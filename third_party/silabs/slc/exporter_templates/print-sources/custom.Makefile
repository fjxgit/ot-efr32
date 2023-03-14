####################################################################
# Automatically-generated file. Do not edit!                       #
# CMake Version 1                                                  #
####################################################################
#
#  Copyright (c) 2023, The OpenThread Authors.
#  All rights reserved.
#
#  Redistribution and use in source and binary forms, with or without
#  modification, are permitted provided that the following conditions are met:
#  1. Redistributions of source code must retain the above copyright
#     notice, this list of conditions and the following disclaimer.
#  2. Redistributions in binary form must reproduce the above copyright
#     notice, this list of conditions and the following disclaimer in the
#     documentation and/or other materials provided with the distribution.
#  3. Neither the name of the copyright holder nor the
#     names of its contributors may be used to endorse or promote products
#     derived from this software without specific prior written permission.
#
#  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
#  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
#  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
#  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
#  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
#  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
#  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
#  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
#  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
#  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
#  POSSIBILITY OF SUCH DAMAGE.
#
{%  from
        'macros.jinja'
    import
        prepare_path,
    with context -%}
        # compile_flags,
        # print_linker_flags,
        # print_all_jinja_vars,
        # openthread_device_type,
        # dict_contains_key_starting_with

# ==============================================================================
#  C_CXX_INCLUDES
# ==============================================================================
C_CXX_INCLUDES:
{%- for include in C_CXX_INCLUDES %}
{%- set include = prepare_path(include) | replace('-I', '') | replace('\"', '') %}
  - {{ include }}
{%- endfor %}

# ==============================================================================
#  SOURCES
# ==============================================================================
SOURCES:
{%- for source in (ALL_SOURCES | sort) %}
  - {{ prepare_path(source) }}
{%- endfor %}

# ==============================================================================
#  C_CXX_DEFINES
# ==============================================================================
C_CXX_DEFINES:
{%- for define in C_CXX_DEFINES %}
  - {{define}}={{C_CXX_DEFINES[define]}}
{%- endfor %}

# ==============================================================================
#  SYS_LIBS
# ==============================================================================
SYS_LIBS:
{%- for lib in SYS_LIBS %}
  - {{ prepare_path(lib) }}
{%- endfor %}

# ==============================================================================
#  USER_LIBS
# ==============================================================================
USER_LIBS:
{%- for lib in USER_LIBS %}
  - {{ prepare_path(lib) }}
{%- endfor %}

# ==============================================================================
#  EXT_CFLAGS
# ==============================================================================
EXT_CFLAGS:
{%- for flag in EXT_CFLAGS %}
  - {{flag}}
{%- endfor %}

# ==============================================================================
#  EXT_DEBUG_CFLAGS
# ==============================================================================
EXT_DEBUG_CFLAGS:
{%- for flag in EXT_DEBUG_CFLAGS %}
  - {{flag}}
{%- endfor %}

# ==============================================================================
#  EXT_RELEASE_CFLAGS
# ==============================================================================
EXT_RELEASE_CFLAGS:
{%- for flag in EXT_RELEASE_CFLAGS %}
  - {{flag}}
{%- endfor %}

# ==============================================================================
#  EXT_CXX_FLAGS
# ==============================================================================
EXT_CXX_FLAGS:
{%- for flag in EXT_CXX_FLAGS %}
  - {{flag}}
{%- endfor %}

# ==============================================================================
#  EXT_DEBUG_CXX_FLAGS
# ==============================================================================
EXT_DEBUG_CXX_FLAGS:
{%- for flag in EXT_DEBUG_CXX_FLAGS %}
  - {{flag}}
{%- endfor %}

# ==============================================================================
#  EXT_RELEASE_CXX_FLAGS
# ==============================================================================
EXT_RELEASE_CXX_FLAGS:
{%- for flag in EXT_RELEASE_CXX_FLAGS %}
  - {{flag}}
{%- endfor %}

# ==============================================================================
#  EXT_ASM_FLAGS
# ==============================================================================
EXT_ASM_FLAGS:
{%- for flag in EXT_ASM_FLAGS %}
  - {{flag}}
{%- endfor %}

# ==============================================================================
#  EXT_DEBUG_ASM_FLAGS
# ==============================================================================
EXT_DEBUG_ASM_FLAGS:
{%- for flag in EXT_DEBUG_ASM_FLAGS %}
  - {{flag}}
{%- endfor %}

# ==============================================================================
#  EXT_RELEASE_ASM_FLAGS
# ==============================================================================
EXT_RELEASE_ASM_FLAGS:
{%- for flag in EXT_RELEASE_ASM_FLAGS %}
  - {{flag}}
{%- endfor %}

# ==============================================================================
#  EXT_LD_FLAGS
# ==============================================================================
EXT_LD_FLAGS:
{%- for flag in EXT_LD_FLAGS %}
  - {{flag}}
{%- endfor %}

# ==============================================================================
#  EXT_DEBUG_LD_FLAGS
# ==============================================================================
EXT_DEBUG_LD_FLAGS:
{%- for flag in EXT_DEBUG_LD_FLAGS %}
  - {{flag}}
{%- endfor %}

# ==============================================================================
#  EXT_RELEASE_LD_FLAGS
# ==============================================================================
EXT_RELEASE_LD_FLAGS:
{%- for flag in EXT_RELEASE_LD_FLAGS %}
  - {{flag}}
{%- endfor %}