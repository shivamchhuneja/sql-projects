use ig_clone;

select * from users;

-- Finding 5 oldest users

select * from users
order by created_at
limit 5;

-- What day of the week most users register on?

select dayname(created_at) AS day,
	count(*) as new_users
from users
group by day
order by new_users desc;

-- Users have have completed onboarding but have 0 activity

select username 