module Components.Checkbox exposing
    ( Attribute
    , checked
    , checkedMaybe
    , id
    , onCheck
    , view
    )

import FeatherIcons
import Html exposing (..)
import Html.Attributes as Attrs
import Html.Events
import Json.Encode
import Maybe.Extra
import Utils


type alias Config msg =
    { checked : Maybe Bool
    , onCheck : Maybe (Bool -> msg)
    , attributes : List (Html.Attribute msg)
    }


defaultConfig : Config msg
defaultConfig =
    { checked = Nothing
    , onCheck = Nothing
    , attributes = []
    }


checkedMaybe : Maybe Bool -> Attribute msg
checkedMaybe mb =
    Attribute <| \c -> { c | checked = mb }


checked : Bool -> Attribute msg
checked b =
    checkedMaybe (Just b)


attribute : Html.Attribute msg -> Attribute msg
attribute attr =
    Attribute <| \c -> { c | attributes = attr :: c.attributes }


id : String -> Attribute msg
id =
    attribute << Attrs.id


onCheck : (Bool -> msg) -> Attribute msg
onCheck onCheck_ =
    Attribute <| \c -> { c | onCheck = Just onCheck_ }


type Attribute msg
    = Attribute (Config msg -> Config msg)


makeConfig : List (Attribute msg) -> Config msg
makeConfig =
    Utils.getMakeConfig
        { unwrap = \(Attribute f) -> f
        , defaultConfig = defaultConfig
        }


viewIcon : FeatherIcons.Icon -> Html msg
viewIcon icon =
    icon
        |> FeatherIcons.withSize 14
        |> FeatherIcons.withStrokeWidth 3
        |> FeatherIcons.toHtml []


viewIndeterminate : Html msg
viewIndeterminate =
    div []
        [ FeatherIcons.minus
            |> FeatherIcons.withClass "text-teal-700"
            |> viewIcon
        ]


viewChecked : Html msg
viewChecked =
    div []
        [ FeatherIcons.check
            |> FeatherIcons.withClass "text-teal-100"
            |> viewIcon
        ]


viewInput : Config msg -> Html msg
viewInput config =
    Utils.concatArgs input
        [ Maybe.Extra.mapToList Attrs.checked config.checked
        , Maybe.Extra.mapToList Html.Events.onCheck config.onCheck
        , [ Attrs.class "hidden"
          , Attrs.type_ "checkbox"
          , Attrs.property "indeterminate" <| Json.Encode.bool (config.checked == Nothing)
          ]
        , config.attributes
        ]
        []


viewButton : Config msg -> Html msg
viewButton config =
    let
        nextValue =
            case config.checked of
                Just b ->
                    not b

                Nothing ->
                    True
    in
    div [ Attrs.class "active:scale-90 transition-all duration-100" ]
        [ Utils.concatArgs button
            [ Maybe.Extra.mapToList (\onCheck_ -> Html.Events.onClick (onCheck_ nextValue)) config.onCheck
            , [ Attrs.class """
                     rounded-md h-5 w-5 block shadow-sm box-border
                     cursor-pointer hover:border-teal-400 hover:ring group-hover:ring ring-teal-200
                     flex items-center justify-center
                     transition-color duration-200 ease-out
                     """
              , Attrs.class <|
                    case config.checked of
                        Just True ->
                            "bg-teal-600"

                        Just False ->
                            "border border-gray-300"

                        Nothing ->
                            "border-[1.5px] border-teal-400 bg-teal-50"
              ]
            ]
            [ case config.checked of
                Nothing ->
                    viewIndeterminate

                Just True ->
                    viewChecked

                Just False ->
                    text ""
            ]
        ]


view : List (Attribute msg) -> Html msg
view attrs =
    let
        config =
            makeConfig attrs
    in
    div []
        [ viewInput config
        , viewButton config
        ]
