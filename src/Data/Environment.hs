{-# LANGUAGE OverloadedStrings #-}

module Data.Environment where

import Data.Text (Text)

data Environment = Environment
  { port :: Text
  , databaseConnectionString :: Text
  } deriving (Show)
