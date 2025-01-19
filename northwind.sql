
---------------------------------------------------EASY-------------------------------------------------

-- 1.QUERY Show the category_name and description from the categories table sorted by category_name.
select category_name, description from categories

--2.QUERY Show all the contact_name, address, city of all customers which are not from 'Germany', 'Mexico', 'Spai
select contact_name, address,city from customers
where country not in ('Germany', 'Mexico' ,'Spain')

--3.QUERY Show order_date, shipped_date, customer_id, Freight of all orders placed on 2018 Feb 26
select order_date, shipped_date,customer_id,freight
from orders
where order_date = '2018-02-26'

--4.QUERY Show the employee_id, order_id, customer_id, required_date, shipped_date from all orders shipped later than the required date
select employee_id, order_id, customer_id, required_date, shipped_date
from orders
where shipped_date > required_date

--5.QUERY Show all the even numbered Order_id from the orders table
select order_id
from orders
where order_id % 2 = 0

--6.QUERY Show the city, company_name, contact_name of all customers from cities which contains the letter 'L' in the city name, sorted by contact_name
SELECT city,company_name,contact_name FROM customers
where city like '%l%'
order by contact_name

--7.QUERY Show the company_name, contact_name, fax number of all customers that has a fax number. (not null)
select company_name, contact_name,fax
from customers
where fax not null ;

--8.QUERY Show the first_name, last_name. hire_date of the most recently hired employee.
select first_name, last_name, max(hire_date)
from employees

--9.QUERY Show the average unit price rounded to 2 decimal places, the total units in stock, total discontinued products from the products table.
select round(avg(unit_price), 2) as average_price, sum(units_in_stock) as total_stock ,
sum(discontinued) as total_discontinued
from products


-----------------------------------MEDIUM----------------------------------------------------------


--1.QUERY Show the ProductName, CompanyName, CategoryName from the products, suppliers, and categories table
select p.product_name, s.company_name, c.category_name
from products p 
inner join suppliers s 
on p.supplier_id = s.supplier_id
inner join categories c 
on p.category_id = c.category_id


--2.QUERY Show the category_name and the average product unit price for each category rounded to 2 decimal places.
select c.category_name, round(avg(p.unit_price),2) as average_unit_price
from categories c 
inner join products p 
on c.category_id = p.category_id
group by c.category_name

--3.QUERY Show the city, company_name, contact_name from the customers and suppliers table merged together.
--Create a column which contains 'customers' or 'suppliers' depending on the table it came from.
select c.city,c.company_name , c.contact_name,'customers' as  relationship
from customers c 
union all
select s.city,s.company_name ,s.contact_name , 'suppliers' as relationship
from suppliers s

--4.QUERY Show the total amount of orders for each year/month.
select year(order_date) as order_year , month(order_date) as order_month, count(*) as no_of_orders
from orders
group by order_year, order_month


-------------------------------------------------HARD---------------------------------------------------------


--1.QUERY Show the employee's first_name and last_name, a "num_orders" column with a count of the orders taken, and a column called "Shipped" that displays "On Time" if the order shipped_date is less or equal to the required_date, "Late" if the order shipped late, "Not Shipped" if shipped_date is null.
--Order by employee last_name, then by first_name, and then descending by number of orders.
select
  e.first_name,
  e.last_name,
  count(*) as num_orders,
  (
    case
      when o.shipped_date  <= o.required_date then 'On Time'
      WHEN o.shipped_date > o.required_date then 'Late'
      else 'Not Shipped'
    end
  ) as shipped
from employees e
  inner join orders o on e.employee_id = o.employee_id
group by
  e.first_name,
  e.last_name,
  shipped
order by
  e.last_name,
  e.first_name,
  num_orders desc


  --2.QUERY Show how much money the company lost due to giving discounts each year, order the years from most recent to least recent. Round to 2 decimal places
select year(o.order_date) as order_year,
ROUND(SUM(p.unit_price * od.quantity * od.discount),2) AS discount_amount

from orders o 
JOIN order_details od ON o.order_id = od.order_id
JOIN products p ON od.product_id = p.product_id

group by YEAR(o.order_date)
order by order_year desc;