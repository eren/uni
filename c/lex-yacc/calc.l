%{
   #include "y.tab.h"
%}
%%
[0-9]+       { yylval.ival = atoi(yytext); return T_Int;}
[0-9]+\.[0-9]+ { yylval.fval = atof(yytext); return T_Float; }
[-+*/\^\n]     { return yytext[0];}
.         { /* ignore everything else */ }
