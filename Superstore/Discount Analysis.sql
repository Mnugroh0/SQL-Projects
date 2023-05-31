-- title: Seberapa Penting Diskon untuk Pengembangan Bisnis?

-- Melihat ada berapa kategori yang dijual
select 
	Category , 
	count(Category) 
from samplesuperstore 
group by 1; -- terdapat 3 kategori

-- Melihat ada berapa sub-kategori
select 
	row_number() over(order by(`Sub-Category`)) as no,
	`Sub-Category`
from samplesuperstore
group by `Sub-Category`;


/* Menentukan perbandingan banyak diskon yang dipakai dan yang tidak
dengan jumlah profit */
/* Keterangan :
NoDiscount = Not Use Discount
YDiscount = use discount */
with YDiscount(Category, TotalDiskon, ProfitDiskon) as 
	(select											   
		Category, 
        count(Discount),
        sum(Profit)
	from samplesuperstore
    where Discount != 0
    group by Category),
    NoDiscount(Category, TotalNoDiskon, ProfitNoDiskon) as
    (select Category, count(Discount), sum(Profit)
    from samplesuperstore
    where Discount = 0
    group by Category)
    select 
		YDiscount.Category, 
        TotalDiskon, 
        TotalNoDiskon, 
        ProfitDiskon as ProfitDiskon, 
        ProfitNoDiskon as ProfitNoDiskon
	from YDiscount, NoDiscount
    where YDiscount.Category = NoDiscount.Category;


-- Sub Category
with YDiscount(`Sub-Category`, TotalDiskon, ProfitDiskon) as
	(select
		`Sub-Category`, 
        count(Discount),
        sum(Profit)
	from samplesuperstore
    where Discount != 0
    group by `Sub-Category`),
    NoDiscount(`Sub-Category`, TotalNoDiskon, ProfitNoDiskon) as
    (select `Sub-Category`, count(Discount), sum(Profit)
    from samplesuperstore
    where Discount = 0
    group by `Sub-Category`)
    select 
		YDiscount.`Sub-Category`, 
		TotalDiskon, 
        TotalNoDiskon, 
        ProfitDiskon as ProfitDiskon, 
        ProfitNoDiskon as ProfitNoDiskon, 
	case 
		when (ProfitNoDiskon + ProfitDiskon) < 0 then "No Profit"
        when (ProfitNoDiskon + ProfitDiskon) > 0 then "Profit"
        when (ProfitNoDiskon + ProfitDiskon) = 0 then "Netral"
    end as indikator
	from YDiscount, NoDiscount
    where YDiscount.`Sub-Category` = NoDiscount.`Sub-Category`
    order by `Sub-Category`;
    
    
/* pengaruh diskon dengan banyak pembelian dan profit*/
-- Detail about Discount
select
	replace(Discount, ".", ",") as Discount,
		sum(case 
			when `Sub-Category` = "Accessories" then Quantity
            else 0
			end) as Accessories,
		sum(case
			when `Sub-Category` = "Appliances" then Quantity
            else 0
            end) as Appliances,
		sum(case
			when `Sub-Category` = "Art" then Quantity
            else 0
            end) as Art,
		sum(case
			when `Sub-Category` = "Binders" then Quantity
            else 0
            end) as Binders,
		sum(case
			when `Sub-Category` = "Bookcases" then Quantity
            else 0
            end) as Bookcases,
		sum(case
			when `Sub-Category` = "Chairs" then Quantity
            else 0
            end) as Chairs,
		sum(case
			when `Sub-Category` = "Copiers" then Quantity
            else 0
            end) as Copiers,
		sum(case
			when `Sub-Category` = "Envelopes" then Quantity
            else 0
            end) as Envelopes,
		sum(case
			when `Sub-Category` = "Fasteners" then Quantity
            else 0
            end) as Fasteners,
		sum(case
			when `Sub-Category` = "Furnishings" then Quantity
            else 0
            end) as Furnishings,
		sum(case
			when `Sub-Category` = "Labels" then Quantity
            else 0
            end) as Labels,
		sum(case
			when `Sub-Category` = "Machines" then Quantity
            else 0
            end) as Machines,
		sum(case
			when `Sub-Category` = "Paper" then Quantity
            else 0
            end) as Paper,
		sum(case
			when `Sub-Category` = "Phones" then Quantity
            else 0
            end) as Phones,
		sum(case
			when `Sub-Category` = "Storage" then Quantity
            else 0
            end) as Storages,
		sum(case
			when `Sub-Category` = "Supplies" then Quantity
            else 0
            end) as Supplies,
		sum(case
			when `Sub-Category` = "Tables" then Quantity
            else 0
            end) as Tabless,
		sum(Quantity) as TotalQuantity,
		sum(Profit) as TotalProfit
	from samplesuperstore
    group by Discount
    order by discount asc;
    
-- Summary Discount
select 
	Discount,
    sum(Quantity) as total_quantity,
    sum(Profit) as total_profit
from samplesuperstore
group by Discount
order by Discount asc;




    
    
    
