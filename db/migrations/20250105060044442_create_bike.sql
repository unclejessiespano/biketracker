-- +micrate Up
CREATE TABLE bikes (
  id INTEGER NOT NULL PRIMARY KEY,
  bike_id INTEGER,
  name VARCHAR,
  prices TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);


-- +micrate Down
DROP TABLE IF EXISTS bikes;
