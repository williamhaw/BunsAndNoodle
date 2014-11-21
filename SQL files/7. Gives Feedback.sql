/* feedback_isbn13, feedback_customer, feedback_date, feedback_score, feedback_text */
# Note that feedback_score is an int, so a value 7.5 will be rounded up to 8, and a value 7.4 is rounded down to 7
# 0 <= feedback_score <= 10 constraints are enforced by the UNSIGNED INT as well as the TRIGGER.

insert into gives_feedback values('978-1449389673','alice','2014-11-17 19:00:00','7','Photoshop elements is a pretty insightful read and I learnt a lot. However, I think that the examples could be a little clearer!');
insert into gives_feedback values('978-1594487712','bob','2014-11-18 01:00:00','3',NULL);
insert into gives_feedback values('978-0470547816','bob','2014-11-18 06:00:00','2','I do not like this book!');
insert into gives_feedback values('978-0073104454','candice','2014-11-19 16:45:00','1','Not my cup of tea...');
insert into gives_feedback values('978-0486437118','gemma','2014-11-19 18:21:33','0',NULL);
insert into gives_feedback values('978-0486437118','alice','2014-11-19 20:00:00','10','Awesome read');
insert into gives_feedback values('978-0486437118','bob','2014-11-19 23:00:00','9','Superbly written and immensely helpful.');
insert into gives_feedback values('978-0136006176','kelly','2014-11-19 23:20:00','8',NULL);
insert into gives_feedback values('978-0393058581','mansa','2014-11-20 23:20:00','4','Below average.');
insert into gives_feedback values('978-0393058581','doggie','2014-11-20 00:01:00','5','Dog ate my homework!');