Select a."TransId",
             d."DocEntry",
             c."BaseAbs",
             a."DocEntry",
             b."TargetType",
             b."TrgetEntry",
             b."BaseRef",
             b."BaseEntry",
             b."BaseType",
             b."ObjType",
             a."CardCode"                          as "Vendor Code",       -- Vendor Code
             a."CardName"                          as "Vendor Name",       -- Vendor Name
             CASE
                 WHEN a."ObjType" = '204' THEN 'DT'
                 ELSE '-'-- A/P Down Payment --ODPO
                 END                               as "Doc Type",          -- Doc Type

             a."DocNum"                            as "Doc Number",        -- Doc Number
             a."NumAtCard"                         as "BP Ref",            -- BP Ref
             a."DocDate"                           as "Posting date",      -- Posting date
             a."DocDueDate"                        as "Due date",          -- Due date
             a."TaxDate"                           as "Doc date",          -- Doc date
             a."DocTotal"                          as "Amount",            -- Amount
             CASE
                 WHEN d."ObjType" = '-2' THEN 'OB' --Opening Balance
                 WHEN d."ObjType" = '13' THEN 'IN' -- A/R Invoice --OINV
                 WHEN d."ObjType" = '14' THEN 'IN' -- A/R Credit Memo --ORIN
                 WHEN d."ObjType" = '18' THEN 'PU' -- A/P Invoice --OPCH
                 WHEN d."ObjType" = '19' THEN 'PC'-- A/P Credit Memo --ORPC
                 WHEN d."ObjType" = '20' THEN 'PD' -- Goods Receipt PO --OPDN
                 WHEN d."ObjType" = '24' THEN 'RC' -- Incoming Payment --ORCT
                 WHEN d."ObjType" = '25' THEN 'DP' -- Deposit --ODPS
                 WHEN d."ObjType" = '30' THEN 'JE' -- Journal Entry --OJDT
                 WHEN d."ObjType" = '46' THEN 'PS' -- Outgoing Payments --OVPM
                 WHEN d."ObjType" = '59' THEN 'SI' -- Goods Receipt --OIGN
                 WHEN d."ObjType" = '60' THEN 'SO' -- Goods Issue --OIGE
                 WHEN d."ObjType" = '67' THEN 'IM' -- Inventory Transfer --OWTR
                 WHEN d."ObjType" = '162' THEN 'MR'-- Inventory Revaluation --OMRV
                 WHEN d."ObjType" = '204' THEN 'DT'-- A/P Down Payment --ODPO
                 WHEN d."ObjType" = '321' THEN 'JR' -- Internal Reconciliation --OITR
                 WHEN d."ObjType" = '10000071' THEN 'ST' --Inventory Posting --OIQR
                 END                               as "Doc Type",          -- Doc Type

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
               left join PCH9 c on a."DocEntry" = c."BaseAbs" --and c."ObjCode" =
               left join OPCH d on c."DocEntry" = d."DocEntry"
               left join OACT e on d."CtlAccount" = e."AcctCode"
      --left join RPC9 f on a."DocEntry" = f."BaseAbs"
--left join ORPC g on b."TargetType" = g."ObjType" and b."TargetEntry" = g."DocEntry"