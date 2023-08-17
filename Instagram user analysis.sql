# Instagram User Analytics;
# Description;
# User Analysis is the process by which we track how user engage and interact with our 
# digtal product (Software or Mobile Application)
# in an attempt to derive business insights for marketing, product & developement teams.


use ig_clone;

-- 1. find 5 most oldest user of the instagram from database provided.

select * from users;

select username, created_at
from users
order by created_at desc
limit 5;

-- 2. Find a user who never posted a single photo on instagram.

select * from photos, users;

select u.username
from users u
left join photos p
on u.id = p.user_id
where p.image_url is null
order by u.username;

-- 3. Identify the winner of contest and provide their details to the teams

select * from likes, photos, users;

select likes.photo_id, users.username, count(likes.user_id) as number_of_likes
from likes
inner join photos on likes.photo_id = photos.id
inner join users on photos.user_id = users.id
group by likes.photo_id, users.username 
order by number_of_likes desc;

-- 4. Identify and suggest top 5 most commonly used hashtags on the platform

select * from photo_tags, tags;

select t.tag_name, count(p.photo_id) hit
from tags t
inner join photo_tags p
on p.tag_id = t.id
group by tag_name
order by hit desc
limit 5;

-- 5. What day of the week do most users register on? 
-- Provide insight on when to scedule an ad campaign

select * from users;

select date_format((created_at), '%W') week, count(username) new_register_user
from users
group by week
order by new_register_user desc;

-- 6. Provide how many times does avereage user post on instagram Also, Provide the total number of
-- photos on instagram/total number of users. 
select * from users, photos;

with base as(
select u.id as user_id, count(p.id) as photo_id
from users u
left join photos p on u.id = p.user_id
group by u.id)
select sum(photo_id) as total_photo, count(user_id) as total_user, sum(photo_id)/count(user_id) as photo_per_user
from base;

-- 7. provide data on users (bots) who have liked every single photo on the site
-- (since any normal user would not be able to do this)

select * from users, likes;

with base as(
select u.username, count(l.photo_id) as likess
from users u
inner join likes l on u.id = l.user_id
group by u.username)
select username, likess from base
where likess = (select count(*) from photos) 
order by username;

