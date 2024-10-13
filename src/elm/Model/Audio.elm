module Model.Audio exposing (..)

import Asset exposing (Asset, Assets)
import Json.Decode as D exposing (Decoder)

type Audio
  = Splat
  | BGM

type Volume
  = Mute Float
  | Volume Float


mute : Volume -> Volume
mute v =
  case v of
    Volume x -> Mute x
    _ -> v

muteか : Volume -> Bool
muteか v =
  case v of
    Mute _ -> True
    _ -> False

volume : Volume -> Float
volume v =
  case v of
    Mute _ -> 0
    Volume x -> x


audioLoadedか : Audio -> Assets -> Bool
audioLoadedか c =
  Asset.check (audioCode c) Asset.readyか

audioCode : Audio -> String
audioCode c =
  case c of
    Splat -> "splat"
    BGM -> "bgm"

audioDecoder : Decoder Audio
audioDecoder =
  D.string
    |> D.andThen
        (\str ->
          case str |> Debug.log "sfx" of
            "splat" -> D.succeed Splat
            "bgm" -> D.succeed BGM
            _ -> D.fail <| "Unknown SFX: " ++ str
        )

codeToAudio : String -> Maybe Audio
codeToAudio code =
  case code of
    "splat" -> Just Splat
    "bgm" -> Just BGM
    _ -> Nothing

playAudio : Audio -> Assets -> Assets
playAudio audio =
  Asset.update (audioCode audio) Asset.activate

loadAudio : Audio -> Assets -> Assets
loadAudio audio =
  Asset.update (audioCode audio) Asset.ready

error : String -> Audio -> Assets -> Assets
error message audio =
  Asset.update (audioCode audio) (Asset.fail message)

allAudio : List Audio
allAudio =
  [ BGM, Splat ]

audioPlayingか : Audio -> Assets -> Bool
audioPlayingか audio =
  checkAudio audio Asset.activeか

checkAudio : Audio -> (Asset -> Bool) -> Asset.Assets -> Bool
checkAudio clip =
  Asset.check (audioCode clip)

