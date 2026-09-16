INSERT INTO library_books
(book_id, title, author, category, total_copies, available_copies)
VALUES
(1, 'Clean Code', 'Robert C. Martin', 'Programming', 3, 3);

INSERT INTO library_books
(book_id, title, author, category, total_copies, available_copies)
VALUES
(2, 'Introduction to Algorithms', 'Thomas H. Cormen', 'Algorithms', 2, 2);

INSERT INTO library_books
(book_id, title, author, category, total_copies, available_copies)
VALUES
(3, 'Database Systems', 'Raghu Ramakrishnan', 'Database', 4, 4);

INSERT INTO library_books
(book_id, title, author, category, total_copies, available_copies)
VALUES
(4, 'Python Crash Course', 'Eric Matthes', 'Programming', 3, 3);


INSERT INTO library_members
(member_id, first_name, last_name, student_number, email)
VALUES
(1, 'John', 'Mokoena', '223100001', 'john@example.com');

INSERT INTO library_members
(member_id, first_name, last_name, student_number, email)
VALUES
(2, 'Sarah', 'Dlamini', '223100002', 'sarah@example.com');

INSERT INTO library_members
(member_id, first_name, last_name, student_number, email)
VALUES
(3, 'Thabo', 'Nkosi', '224100003', 'thabo@example.com');


COMMIT;