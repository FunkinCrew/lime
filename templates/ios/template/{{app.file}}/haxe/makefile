HAXE_BUILDS := $(ARCHS:%=build-haxe-%)

ifeq ("$(CONFIGURATION)","Debug")
   BUILD_STYLE := Debug
endif

ifeq ("$(BUILD_STYLE)","Debug")
   DEBUG := -debug
   CONFIG := Debug
else
   DEBUG :=
   CONFIG := Release
endif

HAXE_OS := $(PLATFORM_NAME)
ifeq ("$(HAXE_OS)","iphonesimulator")
   HAXE_OS := iphonesim
endif
CONFIG := $(CONFIG)-$(HAXE_OS)

LIB_DEST := $(DEBUG)/libApplicationMain.a
LIB_MBEDTLS_DEST := $(DEBUG)/libmbedtls_hxcpp.a

SIMULATOR_ARCH = arm64 x86_64

SUFFIX_x86_64 = -x64
SUFFIX_arm64 = -arm64

BUILD_NAME_x86_64 = x86_64
BUILD_NAME_arm64 = arm64

HXCPP_FLAGS_x86_64 = -D simulator -D HXCPP_M64
HXCPP_FLAGS_arm64 = -D HXCPP_ARM64

ifeq ("$(PLATFORM_NAME)","iphonesimulator")
  BUILD_NAME_arm64 = arm64-sim
  SUFFIX_arm64 = -arm64-sim
  HXCPP_FLAGS_arm64 = -D simulator -D HXCPP_ARM64
endif


ifeq ("$(ACTION)","clean")
default: clean
else
default: $(HAXE_BUILDS)
endif

default: debug_print

debug_print:
	@echo "Make $(HAXE_BUILDS)"

$(HAXE_BUILDS): build-haxe-%:
	@echo "Haxe $(if $(filter $*,$(SIMULATOR_ARCH)),simulator,device) build: $(CONFIG)$(SUFFIX_$*)"
	haxe Build.hxml $(HXCPP_FLAGS_$*) -cpp build/$(CONFIG)$(SUFFIX_$*) $(DEBUG)
	cd build/$(CONFIG)$(SUFFIX_$*); ::HAXELIB_PATH:: export HXCPP_NO_COLOR=1; \
		haxelib run ::CPP_BUILD_LIBRARY:: Build.xml haxe -Ddestination="$(CURDIR)/../lib/$(BUILD_NAME_$*)$(LIB_DEST)" \
		-options Options.txt $(DEBUG)
	touch ../Classes/Main.mm
	cd build/$(CONFIG)$(SUFFIX_$*); ::HAXELIB_PATH:: export HXCPP_NO_COLOR=1; \
		::CPP_CACHE_WORKAROUND:: haxelib run ::CPP_BUILD_LIBRARY:: "$(CURDIR)/BuildHxcppMbedtls.xml" \
		-Ddestination="$(CURDIR)/../lib/$(BUILD_NAME_$*)$(LIB_MBEDTLS_DEST)" \
		-options "$(CURDIR)/build/$(CONFIG)$(SUFFIX_$*)/Options.txt" $(DEBUG)

clean:
	rm -rf build

.PHONY: default debug_print clean $(HAXE_BUILDS)
.SUFFIXES:
