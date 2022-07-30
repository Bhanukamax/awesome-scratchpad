;; SCRATCH PAD
;; This is now usable

;; To be tested and implement
;; - Multi monitor scratch pads
;; - Remove from scratch pad

;; TODO:
;; - Fix about limitations
;; - Seperate this code and publish in a github repo


(local awful (require :awful))
(local naughty (require :naughty))
;; Inspect copied from neovim
(local inspect (require :inspect))
(local screen (awful.screen.focused))

(local M {})

;; Global State
(var active-sp-idx 0)
(var is-sp-visible false)

;; Print Helper
(set M.alert
     (fn [tbl]
       (naughty.notify {:text (inspect
                               {:tbl tbl})})))

(fn send-to-scratch [c]
  ;; Get the tags of the current screen
  (local screen (awful.screen.focused))
  ;; Get the 9th tag of the current screen (9 is riserved for scratch pad for now)
  (local ctag (. screen.tags 9))
  ;; Get the current screen dimentions
  (local workarea screen.workarea)
  (local height (/ workarea.height 2))
  (local width (/ workarea.width 2))
  (local x (/ width 2))
  (local y (/ height 2))
  ;; Send the current client to scratch pad
  (when (= client.focus c)
      (do (client.focus:move_to_tag ctag)
          (set c.ontop true)
          (set c.floating true)
          (set c.height height)
          (set c.width width)
          (set c.x x)
          (set c.y y))))


;; Toggles on and off the scratch pad tag (tag 9)
;; Reason Unknown Caveatts:
;; - This will only work if the keybinding is set in the group where the spawn keybinding are set


(fn hide-scratch [c]
  (set is-sp-visible false))

(fn show-scratch [c]

  (set is-sp-visible true)
  ;; (awful.spawn "kitty")
  (local screen (awful.screen.focused))

  (local stag (. screen.tags 9))
  (local screen-clients (stag:clients))
  (local sp-count (length screen-clients))

  (set active-sp-idx
       (% (+ active-sp-idx 1) sp-count))

  (each [key c-client (pairs screen-clients)]
    (do

      (if (= (+ active-sp-idx 1) key)
        (do
          (set c-client.ontop true)
          (set c-client.floating true)
          ;; Raise & Focus the scrach pad client
          (c-client:raise)
          (set c-client.skip_taskbar false)
          (set c-client.minimized false)
          (set client.focus c-client))
        ;; Minimize inactive scratch buffers
        (do
          (set c-client.skip_taskbar true)
          (set c-client.minimized true))
        ))))

(fn toggle-scratch [c]
  (local screen (awful.screen.focused))
  (local stag (. screen.tags 9))
  (local screen-clients (stag:clients))

  (local sp-count (length screen-clients))
  (when  (> sp-count 0)

    (if is-sp-visible
        (hide-scratch c)
        (show-scratch c))

    (awful.tag.viewtoggle (. screen.tags 9))))

(set M.send_to_scratch send-to-scratch)

(set M.toggle_scratch toggle-scratch)

M
