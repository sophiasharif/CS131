
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
let rec is_computed_periodic_point eq f p x start = match p with 
| 0 -> (eq) x start
| _ -> is_computed_periodic_point eq f (p-1) (f x) start

let rec computed_periodic_point eq f p x = 
  if is_computed_periodic_point eq f p x x then x
  else computed_periodic_point eq f p (f x)

(* 8 *)
let rec whileseq_helper s p l = match l with
| [] -> []
| x::_ -> let next = s x in 
  if (p next) then whileseq_helper s p (next::l)
  else l

let whileseq s p x = List.rev (whileseq_helper s p [x])

(* 9 *)

(* let rec get_outgoing_edges key l = match l with
| [] -> []
| (k, v)::t -> if key = k 
    then v :: get_outgoing_edges key t
    else get_outgoing_edges key t

let get_outgoing_edges key l = List.map (fun (_, v) -> v) (List.filter (fun (k, _) -> k = key) l) *)

let get_outgoing_edges key l = List.fold_right (fun (k,v) acc -> if k = key then v::acc else acc) l []

type ('nonterminal, 'terminal) symbol =
  | N of 'nonterminal
  | T of 'terminal


let rec is_blind_alley node grammar visited = match node with
  | T _ -> false
  | N n -> if List.mem n visited then true else 
            let new_visited = n::visited in
            let outgoing_edges = get_outgoing_edges n grammar in
            not (List.exists (fun next_expr -> 
              List.exists (fun symbol -> is_blind_alley symbol grammar new_visited) next_expr
            ) outgoing_edges)

(* Test cases
let test_get_outgoing_edges () =
  (* Test data *)
  let edges = [("a", 1); ("b", 2); ("a", 3); ("c", 4); ("a", 5)] in

  (* 1. Basic functionality *)
  assert (get_outgoing_edges "a" edges = [1; 3; 5]);

  (* 2. No matching key *)
  assert (get_outgoing_edges "d" edges = []);

  (* 3. Empty list *)
  assert (get_outgoing_edges "a" [] = []);

  (* 4. Repeated keys *)
  assert (get_outgoing_edges "b" edges = [2]);

  (* If no assertion fails, all tests pass *)
  print_endline "All tests passed."

(* Run the test cases *)
let () = test_get_outgoing_edges () *)


(* Test Cases *)

type awksub_nonterminals =
| Expr | Num

let test_is_blind_alley () =
  (* Test Grammars *)
  let grammar1 = [
    Expr, [T"("; N Num; T")"];
    Num, [T"0"];
  ] in
  let grammar2 = [
    Expr, [N Expr];
  ] in
  (* Test 1: No cycle *)
  assert (is_blind_alley (N Expr) grammar1 [] = false);
  assert (is_blind_alley (N Expr) grammar2 [] = true);

  (* If no assertion fails, all tests pass *)
  print_endline "All tests passed."

(* Run the test cases *)
let () = test_is_blind_alley ()









(* TESTS *)
let computed_periodic_point_test0 =
  computed_periodic_point (=) (fun x -> x / 2) 0 (-1) = -1
let computed_periodic_point_test1 =
  computed_periodic_point (=) (fun x -> x *. x -. 1.) 2 0.5 = -1.
let whileseq_test = whileseq ((+) 3) ((>) 10) 0 = [0; 3; 6; 9]
  
let () = print_endline (string_of_bool computed_periodic_point_test0)
let () = print_endline (string_of_bool computed_periodic_point_test1)
let () = print_endline (string_of_bool whileseq_test)

let computed_fixed_point_test0 =
  computed_fixed_point (=) (fun x -> x / 2) 1000000000 = 0
let () = print_endline (string_of_bool computed_fixed_point_test0)
let set_all_union_test0 =
  equal_sets (set_all_union []) []
let () = print_endline (string_of_bool set_all_union_test0)
