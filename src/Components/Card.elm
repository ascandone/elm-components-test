module Components.Card exposing
    ( Attribute
    , Slot
    , Variant
    , actions
    , body
    , class
    , dataTestId
    , media
    , outline
    , raised
    , size
    )

import Html exposing (..)
import Html.Attributes as Attrs
import Utils


type alias ConfigMap a =
    { body : a
    , media : a
    , actions : a
    }


type alias Config msg =
    { body : List (Html msg)
    , media : Maybe { src : String }
    , actions : List (Html msg)
    , attributesMap : ConfigMap (List (Html.Attribute msg))
    }


defaultConfig : Config msg
defaultConfig =
    { body = []
    , media = Nothing
    , actions = []
    , attributesMap = ConfigMap [] [] []
    }


type ConfigCtx
    = Card
    | Media


type Attribute ctx msg
    = Attribute (ConfigCtx -> Config msg -> Config msg)


type Variant
    = Raised
    | Outline


dataTestId : String -> Attribute x msg
dataTestId _ =
    Attribute (\_ c -> c)


size : Float -> Attribute MediaCtx msg
size _ =
    Attribute <| \_ c -> c


class : String -> Attribute CardCtx msg
class _ =
    Attribute (\_ c -> c)


type Slot msg
    = Slot (Config msg -> Config msg)


type MediaCtx
    = MediaCtx


type CardCtx
    = CardCtx


media : List (Attribute MediaCtx msg) -> { src : String } -> Slot msg
media attrs args =
    Slot <|
        \config ->
            Utils.getMakeConfig
                { unwrap = \(Attribute f) -> f Media
                , defaultConfig = { config | media = Just args }
                }
                attrs


body : List (Html msg) -> Slot msg
body children =
    Slot <| \config -> { config | body = children }


actions : List (Html msg) -> Slot msg
actions children =
    Slot <| \config -> { config | actions = children }


raised : List (Attribute CardCtx msg) -> List (Slot msg) -> Html msg
raised =
    view Raised


outline : List (Attribute CardCtx msg) -> List (Slot msg) -> Html msg
outline =
    view Outline


view : Variant -> List (Attribute CardCtx msg) -> List (Slot msg) -> Html msg
view variant attributes slots =
    let
        cardAttributes =
            List.map (\(Attribute f) -> f Card) attributes

        slotsAttributes =
            slots |> List.map (\(Slot f) -> f)

        config =
            Utils.getMakeConfig
                { defaultConfig = defaultConfig
                , unwrap = identity
                }
                (cardAttributes ++ slotsAttributes)
    in
    div
        [ Attrs.class "rounded bg-white"
        , Attrs.class <|
            case variant of
                Raised ->
                    "border shadow-soft  transition-all duration-200"

                Outline ->
                    "border"
        ]
        [ case config.media of
            Nothing ->
                text ""

            Just { src } ->
                img [ Attrs.class "rounded-t mb-2", Attrs.src src ] []
        , div [ Attrs.class "px-4 py-2" ] config.body
        , div [ Attrs.class "px-4 mt-5 mb-3 flex gap-x-2 justify-end" ] config.actions
        ]
