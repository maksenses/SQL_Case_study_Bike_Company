------- Weekly Trend of Bicycle Trip Count by User Type ----------
SELECT 
  member_casual,
  EXTRACT(DOW FROM started_at) AS day_of_week,
  TO_CHAR(started_at, 'Day') AS day_name,
  COUNT(*) AS trip_count
FROM trip2024_clean
GROUP BY member_casual, day_of_week, day_name
ORDER BY member_casual, trip_count DESC;

---Weekday vs Weekend trip count by user type-----
SELECT
	member_casual,
  CASE 
    WHEN EXTRACT(DOW FROM started_at) IN (0,6) THEN 'weekend'
    ELSE 'weekday'
  END AS day_type,
  COUNT(*) AS trip_count
FROM trip2024_clean
where start_station_name is not null
group by member_casual, day_type

------ The frequently used start stations for member and casual users --------
SELECT *
FROM (
  SELECT 
    COUNT(*) AS trip_count,
    t.member_casual,
    t.start_station_name,
    ROW_NUMBER() OVER (
      PARTITION BY t.member_casual ORDER BY COUNT(*) DESC
    ) AS rank
  FROM trip2024_clean t
  WHERE t.start_station_name IS NOT NULL
  GROUP BY t.member_casual, t.start_station_name
) sub
where rank between 1 and 10; 

------- Average trip duration by User Type ----------
with duration as (
select 
member_casual,
ended_at - started_at as duration
from trip2024new
)
select
member_casual,
avg(duration)
from duration
group by "member_casual";

------- Average trip distance by User Type ---------
with jarak as (
SELECT
  member_casual,
  started_at,
  ended_at,
  start_lat,
  start_lng,
  end_lat,
  end_lng,
  6371 * acos(
    LEAST(1, GREATEST(-1,
      cos(radians(start_lat)) * cos(radians(end_lat)) *
      cos(radians(end_lng) - radians(start_lng)) +
      sin(radians(start_lat)) * sin(radians(end_lat))
    ))
  ) AS distance_km
FROM trip2024_clean
ORDER BY distance_km DESC
)
select 
member_casual,
avg(distance_km) as avgdsitance
from jarak
group by member_casual;

------- The peak hours of usage within a day vary by user type --------
SELECT 
  member_casual,
  EXTRACT(HOUR FROM started_at) AS hour,
  COUNT(*) AS trip_count
FROM trip2024new
WHERE start_station_name IS NOT NULL
GROUP BY hour, member_casual
ORDER BY hour

------- The busiest stations during peak hours vary by user type -------  
 SELECT
  start_station_name,
  COUNT(*) AS trip_count,
  COUNT(*) FILTER (WHERE member_casual = 'member') AS member_count,
  COUNT(*) FILTER (WHERE member_casual = 'casual') AS casual_count
FROM trip2024new
WHERE start_station_name IS NOT NULL
  AND EXTRACT(DOW FROM started_at) NOT IN (0, 6) -- hanya weekday
  AND TO_CHAR(started_at, 'HH24') IN ('06', '07', '08', '09', '15', '16', '17', '18') -- jam sibuk
GROUP BY start_station_name
ORDER BY casual_count DESC; 