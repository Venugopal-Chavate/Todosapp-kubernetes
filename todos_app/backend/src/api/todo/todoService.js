const Todo = require('./todo');

Todo.methods(['get', 'post', 'put', 'delete']);
Todo.updateOptions({
  // força retornar o novo registro (que foi atulizado)
  // no caso de update
  new: true,
  // força a efetuar as operações de validação
  // em caso de update
  runValidators: true,
});

module.exports = Todo;
