TARGET = tests.out
LIBS = -lCppUTest -lCppUTestExt -lgtest -lgtest_main -pthread
CC = gcc
CXX = gcc
CPPFLAGS = -Wall -Werror -MMD -MP
CFLAGS = -g 
CXXFLAGS = -g -std=c++17
SOURCES := $(shell find $(SOURCEDIR) -name '*.cpp')
OBJECTS = $(patsubst %.cpp, %.o, $(SOURCES))
DEPS := $(OBJECTS:.o=.d)

vpath %.c $(dir $(MAKEFILE_LIST))


.PHONY: all default clean run ci_run build

default: run

all: run 

build: $(TARGET)

run: $(TARGET)
	./$<

ci_run: $(TARGET)
	./$< -ojunit

$(TARGET): $(OBJECTS)
	g++ $(OBJECTS) $(CPPFLAGS) $(LIBS) -o $@ -no-pie

clean:
	$(RM) *.o
	$(RM) $(TARGET)
	$(RM) *.xml
	$(RM) $(DEPS)

-include $(DEPS)