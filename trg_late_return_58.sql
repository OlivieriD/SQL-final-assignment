drop trigger if exists trg_late_return;
delimiter $$
create trigger trg_late_return
BEFORE UPDATE ON DETAILRENTAL
FOR EACH ROW
BEGIN
    -- If return date is NULL, set days late to NULL
    IF NEW.DETAIL_RETURNDATE IS NULL THEN
        SET NEW.DETAIL_DAYSLATE = NULL;
    ELSE
        -- Calculate days late only if the return date is not NULL
        IF NEW.DETAIL_RETURNDATE <= NEW.DETAIL_DUEDATE THEN
            SET NEW.DETAIL_DAYSLATE = 0; -- Returned on or before due date
        ELSE
            SET NEW.DETAIL_DAYSLATE = DATEDIFF(NEW.DETAIL_RETURNDATE, NEW.DETAIL_DUEDATE); -- Days late
        END IF;
    END IF;
END;
$$
delimiter ;