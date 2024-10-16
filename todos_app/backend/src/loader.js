const server = require('./config/server');
require('./config/database');
// chamada do método que foi exortado no routes.js
require('./config/routes')(server);
