CREATE TABLE library_books (
    book_id NUMBER PRIMARY KEY,
    title VARCHAR2(100) NOT NULL,
    author VARCHAR2(100) NOT NULL,
    category VARCHAR2(50),
    total_copies NUMBER DEFAULT 1,
    available_copies NUMBER DEFAULT 1
);

CREATE TABLE library_members (
    member_id NUMBER PRIMARY KEY,
    first_name VARCHAR2(50) NOT NULL,
    last_name VARCHAR2(50) NOT NULL,
    student_number VARCHAR2(20) UNIQUE,
    email VARCHAR2(100)
);

CREATE TABLE library_loans (
    loan_id NUMBER PRIMARY KEY,
    book_id NUMBER,
    member_id NUMBER,
    borrow_date DATE DEFAULT SYSDATE,
    due_date DATE,
    return_date DATE,
    fine_amount NUMBER(10,2) DEFAULT 0,

    CONSTRAINT fk_loan_book
        FOREIGN KEY (book_id)
        REFERENCES library_books(book_id),

    CONSTRAINT fk_loan_member
        FOREIGN KEY (member_id)
        REFERENCES library_members(member_id)
);