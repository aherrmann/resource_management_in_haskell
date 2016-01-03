import Resource
import Control.Exception (handle, throwIO)

main :: IO ()
main = handle (\ResourceException -> putStrLn "Oops") $ do
  a <- acquireResource "A"
  b <- acquireResource "B"
  -- do something with a and b
  throwIO ResourceException
  -- do some more with a and b
  releaseResource b
  releaseResource a
