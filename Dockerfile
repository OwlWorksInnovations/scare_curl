FROM node:18-alpine

RUN apk add --no-cache bash

WORKDIR /app

COPY package*.json ./
RUN npm install --omit=dev

COPY server.js scare.sh ./
RUN chmod +x scare.sh

EXPOSE 3000

CMD ["node", "server.js"]
