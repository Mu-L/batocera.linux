################################################################################
#
# ffmpeg-rockchip
#
################################################################################
# Keep the version aligned to buildroot ffmpeg 
# We overwrite that version for hwaccel
# Version: Commits on Jul 4, 2025 (7.1 branch)
FFMPEG_ROCKCHIP_VERSION = a8c04e01e7d3bed7efb086ac8b51045bedd08a0d
FFMPEG_ROCKCHIP_SITE = https://github.com/nyanmisaka/ffmpeg-rockchip.git
FFMPEG_ROCKCHIP_SITE_METHOD = git
FFMPEG_ROCKCHIP_GIT_SUBMODULES = YES
FFMPEG_ROCKCHIP_LICENSE = LGPL-2.1+, libjpeg license
FFMPEG_ROCKCHIP_LICENSE_FILES = LICENSE.md COPYING.LGPLv2.1
ifeq ($(BR2_PACKAGE_FFMPEG_ROCKCHIP_GPL),y)
FFMPEG_ROCKCHIP_LICENSE += and GPL-2.0+
FFMPEG_ROCKCHIP_LICENSE_FILES += COPYING.GPLv2
endif

FFMPEG_ROCKCHIP_DEPENDENCIES = ffmpeg

FFMPEG_ROCKCHIP_INSTALL_STAGING = YES

FFMPEG_ROCKCHIP_CPE_ID_VENDOR = ffmpeg

FFMPEG_ROCKCHIP_CONF_OPTS = \
	--prefix=/usr \
	--enable-avfilter \
	--disable-version3 \
	--enable-logging \
	--enable-optimizations \
	--disable-extra-warnings \
	--enable-avdevice \
	--enable-avcodec \
	--enable-avformat \
	--enable-network \
	--disable-gray \
	--enable-swscale-alpha \
	--disable-small \
	--disable-dxva2 \
	--enable-runtime-cpudetect \
	--disable-hardcoded-tables \
	--disable-mipsdsp \
	--disable-mipsdspr2 \
	--disable-msa \
	--enable-hwaccels \
	--disable-cuda \
	--disable-cuvid \
	--disable-nvenc \
	--disable-avisynth \
	--disable-frei0r \
	--disable-libopencore-amrnb \
	--disable-libopencore-amrwb \
	--disable-libdc1394 \
	--disable-libgsm \
	--disable-libilbc \
	--disable-libvo-amrwbenc \
	--disable-symver \
	--disable-doc

# batocera - ensure rockchip hwaccel is enabled
ifeq ($(BR2_PACKAGE_ROCKCHIP_RGA)$(BR2_PACKAGE_ROCKCHIP_MPP),yy)
FFMPEG_ROCKCHIP_CONF_OPTS += --enable-rkmpp --enable-rkrga --enable-version3
FFMPEG_ROCKCHIP_DEPENDENCIES += rockchip-rga rockchip-mpp
endif

# batocera - add pulse audio support for batocera-record
ifeq ($(BR2_PACKAGE_PULSEAUDIO),y)
FFMPEG_ROCKCHIP_CONF_OPTS += --enable-libpulse
FFMPEG_ROCKCHIP_DEPENDENCIES += pulseaudio
endif

# batocera - force dash demuxer & libxml2 for Kodi
FFMPEG_ROCKCHIP_CONF_OPTS += --enable-demuxer=dash
FFMPEG_ROCKCHIP_CONF_OPTS += --enable-libxml2

FFMPEG_ROCKCHIP_DEPENDENCIES += host-pkgconf

ifeq ($(BR2_PACKAGE_FFMPEG_ROCKCHIP_GPL),y)
FFMPEG_ROCKCHIP_CONF_OPTS += --enable-gpl
else
FFMPEG_ROCKCHIP_CONF_OPTS += --disable-gpl
endif

ifeq ($(BR2_PACKAGE_FFMPEG_ROCKCHIP_NONFREE),y)
FFMPEG_ROCKCHIP_CONF_OPTS += --enable-nonfree
else
FFMPEG_ROCKCHIP_CONF_OPTS += --disable-nonfree
endif

