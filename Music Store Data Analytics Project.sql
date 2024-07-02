SHOW VARIABLES LIKE 'secure_file_priv';

CREATE TABLE album (
    album_id INT,
    artist VARCHAR(100),
    artist_id INT
);

CREATE TABLE artist (
    artist_id INT,
    name VARCHAR(100)
);

CREATE TABLE customer (
    customer_id INT,
    first_name VARCHAR(20),
    last_name VARCHAR(20),
    company VARCHAR(50),
    address VARCHAR(100),
    city VARCHAR(50),
    state VARCHAR(10),
    country VARCHAR(20),
    postal_code VARCHAR(50),
    phone VARCHAR(50),
    fax VARCHAR(50),
    email VARCHAR(100),
    support_rep_id INT
);

CREATE TABLE employee (
    employee_id INT,
    last_name VARCHAR(20),
    first_name VARCHAR(20),
    title VARCHAR(40),
    reports_to INT NULL,
    levels VARCHAR(5),
    birthdate DATE,
    hire_date DATE,
    address VARCHAR(50),
    city VARCHAR(40),
    state VARCHAR(2),
    country VARCHAR(10),
    postal_code VARCHAR(30),
    phone VARCHAR(30),
    fax VARCHAR(30),
    email VARCHAR(100)
);

CREATE TABLE genre (
    genre_id INT,
    name VARCHAR(30)
);

CREATE TABLE invoice (
    invoice_id INT,
    customer_id INT,
    invoice_date DATE,
    billing_address VARCHAR(30),
    billing_city VARCHAR(20),
    billing_state VARCHAR(10),
    billing_country VARCHAR(20),
    billing_postal_code VARCHAR(20),
    total float(4 , 2)
);

CREATE TABLE invoice_line (
    invoice_line_id INT,
    invoice_id INT,
    track_id INT,
    unit_price INT,
    quantity INT
);

CREATE TABLE media_type (
    media_type_id INT,
    name VARCHAR(40)
);

CREATE TABLE playlist (
    playlist_id INT,
    name VARCHAR(50)
);

CREATE TABLE playlist_track (
    playlist_id INT,
    track_id INT
);

CREATE TABLE track (
    track_id INT,
    name VARCHAR(40),
    album_id INT,
    media_type_id INT,
    genre_id INT,
    composer VARCHAR(80) NULL,
    milliseconds INT,
    bytes INT,
    unit_price FLOAT8
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/employee.csv'
INTO TABLE employee
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

ALTER TABLE album
ADD PRIMARY KEY (album_id);

ALTER TABLE artist
ADD PRIMARY KEY (artist_id);

ALTER TABLE customer
ADD PRIMARY KEY (customer_id);

ALTER TABLE genre
ADD PRIMARY KEY (genre_id);

ALTER TABLE invoice
ADD PRIMARY KEY (invoice_id);

ALTER TABLE invoice_line
ADD PRIMARY KEY (invoice_line_id);

ALTER TABLE media_type
ADD PRIMARY KEY (media_type_id);

ALTER TABLE playlist
ADD PRIMARY KEY (playlist_id);

ALTER TABLE playlist_track
ADD PRIMARY KEY (playlist_id , track_id);

ALTER TABLE track
ADD PRIMARY KEY (track_id);