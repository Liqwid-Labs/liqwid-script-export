module ScriptImport.ScriptInfo where

import Contract.Prelude

import Aeson as Aeson
import Aeson (class DecodeAeson, decodeAeson)
import Foreign.Object (Object)
import Contract.Address (ByteArray)
import Contract.Scripts (ScriptHash)
import Data.Show.Generic (genericShow)
import Data.Generic.Rep (class Generic)
import Data.Newtype (class Newtype)

-- | The type of making a query to `agora-scripts` server
type ScriptQuery p =
  { name :: String
  , param :: p
  }

-- | Bundled script export
type ScriptExport a =
  { info :: a
  , scripts :: Object CompiledScript
  }

-- | Individual scripts
newtype CompiledScript = CompiledScript
  { cborHex :: ByteArray
  , hash :: ScriptHash
  , rawHex :: ByteArray
  }

derive instance eqCompiledScripts :: Eq CompiledScript
derive instance ordCompiledScripts :: Ord CompiledScript

derive instance Generic CompiledScript _
derive instance Newtype CompiledScript _

instance DecodeAeson CompiledScript where
  decodeAeson blob = CompiledScript <$> decodeAeson blob

instance Show CompiledScript where
  show x = genericShow x
