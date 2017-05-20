{-# LANGUAGE OverloadedStrings #-}
module Fund.Server where

import Data.Fund (Fund(..))
import Web.Scotty
import Network.Wai.Middleware.RequestLogger
import Database.PostgreSQL.Simple
import Control.Monad.IO.Class (liftIO)

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

insertQuery :: Query
insertQuery = "insert into funds (amount, name) values (?, ?) returning id"

insertFund :: Connection -> Fund -> IO Fund
insertFund conn fund = do
  [Only fid] <- query conn insertQuery fund
  return fund { fundId = fid }
