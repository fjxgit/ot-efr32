#!/bin/bash
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

# slc-cli installation dir
[ ! -z "${SLC_INSTALL_DIR:-}" ] || SLC_INSTALL_DIR="${repo_dir}/third_party/silabs/slc"

slc_cmd=""
slc_exporter_templates_dir=""
need_to_restore_templates=0

# Set to 0 to force using slc-cli from 'third_party'/silabs/slc.
use_slc_from_path=1

# Wrapper function to execute an slc command
run_slc()
{
    mycmd=("${slc_cmd}" ${@})
    "${mycmd[@]}"
}

# Find the command to use for slc
slc_init()
{

    # 0 - Use slc-cli from ${repo_dir}/third_party/silabs/slc
    # 1 - Use slc-cli or slc from PATH
    if command -v slc && [ "$use_slc_from_path" -eq "1" ]; then
        slc_cmd="slc"
        slc_dir=$(dirname $(which "${slc_cmd}"))

        # Locate exporter templates for inject_templates() and restore_templates()
        slc_version=$(head -n 1 "${slc_dir}"/latest_version)
        slc_exporter_templates_search_dir="${slc_dir}"/uc_cli_downloads/"${slc_version}"
    else
        if command -v slc-cli && [ "$use_slc_from_path" -eq "1" ]; then
            slc_cmd="slc-cli"
        else
            echo "The 'slc-cli' command could not be found in your PATH."

            # Find the slc executable
            slc_cmd=$(find "${repo_dir}/third_party/silabs/slc" -perm "$([[ $OSTYPE == darwin* ]] && echo '+' || echo '/')"111 -name 'slc*' -type f)

            # Exit if nothing was found
            if [ -z "${slc_cmd}" ]; then
                echo "slc-cli has not been installed yet. Please run ./script/bootstrap"
                exit
            fi
        fi
        slc_dir=$(dirname $(which "${slc_cmd}"))
        slc_exporter_templates_search_dir="${repo_dir}/third_party/silabs/slc/slc_cli"
    fi


    # TODO: Remove when MCUDT-27996 is completed. We shouldn't need to inject templates
    # Attempt to find the 'exporter_templates' folder
    slc_exporter_templates_dir=$(find "${slc_exporter_templates_search_dir}" -name 'exporter_templates')
    if [ -z "${slc_exporter_templates_dir}" ]; then
        # Run a dummy generation
        dummy_builddir="${OT_CMAKE_BUILD_DIR:-$repo_dir/build/${platform}/slc/dummy}"

        mkdir -p "${dummy_builddir}"
        cd "${dummy_builddir}"

        run_slc -v 1 signature trust --sdk ${sdk_dir}

        # Run a dummy generation to create the template directory
        run_slc -v 1 generate \
            --sdk=${sdk_dir} \
            --clear-cache \
            --project-file=${sdk_dir}/protocol/openthread/sample-apps/ot-ncp/ot-rcp.slcp \
            --output-type=makefile \
            --no-copy \
            --export-destination=${dummy_builddir} \
            --with ${board}

        # Attempt to find the 'exporter_templates' folder
        slc_exporter_templates_dir=$(find "${slc_exporter_templates_search_dir}" -name 'exporter_templates')
    fi

    # Find the 'arm_gcc' folder in 'exporter_templates'
    slc_exporter_templates_dir=$(find "${slc_exporter_templates_dir}" -name 'arm_gcc')
}

inject_templates()
{
    local custom_templates_dir=$1

    # Make a backup of existing templates
    echo "Backing up ${slc_exporter_templates_dir}"

    pushd ${slc_exporter_templates_dir}
    cp arm_gcc.Makefile arm_gcc.Makefile.bak
    cp arm_gcc.project.mak arm_gcc.project.mak.bak

    # Inject templates
    echo "Injecting custom exporter templates"
    cp ${custom_templates_dir}/custom.Makefile arm_gcc.Makefile
    cp ${custom_templates_dir}/custom.project.mak arm_gcc.project.mak
    cp ${custom_templates_dir}/macros.jinja .

    popd

    need_to_restore_templates=1
}

restore_templates()
{
    pushd ${slc_exporter_templates_dir}
    rm -f macros.jinja
    echo "Restoring original slc exporter templates"
    cp arm_gcc.Makefile.bak arm_gcc.Makefile 2>/dev/null || :
    cp arm_gcc.project.mak.bak arm_gcc.project.mak 2>/dev/null || :
    popd
}


cleanup()
{
    if [ "$?" -eq "14" ]; then
        echo "Please make sure Java 11 installed and the JAVA_11_HOME environment variable is set."
    fi

    if [ "${need_to_restore_templates}" -eq "1" ]; then
        restore_templates
    fi
}

trap cleanup EXIT