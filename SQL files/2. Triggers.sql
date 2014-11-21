DELIMITER |


/*****************************************

CHECK BOOK BEFORE INSERT AND BEFORE UPDATE

******************************************/

CREATE TRIGGER check_book_before_insert BEFORE INSERT ON book FOR EACH ROW  
BEGIN
	
	DECLARE correct_format BOOLEAN;
	DECLARE non_negative_price BOOLEAN;
	SET correct_format=TRUE;
	SET non_negative_price=TRUE;
	
	IF NEW.format<>'paperback' AND NEW.format<>'hardcover' THEN
		SET correct_format=FALSE;
	END IF;
	
	IF correct_format=FALSE THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT='format should be paperback or hardcover only';
	END IF;


	IF NEW.price<'0' THEN
		SET non_negative_price=FALSE;
	END IF;
	
	IF non_negative_price=FALSE THEN
		SIGNAL SQLSTATE '45001'
		SET MESSAGE_TEXT='price of book cannot be negative';
	END IF;

END; |


CREATE TRIGGER check_book_before_update BEFORE UPDATE ON book FOR EACH ROW  
BEGIN
	
	DECLARE correct_format BOOLEAN;
	DECLARE non_negative_price BOOLEAN;
	SET correct_format=TRUE;
	SET non_negative_price=TRUE;
	
	IF NEW.format<>'paperback' AND NEW.format<>'hardcover' THEN
		SET correct_format=FALSE;
	END IF;
	
	IF correct_format=FALSE THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT='format should be paperback or hardcover only';
	END IF;


	IF NEW.price<'0' THEN
		SET non_negative_price=FALSE;
	END IF;
	
	IF non_negative_price=FALSE THEN
		SIGNAL SQLSTATE '45001'
		SET MESSAGE_TEXT='price of book cannot be negative';
	END IF;

END; |


/*****************************************

CHECK ORDERS BEFORE INSERT AND BEFORE UPDATE

******************************************/

CREATE TRIGGER check_orders_before_insert BEFORE INSERT ON orders FOR EACH ROW  
BEGIN
	
	DECLARE correct_status BOOLEAN;
	DECLARE correct_number_of_books BOOLEAN;
	SET correct_status=TRUE;
	SET correct_number_of_books=TRUE;
	
	IF NEW.order_status<>'processing' AND NEW.order_status<>'shipped' THEN
		SET correct_status=FALSE;
	END IF;
	
	IF correct_status=FALSE THEN
		SIGNAL SQLSTATE '45002'
		SET MESSAGE_TEXT='order_status should be processing or shipped only';
	END IF;


	IF NEW.order_copies='0' THEN
		SET correct_number_of_books=FALSE;
	END IF;
	
	IF correct_number_of_books=FALSE THEN
		SIGNAL SQLSTATE '45003'
		SET MESSAGE_TEXT='customer must order 1 or more books';
	END IF;

END; |


CREATE TRIGGER check_orders_before_update BEFORE UPDATE ON orders FOR EACH ROW  
BEGIN
	
	DECLARE correct_status BOOLEAN;
	DECLARE correct_number_of_books BOOLEAN;
	SET correct_status=TRUE;
	SET correct_number_of_books=TRUE;
	
	IF NEW.order_status<>'processing' AND NEW.order_status<>'shipped' THEN
		SET correct_status=FALSE;
	END IF;
	
	IF correct_status=FALSE THEN
		SIGNAL SQLSTATE '45002'
		SET MESSAGE_TEXT='order_status should be processing or shipped only';
	END IF;


	IF NEW.order_copies='0' THEN
		SET correct_number_of_books=FALSE;
	END IF;
	
	IF correct_number_of_books=FALSE THEN
		SIGNAL SQLSTATE '45003'
		SET MESSAGE_TEXT='customer must order 1 or more books';
	END IF;

END; |


/***************************************************

CHECK GIVES_FEEDBACK BEFORE INSERT AND BEFORE UPDATE

****************************************************/

CREATE TRIGGER check_gives_feedback_before_insert BEFORE INSERT ON gives_feedback FOR EACH ROW  
BEGIN
	
	DECLARE correct_max_score BOOLEAN;
	SET correct_max_score=TRUE;
	
	IF NEW.feedback_score>'10' THEN
		SET correct_max_score=FALSE;
	END IF;
	
	IF correct_max_score=FALSE THEN
		SIGNAL SQLSTATE '45004'
		SET MESSAGE_TEXT='enter a maximum score of 10 only';
	END IF;

END; |

CREATE TRIGGER check_gives_feedback_before_update BEFORE UPDATE ON gives_feedback FOR EACH ROW  
BEGIN
	
	DECLARE correct_max_score BOOLEAN;
	SET correct_max_score=TRUE;
	
	IF NEW.feedback_score>'10' THEN
		SET correct_max_score=FALSE;
	END IF;
	
	IF correct_max_score=FALSE THEN
		SIGNAL SQLSTATE '45004'
		SET MESSAGE_TEXT='enter a maximum score of 10 only';
	END IF;

END; |


/***************************************************

CHECK RATES_FEEDBACK BEFORE INSERT AND BEFORE UPDATE
AND
CHECK THAT RATER != RATER

****************************************************/

CREATE TRIGGER check_rates_feedback_before_insert BEFORE INSERT ON rates_feedback FOR EACH ROW  
BEGIN
	
	DECLARE correct_max_rating BOOLEAN;
	DECLARE rater_neq_ratee BOOLEAN;

	SET correct_max_rating=TRUE;
	
	IF NEW.rating>'2' THEN
		SET correct_max_rating=FALSE;
	END IF;
	
	IF correct_max_rating=FALSE THEN
		SIGNAL SQLSTATE '45005'
		SET MESSAGE_TEXT='enter a maximum rating of 2 only';
	END IF;

	SET rater_neq_ratee=TRUE;

	IF NEW.rater=NEW.ratee THEN
		SET rater_neq_ratee=FALSE;
	END IF;

	IF rater_neq_ratee=FALSE THEN
		SIGNAL SQLSTATE '45006'
		SET MESSAGE_TEXT='user cannot rate his or her own feedback';
	END IF;

END; |

CREATE TRIGGER check_rates_feedback_before_update BEFORE UPDATE ON rates_feedback FOR EACH ROW  
BEGIN
	
	DECLARE correct_max_rating BOOLEAN;
	DECLARE rater_neq_ratee BOOLEAN;

	SET correct_max_rating=TRUE;
	
	IF NEW.rating>'2' THEN
		SET correct_max_rating=FALSE;
	END IF;
	
	IF correct_max_rating=FALSE THEN
		SIGNAL SQLSTATE '45005'
		SET MESSAGE_TEXT='enter a maximum rating of 2 only';
	END IF;

	SET rater_neq_ratee=TRUE;

	IF NEW.rater=NEW.ratee THEN
		SET rater_neq_ratee=FALSE;
	END IF;

	IF rater_neq_ratee=FALSE THEN
		SIGNAL SQLSTATE '45006'
		SET MESSAGE_TEXT='user cannot rate his or her own feedback';
	END IF;

END; |