
-- Manifold 9's SQL syntax highlighting in Notepad++ UDL 2.1


Solarized Dark colors https://en.wikipedia.org/wiki/Solarized
Base03  "002B36"    0  43  54  UNUSED background tone (dark theme)
Base02  "073642"    7  54  66  UNUSED background tone (dark theme)
Base01  "586E75"   88 110 117  -- comments
Base00  "657B83"  101 123 131  default names
Base0   "839496"  131 148 150  UNUSED
Base1   "93A1A1"  147 161 161  [table_names], #2024-05-23#, 123, &, ()      
Base2   "EEE8D5"  238 232 213  UNUSED background tone (light theme) 
Base3   "FDF6E3"  253 246 227  UNUSED background tone (light theme) 
Yellow  "B58900"  181 137   0  'string' 
Orange  "CB4B16"  203  75  22  @variable_name
Red     "DC322F"  220  50  47  !fullfetch 
Magenta "D33682"  211  54 130  INT32
Violet  "6C71C4"  108 113 196  TileRenderSingleWindow, Avg, FALSE, CALL
Blue    "268BD2"   38 139 210  SELECT
Cyan    "2AA198"   42 161 152  UNUSED
Green   "859900"  133 153   0  [[ contexts ]]


-- Default
-- Default text style is only used for unquoted identifiers
a_table_name
a_column_name
a_function_name


-- Comments
-- This is an example of comment


-- Numbers
1 2 3456 23.454 .023 1e9


-- Keywords1 
-- SQL keywords
CREATE
DROP
ALTER
SELECT
FROM
WHERE
ORDER BY

-- Keywords2 
-- Builtin scalar functions
Abs
BinaryStringBase64
Cos
VectorDot

-- Keywords3 
-- SQL types 
BOOLEAN
DATETIME
GEOM
UINT64X3

-- Keywords4 
-- Builtin aggregate functions
Avg
Count
GeomMergeAreas
Min
Sum

-- Keywords5 
-- Builtin constants
CRLF
FLOAT64MAX
NULL
PI

-- Keywords6 
-- Builtin functions returning TABLE requring a CALL 
CALL ComponentFieldDrawing
CALL ValueSequenceRandom


-- Keywords7 - variable names beginning with a @
-- See also Delimiters4
@variable_name


-- Keywords8 
-- Special strings used for pragma, collation options, etc.
'createdname'
'auto'


-- Delimiters1 - escapeless strings
@'London'
@'C:\no\escape\needed\'


-- Delimiters2 - strings
'London'
'\'s-Hertogenbosch'


-- Delimiters4 - variable names beginning with a @
-- See also Keywords7
@[ a crazy variable name $ 5@six.com ]


-- Delimiters3 - context and expression double-angle-brackets
[[ context ]]


-- Delimiters5 - SQL table, column, etc. name in brackets
[a table name]
"a table name"
`a table name`

-- Delimiters6 - 
UNUSED 

-- Delimiters7 - datetime literals
#01/21/2017 12:05:15#


-- Delimiters8 - Expression evaluation and SQL engine directives
?DataLength('SQL is Great!')
!manifold
!fullfetch


-- Operators1
-- Symbol-like "operators", that do not require surrounding whitespace and 
-- can itself act as separators between words.
% & * + - / < <= <> = > >= ^ , :: . ; { } :


-- Operators2                                        
-- Word-like "operators", that require surrounding whitespace or separators
UNUSED 


-- Code folding
---------------
-- start folding by {{ two opening squiggly braces inside comments
-- many 
-- folded
-- lines
-- end folding by }} two closing squiggly braces inside comments  


-- More examples 
-- foldable region starts here {{ 

SELECT * FROM [Files] WHERE [Path] like @'C:\no\escape\needed\' ;
SELECT * FROM [Orders] WHERE [City] = @'London' ;

SELECT * FROM [Orders] WHERE [City] = 'London' ;
SELECT * FROM [Orders] WHERE [City] = '\'s-Hertogenbosch' ;

EXECUTE WITH (@x INT32 = 2, @y INT32 = 20) [[ INSERT INTO dbo.t (a, b) VALUES (@x@, @y@) ]] ON [sql];

EXECUTE WITH (@n TABLE = [States Table])
[[
    FUNCTION f(@T TABLE) TABLE AS
      (SELECT Max([Population]) FROM @T) END;
    TABLE CALL f(@n);
]]
;

FUNCTION f(@[ a crazy param name $ 5@six.com ] TABLE, @not_bigger_than INT32) TABLE AS
(
  SELECT Max([Population]) FROM @[ a crazy param name $ 5@six.com ] WHERE [Population] < @not_bigger_than
)
END
;

SELECT * FROM [2016 Roads];
SELECT * FROM `2016 Roads`;
SELECT * FROM "2016 Roads";
SELECT [Population 1990] FROM [Countries];
SELECT "Population 1990" FROM `Countries`;

SELECT * FROM [Orders] WHERE [datetime] > #01/21/2017 12:05:15# ;


!fullfetch
!native
!manifold

? DataLength('SQL is Great!')
-- float64: 28
? DataLength(CAST ('SQL is Great!' AS VARCHAR))
-- float64: 14


CREATE TABLE [Table] (
  [name] NVARCHAR,
  INDEX [name_x] BTREENULL ([name] COLLATE 'en-US, nocase, noaccent')
);
 
PRAGMA ('gpgpu' = 'aggressive');
PRAGMA ('gpgpu'='aggressive', 'gpgpu.fp'='32')


-- Tables from datasources using ::
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

DELETE FROM [ContinuousColor Table];
INSERT INTO [ContinuousColor Table] ( [v], [x], [y] )
SELECT 
  [Value]*20 as [v],
  Trunc([Value]*40*40) div 40 as [x],
  Trunc([Value]*40*40) mod 40 as [y]
FROM
  CALL ValueSequenceRandom(500, 111)
;

SELECT 
  parcel, 
  SPLIT (COLLECT building, area ORDER BY area DESC FETCH 3)
FROM
(
  SELECT 
    p.[mfd_id] AS [parcel], 
    b.mfd_id AS building,
    GeomArea(b.[geom (i)], 0) AS area
  FROM 
    [parcels Table] AS p 
    INNER JOIN 
    [buildings Table] AS b
    ON GeomContains(p.[geom (i)], b.[geom (i)], 0)
)
GROUP BY parcel;

--}}