ifeq ($(BR2_PACKAGE_FFMPEG_ROCKCHIP_FFMPEG),y)
FFMPEG_ROCKCHIP_CONF_OPTS += --enable-ffmpeg
else
FFMPEG_ROCKCHIP_CONF_OPTS += --disable-ffmpeg
endif

ifeq ($(BR2_PACKAGE_FFMPEG_ROCKCHIP_FFPLAY),y)
FFMPEG_ROCKCHIP_DEPENDENCIES += sdl2
FFMPEG_ROCKCHIP_CONF_OPTS += --enable-ffplay
FFMPEG_ROCKCHIP_CONF_ENV += SDL_CONFIG=$(STAGING_DIR)/usr/bin/sdl2-config
else
FFMPEG_ROCKCHIP_CONF_OPTS += --disable-ffplay
endif

ifeq ($(BR2_PACKAGE_LIBV4L),y)
FFMPEG_ROCKCHIP_DEPENDENCIES += libv4l
FFMPEG_ROCKCHIP_CONF_OPTS += --enable-libv4l2
else
FFMPEG_ROCKCHIP_CONF_OPTS += --disable-libv4l2
endif

ifeq ($(BR2_PACKAGE_FFMPEG_ROCKCHIP_FFPROBE),y)
FFMPEG_ROCKCHIP_CONF_OPTS += --enable-ffprobe
else
FFMPEG_ROCKCHIP_CONF_OPTS += --disable-ffprobe
endif

ifeq ($(BR2_PACKAGE_FFMPEG_ROCKCHIP_XCBGRAB),y)
FFMPEG_ROCKCHIP_CONF_OPTS += \
	--enable-libxcb \
	--enable-libxcb-shape \
	--enable-libxcb-shm \
	--enable-libxcb-xfixes
FFMPEG_ROCKCHIP_DEPENDENCIES += libxcb
else
FFMPEG_ROCKCHIP_CONF_OPTS += --disable-libxcb
endif

ifeq ($(BR2_PACKAGE_FFMPEG_ROCKCHIP_POSTPROC),y)
FFMPEG_ROCKCHIP_CONF_OPTS += --enable-postproc
else
FFMPEG_ROCKCHIP_CONF_OPTS += --disable-postproc
endif

ifeq ($(BR2_PACKAGE_FFMPEG_ROCKCHIP_SWSCALE),y)
FFMPEG_ROCKCHIP_CONF_OPTS += --enable-swscale
else
FFMPEG_ROCKCHIP_CONF_OPTS += --disable-swscale
endif

ifneq ($(call qstrip,$(BR2_PACKAGE_FFMPEG_ROCKCHIP_ENCODERS)),all)
FFMPEG_ROCKCHIP_CONF_OPTS += --disable-encoders \
	$(foreach x,$(call qstrip,$(BR2_PACKAGE_FFMPEG_ROCKCHIP_ENCODERS)),--enable-encoder=$(x))
endif

ifneq ($(call qstrip,$(BR2_PACKAGE_FFMPEG_ROCKCHIP_DECODERS)),all)
FFMPEG_ROCKCHIP_CONF_OPTS += --disable-decoders \
	$(foreach x,$(call qstrip,$(BR2_PACKAGE_FFMPEG_ROCKCHIP_DECODERS)),--enable-decoder=$(x))
endif

ifneq ($(call qstrip,$(BR2_PACKAGE_FFMPEG_ROCKCHIP_MUXERS)),all)
FFMPEG_ROCKCHIP_CONF_OPTS += --disable-muxers \
	$(foreach x,$(call qstrip,$(BR2_PACKAGE_FFMPEG_ROCKCHIP_MUXERS)),--enable-muxer=$(x))
endif

ifneq ($(call qstrip,$(BR2_PACKAGE_FFMPEG_ROCKCHIP_DEMUXERS)),all)
FFMPEG_ROCKCHIP_CONF_OPTS += --disable-demuxers \
	$(foreach x,$(call qstrip,$(BR2_PACKAGE_FFMPEG_ROCKCHIP_DEMUXERS)),--enable-demuxer=$(x))
endif

