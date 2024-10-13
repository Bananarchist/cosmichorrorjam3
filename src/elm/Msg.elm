port module Msg exposing (Msg(..), assetErrorSub, kbSub, loadAudio, playBGM, setBGMVolume, setSFXVolume, stopAudio, pauseAudio, sendPixelBuffer, playSplat, assetLoadedSub, audioCompleteSub)

import Browser.Events
import Json.Decode as D
import Model.Audio as Audio exposing (Audio)
import Result.Extra 

-- Audio Ports
port loadAudio : () -> Cmd msg
port playAudio : String -> Cmd msg
port setBGMVolume : Float -> Cmd msg
port setSFXVolume : Float -> Cmd msg
port pauseAudio : () -> Cmd msg
port stopAudio : () -> Cmd msg
port assetError : (String -> msg) -> Sub msg
port assetLoaded : (String -> msg) -> Sub msg
port audioComplete : (String -> msg) -> Sub msg

-- Video ports
port sendPixelBuffer : (List Int) -> Cmd msg

type Msg
  = AudioLoaded Audio
  | AudioError String
  | AudioFinished Audio
  | SetBGMVolume Audio.Volume
  | SetSFXVolume Audio.Volume
  | VideoResized Int Int
  | KeyPress
  | Tick Float


-- Messages
playBGM : Cmd msg
playBGM =
  playAudio (Audio.audioCode Audio.BGM)

playSplat : Cmd msg
playSplat =
  playAudio (Audio.audioCode Audio.Splat)

-- Subs

assetErrorSub : Sub Msg
assetErrorSub =
  assetError AudioError

assetLoadedSub : Sub Msg
assetLoadedSub =
  assetLoaded
    (\str -> 
      Audio.codeToAudio str
      |> Debug.log "AudioLoaded"
      |> Maybe.map AudioLoaded
      |> Maybe.withDefault (AudioError ("Unknown asset" ++ str))
    )

audioCompleteSub : Sub Msg
audioCompleteSub =
  audioComplete
    (\str -> 
      Audio.codeToAudio str
      |> Maybe.map AudioFinished
      |> Maybe.withDefault (AudioError ("Unknown asset" ++ str))
    )

kbSub : Sub Msg
kbSub =
  Browser.Events.onKeyPress (D.succeed KeyPress)
