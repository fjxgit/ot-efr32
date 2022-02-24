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
{% from 'macros.jinja' import prepare_path %}

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
    {%- if ('sample-apps' not in include) %}
    {{ prepare_path(include) | replace('-I', '') | replace('\"', '') }}
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
    {%- set source = prepare_path(source) -%}

    {#- Ignore crypto sources #}
    {%- if ('util/third_party/crypto/mbedtls' not in source) and ('${PROJECT_SOURCE_DIR}/src/src' not in source) and ('coprocessor' not in source) and ('${PROJECT_SOURCE_DIR}/openthread' not in source) %}
        {%- if source.endswith('.c') or source.endswith('.cpp') or source.endswith('.h') or source.endswith('.hpp') %}
        {{source}}
        {%- endif %}
    {%- endif %}
{%- endfor %}
)

{% for source in (ALL_SOURCES | sort) %}
    {%- set source = prepare_path(source) -%}

    {#- Ignore crypto sources #}
    {%- if ('util/third_party/crypto/mbedtls' not in source) and ('${PROJECT_SOURCE_DIR}/src/src' not in source) and ('coprocessor' not in source) and ('${PROJECT_SOURCE_DIR}/openthread' not in source) %}
        {%- if source.endswith('.s') or source.endswith('.S') %}
target_sources(silabs-efr32-sdk PRIVATE {{source}})
set_property(SOURCE {{source}} PROPERTY LANGUAGE C)
        {%- endif %}
    {%- endif %}
{%- endfor %}

target_link_libraries(silabs-efr32-sdk
    PUBLIC
        silabs-mbedtls
    PRIVATE
{%- for source in SYS_LIBS+USER_LIBS %}
        {{prepare_path(source)}}
{%- endfor %}
        -Wl,--gc-sections
        -Wl,-Map=silabs-efr32-sdk.map
        ot-config
)
