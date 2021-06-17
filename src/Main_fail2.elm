-- 現在のclientX/Y - 現在のoffsetX/Yで現在の左上の座標を求める方法
-- 一見Main_alt1と似ているが最初の時点の記憶はない
-- 全くの失敗作
module Main_fail2 exposing (main)

import Browser
import Html exposing (Html, div, text)
import Html.Attributes exposing (style)
import Html.Events exposing (on)
import Json.Decode exposing (map2, field, int, succeed)

type alias Model = { x : Int, y : Int, dragging : Bool }
type Msg = Up | Down | Move Int Int


main : Program () Model Msg
main = Browser.sandbox { init = init, update = update, view = view }


init : Model
init = { x = 100, y = 100, dragging = False }


update : Msg -> Model -> Model
update msg model =
  case msg of
      Up ->
          { model | dragging = False }
      Down ->
          { model | dragging = True }
      Move x1 y1 ->
          if model.dragging
          then { model | x = x1, y = y1}
          else model


view : Model ->  Html Msg
view model =
  let
    x  = String.fromInt model.x
    y  = String.fromInt model.y
  in
    div [ style "position" "absolute"
        , style "left" <| x ++ "px"
        , style "top"  <| y ++ "px"
        , style "height" "150px"
        , style "width"  "150px"
        , style "background-color" <| if model.dragging then "lightblue" else "skyblue"
        , style "cursor" <| if model.dragging then "move" else "default"
        , on "mouseup" <| succeed Up
        , on "mousedown" <| succeed Down 
        , on "mousemove" <| map2 Move (map2 (-) (field "clientX" int) (field "offsetX" int))
                                      (map2 (-) (field "clientX" int) (field "offsetX" int))
        ]
        [ text <| "(x=" ++ x ++ ",y=" ++ y ++ ")"
        ]
