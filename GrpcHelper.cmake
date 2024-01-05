function(link_grpc proto_file_path server_package_name out_dir)
	# grpc and protobuf
    # Find Protobuf installation
    # Looks for protobuf-config.cmake file installed by Protobuf's cmake installation.
    option(protobuf_MODULE_COMPATIBLE TRUE)
    find_package(Protobuf CONFIG REQUIRED)
    message(STATUS "Using protobuf ${Protobuf_VERSION}")
    set(_PROTOBUF_LIBPROTOBUF protobuf::libprotobuf)
    set(_REFLECTION gRPC::grpc++_reflection)
    if(CMAKE_CROSSCOMPILING)
      find_program(_PROTOBUF_PROTOC protoc)
    else()
      set(_PROTOBUF_PROTOC $<TARGET_FILE:protobuf::protoc>)
    endif()
    # Find gRPC installation
    # Looks for gRPCConfig.cmake file installed by gRPC's cmake installation.
    find_package(gRPC CONFIG REQUIRED)
    message(STATUS "Using gRPC ${gRPC_VERSION}")
    set(_GRPC_GRPCPP gRPC::grpc++)
    if(CMAKE_CROSSCOMPILING)
      find_program(_GRPC_CPP_PLUGIN_EXECUTABLE grpc_cpp_plugin)
    else()
      set(_GRPC_CPP_PLUGIN_EXECUTABLE $<TARGET_FILE:gRPC::grpc_cpp_plugin>)
    endif()
    
    get_filename_component(grpc_proto ${proto_file_path} ABSOLUTE)
    get_filename_component(grpc_proto_path ${grpc_proto} PATH)
    
    message(${grpc_proto_path})
    # Generated sources
    set(grpc_proto_srcs "${out_dir}/${server_package_name}.pb.cc")
    set(grpc_proto_hdrs "${out_dir}/${server_package_name}.pb.h")
    set(grpc_grpc_srcs "${out_dir}/${server_package_name}.grpc.pb.cc")
    set(grpc_grpc_hdrs "${out_dir}/${server_package_name}.grpc.pb.h")
    add_custom_command(
          OUTPUT "${grpc_proto_srcs}" "${grpc_proto_hdrs}" "${grpc_grpc_srcs}" "${grpc_grpc_hdrs}"
          COMMAND ${_PROTOBUF_PROTOC}
          ARGS --grpc_out "${out_dir}"
            --cpp_out "${out_dir}"
            -I "${grpc_proto_path}"
            --plugin=protoc-gen-grpc="${_GRPC_CPP_PLUGIN_EXECUTABLE}"
            "${grpc_proto}"
          DEPENDS "${grpc_proto}")
    
    # Include generated *.pb.h files
    include_directories("${out_dir}")
    
    # hw_grpc_proto
    add_library(${server_package_name}_grpc_proto
      ${grpc_grpc_srcs}
      ${grpc_grpc_hdrs}
      ${grpc_proto_srcs}
      ${grpc_proto_hdrs})
    target_link_libraries(${server_package_name}_grpc_proto
      ${_REFLECTION}
      ${_GRPC_GRPCPP}
      ${_PROTOBUF_LIBPROTOBUF})
endfunction(link_grpc)

