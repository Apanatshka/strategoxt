%{
#include <aterm1.h>
#include <srts/stratego.h>

extern int yylineno;
extern char file_name[256];
extern FILE *yyin;

ATerm parse_tree;

void yymessage(char *msg)  
{
  fprintf(stderr, "%s: line %d - %s\n", file_name, yylineno + 1, msg);
}

void yyerror(char *msg)
{
  yymessage(msg);
  exit(1); 
}

%}

%union{ 
   int    num;
   double real;
   char   *string;
   ATerm  term;
   ATermList list;
}

%{

/* int yylex(void); */
 
int yylex(YYSTYPE *lvalp);
int yyparse(void);

int parse()
{
   int result;
   result = yyparse();
   return result;
}
%}

%token <term> LCID
%token <term> STRINGTOK 
%token <term> UCID
%token <term> ID
%token <term> LID

%token ARROW 
%token LONGARROW 
%token ASSIGN
%token ASTERISK 
%token BACKARROW 
%token BAR
%token BUILD
%token AS
%token ANNBUILD
%token ANNRM
%token BUILDe 
%token COMMA 
%token EQ 
%token FAIL 
%token GG
%token IMPORTS 
%token KIDS
%token LBRACK 
%token LCURLY 
%token LCURLYBAR
%token LL 
%token LPAREN 
%token LT 
%token GT
%token ANNMATCH 
%token MATCH 
%token MATCHe
%token MODULE
%token NEW 
%token CONSTRUCTORS 
%token OVERLAYS
%token PARSEPROG 
%token PARSEQUERY
%token PRIM
%token RCURLY 
%token BARRCURLY 
%token RPAREN 
%token RULES 
%token SIGNATURE 
%token SORTS 
%token STARSTAR
%token STRATEGIES 
%token STR_GT 
%token SUCC 
%token UNDERSCORE 
%token DOT
%token BACKSLASH
%token EXPLODE
%token MODIFIER
%token OVERRIDE

%token STRATEGO
%token SCRIPT
%token DUMP
%token LOAD

%token IN

%right COLON DOUBLECOLON
%right PLUS PLUSPLUS LTPLUSPLUS LTPLUS PLUSGT PLUSPLUSGT
%right SEMICOLON 
%right DOUBLEARROW 
%right LEFTDOUBLEARROW 
%left  ASSIGN
%right RBRACK
%right NOT WHERE TEST ONE ALL THREAD SOMETOK MU LET BAGOF
%right <real> REAL 
%right <num> INT 

%type <list> commands
%type <term> command

%type <term> decl 
%type <list> decls 
%type <term> id 
%type <term> lid 
%type <list> idlist 
%type <term> kind
%type <list> kinds
%type <list> mods
%type <term> opdecl
%type <list> opdecls
%type <term> optcond 
%type <list> optcont 
%type <term> optkind
%type <list> optstrategylist 
%type <list> opttermlist 
%type <list> optvarlist 
%type <list> overlays
%type <term> overlay
%type <term> rule 
%type <term> stratrule 
%type <term> rule_def 
%type <list> rules 
%type <term> sdecl
%type <list> sdecls
%type <term> start
%type <list> strategies 
%type <term> strategy 
%type <term> strategy_def 
%type <list> strategylist
%type <term> strategytail 
%type <term> tail
%type <term> term 
%type <list> termlist 
%type <term> trav
%type <list> tvarlist 
%type <term> type
%type <term> typedid
%type <list> typelist
%type <list> varlist
%type <list> purevarlist

%start start

%pure_parser
   
%%
 
start 	: MODULE id decls 	       	{parse_tree = ATmake("Specification([<list>])", $3);}
	| STRATEGO SCRIPT commands	{parse_tree = (ATerm)$3;}
        | LT strategy GT term 		{parse_tree = App2("App", $2, $4);}
	| strategy			{parse_tree = App1("Strategy",$1);}
	;
  
commands : command 			{$$ = ATmakeList1($1);}
	| commands command 		{$$ = ATappend($1, $2);}
	|				{$$ = ATmakeList0();}
	;

command : DUMP STRINGTOK		{$$ = App1("Dump", $2);}
	| LOAD STRINGTOK		{$$ = App1("Load", $2);}
	| decl				{$$ = $1;}
	| GT strategy			{$$ = App1("Eval", $2);}
	;

