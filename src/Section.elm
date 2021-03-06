module Section exposing
    ( Section
    , make
    , spacerVert
    , static
    , viewSections
    )

import FeatherIcons
import Html exposing (..)
import Html.Attributes exposing (class)
import Utils


type Section msg
    = Section (Html msg)


make :
    { title : String
    , example : String
    , children : List (Html subMsg)
    }
    -> (subMsg -> msg)
    -> Section msg
make { children, title, example } wrapMsg =
    Section <|
        Html.map wrapMsg <|
            div []
                [ sectionTitle title
                , codeExample example
                , container (spacerVert children)
                ]


static :
    { title : String
    , example : String
    , children : List (Html Never)
    }
    -> Section msg
static args =
    make args never


sectionTitle : String -> Html msg
sectionTitle label =
    let
        id_ =
            Utils.kebabCase label
    in
    container
        [ a
            [ Html.Attributes.href ("#" ++ id_)
            , Html.Attributes.id id_
            , class "inline-flex justify-center items-center mb-4 hover:underline"
            ]
            [ h2 [ class "font-bold text-gray-900 text-xl" ] [ text label ]
            , span [ class "ml-2" ]
                [ FeatherIcons.link |> FeatherIcons.withSize 16 |> FeatherIcons.toHtml [] ]
            ]
        ]


container : List (Html msg) -> Html msg
container =
    div [ class "px-5" ]


vSpacer : Html msg
vSpacer =
    div [ class "h-10" ] []


hRow : Html msg
hRow =
    div []
        [ vSpacer
        , hr [] []
        , vSpacer
        ]


spacerVert : List (Html msg) -> List (Html msg)
spacerVert =
    List.intersperse vSpacer


viewFooter : Html msg
viewFooter =
    container
        [ vSpacer
        , hRow
        , pre [ class "mt-10 mb-10" ]
            [ text "Source code "
            , a
                [ class "text-blue-800 underline cursor-pointer font-semibold "
                , Html.Attributes.href "https://github.com/ascandone/elm-components-test"
                , Html.Attributes.target "_blank"
                ]
                [ text "on github" ]
            ]
        ]


viewSections : List (Section msg) -> Html msg
viewSections sections =
    div [ class "max-w-screen-xl mx-auto py-5" ]
        (List.append
            (sections
                |> List.map (\(Section h) -> h)
                |> List.intersperse hRow
            )
            [ viewFooter
            ]
        )


codeExample : String -> Html msg
codeExample str =
    div
        [ class """
            mt-2 mb-8 w-full
            py-4 overflow-x-auto
            bg-neutral-900 text-neutral-100
            xl:rounded-md
            """
        ]
        [ container
            [ code [ class "overflow-x-auto whitespace-pre" ] [ text str ]
            ]
        ]