ifneq ($(call qstrip,$(BR2_PACKAGE_FFMPEG_ROCKCHIP_PARSERS)),all)
FFMPEG_ROCKCHIP_CONF_OPTS += --disable-parsers \
	$(foreach x,$(call qstrip,$(BR2_PACKAGE_FFMPEG_ROCKCHIP_PARSERS)),--enable-parser=$(x))
endif

ifneq ($(call qstrip,$(BR2_PACKAGE_FFMPEG_ROCKCHIP_BSFS)),all)
FFMPEG_ROCKCHIP_CONF_OPTS += --disable-bsfs \
	$(foreach x,$(call qstrip,$(BR2_PACKAGE_FFMPEG_ROCKCHIP_BSFS)),--enable-bsf=$(x))
endif

ifneq ($(call qstrip,$(BR2_PACKAGE_FFMPEG_ROCKCHIP_PROTOCOLS)),all)
FFMPEG_ROCKCHIP_CONF_OPTS += --disable-protocols \
	$(foreach x,$(call qstrip,$(BR2_PACKAGE_FFMPEG_ROCKCHIP_PROTOCOLS)),--enable-protocol=$(x))
endif

ifneq ($(call qstrip,$(BR2_PACKAGE_FFMPEG_ROCKCHIP_FILTERS)),all)
FFMPEG_ROCKCHIP_CONF_OPTS += --disable-filters \
	$(foreach x,$(call qstrip,$(BR2_PACKAGE_FFMPEG_ROCKCHIP_FILTERS)),--enable-filter=$(x))
endif

ifeq ($(BR2_PACKAGE_FFMPEG_ROCKCHIP_INDEVS),y)
FFMPEG_ROCKCHIP_CONF_OPTS += --enable-indevs
ifeq ($(BR2_PACKAGE_ALSA_LIB),y)
FFMPEG_ROCKCHIP_CONF_OPTS += --enable-alsa
FFMPEG_ROCKCHIP_DEPENDENCIES += alsa-lib
else
FFMPEG_ROCKCHIP_CONF_OPTS += --disable-alsa
endif
else
FFMPEG_ROCKCHIP_CONF_OPTS += --disable-indevs
endif

ifeq ($(BR2_PACKAGE_FFMPEG_ROCKCHIP_OUTDEVS),y)
FFMPEG_ROCKCHIP_CONF_OPTS += --enable-outdevs
ifeq ($(BR2_PACKAGE_ALSA_LIB),y)
FFMPEG_ROCKCHIP_DEPENDENCIES += alsa-lib
endif
else
FFMPEG_ROCKCHIP_CONF_OPTS += --disable-outdevs
endif

ifeq ($(BR2_TOOLCHAIN_HAS_THREADS),y)
FFMPEG_ROCKCHIP_CONF_OPTS += --enable-pthreads
else
FFMPEG_ROCKCHIP_CONF_OPTS += --disable-pthreads
endif

ifeq ($(BR2_PACKAGE_ZLIB),y)
FFMPEG_ROCKCHIP_CONF_OPTS += --enable-zlib
FFMPEG_ROCKCHIP_DEPENDENCIES += zlib
else
FFMPEG_ROCKCHIP_CONF_OPTS += --disable-zlib
endif

ifeq ($(BR2_PACKAGE_BZIP2),y)
FFMPEG_ROCKCHIP_CONF_OPTS += --enable-bzlib
FFMPEG_ROCKCHIP_DEPENDENCIES += bzip2
else
FFMPEG_ROCKCHIP_CONF_OPTS += --disable-bzlib
endif

ifeq ($(BR2_PACKAGE_FDK_AAC)$(BR2_PACKAGE_FFMPEG_ROCKCHIP_NONFREE),yy)
FFMPEG_ROCKCHIP_CONF_OPTS += --enable-libfdk-aac
FFMPEG_ROCKCHIP_DEPENDENCIES += fdk-aac
else
FFMPEG_ROCKCHIP_CONF_OPTS += --disable-libfdk-aac
endif

