drop table items cascade constraints;
create table items (
   item char(9),
   unitWeight number(4),
   primary key(item) 
); 

insert into items values ( 'item1' , 5);
insert into items values ( 'item2' , 105);
insert into items values ( 'item3' , 34);
insert into items values ( 'item4' , 98);
insert into items values ( 'item5' , 988);
insert into items values ( 'item6' , 123);
insert into items values ( 'item7' , 23);
insert into items values ( 'item8' , 76);
insert into items values ( 'item9' , 55);
insert into items values ( 'item10' , 63);


drop table busEntities cascade constraints;
create table busEntities (
   entity char(25),
   shipLoc char(9),
   address varchar(20),
   phone varchar(12),
   web varchar(20),
   contact char(10),
   primary key(entity)
); 

insert into BUSENTITIES values ( 'customer1' , 'loc1', 'add1', 'web1',5654823651,'con1');
insert into BUSENTITIES values ( 'customer2' , 'loc3', 'add2', 'web2',5654823652,'con2');
insert into BUSENTITIES values ( 'customer3' , 'loc2', 'add3', 'web3',5654823653,'con3');
insert into BUSENTITIES values ( 'customer4' , 'loc1', 'add4', 'web4',5654823654,'con4');
insert into BUSENTITIES values ( 'customer5' , 'loc2', 'add5', 'web5',5654823655,'con5');
insert into BUSENTITIES values ( 'customer6' , 'loc1', 'add6', 'web6',5654823656,'con6');
insert into BUSENTITIES values ( 'manufacturer1' , 'loc3', 'add7', 'web7',6234211231,'con7');
insert into BUSENTITIES values ( 'manufacturer2' , 'loc3', 'add8', 'web8',6234211232,'con8');
insert into BUSENTITIES values ( 'manufacturer3' , 'loc1', 'add9', 'web9',6234211233,'con9');
insert into BUSENTITIES values ( 'supplier1' , 'loc1', 'add10', 'web10',8734211231,'con10');
insert into BUSENTITIES values ( 'supplier2' , 'loc2', 'add11', 'web11',8734211232,'con11');



drop table billOfMaterials cascade constraints;
create table billOfMaterials(
prodItem char(9), 
matItem char (9), 
QtyMatPerItem number(3),
primary key(prodItem, matItem),
foreign key(prodItem) references items(item),
foreign key(matItem) references items(item)
);
insert into BILLOFMATERIALS values('item4' , 'item6', 10);
insert into BILLOFMATERIALS values('item4' , 'item10', 1);
insert into BILLOFMATERIALS values('item6' , 'item5', 4);
insert into BILLOFMATERIALS values('item1' , 'item6', 1);
insert into BILLOFMATERIALS values('item7' , 'item9', 4);



drop table supplierDiscounts cascade constraints;
create table supplierDiscounts
(supplier char(25), 
amt1 number(5), 
disc1 number(4), 
amt2 number(5), 
disc2 number(4),
primary key(supplier));


insert into supplierDiscounts values('supplier1' , 100, 0.15, 500, 0.20);
insert into supplierDiscounts values('supplier2' , 10, 0.15, 1000, 0.25);


drop table supplyUnitPricing;
create table supplyUnitPricing(supplier char(9), 
item char(9), 
ppu number(4),
primary key(supplier,item),
foreign key(item) references items(item));


insert into supplyUnitPricing values( 'supplier1','item1' , 10);
insert into supplyUnitPricing values( 'supplier2','item1' , 12);
insert into supplyUnitPricing values( 'supplier1','item6' , 5);
insert into supplyUnitPricing values( 'supplier1','item9' , 100);
insert into supplyUnitPricing values( 'supplier2','item6' , 5);
insert into supplyUnitPricing values( 'supplier1','item10' , 12);
insert into supplyUnitPricing values( 'supplier2','item5' , 133);

drop table manufDiscounts cascade constraints;
create table manufDiscounts(
manuf char(25), 
amt1 number(4), 
disc1 number(4),
primary key(manuf));

insert into manufDiscounts values('manufacturer1' , 100, 0.35);
insert into manufDiscounts values('manufacturer2' , 10, 0.25);
insert into manufDiscounts values('manufacturer3' , 50, 0.25);


drop table manufUnitPricing;
create table manufUnitPricing
(manuf char(25), 
prodItem char(9), 
setUpCost number(5), 
prodCostPerUnit number(5),
primary key(manuf,prodItem),
foreign key(prodItem) references items(item)
);

