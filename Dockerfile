FROM node:18-alpine
LABEL maintainer="greenmaryann57@gmail.com"
WORKDIR /app
COPY package.json /app/
RUN npm install
COPY . /app/
ENV NODE_OPTIONS=--openssl-legacy-provider
ENV CI=false
RUN npm run build
EXPOSE 3000
CMD ["npm", "start"]