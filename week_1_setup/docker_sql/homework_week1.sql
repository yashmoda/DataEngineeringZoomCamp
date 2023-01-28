-- Trips on Jan 15

SELECT count(*)
FROM green_taxi_data
where lpep_dropoff_datetime::date = '2019-01-15'
  and lpep_pickup_datetime::date = '2019-01-15'
;

-- Which was the day with the largest trip distance Use the pick up time for your calculations

SELECT lpep_pickup_datetime::date
FROM green_taxi_data
where trip_distance = (SELECT max(trip_distance) FROM green_taxi_data);

-- In 2019-01-01 how many trips had 2 and 3 passengers?

SELECT passenger_count, count(*)
FROM green_taxi_data
where lpep_pickup_datetime::date = '2019-01-01'
  and passenger_count in (2, 3)
group by passenger_count
;

-- For the passengers picked up in the Astoria Zone which was the drop off zone that had the largest tip? We want the name of the zone, not the id

with pick_up_zone_data as (SELECT "DOLocationID", max(tip_amount) as max_tip
                           FROM green_taxi_data
                                    left join
                                zone_data zd on green_taxi_data."PULocationID" = zd."LocationID"
                           where "Zone" = 'Astoria'
                           group by "DOLocationID"),
     drop_off_data as (SELECT pick_up_zone_data.*, zone_data."Zone" as drop_off_zone
                       FROM pick_up_zone_data
                                left join zone_data on pick_up_zone_data."DOLocationID" = zone_data."LocationID")
SELECT *
FROM drop_off_data
where max_tip = (SELECT max(max_tip) from drop_off_data)
;