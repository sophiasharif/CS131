
(* 1 *)
let rec subset a b = match a with
| [] -> true
| h::t -> List.mem h b && subset t b

(* 2 *)
let equal_sets a b = (subset a b) && (subset b a)

(* 3 *)
let rec set_union a b = match a with
| [] -> b
| h::t -> set_union t (h::b)

(* 4 *)
let rec set_all_union a = match a with
| [] -> []
| h::t -> set_union h (set_all_union t)


(* 
5
In OCaml, a list of type 'T list' cannot contain elements of type 'T list'; it can only contain elements of type 'T'. 
Thus, the self_member is not possible to implement in OCaml.
*)

(* 6 *)
let rec computed_fixed_point eq f x = if (eq) x (f x) then x else computed_fixed_point eq f (f x)

(* 7 *)
(*   computed_periodic_point (=) x^2-1 2 0.5 = -1. *)
let rec is_computed_periodic_point eq f p x start = match p with 
| 0 -> (eq) x start
| _ -> is_computed_periodic_point eq f (p-1) (f x) start

let rec computed_periodic_point eq f p x = 
  if is_computed_periodic_point eq f p x x then x
  else computed_periodic_point eq f p (f x)

let computed_periodic_point_test0 =
  computed_periodic_point (=) (fun x -> x / 2) 0 (-1) = -1
let computed_periodic_point_test1 =
  computed_periodic_point (=) (fun x -> x *. x -. 1.) 2 0.5 = -1.
  
let () = print_endline (string_of_bool computed_periodic_point_test0)
let () = print_endline (string_of_bool computed_periodic_point_test1)



let computed_fixed_point_test0 =
  computed_fixed_point (=) (fun x -> x / 2) 1000000000 = 0
let () = print_endline (string_of_bool computed_fixed_point_test0)
let set_all_union_test0 =
  equal_sets (set_all_union []) []
let () = print_endline (string_of_bool set_all_union_test0)
