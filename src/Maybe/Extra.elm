module Maybe.Extra exposing (toList)


toList : Maybe a -> List a
toList m =
    case m of
        Nothing ->
            []

        Just x ->
            [ x ]
