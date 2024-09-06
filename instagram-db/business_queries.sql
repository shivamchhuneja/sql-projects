use ig_clone;

select * from users;

-- Finding 5 oldest users (helpful for celebratory posts etc.)

select * from users
order by created_at
limit 5;

-- What day of the week most users register on? (helpful for ad and partnership campaigns)

select dayname(created_at) AS day,
	count(*) as new_users
from users
group by day
order by new_users desc;

-- Users have have completed onboarding but have 0 photos posted (helpful for in app nudges to initiate activity after onboarding)

select username from users
left join photos
	on users.id = photos.user_id
where photos.id is NULL;

-- The most liked photo (contest winners, celebratory posts etc.)

select 
	username,
    	photos.id,
	photos.image_url, 
    	count(*) as number_of_likes
from photos
inner join likes
	on likes.photo_id = photos.id
inner join users
	on photos.user_id = users.id
group by photos.id
order by number_of_likes desc
limit 1;
