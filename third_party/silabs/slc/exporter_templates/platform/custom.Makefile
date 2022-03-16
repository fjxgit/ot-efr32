####################################################################
# Automatically-generated file. Do not edit!                       #
# CMake Version 0                                                  #
#                                                                  #
#                                                                  #
# This file will be used to generate a .cmake file that will       #
# replace all existing CMake files for the GSDK.                   #
#                                                                  #
####################################################################
{% from 'macros.jinja' import prepare_path,compile_flags,linker_flags with context -%}

include(${PROJECT_SOURCE_DIR}/third_party/silabs/cmake/utility.cmake)
include(silabs-efr32-sdk.cmake)

# ==============================================================================
# Platform library
# ==============================================================================
add_library(openthread-efr32
    $<TARGET_OBJECTS:openthread-platform-utils>
)

set_target_properties(openthread-efr32
    PROPERTIES
        C_STANDARD 99
        CXX_STANDARD 11
)

target_include_directories(ot-config INTERFACE
{%- for include in C_CXX_INCLUDES %}
    {%- if ('sample-apps' not in include) %}
    {{ prepare_path(include) | replace('-I', '') | replace('\"', '') }}
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
    {%- set source = prepare_path(source) -%}

    {#- Only take PAL sources #}
    {%- if ('{PROJECT_SOURCE_DIR}/src/src' in source) -%}
        {%- if source.endswith('.c') or source.endswith('.cpp') or source.endswith('.h') or source.endswith('.hpp') %}
        {{source}}
        {%- endif %}
    {%- endif %}
{%- endfor %}
)

{%- for source in (ALL_SOURCES | sort) %}
    {%- set source = prepare_path(source) -%}

    {#- Only take PAL sources #}
    {%- if ('${PROJECT_SOURCE_DIR}/src/src' in source) -%}
        {%- if source.endswith('.s') or source.endswith('.S') %}
target_sources(openthread-efr32 PRIVATE {{source}})
set_property(SOURCE {{source}} PROPERTY LANGUAGE C)
        {%- endif %}
    {%- endif %}
{%- endfor %}

target_compile_definitions(ot-config INTERFACE
{%- for define in C_CXX_DEFINES %}
        {{define}}={{C_CXX_DEFINES[define]}}
{%- endfor %}
        # ${OT_PLATFORM_DEFINES}
)

set(LD_FILE "${CMAKE_CURRENT_SOURCE_DIR}/autogen/linkerfile.ld")
set(silabs-efr32-sdk_location $<TARGET_FILE:silabs-efr32-sdk>)
target_link_libraries(openthread-efr32
    PUBLIC
{%- for lib_name in SYS_LIBS+USER_LIBS %}
    {%- set lib_name = prepare_path(lib_name) -%}

    {#- Ignore GSDK static libs. These will be added below #}
    {%- if 'SILABS_GSDK_DIR' not in lib_name %}
        {{lib_name | replace('\\', '/') | replace(' ', '\\ ') | replace('"','')}}
    {%- endif %}
{%- endfor %}

    PRIVATE
        -T${LD_FILE}
        -Wl,--gc-sections
        -Wl,--whole-archive ${silabs-efr32-sdk_location} -Wl,--no-whole-archive
        jlinkrtt
        ot-config
)

{% if EXT_CFLAGS+EXT_CXX_FLAGS -%}
target_compile_options(openthread-efr32 PRIVATE {{ compile_flags() }}
)
{%- endif %} {# compile_options #}

{# ========================================================================= #}
{#- Linker Flags #}
{%- if (EXT_LD_FLAGS + EXT_DEBUG_LD_FLAGS + EXT_RELEASE_LD_FLAGS) %}
target_link_options(openthread-efr32 PRIVATE {{ linker_flags() }}
)
{%- endif %} {# linker_flags #}

{% set lib_list = SYS_LIBS + USER_LIBS %}
{%- if lib_list %}
# ==============================================================================
# Static libraries from GSDK
# ==============================================================================
{# Generate a list of GSDK libs #}
set(GSDK_LIBS
{%- for lib_name in lib_list -%}
    {#- Replace SDK_PATH with SILABS_GSDK_DIR #}
    {%- set lib_name = prepare_path(lib_name) -%}

    {%- if ('SILABS_GSDK_DIR' in lib_name) and ('jlink' not in lib_name) %}
    {{lib_name}}
    {%- endif %}
{%- endfor %}
)

foreach(lib_file ${GSDK_LIBS})
    # Parse lib name, stripping .a extension
    get_filename_component(lib_name ${lib_file} NAME_WE)
    set(imported_lib_name "silabs-${lib_name}")

    # Add as an IMPORTED lib
    add_library(${imported_lib_name} STATIC IMPORTED)
    set_target_properties(${imported_lib_name}
        PROPERTIES
            IMPORTED_LOCATION "${lib_file}"
            IMPORTED_LINK_INTERFACE_LIBRARIES silabs-efr32-sdk
    )
    target_link_libraries(openthread-efr32 PUBLIC ${imported_lib_name})
endforeach()

{%- endif %} {# lib_list #}



# ==============================================================================
#  C_CXX_INCLUDES
# ==============================================================================
{%- for include in C_CXX_INCLUDES %}
#    {{ prepare_path(include) | replace('-I', '') | replace('\"', '') }}
{%- endfor %}

# ==============================================================================
#  SOURCES
# ==============================================================================
{%- for source in (ALL_SOURCES | sort) %}
#    {{ prepare_path(source) }}
{%- endfor %}

# ==============================================================================
#  C_CXX_DEFINES
# ==============================================================================
{%- for define in C_CXX_DEFINES %}
#    {{define}}={{C_CXX_DEFINES[define]}}
{%- endfor %}

# ==============================================================================
#  SYS_LIBS+USER_LIBS
# ==============================================================================
{%- for lib_name in SYS_LIBS+USER_LIBS %}
#    {{ prepare_path(lib_name) | replace('\\', '/') | replace(' ', '\\ ') | replace('"','') }}
{%- endfor %}

# ==============================================================================
#  EXT_CFLAGS
# ==============================================================================
{%- for flag in EXT_CFLAGS %}
#    {{flag}}
{%- endfor %}

# ==============================================================================
#  EXT_DEBUG_CFLAGS
# ==============================================================================
{%- for flag in EXT_DEBUG_CFLAGS %}
#    {{flag}}
{%- endfor %}

# ==============================================================================
#  EXT_RELEASE_CFLAGS
# ==============================================================================
{%- for flag in EXT_RELEASE_CFLAGS %}
#    {{flag}}
{%- endfor %}

# ==============================================================================
#  EXT_CXX_FLAGS
# ==============================================================================
{%- for flag in EXT_CXX_FLAGS %}
#    {{flag}}
{%- endfor %}

# ==============================================================================
#  EXT_DEBUG_CXX_FLAGS
# ==============================================================================
{%- for flag in EXT_DEBUG_CXX_FLAGS %}
#    {{flag}}
{%- endfor %}

# ==============================================================================
#  EXT_RELEASE_CXX_FLAGS
# ==============================================================================
{%- for flag in EXT_RELEASE_CXX_FLAGS %}
#    {{flag}}
{%- endfor %}

# ==============================================================================
#  EXT_ASM_FLAGS
# ==============================================================================
{%- for flag in EXT_ASM_FLAGS %}
#    {{flag}}
{%- endfor %}

# ==============================================================================
#  EXT_DEBUG_ASM_FLAGS
# ==============================================================================
{%- for flag in EXT_DEBUG_ASM_FLAGS %}
#    {{flag}}
{%- endfor %}

# ==============================================================================
#  EXT_RELEASE_ASM_FLAGS
# ==============================================================================
{%- for flag in EXT_RELEASE_ASM_FLAGS %}
#    {{flag}}
{%- endfor %}

# ==============================================================================
#  EXT_LD_FLAGS
# ==============================================================================
{%- for flag in EXT_LD_FLAGS %}
#    {{flag}}
{%- endfor %}

# ==============================================================================
#  EXT_DEBUG_LD_FLAGS
# ==============================================================================
{%- for flag in EXT_DEBUG_LD_FLAGS %}
#    {{flag}}
{%- endfor %}

# ==============================================================================
#  EXT_RELEASE_LD_FLAGS
# ==============================================================================
{%- for flag in EXT_RELEASE_LD_FLAGS %}
#    {{flag}}
{%- endfor %}