ifeq ($(BR2_PACKAGE_FFMPEG_ROCKCHIP_GPL)$(BR2_PACKAGE_LIBCDIO_PARANOIA),yy)
FFMPEG_ROCKCHIP_CONF_OPTS += --enable-libcdio
FFMPEG_ROCKCHIP_DEPENDENCIES += libcdio-paranoia
else
FFMPEG_ROCKCHIP_CONF_OPTS += --disable-libcdio
endif

ifeq ($(BR2_PACKAGE_GNUTLS),y)
FFMPEG_ROCKCHIP_CONF_OPTS += --enable-gnutls --disable-openssl
FFMPEG_ROCKCHIP_DEPENDENCIES += gnutls
else
FFMPEG_ROCKCHIP_CONF_OPTS += --disable-gnutls
ifeq ($(BR2_PACKAGE_OPENSSL),y)
# openssl isn't license compatible with GPL
ifeq ($(BR2_PACKAGE_FFMPEG_ROCKCHIP_GPL)x$(BR2_PACKAGE_FFMPEG_ROCKCHIP_NONFREE),yx)
FFMPEG_ROCKCHIP_CONF_OPTS += --disable-openssl
else
FFMPEG_ROCKCHIP_CONF_OPTS += --enable-openssl
FFMPEG_ROCKCHIP_DEPENDENCIES += openssl
endif
else
FFMPEG_ROCKCHIP_CONF_OPTS += --disable-openssl
endif
endif

ifeq ($(BR2_PACKAGE_FFMPEG_ROCKCHIP_GPL)$(BR2_PACKAGE_LIBEBUR128),yy)
FFMPEG_ROCKCHIP_DEPENDENCIES += libebur128
endif

ifeq ($(BR2_PACKAGE_LIBDRM),y)
FFMPEG_ROCKCHIP_CONF_OPTS += --enable-libdrm
FFMPEG_ROCKCHIP_DEPENDENCIES += libdrm
else
FFMPEG_ROCKCHIP_CONF_OPTS += --disable-libdrm
endif

ifeq ($(BR2_PACKAGE_LIBOPENH264),y)
FFMPEG_ROCKCHIP_CONF_OPTS += --enable-libopenh264
FFMPEG_ROCKCHIP_DEPENDENCIES += libopenh264
else
FFMPEG_ROCKCHIP_CONF_OPTS += --disable-libopenh264
endif

ifeq ($(BR2_PACKAGE_LIBVORBIS),y)
FFMPEG_ROCKCHIP_DEPENDENCIES += libvorbis
FFMPEG_ROCKCHIP_CONF_OPTS += \
	--enable-libvorbis \
	--enable-muxer=ogg \
	--enable-encoder=libvorbis
endif

ifeq ($(BR2_PACKAGE_LIBVA),y)
FFMPEG_ROCKCHIP_CONF_OPTS += --enable-vaapi
FFMPEG_ROCKCHIP_DEPENDENCIES += libva
else
FFMPEG_ROCKCHIP_CONF_OPTS += --disable-vaapi
endif

ifeq ($(BR2_PACKAGE_LIBVDPAU),y)
FFMPEG_ROCKCHIP_CONF_OPTS += --enable-vdpau
FFMPEG_ROCKCHIP_DEPENDENCIES += libvdpau
else
FFMPEG_ROCKCHIP_CONF_OPTS += --disable-vdpau
endif

ifeq ($(BR2_PACKAGE_RPI_USERLAND),y)
FFMPEG_ROCKCHIP_CONF_OPTS += --enable-omx --enable-omx-rpi \
	--extra-cflags=-I$(STAGING_DIR)/usr/include/IL
FFMPEG_ROCKCHIP_DEPENDENCIES += rpi-userland
ifeq ($(BR2_arm),y)
FFMPEG_ROCKCHIP_CONF_OPTS += --enable-mmal
else
FFMPEG_ROCKCHIP_CONF_OPTS += --disable-mmal
endif
else
FFMPEG_ROCKCHIP_CONF_OPTS += --disable-mmal --disable-omx --disable-omx-rpi
endif

