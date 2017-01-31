PREFIX=/usr/local

all: jsoncat libjsonpull.a

install: jsonpull.h libjsonpull.a jsoncat
	cp jsonpull.h $(PREFIX)/include/jsonpull.h
	cp libjsonpull.a $(PREFIX)/lib/libjsonpull.a
	cp jsoncat $(PREFIX)/bin/jsoncat

jsoncat: jsoncat.o jsonpull.o
	cc -g -Wall -o $@ $^

jsoncat.o jsonpull.o: jsonpull.h

libjsonpull.a: jsonpull.o
	ar rc $@ $^
	ranlib $@

%.o: %.c
	cc -g -Wall -c $<
