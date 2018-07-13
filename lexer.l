%option yylineno
%pointer

%{
    #include <cstdlib>
    #include <cerrno>
    #include <climits>
    #include <limits>
    #include "parser.hpp"
    
	void yyerror(const char *);
	
%}

/* WRITEME: Write any definitions here. You can find information on
            definitions here:
            http://flex.sourceforge.net/manual/Definitions-Section.html */
            
%x comment

/* WRITEME: If you are going to use start conditions, write them here.
            You can find more information on start conditions here:
            http://flex.sourceforge.net/manual/Start-Conditions.html
            You will probably want to use exclusive conditions rather
            than inclusive conditions (use the %x instead of the %s). */

%%
  /* WRITEME: Write your Flex token rules here */
  
"+"                     { return T_PLUS; }
"-"                     { return T_MINUS; }
"\*"                    { return T_MULTIPLY; }
"/"                     { return T_DIVIDE; }
">"                     { return T_GREATER_THAN; }
">="                    { return T_GREATER_THAN_EQUALS; }
"\("                    { return T_OPEN_PAREN; }
"\)"                    { return T_CLOSE_PAREN; }
"{"                     { return T_OPEN_BRACKET; }
"}"                     { return T_CLOSE_BRACKET; }
"->"                    { return T_RETURN_TYPE; }
";"                     { return T_SEMICOLON; }
"="                     { return T_ASSIGNMENT; }
"\."                     { return T_DOT; }
","                     { return T_COMMA; }
"\n"                    {}
"/*"                    BEGIN(comment);

<comment>[^*\n]*        
<comment>"*"+[^*/\n]*   

<comment>\n         
<comment><<EOF>>        { 
                            yyerror("Comment left unclosed"); 
                        }
<comment>"*"+"/"        BEGIN(INITIAL);

"if"                    { return T_IF; }
"else"                  { return T_ELSE; }
"while"                 { return T_WHILE; }
"do"                    { return T_DO; }
"print"                 { return T_PRINT; }
"return"                { return T_RETURN; }
"integer"               { return T_INTEGER; }
"boolean"               { return T_BOOLEAN; }
"none"                  { return T_NONE; }
"true"                  { return T_TRUE; }
"false"                 { return T_FALSE; }
"new"                   { return T_NEW; }
"extends"               { return T_EXTENDS; }
"equals"                { return T_EQUALS; }
"and"                   { return T_AND; }
"or"                    { return T_OR; }
"not"                   { return T_NOT; }

0|[1-9][0-9]*           { return T_INT; }
[a-zA-Z][a-zA-Z0-9]*    { return  T_IDENTIFIER; }

[ \t\f\v\r]+            {}

.                       { yyerror("invalid character"); }


%%

int yywrap(void) {
  return 1;
}
