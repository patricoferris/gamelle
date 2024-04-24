open Gamelle_backend
open Draw_geometry

type t
type cap = t * string
type alignment = Start | End | Center | Fill
type style = { vertical : alignment; horizontal : alignment }

type vscroll_state = {
  size : size;
  offset : float;
  grasped : bool;
  real_height : float;
}

type slider_state = { v : float; grasped : bool }
type slider_params = { w : float; min : float; max : float }
type 'a vscroll_params = { height : float; f : unit -> 'a }

val window : ?debug:bool -> io:io -> point -> (t -> 'a) -> 'a * box
val button : cap -> ?id:int -> ?weight:float -> ?style:style -> string -> bool
val checkbox : cap -> ?id:int -> ?weight:float -> ?style:style -> string -> bool
val label : cap -> ?weight:float -> ?style:style -> string -> unit

val text_area :
  cap -> ?weight:float -> ?style:style -> ?width:float -> string -> unit

val slider :
  ?id:int ->
  ?weight:float ->
  ?style:style ->
  ?width:float ->
  cap ->
  min:float ->
  max:float ->
  float

val vertical : cap -> ?weight:float -> ?style:style -> (unit -> 'a) -> 'a
val horizontal : cap -> ?weight:float -> ?style:style -> (unit -> 'a) -> 'a

val vscroll :
  cap -> ?weight:float -> ?style:style -> height:float -> (unit -> 'a) -> 'a

val radio :
  cap ->
  ?id:int ->
  ?weight:float ->
  ?style:style ->
  ('a * string) list ->
  'a option

val text_input :
  cap -> ?id:int -> ?weight:float -> ?style:style -> float -> string

val nest_loc : cap -> (unit -> 'a) -> 'a

module Customize : sig
  module Button = Button
  module Checkbox = Checkbox
  module Horizontal = Horizontal
  module Label = Label
  module Radio = Radio
  module Slider = Slider
  module Text_area = Text_area
  module Text_input = Text_input
  module Vertical = Vertical
  module Widget_builder = Widget_builder
end
