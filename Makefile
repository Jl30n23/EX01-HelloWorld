# A sample Makefile for building Google Test and using it in user
# tests.  Please tweak it to suit your environment and project.  You
# may want to move it to your project's root directory.
#
# SYNOPSIS:
#
#   make [all]  - makes everything.
#   make TARGET - makes the given target.
#   make clean  - removes all files generated by make.

# Please tweak the following variable definitions as needed by your
# project, except GTEST_HEADERS, which you can use in your own targets
# but shouldn't modify.

# Points to the root of Google Test, relative to where this file is.
# Remember to tweak this if you move this file.
GTEST_DIR = .

# Where to find user code.
USER_DIR = ./src
INC_DIR = ./include
LIB_DIR = ./lib
BIN_DIR = ./bin
BUILD_DIR = ./build

# Flags passed to the preprocessor.
# Set Google Test's header directory as a system directory, such that
# the compiler doesn't generate warnings in Google Test headers.
CPPFLAGS += -isystem $(GTEST_DIR)/include

# Flags passed to the C++ compiler.
CXXFLAGS += -g -Wall -Wextra

ASSIGNMENT = helloworld

# All tests produced by this Makefile.  Remember to add new tests you
# created to the list.
TESTS = $(BIN_DIR)/$(ASSIGNMENT)_unittest

# All Google Test headers.  Usually you shouldn't change this
# definition.
GTEST_HEADERS = $(GTEST_DIR)/include/gtest/*.h \
                $(GTEST_DIR)/include/gtest/internal/*.h

# House-keeping build targets.

all : $(TESTS) $(BIN_DIR)/$(ASSIGNMENT)

clean :
	rm -rf $(TESTS) $(ASSIGNMENT) output/ $(BIN_DIR) $(BUILD_DIR)

# Builds gtest.a and gtest_main.a.

# Builds a sample test.  A test should link with either gtest.a or
# gtest_main.a, depending on whether it defines its own main()
# function.

$(BIN_DIR)/$(ASSIGNMENT) : $(BUILD_DIR)/$(ASSIGNMENT).o | bin build
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -o $(ASSIGNMENT) $^ -o $@

assignment : $(BIN_DIR)/$(ASSIGNMENT)

run : $(BIN_DIR)/$(ASSIGNMENT)
	$(BIN_DIR)/$(ASSIGNMENT)

$(BUILD_DIR)/$(ASSIGNMENT).o : $(USER_DIR)/$(ASSIGNMENT).cc $(INC_DIR)/$(ASSIGNMENT).h $(GTEST_HEADERS) | build
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $(USER_DIR)/$(ASSIGNMENT).cc -o $@

$(BUILD_DIR)/$(ASSIGNMENT)_unittest.o : $(USER_DIR)/$(ASSIGNMENT)_unittest.cc $(INC_DIR)/$(ASSIGNMENT).h $(GTEST_HEADERS) | build
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $(USER_DIR)/$(ASSIGNMENT)_unittest.cc -o $@

$(BIN_DIR)/$(ASSIGNMENT)_unittest : $(BUILD_DIR)/$(ASSIGNMENT).o $(BUILD_DIR)/$(ASSIGNMENT)_unittest.o | bin build
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -e__Z9test_mainiPPc -lpthread -lgtests -L$(LIB_DIR) $^ -o $@

tester : $(BIN_DIR)/$(ASSIGNMENT)_unittest

test : $(BIN_DIR)/$(ASSIGNMENT)_unittest
	$(BIN_DIR)/$(ASSIGNMENT)_unittest

run_jenkins_tester : $(BIN_DIR)/$(ASSIGNMENT)_unittest
	./$(ASSIGNMENT)_unittest --gtest_output=xml:output/result.xml

bin:
	-mkdir $(BIN_DIR) &2>/dev/null

build:
	-mkdir $(BUILD_DIR) &2>/dev/null
	
.PHONY : assignment tester run test

