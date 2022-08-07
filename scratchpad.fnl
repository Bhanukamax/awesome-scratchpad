;; SCRATCH PAD

(fn fn/filter [arr cb]
  (local new-arr [])
  (each [key value (pairs arr)]
    (when (= (cb value) true)
      (table.insert new-arr value)))
  new-arr)

(local awful (require :awful))
(local naughty (require :naughty))

;; Inspect copied from neovim
(local inspect (require :inspect))

(local M {})

;; Global State
(var active-sp-idx 0)
(var is-sp-visible false)
(var is-visible false)
(var visible-scratch-client {})
(var current-scratch-idx 0)

;; TODO: move this to a seperate module
(local util {})

(local table-has
       (fn [tabel pin]
         (var found false)
         (each [key c (pairs tabel)]
           (when (= c pin)
             (set found true))
           ) found))

(fn log [msg tbl]
  (local file (io.open "bmax-sp-log" "w+"))
  (file:write (inspect {:msg msg :tbl tbl}))
  (io.close file)
  )

(set util.log log)

(set util.table-has table-has)

;; Print Helper
(set M.alert
     (fn [tbl]
       (naughty.notify {:text (inspect
                               {:tbl tbl})})))

(var buf [])

(set M.get-screeen-clients
     (fn  []
       (local screen (awful.screen.focused))
       (local stag screen.selected_tag)
       (local screen-clients (stag:clients))
       screen-clients))

(set M.remove-scratch-props
     (fn [c]
       (set c.floating false)
       (set c.ontop false)))

(set M.set-client-props
     (fn [c]
       (local screen (awful.screen.focused))
       (local w screen.workarea)

       (do
         (set c.ontop true)
         (set c.floating true)
         (set c.height (/  w.height 2))
         (set c.width (/ w.width 2))
         (set c.x (+ (/ w.width 10) w.x))
         (set c.y (+ (/ w.height 10)  w.y)))))


(set M.send-to-scratch
     (fn [c]

       ;; get the screen tag clients
       (local screen (awful.screen.focused))
       (local stag screen.selected_tag)


       (local screen-clients (stag:clients))
       (local to-keep [])

       (each [key cc (pairs screen-clients)]
         ;; send the focus clinet to scrachpad
         ;; check if the cliet is already in it before sending
         ;; if focused
         (if (= client.focus cc)

             ;; if not already in the scratch buffer
             (when (= (util.table-has buf cc) false)
               (do
                 (table.insert buf cc)
                 (M.set-client-props cc)
                 (M.alert "sent to scrattch")))

             ;; Collect the clients to keep
             (do
               (when (= (util.table-has buf cc) false)
                 (table.insert to-keep cc)))))

       ;; Set the clientsforthe curreent tags from to-keep table
       (stag:clients to-keep)))

(set M.remove-client-from-scratch
     (fn  [c]
       (local new-buf (fn/filter buf (fn [i] (~= i c))))
       (set buf new-buf)
       (M.remove-scratch-props c)
       (when (> (length buf) 0)
         (M.show-scratch)
         (M.hide-scratch))
       ))

(set M.toggle-send
     (fn [c]
       (local buf-has-client (table-has buf c))
       (if (= buf-has-client true)
           (M.remove-client-from-scratch c)
           (M.send-to-scratch c))))

(set M.sanitize-client-props
     (fn [c]
       (when c
         (local screen (awful.screen.focused))
         (local w screen.workarea)
         (set c.ontop true)
         (set c.focused true)
         (set c.floating true)

         (when
             (or (< c.y w.y)
                 (> c.y (+ w.y w.height))
                 (> (+ c.x c.width) (+ w.y w.width))
                 (> (+ c.y c.height) (+ w.y w.height))
                 )
           (do
             (set c.height (/  w.height 2))
             (set c.width (/ w.width 2))
             (set c.x (+ (/ w.width 10) w.x))
             (set c.y (+ (/ w.height 10)  w.y)))))))

(set M.show-scratch
     (fn []
       (local screen (awful.screen.focused))

       (local stag screen.selected_tag)

       (local buf-count (length buf))
       (local sclients (M.get-screeen-clients))

       (local cs (. buf (+ current-scratch-idx 1)))
       (table.insert sclients cs)
       (set visible-scratch-client cs)
       (stag:clients sclients)

       (set is-visible true)
       (M.sanitize-client-props cs)
       (set client.focus cs)))

(set M.hide-scratch
     (fn []

       (local screen (awful.screen.focused))
       (local stag screen.selected_tag)

       (local sclients (M.get-screeen-clients))

       (local non-scratch-clients
              (fn/filter
               sclients
               (fn [i]
                 (~= i visible-scratch-client))))

       (stag:clients non-scratch-clients)

       (set is-visible false)))

(set M.cycle

     (fn []
       (when (> (length buf) 0)
         (if (= is-visible false)
             (M.show-scratch)
             (do
               (M.hide-scratch)
               (local buf-count (length buf))
               (local new-idx
                      (% (+ current-scratch-idx 1) buf-count))
               (set current-scratch-idx new-idx)
               (M.show-scratch)
               ;;        (M.set-client-props visible-scratch-client)
               (M.sanitize-client-props visible-scratch-client)
               (M.alert "show shwo next"))))))

;; toggle last active scratch pad
(set M.toggle-scratch
     (fn []
       (when (> (length buf) 0)
         (if (= is-visible false)
             (M.show-scratch)
             (M.hide-scratch)))))

(set M.send_to_scratch M.send-to-scratch)


(set M.toggle M.toggle-scratch)
(set M.toggle_send M.toggle-send)

M
