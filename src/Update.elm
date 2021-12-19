module Update exposing (Nested, andThen, mapCmd, nested)


type alias Nested model subModel msg subMsg =
    (subModel -> ( subModel, Cmd subMsg )) -> model -> ( model, Cmd msg )


nested :
    { setter : model -> subModel -> model
    , getter : model -> subModel
    , wrapMsg : subMsg -> msg
    }
    -> (subModel -> ( subModel, Cmd subMsg ))
    -> model
    -> ( model, Cmd msg )
nested args f model =
    let
        ( newSubModel, subCmd ) =
            f (args.getter model)
    in
    ( args.setter model newSubModel
    , Cmd.map args.wrapMsg subCmd
    )


andThen :
    (model -> ( otherModel, Cmd msg ))
    -> ( model, Cmd msg )
    -> ( otherModel, Cmd msg )
andThen f ( model, cmd ) =
    let
        ( newModel, newCmd ) =
            f model
    in
    ( newModel, Cmd.batch [ cmd, newCmd ] )


mapCmd : (msg -> otherMsg) -> ( model, Cmd msg ) -> ( model, Cmd otherMsg )
mapCmd f ( model, cmd ) =
    ( model, Cmd.map f cmd )
