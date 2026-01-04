load(
    "@bazel_tools//tools/cpp:cc_toolchain_config_lib.bzl",
    "feature",
    "flag_group",
    "flag_set",
    "tool",
    "tool_path",
)


Stm32ToolchainInfo = provider(
    doc = "Provides paths and configuration for an STM32 arm-none-eabi toolchain.",
    fields = {
        "gcc": "Path to arm-none-eabi-gcc",
        "ld": "Path to linker driver (typically arm-none-eabi-gcc)",
        "ar": "Path to arm-none-eabi-ar",
        "as_": "Path to arm-none-eabi-as",
        "cpp": "Path to arm-none-eabi-cpp",
        "nm": "Path to arm-none-eabi-nm",
        "objcopy": "Path to arm-none-eabi-objcopy",
        "objdump": "Path to arm-none-eabi-objdump",
        "strip": "Path to arm-none-eabi-strip",
        "dwp": "Path to arm-none-eabi-dwp",
        "gcov": "Path to arm-none-eabi-gcov",
        "sysroot": "Sysroot path (optional)",
        "cxx_builtin_include_directories": "List of builtin include directories for C/C++",
        "exec_compatible_with": "List of platforms this toolchain is compatible with",
    },
)


def _stm32_toolchain_info_impl(ctx):
    return [
        Stm32ToolchainInfo(
            gcc = ctx.attr.gcc,
            ld = ctx.attr.ld,
            ar = ctx.attr.ar,
            as_ = ctx.attr.as_,
            cpp = ctx.attr.cpp,
            nm = ctx.attr.nm,
            objcopy = ctx.attr.objcopy,
            objdump = ctx.attr.objdump,
            strip = ctx.attr.strip,
            dwp = ctx.attr.dwp,
            gcov = ctx.attr.gcov,
            sysroot = ctx.attr.sysroot,
            cxx_builtin_include_directories = ctx.attr.cxx_builtin_include_directories,
        ),
    ]


stm32_toolchain_info = rule(
    implementation = _stm32_toolchain_info_impl,
    attrs = {
        "gcc": attr.string(mandatory = True),
        "ld": attr.string(mandatory = True),
        "ar": attr.string(mandatory = True),
        "as_": attr.string(mandatory = True),
        "cpp": attr.string(mandatory = True),
        "nm": attr.string(mandatory = True),
        "objcopy": attr.string(mandatory = True),
        "objdump": attr.string(mandatory = True),
        "strip": attr.string(mandatory = True),
        "dwp": attr.string(mandatory = True),
        "gcov": attr.string(mandatory = True),
        "sysroot": attr.string(default = ""),
        "cxx_builtin_include_directories": attr.string_list(default = []),
    },
    doc = "Declares STM32 toolchain tool paths and builtin include dirs.",
)


_C_COMPILE_ACTIONS = [
    "c-compile",
]

_CXX_COMPILE_ACTIONS = [
    "c++-compile",
]

_ASSEMBLE_ACTIONS = [
    "assemble",
    "preprocess-assemble",
]

_LINK_ACTIONS = [
    "c++-link-executable",
]


def _compile_flag_feature(name, actions, flags, enabled = True):
    return feature(
        name = name,
        enabled = enabled,
        flag_sets = [
            flag_set(
                actions = actions,
                flag_groups = [flag_group(flags = flags)],
            ),
        ],
    )

