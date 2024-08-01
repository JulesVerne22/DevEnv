docker volume create toolbox-home-jjsmith
docker run --detach --network host --name toolbox --mount source=toolbox-home-jjsmith,target=/home/jusmith test:latest
