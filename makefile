LIBNAME = Example
TARGET = $(LIBNAME)Test.out
TARGETLIBRARY = Lib$(LIBNAME).a
LIBS = -lCppUTest -lCppUTestExt -pthread -l$(LIBNAME)
INCLUDES = -IInterface
CC = gcc
CXX = gcc
CPPFLAGS = $(INCLUDES) -Wall -Werror -MMD -MP
CFLAGS = -g 
CXXFLAGS = -g -std=c++17
SOURCEDIR = Source
SOURCES := $(shell find $(SOURCEDIR) -name '*.cpp')
OBJECTS = $(patsubst %.cpp, %.o, $(SOURCES))
TESTDIR = Tests
TESTSOURCES := $(shell find $(TESTDIR) -name '*.cpp')
TESTOBJECTS = $(patsubst %.cpp, %.o, $(TESTSOURCES))
DEPS := $(OBJECTS:.o=.d) $(TESTOBJECTS:.o=.d)

vpath %.c $(dir $(MAKEFILE_LIST))


.PHONY: all default clean run ci_run build

default: run

all: run 

build: $(TARGET)

run: $(TARGET)
	./$<

ci_run: $(TARGET)
	./$< -ojunit

$(TARGET): $(TARGETLIBRARY) $(TESTOBJECTS)
	g++ $(TESTOBJECTS) $(CPPFLAGS) -L. $(LIBS) -o $@ -no-pie

$(TARGETLIBRARY): $(OBJECTS)
	$(AR) rs $@ $^

clean:
	find -regex '.*\.\(d\|a\|o\|xml\|out\|log\)' -delete

-include $(DEPS)