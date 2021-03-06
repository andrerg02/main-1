
module Chapter52 where

data Tree a = Null | Leaf a | Node (Tree a) (Tree a) deriving Show

flatten :: Ord a => Tree a -> [a]
flatten Null         = []
flatten (Leaf x)     = [x]
flatten (Node t1 t2) = merge (flatten t1) (flatten t2)

merge:: Ord a => [a] -> [a] -> [a]
merge [] ys  = ys
merge xs []  = xs
merge (x:xs) (y:ys)
  | x <= y    = x : merge xs (y:ys)
  | otherwise = y : merge (x:xs) ys

-- >>> merge [1,3,7,20] [1,2,5,10]
-- [1,1,2,3,5,7,10,20]

mktree :: [a] -> Tree a
-- mktree  [] = Null
-- mktree [x] = Leaf x
-- mktree xs  = Node (mktree ys) (mktree zs) where (ys,zs) = halve xs

-- halve xs = (take m xs,drop m xs) where m = length xs `div` 2

halve :: [a] -> ([a],[a])
halve = foldr op ([],[])
  where op x (ys,zs) = (zs,x:ys)

-- >>> halve [1..10]
-- ([2,4,6,8,10],[1,3,5,7,9])

msort :: Ord a => [a] -> [a]
-- msort = flatten . mktree

-- msort []  = []
-- msort [x] = [x]
-- msort xs  = merge (msort ys) (msort zs)
--  where (ys,zs) = halve xs
 
-- >>> msort [3,4,6,7,3,6,8,1,9,3]
-- [1,3,3,3,4,6,6,7,8,9]


-- mktree xs = fst (mkpair (length xs) xs)

-- mkpair :: Int -> [a] -> (Tree a, [a])
-- mkpair 0 xs = (Null, xs)
-- mkpair 1 xs = (Leaf (head xs), tail xs)
-- mkpair n xs = (Node t1 t2, zs)
--   where
--     (t1,ys) = mkpair m xs
--     (t2,zs) = mkpair (n - m) ys
--     m       = n `div` 2
  

-- msort :: Ord a => [a] -> [a]
-- msort = flatten . mktree

-- >>> msort [2,34,5,5,1,7,8]
-- [1,2,5,5,7,8,34]

-- >>> map Leaf [1..4] 
-- [Leaf 1,Leaf 2,Leaf 3,Leaf 4]

mktree [] = Null
mktree xs = unwrap (until single (pairWith Node) (map Leaf xs))

pairWith :: (t -> t -> t) -> [t] -> [t]
pairWith f []  = []
pairWith f [x] = [x]
pairWith f (x:y:xs) = f x y : pairWith f xs

-- single :: Foldable t => t a -> Bool
-- single xs = length xs == 1
single :: [a] -> Bool
single [x] = True
single _ = False

wrap :: a -> [a]
wrap x = [x]

unwrap :: [a] -> a
unwrap [x] = x

msort [] = []
-- msort xs = unwrap (until single (pairWith merge) (map wrap xs))

-- >>> msort [3,4,6,72,3,6,8,1,9,3]
-- [1,3,3,3,4,6,6,8,9,72]

-- >>> mktree [3,4,6,72,3]
-- Node (Node (Node (Leaf 3) (Leaf 4)) (Node (Leaf 6) (Leaf 72))) (Leaf 3)

msort xs = unwrap (until single (pairWith merge) (runs xs))

runs :: Ord a => [a] -> [[a]]

runs = foldr op []
  where 
    op x []  = [[x]]
    op x ((y:xs):xss) 
      | x <= y    = (x:y:xs):xss
      | otherwise = [x]:(y:xs):xss

-- >>> runs [3,4,5,3,5,6,56,70,80,70,60]
-- [[3,4,5],[3,5,6,56,70,80],[70],[60]]

-- >>> merge [70] [60]
-- [60,70]

