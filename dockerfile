# Dockerfile for Neovim + C++ Development Environment with LazyVim and Custom Config
FROM ubuntu:latest

# Define variables for user and directories
ARG USERNAME=ariel
ARG UID=1000
ARG GID=1000
ARG WORKDIR=/home/${USERNAME}
ARG NVIM_CONFIG_DIR=/home/${USERNAME}/.config/nvim
ARG CUSTOM_CONFIG_DIR=/home/${USERNAME}/my-nvim-config
ARG NVIM_DATA_DIR=/home/${USERNAME}/.local/share/nvim

# Prioritize essential tools in separate steps for better caching
ENV BASE_TOOLS="build-essential curl git xauth xclip tmux htop sudo"
ENV EDITOR_TOOLS="neovim libncurses5-dev libncursesw5-dev"
ENV PYTHON_TOOLS="python3.8 python3.8-dev python3-venv python3-pip python3-neovim"
ENV DATABASE_TOOLS="postgresql-server-dev-all libpq-dev postgresql-16 postgresql"
ENV SSL_LIBS="libssl-dev"
ENV COMPILER_TOOLS="clangd cmake clang gcc g++ make openjdk-8-jdk"
ENV UTILS_TOOLS="unzip tar ripgrep fd-find doxygen fzf bat gdb"

RUN apt-get update && apt-get install -y software-properties-common
RUN add-apt-repository ppa:neovim-ppa/unstable


# Install base system tools
RUN apt-get update && apt-get install -y $BASE_TOOLS 

# Install editor tools
RUN apt-get install -y $EDITOR_TOOLS 

# Install Python tools
RUN apt-get install -y $PYTHON_TOOLS 

# Install database-related tools
RUN apt-get install -y $DATABASE_TOOLS

# Install SSL libraries
RUN apt-get install -y $SSL_LIBS 

# Install compiler tools (like clangd)
RUN apt-get install -y $COMPILER_TOOLS 


RUN apt-get install -y $UTILS_TOOLS && rm -rf /var/lib/apt/lists/*

# Add Node.js installation to your Dockerfile
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash - \
    && apt-get install -y nodejs

# Create or rename the user and group
RUN if ! getent passwd "${UID}" >/dev/null && ! getent group "${GID}" >/dev/null; then \
        # Create new group and user if UID and GID are not taken
        groupadd -g "${GID}" "${USERNAME}" && \
        useradd -l -u "${UID}" -g "${USERNAME}" -m "${USERNAME}"; \
    else \
        # Handle case where UID or GID already exists
        echo "UID or GID already exists. Renaming existing user/group." && \
        CURRENT_USER=$(getent passwd "${UID}" | cut -d: -f1) && \
        CURRENT_GROUP=$(getent group "${GID}" | cut -d: -f1) && \
        if [ "${CURRENT_USER}" != "${USERNAME}" ]; then \
            usermod -l "${USERNAME}" "${CURRENT_USER}"; \
        fi && \
        if [ "${CURRENT_GROUP}" != "${USERNAME}" ]; then \
            groupmod -n "${USERNAME}" "${CURRENT_GROUP}"; \
        fi && \
        usermod -u "${UID}" -d /home/"${USERNAME}" -m "${USERNAME}" && \
        groupmod -g "${GID}" "${USERNAME}"; \
    fi

# Copy the .Xauthority file from the host to the container (optional)
# You can also generate this dynamically later if required
COPY --chown=$USERNAME:$USERNAME ./.Xauthority /home/$USERNAME/.Xauthority


# Create a symlink for cmake3 pointing to cmake
RUN ln -s /usr/bin/cmake /usr/local/bin/cmake3

RUN ln -s /usr/include/postgresql/16/server/postgres_ext.h /usr/include/postgres_ext.h


# Clone and build GoogleTest from source
RUN git clone https://github.com/google/googletest.git /usr/src/googletest && \
    cd /usr/src/googletest && \
    mkdir build && cd build && \
    cmake .. && \
    make -j$(nproc) && \
    make install

# Clean up to reduce the image size
RUN rm -rf /usr/src/googletest && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Link libraries to standard locations (optional, adjust if needed)
RUN ldconfig

# Optional: ensure /usr/local/bin is in the PATH (usually it is by default)
ENV PATH="/usr/local/bin:$PATH"

# Install Go
ENV GO_VERSION=1.21.1
RUN wget https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz && \
    rm go${GO_VERSION}.linux-amd64.tar.gz

# Set up Go environment
ENV PATH="/usr/local/go/bin:${PATH}"
ENV GOPATH="/go"
ENV PATH="${GOPATH}/bin:${PATH}"

# Create Go workspace
RUN mkdir -p /go/src /go/bin /go/pkg

# Create a non-root user for development
# RUN groupadd --gid $GID $USERNAME && useradd -m --uid $UID --gid $GID -s /bin/bash $USERNAME && \
#    echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER $USERNAME
WORKDIR ${WORKDIR}

# Install LazyVim and sync it without overwriting any personal configuration
RUN git clone https://github.com/LazyVim/starter ${NVIM_CONFIG_DIR}
RUN nvim +Lazy sync +qall

# Clone your custom Neovim configuration to a separate directory
RUN git clone https://github.com/arielkazula/nvim-ide-container.git ${CUSTOM_CONFIG_DIR}


# Ensure the lua directory exists
RUN mkdir -p ${NVIM_CONFIG_DIR}/lua


# Link your custom config files to LazyVim's expected directories
RUN ln -s ${CUSTOM_CONFIG_DIR}/lua ${NVIM_CONFIG_DIR}/lua/custom


# Append to LazyVim's init.lua to import your custom init.lua from the custom folder
RUN echo 'require("custom.init")' >> ${NVIM_CONFIG_DIR}/init.lua


# Install Python packages for Neovim globally without sudo
RUN python3 -m pip install --break-system-packages pynvim neovim

# Set ownership of the ~/.config/nvim directory to your user 
RUN chown -R ${USERNAME}:${USERNAME} ${NVIM_CONFIG_DIR} ${NVIM_DATA_DIR} 

# Default working directory
WORKDIR /workspace

ENTRYPOINT ["tail", "-f", "/dev/null"]
