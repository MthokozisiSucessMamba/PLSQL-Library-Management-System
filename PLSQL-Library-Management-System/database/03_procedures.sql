CREATE OR REPLACE PROCEDURE borrow_book (
    p_member_id IN NUMBER,
    p_book_id   IN NUMBER
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
        RAISE_APPLICATION_ERROR(-20001, 'Member does not exist.');
    END IF;


    
    SELECT COUNT(*)
    INTO v_book_count
    FROM library_books
    WHERE book_id = p_book_id;

    IF v_book_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Book does not exist.');
    END IF;


    
    SELECT available_copies
    INTO v_available_copies
    FROM library_books
    WHERE book_id = p_book_id;

    IF v_available_copies <= 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'No copies of this book are available.');
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
        'Due date: ' || TO_CHAR(SYSDATE + 14, 'DD-MON-YYYY')
    );

END;
/

BEGIN
    borrow_book(1, 1);
END;
/

SELECT * FROM library_loans;
SELECT book_id, title, available_copies
FROM library_books
WHERE book_id = 1;