type classfication =
  | Heading1 of string
  | Heading2 of string
  | Heading3 of string
  | Heading4 of string
  | Heading5 of string
  | Heading6 of string
  | Paragraph of string
  | Bold of string
  | Italic of string
  | Unknown of string
  | Empty

let h1_recipe = Str.regexp "^#"
let h2_recipe = Str.regexp "^##"
let h3_recipe = Str.regexp "^###"
let h4_recipe = Str.regexp "^####"
let h5_recipe = Str.regexp "^#####"
let h6_recipe = Str.regexp "^######"



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
    | '_' -> Bold line_string
    | '*' -> Italic line_string
    | _ -> Paragraph line_string

(* Helper Function to print out what the lines are classified as *)
let print_map_list classification_string =
  match classification_string with
  | Heading1 x -> Printf.printf "%s - Heading 1\n" x
  | Heading2 x -> Printf.printf "%s - Heading 2\n" x
  | Heading3 x -> Printf.printf "%s - Heading 3\n" x
  | Heading4 x -> Printf.printf "%s - Heading 4\n" x
  | Heading5 x -> Printf.printf "%s - Heading 5\n" x
  | Heading6 x -> Printf.printf "%s - Heading 6\n" x
  | Bold x -> Printf.printf "%s - Bold\n" x
  | Italic x -> Printf.printf "%s - Italic\n" x
  | Paragraph x -> Printf.printf "%s - Paragraph\n" x
  | Unknown x -> Printf.printf "%s - Unknown\n" x
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
  | _ -> "<p> Skip for now </p>\n"


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
  let html_list = List.map converting_classification_string_to_html c_list in
  (* List.iter print_string html_list;; *)
  List.iter write_to_html_file html_list ;;
