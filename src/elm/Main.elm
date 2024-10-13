module Main exposing (main)

import Browser
import Html exposing (Html)
import Html.Attributes as Hats
import Msg exposing (Msg(..))
import Asset exposing (Asset, Assets)
import Model.Video as Video exposing (Video)
import Model.Effect as Effect exposing (Effect)
import Model.Audio as Audio exposing (Audio)
import Model.Config as Config exposing (Config)
import Model.Logic as Logic exposing (Logic)
import Browser.Events
import Time 
import List.Extra

type alias Model =
  { input : 
    { acceptingInput : Bool }
  , assets : Assets
  , config : Config
  , video : Video
  , logic : Logic
  , effects : List Effect
  , lastTick : Float
  , currentTick : Float
  }

main : Program {width: Int, height: Int} Model Msg
main =
  Browser.element
    { init = init 
    , update = update
    , view = view 
    , subscriptions = subscriptions
    }

init : {width: Int, height: Int} -> (Model, Cmd Msg)
init {width, height} =
  ( { input = { acceptingInput = True }
    , assets = Asset.from (List.map Audio.audioCode Audio.allAudio)
    , config = Config.new
    , video = Video.new width height
    , effects = []
    , logic = Logic.new
    , lastTick = 0
    , currentTick = 0
    }
  , Cmd.batch
    [ Msg.loadAudio ()
    ]
  )

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of 
    Tick currentTick ->
      let
          lastTick = model.currentTick
          δ = currentTick - lastTick
          video = model.video
          newLogic = Logic.update δ model.logic
          (newVideo, inputEnabled, sfxStart) = Video.update δ video
          newInput = 
            if inputEnabled then
              { acceptingInput = True }
            else
              { acceptingInput = False }
          (newAssets, sfxCmd) =
            if (sfxStart && (not <| Audio.audioPlayingか Audio.Splat model.assets )) then
              ( Audio.playAudio Audio.Splat model.assets
              , Cmd.batch
                [ Msg.playSplat
                ]
              )
            else
              (model.assets, Cmd.none)

      in
      ( { model 
        | video = newVideo
        , assets = newAssets
        , input = newInput
        , logic = newLogic
        , lastTick = lastTick
        , currentTick = currentTick
        }
      , sfxCmd
      )
    KeyPress ->
      if List.all Effect.inputPermittedGiven model.effects then
        let
            newEffect = List.Extra.find Effect.punchか model.effects
            newLogic = Logic.punch model.logic
            newVideo = Video.punch model.video
        in
        ( { model | video = newVideo }
        , Cmd.none
        )
      else
        ( model
        , Cmd.none
        )
    AudioLoaded audio ->
      let cmds = if audio == Audio.BGM then
                   Cmd.batch [ Msg.playBGM, Msg.sendPixelBuffer [1,2] ]
                 else
                   Cmd.none
      in
      ( { model | assets = Audio.loadAudio audio model.assets }
      , cmds
      )
    AudioFinished audio ->
      ( { model | assets = Audio.loadAudio audio model.assets }
      , Cmd.none
      )
    AudioError _ ->
      -- quietly fail for now
      ( model
      , Cmd.none
      )
    VideoResized width height ->
      ( { model | video = Video.resize width height model.video }
      , Cmd.none
      )
    SetBGMVolume volume ->
      ( { model | config = Config.setBGMVolume volume model.config }
      , Msg.setBGMVolume (Audio.volume volume)
      )
    SetSFXVolume volume ->
      ( { model | config = Config.setSFXVolume volume model.config }
      , Msg.setSFXVolume (Audio.volume volume)
      )

view : Model -> Html Msg
view model =
  let
      playerClasses =
        case model.video.player of
          Video.Running -> "running"
          Video.PunchWindup _ -> "punch-windup"
          Video.PunchThrow _ -> "punch-throw"
          Video.PunchHold _ -> "punch-hold"
          Video.PunchWithdraw _ -> "punch-withdraw"
      targets =
        List.map
          (\target ->
            Html.div
              [ Hats.class (Logic.targetName target)
              , Hats.style "left" ((String.fromInt (Logic.targetX target)) ++ "px")
              ]
              []
          )
          model.logic.targets
  in
   Html.div 
      [ Hats.id "mainchar"
      , Hats.class playerClasses
      ]
      []
   :: targets 
   |> Html.main_ []


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
    [ Msg.assetErrorSub
    , Msg.assetLoadedSub
    , Msg.audioCompleteSub
    , Msg.kbSub
    , Browser.Events.onResize Msg.VideoResized
    , Browser.Events.onAnimationFrame (Time.posixToMillis >> toFloat >> Tick)
    ]