def _impl(ctx):
    tc = ctx.attr.toolchain_info[Stm32ToolchainInfo]

    toolchain_identifier = "stm32_arm_none_eabi"
    host_system_name = "local"
    target_system_name = "stm32"
    target_cpu = "arm"
    target_libc = "newlib"
    compiler = "arm-none-eabi-gcc"
    abi_version = "unknown"
    abi_libc_version = "unknown"

    tool_paths = [
        tool_path(name = "ar", path = tc.ar),
        tool_path(name = "as", path = tc.as_),
        tool_path(name = "cpp", path = tc.cpp),
        tool_path(name = "dwp", path = tc.dwp),
        tool_path(name = "gcc", path = tc.gcc),
        tool_path(name = "gcov", path = tc.gcov),
        tool_path(name = "ld", path = tc.ld),
        tool_path(name = "nm", path = tc.nm),
        tool_path(name = "objcopy", path = tc.objcopy),
        tool_path(name = "objdump", path = tc.objdump),
        tool_path(name = "strip", path = tc.strip),
    ]

    target_flags = [
        "-mcpu=cortex-m4",
        "-mfpu=fpv4-sp-d16",
        "-mfloat-abi=hard",
    ]

    common_warning_flags = [
        "-Wall",
    ]

    section_gc_flags = [
        "-fdata-sections",
        "-ffunction-sections",
    ]

    c_flags = target_flags + common_warning_flags + section_gc_flags

    cxx_flags = c_flags + [
        "-fno-rtti",
        "-fno-exceptions",
        "-fno-threadsafe-statics",
    ]

    asm_flags = target_flags + [
        "-x",
        "assembler-with-cpp",
        "-MMD",
        "-MP",
    ]

    # Match the intent of your CMake toolchain:
    # - Debug: -O0 -g3
    # - Release: -Os -g0
    dbg_flags = ["-O0", "-g3"]
    opt_flags = ["-Os", "-g0"]

    link_flags = target_flags + [
        "--specs=nano.specs",
        "-Wl,--gc-sections",
        "-Wl,--print-memory-usage",
    ]

    features = [
        _compile_flag_feature("stm32_c_flags", _C_COMPILE_ACTIONS, c_flags),
        _compile_flag_feature("stm32_cxx_flags", _CXX_COMPILE_ACTIONS, cxx_flags),
        _compile_flag_feature("stm32_asm_flags", _ASSEMBLE_ACTIONS, asm_flags),
        _compile_flag_feature("dbg", _C_COMPILE_ACTIONS + _CXX_COMPILE_ACTIONS, dbg_flags, enabled = False),
        _compile_flag_feature("opt", _C_COMPILE_ACTIONS + _CXX_COMPILE_ACTIONS, opt_flags, enabled = False),
        _compile_flag_feature("stm32_link_flags", _LINK_ACTIONS, link_flags),
    ]

    cxx_builtin_include_directories = tc.cxx_builtin_include_directories

    # Use gcc as the linker driver for bare-metal; it knows where to find newlib, etc.
    builtin_sysroot = tc.sysroot if tc.sysroot else None

    return cc_common.create_cc_toolchain_config_info(
        ctx = ctx,
        toolchain_identifier = toolchain_identifier,
        host_system_name = host_system_name,
        target_system_name = target_system_name,
        target_cpu = target_cpu,
        target_libc = target_libc,
        compiler = compiler,
        abi_version = abi_version,
        abi_libc_version = abi_libc_version,
        tool_paths = tool_paths,
        features = features,
        action_configs = [],
        cxx_builtin_include_directories = cxx_builtin_include_directories,
        artifact_name_patterns = [],
        make_variables = [],
        builtin_sysroot = builtin_sysroot,
        cc_target_os = None,
    )

stm32_cc_toolchain_config = rule(
    implementation = _impl,
    attrs = {
        "toolchain_info": attr.label(
            mandatory = True,
            providers = [Stm32ToolchainInfo],
        ),
    },
    provides = [CcToolchainConfigInfo],
)

def stm32_cc_toolchain(name, toolchain_info, exec_compatible_with, **kwargs):
    stm32_cc_toolchain_config(
        name = name + "_config",
        toolchain_info = toolchain_info,
    )

    native.filegroup(
        name = name + "_empty",
        srcs = [],
    )

    native.cc_toolchain(
        name = name + "_cc_toolchain",
        toolchain_config = ":" + name + "_config",
        all_files = ":" + name + "_empty",
        ar_files = ":" + name + "_empty",
        as_files = ":" + name + "_empty",
        compiler_files = ":" + name + "_empty",
        dwp_files = ":" + name + "_empty",
        linker_files = ":" + name + "_empty",
        objcopy_files = ":" + name + "_empty",
        strip_files = ":" + name + "_empty",
        **kwargs,
    )

    native.toolchain(
        name = name,
        toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",
        exec_compatible_with = exec_compatible_with,
        target_compatible_with =
        [
            "@platforms//cpu:arm",
            "@platforms//os:none",
        ],
        toolchain = ":" + name + "_cc_toolchain",
    )
