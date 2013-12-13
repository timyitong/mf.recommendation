# Recommend using Intel C++ compiler
CC=icpc
LD=icpc

ARCH = $(shell uname)
ARCH := $(patsubst i%86,i386,$(ARCH))

ifeq ($(ARCH),i386)
CCFLAGS=-03 -Wall -Wno-sign-compare
#CCFLAGS=-g -Wall
LIBS=$(LIBDIR) -lm
endif

ifeq ($(ARCH),Darwin)
CCFLAGS=-O3 -Wall -Wno-sign-compare
#CCFLAGS=-g -Wall -Wno-sign-compare
LIBS=$(LIBDIR) -lm
endif

ifeq ($(ARCH),Linux)

# Insert appropriate optimization flags (the ones here are for icpc
# and Intel Core2 CPU)
CCFLAGS = -axT -O3 -no-prec-div -Wbrief -DINTEL -DVERBOSE
#CCFLAGS= -ggdb -Wbrief -DINTEL -DVERBOSE

# Depends on BLAS library for optimized matrix operations (these use
# the implementation in Intel's Math Kernel Library)
LIBS=-lmkl_ia32 -lguide

endif

CCFILES=test.cc nmf.cc mat.cc
OBJFILES=$(CCFILES:.cc=.o)

all: nmf_test

%.o: %.cc
	$(CC) -c $< -o $@ $(CCFLAGS)

nmf_test: $(OBJFILES)
	$(LD) -o nmf_test $(OBJFILES) $(LIBS)

clean:
	/bin/rm -f *.o *~ \#*\# nmf_test
