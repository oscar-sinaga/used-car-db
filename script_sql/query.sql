-- Creating Transactional Query

-- 1 Mencari mobil keluaran 2015 ke atas (1% bobot)
SELECT 
    * 
FROM 
    product_detail 
WHERE 
    year>=2015
;

--2 Menambahkan satu data bid produk baru (1% bobot)
INSERT INTO bid (bid_id,product_id, buyer_id, date_bid, bid_price, bid_status)
VALUES (1501,113, 7, '2022-03-04', 185500000, 'Sent');

--3 Melihat semua mobil yg dijual 1 akun dari yg paling baru
--  Contoh: Mobil yang dijual oleh akun “Xanana Melan” (2% bobot)

SELECT 
    seller_name, 
    product_detail_id, 
    brand, 
    model, 
    year, 
    price, 
    date_post
FROM 
    product
        INNER JOIN 
    product_detail USING (product_detail_id)
        INNER JOIN 
    seller USING(seller_id)
WHERE 
    seller_name='Xanana Melani';

--4 Mencari mobil bekas yang termurah berdasarkan keyword
--  Contoh: Berdasarkan keyword “Yaris” (2% bobot)

SELECT 
    product_detail_id, 
    brand, 
    model, 
    year, 
    price
FROM 
    product_detail
WHERE 
    model LIKE '%Yaris%'
ORDER BY 
    price ASC
;

--5 Mencari mobil bekas yang terdekat berdasarkan sebuah id kota, jarak terdekat dihitung berdasarkan latitude longitude
--  Contoh: mencari mobil terdekat dengan id kota 3173 

WITH product_join AS
(
	SELECT 
        *
	FROM 
        product
	        INNER JOIN 
        product_detail USING (product_detail_id)
	        INNER JOIN 
        seller USING(seller_id)
	        INNER JOIN 
        city USING (city_id)
)
SELECT 
	car.product_id,
	car.product_detail_id,
	car.brand,
	car.model, 
	car.year, 
	car.price,
	SQRT(POWER(car.longitude - city.longitude,2) + POWER(car.latitude - city.latitude,2)) AS distance 
FROM 
    product_join AS car
        cross join 
    city
WHERE 
    city.city_id = 3173
ORDER BY 
    distance ASC
;

--  Creating Analytical Query

--6 Ranking popularitas model mobil berdasarkan jumlah bid (2% bobot)
WITH bid_count AS 
(
	SELECT 
        model, 
        count(bid_id) AS count_bid
	FROM 
        bid
	        INNER JOIN 
        product USING (product_id)
	        INNER JOIN 
        product_detail USING(product_detail_id)
	GROUP BY 
        model
),

product_count AS
(
	SELECT 
        model, 
        count(product_id) AS count_product
	FROM 
        product
	        INNER JOIN 
        product_detail USING(product_detail_id)
	GROUP BY 
        model
)

SELECT 
    *
FROM 
    product_count
        INNER JOIN 
    bid_count  USING (model)
ORDER BY 
    count_bid DESC	
;

--7 Membandingkan harga mobil berdasarkan harga rata-rata per kota. (4% bobot)
WITH product_join AS
(
	SELECT 
        *
	FROM
        product
	        INNER JOIN 
        product_detail USING (product_detail_id)
	        INNER JOIN 
        seller USING(seller_id)
	        INNER JOIN 
        city USING (city_id)
)

SELECT
	city_name,
	brand,
	model,
	year,
	price,
	AVG(price) OVER(PARTITION BY city_name) AS avg_car_city
FROM 
    product_join
;

--8 Dari penawaran suatu model mobil, cari perbandingan tanggal user melakukan bid dengan bid selanjutnya beserta harga tawar yang diberikan (4% bobot)
--  Contoh: Bid untuk model mobil: Toyota Yaris.

WITH join_bid AS 
(
	SELECT 
        *
	FROM 
        bid
	        INNER JOIN 
        product USING (product_id)
	        INNER JOIN 
        product_detail USING(product_detail_id)
)


SELECT
	model,
	buyer_id,
	date_bid AS first_bid_date,
	LEAD(date_bid) OVER (ORDER BY date_bid) AS next_bid_date,
	bid_price AS first_bid_price,
	LEAD(bid_price) OVER (ORDER BY date_bid) AS next_bid_price
FROM 
    join_bid
WHERE 
    model = 'Daihatsu Ayla'
ORDER BY 
    buyer_id;

