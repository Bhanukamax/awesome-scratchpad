;; SCRATCH PAD
;; This is now usable

;; To be tested and implement
;; - Multi monitor scratch pads
;; - Remove from scratch pad

;; TODO:
;; - Fix about limitations
;; - Seperate this code and publish in a github repo

;;(local util (require :util))



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
;;(local screen (awful.screen.focused))

(local M {})

;; Global State
(var active-sp-idx 0)
(var is-sp-visible false)

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


(fn get-screeen-clietns []
  (local screen (awful.screen.focused))
  (local stag screen.selected_tag)
  (local screen-clients (stag:clients))
  screen-clients)

(fn get-current-tag []
  (local screen (awful.screen.focused))
  (screen.selected_tag))

;;-- This currently sends to tag 9
;; need to see if can implement scratch pad without using a tag

(fn send-to-scratch [c]

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
            (M.alert "sent to scrattch")))

        ;; Collect the clients to keep
        (do
          (when (= (util.table-has buf cc) false)
            (table.insert to-keep cc)))))

  ;; Set the clientsforthe curreent tags from to-keep table
  (stag:clients to-keep)

  )

;; Toggles on and off the scratch pad tag (tag 9)
;; Reason Unknown Caveatts:
;; - This will only work if the keybinding is set in the group where the spawn keybinding are set


(var is-visible false)

(var visible-scratch-client {})
(var current-scratch-idx 0)

(fn set-client-props [c]
  (local screen (awful.screen.focused))
  (local w screen.workarea)

  (do
    (set c.ontop true)
    (set c.floating true)
    (set c.height (/  w.height 2))
    (set c.width (/ w.width 2))
    (set c.x (+ (/ w.width 10) w.x))
    (set c.y (+ (/ w.height 10)  w.y))))

(fn show-scratch []


  (local screen (awful.screen.focused))

  (local stag screen.selected_tag)

  (local buf-count (length buf))
  (local sclients (get-screeen-clietns))


 ;; (when (> buf-count 0)
 ;;    (set current-scratch-idx
 ;;         (% (+ last-visible-idx 1) buf-count)))
  ;; get the current scratch client
  (local cs (. buf (+ current-scratch-idx 1)))
  (table.insert sclients cs)
  (set visible-scratch-client cs)
  (stag:clients sclients)

  (set is-visible true))

(fn hide-scratch []

  (local screen (awful.screen.focused))
  (local stag screen.selected_tag)

  (local sclients (get-screeen-clietns))

  (local non-scratch-clients
         (fn/filter
          sclients
          (fn [i]
            (~= i visible-scratch-client))))

  (stag:clients non-scratch-clients)
  (set is-visible false))

(fn cycle []
  (if (= is-visible false)
      (show-scratch)
      (do
        (hide-scratch)
        (local buf-count (length buf))
        (local new-idx
             (% (+ current-scratch-idx 1) buf-count))
        (set current-scratch-idx new-idx)
        (show-scratch)
        (set-client-props visible-scratch-client)
        (M.alert "show shwo next"))))

;; toggle last active scratch pad
(fn toggle-scratch []
  (when (> (length buf) 0)
    (if (= is-visible false)
        (show-scratch)
        (hide-scratch))))

(set M.send_to_scratch send-to-scratch)
(set M.toggle toggle-scratch)
(set M.cycle cycle)

M
