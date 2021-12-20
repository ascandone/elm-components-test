module Utils exposing (concatArgs, getMakeConfig, kebabCase)


getMakeConfig :
    { unwrap : attribute -> config -> config
    , defaultConfig : config
    }
    -> List attribute
    -> config
getMakeConfig args =
    List.foldl (\attr conf -> args.unwrap attr conf) args.defaultConfig


kebabCase : String -> String
kebabCase =
    String.replace " " "-" >> String.toLower


concatArgs : (List a -> b) -> List (List a) -> b
concatArgs f args =
    f (List.concat args)
