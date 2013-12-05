CC	= gcc
CFLAGS	= -O3
SRCS	= lda.c learn.c vbem.c newton.c likelihood.c writer.c feature.c \
	  dmatrix.c gamma.c util.c
OBJS	= $(SRCS:.c=.o)
HEADERS	= $(SRCS:.c=.h)
LDFLAGS	= -lm
VERSION	= 0.2
PKGNAME	= lda-$(VERSION)
DISTDIR	= ../dist
DISTFILES = $(SRCS) $(HEADERS) Makefile train train.lex AUTHOR README

all: depend lda

lda: $(OBJS)
	$(CC) $(CFLAGS) -o $@ $(OBJS) $(LDFLAGS)
.c.o:
	$(CC) $(CFLAGS) -c $<

depend:
	@$(CC) -MM $(SRCS) > .depend
clean:
	@rm -f .depend $(OBJS)
pkg:
	@[ -d $(PKGNAME) ] || mkdir $(PKGNAME)
	@cp -p $(DISTFILES) $(PKGNAME)
	@tar cvfz $(DISTDIR)/$(PKGNAME).tar.gz $(PKGNAME)
	@rm -r $(PKGNAME)

-include .depend
