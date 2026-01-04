# STM32F429I Discovery Board with Bazel

This project provides a template to build STM32F429I Discovery board app with Bazel. It manages STM32 HAL libraries and FreeRTOS as external dependencies by cloning from [STM32CubeF4](https://github.com/STMicroelectronics/STM32CubeF4) repository.

## Prerequisites
- ARM GCC Toolchain
- Git
- Bazel, preferably Bazelisk
- OpenOCD (for flashing)

## Building

```bash
$ bazel build //user:app
```

## Flashing
```bash
$ bazel build //user:flash
```

## Creating `compile_commands.json` for IDE integration

```bash
bazel run --platforms=@platforms//host @hedron_compile_commands//:refresh_all
```