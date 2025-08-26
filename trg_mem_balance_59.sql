DELIMITER $$
drop trigger if exists trg_mem_balance ;
CREATE TRIGGER trg_mem_balance
AFTER UPDATE ON DETAILRENTAL
FOR EACH ROW
BEGIN
declare rental_member int;

    DECLARE previous_fee DECIMAL(10,2);
    DECLARE current_fee DECIMAL(10,2);
    DECLARE fee_difference DECIMAL(10,2);

    -- Calculate the prior and current late fees
    SET previous_fee = OLD.DETAIL_DAYSLATE * OLD.DETAIL_DAILYLATEFEE;
    SET current_fee = NEW.DETAIL_DAYSLATE * NEW.DETAIL_DAILYLATEFEE;

    -- Handle NULL fees
    IF previous_fee IS NULL THEN
        SET previous_fee = 0;
    END IF;

    IF current_fee IS NULL THEN
        SET current_fee = 0;
    END IF;

    -- Calculate the difference
    SET fee_difference = current_fee - previous_fee;

    -- Update membership balance if there is a change
    IF fee_difference <> 0 THEN
        select mem_num into rental_member from rental where rent_num = new.rent_num;
        UPDATE MEMBERSHIP
        SET MEM_BALANCE = MEM_BALANCE + fee_difference
        WHERE MEM_NUM = rental_member;
    END IF;
END;

$$

DELIMITER ;
select * from membership;
update detailrental
set detail_returndate  = '2022-04-05'
where rent_num = 1008;