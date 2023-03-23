port module Router.RemoteApi exposing (loadUrlInNewTab, receivePageVisibility)

{-| The remote api file for the router. When elm isn't quite enough


# Ports

@docs loadUrlInNewTab, receivePageVisibility

-}


{-| Call out to load a url in a new tab
-}
port loadUrlInNewTab : String -> Cmd msg


{-| Receive data about whether the current tab or page is active.
-}
port receivePageVisibility : (Bool -> msg) -> Sub msg
