package(default_visibility = ["//visibility:public"])

cc_library(
	name = "cmsis",
	hdrs = glob([
		"Drivers/CMSIS/Core/Include/*.h",
		"Drivers/CMSIS/Device/ST/STM32F4xx/Include/**/*.h",
	]),
	includes = [
		"Drivers/CMSIS/Core/Include",
		"Drivers/CMSIS/Device/ST/STM32F4xx/Include",
	],
)

cc_library(
	name = "hal",
	srcs = [
    	"Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_tim.c",
    	"Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_tim_ex.c",
    	"Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_hcd.c",
    	"Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_ll_usb.c",
    	"Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_rcc.c",
    	"Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_rcc_ex.c",
    	"Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_flash.c",
    	"Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_flash_ex.c",
    	"Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_flash_ramfunc.c",
    	"Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_gpio.c",
    	"Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_dma_ex.c",
    	"Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_dma.c",
    	"Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_pwr.c",
    	"Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_pwr_ex.c",
    	"Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_cortex.c",
    	"Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal.c",
    	"Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_exti.c",
    	"Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_crc.c",
    	"Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_dma2d.c",
    	"Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_ll_fmc.c",
    	"Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_nor.c",
    	"Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_sram.c",
    	"Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_nand.c",
    	"Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_pccard.c",
    	"Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_sdram.c",
    	"Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_i2c.c",
    	"Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_i2c_ex.c",
    	"Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_ltdc.c",
    	"Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_ltdc_ex.c",
    	"Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_dsi.c",
    	"Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_spi.c",
    	"Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_uart.c",
	],
	hdrs = glob([
		"Drivers/STM32F4xx_HAL_Driver/Inc/*.h",
		"Drivers/STM32F4xx_HAL_Driver/Inc/Legacy/*.h",
	]),
	includes = [
		"Drivers/STM32F4xx_HAL_Driver/Inc",
		"Drivers/STM32F4xx_HAL_Driver/Inc/Legacy",
	],
	deps = [
        ":cmsis",
		"@//cube:hal_config",
    ],
)

cc_library(
	name = "f429i_discovery_drivers",
	srcs = glob([
		"Drivers/BSP/STM32F429I-Discovery/*.c",
		"Drivers/BSP/Components/**/*.c",
	]),
	hdrs = glob([
		"Drivers/BSP/STM32F429I-Discovery/*.h",
		"Drivers/BSP/Components/**/*.h",
	]) + [
		"Utilities/Fonts/fonts.h",
	],
	textual_hdrs = glob([
		"Utilities/Fonts/*.c",
	]),
	includes = [
		"Drivers/BSP/STM32F429I-Discovery",
		"Utilities/Fonts",
	],
	deps = [
		":hal",
	],
)

cc_library(
	name = "freertos",
	srcs = glob([
		"Middlewares/Third_Party/FreeRTOS/Source/*.c",
		"Middlewares/Third_Party/FreeRTOS/Source/portable/GCC/ARM_CM4F/*.c",
	]) + [
		"Middlewares/Third_Party/FreeRTOS/Source/portable/MemMang/heap_4.c",
		"Middlewares/Third_Party/FreeRTOS/Source/CMSIS_RTOS/cmsis_os.c",
	],
	hdrs = glob([
		"Middlewares/Third_Party/FreeRTOS/Source/include/*.h",
		"Middlewares/Third_Party/FreeRTOS/Source/portable/GCC/ARM_CM4F/*.h",
	]) + [
		"Middlewares/Third_Party/FreeRTOS/Source/CMSIS_RTOS/cmsis_os.h",
	],
	includes = [
		"Middlewares/Third_Party/FreeRTOS/Source/include",
		"Middlewares/Third_Party/FreeRTOS/Source/portable/GCC/ARM_CM4F",
		"Middlewares/Third_Party/FreeRTOS/Source/CMSIS_RTOS",
	],
	deps = [
		":cmsis",
		"@//cube:freertos_config",
	],
)

