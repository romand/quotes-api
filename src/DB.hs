{-# LANGUAGE QuasiQuotes #-}
module DB where

import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.SqlQQ
import Database.PostgreSQL.Simple.FromField
import GHC.Generics

import Quote

newtype QuoteID = QuoteID(Int) deriving (Generic, Show)
instance FromField QuoteID where
  fromField field mdata = QuoteID <$> fromField field mdata

createQuote :: Quote -> IO QuoteID
createQuote Quote{ applicantName
                 , insuranceStartDate
                 , insuranceEndDate
                 , insuredItemPrice
                 } = do
  conn <- connectPostgreSQL
    "host=localhost user=postgres password=mysecretpassword"
  [Only id] <- query conn
    [sql| INSERT INTO quotes (
            applicant_name,
            insurance_start_date,
            insurance_start_end,
            insured_item_price,
            approval
          ) VALUES (?, ?, ?, ?, 'pending'::approval) RETURNING id|]
    ( applicantName
    , insuranceStartDate
    , insuranceEndDate
    , insuredItemPrice
    )
  return id
