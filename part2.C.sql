
--Part 2.C

--1
SELECT distinct customer
FROM shippedVsCustDemand
where demandqty > SuppliedQty;

--2
SELECT distinct supplier
FROM suppliedVsShipped
where ShippedQty < SuppliedQty;

--3
SELECT distinct manuf 
FROM matsUsedVsShipped
where ShippedQty < RequiredQty;

--4
SELECT distinct manuf
FROM producedVsShipped
where ShippedoutQty < OrderedQty;