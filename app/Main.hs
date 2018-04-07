module Main where

import Data.Monoid ((<>))
import Data.Maybe (fromMaybe)
import System.Environment (lookupEnv)
import Network.Wai (Application, responseLBS)
import Network.Wai.Handler.Warp (run)
import Network.HTTP.Types (status200)
import Network.HTTP.Types.Header (hContentType)

main :: IO ()
main =
  do
    port <- fmap (fromMaybe "3000") (lookupEnv "PORT")
    putStrLn ("Serving at " <> port)
    run (read port) app

app :: Application
app _req f =
  f response
  where
    response = responseLBS status200 [(hContentType, "text/plain")] "Piu."

