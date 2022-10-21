module Main where

import Contract.Prelude

import Aeson as Aeson
import Effect (Effect)
import Effect.Class (liftEffect)
import Effect.Console (log)
import Effect.Aff
import Node.FS.Aff (readTextFile)
import Node.Encoding (Encoding(..))
import ScriptImport.ScriptInfo
import ScriptImport.File
import Type.Proxy

import Type.Data.Symbol

import Prim.RowList (Cons, Nil, RowList, class RowToList)

type OracleScriptInfo =
  { hello :: String
  }

type QueryType =
  ( oracle :: ScriptExport OracleScriptInfo
  , oracleDebug :: ScriptExport OracleScriptInfo
  )

-- We should never use query without parameter, since it is impossible to link
-- in purescript.

type Test = "hello world!"

class ToStr :: forall k. RowList k -> Constraint
class ToStr list where
  toStr :: Proxy list -> String

instance ToStr Nil where
  toStr _ = ""

instance (IsSymbol sym, ToStr next) => ToStr (Cons sym head next) where
  toStr _ = reflectSymbol (SProxy :: SProxy sym) <> toStr (Proxy :: Proxy next)

test ::
  forall rt rl.
  RowToList rt rl =>
  ToStr rl =>
  Proxy rt ->
  Effect Unit
test _ =
  log $ toStr (Proxy :: Proxy rl)

main :: Effect Unit
main = launchAff_ do
  (oracle :: ScriptExport OracleScriptInfo) <-
    liftEffect $ decodeFromFile "./oracle.json"

  liftEffect $ log $ show oracle

  liftEffect $ log "🍝"

  liftEffect $ log $ reflectSymbol (SProxy :: SProxy Test)

  liftEffect $ test (Proxy :: Proxy QueryType)