/*
9. Membandingkan persentase perbedaan rata-rata harga mobil berdasarkan modelnya dan rata-rata harga bid yang ditawarkan oleh customer pada 6 bulan terakhir (4% bobot)
Difference adalah selisih antara rata-rata harga model mobil(avg_price) dengan rata-rata harga bid yang ditawarkan terhadap model tersebut(avg_bid_6month)
Difference dapat bernilai negatif atau positif
Difference_percent adalah persentase dari selisih yang telah dihitung, yaitu dengan cara difference dibagi rata-rata harga model mobil(avg_price) dikali 100%
Difference_percent dapat bernilai negatif atau positif
*/
;

WITH avg_product_price AS
(
	SELECT 
        model, 
        avg(price) AS avg_price
	FROM 
        product_detail
	GROUP BY 
        model
)
,
product_bid AS 
(
	SELECT 
        *
	FROM 
        bid
	        INNER JOIN 
        product USING (product_id)
	        INNER JOIN 
        product_detail USING (product_detail_id)
)
,
avg_bid_price AS
(
	SELECT 
        model, 
        avg(bid_price) AS avg_bid_6month 
	FROM 
        product_bid 
	WHERE 
        date_bid >= (SELECT MAX(date_bid) - INTERVAL '6 MONTH' FROM bid)
	GROUP BY 
        model
)

SELECT 
	*,
	(avg_price - avg_bid_6month) AS difference,
	(avg_price - avg_bid_6month)/avg_price *100 AS difference_percent
    FROM 
        avg_product_price
            INNER JOIN 
        avg_bid_price USING (model)
;

--10 Membuat window function rata-rata harga bid sebuah merk dan model mobil selama 6 bulan terakhir. (5% bobot)
--   Contoh: Mobil Toyota Yaris selama 6 bulan terakhir

CREATE FUNCTION CalculateWindowNMonthAvgBidPrice(n INTEGER) 
RETURNS TABLE (model VARCHAR, avg_bid_price DECIMAL) AS $$
BEGIN
    RETURN QUERY 
    WITH product_bid AS (
        SELECT *
        FROM 
            bid
                INNER JOIN 
            product USING (product_id)
                INNER JOIN 
            product_detail USING (product_detail_id)
    ),
    avg_bid_price_n_month AS (
        SELECT 
            pb.model, 
            AVG(pb.bid_price) AS avg_bid_price
        FROM 
            product_bid pb
        WHERE 
            pb.date_bid >= (SELECT MAX(date_bid) - INTERVAL '1 MONTH' * n FROM bid)
        GROUP BY 
            pb.model
    )
    SELECT * FROM avg_bid_price_n_month;
END;
$$ LANGUAGE plpgsql;

WITH avg_bid_price_6month AS
    (SELECT model, avg_bid_price AS m_min_6 FROM CalculateWindowNMonthAvgBidPrice(6)),
avg_bid_price_5month AS
    (SELECT model, avg_bid_price AS m_min_5 FROM CalculateWindowNMonthAvgBidPrice(5)),
avg_bid_price_4month AS 
    (SELECT model, avg_bid_price AS m_min_4 FROM CalculateWindowNMonthAvgBidPrice(4)),
avg_bid_price_3month AS
    (SELECT model, avg_bid_price AS m_min_3 FROM CalculateWindowNMonthAvgBidPrice(3)), 
avg_bid_price_2month AS 
    (SELECT model, avg_bid_price AS m_min_2 FROM CalculateWindowNMonthAvgBidPrice(2)),
avg_bid_price_1month AS
    (SELECT model, avg_bid_price AS m_min_1 FROM CalculateWindowNMonthAvgBidPrice(1)),

windows_function AS
(
	SELECT 
        * 
    FROM 
        avg_bid_price_6month
	        LEFT JOIN 
        avg_bid_price_5month USING (model)
	        LEFT JOIN 
        avg_bid_price_4month USING (model)
	        LEFT JOIN 
        avg_bid_price_3month USING (model)
	        LEFT JOIN 
        avg_bid_price_2month USING (model)
	        LEFT JOIN 
        avg_bid_price_1month USING (model)
)
,
distinct_product AS
(
	SELECT 
        distinct brand, 
        model 
    FROM product_detail
)

SELECT 
    brand, 
    windows_function.*
FROM 
    windows_function
INNER JOIN 
    distinct_product USING (model)
WHERE 
    model = 'Daihatsu Xenia'
;