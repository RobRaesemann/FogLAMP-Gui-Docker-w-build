# The builder from node image
# FROM node:10.16.3-jessie as builder
FROM node:10 as builder

# build-time variables 
# prod|sandbox its value will be come from outside 
ARG env=prod

RUN apt-get update && apt-get upgrade -y --no-install-recommends && \ 
    apt-get install -y git

RUN git clone https://github.com/foglamp/foglamp-gui.git && \
    cd foglamp-gui && \
    git checkout v1.6.0 && \
    yarn install --network-timeout 5000000  && \
    ./build

# Build a small nginx image with static website
FROM nginx:alpine

RUN rm -rf /usr/share/nginx/html/*
COPY nginx.conf /etc/nginx/nginx.conf
COPY --from=builder /foglamp-gui/dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

LABEL maintainer="rob@raesemann.com" \
      author="Rob Raesemann" \
      target="Linux" \
      version="1.6.0" \