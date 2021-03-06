type markdownClassfication =
  | Heading1 of string
  | Heading2 of string
  | Heading3 of string
  | Heading4 of string
  | Heading5 of string
  | Heading6 of string
  | Paragraph of string
  | HorizontalLine of string
  | UnOrderedListItem of string
  | OrderedListItem of string
  | Code of string
  | BlockquoteItem of string
  | Blockquote of (string list)
  | UnOrderedList of (string list)
  | OrderedList of (string list)
  | Unknown of string
  | Empty


let h1_recipe = Str.regexp "^#"
let h2_recipe = Str.regexp "^##"
let h3_recipe = Str.regexp "^###"
let h4_recipe = Str.regexp "^####"
let h5_recipe = Str.regexp "^#####"
let h6_recipe = Str.regexp "^######"

let unordered_list_recipe = Str.regexp "\\*\|\\-\|\\+"
let ordered_list_recipe = Str.regexp "[0-9]\\."

let code_recipe = Str.regexp "\\`"

let blockquote_recipe = Str.regexp "\\>"

let horizontal_line_recipe = Str.regexp "\\(\\_\\_\\_\\)+\|\\(\\-\\-\\-\\)+\|\\(\\*\\*\\*\\)+"

let get_line ic =
  try
    Some (input_line ic)
  with
  | End_of_file -> None

(* returns all lines from the file as a list of strings, arranged in the reverse order *)
let read_all filename =
  let ic = open_in filename in

  let rec read acc =
    match get_line ic with
    | Some line -> read (line :: acc)
    | None ->
        close_in ic; (* close input channel *)
        acc (* return accumulator *)
  in
  read []


(* Test Check for first character of a line to see if it is a regular line or not*)
let check_tag line_string =
  if String.length line_string = 0 then
    print_string "No character on this line\n"
    (* Printf.printf "%s No character on this line\n" line_string *)
  else
    let first_char = String.get line_string 0 in
    match first_char with
    | '#' -> Printf.printf "%s - Yes it start #\n" line_string
    | '_' -> Printf.printf "%s - Yes it start _\n" line_string
    | '*' -> Printf.printf "%s - Yes it start *\n" line_string
    | _ -> Printf.printf "%s - Does not start with any identifies. Regular line\n" line_string


(* If a the beginning of a line is classified as a header.
This function checks what level of header it is*)
let check_heading_level line_string =
  if Str.string_match h6_recipe line_string 0 then
      Heading6 line_string
  else
    if Str.string_match h5_recipe line_string 0 then
        Heading5 line_string
    else
      if Str.string_match h4_recipe line_string 0 then
          Heading4 line_string
      else
        if Str.string_match h3_recipe line_string 0 then
            Heading3 line_string
        else
          if Str.string_match h2_recipe line_string 0 then
              Heading2 line_string
          else
            if Str.string_match h1_recipe line_string 0 then
                Heading1 line_string
            else
              Unknown line_string


let check_begining_whitespace line_string =
  if Str.string_match unordered_list_recipe line_string 1 then
    UnOrderedListItem line_string
  else if Str.string_match ordered_list_recipe line_string 1 then
      OrderedListItem line_string
  else if Str.string_match blockquote_recipe line_string 1 then
      BlockquoteItem line_string
  else
    Unknown line_string


let check_other_options line_string =
  if Str.string_match horizontal_line_recipe line_string  0 then
    HorizontalLine line_string
  else if Str.string_match code_recipe line_string 0 then
    Code line_string
  else
    Paragraph line_string


(* Function check first char of line to begin classfication *)
let map_tag line_string =
  if String.length line_string = 0 then
    (* print_string "No character on this line\n" *)
    Empty
    (* Printf.printf "%s No character on this line\n" line_string *)
  else
    let first_char = String.get line_string 0 in
    match first_char with
    | '#' -> check_heading_level line_string
    | '>' -> BlockquoteItem line_string
    | ' ' -> check_begining_whitespace line_string
    | _ -> check_other_options line_string


