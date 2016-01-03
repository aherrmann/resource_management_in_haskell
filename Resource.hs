module Resource where

import Control.Exception
import Data.Typeable

data Resource = Resource String

data ResourceException = ResourceException deriving (Show, Typeable)
instance Exception ResourceException

acquireResource :: String -> IO Resource
acquireResource name = do
  putStrLn $ "Acquired " ++ name
  return $ Resource name

releaseResource :: Resource -> IO ()
releaseResource (Resource name) = putStrLn $ "Released " ++ name

withResource :: String -> (Resource -> IO r) -> IO r
withResource name = bracket (acquireResource name) releaseResource
