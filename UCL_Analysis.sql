--TOP 10 Forwards with highest conversion rate (more than 10 attempts)
SELECT TOP 10 a.player_name, goals, total_attempts, (cast(goals as FLOAT)/total_attempts) * 100 AS efficiency
FROM PortfolioProject.dbo.attempts as a
JOIN PortfolioProject.dbo.goals as g
ON a.player_name = g.player_name
WHERE a.position = 'Forward'and total_attempts > 10
ORDER BY efficiency DESC

--TOP 10 Players with highest avg goal per match
SELECT TOP 10 player_name, club, position, CAST(goals AS FLOAT)/match_played as avggoal
FROM  PortfolioProject.dbo.goals
ORDER BY avggoal DESC

--Top 10 pLayers with highest goals + assists
SELECT TOP 10 g.player_name, g.club, g.position, goals+assists as GA,  (cast (goals as float)+assists)/g.match_played AS GA_per_match
FROM PortfolioProject.dbo.goals as g
JOIN PortfolioProject.dbo.attacking as a
ON g.player_name = a.player_name
ORDER BY ga DESC

--TOP 5 players with highest crossing success rate (each position)
WITH therank AS 
(SELECT DENSE_RANK()OVER(PARTITION BY position ORDER BY cast(cross_complted as float)/cross_attempted * 100 DESC) AS RANKING, player_name, club, position, ROUND(cast(cross_complted as float)/cross_attempted, 2) * 100 as cross_rate
FROM PortfolioProject.dbo.distributon
WHERE cross_attempted > 5)

SELECT *
FROM therank
WHERE ranking BETWEEN 1 AND 10
ORDER BY position DESC


--Players with high successful passing rate
with therank as
(SELECT DENSE_RANK()OVER(PARTITION BY position ORDER BY cast(pass_completed as float)/pass_attempted*100 DESC) AS ranking, player_name, club, position, round(cast(pass_completed as float)/pass_attempted*100, 2) as success_rate
FROM PortfolioProject.dbo.distributon)

SELECT *
FROM therank
WHERE ranking BETWEEN 1 AND 10
ORDER BY position DESC


--Defenders with the most fouls commited per minute
SELECT player_name, club position,  cast(fouls_committed as float)/minutes_played as avg_foul_per_minute
FROM PortfolioProject.dbo.disciplinary
WHERE position = 'Defender'
ORDER BY avg_foul_per_minute DESC

--Players with high succesfull tackle rate (more than 5 attempts)
SELECT player_name, position, club, cast(t_won as float)/tackles * 100 as tackling_rate
FROM  PortfolioProject.dbo.defending
where tackles > 5
ORDER BY position, tackling_rate DESC


--Top Performing goalkeepers
SELECT player_name, conceded, match_played, round(CAST(conceded as float)/match_played, 2) as avg_goal_conced
FROM  PortfolioProject.dbo.goalkeeping
WHERE match_played > 5
ORDER BY avg_goal_conced 

--Top 5 teams that scored the most
SELECT top 5 club, SUM(goals) ttlgoals
FROM PortfolioProject.dbo.goals
GROUP BY club
ORDER BY ttlgoals DESC

--Top 5 teams that highest goal difference
WITH goal AS
(SELECT club, sum(goals) ttlgoals
FROM PortfolioProject.dbo.goals
GROUP BY club)

, conced AS
(SELECT club, sum(conceded) ttlcon
FROM PortfolioProject.dbo.goalkeeping
GROUP BY club)

SELECT top 5 g.club, ttlgoals - ttlcon as goaldiff
FROM goal as g
JOIN conced as c
ON g.club = c.club
ORDER BY goaldiff DESC