decls	: decl	     			{$$ = ATmakeList1($1);}
	| decls decl 			{$$ = ATappend($1, $2);}
 	|				{$$ = ATmakeList0();}
        ;

mods	: 				{$$ = ATmakeList0();}
	| mods id			{$$ = ATappend($1, $2);}
	;

decl	: IMPORTS mods			{$$ = App1("Imports", (ATerm) $2);}
	| RULES  strategies		{$$ = App1("Rules", (ATerm) $2);}
	| STRATEGIES strategies 	{$$ = App1("Strategies", (ATerm) $2);}
	| SIGNATURE sdecls		{$$ = App1("Signature", (ATerm) $2);}
	| OVERLAYS overlays		{$$ = App1("Overlays", (ATerm) $2);}
        ;

sdecls	: sdecl				{$$ = ATmakeList1($1);}
	| sdecls sdecl 			{$$ = ATappend($1, $2);}
	| 				{$$ = ATmakeList0();}
        ;

sdecl	: SORTS idlist			{$$ = App1("Sorts", (ATerm) $2);}
	| CONSTRUCTORS opdecls		{$$ = App1("Constructors", (ATerm) $2);}
        ; 

idlist  :                   		{$$ = ATmakeList0();}
        | idlist id optkind             {$$ = ATappend($1, App2("Sort", $2, $3));}
        ;

optkind : 				{$$ = (ATerm) ATempty;}
	| LPAREN termlist RPAREN 	{$$ = (ATerm) $2;}
        ;

kinds   : kind 				{$$ = ATmakeList1($1);}
	| kinds kind 			{$$ = ATappend($1, $2);}
        ;

kind	: ASTERISK			{$$ = ATmake("Type");}
	| STARSTAR			{$$ = ATmake("TypeList");}
        ;

opdecls : 				{$$ = ATmakeList0();}
	| opdecls opdecl 		{$$ = ATappend($1, $2);}
        ;

opdecl	: id COLON type			{$$ = App2("OpDecl", $1, $3);}
        ;

type 	: typelist ARROW type		{$$ = App2("FunType", (ATerm) $1, $3);}
	| term				{$$ = App1("ConstType", $1);}
        | LPAREN type RPAREN 		{$$ = $2;}
        ;

typelist
	: typelist ASTERISK type 	{$$ = ATappend($1, $3);}
	| type				{$$ = ATmakeList1($1);}
        ;

id      : LCID 				{$$ = $1;}
   	| UCID 				{$$ = $1;}
        ;

/* list identifier */

lid     : LID 				{$$ = $1;}
        ;

/* Terms */

term 	: id optcont		      	{if(ATisEmpty($2)) 
					   $$ = App1("Var", $1);
					 else
					   $$ = App3("Con", 
						      App1("Var", $1), ATgetFirst($2), 
						      ATgetFirst(ATgetNext($2)));}

        | lid				{$$ = App1("Var",  App1("ListVar", $1));}
						
	| UNDERSCORE			{$$ = ATmake("Wld");}
					
	| UNDERSCORE term		{$$ = App1("BuildDefault", $2);}

	| INT			      	{$$ = App1("Int", (ATerm) ATmakeInt($1));}
	| REAL			      	{$$ = App1("Real", (ATerm) ATmakeReal($1));}
	| STRINGTOK			{$$ = App1("Str", $1);}
     	| id opttermlist 		{$$ = App2("Op", $1, (ATerm) $2);}
        | id AS term                    {$$ = App2("As", App1("Var", $1), $3);}
	| LT strategy GT term 		{$$ = App2("App", $2, $4);}
	| LT strategy GT 		{$$ = App1("RootApp", $2);}
	| LBRACK termlist tail RBRACK   {$$ = list_to_consnil_op_tl($2, $3);}


	| LPAREN termlist RPAREN	{if(ATgetLength($2) == 1)
    					   $$ = ATgetFirst($2);
  				 	 else
					   $$ = App2("Op", ATmakeString(""), (ATerm) $2);}


	| term EXPLODE LPAREN term RPAREN 
					{$$ = App2("Explode", $1, $4);}
        | term LCURLY termlist RCURLY	{$$ = App2("Anno", $1, list_to_consnil_op($3));}
        ;

