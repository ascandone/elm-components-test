module Utils exposing (getMakeConfig)


getMakeConfig :
    { unwrap : attribute -> config -> config
    , defaultConfig : config
    }
    -> List attribute
    -> config
getMakeConfig args =
    List.foldl (\attr conf -> args.unwrap attr conf) args.defaultConfig