(* Helper Function to print out what the lines are classified as *)
let print_map_list classification_string =
  match classification_string with
  | Heading1 x -> Printf.printf "%s - Heading 1\n" x
  | Heading2 x -> Printf.printf "%s - Heading 2\n" x
  | Heading3 x -> Printf.printf "%s - Heading 3\n" x
  | Heading4 x -> Printf.printf "%s - Heading 4\n" x
  | Heading5 x -> Printf.printf "%s - Heading 5\n" x
  | Heading6 x -> Printf.printf "%s - Heading 6\n" x
  | Paragraph x -> Printf.printf "%s - Paragraph\n" x
  | HorizontalLine x -> Printf.printf "%s - Horizontal Line\n" x
  | Unknown x -> Printf.printf "%s - Unknown\n" x
  | Code x -> Printf.printf "%s - Code\n" x
  | UnOrderedListItem x -> Printf.printf "%s - Unordered List Item\n" x
  | OrderedListItem x -> Printf.printf "%s - Ordered List Item\n" x
  | BlockquoteItem x -> Printf.printf "%s - Blockquote Item\n" x
  | UnOrderedList x -> Printf.printf "- Unordered List\n"
  | OrderedList x -> Printf.printf " - Ordered List\n"
  | Blockquote x -> Printf.printf " - Blockquote\n"
  | Empty -> Printf.printf "Empty line\n"


(* Fucntions to converts Header line to proper html string *)
let convert_h1 line_string =
  let html_string = Str.global_replace h1_recipe "<h1>" line_string in
  html_string ^ "</h1>\n"

let convert_h2 line_string =
  let html_string = Str.global_replace h2_recipe "<h2>" line_string in
  html_string ^ " </h2>\n"

let convert_h3 line_string =
  let html_string = Str.global_replace h3_recipe "<h3>" line_string in
  html_string ^ " </h3>\n"

let convert_h4 line_string =
  let html_string = Str.global_replace h4_recipe "<h4>" line_string in
  html_string ^ " </h4>\n"

let convert_h5 line_string =
  let html_string = Str.global_replace h5_recipe "<h5>" line_string in
  html_string ^ " </h5>\n"

let convert_h6 line_string =
  let html_string = Str.global_replace h6_recipe "<h6>" line_string in
  html_string ^ " </h6>\n"

let convert_paragraph line_string =
  let html_string = "<p> " ^ line_string ^ " </p>\n" in html_string

let convert_unordered_list_item line_string =
  let html_string = Str.global_replace unordered_list_recipe "<li>" line_string in
  html_string ^ " </li>\n"

let convert_ordered_list_item line_string =
  let html_string = Str.global_replace ordered_list_recipe "<li>" line_string in
  html_string ^ " </li>\n"

let convert_code_string line_string =
  let html_string = Str.replace_first code_recipe "<code>" line_string in
  let final_string = Str.replace_first code_recipe "</code>" html_string
  in final_string

let convert_horizontal line_string =
  "\n<hr>\n"


(* Functions for group items *)
(* ------------------ *)
(* ------------------ *)

let remove_blockquote_symbol line_string =
  let html_string = Str.global_replace blockquote_recipe "" line_string in
  html_string

(* Function converts Blockquote string list into a single string *)
let rec create_blockquote_string final_string string_list =
  match string_list with
  | (hd::tl) -> create_blockquote_string (final_string ^"\n" ^ "<p>" ^ hd ^ "</p>") tl
  | [hd] -> (final_string ^"\n"^ "<p>" ^ hd ^ "</p>")
  | [] -> final_string

(* Function converts Blockquote classification type into html   *)
let convert_blockquote string_list =
  Printf.printf "%i" (List.length string_list);
  let remove_symbols_list = List.map remove_blockquote_symbol string_list in
  let reverse_list = List.rev remove_symbols_list in
  List.iter print_string reverse_list;
  let blockquote_string = create_blockquote_string "" reverse_list in
  "<blockquote>" ^ blockquote_string ^ "\n</blockquote>"

(* Function that goes through list to group together Blockquote Items into One Blockquote *)
let rec group_blockquote_items blockquote_object start_quote classification_list =
  match blockquote_object with
  | Blockquote x1 ->
    match classification_list with
    | (hd::tl) ->
      match hd with
      | BlockquoteItem x2 ->
        group_blockquote_items (Blockquote (start_quote::x1)) x2 tl
      | _ -> (Blockquote (start_quote::x1))::hd::classification_list
    | _ -> classification_list

let remove_unordered_list_symbol line_string =
  convert_unordered_list_item line_string

(* Function converts UnOrderedList string list into a single string *)
let rec create_unordered_list_string final_string string_list =
  match string_list with
  | (hd::tl) -> create_unordered_list_string (final_string ^ hd ) tl
  | [hd] -> (final_string ^ hd )
  | [] -> final_string

(* Function converts UnOrderedList classification type into html   *)
let convert_unordered_list string_list =
  Printf.printf "%i" (List.length string_list);
  let remove_symbols_list = List.map remove_unordered_list_symbol string_list in
  let reverse_list = List.rev remove_symbols_list in
  List.iter print_string reverse_list;
  let unordered_string = create_unordered_list_string "" reverse_list in
  "<ul>\n" ^ unordered_string ^ "</ul>"

