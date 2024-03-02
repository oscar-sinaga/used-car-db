COPY city(city_id,city_name,latitude,longitude)
FROM 'D:\OneDrive - UGM 365\dev\pacmann\SQL\used-car-databases\dummy_dataset\city.csv'
DELIMITER ','
CSV
HEADER;

COPY product_detail(product_detail_id,brand,model,body_type,transmission,year,price)
FROM 'D:\OneDrive - UGM 365\dev\pacmann\SQL\used-car-databases\dummy_dataset\product_detail.csv'
DELIMITER ','
CSV
HEADER;

COPY seller(seller_id,seller_name,seller_contact,city_id)
FROM 'D:\OneDrive - UGM 365\dev\pacmann\SQL\used-car-databases\dummy_dataset\seller.csv'
DELIMITER ','
CSV
HEADER;

COPY buyer(buyer_id,buyer_name,buyer_contact,city_id)
FROM 'D:\OneDrive - UGM 365\dev\pacmann\SQL\used-car-databases\dummy_dataset\buyer.csv'
DELIMITER ','
CSV
HEADER;

COPY product(product_id,product_detail_id,seller_id,title,date_post)
FROM 'D:\OneDrive - UGM 365\dev\pacmann\SQL\used-car-databases\dummy_dataset\product.csv'
DELIMITER ','
CSV
HEADER;

COPY bid(bid_id,product_id,buyer_id,date_bid,bid_price,bid_status)
FROM 'D:\OneDrive - UGM 365\dev\pacmann\SQL\used-car-databases\dummy_dataset\bid.csv'
DELIMITER ','
CSV
HEADER;