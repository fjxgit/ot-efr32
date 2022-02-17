#
#  Copyright (c) 2021, The OpenThread Authors.
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

include(${PROJECT_SOURCE_DIR}/third_party/silabs/cmake/utility.cmake)

add_library(silabs-mbedtls)

set_target_properties(silabs-mbedtls
    PROPERTIES
        C_STANDARD 99
        CXX_STANDARD 11
)

set(SILABS_MBEDTLS_DIR "${SILABS_GSDK_DIR}/util/third_party/crypto/mbedtls")

target_compile_definitions(silabs-mbedtls
    PRIVATE
        ${OT_PLATFORM_DEFINES}
)

{%- set linker_flags = EXT_LD_FLAGS + EXT_DEBUG_LD_FLAGS %}
{%- if linker_flags %}
target_link_options(openthread-efr32
{%- for flag in linker_flags %}
{#- Replace SDK_PATH with SILABS_GSDK_DIR #}$(SDK_PATH)
{%- set flag = flag | replace('(SDK_PATH)', '{SILABS_GSDK_DIR}') -%}
    {{flag}}
{%- endfor %}
)
{%- endif %}

target_link_libraries(silabs-mbedtls
    PRIVATE
        ot-config
)

target_include_directories(silabs-mbedtls
    PUBLIC
        autogen
        config
        ${PROJECT_SOURCE_DIR}/src/src
{%- for include in C_CXX_INCLUDES %}
{%- if ('util/third_party/crypto' in include) or ('platform' in include) %}

{#- Redirect OpenThread stack sources to the ot-efr32 openthread submodule #}
{%- set source = source | replace('${SILABS_GSDK_DIR}/util/third_party/openthread', '${PROJECT_SOURCE_DIR}/openthread') -%}

{#- Redirect PAL includes to the ot-efr32 PAL #}
{%- set include = include | replace('${SILABS_GSDK_DIR}/protocol/openthread/platform-abstraction/efr32', '${PROJECT_SOURCE_DIR}/src/src') -%}
        {{include | replace('-I', '') | replace('\\', '/') | replace(' ', '\\ ') | replace('"','') | replace('(SDK_PATH)', '{SILABS_GSDK_DIR}' | replace('{SILABS_GSDK_DIR}/util/third_party/crypto', '{SILABS_MBEDTLS_DIR}'))}}
{%- endif %}
{%- endfor %}
        ${SILABS_GSDK_DIR}/util/silicon_labs/silabs_core/memory_manager
)

set(SILABS_MBEDTLS_SOURCES
{%- for source in (ALL_SOURCES | sort) %}
{%- set source = source | replace('\\', '/') | replace(' ', '\\ ') -%}

{#- Replace SDK_PATH with SILABS_GSDK_DIR #}
{%- set source = source | replace('(SDK_PATH)', '{SILABS_GSDK_DIR}') -%}

{#- Redirect OpenThread stack sources to the ot-efr32 openthread submodule #}
{%- set source = source | replace('${SILABS_GSDK_DIR}/util/third_party/openthread', '${PROJECT_SOURCE_DIR}/openthread') -%}

{#- Redirect PAL sources to the ot-efr32 PAL #}
{%- set source = source | replace('${SILABS_GSDK_DIR}/protocol/openthread/platform-abstraction/efr32', '${PROJECT_SOURCE_DIR}/src/src') -%}

{#- Shorten source paths with SILABS_MBEDTLS_DIR #}
{%- set source = source | replace('{SILABS_GSDK_DIR}/util/third_party/crypto/mbedtls', '{SILABS_MBEDTLS_DIR}') -%}
{#- Filter-out non-mbedtls sources #}
    {{source}}
{%- endfor %}
    ${SILABS_GSDK_DIR}/util/silicon_labs/silabs_core/memory_manager/sl_malloc.c
)

target_sources(silabs-mbedtls PRIVATE ${SILABS_MBEDTLS_SOURCES})
