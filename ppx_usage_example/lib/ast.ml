(*
   SPDX-FileCopyrightText:  Copyright 2023 Roland Csaszar
   SPDX-License-Identifier: MIT

   Project:  OCaml-Buck-2-Examples
   File:     ast.ml
   Date:     15.Oct.2023

   ============================================================================= *)

(** The type of a binary operation. *)
type bop =
  | Add
  | Subtr
  | Mult
  | Div

(** The type of an expression, the type of the whole AST. *)
type expr =
  | Int of int
  | Float of float
  | Var of string
  | Binop of bop * expr * expr
  | Let of string * expr * expr
