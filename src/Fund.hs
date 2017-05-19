{-# LANGUAGE OverloadedStrings #-}
module Fund where

import Data.Environment (Environment(..))
import System.Environment (getEnv)
import Data.Text (pack)

loadEnv :: IO Environment
loadEnv = do
  port <- getEnv "PORT"
  dbConnectionStr <- getEnv "DATABASE_URL"
  return (Environment (pack port) (pack dbConnectionStr))
