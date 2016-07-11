PARSER.asm
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
// terminal symbols
#define TOKEN_PLUS 100
#define TOKEN_MINUS 200
#define TOKEN_MULTIPLY 300
#define TOKEN_DIVIDE 400
#define TOKEN_NUMBER 500
#define TOKEN_NAME 600
#define TOKEN_RIGHTPAREN 700
#define TOKEN_LEFTPAREN 800
#define TOKEN_EOF 0
%}
%%
[\+|\-]*[0-9]+ {return TOKEN_NUMBER;}
[A-Za-z]+ {return TOKEN_NAME;}
\+ {return TOKEN_PLUS;}
\- {return TOKEN_MINUS;}
\* {return TOKEN_MULTIPLY;}
\\ {return TOKEN_DIVIDE;}
\( {return TOKEN_LEFTPAREN;}
\) {return TOKEN_RIGHTPAREN;}
%%
//lookahead symbol k = 1
int word;
void Fail(void);
bool Factor(void);
bool Eprime(void);
bool Expr(void);
bool Term(void);
bool TPrime(void);
void writeHeader(void);
void writeFooter(void);
#define TEST_FILE "/home/samiracoliva/Documents/CMPE152/LabAssignments/lab3/ASSEMBLY_FILE.asm" //path for assembly output file
FILE *spOut;


int main(void)
{
  /* Goal → Expr */
  count = 0;
  spOut = fopen(TEST_FILE, "w");
  writeHeader();
  word = yylex();
  
  if(Expr())
 {
    if(word == TOKEN_EOF)
   {
      printf("Valid Arithmetic Expression String\n");
  }
  else
    Fail();
 }
//print results
fprintf(spOut,"%s\n","\tpush Number");
fprintf(spOut,"%s\n","\tcall printf");
fprintf(spOut,"%s\n","\tadd esp,8");
writeFooter();
fclose(spOut);
return 0;
}


void writeHeader(void)
{
  fprintf(spOut,"%s\n","SECTION .data");
  fprintf(spOut,"%s\n","Number: db \"Num: %d\",10,0");
  fprintf(spOut,"%s\n","operand1: dd 0");
  fprintf(spOut,"%s\n","operand2: dd 0");
  fprintf(spOut,"%s\n","result: dd 0");
  fprintf(spOut,"%s\n","SECTION .bss");
  fprintf(spOut,"%s\n","SECTION .text");
  fprintf(spOut,"%s\n","extern printf ");
  fprintf(spOut,"%s\n","global main ");
  fprintf(spOut,"%s\n","main:");
  fprintf(spOut,"%s\n","nop");
  fprintf(spOut,"%s\n","push ebp");
  fprintf(spOut,"%s\n","mov ebp,esp");
  fprintf(spOut,"%s\n","push ebx ");
  fprintf(spOut,"%s\n","push esi");
  fprintf(spOut,"%s\n","push edi");
}

void writeFooter(void)
{
  fprintf(spOut,"%s\n","pop edi");
  fprintf(spOut,"%s\n","pop esi");
  fprintf(spOut,"%s\n","pop ebx");
  fprintf(spOut,"%s\n","mov esp,ebp");
  fprintf(spOut,"%s\n","pop ebp");
  fprintf(spOut,"%s\n","ret");
}

void Fail(void)
{
  printf("Syntax Error--Invalid Input String\n");
  exit(1);
}

/* Expr' → + Term Expr' */
/* Expr' → - Term Expr'*/
bool Eprime(void)
{
      bool success = false;
      if(word == TOKEN_PLUS)
      {
         word = yylex(); 
         if(Term())
        {
              fprintf(spOut,"\t%s\n","pop eax");//pop operand1 into eax
              fprintf(spOut,"\t%s\n","pop ebx");//pop operand1 into eax
              fprintf(spOut,"\t%s\n","add eax, ebx");// eax + ebx ---> eax
              fprintf(spOut,"\t%s\n","push eax");// eax + ebx ---> eax
              return Eprime();
        }
        else
        {
          Fail();
        }
      }
      else if(word == TOKEN_MINUS)
    {
            word = yylex();
            if(Term())
            {
                fprintf(spOut,"\t%s\n","pop ebx");//pop operand1 into eax
                fprintf(spOut,"\t%s\n","pop eax");//pop operand1 into eax
                fprintf(spOut,"\t%s\n","sub eax, ebx");// eax + ebx ---> eax
                fprintf(spOut,"\t%s\n","push eax");// eax + ebx ---> eax
                return Eprime();
            }
          else
          {
              Fail();
          }
    }
    else
    {
               if(word == TOKEN_RIGHTPAREN || word == TOKEN_EOF)
              {
                  success = true; /* Expr′→ε */
              }
              else
                   Fail();
    }
  
  return success;

}

/* Expr → Term Expr′ */
bool Expr(void)
{
        bool success = false;
        if(Term())
        {
          return Eprime();
        }
        else
            Fail();
        return success;
}

/* Factor → (Expr) */
bool Factor(void)
{
        bool success = false;
        if(word == TOKEN_LEFTPAREN)
        {
              word = yylex();
              if(!Expr())
                Fail();
              if(word != TOKEN_RIGHTPAREN)
                 Fail();
              word = yylex();
              success = true;
        }                                                   /* Factor → num */ 
        else if(word == TOKEN_NUMBER || word == TOKEN_NAME)/* Factor → name */
        {
              fprintf(spOut,"\tpush dword %s\t\t; Push constant %s\n",yytext,yytext);
              word = yylex();
              success = true;
        }
        else
        {
             Fail();
        }
        
return success;
}


/* Term′→ x Factor Term′ */
/* Term′→ ÷ Factor Term′ */
bool TPrime(void)
{
          bool success = false;
          if(word == TOKEN_MULTIPLY)
        {
          word = yylex();
          if(Factor())
          {
              fprintf(spOut,"\t%s\n","pop eax");//multiplicand
              fprintf(spOut,"\t%s\n","pop ebx");//multiplier
              fprintf(spOut,"\t%s\n","mul ebx");//MUL eax by ebx
              //fprintf(spOut,"\t%s\n","push edx");//lower 32-bits
              fprintf(spOut,"\t%s\n","push eax");//upper 32-bits
              return TPrime();
          }
          else
          {
              Fail();
          }
         }
          else if(word == TOKEN_DIVIDE)
         {
              word = yylex();
              if(Factor())
              {
                fprintf(spOut,"\t%s\n","pop edx");// dividend
                fprintf(spOut,"\t%s\n","pop ecx");// divisor
                fprintf(spOut,"\t%s\n","div ecx");//
                //printf(spOut,"\t%s\n","push edx");//edx = remainder
                fprintf(spOut,"\t%s\n","push eax");//eax = quotient
                return TPrime();
               }
               else
              {
                Fail();
              }
        }
        else if(word == TOKEN_PLUS || word == TOKEN_MINUS || word == TOKEN_RIGHTPAREN || word == TOKEN_EOF)
        {
             success = true;/* Term → ε */
        }
        else
        {
            Fail();
        }
        
return success;

}

/* Term → Factor Term′ */
bool Term(void)
{
    bool success = false;
    if(Factor())
        return TPrime();
    else
        Fail();
    return success;
}
int yywrap(void)
{ return 1; }
