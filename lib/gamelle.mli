type io = Gamelle_backend.io

val run : 'state -> (io:io -> 'state -> 'state) -> unit

include module type of Draw_geometry
module Ui : module type of Ui

module Bitmap : sig
  type t

  val load : string -> t
  val sub : t -> int -> int -> int -> int -> t
end

module Font : sig
  type t

  val default : t
  val default_size : int
  val load : string -> t
  val draw : color:Color.t -> t -> int -> string -> Bitmap.t
end

module Sound : sig
  type sound

  val load : string -> sound
  val play : io:io -> sound -> unit

  type music

  val load_music : string -> music
  val play_music : io:io -> music -> unit
end

module Transform : sig
  type t

  val default : t
  val translate : Vec.t -> t -> t
  val scale : float -> t -> t
  val rotate : float -> t -> t
  val project : t -> Point.t -> Point.t
end

module View : sig
  type 'a scene = io:io -> 'a

  val ( & ) : unit scene -> unit scene -> unit scene
  val drawing_box : Box.t -> io -> io
  val translate : Vec.t -> 'a scene -> 'a scene
  val scale : float -> 'a scene -> 'a scene
  val rotate : float -> 'a scene -> 'a scene
  val clip : box -> 'a scene -> 'a scene
  val unclip : 'a scene -> 'a scene
  val clip_events : bool -> 'a scene -> 'a scene
  val translated : Vec.t -> io -> io
  val scaled : float -> io -> io
  val rotated : float -> io -> io
  val clipped : box -> io -> io
  val unclipped : io -> io
  val clipped_events : bool -> io -> io
end

val clock : unit -> float
val dt : unit -> float
val draw : io:io -> Bitmap.t -> point -> unit
val show_cursor : io:io -> bool -> unit

module Event : sig
  val mouse_pos : io:io -> point
  val wheel_delta : io:io -> float

  type key =
    [ `alt
    | `alt_gr
    | `arrow_down
    | `arrow_left
    | `arrow_right
    | `arrow_up
    | `backspace
    | `click_left
    | `click_right
    | `control_left
    | `control_right
    | `delete
    | `escape
    | `input_char of string
    | `meta
    | `physical_char of char
    | `quit
    | `shift
    | `space
    | `tab
    | `wheel
    | `unknown_key ]

  val is_pressed : io:io -> key -> bool
  val is_up : io:io -> key -> bool
  val is_down : io:io -> key -> bool
end

module Window : sig
  val set_size : io:io -> size -> unit
  val size : io:io -> size
  val box : io:io -> box
end

(* *)

module Shape : module type of Shape

module Physics : sig
  type t
  type kind = Movable | Immovable

  val make :
    ?mass:float ->
    ?inertia:float ->
    ?restitution:float ->
    ?kind:kind ->
    Shape.t ->
    t

  val center : t -> Point.t
  val add_velocity : Vec.t -> t -> t
  val add_rot_velocity : float -> t -> t
  val update : dt:float -> t -> t
  val fix_collisions : t list -> t list
  val draw : io:io -> t -> unit
end