function(add_proj_render_server proto_file_path server_package_name _PROTOBUF_PROTOC grpc_cpp_plugin out_dir lib_debug_to_link lib_release_to_link)
message(${_PROTOBUF_PROTOC})
    get_filename_component(grpc_proto ${proto_file_path} ABSOLUTE)
    get_filename_component(grpc_proto_path ${grpc_proto} PATH)
    
    message(${grpc_proto_path})
    message(${out_dir})
    # Generated sources
    set(grpc_proto_srcs "${out_dir}/${server_package_name}.pb.cc")
    set(grpc_proto_hdrs "${out_dir}/${server_package_name}.pb.h")
    set(grpc_grpc_srcs "${out_dir}/${server_package_name}.grpc.pb.cc")
    set(grpc_grpc_hdrs "${out_dir}/${server_package_name}.grpc.pb.h")
    add_custom_command(
          OUTPUT "${grpc_proto_srcs}" "${grpc_proto_hdrs}" "${grpc_grpc_srcs}" "${grpc_grpc_hdrs}"
          COMMAND ${_PROTOBUF_PROTOC}
          ARGS --grpc_out "${out_dir}"
            --cpp_out "${out_dir}"
            -I "${grpc_proto_path}"
            --plugin=protoc-gen-grpc="${grpc_cpp_plugin}"
            "${grpc_proto}"
          DEPENDS "${grpc_proto}")
    
    # Include generated *.pb.h files
    include_directories("${out_dir}")
    
    # hw_grpc_proto
    add_library(${server_package_name}_grpc_proto
      ${grpc_grpc_srcs}
      ${grpc_grpc_hdrs}
      ${grpc_proto_srcs}
      ${grpc_proto_hdrs})
    target_link_libraries(${server_package_name}_grpc_proto PRIVATE
      ${lib_debug_to_link} ${lib_release_to_link})
endfunction(add_proj_render_server)

macro(append_libs libs_list libs_dir build_type)
foreach(_target absl_bad_any_cast_impl
absl_bad_optional_access
absl_bad_variant_access
absl_base
absl_city
absl_civil_time
absl_cord
absl_cordz_functions
absl_cordz_handle
absl_cordz_info
absl_cordz_sample_token
absl_cord_internal
absl_crc32c
absl_crc_cord_state
absl_crc_cpu_detect
absl_crc_internal
absl_debugging_internal
absl_demangle_internal
absl_die_if_null
absl_examine_stack
absl_exponential_biased
absl_failure_signal_handler
absl_flags
absl_flags_commandlineflag
absl_flags_commandlineflag_internal
absl_flags_config
absl_flags_internal
absl_flags_marshalling
absl_flags_parse
absl_flags_private_handle_accessor
absl_flags_program_name
absl_flags_reflection
absl_flags_usage
absl_flags_usage_internal
absl_graphcycles_internal
absl_hash
absl_hashtablez_sampler
absl_int128
absl_kernel_timeout_internal
absl_leak_check
absl_log_entry
absl_log_flags
absl_log_globals
absl_log_initialize
absl_log_internal_check_op
absl_log_internal_conditions
absl_log_internal_format
absl_log_internal_globals
absl_log_internal_log_sink_set
absl_log_internal_message
absl_log_internal_nullguard
absl_log_internal_proto
absl_log_severity
absl_log_sink
absl_low_level_hash
absl_malloc_internal
absl_periodic_sampler
absl_random_distributions
absl_random_internal_distribution_test_util
absl_random_internal_platform
absl_random_internal_pool_urbg
absl_random_internal_randen
absl_random_internal_randen_hwaes
absl_random_internal_randen_hwaes_impl
absl_random_internal_randen_slow
absl_random_internal_seed_material
absl_random_seed_gen_exception
absl_random_seed_sequences
absl_raw_hash_set
absl_raw_logging_internal
absl_scoped_set_env
absl_spinlock_wait
absl_stacktrace
absl_status
absl_statusor
absl_strerror
absl_strings
absl_strings_internal
absl_string_view
absl_str_format_internal
absl_symbolize
absl_synchronization
absl_throw_delegate
absl_time
absl_time_zone
address_sorting
cares
gpr
grpc++_alts
grpc++_error_details
grpc++_unsecure
grpc++_reflection 
grpc++
grpc
grpcpp_channelz
grpc_authorization_provider
grpc_plugin_support
grpc_unsecure
re2
upb
upb_collections_lib
upb_json_lib
upb_textformat_lib
utf8_range
utf8_range_lib
utf8_validity )
if (WIN32)
    list(APPEND ${libs_list} ${build_type} "${libs_dir}/${_target}.lib")
