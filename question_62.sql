

DELIMITER $$
DROP PROCEDURE IF EXISTS prc_new_detail $$
CREATE PROCEDURE prc_new_detail (IN video_num INT)
BEGIN
    DECLARE video_exists INT;
    DECLARE vid_status ENUM('IN', 'OUT', 'LOST');
    DECLARE rent_fee DECIMAL(10, 2);
    DECLARE daily_late_fee DECIMAL(10, 2);
    DECLARE rent_days INT;
    DECLARE due_date DATETIME;

    SELECT COUNT(*), VID_STATUS INTO video_exists, vid_status
    FROM VIDEO
    WHERE VID_NUM = video_num;

    IF video_exists = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Video does not exist.';
    ELSEIF vid_status != 'IN' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Video is not available for rental.';
    ELSE
        SELECT PRICE_RENTFEE, PRICE_DAILYLATEFEE, PRICE_RENTDAYS
        INTO rent_fee, daily_late_fee, rent_days
        FROM PRICE P
        JOIN MOVIE M ON P.PRICE_CODE = M.PRICE_CODE
        JOIN VIDEO V ON M.MOVIE_NUM = V.MOVIE_NUM
        WHERE V.VID_NUM = video_num;

        SET due_date = DATE_ADD(CURRENT_TIMESTAMP(), INTERVAL rent_days DAY);
        INSERT INTO DETAILRENTAL (RENT_NUM, VID_NUM, DETAIL_FEE, DETAIL_DUEDATE, DETAIL_RETURNDATE, DETAIL_DAILYLATEFEE)
        VALUES ((SELECT MAX(RENT_NUM) FROM RENTAL), video_num, rent_fee, due_date, NULL, daily_late_fee);

        UPDATE VIDEO
        SET VID_STATUS = 'OUT'
        WHERE VID_NUM = video_num;

         SELECT CONCAT('Video ', video_num, ' has been rented') AS Message,
               (SELECT MAX(RENT_NUM) FROM RENTAL) AS RENT_NUM,
               rent_fee AS Rent_Fee,
               due_date AS Due_Date,
               daily_late_fee AS Daily_Late_Fee;
    END IF;
END
$$
DELIMITER ;

CALL prc_new_detail(34366);
CALL prc_new_detail(11141);