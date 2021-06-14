{-# LANGUAGE QuasiQuotes #-}
import Test.Hspec
import Test.Hspec.Wai
import Test.Hspec.Wai.JSON
import GHC.Generics
import Data.Text.Lazy (Text)
import Data.Aeson
import Data.Aeson.QQ
import Data.ByteString.Lazy.UTF8 (toString)


import App (app)

quoteJson :: Value
quoteJson =
  [aesonQQ|{
    "applicantName": "name",
    "insuranceStartDate": "2013-10-17T09:42:49.007Z",
    "insuranceEndDate": "2013-10-17T09:42:49.007Z",
    "insuredItemPrice": 12.345
  }|]

data CreateResp =
  CreateResp { status :: Text
             , quoteId :: Int
             } deriving (Generic, Show)
quoteNoPrefix "quoteId" = "id"
quoteNoPrefix s = s
instance FromJSON CreateResp where
  parseJSON = genericParseJSON $ defaultOptions
    { fieldLabelModifier = quoteNoPrefix }

spec :: Spec
spec = with app $ do

  describe "GET /asdf123" $ do
    it "responds with 404" $ do
      get "/asdf123" `shouldRespondWith` 404

  describe "POST /quotes" $ do
    let q = encode quoteJson

    it "responds with 201" $ do
      post "/quotes" q `shouldRespondWith` 201

    it "responds with json" $ do
      post "/quotes" q `shouldRespondWith` 201 {
        matchHeaders=["Content-Type" <:> "application/json; charset=utf-8"]
      }

    let matcher _ body =
          case decode body of
            Just(CreateResp{status = "created" , quoteId = _}) -> Nothing
            Nothing -> Just $ "unexpected response: " ++ toString body

    it "responds with quote id" $ do
      post "/quotes" q `shouldRespondWith` 201 {matchBody=MatchBody matcher}


main :: IO ()
main = hspec spec
