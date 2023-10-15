{
open Parser

exception LexError of string
}

(** no real support for newlines, but at least ignore them. *)
let white_space = [' ' '\t' '\n' '\r']+

let digit = ['0'-'9']
let int = digit+
let frac = '.' digit*
let exp = ['e' 'E'] ['-' '+']? digit+
let float = digit+ frac? exp?

let letter = ['a'-'z' 'A'-'Z']
let id_char = ['a'-'z' 'A'-'Z' '0' - '9' '_']
let id = letter id_char*

rule read = parse
    | white_space { read lexbuf }
    | int { INT (int_of_string (Lexing.lexeme lexbuf)) }
    | float { FLOAT (float_of_string (Lexing.lexeme lexbuf)) }
    | '+' { PLUS }
    | '-' { MINUS }
    | '*' { MULT }
    | '/' { DIV }
    | "let" { LET }
    | '=' { EQUALS }
    | "in" { IN }
    | id { ID (Lexing.lexeme lexbuf) }
    | eof { EOF }
    | _ { raise (LexError (Printf.sprintf "Lexing error in column %d: unexpected character." (Lexing.lexeme_start lexbuf))) }
