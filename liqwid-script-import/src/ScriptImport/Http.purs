module ScriptImport.Http where

import Contract.Prelude

import Effect.Exception (throw)
import Effect.Aff (Aff)
import Milkis as M
import Milkis.Impl.Node (nodeFetch)
import Aeson (class DecodeAeson, class EncodeAeson)
import Aeson as Aeson
import ScriptImport.ScriptInfo (ScriptExport, ScriptQuery)

-- | Query script export from server.
queryScript
  :: forall a param.
     DecodeAeson a =>
     EncodeAeson param =>
     String ->
     ScriptQuery param ->
     Aff (ScriptExport a)
queryScript
  serverURL
  { name, param } = do
    let
      fetch = M.fetch nodeFetch
      opts =
        { method: M.postMethod
        , body: Aeson.stringifyAeson <<< Aeson.encodeAeson $ param
        , headers: M.makeHeaders { "Content-Type": "application/json" }
        }
    result <- fetch (M.URL $ serverURL <> "/query-script/" <> name) opts
    raw <- M.text result

    case (M.statusCode result) of
      200 -> either (liftEffect <<< throw <<< show) pure $ Aeson.decodeJsonString raw
      _ -> liftEffect $ throw raw
