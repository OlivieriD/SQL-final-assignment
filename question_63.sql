DELIMITER $$
DROP PROCEDURE IF EXISTS prc_return_video $$
CREATE PROCEDURE prc_return_video (IN video_num INT)
BEGIN
    DECLARE video_exists INT;
    DECLARE outstanding_rentals INT;
    DECLARE late_days INT;
    SELECT COUNT(*) INTO video_exists
    FROM VIDEO
    WHERE VID_NUM = video_num;

    IF video_exists = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Video does not exist.';
    ELSE
        SELECT COUNT(*) INTO outstanding_rentals
        FROM DETAILRENTAL
        WHERE VID_NUM = video_num AND DETAIL_RETURNDATE IS NULL;

        IF outstanding_rentals = 0 THEN
            UPDATE VIDEO
            SET VID_STATUS = 'IN'
            WHERE VID_NUM = video_num;

            SELECT CONCAT('Video ', video_num, ' had no outstanding rentals and is available for rental.') AS Message;
        ELSEIF outstanding_rentals > 1 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Video has outstanding rentals.';
        ELSE
            UPDATE DETAILRENTAL
            SET DETAIL_RETURNDATE = CURRENT_TIMESTAMP()
            WHERE VID_NUM = video_num AND DETAIL_RETURNDATE IS NULL;

            SELECT DATEDIFF(CURRENT_TIMESTAMP(), DETAIL_DUEDATE) INTO late_days
            FROM DETAILRENTAL
            WHERE VID_NUM = video_num AND DETAIL_RETURNDATE = CURRENT_TIMESTAMP();
IF late_days > 0 THEN
                UPDATE DETAILRENTAL
                SET DETAIL_DAYSLATE = late_days
                WHERE VID_NUM = video_num AND DETAIL_RETURNDATE = CURRENT_TIMESTAMP();
            ELSE
                UPDATE DETAILRENTAL
                SET DETAIL_DAYSLATE = 0
                WHERE VID_NUM = video_num AND DETAIL_RETURNDATE = CURRENT_TIMESTAMP();
            END IF;

            UPDATE VIDEO
            SET VID_STATUS = 'IN'
            WHERE VID_NUM = video_num;

            SELECT CONCAT('Video ', video_num, ' was successfully returned.') AS Message;
        END IF;
    END IF;
END
$$
DELIMITER ;

 
CALL prc_return_video(34342);
CALL prc_return_video(12345);