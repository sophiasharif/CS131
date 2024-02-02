
type ('nonterminal, 'terminal) symbol =
  | N of 'nonterminal
  | T of 'terminal
(* let accept_all string = Some string
let accept_empty_suffix = function
   | _::_ -> None
   | x -> Some x *)

(* An example grammar for a small subset of Awk.
   This grammar is not the same as Homework 1; it is
   instead the grammar shown above.  *)
(* 
type awksub_nonterminals =
  | rule | Term | Lvalue | Incrop | Binop | Num

let awksub_rules =
  [rule, [N Term; N Binop; N rule];
    rule, [N Term];
    Term, [N Num];
    Term, [N Lvalue];
    Term, [N Incrop; N Lvalue];
    Term, [N Lvalue; N Incrop];
    Term, [T"("; N rule; T")"];
    Lvalue, [T"$"; N rule];
    Incrop, [T"++"];
    Incrop, [T"--"];
    Binop, [T"+"];
    Binop, [T"-"];
    Num, [T"0"];
    Num, [T"1"];
    Num, [T"2"];
    Num, [T"3"];
    Num, [T"4"];
    Num, [T"5"];
    Num, [T"6"];
    Num, [T"7"];
    Num, [T"8"];
    Num, [T"9"]]
 
let awksub_grammar = rule, awksub_rules

 
let awkish_grammar =
  (rule,
   function
     | rule ->
         [[N Term; N Binop; N rule];
          [N Term]]
     | Term ->
	 [[N Num];
	  [N Lvalue];
	  [N Incrop; N Lvalue];
	  [N Lvalue; N Incrop];
	  [T"("; N rule; T")"]]
     | Lvalue ->
	 [[T"$"; N rule]]
     | Incrop ->
	 [[T"++"];
	  [T"--"]]
     | Binop ->
	 [[T"+"];
	  [T"-"]]
     | Num ->
	 [[T"0"]; [T"1"]; [T"2"]; [T"3"]; [T"4"];
	  [T"5"]; [T"6"]; [T"7"]; [T"8"]; [T"9"]]) *)

(* 1 - convert hw1 style grammar to hw2 style grammar *)
let convert_grammar (root, rules) = 
  let get_rhs symbol = List.fold_right (fun (k,v) acc -> if k = symbol then v::acc else acc) rules [] 
    in (root, get_rhs)

(* 2 - parse tree leaves left to right *)

type ('nonterminal, 'terminal) parse_tree =
  | Node of 'nonterminal * ('nonterminal, 'terminal) parse_tree list
  | Leaf of 'terminal

let parse_tree_leaves tree = let rec helper acc = function
  | Leaf l -> l::acc
  | Node (_, subtrees) -> List.fold_left helper acc subtrees  (* call helper (acc, tree) on all items in the subtree list and add them to accumulator *)
    in List.rev (helper [] tree)

(* 3 -- matcher generator *)

let match_term t frag = match frag with
    | head::tail when head = t -> Some tail
    | _ -> None

(* let match_or matcher1 matcher2 frag = let try_first = matcher1 frag 
  in match try_first with 
    | None -> matcher2 frag
    | _ -> try_first

let match_and matcher1 matcher2 frag = let try_first = matcher1 frag
  in match try_first with
    | None -> None
    | Some x -> matcher2 x *)

(* let test = function
     | rule ->
         [[N Num; N Binop; N Num];
          [N Term]]
     | Term ->
	 [[T"("; N Num; T")"]]
     | Lvalue ->
	 [[T"$"; N Num]]
     | Incrop ->
	 [[T"++"];
	  [T"--"]]
     | Binop ->
	 [[T"+"];
	  [T"-"]]
     | Num ->
	 [[T"0"]; [T"1"]; [T"2"]; [T"3"]; [T"4"];
	  [T"5"]; [T"6"]; [T"7"]; [T"8"]; [T"9"]] *)

(* let r, test = awkish_grammar *)

(* let rec match_nt f nt = 
let rec match_all = function
  | (T h)::t -> match_and (match_term h) (match_all t)
  | (N h)::t -> match_and (match_nt f h) (match_all t)
  | [] -> (fun frag -> Some frag)
and match_any = function
  | h::t -> match_or (match_all h) (match_any t)
  | [] -> (fun _ -> None) 
in match_any (f nt) *)

let print_suffix suffix_option =
  match suffix_option with
  | Some suffix ->
    let suffix_string = String.concat "; " suffix in
    Printf.printf "Current suffix: Some [%s]\n" suffix_string
  | None ->
    Printf.printf "Current suffix: None\n";;
  
let print_frag frag =
    let suffix_string = String.concat "; " frag in
    Printf.printf "Current frag: Some [%s]\n" suffix_string

let accept_all string = Some string

let accept_empty_suffix = function
  | _::_ -> None
  | x -> Some x

let accept_starts_with_a frag = match frag with
  | "a"::_ -> Some frag
  | _ -> None

let contains_1 frag = if List.mem "1" frag then Some frag else None

(* let r, f = awkish_grammar;; *)

(* let match_nt frag f nt = 
let rec match_all frag sym_list = match sym_list with
  | (T h)::t -> let remaining_frag = match_term h frag in 
    (match remaining_frag with
      | None -> None
      | Some x -> match_all x t)
  | (N h)::t -> let remaining_frag = match_any frag (f h) false in
    (match remaining_frag with
    | None -> None
    | Some x -> match_all x t)
  | [] -> Some frag 
and match_any frag rule_list is_root_level = match rule_list with
  | h::t -> let remaining_frag = match_all frag h in
    (match remaining_frag with
      | None -> match_any frag t is_root_level
      | _ ->  print_frag frag; if is_root_level then print_endline("is this the place?"); remaining_frag)
  | [] -> None
in match_any frag (f nt) true *)

