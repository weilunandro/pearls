import Data.List

transform :: Ord a => [a] -> ([a], Int)
transform xs = (map last xss, position xs xss)
  where 
    xss = sort (rots xs)

position xs xss = length (takeWhile (/= xs) xss)

rots :: [a] -> [[a]]
rots xs = take (length xs) (iterate lrot xs)
  where 
    lrot (x:xs) = xs ++ [x]

takeCols :: Int -> [[a]] -> [[a]]
takeCols j = map (take j)

recreate :: Ord a => Int -> [a] -> [[a]]
recreate 0 = map (const [])
recreate j = hdsort . consCol . fork (id, recreate (j - 1))

rrot :: [a] -> [a]
rrot xs = [last xs] ++ init xs

hdsort :: Ord a => [[a]] -> [[a]]
hdsort = sortBy cmp
  where 
    cmp (x:xs) (y:ys) = compare x y

consCol :: ([a], [[a]]) -> [[a]]
consCol (xs, xss) = zipWith (:) xs xss

fork :: (a -> b, a -> c) -> a -> (b, c)
fork (f, g) x = (f x, g x)

-- Note: in the book, it doesn't mention that the first argument to the first 
-- call of `recreate` needs to be the length of the transformed string.
untransform :: Ord a => ([a], Int) -> [a]
untransform (ys, k) = (recreate (length ys) ys) !! k 

t = transform "Now is the time for all good men to come to the aid of their party."
u = untransform t

sort' ys = apply q ys
  where
    q = p ys

p :: Ord a => [a] -> [Int]
p ys = map snd (sort (zip ys [0 .. n - 1]))
  where
    n = length ys

apply :: [Int] -> [a] -> [a]
apply p xs = [xs !! (p !! i ) | i <- [0 .. n - 1]]
  where
    n = length xs

recreate' :: Ord a => Int -> [a] -> [[a]]
recreate' 0 ys = map (const []) ys
recreate' j ys = (consCol . fork (apply q, apply q . (recreate' (j - 1)))) ys
  where
    q = p ys

untransform' :: Ord a => ([a], Int) -> [a]
untransform' (ys, k) = (recreate' (length ys) ys) !! k