# batocera - add RPi H.265 hardware acceleration
ifeq ($(BR2_PACKAGE_RPI_HEVC),y)
FFMPEG_ROCKCHIP_CONF_OPTS += --disable-mmal
FFMPEG_ROCKCHIP_CONF_OPTS += --enable-neon
FFMPEG_ROCKCHIP_CONF_OPTS += --enable-v4l2-request
FFMPEG_ROCKCHIP_CONF_OPTS += --enable-libudev
FFMPEG_ROCKCHIP_CONF_OPTS += --enable-epoxy
FFMPEG_ROCKCHIP_CONF_OPTS += --enable-sand
endif

# To avoid a circular dependency only use opencv if opencv itself does
# not depend on ffmpeg.
ifeq ($(BR2_PACKAGE_OPENCV3_LIB_IMGPROC)x$(BR2_PACKAGE_OPENCV3_WITH_FFMPEG),yx)
FFMPEG_ROCKCHIP_CONF_OPTS += --enable-libopencv
FFMPEG_ROCKCHIP_DEPENDENCIES += opencv3
else
FFMPEG_ROCKCHIP_CONF_OPTS += --disable-libopencv
endif

ifeq ($(BR2_PACKAGE_OPUS),y)
FFMPEG_ROCKCHIP_CONF_OPTS += --enable-libopus
FFMPEG_ROCKCHIP_DEPENDENCIES += opus
else
FFMPEG_ROCKCHIP_CONF_OPTS += --disable-libopus
endif

ifeq ($(BR2_PACKAGE_LIBVPX),y)
FFMPEG_ROCKCHIP_CONF_OPTS += --enable-libvpx
FFMPEG_ROCKCHIP_DEPENDENCIES += libvpx
else
FFMPEG_ROCKCHIP_CONF_OPTS += --disable-libvpx
endif

ifeq ($(BR2_PACKAGE_LIBASS),y)
FFMPEG_ROCKCHIP_CONF_OPTS += --enable-libass
FFMPEG_ROCKCHIP_DEPENDENCIES += libass
else
FFMPEG_ROCKCHIP_CONF_OPTS += --disable-libass
endif

ifeq ($(BR2_PACKAGE_LIBBLURAY),y)
FFMPEG_ROCKCHIP_CONF_OPTS += --enable-libbluray
FFMPEG_ROCKCHIP_DEPENDENCIES += libbluray
else
FFMPEG_ROCKCHIP_CONF_OPTS += --disable-libbluray
endif

ifeq ($(BR2_PACKAGE_LIBVPL),y)
FFMPEG_ROCKCHIP_CONF_OPTS += --enable-libvpl --disable-libmfx
FFMPEG_ROCKCHIP_DEPENDENCIES += libvpl
else ifeq ($(BR2_PACKAGE_INTEL_MEDIASDK),y)
FFMPEG_ROCKCHIP_CONF_OPTS += --disable-libvpl --enable-libmfx
FFMPEG_ROCKCHIP_DEPENDENCIES += intel-mediasdk
else
FFMPEG_ROCKCHIP_CONF_OPTS += --disable-libvpl --disable-libmfx
endif

ifeq ($(BR2_PACKAGE_RTMPDUMP),y)
FFMPEG_ROCKCHIP_CONF_OPTS += --enable-librtmp
FFMPEG_ROCKCHIP_DEPENDENCIES += rtmpdump
else
FFMPEG_ROCKCHIP_CONF_OPTS += --disable-librtmp
endif

ifeq ($(BR2_PACKAGE_LAME),y)
FFMPEG_ROCKCHIP_CONF_OPTS += --enable-libmp3lame
FFMPEG_ROCKCHIP_DEPENDENCIES += lame
else
FFMPEG_ROCKCHIP_CONF_OPTS += --disable-libmp3lame
endif

ifeq ($(BR2_PACKAGE_LIBMODPLUG),y)
FFMPEG_ROCKCHIP_CONF_OPTS += --enable-libmodplug
FFMPEG_ROCKCHIP_DEPENDENCIES += libmodplug
else
FFMPEG_ROCKCHIP_CONF_OPTS += --disable-libmodplug
endif

ifeq ($(BR2_PACKAGE_SPEEX),y)
FFMPEG_ROCKCHIP_CONF_OPTS += --enable-libspeex
FFMPEG_ROCKCHIP_DEPENDENCIES += speex
else
FFMPEG_ROCKCHIP_CONF_OPTS += --disable-libspeex
endif

