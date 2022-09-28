LIBNAME = Example
TARGET = $(LIBNAME)Test.out
TARGETLIBRARY = lib$(LIBNAME).a
LDLIBS = -lCppUTest -lCppUTestExt -pthread -l$(LIBNAME)
LDFLAGS = -L.
INCLUDES = -IInterface
CC = gcc
CXX = gcc
CPPFLAGS += $(DEBUGFLAGS) $(INCLUDES) -Wall -Werror -MMD -MP
CFLAGS =  
CXXFLAGS = -std=c++17
SOURCEDIR = Source
SOURCES := $(shell find $(SOURCEDIR) -name '*.cpp')
OBJECTS = $(patsubst %.cpp, %.o, $(SOURCES))
TESTDIR = Tests
TESTSOURCES := $(shell find $(TESTDIR) -name '*.cpp')
TESTOBJECTS = $(patsubst %.cpp, %.o, $(TESTSOURCES))
DEPS := $(OBJECTS:.o=.d) $(TESTOBJECTS:.o=.d)

vpath %.c $(dir $(MAKEFILE_LIST))


.PHONY: all clean run ci_run build

all: run ci_run

build: $(TARGET)

run: $(TARGET)
	./$<

ci_run: $(TARGET)
	./$< -ojunit

$(TARGET): $(TARGETLIBRARY) $(TESTOBJECTS)
	g++ $(LDFLAGS) $(TESTOBJECTS) $(LOADLIBES) $(LDLIBS) -o $@

$(TARGETLIBRARY): $(OBJECTS)
	$(AR) rs $@ $^

clean:
	find -regex '.*\.\(d\|a\|o\|xml\|out\|log\)' -delete

-include $(DEPS)