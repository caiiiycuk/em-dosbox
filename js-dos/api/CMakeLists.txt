cmake_minimum_required(VERSION 2.8)

project(js-dos)

set(CMAKE_BUILD_TYPE Release)
set(CMAKE_C_FLAGS_RELEASE "-O3 -DNDEBUG -Wno-implicit-function-declaration")
set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE}")
set(ROOT "${CMAKE_CURRENT_SOURCE_DIR}/../..")

if(EMSCRIPTEN)
  set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -s -s TOTAL_MEMORY=134217728 --memory-init-file 0")
  add_definitions(-DOPENCV_VERSION=${OpenCV_VERSION})
endif(EMSCRIPTEN)

set(LIB_ZLIB_PATH "${ROOT}/js-dos/3rd-party/zlib-1.2.8")
set(LIB_ZIP_PATH "${ROOT}/js-dos/3rd-party/libzip-0.11.2/lib")

include_directories(${LIB_ZLIB_PATH} ${LIB_ZIP_PATH} ${CMAKE_CURRENT_SOURCE_DIR} "${ROOT}/include")

file(GLOB LIB_ZLIB "${LIB_ZLIB_PATH}/*.c")
file(GLOB LIB_ZIP "${LIB_ZIP_PATH}/*.c")
file(GLOB DOSBOX 
    "${ROOT}/src/*.cpp"
    "${ROOT}/src/**/*.cpp"
    "${ROOT}/src/hardware/**/*.cpp")

add_executable(js-dos extract.c ${LIB_ZLIB} ${LIB_ZIP} ${DOSBOX})

add_custom_command(
    TARGET js-dos
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_CURRENT_BINARY_DIR}/js-dos.js" "${CMAKE_CURRENT_SOURCE_DIR}/js/js-dos.js")