CREATE TABLE articles (

  id SERIAL PRIMARY KEY,
  title_name VARCHAR(1000) NOT NULL,
  url_name VARCHAR(1000) NOT NULL,
  desc_name VARCHAR(1000) NOT NULL,
  created_at TIMESTAMP NOT NULL

  );


CREATE TABLE comments (

  id SERIAL PRIMARY KEY,
  article_id Integer REFERENCES articles(id),
  author_name VARCHAR(1000) NOT NULL,
  comment VARCHAR(1000) NOT NULL,
  created_at TIMESTAMP NOT NULL

  );
