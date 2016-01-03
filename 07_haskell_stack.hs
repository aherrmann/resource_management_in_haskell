import Control.Monad.Trans.Class (lift)
import Control.Monad.Trans.Cont (ContT (..), evalContT)
import Control.Monad.Trans.State.Strict

type Stack a = State [Int] a

pop :: Stack (Maybe Int)
pop = state $ \s -> case s of []     -> (Nothing, [])
                              (x:xs) -> ( Just x, xs)

push :: Int -> Stack ()
push x = modify (x:)

pushM :: Maybe Int -> Stack ()
pushM Nothing = return ()
pushM (Just x) = push x

withPop :: (Maybe Int -> Stack b) -> Stack b
withPop action = do
  x <- pop
  r <- action x
  pushM x
  return r

runScope :: (Monad m) => ContT r m r -> m r
runScope = flip runContT return

main :: IO ()
main = print $ flip execState [] $ evalContT $ do
  lift $ mapM push [1,2,3,4] -- [4,3,2,1]
  Just a <- ContT $ withPop  -- [3,2,1]
  Just b <- ContT $ withPop  -- [2,1]
  lift $ push $ a + b        -- [7,2,1
                             -- [4,3,7,2,1]
