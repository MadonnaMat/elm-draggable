module BasicExample exposing (Model, Msg(..), Position, dragConfig, init, main, subscriptions, update, view)

import Draggable
import Html exposing (Html)
import Html.Attributes as A


type alias Position =
    { x : Float
    , y : Float
    }


type alias Model =
    { xy : Position
    , drag : Draggable.State ()
    }


type Msg
    = OnDragBy Draggable.Delta
    | DragMsg (Draggable.Msg ())


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


init : ( Model, Cmd Msg )
init =
    ( { xy = Position 32 32, drag = Draggable.init }
    , Cmd.none
    )


dragConfig : Draggable.Config () Msg
dragConfig =
    Draggable.basicConfig OnDragBy


update : Msg -> Model -> ( Model, Cmd Msg )
update msg ({ xy } as model) =
    case msg of
        OnDragBy ( dx, dy ) ->
            ( { model | xy = Position (xy.x + dx) (xy.y + dy) }
            , Cmd.none
            )

        DragMsg dragMsg ->
            Draggable.update dragConfig dragMsg model


subscriptions : Model -> Sub Msg
subscriptions { drag } =
    Draggable.subscriptions DragMsg drag


view : Model -> Html Msg
view { xy } =
    let
        translate =
            "translate(" ++ toString xy.x ++ "px, " ++ toString xy.y ++ "px)"

        style =
            [ "transform" => translate
            , "padding" => "16px"
            , "background-color" => "lightgray"
            , "width" => "64px"
            , "cursor" => "move"
            ]
    in
    Html.div
        ([ A.style style
         , Draggable.mouseTrigger () DragMsg
         ]
            ++ Draggable.touchTriggers () DragMsg
        )
        [ Html.text "Drag me" ]


(=>) : a -> b -> ( a, b )
(=>) =
    \a b -> ( a, b )
