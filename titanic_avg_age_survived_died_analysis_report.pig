titanic_raw_data = load '/titanic/Titanic_Data.txt' using PigStorage(',') as
(PassengerId:int,Survived:int,Pclass:int,Name:chararray,Sex:chararray,Age:int,
SibSp:int,Parch:int,Ticket:chararray,Fare:int,Cabin:chararray,Embarked:chararray);

-- Extract useful column from the raw data
useful_data = foreach titanic_raw_data generate Survived,Sex,Age;

-- Split data into survived and died passanger
SPLIT useful_data INTO died_Person IF(Survived==0), survived_Person IF(Survived==1);  


-- Group pasanger by gender
survived_gender_grp = GROUP survived_Person by Sex;
died_gender_grp = GROUP died_Person by Sex;

-- Generate avg age for both female and male for died and survived people

sur_average_age = foreach survived_gender_grp generate CONCAT('Survived_',group) ,AVG(survived_Person .Age) as avg_age; 
died_average_age = foreach died_gender_grp generate CONCAT('Died_',group) ,AVG(died_Person .Age) as avg_age; 

merged_data = UNION sur_average_age, died_average_age ;                       

STORE merged_data INTO '/titanic/final_report.txt' using PigStorage(',');  

final_avg_age_report = load '/titanic/final_report.txt' using PigStorage(',') as (category:chararray,avg_age:int);
dump final_avg_age_report 



