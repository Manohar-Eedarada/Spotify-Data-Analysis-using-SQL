-- CREATE SQL DATABASE;
create database sqlproject2;

use sqlproject2;

-- CRETEINA A TABLE NAME SPOTIFY.
CREATE TABLE spotifyproject (
    Artist VARCHAR(255),
    Track VARCHAR(255),
    Album VARCHAR(255),
    Album_type VARCHAR(50),
    Danceability FLOAT,
	Energy FLOAT,
    Loudness FLOAT,
    Speechiness FLOAT,
    Acousticness FLOAT,
    Instrumentalness FLOAT,
    Liveness FLOAT,
    Valence FLOAT,
    Tempo FLOAT,
    Duration_min FLOAT,
    Title VARCHAR(255),
    Channel VARCHAR(255),
    Views FLOAT,
    Likes BIGINT,
    Comments BIGINT,
    Licensed BOOLEAN,
    Official_video BOOLEAN,
    Stream BIGINT,
    Energy_liveness FLOAT,
    most_playedon VARCHAR(50)
);
-- import data by right click on table name adn improt data  click on finish.
select * 
from 
spotifyproject;

-- EDA
select 
count(*) AS NOOFROWS 
from 
spotifyproject;

SELECT 
distinct Album 
from 
spotifyproject;

SELECT 
count( distinct Album) 
from 
spotifyproject;

SELECT 
	count(distinct Artist)
 from 
	spotifyproject;
 
SELECT distinct Album_type 
from spotifyproject;

SELECT MAX(Duration_min) 
FROM spotifyproject;
SELECT MIN(Duration_min) 
FROM spotifyproject;

SELECT * 
FROM 
spotifyproject
where Duration_min=0;

delete 
FROM 
spotifyproject
where Duration_min=0;

SELECT * FROM spotifyproject
where Duration_min=0;

SELECT 
	distinct Channel 
from 
	spotifyproject;

SELECT 
	distinct most_playedon 
from 
	spotifyproject;

-- -----------------------------------------------------------------------------
-- Easy Category Business Problems OR DATA ANALYSIS ??
-- -----------------------------------------------------------------------------

-- 1.Rrtrive the names of all tracks that have more than 1 billon streams??
SELECT
	* 
FROM spotifyproject
where Stream >1000000000;

SELECT 
	COUNT(*) 
FROM spotifyproject
where Stream >1000000000;

-- 2.LIST ALL ALBUMS WITH THERE RESPECTIVE ALBUM??
SELECT 
 distinct Album,
 Artist
 FROM spotifyproject
 order by 1;
 
 
 -- 3.get the total no of comments for tracks wher licensed = true ?/
 
 select 
	sum(Comments) as totalcomments
from spotifyproject
 where Licensed='True';
 
 -- 4.find all the tracks belong to album type single?
 
 select * 
 from 
 spotifyproject
 where Album_type='single';
 
 -- 5.count the total no of tracks by each artst?
 select Artist,count(*) as no_of_songs
 from 
 spotifyproject
 group by Artist
 order by 2 desc;
 
 ----------------------------------------------------------------------------------------------
 -- medium level
 ----------------------------------------------------------------------------------------------
 -- 6. calcualte the avg danceability of tracks in each album???
  select 
	Album,
	avg(Danceability) as avg_danceability
 from 
	spotifyproject
group by Album
order by 2 desc;
 
 -- 7. find the top 5 tracks with higest energy value?
select
	Track, 
    max(Energy) as top_energy
 from 
 spotifyproject
 group by 
	Track
 order by 
	2 desc
 limit 5;
  
 -- 8.list all the tracks along with there views and likes wher offically='true'?
 
select 
	Track,
	sum(Views) as views,
    sum(Likes) as likes
from 
spotifyproject
where Official_video='true'
group by Track
order by 2 desc
limit 10;
 
-- 9.for each album calculate the totalviews of all associated tracks?
select
    Album,
	Track,
    sum(Views) as views
from 
	spotifyproject
group by 1 ,2
ORDER BY 3 DESC;

-- 10.RETRIVE THE TRACK NAME THAT HAVE STREAD IN SPOTIFY MORE THAN YOUTUBE?

SELECT 
* FROM
	(
	select 
		Track,
		coalesce(sum(case when most_playedon = 'youtube'then Stream end),0)as streamed_on_youtube,
		coalesce(sum(case when most_playedon = 'spotify'then Stream end),0)as streamed_on_spotify
	from 
		spotifyproject
	group by 
    Track
	) AS T1
WHERE streamed_on_spotify > streamed_on_youtube
and
streamed_on_youtube <>0;

-- -------------------------------------------------------------------------------------------------------------------
-- ADVANCED PROBLEMS
-- ------------------------------------------------------------------------------------------------------------------- 
-- 11.FIND THE TOP 3 MOST VIEWED TRACKS FOR EACH ARTIST USING WINDOW FUNCTION.

-- each artist and total view for each track
-- track with highest view for artist (we need top)
-- dense rank
-- cte and filter rank<=3

with ranking_artist as
(SELECT 
	Artist,
    Track,
    sum(Views) as total_views,
    dense_rank() over(partition by Artist order by sum(Views) desc)  as ranking
FROM spotifyproject
group by 1,2
order by 1,3 desc)
select* from ranking_artist
where ranking<=3;


-- 12 write a query to find tracks where the kiveness score is above avaerage?
select 
	Track,
    Artist,
    Liveness
from 
	spotifyproject 
where LIveness >(select 
					avg(Liveness) 
                    from 
                    spotifyproject);
                    
-- 13. use a with class to find the difference between highest and lowest energy value for each album

with cte as (
select
	Album,
    max(Energy) as max_energy,
    min(Energy) as min_energy
from spotifyproject
group by 1)
 select
	Album,
    max_energy-min_energy as order_difference 
from
	cte
order by 1 desc;

-- ----------------------------------------------------------------------------------------------------
-- ---------------------end of project ----------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------------------------------------------