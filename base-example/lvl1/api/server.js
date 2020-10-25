#!/usr/bin/env node

const express = require('express')
const bodyParser = require('body-parser')
const app = express()

const db = require('./queries')

// setup
app.use(bodyParser.json())
app.use(
  bodyParser.urlencoded({
    extended: true,
  })
)

app.get('/', (request, response) => {
  response.json({ info: 'Node.js, Express, and Postgres API' })
})

app.get('/tasks', db.getTasks)
app.get('/task/:id', db.getTaskById)
app.post('/task', db.createTask)
app.put('/task/:id', db.updateTasks)
app.delete('/task/:id', db.deleteTask)

setInterval(db.testConn, 1000)

app.listen(process.env.API_PORT, () => {
  console.log(`api running on port ${process.env.API_PORT}.`)
  db.testConn()   
})
