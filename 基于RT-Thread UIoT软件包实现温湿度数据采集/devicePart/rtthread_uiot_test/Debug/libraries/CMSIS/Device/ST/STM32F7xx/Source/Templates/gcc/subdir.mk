################################################################################
# 自动生成的文件。不要编辑！
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
S_SRCS += \
../libraries/CMSIS/Device/ST/STM32F7xx/Source/Templates/gcc/startup_stm32f767xx.s 

OBJS += \
./libraries/CMSIS/Device/ST/STM32F7xx/Source/Templates/gcc/startup_stm32f767xx.o 

S_DEPS += \
./libraries/CMSIS/Device/ST/STM32F7xx/Source/Templates/gcc/startup_stm32f767xx.d 


# Each subdirectory must supply rules for building sources it contributes
libraries/CMSIS/Device/ST/STM32F7xx/Source/Templates/gcc/%.o: ../libraries/CMSIS/Device/ST/STM32F7xx/Source/Templates/gcc/%.s
	arm-none-eabi-gcc -mcpu=cortex-m7 -mthumb -mfloat-abi=hard -mfpu=fpv5-sp-d16 -O0 -ffunction-sections -fdata-sections -Wall  -g -gdwarf-2 -x assembler-with-cpp -I"D:\software\RT-ThreadStudio\workspace\rtthread_uiot_test" -Xassembler -mimplicit-it=thumb -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -c -o "$@" "$<"

