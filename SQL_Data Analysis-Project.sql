create database `SQL Practice Questions`;
select * from customers;
select * from orders_dirty;
select * from orders_store2;

-- Rename `windows-cte-subquery` to Orders
select * from `windows-cte-subquery`;

alter table `windows-cte-subquery`
rename to Orders;
select * from orders;
-- 1. Select	all	columns	for	every	order	in	the	Electronics	category.
select * from orders
where Category = 'Electronics';

-- 2.	Get	the	distinct	list	of	products	ever	ordered.
select distinct product from orders;

-- 3.	List	all	orders	where	the	price	is	greater	than	10,000.
select * from orders
where price > 10000;

-- 4.	Find	all	orders	placed	between	2024-01-15	and	2024-02-01.
select * from orders 
where OrderDate between 2024-01-15 and 2024-02-01;

-- 5.	Find	all	customers	whose	name	starts	with	the	letter	“A”	or	“F”.
select * from orders
where CustomerName like 'A%' OR CustomerName like 'F%';

-- 6.	Select	CustomerName,	Product,	and	Price,	aliasing	Price	as	UnitPrice.
select CustomerName, Product, Price as unit_price from orders;

-- 7. 	Find	all	orders	where	the	product	name	contains	the	word	“Cable”
select * from orders
where Product like '%cable%';

-- 8.	List	orders	where	Category	is	either	Accessories	or	Home
select * from orders
where Category = 'Accessories' or Category like '%Home%';

/* 9.	Write	a	statement	to	add	a	new	column	TotalAmount	(numeric)	to
the	Orders	table.
*/
 select * from orders;
 alter table orders
 add column TotalAmount decimal (10,5);
 
 -- 10.	Write	a	statement	to	rename	the	column	Price	to	UnitPrice.
 alter table orders
 rename column Price to UnitPrice;
 
 -- 11.	Write	a	statement	to	change	the	data	type	of	OrderDate	from	text	to DATE.
 alter table orders
 modify OrderDate date;
 
 -- 12.	Write	a	statement	to	drop	a	column	called	Notes	from	Orders (assume	it	exists).
 alter table orders
 drop column Notes;
 
 -- 13.	Write	a	statement	to	add	a	NOT	NULL	constraint	to	the	CustomerID column
 alter table orders
 modify CustomerID text not null;
 
 -- 14.	Increase	the	price	of	all	Electronics	products	by	10%.
 select product, unitprice, (UnitPrice + UnitPrice*0.1) as New_Unit_Price from orders;
 update orders
 set unitprice = UnitPrice + UnitPrice*0.1;
 select product, unitprice from orders;
 
 -- 15.	Set	Quantity	to	1	for	any	order	where	Quantity	is	currently	NULL	or 0.
 
update orders
set quantity = 1
where quantity = Null or quantity = 0;

-- 16.	Update	the	category	of	the	product	“Webcam”	from	Electronics	to	Accessories.
select Product, Category from orders
where Product like '%webcam%';

update orders
set Category = 'Accessories'
where Product like '%webcam%';

-- 17.	Update	CustomerName	to	“Alice	Johnson”	for	CustomerID	=	'CUST1'
select distinct (CustomerID), CustomerName from orders;
update orders
set customername = 'Alice Johnson'
where customerid = 'CUST1';

-- 18.	For	every	order	placed	in	January	2024,	add	a	500	flat	discount	to	Price	(don’t	let	price	go	below	0).
update orders
set UnitPrice = (UnitPrice-500) 
where OrderDate like '%2024%'
and UnitPrice > 500;
 select * from orders;
 
 
 -- 19.	Find	the	total	revenue	(SUM(Quantity	*	Price))	generated	overall.
 update orders
 set TotalAmount = quantity*Unitprice;
 alter table orders
 modify TotalAmount decimal(10,0);
 select sum(TotalAmount) from orders;
 
-- 20.	Find	the	total	quantity	sold	per	Category.
select Category, sum(Quantity) as TotalQty from orders
group by Category
order by TotalQty;

-- 21.	Find	the	average	price	of	products	in	each	Category.
select Category, Product, round(avg(unitprice)) as AvgPrice from orders
group by Category, Product
order by AvgPrice;

-- 22.	Find	the	highest	and	lowest	priced	order	for	each	Product.
select product, UnitPrice, max(TotalAmount) as HighestOrder, min(TotalAmount) as LowestOrder from orders
group by Product, UnitPrice;

-- 23.	Count	how	many	orders	each	customer	has	placed.
select CustomerID, CustomerName, count(OrderID) as No_of_Orders from orders
group by CustomerID, CustomerName
order by CustomerID asc;
select * from orders;

