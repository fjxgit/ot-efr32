#!/usr/bin/env python3
import argparse
import atexit
import yaml
import pprint
import pathlib
# import re
# import sys
# import time
import os
# import logging

import git


script_dir = pathlib.Path(os.path.realpath(os.path.dirname(__file__)))
repo_dir = script_dir.parents[0]

# Create repo instance
repo = git.Repo(repo_dir)
assert not repo.bare



"""
Get submodules
"""
def get_submodules() -> list[git.objects.submodule.base.Submodule]:
    return repo.submodules

"""
Get all files in submodules which are tracked by LFS

@ret dict()
        Key: path to a lfs file (relative to repo_dir)
        Value: submodule it belongs to
"""
def get_lfs_files() -> dict[str, git.objects.submodule.base.Submodule]:
    # Key: path to a lfs file (relative to repo_dir)
    # Value: submodule it belongs to
    lfs_files: dict[str, git.objects.submodule.base.Submodule]  = dict()

    # Populate lfs_files
    for sub in get_submodules():
        sub_abs_path = pathlib.Path(repo_dir) / sub.path

        # print("=========================================")
        # print(f"Submodule: {sub}")
        # print(f"sub_abs_path = {sub_abs_path}")

        # Get result of 'git -C {sub_abs_path} lfs ls-files'
        r = git.cmd.Git(sub_abs_path)
        lfs_files_raw = r.lfs(["ls-files", "--name-only"]).split("\n")

        for file in lfs_files_raw:
            if not file:
                continue
            # print(f"----: line:'{line}'")

            # Calculate the path to file (relative to repo_dir)
            file_abs_path = sub_abs_path / file
            file_rel_path = file_abs_path.relative_to(repo_dir)

            lfs_files[str(file_rel_path)] = sub
    # print("=========================================")
    return lfs_files


if __name__ == "__main__":

    parser = argparse.ArgumentParser()
    parser.add_argument("slc_project_info_yml", type=str, help="generated yml file containing all SLC variables")

    args = parser.parse_args()
    slc_project_info_yml = args.slc_project_info_yml

    # Read yml file into slc_project_info
    with open(slc_project_info_yml, 'r') as f:
        slc_project_info = yaml.safe_load(f)

    # pprint.pprint(slc_project_info)

    lfs_files = get_lfs_files()

    # Key: submodule
    # Val: set of files needed from submodule
    files_needed: dict[git.objects.submodule.base.Submodule, set[str]] = dict()

    # pprint.pprint(lfs_files)
    # Check sources, includes, and libs
    # for prop in [slc_project_info["USER_LIBS"] ]:
    for prop in [slc_project_info["SOURCES"], slc_project_info["C_CXX_INCLUDES"], slc_project_info["USER_LIBS"] ]:
        for f in prop:
            if f in lfs_files:

                # Submodule
                r = lfs_files[f]

                # Append to list of files needed from this submodule
                if r in files_needed:
                    files_needed[r].add(f)
                else:
                    files_needed[r] = {f}

    # print("Files needed:")
    # pprint.pprint(files_needed)

    for sub,files in files_needed.items():
        print(f"Submodule: {sub}")
        files_relative_to_sub = list()
        for f in files:
            p = pathlib.Path(f).relative_to(sub.path)
            files_relative_to_sub.append(str(p))
            print(f"- {p}")
        # files = list(map(lambda f: pathlib.Path(f).relative_to(sub.root_dir), files))

        # git.cmd.Git(sub.path).config(["lfs.fetchinclude",f"\"{','.join(files_relative_to_sub)}\""])
        # git.cmd.Git(sub.path).lfs(["pull"])
        for f in files:
            git.cmd.Git(sub.path).lfs(["pull", "--include", f])