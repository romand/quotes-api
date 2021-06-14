module App where

import Data.Aeson (Value(String, Number), (.=), object)
import Data.Text.Lazy (toStrict)
import qualified Network.HTTP.Types as HTTP
import Web.Scotty
import Network.Wai (Application)
import Network.Wai.Handler.Warp (run)

import Quote
import DB


app :: IO Application
app = scottyApp $ do
  post "/quotes" $ do
    (quote :: Quote) <- jsonData
    (QuoteID id) <- liftAndCatchIO $ createQuote quote
    status HTTP.created201
    json $ object [("status", "created"), ("id", Number (fromIntegral id))]

  notFound $ json $ object [("error", "not found")]

  defaultHandler $ \e ->
    json $ object [("error", String (toStrict e))]

main :: IO ()
main = app >>= run 3000
