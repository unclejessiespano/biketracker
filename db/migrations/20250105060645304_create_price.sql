-- +micrate Up
CREATE TABLE prices (
  id INTEGER NOT NULL PRIMARY KEY,
  bike_id INTEGER,
  price INTEGER,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);


-- +micrate Down
DROP TABLE IF EXISTS prices;
