module Components.Switch exposing
    ( item
    , view
    )

import Html exposing (..)
import Html.Attributes as Attrs
import Html.Events
import List.Extra as List


{-| Should be opaque but i'm lazy
-}
type alias Item a =
    { value : a
    , label : String
    }


item : a -> String -> Item a
item =
    Item


calculateIndex : { r | selected : a } -> List (Item a) -> Maybe Int
calculateIndex { selected } =
    List.findIndex (\item_ -> item_.value == selected)


getLeftAttribute : { r | selected : a } -> List (Item a) -> Html.Attribute msg
getLeftAttribute args items =
    let
        currentIndex =
            calculateIndex args items |> Maybe.withDefault 0

        leftValue =
            100.0 * (toFloat currentIndex / toFloat (List.length items))
    in
    Attrs.style "left" (String.fromFloat leftValue ++ "%")


viewSlidingIndicator : Attribute msg -> Html msg
viewSlidingIndicator leftAttribute =
    span
        [ Attrs.class """
            absolute px-2 h-9 z-0 -translate-y-1/2 top-1/2 w-1/3
            transition-position duration-200 ease-out
            """
        , leftAttribute
        ]
        [ span
            [ Attrs.class """
               block h-full w-full
               rounded-full bg-white shadow __
               """
            ]
            []
        ]


view : { selected : a, onSelected : a -> msg } -> List (Item a) -> Html msg
view args items =
    div [ Attrs.class "relative px-2 h-12 max-w-xl rounded-full bg-zinc-100" ]
        [ Html.map args.onSelected <|
            div [ Attrs.class "flex h-full" ] (items |> List.map (viewItem args))
        , viewSlidingIndicator (getLeftAttribute args items)
        ]


viewItem : { r | selected : a } -> Item a -> Html a
viewItem { selected } { value, label } =
    let
        isSelected =
            selected == value
    in
    button
        [ Attrs.class """
            z-10 flex-1
            flex justify-center items-center
            px-6 py-1
            rounded-full cursor-pointer font-bold
            transition-color duration-200
            """
        , Attrs.class <|
            if isSelected then
                "text-cyan-700"

            else
                "text-gray-500"
        , Html.Events.onClick value
        ]
        [ text label ]
