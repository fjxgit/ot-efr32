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
add_library(openthread-efr32
    # $<TARGET_OBJECTS:openthread-platform-utils>
)

set_target_properties(openthread-efr32
    PROPERTIES
        C_STANDARD 99
        CXX_STANDARD 11
)

set(slc_gen_dir ${PROJECT_BINARY_DIR}/slc)


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

target_include_directories(openthread-efr32
    PRIVATE
        ${OT_PUBLIC_INCLUDES}
)

target_sources(openthread-efr32
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
{%- if ('util/third_party/crypto' not in source) and ('coprocessor' not in source) and ('${PROJECT_SOURCE_DIR}/openthread' not in source) %}
{%- if source.endswith('.c') or source.endswith('.cpp') or source.endswith('.h') or source.endswith('.hpp') or source.endswith('.s') %}
        {{source}}
{%- endif %}
{%- endif %}
{%- endfor %}
)

target_compile_definitions(ot-config INTERFACE
{#- TODO: Figure out why I can't do

{%- for key, value in C_CXX_DEFINES %}
    {{key}}={{value}}
{%- endfor %}

#}
{%- for define in C_CXX_DEFINES %}
        {{define}}={{C_CXX_DEFINES[define]}}
{%- endfor %}
        # ${OT_PLATFORM_DEFINES}
)

set(LD_FILE "${CMAKE_CURRENT_SOURCE_DIR}/autogen/linkerfile.ld")
target_link_libraries(openthread-efr32
    PUBLIC
{%- for source in SYS_LIBS+USER_LIBS %}
{#- Replace SDK_PATH with SILABS_GSDK_DIR #}
{%- set source = source | replace('(SDK_PATH)', '{SILABS_GSDK_DIR}') %}
        {{source | replace('\\', '/') | replace(' ', '\\ ') | replace('"','')}}
{%- endfor %}
    PRIVATE
        -T${LD_FILE}
        -Wl,--gc-sections
        -Wl,-Map=openthread-efr32.map
        ot-config
)

{%- set compile_options = EXT_CFLAGS + EXT_CXX_FLAGS %}
{%- if compile_options %}
target_compile_options(openthread-efr32
{%- for flag in compile_options %}
    {{flag}}
{%- endfor %}
)
{%- endif %}


{%- set linker_flags = EXT_LD_FLAGS + EXT_DEBUG_LD_FLAGS %}
{%- if linker_flags %}
target_link_options(openthread-efr32
{%- for flag in linker_flags %}
{#- Replace SDK_PATH with SILABS_GSDK_DIR #}
{%- set flag = flag | replace('(SDK_PATH)', '{SILABS_GSDK_DIR}') -%}
    {{flag}}
{%- endfor %}
)
{%- endif %}