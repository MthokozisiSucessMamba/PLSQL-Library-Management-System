

-- 1. Display all currently borrowed books


CREATE OR REPLACE PROCEDURE display_borrowed_books
IS

    CURSOR borrowed_books_cursor IS
        SELECT
            l.loan_id,
            b.title,
            m.first_name || ' ' || m.last_name AS member_name,
            l.borrow_date,
            l.due_date
        FROM library_loans l
        JOIN library_books b
            ON l.book_id = b.book_id
        JOIN library_members m
            ON l.member_id = m.member_id
        WHERE l.return_date IS NULL;

BEGIN

    FOR loan_record IN borrowed_books_cursor
    LOOP

        DBMS_OUTPUT.PUT_LINE('Loan ID: ' || loan_record.loan_id);

        DBMS_OUTPUT.PUT_LINE('Book: ' || loan_record.title);

        DBMS_OUTPUT.PUT_LINE('Member: ' || loan_record.member_name);

        DBMS_OUTPUT.PUT_LINE(
            'Borrowed: ' ||
            TO_CHAR(loan_record.borrow_date, 'DD-MON-YYYY')
        );

        DBMS_OUTPUT.PUT_LINE(
            'Due: ' ||
            TO_CHAR(loan_record.due_date, 'DD-MON-YYYY')
        );

        DBMS_OUTPUT.PUT_LINE(
            '-----------------------------'
        );

    END LOOP;

END;
/



-- 2. Display overdue books


CREATE OR REPLACE PROCEDURE display_overdue_books
IS

    CURSOR overdue_cursor IS
        SELECT
            l.loan_id,
            b.title,
            m.first_name || ' ' || m.last_name AS member_name,
            l.due_date
        FROM library_loans l
        JOIN library_books b
            ON l.book_id = b.book_id
        JOIN library_members m
            ON l.member_id = m.member_id
        WHERE l.return_date IS NULL
        AND l.due_date < SYSDATE;

BEGIN

    FOR loan_record IN overdue_cursor
    LOOP

        DBMS_OUTPUT.PUT_LINE('Loan ID: ' || loan_record.loan_id);

        DBMS_OUTPUT.PUT_LINE('Book: ' || loan_record.title);

        DBMS_OUTPUT.PUT_LINE('Member: ' || loan_record.member_name);

        DBMS_OUTPUT.PUT_LINE(
            'Due Date: ' ||
            TO_CHAR(loan_record.due_date, 'DD-MON-YYYY')
        );

        DBMS_OUTPUT.PUT_LINE('STATUS: OVERDUE');

        DBMS_OUTPUT.PUT_LINE(
            '-----------------------------'
        );

    END LOOP;

END;
/