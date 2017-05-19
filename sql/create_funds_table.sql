create table funds (
  id SERIAL PRIMARY KEY,
  name REAL,
  amount decimal,
  inserted_at timestamp without time zone,
  updated_at timestamp without time zone
);
