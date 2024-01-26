
(* TESTS *)

(* 1 subset *)
let subset_test0 = subset [] []
let subset_test1 = subset [1;1;1;1] [2;1]
let subset_test2 = not (subset [1;3;7] [])

(* 2 equal_sets *)
let equal_sets_test0 = equal_sets [1;2;3] [3;3;2;1]
let equal_sets_test1 = not (equal_sets [-1;-2;-5] [3;1;3])
let equal_sets_test2 = equal_sets [] []


(* 3 set_union *)
let set_union_test0 = equal_sets (set_union [] []) []
let set_union_test1 = equal_sets (set_union [4;4;-1] [1]) [4;-1;1;-1]



(* 4 set_all_union *)
let set_all_union_test0 = not (equal_sets (set_all_union [[2;2;2]; [4;4]; [2;-1]]) [4;2;-1;-1;0])
let set_all_union_test1 =
  equal_sets (set_all_union [[2;2;2]; [4;4]; [0;2;-1]]) [4;2;-1;-1;0]

  (* 6 computed_fixed_point *)
let computed_fixed_point_test0 =
  computed_fixed_point (=) (fun x -> x *. x) 0.5 = 0.0


(* 7 computed_periodic_point *)
let computed_periodic_point_test0 =
  computed_periodic_point (=) (fun x -> x / 2) 0 (-1) = -1


(* 8 whileseq *)
let whileseq_test0 = whileseq ((+) 1) ((<) 5) (2)  = []
let whileseq_test1 = whileseq ((+) 1) ((>) 5) (2)  = [2;3;4]

(* 9 filter_blind_alleys *)
type awksub_nonterminals = Expr | Num
let grammar1 = [ Expr, [T"("; N Num; T")"]; Num, [T"0"];]
let grammar2 = [ Expr, [N Expr];]
let grammar3 = [ Expr, [T"("; N Num; T")"]; Num, [T"0"; N Num]; Num, [T"1";] ]
let my_filter_blind_alleys_test0 = filter_blind_alleys (Expr, grammar1) = (Expr, grammar1)
let my_filter_blind_alleys_test1 = filter_blind_alleys (Expr, grammar2) = (Expr, [])
let my_filter_blind_alleys_test2 = filter_blind_alleys (Expr, grammar3) = (Expr, grammar3);;

(* assert (subset_test0 && subset_test1 && subset_test2);;
assert (equal_sets_test0 && equal_sets_test1 && equal_sets_test2);;
assert (set_union_test0 && set_union_test1);;
assert (set_all_union_test0 && set_all_union_test1);;  
assert computed_fixed_point_test0;;
assert computed_periodic_point_test0;;
assert(whileseq_test0 && whileseq_test1);;
assert (my_filter_blind_alleys_test0 && my_filter_blind_alleys_test1 && my_filter_blind_alleys_test2);; *)


