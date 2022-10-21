module ScriptImport.Http where

import Aeson (Aeson)
import Data.Argonaut (Json)
import ScriptImport.ScriptInfo (ScriptExport)
import Data.Map (Map)
import Effect.Ref (Ref)

newtype ScriptCache = ScriptCache (Ref (Map Json Aeson))

-- | The type of making a query to `agora-scripts` server.
type ScriptQuery =
  { name :: String
  , paramsPayload :: Aeson
  }

type Fetcher =
  {
  }
