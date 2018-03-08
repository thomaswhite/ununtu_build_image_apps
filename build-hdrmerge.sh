#!/usr/bin/env bash
# By Morgan Hardwood
# Version 2018-01-09
# This script gets the latest source code for the given program and compiles it.

# The name of the program, used for the folder names:
prog="hdrmerge"

# The name of the compiled executable:
exe="${prog}"

# The name of the sub-folder, if any, relative to the folder into which the
# compiled executable is placed.
# e.g. If the executable ends up in:
#   ~/programs/someProgram/foo/bar/someExecutable
# then set it to:
#   exeRelativePath="foo/bar"
# or if the executable ends up in
#   ~/programs/someProgram/someExecutable
# then leave it empty:
# exeRelativePath=""
exeRelativePath="bin"

# The path to the repository:
repo="https://github.com/jcelaya/hdrmerge.git"

# No touching below this line, with the exception of the "Compile" section
# -----------------------------------------------------------------------------

# The name of the project's standard branch, typically "master":
master="master"

buildOnly="false"
buildType="release"

# Removes the trailing forward-slash if one is present
exeRelativePath="${exeRelativePath/%\/}"
# Append forward-slash to exeRelativePath only if it is not empty.
exePath="${exeRelativePath:+${exeRelativePath}/}${exe}"

# Command-line arguments
OPTIND=1
while getopts "bdh?-" opt; do
    case "${opt}" in
        b)  buildOnly="true"
            ;;
        d)  buildType="debug"
            ;;
        h|\?|-) printf '%s\n' "This script gets the latest source code for ${prog} and compiles it." \
                "" \
                "  -b" \
                "     Optional. If specified, the script only compiles the source, it does not try to update the source. If not specified, the source will be updated first." \
                "  -d" \
                "     Optional. Compile a \"debug\" build. If not specified, a \"release\" build will be made." \
                ""
        exit 0
        ;;
    esac
done
shift $((OPTIND-1))
[ "$1" = "--" ] && shift

printf '%s\n' "" "Program name: ${prog}" "Build type: ${buildType}" "Build without updating: ${buildOnly}" ""

# Clone if needed
cloned="false"
updates="false"
if [[ ! -d "$HOME/programs/code-${prog}" ]]; then
    mkdir -p "$HOME/programs" || exit 1
    git clone "$repo" "$HOME/programs/code-${prog}" || exit 1
    pushd "$HOME/programs/code-${prog}" 1>/dev/null || exit 1
    cloned="true"
else
    pushd "$HOME/programs/code-${prog}" 1>/dev/null || exit 1
    git fetch
    if [[ $(git rev-parse HEAD) != $(git rev-parse '@{u}') ]]; then
        updates="true"
    fi
fi

# Pull updates if necessary
if [[ "$updates" = "true" && "$buildOnly" = "false" ]]; then
    git pull || exit 1
fi

# Find out which branch git is on
branch="$(git rev-parse --abbrev-ref HEAD)"

# Set build and install folder names
if [[ $branch = $master && $buildType = release ]]; then
    buildDir="$HOME/programs/code-${prog}/build"
    installDir="$HOME/programs/${prog}"
else
    buildDir="$HOME/programs/code-${prog}/build-${branch}-${buildType}"
    installDir="$HOME/programs/${prog}-${branch}-${buildType}"
fi

existsExe="false"
if [[ -e "${installDir}/${exePath}" ]]; then
    existsExe="true"
fi

# Quit if no updates and build-only flag not set
if [[ "$cloned" = "false" && "$buildOnly" = "false" && "$updates" = "false" && "$existsExe" = "true" ]]; then
    printf '%s\n' "No updates, nothing to do."
    exit 0
fi

# Determine CPU count
cpuCount="fail"
if command -v nproc >/dev/null 2>&1; then
    cpuCount="$(nproc --all)"
fi
if [[ ! ( $cpuCount -ge 1 && $cpuCount -le 64 ) ]]; then
    cpuCount=1
fi

# Prepare folders
rm -rf "${installDir}"
mkdir -p "${buildDir}" "${installDir}" || exit 1
cd "${buildDir}" || exit 1

# -----------------------------------------------------------------------------
# Compile

cmake \
    -DCMAKE_CXX_FLAGS="-std=c++11 -Wno-deprecated-declarations -Wno-unused-result" \
    -DCMAKE_INSTALL_PREFIX="${installDir}" \
    -DCMAKE_RUNTIME_OUTPUT_DIRECTORY="." \
    -DCMAKE_BUILD_TYPE="$buildType"  \
    -DCMAKE_C_FLAGS="-O2 -pipe" \
    -DCMAKE_CXX_FLAGS="${CMAKE_C_FLAGS}" \
    "$HOME/programs/code-${prog}" || exit 1

make --jobs="$cpuCount" || exit 1
make install || exit 1

# Finished
printf '%s\n' "" "To run ${prog} type:" "${installDir}/${exePath}" ""

popd 1>/dev/null