tail    : 				{$$ = ATmake("Op(\"Nil\",[])");}
	| BAR term 			{$$ = $2;}
        ;

optcont :				{$$ = ATmakeList0();}
	| LBRACK term optcond RBRACK trav 	
					{$$ = ATmakeList2($2, App2("Call", $5, (ATerm) ATmakeList0()));}
        ;

trav    : 				{$$ = ATmake("SVar(\"oncetd\")"); }
	| LPAREN id RPAREN 		{$$ = App1("SVar", $2);}
        ;

opttermlist
	: 				{$$ = ATmakeList0();}
	| LPAREN termlist RPAREN 	{$$ = $2;}
        ;

termlist: term				{$$ = ATmakeList1($1);}
	| term COMMA termlist  		{$$ = ATinsert($3, $1);}
        |				{$$ = ATmakeList0();}
        ;

tvarlist: id				{$$ = ATmakeList1($1);}
	| id COMMA tvarlist  		{$$ = ATinsert($3, $1);}
        |				{$$ = ATmakeList0();} 
        ;

/* Rewrite rules */

rules 	:           			{$$ = ATmakeList0();}
      	| rules rule_def  		{$$ = ATappend($1, $2);}
        ;

rule_def 
	: id optvarlist COLON rule	{$$ = App3("RDef", $1, (ATerm) $2, (ATerm) $4);}
	| id optvarlist 
		DOUBLECOLON stratrule	{$$ = App3("RDef", $1, (ATerm) $2, (ATerm) $4);}
        ;
       
rule    : term ARROW term optcond 	{$$ = App3("Rule", $1, $3, $4);	}
        ;

stratrule : strategy LONGARROW strategy optcond 	
					{$$ = App3("StratRule", $1, $3, $4);	}
        ;

optcond :				{$$ = ATmake("Id");}
	| WHERE strategy		{$$ = $2;}
        ;

/* Strategies */

strategy
	: id optstrategylist 		{$$ = App2("Call", App1("SVar", $1), (ATerm) $2);}

	| id MODIFIER id optstrategylist
	  				{$$ = App2("Call", App1("SVar", App2("Mod", $1, $3)), 
							   (ATerm)$4);}

	| strategy EXPLODE LPAREN strategy RPAREN 
					{$$ = App2("ExplodeCong", $1, $4);}


	| MATCHe term 			{$$ = App1("Match", $2);}
	| BUILDe term			{$$ = App1("Build", $2);}

        | PRIM LPAREN STRINGTOK RPAREN  {$$ = App2("Prim", $3, (ATerm) ATempty);}
        | PRIM LPAREN STRINGTOK COMMA termlist RPAREN  {$$ = App2("Prim", $3, (ATerm) $5);}

        | BACKSLASH rule BACKSLASH	{$$ = App1("LRule", $2);}

	| LT strategy GT term		{$$ = App2("BA", $2, $4);}
	| strategy DOUBLEARROW term	{$$ = App2("AM", $1, $3);}

        | FAIL 				{$$ = ATmake("Fail");}
        | SUCC 				{$$ = ATmake("Id");}
        | INT strategy			{$$ = App2("Path", (ATerm) ATmakeInt($1), $2); }

        | RULES LPAREN rules RPAREN	{$$ = App1("DynamicRules", (ATerm) $3);}
        | OVERRIDE RULES LPAREN rules RPAREN	{$$ = App1("OverrideDynamicRules", (ATerm) $4);}

        | NOT  LPAREN strategy RPAREN	{$$ = App1("Not", $3);}
        | WHERE LPAREN strategy	RPAREN	{$$ = App1("Where", $3);}
        | TEST  LPAREN strategy RPAREN	{$$ = App1("Test", $3);}

	| LCURLY tvarlist COLON strategy RCURLY 	
					{$$ = App2("Scope", (ATerm) $2, $4);}
	| LCURLYBAR tvarlist COLON strategy BARRCURLY 	
					{$$ = App2("DynRuleScope", (ATerm) $2, $4);}
	| LCURLY strategy RCURLY 	{$$ = App1("ScopeDefault", $2);}

	| strategy SEMICOLON strategy	{$$ = App2("Seq", $1, $3);}

	| strategy PLUS strategy 	{$$ = App2("Choice", $1, $3);}
	| strategy PLUSPLUS strategy 	{$$ = App2("GChoice", $1, $3);}

        | strategy LTPLUS strategy   	{$$ = App2("LChoice", $1, $3);}
        | strategy LTPLUSPLUS strategy  {$$ = App2("LGChoice", $1, $3);}

        | strategy LT strategy 
		 PLUS strategy   	{$$ = App3("GuardedLChoice", $1, $3, $5);}

        | strategy PLUSGT strategy   	{$$ = App2("LChoice", $3, $1);}
        | strategy PLUSPLUSGT strategy  {$$ = App2("LGChoice", $3, $1);}

	| BAGOF LPAREN strategy RPAREN	{$$ = App1("Bagof", $3);}

	| MU id LPAREN strategy RPAREN{$$ = App2("Rec", $2, $4);}
	| SOMETOK LPAREN strategy RPAREN{$$ = App1("Some", $3);}
	| ONE LPAREN strategy RPAREN	{$$ = App1("One", $3);}
	| ALL LPAREN strategy RPAREN	{$$ = App1("All", $3);}
	| THREAD LPAREN strategy RPAREN	{$$ = App1("Thread", $3);}



	| LPAREN strategylist RPAREN	{if(ATgetLength($2) == 1)
    					   $$ = ATgetFirst($2);
  				 	 else
					   $$ = App2("Call", App1("SVar", ATmakeString("")), (ATerm) $2);}

	| LBRACK strategylist 
		 strategytail RBRACK	{$$ = list_cong($2, $3);}
	| STRINGTOK			{$$ = App1("Match", App1("Str", $1));}
	| INT			      	{$$ = App1("Match", 
					      App1("Int", (ATerm) ATmakeInt($1)));}
	| REAL			      	{$$ = App1("Match", 
					      App1("Real", (ATerm) ATmakeReal($1)));}
	| LET strategies IN strategy    {$$ = App2("Let", (ATerm) $2, $4);}


	| strategy LCURLY strategy RCURLY 
				       {$$ = App2("Call", 
						  App1("SVar", ATmakeString("Anno_Cong__")), 
					          (ATerm) ATmakeList2($1, $3));}
        ;

