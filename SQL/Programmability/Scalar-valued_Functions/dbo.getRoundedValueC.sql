USE [StandardGraphs]
GO
/****** Object:  UserDefinedFunction [dbo].[getRoundedValueC]    Script Date: 09/05/2017 11:43:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* some tests
select valueToRound, [dbo].[getRoundedValueC]  ( valueToRound ) as res from tblTempValuesToround
*/


alter function [dbo].[getRoundedValueC]  ( @value float )

returns nvarchar(20)

begin
	declare @firstDigit  as nvarchar(1)
	declare @sf as int
	declare @digits as int
	declare @out as float
	declare @format as nvarchar(20)
	declare @i int = 0

	-- find first digit
	set @firstDigit = left(replace(cast(abs(@value) as varchar), '0.', ''), 1)

	-- the first digit is 2, 3, 4, ...
	if (@firstDigit > 1)
	begin
	  -- significant figures are 2
	  set @sf = 2
	  select @digits = max(v) from (values (0), (floor(-log10(abs(@value))) + 2)) as value(v)
	end
	else -- if first digit is 1 or 0:
	begin
	  -- significant figures are 3
	  set @sf = 3
	  if (@value = 0)
	  begin
	    set @digits = 2
	  end
	  else
	  begin
        select @digits = max(v) from (values (0), (floor(-log10(abs(@value)) - 1e-10) + 3)) as value(v)
	  end
	end

	-- round to @sf significant digits
	select @out = case when @value = 0 then 0 else round(@value, @sf - 1 - floor(log10(abs(@value)))) end

	-- set up format string
	set @format = '0.'
	while @i < @digits
    begin
      set @i = @i + 1
	  set @format = @format + '0'
    end

	return format(@out, @format)
end

