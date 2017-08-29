#!/bin/bash

# make a tag from specific repo branch or tag
TAG=$BUILD_NUMBER
IMAGE_NAME=node-web-app
CONTAINER_NAME=node-web-app-$TAG
NODE_VERSION=${1:-8}

# make a docker contatiner from node:$NODE_VERSION
cat > Dockerfile <<-EOF
FROM node:$NODE_VERSION
# Create app directory
WORKDIR /usr/src/app
# Install app dependencies
COPY package.json .
# For npm@5 or later, copy package-lock.json as well
# COPY package.json package-lock.json ./
RUN npm install
# Bundle app source
COPY . .
EXPOSE 8080
CMD [ "npm", "start" ]
EOF
docker build -t dmitrievav/$IMAGE_NAME:$TAG-node-$NODE_VERSION .

# upload target artifacts to some registry
#docker login -u $dockerhub_user -p $dockerhub_pass -e dm-alexey@ya.ru
docker push dmitrievav/$IMAGE_NAME:$TAG-node-$NODE_VERSION

