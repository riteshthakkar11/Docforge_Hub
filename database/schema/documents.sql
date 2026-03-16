-- Documents
CREATE TABLE documents(
id UUID PRIMARY KEY,
template_id INT REFERENCES document_templates(id) ON DELETE CASCADE,
title VARCHAR(255) NOT NULL,
version VARCHAR(255) DEFAULT 'v1.0',
created_by VARCHAR(255),
status VARCHAR(50) DEFAULT 'draft',
tags TEXT[],
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE documents ADD COLUMN company_id INT REFERENCES company_context(id);

SELECT * FROM documents;

DELETE FROM documents;


