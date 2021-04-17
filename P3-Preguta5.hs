foldr :: (a -> b -> b) -> b -> [a] -> b
foldr _ e [] = e
foldr f e (x:xs) = f x $ foldr f e xs

-- (a)
takeWhile :: (a -> Bool) -> [a] -> [a]
takeWhile p = foldr (\a r -> if p a then a : r else []) []

gen :: Int -> [Int]
gen n = n : gen (n + 1)

lambda = \a r-> if (<=3) a then a : r else []

-- Corrida evaluación normal:
takeWhile (<=3) (gen 1)
-- takeWhile p
foldr (\a r-> if (<=3) a then a : r else []) [] (gen 1)
-- gen n
foldr (\a r-> if (<=3) a then a : r else []) [] (1 : gen (1+1))
-- foldr f e (x:xs)
(\a r -> if (<=3) a then a : r else []) 1 (foldr (\a r-> if (<=3) a then a : r else []) [] gen 1+1)
-- lambda
1 : foldr (\a r-> if (<=3) a then a : r else []) [] (gen 1+1)
-- evaluar argumento de gen
1 : foldr (\a r-> if (<=3) a then a : r else []) [] (gen 2)
-- gen n
1 : foldr (\a r-> if (<=3) a then a : r else []) [] (2 : gen 2 + 1)
-- foldr f e (x:xs)
1 : (\a r-> if (<=3) a then a : r else []) 2 (foldr (\a r-> if (<=3) a then a : r else []) [] gen 2 + 1)
-- lambda
1 : 2 : foldr (\a r-> if (<=3) a then a : r else []) [] (gen 2 + 1)
-- evaluar agumento de gen
1 : 2 : foldr (\a r-> if (<=3) a then a : r else []) [] (gen 3)
-- gen n
1 : 2 : foldr (\a r-> if (<=3) a then a : r else []) [] (3 : gen 3 + 1)
-- foldr f e (x:xs)
1 : 2 : (\a r-> if (<=3) a then a : r else []) 3 (foldr (\a r-> if (<=3) a then a : r else []) [] gen 3 + 1)
-- lambda
1 : 2 : 3 : (foldr (\a r-> if (<=3) a then a : r else []) [] (gen 3 + 1))
-- evaluar argumento de gen
1 : 2 : 3 : (foldr (\a r-> if (<=3) a then a : r else []) [] (gen 4))
-- gen n
1 : 2 : 3 : (foldr (\a r-> if (<=3) a then a : r else []) [] (4 : gen 4 + 1))
-- foldr f e (x:xs)
1 : 2 : 3 : (\a r-> if (<=3) a then a : r else []) 4 (foldr (\a r-> if (<=3) a then a : r else []) [] gen 4 + 1)
-- lambda
1 : 2 : 3 : []
1 : 2 : [3]
1 : [2,3]
[1,2,3]
-- 
-- Corrida evaluación aplicativa:
takeWhile (<=3) (gen 1)
-- gen n
takeWhile (<=3) (1 : gen 2)
-- gen n
takeWhile (<=3) (1 : (2 : gen 3))
-- gen n
takeWhile (<=3) (1 : (2 : (3 : gen 4)))
-- gen n
takeWhile (<=3) (1 : (2 : (3 : (4 : (gen 5)))))
-- gen n ... gen n... gen n... gen b....
...

-- (b)

data Arbol a = Hoja | Rama a (Arbol a) (Arbol a)

foldA  :: (a -> b -> b -> b) -> b -> Arbol a -> b
foldA f z Hoja = z
foldA f z (Rama i r d) = f i (foldA f z r  )  (foldA f z d  )

-- (c)

takeWhileA :: (a -> Bool) -> Arbol a -> Arbol a
takeWhileA p = foldA (\a i d -> if p a then Rama a i d else Hoja) Hoja

genA :: Int -> Arbol Int
genA n = Rama n (genA (n + 1)) (genA (n * 2))

-- Corrida evaluación normal:
lambda = \a i d -> if (<=3) a then Rama a i d else Hoja

