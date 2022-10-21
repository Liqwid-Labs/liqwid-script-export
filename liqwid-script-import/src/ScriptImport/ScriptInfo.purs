module ScriptImport.ScriptInfo where

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

type ScriptExport a =
  { info :: a
  , scripts :: Object CompiledScript
  }

newtype CompiledScript = CompiledScript
  { cborHex :: ByteArray
  , hash :: ScriptHash
  , rawHex :: ByteArray
  }

derive instance eqOracleScripts :: Eq CompiledScript
derive instance ordOracleScripts :: Ord CompiledScript

derive instance Generic CompiledScript _
derive instance Newtype CompiledScript _

instance DecodeAeson CompiledScript where
  decodeAeson blob = CompiledScript <$> decodeAeson blob

instance Show CompiledScript where
  show x = genericShow x
