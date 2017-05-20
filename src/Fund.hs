{-# LANGUAGE OverloadedStrings #-}
module Fund where

import Data.Environment (Environment(..))
import System.Environment (getEnv)
import Data.Text (pack)

loadEnv :: IO Environment
loadEnv = do
  envPort <- getEnv "PORT"
  dbConnectionStr <- getEnv "DATABASE_URL"
  return (Environment (pack envPort) (pack dbConnectionStr))
