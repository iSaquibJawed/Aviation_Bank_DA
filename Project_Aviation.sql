CREATE DATABASE P_AVIATION;
USE P_Aviation;
CREATE TABLE Data_1 
(
Year Int,
Quarter Int,
Month Int,
DayofMonth Int,
DayOfWeek Int,
FlightDate varchar(255),
UniqueCarrier Varchar(255),
AirlineID Int,
Carrier Varchar(255),
TailNum Varchar(255),
FlightNum Int,
OriginAirportID Int,
OriginAirportSeqID Int,
OriginCityMarketID Int,
Origin varchar(255),
OriginCityName varchar(255),
OriginState varchar(255),
OriginStateFips int,
OriginStateName varchar(255),
OriginWac int,
DestAirportID int,
DestAirportSeqID int,
DestCityMarketID int,
Dest varchar(255),
DestCityName varchar(255),
DestState varchar(255),
DestStateFips int,
DestStateName varchar(255),
DestWac int,
CRSDepTime varchar(255),
DepTime varchar(255),
DepDelay varchar(255),
DepDelayMinutes varchar(255),
DepDel15 varchar(255),
DepartureDelayGroups varchar(255),
DepTimeBlk varchar(255),
Indexx Int NOT NUll,
WeekNum Int,
PRIMARY KEY (Indexx)
);

CREATE TABLE Data_2
(
AirlineID int,
TailNum varchar(255),
TaxiOut int NULL,
WheelsOff int NULL,
WheelsOn int NULL,
TaxiIn int NULL,
CRSArrTime int NULL,
ArrTime int NULL,
ArrDelay int NULL,
ArrDelayMinutes int NULL,
ArrDel15 int NULL,
ArrivalDelayGroups int NULL,
ArrTimeBlk varchar(255) NULL,
Cancelled int NULL,
Diverted int NULL,
CRSElapsedTime int NULL,
ActualElapsedTime int NULL,
AirTime int NULL,
Flights int NULL,
Distance int NULL,
DistanceGroup int NULL,
Indexx int NOT NULL,
PRIMARY KEY (Indexx)
);

SELECT * FROM data_1;


/*---------------------- KPI 1 - Weekday vs Weekend total flights --------------------------------------- */

CREATE VIEW view_week_day_end_flights AS
	SELECT 	DayOfWeek,
		IF((DayOfWeek) > 5, 'weekend', 'weekday') AS week_day_end FROM data_1;
SELECT week_day_end,
	COUNT(*) AS total_flights FROM view_week_day_end_flights
    GROUP BY week_day_end;
    
SELECT * FROM view_week_day_end_flights;


/*-------------- ------- KPI 2 Cancelled Flights for Honolulu ----------------------------------------------*/
SELECT a.OriginCityName, count(b.Cancelled) Cancelled
FROM
	data_1 a LEFT JOIN  data_2 b ON a.Indexx = b.Indexx
WHERE
	a.OriginCityName = "Honolulu, HI" AND Cancelled = 1;
    
/* ------------------- KPI 3 Weekwise Statistics of flights Arrivals & Departure  Manchester -------------- */ 

  SELECT WEEK(FlightDate) AS WeekNo,
    SUM(CASE WHEN OriginCityName = 'Manchester, NH' THEN 1 ELSE 0 END)AS Departure,
    SUM(CASE WHEN DestCityName = 'Manchester, NH' THEN 1 ELSE 0 END) AS Arrival
FROM
	data_1
GROUP BY WeekNo
ORDER BY WeekNo;
/* ------------------------------------------------------------------------------------------------------- */
UPDATE data_1 SET FlightDate = STR_TO_DATE(FlightDate, '%d-%m-%Y');
ALTER TABLE data_1 CHANGE FlightDate FlightDate DATE NULL DEFAULT NULL;

    
/*-------------------- KPI 4 Total distance covered by N190AA --------------------------------------------  */
 
/* DELIMITER //
 CREATE PROCEDURE pro_total_distance(m_tailnum varchar(50), m_date date)
 begin
 SELECT
 b.airtime AS airtime, b.distance AS total_distance
 FROM
	data_1 a
		JOIN
	data_2 b ON a.Indexx = b.Indexx
WHERE
	a.tailnum = m_tailnum
		AND a.FlightDate = m_date
ORDER BY airtime;
end //
DELIMITER //

CALL pro_total_distance('N190AA',20-01-2017); */


/*-------------------- KPI 4 Total distance covered by N190AA --------------------------------------------  */

SELECT a.TailNum, a.FlightDate,b.AirTime, sum(b.Distance)Total_Distance
	FROM
	data_1 a LEFT JOIN  data_2 b ON a.Indexx = b.Indexx
	WHERE
	a.TailNum = "N190AA" AND a.FlightDate = '2017-01-20' GROUP BY b.AirTime; 
    
  
  
  
  
  SELECT * from data_1;
    
