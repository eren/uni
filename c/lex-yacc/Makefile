calc:     lex.yy.o y.tab.o
	cc -o calc lex.yy.o y.tab.o -ly -ll -lm -Wall
lex.yy.c:    calc.l y.tab.c
	flex calc.l
y.tab.c:     calc.y
	bison -vdty calc.y
clean:
	rm -f *.o
	rm -f *.tab.*
	rm -f lex.yy.c y.output
	rm -f calc
