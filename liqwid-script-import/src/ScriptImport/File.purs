module ScriptImport.File where

import Contract.Prelude

import Control.Monad.Error.Class (try)
import Aeson as Aeson
import Aeson (class DecodeAeson)
import Node.FS.Aff (readTextFile, writeTextFile, mkdir)
import Node.Path (FilePath)
import Node.Encoding (Encoding (UTF8))
import ScriptImport.ScriptInfo (ScriptExport, ScriptQuery)
import Node.ChildProcess (execSync, defaultExecSyncOptions)

-- | Read script export from file
decodeScript ::
  forall a.
  DecodeAeson a =>
  FilePath ->
  Aff (ScriptExport a)
decodeScript path = do
  raw <- readTextFile UTF8 path
  liftEffect <<< fromRightEff <<< Aeson.decodeJsonString $ raw

-- | Compile script exports with given linker and parameter
compileScript ::
  forall a.
  DecodeAeson a =>
  String ->
  ScriptQuery ->
  Aff (ScriptExport a)
compileScript cmd { name, param } = do
  let dir = name <> "-export"
      paramFile = dir <> "/" <> name <> "-params.json"

  -- Make new directory if it doesn't exist
  _ <- try (mkdir dir)

  -- Write parameter file
  writeTextFile UTF8 paramFile
    (Aeson.stringifyAeson <<< Aeson.encodeAeson $ param)

  -- Link scripts
  _ <-
    liftEffect $
      execSync
        (cmd <> " --param " <> paramFile <> " --out " <> dir)
        defaultExecSyncOptions

  decodeScript (dir <> "/" <> name <> ".json")
