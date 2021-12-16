module Tests.Button exposing (suite)

import Components.Button as Button
import Fuzz
import Test exposing (Test)
import Test.Html.Event as Event
import Test.Html.Query as Query
import Test.Html.Selector as Selector


suite : Test
suite =
    Test.describe "Button"
        [ Test.fuzz Fuzz.int "should handle onClick events" <|
            \n ->
                Button.primary [ Button.onClick n ] "Click me"
                    |> Query.fromHtml
                    |> Event.simulate Event.click
                    |> Event.expect n
        , Test.fuzz Fuzz.string "should render the given label" <|
            \label ->
                Button.primary [] label
                    |> Query.fromHtml
                    |> Query.has [ Selector.text label ]
        ]
