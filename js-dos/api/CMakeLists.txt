cmake_minimum_required(VERSION 2.8)

project(js-dos)

set(CMAKE_BUILD_TYPE Release)
set(CMAKE_C_FLAGS_RELEASE "-O3 -DNDEBUG -Wno-implicit-function-declaration")
set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE}")
set(ROOT "${CMAKE_CURRENT_SOURCE_DIR}/../..")
set(SRC "${ROOT}/src")

if(EMSCRIPTEN)
  set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} \
    --memory-init-file 0 \
    -s TOTAL_MEMORY=134217728 \
    -s EMTERPRETIFY=1 \
    -s EMTERPRETIFY_ASYNC=1 \
    -s EMTERPRETIFY_WHITELIST=@${ROOT}/src/emterpretify.txt \
    -s FETCH=1")
  add_definitions(-DOPENCV_VERSION=${OpenCV_VERSION})
endif(EMSCRIPTEN)

add_definitions(-DEMTERPRETER_SYNC)
add_definitions(-DEMTERPRETER)

set(LIB_ZLIB_PATH "${ROOT}/js-dos/3rd-party/zlib-1.2.8")
set(LIB_ZIP_PATH "${ROOT}/js-dos/3rd-party/libzip-0.11.2/lib")

include_directories(${LIB_ZLIB_PATH} ${LIB_ZIP_PATH} ${CMAKE_CURRENT_SOURCE_DIR} "${ROOT}/include")

file(GLOB LIB_ZLIB "${LIB_ZLIB_PATH}/*.c")
file(GLOB LIB_ZIP "${LIB_ZIP_PATH}/*.c")

add_executable(js-dos 
    extract.c 
    ${LIB_ZLIB}
    ${LIB_ZIP}
)

target_link_libraries(js-dos
    ${SRC}/dosbox.o
    ${SRC}/cpu/libcpu.a
    ${SRC}/debug/libdebug.a
    ${SRC}/dos/libdos.a
    ${SRC}/fpu/libfpu.a
    ${SRC}/hardware/libhardware.a
    ${SRC}/gui/libgui.a
    ${SRC}/ints/libints.a
    ${SRC}/misc/libmisc.a
    ${SRC}/shell/libshell.a
    ${SRC}/hardware/serialport/libserial.a
    ${SRC}/libs/gui_tk/libgui_tk.a
)

add_custom_command(
    TARGET js-dos
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_CURRENT_BINARY_DIR}/js-dos.js" "${CMAKE_CURRENT_SOURCE_DIR}/js/js-dos.js")