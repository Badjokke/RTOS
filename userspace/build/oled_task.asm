
./oled_task:     file format elf32-littlearm


Disassembly of section .text:

00008000 <_start>:
_start():
/home/trefil/sem/sources/userspace/crt0.s:10
;@ startovaci symbol - vstupni bod z jadra OS do uzivatelskeho programu
;@ v podstate jen ihned zavola nejakou C funkci, nepotrebujeme nic tak kritickeho, abychom to vsechno museli psal v ASM
;@ jen _start vlastne ani neni funkce, takze by tento vstupni bod mel byt psany takto; rovnez je treba se ujistit, ze
;@ je tento symbol relokovany spravne na 0x8000 (tam OS ocekava, ze se nachazi vstupni bod)
_start:
    bl __crt0_run
    8000:	eb000017 	bl	8064 <__crt0_run>

00008004 <_hang>:
_hang():
/home/trefil/sem/sources/userspace/crt0.s:13
    ;@ z funkce __crt0_run by se nemel proces uz vratit, ale kdyby neco, tak se zacyklime
_hang:
    b _hang
    8004:	eafffffe 	b	8004 <_hang>

00008008 <__crt0_init_bss>:
__crt0_init_bss():
/home/trefil/sem/sources/userspace/crt0.c:10

extern unsigned int __bss_start;
extern unsigned int __bss_end;

void __crt0_init_bss()
{
    8008:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    800c:	e28db000 	add	fp, sp, #0
    8010:	e24dd00c 	sub	sp, sp, #12
/home/trefil/sem/sources/userspace/crt0.c:11
    for (unsigned int* cur = &__bss_start; cur < &__bss_end; cur++)
    8014:	e59f3040 	ldr	r3, [pc, #64]	; 805c <__crt0_init_bss+0x54>
    8018:	e50b3008 	str	r3, [fp, #-8]
    801c:	ea000005 	b	8038 <__crt0_init_bss+0x30>
/home/trefil/sem/sources/userspace/crt0.c:12 (discriminator 3)
        *cur = 0;
    8020:	e51b3008 	ldr	r3, [fp, #-8]
    8024:	e3a02000 	mov	r2, #0
    8028:	e5832000 	str	r2, [r3]
/home/trefil/sem/sources/userspace/crt0.c:11 (discriminator 3)
    for (unsigned int* cur = &__bss_start; cur < &__bss_end; cur++)
    802c:	e51b3008 	ldr	r3, [fp, #-8]
    8030:	e2833004 	add	r3, r3, #4
    8034:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/userspace/crt0.c:11 (discriminator 1)
    8038:	e51b3008 	ldr	r3, [fp, #-8]
    803c:	e59f201c 	ldr	r2, [pc, #28]	; 8060 <__crt0_init_bss+0x58>
    8040:	e1530002 	cmp	r3, r2
    8044:	3afffff5 	bcc	8020 <__crt0_init_bss+0x18>
/home/trefil/sem/sources/userspace/crt0.c:13
}
    8048:	e320f000 	nop	{0}
    804c:	e320f000 	nop	{0}
    8050:	e28bd000 	add	sp, fp, #0
    8054:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8058:	e12fff1e 	bx	lr
    805c:	0000a32c 	andeq	sl, r0, ip, lsr #6
    8060:	0000a33c 	andeq	sl, r0, ip, lsr r3

00008064 <__crt0_run>:
__crt0_run():
/home/trefil/sem/sources/userspace/crt0.c:16

void __crt0_run()
{
    8064:	e92d4800 	push	{fp, lr}
    8068:	e28db004 	add	fp, sp, #4
    806c:	e24dd008 	sub	sp, sp, #8
/home/trefil/sem/sources/userspace/crt0.c:18
    // inicializace .bss sekce (vynulovani)
    __crt0_init_bss();
    8070:	ebffffe4 	bl	8008 <__crt0_init_bss>
/home/trefil/sem/sources/userspace/crt0.c:21

    // volani konstruktoru globalnich trid (C++)
    _cpp_startup();
    8074:	eb000040 	bl	817c <_cpp_startup>
/home/trefil/sem/sources/userspace/crt0.c:26

    // volani funkce main
    // nebudeme se zde zabyvat predavanim parametru do funkce main
    // jinak by se mohly predavat napr. namapovane do virtualniho adr. prostoru a odkazem pres zasobnik (kam nam muze OS pushnout co chce)
    int result = main(0, 0);
    8078:	e3a01000 	mov	r1, #0
    807c:	e3a00000 	mov	r0, #0
    8080:	eb000078 	bl	8268 <main>
    8084:	e50b0008 	str	r0, [fp, #-8]
/home/trefil/sem/sources/userspace/crt0.c:29

    // volani destruktoru globalnich trid (C++)
    _cpp_shutdown();
    8088:	eb000051 	bl	81d4 <_cpp_shutdown>
/home/trefil/sem/sources/userspace/crt0.c:32

    // volani terminate() syscallu s navratovym kodem funkce main
    asm volatile("mov r0, %0" : : "r" (result));
    808c:	e51b3008 	ldr	r3, [fp, #-8]
    8090:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/userspace/crt0.c:33
    asm volatile("svc #1");
    8094:	ef000001 	svc	0x00000001
/home/trefil/sem/sources/userspace/crt0.c:34
}
    8098:	e320f000 	nop	{0}
    809c:	e24bd004 	sub	sp, fp, #4
    80a0:	e8bd8800 	pop	{fp, pc}

000080a4 <__cxa_guard_acquire>:
__cxa_guard_acquire():
/home/trefil/sem/sources/userspace/cxxabi.cpp:11
	extern "C" int __cxa_guard_acquire (__guard *);
	extern "C" void __cxa_guard_release (__guard *);
	extern "C" void __cxa_guard_abort (__guard *);

	extern "C" int __cxa_guard_acquire (__guard *g)
	{
    80a4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    80a8:	e28db000 	add	fp, sp, #0
    80ac:	e24dd00c 	sub	sp, sp, #12
    80b0:	e50b0008 	str	r0, [fp, #-8]
/home/trefil/sem/sources/userspace/cxxabi.cpp:12
		return !*(char *)(g);
    80b4:	e51b3008 	ldr	r3, [fp, #-8]
    80b8:	e5d33000 	ldrb	r3, [r3]
    80bc:	e3530000 	cmp	r3, #0
    80c0:	03a03001 	moveq	r3, #1
    80c4:	13a03000 	movne	r3, #0
    80c8:	e6ef3073 	uxtb	r3, r3
/home/trefil/sem/sources/userspace/cxxabi.cpp:13
	}
    80cc:	e1a00003 	mov	r0, r3
    80d0:	e28bd000 	add	sp, fp, #0
    80d4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    80d8:	e12fff1e 	bx	lr

000080dc <__cxa_guard_release>:
__cxa_guard_release():
/home/trefil/sem/sources/userspace/cxxabi.cpp:16

	extern "C" void __cxa_guard_release (__guard *g)
	{
    80dc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    80e0:	e28db000 	add	fp, sp, #0
    80e4:	e24dd00c 	sub	sp, sp, #12
    80e8:	e50b0008 	str	r0, [fp, #-8]
/home/trefil/sem/sources/userspace/cxxabi.cpp:17
		*(char *)g = 1;
    80ec:	e51b3008 	ldr	r3, [fp, #-8]
    80f0:	e3a02001 	mov	r2, #1
    80f4:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/userspace/cxxabi.cpp:18
	}
    80f8:	e320f000 	nop	{0}
    80fc:	e28bd000 	add	sp, fp, #0
    8100:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8104:	e12fff1e 	bx	lr

00008108 <__cxa_guard_abort>:
__cxa_guard_abort():
/home/trefil/sem/sources/userspace/cxxabi.cpp:21

	extern "C" void __cxa_guard_abort (__guard *)
	{
    8108:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    810c:	e28db000 	add	fp, sp, #0
    8110:	e24dd00c 	sub	sp, sp, #12
    8114:	e50b0008 	str	r0, [fp, #-8]
/home/trefil/sem/sources/userspace/cxxabi.cpp:23

	}
    8118:	e320f000 	nop	{0}
    811c:	e28bd000 	add	sp, fp, #0
    8120:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8124:	e12fff1e 	bx	lr

00008128 <__dso_handle>:
__dso_handle():
/home/trefil/sem/sources/userspace/cxxabi.cpp:27
}

extern "C" void __dso_handle()
{
    8128:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    812c:	e28db000 	add	fp, sp, #0
/home/trefil/sem/sources/userspace/cxxabi.cpp:29
    // ignore dtors for now
}
    8130:	e320f000 	nop	{0}
    8134:	e28bd000 	add	sp, fp, #0
    8138:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    813c:	e12fff1e 	bx	lr

00008140 <__cxa_atexit>:
__cxa_atexit():
/home/trefil/sem/sources/userspace/cxxabi.cpp:32

extern "C" void __cxa_atexit()
{
    8140:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8144:	e28db000 	add	fp, sp, #0
/home/trefil/sem/sources/userspace/cxxabi.cpp:34
    // ignore dtors for now
}
    8148:	e320f000 	nop	{0}
    814c:	e28bd000 	add	sp, fp, #0
    8150:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8154:	e12fff1e 	bx	lr

00008158 <__cxa_pure_virtual>:
__cxa_pure_virtual():
/home/trefil/sem/sources/userspace/cxxabi.cpp:37

extern "C" void __cxa_pure_virtual()
{
    8158:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    815c:	e28db000 	add	fp, sp, #0
/home/trefil/sem/sources/userspace/cxxabi.cpp:39
    // pure virtual method called
}
    8160:	e320f000 	nop	{0}
    8164:	e28bd000 	add	sp, fp, #0
    8168:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    816c:	e12fff1e 	bx	lr

00008170 <__aeabi_unwind_cpp_pr1>:
__aeabi_unwind_cpp_pr1():
/home/trefil/sem/sources/userspace/cxxabi.cpp:42

extern "C" void __aeabi_unwind_cpp_pr1()
{
    8170:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8174:	e28db000 	add	fp, sp, #0
/home/trefil/sem/sources/userspace/cxxabi.cpp:43 (discriminator 1)
	while (true)
    8178:	eafffffe 	b	8178 <__aeabi_unwind_cpp_pr1+0x8>

0000817c <_cpp_startup>:
_cpp_startup():
/home/trefil/sem/sources/userspace/cxxabi.cpp:61
extern "C" dtor_ptr __DTOR_LIST__[0];
// konec pole destruktoru
extern "C" dtor_ptr __DTOR_END__[0];

extern "C" int _cpp_startup(void)
{
    817c:	e92d4800 	push	{fp, lr}
    8180:	e28db004 	add	fp, sp, #4
    8184:	e24dd008 	sub	sp, sp, #8
/home/trefil/sem/sources/userspace/cxxabi.cpp:66
	ctor_ptr* fnptr;
	
	// zavolame konstruktory globalnich C++ trid
	// v poli __CTOR_LIST__ jsou ukazatele na vygenerovane stuby volani konstruktoru
	for (fnptr = __CTOR_LIST__; fnptr < __CTOR_END__; fnptr++)
    8188:	e59f303c 	ldr	r3, [pc, #60]	; 81cc <_cpp_startup+0x50>
    818c:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/userspace/cxxabi.cpp:66 (discriminator 3)
    8190:	e51b3008 	ldr	r3, [fp, #-8]
    8194:	e59f2034 	ldr	r2, [pc, #52]	; 81d0 <_cpp_startup+0x54>
    8198:	e1530002 	cmp	r3, r2
    819c:	2a000006 	bcs	81bc <_cpp_startup+0x40>
/home/trefil/sem/sources/userspace/cxxabi.cpp:67 (discriminator 2)
		(*fnptr)();
    81a0:	e51b3008 	ldr	r3, [fp, #-8]
    81a4:	e5933000 	ldr	r3, [r3]
    81a8:	e12fff33 	blx	r3
/home/trefil/sem/sources/userspace/cxxabi.cpp:66 (discriminator 2)
	for (fnptr = __CTOR_LIST__; fnptr < __CTOR_END__; fnptr++)
    81ac:	e51b3008 	ldr	r3, [fp, #-8]
    81b0:	e2833004 	add	r3, r3, #4
    81b4:	e50b3008 	str	r3, [fp, #-8]
    81b8:	eafffff4 	b	8190 <_cpp_startup+0x14>
/home/trefil/sem/sources/userspace/cxxabi.cpp:69
	
	return 0;
    81bc:	e3a03000 	mov	r3, #0
/home/trefil/sem/sources/userspace/cxxabi.cpp:70
}
    81c0:	e1a00003 	mov	r0, r3
    81c4:	e24bd004 	sub	sp, fp, #4
    81c8:	e8bd8800 	pop	{fp, pc}
    81cc:	0000a318 	andeq	sl, r0, r8, lsl r3
    81d0:	0000a318 	andeq	sl, r0, r8, lsl r3

000081d4 <_cpp_shutdown>:
_cpp_shutdown():
/home/trefil/sem/sources/userspace/cxxabi.cpp:73

extern "C" int _cpp_shutdown(void)
{
    81d4:	e92d4800 	push	{fp, lr}
    81d8:	e28db004 	add	fp, sp, #4
    81dc:	e24dd008 	sub	sp, sp, #8
/home/trefil/sem/sources/userspace/cxxabi.cpp:77
	dtor_ptr* fnptr;
	
	// zavolame destruktory globalnich C++ trid
	for (fnptr = __DTOR_LIST__; fnptr < __DTOR_END__; fnptr++)
    81e0:	e59f303c 	ldr	r3, [pc, #60]	; 8224 <_cpp_shutdown+0x50>
    81e4:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/userspace/cxxabi.cpp:77 (discriminator 3)
    81e8:	e51b3008 	ldr	r3, [fp, #-8]
    81ec:	e59f2034 	ldr	r2, [pc, #52]	; 8228 <_cpp_shutdown+0x54>
    81f0:	e1530002 	cmp	r3, r2
    81f4:	2a000006 	bcs	8214 <_cpp_shutdown+0x40>
/home/trefil/sem/sources/userspace/cxxabi.cpp:78 (discriminator 2)
		(*fnptr)();
    81f8:	e51b3008 	ldr	r3, [fp, #-8]
    81fc:	e5933000 	ldr	r3, [r3]
    8200:	e12fff33 	blx	r3
/home/trefil/sem/sources/userspace/cxxabi.cpp:77 (discriminator 2)
	for (fnptr = __DTOR_LIST__; fnptr < __DTOR_END__; fnptr++)
    8204:	e51b3008 	ldr	r3, [fp, #-8]
    8208:	e2833004 	add	r3, r3, #4
    820c:	e50b3008 	str	r3, [fp, #-8]
    8210:	eafffff4 	b	81e8 <_cpp_shutdown+0x14>
/home/trefil/sem/sources/userspace/cxxabi.cpp:80
	
	return 0;
    8214:	e3a03000 	mov	r3, #0
/home/trefil/sem/sources/userspace/cxxabi.cpp:81
}
    8218:	e1a00003 	mov	r0, r3
    821c:	e24bd004 	sub	sp, fp, #4
    8220:	e8bd8800 	pop	{fp, pc}
    8224:	0000a318 	andeq	sl, r0, r8, lsl r3
    8228:	0000a318 	andeq	sl, r0, r8, lsl r3

0000822c <_ZL5fputsjPKc>:
_ZL5fputsjPKc():
/home/trefil/sem/sources/userspace/oled_task/main.cpp:25
	"One CPU rules them all.",
	"My favourite sport is ARM wrestling",
	"Old MacDonald had a farm, EIGRP",
};
static void fputs(uint32_t file, const char* string)
{
    822c:	e92d4800 	push	{fp, lr}
    8230:	e28db004 	add	fp, sp, #4
    8234:	e24dd008 	sub	sp, sp, #8
    8238:	e50b0008 	str	r0, [fp, #-8]
    823c:	e50b100c 	str	r1, [fp, #-12]
/home/trefil/sem/sources/userspace/oled_task/main.cpp:26
    write(file, string, strlen(string));
    8240:	e51b000c 	ldr	r0, [fp, #-12]
    8244:	eb0002bc 	bl	8d3c <_Z6strlenPKc>
    8248:	e1a03000 	mov	r3, r0
    824c:	e1a02003 	mov	r2, r3
    8250:	e51b100c 	ldr	r1, [fp, #-12]
    8254:	e51b0008 	ldr	r0, [fp, #-8]
    8258:	eb00005f 	bl	83dc <_Z5writejPKcj>
/home/trefil/sem/sources/userspace/oled_task/main.cpp:27
}
    825c:	e320f000 	nop	{0}
    8260:	e24bd004 	sub	sp, fp, #4
    8264:	e8bd8800 	pop	{fp, pc}

00008268 <main>:
main():
/home/trefil/sem/sources/userspace/oled_task/main.cpp:30

int main(int argc, char** argv)
{
    8268:	e92d4810 	push	{r4, fp, lr}
    826c:	e28db008 	add	fp, sp, #8
    8270:	e24dd01c 	sub	sp, sp, #28
    8274:	e50b0020 	str	r0, [fp, #-32]	; 0xffffffe0
    8278:	e50b1024 	str	r1, [fp, #-36]	; 0xffffffdc
/home/trefil/sem/sources/userspace/oled_task/main.cpp:31
    COLED_Display disp("DEV:oled");
    827c:	e24b3018 	sub	r3, fp, #24
    8280:	e59f1040 	ldr	r1, [pc, #64]	; 82c8 <main+0x60>
    8284:	e1a00003 	mov	r0, r3
    8288:	eb00043f 	bl	938c <_ZN13COLED_DisplayC1EPKc>
/home/trefil/sem/sources/userspace/oled_task/main.cpp:32
    uint32_t uart_file = open("DEV:uart/0", NFile_Open_Mode::Read_Write);
    828c:	e3a01002 	mov	r1, #2
    8290:	e59f0034 	ldr	r0, [pc, #52]	; 82cc <main+0x64>
    8294:	eb00002b 	bl	8348 <_Z4openPKc15NFile_Open_Mode>
    8298:	e50b0010 	str	r0, [fp, #-16]
/home/trefil/sem/sources/userspace/oled_task/main.cpp:33
    fputs(uart_file,"CalcOS v1.1\n");
    829c:	e59f102c 	ldr	r1, [pc, #44]	; 82d0 <main+0x68>
    82a0:	e51b0010 	ldr	r0, [fp, #-16]
    82a4:	ebffffe0 	bl	822c <_ZL5fputsjPKc>
/home/trefil/sem/sources/userspace/oled_task/main.cpp:60
		disp.Flip();

		sleep(0x4000, 0x800); // TODO: z tohohle bude casem cekani na podminkove promenne (na eventu) s timeoutem
	} */

    return 0;
    82a8:	e3a04000 	mov	r4, #0
/home/trefil/sem/sources/userspace/oled_task/main.cpp:31
    COLED_Display disp("DEV:oled");
    82ac:	e24b3018 	sub	r3, fp, #24
    82b0:	e1a00003 	mov	r0, r3
    82b4:	eb00044e 	bl	93f4 <_ZN13COLED_DisplayD1Ev>
/home/trefil/sem/sources/userspace/oled_task/main.cpp:61
}
    82b8:	e1a03004 	mov	r3, r4
    82bc:	e1a00003 	mov	r0, r3
    82c0:	e24bd008 	sub	sp, fp, #8
    82c4:	e8bd8810 	pop	{r4, fp, pc}
    82c8:	00009ff4 	strdeq	r9, [r0], -r4
    82cc:	0000a000 	andeq	sl, r0, r0
    82d0:	0000a00c 	andeq	sl, r0, ip

000082d4 <_Z6getpidv>:
_Z6getpidv():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:5
#include <stdfile.h>
#include <stdstring.h>

uint32_t getpid()
{
    82d4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    82d8:	e28db000 	add	fp, sp, #0
    82dc:	e24dd00c 	sub	sp, sp, #12
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:8
    uint32_t pid;

    asm volatile("swi 0");
    82e0:	ef000000 	svc	0x00000000
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:9
    asm volatile("mov %0, r0" : "=r" (pid));
    82e4:	e1a03000 	mov	r3, r0
    82e8:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:11

    return pid;
    82ec:	e51b3008 	ldr	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:12
}
    82f0:	e1a00003 	mov	r0, r3
    82f4:	e28bd000 	add	sp, fp, #0
    82f8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    82fc:	e12fff1e 	bx	lr

00008300 <_Z9terminatei>:
_Z9terminatei():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:15

void terminate(int exitcode)
{
    8300:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8304:	e28db000 	add	fp, sp, #0
    8308:	e24dd00c 	sub	sp, sp, #12
    830c:	e50b0008 	str	r0, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:16
    asm volatile("mov r0, %0" : : "r" (exitcode));
    8310:	e51b3008 	ldr	r3, [fp, #-8]
    8314:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:17
    asm volatile("swi 1");
    8318:	ef000001 	svc	0x00000001
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:18
}
    831c:	e320f000 	nop	{0}
    8320:	e28bd000 	add	sp, fp, #0
    8324:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8328:	e12fff1e 	bx	lr

0000832c <_Z11sched_yieldv>:
_Z11sched_yieldv():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:21

void sched_yield()
{
    832c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8330:	e28db000 	add	fp, sp, #0
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:22
    asm volatile("swi 2");
    8334:	ef000002 	svc	0x00000002
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:23
}
    8338:	e320f000 	nop	{0}
    833c:	e28bd000 	add	sp, fp, #0
    8340:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8344:	e12fff1e 	bx	lr

00008348 <_Z4openPKc15NFile_Open_Mode>:
_Z4openPKc15NFile_Open_Mode():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:26

uint32_t open(const char* filename, NFile_Open_Mode mode)
{
    8348:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    834c:	e28db000 	add	fp, sp, #0
    8350:	e24dd014 	sub	sp, sp, #20
    8354:	e50b0010 	str	r0, [fp, #-16]
    8358:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:29
    uint32_t file;

    asm volatile("mov r0, %0" : : "r" (filename));
    835c:	e51b3010 	ldr	r3, [fp, #-16]
    8360:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:30
    asm volatile("mov r1, %0" : : "r" (mode));
    8364:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8368:	e1a01003 	mov	r1, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:31
    asm volatile("swi 64");
    836c:	ef000040 	svc	0x00000040
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:32
    asm volatile("mov %0, r0" : "=r" (file));
    8370:	e1a03000 	mov	r3, r0
    8374:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:34

    return file;
    8378:	e51b3008 	ldr	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:35
}
    837c:	e1a00003 	mov	r0, r3
    8380:	e28bd000 	add	sp, fp, #0
    8384:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8388:	e12fff1e 	bx	lr

0000838c <_Z4readjPcj>:
_Z4readjPcj():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:38

uint32_t read(uint32_t file, char* const buffer, uint32_t size)
{
    838c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8390:	e28db000 	add	fp, sp, #0
    8394:	e24dd01c 	sub	sp, sp, #28
    8398:	e50b0010 	str	r0, [fp, #-16]
    839c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    83a0:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:41
    uint32_t rdnum;

    asm volatile("mov r0, %0" : : "r" (file));
    83a4:	e51b3010 	ldr	r3, [fp, #-16]
    83a8:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:42
    asm volatile("mov r1, %0" : : "r" (buffer));
    83ac:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    83b0:	e1a01003 	mov	r1, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:43
    asm volatile("mov r2, %0" : : "r" (size));
    83b4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    83b8:	e1a02003 	mov	r2, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:44
    asm volatile("swi 65");
    83bc:	ef000041 	svc	0x00000041
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:45
    asm volatile("mov %0, r0" : "=r" (rdnum));
    83c0:	e1a03000 	mov	r3, r0
    83c4:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:47

    return rdnum;
    83c8:	e51b3008 	ldr	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:48
}
    83cc:	e1a00003 	mov	r0, r3
    83d0:	e28bd000 	add	sp, fp, #0
    83d4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    83d8:	e12fff1e 	bx	lr

000083dc <_Z5writejPKcj>:
_Z5writejPKcj():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:52


uint32_t write(uint32_t file, const char* buffer, uint32_t size)
{
    83dc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    83e0:	e28db000 	add	fp, sp, #0
    83e4:	e24dd01c 	sub	sp, sp, #28
    83e8:	e50b0010 	str	r0, [fp, #-16]
    83ec:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    83f0:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:55
    uint32_t wrnum;

    asm volatile("mov r0, %0" : : "r" (file));
    83f4:	e51b3010 	ldr	r3, [fp, #-16]
    83f8:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:56
    asm volatile("mov r1, %0" : : "r" (buffer));
    83fc:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8400:	e1a01003 	mov	r1, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:57
    asm volatile("mov r2, %0" : : "r" (size));
    8404:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8408:	e1a02003 	mov	r2, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:58
    asm volatile("swi 66");
    840c:	ef000042 	svc	0x00000042
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:59
    asm volatile("mov %0, r0" : "=r" (wrnum));
    8410:	e1a03000 	mov	r3, r0
    8414:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:61

    return wrnum;
    8418:	e51b3008 	ldr	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:62
}
    841c:	e1a00003 	mov	r0, r3
    8420:	e28bd000 	add	sp, fp, #0
    8424:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8428:	e12fff1e 	bx	lr

0000842c <_Z5closej>:
_Z5closej():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:65

void close(uint32_t file)
{
    842c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8430:	e28db000 	add	fp, sp, #0
    8434:	e24dd00c 	sub	sp, sp, #12
    8438:	e50b0008 	str	r0, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:66
    asm volatile("mov r0, %0" : : "r" (file));
    843c:	e51b3008 	ldr	r3, [fp, #-8]
    8440:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:67
    asm volatile("swi 67");
    8444:	ef000043 	svc	0x00000043
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:68
}
    8448:	e320f000 	nop	{0}
    844c:	e28bd000 	add	sp, fp, #0
    8450:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8454:	e12fff1e 	bx	lr

00008458 <_Z5ioctlj16NIOCtl_OperationPv>:
_Z5ioctlj16NIOCtl_OperationPv():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:71

uint32_t ioctl(uint32_t file, NIOCtl_Operation operation, void* param)
{
    8458:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    845c:	e28db000 	add	fp, sp, #0
    8460:	e24dd01c 	sub	sp, sp, #28
    8464:	e50b0010 	str	r0, [fp, #-16]
    8468:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    846c:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:74
    uint32_t retcode;

    asm volatile("mov r0, %0" : : "r" (file));
    8470:	e51b3010 	ldr	r3, [fp, #-16]
    8474:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:75
    asm volatile("mov r1, %0" : : "r" (operation));
    8478:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    847c:	e1a01003 	mov	r1, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:76
    asm volatile("mov r2, %0" : : "r" (param));
    8480:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8484:	e1a02003 	mov	r2, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:77
    asm volatile("swi 68");
    8488:	ef000044 	svc	0x00000044
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:78
    asm volatile("mov %0, r0" : "=r" (retcode));
    848c:	e1a03000 	mov	r3, r0
    8490:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:80

    return retcode;
    8494:	e51b3008 	ldr	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:81
}
    8498:	e1a00003 	mov	r0, r3
    849c:	e28bd000 	add	sp, fp, #0
    84a0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    84a4:	e12fff1e 	bx	lr

000084a8 <_Z6notifyjj>:
_Z6notifyjj():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:84

uint32_t notify(uint32_t file, uint32_t count)
{
    84a8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    84ac:	e28db000 	add	fp, sp, #0
    84b0:	e24dd014 	sub	sp, sp, #20
    84b4:	e50b0010 	str	r0, [fp, #-16]
    84b8:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:87
    uint32_t retcnt;

    asm volatile("mov r0, %0" : : "r" (file));
    84bc:	e51b3010 	ldr	r3, [fp, #-16]
    84c0:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:88
    asm volatile("mov r1, %0" : : "r" (count));
    84c4:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    84c8:	e1a01003 	mov	r1, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:89
    asm volatile("swi 69");
    84cc:	ef000045 	svc	0x00000045
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:90
    asm volatile("mov %0, r0" : "=r" (retcnt));
    84d0:	e1a03000 	mov	r3, r0
    84d4:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:92

    return retcnt;
    84d8:	e51b3008 	ldr	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:93
}
    84dc:	e1a00003 	mov	r0, r3
    84e0:	e28bd000 	add	sp, fp, #0
    84e4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    84e8:	e12fff1e 	bx	lr

000084ec <_Z4waitjjj>:
_Z4waitjjj():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:96

NSWI_Result_Code wait(uint32_t file, uint32_t count, uint32_t notified_deadline)
{
    84ec:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    84f0:	e28db000 	add	fp, sp, #0
    84f4:	e24dd01c 	sub	sp, sp, #28
    84f8:	e50b0010 	str	r0, [fp, #-16]
    84fc:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8500:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:99
    NSWI_Result_Code retcode;

    asm volatile("mov r0, %0" : : "r" (file));
    8504:	e51b3010 	ldr	r3, [fp, #-16]
    8508:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:100
    asm volatile("mov r1, %0" : : "r" (count));
    850c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8510:	e1a01003 	mov	r1, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:101
    asm volatile("mov r2, %0" : : "r" (notified_deadline));
    8514:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8518:	e1a02003 	mov	r2, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:102
    asm volatile("swi 70");
    851c:	ef000046 	svc	0x00000046
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:103
    asm volatile("mov %0, r0" : "=r" (retcode));
    8520:	e1a03000 	mov	r3, r0
    8524:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:105

    return retcode;
    8528:	e51b3008 	ldr	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:106
}
    852c:	e1a00003 	mov	r0, r3
    8530:	e28bd000 	add	sp, fp, #0
    8534:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8538:	e12fff1e 	bx	lr

0000853c <_Z5sleepjj>:
_Z5sleepjj():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:109

bool sleep(uint32_t ticks, uint32_t notified_deadline)
{
    853c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8540:	e28db000 	add	fp, sp, #0
    8544:	e24dd014 	sub	sp, sp, #20
    8548:	e50b0010 	str	r0, [fp, #-16]
    854c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:112
    uint32_t retcode;

    asm volatile("mov r0, %0" : : "r" (ticks));
    8550:	e51b3010 	ldr	r3, [fp, #-16]
    8554:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:113
    asm volatile("mov r1, %0" : : "r" (notified_deadline));
    8558:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    855c:	e1a01003 	mov	r1, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:114
    asm volatile("swi 3");
    8560:	ef000003 	svc	0x00000003
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:115
    asm volatile("mov %0, r0" : "=r" (retcode));
    8564:	e1a03000 	mov	r3, r0
    8568:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:117

    return retcode;
    856c:	e51b3008 	ldr	r3, [fp, #-8]
    8570:	e3530000 	cmp	r3, #0
    8574:	13a03001 	movne	r3, #1
    8578:	03a03000 	moveq	r3, #0
    857c:	e6ef3073 	uxtb	r3, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:118
}
    8580:	e1a00003 	mov	r0, r3
    8584:	e28bd000 	add	sp, fp, #0
    8588:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    858c:	e12fff1e 	bx	lr

00008590 <_Z24get_active_process_countv>:
_Z24get_active_process_countv():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:121

uint32_t get_active_process_count()
{
    8590:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8594:	e28db000 	add	fp, sp, #0
    8598:	e24dd00c 	sub	sp, sp, #12
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:122
    const NGet_Sched_Info_Type req = NGet_Sched_Info_Type::Active_Process_Count;
    859c:	e3a03000 	mov	r3, #0
    85a0:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:125
    uint32_t retval;

    asm volatile("mov r0, %0" : : "r" (req));
    85a4:	e3a03000 	mov	r3, #0
    85a8:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:126
    asm volatile("mov r1, %0" : : "r" (&retval));
    85ac:	e24b300c 	sub	r3, fp, #12
    85b0:	e1a01003 	mov	r1, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:127
    asm volatile("swi 4");
    85b4:	ef000004 	svc	0x00000004
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:129

    return retval;
    85b8:	e51b300c 	ldr	r3, [fp, #-12]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:130
}
    85bc:	e1a00003 	mov	r0, r3
    85c0:	e28bd000 	add	sp, fp, #0
    85c4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    85c8:	e12fff1e 	bx	lr

000085cc <_Z14get_tick_countv>:
_Z14get_tick_countv():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:133

uint32_t get_tick_count()
{
    85cc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    85d0:	e28db000 	add	fp, sp, #0
    85d4:	e24dd00c 	sub	sp, sp, #12
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:134
    const NGet_Sched_Info_Type req = NGet_Sched_Info_Type::Tick_Count;
    85d8:	e3a03001 	mov	r3, #1
    85dc:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:137
    uint32_t retval;

    asm volatile("mov r0, %0" : : "r" (req));
    85e0:	e3a03001 	mov	r3, #1
    85e4:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:138
    asm volatile("mov r1, %0" : : "r" (&retval));
    85e8:	e24b300c 	sub	r3, fp, #12
    85ec:	e1a01003 	mov	r1, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:139
    asm volatile("swi 4");
    85f0:	ef000004 	svc	0x00000004
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:141

    return retval;
    85f4:	e51b300c 	ldr	r3, [fp, #-12]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:142
}
    85f8:	e1a00003 	mov	r0, r3
    85fc:	e28bd000 	add	sp, fp, #0
    8600:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8604:	e12fff1e 	bx	lr

00008608 <_Z17set_task_deadlinej>:
_Z17set_task_deadlinej():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:145

void set_task_deadline(uint32_t tick_count_required)
{
    8608:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    860c:	e28db000 	add	fp, sp, #0
    8610:	e24dd014 	sub	sp, sp, #20
    8614:	e50b0010 	str	r0, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:146
    const NDeadline_Subservice req = NDeadline_Subservice::Set_Relative;
    8618:	e3a03000 	mov	r3, #0
    861c:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:148

    asm volatile("mov r0, %0" : : "r" (req));
    8620:	e3a03000 	mov	r3, #0
    8624:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:149
    asm volatile("mov r1, %0" : : "r" (&tick_count_required));
    8628:	e24b3010 	sub	r3, fp, #16
    862c:	e1a01003 	mov	r1, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:150
    asm volatile("swi 5");
    8630:	ef000005 	svc	0x00000005
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:151
}
    8634:	e320f000 	nop	{0}
    8638:	e28bd000 	add	sp, fp, #0
    863c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8640:	e12fff1e 	bx	lr

00008644 <_Z26get_task_ticks_to_deadlinev>:
_Z26get_task_ticks_to_deadlinev():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:154

uint32_t get_task_ticks_to_deadline()
{
    8644:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8648:	e28db000 	add	fp, sp, #0
    864c:	e24dd00c 	sub	sp, sp, #12
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:155
    const NDeadline_Subservice req = NDeadline_Subservice::Get_Remaining;
    8650:	e3a03001 	mov	r3, #1
    8654:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:158
    uint32_t ticks;

    asm volatile("mov r0, %0" : : "r" (req));
    8658:	e3a03001 	mov	r3, #1
    865c:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:159
    asm volatile("mov r1, %0" : : "r" (&ticks));
    8660:	e24b300c 	sub	r3, fp, #12
    8664:	e1a01003 	mov	r1, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:160
    asm volatile("swi 5");
    8668:	ef000005 	svc	0x00000005
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:162

    return ticks;
    866c:	e51b300c 	ldr	r3, [fp, #-12]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:163
}
    8670:	e1a00003 	mov	r0, r3
    8674:	e28bd000 	add	sp, fp, #0
    8678:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    867c:	e12fff1e 	bx	lr

00008680 <_Z4pipePKcj>:
_Z4pipePKcj():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:168

const char Pipe_File_Prefix[] = "SYS:pipe/";

uint32_t pipe(const char* name, uint32_t buf_size)
{
    8680:	e92d4800 	push	{fp, lr}
    8684:	e28db004 	add	fp, sp, #4
    8688:	e24dd050 	sub	sp, sp, #80	; 0x50
    868c:	e50b0050 	str	r0, [fp, #-80]	; 0xffffffb0
    8690:	e50b1054 	str	r1, [fp, #-84]	; 0xffffffac
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:170
    char fname[64];
    strncpy(fname, Pipe_File_Prefix, sizeof(Pipe_File_Prefix));
    8694:	e24b3048 	sub	r3, fp, #72	; 0x48
    8698:	e3a0200a 	mov	r2, #10
    869c:	e59f1088 	ldr	r1, [pc, #136]	; 872c <_Z4pipePKcj+0xac>
    86a0:	e1a00003 	mov	r0, r3
    86a4:	eb000149 	bl	8bd0 <_Z7strncpyPcPKci>
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:171
    strncpy(fname + sizeof(Pipe_File_Prefix), name, sizeof(fname) - sizeof(Pipe_File_Prefix) - 1);
    86a8:	e24b3048 	sub	r3, fp, #72	; 0x48
    86ac:	e283300a 	add	r3, r3, #10
    86b0:	e3a02035 	mov	r2, #53	; 0x35
    86b4:	e51b1050 	ldr	r1, [fp, #-80]	; 0xffffffb0
    86b8:	e1a00003 	mov	r0, r3
    86bc:	eb000143 	bl	8bd0 <_Z7strncpyPcPKci>
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:173

    int ncur = sizeof(Pipe_File_Prefix) + strlen(name);
    86c0:	e51b0050 	ldr	r0, [fp, #-80]	; 0xffffffb0
    86c4:	eb00019c 	bl	8d3c <_Z6strlenPKc>
    86c8:	e1a03000 	mov	r3, r0
    86cc:	e283300a 	add	r3, r3, #10
    86d0:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:175

    fname[ncur++] = '#';
    86d4:	e51b3008 	ldr	r3, [fp, #-8]
    86d8:	e2832001 	add	r2, r3, #1
    86dc:	e50b2008 	str	r2, [fp, #-8]
    86e0:	e2433004 	sub	r3, r3, #4
    86e4:	e083300b 	add	r3, r3, fp
    86e8:	e3a02023 	mov	r2, #35	; 0x23
    86ec:	e5432044 	strb	r2, [r3, #-68]	; 0xffffffbc
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:177

    itoa(buf_size, &fname[ncur], 10);
    86f0:	e51b0054 	ldr	r0, [fp, #-84]	; 0xffffffac
    86f4:	e24b2048 	sub	r2, fp, #72	; 0x48
    86f8:	e51b3008 	ldr	r3, [fp, #-8]
    86fc:	e0823003 	add	r3, r2, r3
    8700:	e3a0200a 	mov	r2, #10
    8704:	e1a01003 	mov	r1, r3
    8708:	eb000008 	bl	8730 <_Z4itoaiPcj>
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:179

    return open(fname, NFile_Open_Mode::Read_Write);
    870c:	e24b3048 	sub	r3, fp, #72	; 0x48
    8710:	e3a01002 	mov	r1, #2
    8714:	e1a00003 	mov	r0, r3
    8718:	ebffff0a 	bl	8348 <_Z4openPKc15NFile_Open_Mode>
    871c:	e1a03000 	mov	r3, r0
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:180
}
    8720:	e1a00003 	mov	r0, r3
    8724:	e24bd004 	sub	sp, fp, #4
    8728:	e8bd8800 	pop	{fp, pc}
    872c:	0000a048 	andeq	sl, r0, r8, asr #32

00008730 <_Z4itoaiPcj>:
_Z4itoaiPcj():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:9
{
    const char CharConvArr[] = "0123456789ABCDEF";
}

void itoa(int input, char* output, unsigned int base)
{
    8730:	e92d4800 	push	{fp, lr}
    8734:	e28db004 	add	fp, sp, #4
    8738:	e24dd020 	sub	sp, sp, #32
    873c:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    8740:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    8744:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:10
    int i = 0;
    8748:	e3a03000 	mov	r3, #0
    874c:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:11
    int j = 0;
    8750:	e3a03000 	mov	r3, #0
    8754:	e50b300c 	str	r3, [fp, #-12]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:13

	while (input > 0)
    8758:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    875c:	e3530000 	cmp	r3, #0
    8760:	da000015 	ble	87bc <_Z4itoaiPcj+0x8c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:15
	{
		output[i] = CharConvArr[input % base];
    8764:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8768:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    876c:	e1a00003 	mov	r0, r3
    8770:	eb0004ad 	bl	9a2c <__aeabi_uidivmod>
    8774:	e1a03001 	mov	r3, r1
    8778:	e1a01003 	mov	r1, r3
    877c:	e51b3008 	ldr	r3, [fp, #-8]
    8780:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8784:	e0823003 	add	r3, r2, r3
    8788:	e59f2114 	ldr	r2, [pc, #276]	; 88a4 <_Z4itoaiPcj+0x174>
    878c:	e7d22001 	ldrb	r2, [r2, r1]
    8790:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:16
		input /= base;
    8794:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8798:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    879c:	e1a00003 	mov	r0, r3
    87a0:	eb000426 	bl	9840 <__udivsi3>
    87a4:	e1a03000 	mov	r3, r0
    87a8:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:17
		i++;
    87ac:	e51b3008 	ldr	r3, [fp, #-8]
    87b0:	e2833001 	add	r3, r3, #1
    87b4:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:13
	while (input > 0)
    87b8:	eaffffe6 	b	8758 <_Z4itoaiPcj+0x28>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:20
	}

    if (i == 0)
    87bc:	e51b3008 	ldr	r3, [fp, #-8]
    87c0:	e3530000 	cmp	r3, #0
    87c4:	1a000007 	bne	87e8 <_Z4itoaiPcj+0xb8>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:22
    {
        output[i] = CharConvArr[0];
    87c8:	e51b3008 	ldr	r3, [fp, #-8]
    87cc:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    87d0:	e0823003 	add	r3, r2, r3
    87d4:	e3a02030 	mov	r2, #48	; 0x30
    87d8:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:23
        i++;
    87dc:	e51b3008 	ldr	r3, [fp, #-8]
    87e0:	e2833001 	add	r3, r3, #1
    87e4:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:26
    }

	output[i] = '\0';
    87e8:	e51b3008 	ldr	r3, [fp, #-8]
    87ec:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    87f0:	e0823003 	add	r3, r2, r3
    87f4:	e3a02000 	mov	r2, #0
    87f8:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:27
	i--;
    87fc:	e51b3008 	ldr	r3, [fp, #-8]
    8800:	e2433001 	sub	r3, r3, #1
    8804:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:29 (discriminator 2)

	for (j; j <= i/2; j++)
    8808:	e51b3008 	ldr	r3, [fp, #-8]
    880c:	e1a02fa3 	lsr	r2, r3, #31
    8810:	e0823003 	add	r3, r2, r3
    8814:	e1a030c3 	asr	r3, r3, #1
    8818:	e1a02003 	mov	r2, r3
    881c:	e51b300c 	ldr	r3, [fp, #-12]
    8820:	e1530002 	cmp	r3, r2
    8824:	ca00001b 	bgt	8898 <_Z4itoaiPcj+0x168>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:31 (discriminator 1)
	{
		char c = output[i - j];
    8828:	e51b2008 	ldr	r2, [fp, #-8]
    882c:	e51b300c 	ldr	r3, [fp, #-12]
    8830:	e0423003 	sub	r3, r2, r3
    8834:	e1a02003 	mov	r2, r3
    8838:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    883c:	e0833002 	add	r3, r3, r2
    8840:	e5d33000 	ldrb	r3, [r3]
    8844:	e54b300d 	strb	r3, [fp, #-13]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:32 (discriminator 1)
		output[i - j] = output[j];
    8848:	e51b300c 	ldr	r3, [fp, #-12]
    884c:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8850:	e0822003 	add	r2, r2, r3
    8854:	e51b1008 	ldr	r1, [fp, #-8]
    8858:	e51b300c 	ldr	r3, [fp, #-12]
    885c:	e0413003 	sub	r3, r1, r3
    8860:	e1a01003 	mov	r1, r3
    8864:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8868:	e0833001 	add	r3, r3, r1
    886c:	e5d22000 	ldrb	r2, [r2]
    8870:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:33 (discriminator 1)
		output[j] = c;
    8874:	e51b300c 	ldr	r3, [fp, #-12]
    8878:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    887c:	e0823003 	add	r3, r2, r3
    8880:	e55b200d 	ldrb	r2, [fp, #-13]
    8884:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:29 (discriminator 1)
	for (j; j <= i/2; j++)
    8888:	e51b300c 	ldr	r3, [fp, #-12]
    888c:	e2833001 	add	r3, r3, #1
    8890:	e50b300c 	str	r3, [fp, #-12]
    8894:	eaffffdb 	b	8808 <_Z4itoaiPcj+0xd8>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:36
	}

}
    8898:	e320f000 	nop	{0}
    889c:	e24bd004 	sub	sp, fp, #4
    88a0:	e8bd8800 	pop	{fp, pc}
    88a4:	0000a054 	andeq	sl, r0, r4, asr r0

000088a8 <_Z4atoiPKc>:
_Z4atoiPKc():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:39

int atoi(const char* input)
{
    88a8:	e92d4800 	push	{fp, lr}
    88ac:	e28db004 	add	fp, sp, #4
    88b0:	e24dd010 	sub	sp, sp, #16
    88b4:	e50b0010 	str	r0, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:40
    if(strlen(input) == 1)
    88b8:	e51b0010 	ldr	r0, [fp, #-16]
    88bc:	eb00011e 	bl	8d3c <_Z6strlenPKc>
    88c0:	e1a03000 	mov	r3, r0
    88c4:	e3530001 	cmp	r3, #1
    88c8:	03a03001 	moveq	r3, #1
    88cc:	13a03000 	movne	r3, #0
    88d0:	e6ef3073 	uxtb	r3, r3
    88d4:	e3530000 	cmp	r3, #0
    88d8:	0a000003 	beq	88ec <_Z4atoiPKc+0x44>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:41
        return *input - '0';
    88dc:	e51b3010 	ldr	r3, [fp, #-16]
    88e0:	e5d33000 	ldrb	r3, [r3]
    88e4:	e2433030 	sub	r3, r3, #48	; 0x30
    88e8:	ea00001e 	b	8968 <_Z4atoiPKc+0xc0>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:42
	int output = 0;
    88ec:	e3a03000 	mov	r3, #0
    88f0:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:44

	while (*input != '\0')
    88f4:	e51b3010 	ldr	r3, [fp, #-16]
    88f8:	e5d33000 	ldrb	r3, [r3]
    88fc:	e3530000 	cmp	r3, #0
    8900:	0a000017 	beq	8964 <_Z4atoiPKc+0xbc>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:46
	{
		output *= 10;
    8904:	e51b2008 	ldr	r2, [fp, #-8]
    8908:	e1a03002 	mov	r3, r2
    890c:	e1a03103 	lsl	r3, r3, #2
    8910:	e0833002 	add	r3, r3, r2
    8914:	e1a03083 	lsl	r3, r3, #1
    8918:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:47
		if (*input > '9' || *input < '0')
    891c:	e51b3010 	ldr	r3, [fp, #-16]
    8920:	e5d33000 	ldrb	r3, [r3]
    8924:	e3530039 	cmp	r3, #57	; 0x39
    8928:	8a00000d 	bhi	8964 <_Z4atoiPKc+0xbc>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:47 (discriminator 1)
    892c:	e51b3010 	ldr	r3, [fp, #-16]
    8930:	e5d33000 	ldrb	r3, [r3]
    8934:	e353002f 	cmp	r3, #47	; 0x2f
    8938:	9a000009 	bls	8964 <_Z4atoiPKc+0xbc>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:50
			break;

		output += *input - '0';
    893c:	e51b3010 	ldr	r3, [fp, #-16]
    8940:	e5d33000 	ldrb	r3, [r3]
    8944:	e2433030 	sub	r3, r3, #48	; 0x30
    8948:	e51b2008 	ldr	r2, [fp, #-8]
    894c:	e0823003 	add	r3, r2, r3
    8950:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:52

		input++;
    8954:	e51b3010 	ldr	r3, [fp, #-16]
    8958:	e2833001 	add	r3, r3, #1
    895c:	e50b3010 	str	r3, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:44
	while (*input != '\0')
    8960:	eaffffe3 	b	88f4 <_Z4atoiPKc+0x4c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:55
	}

	return output;
    8964:	e51b3008 	ldr	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:56
}
    8968:	e1a00003 	mov	r0, r3
    896c:	e24bd004 	sub	sp, fp, #4
    8970:	e8bd8800 	pop	{fp, pc}

00008974 <_Z14get_input_typePKc>:
_Z14get_input_typePKc():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:60
//return 1 pokud int
//return 2 pokud float
//return 0 pokud neni cislo
int get_input_type(const char * input){
    8974:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8978:	e28db000 	add	fp, sp, #0
    897c:	e24dd014 	sub	sp, sp, #20
    8980:	e50b0010 	str	r0, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:62
    //existence tecky
    bool dot = false;
    8984:	e3a03000 	mov	r3, #0
    8988:	e54b3005 	strb	r3, [fp, #-5]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:63
    bool trailing_dot = false;
    898c:	e3a03000 	mov	r3, #0
    8990:	e54b3006 	strb	r3, [fp, #-6]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:64
    while(*input != '\0'){
    8994:	e51b3010 	ldr	r3, [fp, #-16]
    8998:	e5d33000 	ldrb	r3, [r3]
    899c:	e3530000 	cmp	r3, #0
    89a0:	0a000023 	beq	8a34 <_Z14get_input_typePKc+0xc0>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:65
        char c = *input;
    89a4:	e51b3010 	ldr	r3, [fp, #-16]
    89a8:	e5d33000 	ldrb	r3, [r3]
    89ac:	e54b3007 	strb	r3, [fp, #-7]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:66
        if(c == '.' && !dot){
    89b0:	e55b3007 	ldrb	r3, [fp, #-7]
    89b4:	e353002e 	cmp	r3, #46	; 0x2e
    89b8:	1a00000c 	bne	89f0 <_Z14get_input_typePKc+0x7c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:66 (discriminator 1)
    89bc:	e55b3005 	ldrb	r3, [fp, #-5]
    89c0:	e2233001 	eor	r3, r3, #1
    89c4:	e6ef3073 	uxtb	r3, r3
    89c8:	e3530000 	cmp	r3, #0
    89cc:	0a000007 	beq	89f0 <_Z14get_input_typePKc+0x7c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:67 (discriminator 2)
            dot = true;
    89d0:	e3a03001 	mov	r3, #1
    89d4:	e54b3005 	strb	r3, [fp, #-5]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:68 (discriminator 2)
            trailing_dot = true;
    89d8:	e3a03001 	mov	r3, #1
    89dc:	e54b3006 	strb	r3, [fp, #-6]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:69 (discriminator 2)
            input++;
    89e0:	e51b3010 	ldr	r3, [fp, #-16]
    89e4:	e2833001 	add	r3, r3, #1
    89e8:	e50b3010 	str	r3, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:70 (discriminator 2)
            continue;
    89ec:	ea00000f 	b	8a30 <_Z14get_input_typePKc+0xbc>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:73
        }
        //nenumericky znak
        if(c < '0' || c > '9')return 0;
    89f0:	e55b3007 	ldrb	r3, [fp, #-7]
    89f4:	e353002f 	cmp	r3, #47	; 0x2f
    89f8:	9a000002 	bls	8a08 <_Z14get_input_typePKc+0x94>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:73 (discriminator 2)
    89fc:	e55b3007 	ldrb	r3, [fp, #-7]
    8a00:	e3530039 	cmp	r3, #57	; 0x39
    8a04:	9a000001 	bls	8a10 <_Z14get_input_typePKc+0x9c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:73 (discriminator 3)
    8a08:	e3a03000 	mov	r3, #0
    8a0c:	ea000014 	b	8a64 <_Z14get_input_typePKc+0xf0>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:75
        //retezec obsahuje tecku a numericke znaky -> tecka je "validni", tedy neni to tecka na konci intu napriklad
        if(dot)
    8a10:	e55b3005 	ldrb	r3, [fp, #-5]
    8a14:	e3530000 	cmp	r3, #0
    8a18:	0a000001 	beq	8a24 <_Z14get_input_typePKc+0xb0>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:76
            trailing_dot = false;
    8a1c:	e3a03000 	mov	r3, #0
    8a20:	e54b3006 	strb	r3, [fp, #-6]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:77
    input++;
    8a24:	e51b3010 	ldr	r3, [fp, #-16]
    8a28:	e2833001 	add	r3, r3, #1
    8a2c:	e50b3010 	str	r3, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:64
    while(*input != '\0'){
    8a30:	eaffffd7 	b	8994 <_Z14get_input_typePKc+0x20>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:79
    }
    if(trailing_dot)return 0;
    8a34:	e55b3006 	ldrb	r3, [fp, #-6]
    8a38:	e3530000 	cmp	r3, #0
    8a3c:	0a000001 	beq	8a48 <_Z14get_input_typePKc+0xd4>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:79 (discriminator 1)
    8a40:	e3a03000 	mov	r3, #0
    8a44:	ea000006 	b	8a64 <_Z14get_input_typePKc+0xf0>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:81
    //float pokud retezec obsahuje non-trailing tecku, 1 pokud je to int
    return dot? 2:1;
    8a48:	e55b3005 	ldrb	r3, [fp, #-5]
    8a4c:	e3530000 	cmp	r3, #0
    8a50:	0a000001 	beq	8a5c <_Z14get_input_typePKc+0xe8>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:81 (discriminator 1)
    8a54:	e3a03002 	mov	r3, #2
    8a58:	ea000000 	b	8a60 <_Z14get_input_typePKc+0xec>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:81 (discriminator 2)
    8a5c:	e3a03001 	mov	r3, #1
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:81
    8a60:	e320f000 	nop	{0}
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:83

}
    8a64:	e1a00003 	mov	r0, r3
    8a68:	e28bd000 	add	sp, fp, #0
    8a6c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8a70:	e12fff1e 	bx	lr

00008a74 <_Z4atofPKc>:
_Z4atofPKc():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:87


//string to float
float atof(const char* input){
    8a74:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8a78:	e28db000 	add	fp, sp, #0
    8a7c:	e24dd03c 	sub	sp, sp, #60	; 0x3c
    8a80:	e50b0038 	str	r0, [fp, #-56]	; 0xffffffc8
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:88
    double output = 0.0;
    8a84:	e3a02000 	mov	r2, #0
    8a88:	e3a03000 	mov	r3, #0
    8a8c:	e14b20fc 	strd	r2, [fp, #-12]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:89
    double factor = 10;
    8a90:	e3a02000 	mov	r2, #0
    8a94:	e59f312c 	ldr	r3, [pc, #300]	; 8bc8 <_Z4atofPKc+0x154>
    8a98:	e14b21fc 	strd	r2, [fp, #-28]	; 0xffffffe4
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:91
    //cast za desetinnou carkou
    double tmp = 0.0;
    8a9c:	e3a02000 	mov	r2, #0
    8aa0:	e3a03000 	mov	r3, #0
    8aa4:	e14b22f4 	strd	r2, [fp, #-36]	; 0xffffffdc
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:92
    int counter = 0;
    8aa8:	e3a03000 	mov	r3, #0
    8aac:	e50b3028 	str	r3, [fp, #-40]	; 0xffffffd8
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:93
    int scale = 1;
    8ab0:	e3a03001 	mov	r3, #1
    8ab4:	e50b3010 	str	r3, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:94
    bool afterDecPoint = false;
    8ab8:	e3a03000 	mov	r3, #0
    8abc:	e54b3011 	strb	r3, [fp, #-17]	; 0xffffffef
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:96

    while(*input != '\0'){
    8ac0:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    8ac4:	e5d33000 	ldrb	r3, [r3]
    8ac8:	e3530000 	cmp	r3, #0
    8acc:	0a000034 	beq	8ba4 <_Z4atofPKc+0x130>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:97
        if (*input == '.'){
    8ad0:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    8ad4:	e5d33000 	ldrb	r3, [r3]
    8ad8:	e353002e 	cmp	r3, #46	; 0x2e
    8adc:	1a000005 	bne	8af8 <_Z4atofPKc+0x84>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:98 (discriminator 1)
            afterDecPoint = true;
    8ae0:	e3a03001 	mov	r3, #1
    8ae4:	e54b3011 	strb	r3, [fp, #-17]	; 0xffffffef
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:99 (discriminator 1)
            input++;
    8ae8:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    8aec:	e2833001 	add	r3, r3, #1
    8af0:	e50b3038 	str	r3, [fp, #-56]	; 0xffffffc8
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:100 (discriminator 1)
            continue;
    8af4:	ea000029 	b	8ba0 <_Z4atofPKc+0x12c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:102
        }
        else if (*input > '9' || *input < '0')break;
    8af8:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    8afc:	e5d33000 	ldrb	r3, [r3]
    8b00:	e3530039 	cmp	r3, #57	; 0x39
    8b04:	8a000026 	bhi	8ba4 <_Z4atofPKc+0x130>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:102 (discriminator 1)
    8b08:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    8b0c:	e5d33000 	ldrb	r3, [r3]
    8b10:	e353002f 	cmp	r3, #47	; 0x2f
    8b14:	9a000022 	bls	8ba4 <_Z4atofPKc+0x130>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:103
        double val = *input - '0';
    8b18:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    8b1c:	e5d33000 	ldrb	r3, [r3]
    8b20:	e2433030 	sub	r3, r3, #48	; 0x30
    8b24:	ee073a90 	vmov	s15, r3
    8b28:	eeb87be7 	vcvt.f64.s32	d7, s15
    8b2c:	ed0b7b0d 	vstr	d7, [fp, #-52]	; 0xffffffcc
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:104
        if(afterDecPoint){
    8b30:	e55b3011 	ldrb	r3, [fp, #-17]	; 0xffffffef
    8b34:	e3530000 	cmp	r3, #0
    8b38:	0a00000f 	beq	8b7c <_Z4atofPKc+0x108>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:105
            scale /= 10;
    8b3c:	e51b3010 	ldr	r3, [fp, #-16]
    8b40:	e59f2084 	ldr	r2, [pc, #132]	; 8bcc <_Z4atofPKc+0x158>
    8b44:	e0c21392 	smull	r1, r2, r2, r3
    8b48:	e1a02142 	asr	r2, r2, #2
    8b4c:	e1a03fc3 	asr	r3, r3, #31
    8b50:	e0423003 	sub	r3, r2, r3
    8b54:	e50b3010 	str	r3, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:106
            output = output + val * scale;
    8b58:	e51b3010 	ldr	r3, [fp, #-16]
    8b5c:	ee073a90 	vmov	s15, r3
    8b60:	eeb86be7 	vcvt.f64.s32	d6, s15
    8b64:	ed1b7b0d 	vldr	d7, [fp, #-52]	; 0xffffffcc
    8b68:	ee267b07 	vmul.f64	d7, d6, d7
    8b6c:	ed1b6b03 	vldr	d6, [fp, #-12]
    8b70:	ee367b07 	vadd.f64	d7, d6, d7
    8b74:	ed0b7b03 	vstr	d7, [fp, #-12]
    8b78:	ea000005 	b	8b94 <_Z4atofPKc+0x120>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:109
        }
        else
            output = output * 10 + val;
    8b7c:	ed1b7b03 	vldr	d7, [fp, #-12]
    8b80:	ed9f6b0e 	vldr	d6, [pc, #56]	; 8bc0 <_Z4atofPKc+0x14c>
    8b84:	ee277b06 	vmul.f64	d7, d7, d6
    8b88:	ed1b6b0d 	vldr	d6, [fp, #-52]	; 0xffffffcc
    8b8c:	ee367b07 	vadd.f64	d7, d6, d7
    8b90:	ed0b7b03 	vstr	d7, [fp, #-12]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:111

        input++;
    8b94:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    8b98:	e2833001 	add	r3, r3, #1
    8b9c:	e50b3038 	str	r3, [fp, #-56]	; 0xffffffc8
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:96
    while(*input != '\0'){
    8ba0:	eaffffc6 	b	8ac0 <_Z4atofPKc+0x4c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:113
    }
    return output;
    8ba4:	ed1b7b03 	vldr	d7, [fp, #-12]
    8ba8:	eef77bc7 	vcvt.f32.f64	s15, d7
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:114
}
    8bac:	eeb00a67 	vmov.f32	s0, s15
    8bb0:	e28bd000 	add	sp, fp, #0
    8bb4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8bb8:	e12fff1e 	bx	lr
    8bbc:	e320f000 	nop	{0}
    8bc0:	00000000 	andeq	r0, r0, r0
    8bc4:	40240000 	eormi	r0, r4, r0
    8bc8:	40240000 	eormi	r0, r4, r0
    8bcc:	66666667 	strbtvs	r6, [r6], -r7, ror #12

00008bd0 <_Z7strncpyPcPKci>:
_Z7strncpyPcPKci():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:116
char* strncpy(char* dest, const char *src, int num)
{
    8bd0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8bd4:	e28db000 	add	fp, sp, #0
    8bd8:	e24dd01c 	sub	sp, sp, #28
    8bdc:	e50b0010 	str	r0, [fp, #-16]
    8be0:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8be4:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:119
	int i;

	for (i = 0; i < num && src[i] != '\0'; i++)
    8be8:	e3a03000 	mov	r3, #0
    8bec:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:119 (discriminator 4)
    8bf0:	e51b2008 	ldr	r2, [fp, #-8]
    8bf4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8bf8:	e1520003 	cmp	r2, r3
    8bfc:	aa000011 	bge	8c48 <_Z7strncpyPcPKci+0x78>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:119 (discriminator 2)
    8c00:	e51b3008 	ldr	r3, [fp, #-8]
    8c04:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    8c08:	e0823003 	add	r3, r2, r3
    8c0c:	e5d33000 	ldrb	r3, [r3]
    8c10:	e3530000 	cmp	r3, #0
    8c14:	0a00000b 	beq	8c48 <_Z7strncpyPcPKci+0x78>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:120 (discriminator 3)
		dest[i] = src[i];
    8c18:	e51b3008 	ldr	r3, [fp, #-8]
    8c1c:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    8c20:	e0822003 	add	r2, r2, r3
    8c24:	e51b3008 	ldr	r3, [fp, #-8]
    8c28:	e51b1010 	ldr	r1, [fp, #-16]
    8c2c:	e0813003 	add	r3, r1, r3
    8c30:	e5d22000 	ldrb	r2, [r2]
    8c34:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:119 (discriminator 3)
	for (i = 0; i < num && src[i] != '\0'; i++)
    8c38:	e51b3008 	ldr	r3, [fp, #-8]
    8c3c:	e2833001 	add	r3, r3, #1
    8c40:	e50b3008 	str	r3, [fp, #-8]
    8c44:	eaffffe9 	b	8bf0 <_Z7strncpyPcPKci+0x20>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:121 (discriminator 2)
	for (; i < num; i++)
    8c48:	e51b2008 	ldr	r2, [fp, #-8]
    8c4c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8c50:	e1520003 	cmp	r2, r3
    8c54:	aa000008 	bge	8c7c <_Z7strncpyPcPKci+0xac>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:122 (discriminator 1)
		dest[i] = '\0';
    8c58:	e51b3008 	ldr	r3, [fp, #-8]
    8c5c:	e51b2010 	ldr	r2, [fp, #-16]
    8c60:	e0823003 	add	r3, r2, r3
    8c64:	e3a02000 	mov	r2, #0
    8c68:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:121 (discriminator 1)
	for (; i < num; i++)
    8c6c:	e51b3008 	ldr	r3, [fp, #-8]
    8c70:	e2833001 	add	r3, r3, #1
    8c74:	e50b3008 	str	r3, [fp, #-8]
    8c78:	eafffff2 	b	8c48 <_Z7strncpyPcPKci+0x78>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:124

   return dest;
    8c7c:	e51b3010 	ldr	r3, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:125
}
    8c80:	e1a00003 	mov	r0, r3
    8c84:	e28bd000 	add	sp, fp, #0
    8c88:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8c8c:	e12fff1e 	bx	lr

00008c90 <_Z7strncmpPKcS0_i>:
_Z7strncmpPKcS0_i():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:128

int strncmp(const char *s1, const char *s2, int num)
{
    8c90:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8c94:	e28db000 	add	fp, sp, #0
    8c98:	e24dd01c 	sub	sp, sp, #28
    8c9c:	e50b0010 	str	r0, [fp, #-16]
    8ca0:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8ca4:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:130
	unsigned char u1, u2;
  	while (num-- > 0)
    8ca8:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8cac:	e2432001 	sub	r2, r3, #1
    8cb0:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
    8cb4:	e3530000 	cmp	r3, #0
    8cb8:	c3a03001 	movgt	r3, #1
    8cbc:	d3a03000 	movle	r3, #0
    8cc0:	e6ef3073 	uxtb	r3, r3
    8cc4:	e3530000 	cmp	r3, #0
    8cc8:	0a000016 	beq	8d28 <_Z7strncmpPKcS0_i+0x98>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:132
    {
      	u1 = (unsigned char) *s1++;
    8ccc:	e51b3010 	ldr	r3, [fp, #-16]
    8cd0:	e2832001 	add	r2, r3, #1
    8cd4:	e50b2010 	str	r2, [fp, #-16]
    8cd8:	e5d33000 	ldrb	r3, [r3]
    8cdc:	e54b3005 	strb	r3, [fp, #-5]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:133
     	u2 = (unsigned char) *s2++;
    8ce0:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8ce4:	e2832001 	add	r2, r3, #1
    8ce8:	e50b2014 	str	r2, [fp, #-20]	; 0xffffffec
    8cec:	e5d33000 	ldrb	r3, [r3]
    8cf0:	e54b3006 	strb	r3, [fp, #-6]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:134
      	if (u1 != u2)
    8cf4:	e55b2005 	ldrb	r2, [fp, #-5]
    8cf8:	e55b3006 	ldrb	r3, [fp, #-6]
    8cfc:	e1520003 	cmp	r2, r3
    8d00:	0a000003 	beq	8d14 <_Z7strncmpPKcS0_i+0x84>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:135
        	return u1 - u2;
    8d04:	e55b2005 	ldrb	r2, [fp, #-5]
    8d08:	e55b3006 	ldrb	r3, [fp, #-6]
    8d0c:	e0423003 	sub	r3, r2, r3
    8d10:	ea000005 	b	8d2c <_Z7strncmpPKcS0_i+0x9c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:136
      	if (u1 == '\0')
    8d14:	e55b3005 	ldrb	r3, [fp, #-5]
    8d18:	e3530000 	cmp	r3, #0
    8d1c:	1affffe1 	bne	8ca8 <_Z7strncmpPKcS0_i+0x18>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:137
        	return 0;
    8d20:	e3a03000 	mov	r3, #0
    8d24:	ea000000 	b	8d2c <_Z7strncmpPKcS0_i+0x9c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:140
    }

  	return 0;
    8d28:	e3a03000 	mov	r3, #0
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:141
}
    8d2c:	e1a00003 	mov	r0, r3
    8d30:	e28bd000 	add	sp, fp, #0
    8d34:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8d38:	e12fff1e 	bx	lr

00008d3c <_Z6strlenPKc>:
_Z6strlenPKc():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:144

int strlen(const char* s)
{
    8d3c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8d40:	e28db000 	add	fp, sp, #0
    8d44:	e24dd014 	sub	sp, sp, #20
    8d48:	e50b0010 	str	r0, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:145
	int i = 0;
    8d4c:	e3a03000 	mov	r3, #0
    8d50:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:147

	while (s[i] != '\0')
    8d54:	e51b3008 	ldr	r3, [fp, #-8]
    8d58:	e51b2010 	ldr	r2, [fp, #-16]
    8d5c:	e0823003 	add	r3, r2, r3
    8d60:	e5d33000 	ldrb	r3, [r3]
    8d64:	e3530000 	cmp	r3, #0
    8d68:	0a000003 	beq	8d7c <_Z6strlenPKc+0x40>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:148
		i++;
    8d6c:	e51b3008 	ldr	r3, [fp, #-8]
    8d70:	e2833001 	add	r3, r3, #1
    8d74:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:147
	while (s[i] != '\0')
    8d78:	eafffff5 	b	8d54 <_Z6strlenPKc+0x18>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:150

	return i;
    8d7c:	e51b3008 	ldr	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:151
}
    8d80:	e1a00003 	mov	r0, r3
    8d84:	e28bd000 	add	sp, fp, #0
    8d88:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8d8c:	e12fff1e 	bx	lr

00008d90 <_Z6strcatPcPKc>:
_Z6strcatPcPKc():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:154
//unsafe varianta
//muze nastat buffer overflow attack
char* strcat(char* dest, const char* src){
    8d90:	e92d4800 	push	{fp, lr}
    8d94:	e28db004 	add	fp, sp, #4
    8d98:	e24dd018 	sub	sp, sp, #24
    8d9c:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    8da0:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:155
    int n = strlen(src);
    8da4:	e51b001c 	ldr	r0, [fp, #-28]	; 0xffffffe4
    8da8:	ebffffe3 	bl	8d3c <_Z6strlenPKc>
    8dac:	e50b0010 	str	r0, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:156
    int m = strlen(dest);
    8db0:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    8db4:	ebffffe0 	bl	8d3c <_Z6strlenPKc>
    8db8:	e50b0008 	str	r0, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:157
    int walker = 0;
    8dbc:	e3a03000 	mov	r3, #0
    8dc0:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:158
    for(int i = 0;i < n; i++)
    8dc4:	e3a03000 	mov	r3, #0
    8dc8:	e50b300c 	str	r3, [fp, #-12]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:158 (discriminator 3)
    8dcc:	e51b200c 	ldr	r2, [fp, #-12]
    8dd0:	e51b3010 	ldr	r3, [fp, #-16]
    8dd4:	e1520003 	cmp	r2, r3
    8dd8:	aa00000e 	bge	8e18 <_Z6strcatPcPKc+0x88>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:159 (discriminator 2)
        dest[m++] = src[i];
    8ddc:	e51b300c 	ldr	r3, [fp, #-12]
    8de0:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8de4:	e0822003 	add	r2, r2, r3
    8de8:	e51b3008 	ldr	r3, [fp, #-8]
    8dec:	e2831001 	add	r1, r3, #1
    8df0:	e50b1008 	str	r1, [fp, #-8]
    8df4:	e1a01003 	mov	r1, r3
    8df8:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8dfc:	e0833001 	add	r3, r3, r1
    8e00:	e5d22000 	ldrb	r2, [r2]
    8e04:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:158 (discriminator 2)
    for(int i = 0;i < n; i++)
    8e08:	e51b300c 	ldr	r3, [fp, #-12]
    8e0c:	e2833001 	add	r3, r3, #1
    8e10:	e50b300c 	str	r3, [fp, #-12]
    8e14:	eaffffec 	b	8dcc <_Z6strcatPcPKc+0x3c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:160
    dest[m] = '\0';
    8e18:	e51b3008 	ldr	r3, [fp, #-8]
    8e1c:	e51b2018 	ldr	r2, [fp, #-24]	; 0xffffffe8
    8e20:	e0823003 	add	r3, r2, r3
    8e24:	e3a02000 	mov	r2, #0
    8e28:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:161
    return dest;
    8e2c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:163

}
    8e30:	e1a00003 	mov	r0, r3
    8e34:	e24bd004 	sub	sp, fp, #4
    8e38:	e8bd8800 	pop	{fp, pc}

00008e3c <_Z7strncatPcPKci>:
_Z7strncatPcPKci():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:164
char* strncat(char* dest, const char* src,int size){
    8e3c:	e92d4800 	push	{fp, lr}
    8e40:	e28db004 	add	fp, sp, #4
    8e44:	e24dd020 	sub	sp, sp, #32
    8e48:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    8e4c:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    8e50:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:165
    int walker = 0;
    8e54:	e3a03000 	mov	r3, #0
    8e58:	e50b3010 	str	r3, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:167
    //najdi odkud muzeme kopirovat, tedy konec retezce
    int m = strlen(dest);
    8e5c:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    8e60:	ebffffb5 	bl	8d3c <_Z6strlenPKc>
    8e64:	e50b0008 	str	r0, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:169
    //nevejdu se
    if(m >= size)return dest;
    8e68:	e51b2008 	ldr	r2, [fp, #-8]
    8e6c:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8e70:	e1520003 	cmp	r2, r3
    8e74:	ba000001 	blt	8e80 <_Z7strncatPcPKci+0x44>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:169 (discriminator 1)
    8e78:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8e7c:	ea000021 	b	8f08 <_Z7strncatPcPKci+0xcc>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:171

    for(int i = 0;i < size; i++){
    8e80:	e3a03000 	mov	r3, #0
    8e84:	e50b300c 	str	r3, [fp, #-12]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:171 (discriminator 1)
    8e88:	e51b200c 	ldr	r2, [fp, #-12]
    8e8c:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8e90:	e1520003 	cmp	r2, r3
    8e94:	aa000015 	bge	8ef0 <_Z7strncatPcPKci+0xb4>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:172
        if(src[i] == '\0')break;
    8e98:	e51b300c 	ldr	r3, [fp, #-12]
    8e9c:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8ea0:	e0823003 	add	r3, r2, r3
    8ea4:	e5d33000 	ldrb	r3, [r3]
    8ea8:	e3530000 	cmp	r3, #0
    8eac:	0a00000e 	beq	8eec <_Z7strncatPcPKci+0xb0>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:173 (discriminator 2)
        dest[m++] = src[i];
    8eb0:	e51b300c 	ldr	r3, [fp, #-12]
    8eb4:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8eb8:	e0822003 	add	r2, r2, r3
    8ebc:	e51b3008 	ldr	r3, [fp, #-8]
    8ec0:	e2831001 	add	r1, r3, #1
    8ec4:	e50b1008 	str	r1, [fp, #-8]
    8ec8:	e1a01003 	mov	r1, r3
    8ecc:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8ed0:	e0833001 	add	r3, r3, r1
    8ed4:	e5d22000 	ldrb	r2, [r2]
    8ed8:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:171 (discriminator 2)
    for(int i = 0;i < size; i++){
    8edc:	e51b300c 	ldr	r3, [fp, #-12]
    8ee0:	e2833001 	add	r3, r3, #1
    8ee4:	e50b300c 	str	r3, [fp, #-12]
    8ee8:	eaffffe6 	b	8e88 <_Z7strncatPcPKci+0x4c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:172
        if(src[i] == '\0')break;
    8eec:	e320f000 	nop	{0}
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:175
    }
    dest[m] = '\0';
    8ef0:	e51b3008 	ldr	r3, [fp, #-8]
    8ef4:	e51b2018 	ldr	r2, [fp, #-24]	; 0xffffffe8
    8ef8:	e0823003 	add	r3, r2, r3
    8efc:	e3a02000 	mov	r2, #0
    8f00:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:176
    return dest;
    8f04:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:178

}
    8f08:	e1a00003 	mov	r0, r3
    8f0c:	e24bd004 	sub	sp, fp, #4
    8f10:	e8bd8800 	pop	{fp, pc}

00008f14 <_Z5bzeroPvi>:
_Z5bzeroPvi():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:182


void bzero(void* memory, int length)
{
    8f14:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8f18:	e28db000 	add	fp, sp, #0
    8f1c:	e24dd014 	sub	sp, sp, #20
    8f20:	e50b0010 	str	r0, [fp, #-16]
    8f24:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:183
	char* mem = reinterpret_cast<char*>(memory);
    8f28:	e51b3010 	ldr	r3, [fp, #-16]
    8f2c:	e50b300c 	str	r3, [fp, #-12]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:185

	for (int i = 0; i < length; i++)
    8f30:	e3a03000 	mov	r3, #0
    8f34:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:185 (discriminator 3)
    8f38:	e51b2008 	ldr	r2, [fp, #-8]
    8f3c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8f40:	e1520003 	cmp	r2, r3
    8f44:	aa000008 	bge	8f6c <_Z5bzeroPvi+0x58>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:186 (discriminator 2)
		mem[i] = 0;
    8f48:	e51b3008 	ldr	r3, [fp, #-8]
    8f4c:	e51b200c 	ldr	r2, [fp, #-12]
    8f50:	e0823003 	add	r3, r2, r3
    8f54:	e3a02000 	mov	r2, #0
    8f58:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:185 (discriminator 2)
	for (int i = 0; i < length; i++)
    8f5c:	e51b3008 	ldr	r3, [fp, #-8]
    8f60:	e2833001 	add	r3, r3, #1
    8f64:	e50b3008 	str	r3, [fp, #-8]
    8f68:	eafffff2 	b	8f38 <_Z5bzeroPvi+0x24>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:187
}
    8f6c:	e320f000 	nop	{0}
    8f70:	e28bd000 	add	sp, fp, #0
    8f74:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8f78:	e12fff1e 	bx	lr

00008f7c <_Z6memcpyPKvPvi>:
_Z6memcpyPKvPvi():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:190

void memcpy(const void* src, void* dst, int num)
{
    8f7c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8f80:	e28db000 	add	fp, sp, #0
    8f84:	e24dd024 	sub	sp, sp, #36	; 0x24
    8f88:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    8f8c:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    8f90:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:191
	const char* memsrc = reinterpret_cast<const char*>(src);
    8f94:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8f98:	e50b300c 	str	r3, [fp, #-12]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:192
	char* memdst = reinterpret_cast<char*>(dst);
    8f9c:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8fa0:	e50b3010 	str	r3, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:194

	for (int i = 0; i < num; i++)
    8fa4:	e3a03000 	mov	r3, #0
    8fa8:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:194 (discriminator 3)
    8fac:	e51b2008 	ldr	r2, [fp, #-8]
    8fb0:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8fb4:	e1520003 	cmp	r2, r3
    8fb8:	aa00000b 	bge	8fec <_Z6memcpyPKvPvi+0x70>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:195 (discriminator 2)
		memdst[i] = memsrc[i];
    8fbc:	e51b3008 	ldr	r3, [fp, #-8]
    8fc0:	e51b200c 	ldr	r2, [fp, #-12]
    8fc4:	e0822003 	add	r2, r2, r3
    8fc8:	e51b3008 	ldr	r3, [fp, #-8]
    8fcc:	e51b1010 	ldr	r1, [fp, #-16]
    8fd0:	e0813003 	add	r3, r1, r3
    8fd4:	e5d22000 	ldrb	r2, [r2]
    8fd8:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:194 (discriminator 2)
	for (int i = 0; i < num; i++)
    8fdc:	e51b3008 	ldr	r3, [fp, #-8]
    8fe0:	e2833001 	add	r3, r3, #1
    8fe4:	e50b3008 	str	r3, [fp, #-8]
    8fe8:	eaffffef 	b	8fac <_Z6memcpyPKvPvi+0x30>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:196
}
    8fec:	e320f000 	nop	{0}
    8ff0:	e28bd000 	add	sp, fp, #0
    8ff4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8ff8:	e12fff1e 	bx	lr

00008ffc <_Z4n_tuii>:
_Z4n_tuii():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:201



int n_tu(int number, int count)
{
    8ffc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9000:	e28db000 	add	fp, sp, #0
    9004:	e24dd014 	sub	sp, sp, #20
    9008:	e50b0010 	str	r0, [fp, #-16]
    900c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:202
    int result = 1;
    9010:	e3a03001 	mov	r3, #1
    9014:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:203
    while(count-- > 0)
    9018:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    901c:	e2432001 	sub	r2, r3, #1
    9020:	e50b2014 	str	r2, [fp, #-20]	; 0xffffffec
    9024:	e3530000 	cmp	r3, #0
    9028:	c3a03001 	movgt	r3, #1
    902c:	d3a03000 	movle	r3, #0
    9030:	e6ef3073 	uxtb	r3, r3
    9034:	e3530000 	cmp	r3, #0
    9038:	0a000004 	beq	9050 <_Z4n_tuii+0x54>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:204
        result *= number;
    903c:	e51b3008 	ldr	r3, [fp, #-8]
    9040:	e51b2010 	ldr	r2, [fp, #-16]
    9044:	e0030392 	mul	r3, r2, r3
    9048:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:203
    while(count-- > 0)
    904c:	eafffff1 	b	9018 <_Z4n_tuii+0x1c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:206

    return result;
    9050:	e51b3008 	ldr	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:207
}
    9054:	e1a00003 	mov	r0, r3
    9058:	e28bd000 	add	sp, fp, #0
    905c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9060:	e12fff1e 	bx	lr

00009064 <_Z4ftoafPc>:
_Z4ftoafPc():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:211

/*** Convert float to string ***/
void ftoa(float f, char r[])
{
    9064:	e92d4bf0 	push	{r4, r5, r6, r7, r8, r9, fp, lr}
    9068:	e28db01c 	add	fp, sp, #28
    906c:	e24dd068 	sub	sp, sp, #104	; 0x68
    9070:	ed0b0a16 	vstr	s0, [fp, #-88]	; 0xffffffa8
    9074:	e50b005c 	str	r0, [fp, #-92]	; 0xffffffa4
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:215
    long long int length, length2, i, number, position, sign;
    float number2;

    sign = -1;   // -1 == positive number
    9078:	e3e02000 	mvn	r2, #0
    907c:	e3e03000 	mvn	r3, #0
    9080:	e14b24fc 	strd	r2, [fp, #-76]	; 0xffffffb4
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:216
    if (f < 0)
    9084:	ed5b7a16 	vldr	s15, [fp, #-88]	; 0xffffffa8
    9088:	eef57ac0 	vcmpe.f32	s15, #0.0
    908c:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    9090:	5a000005 	bpl	90ac <_Z4ftoafPc+0x48>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:218
    {
        sign = '-';
    9094:	e3a0202d 	mov	r2, #45	; 0x2d
    9098:	e3a03000 	mov	r3, #0
    909c:	e14b24fc 	strd	r2, [fp, #-76]	; 0xffffffb4
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:219
        f *= -1;
    90a0:	ed5b7a16 	vldr	s15, [fp, #-88]	; 0xffffffa8
    90a4:	eef17a67 	vneg.f32	s15, s15
    90a8:	ed4b7a16 	vstr	s15, [fp, #-88]	; 0xffffffa8
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:222
    }

    number2 = f;
    90ac:	e51b3058 	ldr	r3, [fp, #-88]	; 0xffffffa8
    90b0:	e50b3050 	str	r3, [fp, #-80]	; 0xffffffb0
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:223
    number = f;
    90b4:	e51b0058 	ldr	r0, [fp, #-88]	; 0xffffffa8
    90b8:	eb00032d 	bl	9d74 <__aeabi_f2lz>
    90bc:	e1a02000 	mov	r2, r0
    90c0:	e1a03001 	mov	r3, r1
    90c4:	e14b23fc 	strd	r2, [fp, #-60]	; 0xffffffc4
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:224
    length = 0;  // Size of decimal part
    90c8:	e3a02000 	mov	r2, #0
    90cc:	e3a03000 	mov	r3, #0
    90d0:	e14b22f4 	strd	r2, [fp, #-36]	; 0xffffffdc
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:225
    length2 = 0; // Size of tenth
    90d4:	e3a02000 	mov	r2, #0
    90d8:	e3a03000 	mov	r3, #0
    90dc:	e14b22fc 	strd	r2, [fp, #-44]	; 0xffffffd4
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:228

    /* Calculate length2 tenth part */
    while( (number2 - (float)number) != 0.0 && !((number2 - (float)number) < 0.0) )
    90e0:	e14b03dc 	ldrd	r0, [fp, #-60]	; 0xffffffc4
    90e4:	eb0002ce 	bl	9c24 <__aeabi_l2f>
    90e8:	ee070a10 	vmov	s14, r0
    90ec:	ed5b7a14 	vldr	s15, [fp, #-80]	; 0xffffffb0
    90f0:	ee777ac7 	vsub.f32	s15, s15, s14
    90f4:	eef57a40 	vcmp.f32	s15, #0.0
    90f8:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    90fc:	0a00001b 	beq	9170 <_Z4ftoafPc+0x10c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:228 (discriminator 1)
    9100:	e14b03dc 	ldrd	r0, [fp, #-60]	; 0xffffffc4
    9104:	eb0002c6 	bl	9c24 <__aeabi_l2f>
    9108:	ee070a10 	vmov	s14, r0
    910c:	ed5b7a14 	vldr	s15, [fp, #-80]	; 0xffffffb0
    9110:	ee777ac7 	vsub.f32	s15, s15, s14
    9114:	eef57ac0 	vcmpe.f32	s15, #0.0
    9118:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    911c:	4a000013 	bmi	9170 <_Z4ftoafPc+0x10c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:230
    {
        number2 = f * (n_tu(10.0, length2 + 1));
    9120:	e51b302c 	ldr	r3, [fp, #-44]	; 0xffffffd4
    9124:	e2833001 	add	r3, r3, #1
    9128:	e1a01003 	mov	r1, r3
    912c:	e3a0000a 	mov	r0, #10
    9130:	ebffffb1 	bl	8ffc <_Z4n_tuii>
    9134:	ee070a90 	vmov	s15, r0
    9138:	eef87ae7 	vcvt.f32.s32	s15, s15
    913c:	ed1b7a16 	vldr	s14, [fp, #-88]	; 0xffffffa8
    9140:	ee677a27 	vmul.f32	s15, s14, s15
    9144:	ed4b7a14 	vstr	s15, [fp, #-80]	; 0xffffffb0
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:231
        number = number2;
    9148:	e51b0050 	ldr	r0, [fp, #-80]	; 0xffffffb0
    914c:	eb000308 	bl	9d74 <__aeabi_f2lz>
    9150:	e1a02000 	mov	r2, r0
    9154:	e1a03001 	mov	r3, r1
    9158:	e14b23fc 	strd	r2, [fp, #-60]	; 0xffffffc4
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:233

        length2++;
    915c:	e14b22dc 	ldrd	r2, [fp, #-44]	; 0xffffffd4
    9160:	e2926001 	adds	r6, r2, #1
    9164:	e2a37000 	adc	r7, r3, #0
    9168:	e14b62fc 	strd	r6, [fp, #-44]	; 0xffffffd4
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:228
    while( (number2 - (float)number) != 0.0 && !((number2 - (float)number) < 0.0) )
    916c:	eaffffdb 	b	90e0 <_Z4ftoafPc+0x7c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:237
    }

    /* Calculate length decimal part */
    for (length = (f > 1) ? 0 : 1; f > 1; length++)
    9170:	ed5b7a16 	vldr	s15, [fp, #-88]	; 0xffffffa8
    9174:	ed9f7a82 	vldr	s14, [pc, #520]	; 9384 <_Z4ftoafPc+0x320>
    9178:	eef47ac7 	vcmpe.f32	s15, s14
    917c:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    9180:	c3a03001 	movgt	r3, #1
    9184:	d3a03000 	movle	r3, #0
    9188:	e6ef3073 	uxtb	r3, r3
    918c:	e2233001 	eor	r3, r3, #1
    9190:	e6ef3073 	uxtb	r3, r3
    9194:	e6ef3073 	uxtb	r3, r3
    9198:	e3a02000 	mov	r2, #0
    919c:	e50b3064 	str	r3, [fp, #-100]	; 0xffffff9c
    91a0:	e50b2060 	str	r2, [fp, #-96]	; 0xffffffa0
    91a4:	e14b26d4 	ldrd	r2, [fp, #-100]	; 0xffffff9c
    91a8:	e14b22f4 	strd	r2, [fp, #-36]	; 0xffffffdc
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:237 (discriminator 3)
    91ac:	ed5b7a16 	vldr	s15, [fp, #-88]	; 0xffffffa8
    91b0:	ed9f7a73 	vldr	s14, [pc, #460]	; 9384 <_Z4ftoafPc+0x320>
    91b4:	eef47ac7 	vcmpe.f32	s15, s14
    91b8:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    91bc:	da00000b 	ble	91f0 <_Z4ftoafPc+0x18c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:238 (discriminator 2)
        f /= 10;
    91c0:	ed1b7a16 	vldr	s14, [fp, #-88]	; 0xffffffa8
    91c4:	eddf6a6f 	vldr	s13, [pc, #444]	; 9388 <_Z4ftoafPc+0x324>
    91c8:	eec77a26 	vdiv.f32	s15, s14, s13
    91cc:	ed4b7a16 	vstr	s15, [fp, #-88]	; 0xffffffa8
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:237 (discriminator 2)
    for (length = (f > 1) ? 0 : 1; f > 1; length++)
    91d0:	e14b22d4 	ldrd	r2, [fp, #-36]	; 0xffffffdc
    91d4:	e2921001 	adds	r1, r2, #1
    91d8:	e50b106c 	str	r1, [fp, #-108]	; 0xffffff94
    91dc:	e2a33000 	adc	r3, r3, #0
    91e0:	e50b3068 	str	r3, [fp, #-104]	; 0xffffff98
    91e4:	e14b26dc 	ldrd	r2, [fp, #-108]	; 0xffffff94
    91e8:	e14b22f4 	strd	r2, [fp, #-36]	; 0xffffffdc
    91ec:	eaffffee 	b	91ac <_Z4ftoafPc+0x148>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:240

    position = length;
    91f0:	e14b22d4 	ldrd	r2, [fp, #-36]	; 0xffffffdc
    91f4:	e14b24f4 	strd	r2, [fp, #-68]	; 0xffffffbc
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:241
    length = length + 1 + length2;
    91f8:	e14b22d4 	ldrd	r2, [fp, #-36]	; 0xffffffdc
    91fc:	e2924001 	adds	r4, r2, #1
    9200:	e2a35000 	adc	r5, r3, #0
    9204:	e14b22dc 	ldrd	r2, [fp, #-44]	; 0xffffffd4
    9208:	e0921004 	adds	r1, r2, r4
    920c:	e50b1074 	str	r1, [fp, #-116]	; 0xffffff8c
    9210:	e0a33005 	adc	r3, r3, r5
    9214:	e50b3070 	str	r3, [fp, #-112]	; 0xffffff90
    9218:	e14b27d4 	ldrd	r2, [fp, #-116]	; 0xffffff8c
    921c:	e14b22f4 	strd	r2, [fp, #-36]	; 0xffffffdc
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:242
    number = number2;
    9220:	e51b0050 	ldr	r0, [fp, #-80]	; 0xffffffb0
    9224:	eb0002d2 	bl	9d74 <__aeabi_f2lz>
    9228:	e1a02000 	mov	r2, r0
    922c:	e1a03001 	mov	r3, r1
    9230:	e14b23fc 	strd	r2, [fp, #-60]	; 0xffffffc4
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:243
    if (sign == '-')
    9234:	e14b24dc 	ldrd	r2, [fp, #-76]	; 0xffffffb4
    9238:	e242102d 	sub	r1, r2, #45	; 0x2d
    923c:	e1913003 	orrs	r3, r1, r3
    9240:	1a00000d 	bne	927c <_Z4ftoafPc+0x218>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:245
    {
        length++;
    9244:	e14b22d4 	ldrd	r2, [fp, #-36]	; 0xffffffdc
    9248:	e2921001 	adds	r1, r2, #1
    924c:	e50b107c 	str	r1, [fp, #-124]	; 0xffffff84
    9250:	e2a33000 	adc	r3, r3, #0
    9254:	e50b3078 	str	r3, [fp, #-120]	; 0xffffff88
    9258:	e14b27dc 	ldrd	r2, [fp, #-124]	; 0xffffff84
    925c:	e14b22f4 	strd	r2, [fp, #-36]	; 0xffffffdc
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:246
        position++;
    9260:	e14b24d4 	ldrd	r2, [fp, #-68]	; 0xffffffbc
    9264:	e2921001 	adds	r1, r2, #1
    9268:	e50b1084 	str	r1, [fp, #-132]	; 0xffffff7c
    926c:	e2a33000 	adc	r3, r3, #0
    9270:	e50b3080 	str	r3, [fp, #-128]	; 0xffffff80
    9274:	e14b28d4 	ldrd	r2, [fp, #-132]	; 0xffffff7c
    9278:	e14b24f4 	strd	r2, [fp, #-68]	; 0xffffffbc
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:249
    }

    for (i = length; i >= 0 ; i--)
    927c:	e14b22d4 	ldrd	r2, [fp, #-36]	; 0xffffffdc
    9280:	e14b23f4 	strd	r2, [fp, #-52]	; 0xffffffcc
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:249 (discriminator 1)
    9284:	e14b23d4 	ldrd	r2, [fp, #-52]	; 0xffffffcc
    9288:	e3530000 	cmp	r3, #0
    928c:	ba000039 	blt	9378 <_Z4ftoafPc+0x314>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:251
    {
        if (i == (length))
    9290:	e14b03d4 	ldrd	r0, [fp, #-52]	; 0xffffffcc
    9294:	e14b22d4 	ldrd	r2, [fp, #-36]	; 0xffffffdc
    9298:	e1510003 	cmp	r1, r3
    929c:	01500002 	cmpeq	r0, r2
    92a0:	1a000005 	bne	92bc <_Z4ftoafPc+0x258>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:252
            r[i] = '\0';
    92a4:	e51b3034 	ldr	r3, [fp, #-52]	; 0xffffffcc
    92a8:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    92ac:	e0823003 	add	r3, r2, r3
    92b0:	e3a02000 	mov	r2, #0
    92b4:	e5c32000 	strb	r2, [r3]
    92b8:	ea000029 	b	9364 <_Z4ftoafPc+0x300>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:253
        else if(i == (position))
    92bc:	e14b03d4 	ldrd	r0, [fp, #-52]	; 0xffffffcc
    92c0:	e14b24d4 	ldrd	r2, [fp, #-68]	; 0xffffffbc
    92c4:	e1510003 	cmp	r1, r3
    92c8:	01500002 	cmpeq	r0, r2
    92cc:	1a000005 	bne	92e8 <_Z4ftoafPc+0x284>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:254
            r[i] = '.';
    92d0:	e51b3034 	ldr	r3, [fp, #-52]	; 0xffffffcc
    92d4:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    92d8:	e0823003 	add	r3, r2, r3
    92dc:	e3a0202e 	mov	r2, #46	; 0x2e
    92e0:	e5c32000 	strb	r2, [r3]
    92e4:	ea00001e 	b	9364 <_Z4ftoafPc+0x300>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:255
        else if(sign == '-' && i == 0)
    92e8:	e14b24dc 	ldrd	r2, [fp, #-76]	; 0xffffffb4
    92ec:	e242102d 	sub	r1, r2, #45	; 0x2d
    92f0:	e1913003 	orrs	r3, r1, r3
    92f4:	1a000008 	bne	931c <_Z4ftoafPc+0x2b8>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:255 (discriminator 1)
    92f8:	e14b23d4 	ldrd	r2, [fp, #-52]	; 0xffffffcc
    92fc:	e1923003 	orrs	r3, r2, r3
    9300:	1a000005 	bne	931c <_Z4ftoafPc+0x2b8>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:256
            r[i] = '-';
    9304:	e51b3034 	ldr	r3, [fp, #-52]	; 0xffffffcc
    9308:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    930c:	e0823003 	add	r3, r2, r3
    9310:	e3a0202d 	mov	r2, #45	; 0x2d
    9314:	e5c32000 	strb	r2, [r3]
    9318:	ea000011 	b	9364 <_Z4ftoafPc+0x300>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:259
        else
        {
            r[i] = (number % 10) + '0';
    931c:	e14b03dc 	ldrd	r0, [fp, #-60]	; 0xffffffc4
    9320:	e3a0200a 	mov	r2, #10
    9324:	e3a03000 	mov	r3, #0
    9328:	eb00025c 	bl	9ca0 <__aeabi_ldivmod>
    932c:	e6ef2072 	uxtb	r2, r2
    9330:	e51b3034 	ldr	r3, [fp, #-52]	; 0xffffffcc
    9334:	e51b105c 	ldr	r1, [fp, #-92]	; 0xffffffa4
    9338:	e0813003 	add	r3, r1, r3
    933c:	e2822030 	add	r2, r2, #48	; 0x30
    9340:	e6ef2072 	uxtb	r2, r2
    9344:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:260
            number /=10;
    9348:	e14b03dc 	ldrd	r0, [fp, #-60]	; 0xffffffc4
    934c:	e3a0200a 	mov	r2, #10
    9350:	e3a03000 	mov	r3, #0
    9354:	eb000251 	bl	9ca0 <__aeabi_ldivmod>
    9358:	e1a02000 	mov	r2, r0
    935c:	e1a03001 	mov	r3, r1
    9360:	e14b23fc 	strd	r2, [fp, #-60]	; 0xffffffc4
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:249 (discriminator 2)
    for (i = length; i >= 0 ; i--)
    9364:	e14b23d4 	ldrd	r2, [fp, #-52]	; 0xffffffcc
    9368:	e2528001 	subs	r8, r2, #1
    936c:	e2c39000 	sbc	r9, r3, #0
    9370:	e14b83f4 	strd	r8, [fp, #-52]	; 0xffffffcc
    9374:	eaffffc2 	b	9284 <_Z4ftoafPc+0x220>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:263
        }
    }
}
    9378:	e320f000 	nop	{0}
    937c:	e24bd01c 	sub	sp, fp, #28
    9380:	e8bd8bf0 	pop	{r4, r5, r6, r7, r8, r9, fp, pc}
    9384:	3f800000 	svccc	0x00800000
    9388:	41200000 			; <UNDEFINED> instruction: 0x41200000

0000938c <_ZN13COLED_DisplayC1EPKc>:
_ZN13COLED_DisplayC2EPKc():
/home/trefil/sem/sources/stdutils/src/oled.cpp:10
#include <drivers/bridges/display_protocol.h>

// tento soubor includujeme jen odtud
#include "oled_font.h"

COLED_Display::COLED_Display(const char* path)
    938c:	e92d4800 	push	{fp, lr}
    9390:	e28db004 	add	fp, sp, #4
    9394:	e24dd008 	sub	sp, sp, #8
    9398:	e50b0008 	str	r0, [fp, #-8]
    939c:	e50b100c 	str	r1, [fp, #-12]
/home/trefil/sem/sources/stdutils/src/oled.cpp:11
    : mHandle{ open(path, NFile_Open_Mode::Write_Only) }, mOpened(false)
    93a0:	e3a01001 	mov	r1, #1
    93a4:	e51b000c 	ldr	r0, [fp, #-12]
    93a8:	ebfffbe6 	bl	8348 <_Z4openPKc15NFile_Open_Mode>
    93ac:	e1a02000 	mov	r2, r0
    93b0:	e51b3008 	ldr	r3, [fp, #-8]
    93b4:	e5832000 	str	r2, [r3]
    93b8:	e51b3008 	ldr	r3, [fp, #-8]
    93bc:	e3a02000 	mov	r2, #0
    93c0:	e5c32004 	strb	r2, [r3, #4]
/home/trefil/sem/sources/stdutils/src/oled.cpp:14
{
    // nastavime priznak dle toho, co vrati open
    mOpened = (mHandle != static_cast<uint32_t>(-1));
    93c4:	e51b3008 	ldr	r3, [fp, #-8]
    93c8:	e5933000 	ldr	r3, [r3]
    93cc:	e3730001 	cmn	r3, #1
    93d0:	13a03001 	movne	r3, #1
    93d4:	03a03000 	moveq	r3, #0
    93d8:	e6ef2073 	uxtb	r2, r3
    93dc:	e51b3008 	ldr	r3, [fp, #-8]
    93e0:	e5c32004 	strb	r2, [r3, #4]
/home/trefil/sem/sources/stdutils/src/oled.cpp:15
}
    93e4:	e51b3008 	ldr	r3, [fp, #-8]
    93e8:	e1a00003 	mov	r0, r3
    93ec:	e24bd004 	sub	sp, fp, #4
    93f0:	e8bd8800 	pop	{fp, pc}

000093f4 <_ZN13COLED_DisplayD1Ev>:
_ZN13COLED_DisplayD2Ev():
/home/trefil/sem/sources/stdutils/src/oled.cpp:17

COLED_Display::~COLED_Display()
    93f4:	e92d4800 	push	{fp, lr}
    93f8:	e28db004 	add	fp, sp, #4
    93fc:	e24dd008 	sub	sp, sp, #8
    9400:	e50b0008 	str	r0, [fp, #-8]
/home/trefil/sem/sources/stdutils/src/oled.cpp:20
{
    // pokud byl displej otevreny, zavreme
    if (mOpened)
    9404:	e51b3008 	ldr	r3, [fp, #-8]
    9408:	e5d33004 	ldrb	r3, [r3, #4]
    940c:	e3530000 	cmp	r3, #0
    9410:	0a000006 	beq	9430 <_ZN13COLED_DisplayD1Ev+0x3c>
/home/trefil/sem/sources/stdutils/src/oled.cpp:22
    {
        mOpened = false;
    9414:	e51b3008 	ldr	r3, [fp, #-8]
    9418:	e3a02000 	mov	r2, #0
    941c:	e5c32004 	strb	r2, [r3, #4]
/home/trefil/sem/sources/stdutils/src/oled.cpp:23
        close(mHandle);
    9420:	e51b3008 	ldr	r3, [fp, #-8]
    9424:	e5933000 	ldr	r3, [r3]
    9428:	e1a00003 	mov	r0, r3
    942c:	ebfffbfe 	bl	842c <_Z5closej>
/home/trefil/sem/sources/stdutils/src/oled.cpp:25
    }
}
    9430:	e51b3008 	ldr	r3, [fp, #-8]
    9434:	e1a00003 	mov	r0, r3
    9438:	e24bd004 	sub	sp, fp, #4
    943c:	e8bd8800 	pop	{fp, pc}

00009440 <_ZNK13COLED_Display9Is_OpenedEv>:
_ZNK13COLED_Display9Is_OpenedEv():
/home/trefil/sem/sources/stdutils/src/oled.cpp:28

bool COLED_Display::Is_Opened() const
{
    9440:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9444:	e28db000 	add	fp, sp, #0
    9448:	e24dd00c 	sub	sp, sp, #12
    944c:	e50b0008 	str	r0, [fp, #-8]
/home/trefil/sem/sources/stdutils/src/oled.cpp:29
    return mOpened;
    9450:	e51b3008 	ldr	r3, [fp, #-8]
    9454:	e5d33004 	ldrb	r3, [r3, #4]
/home/trefil/sem/sources/stdutils/src/oled.cpp:30
}
    9458:	e1a00003 	mov	r0, r3
    945c:	e28bd000 	add	sp, fp, #0
    9460:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9464:	e12fff1e 	bx	lr

00009468 <_ZN13COLED_Display5ClearEb>:
_ZN13COLED_Display5ClearEb():
/home/trefil/sem/sources/stdutils/src/oled.cpp:33

void COLED_Display::Clear(bool clearSet)
{
    9468:	e92d4800 	push	{fp, lr}
    946c:	e28db004 	add	fp, sp, #4
    9470:	e24dd010 	sub	sp, sp, #16
    9474:	e50b0010 	str	r0, [fp, #-16]
    9478:	e1a03001 	mov	r3, r1
    947c:	e54b3011 	strb	r3, [fp, #-17]	; 0xffffffef
/home/trefil/sem/sources/stdutils/src/oled.cpp:34
    if (!mOpened)
    9480:	e51b3010 	ldr	r3, [fp, #-16]
    9484:	e5d33004 	ldrb	r3, [r3, #4]
    9488:	e2233001 	eor	r3, r3, #1
    948c:	e6ef3073 	uxtb	r3, r3
    9490:	e3530000 	cmp	r3, #0
    9494:	1a00000f 	bne	94d8 <_ZN13COLED_Display5ClearEb+0x70>
/home/trefil/sem/sources/stdutils/src/oled.cpp:38
        return;

    TDisplay_Clear_Packet pkt;
	pkt.header.cmd = NDisplay_Command::Clear;
    9498:	e3a03002 	mov	r3, #2
    949c:	e54b3008 	strb	r3, [fp, #-8]
/home/trefil/sem/sources/stdutils/src/oled.cpp:39
	pkt.clearSet = clearSet ? 1 : 0;
    94a0:	e55b3011 	ldrb	r3, [fp, #-17]	; 0xffffffef
    94a4:	e3530000 	cmp	r3, #0
    94a8:	0a000001 	beq	94b4 <_ZN13COLED_Display5ClearEb+0x4c>
/home/trefil/sem/sources/stdutils/src/oled.cpp:39 (discriminator 1)
    94ac:	e3a03001 	mov	r3, #1
    94b0:	ea000000 	b	94b8 <_ZN13COLED_Display5ClearEb+0x50>
/home/trefil/sem/sources/stdutils/src/oled.cpp:39 (discriminator 2)
    94b4:	e3a03000 	mov	r3, #0
/home/trefil/sem/sources/stdutils/src/oled.cpp:39 (discriminator 4)
    94b8:	e54b3007 	strb	r3, [fp, #-7]
/home/trefil/sem/sources/stdutils/src/oled.cpp:40 (discriminator 4)
	write(mHandle, reinterpret_cast<char*>(&pkt), sizeof(pkt));
    94bc:	e51b3010 	ldr	r3, [fp, #-16]
    94c0:	e5933000 	ldr	r3, [r3]
    94c4:	e24b1008 	sub	r1, fp, #8
    94c8:	e3a02002 	mov	r2, #2
    94cc:	e1a00003 	mov	r0, r3
    94d0:	ebfffbc1 	bl	83dc <_Z5writejPKcj>
    94d4:	ea000000 	b	94dc <_ZN13COLED_Display5ClearEb+0x74>
/home/trefil/sem/sources/stdutils/src/oled.cpp:35
        return;
    94d8:	e320f000 	nop	{0}
/home/trefil/sem/sources/stdutils/src/oled.cpp:41
}
    94dc:	e24bd004 	sub	sp, fp, #4
    94e0:	e8bd8800 	pop	{fp, pc}

000094e4 <_ZN13COLED_Display9Set_PixelEttb>:
_ZN13COLED_Display9Set_PixelEttb():
/home/trefil/sem/sources/stdutils/src/oled.cpp:44

void COLED_Display::Set_Pixel(uint16_t x, uint16_t y, bool set)
{
    94e4:	e92d4800 	push	{fp, lr}
    94e8:	e28db004 	add	fp, sp, #4
    94ec:	e24dd018 	sub	sp, sp, #24
    94f0:	e50b0010 	str	r0, [fp, #-16]
    94f4:	e1a00001 	mov	r0, r1
    94f8:	e1a01002 	mov	r1, r2
    94fc:	e1a02003 	mov	r2, r3
    9500:	e1a03000 	mov	r3, r0
    9504:	e14b31b2 	strh	r3, [fp, #-18]	; 0xffffffee
    9508:	e1a03001 	mov	r3, r1
    950c:	e14b31b4 	strh	r3, [fp, #-20]	; 0xffffffec
    9510:	e1a03002 	mov	r3, r2
    9514:	e54b3015 	strb	r3, [fp, #-21]	; 0xffffffeb
/home/trefil/sem/sources/stdutils/src/oled.cpp:45
    if (!mOpened)
    9518:	e51b3010 	ldr	r3, [fp, #-16]
    951c:	e5d33004 	ldrb	r3, [r3, #4]
    9520:	e2233001 	eor	r3, r3, #1
    9524:	e6ef3073 	uxtb	r3, r3
    9528:	e3530000 	cmp	r3, #0
    952c:	1a000024 	bne	95c4 <_ZN13COLED_Display9Set_PixelEttb+0xe0>
/home/trefil/sem/sources/stdutils/src/oled.cpp:50
        return;

    // nehospodarny zpusob, jak nastavit pixely, ale pro ted staci
    TDisplay_Draw_Pixel_Array_Packet pkt;
    pkt.header.cmd = NDisplay_Command::Draw_Pixel_Array;
    9530:	e3a03003 	mov	r3, #3
    9534:	e54b300c 	strb	r3, [fp, #-12]
/home/trefil/sem/sources/stdutils/src/oled.cpp:51
    pkt.count = 1;
    9538:	e3a03000 	mov	r3, #0
    953c:	e3833001 	orr	r3, r3, #1
    9540:	e54b300b 	strb	r3, [fp, #-11]
    9544:	e3a03000 	mov	r3, #0
    9548:	e54b300a 	strb	r3, [fp, #-10]
/home/trefil/sem/sources/stdutils/src/oled.cpp:52
    pkt.first.x = x;
    954c:	e55b3012 	ldrb	r3, [fp, #-18]	; 0xffffffee
    9550:	e3a02000 	mov	r2, #0
    9554:	e1823003 	orr	r3, r2, r3
    9558:	e54b3009 	strb	r3, [fp, #-9]
    955c:	e55b3011 	ldrb	r3, [fp, #-17]	; 0xffffffef
    9560:	e3a02000 	mov	r2, #0
    9564:	e1823003 	orr	r3, r2, r3
    9568:	e54b3008 	strb	r3, [fp, #-8]
/home/trefil/sem/sources/stdutils/src/oled.cpp:53
    pkt.first.y = y;
    956c:	e55b3014 	ldrb	r3, [fp, #-20]	; 0xffffffec
    9570:	e3a02000 	mov	r2, #0
    9574:	e1823003 	orr	r3, r2, r3
    9578:	e54b3007 	strb	r3, [fp, #-7]
    957c:	e55b3013 	ldrb	r3, [fp, #-19]	; 0xffffffed
    9580:	e3a02000 	mov	r2, #0
    9584:	e1823003 	orr	r3, r2, r3
    9588:	e54b3006 	strb	r3, [fp, #-6]
/home/trefil/sem/sources/stdutils/src/oled.cpp:54
    pkt.first.set = set ? 1 : 0;
    958c:	e55b3015 	ldrb	r3, [fp, #-21]	; 0xffffffeb
    9590:	e3530000 	cmp	r3, #0
    9594:	0a000001 	beq	95a0 <_ZN13COLED_Display9Set_PixelEttb+0xbc>
/home/trefil/sem/sources/stdutils/src/oled.cpp:54 (discriminator 1)
    9598:	e3a03001 	mov	r3, #1
    959c:	ea000000 	b	95a4 <_ZN13COLED_Display9Set_PixelEttb+0xc0>
/home/trefil/sem/sources/stdutils/src/oled.cpp:54 (discriminator 2)
    95a0:	e3a03000 	mov	r3, #0
/home/trefil/sem/sources/stdutils/src/oled.cpp:54 (discriminator 4)
    95a4:	e54b3005 	strb	r3, [fp, #-5]
/home/trefil/sem/sources/stdutils/src/oled.cpp:55 (discriminator 4)
    write(mHandle, reinterpret_cast<char*>(&pkt), sizeof(pkt));
    95a8:	e51b3010 	ldr	r3, [fp, #-16]
    95ac:	e5933000 	ldr	r3, [r3]
    95b0:	e24b100c 	sub	r1, fp, #12
    95b4:	e3a02008 	mov	r2, #8
    95b8:	e1a00003 	mov	r0, r3
    95bc:	ebfffb86 	bl	83dc <_Z5writejPKcj>
    95c0:	ea000000 	b	95c8 <_ZN13COLED_Display9Set_PixelEttb+0xe4>
/home/trefil/sem/sources/stdutils/src/oled.cpp:46
        return;
    95c4:	e320f000 	nop	{0}
/home/trefil/sem/sources/stdutils/src/oled.cpp:56
}
    95c8:	e24bd004 	sub	sp, fp, #4
    95cc:	e8bd8800 	pop	{fp, pc}

000095d0 <_ZN13COLED_Display8Put_CharEttc>:
_ZN13COLED_Display8Put_CharEttc():
/home/trefil/sem/sources/stdutils/src/oled.cpp:59

void COLED_Display::Put_Char(uint16_t x, uint16_t y, char c)
{
    95d0:	e92d4800 	push	{fp, lr}
    95d4:	e28db004 	add	fp, sp, #4
    95d8:	e24dd028 	sub	sp, sp, #40	; 0x28
    95dc:	e50b0020 	str	r0, [fp, #-32]	; 0xffffffe0
    95e0:	e1a00001 	mov	r0, r1
    95e4:	e1a01002 	mov	r1, r2
    95e8:	e1a02003 	mov	r2, r3
    95ec:	e1a03000 	mov	r3, r0
    95f0:	e14b32b2 	strh	r3, [fp, #-34]	; 0xffffffde
    95f4:	e1a03001 	mov	r3, r1
    95f8:	e14b32b4 	strh	r3, [fp, #-36]	; 0xffffffdc
    95fc:	e1a03002 	mov	r3, r2
    9600:	e54b3025 	strb	r3, [fp, #-37]	; 0xffffffdb
/home/trefil/sem/sources/stdutils/src/oled.cpp:60
    if (!mOpened)
    9604:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    9608:	e5d33004 	ldrb	r3, [r3, #4]
    960c:	e2233001 	eor	r3, r3, #1
    9610:	e6ef3073 	uxtb	r3, r3
    9614:	e3530000 	cmp	r3, #0
    9618:	1a000040 	bne	9720 <_ZN13COLED_Display8Put_CharEttc+0x150>
/home/trefil/sem/sources/stdutils/src/oled.cpp:64
        return;

    // umime jen nektere znaky
    if (c < OLED_Font::Char_Begin || c >= OLED_Font::Char_End)
    961c:	e55b3025 	ldrb	r3, [fp, #-37]	; 0xffffffdb
    9620:	e353001f 	cmp	r3, #31
    9624:	9a00003f 	bls	9728 <_ZN13COLED_Display8Put_CharEttc+0x158>
/home/trefil/sem/sources/stdutils/src/oled.cpp:64 (discriminator 1)
    9628:	e15b32d5 	ldrsb	r3, [fp, #-37]	; 0xffffffdb
    962c:	e3530000 	cmp	r3, #0
    9630:	ba00003c 	blt	9728 <_ZN13COLED_Display8Put_CharEttc+0x158>
/home/trefil/sem/sources/stdutils/src/oled.cpp:69
        return;

    char buf[sizeof(TDisplay_Pixels_To_Rect) + OLED_Font::Char_Width];

    TDisplay_Pixels_To_Rect* ptr = reinterpret_cast<TDisplay_Pixels_To_Rect*>(buf);
    9634:	e24b301c 	sub	r3, fp, #28
    9638:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdutils/src/oled.cpp:70
    ptr->header.cmd = NDisplay_Command::Draw_Pixel_Array_To_Rect;
    963c:	e51b3008 	ldr	r3, [fp, #-8]
    9640:	e3a02004 	mov	r2, #4
    9644:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdutils/src/oled.cpp:71
    ptr->w = OLED_Font::Char_Width;
    9648:	e51b3008 	ldr	r3, [fp, #-8]
    964c:	e3a02000 	mov	r2, #0
    9650:	e3822006 	orr	r2, r2, #6
    9654:	e5c32005 	strb	r2, [r3, #5]
    9658:	e3a02000 	mov	r2, #0
    965c:	e5c32006 	strb	r2, [r3, #6]
/home/trefil/sem/sources/stdutils/src/oled.cpp:72
    ptr->h = OLED_Font::Char_Height;
    9660:	e51b3008 	ldr	r3, [fp, #-8]
    9664:	e3a02000 	mov	r2, #0
    9668:	e3822008 	orr	r2, r2, #8
    966c:	e5c32007 	strb	r2, [r3, #7]
    9670:	e3a02000 	mov	r2, #0
    9674:	e5c32008 	strb	r2, [r3, #8]
/home/trefil/sem/sources/stdutils/src/oled.cpp:73
    ptr->x1 = x;
    9678:	e51b3008 	ldr	r3, [fp, #-8]
    967c:	e55b2022 	ldrb	r2, [fp, #-34]	; 0xffffffde
    9680:	e3a01000 	mov	r1, #0
    9684:	e1812002 	orr	r2, r1, r2
    9688:	e5c32001 	strb	r2, [r3, #1]
    968c:	e55b2021 	ldrb	r2, [fp, #-33]	; 0xffffffdf
    9690:	e3a01000 	mov	r1, #0
    9694:	e1812002 	orr	r2, r1, r2
    9698:	e5c32002 	strb	r2, [r3, #2]
/home/trefil/sem/sources/stdutils/src/oled.cpp:74
    ptr->y1 = y;
    969c:	e51b3008 	ldr	r3, [fp, #-8]
    96a0:	e55b2024 	ldrb	r2, [fp, #-36]	; 0xffffffdc
    96a4:	e3a01000 	mov	r1, #0
    96a8:	e1812002 	orr	r2, r1, r2
    96ac:	e5c32003 	strb	r2, [r3, #3]
    96b0:	e55b2023 	ldrb	r2, [fp, #-35]	; 0xffffffdd
    96b4:	e3a01000 	mov	r1, #0
    96b8:	e1812002 	orr	r2, r1, r2
    96bc:	e5c32004 	strb	r2, [r3, #4]
/home/trefil/sem/sources/stdutils/src/oled.cpp:75
    ptr->vflip = OLED_Font::Flip_Chars ? 1 : 0;
    96c0:	e51b3008 	ldr	r3, [fp, #-8]
    96c4:	e3a02001 	mov	r2, #1
    96c8:	e5c32009 	strb	r2, [r3, #9]
/home/trefil/sem/sources/stdutils/src/oled.cpp:77
    
    memcpy(&OLED_Font::OLED_Font_Default[OLED_Font::Char_Width * (((uint16_t)c) - OLED_Font::Char_Begin)], &ptr->first, OLED_Font::Char_Width);
    96cc:	e55b3025 	ldrb	r3, [fp, #-37]	; 0xffffffdb
    96d0:	e2432020 	sub	r2, r3, #32
    96d4:	e1a03002 	mov	r3, r2
    96d8:	e1a03083 	lsl	r3, r3, #1
    96dc:	e0833002 	add	r3, r3, r2
    96e0:	e1a03083 	lsl	r3, r3, #1
    96e4:	e1a02003 	mov	r2, r3
    96e8:	e59f3044 	ldr	r3, [pc, #68]	; 9734 <_ZN13COLED_Display8Put_CharEttc+0x164>
    96ec:	e0820003 	add	r0, r2, r3
    96f0:	e51b3008 	ldr	r3, [fp, #-8]
    96f4:	e283300a 	add	r3, r3, #10
    96f8:	e3a02006 	mov	r2, #6
    96fc:	e1a01003 	mov	r1, r3
    9700:	ebfffe1d 	bl	8f7c <_Z6memcpyPKvPvi>
/home/trefil/sem/sources/stdutils/src/oled.cpp:79

    write(mHandle, buf, sizeof(buf));
    9704:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    9708:	e5933000 	ldr	r3, [r3]
    970c:	e24b101c 	sub	r1, fp, #28
    9710:	e3a02011 	mov	r2, #17
    9714:	e1a00003 	mov	r0, r3
    9718:	ebfffb2f 	bl	83dc <_Z5writejPKcj>
    971c:	ea000002 	b	972c <_ZN13COLED_Display8Put_CharEttc+0x15c>
/home/trefil/sem/sources/stdutils/src/oled.cpp:61
        return;
    9720:	e320f000 	nop	{0}
    9724:	ea000000 	b	972c <_ZN13COLED_Display8Put_CharEttc+0x15c>
/home/trefil/sem/sources/stdutils/src/oled.cpp:65
        return;
    9728:	e320f000 	nop	{0}
/home/trefil/sem/sources/stdutils/src/oled.cpp:80
}
    972c:	e24bd004 	sub	sp, fp, #4
    9730:	e8bd8800 	pop	{fp, pc}
    9734:	0000a0d0 	ldrdeq	sl, [r0], -r0

00009738 <_ZN13COLED_Display4FlipEv>:
_ZN13COLED_Display4FlipEv():
/home/trefil/sem/sources/stdutils/src/oled.cpp:83

void COLED_Display::Flip()
{
    9738:	e92d4800 	push	{fp, lr}
    973c:	e28db004 	add	fp, sp, #4
    9740:	e24dd010 	sub	sp, sp, #16
    9744:	e50b0010 	str	r0, [fp, #-16]
/home/trefil/sem/sources/stdutils/src/oled.cpp:84
    if (!mOpened)
    9748:	e51b3010 	ldr	r3, [fp, #-16]
    974c:	e5d33004 	ldrb	r3, [r3, #4]
    9750:	e2233001 	eor	r3, r3, #1
    9754:	e6ef3073 	uxtb	r3, r3
    9758:	e3530000 	cmp	r3, #0
    975c:	1a000008 	bne	9784 <_ZN13COLED_Display4FlipEv+0x4c>
/home/trefil/sem/sources/stdutils/src/oled.cpp:88
        return;

    TDisplay_NonParametric_Packet pkt;
    pkt.header.cmd = NDisplay_Command::Flip;
    9760:	e3a03001 	mov	r3, #1
    9764:	e54b3008 	strb	r3, [fp, #-8]
/home/trefil/sem/sources/stdutils/src/oled.cpp:90

    write(mHandle, reinterpret_cast<char*>(&pkt), sizeof(pkt));
    9768:	e51b3010 	ldr	r3, [fp, #-16]
    976c:	e5933000 	ldr	r3, [r3]
    9770:	e24b1008 	sub	r1, fp, #8
    9774:	e3a02001 	mov	r2, #1
    9778:	e1a00003 	mov	r0, r3
    977c:	ebfffb16 	bl	83dc <_Z5writejPKcj>
    9780:	ea000000 	b	9788 <_ZN13COLED_Display4FlipEv+0x50>
/home/trefil/sem/sources/stdutils/src/oled.cpp:85
        return;
    9784:	e320f000 	nop	{0}
/home/trefil/sem/sources/stdutils/src/oled.cpp:91
}
    9788:	e24bd004 	sub	sp, fp, #4
    978c:	e8bd8800 	pop	{fp, pc}

00009790 <_ZN13COLED_Display10Put_StringEttPKc>:
_ZN13COLED_Display10Put_StringEttPKc():
/home/trefil/sem/sources/stdutils/src/oled.cpp:94

void COLED_Display::Put_String(uint16_t x, uint16_t y, const char* str)
{
    9790:	e92d4800 	push	{fp, lr}
    9794:	e28db004 	add	fp, sp, #4
    9798:	e24dd018 	sub	sp, sp, #24
    979c:	e50b0010 	str	r0, [fp, #-16]
    97a0:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
    97a4:	e1a03001 	mov	r3, r1
    97a8:	e14b31b2 	strh	r3, [fp, #-18]	; 0xffffffee
    97ac:	e1a03002 	mov	r3, r2
    97b0:	e14b31b4 	strh	r3, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/stdutils/src/oled.cpp:95
    if (!mOpened)
    97b4:	e51b3010 	ldr	r3, [fp, #-16]
    97b8:	e5d33004 	ldrb	r3, [r3, #4]
    97bc:	e2233001 	eor	r3, r3, #1
    97c0:	e6ef3073 	uxtb	r3, r3
    97c4:	e3530000 	cmp	r3, #0
    97c8:	1a000019 	bne	9834 <_ZN13COLED_Display10Put_StringEttPKc+0xa4>
/home/trefil/sem/sources/stdutils/src/oled.cpp:98
        return;

    uint16_t xi = x;
    97cc:	e15b31b2 	ldrh	r3, [fp, #-18]	; 0xffffffee
    97d0:	e14b30b6 	strh	r3, [fp, #-6]
/home/trefil/sem/sources/stdutils/src/oled.cpp:99
    const char* ptr = str;
    97d4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    97d8:	e50b300c 	str	r3, [fp, #-12]
/home/trefil/sem/sources/stdutils/src/oled.cpp:101
    // dokud nedojdeme na konec retezce nebo dokud nejsme 64 znaku daleko (limit, kdyby nahodou se neco pokazilo)
    while (*ptr != '\0' && ptr - str < 64)
    97dc:	e51b300c 	ldr	r3, [fp, #-12]
    97e0:	e5d33000 	ldrb	r3, [r3]
    97e4:	e3530000 	cmp	r3, #0
    97e8:	0a000012 	beq	9838 <_ZN13COLED_Display10Put_StringEttPKc+0xa8>
/home/trefil/sem/sources/stdutils/src/oled.cpp:101 (discriminator 1)
    97ec:	e51b200c 	ldr	r2, [fp, #-12]
    97f0:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    97f4:	e0423003 	sub	r3, r2, r3
    97f8:	e353003f 	cmp	r3, #63	; 0x3f
    97fc:	ca00000d 	bgt	9838 <_ZN13COLED_Display10Put_StringEttPKc+0xa8>
/home/trefil/sem/sources/stdutils/src/oled.cpp:103
    {
        Put_Char(xi, y, *ptr);
    9800:	e51b300c 	ldr	r3, [fp, #-12]
    9804:	e5d33000 	ldrb	r3, [r3]
    9808:	e15b21b4 	ldrh	r2, [fp, #-20]	; 0xffffffec
    980c:	e15b10b6 	ldrh	r1, [fp, #-6]
    9810:	e51b0010 	ldr	r0, [fp, #-16]
    9814:	ebffff6d 	bl	95d0 <_ZN13COLED_Display8Put_CharEttc>
/home/trefil/sem/sources/stdutils/src/oled.cpp:104
        xi += OLED_Font::Char_Width;
    9818:	e15b30b6 	ldrh	r3, [fp, #-6]
    981c:	e2833006 	add	r3, r3, #6
    9820:	e14b30b6 	strh	r3, [fp, #-6]
/home/trefil/sem/sources/stdutils/src/oled.cpp:105
        ptr++;
    9824:	e51b300c 	ldr	r3, [fp, #-12]
    9828:	e2833001 	add	r3, r3, #1
    982c:	e50b300c 	str	r3, [fp, #-12]
/home/trefil/sem/sources/stdutils/src/oled.cpp:101
    while (*ptr != '\0' && ptr - str < 64)
    9830:	eaffffe9 	b	97dc <_ZN13COLED_Display10Put_StringEttPKc+0x4c>
/home/trefil/sem/sources/stdutils/src/oled.cpp:96
        return;
    9834:	e320f000 	nop	{0}
/home/trefil/sem/sources/stdutils/src/oled.cpp:107
    }
}
    9838:	e24bd004 	sub	sp, fp, #4
    983c:	e8bd8800 	pop	{fp, pc}

00009840 <__udivsi3>:
__udivsi3():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1104
    9840:	e2512001 	subs	r2, r1, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1106
    9844:	012fff1e 	bxeq	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1107
    9848:	3a000074 	bcc	9a20 <__udivsi3+0x1e0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1108
    984c:	e1500001 	cmp	r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1109
    9850:	9a00006b 	bls	9a04 <__udivsi3+0x1c4>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1110
    9854:	e1110002 	tst	r1, r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1111
    9858:	0a00006c 	beq	9a10 <__udivsi3+0x1d0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1113
    985c:	e16f3f10 	clz	r3, r0
    9860:	e16f2f11 	clz	r2, r1
    9864:	e0423003 	sub	r3, r2, r3
    9868:	e273301f 	rsbs	r3, r3, #31
    986c:	10833083 	addne	r3, r3, r3, lsl #1
    9870:	e3a02000 	mov	r2, #0
    9874:	108ff103 	addne	pc, pc, r3, lsl #2
    9878:	e1a00000 	nop			; (mov r0, r0)
    987c:	e1500f81 	cmp	r0, r1, lsl #31
    9880:	e0a22002 	adc	r2, r2, r2
    9884:	20400f81 	subcs	r0, r0, r1, lsl #31
    9888:	e1500f01 	cmp	r0, r1, lsl #30
    988c:	e0a22002 	adc	r2, r2, r2
    9890:	20400f01 	subcs	r0, r0, r1, lsl #30
    9894:	e1500e81 	cmp	r0, r1, lsl #29
    9898:	e0a22002 	adc	r2, r2, r2
    989c:	20400e81 	subcs	r0, r0, r1, lsl #29
    98a0:	e1500e01 	cmp	r0, r1, lsl #28
    98a4:	e0a22002 	adc	r2, r2, r2
    98a8:	20400e01 	subcs	r0, r0, r1, lsl #28
    98ac:	e1500d81 	cmp	r0, r1, lsl #27
    98b0:	e0a22002 	adc	r2, r2, r2
    98b4:	20400d81 	subcs	r0, r0, r1, lsl #27
    98b8:	e1500d01 	cmp	r0, r1, lsl #26
    98bc:	e0a22002 	adc	r2, r2, r2
    98c0:	20400d01 	subcs	r0, r0, r1, lsl #26
    98c4:	e1500c81 	cmp	r0, r1, lsl #25
    98c8:	e0a22002 	adc	r2, r2, r2
    98cc:	20400c81 	subcs	r0, r0, r1, lsl #25
    98d0:	e1500c01 	cmp	r0, r1, lsl #24
    98d4:	e0a22002 	adc	r2, r2, r2
    98d8:	20400c01 	subcs	r0, r0, r1, lsl #24
    98dc:	e1500b81 	cmp	r0, r1, lsl #23
    98e0:	e0a22002 	adc	r2, r2, r2
    98e4:	20400b81 	subcs	r0, r0, r1, lsl #23
    98e8:	e1500b01 	cmp	r0, r1, lsl #22
    98ec:	e0a22002 	adc	r2, r2, r2
    98f0:	20400b01 	subcs	r0, r0, r1, lsl #22
    98f4:	e1500a81 	cmp	r0, r1, lsl #21
    98f8:	e0a22002 	adc	r2, r2, r2
    98fc:	20400a81 	subcs	r0, r0, r1, lsl #21
    9900:	e1500a01 	cmp	r0, r1, lsl #20
    9904:	e0a22002 	adc	r2, r2, r2
    9908:	20400a01 	subcs	r0, r0, r1, lsl #20
    990c:	e1500981 	cmp	r0, r1, lsl #19
    9910:	e0a22002 	adc	r2, r2, r2
    9914:	20400981 	subcs	r0, r0, r1, lsl #19
    9918:	e1500901 	cmp	r0, r1, lsl #18
    991c:	e0a22002 	adc	r2, r2, r2
    9920:	20400901 	subcs	r0, r0, r1, lsl #18
    9924:	e1500881 	cmp	r0, r1, lsl #17
    9928:	e0a22002 	adc	r2, r2, r2
    992c:	20400881 	subcs	r0, r0, r1, lsl #17
    9930:	e1500801 	cmp	r0, r1, lsl #16
    9934:	e0a22002 	adc	r2, r2, r2
    9938:	20400801 	subcs	r0, r0, r1, lsl #16
    993c:	e1500781 	cmp	r0, r1, lsl #15
    9940:	e0a22002 	adc	r2, r2, r2
    9944:	20400781 	subcs	r0, r0, r1, lsl #15
    9948:	e1500701 	cmp	r0, r1, lsl #14
    994c:	e0a22002 	adc	r2, r2, r2
    9950:	20400701 	subcs	r0, r0, r1, lsl #14
    9954:	e1500681 	cmp	r0, r1, lsl #13
    9958:	e0a22002 	adc	r2, r2, r2
    995c:	20400681 	subcs	r0, r0, r1, lsl #13
    9960:	e1500601 	cmp	r0, r1, lsl #12
    9964:	e0a22002 	adc	r2, r2, r2
    9968:	20400601 	subcs	r0, r0, r1, lsl #12
    996c:	e1500581 	cmp	r0, r1, lsl #11
    9970:	e0a22002 	adc	r2, r2, r2
    9974:	20400581 	subcs	r0, r0, r1, lsl #11
    9978:	e1500501 	cmp	r0, r1, lsl #10
    997c:	e0a22002 	adc	r2, r2, r2
    9980:	20400501 	subcs	r0, r0, r1, lsl #10
    9984:	e1500481 	cmp	r0, r1, lsl #9
    9988:	e0a22002 	adc	r2, r2, r2
    998c:	20400481 	subcs	r0, r0, r1, lsl #9
    9990:	e1500401 	cmp	r0, r1, lsl #8
    9994:	e0a22002 	adc	r2, r2, r2
    9998:	20400401 	subcs	r0, r0, r1, lsl #8
    999c:	e1500381 	cmp	r0, r1, lsl #7
    99a0:	e0a22002 	adc	r2, r2, r2
    99a4:	20400381 	subcs	r0, r0, r1, lsl #7
    99a8:	e1500301 	cmp	r0, r1, lsl #6
    99ac:	e0a22002 	adc	r2, r2, r2
    99b0:	20400301 	subcs	r0, r0, r1, lsl #6
    99b4:	e1500281 	cmp	r0, r1, lsl #5
    99b8:	e0a22002 	adc	r2, r2, r2
    99bc:	20400281 	subcs	r0, r0, r1, lsl #5
    99c0:	e1500201 	cmp	r0, r1, lsl #4
    99c4:	e0a22002 	adc	r2, r2, r2
    99c8:	20400201 	subcs	r0, r0, r1, lsl #4
    99cc:	e1500181 	cmp	r0, r1, lsl #3
    99d0:	e0a22002 	adc	r2, r2, r2
    99d4:	20400181 	subcs	r0, r0, r1, lsl #3
    99d8:	e1500101 	cmp	r0, r1, lsl #2
    99dc:	e0a22002 	adc	r2, r2, r2
    99e0:	20400101 	subcs	r0, r0, r1, lsl #2
    99e4:	e1500081 	cmp	r0, r1, lsl #1
    99e8:	e0a22002 	adc	r2, r2, r2
    99ec:	20400081 	subcs	r0, r0, r1, lsl #1
    99f0:	e1500001 	cmp	r0, r1
    99f4:	e0a22002 	adc	r2, r2, r2
    99f8:	20400001 	subcs	r0, r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1115
    99fc:	e1a00002 	mov	r0, r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1116
    9a00:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1119
    9a04:	03a00001 	moveq	r0, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1120
    9a08:	13a00000 	movne	r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1121
    9a0c:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1123
    9a10:	e16f2f11 	clz	r2, r1
    9a14:	e262201f 	rsb	r2, r2, #31
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1125
    9a18:	e1a00230 	lsr	r0, r0, r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1126
    9a1c:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1130
    9a20:	e3500000 	cmp	r0, #0
    9a24:	13e00000 	mvnne	r0, #0
    9a28:	ea000007 	b	9a4c <__aeabi_idiv0>

00009a2c <__aeabi_uidivmod>:
__aeabi_uidivmod():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1161
    9a2c:	e3510000 	cmp	r1, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1162
    9a30:	0afffffa 	beq	9a20 <__udivsi3+0x1e0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1163
    9a34:	e92d4003 	push	{r0, r1, lr}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1164
    9a38:	ebffff80 	bl	9840 <__udivsi3>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1165
    9a3c:	e8bd4006 	pop	{r1, r2, lr}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1166
    9a40:	e0030092 	mul	r3, r2, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1167
    9a44:	e0411003 	sub	r1, r1, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1168
    9a48:	e12fff1e 	bx	lr

00009a4c <__aeabi_idiv0>:
__aeabi_ldiv0():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1466
    9a4c:	e12fff1e 	bx	lr

00009a50 <__aeabi_frsub>:
__aeabi_frsub():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:59
    9a50:	e2200102 	eor	r0, r0, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:60
    9a54:	ea000000 	b	9a5c <__addsf3>

00009a58 <__aeabi_fsub>:
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:65
    9a58:	e2211102 	eor	r1, r1, #-2147483648	; 0x80000000

00009a5c <__addsf3>:
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:74
    9a5c:	e1b02080 	lsls	r2, r0, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:76
    9a60:	11b03081 	lslsne	r3, r1, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:77
    9a64:	11320003 	teqne	r2, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:78
    9a68:	11f0cc42 	mvnsne	ip, r2, asr #24
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:79
    9a6c:	11f0cc43 	mvnsne	ip, r3, asr #24
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:80
    9a70:	0a00003c 	beq	9b68 <__addsf3+0x10c>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:84
    9a74:	e1a02c22 	lsr	r2, r2, #24
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:85
    9a78:	e0723c23 	rsbs	r3, r2, r3, lsr #24
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:87
    9a7c:	c0822003 	addgt	r2, r2, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:88
    9a80:	c0201001 	eorgt	r1, r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:89
    9a84:	c0210000 	eorgt	r0, r1, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:90
    9a88:	c0201001 	eorgt	r1, r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:92
    9a8c:	b2633000 	rsblt	r3, r3, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:97
    9a90:	e3530019 	cmp	r3, #25
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:99
    9a94:	812fff1e 	bxhi	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:102
    9a98:	e3100102 	tst	r0, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:103
    9a9c:	e3800502 	orr	r0, r0, #8388608	; 0x800000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:104
    9aa0:	e3c004ff 	bic	r0, r0, #-16777216	; 0xff000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:106
    9aa4:	12600000 	rsbne	r0, r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:107
    9aa8:	e3110102 	tst	r1, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:108
    9aac:	e3811502 	orr	r1, r1, #8388608	; 0x800000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:109
    9ab0:	e3c114ff 	bic	r1, r1, #-16777216	; 0xff000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:111
    9ab4:	12611000 	rsbne	r1, r1, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:115
    9ab8:	e1320003 	teq	r2, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:116
    9abc:	0a000023 	beq	9b50 <__addsf3+0xf4>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:120
    9ac0:	e2422001 	sub	r2, r2, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:124
    9ac4:	e0900351 	adds	r0, r0, r1, asr r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:125
    9ac8:	e2633020 	rsb	r3, r3, #32
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:126
    9acc:	e1a01311 	lsl	r1, r1, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:129
    9ad0:	e2003102 	and	r3, r0, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:130
    9ad4:	5a000001 	bpl	9ae0 <__addsf3+0x84>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:135
    9ad8:	e2711000 	rsbs	r1, r1, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:136
    9adc:	e2e00000 	rsc	r0, r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:141
    9ae0:	e3500502 	cmp	r0, #8388608	; 0x800000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:142
    9ae4:	3a00000b 	bcc	9b18 <__addsf3+0xbc>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:143
    9ae8:	e3500401 	cmp	r0, #16777216	; 0x1000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:144
    9aec:	3a000004 	bcc	9b04 <__addsf3+0xa8>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:147
    9af0:	e1b000a0 	lsrs	r0, r0, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:148
    9af4:	e1a01061 	rrx	r1, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:149
    9af8:	e2822001 	add	r2, r2, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:152
    9afc:	e35200fe 	cmp	r2, #254	; 0xfe
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:153
    9b00:	2a00002d 	bcs	9bbc <__addsf3+0x160>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:160
    9b04:	e3510102 	cmp	r1, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:161
    9b08:	e0a00b82 	adc	r0, r0, r2, lsl #23
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:163
    9b0c:	03c00001 	biceq	r0, r0, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:164
    9b10:	e1800003 	orr	r0, r0, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:165
    9b14:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:169
    9b18:	e1b01081 	lsls	r1, r1, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:170
    9b1c:	e0a00000 	adc	r0, r0, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:171
    9b20:	e2522001 	subs	r2, r2, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:173
    9b24:	23500502 	cmpcs	r0, #8388608	; 0x800000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:174
    9b28:	2afffff5 	bcs	9b04 <__addsf3+0xa8>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:199
    9b2c:	e16fcf10 	clz	ip, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:200
    9b30:	e24cc008 	sub	ip, ip, #8
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:201
    9b34:	e052200c 	subs	r2, r2, ip
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:202
    9b38:	e1a00c10 	lsl	r0, r0, ip
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:209
    9b3c:	a0800b82 	addge	r0, r0, r2, lsl #23
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:210
    9b40:	b2622000 	rsblt	r2, r2, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:211
    9b44:	a1800003 	orrge	r0, r0, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:217
    9b48:	b1830230 	orrlt	r0, r3, r0, lsr r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:219
    9b4c:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:224
    9b50:	e3320000 	teq	r2, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:225
    9b54:	e2211502 	eor	r1, r1, #8388608	; 0x800000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:227
    9b58:	02200502 	eoreq	r0, r0, #8388608	; 0x800000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:228
    9b5c:	02822001 	addeq	r2, r2, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:229
    9b60:	12433001 	subne	r3, r3, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:230
    9b64:	eaffffd5 	b	9ac0 <__addsf3+0x64>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:233
    9b68:	e1a03081 	lsl	r3, r1, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:235
    9b6c:	e1f0cc42 	mvns	ip, r2, asr #24
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:237
    9b70:	11f0cc43 	mvnsne	ip, r3, asr #24
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:238
    9b74:	0a000013 	beq	9bc8 <__addsf3+0x16c>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:240
    9b78:	e1320003 	teq	r2, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:241
    9b7c:	0a000002 	beq	9b8c <__addsf3+0x130>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:244
    9b80:	e3320000 	teq	r2, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:246
    9b84:	01a00001 	moveq	r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:247
    9b88:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:249
    9b8c:	e1300001 	teq	r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:253
    9b90:	13a00000 	movne	r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:254
    9b94:	112fff1e 	bxne	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:257
    9b98:	e31204ff 	tst	r2, #-16777216	; 0xff000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:258
    9b9c:	1a000002 	bne	9bac <__addsf3+0x150>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:259
    9ba0:	e1b00080 	lsls	r0, r0, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:261
    9ba4:	23800102 	orrcs	r0, r0, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:262
    9ba8:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:263
    9bac:	e2922402 	adds	r2, r2, #33554432	; 0x2000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:265
    9bb0:	32800502 	addcc	r0, r0, #8388608	; 0x800000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:266
    9bb4:	312fff1e 	bxcc	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:267
    9bb8:	e2003102 	and	r3, r0, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:271
    9bbc:	e383047f 	orr	r0, r3, #2130706432	; 0x7f000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:272
    9bc0:	e3800502 	orr	r0, r0, #8388608	; 0x800000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:273
    9bc4:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:282
    9bc8:	e1f02c42 	mvns	r2, r2, asr #24
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:284
    9bcc:	11a00001 	movne	r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:285
    9bd0:	01f03c43 	mvnseq	r3, r3, asr #24
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:286
    9bd4:	11a01000 	movne	r1, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:287
    9bd8:	e1b02480 	lsls	r2, r0, #9
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:289
    9bdc:	01b03481 	lslseq	r3, r1, #9
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:290
    9be0:	01300001 	teqeq	r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:291
    9be4:	13800501 	orrne	r0, r0, #4194304	; 0x400000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:292
    9be8:	e12fff1e 	bx	lr

00009bec <__aeabi_ui2f>:
__aeabi_ui2f():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:305
    9bec:	e3a03000 	mov	r3, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:306
    9bf0:	ea000001 	b	9bfc <__aeabi_i2f+0x8>

00009bf4 <__aeabi_i2f>:
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:311
    9bf4:	e2103102 	ands	r3, r0, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:313
    9bf8:	42600000 	rsbmi	r0, r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:315
    9bfc:	e1b0c000 	movs	ip, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:317
    9c00:	012fff1e 	bxeq	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:320
    9c04:	e383344b 	orr	r3, r3, #1258291200	; 0x4b000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:323
    9c08:	e1a01000 	mov	r1, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:325
    9c0c:	e3a00000 	mov	r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:326
    9c10:	ea00000f 	b	9c54 <__aeabi_l2f+0x30>

00009c14 <__aeabi_ul2f>:
__floatundisf():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:338
    9c14:	e1902001 	orrs	r2, r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:340
    9c18:	012fff1e 	bxeq	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:342
    9c1c:	e3a03000 	mov	r3, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:343
    9c20:	ea000005 	b	9c3c <__aeabi_l2f+0x18>

00009c24 <__aeabi_l2f>:
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:348
    9c24:	e1902001 	orrs	r2, r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:350
    9c28:	012fff1e 	bxeq	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:352
    9c2c:	e2113102 	ands	r3, r1, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:353
    9c30:	5a000001 	bpl	9c3c <__aeabi_l2f+0x18>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:358
    9c34:	e2700000 	rsbs	r0, r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:359
    9c38:	e2e11000 	rsc	r1, r1, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:362
    9c3c:	e1b0c001 	movs	ip, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:364
    9c40:	01a0c000 	moveq	ip, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:365
    9c44:	01a01000 	moveq	r1, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:366
    9c48:	03a00000 	moveq	r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:369
    9c4c:	e383345b 	orr	r3, r3, #1526726656	; 0x5b000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:371
    9c50:	02433201 	subeq	r3, r3, #268435456	; 0x10000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:372
    9c54:	e2433502 	sub	r3, r3, #8388608	; 0x800000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:397
    9c58:	e16f2f1c 	clz	r2, ip
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:398
    9c5c:	e2522008 	subs	r2, r2, #8
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:402
    9c60:	e0433b82 	sub	r3, r3, r2, lsl #23
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:403
    9c64:	ba000006 	blt	9c84 <__aeabi_l2f+0x60>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:405
    9c68:	e0833211 	add	r3, r3, r1, lsl r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:406
    9c6c:	e1a0c210 	lsl	ip, r0, r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:407
    9c70:	e2622020 	rsb	r2, r2, #32
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:408
    9c74:	e35c0102 	cmp	ip, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:409
    9c78:	e0a30230 	adc	r0, r3, r0, lsr r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:411
    9c7c:	03c00001 	biceq	r0, r0, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:412
    9c80:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:414
    9c84:	e2822020 	add	r2, r2, #32
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:415
    9c88:	e1a0c211 	lsl	ip, r1, r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:416
    9c8c:	e2622020 	rsb	r2, r2, #32
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:417
    9c90:	e190008c 	orrs	r0, r0, ip, lsl #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:418
    9c94:	e0a30231 	adc	r0, r3, r1, lsr r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:420
    9c98:	01c00fac 	biceq	r0, r0, ip, lsr #31
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:421
    9c9c:	e12fff1e 	bx	lr

00009ca0 <__aeabi_ldivmod>:
__aeabi_ldivmod():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:186
    9ca0:	e3530000 	cmp	r3, #0
    9ca4:	03520000 	cmpeq	r2, #0
    9ca8:	1a000007 	bne	9ccc <__aeabi_ldivmod+0x2c>
    9cac:	e3510000 	cmp	r1, #0
    9cb0:	b3a01102 	movlt	r1, #-2147483648	; 0x80000000
    9cb4:	b3a00000 	movlt	r0, #0
    9cb8:	ba000002 	blt	9cc8 <__aeabi_ldivmod+0x28>
    9cbc:	03500000 	cmpeq	r0, #0
    9cc0:	13e01102 	mvnne	r1, #-2147483648	; 0x80000000
    9cc4:	13e00000 	mvnne	r0, #0
    9cc8:	eaffff5f 	b	9a4c <__aeabi_idiv0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:188
    9ccc:	e24dd008 	sub	sp, sp, #8
    9cd0:	e92d6000 	push	{sp, lr}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:189
    9cd4:	e3510000 	cmp	r1, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:190
    9cd8:	ba000006 	blt	9cf8 <__aeabi_ldivmod+0x58>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:191
    9cdc:	e3530000 	cmp	r3, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:192
    9ce0:	ba000011 	blt	9d2c <__aeabi_ldivmod+0x8c>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:194
    9ce4:	eb00003f 	bl	9de8 <__udivmoddi4>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:196
    9ce8:	e59de004 	ldr	lr, [sp, #4]
    9cec:	e28dd008 	add	sp, sp, #8
    9cf0:	e8bd000c 	pop	{r2, r3}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:197
    9cf4:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:201
    9cf8:	e2700000 	rsbs	r0, r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:202
    9cfc:	e0c11081 	sbc	r1, r1, r1, lsl #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:203
    9d00:	e3530000 	cmp	r3, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:204
    9d04:	ba000011 	blt	9d50 <__aeabi_ldivmod+0xb0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:206
    9d08:	eb000036 	bl	9de8 <__udivmoddi4>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:208
    9d0c:	e59de004 	ldr	lr, [sp, #4]
    9d10:	e28dd008 	add	sp, sp, #8
    9d14:	e8bd000c 	pop	{r2, r3}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:209
    9d18:	e2700000 	rsbs	r0, r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:210
    9d1c:	e0c11081 	sbc	r1, r1, r1, lsl #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:211
    9d20:	e2722000 	rsbs	r2, r2, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:212
    9d24:	e0c33083 	sbc	r3, r3, r3, lsl #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:213
    9d28:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:217
    9d2c:	e2722000 	rsbs	r2, r2, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:218
    9d30:	e0c33083 	sbc	r3, r3, r3, lsl #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:220
    9d34:	eb00002b 	bl	9de8 <__udivmoddi4>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:222
    9d38:	e59de004 	ldr	lr, [sp, #4]
    9d3c:	e28dd008 	add	sp, sp, #8
    9d40:	e8bd000c 	pop	{r2, r3}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:223
    9d44:	e2700000 	rsbs	r0, r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:224
    9d48:	e0c11081 	sbc	r1, r1, r1, lsl #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:225
    9d4c:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:229
    9d50:	e2722000 	rsbs	r2, r2, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:230
    9d54:	e0c33083 	sbc	r3, r3, r3, lsl #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:232
    9d58:	eb000022 	bl	9de8 <__udivmoddi4>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:233
    9d5c:	e59de004 	ldr	lr, [sp, #4]
    9d60:	e28dd008 	add	sp, sp, #8
    9d64:	e8bd000c 	pop	{r2, r3}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:234
    9d68:	e2722000 	rsbs	r2, r2, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:235
    9d6c:	e0c33083 	sbc	r3, r3, r3, lsl #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:236
    9d70:	e12fff1e 	bx	lr

00009d74 <__aeabi_f2lz>:
__fixsfdi():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1530
    9d74:	ee070a90 	vmov	s15, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1531
    9d78:	eef57ac0 	vcmpe.f32	s15, #0.0
    9d7c:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    9d80:	4a000000 	bmi	9d88 <__aeabi_f2lz+0x14>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1533
    9d84:	ea000007 	b	9da8 <__aeabi_f2ulz>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1532
    9d88:	eef17a67 	vneg.f32	s15, s15
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1530
    9d8c:	e92d4010 	push	{r4, lr}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1532
    9d90:	ee170a90 	vmov	r0, s15
    9d94:	eb000003 	bl	9da8 <__aeabi_f2ulz>
    9d98:	e2700000 	rsbs	r0, r0, #0
    9d9c:	e2e11000 	rsc	r1, r1, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1534
    9da0:	e8bd8010 	pop	{r4, pc}
__aeabi_f2lz():
    9da4:	00000000 	andeq	r0, r0, r0

00009da8 <__aeabi_f2ulz>:
__fixunssfdi():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1471
    9da8:	ee070a90 	vmov	s15, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1476
    9dac:	ed9f6b09 	vldr	d6, [pc, #36]	; 9dd8 <__aeabi_f2ulz+0x30>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1481
    9db0:	ed9f5b0a 	vldr	d5, [pc, #40]	; 9de0 <__aeabi_f2ulz+0x38>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1471
    9db4:	eeb77ae7 	vcvt.f64.f32	d7, s15
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1476
    9db8:	ee276b06 	vmul.f64	d6, d7, d6
    9dbc:	eebc6bc6 	vcvt.u32.f64	s12, d6
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1481
    9dc0:	eeb84b46 	vcvt.f64.u32	d4, s12
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1524
    9dc4:	ee161a10 	vmov	r1, s12
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1481
    9dc8:	ee047b45 	vmls.f64	d7, d4, d5
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1524
    9dcc:	eefc7bc7 	vcvt.u32.f64	s15, d7
    9dd0:	ee170a90 	vmov	r0, s15
    9dd4:	e12fff1e 	bx	lr
    9dd8:	00000000 	andeq	r0, r0, r0
    9ddc:	3df00000 	ldclcc	0, cr0, [r0]
    9de0:	00000000 	andeq	r0, r0, r0
    9de4:	41f00000 	mvnsmi	r0, r0

00009de8 <__udivmoddi4>:
__udivmoddi4():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:960
    9de8:	e1500002 	cmp	r0, r2
    9dec:	e0d1c003 	sbcs	ip, r1, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:948
    9df0:	e92d43f0 	push	{r4, r5, r6, r7, r8, r9, lr}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:949
    9df4:	33a05000 	movcc	r5, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:948
    9df8:	e59d701c 	ldr	r7, [sp, #28]
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:949
    9dfc:	31a06005 	movcc	r6, r5
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:960
    9e00:	3a00003b 	bcc	9ef4 <__udivmoddi4+0x10c>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:962
    9e04:	e3530000 	cmp	r3, #0
    9e08:	016fcf12 	clzeq	ip, r2
    9e0c:	116fef13 	clzne	lr, r3
    9e10:	028ce020 	addeq	lr, ip, #32
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:963
    9e14:	e3510000 	cmp	r1, #0
    9e18:	016fcf10 	clzeq	ip, r0
    9e1c:	028cc020 	addeq	ip, ip, #32
    9e20:	116fcf11 	clzne	ip, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:965
    9e24:	e04ec00c 	sub	ip, lr, ip
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:966
    9e28:	e1a03c13 	lsl	r3, r3, ip
    9e2c:	e24c9020 	sub	r9, ip, #32
    9e30:	e1833912 	orr	r3, r3, r2, lsl r9
    9e34:	e1a04c12 	lsl	r4, r2, ip
    9e38:	e26c8020 	rsb	r8, ip, #32
    9e3c:	e1833832 	orr	r3, r3, r2, lsr r8
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:973
    9e40:	e1500004 	cmp	r0, r4
    9e44:	e0d12003 	sbcs	r2, r1, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:949
    9e48:	33a05000 	movcc	r5, #0
    9e4c:	31a06005 	movcc	r6, r5
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:973
    9e50:	3a000005 	bcc	9e6c <__udivmoddi4+0x84>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:976
    9e54:	e3a05001 	mov	r5, #1
    9e58:	e1a06915 	lsl	r6, r5, r9
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:975
    9e5c:	e0500004 	subs	r0, r0, r4
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:976
    9e60:	e1866835 	orr	r6, r6, r5, lsr r8
    9e64:	e1a05c15 	lsl	r5, r5, ip
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:975
    9e68:	e0c11003 	sbc	r1, r1, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:979
    9e6c:	e35c0000 	cmp	ip, #0
    9e70:	0a00001f 	beq	9ef4 <__udivmoddi4+0x10c>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:981
    9e74:	e1a040a4 	lsr	r4, r4, #1
    9e78:	e1844f83 	orr	r4, r4, r3, lsl #31
    9e7c:	e1a020a3 	lsr	r2, r3, #1
    9e80:	e1a0e00c 	mov	lr, ip
    9e84:	ea000007 	b	9ea8 <__udivmoddi4+0xc0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:989
    9e88:	e0503004 	subs	r3, r0, r4
    9e8c:	e0c11002 	sbc	r1, r1, r2
    9e90:	e0933003 	adds	r3, r3, r3
    9e94:	e0a11001 	adc	r1, r1, r1
    9e98:	e2930001 	adds	r0, r3, #1
    9e9c:	e2a11000 	adc	r1, r1, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:993
    9ea0:	e25ee001 	subs	lr, lr, #1
    9ea4:	0a000006 	beq	9ec4 <__udivmoddi4+0xdc>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:988
    9ea8:	e1500004 	cmp	r0, r4
    9eac:	e0d13002 	sbcs	r3, r1, r2
    9eb0:	2afffff4 	bcs	9e88 <__udivmoddi4+0xa0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:991
    9eb4:	e0900000 	adds	r0, r0, r0
    9eb8:	e0a11001 	adc	r1, r1, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:993
    9ebc:	e25ee001 	subs	lr, lr, #1
    9ec0:	1afffff8 	bne	9ea8 <__udivmoddi4+0xc0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:997
    9ec4:	e0955000 	adds	r5, r5, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:998
    9ec8:	e1a00c30 	lsr	r0, r0, ip
    9ecc:	e1800811 	orr	r0, r0, r1, lsl r8
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:997
    9ed0:	e0a66001 	adc	r6, r6, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:998
    9ed4:	e1800931 	orr	r0, r0, r1, lsr r9
    9ed8:	e1a01c31 	lsr	r1, r1, ip
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:999
    9edc:	e1a03c10 	lsl	r3, r0, ip
    9ee0:	e1a0cc11 	lsl	ip, r1, ip
    9ee4:	e18cc910 	orr	ip, ip, r0, lsl r9
    9ee8:	e18cc830 	orr	ip, ip, r0, lsr r8
    9eec:	e0555003 	subs	r5, r5, r3
    9ef0:	e0c6600c 	sbc	r6, r6, ip
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1003
    9ef4:	e3570000 	cmp	r7, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1004
    9ef8:	11c700f0 	strdne	r0, [r7]
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1006
    9efc:	e1a00005 	mov	r0, r5
    9f00:	e1a01006 	mov	r1, r6
    9f04:	e8bd83f0 	pop	{r4, r5, r6, r7, r8, r9, pc}

Disassembly of section .rodata:

00009f08 <_ZL13Lock_Unlocked>:
    9f08:	00000000 	andeq	r0, r0, r0

00009f0c <_ZL11Lock_Locked>:
    9f0c:	00000001 	andeq	r0, r0, r1

00009f10 <_ZL21MaxFSDriverNameLength>:
    9f10:	00000010 	andeq	r0, r0, r0, lsl r0

00009f14 <_ZL17MaxFilenameLength>:
    9f14:	00000010 	andeq	r0, r0, r0, lsl r0

00009f18 <_ZL13MaxPathLength>:
    9f18:	00000080 	andeq	r0, r0, r0, lsl #1

00009f1c <_ZL18NoFilesystemDriver>:
    9f1c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009f20 <_ZL9NotifyAll>:
    9f20:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009f24 <_ZL24Max_Process_Opened_Files>:
    9f24:	00000010 	andeq	r0, r0, r0, lsl r0

00009f28 <_ZL10Indefinite>:
    9f28:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009f2c <_ZL18Deadline_Unchanged>:
    9f2c:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

00009f30 <_ZL14Invalid_Handle>:
    9f30:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009f34 <_ZN3halL18Default_Clock_RateE>:
    9f34:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}

00009f38 <_ZN3halL15Peripheral_BaseE>:
    9f38:	20000000 	andcs	r0, r0, r0

00009f3c <_ZN3halL9GPIO_BaseE>:
    9f3c:	20200000 	eorcs	r0, r0, r0

00009f40 <_ZN3halL14GPIO_Pin_CountE>:
    9f40:	00000036 	andeq	r0, r0, r6, lsr r0

00009f44 <_ZN3halL8AUX_BaseE>:
    9f44:	20215000 	eorcs	r5, r1, r0

00009f48 <_ZN3halL25Interrupt_Controller_BaseE>:
    9f48:	2000b200 	andcs	fp, r0, r0, lsl #4

00009f4c <_ZN3halL10Timer_BaseE>:
    9f4c:	2000b400 	andcs	fp, r0, r0, lsl #8

00009f50 <_ZN3halL17System_Timer_BaseE>:
    9f50:	20003000 	andcs	r3, r0, r0

00009f54 <_ZN3halL9TRNG_BaseE>:
    9f54:	20104000 	andscs	r4, r0, r0

00009f58 <_ZN3halL9BSC0_BaseE>:
    9f58:	20205000 	eorcs	r5, r0, r0

00009f5c <_ZN3halL9BSC1_BaseE>:
    9f5c:	20804000 	addcs	r4, r0, r0

00009f60 <_ZN3halL9BSC2_BaseE>:
    9f60:	20805000 	addcs	r5, r0, r0

00009f64 <_ZL11Invalid_Pin>:
    9f64:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
    9f68:	6c622049 	stclvs	0, cr2, [r2], #-292	; 0xfffffedc
    9f6c:	2c6b6e69 	stclcs	14, cr6, [fp], #-420	; 0xfffffe5c
    9f70:	65687420 	strbvs	r7, [r8, #-1056]!	; 0xfffffbe0
    9f74:	6f666572 	svcvs	0x00666572
    9f78:	49206572 	stmdbmi	r0!, {r1, r4, r5, r6, r8, sl, sp, lr}
    9f7c:	2e6d6120 	powcsep	f6, f5, f0
    9f80:	00000000 	andeq	r0, r0, r0
    9f84:	65732049 	ldrbvs	r2, [r3, #-73]!	; 0xffffffb7
    9f88:	65642065 	strbvs	r2, [r4, #-101]!	; 0xffffff9b
    9f8c:	70206461 	eorvc	r6, r0, r1, ror #8
    9f90:	6c657869 	stclvs	8, cr7, [r5], #-420	; 0xfffffe5c
    9f94:	00002e73 	andeq	r2, r0, r3, ror lr
    9f98:	20656e4f 	rsbcs	r6, r5, pc, asr #28
    9f9c:	20555043 	subscs	r5, r5, r3, asr #32
    9fa0:	656c7572 	strbvs	r7, [ip, #-1394]!	; 0xfffffa8e
    9fa4:	68742073 	ldmdavs	r4!, {r0, r1, r4, r5, r6, sp}^
    9fa8:	61206d65 			; <UNDEFINED> instruction: 0x61206d65
    9fac:	002e6c6c 	eoreq	r6, lr, ip, ror #24
    9fb0:	6620794d 	strtvs	r7, [r0], -sp, asr #18
    9fb4:	756f7661 	strbvc	r7, [pc, #-1633]!	; 995b <__udivsi3+0x11b>
    9fb8:	65746972 	ldrbvs	r6, [r4, #-2418]!	; 0xfffff68e
    9fbc:	6f707320 	svcvs	0x00707320
    9fc0:	69207472 	stmdbvs	r0!, {r1, r4, r5, r6, sl, ip, sp, lr}
    9fc4:	52412073 	subpl	r2, r1, #115	; 0x73
    9fc8:	7277204d 	rsbsvc	r2, r7, #77	; 0x4d
    9fcc:	6c747365 	ldclvs	3, cr7, [r4], #-404	; 0xfffffe6c
    9fd0:	00676e69 	rsbeq	r6, r7, r9, ror #28
    9fd4:	20646c4f 	rsbcs	r6, r4, pc, asr #24
    9fd8:	4463614d 	strbtmi	r6, [r3], #-333	; 0xfffffeb3
    9fdc:	6c616e6f 	stclvs	14, cr6, [r1], #-444	; 0xfffffe44
    9fe0:	61682064 	cmnvs	r8, r4, rrx
    9fe4:	20612064 	rsbcs	r2, r1, r4, rrx
    9fe8:	6d726166 	ldfvse	f6, [r2, #-408]!	; 0xfffffe68
    9fec:	4945202c 	stmdbmi	r5, {r2, r3, r5, sp}^
    9ff0:	00505247 	subseq	r5, r0, r7, asr #4
    9ff4:	3a564544 	bcc	159b50c <__bss_end+0x15911d0>
    9ff8:	64656c6f 	strbtvs	r6, [r5], #-3183	; 0xfffff391
    9ffc:	00000000 	andeq	r0, r0, r0
    a000:	3a564544 	bcc	159b518 <__bss_end+0x15911dc>
    a004:	74726175 	ldrbtvc	r6, [r2], #-373	; 0xfffffe8b
    a008:	0000302f 	andeq	r3, r0, pc, lsr #32
    a00c:	636c6143 	cmnvs	ip, #-1073741808	; 0xc0000010
    a010:	7620534f 	strtvc	r5, [r0], -pc, asr #6
    a014:	0a312e31 	beq	c558e0 <__bss_end+0xc4b5a4>
    a018:	00000000 	andeq	r0, r0, r0

0000a01c <_ZL13Lock_Unlocked>:
    a01c:	00000000 	andeq	r0, r0, r0

0000a020 <_ZL11Lock_Locked>:
    a020:	00000001 	andeq	r0, r0, r1

0000a024 <_ZL21MaxFSDriverNameLength>:
    a024:	00000010 	andeq	r0, r0, r0, lsl r0

0000a028 <_ZL17MaxFilenameLength>:
    a028:	00000010 	andeq	r0, r0, r0, lsl r0

0000a02c <_ZL13MaxPathLength>:
    a02c:	00000080 	andeq	r0, r0, r0, lsl #1

0000a030 <_ZL18NoFilesystemDriver>:
    a030:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000a034 <_ZL9NotifyAll>:
    a034:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000a038 <_ZL24Max_Process_Opened_Files>:
    a038:	00000010 	andeq	r0, r0, r0, lsl r0

0000a03c <_ZL10Indefinite>:
    a03c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000a040 <_ZL18Deadline_Unchanged>:
    a040:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

0000a044 <_ZL14Invalid_Handle>:
    a044:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000a048 <_ZL16Pipe_File_Prefix>:
    a048:	3a535953 	bcc	14e059c <__bss_end+0x14d6260>
    a04c:	65706970 	ldrbvs	r6, [r0, #-2416]!	; 0xfffff690
    a050:	0000002f 	andeq	r0, r0, pc, lsr #32

0000a054 <_ZN12_GLOBAL__N_1L11CharConvArrE>:
    a054:	33323130 	teqcc	r2, #48, 2
    a058:	37363534 			; <UNDEFINED> instruction: 0x37363534
    a05c:	42413938 	submi	r3, r1, #56, 18	; 0xe0000
    a060:	46454443 	strbmi	r4, [r5], -r3, asr #8
    a064:	00000000 	andeq	r0, r0, r0

0000a068 <_ZL13Lock_Unlocked>:
    a068:	00000000 	andeq	r0, r0, r0

0000a06c <_ZL11Lock_Locked>:
    a06c:	00000001 	andeq	r0, r0, r1

0000a070 <_ZL21MaxFSDriverNameLength>:
    a070:	00000010 	andeq	r0, r0, r0, lsl r0

0000a074 <_ZL17MaxFilenameLength>:
    a074:	00000010 	andeq	r0, r0, r0, lsl r0

0000a078 <_ZL13MaxPathLength>:
    a078:	00000080 	andeq	r0, r0, r0, lsl #1

0000a07c <_ZL18NoFilesystemDriver>:
    a07c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000a080 <_ZL9NotifyAll>:
    a080:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000a084 <_ZL24Max_Process_Opened_Files>:
    a084:	00000010 	andeq	r0, r0, r0, lsl r0

0000a088 <_ZL10Indefinite>:
    a088:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000a08c <_ZL18Deadline_Unchanged>:
    a08c:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

0000a090 <_ZL14Invalid_Handle>:
    a090:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000a094 <_ZN3halL18Default_Clock_RateE>:
    a094:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}

0000a098 <_ZN3halL15Peripheral_BaseE>:
    a098:	20000000 	andcs	r0, r0, r0

0000a09c <_ZN3halL9GPIO_BaseE>:
    a09c:	20200000 	eorcs	r0, r0, r0

0000a0a0 <_ZN3halL14GPIO_Pin_CountE>:
    a0a0:	00000036 	andeq	r0, r0, r6, lsr r0

0000a0a4 <_ZN3halL8AUX_BaseE>:
    a0a4:	20215000 	eorcs	r5, r1, r0

0000a0a8 <_ZN3halL25Interrupt_Controller_BaseE>:
    a0a8:	2000b200 	andcs	fp, r0, r0, lsl #4

0000a0ac <_ZN3halL10Timer_BaseE>:
    a0ac:	2000b400 	andcs	fp, r0, r0, lsl #8

0000a0b0 <_ZN3halL17System_Timer_BaseE>:
    a0b0:	20003000 	andcs	r3, r0, r0

0000a0b4 <_ZN3halL9TRNG_BaseE>:
    a0b4:	20104000 	andscs	r4, r0, r0

0000a0b8 <_ZN3halL9BSC0_BaseE>:
    a0b8:	20205000 	eorcs	r5, r0, r0

0000a0bc <_ZN3halL9BSC1_BaseE>:
    a0bc:	20804000 	addcs	r4, r0, r0

0000a0c0 <_ZN3halL9BSC2_BaseE>:
    a0c0:	20805000 	addcs	r5, r0, r0

0000a0c4 <_ZN9OLED_FontL10Char_WidthE>:
    a0c4:	 	andeq	r0, r8, r6

0000a0c6 <_ZN9OLED_FontL11Char_HeightE>:
    a0c6:	 	eoreq	r0, r0, r8

0000a0c8 <_ZN9OLED_FontL10Char_BeginE>:
    a0c8:	 	addeq	r0, r0, r0, lsr #32

0000a0ca <_ZN9OLED_FontL8Char_EndE>:
    a0ca:	 	andeq	r0, r1, r0, lsl #1

0000a0cc <_ZN9OLED_FontL10Flip_CharsE>:
    a0cc:	00000001 	andeq	r0, r0, r1

0000a0d0 <_ZN9OLED_FontL17OLED_Font_DefaultE>:
	...
    a0d8:	00002f00 	andeq	r2, r0, r0, lsl #30
    a0dc:	00070000 	andeq	r0, r7, r0
    a0e0:	14000007 	strne	r0, [r0], #-7
    a0e4:	147f147f 	ldrbtne	r1, [pc], #-1151	; a0ec <_ZN9OLED_FontL17OLED_Font_DefaultE+0x1c>
    a0e8:	7f2a2400 	svcvc	0x002a2400
    a0ec:	2300122a 	movwcs	r1, #554	; 0x22a
    a0f0:	62640813 	rsbvs	r0, r4, #1245184	; 0x130000
    a0f4:	55493600 	strbpl	r3, [r9, #-1536]	; 0xfffffa00
    a0f8:	00005022 	andeq	r5, r0, r2, lsr #32
    a0fc:	00000305 	andeq	r0, r0, r5, lsl #6
    a100:	221c0000 	andscs	r0, ip, #0
    a104:	00000041 	andeq	r0, r0, r1, asr #32
    a108:	001c2241 	andseq	r2, ip, r1, asr #4
    a10c:	3e081400 	cfcpyscc	mvf1, mvf8
    a110:	08001408 	stmdaeq	r0, {r3, sl, ip}
    a114:	08083e08 	stmdaeq	r8, {r3, r9, sl, fp, ip, sp}
    a118:	a0000000 	andge	r0, r0, r0
    a11c:	08000060 	stmdaeq	r0, {r5, r6}
    a120:	08080808 	stmdaeq	r8, {r3, fp}
    a124:	60600000 	rsbvs	r0, r0, r0
    a128:	20000000 	andcs	r0, r0, r0
    a12c:	02040810 	andeq	r0, r4, #16, 16	; 0x100000
    a130:	49513e00 	ldmdbmi	r1, {r9, sl, fp, ip, sp}^
    a134:	00003e45 	andeq	r3, r0, r5, asr #28
    a138:	00407f42 	subeq	r7, r0, r2, asr #30
    a13c:	51614200 	cmnpl	r1, r0, lsl #4
    a140:	21004649 	tstcs	r0, r9, asr #12
    a144:	314b4541 	cmpcc	fp, r1, asr #10
    a148:	12141800 	andsne	r1, r4, #0, 16
    a14c:	2700107f 	smlsdxcs	r0, pc, r0, r1	; <UNPREDICTABLE>
    a150:	39454545 	stmdbcc	r5, {r0, r2, r6, r8, sl, lr}^
    a154:	494a3c00 	stmdbmi	sl, {sl, fp, ip, sp}^
    a158:	01003049 	tsteq	r0, r9, asr #32
    a15c:	03050971 	movweq	r0, #22897	; 0x5971
    a160:	49493600 	stmdbmi	r9, {r9, sl, ip, sp}^
    a164:	06003649 	streq	r3, [r0], -r9, asr #12
    a168:	1e294949 	vnmulne.f16	s8, s18, s18	; <UNPREDICTABLE>
    a16c:	36360000 	ldrtcc	r0, [r6], -r0
    a170:	00000000 	andeq	r0, r0, r0
    a174:	00003656 	andeq	r3, r0, r6, asr r6
    a178:	22140800 	andscs	r0, r4, #0, 16
    a17c:	14000041 	strne	r0, [r0], #-65	; 0xffffffbf
    a180:	14141414 	ldrne	r1, [r4], #-1044	; 0xfffffbec
    a184:	22410000 	subcs	r0, r1, #0
    a188:	02000814 	andeq	r0, r0, #20, 16	; 0x140000
    a18c:	06095101 	streq	r5, [r9], -r1, lsl #2
    a190:	59493200 	stmdbpl	r9, {r9, ip, sp}^
    a194:	7c003e51 	stcvc	14, cr3, [r0], {81}	; 0x51
    a198:	7c121112 	ldfvcs	f1, [r2], {18}
    a19c:	49497f00 	stmdbmi	r9, {r8, r9, sl, fp, ip, sp, lr}^
    a1a0:	3e003649 	cfmadd32cc	mvax2, mvfx3, mvfx0, mvfx9
    a1a4:	22414141 	subcs	r4, r1, #1073741840	; 0x40000010
    a1a8:	41417f00 	cmpmi	r1, r0, lsl #30
    a1ac:	7f001c22 	svcvc	0x00001c22
    a1b0:	41494949 	cmpmi	r9, r9, asr #18
    a1b4:	09097f00 	stmdbeq	r9, {r8, r9, sl, fp, ip, sp, lr}
    a1b8:	3e000109 	adfccs	f0, f0, #1.0
    a1bc:	7a494941 	bvc	125c6c8 <__bss_end+0x125238c>
    a1c0:	08087f00 	stmdaeq	r8, {r8, r9, sl, fp, ip, sp, lr}
    a1c4:	00007f08 	andeq	r7, r0, r8, lsl #30
    a1c8:	00417f41 	subeq	r7, r1, r1, asr #30
    a1cc:	41402000 	mrsmi	r2, (UNDEF: 64)
    a1d0:	7f00013f 	svcvc	0x0000013f
    a1d4:	41221408 			; <UNDEFINED> instruction: 0x41221408
    a1d8:	40407f00 	submi	r7, r0, r0, lsl #30
    a1dc:	7f004040 	svcvc	0x00004040
    a1e0:	7f020c02 	svcvc	0x00020c02
    a1e4:	08047f00 	stmdaeq	r4, {r8, r9, sl, fp, ip, sp, lr}
    a1e8:	3e007f10 	mcrcc	15, 0, r7, cr0, cr0, {0}
    a1ec:	3e414141 	dvfccsm	f4, f1, f1
    a1f0:	09097f00 	stmdbeq	r9, {r8, r9, sl, fp, ip, sp, lr}
    a1f4:	3e000609 	cfmadd32cc	mvax0, mvfx0, mvfx0, mvfx9
    a1f8:	5e215141 	sufplsm	f5, f1, f1
    a1fc:	19097f00 	stmdbne	r9, {r8, r9, sl, fp, ip, sp, lr}
    a200:	46004629 	strmi	r4, [r0], -r9, lsr #12
    a204:	31494949 	cmpcc	r9, r9, asr #18
    a208:	7f010100 	svcvc	0x00010100
    a20c:	3f000101 	svccc	0x00000101
    a210:	3f404040 	svccc	0x00404040
    a214:	40201f00 	eormi	r1, r0, r0, lsl #30
    a218:	3f001f20 	svccc	0x00001f20
    a21c:	3f403840 	svccc	0x00403840
    a220:	08146300 	ldmdaeq	r4, {r8, r9, sp, lr}
    a224:	07006314 	smladeq	r0, r4, r3, r6
    a228:	07087008 	streq	r7, [r8, -r8]
    a22c:	49516100 	ldmdbmi	r1, {r8, sp, lr}^
    a230:	00004345 	andeq	r4, r0, r5, asr #6
    a234:	0041417f 	subeq	r4, r1, pc, ror r1
    a238:	552a5500 	strpl	r5, [sl, #-1280]!	; 0xfffffb00
    a23c:	0000552a 	andeq	r5, r0, sl, lsr #10
    a240:	007f4141 	rsbseq	r4, pc, r1, asr #2
    a244:	01020400 	tsteq	r2, r0, lsl #8
    a248:	40000402 	andmi	r0, r0, r2, lsl #8
    a24c:	40404040 	submi	r4, r0, r0, asr #32
    a250:	02010000 	andeq	r0, r1, #0
    a254:	20000004 	andcs	r0, r0, r4
    a258:	78545454 	ldmdavc	r4, {r2, r4, r6, sl, ip, lr}^
    a25c:	44487f00 	strbmi	r7, [r8], #-3840	; 0xfffff100
    a260:	38003844 	stmdacc	r0, {r2, r6, fp, ip, sp}
    a264:	20444444 	subcs	r4, r4, r4, asr #8
    a268:	44443800 	strbmi	r3, [r4], #-2048	; 0xfffff800
    a26c:	38007f48 	stmdacc	r0, {r3, r6, r8, r9, sl, fp, ip, sp, lr}
    a270:	18545454 	ldmdane	r4, {r2, r4, r6, sl, ip, lr}^
    a274:	097e0800 	ldmdbeq	lr!, {fp}^
    a278:	18000201 	stmdane	r0, {r0, r9}
    a27c:	7ca4a4a4 	cfstrsvc	mvf10, [r4], #656	; 0x290
    a280:	04087f00 	streq	r7, [r8], #-3840	; 0xfffff100
    a284:	00007804 	andeq	r7, r0, r4, lsl #16
    a288:	00407d44 	subeq	r7, r0, r4, asr #26
    a28c:	84804000 	strhi	r4, [r0], #0
    a290:	7f00007d 	svcvc	0x0000007d
    a294:	00442810 	subeq	r2, r4, r0, lsl r8
    a298:	7f410000 	svcvc	0x00410000
    a29c:	7c000040 	stcvc	0, cr0, [r0], {64}	; 0x40
    a2a0:	78041804 	stmdavc	r4, {r2, fp, ip}
    a2a4:	04087c00 	streq	r7, [r8], #-3072	; 0xfffff400
    a2a8:	38007804 	stmdacc	r0, {r2, fp, ip, sp, lr}
    a2ac:	38444444 	stmdacc	r4, {r2, r6, sl, lr}^
    a2b0:	2424fc00 	strtcs	pc, [r4], #-3072	; 0xfffff400
    a2b4:	18001824 	stmdane	r0, {r2, r5, fp, ip}
    a2b8:	fc182424 	ldc2	4, cr2, [r8], {36}	; 0x24
    a2bc:	04087c00 	streq	r7, [r8], #-3072	; 0xfffff400
    a2c0:	48000804 	stmdami	r0, {r2, fp}
    a2c4:	20545454 	subscs	r5, r4, r4, asr r4
    a2c8:	443f0400 	ldrtmi	r0, [pc], #-1024	; a2d0 <_ZN9OLED_FontL17OLED_Font_DefaultE+0x200>
    a2cc:	3c002040 	stccc	0, cr2, [r0], {64}	; 0x40
    a2d0:	7c204040 	stcvc	0, cr4, [r0], #-256	; 0xffffff00
    a2d4:	40201c00 	eormi	r1, r0, r0, lsl #24
    a2d8:	3c001c20 	stccc	12, cr1, [r0], {32}
    a2dc:	3c403040 	mcrrcc	0, 4, r3, r0, cr0
    a2e0:	10284400 	eorne	r4, r8, r0, lsl #8
    a2e4:	1c004428 	cfstrsne	mvf4, [r0], {40}	; 0x28
    a2e8:	7ca0a0a0 	stcvc	0, cr10, [r0], #640	; 0x280
    a2ec:	54644400 	strbtpl	r4, [r4], #-1024	; 0xfffffc00
    a2f0:	0000444c 	andeq	r4, r0, ip, asr #8
    a2f4:	00007708 	andeq	r7, r0, r8, lsl #14
    a2f8:	7f000000 	svcvc	0x00000000
    a2fc:	00000000 	andeq	r0, r0, r0
    a300:	00000877 	andeq	r0, r0, r7, ror r8
    a304:	10081000 	andne	r1, r8, r0
    a308:	00000008 	andeq	r0, r0, r8
    a30c:	00000000 	andeq	r0, r0, r0

Disassembly of section .ARM.exidx:

0000a310 <.ARM.exidx>:
    a310:	7ffffad8 	svcvc	0x00fffad8
    a314:	00000001 	andeq	r0, r0, r1

Disassembly of section .data:

0000a318 <messages>:
__DTOR_END__():
    a318:	00009f68 	andeq	r9, r0, r8, ror #30
    a31c:	00009f84 	andeq	r9, r0, r4, lsl #31
    a320:	00009f98 	muleq	r0, r8, pc	; <UNPREDICTABLE>
    a324:	00009fb0 			; <UNDEFINED> instruction: 0x00009fb0
    a328:	00009fd4 	ldrdeq	r9, [r0], -r4

Disassembly of section .bss:

0000a32c <__bss_start>:
	...

Disassembly of section .ARM.attributes:

00000000 <.ARM.attributes>:
   0:	00002e41 	andeq	r2, r0, r1, asr #28
   4:	61656100 	cmnvs	r5, r0, lsl #2
   8:	01006962 	tsteq	r0, r2, ror #18
   c:	00000024 	andeq	r0, r0, r4, lsr #32
  10:	4b5a3605 	blmi	168d82c <__bss_end+0x16834f0>
  14:	08070600 	stmdaeq	r7, {r9, sl}
  18:	0a010901 	beq	42424 <__bss_end+0x380e8>
  1c:	14041202 	strne	r1, [r4], #-514	; 0xfffffdfe
  20:	17011501 	strne	r1, [r1, -r1, lsl #10]
  24:	1a011803 	bne	46038 <__bss_end+0x3bcfc>
  28:	22011c01 	andcs	r1, r1, #256	; 0x100
  2c:	Address 0x000000000000002c is out of bounds.


Disassembly of section .comment:

00000000 <.comment>:
   0:	3a434347 	bcc	10d0d24 <__bss_end+0x10c69e8>
   4:	35312820 	ldrcc	r2, [r1, #-2080]!	; 0xfffff7e0
   8:	2e30313a 	mrccs	1, 1, r3, cr0, cr10, {1}
   c:	30322d33 	eorscc	r2, r2, r3, lsr sp
  10:	302e3132 	eorcc	r3, lr, r2, lsr r1
  14:	29342d37 	ldmdbcs	r4!, {r0, r1, r2, r4, r5, r8, sl, fp, sp}
  18:	2e303120 	rsfcssp	f3, f0, f0
  1c:	20312e33 	eorscs	r2, r1, r3, lsr lr
  20:	31323032 	teqcc	r2, r2, lsr r0
  24:	31323630 	teqcc	r2, r0, lsr r6
  28:	65722820 	ldrbvs	r2, [r2, #-2080]!	; 0xfffff7e0
  2c:	7361656c 	cmnvc	r1, #108, 10	; 0x1b000000
  30:	Address 0x0000000000000030 is out of bounds.


Disassembly of section .debug_line:

00000000 <.debug_line>:
       0:	00000056 	andeq	r0, r0, r6, asr r0
       4:	00400003 	subeq	r0, r0, r3
       8:	01020000 	mrseq	r0, (UNDEF: 2)
       c:	000d0efb 	strdeq	r0, [sp], -fp
      10:	01010101 	tsteq	r1, r1, lsl #2
      14:	01000000 	mrseq	r0, (UNDEF: 0)
      18:	2f010000 	svccs	0x00010000
      1c:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
      20:	6572742f 	ldrbvs	r7, [r2, #-1071]!	; 0xfffffbd1
      24:	2f6c6966 	svccs	0x006c6966
      28:	2f6d6573 	svccs	0x006d6573
      2c:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
      30:	2f736563 	svccs	0x00736563
      34:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
      38:	63617073 	cmnvs	r1, #115	; 0x73
      3c:	63000065 	movwvs	r0, #101	; 0x65
      40:	2e307472 	mrccs	4, 1, r7, cr0, cr2, {3}
      44:	00010073 	andeq	r0, r1, r3, ror r0
      48:	05000000 	streq	r0, [r0, #-0]
      4c:	00800002 	addeq	r0, r0, r2
      50:	01090300 	mrseq	r0, (UNDEF: 57)
      54:	00020231 	andeq	r0, r2, r1, lsr r2
      58:	00850101 	addeq	r0, r5, r1, lsl #2
      5c:	00030000 	andeq	r0, r3, r0
      60:	00000040 	andeq	r0, r0, r0, asr #32
      64:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
      68:	0101000d 	tsteq	r1, sp
      6c:	00000101 	andeq	r0, r0, r1, lsl #2
      70:	00000100 	andeq	r0, r0, r0, lsl #2
      74:	6f682f01 	svcvs	0x00682f01
      78:	742f656d 	strtvc	r6, [pc], #-1389	; 80 <shift+0x80>
      7c:	69666572 	stmdbvs	r6!, {r1, r4, r5, r6, r8, sl, sp, lr}^
      80:	65732f6c 	ldrbvs	r2, [r3, #-3948]!	; 0xfffff094
      84:	6f732f6d 	svcvs	0x00732f6d
      88:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
      8c:	73752f73 	cmnvc	r5, #460	; 0x1cc
      90:	70737265 	rsbsvc	r7, r3, r5, ror #4
      94:	00656361 	rsbeq	r6, r5, r1, ror #6
      98:	74726300 	ldrbtvc	r6, [r2], #-768	; 0xfffffd00
      9c:	00632e30 	rsbeq	r2, r3, r0, lsr lr
      a0:	00000001 	andeq	r0, r0, r1
      a4:	05000105 	streq	r0, [r0, #-261]	; 0xfffffefb
      a8:	00800802 	addeq	r0, r0, r2, lsl #16
      ac:	01090300 	mrseq	r0, (UNDEF: 57)
      b0:	05671805 	strbeq	r1, [r7, #-2053]!	; 0xfffff7fb
      b4:	0e054a05 	vmlaeq.f32	s8, s10, s10
      b8:	03040200 	movweq	r0, #16896	; 0x4200
      bc:	0041052f 	subeq	r0, r1, pc, lsr #10
      c0:	65030402 	strvs	r0, [r3, #-1026]	; 0xfffffbfe
      c4:	02000505 	andeq	r0, r0, #20971520	; 0x1400000
      c8:	05660104 	strbeq	r0, [r6, #-260]!	; 0xfffffefc
      cc:	05d98401 	ldrbeq	r8, [r9, #1025]	; 0x401
      d0:	05316805 	ldreq	r6, [r1, #-2053]!	; 0xfffff7fb
      d4:	05053312 	streq	r3, [r5, #-786]	; 0xfffffcee
      d8:	054b3185 	strbeq	r3, [fp, #-389]	; 0xfffffe7b
      dc:	06022f01 	streq	r2, [r2], -r1, lsl #30
      e0:	db010100 	blle	404e8 <__bss_end+0x361ac>
      e4:	03000000 	movweq	r0, #0
      e8:	00005200 	andeq	r5, r0, r0, lsl #4
      ec:	fb010200 	blx	408f6 <__bss_end+0x365ba>
      f0:	01000d0e 	tsteq	r0, lr, lsl #26
      f4:	00010101 	andeq	r0, r1, r1, lsl #2
      f8:	00010000 	andeq	r0, r1, r0
      fc:	682f0100 	stmdavs	pc!, {r8}	; <UNPREDICTABLE>
     100:	2f656d6f 	svccs	0x00656d6f
     104:	66657274 			; <UNDEFINED> instruction: 0x66657274
     108:	732f6c69 			; <UNDEFINED> instruction: 0x732f6c69
     10c:	732f6d65 			; <UNDEFINED> instruction: 0x732f6d65
     110:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
     114:	752f7365 	strvc	r7, [pc, #-869]!	; fffffdb7 <__bss_end+0xffff5a7b>
     118:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
     11c:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
     120:	78630000 	stmdavc	r3!, {}^	; <UNPREDICTABLE>
     124:	69626178 	stmdbvs	r2!, {r3, r4, r5, r6, r8, sp, lr}^
     128:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
     12c:	00000100 	andeq	r0, r0, r0, lsl #2
     130:	6975623c 	ldmdbvs	r5!, {r2, r3, r4, r5, r9, sp, lr}^
     134:	692d746c 	pushvs	{r2, r3, r5, r6, sl, ip, sp, lr}
     138:	00003e6e 	andeq	r3, r0, lr, ror #28
     13c:	05000000 	streq	r0, [r0, #-0]
     140:	02050002 	andeq	r0, r5, #2
     144:	000080a4 	andeq	r8, r0, r4, lsr #1
     148:	05010a03 	streq	r0, [r1, #-2563]	; 0xfffff5fd
     14c:	0a05830b 	beq	160d80 <__bss_end+0x156a44>
     150:	8302054a 	movwhi	r0, #9546	; 0x254a
     154:	830e0585 	movwhi	r0, #58757	; 0xe585
     158:	85670205 	strbhi	r0, [r7, #-517]!	; 0xfffffdfb
     15c:	86010584 	strhi	r0, [r1], -r4, lsl #11
     160:	854c854c 	strbhi	r8, [ip, #-1356]	; 0xfffffab4
     164:	0205854c 	andeq	r8, r5, #76, 10	; 0x13000000
     168:	01040200 	mrseq	r0, R12_usr
     16c:	0301054b 	movweq	r0, #5451	; 0x154b
     170:	0d052e12 	stceq	14, cr2, [r5, #-72]	; 0xffffffb8
     174:	0024056b 	eoreq	r0, r4, fp, ror #10
     178:	4a030402 	bmi	c1188 <__bss_end+0xb6e4c>
     17c:	02000405 	andeq	r0, r0, #83886080	; 0x5000000
     180:	05830204 	streq	r0, [r3, #516]	; 0x204
     184:	0402000b 	streq	r0, [r2], #-11
     188:	02054a02 	andeq	r4, r5, #8192	; 0x2000
     18c:	02040200 	andeq	r0, r4, #0, 4
     190:	8509052d 	strhi	r0, [r9, #-1325]	; 0xfffffad3
     194:	a12f0105 			; <UNDEFINED> instruction: 0xa12f0105
     198:	056a0d05 	strbeq	r0, [sl, #-3333]!	; 0xfffff2fb
     19c:	04020024 	streq	r0, [r2], #-36	; 0xffffffdc
     1a0:	04054a03 	streq	r4, [r5], #-2563	; 0xfffff5fd
     1a4:	02040200 	andeq	r0, r4, #0, 4
     1a8:	000b0583 	andeq	r0, fp, r3, lsl #11
     1ac:	4a020402 	bmi	811bc <__bss_end+0x76e80>
     1b0:	02000205 	andeq	r0, r0, #1342177280	; 0x50000000
     1b4:	052d0204 	streq	r0, [sp, #-516]!	; 0xfffffdfc
     1b8:	01058509 	tsteq	r5, r9, lsl #10
     1bc:	000a022f 	andeq	r0, sl, pc, lsr #4
     1c0:	022c0101 	eoreq	r0, ip, #1073741824	; 0x40000000
     1c4:	00030000 	andeq	r0, r3, r0
     1c8:	000001f3 	strdeq	r0, [r0], -r3
     1cc:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
     1d0:	0101000d 	tsteq	r1, sp
     1d4:	00000101 	andeq	r0, r0, r1, lsl #2
     1d8:	00000100 	andeq	r0, r0, r0, lsl #2
     1dc:	6f682f01 	svcvs	0x00682f01
     1e0:	742f656d 	strtvc	r6, [pc], #-1389	; 1e8 <shift+0x1e8>
     1e4:	69666572 	stmdbvs	r6!, {r1, r4, r5, r6, r8, sl, sp, lr}^
     1e8:	65732f6c 	ldrbvs	r2, [r3, #-3948]!	; 0xfffff094
     1ec:	6f732f6d 	svcvs	0x00732f6d
     1f0:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
     1f4:	73752f73 	cmnvc	r5, #460	; 0x1cc
     1f8:	70737265 	rsbsvc	r7, r3, r5, ror #4
     1fc:	2f656361 	svccs	0x00656361
     200:	64656c6f 	strbtvs	r6, [r5], #-3183	; 0xfffff391
     204:	7361745f 	cmnvc	r1, #1593835520	; 0x5f000000
     208:	682f006b 	stmdavs	pc!, {r0, r1, r3, r5, r6}	; <UNPREDICTABLE>
     20c:	2f656d6f 	svccs	0x00656d6f
     210:	66657274 			; <UNDEFINED> instruction: 0x66657274
     214:	732f6c69 			; <UNDEFINED> instruction: 0x732f6c69
     218:	732f6d65 			; <UNDEFINED> instruction: 0x732f6d65
     21c:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
     220:	752f7365 	strvc	r7, [pc, #-869]!	; fffffec3 <__bss_end+0xffff5b87>
     224:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
     228:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
     22c:	2f2e2e2f 	svccs	0x002e2e2f
     230:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
     234:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
     238:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
     23c:	622f6564 	eorvs	r6, pc, #100, 10	; 0x19000000
     240:	6472616f 	ldrbtvs	r6, [r2], #-367	; 0xfffffe91
     244:	6970722f 	ldmdbvs	r0!, {r0, r1, r2, r3, r5, r9, ip, sp, lr}^
     248:	61682f30 	cmnvs	r8, r0, lsr pc
     24c:	682f006c 	stmdavs	pc!, {r2, r3, r5, r6}	; <UNPREDICTABLE>
     250:	2f656d6f 	svccs	0x00656d6f
     254:	66657274 			; <UNDEFINED> instruction: 0x66657274
     258:	732f6c69 			; <UNDEFINED> instruction: 0x732f6c69
     25c:	732f6d65 			; <UNDEFINED> instruction: 0x732f6d65
     260:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
     264:	752f7365 	strvc	r7, [pc, #-869]!	; ffffff07 <__bss_end+0xffff5bcb>
     268:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
     26c:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
     270:	2f2e2e2f 	svccs	0x002e2e2f
     274:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
     278:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
     27c:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
     280:	702f6564 	eorvc	r6, pc, r4, ror #10
     284:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     288:	2f007373 	svccs	0x00007373
     28c:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
     290:	6572742f 	ldrbvs	r7, [r2, #-1071]!	; 0xfffffbd1
     294:	2f6c6966 	svccs	0x006c6966
     298:	2f6d6573 	svccs	0x006d6573
     29c:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
     2a0:	2f736563 	svccs	0x00736563
     2a4:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
     2a8:	63617073 	cmnvs	r1, #115	; 0x73
     2ac:	2e2e2f65 	cdpcs	15, 2, cr2, cr14, cr5, {3}
     2b0:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
     2b4:	2f6c656e 	svccs	0x006c656e
     2b8:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
     2bc:	2f656475 	svccs	0x00656475
     2c0:	2f007366 	svccs	0x00007366
     2c4:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
     2c8:	6572742f 	ldrbvs	r7, [r2, #-1071]!	; 0xfffffbd1
     2cc:	2f6c6966 	svccs	0x006c6966
     2d0:	2f6d6573 	svccs	0x006d6573
     2d4:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
     2d8:	2f736563 	svccs	0x00736563
     2dc:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
     2e0:	63617073 	cmnvs	r1, #115	; 0x73
     2e4:	2e2e2f65 	cdpcs	15, 2, cr2, cr14, cr5, {3}
     2e8:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
     2ec:	6c697475 	cfstrdvs	mvd7, [r9], #-468	; 0xfffffe2c
     2f0:	6e692f73 	mcrvs	15, 3, r2, cr9, cr3, {3}
     2f4:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
     2f8:	682f0065 	stmdavs	pc!, {r0, r2, r5, r6}	; <UNPREDICTABLE>
     2fc:	2f656d6f 	svccs	0x00656d6f
     300:	66657274 			; <UNDEFINED> instruction: 0x66657274
     304:	732f6c69 			; <UNDEFINED> instruction: 0x732f6c69
     308:	732f6d65 			; <UNDEFINED> instruction: 0x732f6d65
     30c:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
     310:	752f7365 	strvc	r7, [pc, #-869]!	; ffffffb3 <__bss_end+0xffff5c77>
     314:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
     318:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
     31c:	2f2e2e2f 	svccs	0x002e2e2f
     320:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
     324:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
     328:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
     32c:	642f6564 	strtvs	r6, [pc], #-1380	; 334 <shift+0x334>
     330:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
     334:	00007372 	andeq	r7, r0, r2, ror r3
     338:	6e69616d 	powvsez	f6, f1, #5.0
     33c:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
     340:	00000100 	andeq	r0, r0, r0, lsl #2
     344:	64746e69 	ldrbtvs	r6, [r4], #-3689	; 0xfffff197
     348:	682e6665 	stmdavs	lr!, {r0, r2, r5, r6, r9, sl, sp, lr}
     34c:	00000200 	andeq	r0, r0, r0, lsl #4
     350:	2e697773 	mcrcs	7, 3, r7, cr9, cr3, {3}
     354:	00030068 	andeq	r0, r3, r8, rrx
     358:	69707300 	ldmdbvs	r0!, {r8, r9, ip, sp, lr}^
     35c:	636f6c6e 	cmnvs	pc, #28160	; 0x6e00
     360:	00682e6b 	rsbeq	r2, r8, fp, ror #28
     364:	66000003 	strvs	r0, [r0], -r3
     368:	73656c69 	cmnvc	r5, #26880	; 0x6900
     36c:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     370:	00682e6d 	rsbeq	r2, r8, sp, ror #28
     374:	70000004 	andvc	r0, r0, r4
     378:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     37c:	682e7373 	stmdavs	lr!, {r0, r1, r4, r5, r6, r8, r9, ip, sp, lr}
     380:	00000300 	andeq	r0, r0, r0, lsl #6
     384:	636f7270 	cmnvs	pc, #112, 4
     388:	5f737365 	svcpl	0x00737365
     38c:	616e616d 	cmnvs	lr, sp, ror #2
     390:	2e726567 	cdpcs	5, 7, cr6, cr2, cr7, {3}
     394:	00030068 	andeq	r0, r3, r8, rrx
     398:	656c6f00 	strbvs	r6, [ip, #-3840]!	; 0xfffff100
     39c:	00682e64 	rsbeq	r2, r8, r4, ror #28
     3a0:	70000005 	andvc	r0, r0, r5
     3a4:	70697265 	rsbvc	r7, r9, r5, ror #4
     3a8:	61726568 	cmnvs	r2, r8, ror #10
     3ac:	682e736c 	stmdavs	lr!, {r2, r3, r5, r6, r8, r9, ip, sp, lr}
     3b0:	00000200 	andeq	r0, r0, r0, lsl #4
     3b4:	6f697067 	svcvs	0x00697067
     3b8:	0600682e 	streq	r6, [r0], -lr, lsr #16
     3bc:	05000000 	streq	r0, [r0, #-0]
     3c0:	02050001 	andeq	r0, r5, #1
     3c4:	0000822c 	andeq	r8, r0, ip, lsr #4
     3c8:	05011803 	streq	r1, [r1, #-2051]	; 0xfffff7fd
     3cc:	0a059f1f 	beq	168050 <__bss_end+0x15dd14>
     3d0:	83010566 	movwhi	r0, #5478	; 0x1566
     3d4:	9f220569 	svcls	0x00220569
     3d8:	05831e05 	streq	r1, [r3, #3589]	; 0xe05
     3dc:	0c05830a 	stceq	3, cr8, [r5], {10}
     3e0:	05661b03 	strbeq	r1, [r6, #-2819]!	; 0xfffff4fd
     3e4:	2e630322 	cdpcs	3, 6, cr0, cr3, cr2, {1}
     3e8:	1e030105 	adfnes	f0, f3, f5
     3ec:	000e0266 	andeq	r0, lr, r6, ror #4
     3f0:	02180101 	andseq	r0, r8, #1073741824	; 0x40000000
     3f4:	00030000 	andeq	r0, r3, r0
     3f8:	0000012d 	andeq	r0, r0, sp, lsr #2
     3fc:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
     400:	0101000d 	tsteq	r1, sp
     404:	00000101 	andeq	r0, r0, r1, lsl #2
     408:	00000100 	andeq	r0, r0, r0, lsl #2
     40c:	6f682f01 	svcvs	0x00682f01
     410:	742f656d 	strtvc	r6, [pc], #-1389	; 418 <shift+0x418>
     414:	69666572 	stmdbvs	r6!, {r1, r4, r5, r6, r8, sl, sp, lr}^
     418:	65732f6c 	ldrbvs	r2, [r3, #-3948]!	; 0xfffff094
     41c:	6f732f6d 	svcvs	0x00732f6d
     420:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
     424:	74732f73 	ldrbtvc	r2, [r3], #-3955	; 0xfffff08d
     428:	62696c64 	rsbvs	r6, r9, #100, 24	; 0x6400
     42c:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
     430:	6f682f00 	svcvs	0x00682f00
     434:	742f656d 	strtvc	r6, [pc], #-1389	; 43c <shift+0x43c>
     438:	69666572 	stmdbvs	r6!, {r1, r4, r5, r6, r8, sl, sp, lr}^
     43c:	65732f6c 	ldrbvs	r2, [r3, #-3948]!	; 0xfffff094
     440:	6f732f6d 	svcvs	0x00732f6d
     444:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
     448:	656b2f73 	strbvs	r2, [fp, #-3955]!	; 0xfffff08d
     44c:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
     450:	636e692f 	cmnvs	lr, #770048	; 0xbc000
     454:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
     458:	6f72702f 	svcvs	0x0072702f
     45c:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     460:	6f682f00 	svcvs	0x00682f00
     464:	742f656d 	strtvc	r6, [pc], #-1389	; 46c <shift+0x46c>
     468:	69666572 	stmdbvs	r6!, {r1, r4, r5, r6, r8, sl, sp, lr}^
     46c:	65732f6c 	ldrbvs	r2, [r3, #-3948]!	; 0xfffff094
     470:	6f732f6d 	svcvs	0x00732f6d
     474:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
     478:	656b2f73 	strbvs	r2, [fp, #-3955]!	; 0xfffff08d
     47c:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
     480:	636e692f 	cmnvs	lr, #770048	; 0xbc000
     484:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
     488:	0073662f 	rsbseq	r6, r3, pc, lsr #12
     48c:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 3d8 <shift+0x3d8>
     490:	72742f65 	rsbsvc	r2, r4, #404	; 0x194
     494:	6c696665 	stclvs	6, cr6, [r9], #-404	; 0xfffffe6c
     498:	6d65732f 	stclvs	3, cr7, [r5, #-188]!	; 0xffffff44
     49c:	756f732f 	strbvc	r7, [pc, #-815]!	; 175 <shift+0x175>
     4a0:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
     4a4:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
     4a8:	2f6c656e 	svccs	0x006c656e
     4ac:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
     4b0:	2f656475 	svccs	0x00656475
     4b4:	72616f62 	rsbvc	r6, r1, #392	; 0x188
     4b8:	70722f64 	rsbsvc	r2, r2, r4, ror #30
     4bc:	682f3069 	stmdavs	pc!, {r0, r3, r5, r6, ip, sp}	; <UNPREDICTABLE>
     4c0:	00006c61 	andeq	r6, r0, r1, ror #24
     4c4:	66647473 			; <UNDEFINED> instruction: 0x66647473
     4c8:	2e656c69 	cdpcs	12, 6, cr6, cr5, cr9, {3}
     4cc:	00707063 	rsbseq	r7, r0, r3, rrx
     4d0:	73000001 	movwvc	r0, #1
     4d4:	682e6977 	stmdavs	lr!, {r0, r1, r2, r4, r5, r6, r8, fp, sp, lr}
     4d8:	00000200 	andeq	r0, r0, r0, lsl #4
     4dc:	6e697073 	mcrvs	0, 3, r7, cr9, cr3, {3}
     4e0:	6b636f6c 	blvs	18dc298 <__bss_end+0x18d1f5c>
     4e4:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
     4e8:	69660000 	stmdbvs	r6!, {}^	; <UNPREDICTABLE>
     4ec:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
     4f0:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
     4f4:	0300682e 	movweq	r6, #2094	; 0x82e
     4f8:	72700000 	rsbsvc	r0, r0, #0
     4fc:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     500:	00682e73 	rsbeq	r2, r8, r3, ror lr
     504:	70000002 	andvc	r0, r0, r2
     508:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     50c:	6d5f7373 	ldclvs	3, cr7, [pc, #-460]	; 348 <shift+0x348>
     510:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     514:	682e7265 	stmdavs	lr!, {r0, r2, r5, r6, r9, ip, sp, lr}
     518:	00000200 	andeq	r0, r0, r0, lsl #4
     51c:	64746e69 	ldrbtvs	r6, [r4], #-3689	; 0xfffff197
     520:	682e6665 	stmdavs	lr!, {r0, r2, r5, r6, r9, sl, sp, lr}
     524:	00000400 	andeq	r0, r0, r0, lsl #8
     528:	00010500 	andeq	r0, r1, r0, lsl #10
     52c:	82d40205 	sbcshi	r0, r4, #1342177280	; 0x50000000
     530:	05160000 	ldreq	r0, [r6, #-0]
     534:	052f6905 	streq	r6, [pc, #-2309]!	; fffffc37 <__bss_end+0xffff58fb>
     538:	01054c0c 	tsteq	r5, ip, lsl #24
     53c:	0505852f 	streq	r8, [r5, #-1327]	; 0xfffffad1
     540:	01054b83 	smlabbeq	r5, r3, fp, r4
     544:	0505852f 	streq	r8, [r5, #-1327]	; 0xfffffad1
     548:	2f01054b 	svccs	0x0001054b
     54c:	a1050585 	smlabbge	r5, r5, r5, r0
     550:	052f4b4b 	streq	r4, [pc, #-2891]!	; fffffa0d <__bss_end+0xffff56d1>
     554:	01054c0c 	tsteq	r5, ip, lsl #24
     558:	0505852f 	streq	r8, [r5, #-1327]	; 0xfffffad1
     55c:	4b4b4bbd 	blmi	12d3458 <__bss_end+0x12c911c>
     560:	4c0c052f 	cfstr32mi	mvfx0, [ip], {47}	; 0x2f
     564:	862f0105 	strthi	r0, [pc], -r5, lsl #2
     568:	4bbd0505 	blmi	fef41984 <__bss_end+0xfef37648>
     56c:	052f4b4b 	streq	r4, [pc, #-2891]!	; fffffa29 <__bss_end+0xffff56ed>
     570:	01054c0c 	tsteq	r5, ip, lsl #24
     574:	0505852f 	streq	r8, [r5, #-1327]	; 0xfffffad1
     578:	01054b83 	smlabbeq	r5, r3, fp, r4
     57c:	0505852f 	streq	r8, [r5, #-1327]	; 0xfffffad1
     580:	4b4b4bbd 	blmi	12d347c <__bss_end+0x12c9140>
     584:	4c0c052f 	cfstr32mi	mvfx0, [ip], {47}	; 0x2f
     588:	852f0105 	strhi	r0, [pc, #-261]!	; 48b <shift+0x48b>
     58c:	4ba10505 	blmi	fe8419a8 <__bss_end+0xfe83766c>
     590:	0c052f4b 	stceq	15, cr2, [r5], {75}	; 0x4b
     594:	2f01054c 	svccs	0x0001054c
     598:	bd050585 	cfstr32lt	mvfx0, [r5, #-532]	; 0xfffffdec
     59c:	2f4b4b4b 	svccs	0x004b4b4b
     5a0:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
     5a4:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
     5a8:	4b4ba105 	blmi	12e89c4 <__bss_end+0x12de688>
     5ac:	4c0c052f 	cfstr32mi	mvfx0, [ip], {47}	; 0x2f
     5b0:	859f0105 	ldrhi	r0, [pc, #261]	; 6bd <shift+0x6bd>
     5b4:	05672005 	strbeq	r2, [r7, #-5]!
     5b8:	4b4b4d05 	blmi	12d39d4 <__bss_end+0x12c9698>
     5bc:	05300c05 	ldreq	r0, [r0, #-3077]!	; 0xfffff3fb
     5c0:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
     5c4:	05056720 	streq	r6, [r5, #-1824]	; 0xfffff8e0
     5c8:	054b4b4d 	strbeq	r4, [fp, #-2893]	; 0xfffff4b3
     5cc:	0105300c 	tsteq	r5, ip
     5d0:	2005852f 	andcs	r8, r5, pc, lsr #10
     5d4:	4c050583 	cfstr32mi	mvfx0, [r5], {131}	; 0x83
     5d8:	01054b4b 	tsteq	r5, fp, asr #22
     5dc:	2005852f 	andcs	r8, r5, pc, lsr #10
     5e0:	4d050567 	cfstr32mi	mvfx0, [r5, #-412]	; 0xfffffe64
     5e4:	0c054b4b 			; <UNDEFINED> instruction: 0x0c054b4b
     5e8:	2f010530 	svccs	0x00010530
     5ec:	a00c0587 	andge	r0, ip, r7, lsl #11
     5f0:	bc31059f 	cfldr32lt	mvfx0, [r1], #-636	; 0xfffffd84
     5f4:	05662905 	strbeq	r2, [r6, #-2309]!	; 0xfffff6fb
     5f8:	0f052e36 	svceq	0x00052e36
     5fc:	66130530 			; <UNDEFINED> instruction: 0x66130530
     600:	05840905 	streq	r0, [r4, #2309]	; 0x905
     604:	0105d810 	tsteq	r5, r0, lsl r8
     608:	0008029f 	muleq	r8, pc, r2	; <UNPREDICTABLE>
     60c:	050d0101 	streq	r0, [sp, #-257]	; 0xfffffeff
     610:	00030000 	andeq	r0, r3, r0
     614:	00000048 	andeq	r0, r0, r8, asr #32
     618:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
     61c:	0101000d 	tsteq	r1, sp
     620:	00000101 	andeq	r0, r0, r1, lsl #2
     624:	00000100 	andeq	r0, r0, r0, lsl #2
     628:	6f682f01 	svcvs	0x00682f01
     62c:	742f656d 	strtvc	r6, [pc], #-1389	; 634 <shift+0x634>
     630:	69666572 	stmdbvs	r6!, {r1, r4, r5, r6, r8, sl, sp, lr}^
     634:	65732f6c 	ldrbvs	r2, [r3, #-3948]!	; 0xfffff094
     638:	6f732f6d 	svcvs	0x00732f6d
     63c:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
     640:	74732f73 	ldrbtvc	r2, [r3], #-3955	; 0xfffff08d
     644:	62696c64 	rsbvs	r6, r9, #100, 24	; 0x6400
     648:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
     64c:	74730000 	ldrbtvc	r0, [r3], #-0
     650:	72747364 	rsbsvc	r7, r4, #100, 6	; 0x90000001
     654:	2e676e69 	cdpcs	14, 6, cr6, cr7, cr9, {3}
     658:	00707063 	rsbseq	r7, r0, r3, rrx
     65c:	00000001 	andeq	r0, r0, r1
     660:	05000105 	streq	r0, [r0, #-261]	; 0xfffffefb
     664:	00873002 	addeq	r3, r7, r2
     668:	09051a00 	stmdbeq	r5, {r9, fp, ip}
     66c:	0f054bbb 	svceq	0x00054bbb
     670:	681b054c 	ldmdavs	fp, {r2, r3, r6, r8, sl}
     674:	052e2105 	streq	r2, [lr, #-261]!	; 0xfffffefb
     678:	0b059e0a 	bleq	167ea8 <__bss_end+0x15db6c>
     67c:	4a27052e 	bmi	9c1b3c <__bss_end+0x9b7800>
     680:	054a0d05 	strbeq	r0, [sl, #-3333]	; 0xfffff2fb
     684:	04052f09 	streq	r2, [r5], #-3849	; 0xfffff0f7
     688:	620205bb 	andvs	r0, r2, #784334848	; 0x2ec00000
     68c:	05350505 	ldreq	r0, [r5, #-1285]!	; 0xfffffafb
     690:	11056810 	tstne	r5, r0, lsl r8
     694:	4a22052e 	bmi	881b54 <__bss_end+0x877818>
     698:	052e1305 	streq	r1, [lr, #-773]!	; 0xfffffcfb
     69c:	09052f0a 	stmdbeq	r5, {r1, r3, r8, r9, sl, fp, sp}
     6a0:	2e0a0569 	cfsh32cs	mvfx0, mvfx10, #57
     6a4:	054a0c05 	strbeq	r0, [sl, #-3077]	; 0xfffff3fb
     6a8:	10054b03 	andne	r4, r5, r3, lsl #22
     6ac:	02040200 	andeq	r0, r4, #0, 4
     6b0:	000c0568 	andeq	r0, ip, r8, ror #10
     6b4:	9e020402 	cdpls	4, 0, cr0, cr2, cr2, {0}
     6b8:	02001505 	andeq	r1, r0, #20971520	; 0x1400000
     6bc:	05680104 	strbeq	r0, [r8, #-260]!	; 0xfffffefc
     6c0:	04020018 	streq	r0, [r2], #-24	; 0xffffffe8
     6c4:	08058201 	stmdaeq	r5, {r0, r9, pc}
     6c8:	01040200 	mrseq	r0, R12_usr
     6cc:	001a054a 	andseq	r0, sl, sl, asr #10
     6d0:	4b010402 	blmi	416e0 <__bss_end+0x373a4>
     6d4:	02001b05 	andeq	r1, r0, #5120	; 0x1400
     6d8:	052e0104 	streq	r0, [lr, #-260]!	; 0xfffffefc
     6dc:	0402000c 	streq	r0, [r2], #-12
     6e0:	0f054a01 	svceq	0x00054a01
     6e4:	01040200 	mrseq	r0, R12_usr
     6e8:	001b0582 	andseq	r0, fp, r2, lsl #11
     6ec:	4a010402 	bmi	416fc <__bss_end+0x373c0>
     6f0:	02001105 	andeq	r1, r0, #1073741825	; 0x40000001
     6f4:	052e0104 	streq	r0, [lr, #-260]!	; 0xfffffefc
     6f8:	0402000a 	streq	r0, [r2], #-10
     6fc:	0b052f01 	bleq	14c308 <__bss_end+0x141fcc>
     700:	01040200 	mrseq	r0, R12_usr
     704:	000d052e 	andeq	r0, sp, lr, lsr #10
     708:	4a010402 	bmi	41718 <__bss_end+0x373dc>
     70c:	02000205 	andeq	r0, r0, #1342177280	; 0x50000000
     710:	05460104 	strbeq	r0, [r6, #-260]	; 0xfffffefc
     714:	05858901 	streq	r8, [r5, #2305]	; 0x901
     718:	1605830e 	strne	r8, [r5], -lr, lsl #6
     71c:	82050566 	andhi	r0, r5, #427819008	; 0x19800000
     720:	054b1005 	strbeq	r1, [fp, #-5]
     724:	06054a19 			; <UNDEFINED> instruction: 0x06054a19
     728:	4c09054b 	cfstr32mi	mvfx0, [r9], {75}	; 0x4b
     72c:	054a1005 	strbeq	r1, [sl, #-5]
     730:	07054c0a 	streq	r4, [r5, -sl, lsl #24]
     734:	4a0305bb 	bmi	c1e28 <__bss_end+0xb7aec>
     738:	02001705 	andeq	r1, r0, #1310720	; 0x140000
     73c:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
     740:	04020014 	streq	r0, [r2], #-20	; 0xffffffec
     744:	0d054a01 	vstreq	s8, [r5, #-4]
     748:	4a14054d 	bmi	501c84 <__bss_end+0x4f7948>
     74c:	052e0a05 	streq	r0, [lr, #-2565]!	; 0xfffff5fb
     750:	02056808 	andeq	r6, r5, #8, 16	; 0x80000
     754:	05667803 	strbeq	r7, [r6, #-2051]!	; 0xfffff7fd
     758:	2e0b0309 	cdpcs	3, 0, cr0, cr11, cr9, {0}
     75c:	052f0105 	streq	r0, [pc, #-261]!	; 65f <shift+0x65f>
     760:	0a056a27 	beq	15b004 <__bss_end+0x150cc8>
     764:	0b054b84 	bleq	15357c <__bss_end+0x149240>
     768:	4a12054b 	bmi	481c9c <__bss_end+0x477960>
     76c:	054b0e05 	strbeq	r0, [fp, #-3589]	; 0xfffff1fb
     770:	18056709 	stmdane	r5, {r0, r3, r8, r9, sl, sp, lr}
     774:	01040200 	mrseq	r0, R12_usr
     778:	00150566 	andseq	r0, r5, r6, ror #10
     77c:	66010402 	strvs	r0, [r1], -r2, lsl #8
     780:	02001105 	andeq	r1, r0, #1073741825	; 0x40000001
     784:	054b0204 	strbeq	r0, [fp, #-516]	; 0xfffffdfc
     788:	0402001a 	streq	r0, [r2], #-26	; 0xffffffe6
     78c:	12054b02 	andne	r4, r5, #2048	; 0x800
     790:	02040200 	andeq	r0, r4, #0, 4
     794:	000d054b 	andeq	r0, sp, fp, asr #10
     798:	67020402 	strvs	r0, [r2, -r2, lsl #8]
     79c:	05310905 	ldreq	r0, [r1, #-2309]!	; 0xfffff6fb
     7a0:	04020014 	streq	r0, [r2], #-20	; 0xffffffec
     7a4:	26056602 	strcs	r6, [r5], -r2, lsl #12
     7a8:	03040200 	movweq	r0, #16896	; 0x4200
     7ac:	4c090566 	cfstr32mi	mvfx0, [r9], {102}	; 0x66
     7b0:	05671a05 	strbeq	r1, [r7, #-2565]!	; 0xfffff5fb
     7b4:	05054b0a 	streq	r4, [r5, #-2826]	; 0xfffff4f6
     7b8:	03667303 	cmneq	r6, #201326592	; 0xc000000
     7bc:	1c052e0f 	stcne	14, cr2, [r5], {15}
     7c0:	01040200 	mrseq	r0, R12_usr
     7c4:	4c0f0566 	cfstr32mi	mvfx0, [pc], {102}	; 0x66
     7c8:	01040200 	mrseq	r0, R12_usr
     7cc:	13056606 	movwne	r6, #22022	; 0x5606
     7d0:	01040200 	mrseq	r0, R12_usr
     7d4:	0f052e06 	svceq	0x00052e06
     7d8:	02040200 	andeq	r0, r4, #0, 4
     7dc:	2e13052e 	cfmul64cs	mvdx0, mvdx3, mvdx14
     7e0:	05300105 	ldreq	r0, [r0, #-261]!	; 0xfffffefb
     7e4:	0c05861e 	stceq	6, cr8, [r5], {30}
     7e8:	05686783 	strbeq	r6, [r8, #-1923]!	; 0xfffff87d
     7ec:	054b6709 	strbeq	r6, [fp, #-1801]	; 0xfffff8f7
     7f0:	0b054b0a 	bleq	153420 <__bss_end+0x1490e4>
     7f4:	4a12054c 	bmi	481d2c <__bss_end+0x4779f0>
     7f8:	054b0d05 	strbeq	r0, [fp, #-3333]	; 0xfffff2fb
     7fc:	1b054a09 	blne	153028 <__bss_end+0x148cec>
     800:	01040200 	mrseq	r0, R12_usr
     804:	0012054b 	andseq	r0, r2, fp, asr #10
     808:	4b010402 	blmi	41818 <__bss_end+0x374dc>
     80c:	02000d05 	andeq	r0, r0, #320	; 0x140
     810:	05670104 	strbeq	r0, [r7, #-260]!	; 0xfffffefc
     814:	0e053012 	mcreq	0, 0, r3, cr5, cr2, {0}
     818:	0022054a 	eoreq	r0, r2, sl, asr #10
     81c:	4a010402 	bmi	4182c <__bss_end+0x374f0>
     820:	02001f05 	andeq	r1, r0, #5, 30
     824:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
     828:	1d054b16 	vstrne	d4, [r5, #-88]	; 0xffffffa8
     82c:	2e10054a 	cfmac32cs	mvfx0, mvfx0, mvfx10
     830:	05670905 	strbeq	r0, [r7, #-2309]!	; 0xfffff6fb
     834:	23056713 	movwcs	r6, #22291	; 0x5713
     838:	9e1405d7 	mrcls	5, 0, r0, cr4, cr7, {6}
     83c:	05851d05 	streq	r1, [r5, #3333]	; 0xd05
     840:	0e056614 	mcreq	6, 0, r6, cr5, cr4, {0}
     844:	03050568 	movweq	r0, #21864	; 0x5568
     848:	0c056671 	stceq	6, cr6, [r5], {113}	; 0x71
     84c:	052e1103 	streq	r1, [lr, #-259]!	; 0xfffffefd
     850:	22084b01 	andcs	r4, r8, #1024	; 0x400
     854:	05bd0905 	ldreq	r0, [sp, #2309]!	; 0x905
     858:	04020016 	streq	r0, [r2], #-22	; 0xffffffea
     85c:	1d054a04 	vstrne	s8, [r5, #-16]
     860:	02040200 	andeq	r0, r4, #0, 4
     864:	001e0582 	andseq	r0, lr, r2, lsl #11
     868:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
     86c:	02001605 	andeq	r1, r0, #5242880	; 0x500000
     870:	05660204 	strbeq	r0, [r6, #-516]!	; 0xfffffdfc
     874:	04020011 	streq	r0, [r2], #-17	; 0xffffffef
     878:	12054b03 	andne	r4, r5, #3072	; 0xc00
     87c:	03040200 	movweq	r0, #16896	; 0x4200
     880:	0008052e 	andeq	r0, r8, lr, lsr #10
     884:	4a030402 	bmi	c1894 <__bss_end+0xb7558>
     888:	02000905 	andeq	r0, r0, #81920	; 0x14000
     88c:	052e0304 	streq	r0, [lr, #-772]!	; 0xfffffcfc
     890:	04020012 	streq	r0, [r2], #-18	; 0xffffffee
     894:	0b054a03 	bleq	1530a8 <__bss_end+0x148d6c>
     898:	03040200 	movweq	r0, #16896	; 0x4200
     89c:	0002052e 	andeq	r0, r2, lr, lsr #10
     8a0:	2d030402 	cfstrscs	mvf0, [r3, #-8]
     8a4:	02000b05 	andeq	r0, r0, #5120	; 0x1400
     8a8:	05840204 	streq	r0, [r4, #516]	; 0x204
     8ac:	04020008 	streq	r0, [r2], #-8
     8b0:	09058301 	stmdbeq	r5, {r0, r8, r9, pc}
     8b4:	01040200 	mrseq	r0, R12_usr
     8b8:	000b052e 	andeq	r0, fp, lr, lsr #10
     8bc:	4a010402 	bmi	418cc <__bss_end+0x37590>
     8c0:	02000205 	andeq	r0, r0, #1342177280	; 0x50000000
     8c4:	05490104 	strbeq	r0, [r9, #-260]	; 0xfffffefc
     8c8:	0105850b 	tsteq	r5, fp, lsl #10
     8cc:	0e05852f 	cfsh32eq	mvfx8, mvfx5, #31
     8d0:	661105bc 			; <UNDEFINED> instruction: 0x661105bc
     8d4:	05bc2005 	ldreq	r2, [ip, #5]!
     8d8:	1f05660b 	svcne	0x0005660b
     8dc:	660a054b 	strvs	r0, [sl], -fp, asr #10
     8e0:	054b0805 	strbeq	r0, [fp, #-2053]	; 0xfffff7fb
     8e4:	16058311 			; <UNDEFINED> instruction: 0x16058311
     8e8:	6708052e 	strvs	r0, [r8, -lr, lsr #10]
     8ec:	05671105 	strbeq	r1, [r7, #-261]!	; 0xfffffefb
     8f0:	01054d0b 	tsteq	r5, fp, lsl #26
     8f4:	0605852f 	streq	r8, [r5], -pc, lsr #10
     8f8:	4c0b0583 	cfstr32mi	mvfx0, [fp], {131}	; 0x83
     8fc:	052e0c05 	streq	r0, [lr, #-3077]!	; 0xfffff3fb
     900:	0405660e 	streq	r6, [r5], #-1550	; 0xfffff9f2
     904:	6502054b 	strvs	r0, [r2, #-1355]	; 0xfffffab5
     908:	05310905 	ldreq	r0, [r1, #-2309]!	; 0xfffff6fb
     90c:	2a052f01 	bcs	14c518 <__bss_end+0x1421dc>
     910:	9f130585 	svcls	0x00130585
     914:	67090567 	strvs	r0, [r9, -r7, ror #10]
     918:	054b0d05 	strbeq	r0, [fp, #-3333]	; 0xfffff2fb
     91c:	04020015 	streq	r0, [r2], #-21	; 0xffffffeb
     920:	19054a03 	stmdbne	r5, {r0, r1, r9, fp, lr}
     924:	02040200 	andeq	r0, r4, #0, 4
     928:	001a0583 	andseq	r0, sl, r3, lsl #11
     92c:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
     930:	02000f05 	andeq	r0, r0, #5, 30
     934:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
     938:	04020011 	streq	r0, [r2], #-17	; 0xffffffef
     93c:	1a058202 	bne	16114c <__bss_end+0x156e10>
     940:	02040200 	andeq	r0, r4, #0, 4
     944:	0013054a 	andseq	r0, r3, sl, asr #10
     948:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
     94c:	02000505 	andeq	r0, r0, #20971520	; 0x1400000
     950:	052d0204 	streq	r0, [sp, #-516]!	; 0xfffffdfc
     954:	0b05840a 	bleq	161984 <__bss_end+0x157648>
     958:	4a0d052e 	bmi	341e18 <__bss_end+0x337adc>
     95c:	054b0c05 	strbeq	r0, [fp, #-3077]	; 0xfffff3fb
     960:	34053001 	strcc	r3, [r5], #-1
     964:	bb090567 	bllt	241f08 <__bss_end+0x237bcc>
     968:	054c1305 	strbeq	r1, [ip, #-773]	; 0xfffffcfb
     96c:	19056805 	stmdbne	r5, {r0, r2, fp, sp, lr}
     970:	01040200 	mrseq	r0, R12_usr
     974:	4c0d0582 	cfstr32mi	mvfx0, [sp], {130}	; 0x82
     978:	02001505 	andeq	r1, r0, #20971520	; 0x1400000
     97c:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
     980:	11058310 	tstne	r5, r0, lsl r3
     984:	6609052e 	strvs	r0, [r9], -lr, lsr #10
     988:	02001905 	andeq	r1, r0, #81920	; 0x14000
     98c:	054b0204 	strbeq	r0, [fp, #-516]	; 0xfffffdfc
     990:	0402001a 	streq	r0, [r2], #-26	; 0xffffffe6
     994:	0f052e02 	svceq	0x00052e02
     998:	02040200 	andeq	r0, r4, #0, 4
     99c:	0011054a 	andseq	r0, r1, sl, asr #10
     9a0:	82020402 	andhi	r0, r2, #33554432	; 0x2000000
     9a4:	02001a05 	andeq	r1, r0, #20480	; 0x5000
     9a8:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
     9ac:	04020013 	streq	r0, [r2], #-19	; 0xffffffed
     9b0:	05052e02 	streq	r2, [r5, #-3586]	; 0xfffff1fe
     9b4:	02040200 	andeq	r0, r4, #0, 4
     9b8:	831b052c 	tsthi	fp, #44, 10	; 0xb000000
     9bc:	05310a05 	ldreq	r0, [r1, #-2565]!	; 0xfffff5fb
     9c0:	0d052e0b 	stceq	14, cr2, [r5, #-44]	; 0xffffffd4
     9c4:	4b0c054a 	blmi	301ef4 <__bss_end+0x2f7bb8>
     9c8:	6a300105 	bvs	c00de4 <__bss_end+0xbf6aa8>
     9cc:	059f0805 	ldreq	r0, [pc, #2053]	; 11d9 <shift+0x11d9>
     9d0:	14054c0b 	strne	r4, [r5], #-3083	; 0xfffff3f5
     9d4:	03040200 	movweq	r0, #16896	; 0x4200
     9d8:	0007054a 	andeq	r0, r7, sl, asr #10
     9dc:	83020402 	movwhi	r0, #9218	; 0x2402
     9e0:	02000805 	andeq	r0, r0, #327680	; 0x50000
     9e4:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
     9e8:	0402000a 	streq	r0, [r2], #-10
     9ec:	02054a02 	andeq	r4, r5, #8192	; 0x2000
     9f0:	02040200 	andeq	r0, r4, #0, 4
     9f4:	84010549 	strhi	r0, [r1], #-1353	; 0xfffffab7
     9f8:	bb0e0585 	bllt	382014 <__bss_end+0x377cd8>
     9fc:	054b0805 	strbeq	r0, [fp, #-2053]	; 0xfffff7fb
     a00:	14054c0b 	strne	r4, [r5], #-3083	; 0xfffff3f5
     a04:	03040200 	movweq	r0, #16896	; 0x4200
     a08:	0016054a 	andseq	r0, r6, sl, asr #10
     a0c:	83020402 	movwhi	r0, #9218	; 0x2402
     a10:	02001705 	andeq	r1, r0, #1310720	; 0x140000
     a14:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
     a18:	0402000a 	streq	r0, [r2], #-10
     a1c:	0b054a02 	bleq	15322c <__bss_end+0x148ef0>
     a20:	02040200 	andeq	r0, r4, #0, 4
     a24:	0017052e 	andseq	r0, r7, lr, lsr #10
     a28:	4a020402 	bmi	81a38 <__bss_end+0x776fc>
     a2c:	02000d05 	andeq	r0, r0, #320	; 0x140
     a30:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
     a34:	04020002 	streq	r0, [r2], #-2
     a38:	01052d02 	tsteq	r5, r2, lsl #26
     a3c:	09058784 	stmdbeq	r5, {r2, r7, r8, r9, sl, pc}
     a40:	4b10059f 	blmi	4020c4 <__bss_end+0x3f7d88>
     a44:	05661305 	strbeq	r1, [r6, #-773]!	; 0xfffffcfb
     a48:	0505bb10 	streq	fp, [r5, #-2832]	; 0xfffff4f0
     a4c:	310c0581 	smlabbcc	ip, r1, r5, r0
     a50:	862f0105 	strthi	r0, [pc], -r5, lsl #2
     a54:	05a20a05 	streq	r0, [r2, #2565]!	; 0xa05
     a58:	0e056705 	cdpeq	7, 0, cr6, cr5, cr5, {0}
     a5c:	670b0584 	strvs	r0, [fp, -r4, lsl #11]
     a60:	05690d05 	strbeq	r0, [r9, #-3333]!	; 0xfffff2fb
     a64:	059f4b0c 	ldreq	r4, [pc, #2828]	; 1578 <shift+0x1578>
     a68:	1705670d 	strne	r6, [r5, -sp, lsl #14]
     a6c:	66150569 	ldrvs	r0, [r5], -r9, ror #10
     a70:	054a2d05 	strbeq	r2, [sl, #-3333]	; 0xfffff2fb
     a74:	0402003d 	streq	r0, [r2], #-61	; 0xffffffc3
     a78:	3b056601 	blcc	15a284 <__bss_end+0x14ff48>
     a7c:	01040200 	mrseq	r0, R12_usr
     a80:	002d0566 	eoreq	r0, sp, r6, ror #10
     a84:	4a010402 	bmi	41a94 <__bss_end+0x37758>
     a88:	05682b05 	strbeq	r2, [r8, #-2821]!	; 0xfffff4fb
     a8c:	15054a1c 	strne	r4, [r5, #-2588]	; 0xfffff5e4
     a90:	2e110582 	cdpcs	5, 1, cr0, cr1, cr2, {4}
     a94:	a0671005 	rsbge	r1, r7, r5
     a98:	057d0505 	ldrbeq	r0, [sp, #-1285]!	; 0xfffffafb
     a9c:	2e090316 	mcrcs	3, 0, r0, cr9, cr6, {0}
     aa0:	05d61b05 	ldrbeq	r1, [r6, #2821]	; 0xb05
     aa4:	26054a11 			; <UNDEFINED> instruction: 0x26054a11
     aa8:	03040200 	movweq	r0, #16896	; 0x4200
     aac:	000b05ba 			; <UNDEFINED> instruction: 0x000b05ba
     ab0:	9f020402 	svcls	0x00020402
     ab4:	02000505 	andeq	r0, r0, #20971520	; 0x1400000
     ab8:	05810204 	streq	r0, [r1, #516]	; 0x204
     abc:	1505f50e 	strne	pc, [r5, #-1294]	; 0xfffffaf2
     ac0:	660c054b 	strvs	r0, [ip], -fp, asr #10
     ac4:	9f0505d7 	svcls	0x000505d7
     ac8:	05840f05 	streq	r0, [r4, #3845]	; 0xf05
     acc:	0c05d711 	stceq	7, cr13, [r5], {17}
     ad0:	001805d9 			; <UNDEFINED> instruction: 0x001805d9
     ad4:	4a010402 	bmi	41ae4 <__bss_end+0x377a8>
     ad8:	05680905 	strbeq	r0, [r8, #-2309]!	; 0xfffff6fb
     adc:	12059f10 	andne	r9, r5, #16, 30	; 0x40
     ae0:	670e0566 	strvs	r0, [lr, -r6, ror #10]
     ae4:	059f1005 	ldreq	r1, [pc, #5]	; af1 <shift+0xaf1>
     ae8:	0e056612 	mcreq	6, 0, r6, cr5, cr2, {0}
     aec:	001d0567 	andseq	r0, sp, r7, ror #10
     af0:	82010402 	andhi	r0, r1, #33554432	; 0x2000000
     af4:	05671005 	strbeq	r1, [r7, #-5]!
     af8:	1c056612 	stcne	6, cr6, [r5], {18}
     afc:	82220569 	eorhi	r0, r2, #440401920	; 0x1a400000
     b00:	052e1005 	streq	r1, [lr, #-5]!
     b04:	12056622 	andne	r6, r5, #35651584	; 0x2200000
     b08:	2f14054a 	svccs	0x0014054a
     b0c:	02000505 	andeq	r0, r0, #20971520	; 0x1400000
     b10:	75030204 	strvc	r0, [r3, #-516]	; 0xfffffdfc
     b14:	030105d6 	movweq	r0, #5590	; 0x15d6
     b18:	0a029e0e 	beq	a8358 <__bss_end+0x9e01c>
     b1c:	10010100 	andne	r0, r1, r0, lsl #2
     b20:	03000003 	movweq	r0, #3
     b24:	0001ce00 	andeq	ip, r1, r0, lsl #28
     b28:	fb010200 	blx	41332 <__bss_end+0x36ff6>
     b2c:	01000d0e 	tsteq	r0, lr, lsl #26
     b30:	00010101 	andeq	r0, r1, r1, lsl #2
     b34:	00010000 	andeq	r0, r1, r0
     b38:	682f0100 	stmdavs	pc!, {r8}	; <UNPREDICTABLE>
     b3c:	2f656d6f 	svccs	0x00656d6f
     b40:	66657274 			; <UNDEFINED> instruction: 0x66657274
     b44:	732f6c69 			; <UNDEFINED> instruction: 0x732f6c69
     b48:	732f6d65 			; <UNDEFINED> instruction: 0x732f6d65
     b4c:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
     b50:	732f7365 			; <UNDEFINED> instruction: 0x732f7365
     b54:	74756474 	ldrbtvc	r6, [r5], #-1140	; 0xfffffb8c
     b58:	2f736c69 	svccs	0x00736c69
     b5c:	00637273 	rsbeq	r7, r3, r3, ror r2
     b60:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; aac <shift+0xaac>
     b64:	72742f65 	rsbsvc	r2, r4, #404	; 0x194
     b68:	6c696665 	stclvs	6, cr6, [r9], #-404	; 0xfffffe6c
     b6c:	6d65732f 	stclvs	3, cr7, [r5, #-188]!	; 0xffffff44
     b70:	756f732f 	strbvc	r7, [pc, #-815]!	; 849 <shift+0x849>
     b74:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
     b78:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
     b7c:	2f6c656e 	svccs	0x006c656e
     b80:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
     b84:	2f656475 	svccs	0x00656475
     b88:	72616f62 	rsbvc	r6, r1, #392	; 0x188
     b8c:	70722f64 	rsbsvc	r2, r2, r4, ror #30
     b90:	682f3069 	stmdavs	pc!, {r0, r3, r5, r6, ip, sp}	; <UNPREDICTABLE>
     b94:	2f006c61 	svccs	0x00006c61
     b98:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
     b9c:	6572742f 	ldrbvs	r7, [r2, #-1071]!	; 0xfffffbd1
     ba0:	2f6c6966 	svccs	0x006c6966
     ba4:	2f6d6573 	svccs	0x006d6573
     ba8:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
     bac:	2f736563 	svccs	0x00736563
     bb0:	75647473 	strbvc	r7, [r4, #-1139]!	; 0xfffffb8d
     bb4:	736c6974 	cmnvc	ip, #116, 18	; 0x1d0000
     bb8:	636e692f 	cmnvs	lr, #770048	; 0xbc000
     bbc:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
     bc0:	6f682f00 	svcvs	0x00682f00
     bc4:	742f656d 	strtvc	r6, [pc], #-1389	; bcc <shift+0xbcc>
     bc8:	69666572 	stmdbvs	r6!, {r1, r4, r5, r6, r8, sl, sp, lr}^
     bcc:	65732f6c 	ldrbvs	r2, [r3, #-3948]!	; 0xfffff094
     bd0:	6f732f6d 	svcvs	0x00732f6d
     bd4:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
     bd8:	656b2f73 	strbvs	r2, [fp, #-3955]!	; 0xfffff08d
     bdc:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
     be0:	636e692f 	cmnvs	lr, #770048	; 0xbc000
     be4:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
     be8:	6f72702f 	svcvs	0x0072702f
     bec:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     bf0:	6f682f00 	svcvs	0x00682f00
     bf4:	742f656d 	strtvc	r6, [pc], #-1389	; bfc <shift+0xbfc>
     bf8:	69666572 	stmdbvs	r6!, {r1, r4, r5, r6, r8, sl, sp, lr}^
     bfc:	65732f6c 	ldrbvs	r2, [r3, #-3948]!	; 0xfffff094
     c00:	6f732f6d 	svcvs	0x00732f6d
     c04:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
     c08:	656b2f73 	strbvs	r2, [fp, #-3955]!	; 0xfffff08d
     c0c:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
     c10:	636e692f 	cmnvs	lr, #770048	; 0xbc000
     c14:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
     c18:	0073662f 	rsbseq	r6, r3, pc, lsr #12
     c1c:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; b68 <shift+0xb68>
     c20:	72742f65 	rsbsvc	r2, r4, #404	; 0x194
     c24:	6c696665 	stclvs	6, cr6, [r9], #-404	; 0xfffffe6c
     c28:	6d65732f 	stclvs	3, cr7, [r5, #-188]!	; 0xffffff44
     c2c:	756f732f 	strbvc	r7, [pc, #-815]!	; 905 <shift+0x905>
     c30:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
     c34:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
     c38:	2f6c656e 	svccs	0x006c656e
     c3c:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
     c40:	2f656475 	svccs	0x00656475
     c44:	76697264 	strbtvc	r7, [r9], -r4, ror #4
     c48:	2f737265 	svccs	0x00737265
     c4c:	64697262 	strbtvs	r7, [r9], #-610	; 0xfffffd9e
     c50:	00736567 	rsbseq	r6, r3, r7, ror #10
     c54:	656c6f00 	strbvs	r6, [ip, #-3840]!	; 0xfffff100
     c58:	70632e64 	rsbvc	r2, r3, r4, ror #28
     c5c:	00010070 	andeq	r0, r1, r0, ror r0
     c60:	746e6900 	strbtvc	r6, [lr], #-2304	; 0xfffff700
     c64:	2e666564 	cdpcs	5, 6, cr6, cr6, cr4, {3}
     c68:	00020068 	andeq	r0, r2, r8, rrx
     c6c:	656c6f00 	strbvs	r6, [ip, #-3840]!	; 0xfffff100
     c70:	00682e64 	rsbeq	r2, r8, r4, ror #28
     c74:	73000003 	movwvc	r0, #3
     c78:	682e6977 	stmdavs	lr!, {r0, r1, r2, r4, r5, r6, r8, fp, sp, lr}
     c7c:	00000400 	andeq	r0, r0, r0, lsl #8
     c80:	6e697073 	mcrvs	0, 3, r7, cr9, cr3, {3}
     c84:	6b636f6c 	blvs	18dca3c <__bss_end+0x18d2700>
     c88:	0400682e 	streq	r6, [r0], #-2094	; 0xfffff7d2
     c8c:	69660000 	stmdbvs	r6!, {}^	; <UNPREDICTABLE>
     c90:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
     c94:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
     c98:	0500682e 	streq	r6, [r0, #-2094]	; 0xfffff7d2
     c9c:	72700000 	rsbsvc	r0, r0, #0
     ca0:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     ca4:	00682e73 	rsbeq	r2, r8, r3, ror lr
     ca8:	70000004 	andvc	r0, r0, r4
     cac:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     cb0:	6d5f7373 	ldclvs	3, cr7, [pc, #-460]	; aec <shift+0xaec>
     cb4:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     cb8:	682e7265 	stmdavs	lr!, {r0, r2, r5, r6, r9, ip, sp, lr}
     cbc:	00000400 	andeq	r0, r0, r0, lsl #8
     cc0:	70736964 	rsbsvc	r6, r3, r4, ror #18
     cc4:	5f79616c 	svcpl	0x0079616c
     cc8:	746f7270 	strbtvc	r7, [pc], #-624	; cd0 <shift+0xcd0>
     ccc:	6c6f636f 	stclvs	3, cr6, [pc], #-444	; b18 <shift+0xb18>
     cd0:	0600682e 	streq	r6, [r0], -lr, lsr #16
     cd4:	65700000 	ldrbvs	r0, [r0, #-0]!
     cd8:	68706972 	ldmdavs	r0!, {r1, r4, r5, r6, r8, fp, sp, lr}^
     cdc:	6c617265 	sfmvs	f7, 2, [r1], #-404	; 0xfffffe6c
     ce0:	00682e73 	rsbeq	r2, r8, r3, ror lr
     ce4:	6f000002 	svcvs	0x00000002
     ce8:	5f64656c 	svcpl	0x0064656c
     cec:	746e6f66 	strbtvc	r6, [lr], #-3942	; 0xfffff09a
     cf0:	0100682e 	tsteq	r0, lr, lsr #16
     cf4:	05000000 	streq	r0, [r0, #-0]
     cf8:	02050001 	andeq	r0, r5, #1
     cfc:	0000938c 	andeq	r9, r0, ip, lsl #7
     d00:	05010903 	streq	r0, [r1, #-2307]	; 0xfffff6fd
     d04:	48059f14 	stmdami	r5, {r2, r4, r8, r9, sl, fp, ip, pc}
     d08:	a1100582 	tstge	r0, r2, lsl #11
     d0c:	054a1805 	strbeq	r1, [sl, #-2053]	; 0xfffff7fb
     d10:	0105820d 	tsteq	r5, sp, lsl #4
     d14:	0905844b 	stmdbeq	r5, {r0, r1, r3, r6, sl, pc}
     d18:	4a050585 	bmi	142334 <__bss_end+0x137ff8>
     d1c:	054c1105 	strbeq	r1, [ip, #-261]	; 0xfffffefb
     d20:	0105670e 	tsteq	r5, lr, lsl #14
     d24:	0c058584 	cfstr32eq	mvfx8, [r5], {132}	; 0x84
     d28:	4b010583 	blmi	4233c <__bss_end+0x38000>
     d2c:	bb0a0585 	bllt	282348 <__bss_end+0x27800c>
     d30:	054a0905 	strbeq	r0, [sl, #-2309]	; 0xfffff6fb
     d34:	11054a05 	tstne	r5, r5, lsl #20
     d38:	4b0f054e 	blmi	3c2278 <__bss_end+0x3b7f3c>
     d3c:	01040200 	mrseq	r0, R12_usr
     d40:	02006606 	andeq	r6, r0, #6291456	; 0x600000
     d44:	004a0204 	subeq	r0, sl, r4, lsl #4
     d48:	2e040402 	cdpcs	4, 0, cr0, cr4, cr2, {0}
     d4c:	02000705 	andeq	r0, r0, #1310720	; 0x140000
     d50:	2f060404 	svccs	0x00060404
     d54:	05d10905 	ldrbeq	r0, [r1, #2309]	; 0x905
     d58:	054d3401 	strbeq	r3, [sp, #-1025]	; 0xfffffbff
     d5c:	0591080a 	ldreq	r0, [r1, #2058]	; 0x80a
     d60:	05054a09 	streq	r4, [r5, #-2569]	; 0xfffff5f7
     d64:	4f14054a 	svcmi	0x0014054a
     d68:	054b0f05 	strbeq	r0, [fp, #-3845]	; 0xfffff0fb
     d6c:	05f39f11 	ldrbeq	r9, [r3, #3857]!	; 0xf11
     d70:	0200f313 	andeq	pc, r0, #1275068416	; 0x4c000000
     d74:	66060104 	strvs	r0, [r6], -r4, lsl #2
     d78:	02040200 	andeq	r0, r4, #0, 4
     d7c:	0402004a 	streq	r0, [r2], #-74	; 0xffffffb6
     d80:	0a052e04 	beq	14c598 <__bss_end+0x14225c>
     d84:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
     d88:	09052f06 	stmdbeq	r5, {r1, r2, r8, r9, sl, fp, sp}
     d8c:	05d67703 	ldrbeq	r7, [r6, #1795]	; 0x703
     d90:	2e0a0301 	cdpcs	3, 0, cr0, cr10, cr1, {0}
     d94:	080a054d 	stmdaeq	sl, {r0, r2, r3, r6, r8, sl}
     d98:	4a090591 	bmi	2423e4 <__bss_end+0x2380a8>
     d9c:	4e4a0505 	cdpmi	5, 4, cr0, cr10, cr5, {0}
     da0:	02002805 	andeq	r2, r0, #327680	; 0x50000
     da4:	05660104 	strbeq	r0, [r6, #-260]!	; 0xfffffefc
     da8:	04020023 	streq	r0, [r2], #-35	; 0xffffffdd
     dac:	1e052e01 	cdpne	14, 0, cr2, cr5, cr1, {0}
     db0:	4b15054f 	blmi	5422f4 <__bss_end+0x537fb8>
     db4:	bb670c05 	bllt	19c3dd0 <__bss_end+0x19b9a94>
     db8:	08bb0d05 	ldmeq	fp!, {r0, r2, r8, sl, fp}
     dbc:	08100521 	ldmdaeq	r0, {r0, r5, r8, sl}
     dc0:	68440521 	stmdavs	r4, {r0, r5, r8, sl}^
     dc4:	052e5105 	streq	r5, [lr, #-261]!	; 0xfffffefb
     dc8:	0c052e40 	stceq	14, cr2, [r5], {64}	; 0x40
     dcc:	4a6c059e 	bmi	1b0244c <__bss_end+0x1af8110>
     dd0:	054a0b05 	strbeq	r0, [sl, #-2821]	; 0xfffff4fb
     dd4:	0905680a 	stmdbeq	r5, {r1, r3, fp, sp, lr}
     dd8:	4ed66e03 	cdpmi	14, 13, cr6, cr6, cr3, {0}
     ddc:	0f030105 	svceq	0x00030105
     de0:	0a05692e 	beq	15b2a0 <__bss_end+0x150f64>
     de4:	4a090583 	bmi	2423f8 <__bss_end+0x2380bc>
     de8:	054a0505 	strbeq	r0, [sl, #-1285]	; 0xfffffafb
     dec:	0a054e14 	beq	154644 <__bss_end+0x14a308>
     df0:	d109054c 	tstle	r9, ip, asr #10
     df4:	4d340105 	ldfmis	f0, [r4, #-20]!	; 0xffffffec
     df8:	21080a05 	tstcs	r8, r5, lsl #20
     dfc:	054a0905 	strbeq	r0, [sl, #-2309]	; 0xfffff6fb
     e00:	0e054a05 	vmlaeq.f32	s8, s10, s10
     e04:	4b11054d 	blmi	442340 <__bss_end+0x438004>
     e08:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
     e0c:	20054a19 	andcs	r4, r5, r9, lsl sl
     e10:	01040200 	mrseq	r0, R12_usr
     e14:	0019054a 	andseq	r0, r9, sl, asr #10
     e18:	66010402 	strvs	r0, [r1], -r2, lsl #8
     e1c:	054c1105 	strbeq	r1, [ip, #-261]	; 0xfffffefb
     e20:	0567bb0c 	strbeq	fp, [r7, #-2828]!	; 0xfffff4f4
     e24:	09056205 	stmdbeq	r5, {r0, r2, r9, sp, lr}
     e28:	03010529 	movweq	r0, #5417	; 0x1529
     e2c:	04022e0b 	streq	r2, [r2], #-3595	; 0xfffff1f5
     e30:	79010100 	stmdbvc	r1, {r8}
     e34:	03000000 	movweq	r0, #0
     e38:	00004600 	andeq	r4, r0, r0, lsl #12
     e3c:	fb010200 	blx	41646 <__bss_end+0x3730a>
     e40:	01000d0e 	tsteq	r0, lr, lsl #26
     e44:	00010101 	andeq	r0, r1, r1, lsl #2
     e48:	00010000 	andeq	r0, r1, r0
     e4c:	2e2e0100 	sufcse	f0, f6, f0
     e50:	2f2e2e2f 	svccs	0x002e2e2f
     e54:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     e58:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     e5c:	2f2e2e2f 	svccs	0x002e2e2f
     e60:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
     e64:	632f6363 			; <UNDEFINED> instruction: 0x632f6363
     e68:	69666e6f 	stmdbvs	r6!, {r0, r1, r2, r3, r5, r6, r9, sl, fp, sp, lr}^
     e6c:	72612f67 	rsbvc	r2, r1, #412	; 0x19c
     e70:	6c00006d 	stcvs	0, cr0, [r0], {109}	; 0x6d
     e74:	66316269 	ldrtvs	r6, [r1], -r9, ror #4
     e78:	73636e75 	cmnvc	r3, #1872	; 0x750
     e7c:	0100532e 	tsteq	r0, lr, lsr #6
     e80:	00000000 	andeq	r0, r0, r0
     e84:	98400205 	stmdals	r0, {r0, r2, r9}^
     e88:	cf030000 	svcgt	0x00030000
     e8c:	2f300108 	svccs	0x00300108
     e90:	2f2f2f2f 	svccs	0x002f2f2f
     e94:	01d00230 	bicseq	r0, r0, r0, lsr r2
     e98:	2f312f14 	svccs	0x00312f14
     e9c:	2f4c302f 	svccs	0x004c302f
     ea0:	661f0332 			; <UNDEFINED> instruction: 0x661f0332
     ea4:	2f2f2f2f 	svccs	0x002f2f2f
     ea8:	022f2f2f 	eoreq	r2, pc, #47, 30	; 0xbc
     eac:	01010002 	tsteq	r1, r2
     eb0:	0000005c 	andeq	r0, r0, ip, asr r0
     eb4:	00460003 	subeq	r0, r6, r3
     eb8:	01020000 	mrseq	r0, (UNDEF: 2)
     ebc:	000d0efb 	strdeq	r0, [sp], -fp
     ec0:	01010101 	tsteq	r1, r1, lsl #2
     ec4:	01000000 	mrseq	r0, (UNDEF: 0)
     ec8:	2e010000 	cdpcs	0, 0, cr0, cr1, cr0, {0}
     ecc:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     ed0:	2f2e2e2f 	svccs	0x002e2e2f
     ed4:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     ed8:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     edc:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
     ee0:	2f636367 	svccs	0x00636367
     ee4:	666e6f63 	strbtvs	r6, [lr], -r3, ror #30
     ee8:	612f6769 			; <UNDEFINED> instruction: 0x612f6769
     eec:	00006d72 	andeq	r6, r0, r2, ror sp
     ef0:	3162696c 	cmncc	r2, ip, ror #18
     ef4:	636e7566 	cmnvs	lr, #427819008	; 0x19800000
     ef8:	00532e73 	subseq	r2, r3, r3, ror lr
     efc:	00000001 	andeq	r0, r0, r1
     f00:	4c020500 	cfstr32mi	mvfx0, [r2], {-0}
     f04:	0300009a 	movweq	r0, #154	; 0x9a
     f08:	02010bb9 	andeq	r0, r1, #189440	; 0x2e400
     f0c:	01010002 	tsteq	r1, r2
     f10:	000000fb 	strdeq	r0, [r0], -fp
     f14:	00470003 	subeq	r0, r7, r3
     f18:	01020000 	mrseq	r0, (UNDEF: 2)
     f1c:	000d0efb 	strdeq	r0, [sp], -fp
     f20:	01010101 	tsteq	r1, r1, lsl #2
     f24:	01000000 	mrseq	r0, (UNDEF: 0)
     f28:	2e010000 	cdpcs	0, 0, cr0, cr1, cr0, {0}
     f2c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     f30:	2f2e2e2f 	svccs	0x002e2e2f
     f34:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     f38:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     f3c:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
     f40:	2f636367 	svccs	0x00636367
     f44:	666e6f63 	strbtvs	r6, [lr], -r3, ror #30
     f48:	612f6769 			; <UNDEFINED> instruction: 0x612f6769
     f4c:	00006d72 	andeq	r6, r0, r2, ror sp
     f50:	65656569 	strbvs	r6, [r5, #-1385]!	; 0xfffffa97
     f54:	2d343537 	cfldr32cs	mvfx3, [r4, #-220]!	; 0xffffff24
     f58:	532e6673 			; <UNDEFINED> instruction: 0x532e6673
     f5c:	00000100 	andeq	r0, r0, r0, lsl #2
     f60:	02050000 	andeq	r0, r5, #0
     f64:	00009a50 	andeq	r9, r0, r0, asr sl
     f68:	2f013a03 	svccs	0x00013a03
     f6c:	2e090333 	mcrcs	3, 0, r0, cr9, cr3, {1}
     f70:	2f2f2f30 	svccs	0x002f2f30
     f74:	302f322f 	eorcc	r3, pc, pc, lsr #4
     f78:	302f2f2f 	eorcc	r2, pc, pc, lsr #30
     f7c:	2f313033 	svccs	0x00313033
     f80:	2f2f302f 	svccs	0x002f302f
     f84:	2f32302f 	svccs	0x0032302f
     f88:	2f2f3232 	svccs	0x002f3232
     f8c:	2f332f31 	svccs	0x00332f31
     f90:	2f2f2f33 	svccs	0x002f2f33
     f94:	312f2f31 			; <UNDEFINED> instruction: 0x312f2f31
     f98:	302f352f 	eorcc	r3, pc, pc, lsr #10
     f9c:	2f322f2f 	svccs	0x00322f2f
     fa0:	032f302f 			; <UNDEFINED> instruction: 0x032f302f
     fa4:	2f2f2e19 	svccs	0x002f2e19
     fa8:	2f2f352f 	svccs	0x002f352f
     fac:	2f333034 	svccs	0x00333034
     fb0:	2f2f2f30 	svccs	0x002f2f30
     fb4:	2f303031 	svccs	0x00303031
     fb8:	30312f30 	eorscc	r2, r1, r0, lsr pc
     fbc:	2f32302f 	svccs	0x0032302f
     fc0:	302f2f31 	eorcc	r2, pc, r1, lsr pc	; <UNPREDICTABLE>
     fc4:	2f302f2f 	svccs	0x00302f2f
     fc8:	2f2f322f 	svccs	0x002f322f
     fcc:	302e0903 	eorcc	r0, lr, r3, lsl #18
     fd0:	302f2f2f 	eorcc	r2, pc, pc, lsr #30
     fd4:	032f2f2f 			; <UNDEFINED> instruction: 0x032f2f2f
     fd8:	332f2e0d 			; <UNDEFINED> instruction: 0x332f2e0d
     fdc:	31303030 	teqcc	r0, r0, lsr r0
     fe0:	032f3031 			; <UNDEFINED> instruction: 0x032f3031
     fe4:	30302e0c 	eorscc	r2, r0, ip, lsl #28
     fe8:	3030332f 	eorscc	r3, r0, pc, lsr #6
     fec:	312f332f 			; <UNDEFINED> instruction: 0x312f332f
     ff0:	312f2f30 			; <UNDEFINED> instruction: 0x312f2f30
     ff4:	19032f30 	stmdbne	r3, {r4, r5, r8, r9, sl, fp, sp}
     ff8:	2f322f2e 	svccs	0x00322f2e
     ffc:	2f2f2f30 	svccs	0x002f2f30
    1000:	302f302f 	eorcc	r3, pc, pc, lsr #32
    1004:	2f2f2f2f 	svccs	0x002f2f2f
    1008:	02022f30 	andeq	r2, r2, #48, 30	; 0xc0
    100c:	7a010100 	bvc	41414 <__bss_end+0x370d8>
    1010:	03000000 	movweq	r0, #0
    1014:	00004200 	andeq	r4, r0, r0, lsl #4
    1018:	fb010200 	blx	41822 <__bss_end+0x374e6>
    101c:	01000d0e 	tsteq	r0, lr, lsl #26
    1020:	00010101 	andeq	r0, r1, r1, lsl #2
    1024:	00010000 	andeq	r0, r1, r0
    1028:	2e2e0100 	sufcse	f0, f6, f0
    102c:	2f2e2e2f 	svccs	0x002e2e2f
    1030:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1034:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1038:	2f2e2e2f 	svccs	0x002e2e2f
    103c:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    1040:	632f6363 			; <UNDEFINED> instruction: 0x632f6363
    1044:	69666e6f 	stmdbvs	r6!, {r0, r1, r2, r3, r5, r6, r9, sl, fp, sp, lr}^
    1048:	72612f67 	rsbvc	r2, r1, #412	; 0x19c
    104c:	6200006d 	andvs	r0, r0, #109	; 0x6d
    1050:	69626170 	stmdbvs	r2!, {r4, r5, r6, r8, sp, lr}^
    1054:	0100532e 	tsteq	r0, lr, lsr #6
    1058:	00000000 	andeq	r0, r0, r0
    105c:	9ca00205 	sfmls	f0, 4, [r0], #20
    1060:	b9030000 	stmdblt	r3, {}	; <UNPREDICTABLE>
    1064:	5a080101 	bpl	201470 <__bss_end+0x1f7134>
    1068:	2f2f2f4b 	svccs	0x002f2f4b
    106c:	32673030 	rsbcc	r3, r7, #48	; 0x30
    1070:	302f2f2f 	eorcc	r2, pc, pc, lsr #30
    1074:	2f2f6730 	svccs	0x002f6730
    1078:	2f322f2f 	svccs	0x00322f2f
    107c:	2f673030 	svccs	0x00673030
    1080:	302f322f 	eorcc	r3, pc, pc, lsr #4
    1084:	2f2f672f 	svccs	0x002f672f
    1088:	01000202 	tsteq	r0, r2, lsl #4
    108c:	0000a401 	andeq	sl, r0, r1, lsl #8
    1090:	9e000300 	cdpls	3, 0, cr0, cr0, cr0, {0}
    1094:	02000000 	andeq	r0, r0, #0
    1098:	0d0efb01 	vstreq	d15, [lr, #-4]
    109c:	01010100 	mrseq	r0, (UNDEF: 17)
    10a0:	00000001 	andeq	r0, r0, r1
    10a4:	01000001 	tsteq	r0, r1
    10a8:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    10ac:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    10b0:	2f2e2e2f 	svccs	0x002e2e2f
    10b4:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    10b8:	6363672f 	cmnvs	r3, #12320768	; 0xbc0000
    10bc:	2f2e2e00 	svccs	0x002e2e00
    10c0:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    10c4:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    10c8:	2f2e2e2f 	svccs	0x002e2e2f
    10cc:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; 101c <shift+0x101c>
    10d0:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    10d4:	2e2e2f63 	cdpcs	15, 2, cr2, cr14, cr3, {3}
    10d8:	6363672f 	cmnvs	r3, #12320768	; 0xbc0000
    10dc:	6e6f632f 	cdpvs	3, 6, cr6, cr15, cr15, {1}
    10e0:	2f676966 	svccs	0x00676966
    10e4:	006d7261 	rsbeq	r7, sp, r1, ror #4
    10e8:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    10ec:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    10f0:	2f2e2e2f 	svccs	0x002e2e2f
    10f4:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    10f8:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
    10fc:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    1100:	72610000 	rsbvc	r0, r1, #0
    1104:	73692d6d 	cmnvc	r9, #6976	; 0x1b40
    1108:	00682e61 	rsbeq	r2, r8, r1, ror #28
    110c:	61000001 	tstvs	r0, r1
    1110:	682e6d72 	stmdavs	lr!, {r1, r4, r5, r6, r8, sl, fp, sp, lr}
    1114:	00000200 	andeq	r0, r0, r0, lsl #4
    1118:	2d6c6267 	sfmcs	f6, 2, [ip, #-412]!	; 0xfffffe64
    111c:	726f7463 	rsbvc	r7, pc, #1660944384	; 0x63000000
    1120:	00682e73 	rsbeq	r2, r8, r3, ror lr
    1124:	6c000003 	stcvs	0, cr0, [r0], {3}
    1128:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    112c:	632e3263 			; <UNDEFINED> instruction: 0x632e3263
    1130:	00000300 	andeq	r0, r0, r0, lsl #6
    1134:	0000a700 	andeq	sl, r0, r0, lsl #14
    1138:	68000300 	stmdavs	r0, {r8, r9}
    113c:	02000000 	andeq	r0, r0, #0
    1140:	0d0efb01 	vstreq	d15, [lr, #-4]
    1144:	01010100 	mrseq	r0, (UNDEF: 17)
    1148:	00000001 	andeq	r0, r0, r1
    114c:	01000001 	tsteq	r0, r1
    1150:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1154:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1158:	2f2e2e2f 	svccs	0x002e2e2f
    115c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1160:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
    1164:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    1168:	2f2e2e00 	svccs	0x002e2e00
    116c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1170:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1174:	2f2e2e2f 	svccs	0x002e2e2f
    1178:	63672f2e 	cmnvs	r7, #46, 30	; 0xb8
    117c:	6c000063 	stcvs	0, cr0, [r0], {99}	; 0x63
    1180:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    1184:	632e3263 			; <UNDEFINED> instruction: 0x632e3263
    1188:	00000100 	andeq	r0, r0, r0, lsl #2
    118c:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
    1190:	2e617369 	cdpcs	3, 6, cr7, cr1, cr9, {3}
    1194:	00020068 	andeq	r0, r2, r8, rrx
    1198:	62696c00 	rsbvs	r6, r9, #0, 24
    119c:	32636367 	rsbcc	r6, r3, #-1677721599	; 0x9c000001
    11a0:	0100682e 	tsteq	r0, lr, lsr #16
    11a4:	05000000 	streq	r0, [r0, #-0]
    11a8:	02050001 	andeq	r0, r5, #1
    11ac:	00009d74 	andeq	r9, r0, r4, ror sp
    11b0:	010bf903 	tsteq	fp, r3, lsl #18	; <UNPREDICTABLE>
    11b4:	05130305 	ldreq	r0, [r3, #-773]	; 0xfffffcfb
    11b8:	05110601 	ldreq	r0, [r1, #-1537]	; 0xfffff9ff
    11bc:	03052f06 	movweq	r2, #24326	; 0x5f06
    11c0:	0a056806 	beq	15b1e0 <__bss_end+0x150ea4>
    11c4:	05050106 	streq	r0, [r5, #-262]	; 0xfffffefa
    11c8:	0e052d06 	cdpeq	13, 0, cr2, cr5, cr6, {0}
    11cc:	01050106 	tsteq	r5, r6, lsl #2
    11d0:	300e052c 	andcc	r0, lr, ip, lsr #10
    11d4:	2e0c052e 	cfsh32cs	mvfx0, mvfx12, #30
    11d8:	024c0105 	subeq	r0, ip, #1073741825	; 0x40000001
    11dc:	01010002 	tsteq	r1, r2
    11e0:	000000b6 	strheq	r0, [r0], -r6
    11e4:	00680003 	rsbeq	r0, r8, r3
    11e8:	01020000 	mrseq	r0, (UNDEF: 2)
    11ec:	000d0efb 	strdeq	r0, [sp], -fp
    11f0:	01010101 	tsteq	r1, r1, lsl #2
    11f4:	01000000 	mrseq	r0, (UNDEF: 0)
    11f8:	2e010000 	cdpcs	0, 0, cr0, cr1, cr0, {0}
    11fc:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1200:	2f2e2e2f 	svccs	0x002e2e2f
    1204:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1208:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    120c:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
    1210:	00636367 	rsbeq	r6, r3, r7, ror #6
    1214:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1218:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    121c:	2f2e2e2f 	svccs	0x002e2e2f
    1220:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1224:	6363672f 	cmnvs	r3, #12320768	; 0xbc0000
    1228:	696c0000 	stmdbvs	ip!, {}^	; <UNPREDICTABLE>
    122c:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    1230:	00632e32 	rsbeq	r2, r3, r2, lsr lr
    1234:	61000001 	tstvs	r0, r1
    1238:	692d6d72 	pushvs	{r1, r4, r5, r6, r8, sl, fp, sp, lr}
    123c:	682e6173 	stmdavs	lr!, {r0, r1, r4, r5, r6, r8, sp, lr}
    1240:	00000200 	andeq	r0, r0, r0, lsl #4
    1244:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    1248:	2e326363 	cdpcs	3, 3, cr6, cr2, cr3, {3}
    124c:	00010068 	andeq	r0, r1, r8, rrx
    1250:	01050000 	mrseq	r0, (UNDEF: 5)
    1254:	a8020500 	stmdage	r2, {r8, sl}
    1258:	0300009d 	movweq	r0, #157	; 0x9d
    125c:	05010bb9 	streq	r0, [r1, #-3001]	; 0xfffff447
    1260:	10051703 	andne	r1, r5, r3, lsl #14
    1264:	19050106 	stmdbne	r5, {r1, r2, r8}
    1268:	33270533 			; <UNDEFINED> instruction: 0x33270533
    126c:	76031005 	strvc	r1, [r3], -r5
    1270:	0603052e 	streq	r0, [r3], -lr, lsr #10
    1274:	06190533 			; <UNDEFINED> instruction: 0x06190533
    1278:	2e100501 	cfmul32cs	mvfx0, mvfx0, mvfx1
    127c:	33060305 	movwcc	r0, #25349	; 0x6305
    1280:	061b0515 			; <UNDEFINED> instruction: 0x061b0515
    1284:	0301050f 	movweq	r0, #5391	; 0x150f
    1288:	19052e2b 	stmdbne	r5, {r0, r1, r3, r5, r9, sl, fp, sp}
    128c:	052e5503 	streq	r5, [lr, #-1283]!	; 0xfffffafd
    1290:	2e2b0301 	cdpcs	3, 2, cr0, cr11, cr1, {0}
    1294:	000a024a 	andeq	r0, sl, sl, asr #4
    1298:	01690101 	cmneq	r9, r1, lsl #2
    129c:	00030000 	andeq	r0, r3, r0
    12a0:	00000068 	andeq	r0, r0, r8, rrx
    12a4:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
    12a8:	0101000d 	tsteq	r1, sp
    12ac:	00000101 	andeq	r0, r0, r1, lsl #2
    12b0:	00000100 	andeq	r0, r0, r0, lsl #2
    12b4:	2f2e2e01 	svccs	0x002e2e01
    12b8:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    12bc:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    12c0:	2f2e2e2f 	svccs	0x002e2e2f
    12c4:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; 1214 <shift+0x1214>
    12c8:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    12cc:	2e2e0063 	cdpcs	0, 2, cr0, cr14, cr3, {3}
    12d0:	2f2e2e2f 	svccs	0x002e2e2f
    12d4:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    12d8:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    12dc:	672f2e2f 	strvs	r2, [pc, -pc, lsr #28]!
    12e0:	00006363 	andeq	r6, r0, r3, ror #6
    12e4:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    12e8:	2e326363 	cdpcs	3, 3, cr6, cr2, cr3, {3}
    12ec:	00010063 	andeq	r0, r1, r3, rrx
    12f0:	6d726100 	ldfvse	f6, [r2, #-0]
    12f4:	6173692d 	cmnvs	r3, sp, lsr #18
    12f8:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
    12fc:	696c0000 	stmdbvs	ip!, {}^	; <UNPREDICTABLE>
    1300:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    1304:	00682e32 	rsbeq	r2, r8, r2, lsr lr
    1308:	00000001 	andeq	r0, r0, r1
    130c:	05000105 	streq	r0, [r0, #-261]	; 0xfffffefb
    1310:	009de802 	addseq	lr, sp, r2, lsl #16
    1314:	07b30300 	ldreq	r0, [r3, r0, lsl #6]!
    1318:	13030501 	movwne	r0, #13569	; 0x3501
    131c:	010a0313 	tsteq	sl, r3, lsl r3
    1320:	01060605 	tsteq	r6, r5, lsl #12
    1324:	74030105 	strvc	r0, [r3], #-261	; 0xfffffefb
    1328:	2f0b054a 	svccs	0x000b054a
    132c:	052d0105 	streq	r0, [sp, #-261]!	; 0xfffffefb
    1330:	06052f0b 	streq	r2, [r5], -fp, lsl #30
    1334:	052e0b03 	streq	r0, [lr, #-2819]!	; 0xfffff4fd
    1338:	05300607 	ldreq	r0, [r0, #-1543]!	; 0xfffff9f9
    133c:	0501060d 	streq	r0, [r1, #-1549]	; 0xfffff9f3
    1340:	05830607 	streq	r0, [r3, #1543]	; 0x607
    1344:	4a01060d 	bmi	42b80 <__bss_end+0x38844>
    1348:	4c060705 	stcmi	7, cr0, [r6], {5}
    134c:	01060905 	tsteq	r6, r5, lsl #18
    1350:	2f060705 	svccs	0x00060705
    1354:	01060905 	tsteq	r6, r5, lsl #18
    1358:	0607052e 	streq	r0, [r7], -lr, lsr #10
    135c:	060a05a5 	streq	r0, [sl], -r5, lsr #11
    1360:	0b052e01 	bleq	14cb6c <__bss_end+0x142830>
    1364:	052e6803 	streq	r6, [lr, #-2051]!	; 0xfffff7fd
    1368:	4a18030a 	bmi	601f98 <__bss_end+0x5f7c5c>
    136c:	30060405 	andcc	r0, r6, r5, lsl #8
    1370:	13060605 	movwne	r0, #26117	; 0x6605
    1374:	05492f49 	strbeq	r2, [r9, #-3913]	; 0xfffff0b7
    1378:	052f0604 	streq	r0, [pc, #-1540]!	; d7c <shift+0xd7c>
    137c:	0a051507 	beq	1467a0 <__bss_end+0x13c464>
    1380:	04050106 	streq	r0, [r5], #-262	; 0xfffffefa
    1384:	06054c06 	streq	r4, [r5], -r6, lsl #24
    1388:	052e0106 	streq	r0, [lr, #-262]!	; 0xfffffefa
    138c:	054e0604 	strbeq	r0, [lr, #-1540]	; 0xfffff9fc
    1390:	050e0606 	streq	r0, [lr, #-1542]	; 0xfffff9fa
    1394:	1005520b 	andne	r5, r5, fp, lsl #4
    1398:	4a05054a 	bmi	1428c8 <__bss_end+0x13858c>
    139c:	0608052e 	streq	r0, [r8], -lr, lsr #10
    13a0:	130e0531 	movwne	r0, #58673	; 0xe531
    13a4:	01060605 	tsteq	r6, r5, lsl #12
    13a8:	0604052e 	streq	r0, [r4], -lr, lsr #10
    13ac:	052e7903 	streq	r7, [lr, #-2307]!	; 0xfffff6fd
    13b0:	03051408 	movweq	r1, #21512	; 0x5408
    13b4:	0b051413 	bleq	146408 <__bss_end+0x13c0cc>
    13b8:	05050f06 	streq	r0, [r5, #-3846]	; 0xfffff0fa
    13bc:	08052e69 	stmdaeq	r5, {r0, r3, r5, r6, r9, sl, fp, sp}
    13c0:	0e052f06 	cdpeq	15, 0, cr2, cr5, cr6, {0}
    13c4:	06060513 			; <UNDEFINED> instruction: 0x06060513
    13c8:	04052e01 	streq	r2, [r5], #-3585	; 0xfffff1ff
    13cc:	06053206 	streq	r3, [r5], -r6, lsl #4
    13d0:	492f0106 	stmdbmi	pc!, {r1, r2, r8}	; <UNPREDICTABLE>
    13d4:	2f060405 	svccs	0x00060405
    13d8:	01060605 	tsteq	r6, r5, lsl #12
    13dc:	4b060405 	blmi	1823f8 <__bss_end+0x1780bc>
    13e0:	01060f05 	tsteq	r6, r5, lsl #30
    13e4:	4a06054a 	bmi	182914 <__bss_end+0x1785d8>
    13e8:	0603052e 	streq	r0, [r3], -lr, lsr #10
    13ec:	06060532 			; <UNDEFINED> instruction: 0x06060532
    13f0:	06050501 	streq	r0, [r5], -r1, lsl #10
    13f4:	0609052f 	streq	r0, [r9], -pc, lsr #10
    13f8:	06030501 	streq	r0, [r3], -r1, lsl #10
    13fc:	0601052f 	streq	r0, [r1], -pc, lsr #10
    1400:	04022e13 	streq	r2, [r2], #-3603	; 0xfffff1ed
    1404:	Address 0x0000000000001404 is out of bounds.


Disassembly of section .debug_info:

00000000 <.debug_info>:
       0:	00000022 	andeq	r0, r0, r2, lsr #32
       4:	00000002 	andeq	r0, r0, r2
       8:	01040000 	mrseq	r0, (UNDEF: 4)
       c:	00000000 	andeq	r0, r0, r0
      10:	00008000 	andeq	r8, r0, r0
      14:	00008008 	andeq	r8, r0, r8
      18:	00000000 	andeq	r0, r0, r0
      1c:	0000002a 	andeq	r0, r0, sl, lsr #32
      20:	00000053 	andeq	r0, r0, r3, asr r0
      24:	00a48001 	adceq	r8, r4, r1
      28:	00040000 	andeq	r0, r4, r0
      2c:	00000014 	andeq	r0, r0, r4, lsl r0
      30:	005f0104 	subseq	r0, pc, r4, lsl #2
      34:	fb0c0000 	blx	30003e <__bss_end+0x2f5d02>
      38:	2a000000 	bcs	40 <shift+0x40>
      3c:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
      40:	9c000080 	stcls	0, cr0, [r0], {128}	; 0x80
      44:	5a000000 	bpl	4c <shift+0x4c>
      48:	02000000 	andeq	r0, r0, #0
      4c:	0000012c 	andeq	r0, r0, ip, lsr #2
      50:	31150601 	tstcc	r5, r1, lsl #12
      54:	03000000 	movweq	r0, #0
      58:	188d0704 	stmne	sp, {r2, r8, r9, sl}
      5c:	f1020000 	cps	#0
      60:	01000000 	mrseq	r0, (UNDEF: 0)
      64:	00311507 	eorseq	r1, r1, r7, lsl #10
      68:	48040000 	stmdami	r4, {}	; <UNPREDICTABLE>
      6c:	01000001 	tsteq	r0, r1
      70:	8064060f 	rsbhi	r0, r4, pc, lsl #12
      74:	00400000 	subeq	r0, r0, r0
      78:	9c010000 	stcls	0, cr0, [r1], {-0}
      7c:	0000006a 	andeq	r0, r0, sl, rrx
      80:	00012505 	andeq	r2, r1, r5, lsl #10
      84:	091a0100 	ldmdbeq	sl, {r8}
      88:	0000006a 	andeq	r0, r0, sl, rrx
      8c:	00749102 	rsbseq	r9, r4, r2, lsl #2
      90:	69050406 	stmdbvs	r5, {r1, r2, sl}
      94:	0700746e 	streq	r7, [r0, -lr, ror #8]
      98:	00000138 	andeq	r0, r0, r8, lsr r1
      9c:	08060901 	stmdaeq	r6, {r0, r8, fp}
      a0:	5c000080 	stcpl	0, cr0, [r0], {128}	; 0x80
      a4:	01000000 	mrseq	r0, (UNDEF: 0)
      a8:	0000a19c 	muleq	r0, ip, r1
      ac:	80140800 	andshi	r0, r4, r0, lsl #16
      b0:	00340000 	eorseq	r0, r4, r0
      b4:	63090000 	movwvs	r0, #36864	; 0x9000
      b8:	01007275 	tsteq	r0, r5, ror r2
      bc:	00a1180b 	adceq	r1, r1, fp, lsl #16
      c0:	91020000 	mrsls	r0, (UNDEF: 2)
      c4:	0a000074 	beq	29c <shift+0x29c>
      c8:	00003104 	andeq	r3, r0, r4, lsl #2
      cc:	02020000 	andeq	r0, r2, #0
      d0:	00040000 	andeq	r0, r4, r0
      d4:	000000b9 	strheq	r0, [r0], -r9
      d8:	025e0104 	subseq	r0, lr, #4, 2
      dc:	91040000 	mrsls	r0, (UNDEF: 4)
      e0:	2a000001 	bcs	ec <shift+0xec>
      e4:	a4000000 	strge	r0, [r0], #-0
      e8:	88000080 	stmdahi	r0, {r7}
      ec:	e3000001 	movw	r0, #1
      f0:	02000000 	andeq	r0, r0, #0
      f4:	0000031a 	andeq	r0, r0, sl, lsl r3
      f8:	31072f01 	tstcc	r7, r1, lsl #30
      fc:	03000000 	movweq	r0, #0
     100:	00003704 	andeq	r3, r0, r4, lsl #14
     104:	20020400 	andcs	r0, r2, r0, lsl #8
     108:	01000002 	tsteq	r0, r2
     10c:	00310730 	eorseq	r0, r1, r0, lsr r7
     110:	25050000 	strcs	r0, [r5, #-0]
     114:	57000000 	strpl	r0, [r0, -r0]
     118:	06000000 	streq	r0, [r0], -r0
     11c:	00000057 	andeq	r0, r0, r7, asr r0
     120:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
     124:	07040700 	streq	r0, [r4, -r0, lsl #14]
     128:	0000188d 	andeq	r1, r0, sp, lsl #17
     12c:	00030c08 	andeq	r0, r3, r8, lsl #24
     130:	15330100 	ldrne	r0, [r3, #-256]!	; 0xffffff00
     134:	00000044 	andeq	r0, r0, r4, asr #32
     138:	0001e608 	andeq	lr, r1, r8, lsl #12
     13c:	15350100 	ldrne	r0, [r5, #-256]!	; 0xffffff00
     140:	00000044 	andeq	r0, r0, r4, asr #32
     144:	00003805 	andeq	r3, r0, r5, lsl #16
     148:	00008900 	andeq	r8, r0, r0, lsl #18
     14c:	00570600 	subseq	r0, r7, r0, lsl #12
     150:	ffff0000 			; <UNDEFINED> instruction: 0xffff0000
     154:	0800ffff 	stmdaeq	r0, {r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, fp, ip, sp, lr, pc}
     158:	00000200 	andeq	r0, r0, r0, lsl #4
     15c:	76153801 	ldrvc	r3, [r5], -r1, lsl #16
     160:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
     164:	00000229 	andeq	r0, r0, r9, lsr #4
     168:	76153a01 	ldrvc	r3, [r5], -r1, lsl #20
     16c:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
     170:	00000172 	andeq	r0, r0, r2, ror r1
     174:	cb104801 	blgt	412180 <__bss_end+0x407e44>
     178:	d4000000 	strle	r0, [r0], #-0
     17c:	58000081 	stmdapl	r0, {r0, r7}
     180:	01000000 	mrseq	r0, (UNDEF: 0)
     184:	0000cb9c 	muleq	r0, ip, fp
     188:	01800a00 	orreq	r0, r0, r0, lsl #20
     18c:	4a010000 	bmi	40194 <__bss_end+0x35e58>
     190:	0000d20c 	andeq	sp, r0, ip, lsl #4
     194:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     198:	05040b00 	streq	r0, [r4, #-2816]	; 0xfffff500
     19c:	00746e69 	rsbseq	r6, r4, r9, ror #28
     1a0:	00380403 	eorseq	r0, r8, r3, lsl #8
     1a4:	51090000 	mrspl	r0, (UNDEF: 9)
     1a8:	01000002 	tsteq	r0, r2
     1ac:	00cb103c 	sbceq	r1, fp, ip, lsr r0
     1b0:	817c0000 	cmnhi	ip, r0
     1b4:	00580000 	subseq	r0, r8, r0
     1b8:	9c010000 	stcls	0, cr0, [r1], {-0}
     1bc:	00000102 	andeq	r0, r0, r2, lsl #2
     1c0:	0001800a 	andeq	r8, r1, sl
     1c4:	0c3e0100 	ldfeqs	f0, [lr], #-0
     1c8:	00000102 	andeq	r0, r0, r2, lsl #2
     1cc:	00749102 	rsbseq	r9, r4, r2, lsl #2
     1d0:	00250403 	eoreq	r0, r5, r3, lsl #8
     1d4:	5b0c0000 	blpl	3001dc <__bss_end+0x2f5ea0>
     1d8:	01000001 	tsteq	r0, r1
     1dc:	81701129 	cmnhi	r0, r9, lsr #2
     1e0:	000c0000 	andeq	r0, ip, r0
     1e4:	9c010000 	stcls	0, cr0, [r1], {-0}
     1e8:	0001bf0c 	andeq	fp, r1, ip, lsl #30
     1ec:	11240100 			; <UNDEFINED> instruction: 0x11240100
     1f0:	00008158 	andeq	r8, r0, r8, asr r1
     1f4:	00000018 	andeq	r0, r0, r8, lsl r0
     1f8:	360c9c01 	strcc	r9, [ip], -r1, lsl #24
     1fc:	01000002 	tsteq	r0, r2
     200:	8140111f 	cmphi	r0, pc, lsl r1
     204:	00180000 	andseq	r0, r8, r0
     208:	9c010000 	stcls	0, cr0, [r1], {-0}
     20c:	0001f30c 	andeq	pc, r1, ip, lsl #6
     210:	111a0100 	tstne	sl, r0, lsl #2
     214:	00008128 	andeq	r8, r0, r8, lsr #2
     218:	00000018 	andeq	r0, r0, r8, lsl r0
     21c:	860d9c01 	strhi	r9, [sp], -r1, lsl #24
     220:	02000001 	andeq	r0, r0, #1
     224:	00019e00 	andeq	r9, r1, r0, lsl #28
     228:	020e0e00 	andeq	r0, lr, #0, 28
     22c:	14010000 	strne	r0, [r1], #-0
     230:	00016d12 	andeq	r6, r1, r2, lsl sp
     234:	019e0f00 	orrseq	r0, lr, r0, lsl #30
     238:	02000000 	andeq	r0, r0, #0
     23c:	00000153 	andeq	r0, r0, r3, asr r1
     240:	a41c0401 	ldrge	r0, [ip], #-1025	; 0xfffffbff
     244:	0e000001 	cdpeq	0, 0, cr0, cr0, cr1, {0}
     248:	000001d2 	ldrdeq	r0, [r0], -r2
     24c:	8b120f01 	blhi	483e58 <__bss_end+0x479b1c>
     250:	0f000001 	svceq	0x00000001
     254:	0000019e 	muleq	r0, lr, r1
     258:	03231000 			; <UNDEFINED> instruction: 0x03231000
     25c:	0a010000 	beq	40264 <__bss_end+0x35f28>
     260:	0000cb11 	andeq	ip, r0, r1, lsl fp
     264:	019e0f00 	orrseq	r0, lr, r0, lsl #30
     268:	00000000 	andeq	r0, r0, r0
     26c:	016d0403 	cmneq	sp, r3, lsl #8
     270:	08070000 	stmdaeq	r7, {}	; <UNPREDICTABLE>
     274:	00024305 	andeq	r4, r2, r5, lsl #6
     278:	015b1100 	cmpeq	fp, r0, lsl #2
     27c:	81080000 	mrshi	r0, (UNDEF: 8)
     280:	00200000 	eoreq	r0, r0, r0
     284:	9c010000 	stcls	0, cr0, [r1], {-0}
     288:	000001c7 	andeq	r0, r0, r7, asr #3
     28c:	00019e12 	andeq	r9, r1, r2, lsl lr
     290:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     294:	01791100 	cmneq	r9, r0, lsl #2
     298:	80dc0000 	sbcshi	r0, ip, r0
     29c:	002c0000 	eoreq	r0, ip, r0
     2a0:	9c010000 	stcls	0, cr0, [r1], {-0}
     2a4:	000001e8 	andeq	r0, r0, r8, ror #3
     2a8:	01006713 	tsteq	r0, r3, lsl r7
     2ac:	019e300f 	orrseq	r3, lr, pc
     2b0:	91020000 	mrsls	r0, (UNDEF: 2)
     2b4:	8b140074 	blhi	50048c <__bss_end+0x4f6150>
     2b8:	a4000001 	strge	r0, [r0], #-1
     2bc:	38000080 	stmdacc	r0, {r7}
     2c0:	01000000 	mrseq	r0, (UNDEF: 0)
     2c4:	0067139c 	mlseq	r7, ip, r3, r1
     2c8:	9e2f0a01 	vmulls.f32	s0, s30, s2
     2cc:	02000001 	andeq	r0, r0, #1
     2d0:	00007491 	muleq	r0, r1, r4
     2d4:	000009e4 	andeq	r0, r0, r4, ror #19
     2d8:	01e00004 	mvneq	r0, r4
     2dc:	01040000 	mrseq	r0, (UNDEF: 4)
     2e0:	0000025e 	andeq	r0, r0, lr, asr r2
     2e4:	0005fe04 	andeq	pc, r5, r4, lsl #28
     2e8:	00002a00 	andeq	r2, r0, r0, lsl #20
     2ec:	00822c00 	addeq	r2, r2, r0, lsl #24
     2f0:	0000a800 	andeq	sl, r0, r0, lsl #16
     2f4:	0001c200 	andeq	ip, r1, r0, lsl #4
     2f8:	08010200 	stmdaeq	r1, {r9}
     2fc:	00000b60 	andeq	r0, r0, r0, ror #22
     300:	00002503 	andeq	r2, r0, r3, lsl #10
     304:	05020200 	streq	r0, [r2, #-512]	; 0xfffffe00
     308:	000009ec 	andeq	r0, r0, ip, ror #19
     30c:	69050404 	stmdbvs	r5, {r2, sl}
     310:	0200746e 	andeq	r7, r0, #1845493760	; 0x6e000000
     314:	0b570801 	bleq	15c2320 <__bss_end+0x15b7fe4>
     318:	80050000 	andhi	r0, r5, r0
     31c:	02000009 	andeq	r0, r0, #9
     320:	00520708 	subseq	r0, r2, r8, lsl #14
     324:	02020000 	andeq	r0, r2, #0
     328:	000c3107 	andeq	r3, ip, r7, lsl #2
     32c:	05a80500 	streq	r0, [r8, #1280]!	; 0x500
     330:	09020000 	stmdbeq	r2, {}	; <UNPREDICTABLE>
     334:	00006a07 	andeq	r6, r0, r7, lsl #20
     338:	00590300 	subseq	r0, r9, r0, lsl #6
     33c:	04020000 	streq	r0, [r2], #-0
     340:	00188d07 	andseq	r8, r8, r7, lsl #26
     344:	006a0300 	rsbeq	r0, sl, r0, lsl #6
     348:	e5060000 	str	r0, [r6, #-0]
     34c:	0800000c 	stmdaeq	r0, {r2, r3}
     350:	9c080603 	stcls	6, cr0, [r8], {3}
     354:	07000000 	streq	r0, [r0, -r0]
     358:	03003072 	movweq	r3, #114	; 0x72
     35c:	00590e08 	subseq	r0, r9, r8, lsl #28
     360:	07000000 	streq	r0, [r0, -r0]
     364:	03003172 	movweq	r3, #370	; 0x172
     368:	00590e09 	subseq	r0, r9, r9, lsl #28
     36c:	00040000 	andeq	r0, r4, r0
     370:	000a5508 	andeq	r5, sl, r8, lsl #10
     374:	38040500 	stmdacc	r4, {r8, sl}
     378:	03000000 	movweq	r0, #0
     37c:	00df0c1e 	sbcseq	r0, pc, lr, lsl ip	; <UNPREDICTABLE>
     380:	a0090000 	andge	r0, r9, r0
     384:	00000005 	andeq	r0, r0, r5
     388:	00073d09 	andeq	r3, r7, r9, lsl #26
     38c:	77090100 	strvc	r0, [r9, -r0, lsl #2]
     390:	0200000a 	andeq	r0, r0, #10
     394:	000b7a09 	andeq	r7, fp, r9, lsl #20
     398:	1b090300 	blne	240fa0 <__bss_end+0x236c64>
     39c:	04000007 	streq	r0, [r0], #-7
     3a0:	0009e309 	andeq	lr, r9, r9, lsl #6
     3a4:	65090500 	strvs	r0, [r9, #-1280]	; 0xfffffb00
     3a8:	0600000b 	streq	r0, [r0], -fp
     3ac:	000bc409 	andeq	ip, fp, r9, lsl #8
     3b0:	08000700 	stmdaeq	r0, {r8, r9, sl}
     3b4:	00000a3d 	andeq	r0, r0, sp, lsr sl
     3b8:	00380405 	eorseq	r0, r8, r5, lsl #8
     3bc:	49030000 	stmdbmi	r3, {}	; <UNPREDICTABLE>
     3c0:	00011c0c 	andeq	r1, r1, ip, lsl #24
     3c4:	06b90900 	ldrteq	r0, [r9], r0, lsl #18
     3c8:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
     3cc:	00000738 	andeq	r0, r0, r8, lsr r7
     3d0:	0c7e0901 			; <UNDEFINED> instruction: 0x0c7e0901
     3d4:	09020000 	stmdbeq	r2, {}	; <UNPREDICTABLE>
     3d8:	0000092e 	andeq	r0, r0, lr, lsr #18
     3dc:	072a0903 	streq	r0, [sl, -r3, lsl #18]!
     3e0:	09040000 	stmdbeq	r4, {}	; <UNPREDICTABLE>
     3e4:	000007b8 			; <UNDEFINED> instruction: 0x000007b8
     3e8:	05ed0905 	strbeq	r0, [sp, #2309]!	; 0x905
     3ec:	00060000 	andeq	r0, r6, r0
     3f0:	00090c0a 	andeq	r0, r9, sl, lsl #24
     3f4:	14050400 	strne	r0, [r5], #-1024	; 0xfffffc00
     3f8:	00000065 	andeq	r0, r0, r5, rrx
     3fc:	9f080305 	svcls	0x00080305
     400:	e10a0000 	mrs	r0, (UNDEF: 10)
     404:	0400000a 	streq	r0, [r0], #-10
     408:	00651406 	rsbeq	r1, r5, r6, lsl #8
     40c:	03050000 	movweq	r0, #20480	; 0x5000
     410:	00009f0c 	andeq	r9, r0, ip, lsl #30
     414:	0007cd0a 	andeq	ip, r7, sl, lsl #26
     418:	1a070500 	bne	1c1820 <__bss_end+0x1b74e4>
     41c:	00000065 	andeq	r0, r0, r5, rrx
     420:	9f100305 	svcls	0x00100305
     424:	050a0000 	streq	r0, [sl, #-0]
     428:	0500000a 	streq	r0, [r0, #-10]
     42c:	00651a09 	rsbeq	r1, r5, r9, lsl #20
     430:	03050000 	movweq	r0, #20480	; 0x5000
     434:	00009f14 	andeq	r9, r0, r4, lsl pc
     438:	0007bf0a 	andeq	fp, r7, sl, lsl #30
     43c:	1a0b0500 	bne	2c1844 <__bss_end+0x2b7508>
     440:	00000065 	andeq	r0, r0, r5, rrx
     444:	9f180305 	svcls	0x00180305
     448:	b90a0000 	stmdblt	sl, {}	; <UNPREDICTABLE>
     44c:	05000009 	streq	r0, [r0, #-9]
     450:	00651a0d 	rsbeq	r1, r5, sp, lsl #20
     454:	03050000 	movweq	r0, #20480	; 0x5000
     458:	00009f1c 	andeq	r9, r0, ip, lsl pc
     45c:	0005800a 	andeq	r8, r5, sl
     460:	1a0f0500 	bne	3c1868 <__bss_end+0x3b752c>
     464:	00000065 	andeq	r0, r0, r5, rrx
     468:	9f200305 	svcls	0x00200305
     46c:	d0080000 	andle	r0, r8, r0
     470:	05000010 	streq	r0, [r0, #-16]
     474:	00003804 	andeq	r3, r0, r4, lsl #16
     478:	0c1b0500 	cfldr32eq	mvfx0, [fp], {-0}
     47c:	000001bf 			; <UNDEFINED> instruction: 0x000001bf
     480:	00050c09 	andeq	r0, r5, r9, lsl #24
     484:	a5090000 	strge	r0, [r9, #-0]
     488:	0100000b 	tsteq	r0, fp
     48c:	000c7909 	andeq	r7, ip, r9, lsl #18
     490:	0b000200 	bleq	c98 <shift+0xc98>
     494:	000003a7 	andeq	r0, r0, r7, lsr #7
     498:	57020102 	strpl	r0, [r2, -r2, lsl #2]
     49c:	0c000008 	stceq	0, cr0, [r0], {8}
     4a0:	00002c04 	andeq	r2, r0, r4, lsl #24
     4a4:	bf040c00 	svclt	0x00040c00
     4a8:	0a000001 	beq	4b4 <shift+0x4b4>
     4ac:	00000516 	andeq	r0, r0, r6, lsl r5
     4b0:	65140406 	ldrvs	r0, [r4, #-1030]	; 0xfffffbfa
     4b4:	05000000 	streq	r0, [r0, #-0]
     4b8:	009f2403 	addseq	r2, pc, r3, lsl #8
     4bc:	0a7d0a00 	beq	1f42cc4 <__bss_end+0x1f38988>
     4c0:	07060000 	streq	r0, [r6, -r0]
     4c4:	00006514 	andeq	r6, r0, r4, lsl r5
     4c8:	28030500 	stmdacs	r3, {r8, sl}
     4cc:	0a00009f 	beq	750 <shift+0x750>
     4d0:	0000044d 	andeq	r0, r0, sp, asr #8
     4d4:	65140a06 	ldrvs	r0, [r4, #-2566]	; 0xfffff5fa
     4d8:	05000000 	streq	r0, [r0, #-0]
     4dc:	009f2c03 	addseq	r2, pc, r3, lsl #24
     4e0:	05f20800 	ldrbeq	r0, [r2, #2048]!	; 0x800
     4e4:	04050000 	streq	r0, [r5], #-0
     4e8:	00000038 	andeq	r0, r0, r8, lsr r0
     4ec:	440c0d06 	strmi	r0, [ip], #-3334	; 0xfffff2fa
     4f0:	0d000002 	stceq	0, cr0, [r0, #-8]
     4f4:	0077654e 	rsbseq	r6, r7, lr, asr #10
     4f8:	04100900 	ldreq	r0, [r0], #-2304	; 0xfffff700
     4fc:	09010000 	stmdbeq	r1, {}	; <UNPREDICTABLE>
     500:	00000445 	andeq	r0, r0, r5, asr #8
     504:	06410902 	strbeq	r0, [r1], -r2, lsl #18
     508:	09030000 	stmdbeq	r3, {}	; <UNPREDICTABLE>
     50c:	00000b6c 	andeq	r0, r0, ip, ror #22
     510:	04040904 	streq	r0, [r4], #-2308	; 0xfffff6fc
     514:	00050000 	andeq	r0, r5, r0
     518:	00052f06 	andeq	r2, r5, r6, lsl #30
     51c:	1b061000 	blne	184524 <__bss_end+0x17a1e8>
     520:	00028308 	andeq	r8, r2, r8, lsl #6
     524:	726c0700 	rsbvc	r0, ip, #0, 14
     528:	131d0600 	tstne	sp, #0, 12
     52c:	00000283 	andeq	r0, r0, r3, lsl #5
     530:	70730700 	rsbsvc	r0, r3, r0, lsl #14
     534:	131e0600 	tstne	lr, #0, 12
     538:	00000283 	andeq	r0, r0, r3, lsl #5
     53c:	63700704 	cmnvs	r0, #4, 14	; 0x100000
     540:	131f0600 	tstne	pc, #0, 12
     544:	00000283 	andeq	r0, r0, r3, lsl #5
     548:	0a370e08 	beq	dc3d70 <__bss_end+0xdb9a34>
     54c:	20060000 	andcs	r0, r6, r0
     550:	00028313 	andeq	r8, r2, r3, lsl r3
     554:	02000c00 	andeq	r0, r0, #0, 24
     558:	18880704 	stmne	r8, {r2, r8, r9, sl}
     55c:	83030000 	movwhi	r0, #12288	; 0x3000
     560:	06000002 	streq	r0, [r0], -r2
     564:	0000070e 	andeq	r0, r0, lr, lsl #14
     568:	0828067c 	stmdaeq	r8!, {r2, r3, r4, r5, r6, r9, sl}
     56c:	00000346 	andeq	r0, r0, r6, asr #6
     570:	00069e0e 	andeq	r9, r6, lr, lsl #28
     574:	122a0600 	eorne	r0, sl, #0, 12
     578:	00000244 	andeq	r0, r0, r4, asr #4
     57c:	69700700 	ldmdbvs	r0!, {r8, r9, sl}^
     580:	2b060064 	blcs	180718 <__bss_end+0x1763dc>
     584:	00006a12 	andeq	r6, r0, r2, lsl sl
     588:	9f0e1000 	svcls	0x000e1000
     58c:	0600000b 	streq	r0, [r0], -fp
     590:	020d112c 	andeq	r1, sp, #44, 2
     594:	0e140000 	cdpeq	0, 1, cr0, cr4, cr0, {0}
     598:	00000b49 	andeq	r0, r0, r9, asr #22
     59c:	6a122d06 	bvs	48b9bc <__bss_end+0x481680>
     5a0:	18000000 	stmdane	r0, {}	; <UNPREDICTABLE>
     5a4:	0003370e 	andeq	r3, r3, lr, lsl #14
     5a8:	122e0600 	eorne	r0, lr, #0, 12
     5ac:	0000006a 	andeq	r0, r0, sl, rrx
     5b0:	0a6a0e1c 	beq	1a83e28 <__bss_end+0x1a79aec>
     5b4:	2f060000 	svccs	0x00060000
     5b8:	0003460c 	andeq	r4, r3, ip, lsl #12
     5bc:	c00e2000 	andgt	r2, lr, r0
     5c0:	06000003 	streq	r0, [r0], -r3
     5c4:	00380930 	eorseq	r0, r8, r0, lsr r9
     5c8:	0e600000 	cdpeq	0, 6, cr0, cr0, cr0, {0}
     5cc:	0000065c 	andeq	r0, r0, ip, asr r6
     5d0:	590e3106 	stmdbpl	lr, {r1, r2, r8, ip, sp}
     5d4:	64000000 	strvs	r0, [r0], #-0
     5d8:	0009720e 	andeq	r7, r9, lr, lsl #4
     5dc:	0e330600 	cfmsuba32eq	mvax0, mvax0, mvfx3, mvfx0
     5e0:	00000059 	andeq	r0, r0, r9, asr r0
     5e4:	09690e68 	stmdbeq	r9!, {r3, r5, r6, r9, sl, fp}^
     5e8:	34060000 	strcc	r0, [r6], #-0
     5ec:	0000590e 	andeq	r5, r0, lr, lsl #18
     5f0:	b10e6c00 	tstlt	lr, r0, lsl #24
     5f4:	06000005 	streq	r0, [r0], -r5
     5f8:	00590e35 	subseq	r0, r9, r5, lsr lr
     5fc:	0e700000 	cdpeq	0, 7, cr0, cr0, cr0, {0}
     600:	00000a28 	andeq	r0, r0, r8, lsr #20
     604:	590e3606 	stmdbpl	lr, {r1, r2, r9, sl, ip, sp}
     608:	74000000 	strvc	r0, [r0], #-0
     60c:	000c540e 	andeq	r5, ip, lr, lsl #8
     610:	0e370600 	cfmsuba32eq	mvax0, mvax0, mvfx7, mvfx0
     614:	00000059 	andeq	r0, r0, r9, asr r0
     618:	d10f0078 	tstle	pc, r8, ror r0	; <UNPREDICTABLE>
     61c:	56000001 	strpl	r0, [r0], -r1
     620:	10000003 	andne	r0, r0, r3
     624:	0000006a 	andeq	r0, r0, sl, rrx
     628:	360a000f 	strcc	r0, [sl], -pc
     62c:	07000004 	streq	r0, [r0, -r4]
     630:	0065140a 	rsbeq	r1, r5, sl, lsl #8
     634:	03050000 	movweq	r0, #20480	; 0x5000
     638:	00009f30 	andeq	r9, r0, r0, lsr pc
     63c:	00080808 	andeq	r0, r8, r8, lsl #16
     640:	38040500 	stmdacc	r4, {r8, sl}
     644:	07000000 	streq	r0, [r0, -r0]
     648:	03870c0d 	orreq	r0, r7, #3328	; 0xd00
     64c:	84090000 	strhi	r0, [r9], #-0
     650:	0000000c 	andeq	r0, r0, ip
     654:	000bb909 	andeq	fp, fp, r9, lsl #18
     658:	06000100 	streq	r0, [r0], -r0, lsl #2
     65c:	0000068b 	andeq	r0, r0, fp, lsl #13
     660:	081b070c 	ldmdaeq	fp, {r2, r3, r8, r9, sl}
     664:	000003bc 			; <UNDEFINED> instruction: 0x000003bc
     668:	0004a90e 	andeq	sl, r4, lr, lsl #18
     66c:	191d0700 	ldmdbne	sp, {r8, r9, sl}
     670:	000003bc 			; <UNDEFINED> instruction: 0x000003bc
     674:	040b0e00 	streq	r0, [fp], #-3584	; 0xfffff200
     678:	1e070000 	cdpne	0, 0, cr0, cr7, cr0, {0}
     67c:	0003bc19 	andeq	fp, r3, r9, lsl ip
     680:	2c0e0400 	cfstrscs	mvf0, [lr], {-0}
     684:	07000008 	streq	r0, [r0, -r8]
     688:	03c2131f 	biceq	r1, r2, #2080374784	; 0x7c000000
     68c:	00080000 	andeq	r0, r8, r0
     690:	0387040c 	orreq	r0, r7, #12, 8	; 0xc000000
     694:	040c0000 	streq	r0, [ip], #-0
     698:	0000028f 	andeq	r0, r0, pc, lsl #5
     69c:	000a1711 	andeq	r1, sl, r1, lsl r7
     6a0:	22071400 	andcs	r1, r7, #0, 8
     6a4:	00068907 	andeq	r8, r6, r7, lsl #18
     6a8:	091a0e00 	ldmdbeq	sl, {r9, sl, fp}
     6ac:	26070000 	strcs	r0, [r7], -r0
     6b0:	00005912 	andeq	r5, r0, r2, lsl r9
     6b4:	bc0e0000 	stclt	0, cr0, [lr], {-0}
     6b8:	07000008 	streq	r0, [r0, -r8]
     6bc:	03bc1d29 			; <UNDEFINED> instruction: 0x03bc1d29
     6c0:	0e040000 	cdpeq	0, 0, cr0, cr4, cr0, {0}
     6c4:	00000649 	andeq	r0, r0, r9, asr #12
     6c8:	bc1d2c07 	ldclt	12, cr2, [sp], {7}
     6cc:	08000003 	stmdaeq	r0, {r0, r1}
     6d0:	00092412 	andeq	r2, r9, r2, lsl r4
     6d4:	0e2f0700 	cdpeq	7, 2, cr0, cr15, cr0, {0}
     6d8:	00000668 	andeq	r0, r0, r8, ror #12
     6dc:	00000410 	andeq	r0, r0, r0, lsl r4
     6e0:	0000041b 	andeq	r0, r0, fp, lsl r4
     6e4:	00068e13 	andeq	r8, r6, r3, lsl lr
     6e8:	03bc1400 			; <UNDEFINED> instruction: 0x03bc1400
     6ec:	15000000 	strne	r0, [r0, #-0]
     6f0:	00000759 	andeq	r0, r0, r9, asr r7
     6f4:	e50e3107 	str	r3, [lr, #-263]	; 0xfffffef9
     6f8:	c4000006 	strgt	r0, [r0], #-6
     6fc:	33000001 	movwcc	r0, #1
     700:	3e000004 	cdpcc	0, 0, cr0, cr0, cr4, {0}
     704:	13000004 	movwne	r0, #4
     708:	0000068e 	andeq	r0, r0, lr, lsl #13
     70c:	0003c214 	andeq	ip, r3, r4, lsl r2
     710:	80160000 	andshi	r0, r6, r0
     714:	0700000b 	streq	r0, [r0, -fp]
     718:	07e31d35 			; <UNDEFINED> instruction: 0x07e31d35
     71c:	03bc0000 			; <UNDEFINED> instruction: 0x03bc0000
     720:	57020000 	strpl	r0, [r2, -r0]
     724:	5d000004 	stcpl	0, cr0, [r0, #-16]
     728:	13000004 	movwne	r0, #4
     72c:	0000068e 	andeq	r0, r0, lr, lsl #13
     730:	06341600 	ldrteq	r1, [r4], -r0, lsl #12
     734:	37070000 	strcc	r0, [r7, -r0]
     738:	0009341d 	andeq	r3, r9, sp, lsl r4
     73c:	0003bc00 	andeq	fp, r3, r0, lsl #24
     740:	04760200 	ldrbteq	r0, [r6], #-512	; 0xfffffe00
     744:	047c0000 	ldrbteq	r0, [ip], #-0
     748:	8e130000 	cdphi	0, 1, cr0, cr3, cr0, {0}
     74c:	00000006 	andeq	r0, r0, r6
     750:	0008cf17 	andeq	ip, r8, r7, lsl pc
     754:	31390700 	teqcc	r9, r0, lsl #14
     758:	000006a7 	andeq	r0, r0, r7, lsr #13
     75c:	1716020c 	ldrne	r0, [r6, -ip, lsl #4]
     760:	0700000a 	streq	r0, [r0, -sl]
     764:	0768093c 			; <UNDEFINED> instruction: 0x0768093c
     768:	068e0000 	streq	r0, [lr], r0
     76c:	a3010000 	movwge	r0, #4096	; 0x1000
     770:	a9000004 	stmdbge	r0, {r2}
     774:	13000004 	movwne	r0, #4
     778:	0000068e 	andeq	r0, r0, lr, lsl #13
     77c:	0c161600 	ldceq	6, cr1, [r6], {-0}
     780:	3d070000 	stccc	0, cr0, [r7, #-0]
     784:	00041912 	andeq	r1, r4, r2, lsl r9
     788:	00005900 	andeq	r5, r0, r0, lsl #18
     78c:	04c20100 	strbeq	r0, [r2], #256	; 0x100
     790:	04cd0000 	strbeq	r0, [sp], #0
     794:	8e130000 	cdphi	0, 1, cr0, cr3, cr0, {0}
     798:	14000006 	strne	r0, [r0], #-6
     79c:	00000059 	andeq	r0, r0, r9, asr r0
     7a0:	06aa1600 	strteq	r1, [sl], r0, lsl #12
     7a4:	3f070000 	svccc	0x00070000
     7a8:	00047e12 	andeq	r7, r4, r2, lsl lr
     7ac:	00005900 	andeq	r5, r0, r0, lsl #18
     7b0:	04e60100 	strbteq	r0, [r6], #256	; 0x100
     7b4:	04fb0000 	ldrbteq	r0, [fp], #0
     7b8:	8e130000 	cdphi	0, 1, cr0, cr3, cr0, {0}
     7bc:	14000006 	strne	r0, [r0], #-6
     7c0:	000006b0 			; <UNDEFINED> instruction: 0x000006b0
     7c4:	00006a14 	andeq	r6, r0, r4, lsl sl
     7c8:	01c41400 	biceq	r1, r4, r0, lsl #8
     7cc:	18000000 	stmdane	r0, {}	; <UNPREDICTABLE>
     7d0:	000006be 			; <UNDEFINED> instruction: 0x000006be
     7d4:	310e4107 	tstcc	lr, r7, lsl #2
     7d8:	01000008 	tsteq	r0, r8
     7dc:	00000510 	andeq	r0, r0, r0, lsl r5
     7e0:	00000516 	andeq	r0, r0, r6, lsl r5
     7e4:	00068e13 	andeq	r8, r6, r3, lsl lr
     7e8:	b0180000 	andslt	r0, r8, r0
     7ec:	0700000b 	streq	r0, [r0, -fp]
     7f0:	053c0e43 	ldreq	r0, [ip, #-3651]!	; 0xfffff1bd
     7f4:	2b010000 	blcs	407fc <__bss_end+0x364c0>
     7f8:	31000005 	tstcc	r0, r5
     7fc:	13000005 	movwne	r0, #5
     800:	0000068e 	andeq	r0, r0, lr, lsl #13
     804:	04601600 	strbteq	r1, [r0], #-1536	; 0xfffffa00
     808:	46070000 	strmi	r0, [r7], -r0
     80c:	0004ce17 	andeq	ip, r4, r7, lsl lr
     810:	0003c200 	andeq	ip, r3, r0, lsl #4
     814:	054a0100 	strbeq	r0, [sl, #-256]	; 0xffffff00
     818:	05500000 	ldrbeq	r0, [r0, #-0]
     81c:	b6130000 	ldrlt	r0, [r3], -r0
     820:	00000006 	andeq	r0, r0, r6
     824:	000a8816 	andeq	r8, sl, r6, lsl r8
     828:	17490700 	strbne	r0, [r9, -r0, lsl #14]
     82c:	0000034d 	andeq	r0, r0, sp, asr #6
     830:	000003c2 	andeq	r0, r0, r2, asr #7
     834:	00056901 	andeq	r6, r5, r1, lsl #18
     838:	00057400 	andeq	r7, r5, r0, lsl #8
     83c:	06b61300 	ldrteq	r1, [r6], r0, lsl #6
     840:	59140000 	ldmdbpl	r4, {}	; <UNPREDICTABLE>
     844:	00000000 	andeq	r0, r0, r0
     848:	00058a18 	andeq	r8, r5, r8, lsl sl
     84c:	0e4c0700 	cdpeq	7, 4, cr0, cr12, cr0, {0}
     850:	000008dd 	ldrdeq	r0, [r0], -sp
     854:	00058901 	andeq	r8, r5, r1, lsl #18
     858:	00058f00 	andeq	r8, r5, r0, lsl #30
     85c:	068e1300 	streq	r1, [lr], r0, lsl #6
     860:	16000000 	strne	r0, [r0], -r0
     864:	00000759 	andeq	r0, r0, r9, asr r7
     868:	910e4e07 	tstls	lr, r7, lsl #28
     86c:	c4000009 	strgt	r0, [r0], #-9
     870:	01000001 	tsteq	r0, r1
     874:	000005a8 	andeq	r0, r0, r8, lsr #11
     878:	000005b3 			; <UNDEFINED> instruction: 0x000005b3
     87c:	00068e13 	andeq	r8, r6, r3, lsl lr
     880:	00591400 	subseq	r1, r9, r0, lsl #8
     884:	16000000 	strne	r0, [r0], -r0
     888:	000003f0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
     88c:	7a125107 	bvc	494cb0 <__bss_end+0x48a974>
     890:	59000003 	stmdbpl	r0, {r0, r1}
     894:	01000000 	mrseq	r0, (UNDEF: 0)
     898:	000005cc 	andeq	r0, r0, ip, asr #11
     89c:	000005d7 	ldrdeq	r0, [r0], -r7
     8a0:	00068e13 	andeq	r8, r6, r3, lsl lr
     8a4:	01d11400 	bicseq	r1, r1, r0, lsl #8
     8a8:	16000000 	strne	r0, [r0], -r0
     8ac:	000003ad 	andeq	r0, r0, sp, lsr #7
     8b0:	ea0e5407 	b	3958d4 <__bss_end+0x38b598>
     8b4:	c400000b 	strgt	r0, [r0], #-11
     8b8:	01000001 	tsteq	r0, r1
     8bc:	000005f0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
     8c0:	000005fb 	strdeq	r0, [r0], -fp
     8c4:	00068e13 	andeq	r8, r6, r3, lsl lr
     8c8:	00591400 	subseq	r1, r9, r0, lsl #8
     8cc:	18000000 	stmdane	r0, {}	; <UNPREDICTABLE>
     8d0:	000003ca 	andeq	r0, r0, sl, asr #7
     8d4:	ed0e5707 	stc	7, cr5, [lr, #-28]	; 0xffffffe4
     8d8:	0100000a 	tsteq	r0, sl
     8dc:	00000610 	andeq	r0, r0, r0, lsl r6
     8e0:	0000062f 	andeq	r0, r0, pc, lsr #12
     8e4:	00068e13 	andeq	r8, r6, r3, lsl lr
     8e8:	009c1400 	addseq	r1, ip, r0, lsl #8
     8ec:	59140000 	ldmdbpl	r4, {}	; <UNPREDICTABLE>
     8f0:	14000000 	strne	r0, [r0], #-0
     8f4:	00000059 	andeq	r0, r0, r9, asr r0
     8f8:	00005914 	andeq	r5, r0, r4, lsl r9
     8fc:	06bc1400 	ldrteq	r1, [ip], r0, lsl #8
     900:	18000000 	stmdane	r0, {}	; <UNPREDICTABLE>
     904:	00000c1b 	andeq	r0, r0, fp, lsl ip
     908:	990e5907 	stmdbls	lr, {r0, r1, r2, r8, fp, ip, lr}
     90c:	0100000c 	tsteq	r0, ip
     910:	00000644 	andeq	r0, r0, r4, asr #12
     914:	00000663 	andeq	r0, r0, r3, ror #12
     918:	00068e13 	andeq	r8, r6, r3, lsl lr
     91c:	00df1400 	sbcseq	r1, pc, r0, lsl #8
     920:	59140000 	ldmdbpl	r4, {}	; <UNPREDICTABLE>
     924:	14000000 	strne	r0, [r0], #-0
     928:	00000059 	andeq	r0, r0, r9, asr r0
     92c:	00005914 	andeq	r5, r0, r4, lsl r9
     930:	06bc1400 	ldrteq	r1, [ip], r0, lsl #8
     934:	19000000 	stmdbne	r0, {}	; <UNPREDICTABLE>
     938:	000003dd 	ldrdeq	r0, [r0], -sp
     93c:	5c0e5c07 	stcpl	12, cr5, [lr], {7}
     940:	c4000008 	strgt	r0, [r0], #-8
     944:	01000001 	tsteq	r0, r1
     948:	00000678 	andeq	r0, r0, r8, ror r6
     94c:	00068e13 	andeq	r8, r6, r3, lsl lr
     950:	03681400 	cmneq	r8, #0, 8
     954:	c2140000 	andsgt	r0, r4, #0
     958:	00000006 	andeq	r0, r0, r6
     95c:	03c80300 	biceq	r0, r8, #0, 6
     960:	040c0000 	streq	r0, [ip], #-0
     964:	000003c8 	andeq	r0, r0, r8, asr #7
     968:	0003bc1a 	andeq	fp, r3, sl, lsl ip
     96c:	0006a100 	andeq	sl, r6, r0, lsl #2
     970:	0006a700 	andeq	sl, r6, r0, lsl #14
     974:	068e1300 	streq	r1, [lr], r0, lsl #6
     978:	1b000000 	blne	980 <shift+0x980>
     97c:	000003c8 	andeq	r0, r0, r8, asr #7
     980:	00000694 	muleq	r0, r4, r6
     984:	003f040c 	eorseq	r0, pc, ip, lsl #8
     988:	040c0000 	streq	r0, [ip], #-0
     98c:	00000689 	andeq	r0, r0, r9, lsl #13
     990:	0076041c 	rsbseq	r0, r6, ip, lsl r4
     994:	041d0000 	ldreq	r0, [sp], #-0
     998:	0009f711 	andeq	pc, r9, r1, lsl r7	; <UNPREDICTABLE>
     99c:	06080800 	streq	r0, [r8], -r0, lsl #16
     9a0:	00080807 	andeq	r0, r8, r7, lsl #16
     9a4:	07300e00 	ldreq	r0, [r0, -r0, lsl #28]!
     9a8:	0a080000 	beq	2009b0 <__bss_end+0x1f6674>
     9ac:	00005912 	andeq	r5, r0, r2, lsl r9
     9b0:	890e0000 	stmdbhi	lr, {}	; <UNPREDICTABLE>
     9b4:	08000009 	stmdaeq	r0, {r0, r3}
     9b8:	01c40e0c 	biceq	r0, r4, ip, lsl #28
     9bc:	16040000 	strne	r0, [r4], -r0
     9c0:	000009f7 	strdeq	r0, [r0], -r7
     9c4:	5d091008 	stcpl	0, cr1, [r9, #-32]	; 0xffffffe0
     9c8:	0d000005 	stceq	0, cr0, [r0, #-20]	; 0xffffffec
     9cc:	01000008 	tsteq	r0, r8
     9d0:	00000704 	andeq	r0, r0, r4, lsl #14
     9d4:	0000070f 	andeq	r0, r0, pc, lsl #14
     9d8:	00080d13 	andeq	r0, r8, r3, lsl sp
     9dc:	01cb1400 	biceq	r1, fp, r0, lsl #8
     9e0:	16000000 	strne	r0, [r0], -r0
     9e4:	000009f6 	strdeq	r0, [r0], -r6
     9e8:	cc151208 	lfmgt	f1, 4, [r5], {8}
     9ec:	c2000009 	andgt	r0, r0, #9
     9f0:	01000006 	tsteq	r0, r6
     9f4:	00000728 	andeq	r0, r0, r8, lsr #14
     9f8:	00000733 	andeq	r0, r0, r3, lsr r7
     9fc:	00080d13 	andeq	r0, r8, r3, lsl sp
     a00:	00381300 	eorseq	r1, r8, r0, lsl #6
     a04:	16000000 	strne	r0, [r0], -r0
     a08:	00000576 	andeq	r0, r0, r6, ror r5
     a0c:	980e1508 	stmdals	lr, {r3, r8, sl, ip}
     a10:	c4000007 	strgt	r0, [r0], #-7
     a14:	01000001 	tsteq	r0, r1
     a18:	0000074c 	andeq	r0, r0, ip, asr #14
     a1c:	00000752 	andeq	r0, r0, r2, asr r7
     a20:	00081313 	andeq	r1, r8, r3, lsl r3
     a24:	d0180000 	andsle	r0, r8, r0
     a28:	0800000a 	stmdaeq	r0, {r1, r3}
     a2c:	06cb0e18 			; <UNDEFINED> instruction: 0x06cb0e18
     a30:	67010000 	strvs	r0, [r1, -r0]
     a34:	6d000007 	stcvs	0, cr0, [r0, #-28]	; 0xffffffe4
     a38:	13000007 	movwne	r0, #7
     a3c:	0000080d 	andeq	r0, r0, sp, lsl #16
     a40:	07921800 	ldreq	r1, [r2, r0, lsl #16]
     a44:	1b080000 	blne	200a4c <__bss_end+0x1f6710>
     a48:	0005bf0e 	andeq	fp, r5, lr, lsl #30
     a4c:	07820100 	streq	r0, [r2, r0, lsl #2]
     a50:	078d0000 	streq	r0, [sp, r0]
     a54:	0d130000 	ldceq	0, cr0, [r3, #-0]
     a58:	14000008 	strne	r0, [r0], #-8
     a5c:	000001c4 	andeq	r0, r0, r4, asr #3
     a60:	0b3f1800 	bleq	fc6a68 <__bss_end+0xfbc72c>
     a64:	1d080000 	stcne	0, cr0, [r8, #-0]
     a68:	000bc90e 	andeq	ip, fp, lr, lsl #18
     a6c:	07a20100 	streq	r0, [r2, r0, lsl #2]!
     a70:	07b70000 	ldreq	r0, [r7, r0]!
     a74:	0d130000 	ldceq	0, cr0, [r3, #-0]
     a78:	14000008 	strne	r0, [r0], #-8
     a7c:	00000046 	andeq	r0, r0, r6, asr #32
     a80:	00004614 	andeq	r4, r0, r4, lsl r6
     a84:	01c41400 	biceq	r1, r4, r0, lsl #8
     a88:	18000000 	stmdane	r0, {}	; <UNPREDICTABLE>
     a8c:	000005e4 	andeq	r0, r0, r4, ror #11
     a90:	ae0e1f08 	cdpge	15, 0, cr1, cr14, cr8, {0}
     a94:	01000004 	tsteq	r0, r4
     a98:	000007cc 	andeq	r0, r0, ip, asr #15
     a9c:	000007e1 	andeq	r0, r0, r1, ror #15
     aa0:	00080d13 	andeq	r0, r8, r3, lsl sp
     aa4:	00461400 	subeq	r1, r6, r0, lsl #8
     aa8:	46140000 	ldrmi	r0, [r4], -r0
     aac:	14000000 	strne	r0, [r0], #-0
     ab0:	00000025 	andeq	r0, r0, r5, lsr #32
     ab4:	0c491e00 	mcrreq	14, 0, r1, r9, cr0
     ab8:	21080000 	mrscs	r0, (UNDEF: 8)
     abc:	000aab0e 	andeq	sl, sl, lr, lsl #22
     ac0:	07f20100 	ldrbeq	r0, [r2, r0, lsl #2]!
     ac4:	0d130000 	ldceq	0, cr0, [r3, #-0]
     ac8:	14000008 	strne	r0, [r0], #-8
     acc:	00000046 	andeq	r0, r0, r6, asr #32
     ad0:	00004614 	andeq	r4, r0, r4, lsl r6
     ad4:	01cb1400 	biceq	r1, fp, r0, lsl #8
     ad8:	00000000 	andeq	r0, r0, r0
     adc:	0006c403 	andeq	ip, r6, r3, lsl #8
     ae0:	c4040c00 	strgt	r0, [r4], #-3072	; 0xfffff400
     ae4:	0c000006 	stceq	0, cr0, [r0], {6}
     ae8:	00080804 	andeq	r0, r8, r4, lsl #16
     aec:	61681f00 	cmnvs	r8, r0, lsl #30
     af0:	0509006c 	streq	r0, [r9, #-108]	; 0xffffff94
     af4:	0008e30b 	andeq	lr, r8, fp, lsl #6
     af8:	08a92000 	stmiaeq	r9!, {sp}
     afc:	07090000 	streq	r0, [r9, -r0]
     b00:	00007119 	andeq	r7, r0, r9, lsl r1
     b04:	e6b28000 	ldrt	r8, [r2], r0
     b08:	0a9b200e 	beq	fe6c8b48 <__bss_end+0xfe6be80c>
     b0c:	0a090000 	beq	240b14 <__bss_end+0x2367d8>
     b10:	00028a1a 	andeq	r8, r2, sl, lsl sl
     b14:	00000000 	andeq	r0, r0, r0
     b18:	04742020 	ldrbteq	r2, [r4], #-32	; 0xffffffe0
     b1c:	0d090000 	stceq	0, cr0, [r9, #-0]
     b20:	00028a1a 	andeq	r8, r2, sl, lsl sl
     b24:	20000000 	andcs	r0, r0, r0
     b28:	081d2120 	ldmdaeq	sp, {r5, r8, sp}
     b2c:	10090000 	andne	r0, r9, r0
     b30:	00006515 	andeq	r6, r0, r5, lsl r5
     b34:	8c203600 	stchi	6, cr3, [r0], #-0
     b38:	0900000b 	stmdbeq	r0, {r0, r1, r3}
     b3c:	028a1a42 	addeq	r1, sl, #270336	; 0x42000
     b40:	50000000 	andpl	r0, r0, r0
     b44:	5f202021 	svcpl	0x00202021
     b48:	0900000c 	stmdbeq	r0, {r2, r3}
     b4c:	028a1a71 	addeq	r1, sl, #462848	; 0x71000
     b50:	b2000000 	andlt	r0, r0, #0
     b54:	4e202000 	cdpmi	0, 2, cr2, cr0, cr0, {0}
     b58:	09000007 	stmdbeq	r0, {r0, r1, r2}
     b5c:	028a1aa4 	addeq	r1, sl, #164, 20	; 0xa4000
     b60:	b4000000 	strlt	r0, [r0], #-0
     b64:	47202000 	strmi	r2, [r0, -r0]!
     b68:	09000007 	stmdbeq	r0, {r0, r1, r2}
     b6c:	028a1db2 	addeq	r1, sl, #11392	; 0x2c80
     b70:	30000000 	andcc	r0, r0, r0
     b74:	9f202000 	svcls	0x00202000
     b78:	09000008 	stmdbeq	r0, {r3}
     b7c:	028a1dc0 	addeq	r1, sl, #192, 26	; 0x3000
     b80:	40000000 	andmi	r0, r0, r0
     b84:	5a202010 	bpl	808bcc <__bss_end+0x7fe890>
     b88:	09000009 	stmdbeq	r0, {r0, r3}
     b8c:	028a1acb 	addeq	r1, sl, #831488	; 0xcb000
     b90:	50000000 	andpl	r0, r0, r0
     b94:	da202020 	ble	808c1c <__bss_end+0x7fe8e0>
     b98:	09000005 	stmdbeq	r0, {r0, r2}
     b9c:	028a1acc 	addeq	r1, sl, #204, 20	; 0xcc000
     ba0:	40000000 	andmi	r0, r0, r0
     ba4:	95202080 	strls	r2, [r0, #-128]!	; 0xffffff80
     ba8:	0900000b 	stmdbeq	r0, {r0, r1, r3}
     bac:	028a1acd 	addeq	r1, sl, #839680	; 0xcd000
     bb0:	50000000 	andpl	r0, r0, r0
     bb4:	22002080 	andcs	r2, r0, #128	; 0x80
     bb8:	00000825 	andeq	r0, r0, r5, lsr #16
     bbc:	00083522 	andeq	r3, r8, r2, lsr #10
     bc0:	08452200 	stmdaeq	r5, {r9, sp}^
     bc4:	55220000 	strpl	r0, [r2, #-0]!
     bc8:	22000008 	andcs	r0, r0, #8
     bcc:	00000862 	andeq	r0, r0, r2, ror #16
     bd0:	00087222 	andeq	r7, r8, r2, lsr #4
     bd4:	08822200 	stmeq	r2, {r9, sp}
     bd8:	92220000 	eorls	r0, r2, #0
     bdc:	22000008 	andcs	r0, r0, #8
     be0:	000008a2 	andeq	r0, r0, r2, lsr #17
     be4:	0008b222 	andeq	fp, r8, r2, lsr #4
     be8:	08c22200 	stmiaeq	r2, {r9, sp}^
     bec:	d2220000 	eorle	r0, r2, #0
     bf0:	0a000008 	beq	c18 <shift+0xc18>
     bf4:	00000ad5 	ldrdeq	r0, [r0], -r5
     bf8:	6514080a 	ldrvs	r0, [r4, #-2058]	; 0xfffff7f6
     bfc:	05000000 	streq	r0, [r0, #-0]
     c00:	009f6403 	addseq	r6, pc, r3, lsl #8
     c04:	01cb0f00 	biceq	r0, fp, r0, lsl #30
     c08:	09410000 	stmdbeq	r1, {}^	; <UNPREDICTABLE>
     c0c:	6a100000 	bvs	400c14 <__bss_end+0x3f68d8>
     c10:	04000000 	streq	r0, [r0], #-0
     c14:	07892300 	streq	r2, [r9, r0, lsl #6]
     c18:	11010000 	mrsne	r0, (UNDEF: 1)
     c1c:	0009310d 	andeq	r3, r9, sp, lsl #2
     c20:	18030500 	stmdane	r3, {r8, sl}
     c24:	240000a3 	strcs	r0, [r0], #-163	; 0xffffff5d
     c28:	00001821 	andeq	r1, r0, r1, lsr #16
     c2c:	38051d01 	stmdacc	r5, {r0, r8, sl, fp, ip}
     c30:	68000000 	stmdavs	r0, {}	; <UNPREDICTABLE>
     c34:	6c000082 	stcvs	0, cr0, [r0], {130}	; 0x82
     c38:	01000000 	mrseq	r0, (UNDEF: 0)
     c3c:	0009aa9c 	muleq	r9, ip, sl
     c40:	09642500 	stmdbeq	r4!, {r8, sl, sp}^
     c44:	1d010000 	stcne	0, cr0, [r1, #-0]
     c48:	0000380e 	andeq	r3, r0, lr, lsl #16
     c4c:	5c910200 	lfmpl	f0, 4, [r1], {0}
     c50:	00097b25 	andeq	r7, r9, r5, lsr #22
     c54:	1b1d0100 	blne	74105c <__bss_end+0x736d20>
     c58:	000009aa 	andeq	r0, r0, sl, lsr #19
     c5c:	26589102 	ldrbcs	r9, [r8], -r2, lsl #2
     c60:	00000c44 	andeq	r0, r0, r4, asr #24
     c64:	c4131f01 	ldrgt	r1, [r3], #-3841	; 0xfffff0ff
     c68:	02000006 	andeq	r0, r0, #6
     c6c:	fc266491 	stc2	4, cr6, [r6], #-580	; 0xfffffdbc
     c70:	01000004 	tsteq	r0, r4
     c74:	00590e20 	subseq	r0, r9, r0, lsr #28
     c78:	91020000 	mrsls	r0, (UNDEF: 2)
     c7c:	040c006c 	streq	r0, [ip], #-108	; 0xffffff94
     c80:	000009b0 			; <UNDEFINED> instruction: 0x000009b0
     c84:	0025040c 	eoreq	r0, r5, ip, lsl #8
     c88:	06270000 	strteq	r0, [r7], -r0
     c8c:	01000005 	tsteq	r0, r5
     c90:	822c0d18 	eorhi	r0, ip, #24, 26	; 0x600
     c94:	003c0000 	eorseq	r0, ip, r0
     c98:	9c010000 	stcls	0, cr0, [r1], {-0}
     c9c:	00050125 	andeq	r0, r5, r5, lsr #2
     ca0:	1c180100 	ldfnes	f0, [r8], {-0}
     ca4:	00000059 	andeq	r0, r0, r9, asr r0
     ca8:	25749102 	ldrbcs	r9, [r4, #-258]!	; 0xfffffefe
     cac:	00000782 	andeq	r0, r0, r2, lsl #15
     cb0:	cb2e1801 	blgt	b86cbc <__bss_end+0xb7c980>
     cb4:	02000001 	andeq	r0, r0, #1
     cb8:	00007091 	muleq	r0, r1, r0
     cbc:	00000b91 	muleq	r0, r1, fp
     cc0:	04460004 	strbeq	r0, [r6], #-4
     cc4:	01040000 	mrseq	r0, (UNDEF: 4)
     cc8:	00000e21 	andeq	r0, r0, r1, lsr #28
     ccc:	000fd704 	andeq	sp, pc, r4, lsl #14
     cd0:	000f4b00 	andeq	r4, pc, r0, lsl #22
     cd4:	0082d400 	addeq	sp, r2, r0, lsl #8
     cd8:	00045c00 	andeq	r5, r4, r0, lsl #24
     cdc:	0003f200 	andeq	pc, r3, r0, lsl #4
     ce0:	08010200 	stmdaeq	r1, {r9}
     ce4:	00000b60 	andeq	r0, r0, r0, ror #22
     ce8:	00002503 	andeq	r2, r0, r3, lsl #10
     cec:	05020200 	streq	r0, [r2, #-512]	; 0xfffffe00
     cf0:	000009ec 	andeq	r0, r0, ip, ror #19
     cf4:	69050404 	stmdbvs	r5, {r2, sl}
     cf8:	0200746e 	andeq	r7, r0, #1845493760	; 0x6e000000
     cfc:	0b570801 	bleq	15c2d08 <__bss_end+0x15b89cc>
     d00:	02020000 	andeq	r0, r2, #0
     d04:	000c3107 	andeq	r3, ip, r7, lsl #2
     d08:	05a80500 	streq	r0, [r8, #1280]!	; 0x500
     d0c:	09070000 	stmdbeq	r7, {}	; <UNPREDICTABLE>
     d10:	00005e07 	andeq	r5, r0, r7, lsl #28
     d14:	004d0300 	subeq	r0, sp, r0, lsl #6
     d18:	04020000 	streq	r0, [r2], #-0
     d1c:	00188d07 	andseq	r8, r8, r7, lsl #26
     d20:	0ce50600 	stcleq	6, cr0, [r5]
     d24:	02080000 	andeq	r0, r8, #0
     d28:	008b0806 	addeq	r0, fp, r6, lsl #16
     d2c:	72070000 	andvc	r0, r7, #0
     d30:	08020030 	stmdaeq	r2, {r4, r5}
     d34:	00004d0e 	andeq	r4, r0, lr, lsl #26
     d38:	72070000 	andvc	r0, r7, #0
     d3c:	09020031 	stmdbeq	r2, {r0, r4, r5}
     d40:	00004d0e 	andeq	r4, r0, lr, lsl #26
     d44:	08000400 	stmdaeq	r0, {sl}
     d48:	00001007 	andeq	r1, r0, r7
     d4c:	00380405 	eorseq	r0, r8, r5, lsl #8
     d50:	0d020000 	stceq	0, cr0, [r2, #-0]
     d54:	0000a90c 	andeq	sl, r0, ip, lsl #18
     d58:	4b4f0900 	blmi	13c3160 <__bss_end+0x13b8e24>
     d5c:	540a0000 	strpl	r0, [sl], #-0
     d60:	0100000d 	tsteq	r0, sp
     d64:	0a550800 	beq	1542d6c <__bss_end+0x1538a30>
     d68:	04050000 	streq	r0, [r5], #-0
     d6c:	00000038 	andeq	r0, r0, r8, lsr r0
     d70:	ec0c1e02 	stc	14, cr1, [ip], {2}
     d74:	0a000000 	beq	d7c <shift+0xd7c>
     d78:	000005a0 	andeq	r0, r0, r0, lsr #11
     d7c:	073d0a00 	ldreq	r0, [sp, -r0, lsl #20]!
     d80:	0a010000 	beq	40d88 <__bss_end+0x36a4c>
     d84:	00000a77 	andeq	r0, r0, r7, ror sl
     d88:	0b7a0a02 	bleq	1e83598 <__bss_end+0x1e7925c>
     d8c:	0a030000 	beq	c0d94 <__bss_end+0xb6a58>
     d90:	0000071b 	andeq	r0, r0, fp, lsl r7
     d94:	09e30a04 	stmibeq	r3!, {r2, r9, fp}^
     d98:	0a050000 	beq	140da0 <__bss_end+0x136a64>
     d9c:	00000b65 	andeq	r0, r0, r5, ror #22
     da0:	0bc40a06 	bleq	ff1035c0 <__bss_end+0xff0f9284>
     da4:	00070000 	andeq	r0, r7, r0
     da8:	000a3d08 	andeq	r3, sl, r8, lsl #26
     dac:	38040500 	stmdacc	r4, {r8, sl}
     db0:	02000000 	andeq	r0, r0, #0
     db4:	01290c49 			; <UNDEFINED> instruction: 0x01290c49
     db8:	b90a0000 	stmdblt	sl, {}	; <UNPREDICTABLE>
     dbc:	00000006 	andeq	r0, r0, r6
     dc0:	0007380a 	andeq	r3, r7, sl, lsl #16
     dc4:	7e0a0100 	adfvce	f0, f2, f0
     dc8:	0200000c 	andeq	r0, r0, #12
     dcc:	00092e0a 	andeq	r2, r9, sl, lsl #28
     dd0:	2a0a0300 	bcs	2819d8 <__bss_end+0x27769c>
     dd4:	04000007 	streq	r0, [r0], #-7
     dd8:	0007b80a 	andeq	fp, r7, sl, lsl #16
     ddc:	ed0a0500 	cfstr32	mvfx0, [sl, #-0]
     de0:	06000005 	streq	r0, [r0], -r5
     de4:	107d0800 	rsbsne	r0, sp, r0, lsl #16
     de8:	04050000 	streq	r0, [r5], #-0
     dec:	00000038 	andeq	r0, r0, r8, lsr r0
     df0:	540c7002 	strpl	r7, [ip], #-2
     df4:	0a000001 	beq	e00 <shift+0xe00>
     df8:	00000f7c 	andeq	r0, r0, ip, ror pc
     dfc:	0db10a00 			; <UNDEFINED> instruction: 0x0db10a00
     e00:	0a010000 	beq	40e08 <__bss_end+0x36acc>
     e04:	00000fa0 	andeq	r0, r0, r0, lsr #31
     e08:	0dd60a02 	vldreq	s1, [r6, #8]
     e0c:	00030000 	andeq	r0, r3, r0
     e10:	00090c0b 	andeq	r0, r9, fp, lsl #24
     e14:	14050300 	strne	r0, [r5], #-768	; 0xfffffd00
     e18:	00000059 	andeq	r0, r0, r9, asr r0
     e1c:	a01c0305 	andsge	r0, ip, r5, lsl #6
     e20:	e10b0000 	mrs	r0, (UNDEF: 11)
     e24:	0300000a 	movweq	r0, #10
     e28:	00591406 	subseq	r1, r9, r6, lsl #8
     e2c:	03050000 	movweq	r0, #20480	; 0x5000
     e30:	0000a020 	andeq	sl, r0, r0, lsr #32
     e34:	0007cd0b 	andeq	ip, r7, fp, lsl #26
     e38:	1a070400 	bne	1c1e40 <__bss_end+0x1b7b04>
     e3c:	00000059 	andeq	r0, r0, r9, asr r0
     e40:	a0240305 	eorge	r0, r4, r5, lsl #6
     e44:	050b0000 	streq	r0, [fp, #-0]
     e48:	0400000a 	streq	r0, [r0], #-10
     e4c:	00591a09 	subseq	r1, r9, r9, lsl #20
     e50:	03050000 	movweq	r0, #20480	; 0x5000
     e54:	0000a028 	andeq	sl, r0, r8, lsr #32
     e58:	0007bf0b 	andeq	fp, r7, fp, lsl #30
     e5c:	1a0b0400 	bne	2c1e64 <__bss_end+0x2b7b28>
     e60:	00000059 	andeq	r0, r0, r9, asr r0
     e64:	a02c0305 	eorge	r0, ip, r5, lsl #6
     e68:	b90b0000 	stmdblt	fp, {}	; <UNPREDICTABLE>
     e6c:	04000009 	streq	r0, [r0], #-9
     e70:	00591a0d 	subseq	r1, r9, sp, lsl #20
     e74:	03050000 	movweq	r0, #20480	; 0x5000
     e78:	0000a030 	andeq	sl, r0, r0, lsr r0
     e7c:	0005800b 	andeq	r8, r5, fp
     e80:	1a0f0400 	bne	3c1e88 <__bss_end+0x3b7b4c>
     e84:	00000059 	andeq	r0, r0, r9, asr r0
     e88:	a0340305 	eorsge	r0, r4, r5, lsl #6
     e8c:	d0080000 	andle	r0, r8, r0
     e90:	05000010 	streq	r0, [r0, #-16]
     e94:	00003804 	andeq	r3, r0, r4, lsl #16
     e98:	0c1b0400 	cfldrseq	mvf0, [fp], {-0}
     e9c:	000001f7 	strdeq	r0, [r0], -r7
     ea0:	00050c0a 	andeq	r0, r5, sl, lsl #24
     ea4:	a50a0000 	strge	r0, [sl, #-0]
     ea8:	0100000b 	tsteq	r0, fp
     eac:	000c790a 	andeq	r7, ip, sl, lsl #18
     eb0:	0c000200 	sfmeq	f0, 4, [r0], {-0}
     eb4:	000003a7 	andeq	r0, r0, r7, lsr #7
     eb8:	57020102 	strpl	r0, [r2, -r2, lsl #2]
     ebc:	0d000008 	stceq	0, cr0, [r0, #-32]	; 0xffffffe0
     ec0:	00002c04 	andeq	r2, r0, r4, lsl #24
     ec4:	f7040d00 			; <UNDEFINED> instruction: 0xf7040d00
     ec8:	0b000001 	bleq	ed4 <shift+0xed4>
     ecc:	00000516 	andeq	r0, r0, r6, lsl r5
     ed0:	59140405 	ldmdbpl	r4, {r0, r2, sl}
     ed4:	05000000 	streq	r0, [r0, #-0]
     ed8:	00a03803 	adceq	r3, r0, r3, lsl #16
     edc:	0a7d0b00 	beq	1f43ae4 <__bss_end+0x1f397a8>
     ee0:	07050000 	streq	r0, [r5, -r0]
     ee4:	00005914 	andeq	r5, r0, r4, lsl r9
     ee8:	3c030500 	cfstr32cc	mvfx0, [r3], {-0}
     eec:	0b0000a0 	bleq	1174 <shift+0x1174>
     ef0:	0000044d 	andeq	r0, r0, sp, asr #8
     ef4:	59140a05 	ldmdbpl	r4, {r0, r2, r9, fp}
     ef8:	05000000 	streq	r0, [r0, #-0]
     efc:	00a04003 	adceq	r4, r0, r3
     f00:	05f20800 	ldrbeq	r0, [r2, #2048]!	; 0x800
     f04:	04050000 	streq	r0, [r5], #-0
     f08:	00000038 	andeq	r0, r0, r8, lsr r0
     f0c:	7c0c0d05 	stcvc	13, cr0, [ip], {5}
     f10:	09000002 	stmdbeq	r0, {r1}
     f14:	0077654e 	rsbseq	r6, r7, lr, asr #10
     f18:	04100a00 	ldreq	r0, [r0], #-2560	; 0xfffff600
     f1c:	0a010000 	beq	40f24 <__bss_end+0x36be8>
     f20:	00000445 	andeq	r0, r0, r5, asr #8
     f24:	06410a02 	strbeq	r0, [r1], -r2, lsl #20
     f28:	0a030000 	beq	c0f30 <__bss_end+0xb6bf4>
     f2c:	00000b6c 	andeq	r0, r0, ip, ror #22
     f30:	04040a04 	streq	r0, [r4], #-2564	; 0xfffff5fc
     f34:	00050000 	andeq	r0, r5, r0
     f38:	00052f06 	andeq	r2, r5, r6, lsl #30
     f3c:	1b051000 	blne	144f44 <__bss_end+0x13ac08>
     f40:	0002bb08 	andeq	fp, r2, r8, lsl #22
     f44:	726c0700 	rsbvc	r0, ip, #0, 14
     f48:	131d0500 	tstne	sp, #0, 10
     f4c:	000002bb 			; <UNDEFINED> instruction: 0x000002bb
     f50:	70730700 	rsbsvc	r0, r3, r0, lsl #14
     f54:	131e0500 	tstne	lr, #0, 10
     f58:	000002bb 			; <UNDEFINED> instruction: 0x000002bb
     f5c:	63700704 	cmnvs	r0, #4, 14	; 0x100000
     f60:	131f0500 	tstne	pc, #0, 10
     f64:	000002bb 			; <UNDEFINED> instruction: 0x000002bb
     f68:	0a370e08 	beq	dc4790 <__bss_end+0xdba454>
     f6c:	20050000 	andcs	r0, r5, r0
     f70:	0002bb13 	andeq	fp, r2, r3, lsl fp
     f74:	02000c00 	andeq	r0, r0, #0, 24
     f78:	18880704 	stmne	r8, {r2, r8, r9, sl}
     f7c:	0e060000 	cdpeq	0, 0, cr0, cr6, cr0, {0}
     f80:	7c000007 	stcvc	0, cr0, [r0], {7}
     f84:	79082805 	stmdbvc	r8, {r0, r2, fp, sp}
     f88:	0e000003 	cdpeq	0, 0, cr0, cr0, cr3, {0}
     f8c:	0000069e 	muleq	r0, lr, r6
     f90:	7c122a05 			; <UNDEFINED> instruction: 0x7c122a05
     f94:	00000002 	andeq	r0, r0, r2
     f98:	64697007 	strbtvs	r7, [r9], #-7
     f9c:	122b0500 	eorne	r0, fp, #0, 10
     fa0:	0000005e 	andeq	r0, r0, lr, asr r0
     fa4:	0b9f0e10 	bleq	fe7c47ec <__bss_end+0xfe7ba4b0>
     fa8:	2c050000 	stccs	0, cr0, [r5], {-0}
     fac:	00024511 	andeq	r4, r2, r1, lsl r5
     fb0:	490e1400 	stmdbmi	lr, {sl, ip}
     fb4:	0500000b 	streq	r0, [r0, #-11]
     fb8:	005e122d 	subseq	r1, lr, sp, lsr #4
     fbc:	0e180000 	cdpeq	0, 1, cr0, cr8, cr0, {0}
     fc0:	00000337 	andeq	r0, r0, r7, lsr r3
     fc4:	5e122e05 	cdppl	14, 1, cr2, cr2, cr5, {0}
     fc8:	1c000000 	stcne	0, cr0, [r0], {-0}
     fcc:	000a6a0e 	andeq	r6, sl, lr, lsl #20
     fd0:	0c2f0500 	cfstr32eq	mvfx0, [pc], #-0	; fd8 <shift+0xfd8>
     fd4:	00000379 	andeq	r0, r0, r9, ror r3
     fd8:	03c00e20 	biceq	r0, r0, #32, 28	; 0x200
     fdc:	30050000 	andcc	r0, r5, r0
     fe0:	00003809 	andeq	r3, r0, r9, lsl #16
     fe4:	5c0e6000 	stcpl	0, cr6, [lr], {-0}
     fe8:	05000006 	streq	r0, [r0, #-6]
     fec:	004d0e31 	subeq	r0, sp, r1, lsr lr
     ff0:	0e640000 	cdpeq	0, 6, cr0, cr4, cr0, {0}
     ff4:	00000972 	andeq	r0, r0, r2, ror r9
     ff8:	4d0e3305 	stcmi	3, cr3, [lr, #-20]	; 0xffffffec
     ffc:	68000000 	stmdavs	r0, {}	; <UNPREDICTABLE>
    1000:	0009690e 	andeq	r6, r9, lr, lsl #18
    1004:	0e340500 	cfabs32eq	mvfx0, mvfx4
    1008:	0000004d 	andeq	r0, r0, sp, asr #32
    100c:	05b10e6c 	ldreq	r0, [r1, #3692]!	; 0xe6c
    1010:	35050000 	strcc	r0, [r5, #-0]
    1014:	00004d0e 	andeq	r4, r0, lr, lsl #26
    1018:	280e7000 	stmdacs	lr, {ip, sp, lr}
    101c:	0500000a 	streq	r0, [r0, #-10]
    1020:	004d0e36 	subeq	r0, sp, r6, lsr lr
    1024:	0e740000 	cdpeq	0, 7, cr0, cr4, cr0, {0}
    1028:	00000c54 	andeq	r0, r0, r4, asr ip
    102c:	4d0e3705 	stcmi	7, cr3, [lr, #-20]	; 0xffffffec
    1030:	78000000 	stmdavc	r0, {}	; <UNPREDICTABLE>
    1034:	02090f00 	andeq	r0, r9, #0, 30
    1038:	03890000 	orreq	r0, r9, #0
    103c:	5e100000 	cdppl	0, 1, cr0, cr0, cr0, {0}
    1040:	0f000000 	svceq	0x00000000
    1044:	04360b00 	ldrteq	r0, [r6], #-2816	; 0xfffff500
    1048:	0a060000 	beq	181050 <__bss_end+0x176d14>
    104c:	00005914 	andeq	r5, r0, r4, lsl r9
    1050:	44030500 	strmi	r0, [r3], #-1280	; 0xfffffb00
    1054:	080000a0 	stmdaeq	r0, {r5, r7}
    1058:	00000808 	andeq	r0, r0, r8, lsl #16
    105c:	00380405 	eorseq	r0, r8, r5, lsl #8
    1060:	0d060000 	stceq	0, cr0, [r6, #-0]
    1064:	0003ba0c 	andeq	fp, r3, ip, lsl #20
    1068:	0c840a00 	vstmiaeq	r4, {s0-s-1}
    106c:	0a000000 	beq	1074 <shift+0x1074>
    1070:	00000bb9 			; <UNDEFINED> instruction: 0x00000bb9
    1074:	9b030001 	blls	c1080 <__bss_end+0xb6d44>
    1078:	08000003 	stmdaeq	r0, {r0, r1}
    107c:	00000eef 	andeq	r0, r0, pc, ror #29
    1080:	00380405 	eorseq	r0, r8, r5, lsl #8
    1084:	14060000 	strne	r0, [r6], #-0
    1088:	0003de0c 	andeq	sp, r3, ip, lsl #28
    108c:	0cf70a00 	vldmiaeq	r7!, {s1-s0}
    1090:	0a000000 	beq	1098 <shift+0x1098>
    1094:	00000f92 	muleq	r0, r2, pc	; <UNPREDICTABLE>
    1098:	bf030001 	svclt	0x00030001
    109c:	06000003 	streq	r0, [r0], -r3
    10a0:	0000068b 	andeq	r0, r0, fp, lsl #13
    10a4:	081b060c 	ldmdaeq	fp, {r2, r3, r9, sl}
    10a8:	00000418 	andeq	r0, r0, r8, lsl r4
    10ac:	0004a90e 	andeq	sl, r4, lr, lsl #18
    10b0:	191d0600 	ldmdbne	sp, {r9, sl}
    10b4:	00000418 	andeq	r0, r0, r8, lsl r4
    10b8:	040b0e00 	streq	r0, [fp], #-3584	; 0xfffff200
    10bc:	1e060000 	cdpne	0, 0, cr0, cr6, cr0, {0}
    10c0:	00041819 	andeq	r1, r4, r9, lsl r8
    10c4:	2c0e0400 	cfstrscs	mvf0, [lr], {-0}
    10c8:	06000008 	streq	r0, [r0], -r8
    10cc:	041e131f 	ldreq	r1, [lr], #-799	; 0xfffffce1
    10d0:	00080000 	andeq	r0, r8, r0
    10d4:	03e3040d 	mvneq	r0, #218103808	; 0xd000000
    10d8:	040d0000 	streq	r0, [sp], #-0
    10dc:	000002c2 	andeq	r0, r0, r2, asr #5
    10e0:	000a1711 	andeq	r1, sl, r1, lsl r7
    10e4:	22061400 	andcs	r1, r6, #0, 8
    10e8:	0006e507 	andeq	lr, r6, r7, lsl #10
    10ec:	091a0e00 	ldmdbeq	sl, {r9, sl, fp}
    10f0:	26060000 	strcs	r0, [r6], -r0
    10f4:	00004d12 	andeq	r4, r0, r2, lsl sp
    10f8:	bc0e0000 	stclt	0, cr0, [lr], {-0}
    10fc:	06000008 	streq	r0, [r0], -r8
    1100:	04181d29 	ldreq	r1, [r8], #-3369	; 0xfffff2d7
    1104:	0e040000 	cdpeq	0, 0, cr0, cr4, cr0, {0}
    1108:	00000649 	andeq	r0, r0, r9, asr #12
    110c:	181d2c06 	ldmdane	sp, {r1, r2, sl, fp, sp}
    1110:	08000004 	stmdaeq	r0, {r2}
    1114:	00092412 	andeq	r2, r9, r2, lsl r4
    1118:	0e2f0600 	cfmadda32eq	mvax0, mvax0, mvfx15, mvfx0
    111c:	00000668 	andeq	r0, r0, r8, ror #12
    1120:	0000046c 	andeq	r0, r0, ip, ror #8
    1124:	00000477 	andeq	r0, r0, r7, ror r4
    1128:	0006ea13 	andeq	lr, r6, r3, lsl sl
    112c:	04181400 	ldreq	r1, [r8], #-1024	; 0xfffffc00
    1130:	15000000 	strne	r0, [r0, #-0]
    1134:	00000759 	andeq	r0, r0, r9, asr r7
    1138:	e50e3106 	str	r3, [lr, #-262]	; 0xfffffefa
    113c:	fc000006 	stc2	0, cr0, [r0], {6}
    1140:	8f000001 	svchi	0x00000001
    1144:	9a000004 	bls	115c <shift+0x115c>
    1148:	13000004 	movwne	r0, #4
    114c:	000006ea 	andeq	r0, r0, sl, ror #13
    1150:	00041e14 	andeq	r1, r4, r4, lsl lr
    1154:	80160000 	andshi	r0, r6, r0
    1158:	0600000b 	streq	r0, [r0], -fp
    115c:	07e31d35 			; <UNDEFINED> instruction: 0x07e31d35
    1160:	04180000 	ldreq	r0, [r8], #-0
    1164:	b3020000 	movwlt	r0, #8192	; 0x2000
    1168:	b9000004 	stmdblt	r0, {r2}
    116c:	13000004 	movwne	r0, #4
    1170:	000006ea 	andeq	r0, r0, sl, ror #13
    1174:	06341600 	ldrteq	r1, [r4], -r0, lsl #12
    1178:	37060000 	strcc	r0, [r6, -r0]
    117c:	0009341d 	andeq	r3, r9, sp, lsl r4
    1180:	00041800 	andeq	r1, r4, r0, lsl #16
    1184:	04d20200 	ldrbeq	r0, [r2], #512	; 0x200
    1188:	04d80000 	ldrbeq	r0, [r8], #0
    118c:	ea130000 	b	4c1194 <__bss_end+0x4b6e58>
    1190:	00000006 	andeq	r0, r0, r6
    1194:	0008cf17 	andeq	ip, r8, r7, lsl pc
    1198:	31390600 	teqcc	r9, r0, lsl #12
    119c:	00000703 	andeq	r0, r0, r3, lsl #14
    11a0:	1716020c 	ldrne	r0, [r6, -ip, lsl #4]
    11a4:	0600000a 	streq	r0, [r0], -sl
    11a8:	0768093c 			; <UNDEFINED> instruction: 0x0768093c
    11ac:	06ea0000 	strbteq	r0, [sl], r0
    11b0:	ff010000 			; <UNDEFINED> instruction: 0xff010000
    11b4:	05000004 	streq	r0, [r0, #-4]
    11b8:	13000005 	movwne	r0, #5
    11bc:	000006ea 	andeq	r0, r0, sl, ror #13
    11c0:	0c161600 	ldceq	6, cr1, [r6], {-0}
    11c4:	3d060000 	stccc	0, cr0, [r6, #-0]
    11c8:	00041912 	andeq	r1, r4, r2, lsl r9
    11cc:	00004d00 	andeq	r4, r0, r0, lsl #26
    11d0:	051e0100 	ldreq	r0, [lr, #-256]	; 0xffffff00
    11d4:	05290000 	streq	r0, [r9, #-0]!
    11d8:	ea130000 	b	4c11e0 <__bss_end+0x4b6ea4>
    11dc:	14000006 	strne	r0, [r0], #-6
    11e0:	0000004d 	andeq	r0, r0, sp, asr #32
    11e4:	06aa1600 	strteq	r1, [sl], r0, lsl #12
    11e8:	3f060000 	svccc	0x00060000
    11ec:	00047e12 	andeq	r7, r4, r2, lsl lr
    11f0:	00004d00 	andeq	r4, r0, r0, lsl #26
    11f4:	05420100 	strbeq	r0, [r2, #-256]	; 0xffffff00
    11f8:	05570000 	ldrbeq	r0, [r7, #-0]
    11fc:	ea130000 	b	4c1204 <__bss_end+0x4b6ec8>
    1200:	14000006 	strne	r0, [r0], #-6
    1204:	0000070c 	andeq	r0, r0, ip, lsl #14
    1208:	00005e14 	andeq	r5, r0, r4, lsl lr
    120c:	01fc1400 	mvnseq	r1, r0, lsl #8
    1210:	18000000 	stmdane	r0, {}	; <UNPREDICTABLE>
    1214:	000006be 			; <UNDEFINED> instruction: 0x000006be
    1218:	310e4106 	tstcc	lr, r6, lsl #2
    121c:	01000008 	tsteq	r0, r8
    1220:	0000056c 	andeq	r0, r0, ip, ror #10
    1224:	00000572 	andeq	r0, r0, r2, ror r5
    1228:	0006ea13 	andeq	lr, r6, r3, lsl sl
    122c:	b0180000 	andslt	r0, r8, r0
    1230:	0600000b 	streq	r0, [r0], -fp
    1234:	053c0e43 	ldreq	r0, [ip, #-3651]!	; 0xfffff1bd
    1238:	87010000 	strhi	r0, [r1, -r0]
    123c:	8d000005 	stchi	0, cr0, [r0, #-20]	; 0xffffffec
    1240:	13000005 	movwne	r0, #5
    1244:	000006ea 	andeq	r0, r0, sl, ror #13
    1248:	04601600 	strbteq	r1, [r0], #-1536	; 0xfffffa00
    124c:	46060000 	strmi	r0, [r6], -r0
    1250:	0004ce17 	andeq	ip, r4, r7, lsl lr
    1254:	00041e00 	andeq	r1, r4, r0, lsl #28
    1258:	05a60100 	streq	r0, [r6, #256]!	; 0x100
    125c:	05ac0000 	streq	r0, [ip, #0]!
    1260:	12130000 	andsne	r0, r3, #0
    1264:	00000007 	andeq	r0, r0, r7
    1268:	000a8816 	andeq	r8, sl, r6, lsl r8
    126c:	17490600 	strbne	r0, [r9, -r0, lsl #12]
    1270:	0000034d 	andeq	r0, r0, sp, asr #6
    1274:	0000041e 	andeq	r0, r0, lr, lsl r4
    1278:	0005c501 	andeq	ip, r5, r1, lsl #10
    127c:	0005d000 	andeq	sp, r5, r0
    1280:	07121300 	ldreq	r1, [r2, -r0, lsl #6]
    1284:	4d140000 	ldcmi	0, cr0, [r4, #-0]
    1288:	00000000 	andeq	r0, r0, r0
    128c:	00058a18 	andeq	r8, r5, r8, lsl sl
    1290:	0e4c0600 	cdpeq	6, 4, cr0, cr12, cr0, {0}
    1294:	000008dd 	ldrdeq	r0, [r0], -sp
    1298:	0005e501 	andeq	lr, r5, r1, lsl #10
    129c:	0005eb00 	andeq	lr, r5, r0, lsl #22
    12a0:	06ea1300 	strbteq	r1, [sl], r0, lsl #6
    12a4:	16000000 	strne	r0, [r0], -r0
    12a8:	00000759 	andeq	r0, r0, r9, asr r7
    12ac:	910e4e06 	tstls	lr, r6, lsl #28
    12b0:	fc000009 	stc2	0, cr0, [r0], {9}
    12b4:	01000001 	tsteq	r0, r1
    12b8:	00000604 	andeq	r0, r0, r4, lsl #12
    12bc:	0000060f 	andeq	r0, r0, pc, lsl #12
    12c0:	0006ea13 	andeq	lr, r6, r3, lsl sl
    12c4:	004d1400 	subeq	r1, sp, r0, lsl #8
    12c8:	16000000 	strne	r0, [r0], -r0
    12cc:	000003f0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
    12d0:	7a125106 	bvc	4956f0 <__bss_end+0x48b3b4>
    12d4:	4d000003 	stcmi	0, cr0, [r0, #-12]
    12d8:	01000000 	mrseq	r0, (UNDEF: 0)
    12dc:	00000628 	andeq	r0, r0, r8, lsr #12
    12e0:	00000633 	andeq	r0, r0, r3, lsr r6
    12e4:	0006ea13 	andeq	lr, r6, r3, lsl sl
    12e8:	02091400 	andeq	r1, r9, #0, 8
    12ec:	16000000 	strne	r0, [r0], -r0
    12f0:	000003ad 	andeq	r0, r0, sp, lsr #7
    12f4:	ea0e5406 	b	396314 <__bss_end+0x38bfd8>
    12f8:	fc00000b 	stc2	0, cr0, [r0], {11}
    12fc:	01000001 	tsteq	r0, r1
    1300:	0000064c 	andeq	r0, r0, ip, asr #12
    1304:	00000657 	andeq	r0, r0, r7, asr r6
    1308:	0006ea13 	andeq	lr, r6, r3, lsl sl
    130c:	004d1400 	subeq	r1, sp, r0, lsl #8
    1310:	18000000 	stmdane	r0, {}	; <UNPREDICTABLE>
    1314:	000003ca 	andeq	r0, r0, sl, asr #7
    1318:	ed0e5706 	stc	7, cr5, [lr, #-24]	; 0xffffffe8
    131c:	0100000a 	tsteq	r0, sl
    1320:	0000066c 	andeq	r0, r0, ip, ror #12
    1324:	0000068b 	andeq	r0, r0, fp, lsl #13
    1328:	0006ea13 	andeq	lr, r6, r3, lsl sl
    132c:	00a91400 	adceq	r1, r9, r0, lsl #8
    1330:	4d140000 	ldcmi	0, cr0, [r4, #-0]
    1334:	14000000 	strne	r0, [r0], #-0
    1338:	0000004d 	andeq	r0, r0, sp, asr #32
    133c:	00004d14 	andeq	r4, r0, r4, lsl sp
    1340:	07181400 	ldreq	r1, [r8, -r0, lsl #8]
    1344:	18000000 	stmdane	r0, {}	; <UNPREDICTABLE>
    1348:	00000c1b 	andeq	r0, r0, fp, lsl ip
    134c:	990e5906 	stmdbls	lr, {r1, r2, r8, fp, ip, lr}
    1350:	0100000c 	tsteq	r0, ip
    1354:	000006a0 	andeq	r0, r0, r0, lsr #13
    1358:	000006bf 			; <UNDEFINED> instruction: 0x000006bf
    135c:	0006ea13 	andeq	lr, r6, r3, lsl sl
    1360:	00ec1400 	rsceq	r1, ip, r0, lsl #8
    1364:	4d140000 	ldcmi	0, cr0, [r4, #-0]
    1368:	14000000 	strne	r0, [r0], #-0
    136c:	0000004d 	andeq	r0, r0, sp, asr #32
    1370:	00004d14 	andeq	r4, r0, r4, lsl sp
    1374:	07181400 	ldreq	r1, [r8, -r0, lsl #8]
    1378:	19000000 	stmdbne	r0, {}	; <UNPREDICTABLE>
    137c:	000003dd 	ldrdeq	r0, [r0], -sp
    1380:	5c0e5c06 	stcpl	12, cr5, [lr], {6}
    1384:	fc000008 	stc2	0, cr0, [r0], {8}
    1388:	01000001 	tsteq	r0, r1
    138c:	000006d4 	ldrdeq	r0, [r0], -r4
    1390:	0006ea13 	andeq	lr, r6, r3, lsl sl
    1394:	039b1400 	orrseq	r1, fp, #0, 8
    1398:	1e140000 	cdpne	0, 1, cr0, cr4, cr0, {0}
    139c:	00000007 	andeq	r0, r0, r7
    13a0:	04240300 	strteq	r0, [r4], #-768	; 0xfffffd00
    13a4:	040d0000 	streq	r0, [sp], #-0
    13a8:	00000424 	andeq	r0, r0, r4, lsr #8
    13ac:	0004181a 	andeq	r1, r4, sl, lsl r8
    13b0:	0006fd00 	andeq	pc, r6, r0, lsl #26
    13b4:	00070300 	andeq	r0, r7, r0, lsl #6
    13b8:	06ea1300 	strbteq	r1, [sl], r0, lsl #6
    13bc:	1b000000 	blne	13c4 <shift+0x13c4>
    13c0:	00000424 	andeq	r0, r0, r4, lsr #8
    13c4:	000006f0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
    13c8:	003f040d 	eorseq	r0, pc, sp, lsl #8
    13cc:	040d0000 	streq	r0, [sp], #-0
    13d0:	000006e5 	andeq	r0, r0, r5, ror #13
    13d4:	0065041c 	rsbeq	r0, r5, ip, lsl r4
    13d8:	041d0000 	ldreq	r0, [sp], #-0
    13dc:	00002c0f 	andeq	r2, r0, pc, lsl #24
    13e0:	00073000 	andeq	r3, r7, r0
    13e4:	005e1000 	subseq	r1, lr, r0
    13e8:	00090000 	andeq	r0, r9, r0
    13ec:	00072003 	andeq	r2, r7, r3
    13f0:	0da01e00 	stceq	14, cr1, [r0]
    13f4:	a5010000 	strge	r0, [r1, #-0]
    13f8:	0007300c 	andeq	r3, r7, ip
    13fc:	48030500 	stmdami	r3, {r8, sl}
    1400:	1f0000a0 	svcne	0x000000a0
    1404:	00000d10 	andeq	r0, r0, r0, lsl sp
    1408:	e30aa701 	movw	sl, #42753	; 0xa701
    140c:	4d00000e 	stcmi	0, cr0, [r0, #-56]	; 0xffffffc8
    1410:	80000000 	andhi	r0, r0, r0
    1414:	b0000086 	andlt	r0, r0, r6, lsl #1
    1418:	01000000 	mrseq	r0, (UNDEF: 0)
    141c:	0007a59c 	muleq	r7, ip, r5
    1420:	10b32000 	adcsne	r2, r3, r0
    1424:	a7010000 	strge	r0, [r1, -r0]
    1428:	0002031b 	andeq	r0, r2, fp, lsl r3
    142c:	ac910300 	ldcge	3, cr0, [r1], {0}
    1430:	0f42207f 	svceq	0x0042207f
    1434:	a7010000 	strge	r0, [r1, -r0]
    1438:	00004d2a 	andeq	r4, r0, sl, lsr #26
    143c:	a8910300 	ldmge	r1, {r8, r9}
    1440:	0e1b1e7f 	mrceq	14, 0, r1, cr11, cr15, {3}
    1444:	a9010000 	stmdbge	r1, {}	; <UNPREDICTABLE>
    1448:	0007a50a 	andeq	sl, r7, sl, lsl #10
    144c:	b4910300 	ldrlt	r0, [r1], #768	; 0x300
    1450:	0d0b1e7f 	stceq	14, cr1, [fp, #-508]	; 0xfffffe04
    1454:	ad010000 	stcge	0, cr0, [r1, #-0]
    1458:	00003809 	andeq	r3, r0, r9, lsl #16
    145c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1460:	00250f00 	eoreq	r0, r5, r0, lsl #30
    1464:	07b50000 	ldreq	r0, [r5, r0]!
    1468:	5e100000 	cdppl	0, 1, cr0, cr0, cr0, {0}
    146c:	3f000000 	svccc	0x00000000
    1470:	0f272100 	svceq	0x00272100
    1474:	99010000 	stmdbls	r1, {}	; <UNPREDICTABLE>
    1478:	000fb70a 	andeq	fp, pc, sl, lsl #14
    147c:	00004d00 	andeq	r4, r0, r0, lsl #26
    1480:	00864400 	addeq	r4, r6, r0, lsl #8
    1484:	00003c00 	andeq	r3, r0, r0, lsl #24
    1488:	f29c0100 	vaddw.s16	q0, q6, d0
    148c:	22000007 	andcs	r0, r0, #7
    1490:	00716572 	rsbseq	r6, r1, r2, ror r5
    1494:	de209b01 	vmulle.f64	d9, d0, d1
    1498:	02000003 	andeq	r0, r0, #3
    149c:	d81e7491 	ldmdale	lr, {r0, r4, r7, sl, ip, sp, lr}
    14a0:	0100000e 	tsteq	r0, lr
    14a4:	004d0e9c 	umaaleq	r0, sp, ip, lr
    14a8:	91020000 	mrsls	r0, (UNDEF: 2)
    14ac:	6a230070 	bvs	8c1674 <__bss_end+0x8b7338>
    14b0:	0100000f 	tsteq	r0, pc
    14b4:	0d2c0690 	stceq	6, cr0, [ip, #-576]!	; 0xfffffdc0
    14b8:	86080000 	strhi	r0, [r8], -r0
    14bc:	003c0000 	eorseq	r0, ip, r0
    14c0:	9c010000 	stcls	0, cr0, [r1], {-0}
    14c4:	0000082b 	andeq	r0, r0, fp, lsr #16
    14c8:	000d6e20 	andeq	r6, sp, r0, lsr #28
    14cc:	21900100 	orrscs	r0, r0, r0, lsl #2
    14d0:	0000004d 	andeq	r0, r0, sp, asr #32
    14d4:	226c9102 	rsbcs	r9, ip, #-2147483648	; 0x80000000
    14d8:	00716572 	rsbseq	r6, r1, r2, ror r5
    14dc:	de209201 	cdple	2, 2, cr9, cr0, cr1, {0}
    14e0:	02000003 	andeq	r0, r0, #3
    14e4:	21007491 			; <UNDEFINED> instruction: 0x21007491
    14e8:	00000f04 	andeq	r0, r0, r4, lsl #30
    14ec:	bc0a8401 	cfstrslt	mvf8, [sl], {1}
    14f0:	4d00000d 	stcmi	0, cr0, [r0, #-52]	; 0xffffffcc
    14f4:	cc000000 	stcgt	0, cr0, [r0], {-0}
    14f8:	3c000085 	stccc	0, cr0, [r0], {133}	; 0x85
    14fc:	01000000 	mrseq	r0, (UNDEF: 0)
    1500:	0008689c 	muleq	r8, ip, r8
    1504:	65722200 	ldrbvs	r2, [r2, #-512]!	; 0xfffffe00
    1508:	86010071 			; <UNDEFINED> instruction: 0x86010071
    150c:	0003ba20 	andeq	fp, r3, r0, lsr #20
    1510:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1514:	000d041e 	andeq	r0, sp, lr, lsl r4
    1518:	0e870100 	rmfeqs	f0, f7, f0
    151c:	0000004d 	andeq	r0, r0, sp, asr #32
    1520:	00709102 	rsbseq	r9, r0, r2, lsl #2
    1524:	00109621 	andseq	r9, r0, r1, lsr #12
    1528:	0a780100 	beq	1e01930 <__bss_end+0x1df75f4>
    152c:	00000d82 	andeq	r0, r0, r2, lsl #27
    1530:	0000004d 	andeq	r0, r0, sp, asr #32
    1534:	00008590 	muleq	r0, r0, r5
    1538:	0000003c 	andeq	r0, r0, ip, lsr r0
    153c:	08a59c01 	stmiaeq	r5!, {r0, sl, fp, ip, pc}
    1540:	72220000 	eorvc	r0, r2, #0
    1544:	01007165 	tsteq	r0, r5, ror #2
    1548:	03ba207a 			; <UNDEFINED> instruction: 0x03ba207a
    154c:	91020000 	mrsls	r0, (UNDEF: 2)
    1550:	0d041e74 	stceq	14, cr1, [r4, #-464]	; 0xfffffe30
    1554:	7b010000 	blvc	4155c <__bss_end+0x37220>
    1558:	00004d0e 	andeq	r4, r0, lr, lsl #26
    155c:	70910200 	addsvc	r0, r1, r0, lsl #4
    1560:	0dd02100 	ldfeqe	f2, [r0]
    1564:	6c010000 	stcvs	0, cr0, [r1], {-0}
    1568:	000f8706 	andeq	r8, pc, r6, lsl #14
    156c:	0001fc00 	andeq	pc, r1, r0, lsl #24
    1570:	00853c00 	addeq	r3, r5, r0, lsl #24
    1574:	00005400 	andeq	r5, r0, r0, lsl #8
    1578:	f19c0100 			; <UNDEFINED> instruction: 0xf19c0100
    157c:	20000008 	andcs	r0, r0, r8
    1580:	00000ed8 	ldrdeq	r0, [r0], -r8
    1584:	4d156c01 	ldcmi	12, cr6, [r5, #-4]
    1588:	02000000 	andeq	r0, r0, #0
    158c:	69206c91 	stmdbvs	r0!, {r0, r4, r7, sl, fp, sp, lr}
    1590:	01000009 	tsteq	r0, r9
    1594:	004d256c 	subeq	r2, sp, ip, ror #10
    1598:	91020000 	mrsls	r0, (UNDEF: 2)
    159c:	108e1e68 	addne	r1, lr, r8, ror #28
    15a0:	6e010000 	cdpvs	0, 0, cr0, cr1, cr0, {0}
    15a4:	00004d0e 	andeq	r4, r0, lr, lsl #26
    15a8:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    15ac:	0d432100 	stfeqe	f2, [r3, #-0]
    15b0:	5f010000 	svcpl	0x00010000
    15b4:	00101e12 	andseq	r1, r0, r2, lsl lr
    15b8:	00008b00 	andeq	r8, r0, r0, lsl #22
    15bc:	0084ec00 	addeq	lr, r4, r0, lsl #24
    15c0:	00005000 	andeq	r5, r0, r0
    15c4:	4c9c0100 	ldfmis	f0, [ip], {0}
    15c8:	20000009 	andcs	r0, r0, r9
    15cc:	00000501 	andeq	r0, r0, r1, lsl #10
    15d0:	4d205f01 	stcmi	15, cr5, [r0, #-4]!
    15d4:	02000000 	andeq	r0, r0, #0
    15d8:	0d206c91 	stceq	12, cr6, [r0, #-580]!	; 0xfffffdbc
    15dc:	0100000f 	tsteq	r0, pc
    15e0:	004d2f5f 	subeq	r2, sp, pc, asr pc
    15e4:	91020000 	mrsls	r0, (UNDEF: 2)
    15e8:	09692068 	stmdbeq	r9!, {r3, r5, r6, sp}^
    15ec:	5f010000 	svcpl	0x00010000
    15f0:	00004d3f 	andeq	r4, r0, pc, lsr sp
    15f4:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    15f8:	00108e1e 	andseq	r8, r0, lr, lsl lr
    15fc:	16610100 	strbtne	r0, [r1], -r0, lsl #2
    1600:	0000008b 	andeq	r0, r0, fp, lsl #1
    1604:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1608:	00105421 	andseq	r5, r0, r1, lsr #8
    160c:	0a530100 	beq	14c1a14 <__bss_end+0x14b76d8>
    1610:	00000d48 	andeq	r0, r0, r8, asr #26
    1614:	0000004d 	andeq	r0, r0, sp, asr #32
    1618:	000084a8 	andeq	r8, r0, r8, lsr #9
    161c:	00000044 	andeq	r0, r0, r4, asr #32
    1620:	09989c01 	ldmibeq	r8, {r0, sl, fp, ip, pc}
    1624:	01200000 			; <UNDEFINED> instruction: 0x01200000
    1628:	01000005 	tsteq	r0, r5
    162c:	004d1a53 	subeq	r1, sp, r3, asr sl
    1630:	91020000 	mrsls	r0, (UNDEF: 2)
    1634:	0f0d206c 	svceq	0x000d206c
    1638:	53010000 	movwpl	r0, #4096	; 0x1000
    163c:	00004d29 	andeq	r4, r0, r9, lsr #26
    1640:	68910200 	ldmvs	r1, {r9}
    1644:	00104d1e 	andseq	r4, r0, lr, lsl sp
    1648:	0e550100 	rdfeqs	f0, f5, f0
    164c:	0000004d 	andeq	r0, r0, sp, asr #32
    1650:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1654:	00104721 	andseq	r4, r0, r1, lsr #14
    1658:	0a460100 	beq	1181a60 <__bss_end+0x1177724>
    165c:	00001029 	andeq	r1, r0, r9, lsr #32
    1660:	0000004d 	andeq	r0, r0, sp, asr #32
    1664:	00008458 	andeq	r8, r0, r8, asr r4
    1668:	00000050 	andeq	r0, r0, r0, asr r0
    166c:	09f39c01 	ldmibeq	r3!, {r0, sl, fp, ip, pc}^
    1670:	01200000 			; <UNDEFINED> instruction: 0x01200000
    1674:	01000005 	tsteq	r0, r5
    1678:	004d1946 	subeq	r1, sp, r6, asr #18
    167c:	91020000 	mrsls	r0, (UNDEF: 2)
    1680:	0dfc206c 	ldcleq	0, cr2, [ip, #432]!	; 0x1b0
    1684:	46010000 	strmi	r0, [r1], -r0
    1688:	00012930 	andeq	r2, r1, r0, lsr r9
    168c:	68910200 	ldmvs	r1, {r9}
    1690:	000f1320 	andeq	r1, pc, r0, lsr #6
    1694:	41460100 	mrsmi	r0, (UNDEF: 86)
    1698:	0000071e 	andeq	r0, r0, lr, lsl r7
    169c:	1e649102 	lgnnes	f1, f2
    16a0:	0000108e 	andeq	r1, r0, lr, lsl #1
    16a4:	4d0e4801 	stcmi	8, cr4, [lr, #-4]
    16a8:	02000000 	andeq	r0, r0, #0
    16ac:	23007491 	movwcs	r7, #1169	; 0x491
    16b0:	00000cf1 	strdeq	r0, [r0], -r1
    16b4:	06064001 	streq	r4, [r6], -r1
    16b8:	2c00000e 	stccs	0, cr0, [r0], {14}
    16bc:	2c000084 	stccs	0, cr0, [r0], {132}	; 0x84
    16c0:	01000000 	mrseq	r0, (UNDEF: 0)
    16c4:	000a1d9c 	muleq	sl, ip, sp
    16c8:	05012000 	streq	r2, [r1, #-0]
    16cc:	40010000 	andmi	r0, r1, r0
    16d0:	00004d15 	andeq	r4, r0, r5, lsl sp
    16d4:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    16d8:	0ed22100 	cdpeq	1, 13, cr2, cr2, cr0, {0}
    16dc:	33010000 	movwcc	r0, #4096	; 0x1000
    16e0:	000f190a 	andeq	r1, pc, sl, lsl #18
    16e4:	00004d00 	andeq	r4, r0, r0, lsl #26
    16e8:	0083dc00 	addeq	sp, r3, r0, lsl #24
    16ec:	00005000 	andeq	r5, r0, r0
    16f0:	789c0100 	ldmvc	ip, {r8}
    16f4:	2000000a 	andcs	r0, r0, sl
    16f8:	00000501 	andeq	r0, r0, r1, lsl #10
    16fc:	4d193301 	ldcmi	3, cr3, [r9, #-4]
    1700:	02000000 	andeq	r0, r0, #0
    1704:	6a206c91 	bvs	81c950 <__bss_end+0x812614>
    1708:	01000010 	tsteq	r0, r0, lsl r0
    170c:	02032b33 	andeq	r2, r3, #52224	; 0xcc00
    1710:	91020000 	mrsls	r0, (UNDEF: 2)
    1714:	0f462068 	svceq	0x00462068
    1718:	33010000 	movwcc	r0, #4096	; 0x1000
    171c:	00004d3c 	andeq	r4, r0, ip, lsr sp
    1720:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    1724:	0010181e 	andseq	r1, r0, lr, lsl r8
    1728:	0e350100 	rsfeqs	f0, f5, f0
    172c:	0000004d 	andeq	r0, r0, sp, asr #32
    1730:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1734:	0010b821 	andseq	fp, r0, r1, lsr #16
    1738:	0a250100 	beq	941b40 <__bss_end+0x937804>
    173c:	00001071 	andeq	r1, r0, r1, ror r0
    1740:	0000004d 	andeq	r0, r0, sp, asr #32
    1744:	0000838c 	andeq	r8, r0, ip, lsl #7
    1748:	00000050 	andeq	r0, r0, r0, asr r0
    174c:	0ad39c01 	beq	ff4e8758 <__bss_end+0xff4de41c>
    1750:	01200000 			; <UNDEFINED> instruction: 0x01200000
    1754:	01000005 	tsteq	r0, r5
    1758:	004d1825 	subeq	r1, sp, r5, lsr #16
    175c:	91020000 	mrsls	r0, (UNDEF: 2)
    1760:	106a206c 	rsbne	r2, sl, ip, rrx
    1764:	25010000 	strcs	r0, [r1, #-0]
    1768:	000ad92a 	andeq	sp, sl, sl, lsr #18
    176c:	68910200 	ldmvs	r1, {r9}
    1770:	000f4620 	andeq	r4, pc, r0, lsr #12
    1774:	3b250100 	blcc	941b7c <__bss_end+0x937840>
    1778:	0000004d 	andeq	r0, r0, sp, asr #32
    177c:	1e649102 	lgnnes	f1, f2
    1780:	00000d15 	andeq	r0, r0, r5, lsl sp
    1784:	4d0e2701 	stcmi	7, cr2, [lr, #-4]
    1788:	02000000 	andeq	r0, r0, #0
    178c:	0d007491 	cfstrseq	mvf7, [r0, #-580]	; 0xfffffdbc
    1790:	00002504 	andeq	r2, r0, r4, lsl #10
    1794:	0ad30300 	beq	ff4c239c <__bss_end+0xff4b8060>
    1798:	de210000 	cdple	0, 2, cr0, cr1, cr0, {0}
    179c:	0100000e 	tsteq	r0, lr
    17a0:	10c40a19 	sbcne	r0, r4, r9, lsl sl
    17a4:	004d0000 	subeq	r0, sp, r0
    17a8:	83480000 	movthi	r0, #32768	; 0x8000
    17ac:	00440000 	subeq	r0, r4, r0
    17b0:	9c010000 	stcls	0, cr0, [r1], {-0}
    17b4:	00000b2a 	andeq	r0, r0, sl, lsr #22
    17b8:	0010af20 	andseq	sl, r0, r0, lsr #30
    17bc:	1b190100 	blne	641bc4 <__bss_end+0x637888>
    17c0:	00000203 	andeq	r0, r0, r3, lsl #4
    17c4:	206c9102 	rsbcs	r9, ip, r2, lsl #2
    17c8:	00001065 	andeq	r1, r0, r5, rrx
    17cc:	d2351901 	eorsle	r1, r5, #16384	; 0x4000
    17d0:	02000001 	andeq	r0, r0, #1
    17d4:	011e6891 			; <UNDEFINED> instruction: 0x011e6891
    17d8:	01000005 	tsteq	r0, r5
    17dc:	004d0e1b 	subeq	r0, sp, fp, lsl lr
    17e0:	91020000 	mrsls	r0, (UNDEF: 2)
    17e4:	62240074 	eorvs	r0, r4, #116	; 0x74
    17e8:	0100000d 	tsteq	r0, sp
    17ec:	0d1b0614 	ldceq	6, cr0, [fp, #-80]	; 0xffffffb0
    17f0:	832c0000 			; <UNDEFINED> instruction: 0x832c0000
    17f4:	001c0000 	andseq	r0, ip, r0
    17f8:	9c010000 	stcls	0, cr0, [r1], {-0}
    17fc:	00105b23 	andseq	r5, r0, r3, lsr #22
    1800:	060e0100 	streq	r0, [lr], -r0, lsl #2
    1804:	00000dee 	andeq	r0, r0, lr, ror #27
    1808:	00008300 	andeq	r8, r0, r0, lsl #6
    180c:	0000002c 	andeq	r0, r0, ip, lsr #32
    1810:	0b6a9c01 	bleq	1aa881c <__bss_end+0x1a9e4e0>
    1814:	59200000 	stmdbpl	r0!, {}	; <UNPREDICTABLE>
    1818:	0100000d 	tsteq	r0, sp
    181c:	0038140e 	eorseq	r1, r8, lr, lsl #8
    1820:	91020000 	mrsls	r0, (UNDEF: 2)
    1824:	bd250074 	stclt	0, cr0, [r5, #-464]!	; 0xfffffe30
    1828:	01000010 	tsteq	r0, r0, lsl r0
    182c:	0e100a04 	vnmlseq.f32	s0, s0, s8
    1830:	004d0000 	subeq	r0, sp, r0
    1834:	82d40000 	sbcshi	r0, r4, #0
    1838:	002c0000 	eoreq	r0, ip, r0
    183c:	9c010000 	stcls	0, cr0, [r1], {-0}
    1840:	64697022 	strbtvs	r7, [r9], #-34	; 0xffffffde
    1844:	0e060100 	adfeqs	f0, f6, f0
    1848:	0000004d 	andeq	r0, r0, sp, asr #32
    184c:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1850:	00062d00 	andeq	r2, r6, r0, lsl #26
    1854:	af000400 	svcge	0x00000400
    1858:	04000006 	streq	r0, [r0], #-6
    185c:	000e2101 	andeq	r2, lr, r1, lsl #2
    1860:	117f0400 	cmnne	pc, r0, lsl #8
    1864:	0f4b0000 	svceq	0x004b0000
    1868:	87300000 	ldrhi	r0, [r0, -r0]!
    186c:	0c5c0000 	mraeq	r0, ip, acc0
    1870:	060e0000 	streq	r0, [lr], -r0
    1874:	49020000 	stmdbmi	r2, {}	; <UNPREDICTABLE>
    1878:	03000000 	movweq	r0, #0
    187c:	000011dc 	ldrdeq	r1, [r0], -ip
    1880:	61100501 	tstvs	r0, r1, lsl #10
    1884:	11000000 	mrsne	r0, (UNDEF: 0)
    1888:	33323130 	teqcc	r2, #48, 2
    188c:	37363534 			; <UNDEFINED> instruction: 0x37363534
    1890:	42413938 	submi	r3, r1, #56, 18	; 0xe0000
    1894:	46454443 	strbmi	r4, [r5], -r3, asr #8
    1898:	01040000 	mrseq	r0, (UNDEF: 4)
    189c:	00250103 	eoreq	r0, r5, r3, lsl #2
    18a0:	74050000 	strvc	r0, [r5], #-0
    18a4:	61000000 	mrsvs	r0, (UNDEF: 0)
    18a8:	06000000 	streq	r0, [r0], -r0
    18ac:	00000066 	andeq	r0, r0, r6, rrx
    18b0:	51070010 	tstpl	r7, r0, lsl r0
    18b4:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    18b8:	188d0704 	stmne	sp, {r2, r8, r9, sl}
    18bc:	01080000 	mrseq	r0, (UNDEF: 8)
    18c0:	000b6008 	andeq	r6, fp, r8
    18c4:	006d0700 	rsbeq	r0, sp, r0, lsl #14
    18c8:	2a090000 	bcs	2418d0 <__bss_end+0x237594>
    18cc:	0a000000 	beq	18d4 <shift+0x18d4>
    18d0:	000011e8 	andeq	r1, r0, r8, ror #3
    18d4:	7d06d201 	sfmvc	f5, 1, [r6, #-4]
    18d8:	64000012 	strvs	r0, [r0], #-18	; 0xffffffee
    18dc:	28000090 	stmdacs	r0, {r4, r7}
    18e0:	01000003 	tsteq	r0, r3
    18e4:	00011f9c 	muleq	r1, ip, pc	; <UNPREDICTABLE>
    18e8:	00660b00 	rsbeq	r0, r6, r0, lsl #22
    18ec:	1f11d201 	svcne	0x0011d201
    18f0:	03000001 	movweq	r0, #1
    18f4:	0b7fa491 	bleq	1feab40 <__bss_end+0x1fe0804>
    18f8:	d2010072 	andle	r0, r1, #114	; 0x72
    18fc:	00012619 	andeq	r2, r1, r9, lsl r6
    1900:	a0910300 	addsge	r0, r1, r0, lsl #6
    1904:	128f0c7f 	addne	r0, pc, #32512	; 0x7f00
    1908:	d4010000 	strle	r0, [r1], #-0
    190c:	00012c13 	andeq	r2, r1, r3, lsl ip
    1910:	58910200 	ldmpl	r1, {r9}
    1914:	00123a0c 	andseq	r3, r2, ip, lsl #20
    1918:	1bd40100 	blne	ff501d20 <__bss_end+0xff4f79e4>
    191c:	0000012c 	andeq	r0, r0, ip, lsr #2
    1920:	0d509102 	ldfeqp	f1, [r0, #-8]
    1924:	d4010069 	strle	r0, [r1], #-105	; 0xffffff97
    1928:	00012c24 	andeq	r2, r1, r4, lsr #24
    192c:	48910200 	ldmmi	r1, {r9}
    1930:	0011ed0c 	andseq	lr, r1, ip, lsl #26
    1934:	27d40100 	ldrbcs	r0, [r4, r0, lsl #2]
    1938:	0000012c 	andeq	r0, r0, ip, lsr #2
    193c:	0c409102 	stfeqp	f1, [r0], {2}
    1940:	000011cc 	andeq	r1, r0, ip, asr #3
    1944:	2c2fd401 	cfstrscs	mvf13, [pc], #-4	; 1948 <shift+0x1948>
    1948:	03000001 	movweq	r0, #1
    194c:	0c7fb891 	ldcleq	8, cr11, [pc], #-580	; 1710 <shift+0x1710>
    1950:	00001150 	andeq	r1, r0, r0, asr r1
    1954:	2c39d401 	cfldrscs	mvf13, [r9], #-4
    1958:	03000001 	movweq	r0, #1
    195c:	0c7fb091 	ldcleq	0, cr11, [pc], #-580	; 1720 <shift+0x1720>
    1960:	000011fb 	strdeq	r1, [r0], -fp
    1964:	1f0bd501 	svcne	0x000bd501
    1968:	03000001 	movweq	r0, #1
    196c:	007fac91 			; <UNDEFINED> instruction: 0x007fac91
    1970:	94040408 	strls	r0, [r4], #-1032	; 0xfffffbf8
    1974:	0e000015 	mcreq	0, 0, r0, cr0, cr5, {0}
    1978:	00006d04 	andeq	r6, r0, r4, lsl #26
    197c:	05080800 	streq	r0, [r8, #-2048]	; 0xfffff800
    1980:	00000243 	andeq	r0, r0, r3, asr #4
    1984:	0012420f 	andseq	r4, r2, pc, lsl #4
    1988:	05c80100 	strbeq	r0, [r8, #256]	; 0x100
    198c:	00001117 	andeq	r1, r0, r7, lsl r1
    1990:	0000017f 	andeq	r0, r0, pc, ror r1
    1994:	00008ffc 	strdeq	r8, [r0], -ip
    1998:	00000068 	andeq	r0, r0, r8, rrx
    199c:	017f9c01 	cmneq	pc, r1, lsl #24
    19a0:	ed100000 	ldc	0, cr0, [r0, #-0]
    19a4:	01000011 	tsteq	r0, r1, lsl r0
    19a8:	017f0ec8 	cmneq	pc, r8, asr #29
    19ac:	91020000 	mrsls	r0, (UNDEF: 2)
    19b0:	0f0d106c 	svceq	0x000d106c
    19b4:	c8010000 	stmdagt	r1, {}	; <UNPREDICTABLE>
    19b8:	00017f1a 	andeq	r7, r1, sl, lsl pc
    19bc:	68910200 	ldmvs	r1, {r9}
    19c0:	0001250c 	andeq	r2, r1, ip, lsl #10
    19c4:	09ca0100 	stmibeq	sl, {r8}^
    19c8:	0000017f 	andeq	r0, r0, pc, ror r1
    19cc:	00749102 	rsbseq	r9, r4, r2, lsl #2
    19d0:	69050411 	stmdbvs	r5, {r0, r4, sl}
    19d4:	1200746e 	andne	r7, r0, #1845493760	; 0x6e000000
    19d8:	00001217 	andeq	r1, r0, r7, lsl r2
    19dc:	f106bd01 			; <UNDEFINED> instruction: 0xf106bd01
    19e0:	7c000010 	stcvc	0, cr0, [r0], {16}
    19e4:	8000008f 	andhi	r0, r0, pc, lsl #1
    19e8:	01000000 	mrseq	r0, (UNDEF: 0)
    19ec:	0002039c 	muleq	r2, ip, r3
    19f0:	72730b00 	rsbsvc	r0, r3, #0, 22
    19f4:	bd010063 	stclt	0, cr0, [r1, #-396]	; 0xfffffe74
    19f8:	00020319 	andeq	r0, r2, r9, lsl r3
    19fc:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    1a00:	7473640b 	ldrbtvc	r6, [r3], #-1035	; 0xfffffbf5
    1a04:	24bd0100 	ldrtcs	r0, [sp], #256	; 0x100
    1a08:	0000020a 	andeq	r0, r0, sl, lsl #4
    1a0c:	0b609102 	bleq	1825e1c <__bss_end+0x181bae0>
    1a10:	006d756e 	rsbeq	r7, sp, lr, ror #10
    1a14:	7f2dbd01 	svcvc	0x002dbd01
    1a18:	02000001 	andeq	r0, r0, #1
    1a1c:	f40c5c91 			; <UNDEFINED> instruction: 0xf40c5c91
    1a20:	01000011 	tsteq	r0, r1, lsl r0
    1a24:	020c0ebf 	andeq	r0, ip, #3056	; 0xbf0
    1a28:	91020000 	mrsls	r0, (UNDEF: 2)
    1a2c:	11d50c70 	bicsne	r0, r5, r0, ror ip
    1a30:	c0010000 	andgt	r0, r1, r0
    1a34:	00012608 	andeq	r2, r1, r8, lsl #12
    1a38:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1a3c:	008fa413 	addeq	sl, pc, r3, lsl r4	; <UNPREDICTABLE>
    1a40:	00004800 	andeq	r4, r0, r0, lsl #16
    1a44:	00690d00 	rsbeq	r0, r9, r0, lsl #26
    1a48:	7f0bc201 	svcvc	0x000bc201
    1a4c:	02000001 	andeq	r0, r0, #1
    1a50:	00007491 	muleq	r0, r1, r4
    1a54:	0209040e 	andeq	r0, r9, #234881024	; 0xe000000
    1a58:	15140000 	ldrne	r0, [r4, #-0]
    1a5c:	74040e04 	strvc	r0, [r4], #-3588	; 0xfffff1fc
    1a60:	12000000 	andne	r0, r0, #0
    1a64:	00001211 	andeq	r1, r0, r1, lsl r2
    1a68:	5c06b501 	cfstr32pl	mvfx11, [r6], {1}
    1a6c:	14000011 	strne	r0, [r0], #-17	; 0xffffffef
    1a70:	6800008f 	stmdavs	r0, {r0, r1, r2, r3, r7}
    1a74:	01000000 	mrseq	r0, (UNDEF: 0)
    1a78:	0002719c 	muleq	r2, ip, r1
    1a7c:	12881000 	addne	r1, r8, #0
    1a80:	b5010000 	strlt	r0, [r1, #-0]
    1a84:	00020a12 	andeq	r0, r2, r2, lsl sl
    1a88:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1a8c:	00128f10 	andseq	r8, r2, r0, lsl pc
    1a90:	1eb50100 	frdnes	f0, f5, f0
    1a94:	0000017f 	andeq	r0, r0, pc, ror r1
    1a98:	0d689102 	stfeqp	f1, [r8, #-8]!
    1a9c:	006d656d 	rsbeq	r6, sp, sp, ror #10
    1aa0:	2608b701 	strcs	fp, [r8], -r1, lsl #14
    1aa4:	02000001 	andeq	r0, r0, #1
    1aa8:	30137091 	mulscc	r3, r1, r0
    1aac:	3c00008f 	stccc	0, cr0, [r0], {143}	; 0x8f
    1ab0:	0d000000 	stceq	0, cr0, [r0, #-0]
    1ab4:	b9010069 	stmdblt	r1, {r0, r3, r5, r6}
    1ab8:	00017f0b 	andeq	r7, r1, fp, lsl #30
    1abc:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1ac0:	b1160000 	tstlt	r6, r0
    1ac4:	01000011 	tsteq	r0, r1, lsl r0
    1ac8:	129d07a4 	addsne	r0, sp, #164, 14	; 0x2900000
    1acc:	01260000 			; <UNDEFINED> instruction: 0x01260000
    1ad0:	8e3c0000 	cdphi	0, 3, cr0, cr12, cr0, {0}
    1ad4:	00d80000 	sbcseq	r0, r8, r0
    1ad8:	9c010000 	stcls	0, cr0, [r1], {-0}
    1adc:	000002f0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
    1ae0:	00114510 	andseq	r4, r1, r0, lsl r5
    1ae4:	15a40100 	strne	r0, [r4, #256]!	; 0x100
    1ae8:	00000126 	andeq	r0, r0, r6, lsr #2
    1aec:	0b649102 	bleq	1925efc <__bss_end+0x191bbc0>
    1af0:	00637273 	rsbeq	r7, r3, r3, ror r2
    1af4:	0c27a401 	cfstrseq	mvf10, [r7], #-4
    1af8:	02000002 	andeq	r0, r0, #2
    1afc:	46106091 			; <UNDEFINED> instruction: 0x46106091
    1b00:	0100000f 	tsteq	r0, pc
    1b04:	017f2fa4 	cmneq	pc, r4, lsr #31
    1b08:	91020000 	mrsls	r0, (UNDEF: 2)
    1b0c:	11b90c5c 			; <UNDEFINED> instruction: 0x11b90c5c
    1b10:	a5010000 	strge	r0, [r1, #-0]
    1b14:	00017f09 	andeq	r7, r1, r9, lsl #30
    1b18:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1b1c:	01006d0d 	tsteq	r0, sp, lsl #26
    1b20:	017f09a7 	cmneq	pc, r7, lsr #19
    1b24:	91020000 	mrsls	r0, (UNDEF: 2)
    1b28:	8e801374 	mcrhi	3, 4, r1, cr0, cr4, {3}
    1b2c:	00700000 	rsbseq	r0, r0, r0
    1b30:	690d0000 	stmdbvs	sp, {}	; <UNPREDICTABLE>
    1b34:	0dab0100 	stfeqs	f0, [fp]
    1b38:	0000017f 	andeq	r0, r0, pc, ror r1
    1b3c:	00709102 	rsbseq	r9, r0, r2, lsl #2
    1b40:	11551600 	cmpne	r5, r0, lsl #12
    1b44:	9a010000 	bls	41b4c <__bss_end+0x37810>
    1b48:	00117007 	andseq	r7, r1, r7
    1b4c:	00012600 	andeq	r2, r1, r0, lsl #12
    1b50:	008d9000 	addeq	r9, sp, r0
    1b54:	0000ac00 	andeq	sl, r0, r0, lsl #24
    1b58:	6d9c0100 	ldfvss	f0, [ip]
    1b5c:	10000003 	andne	r0, r0, r3
    1b60:	00001145 	andeq	r1, r0, r5, asr #2
    1b64:	26149a01 	ldrcs	r9, [r4], -r1, lsl #20
    1b68:	02000001 	andeq	r0, r0, #1
    1b6c:	730b6491 	movwvc	r6, #46225	; 0xb491
    1b70:	01006372 	tsteq	r0, r2, ror r3
    1b74:	020c269a 	andeq	r2, ip, #161480704	; 0x9a00000
    1b78:	91020000 	mrsls	r0, (UNDEF: 2)
    1b7c:	006e0d60 	rsbeq	r0, lr, r0, ror #26
    1b80:	7f099b01 	svcvc	0x00099b01
    1b84:	02000001 	andeq	r0, r0, #1
    1b88:	6d0d6c91 	stcvs	12, cr6, [sp, #-580]	; 0xfffffdbc
    1b8c:	099c0100 	ldmibeq	ip, {r8}
    1b90:	0000017f 	andeq	r0, r0, pc, ror r1
    1b94:	0c749102 	ldfeqp	f1, [r4], #-8
    1b98:	000011b9 			; <UNDEFINED> instruction: 0x000011b9
    1b9c:	7f099d01 	svcvc	0x00099d01
    1ba0:	02000001 	andeq	r0, r0, #1
    1ba4:	c4136891 	ldrgt	r6, [r3], #-2193	; 0xfffff76f
    1ba8:	5400008d 	strpl	r0, [r0], #-141	; 0xffffff73
    1bac:	0d000000 	stceq	0, cr0, [r0, #-0]
    1bb0:	9e010069 	cdpls	0, 0, cr0, cr1, cr9, {3}
    1bb4:	00017f0d 	andeq	r7, r1, sp, lsl #30
    1bb8:	70910200 	addsvc	r0, r1, r0, lsl #4
    1bbc:	960f0000 	strls	r0, [pc], -r0
    1bc0:	01000012 	tsteq	r0, r2, lsl r0
    1bc4:	1247058f 	subne	r0, r7, #599785472	; 0x23c00000
    1bc8:	017f0000 	cmneq	pc, r0
    1bcc:	8d3c0000 	ldchi	0, cr0, [ip, #-0]
    1bd0:	00540000 	subseq	r0, r4, r0
    1bd4:	9c010000 	stcls	0, cr0, [r1], {-0}
    1bd8:	000003a6 	andeq	r0, r0, r6, lsr #7
    1bdc:	0100730b 	tsteq	r0, fp, lsl #6
    1be0:	020c188f 	andeq	r1, ip, #9371648	; 0x8f0000
    1be4:	91020000 	mrsls	r0, (UNDEF: 2)
    1be8:	00690d6c 	rsbeq	r0, r9, ip, ror #26
    1bec:	7f069101 	svcvc	0x00069101
    1bf0:	02000001 	andeq	r0, r0, #1
    1bf4:	0f007491 	svceq	0x00007491
    1bf8:	0000121e 	andeq	r1, r0, lr, lsl r2
    1bfc:	54057f01 	strpl	r7, [r5], #-3841	; 0xfffff0ff
    1c00:	7f000012 	svcvc	0x00000012
    1c04:	90000001 	andls	r0, r0, r1
    1c08:	ac00008c 	stcge	0, cr0, [r0], {140}	; 0x8c
    1c0c:	01000000 	mrseq	r0, (UNDEF: 0)
    1c10:	00040c9c 	muleq	r4, ip, ip
    1c14:	31730b00 	cmncc	r3, r0, lsl #22
    1c18:	197f0100 	ldmdbne	pc!, {r8}^	; <UNPREDICTABLE>
    1c1c:	0000020c 	andeq	r0, r0, ip, lsl #4
    1c20:	0b6c9102 	bleq	1b26030 <__bss_end+0x1b1bcf4>
    1c24:	01003273 	tsteq	r0, r3, ror r2
    1c28:	020c297f 	andeq	r2, ip, #2080768	; 0x1fc000
    1c2c:	91020000 	mrsls	r0, (UNDEF: 2)
    1c30:	756e0b68 	strbvc	r0, [lr, #-2920]!	; 0xfffff498
    1c34:	7f01006d 	svcvc	0x0001006d
    1c38:	00017f31 	andeq	r7, r1, r1, lsr pc
    1c3c:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    1c40:	0031750d 	eorseq	r7, r1, sp, lsl #10
    1c44:	0c108101 	ldfeqd	f0, [r0], {1}
    1c48:	02000004 	andeq	r0, r0, #4
    1c4c:	750d7791 	strvc	r7, [sp, #-1937]	; 0xfffff86f
    1c50:	81010032 	tsthi	r1, r2, lsr r0
    1c54:	00040c14 	andeq	r0, r4, r4, lsl ip
    1c58:	76910200 	ldrvc	r0, [r1], r0, lsl #4
    1c5c:	08010800 	stmdaeq	r1, {fp}
    1c60:	00000b57 	andeq	r0, r0, r7, asr fp
    1c64:	0011680f 	andseq	r6, r1, pc, lsl #16
    1c68:	07730100 	ldrbeq	r0, [r3, -r0, lsl #2]!
    1c6c:	000010e0 	andeq	r1, r0, r0, ror #1
    1c70:	00000126 	andeq	r0, r0, r6, lsr #2
    1c74:	00008bd0 	ldrdeq	r8, [r0], -r0
    1c78:	000000c0 	andeq	r0, r0, r0, asr #1
    1c7c:	046c9c01 	strbteq	r9, [ip], #-3073	; 0xfffff3ff
    1c80:	45100000 	ldrmi	r0, [r0, #-0]
    1c84:	01000011 	tsteq	r0, r1, lsl r0
    1c88:	01261573 			; <UNDEFINED> instruction: 0x01261573
    1c8c:	91020000 	mrsls	r0, (UNDEF: 2)
    1c90:	72730b6c 	rsbsvc	r0, r3, #108, 22	; 0x1b000
    1c94:	73010063 	movwvc	r0, #4195	; 0x1063
    1c98:	00020c27 	andeq	r0, r2, r7, lsr #24
    1c9c:	68910200 	ldmvs	r1, {r9}
    1ca0:	6d756e0b 	ldclvs	14, cr6, [r5, #-44]!	; 0xffffffd4
    1ca4:	30730100 	rsbscc	r0, r3, r0, lsl #2
    1ca8:	0000017f 	andeq	r0, r0, pc, ror r1
    1cac:	0d649102 	stfeqp	f1, [r4, #-8]!
    1cb0:	75010069 	strvc	r0, [r1, #-105]	; 0xffffff97
    1cb4:	00017f06 	andeq	r7, r1, r6, lsl #30
    1cb8:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1cbc:	11210f00 			; <UNDEFINED> instruction: 0x11210f00
    1cc0:	57010000 	strpl	r0, [r1, -r0]
    1cc4:	00113a07 	andseq	r3, r1, r7, lsl #20
    1cc8:	00011f00 	andeq	r1, r1, r0, lsl #30
    1ccc:	008a7400 	addeq	r7, sl, r0, lsl #8
    1cd0:	00015c00 	andeq	r5, r1, r0, lsl #24
    1cd4:	0d9c0100 	ldfeqs	f0, [ip]
    1cd8:	10000005 	andne	r0, r0, r5
    1cdc:	0000114a 	andeq	r1, r0, sl, asr #2
    1ce0:	0c185701 	ldceq	7, cr5, [r8], {1}
    1ce4:	02000002 	andeq	r0, r0, #2
    1ce8:	330c4491 	movwcc	r4, #50321	; 0xc491
    1cec:	01000012 	tsteq	r0, r2, lsl r0
    1cf0:	050d0c58 	streq	r0, [sp, #-3160]	; 0xfffff3a8
    1cf4:	91020000 	mrsls	r0, (UNDEF: 2)
    1cf8:	11c00c70 	bicne	r0, r0, r0, ror ip
    1cfc:	59010000 	stmdbpl	r1, {}	; <UNPREDICTABLE>
    1d00:	00050d0c 	andeq	r0, r5, ip, lsl #26
    1d04:	60910200 	addsvs	r0, r1, r0, lsl #4
    1d08:	706d740d 	rsbvc	r7, sp, sp, lsl #8
    1d0c:	0c5b0100 	ldfeqe	f0, [fp], {-0}
    1d10:	0000050d 	andeq	r0, r0, sp, lsl #10
    1d14:	0c589102 	ldfeqp	f1, [r8], {2}
    1d18:	00000b4f 	andeq	r0, r0, pc, asr #22
    1d1c:	7f095c01 	svcvc	0x00095c01
    1d20:	02000001 	andeq	r0, r0, #1
    1d24:	7d0c5491 	cfstrsvc	mvf5, [ip, #-580]	; 0xfffffdbc
    1d28:	01000018 	tsteq	r0, r8, lsl r0
    1d2c:	017f095d 	cmneq	pc, sp, asr r9	; <UNPREDICTABLE>
    1d30:	91020000 	mrsls	r0, (UNDEF: 2)
    1d34:	12030c6c 	andne	r0, r3, #108, 24	; 0x6c00
    1d38:	5e010000 	cdppl	0, 0, cr0, cr1, cr0, {0}
    1d3c:	0005140a 	andeq	r1, r5, sl, lsl #8
    1d40:	6b910200 	blvs	fe442548 <__bss_end+0xfe43820c>
    1d44:	008ad013 	addeq	sp, sl, r3, lsl r0
    1d48:	0000d000 	andeq	sp, r0, r0
    1d4c:	61760d00 	cmnvs	r6, r0, lsl #26
    1d50:	6701006c 	strvs	r0, [r1, -ip, rrx]
    1d54:	00050d10 	andeq	r0, r5, r0, lsl sp
    1d58:	48910200 	ldmmi	r1, {r9}
    1d5c:	08080000 	stmdaeq	r8, {}	; <UNPREDICTABLE>
    1d60:	00183d04 	andseq	r3, r8, r4, lsl #26
    1d64:	02010800 	andeq	r0, r1, #0, 16
    1d68:	00000857 	andeq	r0, r0, r7, asr r8
    1d6c:	0011260f 	andseq	r2, r1, pc, lsl #12
    1d70:	053c0100 	ldreq	r0, [ip, #-256]!	; 0xffffff00
    1d74:	00001101 	andeq	r1, r0, r1, lsl #2
    1d78:	0000017f 	andeq	r0, r0, pc, ror r1
    1d7c:	00008974 	andeq	r8, r0, r4, ror r9
    1d80:	00000100 	andeq	r0, r0, r0, lsl #2
    1d84:	057e9c01 	ldrbeq	r9, [lr, #-3073]!	; 0xfffff3ff
    1d88:	4a100000 	bmi	401d90 <__bss_end+0x3f7a54>
    1d8c:	01000011 	tsteq	r0, r1, lsl r0
    1d90:	020c213c 	andeq	r2, ip, #60, 2
    1d94:	91020000 	mrsls	r0, (UNDEF: 2)
    1d98:	6f640d6c 	svcvs	0x00640d6c
    1d9c:	3e010074 	mcrcc	0, 0, r0, cr1, cr4, {3}
    1da0:	0005140a 	andeq	r1, r5, sl, lsl #8
    1da4:	77910200 	ldrvc	r0, [r1, r0, lsl #4]
    1da8:	0012260c 	andseq	r2, r2, ip, lsl #12
    1dac:	0a3f0100 	beq	fc21b4 <__bss_end+0xfb7e78>
    1db0:	00000514 	andeq	r0, r0, r4, lsl r5
    1db4:	13769102 	cmnne	r6, #-2147483648	; 0x80000000
    1db8:	000089a4 	andeq	r8, r0, r4, lsr #19
    1dbc:	0000008c 	andeq	r0, r0, ip, lsl #1
    1dc0:	0100630d 	tsteq	r0, sp, lsl #6
    1dc4:	006d0e41 	rsbeq	r0, sp, r1, asr #28
    1dc8:	91020000 	mrsls	r0, (UNDEF: 2)
    1dcc:	16000075 			; <UNDEFINED> instruction: 0x16000075
    1dd0:	00001135 	andeq	r1, r0, r5, lsr r1
    1dd4:	66052601 	strvs	r2, [r5], -r1, lsl #12
    1dd8:	7f000012 	svcvc	0x00000012
    1ddc:	a8000001 	stmdage	r0, {r0}
    1de0:	cc000088 	stcgt	0, cr0, [r0], {136}	; 0x88
    1de4:	01000000 	mrseq	r0, (UNDEF: 0)
    1de8:	0005bb9c 	muleq	r5, ip, fp
    1dec:	114a1000 	mrsne	r1, (UNDEF: 74)
    1df0:	26010000 	strcs	r0, [r1], -r0
    1df4:	00020c16 	andeq	r0, r2, r6, lsl ip
    1df8:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1dfc:	0012330c 	andseq	r3, r2, ip, lsl #6
    1e00:	062a0100 	strteq	r0, [sl], -r0, lsl #2
    1e04:	0000017f 	andeq	r0, r0, pc, ror r1
    1e08:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1e0c:	0011c717 	andseq	ip, r1, r7, lsl r7
    1e10:	06080100 	streq	r0, [r8], -r0, lsl #2
    1e14:	00001271 	andeq	r1, r0, r1, ror r2
    1e18:	00008730 	andeq	r8, r0, r0, lsr r7
    1e1c:	00000178 	andeq	r0, r0, r8, ror r1
    1e20:	4a109c01 	bmi	428e2c <__bss_end+0x41eaf0>
    1e24:	01000011 	tsteq	r0, r1, lsl r0
    1e28:	017f0f08 	cmneq	pc, r8, lsl #30
    1e2c:	91020000 	mrsls	r0, (UNDEF: 2)
    1e30:	12331064 	eorsne	r1, r3, #100	; 0x64
    1e34:	08010000 	stmdaeq	r1, {}	; <UNPREDICTABLE>
    1e38:	0001261c 	andeq	r2, r1, ip, lsl r6
    1e3c:	60910200 	addsvs	r0, r1, r0, lsl #4
    1e40:	00158710 	andseq	r8, r5, r0, lsl r7
    1e44:	31080100 	mrscc	r0, (UNDEF: 24)
    1e48:	00000066 	andeq	r0, r0, r6, rrx
    1e4c:	0d5c9102 	ldfeqp	f1, [ip, #-8]
    1e50:	0a010069 	beq	41ffc <__bss_end+0x37cc0>
    1e54:	00017f09 	andeq	r7, r1, r9, lsl #30
    1e58:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1e5c:	01006a0d 	tsteq	r0, sp, lsl #20
    1e60:	017f090b 	cmneq	pc, fp, lsl #18
    1e64:	91020000 	mrsls	r0, (UNDEF: 2)
    1e68:	88281370 	stmdahi	r8!, {r4, r5, r6, r8, r9, ip}
    1e6c:	00600000 	rsbeq	r0, r0, r0
    1e70:	630d0000 	movwvs	r0, #53248	; 0xd000
    1e74:	081f0100 	ldmdaeq	pc, {r8}	; <UNPREDICTABLE>
    1e78:	0000006d 	andeq	r0, r0, sp, rrx
    1e7c:	006f9102 	rsbeq	r9, pc, r2, lsl #2
    1e80:	0fd40000 	svceq	0x00d40000
    1e84:	00040000 	andeq	r0, r4, r0
    1e88:	00000810 	andeq	r0, r0, r0, lsl r8
    1e8c:	0e210104 	sufeqs	f0, f1, f4
    1e90:	19040000 	stmdbne	r4, {}	; <UNPREDICTABLE>
    1e94:	4b000014 	blmi	1eec <shift+0x1eec>
    1e98:	8c00000f 	stchi	0, cr0, [r0], {15}
    1e9c:	b4000093 	strlt	r0, [r0], #-147	; 0xffffff6d
    1ea0:	1f000004 	svcne	0x00000004
    1ea4:	0200000b 	andeq	r0, r0, #11
    1ea8:	0b600801 	bleq	1803eb4 <__bss_end+0x17f9b78>
    1eac:	25030000 	strcs	r0, [r3, #-0]
    1eb0:	02000000 	andeq	r0, r0, #0
    1eb4:	09ec0502 	stmibeq	ip!, {r1, r8, sl}^
    1eb8:	04040000 	streq	r0, [r4], #-0
    1ebc:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
    1ec0:	00380300 	eorseq	r0, r8, r0, lsl #6
    1ec4:	fe050000 	cdp2	0, 0, cr0, cr5, cr0, {0}
    1ec8:	02000013 	andeq	r0, r0, #19
    1ecc:	00550707 	subseq	r0, r5, r7, lsl #14
    1ed0:	44030000 	strmi	r0, [r3], #-0
    1ed4:	02000000 	andeq	r0, r0, #0
    1ed8:	0b570801 	bleq	15c3ee4 <__bss_end+0x15b9ba8>
    1edc:	80050000 	andhi	r0, r5, r0
    1ee0:	02000009 	andeq	r0, r0, #9
    1ee4:	006d0708 	rsbeq	r0, sp, r8, lsl #14
    1ee8:	5c030000 	stcpl	0, cr0, [r3], {-0}
    1eec:	02000000 	andeq	r0, r0, #0
    1ef0:	0c310702 	ldceq	7, cr0, [r1], #-8
    1ef4:	a8050000 	stmdage	r5, {}	; <UNPREDICTABLE>
    1ef8:	02000005 	andeq	r0, r0, #5
    1efc:	00850709 	addeq	r0, r5, r9, lsl #14
    1f00:	74030000 	strvc	r0, [r3], #-0
    1f04:	02000000 	andeq	r0, r0, #0
    1f08:	188d0704 	stmne	sp, {r2, r8, r9, sl}
    1f0c:	85030000 	strhi	r0, [r3, #-0]
    1f10:	06000000 	streq	r0, [r0], -r0
    1f14:	000009f7 	strdeq	r0, [r0], -r7
    1f18:	07060308 	streq	r0, [r6, -r8, lsl #6]
    1f1c:	000001d5 	ldrdeq	r0, [r0], -r5
    1f20:	00073007 	andeq	r3, r7, r7
    1f24:	120a0300 	andne	r0, sl, #0, 6
    1f28:	00000074 	andeq	r0, r0, r4, ror r0
    1f2c:	09890700 	stmibeq	r9, {r8, r9, sl}
    1f30:	0c030000 	stceq	0, cr0, [r3], {-0}
    1f34:	0001da0e 	andeq	sp, r1, lr, lsl #20
    1f38:	f7080400 			; <UNDEFINED> instruction: 0xf7080400
    1f3c:	03000009 	movweq	r0, #9
    1f40:	055d0910 	ldrbeq	r0, [sp, #-2320]	; 0xfffff6f0
    1f44:	01e60000 	mvneq	r0, r0
    1f48:	d1010000 	mrsle	r0, (UNDEF: 1)
    1f4c:	dc000000 	stcle	0, cr0, [r0], {-0}
    1f50:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
    1f54:	000001e6 	andeq	r0, r0, r6, ror #3
    1f58:	0001f10a 	andeq	pc, r1, sl, lsl #2
    1f5c:	f6080000 			; <UNDEFINED> instruction: 0xf6080000
    1f60:	03000009 	movweq	r0, #9
    1f64:	09cc1512 	stmibeq	ip, {r1, r4, r8, sl, ip}^
    1f68:	01f70000 	mvnseq	r0, r0
    1f6c:	f5010000 			; <UNDEFINED> instruction: 0xf5010000
    1f70:	00000000 	andeq	r0, r0, r0
    1f74:	09000001 	stmdbeq	r0, {r0}
    1f78:	000001e6 	andeq	r0, r0, r6, ror #3
    1f7c:	00003809 	andeq	r3, r0, r9, lsl #16
    1f80:	76080000 	strvc	r0, [r8], -r0
    1f84:	03000005 	movweq	r0, #5
    1f88:	07980e15 			; <UNDEFINED> instruction: 0x07980e15
    1f8c:	01da0000 	bicseq	r0, sl, r0
    1f90:	19010000 	stmdbne	r1, {}	; <UNPREDICTABLE>
    1f94:	1f000001 	svcne	0x00000001
    1f98:	09000001 	stmdbeq	r0, {r0}
    1f9c:	000001f9 	strdeq	r0, [r0], -r9
    1fa0:	0ad00b00 	beq	ff404ba8 <__bss_end+0xff3fa86c>
    1fa4:	18030000 	stmdane	r3, {}	; <UNPREDICTABLE>
    1fa8:	0006cb0e 	andeq	ip, r6, lr, lsl #22
    1fac:	01340100 	teqeq	r4, r0, lsl #2
    1fb0:	013a0000 	teqeq	sl, r0
    1fb4:	e6090000 	str	r0, [r9], -r0
    1fb8:	00000001 	andeq	r0, r0, r1
    1fbc:	0007920b 	andeq	r9, r7, fp, lsl #4
    1fc0:	0e1b0300 	cdpeq	3, 1, cr0, cr11, cr0, {0}
    1fc4:	000005bf 			; <UNDEFINED> instruction: 0x000005bf
    1fc8:	00014f01 	andeq	r4, r1, r1, lsl #30
    1fcc:	00015a00 	andeq	r5, r1, r0, lsl #20
    1fd0:	01e60900 	mvneq	r0, r0, lsl #18
    1fd4:	da0a0000 	ble	281fdc <__bss_end+0x277ca0>
    1fd8:	00000001 	andeq	r0, r0, r1
    1fdc:	000b3f0b 	andeq	r3, fp, fp, lsl #30
    1fe0:	0e1d0300 	cdpeq	3, 1, cr0, cr13, cr0, {0}
    1fe4:	00000bc9 	andeq	r0, r0, r9, asr #23
    1fe8:	00016f01 	andeq	r6, r1, r1, lsl #30
    1fec:	00018400 	andeq	r8, r1, r0, lsl #8
    1ff0:	01e60900 	mvneq	r0, r0, lsl #18
    1ff4:	5c0a0000 	stcpl	0, cr0, [sl], {-0}
    1ff8:	0a000000 	beq	2000 <shift+0x2000>
    1ffc:	0000005c 	andeq	r0, r0, ip, asr r0
    2000:	0001da0a 	andeq	sp, r1, sl, lsl #20
    2004:	e40b0000 	str	r0, [fp], #-0
    2008:	03000005 	movweq	r0, #5
    200c:	04ae0e1f 	strteq	r0, [lr], #3615	; 0xe1f
    2010:	99010000 	stmdbls	r1, {}	; <UNPREDICTABLE>
    2014:	ae000001 	cdpge	0, 0, cr0, cr0, cr1, {0}
    2018:	09000001 	stmdbeq	r0, {r0}
    201c:	000001e6 	andeq	r0, r0, r6, ror #3
    2020:	00005c0a 	andeq	r5, r0, sl, lsl #24
    2024:	005c0a00 	subseq	r0, ip, r0, lsl #20
    2028:	250a0000 	strcs	r0, [sl, #-0]
    202c:	00000000 	andeq	r0, r0, r0
    2030:	000c490c 	andeq	r4, ip, ip, lsl #18
    2034:	0e210300 	cdpeq	3, 2, cr0, cr1, cr0, {0}
    2038:	00000aab 	andeq	r0, r0, fp, lsr #21
    203c:	0001bf01 	andeq	fp, r1, r1, lsl #30
    2040:	01e60900 	mvneq	r0, r0, lsl #18
    2044:	5c0a0000 	stcpl	0, cr0, [sl], {-0}
    2048:	0a000000 	beq	2050 <shift+0x2050>
    204c:	0000005c 	andeq	r0, r0, ip, asr r0
    2050:	0001f10a 	andeq	pc, r1, sl, lsl #2
    2054:	03000000 	movweq	r0, #0
    2058:	00000091 	muleq	r0, r1, r0
    205c:	57020102 	strpl	r0, [r2, -r2, lsl #2]
    2060:	03000008 	movweq	r0, #8
    2064:	000001da 	ldrdeq	r0, [r0], -sl
    2068:	0091040d 	addseq	r0, r1, sp, lsl #8
    206c:	e6030000 	str	r0, [r3], -r0
    2070:	0d000001 	stceq	0, cr0, [r0, #-4]
    2074:	00002c04 	andeq	r2, r0, r4, lsl #24
    2078:	0d040e00 	stceq	14, cr0, [r4, #-0]
    207c:	0001d504 	andeq	sp, r1, r4, lsl #10
    2080:	01f90300 	mvnseq	r0, r0, lsl #6
    2084:	e50f0000 	str	r0, [pc, #-0]	; 208c <shift+0x208c>
    2088:	0800000c 	stmdaeq	r0, {r2, r3}
    208c:	2a080604 	bcs	2038a4 <__bss_end+0x1f9568>
    2090:	10000002 	andne	r0, r0, r2
    2094:	04003072 	streq	r3, [r0], #-114	; 0xffffff8e
    2098:	00740e08 	rsbseq	r0, r4, r8, lsl #28
    209c:	10000000 	andne	r0, r0, r0
    20a0:	04003172 	streq	r3, [r0], #-370	; 0xfffffe8e
    20a4:	00740e09 	rsbseq	r0, r4, r9, lsl #28
    20a8:	00040000 	andeq	r0, r4, r0
    20ac:	000a5511 	andeq	r5, sl, r1, lsl r5
    20b0:	38040500 	stmdacc	r4, {r8, sl}
    20b4:	04000000 	streq	r0, [r0], #-0
    20b8:	026d0c1e 	rsbeq	r0, sp, #7680	; 0x1e00
    20bc:	a0120000 	andsge	r0, r2, r0
    20c0:	00000005 	andeq	r0, r0, r5
    20c4:	00073d12 	andeq	r3, r7, r2, lsl sp
    20c8:	77120100 	ldrvc	r0, [r2, -r0, lsl #2]
    20cc:	0200000a 	andeq	r0, r0, #10
    20d0:	000b7a12 	andeq	r7, fp, r2, lsl sl
    20d4:	1b120300 	blne	482cdc <__bss_end+0x4789a0>
    20d8:	04000007 	streq	r0, [r0], #-7
    20dc:	0009e312 	andeq	lr, r9, r2, lsl r3
    20e0:	65120500 	ldrvs	r0, [r2, #-1280]	; 0xfffffb00
    20e4:	0600000b 	streq	r0, [r0], -fp
    20e8:	000bc412 	andeq	ip, fp, r2, lsl r4
    20ec:	11000700 	tstne	r0, r0, lsl #14
    20f0:	00000a3d 	andeq	r0, r0, sp, lsr sl
    20f4:	00380405 	eorseq	r0, r8, r5, lsl #8
    20f8:	49040000 	stmdbmi	r4, {}	; <UNPREDICTABLE>
    20fc:	0002aa0c 	andeq	sl, r2, ip, lsl #20
    2100:	06b91200 	ldrteq	r1, [r9], r0, lsl #4
    2104:	12000000 	andne	r0, r0, #0
    2108:	00000738 	andeq	r0, r0, r8, lsr r7
    210c:	0c7e1201 	lfmeq	f1, 2, [lr], #-4
    2110:	12020000 	andne	r0, r2, #0
    2114:	0000092e 	andeq	r0, r0, lr, lsr #18
    2118:	072a1203 	streq	r1, [sl, -r3, lsl #4]!
    211c:	12040000 	andne	r0, r4, #0
    2120:	000007b8 			; <UNDEFINED> instruction: 0x000007b8
    2124:	05ed1205 	strbeq	r1, [sp, #517]!	; 0x205
    2128:	00060000 	andeq	r0, r6, r0
    212c:	00090c13 	andeq	r0, r9, r3, lsl ip
    2130:	14050500 	strne	r0, [r5], #-1280	; 0xfffffb00
    2134:	00000080 	andeq	r0, r0, r0, lsl #1
    2138:	a0680305 	rsbge	r0, r8, r5, lsl #6
    213c:	e1130000 	tst	r3, r0
    2140:	0500000a 	streq	r0, [r0, #-10]
    2144:	00801406 	addeq	r1, r0, r6, lsl #8
    2148:	03050000 	movweq	r0, #20480	; 0x5000
    214c:	0000a06c 	andeq	sl, r0, ip, rrx
    2150:	0007cd13 	andeq	ip, r7, r3, lsl sp
    2154:	1a070600 	bne	1c395c <__bss_end+0x1b9620>
    2158:	00000080 	andeq	r0, r0, r0, lsl #1
    215c:	a0700305 	rsbsge	r0, r0, r5, lsl #6
    2160:	05130000 	ldreq	r0, [r3, #-0]
    2164:	0600000a 	streq	r0, [r0], -sl
    2168:	00801a09 	addeq	r1, r0, r9, lsl #20
    216c:	03050000 	movweq	r0, #20480	; 0x5000
    2170:	0000a074 	andeq	sl, r0, r4, ror r0
    2174:	0007bf13 	andeq	fp, r7, r3, lsl pc
    2178:	1a0b0600 	bne	2c3980 <__bss_end+0x2b9644>
    217c:	00000080 	andeq	r0, r0, r0, lsl #1
    2180:	a0780305 	rsbsge	r0, r8, r5, lsl #6
    2184:	b9130000 	ldmdblt	r3, {}	; <UNPREDICTABLE>
    2188:	06000009 	streq	r0, [r0], -r9
    218c:	00801a0d 	addeq	r1, r0, sp, lsl #20
    2190:	03050000 	movweq	r0, #20480	; 0x5000
    2194:	0000a07c 	andeq	sl, r0, ip, ror r0
    2198:	00058013 	andeq	r8, r5, r3, lsl r0
    219c:	1a0f0600 	bne	3c39a4 <__bss_end+0x3b9668>
    21a0:	00000080 	andeq	r0, r0, r0, lsl #1
    21a4:	a0800305 	addge	r0, r0, r5, lsl #6
    21a8:	a7140000 	ldrge	r0, [r4, -r0]
    21ac:	0d000003 	stceq	0, cr0, [r0, #-12]
    21b0:	00032804 	andeq	r2, r3, r4, lsl #16
    21b4:	05161300 	ldreq	r1, [r6, #-768]	; 0xfffffd00
    21b8:	04070000 	streq	r0, [r7], #-0
    21bc:	00008014 	andeq	r8, r0, r4, lsl r0
    21c0:	84030500 	strhi	r0, [r3], #-1280	; 0xfffffb00
    21c4:	130000a0 	movwne	r0, #160	; 0xa0
    21c8:	00000a7d 	andeq	r0, r0, sp, ror sl
    21cc:	80140707 	andshi	r0, r4, r7, lsl #14
    21d0:	05000000 	streq	r0, [r0, #-0]
    21d4:	00a08803 	adceq	r8, r0, r3, lsl #16
    21d8:	044d1300 	strbeq	r1, [sp], #-768	; 0xfffffd00
    21dc:	0a070000 	beq	1c21e4 <__bss_end+0x1b7ea8>
    21e0:	00008014 	andeq	r8, r0, r4, lsl r0
    21e4:	8c030500 	cfstr32hi	mvfx0, [r3], {-0}
    21e8:	110000a0 	smlatbne	r0, r0, r0, r0
    21ec:	000005f2 	strdeq	r0, [r0], -r2
    21f0:	00380405 	eorseq	r0, r8, r5, lsl #8
    21f4:	0d070000 	stceq	0, cr0, [r7, #-0]
    21f8:	0003a00c 	andeq	sl, r3, ip
    21fc:	654e1500 	strbvs	r1, [lr, #-1280]	; 0xfffffb00
    2200:	12000077 	andne	r0, r0, #119	; 0x77
    2204:	00000410 	andeq	r0, r0, r0, lsl r4
    2208:	04451201 	strbeq	r1, [r5], #-513	; 0xfffffdff
    220c:	12020000 	andne	r0, r2, #0
    2210:	00000641 	andeq	r0, r0, r1, asr #12
    2214:	0b6c1203 	bleq	1b06a28 <__bss_end+0x1afc6ec>
    2218:	12040000 	andne	r0, r4, #0
    221c:	00000404 	andeq	r0, r0, r4, lsl #8
    2220:	2f0f0005 	svccs	0x000f0005
    2224:	10000005 	andne	r0, r0, r5
    2228:	df081b07 	svcle	0x00081b07
    222c:	10000003 	andne	r0, r0, r3
    2230:	0700726c 	streq	r7, [r0, -ip, ror #4]
    2234:	03df131d 	bicseq	r1, pc, #1946157056	; 0x74000000
    2238:	10000000 	andne	r0, r0, r0
    223c:	07007073 	smlsdxeq	r0, r3, r0, r7
    2240:	03df131e 	bicseq	r1, pc, #2013265920	; 0x78000000
    2244:	10040000 	andne	r0, r4, r0
    2248:	07006370 	smlsdxeq	r0, r0, r3, r6
    224c:	03df131f 	bicseq	r1, pc, #2080374784	; 0x7c000000
    2250:	07080000 	streq	r0, [r8, -r0]
    2254:	00000a37 	andeq	r0, r0, r7, lsr sl
    2258:	df132007 	svcle	0x00132007
    225c:	0c000003 	stceq	0, cr0, [r0], {3}
    2260:	07040200 	streq	r0, [r4, -r0, lsl #4]
    2264:	00001888 	andeq	r1, r0, r8, lsl #17
    2268:	0003df03 	andeq	sp, r3, r3, lsl #30
    226c:	070e0f00 	streq	r0, [lr, -r0, lsl #30]
    2270:	077c0000 	ldrbeq	r0, [ip, -r0]!
    2274:	04a20828 	strteq	r0, [r2], #2088	; 0x828
    2278:	9e070000 	cdpls	0, 0, cr0, cr7, cr0, {0}
    227c:	07000006 	streq	r0, [r0, -r6]
    2280:	03a0122a 	moveq	r1, #-1610612734	; 0xa0000002
    2284:	10000000 	andne	r0, r0, r0
    2288:	00646970 	rsbeq	r6, r4, r0, ror r9
    228c:	85122b07 	ldrhi	r2, [r2, #-2823]	; 0xfffff4f9
    2290:	10000000 	andne	r0, r0, r0
    2294:	000b9f07 	andeq	r9, fp, r7, lsl #30
    2298:	112c0700 			; <UNDEFINED> instruction: 0x112c0700
    229c:	00000369 	andeq	r0, r0, r9, ror #6
    22a0:	0b490714 	bleq	1243ef8 <__bss_end+0x1239bbc>
    22a4:	2d070000 	stccs	0, cr0, [r7, #-0]
    22a8:	00008512 	andeq	r8, r0, r2, lsl r5
    22ac:	37071800 	strcc	r1, [r7, -r0, lsl #16]
    22b0:	07000003 	streq	r0, [r0, -r3]
    22b4:	0085122e 	addeq	r1, r5, lr, lsr #4
    22b8:	071c0000 	ldreq	r0, [ip, -r0]
    22bc:	00000a6a 	andeq	r0, r0, sl, ror #20
    22c0:	a20c2f07 	andge	r2, ip, #7, 30
    22c4:	20000004 	andcs	r0, r0, r4
    22c8:	0003c007 	andeq	ip, r3, r7
    22cc:	09300700 	ldmdbeq	r0!, {r8, r9, sl}
    22d0:	00000038 	andeq	r0, r0, r8, lsr r0
    22d4:	065c0760 	ldrbeq	r0, [ip], -r0, ror #14
    22d8:	31070000 	mrscc	r0, (UNDEF: 7)
    22dc:	0000740e 	andeq	r7, r0, lr, lsl #8
    22e0:	72076400 	andvc	r6, r7, #0, 8
    22e4:	07000009 	streq	r0, [r0, -r9]
    22e8:	00740e33 	rsbseq	r0, r4, r3, lsr lr
    22ec:	07680000 	strbeq	r0, [r8, -r0]!
    22f0:	00000969 	andeq	r0, r0, r9, ror #18
    22f4:	740e3407 	strvc	r3, [lr], #-1031	; 0xfffffbf9
    22f8:	6c000000 	stcvs	0, cr0, [r0], {-0}
    22fc:	0005b107 	andeq	fp, r5, r7, lsl #2
    2300:	0e350700 	cdpeq	7, 3, cr0, cr5, cr0, {0}
    2304:	00000074 	andeq	r0, r0, r4, ror r0
    2308:	0a280770 	beq	a040d0 <__bss_end+0x9f9d94>
    230c:	36070000 	strcc	r0, [r7], -r0
    2310:	0000740e 	andeq	r7, r0, lr, lsl #8
    2314:	54077400 	strpl	r7, [r7], #-1024	; 0xfffffc00
    2318:	0700000c 	streq	r0, [r0, -ip]
    231c:	00740e37 	rsbseq	r0, r4, r7, lsr lr
    2320:	00780000 	rsbseq	r0, r8, r0
    2324:	00032d16 	andeq	r2, r3, r6, lsl sp
    2328:	0004b200 	andeq	fp, r4, r0, lsl #4
    232c:	00851700 	addeq	r1, r5, r0, lsl #14
    2330:	000f0000 	andeq	r0, pc, r0
    2334:	00043613 	andeq	r3, r4, r3, lsl r6
    2338:	140a0800 	strne	r0, [sl], #-2048	; 0xfffff800
    233c:	00000080 	andeq	r0, r0, r0, lsl #1
    2340:	a0900305 	addsge	r0, r0, r5, lsl #6
    2344:	08110000 	ldmdaeq	r1, {}	; <UNPREDICTABLE>
    2348:	05000008 	streq	r0, [r0, #-8]
    234c:	00003804 	andeq	r3, r0, r4, lsl #16
    2350:	0c0d0800 	stceq	8, cr0, [sp], {-0}
    2354:	000004e3 	andeq	r0, r0, r3, ror #9
    2358:	000c8412 	andeq	r8, ip, r2, lsl r4
    235c:	b9120000 	ldmdblt	r2, {}	; <UNPREDICTABLE>
    2360:	0100000b 	tsteq	r0, fp
    2364:	068b0f00 	streq	r0, [fp], r0, lsl #30
    2368:	080c0000 	stmdaeq	ip, {}	; <UNPREDICTABLE>
    236c:	0518081b 	ldreq	r0, [r8, #-2075]	; 0xfffff7e5
    2370:	a9070000 	stmdbge	r7, {}	; <UNPREDICTABLE>
    2374:	08000004 	stmdaeq	r0, {r2}
    2378:	0518191d 	ldreq	r1, [r8, #-2333]	; 0xfffff6e3
    237c:	07000000 	streq	r0, [r0, -r0]
    2380:	0000040b 	andeq	r0, r0, fp, lsl #8
    2384:	18191e08 	ldmdane	r9, {r3, r9, sl, fp, ip}
    2388:	04000005 	streq	r0, [r0], #-5
    238c:	00082c07 	andeq	r2, r8, r7, lsl #24
    2390:	131f0800 	tstne	pc, #0, 16
    2394:	0000051e 	andeq	r0, r0, lr, lsl r5
    2398:	040d0008 	streq	r0, [sp], #-8
    239c:	000004e3 	andeq	r0, r0, r3, ror #9
    23a0:	03eb040d 	mvneq	r0, #218103808	; 0xd000000
    23a4:	17060000 	strne	r0, [r6, -r0]
    23a8:	1400000a 	strne	r0, [r0], #-10
    23ac:	e5072208 	str	r2, [r7, #-520]	; 0xfffffdf8
    23b0:	07000007 	streq	r0, [r0, -r7]
    23b4:	0000091a 	andeq	r0, r0, sl, lsl r9
    23b8:	74122608 	ldrvc	r2, [r2], #-1544	; 0xfffff9f8
    23bc:	00000000 	andeq	r0, r0, r0
    23c0:	0008bc07 	andeq	fp, r8, r7, lsl #24
    23c4:	1d290800 	stcne	8, cr0, [r9, #-0]
    23c8:	00000518 	andeq	r0, r0, r8, lsl r5
    23cc:	06490704 	strbeq	r0, [r9], -r4, lsl #14
    23d0:	2c080000 	stccs	0, cr0, [r8], {-0}
    23d4:	0005181d 	andeq	r1, r5, sp, lsl r8
    23d8:	24180800 	ldrcs	r0, [r8], #-2048	; 0xfffff800
    23dc:	08000009 	stmdaeq	r0, {r0, r3}
    23e0:	06680e2f 	strbteq	r0, [r8], -pc, lsr #28
    23e4:	056c0000 	strbeq	r0, [ip, #-0]!
    23e8:	05770000 	ldrbeq	r0, [r7, #-0]!
    23ec:	ea090000 	b	2423f4 <__bss_end+0x2380b8>
    23f0:	0a000007 	beq	2414 <shift+0x2414>
    23f4:	00000518 	andeq	r0, r0, r8, lsl r5
    23f8:	07591900 	ldrbeq	r1, [r9, -r0, lsl #18]
    23fc:	31080000 	mrscc	r0, (UNDEF: 8)
    2400:	0006e50e 	andeq	lr, r6, lr, lsl #10
    2404:	0001da00 	andeq	sp, r1, r0, lsl #20
    2408:	00058f00 	andeq	r8, r5, r0, lsl #30
    240c:	00059a00 	andeq	r9, r5, r0, lsl #20
    2410:	07ea0900 	strbeq	r0, [sl, r0, lsl #18]!
    2414:	1e0a0000 	cdpne	0, 0, cr0, cr10, cr0, {0}
    2418:	00000005 	andeq	r0, r0, r5
    241c:	000b8008 	andeq	r8, fp, r8
    2420:	1d350800 	ldcne	8, cr0, [r5, #-0]
    2424:	000007e3 	andeq	r0, r0, r3, ror #15
    2428:	00000518 	andeq	r0, r0, r8, lsl r5
    242c:	0005b302 	andeq	fp, r5, r2, lsl #6
    2430:	0005b900 	andeq	fp, r5, r0, lsl #18
    2434:	07ea0900 	strbeq	r0, [sl, r0, lsl #18]!
    2438:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    243c:	00000634 	andeq	r0, r0, r4, lsr r6
    2440:	341d3708 	ldrcc	r3, [sp], #-1800	; 0xfffff8f8
    2444:	18000009 	stmdane	r0, {r0, r3}
    2448:	02000005 	andeq	r0, r0, #5
    244c:	000005d2 	ldrdeq	r0, [r0], -r2
    2450:	000005d8 	ldrdeq	r0, [r0], -r8
    2454:	0007ea09 	andeq	lr, r7, r9, lsl #20
    2458:	cf1a0000 	svcgt	0x001a0000
    245c:	08000008 	stmdaeq	r0, {r3}
    2460:	08033139 	stmdaeq	r3, {r0, r3, r4, r5, r8, ip, sp}
    2464:	020c0000 	andeq	r0, ip, #0
    2468:	000a1708 	andeq	r1, sl, r8, lsl #14
    246c:	093c0800 	ldmdbeq	ip!, {fp}
    2470:	00000768 	andeq	r0, r0, r8, ror #14
    2474:	000007ea 	andeq	r0, r0, sl, ror #15
    2478:	0005ff01 	andeq	pc, r5, r1, lsl #30
    247c:	00060500 	andeq	r0, r6, r0, lsl #10
    2480:	07ea0900 	strbeq	r0, [sl, r0, lsl #18]!
    2484:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    2488:	00000c16 	andeq	r0, r0, r6, lsl ip
    248c:	19123d08 	ldmdbne	r2, {r3, r8, sl, fp, ip, sp}
    2490:	74000004 	strvc	r0, [r0], #-4
    2494:	01000000 	mrseq	r0, (UNDEF: 0)
    2498:	0000061e 	andeq	r0, r0, lr, lsl r6
    249c:	00000629 	andeq	r0, r0, r9, lsr #12
    24a0:	0007ea09 	andeq	lr, r7, r9, lsl #20
    24a4:	00740a00 	rsbseq	r0, r4, r0, lsl #20
    24a8:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    24ac:	000006aa 	andeq	r0, r0, sl, lsr #13
    24b0:	7e123f08 	cdpvc	15, 1, cr3, cr2, cr8, {0}
    24b4:	74000004 	strvc	r0, [r0], #-4
    24b8:	01000000 	mrseq	r0, (UNDEF: 0)
    24bc:	00000642 	andeq	r0, r0, r2, asr #12
    24c0:	00000657 	andeq	r0, r0, r7, asr r6
    24c4:	0007ea09 	andeq	lr, r7, r9, lsl #20
    24c8:	080c0a00 	stmdaeq	ip, {r9, fp}
    24cc:	850a0000 	strhi	r0, [sl, #-0]
    24d0:	0a000000 	beq	24d8 <shift+0x24d8>
    24d4:	000001da 	ldrdeq	r0, [r0], -sl
    24d8:	06be0b00 	ldrteq	r0, [lr], r0, lsl #22
    24dc:	41080000 	mrsmi	r0, (UNDEF: 8)
    24e0:	0008310e 	andeq	r3, r8, lr, lsl #2
    24e4:	066c0100 	strbteq	r0, [ip], -r0, lsl #2
    24e8:	06720000 	ldrbteq	r0, [r2], -r0
    24ec:	ea090000 	b	2424f4 <__bss_end+0x2381b8>
    24f0:	00000007 	andeq	r0, r0, r7
    24f4:	000bb00b 	andeq	fp, fp, fp
    24f8:	0e430800 	cdpeq	8, 4, cr0, cr3, cr0, {0}
    24fc:	0000053c 	andeq	r0, r0, ip, lsr r5
    2500:	00068701 	andeq	r8, r6, r1, lsl #14
    2504:	00068d00 	andeq	r8, r6, r0, lsl #26
    2508:	07ea0900 	strbeq	r0, [sl, r0, lsl #18]!
    250c:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    2510:	00000460 	andeq	r0, r0, r0, ror #8
    2514:	ce174608 	cfmsub32gt	mvax0, mvfx4, mvfx7, mvfx8
    2518:	1e000004 	cdpne	0, 0, cr0, cr0, cr4, {0}
    251c:	01000005 	tsteq	r0, r5
    2520:	000006a6 	andeq	r0, r0, r6, lsr #13
    2524:	000006ac 	andeq	r0, r0, ip, lsr #13
    2528:	00081209 	andeq	r1, r8, r9, lsl #4
    252c:	88080000 	stmdahi	r8, {}	; <UNPREDICTABLE>
    2530:	0800000a 	stmdaeq	r0, {r1, r3}
    2534:	034d1749 	movteq	r1, #55113	; 0xd749
    2538:	051e0000 	ldreq	r0, [lr, #-0]
    253c:	c5010000 	strgt	r0, [r1, #-0]
    2540:	d0000006 	andle	r0, r0, r6
    2544:	09000006 	stmdbeq	r0, {r1, r2}
    2548:	00000812 	andeq	r0, r0, r2, lsl r8
    254c:	0000740a 	andeq	r7, r0, sl, lsl #8
    2550:	8a0b0000 	bhi	2c2558 <__bss_end+0x2b821c>
    2554:	08000005 	stmdaeq	r0, {r0, r2}
    2558:	08dd0e4c 	ldmeq	sp, {r2, r3, r6, r9, sl, fp}^
    255c:	e5010000 	str	r0, [r1, #-0]
    2560:	eb000006 	bl	2580 <shift+0x2580>
    2564:	09000006 	stmdbeq	r0, {r1, r2}
    2568:	000007ea 	andeq	r0, r0, sl, ror #15
    256c:	07590800 	ldrbeq	r0, [r9, -r0, lsl #16]
    2570:	4e080000 	cdpmi	0, 0, cr0, cr8, cr0, {0}
    2574:	0009910e 	andeq	r9, r9, lr, lsl #2
    2578:	0001da00 	andeq	sp, r1, r0, lsl #20
    257c:	07040100 	streq	r0, [r4, -r0, lsl #2]
    2580:	070f0000 	streq	r0, [pc, -r0]
    2584:	ea090000 	b	24258c <__bss_end+0x238250>
    2588:	0a000007 	beq	25ac <shift+0x25ac>
    258c:	00000074 	andeq	r0, r0, r4, ror r0
    2590:	03f00800 	mvnseq	r0, #0, 16
    2594:	51080000 	mrspl	r0, (UNDEF: 8)
    2598:	00037a12 	andeq	r7, r3, r2, lsl sl
    259c:	00007400 	andeq	r7, r0, r0, lsl #8
    25a0:	07280100 	streq	r0, [r8, -r0, lsl #2]!
    25a4:	07330000 	ldreq	r0, [r3, -r0]!
    25a8:	ea090000 	b	2425b0 <__bss_end+0x238274>
    25ac:	0a000007 	beq	25d0 <shift+0x25d0>
    25b0:	0000032d 	andeq	r0, r0, sp, lsr #6
    25b4:	03ad0800 			; <UNDEFINED> instruction: 0x03ad0800
    25b8:	54080000 	strpl	r0, [r8], #-0
    25bc:	000bea0e 	andeq	lr, fp, lr, lsl #20
    25c0:	0001da00 	andeq	sp, r1, r0, lsl #20
    25c4:	074c0100 	strbeq	r0, [ip, -r0, lsl #2]
    25c8:	07570000 	ldrbeq	r0, [r7, -r0]
    25cc:	ea090000 	b	2425d4 <__bss_end+0x238298>
    25d0:	0a000007 	beq	25f4 <shift+0x25f4>
    25d4:	00000074 	andeq	r0, r0, r4, ror r0
    25d8:	03ca0b00 	biceq	r0, sl, #0, 22
    25dc:	57080000 	strpl	r0, [r8, -r0]
    25e0:	000aed0e 	andeq	lr, sl, lr, lsl #26
    25e4:	076c0100 	strbeq	r0, [ip, -r0, lsl #2]!
    25e8:	078b0000 	streq	r0, [fp, r0]
    25ec:	ea090000 	b	2425f4 <__bss_end+0x2382b8>
    25f0:	0a000007 	beq	2614 <shift+0x2614>
    25f4:	0000022a 	andeq	r0, r0, sl, lsr #4
    25f8:	0000740a 	andeq	r7, r0, sl, lsl #8
    25fc:	00740a00 	rsbseq	r0, r4, r0, lsl #20
    2600:	740a0000 	strvc	r0, [sl], #-0
    2604:	0a000000 	beq	260c <shift+0x260c>
    2608:	00000818 	andeq	r0, r0, r8, lsl r8
    260c:	0c1b0b00 			; <UNDEFINED> instruction: 0x0c1b0b00
    2610:	59080000 	stmdbpl	r8, {}	; <UNPREDICTABLE>
    2614:	000c990e 	andeq	r9, ip, lr, lsl #18
    2618:	07a00100 	streq	r0, [r0, r0, lsl #2]!
    261c:	07bf0000 	ldreq	r0, [pc, r0]!
    2620:	ea090000 	b	242628 <__bss_end+0x2382ec>
    2624:	0a000007 	beq	2648 <shift+0x2648>
    2628:	0000026d 	andeq	r0, r0, sp, ror #4
    262c:	0000740a 	andeq	r7, r0, sl, lsl #8
    2630:	00740a00 	rsbseq	r0, r4, r0, lsl #20
    2634:	740a0000 	strvc	r0, [sl], #-0
    2638:	0a000000 	beq	2640 <shift+0x2640>
    263c:	00000818 	andeq	r0, r0, r8, lsl r8
    2640:	03dd1b00 	bicseq	r1, sp, #0, 22
    2644:	5c080000 	stcpl	0, cr0, [r8], {-0}
    2648:	00085c0e 	andeq	r5, r8, lr, lsl #24
    264c:	0001da00 	andeq	sp, r1, r0, lsl #20
    2650:	07d40100 	ldrbeq	r0, [r4, r0, lsl #2]
    2654:	ea090000 	b	24265c <__bss_end+0x238320>
    2658:	0a000007 	beq	267c <shift+0x267c>
    265c:	000004c4 	andeq	r0, r0, r4, asr #9
    2660:	0001f70a 	andeq	pc, r1, sl, lsl #14
    2664:	03000000 	movweq	r0, #0
    2668:	00000524 	andeq	r0, r0, r4, lsr #10
    266c:	0524040d 	streq	r0, [r4, #-1037]!	; 0xfffffbf3
    2670:	181c0000 	ldmdane	ip, {}	; <UNPREDICTABLE>
    2674:	fd000005 	stc2	0, cr0, [r0, #-20]	; 0xffffffec
    2678:	03000007 	movweq	r0, #7
    267c:	09000008 	stmdbeq	r0, {r3}
    2680:	000007ea 	andeq	r0, r0, sl, ror #15
    2684:	05241d00 	streq	r1, [r4, #-3328]!	; 0xfffff300
    2688:	07f00000 	ldrbeq	r0, [r0, r0]!
    268c:	040d0000 	streq	r0, [sp], #-0
    2690:	00000055 	andeq	r0, r0, r5, asr r0
    2694:	07e5040d 	strbeq	r0, [r5, sp, lsl #8]!
    2698:	041e0000 	ldreq	r0, [lr], #-0
    269c:	00000204 	andeq	r0, r0, r4, lsl #4
    26a0:	0013c511 	andseq	ip, r3, r1, lsl r5
    26a4:	44010700 	strmi	r0, [r1], #-1792	; 0xfffff900
    26a8:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
    26ac:	084f0c06 	stmdaeq	pc, {r1, r2, sl, fp}^	; <UNPREDICTABLE>
    26b0:	4e150000 	cdpmi	0, 1, cr0, cr5, cr0, {0}
    26b4:	0000706f 	andeq	r7, r0, pc, rrx
    26b8:	000ad012 	andeq	sp, sl, r2, lsl r0
    26bc:	92120100 	andsls	r0, r2, #0, 2
    26c0:	02000007 	andeq	r0, r0, #7
    26c4:	00137e12 	andseq	r7, r3, r2, lsl lr
    26c8:	2b120300 	blcs	4832d0 <__bss_end+0x478f94>
    26cc:	04000013 	streq	r0, [r0], #-19	; 0xffffffed
    26d0:	13440f00 	movtne	r0, #20224	; 0x4f00
    26d4:	09050000 	stmdbeq	r5, {}	; <UNPREDICTABLE>
    26d8:	08800822 	stmeq	r0, {r1, r5, fp}
    26dc:	78100000 	ldmdavc	r0, {}	; <UNPREDICTABLE>
    26e0:	0e240900 	vmuleq.f16	s0, s8, s0	; <UNPREDICTABLE>
    26e4:	0000005c 	andeq	r0, r0, ip, asr r0
    26e8:	00791000 	rsbseq	r1, r9, r0
    26ec:	5c0e2509 	cfstr32pl	mvfx2, [lr], {9}
    26f0:	02000000 	andeq	r0, r0, #0
    26f4:	74657310 	strbtvc	r7, [r5], #-784	; 0xfffffcf0
    26f8:	0d260900 			; <UNDEFINED> instruction: 0x0d260900
    26fc:	00000044 	andeq	r0, r0, r4, asr #32
    2700:	b80f0004 	stmdalt	pc, {r2}	; <UNPREDICTABLE>
    2704:	01000012 	tsteq	r0, r2, lsl r0
    2708:	9b082a09 	blls	20cf34 <__bss_end+0x202bf8>
    270c:	10000008 	andne	r0, r0, r8
    2710:	00646d63 	rsbeq	r6, r4, r3, ror #26
    2714:	1e162c09 	cdpne	12, 1, cr2, cr6, cr9, {0}
    2718:	00000008 	andeq	r0, r0, r8
    271c:	12cf0f00 	sbcne	r0, pc, #0, 30
    2720:	09010000 	stmdbeq	r1, {}	; <UNPREDICTABLE>
    2724:	08b60830 	ldmeq	r6!, {r4, r5, fp}
    2728:	12070000 	andne	r0, r7, #0
    272c:	09000014 	stmdbeq	r0, {r2, r4}
    2730:	08801c32 	stmeq	r0, {r1, r4, r5, sl, fp, ip}
    2734:	00000000 	andeq	r0, r0, r0
    2738:	00139a0f 	andseq	r9, r3, pc, lsl #20
    273c:	36090200 	strcc	r0, [r9], -r0, lsl #4
    2740:	0008de08 	andeq	sp, r8, r8, lsl #28
    2744:	14120700 	ldrne	r0, [r2], #-1792	; 0xfffff900
    2748:	38090000 	stmdacc	r9, {}	; <UNPREDICTABLE>
    274c:	0008801c 	andeq	r8, r8, ip, lsl r0
    2750:	dc070000 	stcle	0, cr0, [r7], {-0}
    2754:	09000013 	stmdbeq	r0, {r0, r1, r4}
    2758:	00440d39 	subeq	r0, r4, r9, lsr sp
    275c:	00010000 	andeq	r0, r1, r0
    2760:	00130a0f 	andseq	r0, r3, pc, lsl #20
    2764:	3d090800 	stccc	8, cr0, [r9, #-0]
    2768:	00091308 	andeq	r1, r9, r8, lsl #6
    276c:	14120700 	ldrne	r0, [r2], #-1792	; 0xfffff900
    2770:	3f090000 	svccc	0x00090000
    2774:	0008801c 	andeq	r8, r8, ip, lsl r0
    2778:	0d070000 	stceq	0, cr0, [r7, #-0]
    277c:	0900000f 	stmdbeq	r0, {r0, r1, r2, r3}
    2780:	005c0e40 	subseq	r0, ip, r0, asr #28
    2784:	07010000 	streq	r0, [r1, -r0]
    2788:	000013d6 	ldrdeq	r1, [r0], -r6
    278c:	4f194209 	svcmi	0x00194209
    2790:	03000008 	movweq	r0, #8
    2794:	135d0f00 	cmpne	sp, #0, 30
    2798:	090b0000 	stmdbeq	fp, {}	; <UNPREDICTABLE>
    279c:	09760846 	ldmdbeq	r6!, {r1, r2, r6, fp}^
    27a0:	12070000 	andne	r0, r7, #0
    27a4:	09000014 	stmdbeq	r0, {r2, r4}
    27a8:	08801c48 	stmeq	r0, {r3, r6, sl, fp, ip}
    27ac:	10000000 	andne	r0, r0, r0
    27b0:	09003178 	stmdbeq	r0, {r3, r4, r5, r6, r8, ip, sp}
    27b4:	005c0e49 	subseq	r0, ip, r9, asr #28
    27b8:	10010000 	andne	r0, r1, r0
    27bc:	09003179 	stmdbeq	r0, {r0, r3, r4, r5, r6, r8, ip, sp}
    27c0:	005c1249 	subseq	r1, ip, r9, asr #4
    27c4:	10030000 	andne	r0, r3, r0
    27c8:	4a090077 	bmi	2429ac <__bss_end+0x238670>
    27cc:	00005c0e 	andeq	r5, r0, lr, lsl #24
    27d0:	68100500 	ldmdavs	r0, {r8, sl}
    27d4:	114a0900 	cmpne	sl, r0, lsl #18
    27d8:	0000005c 	andeq	r0, r0, ip, asr r0
    27dc:	13040707 	movwne	r0, #18183	; 0x4707
    27e0:	4b090000 	blmi	2427e8 <__bss_end+0x2384ac>
    27e4:	0000440d 	andeq	r4, r0, sp, lsl #8
    27e8:	d6070900 	strle	r0, [r7], -r0, lsl #18
    27ec:	09000013 	stmdbeq	r0, {r0, r1, r4}
    27f0:	00440d4d 	subeq	r0, r4, sp, asr #26
    27f4:	000a0000 	andeq	r0, sl, r0
    27f8:	6c61681f 	stclvs	8, cr6, [r1], #-124	; 0xffffff84
    27fc:	0b050a00 	bleq	145004 <__bss_end+0x13acc8>
    2800:	00000a40 	andeq	r0, r0, r0, asr #20
    2804:	0008a920 	andeq	sl, r8, r0, lsr #18
    2808:	19070a00 	stmdbne	r7, {r9, fp}
    280c:	0000008c 	andeq	r0, r0, ip, lsl #1
    2810:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}
    2814:	000a9b20 	andeq	r9, sl, r0, lsr #22
    2818:	1a0a0a00 	bne	285020 <__bss_end+0x27ace4>
    281c:	000003e6 	andeq	r0, r0, r6, ror #7
    2820:	20000000 	andcs	r0, r0, r0
    2824:	00047420 	andeq	r7, r4, r0, lsr #8
    2828:	1a0d0a00 	bne	345030 <__bss_end+0x33acf4>
    282c:	000003e6 	andeq	r0, r0, r6, ror #7
    2830:	20200000 	eorcs	r0, r0, r0
    2834:	00081d21 	andeq	r1, r8, r1, lsr #26
    2838:	15100a00 	ldrne	r0, [r0, #-2560]	; 0xfffff600
    283c:	00000080 	andeq	r0, r0, r0, lsl #1
    2840:	0b8c2036 	bleq	fe30a920 <__bss_end+0xfe3005e4>
    2844:	420a0000 	andmi	r0, sl, #0
    2848:	0003e61a 	andeq	lr, r3, sl, lsl r6
    284c:	21500000 	cmpcs	r0, r0
    2850:	0c5f2020 	mrrceq	0, 2, r2, pc, cr0	; <UNPREDICTABLE>
    2854:	710a0000 	mrsvc	r0, (UNDEF: 10)
    2858:	0003e61a 	andeq	lr, r3, sl, lsl r6
    285c:	00b20000 	adcseq	r0, r2, r0
    2860:	074e2020 	strbeq	r2, [lr, -r0, lsr #32]
    2864:	a40a0000 	strge	r0, [sl], #-0
    2868:	0003e61a 	andeq	lr, r3, sl, lsl r6
    286c:	00b40000 	adcseq	r0, r4, r0
    2870:	07472020 	strbeq	r2, [r7, -r0, lsr #32]
    2874:	b20a0000 	andlt	r0, sl, #0
    2878:	0003e61d 	andeq	lr, r3, sp, lsl r6
    287c:	00300000 	eorseq	r0, r0, r0
    2880:	089f2020 	ldmeq	pc, {r5, sp}	; <UNPREDICTABLE>
    2884:	c00a0000 	andgt	r0, sl, r0
    2888:	0003e61d 	andeq	lr, r3, sp, lsl r6
    288c:	10400000 	subne	r0, r0, r0
    2890:	095a2020 	ldmdbeq	sl, {r5, sp}^
    2894:	cb0a0000 	blgt	28289c <__bss_end+0x278560>
    2898:	0003e61a 	andeq	lr, r3, sl, lsl r6
    289c:	20500000 	subscs	r0, r0, r0
    28a0:	05da2020 	ldrbeq	r2, [sl, #32]
    28a4:	cc0a0000 	stcgt	0, cr0, [sl], {-0}
    28a8:	0003e61a 	andeq	lr, r3, sl, lsl r6
    28ac:	80400000 	subhi	r0, r0, r0
    28b0:	0b952020 	bleq	fe54a938 <__bss_end+0xfe5405fc>
    28b4:	cd0a0000 	stcgt	0, cr0, [sl, #-0]
    28b8:	0003e61a 	andeq	lr, r3, sl, lsl r6
    28bc:	80500000 	subshi	r0, r0, r0
    28c0:	82220020 	eorhi	r0, r2, #32
    28c4:	22000009 	andcs	r0, r0, #9
    28c8:	00000992 	muleq	r0, r2, r9
    28cc:	0009a222 	andeq	sl, r9, r2, lsr #4
    28d0:	09b22200 	ldmibeq	r2!, {r9, sp}
    28d4:	bf220000 	svclt	0x00220000
    28d8:	22000009 	andcs	r0, r0, #9
    28dc:	000009cf 	andeq	r0, r0, pc, asr #19
    28e0:	0009df22 	andeq	sp, r9, r2, lsr #30
    28e4:	09ef2200 	stmibeq	pc!, {r9, sp}^	; <UNPREDICTABLE>
    28e8:	ff220000 			; <UNDEFINED> instruction: 0xff220000
    28ec:	22000009 	andcs	r0, r0, #9
    28f0:	00000a0f 	andeq	r0, r0, pc, lsl #20
    28f4:	000a1f22 	andeq	r1, sl, r2, lsr #30
    28f8:	0a2f2200 	beq	bcb100 <__bss_end+0xbc0dc4>
    28fc:	bb230000 	bllt	8c2904 <__bss_end+0x8b85c8>
    2900:	0b000013 	bleq	2954 <shift+0x2954>
    2904:	0d180b04 	vldreq	d0, [r8, #-16]
    2908:	b0210000 	eorlt	r0, r1, r0
    290c:	0b000013 	bleq	2960 <shift+0x2960>
    2910:	00681807 	rsbeq	r1, r8, r7, lsl #16
    2914:	21060000 	mrscs	r0, (UNDEF: 6)
    2918:	00001406 	andeq	r1, r0, r6, lsl #8
    291c:	6818090b 	ldmdavs	r8, {r0, r1, r3, r8, fp}
    2920:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    2924:	00144821 	andseq	r4, r4, r1, lsr #16
    2928:	180c0b00 	stmdane	ip, {r8, r9, fp}
    292c:	00000068 	andeq	r0, r0, r8, rrx
    2930:	13752120 	cmnne	r5, #32, 2
    2934:	0e0b0000 	cdpeq	0, 0, cr0, cr11, cr0, {0}
    2938:	00006818 	andeq	r6, r0, r8, lsl r8
    293c:	8f218000 	svchi	0x00218000
    2940:	0b000013 	bleq	2994 <shift+0x2994>
    2944:	01e11411 	mvneq	r1, r1, lsl r4
    2948:	24010000 	strcs	r0, [r1], #-0
    294c:	000012f2 	strdeq	r1, [r0], -r2
    2950:	4213140b 	andsmi	r1, r3, #184549376	; 0xb000000
    2954:	4000000d 	andmi	r0, r0, sp
    2958:	00000002 	andeq	r0, r0, r2
    295c:	00000000 	andeq	r0, r0, r0
    2960:	002f0000 	eoreq	r0, pc, r0
    2964:	07000000 	streq	r0, [r0, -r0]
    2968:	00000700 	andeq	r0, r0, r0, lsl #14
    296c:	7f147f14 	svcvc	0x00147f14
    2970:	2a240014 	bcs	9029c8 <__bss_end+0x8f868c>
    2974:	00122a7f 	andseq	r2, r2, pc, ror sl
    2978:	64081323 	strvs	r1, [r8], #-803	; 0xfffffcdd
    297c:	49360062 	ldmdbmi	r6!, {r1, r5, r6}
    2980:	00502255 	subseq	r2, r0, r5, asr r2
    2984:	00030500 	andeq	r0, r3, r0, lsl #10
    2988:	1c000000 	stcne	0, cr0, [r0], {-0}
    298c:	00004122 	andeq	r4, r0, r2, lsr #2
    2990:	1c224100 	stfnes	f4, [r2], #-0
    2994:	08140000 	ldmdaeq	r4, {}	; <UNPREDICTABLE>
    2998:	0014083e 	andseq	r0, r4, lr, lsr r8
    299c:	083e0808 	ldmdaeq	lr!, {r3, fp}
    29a0:	00000008 	andeq	r0, r0, r8
    29a4:	000060a0 	andeq	r6, r0, r0, lsr #1
    29a8:	08080808 	stmdaeq	r8, {r3, fp}
    29ac:	60000008 	andvs	r0, r0, r8
    29b0:	00000060 	andeq	r0, r0, r0, rrx
    29b4:	04081020 	streq	r1, [r8], #-32	; 0xffffffe0
    29b8:	513e0002 	teqpl	lr, r2
    29bc:	003e4549 	eorseq	r4, lr, r9, asr #10
    29c0:	407f4200 	rsbsmi	r4, pc, r0, lsl #4
    29c4:	61420000 	mrsvs	r0, (UNDEF: 66)
    29c8:	00464951 	subeq	r4, r6, r1, asr r9
    29cc:	4b454121 	blmi	1152e58 <__bss_end+0x1148b1c>
    29d0:	14180031 	ldrne	r0, [r8], #-49	; 0xffffffcf
    29d4:	00107f12 	andseq	r7, r0, r2, lsl pc
    29d8:	45454527 	strbmi	r4, [r5, #-1319]	; 0xfffffad9
    29dc:	4a3c0039 	bmi	f02ac8 <__bss_end+0xef878c>
    29e0:	00304949 	eorseq	r4, r0, r9, asr #18
    29e4:	05097101 	streq	r7, [r9, #-257]	; 0xfffffeff
    29e8:	49360003 	ldmdbmi	r6!, {r0, r1}
    29ec:	00364949 	eorseq	r4, r6, r9, asr #18
    29f0:	29494906 	stmdbcs	r9, {r1, r2, r8, fp, lr}^
    29f4:	3600001e 			; <UNDEFINED> instruction: 0x3600001e
    29f8:	00000036 	andeq	r0, r0, r6, lsr r0
    29fc:	00365600 	eorseq	r5, r6, r0, lsl #12
    2a00:	14080000 	strne	r0, [r8], #-0
    2a04:	00004122 	andeq	r4, r0, r2, lsr #2
    2a08:	14141414 	ldrne	r1, [r4], #-1044	; 0xfffffbec
    2a0c:	41000014 	tstmi	r0, r4, lsl r0
    2a10:	00081422 	andeq	r1, r8, r2, lsr #8
    2a14:	09510102 	ldmdbeq	r1, {r1, r8}^
    2a18:	49320006 	ldmdbmi	r2!, {r1, r2}
    2a1c:	003e5159 	eorseq	r5, lr, r9, asr r1
    2a20:	1211127c 	andsne	r1, r1, #124, 4	; 0xc0000007
    2a24:	497f007c 	ldmdbmi	pc!, {r2, r3, r4, r5, r6}^	; <UNPREDICTABLE>
    2a28:	00364949 	eorseq	r4, r6, r9, asr #18
    2a2c:	4141413e 	cmpmi	r1, lr, lsr r1
    2a30:	417f0022 	cmnmi	pc, r2, lsr #32
    2a34:	001c2241 	andseq	r2, ip, r1, asr #4
    2a38:	4949497f 	stmdbmi	r9, {r0, r1, r2, r3, r4, r5, r6, r8, fp, lr}^
    2a3c:	097f0041 	ldmdbeq	pc!, {r0, r6}^	; <UNPREDICTABLE>
    2a40:	00010909 	andeq	r0, r1, r9, lsl #18
    2a44:	4949413e 	stmdbmi	r9, {r1, r2, r3, r4, r5, r8, lr}^
    2a48:	087f007a 	ldmdaeq	pc!, {r1, r3, r4, r5, r6}^	; <UNPREDICTABLE>
    2a4c:	007f0808 	rsbseq	r0, pc, r8, lsl #16
    2a50:	417f4100 	cmnmi	pc, r0, lsl #2
    2a54:	40200000 	eormi	r0, r0, r0
    2a58:	00013f41 	andeq	r3, r1, r1, asr #30
    2a5c:	2214087f 	andscs	r0, r4, #8323072	; 0x7f0000
    2a60:	407f0041 	rsbsmi	r0, pc, r1, asr #32
    2a64:	00404040 	subeq	r4, r0, r0, asr #32
    2a68:	020c027f 	andeq	r0, ip, #-268435449	; 0xf0000007
    2a6c:	047f007f 	ldrbteq	r0, [pc], #-127	; 2a74 <shift+0x2a74>
    2a70:	007f1008 	rsbseq	r1, pc, r8
    2a74:	4141413e 	cmpmi	r1, lr, lsr r1
    2a78:	097f003e 	ldmdbeq	pc!, {r1, r2, r3, r4, r5}^	; <UNPREDICTABLE>
    2a7c:	00060909 	andeq	r0, r6, r9, lsl #18
    2a80:	2151413e 	cmpcs	r1, lr, lsr r1
    2a84:	097f005e 	ldmdbeq	pc!, {r1, r2, r3, r4, r6}^	; <UNPREDICTABLE>
    2a88:	00462919 	subeq	r2, r6, r9, lsl r9
    2a8c:	49494946 	stmdbmi	r9, {r1, r2, r6, r8, fp, lr}^
    2a90:	01010031 	tsteq	r1, r1, lsr r0
    2a94:	0001017f 	andeq	r0, r1, pc, ror r1
    2a98:	4040403f 	submi	r4, r0, pc, lsr r0
    2a9c:	201f003f 	andscs	r0, pc, pc, lsr r0	; <UNPREDICTABLE>
    2aa0:	001f2040 	andseq	r2, pc, r0, asr #32
    2aa4:	4038403f 	eorsmi	r4, r8, pc, lsr r0
    2aa8:	1463003f 	strbtne	r0, [r3], #-63	; 0xffffffc1
    2aac:	00631408 	rsbeq	r1, r3, r8, lsl #8
    2ab0:	08700807 	ldmdaeq	r0!, {r0, r1, r2, fp}^
    2ab4:	51610007 	cmnpl	r1, r7
    2ab8:	00434549 	subeq	r4, r3, r9, asr #10
    2abc:	41417f00 	cmpmi	r1, r0, lsl #30
    2ac0:	2a550000 	bcs	1542ac8 <__bss_end+0x153878c>
    2ac4:	00552a55 	subseq	r2, r5, r5, asr sl
    2ac8:	7f414100 	svcvc	0x00414100
    2acc:	02040000 	andeq	r0, r4, #0
    2ad0:	00040201 	andeq	r0, r4, r1, lsl #4
    2ad4:	40404040 	submi	r4, r0, r0, asr #32
    2ad8:	01000040 	tsteq	r0, r0, asr #32
    2adc:	00000402 	andeq	r0, r0, r2, lsl #8
    2ae0:	54545420 	ldrbpl	r5, [r4], #-1056	; 0xfffffbe0
    2ae4:	487f0078 	ldmdami	pc!, {r3, r4, r5, r6}^	; <UNPREDICTABLE>
    2ae8:	00384444 	eorseq	r4, r8, r4, asr #8
    2aec:	44444438 	strbmi	r4, [r4], #-1080	; 0xfffffbc8
    2af0:	44380020 	ldrtmi	r0, [r8], #-32	; 0xffffffe0
    2af4:	007f4844 	rsbseq	r4, pc, r4, asr #16
    2af8:	54545438 	ldrbpl	r5, [r4], #-1080	; 0xfffffbc8
    2afc:	7e080018 	mcrvc	0, 0, r0, cr8, cr8, {0}
    2b00:	00020109 	andeq	r0, r2, r9, lsl #2
    2b04:	a4a4a418 	strtge	sl, [r4], #1048	; 0x418
    2b08:	087f007c 	ldmdaeq	pc!, {r2, r3, r4, r5, r6}^	; <UNPREDICTABLE>
    2b0c:	00780404 	rsbseq	r0, r8, r4, lsl #8
    2b10:	407d4400 	rsbsmi	r4, sp, r0, lsl #8
    2b14:	80400000 	subhi	r0, r0, r0
    2b18:	00007d84 	andeq	r7, r0, r4, lsl #27
    2b1c:	4428107f 	strtmi	r1, [r8], #-127	; 0xffffff81
    2b20:	41000000 	mrsmi	r0, (UNDEF: 0)
    2b24:	0000407f 	andeq	r4, r0, pc, ror r0
    2b28:	0418047c 	ldreq	r0, [r8], #-1148	; 0xfffffb84
    2b2c:	087c0078 	ldmdaeq	ip!, {r3, r4, r5, r6}^
    2b30:	00780404 	rsbseq	r0, r8, r4, lsl #8
    2b34:	44444438 	strbmi	r4, [r4], #-1080	; 0xfffffbc8
    2b38:	24fc0038 	ldrbtcs	r0, [ip], #56	; 0x38
    2b3c:	00182424 	andseq	r2, r8, r4, lsr #8
    2b40:	18242418 	stmdane	r4!, {r3, r4, sl, sp}
    2b44:	087c00fc 	ldmdaeq	ip!, {r2, r3, r4, r5, r6, r7}^
    2b48:	00080404 	andeq	r0, r8, r4, lsl #8
    2b4c:	54545448 	ldrbpl	r5, [r4], #-1096	; 0xfffffbb8
    2b50:	3f040020 	svccc	0x00040020
    2b54:	00204044 	eoreq	r4, r0, r4, asr #32
    2b58:	2040403c 	subcs	r4, r0, ip, lsr r0
    2b5c:	201c007c 	andscs	r0, ip, ip, ror r0
    2b60:	001c2040 	andseq	r2, ip, r0, asr #32
    2b64:	4030403c 	eorsmi	r4, r0, ip, lsr r0
    2b68:	2844003c 	stmdacs	r4, {r2, r3, r4, r5}^
    2b6c:	00442810 	subeq	r2, r4, r0, lsl r8
    2b70:	a0a0a01c 	adcge	sl, r0, ip, lsl r0
    2b74:	6444007c 	strbvs	r0, [r4], #-124	; 0xffffff84
    2b78:	00444c54 	subeq	r4, r4, r4, asr ip
    2b7c:	00770800 	rsbseq	r0, r7, r0, lsl #16
    2b80:	00000000 	andeq	r0, r0, r0
    2b84:	0000007f 	andeq	r0, r0, pc, ror r0
    2b88:	00087700 	andeq	r7, r8, r0, lsl #14
    2b8c:	08100000 	ldmdaeq	r0, {}	; <UNPREDICTABLE>
    2b90:	00000810 	andeq	r0, r0, r0, lsl r8
    2b94:	00000000 	andeq	r0, r0, r0
    2b98:	88220000 	stmdahi	r2!, {}	; <UNPREDICTABLE>
    2b9c:	2200000a 	andcs	r0, r0, #10
    2ba0:	00000a95 	muleq	r0, r5, sl
    2ba4:	000aa222 	andeq	sl, sl, r2, lsr #4
    2ba8:	0aaf2200 	beq	febcb3b0 <__bss_end+0xfebc1074>
    2bac:	bc220000 	stclt	0, cr0, [r2], #-0
    2bb0:	1600000a 	strne	r0, [r0], -sl
    2bb4:	00000050 	andeq	r0, r0, r0, asr r0
    2bb8:	00000d42 	andeq	r0, r0, r2, asr #26
    2bbc:	00008525 	andeq	r8, r0, r5, lsr #10
    2bc0:	00023f00 	andeq	r3, r2, r0, lsl #30
    2bc4:	000d3103 	andeq	r3, sp, r3, lsl #2
    2bc8:	0ac92200 	beq	ff24b3d0 <__bss_end+0xff241094>
    2bcc:	ae260000 	cdpge	0, 2, cr0, cr6, cr0, {0}
    2bd0:	01000001 	tsteq	r0, r1
    2bd4:	0d66065d 	stcleq	6, cr0, [r6, #-372]!	; 0xfffffe8c
    2bd8:	97900000 	ldrls	r0, [r0, r0]
    2bdc:	00b00000 	adcseq	r0, r0, r0
    2be0:	9c010000 	stcls	0, cr0, [r1], {-0}
    2be4:	00000db9 			; <UNDEFINED> instruction: 0x00000db9
    2be8:	0012ed27 	andseq	lr, r2, r7, lsr #26
    2bec:	0001ec00 	andeq	lr, r1, r0, lsl #24
    2bf0:	6c910200 	lfmvs	f0, 4, [r1], {0}
    2bf4:	01007828 	tsteq	r0, r8, lsr #16
    2bf8:	005c295d 	subseq	r2, ip, sp, asr r9
    2bfc:	91020000 	mrsls	r0, (UNDEF: 2)
    2c00:	0079286a 	rsbseq	r2, r9, sl, ror #16
    2c04:	5c355d01 	ldcpl	13, cr5, [r5], #-4
    2c08:	02000000 	andeq	r0, r0, #0
    2c0c:	73286891 			; <UNDEFINED> instruction: 0x73286891
    2c10:	01007274 	tsteq	r0, r4, ror r2
    2c14:	01f1445d 	mvnseq	r4, sp, asr r4
    2c18:	91020000 	mrsls	r0, (UNDEF: 2)
    2c1c:	69782964 	ldmdbvs	r8!, {r2, r5, r6, r8, fp, sp}^
    2c20:	0e620100 	poweqs	f0, f2, f0
    2c24:	0000005c 	andeq	r0, r0, ip, asr r0
    2c28:	29769102 	ldmdbcs	r6!, {r1, r8, ip, pc}^
    2c2c:	00727470 	rsbseq	r7, r2, r0, ror r4
    2c30:	f1116301 			; <UNDEFINED> instruction: 0xf1116301
    2c34:	02000001 	andeq	r0, r0, #1
    2c38:	26007091 			; <UNDEFINED> instruction: 0x26007091
    2c3c:	0000011f 	andeq	r0, r0, pc, lsl r1
    2c40:	d3065201 	movwle	r5, #25089	; 0x6201
    2c44:	3800000d 	stmdacc	r0, {r0, r2, r3}
    2c48:	58000097 	stmdapl	r0, {r0, r1, r2, r4, r7}
    2c4c:	01000000 	mrseq	r0, (UNDEF: 0)
    2c50:	000def9c 	muleq	sp, ip, pc	; <UNPREDICTABLE>
    2c54:	12ed2700 	rscne	r2, sp, #0, 14
    2c58:	01ec0000 	mvneq	r0, r0
    2c5c:	91020000 	mrsls	r0, (UNDEF: 2)
    2c60:	6b70296c 	blvs	1c0d218 <__bss_end+0x1c02edc>
    2c64:	57010074 	smlsdxpl	r1, r4, r0, r0
    2c68:	00089b23 	andeq	r9, r8, r3, lsr #22
    2c6c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    2c70:	01842600 	orreq	r2, r4, r0, lsl #12
    2c74:	3a010000 	bcc	42c7c <__bss_end+0x38940>
    2c78:	000e0906 	andeq	r0, lr, r6, lsl #18
    2c7c:	0095d000 	addseq	sp, r5, r0
    2c80:	00016800 	andeq	r6, r1, r0, lsl #16
    2c84:	5b9c0100 	blpl	fe70308c <__bss_end+0xfe6f8d50>
    2c88:	2700000e 	strcs	r0, [r0, -lr]
    2c8c:	000012ed 	andeq	r1, r0, sp, ror #5
    2c90:	000001ec 	andeq	r0, r0, ip, ror #3
    2c94:	285c9102 	ldmdacs	ip, {r1, r8, ip, pc}^
    2c98:	3a010078 	bcc	42e80 <__bss_end+0x38b44>
    2c9c:	00005c27 	andeq	r5, r0, r7, lsr #24
    2ca0:	5a910200 	bpl	fe4434a8 <__bss_end+0xfe43916c>
    2ca4:	01007928 	tsteq	r0, r8, lsr #18
    2ca8:	005c333a 	subseq	r3, ip, sl, lsr r3
    2cac:	91020000 	mrsls	r0, (UNDEF: 2)
    2cb0:	00632858 	rsbeq	r2, r3, r8, asr r8
    2cb4:	253b3a01 	ldrcs	r3, [fp, #-2561]!	; 0xfffff5ff
    2cb8:	02000000 	andeq	r0, r0, #0
    2cbc:	62295791 	eorvs	r5, r9, #38010880	; 0x2440000
    2cc0:	01006675 	tsteq	r0, r5, ror r6
    2cc4:	0e5b0a43 	vnmlaeq.f32	s1, s22, s6
    2cc8:	91020000 	mrsls	r0, (UNDEF: 2)
    2ccc:	74702960 	ldrbtvc	r2, [r0], #-2400	; 0xfffff6a0
    2cd0:	45010072 	strmi	r0, [r1, #-114]	; 0xffffff8e
    2cd4:	000e6b1e 	andeq	r6, lr, lr, lsl fp
    2cd8:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    2cdc:	00251600 	eoreq	r1, r5, r0, lsl #12
    2ce0:	0e6b0000 	cdpeq	0, 6, cr0, cr11, cr0, {0}
    2ce4:	85170000 	ldrhi	r0, [r7, #-0]
    2ce8:	10000000 	andne	r0, r0, r0
    2cec:	13040d00 	movwne	r0, #19712	; 0x4d00
    2cf0:	26000009 	strcs	r0, [r0], -r9
    2cf4:	0000015a 	andeq	r0, r0, sl, asr r1
    2cf8:	8b062b01 	blhi	18d904 <__bss_end+0x1835c8>
    2cfc:	e400000e 	str	r0, [r0], #-14
    2d00:	ec000094 	stc	0, cr0, [r0], {148}	; 0x94
    2d04:	01000000 	mrseq	r0, (UNDEF: 0)
    2d08:	000ed09c 	muleq	lr, ip, r0
    2d0c:	12ed2700 	rscne	r2, sp, #0, 14
    2d10:	01ec0000 	mvneq	r0, r0
    2d14:	91020000 	mrsls	r0, (UNDEF: 2)
    2d18:	0078286c 	rsbseq	r2, r8, ip, ror #16
    2d1c:	5c282b01 			; <UNDEFINED> instruction: 0x5c282b01
    2d20:	02000000 	andeq	r0, r0, #0
    2d24:	79286a91 	stmdbvc	r8!, {r0, r4, r7, r9, fp, sp, lr}
    2d28:	342b0100 	strtcc	r0, [fp], #-256	; 0xffffff00
    2d2c:	0000005c 	andeq	r0, r0, ip, asr r0
    2d30:	28689102 	stmdacs	r8!, {r1, r8, ip, pc}^
    2d34:	00746573 	rsbseq	r6, r4, r3, ror r5
    2d38:	da3c2b01 	ble	f0d944 <__bss_end+0xf03608>
    2d3c:	02000001 	andeq	r0, r0, #1
    2d40:	70296791 	mlavc	r9, r1, r7, r6
    2d44:	0100746b 	tsteq	r0, fp, ror #8
    2d48:	08de2631 	ldmeq	lr, {r0, r4, r5, r9, sl, sp}^
    2d4c:	91020000 	mrsls	r0, (UNDEF: 2)
    2d50:	3a260070 	bcc	982f18 <__bss_end+0x978bdc>
    2d54:	01000001 	tsteq	r0, r1
    2d58:	0eea0620 	cdpeq	6, 14, cr0, cr10, cr0, {1}
    2d5c:	94680000 	strbtls	r0, [r8], #-0
    2d60:	007c0000 	rsbseq	r0, ip, r0
    2d64:	9c010000 	stcls	0, cr0, [r1], {-0}
    2d68:	00000f15 	andeq	r0, r0, r5, lsl pc
    2d6c:	0012ed27 	andseq	lr, r2, r7, lsr #26
    2d70:	0001ec00 	andeq	lr, r1, r0, lsl #24
    2d74:	6c910200 	lfmvs	f0, 4, [r1], {0}
    2d78:	0013dc2a 	andseq	sp, r3, sl, lsr #24
    2d7c:	20200100 	eorcs	r0, r0, r0, lsl #2
    2d80:	000001da 	ldrdeq	r0, [r0], -sl
    2d84:	296b9102 	stmdbcs	fp!, {r1, r8, ip, pc}^
    2d88:	00746b70 	rsbseq	r6, r4, r0, ror fp
    2d8c:	b61b2501 	ldrlt	r2, [fp], -r1, lsl #10
    2d90:	02000008 	andeq	r0, r0, #8
    2d94:	2b007491 	blcs	1ffe0 <__bss_end+0x15ca4>
    2d98:	00000100 	andeq	r0, r0, r0, lsl #2
    2d9c:	2f061b01 	svccs	0x00061b01
    2da0:	4000000f 	andmi	r0, r0, pc
    2da4:	28000094 	stmdacs	r0, {r2, r4, r7}
    2da8:	01000000 	mrseq	r0, (UNDEF: 0)
    2dac:	000f3c9c 	muleq	pc, ip, ip	; <UNPREDICTABLE>
    2db0:	12ed2700 	rscne	r2, sp, #0, 14
    2db4:	01ff0000 	mvnseq	r0, r0
    2db8:	91020000 	mrsls	r0, (UNDEF: 2)
    2dbc:	dc2c0074 	stcle	0, cr0, [ip], #-464	; 0xfffffe30
    2dc0:	01000000 	mrseq	r0, (UNDEF: 0)
    2dc4:	01f70111 	mvnseq	r0, r1, lsl r1
    2dc8:	0f510000 	svceq	0x00510000
    2dcc:	64000000 	strvs	r0, [r0], #-0
    2dd0:	2d00000f 	stccs	0, cr0, [r0, #-60]	; 0xffffffc4
    2dd4:	000012ed 	andeq	r1, r0, sp, ror #5
    2dd8:	000001ec 	andeq	r0, r0, ip, ror #3
    2ddc:	0012ae2d 	andseq	sl, r2, sp, lsr #28
    2de0:	00003f00 	andeq	r3, r0, r0, lsl #30
    2de4:	3c2e0000 	stccc	0, cr0, [lr], #-0
    2de8:	5300000f 	movwpl	r0, #15
    2dec:	7f000014 	svcvc	0x00000014
    2df0:	f400000f 	vst4.8	{d0-d3}, [r0]
    2df4:	4c000093 	stcmi	0, cr0, [r0], {147}	; 0x93
    2df8:	01000000 	mrseq	r0, (UNDEF: 0)
    2dfc:	000f889c 	muleq	pc, ip, r8	; <UNPREDICTABLE>
    2e00:	0f512f00 	svceq	0x00512f00
    2e04:	91020000 	mrsls	r0, (UNDEF: 2)
    2e08:	b8300074 	ldmdalt	r0!, {r2, r4, r5, r6}
    2e0c:	01000000 	mrseq	r0, (UNDEF: 0)
    2e10:	0f99010a 	svceq	0x0099010a
    2e14:	af000000 	svcge	0x00000000
    2e18:	2d00000f 	stccs	0, cr0, [r0, #-60]	; 0xffffffc4
    2e1c:	000012ed 	andeq	r1, r0, sp, ror #5
    2e20:	000001ec 	andeq	r0, r0, ip, ror #3
    2e24:	00135831 	andseq	r5, r3, r1, lsr r8
    2e28:	2a0a0100 	bcs	283230 <__bss_end+0x278ef4>
    2e2c:	000001f1 	strdeq	r0, [r0], -r1
    2e30:	0f883200 	svceq	0x00883200
    2e34:	13e50000 	mvnne	r0, #0
    2e38:	0fc60000 	svceq	0x00c60000
    2e3c:	938c0000 	orrls	r0, ip, #0
    2e40:	00680000 	rsbeq	r0, r8, r0
    2e44:	9c010000 	stcls	0, cr0, [r1], {-0}
    2e48:	000f992f 	andeq	r9, pc, pc, lsr #18
    2e4c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    2e50:	000fa22f 	andeq	sl, pc, pc, lsr #4
    2e54:	70910200 	addsvc	r0, r1, r0, lsl #4
    2e58:	00220000 	eoreq	r0, r2, r0
    2e5c:	00020000 	andeq	r0, r2, r0
    2e60:	00000b23 	andeq	r0, r0, r3, lsr #22
    2e64:	0e330104 	rsfeqs	f0, f3, f4
    2e68:	98400000 	stmdals	r0, {}^	; <UNPREDICTABLE>
    2e6c:	9a4c0000 	bls	1302e74 <__bss_end+0x12f8b38>
    2e70:	146a0000 	strbtne	r0, [sl], #-0
    2e74:	149a0000 	ldrne	r0, [sl], #0
    2e78:	15020000 	strne	r0, [r2, #-0]
    2e7c:	80010000 	andhi	r0, r1, r0
    2e80:	00000022 	andeq	r0, r0, r2, lsr #32
    2e84:	0b370002 	bleq	dc2e94 <__bss_end+0xdb8b58>
    2e88:	01040000 	mrseq	r0, (UNDEF: 4)
    2e8c:	00000eb0 			; <UNDEFINED> instruction: 0x00000eb0
    2e90:	00009a4c 	andeq	r9, r0, ip, asr #20
    2e94:	00009a50 	andeq	r9, r0, r0, asr sl
    2e98:	0000146a 	andeq	r1, r0, sl, ror #8
    2e9c:	0000149a 	muleq	r0, sl, r4
    2ea0:	00001502 	andeq	r1, r0, r2, lsl #10
    2ea4:	00228001 	eoreq	r8, r2, r1
    2ea8:	00020000 	andeq	r0, r2, r0
    2eac:	00000b4b 	andeq	r0, r0, fp, asr #22
    2eb0:	0f100104 	svceq	0x00100104
    2eb4:	9a500000 	bls	1402ebc <__bss_end+0x13f8b80>
    2eb8:	9ca00000 	stcls	0, cr0, [r0]
    2ebc:	150e0000 	strne	r0, [lr, #-0]
    2ec0:	149a0000 	ldrne	r0, [sl], #0
    2ec4:	15020000 	strne	r0, [r2, #-0]
    2ec8:	80010000 	andhi	r0, r1, r0
    2ecc:	00000022 	andeq	r0, r0, r2, lsr #32
    2ed0:	0b5f0002 	bleq	17c2ee0 <__bss_end+0x17b8ba4>
    2ed4:	01040000 	mrseq	r0, (UNDEF: 4)
    2ed8:	0000100f 	andeq	r1, r0, pc
    2edc:	00009ca0 	andeq	r9, r0, r0, lsr #25
    2ee0:	00009d74 	andeq	r9, r0, r4, ror sp
    2ee4:	0000153f 	andeq	r1, r0, pc, lsr r5
    2ee8:	0000149a 	muleq	r0, sl, r4
    2eec:	00001502 	andeq	r1, r0, r2, lsl #10
    2ef0:	032a8001 			; <UNDEFINED> instruction: 0x032a8001
    2ef4:	00040000 	andeq	r0, r4, r0
    2ef8:	00000b73 	andeq	r0, r0, r3, ror fp
    2efc:	168b0104 	strne	r0, [fp], r4, lsl #2
    2f00:	440c0000 	strmi	r0, [ip], #-0
    2f04:	9a000018 	bls	2f6c <shift+0x2f6c>
    2f08:	8d000014 	stchi	0, cr0, [r0, #-80]	; 0xffffffb0
    2f0c:	02000010 	andeq	r0, r0, #16
    2f10:	6e690504 	cdpvs	5, 6, cr0, cr9, cr4, {0}
    2f14:	04030074 	streq	r0, [r3], #-116	; 0xffffff8c
    2f18:	00188d07 	andseq	r8, r8, r7, lsl #26
    2f1c:	05080300 	streq	r0, [r8, #-768]	; 0xfffffd00
    2f20:	00000243 	andeq	r0, r0, r3, asr #4
    2f24:	38040803 	stmdacc	r4, {r0, r1, fp}
    2f28:	03000018 	movweq	r0, #24
    2f2c:	0b570801 	bleq	15c4f38 <__bss_end+0x15babfc>
    2f30:	01030000 	mrseq	r0, (UNDEF: 3)
    2f34:	000b5906 	andeq	r5, fp, r6, lsl #18
    2f38:	1a100400 	bne	403f40 <__bss_end+0x3f9c04>
    2f3c:	01070000 	mrseq	r0, (UNDEF: 7)
    2f40:	00000039 	andeq	r0, r0, r9, lsr r0
    2f44:	d4061701 	strle	r1, [r6], #-1793	; 0xfffff8ff
    2f48:	05000001 	streq	r0, [r0, #-1]
    2f4c:	0000159a 	muleq	r0, sl, r5
    2f50:	1abf0500 	bne	fefc4358 <__bss_end+0xfefba01c>
    2f54:	05010000 	streq	r0, [r1, #-0]
    2f58:	0000176d 	andeq	r1, r0, sp, ror #14
    2f5c:	182b0502 	stmdane	fp!, {r1, r8, sl}
    2f60:	05030000 	streq	r0, [r3, #-0]
    2f64:	00001a29 	andeq	r1, r0, r9, lsr #20
    2f68:	1acf0504 	bne	ff3c4380 <__bss_end+0xff3ba044>
    2f6c:	05050000 	streq	r0, [r5, #-0]
    2f70:	00001a3f 	andeq	r1, r0, pc, lsr sl
    2f74:	18740506 	ldmdane	r4!, {r1, r2, r8, sl}^
    2f78:	05070000 	streq	r0, [r7, #-0]
    2f7c:	000019ba 			; <UNDEFINED> instruction: 0x000019ba
    2f80:	19c80508 	stmibne	r8, {r3, r8, sl}^
    2f84:	05090000 	streq	r0, [r9, #-0]
    2f88:	000019d6 	ldrdeq	r1, [r0], -r6
    2f8c:	18dd050a 	ldmne	sp, {r1, r3, r8, sl}^
    2f90:	050b0000 	streq	r0, [fp, #-0]
    2f94:	000018cd 	andeq	r1, r0, sp, asr #17
    2f98:	15b6050c 	ldrne	r0, [r6, #1292]!	; 0x50c
    2f9c:	050d0000 	streq	r0, [sp, #-0]
    2fa0:	000015cf 	andeq	r1, r0, pc, asr #11
    2fa4:	18be050e 	ldmne	lr!, {r1, r2, r3, r8, sl}
    2fa8:	050f0000 	streq	r0, [pc, #-0]	; 2fb0 <shift+0x2fb0>
    2fac:	00001a82 	andeq	r1, r0, r2, lsl #21
    2fb0:	19ff0510 	ldmibne	pc!, {r4, r8, sl}^	; <UNPREDICTABLE>
    2fb4:	05110000 	ldreq	r0, [r1, #-0]
    2fb8:	00001a73 	andeq	r1, r0, r3, ror sl
    2fbc:	167c0512 			; <UNDEFINED> instruction: 0x167c0512
    2fc0:	05130000 	ldreq	r0, [r3, #-0]
    2fc4:	000015f9 	strdeq	r1, [r0], -r9
    2fc8:	15c30514 	strbne	r0, [r3, #1300]	; 0x514
    2fcc:	05150000 	ldreq	r0, [r5, #-0]
    2fd0:	0000195c 	andeq	r1, r0, ip, asr r9
    2fd4:	16300516 			; <UNDEFINED> instruction: 0x16300516
    2fd8:	05170000 	ldreq	r0, [r7, #-0]
    2fdc:	0000156b 	andeq	r1, r0, fp, ror #10
    2fe0:	1a650518 	bne	1944448 <__bss_end+0x193a10c>
    2fe4:	05190000 	ldreq	r0, [r9, #-0]
    2fe8:	0000189a 	muleq	r0, sl, r8
    2fec:	1974051a 	ldmdbne	r4!, {r1, r3, r4, r8, sl}^
    2ff0:	051b0000 	ldreq	r0, [fp, #-0]
    2ff4:	00001604 	andeq	r1, r0, r4, lsl #12
    2ff8:	1810051c 	ldmdane	r0, {r2, r3, r4, r8, sl}
    2ffc:	051d0000 	ldreq	r0, [sp, #-0]
    3000:	0000175f 	andeq	r1, r0, pc, asr r7
    3004:	19f1051e 	ldmibne	r1!, {r1, r2, r3, r4, r8, sl}^
    3008:	051f0000 	ldreq	r0, [pc, #-0]	; 3010 <shift+0x3010>
    300c:	00001a4d 	andeq	r1, r0, sp, asr #20
    3010:	1a8e0520 	bne	fe384498 <__bss_end+0xfe37a15c>
    3014:	05210000 	streq	r0, [r1, #-0]!
    3018:	00001a9c 	muleq	r0, ip, sl
    301c:	18b10522 	ldmne	r1!, {r1, r5, r8, sl}
    3020:	05230000 	streq	r0, [r3, #-0]!
    3024:	000017d4 	ldrdeq	r1, [r0], -r4
    3028:	16130524 	ldrne	r0, [r3], -r4, lsr #10
    302c:	05250000 	streq	r0, [r5, #-0]!
    3030:	00001867 	andeq	r1, r0, r7, ror #16
    3034:	17790526 	ldrbne	r0, [r9, -r6, lsr #10]!
    3038:	05270000 	streq	r0, [r7, #-0]!
    303c:	00001a1c 	andeq	r1, r0, ip, lsl sl
    3040:	17890528 	strne	r0, [r9, r8, lsr #10]
    3044:	05290000 	streq	r0, [r9, #-0]!
    3048:	00001798 	muleq	r0, r8, r7
    304c:	17a7052a 	strne	r0, [r7, sl, lsr #10]!
    3050:	052b0000 	streq	r0, [fp, #-0]!
    3054:	000017b6 			; <UNDEFINED> instruction: 0x000017b6
    3058:	1744052c 	strbne	r0, [r4, -ip, lsr #10]
    305c:	052d0000 	streq	r0, [sp, #-0]!
    3060:	000017c5 	andeq	r1, r0, r5, asr #15
    3064:	19ab052e 	stmibne	fp!, {r1, r2, r3, r5, r8, sl}
    3068:	052f0000 	streq	r0, [pc, #-0]!	; 3070 <shift+0x3070>
    306c:	000017e3 	andeq	r1, r0, r3, ror #15
    3070:	17f20530 			; <UNDEFINED> instruction: 0x17f20530
    3074:	05310000 	ldreq	r0, [r1, #-0]!
    3078:	000015a4 	andeq	r1, r0, r4, lsr #11
    307c:	18fc0532 	ldmne	ip!, {r1, r4, r5, r8, sl}^
    3080:	05330000 	ldreq	r0, [r3, #-0]!
    3084:	0000190c 	andeq	r1, r0, ip, lsl #18
    3088:	191c0534 	ldmdbne	ip, {r2, r4, r5, r8, sl}
    308c:	05350000 	ldreq	r0, [r5, #-0]!
    3090:	00001732 	andeq	r1, r0, r2, lsr r7
    3094:	192c0536 	stmdbne	ip!, {r1, r2, r4, r5, r8, sl}
    3098:	05370000 	ldreq	r0, [r7, #-0]!
    309c:	0000193c 	andeq	r1, r0, ip, lsr r9
    30a0:	194c0538 	stmdbne	ip, {r3, r4, r5, r8, sl}^
    30a4:	05390000 	ldreq	r0, [r9, #-0]!
    30a8:	00001623 	andeq	r1, r0, r3, lsr #12
    30ac:	15dc053a 	ldrbne	r0, [ip, #1338]	; 0x53a
    30b0:	053b0000 	ldreq	r0, [fp, #-0]!
    30b4:	00001801 	andeq	r1, r0, r1, lsl #16
    30b8:	157b053c 	ldrbne	r0, [fp, #-1340]!	; 0xfffffac4
    30bc:	053d0000 	ldreq	r0, [sp, #-0]!
    30c0:	00001967 	andeq	r1, r0, r7, ror #18
    30c4:	6306003e 	movwvs	r0, #24638	; 0x603e
    30c8:	02000016 	andeq	r0, r0, #22
    30cc:	08026b01 	stmdaeq	r2, {r0, r8, r9, fp, sp, lr}
    30d0:	000001ff 	strdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    30d4:	00182607 	andseq	r2, r8, r7, lsl #12
    30d8:	02700100 	rsbseq	r0, r0, #0, 2
    30dc:	00004714 	andeq	r4, r0, r4, lsl r7
    30e0:	3f070000 	svccc	0x00070000
    30e4:	01000017 	tsteq	r0, r7, lsl r0
    30e8:	47140271 			; <UNDEFINED> instruction: 0x47140271
    30ec:	01000000 	mrseq	r0, (UNDEF: 0)
    30f0:	01d40800 	bicseq	r0, r4, r0, lsl #16
    30f4:	ff090000 			; <UNDEFINED> instruction: 0xff090000
    30f8:	14000001 	strne	r0, [r0], #-1
    30fc:	0a000002 	beq	310c <shift+0x310c>
    3100:	00000024 	andeq	r0, r0, r4, lsr #32
    3104:	04080011 	streq	r0, [r8], #-17	; 0xffffffef
    3108:	0b000002 	bleq	3118 <shift+0x3118>
    310c:	000018ea 	andeq	r1, r0, sl, ror #17
    3110:	26027401 	strcs	r7, [r2], -r1, lsl #8
    3114:	00000214 	andeq	r0, r0, r4, lsl r2
    3118:	0a3d3a24 	beq	f519b0 <__bss_end+0xf47674>
    311c:	243d0f3d 	ldrtcs	r0, [sp], #-3901	; 0xfffff0c3
    3120:	023d323d 	eorseq	r3, sp, #-805306365	; 0xd0000003
    3124:	133d053d 	teqne	sp, #255852544	; 0xf400000
    3128:	0c3d0d3d 	ldceq	13, cr0, [sp], #-244	; 0xffffff0c
    312c:	113d233d 	teqne	sp, sp, lsr r3
    3130:	013d263d 	teqeq	sp, sp, lsr r6
    3134:	083d173d 	ldmdaeq	sp!, {r0, r2, r3, r4, r5, r8, r9, sl, ip}
    3138:	003d093d 	eorseq	r0, sp, sp, lsr r9
    313c:	07020300 	streq	r0, [r2, -r0, lsl #6]
    3140:	00000c31 	andeq	r0, r0, r1, lsr ip
    3144:	60080103 	andvs	r0, r8, r3, lsl #2
    3148:	0c00000b 	stceq	0, cr0, [r0], {11}
    314c:	0259040d 	subseq	r0, r9, #218103808	; 0xd000000
    3150:	aa0e0000 	bge	383158 <__bss_end+0x378e1c>
    3154:	0700001a 	smladeq	r0, sl, r0, r0
    3158:	00003901 	andeq	r3, r0, r1, lsl #18
    315c:	04f70200 	ldrbteq	r0, [r7], #512	; 0x200
    3160:	00029e06 	andeq	r9, r2, r6, lsl #28
    3164:	163d0500 	ldrtne	r0, [sp], -r0, lsl #10
    3168:	05000000 	streq	r0, [r0, #-0]
    316c:	00001648 	andeq	r1, r0, r8, asr #12
    3170:	165a0501 	ldrbne	r0, [sl], -r1, lsl #10
    3174:	05020000 	streq	r0, [r2, #-0]
    3178:	00001674 	andeq	r1, r0, r4, ror r6
    317c:	19e40503 	stmibne	r4!, {r0, r1, r8, sl}^
    3180:	05040000 	streq	r0, [r4, #-0]
    3184:	00001753 	andeq	r1, r0, r3, asr r7
    3188:	199d0505 	ldmibne	sp, {r0, r2, r8, sl}
    318c:	00060000 	andeq	r0, r6, r0
    3190:	ec050203 	sfm	f0, 4, [r5], {3}
    3194:	03000009 	movweq	r0, #9
    3198:	18830708 	stmne	r3, {r3, r8, r9, sl}
    319c:	04030000 	streq	r0, [r3], #-0
    31a0:	00159404 	andseq	r9, r5, r4, lsl #8
    31a4:	03080300 	movweq	r0, #33536	; 0x8300
    31a8:	0000158c 	andeq	r1, r0, ip, lsl #11
    31ac:	3d040803 	stccc	8, cr0, [r4, #-12]
    31b0:	03000018 	movweq	r0, #24
    31b4:	198e0310 	stmibne	lr, {r4, r8, r9}
    31b8:	850f0000 	strhi	r0, [pc, #-0]	; 31c0 <shift+0x31c0>
    31bc:	03000019 	movweq	r0, #25
    31c0:	025a102a 	subseq	r1, sl, #42	; 0x2a
    31c4:	c8090000 	stmdagt	r9, {}	; <UNPREDICTABLE>
    31c8:	df000002 	svcle	0x00000002
    31cc:	10000002 	andne	r0, r0, r2
    31d0:	030c1100 	movweq	r1, #49408	; 0xc100
    31d4:	2f030000 	svccs	0x00030000
    31d8:	0002d411 	andeq	sp, r2, r1, lsl r4
    31dc:	02001100 	andeq	r1, r0, #0, 2
    31e0:	30030000 	andcc	r0, r3, r0
    31e4:	0002d411 	andeq	sp, r2, r1, lsl r4
    31e8:	02c80900 	sbceq	r0, r8, #0, 18
    31ec:	03070000 	movweq	r0, #28672	; 0x7000
    31f0:	240a0000 	strcs	r0, [sl], #-0
    31f4:	01000000 	mrseq	r0, (UNDEF: 0)
    31f8:	02df1200 	sbcseq	r1, pc, #0, 4
    31fc:	33040000 	movwcc	r0, #16384	; 0x4000
    3200:	02f70a09 	rscseq	r0, r7, #36864	; 0x9000
    3204:	03050000 	movweq	r0, #20480	; 0x5000
    3208:	0000a318 	andeq	sl, r0, r8, lsl r3
    320c:	0002eb12 	andeq	lr, r2, r2, lsl fp
    3210:	09340400 	ldmdbeq	r4!, {sl}
    3214:	0002f70a 	andeq	pc, r2, sl, lsl #14
    3218:	18030500 	stmdane	r3, {r8, sl}
    321c:	000000a3 	andeq	r0, r0, r3, lsr #1
    3220:	00000306 	andeq	r0, r0, r6, lsl #6
    3224:	0c600004 	stcleq	0, cr0, [r0], #-16
    3228:	01040000 	mrseq	r0, (UNDEF: 4)
    322c:	0000168b 	andeq	r1, r0, fp, lsl #13
    3230:	0018440c 	andseq	r4, r8, ip, lsl #8
    3234:	00149a00 	andseq	r9, r4, r0, lsl #20
    3238:	009d7400 	addseq	r7, sp, r0, lsl #8
    323c:	00003000 	andeq	r3, r0, r0
    3240:	00113500 	andseq	r3, r1, r0, lsl #10
    3244:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
    3248:	00001594 	muleq	r0, r4, r5
    324c:	69050403 	stmdbvs	r5, {r0, r1, sl}
    3250:	0200746e 	andeq	r7, r0, #1845493760	; 0x6e000000
    3254:	188d0704 	stmne	sp, {r2, r8, r9, sl}
    3258:	08020000 	stmdaeq	r2, {}	; <UNPREDICTABLE>
    325c:	00024305 	andeq	r4, r2, r5, lsl #6
    3260:	04080200 	streq	r0, [r8], #-512	; 0xfffffe00
    3264:	00001838 	andeq	r1, r0, r8, lsr r8
    3268:	57080102 	strpl	r0, [r8, -r2, lsl #2]
    326c:	0200000b 	andeq	r0, r0, #11
    3270:	0b590601 	bleq	1644a7c <__bss_end+0x163a740>
    3274:	10040000 	andne	r0, r4, r0
    3278:	0700001a 	smladeq	r0, sl, r0, r0
    327c:	00004801 	andeq	r4, r0, r1, lsl #16
    3280:	06170200 	ldreq	r0, [r7], -r0, lsl #4
    3284:	000001e3 	andeq	r0, r0, r3, ror #3
    3288:	00159a05 	andseq	r9, r5, r5, lsl #20
    328c:	bf050000 	svclt	0x00050000
    3290:	0100001a 	tsteq	r0, sl, lsl r0
    3294:	00176d05 	andseq	r6, r7, r5, lsl #26
    3298:	2b050200 	blcs	143aa0 <__bss_end+0x139764>
    329c:	03000018 	movweq	r0, #24
    32a0:	001a2905 	andseq	r2, sl, r5, lsl #18
    32a4:	cf050400 	svcgt	0x00050400
    32a8:	0500001a 	streq	r0, [r0, #-26]	; 0xffffffe6
    32ac:	001a3f05 	andseq	r3, sl, r5, lsl #30
    32b0:	74050600 	strvc	r0, [r5], #-1536	; 0xfffffa00
    32b4:	07000018 	smladeq	r0, r8, r0, r0
    32b8:	0019ba05 	andseq	fp, r9, r5, lsl #20
    32bc:	c8050800 	stmdagt	r5, {fp}
    32c0:	09000019 	stmdbeq	r0, {r0, r3, r4}
    32c4:	0019d605 	andseq	sp, r9, r5, lsl #12
    32c8:	dd050a00 	vstrle	s0, [r5, #-0]
    32cc:	0b000018 	bleq	3334 <shift+0x3334>
    32d0:	0018cd05 	andseq	ip, r8, r5, lsl #26
    32d4:	b6050c00 	strlt	r0, [r5], -r0, lsl #24
    32d8:	0d000015 	stceq	0, cr0, [r0, #-84]	; 0xffffffac
    32dc:	0015cf05 	andseq	ip, r5, r5, lsl #30
    32e0:	be050e00 	cdplt	14, 0, cr0, cr5, cr0, {0}
    32e4:	0f000018 	svceq	0x00000018
    32e8:	001a8205 	andseq	r8, sl, r5, lsl #4
    32ec:	ff051000 			; <UNDEFINED> instruction: 0xff051000
    32f0:	11000019 	tstne	r0, r9, lsl r0
    32f4:	001a7305 	andseq	r7, sl, r5, lsl #6
    32f8:	7c051200 	sfmvc	f1, 4, [r5], {-0}
    32fc:	13000016 	movwne	r0, #22
    3300:	0015f905 	andseq	pc, r5, r5, lsl #18
    3304:	c3051400 	movwgt	r1, #21504	; 0x5400
    3308:	15000015 	strne	r0, [r0, #-21]	; 0xffffffeb
    330c:	00195c05 	andseq	r5, r9, r5, lsl #24
    3310:	30051600 	andcc	r1, r5, r0, lsl #12
    3314:	17000016 	smladne	r0, r6, r0, r0
    3318:	00156b05 	andseq	r6, r5, r5, lsl #22
    331c:	65051800 	strvs	r1, [r5, #-2048]	; 0xfffff800
    3320:	1900001a 	stmdbne	r0, {r1, r3, r4}
    3324:	00189a05 	andseq	r9, r8, r5, lsl #20
    3328:	74051a00 	strvc	r1, [r5], #-2560	; 0xfffff600
    332c:	1b000019 	blne	3398 <shift+0x3398>
    3330:	00160405 	andseq	r0, r6, r5, lsl #8
    3334:	10051c00 	andne	r1, r5, r0, lsl #24
    3338:	1d000018 	stcne	0, cr0, [r0, #-96]	; 0xffffffa0
    333c:	00175f05 	andseq	r5, r7, r5, lsl #30
    3340:	f1051e00 			; <UNDEFINED> instruction: 0xf1051e00
    3344:	1f000019 	svcne	0x00000019
    3348:	001a4d05 	andseq	r4, sl, r5, lsl #26
    334c:	8e052000 	cdphi	0, 0, cr2, cr5, cr0, {0}
    3350:	2100001a 	tstcs	r0, sl, lsl r0
    3354:	001a9c05 	andseq	r9, sl, r5, lsl #24
    3358:	b1052200 	mrslt	r2, SP_usr
    335c:	23000018 	movwcs	r0, #24
    3360:	0017d405 	andseq	sp, r7, r5, lsl #8
    3364:	13052400 	movwne	r2, #21504	; 0x5400
    3368:	25000016 	strcs	r0, [r0, #-22]	; 0xffffffea
    336c:	00186705 	andseq	r6, r8, r5, lsl #14
    3370:	79052600 	stmdbvc	r5, {r9, sl, sp}
    3374:	27000017 	smladcs	r0, r7, r0, r0
    3378:	001a1c05 	andseq	r1, sl, r5, lsl #24
    337c:	89052800 	stmdbhi	r5, {fp, sp}
    3380:	29000017 	stmdbcs	r0, {r0, r1, r2, r4}
    3384:	00179805 	andseq	r9, r7, r5, lsl #16
    3388:	a7052a00 	strge	r2, [r5, -r0, lsl #20]
    338c:	2b000017 	blcs	33f0 <shift+0x33f0>
    3390:	0017b605 	andseq	fp, r7, r5, lsl #12
    3394:	44052c00 	strmi	r2, [r5], #-3072	; 0xfffff400
    3398:	2d000017 	stccs	0, cr0, [r0, #-92]	; 0xffffffa4
    339c:	0017c505 	andseq	ip, r7, r5, lsl #10
    33a0:	ab052e00 	blge	14eba8 <__bss_end+0x14486c>
    33a4:	2f000019 	svccs	0x00000019
    33a8:	0017e305 	andseq	lr, r7, r5, lsl #6
    33ac:	f2053000 	vhadd.s8	d3, d5, d0
    33b0:	31000017 	tstcc	r0, r7, lsl r0
    33b4:	0015a405 	andseq	sl, r5, r5, lsl #8
    33b8:	fc053200 	stc2	2, cr3, [r5], {-0}
    33bc:	33000018 	movwcc	r0, #24
    33c0:	00190c05 	andseq	r0, r9, r5, lsl #24
    33c4:	1c053400 	cfstrsne	mvf3, [r5], {-0}
    33c8:	35000019 	strcc	r0, [r0, #-25]	; 0xffffffe7
    33cc:	00173205 	andseq	r3, r7, r5, lsl #4
    33d0:	2c053600 	stccs	6, cr3, [r5], {-0}
    33d4:	37000019 	smladcc	r0, r9, r0, r0
    33d8:	00193c05 	andseq	r3, r9, r5, lsl #24
    33dc:	4c053800 	stcmi	8, cr3, [r5], {-0}
    33e0:	39000019 	stmdbcc	r0, {r0, r3, r4}
    33e4:	00162305 	andseq	r2, r6, r5, lsl #6
    33e8:	dc053a00 			; <UNDEFINED> instruction: 0xdc053a00
    33ec:	3b000015 	blcc	3448 <shift+0x3448>
    33f0:	00180105 	andseq	r0, r8, r5, lsl #2
    33f4:	7b053c00 	blvc	1523fc <__bss_end+0x1480c0>
    33f8:	3d000015 	stccc	0, cr0, [r0, #-84]	; 0xffffffac
    33fc:	00196705 	andseq	r6, r9, r5, lsl #14
    3400:	06003e00 	streq	r3, [r0], -r0, lsl #28
    3404:	00001663 	andeq	r1, r0, r3, ror #12
    3408:	026b0202 	rsbeq	r0, fp, #536870912	; 0x20000000
    340c:	00020e08 	andeq	r0, r2, r8, lsl #28
    3410:	18260700 	stmdane	r6!, {r8, r9, sl}
    3414:	70020000 	andvc	r0, r2, r0
    3418:	00561402 	subseq	r1, r6, r2, lsl #8
    341c:	07000000 	streq	r0, [r0, -r0]
    3420:	0000173f 	andeq	r1, r0, pc, lsr r7
    3424:	14027102 	strne	r7, [r2], #-258	; 0xfffffefe
    3428:	00000056 	andeq	r0, r0, r6, asr r0
    342c:	e3080001 	movw	r0, #32769	; 0x8001
    3430:	09000001 	stmdbeq	r0, {r0}
    3434:	0000020e 	andeq	r0, r0, lr, lsl #4
    3438:	00000223 	andeq	r0, r0, r3, lsr #4
    343c:	0000330a 	andeq	r3, r0, sl, lsl #6
    3440:	08001100 	stmdaeq	r0, {r8, ip}
    3444:	00000213 	andeq	r0, r0, r3, lsl r2
    3448:	0018ea0b 	andseq	lr, r8, fp, lsl #20
    344c:	02740200 	rsbseq	r0, r4, #0, 4
    3450:	00022326 	andeq	r2, r2, r6, lsr #6
    3454:	3d3a2400 	cfldrscc	mvf2, [sl, #-0]
    3458:	3d0f3d0a 	stccc	13, cr3, [pc, #-40]	; 3438 <shift+0x3438>
    345c:	3d323d24 	ldccc	13, cr3, [r2, #-144]!	; 0xffffff70
    3460:	3d053d02 	stccc	13, cr3, [r5, #-8]
    3464:	3d0d3d13 	stccc	13, cr3, [sp, #-76]	; 0xffffffb4
    3468:	3d233d0c 	stccc	13, cr3, [r3, #-48]!	; 0xffffffd0
    346c:	3d263d11 	stccc	13, cr3, [r6, #-68]!	; 0xffffffbc
    3470:	3d173d01 	ldccc	13, cr3, [r7, #-4]
    3474:	3d093d08 	stccc	13, cr3, [r9, #-32]	; 0xffffffe0
    3478:	02020000 	andeq	r0, r2, #0
    347c:	000c3107 	andeq	r3, ip, r7, lsl #2
    3480:	08010200 	stmdaeq	r1, {r9}
    3484:	00000b60 	andeq	r0, r0, r0, ror #22
    3488:	ec050202 	sfm	f0, 4, [r5], {2}
    348c:	0c000009 	stceq	0, cr0, [r0], {9}
    3490:	00001b1b 	andeq	r1, r0, fp, lsl fp
    3494:	3a0f8403 	bcc	3e44a8 <__bss_end+0x3da16c>
    3498:	02000000 	andeq	r0, r0, #0
    349c:	18830708 	stmne	r3, {r3, r8, r9, sl}
    34a0:	ec0c0000 	stc	0, cr0, [ip], {-0}
    34a4:	0300001a 	movweq	r0, #26
    34a8:	00251093 	mlaeq	r5, r3, r0, r1
    34ac:	08020000 	stmdaeq	r2, {}	; <UNPREDICTABLE>
    34b0:	00158c03 	andseq	r8, r5, r3, lsl #24
    34b4:	04080200 	streq	r0, [r8], #-512	; 0xfffffe00
    34b8:	0000183d 	andeq	r1, r0, sp, lsr r8
    34bc:	8e031002 	cdphi	0, 0, cr1, cr3, cr2, {0}
    34c0:	0d000019 	stceq	0, cr0, [r0, #-100]	; 0xffffff9c
    34c4:	00001b01 	andeq	r1, r0, r1, lsl #22
    34c8:	0105f901 	tsteq	r5, r1, lsl #18	; <UNPREDICTABLE>
    34cc:	0000026f 	andeq	r0, r0, pc, ror #4
    34d0:	00009d74 	andeq	r9, r0, r4, ror sp
    34d4:	00000030 	andeq	r0, r0, r0, lsr r0
    34d8:	02fd9c01 	rscseq	r9, sp, #256	; 0x100
    34dc:	610e0000 	mrsvs	r0, (UNDEF: 14)
    34e0:	05f90100 	ldrbeq	r0, [r9, #256]!	; 0x100
    34e4:	00028213 	andeq	r8, r2, r3, lsl r2
    34e8:	00000800 	andeq	r0, r0, r0, lsl #16
    34ec:	00000000 	andeq	r0, r0, r0
    34f0:	9d880f00 	stcls	15, cr0, [r8]
    34f4:	02fd0000 	rscseq	r0, sp, #0
    34f8:	02e80000 	rsceq	r0, r8, #0
    34fc:	01100000 	tsteq	r0, r0
    3500:	03f30550 	mvnseq	r0, #80, 10	; 0x14000000
    3504:	002500f5 	strdeq	r0, [r5], -r5	; <UNPREDICTABLE>
    3508:	009d9811 	addseq	r9, sp, r1, lsl r8
    350c:	0002fd00 	andeq	pc, r2, r0, lsl #26
    3510:	50011000 	andpl	r1, r1, r0
    3514:	f503f306 			; <UNDEFINED> instruction: 0xf503f306
    3518:	001f2500 	andseq	r2, pc, r0, lsl #10
    351c:	1af31200 	bne	ffcc7d24 <__bss_end+0xffcbd9e8>
    3520:	1adf0000 	bne	ff7c3528 <__bss_end+0xff7b91ec>
    3524:	3b010000 	blcc	4352c <__bss_end+0x391f0>
    3528:	032a0003 			; <UNDEFINED> instruction: 0x032a0003
    352c:	00040000 	andeq	r0, r4, r0
    3530:	00000d6f 	andeq	r0, r0, pc, ror #26
    3534:	168b0104 	strne	r0, [fp], r4, lsl #2
    3538:	440c0000 	strmi	r0, [ip], #-0
    353c:	9a000018 	bls	35a4 <shift+0x35a4>
    3540:	a8000014 	stmdage	r0, {r2, r4}
    3544:	4000009d 	mulmi	r0, sp, r0
    3548:	e0000000 	and	r0, r0, r0
    354c:	02000011 	andeq	r0, r0, #17
    3550:	183d0408 	ldmdane	sp!, {r3, sl}
    3554:	04020000 	streq	r0, [r2], #-0
    3558:	00188d07 	andseq	r8, r8, r7, lsl #26
    355c:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
    3560:	00001594 	muleq	r0, r4, r5
    3564:	69050403 	stmdbvs	r5, {r0, r1, sl}
    3568:	0200746e 	andeq	r7, r0, #1845493760	; 0x6e000000
    356c:	02430508 	subeq	r0, r3, #8, 10	; 0x2000000
    3570:	08020000 	stmdaeq	r2, {}	; <UNPREDICTABLE>
    3574:	00183804 	andseq	r3, r8, r4, lsl #16
    3578:	08010200 	stmdaeq	r1, {r9}
    357c:	00000b57 	andeq	r0, r0, r7, asr fp
    3580:	59060102 	stmdbpl	r6, {r1, r8}
    3584:	0400000b 	streq	r0, [r0], #-11
    3588:	00001a10 	andeq	r1, r0, r0, lsl sl
    358c:	004f0107 	subeq	r0, pc, r7, lsl #2
    3590:	17020000 	strne	r0, [r2, -r0]
    3594:	0001ea06 	andeq	lr, r1, r6, lsl #20
    3598:	159a0500 	ldrne	r0, [sl, #1280]	; 0x500
    359c:	05000000 	streq	r0, [r0, #-0]
    35a0:	00001abf 			; <UNDEFINED> instruction: 0x00001abf
    35a4:	176d0501 	strbne	r0, [sp, -r1, lsl #10]!
    35a8:	05020000 	streq	r0, [r2, #-0]
    35ac:	0000182b 	andeq	r1, r0, fp, lsr #16
    35b0:	1a290503 	bne	a449c4 <__bss_end+0xa3a688>
    35b4:	05040000 	streq	r0, [r4, #-0]
    35b8:	00001acf 	andeq	r1, r0, pc, asr #21
    35bc:	1a3f0505 	bne	fc49d8 <__bss_end+0xfba69c>
    35c0:	05060000 	streq	r0, [r6, #-0]
    35c4:	00001874 	andeq	r1, r0, r4, ror r8
    35c8:	19ba0507 	ldmibne	sl!, {r0, r1, r2, r8, sl}
    35cc:	05080000 	streq	r0, [r8, #-0]
    35d0:	000019c8 	andeq	r1, r0, r8, asr #19
    35d4:	19d60509 	ldmibne	r6, {r0, r3, r8, sl}^
    35d8:	050a0000 	streq	r0, [sl, #-0]
    35dc:	000018dd 	ldrdeq	r1, [r0], -sp
    35e0:	18cd050b 	stmiane	sp, {r0, r1, r3, r8, sl}^
    35e4:	050c0000 	streq	r0, [ip, #-0]
    35e8:	000015b6 			; <UNDEFINED> instruction: 0x000015b6
    35ec:	15cf050d 	strbne	r0, [pc, #1293]	; 3b01 <shift+0x3b01>
    35f0:	050e0000 	streq	r0, [lr, #-0]
    35f4:	000018be 			; <UNDEFINED> instruction: 0x000018be
    35f8:	1a82050f 	bne	fe084a3c <__bss_end+0xfe07a700>
    35fc:	05100000 	ldreq	r0, [r0, #-0]
    3600:	000019ff 	strdeq	r1, [r0], -pc	; <UNPREDICTABLE>
    3604:	1a730511 	bne	1cc4a50 <__bss_end+0x1cba714>
    3608:	05120000 	ldreq	r0, [r2, #-0]
    360c:	0000167c 	andeq	r1, r0, ip, ror r6
    3610:	15f90513 	ldrbne	r0, [r9, #1299]!	; 0x513
    3614:	05140000 	ldreq	r0, [r4, #-0]
    3618:	000015c3 	andeq	r1, r0, r3, asr #11
    361c:	195c0515 	ldmdbne	ip, {r0, r2, r4, r8, sl}^
    3620:	05160000 	ldreq	r0, [r6, #-0]
    3624:	00001630 	andeq	r1, r0, r0, lsr r6
    3628:	156b0517 	strbne	r0, [fp, #-1303]!	; 0xfffffae9
    362c:	05180000 	ldreq	r0, [r8, #-0]
    3630:	00001a65 	andeq	r1, r0, r5, ror #20
    3634:	189a0519 	ldmne	sl, {r0, r3, r4, r8, sl}
    3638:	051a0000 	ldreq	r0, [sl, #-0]
    363c:	00001974 	andeq	r1, r0, r4, ror r9
    3640:	1604051b 			; <UNDEFINED> instruction: 0x1604051b
    3644:	051c0000 	ldreq	r0, [ip, #-0]
    3648:	00001810 	andeq	r1, r0, r0, lsl r8
    364c:	175f051d 	smmlane	pc, sp, r5, r0	; <UNPREDICTABLE>
    3650:	051e0000 	ldreq	r0, [lr, #-0]
    3654:	000019f1 	strdeq	r1, [r0], -r1	; <UNPREDICTABLE>
    3658:	1a4d051f 	bne	1344adc <__bss_end+0x133a7a0>
    365c:	05200000 	streq	r0, [r0, #-0]!
    3660:	00001a8e 	andeq	r1, r0, lr, lsl #21
    3664:	1a9c0521 	bne	fe704af0 <__bss_end+0xfe6fa7b4>
    3668:	05220000 	streq	r0, [r2, #-0]!
    366c:	000018b1 			; <UNDEFINED> instruction: 0x000018b1
    3670:	17d40523 	ldrbne	r0, [r4, r3, lsr #10]
    3674:	05240000 	streq	r0, [r4, #-0]!
    3678:	00001613 	andeq	r1, r0, r3, lsl r6
    367c:	18670525 	stmdane	r7!, {r0, r2, r5, r8, sl}^
    3680:	05260000 	streq	r0, [r6, #-0]!
    3684:	00001779 	andeq	r1, r0, r9, ror r7
    3688:	1a1c0527 	bne	704b2c <__bss_end+0x6fa7f0>
    368c:	05280000 	streq	r0, [r8, #-0]!
    3690:	00001789 	andeq	r1, r0, r9, lsl #15
    3694:	17980529 	ldrne	r0, [r8, r9, lsr #10]
    3698:	052a0000 	streq	r0, [sl, #-0]!
    369c:	000017a7 	andeq	r1, r0, r7, lsr #15
    36a0:	17b6052b 	ldrne	r0, [r6, fp, lsr #10]!
    36a4:	052c0000 	streq	r0, [ip, #-0]!
    36a8:	00001744 	andeq	r1, r0, r4, asr #14
    36ac:	17c5052d 	strbne	r0, [r5, sp, lsr #10]
    36b0:	052e0000 	streq	r0, [lr, #-0]!
    36b4:	000019ab 	andeq	r1, r0, fp, lsr #19
    36b8:	17e3052f 	strbne	r0, [r3, pc, lsr #10]!
    36bc:	05300000 	ldreq	r0, [r0, #-0]!
    36c0:	000017f2 	strdeq	r1, [r0], -r2
    36c4:	15a40531 	strne	r0, [r4, #1329]!	; 0x531
    36c8:	05320000 	ldreq	r0, [r2, #-0]!
    36cc:	000018fc 	strdeq	r1, [r0], -ip
    36d0:	190c0533 	stmdbne	ip, {r0, r1, r4, r5, r8, sl}
    36d4:	05340000 	ldreq	r0, [r4, #-0]!
    36d8:	0000191c 	andeq	r1, r0, ip, lsl r9
    36dc:	17320535 			; <UNDEFINED> instruction: 0x17320535
    36e0:	05360000 	ldreq	r0, [r6, #-0]!
    36e4:	0000192c 	andeq	r1, r0, ip, lsr #18
    36e8:	193c0537 	ldmdbne	ip!, {r0, r1, r2, r4, r5, r8, sl}
    36ec:	05380000 	ldreq	r0, [r8, #-0]!
    36f0:	0000194c 	andeq	r1, r0, ip, asr #18
    36f4:	16230539 			; <UNDEFINED> instruction: 0x16230539
    36f8:	053a0000 	ldreq	r0, [sl, #-0]!
    36fc:	000015dc 	ldrdeq	r1, [r0], -ip
    3700:	1801053b 	stmdane	r1, {r0, r1, r3, r4, r5, r8, sl}
    3704:	053c0000 	ldreq	r0, [ip, #-0]!
    3708:	0000157b 	andeq	r1, r0, fp, ror r5
    370c:	1967053d 	stmdbne	r7!, {r0, r2, r3, r4, r5, r8, sl}^
    3710:	003e0000 	eorseq	r0, lr, r0
    3714:	00166306 	andseq	r6, r6, r6, lsl #6
    3718:	6b020200 	blvs	83f20 <__bss_end+0x79be4>
    371c:	02150802 	andseq	r0, r5, #131072	; 0x20000
    3720:	26070000 	strcs	r0, [r7], -r0
    3724:	02000018 	andeq	r0, r0, #24
    3728:	5d140270 	lfmpl	f0, 4, [r4, #-448]	; 0xfffffe40
    372c:	00000000 	andeq	r0, r0, r0
    3730:	00173f07 	andseq	r3, r7, r7, lsl #30
    3734:	02710200 	rsbseq	r0, r1, #0, 4
    3738:	00005d14 	andeq	r5, r0, r4, lsl sp
    373c:	08000100 	stmdaeq	r0, {r8}
    3740:	000001ea 	andeq	r0, r0, sl, ror #3
    3744:	00021509 	andeq	r1, r2, r9, lsl #10
    3748:	00022a00 	andeq	r2, r2, r0, lsl #20
    374c:	002c0a00 	eoreq	r0, ip, r0, lsl #20
    3750:	00110000 	andseq	r0, r1, r0
    3754:	00021a08 	andeq	r1, r2, r8, lsl #20
    3758:	18ea0b00 	stmiane	sl!, {r8, r9, fp}^
    375c:	74020000 	strvc	r0, [r2], #-0
    3760:	022a2602 	eoreq	r2, sl, #2097152	; 0x200000
    3764:	3a240000 	bcc	90376c <__bss_end+0x8f9430>
    3768:	0f3d0a3d 	svceq	0x003d0a3d
    376c:	323d243d 	eorscc	r2, sp, #1023410176	; 0x3d000000
    3770:	053d023d 	ldreq	r0, [sp, #-573]!	; 0xfffffdc3
    3774:	0d3d133d 	ldceq	3, cr1, [sp, #-244]!	; 0xffffff0c
    3778:	233d0c3d 	teqcs	sp, #15616	; 0x3d00
    377c:	263d113d 			; <UNDEFINED> instruction: 0x263d113d
    3780:	173d013d 			; <UNDEFINED> instruction: 0x173d013d
    3784:	093d083d 	ldmdbeq	sp!, {r0, r2, r3, r4, r5, fp}
    3788:	0200003d 	andeq	r0, r0, #61	; 0x3d
    378c:	0c310702 	ldceq	7, cr0, [r1], #-8
    3790:	01020000 	mrseq	r0, (UNDEF: 2)
    3794:	000b6008 	andeq	r6, fp, r8
    3798:	05020200 	streq	r0, [r2, #-512]	; 0xfffffe00
    379c:	000009ec 	andeq	r0, r0, ip, ror #19
    37a0:	001b120c 	andseq	r1, fp, ip, lsl #4
    37a4:	16810300 	strne	r0, [r1], r0, lsl #6
    37a8:	0000002c 	andeq	r0, r0, ip, lsr #32
    37ac:	00027608 	andeq	r7, r2, r8, lsl #12
    37b0:	1b1a0c00 	blne	6867b8 <__bss_end+0x67c47c>
    37b4:	85030000 	strhi	r0, [r3, #-0]
    37b8:	00029316 	andeq	r9, r2, r6, lsl r3
    37bc:	07080200 	streq	r0, [r8, -r0, lsl #4]
    37c0:	00001883 	andeq	r1, r0, r3, lsl #17
    37c4:	001aec0c 	andseq	lr, sl, ip, lsl #24
    37c8:	10930300 	addsne	r0, r3, r0, lsl #6
    37cc:	00000033 	andeq	r0, r0, r3, lsr r0
    37d0:	8c030802 	stchi	8, cr0, [r3], {2}
    37d4:	0c000015 	stceq	0, cr0, [r0], {21}
    37d8:	00001b0b 	andeq	r1, r0, fp, lsl #22
    37dc:	25109703 	ldrcs	r9, [r0, #-1795]	; 0xfffff8fd
    37e0:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    37e4:	000002ad 	andeq	r0, r0, sp, lsr #5
    37e8:	8e031002 	cdphi	0, 0, cr1, cr3, cr2, {0}
    37ec:	0d000019 	stceq	0, cr0, [r0, #-100]	; 0xffffff9c
    37f0:	00001adf 	ldrdeq	r1, [r0], -pc	; <UNPREDICTABLE>
    37f4:	0105b901 	tsteq	r5, r1, lsl #18
    37f8:	00000287 	andeq	r0, r0, r7, lsl #5
    37fc:	00009da8 	andeq	r9, r0, r8, lsr #27
    3800:	00000040 	andeq	r0, r0, r0, asr #32
    3804:	610e9c01 	tstvs	lr, r1, lsl #24
    3808:	05b90100 	ldreq	r0, [r9, #256]!	; 0x100
    380c:	00029a16 	andeq	r9, r2, r6, lsl sl
    3810:	00004a00 	andeq	r4, r0, r0, lsl #20
    3814:	00004600 	andeq	r4, r0, r0, lsl #12
    3818:	66640f00 	strbtvs	r0, [r4], -r0, lsl #30
    381c:	bf010061 	svclt	0x00010061
    3820:	02b91005 	adcseq	r1, r9, #5
    3824:	00730000 	rsbseq	r0, r3, r0
    3828:	006d0000 	rsbeq	r0, sp, r0
    382c:	680f0000 	stmdavs	pc, {}	; <UNPREDICTABLE>
    3830:	c4010069 	strgt	r0, [r1], #-105	; 0xffffff97
    3834:	02821005 	addeq	r1, r2, #5
    3838:	00b10000 	adcseq	r0, r1, r0
    383c:	00af0000 	adceq	r0, pc, r0
    3840:	6c0f0000 	stcvs	0, cr0, [pc], {-0}
    3844:	c901006f 	stmdbgt	r1, {r0, r1, r2, r3, r5, r6}
    3848:	02821005 	addeq	r1, r2, #5
    384c:	00cb0000 	sbceq	r0, fp, r0
    3850:	00c50000 	sbceq	r0, r5, r0
    3854:	00000000 	andeq	r0, r0, r0
    3858:	00000380 	andeq	r0, r0, r0, lsl #7
    385c:	0e560004 	cdpeq	0, 5, cr0, cr6, cr4, {0}
    3860:	01040000 	mrseq	r0, (UNDEF: 4)
    3864:	00001b22 	andeq	r1, r0, r2, lsr #22
    3868:	0018440c 	andseq	r4, r8, ip, lsl #8
    386c:	00149a00 	andseq	r9, r4, r0, lsl #20
    3870:	009de800 	addseq	lr, sp, r0, lsl #16
    3874:	00012000 	andeq	r2, r1, r0
    3878:	00129a00 	andseq	r9, r2, r0, lsl #20
    387c:	07080200 	streq	r0, [r8, -r0, lsl #4]
    3880:	00001883 	andeq	r1, r0, r3, lsl #17
    3884:	69050403 	stmdbvs	r5, {r0, r1, sl}
    3888:	0200746e 	andeq	r7, r0, #1845493760	; 0x6e000000
    388c:	188d0704 	stmne	sp, {r2, r8, r9, sl}
    3890:	08020000 	stmdaeq	r2, {}	; <UNPREDICTABLE>
    3894:	00024305 	andeq	r4, r2, r5, lsl #6
    3898:	04080200 	streq	r0, [r8], #-512	; 0xfffffe00
    389c:	00001838 	andeq	r1, r0, r8, lsr r8
    38a0:	57080102 	strpl	r0, [r8, -r2, lsl #2]
    38a4:	0200000b 	andeq	r0, r0, #11
    38a8:	0b590601 	bleq	16450b4 <__bss_end+0x163ad78>
    38ac:	10040000 	andne	r0, r4, r0
    38b0:	0700001a 	smladeq	r0, sl, r0, r0
    38b4:	00004801 	andeq	r4, r0, r1, lsl #16
    38b8:	06170200 	ldreq	r0, [r7], -r0, lsl #4
    38bc:	000001e3 	andeq	r0, r0, r3, ror #3
    38c0:	00159a05 	andseq	r9, r5, r5, lsl #20
    38c4:	bf050000 	svclt	0x00050000
    38c8:	0100001a 	tsteq	r0, sl, lsl r0
    38cc:	00176d05 	andseq	r6, r7, r5, lsl #26
    38d0:	2b050200 	blcs	1440d8 <__bss_end+0x139d9c>
    38d4:	03000018 	movweq	r0, #24
    38d8:	001a2905 	andseq	r2, sl, r5, lsl #18
    38dc:	cf050400 	svcgt	0x00050400
    38e0:	0500001a 	streq	r0, [r0, #-26]	; 0xffffffe6
    38e4:	001a3f05 	andseq	r3, sl, r5, lsl #30
    38e8:	74050600 	strvc	r0, [r5], #-1536	; 0xfffffa00
    38ec:	07000018 	smladeq	r0, r8, r0, r0
    38f0:	0019ba05 	andseq	fp, r9, r5, lsl #20
    38f4:	c8050800 	stmdagt	r5, {fp}
    38f8:	09000019 	stmdbeq	r0, {r0, r3, r4}
    38fc:	0019d605 	andseq	sp, r9, r5, lsl #12
    3900:	dd050a00 	vstrle	s0, [r5, #-0]
    3904:	0b000018 	bleq	396c <shift+0x396c>
    3908:	0018cd05 	andseq	ip, r8, r5, lsl #26
    390c:	b6050c00 	strlt	r0, [r5], -r0, lsl #24
    3910:	0d000015 	stceq	0, cr0, [r0, #-84]	; 0xffffffac
    3914:	0015cf05 	andseq	ip, r5, r5, lsl #30
    3918:	be050e00 	cdplt	14, 0, cr0, cr5, cr0, {0}
    391c:	0f000018 	svceq	0x00000018
    3920:	001a8205 	andseq	r8, sl, r5, lsl #4
    3924:	ff051000 			; <UNDEFINED> instruction: 0xff051000
    3928:	11000019 	tstne	r0, r9, lsl r0
    392c:	001a7305 	andseq	r7, sl, r5, lsl #6
    3930:	7c051200 	sfmvc	f1, 4, [r5], {-0}
    3934:	13000016 	movwne	r0, #22
    3938:	0015f905 	andseq	pc, r5, r5, lsl #18
    393c:	c3051400 	movwgt	r1, #21504	; 0x5400
    3940:	15000015 	strne	r0, [r0, #-21]	; 0xffffffeb
    3944:	00195c05 	andseq	r5, r9, r5, lsl #24
    3948:	30051600 	andcc	r1, r5, r0, lsl #12
    394c:	17000016 	smladne	r0, r6, r0, r0
    3950:	00156b05 	andseq	r6, r5, r5, lsl #22
    3954:	65051800 	strvs	r1, [r5, #-2048]	; 0xfffff800
    3958:	1900001a 	stmdbne	r0, {r1, r3, r4}
    395c:	00189a05 	andseq	r9, r8, r5, lsl #20
    3960:	74051a00 	strvc	r1, [r5], #-2560	; 0xfffff600
    3964:	1b000019 	blne	39d0 <shift+0x39d0>
    3968:	00160405 	andseq	r0, r6, r5, lsl #8
    396c:	10051c00 	andne	r1, r5, r0, lsl #24
    3970:	1d000018 	stcne	0, cr0, [r0, #-96]	; 0xffffffa0
    3974:	00175f05 	andseq	r5, r7, r5, lsl #30
    3978:	f1051e00 			; <UNDEFINED> instruction: 0xf1051e00
    397c:	1f000019 	svcne	0x00000019
    3980:	001a4d05 	andseq	r4, sl, r5, lsl #26
    3984:	8e052000 	cdphi	0, 0, cr2, cr5, cr0, {0}
    3988:	2100001a 	tstcs	r0, sl, lsl r0
    398c:	001a9c05 	andseq	r9, sl, r5, lsl #24
    3990:	b1052200 	mrslt	r2, SP_usr
    3994:	23000018 	movwcs	r0, #24
    3998:	0017d405 	andseq	sp, r7, r5, lsl #8
    399c:	13052400 	movwne	r2, #21504	; 0x5400
    39a0:	25000016 	strcs	r0, [r0, #-22]	; 0xffffffea
    39a4:	00186705 	andseq	r6, r8, r5, lsl #14
    39a8:	79052600 	stmdbvc	r5, {r9, sl, sp}
    39ac:	27000017 	smladcs	r0, r7, r0, r0
    39b0:	001a1c05 	andseq	r1, sl, r5, lsl #24
    39b4:	89052800 	stmdbhi	r5, {fp, sp}
    39b8:	29000017 	stmdbcs	r0, {r0, r1, r2, r4}
    39bc:	00179805 	andseq	r9, r7, r5, lsl #16
    39c0:	a7052a00 	strge	r2, [r5, -r0, lsl #20]
    39c4:	2b000017 	blcs	3a28 <shift+0x3a28>
    39c8:	0017b605 	andseq	fp, r7, r5, lsl #12
    39cc:	44052c00 	strmi	r2, [r5], #-3072	; 0xfffff400
    39d0:	2d000017 	stccs	0, cr0, [r0, #-92]	; 0xffffffa4
    39d4:	0017c505 	andseq	ip, r7, r5, lsl #10
    39d8:	ab052e00 	blge	14f1e0 <__bss_end+0x144ea4>
    39dc:	2f000019 	svccs	0x00000019
    39e0:	0017e305 	andseq	lr, r7, r5, lsl #6
    39e4:	f2053000 	vhadd.s8	d3, d5, d0
    39e8:	31000017 	tstcc	r0, r7, lsl r0
    39ec:	0015a405 	andseq	sl, r5, r5, lsl #8
    39f0:	fc053200 	stc2	2, cr3, [r5], {-0}
    39f4:	33000018 	movwcc	r0, #24
    39f8:	00190c05 	andseq	r0, r9, r5, lsl #24
    39fc:	1c053400 	cfstrsne	mvf3, [r5], {-0}
    3a00:	35000019 	strcc	r0, [r0, #-25]	; 0xffffffe7
    3a04:	00173205 	andseq	r3, r7, r5, lsl #4
    3a08:	2c053600 	stccs	6, cr3, [r5], {-0}
    3a0c:	37000019 	smladcc	r0, r9, r0, r0
    3a10:	00193c05 	andseq	r3, r9, r5, lsl #24
    3a14:	4c053800 	stcmi	8, cr3, [r5], {-0}
    3a18:	39000019 	stmdbcc	r0, {r0, r3, r4}
    3a1c:	00162305 	andseq	r2, r6, r5, lsl #6
    3a20:	dc053a00 			; <UNDEFINED> instruction: 0xdc053a00
    3a24:	3b000015 	blcc	3a80 <shift+0x3a80>
    3a28:	00180105 	andseq	r0, r8, r5, lsl #2
    3a2c:	7b053c00 	blvc	152a34 <__bss_end+0x1486f8>
    3a30:	3d000015 	stccc	0, cr0, [r0, #-84]	; 0xffffffac
    3a34:	00196705 	andseq	r6, r9, r5, lsl #14
    3a38:	06003e00 	streq	r3, [r0], -r0, lsl #28
    3a3c:	00001663 	andeq	r1, r0, r3, ror #12
    3a40:	026b0202 	rsbeq	r0, fp, #536870912	; 0x20000000
    3a44:	00020e08 	andeq	r0, r2, r8, lsl #28
    3a48:	18260700 	stmdane	r6!, {r8, r9, sl}
    3a4c:	70020000 	andvc	r0, r2, r0
    3a50:	00561402 	subseq	r1, r6, r2, lsl #8
    3a54:	07000000 	streq	r0, [r0, -r0]
    3a58:	0000173f 	andeq	r1, r0, pc, lsr r7
    3a5c:	14027102 	strne	r7, [r2], #-258	; 0xfffffefe
    3a60:	00000056 	andeq	r0, r0, r6, asr r0
    3a64:	e3080001 	movw	r0, #32769	; 0x8001
    3a68:	09000001 	stmdbeq	r0, {r0}
    3a6c:	0000020e 	andeq	r0, r0, lr, lsl #4
    3a70:	00000223 	andeq	r0, r0, r3, lsr #4
    3a74:	0000330a 	andeq	r3, r0, sl, lsl #6
    3a78:	08001100 	stmdaeq	r0, {r8, ip}
    3a7c:	00000213 	andeq	r0, r0, r3, lsl r2
    3a80:	0018ea0b 	andseq	lr, r8, fp, lsl #20
    3a84:	02740200 	rsbseq	r0, r4, #0, 4
    3a88:	00022326 	andeq	r2, r2, r6, lsr #6
    3a8c:	3d3a2400 	cfldrscc	mvf2, [sl, #-0]
    3a90:	3d0f3d0a 	stccc	13, cr3, [pc, #-40]	; 3a70 <shift+0x3a70>
    3a94:	3d323d24 	ldccc	13, cr3, [r2, #-144]!	; 0xffffff70
    3a98:	3d053d02 	stccc	13, cr3, [r5, #-8]
    3a9c:	3d0d3d13 	stccc	13, cr3, [sp, #-76]	; 0xffffffb4
    3aa0:	3d233d0c 	stccc	13, cr3, [r3, #-48]!	; 0xffffffd0
    3aa4:	3d263d11 	stccc	13, cr3, [r6, #-68]!	; 0xffffffbc
    3aa8:	3d173d01 	ldccc	13, cr3, [r7, #-4]
    3aac:	3d093d08 	stccc	13, cr3, [r9, #-32]	; 0xffffffe0
    3ab0:	02020000 	andeq	r0, r2, #0
    3ab4:	000c3107 	andeq	r3, ip, r7, lsl #2
    3ab8:	08010200 	stmdaeq	r1, {r9}
    3abc:	00000b60 	andeq	r0, r0, r0, ror #22
    3ac0:	ec050202 	sfm	f0, 4, [r5], {2}
    3ac4:	0c000009 	stceq	0, cr0, [r0], {9}
    3ac8:	00001b12 	andeq	r1, r0, r2, lsl fp
    3acc:	33168103 	tstcc	r6, #-1073741824	; 0xc0000000
    3ad0:	0c000000 	stceq	0, cr0, [r0], {-0}
    3ad4:	00001b1a 	andeq	r1, r0, sl, lsl fp
    3ad8:	25168503 	ldrcs	r8, [r6, #-1283]	; 0xfffffafd
    3adc:	02000000 	andeq	r0, r0, #0
    3ae0:	15940404 	ldrne	r0, [r4, #1028]	; 0x404
    3ae4:	08020000 	stmdaeq	r2, {}	; <UNPREDICTABLE>
    3ae8:	00158c03 	andseq	r8, r5, r3, lsl #24
    3aec:	04080200 	streq	r0, [r8], #-512	; 0xfffffe00
    3af0:	0000183d 	andeq	r1, r0, sp, lsr r8
    3af4:	8e031002 	cdphi	0, 0, cr1, cr3, cr2, {0}
    3af8:	0d000019 	stceq	0, cr0, [r0, #-100]	; 0xffffff9c
    3afc:	00001bd6 	ldrdeq	r1, [r0], -r6
    3b00:	0103b301 	tsteq	r3, r1, lsl #6
    3b04:	0000027b 	andeq	r0, r0, fp, ror r2
    3b08:	00009de8 	andeq	r9, r0, r8, ror #27
    3b0c:	00000120 	andeq	r0, r0, r0, lsr #2
    3b10:	037d9c01 	cmneq	sp, #256	; 0x100
    3b14:	6e0e0000 	cdpvs	0, 0, cr0, cr14, cr0, {0}
    3b18:	03b30100 			; <UNDEFINED> instruction: 0x03b30100
    3b1c:	00027b17 	andeq	r7, r2, r7, lsl fp
    3b20:	00014900 	andeq	r4, r1, r0, lsl #18
    3b24:	00014500 	andeq	r4, r1, r0, lsl #10
    3b28:	00640e00 	rsbeq	r0, r4, r0, lsl #28
    3b2c:	2203b301 	andcs	fp, r3, #67108864	; 0x4000000
    3b30:	0000027b 	andeq	r0, r0, fp, ror r2
    3b34:	00000175 	andeq	r0, r0, r5, ror r1
    3b38:	00000171 	andeq	r0, r0, r1, ror r1
    3b3c:	0070720f 	rsbseq	r7, r0, pc, lsl #4
    3b40:	2e03b301 	cdpcs	3, 0, cr11, cr3, cr1, {0}
    3b44:	0000037d 	andeq	r0, r0, sp, ror r3
    3b48:	10009102 	andne	r9, r0, r2, lsl #2
    3b4c:	b5010071 	strlt	r0, [r1, #-113]	; 0xffffff8f
    3b50:	027b0b03 	rsbseq	r0, fp, #3072	; 0xc00
    3b54:	01a50000 			; <UNDEFINED> instruction: 0x01a50000
    3b58:	019d0000 	orrseq	r0, sp, r0
    3b5c:	72100000 	andsvc	r0, r0, #0
    3b60:	03b50100 			; <UNDEFINED> instruction: 0x03b50100
    3b64:	00027b12 	andeq	r7, r2, r2, lsl fp
    3b68:	0001fb00 	andeq	pc, r1, r0, lsl #22
    3b6c:	0001f100 	andeq	pc, r1, r0, lsl #2
    3b70:	00791000 	rsbseq	r1, r9, r0
    3b74:	1903b501 	stmdbne	r3, {r0, r8, sl, ip, sp, pc}
    3b78:	0000027b 	andeq	r0, r0, fp, ror r2
    3b7c:	00000259 	andeq	r0, r0, r9, asr r2
    3b80:	00000253 	andeq	r0, r0, r3, asr r2
    3b84:	317a6c10 	cmncc	sl, r0, lsl ip
    3b88:	03b60100 			; <UNDEFINED> instruction: 0x03b60100
    3b8c:	00026f0a 	andeq	r6, r2, sl, lsl #30
    3b90:	00029300 	andeq	r9, r2, r0, lsl #6
    3b94:	00029100 	andeq	r9, r2, r0, lsl #2
    3b98:	7a6c1000 	bvc	1b07ba0 <__bss_end+0x1afd864>
    3b9c:	b6010032 			; <UNDEFINED> instruction: 0xb6010032
    3ba0:	026f0f03 	rsbeq	r0, pc, #3, 30
    3ba4:	02aa0000 	adceq	r0, sl, #0
    3ba8:	02a80000 	adceq	r0, r8, #0
    3bac:	69100000 	ldmdbvs	r0, {}	; <UNPREDICTABLE>
    3bb0:	03b60100 			; <UNDEFINED> instruction: 0x03b60100
    3bb4:	00026f14 	andeq	r6, r2, r4, lsl pc
    3bb8:	0002c900 	andeq	ip, r2, r0, lsl #18
    3bbc:	0002bd00 	andeq	fp, r2, r0, lsl #26
    3bc0:	006b1000 	rsbeq	r1, fp, r0
    3bc4:	1703b601 	strne	fp, [r3, -r1, lsl #12]
    3bc8:	0000026f 	andeq	r0, r0, pc, ror #4
    3bcc:	0000031b 	andeq	r0, r0, fp, lsl r3
    3bd0:	00000317 	andeq	r0, r0, r7, lsl r3
    3bd4:	7b041100 	blvc	107fdc <__bss_end+0xfdca0>
    3bd8:	00000002 	andeq	r0, r0, r2

Disassembly of section .debug_abbrev:

00000000 <.debug_abbrev>:
   0:	10001101 	andne	r1, r0, r1, lsl #2
   4:	12011106 	andne	r1, r1, #-2147483647	; 0x80000001
   8:	1b0e0301 	blne	380c14 <__bss_end+0x3768d8>
   c:	130e250e 	movwne	r2, #58638	; 0xe50e
  10:	00000005 	andeq	r0, r0, r5
  14:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
  18:	030b130e 	movweq	r1, #45838	; 0xb30e
  1c:	110e1b0e 	tstne	lr, lr, lsl #22
  20:	10061201 	andne	r1, r6, r1, lsl #4
  24:	02000017 	andeq	r0, r0, #23
  28:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
  2c:	0b3b0b3a 	bleq	ec2d1c <__bss_end+0xeb89e0>
  30:	13490b39 	movtne	r0, #39737	; 0x9b39
  34:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
  38:	24030000 	strcs	r0, [r3], #-0
  3c:	3e0b0b00 	vmlacc.f64	d0, d11, d0
  40:	000e030b 	andeq	r0, lr, fp, lsl #6
  44:	012e0400 			; <UNDEFINED> instruction: 0x012e0400
  48:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
  4c:	0b3b0b3a 	bleq	ec2d3c <__bss_end+0xeb8a00>
  50:	01110b39 	tsteq	r1, r9, lsr fp
  54:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
  58:	01194296 			; <UNDEFINED> instruction: 0x01194296
  5c:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
  60:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
  64:	0b3b0b3a 	bleq	ec2d54 <__bss_end+0xeb8a18>
  68:	13490b39 	movtne	r0, #39737	; 0x9b39
  6c:	00001802 	andeq	r1, r0, r2, lsl #16
  70:	0b002406 	bleq	9090 <_Z4ftoafPc+0x2c>
  74:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
  78:	07000008 	streq	r0, [r0, -r8]
  7c:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
  80:	0b3a0e03 	bleq	e83894 <__bss_end+0xe79558>
  84:	0b390b3b 	bleq	e42d78 <__bss_end+0xe38a3c>
  88:	06120111 			; <UNDEFINED> instruction: 0x06120111
  8c:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
  90:	00130119 	andseq	r0, r3, r9, lsl r1
  94:	010b0800 	tsteq	fp, r0, lsl #16
  98:	06120111 			; <UNDEFINED> instruction: 0x06120111
  9c:	34090000 	strcc	r0, [r9], #-0
  a0:	3a080300 	bcc	200ca8 <__bss_end+0x1f696c>
  a4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
  a8:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
  ac:	0a000018 	beq	114 <shift+0x114>
  b0:	0b0b000f 	bleq	2c00f4 <__bss_end+0x2b5db8>
  b4:	00001349 	andeq	r1, r0, r9, asr #6
  b8:	01110100 	tsteq	r1, r0, lsl #2
  bc:	0b130e25 	bleq	4c3958 <__bss_end+0x4b961c>
  c0:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
  c4:	06120111 			; <UNDEFINED> instruction: 0x06120111
  c8:	00001710 	andeq	r1, r0, r0, lsl r7
  cc:	03001602 	movweq	r1, #1538	; 0x602
  d0:	3b0b3a0e 	blcc	2ce910 <__bss_end+0x2c45d4>
  d4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
  d8:	03000013 	movweq	r0, #19
  dc:	0b0b000f 	bleq	2c0120 <__bss_end+0x2b5de4>
  e0:	00001349 	andeq	r1, r0, r9, asr #6
  e4:	00001504 	andeq	r1, r0, r4, lsl #10
  e8:	01010500 	tsteq	r1, r0, lsl #10
  ec:	13011349 	movwne	r1, #4937	; 0x1349
  f0:	21060000 	mrscs	r0, (UNDEF: 6)
  f4:	2f134900 	svccs	0x00134900
  f8:	07000006 	streq	r0, [r0, -r6]
  fc:	0b0b0024 	bleq	2c0194 <__bss_end+0x2b5e58>
 100:	0e030b3e 	vmoveq.16	d3[0], r0
 104:	34080000 	strcc	r0, [r8], #-0
 108:	3a0e0300 	bcc	380d10 <__bss_end+0x3769d4>
 10c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 110:	3f13490b 	svccc	0x0013490b
 114:	00193c19 	andseq	r3, r9, r9, lsl ip
 118:	012e0900 			; <UNDEFINED> instruction: 0x012e0900
 11c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 120:	0b3b0b3a 	bleq	ec2e10 <__bss_end+0xeb8ad4>
 124:	13490b39 	movtne	r0, #39737	; 0x9b39
 128:	06120111 			; <UNDEFINED> instruction: 0x06120111
 12c:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 130:	00130119 	andseq	r0, r3, r9, lsl r1
 134:	00340a00 	eorseq	r0, r4, r0, lsl #20
 138:	0b3a0e03 	bleq	e8394c <__bss_end+0xe79610>
 13c:	0b390b3b 	bleq	e42e30 <__bss_end+0xe38af4>
 140:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 144:	240b0000 	strcs	r0, [fp], #-0
 148:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 14c:	0008030b 	andeq	r0, r8, fp, lsl #6
 150:	002e0c00 	eoreq	r0, lr, r0, lsl #24
 154:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 158:	0b3b0b3a 	bleq	ec2e48 <__bss_end+0xeb8b0c>
 15c:	01110b39 	tsteq	r1, r9, lsr fp
 160:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 164:	00194297 	mulseq	r9, r7, r2
 168:	01390d00 	teqeq	r9, r0, lsl #26
 16c:	0b3a0e03 	bleq	e83980 <__bss_end+0xe79644>
 170:	13010b3b 	movwne	r0, #6971	; 0x1b3b
 174:	2e0e0000 	cdpcs	0, 0, cr0, cr14, cr0, {0}
 178:	03193f01 	tsteq	r9, #1, 30
 17c:	3b0b3a0e 	blcc	2ce9bc <__bss_end+0x2c4680>
 180:	3c0b390b 			; <UNDEFINED> instruction: 0x3c0b390b
 184:	00130119 	andseq	r0, r3, r9, lsl r1
 188:	00050f00 	andeq	r0, r5, r0, lsl #30
 18c:	00001349 	andeq	r1, r0, r9, asr #6
 190:	3f012e10 	svccc	0x00012e10
 194:	3a0e0319 	bcc	380e00 <__bss_end+0x376ac4>
 198:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 19c:	3c13490b 			; <UNDEFINED> instruction: 0x3c13490b
 1a0:	11000019 	tstne	r0, r9, lsl r0
 1a4:	1347012e 	movtne	r0, #28974	; 0x712e
 1a8:	06120111 			; <UNDEFINED> instruction: 0x06120111
 1ac:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 1b0:	00130119 	andseq	r0, r3, r9, lsl r1
 1b4:	00051200 	andeq	r1, r5, r0, lsl #4
 1b8:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 1bc:	05130000 	ldreq	r0, [r3, #-0]
 1c0:	3a080300 	bcc	200dc8 <__bss_end+0x1f6a8c>
 1c4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 1c8:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 1cc:	14000018 	strne	r0, [r0], #-24	; 0xffffffe8
 1d0:	1347012e 	movtne	r0, #28974	; 0x712e
 1d4:	06120111 			; <UNDEFINED> instruction: 0x06120111
 1d8:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 1dc:	00000019 	andeq	r0, r0, r9, lsl r0
 1e0:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
 1e4:	030b130e 	movweq	r1, #45838	; 0xb30e
 1e8:	110e1b0e 	tstne	lr, lr, lsl #22
 1ec:	10061201 	andne	r1, r6, r1, lsl #4
 1f0:	02000017 	andeq	r0, r0, #23
 1f4:	0b0b0024 	bleq	2c028c <__bss_end+0x2b5f50>
 1f8:	0e030b3e 	vmoveq.16	d3[0], r0
 1fc:	26030000 	strcs	r0, [r3], -r0
 200:	00134900 	andseq	r4, r3, r0, lsl #18
 204:	00240400 	eoreq	r0, r4, r0, lsl #8
 208:	0b3e0b0b 	bleq	f82e3c <__bss_end+0xf78b00>
 20c:	00000803 	andeq	r0, r0, r3, lsl #16
 210:	03001605 	movweq	r1, #1541	; 0x605
 214:	3b0b3a0e 	blcc	2cea54 <__bss_end+0x2c4718>
 218:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 21c:	06000013 			; <UNDEFINED> instruction: 0x06000013
 220:	0e030113 	mcreq	1, 0, r0, cr3, cr3, {0}
 224:	0b3a0b0b 	bleq	e82e58 <__bss_end+0xe78b1c>
 228:	0b390b3b 	bleq	e42f1c <__bss_end+0xe38be0>
 22c:	00001301 	andeq	r1, r0, r1, lsl #6
 230:	03000d07 	movweq	r0, #3335	; 0xd07
 234:	3b0b3a08 	blcc	2cea5c <__bss_end+0x2c4720>
 238:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 23c:	000b3813 	andeq	r3, fp, r3, lsl r8
 240:	01040800 	tsteq	r4, r0, lsl #16
 244:	196d0e03 	stmdbne	sp!, {r0, r1, r9, sl, fp}^
 248:	0b0b0b3e 	bleq	2c2f48 <__bss_end+0x2b8c0c>
 24c:	0b3a1349 	bleq	e84f78 <__bss_end+0xe7ac3c>
 250:	0b390b3b 	bleq	e42f44 <__bss_end+0xe38c08>
 254:	00001301 	andeq	r1, r0, r1, lsl #6
 258:	03002809 	movweq	r2, #2057	; 0x809
 25c:	000b1c0e 	andeq	r1, fp, lr, lsl #24
 260:	00340a00 	eorseq	r0, r4, r0, lsl #20
 264:	0b3a0e03 	bleq	e83a78 <__bss_end+0xe7973c>
 268:	0b390b3b 	bleq	e42f5c <__bss_end+0xe38c20>
 26c:	196c1349 	stmdbne	ip!, {r0, r3, r6, r8, r9, ip}^
 270:	00001802 	andeq	r1, r0, r2, lsl #16
 274:	0300020b 	movweq	r0, #523	; 0x20b
 278:	00193c0e 	andseq	r3, r9, lr, lsl #24
 27c:	000f0c00 	andeq	r0, pc, r0, lsl #24
 280:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 284:	280d0000 	stmdacs	sp, {}	; <UNPREDICTABLE>
 288:	1c080300 	stcne	3, cr0, [r8], {-0}
 28c:	0e00000b 	cdpeq	0, 0, cr0, cr0, cr11, {0}
 290:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
 294:	0b3b0b3a 	bleq	ec2f84 <__bss_end+0xeb8c48>
 298:	13490b39 	movtne	r0, #39737	; 0x9b39
 29c:	00000b38 	andeq	r0, r0, r8, lsr fp
 2a0:	4901010f 	stmdbmi	r1, {r0, r1, r2, r3, r8}
 2a4:	00130113 	andseq	r0, r3, r3, lsl r1
 2a8:	00211000 	eoreq	r1, r1, r0
 2ac:	0b2f1349 	bleq	bc4fd8 <__bss_end+0xbbac9c>
 2b0:	02110000 	andseq	r0, r1, #0
 2b4:	0b0e0301 	bleq	380ec0 <__bss_end+0x376b84>
 2b8:	3b0b3a0b 	blcc	2ceaec <__bss_end+0x2c47b0>
 2bc:	010b390b 	tsteq	fp, fp, lsl #18
 2c0:	12000013 	andne	r0, r0, #19
 2c4:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 2c8:	0b3a0e03 	bleq	e83adc <__bss_end+0xe797a0>
 2cc:	0b390b3b 	bleq	e42fc0 <__bss_end+0xe38c84>
 2d0:	193c0e6e 	ldmdbne	ip!, {r1, r2, r3, r5, r6, r9, sl, fp}
 2d4:	13011364 	movwne	r1, #4964	; 0x1364
 2d8:	05130000 	ldreq	r0, [r3, #-0]
 2dc:	34134900 	ldrcc	r4, [r3], #-2304	; 0xfffff700
 2e0:	14000019 	strne	r0, [r0], #-25	; 0xffffffe7
 2e4:	13490005 	movtne	r0, #36869	; 0x9005
 2e8:	2e150000 	cdpcs	0, 1, cr0, cr5, cr0, {0}
 2ec:	03193f01 	tsteq	r9, #1, 30
 2f0:	3b0b3a0e 	blcc	2ceb30 <__bss_end+0x2c47f4>
 2f4:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 2f8:	3c13490e 			; <UNDEFINED> instruction: 0x3c13490e
 2fc:	01136419 	tsteq	r3, r9, lsl r4
 300:	16000013 			; <UNDEFINED> instruction: 0x16000013
 304:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 308:	0b3a0e03 	bleq	e83b1c <__bss_end+0xe797e0>
 30c:	0b390b3b 	bleq	e43000 <__bss_end+0xe38cc4>
 310:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 314:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 318:	13011364 	movwne	r1, #4964	; 0x1364
 31c:	0d170000 	ldceq	0, cr0, [r7, #-0]
 320:	3a0e0300 	bcc	380f28 <__bss_end+0x376bec>
 324:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 328:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 32c:	000b320b 	andeq	r3, fp, fp, lsl #4
 330:	012e1800 			; <UNDEFINED> instruction: 0x012e1800
 334:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 338:	0b3b0b3a 	bleq	ec3028 <__bss_end+0xeb8cec>
 33c:	0e6e0b39 	vmoveq.8	d14[5], r0
 340:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 344:	13011364 	movwne	r1, #4964	; 0x1364
 348:	2e190000 	cdpcs	0, 1, cr0, cr9, cr0, {0}
 34c:	03193f01 	tsteq	r9, #1, 30
 350:	3b0b3a0e 	blcc	2ceb90 <__bss_end+0x2c4854>
 354:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 358:	3213490e 	andscc	r4, r3, #229376	; 0x38000
 35c:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
 360:	1a000013 	bne	3b4 <shift+0x3b4>
 364:	13490115 	movtne	r0, #37141	; 0x9115
 368:	13011364 	movwne	r1, #4964	; 0x1364
 36c:	1f1b0000 	svcne	0x001b0000
 370:	49131d00 	ldmdbmi	r3, {r8, sl, fp, ip}
 374:	1c000013 	stcne	0, cr0, [r0], {19}
 378:	0b0b0010 	bleq	2c03c0 <__bss_end+0x2b6084>
 37c:	00001349 	andeq	r1, r0, r9, asr #6
 380:	0b000f1d 	bleq	3ffc <shift+0x3ffc>
 384:	1e00000b 	cdpne	0, 0, cr0, cr0, cr11, {0}
 388:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 38c:	0b3a0e03 	bleq	e83ba0 <__bss_end+0xe79864>
 390:	0b390b3b 	bleq	e43084 <__bss_end+0xe38d48>
 394:	0b320e6e 	bleq	c83d54 <__bss_end+0xc79a18>
 398:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 39c:	391f0000 	ldmdbcc	pc, {}	; <UNPREDICTABLE>
 3a0:	3a080301 	bcc	200fac <__bss_end+0x1f6c70>
 3a4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 3a8:	0013010b 	andseq	r0, r3, fp, lsl #2
 3ac:	00342000 	eorseq	r2, r4, r0
 3b0:	0b3a0e03 	bleq	e83bc4 <__bss_end+0xe79888>
 3b4:	0b390b3b 	bleq	e430a8 <__bss_end+0xe38d6c>
 3b8:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
 3bc:	196c061c 	stmdbne	ip!, {r2, r3, r4, r9, sl}^
 3c0:	34210000 	strtcc	r0, [r1], #-0
 3c4:	3a0e0300 	bcc	380fcc <__bss_end+0x376c90>
 3c8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 3cc:	3c13490b 			; <UNDEFINED> instruction: 0x3c13490b
 3d0:	6c0b1c19 	stcvs	12, cr1, [fp], {25}
 3d4:	22000019 	andcs	r0, r0, #25
 3d8:	13470034 	movtne	r0, #28724	; 0x7034
 3dc:	34230000 	strtcc	r0, [r3], #-0
 3e0:	3a0e0300 	bcc	380fe8 <__bss_end+0x376cac>
 3e4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 3e8:	3f13490b 	svccc	0x0013490b
 3ec:	00180219 	andseq	r0, r8, r9, lsl r2
 3f0:	012e2400 			; <UNDEFINED> instruction: 0x012e2400
 3f4:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 3f8:	0b3b0b3a 	bleq	ec30e8 <__bss_end+0xeb8dac>
 3fc:	13490b39 	movtne	r0, #39737	; 0x9b39
 400:	06120111 			; <UNDEFINED> instruction: 0x06120111
 404:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 408:	00130119 	andseq	r0, r3, r9, lsl r1
 40c:	00052500 	andeq	r2, r5, r0, lsl #10
 410:	0b3a0e03 	bleq	e83c24 <__bss_end+0xe798e8>
 414:	0b390b3b 	bleq	e43108 <__bss_end+0xe38dcc>
 418:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 41c:	34260000 	strtcc	r0, [r6], #-0
 420:	3a0e0300 	bcc	381028 <__bss_end+0x376cec>
 424:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 428:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 42c:	27000018 	smladcs	r0, r8, r0, r0
 430:	0e03012e 	adfeqsp	f0, f3, #0.5
 434:	0b3b0b3a 	bleq	ec3124 <__bss_end+0xeb8de8>
 438:	01110b39 	tsteq	r1, r9, lsr fp
 43c:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 440:	00194296 	mulseq	r9, r6, r2
 444:	11010000 	mrsne	r0, (UNDEF: 1)
 448:	130e2501 	movwne	r2, #58625	; 0xe501
 44c:	1b0e030b 	blne	381080 <__bss_end+0x376d44>
 450:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 454:	00171006 	andseq	r1, r7, r6
 458:	00240200 	eoreq	r0, r4, r0, lsl #4
 45c:	0b3e0b0b 	bleq	f83090 <__bss_end+0xf78d54>
 460:	00000e03 	andeq	r0, r0, r3, lsl #28
 464:	49002603 	stmdbmi	r0, {r0, r1, r9, sl, sp}
 468:	04000013 	streq	r0, [r0], #-19	; 0xffffffed
 46c:	0b0b0024 	bleq	2c0504 <__bss_end+0x2b61c8>
 470:	08030b3e 	stmdaeq	r3, {r1, r2, r3, r4, r5, r8, r9, fp}
 474:	16050000 	strne	r0, [r5], -r0
 478:	3a0e0300 	bcc	381080 <__bss_end+0x376d44>
 47c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 480:	0013490b 	andseq	r4, r3, fp, lsl #18
 484:	01130600 	tsteq	r3, r0, lsl #12
 488:	0b0b0e03 	bleq	2c3c9c <__bss_end+0x2b9960>
 48c:	0b3b0b3a 	bleq	ec317c <__bss_end+0xeb8e40>
 490:	13010b39 	movwne	r0, #6969	; 0x1b39
 494:	0d070000 	stceq	0, cr0, [r7, #-0]
 498:	3a080300 	bcc	2010a0 <__bss_end+0x1f6d64>
 49c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 4a0:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 4a4:	0800000b 	stmdaeq	r0, {r0, r1, r3}
 4a8:	0e030104 	adfeqs	f0, f3, f4
 4ac:	0b3e196d 	bleq	f86a68 <__bss_end+0xf7c72c>
 4b0:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 4b4:	0b3b0b3a 	bleq	ec31a4 <__bss_end+0xeb8e68>
 4b8:	13010b39 	movwne	r0, #6969	; 0x1b39
 4bc:	28090000 	stmdacs	r9, {}	; <UNPREDICTABLE>
 4c0:	1c080300 	stcne	3, cr0, [r8], {-0}
 4c4:	0a00000b 	beq	4f8 <shift+0x4f8>
 4c8:	0e030028 	cdpeq	0, 0, cr0, cr3, cr8, {1}
 4cc:	00000b1c 	andeq	r0, r0, ip, lsl fp
 4d0:	0300340b 	movweq	r3, #1035	; 0x40b
 4d4:	3b0b3a0e 	blcc	2ced14 <__bss_end+0x2c49d8>
 4d8:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 4dc:	02196c13 	andseq	r6, r9, #4864	; 0x1300
 4e0:	0c000018 	stceq	0, cr0, [r0], {24}
 4e4:	0e030002 	cdpeq	0, 0, cr0, cr3, cr2, {0}
 4e8:	0000193c 	andeq	r1, r0, ip, lsr r9
 4ec:	0b000f0d 	bleq	4128 <shift+0x4128>
 4f0:	0013490b 	andseq	r4, r3, fp, lsl #18
 4f4:	000d0e00 	andeq	r0, sp, r0, lsl #28
 4f8:	0b3a0e03 	bleq	e83d0c <__bss_end+0xe799d0>
 4fc:	0b390b3b 	bleq	e431f0 <__bss_end+0xe38eb4>
 500:	0b381349 	bleq	e0522c <__bss_end+0xdfaef0>
 504:	010f0000 	mrseq	r0, CPSR
 508:	01134901 	tsteq	r3, r1, lsl #18
 50c:	10000013 	andne	r0, r0, r3, lsl r0
 510:	13490021 	movtne	r0, #36897	; 0x9021
 514:	00000b2f 	andeq	r0, r0, pc, lsr #22
 518:	03010211 	movweq	r0, #4625	; 0x1211
 51c:	3a0b0b0e 	bcc	2c315c <__bss_end+0x2b8e20>
 520:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 524:	0013010b 	andseq	r0, r3, fp, lsl #2
 528:	012e1200 			; <UNDEFINED> instruction: 0x012e1200
 52c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 530:	0b3b0b3a 	bleq	ec3220 <__bss_end+0xeb8ee4>
 534:	0e6e0b39 	vmoveq.8	d14[5], r0
 538:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 53c:	00001301 	andeq	r1, r0, r1, lsl #6
 540:	49000513 	stmdbmi	r0, {r0, r1, r4, r8, sl}
 544:	00193413 	andseq	r3, r9, r3, lsl r4
 548:	00051400 	andeq	r1, r5, r0, lsl #8
 54c:	00001349 	andeq	r1, r0, r9, asr #6
 550:	3f012e15 	svccc	0x00012e15
 554:	3a0e0319 	bcc	3811c0 <__bss_end+0x376e84>
 558:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 55c:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 560:	64193c13 	ldrvs	r3, [r9], #-3091	; 0xfffff3ed
 564:	00130113 	andseq	r0, r3, r3, lsl r1
 568:	012e1600 			; <UNDEFINED> instruction: 0x012e1600
 56c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 570:	0b3b0b3a 	bleq	ec3260 <__bss_end+0xeb8f24>
 574:	0e6e0b39 	vmoveq.8	d14[5], r0
 578:	0b321349 	bleq	c852a4 <__bss_end+0xc7af68>
 57c:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 580:	00001301 	andeq	r1, r0, r1, lsl #6
 584:	03000d17 	movweq	r0, #3351	; 0xd17
 588:	3b0b3a0e 	blcc	2cedc8 <__bss_end+0x2c4a8c>
 58c:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 590:	320b3813 	andcc	r3, fp, #1245184	; 0x130000
 594:	1800000b 	stmdane	r0, {r0, r1, r3}
 598:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 59c:	0b3a0e03 	bleq	e83db0 <__bss_end+0xe79a74>
 5a0:	0b390b3b 	bleq	e43294 <__bss_end+0xe38f58>
 5a4:	0b320e6e 	bleq	c83f64 <__bss_end+0xc79c28>
 5a8:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 5ac:	00001301 	andeq	r1, r0, r1, lsl #6
 5b0:	3f012e19 	svccc	0x00012e19
 5b4:	3a0e0319 	bcc	381220 <__bss_end+0x376ee4>
 5b8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 5bc:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 5c0:	3c0b3213 	sfmcc	f3, 4, [fp], {19}
 5c4:	00136419 	andseq	r6, r3, r9, lsl r4
 5c8:	01151a00 	tsteq	r5, r0, lsl #20
 5cc:	13641349 	cmnne	r4, #603979777	; 0x24000001
 5d0:	00001301 	andeq	r1, r0, r1, lsl #6
 5d4:	1d001f1b 	stcne	15, cr1, [r0, #-108]	; 0xffffff94
 5d8:	00134913 	andseq	r4, r3, r3, lsl r9
 5dc:	00101c00 	andseq	r1, r0, r0, lsl #24
 5e0:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 5e4:	0f1d0000 	svceq	0x001d0000
 5e8:	000b0b00 	andeq	r0, fp, r0, lsl #22
 5ec:	00341e00 	eorseq	r1, r4, r0, lsl #28
 5f0:	0b3a0e03 	bleq	e83e04 <__bss_end+0xe79ac8>
 5f4:	0b390b3b 	bleq	e432e8 <__bss_end+0xe38fac>
 5f8:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 5fc:	2e1f0000 	cdpcs	0, 1, cr0, cr15, cr0, {0}
 600:	03193f01 	tsteq	r9, #1, 30
 604:	3b0b3a0e 	blcc	2cee44 <__bss_end+0x2c4b08>
 608:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 60c:	1113490e 	tstne	r3, lr, lsl #18
 610:	40061201 	andmi	r1, r6, r1, lsl #4
 614:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
 618:	00001301 	andeq	r1, r0, r1, lsl #6
 61c:	03000520 	movweq	r0, #1312	; 0x520
 620:	3b0b3a0e 	blcc	2cee60 <__bss_end+0x2c4b24>
 624:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 628:	00180213 	andseq	r0, r8, r3, lsl r2
 62c:	012e2100 			; <UNDEFINED> instruction: 0x012e2100
 630:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 634:	0b3b0b3a 	bleq	ec3324 <__bss_end+0xeb8fe8>
 638:	0e6e0b39 	vmoveq.8	d14[5], r0
 63c:	01111349 	tsteq	r1, r9, asr #6
 640:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 644:	01194297 			; <UNDEFINED> instruction: 0x01194297
 648:	22000013 	andcs	r0, r0, #19
 64c:	08030034 	stmdaeq	r3, {r2, r4, r5}
 650:	0b3b0b3a 	bleq	ec3340 <__bss_end+0xeb9004>
 654:	13490b39 	movtne	r0, #39737	; 0x9b39
 658:	00001802 	andeq	r1, r0, r2, lsl #16
 65c:	3f012e23 	svccc	0x00012e23
 660:	3a0e0319 	bcc	3812cc <__bss_end+0x376f90>
 664:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 668:	110e6e0b 	tstne	lr, fp, lsl #28
 66c:	40061201 	andmi	r1, r6, r1, lsl #4
 670:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
 674:	00001301 	andeq	r1, r0, r1, lsl #6
 678:	3f002e24 	svccc	0x00002e24
 67c:	3a0e0319 	bcc	3812e8 <__bss_end+0x376fac>
 680:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 684:	110e6e0b 	tstne	lr, fp, lsl #28
 688:	40061201 	andmi	r1, r6, r1, lsl #4
 68c:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
 690:	2e250000 	cdpcs	0, 2, cr0, cr5, cr0, {0}
 694:	03193f01 	tsteq	r9, #1, 30
 698:	3b0b3a0e 	blcc	2ceed8 <__bss_end+0x2c4b9c>
 69c:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 6a0:	1113490e 	tstne	r3, lr, lsl #18
 6a4:	40061201 	andmi	r1, r6, r1, lsl #4
 6a8:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
 6ac:	01000000 	mrseq	r0, (UNDEF: 0)
 6b0:	0e250111 	mcreq	1, 1, r0, cr5, cr1, {0}
 6b4:	0e030b13 	vmoveq.32	d3[0], r0
 6b8:	01110e1b 	tsteq	r1, fp, lsl lr
 6bc:	17100612 			; <UNDEFINED> instruction: 0x17100612
 6c0:	39020000 	stmdbcc	r2, {}	; <UNPREDICTABLE>
 6c4:	00130101 	andseq	r0, r3, r1, lsl #2
 6c8:	00340300 	eorseq	r0, r4, r0, lsl #6
 6cc:	0b3a0e03 	bleq	e83ee0 <__bss_end+0xe79ba4>
 6d0:	0b390b3b 	bleq	e433c4 <__bss_end+0xe39088>
 6d4:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
 6d8:	00000a1c 	andeq	r0, r0, ip, lsl sl
 6dc:	3a003a04 	bcc	eef4 <__bss_end+0x4bb8>
 6e0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 6e4:	0013180b 	andseq	r1, r3, fp, lsl #16
 6e8:	01010500 	tsteq	r1, r0, lsl #10
 6ec:	13011349 	movwne	r1, #4937	; 0x1349
 6f0:	21060000 	mrscs	r0, (UNDEF: 6)
 6f4:	2f134900 	svccs	0x00134900
 6f8:	0700000b 	streq	r0, [r0, -fp]
 6fc:	13490026 	movtne	r0, #36902	; 0x9026
 700:	24080000 	strcs	r0, [r8], #-0
 704:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 708:	000e030b 	andeq	r0, lr, fp, lsl #6
 70c:	00340900 	eorseq	r0, r4, r0, lsl #18
 710:	00001347 	andeq	r1, r0, r7, asr #6
 714:	3f012e0a 	svccc	0x00012e0a
 718:	3a0e0319 	bcc	381384 <__bss_end+0x377048>
 71c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 720:	110e6e0b 	tstne	lr, fp, lsl #28
 724:	40061201 	andmi	r1, r6, r1, lsl #4
 728:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
 72c:	00001301 	andeq	r1, r0, r1, lsl #6
 730:	0300050b 	movweq	r0, #1291	; 0x50b
 734:	3b0b3a08 	blcc	2cef5c <__bss_end+0x2c4c20>
 738:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 73c:	00180213 	andseq	r0, r8, r3, lsl r2
 740:	00340c00 	eorseq	r0, r4, r0, lsl #24
 744:	0b3a0e03 	bleq	e83f58 <__bss_end+0xe79c1c>
 748:	0b390b3b 	bleq	e4343c <__bss_end+0xe39100>
 74c:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 750:	340d0000 	strcc	r0, [sp], #-0
 754:	3a080300 	bcc	20135c <__bss_end+0x1f7020>
 758:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 75c:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 760:	0e000018 	mcreq	0, 0, r0, cr0, cr8, {0}
 764:	0b0b000f 	bleq	2c07a8 <__bss_end+0x2b646c>
 768:	00001349 	andeq	r1, r0, r9, asr #6
 76c:	3f012e0f 	svccc	0x00012e0f
 770:	3a0e0319 	bcc	3813dc <__bss_end+0x3770a0>
 774:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 778:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 77c:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
 780:	97184006 	ldrls	r4, [r8, -r6]
 784:	13011942 	movwne	r1, #6466	; 0x1942
 788:	05100000 	ldreq	r0, [r0, #-0]
 78c:	3a0e0300 	bcc	381394 <__bss_end+0x377058>
 790:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 794:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 798:	11000018 	tstne	r0, r8, lsl r0
 79c:	0b0b0024 	bleq	2c0834 <__bss_end+0x2b64f8>
 7a0:	08030b3e 	stmdaeq	r3, {r1, r2, r3, r4, r5, r8, r9, fp}
 7a4:	2e120000 	cdpcs	0, 1, cr0, cr2, cr0, {0}
 7a8:	03193f01 	tsteq	r9, #1, 30
 7ac:	3b0b3a0e 	blcc	2cefec <__bss_end+0x2c4cb0>
 7b0:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 7b4:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 7b8:	97184006 	ldrls	r4, [r8, -r6]
 7bc:	13011942 	movwne	r1, #6466	; 0x1942
 7c0:	0b130000 	bleq	4c07c8 <__bss_end+0x4b648c>
 7c4:	12011101 	andne	r1, r1, #1073741824	; 0x40000000
 7c8:	14000006 	strne	r0, [r0], #-6
 7cc:	00000026 	andeq	r0, r0, r6, lsr #32
 7d0:	0b000f15 	bleq	442c <shift+0x442c>
 7d4:	1600000b 	strne	r0, [r0], -fp
 7d8:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 7dc:	0b3a0e03 	bleq	e83ff0 <__bss_end+0xe79cb4>
 7e0:	0b390b3b 	bleq	e434d4 <__bss_end+0xe39198>
 7e4:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 7e8:	06120111 			; <UNDEFINED> instruction: 0x06120111
 7ec:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 7f0:	00130119 	andseq	r0, r3, r9, lsl r1
 7f4:	012e1700 			; <UNDEFINED> instruction: 0x012e1700
 7f8:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 7fc:	0b3b0b3a 	bleq	ec34ec <__bss_end+0xeb91b0>
 800:	0e6e0b39 	vmoveq.8	d14[5], r0
 804:	06120111 			; <UNDEFINED> instruction: 0x06120111
 808:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 80c:	00000019 	andeq	r0, r0, r9, lsl r0
 810:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
 814:	030b130e 	movweq	r1, #45838	; 0xb30e
 818:	110e1b0e 	tstne	lr, lr, lsl #22
 81c:	10061201 	andne	r1, r6, r1, lsl #4
 820:	02000017 	andeq	r0, r0, #23
 824:	0b0b0024 	bleq	2c08bc <__bss_end+0x2b6580>
 828:	0e030b3e 	vmoveq.16	d3[0], r0
 82c:	26030000 	strcs	r0, [r3], -r0
 830:	00134900 	andseq	r4, r3, r0, lsl #18
 834:	00240400 	eoreq	r0, r4, r0, lsl #8
 838:	0b3e0b0b 	bleq	f8346c <__bss_end+0xf79130>
 83c:	00000803 	andeq	r0, r0, r3, lsl #16
 840:	03001605 	movweq	r1, #1541	; 0x605
 844:	3b0b3a0e 	blcc	2cf084 <__bss_end+0x2c4d48>
 848:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 84c:	06000013 			; <UNDEFINED> instruction: 0x06000013
 850:	0e030102 	adfeqs	f0, f3, f2
 854:	0b3a0b0b 	bleq	e83488 <__bss_end+0xe7914c>
 858:	0b390b3b 	bleq	e4354c <__bss_end+0xe39210>
 85c:	00001301 	andeq	r1, r0, r1, lsl #6
 860:	03000d07 	movweq	r0, #3335	; 0xd07
 864:	3b0b3a0e 	blcc	2cf0a4 <__bss_end+0x2c4d68>
 868:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 86c:	000b3813 	andeq	r3, fp, r3, lsl r8
 870:	012e0800 			; <UNDEFINED> instruction: 0x012e0800
 874:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 878:	0b3b0b3a 	bleq	ec3568 <__bss_end+0xeb922c>
 87c:	0e6e0b39 	vmoveq.8	d14[5], r0
 880:	0b321349 	bleq	c855ac <__bss_end+0xc7b270>
 884:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 888:	00001301 	andeq	r1, r0, r1, lsl #6
 88c:	49000509 	stmdbmi	r0, {r0, r3, r8, sl}
 890:	00193413 	andseq	r3, r9, r3, lsl r4
 894:	00050a00 	andeq	r0, r5, r0, lsl #20
 898:	00001349 	andeq	r1, r0, r9, asr #6
 89c:	3f012e0b 	svccc	0x00012e0b
 8a0:	3a0e0319 	bcc	38150c <__bss_end+0x3771d0>
 8a4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 8a8:	320e6e0b 	andcc	r6, lr, #11, 28	; 0xb0
 8ac:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
 8b0:	00130113 	andseq	r0, r3, r3, lsl r1
 8b4:	012e0c00 			; <UNDEFINED> instruction: 0x012e0c00
 8b8:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 8bc:	0b3b0b3a 	bleq	ec35ac <__bss_end+0xeb9270>
 8c0:	0e6e0b39 	vmoveq.8	d14[5], r0
 8c4:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 8c8:	00001364 	andeq	r1, r0, r4, ror #6
 8cc:	0b000f0d 	bleq	4508 <shift+0x4508>
 8d0:	0013490b 	andseq	r4, r3, fp, lsl #18
 8d4:	000f0e00 	andeq	r0, pc, r0, lsl #28
 8d8:	00000b0b 	andeq	r0, r0, fp, lsl #22
 8dc:	0301130f 	movweq	r1, #4879	; 0x130f
 8e0:	3a0b0b0e 	bcc	2c3520 <__bss_end+0x2b91e4>
 8e4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 8e8:	0013010b 	andseq	r0, r3, fp, lsl #2
 8ec:	000d1000 	andeq	r1, sp, r0
 8f0:	0b3a0803 	bleq	e82904 <__bss_end+0xe785c8>
 8f4:	0b390b3b 	bleq	e435e8 <__bss_end+0xe392ac>
 8f8:	0b381349 	bleq	e05624 <__bss_end+0xdfb2e8>
 8fc:	04110000 	ldreq	r0, [r1], #-0
 900:	6d0e0301 	stcvs	3, cr0, [lr, #-4]
 904:	0b0b3e19 	bleq	2d0170 <__bss_end+0x2c5e34>
 908:	3a13490b 	bcc	4d2d3c <__bss_end+0x4c8a00>
 90c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 910:	0013010b 	andseq	r0, r3, fp, lsl #2
 914:	00281200 	eoreq	r1, r8, r0, lsl #4
 918:	0b1c0e03 	bleq	70412c <__bss_end+0x6f9df0>
 91c:	34130000 	ldrcc	r0, [r3], #-0
 920:	3a0e0300 	bcc	381528 <__bss_end+0x3771ec>
 924:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 928:	6c13490b 			; <UNDEFINED> instruction: 0x6c13490b
 92c:	00180219 	andseq	r0, r8, r9, lsl r2
 930:	00021400 	andeq	r1, r2, r0, lsl #8
 934:	193c0e03 	ldmdbne	ip!, {r0, r1, r9, sl, fp}
 938:	28150000 	ldmdacs	r5, {}	; <UNPREDICTABLE>
 93c:	1c080300 	stcne	3, cr0, [r8], {-0}
 940:	1600000b 	strne	r0, [r0], -fp
 944:	13490101 	movtne	r0, #37121	; 0x9101
 948:	00001301 	andeq	r1, r0, r1, lsl #6
 94c:	49002117 	stmdbmi	r0, {r0, r1, r2, r4, r8, sp}
 950:	000b2f13 	andeq	r2, fp, r3, lsl pc
 954:	012e1800 			; <UNDEFINED> instruction: 0x012e1800
 958:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 95c:	0b3b0b3a 	bleq	ec364c <__bss_end+0xeb9310>
 960:	0e6e0b39 	vmoveq.8	d14[5], r0
 964:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 968:	00001301 	andeq	r1, r0, r1, lsl #6
 96c:	3f012e19 	svccc	0x00012e19
 970:	3a0e0319 	bcc	3815dc <__bss_end+0x3772a0>
 974:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 978:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 97c:	64193c13 	ldrvs	r3, [r9], #-3091	; 0xfffff3ed
 980:	00130113 	andseq	r0, r3, r3, lsl r1
 984:	000d1a00 	andeq	r1, sp, r0, lsl #20
 988:	0b3a0e03 	bleq	e8419c <__bss_end+0xe79e60>
 98c:	0b390b3b 	bleq	e43680 <__bss_end+0xe39344>
 990:	0b381349 	bleq	e056bc <__bss_end+0xdfb380>
 994:	00000b32 	andeq	r0, r0, r2, lsr fp
 998:	3f012e1b 	svccc	0x00012e1b
 99c:	3a0e0319 	bcc	381608 <__bss_end+0x3772cc>
 9a0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 9a4:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 9a8:	3c0b3213 	sfmcc	f3, 4, [fp], {19}
 9ac:	00136419 	andseq	r6, r3, r9, lsl r4
 9b0:	01151c00 	tsteq	r5, r0, lsl #24
 9b4:	13641349 	cmnne	r4, #603979777	; 0x24000001
 9b8:	00001301 	andeq	r1, r0, r1, lsl #6
 9bc:	1d001f1d 	stcne	15, cr1, [r0, #-116]	; 0xffffff8c
 9c0:	00134913 	andseq	r4, r3, r3, lsl r9
 9c4:	00101e00 	andseq	r1, r0, r0, lsl #28
 9c8:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 9cc:	391f0000 	ldmdbcc	pc, {}	; <UNPREDICTABLE>
 9d0:	3a080301 	bcc	2015dc <__bss_end+0x1f72a0>
 9d4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 9d8:	0013010b 	andseq	r0, r3, fp, lsl #2
 9dc:	00342000 	eorseq	r2, r4, r0
 9e0:	0b3a0e03 	bleq	e841f4 <__bss_end+0xe79eb8>
 9e4:	0b390b3b 	bleq	e436d8 <__bss_end+0xe3939c>
 9e8:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
 9ec:	196c061c 	stmdbne	ip!, {r2, r3, r4, r9, sl}^
 9f0:	34210000 	strtcc	r0, [r1], #-0
 9f4:	3a0e0300 	bcc	3815fc <__bss_end+0x3772c0>
 9f8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 9fc:	3c13490b 			; <UNDEFINED> instruction: 0x3c13490b
 a00:	6c0b1c19 	stcvs	12, cr1, [fp], {25}
 a04:	22000019 	andcs	r0, r0, #25
 a08:	13470034 	movtne	r0, #28724	; 0x7034
 a0c:	39230000 	stmdbcc	r3!, {}	; <UNPREDICTABLE>
 a10:	3a0e0301 	bcc	38161c <__bss_end+0x3772e0>
 a14:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 a18:	0013010b 	andseq	r0, r3, fp, lsl #2
 a1c:	00342400 	eorseq	r2, r4, r0, lsl #8
 a20:	0b3a0e03 	bleq	e84234 <__bss_end+0xe79ef8>
 a24:	0b390b3b 	bleq	e43718 <__bss_end+0xe393dc>
 a28:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
 a2c:	0000031c 	andeq	r0, r0, ip, lsl r3
 a30:	49002125 	stmdbmi	r0, {r0, r2, r5, r8, sp}
 a34:	00052f13 	andeq	r2, r5, r3, lsl pc
 a38:	012e2600 			; <UNDEFINED> instruction: 0x012e2600
 a3c:	0b3a1347 	bleq	e85760 <__bss_end+0xe7b424>
 a40:	0b390b3b 	bleq	e43734 <__bss_end+0xe393f8>
 a44:	01111364 	tsteq	r1, r4, ror #6
 a48:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 a4c:	01194296 			; <UNDEFINED> instruction: 0x01194296
 a50:	27000013 	smladcs	r0, r3, r0, r0
 a54:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
 a58:	19341349 	ldmdbne	r4!, {r0, r3, r6, r8, r9, ip}
 a5c:	00001802 	andeq	r1, r0, r2, lsl #16
 a60:	03000528 	movweq	r0, #1320	; 0x528
 a64:	3b0b3a08 	blcc	2cf28c <__bss_end+0x2c4f50>
 a68:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 a6c:	00180213 	andseq	r0, r8, r3, lsl r2
 a70:	00342900 	eorseq	r2, r4, r0, lsl #18
 a74:	0b3a0803 	bleq	e82a88 <__bss_end+0xe7874c>
 a78:	0b390b3b 	bleq	e4376c <__bss_end+0xe39430>
 a7c:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 a80:	052a0000 	streq	r0, [sl, #-0]!
 a84:	3a0e0300 	bcc	38168c <__bss_end+0x377350>
 a88:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 a8c:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 a90:	2b000018 	blcs	af8 <shift+0xaf8>
 a94:	1347012e 	movtne	r0, #28974	; 0x712e
 a98:	0b3b0b3a 	bleq	ec3788 <__bss_end+0xeb944c>
 a9c:	13640b39 	cmnne	r4, #58368	; 0xe400
 aa0:	06120111 			; <UNDEFINED> instruction: 0x06120111
 aa4:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 aa8:	00130119 	andseq	r0, r3, r9, lsl r1
 aac:	012e2c00 			; <UNDEFINED> instruction: 0x012e2c00
 ab0:	0b3a1347 	bleq	e857d4 <__bss_end+0xe7b498>
 ab4:	0b390b3b 	bleq	e437a8 <__bss_end+0xe3946c>
 ab8:	13641349 	cmnne	r4, #603979777	; 0x24000001
 abc:	13010b20 	movwne	r0, #6944	; 0x1b20
 ac0:	052d0000 	streq	r0, [sp, #-0]!
 ac4:	490e0300 	stmdbmi	lr, {r8, r9}
 ac8:	00193413 	andseq	r3, r9, r3, lsl r4
 acc:	012e2e00 			; <UNDEFINED> instruction: 0x012e2e00
 ad0:	0e6e1331 	mcreq	3, 3, r1, cr14, cr1, {1}
 ad4:	01111364 	tsteq	r1, r4, ror #6
 ad8:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 adc:	01194296 			; <UNDEFINED> instruction: 0x01194296
 ae0:	2f000013 	svccs	0x00000013
 ae4:	13310005 	teqne	r1, #5
 ae8:	00001802 	andeq	r1, r0, r2, lsl #16
 aec:	47012e30 	smladxmi	r1, r0, lr, r2
 af0:	3b0b3a13 	blcc	2cf344 <__bss_end+0x2c5008>
 af4:	640b390b 	strvs	r3, [fp], #-2315	; 0xfffff6f5
 af8:	010b2013 	tsteq	fp, r3, lsl r0
 afc:	31000013 	tstcc	r0, r3, lsl r0
 b00:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
 b04:	0b3b0b3a 	bleq	ec37f4 <__bss_end+0xeb94b8>
 b08:	13490b39 	movtne	r0, #39737	; 0x9b39
 b0c:	2e320000 	cdpcs	0, 3, cr0, cr2, cr0, {0}
 b10:	6e133101 	mufvss	f3, f3, f1
 b14:	1113640e 	tstne	r3, lr, lsl #8
 b18:	40061201 	andmi	r1, r6, r1, lsl #4
 b1c:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
 b20:	01000000 	mrseq	r0, (UNDEF: 0)
 b24:	06100011 			; <UNDEFINED> instruction: 0x06100011
 b28:	01120111 	tsteq	r2, r1, lsl r1
 b2c:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
 b30:	05130e25 	ldreq	r0, [r3, #-3621]	; 0xfffff1db
 b34:	01000000 	mrseq	r0, (UNDEF: 0)
 b38:	06100011 			; <UNDEFINED> instruction: 0x06100011
 b3c:	01120111 	tsteq	r2, r1, lsl r1
 b40:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
 b44:	05130e25 	ldreq	r0, [r3, #-3621]	; 0xfffff1db
 b48:	01000000 	mrseq	r0, (UNDEF: 0)
 b4c:	06100011 			; <UNDEFINED> instruction: 0x06100011
 b50:	01120111 	tsteq	r2, r1, lsl r1
 b54:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
 b58:	05130e25 	ldreq	r0, [r3, #-3621]	; 0xfffff1db
 b5c:	01000000 	mrseq	r0, (UNDEF: 0)
 b60:	06100011 			; <UNDEFINED> instruction: 0x06100011
 b64:	01120111 	tsteq	r2, r1, lsl r1
 b68:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
 b6c:	05130e25 	ldreq	r0, [r3, #-3621]	; 0xfffff1db
 b70:	01000000 	mrseq	r0, (UNDEF: 0)
 b74:	0e250111 	mcreq	1, 1, r0, cr5, cr1, {0}
 b78:	0e030b13 	vmoveq.32	d3[0], r0
 b7c:	17100e1b 			; <UNDEFINED> instruction: 0x17100e1b
 b80:	24020000 	strcs	r0, [r2], #-0
 b84:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 b88:	0008030b 	andeq	r0, r8, fp, lsl #6
 b8c:	00240300 	eoreq	r0, r4, r0, lsl #6
 b90:	0b3e0b0b 	bleq	f837c4 <__bss_end+0xf79488>
 b94:	00000e03 	andeq	r0, r0, r3, lsl #28
 b98:	03010404 	movweq	r0, #5124	; 0x1404
 b9c:	0b0b3e0e 	bleq	2d03dc <__bss_end+0x2c60a0>
 ba0:	3a13490b 	bcc	4d2fd4 <__bss_end+0x4c8c98>
 ba4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 ba8:	0013010b 	andseq	r0, r3, fp, lsl #2
 bac:	00280500 	eoreq	r0, r8, r0, lsl #10
 bb0:	0b1c0e03 	bleq	7043c4 <__bss_end+0x6fa088>
 bb4:	13060000 	movwne	r0, #24576	; 0x6000
 bb8:	0b0e0301 	bleq	3817c4 <__bss_end+0x377488>
 bbc:	3b0b3a0b 	blcc	2cf3f0 <__bss_end+0x2c50b4>
 bc0:	010b3905 	tsteq	fp, r5, lsl #18
 bc4:	07000013 	smladeq	r0, r3, r0, r0
 bc8:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
 bcc:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 bd0:	13490b39 	movtne	r0, #39737	; 0x9b39
 bd4:	00000b38 	andeq	r0, r0, r8, lsr fp
 bd8:	49002608 	stmdbmi	r0, {r3, r9, sl, sp}
 bdc:	09000013 	stmdbeq	r0, {r0, r1, r4}
 be0:	13490101 	movtne	r0, #37121	; 0x9101
 be4:	00001301 	andeq	r1, r0, r1, lsl #6
 be8:	4900210a 	stmdbmi	r0, {r1, r3, r8, sp}
 bec:	000b2f13 	andeq	r2, fp, r3, lsl pc
 bf0:	00340b00 	eorseq	r0, r4, r0, lsl #22
 bf4:	0b3a0e03 	bleq	e84408 <__bss_end+0xe7a0cc>
 bf8:	0b39053b 	bleq	e420ec <__bss_end+0xe37db0>
 bfc:	0a1c1349 	beq	705928 <__bss_end+0x6fb5ec>
 c00:	150c0000 	strne	r0, [ip, #-0]
 c04:	00192700 	andseq	r2, r9, r0, lsl #14
 c08:	000f0d00 	andeq	r0, pc, r0, lsl #26
 c0c:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 c10:	040e0000 	streq	r0, [lr], #-0
 c14:	3e0e0301 	cdpcc	3, 0, cr0, cr14, cr1, {0}
 c18:	490b0b0b 	stmdbmi	fp, {r0, r1, r3, r8, r9, fp}
 c1c:	3b0b3a13 	blcc	2cf470 <__bss_end+0x2c5134>
 c20:	010b3905 	tsteq	fp, r5, lsl #18
 c24:	0f000013 	svceq	0x00000013
 c28:	0e030016 	mcreq	0, 0, r0, cr3, cr6, {0}
 c2c:	0b3b0b3a 	bleq	ec391c <__bss_end+0xeb95e0>
 c30:	13490b39 	movtne	r0, #39737	; 0x9b39
 c34:	21100000 	tstcs	r0, r0
 c38:	11000000 	mrsne	r0, (UNDEF: 0)
 c3c:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 c40:	0b3b0b3a 	bleq	ec3930 <__bss_end+0xeb95f4>
 c44:	13490b39 	movtne	r0, #39737	; 0x9b39
 c48:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
 c4c:	34120000 	ldrcc	r0, [r2], #-0
 c50:	3a134700 	bcc	4d2858 <__bss_end+0x4c851c>
 c54:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 c58:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 c5c:	00000018 	andeq	r0, r0, r8, lsl r0
 c60:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
 c64:	030b130e 	movweq	r1, #45838	; 0xb30e
 c68:	110e1b0e 	tstne	lr, lr, lsl #22
 c6c:	10061201 	andne	r1, r6, r1, lsl #4
 c70:	02000017 	andeq	r0, r0, #23
 c74:	0b0b0024 	bleq	2c0d0c <__bss_end+0x2b69d0>
 c78:	0e030b3e 	vmoveq.16	d3[0], r0
 c7c:	24030000 	strcs	r0, [r3], #-0
 c80:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 c84:	0008030b 	andeq	r0, r8, fp, lsl #6
 c88:	01040400 	tsteq	r4, r0, lsl #8
 c8c:	0b3e0e03 	bleq	f844a0 <__bss_end+0xf7a164>
 c90:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 c94:	0b3b0b3a 	bleq	ec3984 <__bss_end+0xeb9648>
 c98:	13010b39 	movwne	r0, #6969	; 0x1b39
 c9c:	28050000 	stmdacs	r5, {}	; <UNPREDICTABLE>
 ca0:	1c0e0300 	stcne	3, cr0, [lr], {-0}
 ca4:	0600000b 	streq	r0, [r0], -fp
 ca8:	0e030113 	mcreq	1, 0, r0, cr3, cr3, {0}
 cac:	0b3a0b0b 	bleq	e838e0 <__bss_end+0xe795a4>
 cb0:	0b39053b 	bleq	e421a4 <__bss_end+0xe37e68>
 cb4:	00001301 	andeq	r1, r0, r1, lsl #6
 cb8:	03000d07 	movweq	r0, #3335	; 0xd07
 cbc:	3b0b3a0e 	blcc	2cf4fc <__bss_end+0x2c51c0>
 cc0:	490b3905 	stmdbmi	fp, {r0, r2, r8, fp, ip, sp}
 cc4:	000b3813 	andeq	r3, fp, r3, lsl r8
 cc8:	00260800 	eoreq	r0, r6, r0, lsl #16
 ccc:	00001349 	andeq	r1, r0, r9, asr #6
 cd0:	49010109 	stmdbmi	r1, {r0, r3, r8}
 cd4:	00130113 	andseq	r0, r3, r3, lsl r1
 cd8:	00210a00 	eoreq	r0, r1, r0, lsl #20
 cdc:	0b2f1349 	bleq	bc5a08 <__bss_end+0xbbb6cc>
 ce0:	340b0000 	strcc	r0, [fp], #-0
 ce4:	3a0e0300 	bcc	3818ec <__bss_end+0x3775b0>
 ce8:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 cec:	1c13490b 			; <UNDEFINED> instruction: 0x1c13490b
 cf0:	0c00000a 	stceq	0, cr0, [r0], {10}
 cf4:	0e030016 	mcreq	0, 0, r0, cr3, cr6, {0}
 cf8:	0b3b0b3a 	bleq	ec39e8 <__bss_end+0xeb96ac>
 cfc:	13490b39 	movtne	r0, #39737	; 0x9b39
 d00:	2e0d0000 	cdpcs	0, 0, cr0, cr13, cr0, {0}
 d04:	03193f01 	tsteq	r9, #1, 30
 d08:	3b0b3a0e 	blcc	2cf548 <__bss_end+0x2c520c>
 d0c:	270b3905 	strcs	r3, [fp, -r5, lsl #18]
 d10:	11134919 	tstne	r3, r9, lsl r9
 d14:	40061201 	andmi	r1, r6, r1, lsl #4
 d18:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
 d1c:	00001301 	andeq	r1, r0, r1, lsl #6
 d20:	0300050e 	movweq	r0, #1294	; 0x50e
 d24:	3b0b3a08 	blcc	2cf54c <__bss_end+0x2c5210>
 d28:	490b3905 	stmdbmi	fp, {r0, r2, r8, fp, ip, sp}
 d2c:	b7170213 			; <UNDEFINED> instruction: 0xb7170213
 d30:	00001742 	andeq	r1, r0, r2, asr #14
 d34:	0182890f 	orreq	r8, r2, pc, lsl #18
 d38:	95011101 	strls	r1, [r1, #-257]	; 0xfffffeff
 d3c:	13311942 	teqne	r1, #1081344	; 0x108000
 d40:	00001301 	andeq	r1, r0, r1, lsl #6
 d44:	01828a10 	orreq	r8, r2, r0, lsl sl
 d48:	91180200 	tstls	r8, r0, lsl #4
 d4c:	00001842 	andeq	r1, r0, r2, asr #16
 d50:	01828911 	orreq	r8, r2, r1, lsl r9
 d54:	31011101 	tstcc	r1, r1, lsl #2
 d58:	12000013 	andne	r0, r0, #19
 d5c:	193f002e 	ldmdbne	pc!, {r1, r2, r3, r5}	; <UNPREDICTABLE>
 d60:	0e6e193c 			; <UNDEFINED> instruction: 0x0e6e193c
 d64:	0b3a0e03 	bleq	e84578 <__bss_end+0xe7a23c>
 d68:	0b390b3b 	bleq	e43a5c <__bss_end+0xe39720>
 d6c:	01000000 	mrseq	r0, (UNDEF: 0)
 d70:	0e250111 	mcreq	1, 1, r0, cr5, cr1, {0}
 d74:	0e030b13 	vmoveq.32	d3[0], r0
 d78:	01110e1b 	tsteq	r1, fp, lsl lr
 d7c:	17100612 			; <UNDEFINED> instruction: 0x17100612
 d80:	24020000 	strcs	r0, [r2], #-0
 d84:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 d88:	000e030b 	andeq	r0, lr, fp, lsl #6
 d8c:	00240300 	eoreq	r0, r4, r0, lsl #6
 d90:	0b3e0b0b 	bleq	f839c4 <__bss_end+0xf79688>
 d94:	00000803 	andeq	r0, r0, r3, lsl #16
 d98:	03010404 	movweq	r0, #5124	; 0x1404
 d9c:	0b0b3e0e 	bleq	2d05dc <__bss_end+0x2c62a0>
 da0:	3a13490b 	bcc	4d31d4 <__bss_end+0x4c8e98>
 da4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 da8:	0013010b 	andseq	r0, r3, fp, lsl #2
 dac:	00280500 	eoreq	r0, r8, r0, lsl #10
 db0:	0b1c0e03 	bleq	7045c4 <__bss_end+0x6fa288>
 db4:	13060000 	movwne	r0, #24576	; 0x6000
 db8:	0b0e0301 	bleq	3819c4 <__bss_end+0x377688>
 dbc:	3b0b3a0b 	blcc	2cf5f0 <__bss_end+0x2c52b4>
 dc0:	010b3905 	tsteq	fp, r5, lsl #18
 dc4:	07000013 	smladeq	r0, r3, r0, r0
 dc8:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
 dcc:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 dd0:	13490b39 	movtne	r0, #39737	; 0x9b39
 dd4:	00000b38 	andeq	r0, r0, r8, lsr fp
 dd8:	49002608 	stmdbmi	r0, {r3, r9, sl, sp}
 ddc:	09000013 	stmdbeq	r0, {r0, r1, r4}
 de0:	13490101 	movtne	r0, #37121	; 0x9101
 de4:	00001301 	andeq	r1, r0, r1, lsl #6
 de8:	4900210a 	stmdbmi	r0, {r1, r3, r8, sp}
 dec:	000b2f13 	andeq	r2, fp, r3, lsl pc
 df0:	00340b00 	eorseq	r0, r4, r0, lsl #22
 df4:	0b3a0e03 	bleq	e84608 <__bss_end+0xe7a2cc>
 df8:	0b39053b 	bleq	e422ec <__bss_end+0xe37fb0>
 dfc:	0a1c1349 	beq	705b28 <__bss_end+0x6fb7ec>
 e00:	160c0000 	strne	r0, [ip], -r0
 e04:	3a0e0300 	bcc	381a0c <__bss_end+0x3776d0>
 e08:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 e0c:	0013490b 	andseq	r4, r3, fp, lsl #18
 e10:	012e0d00 			; <UNDEFINED> instruction: 0x012e0d00
 e14:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 e18:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 e1c:	19270b39 	stmdbne	r7!, {r0, r3, r4, r5, r8, r9, fp}
 e20:	01111349 	tsteq	r1, r9, asr #6
 e24:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 e28:	00194297 	mulseq	r9, r7, r2
 e2c:	00050e00 	andeq	r0, r5, r0, lsl #28
 e30:	0b3a0803 	bleq	e82e44 <__bss_end+0xe78b08>
 e34:	0b39053b 	bleq	e42328 <__bss_end+0xe37fec>
 e38:	17021349 	strne	r1, [r2, -r9, asr #6]
 e3c:	001742b7 			; <UNDEFINED> instruction: 0x001742b7
 e40:	00340f00 	eorseq	r0, r4, r0, lsl #30
 e44:	0b3a0803 	bleq	e82e58 <__bss_end+0xe78b1c>
 e48:	0b39053b 	bleq	e4233c <__bss_end+0xe38000>
 e4c:	17021349 	strne	r1, [r2, -r9, asr #6]
 e50:	001742b7 			; <UNDEFINED> instruction: 0x001742b7
 e54:	11010000 	mrsne	r0, (UNDEF: 1)
 e58:	130e2501 	movwne	r2, #58625	; 0xe501
 e5c:	1b0e030b 	blne	381a90 <__bss_end+0x377754>
 e60:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 e64:	00171006 	andseq	r1, r7, r6
 e68:	00240200 	eoreq	r0, r4, r0, lsl #4
 e6c:	0b3e0b0b 	bleq	f83aa0 <__bss_end+0xf79764>
 e70:	00000e03 	andeq	r0, r0, r3, lsl #28
 e74:	0b002403 	bleq	9e88 <__udivmoddi4+0xa0>
 e78:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 e7c:	04000008 	streq	r0, [r0], #-8
 e80:	0e030104 	adfeqs	f0, f3, f4
 e84:	0b0b0b3e 	bleq	2c3b84 <__bss_end+0x2b9848>
 e88:	0b3a1349 	bleq	e85bb4 <__bss_end+0xe7b878>
 e8c:	0b390b3b 	bleq	e43b80 <__bss_end+0xe39844>
 e90:	00001301 	andeq	r1, r0, r1, lsl #6
 e94:	03002805 	movweq	r2, #2053	; 0x805
 e98:	000b1c0e 	andeq	r1, fp, lr, lsl #24
 e9c:	01130600 	tsteq	r3, r0, lsl #12
 ea0:	0b0b0e03 	bleq	2c46b4 <__bss_end+0x2ba378>
 ea4:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 ea8:	13010b39 	movwne	r0, #6969	; 0x1b39
 eac:	0d070000 	stceq	0, cr0, [r7, #-0]
 eb0:	3a0e0300 	bcc	381ab8 <__bss_end+0x37777c>
 eb4:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 eb8:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 ebc:	0800000b 	stmdaeq	r0, {r0, r1, r3}
 ec0:	13490026 	movtne	r0, #36902	; 0x9026
 ec4:	01090000 	mrseq	r0, (UNDEF: 9)
 ec8:	01134901 	tsteq	r3, r1, lsl #18
 ecc:	0a000013 	beq	f20 <shift+0xf20>
 ed0:	13490021 	movtne	r0, #36897	; 0x9021
 ed4:	00000b2f 	andeq	r0, r0, pc, lsr #22
 ed8:	0300340b 	movweq	r3, #1035	; 0x40b
 edc:	3b0b3a0e 	blcc	2cf71c <__bss_end+0x2c53e0>
 ee0:	490b3905 	stmdbmi	fp, {r0, r2, r8, fp, ip, sp}
 ee4:	000a1c13 	andeq	r1, sl, r3, lsl ip
 ee8:	00160c00 	andseq	r0, r6, r0, lsl #24
 eec:	0b3a0e03 	bleq	e84700 <__bss_end+0xe7a3c4>
 ef0:	0b390b3b 	bleq	e43be4 <__bss_end+0xe398a8>
 ef4:	00001349 	andeq	r1, r0, r9, asr #6
 ef8:	3f012e0d 	svccc	0x00012e0d
 efc:	3a0e0319 	bcc	381b68 <__bss_end+0x37782c>
 f00:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 f04:	4919270b 	ldmdbmi	r9, {r0, r1, r3, r8, r9, sl, sp}
 f08:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
 f0c:	97184006 	ldrls	r4, [r8, -r6]
 f10:	13011942 	movwne	r1, #6466	; 0x1942
 f14:	050e0000 	streq	r0, [lr, #-0]
 f18:	3a080300 	bcc	201b20 <__bss_end+0x1f77e4>
 f1c:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 f20:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 f24:	1742b717 	smlaldne	fp, r2, r7, r7
 f28:	050f0000 	streq	r0, [pc, #-0]	; f30 <shift+0xf30>
 f2c:	3a080300 	bcc	201b34 <__bss_end+0x1f77f8>
 f30:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 f34:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 f38:	10000018 	andne	r0, r0, r8, lsl r0
 f3c:	08030034 	stmdaeq	r3, {r2, r4, r5}
 f40:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 f44:	13490b39 	movtne	r0, #39737	; 0x9b39
 f48:	42b71702 	adcsmi	r1, r7, #524288	; 0x80000
 f4c:	11000017 	tstne	r0, r7, lsl r0
 f50:	0b0b000f 	bleq	2c0f94 <__bss_end+0x2b6c58>
 f54:	00001349 	andeq	r1, r0, r9, asr #6
	...

Disassembly of section .debug_aranges:

00000000 <.debug_aranges>:
   0:	0000001c 	andeq	r0, r0, ip, lsl r0
   4:	00000002 	andeq	r0, r0, r2
   8:	00040000 	andeq	r0, r4, r0
   c:	00000000 	andeq	r0, r0, r0
  10:	00008000 	andeq	r8, r0, r0
  14:	00000008 	andeq	r0, r0, r8
	...
  20:	0000001c 	andeq	r0, r0, ip, lsl r0
  24:	00260002 	eoreq	r0, r6, r2
  28:	00040000 	andeq	r0, r4, r0
  2c:	00000000 	andeq	r0, r0, r0
  30:	00008008 	andeq	r8, r0, r8
  34:	0000009c 	muleq	r0, ip, r0
	...
  40:	0000001c 	andeq	r0, r0, ip, lsl r0
  44:	00ce0002 	sbceq	r0, lr, r2
  48:	00040000 	andeq	r0, r4, r0
  4c:	00000000 	andeq	r0, r0, r0
  50:	000080a4 	andeq	r8, r0, r4, lsr #1
  54:	00000188 	andeq	r0, r0, r8, lsl #3
	...
  60:	0000001c 	andeq	r0, r0, ip, lsl r0
  64:	02d40002 	sbcseq	r0, r4, #2
  68:	00040000 	andeq	r0, r4, r0
  6c:	00000000 	andeq	r0, r0, r0
  70:	0000822c 	andeq	r8, r0, ip, lsr #4
  74:	000000a8 	andeq	r0, r0, r8, lsr #1
	...
  80:	0000001c 	andeq	r0, r0, ip, lsl r0
  84:	0cbc0002 	ldceq	0, cr0, [ip], #8
  88:	00040000 	andeq	r0, r4, r0
  8c:	00000000 	andeq	r0, r0, r0
  90:	000082d4 	ldrdeq	r8, [r0], -r4
  94:	0000045c 	andeq	r0, r0, ip, asr r4
	...
  a0:	0000001c 	andeq	r0, r0, ip, lsl r0
  a4:	18510002 	ldmdane	r1, {r1}^
  a8:	00040000 	andeq	r0, r4, r0
  ac:	00000000 	andeq	r0, r0, r0
  b0:	00008730 	andeq	r8, r0, r0, lsr r7
  b4:	00000c5c 	andeq	r0, r0, ip, asr ip
	...
  c0:	0000001c 	andeq	r0, r0, ip, lsl r0
  c4:	1e820002 	cdpne	0, 8, cr0, cr2, cr2, {0}
  c8:	00040000 	andeq	r0, r4, r0
  cc:	00000000 	andeq	r0, r0, r0
  d0:	0000938c 	andeq	r9, r0, ip, lsl #7
  d4:	000004b4 			; <UNDEFINED> instruction: 0x000004b4
	...
  e0:	0000001c 	andeq	r0, r0, ip, lsl r0
  e4:	2e5a0002 	cdpcs	0, 5, cr0, cr10, cr2, {0}
  e8:	00040000 	andeq	r0, r4, r0
  ec:	00000000 	andeq	r0, r0, r0
  f0:	00009840 	andeq	r9, r0, r0, asr #16
  f4:	0000020c 	andeq	r0, r0, ip, lsl #4
	...
 100:	0000001c 	andeq	r0, r0, ip, lsl r0
 104:	2e800002 	cdpcs	0, 8, cr0, cr0, cr2, {0}
 108:	00040000 	andeq	r0, r4, r0
 10c:	00000000 	andeq	r0, r0, r0
 110:	00009a4c 	andeq	r9, r0, ip, asr #20
 114:	00000004 	andeq	r0, r0, r4
	...
 120:	0000001c 	andeq	r0, r0, ip, lsl r0
 124:	2ea60002 	cdpcs	0, 10, cr0, cr6, cr2, {0}
 128:	00040000 	andeq	r0, r4, r0
 12c:	00000000 	andeq	r0, r0, r0
 130:	00009a50 	andeq	r9, r0, r0, asr sl
 134:	00000250 	andeq	r0, r0, r0, asr r2
	...
 140:	0000001c 	andeq	r0, r0, ip, lsl r0
 144:	2ecc0002 	cdpcs	0, 12, cr0, cr12, cr2, {0}
 148:	00040000 	andeq	r0, r4, r0
 14c:	00000000 	andeq	r0, r0, r0
 150:	00009ca0 	andeq	r9, r0, r0, lsr #25
 154:	000000d4 	ldrdeq	r0, [r0], -r4
	...
 160:	00000014 	andeq	r0, r0, r4, lsl r0
 164:	2ef20002 	cdpcs	0, 15, cr0, cr2, cr2, {0}
 168:	00040000 	andeq	r0, r4, r0
	...
 178:	0000001c 	andeq	r0, r0, ip, lsl r0
 17c:	32200002 	eorcc	r0, r0, #2
 180:	00040000 	andeq	r0, r4, r0
 184:	00000000 	andeq	r0, r0, r0
 188:	00009d74 	andeq	r9, r0, r4, ror sp
 18c:	00000030 	andeq	r0, r0, r0, lsr r0
	...
 198:	0000001c 	andeq	r0, r0, ip, lsl r0
 19c:	352a0002 	strcc	r0, [sl, #-2]!
 1a0:	00040000 	andeq	r0, r4, r0
 1a4:	00000000 	andeq	r0, r0, r0
 1a8:	00009da8 	andeq	r9, r0, r8, lsr #27
 1ac:	00000040 	andeq	r0, r0, r0, asr #32
	...
 1b8:	0000001c 	andeq	r0, r0, ip, lsl r0
 1bc:	38580002 	ldmdacc	r8, {r1}^
 1c0:	00040000 	andeq	r0, r4, r0
 1c4:	00000000 	andeq	r0, r0, r0
 1c8:	00009de8 	andeq	r9, r0, r8, ror #27
 1cc:	00000120 	andeq	r0, r0, r0, lsr #2
	...

Disassembly of section .debug_str:

00000000 <.debug_str>:
       0:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; ffffff4c <__bss_end+0xffff5c10>
       4:	72742f65 	rsbsvc	r2, r4, #404	; 0x194
       8:	6c696665 	stclvs	6, cr6, [r9], #-404	; 0xfffffe6c
       c:	6d65732f 	stclvs	3, cr7, [r5, #-188]!	; 0xffffff44
      10:	756f732f 	strbvc	r7, [pc, #-815]!	; fffffce9 <__bss_end+0xffff59ad>
      14:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
      18:	6573752f 	ldrbvs	r7, [r3, #-1327]!	; 0xfffffad1
      1c:	61707372 	cmnvs	r0, r2, ror r3
      20:	632f6563 			; <UNDEFINED> instruction: 0x632f6563
      24:	2e307472 	mrccs	4, 1, r7, cr0, cr2, {3}
      28:	682f0073 	stmdavs	pc!, {r0, r1, r4, r5, r6}	; <UNPREDICTABLE>
      2c:	2f656d6f 	svccs	0x00656d6f
      30:	66657274 			; <UNDEFINED> instruction: 0x66657274
      34:	732f6c69 			; <UNDEFINED> instruction: 0x732f6c69
      38:	732f6d65 			; <UNDEFINED> instruction: 0x732f6d65
      3c:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
      40:	752f7365 	strvc	r7, [pc, #-869]!	; fffffce3 <__bss_end+0xffff59a7>
      44:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
      48:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
      4c:	6975622f 	ldmdbvs	r5!, {r0, r1, r2, r3, r5, r9, sp, lr}^
      50:	4700646c 	strmi	r6, [r0, -ip, ror #8]
      54:	4120554e 			; <UNDEFINED> instruction: 0x4120554e
      58:	2e322053 	mrccs	0, 1, r2, cr2, cr3, {2}
      5c:	47003833 	smladxmi	r0, r3, r8, r3
      60:	4320554e 			; <UNDEFINED> instruction: 0x4320554e
      64:	31203731 			; <UNDEFINED> instruction: 0x31203731
      68:	2e332e30 	mrccs	14, 1, r2, cr3, cr0, {1}
      6c:	30322031 	eorscc	r2, r2, r1, lsr r0
      70:	36303132 			; <UNDEFINED> instruction: 0x36303132
      74:	28203132 	stmdacs	r0!, {r1, r4, r5, r8, ip, sp}
      78:	656c6572 	strbvs	r6, [ip, #-1394]!	; 0xfffffa8e
      7c:	29657361 	stmdbcs	r5!, {r0, r5, r6, r8, r9, ip, sp, lr}^
      80:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
      84:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
      88:	6962612d 	stmdbvs	r2!, {r0, r2, r3, r5, r8, sp, lr}^
      8c:	7261683d 	rsbvc	r6, r1, #3997696	; 0x3d0000
      90:	6d2d2064 	stcvs	0, cr2, [sp, #-400]!	; 0xfffffe70
      94:	3d757066 	ldclcc	0, cr7, [r5, #-408]!	; 0xfffffe68
      98:	20706676 	rsbscs	r6, r0, r6, ror r6
      9c:	6c666d2d 	stclvs	13, cr6, [r6], #-180	; 0xffffff4c
      a0:	2d74616f 	ldfcse	f6, [r4, #-444]!	; 0xfffffe44
      a4:	3d696261 	sfmcc	f6, 2, [r9, #-388]!	; 0xfffffe7c
      a8:	64726168 	ldrbtvs	r6, [r2], #-360	; 0xfffffe98
      ac:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
      b0:	763d7570 			; <UNDEFINED> instruction: 0x763d7570
      b4:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
      b8:	6e75746d 	cdpvs	4, 7, cr7, cr5, cr13, {3}
      bc:	72613d65 	rsbvc	r3, r1, #6464	; 0x1940
      c0:	3731316d 	ldrcc	r3, [r1, -sp, ror #2]!
      c4:	667a6a36 			; <UNDEFINED> instruction: 0x667a6a36
      c8:	2d20732d 	stccs	3, cr7, [r0, #-180]!	; 0xffffff4c
      cc:	6d72616d 	ldfvse	f6, [r2, #-436]!	; 0xfffffe4c
      d0:	616d2d20 	cmnvs	sp, r0, lsr #26
      d4:	3d686372 	stclcc	3, cr6, [r8, #-456]!	; 0xfffffe38
      d8:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
      dc:	2b6b7a36 	blcs	1ade9bc <__bss_end+0x1ad4680>
      e0:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
      e4:	672d2067 	strvs	r2, [sp, -r7, rrx]!
      e8:	304f2d20 	subcc	r2, pc, r0, lsr #26
      ec:	304f2d20 	subcc	r2, pc, r0, lsr #26
      f0:	625f5f00 	subsvs	r5, pc, #0, 30
      f4:	655f7373 	ldrbvs	r7, [pc, #-883]	; fffffd89 <__bss_end+0xffff5a4d>
      f8:	2f00646e 	svccs	0x0000646e
      fc:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
     100:	6572742f 	ldrbvs	r7, [r2, #-1071]!	; 0xfffffbd1
     104:	2f6c6966 	svccs	0x006c6966
     108:	2f6d6573 	svccs	0x006d6573
     10c:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
     110:	2f736563 	svccs	0x00736563
     114:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
     118:	63617073 	cmnvs	r1, #115	; 0x73
     11c:	72632f65 	rsbvc	r2, r3, #404	; 0x194
     120:	632e3074 			; <UNDEFINED> instruction: 0x632e3074
     124:	73657200 	cmnvc	r5, #0, 4
     128:	00746c75 	rsbseq	r6, r4, r5, ror ip
     12c:	73625f5f 	cmnvc	r2, #380	; 0x17c
     130:	74735f73 	ldrbtvc	r5, [r3], #-3955	; 0xfffff08d
     134:	00747261 	rsbseq	r7, r4, r1, ror #4
     138:	72635f5f 	rsbvc	r5, r3, #380	; 0x17c
     13c:	695f3074 	ldmdbvs	pc, {r2, r4, r5, r6, ip, sp}^	; <UNPREDICTABLE>
     140:	5f74696e 	svcpl	0x0074696e
     144:	00737362 	rsbseq	r7, r3, r2, ror #6
     148:	72635f5f 	rsbvc	r5, r3, #380	; 0x17c
     14c:	725f3074 	subsvc	r3, pc, #116	; 0x74
     150:	5f006e75 	svcpl	0x00006e75
     154:	6175675f 	cmnvs	r5, pc, asr r7
     158:	5f006472 	svcpl	0x00006472
     15c:	6165615f 	cmnvs	r5, pc, asr r1
     160:	755f6962 	ldrbvc	r6, [pc, #-2402]	; fffff806 <__bss_end+0xffff54ca>
     164:	6e69776e 	cdpvs	7, 6, cr7, cr9, cr14, {3}
     168:	70635f64 	rsbvc	r5, r3, r4, ror #30
     16c:	72705f70 	rsbsvc	r5, r0, #112, 30	; 0x1c0
     170:	635f0031 	cmpvs	pc, #49	; 0x31
     174:	735f7070 	cmpvc	pc, #112	; 0x70
     178:	64747568 	ldrbtvs	r7, [r4], #-1384	; 0xfffffa98
     17c:	006e776f 	rsbeq	r7, lr, pc, ror #14
     180:	74706e66 	ldrbtvc	r6, [r0], #-3686	; 0xfffff19a
     184:	5f5f0072 	svcpl	0x005f0072
     188:	61787863 	cmnvs	r8, r3, ror #16
     18c:	31766962 	cmncc	r6, r2, ror #18
     190:	6f682f00 	svcvs	0x00682f00
     194:	742f656d 	strtvc	r6, [pc], #-1389	; 19c <shift+0x19c>
     198:	69666572 	stmdbvs	r6!, {r1, r4, r5, r6, r8, sl, sp, lr}^
     19c:	65732f6c 	ldrbvs	r2, [r3, #-3948]!	; 0xfffff094
     1a0:	6f732f6d 	svcvs	0x00732f6d
     1a4:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
     1a8:	73752f73 	cmnvc	r5, #460	; 0x1cc
     1ac:	70737265 	rsbsvc	r7, r3, r5, ror #4
     1b0:	2f656361 	svccs	0x00656361
     1b4:	61787863 	cmnvs	r8, r3, ror #16
     1b8:	632e6962 			; <UNDEFINED> instruction: 0x632e6962
     1bc:	5f007070 	svcpl	0x00007070
     1c0:	6178635f 	cmnvs	r8, pc, asr r3
     1c4:	7275705f 	rsbsvc	r7, r5, #95	; 0x5f
     1c8:	69765f65 	ldmdbvs	r6!, {r0, r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     1cc:	61757472 	cmnvs	r5, r2, ror r4
     1d0:	5f5f006c 	svcpl	0x005f006c
     1d4:	5f617863 	svcpl	0x00617863
     1d8:	72617567 	rsbvc	r7, r1, #432013312	; 0x19c00000
     1dc:	65725f64 	ldrbvs	r5, [r2, #-3940]!	; 0xfffff09c
     1e0:	7361656c 	cmnvc	r1, #108, 10	; 0x1b000000
     1e4:	5f5f0065 	svcpl	0x005f0065
     1e8:	524f5443 	subpl	r5, pc, #1124073472	; 0x43000000
     1ec:	444e455f 	strbmi	r4, [lr], #-1375	; 0xfffffaa1
     1f0:	5f005f5f 	svcpl	0x00005f5f
     1f4:	6f73645f 	svcvs	0x0073645f
     1f8:	6e61685f 	mcrvs	8, 3, r6, cr1, cr15, {2}
     1fc:	00656c64 	rsbeq	r6, r5, r4, ror #24
     200:	54445f5f 	strbpl	r5, [r4], #-3935	; 0xfffff0a1
     204:	4c5f524f 	lfmmi	f5, 2, [pc], {79}	; 0x4f
     208:	5f545349 	svcpl	0x00545349
     20c:	5f5f005f 	svcpl	0x005f005f
     210:	5f617863 	svcpl	0x00617863
     214:	72617567 	rsbvc	r7, r1, #432013312	; 0x19c00000
     218:	62615f64 	rsbvs	r5, r1, #100, 30	; 0x190
     21c:	0074726f 	rsbseq	r7, r4, pc, ror #4
     220:	726f7464 	rsbvc	r7, pc, #100, 8	; 0x64000000
     224:	7274705f 	rsbsvc	r7, r4, #95	; 0x5f
     228:	445f5f00 	ldrbmi	r5, [pc], #-3840	; 230 <shift+0x230>
     22c:	5f524f54 	svcpl	0x00524f54
     230:	5f444e45 	svcpl	0x00444e45
     234:	5f5f005f 	svcpl	0x005f005f
     238:	5f617863 	svcpl	0x00617863
     23c:	78657461 	stmdavc	r5!, {r0, r5, r6, sl, ip, sp, lr}^
     240:	6c007469 	cfstrsvs	mvf7, [r0], {105}	; 0x69
     244:	20676e6f 	rsbcs	r6, r7, pc, ror #28
     248:	676e6f6c 	strbvs	r6, [lr, -ip, ror #30]!
     24c:	746e6920 	strbtvc	r6, [lr], #-2336	; 0xfffff6e0
     250:	70635f00 	rsbvc	r5, r3, r0, lsl #30
     254:	74735f70 	ldrbtvc	r5, [r3], #-3952	; 0xfffff090
     258:	75747261 	ldrbvc	r7, [r4, #-609]!	; 0xfffffd9f
     25c:	4e470070 	mcrmi	0, 2, r0, cr7, cr0, {3}
     260:	2b432055 	blcs	10c83bc <__bss_end+0x10be080>
     264:	2034312b 	eorscs	r3, r4, fp, lsr #2
     268:	332e3031 			; <UNDEFINED> instruction: 0x332e3031
     26c:	3220312e 	eorcc	r3, r0, #-2147483637	; 0x8000000b
     270:	30313230 	eorscc	r3, r1, r0, lsr r2
     274:	20313236 	eorscs	r3, r1, r6, lsr r2
     278:	6c657228 	sfmvs	f7, 2, [r5], #-160	; 0xffffff60
     27c:	65736165 	ldrbvs	r6, [r3, #-357]!	; 0xfffffe9b
     280:	6d2d2029 	stcvs	0, cr2, [sp, #-164]!	; 0xffffff5c
     284:	616f6c66 	cmnvs	pc, r6, ror #24
     288:	62612d74 	rsbvs	r2, r1, #116, 26	; 0x1d00
     28c:	61683d69 	cmnvs	r8, r9, ror #26
     290:	2d206472 	cfstrscs	mvf6, [r0, #-456]!	; 0xfffffe38
     294:	7570666d 	ldrbvc	r6, [r0, #-1645]!	; 0xfffff993
     298:	7066763d 	rsbvc	r7, r6, sp, lsr r6
     29c:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
     2a0:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
     2a4:	6962612d 	stmdbvs	r2!, {r0, r2, r3, r5, r8, sp, lr}^
     2a8:	7261683d 	rsbvc	r6, r1, #3997696	; 0x3d0000
     2ac:	6d2d2064 	stcvs	0, cr2, [sp, #-400]!	; 0xfffffe70
     2b0:	3d757066 	ldclcc	0, cr7, [r5, #-408]!	; 0xfffffe68
     2b4:	20706676 	rsbscs	r6, r0, r6, ror r6
     2b8:	75746d2d 	ldrbvc	r6, [r4, #-3373]!	; 0xfffff2d3
     2bc:	613d656e 	teqvs	sp, lr, ror #10
     2c0:	31316d72 	teqcc	r1, r2, ror sp
     2c4:	7a6a3637 	bvc	1a8dba8 <__bss_end+0x1a8386c>
     2c8:	20732d66 	rsbscs	r2, r3, r6, ror #26
     2cc:	72616d2d 	rsbvc	r6, r1, #2880	; 0xb40
     2d0:	6d2d206d 	stcvs	0, cr2, [sp, #-436]!	; 0xfffffe4c
     2d4:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
     2d8:	6d72613d 	ldfvse	f6, [r2, #-244]!	; 0xffffff0c
     2dc:	6b7a3676 	blvs	1e8dcbc <__bss_end+0x1e83980>
     2e0:	2070662b 	rsbscs	r6, r0, fp, lsr #12
     2e4:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
     2e8:	4f2d2067 	svcmi	0x002d2067
     2ec:	4f2d2030 	svcmi	0x002d2030
     2f0:	662d2030 			; <UNDEFINED> instruction: 0x662d2030
     2f4:	652d6f6e 	strvs	r6, [sp, #-3950]!	; 0xfffff092
     2f8:	70656378 	rsbvc	r6, r5, r8, ror r3
     2fc:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     300:	662d2073 			; <UNDEFINED> instruction: 0x662d2073
     304:	722d6f6e 	eorvc	r6, sp, #440	; 0x1b8
     308:	00697474 	rsbeq	r7, r9, r4, ror r4
     30c:	54435f5f 	strbpl	r5, [r3], #-3935	; 0xfffff0a1
     310:	4c5f524f 	lfmmi	f5, 2, [pc], {79}	; 0x4f
     314:	5f545349 	svcpl	0x00545349
     318:	7463005f 	strbtvc	r0, [r3], #-95	; 0xffffffa1
     31c:	705f726f 	subsvc	r7, pc, pc, ror #4
     320:	5f007274 	svcpl	0x00007274
     324:	6178635f 	cmnvs	r8, pc, asr r3
     328:	6175675f 	cmnvs	r5, pc, asr r7
     32c:	615f6472 	cmpvs	pc, r2, ror r4	; <UNPREDICTABLE>
     330:	69757163 	ldmdbvs	r5!, {r0, r1, r5, r6, r8, ip, sp, lr}^
     334:	73006572 	movwvc	r6, #1394	; 0x572
     338:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     33c:	6174735f 	cmnvs	r4, pc, asr r3
     340:	5f636974 	svcpl	0x00636974
     344:	6f697270 	svcvs	0x00697270
     348:	79746972 	ldmdbvc	r4!, {r1, r4, r5, r6, r8, fp, sp, lr}^
     34c:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     350:	4336314b 	teqmi	r6, #-1073741806	; 0xc0000012
     354:	636f7250 	cmnvs	pc, #80, 4
     358:	5f737365 	svcpl	0x00737365
     35c:	616e614d 	cmnvs	lr, sp, asr #2
     360:	31726567 	cmncc	r2, r7, ror #10
     364:	74654738 	strbtvc	r4, [r5], #-1848	; 0xfffff8c8
     368:	6f72505f 	svcvs	0x0072505f
     36c:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     370:	5f79425f 	svcpl	0x0079425f
     374:	45444950 	strbmi	r4, [r4, #-2384]	; 0xfffff6b0
     378:	5a5f006a 	bpl	17c0528 <__bss_end+0x17b61ec>
     37c:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     380:	636f7250 	cmnvs	pc, #80, 4
     384:	5f737365 	svcpl	0x00737365
     388:	616e614d 	cmnvs	lr, sp, asr #2
     38c:	31726567 	cmncc	r2, r7, ror #10
     390:	70614d39 	rsbvc	r4, r1, r9, lsr sp
     394:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     398:	6f545f65 	svcvs	0x00545f65
     39c:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
     3a0:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     3a4:	49355045 	ldmdbmi	r5!, {r0, r2, r6, ip, lr}
     3a8:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     3ac:	6d6e5500 	cfstr64vs	mvdx5, [lr, #-0]
     3b0:	465f7061 	ldrbmi	r7, [pc], -r1, rrx
     3b4:	5f656c69 	svcpl	0x00656c69
     3b8:	72727543 	rsbsvc	r7, r2, #281018368	; 0x10c00000
     3bc:	00746e65 	rsbseq	r6, r4, r5, ror #28
     3c0:	74697865 	strbtvc	r7, [r9], #-2149	; 0xfffff79b
     3c4:	646f635f 	strbtvs	r6, [pc], #-863	; 3cc <shift+0x3cc>
     3c8:	61480065 	cmpvs	r8, r5, rrx
     3cc:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     3d0:	6f72505f 	svcvs	0x0072505f
     3d4:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     3d8:	4957535f 	ldmdbmi	r7, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     3dc:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     3e0:	6863535f 	stmdavs	r3!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     3e4:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
     3e8:	495f7265 	ldmdbmi	pc, {r0, r2, r5, r6, r9, ip, sp, lr}^	; <UNPREDICTABLE>
     3ec:	006f666e 	rsbeq	r6, pc, lr, ror #12
     3f0:	5f70614d 	svcpl	0x0070614d
     3f4:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     3f8:	5f6f545f 	svcpl	0x006f545f
     3fc:	72727543 	rsbsvc	r7, r2, #281018368	; 0x10c00000
     400:	00746e65 	rsbseq	r6, r4, r5, ror #28
     404:	626d6f5a 	rsbvs	r6, sp, #360	; 0x168
     408:	6e006569 	cfsh32vs	mvfx6, mvfx0, #57
     40c:	00747865 	rsbseq	r7, r4, r5, ror #16
     410:	6e6e7552 	mcrvs	5, 3, r7, cr14, cr2, {2}
     414:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
     418:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     41c:	50433631 	subpl	r3, r3, r1, lsr r6
     420:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     424:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 260 <shift+0x260>
     428:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     42c:	53347265 	teqpl	r4, #1342177286	; 0x50000006
     430:	456b7262 	strbmi	r7, [fp, #-610]!	; 0xfffffd9e
     434:	6e49006a 	cdpvs	0, 4, cr0, cr9, cr10, {3}
     438:	696c6176 	stmdbvs	ip!, {r1, r2, r4, r5, r6, r8, sp, lr}^
     43c:	61485f64 	cmpvs	r8, r4, ror #30
     440:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     444:	6e755200 	cdpvs	2, 7, cr5, cr5, cr0, {0}
     448:	676e696e 	strbvs	r6, [lr, -lr, ror #18]!
     44c:	61654400 	cmnvs	r5, r0, lsl #8
     450:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
     454:	6e555f65 	cdpvs	15, 5, cr5, cr5, cr5, {3}
     458:	6e616863 	cdpvs	8, 6, cr6, cr1, cr3, {3}
     45c:	00646567 	rsbeq	r6, r4, r7, ror #10
     460:	5f746547 	svcpl	0x00746547
     464:	72727543 	rsbsvc	r7, r2, #281018368	; 0x10c00000
     468:	5f746e65 	svcpl	0x00746e65
     46c:	636f7250 	cmnvs	pc, #80, 4
     470:	00737365 	rsbseq	r7, r3, r5, ror #6
     474:	4f495047 	svcmi	0x00495047
     478:	7361425f 	cmnvc	r1, #-268435451	; 0xf0000005
     47c:	5a5f0065 	bpl	17c0618 <__bss_end+0x17b62dc>
     480:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     484:	636f7250 	cmnvs	pc, #80, 4
     488:	5f737365 	svcpl	0x00737365
     48c:	616e614d 	cmnvs	lr, sp, asr #2
     490:	31726567 	cmncc	r2, r7, ror #10
     494:	65724334 	ldrbvs	r4, [r2, #-820]!	; 0xfffffccc
     498:	5f657461 	svcpl	0x00657461
     49c:	636f7250 	cmnvs	pc, #80, 4
     4a0:	45737365 	ldrbmi	r7, [r3, #-869]!	; 0xfffffc9b
     4a4:	626a6850 	rsbvs	r6, sl, #80, 16	; 0x500000
     4a8:	65727000 	ldrbvs	r7, [r2, #-0]!
     4ac:	5a5f0076 	bpl	17c068c <__bss_end+0x17b6350>
     4b0:	4333314e 	teqmi	r3, #-2147483629	; 0x80000013
     4b4:	44454c4f 	strbmi	r4, [r5], #-3151	; 0xfffff3b1
     4b8:	7369445f 	cmnvc	r9, #1593835520	; 0x5f000000
     4bc:	79616c70 	stmdbvc	r1!, {r4, r5, r6, sl, fp, sp, lr}^
     4c0:	74755038 	ldrbtvc	r5, [r5], #-56	; 0xffffffc8
     4c4:	6168435f 	cmnvs	r8, pc, asr r3
     4c8:	74744572 	ldrbtvc	r4, [r4], #-1394	; 0xfffffa8e
     4cc:	5a5f0063 	bpl	17c0660 <__bss_end+0x17b6324>
     4d0:	36314b4e 	ldrtcc	r4, [r1], -lr, asr #22
     4d4:	6f725043 	svcvs	0x00725043
     4d8:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     4dc:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     4e0:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     4e4:	65473931 	strbvs	r3, [r7, #-2353]	; 0xfffff6cf
     4e8:	75435f74 	strbvc	r5, [r3, #-3956]	; 0xfffff08c
     4ec:	6e657272 	mcrvs	2, 3, r7, cr5, cr2, {3}
     4f0:	72505f74 	subsvc	r5, r0, #116, 30	; 0x1d0
     4f4:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     4f8:	00764573 	rsbseq	r4, r6, r3, ror r5
     4fc:	74726175 	ldrbtvc	r6, [r2], #-373	; 0xfffffe8b
     500:	6c69665f 	stclvs	6, cr6, [r9], #-380	; 0xfffffe84
     504:	70660065 	rsbvc	r0, r6, r5, rrx
     508:	00737475 	rsbseq	r7, r3, r5, ror r4
     50c:	64616552 	strbtvs	r6, [r1], #-1362	; 0xfffffaae
     510:	6c6e4f5f 	stclvs	15, cr4, [lr], #-380	; 0xfffffe84
     514:	614d0079 	hvcvs	53257	; 0xd009
     518:	72505f78 	subsvc	r5, r0, #120, 30	; 0x1e0
     51c:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     520:	704f5f73 	subvc	r5, pc, r3, ror pc	; <UNPREDICTABLE>
     524:	64656e65 	strbtvs	r6, [r5], #-3685	; 0xfffff19b
     528:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     52c:	54007365 	strpl	r7, [r0], #-869	; 0xfffffc9b
     530:	5f555043 	svcpl	0x00555043
     534:	746e6f43 	strbtvc	r6, [lr], #-3907	; 0xfffff0bd
     538:	00747865 	rsbseq	r7, r4, r5, ror #16
     53c:	314e5a5f 	cmpcc	lr, pc, asr sl
     540:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     544:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     548:	614d5f73 	hvcvs	54771	; 0xd5f3
     54c:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     550:	63533872 	cmpvs	r3, #7471104	; 0x720000
     554:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
     558:	7645656c 	strbvc	r6, [r5], -ip, ror #10
     55c:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     560:	4f433331 	svcmi	0x00433331
     564:	5f44454c 	svcpl	0x0044454c
     568:	70736944 	rsbsvc	r6, r3, r4, asr #18
     56c:	4379616c 	cmnmi	r9, #108, 2
     570:	4b504534 	blmi	1411a48 <__bss_end+0x140770c>
     574:	73490063 	movtvc	r0, #36963	; 0x9063
     578:	65704f5f 	ldrbvs	r4, [r0, #-3935]!	; 0xfffff0a1
     57c:	0064656e 	rsbeq	r6, r4, lr, ror #10
     580:	69746f4e 	ldmdbvs	r4!, {r1, r2, r3, r6, r8, r9, sl, fp, sp, lr}^
     584:	6c417966 	mcrrvs	9, 6, r7, r1, cr6	; <UNPREDICTABLE>
     588:	6c42006c 	mcrrvs	0, 6, r0, r2, cr12
     58c:	5f6b636f 	svcpl	0x006b636f
     590:	72727543 	rsbsvc	r7, r2, #281018368	; 0x10c00000
     594:	5f746e65 	svcpl	0x00746e65
     598:	636f7250 	cmnvs	pc, #80, 4
     59c:	00737365 	rsbseq	r7, r3, r5, ror #6
     5a0:	5f746547 	svcpl	0x00746547
     5a4:	00444950 	subeq	r4, r4, r0, asr r9
     5a8:	746e6975 	strbtvc	r6, [lr], #-2421	; 0xfffff68b
     5ac:	745f3233 	ldrbvc	r3, [pc], #-563	; 5b4 <shift+0x5b4>
     5b0:	676f6c00 	strbvs	r6, [pc, -r0, lsl #24]!
     5b4:	6c616369 	stclvs	3, cr6, [r1], #-420	; 0xfffffe5c
     5b8:	6572625f 	ldrbvs	r6, [r2, #-607]!	; 0xfffffda1
     5bc:	5f006b61 	svcpl	0x00006b61
     5c0:	33314e5a 	teqcc	r1, #1440	; 0x5a0
     5c4:	454c4f43 	strbmi	r4, [ip, #-3907]	; 0xfffff0bd
     5c8:	69445f44 	stmdbvs	r4, {r2, r6, r8, r9, sl, fp, ip, lr}^
     5cc:	616c7073 	smcvs	50947	; 0xc703
     5d0:	6c433579 	cfstr64vs	mvdx3, [r3], {121}	; 0x79
     5d4:	45726165 	ldrbmi	r6, [r2, #-357]!	; 0xfffffe9b
     5d8:	53420062 	movtpl	r0, #8290	; 0x2062
     5dc:	425f3143 	subsmi	r3, pc, #-1073741808	; 0xc0000010
     5e0:	00657361 	rsbeq	r7, r5, r1, ror #6
     5e4:	5f747550 	svcpl	0x00747550
     5e8:	72616843 	rsbvc	r6, r1, #4390912	; 0x430000
     5ec:	69615700 	stmdbvs	r1!, {r8, r9, sl, ip, lr}^
     5f0:	544e0074 	strbpl	r0, [lr], #-116	; 0xffffff8c
     5f4:	5f6b7361 	svcpl	0x006b7361
     5f8:	74617453 	strbtvc	r7, [r1], #-1107	; 0xfffffbad
     5fc:	682f0065 	stmdavs	pc!, {r0, r2, r5, r6}	; <UNPREDICTABLE>
     600:	2f656d6f 	svccs	0x00656d6f
     604:	66657274 			; <UNDEFINED> instruction: 0x66657274
     608:	732f6c69 			; <UNDEFINED> instruction: 0x732f6c69
     60c:	732f6d65 			; <UNDEFINED> instruction: 0x732f6d65
     610:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
     614:	752f7365 	strvc	r7, [pc, #-869]!	; 2b7 <shift+0x2b7>
     618:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
     61c:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
     620:	656c6f2f 	strbvs	r6, [ip, #-3887]!	; 0xfffff0d1
     624:	61745f64 	cmnvs	r4, r4, ror #30
     628:	6d2f6b73 	fstmdbxvs	pc!, {d6-d62}	;@ Deprecated
     62c:	2e6e6961 	vnmulcs.f16	s13, s28, s3	; <UNPREDICTABLE>
     630:	00707063 	rsbseq	r7, r0, r3, rrx
     634:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     638:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
     63c:	4644455f 			; <UNDEFINED> instruction: 0x4644455f
     640:	6f6c4200 	svcvs	0x006c4200
     644:	64656b63 	strbtvs	r6, [r5], #-2915	; 0xfffff49d
     648:	75436d00 	strbvc	r6, [r3, #-3328]	; 0xfffff300
     64c:	6e657272 	mcrvs	2, 3, r7, cr5, cr2, {3}
     650:	61545f74 	cmpvs	r4, r4, ror pc
     654:	4e5f6b73 	vmovmi.s8	r6, d15[3]
     658:	0065646f 	rsbeq	r6, r5, pc, ror #8
     65c:	65656c73 	strbvs	r6, [r5, #-3187]!	; 0xfffff38d
     660:	69745f70 	ldmdbvs	r4!, {r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     664:	0072656d 	rsbseq	r6, r2, sp, ror #10
     668:	314e5a5f 	cmpcc	lr, pc, asr sl
     66c:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     670:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     674:	614d5f73 	hvcvs	54771	; 0xd5f3
     678:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     67c:	77533972 			; <UNDEFINED> instruction: 0x77533972
     680:	68637469 	stmdavs	r3!, {r0, r3, r5, r6, sl, ip, sp, lr}^
     684:	456f545f 	strbmi	r5, [pc, #-1119]!	; 22d <shift+0x22d>
     688:	43383150 	teqmi	r8, #80, 2
     68c:	636f7250 	cmnvs	pc, #80, 4
     690:	5f737365 	svcpl	0x00737365
     694:	7473694c 	ldrbtvc	r6, [r3], #-2380	; 0xfffff6b4
     698:	646f4e5f 	strbtvs	r4, [pc], #-3679	; 6a0 <shift+0x6a0>
     69c:	70630065 	rsbvc	r0, r3, r5, rrx
     6a0:	6f635f75 	svcvs	0x00635f75
     6a4:	7865746e 	stmdavc	r5!, {r1, r2, r3, r5, r6, sl, ip, sp, lr}^
     6a8:	72430074 	subvc	r0, r3, #116	; 0x74
     6ac:	65746165 	ldrbvs	r6, [r4, #-357]!	; 0xfffffe9b
     6b0:	6f72505f 	svcvs	0x0072505f
     6b4:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     6b8:	65704f00 	ldrbvs	r4, [r0, #-3840]!	; 0xfffff100
     6bc:	7552006e 	ldrbvc	r0, [r2, #-110]	; 0xffffff92
     6c0:	7269466e 	rsbvc	r4, r9, #115343360	; 0x6e00000
     6c4:	61547473 	cmpvs	r4, r3, ror r4
     6c8:	5f006b73 	svcpl	0x00006b73
     6cc:	33314e5a 	teqcc	r1, #1440	; 0x5a0
     6d0:	454c4f43 	strbmi	r4, [ip, #-3907]	; 0xfffff0bd
     6d4:	69445f44 	stmdbvs	r4, {r2, r6, r8, r9, sl, fp, ip, lr}^
     6d8:	616c7073 	smcvs	50947	; 0xc703
     6dc:	6c463479 	cfstrdvs	mvd3, [r6], {121}	; 0x79
     6e0:	76457069 	strbvc	r7, [r5], -r9, rrx
     6e4:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     6e8:	50433631 	subpl	r3, r3, r1, lsr r6
     6ec:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     6f0:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 52c <shift+0x52c>
     6f4:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     6f8:	34317265 	ldrtcc	r7, [r1], #-613	; 0xfffffd9b
     6fc:	69746f4e 	ldmdbvs	r4!, {r1, r2, r3, r6, r8, r9, sl, fp, sp, lr}^
     700:	505f7966 	subspl	r7, pc, r6, ror #18
     704:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     708:	50457373 	subpl	r7, r5, r3, ror r3
     70c:	54543231 	ldrbpl	r3, [r4], #-561	; 0xfffffdcf
     710:	5f6b7361 	svcpl	0x006b7361
     714:	75727453 	ldrbvc	r7, [r2, #-1107]!	; 0xfffffbad
     718:	47007463 	strmi	r7, [r0, -r3, ror #8]
     71c:	535f7465 	cmppl	pc, #1694498816	; 0x65000000
     720:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     724:	666e495f 			; <UNDEFINED> instruction: 0x666e495f
     728:	4f49006f 	svcmi	0x0049006f
     72c:	006c7443 	rsbeq	r7, ip, r3, asr #8
     730:	6e61486d 	cdpvs	8, 6, cr4, cr1, cr13, {3}
     734:	00656c64 	rsbeq	r6, r5, r4, ror #24
     738:	64616552 	strbtvs	r6, [r1], #-1362	; 0xfffffaae
     73c:	72655400 	rsbvc	r5, r5, #0, 8
     740:	616e696d 	cmnvs	lr, sp, ror #18
     744:	53006574 	movwpl	r6, #1396	; 0x574
     748:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     74c:	69545f6d 	ldmdbvs	r4, {r0, r2, r3, r5, r6, r8, r9, sl, fp, ip, lr}^
     750:	5f72656d 	svcpl	0x0072656d
     754:	65736142 	ldrbvs	r6, [r3, #-322]!	; 0xfffffebe
     758:	746f4e00 	strbtvc	r4, [pc], #-3584	; 760 <shift+0x760>
     75c:	5f796669 	svcpl	0x00796669
     760:	636f7250 	cmnvs	pc, #80, 4
     764:	00737365 	rsbseq	r7, r3, r5, ror #6
     768:	314e5a5f 	cmpcc	lr, pc, asr sl
     76c:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     770:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     774:	614d5f73 	hvcvs	54771	; 0xd5f3
     778:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     77c:	45344372 	ldrmi	r4, [r4, #-882]!	; 0xfffffc8e
     780:	74730076 	ldrbtvc	r0, [r3], #-118	; 0xffffff8a
     784:	676e6972 			; <UNDEFINED> instruction: 0x676e6972
     788:	73656d00 	cmnvc	r5, #0, 26
     78c:	65676173 	strbvs	r6, [r7, #-371]!	; 0xfffffe8d
     790:	6c430073 	mcrrvs	0, 7, r0, r3, cr3
     794:	00726165 	rsbseq	r6, r2, r5, ror #2
     798:	4b4e5a5f 	blmi	139711c <__bss_end+0x138cde0>
     79c:	4f433331 	svcmi	0x00433331
     7a0:	5f44454c 	svcpl	0x0044454c
     7a4:	70736944 	rsbsvc	r6, r3, r4, asr #18
     7a8:	3979616c 	ldmdbcc	r9!, {r2, r3, r5, r6, r8, sp, lr}^
     7ac:	4f5f7349 	svcmi	0x005f7349
     7b0:	656e6570 	strbvs	r6, [lr, #-1392]!	; 0xfffffa90
     7b4:	00764564 	rsbseq	r4, r6, r4, ror #10
     7b8:	69746f4e 	ldmdbvs	r4!, {r1, r2, r3, r6, r8, r9, sl, fp, sp, lr}^
     7bc:	4d007966 	vstrmi.16	s14, [r0, #-204]	; 0xffffff34	; <UNPREDICTABLE>
     7c0:	61507861 	cmpvs	r0, r1, ror #16
     7c4:	654c6874 	strbvs	r6, [ip, #-2164]	; 0xfffff78c
     7c8:	6874676e 	ldmdavs	r4!, {r1, r2, r3, r5, r6, r8, r9, sl, sp, lr}^
     7cc:	78614d00 	stmdavc	r1!, {r8, sl, fp, lr}^
     7d0:	72445346 	subvc	r5, r4, #402653185	; 0x18000001
     7d4:	72657669 	rsbvc	r7, r5, #110100480	; 0x6900000
     7d8:	656d614e 	strbvs	r6, [sp, #-334]!	; 0xfffffeb2
     7dc:	676e654c 	strbvs	r6, [lr, -ip, asr #10]!
     7e0:	5f006874 	svcpl	0x00006874
     7e4:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     7e8:	6f725043 	svcvs	0x00725043
     7ec:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     7f0:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     7f4:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     7f8:	63533131 	cmpvs	r3, #1073741836	; 0x4000000c
     7fc:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
     800:	525f656c 	subspl	r6, pc, #108, 10	; 0x1b000000
     804:	00764552 	rsbseq	r4, r6, r2, asr r5
     808:	7465474e 	strbtvc	r4, [r5], #-1870	; 0xfffff8b2
     80c:	6863535f 	stmdavs	r3!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     810:	495f6465 	ldmdbmi	pc, {r0, r2, r5, r6, sl, sp, lr}^	; <UNPREDICTABLE>
     814:	5f6f666e 	svcpl	0x006f666e
     818:	65707954 	ldrbvs	r7, [r0, #-2388]!	; 0xfffff6ac
     81c:	49504700 	ldmdbmi	r0, {r8, r9, sl, lr}^
     820:	69505f4f 	ldmdbvs	r0, {r0, r1, r2, r3, r6, r8, r9, sl, fp, ip, lr}^
     824:	6f435f6e 	svcvs	0x00435f6e
     828:	00746e75 	rsbseq	r6, r4, r5, ror lr
     82c:	6b736174 	blvs	1cd8e04 <__bss_end+0x1cceac8>
     830:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     834:	50433631 	subpl	r3, r3, r1, lsr r6
     838:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     83c:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 678 <shift+0x678>
     840:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     844:	32317265 	eorscc	r7, r1, #1342177286	; 0x50000006
     848:	466e7552 			; <UNDEFINED> instruction: 0x466e7552
     84c:	74737269 	ldrbtvc	r7, [r3], #-617	; 0xfffffd97
     850:	6b736154 	blvs	1cd8da8 <__bss_end+0x1ccea6c>
     854:	62007645 	andvs	r7, r0, #72351744	; 0x4500000
     858:	006c6f6f 	rsbeq	r6, ip, pc, ror #30
     85c:	314e5a5f 	cmpcc	lr, pc, asr sl
     860:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     864:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     868:	614d5f73 	hvcvs	54771	; 0xd5f3
     86c:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     870:	47383172 			; <UNDEFINED> instruction: 0x47383172
     874:	535f7465 	cmppl	pc, #1694498816	; 0x65000000
     878:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     87c:	72656c75 	rsbvc	r6, r5, #29952	; 0x7500
     880:	666e495f 			; <UNDEFINED> instruction: 0x666e495f
     884:	3032456f 	eorscc	r4, r2, pc, ror #10
     888:	7465474e 	strbtvc	r4, [r5], #-1870	; 0xfffff8b2
     88c:	6863535f 	stmdavs	r3!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     890:	495f6465 	ldmdbmi	pc, {r0, r2, r5, r6, sl, sp, lr}^	; <UNPREDICTABLE>
     894:	5f6f666e 	svcpl	0x006f666e
     898:	65707954 	ldrbvs	r7, [r0, #-2388]!	; 0xfffff6ac
     89c:	54007650 	strpl	r7, [r0], #-1616	; 0xfffff9b0
     8a0:	5f474e52 	svcpl	0x00474e52
     8a4:	65736142 	ldrbvs	r6, [r3, #-322]!	; 0xfffffebe
     8a8:	66654400 	strbtvs	r4, [r5], -r0, lsl #8
     8ac:	746c7561 	strbtvc	r7, [ip], #-1377	; 0xfffffa9f
     8b0:	6f6c435f 	svcvs	0x006c435f
     8b4:	525f6b63 	subspl	r6, pc, #101376	; 0x18c00
     8b8:	00657461 	rsbeq	r7, r5, r1, ror #8
     8bc:	6f72506d 	svcvs	0x0072506d
     8c0:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     8c4:	73694c5f 	cmnvc	r9, #24320	; 0x5f00
     8c8:	65485f74 	strbvs	r5, [r8, #-3956]	; 0xfffff08c
     8cc:	6d006461 	cfstrsvs	mvf6, [r0, #-388]	; 0xfffffe7c
     8d0:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     8d4:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
     8d8:	636e465f 	cmnvs	lr, #99614720	; 0x5f00000
     8dc:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     8e0:	50433631 	subpl	r3, r3, r1, lsr r6
     8e4:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     8e8:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 724 <shift+0x724>
     8ec:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     8f0:	31327265 	teqcc	r2, r5, ror #4
     8f4:	636f6c42 	cmnvs	pc, #16896	; 0x4200
     8f8:	75435f6b 	strbvc	r5, [r3, #-3947]	; 0xfffff095
     8fc:	6e657272 	mcrvs	2, 3, r7, cr5, cr2, {3}
     900:	72505f74 	subsvc	r5, r0, #116, 30	; 0x1d0
     904:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     908:	00764573 	rsbseq	r4, r6, r3, ror r5
     90c:	6b636f4c 	blvs	18dc644 <__bss_end+0x18d2308>
     910:	6c6e555f 	cfstr64vs	mvdx5, [lr], #-380	; 0xfffffe84
     914:	656b636f 	strbvs	r6, [fp, #-879]!	; 0xfffffc91
     918:	4c6d0064 	stclmi	0, cr0, [sp], #-400	; 0xfffffe70
     91c:	5f747361 	svcpl	0x00747361
     920:	00444950 	subeq	r4, r4, r0, asr r9
     924:	74697753 	strbtvc	r7, [r9], #-1875	; 0xfffff8ad
     928:	545f6863 	ldrbpl	r6, [pc], #-2147	; 930 <shift+0x930>
     92c:	6c43006f 	mcrrvs	0, 6, r0, r3, cr15
     930:	0065736f 	rsbeq	r7, r5, pc, ror #6
     934:	314e5a5f 	cmpcc	lr, pc, asr sl
     938:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     93c:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     940:	614d5f73 	hvcvs	54771	; 0xd5f3
     944:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     948:	53323172 	teqpl	r2, #-2147483620	; 0x8000001c
     94c:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     950:	5f656c75 	svcpl	0x00656c75
     954:	45464445 	strbmi	r4, [r6, #-1093]	; 0xfffffbbb
     958:	53420076 	movtpl	r0, #8310	; 0x2076
     95c:	425f3043 	subsmi	r3, pc, #67	; 0x43
     960:	00657361 	rsbeq	r7, r5, r1, ror #6
     964:	63677261 	cmnvs	r7, #268435462	; 0x10000006
     968:	746f6e00 	strbtvc	r6, [pc], #-3584	; 970 <shift+0x970>
     96c:	65696669 	strbvs	r6, [r9, #-1641]!	; 0xfffff997
     970:	65645f64 	strbvs	r5, [r4, #-3940]!	; 0xfffff09c
     974:	696c6461 	stmdbvs	ip!, {r0, r5, r6, sl, sp, lr}^
     978:	6100656e 	tstvs	r0, lr, ror #10
     97c:	00766772 	rsbseq	r6, r6, r2, ror r7
     980:	746e6975 	strbtvc	r6, [lr], #-2421	; 0xfffff68b
     984:	745f3631 	ldrbvc	r3, [pc], #-1585	; 98c <shift+0x98c>
     988:	704f6d00 	subvc	r6, pc, r0, lsl #26
     98c:	64656e65 	strbtvs	r6, [r5], #-3685	; 0xfffff19b
     990:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     994:	50433631 	subpl	r3, r3, r1, lsr r6
     998:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     99c:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 7d8 <shift+0x7d8>
     9a0:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     9a4:	34317265 	ldrtcc	r7, [r1], #-613	; 0xfffffd9b
     9a8:	69746f4e 	ldmdbvs	r4!, {r1, r2, r3, r6, r8, r9, sl, fp, sp, lr}^
     9ac:	505f7966 	subspl	r7, pc, r6, ror #18
     9b0:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     9b4:	6a457373 	bvs	115d788 <__bss_end+0x115344c>
     9b8:	466f4e00 	strbtmi	r4, [pc], -r0, lsl #28
     9bc:	73656c69 	cmnvc	r5, #26880	; 0x6900
     9c0:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     9c4:	6972446d 	ldmdbvs	r2!, {r0, r2, r3, r5, r6, sl, lr}^
     9c8:	00726576 	rsbseq	r6, r2, r6, ror r5
     9cc:	314e5a5f 	cmpcc	lr, pc, asr sl
     9d0:	4c4f4333 	mcrrmi	3, 3, r4, pc, cr3
     9d4:	445f4445 	ldrbmi	r4, [pc], #-1093	; 9dc <shift+0x9dc>
     9d8:	6c707369 	ldclvs	3, cr7, [r0], #-420	; 0xfffffe5c
     9dc:	34447961 	strbcc	r7, [r4], #-2401	; 0xfffff69f
     9e0:	44007645 	strmi	r7, [r0], #-1605	; 0xfffff9bb
     9e4:	6c646165 	stfvse	f6, [r4], #-404	; 0xfffffe6c
     9e8:	00656e69 	rsbeq	r6, r5, r9, ror #28
     9ec:	726f6873 	rsbvc	r6, pc, #7536640	; 0x730000
     9f0:	6e692074 	mcrvs	0, 3, r2, cr9, cr4, {3}
     9f4:	437e0074 	cmnmi	lr, #116	; 0x74
     9f8:	44454c4f 	strbmi	r4, [r5], #-3151	; 0xfffff3b1
     9fc:	7369445f 	cmnvc	r9, #1593835520	; 0x5f000000
     a00:	79616c70 	stmdbvc	r1!, {r4, r5, r6, sl, fp, sp, lr}^
     a04:	78614d00 	stmdavc	r1!, {r8, sl, fp, lr}^
     a08:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     a0c:	656d616e 	strbvs	r6, [sp, #-366]!	; 0xfffffe92
     a10:	676e654c 	strbvs	r6, [lr, -ip, asr #10]!
     a14:	43006874 	movwmi	r6, #2164	; 0x874
     a18:	636f7250 	cmnvs	pc, #80, 4
     a1c:	5f737365 	svcpl	0x00737365
     a20:	616e614d 	cmnvs	lr, sp, asr #2
     a24:	00726567 	rsbseq	r6, r2, r7, ror #10
     a28:	73796870 	cmnvc	r9, #112, 16	; 0x700000
     a2c:	6c616369 	stclvs	3, cr6, [r1], #-420	; 0xfffffe5c
     a30:	6572625f 	ldrbvs	r6, [r2, #-607]!	; 0xfffffda1
     a34:	74006b61 	strvc	r6, [r0], #-2913	; 0xfffff49f
     a38:	30726274 	rsbscc	r6, r2, r4, ror r2
     a3c:	57534e00 	ldrbpl	r4, [r3, -r0, lsl #28]
     a40:	69465f49 	stmdbvs	r6, {r0, r3, r6, r8, r9, sl, fp, ip, lr}^
     a44:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
     a48:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
     a4c:	7265535f 	rsbvc	r5, r5, #2080374785	; 0x7c000001
     a50:	65636976 	strbvs	r6, [r3, #-2422]!	; 0xfffff68a
     a54:	57534e00 	ldrbpl	r4, [r3, -r0, lsl #28]
     a58:	72505f49 	subsvc	r5, r0, #292	; 0x124
     a5c:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     a60:	65535f73 	ldrbvs	r5, [r3, #-3955]	; 0xfffff08d
     a64:	63697672 	cmnvs	r9, #119537664	; 0x7200000
     a68:	706f0065 	rsbvc	r0, pc, r5, rrx
     a6c:	64656e65 	strbtvs	r6, [r5], #-3685	; 0xfffff19b
     a70:	6c69665f 	stclvs	6, cr6, [r9], #-380	; 0xfffffe84
     a74:	59007365 	stmdbpl	r0, {r0, r2, r5, r6, r8, r9, ip, sp, lr}
     a78:	646c6569 	strbtvs	r6, [ip], #-1385	; 0xfffffa97
     a7c:	646e4900 	strbtvs	r4, [lr], #-2304	; 0xfffff700
     a80:	6e696665 	cdpvs	6, 6, cr6, cr9, cr5, {3}
     a84:	00657469 	rsbeq	r7, r5, r9, ror #8
     a88:	5f746547 	svcpl	0x00746547
     a8c:	636f7250 	cmnvs	pc, #80, 4
     a90:	5f737365 	svcpl	0x00737365
     a94:	505f7942 	subspl	r7, pc, r2, asr #18
     a98:	50004449 	andpl	r4, r0, r9, asr #8
     a9c:	70697265 	rsbvc	r7, r9, r5, ror #4
     aa0:	61726568 	cmnvs	r2, r8, ror #10
     aa4:	61425f6c 	cmpvs	r2, ip, ror #30
     aa8:	5f006573 	svcpl	0x00006573
     aac:	33314e5a 	teqcc	r1, #1440	; 0x5a0
     ab0:	454c4f43 	strbmi	r4, [ip, #-3907]	; 0xfffff0bd
     ab4:	69445f44 	stmdbvs	r4, {r2, r6, r8, r9, sl, fp, ip, lr}^
     ab8:	616c7073 	smcvs	50947	; 0xc703
     abc:	50303179 	eorspl	r3, r0, r9, ror r1
     ac0:	535f7475 	cmppl	pc, #1962934272	; 0x75000000
     ac4:	6e697274 	mcrvs	2, 3, r7, cr9, cr4, {3}
     ac8:	74744567 	ldrbtvc	r4, [r4], #-1383	; 0xfffffa99
     acc:	00634b50 	rsbeq	r4, r3, r0, asr fp
     ad0:	70696c46 	rsbvc	r6, r9, r6, asr #24
     ad4:	766e4900 	strbtvc	r4, [lr], -r0, lsl #18
     ad8:	64696c61 	strbtvs	r6, [r9], #-3169	; 0xfffff39f
     adc:	6e69505f 	mcrvs	0, 3, r5, cr9, cr15, {2}
     ae0:	636f4c00 	cmnvs	pc, #0, 24
     ae4:	6f4c5f6b 	svcvs	0x004c5f6b
     ae8:	64656b63 	strbtvs	r6, [r5], #-2915	; 0xfffff49d
     aec:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     af0:	50433631 	subpl	r3, r3, r1, lsr r6
     af4:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     af8:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 934 <shift+0x934>
     afc:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     b00:	38317265 	ldmdacc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
     b04:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     b08:	505f656c 	subspl	r6, pc, ip, ror #10
     b0c:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     b10:	535f7373 	cmppl	pc, #-872415231	; 0xcc000001
     b14:	32454957 	subcc	r4, r5, #1425408	; 0x15c000
     b18:	57534e30 	smmlarpl	r3, r0, lr, r4
     b1c:	72505f49 	subsvc	r5, r0, #292	; 0x124
     b20:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     b24:	65535f73 	ldrbvs	r5, [r3, #-3955]	; 0xfffff08d
     b28:	63697672 	cmnvs	r9, #119537664	; 0x7200000
     b2c:	6a6a6a65 	bvs	1a9b4c8 <__bss_end+0x1a9118c>
     b30:	54313152 	ldrtpl	r3, [r1], #-338	; 0xfffffeae
     b34:	5f495753 	svcpl	0x00495753
     b38:	75736552 	ldrbvc	r6, [r3, #-1362]!	; 0xfffffaae
     b3c:	5300746c 	movwpl	r7, #1132	; 0x46c
     b40:	505f7465 	subspl	r7, pc, r5, ror #8
     b44:	6c657869 	stclvs	8, cr7, [r5], #-420	; 0xfffffe5c
     b48:	68637300 	stmdavs	r3!, {r8, r9, ip, sp, lr}^
     b4c:	635f6465 	cmpvs	pc, #1694498816	; 0x65000000
     b50:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
     b54:	75007265 	strvc	r7, [r0, #-613]	; 0xfffffd9b
     b58:	6769736e 	strbvs	r7, [r9, -lr, ror #6]!
     b5c:	2064656e 	rsbcs	r6, r4, lr, ror #10
     b60:	72616863 	rsbvc	r6, r1, #6488064	; 0x630000
     b64:	6c614d00 	stclvs	13, cr4, [r1], #-0
     b68:	00636f6c 	rsbeq	r6, r3, ip, ror #30
     b6c:	65746e49 	ldrbvs	r6, [r4, #-3657]!	; 0xfffff1b7
     b70:	70757272 	rsbsvc	r7, r5, r2, ror r2
     b74:	6c626174 	stfvse	f6, [r2], #-464	; 0xfffffe30
     b78:	6c535f65 	mrrcvs	15, 6, r5, r3, cr5
     b7c:	00706565 	rsbseq	r6, r0, r5, ror #10
     b80:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     b84:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
     b88:	0052525f 	subseq	r5, r2, pc, asr r2
     b8c:	5f585541 	svcpl	0x00585541
     b90:	65736142 	ldrbvs	r6, [r3, #-322]!	; 0xfffffebe
     b94:	43534200 	cmpmi	r3, #0, 4
     b98:	61425f32 	cmpvs	r2, r2, lsr pc
     b9c:	73006573 	movwvc	r6, #1395	; 0x573
     ba0:	65746174 	ldrbvs	r6, [r4, #-372]!	; 0xfffffe8c
     ba4:	69725700 	ldmdbvs	r2!, {r8, r9, sl, ip, lr}^
     ba8:	4f5f6574 	svcmi	0x005f6574
     bac:	00796c6e 	rsbseq	r6, r9, lr, ror #24
     bb0:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     bb4:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
     bb8:	63695400 	cmnvs	r9, #0, 8
     bbc:	6f435f6b 	svcvs	0x00435f6b
     bc0:	00746e75 	rsbseq	r6, r4, r5, ror lr
     bc4:	65657246 	strbvs	r7, [r5, #-582]!	; 0xfffffdba
     bc8:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     bcc:	4f433331 	svcmi	0x00433331
     bd0:	5f44454c 	svcpl	0x0044454c
     bd4:	70736944 	rsbsvc	r6, r3, r4, asr #18
     bd8:	3979616c 	ldmdbcc	r9!, {r2, r3, r5, r6, r8, sp, lr}^
     bdc:	5f746553 	svcpl	0x00746553
     be0:	65786950 	ldrbvs	r6, [r8, #-2384]!	; 0xfffff6b0
     be4:	7474456c 	ldrbtvc	r4, [r4], #-1388	; 0xfffffa94
     be8:	5a5f0062 	bpl	17c0d78 <__bss_end+0x17b6a3c>
     bec:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     bf0:	636f7250 	cmnvs	pc, #80, 4
     bf4:	5f737365 	svcpl	0x00737365
     bf8:	616e614d 	cmnvs	lr, sp, asr #2
     bfc:	31726567 	cmncc	r2, r7, ror #10
     c00:	6d6e5538 	cfstr64vs	mvdx5, [lr, #-224]!	; 0xffffff20
     c04:	465f7061 	ldrbmi	r7, [pc], -r1, rrx
     c08:	5f656c69 	svcpl	0x00656c69
     c0c:	72727543 	rsbsvc	r7, r2, #281018368	; 0x10c00000
     c10:	45746e65 	ldrbmi	r6, [r4, #-3685]!	; 0xfffff19b
     c14:	6253006a 	subsvs	r0, r3, #106	; 0x6a
     c18:	48006b72 	stmdami	r0, {r1, r4, r5, r6, r8, r9, fp, sp, lr}
     c1c:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     c20:	69465f65 	stmdbvs	r6, {r0, r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     c24:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
     c28:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
     c2c:	4957535f 	ldmdbmi	r7, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     c30:	6f687300 	svcvs	0x00687300
     c34:	75207472 	strvc	r7, [r0, #-1138]!	; 0xfffffb8e
     c38:	6769736e 	strbvs	r7, [r9, -lr, ror #6]!
     c3c:	2064656e 	rsbcs	r6, r4, lr, ror #10
     c40:	00746e69 	rsbseq	r6, r4, r9, ror #28
     c44:	70736964 	rsbsvc	r6, r3, r4, ror #18
     c48:	74755000 	ldrbtvc	r5, [r5], #-0
     c4c:	7274535f 	rsbsvc	r5, r4, #2080374785	; 0x7c000001
     c50:	00676e69 	rsbeq	r6, r7, r9, ror #28
     c54:	70616568 	rsbvc	r6, r1, r8, ror #10
     c58:	6174735f 	cmnvs	r4, pc, asr r3
     c5c:	49007472 	stmdbmi	r0, {r1, r4, r5, r6, sl, ip, sp, lr}
     c60:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
     c64:	74707572 	ldrbtvc	r7, [r0], #-1394	; 0xfffffa8e
     c68:	6e6f435f 	mcrvs	3, 3, r4, cr15, cr15, {2}
     c6c:	6c6f7274 	sfmvs	f7, 2, [pc], #-464	; aa4 <shift+0xaa4>
     c70:	5f72656c 	svcpl	0x0072656c
     c74:	65736142 	ldrbvs	r6, [r3, #-322]!	; 0xfffffebe
     c78:	61655200 	cmnvs	r5, r0, lsl #4
     c7c:	72575f64 	subsvc	r5, r7, #100, 30	; 0x190
     c80:	00657469 	rsbeq	r7, r5, r9, ror #8
     c84:	69746341 	ldmdbvs	r4!, {r0, r6, r8, r9, sp, lr}^
     c88:	505f6576 	subspl	r6, pc, r6, ror r5	; <UNPREDICTABLE>
     c8c:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     c90:	435f7373 	cmpmi	pc, #-872415231	; 0xcc000001
     c94:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
     c98:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     c9c:	50433631 	subpl	r3, r3, r1, lsr r6
     ca0:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     ca4:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; ae0 <shift+0xae0>
     ca8:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     cac:	31327265 	teqcc	r2, r5, ror #4
     cb0:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     cb4:	465f656c 	ldrbmi	r6, [pc], -ip, ror #10
     cb8:	73656c69 	cmnvc	r5, #26880	; 0x6900
     cbc:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     cc0:	57535f6d 	ldrbpl	r5, [r3, -sp, ror #30]
     cc4:	33324549 	teqcc	r2, #306184192	; 0x12400000
     cc8:	4957534e 	ldmdbmi	r7, {r1, r2, r3, r6, r8, r9, ip, lr}^
     ccc:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     cd0:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     cd4:	5f6d6574 	svcpl	0x006d6574
     cd8:	76726553 			; <UNDEFINED> instruction: 0x76726553
     cdc:	6a656369 	bvs	1959a88 <__bss_end+0x194f74c>
     ce0:	31526a6a 	cmpcc	r2, sl, ror #20
     ce4:	57535431 	smmlarpl	r3, r1, r4, r5
     ce8:	65525f49 	ldrbvs	r5, [r2, #-3913]	; 0xfffff0b7
     cec:	746c7573 	strbtvc	r7, [ip], #-1395	; 0xfffffa8d
     cf0:	6f6c6300 	svcvs	0x006c6300
     cf4:	53006573 	movwpl	r6, #1395	; 0x573
     cf8:	525f7465 	subspl	r7, pc, #1694498816	; 0x65000000
     cfc:	74616c65 	strbtvc	r6, [r1], #-3173	; 0xfffff39b
     d00:	00657669 	rsbeq	r7, r5, r9, ror #12
     d04:	76746572 			; <UNDEFINED> instruction: 0x76746572
     d08:	6e006c61 	cdpvs	12, 0, cr6, cr0, cr1, {3}
     d0c:	00727563 	rsbseq	r7, r2, r3, ror #10
     d10:	65706970 	ldrbvs	r6, [r0, #-2416]!	; 0xfffff690
     d14:	6e647200 	cdpvs	2, 6, cr7, cr4, cr0, {0}
     d18:	5f006d75 	svcpl	0x00006d75
     d1c:	7331315a 	teqvc	r1, #-2147483626	; 0x80000016
     d20:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     d24:	6569795f 	strbvs	r7, [r9, #-2399]!	; 0xfffff6a1
     d28:	0076646c 	rsbseq	r6, r6, ip, ror #8
     d2c:	37315a5f 			; <UNDEFINED> instruction: 0x37315a5f
     d30:	5f746573 	svcpl	0x00746573
     d34:	6b736174 	blvs	1cd930c <__bss_end+0x1ccefd0>
     d38:	6165645f 	cmnvs	r5, pc, asr r4
     d3c:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
     d40:	77006a65 	strvc	r6, [r0, -r5, ror #20]
     d44:	00746961 	rsbseq	r6, r4, r1, ror #18
     d48:	6e365a5f 			; <UNDEFINED> instruction: 0x6e365a5f
     d4c:	6669746f 	strbtvs	r7, [r9], -pc, ror #8
     d50:	006a6a79 	rsbeq	r6, sl, r9, ror sl
     d54:	6c696146 	stfvse	f6, [r9], #-280	; 0xfffffee8
     d58:	69786500 	ldmdbvs	r8!, {r8, sl, sp, lr}^
     d5c:	646f6374 	strbtvs	r6, [pc], #-884	; d64 <shift+0xd64>
     d60:	63730065 	cmnvs	r3, #101	; 0x65
     d64:	5f646568 	svcpl	0x00646568
     d68:	6c656979 			; <UNDEFINED> instruction: 0x6c656979
     d6c:	69740064 	ldmdbvs	r4!, {r2, r5, r6}^
     d70:	635f6b63 	cmpvs	pc, #101376	; 0x18c00
     d74:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
     d78:	7165725f 	cmnvc	r5, pc, asr r2
     d7c:	65726975 	ldrbvs	r6, [r2, #-2421]!	; 0xfffff68b
     d80:	5a5f0064 	bpl	17c0f18 <__bss_end+0x17b6bdc>
     d84:	65673432 	strbvs	r3, [r7, #-1074]!	; 0xfffffbce
     d88:	63615f74 	cmnvs	r1, #116, 30	; 0x1d0
     d8c:	65766974 	ldrbvs	r6, [r6, #-2420]!	; 0xfffff68c
     d90:	6f72705f 	svcvs	0x0072705f
     d94:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     d98:	756f635f 	strbvc	r6, [pc, #-863]!	; a41 <shift+0xa41>
     d9c:	0076746e 	rsbseq	r7, r6, lr, ror #8
     da0:	65706950 	ldrbvs	r6, [r0, #-2384]!	; 0xfffff6b0
     da4:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     da8:	72505f65 	subsvc	r5, r0, #404	; 0x194
     dac:	78696665 	stmdavc	r9!, {r0, r2, r5, r6, r9, sl, sp, lr}^
     db0:	74655300 	strbtvc	r5, [r5], #-768	; 0xfffffd00
     db4:	7261505f 	rsbvc	r5, r1, #95	; 0x5f
     db8:	00736d61 	rsbseq	r6, r3, r1, ror #26
     dbc:	34315a5f 	ldrtcc	r5, [r1], #-2655	; 0xfffff5a1
     dc0:	5f746567 	svcpl	0x00746567
     dc4:	6b636974 	blvs	18db39c <__bss_end+0x18d1060>
     dc8:	756f635f 	strbvc	r6, [pc, #-863]!	; a71 <shift+0xa71>
     dcc:	0076746e 	rsbseq	r7, r6, lr, ror #8
     dd0:	65656c73 	strbvs	r6, [r5, #-3187]!	; 0xfffff38d
     dd4:	69440070 	stmdbvs	r4, {r4, r5, r6}^
     dd8:	6c626173 	stfvse	f6, [r2], #-460	; 0xfffffe34
     ddc:	76455f65 	strbvc	r5, [r5], -r5, ror #30
     de0:	5f746e65 	svcpl	0x00746e65
     de4:	65746544 	ldrbvs	r6, [r4, #-1348]!	; 0xfffffabc
     de8:	6f697463 	svcvs	0x00697463
     dec:	5a5f006e 	bpl	17c0fac <__bss_end+0x17b6c70>
     df0:	72657439 	rsbvc	r7, r5, #956301312	; 0x39000000
     df4:	616e696d 	cmnvs	lr, sp, ror #18
     df8:	00696574 	rsbeq	r6, r9, r4, ror r5
     dfc:	7265706f 	rsbvc	r7, r5, #111	; 0x6f
     e00:	6f697461 	svcvs	0x00697461
     e04:	5a5f006e 	bpl	17c0fc4 <__bss_end+0x17b6c88>
     e08:	6f6c6335 	svcvs	0x006c6335
     e0c:	006a6573 	rsbeq	r6, sl, r3, ror r5
     e10:	67365a5f 			; <UNDEFINED> instruction: 0x67365a5f
     e14:	69707465 	ldmdbvs	r0!, {r0, r2, r5, r6, sl, ip, sp, lr}^
     e18:	66007664 	strvs	r7, [r0], -r4, ror #12
     e1c:	656d616e 	strbvs	r6, [sp, #-366]!	; 0xfffffe92
     e20:	554e4700 	strbpl	r4, [lr, #-1792]	; 0xfffff900
     e24:	2b2b4320 	blcs	ad1aac <__bss_end+0xac7770>
     e28:	31203431 			; <UNDEFINED> instruction: 0x31203431
     e2c:	2e332e30 	mrccs	14, 1, r2, cr3, cr0, {1}
     e30:	30322031 	eorscc	r2, r2, r1, lsr r0
     e34:	36303132 			; <UNDEFINED> instruction: 0x36303132
     e38:	28203132 	stmdacs	r0!, {r1, r4, r5, r8, ip, sp}
     e3c:	656c6572 	strbvs	r6, [ip, #-1394]!	; 0xfffffa8e
     e40:	29657361 	stmdbcs	r5!, {r0, r5, r6, r8, r9, ip, sp, lr}^
     e44:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
     e48:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
     e4c:	6962612d 	stmdbvs	r2!, {r0, r2, r3, r5, r8, sp, lr}^
     e50:	7261683d 	rsbvc	r6, r1, #3997696	; 0x3d0000
     e54:	6d2d2064 	stcvs	0, cr2, [sp, #-400]!	; 0xfffffe70
     e58:	3d757066 	ldclcc	0, cr7, [r5, #-408]!	; 0xfffffe68
     e5c:	20706676 	rsbscs	r6, r0, r6, ror r6
     e60:	6c666d2d 	stclvs	13, cr6, [r6], #-180	; 0xffffff4c
     e64:	2d74616f 	ldfcse	f6, [r4, #-444]!	; 0xfffffe44
     e68:	3d696261 	sfmcc	f6, 2, [r9, #-388]!	; 0xfffffe7c
     e6c:	64726168 	ldrbtvs	r6, [r2], #-360	; 0xfffffe98
     e70:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
     e74:	763d7570 			; <UNDEFINED> instruction: 0x763d7570
     e78:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
     e7c:	6e75746d 	cdpvs	4, 7, cr7, cr5, cr13, {3}
     e80:	72613d65 	rsbvc	r3, r1, #6464	; 0x1940
     e84:	3731316d 	ldrcc	r3, [r1, -sp, ror #2]!
     e88:	667a6a36 			; <UNDEFINED> instruction: 0x667a6a36
     e8c:	2d20732d 	stccs	3, cr7, [r0, #-180]!	; 0xffffff4c
     e90:	6d72616d 	ldfvse	f6, [r2, #-436]!	; 0xfffffe4c
     e94:	616d2d20 	cmnvs	sp, r0, lsr #26
     e98:	3d686372 	stclcc	3, cr6, [r8, #-456]!	; 0xfffffe38
     e9c:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
     ea0:	2b6b7a36 	blcs	1adf780 <__bss_end+0x1ad5444>
     ea4:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
     ea8:	672d2067 	strvs	r2, [sp, -r7, rrx]!
     eac:	20672d20 	rsbcs	r2, r7, r0, lsr #26
     eb0:	20304f2d 	eorscs	r4, r0, sp, lsr #30
     eb4:	20304f2d 	eorscs	r4, r0, sp, lsr #30
     eb8:	6f6e662d 	svcvs	0x006e662d
     ebc:	6378652d 	cmnvs	r8, #188743680	; 0xb400000
     ec0:	69747065 	ldmdbvs	r4!, {r0, r2, r5, r6, ip, sp, lr}^
     ec4:	20736e6f 	rsbscs	r6, r3, pc, ror #28
     ec8:	6f6e662d 	svcvs	0x006e662d
     ecc:	7474722d 	ldrbtvc	r7, [r4], #-557	; 0xfffffdd3
     ed0:	72770069 	rsbsvc	r0, r7, #105	; 0x69
     ed4:	00657469 	rsbeq	r7, r5, r9, ror #8
     ed8:	6b636974 	blvs	18db4b0 <__bss_end+0x18d1174>
     edc:	706f0073 	rsbvc	r0, pc, r3, ror r0	; <UNPREDICTABLE>
     ee0:	5f006e65 	svcpl	0x00006e65
     ee4:	6970345a 	ldmdbvs	r0!, {r1, r3, r4, r6, sl, ip, sp}^
     ee8:	4b506570 	blmi	141a4b0 <__bss_end+0x1410174>
     eec:	4e006a63 	vmlsmi.f32	s12, s0, s7
     ef0:	64616544 	strbtvs	r6, [r1], #-1348	; 0xfffffabc
     ef4:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
     ef8:	6275535f 	rsbsvs	r5, r5, #2080374785	; 0x7c000001
     efc:	76726573 			; <UNDEFINED> instruction: 0x76726573
     f00:	00656369 	rsbeq	r6, r5, r9, ror #6
     f04:	5f746567 	svcpl	0x00746567
     f08:	6b636974 	blvs	18db4e0 <__bss_end+0x18d11a4>
     f0c:	756f635f 	strbvc	r6, [pc, #-863]!	; bb5 <shift+0xbb5>
     f10:	7000746e 	andvc	r7, r0, lr, ror #8
     f14:	6d617261 	sfmvs	f7, 2, [r1, #-388]!	; 0xfffffe7c
     f18:	355a5f00 	ldrbcc	r5, [sl, #-3840]	; 0xfffff100
     f1c:	74697277 	strbtvc	r7, [r9], #-631	; 0xfffffd89
     f20:	4b506a65 	blmi	141b8bc <__bss_end+0x1411580>
     f24:	67006a63 	strvs	r6, [r0, -r3, ror #20]
     f28:	745f7465 	ldrbvc	r7, [pc], #-1125	; f30 <shift+0xf30>
     f2c:	5f6b7361 	svcpl	0x006b7361
     f30:	6b636974 	blvs	18db508 <__bss_end+0x18d11cc>
     f34:	6f745f73 	svcvs	0x00745f73
     f38:	6165645f 	cmnvs	r5, pc, asr r4
     f3c:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
     f40:	75620065 	strbvc	r0, [r2, #-101]!	; 0xffffff9b
     f44:	69735f66 	ldmdbvs	r3!, {r1, r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     f48:	2f00657a 	svccs	0x0000657a
     f4c:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
     f50:	6572742f 	ldrbvs	r7, [r2, #-1071]!	; 0xfffffbd1
     f54:	2f6c6966 	svccs	0x006c6966
     f58:	2f6d6573 	svccs	0x006d6573
     f5c:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
     f60:	2f736563 	svccs	0x00736563
     f64:	6c697562 	cfstr64vs	mvdx7, [r9], #-392	; 0xfffffe78
     f68:	65730064 	ldrbvs	r0, [r3, #-100]!	; 0xffffff9c
     f6c:	61745f74 	cmnvs	r4, r4, ror pc
     f70:	645f6b73 	ldrbvs	r6, [pc], #-2931	; f78 <shift+0xf78>
     f74:	6c646165 	stfvse	f6, [r4], #-404	; 0xfffffe6c
     f78:	00656e69 	rsbeq	r6, r5, r9, ror #28
     f7c:	5f746547 	svcpl	0x00746547
     f80:	61726150 	cmnvs	r2, r0, asr r1
     f84:	5f00736d 	svcpl	0x0000736d
     f88:	6c73355a 	cfldr64vs	mvdx3, [r3], #-360	; 0xfffffe98
     f8c:	6a706565 	bvs	1c1a528 <__bss_end+0x1c101ec>
     f90:	6547006a 	strbvs	r0, [r7, #-106]	; 0xffffff96
     f94:	65525f74 	ldrbvs	r5, [r2, #-3956]	; 0xfffff08c
     f98:	6e69616d 	powvsez	f6, f1, #5.0
     f9c:	00676e69 	rsbeq	r6, r7, r9, ror #28
     fa0:	62616e45 	rsbvs	r6, r1, #1104	; 0x450
     fa4:	455f656c 	ldrbmi	r6, [pc, #-1388]	; a40 <shift+0xa40>
     fa8:	746e6576 	strbtvc	r6, [lr], #-1398	; 0xfffffa8a
     fac:	7465445f 	strbtvc	r4, [r5], #-1119	; 0xfffffba1
     fb0:	69746365 	ldmdbvs	r4!, {r0, r2, r5, r6, r8, r9, sp, lr}^
     fb4:	5f006e6f 	svcpl	0x00006e6f
     fb8:	6736325a 			; <UNDEFINED> instruction: 0x6736325a
     fbc:	745f7465 	ldrbvc	r7, [pc], #-1125	; fc4 <shift+0xfc4>
     fc0:	5f6b7361 	svcpl	0x006b7361
     fc4:	6b636974 	blvs	18db59c <__bss_end+0x18d1260>
     fc8:	6f745f73 	svcvs	0x00745f73
     fcc:	6165645f 	cmnvs	r5, pc, asr r4
     fd0:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
     fd4:	2f007665 	svccs	0x00007665
     fd8:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
     fdc:	6572742f 	ldrbvs	r7, [r2, #-1071]!	; 0xfffffbd1
     fe0:	2f6c6966 	svccs	0x006c6966
     fe4:	2f6d6573 	svccs	0x006d6573
     fe8:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
     fec:	2f736563 	svccs	0x00736563
     ff0:	6c647473 	cfstrdvs	mvd7, [r4], #-460	; 0xfffffe34
     ff4:	732f6269 			; <UNDEFINED> instruction: 0x732f6269
     ff8:	732f6372 			; <UNDEFINED> instruction: 0x732f6372
     ffc:	69666474 	stmdbvs	r6!, {r2, r4, r5, r6, sl, sp, lr}^
    1000:	632e656c 			; <UNDEFINED> instruction: 0x632e656c
    1004:	4e007070 	mcrmi	0, 0, r7, cr0, cr0, {3}
    1008:	5f495753 	svcpl	0x00495753
    100c:	75736552 	ldrbvc	r6, [r3, #-1362]!	; 0xfffffaae
    1010:	435f746c 	cmpmi	pc, #108, 8	; 0x6c000000
    1014:	0065646f 	rsbeq	r6, r5, pc, ror #8
    1018:	756e7277 	strbvc	r7, [lr, #-631]!	; 0xfffffd89
    101c:	5a5f006d 	bpl	17c11d8 <__bss_end+0x17b6e9c>
    1020:	69617734 	stmdbvs	r1!, {r2, r4, r5, r8, r9, sl, ip, sp, lr}^
    1024:	6a6a6a74 	bvs	1a9b9fc <__bss_end+0x1a916c0>
    1028:	355a5f00 	ldrbcc	r5, [sl, #-3840]	; 0xfffff100
    102c:	74636f69 	strbtvc	r6, [r3], #-3945	; 0xfffff097
    1030:	36316a6c 	ldrtcc	r6, [r1], -ip, ror #20
    1034:	434f494e 	movtmi	r4, #63822	; 0xf94e
    1038:	4f5f6c74 	svcmi	0x005f6c74
    103c:	61726570 	cmnvs	r2, r0, ror r5
    1040:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
    1044:	69007650 	stmdbvs	r0, {r4, r6, r9, sl, ip, sp, lr}
    1048:	6c74636f 	ldclvs	3, cr6, [r4], #-444	; 0xfffffe44
    104c:	74657200 	strbtvc	r7, [r5], #-512	; 0xfffffe00
    1050:	00746e63 	rsbseq	r6, r4, r3, ror #28
    1054:	69746f6e 	ldmdbvs	r4!, {r1, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
    1058:	74007966 	strvc	r7, [r0], #-2406	; 0xfffff69a
    105c:	696d7265 	stmdbvs	sp!, {r0, r2, r5, r6, r9, ip, sp, lr}^
    1060:	6574616e 	ldrbvs	r6, [r4, #-366]!	; 0xfffffe92
    1064:	646f6d00 	strbtvs	r6, [pc], #-3328	; 106c <shift+0x106c>
    1068:	75620065 	strbvc	r0, [r2, #-101]!	; 0xffffff9b
    106c:	72656666 	rsbvc	r6, r5, #106954752	; 0x6600000
    1070:	345a5f00 	ldrbcc	r5, [sl], #-3840	; 0xfffff100
    1074:	64616572 	strbtvs	r6, [r1], #-1394	; 0xfffffa8e
    1078:	6a63506a 	bvs	18d5228 <__bss_end+0x18caeec>
    107c:	4f494e00 	svcmi	0x00494e00
    1080:	5f6c7443 	svcpl	0x006c7443
    1084:	7265704f 	rsbvc	r7, r5, #79	; 0x4f
    1088:	6f697461 	svcvs	0x00697461
    108c:	6572006e 	ldrbvs	r0, [r2, #-110]!	; 0xffffff92
    1090:	646f6374 	strbtvs	r6, [pc], #-884	; 1098 <shift+0x1098>
    1094:	65670065 	strbvs	r0, [r7, #-101]!	; 0xffffff9b
    1098:	63615f74 	cmnvs	r1, #116, 30	; 0x1d0
    109c:	65766974 	ldrbvs	r6, [r6, #-2420]!	; 0xfffff68c
    10a0:	6f72705f 	svcvs	0x0072705f
    10a4:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    10a8:	756f635f 	strbvc	r6, [pc, #-863]!	; d51 <shift+0xd51>
    10ac:	6600746e 	strvs	r7, [r0], -lr, ror #8
    10b0:	6e656c69 	cdpvs	12, 6, cr6, cr5, cr9, {3}
    10b4:	00656d61 	rsbeq	r6, r5, r1, ror #26
    10b8:	64616572 	strbtvs	r6, [r1], #-1394	; 0xfffffa8e
    10bc:	74656700 	strbtvc	r6, [r5], #-1792	; 0xfffff900
    10c0:	00646970 	rsbeq	r6, r4, r0, ror r9
    10c4:	6f345a5f 	svcvs	0x00345a5f
    10c8:	506e6570 	rsbpl	r6, lr, r0, ror r5
    10cc:	3531634b 	ldrcc	r6, [r1, #-843]!	; 0xfffffcb5
    10d0:	6c69464e 	stclvs	6, cr4, [r9], #-312	; 0xfffffec8
    10d4:	704f5f65 	subvc	r5, pc, r5, ror #30
    10d8:	4d5f6e65 	ldclmi	14, cr6, [pc, #-404]	; f4c <shift+0xf4c>
    10dc:	0065646f 	rsbeq	r6, r5, pc, ror #8
    10e0:	73375a5f 	teqvc	r7, #389120	; 0x5f000
    10e4:	636e7274 	cmnvs	lr, #116, 4	; 0x40000007
    10e8:	63507970 	cmpvs	r0, #112, 18	; 0x1c0000
    10ec:	69634b50 	stmdbvs	r3!, {r4, r6, r8, r9, fp, lr}^
    10f0:	365a5f00 	ldrbcc	r5, [sl], -r0, lsl #30
    10f4:	636d656d 	cmnvs	sp, #457179136	; 0x1b400000
    10f8:	4b507970 	blmi	141f6c0 <__bss_end+0x1415384>
    10fc:	69765076 	ldmdbvs	r6!, {r1, r2, r4, r5, r6, ip, lr}^
    1100:	315a5f00 	cmpcc	sl, r0, lsl #30
    1104:	74656734 	strbtvc	r6, [r5], #-1844	; 0xfffff8cc
    1108:	706e695f 	rsbvc	r6, lr, pc, asr r9
    110c:	745f7475 	ldrbvc	r7, [pc], #-1141	; 1114 <shift+0x1114>
    1110:	50657079 	rsbpl	r7, r5, r9, ror r0
    1114:	5f00634b 	svcpl	0x0000634b
    1118:	5f6e345a 	svcpl	0x006e345a
    111c:	69697574 	stmdbvs	r9!, {r2, r4, r5, r6, r8, sl, ip, sp, lr}^
    1120:	6f746100 	svcvs	0x00746100
    1124:	65670066 	strbvs	r0, [r7, #-102]!	; 0xffffff9a
    1128:	6e695f74 	mcrvs	15, 3, r5, cr9, cr4, {3}
    112c:	5f747570 	svcpl	0x00747570
    1130:	65707974 	ldrbvs	r7, [r0, #-2420]!	; 0xfffff68c
    1134:	6f746100 	svcvs	0x00746100
    1138:	5a5f0069 	bpl	17c12e4 <__bss_end+0x17b6fa8>
    113c:	6f746134 	svcvs	0x00746134
    1140:	634b5066 	movtvs	r5, #45158	; 0xb066
    1144:	73656400 	cmnvc	r5, #0, 8
    1148:	6e690074 	mcrvs	0, 3, r0, cr9, cr4, {3}
    114c:	00747570 	rsbseq	r7, r4, r0, ror r5
    1150:	6e676973 			; <UNDEFINED> instruction: 0x6e676973
    1154:	72747300 	rsbsvc	r7, r4, #0, 6
    1158:	00746163 	rsbseq	r6, r4, r3, ror #2
    115c:	62355a5f 	eorsvs	r5, r5, #389120	; 0x5f000
    1160:	6f72657a 	svcvs	0x0072657a
    1164:	00697650 	rsbeq	r7, r9, r0, asr r6
    1168:	6e727473 	mrcvs	4, 3, r7, cr2, cr3, {3}
    116c:	00797063 	rsbseq	r7, r9, r3, rrx
    1170:	73365a5f 	teqvc	r6, #389120	; 0x5f000
    1174:	61637274 	smcvs	14116	; 0x3724
    1178:	50635074 	rsbpl	r5, r3, r4, ror r0
    117c:	2f00634b 	svccs	0x0000634b
    1180:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
    1184:	6572742f 	ldrbvs	r7, [r2, #-1071]!	; 0xfffffbd1
    1188:	2f6c6966 	svccs	0x006c6966
    118c:	2f6d6573 	svccs	0x006d6573
    1190:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
    1194:	2f736563 	svccs	0x00736563
    1198:	6c647473 	cfstrdvs	mvd7, [r4], #-460	; 0xfffffe34
    119c:	732f6269 			; <UNDEFINED> instruction: 0x732f6269
    11a0:	732f6372 			; <UNDEFINED> instruction: 0x732f6372
    11a4:	74736474 	ldrbtvc	r6, [r3], #-1140	; 0xfffffb8c
    11a8:	676e6972 			; <UNDEFINED> instruction: 0x676e6972
    11ac:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
    11b0:	72747300 	rsbsvc	r7, r4, #0, 6
    11b4:	7461636e 	strbtvc	r6, [r1], #-878	; 0xfffffc92
    11b8:	6c617700 	stclvs	7, cr7, [r1], #-0
    11bc:	0072656b 	rsbseq	r6, r2, fp, ror #10
    11c0:	74636166 	strbtvc	r6, [r3], #-358	; 0xfffffe9a
    11c4:	6900726f 	stmdbvs	r0, {r0, r1, r2, r3, r5, r6, r9, ip, sp, lr}
    11c8:	00616f74 	rsbeq	r6, r1, r4, ror pc
    11cc:	69736f70 	ldmdbvs	r3!, {r4, r5, r6, r8, r9, sl, fp, sp, lr}^
    11d0:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
    11d4:	6d656d00 	stclvs	13, cr6, [r5, #-0]
    11d8:	00747364 	rsbseq	r7, r4, r4, ror #6
    11dc:	72616843 	rsbvc	r6, r1, #4390912	; 0x430000
    11e0:	766e6f43 	strbtvc	r6, [lr], -r3, asr #30
    11e4:	00727241 	rsbseq	r7, r2, r1, asr #4
    11e8:	616f7466 	cmnvs	pc, r6, ror #8
    11ec:	6d756e00 	ldclvs	14, cr6, [r5, #-0]
    11f0:	00726562 	rsbseq	r6, r2, r2, ror #10
    11f4:	736d656d 	cmnvc	sp, #457179136	; 0x1b400000
    11f8:	6e006372 	mcrvs	3, 0, r6, cr0, cr2, {3}
    11fc:	65626d75 	strbvs	r6, [r2, #-3445]!	; 0xfffff28b
    1200:	61003272 	tstvs	r0, r2, ror r2
    1204:	72657466 	rsbvc	r7, r5, #1711276032	; 0x66000000
    1208:	50636544 	rsbpl	r6, r3, r4, asr #10
    120c:	746e696f 	strbtvc	r6, [lr], #-2415	; 0xfffff691
    1210:	657a6200 	ldrbvs	r6, [sl, #-512]!	; 0xfffffe00
    1214:	6d006f72 	stcvs	15, cr6, [r0, #-456]	; 0xfffffe38
    1218:	70636d65 	rsbvc	r6, r3, r5, ror #26
    121c:	74730079 	ldrbtvc	r0, [r3], #-121	; 0xffffff87
    1220:	6d636e72 	stclvs	14, cr6, [r3, #-456]!	; 0xfffffe38
    1224:	72740070 	rsbsvc	r0, r4, #112	; 0x70
    1228:	696c6961 	stmdbvs	ip!, {r0, r5, r6, r8, fp, sp, lr}^
    122c:	645f676e 	ldrbvs	r6, [pc], #-1902	; 1234 <shift+0x1234>
    1230:	6f00746f 	svcvs	0x0000746f
    1234:	75707475 	ldrbvc	r7, [r0, #-1141]!	; 0xfffffb8b
    1238:	656c0074 	strbvs	r0, [ip, #-116]!	; 0xffffff8c
    123c:	6874676e 	ldmdavs	r4!, {r1, r2, r3, r5, r6, r8, r9, sl, sp, lr}^
    1240:	5f6e0032 	svcpl	0x006e0032
    1244:	5f007574 	svcpl	0x00007574
    1248:	7473365a 	ldrbtvc	r3, [r3], #-1626	; 0xfffff9a6
    124c:	6e656c72 	mcrvs	12, 3, r6, cr5, cr2, {3}
    1250:	00634b50 	rsbeq	r4, r3, r0, asr fp
    1254:	73375a5f 	teqvc	r7, #389120	; 0x5f000
    1258:	636e7274 	cmnvs	lr, #116, 4	; 0x40000007
    125c:	4b50706d 	blmi	141d418 <__bss_end+0x14130dc>
    1260:	5f305363 	svcpl	0x00305363
    1264:	5a5f0069 	bpl	17c1410 <__bss_end+0x17b70d4>
    1268:	6f746134 	svcvs	0x00746134
    126c:	634b5069 	movtvs	r5, #45161	; 0xb069
    1270:	345a5f00 	ldrbcc	r5, [sl], #-3840	; 0xfffff100
    1274:	616f7469 	cmnvs	pc, r9, ror #8
    1278:	6a635069 	bvs	18d5424 <__bss_end+0x18cb0e8>
    127c:	345a5f00 	ldrbcc	r5, [sl], #-3840	; 0xfffff100
    1280:	616f7466 	cmnvs	pc, r6, ror #8
    1284:	00635066 	rsbeq	r5, r3, r6, rrx
    1288:	6f6d656d 	svcvs	0x006d656d
    128c:	6c007972 			; <UNDEFINED> instruction: 0x6c007972
    1290:	74676e65 	strbtvc	r6, [r7], #-3685	; 0xfffff19b
    1294:	74730068 	ldrbtvc	r0, [r3], #-104	; 0xffffff98
    1298:	6e656c72 	mcrvs	12, 3, r6, cr5, cr2, {3}
    129c:	375a5f00 	ldrbcc	r5, [sl, -r0, lsl #30]
    12a0:	6e727473 	mrcvs	4, 3, r7, cr2, cr3, {3}
    12a4:	50746163 	rsbspl	r6, r4, r3, ror #2
    12a8:	634b5063 	movtvs	r5, #45155	; 0xb063
    12ac:	5f5f0069 	svcpl	0x005f0069
    12b0:	635f6e69 	cmpvs	pc, #1680	; 0x690
    12b4:	00677268 	rsbeq	r7, r7, r8, ror #4
    12b8:	73694454 	cmnvc	r9, #84, 8	; 0x54000000
    12bc:	79616c70 	stmdbvc	r1!, {r4, r5, r6, sl, fp, sp, lr}^
    12c0:	6361505f 	cmnvs	r1, #95	; 0x5f
    12c4:	5f74656b 	svcpl	0x0074656b
    12c8:	64616548 	strbtvs	r6, [r1], #-1352	; 0xfffffab8
    12cc:	54007265 	strpl	r7, [r0], #-613	; 0xfffffd9b
    12d0:	70736944 	rsbsvc	r6, r3, r4, asr #18
    12d4:	5f79616c 	svcpl	0x0079616c
    12d8:	506e6f4e 	rsbpl	r6, lr, lr, asr #30
    12dc:	6d617261 	sfmvs	f7, 2, [r1, #-388]!	; 0xfffffe7c
    12e0:	69727465 	ldmdbvs	r2!, {r0, r2, r5, r6, sl, ip, sp, lr}^
    12e4:	61505f63 	cmpvs	r0, r3, ror #30
    12e8:	74656b63 	strbtvc	r6, [r5], #-2915	; 0xfffff49d
    12ec:	69687400 	stmdbvs	r8!, {sl, ip, sp, lr}^
    12f0:	4c4f0073 	mcrrmi	0, 7, r0, pc, cr3
    12f4:	465f4445 	ldrbmi	r4, [pc], -r5, asr #8
    12f8:	5f746e6f 	svcpl	0x00746e6f
    12fc:	61666544 	cmnvs	r6, r4, asr #10
    1300:	00746c75 	rsbseq	r6, r4, r5, ror ip
    1304:	696c6676 	stmdbvs	ip!, {r1, r2, r4, r5, r6, r9, sl, sp, lr}^
    1308:	44540070 	ldrbmi	r0, [r4], #-112	; 0xffffff90
    130c:	6c707369 	ldclvs	3, cr7, [r0], #-420	; 0xfffffe5c
    1310:	445f7961 	ldrbmi	r7, [pc], #-2401	; 1318 <shift+0x1318>
    1314:	5f776172 	svcpl	0x00776172
    1318:	65786950 	ldrbvs	r6, [r8, #-2384]!	; 0xfffff6b0
    131c:	72415f6c 	subvc	r5, r1, #108, 30	; 0x1b0
    1320:	5f796172 	svcpl	0x00796172
    1324:	6b636150 	blvs	18d986c <__bss_end+0x18cf530>
    1328:	44007465 	strmi	r7, [r0], #-1125	; 0xfffffb9b
    132c:	5f776172 	svcpl	0x00776172
    1330:	65786950 	ldrbvs	r6, [r8, #-2384]!	; 0xfffff6b0
    1334:	72415f6c 	subvc	r5, r1, #108, 30	; 0x1b0
    1338:	5f796172 	svcpl	0x00796172
    133c:	525f6f54 	subspl	r6, pc, #84, 30	; 0x150
    1340:	00746365 	rsbseq	r6, r4, r5, ror #6
    1344:	73694454 	cmnvc	r9, #84, 8	; 0x54000000
    1348:	79616c70 	stmdbvc	r1!, {r4, r5, r6, sl, fp, sp, lr}^
    134c:	7869505f 	stmdavc	r9!, {r0, r1, r2, r3, r4, r6, ip, lr}^
    1350:	535f6c65 	cmppl	pc, #25856	; 0x6500
    1354:	00636570 	rsbeq	r6, r3, r0, ror r5
    1358:	68746170 	ldmdavs	r4!, {r4, r5, r6, r8, sp, lr}^
    135c:	69445400 	stmdbvs	r4, {sl, ip, lr}^
    1360:	616c7073 	smcvs	50947	; 0xc703
    1364:	69505f79 	ldmdbvs	r0, {r0, r3, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    1368:	736c6578 	cmnvc	ip, #120, 10	; 0x1e000000
    136c:	5f6f545f 	svcpl	0x006f545f
    1370:	74636552 	strbtvc	r6, [r3], #-1362	; 0xfffffaae
    1374:	61684300 	cmnvs	r8, r0, lsl #6
    1378:	6e455f72 	mcrvs	15, 2, r5, cr5, cr2, {3}
    137c:	72440064 	subvc	r0, r4, #100	; 0x64
    1380:	505f7761 	subspl	r7, pc, r1, ror #14
    1384:	6c657869 	stclvs	8, cr7, [r5], #-420	; 0xfffffe5c
    1388:	7272415f 	rsbsvc	r4, r2, #-1073741801	; 0xc0000017
    138c:	46007961 	strmi	r7, [r0], -r1, ror #18
    1390:	5f70696c 	svcpl	0x0070696c
    1394:	72616843 	rsbvc	r6, r1, #4390912	; 0x430000
    1398:	44540073 	ldrbmi	r0, [r4], #-115	; 0xffffff8d
    139c:	6c707369 	ldclvs	3, cr7, [r0], #-420	; 0xfffffe5c
    13a0:	435f7961 	cmpmi	pc, #1589248	; 0x184000
    13a4:	7261656c 	rsbvc	r6, r1, #108, 10	; 0x1b000000
    13a8:	6361505f 	cmnvs	r1, #95	; 0x5f
    13ac:	0074656b 	rsbseq	r6, r4, fp, ror #10
    13b0:	72616843 	rsbvc	r6, r1, #4390912	; 0x430000
    13b4:	6469575f 	strbtvs	r5, [r9], #-1887	; 0xfffff8a1
    13b8:	4f006874 	svcmi	0x00006874
    13bc:	5f44454c 	svcpl	0x0044454c
    13c0:	746e6f46 	strbtvc	r6, [lr], #-3910	; 0xfffff0ba
    13c4:	69444e00 	stmdbvs	r4, {r9, sl, fp, lr}^
    13c8:	616c7073 	smcvs	50947	; 0xc703
    13cc:	6f435f79 	svcvs	0x00435f79
    13d0:	6e616d6d 	cdpvs	13, 6, cr6, cr1, cr13, {3}
    13d4:	69660064 	stmdbvs	r6!, {r2, r5, r6}^
    13d8:	00747372 	rsbseq	r7, r4, r2, ror r3
    13dc:	61656c63 	cmnvs	r5, r3, ror #24
    13e0:	74655372 	strbtvc	r5, [r5], #-882	; 0xfffffc8e
    13e4:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
    13e8:	4f433331 	svcmi	0x00433331
    13ec:	5f44454c 	svcpl	0x0044454c
    13f0:	70736944 	rsbsvc	r6, r3, r4, asr #18
    13f4:	4379616c 	cmnmi	r9, #108, 2
    13f8:	4b504532 	blmi	14128c8 <__bss_end+0x140858c>
    13fc:	69750063 	ldmdbvs	r5!, {r0, r1, r5, r6}^
    1400:	5f38746e 	svcpl	0x0038746e
    1404:	68430074 	stmdavs	r3, {r2, r4, r5, r6}^
    1408:	485f7261 	ldmdami	pc, {r0, r5, r6, r9, ip, sp, lr}^	; <UNPREDICTABLE>
    140c:	68676965 	stmdavs	r7!, {r0, r2, r5, r6, r8, fp, sp, lr}^
    1410:	65680074 	strbvs	r0, [r8, #-116]!	; 0xffffff8c
    1414:	72656461 	rsbvc	r6, r5, #1627389952	; 0x61000000
    1418:	6f682f00 	svcvs	0x00682f00
    141c:	742f656d 	strtvc	r6, [pc], #-1389	; 1424 <shift+0x1424>
    1420:	69666572 	stmdbvs	r6!, {r1, r4, r5, r6, r8, sl, sp, lr}^
    1424:	65732f6c 	ldrbvs	r2, [r3, #-3948]!	; 0xfffff094
    1428:	6f732f6d 	svcvs	0x00732f6d
    142c:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
    1430:	74732f73 	ldrbtvc	r2, [r3], #-3955	; 0xfffff08d
    1434:	69747564 	ldmdbvs	r4!, {r2, r5, r6, r8, sl, ip, sp, lr}^
    1438:	732f736c 			; <UNDEFINED> instruction: 0x732f736c
    143c:	6f2f6372 	svcvs	0x002f6372
    1440:	2e64656c 	cdpcs	5, 6, cr6, cr4, cr12, {3}
    1444:	00707063 	rsbseq	r7, r0, r3, rrx
    1448:	72616843 	rsbvc	r6, r1, #4390912	; 0x430000
    144c:	6765425f 			; <UNDEFINED> instruction: 0x6765425f
    1450:	5f006e69 	svcpl	0x00006e69
    1454:	33314e5a 	teqcc	r1, #1440	; 0x5a0
    1458:	454c4f43 	strbmi	r4, [ip, #-3907]	; 0xfffff0bd
    145c:	69445f44 	stmdbvs	r4, {r2, r6, r8, r9, sl, fp, ip, lr}^
    1460:	616c7073 	smcvs	50947	; 0xc703
    1464:	45324479 	ldrmi	r4, [r2, #-1145]!	; 0xfffffb87
    1468:	2e2e0076 	mcrcs	0, 1, r0, cr14, cr6, {3}
    146c:	2f2e2e2f 	svccs	0x002e2e2f
    1470:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1474:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1478:	2f2e2e2f 	svccs	0x002e2e2f
    147c:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    1480:	632f6363 			; <UNDEFINED> instruction: 0x632f6363
    1484:	69666e6f 	stmdbvs	r6!, {r0, r1, r2, r3, r5, r6, r9, sl, fp, sp, lr}^
    1488:	72612f67 	rsbvc	r2, r1, #412	; 0x19c
    148c:	696c2f6d 	stmdbvs	ip!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, sp}^
    1490:	75663162 	strbvc	r3, [r6, #-354]!	; 0xfffffe9e
    1494:	2e73636e 	cdpcs	3, 7, cr6, cr3, cr14, {3}
    1498:	622f0053 	eorvs	r0, pc, #83	; 0x53
    149c:	646c6975 	strbtvs	r6, [ip], #-2421	; 0xfffff68b
    14a0:	6363672f 	cmnvs	r3, #12320768	; 0xbc0000
    14a4:	6d72612d 	ldfvse	f6, [r2, #-180]!	; 0xffffff4c
    14a8:	6e6f6e2d 	cdpvs	14, 6, cr6, cr15, cr13, {1}
    14ac:	61652d65 	cmnvs	r5, r5, ror #26
    14b0:	682d6962 	stmdavs	sp!, {r1, r5, r6, r8, fp, sp, lr}
    14b4:	4b676659 	blmi	19dae20 <__bss_end+0x19d0ae4>
    14b8:	63672f34 	cmnvs	r7, #52, 30	; 0xd0
    14bc:	72612d63 	rsbvc	r2, r1, #6336	; 0x18c0
    14c0:	6f6e2d6d 	svcvs	0x006e2d6d
    14c4:	652d656e 	strvs	r6, [sp, #-1390]!	; 0xfffffa92
    14c8:	2d696261 	sfmcs	f6, 2, [r9, #-388]!	; 0xfffffe7c
    14cc:	332e3031 			; <UNDEFINED> instruction: 0x332e3031
    14d0:	3230322d 	eorscc	r3, r0, #-805306366	; 0xd0000002
    14d4:	37302e31 			; <UNDEFINED> instruction: 0x37302e31
    14d8:	6975622f 	ldmdbvs	r5!, {r0, r1, r2, r3, r5, r9, sp, lr}^
    14dc:	612f646c 			; <UNDEFINED> instruction: 0x612f646c
    14e0:	6e2d6d72 	mcrvs	13, 1, r6, cr13, cr2, {3}
    14e4:	2d656e6f 	stclcs	14, cr6, [r5, #-444]!	; 0xfffffe44
    14e8:	69626165 	stmdbvs	r2!, {r0, r2, r5, r6, r8, sp, lr}^
    14ec:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
    14f0:	7435762f 	ldrtvc	r7, [r5], #-1583	; 0xfffff9d1
    14f4:	61682f65 	cmnvs	r8, r5, ror #30
    14f8:	6c2f6472 	cfstrsvs	mvf6, [pc], #-456	; 1338 <shift+0x1338>
    14fc:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    1500:	4e470063 	cdpmi	0, 4, cr0, cr7, cr3, {3}
    1504:	53412055 	movtpl	r2, #4181	; 0x1055
    1508:	332e3220 			; <UNDEFINED> instruction: 0x332e3220
    150c:	2e2e0037 	mcrcs	0, 1, r0, cr14, cr7, {1}
    1510:	2f2e2e2f 	svccs	0x002e2e2f
    1514:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1518:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    151c:	2f2e2e2f 	svccs	0x002e2e2f
    1520:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    1524:	632f6363 			; <UNDEFINED> instruction: 0x632f6363
    1528:	69666e6f 	stmdbvs	r6!, {r0, r1, r2, r3, r5, r6, r9, sl, fp, sp, lr}^
    152c:	72612f67 	rsbvc	r2, r1, #412	; 0x19c
    1530:	65692f6d 	strbvs	r2, [r9, #-3949]!	; 0xfffff093
    1534:	35376565 	ldrcc	r6, [r7, #-1381]!	; 0xfffffa9b
    1538:	66732d34 			; <UNDEFINED> instruction: 0x66732d34
    153c:	2e00532e 	cdpcs	3, 0, cr5, cr0, cr14, {1}
    1540:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1544:	2f2e2e2f 	svccs	0x002e2e2f
    1548:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    154c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1550:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
    1554:	2f636367 	svccs	0x00636367
    1558:	666e6f63 	strbtvs	r6, [lr], -r3, ror #30
    155c:	612f6769 			; <UNDEFINED> instruction: 0x612f6769
    1560:	622f6d72 	eorvs	r6, pc, #7296	; 0x1c80
    1564:	69626170 	stmdbvs	r2!, {r4, r5, r6, r8, sp, lr}^
    1568:	6900532e 	stmdbvs	r0, {r1, r2, r3, r5, r8, r9, ip, lr}
    156c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1570:	705f7469 	subsvc	r7, pc, r9, ror #8
    1574:	72646572 	rsbvc	r6, r4, #478150656	; 0x1c800000
    1578:	69007365 	stmdbvs	r0, {r0, r2, r5, r6, r8, r9, ip, sp, lr}
    157c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1580:	765f7469 	ldrbvc	r7, [pc], -r9, ror #8
    1584:	625f7066 	subsvs	r7, pc, #102	; 0x66
    1588:	00657361 	rsbeq	r7, r5, r1, ror #6
    158c:	706d6f63 	rsbvc	r6, sp, r3, ror #30
    1590:	2078656c 	rsbscs	r6, r8, ip, ror #10
    1594:	616f6c66 	cmnvs	pc, r6, ror #24
    1598:	73690074 	cmnvc	r9, #116	; 0x74
    159c:	6f6e5f61 	svcvs	0x006e5f61
    15a0:	00746962 	rsbseq	r6, r4, r2, ror #18
    15a4:	5f617369 	svcpl	0x00617369
    15a8:	5f746962 	svcpl	0x00746962
    15ac:	5f65766d 	svcpl	0x0065766d
    15b0:	616f6c66 	cmnvs	pc, r6, ror #24
    15b4:	73690074 	cmnvc	r9, #116	; 0x74
    15b8:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    15bc:	70665f74 	rsbvc	r5, r6, r4, ror pc
    15c0:	69003631 	stmdbvs	r0, {r0, r4, r5, r9, sl, ip, sp}
    15c4:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    15c8:	735f7469 	cmpvc	pc, #1761607680	; 0x69000000
    15cc:	69006365 	stmdbvs	r0, {r0, r2, r5, r6, r8, r9, sp, lr}
    15d0:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    15d4:	615f7469 	cmpvs	pc, r9, ror #8
    15d8:	00766964 	rsbseq	r6, r6, r4, ror #18
    15dc:	5f617369 	svcpl	0x00617369
    15e0:	5f746962 	svcpl	0x00746962
    15e4:	72697571 	rsbvc	r7, r9, #473956352	; 0x1c400000
    15e8:	6f6e5f6b 	svcvs	0x006e5f6b
    15ec:	6c6f765f 	stclvs	6, cr7, [pc], #-380	; 1478 <shift+0x1478>
    15f0:	6c697461 	cfstrdvs	mvd7, [r9], #-388	; 0xfffffe7c
    15f4:	65635f65 	strbvs	r5, [r3, #-3941]!	; 0xfffff09b
    15f8:	61736900 	cmnvs	r3, r0, lsl #18
    15fc:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1600:	00706d5f 	rsbseq	r6, r0, pc, asr sp
    1604:	5f617369 	svcpl	0x00617369
    1608:	5f746962 	svcpl	0x00746962
    160c:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    1610:	69007435 	stmdbvs	r0, {r0, r2, r4, r5, sl, ip, sp, lr}
    1614:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1618:	615f7469 	cmpvs	pc, r9, ror #8
    161c:	35766d72 	ldrbcc	r6, [r6, #-3442]!	; 0xfffff28e
    1620:	69006574 	stmdbvs	r0, {r2, r4, r5, r6, r8, sl, sp, lr}
    1624:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1628:	6e5f7469 	cdpvs	4, 5, cr7, cr15, cr9, {3}
    162c:	006e6f65 	rsbeq	r6, lr, r5, ror #30
    1630:	5f617369 	svcpl	0x00617369
    1634:	5f746962 	svcpl	0x00746962
    1638:	36316662 	ldrtcc	r6, [r1], -r2, ror #12
    163c:	53504600 	cmppl	r0, #0, 12
    1640:	455f5243 	ldrbmi	r5, [pc, #-579]	; 1405 <shift+0x1405>
    1644:	004d554e 	subeq	r5, sp, lr, asr #10
    1648:	43535046 	cmpmi	r3, #70	; 0x46
    164c:	7a6e5f52 	bvc	1b9939c <__bss_end+0x1b8f060>
    1650:	63717663 	cmnvs	r1, #103809024	; 0x6300000
    1654:	554e455f 	strbpl	r4, [lr, #-1375]	; 0xfffffaa1
    1658:	5056004d 	subspl	r0, r6, sp, asr #32
    165c:	4e455f52 	mcrmi	15, 2, r5, cr5, cr2, {2}
    1660:	66004d55 			; <UNDEFINED> instruction: 0x66004d55
    1664:	5f746962 	svcpl	0x00746962
    1668:	6c706d69 	ldclvs	13, cr6, [r0], #-420	; 0xfffffe5c
    166c:	74616369 	strbtvc	r6, [r1], #-873	; 0xfffffc97
    1670:	006e6f69 	rsbeq	r6, lr, r9, ror #30
    1674:	455f3050 	ldrbmi	r3, [pc, #-80]	; 162c <shift+0x162c>
    1678:	004d554e 	subeq	r5, sp, lr, asr #10
    167c:	5f617369 	svcpl	0x00617369
    1680:	5f746962 	svcpl	0x00746962
    1684:	70797263 	rsbsvc	r7, r9, r3, ror #4
    1688:	47006f74 	smlsdxmi	r0, r4, pc, r6	; <UNPREDICTABLE>
    168c:	4320554e 			; <UNDEFINED> instruction: 0x4320554e
    1690:	31203731 			; <UNDEFINED> instruction: 0x31203731
    1694:	2e332e30 	mrccs	14, 1, r2, cr3, cr0, {1}
    1698:	30322031 	eorscc	r2, r2, r1, lsr r0
    169c:	36303132 			; <UNDEFINED> instruction: 0x36303132
    16a0:	28203132 	stmdacs	r0!, {r1, r4, r5, r8, ip, sp}
    16a4:	656c6572 	strbvs	r6, [ip, #-1394]!	; 0xfffffa8e
    16a8:	29657361 	stmdbcs	r5!, {r0, r5, r6, r8, r9, ip, sp, lr}^
    16ac:	616d2d20 	cmnvs	sp, r0, lsr #26
    16b0:	2d206d72 	stccs	13, cr6, [r0, #-456]!	; 0xfffffe38
    16b4:	6f6c666d 	svcvs	0x006c666d
    16b8:	612d7461 			; <UNDEFINED> instruction: 0x612d7461
    16bc:	683d6962 	ldmdavs	sp!, {r1, r5, r6, r8, fp, sp, lr}
    16c0:	20647261 	rsbcs	r7, r4, r1, ror #4
    16c4:	72616d2d 	rsbvc	r6, r1, #2880	; 0xb40
    16c8:	613d6863 	teqvs	sp, r3, ror #16
    16cc:	35766d72 	ldrbcc	r6, [r6, #-3442]!	; 0xfffff28e
    16d0:	662b6574 			; <UNDEFINED> instruction: 0x662b6574
    16d4:	672d2070 			; <UNDEFINED> instruction: 0x672d2070
    16d8:	20672d20 	rsbcs	r2, r7, r0, lsr #26
    16dc:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
    16e0:	2d20324f 	sfmcs	f3, 4, [r0, #-316]!	; 0xfffffec4
    16e4:	2d20324f 	sfmcs	f3, 4, [r0, #-316]!	; 0xfffffec4
    16e8:	2d20324f 	sfmcs	f3, 4, [r0, #-316]!	; 0xfffffec4
    16ec:	69756266 	ldmdbvs	r5!, {r1, r2, r5, r6, r9, sp, lr}^
    16f0:	6e69646c 	cdpvs	4, 6, cr6, cr9, cr12, {3}
    16f4:	696c2d67 	stmdbvs	ip!, {r0, r1, r2, r5, r6, r8, sl, fp, sp}^
    16f8:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    16fc:	6e662d20 	cdpvs	13, 6, cr2, cr6, cr0, {1}
    1700:	74732d6f 	ldrbtvc	r2, [r3], #-3439	; 0xfffff291
    1704:	2d6b6361 	stclcs	3, cr6, [fp, #-388]!	; 0xfffffe7c
    1708:	746f7270 	strbtvc	r7, [pc], #-624	; 1710 <shift+0x1710>
    170c:	6f746365 	svcvs	0x00746365
    1710:	662d2072 			; <UNDEFINED> instruction: 0x662d2072
    1714:	692d6f6e 	pushvs	{r1, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}
    1718:	6e696c6e 	cdpvs	12, 6, cr6, cr9, cr14, {3}
    171c:	662d2065 	strtvs	r2, [sp], -r5, rrx
    1720:	69736976 	ldmdbvs	r3!, {r1, r2, r4, r5, r6, r8, fp, sp, lr}^
    1724:	696c6962 	stmdbvs	ip!, {r1, r5, r6, r8, fp, sp, lr}^
    1728:	683d7974 	ldmdavs	sp!, {r2, r4, r5, r6, r8, fp, ip, sp, lr}
    172c:	65646469 	strbvs	r6, [r4, #-1129]!	; 0xfffffb97
    1730:	7369006e 	cmnvc	r9, #110	; 0x6e
    1734:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1738:	64745f74 	ldrbtvs	r5, [r4], #-3956	; 0xfffff08c
    173c:	63007669 	movwvs	r7, #1641	; 0x669
    1740:	00736e6f 	rsbseq	r6, r3, pc, ror #28
    1744:	5f617369 	svcpl	0x00617369
    1748:	5f746962 	svcpl	0x00746962
    174c:	6d6d7769 	stclvs	7, cr7, [sp, #-420]!	; 0xfffffe5c
    1750:	46007478 			; <UNDEFINED> instruction: 0x46007478
    1754:	54584350 	ldrbpl	r4, [r8], #-848	; 0xfffffcb0
    1758:	4e455f53 	mcrmi	15, 2, r5, cr5, cr3, {2}
    175c:	69004d55 	stmdbvs	r0, {r0, r2, r4, r6, r8, sl, fp, lr}
    1760:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1764:	615f7469 	cmpvs	pc, r9, ror #8
    1768:	36766d72 			; <UNDEFINED> instruction: 0x36766d72
    176c:	61736900 	cmnvs	r3, r0, lsl #18
    1770:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1774:	65766d5f 	ldrbvs	r6, [r6, #-3423]!	; 0xfffff2a1
    1778:	61736900 	cmnvs	r3, r0, lsl #18
    177c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1780:	6d77695f 			; <UNDEFINED> instruction: 0x6d77695f
    1784:	3274786d 	rsbscc	r7, r4, #7143424	; 0x6d0000
    1788:	61736900 	cmnvs	r3, r0, lsl #18
    178c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1790:	6564635f 	strbvs	r6, [r4, #-863]!	; 0xfffffca1
    1794:	00307063 	eorseq	r7, r0, r3, rrx
    1798:	5f617369 	svcpl	0x00617369
    179c:	5f746962 	svcpl	0x00746962
    17a0:	63656463 	cmnvs	r5, #1660944384	; 0x63000000
    17a4:	69003170 	stmdbvs	r0, {r4, r5, r6, r8, ip, sp}
    17a8:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    17ac:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
    17b0:	70636564 	rsbvc	r6, r3, r4, ror #10
    17b4:	73690032 	cmnvc	r9, #50	; 0x32
    17b8:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    17bc:	64635f74 	strbtvs	r5, [r3], #-3956	; 0xfffff08c
    17c0:	33706365 	cmncc	r0, #-1811939327	; 0x94000001
    17c4:	61736900 	cmnvs	r3, r0, lsl #18
    17c8:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    17cc:	6564635f 	strbvs	r6, [r4, #-863]!	; 0xfffffca1
    17d0:	00347063 	eorseq	r7, r4, r3, rrx
    17d4:	5f617369 	svcpl	0x00617369
    17d8:	5f746962 	svcpl	0x00746962
    17dc:	645f7066 	ldrbvs	r7, [pc], #-102	; 17e4 <shift+0x17e4>
    17e0:	69006c62 	stmdbvs	r0, {r1, r5, r6, sl, fp, sp, lr}
    17e4:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    17e8:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
    17ec:	70636564 	rsbvc	r6, r3, r4, ror #10
    17f0:	73690036 	cmnvc	r9, #54	; 0x36
    17f4:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    17f8:	64635f74 	strbtvs	r5, [r3], #-3956	; 0xfffff08c
    17fc:	37706365 	ldrbcc	r6, [r0, -r5, ror #6]!
    1800:	61736900 	cmnvs	r3, r0, lsl #18
    1804:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1808:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    180c:	006b3676 	rsbeq	r3, fp, r6, ror r6
    1810:	5f617369 	svcpl	0x00617369
    1814:	5f746962 	svcpl	0x00746962
    1818:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    181c:	6d315f38 	ldcvs	15, cr5, [r1, #-224]!	; 0xffffff20
    1820:	69616d5f 	stmdbvs	r1!, {r0, r1, r2, r3, r4, r6, r8, sl, fp, sp, lr}^
    1824:	6e61006e 	cdpvs	0, 6, cr0, cr1, cr14, {3}
    1828:	69006574 	stmdbvs	r0, {r2, r4, r5, r6, r8, sl, sp, lr}
    182c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1830:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
    1834:	0065736d 	rsbeq	r7, r5, sp, ror #6
    1838:	676e6f6c 	strbvs	r6, [lr, -ip, ror #30]!
    183c:	756f6420 	strbvc	r6, [pc, #-1056]!	; 1424 <shift+0x1424>
    1840:	00656c62 	rsbeq	r6, r5, r2, ror #24
    1844:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1848:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    184c:	2f2e2e2f 	svccs	0x002e2e2f
    1850:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1854:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
    1858:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    185c:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
    1860:	32636367 	rsbcc	r6, r3, #-1677721599	; 0x9c000001
    1864:	6900632e 	stmdbvs	r0, {r1, r2, r3, r5, r8, r9, sp, lr}
    1868:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    186c:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
    1870:	00357670 	eorseq	r7, r5, r0, ror r6
    1874:	5f617369 	svcpl	0x00617369
    1878:	5f746962 	svcpl	0x00746962
    187c:	61637378 	smcvs	14136	; 0x3738
    1880:	6c00656c 	cfstr32vs	mvfx6, [r0], {108}	; 0x6c
    1884:	20676e6f 	rsbcs	r6, r7, pc, ror #28
    1888:	676e6f6c 	strbvs	r6, [lr, -ip, ror #30]!
    188c:	736e7520 	cmnvc	lr, #32, 10	; 0x8000000
    1890:	656e6769 	strbvs	r6, [lr, #-1897]!	; 0xfffff897
    1894:	6e692064 	cdpvs	0, 6, cr2, cr9, cr4, {3}
    1898:	73690074 	cmnvc	r9, #116	; 0x74
    189c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    18a0:	75715f74 	ldrbvc	r5, [r1, #-3956]!	; 0xfffff08c
    18a4:	5f6b7269 	svcpl	0x006b7269
    18a8:	5f336d63 	svcpl	0x00336d63
    18ac:	6472646c 	ldrbtvs	r6, [r2], #-1132	; 0xfffffb94
    18b0:	61736900 	cmnvs	r3, r0, lsl #18
    18b4:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    18b8:	6d38695f 			; <UNDEFINED> instruction: 0x6d38695f
    18bc:	7369006d 	cmnvc	r9, #109	; 0x6d
    18c0:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    18c4:	70665f74 	rsbvc	r5, r6, r4, ror pc
    18c8:	3233645f 	eorscc	r6, r3, #1593835520	; 0x5f000000
    18cc:	61736900 	cmnvs	r3, r0, lsl #18
    18d0:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    18d4:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    18d8:	6d653776 	stclvs	7, cr3, [r5, #-472]!	; 0xfffffe28
    18dc:	61736900 	cmnvs	r3, r0, lsl #18
    18e0:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    18e4:	61706c5f 	cmnvs	r0, pc, asr ip
    18e8:	6c610065 	stclvs	0, cr0, [r1], #-404	; 0xfffffe6c
    18ec:	6d695f6c 	stclvs	15, cr5, [r9, #-432]!	; 0xfffffe50
    18f0:	65696c70 	strbvs	r6, [r9, #-3184]!	; 0xfffff390
    18f4:	62665f64 	rsbvs	r5, r6, #100, 30	; 0x190
    18f8:	00737469 	rsbseq	r7, r3, r9, ror #8
    18fc:	5f617369 	svcpl	0x00617369
    1900:	5f746962 	svcpl	0x00746962
    1904:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    1908:	00315f38 	eorseq	r5, r1, r8, lsr pc
    190c:	5f617369 	svcpl	0x00617369
    1910:	5f746962 	svcpl	0x00746962
    1914:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    1918:	00325f38 	eorseq	r5, r2, r8, lsr pc
    191c:	5f617369 	svcpl	0x00617369
    1920:	5f746962 	svcpl	0x00746962
    1924:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    1928:	00335f38 	eorseq	r5, r3, r8, lsr pc
    192c:	5f617369 	svcpl	0x00617369
    1930:	5f746962 	svcpl	0x00746962
    1934:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    1938:	00345f38 	eorseq	r5, r4, r8, lsr pc
    193c:	5f617369 	svcpl	0x00617369
    1940:	5f746962 	svcpl	0x00746962
    1944:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    1948:	00355f38 	eorseq	r5, r5, r8, lsr pc
    194c:	5f617369 	svcpl	0x00617369
    1950:	5f746962 	svcpl	0x00746962
    1954:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    1958:	00365f38 	eorseq	r5, r6, r8, lsr pc
    195c:	5f617369 	svcpl	0x00617369
    1960:	5f746962 	svcpl	0x00746962
    1964:	69006273 	stmdbvs	r0, {r0, r1, r4, r5, r6, r9, sp, lr}
    1968:	6e5f6173 	mrcvs	1, 2, r6, cr15, cr3, {3}
    196c:	625f6d75 	subsvs	r6, pc, #7488	; 0x1d40
    1970:	00737469 	rsbseq	r7, r3, r9, ror #8
    1974:	5f617369 	svcpl	0x00617369
    1978:	5f746962 	svcpl	0x00746962
    197c:	6c616d73 	stclvs	13, cr6, [r1], #-460	; 0xfffffe34
    1980:	6c756d6c 	ldclvs	13, cr6, [r5], #-432	; 0xfffffe50
    1984:	6e756600 	cdpvs	6, 7, cr6, cr5, cr0, {0}
    1988:	74705f63 	ldrbtvc	r5, [r0], #-3939	; 0xfffff09d
    198c:	6f630072 	svcvs	0x00630072
    1990:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
    1994:	6f642078 	svcvs	0x00642078
    1998:	656c6275 	strbvs	r6, [ip, #-629]!	; 0xfffffd8b
    199c:	5f424e00 	svcpl	0x00424e00
    19a0:	535f5046 	cmppl	pc, #70	; 0x46
    19a4:	45525359 	ldrbmi	r5, [r2, #-857]	; 0xfffffca7
    19a8:	69005347 	stmdbvs	r0, {r0, r1, r2, r6, r8, r9, ip, lr}
    19ac:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    19b0:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
    19b4:	70636564 	rsbvc	r6, r3, r4, ror #10
    19b8:	73690035 	cmnvc	r9, #53	; 0x35
    19bc:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    19c0:	66765f74 	uhsub16vs	r5, r6, r4
    19c4:	00327670 	eorseq	r7, r2, r0, ror r6
    19c8:	5f617369 	svcpl	0x00617369
    19cc:	5f746962 	svcpl	0x00746962
    19d0:	76706676 			; <UNDEFINED> instruction: 0x76706676
    19d4:	73690033 	cmnvc	r9, #51	; 0x33
    19d8:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    19dc:	66765f74 	uhsub16vs	r5, r6, r4
    19e0:	00347670 	eorseq	r7, r4, r0, ror r6
    19e4:	58435046 	stmdapl	r3, {r1, r2, r6, ip, lr}^
    19e8:	5f534e54 	svcpl	0x00534e54
    19ec:	4d554e45 	ldclmi	14, cr4, [r5, #-276]	; 0xfffffeec
    19f0:	61736900 	cmnvs	r3, r0, lsl #18
    19f4:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    19f8:	7568745f 	strbvc	r7, [r8, #-1119]!	; 0xfffffba1
    19fc:	6900626d 	stmdbvs	r0, {r0, r2, r3, r5, r6, r9, sp, lr}
    1a00:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1a04:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
    1a08:	63363170 	teqvs	r6, #112, 2
    1a0c:	00766e6f 	rsbseq	r6, r6, pc, ror #28
    1a10:	5f617369 	svcpl	0x00617369
    1a14:	74616566 	strbtvc	r6, [r1], #-1382	; 0xfffffa9a
    1a18:	00657275 	rsbeq	r7, r5, r5, ror r2
    1a1c:	5f617369 	svcpl	0x00617369
    1a20:	5f746962 	svcpl	0x00746962
    1a24:	6d746f6e 	ldclvs	15, cr6, [r4, #-440]!	; 0xfffffe48
    1a28:	61736900 	cmnvs	r3, r0, lsl #18
    1a2c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1a30:	6975715f 	ldmdbvs	r5!, {r0, r1, r2, r3, r4, r6, r8, ip, sp, lr}^
    1a34:	615f6b72 	cmpvs	pc, r2, ror fp	; <UNPREDICTABLE>
    1a38:	36766d72 			; <UNDEFINED> instruction: 0x36766d72
    1a3c:	69007a6b 	stmdbvs	r0, {r0, r1, r3, r5, r6, r9, fp, ip, sp, lr}
    1a40:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1a44:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
    1a48:	32336372 	eorscc	r6, r3, #-939524095	; 0xc8000001
    1a4c:	61736900 	cmnvs	r3, r0, lsl #18
    1a50:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1a54:	6975715f 	ldmdbvs	r5!, {r0, r1, r2, r3, r4, r6, r8, ip, sp, lr}^
    1a58:	6e5f6b72 	vmovvs.s8	r6, d15[3]
    1a5c:	73615f6f 	cmnvc	r1, #444	; 0x1bc
    1a60:	7570636d 	ldrbvc	r6, [r0, #-877]!	; 0xfffffc93
    1a64:	61736900 	cmnvs	r3, r0, lsl #18
    1a68:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1a6c:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1a70:	69003476 	stmdbvs	r0, {r1, r2, r4, r5, r6, sl, ip, sp}
    1a74:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1a78:	745f7469 	ldrbvc	r7, [pc], #-1129	; 1a80 <shift+0x1a80>
    1a7c:	626d7568 	rsbvs	r7, sp, #104, 10	; 0x1a000000
    1a80:	73690032 	cmnvc	r9, #50	; 0x32
    1a84:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1a88:	65625f74 	strbvs	r5, [r2, #-3956]!	; 0xfffff08c
    1a8c:	73690038 	cmnvc	r9, #56	; 0x38
    1a90:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1a94:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    1a98:	0037766d 	eorseq	r7, r7, sp, ror #12
    1a9c:	5f617369 	svcpl	0x00617369
    1aa0:	5f746962 	svcpl	0x00746962
    1aa4:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    1aa8:	66760038 			; <UNDEFINED> instruction: 0x66760038
    1aac:	79735f70 	ldmdbvc	r3!, {r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    1ab0:	67657273 			; <UNDEFINED> instruction: 0x67657273
    1ab4:	6e655f73 	mcrvs	15, 3, r5, cr5, cr3, {3}
    1ab8:	69646f63 	stmdbvs	r4!, {r0, r1, r5, r6, r8, r9, sl, fp, sp, lr}^
    1abc:	6900676e 	stmdbvs	r0, {r1, r2, r3, r5, r6, r8, r9, sl, sp, lr}
    1ac0:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1ac4:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
    1ac8:	66363170 			; <UNDEFINED> instruction: 0x66363170
    1acc:	69006c6d 	stmdbvs	r0, {r0, r2, r3, r5, r6, sl, fp, sp, lr}
    1ad0:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1ad4:	645f7469 	ldrbvs	r7, [pc], #-1129	; 1adc <shift+0x1adc>
    1ad8:	7270746f 	rsbsvc	r7, r0, #1862270976	; 0x6f000000
    1adc:	5f00646f 	svcpl	0x0000646f
    1ae0:	7869665f 	stmdavc	r9!, {r0, r1, r2, r3, r4, r6, r9, sl, sp, lr}^
    1ae4:	73736e75 	cmnvc	r3, #1872	; 0x750
    1ae8:	00696466 	rsbeq	r6, r9, r6, ror #8
    1aec:	79744653 	ldmdbvc	r4!, {r0, r1, r4, r6, r9, sl, lr}^
    1af0:	5f006570 	svcpl	0x00006570
    1af4:	6165615f 	cmnvs	r5, pc, asr r1
    1af8:	665f6962 	ldrbvs	r6, [pc], -r2, ror #18
    1afc:	7a6c7532 	bvc	1b1efcc <__bss_end+0x1b14c90>
    1b00:	665f5f00 	ldrbvs	r5, [pc], -r0, lsl #30
    1b04:	66737869 	ldrbtvs	r7, [r3], -r9, ror #16
    1b08:	44006964 	strmi	r6, [r0], #-2404	; 0xfffff69c
    1b0c:	70797446 	rsbsvc	r7, r9, r6, asr #8
    1b10:	53550065 	cmppl	r5, #101	; 0x65
    1b14:	70797449 	rsbsvc	r7, r9, r9, asr #8
    1b18:	44550065 	ldrbmi	r0, [r5], #-101	; 0xffffff9b
    1b1c:	70797449 	rsbsvc	r7, r9, r9, asr #8
    1b20:	4e470065 	cdpmi	0, 4, cr0, cr7, cr5, {3}
    1b24:	31432055 	qdaddcc	r2, r5, r3
    1b28:	30312037 	eorscc	r2, r1, r7, lsr r0
    1b2c:	312e332e 			; <UNDEFINED> instruction: 0x312e332e
    1b30:	32303220 	eorscc	r3, r0, #32, 4
    1b34:	32363031 	eorscc	r3, r6, #49	; 0x31
    1b38:	72282031 	eorvc	r2, r8, #49	; 0x31
    1b3c:	61656c65 	cmnvs	r5, r5, ror #24
    1b40:	20296573 	eorcs	r6, r9, r3, ror r5
    1b44:	72616d2d 	rsbvc	r6, r1, #2880	; 0xb40
    1b48:	6d2d206d 	stcvs	0, cr2, [sp, #-436]!	; 0xfffffe4c
    1b4c:	616f6c66 	cmnvs	pc, r6, ror #24
    1b50:	62612d74 	rsbvs	r2, r1, #116, 26	; 0x1d00
    1b54:	61683d69 	cmnvs	r8, r9, ror #26
    1b58:	2d206472 	cfstrscs	mvf6, [r0, #-456]!	; 0xfffffe38
    1b5c:	6372616d 	cmnvs	r2, #1073741851	; 0x4000001b
    1b60:	72613d68 	rsbvc	r3, r1, #104, 26	; 0x1a00
    1b64:	7435766d 	ldrtvc	r7, [r5], #-1645	; 0xfffff993
    1b68:	70662b65 	rsbvc	r2, r6, r5, ror #22
    1b6c:	20672d20 	rsbcs	r2, r7, r0, lsr #26
    1b70:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
    1b74:	4f2d2067 	svcmi	0x002d2067
    1b78:	4f2d2032 	svcmi	0x002d2032
    1b7c:	4f2d2032 	svcmi	0x002d2032
    1b80:	662d2032 			; <UNDEFINED> instruction: 0x662d2032
    1b84:	6c697562 	cfstr64vs	mvdx7, [r9], #-392	; 0xfffffe78
    1b88:	676e6964 	strbvs	r6, [lr, -r4, ror #18]!
    1b8c:	62696c2d 	rsbvs	r6, r9, #11520	; 0x2d00
    1b90:	20636367 	rsbcs	r6, r3, r7, ror #6
    1b94:	6f6e662d 	svcvs	0x006e662d
    1b98:	6174732d 	cmnvs	r4, sp, lsr #6
    1b9c:	702d6b63 	eorvc	r6, sp, r3, ror #22
    1ba0:	65746f72 	ldrbvs	r6, [r4, #-3954]!	; 0xfffff08e
    1ba4:	726f7463 	rsbvc	r7, pc, #1660944384	; 0x63000000
    1ba8:	6e662d20 	cdpvs	13, 6, cr2, cr6, cr0, {1}
    1bac:	6e692d6f 	cdpvs	13, 6, cr2, cr9, cr15, {3}
    1bb0:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
    1bb4:	65662d20 	strbvs	r2, [r6, #-3360]!	; 0xfffff2e0
    1bb8:	70656378 	rsbvc	r6, r5, r8, ror r3
    1bbc:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
    1bc0:	662d2073 			; <UNDEFINED> instruction: 0x662d2073
    1bc4:	69736976 	ldmdbvs	r3!, {r1, r2, r4, r5, r6, r8, fp, sp, lr}^
    1bc8:	696c6962 	stmdbvs	ip!, {r1, r5, r6, r8, fp, sp, lr}^
    1bcc:	683d7974 	ldmdavs	sp!, {r2, r4, r5, r6, r8, fp, ip, sp, lr}
    1bd0:	65646469 	strbvs	r6, [r4, #-1129]!	; 0xfffffb97
    1bd4:	5f5f006e 	svcpl	0x005f006e
    1bd8:	76696475 			; <UNDEFINED> instruction: 0x76696475
    1bdc:	64646f6d 	strbtvs	r6, [r4], #-3949	; 0xfffff093
    1be0:	Address 0x0000000000001be0 is out of bounds.


Disassembly of section .debug_frame:

00000000 <.debug_frame>:
   0:	0000000c 	andeq	r0, r0, ip
   4:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
   8:	7c020001 	stcvc	0, cr0, [r2], {1}
   c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
  10:	0000001c 	andeq	r0, r0, ip, lsl r0
  14:	00000000 	andeq	r0, r0, r0
  18:	00008008 	andeq	r8, r0, r8
  1c:	0000005c 	andeq	r0, r0, ip, asr r0
  20:	8b040e42 	blhi	103930 <__bss_end+0xf95f4>
  24:	0b0d4201 	bleq	350830 <__bss_end+0x3464f4>
  28:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
  2c:	00000ecb 	andeq	r0, r0, fp, asr #29
  30:	0000001c 	andeq	r0, r0, ip, lsl r0
  34:	00000000 	andeq	r0, r0, r0
  38:	00008064 	andeq	r8, r0, r4, rrx
  3c:	00000040 	andeq	r0, r0, r0, asr #32
  40:	8b080e42 	blhi	203950 <__bss_end+0x1f9614>
  44:	42018e02 	andmi	r8, r1, #2, 28
  48:	5a040b0c 	bpl	102c80 <__bss_end+0xf8944>
  4c:	00080d0c 	andeq	r0, r8, ip, lsl #26
  50:	0000000c 	andeq	r0, r0, ip
  54:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
  58:	7c020001 	stcvc	0, cr0, [r2], {1}
  5c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
  60:	0000001c 	andeq	r0, r0, ip, lsl r0
  64:	00000050 	andeq	r0, r0, r0, asr r0
  68:	000080a4 	andeq	r8, r0, r4, lsr #1
  6c:	00000038 	andeq	r0, r0, r8, lsr r0
  70:	8b040e42 	blhi	103980 <__bss_end+0xf9644>
  74:	0b0d4201 	bleq	350880 <__bss_end+0x346544>
  78:	420d0d54 	andmi	r0, sp, #84, 26	; 0x1500
  7c:	00000ecb 	andeq	r0, r0, fp, asr #29
  80:	0000001c 	andeq	r0, r0, ip, lsl r0
  84:	00000050 	andeq	r0, r0, r0, asr r0
  88:	000080dc 	ldrdeq	r8, [r0], -ip
  8c:	0000002c 	andeq	r0, r0, ip, lsr #32
  90:	8b040e42 	blhi	1039a0 <__bss_end+0xf9664>
  94:	0b0d4201 	bleq	3508a0 <__bss_end+0x346564>
  98:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
  9c:	00000ecb 	andeq	r0, r0, fp, asr #29
  a0:	0000001c 	andeq	r0, r0, ip, lsl r0
  a4:	00000050 	andeq	r0, r0, r0, asr r0
  a8:	00008108 	andeq	r8, r0, r8, lsl #2
  ac:	00000020 	andeq	r0, r0, r0, lsr #32
  b0:	8b040e42 	blhi	1039c0 <__bss_end+0xf9684>
  b4:	0b0d4201 	bleq	3508c0 <__bss_end+0x346584>
  b8:	420d0d48 	andmi	r0, sp, #72, 26	; 0x1200
  bc:	00000ecb 	andeq	r0, r0, fp, asr #29
  c0:	0000001c 	andeq	r0, r0, ip, lsl r0
  c4:	00000050 	andeq	r0, r0, r0, asr r0
  c8:	00008128 	andeq	r8, r0, r8, lsr #2
  cc:	00000018 	andeq	r0, r0, r8, lsl r0
  d0:	8b040e42 	blhi	1039e0 <__bss_end+0xf96a4>
  d4:	0b0d4201 	bleq	3508e0 <__bss_end+0x3465a4>
  d8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  dc:	00000ecb 	andeq	r0, r0, fp, asr #29
  e0:	0000001c 	andeq	r0, r0, ip, lsl r0
  e4:	00000050 	andeq	r0, r0, r0, asr r0
  e8:	00008140 	andeq	r8, r0, r0, asr #2
  ec:	00000018 	andeq	r0, r0, r8, lsl r0
  f0:	8b040e42 	blhi	103a00 <__bss_end+0xf96c4>
  f4:	0b0d4201 	bleq	350900 <__bss_end+0x3465c4>
  f8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  fc:	00000ecb 	andeq	r0, r0, fp, asr #29
 100:	0000001c 	andeq	r0, r0, ip, lsl r0
 104:	00000050 	andeq	r0, r0, r0, asr r0
 108:	00008158 	andeq	r8, r0, r8, asr r1
 10c:	00000018 	andeq	r0, r0, r8, lsl r0
 110:	8b040e42 	blhi	103a20 <__bss_end+0xf96e4>
 114:	0b0d4201 	bleq	350920 <__bss_end+0x3465e4>
 118:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
 11c:	00000ecb 	andeq	r0, r0, fp, asr #29
 120:	00000014 	andeq	r0, r0, r4, lsl r0
 124:	00000050 	andeq	r0, r0, r0, asr r0
 128:	00008170 	andeq	r8, r0, r0, ror r1
 12c:	0000000c 	andeq	r0, r0, ip
 130:	8b040e42 	blhi	103a40 <__bss_end+0xf9704>
 134:	0b0d4201 	bleq	350940 <__bss_end+0x346604>
 138:	0000001c 	andeq	r0, r0, ip, lsl r0
 13c:	00000050 	andeq	r0, r0, r0, asr r0
 140:	0000817c 	andeq	r8, r0, ip, ror r1
 144:	00000058 	andeq	r0, r0, r8, asr r0
 148:	8b080e42 	blhi	203a58 <__bss_end+0x1f971c>
 14c:	42018e02 	andmi	r8, r1, #2, 28
 150:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 154:	00080d0c 	andeq	r0, r8, ip, lsl #26
 158:	0000001c 	andeq	r0, r0, ip, lsl r0
 15c:	00000050 	andeq	r0, r0, r0, asr r0
 160:	000081d4 	ldrdeq	r8, [r0], -r4
 164:	00000058 	andeq	r0, r0, r8, asr r0
 168:	8b080e42 	blhi	203a78 <__bss_end+0x1f973c>
 16c:	42018e02 	andmi	r8, r1, #2, 28
 170:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 174:	00080d0c 	andeq	r0, r8, ip, lsl #26
 178:	0000000c 	andeq	r0, r0, ip
 17c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 180:	7c020001 	stcvc	0, cr0, [r2], {1}
 184:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 188:	0000001c 	andeq	r0, r0, ip, lsl r0
 18c:	00000178 	andeq	r0, r0, r8, ror r1
 190:	0000822c 	andeq	r8, r0, ip, lsr #4
 194:	0000003c 	andeq	r0, r0, ip, lsr r0
 198:	8b080e42 	blhi	203aa8 <__bss_end+0x1f976c>
 19c:	42018e02 	andmi	r8, r1, #2, 28
 1a0:	58040b0c 	stmdapl	r4, {r2, r3, r8, r9, fp}
 1a4:	00080d0c 	andeq	r0, r8, ip, lsl #26
 1a8:	00000020 	andeq	r0, r0, r0, lsr #32
 1ac:	00000178 	andeq	r0, r0, r8, ror r1
 1b0:	00008268 	andeq	r8, r0, r8, ror #4
 1b4:	0000006c 	andeq	r0, r0, ip, rrx
 1b8:	840c0e42 	strhi	r0, [ip], #-3650	; 0xfffff1be
 1bc:	8e028b03 	vmlahi.f64	d8, d2, d3
 1c0:	0b0c4201 	bleq	3109cc <__bss_end+0x306690>
 1c4:	0d0c6a04 	vstreq	s12, [ip, #-16]
 1c8:	0000000c 	andeq	r0, r0, ip
 1cc:	0000000c 	andeq	r0, r0, ip
 1d0:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 1d4:	7c020001 	stcvc	0, cr0, [r2], {1}
 1d8:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 1dc:	0000001c 	andeq	r0, r0, ip, lsl r0
 1e0:	000001cc 	andeq	r0, r0, ip, asr #3
 1e4:	000082d4 	ldrdeq	r8, [r0], -r4
 1e8:	0000002c 	andeq	r0, r0, ip, lsr #32
 1ec:	8b040e42 	blhi	103afc <__bss_end+0xf97c0>
 1f0:	0b0d4201 	bleq	3509fc <__bss_end+0x3466c0>
 1f4:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 1f8:	00000ecb 	andeq	r0, r0, fp, asr #29
 1fc:	0000001c 	andeq	r0, r0, ip, lsl r0
 200:	000001cc 	andeq	r0, r0, ip, asr #3
 204:	00008300 	andeq	r8, r0, r0, lsl #6
 208:	0000002c 	andeq	r0, r0, ip, lsr #32
 20c:	8b040e42 	blhi	103b1c <__bss_end+0xf97e0>
 210:	0b0d4201 	bleq	350a1c <__bss_end+0x3466e0>
 214:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 218:	00000ecb 	andeq	r0, r0, fp, asr #29
 21c:	0000001c 	andeq	r0, r0, ip, lsl r0
 220:	000001cc 	andeq	r0, r0, ip, asr #3
 224:	0000832c 	andeq	r8, r0, ip, lsr #6
 228:	0000001c 	andeq	r0, r0, ip, lsl r0
 22c:	8b040e42 	blhi	103b3c <__bss_end+0xf9800>
 230:	0b0d4201 	bleq	350a3c <__bss_end+0x346700>
 234:	420d0d46 	andmi	r0, sp, #4480	; 0x1180
 238:	00000ecb 	andeq	r0, r0, fp, asr #29
 23c:	0000001c 	andeq	r0, r0, ip, lsl r0
 240:	000001cc 	andeq	r0, r0, ip, asr #3
 244:	00008348 	andeq	r8, r0, r8, asr #6
 248:	00000044 	andeq	r0, r0, r4, asr #32
 24c:	8b040e42 	blhi	103b5c <__bss_end+0xf9820>
 250:	0b0d4201 	bleq	350a5c <__bss_end+0x346720>
 254:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 258:	00000ecb 	andeq	r0, r0, fp, asr #29
 25c:	0000001c 	andeq	r0, r0, ip, lsl r0
 260:	000001cc 	andeq	r0, r0, ip, asr #3
 264:	0000838c 	andeq	r8, r0, ip, lsl #7
 268:	00000050 	andeq	r0, r0, r0, asr r0
 26c:	8b040e42 	blhi	103b7c <__bss_end+0xf9840>
 270:	0b0d4201 	bleq	350a7c <__bss_end+0x346740>
 274:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 278:	00000ecb 	andeq	r0, r0, fp, asr #29
 27c:	0000001c 	andeq	r0, r0, ip, lsl r0
 280:	000001cc 	andeq	r0, r0, ip, asr #3
 284:	000083dc 	ldrdeq	r8, [r0], -ip
 288:	00000050 	andeq	r0, r0, r0, asr r0
 28c:	8b040e42 	blhi	103b9c <__bss_end+0xf9860>
 290:	0b0d4201 	bleq	350a9c <__bss_end+0x346760>
 294:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 298:	00000ecb 	andeq	r0, r0, fp, asr #29
 29c:	0000001c 	andeq	r0, r0, ip, lsl r0
 2a0:	000001cc 	andeq	r0, r0, ip, asr #3
 2a4:	0000842c 	andeq	r8, r0, ip, lsr #8
 2a8:	0000002c 	andeq	r0, r0, ip, lsr #32
 2ac:	8b040e42 	blhi	103bbc <__bss_end+0xf9880>
 2b0:	0b0d4201 	bleq	350abc <__bss_end+0x346780>
 2b4:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 2b8:	00000ecb 	andeq	r0, r0, fp, asr #29
 2bc:	0000001c 	andeq	r0, r0, ip, lsl r0
 2c0:	000001cc 	andeq	r0, r0, ip, asr #3
 2c4:	00008458 	andeq	r8, r0, r8, asr r4
 2c8:	00000050 	andeq	r0, r0, r0, asr r0
 2cc:	8b040e42 	blhi	103bdc <__bss_end+0xf98a0>
 2d0:	0b0d4201 	bleq	350adc <__bss_end+0x3467a0>
 2d4:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 2d8:	00000ecb 	andeq	r0, r0, fp, asr #29
 2dc:	0000001c 	andeq	r0, r0, ip, lsl r0
 2e0:	000001cc 	andeq	r0, r0, ip, asr #3
 2e4:	000084a8 	andeq	r8, r0, r8, lsr #9
 2e8:	00000044 	andeq	r0, r0, r4, asr #32
 2ec:	8b040e42 	blhi	103bfc <__bss_end+0xf98c0>
 2f0:	0b0d4201 	bleq	350afc <__bss_end+0x3467c0>
 2f4:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 2f8:	00000ecb 	andeq	r0, r0, fp, asr #29
 2fc:	0000001c 	andeq	r0, r0, ip, lsl r0
 300:	000001cc 	andeq	r0, r0, ip, asr #3
 304:	000084ec 	andeq	r8, r0, ip, ror #9
 308:	00000050 	andeq	r0, r0, r0, asr r0
 30c:	8b040e42 	blhi	103c1c <__bss_end+0xf98e0>
 310:	0b0d4201 	bleq	350b1c <__bss_end+0x3467e0>
 314:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 318:	00000ecb 	andeq	r0, r0, fp, asr #29
 31c:	0000001c 	andeq	r0, r0, ip, lsl r0
 320:	000001cc 	andeq	r0, r0, ip, asr #3
 324:	0000853c 	andeq	r8, r0, ip, lsr r5
 328:	00000054 	andeq	r0, r0, r4, asr r0
 32c:	8b040e42 	blhi	103c3c <__bss_end+0xf9900>
 330:	0b0d4201 	bleq	350b3c <__bss_end+0x346800>
 334:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 338:	00000ecb 	andeq	r0, r0, fp, asr #29
 33c:	0000001c 	andeq	r0, r0, ip, lsl r0
 340:	000001cc 	andeq	r0, r0, ip, asr #3
 344:	00008590 	muleq	r0, r0, r5
 348:	0000003c 	andeq	r0, r0, ip, lsr r0
 34c:	8b040e42 	blhi	103c5c <__bss_end+0xf9920>
 350:	0b0d4201 	bleq	350b5c <__bss_end+0x346820>
 354:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 358:	00000ecb 	andeq	r0, r0, fp, asr #29
 35c:	0000001c 	andeq	r0, r0, ip, lsl r0
 360:	000001cc 	andeq	r0, r0, ip, asr #3
 364:	000085cc 	andeq	r8, r0, ip, asr #11
 368:	0000003c 	andeq	r0, r0, ip, lsr r0
 36c:	8b040e42 	blhi	103c7c <__bss_end+0xf9940>
 370:	0b0d4201 	bleq	350b7c <__bss_end+0x346840>
 374:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 378:	00000ecb 	andeq	r0, r0, fp, asr #29
 37c:	0000001c 	andeq	r0, r0, ip, lsl r0
 380:	000001cc 	andeq	r0, r0, ip, asr #3
 384:	00008608 	andeq	r8, r0, r8, lsl #12
 388:	0000003c 	andeq	r0, r0, ip, lsr r0
 38c:	8b040e42 	blhi	103c9c <__bss_end+0xf9960>
 390:	0b0d4201 	bleq	350b9c <__bss_end+0x346860>
 394:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 398:	00000ecb 	andeq	r0, r0, fp, asr #29
 39c:	0000001c 	andeq	r0, r0, ip, lsl r0
 3a0:	000001cc 	andeq	r0, r0, ip, asr #3
 3a4:	00008644 	andeq	r8, r0, r4, asr #12
 3a8:	0000003c 	andeq	r0, r0, ip, lsr r0
 3ac:	8b040e42 	blhi	103cbc <__bss_end+0xf9980>
 3b0:	0b0d4201 	bleq	350bbc <__bss_end+0x346880>
 3b4:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 3b8:	00000ecb 	andeq	r0, r0, fp, asr #29
 3bc:	0000001c 	andeq	r0, r0, ip, lsl r0
 3c0:	000001cc 	andeq	r0, r0, ip, asr #3
 3c4:	00008680 	andeq	r8, r0, r0, lsl #13
 3c8:	000000b0 	strheq	r0, [r0], -r0	; <UNPREDICTABLE>
 3cc:	8b080e42 	blhi	203cdc <__bss_end+0x1f99a0>
 3d0:	42018e02 	andmi	r8, r1, #2, 28
 3d4:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 3d8:	080d0c50 	stmdaeq	sp, {r4, r6, sl, fp}
 3dc:	0000000c 	andeq	r0, r0, ip
 3e0:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 3e4:	7c020001 	stcvc	0, cr0, [r2], {1}
 3e8:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 3ec:	0000001c 	andeq	r0, r0, ip, lsl r0
 3f0:	000003dc 	ldrdeq	r0, [r0], -ip
 3f4:	00008730 	andeq	r8, r0, r0, lsr r7
 3f8:	00000178 	andeq	r0, r0, r8, ror r1
 3fc:	8b080e42 	blhi	203d0c <__bss_end+0x1f99d0>
 400:	42018e02 	andmi	r8, r1, #2, 28
 404:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 408:	080d0cb4 	stmdaeq	sp, {r2, r4, r5, r7, sl, fp}
 40c:	0000001c 	andeq	r0, r0, ip, lsl r0
 410:	000003dc 	ldrdeq	r0, [r0], -ip
 414:	000088a8 	andeq	r8, r0, r8, lsr #17
 418:	000000cc 	andeq	r0, r0, ip, asr #1
 41c:	8b080e42 	blhi	203d2c <__bss_end+0x1f99f0>
 420:	42018e02 	andmi	r8, r1, #2, 28
 424:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 428:	080d0c60 	stmdaeq	sp, {r5, r6, sl, fp}
 42c:	0000001c 	andeq	r0, r0, ip, lsl r0
 430:	000003dc 	ldrdeq	r0, [r0], -ip
 434:	00008974 	andeq	r8, r0, r4, ror r9
 438:	00000100 	andeq	r0, r0, r0, lsl #2
 43c:	8b040e42 	blhi	103d4c <__bss_end+0xf9a10>
 440:	0b0d4201 	bleq	350c4c <__bss_end+0x346910>
 444:	0d0d7802 	stceq	8, cr7, [sp, #-8]
 448:	000ecb42 	andeq	ip, lr, r2, asr #22
 44c:	0000001c 	andeq	r0, r0, ip, lsl r0
 450:	000003dc 	ldrdeq	r0, [r0], -ip
 454:	00008a74 	andeq	r8, r0, r4, ror sl
 458:	0000015c 	andeq	r0, r0, ip, asr r1
 45c:	8b040e42 	blhi	103d6c <__bss_end+0xf9a30>
 460:	0b0d4201 	bleq	350c6c <__bss_end+0x346930>
 464:	0d0d9c02 	stceq	12, cr9, [sp, #-8]
 468:	000ecb42 	andeq	ip, lr, r2, asr #22
 46c:	0000001c 	andeq	r0, r0, ip, lsl r0
 470:	000003dc 	ldrdeq	r0, [r0], -ip
 474:	00008bd0 	ldrdeq	r8, [r0], -r0
 478:	000000c0 	andeq	r0, r0, r0, asr #1
 47c:	8b040e42 	blhi	103d8c <__bss_end+0xf9a50>
 480:	0b0d4201 	bleq	350c8c <__bss_end+0x346950>
 484:	0d0d5802 	stceq	8, cr5, [sp, #-8]
 488:	000ecb42 	andeq	ip, lr, r2, asr #22
 48c:	0000001c 	andeq	r0, r0, ip, lsl r0
 490:	000003dc 	ldrdeq	r0, [r0], -ip
 494:	00008c90 	muleq	r0, r0, ip
 498:	000000ac 	andeq	r0, r0, ip, lsr #1
 49c:	8b040e42 	blhi	103dac <__bss_end+0xf9a70>
 4a0:	0b0d4201 	bleq	350cac <__bss_end+0x346970>
 4a4:	0d0d4e02 	stceq	14, cr4, [sp, #-8]
 4a8:	000ecb42 	andeq	ip, lr, r2, asr #22
 4ac:	0000001c 	andeq	r0, r0, ip, lsl r0
 4b0:	000003dc 	ldrdeq	r0, [r0], -ip
 4b4:	00008d3c 	andeq	r8, r0, ip, lsr sp
 4b8:	00000054 	andeq	r0, r0, r4, asr r0
 4bc:	8b040e42 	blhi	103dcc <__bss_end+0xf9a90>
 4c0:	0b0d4201 	bleq	350ccc <__bss_end+0x346990>
 4c4:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 4c8:	00000ecb 	andeq	r0, r0, fp, asr #29
 4cc:	0000001c 	andeq	r0, r0, ip, lsl r0
 4d0:	000003dc 	ldrdeq	r0, [r0], -ip
 4d4:	00008d90 	muleq	r0, r0, sp
 4d8:	000000ac 	andeq	r0, r0, ip, lsr #1
 4dc:	8b080e42 	blhi	203dec <__bss_end+0x1f9ab0>
 4e0:	42018e02 	andmi	r8, r1, #2, 28
 4e4:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 4e8:	080d0c50 	stmdaeq	sp, {r4, r6, sl, fp}
 4ec:	0000001c 	andeq	r0, r0, ip, lsl r0
 4f0:	000003dc 	ldrdeq	r0, [r0], -ip
 4f4:	00008e3c 	andeq	r8, r0, ip, lsr lr
 4f8:	000000d8 	ldrdeq	r0, [r0], -r8
 4fc:	8b080e42 	blhi	203e0c <__bss_end+0x1f9ad0>
 500:	42018e02 	andmi	r8, r1, #2, 28
 504:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 508:	080d0c66 	stmdaeq	sp, {r1, r2, r5, r6, sl, fp}
 50c:	0000001c 	andeq	r0, r0, ip, lsl r0
 510:	000003dc 	ldrdeq	r0, [r0], -ip
 514:	00008f14 	andeq	r8, r0, r4, lsl pc
 518:	00000068 	andeq	r0, r0, r8, rrx
 51c:	8b040e42 	blhi	103e2c <__bss_end+0xf9af0>
 520:	0b0d4201 	bleq	350d2c <__bss_end+0x3469f0>
 524:	420d0d6c 	andmi	r0, sp, #108, 26	; 0x1b00
 528:	00000ecb 	andeq	r0, r0, fp, asr #29
 52c:	0000001c 	andeq	r0, r0, ip, lsl r0
 530:	000003dc 	ldrdeq	r0, [r0], -ip
 534:	00008f7c 	andeq	r8, r0, ip, ror pc
 538:	00000080 	andeq	r0, r0, r0, lsl #1
 53c:	8b040e42 	blhi	103e4c <__bss_end+0xf9b10>
 540:	0b0d4201 	bleq	350d4c <__bss_end+0x346a10>
 544:	420d0d78 	andmi	r0, sp, #120, 26	; 0x1e00
 548:	00000ecb 	andeq	r0, r0, fp, asr #29
 54c:	0000001c 	andeq	r0, r0, ip, lsl r0
 550:	000003dc 	ldrdeq	r0, [r0], -ip
 554:	00008ffc 	strdeq	r8, [r0], -ip
 558:	00000068 	andeq	r0, r0, r8, rrx
 55c:	8b040e42 	blhi	103e6c <__bss_end+0xf9b30>
 560:	0b0d4201 	bleq	350d6c <__bss_end+0x346a30>
 564:	420d0d6c 	andmi	r0, sp, #108, 26	; 0x1b00
 568:	00000ecb 	andeq	r0, r0, fp, asr #29
 56c:	0000002c 	andeq	r0, r0, ip, lsr #32
 570:	000003dc 	ldrdeq	r0, [r0], -ip
 574:	00009064 	andeq	r9, r0, r4, rrx
 578:	00000328 	andeq	r0, r0, r8, lsr #6
 57c:	84200e42 	strthi	r0, [r0], #-3650	; 0xfffff1be
 580:	86078508 	strhi	r8, [r7], -r8, lsl #10
 584:	88058706 	stmdahi	r5, {r1, r2, r8, r9, sl, pc}
 588:	8b038904 	blhi	e29a0 <__bss_end+0xd8664>
 58c:	42018e02 	andmi	r8, r1, #2, 28
 590:	03040b0c 	movweq	r0, #19212	; 0x4b0c
 594:	0d0c018a 	stfeqs	f0, [ip, #-552]	; 0xfffffdd8
 598:	00000020 	andeq	r0, r0, r0, lsr #32
 59c:	0000000c 	andeq	r0, r0, ip
 5a0:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 5a4:	7c020001 	stcvc	0, cr0, [r2], {1}
 5a8:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 5ac:	0000001c 	andeq	r0, r0, ip, lsl r0
 5b0:	0000059c 	muleq	r0, ip, r5
 5b4:	0000938c 	andeq	r9, r0, ip, lsl #7
 5b8:	00000068 	andeq	r0, r0, r8, rrx
 5bc:	8b080e42 	blhi	203ecc <__bss_end+0x1f9b90>
 5c0:	42018e02 	andmi	r8, r1, #2, 28
 5c4:	6e040b0c 	vmlavs.f64	d0, d4, d12
 5c8:	00080d0c 	andeq	r0, r8, ip, lsl #26
 5cc:	0000001c 	andeq	r0, r0, ip, lsl r0
 5d0:	0000059c 	muleq	r0, ip, r5
 5d4:	000093f4 	strdeq	r9, [r0], -r4
 5d8:	0000004c 	andeq	r0, r0, ip, asr #32
 5dc:	8b080e42 	blhi	203eec <__bss_end+0x1f9bb0>
 5e0:	42018e02 	andmi	r8, r1, #2, 28
 5e4:	60040b0c 	andvs	r0, r4, ip, lsl #22
 5e8:	00080d0c 	andeq	r0, r8, ip, lsl #26
 5ec:	0000001c 	andeq	r0, r0, ip, lsl r0
 5f0:	0000059c 	muleq	r0, ip, r5
 5f4:	00009440 	andeq	r9, r0, r0, asr #8
 5f8:	00000028 	andeq	r0, r0, r8, lsr #32
 5fc:	8b040e42 	blhi	103f0c <__bss_end+0xf9bd0>
 600:	0b0d4201 	bleq	350e0c <__bss_end+0x346ad0>
 604:	420d0d4c 	andmi	r0, sp, #76, 26	; 0x1300
 608:	00000ecb 	andeq	r0, r0, fp, asr #29
 60c:	0000001c 	andeq	r0, r0, ip, lsl r0
 610:	0000059c 	muleq	r0, ip, r5
 614:	00009468 	andeq	r9, r0, r8, ror #8
 618:	0000007c 	andeq	r0, r0, ip, ror r0
 61c:	8b080e42 	blhi	203f2c <__bss_end+0x1f9bf0>
 620:	42018e02 	andmi	r8, r1, #2, 28
 624:	78040b0c 	stmdavc	r4, {r2, r3, r8, r9, fp}
 628:	00080d0c 	andeq	r0, r8, ip, lsl #26
 62c:	0000001c 	andeq	r0, r0, ip, lsl r0
 630:	0000059c 	muleq	r0, ip, r5
 634:	000094e4 	andeq	r9, r0, r4, ror #9
 638:	000000ec 	andeq	r0, r0, ip, ror #1
 63c:	8b080e42 	blhi	203f4c <__bss_end+0x1f9c10>
 640:	42018e02 	andmi	r8, r1, #2, 28
 644:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 648:	080d0c70 	stmdaeq	sp, {r4, r5, r6, sl, fp}
 64c:	0000001c 	andeq	r0, r0, ip, lsl r0
 650:	0000059c 	muleq	r0, ip, r5
 654:	000095d0 	ldrdeq	r9, [r0], -r0
 658:	00000168 	andeq	r0, r0, r8, ror #2
 65c:	8b080e42 	blhi	203f6c <__bss_end+0x1f9c30>
 660:	42018e02 	andmi	r8, r1, #2, 28
 664:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 668:	080d0cac 	stmdaeq	sp, {r2, r3, r5, r7, sl, fp}
 66c:	0000001c 	andeq	r0, r0, ip, lsl r0
 670:	0000059c 	muleq	r0, ip, r5
 674:	00009738 	andeq	r9, r0, r8, lsr r7
 678:	00000058 	andeq	r0, r0, r8, asr r0
 67c:	8b080e42 	blhi	203f8c <__bss_end+0x1f9c50>
 680:	42018e02 	andmi	r8, r1, #2, 28
 684:	66040b0c 	strvs	r0, [r4], -ip, lsl #22
 688:	00080d0c 	andeq	r0, r8, ip, lsl #26
 68c:	0000001c 	andeq	r0, r0, ip, lsl r0
 690:	0000059c 	muleq	r0, ip, r5
 694:	00009790 	muleq	r0, r0, r7
 698:	000000b0 	strheq	r0, [r0], -r0	; <UNPREDICTABLE>
 69c:	8b080e42 	blhi	203fac <__bss_end+0x1f9c70>
 6a0:	42018e02 	andmi	r8, r1, #2, 28
 6a4:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 6a8:	080d0c52 	stmdaeq	sp, {r1, r4, r6, sl, fp}
 6ac:	0000000c 	andeq	r0, r0, ip
 6b0:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 6b4:	7c010001 	stcvc	0, cr0, [r1], {1}
 6b8:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 6bc:	0000000c 	andeq	r0, r0, ip
 6c0:	000006ac 	andeq	r0, r0, ip, lsr #13
 6c4:	00009840 	andeq	r9, r0, r0, asr #16
 6c8:	000001ec 	andeq	r0, r0, ip, ror #3
 6cc:	0000000c 	andeq	r0, r0, ip
 6d0:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 6d4:	7c020001 	stcvc	0, cr0, [r2], {1}
 6d8:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 6dc:	00000010 	andeq	r0, r0, r0, lsl r0
 6e0:	000006cc 	andeq	r0, r0, ip, asr #13
 6e4:	00009a50 	andeq	r9, r0, r0, asr sl
 6e8:	0000019c 	muleq	r0, ip, r1
 6ec:	0bce020a 	bleq	ff380f1c <__bss_end+0xff376be0>
 6f0:	00000010 	andeq	r0, r0, r0, lsl r0
 6f4:	000006cc 	andeq	r0, r0, ip, asr #13
 6f8:	00009bec 	andeq	r9, r0, ip, ror #23
 6fc:	00000028 	andeq	r0, r0, r8, lsr #32
 700:	000b540a 	andeq	r5, fp, sl, lsl #8
 704:	00000010 	andeq	r0, r0, r0, lsl r0
 708:	000006cc 	andeq	r0, r0, ip, asr #13
 70c:	00009c14 	andeq	r9, r0, r4, lsl ip
 710:	0000008c 	andeq	r0, r0, ip, lsl #1
 714:	0b46020a 	bleq	1180f44 <__bss_end+0x1176c08>
 718:	0000000c 	andeq	r0, r0, ip
 71c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 720:	7c020001 	stcvc	0, cr0, [r2], {1}
 724:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 728:	00000030 	andeq	r0, r0, r0, lsr r0
 72c:	00000718 	andeq	r0, r0, r8, lsl r7
 730:	00009ca0 	andeq	r9, r0, r0, lsr #25
 734:	000000d4 	ldrdeq	r0, [r0], -r4
 738:	8e100e5a 	mrchi	14, 0, r0, cr0, cr10, {2}
 73c:	460a4a03 	strmi	r4, [sl], -r3, lsl #20
 740:	42100ece 	andsmi	r0, r0, #3296	; 0xce0
 744:	460a4a0b 	strmi	r4, [sl], -fp, lsl #20
 748:	4a100ece 	bmi	404288 <__bss_end+0x3f9f4c>
 74c:	460a460b 	strmi	r4, [sl], -fp, lsl #12
 750:	46100ece 	ldrmi	r0, [r0], -lr, asr #29
 754:	0ece4c0b 	cdpeq	12, 12, cr4, cr14, cr11, {0}
 758:	00000010 	andeq	r0, r0, r0, lsl r0
 75c:	0000000c 	andeq	r0, r0, ip
 760:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 764:	7c020001 	stcvc	0, cr0, [r2], {1}
 768:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 76c:	00000014 	andeq	r0, r0, r4, lsl r0
 770:	0000075c 	andeq	r0, r0, ip, asr r7
 774:	00009d74 	andeq	r9, r0, r4, ror sp
 778:	00000030 	andeq	r0, r0, r0, lsr r0
 77c:	84080e4e 	strhi	r0, [r8], #-3662	; 0xfffff1b2
 780:	00018e02 	andeq	r8, r1, r2, lsl #28
 784:	0000000c 	andeq	r0, r0, ip
 788:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 78c:	7c020001 	stcvc	0, cr0, [r2], {1}
 790:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 794:	0000000c 	andeq	r0, r0, ip
 798:	00000784 	andeq	r0, r0, r4, lsl #15
 79c:	00009da8 	andeq	r9, r0, r8, lsr #27
 7a0:	00000040 	andeq	r0, r0, r0, asr #32
 7a4:	0000000c 	andeq	r0, r0, ip
 7a8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 7ac:	7c020001 	stcvc	0, cr0, [r2], {1}
 7b0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 7b4:	00000020 	andeq	r0, r0, r0, lsr #32
 7b8:	000007a4 	andeq	r0, r0, r4, lsr #15
 7bc:	00009de8 	andeq	r9, r0, r8, ror #27
 7c0:	00000120 	andeq	r0, r0, r0, lsr #2
 7c4:	841c0e46 	ldrhi	r0, [ip], #-3654	; 0xfffff1ba
 7c8:	86068507 	strhi	r8, [r6], -r7, lsl #10
 7cc:	88048705 	stmdahi	r4, {r0, r2, r8, r9, sl, pc}
 7d0:	8e028903 	vmlahi.f16	s16, s4, s6	; <UNPREDICTABLE>
 7d4:	00000001 	andeq	r0, r0, r1

Disassembly of section .debug_loc:

00000000 <.debug_loc>:
	...
   c:	00000013 	andeq	r0, r0, r3, lsl r0
  10:	13500001 	cmpne	r0, #1
  14:	14000000 	strne	r0, [r0], #-0
  18:	06000000 	streq	r0, [r0], -r0
  1c:	f503f300 			; <UNDEFINED> instruction: 0xf503f300
  20:	149f2500 	ldrne	r2, [pc], #1280	; 28 <shift+0x28>
  24:	20000000 	andcs	r0, r0, r0
  28:	01000000 	mrseq	r0, (UNDEF: 0)
  2c:	00205000 	eoreq	r5, r0, r0
  30:	00300000 	eorseq	r0, r0, r0
  34:	00060000 	andeq	r0, r6, r0
  38:	00f503f3 	ldrshteq	r0, [r5], #51	; 0x33
  3c:	00009f25 	andeq	r9, r0, r5, lsr #30
	...
  4c:	002c0000 	eoreq	r0, ip, r0
  50:	00010000 	andeq	r0, r1, r0
  54:	00002c50 	andeq	r2, r0, r0, asr ip
  58:	00004000 	andeq	r4, r0, r0
  5c:	f3000600 	vmax.u8	d0, d0, d0
  60:	3300f503 	movwcc	pc, #1283	; 0x503	; <UNPREDICTABLE>
  64:	0000009f 	muleq	r0, pc, r0	; <UNPREDICTABLE>
	...
  70:	10000000 	andne	r0, r0, r0
  74:	24000000 	strcs	r0, [r0], #-0
  78:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
  7c:	934e9000 	movtls	r9, #57344	; 0xe000
  80:	934f9004 	movtls	r9, #61444	; 0xf004
  84:	00002404 	andeq	r2, r0, r4, lsl #8
  88:	00002c00 	andeq	r2, r0, r0, lsl #24
  8c:	f5000600 			; <UNDEFINED> instruction: 0xf5000600
  90:	25f73300 	ldrbcs	r3, [r7, #768]!	; 0x300
  94:	00002c9f 	muleq	r0, pc, ip	; <UNPREDICTABLE>
  98:	00004000 	andeq	r4, r0, r0
  9c:	f3000800 	vsub.i8	d0, d0, d0
  a0:	3300f503 	movwcc	pc, #1283	; 0x503	; <UNPREDICTABLE>
  a4:	009f25f7 			; <UNDEFINED> instruction: 0x009f25f7
	...
  b0:	00001800 	andeq	r1, r0, r0, lsl #16
  b4:	00004000 	andeq	r4, r0, r0
  b8:	90000200 	andls	r0, r0, r0, lsl #4
  bc:	0000004c 	andeq	r0, r0, ip, asr #32
  c0:	00000000 	andeq	r0, r0, r0
  c4:	00000100 	andeq	r0, r0, r0, lsl #2
  c8:	18000000 	stmdane	r0, {}	; <UNPREDICTABLE>
  cc:	24000000 	strcs	r0, [r0], #-0
  d0:	1a000000 	bne	d8 <shift+0xd8>
  d4:	254ef500 	strbcs	pc, [lr, #-1280]	; 0xfffffb00	; <UNPREDICTABLE>
  d8:	f7004c92 			; <UNDEFINED> instruction: 0xf7004c92
  dc:	f425f72c 	vld1.8	{d15}, [r5 :128], ip
  e0:	00000825 	andeq	r0, r0, r5, lsr #16
  e4:	00000000 	andeq	r0, r0, r0
  e8:	1c1e41f0 	ldfnes	f4, [lr], {240}	; 0xf0
  ec:	249f2cf7 	ldrcs	r2, [pc], #3319	; f4 <shift+0xf4>
  f0:	2c000000 	stccs	0, cr0, [r0], {-0}
  f4:	1c000000 	stcne	0, cr0, [r0], {-0}
  f8:	3300f500 	movwcc	pc, #1280	; 0x500	; <UNPREDICTABLE>
  fc:	4c9225f7 	cfldr32mi	mvfx2, [r2], {247}	; 0xf7
 100:	f72cf700 			; <UNDEFINED> instruction: 0xf72cf700
 104:	0825f425 	stmdaeq	r5!, {r0, r2, r5, sl, ip, sp, lr, pc}
 108:	00000000 	andeq	r0, r0, r0
 10c:	41f00000 	mvnsmi	r0, r0
 110:	2cf71c1e 	ldclcs	12, cr1, [r7], #120	; 0x78
 114:	00002c9f 	muleq	r0, pc, ip	; <UNPREDICTABLE>
 118:	00004000 	andeq	r4, r0, r0
 11c:	f3001e00 	vcge.f32	d1, d0, d0
 120:	3300f503 	movwcc	pc, #1283	; 0x503	; <UNPREDICTABLE>
 124:	4c9225f7 	cfldr32mi	mvfx2, [r2], {247}	; 0xf7
 128:	f72cf700 			; <UNDEFINED> instruction: 0xf72cf700
 12c:	0825f425 	stmdaeq	r5!, {r0, r2, r5, sl, ip, sp, lr, pc}
 130:	00000000 	andeq	r0, r0, r0
 134:	41f00000 	mvnsmi	r0, r0
 138:	2cf71c1e 	ldclcs	12, cr1, [r7], #120	; 0x78
 13c:	0000009f 	muleq	r0, pc, r0	; <UNPREDICTABLE>
	...
 14c:	00007800 	andeq	r7, r0, r0, lsl #16
 150:	50000600 	andpl	r0, r0, r0, lsl #12
 154:	93510493 	cmpls	r1, #-1828716544	; 0x93000000
 158:	00007804 	andeq	r7, r0, r4, lsl #16
 15c:	00012000 	andeq	r2, r1, r0
 160:	f3000600 	vmax.u8	d0, d0, d0
 164:	2500f503 	strcs	pc, [r0, #-1283]	; 0xfffffafd
 168:	0000009f 	muleq	r0, pc, r0	; <UNPREDICTABLE>
	...
 178:	00006000 	andeq	r6, r0, r0
 17c:	52000600 	andpl	r0, r0, #0, 12
 180:	93530493 	cmpls	r3, #-1828716544	; 0x93000000
 184:	00006004 	andeq	r6, r0, r4
 188:	00012000 	andeq	r2, r1, r0
 18c:	f3000600 	vmax.u8	d0, d0, d0
 190:	2502f503 	strcs	pc, [r2, #-1283]	; 0xfffffafd
 194:	0000009f 	muleq	r0, pc, r0	; <UNPREDICTABLE>
 198:	00000000 	andeq	r0, r0, r0
 19c:	01010200 	mrseq	r0, R9_usr
	...
 1a8:	00008400 	andeq	r8, r0, r0, lsl #8
 1ac:	9e000a00 	vmlals.f32	s0, s0, s0
 1b0:	00000008 	andeq	r0, r0, r8
 1b4:	00000000 	andeq	r0, r0, r0
 1b8:	00008400 	andeq	r8, r0, r0, lsl #8
 1bc:	0000e000 	andeq	lr, r0, r0
 1c0:	55000600 	strpl	r0, [r0, #-1536]	; 0xfffffa00
 1c4:	93560493 	cmpls	r6, #-1828716544	; 0x93000000
 1c8:	0000ec04 	andeq	lr, r0, r4, lsl #24
 1cc:	00010800 	andeq	r0, r1, r0, lsl #16
 1d0:	55000600 	strpl	r0, [r0, #-1536]	; 0xfffffa00
 1d4:	93560493 	cmpls	r6, #-1828716544	; 0x93000000
 1d8:	00010c04 	andeq	r0, r1, r4, lsl #24
 1dc:	00012000 	andeq	r2, r1, r0
 1e0:	55000600 	strpl	r0, [r0, #-1536]	; 0xfffffa00
 1e4:	93560493 	cmpls	r6, #-1828716544	; 0x93000000
 1e8:	00000004 	andeq	r0, r0, r4
 1ec:	00000000 	andeq	r0, r0, r0
 1f0:	00000200 	andeq	r0, r0, r0, lsl #4
	...
 1fc:	78000000 	stmdavc	r0, {}	; <UNPREDICTABLE>
 200:	06000000 	streq	r0, [r0], -r0
 204:	04935000 	ldreq	r5, [r3], #0
 208:	84049351 	strhi	r9, [r4], #-849	; 0xfffffcaf
 20c:	a8000000 	stmdage	r0, {}	; <UNPREDICTABLE>
 210:	06000000 	streq	r0, [r0], -r0
 214:	04935000 	ldreq	r5, [r3], #0
 218:	b8049351 	stmdalt	r4, {r0, r4, r6, r8, r9, ip, pc}
 21c:	d0000000 	andle	r0, r0, r0
 220:	06000000 	streq	r0, [r0], -r0
 224:	04935000 	ldreq	r5, [r3], #0
 228:	d4049351 	strle	r9, [r4], #-849	; 0xfffffcaf
 22c:	dc000000 	stcle	0, cr0, [r0], {-0}
 230:	06000000 	streq	r0, [r0], -r0
 234:	04935000 	ldreq	r5, [r3], #0
 238:	f4049351 	vst2.16	{d9-d12}, [r4 :64], r1
 23c:	18000000 	stmdane	r0, {}	; <UNPREDICTABLE>
 240:	06000001 	streq	r0, [r0], -r1
 244:	04935000 	ldreq	r5, [r3], #0
 248:	00049351 	andeq	r9, r4, r1, asr r3
 24c:	00000000 	andeq	r0, r0, r0
 250:	02000000 	andeq	r0, r0, #0
	...
 25c:	00004400 	andeq	r4, r0, r0, lsl #8
 260:	52000600 	andpl	r0, r0, #0, 12
 264:	93530493 	cmpls	r3, #-1828716544	; 0x93000000
 268:	00005804 	andeq	r5, r0, r4, lsl #16
 26c:	00009000 	andeq	r9, r0, r0
 270:	54000600 	strpl	r0, [r0], #-1536	; 0xfffffa00
 274:	93530493 	cmpls	r3, #-1828716544	; 0x93000000
 278:	00009804 	andeq	r9, r0, r4, lsl #16
 27c:	00010c00 	andeq	r0, r1, r0, lsl #24
 280:	54000600 	strpl	r0, [r0], #-1536	; 0xfffffa00
 284:	93520493 	cmpls	r2, #-1828716544	; 0x93000000
 288:	00000004 	andeq	r0, r0, r4
 28c:	00000000 	andeq	r0, r0, r0
 290:	2c000000 	stccs	0, cr0, [r0], {-0}
 294:	34000000 	strcc	r0, [r0], #-0
 298:	03000000 	movweq	r0, #0
 29c:	9f207c00 	svcls	0x00207c00
	...
 2a8:	003c0000 	eorseq	r0, ip, r0
 2ac:	00400000 	subeq	r0, r0, r0
 2b0:	00010000 	andeq	r0, r1, r0
 2b4:	0000005c 	andeq	r0, r0, ip, asr r0
 2b8:	00000000 	andeq	r0, r0, r0
 2bc:	00000100 	andeq	r0, r0, r0, lsl #2
 2c0:	00000101 	andeq	r0, r0, r1, lsl #2
 2c4:	00000101 	andeq	r0, r0, r1, lsl #2
 2c8:	00009800 	andeq	r9, r0, r0, lsl #16
 2cc:	0000a000 	andeq	sl, r0, r0
 2d0:	5c000100 	stfpls	f0, [r0], {-0}
 2d4:	000000a0 	andeq	r0, r0, r0, lsr #1
 2d8:	000000b8 	strheq	r0, [r0], -r8
 2dc:	b85e0001 	ldmdalt	lr, {r0}^
 2e0:	bc000000 	stclt	0, cr0, [r0], {-0}
 2e4:	03000000 	movweq	r0, #0
 2e8:	9f7f7e00 	svcls	0x007f7e00
 2ec:	000000bc 	strheq	r0, [r0], -ip
 2f0:	000000d4 	ldrdeq	r0, [r0], -r4
 2f4:	d45e0001 	ldrble	r0, [lr], #-1
 2f8:	d8000000 	stmdale	r0, {}	; <UNPREDICTABLE>
 2fc:	03000000 	movweq	r0, #0
 300:	9f7f7e00 	svcls	0x007f7e00
 304:	000000d8 	ldrdeq	r0, [r0], -r8
 308:	0000010c 	andeq	r0, r0, ip, lsl #2
 30c:	005e0001 	subseq	r0, lr, r1
	...
 318:	40000000 	andmi	r0, r0, r0
 31c:	fc000000 	stc2	0, cr0, [r0], {-0}
 320:	01000000 	mrseq	r0, (UNDEF: 0)
 324:	00fc5c00 	rscseq	r5, ip, r0, lsl #24
 328:	010c0000 	mrseq	r0, (UNDEF: 12)
 32c:	00030000 	andeq	r0, r3, r0
 330:	009f2079 	addseq	r2, pc, r9, ror r0	; <UNPREDICTABLE>
 334:	00000000 	andeq	r0, r0, r0
 338:	Address 0x0000000000000338 is out of bounds.

