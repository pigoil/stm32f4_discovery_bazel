def stm32_binary(
    name,
    linker_script,
    **kwargs
):
    elf_target = name + ".elf"
    native.cc_binary(
        name = elf_target,
        linkopts = [
            "-T$(location {})".format(linker_script),
        ],
        additional_linker_inputs = [linker_script],
        **kwargs
    )

    native.genrule(
        name = name,
        srcs = [elf_target],
        outs = [
            name + ".bin",
            name + ".hex",
        ],
        cmd = (
            "$(OBJCOPY) -O binary $< $(location {name}.bin) && " +
            "$(OBJCOPY) -O ihex $< $(location {name}.hex)"
        ).format(name = name),
        toolchains = ["@bazel_tools//tools/cpp:toolchain_type"],
    )

def openocd_flash(
    name,
    target,
    target_cfg = "target/stm32f4x.cfg",
    interface_cfg = "interface/stlink.cfg",
):
    elf_target = target
    if not target.endswith(".elf"):
        elf_target = target + ".elf"

    native.genrule(
        name = name,
        srcs = [elf_target],
        outs = ["{}.log".format(name)],
        cmd = (
            "openocd -f {} -f {} -c \"program $(location {}) verify reset exit\" > $@ 2>&1"
            .format(interface_cfg, target_cfg, elf_target)
        ),
    )
