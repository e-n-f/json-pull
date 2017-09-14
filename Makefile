PREFIX=/usr/local

all: jsoncat libjsonpull.a

install: jsonpull.h libjsonpull.a jsoncat
	cp jsonpull.h $(PREFIX)/include/jsonpull.h
	cp libjsonpull.a $(PREFIX)/lib/libjsonpull.a
	cp jsoncat $(PREFIX)/bin/jsoncat

clean:
	rm -f *.o jsoncat libjsonpull.a

jsoncat: jsoncat.o jsonpull.o
	cc -O3 -g -Wall -o $@ $^

jsoncat.o jsonpull.o: jsonpull.h

libjsonpull.a: jsonpull.o
	ar rc $@ $^
	ranlib $@

%.o: %.c
	cc -O3 -g -Wall -c $<

H = $(wildcard *.h) $(wildcard *.hpp)
C = $(wildcard *.c) $(wildcard *.cpp)

indent:
	clang-format -i -style="{BasedOnStyle: Google, IndentWidth: 8, UseTab: Always, AllowShortIfStatementsOnASingleLine: false, ColumnLimit: 0, ContinuationIndentWidth: 8, SpaceAfterCStyleCast: true, IndentCaseLabels: false, AllowShortBlocksOnASingleLine: false, AllowShortFunctionsOnASingleLine: false, SortIncludes: false}" $(C) $(H)
