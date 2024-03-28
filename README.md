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

```docker run -v "$(pwd)"/dev-env:/dev-env --name dev-env -id --rm julesverne22/dev-env```

```docker exec -it dev-env /bin/bash```