ifeq ($(BR2_PACKAGE_LIBTHEORA),y)
FFMPEG_ROCKCHIP_CONF_OPTS += --enable-libtheora
FFMPEG_ROCKCHIP_DEPENDENCIES += libtheora
else
FFMPEG_ROCKCHIP_CONF_OPTS += --disable-libtheora
endif

ifeq ($(BR2_PACKAGE_LIBICONV),y)
FFMPEG_ROCKCHIP_CONF_OPTS += --enable-iconv
FFMPEG_ROCKCHIP_DEPENDENCIES += libiconv
else
FFMPEG_ROCKCHIP_CONF_OPTS += --disable-iconv
endif

# batocera - add cuda & nvenc
ifeq ($(BR2_PACKAGE_NVIDIA_OPEN_DRIVER_CUDA),y)
FFMPEG_ROCKCHIP_CONF_OPTS += --enable-cuda --enable-cuvid --enable-nvdec --enable-nvenc
FFMPEG_ROCKCHIP_DEPENDENCIES += nv-codec-headers
endif

# ffmpeg freetype support require fenv.h which is only
# available/working on glibc.
# The microblaze variant doesn't provide the needed exceptions
ifeq ($(BR2_PACKAGE_FREETYPE)$(BR2_TOOLCHAIN_USES_GLIBC)x$(BR2_microblaze),yyx)
FFMPEG_ROCKCHIP_CONF_OPTS += --enable-libfreetype
FFMPEG_ROCKCHIP_DEPENDENCIES += freetype
else
FFMPEG_ROCKCHIP_CONF_OPTS += --disable-libfreetype
endif

ifeq ($(BR2_PACKAGE_FONTCONFIG),y)
FFMPEG_ROCKCHIP_CONF_OPTS += --enable-fontconfig
FFMPEG_ROCKCHIP_DEPENDENCIES += fontconfig
else
FFMPEG_ROCKCHIP_CONF_OPTS += --disable-fontconfig
endif

ifeq ($(BR2_PACKAGE_OPENJPEG),y)
FFMPEG_ROCKCHIP_CONF_OPTS += --enable-libopenjpeg
FFMPEG_ROCKCHIP_DEPENDENCIES += openjpeg
else
FFMPEG_ROCKCHIP_CONF_OPTS += --disable-libopenjpeg
endif

ifeq ($(BR2_PACKAGE_X264)$(BR2_PACKAGE_FFMPEG_ROCKCHIP_GPL),yy)
FFMPEG_ROCKCHIP_CONF_OPTS += --enable-libx264
FFMPEG_ROCKCHIP_DEPENDENCIES += x264
else
FFMPEG_ROCKCHIP_CONF_OPTS += --disable-libx264
endif

ifeq ($(BR2_PACKAGE_X265)$(BR2_PACKAGE_FFMPEG_ROCKCHIP_GPL),yy)
FFMPEG_ROCKCHIP_CONF_OPTS += --enable-libx265
FFMPEG_ROCKCHIP_DEPENDENCIES += x265
else
FFMPEG_ROCKCHIP_CONF_OPTS += --disable-libx265
endif

ifeq ($(BR2_PACKAGE_DAV1D),y)
FFMPEG_ROCKCHIP_CONF_OPTS += --enable-libdav1d
FFMPEG_ROCKCHIP_DEPENDENCIES += dav1d
else
FFMPEG_ROCKCHIP_CONF_OPTS += --disable-libdav1d
endif

ifeq ($(BR2_X86_CPU_HAS_MMX),y)
FFMPEG_ROCKCHIP_CONF_OPTS += --enable-x86asm
FFMPEG_ROCKCHIP_DEPENDENCIES += host-nasm
else
FFMPEG_ROCKCHIP_CONF_OPTS += --disable-x86asm
FFMPEG_ROCKCHIP_CONF_OPTS += --disable-mmx
endif

ifeq ($(BR2_X86_CPU_HAS_SSE),y)
FFMPEG_ROCKCHIP_CONF_OPTS += --enable-sse
else
FFMPEG_ROCKCHIP_CONF_OPTS += --disable-sse
endif

