module Main where

import Contract.Prelude (Unit, bind, discard, log, show, ($))

import Effect (Effect)
import Effect.Class (liftEffect)
import Effect.Aff (launchAff_)
import Node.ChildProcess (spawn, defaultSpawnOptions, kill)
import Data.Posix.Signal (Signal(SIGTERM))
import ScriptImport.ScriptInfo (ScriptExport)
import ScriptImport.File (compileScript)
import ScriptImport.Http (queryScript)

-- | Example usage
main :: Effect Unit
main = launchAff_ do
  server <- liftEffect
       $ spawn
           "export-example"
           ["--port", "8080"]
           defaultSpawnOptions

  (oracle :: ScriptExport Int) <-
    queryScript
      "http://localhost:8080"
      { name: "my-onchain-project-param"
      , param: 1
      }

  (oracle2 :: ScriptExport Int) <-
    compileScript
      "export-example"
      { name: "my-onchain-project-param"
      , param: 1
      }

  liftEffect $ log $ show oracle

  liftEffect $ log $ show oracle2

  liftEffect $ kill SIGTERM server
