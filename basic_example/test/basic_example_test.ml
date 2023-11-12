(*
   SPDX-FileCopyrightText:  Copyright 2023 Roland Csaszar
   SPDX-License-Identifier: MIT

   Project:  OCaml-Buck-2-Examples, basic_example
   File:     basic_example.ml
   Date:     08.Oct.2023

   =============================================================================

   Tests of the library `basic_example` using Alcotest.
*)

open Basic_example.Fibonacci

let () =
  let open Alcotest in
  let open QCheck_alcotest in
  run
    "Fibonacci Tests"
    [ ( "Naive Fibonacci tests"
      , [ test_case "F0 is 0" `Quick (fun () -> (check int) "same ints" 0 (fibonacci 0))
        ; test_case "F1 is 1" `Quick (fun () -> (check int) "same ints" 1 (fibonacci 1))
        ; test_case "F2 is 1" `Quick (fun () -> (check int) "same ints" 1 (fibonacci 2))
        ; test_case "F3 is 2" `Quick (fun () -> (check int) "same ints" 2 (fibonacci 3))
        ; test_case "F4 is 3" `Quick (fun () -> (check int) "same ints" 3 (fibonacci 4))
        ; test_case "F5 is 5" `Quick (fun () -> (check int) "same ints" 5 (fibonacci 5))
        ; test_case "F6 is 8" `Quick (fun () -> (check int) "same ints" 8 (fibonacci 6))
        ; test_case "F7 is 13" `Quick (fun () -> (check int) "same ints" 13 (fibonacci 7))
        ; test_case "F8 is 21" `Quick (fun () -> (check int) "same ints" 21 (fibonacci 8))
        ; test_case "F9 is 34" `Quick (fun () -> (check int) "same ints" 34 (fibonacci 9))
        ; test_case "F10 is 55" `Quick (fun () ->
            (check int) "same ints" 55 (fibonacci 10))
        ] )
    ; ( "Compare naive and tail recursive"
      , [ to_alcotest
            ~colors:true
            ~verbose:true
            ~long:true
            QCheck2.(
              Test.make
                ~name:"Using Quickcheck"
                ~count:100
                ~print:Print.(int)
                Gen.(int_range 0 40)
                (fun n -> fibonacci n = fibonacci_tailrec n))
        ] )
    ]
