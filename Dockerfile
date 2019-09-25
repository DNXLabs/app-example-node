FROM node:10-alpine

WORKDIR /app
ENV NODE_ENV=production
COPY . .
RUN npm config set depth 0 \
    && npm install

EXPOSE 8080
CMD ["node", "app.js"]
