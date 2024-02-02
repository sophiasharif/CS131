type ('nonterminal, 'terminal) symbol =
  | N of 'nonterminal
  | T of 'terminal

type ('nonterminal, 'terminal) parse_tree =
  | Node of 'nonterminal * ('nonterminal, 'terminal) parse_tree list
  | Leaf of 'terminal

(* 1 - convert hw1 style grammar to hw2 style grammar *)

let convert_grammar (root, rules) = 
  let get_rhs symbol = List.fold_right (fun (k,v) acc -> if k = symbol then v::acc else acc) rules [] 
    in (root, get_rhs)

(* 2 - parse tree leaves left to right *)

let parse_tree_leaves tree = let rec helper acc = function
  | Leaf l -> l::acc
  | Node (_, subtrees) -> List.fold_left helper acc subtrees  (* call helper (acc, tree) on all items in the subtree list and add them to accumulator *)
    in List.rev (helper [] tree)

(* 3 -- matcher generator *)

let make_matcher (root, nt_to_rules) =
  let rec get_rule rule_list acceptor frag = match rule_list with 
      | [] -> None                  (* if rule list is empty, we weren't able to match anything*)
      | rule::remaining_rules -> (match (try_rule rule acceptor frag) with 
          | None -> get_rule remaining_rules acceptor frag  (* if rule wasn't a match, try another rule*)
          | remaining_frag -> remaining_frag )              (* if rule successfully matched, return suffix*)
  and try_rule rule acceptor frag = match rule, frag with
      | [], _ -> acceptor frag      (* when nothing left in rule, attempt to accept the current fragment *)
      | _, [] -> None               (* when fragment is empty but rule is not, no match is possible *)
      | (T term)::remaining_rule, first::remaining_frag ->   (* if we match a terminal, try the rest of the rule on the rest of the frag*) 
          if term = first then (try_rule remaining_rule acceptor remaining_frag) else None
      | (N nt)::tl, _ ->            (* if nonterminal, expand it recursively *)
          get_rule (nt_to_rules nt) (try_rule tl acceptor) frag   (* pass a new acceptor to make sure the rest of the rule matches *)   
  in let mm acceptor fragment = try_rule [N root] acceptor fragment 
    in mm 


let make_parser gram frag = gram; frag; None;
