module Model.Config exposing (..)

import Model.Audio exposing (Volume(..))

type alias Config =
  { bgmVolume : Volume
  , sfxVolume : Volume
  }

new : Config
new =
  { bgmVolume = Volume 0.5
  , sfxVolume = Volume 0.5
  }
 
setBGMVolume : Volume -> Config -> Config
setBGMVolume volume config =
  { config | bgmVolume = volume }

setSFXVolume : Volume -> Config -> Config
setSFXVolume volume config =
  { config | sfxVolume = volume }
