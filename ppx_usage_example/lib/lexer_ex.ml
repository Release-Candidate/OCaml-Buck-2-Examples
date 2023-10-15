open Parser_ex

let digit = [%sedlex.regexp? '0' .. '9']
let int_token = [%sedlex.regexp? Plus digit]
let float_token = [%sedlex.regexp? Plus digit, '.', Star digit]
let letter = [%sedlex.regexp? 'a' .. 'z' | 'A' .. 'Z']
let id_char = [%sedlex.regexp? letter | digit | '_']
let id = [%sedlex.regexp? letter, Star id_char]
let whitespace = [%sedlex.regexp? ' ' | '\t']
let newline = [%sedlex.regexp? '\r' | '\n' | "\r\n"]
let white_or_new = [%sedlex.regexp? whitespace | newline]

(** Exception raised by the lexer.*)
exception LexError of string

(** [token buf] lexes the buffer [buf]. Ignores whitespace.
    Raises: [LexError] on lexing errors. *)
let rec token buf =
  match%sedlex buf with
  | white_or_new -> token buf
  | eof -> EOF
  | '*' -> MULT
  | '/' -> DIV
  | '+' -> PLUS
  | '-' -> MINUS
  | "let" -> LET
  | '=' -> EQUALS
  | "in" -> IN
  | float_token -> FLOAT (float_of_string (Sedlexing.Utf8.lexeme buf))
  | int_token -> INT (int_of_string (Sedlexing.Utf8.lexeme buf))
  | id -> ID (Sedlexing.Utf8.lexeme buf)
  | _ ->
    raise
      (LexError
         (Printf.sprintf
            "Lexing error in column %d: unexpected character."
            (Sedlexing.lexeme_start buf)))
;;
