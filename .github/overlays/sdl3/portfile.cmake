vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO libsdl-org/SDL
    REF "release-${VERSION}"
    SHA512 f5da0573118330ecef40d0cbb0a4a01c03a0c0e376624108ed9abe8769cdf68d8c61868d771ab65dd1666690d2a363e1dd1cd5cca408eb8ac9b9b613caa4af40
    HEAD_REF main
)

string(COMPARE EQUAL "${VCPKG_LIBRARY_LINKAGE}" "static" SDL_STATIC)
string(COMPARE EQUAL "${VCPKG_LIBRARY_LINKAGE}" "dynamic" SDL_SHARED)
string(COMPARE EQUAL "${VCPKG_CRT_LINKAGE}" "static" FORCE_STATIC_VCRT)

vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        alsa SDL_ALSA
        dbus SDL_DBUS
        ibus SDL_IBUS
        vulkan SDL_VULKAN
        wayland SDL_WAYLAND
        x11 SDL_X11
        libusb SDL_HIDAPI_LIBUSB
)

if ("libusb" IN_LIST FEATURES)
    if(VCPKG_LIBRARY_LINKAGE STREQUAL "dynamic")
        vcpkg_list(APPEND FEATURE_OPTIONS "-DSDL_HIDAPI_LIBUSB_SHARED=ON")
    else()
        vcpkg_list(APPEND FEATURE_OPTIONS "-DSDL_HIDAPI_LIBUSB_SHARED=OFF")
    endif()
endif()

list(APPEND FEATURE_OPTIONS -DSDL_UNIX_CONSOLE_BUILD=ON)
if (VCPKG_TARGET_IS_LINUX AND NOT "x11" IN_LIST FEATURES AND NOT "wayland" IN_LIST FEATURES)
    message(WARNING "The selected features don't allow sdl3 to create windows.")
endif()

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        ${FEATURE_OPTIONS}
        -DSDL_STATIC=${SDL_STATIC}
        -DSDL_SHARED=${SDL_SHARED}
        -DSDL_FORCE_STATIC_VCRT=${FORCE_STATIC_VCRT}
        -DSDL_LIBC=ON
        -DSDL_TEST_LIBRARY=OFF
        -DSDL_TESTS=OFF
        -DSDL_X11_XSCRNSAVER=OFF
        -DSDL_X11_XFIXES=OFF
        -DSDL_INSTALL_CMAKEDIR_ROOT=share/${PORT}
        -DSDL_REVISION=vcpkg
    MAYBE_UNUSED_VARIABLES SDL_FORCE_STATIC_VCRT
)

vcpkg_cmake_install()
vcpkg_cmake_config_fixup()
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include" "${CURRENT_PACKAGES_DIR}/debug/share")
vcpkg_copy_pdbs()
vcpkg_fixup_pkgconfig()
file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE.txt")