elseif(ANDROID)
    list(APPEND ${libs_list} "${libs_dir}/lib${_target}.a")
endif()
endforeach()
endmacro(append_libs)

macro(prepare_grpc_libs gRPC_DIR OpenSSL_DIR GRPC_LIBS_DEBUG GRPC_LIBS_RELEASE _GRPC_CPP_PLUGIN_EXECUTABLE _PROTOBUF_PROTOC)
set(_PROTOBUF_PROTOC "${gRPC_DIR}/win64/release/bin/protoc.exe")
set(_GRPC_CPP_PLUGIN_EXECUTABLE "${gRPC_DIR}/win64/release/bin/grpc_cpp_plugin.exe")

if (WIN32)
include_directories("${gRPC_DIR}/win64/include")
set(LIB_DIR_DEBUG "${gRPC_DIR}/win64/debug/lib")
set(LIB_DIR_RELEASE "${gRPC_DIR}/win64/release/lib")

set(${GRPC_LIBS_DEBUG}
debug ${LIB_DIR_DEBUG}/libprotocd.lib 
debug ${LIB_DIR_DEBUG}/libprotobufd.lib 
debug ${LIB_DIR_DEBUG}/libprotobuf-lited.lib 
debug ${LIB_DIR_DEBUG}/crypto.lib 
debug ${LIB_DIR_DEBUG}/ssl.lib 
debug ${LIB_DIR_DEBUG}/zlibstaticd.lib)

set(${GRPC_LIBS_RELEASE} 
optimized ${LIB_DIR_RELEASE}/libprotoc.lib 
optimized ${LIB_DIR_RELEASE}/libprotobuf.lib 
optimized ${LIB_DIR_RELEASE}/libprotobuf-lite.lib 
optimized ${LIB_DIR_RELEASE}/zlibstatic.lib)

set(OPENSSL_ROOT_DIR "${OpenSSL_DIR}/win64")
set(OpenSSL_LIBRARIY_SSL_NAME libssl.dll.a)
set(OpenSSL_LIBRARY_CRYPRO_NAME libcrypto.dll.a)

append_libs(${GRPC_LIBS_DEBUG} ${LIB_DIR_DEBUG} debug)
append_libs(${GRPC_LIBS_RELEASE} ${LIB_DIR_RELEASE} optimized)

list(APPEND ${GRPC_LIBS_RELEASE} optimized "${OPENSSL_ROOT_DIR}/lib/${OpenSSL_LIBRARIY_SSL_NAME}" optimized "${OPENSSL_ROOT_DIR}/lib/${OpenSSL_LIBRARY_CRYPRO_NAME}")

elseif(ANDROID)
include_directories("${gRPC_DIR}/Android/Release-Static/include")
set(LIB_DIR_DEBUG "${gRPC_DIR}/Android/Release-Static/lib")
set(LIB_DIR_RELEASE "${gRPC_DIR}/Android/Release-Static/lib")

