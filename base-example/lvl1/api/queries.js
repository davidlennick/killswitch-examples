// set up the db
const Pool = require('pg').Pool
const pool = new Pool({
  user: 'docker',
  host: process.env.DB_ADDR,
  database: 'todo',
  password: 'docker',
  port: process.env.DB_PORT,
})

const testConn = (request, response) => {
  pool.query('SELECT NOW()', (err, res) => {
    if (err) {
      throw err
    }
    console.log(`api to db conn (${process.env.DB_ADDR}:${process.env.DB_PORT}) ok`)
    //pool.end()
  })
}

const getTasks = (request, response) => {
  pool.query('SELECT * FROM tasks ORDER BY id ASC', (err, res) => {
    if (err) {
      throw err
    }
    response.status(200).json(res.rows)
  })
}

const getTaskById = (request, response) => {
  const id = parseInt(request.params.id)

  pool.query('SELECT * FROM tasks WHERE id = $1', [id], (err, res) => {
    if (err) {
      throw err
    }
    response.status(200).json(res.rows)
  })
}

const createTask = (request, response) => {
  const { task, is_complete } = request.body

  pool.query('INSERT INTO tasks (task, is_complete) VALUES ($1, $2)', [task, is_complete], (err, res) => {
    if (err) {
      throw err
    }
    response.status(201).send(`Task added`)
  })
}

const updateTasks = (request, response) => {
  const id = parseInt(request.params.id)
  const { task, is_complete } = request.body

  pool.query(
    'UPDATE tasks SET task = $1, is_complete = $2 WHERE id = $3',
    [task, is_complete, id],
    (err, res) => {
      if (err) {
        throw err
      }
      response.status(200).send(`Task modified with ID: ${id}`)
    }
  )
}

const deleteTask = (request, response) => {
  const id = parseInt(request.params.id)

  pool.query('DELETE FROM tasks WHERE id = $1', [id], (err, ress) => {
    if (err) {
      throw err
    }
    response.status(200).send('Task deleted with ID: ${id}')
  })
}


module.exports = {
  testConn,
  getTasks,
  getTaskById,
  createTask,
  updateTasks,
  deleteTask
}