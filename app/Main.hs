{-# LANGUAGE OverloadedStrings #-}
module Main where

import Fund (loadEnv)
import Data.Fund (Fund (..))
import Data.Environment (databaseConnectionString, parsePort)
import Web.Scotty
import Network.Wai.Middleware.RequestLogger
import Database.PostgreSQL.Simple
import Control.Monad.IO.Class (liftIO)
import Data.Text.Encoding (encodeUtf8)

main :: IO ()
main = do
  env <- loadEnv
  conn <- connectPostgreSQL ((encodeUtf8 . databaseConnectionString) env)
  scotty (parsePort env) $ server conn

server :: Connection -> ScottyM ()
server conn = do
  middleware logStdoutDev
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

