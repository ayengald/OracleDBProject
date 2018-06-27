PART 2.A.)

--1

create table items (
   item char(10),
   unitWeight number(6),
   primary key(item) 
); 

--2

create table busEntities (
   entity char(25),
   shipLoc char(10),
   address varchar(20),
   phone varchar(12),
   web varchar(20),
   contact char(10),
   primary key(entity)
); 

--3

create table billOfMaterials(
prodItem char(10), 
matItem char (10), 
QtyMatPerItem number(5),
primary key(prodItem, matItem),
foreign key(prodItem) references items(item),
foreign key(matItem) references items(item)
);

--4

create table supplierDiscounts
(supplier char(25), 
amt1 number(5), 
disc1 number(5), 
amt2 number(5), 
disc2 number(5),
primary key(supplier));

--5

create table supplyUnitPricing(supplier char(9), 
item char(9), 
ppu number(4),
primary key(supplier,item),
foreign key(item) references items(item) on delete cascade);

--6

create table manufDiscounts(
manuf char(25), 
amt1 number(4), 
disc1 number(4),
primary key(manuf));

--7

create table manufUnitPricing
(manuf char(25), 
prodItem char(9), 
setUpCost number(5), 
prodCostPerUnit number(5),
primary key(manuf,prodItem),
foreign key(prodItem) references items(item)
);

--8

create table shippingPricing(
 shipper char(9), 
 fromLoc  char(9), 
 toLoc char(9), 
 minPackagePrice number(5), 
 pricePerLb number(9), 
 amt1 number(9), 
 disc1 number(9), 
 amt2 number (9), 
 disc2 number(9),
 primary key (shipper, fromLoc, toLoc));

--9

create table customerDemand(
 customer char(9), 
 item char(9), 
 qty number(5),
 primary key(customer, item),
 foreign key(item) references items(item));

--10

create table supplyOrders(
 item char(9), 
 supplier char(25), 
 qty number(5),
 primary key(item, supplier),
 foreign key(item) references items(item),
 foreign key(supplier) references BUSENTITIES(entity)
 );

--11

create table manufOrders(
item char(9), 
manuf char(25), 
qty number(6),
primary key(item, manuf),
 foreign key(item) references items(item),
 foreign key(manuf) references BUSENTITIES(entity));

--12

create table shipOrders(
 item char(9), 
 shipper char(9), 
 sender char(25), 
 recipient char(25), 
 qty number(6),
 primary key(item, shipper, sender, recipient),
 foreign key(item) REFERENCES items(item),
 foreign key(sender) REFERENCES BUSENTITIES(entity),
 foreign key(recipient) REFERENCES BUSENTITIES(entity));
