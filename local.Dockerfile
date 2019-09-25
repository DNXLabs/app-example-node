FROM node:10-alpine

WORKDIR /app

RUN npm install nodemon -g

EXPOSE 8080
CMD ["nodemon", "app.js"]
