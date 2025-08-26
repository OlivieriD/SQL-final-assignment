drop procedure if exists prc_new_rental;
delimiter $$

create procedure prc_new_rental (in p_mem_num int)
begin

	DECLARE member_balance DECIMAL(10,2);
    
	if (select count(*) from membership where MEM_NUM = p_mem_num) = 0 then
		signal sqlstate '45000'
        set message_text= 'Membership does not exist.';
	else
    
        SELECT MEM_BALANCE INTO member_balance
        FROM MEMBERSHIP
        WHERE MEM_NUM = p_mem_num;
        
        select concat('Previous Balance: $', FORMAT(member_balance, 2)) AS Balance_Message;
        
         INSERT INTO RENTAL (RENT_DATE, MEM_NUM)
        VALUES (CURRENT_DATE, p_mem_num);
    END IF;
END;

$$
delimiter ;

CALL prc_new_rental(103);