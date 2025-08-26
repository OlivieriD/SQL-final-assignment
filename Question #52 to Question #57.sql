-- Question #52
alter table detailrental
add column DETAIL_DAYSLATE int(3);

-- Question #53
ALTER TABLE DETAILRENTAL
MODIFY COLUMN DETAIL_RETURNDATE DATETIME;

-- Question #54
ALTER TABLE VIDEO
ADD COLUMN VID_STATUS VARCHAR(4) DEFAULT 'IN',
ADD CONSTRAINT CHECK_VID_STATUS CHECK (VID_STATUS IN ('IN', 'OUT', 'LOST'));

-- Question #55
update video
set VID_STATUS = 'OUT';

-- Question #56
alter table price
add column PRICE_RENTDAYS int(3) not null default 3;

-- Question #57
update price
set PRICE_RENTDAYS = 5
where PRICE_CODE = 1;

update price
set PRICE_RENTDAYS = 3
where PRICE_CODE = 2;

update price
set PRICE_RENTDAYS = 5
where PRICE_CODE = 3;

update price
set PRICE_RENTDAYS = 7
where PRICE_CODE = 4;
