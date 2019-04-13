

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


(* Check first character of a line to see if it is a regular line or not*)
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


let () =
  let file_data = read_all "test.md" in
  let reverse_data = List.rev file_data in
  (* List.iter (Printf.printf "%s\n") reverse_data;; *)
  List.iter (check_tag) reverse_data ;;
