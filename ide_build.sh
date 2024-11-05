cp ~/.Xauthority .
docker build -t my-dev-env .
docker stop orimintz-ide 
docker rm orimintz-ide 
docker run -it  -v ~/git:/workspace   -v ~/.ssh:/home/orimintz/.ssh:ro  --volume /tmp/.X11-unix:/tmp/.X11-unix  -e DISPLAY=$DISPLAY  -d --name orimintz-ide  --network host  my-dev-env
