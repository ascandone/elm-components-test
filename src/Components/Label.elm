module Components.Label exposing (class)

import Html exposing (Attribute)
import Html.Attributes


class : Attribute msg
class =
    Html.Attributes.class "flex items-center gap-x-3 text-gray-800 select-none group cursor-pointer"