ifeq ($(BR2_X86_CPU_HAS_SSE2),y)
FFMPEG_ROCKCHIP_CONF_OPTS += --enable-sse2
else
FFMPEG_ROCKCHIP_CONF_OPTS += --disable-sse2
endif

ifeq ($(BR2_X86_CPU_HAS_SSE3),y)
FFMPEG_ROCKCHIP_CONF_OPTS += --enable-sse3
else
FFMPEG_ROCKCHIP_CONF_OPTS += --disable-sse3
endif

ifeq ($(BR2_X86_CPU_HAS_SSSE3),y)
FFMPEG_ROCKCHIP_CONF_OPTS += --enable-ssse3
else
FFMPEG_ROCKCHIP_CONF_OPTS += --disable-ssse3
endif

ifeq ($(BR2_X86_CPU_HAS_SSE4),y)
FFMPEG_ROCKCHIP_CONF_OPTS += --enable-sse4
else
FFMPEG_ROCKCHIP_CONF_OPTS += --disable-sse4
endif

ifeq ($(BR2_X86_CPU_HAS_SSE42),y)
FFMPEG_ROCKCHIP_CONF_OPTS += --enable-sse42
else
FFMPEG_ROCKCHIP_CONF_OPTS += --disable-sse42
endif

ifeq ($(BR2_X86_CPU_HAS_AVX),y)
FFMPEG_ROCKCHIP_CONF_OPTS += --enable-avx
else
FFMPEG_ROCKCHIP_CONF_OPTS += --disable-avx
endif

ifeq ($(BR2_X86_CPU_HAS_AVX2),y)
FFMPEG_ROCKCHIP_CONF_OPTS += --enable-avx2
else
FFMPEG_ROCKCHIP_CONF_OPTS += --disable-avx2
endif

# Explicitly disable everything that doesn't match for ARM
# FFMPEG "autodetects" by compiling an extended instruction via AS
# This works on compilers that aren't built for generic by default
ifeq ($(BR2_ARM_CPU_ARMV4),y)
FFMPEG_ROCKCHIP_CONF_OPTS += --disable-armv5te
endif
ifeq ($(BR2_ARM_CPU_ARMV6)$(BR2_ARM_CPU_ARMV7A),y)
FFMPEG_ROCKCHIP_CONF_OPTS += --enable-armv6
else
FFMPEG_ROCKCHIP_CONF_OPTS += --disable-armv6 --disable-armv6t2
endif
ifeq ($(BR2_ARM_CPU_HAS_VFPV2),y)
FFMPEG_ROCKCHIP_CONF_OPTS += --enable-vfp
else
FFMPEG_ROCKCHIP_CONF_OPTS += --disable-vfp
endif
ifeq ($(BR2_ARM_CPU_HAS_NEON),y)
FFMPEG_ROCKCHIP_CONF_OPTS += --enable-neon
else ifeq ($(BR2_aarch64),y)
FFMPEG_ROCKCHIP_CONF_OPTS += --enable-neon
else
FFMPEG_ROCKCHIP_CONF_OPTS += --disable-neon
endif

# batocera
ifeq ($(BR2_PACKAGE_VULKAN_HEADERS)$(BR2_PACKAGE_VULKAN_LOADER)$(BR2_PACKAGE_SHADERC),yyy)
FFMPEG_ROCKCHIP_CONF_OPTS += --enable-vulkan --enable-libshaderc
FFMPEG_ROCKCHIP_DEPENDENCIES += vulkan-headers vulkan-loader shaderc
else
FFMPEG_ROCKCHIP_CONF_OPTS += --disable-vulkan
endif

ifeq ($(BR2_mips)$(BR2_mipsel)$(BR2_mips64)$(BR2_mips64el),y)
ifeq ($(BR2_MIPS_SOFT_FLOAT),y)
FFMPEG_ROCKCHIP_CONF_OPTS += --disable-mipsfpu
else
FFMPEG_ROCKCHIP_CONF_OPTS += --enable-mipsfpu
endif

