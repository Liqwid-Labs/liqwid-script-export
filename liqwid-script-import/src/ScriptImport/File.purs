module ScriptImport.File where

import Contract.Prelude

import Aeson as Aeson
import Aeson (class DecodeAeson, decodeAeson, JsonDecodeError)
import Foreign.Object (Object)
import Contract.Address (ByteArray)
import Contract.Scripts (ScriptHash)
import Data.Show.Generic (genericShow)
import Data.Generic.Rep (class Generic)
import Data.Newtype (class Newtype)
import Node.FS.Sync (readTextFile)
import Node.Path (FilePath)
import Node.Encoding (Encoding (UTF8))
import Effect (Effect)
import Data.Either (Either)

import ScriptImport.ScriptInfo (ScriptExport)

decodeFromFile ::
  forall a.
  DecodeAeson a =>
  FilePath ->
  Effect (ScriptExport a)
decodeFromFile path = do
  raw <- readTextFile UTF8 path
  fromRightEff $ Aeson.decodeJsonString raw
