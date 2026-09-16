CREATE OR REPLACE PACKAGE library_pkg AS

    PROCEDURE borrow_book(
        p_member_id IN NUMBER,
        p_book_id IN NUMBER
    );

    PROCEDURE return_book(
        p_loan_id IN NUMBER
    );

    FUNCTION get_available_copies(
        p_book_id IN NUMBER
    ) RETURN NUMBER;

    FUNCTION calculate_fine(
        p_due_date IN DATE,
        p_return_date IN DATE
    ) RETURN NUMBER;

    FUNCTION count_member_loans(
        p_member_id IN NUMBER
    ) RETURN NUMBER;

END library_pkg;
/

CREATE OR REPLACE PACKAGE BODY library_pkg AS

    PROCEDURE borrow_book(
        p_member_id IN NUMBER,
        p_book_id IN NUMBER
    )
    IS
        v_member_count NUMBER;
        v_book_count NUMBER;
        v_available_copies NUMBER;
    BEGIN

        SELECT COUNT(*)
        INTO v_member_count
        FROM library_members
        WHERE member_id = p_member_id;

        IF v_member_count = 0 THEN
            RAISE_APPLICATION_ERROR(
                -20001,
                'Member does not exist.'
            );
        END IF;

        SELECT COUNT(*)
        INTO v_book_count
        FROM library_books
        WHERE book_id = p_book_id;

        IF v_book_count = 0 THEN
            RAISE_APPLICATION_ERROR(
                -20002,
                'Book does not exist.'
            );
        END IF;

        SELECT available_copies
        INTO v_available_copies
        FROM library_books
        WHERE book_id = p_book_id;

        IF v_available_copies <= 0 THEN
            RAISE_APPLICATION_ERROR(
                -20003,
                'No copies of this book are available.'
            );
        END IF;

        INSERT INTO library_loans (
            loan_id,
            book_id,
            member_id,
            borrow_date,
            due_date
        )
        VALUES (
            library_loans_seq.NEXTVAL,
            p_book_id,
            p_member_id,
            SYSDATE,
            SYSDATE + 14
        );

        UPDATE library_books
        SET available_copies = available_copies - 1
        WHERE book_id = p_book_id;

        COMMIT;

        DBMS_OUTPUT.PUT_LINE('Book borrowed successfully.');
        DBMS_OUTPUT.PUT_LINE(
            'Due date: ' ||
            TO_CHAR(SYSDATE + 14, 'DD-MON-YYYY')
        );

    END borrow_book;


    PROCEDURE return_book(
        p_loan_id IN NUMBER
    )
    IS
        v_book_id NUMBER;
        v_return_date DATE;
    BEGIN

        SELECT book_id, return_date
        INTO v_book_id, v_return_date
        FROM library_loans
        WHERE loan_id = p_loan_id;

        IF v_return_date IS NOT NULL THEN
            RAISE_APPLICATION_ERROR(
                -20004,
                'This book has already been returned.'
            );
        END IF;

        UPDATE library_loans
        SET return_date = SYSDATE,
            fine_amount = calculate_fine(
                due_date,
                SYSDATE
            )
        WHERE loan_id = p_loan_id;

        UPDATE library_books
        SET available_copies = available_copies + 1
        WHERE book_id = v_book_id;

        COMMIT;

        DBMS_OUTPUT.PUT_LINE(
            'Book returned successfully.'
        );

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(
                -20005,
                'Loan does not exist.'
            );

    END return_book;


    FUNCTION get_available_copies(
        p_book_id IN NUMBER
    )
    RETURN NUMBER
    IS
        v_available_copies NUMBER;
    BEGIN

        SELECT available_copies
        INTO v_available_copies
        FROM library_books
        WHERE book_id = p_book_id;

        RETURN v_available_copies;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN -1;

    END get_available_copies;


    FUNCTION calculate_fine(
        p_due_date IN DATE,
        p_return_date IN DATE
    )
    RETURN NUMBER
    IS
        v_days_late NUMBER;
        v_fine NUMBER;
    BEGIN

        IF p_return_date <= p_due_date THEN
            RETURN 0;
        END IF;

        v_days_late :=
            TRUNC(p_return_date) - TRUNC(p_due_date);

        v_fine := v_days_late * 5;

        RETURN v_fine;

    END calculate_fine;


    FUNCTION count_member_loans(
        p_member_id IN NUMBER
    )
    RETURN NUMBER
    IS
        v_loan_count NUMBER;
    BEGIN

        SELECT COUNT(*)
        INTO v_loan_count
        FROM library_loans
        WHERE member_id = p_member_id
        AND return_date IS NULL;

        RETURN v_loan_count;

    END count_member_loans;


END library_pkg;
/