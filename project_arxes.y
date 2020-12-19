%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yylex();
extern int yyparse();
extern FILE *yyin;
extern FILE *yyout;
extern int linenum;
void yyerror(const char *s);
%}

%union {
	int ival;
	char *sval;
}

%token WORKBOOK
%token WORKSHEET
%token STYLES
%token STYLE
%token TABLE
%token COLUMN
%token ROW
%token CELL
%token DATA
%token <sval> ID
%token NAME
%token PROTECTED
%token ECC
%token ERC
%token <sval> STYLEID
%token HIDDEN
%token WIDTH
%token HEIGHT
%token MRGACROSS
%token MRGDOWN                      
%token TYPE
%token TSTRING
%token TBOOLEAN
%token TDATETIME
%token TNUMBER
%token <sval> ALPHANUM
%token <sval> BOOLEAN
%token <sval> INT
%token <sval> DATETIME
%token LEFT
%token RIGHT
%token DIV
%token EQUAL
%token QUOTES

%type <sval> id

%%

init_workbook : LEFT WORKBOOK RIGHT { printf("\n<ss:Workbook>\n");} Styles_rec Worksheet_rec LEFT DIV WORKBOOK RIGHT { printf("</ss:Workbook>\n\n");} 
      ; 

Worksheet_rec : Worksheet | Worksheet_rec Worksheet 
      ;

Styles_rec : | Styles_rec Styles 
      ;

Styles : LEFT STYLES RIGHT { printf("\t<ss:Styles>\n");} Style_rec LEFT DIV STYLES RIGHT { printf("\t</ss:Styles>\n");}
      ;

Style_rec : | Style_rec Style 
      ;

Style : LEFT STYLE id RIGHT { printf("\t\t<ss:Style ss:ID=\"%s\">",$3);} LEFT DIV STYLE RIGHT { printf("</ss:Style>\n");}
      ;

id : ID EQUAL QUOTES ALPHANUM QUOTES {$$=$4;} //anathetei timi sto id wste na ektypwthei panw sto $3
      ;

Worksheet : LEFT WORKSHEET {printf("\t<ss:Worksheet");} Name Protected RIGHT {printf(">\n");} Table_rec LEFT DIV WORKSHEET RIGHT { printf("\t</ss:Worksheet>\n");} 
   	  ;

Name : NAME EQUAL QUOTES ALPHANUM QUOTES { printf(" ss:Name=\"%s\"", $4);} 			
      ;

Protected : | PROTECTED EQUAL QUOTES BOOLEAN QUOTES { printf(" ss:Protected=\"%s\"", $4);}
	  ;

Table_rec : | Table_rec Table
      ;

Table : LEFT TABLE {printf("\t\t<ss:Table");} ecc erc styleid RIGHT {printf(">\n");} T_rec LEFT DIV TABLE RIGHT { printf("\t\t</ss:Table>\n");}
      ;

ecc : | ECC EQUAL QUOTES INT QUOTES { printf(" ss:ExpandedColumnCount=\"%s\"", $4);}
      ;

erc : | ERC EQUAL QUOTES INT QUOTES { printf(" ss:ExpandedRowCount=\"%s\"", $4);}
      ;

styleid : | STYLEID EQUAL QUOTES ALPHANUM QUOTES { printf(" ss:StyleID=\"%s\"", $4);} 
      ;

T_rec : | T_rec Column | T_rec Row
            ;

Column : LEFT COLUMN { printf("\t\t\t<ss:Column");} hidden width styleid DIV RIGHT { printf("/>\n");}
      ;

hidden : | HIDDEN EQUAL QUOTES BOOLEAN QUOTES { printf(" ss:Hidden=\"%s\"",$4);}
      ;

width : | WIDTH EQUAL QUOTES INT QUOTES { printf(" ss:Width=\"%s\"",$4);}
      ;

Row : LEFT ROW { printf("\t\t\t<ss:Row");} height hidden styleid RIGHT { printf(">\n");} Cell_rec LEFT DIV ROW RIGHT { printf("\t\t\t</ss:Row>\n");}
      ;

height : | HEIGHT EQUAL QUOTES INT QUOTES  { printf(" ss:Height=\"%s\"",$4);}
      ;

Cell_rec : | Cell_rec Cell
      ;

Cell : LEFT CELL { printf("\t\t\t\t<ss:Cell");} mrgacross mrgdown styleid RIGHT { printf(">\n");} Data_rec LEFT DIV CELL RIGHT { printf("\t\t\t\t</ss:Cell>\n");}
      ;

mrgacross : | MRGACROSS EQUAL QUOTES INT QUOTES { printf(" ss:MergeAcross=\"%s\"",$4);}
      ;

mrgdown : | MRGDOWN EQUAL QUOTES INT QUOTES { printf(" ss:MergeDown=\"%s\"",$4);}
      ;

Data_rec : | Data_rec Data
      ;

Data : LEFT DATA { printf("\t\t\t\t\t<ss:Data");} type RIGHT { printf(">");} periexomeno_data LEFT DIV DATA RIGHT { printf("</ss:Data>\n");}
      ;

type : TYPE EQUAL QUOTES TNUMBER QUOTES { printf(" ss:Type=\"Number\"");} | TYPE EQUAL QUOTES TDATETIME QUOTES { printf(" ss:Type=\"Datetime\"");} | TYPE EQUAL QUOTES TBOOLEAN QUOTES { printf(" ss:Type=\"Boolean\"");} | TYPE EQUAL QUOTES TSTRING QUOTES { printf(" ss:Type=\"String\"");}
      ;

periexomeno_data : | INT {printf("%s",$1);} | DATETIME {printf("%s",$1);} | BOOLEAN {printf("%s",$1);} | string_rec
      ;

string_rec: ALPHANUM {printf("%s",$1);} | string_rec ALPHANUM {printf(" %s",$2);}
      ;


%%


int main( int argc, char **argv ) {
  ++argv; --argc;
  if ( argc > 0 )
        yyin = fopen( argv[0], "r" );
  else
        yyin = stdin;
  yyout = fopen ( "output", "w" );	
  yyparse ();	    
  return 0;
}

void yyerror(const char* s) {
	fprintf(stderr, "Parse error: %s in line ", s);
	printf("%d\n\n", linenum);
	exit(1);
}
