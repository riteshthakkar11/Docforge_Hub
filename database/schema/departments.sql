-- Departments

CREATE TABLE departments(
id SERIAL PRIMARY KEY,
name VARCHAR(50) UNIQUE NOT NULL,
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO departments (name) VALUES
('HR'),
('Finance'),
('Engineering'),
('IT Security'),
('Sales'),
('Marketing'),
('Customer Support'),
('Legal'),
('Operations'),
('Product');

SELECT * FROM departments;

ALTER SEQUENCE departments_id_seq RESTART WITH 1;
ALTER SEQUENCE document_types_id_seq RESTART WITH 1;
ALTER SEQUENCE document_templates_id_seq RESTART WITH 1;
ALTER SEQUENCE template_sections_id_seq RESTART WITH 1;
ALTER SEQUENCE template_questions_id_seq RESTART WITH 1;
ALTER SEQUENCE company_context_id_seq RESTART WITH 1;
ALTER SEQUENCE document_sections_id_seq RESTART WITH 1;
