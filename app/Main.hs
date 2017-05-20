{-# LANGUAGE OverloadedStrings #-}
module Main where

import Fund (loadEnv)
import Fund.Server (server)
import Data.Environment (databaseConnectionString, parsePort)
import Web.Scotty
import Database.PostgreSQL.Simple (connectPostgreSQL)
import Data.Text.Encoding (encodeUtf8)

main :: IO ()
main = do
  env <- loadEnv
  conn <- connectPostgreSQL ((encodeUtf8 . databaseConnectionString) env)
  scotty (parsePort env) $ server conn

