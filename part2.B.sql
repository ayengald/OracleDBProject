PART 2.B.)

--1

DROP VIEW shippedVsCustDemand;
CREATE VIEW shippedVsCustDemand AS
(
	SELECT C.customer, C.item, COALESCE(SUM(S.qty),0) AS Suppliedqty, C.qty AS demandqty
	FROM customerDemand C, shipOrders S
	Where c.customer = S.recipient (+) AND C.Item = S.Item (+)
    GROUP BY C.customer, C.Item, C.qty
);
select * from shippedVsCustDemand order by Customer asc;

--2

DROP VIEW totalManufItems;
CREATE VIEW totalManufItems as 
(SELECT item, COALESCE(SUM(qty),0) 
AS totalManufqty
FROM manufOrders GROUP BY item);
select * from totalManufItems;

--3

DROP VIEW temp;
CREATE VIEW temp as 
(SELECT mo.manuf, bm.matItem, sum(MO.qty*BM.QtyMatPerItem) as requiredqty 
	FROM billOfMaterials bm, manufOrders mo 
	WHERE bm.prodItem = mo.item 
	GROUP BY mo.manuf, bm.matitem);

DROP VIEW matsUsedVsShipped;
CREATE VIEW matsUsedVsShipped as 
(SELECT a.manuf, a.matitem, a.requiredqty, sum(so.qty) as shippedqty 
	FROM temp a, shipOrders so 
	WHERE a.matitem = so.item (+) AND a.manuf= so.recipient 
	GROUP BY a.manuf, a.matItem, a.requiredqty);
SELECT * FROM matsUsedVsShipped;

--4

DROP VIEW totalQuantity_items;
CREATE VIEW totalQuantity_items AS
(SELECT item, sender, COALESCE(sum(qty),0) as totalqty 
FROM shipOrders GROUP BY item,sender);

DROP VIEW producedVsShipped;
CREATE VIEW producedVsShipped as
(SELECT m.item, m.manuf, COALESCE(t.totalqty,0) as ShippedOutQty, m.qty as OrderedQty FROM manufOrders m, totalQuantity_items t
where m.manuf=t.sender (+) and m.item = t.item (+));
Select * from producedVsShipped;

--5

DROP VIEW suppliedVsShipped ;
CREATE VIEW suppliedVsShipped as 
(SELECT so.item, so.supplier,  so.qty as SuppliedQty, COALESCE(sum(s.qty),0) as ShippedQty
FROM supplyOrders so, shipOrders s
where so.supplier=s.sender (+) and so.item=s.item (+)
GROUP BY so.supplier, so.item, so.qty);
select * from suppliedVsShipped order by supplier asc;

--6

DROP VIEW totalcost_items;
CREATE VIEW totalcost_items as
	(SELECT so.supplier,sum(so.qty*s.ppu) as total_cost
		FROM supplyOrders so left join supplyUnitPricing s on so.item=s.item and so.supplier=s.supplier
		GROUP BY so.supplier);

DROP VIEW perSupplierCost;
CREATE VIEW perSupplierCost as
	(SELECT sd.supplier, 
	case when (s.total_cost>=sd.amt1 and s.total_cost<sd.amt2) 
			then sd.amt1 + (s.total_cost-sd.amt1)*(1-sd.disc1)
		when (s.total_cost>=sd.amt2) 
			then sd.amt1 + (s.total_cost-sd.amt2)*(1-sd.disc2) + (sd.amt2 - sd.amt1)*(1-sd.disc1)
		else s.total_cost
			end as Cost
		FROM supplierDiscounts sd left join totalcost_items s on s.supplier=sd.supplier);
select * from perSupplierCost ;
											
--7

DROP VIEW perManufCost1;
CREATE VIEW perManufCost1 as
	(SELECT mo.manuf,mo.item, mp.setUpCost+mo.qty*mp.prodCostPerUnit as cost
		FROM manufOrders mo, manufUnitPricing mp
			where mo.manuf=mp.manuf (+) and mo.item=mp.prodItem (+)
		GROUP BY mo.manuf,mo.item,mp.setUpCost+mo.qty*mp.prodCostPerUnit);

DROP VIEW perManufCost2;
CREATE VIEW perManufCost2 as
	(SELECT m.manuf, COALESCE(sum(m.cost),0) as total_cost
		FROM perManufCost1 m
		GROUP BY m.manuf );

DROP VIEW perManufCost;
CREATE VIEW perManufCost as
(SELECT md.manuf, 
	case when (t2.total_cost>md.amt1) then (t2.total_cost-md.amt1)*(1- md.disc1)+ md.amt1
	else t2.total_cost
	end as Cost
	FROM manufDiscounts md left join perManufCost2 t2 on md.manuf=t2.manuf);
select * from perManufCost order by manuf;
											
--8

DROP VIEW ItemShipLoc;
CREATE VIEW ItemShipLoc as
(SELECT s.item,s.shipper,b1.shipLoc as fromLoc,b2.shipLoc as toLoc, s.qty
	FROM shipOrders s, busEntities b1, busEntities b2
	where b1.entity=s.sender and b2.entity=s.recipient);

DROP VIEW ItemQty;
CREATE VIEW ItemQty as
(SELECT l.shipper,l.fromLoc,l.toLoc,l.item, l.qty*i.unitWeight as Item_Weight
	FROM ItemShipLoc l,items i
	where i.item=l.item
	GROUP BY l.shipper,l.fromLoc,l.toLoc, l.item,  l.qty*i.unitWeight);


DROP VIEW totalQty;
CREATE VIEW totalQty as
(SELECT l.shipper,l.fromLoc,l.toLoc,COALESCE(sum(l.Item_Weight),0) as totalWt
	FROM ItemQty l
	GROUP BY l.shipper,l.fromLoc,l.toLoc);

DROP VIEW totalPrice;
CREATE VIEW totalPrice as
(SELECT s.shipper,s.fromLoc,s.toLoc,s.minPackagePrice, 
	case when (l.totalWt*s.pricePerLb>=amt1 and l.totalWt*s.pricePerLb<=amt2) then (l.totalWt*s.pricePerLb - s.amt1)*(1- s.disc1)+ s.amt1
		 when (l.totalWt*s.pricePerLb>amt2) then s.amt1 + (s.amt2 - s.amt1)*(1- s.disc1)+(l.totalWt*s.pricePerLb-s.amt2)*(1- s.disc2)
	else l.totalWt*s.pricePerLb
	end as PackagePrice
	FROM shippingPricing s left join totalQty l on s.shipper=l.shipper and s.fromLoc=l.fromLoc and s.toLoc=l.toLoc);

DROP VIEW MinPrice;
CREATE VIEW MinPrice as
(SELECT s.shipper,s.fromLoc,s.toLoc,
	case when (s.minPackagePrice>s.PackagePrice) then s.minPackagePrice
	else s.PackagePrice
	end as MinCost
	FROM totalPrice s);

DROP VIEW perShipperCost;
CREATE VIEW perShipperCost as
(SELECT shipper, COALESCE(sum(MinCost),0) as Cost
	FROM MinPrice
	GROUP BY shipper);
select * from perShipperCost;

--9

DROP VIEW totalCostBreakdown;
CREATE VIEW totalCostBreakdown as
(SELECT totalSuppliercost as SupplyCost, totalManufCost as ManufCost, totalShipperCost as ShippingCost
FROM (SELECT sum(Cost) as totalShipperCost FROM perShipperCost),(SELECT sum(Cost) as totalManufCost FROM 
perManufCost),
(SELECT sum(Cost) as totalSuppliercost FROM perSupplierCost));
select * from totalCostBreakdown;
