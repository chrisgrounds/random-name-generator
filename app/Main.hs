module Main where

import Data.Monoid ((<>))
import Data.Maybe (fromMaybe)
import System.Environment (lookupEnv)
import System.Random (randomRIO)
import Network.Wai (Application, responseLBS)
import Network.Wai.Handler.Warp (run)
import Network.HTTP.Types (status200)
import Network.HTTP.Types.Header (hContentType)
import Data.ByteString.Lazy.Char8 (pack, unpack)

main :: IO ()
main =
    do
      port <- fmap (fromMaybe "3000") (lookupEnv "PORT")
      putStrLn ("Serving at " <> port)
      let endAs = length adjs - 1
      let endNs = length nouns - 1
      randomAdj <- randomRIO (0, endAs)
      randomNouns <- randomRIO (0, endNs)
      let adj = adjs !! randomAdj
      let noun = nouns !! randomNouns
      let randomName = mconcat ["{\"name\": \"", adj, "_", noun, "\"}"]
      run (read port) (app randomName)

adjs = ["admiring",
    "adoring",
    "agitated",
    "angry",
    "backstabbing",
    "berserk",
    "boring",
    "clever",
    "cocky",
    "compassionate",
    "condescending",
    "cranky",
    "desperate",
    "determined",
    "distracted",
    "dreamy",
    "drunk",
    "ecstatic",
    "elated",
    "elegant",
    "evil",
    "fervent",
    "focused",
    "furious",
    "gloomy",
    "goofy",
    "grave",
    "happy",
    "high",
    "hopeful",
    "hungry",
    "insane",
    "jolly",
    "jovial",
    "kickass",
    "lonely",
    "loving",
    "mad",
    "modest",
    "naughty",
    "nostalgic",
    "pensive",
    "prickly",
    "reverent",
    "romantic",
    "sad",
    "serene",
    "sharp",
    "sick",
    "silly",
    "sleepy",
    "stoic",
    "stupefied",
    "suspicious",
    "tender",
    "thirsty",
    "trusting"]

nouns = ["lake",
    "mountain",
    "plateau",
    "fjord",
    "hilltop",
    "valley",
    "gorge",
    "canyon",
    "peak",
    "trough",
    "stream",
    "river",
    "sea",
    "cloud",
    "fog"]


app :: String -> Application
app htmlContent _req f = f $ response
    where
        response = responseLBS status200 [(hContentType, "application/json")] (pack htmlContent)

