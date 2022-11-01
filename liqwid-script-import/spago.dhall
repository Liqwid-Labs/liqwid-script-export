{ name = "liqwid-script-import"
, dependencies =
  [ "cardano-transaction-lib"
  , "prelude"
  , "console"
  , "effect"
  , "aeson"
  , "aff"
  , "either"
  , "foreign-object"
  , "newtype"
  , "node-buffer"
  , "node-fs-aff"
  , "node-path"
  , "node-fs"
  , "node-child-process"
  , "milkis"
  , "exceptions"
  , "transformers"
  , "posix-types"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
