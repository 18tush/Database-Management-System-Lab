create database tusharys2_cs545;
\c tusharys2_cs545

CREATE TABLE ORDERS
 (	item_id INT NOT NULL ,
	item_name VARCHAR(30) NOT NULL, 
    quantity DECIMAL(7,2), 
    price INT NOT NULL,

	PRIMARY KEY (item_id)
    );


CREATE TABLE SUMMARY
 (	total_items INT DEFAULT 0,
    total_price DECIMAL(7,2) DEFAULT 0.00              
    );

INSERT INTO summary VALUES (0,0);


CREATE FUNCTION insert_order()
	RETURNS trigger as $$
	BEGIN
		UPDATE summary
		SET total_items = total_items + NEW.quantity;
		
        UPDATE summary
		SET total_price = total_price + NEW.price*NEW.quantity;
		RETURN NEW;
	END;
	$$
	LANGUAGE 'plpgsql';

	CREATE FUNCTION delete_order()
	RETURNS trigger as $$
	BEGIN
		UPDATE summary
		SET total_items = total_items - OLD.quantity;
        UPDATE summary
		SET total_price = total_price - OLD.price*OLD.quantity;
		RETURN OLD;
	END;
	$$
	LANGUAGE 'plpgsql';



CREATE TRIGGER insertItem
	AFTER INSERT ON orders
	FOR EACH ROW
	EXECUTE PROCEDURE insert_order();

CREATE TRIGGER deleteItem
	BEFORE DELETE ON orders
	FOR EACH ROW
	EXECUTE PROCEDURE delete_order();