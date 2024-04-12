open Gamelle_backend
open Gamelle_common
open Ui_backend
open Widget_builder

type params = string
type state = bool
type return = bool
type Ui_backend.state += Button of state

let construct_state b = Button b
let destruct_state s = match s with Button b -> b | _ -> raise IdTypeMismatch

let size ~ts text =
  let text_size = ts text in
  V2.(text_size + (2. * padding_xy))

let render ~io text _is_clicked box =
  fill_rect ~io ~color:bg' box;
  draw_rect ~io ~color:fg box;
  let text_size = text_size ~io ~size:font_size text in
  let text_box = Box.(v_mid (mid box) text_size) in
  draw_string ~io ~color:fg ~size:font_size text (Box.o text_box)

let update ~io _text _old_state box = is_clicked ~io box
let result _ b = b

let v =
  elt ~construct_state ~destruct_state
    ~default:(fun _ -> false)
    ~size ~render ~update ~result ()
