# ==========================================
#   Unity Project - A Test Framework for C
#   Copyright (c) 2007 Mike Karlesky, Mark VanderVoord, Greg Williams
#   [Released under MIT License. Please refer to license.txt for details]
# ==========================================

#We try to detect the OS we are running on, and adjust commands as needed
ifeq ($(OS),Windows_NT)
  ifeq ($(shell uname -s),) # not in a bash-like shell
	CLEANUP = del /F /Q
	MKDIR = mkdir
  else # in a bash-like shell, like msys
	CLEANUP = rm -f
	MKDIR = mkdir -p
  endif
	TARGET_EXTENSION=.exe
else
	CLEANUP = rm -f
	MKDIR = mkdir -p
	TARGET_EXTENSION=.out
endif

CC=gcc
ifeq ($(shell uname -s), Darwin)
CC=clang
endif

UNITY_ROOT=test/Unity

CFLAGS=-std=c99
CFLAGS += -Wall
CFLAGS += -Wextra
CFLAGS += -Wpointer-arith
CFLAGS += -Wcast-align
CFLAGS += -Wwrite-strings
CFLAGS += -Wswitch-default
CFLAGS += -Wunreachable-code
CFLAGS += -Winit-self
CFLAGS += -Wmissing-field-initializers
CFLAGS += -Wno-unknown-pragmas
CFLAGS += -Wstrict-prototypes
CFLAGS += -Wundef
CFLAGS += -Wold-style-definition
#CFLAGS += -Wno-misleading-indentation

TARGET_BASE1=all_tests
TARGET1 = $(TARGET_BASE1)$(TARGET_EXTENSION)


BUILDDIR := build
SOURCEDIR := src
TEST_SOURCEDIR := test

# Get list of object files, with paths
SOURCES := $(shell find $(SOURCEDIR) -name '*.c')
OBJECTS := $(addprefix $(BUILDDIR)/,$(SOURCES:%.c=%.o))


TEST_SOURCES := $(shell find $(TEST_SOURCEDIR) -name '*.c')
TEST_OBJECTS := $(addprefix $(BUILDDIR)/,$(TEST_SOURCES:%.c=%.o))


UNITY_FILES=\
  $(UNITY_ROOT)/src/unity.c \
  $(UNITY_ROOT)/extras/fixture/src/unity_fixture.c \
  $(UNITY_ROOT)/extras/memory/src/unity_memory.c

INC_DIRS=-Isrc -Iinc -I$(UNITY_ROOT)/src -I$(UNITY_ROOT)/extras/fixture/src -I$(UNITY_ROOT)/extras/memory/src

SYMBOLS=-DUNITY_FIXTURE_NO_EXTRAS

all: clean default

default: $(OBJECTS) $(TEST_OBJECTS)
	$(CC) $(CFLAGS) $(INC_DIRS) $(OBJECTS) $(TEST_OBJECTS) $(SYMBOLS) -o $(TARGET1)
	- ./$(TARGET1) -v

$(BUILDDIR)/%.o: %.c
	mkdir -p $(BUILDDIR)/src
	mkdir -p $(BUILDDIR)/test/Unity/src
	mkdir -p $(BUILDDIR)/test/Unity/extras/fixture/src/
	mkdir -p $(BUILDDIR)/test/Unity/extras/memory/src/
	$(CC) $(CFLAGS) $(LDFLAGS) $(INC_DIRS) -I$(dir $<) -c $<  -o $@

clean:
	$(CLEANUP) $(TARGET1)
	$(CLEANUP)  -rf $(BUILDDIR)

ci: CFLAGS += -Werror
ci: default
