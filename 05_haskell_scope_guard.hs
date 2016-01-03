import Resource
import Control.Exception (handle, finally, onException, mask, throwIO)
import Control.Monad (when)
import Control.Monad.IO.Class (liftIO)
import Control.Monad.Trans.Cont (ContT (..), evalContT)

scopeExit :: IO a -> ContT r IO ()
scopeExit action = ContT $ \f -> f () `finally` action

scopeFail :: IO a -> ContT r IO ()
scopeFail action = ContT $ \f -> f () `onException` action

scopeSuccess :: IO a -> ContT r IO ()
scopeSuccess action = ContT $ \f -> do
  mask $ \restore -> do
    r <- restore (f ())
    _ <- action
    return r

demo :: Bool -> IO ()
demo throw = evalContT $ do
  scopeExit $ putStrLn "Leaving scope"
  scopeFail $ putStrLn "Scope failed"
  scopeSuccess $ putStrLn "Scope succeeded"
  liftIO $ putStrLn "Inside scope"
  when throw $ liftIO $ throwIO ResourceException
  liftIO $ putStrLn "Did we just throw?"

main :: IO ()
main = do
  handle (\ResourceException -> putStrLn "Oops") $ demo True
  putStrLn $ replicate 50 '-'
  handle (\ResourceException -> putStrLn "Oops") $ demo False
