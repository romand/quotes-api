module Quote
  ( Quote(..)
  ) where

import Data.Aeson
import Data.Text.Lazy (Text)
import Data.Time.Clock (UTCTime)
import GHC.Generics

data Approval
  = Pending
  | Approved
  | Rejected
  deriving (Generic, Show)
instance FromJSON Approval
instance ToJSON Approval

data Quote =
  Quote
    { applicantName :: Text
    , insuranceStartDate :: UTCTime
    , insuranceEndDate :: UTCTime
    , insuredItemPrice :: Double
    }
  deriving (Generic, Show)
instance FromJSON Quote
instance ToJSON Quote
