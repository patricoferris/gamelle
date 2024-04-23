open! Common
open Gamelle_common.Events_backend

let key_of_keycode kc =
  match () with
  | _ when kc = Sdl.K.lalt -> Some `alt
  | _ when kc = Sdl.K.ralt -> Some `alt_gr
  | _ when kc = Sdl.K.down -> Some `arrow_down
  | _ when kc = Sdl.K.left -> Some `arrow_left
  | _ when kc = Sdl.K.right -> Some `arrow_right
  | _ when kc = Sdl.K.up -> Some `arrow_up
  | _ when kc = Sdl.K.backspace -> Some `backspace
  | _ when kc = Sdl.K.lctrl -> Some `control_left
  | _ when kc = Sdl.K.rctrl -> Some `control_right
  | _ when kc = Sdl.K.delete -> Some `delete
  | _ when kc = Sdl.K.escape -> Some `escape
  (* todo : meta key *)
  | _ when kc = Sdl.K.lshift -> Some `shift
  | _ when kc = Sdl.K.rshift -> Some `shift
  | _ when kc = Sdl.K.space -> Some `space
  | _ when kc = Sdl.K.tab -> Some `tab
  (* `char _ events are produced by SdlTextInput events not keypresses. This is
     the only clean way to handle shift key and various layouts *)
  (*| _ when kc >= 0 && kc <= 127 ->
      Some (`char (Char.chr ( kc )))*)
  | _ -> None

let key_of_event e = key_of_keycode (Sdl.Event.get e Sdl.Event.keyboard_keycode)

let update t e =
  let typ = Sdl.Event.get e Sdl.Event.typ in
  let t =
    {
      t with
      pressed_chars = Chars.empty;
      keypressed =
        Keys.filter (function `char _ -> false | _ -> true) t.keypressed;
    }
  in
  match () with
  | _ when typ = Sdl.Event.quit ->
      { t with keypressed = insert `quit t.keypressed }
  | _ when typ = Sdl.Event.text_input ->
      let char = Sdl.Event.(get e text_input_text).[0] in
      let keypressed = Keys.add (`char char) t.keypressed in
      let pressed_chars = Chars.singleton char in
      { t with pressed_chars; keypressed }
  | _ when typ = Sdl.Event.key_down -> (
      let key = key_of_event e in
      match key with
      | Some key -> { t with keypressed = insert key t.keypressed }
      | None -> t)
  | _ when typ = Sdl.Event.key_up -> (
      let key = key_of_event e in
      match key with
      | Some key -> { t with keypressed = remove key t.keypressed }
      | None -> t)
  | _ when typ = Sdl.Event.mouse_wheel -> (
      let wheel_delta = Sdl.Event.(get e mouse_wheel_y) in
      let wheel_delta = t.wheel_delta +. float (wheel_delta * 4) in
      let t = { t with wheel_delta } in
      match wheel_delta with
      | d when d <> 0. ->
          { t with keypressed = insert `wheel @@ remove `wheel t.keypressed }
      | _ -> { t with keypressed = remove `wheel t.keypressed })
  | _ ->
      (* Format.printf "unhandled event@." ; *)
      t

let update t e = try update t e with Exit as exn -> raise exn | _ -> t

let reset t =
  { t with keypressed = remove `wheel t.keypressed; wheel_delta = 0. }

let update_mouse t =
  let state, (x, y) = Sdl.get_mouse_state () in
  let t =
    if Int32.logand state Sdl.Button.lmask <> Int32.zero then
      { t with keypressed = insert `click_left t.keypressed }
    else { t with keypressed = remove `click_left t.keypressed }
  in
  let t =
    if Int32.logand state Sdl.Button.rmask <> Int32.zero then
      { t with keypressed = insert `click_right t.keypressed }
    else { t with keypressed = remove `click_right t.keypressed }
  in
  { t with mouse_x = float x; mouse_y = float y }
