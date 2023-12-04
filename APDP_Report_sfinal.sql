Select --b."TargetType", b."TrgetEntry",
a."CardCode" as "Vendor Code", -- Vendor Code
a."CardName" as "Vendor Name", -- Vendor Name
CASE
WHEN a."ObjType" = '-2' THEN 'OB' --Opening Balance
WHEN a."ObjType" = '13' THEN 'IN' -- A/R Invoice --OINV
WHEN a."ObjType" = '14' THEN 'IN' -- A/R Credit Memo --ORIN
WHEN a."ObjType" = '18' THEN 'PU' -- A/P Invoice --OPCH
WHEN a."ObjType" = '19' THEN 'PC'-- A/P Credit Memo --ORPC
WHEN a."ObjType" = '20' THEN 'PD' -- Goods Receipt PO --OPDN
WHEN a."ObjType" = '24' THEN 'RC' -- Incoming Payment --ORCT
WHEN a."ObjType" = '25' THEN 'DP' -- Deposit --ODPS
WHEN a."ObjType" = '30' THEN 'JE' -- Journal Entry --OJDT
WHEN a."ObjType" = '46' THEN 'PS' -- Outgoing Payments --OVPM
WHEN a."ObjType" = '59' THEN 'SI' -- Goods Receipt --OIGN
WHEN a."ObjType" = '60' THEN 'SO' -- Goods Issue --OIGE
WHEN a."ObjType" = '67' THEN 'IM' -- Inventory Transfer --OWTR
WHEN a."ObjType" = '162' THEN 'MR'-- Inventory Revaluation --OMRV
WHEN a."ObjType" = '204' THEN 'DT'-- A/P Down Payment --ODPO
WHEN a."ObjType" = '321' THEN 'JR' -- Internal Reconciliation --OITR
WHEN a."ObjType" = '10000071' THEN 'ST' --Inventory Posting --OIQR
END as "Doc Type", -- Doc Type

a."DocNum" as "Doc Number", -- Doc Number
a."NumAtCard" as "BP Ref", -- BP Ref
a."DocDate" as "Posting date", -- Posting date
a."DocDueDate" as "Due date", -- Due date
a."TaxDate" as "Doc date", -- Doc date
a."DocTotal" as "Amount", -- Amount

CASE
WHEN b."TargetType" = '-1' THEN 'PU' -- A/P Invoice --OPCH
WHEN b."TargetType" = '19' THEN 'PC'-- A/P Credit Memo --ORPC
END as "Doc Type", -- Doc Type

CASE
WHEN b."TargetType" = '-1' THEN d."DocNum"
WHEN b."TargetType" = '19' THEN g."DocNum"
END as "Doc Number", -- Doc Number

CASE
WHEN b."TargetType" = '-1' THEN d."NumAtCard"
WHEN b."TargetType" = '19' THEN g."NumAtCard"
END as "BP Ref", -- BP Ref

CASE
WHEN b."TargetType" = '-1' THEN e."Segment_0" || '-' || e."Segment_1" || '-' || e."Segment_2" || '-' || e."Segment_3" || '-' || e."Segment_4" || '-' || e."Segment_5"
WHEN b."TargetType" = '19' THEN h."Segment_0" || '-' || h."Segment_1" || '-' || h."Segment_2" || '-' || h."Segment_3" || '-' || h."Segment_4" || '-' || h."Segment_5"
END AS "Control Account", --Control Account

CASE
WHEN b."TargetType" = '-1' THEN d."DocDate"
WHEN b."TargetType" = '19' THEN g."DocDate"
END as "Posting date", -- Posting date

CASE
WHEN b."TargetType" = '-1' THEN d."DocDueDate"
WHEN b."TargetType" = '19' THEN g."DocDueDate"
END as "Due date", -- Due date

CASE
WHEN b."TargetType" = '-1' THEN d."TaxDate"
WHEN b."TargetType" = '19' THEN g."TaxDate"
END as "Doc date", -- Doc date

CASE
WHEN b."TargetType" = '-1' THEN c."DrawnSum"
WHEN b."TargetType" = '19' THEN g."DocTotal"
END as "Net Amount Draw", -- Net Amount Draw

CASE
WHEN b."TargetType" = '-1' THEN d."DpmAmnt"
WHEN b."TargetType" = '19' THEN g."PaidSys"
END as "Total Downpayment", -- Total Downpayment

CASE
WHEN b."TargetType" = '-1' THEN d."Comments"
WHEN b."TargetType" = '19' THEN g."Comments"
END as "API Remarks" -- API Remarks

from ODPO a
left join DPO1 b on a."DocEntry" = b."DocEntry"
left join PCH9 c on a."DocEntry" = c."BaseAbs" --and c."ObjCode" =
left join OPCH d on c."DocEntry" = d."DocEntry"
left join OACT e on d."CtlAccount" = e."AcctCode"
--left join RPC9 f on a."DocEntry" = f."BaseAbs"
left join ORPC g on b."TargetType" = g."ObjType" and b."TrgetEntry" = g."DocEntry"
left join OACT h on g."CtlAccount" = h."AcctCode"

where d."DocNum" is not null OR g."DocNum" is not null
-- AND a."DocDate" >= '[%0]'
-- AND a."DocDate" <= '[%1]'
-- AND (a."CardCode" = '[%2]' or ('[%2]' = '' and '[%3]' = '' and '[%4]' = '' )) or a."CardCode" = '[%3]' or a."CardCode" = '[%4]'

order by b."TrgetEntry"