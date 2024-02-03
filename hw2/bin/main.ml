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

(* 4 -- parser *)

(* step 1: adapt code from #3 to create a trace of how the expression was matched *)
let get_trace root nt_to_rules frag = 
  let rec get_rule rule_list acceptor frag = match rule_list with 
    | [] -> None                 
    | rule::remaining_rules -> (match (try_rule rule acceptor frag) with 
        | None -> get_rule remaining_rules acceptor frag 
        | Some remaining_frag -> Some (rule::remaining_frag) )  (* only difference: if rule successfully matched, add it to trace *)
  and try_rule rule acceptor frag = match rule, frag with
    | [], _ -> acceptor frag      
    | _, [] -> None               
    | (T term)::remaining_rule, first::remaining_frag ->  
        if term = first then (try_rule remaining_rule acceptor remaining_frag) else None
    | (N nt)::tl, _ ->            
        get_rule (nt_to_rules nt) (try_rule tl acceptor) frag 
  in get_rule [[N root]] (function [] -> Some [] | _ -> None) frag  (* acceptor is accept_empty *)

(*  step 2: parse the trace *)
let create_tree trace  = 
  let rec parse_rule rule trace = match rule with (* returns (tree, rest of trace) *)
    | [] -> ([], trace)     (* return empty tree and trace if done with rule*)
    | sym::remaining_rule -> (match sym with 
        | T term -> (match parse_rule remaining_rule trace with (* if terminal, append leaf to list*)
            | (tree, remaining_trace) -> ((Leaf term)::tree, remaining_trace)) 
        | N nterm -> ( match parse_nt trace with (* if nonterminal, create a tree and then append *)
            | (l1, tr1) -> (match parse_rule remaining_rule tr1 with
                | (tree, remaining_trace) -> ((Node (nterm, l1))::tree, remaining_trace))))        
  and parse_nt = function [] -> ([], []) | hd::tl -> parse_rule hd tl 
  in match trace with 
    | None | Some [] -> None
    | Some (rule::trace) -> let tree, _ = parse_rule rule trace in 
        if tree = [] then None else Some(List.hd tree) (* throw away empty trace and get node out of list*)

(* step 3: package into a function that can accept a fragment *)
let make_parser (root, nt_to_rules) = (fun frag -> create_tree (get_trace root nt_to_rules frag))