module Main exposing (main)

import Browser
import Html exposing (Html, div, text)
import Html.Attributes exposing (style)
import Html.Events exposing (on)
import Json.Decode exposing (map2, field, int, succeed)

type alias Model = { x : Int, y : Int, x0 : Int, y0 : Int }
type Msg = Up | Down Int Int | Move Int Int


main : Program () Model Msg
main = Browser.sandbox { init = init, update = update, view = view }


init : Model
init = { x = 100, y = 100, x0 = -1 , y0 = -1 }


update : Msg -> Model -> Model
update msg model =
  case msg of
      Up ->
          { model | x0 = -1, y0 = -1 }
      Down x0 y0 ->
          { model | x0 = x0, y0 = y0 }
      Move x y ->
          if model.x0 >= 0
          then { model | x = model.x + x - model.x0, y = model.y + y - model.y0}
          else model


view : Model ->  Html Msg
view model =
  let
    x  = String.fromInt model.x
    y  = String.fromInt model.y
    x0 = String.fromInt model.x0
    y0 = String.fromInt model.y0
  in
    div [ style "position" "absolute"
        , style "left" <| x ++ "px"
        , style "top"  <| y ++ "px"
        , style "height" "150px"
        , style "width"  "150px"
        , style "background-color" <| if model.x0 > 0 then "lightblue" else "skyblue"
        , style "cursor" <| if model.x0 > 0 then "move" else "default"
        , on "mouseup" <| succeed Up
        , on "mousedown" <| map2 Down (field "offsetX" int) (field "offsetY" int)
        , on "mousemove" <| map2 Move (field "offsetX" int) (field "offsetY" int)
        ]
        [ text <| "(x=" ++ x ++ ",y=" ++ y ++ ")"
        , text <| "(x0=" ++ x0 ++ ",y0=" ++ y0 ++ ")"
        ]
