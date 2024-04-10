use AdventureWorks2019
go

Drop view  if exists FinishedGoods
go
create view FinishedGoods as
select *
from production.Product
where FinishedGoodsFlag=1
go
