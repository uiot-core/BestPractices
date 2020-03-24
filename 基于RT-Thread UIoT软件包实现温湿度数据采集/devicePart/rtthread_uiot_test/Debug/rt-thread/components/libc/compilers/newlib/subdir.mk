################################################################################
# 自动生成的文件。不要编辑！
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../rt-thread/components/libc/compilers/newlib/libc.c \
../rt-thread/components/libc/compilers/newlib/libc_syms.c \
../rt-thread/components/libc/compilers/newlib/stdio.c \
../rt-thread/components/libc/compilers/newlib/syscalls.c \
../rt-thread/components/libc/compilers/newlib/time.c 

OBJS += \
./rt-thread/components/libc/compilers/newlib/libc.o \
./rt-thread/components/libc/compilers/newlib/libc_syms.o \
./rt-thread/components/libc/compilers/newlib/stdio.o \
./rt-thread/components/libc/compilers/newlib/syscalls.o \
./rt-thread/components/libc/compilers/newlib/time.o 

C_DEPS += \
./rt-thread/components/libc/compilers/newlib/libc.d \
./rt-thread/components/libc/compilers/newlib/libc_syms.d \
./rt-thread/components/libc/compilers/newlib/stdio.d \
./rt-thread/components/libc/compilers/newlib/syscalls.d \
./rt-thread/components/libc/compilers/newlib/time.d 


# Each subdirectory must supply rules for building sources it contributes
rt-thread/components/libc/compilers/newlib/%.o: ../rt-thread/components/libc/compilers/newlib/%.c
	arm-none-eabi-gcc -mcpu=cortex-m7 -mthumb -mfloat-abi=hard -mfpu=fpv5-sp-d16 -O0 -ffunction-sections -fdata-sections -Wall  -g -gdwarf-2 -DDEBUG -I"D:\software\RT-ThreadStudio\workspace\rtthread_uiot_test\drivers" -I"D:\software\RT-ThreadStudio\workspace\rtthread_uiot_test\libraries" -I"D:\software\RT-ThreadStudio\workspace\rtthread_uiot_test\libraries\CMSIS\Device\ST\STM32F7xx\Include" -I"D:\software\RT-ThreadStudio\workspace\rtthread_uiot_test\libraries\CMSIS\Include" -I"D:\software\RT-ThreadStudio\workspace\rtthread_uiot_test\libraries\STM32F7xx_HAL_Driver\Inc" -I"D:\software\RT-ThreadStudio\workspace\rtthread_uiot_test" -I"D:\software\RT-ThreadStudio\workspace\rtthread_uiot_test\packages\at_device-v2.0.2\class\ec20" -I"D:\software\RT-ThreadStudio\workspace\rtthread_uiot_test\packages\at_device-v2.0.2\inc" -I"D:\software\RT-ThreadStudio\workspace\rtthread_uiot_test\packages\dht11-latest" -I"D:\software\RT-ThreadStudio\workspace\rtthread_uiot_test\packages\ucloud_iot_sdk-latest\ports\fal" -I"D:\software\RT-ThreadStudio\workspace\rtthread_uiot_test\packages\ucloud_iot_sdk-latest\ports\rtthread" -I"D:\software\RT-ThreadStudio\workspace\rtthread_uiot_test\packages\ucloud_iot_sdk-latest\ports\ssl" -I"D:\software\RT-ThreadStudio\workspace\rtthread_uiot_test\packages\ucloud_iot_sdk-latest\uiot\certs" -I"D:\software\RT-ThreadStudio\workspace\rtthread_uiot_test\packages\ucloud_iot_sdk-latest\uiot\dev_model\include" -I"D:\software\RT-ThreadStudio\workspace\rtthread_uiot_test\packages\ucloud_iot_sdk-latest\uiot\mqtt\include" -I"D:\software\RT-ThreadStudio\workspace\rtthread_uiot_test\packages\ucloud_iot_sdk-latest\uiot\ota\include" -I"D:\software\RT-ThreadStudio\workspace\rtthread_uiot_test\packages\ucloud_iot_sdk-latest\uiot\sdk-impl" -I"D:\software\RT-ThreadStudio\workspace\rtthread_uiot_test\packages\ucloud_iot_sdk-latest\uiot\shadow\include" -I"D:\software\RT-ThreadStudio\workspace\rtthread_uiot_test\packages\ucloud_iot_sdk-latest\uiot\utils" -I"D:\software\RT-ThreadStudio\workspace\rtthread_uiot_test\rt-thread\components\drivers\include" -I"D:\software\RT-ThreadStudio\workspace\rtthread_uiot_test\rt-thread\components\drivers\sensors" -I"D:\software\RT-ThreadStudio\workspace\rtthread_uiot_test\rt-thread\components\finsh" -I"D:\software\RT-ThreadStudio\workspace\rtthread_uiot_test\rt-thread\components\libc\compilers\newlib" -I"D:\software\RT-ThreadStudio\workspace\rtthread_uiot_test\rt-thread\components\net\at\at_socket" -I"D:\software\RT-ThreadStudio\workspace\rtthread_uiot_test\rt-thread\components\net\at\include" -I"D:\software\RT-ThreadStudio\workspace\rtthread_uiot_test\rt-thread\components\net\netdev\include" -I"D:\software\RT-ThreadStudio\workspace\rtthread_uiot_test\rt-thread\components\net\sal_socket\impl" -I"D:\software\RT-ThreadStudio\workspace\rtthread_uiot_test\rt-thread\components\net\sal_socket\include\socket\sys_socket" -I"D:\software\RT-ThreadStudio\workspace\rtthread_uiot_test\rt-thread\components\net\sal_socket\include\socket" -I"D:\software\RT-ThreadStudio\workspace\rtthread_uiot_test\rt-thread\components\net\sal_socket\include" -I"D:\software\RT-ThreadStudio\workspace\rtthread_uiot_test\rt-thread\include" -I"D:\software\RT-ThreadStudio\workspace\rtthread_uiot_test\rt-thread\libcpu\arm\common" -I"D:\software\RT-ThreadStudio\workspace\rtthread_uiot_test\rt-thread\libcpu\arm\cortex-m7" -include"D:\software\RT-ThreadStudio\workspace\rtthread_uiot_test\rtconfig_preinc.h" -std=gnu11 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -c -o "$@" "$<"

