;; SCRATCH PAD
;; This is now usable

;; To be tested and implement
;; - Multi monitor scratch pads
;; - Remove from scratch pad

;; TODO:
;; - Fix about limitations
;; - Seperate this code and publish in a github repo

;;(local util (require :util))

(local awful (require :awful))
(local naughty (require :naughty))
;; Inspect copied from neovim
(local inspect (require :inspect))
(local screen (awful.screen.focused))

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
  (local screen-clients (stag:clients)))

;;-- This currently sends to tag 9
;; need to see if can implement scratch pad without using a tag
(fn send-to-scratch [c]

  ;; get the screen tag clients
  (local screen (awful.screen.focused))
  (local stag screen.selected_tag)


  (local screen-clients (stag:clients))
  (local to-keep [])

  (each [key c (pairs screen-clients)]
    ;; send the focus clinet to scrachpad
    ;; check if the cliet is already in it before sending
    ;; if focused
    (if (= client.focus c)

        ;; if not already in the scratch buffer
        (when (= (util.table-has buf c) false)
          (do
            (table.insert buf c)
            (M.alert "sent to scrattch")))

        ;; Collect the clients to keep
        (do
          (when (= (util.table-has buf c) false)
            (table.insert to-keep c)))))

  ;; Set the clientsforthe curreent tags from to-keep table
  (stag:clients to-keep)

  (M.alert {:msg :to-keep :to-keep to-keep :sent buf})
  )

;; Toggles on and off the scratch pad tag (tag 9)
;; Reason Unknown Caveatts:
;; - This will only work if the keybinding is set in the group where the spawn keybinding are set


(var is-visible false)

(var last-visible-idx 0)

(fn show-scratch []
  (local buf-count (length buf))
  (local sclietns (get-screeen-clietns))
  (M.alert {:msg :showing :clients sclietns})
  ;; Show scratch pad
  ;; get all the clietns of the current tag
  ;; add the first cient from the scratchpad to clietn tag
  ;; - reset the tags for ctag with the new clietn included

  (set is-visible true)
  (when (> buf-count 0)
    (set last-visible-idx
         (% (+ last-visible-idx 1) buf-count)))
 )

(fn hide-scratch []
    ;; Hide scratch pad
  ;; Reset the clients without the client from the scratch pad

  (M.alert "hiding scratchs!!")
  (set is-visible false))

(fn toggle-scratch [c]
  (M.alert "new toggle scratch!!")
  (if (= is-visible false)
      (show-scratch c)
      (hide-scratch c)))

(set M.send_to_scratch send-to-scratch)

(set M.toggle_scratch toggle-scratch)

M