# Fix build failure on several missing assembly instructions
FFMPEG_ROCKCHIP_CONF_OPTS += --disable-asm
endif # MIPS

ifeq ($(BR2_POWERPC_CPU_HAS_ALTIVEC):$(BR2_powerpc64le),y:)
FFMPEG_ROCKCHIP_CONF_OPTS += --enable-altivec
else ifeq ($(BR2_POWERPC_CPU_HAS_VSX):$(BR2_powerpc64le),y:y)
# On LE, ffmpeg AltiVec support needs VSX intrinsics, and VSX
# is an extension to AltiVec.
FFMPEG_ROCKCHIP_CONF_OPTS += --enable-altivec
else
FFMPEG_ROCKCHIP_CONF_OPTS += --disable-altivec
endif

# Uses __atomic_fetch_add_4
ifeq ($(BR2_TOOLCHAIN_HAS_LIBATOMIC),y)
FFMPEG_ROCKCHIP_CONF_OPTS += --extra-libs=-latomic
endif

ifeq ($(BR2_STATIC_LIBS),)
FFMPEG_ROCKCHIP_CONF_OPTS += --enable-pic
else
FFMPEG_ROCKCHIP_CONF_OPTS += --disable-pic
endif

# Default to --cpu=generic for MIPS architecture, in order to avoid a
# warning from ffmpeg's configure script.
ifeq ($(BR2_mips)$(BR2_mipsel)$(BR2_mips64)$(BR2_mips64el),y)
FFMPEG_ROCKCHIP_CONF_OPTS += --cpu=generic
else ifneq ($(GCC_TARGET_CPU),)
FFMPEG_ROCKCHIP_CONF_OPTS += --cpu="$(GCC_TARGET_CPU)"
else ifneq ($(GCC_TARGET_ARCH),)
FFMPEG_ROCKCHIP_CONF_OPTS += --cpu="$(GCC_TARGET_ARCH)"
endif

FFMPEG_ROCKCHIP_CFLAGS = $(TARGET_CFLAGS)

ifeq ($(BR2_TOOLCHAIN_HAS_GCC_BUG_85180),y)
FFMPEG_ROCKCHIP_CONF_OPTS += --disable-optimizations
FFMPEG_ROCKCHIP_CFLAGS += -O0
endif

ifeq ($(BR2_ARM_INSTRUCTIONS_THUMB),y)
FFMPEG_ROCKCHIP_CFLAGS += -marm
endif

FFMPEG_ROCKCHIP_CONF_ENV += CFLAGS="$(FFMPEG_ROCKCHIP_CFLAGS)"
FFMPEG_ROCKCHIP_CONF_OPTS += $(call qstrip,$(BR2_PACKAGE_FFMPEG_ROCKCHIP_EXTRACONF))

# Override FFMPEG_ROCKCHIP_CONFIGURE_CMDS: FFmpeg does not support --target and others
define FFMPEG_ROCKCHIP_CONFIGURE_CMDS
	(cd $(FFMPEG_ROCKCHIP_SRCDIR) && rm -rf config.cache && \
	$(TARGET_CONFIGURE_OPTS) \
	$(TARGET_CONFIGURE_ARGS) \
	$(FFMPEG_ROCKCHIP_CONF_ENV) \
	./configure \
		--enable-cross-compile \
		--cross-prefix=$(TARGET_CROSS) \
		--sysroot=$(STAGING_DIR) \
		--host-cc="$(HOSTCC)" \
		--arch=$(BR2_ARCH) \
		--target-os="linux" \
		--disable-stripping \
		--pkg-config="$(PKG_CONFIG_HOST_BINARY)" \
		$(SHARED_STATIC_LIBS_OPTS) \
		$(FFMPEG_ROCKCHIP_CONF_OPTS) \
	)
endef

define FFMPEG_ROCKCHIP_REMOVE_EXAMPLE_SRC_FILES
	rm -rf $(TARGET_DIR)/usr/share/ffmpeg/examples
endef
FFMPEG_ROCKCHIP_POST_INSTALL_TARGET_HOOKS += FFMPEG_ROCKCHIP_REMOVE_EXAMPLE_SRC_FILES

$(eval $(autotools-package))
