

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

(* let rec print_file_data_list string_list =
  match string_list with
  | (hd::tl) -> Printf.printf hd; print_file_data_list tl
  | [] -> "" *)

let () =
  let file_data = read_all "test.md" in
  List.iter (Printf.printf "%s\n") file_data
