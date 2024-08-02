# DevEnv

A containerized development environment for neovim based development. Offers a
more portable version of the environment instead of installing every dependency
every time.

## Build Steps

Run the following command to build the docker image:

```docker build -t julesverne22/dev-env .```

Push to repository using:

```docker push julesverne22/dev-env```

## Run Steps

To use the container, run the following commands:

```docker run -it --rm --detach --network host --name toolbox --mount type=bind,src=.,dst=/home/jjsmith/mnt -e TERM julesverne22/dev-env:latest /bin/bash```

```docker exec -it toolbox tmux```
