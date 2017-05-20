{-# LANGUAGE OverloadedStrings #-}

module Data.Environment where

import Data.Text (Text)
import Data.Text.Read (decimal)

data Environment = Environment
  { port :: Text
  , databaseConnectionString :: Text
  } deriving (Show)

type Port = Int

parsePort :: Environment -> Port
parsePort = (either defaultPort fst) . decimal . port

defaultPort :: a -> Port
defaultPort = const 3000
