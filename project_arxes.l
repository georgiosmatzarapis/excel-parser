%option noyywrap
%x COMMENT

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "project_arxes.tab.h"
#define YY_DECL int yylex()
int linenum = 1;
%}

%%
[ \t]
[ \n] {linenum++;}
"ss:Workbook" { return WORKBOOK; }
"ss:Worksheet" { return WORKSHEET; }
"ss:Styles" { return STYLES; }
"ss:Style" { return STYLE; }
"ss:Table" { return TABLE; }
"ss:Column" { return COLUMN; }
"ss:Row" { return ROW; }
"ss:Cell" { return CELL; } 
"ss:Data" { return DATA; }
"ss:ID" { yylval.sval = strdup(yytext); return ID; }
"ss:Name" { return NAME;}
"ss:Protected" { return PROTECTED; }
"ss:ExpandedColumnCount" { return ECC; }
"ss:ExpandedRowCount" { return ERC; }
"ss:StyleID" { return STYLEID; }
"ss:Hidden" { return HIDDEN; }
"ss:Width" { return WIDTH; }
"ss:Height" { return HEIGHT; }
"ss:MergeAcross" { return MRGACROSS; }
"ss:MergeDown" { return MRGDOWN; }
"ss:Type" { return TYPE; }
"String" { return TSTRING; }
"Boolean" { return TBOOLEAN; }
"Datetime" { return TDATETIME; }
"Number" { return TNUMBER; }
"True" { yylval.sval = strdup(yytext); return BOOLEAN; } 
"False" { yylval.sval = strdup(yytext); return BOOLEAN; }
[0-9]+ { yylval.sval = strdup(yytext); return INT; }
([a-zA-Z0-9]*)+ { yylval.sval = strdup(yytext); return ALPHANUM; }
[-]?[0-9]{4}-[01][0-9]-[0-3][0-9][T][0-2][0-9]:[0-5][0-9]:[0-6][0-9][Z]?(\.[0-9]*)?([+|-][0-2][0-9]:[0-5][0-9])? { yylval.sval = strdup(yytext); return DATETIME; }
"<" { return LEFT; }
">" { return RIGHT; }
"/" { return DIV; }
"=" { return EQUAL; }
["] { return QUOTES; }

"<!--" {BEGIN(COMMENT); printf("%d: <!--", linenum++);}
<COMMENT>"-->" { BEGIN(INITIAL); printf("-->\n"); }
<COMMENT>"\n" {printf("\n"); linenum++;}
<COMMENT>.    {printf("%s",yytext);}

%%

