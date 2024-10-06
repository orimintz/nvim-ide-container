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
ENV MUST_HAVE_TOOLS="build-essential clangd neovim curl git xclip tmux htop sudo python3.8 python3.8-dev python3-venv  python3-pip python3-neovim"
ENV CMAKE_AND_COMPILERS="cmake gcc g++ make"
ENV PLUGIN_TOOLS="unzip tar ripgrep fd-find doxygen fzf bat gdb"


# Install must-have tools
RUN apt-get update && apt-get install -y $MUST_HAVE_TOOLS && rm -rf /var/lib/apt/lists/*

# Install plugin tools (extra utilities)
RUN apt-get update && apt-get install -y $CMAKE_AND_COMPILERS && rm -rf /var/lib/apt/lists/*
RUN apt-get update && apt-get install -y $PLUGIN_TOOLS  && rm -rf /var/lib/apt/lists/*

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

# LazyVim will automatically load files from lua/custom/init.lua, no need to modify the main init.lua


# Install Python packages for Neovim globally without sudo
RUN python3 -m pip install --break-system-packages pynvim neovim

# Set ownership of the ~/.config/nvim directory to your user 
RUN chown -R ${USERNAME}:${USERNAME} ${NVIM_CONFIG_DIR} ${NVIM_DATA_DIR} 

RUN mkdir -p /home/${USERNAME}/.local/share/nvim && \
    chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}/.local/share/nvim /home/${USERNAME}/.config/nvim


ENTRYPOINT ["tail", "-f", "/dev/null"]
