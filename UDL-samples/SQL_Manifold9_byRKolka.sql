
-- Describing Manifold 9's SQL syntax in Notepad++ UDL 2.1 (User Defined Language) style terms.

-- Default
----------------------------
-- Default text style is only used for unquoted identifiers eg
a_table_name
a_column_name
a_function_name

-- Comments
----------------------------
-- This is an example of comment

-- Numbers
----------------------------
1 2 3456 23.454 .023 1e9


-- Keywords
----------------------------

-- Keywords1 - SQl keywords
CREATE 
DROP
ALTER
SELECT 
FROM
WHERE
ORDER BY

-- Keywords2 - Builtin scalar functions
-- Builtin scalar functions are styled as violet
Abs
BinaryStringBase64
Cos
VectorDot

-- Keywords3 - SQL types 
-- Manifold 9 SQL types are styled as magenta
BOOLEAN 
DATETIME
GEOM
UINT64X3

-- Keywords4 - Builtin aggregate functions
-- Builtin aggregate functions are styled as violet and bold
Avg
Count
GeomMergeAreas
Min
Sum

-- Keywords5 - Builtin constants
-- Builtin aggregate functions are styled as violet and bold
CRLF
FLOAT64MAX
NULL
PI

-- Keywords6 - Builtin functions returning TABLE
-- Builtin aggregate functions are those requring a CALL 
-- Builtin aggregate functions are styled as violet and bold underlined
CALL ComponentFieldDrawing
CALL ValueSequenceRandom


-- Keywords7 - variable names beginning with a @
-- see also Delimiters4
@var
@param

-- Keywords8 - special strings used for pragmaa, collation options, etc.
-- Styled as strings but underlined
'createdname'
'auto'
'progress.percentnext'



-- Operators
----------------------------
-- Symbol-like "operators", that do not require surrounding whitespace and 
-- can itself act as separators between words.
-- Operators 1
% & * + - / < <= <> = > >= ^ , :: . ; { } :
-- Word-like "operators", that require surrounding whitespace or separators
-- Operators 2                                        
AND
BETWEEN
BITAND
INTERSECT ALL
LIKE
-- (some word-like operators might belong to the keyword list)


-- Delimiter pairs
----------------------------
--    NOTE: Order of {1, 2} and {3, 4, 5} is important

-- Delimiters1 - escapeless strings
@'London'
@'C:\no\escape\needed\'

-- Delimiters2 - strings
'London'
'\'s-Hertogenbosch'

-- Delimiters3 - context and expression double-angle-brackets
[[ context ]]

-- Delimiters4 - variable names beginning with @ in angle-brackets 
@[ a crazy variable name $ 5@six.com ]

-- Delimiters5 - SQL table, column, etc. names brackets with alternatives
[a table name]
"a table name"
`a table name` 
[geom]
[ID]

-- Delimiters6 - parenthesis (testing, should remove?)    «(»   «)»   

-- Delimiters7 - datetime literals
#01/21/2017 12:05:15#


-- Delimiters8 - Expression evaluation and SQL engine directives
?DataLength('SQL is Great!')
!manifold
!fullfetch

-- Code folding
-------------

-- start folding by {{ two opening squiggly braces inside comments
-- many 
-- folded
-- lines
-- end folding by }} two closing squiggly braces inside comments  


-- Examples
------------

-- {{  Delimiter 1  «@'»  «'»  sample
SELECT * FROM [Files] WHERE [Path] like @'C:\no\escape\needed\' ;
SELECT * FROM [Orders] WHERE [City] = @'London' ;
-- }}


-- {{  Delimiter 2  «'»   «'»  sample
SELECT * FROM [Orders] WHERE [City] = 'London' ;
SELECT * FROM [Orders] WHERE [City] = '\'s-Hertogenbosch' ;
-- }}


--  {{  Delimiter 3  «[[»  «]]»  sample
EXECUTE WITH (@x INT32 = 2, @y INT32 = 20) [[ INSERT INTO dbo.t (a, b) VALUES (@x@, @y@) ]] ON [sql];

EXECUTE WITH (@n TABLE = [States Table])  
[[
    FUNCTION f(@T TABLE) TABLE AS
      (SELECT Max([Population]) FROM @T) END;
    TABLE CALL f(@n);
]]
;
-- }} 
sdw

--  {{  Delimiter 4 «@[»  «]» / Keyword 7  «@» sample
FUNCTION f(@[ a crazy param name $ 5@six.com ] TABLE, @not_bigger_than INT32) TABLE AS
(
  SELECT Max([Population]) FROM @[ a crazy param name $ 5@six.com ] WHERE [Population] < @not_bigger_than
)
END
;
-- }} 


