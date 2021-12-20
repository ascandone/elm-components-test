module Section.Card exposing (get)

import Components.Button as Button
import Components.Card as Card
import Html exposing (..)
import Html.Attributes exposing (class)
import Section exposing (Section)


src : String
src =
    "https://mui.com/static/images/cards/contemplative-reptile.jpg"


get : Section msg
get =
    Section.static
        { title = "Card"
        , example = """Card.raised [ Card.dataTestId "lizard-card" ]
    [ Card.media [] { src = "..." }
    , Card.body
        [ h1 [] [ text "Lizard" ]
        , p [] [ text "Lizards are a ..." ]
        ]
    , Card.actions
        [ Button.ghost
            [ Button.size Button.sm
            , Button.onClick Share
            ]
            "Share"
        , Button.ghost
            [ Button.size Button.sm
            , Button.onClick Fav
            ]
            "Favorite"
        ]
    ]
            """
        , children =
            [ div [ class "max-w-sm" ]
                [ Card.raised [ Card.dataTestId "lizard-card", Card.class "test-class" ]
                    [ Card.media [ Card.dataTestId "lizard-media", Card.size 12 ] { src = src }
                    , Card.body
                        [ h2 [ class "font-semibold text-xl" ] [ text "Lizard" ]
                        , p [ class "text-gray-600" ]
                            [ text "Lizards are a widespread group of squamate reptiles, with over 6,000 species, ranging across all continents except Antarctica" ]
                        ]
                    , Card.actions
                        [ Button.ghost [ Button.size Button.sm ] "Share"
                        , Button.ghost [ Button.size Button.sm ] "Favorite"
                        ]
                    ]
                ]
            ]
        }
