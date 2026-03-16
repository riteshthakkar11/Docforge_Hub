-- Document_templates

CREATE TABLE document_templates(
id SERIAL PRIMARY KEY,
department_id INT REFERENCES departments(id),
document_type_id INT REFERENCES document_types(id),
name VARCHAR(255) NOT NULL,
industry VARCHAR(255) DEFAULT 'SaaS',
description TEXT,
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

SELECT * FROM document_templates;


INSERT INTO document_templates (department_id, document_type_id, name)
VALUES
(1,1,'Employee Handbook'),
(1,1,'Leave Policy'),
(1,1,'Remote Work Policy'),
(1,2,'Recruitment SOP'),
(1,2,'Employee Onboarding SOP'),
(1,1,'Performance Review Policy'),
(1,2,'Employee Exit Process'),
(1,4,'Training & Development Plan'),
(1,1,'Workplace Harassment Policy'),
(1,1,'Employee Benefits Policy');

INSERT INTO document_templates (department_id, document_type_id, name)
VALUES
(2,1,'Expense Policy'),
(2,4,'Budget Planning'),
(2,1,'Procurement Policy'),
(2,2,'Financial Reporting SOP'),
(2,5,'Audit Report'),
(2,1,'Cost Control Policy'),
(2,2,'Invoice Processing SOP'),
(2,2,'Tax Compliance SOP'),
(2,5,'Financial Risk Assessment'),
(2,2,'Vendor Payment Process');


INSERT INTO document_templates (department_id, document_type_id, name)
VALUES
(3,3,'Coding Standards'),
(3,3,'Architecture Design Document'),
(3,2,'Deployment SOP'),
(3,5,'Incident Report'),
(3,3,'Code Review Guidelines'),
(3,3,'API Documentation'),
(3,4,'Technical Proposal'),
(3,3,'System Design Document'),
(3,2,'Bug Handling SOP'),
(3,2,'Release Management SOP');


INSERT INTO document_templates (department_id, document_type_id, name)
VALUES
(4,1,'Information Security Policy'),
(4,1,'Access Management Policy'),
(4,2,'Backup SOP'),
(4,4,'Disaster Recovery Plan'),
(4,2,'Security Incident Response SOP'),
(4,1,'Password Policy'),
(4,3,'Network Security Guidelines'),
(4,1,'Encryption Policy'),
(4,1,'Device Usage Policy'),
(4,2,'Vulnerability Management SOP');


INSERT INTO document_templates (department_id, document_type_id, name)
VALUES
(5,4,'Sales Proposal'),
(5,1,'Pricing Policy'),
(5,3,'Partnership Agreement'),
(5,2,'Client Onboarding SOP'),
(5,4,'Sales Strategy'),
(5,2,'Lead Qualification Process'),
(5,5,'Sales Forecast Report'),
(5,3,'Contract Template'),
(5,4,'Customer Proposal'),
(5,5,'Sales Performance Report');


INSERT INTO document_templates (department_id, document_type_id, name)
VALUES
(6,4,'Marketing Strategy'),
(6,4,'Campaign Plan'),
(6,3,'Brand Guidelines'),
(6,1,'Social Media Policy'),
(6,4,'Content Marketing Plan'),
(6,4,'Product Launch Plan'),
(6,5,'Market Research Report'),
(6,3,'Customer Persona Document'),
(6,4,'SEO Strategy'),
(6,4,'Marketing Budget Plan');


INSERT INTO document_templates (department_id, document_type_id, name)
VALUES
(7,2,'Support SOP'),
(7,2,'Ticket Handling Process'),
(7,1,'Escalation Policy'),
(7,3,'Customer FAQ'),
(7,2,'Customer Feedback Process'),
(7,3,'Service Level Agreement'),
(7,2,'Complaint Handling SOP'),
(7,3,'Agent Training Guide'),
(7,3,'Communication Guidelines'),
(7,3,'Knowledge Base Template');


INSERT INTO document_templates (department_id, document_type_id, name)
VALUES
(8,3,'NDA'),
(8,3,'Data Protection Agreement'),
(8,3,'Terms of Service'),
(8,1,'Privacy Policy'),
(8,1,'Compliance Policy'),
(8,2,'Contract Review SOP'),
(8,5,'Legal Risk Assessment'),
(8,1,'Intellectual Property Policy'),
(8,3,'Vendor Agreement'),
(8,3,'Compliance Audit Checklist');


INSERT INTO document_templates (department_id, document_type_id, name)
VALUES
(9,2,'Operations SOP'),
(9,1,'Vendor Management Policy'),
(9,2,'Service Delivery Process'),
(9,3,'Internal Process Documentation'),
(9,2,'Quality Assurance SOP'),
(9,5,'Operational Risk Management'),
(9,4,'Resource Allocation Plan'),
(9,3,'Process Improvement Guide'),
(9,2,'Incident Management SOP'),
(9,5,'Operations Performance Report');


INSERT INTO document_templates (department_id, document_type_id, name)
VALUES
(10,3,'Product Requirement Documents'),
(10,4,'Feature Proposal'),
(10,4,'Product Roadmap'),
(10,4,'Product Strategy'),
(10,3,'User Story Documentation'),
(10,4,'Release Plan'),
(10,3,'Feature Prioritization Guidelines'),
(10,5,'Product Feedback Analysis'),
(10,5,'Competitive Analysis'),
(10,3,'Product Vision Document')


SELECT COUNT(*) FROM document_templates;

SELECT id, name 
FROM document_templates
WHERE department_id = 9;

