titanic_raw_data = load '/titanic/Titanic_Data.txt' using PigStorage(',') as
(PassengerId:int,Survived:int,Pclass:int,Name:chararray,Sex:chararray,Age:int,
SibSp:int,Parch:int,Ticket:chararray,Fare:int,Cabin:chararray,Embarked:chararray);

-- Extract useful column from the raw data for analysis

useful_data = FOREACH titanic_raw_data generate Survived,Pclass;

SPLIT useful_data into died_Person IF(Survived==0), survived_Person IF(Survived==1);

died_pclass_grp = GROUP died_Person by Pclass;
survived_pclass_grp = GROUP survived_Person by Pclass;

count_died_person = foreach died_pclass_grp generate CONCAT('Died_Pclass_',(chararray)group),COUNT(died_Person);
count_survived_person = foreach survived_pclass_grp generate CONCAT('Survived_Pclass_',(chararray)group),COUNT(survived_Person);

pclass_final_report = UNION count_died_person, count_survived_person;
 
STORE pclass_final_report INTO '/titanic/Pclass_final_report.txt' using PigStorage(',');

pclass_final_report_data = load '/titanic/Pclass_final_report.txt' using PigStorage(',') as (category:chararray,total:int);
dump pclass_final_report_data;
