import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicBars
import XMonad.Hooks.SetWMName
import XMonad.Layout.IndependentScreens
import XMonad.Layout.Fullscreen
import XMonad.Layout.NoBorders
import XMonad.Layout.Tabbed
import XMonad.Layout.Grid
import XMonad.Layout.ThreeColumns
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO

main = do
    nScreens <- countScreens

    xmproc <- spawnPipe $ if nScreens == 2 then "xmobar -p 'Static { xpos = 1920, ypos = 0, width = 1920, height = 20 }'" else "xmobar"

    xmonad $ docks defaultConfig
        { startupHook = setWMName "LG3D"
        , manageHook = manageDocks <+> manageHook defaultConfig
        , layoutHook = smartBorders $ myLayout
        , logHook = dynamicLogWithPP xmobarPP
                        { ppOutput = hPutStrLn xmproc
                        , ppTitle = xmobarColor "green" "" . shorten 50
                        }
        , modMask = mod4Mask
        } `additionalKeys`
        [ ((mod4Mask .|. shiftMask, xK_l), spawn "xscreensaver-command -lock; xset dpms force off")
        ]

myLayout = avoidStruts (
    Tall 1 (3/100) (1/2) |||
    ThreeColMid 1 (3/100) (1/2) |||
    Grid |||
    Full)