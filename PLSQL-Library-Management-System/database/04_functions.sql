CREATE OR REPLACE FUNCTION get_available_copies (
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
END;
/


CREATE OR REPLACE FUNCTION calculate_fine (
    p_due_date    IN DATE,
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

    v_days_late := TRUNC(p_return_date) - TRUNC(p_due_date);

    v_fine := v_days_late * 5;

    RETURN v_fine;

END;
/


CREATE OR REPLACE FUNCTION count_member_loans (
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

END;
/