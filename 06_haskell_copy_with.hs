import Control.Monad (unless)
import Foreign.Marshal.Alloc (allocaBytes)
import System.IO

bufferSize :: Int
bufferSize = 1024 * 1024

percentOf :: Integral a => a -> a -> a
percentOf part all = (part * 100) `div` all

main :: IO ()
main =
  withBinaryFile "infile" ReadMode $ \infile ->
    withBinaryFile "outfile" WriteMode $ \outfile ->
      allocaBytes bufferSize $ \buffer -> do
        hSetBuffering infile NoBuffering
        hSetBuffering outfile NoBuffering
        fileSize <- hFileSize infile
        let copy progress = do
              print $ progress `percentOf` fileSize
              bytesRead <- hGetBuf infile buffer bufferSize
              hPutBuf outfile buffer bytesRead
              unless (bytesRead == 0) $ copy (progress + fromIntegral bytesRead)
        copy 0
