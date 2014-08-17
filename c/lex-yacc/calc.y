/*
 * Copyright (C) 2014  Eren Türkay <turkay.eren@gmail.com>
 * 
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
 * 02110-1301, USA.
 */

/*

Design and Report
=================

COMP 412 Homework II

Eren Turkay <turkay.eren@gmail.com>
Istanbul Bilgi University,
Departmant of Computer Science.

2014-03-14

This section of code describes the design choice for solving the
problem. The original idea of using the stack for pushing the numbers
and popping them after was kept. However, as there will be new type for
floating numbers, a new regular expression was written in calc.l that
recognizes floating point numbers.

The first design did not differentiate between integers and floats in
both lexer and parser. So, union type was added in calc.y and tokens
were marked as either integer or float. So, when lexer recognized an
integer or float, it marked the value accordingly by putting yylval.ival
(for integers), or yylval.fval (for floats).

When we have different types of numbers, a new data structure for
holding them was needed. Thus, number_t was created that holds the type
of the data and the value. Integers are kept as a float in this data
sturcture and they are casted when needed. For example, when T_Int is
seen, the value is cast to float and pushed onto the stack.

So, the stack was needed to be updated that operates on number_t data
structure. Instead of putting simply ints in the stack, number_t is put
on the stack and operated. Instead of calculating the result in the
grammar like (| E E '+' { Push(pop() + pop())}", new functions were
added for the operations. These functions operated on number_t data
structure that distinquish between floating point numbers and integers.
If both of the operands are integers, the resulting number is marked as
integer, however, if either of the operands are floats, the result is
marked as float.

Lastly, new function print_top() was created that shows the result. If
the result coming from calc_* methods is integer, only the integer part
is written. However, if the result is float, the float is printed with
precision of 5 after the dot.

At first, there seems to be code duplication arising from the same
design choice. All of these calc_* methods could be put in one function
that takes another operation function as a parameter and produces
the result. If it were a functional programming language like Racket, it
would be easily done. However, it is a little bit hard to implement this
just to save a few lines of code in C.
*/


%{
   #include <stdio.h>
   #include <math.h>
   #include <assert.h>

/* Data structures to hold the number and compare accordingly to */
/* their type. */
typedef struct {
    enum { INT, FLOAT } type;

    // float is big enough to hold the integer. When the type is int in
    // the number, we print only the integer part. All the calculations
    // are done as a float type.
    float value;
} number_t;

static number_t Pop();
static number_t Top();
static void Push(number_t val);
static void calc_add(number_t op1, number_t op2);
static void calc_mul(number_t op1, number_t op2);
static void calc_div(number_t op1, number_t op2);
static void calc_subs(number_t op1, number_t op2);
static void calc_exp(number_t op1, number_t op2);
static void print_top();
%}

%union {
    int ival;
    float fval;
}

%token <ival> T_Int
%token <fval> T_Float

%%
S    :  S E '\n' { print_top(); }
     |
     ;
E    :  E E '+' { calc_add(Pop(), Pop()); }
     |  E E '*' { calc_mul(Pop(), Pop()); }
     |  E E '/' { calc_div(Pop(), Pop()); }
     |  E E '-' { calc_subs(Pop(), Pop()); }
     |  E E '^' { calc_exp(Pop(), Pop()); }
     |  T_Int   {
        number_t number;
        number.type = INT;
        number.value = (float)yyval.ival;

        Push(number);
        }
     |  T_Float {
        number_t number;
        number.type = FLOAT;
        number.value = yyval.fval;

        Push(number);
        }
     ;
                                                  
%%

/**********************************************************************/
/*  S t a c k   i m p l e m e n t a t i o n                           */
/**********************************************************************/
static number_t stack[100];
int count = 0;

static number_t Pop() {
    assert(count > 0);
    return stack[--count];
}
static number_t Top() {
    assert(count > 0);
    return stack[count-1];
}
static void Push(number_t val) {
    assert(count < sizeof(stack)/sizeof(*stack));
    stack[count++] = val;
}


/**********************************************************************/
/*  C a l c u l a t o r   f u n c t i o n s                           */
/**********************************************************************/
static void calc_add(number_t op1, number_t op2)
{
    // calculate the result accordingly to their type and push
    // it onto the stack.
    if (op1.type == INT && op2.type == INT) {
        number_t number;
        number.type = INT;
        number.value = op1.value + op2.value;

        Push(number);
    } else {
        // either one of the operator is float, so the result will be
        // float. Mark it and do the calculation.
        number_t number;
        number.type = FLOAT;
        number.value = op1.value + op2.value;

        Push(number);
    }
}

static void calc_mul(number_t op1, number_t op2)
{
    if (op1.type == INT && op2.type == INT) {
        number_t number;
        number.type = INT;
        number.value = op1.value * op2.value;

        Push(number);
    } else {
        number_t number;
        number.type = FLOAT;
        number.value = op1.value * op2.value;

        Push(number);
    }
}

static void calc_div(number_t op1, number_t op2)
{
    if (op1.type == INT && op2.type == INT) {
        number_t number;
        number.type = INT;
        number.value = op1.value / op2.value;

        Push(number);
    } else {
        number_t number;
        number.type = FLOAT;
        number.value = op1.value / op2.value;

        Push(number);
    }
}

static void calc_subs(number_t op1, number_t op2)
{
    if (op1.type == INT && op2.type == INT) {
        number_t number;
        number.type = INT;
        number.value = op1.value - op2.value;

        Push(number);
    } else {
        number_t number;
        number.type = FLOAT;
        number.value = op1.value - op2.value;

        Push(number);
    }
}

static void calc_exp(number_t op1, number_t op2)
{
    if (op1.type == INT && op2.type == INT) {
        number_t number;
        number.type = INT;
        number.value = pow(op1.value, op2.value);

        Push(number);
    } else {
        number_t number;
        number.type = FLOAT;
        number.value = pow(op1.value, op2.value);

        Push(number);
    }
}

static void print_top() {
    number_t number = Top();

    // print only the integer part
    if (number.type == INT) {
        printf("= %.0f\n", number.value);
    } else if (number.type == FLOAT) {
        printf("= %.5f\n", number.value);
    }
}

// We need yyerror() defined due to bison bug in Ubuntu 12.04 LTS.
// Please see the link for more information:
//
// https://lists.gnu.org/archive/html/help-bison/2012-01/msg00016.html
int yyerror (char const *message) {
    fputs(message, stderr);
    fputc('\n', stderr);
    return 0;
}

int main() {
   return yyparse();
}
