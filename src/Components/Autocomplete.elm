module Components.Autocomplete exposing
    ( Attribute
    , Model
    , Msg
    , Option
    , freshOption
    , getSelected
    , getValue
    , id
    , init
    , option
    , placeholder
    , simpleOption
    , update
    , view
    )

import Components.ActionButton as ActionButton
import Components.TextField as TextField
import FeatherIcons
import Html exposing (..)
import Html.Attributes as Attrs
import Html.Events
import Utils


{-| Should be opaque but i'm lazy
-}
type alias Option =
    { label : String
    , id : String
    }


type alias Config msg =
    { textFieldAttributes : List (TextField.Attribute msg)
    , freshOption : Maybe (String -> List (Html Never))
    }


defaultConfig : Config msg
defaultConfig =
    { textFieldAttributes = []
    , freshOption = Nothing
    }


type Attribute msg
    = Attribute (Config msg -> Config msg)


textFieldAttribute : TextField.Attribute msg -> Attribute msg
textFieldAttribute attr_ =
    Attribute <| \c -> { c | textFieldAttributes = attr_ :: c.textFieldAttributes }


id : String -> Attribute msg
id =
    textFieldAttribute << TextField.id


placeholder : String -> Attribute msg
placeholder =
    textFieldAttribute << TextField.placeholder


freshOption : (String -> List (Html Never)) -> Attribute msg
freshOption value =
    Attribute <| \c -> { c | freshOption = Just value }


option :
    { label : String
    , id : String
    }
    -> Option
option =
    identity


{-| when id happens to be the label
-}
simpleOption : String -> Option
simpleOption id_ =
    { label = id_
    , id = id_
    }


{-| Should be opaque but i'm lazy
-}
type alias Model =
    { value : String
    , selected : Bool
    , focused : Bool
    }


init : Model
init =
    { value = ""
    , selected = False
    , focused = False
    }


getSelected : Model -> Maybe String
getSelected model =
    if model.selected then
        Just model.value

    else
        Nothing


getValue : Model -> String
getValue =
    .value


type Msg
    = InternalInput String
    | Focused
    | Blurred
    | Selected Option
    | ClearedSelection


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Focused ->
            ( { model | focused = True }
            , Cmd.none
            )

        ClearedSelection ->
            ( { model
                | selected = False
                , value = ""
              }
            , Cmd.none
            )

        Blurred ->
            ( { model | focused = False }, Cmd.none )

        InternalInput str ->
            ( { model | value = str, selected = False }, Cmd.none )

        Selected option_ ->
            ( { model
                | value = option_.label
                , selected = True
              }
            , Cmd.none
            )


getConfig : List (Attribute msg) -> Config msg
getConfig =
    Utils.getMakeConfig
        { unwrap = \(Attribute f) -> f
        , defaultConfig = defaultConfig
        }


view : List (Attribute Msg) -> { model : Model, toMsg : Msg -> msg, options : Maybe (List Option) } -> Html msg
view attrs_ { model, toMsg, options } =
    let
        config =
            getConfig attrs_
    in
    Html.map toMsg <|
        div [ Attrs.class "w-64 relative" ]
            [ div [ Attrs.class "" ]
                [ TextField.view
                    (List.concat
                        [ config.textFieldAttributes
                        , if model.selected then
                            [ TextField.actionIcon
                                [ ActionButton.onClick ClearedSelection
                                , ActionButton.size ActionButton.sm
                                , ActionButton.variant ActionButton.filled
                                ]
                                FeatherIcons.x
                            ]

                          else
                            []
                        , [ TextField.onFocus Focused
                          , TextField.onBlur Blurred
                          , TextField.onInput InternalInput
                          , TextField.value model.value
                          ]
                        ]
                    )
                ]
            , div [ Attrs.class "mt-3" ] []
            , Html.map Selected <|
                div
                    [ Attrs.class """
                    border rounded-md shadow-lg bg-white
                    max-h-64 overflow-y-auto
                    absolute inset-x-0
                    z-20
                    """
                    , Attrs.classList [ ( "hidden", not model.focused || (String.isEmpty model.value && options == Nothing) ) ]
                    ]
                    (case options of
                        Nothing ->
                            List.repeat 6 viewPlaceholder

                        Just options_ ->
                            List.append
                                (options_
                                    |> List.filter (\option_ -> option_.label |> String.contains model.value)
                                    |> viewOptions { hasFreshOption = config.freshOption /= Nothing } model
                                )
                                (case config.freshOption of
                                    Nothing ->
                                        []

                                    Just getHtml ->
                                        let
                                            isOptionPresent () =
                                                options
                                                    |> Maybe.withDefault []
                                                    |> List.any (\option_ -> option_.id == model.value)
                                        in
                                        if String.isEmpty model.value || isOptionPresent () then
                                            []

                                        else
                                            --TODO should be a button
                                            [ div
                                                [ optionCommonCls
                                                , Attrs.class "text-gray-600 font-light block w-full"
                                                , Html.Events.onMouseDown (simpleOption model.value)
                                                ]
                                                (List.map (Html.map never) (getHtml model.value))
                                            ]
                                )
                                |> List.intersperse (div [ Attrs.class "h-2" ] [])
                    )
            ]


viewPlaceholder : Html msg
viewPlaceholder =
    div [ Attrs.class """px-3 py-2 animate-pulse""" ]
        [ div [ Attrs.class "w-full h-4 bg-gray-200 rounded" ] []
        ]


viewOptions : { hasFreshOption : Bool } -> Model -> List Option -> List (Html Option)
viewOptions { hasFreshOption } model options =
    case ( options, hasFreshOption ) of
        ( [], False ) ->
            [ div [ Attrs.class "px-3 py-3 text-gray-600" ]
                [ text "Cannot find data" ]
            ]

        ( _ :: _, _ ) ->
            options
                |> List.map (\o -> viewOption { isSelected = getSelected model == Just o.id } o)

        _ ->
            []


optionCommonCls : Html.Attribute msg
optionCommonCls =
    Attrs.class "px-3 py-2 cursor-pointer hover:bg-gray-100"


viewOption : { isSelected : Bool } -> Option -> Html Option
viewOption { isSelected } option_ =
    div
        [ optionCommonCls
        , Attrs.class "text-gray-800 font-medium"
        , Attrs.class <|
            if isSelected then
                "bg-gray-100"

            else
                ""
        , Html.Events.onMouseDown option_
        ]
        [ text option_.label ]
