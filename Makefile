CC := gcc

CPPFLAGS := -g -O2

override CPPFLAGS += -DHAVE_CONFIG_H -Iapi -Icommon -Icheck -Ilz -Irangecoder -Ilzma -Idelta -Isimple -Icommon -Ixz -I. -pthread -fvisibility=hidden

# CPPFLAGS += -Wall -Wextra -Wvla -Wformat=2 -Winit-self -Wmissing-include-dirs -Wshift-overflow=2 -Wstrict-overflow=3 -Walloc-zero -Wduplicated-cond -Wfloat-equal -Wundef -Wshadow -Wpointer-arith -Wbad-function-cast -Wwrite-strings -Wdate-time -Wsign-conversion -Wfloat-conversion -Wlogical-op -Waggregate-return -Wstrict-prototypes -Wold-style-definition -Wmissing-prototypes -Wmissing-declarations -Wredundant-decls

COND_SYMVERS_LINUX := 1
# COND_SYMVERS_GENERIC := 1

CPUCORES_METHOD := SCHED_GETAFFINITY
# CPUCORES_METHOD := CPUSET
# CPUCORES_METHOD := SYSCTL
# CPUCORES_METHOD := SYSCONF
# CPUCORES_METHOD := PSTAT_GETDYNAMIC

override CPPFLAGS += -DTUKLIB_CPUCORES_$(CPUCORES_METHOD)

# PHYSMEM_METHOD := AIX
PHYSMEM_METHOD := SYSCONF
# PHYSMEM_METHOD := SYSCTL
# PHYSMEM_METHOD := GETSYSINFO
# PHYSMEM_METHOD := PSTAT_GETSTATIC
# PHYSMEM_METHOD := GETINVENT_R
# PHYSMEM_METHOD := SYSINFO

override CPPFLAGS += -DTUKLIB_PHYSMEM_$(PHYSMEM_METHOD)

override CPPFLAGS += -DTUKLIB_FAST_UNALIGNED_ACCESS
override CPPFLAGS += -DTUKLIB_SYMBOL_PREFIX=lzma_

override LDLIBS += -lpthread
override LDFLAGS += -Wl,-soname -Wl,liblzma.so.5 -Wl,--no-undefined

ifdef COND_SYMVERS_GENERIC
override LDFLAGS += -Wl,--version-script=liblzma_generic.map
endif

ifdef COND_SYMVERS_LINUX
override LDFLAGS += -Wl,--version-script=liblzma_linux.map
endif

objects := xz/tuklib_physmem.o \
	   xz/tuklib_cpucores.o

objects += common/common.o \
	   common/block_util.o \
	   common/easy_preset.o \
	   common/filter_common.o \
	   common/hardware_physmem.o \
	   common/index.o \
	   common/stream_flags_common.o \
	   common/string_conversion.o \
	   common/vli_size.o \
	   common/hardware_cputhreads.o \
	   common/outqueue.o \
	   common/alone_encoder.o \
	   common/block_buffer_encoder.o \
	   common/block_encoder.o \
	   common/block_header_encoder.o \
	   common/easy_buffer_encoder.o \
	   common/easy_encoder.o \
	   common/easy_encoder_memusage.o \
	   common/filter_buffer_encoder.o \
	   common/filter_encoder.o \
	   common/filter_flags_encoder.o \
	   common/index_encoder.o \
	   common/stream_buffer_encoder.o \
	   common/stream_encoder.o \
	   common/stream_flags_encoder.o \
	   common/vli_encoder.o \
	   common/stream_encoder_mt.o \
	   common/microlzma_encoder.o \
	   common/alone_decoder.o \
	   common/auto_decoder.o \
	   common/block_buffer_decoder.o \
	   common/block_decoder.o \
	   common/block_header_decoder.o \
	   common/easy_decoder_memusage.o \
	   common/file_info.o \
	   common/filter_buffer_decoder.o \
	   common/filter_decoder.o \
	   common/filter_flags_decoder.o \
	   common/index_decoder.o \
	   common/index_hash.o \
	   common/stream_buffer_decoder.o \
	   common/stream_decoder.o \
	   common/stream_flags_decoder.o \
	   common/vli_decoder.o \
	   common/stream_decoder_mt.o \
	   common/microlzma_decoder.o \
	   common/lzip_decoder.o

objects += check/check.o \
	   check/crc32_table.o \
	   check/crc32_fast.o \
	   check/crc64_table.o \
	   check/crc64_fast.o \
	   check/sha256.o

objects += lz/lz_encoder.o \
	   lz/lz_encoder_mf.o \
	   lz/lz_decoder.o

objects += lzma/lzma_encoder_presets.o \
	   lzma/lzma_encoder.o \
	   lzma/lzma_encoder_optimum_fast.o \
	   lzma/lzma_encoder_optimum_normal.o \
	   lzma/fastpos_table.o \
	   lzma/lzma_decoder.o \
	   lzma/lzma2_encoder.o \
	   lzma/lzma2_decoder.o

objects += rangecoder/price_table.o

objects += delta/delta_common.o \
	   delta/delta_encoder.o \
	   delta/delta_decoder.o

objects += simple/simple_coder.o \
	   simple/simple_encoder.o \
	   simple/simple_decoder.o \
	   simple/x86.o \
	   simple/powerpc.o \
	   simple/ia64.o \
	   simple/arm.o \
	   simple/armthumb.o \
	   simple/arm64.o \
	   simple/sparc.o \
	   simple/riscv.o

all: liblzma.so liblzma.so.5

liblzma.so: $(objects)

liblzma.so.5:
	ln -s liblzma.so $@

%.so: override CPPFLAGS += -fPIC

%.so:
	$(CC) -shared $(LDFLAGS) $^ $(LDLIBS) -o $@
