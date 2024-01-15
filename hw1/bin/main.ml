let rec subset a b = match a with
| [] -> true
| h::t -> List.mem h b && subset t b


let equal_sets a b = (subset a b) && (subset b a)


let rec set_union a b = match a with
| [] -> b
| h::t -> set_union t (h::b)


let rec set_all_union a = match a with
| [] -> []
| h::t -> set_union h (set_all_union t)


(* 
In OCaml, a list of type 'T list' cannot contain elements of type 'T list'; it can only contain elements of type 'T'. 
Thus, the self_member is not possible to implement in OCaml.
*)


let rec computed_fixed_point eq f x = if (eq) x (f x) then x else computed_fixed_point eq f (f x)




let computed_fixed_point_test0 =
  computed_fixed_point (=) (fun x -> x / 2) 1000000000 = 0
let () = print_endline (string_of_bool computed_fixed_point_test0)
let set_all_union_test0 =
  equal_sets (set_all_union []) []
let () = print_endline (string_of_bool set_all_union_test0)
