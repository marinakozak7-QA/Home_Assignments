--Database schema: https://sql-ex.ru/help/select13.php#db_1

--Ex.1. Find the model number, speed and hard drive capacity for all the PCs with prices below $500.
SELECT model, speed, hd FROM PC
WHERE price < 500;

--Ex.2. List all printer makers.
SELECT DISTINCT maker FROM Product 
WHERE type = 'Printer';

--Ex.3. Find the model number, RAM and screen size of the laptops with prices over $1000.
SELECT model, ram, screen FROM Laptop
WHERE price > 1000;

--Ex.4. Find all records from the Printer table containing data about color printers.
SELECT * FROM Printer
WHERE color = 'y';

--Ex.5. Find the model number, speed and hard drive capacity of PCs cheaper than $600 having a 12x or a 24x CD drive.
SELECT model, speed, hd FROM PC
WHERE ((cd = '12x' OR cd = '24x') AND (price < 600));

--Ex.6. For each maker producing laptops with a hard drive capacity of 10 Gb or higher, find the speed of such laptops.
SELECT DISTINCT Product.maker, Laptop.speed FROM Laptop
JOIN Product ON Laptop.model = Product.model
WHERE Laptop.hd >= 10
GROUP BY Product.maker, Laptop.speed;

--Ex.7. Get the models and prices for all commercially available products (of any type) produced by maker B.
SELECT DISTINCT PC.model, PC.price FROM PC 
JOIN Product ON Product.model = PC.model
WHERE Product.Maker = 'B' 
UNION
SELECT DISTINCT Laptop.model, Laptop.price FROM Laptop
JOIN Product ON Product.model = Laptop.model 
WHERE Product.Maker = 'B' 
UNION 
SELECT DISTINCT Printer.model, Printer.price FROM Printer 
JOIN Product ON Product.model = Printer.model 
WHERE Product.Maker = 'B';

--Ex.8. Find the makers producing PCs but not laptops.
SELECT Maker FROM Product
WHERE type = 'PC' 
EXCEPT
SELECT Maker FROM Product
WHERE type = 'Laptop';

--Ex.9. Find the makers of PCs with a processor speed of 450 MHz or more.
SELECT DISTINCT Product.maker FROM Product
JOIN PC ON Product.model = PC.model
WHERE PC.speed >= 450;

--Ex.10. Find the printer models having the highest price.
SELECT DISTINCT Printer.model, Printer.price FROM Printer 
WHERE price IN 
(SELECT MAX(price) FROM Printer);

--Ex.11. Find out the average speed of PCs.
SELECT AVG(PC.speed) FROM PC;

--Ex.12. Find out the average speed of the laptops priced over $1000.
SELECT AVG(Laptop.speed) FROM Laptop
WHERE Price > 1000;

--Ex.13. Find out the average speed of the PCs produced by maker A.
SELECT AVG(PC.speed) FROM PC
JOIN Product ON Product.model = PC.model
WHERE Product.maker = 'A';

--Ex.14. For the ships in the Ships table that have at least 10 guns, get the class, name, and country.
SELECT DISTINCT Ships.class, Ships.name, Classes.country FROM Ships, Classes
WHERE Classes.class = Ships.class AND numGuns >= 10;

--Ex.15. Get hard drive capacities that are identical for two or more PCs.
SELECT DISTINCT hd FROM PC
GROUP BY (hd)
HAVING COUNT(model) >= 2;

--Ex.16. Get pairs of PC models with identical speeds and the same RAM capacity. Each resulting pair should be displayed only once, i.e. (i, j) but not (j, i).
SELECT DISTINCT p1.model, p2.model, p1.speed, p1.ram FROM pc p1, pc p2
WHERE p1.speed = p2.speed AND p1.ram = p2.ram AND p1.model > p2.model;

--Ex.17. Get the laptop models that have a speed smaller than the speed of any PC.
SELECT DISTINCT product.type, product.model, laptop.speed FROM Laptop
JOIN Product ON product.model = laptop.model
WHERE laptop.speed < (SELECT MIN(speed) from PC);

--Ex.18. Find the makers of the cheapest color printers.
SELECT DISTINCT product.maker, printer.price FROM Printer
JOIN Product ON product.model = printer.model
WHERE printer.color = 'y' AND printer.price = (SELECT MIN(price) FROM Printer WHERE printer.color = 'y');

--Ex.19. For each maker having models in the Laptop table, find out the average screen size of the laptops he produces.
SELECT product.maker, AVG(screen) FROM Laptop
JOIN Product ON product.model = laptop.model
GROUP BY product.maker;

--Ex.20. Find the makers producing at least three distinct models of PCs.
SELECT product.maker, COUNT(model) FROM Product
WHERE Type = 'PC'
GROUP BY product.maker
HAVING COUNT (DISTINCT model) >= 3;

--Ex.21.Find out the maximum PC price for each maker having models in the PC table.
SELECT DISTINCT product.maker, MAX(pc.price) FROM PC
JOIN Product ON product.model = pc.model
WHERE product.type = 'PC'
GROUP BY product.maker;

--Ex.22. For each value of PC speed that exceeds 600 MHz, find out the average price of PCs with identical speeds.
SELECT pc.speed, AVG(pc.price) FROM PC
WHERE pc.speed > 600
GROUP BY pc.speed;

--Ex.23. Get the makers producing both PCs having a speed of 750 MHz or higher and laptops with a speed of 750 MHz or higher.
SELECT DISTINCT product.maker FROM Product
JOIN PC ON product.model = pc.model
WHERE speed >= 750 AND maker IN
(SELECT maker FROM Product 
JOIN Laptop ON product.model = laptop.model
WHERE speed>=750 );

--Ex.24. List the models of any type having the highest price of all products present in the database.
SELECT DISTINCT model FROM (SELECT model, price FROM pc
UNION
SELECT model, price FROM Laptop
UNION
SELECT model, price FROM Printer) t1
WHERE price = (SELECT MAX(price) FROM (SELECT price FROM pc
UNION
SELECT price FROM Laptop
UNION
SELECT price FROM Printer) t2);

--Ex.25. Find the printer makers also producing PCs with the lowest RAM capacity and the highest processor speed of all PCs having the lowest RAM capacity.
SELECT DISTINCT maker FROM product 
WHERE model IN (
SELECT model FROM pc
WHERE ram = (SELECT MIN(ram) FROM pc) 
AND 
speed = (SELECT MAX(speed) FROM pc
WHERE ram = (SELECT MIN(ram) FROM pc))
)
AND
maker IN (SELECT maker FROM product
WHERE type = 'printer');