-- 24.	Find	the	total	revenue	per	customer,	sorted	from	highest	to	lowest.
select CustomerID, CustomerName, sum(TotalAmount) as TotalRevenue from orders
group by CustomerID, CustomerName
order by TotalRevenue desc;

-- 25.	Group	orders	by	Category	and	show	total	revenue	per	category, ordered	by	revenue	descending.
select category, sum(TotalAmount) as TotalRevenue from orders
group by Category
order by TotalRevenue desc;

-- 26.	Group orders by	CustomerID and show	the	count of orders, only for customers	with more than 3 orders	(use HAVING).
select CustomerID, count(OrderID) as TotalOrder from orders
group by CustomerID
having TotalOrder > 3;

-- 27.	Using	PARTITION	BY	Category,	show	each	order	alongside	the
-- average	price	of	its	category	(without	collapsing	rows).
Select *, avg(UnitPrice) OVER (PARTITION BY Category) AS avg_category_price
FROM orders
;
-- 28.	Using	PARTITION	BY	CustomerID	ORDER	BY	OrderDate,	show	each
-- customer’s	orders	numbered	in	the	sequence	they	were	placed.
select *, row_number() over (partition by CustomerID order by OrderDate) as Order_Sequence from orders;

-- 29. 	Show	total	quantity	sold	per	Category	per	month,	ordered	by	month then	category.
SELECT Category,
       DATE_FORMAT(OrderDate, '%Y-%m-01') AS order_month,
       SUM(Quantity) AS total_quantity
FROM orders
GROUP BY Category, DATE_FORMAT(OrderDate, '%Y-%m-01')
ORDER BY order_month, Category;

-- 30.	Use	ROW_NUMBER() to	number	each	customer’s	orders	from	earliest to	latest.
select *, row_number()  
over (partition by CustomerID order by OrderID) as Order_Sequence from orders ;

-- 31.	Use	RANK()	to	rank	products	by	total	revenue,	highest	first.
select product, sum(TotalAmount) as TotalRevenue, rank () over (order by sum(TotalAmount) desc) as TopProduct from orders
group by Product
order by TopProduct;

-- 32.	Use	DENSE_RANK()	to	rank	customers	by	total	amount	spent.
select CustomerID, CustomerName, sum(TotalAmount) as TotalRevenue, dense_rank () over (order by sum(TotalAmount) desc ) as TopCustomer  
from orders
group by CustomerID, CustomerName 
order by sum(TotalAmount) desc;

-- 33. Use	LAG()	to	show	each	order’s	price	next	to	the	previous order’s price	for	the	same	customer.
select *, lag(UnitPrice) over (partition by CustomerID order by OrderDate) as PreviousPrice from orders;

-- 34.	Use	LEAD()	to	show	the	date	of	each	customer’s	next	order.
select *, lead(OrderDate) over (partition by CustomerID order by OrderDate) as Nextorderdate from orders;

-- 35.	Calculate	a	running	total	of	revenue	by	OrderDate	using	SUM()	OVER (ORDER	BY	OrderDate).
select *, sum(TotalAmount) over (order by OrderDate)as runningtotal from orders;

