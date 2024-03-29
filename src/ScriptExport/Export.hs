module ScriptExport.Export (
  exportMain,
) where

import Data.Text (intercalate, unpack)
import ScriptExport.API (runServer)
import ScriptExport.File (runFile)
import ScriptExport.Options (
  Options (FileOption, ListBuilders, ServerOption),
  parseOptions,
 )
import ScriptExport.Types (Builders, toList)

{- | Program entry point. It provides both file and servant api.

 @since 2.2.0
-}
exportMain :: Builders -> IO ()
exportMain builders = do
  opts <- parseOptions
  case opts of
    ServerOption so -> runServer builders so
    FileOption fo -> runFile builders fo
    ListBuilders ->
      putStrLn $ unpack $ intercalate "\n" $ toList builders
