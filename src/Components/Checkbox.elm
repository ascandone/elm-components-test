module Components.Checkbox exposing
    ( Attribute
    , checked
    , checkedMaybe
    , onCheck
    , view
    )

import FeatherIcons
import Html exposing (..)
import Html.Attributes as Attrs
import Utils


type alias Config msg =
    { checked : Maybe Bool
    , onCheck : Maybe (Bool -> msg)
    }


defaultConfig : Config msg
defaultConfig =
    { checked = Nothing
    , onCheck = Nothing
    }


checkedMaybe : Maybe Bool -> Attribute msg
checkedMaybe mb =
    Attribute <| \c -> { c | checked = mb }


checked : Bool -> Attribute msg
checked b =
    checkedMaybe (Just b)


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


view : List (Attribute msg) -> Html msg
view attrs =
    let
        config =
            makeConfig attrs
    in
    div []
        [ input [ Attrs.class "hidden" ] []
        , div
            [ Attrs.class """
                rounded-md h-5 w-5 block
                shadow-sm box-border
                cursor-pointer hover:border-teal-400 hover:ring ring-teal-100
                flex items-center justify-center
                """
            , Attrs.class <|
                case config.checked of
                    Just True ->
                        "bg-teal-600"

                    Just False ->
                        "border"

                    Nothing ->
                        "border-[1.5px] border-teal-400 bg-teal-50"
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
