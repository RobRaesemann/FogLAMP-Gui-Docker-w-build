FROM node:latest as builder

RUN git clone https://github.com/foglamp/foglamp-gui.git /foglamp-gui

WORKDIR /foglamp-gui
RUN yarn upgrade
RUN yarn install

RUN ng build --prod


FROM nginx

## Copy our default nginx config
COPY --from=builder /foglamp-gui/nginx.conf /etc/nginx/conf.d/

## Remove default nginx website
RUN rm -rf /usr/share/nginx/html/*

## From ‘builder’ stage copy over the artifacts in dist folder to default nginx public folder
COPY --from=builder /foglamp-gui/dist /usr/share/nginx/html

CMD ["nginx", "-g", "daemon off;"]