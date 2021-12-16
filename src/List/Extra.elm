module List.Extra exposing (findIndex)

{-| -}


{-| Quick 'n dirty implementation
-}
findIndex : (a -> Bool) -> List a -> Maybe Int
findIndex pred lst =
    lst
        |> List.indexedMap Tuple.pair
        |> List.filter (\( _, x ) -> pred x)
        |> List.head
        |> Maybe.map Tuple.first
