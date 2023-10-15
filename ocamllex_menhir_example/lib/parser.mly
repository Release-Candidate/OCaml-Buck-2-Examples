%token <int> INT
%token <float> FLOAT
%token <string> ID
%token MULT
%token DIV
%token PLUS
%token MINUS
%token EQUALS
%token LET
%token IN
%token EOF

%nonassoc IN
%left PLUS MINUS
%left MULT DIV

%{ open Ast %}

%type <Ast.expr> expr
%type <Ast.expr> prog

%start prog

%%

prog:
    | e = expr EOF { e }

expr:
    | LET x = ID EQUALS e1 = expr IN e2 = expr { Let (x, e1, e2) }
    | e1 = expr binop e2 = expr { Binop ($2, e1, e2) }
    | x = ID { Var x }
    | i = INT { Int i }
    | f = FLOAT { Float f }

%inline binop:
    | PLUS { Add }
    | MINUS { Subtr }
    | MULT { Mult }
    | DIV { Div }
