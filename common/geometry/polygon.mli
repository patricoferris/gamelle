type t

val v : Point.t list -> t
val to_list : t -> Point.t list
val center : t -> Point.t
val signed_area : t -> float
val segments : t -> Segment.t list
val translate : t -> Vec.t -> t
val map_points : (Point.t -> Point.t) -> t -> t
