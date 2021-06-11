module App
  ( main
  ) where

import Data.Aeson (Value(String, Number), (.=), object)
import Data.Text.Lazy (toStrict)
import qualified Network.HTTP.Types as HTTP
import Web.Scotty

import Quote
import DB

main :: IO ()
main = scotty 3000 $ do
    post "/quotes" $ do
      (quote :: Quote) <- jsonData
      (QuoteID id) <- liftAndCatchIO $ createQuote quote
      status HTTP.created201
      json $ object [("status", "created"), ("id", Number (fromIntegral id))]

    notFound $ json $ object [("error", "not found")]

    defaultHandler $ \e ->
      json $ object [("error", String (toStrict e))]