(* let make_matcher (root, nt_to_rules) =
  let rec get_rule rule_list acceptor frag =
      match rule_list with 
          | [] -> None
          | rule::remaining_rules -> (match (try_rule rule acceptor frag) with
            | None -> get_rule remaining_rules acceptor frag
            | remaining_frag -> remaining_frag )
  and try_rule rule acceptor frag =
      if rule = [] then acceptor frag
      else match frag with 
          | [] -> None
          | first::rest -> ( match rule with
              | [] -> None
              | (T hd)::tl -> if hd = first then try_rule tl acceptor rest else None
              | (N hd)::tl -> get_rule (nt_to_rules hd) (try_rule tl acceptor) frag )
  in let mm acceptor fragment = try_rule [N root] acceptor fragment 
    in mm  *)

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


(* let match_nt frag f nt accept = 
  let rec match_all frag sym_list = match sym_list with
    | (T h)::t -> let remaining_frag = match_term h frag in 
      (match remaining_frag with
        | None -> None
        | Some x -> match_all x t)
    | (N h)::t -> let remaining_frag = match_any frag (f h) false in
      (match remaining_frag with
      | None -> None
      | Some x -> match_all x t)
    | [] -> Some frag 
  and match_any frag rule_list is_root_level = match rule_list with
    | h::t -> let remaining_frag = match_all frag h in
      (match remaining_frag with
        | None -> match_any frag t is_root_level
        | Some x ->  if is_root_level then (accept x) else remaining_frag)
    | [] -> None
  in match_any frag (f nt) true *)

(* let match_nt frag f nt accept = 
  let rec match_all frag sym_list = match sym_list with
    | (T h)::t -> let remaining_frag = match_term h frag in 
      (match remaining_frag with
        | None -> None
        | Some x -> match_all x t)
    | (N h)::t -> let remaining_frag = match_any frag (f h) false in
      (match remaining_frag with
      | None -> None
      | Some x -> match_all x t)
    | [] -> Some frag 
  and match_any frag rule_list is_root_level = match rule_list with
    | h::t -> let remaining_frag = match_all frag h in
      (match remaining_frag with
        | None -> match_any frag t is_root_level
        | Some x ->  if is_root_level then (accept x) else remaining_frag)
  | [] -> None
in match_any frag (f nt) true *)

(* let match_nt frag f nt accept = 
  let rec match_all sym_list accept frag = match sym_list with
    | (T h)::t -> let remaining_frag = match_term h frag in 
      (match remaining_frag with
        | None -> None
        | Some x -> match_all t accept x)
    | (N h)::t -> let remaining_frag = match_any frag (f h) (match_all t accept) in
      (match remaining_frag with
      | None -> None
      | Some x -> match_all t accept x)
    | [] -> Some frag 
  and match_any frag rule_list accept = match rule_list with
    | h::t -> let remaining_frag = match_all h accept frag in
      (match remaining_frag with
        | None -> match_any frag t accept
        | Some x ->  accept x)
  | [] -> None
in match_any frag (f nt) accept *)


(* Updated make_matcher to work with the adjusted match_nt *)
(* let make_matcher gram accept frag = 
  let root, gramf = gram in
  match_nt frag gramf root accept  *)

(* 
let parse_leaf t frag = match frag with
  | head::tail when head = t -> Some tail
  | _ -> None

let parse_nt frag f nt = 
let rec match_all frag sym_list = match sym_list with
  | (T term)::sym_list_tail -> (match (match_term term frag) with
      | None -> None
      | Some remaining_frag -> match_all remaining_frag sym_list_tail)
  | (N non_term)::sym_list_tail -> (match (match_any frag (f non_term)) with
    | None -> None
    | Some remaining_frag -> match_all remaining_frag sym_list_tail)
  | [] -> Some frag 
and match_any frag rule_list  = match rule_list with
  | rule::rule_list_tail -> let remaining_frag = match_all frag rule in
    (match remaining_frag with
      | None -> match_any frag rule_list_tail
      | _ -> remaining_frag)
  | [] -> None
in match_any frag (f nt) *)


let make_parser gram frag = gram; frag; None;


(* let make_matcher gram accept frag = let root, gramf = convert_grammar gram in
  let suffix = match_nt frag gramf root in 
    match suffix with
      | None -> None
      | Some x -> accept x *)
(* 
let x = make_matcher awksub_grammar accept_empty_suffix ["1"; "+"; "1"] *)
(* 
let test0 =
  ((make_matcher awkish_grammar accept_all ["ouch"]) = None)

let test1 =
  ((make_matcher awkish_grammar accept_all ["9"])
   = Some [])

let test2 =
  ((make_matcher awkish_grammar accept_all ["9"; "+"; "$"; "1"; "+"])
   = Some ["+"])

let test3 =
  ((make_matcher awkish_grammar accept_empty_suffix ["9"; "+"; "$"; "1"; "+"])
   = None)

(* This one might take a bit longer.... *)
let test4 =
 ((make_matcher awkish_grammar accept_all
     ["("; "$"; "8"; ")"; "-"; "$"; "++"; "$"; "--"; "$"; "9"; "+";
      "("; "$"; "++"; "$"; "2"; "+"; "("; "8"; ")"; "-"; "9"; ")";
      "-"; "("; "$"; "$"; "$"; "$"; "$"; "++"; "$"; "$"; "5"; "++";
      "++"; "--"; ")"; "-"; "++"; "$"; "$"; "("; "$"; "8"; "++"; ")";
      "++"; "+"; "0"])
  = Some []) *)