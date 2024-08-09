# Northwind
Objective: Analysis of a social media platform

Total number of Queries: 27  <br><br>
![image](https://github.com/user-attachments/assets/3a64658a-ae1e-4189-bf4b-cbded223d4da)

---
## SNAPSHOTS  


#1 Selecting posts on basis of number of likes   <BR>

```
-- Query 2
-- Selecting posts on basis of number of likes 

SELECT users.user_id,
       users.username,
       post.caption, 
       COUNT(post_likes.user_id) AS total_likes
FROM users
LEFT JOIN post
ON users.user_id=post.user_id
LEFT JOIN post_likes
ON post.post_id=post_likes.post_id
GROUP BY users.user_id,users.username, post.caption
ORDER BY total_likes DESC;
```
![image](https://github.com/user-attachments/assets/2fff4d49-6d11-41bf-a557-6a5c41dc4b53)

<BR>

#2 Users with most combined likes on all posts  <BR>

```
SELECT users.user_id,
       username,
       COUNT(DISTINCT post.post_id) AS total_posts,
       COUNT(post_likes.user_id) AS total_likes,
       COUNT(post_likes.user_id)/COUNT(DISTINCT post.post_id) AS avg_likes_per_post
FROM users
LEFT JOIN post
ON users.user_id=post.user_id
LEFT JOIN post_likes
ON post.post_id=post_likes.post_id
GROUP BY users.user_id,username
ORDER BY total_likes DESC;
```
![image](https://github.com/user-attachments/assets/d7160173-803f-47a8-8f53-b00cfa1ffa66)

<BR>

#3 Users with No logins <BR>

```
-- Query 9
-- Users with No logins (Inactive users check)

SELECT user_id, username
FROM users
WHERE user_id NOT IN (SELECT user_id
                      FROM login)
ORDER BY user_id ASC;

```
![image](https://github.com/user-attachments/assets/36b4a734-73ea-4fb0-9663-afcf711e2386)

<BR>

#4 Users who recievd most cummulative comments on posts <BR>

```
-- Query 14
-- Users who recievd most cummulative comments on posts

SELECT users.user_id,
       username,
       COUNT(Comments.post_id) AS total_comments_recieved,
       COUNT(DISTINCT post.post_id) AS total_posts,
       COUNT(Comments.post_id)/COUNT(DISTINCT post.post_id) AS avg_comments
FROM Post
LEFT JOIN comments
ON post.post_id=comments.post_id
INNER JOIN users
ON users.user_id=post.user_id
GROUP BY users.user_id, username
ORDER BY total_comments_recieved DESC;

```
![image](https://github.com/user-attachments/assets/7cd9975c-d7ef-4cde-af8f-8f6fa8353e7e)

<BR>

#5 Selecting comments on basis of number of comment_likes <BR>

```
-- Query 18
-- Selecting comments on basis of number of comment_likes

SELECT users.user_id,
       username,
       comment_text,
       COUNT(comment_likes.comment_id) AS total_comment_likes
FROM comments
LEFT JOIN users
ON users.user_id=comments.user_id
LEFT JOIN comment_likes
ON comments.comment_id=comment_likes.comment_id
GROUP BY users.user_id, username,comment_text
ORDER BY total_comment_likes DESC;
```

![image](https://github.com/user-attachments/assets/3b2dad5b-5c46-4a15-93b7-1717c8d47313)

<BR>

#6 Selecting users on basis of followers  <BR>

```
-- Query 24
-- Selecting users on basis of followers

SELECT  user_id,
        username,
        COUNT(followee_id) AS total_followers
FROM users
LEFT JOIN follows
ON user_id=follower_id
WHERE follower_id != followee_id
GROUP BY user_id, username
ORDER BY total_followers DESC;

```
![image](https://github.com/user-attachments/assets/58462382-eefa-4f16-8fd7-0d3f06a252d8)

<BR>



