{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
module Main where

import Data.Fund (Fund(..))
import Web.Scotty
import Network.Wai.Middleware.RequestLogger
import Database.PostgreSQL.Simple
import GHC.Generics
import Data.Aeson (FromJSON, ToJSON)
import Control.Monad.IO.Class (liftIO)

server :: Connection -> ScottyM ()
server conn = do
  get "/funds" $ do
    funds <- liftIO (query_ conn "select id, amount, name from funds" :: IO [Fund])
    json funds

  post "/funds" $ do
    fund <- jsonData :: ActionM Fund
    newFund <- liftIO (insertFund conn fund)
    json newFund

insertQuery = "insert into funds (amount, name) values (?, ?) returning id"

insertFund :: Connection -> Fund -> IO Fund
insertFund conn fund = do
  [Only id] <- query conn insertQuery fund
  return fund { fundId = id }

main :: IO ()
main = do
  conn <- connectPostgreSQL ("host='127.0.0.1' user='db' dbname='db' password='db' port='5598'")
  scotty 3000 $ server conn
