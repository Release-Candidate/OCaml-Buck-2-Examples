(*
   SPDX-FileCopyrightText:  Copyright 2023 Roland Csaszar
   SPDX-License-Identifier: MIT

   Project:  OCaml-Buck-2-Examples, basic_example
   File:     main.ml
   Date:     08.Oct.2023

   ========================================================================== *)

let main () =
  let fib10 = Basic_example.Fibonacci.fibonacci_tailrec 10 in
  Printf.printf "Hello, World!\nBtw. Fibonacci number F_10 is %d\n" fib10 |> ignore
;;

main ()