-- 36.	Calculate	a	3-order	moving	average	of	Price	for	each	customer using	a	window	frame.
SELECT *,
       avg(UnitPrice) OVER (partition by CustomerID order by OrderDate
           ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS moving_avg_3_orders
FROM orders;

-- 37.	For	each category,	find the top 2 highest-priced	orders	using ROW_NUMBER()	inside	a	subquery/CTE.
With Top as 
(select *, row_number() over (partition by Category order by UnitPrice desc) as topprice from orders)
select category, unitprice, topprice from Top
where topprice <= 2
order by unitprice desc ;

-- 38.	Write	a	CTE	that	calculates	total	spend	per	customer,	then	select
-- only	customers	who	spent	more	than	30,000.
with tp as (select CustomerID, CustomerName, sum(TotalAmount) as TotalSpend from orders
group by CustomerID, CustomerName
order by Totalspend desc)
select * from tp where totalspend >=30000;

-- 39.	Write	a	subquery	to	find	the	product	with	the	single	highest	price.
select * from
(select product,Category, UnitPrice from orders) as productprice
where UnitPrice >= (select max(UnitPrice) from orders);

-- 40.	Write	a	CTE	that	ranks	products	by	revenue,	then	return	only	the top	3.
with top as 
		(select product, sum(totalamount) as totalrevenue, rank () over (order by sum(TotalAmount) desc) as Ranking  from orders
        group by Product 
        order by sum(TotalAmount) desc)
select * from top
where ranking <= 3;

-- 41.	Find	customers	whose	average	order	value	is	higher	than	the
-- overall	average	order	value	(subquery	in	WHERE).
select * from
(select CustomerID, CustomerName, avg(TotalAmount) as avg_order_value from orders
group by CustomerID, CustomerName
order by avg(TotalAmount)) as top
where avg_order_value > (select avg(TotalAmount) from orders)
;
-- 42.	Return	the	5	most	recent	orders.
select * from orders
limit 5;

-- 43.	Return	the	top	3	highest-priced	orders.
select * from orders
order by TotalAmount desc limit 3;

-- 44.	Return	the	5	customers	with	the	highest	total	spend	(combine	with
-- aggregation	+	LIMIT).
select CustomerID, CustomerName, sum(TotalAmount) as TotalSpend from orders
group by CustomerID, CustomerName
order by TotalSpend desc limit 5;

-- 45.	Skip	the	first	10	orders	and	return	the	next	5	(pagination,	LIMIT	OFFSET	...).
select * from orders
limit 5 offset 10;

-- 54.	Join	Orders	to	Customers	to	show	each	order	alongside	the customer’s	City	and	LoyaltyTier.
select orders.OrderID, orders.CustomerID, orders.CustomerName, orders.Product,orders.Category, orders.UnitPrice, orders.OrderDate,
 orders.TotalAmount, customers.City, customers.LoyaltyTier from orders
left join customers on orders.CustomerID = customers.CustomerID ;

-- 55.	Find	all	customers	who	have	never	placed	an	order	(LEFT	JOIN	+	IS	NULL).
SELECT customers.*
FROM customers
LEFT JOIN orders
    ON customers.CustomerID = orders.CustomerID
WHERE orders.CustomerID IS NULL;

-- 56.	Find	all	orders	placed	by	customers	with	a	Gold	loyalty	tier.
select orders.*,customers.city, customers.LoyaltyTier from orders
left join customers on orders.CustomerID = customers.CustomerID
where LoyaltyTier = 'Gold';

-- 57.	Use	an	INNER	JOIN	to	show	total	revenue	per	city.
 select customers.City, sum(orders.TotalAmount) as totalrevenue from orders
 inner join customers on customers.CustomerID=orders.CustomerID
 group by customers.City,orders.TotalAmount
 order by Totalrevenue desc;
 
 -- 58.	Use	a	LEFT	JOIN	to	list	every	customer	and	their	total	number	of
-- orders,	including	customers	with	zero	orders.
 select customers.CustomerID, customers.CustomerName, count(orders.orderid) from customers
 left join orders on customers.CustomerID=orders.CustomerID
 group by customers.CustomerID, customers.CustomerName;
 
 -- 59.	Find	customers	whose	Email	is	missing,	then	show	whether	they’ve
-- placed	any	orders	(JOIN	+	data	cleaning	combined)
select customers.CustomerID, customers.CustomerName,customers.Email, 
if(orders.orderid >= 1, 'Placed Order', 'No Order') as orderstatus
from customers
left join orders on customers.CustomerID = orders.CustomerID
where customers.Email=' ' or customers.Email is null;

-- 60.	Combine	Orders	and	Orders_Store2	into	a	single	result	set	of	all
-- orders	from	both	stores	using	UNION.
alter table orders_store2
rename column price to Unitprice;
alter table orders_store2
add column TotalAmount decimal (10,0);

update orders_store2
set TotalAmount = Quantity*UnitPrice;
 
select * from orders
union
select * from orders_store2;

-- 61.	Combine	both tables	using	UNION	ALL	and	explain	the	difference	in results	vs.	question	60.
-- Explanation - ALthough there is no duplicate row, But Union removes duplicates while union all shows all the result rows.
select * from orders
union all
select * from orders_store2;

-- 62.	Find	customers	who	appear	in	both	Orders	and	Orders_Store2	(hint:
-- INTERSECT,	or	UNION	+	GROUP	BY	...	HAVING	COUNT(*)	>	1).
select CustomerID, CustomerName from
 (select * from orders
union all
select * from orders_store2) as Bothtable
group by CustomerID, CustomerName
having count(*) > 1;

-- 63.	Find	products	that	were	sold	in	Orders_Store2	but	never	in	the original	Orders	table.
select orders.Product, orders_store2.Product from orders_store2
left join orders on orders_store2.CustomerID=orders.CustomerID
where orders.Product is null or orders.Product=' ';

-- 64.	Combine	both	order	tables	and	compute	total	combined	revenue per	category.
select Category, sum(TotalAmount) as TotalRevenue from
(select * from orders
union all
select * from orders_store2) as Bothtable
group by Category
order by totalrevenue desc;



