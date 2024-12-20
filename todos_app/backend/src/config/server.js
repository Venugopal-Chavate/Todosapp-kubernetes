const port = process.env.API_PORT || 3001;

const bodyParser = require('body-parser');
const express = require('express');

const server = express();
const allowCors = require('./cors');

server.use(bodyParser.urlencoded({ extended: true }));
server.use(bodyParser.json());
server.use(allowCors);
server.listen(port, () => {
  console.log(`BACKEND is running on port ${port}`);
});

module.exports = server;
