import Control.Monad (unless)
import Control.Monad.IO.Class (liftIO)
import Control.Monad.Trans.Cont (ContT (..), evalContT)
import Foreign.Marshal.Alloc (allocaBytes)
import System.IO

bufferSize :: Int
bufferSize = 1024 * 1024

percentOf :: Integral a => a -> a -> a
percentOf part all = (part * 100) `div` all

main :: IO ()
main = evalContT $ do
  infile <- ContT $ withBinaryFile "infile" ReadMode
  outfile <- ContT $ withBinaryFile "outfile" WriteMode
  buffer <- ContT $ allocaBytes $ bufferSize
  liftIO $ hSetBuffering infile NoBuffering
  liftIO $ hSetBuffering outfile NoBuffering
  fileSize <- liftIO $ hFileSize infile
  let copy progress = do
        print $ progress `percentOf` fileSize
        bytesRead <- hGetBuf infile buffer bufferSize
        hPutBuf outfile buffer bytesRead
        unless (bytesRead == 0) $ copy (progress + fromIntegral bytesRead)
  liftIO $ copy 0
