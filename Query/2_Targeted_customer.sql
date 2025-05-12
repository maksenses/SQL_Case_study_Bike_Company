 SELECT
  start_station_name,
  COUNT(*) AS trip_count,
  COUNT(*) FILTER (WHERE member_casual = 'member') AS member_count,
  COUNT(*) FILTER (WHERE member_casual = 'casual') AS casual_count
FROM trip2024new
WHERE start_station_name IS NOT NULL
  AND EXTRACT(DOW FROM started_at) NOT IN (0, 6) -- excluding weekend
  AND TO_CHAR(started_at, 'HH24') IN ('06', '07', '08', '09', '15', '16', '17', '18') -- busy time
GROUP BY start_station_name
ORDER BY member_count desc, trip_count DESC 