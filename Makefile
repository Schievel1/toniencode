CC ?= gcc

INCLUDES = \
	-Iinclude \
	-Iinclude/protobuf-c \
	-Isrc/proto/

SRC_DIR := src
OBJ_DIR := obj
OBJ_EXT := .o

EXECUTABLE := toniencode
CLEAN_FILES += $(EXECUTABLE)

SOURCES = \
	$(wildcard $(SRC_DIR)/*.c) \
	$(wildcard $(SRC_DIR)/proto/*.c)

CFLAGS += $(INCLUDES)
CFLAGS += -Wno-error=stringop-overflow= -Wno-error=stringop-overread

LDFLAGS += -lm -lopus -logg -lprotobuf-c

PROTO_DIR := proto
PROTO_GEN_DIR := src/proto

PROTO_FILES := $(wildcard $(PROTO_DIR)/*.proto)
PROTO_C_FILES := $(patsubst $(PROTO_DIR)/%.proto, $(PROTO_GEN_DIR)/$(PROTO_DIR)/%.pb-c.c, $(PROTO_FILES))
PROTO_H_FILES := $(patsubst $(PROTO_DIR)/%.proto, $(PROTO_GEN_DIR)/$(PROTO_DIR)/%.pb-c.h, $(PROTO_FILES))

$(PROTO_GEN_DIR)/$(PROTO_DIR)/%.pb-c.c $(PROTO_GEN_DIR)/$(PROTO_DIR)/%.pb-c.h: $(PROTO_DIR)/%.proto
	protoc-c --c_out=$(PROTO_GEN_DIR) $<

SOURCES += $(PROTO_C_FILES)
CLEAN_FILES += $(PROTO_C_FILES) $(PROTO_H_FILES)

OBJECTS = $(patsubst $(SRC_DIR)/%.c,$(OBJ_DIR)/%.o,$(SOURCES))
CLEAN_FILES += $(OBJECTS)

all: proto build

build: $(OBJECTS)
	$(CC) $(CFLAGS) $^ -o $(EXECUTABLE) $(LDFLAGS)

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c
	mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

proto: $(PROTO_C_FILES)

clean:
	echo 'Cleaning...'
	rm -f $(CLEAN_FILES)
