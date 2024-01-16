/*SELECT FROM ODPO T0 WHERE T0."DocDate" >=[%0] T0."DocDate" <=[%1] T0."CardName" =[%2] T0."CardName" =[%3] T0."CardName" =[%4];*/

select T0."Vendor Code",
       T0."Vendor Name",
       T0."APDP_Doc Type",    -- Doc Type
       T0."APDP_Doc Number",
       T0."APDP_BP Ref",
       T0."APDP_Posting date",
       T0."APDP_Due date",
       T0."APDP_Doc date",
       T0."Amount",
       T0."ObjType",
       CASE
           WHEN T0."ObjType" = '-2' THEN 'OB' --Opening Balance
           WHEN T0."ObjType" = '13' THEN 'IN' -- A/R Invoice --OINV
           WHEN T0."ObjType" = '14' THEN 'IN' -- A/R Credit Memo --ORIN
           WHEN T0."ObjType" = '18' THEN 'PU' -- A/P Invoice --OPCH
           WHEN T0."ObjType" = '19' THEN 'PC'-- A/P Credit Memo --ORPC
           WHEN T0."ObjType" = '20' THEN 'PD' -- Goods Receipt PO --OPDN
           WHEN T0."ObjType" = '24' THEN 'RC' -- Incoming Payment --ORCT
           WHEN T0."ObjType" = '25' THEN 'DP' -- Deposit --ODPS
           WHEN T0."ObjType" = '30' THEN 'JE' -- Journal Entry --OJDT
           WHEN T0."ObjType" = '46' THEN 'PS' -- Outgoing Payments --OVPM
           WHEN T0."ObjType" = '59' THEN 'SI' -- Goods Receipt --OIGN
           WHEN T0."ObjType" = '60' THEN 'SO' -- Goods Issue --OIGE
           WHEN T0."ObjType" = '67' THEN 'IM' -- Inventory Transfer --OWTR
           WHEN T0."ObjType" = '162' THEN 'MR'-- Inventory Revaluation --OMRV
           WHEN T0."ObjType" = '204' THEN 'DT'-- A/P Down Payment --ODPO
           WHEN T0."ObjType" = '321' THEN 'JR' -- Internal Reconciliation --OITR
           WHEN T0."ObjType" = '10000071' THEN 'ST' --Inventory Posting --OIQR
           END as "Doc Type", -- Doc Type
       T0."Doc Number",
       T0."BP Ref",
       T0."Control Account",
       T0."Posting date",
       T0."Due date",
       T0."Doc date",
       T0."Net Amount Draw",
       T0."Total Downpayment",
       T0."API Remarks"

FROM (Select a."CardCode"                          as "Vendor Code",       -- Vendor Code
             a."CardName"                          as "Vendor Name",       -- Vendor Name
             CASE
                 WHEN a."ObjType" = '204' THEN 'DT'
                 ELSE '-'-- A/P Down Payment --ODPO
                 END                               as "APDP_Doc Type",     -- Doc Type

             a."DocNum"                            as "APDP_Doc Number",   -- Doc Number
             a."NumAtCard"                         as "APDP_BP Ref",       -- BP Ref
             a."DocDate"                           as "APDP_Posting date", -- Posting date
             a."DocDueDate"                        as "APDP_Due date",     -- Due date
             a."TaxDate"                           as "APDP_Doc date",     -- Doc date
             a."DocTotal"                          as "Amount",            -- Amount
             d."ObjType" as "ObjType",
             d."DocNum"                            as "Doc Number",        -- Doc Number
             d."NumAtCard"                         as "BP Ref",            -- BP Ref
             e."Segment_0" || '-' || e."Segment_1" || '-' || e."Segment_2" || '-' || e."Segment_3" || '-' ||
             e."Segment_4" || '-' || e."Segment_5" AS "Control Account",   --Control Account
             d."DocDate"                           as "Posting date",      -- Posting date
             d."DocDueDate"                        as "Due date",          -- Due date
             d."TaxDate"                           as "Doc date",          -- Doc date
             c."DrawnSum"                          as "Net Amount Draw",   -- Net Amount Draw
             d."DpmAmnt"                           as "Total Downpayment", -- Total Downpayment
             d."Comments"                          as "API Remarks"        -- API Remarks

      from ODPO a
               left join DPO1 b on a."DocEntry" = b."DocEntry"
               inner join PCH9 c on a."DocEntry" = c."BaseAbs" --and c."ObjCode" =
               left join OPCH d on c."DocEntry" = d."DocEntry"
               left join OACT e on d."CtlAccount" = e."AcctCode"

      union all

      Select a."CardCode"                          as "Vendor Code",       -- Vendor Code
             a."CardName"                          as "Vendor Name",       -- Vendor Name
             CASE
                 WHEN a."ObjType" = '204' THEN 'DT'
                 ELSE '-'-- A/P Down Payment --ODPO
                 END                               as "APDP_Doc Type",     -- Doc Type

             a."DocNum"                            as "APDP_Doc Number",   -- Doc Number
             a."NumAtCard"                         as "APDP_BP Ref",       -- BP Ref
             a."DocDate"                           as "APDP_Posting date", -- Posting date
             a."DocDueDate"                        as "APDP_Due date",     -- Due date
             a."TaxDate"                           as "APDP_Doc date",     -- Doc date
             a."DocTotal"                          as "Amount",            -- Amount
             g."ObjType" as "ObjType",
             g."DocNum"                            as "Doc Number",        -- Doc Number
             g."NumAtCard"                         as "BP Ref",            -- BP Ref
             h."Segment_0" || '-' || h."Segment_1" || '-' || h."Segment_2" || '-' || h."Segment_3" || '-' ||
             h."Segment_4" || '-' || h."Segment_5" AS "Control Account",   --Control Account
             g."DocDate"                           as "Posting date",      -- Posting date
             g."DocDueDate"                        as "Due date",          -- Due date
             g."TaxDate"                           as "Doc date",          -- Doc date
             g."DocTotal"                          as "Net Amount Draw",   -- Net Amount Draw
             g."PaidSys"                           as "Total Downpayment", -- Total Downpayment
             g."Comments"                          as "API Remarks"        -- API Remarks

      from ODPO a
               left join DPO1 b on a."DocEntry" = b."DocEntry"
               inner join ORPC g on b."TargetType" = g."ObjType" and b."TrgetEntry" = g."DocEntry"
               left join OACT h on g."CtlAccount" = h."AcctCode") as T0

--where T0."APDP_Doc Number" = '100003156'
--
where T0."APDP_Posting date" >= '[%0]'
AND T0."APDP_Posting date" <= '[%1]'
AND (T0."Vendor Name" = '[%2]' or ('[%2]' = '' and '[%3]' = '' and '[%4]' = '' )) or T0."Vendor Name" = '[%3]' or T0."Vendor Name" = '[%4]'

order by T0."Vendor Name"