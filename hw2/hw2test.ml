type english_nontermials =
   Sentence | Phrase | Conjunction | Noun | Verb | Adjective | Pronoun 

let english_grammar =
  (Sentence,
   function
     | Sentence ->
         [[N Adjective; N Noun; N Verb; N Pronoun];
          [N Phrase; N Conjunction; N Sentence];
          [N Phrase; N Conjunction; N Sentence; N Conjunction; N Phrase]]
     | Phrase ->
	 [[N Noun; N Verb];
   [N Verb; N Noun];
    [N Pronoun; N Verb];
    [N Pronoun; N Verb; N Noun;];]
     | Conjunction -> [[T "and"]; [T "or"]]
     | Noun -> [[T"DOG"]; [T"cat"]; [T"ball"]; [T"elevator"]]
     | Verb -> [[T"frolicks"]; [T"gyrate"]; [T"spellbinds"]; [T"lick"]]
     | Adjective -> [[T"delicious"]; [T"stinky"]; [T"wishy-washy"]];
     | Pronoun ->  [[T"I"]; [T"You"]; [T"She"]]
     )

(* matcher test *)

let accept_contains_DOG frag = if List.mem "DOG" frag then Some frag else None
let make_matcher_test =
  ((make_matcher english_grammar accept_contains_DOG ["She"; "gyrate"; "and"; "wishy-washy"; "elevator"; "spellbinds"; "You"; "and"; "DOG"; "frolicks"]) = Some["and"; "DOG"; "frolicks"])

(* parser test *)
let frag = ["She"; "gyrate"; "and"; "stinky"; "DOG"; "lick"; "You"] 

let make_parser_test = match (make_parser english_grammar frag) with
  | None -> false
  | Some tree -> parse_tree_leaves tree = frag
  