(* Function that goes through list to group together UnOrderedList Items into One UnOrderedList type *)
let rec group_unordered_items unordered_item_object start_item classification_list =
  match unordered_item_object with
  | UnOrderedList x1 ->
    match classification_list with
    | (hd::tl) ->
      match hd with
      | UnOrderedListItem x2 ->
        group_unordered_items (UnOrderedList (start_item::x1)) x2 tl
      | _ -> (UnOrderedList (start_item::x1))::hd::classification_list
    | _ -> classification_list

let remove_ordered_list_symbol line_string =
  convert_ordered_list_item line_string

(* Function converts OrderedList string list into a single string *)
let rec create_ordered_list_string final_string string_list =
  match string_list with
  | (hd::tl) -> create_ordered_list_string (final_string ^ hd ) tl
  | [hd] -> (final_string ^ hd )
  | [] -> final_string

(* Function converts OrderedList classification type into html   *)
let convert_ordered_list string_list =
  Printf.printf "%i" (List.length string_list);
  let remove_symbols_list = List.map remove_ordered_list_symbol string_list in
  let reverse_list = List.rev remove_symbols_list in
  List.iter print_string reverse_list;
  let ordered_string = create_ordered_list_string "" reverse_list in
  "<ol>\n" ^ ordered_string ^ "</ol>"

(* Function that goes through list to group together OrderedList Items into One OrderedList type *)
let rec group_ordered_items ordered_item_object start_item classification_list =
  match ordered_item_object with
  | OrderedList x1 ->
    match classification_list with
    | (hd::tl) ->
      match hd with
      | OrderedListItem x2 ->
        group_ordered_items (OrderedList (start_item::x1)) x2 tl
      | _ -> (OrderedList (start_item::x1))::hd::classification_list
    | _ -> classification_list

(* Function iterates through classfication list to find items to group together  *)
let rec group_list_items classification_list =
  match classification_list with
  | [] -> []
  | (hd::tl) ->
      match hd with
      | BlockquoteItem x -> group_list_items (group_blockquote_items (Blockquote []) x tl)
      | UnOrderedListItem x -> group_list_items (group_unordered_items (UnOrderedList []) x tl)
      | OrderedListItem x -> group_list_items (group_ordered_items (OrderedList []) x tl)
      | _ ->  hd::group_list_items tl
  | _ -> classification_list

(* ------------------ *)
(* ------------------ *)

(* let convert_bolditalic line_string =
  if Str.string_match bold_recipe1 line_string 0 then
    let html_string = Str.global_substitute bold_recipe1 (fun s -> "<b>") line_string in
    print_string html_string;
    html_string
  else
    line_string *)

(* ----------------------------- *)


(* Function that takes classfication string and begins conversion to html *)
let converting_classification_string_to_html classification_string =
  match classification_string with
  | Heading1 x -> convert_h1 x
  | Heading2 x -> convert_h2 x
  | Heading3 x -> convert_h3 x
  | Heading4 x -> convert_h4 x
  | Heading5 x -> convert_h5 x
  | Heading6 x -> convert_h6 x
  | Paragraph x -> convert_paragraph x
  | HorizontalLine x -> convert_horizontal x
  | Code x -> convert_code_string x
  | Blockquote x -> convert_blockquote x
  | UnOrderedList x -> convert_unordered_list x
  | OrderedList x -> convert_ordered_list x
  | Empty-> "\n"
  | Unknown x -> "Unknown " ^ x ^ " \n"

let write_to_html_file html_string =
  let htmlfile = open_out_gen [Open_creat; Open_text; Open_append] 0o640 "test.html" in
  output_string htmlfile html_string;
  close_out htmlfile

let () =
  let file_data = read_all "test.md" in
  let reverse_data = List.rev file_data in
  (* List.iter (Printf.printf "%s\n") reverse_data;; *)
  (* List.iter (check_tag) reverse_data in *)
  let c_list = List.map map_tag reverse_data in
  (* List.iter print_map_list c_list ;; *)
  let group_list = group_list_items c_list in
  List.iter print_map_list group_list ;
  let html_list = List.map converting_classification_string_to_html group_list in
  (* List.iter print_string html_list;; *)
  let html_list = ["<html>\n\t<head>\n\t</head>\n\t<body>\n"] @ html_list in
  let html_list = html_list @ ["\n\t</body>\n</html>\n"] in
  List.iter write_to_html_file html_list ;;
