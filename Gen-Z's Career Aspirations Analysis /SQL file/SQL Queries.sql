use genzdb;
show tables;

select * from learning_aspirations;
select * from manager_aspirations;
select * from mission_aspirations;
select * from personalized_info;

select * from learning_aspirations as l 
join manager_aspirations as m on l.ResponseID = m.ResponseID
join mission_aspirations as mi on m.ResponseID = mi.ResponseID
join personalized_info as p on mi.ResponseID = p.ResponseID;

-- 1. What percentage of male and female GenZ wants to go office everyday?
select (count(case when PreferredWorkingEnvironment = "Every Day Office Environment" then PreferredWorkingEnvironment end)/ count(Gender))*100 as percentage from learning_aspirations as l
join personalized_info as p on l.ResponseID = p.ResponseID;

-- 2. What percentage of GenZs who have choosen their career as Business Operations are more likely to be influenced by their parents?
SELECT (COUNT(*) / (SELECT COUNT(*) FROM learning_aspirations)) * 100 AS percentage
FROM learning_aspirations
WHERE closestAspirationalCareer LIKE 'Business Operations%' AND CareerInfluenceFactor = 'My Parents';

-- 3. What percentage of GenZs prefer opting for higher studies, give a gender wise approach?
select count(case when Gender = 'Female\r' then Gender end)/(select count(*) from learning_aspirations)*100 as Female_per, 
count(case when Gender = 'Male\r' then Gender end)/(select count(*) from learning_aspirations)*100 as Male_per from learning_aspirations as l
join personalized_info as p on l.ResponseID = p.ResponseID
;

-- 4. What percent of GenZ are willing & not willing to work for the company whose mission is misaligned with their public actions or even their
-- products? (Give Gender based split).
select (count(case when Gender = 'Male\r' then p.ResponseID end)/(select count(*) from personalized_info) *100) as Male, 
(count(case when Gender = 'Female\r' then p.ResponseID end)/(select count(*) from personalized_info) *100) as Female
from personalized_info as p
join mission_aspirations as mi on p.ResponseID= mi.ResponseID
;

-- 5. What is the most suitable working environment according to female GenZ?
select PreferredWorkingEnvironment from
(
select PreferredWorkingEnvironment, count(PreferredWorkingEnvironment) as cnt  from learning_aspirations as l
join personalized_info as p on l.ResponseID = p.ResponseID
where Gender = 'Female\r'
group by PreferredWorkingEnvironment) as a
order by cnt desc limit 1;

-- 6. Calculate the total number of female who aspire to work in their closest aspirational career and have no social impact likelyhood of 1 to 5?
select count(Gender) as cnt from personalized_info as p
join learning_aspirations as l on p.ResponseID = l.ResponseID
join mission_aspirations as mi on mi.ResponseID = l.ResponseID
where Gender = 'Female\r' and NoSocialImpactLikelihood between 1 and 5;

-- 7. Retrieve the male who are interested in Higher education abroad and have a career influence factor of "My Parents"?
select count(Gender) as cnt from personalized_info as p
join learning_aspirations as l on p.ResponseID = l.ResponseID
where CareerInfluenceFactor = 'My Parents' and HigherEducationAbroad = 'Yes, I wil';

-- 8. Determine the percentage of gender who have a No social impact likelyhood of "8 to 10" among those who are interested in Higher Education Abroad?
select (count(Gender) / (select count(*) from  personalized_info)) *100 as percent from personalized_info as p
join mission_aspirations as mi on mi.ResponseID = p.ResponseID
join learning_aspirations as l on mi.ResponseID = l.ResponseID
where NoSocialImpactLikelihood between 8 and 10 and HigherEducationAbroad = 'Yes, I wil';

-- 9. Give a detailed split of GenZ prefrences to work with teams, Data should include male, female and overall in counts and also the overall in %?
select count(case when Gender = 'Male\r' then p.ResponseID end) as Male, 
count(case when Gender = 'Female\r' then p.ResponseID end) as Female, 
(count(*)/(select count(*) from personalized_info)*100) as overall_percent from personalized_info as p 
join manager_aspirations as m on m.ResponseID = p.ResponseID
where PreferredWorkSetup like "%team%";

