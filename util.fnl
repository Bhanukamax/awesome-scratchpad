(local M {})

(local table-has
     (fn [tabel pin]
       (var found false)
       (each [key c (pairs screen-clients)]
         (when (= c pin)
           (set found true))
         ) found))

(set M.table-has table-has)

M
