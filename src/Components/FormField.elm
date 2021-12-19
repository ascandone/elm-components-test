module Components.FormField exposing
    ( Attribute
    , Slot
    , autoComplete
    , id
    , label
    , textField
    , toggle
    , view
    )

import Components.Autocomplete as Autocomplete
import Components.TextField as TextField
import Components.Toggle as Toggle
import Html exposing (..)
import Html.Attributes as Attrs
import Utils


type Attribute msg
    = Attribute (Config msg -> Config msg)


type alias Config msg =
    { dummy : Maybe msg
    , id : Maybe String
    }


defaultConfig : Config msg
defaultConfig =
    { dummy = Nothing
    , id = Nothing
    }


type Slot msg
    = Slot (Slots msg -> Slots msg)


type alias Slots msg =
    { label : Html msg
    , form : { id : Maybe String } -> Html msg
    }


id : String -> Attribute msg
id str =
    Attribute <| \c -> { c | id = Just str }


defaultSlots : Slots msg
defaultSlots =
    { label = text ""
    , form = \_ -> text ""
    }


label : String -> Slot msg
label text_ =
    Slot <| \slots -> { slots | label = text text_ }


textField : List (TextField.Attribute msg) -> Slot msg
textField attrs =
    let
        viewForm args =
            TextField.view <|
                List.append
                    attrs
                    (case args.id of
                        Nothing ->
                            []

                        Just id_ ->
                            [ TextField.id id_ ]
                    )
    in
    Slot <| \slots -> { slots | form = viewForm }


autoComplete :
    List (Autocomplete.Attribute Autocomplete.Msg)
    ->
        { model : Autocomplete.Model
        , toMsg : Autocomplete.Msg -> msg
        , options : Maybe (List Autocomplete.Option)
        }
    -> Slot msg
autoComplete attrs autoCompleteArgs =
    let
        viewForm args =
            Autocomplete.view
                (List.append
                    attrs
                    (case args.id of
                        Nothing ->
                            []

                        Just id_ ->
                            [ Autocomplete.id id_ ]
                    )
                )
                autoCompleteArgs
    in
    Slot <| \slots -> { slots | form = viewForm }


toggle : { checked : Bool, onCheck : Bool -> msg } -> List (Toggle.Attribute msg) -> Slot msg
toggle args attrs =
    let
        viewForm formArgs =
            div []
                [ Toggle.view args <|
                    List.append
                        attrs
                        (case formArgs.id of
                            Nothing ->
                                []

                            Just id_ ->
                                [ Toggle.id id_ ]
                        )
                ]
    in
    Slot <| \slots -> { slots | form = viewForm }


makeAttrsConfig : List (Attribute msg) -> Config msg
makeAttrsConfig =
    Utils.getMakeConfig
        { defaultConfig = defaultConfig
        , unwrap = \(Attribute f) -> f
        }


makeSlots : List (Slot msg) -> Slots msg
makeSlots =
    Utils.getMakeConfig
        { defaultConfig = defaultSlots
        , unwrap = \(Slot f) -> f
        }


view : List (Attribute msg) -> List (Slot msg) -> Html msg
view attrs slots =
    let
        config =
            makeAttrsConfig attrs

        slots_ =
            makeSlots slots
    in
    div
        [ Attrs.class """
            md:flex items-center
            px-2 py-4 rounded-md md:hover:bg-stone-50
            transition-color duration-300
            """
        ]
        [ Html.label
            (List.concat
                [ case config.id of
                    Nothing ->
                        []

                    Just str ->
                        [ Attrs.for str ]
                , [ Attrs.class """
                text-sm font-regular text-gray-700
                md:flex justify-end [flex-basis:calc(50%-11rem)]
            """
                  ]
                ]
            )
            [ slots_.label ]
        , div [ Attrs.class "h-1 md:h-0 md:w-8" ] []
        , div [ Attrs.class "w-72" ] [ slots_.form { id = config.id } ]
        ]
