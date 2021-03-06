module Main where

import Control.Monad (liftM, join)
import Data.ByteString.Lazy.Char8 (pack, unpack)
import Data.Maybe (fromMaybe)
import System.Environment (lookupEnv)
import System.Random (randomRIO)
import Network.Wai (Application, responseLBS)
import Network.Wai.Internal
import Network.Wai.Handler.Warp (run)
import Network.HTTP.Types (status200)
import Network.HTTP.Types.Header (hContentType)

import Vocabulary (adjs, nouns)

endAs, endNs :: Int
endAs = length adjs - 1
endNs = length nouns - 1

getRandomName :: IO String
getRandomName = do
    randomAdj <- randomRIO (0, endAs)
    randomNouns <- randomRIO (0, endNs)
    let adj = adjs !! randomAdj
    let noun = nouns !! randomNouns
    return $ mconcat ["{\"name\": \"", adj, "_", noun, "\"}"]

app :: Application
app _req f = join $ f `liftM` response
    where
        response :: IO Response
        response = getRandomName >>= (\n -> return $ responseLBS status200 [(hContentType, "application/json")] (pack n))

main :: IO ()
main = do
      port <- fmap (fromMaybe "3000") (lookupEnv "PORT")
      putStrLn ("Serving at " ++ port)
      run (read port) app 

