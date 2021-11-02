SRCDIR		= ./src 

ifeq ($(STATIC_ENABLED), 1)
TARGET = libgo2.a
else
TARGET = libgo2.so
endif

CFLAGS		+= -D_GNU_SOURCE -DHAVE_LIBC -D_REENTRANT -Isrc
CFLAGS		+= -Iinclude -std=gnu99 $(shell $(PKG_CONFIG) --cflags libdrm) $(shell $(PKG_CONFIG) --cflags libpng)

VPATH		= $(SRCDIR)
SRC_C		= $(foreach dir, $(SRCDIR), $(wildcard $(dir)/*.c))
OBJ_C		= $(notdir $(patsubst %.c, %.o, $(SRC_C)))
OBJS		= $(OBJ_C)

all: $(TARGET)

# Rules to make executable
$(TARGET): $(OBJS)  
ifeq ($(STATIC_ENABLED), 1)
	$(AR) rcs $(TARGET) $^
else
	$(CC) -shared $(CFLAGS) $^ -o $@ -ldl -ludev -ldrm $(LDFLAGS)
endif

$(OBJ_C) : %.o : %.c
	$(CC) $(CFLAGS) -c -o $@ $<

install:
	cp $(TARGET) $(DESTDIR)/$(TARGET)
	
install-headers:
	cp -rp src/*.h $(DESTDIR)$(PREFIX)/include/go2

install-lib:
	cp $(TARGET) $(DESTDIR)$(PREFIX)/lib/

install: $(TARGET) install-headers install-lib

clean:
	rm -f $(TARGET) *.o *.a *.so
