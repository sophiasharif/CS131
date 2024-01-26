
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

let whileseq s p x = if p x then List.rev (whileseq_helper s p [x]) else []

(* 9 *)

type ('nonterminal, 'terminal) symbol =
  | N of 'nonterminal
  | T of 'terminal

let get_outgoing_edges key l = List.fold_right (fun (k,v) acc -> if k = key then v::acc else acc) l []

let rec is_blind_alley node rules visited = match node with
  | T _ -> false
  | N n ->  if List.mem n visited then true else 
            let new_visited = n::visited in
            let outgoing_edges = get_outgoing_edges n rules in
            List.for_all (fun next_expr -> (* if all expressions are blind alleys, return true*)
              List.exists (fun symbol -> is_blind_alley symbol rules new_visited) next_expr (*if any symbol is a blind alley, then the expression is a blind alley, so return true*)
            ) outgoing_edges

let filter_blind_alleys (root, rules) = (root, List.filter (fun (_, rhs) -> List.for_all (fun symbol -> not (is_blind_alley symbol rules [])) rhs) rules)