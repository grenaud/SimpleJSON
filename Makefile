# Change to whatever your C++ compiler is

ifeq ($(CXX),)
CXX := g++ #-g  -pg 
endif

ifeq ($(CC),)
CC := gcc #-g  -pg 
endif


ifeq ($(OS),Windows_NT)
	detectedOS := Windows
	TESTCMD=if exist 
else
	detectedOS := $(shell sh -c 'uname 2>/dev/null || echo Unknown')
	TESTCMD=test -f 
endif

# Compile settings
CFLAGS=-c -Wall -fPIC
LFLAGS=-lm

# Source files
LIBAR=obj/libsimplejson.a
LIBARDL=obj/libsimplejson.so
SOURCES=src/JSON.cpp src/JSONValue.cpp src/demo/nix-main.cpp src/demo/example.cpp src/demo/testcases.cpp
HEADERS=src/JSON.h src/JSONValue.h
OBJECTS=$(SOURCES:src/%.cpp=obj/%.o)
OBJECTSAR=$(HEADERS:src/%.h=obj/%.o)

# Output
EXECUTABLE=JSONDemo

all:	$(SOURCES) $(EXECUTABLE) $(LIBAR)

dynamic: all
	$(CXX) -shared -o $(LIBARDL)  $(OBJECTSAR)

$(EXECUTABLE):	$(OBJECTS) 
		$(CXX) $(LFLAGS) $(OBJECTS) -o $@

$(LIBAR):	$(EXECUTABLE)
		ar cr $(LIBAR) $(OBJECTSAR)

obj/%.o:	src/%.cpp $(HEADERS)
		@test -d $(@D) || mkdir -p $(@D)
		$(CXX) $(CFLAGS) $(@:obj/%.o=src/%.cpp) -o $@


clean:
		rm -f $(OBJECTS) $(EXECUTABLE) $(LIBAR)

test:
	@echo $(detectedOS)
	$(TESTCMD) $(LIBAR)
	$(TESTCMD) $(LIBARDL)
