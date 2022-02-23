####################################################################
# Automatically-generated file. Do not edit!                       #
# CMake Version 0                                                  #
#                                                                  #
#                                                                  #
# This file will be used to generate a .cmake file that will       #
# replace all existing CMake files for the GSDK.                   #
#                                                                  #
# place in /Users/matran/repos/sl/uc_cli_mac0014605/uc_cli_downloads/0.7.14/slc_cli/bin/slc-cli/slc-cli.app/Contents/Eclipse/developer/exporter_templates/arm_gcc                                                                 #
####################################################################

include(${PROJECT_SOURCE_DIR}/third_party/silabs/cmake/utility.cmake)

# ==============================================================================
# Platform library
# ==============================================================================
set(slc_gen_dir ${PROJECT_BINARY_DIR}/slc)

add_library(silabs-efr32-sdk)

set_target_properties(silabs-efr32-sdk
    PROPERTIES
        C_STANDARD 99
        CXX_STANDARD 11
)

target_compile_options(silabs-efr32-sdk
    PRIVATE
        -Wno-unused-parameter
        -Wno-missing-field-initializers
)

target_include_directories(ot-config INTERFACE
    autogen
    config
    ${PROJECT_SOURCE_DIR}/src/src
{%- for include in C_CXX_INCLUDES %}

{%- set include = include | replace('-I', '') | replace('\\', '/') | replace(' ', '\\ ') | replace('\"', '') -%}

{#- Replace SDK_PATH with SILABS_GSDK_DIR #}
{%- set include = include | replace('(SDK_PATH)', '{SILABS_GSDK_DIR}') -%}

{#- Redirect PAL includes to the ot-efr32 PAL #}
{%- set include = include | replace('{SILABS_GSDK_DIR}/protocol/openthread/platform-abstraction/efr32', '{PROJECT_SOURCE_DIR}/src/src') -%}

{%- if ('sample-apps' not in include) %}
    {{include}}
{%- endif %}
{%- endfor %}
)

target_include_directories(silabs-efr32-sdk
    PRIVATE
        ${OT_PUBLIC_INCLUDES}
)

target_sources(silabs-efr32-sdk
    PRIVATE
{%- for source in (ALL_SOURCES | sort) %}
{%- set source = source | replace('\\', '/') | replace(' ', '\\ ') -%}

{#- Replace SDK_PATH with SILABS_GSDK_DIR #}
{%- set source = source | replace('(SDK_PATH)', '{SILABS_GSDK_DIR}') -%}

{#- Redirect OpenThread stack sources to the ot-efr32 openthread submodule #}
{%- set source = source | replace('${SILABS_GSDK_DIR}/util/third_party/openthread', '${PROJECT_SOURCE_DIR}/openthread') -%}

{#- Redirect PAL sources to the ot-efr32 PAL #}
{%- set source = source | replace('${SILABS_GSDK_DIR}/protocol/openthread/platform-abstraction/efr32', '${PROJECT_SOURCE_DIR}/src/src') -%}
{#- #}
{#- #}
{#- Ignore crypto sources #}
{%- if ('util/third_party/crypto/mbedtls' not in source) and ('${PROJECT_SOURCE_DIR}/src/src' not in source) and ('coprocessor' not in source) and ('${PROJECT_SOURCE_DIR}/openthread' not in source) %}
{%- if source.endswith('.c') or source.endswith('.cpp') or source.endswith('.h') or source.endswith('.hpp') or source.endswith('.s') %}
        {{source}}
{%- endif %}
{%- endif %}
{%- endfor %}
)


target_link_libraries(silabs-efr32-sdk
    PUBLIC
        silabs-mbedtls
    PRIVATE
{%- for source in SYS_LIBS+USER_LIBS %}
{#- Replace SDK_PATH with SILABS_GSDK_DIR #}
{%- set source = source | replace('(SDK_PATH)', '{SILABS_GSDK_DIR}') %}
        {{source | replace('\\', '/') | replace(' ', '\\ ') | replace('"','')}}
{%- endfor %}
        -Wl,--gc-sections
        -Wl,-Map=silabs-efr32-sdk.map
        ot-config
)
