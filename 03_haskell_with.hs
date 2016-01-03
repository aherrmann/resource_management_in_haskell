import Resource
import Control.Exception (handle, throwIO)

main :: IO ()
main = handle (\ResourceException -> putStrLn "Oops") $
  withResource "A" $ \a ->
    withResource "B" $ \b -> do
      -- do something with a and b
      throwIO ResourceException
      -- do some more with a and b