takeWhile (<=3) (gen 1)
-- takeWhile p
foldA (lambda) Hoja (genA 1)
-- genA n
foldA (lambda) Hoja ( Rama 1 (genA (1 + 1)) (genA (1 * 2)))
-- foldA f z (Rama i r d)
(lambda) 1 (foldA (lambda) Hoja (genA (1 + 1))) (foldA (lambda) Hoja (genA (1 * 2)))
-- lambda
Rama 1 ( foldA (lambda) Hoja (genA (1 + 1))) (foldA (lambda) Hoja (genA (1 * 2)))
-- evaluar argumento de gen
Rama 1 ( foldA (lambda) Hoja (genA (2)) ) ( foldA (lambda) Hoja (genA (2)) )
-- gen n
Rama 1 ( foldA (lambda) Hoja ( Rama 2 (genA (2 + 1)) (genA (2 * 2))) ) ( foldA (lambda) Hoja ( Rama 2 (genA (2 + 1)) (genA (2 * 2))) )
-- foldA f z (Rama i r d)
Rama 1 ( foldA lambda Hoja ( Rama 2 (genA (2 + 1)) (genA (2 * 2))) ) ( foldA lambda Hoja ( Rama 2 (genA (2 + 1)) (genA (2 * 2))) )
-- lambda
Rama 1 (lambda 2 (foldA lambda Hoja (genA (2 + 1))) (foldA lambda Hoja (genA (2 * 2))) ) (lambda 2 (foldA lambda Hoja (genA (2 + 1))) (foldA lambda Hoja (genA (2 * 2))) )
-- evaluar argumento de gen 
Rama 1 (Rama 2  (foldA lambda Hoja (genA (2 + 1))) (foldA lambda Hoja (genA (2 * 2)))) (Rama 2  (foldA lambda Hoja (genA (2 + 1))) (foldA lambda Hoja (genA (2 * 2)))) 
-- gen n
Rama 1 (Rama 2  (foldA lambda Hoja (genA (3))) (foldA lambda Hoja (genA (4))))  (Rama 2  (foldA lambda Hoja (genA (3))) (foldA lambda Hoja (genA (4))))
-- foldA f z (Rama i r d)
Rama 1 (Rama 2  (foldA lambda Hoja ( Rama 3 (genA (3 + 1)) (genA (3 * 2))) ) (foldA lambda Hoja ( Rama 4 (genA (4 + 1)) (genA (4 * 2))) ) (Rama 2  (foldA lambda Hoja ( Rama 3 (genA (3 + 1)) (genA (3 * 2))) ) (foldA lambda Hoja ( Rama 4 (genA (4 + 1)) (genA (4 * 2))) ) ) 
-- lambda
Rama 1 (Rama 2  (lambda 3 (foldA lambda Hoja (genA (3 + 1))) (foldA lambda Hoja (genA (3 * 2)))) ( lambda 4 (foldA lambda Hoja (genA (4 + 1)) ) (foldA lambda Hoja (genA (4 * 2))) ) ( Rama 2  (lambda 3 (foldA lambda Hoja (genA (3 + 1))) (foldA lambda Hoja (genA (3 * 2)))) ( lambda 4 (foldA lambda Hoja (genA (4 + 1)) ) (foldA lambda Hoja (genA (4 * 2))) ) 
-- evaluar argumentos de gen
Rama 1 (Rama 2  (Rama 3  (foldA lambda Hoja (genA (4))) (foldA lambda Hoja (genA (6)))) )  Hoja ) (Rama 2  (Rama 3  (foldA lambda Hoja (genA (4))) (foldA lambda Hoja (genA (6)))) )  Hoja ) 
-- gen n
Rama 1 (Rama 2  (Rama 3  (foldA lambda Hoja (Rama 4 (genA (4 + 1)) (genA (4 * 2)) )) (foldA lambda Hoja (Rama 6 (genA (6 + 1)) (genA (6 * 2)) ))) )  Hoja ) (Rama 2  (Rama 3  (foldA lambda Hoja (Rama 4 (genA (4 + 1)) (genA (4 * 2)) )) (foldA lambda Hoja (Rama 6 (genA (6 + 1)) (genA (6 * 2)) )) )  Hoja )
-- foldA f z (Rama i r d)
Rama 1 (Rama 2  (Rama 3  (lambda 4 (foldA lambda Hoja (genA (4 + 1))) (foldA lambda Hoja (genA (4 * 2)))) (lambda 6 (foldA lambda Hoja (genA (6 + 1)) ) (foldA lambda Hoja (genA (6 * 2))) )  Hoja ) (Rama 2  (Rama 3  (lambda 4 (foldA lambda Hoja (genA (4 + 1))) (foldA lambda Hoja (genA (4 * 2)))) (lambda 6 (foldA lambda Hoja (genA (6 + 1)) ) (foldA lambda Hoja (genA (6 * 2))) )  Hoja )
-- lambda
Rama 1 (Rama 2  (Rama 3  Hoja  Hoja  )  Hoja ) (Rama 2  (Rama 3  Hoja  Hoja  )  Hoja )


-- Corrida evaluación aplicativa:
takeWhileA (<=3) (genA 1)
-- takeWhile
takeWhileA (<=3) ( Rama 1 (genA (2)) (genA (2)))
-- gen n
takeWhileA (<=3) ( Rama 1 ( Rama 2 (genA (3)) (genA (4)) ) ( Rama 2 (genA (3)) (genA (4))))
-- gen n
takeWhileA (<=3) ( Rama 1 ( Rama 2 ( Rama 3 (genA (4)) (genA (6))) ( Rama 4 (genA (5)) (genA (8))) ) ( Rama 2 ( Rama 3 (genA (4)) (genA (6))) ( Rama 4 (genA (5)) (genA (8)))))