-- 10. Give a detailed breakdown of "WorkLikelihood3Years" for each Gender?
select Gender, WorkLikelihood3Years, count(WorkLikelihood3Years) as cnt from manager_aspirations as m
join personalized_info as p on  m.ResponseID = p.ResponseID
group by Gender;

-- 11. Give a detailed breakdown of "WorkLikelihood3Years" for each state?
select ZipCode, WorkLikelihood3Years, count(WorkLikelihood3Years) as cnt from manager_aspirations as m
join personalized_info as p on  m.ResponseID = p.ResponseID
group by ZipCode;

-- 12. What is the average starting salary expectations at 3 year mark for each Gender?
select  Gender, concat(avg(REGEXP_SUBSTR(left(ExpectedSalary3Years,3), '[0-9]+')), " k") as avg_starting_sal_exp_3yr from mission_aspirations as m
join personalized_info as p on p.ResponseID = m.ResponseID
group by Gender;

-- 13. What is the average starting salary expectations at 5 year mark for each Gender?
select  Gender, concat(avg(REGEXP_SUBSTR(left(ExpectedSalary5Years,3), '[0-9]+')), " k") as avg_starting_sal_exp_5yr from mission_aspirations as m
join personalized_info as p on p.ResponseID = m.ResponseID
group by Gender;

-- 14. What is the average Higher Bar salary expectations at 3 year mark for each Gender?
select Gender, concat(avg(REGEXP_SUBSTR(right(ExpectedSalary3Years,3), '[0-9]+')), " k") as avg_high_sal_exp_3yr from mission_aspirations as m
join personalized_info as p on p.ResponseID = m.ResponseID
group by Gender;

-- 15. What is the average Higher Bar salary expectations at 5 year mark for each Gender?
select Gender, concat(avg(REGEXP_SUBSTR(right(ExpectedSalary5Years,4), '[0-9]+')), " k") as avg_high_sal_exp_5yr from mission_aspirations as m
join personalized_info as p on p.ResponseID = m.ResponseID
group by Gender;

-- 16. What is the average starting Bar salary expectations at 3 year mark for each Gender and each state in India? 
select Gender, zipcode, concat(avg(REGEXP_SUBSTR(left(ExpectedSalary3Years,3), '[0-9]+')), " k") as avg_start_sal_exp_3yr from mission_aspirations as m
join personalized_info as p on p.ResponseID = m.ResponseID
where CurrentCountry ='India'
group by Gender,zipcode;

-- 17. What is the average starting Bar salary expectations at 5 year mark for each Gender and each state in India? 
select Gender, zipcode, concat(avg(REGEXP_SUBSTR(left(ExpectedSalary5Years,3), '[0-9]+')), " k") as avg_start_sal_exp_5yr from mission_aspirations as m
join personalized_info as p on p.ResponseID = m.ResponseID
where CurrentCountry ='India'
group by Gender, zipcode;

-- 18. What is the average Higher Bar salary expectations at 3 year mark for each Gender and each state in India? 
select Gender, zipcode, concat(avg(REGEXP_SUBSTR(right(ExpectedSalary3Years,3), '[0-9]+')), " k") as avg_high_sal_exp_3yr from mission_aspirations as m
join personalized_info as p on p.ResponseID = m.ResponseID
where CurrentCountry ='India'
group by Gender, zipcode;

-- 19. What is the average Higher Bar salary expectations at 5 year mark for each Gender and each state in India? 
select Gender, zipcode, concat(avg(REGEXP_SUBSTR(right(ExpectedSalary5Years,5), '[0-9]+')), " k") as avg_high_sal_exp_5yr from mission_aspirations as m
join personalized_info as p on p.ResponseID = m.ResponseID
where CurrentCountry ='India'
group by Gender, zipcode;

-- 20. Give a detailed breakdown of the posibility of GenZ working for an Org if the "Mission is misalligned" for each state in India?
select zipcode,MisalignedMissionLikelihood, count(Gender) as cnt from mission_aspirations as m
join personalized_info as p on p.ResponseID = m.ResponseID
where MisalignedMissionLikelihood = 'Will work for them' and CurrentCountry = 'India'
group by zipcode;

