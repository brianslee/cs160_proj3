%{
    #include <cstdlib>
    #include <cstdio>
    #include <iostream>

    #define YYDEBUG 1

    int yylex(void);
    void yyerror(const char *);
%}

%error-verbose

/* WRITEME: List all your tokens here */
%token T_PLUS T_MINUS T_MULTIPLY T_DIVIDE
%token T_GREATER_THAN T_GREATER_THAN_EQUALS T_EQUALS
%token T_AND T_OR T_NOT //T_UNARY_MINUS
%token T_OPEN_BRACKET T_CLOSE_BRACKET
%token T_OPEN_PAREN T_CLOSE_PAREN
%token T_RETURN_TYPE T_ASSIGNMENT
%token T_DOT T_SEMICOLON T_COMMA
%token T_IF T_ELSE T_WHILE T_DO
%token T_PRINT T_RETURN T_INTEGER T_BOOLEAN
%token T_NONE T_TRUE T_FALSE
%token T_NEW T_EXTENDS
%token T_INT T_IDENTIFIER


/* WRITEME: Specify precedence here */
%left T_OR
%left T_AND
%left T_GREATER_THAN T_GREATER_THAN_EQUALS T_EQUALS
%left T_PLUS T_MINUS
%left T_MULTIPLY T_DIVIDE
%right T_NOT //T_UNARY_MINUS


%%

/* WRITEME: This rule is a placeholder, since Bison requires
            at least one rule to run successfully. Replace
            this with your appropriate start rules. */
Start       :   ClassList
            ;

/* WRITME: Write your Bison grammar specification here */
ClassList   :   Class ClassList
            |   Class
            ;
Class       :   ClassName ClassBody
            |   ClassName T_EXTENDS ClassName ClassBody
            ;
            
ClassBody   :   T_OPEN_BRACKET MemVarList MemMethList T_CLOSE_BRACKET
            ;

Type        :   T_INTEGER
            |   T_BOOLEAN
            |   ClassName
            ;

MemVarList  :   MemVarList VariableDec T_SEMICOLON
            |   Epsilon
            ;

MemMethList :   MethodDec MemMethList
            |   Epsilon
            ;

VariableDec :   Type VarName
            |   Type VarName VarList
            ;

VarList     :   T_COMMA VarName
            |   T_COMMA VarName VarList
            ;

Identifier  :   T_IDENTIFIER
            ;

ClassName   :   Identifier
            ;

MethodName  :   Identifier
            ;

VarName     :   Identifier
            ;
            
Expression  :   Expression T_PLUS Expression
            |   Expression T_MINUS Expression
            |   Expression T_MULTIPLY Expression
            |   Expression T_DIVIDE Expression
            |   Expression T_GREATER_THAN Expression
            |   Expression T_GREATER_THAN_EQUALS Expression
            |   Expression T_EQUALS Expression
            |   Expression T_AND Expression
            |   Expression T_OR Expression
            |   T_NOT Expression
            |   T_MINUS Expression
            |   VarName
            |   VarName T_DOT VarName
            |   MethodCall
            |   T_OPEN_PAREN Expression T_CLOSE_PAREN
            |   Value
            |   T_NEW ClassName
            |   T_NEW ClassName T_OPEN_PAREN Arguments T_CLOSE_PAREN
            ;

Value       :   T_INT
            |   T_TRUE
            |   T_FALSE
            ;

MethodCall  :   MethodName T_OPEN_PAREN Arguments T_CLOSE_PAREN T_SEMICOLON
            |   VarName T_DOT MethodName T_OPEN_PAREN Arguments T_CLOSE_PAREN T_SEMICOLON
            ;

Arguments   :   ArgTwo
            |   Epsilon
            ;

ArgTwo      :   ArgTwo T_COMMA Expression
            |   Expression
            ;

Epsilon     :
            ;


MethodDec   :   MethodName T_OPEN_PAREN Parameters T_CLOSE_PAREN T_RETURN_TYPE T_NONE T_OPEN_BRACKET MethodBod T_CLOSE_BRACKET
            |   MethodName T_OPEN_PAREN Parameters T_CLOSE_PAREN T_RETURN_TYPE Type T_OPEN_BRACKET MethodBod Return T_CLOSE_BRACKET
            ;
            
Return      :   T_RETURN Expression T_SEMICOLON
            ;

Parameters  :   ParaList
            |   Epsilon
            ;

ParaList    :   ParaList T_COMMA Type VarName
            |   Type VarName
            ;

MethodBod   :   DeclarList StateList
            ;

DeclarList  :   DeclarList VariableDec T_SEMICOLON
            |   Epsilon
            ;
            
StateList   :   Statement StateList
            |   Epsilon
            ;

Statement   :   Assignment
            |   MethodCall
            |   IfElse
            |   While
            |   DoWhile
            |   Print
            ;

Assignment  :   VarName T_ASSIGNMENT Expression T_SEMICOLON
            |   VarName T_DOT VarName T_ASSIGNMENT Expression T_SEMICOLON
            ;

IfElse      :   T_IF Expression Block
            |   T_IF Expression Block T_ELSE Block
            ;
            
While       :   T_WHILE Expression Block
            ;

DoWhile     :   T_DO Block T_WHILE T_OPEN_PAREN Expression T_CLOSE_PAREN T_SEMICOLON

Block       :   T_OPEN_BRACKET Statement StateList T_CLOSE_BRACKET
            ;

Print       :   T_PRINT Expression T_SEMICOLON
            ;

%%

extern int yylineno;

void yyerror(const char *s) {
  fprintf(stderr, "%s at line %d\n", s, yylineno);
  exit(1);
}
