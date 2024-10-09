FROM node:10-alpine

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install

COPY . .

EXPOSE 3001

# Add a health check endpoint to your server.js file
RUN echo "app.get('/health', (req, res) => res.status(200).send('OK'));" >> server.js

CMD ["node", "server.js"]