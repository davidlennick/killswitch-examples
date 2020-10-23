
CREATE DATABASE todo;
\connect todo;

CREATE TABLE tasks(
  id SERIAL PRIMARY KEY, 
  task VARCHAR(40) not null, 
  is_complete BOOLEAN
);