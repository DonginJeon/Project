CREATE DATABASE irt_cat_db;

USE irt_cat_db;

CREATE TABLE pre_info (
    student_id INT PRIMARY KEY,
    initial_theta FLOAT
);

CREATE TABLE question_bank (
    question_id SERIAL PRIMARY KEY,
    difficulty FLOAT,
    discrimination FLOAT,
    guessing FLOAT
);

DROP TABLE student_responses;

--- ALTER DATABASE irt_cat_db CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci;


CREATE TABLE student_responses (
    response_id SERIAL PRIMARY KEY,
    student_id INT,
    question_id INT,
    response INT
);

CREATE TABLE student_theta (
    student_id INT PRIMARY KEY,
    theta_value FLOAT
);


SELECT  * FROM pre_info;


--- 
INSERT INTO pre_info (student_id, initial_theta) VALUES
(1, 0.0),
(2, 0.0),
(3, 0.0);

INSERT INTO question_bank (question_id, difficulty, discrimination, guessing) VALUES
(1, 0.5, 1.2, 0.2),
(2, 0.4, 1.0, 0.2),
(3, 0.6, 1.3, 0.2),
(4, 0.7, 1.1, 0.2),
(5, 0.8, 1.2, 0.2),
(6, 0.45, 1.1, 0.2),
(7, 0.5, 1.0, 0.2),
(8, 0.75, 1.2, 0.2),
(9, 0.6, 1.0, 0.2),
(10, 0.55, 1.1, 0.2),
(11, 0.6, 1.2, 0.2),
(12, 0.65, 1.1, 0.2),
(13, 0.7, 1.0, 0.2),
(14, 0.8, 1.2, 0.2),
(15, 0.75, 1.1, 0.2);

INSERT INTO student_responses (student_id, question_id, response) VALUES
(1, 1, 1), (1, 2, 1), (1, 3, 0), (1, 4, 1), (1, 5, 1),
(1, 6, 0), (1, 7, 1), (1, 8, 0), (1, 9, 1), (1, 10, 1),
(1, 11, 0), (1, 12, 1), (1, 13, 0), (1, 14, 1), (1, 15, 1),

(2, 1, 0), (2, 2, 1), (2, 3, 1), (2, 4, 0), (2, 5, 1),
(2, 6, 1), (2, 7, 0), (2, 8, 1), (2, 9, 0), (2, 10, 1),
(2, 11, 1), (2, 12, 0), (2, 13, 1), (2, 14, 0), (2, 15, 1),

(3, 1, 1), (3, 2, 0), (3, 3, 1), (3, 4, 1), (3, 5, 0),
(3, 6, 1), (3, 7, 1), (3, 8, 0), (3, 9, 1), (3, 10, 0),
(3, 11, 1), (3, 12, 1), (3, 13, 0), (3, 14, 1), (3, 15, 1);

