#!/usr/bin/env python3

import argparse
from glob import glob
import os
import logging
import pathlib
import shutil
from zipfile import ZipFile
from script.efr32 import Board
from script.slc import GeneratedProject, SlcInstallation, SlcProjectTemplate

# ==============================================================================
# System paths
# ==============================================================================
script_dir = os.path.dirname(os.path.realpath(__file__))
repo_dir = os.path.realpath(f"{script_dir}/../")
sdk_dir = os.path.realpath(f"{repo_dir}/third_party/silabs/gecko_sdk")

# ==============================================================================
# Functions
# ==============================================================================


def build(board: Board, targets: list[str], build_dir: str) -> None:

    # Map a CMake target to the SlcProjectTemplate it depends on
    slc_project_dependencies_dict = {
        "ot-cli-ftd": SlcProjectTemplate(f"{repo_dir}/src/platform_projects/openthread-efr32-soc.slcp"),
        "ot-cli-mtd": SlcProjectTemplate(f"{repo_dir}/src/platform_projects/openthread-efr32-soc.slcp"),
        "ot-ncp-ftd": SlcProjectTemplate(f"{repo_dir}/src/platform_projects/openthread-efr32-soc.slcp"),
        "ot-ncp-mtd": SlcProjectTemplate(f"{repo_dir}/src/platform_projects/openthread-efr32-soc.slcp"),
        "ot-rcp": SlcProjectTemplate(f"{repo_dir}/src/platform_projects/openthread-efr32-rcp.slcp"),
        "sleepy-demo-ftd": SlcProjectTemplate(f"{repo_dir}/src/platform_projects/openthread-efr32-soc-with-buttons.slcp"),
        "sleepy-demo-mtd": SlcProjectTemplate(f"{repo_dir}/src/platform_projects/openthread-efr32-soc-with-buttons-power-manager.slcp"),
    }

    # Build set of dependencies
    projects_to_generate: set[GeneratedProject] = []
    for target in targets:
        if target not in slc_project_dependencies_dict:
            continue
        gp = GeneratedProject(
            project=slc_project_dependencies_dict[target],
            board=board,
            export_destination=build_dir,
        )
        projects_to_generate.append(gp)

    # Generate
    logging.info(f"Generating:")
    for project in projects_to_generate:
        logging.info(f"- {project}")
        project.generate()

    return



# ==============================================================================
# Main
# ==============================================================================
if __name__ == "__main__":
    logging.basicConfig(filename='build.log', level=logging.DEBUG)
    logging.getLogger().addHandler(logging.StreamHandler())

    parser = argparse.ArgumentParser()
    parser.add_argument("board", type=Board, help="EFR32 board")
    parser.add_argument("--skip-silabs-apps", action="store_true",
                        help="Skips generation and build of Silicon Labs apps (ex. sleepy-demo-ftd, sleepy-demo-mtd)")
    parser.add_argument("--skip-generation", action="store_true",
                        help="Skips slc-cli generation. This is usually helpful when iterating on changes that don't require template regeneration")
    parser.add_argument("--force-slc-installation", action="store_true",
                        help="Forces slc-cli to be downloaded to the path specified by env variable \'SLC_INSTALL_DIR\'")

    args = parser.parse_args()

    # Parse board
    board: Board = args.board
    assert board.device["family"] == "mg", f"{board} ({board.platform}) is not supported"

    skip_silabs_apps = args.skip_silabs_apps
    skip_generation = args.skip_generation
    force_install_slc = args.force_slc_installation

    # Default OT CMake options
    ot_cmake_options = [
        "-DCMAKE_BUILD_TYPE=Debug",
        "-DOT_DIAGNOSTIC=ON",
        "-DOT_EXTERNAL_HEAP=ON",
        "-DOT_SLAAC=ON",
        # Platform-specific toolchain file
        f"-DCMAKE_TOOLCHAIN_FILE=src/{board.get_platform()}/arm-none-eabi.cmake",
        f"-DEFR32_PLATFORM=\"{board.platform}\"",
        f"-DBOARD={board}",
    ]

    ot_cmake_ninja_targets = ["ot-rcp"]
    # TODO: We can probably parse for RAM/FLASH sizes and figure out what can fit on each platform
    if board.platform != "efr32mg1":
        ot_cmake_ninja_targets += [
            "ot-rcp" "ot-cli-ftd" "ot-cli-mtd" "ot-ncp-ftd" "ot-ncp-mtd"]

    if not skip_silabs_apps:
        ot_cmake_ninja_targets += ["sleepy-demo-ftd" "sleepy-demo-mtd"]

    # Initialize slc-cli installation
    global slc
    slc = SlcInstallation(force_install_slc)

    # Get build_dir from env variables
    build_dir=os.environ.get("OT_CMAKE_BUILD_DIR") or f"{repo_dir}/build/{board}"
    pathlib.Path(build_dir).mkdir(parents=True, exist_ok=True)



    build(board, ot_cmake_ninja_targets, build_dir=build_dir)
