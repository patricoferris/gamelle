open Brr
open Brr_canvas
open Gamelle_common
module Color = Color
module Bitmap = Bitmap
module Font = Font_
module Sound = Sound
module Transform = Gamelle_common.Transform
include Draw

(* type ctx = C.t *)

let prev_now = ref 0.0
let now = ref 0.0
let clock () = !now
let dt () = !now -. !prev_now

module Window = struct
  open Globals

  let size () =
    let canvas = Option.get !global_canvas in
    let w = Canvas.w canvas in
    let h = Canvas.h canvas in
    Size2.v (float w) (float h)

  let set_size s =
    let w = s |> Size2.w |> int_of_float and h = s |> Size2.h |> int_of_float in
    let canvas = Option.get !global_canvas in
    Canvas.set_w canvas w;
    Canvas.set_h canvas h

  let box () = Box2.v V2.zero (size ())
end

module View = struct
  include Gamelle_common.Io
end

let run state update =
  let canvas =
    match Document.find_el_by_id G.document (Jstr.of_string "target") with
    | None -> failwith "missing 'target' canvas"
    | Some elt ->
        Events_js.attach ~target:(El.as_target elt);
        Canvas.of_el elt
  in
  let open Globals in
  global_canvas := Some canvas;

  Canvas.set_w canvas (640 * 2);
  Canvas.set_h canvas (480 * 2);

  let ctx = C.get_context canvas in
  global_ctx := Some ctx;

  let rec animate state =
    let _ = G.request_animation_frame (loop state) in
    ()
  and loop state elapsed =
    let open Events_backend in
    prev_now := !now;
    now := elapsed /. 1000.0;
    Events_js.new_frame ();
    let io = { (Io.make ()) with event = !Events_js.current } in
    fill_rect ~io ~color:Color.black (Window.box ());
    let state = update ~io state in
    Events_js.current := reset_wheel !Events_js.current;
    animate state
  in
  animate state
