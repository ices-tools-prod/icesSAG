use [StandardGraphs]
go
/****** Object:  UserDefinedFunction [dbo].[getRoundedValue]    Script Date: 09/05/2017 11:40:46 ******/
set ANSI_NULLS on
go
set QUOTED_IDENTIFIER on
go

/* some tests
select [dbo].[getRoundedValue]  (  0.00015556999 )
select [dbo].[getRoundedValue]  (  f) as f, f as FOld, round( ssb, 0) as ssb, ssb as oldSSB from Fishdata
update tblTempValuesToround set valuesRounded = [dbo].[getRoundedValue]  ( valueToRound )
select * FROM tblTempValuesToround
*/

alter function [dbo].[getRoundedValue]  (  @value float )
returns float
begin
  return cast([dbo].[getRoundedValueC] (@value) as float)
 end
