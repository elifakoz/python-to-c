%{
#include <stdio.h>
#include <string.h>
#include "y.tab.h"
int tabCounter = 1;

int linenumber=3;
%}
%%
-?[0-9]+	{yylval.str = strdup(yytext); return INTEGER;}
-?[0-9]+(\.[0-9]+) {yylval.str = strdup(yytext); return FLOAT;}
\+|\-|\*|\/	{yylval.str = strdup(yytext); return MATHOP;}
"=="|"!="|"<"|"<="|">"|">=" {yylval.str = strdup(yytext); return COMPARISON;}
\"[^"]*\"     {yylval.str=strdup(yytext); return STRING;}
\(	return OPENPAR;
\)	return CLOSEPAR;
":" {yylval.str = strdup(yytext); return COLON;}
"="	{yylval.str = strdup(yytext); return EQUAL;}
"if" {yylval.str = strdup(yytext); return IF;}
"else" {yylval.str = strdup(yytext); return ELSE;}
"elif" {yylval.str = strdup(yytext); return ELIF;}
\n	{linenumber++; return NEWLINE;}
\t {tabCounter++;  return TAB;}
[a-zA-Z][a-zA-Z0-9]* {yylval.str = strdup(yytext);return VARIABLE;}

" "
%%