-- Template_sections

CREATE TABLE template_sections(
id SERIAL PRIMARY KEY,
template_id INT REFERENCES document_templates(id) ON DELETE CASCADE,
section_title VARCHAR(255)NOT NULL,
section_description TEXT,
section_order INT,
required BOOLEAN DEFAULT TRUE
);

-- HR

INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(1,'Overview',1),
(1,'Purpose',2),
(1,'Scope',3),
(1,'Company Values',4),
(1,'Code of Conduct',5),
(1,'Work Hours',6),
(1,'Attendance Rules',7),
(1,'Leave Policy',8),
(1,'Compensation',9),
(1,'Employee Benefits',10),
(1,'Workplace Safety',11),
(1,'Diversity & Inclusion',12),
(1,'Performance Expectations',13),
(1,'Disciplinary Actions',14),
(1,'Acknowledgement',15);


INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(2,'Overview',1),
(2,'Purpose',2),
(2,'Scope',3),
(2,'Eligibility',4),
(2,'Leave Types',5),
(2,'Annual Leave',6),
(2,'Sick Leave',7),
(2,'Emergency Leave',8),
(2,'Maternity Leave',9),
(2,'Paternity Leave',10),
(2,'Leave Request',11),
(2,'Approval Process',12),
(2,'Leave Records',13),
(2,'Policy Exceptions',14),
(2,'Policy Review',15);


INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(3,'Overview',1),
(3,'Purpose',2),
(3,'Scope',3),
(3,'Eligibility',4),
(3,'Remote Work Rules',5),
(3,'Work Hours',6),
(3,'Availability',7),
(3,'Communication',8),
(3,'Equipment Use',9),
(3,'Data Security',10),
(3,'Performance Monitoring',11),
(3,'Expense Policy',12),
(3,'Compliance',13),
(3,'Policy Violations',14),
(3,'Policy Review',15);


INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(4,'Overview',1),
(4,'Purpose',2),
(4,'Scope',3),
(4,'Hiring Needs',4),
(4,'Job Requisition',5),
(4,'Job Posting',6),
(4,'Candidate Sourcing',7),
(4,'Resume Screening',8),
(4,'Interview Process',9),
(4,'Evaluation Criteria',10),
(4,'Selection Decision',11),
(4,'Offer Process',12),
(4,'Background Check',13),
(4,'Recruitment Records',14),
(4,'Process Review',15);


INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(5,'Overview',1),
(5,'Purpose',2),
(5,'Scope',3),
(5,'Pre-Onboarding',4),
(5,'Employee Documents',5),
(5,'Account Setup',6),
(5,'Orientation Plan',7),
(5,'Team Introduction',8),
(5,'Role Overview',9),
(5,'Training Plan',10),
(5,'Compliance Training',11),
(5,'Policy Awareness',12),
(5,'Performance Goals',13),
(5,'Onboarding Feedback',14),
(5,'Process Review',15);



INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(6,'Overview',1),
(6,'Purpose',2),
(6,'Scope',3),
(6,'Review Cycle',4),
(6,'Goal Setting',5),
(6,'KPIs',6),
(6,'Manager Role',7),
(6,'Employee Self Review',8),
(6,'Feedback Process',9),
(6,'Performance Ratings',10),
(6,'Improvement Plan',11),
(6,'Documentation',12),
(6,'Appeal Process',13),
(6,'Confidentiality',14),
(6,'Policy Review',15);


INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(7,'Overview',1),
(7,'Purpose',2),
(7,'Scope',3),
(7,'Exit Types',4),
(7,'Resignation Notice',5),
(7,'Exit Approval',6),
(7,'Exit Interview',7),
(7,'Knowledge Transfer',8),
(7,'Asset Return',9),
(7,'System Access Removal',10),
(7,'Final Settlement',11),
(7,'Documentation',12),
(7,'Compliance Check',13),
(7,'Exit Records',14),
(7,'Process Review',15);



INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(8,'Overview',1),
(8,'Purpose',2),
(8,'Scope',3),
(8,'Learning Goals',4),
(8,'Skill Assessment',5),
(8,'Training Needs',6),
(8,'Training Programs',7),
(8,'Learning Resources',8),
(8,'Training Schedule',9),
(8,'Trainer Roles',10),
(8,'Employee Participation',11),
(8,'Training Evaluation',12),
(8,'Certification',13),
(8,'Learning Records',14),
(8,'Plan Review',15);


INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(9,'Overview',1),
(9,'Purpose',2),
(9,'Scope',3),
(9,'Definitions',4),
(9,'Harassment Types',5),
(9,'Employee Rights',6),
(9,'Reporting Channels',7),
(9,'Complaint Process',8),
(9,'Investigation Steps',9),
(9,'Confidentiality',10),
(9,'Protection Policy',11),
(9,'Disciplinary Actions',12),
(9,'Awareness Training',13),
(9,'Compliance',14),
(9,'Policy Review',15);



INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(10,'Overview',1),
(10,'Purpose',2),
(10,'Scope',3),
(10,'Eligibility',4),
(10,'Benefits Overview',5),
(10,'Health Benefits',6),
(10,'Retirement Plans',7),
(10,'Leave Benefits',8),
(10,'Wellness Programs',9),
(10,'Insurance Coverage',10),
(10,'Enrollment Process',11),
(10,'Claims Process',12),
(10,'Compliance Rules',13),
(10,'Benefit Exceptions',14),
(10,'Policy Review',15);


SELECT * FROM template_sections;



-- Finance

INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(11,'Overview',1),
(11,'Purpose',2),
(11,'Scope',3),
(11,'Eligibility',4),
(11,'Expense Categories',5),
(11,'Travel Expenses',6),
(11,'Office Expenses',7),
(11,'Reimbursement Rules',8),
(11,'Expense Submission',9),
(11,'Approval Workflow',10),
(11,'Expense Limits',11),
(11,'Documentation Requirements',12),
(11,'Compliance Rules',13),
(11,'Fraud Prevention',14),
(11,'Expense Audit',15),
(11,'Policy Exceptions',16),
(11,'Policy Review',17);



INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(12,'Overview',1),
(12,'Purpose',2),
(12,'Scope',3),
(12,'Budget Objectives',4),
(12,'Budget Cycle',5),
(12,'Budget Assumptions',6),
(12,'Revenue Forecast',7),
(12,'Expense Forecast',8),
(12,'Department Budgets',9),
(12,'Capital Budget',10),
(12,'Budget Allocation',11),
(12,'Budget Approval',12),
(12,'Budget Monitoring',13),
(12,'Variance Analysis',14),
(12,'Budget Adjustments',15),
(12,'Financial Controls',16),
(12,'Plan Review',17);


INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(13,'Overview',1),
(13,'Purpose',2),
(13,'Scope',3),
(13,'Procurement Principles',4),
(13,'Vendor Selection',5),
(13,'Procurement Methods',6),
(13,'Tender Process',7),
(13,'Quotation Process',8),
(13,'Purchase Approval',9),
(13,'Contract Management',10),
(13,'Vendor Evaluation',11),
(13,'Procurement Records',12),
(13,'Compliance Rules',13),
(13,'Conflict of Interest',14),
(13,'Risk Management',15),
(13,'Audit Controls',16),
(13,'Policy Review',17);



INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(14,'Overview',1),
(14,'Purpose',2),
(14,'Scope',3),
(14,'Reporting Framework',4),
(14,'Reporting Schedule',5),
(14,'Data Sources',6),
(14,'Accounting Standards',7),
(14,'Financial Statements',8),
(14,'Income Statement',9),
(14,'Balance Sheet',10),
(14,'Cash Flow Statement',11),
(14,'Report Preparation',12),
(14,'Review Process',13),
(14,'Approval Workflow',14),
(14,'Compliance Controls',15),
(14,'Documentation',16),
(14,'Process Review',17);



INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(15,'Overview',1),
(15,'Purpose',2),
(15,'Scope',3),
(15,'Audit Objectives',4),
(15,'Audit Criteria',5),
(15,'Audit Methodology',6),
(15,'Financial Records Review',7),
(15,'Control Assessment',8),
(15,'Risk Analysis',9),
(15,'Findings Summary',10),
(15,'Detailed Findings',11),
(15,'Recommendations',12),
(15,'Management Response',13),
(15,'Compliance Evaluation',14),
(15,'Audit Conclusion',15),
(15,'Follow-up Actions',16),
(15,'Report Approval',17);



INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(16,'Overview',1),
(16,'Purpose',2),
(16,'Scope',3),
(16,'Cost Management Principles',4),
(16,'Budget Controls',5),
(16,'Expense Monitoring',6),
(16,'Cost Reduction Strategies',7),
(16,'Cost Allocation',8),
(16,'Approval Controls',9),
(16,'Cost Reporting',10),
(16,'Variance Tracking',11),
(16,'Risk Management',12),
(16,'Compliance Rules',13),
(16,'Fraud Prevention',14),
(16,'Performance Metrics',15),
(16,'Policy Exceptions',16),
(16,'Policy Review',17);



INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(17,'Overview',1),
(17,'Purpose',2),
(17,'Scope',3),
(17,'Invoice Receipt',4),
(17,'Invoice Verification',5),
(17,'Vendor Validation',6),
(17,'Invoice Recording',7),
(17,'Approval Workflow',8),
(17,'Payment Scheduling',9),
(17,'Payment Processing',10),
(17,'Accounting Entries',11),
(17,'Dispute Handling',12),
(17,'Compliance Controls',13),
(17,'Fraud Prevention',14),
(17,'Process Review',15);


INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(18,'Overview',1),
(18,'Purpose',2),
(18,'Scope',3),
(18,'Tax Regulations',4),
(18,'Tax Categories',5),
(18,'Tax Calculation',6),
(18,'Tax Reporting',7),
(18,'Tax Filing',8),
(18,'Payment Process',9),
(18,'Compliance Monitoring',10),
(18,'Audit Support',11),
(18,'Documentation',12),
(18,'Penalty Handling',13),
(18,'Risk Management',14),
(18,'Process Review',15);



INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(19,'Overview',1),
(19,'Purpose',2),
(19,'Scope',3),
(19,'Risk Identification',4),
(19,'Risk Categories',5),
(19,'Financial Exposure',6),
(19,'Risk Analysis',7),
(19,'Risk Scoring',8),
(19,'Risk Mitigation',9),
(19,'Control Measures',10),
(19,'Monitoring Process',11),
(19,'Reporting Framework',12),
(19,'Compliance Checks',13),
(19,'Risk Documentation',14),
(19,'Risk Review',15);



INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(20,'Overview',1),
(20,'Purpose',2),
(20,'Scope',3),
(20,'Vendor Verification',4),
(20,'Payment Terms',5),
(20,'Invoice Matching',6),
(20,'Payment Approval',7),
(20,'Payment Methods',8),
(20,'Payment Scheduling',9),
(20,'Bank Processing',10),
(20,'Accounting Entries',11),
(20,'Payment Records',12),
(20,'Compliance Checks',13),
(20,'Audit Trail',14),
(20,'Process Review',15);



-- Engineering

INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(21,'Overview',1),
(21,'Purpose',2),
(21,'Scope',3),
(21,'Coding Principles',4),
(21,'Naming Conventions',5),
(21,'Code Structure',6),
(21,'Documentation Standards',7),
(21,'Error Handling',8),
(21,'Logging Practices',9),
(21,'Security Practices',10),
(21,'Code Review Process',11),
(21,'Testing Guidelines',12),
(21,'Version Control Rules',13),
(21,'Performance Guidelines',14),
(21,'Standards Review',15);



INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(22,'Overview',1),
(22,'Purpose',2),
(22,'Scope',3),
(22,'System Overview',4),
(22,'Architecture Principles',5),
(22,'System Components',6),
(22,'Data Flow',7),
(22,'Database Design',8),
(22,'API Architecture',9),
(22,'Security Architecture',10),
(22,'Scalability Design',11),
(22,'Performance Considerations',12),
(22,'Deployment Architecture',13),
(22,'Monitoring Strategy',14),
(22,'Architecture Review',15);



INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(23,'Overview',1),
(23,'Purpose',2),
(23,'Scope',3),
(23,'Deployment Environment',4),
(23,'Prerequisites',5),
(23,'Deployment Tools',6),
(23,'Deployment Steps',7),
(23,'Configuration Setup',8),
(23,'Database Migration',9),
(23,'Verification Process',10),
(23,'Rollback Procedure',11),
(23,'Security Checks',12),
(23,'Logging Setup',13),
(23,'Monitoring Setup',14),
(23,'Process Review',15);



INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(24,'Overview',1),
(24,'Purpose',2),
(24,'Scope',3),
(24,'Incident Summary',4),
(24,'Incident Timeline',5),
(24,'Root Cause',6),
(24,'Impact Analysis',7),
(24,'Detection Method',8),
(24,'Response Actions',9),
(24,'Resolution Steps',10),
(24,'System Recovery',11),
(24,'Lessons Learned',12),
(24,'Preventive Measures',13),
(24,'Documentation',14),
(24,'Report Approval',15);



INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(25,'Overview',1),
(25,'Purpose',2),
(25,'Scope',3),
(25,'Review Principles',4),
(25,'Review Workflow',5),
(25,'Reviewer Responsibilities',6),
(25,'Author Responsibilities',7),
(25,'Code Quality Checks',8),
(25,'Security Review',9),
(25,'Performance Review',10),
(25,'Testing Review',11),
(25,'Documentation Review',12),
(25,'Approval Criteria',13),
(25,'Merge Guidelines',14),
(25,'Guidelines Review',15);



INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(26,'Overview',1),
(26,'Purpose',2),
(26,'Scope',3),
(26,'API Architecture',4),
(26,'Authentication',5),
(26,'API Endpoints',6),
(26,'Request Format',7),
(26,'Response Format',8),
(26,'Error Codes',9),
(26,'Rate Limits',10),
(26,'Security Practices',11),
(26,'Usage Examples',12),
(26,'Integration Guidelines',13),
(26,'Testing Procedures',14),
(26,'Documentation Updates',15);



INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(27,'Overview',1),
(27,'Purpose',2),
(27,'Scope',3),
(27,'Problem Statement',4),
(27,'Proposed Solution',5),
(27,'Technical Approach',6),
(27,'Architecture Design',7),
(27,'Technology Stack',8),
(27,'Implementation Plan',9),
(27,'Resource Requirements',10),
(27,'Risk Assessment',11),
(27,'Cost Estimation',12),
(27,'Timeline',13),
(27,'Expected Outcomes',14),
(27,'Proposal Review',15);



INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(28,'Overview',1),
(28,'Purpose',2),
(28,'Scope',3),
(28,'System Overview',4),
(28,'Functional Requirements',5),
(28,'Non Functional Requirements',6),
(28,'Architecture Design',7),
(28,'Data Model',8),
(28,'API Interfaces',9),
(28,'Security Design',10),
(28,'Scalability Strategy',11),
(28,'Performance Strategy',12),
(28,'Deployment Strategy',13),
(28,'Monitoring Strategy',14),
(28,'Design Review',15);



INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(29,'Overview',1),
(29,'Purpose',2),
(29,'Scope',3),
(29,'Bug Identification',4),
(29,'Bug Reporting',5),
(29,'Bug Classification',6),
(29,'Bug Prioritization',7),
(29,'Assignment Process',8),
(29,'Debugging Steps',9),
(29,'Fix Implementation',10),
(29,'Testing Verification',11),
(29,'Deployment Process',12),
(29,'Documentation',13),
(29,'Monitoring',14),
(29,'Process Review',15);



INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(30,'Overview',1),
(30,'Purpose',2),
(30,'Scope',3),
(30,'Release Planning',4),
(30,'Release Strategy',5),
(30,'Version Control',6),
(30,'Build Process',7),
(30,'Testing Process',8),
(30,'Release Approval',9),
(30,'Deployment Steps',10),
(30,'Rollback Plan',11),
(30,'Release Notes',12),
(30,'Monitoring',13),
(30,'Post Release Review',14),
(30,'Process Improvement',15);



-- IT Security

INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(31,'Overview',1),
(31,'Purpose',2),
(31,'Scope',3),
(31,'Security Objectives',4),
(31,'Security Governance',5),
(31,'Roles and Responsibilities',6),
(31,'Asset Classification',7),
(31,'Access Control',8),
(31,'Data Protection',9),
(31,'Network Security',10),
(31,'Incident Management',11),
(31,'Risk Management',12),
(31,'Compliance Requirements',13),
(31,'Monitoring and Auditing',14),
(31,'Policy Exceptions',15),
(31,'Policy Review',16);


INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(32,'Overview',1),
(32,'Purpose',2),
(32,'Scope',3),
(32,'Access Principles',4),
(32,'User Access Request',5),
(32,'Access Approval Process',6),
(32,'Role Based Access Control',7),
(32,'Privileged Access',8),
(32,'Access Provisioning',9),
(32,'Access Monitoring',10),
(32,'Access Revocation',11),
(32,'Authentication Methods',12),
(32,'Audit Logging',13),
(32,'Compliance Controls',14),
(32,'Policy Exceptions',15),
(32,'Policy Review',16);



INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(33,'Overview',1),
(33,'Purpose',2),
(33,'Scope',3),
(33,'Backup Objectives',4),
(33,'Backup Types',5),
(33,'Backup Schedule',6),
(33,'Backup Storage',7),
(33,'Backup Tools',8),
(33,'Data Retention',9),
(33,'Backup Verification',10),
(33,'Recovery Process',11),
(33,'Security Controls',12),
(33,'Backup Monitoring',13),
(33,'Incident Handling',14),
(33,'Documentation',15),
(33,'Process Review',16);



INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(34,'Overview',1),
(34,'Purpose',2),
(34,'Scope',3),
(34,'Recovery Objectives',4),
(34,'Disaster Scenarios',5),
(34,'Business Impact Analysis',6),
(34,'Recovery Strategy',7),
(34,'Recovery Infrastructure',8),
(34,'Recovery Procedures',9),
(34,'Data Restoration',10),
(34,'Communication Plan',11),
(34,'Testing Procedures',12),
(34,'Roles and Responsibilities',13),
(34,'Compliance Requirements',14),
(34,'Documentation',15),
(34,'Plan Review',16);



INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(35,'Overview',1),
(35,'Purpose',2),
(35,'Scope',3),
(35,'Incident Definition',4),
(35,'Incident Detection',5),
(35,'Incident Classification',6),
(35,'Incident Reporting',7),
(35,'Incident Analysis',8),
(35,'Containment Strategy',9),
(35,'Incident Resolution',10),
(35,'System Recovery',11),
(35,'Root Cause Analysis',12),
(35,'Lessons Learned',13),
(35,'Documentation',14),
(35,'Compliance Reporting',15),
(35,'Process Review',16);



INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(36,'Overview',1),
(36,'Purpose',2),
(36,'Scope',3),
(36,'Password Requirements',4),
(36,'Password Complexity',5),
(36,'Password Expiry',6),
(36,'Password Storage',7),
(36,'Multi Factor Authentication',8),
(36,'Password Reset Process',9),
(36,'Account Lockout Rules',10),
(36,'User Responsibilities',11),
(36,'Security Controls',12),
(36,'Monitoring',13),
(36,'Compliance Requirements',14),
(36,'Policy Exceptions',15),
(36,'Policy Review',16);



INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(37,'Overview',1),
(37,'Purpose',2),
(37,'Scope',3),
(37,'Network Architecture',4),
(37,'Firewall Configuration',5),
(37,'Intrusion Detection',6),
(37,'Network Access Control',7),
(37,'VPN Security',8),
(37,'Monitoring and Logging',9),
(37,'Threat Detection',10),
(37,'Incident Handling',11),
(37,'Compliance Controls',12),
(37,'Security Testing',13),
(37,'Network Documentation',14),
(37,'Security Review',15),
(37,'Guidelines Update',16);



INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(38,'Overview',1),
(38,'Purpose',2),
(38,'Scope',3),
(38,'Encryption Standards',4),
(38,'Data Encryption',5),
(38,'Encryption Algorithms',6),
(38,'Key Management',7),
(38,'Key Storage',8),
(38,'Encryption for Data in Transit',9),
(38,'Encryption for Data at Rest',10),
(38,'Access Controls',11),
(38,'Compliance Requirements',12),
(38,'Audit Logging',13),
(38,'Risk Management',14),
(38,'Policy Exceptions',15),
(38,'Policy Review',16);



INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(39,'Overview',1),
(39,'Purpose',2),
(39,'Scope',3),
(39,'Device Eligibility',4),
(39,'Device Security',5),
(39,'Approved Devices',6),
(39,'Software Installation',7),
(39,'Network Access',8),
(39,'Data Protection',9),
(39,'Monitoring',10),
(39,'Incident Reporting',11),
(39,'Compliance Requirements',12),
(39,'Device Maintenance',13),
(39,'Policy Violations',14),
(39,'Policy Exceptions',15),
(39,'Policy Review',16);



INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(40,'Overview',1),
(40,'Purpose',2),
(40,'Scope',3),
(40,'Vulnerability Identification',4),
(40,'Scanning Tools',5),
(40,'Risk Assessment',6),
(40,'Vulnerability Prioritization',7),
(40,'Patch Management',8),
(40,'Remediation Process',9),
(40,'Verification Testing',10),
(40,'Reporting Process',11),
(40,'Compliance Controls',12),
(40,'Monitoring',13),
(40,'Documentation',14),
(40,'Security Review',15),
(40,'Process Improvement',16);


-- Sales
INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(41,'Client Background',1),
(41,'Problem Statement',2),
(41,'Proposed Solution',3),
(41,'Product Overview',4),
(41,'Key Features',5),
(41,'Implementation Plan',6),
(41,'Project Timeline',7),
(41,'Pricing Breakdown',8),
(41,'Value Proposition',9),
(41,'Expected Outcomes',10),
(41,'Customer Responsibilities',11),
(41,'Support Model',12),
(41,'Assumptions',13),
(41,'Proposal Validity',14),
(41,'Approval and Signoff',15);


INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(42,'Pricing Principles',1),
(42,'Pricing Structure',2),
(42,'Subscription Plans',3),
(42,'Discount Strategy',4),
(42,'Enterprise Pricing',5),
(42,'Regional Pricing Rules',6),
(42,'Renewal Pricing',7),
(42,'Promotional Pricing',8),
(42,'Contract Pricing Terms',9),
(42,'Billing Model',10),
(42,'Revenue Recognition',11),
(42,'Price Change Guidelines',12),
(42,'Approval Authority',13),
(42,'Pricing Documentation',14),
(42,'Compliance Requirements',15);


INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(43,'Partner Roles',1),
(43,'Partnership Model',2),
(43,'Business Objectives',3),
(43,'Revenue Sharing Model',4),
(43,'Sales Responsibilities',5),
(43,'Marketing Collaboration',6),
(43,'Lead Ownership',7),
(43,'Performance Metrics',8),
(43,'Payment Terms',9),
(43,'Confidentiality Terms',10),
(43,'Intellectual Property Rights',11),
(43,'Termination Conditions',12),
(43,'Dispute Resolution',13),
(43,'Legal Jurisdiction',14),
(43,'Agreement Signatures',15);


INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(44,'Client Registration',1),
(44,'Contract Confirmation',2),
(44,'Account Setup',3),
(44,'Access Provisioning',4),
(44,'Product Configuration',5),
(44,'Client Kickoff Meeting',6),
(44,'Implementation Steps',7),
(44,'Integration Setup',8),
(44,'Training Sessions',9),
(44,'Support Channels',10),
(44,'Data Migration',11),
(44,'Service Activation',12),
(44,'Customer Success Handoff',13),
(44,'Onboarding Documentation',14),
(44,'Client Acceptance',15);


INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(45,'Market Analysis',1),
(45,'Target Customer Segments',2),
(45,'Product Positioning',3),
(45,'Competitive Landscape',4),
(45,'Value Proposition',5),
(45,'Sales Channels',6),
(45,'Lead Generation Strategy',7),
(45,'Sales Pipeline Model',8),
(45,'Sales Targets',9),
(45,'Territory Planning',10),
(45,'Customer Acquisition Strategy',11),
(45,'Revenue Growth Plan',12),
(45,'Partnership Opportunities',13),
(45,'Sales Enablement Tools',14),
(45,'Performance Metrics',15);


INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(46,'Lead Sources',1),
(46,'Lead Capture Methods',2),
(46,'Qualification Criteria',3),
(46,'Ideal Customer Profile',4),
(46,'Lead Scoring Model',5),
(46,'Initial Contact Process',6),
(46,'Discovery Questions',7),
(46,'Sales Readiness Evaluation',8),
(46,'Lead Routing',9),
(46,'CRM Recording',10),
(46,'Follow Up Strategy',11),
(46,'Disqualification Criteria',12),
(46,'Pipeline Entry',13),
(46,'Lead Nurturing',14),
(46,'Qualification Documentation',15);


INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(47,'Forecast Period',1),
(47,'Revenue Projections',2),
(47,'Pipeline Analysis',3),
(47,'Deal Probability',4),
(47,'Market Trends',5),
(47,'Sales Assumptions',6),
(47,'Regional Forecast',7),
(47,'Product Forecast',8),
(47,'Sales Targets',9),
(47,'Quota Achievement',10),
(47,'Revenue Risks',11),
(47,'Opportunity Analysis',12),
(47,'Forecast Adjustments',13),
(47,'Executive Summary',14),
(47,'Forecast Approval',15);


INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(48,'Agreement Parties',1),
(48,'Service Description',2),
(48,'Contract Duration',3),
(48,'Pricing Terms',4),
(48,'Payment Conditions',5),
(48,'Service Level Commitments',6),
(48,'Customer Responsibilities',7),
(48,'Confidentiality Clause',8),
(48,'Data Protection Clause',9),
(48,'Liability Limitations',10),
(48,'Termination Conditions',11),
(48,'Renewal Terms',12),
(48,'Dispute Resolution',13),
(48,'Legal Jurisdiction',14),
(48,'Contract Signatures',15);


INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(49,'Customer Context',1),
(49,'Business Challenges',2),
(49,'Recommended Solution',3),
(49,'Solution Architecture',4),
(49,'Implementation Roadmap',5),
(49,'Project Milestones',6),
(49,'Pricing Structure',7),
(49,'Customer Benefits',8),
(49,'Expected ROI',9),
(49,'Service Deliverables',10),
(49,'Customer Responsibilities',11),
(49,'Support Services',12),
(49,'Proposal Timeline',13),
(49,'Acceptance Terms',14),
(49,'Customer Signoff',15);



INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(50,'Reporting Period',1),
(50,'Revenue Performance',2),
(50,'Sales Target Achievement',3),
(50,'Pipeline Health',4),
(50,'Lead Conversion Rate',5),
(50,'Customer Acquisition',6),
(50,'Product Sales Breakdown',7),
(50,'Regional Sales Performance',8),
(50,'Top Performing Deals',9),
(50,'Lost Deal Analysis',10),
(50,'Sales Activity Metrics',11),
(50,'Sales Team Performance',12),
(50,'Revenue Growth Trends',13),
(50,'Strategic Insights',14),
(50,'Management Recommendations',15);



-- Marketing
INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(51,'Market Landscape',1),
(51,'Target Customer Segments',2),
(51,'Brand Positioning',3),
(51,'Value Proposition',4),
(51,'Competitive Analysis',5),
(51,'Marketing Channels',6),
(51,'Demand Generation Plan',7),
(51,'Customer Acquisition Strategy',8),
(51,'Customer Retention Strategy',9),
(51,'Growth Opportunities',10),
(51,'Marketing Technology Stack',11),
(51,'Campaign Planning Framework',12),
(51,'Marketing KPIs',13),
(51,'Revenue Contribution Model',14),
(51,'Strategic Roadmap',15);


INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(52,'Campaign Objective',1),
(52,'Target Audience',2),
(52,'Campaign Message',3),
(52,'Content Assets',4),
(52,'Channel Distribution',5),
(52,'Campaign Timeline',6),
(52,'Lead Capture Strategy',7),
(52,'Landing Page Strategy',8),
(52,'Marketing Automation Flow',9),
(52,'Advertising Plan',10),
(52,'Conversion Strategy',11),
(52,'Budget Allocation',12),
(52,'Campaign Metrics',13),
(52,'Performance Tracking',14),
(52,'Campaign Reporting',15);



INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(53,'Brand Mission',1),
(53,'Brand Vision',2),
(53,'Brand Personality',3),
(53,'Brand Voice',4),
(53,'Brand Messaging',5),
(53,'Logo Usage',6),
(53,'Color Palette',7),
(53,'Typography Standards',8),
(53,'Visual Design Principles',9),
(53,'Image Style',10),
(53,'Content Tone',11),
(53,'Brand Consistency Rules',12),
(53,'Marketing Material Usage',13),
(53,'Digital Branding Standards',14),
(53,'Brand Compliance',15);


INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(54,'Social Media Objectives',1),
(54,'Approved Platforms',2),
(54,'Account Management',3),
(54,'Content Guidelines',4),
(54,'Posting Schedule',5),
(54,'Community Engagement',6),
(54,'Brand Voice in Social Media',7),
(54,'Employee Social Media Conduct',8),
(54,'Crisis Communication',9),
(54,'Comment Moderation',10),
(54,'Security Practices',11),
(54,'Analytics Tracking',12),
(54,'Compliance Guidelines',13),
(54,'Escalation Procedures',14),
(54,'Policy Violations',15);


INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(55,'Content Goals',1),
(55,'Target Audience',2),
(55,'Content Themes',3),
(55,'Content Formats',4),
(55,'Editorial Calendar',5),
(55,'SEO Integration',6),
(55,'Content Distribution Channels',7),
(55,'Content Creation Workflow',8),
(55,'Content Quality Standards',9),
(55,'Content Promotion Strategy',10),
(55,'Lead Generation Content',11),
(55,'Content Performance Metrics',12),
(55,'Content Repurposing Strategy',13),
(55,'Content Governance',14),
(55,'Content Optimization',15);



INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(56,'Launch Objectives',1),
(56,'Target Market',2),
(56,'Product Positioning',3),
(56,'Messaging Framework',4),
(56,'Launch Timeline',5),
(56,'Marketing Channels',6),
(56,'Launch Campaigns',7),
(56,'PR Strategy',8),
(56,'Influencer Outreach',9),
(56,'Sales Enablement',10),
(56,'Customer Education',11),
(56,'Launch Events',12),
(56,'Success Metrics',13),
(56,'Risk Mitigation',14),
(56,'Post Launch Activities',15);


INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(57,'Research Objectives',1),
(57,'Research Methodology',2),
(57,'Market Overview',3),
(57,'Customer Segments',4),
(57,'Market Trends',5),
(57,'Industry Analysis',6),
(57,'Competitor Analysis',7),
(57,'Customer Needs Analysis',8),
(57,'Product Demand Insights',9),
(57,'Data Analysis',10),
(57,'Key Findings',11),
(57,'Strategic Insights',12),
(57,'Growth Opportunities',13),
(57,'Market Risks',14),
(57,'Research Conclusions',15);


INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(58,'Persona Overview',1),
(58,'Demographic Profile',2),
(58,'Professional Background',3),
(58,'Goals and Motivations',4),
(58,'Pain Points',5),
(58,'Buying Behavior',6),
(58,'Decision Factors',7),
(58,'Customer Journey',8),
(58,'Preferred Channels',9),
(58,'Content Preferences',10),
(58,'Product Expectations',11),
(58,'Customer Objections',12),
(58,'Customer Needs',13),
(58,'Persona Insights',14),
(58,'Marketing Recommendations',15);


INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(59,'SEO Objectives',1),
(59,'Keyword Research',2),
(59,'Search Intent Analysis',3),
(59,'Competitor SEO Analysis',4),
(59,'On Page SEO Strategy',5),
(59,'Technical SEO Plan',6),
(59,'Content Optimization',7),
(59,'Backlink Strategy',8),
(59,'Site Structure Optimization',9),
(59,'SEO Tools and Platforms',10),
(59,'SEO Content Plan',11),
(59,'Ranking Metrics',12),
(59,'Traffic Growth Plan',13),
(59,'SEO Monitoring',14),
(59,'SEO Reporting',15);


INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(60,'Budget Objectives',1),
(60,'Marketing Spend Categories',2),
(60,'Campaign Budget Allocation',3),
(60,'Channel Budget Distribution',4),
(60,'Advertising Budget',5),
(60,'Content Production Budget',6),
(60,'Marketing Tools Budget',7),
(60,'Event Marketing Budget',8),
(60,'Partner Marketing Budget',9),
(60,'Lead Generation Budget',10),
(60,'Cost per Acquisition Targets',11),
(60,'Budget Monitoring',12),
(60,'Variance Analysis',13),
(60,'ROI Measurement',14),
(60,'Budget Adjustments',15);


-- Customer Support
INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(61,'Support Channels',1),
(61,'Customer Request Intake',2),
(61,'Ticket Creation',3),
(61,'Ticket Categorization',4),
(61,'Ticket Prioritization',5),
(61,'Initial Response Workflow',6),
(61,'Troubleshooting Process',7),
(61,'Internal Escalation',8),
(61,'Resolution Workflow',9),
(61,'Customer Follow-up',10),
(61,'Ticket Closure',11),
(61,'Support Documentation',12),
(61,'Service Metrics',13),
(61,'Support Tools',14),
(61,'Process Improvements',15);


INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(62,'Ticket Intake Methods',1),
(62,'Ticket Classification',2),
(62,'Priority Assignment',3),
(62,'Ticket Routing',4),
(62,'Agent Assignment',5),
(62,'Customer Communication',6),
(62,'Investigation Process',7),
(62,'Technical Troubleshooting',8),
(62,'Resolution Steps',9),
(62,'Escalation Conditions',10),
(62,'Ticket Updates',11),
(62,'Resolution Confirmation',12),
(62,'Ticket Closure Rules',13),
(62,'Customer Satisfaction Tracking',14),
(62,'Ticket Analytics',15);


INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(63,'Escalation Triggers',1),
(63,'Escalation Levels',2),
(63,'Priority Escalation Rules',3),
(63,'Technical Escalation Path',4),
(63,'Manager Escalation Process',5),
(63,'Response Time Thresholds',6),
(63,'Customer Impact Evaluation',7),
(63,'Escalation Communication',8),
(63,'Incident Coordination',9),
(63,'Resolution Ownership',10),
(63,'Escalation Documentation',11),
(63,'Escalation Tracking',12),
(63,'Performance Monitoring',13),
(63,'Post Escalation Review',14),
(63,'Policy Enforcement',15);


INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(64,'Account Setup Questions',1),
(64,'Product Usage Questions',2),
(64,'Billing Questions',3),
(64,'Subscription Management',4),
(64,'Technical Troubleshooting',5),
(64,'Integration Questions',6),
(64,'Security and Privacy Questions',7),
(64,'Feature Availability',8),
(64,'Data Management Questions',9),
(64,'Service Limitations',10),
(64,'Support Contact Methods',11),
(64,'Account Recovery',12),
(64,'Product Updates',13),
(64,'Customer Resources',14),
(64,'FAQ Maintenance',15);


INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(65,'Feedback Collection Channels',1),
(65,'Customer Surveys',2),
(65,'Feedback Recording',3),
(65,'Feedback Categorization',4),
(65,'Sentiment Analysis',5),
(65,'Customer Experience Metrics',6),
(65,'Product Feedback Tracking',7),
(65,'Issue Prioritization',8),
(65,'Internal Feedback Sharing',9),
(65,'Improvement Actions',10),
(65,'Customer Follow-up',11),
(65,'Feedback Reporting',12),
(65,'Trend Analysis',13),
(65,'Customer Retention Insights',14),
(65,'Feedback Improvement Cycle',15);


INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(66,'Service Coverage',1),
(66,'Support Availability',2),
(66,'Response Time Targets',3),
(66,'Resolution Time Targets',4),
(66,'Incident Severity Levels',5),
(66,'Support Responsibilities',6),
(66,'Customer Responsibilities',7),
(66,'Service Performance Metrics',8),
(66,'Service Monitoring',9),
(66,'Support Escalation Conditions',10),
(66,'Service Credits',11),
(66,'Maintenance Windows',12),
(66,'Service Limitations',13),
(66,'SLA Reporting',14),
(66,'Agreement Acceptance',15);


INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(67,'Complaint Intake',1),
(67,'Complaint Registration',2),
(67,'Complaint Classification',3),
(67,'Priority Assessment',4),
(67,'Investigation Workflow',5),
(67,'Customer Communication',6),
(67,'Resolution Actions',7),
(67,'Escalation Conditions',8),
(67,'Corrective Actions',9),
(67,'Customer Confirmation',10),
(67,'Complaint Documentation',11),
(67,'Complaint Metrics',12),
(67,'Quality Monitoring',13),
(67,'Complaint Analysis',14),
(67,'Process Improvements',15);


INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(68,'Agent Role Overview',1),
(68,'Support Tools Training',2),
(68,'Product Knowledge Training',3),
(68,'Customer Interaction Skills',4),
(68,'Troubleshooting Techniques',5),
(68,'Ticket Handling Training',6),
(68,'Communication Best Practices',7),
(68,'Escalation Procedures',8),
(68,'Service Standards',9),
(68,'Performance Expectations',10),
(68,'Quality Assurance Guidelines',11),
(68,'Continuous Learning',12),
(68,'Training Assessments',13),
(68,'Agent Certification',14),
(68,'Training Resources',15);


INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(69,'Customer Interaction Standards',1),
(69,'Response Tone and Style',2),
(69,'Email Communication Rules',3),
(69,'Chat Communication Guidelines',4),
(69,'Phone Support Etiquette',5),
(69,'Professional Language Usage',6),
(69,'Handling Difficult Customers',7),
(69,'Escalation Communication',8),
(69,'Response Time Expectations',9),
(69,'Internal Communication',10),
(69,'Documentation Practices',11),
(69,'Customer Follow-up',12),
(69,'Confidential Information Handling',13),
(69,'Communication Quality Monitoring',14),
(69,'Guideline Enforcement',15);


INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(70,'Article Title',1),
(70,'Problem Description',2),
(70,'Applicable Product Version',3),
(70,'Prerequisites',4),
(70,'Step by Step Solution',5),
(70,'Alternative Solutions',6),
(70,'Troubleshooting Tips',7),
(70,'Screenshots and Examples',8),
(70,'Common Errors',9),
(70,'Related Articles',10),
(70,'Customer Impact',11),
(70,'Technical Notes',12),
(70,'Support References',13),
(70,'Update History',14),
(70,'Content Owner',15);


-- Legal
INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(71,'Parties Involved',1),
(71,'Definition of Confidential Information',2),
(71,'Purpose of Disclosure',3),
(71,'Confidentiality Obligations',4),
(71,'Permitted Use of Information',5),
(71,'Information Exclusions',6),
(71,'Protection Measures',7),
(71,'Third Party Disclosure',8),
(71,'Duration of Confidentiality',9),
(71,'Data Return or Destruction',10),
(71,'Breach Consequences',11),
(71,'Liability Limitations',12),
(71,'Governing Law',13),
(71,'Dispute Resolution',14),
(71,'Agreement Signatures',15);


INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(72,'Agreement Parties',1),
(72,'Data Processing Scope',2),
(72,'Categories of Personal Data',3),
(72,'Data Subject Types',4),
(72,'Data Processing Responsibilities',5),
(72,'Data Protection Principles',6),
(72,'Security Safeguards',7),
(72,'Data Access Controls',8),
(72,'Data Transfer Restrictions',9),
(72,'Subprocessor Management',10),
(72,'Data Breach Notification',11),
(72,'Data Retention Rules',12),
(72,'Audit Rights',13),
(72,'Regulatory Compliance',14),
(72,'Agreement Termination',15);

SELECT * FROM template_sections;

SELECT COUNT(*) FROM template_sections;

INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(73,'Service Description',1),
(73,'User Eligibility',2),
(73,'Account Registration',3),
(73,'User Responsibilities',4),
(73,'Acceptable Use Rules',5),
(73,'Service Availability',6),
(73,'Subscription Terms',7),
(73,'Payment Conditions',8),
(73,'Intellectual Property Rights',9),
(73,'Data Usage Terms',10),
(73,'Service Limitations',11),
(73,'Termination Conditions',12),
(73,'Liability Disclaimer',13),
(73,'Dispute Resolution',14),
(73,'Legal Jurisdiction',15);


INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(74,'Data Collection Practices',1),
(74,'Types of Personal Information',2),
(74,'Data Usage Purposes',3),
(74,'Legal Basis for Processing',4),
(74,'Cookies and Tracking Technologies',5),
(74,'Data Sharing Practices',6),
(74,'Third Party Services',7),
(74,'Data Security Measures',8),
(74,'Data Retention Period',9),
(74,'User Privacy Rights',10),
(74,'Data Access Requests',11),
(74,'International Data Transfers',12),
(74,'Children Privacy Protection',13),
(74,'Policy Updates',14),
(74,'Contact Information',15);


INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(75,'Regulatory Framework',1),
(75,'Compliance Objectives',2),
(75,'Legal Obligations',3),
(75,'Internal Compliance Standards',4),
(75,'Employee Responsibilities',5),
(75,'Compliance Monitoring',6),
(75,'Reporting Violations',7),
(75,'Investigation Procedures',8),
(75,'Corrective Actions',9),
(75,'Training Requirements',10),
(75,'Compliance Documentation',11),
(75,'Internal Controls',12),
(75,'Regulatory Audits',13),
(75,'Compliance Metrics',14),
(75,'Policy Enforcement',15);


INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(76,'Contract Submission',1),
(76,'Contract Classification',2),
(76,'Initial Legal Review',3),
(76,'Risk Identification',4),
(76,'Clause Analysis',5),
(76,'Compliance Verification',6),
(76,'Negotiation Points',7),
(76,'Legal Approval Workflow',8),
(76,'Stakeholder Coordination',9),
(76,'Revision Tracking',10),
(76,'Contract Finalization',11),
(76,'Execution Process',12),
(76,'Contract Storage',13),
(76,'Contract Monitoring',14),
(76,'Review Documentation',15);


INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(77,'Risk Identification',1),
(77,'Risk Categories',2),
(77,'Legal Exposure Analysis',3),
(77,'Regulatory Risk Factors',4),
(77,'Contractual Risks',5),
(77,'Compliance Risks',6),
(77,'Operational Legal Risks',7),
(77,'Risk Impact Assessment',8),
(77,'Risk Probability Evaluation',9),
(77,'Mitigation Strategies',10),
(77,'Control Mechanisms',11),
(77,'Risk Monitoring',12),
(77,'Legal Reporting',13),
(77,'Risk Documentation',14),
(77,'Management Recommendations',15);


INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(78,'Intellectual Property Scope',1),
(78,'Ownership Principles',2),
(78,'Employee Creations',3),
(78,'Patent Rights',4),
(78,'Trademark Usage',5),
(78,'Copyright Protection',6),
(78,'Trade Secrets',7),
(78,'Third Party IP Usage',8),
(78,'Licensing Rules',9),
(78,'IP Protection Measures',10),
(78,'IP Infringement Reporting',11),
(78,'Enforcement Actions',12),
(78,'IP Documentation',13),
(78,'Legal Compliance',14),
(78,'Policy Enforcement',15);


INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(79,'Vendor Identification',1),
(79,'Service Description',2),
(79,'Contract Duration',3),
(79,'Pricing and Payment Terms',4),
(79,'Vendor Responsibilities',5),
(79,'Company Responsibilities',6),
(79,'Service Level Commitments',7),
(79,'Confidentiality Requirements',8),
(79,'Data Protection Obligations',9),
(79,'Compliance Requirements',10),
(79,'Liability Terms',11),
(79,'Termination Conditions',12),
(79,'Dispute Resolution',13),
(79,'Legal Jurisdiction',14),
(79,'Agreement Signatures',15);


INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(80,'Audit Scope Definition',1),
(80,'Applicable Regulations',2),
(80,'Compliance Controls Review',3),
(80,'Policy Implementation Check',4),
(80,'Operational Compliance Checks',5),
(80,'Documentation Verification',6),
(80,'Process Compliance Evaluation',7),
(80,'Risk Identification',8),
(80,'Control Effectiveness Review',9),
(80,'Regulatory Gap Analysis',10),
(80,'Audit Findings',11),
(80,'Non Compliance Issues',12),
(80,'Corrective Action Plan',13),
(80,'Compliance Reporting',14),
(80,'Audit Signoff',15);


-- Operations 

INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(81,'Overview',1),
(81,'Purpose',2),
(81,'Operational Workflow',3),
(81,'Task Assignment Model',4),
(81,'Operational Responsibilities',5),
(81,'Service Execution Steps',6),
(81,'Resource Coordination',7),
(81,'Operational Tools',8),
(81,'Communication Channels',9),
(81,'Operational Monitoring',10),
(81,'Issue Handling',11),
(81,'Operational Documentation',12),
(81,'Process Controls',13),
(81,'Performance Monitoring',14),
(81,'Operational Improvements',15);


INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(82,'Vendor Selection Criteria',1),
(82,'Vendor Onboarding',2),
(82,'Contract Management',3),
(82,'Vendor Performance Metrics',4),
(82,'Service Expectations',5),
(82,'Vendor Communication',6),
(82,'Compliance Requirements',7),
(82,'Risk Assessment',8),
(82,'Vendor Monitoring',9),
(82,'Vendor Evaluation Process',10),
(82,'Issue Escalation',11),
(82,'Vendor Payment Terms',12),
(82,'Vendor Documentation',13),
(82,'Vendor Relationship Management',14),
(82,'Policy Enforcement',15);


INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(83,'Service Delivery Overview',1),
(83,'Service Delivery Model',2),
(83,'Customer Request Intake',3),
(83,'Service Planning',4),
(83,'Service Execution Workflow',5),
(83,'Resource Assignment',6),
(83,'Quality Control Steps',7),
(83,'Customer Communication',8),
(83,'Service Tracking',9),
(83,'Issue Resolution',10),
(83,'Service Completion',11),
(83,'Customer Feedback Collection',12),
(83,'Service Documentation',13),
(83,'Delivery Metrics',14),
(83,'Service Optimization',15);



INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(84,'Process Overview',1),
(84,'Process Objectives',2),
(84,'Process Scope',3),
(84,'Workflow Diagram',4),
(84,'Process Inputs',5),
(84,'Process Activities',6),
(84,'Process Outputs',7),
(84,'Roles and Responsibilities',8),
(84,'Operational Dependencies',9),
(84,'Process Controls',10),
(84,'Documentation Standards',11),
(84,'Process Monitoring',12),
(84,'Process Metrics',13),
(84,'Process Risks',14),
(84,'Process Updates',15);


INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(85,'Overview',1),
(85,'Quality Standards',2),
(85,'Testing Procedures',3),
(85,'Quality Control Workflow',4),
(85,'Inspection Methods',5),
(85,'Defect Identification',6),
(85,'Issue Tracking',7),
(85,'Quality Documentation',8),
(85,'Quality Metrics',9),
(85,'Corrective Actions',10),
(85,'Continuous Quality Monitoring',11),
(85,'Quality Reporting',12),
(85,'Compliance Checks',13),
(85,'Quality Improvement Actions',14),
(85,'QA Process Governance',15);


INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(86,'Purpose',1),
(86,'Risk Identification',2),
(86,'Operational Risk Categories',3),
(86,'Risk Assessment Criteria',4),
(86,'Risk Impact Analysis',5),
(86,'Risk Probability Evaluation',6),
(86,'Risk Mitigation Strategies',7),
(86,'Operational Controls',8),
(86,'Risk Monitoring',9),
(86,'Incident Correlation',10),
(86,'Risk Reporting',11),
(86,'Compliance Requirements',12),
(86,'Risk Documentation',13),
(86,'Management Review',14),
(86,'Risk Reduction Initiatives',15);


INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(87,'Resource Planning Objectives',1),
(87,'Resource Categories',2),
(87,'Team Allocation Model',3),
(87,'Skill Mapping',4),
(87,'Capacity Planning',5),
(87,'Resource Scheduling',6),
(87,'Project Assignment Rules',7),
(87,'Workload Distribution',8),
(87,'Resource Utilization Metrics',9),
(87,'Resource Monitoring',10),
(87,'Budget Constraints',11),
(87,'Resource Adjustments',12),
(87,'Operational Dependencies',13),
(87,'Resource Reporting',14),
(87,'Optimization Strategies',15);


INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(88,'Overview',1),
(88,'Improvement Objectives',2),
(88,'Process Evaluation Methods',3),
(88,'Performance Analysis',4),
(88,'Operational Bottlenecks',5),
(88,'Improvement Opportunities',6),
(88,'Process Redesign',7),
(88,'Implementation Strategy',8),
(88,'Resource Requirements',9),
(88,'Change Management',10),
(88,'Improvement Metrics',11),
(88,'Impact Analysis',12),
(88,'Continuous Improvement Framework',13),
(88,'Improvement Documentation',14),
(88,'Implementation Tracking',15);


INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(89,'Incident Identification',1),
(89,'Incident Reporting',2),
(89,'Incident Classification',3),
(89,'Incident Prioritization',4),
(89,'Incident Investigation',5),
(89,'Response Coordination',6),
(89,'Resolution Actions',7),
(89,'Communication Procedures',8),
(89,'Service Restoration',9),
(89,'Root Cause Analysis',10),
(89,'Preventive Measures',11),
(89,'Incident Documentation',12),
(89,'Incident Metrics',13),
(89,'Post Incident Review',14),
(89,'Process Improvements',15);


INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(90,'Reporting Period',1),
(90,'Operational Summary',2),
(90,'Service Delivery Metrics',3),
(90,'Operational Efficiency Metrics',4),
(90,'Resource Utilization',5),
(90,'Process Performance Analysis',6),
(90,'Operational Issues',7),
(90,'Incident Statistics',8),
(90,'Customer Impact Analysis',9),
(90,'Operational Risks',10),
(90,'Cost Efficiency Metrics',11),
(90,'Improvement Initiatives',12),
(90,'Strategic Recommendations',13),
(90,'Operational Insights',14),
(90,'Management Summary',15);


-- Product

INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(91,'Product Overview',1),
(91,'Problem Statement',2),
(91,'Business Objectives',3),
(91,'Target Users',4),
(91,'User Needs',5),
(91,'Functional Requirements',6),
(91,'Non Functional Requirements',7),
(91,'User Flows',8),
(91,'System Dependencies',9),
(91,'Success Metrics',10),
(91,'Constraints',11),
(91,'Implementation Considerations',12),
(91,'Release Scope',13),
(91,'Risk Factors',14),
(91,'Approval Stakeholders',15);


INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(92,'Feature Summary',1),
(92,'Problem Description',2),
(92,'User Impact',3),
(92,'Proposed Solution',4),
(92,'Feature Workflow',5),
(92,'Product Dependencies',6),
(92,'Technical Considerations',7),
(92,'Design Requirements',8),
(92,'Expected Benefits',9),
(92,'Implementation Effort',10),
(92,'Success Criteria',11),
(92,'Potential Risks',12),
(92,'Alternatives Considered',13),
(92,'Stakeholder Approval',14),
(92,'Proposal Decision',15);


INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(93,'Roadmap Vision',1),
(93,'Strategic Themes',2),
(93,'Quarterly Goals',3),
(93,'Upcoming Features',4),
(93,'Planned Enhancements',5),
(93,'Innovation Initiatives',6),
(93,'Customer Driven Features',7),
(93,'Technical Improvements',8),
(93,'Release Milestones',9),
(93,'Dependencies',10),
(93,'Resource Allocation',11),
(93,'Timeline Overview',12),
(93,'Delivery Risks',13),
(93,'Success Indicators',14),
(93,'Roadmap Updates',15);


INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(94,'Market Opportunity',1),
(94,'Customer Segments',2),
(94,'Product Value Proposition',3),
(94,'Competitive Landscape',4),
(94,'Strategic Goals',5),
(94,'Product Positioning',6),
(94,'Growth Strategy',7),
(94,'Revenue Strategy',8),
(94,'Innovation Areas',9),
(94,'Strategic Initiatives',10),
(94,'Partnership Opportunities',11),
(94,'Technology Alignment',12),
(94,'Customer Success Alignment',13),
(94,'Performance Metrics',14),
(94,'Strategic Roadmap',15);


INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(95,'User Story Title',1),
(95,'User Persona',2),
(95,'User Goal',3),
(95,'User Scenario',4),
(95,'Acceptance Criteria',5),
(95,'Functional Behavior',6),
(95,'User Interface Notes',7),
(95,'Edge Cases',8),
(95,'Dependencies',9),
(95,'Technical Notes',10),
(95,'Test Scenarios',11),
(95,'Priority Level',12),
(95,'Story Points',13),
(95,'Release Target',14),
(95,'Story Approval',15);


INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(96,'Release Objectives',1),
(96,'Release Scope',2),
(96,'Included Features',3),
(96,'Development Timeline',4),
(96,'Testing Strategy',5),
(96,'Quality Assurance Checks',6),
(96,'Deployment Plan',7),
(96,'Release Dependencies',8),
(96,'Rollback Plan',9),
(96,'Communication Plan',10),
(96,'Customer Notification',11),
(96,'Release Metrics',12),
(96,'Post Release Monitoring',13),
(96,'Known Limitations',14),
(96,'Release Approval',15);


INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(97,'Prioritization Principles',1),
(97,'Customer Value Evaluation',2),
(97,'Business Impact Assessment',3),
(97,'Effort Estimation',4),
(97,'Technical Feasibility',5),
(97,'Market Demand Analysis',6),
(97,'Revenue Potential',7),
(97,'Strategic Alignment',8),
(97,'Risk Evaluation',9),
(97,'Scoring Framework',10),
(97,'Feature Ranking Process',11),
(97,'Stakeholder Inputs',12),
(97,'Prioritization Reviews',13),
(97,'Decision Documentation',14),
(97,'Priority Updates',15);


INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(98,'Feedback Sources',1),
(98,'Customer Feedback Channels',2),
(98,'Feedback Categorization',3),
(98,'Sentiment Analysis',4),
(98,'Feature Requests',5),
(98,'Usability Issues',6),
(98,'Customer Pain Points',7),
(98,'Feedback Trends',8),
(98,'Product Improvement Insights',9),
(98,'Customer Satisfaction Metrics',10),
(98,'Priority Feedback Items',11),
(98,'Product Team Actions',12),
(98,'Impact Assessment',13),
(98,'Improvement Roadmap',14),
(98,'Feedback Reporting',15);


INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(99,'Market Overview',1),
(99,'Competitor Landscape',2),
(99,'Competitor Profiles',3),
(99,'Feature Comparison',4),
(99,'Pricing Comparison',5),
(99,'Product Strengths',6),
(99,'Product Weaknesses',7),
(99,'Market Positioning',8),
(99,'Customer Preference Analysis',9),
(99,'Competitive Advantages',10),
(99,'Market Gaps',11),
(99,'Strategic Opportunities',12),
(99,'Threat Analysis',13),
(99,'Strategic Recommendations',14),
(99,'Analysis Summary',15);



INSERT INTO template_sections (template_id, section_title, section_order)
VALUES
(100,'Product Vision Statement',1),
(100,'Long Term Goals',2),
(100,'Target Market',3),
(100,'Customer Value',4),
(100,'Product Principles',5),
(100,'Innovation Direction',6),
(100,'Strategic Differentiation',7),
(100,'Future Capabilities',8),
(100,'Customer Experience Vision',9),
(100,'Technology Direction',10),
(100,'Product Evolution Path',11),
(100,'Growth Opportunities',12),
(100,'Strategic Milestones',13),
(100,'Vision Alignment',14),
(100,'Executive Endorsement',15);



SELECT section_title, template_id
FROM template_sections
WHERE template_id = 100
ORDER BY section_order;

DELETE FROM template_sections;

ALTER SEQUENCE template_sections_id_seq RESTART WITH 1;

SELECT * FROM template_sections;



