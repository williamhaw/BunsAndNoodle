# All CHECK constraints are parsed but IGNORED in mySQL.
# CHECK constraints are still written for portability of code.
# Workaround is to utilize triggers on insert/update to enforce check constraints - see Triggers.sql

CREATE DATABASE b_and_n_book_store;

USE b_and_n_book_store;

CREATE TABLE manager (
	admin_login VARCHAR(64) PRIMARY KEY,
	admin_password CHAR(64) NOT NULL
);

CREATE TABLE book (
	title VARCHAR(256) NOT NULL,
	format CHAR(9) CHECK(format='paperback' OR format='hardcover'), 
	pages INT UNSIGNED,
	language VARCHAR(32),
	authors VARCHAR(256),
	publisher VARCHAR(64),
	year YEAR,
	isbn13 CHAR(14) PRIMARY KEY, 
	keywords VARCHAR(256),
	subject VARCHAR(64), 
	copies INT UNSIGNED DEFAULT 1 NOT NULL,
	price DECIMAL(6,2) DEFAULT 50 NOT NULL CHECK(price>='0')
);

CREATE TABLE customer (
	name VARCHAR(256) NOT NULL,
	login VARCHAR(64) PRIMARY KEY,
	pw CHAR(64) NOT NULL, 
	credit_card CHAR(16) NOT NULL,
	phone CHAR(8) NOT NULL,
	address VARCHAR(256) NOT NULL
);

CREATE TABLE orders (
	order_date DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL, #'YYYY-MM-DD HH:MM:SS'
	order_status CHAR(12) DEFAULT 'processing' NOT NULL CHECK(order_status='processing' OR order_status='shipped'),
	order_isbn13 CHAR(14) NOT NULL,
	order_copies INT UNSIGNED NOT NULL CHECK(order_copies<>'0'),
	order_customer VARCHAR(64) NOT NULL,
	PRIMARY KEY (order_date, order_isbn13, order_customer),
	# ON UPDATE CASCADE not specified because we don't want to support changes to existing isbn13 or customer login
	FOREIGN KEY (order_isbn13) REFERENCES book(isbn13) ON DELETE CASCADE, 
	FOREIGN KEY (order_customer) REFERENCES customer(login) ON DELETE CASCADE
);

CREATE TABLE gives_feedback (
	feedback_isbn13 CHAR(14) NOT NULL,
	feedback_customer VARCHAR(64) NOT NULL,
	feedback_date DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
	feedback_score INT UNSIGNED NOT NULL CHECK(gives_feedback_score <= 10),
	feedback_text TEXT, # optional
	PRIMARY KEY (feedback_isbn13, feedback_customer), # 1 feedback per customer per book
	FOREIGN KEY (feedback_isbn13) REFERENCES book(isbn13) ON DELETE CASCADE, 
	FOREIGN KEY (feedback_customer) REFERENCES customer(login) ON DELETE CASCADE # any registered user can give feedback 
);

CREATE TABLE rates_feedback (
	rater VARCHAR(64) NOT NULL,
	ratee VARCHAR(64) NOT NULL,
	ratee_feedback_isbn13 CHAR(14) NOT NULL,
	rating INT UNSIGNED NOT NULL CHECK(rates_feedback_score <= 2),
	PRIMARY KEY (rater, ratee, ratee_feedback_isbn13),
	FOREIGN KEY (rater) REFERENCES customer(login) ON DELETE CASCADE,
	FOREIGN KEY (ratee, ratee_feedback_isbn13) 
		REFERENCES gives_feedback(feedback_customer, feedback_isbn13) ON DELETE CASCADE, # ratee and ratee's feedback on must be paired together (obviously)
	CHECK(ratee <> rater)
);