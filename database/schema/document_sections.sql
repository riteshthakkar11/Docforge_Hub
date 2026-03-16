-- Document_sections 
CREATE TABLE document_sections (
id SERIAL PRIMARY KEY,
document_id UUID REFERENCES documents(id) ON DELETE CASCADE,
section_title VARCHAR(255) NOT NULL,
section_content TEXT,
section_order INT,
status VARCHAR(50) DEFAULT 'draft',
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELETE FROM document_sections;


