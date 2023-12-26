cmake_minimum_required(VERSION 3.19)

project(whisper_test VERSION 0.0.1 LANGUAGES C CXX)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fPIC")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fPIC")

add_library(ggml SHARED whisper.cpp/ggml.c)
add_library(ggml-alloc SHARED whisper.cpp/ggml-alloc.c)
add_library(ggml-metal SHARED whisper.cpp/ggml-metal.m)
add_library(whisper SHARED whisper.cpp/whisper.cpp)
add_library(whisper_test SHARED whisper_flutter_plus.cpp)

# set_target_properties(whisper_test PROPERTIES
#   PUBLIC_HEADER whisper.cpp/whisper.h 
#   OUTPUT_NAME "whisper"
# )

# if (WIN32)
# set_target_properties(whisper_flutter PROPERTIES
#   WINDOWS_EXPORT_ALL_SYMBOLS ON
# )
# endif (WIN32)

# target_compile_definitions(whisper_test PUBLIC DART_SHARED_LIB)
# target_link_libraries(whisper_test PRIVATE whisper ggml ${CMAKE_THREAD_LIBS_INIT})
