(*
   SPDX-FileCopyrightText:  Copyright 2023 Roland Csaszar
   SPDX-License-Identifier: MIT

   Project:  OCaml-Buck-2-Examples
   File:     interpreter.ml
   Date:     15.Oct.2023

   ============================================================================= *)

(** See the video https://www.youtube.com/watch?v=OKcCiMV2dQA&list=PLre5AT9JnKShBOPeuiD9b-I4XROIJhkIU&index=154
    and the following for a description. *)

open Ast

exception RuntimeError of string

(** [parse s] parses the given program [s] and returns the AST (abstract syntax
    tree) of this program. *)
let parse (s : string) : expr =
  let lexbuf = Lexing.from_string s in
  try
    let ast = Parser.prog Lexer.read lexbuf in
    ast
  with
  | Lexer.LexError msg -> failwith msg
  | Parser.Error ->
    failwith
      (Printf.sprintf
         "Parse error in column %d: syntax error."
         (Lexing.lexeme_start lexbuf))

(** [Env] is the module of environments. An environment is a map of string to
    values. *)
module Env = Map.Make (String)

(** [empty_env] is the empty environment. *)
let empty_env = Env.empty

(** [env] is the type of an environment that maps a string to a value. *)
type env = value Env.t

(** [value] is the type of a value. *)
and value =
  | VInt of int
  | VFloat of float

(** [eval_env env e] returns the value [v] , so that [<env e> ==> v] that is, so
    that [e] evaluates to the value [v] in the machine configuration
    [<env, v>]. *)
let rec eval_env (env : env) (e : expr) : value =
  match e with
  | Int i -> VInt i
  | Float f -> VFloat f
  | Var x -> eval_var_env env x
  | Binop (op, e1, e2) -> eval_binop_env env op e1 e2
  | Let (x, e1, e2) -> eval_let_env env x e1 e2

(** [eval_var_env env x] returns the value [v]. such that [<env, x> ==> v]. *)
and eval_var_env env x =
  try Env.find x env with
  | Not_found -> raise (RuntimeError ("Unbound variable " ^ x))

(** [eval_binop_env env op e1 e2] returns the value [v], such that
    [<env, op e1 e2> ==> v]. *)
and eval_binop_env env op e1 e2 =
  match op, eval_env env e1, eval_env env e2 with
  | Add, VInt n, VInt m -> VInt (n + m)
  | Subtr, VInt n, VInt m -> VInt (n - m)
  | Add, VFloat f, VFloat g -> VFloat (f +. g)
  | Subtr, VFloat f, VFloat g -> VFloat (f -. g)
  | Mult, VInt n, VInt m -> VInt (n * m)
  | Div, VInt n, VInt m -> VInt (n / m)
  | Mult, VFloat f, VFloat g -> VFloat (f *. g)
  | Div, VFloat f, VFloat g -> VFloat (f /. g)
  | Add, _, _ -> raise (RuntimeError "Invalid types for addition")
  | Subtr, _, _ -> raise (RuntimeError "Invalid types for subtraction")
  | Mult, _, _ -> raise (RuntimeError "Invalid types for multiplication")
  | Div, _, _ -> raise (RuntimeError "Invalid types for division")

(** [eval_let_env env x e1 e2] returns the value [v], so that
    [<env, let x = e1 in e2> ==> v]. *)
and eval_let_env env x e1 e2 =
  let v1 = eval_env env e1 in
  let env' = Env.add x v1 env in
  eval_env env' e2

(** [string_of_val_env e] converts the value [v] to a string representation and
    returns that. *)
let string_of_val_env (v : value) : string =
  match v with
  | VInt i -> string_of_int i
  | VFloat f -> string_of_float f

(** [interp_env s] interprets the string [s] as a program by lexing, parsing
    and using a dynamic environment to evaluate it to the final string that is
    returned *)
let interp_env (s : string) : string =
  s |> parse |> eval_env empty_env |> string_of_val_env
