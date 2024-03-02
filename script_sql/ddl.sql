-- Create table city 
CREATE TABLE city
(
	city_id integer PRIMARY KEY,
	city_name varchar(255) UNIQUE NOT NULL,
	latitude float NOT NULL,
	longitude float NOT NULL
);

CREATE TABLE product_detail
(
	product_detail_id SERIAL PRIMARY KEY,
	brand varchar(255) ,
	model varchar(255) ,
	body_type varchar(255) ,
	transmission varchar(255) ,
	year integer,
	price integer
);

-- Create table seller 
CREATE TABLE seller
(
	seller_id SERIAL PRIMARY KEY,
	seller_name varchar(255) UNIQUE NOT NULL,
	seller_contact varchar(255),
	city_id integer
);

-- Create table seller 
CREATE TABLE buyer
(
	buyer_id SERIAL PRIMARY KEY,
	buyer_name varchar(255) UNIQUE NOT NULL,
	buyer_contact varchar(255),
	city_id integer
);

-- Create table product 
CREATE TABLE product
(
    product_id SERIAL PRIMARY KEY,
	product_detail_id integer,
	seller_id integer,
	title text ,
	date_post date
	
);

-- Create table bid 
CREATE TABLE bid
(
    bid_id SERIAL PRIMARY KEY,
	product_id integer,
	buyer_id integer ,
	date_bid date,
	bid_price integer ,
	bid_status varchar(255)
);

--Business Process

-- For table product_detail
-- The price must be > 0 
-- Column brand, model, body_type, and transmission must be not null
ALTER TABLE product_detail
	ADD CONSTRAINT price_check
		CHECK(
			price>0
		), 
	ALTER COLUMN brand SET NOT NULL,
	ALTER COLUMN model SET NOT NULL,
	ALTER COLUMN body_type SET NOT NULL,
	ALTER COLUMN transmission SET NOT NULL;

ALTER TABLE seller 
	ADD CONSTRAINT fk_city
		FOREIGN KEY (city_id)
		REFERENCES city(city_id),
	ALTER COLUMN city_id SET NOT NULL,
	ALTER COLUMN seller_contact SET NOT NULL;

ALTER TABLE buyer 
	ADD CONSTRAINT fk_city
		FOREIGN KEY (city_id)
		REFERENCES city(city_id),
	ALTER COLUMN buyer_contact SET NOT NULL;
	
-- For table product
-- product_detail_id and seller_id must be its foreign key and not null 
ALTER TABLE product 
	ADD CONSTRAINT fk_product_detail
		FOREIGN KEY (product_detail_id) 
		REFERENCES product_detail(product_detail_id),
	ADD CONSTRAINT fk_seller
		FOREIGN KEY (seller_id) 
		REFERENCES seller(seller_id),
	ALTER COLUMN product_detail_id SET NOT NULL,
	ALTER COLUMN seller_id SET NOT NULL,
	ALTER COLUMN title SET NOT NULL,
	ALTER COLUMN date_post SET DEFAULT CURRENT_DATE;

-- For table product
-- Product_id must be its foreign key and not null 
-- Column bid_price must be > 0
ALTER TABLE bid 
	ADD	CONSTRAINT fk_product_id
		FOREIGN KEY (product_id)
		REFERENCES product(product_id),
	ADD	CONSTRAINT fk_buyer_id
		FOREIGN KEY (buyer_id)
		REFERENCES buyer(buyer_id),
	ADD CONSTRAINT bid_price_check
			CHECK(
				bid_price>0
		),
	ALTER COLUMN product_id SET NOT NULL,
	ALTER COLUMN buyer_id SET NOT NULL,
	ALTER COLUMN bid_status SET DEFAULT 'Sent',
	ALTER COLUMN date_bid SET DEFAULT CURRENT_DATE;