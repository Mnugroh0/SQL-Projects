-- 1.Produk yang dijual by kategori
SELECT ROW_NUMBER() OVER (ORDER BY(category)) AS NO, category 
FROM products
GROUP BY category;

-- 2.Mengecek quantity
SELECT
	category,
    SUM(quantity)
FROM order_details od
INNER JOIN products p ON od.product_id = p.product_id
GROUP BY 1;

-- 3.Banyak transaksi/bulan 
SELECT
	DATE_FORMAT(created_at, "%Y-%m") AS tahun_bulan,
    COUNT(buyer_id) AS total_pembeli,
    SUM(quantity) AS terjual
FROM order_details od
INNER JOIN orders o USING(order_id)
GROUP BY 1;


-- 4.Produk kategori yang paling banyak di jual tiap bulan 
SELECT 
	tahun_bulan, 
    category,
    MAX(terjual) AS terjual
FROM
(SELECT															-- bisa digunakan sebagai kategori paling banyak dibeli tahun 2020/2019
	DATE_FORMAT(created_at, "%Y-%m") AS tahun_bulan,			-- note : terpenting ada di group by 
    category,
    SUM(quantity) AS terjual
FROM order_details od
INNER JOIN orders o USING(order_id)
INNER JOIN products p USING(product_id)
GROUP BY 2,1) AS summary
GROUP BY 1;														-- end untuk mengetahui


-- 5.kategori produk yang paling banyak dibeli tahun 2019 dan 2020
SELECT
	tahun,
    category,
    MAX(terjual) AS terjual
FROM(
SELECT
	YEAR(created_at) AS tahun,			
    category,
    SUM(quantity) AS terjual
FROM order_details od
INNER JOIN orders o USING(order_id)
INNER JOIN products p USING(product_id)
GROUP BY 2, 1
ORDER BY 3 DESC) AS summary
GROUP BY 1;


-- 6. Buyer Each Month (mengetahui sebaran pembeli melalui kodepos dan yang dibeli di atas 300)
    
SELECT
	DATE_FORMAT(created_at, "%Y-%m") AS tahun_bulan,
    kodepos,
    MAX(category) AS category,
    SUM(quantity) AS bought
FROM order_details od
INNER JOIN orders o USING(order_id)
INNER JOIN products p USING(product_id)
GROUP BY 1, 2
HAVING terjual >= 400
ORDER BY terjual DESC;

-- 7. What category products mostly bought by top buyer 

SELECT
	DATE_FORMAT(created_at, "%Y-%m") AS tahun_bulan,
	kodepos,
    category, 
    SUM(quantity) AS bought
FROM order_details od
INNER JOIN orders o USING(order_id)
INNER JOIN products p USING(product_id)
WHERE DATE_FORMAT(created_at, "%Y-%m") = "2020-05" AND kodepos = "96062"
GROUP BY 1, 3
ORDER BY bought DESC;

