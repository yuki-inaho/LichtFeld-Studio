# USD plugins do not produce .lib
set(VCPKG_POLICY_DLLS_WITHOUT_LIBS enabled)

# Proper support for a true static usd build is left as a future port improvement.
vcpkg_check_linkage(ONLY_DYNAMIC_LIBRARY)

string(REPLACE "." ";" version_components ${VERSION})
foreach(component IN LISTS version_components)
    string(LENGTH ${component} component_length)
    if(component_length LESS 2)
        list(APPEND USD_VERSION "0${component}")
    else()
        list(APPEND USD_VERSION "${component}")
    endif()
endforeach()
string(JOIN "." USD_VERSION ${USD_VERSION})

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO PixarAnimationStudios/OpenUSD
    REF "v${USD_VERSION}"
    SHA512 d10222a457d71470a26ad6dc812685f257bf5c90a64a11d90e543ef7eaba803aa4e2593c358ebd430ba55856e987f7a6f50597b1ad6d2da737c239ad4f18ad6a
    HEAD_REF release
    PATCHES
        "${VCPKG_ROOT_DIR}/ports/usd/003-fix-dep.patch"
        "${VCPKG_ROOT_DIR}/ports/usd/004-fix_cmake_package.patch"
        "${VCPKG_ROOT_DIR}/ports/usd/007-fix_cmake_hgi_interop.patch"
        "${VCPKG_ROOT_DIR}/ports/usd/008-fix_clang8_compiler_error.patch"
        "${VCPKG_ROOT_DIR}/ports/usd/009-vcpkg_install_folder_conventions.patch"
        "${VCPKG_ROOT_DIR}/ports/usd/010-cmake_export_plugin_as_modules.patch"
        "${VCPKG_ROOT_DIR}/ports/usd/011-fix-tbb2023-task-api.patch"
)

file(REMOVE
    "${SOURCE_PATH}/cmake/modules/FindOpenColorIO.cmake"
    "${SOURCE_PATH}/pxr/imaging/hgiVulkan/vk_mem_alloc.cpp"
    "${SOURCE_PATH}/pxr/imaging/hgiVulkan/vk_mem_alloc.h"
)

vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        imaging        PXR_BUILD_IMAGING
        imaging        PXR_BUILD_USD_IMAGING
        imaging        PXR_ENABLE_GL_SUPPORT
        materialx      PXR_ENABLE_MATERIALX_SUPPORT
        openimageio    PXR_BUILD_OPENIMAGEIO_PLUGIN
        vulkan         PXR_ENABLE_VULKAN_SUPPORT
)

vcpkg_cmake_configure(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS ${FEATURE_OPTIONS}
        # The conda-forge compiler flags used by Pixi include
        # -fvisibility-inlines-hidden. USD's VtArray inline methods are
        # instantiated in libusd_vt and consumed by the other USD DSOs, so
        # disable that flag for the USD package itself.
        "-DCMAKE_CXX_FLAGS:STRING=-fno-visibility-inlines-hidden"
        -DPXR_BUILD_DOCUMENTATION:BOOL=OFF
        -DPXR_BUILD_EXAMPLES:BOOL=OFF
        -DPXR_BUILD_TESTS:BOOL=OFF
        -DPXR_BUILD_TUTORIALS:BOOL=OFF
        -DPXR_BUILD_USD_TOOLS:BOOL=OFF
        -DPXR_BUILD_ALEMBIC_PLUGIN:BOOL=OFF
        -DPXR_BUILD_DRACO_PLUGIN:BOOL=OFF
        -DPXR_BUILD_EMBREE_PLUGIN:BOOL=OFF
        -DPXR_BUILD_PRMAN_PLUGIN:BOOL=OFF
        -DPXR_ENABLE_OPENVDB_SUPPORT:BOOL=OFF
        -DPXR_ENABLE_PTEX_SUPPORT:BOOL=OFF
        -DPXR_PREFER_SAFETY_OVER_SPEED:BOOL=ON
        -DPXR_ENABLE_PYTHON_SUPPORT:BOOL=OFF
        -DPXR_USE_DEBUG_PYTHON:BOOL=OFF
    MAYBE_UNUSED_VARIABLES
        PXR_ENABLE_PTEX_SUPPORT
        PXR_USE_PYTHON_3
        PYTHON_EXECUTABLE
)

vcpkg_cmake_install()
vcpkg_copy_pdbs()

if(NOT DEFINED VCPKG_BUILD_TYPE OR VCPKG_BUILD_TYPE STREQUAL "debug")
    file(GLOB_RECURSE debug_targets
        "${CURRENT_PACKAGES_DIR}/debug/share/pxr/*-debug.cmake")
    foreach(debug_target IN LISTS debug_targets)
        file(READ "${debug_target}" contents)
        string(REPLACE "\${_IMPORT_PREFIX}/usd" "\${_IMPORT_PREFIX}/debug/usd" contents "${contents}")
        string(REPLACE "\${_IMPORT_PREFIX}/plugin" "\${_IMPORT_PREFIX}/debug/plugin" contents "${contents}")
        file(WRITE "${debug_target}" "${contents}")
    endforeach()
endif()

vcpkg_cmake_config_fixup(PACKAGE_NAME "pxr")

file(REMOVE_RECURSE
    "${CURRENT_PACKAGES_DIR}/debug/include"
    "${CURRENT_PACKAGES_DIR}/debug/share"
)

if(VCPKG_TARGET_IS_WINDOWS)
    file(GLOB RELEASE_DLL ${CURRENT_PACKAGES_DIR}/lib/*.dll)
    file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/bin)
    if(NOT VCPKG_BUILD_TYPE)
        file(GLOB DEBUG_DLL ${CURRENT_PACKAGES_DIR}/debug/lib/*.dll)
        file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/debug/bin)
    endif()
    foreach(CURRENT_FROM ${RELEASE_DLL} ${DEBUG_DLL})
        string(REPLACE "/lib/" "/bin/" CURRENT_TO ${CURRENT_FROM})
        file(RENAME ${CURRENT_FROM} ${CURRENT_TO})
    endforeach()

    function(file_replace_regex filename match_string replace_string)
        file(READ ${filename} _contents)
        string(REGEX REPLACE "${match_string}" "${replace_string}" _contents "${_contents}")
        file(WRITE ${filename} "${_contents}")
    endfunction()

    if(NOT VCPKG_BUILD_TYPE)
        file_replace_regex(${CURRENT_PACKAGES_DIR}/share/pxr/pxrTargets-debug.cmake "debug/lib/([a-zA-Z0-9_]+)\\.dll" "debug/bin/\\1.dll")
    endif()
    file_replace_regex(${CURRENT_PACKAGES_DIR}/share/pxr/pxrTargets-release.cmake "lib/([a-zA-Z0-9_]+)\\.dll" "bin/\\1.dll")

    file(GLOB_RECURSE PLUGINFO_FILES ${CURRENT_PACKAGES_DIR}/lib/usd/*/resources/plugInfo.json)
    file(GLOB_RECURSE PLUGINFO_FILES_DEBUG ${CURRENT_PACKAGES_DIR}/debug/lib/usd/*/resources/plugInfo.json)
    foreach(PLUGINFO ${PLUGINFO_FILES} ${PLUGINFO_FILES_DEBUG})
        file_replace_regex(${PLUGINFO} [=["LibraryPath": "../../([a-zA-Z0-9_]+).dll"]=] [=["LibraryPath": "../../../bin/\1.dll"]=])
    endforeach()
endif()

vcpkg_install_copyright(FILE_LIST ${SOURCE_PATH}/LICENSE.txt)
