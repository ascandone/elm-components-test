module Validation exposing (Validation, attributes, init, run)

import Components.TextField as TextField


type alias Validation a =
    { value : String
    , initial : Bool
    , focused : Bool
    , validation : Maybe (Result String a)
    }


init : Validation a
init =
    { value = ""
    , initial = True
    , focused = False
    , validation = Nothing
    }


run : Validation a -> Maybe a
run validation =
    case validation.validation of
        Just (Ok x) ->
            Just x

        _ ->
            Nothing


type Msg
    = Blur
    | Focus
    | Input String


update : Msg -> Validation a -> Validation a
update msg validation =
    case msg of
        Blur ->
            { validation | focused = False }

        Focus ->
            { validation | focused = True }

        Input value ->
            { validation | value = value, initial = False }


attributes : Validation a -> List (TextField.Attribute (Validation a))
attributes validation =
    let
        onInput str =
            { validation | value = str, initial = False }
    in
    List.concat
        [ [ TextField.value validation.value
          , TextField.onInput onInput
          , TextField.onBlur { validation | focused = False }
          , TextField.onFocus { validation | focused = True }
          ]
        , if validation.initial then
            []

          else
            []
        ]