set(${GRPC_LIBS_RELEASE}
${LIB_DIR_RELEASE}/libabsl_bad_any_cast_impl.a
${LIB_DIR_RELEASE}/libabsl_bad_optional_access.a
${LIB_DIR_RELEASE}/libabsl_bad_variant_access.a
${LIB_DIR_RELEASE}/libabsl_base.a
${LIB_DIR_RELEASE}/libabsl_city.a
${LIB_DIR_RELEASE}/libabsl_civil_time.a
${LIB_DIR_RELEASE}/libabsl_cord.a
${LIB_DIR_RELEASE}/libabsl_cordz_functions.a
${LIB_DIR_RELEASE}/libabsl_cordz_handle.a
${LIB_DIR_RELEASE}/libabsl_cordz_info.a
${LIB_DIR_RELEASE}/libabsl_cordz_sample_token.a
${LIB_DIR_RELEASE}/libabsl_cord_internal.a
${LIB_DIR_RELEASE}/libabsl_crc32c.a
${LIB_DIR_RELEASE}/libabsl_crc_cord_state.a
${LIB_DIR_RELEASE}/libabsl_crc_cpu_detect.a
${LIB_DIR_RELEASE}/libabsl_crc_internal.a
${LIB_DIR_RELEASE}/libabsl_debugging_internal.a
${LIB_DIR_RELEASE}/libabsl_demangle_internal.a
${LIB_DIR_RELEASE}/libabsl_die_if_null.a
${LIB_DIR_RELEASE}/libabsl_examine_stack.a
${LIB_DIR_RELEASE}/libabsl_exponential_biased.a
${LIB_DIR_RELEASE}/libabsl_failure_signal_handler.a
${LIB_DIR_RELEASE}/libabsl_flags.a
${LIB_DIR_RELEASE}/libabsl_flags_commandlineflag.a
${LIB_DIR_RELEASE}/libabsl_flags_commandlineflag_internal.a
${LIB_DIR_RELEASE}/libabsl_flags_config.a
${LIB_DIR_RELEASE}/libabsl_flags_internal.a
${LIB_DIR_RELEASE}/libabsl_flags_marshalling.a
${LIB_DIR_RELEASE}/libabsl_flags_parse.a
${LIB_DIR_RELEASE}/libabsl_flags_private_handle_accessor.a
${LIB_DIR_RELEASE}/libabsl_flags_program_name.a
${LIB_DIR_RELEASE}/libabsl_flags_reflection.a
${LIB_DIR_RELEASE}/libabsl_flags_usage.a
${LIB_DIR_RELEASE}/libabsl_flags_usage_internal.a
${LIB_DIR_RELEASE}/libabsl_graphcycles_internal.a
${LIB_DIR_RELEASE}/libabsl_hash.a
${LIB_DIR_RELEASE}/libabsl_hashtablez_sampler.a
${LIB_DIR_RELEASE}/libabsl_int128.a
${LIB_DIR_RELEASE}/libabsl_kernel_timeout_internal.a
${LIB_DIR_RELEASE}/libabsl_leak_check.a
${LIB_DIR_RELEASE}/libabsl_log_entry.a
${LIB_DIR_RELEASE}/libabsl_log_flags.a
${LIB_DIR_RELEASE}/libabsl_log_globals.a
${LIB_DIR_RELEASE}/libabsl_log_initialize.a
${LIB_DIR_RELEASE}/libabsl_log_internal_check_op.a
${LIB_DIR_RELEASE}/libabsl_log_internal_conditions.a
${LIB_DIR_RELEASE}/libabsl_log_internal_format.a
${LIB_DIR_RELEASE}/libabsl_log_internal_globals.a
${LIB_DIR_RELEASE}/libabsl_log_internal_log_sink_set.a
${LIB_DIR_RELEASE}/libabsl_log_internal_message.a
${LIB_DIR_RELEASE}/libabsl_log_internal_nullguard.a
${LIB_DIR_RELEASE}/libabsl_log_internal_proto.a
${LIB_DIR_RELEASE}/libabsl_log_severity.a
${LIB_DIR_RELEASE}/libabsl_log_sink.a
${LIB_DIR_RELEASE}/libabsl_low_level_hash.a
${LIB_DIR_RELEASE}/libabsl_malloc_internal.a
${LIB_DIR_RELEASE}/libabsl_periodic_sampler.a
${LIB_DIR_RELEASE}/libabsl_random_distributions.a
${LIB_DIR_RELEASE}/libabsl_random_internal_distribution_test_util.a
${LIB_DIR_RELEASE}/libabsl_random_internal_platform.a
${LIB_DIR_RELEASE}/libabsl_random_internal_pool_urbg.a
${LIB_DIR_RELEASE}/libabsl_random_internal_randen.a
${LIB_DIR_RELEASE}/libabsl_random_internal_randen_hwaes.a
${LIB_DIR_RELEASE}/libabsl_random_internal_randen_hwaes_impl.a
${LIB_DIR_RELEASE}/libabsl_random_internal_randen_slow.a
${LIB_DIR_RELEASE}/libabsl_random_internal_seed_material.a
${LIB_DIR_RELEASE}/libabsl_random_seed_gen_exception.a
${LIB_DIR_RELEASE}/libabsl_random_seed_sequences.a
${LIB_DIR_RELEASE}/libabsl_raw_hash_set.a
${LIB_DIR_RELEASE}/libabsl_raw_logging_internal.a
${LIB_DIR_RELEASE}/libabsl_scoped_set_env.a
${LIB_DIR_RELEASE}/libabsl_spinlock_wait.a
${LIB_DIR_RELEASE}/libabsl_stacktrace.a
${LIB_DIR_RELEASE}/libabsl_status.a
${LIB_DIR_RELEASE}/libabsl_statusor.a
${LIB_DIR_RELEASE}/libabsl_strerror.a
# LIB_DIR_RELEASEUG}/libabsl_strings.a
# LIB_DIR_RELEASEUG}/libabsl_strings_internal.a
# LIB_DIR_RELEASEUG}/libabsl_string_view.a
${LIB_DIR_RELEASE}/libabsl_str_format_internal.a
${LIB_DIR_RELEASE}/libabsl_symbolize.a
${LIB_DIR_RELEASE}/libabsl_synchronization.a
${LIB_DIR_RELEASE}/libabsl_throw_delegate.a
${LIB_DIR_RELEASE}/libabsl_time.a
${LIB_DIR_RELEASE}/libabsl_time_zone.a
${LIB_DIR_RELEASE}/libaddress_sorting.a
${LIB_DIR_RELEASE}/libcares.a
${LIB_DIR_RELEASE}/libcrypto.a
${LIB_DIR_RELEASE}/libgpr.a
${LIB_DIR_RELEASE}/libgrpc++.a
${LIB_DIR_RELEASE}/libgrpc++_alts.a
${LIB_DIR_RELEASE}/libgrpc++_error_details.a
${LIB_DIR_RELEASE}/libgrpc++_reflection.a
${LIB_DIR_RELEASE}/libgrpc++_unsecure.a
${LIB_DIR_RELEASE}/libgrpc.a
${LIB_DIR_RELEASE}/libgrpcpp_channelz.a
${LIB_DIR_RELEASE}/libgrpc_authorization_provider.a
${LIB_DIR_RELEASE}/libgrpc_plugin_support.a
${LIB_DIR_RELEASE}/libgrpc_unsecure.a
${LIB_DIR_RELEASE}/libprotobuf-lite.a
${LIB_DIR_RELEASE}/libprotobuf.a
${LIB_DIR_RELEASE}/libprotoc.a
${LIB_DIR_RELEASE}/libre2.a
${LIB_DIR_RELEASE}/libssl.a
${LIB_DIR_RELEASE}/libupb.a
${LIB_DIR_RELEASE}/libupb_collections_lib.a
${LIB_DIR_RELEASE}/libupb_json_lib.a
${LIB_DIR_RELEASE}/libupb_textformat_lib.a
${LIB_DIR_RELEASE}/libutf8_range.a
${LIB_DIR_RELEASE}/libutf8_range_lib.a
${LIB_DIR_RELEASE}/libutf8_validity.a
${LIB_DIR_RELEASE}/libz.a)

set(${GRPC_LIBS_DEBUG} 
${LIB_DIR_DEBUG}/libprotoc.a 
${LIB_DIR_DEBUG}/libprotobuf.a 
${LIB_DIR_DEBUG}/libprotobuf-lite.a
${LIB_DIR_DEBUG}/libssl.a 
${LIB_DIR_DEBUG}/libz.a)

append_libs(${GRPC_LIBS_RELEASE} ${LIB_DIR_RELEASE} optimized)

endif()

endmacro(prepare_grpc_libs)