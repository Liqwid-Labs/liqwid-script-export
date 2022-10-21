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
  , "argonaut"
  , "node-fs"
  , "ordered-collections"
  , "refs"
  , "typelevel-prelude"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