insert into MANUFUNITPRICING values( 'manufacturer1','item1' , 13,98);
insert into MANUFUNITPRICING values( 'manufacturer1','item3' , 15,32);
insert into MANUFUNITPRICING values( 'manufacturer1','item6' , 32,45);
insert into MANUFUNITPRICING values( 'manufacturer1','item7' , 135,12);
insert into MANUFUNITPRICING values( 'manufacturer1','item9' , 43,5);
insert into MANUFUNITPRICING values( 'manufacturer1','item10' , 65,18);
insert into MANUFUNITPRICING values( 'manufacturer2','item6' , 25,47);
insert into MANUFUNITPRICING values( 'manufacturer2','item2' , 245,32);
insert into MANUFUNITPRICING values( 'manufacturer2','item1' , 14,102);


 drop table shippingPricing;
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
 
 insert into SHIPPINGPRICING values ( 'shipper1' , 'loc1', 'loc2',20, 10,20,0.15,40,0.20);
 insert into SHIPPINGPRICING values ( 'shipper1' , 'loc2', 'loc1',20, 10,20,0.15,40,0.20);
 insert into SHIPPINGPRICING values ( 'shipper1' , 'loc1', 'loc3',20, 10,20,0.20,40,0.22);
 insert into SHIPPINGPRICING values ( 'shipper1' , 'loc3', 'loc1', 20,10,20,0.20,40,0.22);
 insert into SHIPPINGPRICING values ( 'shipper1' , 'loc2', 'loc3',30, 10,20,0.20,40,0.22);
  insert into SHIPPINGPRICING values ( 'shipper2' , 'loc1', 'loc3', 30,20,30,0.22,50,0.30);
 insert into SHIPPINGPRICING values ( 'shipper2' , 'loc3', 'loc1', 30, 10,25,0.20,40,0.23);
 insert into SHIPPINGPRICING values ( 'shipper2' , 'loc2', 'loc3', 30,10,25,0.20,40,0.28);
  insert into SHIPPINGPRICING values ( 'shipper2' , 'loc3', 'loc2', 30,10,20,0.20,40,0.27);
 
 drop table customerDemand;
 create table customerDemand(
 customer char(9), 
 item char(9), 
 qty number(5),
 primary key(customer, item),
 foreign key(item) references items(item));
 
 insert into CUSTOMERDEMAND values ( 'customer1' , 'item1', 65);
 insert into CUSTOMERDEMAND values ( 'customer1' , 'item5', 197);
 insert into CUSTOMERDEMAND values ( 'customer1' , 'item3', 98);
 insert into CUSTOMERDEMAND values ( 'customer2' , 'item3', 14);
 insert into CUSTOMERDEMAND values ( 'customer2' , 'item7', 123);
 insert into CUSTOMERDEMAND values ( 'customer3' , 'item2', 564);
 insert into CUSTOMERDEMAND values ( 'customer4' , 'item6', 12);
 insert into CUSTOMERDEMAND values ( 'customer5' , 'item9', 877);
 insert into CUSTOMERDEMAND values ( 'customer5' , 'item10', 5);
 insert into CUSTOMERDEMAND values ( 'customer6' , 'item4', 121);
       

   
 
 
 drop table supplyOrders;
 create table supplyOrders(
 item char(9), 
 supplier char(25), 
 qty number(5),
 primary key(item, supplier),
 foreign key(item) references items(item),
 foreign key(supplier) references BUSENTITIES(entity)
 );
 
  insert into supplyOrders values('item6' , 'supplier1', 20);
  insert into supplyOrders values('item6' , 'supplier2', 60);
  insert into supplyOrders values('item10' , 'supplier1', 100);
  insert into supplyOrders values('item9' , 'supplier1', 877);
 
drop table manufOrders;
create table manufOrders(
item char(9), 
manuf char(25), 
qty number(6),
primary key(item, manuf),
 foreign key(item) references items(item),
 foreign key(manuf) references BUSENTITIES(entity));
 
 insert into manufOrders values('item1' , 'manufacturer1', 20);
 insert into manufOrders values('item1' , 'manufacturer2', 60);
 insert into manufOrders values('item2' , 'manufacturer1', 50);
 insert into manufOrders values('item4' , 'manufacturer3', 20);
 insert into manufOrders values('item7' , 'manufacturer1', 98);
 insert into manufOrders values('item3' , 'manufacturer1', 14);
 
 
 drop table shipOrders;
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
 
 
  insert into SHIPORDERS values('item1','shipper2' , 'manufacturer1', 'customer1',20);
  insert into SHIPORDERS values('item5','shipper2' , 'manufacturer2', 'customer1',197);
  insert into SHIPORDERS values('item3','shipper1' , 'manufacturer1', 'customer2',14);
  insert into SHIPORDERS values('item7','shipper2' , 'manufacturer1', 'customer2',98);
  insert into SHIPORDERS values('item6','shipper2' , 'supplier2', 'customer4',12);
  insert into SHIPORDERS values('item4','shipper1' , 'manufacturer2', 'customer6',121);
  insert into SHIPORDERS values('item6','shipper2' , 'supplier1', 'manufacturer2',100);
  insert into SHIPORDERS values('item6','shipper2' , 'supplier1', 'manufacturer1',25);
   insert into SHIPORDERS values('item9','shipper2' , 'supplier1', 'manufacturer1',25);