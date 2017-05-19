{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Data.Fund where

import GHC.Generics
import Data.Text (Text)
import Data.Aeson (FromJSON, ToJSON)
import Database.PostgreSQL.Simple.ToRow
import Database.PostgreSQL.Simple.FromRow
import Database.PostgreSQL.Simple.ToField

data Fund = Fund
  { fundId :: Maybe Int
  , amount :: Float
  , name :: !Text
  } deriving (Show, Generic)

instance ToJSON Fund
instance FromJSON Fund

instance FromRow Fund where
  fromRow = Fund <$> field <*> field <*> field

instance ToRow Fund where
  toRow f = [toField $ amount f, toField $ name f]
