CREATE DATABASE library_management;
USE library_management;

-- Books Table

CREATE TABLE books (
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(150) NOT NULL,
    author VARCHAR(100),
    available_copies INT CHECK (available_copies >= 0)
);

-- Members Table

CREATE TABLE members (
    member_id INT PRIMARY KEY AUTO_INCREMENT,
    member_name VARCHAR(100) NOT NULL,
    status VARCHAR(20) DEFAULT 'ACTIVE'
);

-- Borrow Records Table

CREATE TABLE borrow_records (
    record_id INT PRIMARY KEY AUTO_INCREMENT,
    book_id INT,
    member_id INT,
    borrow_date DATE,
    due_date DATE,
    return_date DATE,
    fine_amount DECIMAL(6,2) DEFAULT 0,
    FOREIGN KEY (book_id) REFERENCES books(book_id),
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);

-- Insert Books

INSERT INTO books (title, author, available_copies) VALUES
('Clean Code', 'Robert C. Martin', 3),
('Introduction to Algorithms', 'Cormen', 2),
('Database System Concepts', 'Silberschatz', 1);

-- Insert Members

INSERT INTO members (member_name) VALUES
('Aakash'),
('Divya'),
('Rahul');

-- Borrow Book (14 days)

INSERT INTO borrow_records (book_id, member_id, borrow_date, due_date)
VALUES (1, 1, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 14 DAY));

-- View Borrowed Books

SELECT m.member_name, b.title, br.borrow_date, br.due_date
FROM borrow_records br
JOIN members m ON br.member_id = m.member_id
JOIN books b ON br.book_id = b.book_id;

-- Overdue Books

SELECT m.member_name, b.title,
DATEDIFF(CURDATE(), br.due_date) AS days_late
FROM borrow_records br
JOIN members m ON br.member_id = m.member_id
JOIN books b ON br.book_id = b.book_id
WHERE CURDATE() > br.due_date;

-- ===============================
-- Fine Calculation (₹5 per day)
-- ===============================
UPDATE borrow_records
SET fine_amount = DATEDIFF(CURDATE(), due_date) * 5
WHERE CURDATE() > due_date;