strategytail 
	: 				{$$ = ATmake("Call(SVar(\"Nil\"),[])");}
	| BAR strategy			{$$ = $2;}
	;

optstrategylist
	:			     	{$$ = ATmakeList0();}
	| LPAREN strategylist RPAREN 	{$$ = $2;}
        ;

strategylist 
	: 				{$$ = ATmakeList0();}
	| strategy 			{$$ = ATmakeList1($1);}
	| strategy COMMA strategylist 	{$$ = ATinsert($3, $1);}
        ;

/* Strategy definitions */ 

strategies 
	:                         	{$$ = ATmakeList0();}
	| strategies strategy_def 	{$$ = ATappend($1, $2);}
	| strategies rule_def 		{$$ = ATappend($1, $2);}
        ;

strategy_def 
	: id optvarlist EQ strategy	{$$ = App3("SDef", $1, (ATerm) $2, $4);}
        ;

optvarlist
	: 				{$$ = ATmakeList0();}
	| LPAREN varlist RPAREN 	{$$ = $2;}
        ;

varlist : 				{$$ = ATmakeList0();}
	| typedid			{$$ = ATmakeList1($1);}
	| typedid COMMA varlist 	{$$ = ATinsert($3, $1);}
        ;

typedid : id				{$$ = App1("DefaultVarDec", $1);}
	| id COLON type			{$$ = App2("VarDec", $1, $3);}
        ;

purevarlist : 				{$$ = ATmakeList0();}
	| id				{$$ = ATmakeList1($1);}
	| id COMMA purevarlist 		{$$ = ATinsert($3, $1);}
        ;

overlays:				{$$ = ATmakeList0();}
	| overlay overlays 		{$$ = ATinsert($2, $1);}
        ;

overlay : id LPAREN purevarlist RPAREN EQ term
					{$$ = App3("Overlay", $1, (ATerm) $3, $6);}
	| id EQ term 	{$$ = App3("Overlay", $1, (ATerm) ATmakeList0(), $3);}
        ; 

/* Note this allows contexts in overlay definitions; should be excluded
by checking in front-end */
