# The builder from node image
FROM node:latest as builder

# build-time variables 
# prod|sandbox its value will be come from outside 
ARG env=prod

RUN apt-get update && apt-get upgrade -y --no-install-recommends\ 
    && apt-get install -y git

RUN mkdir /usr/src/app
WORKDIR /usr/src/app
RUN git clone https://github.com/foglamp/foglamp-gui.git \
    && cd foglamp-gui \
    && git checkout v1.5.2 \
    # Move our files into directory name "app"
    && cp /usr/src/app/foglamp-gui/package*.json /usr/src/app/ \
    && npm install @angular/cli@latest -g \
    && npm install yarn -g \
    && yarn install

RUN mv foglamp-gui/* /usr/src/app

# Build with $env variable from outside
# RUN yarn upgrade 
RUN ./build

# Build a small nginx image with static website
FROM nginx:alpine

RUN rm -rf /usr/share/nginx/html/*
COPY nginx.conf /etc/nginx/nginx.conf
COPY --from=builder /usr/src/app/dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
