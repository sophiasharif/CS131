
type ('nonterminal, 'terminal) symbol =
  | N of 'nonterminal
  | T of 'terminal
let accept_all string = Some string
let accept_empty_suffix = function
   | _::_ -> None
   | x -> Some x

(* An example grammar for a small subset of Awk.
   This grammar is not the same as Homework 1; it is
   instead the grammar shown above.  *)

type awksub_nonterminals =
  | Expr | Term | Lvalue | Incrop | Binop | Num

let awksub_rules =
  [Expr, [N Term; N Binop; N Expr];
    Expr, [N Term];
    Term, [N Num];
    Term, [N Lvalue];
    Term, [N Incrop; N Lvalue];
    Term, [N Lvalue; N Incrop];
    Term, [T"("; N Expr; T")"];
    Lvalue, [T"$"; N Expr];
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
 
let awksub_grammar = Expr, awksub_rules

 
let awkish_grammar =
  (Expr,
   function
     | Expr ->
         [[N Term; N Binop; N Expr];
          [N Term]]
     | Term ->
	 [[N Num];
	  [N Lvalue];
	  [N Incrop; N Lvalue];
	  [N Lvalue; N Incrop];
	  [T"("; N Expr; T")"]]
     | Lvalue ->
	 [[T"$"; N Expr]]
     | Incrop ->
	 [[T"++"];
	  [T"--"]]
     | Binop ->
	 [[T"+"];
	  [T"-"]]
     | Num ->
	 [[T"0"]; [T"1"]; [T"2"]; [T"3"]; [T"4"];
	  [T"5"]; [T"6"]; [T"7"]; [T"8"]; [T"9"]])

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

let match_or matcher1 matcher2 frag = let try_first = matcher1 frag 
  in match try_first with 
    | None -> matcher2 frag
    | _ -> try_first

let match_and matcher1 matcher2 frag = let try_first = matcher1 frag
  in match try_first with
    | None -> None
    | Some x -> matcher2 x

let test = function
     | Expr ->
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
	  [T"5"]; [T"6"]; [T"7"]; [T"8"]; [T"9"]]

(* let r, test = awkish_grammar *)

let rec match_nt f nt = 
let rec match_all = function
  | (T h)::t -> match_and (match_term h) (match_all t)
  | (N h)::t -> match_and (match_nt f h) (match_all t)
  | [] -> (fun frag -> Some frag)
and match_any = function
  | h::t -> match_or (match_all h) (match_any t)
  | [] -> (fun _ -> None) 
in match_any (f nt)

let expr_matcher = match_nt test Expr