--  {{  Delimiter 5 «[» «]», «`» «`», «"» «"»  sample
SELECT * FROM [2016 Roads];
SELECT * FROM `2016 Roads`;
SELECT * FROM "2016 Roads";
SELECT [Population 1990] FROM [Countries];
SELECT "Population 1990" FROM `Countries`;
-- }} 


--  {{  Delimiter 7 «#» «#» sample
SELECT * FROM [Orders] WHERE [datetime] > #01/21/2017 12:05:15# ;
-- }} 


--  {{  Delimiter 8 «!», «?» sample
!fullfetch
!native
!manifold

? DataLength('SQL is Great!')
-- float64: 28
? DataLength(CAST ('SQL is Great!' AS VARCHAR))
-- float64: 14
-- }} 
 

--  {{  Keywords 8 sample
-- Delimiter 2 single-quotes nest Keywords 8 (and Operators 1 and Delimiter 5)
CREATE TABLE [Table] (
  [name] NVARCHAR,
  INDEX [name_x] BTREENULL ([name] COLLATE 'en-US, nocase, noaccent')
);
 
PRAGMA ('gpgpu' = 'aggressive');
PRAGMA ('gpgpu'='aggressive', 'gpgpu.fp'='32')
--}}



--  {{  Tables from datasources using «::» sample

SELECT 
  [USA States].[State], 
  [USA States].[Population], 
  [City Capitals].[Capital]
FROM 
  [USA]::[States] AS [USA States] 
  JOIN 
  [Cities]::[Capitals] AS [City Capitals]
  ON 
  [USA States].[State] = [City Capitals].[State]
;
--}}

--  {{  Function samples
-- Pure SQL/9 function
FUNCTION combine(@p NVARCHAR, @q NVARCHAR) NVARCHAR AS @p & ': ' & @q  END;

-- Function from dll
FUNCTION F(@x FLOAT64) FLOAT64 AS SCRIPT FILE 'math2.dll' ENTRY 'math.Var.F';


-- Inline SCRIPT and FUNCTION in the context of computed field 
ALTER TABLE t (
  ADD insertdate DATETIME
    WITH
	-- context starts
	[[
	SCRIPT funcs ENGINE 'c#' 
		-- inline SCRIPT starts
		[[
		class Script
		{
			static System.DateTime F() { return System.DateTime.Now; }
		}
		]];
		-- inline SCRIPT ends
	FUNCTION currentdate() DATETIME AS SCRIPT INLINE funcs ENTRY 'Script.F';
	]]
	-- context ends
-- expression starts
    AS [[ currentdate() ]]
-- expression ends
);

--}}

--  {{  JSON double-quoted values in single-quoted string sample
-- Note: Delimiter 2 single-quotes nest Delimiter 5 and Operators 1 (and Keywords 8)
CREATE TABLE [ContinuousColor Table] (
  [mfd_id] INT64,
  [Geom] GEOM,
  [v] FLOAT32,
  [x] FLOAT32,
  [y] FLOAT32,
  INDEX [mfd_id_x] BTREE ([mfd_id]),
  INDEX [Geom_x] RTREE ([Geom]),
  PROPERTY 'FieldCoordSystem.Geom' 'EPSG:3301,mfd:{ "Axes": "XY" }'
);

CREATE DRAWING [ContinuousColor] (
  PROPERTY 'FieldGeom' 'Geom',
  PROPERTY 'StylePointColor' '{ "Value": 11119017 }',
  PROPERTY 'StylePointColorBack' '{ "Field": "v", "Fill": "boundaverage", "Value": 16777215, "Values": { "0": 16777215, "10": 3688006, "15": 15594514, "20": 16777215, "5": 2287079 } }',
  PROPERTY 'StylePointSize' '{ "Value": 8 }',
  PROPERTY 'Table' '[ContinuousColor Table]'
);

-- Query in single-quoted string
CREATE QUERY [Insert_ContinuousColor] (
  PROPERTY 'Text' '
  -- $manifold$
  DELETE FROM [ContinuousColor Table];
  INSERT INTO [ContinuousColor Table] ( [v], [x], [y] )
  SELECT 
  [Value]*20 as [v],
  Trunc([Value]*40*40) div 40 as [x],
  Trunc([Value]*40*40) mod 40 as [y]
  FROM
  CALL ValueSequenceRandom(500, 111)
  ;
'
);
--}}

  DELETE FROM [ContinuousColor Table];
  INSERT INTO [ContinuousColor Table] ( [v], [x], [y] )
  SELECT 
  [Value]*20 as [v],
  Trunc([Value]*40*40) div 40 as [x],
  Trunc([Value]*40*40) mod 40 as [y]
  FROM
  CALL ValueSequenceRandom(500, 111)
  ;