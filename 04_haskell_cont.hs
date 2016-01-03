import Resource
import Control.Exception (handle, throwIO)
import Control.Monad.IO.Class (liftIO)
import Control.Monad.Trans.Cont (ContT (..), evalContT)

main :: IO ()
main = handle (\ResourceException -> putStrLn "Oops") $ evalContT $ do
  a <- ContT $ withResource "A"
  b <- ContT $ withResource "B"
  -- do something with a and b
  liftIO $ throwIO ResourceException
  -- do some more with a and b
