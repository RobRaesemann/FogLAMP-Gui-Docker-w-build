# FOGLAMP-GUI-DOCKER

This Dockerfile performs a two-stage build of the latest FogLAMP GUI from Github. The first stage performs an optimized production build of the Angular project. The second stage copies the and hosts it in NGINX

The docker-compose.yaml file allows the Dockerfile to be run simply from the command line.

``` 
docker-compose up
```

You may then browse to the FogLAMP GUI console

```
http://localhost or 
http://<<host running the container>> container.
```