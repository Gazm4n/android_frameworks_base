# Copyright (C) 2010 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

LOCAL_PATH:= $(call my-dir)

# libui is partially built for the host (used by build time keymap validation tool)
# These files are common to host and target builds.
commonSources:= \
	Input.cpp \
	Keyboard.cpp \
	KeyLayoutMap.cpp \
	KeyCharacterMap.cpp \
	VirtualKeyMap.cpp

# For the host
# =====================================================

include $(CLEAR_VARS)

LOCAL_SRC_FILES:= $(commonSources)

LOCAL_MODULE:= libui

include $(BUILD_HOST_STATIC_LIBRARY)


# For the device
# =====================================================

include $(CLEAR_VARS)

LOCAL_SRC_FILES:= \
	$(commonSources) \
	Overlay.cpp \
	EGLUtils.cpp \
	FramebufferNativeWindow.cpp \
	GraphicBuffer.cpp \
	GraphicBufferAllocator.cpp \
	GraphicBufferMapper.cpp \
	GraphicLog.cpp \
	InputTransport.cpp \
	PixelFormat.cpp \
	Rect.cpp \
	Region.cpp

LOCAL_SHARED_LIBRARIES := \
	libcutils \
	libutils \
	libEGL \
	libpixelflinger \
	libhardware \
	libhardware_legacy \
	libskia \
	libbinder

ifdef BOARD_EGL_GRALLOC_USAGE_FILTER
	LOCAL_CFLAGS += -DBOARD_EGL_GRALLOC_USAGE_FILTER=$(BOARD_EGL_GRALLOC_USAGE_FILTER)
endif

LOCAL_C_INCLUDES := \
    external/skia/include/core

ifeq ($(BOARD_USES_QCOM_HARDWARE),true)
LOCAL_CFLAGS += -DQCOM_HARDWARE
endif

LOCAL_MODULE:= libui

include $(BUILD_SHARED_LIBRARY)


# Include subdirectory makefiles
# ============================================================

# If we're building with ONE_SHOT_MAKEFILE (mm, mmm), then what the framework
# team really wants is to build the stuff defined by this makefile.
ifeq (,$(ONE_SHOT_MAKEFILE))
include $(call first-makefiles-under,$(LOCAL_PATH))
endif
