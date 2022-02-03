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
# include(${PROJECT_SOURCE_DIR}/third_party/silabs/cmake/includes.cmake)

{# TODO: Parse efr32mgXX from C_FlAGS #}
add_library(openthread-efr32)

set(slc_gen_dir ${PROJECT_BINARY_DIR}/slc)

target_include_directories(openthread-efr32
    PRIVATE
{%- for include in C_CXX_INCLUDES %}
        {{include | replace('-I', '') | replace('\\', '/') | replace(' ', '\\ ') | replace('"','')}}
{%- endfor %}
        ${PROJECT_SOURCE_DIR}/src/src
        ${OT_PUBLIC_INCLUDES}
)

target_sources(openthread-efr32
    PRIVATE
{%- for source in (ALL_SOURCES | sort) %}
{%- set source = source | replace('\\', '/') | replace(' ', '\\ ') %}
{#- Replace SDK_PATH with SILABS_GSDK_DIR #}
{%- set source = source | replace('(SDK_PATH)', '{SILABS_GSDK_DIR}') %}
{#- Redirect OpenThread stack sources to the ot-efr32 openthread submodule #}
{%- set source = source | replace('${SILABS_GSDK_DIR}/util/third_party/openthread', '${PROJECT_SOURCE_DIR}/openthread') %}
{#- Redirect PAL sources to the ot-efr32 PAL #}
{%- set source = source | replace('${SILABS_GSDK_DIR}/protocol/openthread/platform-abstraction/efr32', '${PROJECT_SOURCE_DIR}/src/src') %}
{#- #}
{#- #}
{#- Only include .c files #}
{%- if source.endswith('.c') %}
{#- Ignore crypto sources #}
{%- if 'util/third_party/crypto' not in source %}
        {{source}}
{%- endif %}
{%- endif %}
{%- endfor %}
)

include(${slc_gen_dir}/slc_defines.cmake)
target_compile_definitions(openthread-efr32
    PRIVATE
        ${slc_defines}
)

target_compile_definitions(openthread-efr32
{% for define in C_CXX_DEFINE_STR %}    {{define}}
{% endfor %}
)

target_link_libraries(openthread-efr32
{% for source in SYS_LIBS+USER_LIBS %} {{source | replace('\\', '/') | replace(' ', '\\ ') | replace('"','')}}
{% endfor %}
)

target_compile_options(openthread-efr32
{% for flag in EXT_CFLAGS %}    {{flag}}
{% endfor %}
{% for flag in EXT_CXX_FLAGS %}    {{flag}}
{% endfor %}
)

target_link_options(openthread-efr32
{% for flag in EXT_LD_FLAGS %}    {{flag}}
{% endfor %}
)
