
./logger_task:     file format elf32-littlearm


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
    805c:	00009bd8 	ldrdeq	r9, [r0], -r8
    8060:	00009be8 	andeq	r9, r0, r8, ror #23

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
    81cc:	00009bd8 	ldrdeq	r9, [r0], -r8
    81d0:	00009bd8 	ldrdeq	r9, [r0], -r8

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
    8224:	00009bd8 	ldrdeq	r9, [r0], -r8
    8228:	00009bd8 	ldrdeq	r9, [r0], -r8

0000822c <_ZL5fputsjPKc>:
_ZL5fputsjPKc():
/home/trefil/sem/sources/userspace/logger_task/main.cpp:13
 * 
 * Prijima vsechny udalosti od ostatnich tasku a oznamuje je skrz UART hostiteli
 **/

static void fputs(uint32_t file, const char* string)
{
    822c:	e92d4800 	push	{fp, lr}
    8230:	e28db004 	add	fp, sp, #4
    8234:	e24dd008 	sub	sp, sp, #8
    8238:	e50b0008 	str	r0, [fp, #-8]
    823c:	e50b100c 	str	r1, [fp, #-12]
/home/trefil/sem/sources/userspace/logger_task/main.cpp:14
	write(file, string, strlen(string));
    8240:	e51b000c 	ldr	r0, [fp, #-12]
    8244:	eb0002f2 	bl	8e14 <_Z6strlenPKc>
    8248:	e1a03000 	mov	r3, r0
    824c:	e1a02003 	mov	r2, r3
    8250:	e51b100c 	ldr	r1, [fp, #-12]
    8254:	e51b0008 	ldr	r0, [fp, #-8]
    8258:	eb000095 	bl	84b4 <_Z5writejPKcj>
/home/trefil/sem/sources/userspace/logger_task/main.cpp:15
}
    825c:	e320f000 	nop	{0}
    8260:	e24bd004 	sub	sp, fp, #4
    8264:	e8bd8800 	pop	{fp, pc}

00008268 <main>:
main():
/home/trefil/sem/sources/userspace/logger_task/main.cpp:18

int main(int argc, char** argv)
{
    8268:	e92d4800 	push	{fp, lr}
    826c:	e28db004 	add	fp, sp, #4
    8270:	e24dd048 	sub	sp, sp, #72	; 0x48
    8274:	e50b0048 	str	r0, [fp, #-72]	; 0xffffffb8
    8278:	e50b104c 	str	r1, [fp, #-76]	; 0xffffffb4
/home/trefil/sem/sources/userspace/logger_task/main.cpp:19
	uint32_t uart_file = open("DEV:uart/0", NFile_Open_Mode::Write_Only);
    827c:	e3a01001 	mov	r1, #1
    8280:	e59f010c 	ldr	r0, [pc, #268]	; 8394 <main+0x12c>
    8284:	eb000065 	bl	8420 <_Z4openPKc15NFile_Open_Mode>
    8288:	e50b0008 	str	r0, [fp, #-8]
/home/trefil/sem/sources/userspace/logger_task/main.cpp:22

	TUART_IOCtl_Params params;
	params.baud_rate = NUART_Baud_Rate::BR_115200;
    828c:	e59f3104 	ldr	r3, [pc, #260]	; 8398 <main+0x130>
    8290:	e50b3020 	str	r3, [fp, #-32]	; 0xffffffe0
/home/trefil/sem/sources/userspace/logger_task/main.cpp:23
	params.char_length = NUART_Char_Length::Char_8;
    8294:	e3a03001 	mov	r3, #1
    8298:	e50b3024 	str	r3, [fp, #-36]	; 0xffffffdc
/home/trefil/sem/sources/userspace/logger_task/main.cpp:24
	ioctl(uart_file, NIOCtl_Operation::Set_Params, &params);
    829c:	e24b3024 	sub	r3, fp, #36	; 0x24
    82a0:	e1a02003 	mov	r2, r3
    82a4:	e3a01001 	mov	r1, #1
    82a8:	e51b0008 	ldr	r0, [fp, #-8]
    82ac:	eb00009f 	bl	8530 <_Z5ioctlj16NIOCtl_OperationPv>
/home/trefil/sem/sources/userspace/logger_task/main.cpp:26

	fputs(uart_file, "UART task starting!");
    82b0:	e59f10e4 	ldr	r1, [pc, #228]	; 839c <main+0x134>
    82b4:	e51b0008 	ldr	r0, [fp, #-8]
    82b8:	ebffffdb 	bl	822c <_ZL5fputsjPKc>
/home/trefil/sem/sources/userspace/logger_task/main.cpp:30

	char buf[16];
	char tickbuf[16];
	bzero(buf, 16);
    82bc:	e24b3034 	sub	r3, fp, #52	; 0x34
    82c0:	e3a01010 	mov	r1, #16
    82c4:	e1a00003 	mov	r0, r3
    82c8:	eb000347 	bl	8fec <_Z5bzeroPvi>
/home/trefil/sem/sources/userspace/logger_task/main.cpp:31
	bzero(tickbuf, 16);
    82cc:	e24b3044 	sub	r3, fp, #68	; 0x44
    82d0:	e3a01010 	mov	r1, #16
    82d4:	e1a00003 	mov	r0, r3
    82d8:	eb000343 	bl	8fec <_Z5bzeroPvi>
/home/trefil/sem/sources/userspace/logger_task/main.cpp:33

	uint32_t last_tick = 0;
    82dc:	e3a03000 	mov	r3, #0
    82e0:	e50b300c 	str	r3, [fp, #-12]
/home/trefil/sem/sources/userspace/logger_task/main.cpp:35

	uint32_t logpipe = pipe("log", 32);
    82e4:	e3a01020 	mov	r1, #32
    82e8:	e59f00b0 	ldr	r0, [pc, #176]	; 83a0 <main+0x138>
    82ec:	eb000119 	bl	8758 <_Z4pipePKcj>
    82f0:	e50b0010 	str	r0, [fp, #-16]
/home/trefil/sem/sources/userspace/logger_task/main.cpp:40

	while (true)
	{

		wait(logpipe, 1, 0x1000);
    82f4:	e3a02a01 	mov	r2, #4096	; 0x1000
    82f8:	e3a01001 	mov	r1, #1
    82fc:	e51b0010 	ldr	r0, [fp, #-16]
    8300:	eb0000af 	bl	85c4 <_Z4waitjjj>
/home/trefil/sem/sources/userspace/logger_task/main.cpp:42

		uint32_t v = read(logpipe, buf, 15);
    8304:	e24b3034 	sub	r3, fp, #52	; 0x34
    8308:	e3a0200f 	mov	r2, #15
    830c:	e1a01003 	mov	r1, r3
    8310:	e51b0010 	ldr	r0, [fp, #-16]
    8314:	eb000052 	bl	8464 <_Z4readjPcj>
    8318:	e50b0014 	str	r0, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/userspace/logger_task/main.cpp:43
		if (v > 0)
    831c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8320:	e3530000 	cmp	r3, #0
    8324:	0afffff2 	beq	82f4 <main+0x8c>
/home/trefil/sem/sources/userspace/logger_task/main.cpp:45
		{
			buf[v] = '\0';
    8328:	e24b2034 	sub	r2, fp, #52	; 0x34
    832c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8330:	e0823003 	add	r3, r2, r3
    8334:	e3a02000 	mov	r2, #0
    8338:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/userspace/logger_task/main.cpp:46
			fputs(uart_file, "\r\n[ ");
    833c:	e59f1060 	ldr	r1, [pc, #96]	; 83a4 <main+0x13c>
    8340:	e51b0008 	ldr	r0, [fp, #-8]
    8344:	ebffffb8 	bl	822c <_ZL5fputsjPKc>
/home/trefil/sem/sources/userspace/logger_task/main.cpp:47
			uint32_t tick = get_tick_count();
    8348:	eb0000d5 	bl	86a4 <_Z14get_tick_countv>
    834c:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/userspace/logger_task/main.cpp:48
			itoa(tick, tickbuf, 16);
    8350:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8354:	e24b1044 	sub	r1, fp, #68	; 0x44
    8358:	e3a02010 	mov	r2, #16
    835c:	e1a00003 	mov	r0, r3
    8360:	eb000128 	bl	8808 <_Z4itoaiPcj>
/home/trefil/sem/sources/userspace/logger_task/main.cpp:49
			fputs(uart_file, tickbuf);
    8364:	e24b3044 	sub	r3, fp, #68	; 0x44
    8368:	e1a01003 	mov	r1, r3
    836c:	e51b0008 	ldr	r0, [fp, #-8]
    8370:	ebffffad 	bl	822c <_ZL5fputsjPKc>
/home/trefil/sem/sources/userspace/logger_task/main.cpp:50
			fputs(uart_file, "]: ");
    8374:	e59f102c 	ldr	r1, [pc, #44]	; 83a8 <main+0x140>
    8378:	e51b0008 	ldr	r0, [fp, #-8]
    837c:	ebffffaa 	bl	822c <_ZL5fputsjPKc>
/home/trefil/sem/sources/userspace/logger_task/main.cpp:51
			fputs(uart_file, buf);
    8380:	e24b3034 	sub	r3, fp, #52	; 0x34
    8384:	e1a01003 	mov	r1, r3
    8388:	e51b0008 	ldr	r0, [fp, #-8]
    838c:	ebffffa6 	bl	822c <_ZL5fputsjPKc>
/home/trefil/sem/sources/userspace/logger_task/main.cpp:53
		}
	}
    8390:	eaffffd7 	b	82f4 <main+0x8c>
    8394:	00009b54 	andeq	r9, r0, r4, asr fp
    8398:	0001c200 	andeq	ip, r1, r0, lsl #4
    839c:	00009b60 	andeq	r9, r0, r0, ror #22
    83a0:	00009b74 	andeq	r9, r0, r4, ror fp
    83a4:	00009b78 	andeq	r9, r0, r8, ror fp
    83a8:	00009b80 	andeq	r9, r0, r0, lsl #23

000083ac <_Z6getpidv>:
_Z6getpidv():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:5
#include <stdfile.h>
#include <stdstring.h>

uint32_t getpid()
{
    83ac:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    83b0:	e28db000 	add	fp, sp, #0
    83b4:	e24dd00c 	sub	sp, sp, #12
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:8
    uint32_t pid;

    asm volatile("swi 0");
    83b8:	ef000000 	svc	0x00000000
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:9
    asm volatile("mov %0, r0" : "=r" (pid));
    83bc:	e1a03000 	mov	r3, r0
    83c0:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:11

    return pid;
    83c4:	e51b3008 	ldr	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:12
}
    83c8:	e1a00003 	mov	r0, r3
    83cc:	e28bd000 	add	sp, fp, #0
    83d0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    83d4:	e12fff1e 	bx	lr

000083d8 <_Z9terminatei>:
_Z9terminatei():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:15

void terminate(int exitcode)
{
    83d8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    83dc:	e28db000 	add	fp, sp, #0
    83e0:	e24dd00c 	sub	sp, sp, #12
    83e4:	e50b0008 	str	r0, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:16
    asm volatile("mov r0, %0" : : "r" (exitcode));
    83e8:	e51b3008 	ldr	r3, [fp, #-8]
    83ec:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:17
    asm volatile("swi 1");
    83f0:	ef000001 	svc	0x00000001
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:18
}
    83f4:	e320f000 	nop	{0}
    83f8:	e28bd000 	add	sp, fp, #0
    83fc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8400:	e12fff1e 	bx	lr

00008404 <_Z11sched_yieldv>:
_Z11sched_yieldv():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:21

void sched_yield()
{
    8404:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8408:	e28db000 	add	fp, sp, #0
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:22
    asm volatile("swi 2");
    840c:	ef000002 	svc	0x00000002
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:23
}
    8410:	e320f000 	nop	{0}
    8414:	e28bd000 	add	sp, fp, #0
    8418:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    841c:	e12fff1e 	bx	lr

00008420 <_Z4openPKc15NFile_Open_Mode>:
_Z4openPKc15NFile_Open_Mode():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:26

uint32_t open(const char* filename, NFile_Open_Mode mode)
{
    8420:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8424:	e28db000 	add	fp, sp, #0
    8428:	e24dd014 	sub	sp, sp, #20
    842c:	e50b0010 	str	r0, [fp, #-16]
    8430:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:29
    uint32_t file;

    asm volatile("mov r0, %0" : : "r" (filename));
    8434:	e51b3010 	ldr	r3, [fp, #-16]
    8438:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:30
    asm volatile("mov r1, %0" : : "r" (mode));
    843c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8440:	e1a01003 	mov	r1, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:31
    asm volatile("swi 64");
    8444:	ef000040 	svc	0x00000040
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:32
    asm volatile("mov %0, r0" : "=r" (file));
    8448:	e1a03000 	mov	r3, r0
    844c:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:34

    return file;
    8450:	e51b3008 	ldr	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:35
}
    8454:	e1a00003 	mov	r0, r3
    8458:	e28bd000 	add	sp, fp, #0
    845c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8460:	e12fff1e 	bx	lr

00008464 <_Z4readjPcj>:
_Z4readjPcj():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:38

uint32_t read(uint32_t file, char* const buffer, uint32_t size)
{
    8464:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8468:	e28db000 	add	fp, sp, #0
    846c:	e24dd01c 	sub	sp, sp, #28
    8470:	e50b0010 	str	r0, [fp, #-16]
    8474:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8478:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:41
    uint32_t rdnum;

    asm volatile("mov r0, %0" : : "r" (file));
    847c:	e51b3010 	ldr	r3, [fp, #-16]
    8480:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:42
    asm volatile("mov r1, %0" : : "r" (buffer));
    8484:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8488:	e1a01003 	mov	r1, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:43
    asm volatile("mov r2, %0" : : "r" (size));
    848c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8490:	e1a02003 	mov	r2, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:44
    asm volatile("swi 65");
    8494:	ef000041 	svc	0x00000041
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:45
    asm volatile("mov %0, r0" : "=r" (rdnum));
    8498:	e1a03000 	mov	r3, r0
    849c:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:47

    return rdnum;
    84a0:	e51b3008 	ldr	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:48
}
    84a4:	e1a00003 	mov	r0, r3
    84a8:	e28bd000 	add	sp, fp, #0
    84ac:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    84b0:	e12fff1e 	bx	lr

000084b4 <_Z5writejPKcj>:
_Z5writejPKcj():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:52


uint32_t write(uint32_t file, const char* buffer, uint32_t size)
{
    84b4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    84b8:	e28db000 	add	fp, sp, #0
    84bc:	e24dd01c 	sub	sp, sp, #28
    84c0:	e50b0010 	str	r0, [fp, #-16]
    84c4:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    84c8:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:55
    uint32_t wrnum;

    asm volatile("mov r0, %0" : : "r" (file));
    84cc:	e51b3010 	ldr	r3, [fp, #-16]
    84d0:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:56
    asm volatile("mov r1, %0" : : "r" (buffer));
    84d4:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    84d8:	e1a01003 	mov	r1, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:57
    asm volatile("mov r2, %0" : : "r" (size));
    84dc:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    84e0:	e1a02003 	mov	r2, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:58
    asm volatile("swi 66");
    84e4:	ef000042 	svc	0x00000042
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:59
    asm volatile("mov %0, r0" : "=r" (wrnum));
    84e8:	e1a03000 	mov	r3, r0
    84ec:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:61

    return wrnum;
    84f0:	e51b3008 	ldr	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:62
}
    84f4:	e1a00003 	mov	r0, r3
    84f8:	e28bd000 	add	sp, fp, #0
    84fc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8500:	e12fff1e 	bx	lr

00008504 <_Z5closej>:
_Z5closej():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:65

void close(uint32_t file)
{
    8504:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8508:	e28db000 	add	fp, sp, #0
    850c:	e24dd00c 	sub	sp, sp, #12
    8510:	e50b0008 	str	r0, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:66
    asm volatile("mov r0, %0" : : "r" (file));
    8514:	e51b3008 	ldr	r3, [fp, #-8]
    8518:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:67
    asm volatile("swi 67");
    851c:	ef000043 	svc	0x00000043
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:68
}
    8520:	e320f000 	nop	{0}
    8524:	e28bd000 	add	sp, fp, #0
    8528:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    852c:	e12fff1e 	bx	lr

00008530 <_Z5ioctlj16NIOCtl_OperationPv>:
_Z5ioctlj16NIOCtl_OperationPv():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:71

uint32_t ioctl(uint32_t file, NIOCtl_Operation operation, void* param)
{
    8530:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8534:	e28db000 	add	fp, sp, #0
    8538:	e24dd01c 	sub	sp, sp, #28
    853c:	e50b0010 	str	r0, [fp, #-16]
    8540:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8544:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:74
    uint32_t retcode;

    asm volatile("mov r0, %0" : : "r" (file));
    8548:	e51b3010 	ldr	r3, [fp, #-16]
    854c:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:75
    asm volatile("mov r1, %0" : : "r" (operation));
    8550:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8554:	e1a01003 	mov	r1, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:76
    asm volatile("mov r2, %0" : : "r" (param));
    8558:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    855c:	e1a02003 	mov	r2, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:77
    asm volatile("swi 68");
    8560:	ef000044 	svc	0x00000044
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:78
    asm volatile("mov %0, r0" : "=r" (retcode));
    8564:	e1a03000 	mov	r3, r0
    8568:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:80

    return retcode;
    856c:	e51b3008 	ldr	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:81
}
    8570:	e1a00003 	mov	r0, r3
    8574:	e28bd000 	add	sp, fp, #0
    8578:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    857c:	e12fff1e 	bx	lr

00008580 <_Z6notifyjj>:
_Z6notifyjj():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:84

uint32_t notify(uint32_t file, uint32_t count)
{
    8580:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8584:	e28db000 	add	fp, sp, #0
    8588:	e24dd014 	sub	sp, sp, #20
    858c:	e50b0010 	str	r0, [fp, #-16]
    8590:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:87
    uint32_t retcnt;

    asm volatile("mov r0, %0" : : "r" (file));
    8594:	e51b3010 	ldr	r3, [fp, #-16]
    8598:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:88
    asm volatile("mov r1, %0" : : "r" (count));
    859c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    85a0:	e1a01003 	mov	r1, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:89
    asm volatile("swi 69");
    85a4:	ef000045 	svc	0x00000045
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:90
    asm volatile("mov %0, r0" : "=r" (retcnt));
    85a8:	e1a03000 	mov	r3, r0
    85ac:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:92

    return retcnt;
    85b0:	e51b3008 	ldr	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:93
}
    85b4:	e1a00003 	mov	r0, r3
    85b8:	e28bd000 	add	sp, fp, #0
    85bc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    85c0:	e12fff1e 	bx	lr

000085c4 <_Z4waitjjj>:
_Z4waitjjj():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:96

NSWI_Result_Code wait(uint32_t file, uint32_t count, uint32_t notified_deadline)
{
    85c4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    85c8:	e28db000 	add	fp, sp, #0
    85cc:	e24dd01c 	sub	sp, sp, #28
    85d0:	e50b0010 	str	r0, [fp, #-16]
    85d4:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    85d8:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:99
    NSWI_Result_Code retcode;

    asm volatile("mov r0, %0" : : "r" (file));
    85dc:	e51b3010 	ldr	r3, [fp, #-16]
    85e0:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:100
    asm volatile("mov r1, %0" : : "r" (count));
    85e4:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    85e8:	e1a01003 	mov	r1, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:101
    asm volatile("mov r2, %0" : : "r" (notified_deadline));
    85ec:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    85f0:	e1a02003 	mov	r2, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:102
    asm volatile("swi 70");
    85f4:	ef000046 	svc	0x00000046
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:103
    asm volatile("mov %0, r0" : "=r" (retcode));
    85f8:	e1a03000 	mov	r3, r0
    85fc:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:105

    return retcode;
    8600:	e51b3008 	ldr	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:106
}
    8604:	e1a00003 	mov	r0, r3
    8608:	e28bd000 	add	sp, fp, #0
    860c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8610:	e12fff1e 	bx	lr

00008614 <_Z5sleepjj>:
_Z5sleepjj():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:109

bool sleep(uint32_t ticks, uint32_t notified_deadline)
{
    8614:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8618:	e28db000 	add	fp, sp, #0
    861c:	e24dd014 	sub	sp, sp, #20
    8620:	e50b0010 	str	r0, [fp, #-16]
    8624:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:112
    uint32_t retcode;

    asm volatile("mov r0, %0" : : "r" (ticks));
    8628:	e51b3010 	ldr	r3, [fp, #-16]
    862c:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:113
    asm volatile("mov r1, %0" : : "r" (notified_deadline));
    8630:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8634:	e1a01003 	mov	r1, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:114
    asm volatile("swi 3");
    8638:	ef000003 	svc	0x00000003
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:115
    asm volatile("mov %0, r0" : "=r" (retcode));
    863c:	e1a03000 	mov	r3, r0
    8640:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:117

    return retcode;
    8644:	e51b3008 	ldr	r3, [fp, #-8]
    8648:	e3530000 	cmp	r3, #0
    864c:	13a03001 	movne	r3, #1
    8650:	03a03000 	moveq	r3, #0
    8654:	e6ef3073 	uxtb	r3, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:118
}
    8658:	e1a00003 	mov	r0, r3
    865c:	e28bd000 	add	sp, fp, #0
    8660:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8664:	e12fff1e 	bx	lr

00008668 <_Z24get_active_process_countv>:
_Z24get_active_process_countv():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:121

uint32_t get_active_process_count()
{
    8668:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    866c:	e28db000 	add	fp, sp, #0
    8670:	e24dd00c 	sub	sp, sp, #12
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:122
    const NGet_Sched_Info_Type req = NGet_Sched_Info_Type::Active_Process_Count;
    8674:	e3a03000 	mov	r3, #0
    8678:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:125
    uint32_t retval;

    asm volatile("mov r0, %0" : : "r" (req));
    867c:	e3a03000 	mov	r3, #0
    8680:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:126
    asm volatile("mov r1, %0" : : "r" (&retval));
    8684:	e24b300c 	sub	r3, fp, #12
    8688:	e1a01003 	mov	r1, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:127
    asm volatile("swi 4");
    868c:	ef000004 	svc	0x00000004
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:129

    return retval;
    8690:	e51b300c 	ldr	r3, [fp, #-12]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:130
}
    8694:	e1a00003 	mov	r0, r3
    8698:	e28bd000 	add	sp, fp, #0
    869c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    86a0:	e12fff1e 	bx	lr

000086a4 <_Z14get_tick_countv>:
_Z14get_tick_countv():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:133

uint32_t get_tick_count()
{
    86a4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    86a8:	e28db000 	add	fp, sp, #0
    86ac:	e24dd00c 	sub	sp, sp, #12
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:134
    const NGet_Sched_Info_Type req = NGet_Sched_Info_Type::Tick_Count;
    86b0:	e3a03001 	mov	r3, #1
    86b4:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:137
    uint32_t retval;

    asm volatile("mov r0, %0" : : "r" (req));
    86b8:	e3a03001 	mov	r3, #1
    86bc:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:138
    asm volatile("mov r1, %0" : : "r" (&retval));
    86c0:	e24b300c 	sub	r3, fp, #12
    86c4:	e1a01003 	mov	r1, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:139
    asm volatile("swi 4");
    86c8:	ef000004 	svc	0x00000004
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:141

    return retval;
    86cc:	e51b300c 	ldr	r3, [fp, #-12]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:142
}
    86d0:	e1a00003 	mov	r0, r3
    86d4:	e28bd000 	add	sp, fp, #0
    86d8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    86dc:	e12fff1e 	bx	lr

000086e0 <_Z17set_task_deadlinej>:
_Z17set_task_deadlinej():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:145

void set_task_deadline(uint32_t tick_count_required)
{
    86e0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    86e4:	e28db000 	add	fp, sp, #0
    86e8:	e24dd014 	sub	sp, sp, #20
    86ec:	e50b0010 	str	r0, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:146
    const NDeadline_Subservice req = NDeadline_Subservice::Set_Relative;
    86f0:	e3a03000 	mov	r3, #0
    86f4:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:148

    asm volatile("mov r0, %0" : : "r" (req));
    86f8:	e3a03000 	mov	r3, #0
    86fc:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:149
    asm volatile("mov r1, %0" : : "r" (&tick_count_required));
    8700:	e24b3010 	sub	r3, fp, #16
    8704:	e1a01003 	mov	r1, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:150
    asm volatile("swi 5");
    8708:	ef000005 	svc	0x00000005
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:151
}
    870c:	e320f000 	nop	{0}
    8710:	e28bd000 	add	sp, fp, #0
    8714:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8718:	e12fff1e 	bx	lr

0000871c <_Z26get_task_ticks_to_deadlinev>:
_Z26get_task_ticks_to_deadlinev():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:154

uint32_t get_task_ticks_to_deadline()
{
    871c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8720:	e28db000 	add	fp, sp, #0
    8724:	e24dd00c 	sub	sp, sp, #12
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:155
    const NDeadline_Subservice req = NDeadline_Subservice::Get_Remaining;
    8728:	e3a03001 	mov	r3, #1
    872c:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:158
    uint32_t ticks;

    asm volatile("mov r0, %0" : : "r" (req));
    8730:	e3a03001 	mov	r3, #1
    8734:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:159
    asm volatile("mov r1, %0" : : "r" (&ticks));
    8738:	e24b300c 	sub	r3, fp, #12
    873c:	e1a01003 	mov	r1, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:160
    asm volatile("swi 5");
    8740:	ef000005 	svc	0x00000005
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:162

    return ticks;
    8744:	e51b300c 	ldr	r3, [fp, #-12]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:163
}
    8748:	e1a00003 	mov	r0, r3
    874c:	e28bd000 	add	sp, fp, #0
    8750:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8754:	e12fff1e 	bx	lr

00008758 <_Z4pipePKcj>:
_Z4pipePKcj():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:168

const char Pipe_File_Prefix[] = "SYS:pipe/";

uint32_t pipe(const char* name, uint32_t buf_size)
{
    8758:	e92d4800 	push	{fp, lr}
    875c:	e28db004 	add	fp, sp, #4
    8760:	e24dd050 	sub	sp, sp, #80	; 0x50
    8764:	e50b0050 	str	r0, [fp, #-80]	; 0xffffffb0
    8768:	e50b1054 	str	r1, [fp, #-84]	; 0xffffffac
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:170
    char fname[64];
    strncpy(fname, Pipe_File_Prefix, sizeof(Pipe_File_Prefix));
    876c:	e24b3048 	sub	r3, fp, #72	; 0x48
    8770:	e3a0200a 	mov	r2, #10
    8774:	e59f1088 	ldr	r1, [pc, #136]	; 8804 <_Z4pipePKcj+0xac>
    8778:	e1a00003 	mov	r0, r3
    877c:	eb000149 	bl	8ca8 <_Z7strncpyPcPKci>
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:171
    strncpy(fname + sizeof(Pipe_File_Prefix), name, sizeof(fname) - sizeof(Pipe_File_Prefix) - 1);
    8780:	e24b3048 	sub	r3, fp, #72	; 0x48
    8784:	e283300a 	add	r3, r3, #10
    8788:	e3a02035 	mov	r2, #53	; 0x35
    878c:	e51b1050 	ldr	r1, [fp, #-80]	; 0xffffffb0
    8790:	e1a00003 	mov	r0, r3
    8794:	eb000143 	bl	8ca8 <_Z7strncpyPcPKci>
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:173

    int ncur = sizeof(Pipe_File_Prefix) + strlen(name);
    8798:	e51b0050 	ldr	r0, [fp, #-80]	; 0xffffffb0
    879c:	eb00019c 	bl	8e14 <_Z6strlenPKc>
    87a0:	e1a03000 	mov	r3, r0
    87a4:	e283300a 	add	r3, r3, #10
    87a8:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:175

    fname[ncur++] = '#';
    87ac:	e51b3008 	ldr	r3, [fp, #-8]
    87b0:	e2832001 	add	r2, r3, #1
    87b4:	e50b2008 	str	r2, [fp, #-8]
    87b8:	e2433004 	sub	r3, r3, #4
    87bc:	e083300b 	add	r3, r3, fp
    87c0:	e3a02023 	mov	r2, #35	; 0x23
    87c4:	e5432044 	strb	r2, [r3, #-68]	; 0xffffffbc
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:177

    itoa(buf_size, &fname[ncur], 10);
    87c8:	e51b0054 	ldr	r0, [fp, #-84]	; 0xffffffac
    87cc:	e24b2048 	sub	r2, fp, #72	; 0x48
    87d0:	e51b3008 	ldr	r3, [fp, #-8]
    87d4:	e0823003 	add	r3, r2, r3
    87d8:	e3a0200a 	mov	r2, #10
    87dc:	e1a01003 	mov	r1, r3
    87e0:	eb000008 	bl	8808 <_Z4itoaiPcj>
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:179

    return open(fname, NFile_Open_Mode::Read_Write);
    87e4:	e24b3048 	sub	r3, fp, #72	; 0x48
    87e8:	e3a01002 	mov	r1, #2
    87ec:	e1a00003 	mov	r0, r3
    87f0:	ebffff0a 	bl	8420 <_Z4openPKc15NFile_Open_Mode>
    87f4:	e1a03000 	mov	r3, r0
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:180
}
    87f8:	e1a00003 	mov	r0, r3
    87fc:	e24bd004 	sub	sp, fp, #4
    8800:	e8bd8800 	pop	{fp, pc}
    8804:	00009bb0 			; <UNDEFINED> instruction: 0x00009bb0

00008808 <_Z4itoaiPcj>:
_Z4itoaiPcj():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:9
{
    const char CharConvArr[] = "0123456789ABCDEF";
}

void itoa(int input, char* output, unsigned int base)
{
    8808:	e92d4800 	push	{fp, lr}
    880c:	e28db004 	add	fp, sp, #4
    8810:	e24dd020 	sub	sp, sp, #32
    8814:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    8818:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    881c:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:10
    int i = 0;
    8820:	e3a03000 	mov	r3, #0
    8824:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:11
    int j = 0;
    8828:	e3a03000 	mov	r3, #0
    882c:	e50b300c 	str	r3, [fp, #-12]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:13

	while (input > 0)
    8830:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8834:	e3530000 	cmp	r3, #0
    8838:	da000015 	ble	8894 <_Z4itoaiPcj+0x8c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:15
	{
		output[i] = CharConvArr[input % base];
    883c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8840:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    8844:	e1a00003 	mov	r0, r3
    8848:	eb000380 	bl	9650 <__aeabi_uidivmod>
    884c:	e1a03001 	mov	r3, r1
    8850:	e1a01003 	mov	r1, r3
    8854:	e51b3008 	ldr	r3, [fp, #-8]
    8858:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    885c:	e0823003 	add	r3, r2, r3
    8860:	e59f2114 	ldr	r2, [pc, #276]	; 897c <_Z4itoaiPcj+0x174>
    8864:	e7d22001 	ldrb	r2, [r2, r1]
    8868:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:16
		input /= base;
    886c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8870:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    8874:	e1a00003 	mov	r0, r3
    8878:	eb0002f9 	bl	9464 <__udivsi3>
    887c:	e1a03000 	mov	r3, r0
    8880:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:17
		i++;
    8884:	e51b3008 	ldr	r3, [fp, #-8]
    8888:	e2833001 	add	r3, r3, #1
    888c:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:13
	while (input > 0)
    8890:	eaffffe6 	b	8830 <_Z4itoaiPcj+0x28>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:20
	}

    if (i == 0)
    8894:	e51b3008 	ldr	r3, [fp, #-8]
    8898:	e3530000 	cmp	r3, #0
    889c:	1a000007 	bne	88c0 <_Z4itoaiPcj+0xb8>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:22
    {
        output[i] = CharConvArr[0];
    88a0:	e51b3008 	ldr	r3, [fp, #-8]
    88a4:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    88a8:	e0823003 	add	r3, r2, r3
    88ac:	e3a02030 	mov	r2, #48	; 0x30
    88b0:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:23
        i++;
    88b4:	e51b3008 	ldr	r3, [fp, #-8]
    88b8:	e2833001 	add	r3, r3, #1
    88bc:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:26
    }

	output[i] = '\0';
    88c0:	e51b3008 	ldr	r3, [fp, #-8]
    88c4:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    88c8:	e0823003 	add	r3, r2, r3
    88cc:	e3a02000 	mov	r2, #0
    88d0:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:27
	i--;
    88d4:	e51b3008 	ldr	r3, [fp, #-8]
    88d8:	e2433001 	sub	r3, r3, #1
    88dc:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:29 (discriminator 2)

	for (j; j <= i/2; j++)
    88e0:	e51b3008 	ldr	r3, [fp, #-8]
    88e4:	e1a02fa3 	lsr	r2, r3, #31
    88e8:	e0823003 	add	r3, r2, r3
    88ec:	e1a030c3 	asr	r3, r3, #1
    88f0:	e1a02003 	mov	r2, r3
    88f4:	e51b300c 	ldr	r3, [fp, #-12]
    88f8:	e1530002 	cmp	r3, r2
    88fc:	ca00001b 	bgt	8970 <_Z4itoaiPcj+0x168>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:31 (discriminator 1)
	{
		char c = output[i - j];
    8900:	e51b2008 	ldr	r2, [fp, #-8]
    8904:	e51b300c 	ldr	r3, [fp, #-12]
    8908:	e0423003 	sub	r3, r2, r3
    890c:	e1a02003 	mov	r2, r3
    8910:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8914:	e0833002 	add	r3, r3, r2
    8918:	e5d33000 	ldrb	r3, [r3]
    891c:	e54b300d 	strb	r3, [fp, #-13]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:32 (discriminator 1)
		output[i - j] = output[j];
    8920:	e51b300c 	ldr	r3, [fp, #-12]
    8924:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8928:	e0822003 	add	r2, r2, r3
    892c:	e51b1008 	ldr	r1, [fp, #-8]
    8930:	e51b300c 	ldr	r3, [fp, #-12]
    8934:	e0413003 	sub	r3, r1, r3
    8938:	e1a01003 	mov	r1, r3
    893c:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8940:	e0833001 	add	r3, r3, r1
    8944:	e5d22000 	ldrb	r2, [r2]
    8948:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:33 (discriminator 1)
		output[j] = c;
    894c:	e51b300c 	ldr	r3, [fp, #-12]
    8950:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8954:	e0823003 	add	r3, r2, r3
    8958:	e55b200d 	ldrb	r2, [fp, #-13]
    895c:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:29 (discriminator 1)
	for (j; j <= i/2; j++)
    8960:	e51b300c 	ldr	r3, [fp, #-12]
    8964:	e2833001 	add	r3, r3, #1
    8968:	e50b300c 	str	r3, [fp, #-12]
    896c:	eaffffdb 	b	88e0 <_Z4itoaiPcj+0xd8>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:36
	}

}
    8970:	e320f000 	nop	{0}
    8974:	e24bd004 	sub	sp, fp, #4
    8978:	e8bd8800 	pop	{fp, pc}
    897c:	00009bbc 			; <UNDEFINED> instruction: 0x00009bbc

00008980 <_Z4atoiPKc>:
_Z4atoiPKc():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:39

int atoi(const char* input)
{
    8980:	e92d4800 	push	{fp, lr}
    8984:	e28db004 	add	fp, sp, #4
    8988:	e24dd010 	sub	sp, sp, #16
    898c:	e50b0010 	str	r0, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:40
    if(strlen(input) == 1)
    8990:	e51b0010 	ldr	r0, [fp, #-16]
    8994:	eb00011e 	bl	8e14 <_Z6strlenPKc>
    8998:	e1a03000 	mov	r3, r0
    899c:	e3530001 	cmp	r3, #1
    89a0:	03a03001 	moveq	r3, #1
    89a4:	13a03000 	movne	r3, #0
    89a8:	e6ef3073 	uxtb	r3, r3
    89ac:	e3530000 	cmp	r3, #0
    89b0:	0a000003 	beq	89c4 <_Z4atoiPKc+0x44>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:41
        return *input - '0';
    89b4:	e51b3010 	ldr	r3, [fp, #-16]
    89b8:	e5d33000 	ldrb	r3, [r3]
    89bc:	e2433030 	sub	r3, r3, #48	; 0x30
    89c0:	ea00001e 	b	8a40 <_Z4atoiPKc+0xc0>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:42
	int output = 0;
    89c4:	e3a03000 	mov	r3, #0
    89c8:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:44

	while (*input != '\0')
    89cc:	e51b3010 	ldr	r3, [fp, #-16]
    89d0:	e5d33000 	ldrb	r3, [r3]
    89d4:	e3530000 	cmp	r3, #0
    89d8:	0a000017 	beq	8a3c <_Z4atoiPKc+0xbc>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:46
	{
		output *= 10;
    89dc:	e51b2008 	ldr	r2, [fp, #-8]
    89e0:	e1a03002 	mov	r3, r2
    89e4:	e1a03103 	lsl	r3, r3, #2
    89e8:	e0833002 	add	r3, r3, r2
    89ec:	e1a03083 	lsl	r3, r3, #1
    89f0:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:47
		if (*input > '9' || *input < '0')
    89f4:	e51b3010 	ldr	r3, [fp, #-16]
    89f8:	e5d33000 	ldrb	r3, [r3]
    89fc:	e3530039 	cmp	r3, #57	; 0x39
    8a00:	8a00000d 	bhi	8a3c <_Z4atoiPKc+0xbc>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:47 (discriminator 1)
    8a04:	e51b3010 	ldr	r3, [fp, #-16]
    8a08:	e5d33000 	ldrb	r3, [r3]
    8a0c:	e353002f 	cmp	r3, #47	; 0x2f
    8a10:	9a000009 	bls	8a3c <_Z4atoiPKc+0xbc>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:50
			break;

		output += *input - '0';
    8a14:	e51b3010 	ldr	r3, [fp, #-16]
    8a18:	e5d33000 	ldrb	r3, [r3]
    8a1c:	e2433030 	sub	r3, r3, #48	; 0x30
    8a20:	e51b2008 	ldr	r2, [fp, #-8]
    8a24:	e0823003 	add	r3, r2, r3
    8a28:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:52

		input++;
    8a2c:	e51b3010 	ldr	r3, [fp, #-16]
    8a30:	e2833001 	add	r3, r3, #1
    8a34:	e50b3010 	str	r3, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:44
	while (*input != '\0')
    8a38:	eaffffe3 	b	89cc <_Z4atoiPKc+0x4c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:55
	}

	return output;
    8a3c:	e51b3008 	ldr	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:56
}
    8a40:	e1a00003 	mov	r0, r3
    8a44:	e24bd004 	sub	sp, fp, #4
    8a48:	e8bd8800 	pop	{fp, pc}

00008a4c <_Z14get_input_typePKc>:
_Z14get_input_typePKc():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:60
//return 1 pokud int
//return 2 pokud float
//return 0 pokud neni cislo
int get_input_type(const char * input){
    8a4c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8a50:	e28db000 	add	fp, sp, #0
    8a54:	e24dd014 	sub	sp, sp, #20
    8a58:	e50b0010 	str	r0, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:62
    //existence tecky
    bool dot = false;
    8a5c:	e3a03000 	mov	r3, #0
    8a60:	e54b3005 	strb	r3, [fp, #-5]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:63
    bool trailing_dot = false;
    8a64:	e3a03000 	mov	r3, #0
    8a68:	e54b3006 	strb	r3, [fp, #-6]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:64
    while(*input != '\0'){
    8a6c:	e51b3010 	ldr	r3, [fp, #-16]
    8a70:	e5d33000 	ldrb	r3, [r3]
    8a74:	e3530000 	cmp	r3, #0
    8a78:	0a000023 	beq	8b0c <_Z14get_input_typePKc+0xc0>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:65
        char c = *input;
    8a7c:	e51b3010 	ldr	r3, [fp, #-16]
    8a80:	e5d33000 	ldrb	r3, [r3]
    8a84:	e54b3007 	strb	r3, [fp, #-7]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:66
        if(c == '.' && !dot){
    8a88:	e55b3007 	ldrb	r3, [fp, #-7]
    8a8c:	e353002e 	cmp	r3, #46	; 0x2e
    8a90:	1a00000c 	bne	8ac8 <_Z14get_input_typePKc+0x7c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:66 (discriminator 1)
    8a94:	e55b3005 	ldrb	r3, [fp, #-5]
    8a98:	e2233001 	eor	r3, r3, #1
    8a9c:	e6ef3073 	uxtb	r3, r3
    8aa0:	e3530000 	cmp	r3, #0
    8aa4:	0a000007 	beq	8ac8 <_Z14get_input_typePKc+0x7c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:67 (discriminator 2)
            dot = true;
    8aa8:	e3a03001 	mov	r3, #1
    8aac:	e54b3005 	strb	r3, [fp, #-5]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:68 (discriminator 2)
            trailing_dot = true;
    8ab0:	e3a03001 	mov	r3, #1
    8ab4:	e54b3006 	strb	r3, [fp, #-6]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:69 (discriminator 2)
            input++;
    8ab8:	e51b3010 	ldr	r3, [fp, #-16]
    8abc:	e2833001 	add	r3, r3, #1
    8ac0:	e50b3010 	str	r3, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:70 (discriminator 2)
            continue;
    8ac4:	ea00000f 	b	8b08 <_Z14get_input_typePKc+0xbc>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:73
        }
        //nenumericky znak
        if(c < '0' || c > '9')return 0;
    8ac8:	e55b3007 	ldrb	r3, [fp, #-7]
    8acc:	e353002f 	cmp	r3, #47	; 0x2f
    8ad0:	9a000002 	bls	8ae0 <_Z14get_input_typePKc+0x94>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:73 (discriminator 2)
    8ad4:	e55b3007 	ldrb	r3, [fp, #-7]
    8ad8:	e3530039 	cmp	r3, #57	; 0x39
    8adc:	9a000001 	bls	8ae8 <_Z14get_input_typePKc+0x9c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:73 (discriminator 3)
    8ae0:	e3a03000 	mov	r3, #0
    8ae4:	ea000014 	b	8b3c <_Z14get_input_typePKc+0xf0>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:75
        //retezec obsahuje tecku a numericke znaky -> tecka je "validni", tedy neni to tecka na konci intu napriklad
        if(dot)
    8ae8:	e55b3005 	ldrb	r3, [fp, #-5]
    8aec:	e3530000 	cmp	r3, #0
    8af0:	0a000001 	beq	8afc <_Z14get_input_typePKc+0xb0>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:76
            trailing_dot = false;
    8af4:	e3a03000 	mov	r3, #0
    8af8:	e54b3006 	strb	r3, [fp, #-6]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:77
    input++;
    8afc:	e51b3010 	ldr	r3, [fp, #-16]
    8b00:	e2833001 	add	r3, r3, #1
    8b04:	e50b3010 	str	r3, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:64
    while(*input != '\0'){
    8b08:	eaffffd7 	b	8a6c <_Z14get_input_typePKc+0x20>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:79
    }
    if(trailing_dot)return 0;
    8b0c:	e55b3006 	ldrb	r3, [fp, #-6]
    8b10:	e3530000 	cmp	r3, #0
    8b14:	0a000001 	beq	8b20 <_Z14get_input_typePKc+0xd4>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:79 (discriminator 1)
    8b18:	e3a03000 	mov	r3, #0
    8b1c:	ea000006 	b	8b3c <_Z14get_input_typePKc+0xf0>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:81
    //float pokud retezec obsahuje non-trailing tecku, 1 pokud je to int
    return dot? 2:1;
    8b20:	e55b3005 	ldrb	r3, [fp, #-5]
    8b24:	e3530000 	cmp	r3, #0
    8b28:	0a000001 	beq	8b34 <_Z14get_input_typePKc+0xe8>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:81 (discriminator 1)
    8b2c:	e3a03002 	mov	r3, #2
    8b30:	ea000000 	b	8b38 <_Z14get_input_typePKc+0xec>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:81 (discriminator 2)
    8b34:	e3a03001 	mov	r3, #1
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:81
    8b38:	e320f000 	nop	{0}
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:83

}
    8b3c:	e1a00003 	mov	r0, r3
    8b40:	e28bd000 	add	sp, fp, #0
    8b44:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8b48:	e12fff1e 	bx	lr

00008b4c <_Z4atofPKc>:
_Z4atofPKc():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:87


//string to float
float atof(const char* input){
    8b4c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8b50:	e28db000 	add	fp, sp, #0
    8b54:	e24dd03c 	sub	sp, sp, #60	; 0x3c
    8b58:	e50b0038 	str	r0, [fp, #-56]	; 0xffffffc8
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:88
    double output = 0.0;
    8b5c:	e3a02000 	mov	r2, #0
    8b60:	e3a03000 	mov	r3, #0
    8b64:	e14b20fc 	strd	r2, [fp, #-12]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:89
    double factor = 10;
    8b68:	e3a02000 	mov	r2, #0
    8b6c:	e59f312c 	ldr	r3, [pc, #300]	; 8ca0 <_Z4atofPKc+0x154>
    8b70:	e14b21fc 	strd	r2, [fp, #-28]	; 0xffffffe4
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:91
    //cast za desetinnou carkou
    double tmp = 0.0;
    8b74:	e3a02000 	mov	r2, #0
    8b78:	e3a03000 	mov	r3, #0
    8b7c:	e14b22f4 	strd	r2, [fp, #-36]	; 0xffffffdc
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:92
    int counter = 0;
    8b80:	e3a03000 	mov	r3, #0
    8b84:	e50b3028 	str	r3, [fp, #-40]	; 0xffffffd8
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:93
    int scale = 1;
    8b88:	e3a03001 	mov	r3, #1
    8b8c:	e50b3010 	str	r3, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:94
    bool afterDecPoint = false;
    8b90:	e3a03000 	mov	r3, #0
    8b94:	e54b3011 	strb	r3, [fp, #-17]	; 0xffffffef
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:96

    while(*input != '\0'){
    8b98:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    8b9c:	e5d33000 	ldrb	r3, [r3]
    8ba0:	e3530000 	cmp	r3, #0
    8ba4:	0a000034 	beq	8c7c <_Z4atofPKc+0x130>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:97
        if (*input == '.'){
    8ba8:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    8bac:	e5d33000 	ldrb	r3, [r3]
    8bb0:	e353002e 	cmp	r3, #46	; 0x2e
    8bb4:	1a000005 	bne	8bd0 <_Z4atofPKc+0x84>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:98 (discriminator 1)
            afterDecPoint = true;
    8bb8:	e3a03001 	mov	r3, #1
    8bbc:	e54b3011 	strb	r3, [fp, #-17]	; 0xffffffef
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:99 (discriminator 1)
            input++;
    8bc0:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    8bc4:	e2833001 	add	r3, r3, #1
    8bc8:	e50b3038 	str	r3, [fp, #-56]	; 0xffffffc8
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:100 (discriminator 1)
            continue;
    8bcc:	ea000029 	b	8c78 <_Z4atofPKc+0x12c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:102
        }
        else if (*input > '9' || *input < '0')break;
    8bd0:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    8bd4:	e5d33000 	ldrb	r3, [r3]
    8bd8:	e3530039 	cmp	r3, #57	; 0x39
    8bdc:	8a000026 	bhi	8c7c <_Z4atofPKc+0x130>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:102 (discriminator 1)
    8be0:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    8be4:	e5d33000 	ldrb	r3, [r3]
    8be8:	e353002f 	cmp	r3, #47	; 0x2f
    8bec:	9a000022 	bls	8c7c <_Z4atofPKc+0x130>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:103
        double val = *input - '0';
    8bf0:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    8bf4:	e5d33000 	ldrb	r3, [r3]
    8bf8:	e2433030 	sub	r3, r3, #48	; 0x30
    8bfc:	ee073a90 	vmov	s15, r3
    8c00:	eeb87be7 	vcvt.f64.s32	d7, s15
    8c04:	ed0b7b0d 	vstr	d7, [fp, #-52]	; 0xffffffcc
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:104
        if(afterDecPoint){
    8c08:	e55b3011 	ldrb	r3, [fp, #-17]	; 0xffffffef
    8c0c:	e3530000 	cmp	r3, #0
    8c10:	0a00000f 	beq	8c54 <_Z4atofPKc+0x108>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:105
            scale /= 10;
    8c14:	e51b3010 	ldr	r3, [fp, #-16]
    8c18:	e59f2084 	ldr	r2, [pc, #132]	; 8ca4 <_Z4atofPKc+0x158>
    8c1c:	e0c21392 	smull	r1, r2, r2, r3
    8c20:	e1a02142 	asr	r2, r2, #2
    8c24:	e1a03fc3 	asr	r3, r3, #31
    8c28:	e0423003 	sub	r3, r2, r3
    8c2c:	e50b3010 	str	r3, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:106
            output = output + val * scale;
    8c30:	e51b3010 	ldr	r3, [fp, #-16]
    8c34:	ee073a90 	vmov	s15, r3
    8c38:	eeb86be7 	vcvt.f64.s32	d6, s15
    8c3c:	ed1b7b0d 	vldr	d7, [fp, #-52]	; 0xffffffcc
    8c40:	ee267b07 	vmul.f64	d7, d6, d7
    8c44:	ed1b6b03 	vldr	d6, [fp, #-12]
    8c48:	ee367b07 	vadd.f64	d7, d6, d7
    8c4c:	ed0b7b03 	vstr	d7, [fp, #-12]
    8c50:	ea000005 	b	8c6c <_Z4atofPKc+0x120>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:109
        }
        else
            output = output * 10 + val;
    8c54:	ed1b7b03 	vldr	d7, [fp, #-12]
    8c58:	ed9f6b0e 	vldr	d6, [pc, #56]	; 8c98 <_Z4atofPKc+0x14c>
    8c5c:	ee277b06 	vmul.f64	d7, d7, d6
    8c60:	ed1b6b0d 	vldr	d6, [fp, #-52]	; 0xffffffcc
    8c64:	ee367b07 	vadd.f64	d7, d6, d7
    8c68:	ed0b7b03 	vstr	d7, [fp, #-12]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:111

        input++;
    8c6c:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    8c70:	e2833001 	add	r3, r3, #1
    8c74:	e50b3038 	str	r3, [fp, #-56]	; 0xffffffc8
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:96
    while(*input != '\0'){
    8c78:	eaffffc6 	b	8b98 <_Z4atofPKc+0x4c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:113
    }
    return output;
    8c7c:	ed1b7b03 	vldr	d7, [fp, #-12]
    8c80:	eef77bc7 	vcvt.f32.f64	s15, d7
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:114
}
    8c84:	eeb00a67 	vmov.f32	s0, s15
    8c88:	e28bd000 	add	sp, fp, #0
    8c8c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8c90:	e12fff1e 	bx	lr
    8c94:	e320f000 	nop	{0}
    8c98:	00000000 	andeq	r0, r0, r0
    8c9c:	40240000 	eormi	r0, r4, r0
    8ca0:	40240000 	eormi	r0, r4, r0
    8ca4:	66666667 	strbtvs	r6, [r6], -r7, ror #12

00008ca8 <_Z7strncpyPcPKci>:
_Z7strncpyPcPKci():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:116
char* strncpy(char* dest, const char *src, int num)
{
    8ca8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8cac:	e28db000 	add	fp, sp, #0
    8cb0:	e24dd01c 	sub	sp, sp, #28
    8cb4:	e50b0010 	str	r0, [fp, #-16]
    8cb8:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8cbc:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:119
	int i;

	for (i = 0; i < num && src[i] != '\0'; i++)
    8cc0:	e3a03000 	mov	r3, #0
    8cc4:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:119 (discriminator 4)
    8cc8:	e51b2008 	ldr	r2, [fp, #-8]
    8ccc:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8cd0:	e1520003 	cmp	r2, r3
    8cd4:	aa000011 	bge	8d20 <_Z7strncpyPcPKci+0x78>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:119 (discriminator 2)
    8cd8:	e51b3008 	ldr	r3, [fp, #-8]
    8cdc:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    8ce0:	e0823003 	add	r3, r2, r3
    8ce4:	e5d33000 	ldrb	r3, [r3]
    8ce8:	e3530000 	cmp	r3, #0
    8cec:	0a00000b 	beq	8d20 <_Z7strncpyPcPKci+0x78>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:120 (discriminator 3)
		dest[i] = src[i];
    8cf0:	e51b3008 	ldr	r3, [fp, #-8]
    8cf4:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    8cf8:	e0822003 	add	r2, r2, r3
    8cfc:	e51b3008 	ldr	r3, [fp, #-8]
    8d00:	e51b1010 	ldr	r1, [fp, #-16]
    8d04:	e0813003 	add	r3, r1, r3
    8d08:	e5d22000 	ldrb	r2, [r2]
    8d0c:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:119 (discriminator 3)
	for (i = 0; i < num && src[i] != '\0'; i++)
    8d10:	e51b3008 	ldr	r3, [fp, #-8]
    8d14:	e2833001 	add	r3, r3, #1
    8d18:	e50b3008 	str	r3, [fp, #-8]
    8d1c:	eaffffe9 	b	8cc8 <_Z7strncpyPcPKci+0x20>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:121 (discriminator 2)
	for (; i < num; i++)
    8d20:	e51b2008 	ldr	r2, [fp, #-8]
    8d24:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8d28:	e1520003 	cmp	r2, r3
    8d2c:	aa000008 	bge	8d54 <_Z7strncpyPcPKci+0xac>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:122 (discriminator 1)
		dest[i] = '\0';
    8d30:	e51b3008 	ldr	r3, [fp, #-8]
    8d34:	e51b2010 	ldr	r2, [fp, #-16]
    8d38:	e0823003 	add	r3, r2, r3
    8d3c:	e3a02000 	mov	r2, #0
    8d40:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:121 (discriminator 1)
	for (; i < num; i++)
    8d44:	e51b3008 	ldr	r3, [fp, #-8]
    8d48:	e2833001 	add	r3, r3, #1
    8d4c:	e50b3008 	str	r3, [fp, #-8]
    8d50:	eafffff2 	b	8d20 <_Z7strncpyPcPKci+0x78>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:124

   return dest;
    8d54:	e51b3010 	ldr	r3, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:125
}
    8d58:	e1a00003 	mov	r0, r3
    8d5c:	e28bd000 	add	sp, fp, #0
    8d60:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8d64:	e12fff1e 	bx	lr

00008d68 <_Z7strncmpPKcS0_i>:
_Z7strncmpPKcS0_i():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:128

int strncmp(const char *s1, const char *s2, int num)
{
    8d68:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8d6c:	e28db000 	add	fp, sp, #0
    8d70:	e24dd01c 	sub	sp, sp, #28
    8d74:	e50b0010 	str	r0, [fp, #-16]
    8d78:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8d7c:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:130
	unsigned char u1, u2;
  	while (num-- > 0)
    8d80:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8d84:	e2432001 	sub	r2, r3, #1
    8d88:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
    8d8c:	e3530000 	cmp	r3, #0
    8d90:	c3a03001 	movgt	r3, #1
    8d94:	d3a03000 	movle	r3, #0
    8d98:	e6ef3073 	uxtb	r3, r3
    8d9c:	e3530000 	cmp	r3, #0
    8da0:	0a000016 	beq	8e00 <_Z7strncmpPKcS0_i+0x98>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:132
    {
      	u1 = (unsigned char) *s1++;
    8da4:	e51b3010 	ldr	r3, [fp, #-16]
    8da8:	e2832001 	add	r2, r3, #1
    8dac:	e50b2010 	str	r2, [fp, #-16]
    8db0:	e5d33000 	ldrb	r3, [r3]
    8db4:	e54b3005 	strb	r3, [fp, #-5]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:133
     	u2 = (unsigned char) *s2++;
    8db8:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8dbc:	e2832001 	add	r2, r3, #1
    8dc0:	e50b2014 	str	r2, [fp, #-20]	; 0xffffffec
    8dc4:	e5d33000 	ldrb	r3, [r3]
    8dc8:	e54b3006 	strb	r3, [fp, #-6]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:134
      	if (u1 != u2)
    8dcc:	e55b2005 	ldrb	r2, [fp, #-5]
    8dd0:	e55b3006 	ldrb	r3, [fp, #-6]
    8dd4:	e1520003 	cmp	r2, r3
    8dd8:	0a000003 	beq	8dec <_Z7strncmpPKcS0_i+0x84>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:135
        	return u1 - u2;
    8ddc:	e55b2005 	ldrb	r2, [fp, #-5]
    8de0:	e55b3006 	ldrb	r3, [fp, #-6]
    8de4:	e0423003 	sub	r3, r2, r3
    8de8:	ea000005 	b	8e04 <_Z7strncmpPKcS0_i+0x9c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:136
      	if (u1 == '\0')
    8dec:	e55b3005 	ldrb	r3, [fp, #-5]
    8df0:	e3530000 	cmp	r3, #0
    8df4:	1affffe1 	bne	8d80 <_Z7strncmpPKcS0_i+0x18>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:137
        	return 0;
    8df8:	e3a03000 	mov	r3, #0
    8dfc:	ea000000 	b	8e04 <_Z7strncmpPKcS0_i+0x9c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:140
    }

  	return 0;
    8e00:	e3a03000 	mov	r3, #0
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:141
}
    8e04:	e1a00003 	mov	r0, r3
    8e08:	e28bd000 	add	sp, fp, #0
    8e0c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8e10:	e12fff1e 	bx	lr

00008e14 <_Z6strlenPKc>:
_Z6strlenPKc():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:144

int strlen(const char* s)
{
    8e14:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8e18:	e28db000 	add	fp, sp, #0
    8e1c:	e24dd014 	sub	sp, sp, #20
    8e20:	e50b0010 	str	r0, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:145
	int i = 0;
    8e24:	e3a03000 	mov	r3, #0
    8e28:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:147

	while (s[i] != '\0')
    8e2c:	e51b3008 	ldr	r3, [fp, #-8]
    8e30:	e51b2010 	ldr	r2, [fp, #-16]
    8e34:	e0823003 	add	r3, r2, r3
    8e38:	e5d33000 	ldrb	r3, [r3]
    8e3c:	e3530000 	cmp	r3, #0
    8e40:	0a000003 	beq	8e54 <_Z6strlenPKc+0x40>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:148
		i++;
    8e44:	e51b3008 	ldr	r3, [fp, #-8]
    8e48:	e2833001 	add	r3, r3, #1
    8e4c:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:147
	while (s[i] != '\0')
    8e50:	eafffff5 	b	8e2c <_Z6strlenPKc+0x18>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:150

	return i;
    8e54:	e51b3008 	ldr	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:151
}
    8e58:	e1a00003 	mov	r0, r3
    8e5c:	e28bd000 	add	sp, fp, #0
    8e60:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8e64:	e12fff1e 	bx	lr

00008e68 <_Z6strcatPcPKc>:
_Z6strcatPcPKc():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:154
//unsafe varianta
//muze nastat buffer overflow attack
char* strcat(char* dest, const char* src){
    8e68:	e92d4800 	push	{fp, lr}
    8e6c:	e28db004 	add	fp, sp, #4
    8e70:	e24dd018 	sub	sp, sp, #24
    8e74:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    8e78:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:155
    int n = strlen(src);
    8e7c:	e51b001c 	ldr	r0, [fp, #-28]	; 0xffffffe4
    8e80:	ebffffe3 	bl	8e14 <_Z6strlenPKc>
    8e84:	e50b0010 	str	r0, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:156
    int m = strlen(dest);
    8e88:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    8e8c:	ebffffe0 	bl	8e14 <_Z6strlenPKc>
    8e90:	e50b0008 	str	r0, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:157
    int walker = 0;
    8e94:	e3a03000 	mov	r3, #0
    8e98:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:158
    for(int i = 0;i < n; i++)
    8e9c:	e3a03000 	mov	r3, #0
    8ea0:	e50b300c 	str	r3, [fp, #-12]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:158 (discriminator 3)
    8ea4:	e51b200c 	ldr	r2, [fp, #-12]
    8ea8:	e51b3010 	ldr	r3, [fp, #-16]
    8eac:	e1520003 	cmp	r2, r3
    8eb0:	aa00000e 	bge	8ef0 <_Z6strcatPcPKc+0x88>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:159 (discriminator 2)
        dest[m++] = src[i];
    8eb4:	e51b300c 	ldr	r3, [fp, #-12]
    8eb8:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8ebc:	e0822003 	add	r2, r2, r3
    8ec0:	e51b3008 	ldr	r3, [fp, #-8]
    8ec4:	e2831001 	add	r1, r3, #1
    8ec8:	e50b1008 	str	r1, [fp, #-8]
    8ecc:	e1a01003 	mov	r1, r3
    8ed0:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8ed4:	e0833001 	add	r3, r3, r1
    8ed8:	e5d22000 	ldrb	r2, [r2]
    8edc:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:158 (discriminator 2)
    for(int i = 0;i < n; i++)
    8ee0:	e51b300c 	ldr	r3, [fp, #-12]
    8ee4:	e2833001 	add	r3, r3, #1
    8ee8:	e50b300c 	str	r3, [fp, #-12]
    8eec:	eaffffec 	b	8ea4 <_Z6strcatPcPKc+0x3c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:160
    dest[m] = '\0';
    8ef0:	e51b3008 	ldr	r3, [fp, #-8]
    8ef4:	e51b2018 	ldr	r2, [fp, #-24]	; 0xffffffe8
    8ef8:	e0823003 	add	r3, r2, r3
    8efc:	e3a02000 	mov	r2, #0
    8f00:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:161
    return dest;
    8f04:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:163

}
    8f08:	e1a00003 	mov	r0, r3
    8f0c:	e24bd004 	sub	sp, fp, #4
    8f10:	e8bd8800 	pop	{fp, pc}

00008f14 <_Z7strncatPcPKci>:
_Z7strncatPcPKci():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:164
char* strncat(char* dest, const char* src,int size){
    8f14:	e92d4800 	push	{fp, lr}
    8f18:	e28db004 	add	fp, sp, #4
    8f1c:	e24dd020 	sub	sp, sp, #32
    8f20:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    8f24:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    8f28:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:165
    int walker = 0;
    8f2c:	e3a03000 	mov	r3, #0
    8f30:	e50b3010 	str	r3, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:167
    //najdi odkud muzeme kopirovat, tedy konec retezce
    int m = strlen(dest);
    8f34:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    8f38:	ebffffb5 	bl	8e14 <_Z6strlenPKc>
    8f3c:	e50b0008 	str	r0, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:169
    //nevejdu se
    if(m >= size)return dest;
    8f40:	e51b2008 	ldr	r2, [fp, #-8]
    8f44:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8f48:	e1520003 	cmp	r2, r3
    8f4c:	ba000001 	blt	8f58 <_Z7strncatPcPKci+0x44>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:169 (discriminator 1)
    8f50:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8f54:	ea000021 	b	8fe0 <_Z7strncatPcPKci+0xcc>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:171

    for(int i = 0;i < size; i++){
    8f58:	e3a03000 	mov	r3, #0
    8f5c:	e50b300c 	str	r3, [fp, #-12]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:171 (discriminator 1)
    8f60:	e51b200c 	ldr	r2, [fp, #-12]
    8f64:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8f68:	e1520003 	cmp	r2, r3
    8f6c:	aa000015 	bge	8fc8 <_Z7strncatPcPKci+0xb4>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:172
        if(src[i] == '\0')break;
    8f70:	e51b300c 	ldr	r3, [fp, #-12]
    8f74:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8f78:	e0823003 	add	r3, r2, r3
    8f7c:	e5d33000 	ldrb	r3, [r3]
    8f80:	e3530000 	cmp	r3, #0
    8f84:	0a00000e 	beq	8fc4 <_Z7strncatPcPKci+0xb0>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:173 (discriminator 2)
        dest[m++] = src[i];
    8f88:	e51b300c 	ldr	r3, [fp, #-12]
    8f8c:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8f90:	e0822003 	add	r2, r2, r3
    8f94:	e51b3008 	ldr	r3, [fp, #-8]
    8f98:	e2831001 	add	r1, r3, #1
    8f9c:	e50b1008 	str	r1, [fp, #-8]
    8fa0:	e1a01003 	mov	r1, r3
    8fa4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8fa8:	e0833001 	add	r3, r3, r1
    8fac:	e5d22000 	ldrb	r2, [r2]
    8fb0:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:171 (discriminator 2)
    for(int i = 0;i < size; i++){
    8fb4:	e51b300c 	ldr	r3, [fp, #-12]
    8fb8:	e2833001 	add	r3, r3, #1
    8fbc:	e50b300c 	str	r3, [fp, #-12]
    8fc0:	eaffffe6 	b	8f60 <_Z7strncatPcPKci+0x4c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:172
        if(src[i] == '\0')break;
    8fc4:	e320f000 	nop	{0}
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:175
    }
    dest[m] = '\0';
    8fc8:	e51b3008 	ldr	r3, [fp, #-8]
    8fcc:	e51b2018 	ldr	r2, [fp, #-24]	; 0xffffffe8
    8fd0:	e0823003 	add	r3, r2, r3
    8fd4:	e3a02000 	mov	r2, #0
    8fd8:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:176
    return dest;
    8fdc:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:178

}
    8fe0:	e1a00003 	mov	r0, r3
    8fe4:	e24bd004 	sub	sp, fp, #4
    8fe8:	e8bd8800 	pop	{fp, pc}

00008fec <_Z5bzeroPvi>:
_Z5bzeroPvi():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:182


void bzero(void* memory, int length)
{
    8fec:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8ff0:	e28db000 	add	fp, sp, #0
    8ff4:	e24dd014 	sub	sp, sp, #20
    8ff8:	e50b0010 	str	r0, [fp, #-16]
    8ffc:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:183
	char* mem = reinterpret_cast<char*>(memory);
    9000:	e51b3010 	ldr	r3, [fp, #-16]
    9004:	e50b300c 	str	r3, [fp, #-12]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:185

	for (int i = 0; i < length; i++)
    9008:	e3a03000 	mov	r3, #0
    900c:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:185 (discriminator 3)
    9010:	e51b2008 	ldr	r2, [fp, #-8]
    9014:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9018:	e1520003 	cmp	r2, r3
    901c:	aa000008 	bge	9044 <_Z5bzeroPvi+0x58>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:186 (discriminator 2)
		mem[i] = 0;
    9020:	e51b3008 	ldr	r3, [fp, #-8]
    9024:	e51b200c 	ldr	r2, [fp, #-12]
    9028:	e0823003 	add	r3, r2, r3
    902c:	e3a02000 	mov	r2, #0
    9030:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:185 (discriminator 2)
	for (int i = 0; i < length; i++)
    9034:	e51b3008 	ldr	r3, [fp, #-8]
    9038:	e2833001 	add	r3, r3, #1
    903c:	e50b3008 	str	r3, [fp, #-8]
    9040:	eafffff2 	b	9010 <_Z5bzeroPvi+0x24>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:187
}
    9044:	e320f000 	nop	{0}
    9048:	e28bd000 	add	sp, fp, #0
    904c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9050:	e12fff1e 	bx	lr

00009054 <_Z6memcpyPKvPvi>:
_Z6memcpyPKvPvi():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:190

void memcpy(const void* src, void* dst, int num)
{
    9054:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9058:	e28db000 	add	fp, sp, #0
    905c:	e24dd024 	sub	sp, sp, #36	; 0x24
    9060:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    9064:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    9068:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:191
	const char* memsrc = reinterpret_cast<const char*>(src);
    906c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9070:	e50b300c 	str	r3, [fp, #-12]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:192
	char* memdst = reinterpret_cast<char*>(dst);
    9074:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    9078:	e50b3010 	str	r3, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:194

	for (int i = 0; i < num; i++)
    907c:	e3a03000 	mov	r3, #0
    9080:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:194 (discriminator 3)
    9084:	e51b2008 	ldr	r2, [fp, #-8]
    9088:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    908c:	e1520003 	cmp	r2, r3
    9090:	aa00000b 	bge	90c4 <_Z6memcpyPKvPvi+0x70>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:195 (discriminator 2)
		memdst[i] = memsrc[i];
    9094:	e51b3008 	ldr	r3, [fp, #-8]
    9098:	e51b200c 	ldr	r2, [fp, #-12]
    909c:	e0822003 	add	r2, r2, r3
    90a0:	e51b3008 	ldr	r3, [fp, #-8]
    90a4:	e51b1010 	ldr	r1, [fp, #-16]
    90a8:	e0813003 	add	r3, r1, r3
    90ac:	e5d22000 	ldrb	r2, [r2]
    90b0:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:194 (discriminator 2)
	for (int i = 0; i < num; i++)
    90b4:	e51b3008 	ldr	r3, [fp, #-8]
    90b8:	e2833001 	add	r3, r3, #1
    90bc:	e50b3008 	str	r3, [fp, #-8]
    90c0:	eaffffef 	b	9084 <_Z6memcpyPKvPvi+0x30>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:196
}
    90c4:	e320f000 	nop	{0}
    90c8:	e28bd000 	add	sp, fp, #0
    90cc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    90d0:	e12fff1e 	bx	lr

000090d4 <_Z4n_tuii>:
_Z4n_tuii():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:201



int n_tu(int number, int count)
{
    90d4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    90d8:	e28db000 	add	fp, sp, #0
    90dc:	e24dd014 	sub	sp, sp, #20
    90e0:	e50b0010 	str	r0, [fp, #-16]
    90e4:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:202
    int result = 1;
    90e8:	e3a03001 	mov	r3, #1
    90ec:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:203
    while(count-- > 0)
    90f0:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    90f4:	e2432001 	sub	r2, r3, #1
    90f8:	e50b2014 	str	r2, [fp, #-20]	; 0xffffffec
    90fc:	e3530000 	cmp	r3, #0
    9100:	c3a03001 	movgt	r3, #1
    9104:	d3a03000 	movle	r3, #0
    9108:	e6ef3073 	uxtb	r3, r3
    910c:	e3530000 	cmp	r3, #0
    9110:	0a000004 	beq	9128 <_Z4n_tuii+0x54>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:204
        result *= number;
    9114:	e51b3008 	ldr	r3, [fp, #-8]
    9118:	e51b2010 	ldr	r2, [fp, #-16]
    911c:	e0030392 	mul	r3, r2, r3
    9120:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:203
    while(count-- > 0)
    9124:	eafffff1 	b	90f0 <_Z4n_tuii+0x1c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:206

    return result;
    9128:	e51b3008 	ldr	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:207
}
    912c:	e1a00003 	mov	r0, r3
    9130:	e28bd000 	add	sp, fp, #0
    9134:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9138:	e12fff1e 	bx	lr

0000913c <_Z4ftoafPc>:
_Z4ftoafPc():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:211

/*** Convert float to string ***/
void ftoa(float f, char r[])
{
    913c:	e92d4bf0 	push	{r4, r5, r6, r7, r8, r9, fp, lr}
    9140:	e28db01c 	add	fp, sp, #28
    9144:	e24dd068 	sub	sp, sp, #104	; 0x68
    9148:	ed0b0a16 	vstr	s0, [fp, #-88]	; 0xffffffa8
    914c:	e50b005c 	str	r0, [fp, #-92]	; 0xffffffa4
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:215
    long long int length, length2, i, number, position, sign;
    float number2;

    sign = -1;   // -1 == positive number
    9150:	e3e02000 	mvn	r2, #0
    9154:	e3e03000 	mvn	r3, #0
    9158:	e14b24fc 	strd	r2, [fp, #-76]	; 0xffffffb4
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:216
    if (f < 0)
    915c:	ed5b7a16 	vldr	s15, [fp, #-88]	; 0xffffffa8
    9160:	eef57ac0 	vcmpe.f32	s15, #0.0
    9164:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    9168:	5a000005 	bpl	9184 <_Z4ftoafPc+0x48>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:218
    {
        sign = '-';
    916c:	e3a0202d 	mov	r2, #45	; 0x2d
    9170:	e3a03000 	mov	r3, #0
    9174:	e14b24fc 	strd	r2, [fp, #-76]	; 0xffffffb4
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:219
        f *= -1;
    9178:	ed5b7a16 	vldr	s15, [fp, #-88]	; 0xffffffa8
    917c:	eef17a67 	vneg.f32	s15, s15
    9180:	ed4b7a16 	vstr	s15, [fp, #-88]	; 0xffffffa8
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:222
    }

    number2 = f;
    9184:	e51b3058 	ldr	r3, [fp, #-88]	; 0xffffffa8
    9188:	e50b3050 	str	r3, [fp, #-80]	; 0xffffffb0
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:223
    number = f;
    918c:	e51b0058 	ldr	r0, [fp, #-88]	; 0xffffffa8
    9190:	eb000200 	bl	9998 <__aeabi_f2lz>
    9194:	e1a02000 	mov	r2, r0
    9198:	e1a03001 	mov	r3, r1
    919c:	e14b23fc 	strd	r2, [fp, #-60]	; 0xffffffc4
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:224
    length = 0;  // Size of decimal part
    91a0:	e3a02000 	mov	r2, #0
    91a4:	e3a03000 	mov	r3, #0
    91a8:	e14b22f4 	strd	r2, [fp, #-36]	; 0xffffffdc
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:225
    length2 = 0; // Size of tenth
    91ac:	e3a02000 	mov	r2, #0
    91b0:	e3a03000 	mov	r3, #0
    91b4:	e14b22fc 	strd	r2, [fp, #-44]	; 0xffffffd4
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:228

    /* Calculate length2 tenth part */
    while( (number2 - (float)number) != 0.0 && !((number2 - (float)number) < 0.0) )
    91b8:	e14b03dc 	ldrd	r0, [fp, #-60]	; 0xffffffc4
    91bc:	eb0001a1 	bl	9848 <__aeabi_l2f>
    91c0:	ee070a10 	vmov	s14, r0
    91c4:	ed5b7a14 	vldr	s15, [fp, #-80]	; 0xffffffb0
    91c8:	ee777ac7 	vsub.f32	s15, s15, s14
    91cc:	eef57a40 	vcmp.f32	s15, #0.0
    91d0:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    91d4:	0a00001b 	beq	9248 <_Z4ftoafPc+0x10c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:228 (discriminator 1)
    91d8:	e14b03dc 	ldrd	r0, [fp, #-60]	; 0xffffffc4
    91dc:	eb000199 	bl	9848 <__aeabi_l2f>
    91e0:	ee070a10 	vmov	s14, r0
    91e4:	ed5b7a14 	vldr	s15, [fp, #-80]	; 0xffffffb0
    91e8:	ee777ac7 	vsub.f32	s15, s15, s14
    91ec:	eef57ac0 	vcmpe.f32	s15, #0.0
    91f0:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    91f4:	4a000013 	bmi	9248 <_Z4ftoafPc+0x10c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:230
    {
        number2 = f * (n_tu(10.0, length2 + 1));
    91f8:	e51b302c 	ldr	r3, [fp, #-44]	; 0xffffffd4
    91fc:	e2833001 	add	r3, r3, #1
    9200:	e1a01003 	mov	r1, r3
    9204:	e3a0000a 	mov	r0, #10
    9208:	ebffffb1 	bl	90d4 <_Z4n_tuii>
    920c:	ee070a90 	vmov	s15, r0
    9210:	eef87ae7 	vcvt.f32.s32	s15, s15
    9214:	ed1b7a16 	vldr	s14, [fp, #-88]	; 0xffffffa8
    9218:	ee677a27 	vmul.f32	s15, s14, s15
    921c:	ed4b7a14 	vstr	s15, [fp, #-80]	; 0xffffffb0
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:231
        number = number2;
    9220:	e51b0050 	ldr	r0, [fp, #-80]	; 0xffffffb0
    9224:	eb0001db 	bl	9998 <__aeabi_f2lz>
    9228:	e1a02000 	mov	r2, r0
    922c:	e1a03001 	mov	r3, r1
    9230:	e14b23fc 	strd	r2, [fp, #-60]	; 0xffffffc4
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:233

        length2++;
    9234:	e14b22dc 	ldrd	r2, [fp, #-44]	; 0xffffffd4
    9238:	e2926001 	adds	r6, r2, #1
    923c:	e2a37000 	adc	r7, r3, #0
    9240:	e14b62fc 	strd	r6, [fp, #-44]	; 0xffffffd4
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:228
    while( (number2 - (float)number) != 0.0 && !((number2 - (float)number) < 0.0) )
    9244:	eaffffdb 	b	91b8 <_Z4ftoafPc+0x7c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:237
    }

    /* Calculate length decimal part */
    for (length = (f > 1) ? 0 : 1; f > 1; length++)
    9248:	ed5b7a16 	vldr	s15, [fp, #-88]	; 0xffffffa8
    924c:	ed9f7a82 	vldr	s14, [pc, #520]	; 945c <_Z4ftoafPc+0x320>
    9250:	eef47ac7 	vcmpe.f32	s15, s14
    9254:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    9258:	c3a03001 	movgt	r3, #1
    925c:	d3a03000 	movle	r3, #0
    9260:	e6ef3073 	uxtb	r3, r3
    9264:	e2233001 	eor	r3, r3, #1
    9268:	e6ef3073 	uxtb	r3, r3
    926c:	e6ef3073 	uxtb	r3, r3
    9270:	e3a02000 	mov	r2, #0
    9274:	e50b3064 	str	r3, [fp, #-100]	; 0xffffff9c
    9278:	e50b2060 	str	r2, [fp, #-96]	; 0xffffffa0
    927c:	e14b26d4 	ldrd	r2, [fp, #-100]	; 0xffffff9c
    9280:	e14b22f4 	strd	r2, [fp, #-36]	; 0xffffffdc
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:237 (discriminator 3)
    9284:	ed5b7a16 	vldr	s15, [fp, #-88]	; 0xffffffa8
    9288:	ed9f7a73 	vldr	s14, [pc, #460]	; 945c <_Z4ftoafPc+0x320>
    928c:	eef47ac7 	vcmpe.f32	s15, s14
    9290:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    9294:	da00000b 	ble	92c8 <_Z4ftoafPc+0x18c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:238 (discriminator 2)
        f /= 10;
    9298:	ed1b7a16 	vldr	s14, [fp, #-88]	; 0xffffffa8
    929c:	eddf6a6f 	vldr	s13, [pc, #444]	; 9460 <_Z4ftoafPc+0x324>
    92a0:	eec77a26 	vdiv.f32	s15, s14, s13
    92a4:	ed4b7a16 	vstr	s15, [fp, #-88]	; 0xffffffa8
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:237 (discriminator 2)
    for (length = (f > 1) ? 0 : 1; f > 1; length++)
    92a8:	e14b22d4 	ldrd	r2, [fp, #-36]	; 0xffffffdc
    92ac:	e2921001 	adds	r1, r2, #1
    92b0:	e50b106c 	str	r1, [fp, #-108]	; 0xffffff94
    92b4:	e2a33000 	adc	r3, r3, #0
    92b8:	e50b3068 	str	r3, [fp, #-104]	; 0xffffff98
    92bc:	e14b26dc 	ldrd	r2, [fp, #-108]	; 0xffffff94
    92c0:	e14b22f4 	strd	r2, [fp, #-36]	; 0xffffffdc
    92c4:	eaffffee 	b	9284 <_Z4ftoafPc+0x148>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:240

    position = length;
    92c8:	e14b22d4 	ldrd	r2, [fp, #-36]	; 0xffffffdc
    92cc:	e14b24f4 	strd	r2, [fp, #-68]	; 0xffffffbc
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:241
    length = length + 1 + length2;
    92d0:	e14b22d4 	ldrd	r2, [fp, #-36]	; 0xffffffdc
    92d4:	e2924001 	adds	r4, r2, #1
    92d8:	e2a35000 	adc	r5, r3, #0
    92dc:	e14b22dc 	ldrd	r2, [fp, #-44]	; 0xffffffd4
    92e0:	e0921004 	adds	r1, r2, r4
    92e4:	e50b1074 	str	r1, [fp, #-116]	; 0xffffff8c
    92e8:	e0a33005 	adc	r3, r3, r5
    92ec:	e50b3070 	str	r3, [fp, #-112]	; 0xffffff90
    92f0:	e14b27d4 	ldrd	r2, [fp, #-116]	; 0xffffff8c
    92f4:	e14b22f4 	strd	r2, [fp, #-36]	; 0xffffffdc
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:242
    number = number2;
    92f8:	e51b0050 	ldr	r0, [fp, #-80]	; 0xffffffb0
    92fc:	eb0001a5 	bl	9998 <__aeabi_f2lz>
    9300:	e1a02000 	mov	r2, r0
    9304:	e1a03001 	mov	r3, r1
    9308:	e14b23fc 	strd	r2, [fp, #-60]	; 0xffffffc4
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:243
    if (sign == '-')
    930c:	e14b24dc 	ldrd	r2, [fp, #-76]	; 0xffffffb4
    9310:	e242102d 	sub	r1, r2, #45	; 0x2d
    9314:	e1913003 	orrs	r3, r1, r3
    9318:	1a00000d 	bne	9354 <_Z4ftoafPc+0x218>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:245
    {
        length++;
    931c:	e14b22d4 	ldrd	r2, [fp, #-36]	; 0xffffffdc
    9320:	e2921001 	adds	r1, r2, #1
    9324:	e50b107c 	str	r1, [fp, #-124]	; 0xffffff84
    9328:	e2a33000 	adc	r3, r3, #0
    932c:	e50b3078 	str	r3, [fp, #-120]	; 0xffffff88
    9330:	e14b27dc 	ldrd	r2, [fp, #-124]	; 0xffffff84
    9334:	e14b22f4 	strd	r2, [fp, #-36]	; 0xffffffdc
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:246
        position++;
    9338:	e14b24d4 	ldrd	r2, [fp, #-68]	; 0xffffffbc
    933c:	e2921001 	adds	r1, r2, #1
    9340:	e50b1084 	str	r1, [fp, #-132]	; 0xffffff7c
    9344:	e2a33000 	adc	r3, r3, #0
    9348:	e50b3080 	str	r3, [fp, #-128]	; 0xffffff80
    934c:	e14b28d4 	ldrd	r2, [fp, #-132]	; 0xffffff7c
    9350:	e14b24f4 	strd	r2, [fp, #-68]	; 0xffffffbc
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:249
    }

    for (i = length; i >= 0 ; i--)
    9354:	e14b22d4 	ldrd	r2, [fp, #-36]	; 0xffffffdc
    9358:	e14b23f4 	strd	r2, [fp, #-52]	; 0xffffffcc
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:249 (discriminator 1)
    935c:	e14b23d4 	ldrd	r2, [fp, #-52]	; 0xffffffcc
    9360:	e3530000 	cmp	r3, #0
    9364:	ba000039 	blt	9450 <_Z4ftoafPc+0x314>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:251
    {
        if (i == (length))
    9368:	e14b03d4 	ldrd	r0, [fp, #-52]	; 0xffffffcc
    936c:	e14b22d4 	ldrd	r2, [fp, #-36]	; 0xffffffdc
    9370:	e1510003 	cmp	r1, r3
    9374:	01500002 	cmpeq	r0, r2
    9378:	1a000005 	bne	9394 <_Z4ftoafPc+0x258>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:252
            r[i] = '\0';
    937c:	e51b3034 	ldr	r3, [fp, #-52]	; 0xffffffcc
    9380:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    9384:	e0823003 	add	r3, r2, r3
    9388:	e3a02000 	mov	r2, #0
    938c:	e5c32000 	strb	r2, [r3]
    9390:	ea000029 	b	943c <_Z4ftoafPc+0x300>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:253
        else if(i == (position))
    9394:	e14b03d4 	ldrd	r0, [fp, #-52]	; 0xffffffcc
    9398:	e14b24d4 	ldrd	r2, [fp, #-68]	; 0xffffffbc
    939c:	e1510003 	cmp	r1, r3
    93a0:	01500002 	cmpeq	r0, r2
    93a4:	1a000005 	bne	93c0 <_Z4ftoafPc+0x284>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:254
            r[i] = '.';
    93a8:	e51b3034 	ldr	r3, [fp, #-52]	; 0xffffffcc
    93ac:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    93b0:	e0823003 	add	r3, r2, r3
    93b4:	e3a0202e 	mov	r2, #46	; 0x2e
    93b8:	e5c32000 	strb	r2, [r3]
    93bc:	ea00001e 	b	943c <_Z4ftoafPc+0x300>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:255
        else if(sign == '-' && i == 0)
    93c0:	e14b24dc 	ldrd	r2, [fp, #-76]	; 0xffffffb4
    93c4:	e242102d 	sub	r1, r2, #45	; 0x2d
    93c8:	e1913003 	orrs	r3, r1, r3
    93cc:	1a000008 	bne	93f4 <_Z4ftoafPc+0x2b8>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:255 (discriminator 1)
    93d0:	e14b23d4 	ldrd	r2, [fp, #-52]	; 0xffffffcc
    93d4:	e1923003 	orrs	r3, r2, r3
    93d8:	1a000005 	bne	93f4 <_Z4ftoafPc+0x2b8>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:256
            r[i] = '-';
    93dc:	e51b3034 	ldr	r3, [fp, #-52]	; 0xffffffcc
    93e0:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    93e4:	e0823003 	add	r3, r2, r3
    93e8:	e3a0202d 	mov	r2, #45	; 0x2d
    93ec:	e5c32000 	strb	r2, [r3]
    93f0:	ea000011 	b	943c <_Z4ftoafPc+0x300>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:259
        else
        {
            r[i] = (number % 10) + '0';
    93f4:	e14b03dc 	ldrd	r0, [fp, #-60]	; 0xffffffc4
    93f8:	e3a0200a 	mov	r2, #10
    93fc:	e3a03000 	mov	r3, #0
    9400:	eb00012f 	bl	98c4 <__aeabi_ldivmod>
    9404:	e6ef2072 	uxtb	r2, r2
    9408:	e51b3034 	ldr	r3, [fp, #-52]	; 0xffffffcc
    940c:	e51b105c 	ldr	r1, [fp, #-92]	; 0xffffffa4
    9410:	e0813003 	add	r3, r1, r3
    9414:	e2822030 	add	r2, r2, #48	; 0x30
    9418:	e6ef2072 	uxtb	r2, r2
    941c:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:260
            number /=10;
    9420:	e14b03dc 	ldrd	r0, [fp, #-60]	; 0xffffffc4
    9424:	e3a0200a 	mov	r2, #10
    9428:	e3a03000 	mov	r3, #0
    942c:	eb000124 	bl	98c4 <__aeabi_ldivmod>
    9430:	e1a02000 	mov	r2, r0
    9434:	e1a03001 	mov	r3, r1
    9438:	e14b23fc 	strd	r2, [fp, #-60]	; 0xffffffc4
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:249 (discriminator 2)
    for (i = length; i >= 0 ; i--)
    943c:	e14b23d4 	ldrd	r2, [fp, #-52]	; 0xffffffcc
    9440:	e2528001 	subs	r8, r2, #1
    9444:	e2c39000 	sbc	r9, r3, #0
    9448:	e14b83f4 	strd	r8, [fp, #-52]	; 0xffffffcc
    944c:	eaffffc2 	b	935c <_Z4ftoafPc+0x220>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:263
        }
    }
}
    9450:	e320f000 	nop	{0}
    9454:	e24bd01c 	sub	sp, fp, #28
    9458:	e8bd8bf0 	pop	{r4, r5, r6, r7, r8, r9, fp, pc}
    945c:	3f800000 	svccc	0x00800000
    9460:	41200000 			; <UNDEFINED> instruction: 0x41200000

00009464 <__udivsi3>:
__udivsi3():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1104
    9464:	e2512001 	subs	r2, r1, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1106
    9468:	012fff1e 	bxeq	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1107
    946c:	3a000074 	bcc	9644 <__udivsi3+0x1e0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1108
    9470:	e1500001 	cmp	r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1109
    9474:	9a00006b 	bls	9628 <__udivsi3+0x1c4>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1110
    9478:	e1110002 	tst	r1, r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1111
    947c:	0a00006c 	beq	9634 <__udivsi3+0x1d0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1113
    9480:	e16f3f10 	clz	r3, r0
    9484:	e16f2f11 	clz	r2, r1
    9488:	e0423003 	sub	r3, r2, r3
    948c:	e273301f 	rsbs	r3, r3, #31
    9490:	10833083 	addne	r3, r3, r3, lsl #1
    9494:	e3a02000 	mov	r2, #0
    9498:	108ff103 	addne	pc, pc, r3, lsl #2
    949c:	e1a00000 	nop			; (mov r0, r0)
    94a0:	e1500f81 	cmp	r0, r1, lsl #31
    94a4:	e0a22002 	adc	r2, r2, r2
    94a8:	20400f81 	subcs	r0, r0, r1, lsl #31
    94ac:	e1500f01 	cmp	r0, r1, lsl #30
    94b0:	e0a22002 	adc	r2, r2, r2
    94b4:	20400f01 	subcs	r0, r0, r1, lsl #30
    94b8:	e1500e81 	cmp	r0, r1, lsl #29
    94bc:	e0a22002 	adc	r2, r2, r2
    94c0:	20400e81 	subcs	r0, r0, r1, lsl #29
    94c4:	e1500e01 	cmp	r0, r1, lsl #28
    94c8:	e0a22002 	adc	r2, r2, r2
    94cc:	20400e01 	subcs	r0, r0, r1, lsl #28
    94d0:	e1500d81 	cmp	r0, r1, lsl #27
    94d4:	e0a22002 	adc	r2, r2, r2
    94d8:	20400d81 	subcs	r0, r0, r1, lsl #27
    94dc:	e1500d01 	cmp	r0, r1, lsl #26
    94e0:	e0a22002 	adc	r2, r2, r2
    94e4:	20400d01 	subcs	r0, r0, r1, lsl #26
    94e8:	e1500c81 	cmp	r0, r1, lsl #25
    94ec:	e0a22002 	adc	r2, r2, r2
    94f0:	20400c81 	subcs	r0, r0, r1, lsl #25
    94f4:	e1500c01 	cmp	r0, r1, lsl #24
    94f8:	e0a22002 	adc	r2, r2, r2
    94fc:	20400c01 	subcs	r0, r0, r1, lsl #24
    9500:	e1500b81 	cmp	r0, r1, lsl #23
    9504:	e0a22002 	adc	r2, r2, r2
    9508:	20400b81 	subcs	r0, r0, r1, lsl #23
    950c:	e1500b01 	cmp	r0, r1, lsl #22
    9510:	e0a22002 	adc	r2, r2, r2
    9514:	20400b01 	subcs	r0, r0, r1, lsl #22
    9518:	e1500a81 	cmp	r0, r1, lsl #21
    951c:	e0a22002 	adc	r2, r2, r2
    9520:	20400a81 	subcs	r0, r0, r1, lsl #21
    9524:	e1500a01 	cmp	r0, r1, lsl #20
    9528:	e0a22002 	adc	r2, r2, r2
    952c:	20400a01 	subcs	r0, r0, r1, lsl #20
    9530:	e1500981 	cmp	r0, r1, lsl #19
    9534:	e0a22002 	adc	r2, r2, r2
    9538:	20400981 	subcs	r0, r0, r1, lsl #19
    953c:	e1500901 	cmp	r0, r1, lsl #18
    9540:	e0a22002 	adc	r2, r2, r2
    9544:	20400901 	subcs	r0, r0, r1, lsl #18
    9548:	e1500881 	cmp	r0, r1, lsl #17
    954c:	e0a22002 	adc	r2, r2, r2
    9550:	20400881 	subcs	r0, r0, r1, lsl #17
    9554:	e1500801 	cmp	r0, r1, lsl #16
    9558:	e0a22002 	adc	r2, r2, r2
    955c:	20400801 	subcs	r0, r0, r1, lsl #16
    9560:	e1500781 	cmp	r0, r1, lsl #15
    9564:	e0a22002 	adc	r2, r2, r2
    9568:	20400781 	subcs	r0, r0, r1, lsl #15
    956c:	e1500701 	cmp	r0, r1, lsl #14
    9570:	e0a22002 	adc	r2, r2, r2
    9574:	20400701 	subcs	r0, r0, r1, lsl #14
    9578:	e1500681 	cmp	r0, r1, lsl #13
    957c:	e0a22002 	adc	r2, r2, r2
    9580:	20400681 	subcs	r0, r0, r1, lsl #13
    9584:	e1500601 	cmp	r0, r1, lsl #12
    9588:	e0a22002 	adc	r2, r2, r2
    958c:	20400601 	subcs	r0, r0, r1, lsl #12
    9590:	e1500581 	cmp	r0, r1, lsl #11
    9594:	e0a22002 	adc	r2, r2, r2
    9598:	20400581 	subcs	r0, r0, r1, lsl #11
    959c:	e1500501 	cmp	r0, r1, lsl #10
    95a0:	e0a22002 	adc	r2, r2, r2
    95a4:	20400501 	subcs	r0, r0, r1, lsl #10
    95a8:	e1500481 	cmp	r0, r1, lsl #9
    95ac:	e0a22002 	adc	r2, r2, r2
    95b0:	20400481 	subcs	r0, r0, r1, lsl #9
    95b4:	e1500401 	cmp	r0, r1, lsl #8
    95b8:	e0a22002 	adc	r2, r2, r2
    95bc:	20400401 	subcs	r0, r0, r1, lsl #8
    95c0:	e1500381 	cmp	r0, r1, lsl #7
    95c4:	e0a22002 	adc	r2, r2, r2
    95c8:	20400381 	subcs	r0, r0, r1, lsl #7
    95cc:	e1500301 	cmp	r0, r1, lsl #6
    95d0:	e0a22002 	adc	r2, r2, r2
    95d4:	20400301 	subcs	r0, r0, r1, lsl #6
    95d8:	e1500281 	cmp	r0, r1, lsl #5
    95dc:	e0a22002 	adc	r2, r2, r2
    95e0:	20400281 	subcs	r0, r0, r1, lsl #5
    95e4:	e1500201 	cmp	r0, r1, lsl #4
    95e8:	e0a22002 	adc	r2, r2, r2
    95ec:	20400201 	subcs	r0, r0, r1, lsl #4
    95f0:	e1500181 	cmp	r0, r1, lsl #3
    95f4:	e0a22002 	adc	r2, r2, r2
    95f8:	20400181 	subcs	r0, r0, r1, lsl #3
    95fc:	e1500101 	cmp	r0, r1, lsl #2
    9600:	e0a22002 	adc	r2, r2, r2
    9604:	20400101 	subcs	r0, r0, r1, lsl #2
    9608:	e1500081 	cmp	r0, r1, lsl #1
    960c:	e0a22002 	adc	r2, r2, r2
    9610:	20400081 	subcs	r0, r0, r1, lsl #1
    9614:	e1500001 	cmp	r0, r1
    9618:	e0a22002 	adc	r2, r2, r2
    961c:	20400001 	subcs	r0, r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1115
    9620:	e1a00002 	mov	r0, r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1116
    9624:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1119
    9628:	03a00001 	moveq	r0, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1120
    962c:	13a00000 	movne	r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1121
    9630:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1123
    9634:	e16f2f11 	clz	r2, r1
    9638:	e262201f 	rsb	r2, r2, #31
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1125
    963c:	e1a00230 	lsr	r0, r0, r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1126
    9640:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1130
    9644:	e3500000 	cmp	r0, #0
    9648:	13e00000 	mvnne	r0, #0
    964c:	ea000007 	b	9670 <__aeabi_idiv0>

00009650 <__aeabi_uidivmod>:
__aeabi_uidivmod():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1161
    9650:	e3510000 	cmp	r1, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1162
    9654:	0afffffa 	beq	9644 <__udivsi3+0x1e0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1163
    9658:	e92d4003 	push	{r0, r1, lr}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1164
    965c:	ebffff80 	bl	9464 <__udivsi3>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1165
    9660:	e8bd4006 	pop	{r1, r2, lr}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1166
    9664:	e0030092 	mul	r3, r2, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1167
    9668:	e0411003 	sub	r1, r1, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1168
    966c:	e12fff1e 	bx	lr

00009670 <__aeabi_idiv0>:
__aeabi_ldiv0():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1466
    9670:	e12fff1e 	bx	lr

00009674 <__aeabi_frsub>:
__aeabi_frsub():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:59
    9674:	e2200102 	eor	r0, r0, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:60
    9678:	ea000000 	b	9680 <__addsf3>

0000967c <__aeabi_fsub>:
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:65
    967c:	e2211102 	eor	r1, r1, #-2147483648	; 0x80000000

00009680 <__addsf3>:
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:74
    9680:	e1b02080 	lsls	r2, r0, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:76
    9684:	11b03081 	lslsne	r3, r1, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:77
    9688:	11320003 	teqne	r2, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:78
    968c:	11f0cc42 	mvnsne	ip, r2, asr #24
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:79
    9690:	11f0cc43 	mvnsne	ip, r3, asr #24
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:80
    9694:	0a00003c 	beq	978c <__addsf3+0x10c>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:84
    9698:	e1a02c22 	lsr	r2, r2, #24
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:85
    969c:	e0723c23 	rsbs	r3, r2, r3, lsr #24
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:87
    96a0:	c0822003 	addgt	r2, r2, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:88
    96a4:	c0201001 	eorgt	r1, r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:89
    96a8:	c0210000 	eorgt	r0, r1, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:90
    96ac:	c0201001 	eorgt	r1, r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:92
    96b0:	b2633000 	rsblt	r3, r3, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:97
    96b4:	e3530019 	cmp	r3, #25
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:99
    96b8:	812fff1e 	bxhi	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:102
    96bc:	e3100102 	tst	r0, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:103
    96c0:	e3800502 	orr	r0, r0, #8388608	; 0x800000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:104
    96c4:	e3c004ff 	bic	r0, r0, #-16777216	; 0xff000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:106
    96c8:	12600000 	rsbne	r0, r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:107
    96cc:	e3110102 	tst	r1, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:108
    96d0:	e3811502 	orr	r1, r1, #8388608	; 0x800000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:109
    96d4:	e3c114ff 	bic	r1, r1, #-16777216	; 0xff000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:111
    96d8:	12611000 	rsbne	r1, r1, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:115
    96dc:	e1320003 	teq	r2, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:116
    96e0:	0a000023 	beq	9774 <__addsf3+0xf4>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:120
    96e4:	e2422001 	sub	r2, r2, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:124
    96e8:	e0900351 	adds	r0, r0, r1, asr r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:125
    96ec:	e2633020 	rsb	r3, r3, #32
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:126
    96f0:	e1a01311 	lsl	r1, r1, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:129
    96f4:	e2003102 	and	r3, r0, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:130
    96f8:	5a000001 	bpl	9704 <__addsf3+0x84>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:135
    96fc:	e2711000 	rsbs	r1, r1, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:136
    9700:	e2e00000 	rsc	r0, r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:141
    9704:	e3500502 	cmp	r0, #8388608	; 0x800000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:142
    9708:	3a00000b 	bcc	973c <__addsf3+0xbc>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:143
    970c:	e3500401 	cmp	r0, #16777216	; 0x1000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:144
    9710:	3a000004 	bcc	9728 <__addsf3+0xa8>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:147
    9714:	e1b000a0 	lsrs	r0, r0, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:148
    9718:	e1a01061 	rrx	r1, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:149
    971c:	e2822001 	add	r2, r2, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:152
    9720:	e35200fe 	cmp	r2, #254	; 0xfe
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:153
    9724:	2a00002d 	bcs	97e0 <__addsf3+0x160>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:160
    9728:	e3510102 	cmp	r1, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:161
    972c:	e0a00b82 	adc	r0, r0, r2, lsl #23
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:163
    9730:	03c00001 	biceq	r0, r0, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:164
    9734:	e1800003 	orr	r0, r0, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:165
    9738:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:169
    973c:	e1b01081 	lsls	r1, r1, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:170
    9740:	e0a00000 	adc	r0, r0, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:171
    9744:	e2522001 	subs	r2, r2, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:173
    9748:	23500502 	cmpcs	r0, #8388608	; 0x800000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:174
    974c:	2afffff5 	bcs	9728 <__addsf3+0xa8>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:199
    9750:	e16fcf10 	clz	ip, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:200
    9754:	e24cc008 	sub	ip, ip, #8
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:201
    9758:	e052200c 	subs	r2, r2, ip
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:202
    975c:	e1a00c10 	lsl	r0, r0, ip
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:209
    9760:	a0800b82 	addge	r0, r0, r2, lsl #23
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:210
    9764:	b2622000 	rsblt	r2, r2, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:211
    9768:	a1800003 	orrge	r0, r0, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:217
    976c:	b1830230 	orrlt	r0, r3, r0, lsr r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:219
    9770:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:224
    9774:	e3320000 	teq	r2, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:225
    9778:	e2211502 	eor	r1, r1, #8388608	; 0x800000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:227
    977c:	02200502 	eoreq	r0, r0, #8388608	; 0x800000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:228
    9780:	02822001 	addeq	r2, r2, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:229
    9784:	12433001 	subne	r3, r3, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:230
    9788:	eaffffd5 	b	96e4 <__addsf3+0x64>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:233
    978c:	e1a03081 	lsl	r3, r1, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:235
    9790:	e1f0cc42 	mvns	ip, r2, asr #24
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:237
    9794:	11f0cc43 	mvnsne	ip, r3, asr #24
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:238
    9798:	0a000013 	beq	97ec <__addsf3+0x16c>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:240
    979c:	e1320003 	teq	r2, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:241
    97a0:	0a000002 	beq	97b0 <__addsf3+0x130>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:244
    97a4:	e3320000 	teq	r2, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:246
    97a8:	01a00001 	moveq	r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:247
    97ac:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:249
    97b0:	e1300001 	teq	r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:253
    97b4:	13a00000 	movne	r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:254
    97b8:	112fff1e 	bxne	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:257
    97bc:	e31204ff 	tst	r2, #-16777216	; 0xff000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:258
    97c0:	1a000002 	bne	97d0 <__addsf3+0x150>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:259
    97c4:	e1b00080 	lsls	r0, r0, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:261
    97c8:	23800102 	orrcs	r0, r0, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:262
    97cc:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:263
    97d0:	e2922402 	adds	r2, r2, #33554432	; 0x2000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:265
    97d4:	32800502 	addcc	r0, r0, #8388608	; 0x800000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:266
    97d8:	312fff1e 	bxcc	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:267
    97dc:	e2003102 	and	r3, r0, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:271
    97e0:	e383047f 	orr	r0, r3, #2130706432	; 0x7f000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:272
    97e4:	e3800502 	orr	r0, r0, #8388608	; 0x800000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:273
    97e8:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:282
    97ec:	e1f02c42 	mvns	r2, r2, asr #24
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:284
    97f0:	11a00001 	movne	r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:285
    97f4:	01f03c43 	mvnseq	r3, r3, asr #24
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:286
    97f8:	11a01000 	movne	r1, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:287
    97fc:	e1b02480 	lsls	r2, r0, #9
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:289
    9800:	01b03481 	lslseq	r3, r1, #9
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:290
    9804:	01300001 	teqeq	r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:291
    9808:	13800501 	orrne	r0, r0, #4194304	; 0x400000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:292
    980c:	e12fff1e 	bx	lr

00009810 <__aeabi_ui2f>:
__aeabi_ui2f():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:305
    9810:	e3a03000 	mov	r3, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:306
    9814:	ea000001 	b	9820 <__aeabi_i2f+0x8>

00009818 <__aeabi_i2f>:
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:311
    9818:	e2103102 	ands	r3, r0, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:313
    981c:	42600000 	rsbmi	r0, r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:315
    9820:	e1b0c000 	movs	ip, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:317
    9824:	012fff1e 	bxeq	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:320
    9828:	e383344b 	orr	r3, r3, #1258291200	; 0x4b000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:323
    982c:	e1a01000 	mov	r1, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:325
    9830:	e3a00000 	mov	r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:326
    9834:	ea00000f 	b	9878 <__aeabi_l2f+0x30>

00009838 <__aeabi_ul2f>:
__floatundisf():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:338
    9838:	e1902001 	orrs	r2, r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:340
    983c:	012fff1e 	bxeq	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:342
    9840:	e3a03000 	mov	r3, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:343
    9844:	ea000005 	b	9860 <__aeabi_l2f+0x18>

00009848 <__aeabi_l2f>:
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:348
    9848:	e1902001 	orrs	r2, r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:350
    984c:	012fff1e 	bxeq	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:352
    9850:	e2113102 	ands	r3, r1, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:353
    9854:	5a000001 	bpl	9860 <__aeabi_l2f+0x18>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:358
    9858:	e2700000 	rsbs	r0, r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:359
    985c:	e2e11000 	rsc	r1, r1, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:362
    9860:	e1b0c001 	movs	ip, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:364
    9864:	01a0c000 	moveq	ip, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:365
    9868:	01a01000 	moveq	r1, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:366
    986c:	03a00000 	moveq	r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:369
    9870:	e383345b 	orr	r3, r3, #1526726656	; 0x5b000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:371
    9874:	02433201 	subeq	r3, r3, #268435456	; 0x10000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:372
    9878:	e2433502 	sub	r3, r3, #8388608	; 0x800000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:397
    987c:	e16f2f1c 	clz	r2, ip
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:398
    9880:	e2522008 	subs	r2, r2, #8
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:402
    9884:	e0433b82 	sub	r3, r3, r2, lsl #23
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:403
    9888:	ba000006 	blt	98a8 <__aeabi_l2f+0x60>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:405
    988c:	e0833211 	add	r3, r3, r1, lsl r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:406
    9890:	e1a0c210 	lsl	ip, r0, r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:407
    9894:	e2622020 	rsb	r2, r2, #32
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:408
    9898:	e35c0102 	cmp	ip, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:409
    989c:	e0a30230 	adc	r0, r3, r0, lsr r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:411
    98a0:	03c00001 	biceq	r0, r0, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:412
    98a4:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:414
    98a8:	e2822020 	add	r2, r2, #32
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:415
    98ac:	e1a0c211 	lsl	ip, r1, r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:416
    98b0:	e2622020 	rsb	r2, r2, #32
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:417
    98b4:	e190008c 	orrs	r0, r0, ip, lsl #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:418
    98b8:	e0a30231 	adc	r0, r3, r1, lsr r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:420
    98bc:	01c00fac 	biceq	r0, r0, ip, lsr #31
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:421
    98c0:	e12fff1e 	bx	lr

000098c4 <__aeabi_ldivmod>:
__aeabi_ldivmod():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:186
    98c4:	e3530000 	cmp	r3, #0
    98c8:	03520000 	cmpeq	r2, #0
    98cc:	1a000007 	bne	98f0 <__aeabi_ldivmod+0x2c>
    98d0:	e3510000 	cmp	r1, #0
    98d4:	b3a01102 	movlt	r1, #-2147483648	; 0x80000000
    98d8:	b3a00000 	movlt	r0, #0
    98dc:	ba000002 	blt	98ec <__aeabi_ldivmod+0x28>
    98e0:	03500000 	cmpeq	r0, #0
    98e4:	13e01102 	mvnne	r1, #-2147483648	; 0x80000000
    98e8:	13e00000 	mvnne	r0, #0
    98ec:	eaffff5f 	b	9670 <__aeabi_idiv0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:188
    98f0:	e24dd008 	sub	sp, sp, #8
    98f4:	e92d6000 	push	{sp, lr}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:189
    98f8:	e3510000 	cmp	r1, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:190
    98fc:	ba000006 	blt	991c <__aeabi_ldivmod+0x58>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:191
    9900:	e3530000 	cmp	r3, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:192
    9904:	ba000011 	blt	9950 <__aeabi_ldivmod+0x8c>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:194
    9908:	eb00003e 	bl	9a08 <__udivmoddi4>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:196
    990c:	e59de004 	ldr	lr, [sp, #4]
    9910:	e28dd008 	add	sp, sp, #8
    9914:	e8bd000c 	pop	{r2, r3}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:197
    9918:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:201
    991c:	e2700000 	rsbs	r0, r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:202
    9920:	e0c11081 	sbc	r1, r1, r1, lsl #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:203
    9924:	e3530000 	cmp	r3, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:204
    9928:	ba000011 	blt	9974 <__aeabi_ldivmod+0xb0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:206
    992c:	eb000035 	bl	9a08 <__udivmoddi4>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:208
    9930:	e59de004 	ldr	lr, [sp, #4]
    9934:	e28dd008 	add	sp, sp, #8
    9938:	e8bd000c 	pop	{r2, r3}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:209
    993c:	e2700000 	rsbs	r0, r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:210
    9940:	e0c11081 	sbc	r1, r1, r1, lsl #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:211
    9944:	e2722000 	rsbs	r2, r2, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:212
    9948:	e0c33083 	sbc	r3, r3, r3, lsl #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:213
    994c:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:217
    9950:	e2722000 	rsbs	r2, r2, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:218
    9954:	e0c33083 	sbc	r3, r3, r3, lsl #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:220
    9958:	eb00002a 	bl	9a08 <__udivmoddi4>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:222
    995c:	e59de004 	ldr	lr, [sp, #4]
    9960:	e28dd008 	add	sp, sp, #8
    9964:	e8bd000c 	pop	{r2, r3}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:223
    9968:	e2700000 	rsbs	r0, r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:224
    996c:	e0c11081 	sbc	r1, r1, r1, lsl #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:225
    9970:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:229
    9974:	e2722000 	rsbs	r2, r2, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:230
    9978:	e0c33083 	sbc	r3, r3, r3, lsl #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:232
    997c:	eb000021 	bl	9a08 <__udivmoddi4>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:233
    9980:	e59de004 	ldr	lr, [sp, #4]
    9984:	e28dd008 	add	sp, sp, #8
    9988:	e8bd000c 	pop	{r2, r3}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:234
    998c:	e2722000 	rsbs	r2, r2, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:235
    9990:	e0c33083 	sbc	r3, r3, r3, lsl #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:236
    9994:	e12fff1e 	bx	lr

00009998 <__aeabi_f2lz>:
__fixsfdi():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1530
    9998:	ee070a90 	vmov	s15, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1531
    999c:	eef57ac0 	vcmpe.f32	s15, #0.0
    99a0:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    99a4:	4a000000 	bmi	99ac <__aeabi_f2lz+0x14>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1533
    99a8:	ea000006 	b	99c8 <__aeabi_f2ulz>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1532
    99ac:	eef17a67 	vneg.f32	s15, s15
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1530
    99b0:	e92d4010 	push	{r4, lr}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1532
    99b4:	ee170a90 	vmov	r0, s15
    99b8:	eb000002 	bl	99c8 <__aeabi_f2ulz>
    99bc:	e2700000 	rsbs	r0, r0, #0
    99c0:	e2e11000 	rsc	r1, r1, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1534
    99c4:	e8bd8010 	pop	{r4, pc}

000099c8 <__aeabi_f2ulz>:
__fixunssfdi():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1471
    99c8:	ee070a90 	vmov	s15, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1476
    99cc:	ed9f6b09 	vldr	d6, [pc, #36]	; 99f8 <__aeabi_f2ulz+0x30>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1481
    99d0:	ed9f5b0a 	vldr	d5, [pc, #40]	; 9a00 <__aeabi_f2ulz+0x38>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1471
    99d4:	eeb77ae7 	vcvt.f64.f32	d7, s15
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1476
    99d8:	ee276b06 	vmul.f64	d6, d7, d6
    99dc:	eebc6bc6 	vcvt.u32.f64	s12, d6
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1481
    99e0:	eeb84b46 	vcvt.f64.u32	d4, s12
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1524
    99e4:	ee161a10 	vmov	r1, s12
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1481
    99e8:	ee047b45 	vmls.f64	d7, d4, d5
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1524
    99ec:	eefc7bc7 	vcvt.u32.f64	s15, d7
    99f0:	ee170a90 	vmov	r0, s15
    99f4:	e12fff1e 	bx	lr
    99f8:	00000000 	andeq	r0, r0, r0
    99fc:	3df00000 	ldclcc	0, cr0, [r0]
    9a00:	00000000 	andeq	r0, r0, r0
    9a04:	41f00000 	mvnsmi	r0, r0

00009a08 <__udivmoddi4>:
__udivmoddi4():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:960
    9a08:	e1500002 	cmp	r0, r2
    9a0c:	e0d1c003 	sbcs	ip, r1, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:948
    9a10:	e92d43f0 	push	{r4, r5, r6, r7, r8, r9, lr}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:949
    9a14:	33a05000 	movcc	r5, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:948
    9a18:	e59d701c 	ldr	r7, [sp, #28]
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:949
    9a1c:	31a06005 	movcc	r6, r5
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:960
    9a20:	3a00003b 	bcc	9b14 <__udivmoddi4+0x10c>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:962
    9a24:	e3530000 	cmp	r3, #0
    9a28:	016fcf12 	clzeq	ip, r2
    9a2c:	116fef13 	clzne	lr, r3
    9a30:	028ce020 	addeq	lr, ip, #32
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:963
    9a34:	e3510000 	cmp	r1, #0
    9a38:	016fcf10 	clzeq	ip, r0
    9a3c:	028cc020 	addeq	ip, ip, #32
    9a40:	116fcf11 	clzne	ip, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:965
    9a44:	e04ec00c 	sub	ip, lr, ip
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:966
    9a48:	e1a03c13 	lsl	r3, r3, ip
    9a4c:	e24c9020 	sub	r9, ip, #32
    9a50:	e1833912 	orr	r3, r3, r2, lsl r9
    9a54:	e1a04c12 	lsl	r4, r2, ip
    9a58:	e26c8020 	rsb	r8, ip, #32
    9a5c:	e1833832 	orr	r3, r3, r2, lsr r8
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:973
    9a60:	e1500004 	cmp	r0, r4
    9a64:	e0d12003 	sbcs	r2, r1, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:949
    9a68:	33a05000 	movcc	r5, #0
    9a6c:	31a06005 	movcc	r6, r5
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:973
    9a70:	3a000005 	bcc	9a8c <__udivmoddi4+0x84>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:976
    9a74:	e3a05001 	mov	r5, #1
    9a78:	e1a06915 	lsl	r6, r5, r9
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:975
    9a7c:	e0500004 	subs	r0, r0, r4
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:976
    9a80:	e1866835 	orr	r6, r6, r5, lsr r8
    9a84:	e1a05c15 	lsl	r5, r5, ip
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:975
    9a88:	e0c11003 	sbc	r1, r1, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:979
    9a8c:	e35c0000 	cmp	ip, #0
    9a90:	0a00001f 	beq	9b14 <__udivmoddi4+0x10c>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:981
    9a94:	e1a040a4 	lsr	r4, r4, #1
    9a98:	e1844f83 	orr	r4, r4, r3, lsl #31
    9a9c:	e1a020a3 	lsr	r2, r3, #1
    9aa0:	e1a0e00c 	mov	lr, ip
    9aa4:	ea000007 	b	9ac8 <__udivmoddi4+0xc0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:989
    9aa8:	e0503004 	subs	r3, r0, r4
    9aac:	e0c11002 	sbc	r1, r1, r2
    9ab0:	e0933003 	adds	r3, r3, r3
    9ab4:	e0a11001 	adc	r1, r1, r1
    9ab8:	e2930001 	adds	r0, r3, #1
    9abc:	e2a11000 	adc	r1, r1, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:993
    9ac0:	e25ee001 	subs	lr, lr, #1
    9ac4:	0a000006 	beq	9ae4 <__udivmoddi4+0xdc>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:988
    9ac8:	e1500004 	cmp	r0, r4
    9acc:	e0d13002 	sbcs	r3, r1, r2
    9ad0:	2afffff4 	bcs	9aa8 <__udivmoddi4+0xa0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:991
    9ad4:	e0900000 	adds	r0, r0, r0
    9ad8:	e0a11001 	adc	r1, r1, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:993
    9adc:	e25ee001 	subs	lr, lr, #1
    9ae0:	1afffff8 	bne	9ac8 <__udivmoddi4+0xc0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:997
    9ae4:	e0955000 	adds	r5, r5, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:998
    9ae8:	e1a00c30 	lsr	r0, r0, ip
    9aec:	e1800811 	orr	r0, r0, r1, lsl r8
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:997
    9af0:	e0a66001 	adc	r6, r6, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:998
    9af4:	e1800931 	orr	r0, r0, r1, lsr r9
    9af8:	e1a01c31 	lsr	r1, r1, ip
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:999
    9afc:	e1a03c10 	lsl	r3, r0, ip
    9b00:	e1a0cc11 	lsl	ip, r1, ip
    9b04:	e18cc910 	orr	ip, ip, r0, lsl r9
    9b08:	e18cc830 	orr	ip, ip, r0, lsr r8
    9b0c:	e0555003 	subs	r5, r5, r3
    9b10:	e0c6600c 	sbc	r6, r6, ip
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1003
    9b14:	e3570000 	cmp	r7, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1004
    9b18:	11c700f0 	strdne	r0, [r7]
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1006
    9b1c:	e1a00005 	mov	r0, r5
    9b20:	e1a01006 	mov	r1, r6
    9b24:	e8bd83f0 	pop	{r4, r5, r6, r7, r8, r9, pc}

Disassembly of section .rodata:

00009b28 <_ZL13Lock_Unlocked>:
    9b28:	00000000 	andeq	r0, r0, r0

00009b2c <_ZL11Lock_Locked>:
    9b2c:	00000001 	andeq	r0, r0, r1

00009b30 <_ZL21MaxFSDriverNameLength>:
    9b30:	00000010 	andeq	r0, r0, r0, lsl r0

00009b34 <_ZL17MaxFilenameLength>:
    9b34:	00000010 	andeq	r0, r0, r0, lsl r0

00009b38 <_ZL13MaxPathLength>:
    9b38:	00000080 	andeq	r0, r0, r0, lsl #1

00009b3c <_ZL18NoFilesystemDriver>:
    9b3c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009b40 <_ZL9NotifyAll>:
    9b40:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009b44 <_ZL24Max_Process_Opened_Files>:
    9b44:	00000010 	andeq	r0, r0, r0, lsl r0

00009b48 <_ZL10Indefinite>:
    9b48:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009b4c <_ZL18Deadline_Unchanged>:
    9b4c:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

00009b50 <_ZL14Invalid_Handle>:
    9b50:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
    9b54:	3a564544 	bcc	159b06c <__bss_end+0x1591484>
    9b58:	74726175 	ldrbtvc	r6, [r2], #-373	; 0xfffffe8b
    9b5c:	0000302f 	andeq	r3, r0, pc, lsr #32
    9b60:	54524155 	ldrbpl	r4, [r2], #-341	; 0xfffffeab
    9b64:	73617420 	cmnvc	r1, #32, 8	; 0x20000000
    9b68:	7473206b 	ldrbtvc	r2, [r3], #-107	; 0xffffff95
    9b6c:	69747261 	ldmdbvs	r4!, {r0, r5, r6, r9, ip, sp, lr}^
    9b70:	0021676e 	eoreq	r6, r1, lr, ror #14
    9b74:	00676f6c 	rsbeq	r6, r7, ip, ror #30
    9b78:	205b0a0d 	subscs	r0, fp, sp, lsl #20
    9b7c:	00000000 	andeq	r0, r0, r0
    9b80:	00203a5d 	eoreq	r3, r0, sp, asr sl

00009b84 <_ZL13Lock_Unlocked>:
    9b84:	00000000 	andeq	r0, r0, r0

00009b88 <_ZL11Lock_Locked>:
    9b88:	00000001 	andeq	r0, r0, r1

00009b8c <_ZL21MaxFSDriverNameLength>:
    9b8c:	00000010 	andeq	r0, r0, r0, lsl r0

00009b90 <_ZL17MaxFilenameLength>:
    9b90:	00000010 	andeq	r0, r0, r0, lsl r0

00009b94 <_ZL13MaxPathLength>:
    9b94:	00000080 	andeq	r0, r0, r0, lsl #1

00009b98 <_ZL18NoFilesystemDriver>:
    9b98:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009b9c <_ZL9NotifyAll>:
    9b9c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009ba0 <_ZL24Max_Process_Opened_Files>:
    9ba0:	00000010 	andeq	r0, r0, r0, lsl r0

00009ba4 <_ZL10Indefinite>:
    9ba4:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009ba8 <_ZL18Deadline_Unchanged>:
    9ba8:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

00009bac <_ZL14Invalid_Handle>:
    9bac:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009bb0 <_ZL16Pipe_File_Prefix>:
    9bb0:	3a535953 	bcc	14e0104 <__bss_end+0x14d651c>
    9bb4:	65706970 	ldrbvs	r6, [r0, #-2416]!	; 0xfffff690
    9bb8:	0000002f 	andeq	r0, r0, pc, lsr #32

00009bbc <_ZN12_GLOBAL__N_1L11CharConvArrE>:
    9bbc:	33323130 	teqcc	r2, #48, 2
    9bc0:	37363534 			; <UNDEFINED> instruction: 0x37363534
    9bc4:	42413938 	submi	r3, r1, #56, 18	; 0xe0000
    9bc8:	46454443 	strbmi	r4, [r5], -r3, asr #8
	...

Disassembly of section .ARM.exidx:

00009bd0 <__CTOR_LIST__-0x8>:
    9bd0:	7ffffe38 	svcvc	0x00fffe38
    9bd4:	00000001 	andeq	r0, r0, r1

Disassembly of section .bss:

00009bd8 <__bss_start>:
	...

Disassembly of section .ARM.attributes:

00000000 <.ARM.attributes>:
   0:	00002e41 	andeq	r2, r0, r1, asr #28
   4:	61656100 	cmnvs	r5, r0, lsl #2
   8:	01006962 	tsteq	r0, r2, ror #18
   c:	00000024 	andeq	r0, r0, r4, lsr #32
  10:	4b5a3605 	blmi	168d82c <__bss_end+0x1683c44>
  14:	08070600 	stmdaeq	r7, {r9, sl}
  18:	0a010901 	beq	42424 <__bss_end+0x3883c>
  1c:	14041202 	strne	r1, [r4], #-514	; 0xfffffdfe
  20:	17011501 	strne	r1, [r1, -r1, lsl #10]
  24:	1a011803 	bne	46038 <__bss_end+0x3c450>
  28:	22011c01 	andcs	r1, r1, #256	; 0x100
  2c:	Address 0x000000000000002c is out of bounds.


Disassembly of section .comment:

00000000 <.comment>:
   0:	3a434347 	bcc	10d0d24 <__bss_end+0x10c713c>
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
      e0:	db010100 	blle	404e8 <__bss_end+0x36900>
      e4:	03000000 	movweq	r0, #0
      e8:	00005200 	andeq	r5, r0, r0, lsl #4
      ec:	fb010200 	blx	408f6 <__bss_end+0x36d0e>
      f0:	01000d0e 	tsteq	r0, lr, lsl #26
      f4:	00010101 	andeq	r0, r1, r1, lsl #2
      f8:	00010000 	andeq	r0, r1, r0
      fc:	682f0100 	stmdavs	pc!, {r8}	; <UNPREDICTABLE>
     100:	2f656d6f 	svccs	0x00656d6f
     104:	66657274 			; <UNDEFINED> instruction: 0x66657274
     108:	732f6c69 			; <UNDEFINED> instruction: 0x732f6c69
     10c:	732f6d65 			; <UNDEFINED> instruction: 0x732f6d65
     110:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
     114:	752f7365 	strvc	r7, [pc, #-869]!	; fffffdb7 <__bss_end+0xffff61cf>
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
     14c:	0a05830b 	beq	160d80 <__bss_end+0x157198>
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
     178:	4a030402 	bmi	c1188 <__bss_end+0xb75a0>
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
     1ac:	4a020402 	bmi	811bc <__bss_end+0x775d4>
     1b0:	02000205 	andeq	r0, r0, #1342177280	; 0x50000000
     1b4:	052d0204 	streq	r0, [sp, #-516]!	; 0xfffffdfc
     1b8:	01058509 	tsteq	r5, r9, lsl #10
     1bc:	000a022f 	andeq	r0, sl, pc, lsr #4
     1c0:	02030101 	andeq	r0, r3, #1073741824	; 0x40000000
     1c4:	00030000 	andeq	r0, r3, r0
     1c8:	000001b0 			; <UNDEFINED> instruction: 0x000001b0
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
     200:	67676f6c 	strbvs	r6, [r7, -ip, ror #30]!
     204:	745f7265 	ldrbvc	r7, [pc], #-613	; 20c <shift+0x20c>
     208:	006b7361 	rsbeq	r7, fp, r1, ror #6
     20c:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 158 <shift+0x158>
     210:	72742f65 	rsbsvc	r2, r4, #404	; 0x194
     214:	6c696665 	stclvs	6, cr6, [r9], #-404	; 0xfffffe6c
     218:	6d65732f 	stclvs	3, cr7, [r5, #-188]!	; 0xffffff44
     21c:	756f732f 	strbvc	r7, [pc, #-815]!	; fffffef5 <__bss_end+0xffff630d>
     220:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
     224:	6573752f 	ldrbvs	r7, [r3, #-1327]!	; 0xfffffad1
     228:	61707372 	cmnvs	r0, r2, ror r3
     22c:	2e2f6563 	cfsh64cs	mvdx6, mvdx15, #51
     230:	656b2f2e 	strbvs	r2, [fp, #-3886]!	; 0xfffff0d2
     234:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
     238:	636e692f 	cmnvs	lr, #770048	; 0xbc000
     23c:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
     240:	6f72702f 	svcvs	0x0072702f
     244:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     248:	6f682f00 	svcvs	0x00682f00
     24c:	742f656d 	strtvc	r6, [pc], #-1389	; 254 <shift+0x254>
     250:	69666572 	stmdbvs	r6!, {r1, r4, r5, r6, r8, sl, sp, lr}^
     254:	65732f6c 	ldrbvs	r2, [r3, #-3948]!	; 0xfffff094
     258:	6f732f6d 	svcvs	0x00732f6d
     25c:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
     260:	73752f73 	cmnvc	r5, #460	; 0x1cc
     264:	70737265 	rsbsvc	r7, r3, r5, ror #4
     268:	2f656361 	svccs	0x00656361
     26c:	6b2f2e2e 	blvs	bcbb2c <__bss_end+0xbc1f44>
     270:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
     274:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
     278:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
     27c:	73662f65 	cmnvc	r6, #404	; 0x194
     280:	6f682f00 	svcvs	0x00682f00
     284:	742f656d 	strtvc	r6, [pc], #-1389	; 28c <shift+0x28c>
     288:	69666572 	stmdbvs	r6!, {r1, r4, r5, r6, r8, sl, sp, lr}^
     28c:	65732f6c 	ldrbvs	r2, [r3, #-3948]!	; 0xfffff094
     290:	6f732f6d 	svcvs	0x00732f6d
     294:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
     298:	73752f73 	cmnvc	r5, #460	; 0x1cc
     29c:	70737265 	rsbsvc	r7, r3, r5, ror #4
     2a0:	2f656361 	svccs	0x00656361
     2a4:	6b2f2e2e 	blvs	bcbb64 <__bss_end+0xbc1f7c>
     2a8:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
     2ac:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
     2b0:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
     2b4:	72642f65 	rsbvc	r2, r4, #404	; 0x194
     2b8:	72657669 	rsbvc	r7, r5, #110100480	; 0x6900000
     2bc:	72622f73 	rsbvc	r2, r2, #460	; 0x1cc
     2c0:	65676469 	strbvs	r6, [r7, #-1129]!	; 0xfffffb97
     2c4:	682f0073 	stmdavs	pc!, {r0, r1, r4, r5, r6}	; <UNPREDICTABLE>
     2c8:	2f656d6f 	svccs	0x00656d6f
     2cc:	66657274 			; <UNDEFINED> instruction: 0x66657274
     2d0:	732f6c69 			; <UNDEFINED> instruction: 0x732f6c69
     2d4:	732f6d65 			; <UNDEFINED> instruction: 0x732f6d65
     2d8:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
     2dc:	752f7365 	strvc	r7, [pc, #-869]!	; ffffff7f <__bss_end+0xffff6397>
     2e0:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
     2e4:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
     2e8:	2f2e2e2f 	svccs	0x002e2e2f
     2ec:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
     2f0:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
     2f4:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
     2f8:	622f6564 	eorvs	r6, pc, #100, 10	; 0x19000000
     2fc:	6472616f 	ldrbtvs	r6, [r2], #-367	; 0xfffffe91
     300:	6970722f 	ldmdbvs	r0!, {r0, r1, r2, r3, r5, r9, ip, sp, lr}^
     304:	61682f30 	cmnvs	r8, r0, lsr pc
     308:	6d00006c 	stcvs	0, cr0, [r0, #-432]	; 0xfffffe50
     30c:	2e6e6961 	vnmulcs.f16	s13, s28, s3	; <UNPREDICTABLE>
     310:	00707063 	rsbseq	r7, r0, r3, rrx
     314:	73000001 	movwvc	r0, #1
     318:	6c6e6970 			; <UNDEFINED> instruction: 0x6c6e6970
     31c:	2e6b636f 	cdpcs	3, 6, cr6, cr11, cr15, {3}
     320:	00020068 	andeq	r0, r2, r8, rrx
     324:	6c696600 	stclvs	6, cr6, [r9], #-0
     328:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     32c:	2e6d6574 	mcrcs	5, 3, r6, cr13, cr4, {3}
     330:	00030068 	andeq	r0, r3, r8, rrx
     334:	69777300 	ldmdbvs	r7!, {r8, r9, ip, sp, lr}^
     338:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
     33c:	72700000 	rsbsvc	r0, r0, #0
     340:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     344:	00682e73 	rsbeq	r2, r8, r3, ror lr
     348:	70000002 	andvc	r0, r0, r2
     34c:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     350:	6d5f7373 	ldclvs	3, cr7, [pc, #-460]	; 18c <shift+0x18c>
     354:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     358:	682e7265 	stmdavs	lr!, {r0, r2, r5, r6, r9, ip, sp, lr}
     35c:	00000200 	andeq	r0, r0, r0, lsl #4
     360:	74726175 	ldrbtvc	r6, [r2], #-373	; 0xfffffe8b
     364:	6665645f 			; <UNDEFINED> instruction: 0x6665645f
     368:	00682e73 	rsbeq	r2, r8, r3, ror lr
     36c:	69000004 	stmdbvs	r0, {r2}
     370:	6564746e 	strbvs	r7, [r4, #-1134]!	; 0xfffffb92
     374:	00682e66 	rsbeq	r2, r8, r6, ror #28
     378:	00000005 	andeq	r0, r0, r5
     37c:	05000105 	streq	r0, [r0, #-261]	; 0xfffffefb
     380:	00822c02 	addeq	r2, r2, r2, lsl #24
     384:	010c0300 	mrseq	r0, LR_mon
     388:	059f1c05 	ldreq	r1, [pc, #3077]	; f95 <shift+0xf95>
     38c:	01056607 	tsteq	r5, r7, lsl #12
     390:	1b056983 	blne	15a9a4 <__bss_end+0x150dbc>
     394:	8513059f 	ldrhi	r0, [r3, #-1439]	; 0xfffffa61
     398:	054b1505 	strbeq	r1, [fp, #-1285]	; 0xfffffafb
     39c:	6aa04b07 	bvs	fe812fc0 <__bss_end+0xfe8093d8>
     3a0:	840b0583 	strhi	r0, [fp], #-1411	; 0xfffffa7d
     3a4:	054c1905 	strbeq	r1, [ip, #-2309]	; 0xfffff6fb
     3a8:	14058707 	strne	r8, [r5], #-1799	; 0xfffff8f9
     3ac:	bb030584 	bllt	c19c4 <__bss_end+0xb7ddc>
     3b0:	05680b05 	strbeq	r0, [r8, #-2821]!	; 0xfffff4fb
     3b4:	22059f09 	andcs	r9, r5, #9, 30	; 0x24
     3b8:	4b080567 	blmi	20195c <__bss_end+0x1f7d74>
     3bc:	839f0905 	orrshi	r0, pc, #81920	; 0x14000
     3c0:	84020567 	strhi	r0, [r2], #-1383	; 0xfffffa99
     3c4:	01000e02 	tsteq	r0, r2, lsl #28
     3c8:	00021801 	andeq	r1, r2, r1, lsl #16
     3cc:	2d000300 	stccs	3, cr0, [r0, #-0]
     3d0:	02000001 	andeq	r0, r0, #1
     3d4:	0d0efb01 	vstreq	d15, [lr, #-4]
     3d8:	01010100 	mrseq	r0, (UNDEF: 17)
     3dc:	00000001 	andeq	r0, r0, r1
     3e0:	01000001 	tsteq	r0, r1
     3e4:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 330 <shift+0x330>
     3e8:	72742f65 	rsbsvc	r2, r4, #404	; 0x194
     3ec:	6c696665 	stclvs	6, cr6, [r9], #-404	; 0xfffffe6c
     3f0:	6d65732f 	stclvs	3, cr7, [r5, #-188]!	; 0xffffff44
     3f4:	756f732f 	strbvc	r7, [pc, #-815]!	; cd <shift+0xcd>
     3f8:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
     3fc:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
     400:	2f62696c 	svccs	0x0062696c
     404:	00637273 	rsbeq	r7, r3, r3, ror r2
     408:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 354 <shift+0x354>
     40c:	72742f65 	rsbsvc	r2, r4, #404	; 0x194
     410:	6c696665 	stclvs	6, cr6, [r9], #-404	; 0xfffffe6c
     414:	6d65732f 	stclvs	3, cr7, [r5, #-188]!	; 0xffffff44
     418:	756f732f 	strbvc	r7, [pc, #-815]!	; f1 <shift+0xf1>
     41c:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
     420:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
     424:	2f6c656e 	svccs	0x006c656e
     428:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
     42c:	2f656475 	svccs	0x00656475
     430:	636f7270 	cmnvs	pc, #112, 4
     434:	00737365 	rsbseq	r7, r3, r5, ror #6
     438:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 384 <shift+0x384>
     43c:	72742f65 	rsbsvc	r2, r4, #404	; 0x194
     440:	6c696665 	stclvs	6, cr6, [r9], #-404	; 0xfffffe6c
     444:	6d65732f 	stclvs	3, cr7, [r5, #-188]!	; 0xffffff44
     448:	756f732f 	strbvc	r7, [pc, #-815]!	; 121 <shift+0x121>
     44c:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
     450:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
     454:	2f6c656e 	svccs	0x006c656e
     458:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
     45c:	2f656475 	svccs	0x00656475
     460:	2f007366 	svccs	0x00007366
     464:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
     468:	6572742f 	ldrbvs	r7, [r2, #-1071]!	; 0xfffffbd1
     46c:	2f6c6966 	svccs	0x006c6966
     470:	2f6d6573 	svccs	0x006d6573
     474:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
     478:	2f736563 	svccs	0x00736563
     47c:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
     480:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
     484:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
     488:	622f6564 	eorvs	r6, pc, #100, 10	; 0x19000000
     48c:	6472616f 	ldrbtvs	r6, [r2], #-367	; 0xfffffe91
     490:	6970722f 	ldmdbvs	r0!, {r0, r1, r2, r3, r5, r9, ip, sp, lr}^
     494:	61682f30 	cmnvs	r8, r0, lsr pc
     498:	7300006c 	movwvc	r0, #108	; 0x6c
     49c:	69666474 	stmdbvs	r6!, {r2, r4, r5, r6, sl, sp, lr}^
     4a0:	632e656c 			; <UNDEFINED> instruction: 0x632e656c
     4a4:	01007070 	tsteq	r0, r0, ror r0
     4a8:	77730000 	ldrbvc	r0, [r3, -r0]!
     4ac:	00682e69 	rsbeq	r2, r8, r9, ror #28
     4b0:	73000002 	movwvc	r0, #2
     4b4:	6c6e6970 			; <UNDEFINED> instruction: 0x6c6e6970
     4b8:	2e6b636f 	cdpcs	3, 6, cr6, cr11, cr15, {3}
     4bc:	00020068 	andeq	r0, r2, r8, rrx
     4c0:	6c696600 	stclvs	6, cr6, [r9], #-0
     4c4:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     4c8:	2e6d6574 	mcrcs	5, 3, r6, cr13, cr4, {3}
     4cc:	00030068 	andeq	r0, r3, r8, rrx
     4d0:	6f727000 	svcvs	0x00727000
     4d4:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     4d8:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
     4dc:	72700000 	rsbsvc	r0, r0, #0
     4e0:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     4e4:	616d5f73 	smcvs	54771	; 0xd5f3
     4e8:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     4ec:	00682e72 	rsbeq	r2, r8, r2, ror lr
     4f0:	69000002 	stmdbvs	r0, {r1}
     4f4:	6564746e 	strbvs	r7, [r4, #-1134]!	; 0xfffffb92
     4f8:	00682e66 	rsbeq	r2, r8, r6, ror #28
     4fc:	00000004 	andeq	r0, r0, r4
     500:	05000105 	streq	r0, [r0, #-261]	; 0xfffffefb
     504:	0083ac02 	addeq	sl, r3, r2, lsl #24
     508:	05051600 	streq	r1, [r5, #-1536]	; 0xfffffa00
     50c:	0c052f69 	stceq	15, cr2, [r5], {105}	; 0x69
     510:	2f01054c 	svccs	0x0001054c
     514:	83050585 	movwhi	r0, #21893	; 0x5585
     518:	2f01054b 	svccs	0x0001054b
     51c:	4b050585 	blmi	141b38 <__bss_end+0x137f50>
     520:	852f0105 	strhi	r0, [pc, #-261]!	; 423 <shift+0x423>
     524:	4ba10505 	blmi	fe841940 <__bss_end+0xfe837d58>
     528:	0c052f4b 	stceq	15, cr2, [r5], {75}	; 0x4b
     52c:	2f01054c 	svccs	0x0001054c
     530:	bd050585 	cfstr32lt	mvfx0, [r5, #-532]	; 0xfffffdec
     534:	2f4b4b4b 	svccs	0x004b4b4b
     538:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
     53c:	05862f01 	streq	r2, [r6, #3841]	; 0xf01
     540:	4b4bbd05 	blmi	12ef95c <__bss_end+0x12e5d74>
     544:	0c052f4b 	stceq	15, cr2, [r5], {75}	; 0x4b
     548:	2f01054c 	svccs	0x0001054c
     54c:	83050585 	movwhi	r0, #21893	; 0x5585
     550:	2f01054b 	svccs	0x0001054b
     554:	bd050585 	cfstr32lt	mvfx0, [r5, #-532]	; 0xfffffdec
     558:	2f4b4b4b 	svccs	0x004b4b4b
     55c:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
     560:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
     564:	4b4ba105 	blmi	12e8980 <__bss_end+0x12ded98>
     568:	4c0c052f 	cfstr32mi	mvfx0, [ip], {47}	; 0x2f
     56c:	852f0105 	strhi	r0, [pc, #-261]!	; 46f <shift+0x46f>
     570:	4bbd0505 	blmi	fef4198c <__bss_end+0xfef37da4>
     574:	052f4b4b 	streq	r4, [pc, #-2891]!	; fffffa31 <__bss_end+0xffff5e49>
     578:	01054c0c 	tsteq	r5, ip, lsl #24
     57c:	0505852f 	streq	r8, [r5, #-1327]	; 0xfffffad1
     580:	2f4b4ba1 	svccs	0x004b4ba1
     584:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
     588:	05859f01 	streq	r9, [r5, #3841]	; 0xf01
     58c:	05056720 	streq	r6, [r5, #-1824]	; 0xfffff8e0
     590:	054b4b4d 	strbeq	r4, [fp, #-2893]	; 0xfffff4b3
     594:	0105300c 	tsteq	r5, ip
     598:	2005852f 	andcs	r8, r5, pc, lsr #10
     59c:	4d050567 	cfstr32mi	mvfx0, [r5, #-412]	; 0xfffffe64
     5a0:	0c054b4b 			; <UNDEFINED> instruction: 0x0c054b4b
     5a4:	2f010530 	svccs	0x00010530
     5a8:	83200585 			; <UNDEFINED> instruction: 0x83200585
     5ac:	4b4c0505 	blmi	13019c8 <__bss_end+0x12f7de0>
     5b0:	2f01054b 	svccs	0x0001054b
     5b4:	67200585 	strvs	r0, [r0, -r5, lsl #11]!
     5b8:	4b4d0505 	blmi	13419d4 <__bss_end+0x1337dec>
     5bc:	300c054b 	andcc	r0, ip, fp, asr #10
     5c0:	872f0105 	strhi	r0, [pc, -r5, lsl #2]!
     5c4:	9fa00c05 	svcls	0x00a00c05
     5c8:	05bc3105 	ldreq	r3, [ip, #261]!	; 0x105
     5cc:	36056629 	strcc	r6, [r5], -r9, lsr #12
     5d0:	300f052e 	andcc	r0, pc, lr, lsr #10
     5d4:	05661305 	strbeq	r1, [r6, #-773]!	; 0xfffffcfb
     5d8:	10058409 	andne	r8, r5, r9, lsl #8
     5dc:	9f0105d8 	svcls	0x000105d8
     5e0:	01000802 	tsteq	r0, r2, lsl #16
     5e4:	00050d01 	andeq	r0, r5, r1, lsl #26
     5e8:	48000300 	stmdami	r0, {r8, r9}
     5ec:	02000000 	andeq	r0, r0, #0
     5f0:	0d0efb01 	vstreq	d15, [lr, #-4]
     5f4:	01010100 	mrseq	r0, (UNDEF: 17)
     5f8:	00000001 	andeq	r0, r0, r1
     5fc:	01000001 	tsteq	r0, r1
     600:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 54c <shift+0x54c>
     604:	72742f65 	rsbsvc	r2, r4, #404	; 0x194
     608:	6c696665 	stclvs	6, cr6, [r9], #-404	; 0xfffffe6c
     60c:	6d65732f 	stclvs	3, cr7, [r5, #-188]!	; 0xffffff44
     610:	756f732f 	strbvc	r7, [pc, #-815]!	; 2e9 <shift+0x2e9>
     614:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
     618:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
     61c:	2f62696c 	svccs	0x0062696c
     620:	00637273 	rsbeq	r7, r3, r3, ror r2
     624:	64747300 	ldrbtvs	r7, [r4], #-768	; 0xfffffd00
     628:	69727473 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
     62c:	632e676e 			; <UNDEFINED> instruction: 0x632e676e
     630:	01007070 	tsteq	r0, r0, ror r0
     634:	05000000 	streq	r0, [r0, #-0]
     638:	02050001 	andeq	r0, r5, #1
     63c:	00008808 	andeq	r8, r0, r8, lsl #16
     640:	bb09051a 	bllt	241ab0 <__bss_end+0x237ec8>
     644:	4c0f054b 	cfstr32mi	mvfx0, [pc], {75}	; 0x4b
     648:	05681b05 	strbeq	r1, [r8, #-2821]!	; 0xfffff4fb
     64c:	0a052e21 	beq	14bed8 <__bss_end+0x1422f0>
     650:	2e0b059e 	mcrcs	5, 0, r0, cr11, cr14, {4}
     654:	054a2705 	strbeq	r2, [sl, #-1797]	; 0xfffff8fb
     658:	09054a0d 	stmdbeq	r5, {r0, r2, r3, r9, fp, lr}
     65c:	bb04052f 	bllt	101b20 <__bss_end+0xf7f38>
     660:	05620205 	strbeq	r0, [r2, #-517]!	; 0xfffffdfb
     664:	10053505 	andne	r3, r5, r5, lsl #10
     668:	2e110568 	cfmsc32cs	mvfx0, mvfx1, mvfx8
     66c:	054a2205 	strbeq	r2, [sl, #-517]	; 0xfffffdfb
     670:	0a052e13 	beq	14bec4 <__bss_end+0x1422dc>
     674:	6909052f 	stmdbvs	r9, {r0, r1, r2, r3, r5, r8, sl}
     678:	052e0a05 	streq	r0, [lr, #-2565]!	; 0xfffff5fb
     67c:	03054a0c 	movweq	r4, #23052	; 0x5a0c
     680:	0010054b 	andseq	r0, r0, fp, asr #10
     684:	68020402 	stmdavs	r2, {r1, sl}
     688:	02000c05 	andeq	r0, r0, #1280	; 0x500
     68c:	059e0204 	ldreq	r0, [lr, #516]	; 0x204
     690:	04020015 	streq	r0, [r2], #-21	; 0xffffffeb
     694:	18056801 	stmdane	r5, {r0, fp, sp, lr}
     698:	01040200 	mrseq	r0, R12_usr
     69c:	00080582 	andeq	r0, r8, r2, lsl #11
     6a0:	4a010402 	bmi	416b0 <__bss_end+0x37ac8>
     6a4:	02001a05 	andeq	r1, r0, #20480	; 0x5000
     6a8:	054b0104 	strbeq	r0, [fp, #-260]	; 0xfffffefc
     6ac:	0402001b 	streq	r0, [r2], #-27	; 0xffffffe5
     6b0:	0c052e01 	stceq	14, cr2, [r5], {1}
     6b4:	01040200 	mrseq	r0, R12_usr
     6b8:	000f054a 	andeq	r0, pc, sl, asr #10
     6bc:	82010402 	andhi	r0, r1, #33554432	; 0x2000000
     6c0:	02001b05 	andeq	r1, r0, #5120	; 0x1400
     6c4:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
     6c8:	04020011 	streq	r0, [r2], #-17	; 0xffffffef
     6cc:	0a052e01 	beq	14bed8 <__bss_end+0x1422f0>
     6d0:	01040200 	mrseq	r0, R12_usr
     6d4:	000b052f 	andeq	r0, fp, pc, lsr #10
     6d8:	2e010402 	cdpcs	4, 0, cr0, cr1, cr2, {0}
     6dc:	02000d05 	andeq	r0, r0, #320	; 0x140
     6e0:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
     6e4:	04020002 	streq	r0, [r2], #-2
     6e8:	01054601 	tsteq	r5, r1, lsl #12
     6ec:	0e058589 	cfsh32eq	mvfx8, mvfx5, #-55
     6f0:	66160583 	ldrvs	r0, [r6], -r3, lsl #11
     6f4:	05820505 	streq	r0, [r2, #1285]	; 0x505
     6f8:	19054b10 	stmdbne	r5, {r4, r8, r9, fp, lr}
     6fc:	4b06054a 	blmi	181c2c <__bss_end+0x178044>
     700:	054c0905 	strbeq	r0, [ip, #-2309]	; 0xfffff6fb
     704:	0a054a10 	beq	152f4c <__bss_end+0x149364>
     708:	bb07054c 	bllt	1c1c40 <__bss_end+0x1b8058>
     70c:	054a0305 	strbeq	r0, [sl, #-773]	; 0xfffffcfb
     710:	04020017 	streq	r0, [r2], #-23	; 0xffffffe9
     714:	14054a01 	strne	r4, [r5], #-2561	; 0xfffff5ff
     718:	01040200 	mrseq	r0, R12_usr
     71c:	4d0d054a 	cfstr32mi	mvfx0, [sp, #-296]	; 0xfffffed8
     720:	054a1405 	strbeq	r1, [sl, #-1029]	; 0xfffffbfb
     724:	08052e0a 	stmdaeq	r5, {r1, r3, r9, sl, fp, sp}
     728:	03020568 	movweq	r0, #9576	; 0x2568
     72c:	09056678 	stmdbeq	r5, {r3, r4, r5, r6, r9, sl, sp, lr}
     730:	052e0b03 	streq	r0, [lr, #-2819]!	; 0xfffff4fd
     734:	27052f01 	strcs	r2, [r5, -r1, lsl #30]
     738:	840a056a 	strhi	r0, [sl], #-1386	; 0xfffffa96
     73c:	4b0b054b 	blmi	2c1c70 <__bss_end+0x2b8088>
     740:	054a1205 	strbeq	r1, [sl, #-517]	; 0xfffffdfb
     744:	09054b0e 	stmdbeq	r5, {r1, r2, r3, r8, r9, fp, lr}
     748:	00180567 	andseq	r0, r8, r7, ror #10
     74c:	66010402 	strvs	r0, [r1], -r2, lsl #8
     750:	02001505 	andeq	r1, r0, #20971520	; 0x1400000
     754:	05660104 	strbeq	r0, [r6, #-260]!	; 0xfffffefc
     758:	04020011 	streq	r0, [r2], #-17	; 0xffffffef
     75c:	1a054b02 	bne	15336c <__bss_end+0x149784>
     760:	02040200 	andeq	r0, r4, #0, 4
     764:	0012054b 	andseq	r0, r2, fp, asr #10
     768:	4b020402 	blmi	81778 <__bss_end+0x77b90>
     76c:	02000d05 	andeq	r0, r0, #320	; 0x140
     770:	05670204 	strbeq	r0, [r7, #-516]!	; 0xfffffdfc
     774:	14053109 	strne	r3, [r5], #-265	; 0xfffffef7
     778:	02040200 	andeq	r0, r4, #0, 4
     77c:	00260566 	eoreq	r0, r6, r6, ror #10
     780:	66030402 	strvs	r0, [r3], -r2, lsl #8
     784:	054c0905 	strbeq	r0, [ip, #-2309]	; 0xfffff6fb
     788:	0a05671a 	beq	15a3f8 <__bss_end+0x150810>
     78c:	0305054b 	movweq	r0, #21835	; 0x554b
     790:	0f036673 	svceq	0x00036673
     794:	001c052e 	andseq	r0, ip, lr, lsr #10
     798:	66010402 	strvs	r0, [r1], -r2, lsl #8
     79c:	004c0f05 	subeq	r0, ip, r5, lsl #30
     7a0:	06010402 	streq	r0, [r1], -r2, lsl #8
     7a4:	00130566 	andseq	r0, r3, r6, ror #10
     7a8:	06010402 	streq	r0, [r1], -r2, lsl #8
     7ac:	000f052e 	andeq	r0, pc, lr, lsr #10
     7b0:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
     7b4:	052e1305 	streq	r1, [lr, #-773]!	; 0xfffffcfb
     7b8:	1e053001 	cdpne	0, 0, cr3, cr5, cr1, {0}
     7bc:	830c0586 	movwhi	r0, #50566	; 0xc586
     7c0:	09056867 	stmdbeq	r5, {r0, r1, r2, r5, r6, fp, sp, lr}
     7c4:	0a054b67 	beq	153568 <__bss_end+0x149980>
     7c8:	4c0b054b 	cfstr32mi	mvfx0, [fp], {75}	; 0x4b
     7cc:	054a1205 	strbeq	r1, [sl, #-517]	; 0xfffffdfb
     7d0:	09054b0d 	stmdbeq	r5, {r0, r2, r3, r8, r9, fp, lr}
     7d4:	001b054a 	andseq	r0, fp, sl, asr #10
     7d8:	4b010402 	blmi	417e8 <__bss_end+0x37c00>
     7dc:	02001205 	andeq	r1, r0, #1342177280	; 0x50000000
     7e0:	054b0104 	strbeq	r0, [fp, #-260]	; 0xfffffefc
     7e4:	0402000d 	streq	r0, [r2], #-13
     7e8:	12056701 	andne	r6, r5, #262144	; 0x40000
     7ec:	4a0e0530 	bmi	381cb4 <__bss_end+0x3780cc>
     7f0:	02002205 	andeq	r2, r0, #1342177280	; 0x50000000
     7f4:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
     7f8:	0402001f 	streq	r0, [r2], #-31	; 0xffffffe1
     7fc:	16054a01 	strne	r4, [r5], -r1, lsl #20
     800:	4a1d054b 	bmi	741d34 <__bss_end+0x73814c>
     804:	052e1005 	streq	r1, [lr, #-5]!
     808:	13056709 	movwne	r6, #22281	; 0x5709
     80c:	d7230567 	strle	r0, [r3, -r7, ror #10]!
     810:	059e1405 	ldreq	r1, [lr, #1029]	; 0x405
     814:	1405851d 	strne	r8, [r5], #-1309	; 0xfffffae3
     818:	680e0566 	stmdavs	lr, {r1, r2, r5, r6, r8, sl}
     81c:	71030505 	tstvc	r3, r5, lsl #10
     820:	030c0566 	movweq	r0, #50534	; 0xc566
     824:	01052e11 	tsteq	r5, r1, lsl lr
     828:	0522084b 	streq	r0, [r2, #-2123]!	; 0xfffff7b5
     82c:	1605bd09 	strne	fp, [r5], -r9, lsl #26
     830:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
     834:	001d054a 	andseq	r0, sp, sl, asr #10
     838:	82020402 	andhi	r0, r2, #33554432	; 0x2000000
     83c:	02001e05 	andeq	r1, r0, #5, 28	; 0x50
     840:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
     844:	04020016 	streq	r0, [r2], #-22	; 0xffffffea
     848:	11056602 	tstne	r5, r2, lsl #12
     84c:	03040200 	movweq	r0, #16896	; 0x4200
     850:	0012054b 	andseq	r0, r2, fp, asr #10
     854:	2e030402 	cdpcs	4, 0, cr0, cr3, cr2, {0}
     858:	02000805 	andeq	r0, r0, #327680	; 0x50000
     85c:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
     860:	04020009 	streq	r0, [r2], #-9
     864:	12052e03 	andne	r2, r5, #3, 28	; 0x30
     868:	03040200 	movweq	r0, #16896	; 0x4200
     86c:	000b054a 	andeq	r0, fp, sl, asr #10
     870:	2e030402 	cdpcs	4, 0, cr0, cr3, cr2, {0}
     874:	02000205 	andeq	r0, r0, #1342177280	; 0x50000000
     878:	052d0304 	streq	r0, [sp, #-772]!	; 0xfffffcfc
     87c:	0402000b 	streq	r0, [r2], #-11
     880:	08058402 	stmdaeq	r5, {r1, sl, pc}
     884:	01040200 	mrseq	r0, R12_usr
     888:	00090583 	andeq	r0, r9, r3, lsl #11
     88c:	2e010402 	cdpcs	4, 0, cr0, cr1, cr2, {0}
     890:	02000b05 	andeq	r0, r0, #5120	; 0x1400
     894:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
     898:	04020002 	streq	r0, [r2], #-2
     89c:	0b054901 	bleq	152ca8 <__bss_end+0x1490c0>
     8a0:	2f010585 	svccs	0x00010585
     8a4:	bc0e0585 	cfstr32lt	mvfx0, [lr], {133}	; 0x85
     8a8:	05661105 	strbeq	r1, [r6, #-261]!	; 0xfffffefb
     8ac:	0b05bc20 	bleq	16f934 <__bss_end+0x165d4c>
     8b0:	4b1f0566 	blmi	7c1e50 <__bss_end+0x7b8268>
     8b4:	05660a05 	strbeq	r0, [r6, #-2565]!	; 0xfffff5fb
     8b8:	11054b08 	tstne	r5, r8, lsl #22
     8bc:	2e160583 	cdpcs	5, 1, cr0, cr6, cr3, {4}
     8c0:	05670805 	strbeq	r0, [r7, #-2053]!	; 0xfffff7fb
     8c4:	0b056711 	bleq	15a510 <__bss_end+0x150928>
     8c8:	2f01054d 	svccs	0x0001054d
     8cc:	83060585 	movwhi	r0, #25989	; 0x6585
     8d0:	054c0b05 	strbeq	r0, [ip, #-2821]	; 0xfffff4fb
     8d4:	0e052e0c 	cdpeq	14, 0, cr2, cr5, cr12, {0}
     8d8:	4b040566 	blmi	101e78 <__bss_end+0xf8290>
     8dc:	05650205 	strbeq	r0, [r5, #-517]!	; 0xfffffdfb
     8e0:	01053109 	tsteq	r5, r9, lsl #2
     8e4:	852a052f 	strhi	r0, [sl, #-1327]!	; 0xfffffad1
     8e8:	679f1305 	ldrvs	r1, [pc, r5, lsl #6]
     8ec:	05670905 	strbeq	r0, [r7, #-2309]!	; 0xfffff6fb
     8f0:	15054b0d 	strne	r4, [r5, #-2829]	; 0xfffff4f3
     8f4:	03040200 	movweq	r0, #16896	; 0x4200
     8f8:	0019054a 	andseq	r0, r9, sl, asr #10
     8fc:	83020402 	movwhi	r0, #9218	; 0x2402
     900:	02001a05 	andeq	r1, r0, #20480	; 0x5000
     904:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
     908:	0402000f 	streq	r0, [r2], #-15
     90c:	11054a02 	tstne	r5, r2, lsl #20
     910:	02040200 	andeq	r0, r4, #0, 4
     914:	001a0582 	andseq	r0, sl, r2, lsl #11
     918:	4a020402 	bmi	81928 <__bss_end+0x77d40>
     91c:	02001305 	andeq	r1, r0, #335544320	; 0x14000000
     920:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
     924:	04020005 	streq	r0, [r2], #-5
     928:	0a052d02 	beq	14bd38 <__bss_end+0x142150>
     92c:	2e0b0584 	cfsh32cs	mvfx0, mvfx11, #-60
     930:	054a0d05 	strbeq	r0, [sl, #-3333]	; 0xfffff2fb
     934:	01054b0c 	tsteq	r5, ip, lsl #22
     938:	67340530 			; <UNDEFINED> instruction: 0x67340530
     93c:	05bb0905 	ldreq	r0, [fp, #2309]!	; 0x905
     940:	05054c13 	streq	r4, [r5, #-3091]	; 0xfffff3ed
     944:	00190568 	andseq	r0, r9, r8, ror #10
     948:	82010402 	andhi	r0, r1, #33554432	; 0x2000000
     94c:	054c0d05 	strbeq	r0, [ip, #-3333]	; 0xfffff2fb
     950:	04020015 	streq	r0, [r2], #-21	; 0xffffffeb
     954:	10054a01 	andne	r4, r5, r1, lsl #20
     958:	2e110583 	cdpcs	5, 1, cr0, cr1, cr3, {4}
     95c:	05660905 	strbeq	r0, [r6, #-2309]!	; 0xfffff6fb
     960:	04020019 	streq	r0, [r2], #-25	; 0xffffffe7
     964:	1a054b02 	bne	153574 <__bss_end+0x14998c>
     968:	02040200 	andeq	r0, r4, #0, 4
     96c:	000f052e 	andeq	r0, pc, lr, lsr #10
     970:	4a020402 	bmi	81980 <__bss_end+0x77d98>
     974:	02001105 	andeq	r1, r0, #1073741825	; 0x40000001
     978:	05820204 	streq	r0, [r2, #516]	; 0x204
     97c:	0402001a 	streq	r0, [r2], #-26	; 0xffffffe6
     980:	13054a02 	movwne	r4, #23042	; 0x5a02
     984:	02040200 	andeq	r0, r4, #0, 4
     988:	0005052e 	andeq	r0, r5, lr, lsr #10
     98c:	2c020402 	cfstrscs	mvf0, [r2], {2}
     990:	05831b05 	streq	r1, [r3, #2821]	; 0xb05
     994:	0b05310a 	bleq	14cdc4 <__bss_end+0x1431dc>
     998:	4a0d052e 	bmi	341e58 <__bss_end+0x338270>
     99c:	054b0c05 	strbeq	r0, [fp, #-3077]	; 0xfffff3fb
     9a0:	056a3001 	strbeq	r3, [sl, #-1]!
     9a4:	0b059f08 	bleq	1685cc <__bss_end+0x15e9e4>
     9a8:	0014054c 	andseq	r0, r4, ip, asr #10
     9ac:	4a030402 	bmi	c19bc <__bss_end+0xb7dd4>
     9b0:	02000705 	andeq	r0, r0, #1310720	; 0x140000
     9b4:	05830204 	streq	r0, [r3, #516]	; 0x204
     9b8:	04020008 	streq	r0, [r2], #-8
     9bc:	0a052e02 	beq	14c1cc <__bss_end+0x1425e4>
     9c0:	02040200 	andeq	r0, r4, #0, 4
     9c4:	0002054a 	andeq	r0, r2, sl, asr #10
     9c8:	49020402 	stmdbmi	r2, {r1, sl}
     9cc:	85840105 	strhi	r0, [r4, #261]	; 0x105
     9d0:	05bb0e05 	ldreq	r0, [fp, #3589]!	; 0xe05
     9d4:	0b054b08 	bleq	1535fc <__bss_end+0x149a14>
     9d8:	0014054c 	andseq	r0, r4, ip, asr #10
     9dc:	4a030402 	bmi	c19ec <__bss_end+0xb7e04>
     9e0:	02001605 	andeq	r1, r0, #5242880	; 0x500000
     9e4:	05830204 	streq	r0, [r3, #516]	; 0x204
     9e8:	04020017 	streq	r0, [r2], #-23	; 0xffffffe9
     9ec:	0a052e02 	beq	14c1fc <__bss_end+0x142614>
     9f0:	02040200 	andeq	r0, r4, #0, 4
     9f4:	000b054a 	andeq	r0, fp, sl, asr #10
     9f8:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
     9fc:	02001705 	andeq	r1, r0, #1310720	; 0x140000
     a00:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
     a04:	0402000d 	streq	r0, [r2], #-13
     a08:	02052e02 	andeq	r2, r5, #2, 28
     a0c:	02040200 	andeq	r0, r4, #0, 4
     a10:	8401052d 	strhi	r0, [r1], #-1325	; 0xfffffad3
     a14:	9f090587 	svcls	0x00090587
     a18:	054b1005 	strbeq	r1, [fp, #-5]
     a1c:	10056613 	andne	r6, r5, r3, lsl r6
     a20:	810505bb 			; <UNDEFINED> instruction: 0x810505bb
     a24:	05310c05 	ldreq	r0, [r1, #-3077]!	; 0xfffff3fb
     a28:	05862f01 	streq	r2, [r6, #3841]	; 0xf01
     a2c:	0505a20a 	streq	sl, [r5, #-522]	; 0xfffffdf6
     a30:	840e0567 	strhi	r0, [lr], #-1383	; 0xfffffa99
     a34:	05670b05 	strbeq	r0, [r7, #-2821]!	; 0xfffff4fb
     a38:	0c05690d 			; <UNDEFINED> instruction: 0x0c05690d
     a3c:	0d059f4b 	stceq	15, cr9, [r5, #-300]	; 0xfffffed4
     a40:	69170567 	ldmdbvs	r7, {r0, r1, r2, r5, r6, r8, sl}
     a44:	05661505 	strbeq	r1, [r6, #-1285]!	; 0xfffffafb
     a48:	3d054a2d 	vstrcc	s8, [r5, #-180]	; 0xffffff4c
     a4c:	01040200 	mrseq	r0, R12_usr
     a50:	003b0566 	eorseq	r0, fp, r6, ror #10
     a54:	66010402 	strvs	r0, [r1], -r2, lsl #8
     a58:	02002d05 	andeq	r2, r0, #320	; 0x140
     a5c:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
     a60:	1c05682b 	stcne	8, cr6, [r5], {43}	; 0x2b
     a64:	8215054a 	andshi	r0, r5, #310378496	; 0x12800000
     a68:	052e1105 	streq	r1, [lr, #-261]!	; 0xfffffefb
     a6c:	05a06710 	streq	r6, [r0, #1808]!	; 0x710
     a70:	16057d05 	strne	r7, [r5], -r5, lsl #26
     a74:	052e0903 	streq	r0, [lr, #-2307]!	; 0xfffff6fd
     a78:	1105d61b 	tstne	r5, fp, lsl r6
     a7c:	0026054a 	eoreq	r0, r6, sl, asr #10
     a80:	ba030402 	blt	c1a90 <__bss_end+0xb7ea8>
     a84:	02000b05 	andeq	r0, r0, #5120	; 0x1400
     a88:	059f0204 	ldreq	r0, [pc, #516]	; c94 <shift+0xc94>
     a8c:	04020005 	streq	r0, [r2], #-5
     a90:	0e058102 	mvfeqs	f0, f2
     a94:	4b1505f5 	blmi	542270 <__bss_end+0x538688>
     a98:	d7660c05 	strble	r0, [r6, -r5, lsl #24]!
     a9c:	059f0505 	ldreq	r0, [pc, #1285]	; fa9 <shift+0xfa9>
     aa0:	1105840f 	tstne	r5, pc, lsl #8
     aa4:	d90c05d7 	stmdble	ip, {r0, r1, r2, r4, r6, r7, r8, sl}
     aa8:	02001805 	andeq	r1, r0, #327680	; 0x50000
     aac:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
     ab0:	10056809 	andne	r6, r5, r9, lsl #16
     ab4:	6612059f 			; <UNDEFINED> instruction: 0x6612059f
     ab8:	05670e05 	strbeq	r0, [r7, #-3589]!	; 0xfffff1fb
     abc:	12059f10 	andne	r9, r5, #16, 30	; 0x40
     ac0:	670e0566 	strvs	r0, [lr, -r6, ror #10]
     ac4:	02001d05 	andeq	r1, r0, #320	; 0x140
     ac8:	05820104 	streq	r0, [r2, #260]	; 0x104
     acc:	12056710 	andne	r6, r5, #16, 14	; 0x400000
     ad0:	691c0566 	ldmdbvs	ip, {r1, r2, r5, r6, r8, sl}
     ad4:	05822205 	streq	r2, [r2, #517]	; 0x205
     ad8:	22052e10 	andcs	r2, r5, #16, 28	; 0x100
     adc:	4a120566 	bmi	48207c <__bss_end+0x478494>
     ae0:	052f1405 	streq	r1, [pc, #-1029]!	; 6e3 <shift+0x6e3>
     ae4:	04020005 	streq	r0, [r2], #-5
     ae8:	d6750302 	ldrbtle	r0, [r5], -r2, lsl #6
     aec:	0e030105 	adfeqs	f0, f3, f5
     af0:	000a029e 	muleq	sl, lr, r2
     af4:	00790101 	rsbseq	r0, r9, r1, lsl #2
     af8:	00030000 	andeq	r0, r3, r0
     afc:	00000046 	andeq	r0, r0, r6, asr #32
     b00:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
     b04:	0101000d 	tsteq	r1, sp
     b08:	00000101 	andeq	r0, r0, r1, lsl #2
     b0c:	00000100 	andeq	r0, r0, r0, lsl #2
     b10:	2f2e2e01 	svccs	0x002e2e01
     b14:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     b18:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     b1c:	2f2e2e2f 	svccs	0x002e2e2f
     b20:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; a70 <shift+0xa70>
     b24:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
     b28:	6f632f63 	svcvs	0x00632f63
     b2c:	6769666e 	strbvs	r6, [r9, -lr, ror #12]!
     b30:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
     b34:	696c0000 	stmdbvs	ip!, {}^	; <UNPREDICTABLE>
     b38:	75663162 	strbvc	r3, [r6, #-354]!	; 0xfffffe9e
     b3c:	2e73636e 	cdpcs	3, 7, cr6, cr3, cr14, {3}
     b40:	00010053 	andeq	r0, r1, r3, asr r0
     b44:	05000000 	streq	r0, [r0, #-0]
     b48:	00946402 	addseq	r6, r4, r2, lsl #8
     b4c:	08cf0300 	stmiaeq	pc, {r8, r9}^	; <UNPREDICTABLE>
     b50:	2f2f3001 	svccs	0x002f3001
     b54:	302f2f2f 	eorcc	r2, pc, pc, lsr #30
     b58:	1401d002 	strne	sp, [r1], #-2
     b5c:	2f2f312f 	svccs	0x002f312f
     b60:	322f4c30 	eorcc	r4, pc, #48, 24	; 0x3000
     b64:	2f661f03 	svccs	0x00661f03
     b68:	2f2f2f2f 	svccs	0x002f2f2f
     b6c:	02022f2f 	andeq	r2, r2, #47, 30	; 0xbc
     b70:	5c010100 	stfpls	f0, [r1], {-0}
     b74:	03000000 	movweq	r0, #0
     b78:	00004600 	andeq	r4, r0, r0, lsl #12
     b7c:	fb010200 	blx	41386 <__bss_end+0x3779e>
     b80:	01000d0e 	tsteq	r0, lr, lsl #26
     b84:	00010101 	andeq	r0, r1, r1, lsl #2
     b88:	00010000 	andeq	r0, r1, r0
     b8c:	2e2e0100 	sufcse	f0, f6, f0
     b90:	2f2e2e2f 	svccs	0x002e2e2f
     b94:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     b98:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     b9c:	2f2e2e2f 	svccs	0x002e2e2f
     ba0:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
     ba4:	632f6363 			; <UNDEFINED> instruction: 0x632f6363
     ba8:	69666e6f 	stmdbvs	r6!, {r0, r1, r2, r3, r5, r6, r9, sl, fp, sp, lr}^
     bac:	72612f67 	rsbvc	r2, r1, #412	; 0x19c
     bb0:	6c00006d 	stcvs	0, cr0, [r0], {109}	; 0x6d
     bb4:	66316269 	ldrtvs	r6, [r1], -r9, ror #4
     bb8:	73636e75 	cmnvc	r3, #1872	; 0x750
     bbc:	0100532e 	tsteq	r0, lr, lsr #6
     bc0:	00000000 	andeq	r0, r0, r0
     bc4:	96700205 	ldrbtls	r0, [r0], -r5, lsl #4
     bc8:	b9030000 	stmdblt	r3, {}	; <UNPREDICTABLE>
     bcc:	0202010b 	andeq	r0, r2, #-1073741822	; 0xc0000002
     bd0:	fb010100 	blx	40fda <__bss_end+0x373f2>
     bd4:	03000000 	movweq	r0, #0
     bd8:	00004700 	andeq	r4, r0, r0, lsl #14
     bdc:	fb010200 	blx	413e6 <__bss_end+0x377fe>
     be0:	01000d0e 	tsteq	r0, lr, lsl #26
     be4:	00010101 	andeq	r0, r1, r1, lsl #2
     be8:	00010000 	andeq	r0, r1, r0
     bec:	2e2e0100 	sufcse	f0, f6, f0
     bf0:	2f2e2e2f 	svccs	0x002e2e2f
     bf4:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     bf8:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     bfc:	2f2e2e2f 	svccs	0x002e2e2f
     c00:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
     c04:	632f6363 			; <UNDEFINED> instruction: 0x632f6363
     c08:	69666e6f 	stmdbvs	r6!, {r0, r1, r2, r3, r5, r6, r9, sl, fp, sp, lr}^
     c0c:	72612f67 	rsbvc	r2, r1, #412	; 0x19c
     c10:	6900006d 	stmdbvs	r0, {r0, r2, r3, r5, r6}
     c14:	37656565 	strbcc	r6, [r5, -r5, ror #10]!
     c18:	732d3435 			; <UNDEFINED> instruction: 0x732d3435
     c1c:	00532e66 	subseq	r2, r3, r6, ror #28
     c20:	00000001 	andeq	r0, r0, r1
     c24:	74020500 	strvc	r0, [r2], #-1280	; 0xfffffb00
     c28:	03000096 	movweq	r0, #150	; 0x96
     c2c:	332f013a 			; <UNDEFINED> instruction: 0x332f013a
     c30:	302e0903 	eorcc	r0, lr, r3, lsl #18
     c34:	2f2f2f2f 	svccs	0x002f2f2f
     c38:	2f302f32 	svccs	0x00302f32
     c3c:	33302f2f 	teqcc	r0, #47, 30	; 0xbc
     c40:	2f2f3130 	svccs	0x002f3130
     c44:	2f2f2f30 	svccs	0x002f2f30
     c48:	322f3230 	eorcc	r3, pc, #48, 4
     c4c:	312f2f32 			; <UNDEFINED> instruction: 0x312f2f32
     c50:	332f332f 			; <UNDEFINED> instruction: 0x332f332f
     c54:	312f2f2f 			; <UNDEFINED> instruction: 0x312f2f2f
     c58:	2f312f2f 	svccs	0x00312f2f
     c5c:	2f302f35 	svccs	0x00302f35
     c60:	2f2f322f 	svccs	0x002f322f
     c64:	19032f30 	stmdbne	r3, {r4, r5, r8, r9, sl, fp, sp}
     c68:	2f2f2f2e 	svccs	0x002f2f2e
     c6c:	342f2f35 	strtcc	r2, [pc], #-3893	; c74 <shift+0xc74>
     c70:	302f3330 	eorcc	r3, pc, r0, lsr r3	; <UNPREDICTABLE>
     c74:	312f2f2f 			; <UNDEFINED> instruction: 0x312f2f2f
     c78:	302f3030 	eorcc	r3, pc, r0, lsr r0	; <UNPREDICTABLE>
     c7c:	2f30312f 	svccs	0x0030312f
     c80:	312f3230 			; <UNDEFINED> instruction: 0x312f3230
     c84:	2f302f2f 	svccs	0x00302f2f
     c88:	2f2f302f 	svccs	0x002f302f
     c8c:	032f2f32 			; <UNDEFINED> instruction: 0x032f2f32
     c90:	2f302e09 	svccs	0x00302e09
     c94:	2f302f2f 	svccs	0x00302f2f
     c98:	0d032f2f 	stceq	15, cr2, [r3, #-188]	; 0xffffff44
     c9c:	30332f2e 	eorscc	r2, r3, lr, lsr #30
     ca0:	31313030 	teqcc	r1, r0, lsr r0
     ca4:	0c032f30 	stceq	15, cr2, [r3], {48}	; 0x30
     ca8:	2f30302e 	svccs	0x0030302e
     cac:	2f303033 	svccs	0x00303033
     cb0:	30312f33 	eorscc	r2, r1, r3, lsr pc
     cb4:	30312f2f 	eorscc	r2, r1, pc, lsr #30
     cb8:	2e19032f 	cdpcs	3, 1, cr0, cr9, cr15, {1}
     cbc:	302f322f 	eorcc	r3, pc, pc, lsr #4
     cc0:	2f2f2f2f 	svccs	0x002f2f2f
     cc4:	2f302f30 	svccs	0x00302f30
     cc8:	302f2f2f 	eorcc	r2, pc, pc, lsr #30
     ccc:	0002022f 	andeq	r0, r2, pc, lsr #4
     cd0:	007a0101 	rsbseq	r0, sl, r1, lsl #2
     cd4:	00030000 	andeq	r0, r3, r0
     cd8:	00000042 	andeq	r0, r0, r2, asr #32
     cdc:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
     ce0:	0101000d 	tsteq	r1, sp
     ce4:	00000101 	andeq	r0, r0, r1, lsl #2
     ce8:	00000100 	andeq	r0, r0, r0, lsl #2
     cec:	2f2e2e01 	svccs	0x002e2e01
     cf0:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     cf4:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     cf8:	2f2e2e2f 	svccs	0x002e2e2f
     cfc:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; c4c <shift+0xc4c>
     d00:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
     d04:	6f632f63 	svcvs	0x00632f63
     d08:	6769666e 	strbvs	r6, [r9, -lr, ror #12]!
     d0c:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
     d10:	70620000 	rsbvc	r0, r2, r0
     d14:	2e696261 	cdpcs	2, 6, cr6, cr9, cr1, {3}
     d18:	00010053 	andeq	r0, r1, r3, asr r0
     d1c:	05000000 	streq	r0, [r0, #-0]
     d20:	0098c402 	addseq	ip, r8, r2, lsl #8
     d24:	01b90300 			; <UNDEFINED> instruction: 0x01b90300
     d28:	4b5a0801 	blmi	1682d34 <__bss_end+0x167914c>
     d2c:	302f2f2f 	eorcc	r2, pc, pc, lsr #30
     d30:	2f326730 	svccs	0x00326730
     d34:	30302f2f 	eorscc	r2, r0, pc, lsr #30
     d38:	2f2f2f67 	svccs	0x002f2f67
     d3c:	302f322f 	eorcc	r3, pc, pc, lsr #4
     d40:	2f2f6730 	svccs	0x002f6730
     d44:	2f302f32 	svccs	0x00302f32
     d48:	022f2f67 	eoreq	r2, pc, #412	; 0x19c
     d4c:	01010002 	tsteq	r1, r2
     d50:	000000a4 	andeq	r0, r0, r4, lsr #1
     d54:	009e0003 	addseq	r0, lr, r3
     d58:	01020000 	mrseq	r0, (UNDEF: 2)
     d5c:	000d0efb 	strdeq	r0, [sp], -fp
     d60:	01010101 	tsteq	r1, r1, lsl #2
     d64:	01000000 	mrseq	r0, (UNDEF: 0)
     d68:	2e010000 	cdpcs	0, 0, cr0, cr1, cr0, {0}
     d6c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     d70:	2f2e2e2f 	svccs	0x002e2e2f
     d74:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     d78:	2f2e2f2e 	svccs	0x002e2f2e
     d7c:	00636367 	rsbeq	r6, r3, r7, ror #6
     d80:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     d84:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     d88:	2f2e2e2f 	svccs	0x002e2e2f
     d8c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     d90:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
     d94:	63636762 	cmnvs	r3, #25690112	; 0x1880000
     d98:	2f2e2e2f 	svccs	0x002e2e2f
     d9c:	2f636367 	svccs	0x00636367
     da0:	666e6f63 	strbtvs	r6, [lr], -r3, ror #30
     da4:	612f6769 			; <UNDEFINED> instruction: 0x612f6769
     da8:	2e006d72 	mcrcs	13, 0, r6, cr0, cr2, {3}
     dac:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     db0:	2f2e2e2f 	svccs	0x002e2e2f
     db4:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     db8:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     dbc:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
     dc0:	00636367 	rsbeq	r6, r3, r7, ror #6
     dc4:	6d726100 	ldfvse	f6, [r2, #-0]
     dc8:	6173692d 	cmnvs	r3, sp, lsr #18
     dcc:	0100682e 	tsteq	r0, lr, lsr #16
     dd0:	72610000 	rsbvc	r0, r1, #0
     dd4:	00682e6d 	rsbeq	r2, r8, sp, ror #28
     dd8:	67000002 	strvs	r0, [r0, -r2]
     ddc:	632d6c62 			; <UNDEFINED> instruction: 0x632d6c62
     de0:	73726f74 	cmnvc	r2, #116, 30	; 0x1d0
     de4:	0300682e 	movweq	r6, #2094	; 0x82e
     de8:	696c0000 	stmdbvs	ip!, {}^	; <UNPREDICTABLE>
     dec:	63636762 	cmnvs	r3, #25690112	; 0x1880000
     df0:	00632e32 	rsbeq	r2, r3, r2, lsr lr
     df4:	00000003 	andeq	r0, r0, r3
     df8:	000000a7 	andeq	r0, r0, r7, lsr #1
     dfc:	00680003 	rsbeq	r0, r8, r3
     e00:	01020000 	mrseq	r0, (UNDEF: 2)
     e04:	000d0efb 	strdeq	r0, [sp], -fp
     e08:	01010101 	tsteq	r1, r1, lsl #2
     e0c:	01000000 	mrseq	r0, (UNDEF: 0)
     e10:	2e010000 	cdpcs	0, 0, cr0, cr1, cr0, {0}
     e14:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     e18:	2f2e2e2f 	svccs	0x002e2e2f
     e1c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     e20:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     e24:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
     e28:	00636367 	rsbeq	r6, r3, r7, ror #6
     e2c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     e30:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     e34:	2f2e2e2f 	svccs	0x002e2e2f
     e38:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     e3c:	6363672f 	cmnvs	r3, #12320768	; 0xbc0000
     e40:	696c0000 	stmdbvs	ip!, {}^	; <UNPREDICTABLE>
     e44:	63636762 	cmnvs	r3, #25690112	; 0x1880000
     e48:	00632e32 	rsbeq	r2, r3, r2, lsr lr
     e4c:	61000001 	tstvs	r0, r1
     e50:	692d6d72 	pushvs	{r1, r4, r5, r6, r8, sl, fp, sp, lr}
     e54:	682e6173 	stmdavs	lr!, {r0, r1, r4, r5, r6, r8, sp, lr}
     e58:	00000200 	andeq	r0, r0, r0, lsl #4
     e5c:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
     e60:	2e326363 	cdpcs	3, 3, cr6, cr2, cr3, {3}
     e64:	00010068 	andeq	r0, r1, r8, rrx
     e68:	01050000 	mrseq	r0, (UNDEF: 5)
     e6c:	98020500 	stmdals	r2, {r8, sl}
     e70:	03000099 	movweq	r0, #153	; 0x99
     e74:	05010bf9 	streq	r0, [r1, #-3065]	; 0xfffff407
     e78:	01051303 	tsteq	r5, r3, lsl #6
     e7c:	06051106 	streq	r1, [r5], -r6, lsl #2
     e80:	0603052f 	streq	r0, [r3], -pc, lsr #10
     e84:	060a0568 	streq	r0, [sl], -r8, ror #10
     e88:	06050501 	streq	r0, [r5], -r1, lsl #10
     e8c:	060e052d 	streq	r0, [lr], -sp, lsr #10
     e90:	2c010501 	cfstr32cs	mvfx0, [r1], {1}
     e94:	2e300e05 	cdpcs	14, 3, cr0, cr0, cr5, {0}
     e98:	052e0c05 	streq	r0, [lr, #-3077]!	; 0xfffff3fb
     e9c:	02024c01 	andeq	r4, r2, #256	; 0x100
     ea0:	b6010100 	strlt	r0, [r1], -r0, lsl #2
     ea4:	03000000 	movweq	r0, #0
     ea8:	00006800 	andeq	r6, r0, r0, lsl #16
     eac:	fb010200 	blx	416b6 <__bss_end+0x37ace>
     eb0:	01000d0e 	tsteq	r0, lr, lsl #26
     eb4:	00010101 	andeq	r0, r1, r1, lsl #2
     eb8:	00010000 	andeq	r0, r1, r0
     ebc:	2e2e0100 	sufcse	f0, f6, f0
     ec0:	2f2e2e2f 	svccs	0x002e2e2f
     ec4:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     ec8:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     ecc:	2f2e2e2f 	svccs	0x002e2e2f
     ed0:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
     ed4:	2e006363 	cdpcs	3, 0, cr6, cr0, cr3, {3}
     ed8:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     edc:	2f2e2e2f 	svccs	0x002e2e2f
     ee0:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     ee4:	2f2e2f2e 	svccs	0x002e2f2e
     ee8:	00636367 	rsbeq	r6, r3, r7, ror #6
     eec:	62696c00 	rsbvs	r6, r9, #0, 24
     ef0:	32636367 	rsbcc	r6, r3, #-1677721599	; 0x9c000001
     ef4:	0100632e 	tsteq	r0, lr, lsr #6
     ef8:	72610000 	rsbvc	r0, r1, #0
     efc:	73692d6d 	cmnvc	r9, #6976	; 0x1b40
     f00:	00682e61 	rsbeq	r2, r8, r1, ror #28
     f04:	6c000002 	stcvs	0, cr0, [r0], {2}
     f08:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
     f0c:	682e3263 	stmdavs	lr!, {r0, r1, r5, r6, r9, ip, sp}
     f10:	00000100 	andeq	r0, r0, r0, lsl #2
     f14:	00010500 	andeq	r0, r1, r0, lsl #10
     f18:	99c80205 	stmibls	r8, {r0, r2, r9}^
     f1c:	b9030000 	stmdblt	r3, {}	; <UNPREDICTABLE>
     f20:	0305010b 	movweq	r0, #20747	; 0x510b
     f24:	06100517 			; <UNDEFINED> instruction: 0x06100517
     f28:	33190501 	tstcc	r9, #4194304	; 0x400000
     f2c:	05332705 	ldreq	r2, [r3, #-1797]!	; 0xfffff8fb
     f30:	2e760310 	mrccs	3, 3, r0, cr6, cr0, {0}
     f34:	33060305 	movwcc	r0, #25349	; 0x6305
     f38:	01061905 	tsteq	r6, r5, lsl #18
     f3c:	052e1005 	streq	r1, [lr, #-5]!
     f40:	15330603 	ldrne	r0, [r3, #-1539]!	; 0xfffff9fd
     f44:	0f061b05 	svceq	0x00061b05
     f48:	2b030105 	blcs	c1364 <__bss_end+0xb777c>
     f4c:	0319052e 	tsteq	r9, #192937984	; 0xb800000
     f50:	01052e55 	tsteq	r5, r5, asr lr
     f54:	4a2e2b03 	bmi	b8bb68 <__bss_end+0xb81f80>
     f58:	01000a02 	tsteq	r0, r2, lsl #20
     f5c:	00016901 	andeq	r6, r1, r1, lsl #18
     f60:	68000300 	stmdavs	r0, {r8, r9}
     f64:	02000000 	andeq	r0, r0, #0
     f68:	0d0efb01 	vstreq	d15, [lr, #-4]
     f6c:	01010100 	mrseq	r0, (UNDEF: 17)
     f70:	00000001 	andeq	r0, r0, r1
     f74:	01000001 	tsteq	r0, r1
     f78:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     f7c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     f80:	2f2e2e2f 	svccs	0x002e2e2f
     f84:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     f88:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
     f8c:	63636762 	cmnvs	r3, #25690112	; 0x1880000
     f90:	2f2e2e00 	svccs	0x002e2e00
     f94:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     f98:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     f9c:	2f2e2e2f 	svccs	0x002e2e2f
     fa0:	63672f2e 	cmnvs	r7, #46, 30	; 0xb8
     fa4:	6c000063 	stcvs	0, cr0, [r0], {99}	; 0x63
     fa8:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
     fac:	632e3263 			; <UNDEFINED> instruction: 0x632e3263
     fb0:	00000100 	andeq	r0, r0, r0, lsl #2
     fb4:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
     fb8:	2e617369 	cdpcs	3, 6, cr7, cr1, cr9, {3}
     fbc:	00020068 	andeq	r0, r2, r8, rrx
     fc0:	62696c00 	rsbvs	r6, r9, #0, 24
     fc4:	32636367 	rsbcc	r6, r3, #-1677721599	; 0x9c000001
     fc8:	0100682e 	tsteq	r0, lr, lsr #16
     fcc:	05000000 	streq	r0, [r0, #-0]
     fd0:	02050001 	andeq	r0, r5, #1
     fd4:	00009a08 	andeq	r9, r0, r8, lsl #20
     fd8:	0107b303 	tsteq	r7, r3, lsl #6
     fdc:	13130305 	tstne	r3, #335544320	; 0x14000000
     fe0:	05010a03 	streq	r0, [r1, #-2563]	; 0xfffff5fd
     fe4:	05010606 	streq	r0, [r1, #-1542]	; 0xfffff9fa
     fe8:	4a740301 	bmi	1d01bf4 <__bss_end+0x1cf800c>
     fec:	052f0b05 	streq	r0, [pc, #-2821]!	; 4ef <shift+0x4ef>
     ff0:	0b052d01 	bleq	14c3fc <__bss_end+0x142814>
     ff4:	0306052f 	movweq	r0, #25903	; 0x652f
     ff8:	07052e0b 	streq	r2, [r5, -fp, lsl #28]
     ffc:	0d053006 	stceq	0, cr3, [r5, #-24]	; 0xffffffe8
    1000:	07050106 	streq	r0, [r5, -r6, lsl #2]
    1004:	0d058306 	stceq	3, cr8, [r5, #-24]	; 0xffffffe8
    1008:	054a0106 	strbeq	r0, [sl, #-262]	; 0xfffffefa
    100c:	054c0607 	strbeq	r0, [ip, #-1543]	; 0xfffff9f9
    1010:	05010609 	streq	r0, [r1, #-1545]	; 0xfffff9f7
    1014:	052f0607 	streq	r0, [pc, #-1543]!	; a15 <shift+0xa15>
    1018:	2e010609 	cfmadd32cs	mvax0, mvfx0, mvfx1, mvfx9
    101c:	a5060705 	strge	r0, [r6, #-1797]	; 0xfffff8fb
    1020:	01060a05 	tsteq	r6, r5, lsl #20
    1024:	030b052e 	movweq	r0, #46382	; 0xb52e
    1028:	0a052e68 	beq	14c9d0 <__bss_end+0x142de8>
    102c:	054a1803 	strbeq	r1, [sl, #-2051]	; 0xfffff7fd
    1030:	05300604 	ldreq	r0, [r0, #-1540]!	; 0xfffff9fc
    1034:	49130606 	ldmdbmi	r3, {r1, r2, r9, sl}
    1038:	0405492f 	streq	r4, [r5], #-2351	; 0xfffff6d1
    103c:	07052f06 	streq	r2, [r5, -r6, lsl #30]
    1040:	060a0515 			; <UNDEFINED> instruction: 0x060a0515
    1044:	06040501 	streq	r0, [r4], -r1, lsl #10
    1048:	0606054c 	streq	r0, [r6], -ip, asr #10
    104c:	04052e01 	streq	r2, [r5], #-3585	; 0xfffff1ff
    1050:	06054e06 	streq	r4, [r5], -r6, lsl #28
    1054:	0b050e06 	bleq	144874 <__bss_end+0x13ac8c>
    1058:	4a100552 	bmi	4025a8 <__bss_end+0x3f89c0>
    105c:	2e4a0505 	cdpcs	5, 4, cr0, cr10, cr5, {0}
    1060:	31060805 	tstcc	r6, r5, lsl #16
    1064:	05130e05 	ldreq	r0, [r3, #-3589]	; 0xfffff1fb
    1068:	2e010606 	cfmadd32cs	mvax0, mvfx0, mvfx1, mvfx6
    106c:	03060405 	movweq	r0, #25605	; 0x6405
    1070:	08052e79 	stmdaeq	r5, {r0, r3, r4, r5, r6, r9, sl, fp, sp}
    1074:	13030514 	movwne	r0, #13588	; 0x3514
    1078:	060b0514 			; <UNDEFINED> instruction: 0x060b0514
    107c:	6905050f 	stmdbvs	r5, {r0, r1, r2, r3, r8, sl}
    1080:	0608052e 	streq	r0, [r8], -lr, lsr #10
    1084:	130e052f 	movwne	r0, #58671	; 0xe52f
    1088:	01060605 	tsteq	r6, r5, lsl #12
    108c:	0604052e 	streq	r0, [r4], -lr, lsr #10
    1090:	06060532 			; <UNDEFINED> instruction: 0x06060532
    1094:	05492f01 	strbeq	r2, [r9, #-3841]	; 0xfffff0ff
    1098:	052f0604 	streq	r0, [pc, #-1540]!	; a9c <shift+0xa9c>
    109c:	05010606 	streq	r0, [r1, #-1542]	; 0xfffff9fa
    10a0:	054b0604 	strbeq	r0, [fp, #-1540]	; 0xfffff9fc
    10a4:	4a01060f 	bmi	428e8 <__bss_end+0x38d00>
    10a8:	2e4a0605 	cdpcs	6, 4, cr0, cr10, cr5, {0}
    10ac:	32060305 	andcc	r0, r6, #335544320	; 0x14000000
    10b0:	01060605 	tsteq	r6, r5, lsl #12
    10b4:	2f060505 	svccs	0x00060505
    10b8:	01060905 	tsteq	r6, r5, lsl #18
    10bc:	2f060305 	svccs	0x00060305
    10c0:	13060105 	movwne	r0, #24837	; 0x6105
    10c4:	0004022e 	andeq	r0, r4, lr, lsr #4
    10c8:	Address 0x00000000000010c8 is out of bounds.


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
      34:	fb0c0000 	blx	30003e <__bss_end+0x2f6456>
      38:	2a000000 	bcs	40 <shift+0x40>
      3c:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
      40:	9c000080 	stcls	0, cr0, [r0], {128}	; 0x80
      44:	5a000000 	bpl	4c <shift+0x4c>
      48:	02000000 	andeq	r0, r0, #0
      4c:	0000012c 	andeq	r0, r0, ip, lsr #2
      50:	31150601 	tstcc	r5, r1, lsl #12
      54:	03000000 	movweq	r0, #0
      58:	15b20704 	ldrne	r0, [r2, #1796]!	; 0x704
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
     128:	000015b2 			; <UNDEFINED> instruction: 0x000015b2
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
     174:	cb104801 	blgt	412180 <__bss_end+0x408598>
     178:	d4000000 	strle	r0, [r0], #-0
     17c:	58000081 	stmdapl	r0, {r0, r7}
     180:	01000000 	mrseq	r0, (UNDEF: 0)
     184:	0000cb9c 	muleq	r0, ip, fp
     188:	01800a00 	orreq	r0, r0, r0, lsl #20
     18c:	4a010000 	bmi	40194 <__bss_end+0x365ac>
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
     1d4:	5b0c0000 	blpl	3001dc <__bss_end+0x2f65f4>
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
     24c:	8b120f01 	blhi	483e58 <__bss_end+0x47a270>
     250:	0f000001 	svceq	0x00000001
     254:	0000019e 	muleq	r0, lr, r1
     258:	03231000 			; <UNDEFINED> instruction: 0x03231000
     25c:	0a010000 	beq	40264 <__bss_end+0x3667c>
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
     2b4:	8b140074 	blhi	50048c <__bss_end+0x4f68a4>
     2b8:	a4000001 	strge	r0, [r0], #-1
     2bc:	38000080 	stmdacc	r0, {r7}
     2c0:	01000000 	mrseq	r0, (UNDEF: 0)
     2c4:	0067139c 	mlseq	r7, ip, r3, r1
     2c8:	9e2f0a01 	vmulls.f32	s0, s30, s2
     2cc:	02000001 	andeq	r0, r0, #1
     2d0:	00007491 	muleq	r0, r1, r4
     2d4:	0000035f 	andeq	r0, r0, pc, asr r3
     2d8:	01e00004 	mvneq	r0, r4
     2dc:	01040000 	mrseq	r0, (UNDEF: 4)
     2e0:	0000025e 	andeq	r0, r0, lr, asr r2
     2e4:	00056504 	andeq	r6, r5, r4, lsl #10
     2e8:	00002a00 	andeq	r2, r0, r0, lsl #20
     2ec:	00822c00 	addeq	r2, r2, r0, lsl #24
     2f0:	00018000 	andeq	r8, r1, r0
     2f4:	0001c200 	andeq	ip, r1, r0, lsl #4
     2f8:	08010200 	stmdaeq	r1, {r9}
     2fc:	000004d0 	ldrdeq	r0, [r0], -r0	; <UNPREDICTABLE>
     300:	00002503 	andeq	r2, r0, r3, lsl #10
     304:	05020200 	streq	r0, [r2, #-512]	; 0xfffffe00
     308:	000004e4 	andeq	r0, r0, r4, ror #9
     30c:	69050404 	stmdbvs	r5, {r2, sl}
     310:	0200746e 	andeq	r7, r0, #1845493760	; 0x6e000000
     314:	04c70801 	strbeq	r0, [r7], #2049	; 0x801
     318:	02020000 	andeq	r0, r2, #0
     31c:	0003f107 	andeq	pc, r3, r7, lsl #2
     320:	05180500 	ldreq	r0, [r8, #-1280]	; 0xfffffb00
     324:	09080000 	stmdbeq	r8, {}	; <UNPREDICTABLE>
     328:	00005e07 	andeq	r5, r0, r7, lsl #28
     32c:	004d0300 	subeq	r0, sp, r0, lsl #6
     330:	04020000 	streq	r0, [r2], #-0
     334:	0015b207 	andseq	fp, r5, r7, lsl #4
     338:	054c0600 	strbeq	r0, [ip, #-1536]	; 0xfffffa00
     33c:	04050000 	streq	r0, [r5], #-0
     340:	00000038 	andeq	r0, r0, r8, lsr r0
     344:	900c7004 	andls	r7, ip, r4
     348:	07000000 	streq	r0, [r0, -r0]
     34c:	000004ae 	andeq	r0, r0, lr, lsr #9
     350:	03e60700 	mvneq	r0, #0, 14
     354:	07010000 	streq	r0, [r1, -r0]
     358:	000004f8 	strdeq	r0, [r0], -r8
     35c:	04040702 	streq	r0, [r4], #-1794	; 0xfffff8fe
     360:	00030000 	andeq	r0, r3, r0
     364:	00047008 	andeq	r7, r4, r8
     368:	14050200 	strne	r0, [r5], #-512	; 0xfffffe00
     36c:	00000059 	andeq	r0, r0, r9, asr r0
     370:	9b280305 	blls	a00f8c <__bss_end+0x9f73a4>
     374:	84080000 	strhi	r0, [r8], #-0
     378:	02000004 	andeq	r0, r0, #4
     37c:	00591406 	subseq	r1, r9, r6, lsl #8
     380:	03050000 	movweq	r0, #20480	; 0x5000
     384:	00009b2c 	andeq	r9, r0, ip, lsr #22
     388:	00045a08 	andeq	r5, r4, r8, lsl #20
     38c:	1a070300 	bne	1c0f94 <__bss_end+0x1b73ac>
     390:	00000059 	andeq	r0, r0, r9, asr r0
     394:	9b300305 	blls	c00fb0 <__bss_end+0xbf73c8>
     398:	6d080000 	stcvs	0, cr0, [r8, #-0]
     39c:	03000003 	movweq	r0, #3
     3a0:	00591a09 	subseq	r1, r9, r9, lsl #20
     3a4:	03050000 	movweq	r0, #20480	; 0x5000
     3a8:	00009b34 	andeq	r9, r0, r4, lsr fp
     3ac:	0004b908 	andeq	fp, r4, r8, lsl #18
     3b0:	1a0b0300 	bne	2c0fb8 <__bss_end+0x2b73d0>
     3b4:	00000059 	andeq	r0, r0, r9, asr r0
     3b8:	9b380305 	blls	e00fd4 <__bss_end+0xdf73ec>
     3bc:	d3080000 	movwle	r0, #32768	; 0x8000
     3c0:	03000003 	movweq	r0, #3
     3c4:	00591a0d 	subseq	r1, r9, sp, lsl #20
     3c8:	03050000 	movweq	r0, #20480	; 0x5000
     3cc:	00009b3c 	andeq	r9, r0, ip, lsr fp
     3d0:	00039208 	andeq	r9, r3, r8, lsl #4
     3d4:	1a0f0300 	bne	3c0fdc <__bss_end+0x3b73f4>
     3d8:	00000059 	andeq	r0, r0, r9, asr r0
     3dc:	9b400305 	blls	1000ff8 <__bss_end+0xff7410>
     3e0:	88060000 	stmdahi	r6, {}	; <UNPREDICTABLE>
     3e4:	0500000f 	streq	r0, [r0, #-15]
     3e8:	00003804 	andeq	r3, r0, r4, lsl #16
     3ec:	0c1b0300 	ldceq	3, cr0, [fp], {-0}
     3f0:	00000133 	andeq	r0, r0, r3, lsr r1
     3f4:	00053007 	andeq	r3, r5, r7
     3f8:	bc070000 	stclt	0, cr0, [r7], {-0}
     3fc:	01000005 	tsteq	r0, r5
     400:	0004a307 	andeq	sl, r4, r7, lsl #6
     404:	09000200 	stmdbeq	r0, {r9}
     408:	00000025 	andeq	r0, r0, r5, lsr #32
     40c:	00000143 	andeq	r0, r0, r3, asr #2
     410:	00005e0a 	andeq	r5, r0, sl, lsl #28
     414:	02000f00 	andeq	r0, r0, #0, 30
     418:	041c0201 	ldreq	r0, [ip], #-513	; 0xfffffdff
     41c:	040b0000 	streq	r0, [fp], #-0
     420:	0000002c 	andeq	r0, r0, ip, lsr #32
     424:	0003ba08 	andeq	fp, r3, r8, lsl #20
     428:	14040500 	strne	r0, [r4], #-1280	; 0xfffffb00
     42c:	00000059 	andeq	r0, r0, r9, asr r0
     430:	9b440305 	blls	110104c <__bss_end+0x10f7464>
     434:	37080000 	strcc	r0, [r8, -r0]
     438:	05000003 	streq	r0, [r0, #-3]
     43c:	00591407 	subseq	r1, r9, r7, lsl #8
     440:	03050000 	movweq	r0, #20480	; 0x5000
     444:	00009b48 	andeq	r9, r0, r8, asr #22
     448:	00037f08 	andeq	r7, r3, r8, lsl #30
     44c:	140a0500 	strne	r0, [sl], #-1280	; 0xfffffb00
     450:	00000059 	andeq	r0, r0, r9, asr r0
     454:	9b4c0305 	blls	1301070 <__bss_end+0x12f7488>
     458:	04020000 	streq	r0, [r2], #-0
     45c:	0015ad07 	andseq	sl, r5, r7, lsl #26
     460:	04d50800 	ldrbeq	r0, [r5], #2048	; 0x800
     464:	0a060000 	beq	18046c <__bss_end+0x176884>
     468:	00005914 	andeq	r5, r0, r4, lsl r9
     46c:	50030500 	andpl	r0, r3, r0, lsl #10
     470:	0600009b 			; <UNDEFINED> instruction: 0x0600009b
     474:	00000433 	andeq	r0, r0, r3, lsr r4
     478:	00380405 	eorseq	r0, r8, r5, lsl #8
     47c:	02070000 	andeq	r0, r7, #0
     480:	0001be0c 	andeq	fp, r1, ip, lsl #28
     484:	053e0700 	ldreq	r0, [lr, #-1792]!	; 0xfffff900
     488:	07010000 	streq	r0, [r1, -r0]
     48c:	0000053a 	andeq	r0, r0, sl, lsr r5
     490:	9d060000 	stcls	0, cr0, [r6, #-0]
     494:	05000005 	streq	r0, [r0, #-5]
     498:	00003804 	andeq	r3, r0, r4, lsl #16
     49c:	0c060700 	stceq	7, cr0, [r6], {-0}
     4a0:	000001dd 	ldrdeq	r0, [r0], -sp
     4a4:	0003ac07 	andeq	sl, r3, r7, lsl #24
     4a8:	b3070000 	movwlt	r0, #28672	; 0x7000
     4ac:	01000003 	tsteq	r0, r3
     4b0:	039c0600 	orrseq	r0, ip, #0, 12
     4b4:	04050000 	streq	r0, [r5], #-0
     4b8:	00000038 	andeq	r0, r0, r8, lsr r0
     4bc:	2a0c0c07 	bcs	3034e0 <__bss_end+0x2f98f8>
     4c0:	0c000002 	stceq	0, cr0, [r0], {2}
     4c4:	0000055d 	andeq	r0, r0, sp, asr r5
     4c8:	490c04b0 	stmdbmi	ip, {r4, r5, r7, sl}
     4cc:	60000003 	andvs	r0, r0, r3
     4d0:	035b0c09 	cmpeq	fp, #2304	; 0x900
     4d4:	12c00000 	sbcne	r0, r0, #0
     4d8:	0005af0c 	andeq	sl, r5, ip, lsl #30
     4dc:	0c258000 	stceq	0, cr8, [r5], #-0
     4e0:	00000421 	andeq	r0, r0, r1, lsr #8
     4e4:	2a0c4b00 	bcs	3130ec <__bss_end+0x309504>
     4e8:	00000004 	andeq	r0, r0, r4
     4ec:	04470c96 	strbeq	r0, [r7], #-3222	; 0xfffff36a
     4f0:	e1000000 	mrs	r0, (UNDEF: 0)
     4f4:	0004500d 	andeq	r5, r4, sp
     4f8:	01c20000 	biceq	r0, r2, r0
     4fc:	900e0000 	andls	r0, lr, r0
     500:	0c000004 	stceq	0, cr0, [r0], {4}
     504:	5f081907 	svcpl	0x00081907
     508:	0f000002 	svceq	0x00000002
     50c:	000005c7 	andeq	r0, r0, r7, asr #11
     510:	be171b07 	vnmlslt.f64	d1, d7, d7
     514:	00000001 	andeq	r0, r0, r1
     518:	0003510f 	andeq	r5, r3, pc, lsl #2
     51c:	151c0700 	ldrne	r0, [ip, #-1792]	; 0xfffff900
     520:	000001dd 	ldrdeq	r0, [r0], -sp
     524:	050f0f04 	streq	r0, [pc, #-3844]	; fffff628 <__bss_end+0xffff5a40>
     528:	1d070000 	stcne	0, cr0, [r7, #-0]
     52c:	00019f19 	andeq	r9, r1, r9, lsl pc
     530:	10000800 	andne	r0, r0, r0, lsl #16
     534:	00001546 	andeq	r1, r0, r6, asr #10
     538:	38051101 	stmdacc	r5, {r0, r8, ip}
     53c:	68000000 	stmdavs	r0, {}	; <UNPREDICTABLE>
     540:	44000082 	strmi	r0, [r0], #-130	; 0xffffff7e
     544:	01000001 	tsteq	r0, r1
     548:	0003259c 	muleq	r3, ip, r5
     54c:	05b71100 	ldreq	r1, [r7, #256]!	; 0x100
     550:	11010000 	mrsne	r0, (UNDEF: 1)
     554:	0000380e 	andeq	r3, r0, lr, lsl #16
     558:	b4910300 	ldrlt	r0, [r1], #768	; 0x300
     55c:	0547117f 	strbeq	r1, [r7, #-383]	; 0xfffffe81
     560:	11010000 	mrsne	r0, (UNDEF: 1)
     564:	0003251b 	andeq	r2, r3, fp, lsl r5
     568:	b0910300 	addslt	r0, r1, r0, lsl #6
     56c:	04ee127f 	strbteq	r1, [lr], #639	; 0x27f
     570:	13010000 	movwne	r0, #4096	; 0x1000
     574:	00004d0b 	andeq	r4, r0, fp, lsl #26
     578:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     57c:	00052912 	andeq	r2, r5, r2, lsl r9
     580:	15150100 	ldrne	r0, [r5, #-256]	; 0xffffff00
     584:	0000022a 	andeq	r0, r0, sl, lsr #4
     588:	13589102 	cmpne	r8, #-2147483648	; 0x80000000
     58c:	00667562 	rsbeq	r7, r6, r2, ror #10
     590:	33071c01 	movwcc	r1, #31745	; 0x7c01
     594:	02000001 	andeq	r0, r0, #1
     598:	21124891 			; <UNDEFINED> instruction: 0x21124891
     59c:	01000005 	tsteq	r0, r5
     5a0:	0133071d 	teqeq	r3, sp, lsl r7
     5a4:	91030000 	mrsls	r0, (UNDEF: 3)
     5a8:	63127fb8 	tstvs	r2, #184, 30	; 0x2e0
     5ac:	01000003 	tsteq	r0, r3
     5b0:	004d0b21 	subeq	r0, sp, r1, lsr #22
     5b4:	91020000 	mrsls	r0, (UNDEF: 2)
     5b8:	05d31270 	ldrbeq	r1, [r3, #624]	; 0x270
     5bc:	23010000 	movwcs	r0, #4096	; 0x1000
     5c0:	00004d0b 	andeq	r4, r0, fp, lsl #26
     5c4:	6c910200 	lfmvs	f0, 4, [r1], {0}
     5c8:	0082f414 	addeq	pc, r2, r4, lsl r4	; <UNPREDICTABLE>
     5cc:	00009c00 	andeq	r9, r0, r0, lsl #24
     5d0:	00761300 	rsbseq	r1, r6, r0, lsl #6
     5d4:	4d0c2a01 	vstrmi	s4, [ip, #-4]
     5d8:	02000000 	andeq	r0, r0, #0
     5dc:	28146891 	ldmdacs	r4, {r0, r4, r7, fp, sp, lr}
     5e0:	68000083 	stmdavs	r0, {r0, r1, r7}
     5e4:	12000000 	andne	r0, r0, #0
     5e8:	00000368 	andeq	r0, r0, r8, ror #6
     5ec:	4d0d2f01 	stcmi	15, cr2, [sp, #-4]
     5f0:	02000000 	andeq	r0, r0, #0
     5f4:	00006491 	muleq	r0, r1, r4
     5f8:	2b040b00 	blcs	103200 <__bss_end+0xf9618>
     5fc:	0b000003 	bleq	610 <shift+0x610>
     600:	00002504 	andeq	r2, r0, r4, lsl #10
     604:	047e1500 	ldrbteq	r1, [lr], #-1280	; 0xfffffb00
     608:	0c010000 	stceq	0, cr0, [r1], {-0}
     60c:	00822c0d 	addeq	r2, r2, sp, lsl #24
     610:	00003c00 	andeq	r3, r0, r0, lsl #24
     614:	119c0100 	orrsne	r0, ip, r0, lsl #2
     618:	000004f3 	strdeq	r0, [r0], -r3
     61c:	4d1c0c01 	ldcmi	12, cr0, [ip, #-4]
     620:	02000000 	andeq	r0, r0, #0
     624:	42117491 	andsmi	r7, r1, #-1862270976	; 0x91000000
     628:	01000003 	tsteq	r0, r3
     62c:	014a2e0c 	cmpeq	sl, ip, lsl #28
     630:	91020000 	mrsls	r0, (UNDEF: 2)
     634:	91000070 	tstls	r0, r0, ror r0
     638:	0400000b 	streq	r0, [r0], #-11
     63c:	00031000 	andeq	r1, r3, r0
     640:	5a010400 	bpl	41648 <__bss_end+0x37a60>
     644:	0400000a 	streq	r0, [r0], #-10
     648:	00000cec 	andeq	r0, r0, ip, ror #25
     64c:	00000bf9 	strdeq	r0, [r0], -r9
     650:	000083ac 	andeq	r8, r0, ip, lsr #7
     654:	0000045c 	andeq	r0, r0, ip, asr r4
     658:	000003c9 	andeq	r0, r0, r9, asr #7
     65c:	d0080102 	andle	r0, r8, r2, lsl #2
     660:	03000004 	movweq	r0, #4
     664:	00000025 	andeq	r0, r0, r5, lsr #32
     668:	e4050202 	str	r0, [r5], #-514	; 0xfffffdfe
     66c:	04000004 	streq	r0, [r0], #-4
     670:	6e690504 	cdpvs	5, 6, cr0, cr9, cr4, {0}
     674:	01020074 	tsteq	r2, r4, ror r0
     678:	0004c708 	andeq	ip, r4, r8, lsl #14
     67c:	07020200 	streq	r0, [r2, -r0, lsl #4]
     680:	000003f1 	strdeq	r0, [r0], -r1
     684:	00051805 	andeq	r1, r5, r5, lsl #16
     688:	07090700 	streq	r0, [r9, -r0, lsl #14]
     68c:	0000005e 	andeq	r0, r0, lr, asr r0
     690:	00004d03 	andeq	r4, r0, r3, lsl #26
     694:	07040200 	streq	r0, [r4, -r0, lsl #4]
     698:	000015b2 			; <UNDEFINED> instruction: 0x000015b2
     69c:	0007e206 	andeq	lr, r7, r6, lsl #4
     6a0:	06020800 	streq	r0, [r2], -r0, lsl #16
     6a4:	00008b08 	andeq	r8, r0, r8, lsl #22
     6a8:	30720700 	rsbscc	r0, r2, r0, lsl #14
     6ac:	0e080200 	cdpeq	2, 0, cr0, cr8, cr0, {0}
     6b0:	0000004d 	andeq	r0, r0, sp, asr #32
     6b4:	31720700 	cmncc	r2, r0, lsl #14
     6b8:	0e090200 	cdpeq	2, 0, cr0, cr9, cr0, {0}
     6bc:	0000004d 	andeq	r0, r0, sp, asr #32
     6c0:	1c080004 	stcne	0, cr0, [r8], {4}
     6c4:	0500000d 	streq	r0, [r0, #-13]
     6c8:	00003804 	andeq	r3, r0, r4, lsl #16
     6cc:	0c0d0200 	sfmeq	f0, 4, [sp], {-0}
     6d0:	000000a9 	andeq	r0, r0, r9, lsr #1
     6d4:	004b4f09 	subeq	r4, fp, r9, lsl #30
     6d8:	07fb0a00 	ldrbeq	r0, [fp, r0, lsl #20]!
     6dc:	00010000 	andeq	r0, r1, r0
     6e0:	0006c808 	andeq	ip, r6, r8, lsl #16
     6e4:	38040500 	stmdacc	r4, {r8, sl}
     6e8:	02000000 	andeq	r0, r0, #0
     6ec:	00ec0c1e 	rsceq	r0, ip, lr, lsl ip
     6f0:	4d0a0000 	stcmi	0, cr0, [sl, #-0]
     6f4:	00000008 	andeq	r0, r0, r8
     6f8:	000fb80a 	andeq	fp, pc, sl, lsl #16
     6fc:	980a0100 	stmdals	sl, {r8}
     700:	0200000f 	andeq	r0, r0, #15
     704:	0009e50a 	andeq	lr, r9, sl, lsl #10
     708:	180a0300 	stmdane	sl, {r8, r9}
     70c:	0400000c 	streq	r0, [r0], #-12
     710:	00080d0a 	andeq	r0, r8, sl, lsl #26
     714:	510a0500 	tstpl	sl, r0, lsl #10
     718:	06000006 	streq	r0, [r0], -r6
     71c:	000f5a0a 	andeq	r5, pc, sl, lsl #20
     720:	08000700 	stmdaeq	r0, {r8, r9, sl}
     724:	00000f18 	andeq	r0, r0, r8, lsl pc
     728:	00380405 	eorseq	r0, r8, r5, lsl #8
     72c:	49020000 	stmdbmi	r2, {}	; <UNPREDICTABLE>
     730:	0001290c 	andeq	r2, r1, ip, lsl #18
     734:	05e60a00 	strbeq	r0, [r6, #2560]!	; 0xa00
     738:	0a000000 	beq	740 <shift+0x740>
     73c:	00000442 	andeq	r0, r0, r2, asr #8
     740:	04a80a01 	strteq	r0, [r8], #2561	; 0xa01
     744:	0a020000 	beq	8074c <__bss_end+0x76b64>
     748:	00000f64 	andeq	r0, r0, r4, ror #30
     74c:	0fc20a03 	svceq	0x00c20a03
     750:	0a040000 	beq	100758 <__bss_end+0xf6b70>
     754:	00000b97 	muleq	r0, r7, fp
     758:	09c40a05 	stmibeq	r4, {r0, r2, r9, fp}^
     75c:	00060000 	andeq	r0, r6, r0
     760:	00054c08 	andeq	r4, r5, r8, lsl #24
     764:	38040500 	stmdacc	r4, {r8, sl}
     768:	02000000 	andeq	r0, r0, #0
     76c:	01540c70 	cmpeq	r4, r0, ror ip
     770:	ae0a0000 	cdpge	0, 0, cr0, cr10, cr0, {0}
     774:	00000004 	andeq	r0, r0, r4
     778:	0003e60a 	andeq	lr, r3, sl, lsl #12
     77c:	f80a0100 			; <UNDEFINED> instruction: 0xf80a0100
     780:	02000004 	andeq	r0, r0, #4
     784:	0004040a 	andeq	r0, r4, sl, lsl #8
     788:	0b000300 	bleq	1390 <shift+0x1390>
     78c:	00000470 	andeq	r0, r0, r0, ror r4
     790:	59140503 	ldmdbpl	r4, {r0, r1, r8, sl}
     794:	05000000 	streq	r0, [r0, #-0]
     798:	009b8403 	addseq	r8, fp, r3, lsl #8
     79c:	04840b00 	streq	r0, [r4], #2816	; 0xb00
     7a0:	06030000 	streq	r0, [r3], -r0
     7a4:	00005914 	andeq	r5, r0, r4, lsl r9
     7a8:	88030500 	stmdahi	r3, {r8, sl}
     7ac:	0b00009b 	bleq	a20 <shift+0xa20>
     7b0:	0000045a 	andeq	r0, r0, sl, asr r4
     7b4:	591a0704 	ldmdbpl	sl, {r2, r8, r9, sl}
     7b8:	05000000 	streq	r0, [r0, #-0]
     7bc:	009b8c03 	addseq	r8, fp, r3, lsl #24
     7c0:	036d0b00 	cmneq	sp, #0, 22
     7c4:	09040000 	stmdbeq	r4, {}	; <UNPREDICTABLE>
     7c8:	0000591a 	andeq	r5, r0, sl, lsl r9
     7cc:	90030500 	andls	r0, r3, r0, lsl #10
     7d0:	0b00009b 	bleq	a44 <shift+0xa44>
     7d4:	000004b9 			; <UNDEFINED> instruction: 0x000004b9
     7d8:	591a0b04 	ldmdbpl	sl, {r2, r8, r9, fp}
     7dc:	05000000 	streq	r0, [r0, #-0]
     7e0:	009b9403 	addseq	r9, fp, r3, lsl #8
     7e4:	03d30b00 	bicseq	r0, r3, #0, 22
     7e8:	0d040000 	stceq	0, cr0, [r4, #-0]
     7ec:	0000591a 	andeq	r5, r0, sl, lsl r9
     7f0:	98030500 	stmdals	r3, {r8, sl}
     7f4:	0b00009b 	bleq	a68 <shift+0xa68>
     7f8:	00000392 	muleq	r0, r2, r3
     7fc:	591a0f04 	ldmdbpl	sl, {r2, r8, r9, sl, fp}
     800:	05000000 	streq	r0, [r0, #-0]
     804:	009b9c03 	addseq	r9, fp, r3, lsl #24
     808:	0f880800 	svceq	0x00880800
     80c:	04050000 	streq	r0, [r5], #-0
     810:	00000038 	andeq	r0, r0, r8, lsr r0
     814:	f70c1b04 			; <UNDEFINED> instruction: 0xf70c1b04
     818:	0a000001 	beq	824 <shift+0x824>
     81c:	00000530 	andeq	r0, r0, r0, lsr r5
     820:	05bc0a00 	ldreq	r0, [ip, #2560]!	; 0xa00
     824:	0a010000 	beq	4082c <__bss_end+0x36c44>
     828:	000004a3 	andeq	r0, r0, r3, lsr #9
     82c:	870c0002 	strhi	r0, [ip, -r2]
     830:	0200000c 	andeq	r0, r0, #12
     834:	041c0201 	ldreq	r0, [ip], #-513	; 0xfffffdff
     838:	040d0000 	streq	r0, [sp], #-0
     83c:	0000002c 	andeq	r0, r0, ip, lsr #32
     840:	01f7040d 	mvnseq	r0, sp, lsl #8
     844:	ba0b0000 	blt	2c084c <__bss_end+0x2b6c64>
     848:	05000003 	streq	r0, [r0, #-3]
     84c:	00591404 	subseq	r1, r9, r4, lsl #8
     850:	03050000 	movweq	r0, #20480	; 0x5000
     854:	00009ba0 	andeq	r9, r0, r0, lsr #23
     858:	0003370b 	andeq	r3, r3, fp, lsl #14
     85c:	14070500 	strne	r0, [r7], #-1280	; 0xfffffb00
     860:	00000059 	andeq	r0, r0, r9, asr r0
     864:	9ba40305 	blls	fe901480 <__bss_end+0xfe8f7898>
     868:	7f0b0000 	svcvc	0x000b0000
     86c:	05000003 	streq	r0, [r0, #-3]
     870:	0059140a 	subseq	r1, r9, sl, lsl #8
     874:	03050000 	movweq	r0, #20480	; 0x5000
     878:	00009ba8 	andeq	r9, r0, r8, lsr #23
     87c:	000a4008 	andeq	r4, sl, r8
     880:	38040500 	stmdacc	r4, {r8, sl}
     884:	05000000 	streq	r0, [r0, #-0]
     888:	027c0c0d 	rsbseq	r0, ip, #3328	; 0xd00
     88c:	4e090000 	cdpmi	0, 0, cr0, cr9, cr0, {0}
     890:	00007765 	andeq	r7, r0, r5, ror #14
     894:	000a370a 	andeq	r3, sl, sl, lsl #14
     898:	2d0a0100 	stfcss	f0, [sl, #-0]
     89c:	0200000d 	andeq	r0, r0, #13
     8a0:	000a090a 	andeq	r0, sl, sl, lsl #18
     8a4:	d70a0300 	strle	r0, [sl, -r0, lsl #6]
     8a8:	04000009 	streq	r0, [r0], #-9
     8ac:	000bf20a 	andeq	pc, fp, sl, lsl #4
     8b0:	06000500 	streq	r0, [r0], -r0, lsl #10
     8b4:	00000800 	andeq	r0, r0, r0, lsl #16
     8b8:	081b0510 	ldmdaeq	fp, {r4, r8, sl}
     8bc:	000002bb 			; <UNDEFINED> instruction: 0x000002bb
     8c0:	00726c07 	rsbseq	r6, r2, r7, lsl #24
     8c4:	bb131d05 	bllt	4c7ce0 <__bss_end+0x4be0f8>
     8c8:	00000002 	andeq	r0, r0, r2
     8cc:	00707307 	rsbseq	r7, r0, r7, lsl #6
     8d0:	bb131e05 	bllt	4c80ec <__bss_end+0x4be504>
     8d4:	04000002 	streq	r0, [r0], #-2
     8d8:	00637007 	rsbeq	r7, r3, r7
     8dc:	bb131f05 	bllt	4c84f8 <__bss_end+0x4be910>
     8e0:	08000002 	stmdaeq	r0, {r1}
     8e4:	00081f0e 	andeq	r1, r8, lr, lsl #30
     8e8:	13200500 	nopne	{0}	; <UNPREDICTABLE>
     8ec:	000002bb 			; <UNDEFINED> instruction: 0x000002bb
     8f0:	0402000c 	streq	r0, [r2], #-12
     8f4:	0015ad07 	andseq	sl, r5, r7, lsl #26
     8f8:	08bc0600 	ldmeq	ip!, {r9, sl}
     8fc:	057c0000 	ldrbeq	r0, [ip, #-0]!
     900:	03790828 	cmneq	r9, #40, 16	; 0x280000
     904:	9a0e0000 	bls	38090c <__bss_end+0x376d24>
     908:	0500000d 	streq	r0, [r0, #-13]
     90c:	027c122a 	rsbseq	r1, ip, #-1610612734	; 0xa0000002
     910:	07000000 	streq	r0, [r0, -r0]
     914:	00646970 	rsbeq	r6, r4, r0, ror r9
     918:	5e122b05 	vnmlspl.f64	d2, d2, d5
     91c:	10000000 	andne	r0, r0, r0
     920:	00071d0e 	andeq	r1, r7, lr, lsl #26
     924:	112c0500 			; <UNDEFINED> instruction: 0x112c0500
     928:	00000245 	andeq	r0, r0, r5, asr #4
     92c:	0a4c0e14 	beq	1304184 <__bss_end+0x12fa59c>
     930:	2d050000 	stccs	0, cr0, [r5, #-0]
     934:	00005e12 	andeq	r5, r0, r2, lsl lr
     938:	380e1800 	stmdacc	lr, {fp, ip}
     93c:	0500000b 	streq	r0, [r0, #-11]
     940:	005e122e 	subseq	r1, lr, lr, lsr #4
     944:	0e1c0000 	cdpeq	0, 1, cr0, cr12, cr0, {0}
     948:	000007ee 	andeq	r0, r0, lr, ror #15
     94c:	790c2f05 	stmdbvc	ip, {r0, r2, r8, r9, sl, fp, sp}
     950:	20000003 	andcs	r0, r0, r3
     954:	000b110e 	andeq	r1, fp, lr, lsl #2
     958:	09300500 	ldmdbeq	r0!, {r8, sl}
     95c:	00000038 	andeq	r0, r0, r8, lsr r0
     960:	0dad0e60 	stceq	14, cr0, [sp, #384]!	; 0x180
     964:	31050000 	mrscc	r0, (UNDEF: 5)
     968:	00004d0e 	andeq	r4, r0, lr, lsl #26
     96c:	5e0e6400 	cfcpyspl	mvf6, mvf14
     970:	05000008 	streq	r0, [r0, #-8]
     974:	004d0e33 	subeq	r0, sp, r3, lsr lr
     978:	0e680000 	cdpeq	0, 6, cr0, cr8, cr0, {0}
     97c:	00000855 	andeq	r0, r0, r5, asr r8
     980:	4d0e3405 	cfstrsmi	mvf3, [lr, #-20]	; 0xffffffec
     984:	6c000000 	stcvs	0, cr0, [r0], {-0}
     988:	0009900e 	andeq	r9, r9, lr
     98c:	0e350500 	cfabs32eq	mvfx0, mvfx5
     990:	0000004d 	andeq	r0, r0, sp, asr #32
     994:	0be30e70 	bleq	ff8c435c <__bss_end+0xff8ba774>
     998:	36050000 	strcc	r0, [r5], -r0
     99c:	00004d0e 	andeq	r4, r0, lr, lsl #26
     9a0:	6a0e7400 	bvs	39d9a8 <__bss_end+0x393dc0>
     9a4:	0500000f 	streq	r0, [r0, #-15]
     9a8:	004d0e37 	subeq	r0, sp, r7, lsr lr
     9ac:	00780000 	rsbseq	r0, r8, r0
     9b0:	0002090f 	andeq	r0, r2, pc, lsl #18
     9b4:	00038900 	andeq	r8, r3, r0, lsl #18
     9b8:	005e1000 	subseq	r1, lr, r0
     9bc:	000f0000 	andeq	r0, pc, r0
     9c0:	0004d50b 	andeq	sp, r4, fp, lsl #10
     9c4:	140a0600 	strne	r0, [sl], #-1536	; 0xfffffa00
     9c8:	00000059 	andeq	r0, r0, r9, asr r0
     9cc:	9bac0305 	blls	feb015e8 <__bss_end+0xfeaf7a00>
     9d0:	11080000 	mrsne	r0, (UNDEF: 8)
     9d4:	0500000a 	streq	r0, [r0, #-10]
     9d8:	00003804 	andeq	r3, r0, r4, lsl #16
     9dc:	0c0d0600 	stceq	6, cr0, [sp], {-0}
     9e0:	000003ba 			; <UNDEFINED> instruction: 0x000003ba
     9e4:	0006dd0a 	andeq	sp, r6, sl, lsl #26
     9e8:	db0a0000 	blle	2809f0 <__bss_end+0x276e08>
     9ec:	01000005 	tsteq	r0, r5
     9f0:	039b0300 	orrseq	r0, fp, #0, 6
     9f4:	73080000 	movwvc	r0, #32768	; 0x8000
     9f8:	0500000b 	streq	r0, [r0, #-11]
     9fc:	00003804 	andeq	r3, r0, r4, lsl #16
     a00:	0c140600 	ldceq	6, cr0, [r4], {-0}
     a04:	000003de 	ldrdeq	r0, [r0], -lr
     a08:	0006250a 	andeq	r2, r6, sl, lsl #10
     a0c:	be0a0000 	cdplt	0, 0, cr0, cr10, cr0, {0}
     a10:	0100000c 	tsteq	r0, ip
     a14:	03bf0300 			; <UNDEFINED> instruction: 0x03bf0300
     a18:	72060000 	andvc	r0, r6, #0
     a1c:	0c00000e 	stceq	0, cr0, [r0], {14}
     a20:	18081b06 	stmdane	r8, {r1, r2, r8, r9, fp, ip}
     a24:	0e000004 	cdpeq	0, 0, cr0, cr0, cr4, {0}
     a28:	00000620 	andeq	r0, r0, r0, lsr #12
     a2c:	18191d06 	ldmdane	r9, {r1, r2, r8, sl, fp, ip}
     a30:	00000004 	andeq	r0, r0, r4
     a34:	00069f0e 	andeq	r9, r6, lr, lsl #30
     a38:	191e0600 	ldmdbne	lr, {r9, sl}
     a3c:	00000418 	andeq	r0, r0, r8, lsl r4
     a40:	0e210e04 	cdpeq	14, 2, cr0, cr1, cr4, {0}
     a44:	1f060000 	svcne	0x00060000
     a48:	00041e13 	andeq	r1, r4, r3, lsl lr
     a4c:	0d000800 	stceq	8, cr0, [r0, #-0]
     a50:	0003e304 	andeq	lr, r3, r4, lsl #6
     a54:	c2040d00 	andgt	r0, r4, #0, 26
     a58:	11000002 	tstne	r0, r2
     a5c:	00000742 	andeq	r0, r0, r2, asr #14
     a60:	07220614 			; <UNDEFINED> instruction: 0x07220614
     a64:	000006e5 	andeq	r0, r0, r5, ror #13
     a68:	0009ff0e 	andeq	pc, r9, lr, lsl #30
     a6c:	12260600 	eorne	r0, r6, #0, 12
     a70:	0000004d 	andeq	r0, r0, sp, asr #32
     a74:	06580e00 	ldrbeq	r0, [r8], -r0, lsl #28
     a78:	29060000 	stmdbcs	r6, {}	; <UNPREDICTABLE>
     a7c:	0004181d 	andeq	r1, r4, sp, lsl r8
     a80:	710e0400 	tstvc	lr, r0, lsl #8
     a84:	0600000d 	streq	r0, [r0], -sp
     a88:	04181d2c 	ldreq	r1, [r8], #-3372	; 0xfffff2d4
     a8c:	12080000 	andne	r0, r8, #0
     a90:	00000f0e 	andeq	r0, r0, lr, lsl #30
     a94:	4f0e2f06 	svcmi	0x000e2f06
     a98:	6c00000e 	stcvs	0, cr0, [r0], {14}
     a9c:	77000004 	strvc	r0, [r0, -r4]
     aa0:	13000004 	movwne	r0, #4
     aa4:	000006ea 	andeq	r0, r0, sl, ror #13
     aa8:	00041814 	andeq	r1, r4, r4, lsl r8
     aac:	37150000 	ldrcc	r0, [r5, -r0]
     ab0:	0600000e 	streq	r0, [r0], -lr
     ab4:	08930e31 	ldmeq	r3, {r0, r4, r5, r9, sl, fp}
     ab8:	01fc0000 	mvnseq	r0, r0
     abc:	048f0000 	streq	r0, [pc], #0	; ac4 <shift+0xac4>
     ac0:	049a0000 	ldreq	r0, [sl], #0
     ac4:	ea130000 	b	4c0acc <__bss_end+0x4b6ee4>
     ac8:	14000006 	strne	r0, [r0], #-6
     acc:	0000041e 	andeq	r0, r0, lr, lsl r4
     ad0:	0e851600 	cdpeq	6, 8, cr1, cr5, cr0, {0}
     ad4:	35060000 	strcc	r0, [r6, #-0]
     ad8:	000dfc1d 	andeq	pc, sp, sp, lsl ip	; <UNPREDICTABLE>
     adc:	00041800 	andeq	r1, r4, r0, lsl #16
     ae0:	04b30200 	ldrteq	r0, [r3], #512	; 0x200
     ae4:	04b90000 	ldrteq	r0, [r9], #0
     ae8:	ea130000 	b	4c0af0 <__bss_end+0x4b6f08>
     aec:	00000006 	andeq	r0, r0, r6
     af0:	0009b716 	andeq	fp, r9, r6, lsl r7
     af4:	1d370600 	ldcne	6, cr0, [r7, #-0]
     af8:	00000c8d 	andeq	r0, r0, sp, lsl #25
     afc:	00000418 	andeq	r0, r0, r8, lsl r4
     b00:	0004d202 	andeq	sp, r4, r2, lsl #4
     b04:	0004d800 	andeq	sp, r4, r0, lsl #16
     b08:	06ea1300 	strbteq	r1, [sl], r0, lsl #6
     b0c:	17000000 	strne	r0, [r0, -r0]
     b10:	00000b54 	andeq	r0, r0, r4, asr fp
     b14:	03313906 	teqeq	r1, #98304	; 0x18000
     b18:	0c000007 	stceq	0, cr0, [r0], {7}
     b1c:	07421602 	strbeq	r1, [r2, -r2, lsl #12]
     b20:	3c060000 	stccc	0, cr0, [r6], {-0}
     b24:	000f9e09 	andeq	r9, pc, r9, lsl #28
     b28:	0006ea00 	andeq	lr, r6, r0, lsl #20
     b2c:	04ff0100 	ldrbteq	r0, [pc], #256	; b34 <shift+0xb34>
     b30:	05050000 	streq	r0, [r5, #-0]
     b34:	ea130000 	b	4c0b3c <__bss_end+0x4b6f54>
     b38:	00000006 	andeq	r0, r0, r6
     b3c:	000e3216 	andeq	r3, lr, r6, lsl r2
     b40:	123d0600 	eorsne	r0, sp, #0, 12
     b44:	00000b1b 	andeq	r0, r0, fp, lsl fp
     b48:	0000004d 	andeq	r0, r0, sp, asr #32
     b4c:	00051e01 	andeq	r1, r5, r1, lsl #28
     b50:	00052900 	andeq	r2, r5, r0, lsl #18
     b54:	06ea1300 	strbteq	r1, [sl], r0, lsl #6
     b58:	4d140000 	ldcmi	0, cr0, [r4, #-0]
     b5c:	00000000 	andeq	r0, r0, r0
     b60:	0006f216 	andeq	pc, r6, r6, lsl r2	; <UNPREDICTABLE>
     b64:	123f0600 	eorsne	r0, pc, #0, 12
     b68:	00000ee3 	andeq	r0, r0, r3, ror #29
     b6c:	0000004d 	andeq	r0, r0, sp, asr #32
     b70:	00054201 	andeq	r4, r5, r1, lsl #4
     b74:	00055700 	andeq	r5, r5, r0, lsl #14
     b78:	06ea1300 	strbteq	r1, [sl], r0, lsl #6
     b7c:	0c140000 	ldceq	0, cr0, [r4], {-0}
     b80:	14000007 	strne	r0, [r0], #-7
     b84:	0000005e 	andeq	r0, r0, lr, asr r0
     b88:	0001fc14 	andeq	pc, r1, r4, lsl ip	; <UNPREDICTABLE>
     b8c:	b2180000 	andslt	r0, r8, #0
     b90:	0600000b 	streq	r0, [r0], -fp
     b94:	08e90e41 	stmiaeq	r9!, {r0, r6, r9, sl, fp}^
     b98:	6c010000 	stcvs	0, cr0, [r1], {-0}
     b9c:	72000005 	andvc	r0, r0, #5
     ba0:	13000005 	movwne	r0, #5
     ba4:	000006ea 	andeq	r0, r0, sl, ror #13
     ba8:	0e461800 	cdpeq	8, 4, cr1, cr6, cr0, {0}
     bac:	43060000 	movwmi	r0, #24576	; 0x6000
     bb0:	000c390e 	andeq	r3, ip, lr, lsl #18
     bb4:	05870100 	streq	r0, [r7, #256]	; 0x100
     bb8:	058d0000 	streq	r0, [sp]
     bbc:	ea130000 	b	4c0bc4 <__bss_end+0x4b6fdc>
     bc0:	00000006 	andeq	r0, r0, r6
     bc4:	00092d16 	andeq	r2, r9, r6, lsl sp
     bc8:	17460600 	strbne	r0, [r6, -r0, lsl #12]
     bcc:	0000066b 	andeq	r0, r0, fp, ror #12
     bd0:	0000041e 	andeq	r0, r0, lr, lsl r4
     bd4:	0005a601 	andeq	sl, r5, r1, lsl #12
     bd8:	0005ac00 	andeq	sl, r5, r0, lsl #24
     bdc:	07121300 	ldreq	r1, [r2, -r0, lsl #6]
     be0:	16000000 	strne	r0, [r0], -r0
     be4:	000006a4 	andeq	r0, r0, r4, lsr #13
     be8:	b9174906 	ldmdblt	r7, {r1, r2, r8, fp, lr}
     bec:	1e00000d 	cdpne	0, 0, cr0, cr0, cr13, {0}
     bf0:	01000004 	tsteq	r0, r4
     bf4:	000005c5 	andeq	r0, r0, r5, asr #11
     bf8:	000005d0 	ldrdeq	r0, [r0], -r0	; <UNPREDICTABLE>
     bfc:	00071213 	andeq	r1, r7, r3, lsl r2
     c00:	004d1400 	subeq	r1, sp, r0, lsl #8
     c04:	18000000 	stmdane	r0, {}	; <UNPREDICTABLE>
     c08:	00000966 	andeq	r0, r0, r6, ror #18
     c0c:	eb0e4c06 	bl	393c2c <__bss_end+0x38a044>
     c10:	01000005 	tsteq	r0, r5
     c14:	000005e5 	andeq	r0, r0, r5, ror #11
     c18:	000005eb 	andeq	r0, r0, fp, ror #11
     c1c:	0006ea13 	andeq	lr, r6, r3, lsl sl
     c20:	37160000 	ldrcc	r0, [r6, -r0]
     c24:	0600000e 	streq	r0, [r0], -lr
     c28:	08250e4e 	stmdaeq	r5!, {r1, r2, r3, r6, r9, sl, fp}
     c2c:	01fc0000 	mvnseq	r0, r0
     c30:	04010000 	streq	r0, [r1], #-0
     c34:	0f000006 	svceq	0x00000006
     c38:	13000006 	movwne	r0, #6
     c3c:	000006ea 	andeq	r0, r0, sl, ror #13
     c40:	00004d14 	andeq	r4, r0, r4, lsl sp
     c44:	52160000 	andspl	r0, r6, #0
     c48:	06000009 	streq	r0, [r0], -r9
     c4c:	0c5a1251 	lfmeq	f1, 2, [sl], {81}	; 0x51
     c50:	004d0000 	subeq	r0, sp, r0
     c54:	28010000 	stmdacs	r1, {}	; <UNPREDICTABLE>
     c58:	33000006 	movwcc	r0, #6
     c5c:	13000006 	movwne	r0, #6
     c60:	000006ea 	andeq	r0, r0, sl, ror #13
     c64:	00020914 	andeq	r0, r2, r4, lsl r9
     c68:	32160000 	andscc	r0, r6, #0
     c6c:	06000006 	streq	r0, [r0], -r6
     c70:	08670e54 	stmdaeq	r7!, {r2, r4, r6, r9, sl, fp}^
     c74:	01fc0000 	mvnseq	r0, r0
     c78:	4c010000 	stcmi	0, cr0, [r1], {-0}
     c7c:	57000006 	strpl	r0, [r0, -r6]
     c80:	13000006 	movwne	r0, #6
     c84:	000006ea 	andeq	r0, r0, sl, ror #13
     c88:	00004d14 	andeq	r4, r0, r4, lsl sp
     c8c:	9e180000 	cdpls	0, 1, cr0, cr8, cr0, {0}
     c90:	06000009 	streq	r0, [r0], -r9
     c94:	0e910e57 	mrceq	14, 4, r0, cr1, cr7, {2}
     c98:	6c010000 	stcvs	0, cr0, [r1], {-0}
     c9c:	8b000006 	blhi	cbc <shift+0xcbc>
     ca0:	13000006 	movwne	r0, #6
     ca4:	000006ea 	andeq	r0, r0, sl, ror #13
     ca8:	0000a914 	andeq	sl, r0, r4, lsl r9
     cac:	004d1400 	subeq	r1, sp, r0, lsl #8
     cb0:	4d140000 	ldcmi	0, cr0, [r4, #-0]
     cb4:	14000000 	strne	r0, [r0], #-0
     cb8:	0000004d 	andeq	r0, r0, sp, asr #32
     cbc:	00071814 	andeq	r1, r7, r4, lsl r8
     cc0:	e6180000 	ldr	r0, [r8], -r0
     cc4:	0600000d 	streq	r0, [r0], -sp
     cc8:	07960e59 			; <UNDEFINED> instruction: 0x07960e59
     ccc:	a0010000 	andge	r0, r1, r0
     cd0:	bf000006 	svclt	0x00000006
     cd4:	13000006 	movwne	r0, #6
     cd8:	000006ea 	andeq	r0, r0, sl, ror #13
     cdc:	0000ec14 	andeq	lr, r0, r4, lsl ip
     ce0:	004d1400 	subeq	r1, sp, r0, lsl #8
     ce4:	4d140000 	ldcmi	0, cr0, [r4, #-0]
     ce8:	14000000 	strne	r0, [r0], #-0
     cec:	0000004d 	andeq	r0, r0, sp, asr #32
     cf0:	00071814 	andeq	r1, r7, r4, lsl r8
     cf4:	2f190000 	svccs	0x00190000
     cf8:	06000007 	streq	r0, [r0], -r7
     cfc:	07530e5c 			; <UNDEFINED> instruction: 0x07530e5c
     d00:	01fc0000 	mvnseq	r0, r0
     d04:	d4010000 	strle	r0, [r1], #-0
     d08:	13000006 	movwne	r0, #6
     d0c:	000006ea 	andeq	r0, r0, sl, ror #13
     d10:	00039b14 	andeq	r9, r3, r4, lsl fp
     d14:	071e1400 	ldreq	r1, [lr, -r0, lsl #8]
     d18:	00000000 	andeq	r0, r0, r0
     d1c:	00042403 	andeq	r2, r4, r3, lsl #8
     d20:	24040d00 	strcs	r0, [r4], #-3328	; 0xfffff300
     d24:	1a000004 	bne	d3c <shift+0xd3c>
     d28:	00000418 	andeq	r0, r0, r8, lsl r4
     d2c:	000006fd 	strdeq	r0, [r0], -sp
     d30:	00000703 	andeq	r0, r0, r3, lsl #14
     d34:	0006ea13 	andeq	lr, r6, r3, lsl sl
     d38:	241b0000 	ldrcs	r0, [fp], #-0
     d3c:	f0000004 			; <UNDEFINED> instruction: 0xf0000004
     d40:	0d000006 	stceq	0, cr0, [r0, #-24]	; 0xffffffe8
     d44:	00003f04 	andeq	r3, r0, r4, lsl #30
     d48:	e5040d00 	str	r0, [r4, #-3328]	; 0xfffff300
     d4c:	1c000006 	stcne	0, cr0, [r0], {6}
     d50:	00006504 	andeq	r6, r0, r4, lsl #10
     d54:	0f041d00 	svceq	0x00041d00
     d58:	0000002c 	andeq	r0, r0, ip, lsr #32
     d5c:	00000730 	andeq	r0, r0, r0, lsr r7
     d60:	00005e10 	andeq	r5, r0, r0, lsl lr
     d64:	03000900 	movweq	r0, #2304	; 0x900
     d68:	00000720 	andeq	r0, r0, r0, lsr #14
     d6c:	0009411e 	andeq	r4, r9, lr, lsl r1
     d70:	0ca50100 	stfeqs	f0, [r5]
     d74:	00000730 	andeq	r0, r0, r0, lsr r7
     d78:	9bb00305 	blls	fec01994 <__bss_end+0xfebf7dac>
     d7c:	d61f0000 	ldrle	r0, [pc], -r0
     d80:	01000005 	tsteq	r0, r5
     d84:	0b670aa7 	bleq	19c3828 <__bss_end+0x19b9c40>
     d88:	004d0000 	subeq	r0, sp, r0
     d8c:	87580000 	ldrbhi	r0, [r8, -r0]
     d90:	00b00000 	adcseq	r0, r0, r0
     d94:	9c010000 	stcls	0, cr0, [r1], {-0}
     d98:	000007a5 	andeq	r0, r0, r5, lsr #15
     d9c:	000f5520 	andeq	r5, pc, r0, lsr #10
     da0:	1ba70100 	blne	fe9c11a8 <__bss_end+0xfe9b75c0>
     da4:	00000203 	andeq	r0, r0, r3, lsl #4
     da8:	7fac9103 	svcvc	0x00ac9103
     dac:	000bda20 	andeq	sp, fp, r0, lsr #20
     db0:	2aa70100 	bcs	fe9c11b8 <__bss_end+0xfe9b75d0>
     db4:	0000004d 	andeq	r0, r0, sp, asr #32
     db8:	7fa89103 	svcvc	0x00a89103
     dbc:	000a311e 	andeq	r3, sl, lr, lsl r1
     dc0:	0aa90100 	beq	fea411c8 <__bss_end+0xfea375e0>
     dc4:	000007a5 	andeq	r0, r0, r5, lsr #15
     dc8:	7fb49103 	svcvc	0x00b49103
     dcc:	00064c1e 	andeq	r4, r6, lr, lsl ip
     dd0:	09ad0100 	stmibeq	sp!, {r8}
     dd4:	00000038 	andeq	r0, r0, r8, lsr r0
     dd8:	00749102 	rsbseq	r9, r4, r2, lsl #2
     ddc:	0000250f 	andeq	r2, r0, pc, lsl #10
     de0:	0007b500 	andeq	fp, r7, r0, lsl #10
     de4:	005e1000 	subseq	r1, lr, r0
     de8:	003f0000 	eorseq	r0, pc, r0
     dec:	000bbf21 	andeq	fp, fp, r1, lsr #30
     df0:	0a990100 	beq	fe6411f8 <__bss_end+0xfe637610>
     df4:	00000ccc 	andeq	r0, r0, ip, asr #25
     df8:	0000004d 	andeq	r0, r0, sp, asr #32
     dfc:	0000871c 	andeq	r8, r0, ip, lsl r7
     e00:	0000003c 	andeq	r0, r0, ip, lsr r0
     e04:	07f29c01 	ldrbeq	r9, [r2, r1, lsl #24]!
     e08:	72220000 	eorvc	r0, r2, #0
     e0c:	01007165 	tsteq	r0, r5, ror #2
     e10:	03de209b 	bicseq	r2, lr, #155	; 0x9b
     e14:	91020000 	mrsls	r0, (UNDEF: 2)
     e18:	0b4e1e74 	bleq	13887f0 <__bss_end+0x137ec08>
     e1c:	9c010000 	stcls	0, cr0, [r1], {-0}
     e20:	00004d0e 	andeq	r4, r0, lr, lsl #26
     e24:	70910200 	addsvc	r0, r1, r0, lsl #4
     e28:	0c272300 	stceq	3, cr2, [r7], #-0
     e2c:	90010000 	andls	r0, r1, r0
     e30:	00070106 	andeq	r0, r7, r6, lsl #2
     e34:	0086e000 	addeq	lr, r6, r0
     e38:	00003c00 	andeq	r3, r0, r0, lsl #24
     e3c:	2b9c0100 	blcs	fe701244 <__bss_end+0xfe6f765c>
     e40:	20000008 	andcs	r0, r0, r8
     e44:	000008d5 	ldrdeq	r0, [r0], -r5
     e48:	4d219001 	stcmi	0, cr9, [r1, #-4]!
     e4c:	02000000 	andeq	r0, r0, #0
     e50:	72226c91 	eorvc	r6, r2, #37120	; 0x9100
     e54:	01007165 	tsteq	r0, r5, ror #2
     e58:	03de2092 	bicseq	r2, lr, #146	; 0x92
     e5c:	91020000 	mrsls	r0, (UNDEF: 2)
     e60:	88210074 	stmdahi	r1!, {r2, r4, r5, r6}
     e64:	0100000b 	tsteq	r0, fp
     e68:	097c0a84 	ldmdbeq	ip!, {r2, r7, r9, fp}^
     e6c:	004d0000 	subeq	r0, sp, r0
     e70:	86a40000 	strthi	r0, [r4], r0
     e74:	003c0000 	eorseq	r0, ip, r0
     e78:	9c010000 	stcls	0, cr0, [r1], {-0}
     e7c:	00000868 	andeq	r0, r0, r8, ror #16
     e80:	71657222 	cmnvc	r5, r2, lsr #4
     e84:	20860100 	addcs	r0, r6, r0, lsl #2
     e88:	000003ba 			; <UNDEFINED> instruction: 0x000003ba
     e8c:	1e749102 	expnes	f1, f2
     e90:	00000645 	andeq	r0, r0, r5, asr #12
     e94:	4d0e8701 	stcmi	7, cr8, [lr, #-4]
     e98:	02000000 	andeq	r0, r0, #0
     e9c:	21007091 	swpcs	r7, r1, [r0]
     ea0:	00000f38 	andeq	r0, r0, r8, lsr pc
     ea4:	0f0a7801 	svceq	0x000a7801
     ea8:	4d000009 	stcmi	0, cr0, [r0, #-36]	; 0xffffffdc
     eac:	68000000 	stmdavs	r0, {}	; <UNPREDICTABLE>
     eb0:	3c000086 	stccc	0, cr0, [r0], {134}	; 0x86
     eb4:	01000000 	mrseq	r0, (UNDEF: 0)
     eb8:	0008a59c 	muleq	r8, ip, r5
     ebc:	65722200 	ldrbvs	r2, [r2, #-512]!	; 0xfffffe00
     ec0:	7a010071 	bvc	4108c <__bss_end+0x374a4>
     ec4:	0003ba20 	andeq	fp, r3, r0, lsr #20
     ec8:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     ecc:	0006451e 	andeq	r4, r6, lr, lsl r5
     ed0:	0e7b0100 	rpweqe	f0, f3, f0
     ed4:	0000004d 	andeq	r0, r0, sp, asr #32
     ed8:	00709102 	rsbseq	r9, r0, r2, lsl #2
     edc:	0009b121 	andeq	fp, r9, r1, lsr #2
     ee0:	066c0100 	strbteq	r0, [ip], -r0, lsl #2
     ee4:	00000cb3 			; <UNDEFINED> instruction: 0x00000cb3
     ee8:	000001fc 	strdeq	r0, [r0], -ip
     eec:	00008614 	andeq	r8, r0, r4, lsl r6
     ef0:	00000054 	andeq	r0, r0, r4, asr r0
     ef4:	08f19c01 	ldmeq	r1!, {r0, sl, fp, ip, pc}^
     ef8:	4e200000 	cdpmi	0, 2, cr0, cr0, cr0, {0}
     efc:	0100000b 	tsteq	r0, fp
     f00:	004d156c 	subeq	r1, sp, ip, ror #10
     f04:	91020000 	mrsls	r0, (UNDEF: 2)
     f08:	0855206c 	ldmdaeq	r5, {r2, r3, r5, r6, sp}^
     f0c:	6c010000 	stcvs	0, cr0, [r1], {-0}
     f10:	00004d25 	andeq	r4, r0, r5, lsr #26
     f14:	68910200 	ldmvs	r1, {r9}
     f18:	000f301e 	andeq	r3, pc, lr, lsl r0	; <UNPREDICTABLE>
     f1c:	0e6e0100 	poweqe	f0, f6, f0
     f20:	0000004d 	andeq	r0, r0, sp, asr #32
     f24:	00749102 	rsbseq	r9, r4, r2, lsl #2
     f28:	00071821 	andeq	r1, r7, r1, lsr #16
     f2c:	125f0100 	subsne	r0, pc, #0, 2
     f30:	00000d3b 	andeq	r0, r0, fp, lsr sp
     f34:	0000008b 	andeq	r0, r0, fp, lsl #1
     f38:	000085c4 	andeq	r8, r0, r4, asr #11
     f3c:	00000050 	andeq	r0, r0, r0, asr r0
     f40:	094c9c01 	stmdbeq	ip, {r0, sl, fp, ip, pc}^
     f44:	f3200000 	vhadd.u32	d0, d0, d0
     f48:	01000004 	tsteq	r0, r4
     f4c:	004d205f 	subeq	r2, sp, pc, asr r0
     f50:	91020000 	mrsls	r0, (UNDEF: 2)
     f54:	0b91206c 	bleq	fe44910c <__bss_end+0xfe43f524>
     f58:	5f010000 	svcpl	0x00010000
     f5c:	00004d2f 	andeq	r4, r0, pc, lsr #26
     f60:	68910200 	ldmvs	r1, {r9}
     f64:	00085520 	andeq	r5, r8, r0, lsr #10
     f68:	3f5f0100 	svccc	0x005f0100
     f6c:	0000004d 	andeq	r0, r0, sp, asr #32
     f70:	1e649102 	lgnnes	f1, f2
     f74:	00000f30 	andeq	r0, r0, r0, lsr pc
     f78:	8b166101 	blhi	599384 <__bss_end+0x58f79c>
     f7c:	02000000 	andeq	r0, r0, #0
     f80:	21007491 			; <UNDEFINED> instruction: 0x21007491
     f84:	00000d84 	andeq	r0, r0, r4, lsl #27
     f88:	230a5301 	movwcs	r5, #41729	; 0xa301
     f8c:	4d000007 	stcmi	0, cr0, [r0, #-28]	; 0xffffffe4
     f90:	80000000 	andhi	r0, r0, r0
     f94:	44000085 	strmi	r0, [r0], #-133	; 0xffffff7b
     f98:	01000000 	mrseq	r0, (UNDEF: 0)
     f9c:	0009989c 	muleq	r9, ip, r8
     fa0:	04f32000 	ldrbteq	r2, [r3], #0
     fa4:	53010000 	movwpl	r0, #4096	; 0x1000
     fa8:	00004d1a 	andeq	r4, r0, sl, lsl sp
     fac:	6c910200 	lfmvs	f0, 4, [r1], {0}
     fb0:	000b9120 	andeq	r9, fp, r0, lsr #2
     fb4:	29530100 	ldmdbcs	r3, {r8}^
     fb8:	0000004d 	andeq	r0, r0, sp, asr #32
     fbc:	1e689102 	lgnnee	f1, f2
     fc0:	00000d6a 	andeq	r0, r0, sl, ror #26
     fc4:	4d0e5501 	cfstr32mi	mvfx5, [lr, #-4]
     fc8:	02000000 	andeq	r0, r0, #0
     fcc:	21007491 			; <UNDEFINED> instruction: 0x21007491
     fd0:	00000d64 	andeq	r0, r0, r4, ror #26
     fd4:	460a4601 	strmi	r4, [sl], -r1, lsl #12
     fd8:	4d00000d 	stcmi	0, cr0, [r0, #-52]	; 0xffffffcc
     fdc:	30000000 	andcc	r0, r0, r0
     fe0:	50000085 	andpl	r0, r0, r5, lsl #1
     fe4:	01000000 	mrseq	r0, (UNDEF: 0)
     fe8:	0009f39c 	muleq	r9, ip, r3
     fec:	04f32000 	ldrbteq	r2, [r3], #0
     ff0:	46010000 	strmi	r0, [r1], -r0
     ff4:	00004d19 	andeq	r4, r0, r9, lsl sp
     ff8:	6c910200 	lfmvs	f0, 4, [r1], {0}
     ffc:	0009eb20 	andeq	lr, r9, r0, lsr #22
    1000:	30460100 	subcc	r0, r6, r0, lsl #2
    1004:	00000129 	andeq	r0, r0, r9, lsr #2
    1008:	20689102 	rsbcs	r9, r8, r2, lsl #2
    100c:	00000b9e 	muleq	r0, lr, fp
    1010:	1e414601 	cdpne	6, 4, cr4, cr1, cr1, {0}
    1014:	02000007 	andeq	r0, r0, #7
    1018:	301e6491 	mulscc	lr, r1, r4
    101c:	0100000f 	tsteq	r0, pc
    1020:	004d0e48 	subeq	r0, sp, r8, asr #28
    1024:	91020000 	mrsls	r0, (UNDEF: 2)
    1028:	1a230074 	bne	8c1200 <__bss_end+0x8b7618>
    102c:	01000006 	tsteq	r0, r6
    1030:	09f50640 	ldmibeq	r5!, {r6, r9, sl}^
    1034:	85040000 	strhi	r0, [r4, #-0]
    1038:	002c0000 	eoreq	r0, ip, r0
    103c:	9c010000 	stcls	0, cr0, [r1], {-0}
    1040:	00000a1d 	andeq	r0, r0, sp, lsl sl
    1044:	0004f320 	andeq	pc, r4, r0, lsr #6
    1048:	15400100 	strbne	r0, [r0, #-256]	; 0xffffff00
    104c:	0000004d 	andeq	r0, r0, sp, asr #32
    1050:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1054:	000b0b21 	andeq	r0, fp, r1, lsr #22
    1058:	0a330100 	beq	cc1460 <__bss_end+0xcb7878>
    105c:	00000ba4 	andeq	r0, r0, r4, lsr #23
    1060:	0000004d 	andeq	r0, r0, sp, asr #32
    1064:	000084b4 			; <UNDEFINED> instruction: 0x000084b4
    1068:	00000050 	andeq	r0, r0, r0, asr r0
    106c:	0a789c01 	beq	1e28078 <__bss_end+0x1e1e490>
    1070:	f3200000 	vhadd.u32	d0, d0, d0
    1074:	01000004 	tsteq	r0, r4
    1078:	004d1933 	subeq	r1, sp, r3, lsr r9
    107c:	91020000 	mrsls	r0, (UNDEF: 2)
    1080:	0da6206c 	stceq	0, cr2, [r6, #432]!	; 0x1b0
    1084:	33010000 	movwcc	r0, #4096	; 0x1000
    1088:	0002032b 	andeq	r0, r2, fp, lsr #6
    108c:	68910200 	ldmvs	r1, {r9}
    1090:	000bde20 	andeq	sp, fp, r0, lsr #28
    1094:	3c330100 	ldfccs	f0, [r3], #-0
    1098:	0000004d 	andeq	r0, r0, sp, asr #32
    109c:	1e649102 	lgnnes	f1, f2
    10a0:	00000d35 	andeq	r0, r0, r5, lsr sp
    10a4:	4d0e3501 	cfstr32mi	mvfx3, [lr, #-4]
    10a8:	02000000 	andeq	r0, r0, #0
    10ac:	21007491 			; <UNDEFINED> instruction: 0x21007491
    10b0:	00000f5f 	andeq	r0, r0, pc, asr pc
    10b4:	260a2501 	strcs	r2, [sl], -r1, lsl #10
    10b8:	4d00000e 	stcmi	0, cr0, [r0, #-56]	; 0xffffffc8
    10bc:	64000000 	strvs	r0, [r0], #-0
    10c0:	50000084 	andpl	r0, r0, r4, lsl #1
    10c4:	01000000 	mrseq	r0, (UNDEF: 0)
    10c8:	000ad39c 	muleq	sl, ip, r3
    10cc:	04f32000 	ldrbteq	r2, [r3], #0
    10d0:	25010000 	strcs	r0, [r1, #-0]
    10d4:	00004d18 	andeq	r4, r0, r8, lsl sp
    10d8:	6c910200 	lfmvs	f0, 4, [r1], {0}
    10dc:	000da620 	andeq	sl, sp, r0, lsr #12
    10e0:	2a250100 	bcs	9414e8 <__bss_end+0x937900>
    10e4:	00000ad9 	ldrdeq	r0, [r0], -r9
    10e8:	20689102 	rsbcs	r9, r8, r2, lsl #2
    10ec:	00000bde 	ldrdeq	r0, [r0], -lr
    10f0:	4d3b2501 	cfldr32mi	mvfx2, [fp, #-4]!
    10f4:	02000000 	andeq	r0, r0, #0
    10f8:	991e6491 	ldmdbls	lr, {r0, r4, r7, sl, sp, lr}
    10fc:	01000006 	tsteq	r0, r6
    1100:	004d0e27 	subeq	r0, sp, r7, lsr #28
    1104:	91020000 	mrsls	r0, (UNDEF: 2)
    1108:	040d0074 	streq	r0, [sp], #-116	; 0xffffff8c
    110c:	00000025 	andeq	r0, r0, r5, lsr #32
    1110:	000ad303 	andeq	sp, sl, r3, lsl #6
    1114:	0b622100 	bleq	188951c <__bss_end+0x187f934>
    1118:	19010000 	stmdbne	r1, {}	; <UNPREDICTABLE>
    111c:	000f7c0a 	andeq	r7, pc, sl, lsl #24
    1120:	00004d00 	andeq	r4, r0, r0, lsl #26
    1124:	00842000 	addeq	r2, r4, r0
    1128:	00004400 	andeq	r4, r0, r0, lsl #8
    112c:	2a9c0100 	bcs	fe701534 <__bss_end+0xfe6f794c>
    1130:	2000000b 	andcs	r0, r0, fp
    1134:	00000f51 	andeq	r0, r0, r1, asr pc
    1138:	031b1901 	tsteq	fp, #16384	; 0x4000
    113c:	02000002 	andeq	r0, r0, #2
    1140:	95206c91 	strls	r6, [r0, #-3217]!	; 0xfffff36f
    1144:	0100000d 	tsteq	r0, sp
    1148:	01d23519 	bicseq	r3, r2, r9, lsl r5
    114c:	91020000 	mrsls	r0, (UNDEF: 2)
    1150:	04f31e68 	ldrbteq	r1, [r3], #3688	; 0xe68
    1154:	1b010000 	blne	4115c <__bss_end+0x37574>
    1158:	00004d0e 	andeq	r4, r0, lr, lsl #26
    115c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1160:	08c92400 	stmiaeq	r9, {sl, sp}^
    1164:	14010000 	strne	r0, [r1], #-0
    1168:	0006b706 	andeq	fp, r6, r6, lsl #14
    116c:	00840400 	addeq	r0, r4, r0, lsl #8
    1170:	00001c00 	andeq	r1, r0, r0, lsl #24
    1174:	239c0100 	orrscs	r0, ip, #0, 2
    1178:	00000d8b 	andeq	r0, r0, fp, lsl #27
    117c:	c9060e01 	stmdbgt	r6, {r0, r9, sl, fp}
    1180:	d8000009 	stmdale	r0, {r0, r3}
    1184:	2c000083 	stccs	0, cr0, [r0], {131}	; 0x83
    1188:	01000000 	mrseq	r0, (UNDEF: 0)
    118c:	000b6a9c 	muleq	fp, ip, sl
    1190:	08162000 	ldmdaeq	r6, {sp}
    1194:	0e010000 	cdpeq	0, 0, cr0, cr1, cr0, {0}
    1198:	00003814 	andeq	r3, r0, r4, lsl r8
    119c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    11a0:	0f752500 	svceq	0x00752500
    11a4:	04010000 	streq	r0, [r1], #-0
    11a8:	000a260a 	andeq	r2, sl, sl, lsl #12
    11ac:	00004d00 	andeq	r4, r0, r0, lsl #26
    11b0:	0083ac00 	addeq	sl, r3, r0, lsl #24
    11b4:	00002c00 	andeq	r2, r0, r0, lsl #24
    11b8:	229c0100 	addscs	r0, ip, #0, 2
    11bc:	00646970 	rsbeq	r6, r4, r0, ror r9
    11c0:	4d0e0601 	stcmi	6, cr0, [lr, #-4]
    11c4:	02000000 	andeq	r0, r0, #0
    11c8:	00007491 	muleq	r0, r1, r4
    11cc:	0000062d 	andeq	r0, r0, sp, lsr #12
    11d0:	05790004 	ldrbeq	r0, [r9, #-4]!
    11d4:	01040000 	mrseq	r0, (UNDEF: 4)
    11d8:	00000a5a 	andeq	r0, r0, sl, asr sl
    11dc:	00106704 	andseq	r6, r0, r4, lsl #14
    11e0:	000bf900 	andeq	pc, fp, r0, lsl #18
    11e4:	00880800 	addeq	r0, r8, r0, lsl #16
    11e8:	000c5c00 	andeq	r5, ip, r0, lsl #24
    11ec:	0005e500 	andeq	lr, r5, r0, lsl #10
    11f0:	00490200 	subeq	r0, r9, r0, lsl #4
    11f4:	c4030000 	strgt	r0, [r3], #-0
    11f8:	01000010 	tsteq	r0, r0, lsl r0
    11fc:	00611005 	rsbeq	r1, r1, r5
    1200:	30110000 	andscc	r0, r1, r0
    1204:	34333231 	ldrtcc	r3, [r3], #-561	; 0xfffffdcf
    1208:	38373635 	ldmdacc	r7!, {r0, r2, r4, r5, r9, sl, ip, sp}
    120c:	43424139 	movtmi	r4, #8505	; 0x2139
    1210:	00464544 	subeq	r4, r6, r4, asr #10
    1214:	03010400 	movweq	r0, #5120	; 0x1400
    1218:	00002501 	andeq	r2, r0, r1, lsl #10
    121c:	00740500 	rsbseq	r0, r4, r0, lsl #10
    1220:	00610000 	rsbeq	r0, r1, r0
    1224:	66060000 	strvs	r0, [r6], -r0
    1228:	10000000 	andne	r0, r0, r0
    122c:	00510700 	subseq	r0, r1, r0, lsl #14
    1230:	04080000 	streq	r0, [r8], #-0
    1234:	0015b207 	andseq	fp, r5, r7, lsl #4
    1238:	08010800 	stmdaeq	r1, {fp}
    123c:	000004d0 	ldrdeq	r0, [r0], -r0	; <UNPREDICTABLE>
    1240:	00006d07 	andeq	r6, r0, r7, lsl #26
    1244:	002a0900 	eoreq	r0, sl, r0, lsl #18
    1248:	d00a0000 	andle	r0, sl, r0
    124c:	01000010 	tsteq	r0, r0, lsl r0
    1250:	116506d2 	ldrdne	r0, [r5, #-98]!	; 0xffffff9e
    1254:	913c0000 	teqls	ip, r0
    1258:	03280000 			; <UNDEFINED> instruction: 0x03280000
    125c:	9c010000 	stcls	0, cr0, [r1], {-0}
    1260:	0000011f 	andeq	r0, r0, pc, lsl r1
    1264:	0100660b 	tsteq	r0, fp, lsl #12
    1268:	011f11d2 			; <UNDEFINED> instruction: 0x011f11d2
    126c:	91030000 	mrsls	r0, (UNDEF: 3)
    1270:	720b7fa4 	andvc	r7, fp, #164, 30	; 0x290
    1274:	19d20100 	ldmibne	r2, {r8}^
    1278:	00000126 	andeq	r0, r0, r6, lsr #2
    127c:	7fa09103 	svcvc	0x00a09103
    1280:	0005cc0c 	andeq	ip, r5, ip, lsl #24
    1284:	13d40100 	bicsne	r0, r4, #0, 2
    1288:	0000012c 	andeq	r0, r0, ip, lsr #2
    128c:	0c589102 	ldfeqp	f1, [r8], {2}
    1290:	00001122 	andeq	r1, r0, r2, lsr #2
    1294:	2c1bd401 	cfldrscs	mvf13, [fp], {1}
    1298:	02000001 	andeq	r0, r0, #1
    129c:	690d5091 	stmdbvs	sp, {r0, r4, r7, ip, lr}
    12a0:	24d40100 	ldrbcs	r0, [r4], #256	; 0x100
    12a4:	0000012c 	andeq	r0, r0, ip, lsr #2
    12a8:	0c489102 	stfeqp	f1, [r8], {2}
    12ac:	000010d5 	ldrdeq	r1, [r0], -r5
    12b0:	2c27d401 	cfstrscs	mvf13, [r7], #-4
    12b4:	02000001 	andeq	r0, r0, #1
    12b8:	b40c4091 	strlt	r4, [ip], #-145	; 0xffffff6f
    12bc:	01000010 	tsteq	r0, r0, lsl r0
    12c0:	012c2fd4 	ldrdeq	r2, [ip, -r4]!
    12c4:	91030000 	mrsls	r0, (UNDEF: 3)
    12c8:	380c7fb8 	stmdacc	ip, {r3, r4, r5, r7, r8, r9, sl, fp, ip, sp, lr}
    12cc:	01000010 	tsteq	r0, r0, lsl r0
    12d0:	012c39d4 	ldrdeq	r3, [ip, -r4]!
    12d4:	91030000 	mrsls	r0, (UNDEF: 3)
    12d8:	e30c7fb0 	movw	r7, #53168	; 0xcfb0
    12dc:	01000010 	tsteq	r0, r0, lsl r0
    12e0:	011f0bd5 			; <UNDEFINED> instruction: 0x011f0bd5
    12e4:	91030000 	mrsls	r0, (UNDEF: 3)
    12e8:	08007fac 	stmdaeq	r0, {r2, r3, r5, r7, r8, r9, sl, fp, ip, sp, lr}
    12ec:	12b90404 	adcsne	r0, r9, #4, 8	; 0x4000000
    12f0:	040e0000 	streq	r0, [lr], #-0
    12f4:	0000006d 	andeq	r0, r0, sp, rrx
    12f8:	43050808 	movwmi	r0, #22536	; 0x5808
    12fc:	0f000002 	svceq	0x00000002
    1300:	0000112a 	andeq	r1, r0, sl, lsr #2
    1304:	ff05c801 			; <UNDEFINED> instruction: 0xff05c801
    1308:	7f00000f 	svcvc	0x0000000f
    130c:	d4000001 	strle	r0, [r0], #-1
    1310:	68000090 	stmdavs	r0, {r4, r7}
    1314:	01000000 	mrseq	r0, (UNDEF: 0)
    1318:	00017f9c 	muleq	r1, ip, pc	; <UNPREDICTABLE>
    131c:	10d51000 	sbcsne	r1, r5, r0
    1320:	c8010000 	stmdagt	r1, {}	; <UNPREDICTABLE>
    1324:	00017f0e 	andeq	r7, r1, lr, lsl #30
    1328:	6c910200 	lfmvs	f0, 4, [r1], {0}
    132c:	000b9110 	andeq	r9, fp, r0, lsl r1
    1330:	1ac80100 	bne	ff201738 <__bss_end+0xff1f7b50>
    1334:	0000017f 	andeq	r0, r0, pc, ror r1
    1338:	0c689102 	stfeqp	f1, [r8], #-8
    133c:	00000125 	andeq	r0, r0, r5, lsr #2
    1340:	7f09ca01 	svcvc	0x0009ca01
    1344:	02000001 	andeq	r0, r0, #1
    1348:	11007491 			; <UNDEFINED> instruction: 0x11007491
    134c:	6e690504 	cdpvs	5, 6, cr0, cr9, cr4, {0}
    1350:	ff120074 			; <UNDEFINED> instruction: 0xff120074
    1354:	01000010 	tsteq	r0, r0, lsl r0
    1358:	0fd906bd 	svceq	0x00d906bd
    135c:	90540000 	subsls	r0, r4, r0
    1360:	00800000 	addeq	r0, r0, r0
    1364:	9c010000 	stcls	0, cr0, [r1], {-0}
    1368:	00000203 	andeq	r0, r0, r3, lsl #4
    136c:	6372730b 	cmnvs	r2, #738197504	; 0x2c000000
    1370:	19bd0100 	ldmibne	sp!, {r8}
    1374:	00000203 	andeq	r0, r0, r3, lsl #4
    1378:	0b649102 	bleq	1925788 <__bss_end+0x191bba0>
    137c:	00747364 	rsbseq	r7, r4, r4, ror #6
    1380:	0a24bd01 	beq	93078c <__bss_end+0x926ba4>
    1384:	02000002 	andeq	r0, r0, #2
    1388:	6e0b6091 	mcrvs	0, 0, r6, cr11, cr1, {4}
    138c:	01006d75 	tsteq	r0, r5, ror sp
    1390:	017f2dbd 	ldrheq	r2, [pc, #-221]	; 12bb <shift+0x12bb>
    1394:	91020000 	mrsls	r0, (UNDEF: 2)
    1398:	10dc0c5c 	sbcsne	r0, ip, ip, asr ip
    139c:	bf010000 	svclt	0x00010000
    13a0:	00020c0e 	andeq	r0, r2, lr, lsl #24
    13a4:	70910200 	addsvc	r0, r1, r0, lsl #4
    13a8:	0010bd0c 	andseq	fp, r0, ip, lsl #26
    13ac:	08c00100 	stmiaeq	r0, {r8}^
    13b0:	00000126 	andeq	r0, r0, r6, lsr #2
    13b4:	136c9102 	cmnne	ip, #-2147483648	; 0x80000000
    13b8:	0000907c 	andeq	r9, r0, ip, ror r0
    13bc:	00000048 	andeq	r0, r0, r8, asr #32
    13c0:	0100690d 	tsteq	r0, sp, lsl #18
    13c4:	017f0bc2 	cmneq	pc, r2, asr #23
    13c8:	91020000 	mrsls	r0, (UNDEF: 2)
    13cc:	0e000074 	mcreq	0, 0, r0, cr0, cr4, {3}
    13d0:	00020904 	andeq	r0, r2, r4, lsl #18
    13d4:	04151400 	ldreq	r1, [r5], #-1024	; 0xfffffc00
    13d8:	0074040e 	rsbseq	r0, r4, lr, lsl #8
    13dc:	f9120000 			; <UNDEFINED> instruction: 0xf9120000
    13e0:	01000010 	tsteq	r0, r0, lsl r0
    13e4:	104406b5 	strhne	r0, [r4], #-101	; 0xffffff9b
    13e8:	8fec0000 	svchi	0x00ec0000
    13ec:	00680000 	rsbeq	r0, r8, r0
    13f0:	9c010000 	stcls	0, cr0, [r1], {-0}
    13f4:	00000271 	andeq	r0, r0, r1, ror r2
    13f8:	00117010 	andseq	r7, r1, r0, lsl r0
    13fc:	12b50100 	adcsne	r0, r5, #0, 2
    1400:	0000020a 	andeq	r0, r0, sl, lsl #4
    1404:	106c9102 	rsbne	r9, ip, r2, lsl #2
    1408:	000005cc 	andeq	r0, r0, ip, asr #11
    140c:	7f1eb501 	svcvc	0x001eb501
    1410:	02000001 	andeq	r0, r0, #1
    1414:	6d0d6891 	stcvs	8, cr6, [sp, #-580]	; 0xfffffdbc
    1418:	01006d65 	tsteq	r0, r5, ror #26
    141c:	012608b7 			; <UNDEFINED> instruction: 0x012608b7
    1420:	91020000 	mrsls	r0, (UNDEF: 2)
    1424:	90081370 	andls	r1, r8, r0, ror r3
    1428:	003c0000 	eorseq	r0, ip, r0
    142c:	690d0000 	stmdbvs	sp, {}	; <UNPREDICTABLE>
    1430:	0bb90100 	bleq	fee41838 <__bss_end+0xfee37c50>
    1434:	0000017f 	andeq	r0, r0, pc, ror r1
    1438:	00749102 	rsbseq	r9, r4, r2, lsl #2
    143c:	10991600 	addsne	r1, r9, r0, lsl #12
    1440:	a4010000 	strge	r0, [r1], #-0
    1444:	00117e07 	andseq	r7, r1, r7, lsl #28
    1448:	00012600 	andeq	r2, r1, r0, lsl #12
    144c:	008f1400 	addeq	r1, pc, r0, lsl #8
    1450:	0000d800 	andeq	sp, r0, r0, lsl #16
    1454:	f09c0100 			; <UNDEFINED> instruction: 0xf09c0100
    1458:	10000002 	andne	r0, r0, r2
    145c:	0000102d 	andeq	r1, r0, sp, lsr #32
    1460:	2615a401 	ldrcs	sl, [r5], -r1, lsl #8
    1464:	02000001 	andeq	r0, r0, #1
    1468:	730b6491 	movwvc	r6, #46225	; 0xb491
    146c:	01006372 	tsteq	r0, r2, ror r3
    1470:	020c27a4 	andeq	r2, ip, #164, 14	; 0x2900000
    1474:	91020000 	mrsls	r0, (UNDEF: 2)
    1478:	0bde1060 	bleq	ff785600 <__bss_end+0xff77ba18>
    147c:	a4010000 	strge	r0, [r1], #-0
    1480:	00017f2f 	andeq	r7, r1, pc, lsr #30
    1484:	5c910200 	lfmpl	f0, 4, [r1], {0}
    1488:	0010a10c 	andseq	sl, r0, ip, lsl #2
    148c:	09a50100 	stmibeq	r5!, {r8}
    1490:	0000017f 	andeq	r0, r0, pc, ror r1
    1494:	0d6c9102 	stfeqp	f1, [ip, #-8]!
    1498:	a701006d 	strge	r0, [r1, -sp, rrx]
    149c:	00017f09 	andeq	r7, r1, r9, lsl #30
    14a0:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    14a4:	008f5813 	addeq	r5, pc, r3, lsl r8	; <UNPREDICTABLE>
    14a8:	00007000 	andeq	r7, r0, r0
    14ac:	00690d00 	rsbeq	r0, r9, r0, lsl #26
    14b0:	7f0dab01 	svcvc	0x000dab01
    14b4:	02000001 	andeq	r0, r0, #1
    14b8:	00007091 	muleq	r0, r1, r0
    14bc:	00103d16 	andseq	r3, r0, r6, lsl sp
    14c0:	079a0100 	ldreq	r0, [sl, r0, lsl #2]
    14c4:	00001058 	andeq	r1, r0, r8, asr r0
    14c8:	00000126 	andeq	r0, r0, r6, lsr #2
    14cc:	00008e68 	andeq	r8, r0, r8, ror #28
    14d0:	000000ac 	andeq	r0, r0, ip, lsr #1
    14d4:	036d9c01 	cmneq	sp, #256	; 0x100
    14d8:	2d100000 	ldccs	0, cr0, [r0, #-0]
    14dc:	01000010 	tsteq	r0, r0, lsl r0
    14e0:	0126149a 			; <UNDEFINED> instruction: 0x0126149a
    14e4:	91020000 	mrsls	r0, (UNDEF: 2)
    14e8:	72730b64 	rsbsvc	r0, r3, #100, 22	; 0x19000
    14ec:	9a010063 	bls	41680 <__bss_end+0x37a98>
    14f0:	00020c26 	andeq	r0, r2, r6, lsr #24
    14f4:	60910200 	addsvs	r0, r1, r0, lsl #4
    14f8:	01006e0d 	tsteq	r0, sp, lsl #28
    14fc:	017f099b 			; <UNDEFINED> instruction: 0x017f099b
    1500:	91020000 	mrsls	r0, (UNDEF: 2)
    1504:	006d0d6c 	rsbeq	r0, sp, ip, ror #26
    1508:	7f099c01 	svcvc	0x00099c01
    150c:	02000001 	andeq	r0, r0, #1
    1510:	a10c7491 			; <UNDEFINED> instruction: 0xa10c7491
    1514:	01000010 	tsteq	r0, r0, lsl r0
    1518:	017f099d 			; <UNDEFINED> instruction: 0x017f099d
    151c:	91020000 	mrsls	r0, (UNDEF: 2)
    1520:	8e9c1368 	cdphi	3, 9, cr1, cr12, cr8, {3}
    1524:	00540000 	subseq	r0, r4, r0
    1528:	690d0000 	stmdbvs	sp, {}	; <UNPREDICTABLE>
    152c:	0d9e0100 	ldfeqs	f0, [lr]
    1530:	0000017f 	andeq	r0, r0, pc, ror r1
    1534:	00709102 	rsbseq	r9, r0, r2, lsl #2
    1538:	11770f00 	cmnne	r7, r0, lsl #30
    153c:	8f010000 	svchi	0x00010000
    1540:	00112f05 	andseq	r2, r1, r5, lsl #30
    1544:	00017f00 	andeq	r7, r1, r0, lsl #30
    1548:	008e1400 	addeq	r1, lr, r0, lsl #8
    154c:	00005400 	andeq	r5, r0, r0, lsl #8
    1550:	a69c0100 	ldrge	r0, [ip], r0, lsl #2
    1554:	0b000003 	bleq	1568 <shift+0x1568>
    1558:	8f010073 	svchi	0x00010073
    155c:	00020c18 	andeq	r0, r2, r8, lsl ip
    1560:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1564:	0100690d 	tsteq	r0, sp, lsl #18
    1568:	017f0691 			; <UNDEFINED> instruction: 0x017f0691
    156c:	91020000 	mrsls	r0, (UNDEF: 2)
    1570:	060f0074 			; <UNDEFINED> instruction: 0x060f0074
    1574:	01000011 	tsteq	r0, r1, lsl r0
    1578:	113c057f 	teqne	ip, pc, ror r5
    157c:	017f0000 	cmneq	pc, r0
    1580:	8d680000 	stclhi	0, cr0, [r8, #-0]
    1584:	00ac0000 	adceq	r0, ip, r0
    1588:	9c010000 	stcls	0, cr0, [r1], {-0}
    158c:	0000040c 	andeq	r0, r0, ip, lsl #8
    1590:	0031730b 	eorseq	r7, r1, fp, lsl #6
    1594:	0c197f01 	ldceq	15, cr7, [r9], {1}
    1598:	02000002 	andeq	r0, r0, #2
    159c:	730b6c91 	movwvc	r6, #48273	; 0xbc91
    15a0:	7f010032 	svcvc	0x00010032
    15a4:	00020c29 	andeq	r0, r2, r9, lsr #24
    15a8:	68910200 	ldmvs	r1, {r9}
    15ac:	6d756e0b 	ldclvs	14, cr6, [r5, #-44]!	; 0xffffffd4
    15b0:	317f0100 	cmncc	pc, r0, lsl #2
    15b4:	0000017f 	andeq	r0, r0, pc, ror r1
    15b8:	0d649102 	stfeqp	f1, [r4, #-8]!
    15bc:	01003175 	tsteq	r0, r5, ror r1
    15c0:	040c1081 	streq	r1, [ip], #-129	; 0xffffff7f
    15c4:	91020000 	mrsls	r0, (UNDEF: 2)
    15c8:	32750d77 	rsbscc	r0, r5, #7616	; 0x1dc0
    15cc:	14810100 	strne	r0, [r1], #256	; 0x100
    15d0:	0000040c 	andeq	r0, r0, ip, lsl #8
    15d4:	00769102 	rsbseq	r9, r6, r2, lsl #2
    15d8:	c7080108 	strgt	r0, [r8, -r8, lsl #2]
    15dc:	0f000004 	svceq	0x00000004
    15e0:	00001050 	andeq	r1, r0, r0, asr r0
    15e4:	c8077301 	stmdagt	r7, {r0, r8, r9, ip, sp, lr}
    15e8:	2600000f 	strcs	r0, [r0], -pc
    15ec:	a8000001 	stmdage	r0, {r0}
    15f0:	c000008c 	andgt	r0, r0, ip, lsl #1
    15f4:	01000000 	mrseq	r0, (UNDEF: 0)
    15f8:	00046c9c 	muleq	r4, ip, ip
    15fc:	102d1000 	eorne	r1, sp, r0
    1600:	73010000 	movwvc	r0, #4096	; 0x1000
    1604:	00012615 	andeq	r2, r1, r5, lsl r6
    1608:	6c910200 	lfmvs	f0, 4, [r1], {0}
    160c:	6372730b 	cmnvs	r2, #738197504	; 0x2c000000
    1610:	27730100 	ldrbcs	r0, [r3, -r0, lsl #2]!
    1614:	0000020c 	andeq	r0, r0, ip, lsl #4
    1618:	0b689102 	bleq	1a25a28 <__bss_end+0x1a1be40>
    161c:	006d756e 	rsbeq	r7, sp, lr, ror #10
    1620:	7f307301 	svcvc	0x00307301
    1624:	02000001 	andeq	r0, r0, #1
    1628:	690d6491 	stmdbvs	sp, {r0, r4, r7, sl, sp, lr}
    162c:	06750100 	ldrbteq	r0, [r5], -r0, lsl #2
    1630:	0000017f 	andeq	r0, r0, pc, ror r1
    1634:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1638:	0010090f 	andseq	r0, r0, pc, lsl #18
    163c:	07570100 	ldrbeq	r0, [r7, -r0, lsl #2]
    1640:	00001022 	andeq	r1, r0, r2, lsr #32
    1644:	0000011f 	andeq	r0, r0, pc, lsl r1
    1648:	00008b4c 	andeq	r8, r0, ip, asr #22
    164c:	0000015c 	andeq	r0, r0, ip, asr r1
    1650:	050d9c01 	streq	r9, [sp, #-3073]	; 0xfffff3ff
    1654:	32100000 	andscc	r0, r0, #0
    1658:	01000010 	tsteq	r0, r0, lsl r0
    165c:	020c1857 	andeq	r1, ip, #5701632	; 0x570000
    1660:	91020000 	mrsls	r0, (UNDEF: 2)
    1664:	111b0c44 	tstne	fp, r4, asr #24
    1668:	58010000 	stmdapl	r1, {}	; <UNPREDICTABLE>
    166c:	00050d0c 	andeq	r0, r5, ip, lsl #26
    1670:	70910200 	addsvc	r0, r1, r0, lsl #4
    1674:	0010a80c 	andseq	sl, r0, ip, lsl #16
    1678:	0c590100 	ldfeqe	f0, [r9], {-0}
    167c:	0000050d 	andeq	r0, r0, sp, lsl #10
    1680:	0d609102 	stfeqp	f1, [r0, #-8]!
    1684:	00706d74 	rsbseq	r6, r0, r4, ror sp
    1688:	0d0c5b01 	vstreq	d5, [ip, #-4]
    168c:	02000005 	andeq	r0, r0, #5
    1690:	520c5891 	andpl	r5, ip, #9502720	; 0x910000
    1694:	0100000a 	tsteq	r0, sl
    1698:	017f095c 	cmneq	pc, ip, asr r9	; <UNPREDICTABLE>
    169c:	91020000 	mrsls	r0, (UNDEF: 2)
    16a0:	15a20c54 	strne	r0, [r2, #3156]!	; 0xc54
    16a4:	5d010000 	stcpl	0, cr0, [r1, #-0]
    16a8:	00017f09 	andeq	r7, r1, r9, lsl #30
    16ac:	6c910200 	lfmvs	f0, 4, [r1], {0}
    16b0:	0010eb0c 	andseq	lr, r0, ip, lsl #22
    16b4:	0a5e0100 	beq	1781abc <__bss_end+0x1777ed4>
    16b8:	00000514 	andeq	r0, r0, r4, lsl r5
    16bc:	136b9102 	cmnne	fp, #-2147483648	; 0x80000000
    16c0:	00008ba8 	andeq	r8, r0, r8, lsr #23
    16c4:	000000d0 	ldrdeq	r0, [r0], -r0	; <UNPREDICTABLE>
    16c8:	6c61760d 	stclvs	6, cr7, [r1], #-52	; 0xffffffcc
    16cc:	10670100 	rsbne	r0, r7, r0, lsl #2
    16d0:	0000050d 	andeq	r0, r0, sp, lsl #10
    16d4:	00489102 	subeq	r9, r8, r2, lsl #2
    16d8:	04080800 	streq	r0, [r8], #-2048	; 0xfffff800
    16dc:	00001562 	andeq	r1, r0, r2, ror #10
    16e0:	1c020108 	stfnes	f0, [r2], {8}
    16e4:	0f000004 	svceq	0x00000004
    16e8:	0000100e 	andeq	r1, r0, lr
    16ec:	e9053c01 	stmdb	r5, {r0, sl, fp, ip, sp}
    16f0:	7f00000f 	svcvc	0x0000000f
    16f4:	4c000001 	stcmi	0, cr0, [r0], {1}
    16f8:	0000008a 	andeq	r0, r0, sl, lsl #1
    16fc:	01000001 	tsteq	r0, r1
    1700:	00057e9c 	muleq	r5, ip, lr
    1704:	10321000 	eorsne	r1, r2, r0
    1708:	3c010000 	stccc	0, cr0, [r1], {-0}
    170c:	00020c21 	andeq	r0, r2, r1, lsr #24
    1710:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1714:	746f640d 	strbtvc	r6, [pc], #-1037	; 171c <shift+0x171c>
    1718:	0a3e0100 	beq	f81b20 <__bss_end+0xf77f38>
    171c:	00000514 	andeq	r0, r0, r4, lsl r5
    1720:	0c779102 	ldfeqp	f1, [r7], #-8
    1724:	0000110e 	andeq	r1, r0, lr, lsl #2
    1728:	140a3f01 	strne	r3, [sl], #-3841	; 0xfffff0ff
    172c:	02000005 	andeq	r0, r0, #5
    1730:	7c137691 	ldcvc	6, cr7, [r3], {145}	; 0x91
    1734:	8c00008a 	stchi	0, cr0, [r0], {138}	; 0x8a
    1738:	0d000000 	stceq	0, cr0, [r0, #-0]
    173c:	41010063 	tstmi	r1, r3, rrx
    1740:	00006d0e 	andeq	r6, r0, lr, lsl #26
    1744:	75910200 	ldrvc	r0, [r1, #512]	; 0x200
    1748:	1d160000 	ldcne	0, cr0, [r6, #-0]
    174c:	01000010 	tsteq	r0, r0, lsl r0
    1750:	114e0526 	cmpne	lr, r6, lsr #10
    1754:	017f0000 	cmneq	pc, r0
    1758:	89800000 	stmibhi	r0, {}	; <UNPREDICTABLE>
    175c:	00cc0000 	sbceq	r0, ip, r0
    1760:	9c010000 	stcls	0, cr0, [r1], {-0}
    1764:	000005bb 			; <UNDEFINED> instruction: 0x000005bb
    1768:	00103210 	andseq	r3, r0, r0, lsl r2
    176c:	16260100 	strtne	r0, [r6], -r0, lsl #2
    1770:	0000020c 	andeq	r0, r0, ip, lsl #4
    1774:	0c6c9102 	stfeqp	f1, [ip], #-8
    1778:	0000111b 	andeq	r1, r0, fp, lsl r1
    177c:	7f062a01 	svcvc	0x00062a01
    1780:	02000001 	andeq	r0, r0, #1
    1784:	17007491 			; <UNDEFINED> instruction: 0x17007491
    1788:	000010af 	andeq	r1, r0, pc, lsr #1
    178c:	59060801 	stmdbpl	r6, {r0, fp}
    1790:	08000011 	stmdaeq	r0, {r0, r4}
    1794:	78000088 	stmdavc	r0, {r3, r7}
    1798:	01000001 	tsteq	r0, r1
    179c:	1032109c 	mlasne	r2, ip, r0, r1
    17a0:	08010000 	stmdaeq	r1, {}	; <UNPREDICTABLE>
    17a4:	00017f0f 	andeq	r7, r1, pc, lsl #30
    17a8:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    17ac:	00111b10 	andseq	r1, r1, r0, lsl fp
    17b0:	1c080100 	stfnes	f0, [r8], {-0}
    17b4:	00000126 	andeq	r0, r0, r6, lsr #2
    17b8:	10609102 	rsbne	r9, r0, r2, lsl #2
    17bc:	000012ac 	andeq	r1, r0, ip, lsr #5
    17c0:	66310801 	ldrtvs	r0, [r1], -r1, lsl #16
    17c4:	02000000 	andeq	r0, r0, #0
    17c8:	690d5c91 	stmdbvs	sp, {r0, r4, r7, sl, fp, ip, lr}
    17cc:	090a0100 	stmdbeq	sl, {r8}
    17d0:	0000017f 	andeq	r0, r0, pc, ror r1
    17d4:	0d749102 	ldfeqp	f1, [r4, #-8]!
    17d8:	0b01006a 	bleq	41988 <__bss_end+0x37da0>
    17dc:	00017f09 	andeq	r7, r1, r9, lsl #30
    17e0:	70910200 	addsvc	r0, r1, r0, lsl #4
    17e4:	00890013 	addeq	r0, r9, r3, lsl r0
    17e8:	00006000 	andeq	r6, r0, r0
    17ec:	00630d00 	rsbeq	r0, r3, r0, lsl #26
    17f0:	6d081f01 	stcvs	15, cr1, [r8, #-4]
    17f4:	02000000 	andeq	r0, r0, #0
    17f8:	00006f91 	muleq	r0, r1, pc	; <UNPREDICTABLE>
    17fc:	00002200 	andeq	r2, r0, r0, lsl #4
    1800:	da000200 	ble	2008 <shift+0x2008>
    1804:	04000006 	streq	r0, [r0], #-6
    1808:	000af601 	andeq	pc, sl, r1, lsl #12
    180c:	00946400 	addseq	r6, r4, r0, lsl #8
    1810:	00967000 	addseq	r7, r6, r0
    1814:	00118f00 	andseq	r8, r1, r0, lsl #30
    1818:	0011bf00 	andseq	fp, r1, r0, lsl #30
    181c:	00122700 	andseq	r2, r2, r0, lsl #14
    1820:	22800100 	addcs	r0, r0, #0, 2
    1824:	02000000 	andeq	r0, r0, #0
    1828:	0006ee00 	andeq	lr, r6, r0, lsl #28
    182c:	73010400 	movwvc	r0, #5120	; 0x1400
    1830:	7000000b 	andvc	r0, r0, fp
    1834:	74000096 	strvc	r0, [r0], #-150	; 0xffffff6a
    1838:	8f000096 	svchi	0x00000096
    183c:	bf000011 	svclt	0x00000011
    1840:	27000011 	smladcs	r0, r1, r0, r0
    1844:	01000012 	tsteq	r0, r2, lsl r0
    1848:	00002280 	andeq	r2, r0, r0, lsl #5
    184c:	02000200 	andeq	r0, r0, #0, 4
    1850:	04000007 	streq	r0, [r0], #-7
    1854:	000bd301 	andeq	sp, fp, r1, lsl #6
    1858:	00967400 	addseq	r7, r6, r0, lsl #8
    185c:	0098c400 	addseq	ip, r8, r0, lsl #8
    1860:	00123300 	andseq	r3, r2, r0, lsl #6
    1864:	0011bf00 	andseq	fp, r1, r0, lsl #30
    1868:	00122700 	andseq	r2, r2, r0, lsl #14
    186c:	22800100 	addcs	r0, r0, #0, 2
    1870:	02000000 	andeq	r0, r0, #0
    1874:	00071600 	andeq	r1, r7, r0, lsl #12
    1878:	d2010400 	andle	r0, r1, #0, 8
    187c:	c400000c 	strgt	r0, [r0], #-12
    1880:	98000098 	stmdals	r0, {r3, r4, r7}
    1884:	64000099 	strvs	r0, [r0], #-153	; 0xffffff67
    1888:	bf000012 	svclt	0x00000012
    188c:	27000011 	smladcs	r0, r1, r0, r0
    1890:	01000012 	tsteq	r0, r2, lsl r0
    1894:	00032a80 	andeq	r2, r3, r0, lsl #21
    1898:	2a000400 	bcs	28a0 <shift+0x28a0>
    189c:	04000007 	streq	r0, [r0], #-7
    18a0:	0013b001 	andseq	fp, r3, r1
    18a4:	15690c00 	strbne	r0, [r9, #-3072]!	; 0xfffff400
    18a8:	11bf0000 			; <UNDEFINED> instruction: 0x11bf0000
    18ac:	0d500000 	ldcleq	0, cr0, [r0, #-0]
    18b0:	04020000 	streq	r0, [r2], #-0
    18b4:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
    18b8:	07040300 	streq	r0, [r4, -r0, lsl #6]
    18bc:	000015b2 			; <UNDEFINED> instruction: 0x000015b2
    18c0:	43050803 	movwmi	r0, #22531	; 0x5803
    18c4:	03000002 	movweq	r0, #2
    18c8:	155d0408 	ldrbne	r0, [sp, #-1032]	; 0xfffffbf8
    18cc:	01030000 	mrseq	r0, (UNDEF: 3)
    18d0:	0004c708 	andeq	ip, r4, r8, lsl #14
    18d4:	06010300 	streq	r0, [r1], -r0, lsl #6
    18d8:	000004c9 	andeq	r0, r0, r9, asr #9
    18dc:	00173504 	andseq	r3, r7, r4, lsl #10
    18e0:	39010700 	stmdbcc	r1, {r8, r9, sl}
    18e4:	01000000 	mrseq	r0, (UNDEF: 0)
    18e8:	01d40617 	bicseq	r0, r4, r7, lsl r6
    18ec:	bf050000 	svclt	0x00050000
    18f0:	00000012 	andeq	r0, r0, r2, lsl r0
    18f4:	0017e405 	andseq	lr, r7, r5, lsl #8
    18f8:	92050100 	andls	r0, r5, #0, 2
    18fc:	02000014 	andeq	r0, r0, #20
    1900:	00155005 	andseq	r5, r5, r5
    1904:	4e050300 	cdpmi	3, 0, cr0, cr5, cr0, {0}
    1908:	04000017 	streq	r0, [r0], #-23	; 0xffffffe9
    190c:	0017f405 	andseq	pc, r7, r5, lsl #8
    1910:	64050500 	strvs	r0, [r5], #-1280	; 0xfffffb00
    1914:	06000017 			; <UNDEFINED> instruction: 0x06000017
    1918:	00159905 	andseq	r9, r5, r5, lsl #18
    191c:	df050700 	svcle	0x00050700
    1920:	08000016 	stmdaeq	r0, {r1, r2, r4}
    1924:	0016ed05 	andseq	lr, r6, r5, lsl #26
    1928:	fb050900 	blx	143d32 <__bss_end+0x13a14a>
    192c:	0a000016 	beq	198c <shift+0x198c>
    1930:	00160205 	andseq	r0, r6, r5, lsl #4
    1934:	f2050b00 	vqdmulh.s<illegal width 8>	d0, d5, d0
    1938:	0c000015 	stceq	0, cr0, [r0], {21}
    193c:	0012db05 	andseq	sp, r2, r5, lsl #22
    1940:	f4050d00 			; <UNDEFINED> instruction: 0xf4050d00
    1944:	0e000012 	mcreq	0, 0, r0, cr0, cr2, {0}
    1948:	0015e305 	andseq	lr, r5, r5, lsl #6
    194c:	a7050f00 	strge	r0, [r5, -r0, lsl #30]
    1950:	10000017 	andne	r0, r0, r7, lsl r0
    1954:	00172405 	andseq	r2, r7, r5, lsl #8
    1958:	98051100 	stmdals	r5, {r8, ip}
    195c:	12000017 	andne	r0, r0, #23
    1960:	0013a105 	andseq	sl, r3, r5, lsl #2
    1964:	1e051300 	cdpne	3, 0, cr1, cr5, cr0, {0}
    1968:	14000013 	strne	r0, [r0], #-19	; 0xffffffed
    196c:	0012e805 	andseq	lr, r2, r5, lsl #16
    1970:	81051500 	tsthi	r5, r0, lsl #10
    1974:	16000016 			; <UNDEFINED> instruction: 0x16000016
    1978:	00135505 	andseq	r5, r3, r5, lsl #10
    197c:	90051700 	andls	r1, r5, r0, lsl #14
    1980:	18000012 	stmdane	r0, {r1, r4}
    1984:	00178a05 	andseq	r8, r7, r5, lsl #20
    1988:	bf051900 	svclt	0x00051900
    198c:	1a000015 	bne	19e8 <shift+0x19e8>
    1990:	00169905 	andseq	r9, r6, r5, lsl #18
    1994:	29051b00 	stmdbcs	r5, {r8, r9, fp, ip}
    1998:	1c000013 	stcne	0, cr0, [r0], {19}
    199c:	00153505 	andseq	r3, r5, r5, lsl #10
    19a0:	84051d00 	strhi	r1, [r5], #-3328	; 0xfffff300
    19a4:	1e000014 	mcrne	0, 0, r0, cr0, cr4, {0}
    19a8:	00171605 	andseq	r1, r7, r5, lsl #12
    19ac:	72051f00 	andvc	r1, r5, #0, 30
    19b0:	20000017 	andcs	r0, r0, r7, lsl r0
    19b4:	0017b305 	andseq	fp, r7, r5, lsl #6
    19b8:	c1052100 	mrsgt	r2, (UNDEF: 21)
    19bc:	22000017 	andcs	r0, r0, #23
    19c0:	0015d605 	andseq	sp, r5, r5, lsl #12
    19c4:	f9052300 			; <UNDEFINED> instruction: 0xf9052300
    19c8:	24000014 	strcs	r0, [r0], #-20	; 0xffffffec
    19cc:	00133805 	andseq	r3, r3, r5, lsl #16
    19d0:	8c052500 	cfstr32hi	mvfx2, [r5], {-0}
    19d4:	26000015 			; <UNDEFINED> instruction: 0x26000015
    19d8:	00149e05 	andseq	r9, r4, r5, lsl #28
    19dc:	41052700 	tstmi	r5, r0, lsl #14
    19e0:	28000017 	stmdacs	r0, {r0, r1, r2, r4}
    19e4:	0014ae05 	andseq	sl, r4, r5, lsl #28
    19e8:	bd052900 	vstrlt.16	s4, [r5, #-0]	; <UNPREDICTABLE>
    19ec:	2a000014 	bcs	1a44 <shift+0x1a44>
    19f0:	0014cc05 	andseq	ip, r4, r5, lsl #24
    19f4:	db052b00 	blle	14c5fc <__bss_end+0x142a14>
    19f8:	2c000014 	stccs	0, cr0, [r0], {20}
    19fc:	00146905 	andseq	r6, r4, r5, lsl #18
    1a00:	ea052d00 	b	14ce08 <__bss_end+0x143220>
    1a04:	2e000014 	mcrcs	0, 0, r0, cr0, cr4, {0}
    1a08:	0016d005 	andseq	sp, r6, r5
    1a0c:	08052f00 	stmdaeq	r5, {r8, r9, sl, fp, sp}
    1a10:	30000015 	andcc	r0, r0, r5, lsl r0
    1a14:	00151705 	andseq	r1, r5, r5, lsl #14
    1a18:	c9053100 	stmdbgt	r5, {r8, ip, sp}
    1a1c:	32000012 	andcc	r0, r0, #18
    1a20:	00162105 	andseq	r2, r6, r5, lsl #2
    1a24:	31053300 	mrscc	r3, SP_abt
    1a28:	34000016 	strcc	r0, [r0], #-22	; 0xffffffea
    1a2c:	00164105 	andseq	r4, r6, r5, lsl #2
    1a30:	57053500 	strpl	r3, [r5, -r0, lsl #10]
    1a34:	36000014 			; <UNDEFINED> instruction: 0x36000014
    1a38:	00165105 	andseq	r5, r6, r5, lsl #2
    1a3c:	61053700 	tstvs	r5, r0, lsl #14
    1a40:	38000016 	stmdacc	r0, {r1, r2, r4}
    1a44:	00167105 	andseq	r7, r6, r5, lsl #2
    1a48:	48053900 	stmdami	r5, {r8, fp, ip, sp}
    1a4c:	3a000013 	bcc	1aa0 <shift+0x1aa0>
    1a50:	00130105 	andseq	r0, r3, r5, lsl #2
    1a54:	26053b00 	strcs	r3, [r5], -r0, lsl #22
    1a58:	3c000015 	stccc	0, cr0, [r0], {21}
    1a5c:	0012a005 	andseq	sl, r2, r5
    1a60:	8c053d00 	stchi	13, cr3, [r5], {-0}
    1a64:	3e000016 	mcrcc	0, 0, r0, cr0, cr6, {0}
    1a68:	13880600 	orrne	r0, r8, #0, 12
    1a6c:	01020000 	mrseq	r0, (UNDEF: 2)
    1a70:	ff08026b 			; <UNDEFINED> instruction: 0xff08026b
    1a74:	07000001 	streq	r0, [r0, -r1]
    1a78:	0000154b 	andeq	r1, r0, fp, asr #10
    1a7c:	14027001 	strne	r7, [r2], #-1
    1a80:	00000047 	andeq	r0, r0, r7, asr #32
    1a84:	14640700 	strbtne	r0, [r4], #-1792	; 0xfffff900
    1a88:	71010000 	mrsvc	r0, (UNDEF: 1)
    1a8c:	00471402 	subeq	r1, r7, r2, lsl #8
    1a90:	00010000 	andeq	r0, r1, r0
    1a94:	0001d408 	andeq	sp, r1, r8, lsl #8
    1a98:	01ff0900 	mvnseq	r0, r0, lsl #18
    1a9c:	02140000 	andseq	r0, r4, #0
    1aa0:	240a0000 	strcs	r0, [sl], #-0
    1aa4:	11000000 	mrsne	r0, (UNDEF: 0)
    1aa8:	02040800 	andeq	r0, r4, #0, 16
    1aac:	0f0b0000 	svceq	0x000b0000
    1ab0:	01000016 	tsteq	r0, r6, lsl r0
    1ab4:	14260274 	strtne	r0, [r6], #-628	; 0xfffffd8c
    1ab8:	24000002 	strcs	r0, [r0], #-2
    1abc:	3d0a3d3a 	stccc	13, cr3, [sl, #-232]	; 0xffffff18
    1ac0:	3d243d0f 	stccc	13, cr3, [r4, #-60]!	; 0xffffffc4
    1ac4:	3d023d32 	stccc	13, cr3, [r2, #-200]	; 0xffffff38
    1ac8:	3d133d05 	ldccc	13, cr3, [r3, #-20]	; 0xffffffec
    1acc:	3d0c3d0d 	stccc	13, cr3, [ip, #-52]	; 0xffffffcc
    1ad0:	3d113d23 	ldccc	13, cr3, [r1, #-140]	; 0xffffff74
    1ad4:	3d013d26 	stccc	13, cr3, [r1, #-152]	; 0xffffff68
    1ad8:	3d083d17 	stccc	13, cr3, [r8, #-92]	; 0xffffffa4
    1adc:	00003d09 	andeq	r3, r0, r9, lsl #26
    1ae0:	f1070203 			; <UNDEFINED> instruction: 0xf1070203
    1ae4:	03000003 	movweq	r0, #3
    1ae8:	04d00801 	ldrbeq	r0, [r0], #2049	; 0x801
    1aec:	0d0c0000 	stceq	0, cr0, [ip, #-0]
    1af0:	00025904 	andeq	r5, r2, r4, lsl #18
    1af4:	17cf0e00 	strbne	r0, [pc, r0, lsl #28]
    1af8:	01070000 	mrseq	r0, (UNDEF: 7)
    1afc:	00000039 	andeq	r0, r0, r9, lsr r0
    1b00:	0604f702 	streq	pc, [r4], -r2, lsl #14
    1b04:	0000029e 	muleq	r0, lr, r2
    1b08:	00136205 	andseq	r6, r3, r5, lsl #4
    1b0c:	6d050000 	stcvs	0, cr0, [r5, #-0]
    1b10:	01000013 	tsteq	r0, r3, lsl r0
    1b14:	00137f05 	andseq	r7, r3, r5, lsl #30
    1b18:	99050200 	stmdbls	r5, {r9}
    1b1c:	03000013 	movweq	r0, #19
    1b20:	00170905 	andseq	r0, r7, r5, lsl #18
    1b24:	78050400 	stmdavc	r5, {sl}
    1b28:	05000014 	streq	r0, [r0, #-20]	; 0xffffffec
    1b2c:	0016c205 	andseq	ip, r6, r5, lsl #4
    1b30:	03000600 	movweq	r0, #1536	; 0x600
    1b34:	04e40502 	strbteq	r0, [r4], #1282	; 0x502
    1b38:	08030000 	stmdaeq	r3, {}	; <UNPREDICTABLE>
    1b3c:	0015a807 	andseq	sl, r5, r7, lsl #16
    1b40:	04040300 	streq	r0, [r4], #-768	; 0xfffffd00
    1b44:	000012b9 			; <UNDEFINED> instruction: 0x000012b9
    1b48:	b1030803 	tstlt	r3, r3, lsl #16
    1b4c:	03000012 	movweq	r0, #18
    1b50:	15620408 	strbne	r0, [r2, #-1032]!	; 0xfffffbf8
    1b54:	10030000 	andne	r0, r3, r0
    1b58:	0016b303 	andseq	fp, r6, r3, lsl #6
    1b5c:	16aa0f00 	strtne	r0, [sl], r0, lsl #30
    1b60:	2a030000 	bcs	c1b68 <__bss_end+0xb7f80>
    1b64:	00025a10 	andeq	r5, r2, r0, lsl sl
    1b68:	02c80900 	sbceq	r0, r8, #0, 18
    1b6c:	02df0000 	sbcseq	r0, pc, #0
    1b70:	00100000 	andseq	r0, r0, r0
    1b74:	00030c11 	andeq	r0, r3, r1, lsl ip
    1b78:	112f0300 			; <UNDEFINED> instruction: 0x112f0300
    1b7c:	000002d4 	ldrdeq	r0, [r0], -r4
    1b80:	00020011 	andeq	r0, r2, r1, lsl r0
    1b84:	11300300 	teqne	r0, r0, lsl #6
    1b88:	000002d4 	ldrdeq	r0, [r0], -r4
    1b8c:	0002c809 	andeq	ip, r2, r9, lsl #16
    1b90:	00030700 	andeq	r0, r3, r0, lsl #14
    1b94:	00240a00 	eoreq	r0, r4, r0, lsl #20
    1b98:	00010000 	andeq	r0, r1, r0
    1b9c:	0002df12 	andeq	sp, r2, r2, lsl pc
    1ba0:	09330400 	ldmdbeq	r3!, {sl}
    1ba4:	0002f70a 	andeq	pc, r2, sl, lsl #14
    1ba8:	d8030500 	stmdale	r3, {r8, sl}
    1bac:	1200009b 	andne	r0, r0, #155	; 0x9b
    1bb0:	000002eb 	andeq	r0, r0, fp, ror #5
    1bb4:	0a093404 	beq	24ebcc <__bss_end+0x244fe4>
    1bb8:	000002f7 	strdeq	r0, [r0], -r7
    1bbc:	9bd80305 	blls	ff6027d8 <__bss_end+0xff5f8bf0>
    1bc0:	06000000 	streq	r0, [r0], -r0
    1bc4:	04000003 	streq	r0, [r0], #-3
    1bc8:	00081700 	andeq	r1, r8, r0, lsl #14
    1bcc:	b0010400 	andlt	r0, r1, r0, lsl #8
    1bd0:	0c000013 	stceq	0, cr0, [r0], {19}
    1bd4:	00001569 	andeq	r1, r0, r9, ror #10
    1bd8:	000011bf 			; <UNDEFINED> instruction: 0x000011bf
    1bdc:	00009998 	muleq	r0, r8, r9
    1be0:	00000030 	andeq	r0, r0, r0, lsr r0
    1be4:	00000df8 	strdeq	r0, [r0], -r8
    1be8:	b9040402 	stmdblt	r4, {r1, sl}
    1bec:	03000012 	movweq	r0, #18
    1bf0:	6e690504 	cdpvs	5, 6, cr0, cr9, cr4, {0}
    1bf4:	04020074 	streq	r0, [r2], #-116	; 0xffffff8c
    1bf8:	0015b207 	andseq	fp, r5, r7, lsl #4
    1bfc:	05080200 	streq	r0, [r8, #-512]	; 0xfffffe00
    1c00:	00000243 	andeq	r0, r0, r3, asr #4
    1c04:	5d040802 	stcpl	8, cr0, [r4, #-8]
    1c08:	02000015 	andeq	r0, r0, #21
    1c0c:	04c70801 	strbeq	r0, [r7], #2049	; 0x801
    1c10:	01020000 	mrseq	r0, (UNDEF: 2)
    1c14:	0004c906 	andeq	ip, r4, r6, lsl #18
    1c18:	17350400 	ldrne	r0, [r5, -r0, lsl #8]!
    1c1c:	01070000 	mrseq	r0, (UNDEF: 7)
    1c20:	00000048 	andeq	r0, r0, r8, asr #32
    1c24:	e3061702 	movw	r1, #26370	; 0x6702
    1c28:	05000001 	streq	r0, [r0, #-1]
    1c2c:	000012bf 			; <UNDEFINED> instruction: 0x000012bf
    1c30:	17e40500 	strbne	r0, [r4, r0, lsl #10]!
    1c34:	05010000 	streq	r0, [r1, #-0]
    1c38:	00001492 	muleq	r0, r2, r4
    1c3c:	15500502 	ldrbne	r0, [r0, #-1282]	; 0xfffffafe
    1c40:	05030000 	streq	r0, [r3, #-0]
    1c44:	0000174e 	andeq	r1, r0, lr, asr #14
    1c48:	17f40504 	ldrbne	r0, [r4, r4, lsl #10]!
    1c4c:	05050000 	streq	r0, [r5, #-0]
    1c50:	00001764 	andeq	r1, r0, r4, ror #14
    1c54:	15990506 	ldrne	r0, [r9, #1286]	; 0x506
    1c58:	05070000 	streq	r0, [r7, #-0]
    1c5c:	000016df 	ldrdeq	r1, [r0], -pc	; <UNPREDICTABLE>
    1c60:	16ed0508 	strbtne	r0, [sp], r8, lsl #10
    1c64:	05090000 	streq	r0, [r9, #-0]
    1c68:	000016fb 	strdeq	r1, [r0], -fp
    1c6c:	1602050a 	strne	r0, [r2], -sl, lsl #10
    1c70:	050b0000 	streq	r0, [fp, #-0]
    1c74:	000015f2 	strdeq	r1, [r0], -r2
    1c78:	12db050c 	sbcsne	r0, fp, #12, 10	; 0x3000000
    1c7c:	050d0000 	streq	r0, [sp, #-0]
    1c80:	000012f4 	strdeq	r1, [r0], -r4
    1c84:	15e3050e 	strbne	r0, [r3, #1294]!	; 0x50e
    1c88:	050f0000 	streq	r0, [pc, #-0]	; 1c90 <shift+0x1c90>
    1c8c:	000017a7 	andeq	r1, r0, r7, lsr #15
    1c90:	17240510 			; <UNDEFINED> instruction: 0x17240510
    1c94:	05110000 	ldreq	r0, [r1, #-0]
    1c98:	00001798 	muleq	r0, r8, r7
    1c9c:	13a10512 			; <UNDEFINED> instruction: 0x13a10512
    1ca0:	05130000 	ldreq	r0, [r3, #-0]
    1ca4:	0000131e 	andeq	r1, r0, lr, lsl r3
    1ca8:	12e80514 	rscne	r0, r8, #20, 10	; 0x5000000
    1cac:	05150000 	ldreq	r0, [r5, #-0]
    1cb0:	00001681 	andeq	r1, r0, r1, lsl #13
    1cb4:	13550516 	cmpne	r5, #92274688	; 0x5800000
    1cb8:	05170000 	ldreq	r0, [r7, #-0]
    1cbc:	00001290 	muleq	r0, r0, r2
    1cc0:	178a0518 	usada8ne	sl, r8, r5, r0
    1cc4:	05190000 	ldreq	r0, [r9, #-0]
    1cc8:	000015bf 			; <UNDEFINED> instruction: 0x000015bf
    1ccc:	1699051a 			; <UNDEFINED> instruction: 0x1699051a
    1cd0:	051b0000 	ldreq	r0, [fp, #-0]
    1cd4:	00001329 	andeq	r1, r0, r9, lsr #6
    1cd8:	1535051c 	ldrne	r0, [r5, #-1308]!	; 0xfffffae4
    1cdc:	051d0000 	ldreq	r0, [sp, #-0]
    1ce0:	00001484 	andeq	r1, r0, r4, lsl #9
    1ce4:	1716051e 			; <UNDEFINED> instruction: 0x1716051e
    1ce8:	051f0000 	ldreq	r0, [pc, #-0]	; 1cf0 <shift+0x1cf0>
    1cec:	00001772 	andeq	r1, r0, r2, ror r7
    1cf0:	17b30520 	ldrne	r0, [r3, r0, lsr #10]!
    1cf4:	05210000 	streq	r0, [r1, #-0]!
    1cf8:	000017c1 	andeq	r1, r0, r1, asr #15
    1cfc:	15d60522 	ldrbne	r0, [r6, #1314]	; 0x522
    1d00:	05230000 	streq	r0, [r3, #-0]!
    1d04:	000014f9 	strdeq	r1, [r0], -r9
    1d08:	13380524 	teqne	r8, #36, 10	; 0x9000000
    1d0c:	05250000 	streq	r0, [r5, #-0]!
    1d10:	0000158c 	andeq	r1, r0, ip, lsl #11
    1d14:	149e0526 	ldrne	r0, [lr], #1318	; 0x526
    1d18:	05270000 	streq	r0, [r7, #-0]!
    1d1c:	00001741 	andeq	r1, r0, r1, asr #14
    1d20:	14ae0528 	strtne	r0, [lr], #1320	; 0x528
    1d24:	05290000 	streq	r0, [r9, #-0]!
    1d28:	000014bd 			; <UNDEFINED> instruction: 0x000014bd
    1d2c:	14cc052a 	strbne	r0, [ip], #1322	; 0x52a
    1d30:	052b0000 	streq	r0, [fp, #-0]!
    1d34:	000014db 	ldrdeq	r1, [r0], -fp
    1d38:	1469052c 	strbtne	r0, [r9], #-1324	; 0xfffffad4
    1d3c:	052d0000 	streq	r0, [sp, #-0]!
    1d40:	000014ea 	andeq	r1, r0, sl, ror #9
    1d44:	16d0052e 	ldrbne	r0, [r0], lr, lsr #10
    1d48:	052f0000 	streq	r0, [pc, #-0]!	; 1d50 <shift+0x1d50>
    1d4c:	00001508 	andeq	r1, r0, r8, lsl #10
    1d50:	15170530 	ldrne	r0, [r7, #-1328]	; 0xfffffad0
    1d54:	05310000 	ldreq	r0, [r1, #-0]!
    1d58:	000012c9 	andeq	r1, r0, r9, asr #5
    1d5c:	16210532 			; <UNDEFINED> instruction: 0x16210532
    1d60:	05330000 	ldreq	r0, [r3, #-0]!
    1d64:	00001631 	andeq	r1, r0, r1, lsr r6
    1d68:	16410534 			; <UNDEFINED> instruction: 0x16410534
    1d6c:	05350000 	ldreq	r0, [r5, #-0]!
    1d70:	00001457 	andeq	r1, r0, r7, asr r4
    1d74:	16510536 			; <UNDEFINED> instruction: 0x16510536
    1d78:	05370000 	ldreq	r0, [r7, #-0]!
    1d7c:	00001661 	andeq	r1, r0, r1, ror #12
    1d80:	16710538 			; <UNDEFINED> instruction: 0x16710538
    1d84:	05390000 	ldreq	r0, [r9, #-0]!
    1d88:	00001348 	andeq	r1, r0, r8, asr #6
    1d8c:	1301053a 	movwne	r0, #5434	; 0x153a
    1d90:	053b0000 	ldreq	r0, [fp, #-0]!
    1d94:	00001526 	andeq	r1, r0, r6, lsr #10
    1d98:	12a0053c 	adcne	r0, r0, #60, 10	; 0xf000000
    1d9c:	053d0000 	ldreq	r0, [sp, #-0]!
    1da0:	0000168c 	andeq	r1, r0, ip, lsl #13
    1da4:	8806003e 	stmdahi	r6, {r1, r2, r3, r4, r5}
    1da8:	02000013 	andeq	r0, r0, #19
    1dac:	08026b02 	stmdaeq	r2, {r1, r8, r9, fp, sp, lr}
    1db0:	0000020e 	andeq	r0, r0, lr, lsl #4
    1db4:	00154b07 	andseq	r4, r5, r7, lsl #22
    1db8:	02700200 	rsbseq	r0, r0, #0, 4
    1dbc:	00005614 	andeq	r5, r0, r4, lsl r6
    1dc0:	64070000 	strvs	r0, [r7], #-0
    1dc4:	02000014 	andeq	r0, r0, #20
    1dc8:	56140271 			; <UNDEFINED> instruction: 0x56140271
    1dcc:	01000000 	mrseq	r0, (UNDEF: 0)
    1dd0:	01e30800 	mvneq	r0, r0, lsl #16
    1dd4:	0e090000 	cdpeq	0, 0, cr0, cr9, cr0, {0}
    1dd8:	23000002 	movwcs	r0, #2
    1ddc:	0a000002 	beq	1dec <shift+0x1dec>
    1de0:	00000033 	andeq	r0, r0, r3, lsr r0
    1de4:	13080011 	movwne	r0, #32785	; 0x8011
    1de8:	0b000002 	bleq	1df8 <shift+0x1df8>
    1dec:	0000160f 	andeq	r1, r0, pc, lsl #12
    1df0:	26027402 	strcs	r7, [r2], -r2, lsl #8
    1df4:	00000223 	andeq	r0, r0, r3, lsr #4
    1df8:	0a3d3a24 	beq	f50690 <__bss_end+0xf46aa8>
    1dfc:	243d0f3d 	ldrtcs	r0, [sp], #-3901	; 0xfffff0c3
    1e00:	023d323d 	eorseq	r3, sp, #-805306365	; 0xd0000003
    1e04:	133d053d 	teqne	sp, #255852544	; 0xf400000
    1e08:	0c3d0d3d 	ldceq	13, cr0, [sp], #-244	; 0xffffff0c
    1e0c:	113d233d 	teqne	sp, sp, lsr r3
    1e10:	013d263d 	teqeq	sp, sp, lsr r6
    1e14:	083d173d 	ldmdaeq	sp!, {r0, r2, r3, r4, r5, r8, r9, sl, ip}
    1e18:	003d093d 	eorseq	r0, sp, sp, lsr r9
    1e1c:	07020200 	streq	r0, [r2, -r0, lsl #4]
    1e20:	000003f1 	strdeq	r0, [r0], -r1
    1e24:	d0080102 	andle	r0, r8, r2, lsl #2
    1e28:	02000004 	andeq	r0, r0, #4
    1e2c:	04e40502 	strbteq	r0, [r4], #1282	; 0x502
    1e30:	400c0000 	andmi	r0, ip, r0
    1e34:	03000018 	movweq	r0, #24
    1e38:	003a0f84 	eorseq	r0, sl, r4, lsl #31
    1e3c:	08020000 	stmdaeq	r2, {}	; <UNPREDICTABLE>
    1e40:	0015a807 	andseq	sl, r5, r7, lsl #16
    1e44:	18110c00 	ldmdane	r1, {sl, fp}
    1e48:	93030000 	movwls	r0, #12288	; 0x3000
    1e4c:	00002510 	andeq	r2, r0, r0, lsl r5
    1e50:	03080200 	movweq	r0, #33280	; 0x8200
    1e54:	000012b1 			; <UNDEFINED> instruction: 0x000012b1
    1e58:	62040802 	andvs	r0, r4, #131072	; 0x20000
    1e5c:	02000015 	andeq	r0, r0, #21
    1e60:	16b30310 	ssatne	r0, #20, r0, lsl #6
    1e64:	260d0000 	strcs	r0, [sp], -r0
    1e68:	01000018 	tsteq	r0, r8, lsl r0
    1e6c:	6f0105f9 	svcvs	0x000105f9
    1e70:	98000002 	stmdals	r0, {r1}
    1e74:	30000099 	mulcc	r0, r9, r0
    1e78:	01000000 	mrseq	r0, (UNDEF: 0)
    1e7c:	0002fd9c 	muleq	r2, ip, sp
    1e80:	00610e00 	rsbeq	r0, r1, r0, lsl #28
    1e84:	1305f901 	movwne	pc, #22785	; 0x5901	; <UNPREDICTABLE>
    1e88:	00000282 	andeq	r0, r0, r2, lsl #5
    1e8c:	00000008 	andeq	r0, r0, r8
    1e90:	00000000 	andeq	r0, r0, r0
    1e94:	0099ac0f 	addseq	sl, r9, pc, lsl #24
    1e98:	0002fd00 	andeq	pc, r2, r0, lsl #26
    1e9c:	0002e800 	andeq	lr, r2, r0, lsl #16
    1ea0:	50011000 	andpl	r1, r1, r0
    1ea4:	f503f305 			; <UNDEFINED> instruction: 0xf503f305
    1ea8:	11002500 	tstne	r0, r0, lsl #10
    1eac:	000099bc 			; <UNDEFINED> instruction: 0x000099bc
    1eb0:	000002fd 	strdeq	r0, [r0], -sp
    1eb4:	06500110 			; <UNDEFINED> instruction: 0x06500110
    1eb8:	00f503f3 	ldrshteq	r0, [r5], #51	; 0x33
    1ebc:	00001f25 	andeq	r1, r0, r5, lsr #30
    1ec0:	00181812 	andseq	r1, r8, r2, lsl r8
    1ec4:	00180400 	andseq	r0, r8, r0, lsl #8
    1ec8:	033b0100 	teqeq	fp, #0, 2
    1ecc:	00032a00 	andeq	r2, r3, r0, lsl #20
    1ed0:	26000400 	strcs	r0, [r0], -r0, lsl #8
    1ed4:	04000009 	streq	r0, [r0], #-9
    1ed8:	0013b001 	andseq	fp, r3, r1
    1edc:	15690c00 	strbne	r0, [r9, #-3072]!	; 0xfffff400
    1ee0:	11bf0000 			; <UNDEFINED> instruction: 0x11bf0000
    1ee4:	99c80000 	stmibls	r8, {}^	; <UNPREDICTABLE>
    1ee8:	00400000 	subeq	r0, r0, r0
    1eec:	0ea30000 	cdpeq	0, 10, cr0, cr3, cr0, {0}
    1ef0:	08020000 	stmdaeq	r2, {}	; <UNPREDICTABLE>
    1ef4:	00156204 	andseq	r6, r5, r4, lsl #4
    1ef8:	07040200 	streq	r0, [r4, -r0, lsl #4]
    1efc:	000015b2 			; <UNDEFINED> instruction: 0x000015b2
    1f00:	b9040402 	stmdblt	r4, {r1, sl}
    1f04:	03000012 	movweq	r0, #18
    1f08:	6e690504 	cdpvs	5, 6, cr0, cr9, cr4, {0}
    1f0c:	08020074 	stmdaeq	r2, {r2, r4, r5, r6}
    1f10:	00024305 	andeq	r4, r2, r5, lsl #6
    1f14:	04080200 	streq	r0, [r8], #-512	; 0xfffffe00
    1f18:	0000155d 	andeq	r1, r0, sp, asr r5
    1f1c:	c7080102 	strgt	r0, [r8, -r2, lsl #2]
    1f20:	02000004 	andeq	r0, r0, #4
    1f24:	04c90601 	strbeq	r0, [r9], #1537	; 0x601
    1f28:	35040000 	strcc	r0, [r4, #-0]
    1f2c:	07000017 	smladeq	r0, r7, r0, r0
    1f30:	00004f01 	andeq	r4, r0, r1, lsl #30
    1f34:	06170200 	ldreq	r0, [r7], -r0, lsl #4
    1f38:	000001ea 	andeq	r0, r0, sl, ror #3
    1f3c:	0012bf05 	andseq	fp, r2, r5, lsl #30
    1f40:	e4050000 	str	r0, [r5], #-0
    1f44:	01000017 	tsteq	r0, r7, lsl r0
    1f48:	00149205 	andseq	r9, r4, r5, lsl #4
    1f4c:	50050200 	andpl	r0, r5, r0, lsl #4
    1f50:	03000015 	movweq	r0, #21
    1f54:	00174e05 	andseq	r4, r7, r5, lsl #28
    1f58:	f4050400 	vst3.8	{d0-d2}, [r5], r0
    1f5c:	05000017 	streq	r0, [r0, #-23]	; 0xffffffe9
    1f60:	00176405 	andseq	r6, r7, r5, lsl #8
    1f64:	99050600 	stmdbls	r5, {r9, sl}
    1f68:	07000015 	smladeq	r0, r5, r0, r0
    1f6c:	0016df05 	andseq	sp, r6, r5, lsl #30
    1f70:	ed050800 	stc	8, cr0, [r5, #-0]
    1f74:	09000016 	stmdbeq	r0, {r1, r2, r4}
    1f78:	0016fb05 	andseq	pc, r6, r5, lsl #22
    1f7c:	02050a00 	andeq	r0, r5, #0, 20
    1f80:	0b000016 	bleq	1fe0 <shift+0x1fe0>
    1f84:	0015f205 	andseq	pc, r5, r5, lsl #4
    1f88:	db050c00 	blle	144f90 <__bss_end+0x13b3a8>
    1f8c:	0d000012 	stceq	0, cr0, [r0, #-72]	; 0xffffffb8
    1f90:	0012f405 	andseq	pc, r2, r5, lsl #8
    1f94:	e3050e00 	movw	r0, #24064	; 0x5e00
    1f98:	0f000015 	svceq	0x00000015
    1f9c:	0017a705 	andseq	sl, r7, r5, lsl #14
    1fa0:	24051000 	strcs	r1, [r5], #-0
    1fa4:	11000017 	tstne	r0, r7, lsl r0
    1fa8:	00179805 	andseq	r9, r7, r5, lsl #16
    1fac:	a1051200 	mrsge	r1, SP_usr
    1fb0:	13000013 	movwne	r0, #19
    1fb4:	00131e05 	andseq	r1, r3, r5, lsl #28
    1fb8:	e8051400 	stmda	r5, {sl, ip}
    1fbc:	15000012 	strne	r0, [r0, #-18]	; 0xffffffee
    1fc0:	00168105 	andseq	r8, r6, r5, lsl #2
    1fc4:	55051600 	strpl	r1, [r5, #-1536]	; 0xfffffa00
    1fc8:	17000013 	smladne	r0, r3, r0, r0
    1fcc:	00129005 	andseq	r9, r2, r5
    1fd0:	8a051800 	bhi	147fd8 <__bss_end+0x13e3f0>
    1fd4:	19000017 	stmdbne	r0, {r0, r1, r2, r4}
    1fd8:	0015bf05 	andseq	fp, r5, r5, lsl #30
    1fdc:	99051a00 	stmdbls	r5, {r9, fp, ip}
    1fe0:	1b000016 	blne	2040 <shift+0x2040>
    1fe4:	00132905 	andseq	r2, r3, r5, lsl #18
    1fe8:	35051c00 	strcc	r1, [r5, #-3072]	; 0xfffff400
    1fec:	1d000015 	stcne	0, cr0, [r0, #-84]	; 0xffffffac
    1ff0:	00148405 	andseq	r8, r4, r5, lsl #8
    1ff4:	16051e00 	strne	r1, [r5], -r0, lsl #28
    1ff8:	1f000017 	svcne	0x00000017
    1ffc:	00177205 	andseq	r7, r7, r5, lsl #4
    2000:	b3052000 	movwlt	r2, #20480	; 0x5000
    2004:	21000017 	tstcs	r0, r7, lsl r0
    2008:	0017c105 	andseq	ip, r7, r5, lsl #2
    200c:	d6052200 	strle	r2, [r5], -r0, lsl #4
    2010:	23000015 	movwcs	r0, #21
    2014:	0014f905 	andseq	pc, r4, r5, lsl #18
    2018:	38052400 	stmdacc	r5, {sl, sp}
    201c:	25000013 	strcs	r0, [r0, #-19]	; 0xffffffed
    2020:	00158c05 	andseq	r8, r5, r5, lsl #24
    2024:	9e052600 	cfmadd32ls	mvax0, mvfx2, mvfx5, mvfx0
    2028:	27000014 	smladcs	r0, r4, r0, r0
    202c:	00174105 	andseq	r4, r7, r5, lsl #2
    2030:	ae052800 	cdpge	8, 0, cr2, cr5, cr0, {0}
    2034:	29000014 	stmdbcs	r0, {r2, r4}
    2038:	0014bd05 	andseq	fp, r4, r5, lsl #26
    203c:	cc052a00 			; <UNDEFINED> instruction: 0xcc052a00
    2040:	2b000014 	blcs	2098 <shift+0x2098>
    2044:	0014db05 	andseq	sp, r4, r5, lsl #22
    2048:	69052c00 	stmdbvs	r5, {sl, fp, sp}
    204c:	2d000014 	stccs	0, cr0, [r0, #-80]	; 0xffffffb0
    2050:	0014ea05 	andseq	lr, r4, r5, lsl #20
    2054:	d0052e00 	andle	r2, r5, r0, lsl #28
    2058:	2f000016 	svccs	0x00000016
    205c:	00150805 	andseq	r0, r5, r5, lsl #16
    2060:	17053000 	strne	r3, [r5, -r0]
    2064:	31000015 	tstcc	r0, r5, lsl r0
    2068:	0012c905 	andseq	ip, r2, r5, lsl #18
    206c:	21053200 	mrscs	r3, SP_usr
    2070:	33000016 	movwcc	r0, #22
    2074:	00163105 	andseq	r3, r6, r5, lsl #2
    2078:	41053400 	tstmi	r5, r0, lsl #8
    207c:	35000016 	strcc	r0, [r0, #-22]	; 0xffffffea
    2080:	00145705 	andseq	r5, r4, r5, lsl #14
    2084:	51053600 	tstpl	r5, r0, lsl #12
    2088:	37000016 	smladcc	r0, r6, r0, r0
    208c:	00166105 	andseq	r6, r6, r5, lsl #2
    2090:	71053800 	tstvc	r5, r0, lsl #16
    2094:	39000016 	stmdbcc	r0, {r1, r2, r4}
    2098:	00134805 	andseq	r4, r3, r5, lsl #16
    209c:	01053a00 	tsteq	r5, r0, lsl #20
    20a0:	3b000013 	blcc	20f4 <shift+0x20f4>
    20a4:	00152605 	andseq	r2, r5, r5, lsl #12
    20a8:	a0053c00 	andge	r3, r5, r0, lsl #24
    20ac:	3d000012 	stccc	0, cr0, [r0, #-72]	; 0xffffffb8
    20b0:	00168c05 	andseq	r8, r6, r5, lsl #24
    20b4:	06003e00 	streq	r3, [r0], -r0, lsl #28
    20b8:	00001388 	andeq	r1, r0, r8, lsl #7
    20bc:	026b0202 	rsbeq	r0, fp, #536870912	; 0x20000000
    20c0:	00021508 	andeq	r1, r2, r8, lsl #10
    20c4:	154b0700 	strbne	r0, [fp, #-1792]	; 0xfffff900
    20c8:	70020000 	andvc	r0, r2, r0
    20cc:	005d1402 	subseq	r1, sp, r2, lsl #8
    20d0:	07000000 	streq	r0, [r0, -r0]
    20d4:	00001464 	andeq	r1, r0, r4, ror #8
    20d8:	14027102 	strne	r7, [r2], #-258	; 0xfffffefe
    20dc:	0000005d 	andeq	r0, r0, sp, asr r0
    20e0:	ea080001 	b	2020ec <__bss_end+0x1f8504>
    20e4:	09000001 	stmdbeq	r0, {r0}
    20e8:	00000215 	andeq	r0, r0, r5, lsl r2
    20ec:	0000022a 	andeq	r0, r0, sl, lsr #4
    20f0:	00002c0a 	andeq	r2, r0, sl, lsl #24
    20f4:	08001100 	stmdaeq	r0, {r8, ip}
    20f8:	0000021a 	andeq	r0, r0, sl, lsl r2
    20fc:	00160f0b 	andseq	r0, r6, fp, lsl #30
    2100:	02740200 	rsbseq	r0, r4, #0, 4
    2104:	00022a26 	andeq	r2, r2, r6, lsr #20
    2108:	3d3a2400 	cfldrscc	mvf2, [sl, #-0]
    210c:	3d0f3d0a 	stccc	13, cr3, [pc, #-40]	; 20ec <shift+0x20ec>
    2110:	3d323d24 	ldccc	13, cr3, [r2, #-144]!	; 0xffffff70
    2114:	3d053d02 	stccc	13, cr3, [r5, #-8]
    2118:	3d0d3d13 	stccc	13, cr3, [sp, #-76]	; 0xffffffb4
    211c:	3d233d0c 	stccc	13, cr3, [r3, #-48]!	; 0xffffffd0
    2120:	3d263d11 	stccc	13, cr3, [r6, #-68]!	; 0xffffffbc
    2124:	3d173d01 	ldccc	13, cr3, [r7, #-4]
    2128:	3d093d08 	stccc	13, cr3, [r9, #-32]	; 0xffffffe0
    212c:	02020000 	andeq	r0, r2, #0
    2130:	0003f107 	andeq	pc, r3, r7, lsl #2
    2134:	08010200 	stmdaeq	r1, {r9}
    2138:	000004d0 	ldrdeq	r0, [r0], -r0	; <UNPREDICTABLE>
    213c:	e4050202 	str	r0, [r5], #-514	; 0xfffffdfe
    2140:	0c000004 	stceq	0, cr0, [r0], {4}
    2144:	00001837 	andeq	r1, r0, r7, lsr r8
    2148:	2c168103 	ldfcsd	f0, [r6], {3}
    214c:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    2150:	00000276 	andeq	r0, r0, r6, ror r2
    2154:	00183f0c 	andseq	r3, r8, ip, lsl #30
    2158:	16850300 	strne	r0, [r5], r0, lsl #6
    215c:	00000293 	muleq	r0, r3, r2
    2160:	a8070802 	stmdage	r7, {r1, fp}
    2164:	0c000015 	stceq	0, cr0, [r0], {21}
    2168:	00001811 	andeq	r1, r0, r1, lsl r8
    216c:	33109303 	tstcc	r0, #201326592	; 0xc000000
    2170:	02000000 	andeq	r0, r0, #0
    2174:	12b10308 	adcsne	r0, r1, #8, 6	; 0x20000000
    2178:	300c0000 	andcc	r0, ip, r0
    217c:	03000018 	movweq	r0, #24
    2180:	00251097 	mlaeq	r5, r7, r0, r1
    2184:	ad080000 	stcge	0, cr0, [r8, #-0]
    2188:	02000002 	andeq	r0, r0, #2
    218c:	16b30310 	ssatne	r0, #20, r0, lsl #6
    2190:	040d0000 	streq	r0, [sp], #-0
    2194:	01000018 	tsteq	r0, r8, lsl r0
    2198:	870105b9 			; <UNDEFINED> instruction: 0x870105b9
    219c:	c8000002 	stmdagt	r0, {r1}
    21a0:	40000099 	mulmi	r0, r9, r0
    21a4:	01000000 	mrseq	r0, (UNDEF: 0)
    21a8:	00610e9c 	mlseq	r1, ip, lr, r0
    21ac:	1605b901 	strne	fp, [r5], -r1, lsl #18
    21b0:	0000029a 	muleq	r0, sl, r2
    21b4:	0000004a 	andeq	r0, r0, sl, asr #32
    21b8:	00000046 	andeq	r0, r0, r6, asr #32
    21bc:	6166640f 	cmnvs	r6, pc, lsl #8
    21c0:	05bf0100 	ldreq	r0, [pc, #256]!	; 22c8 <shift+0x22c8>
    21c4:	0002b910 	andeq	fp, r2, r0, lsl r9
    21c8:	00007300 	andeq	r7, r0, r0, lsl #6
    21cc:	00006d00 	andeq	r6, r0, r0, lsl #26
    21d0:	69680f00 	stmdbvs	r8!, {r8, r9, sl, fp}^
    21d4:	05c40100 	strbeq	r0, [r4, #256]	; 0x100
    21d8:	00028210 	andeq	r8, r2, r0, lsl r2
    21dc:	0000b100 	andeq	fp, r0, r0, lsl #2
    21e0:	0000af00 	andeq	sl, r0, r0, lsl #30
    21e4:	6f6c0f00 	svcvs	0x006c0f00
    21e8:	05c90100 	strbeq	r0, [r9, #256]	; 0x100
    21ec:	00028210 	andeq	r8, r2, r0, lsl r2
    21f0:	0000cb00 	andeq	ip, r0, r0, lsl #22
    21f4:	0000c500 	andeq	ip, r0, r0, lsl #10
    21f8:	80000000 	andhi	r0, r0, r0
    21fc:	04000003 	streq	r0, [r0], #-3
    2200:	000a0d00 	andeq	r0, sl, r0, lsl #26
    2204:	47010400 	strmi	r0, [r1, -r0, lsl #8]
    2208:	0c000018 	stceq	0, cr0, [r0], {24}
    220c:	00001569 	andeq	r1, r0, r9, ror #10
    2210:	000011bf 			; <UNDEFINED> instruction: 0x000011bf
    2214:	00009a08 	andeq	r9, r0, r8, lsl #20
    2218:	00000120 	andeq	r0, r0, r0, lsr #2
    221c:	00000f5d 	andeq	r0, r0, sp, asr pc
    2220:	a8070802 	stmdage	r7, {r1, fp}
    2224:	03000015 	movweq	r0, #21
    2228:	6e690504 	cdpvs	5, 6, cr0, cr9, cr4, {0}
    222c:	04020074 	streq	r0, [r2], #-116	; 0xffffff8c
    2230:	0015b207 	andseq	fp, r5, r7, lsl #4
    2234:	05080200 	streq	r0, [r8, #-512]	; 0xfffffe00
    2238:	00000243 	andeq	r0, r0, r3, asr #4
    223c:	5d040802 	stcpl	8, cr0, [r4, #-8]
    2240:	02000015 	andeq	r0, r0, #21
    2244:	04c70801 	strbeq	r0, [r7], #2049	; 0x801
    2248:	01020000 	mrseq	r0, (UNDEF: 2)
    224c:	0004c906 	andeq	ip, r4, r6, lsl #18
    2250:	17350400 	ldrne	r0, [r5, -r0, lsl #8]!
    2254:	01070000 	mrseq	r0, (UNDEF: 7)
    2258:	00000048 	andeq	r0, r0, r8, asr #32
    225c:	e3061702 	movw	r1, #26370	; 0x6702
    2260:	05000001 	streq	r0, [r0, #-1]
    2264:	000012bf 			; <UNDEFINED> instruction: 0x000012bf
    2268:	17e40500 	strbne	r0, [r4, r0, lsl #10]!
    226c:	05010000 	streq	r0, [r1, #-0]
    2270:	00001492 	muleq	r0, r2, r4
    2274:	15500502 	ldrbne	r0, [r0, #-1282]	; 0xfffffafe
    2278:	05030000 	streq	r0, [r3, #-0]
    227c:	0000174e 	andeq	r1, r0, lr, asr #14
    2280:	17f40504 	ldrbne	r0, [r4, r4, lsl #10]!
    2284:	05050000 	streq	r0, [r5, #-0]
    2288:	00001764 	andeq	r1, r0, r4, ror #14
    228c:	15990506 	ldrne	r0, [r9, #1286]	; 0x506
    2290:	05070000 	streq	r0, [r7, #-0]
    2294:	000016df 	ldrdeq	r1, [r0], -pc	; <UNPREDICTABLE>
    2298:	16ed0508 	strbtne	r0, [sp], r8, lsl #10
    229c:	05090000 	streq	r0, [r9, #-0]
    22a0:	000016fb 	strdeq	r1, [r0], -fp
    22a4:	1602050a 	strne	r0, [r2], -sl, lsl #10
    22a8:	050b0000 	streq	r0, [fp, #-0]
    22ac:	000015f2 	strdeq	r1, [r0], -r2
    22b0:	12db050c 	sbcsne	r0, fp, #12, 10	; 0x3000000
    22b4:	050d0000 	streq	r0, [sp, #-0]
    22b8:	000012f4 	strdeq	r1, [r0], -r4
    22bc:	15e3050e 	strbne	r0, [r3, #1294]!	; 0x50e
    22c0:	050f0000 	streq	r0, [pc, #-0]	; 22c8 <shift+0x22c8>
    22c4:	000017a7 	andeq	r1, r0, r7, lsr #15
    22c8:	17240510 			; <UNDEFINED> instruction: 0x17240510
    22cc:	05110000 	ldreq	r0, [r1, #-0]
    22d0:	00001798 	muleq	r0, r8, r7
    22d4:	13a10512 			; <UNDEFINED> instruction: 0x13a10512
    22d8:	05130000 	ldreq	r0, [r3, #-0]
    22dc:	0000131e 	andeq	r1, r0, lr, lsl r3
    22e0:	12e80514 	rscne	r0, r8, #20, 10	; 0x5000000
    22e4:	05150000 	ldreq	r0, [r5, #-0]
    22e8:	00001681 	andeq	r1, r0, r1, lsl #13
    22ec:	13550516 	cmpne	r5, #92274688	; 0x5800000
    22f0:	05170000 	ldreq	r0, [r7, #-0]
    22f4:	00001290 	muleq	r0, r0, r2
    22f8:	178a0518 	usada8ne	sl, r8, r5, r0
    22fc:	05190000 	ldreq	r0, [r9, #-0]
    2300:	000015bf 			; <UNDEFINED> instruction: 0x000015bf
    2304:	1699051a 			; <UNDEFINED> instruction: 0x1699051a
    2308:	051b0000 	ldreq	r0, [fp, #-0]
    230c:	00001329 	andeq	r1, r0, r9, lsr #6
    2310:	1535051c 	ldrne	r0, [r5, #-1308]!	; 0xfffffae4
    2314:	051d0000 	ldreq	r0, [sp, #-0]
    2318:	00001484 	andeq	r1, r0, r4, lsl #9
    231c:	1716051e 			; <UNDEFINED> instruction: 0x1716051e
    2320:	051f0000 	ldreq	r0, [pc, #-0]	; 2328 <shift+0x2328>
    2324:	00001772 	andeq	r1, r0, r2, ror r7
    2328:	17b30520 	ldrne	r0, [r3, r0, lsr #10]!
    232c:	05210000 	streq	r0, [r1, #-0]!
    2330:	000017c1 	andeq	r1, r0, r1, asr #15
    2334:	15d60522 	ldrbne	r0, [r6, #1314]	; 0x522
    2338:	05230000 	streq	r0, [r3, #-0]!
    233c:	000014f9 	strdeq	r1, [r0], -r9
    2340:	13380524 	teqne	r8, #36, 10	; 0x9000000
    2344:	05250000 	streq	r0, [r5, #-0]!
    2348:	0000158c 	andeq	r1, r0, ip, lsl #11
    234c:	149e0526 	ldrne	r0, [lr], #1318	; 0x526
    2350:	05270000 	streq	r0, [r7, #-0]!
    2354:	00001741 	andeq	r1, r0, r1, asr #14
    2358:	14ae0528 	strtne	r0, [lr], #1320	; 0x528
    235c:	05290000 	streq	r0, [r9, #-0]!
    2360:	000014bd 			; <UNDEFINED> instruction: 0x000014bd
    2364:	14cc052a 	strbne	r0, [ip], #1322	; 0x52a
    2368:	052b0000 	streq	r0, [fp, #-0]!
    236c:	000014db 	ldrdeq	r1, [r0], -fp
    2370:	1469052c 	strbtne	r0, [r9], #-1324	; 0xfffffad4
    2374:	052d0000 	streq	r0, [sp, #-0]!
    2378:	000014ea 	andeq	r1, r0, sl, ror #9
    237c:	16d0052e 	ldrbne	r0, [r0], lr, lsr #10
    2380:	052f0000 	streq	r0, [pc, #-0]!	; 2388 <shift+0x2388>
    2384:	00001508 	andeq	r1, r0, r8, lsl #10
    2388:	15170530 	ldrne	r0, [r7, #-1328]	; 0xfffffad0
    238c:	05310000 	ldreq	r0, [r1, #-0]!
    2390:	000012c9 	andeq	r1, r0, r9, asr #5
    2394:	16210532 			; <UNDEFINED> instruction: 0x16210532
    2398:	05330000 	ldreq	r0, [r3, #-0]!
    239c:	00001631 	andeq	r1, r0, r1, lsr r6
    23a0:	16410534 			; <UNDEFINED> instruction: 0x16410534
    23a4:	05350000 	ldreq	r0, [r5, #-0]!
    23a8:	00001457 	andeq	r1, r0, r7, asr r4
    23ac:	16510536 			; <UNDEFINED> instruction: 0x16510536
    23b0:	05370000 	ldreq	r0, [r7, #-0]!
    23b4:	00001661 	andeq	r1, r0, r1, ror #12
    23b8:	16710538 			; <UNDEFINED> instruction: 0x16710538
    23bc:	05390000 	ldreq	r0, [r9, #-0]!
    23c0:	00001348 	andeq	r1, r0, r8, asr #6
    23c4:	1301053a 	movwne	r0, #5434	; 0x153a
    23c8:	053b0000 	ldreq	r0, [fp, #-0]!
    23cc:	00001526 	andeq	r1, r0, r6, lsr #10
    23d0:	12a0053c 	adcne	r0, r0, #60, 10	; 0xf000000
    23d4:	053d0000 	ldreq	r0, [sp, #-0]!
    23d8:	0000168c 	andeq	r1, r0, ip, lsl #13
    23dc:	8806003e 	stmdahi	r6, {r1, r2, r3, r4, r5}
    23e0:	02000013 	andeq	r0, r0, #19
    23e4:	08026b02 	stmdaeq	r2, {r1, r8, r9, fp, sp, lr}
    23e8:	0000020e 	andeq	r0, r0, lr, lsl #4
    23ec:	00154b07 	andseq	r4, r5, r7, lsl #22
    23f0:	02700200 	rsbseq	r0, r0, #0, 4
    23f4:	00005614 	andeq	r5, r0, r4, lsl r6
    23f8:	64070000 	strvs	r0, [r7], #-0
    23fc:	02000014 	andeq	r0, r0, #20
    2400:	56140271 			; <UNDEFINED> instruction: 0x56140271
    2404:	01000000 	mrseq	r0, (UNDEF: 0)
    2408:	01e30800 	mvneq	r0, r0, lsl #16
    240c:	0e090000 	cdpeq	0, 0, cr0, cr9, cr0, {0}
    2410:	23000002 	movwcs	r0, #2
    2414:	0a000002 	beq	2424 <shift+0x2424>
    2418:	00000033 	andeq	r0, r0, r3, lsr r0
    241c:	13080011 	movwne	r0, #32785	; 0x8011
    2420:	0b000002 	bleq	2430 <shift+0x2430>
    2424:	0000160f 	andeq	r1, r0, pc, lsl #12
    2428:	26027402 	strcs	r7, [r2], -r2, lsl #8
    242c:	00000223 	andeq	r0, r0, r3, lsr #4
    2430:	0a3d3a24 	beq	f50cc8 <__bss_end+0xf470e0>
    2434:	243d0f3d 	ldrtcs	r0, [sp], #-3901	; 0xfffff0c3
    2438:	023d323d 	eorseq	r3, sp, #-805306365	; 0xd0000003
    243c:	133d053d 	teqne	sp, #255852544	; 0xf400000
    2440:	0c3d0d3d 	ldceq	13, cr0, [sp], #-244	; 0xffffff0c
    2444:	113d233d 	teqne	sp, sp, lsr r3
    2448:	013d263d 	teqeq	sp, sp, lsr r6
    244c:	083d173d 	ldmdaeq	sp!, {r0, r2, r3, r4, r5, r8, r9, sl, ip}
    2450:	003d093d 	eorseq	r0, sp, sp, lsr r9
    2454:	07020200 	streq	r0, [r2, -r0, lsl #4]
    2458:	000003f1 	strdeq	r0, [r0], -r1
    245c:	d0080102 	andle	r0, r8, r2, lsl #2
    2460:	02000004 	andeq	r0, r0, #4
    2464:	04e40502 	strbteq	r0, [r4], #1282	; 0x502
    2468:	370c0000 	strcc	r0, [ip, -r0]
    246c:	03000018 	movweq	r0, #24
    2470:	00331681 	eorseq	r1, r3, r1, lsl #13
    2474:	3f0c0000 	svccc	0x000c0000
    2478:	03000018 	movweq	r0, #24
    247c:	00251685 	eoreq	r1, r5, r5, lsl #13
    2480:	04020000 	streq	r0, [r2], #-0
    2484:	0012b904 	andseq	fp, r2, r4, lsl #18
    2488:	03080200 	movweq	r0, #33280	; 0x8200
    248c:	000012b1 			; <UNDEFINED> instruction: 0x000012b1
    2490:	62040802 	andvs	r0, r4, #131072	; 0x20000
    2494:	02000015 	andeq	r0, r0, #21
    2498:	16b30310 	ssatne	r0, #20, r0, lsl #6
    249c:	fb0d0000 	blx	3424a6 <__bss_end+0x3388be>
    24a0:	01000018 	tsteq	r0, r8, lsl r0
    24a4:	7b0103b3 	blvc	43378 <__bss_end+0x39790>
    24a8:	08000002 	stmdaeq	r0, {r1}
    24ac:	2000009a 	mulcs	r0, sl, r0
    24b0:	01000001 	tsteq	r0, r1
    24b4:	00037d9c 	muleq	r3, ip, sp
    24b8:	006e0e00 	rsbeq	r0, lr, r0, lsl #28
    24bc:	1703b301 	strne	fp, [r3, -r1, lsl #6]
    24c0:	0000027b 	andeq	r0, r0, fp, ror r2
    24c4:	00000149 	andeq	r0, r0, r9, asr #2
    24c8:	00000145 	andeq	r0, r0, r5, asr #2
    24cc:	0100640e 	tsteq	r0, lr, lsl #8
    24d0:	7b2203b3 	blvc	8833a4 <__bss_end+0x8797bc>
    24d4:	75000002 	strvc	r0, [r0, #-2]
    24d8:	71000001 	tstvc	r0, r1
    24dc:	0f000001 	svceq	0x00000001
    24e0:	01007072 	tsteq	r0, r2, ror r0
    24e4:	7d2e03b3 	stcvc	3, cr0, [lr, #-716]!	; 0xfffffd34
    24e8:	02000003 	andeq	r0, r0, #3
    24ec:	71100091 			; <UNDEFINED> instruction: 0x71100091
    24f0:	03b50100 			; <UNDEFINED> instruction: 0x03b50100
    24f4:	00027b0b 	andeq	r7, r2, fp, lsl #22
    24f8:	0001a500 	andeq	sl, r1, r0, lsl #10
    24fc:	00019d00 	andeq	r9, r1, r0, lsl #26
    2500:	00721000 	rsbseq	r1, r2, r0
    2504:	1203b501 	andne	fp, r3, #4194304	; 0x400000
    2508:	0000027b 	andeq	r0, r0, fp, ror r2
    250c:	000001fb 	strdeq	r0, [r0], -fp
    2510:	000001f1 	strdeq	r0, [r0], -r1
    2514:	01007910 	tsteq	r0, r0, lsl r9
    2518:	7b1903b5 	blvc	6433f4 <__bss_end+0x63980c>
    251c:	59000002 	stmdbpl	r0, {r1}
    2520:	53000002 	movwpl	r0, #2
    2524:	10000002 	andne	r0, r0, r2
    2528:	00317a6c 	eorseq	r7, r1, ip, ror #20
    252c:	0a03b601 	beq	efd38 <__bss_end+0xe6150>
    2530:	0000026f 	andeq	r0, r0, pc, ror #4
    2534:	00000293 	muleq	r0, r3, r2
    2538:	00000291 	muleq	r0, r1, r2
    253c:	327a6c10 	rsbscc	r6, sl, #16, 24	; 0x1000
    2540:	03b60100 			; <UNDEFINED> instruction: 0x03b60100
    2544:	00026f0f 	andeq	r6, r2, pc, lsl #30
    2548:	0002aa00 	andeq	sl, r2, r0, lsl #20
    254c:	0002a800 	andeq	sl, r2, r0, lsl #16
    2550:	00691000 	rsbeq	r1, r9, r0
    2554:	1403b601 	strne	fp, [r3], #-1537	; 0xfffff9ff
    2558:	0000026f 	andeq	r0, r0, pc, ror #4
    255c:	000002c9 	andeq	r0, r0, r9, asr #5
    2560:	000002bd 			; <UNDEFINED> instruction: 0x000002bd
    2564:	01006b10 	tsteq	r0, r0, lsl fp
    2568:	6f1703b6 	svcvs	0x001703b6
    256c:	1b000002 	blne	257c <shift+0x257c>
    2570:	17000003 	strne	r0, [r0, -r3]
    2574:	00000003 	andeq	r0, r0, r3
    2578:	027b0411 	rsbseq	r0, fp, #285212672	; 0x11000000
    257c:	Address 0x000000000000257c is out of bounds.


Disassembly of section .debug_abbrev:

00000000 <.debug_abbrev>:
   0:	10001101 	andne	r1, r0, r1, lsl #2
   4:	12011106 	andne	r1, r1, #-2147483647	; 0x80000001
   8:	1b0e0301 	blne	380c14 <__bss_end+0x37702c>
   c:	130e250e 	movwne	r2, #58638	; 0xe50e
  10:	00000005 	andeq	r0, r0, r5
  14:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
  18:	030b130e 	movweq	r1, #45838	; 0xb30e
  1c:	110e1b0e 	tstne	lr, lr, lsl #22
  20:	10061201 	andne	r1, r6, r1, lsl #4
  24:	02000017 	andeq	r0, r0, #23
  28:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
  2c:	0b3b0b3a 	bleq	ec2d1c <__bss_end+0xeb9134>
  30:	13490b39 	movtne	r0, #39737	; 0x9b39
  34:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
  38:	24030000 	strcs	r0, [r3], #-0
  3c:	3e0b0b00 	vmlacc.f64	d0, d11, d0
  40:	000e030b 	andeq	r0, lr, fp, lsl #6
  44:	012e0400 			; <UNDEFINED> instruction: 0x012e0400
  48:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
  4c:	0b3b0b3a 	bleq	ec2d3c <__bss_end+0xeb9154>
  50:	01110b39 	tsteq	r1, r9, lsr fp
  54:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
  58:	01194296 			; <UNDEFINED> instruction: 0x01194296
  5c:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
  60:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
  64:	0b3b0b3a 	bleq	ec2d54 <__bss_end+0xeb916c>
  68:	13490b39 	movtne	r0, #39737	; 0x9b39
  6c:	00001802 	andeq	r1, r0, r2, lsl #16
  70:	0b002406 	bleq	9090 <_Z6memcpyPKvPvi+0x3c>
  74:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
  78:	07000008 	streq	r0, [r0, -r8]
  7c:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
  80:	0b3a0e03 	bleq	e83894 <__bss_end+0xe79cac>
  84:	0b390b3b 	bleq	e42d78 <__bss_end+0xe39190>
  88:	06120111 			; <UNDEFINED> instruction: 0x06120111
  8c:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
  90:	00130119 	andseq	r0, r3, r9, lsl r1
  94:	010b0800 	tsteq	fp, r0, lsl #16
  98:	06120111 			; <UNDEFINED> instruction: 0x06120111
  9c:	34090000 	strcc	r0, [r9], #-0
  a0:	3a080300 	bcc	200ca8 <__bss_end+0x1f70c0>
  a4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
  a8:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
  ac:	0a000018 	beq	114 <shift+0x114>
  b0:	0b0b000f 	bleq	2c00f4 <__bss_end+0x2b650c>
  b4:	00001349 	andeq	r1, r0, r9, asr #6
  b8:	01110100 	tsteq	r1, r0, lsl #2
  bc:	0b130e25 	bleq	4c3958 <__bss_end+0x4b9d70>
  c0:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
  c4:	06120111 			; <UNDEFINED> instruction: 0x06120111
  c8:	00001710 	andeq	r1, r0, r0, lsl r7
  cc:	03001602 	movweq	r1, #1538	; 0x602
  d0:	3b0b3a0e 	blcc	2ce910 <__bss_end+0x2c4d28>
  d4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
  d8:	03000013 	movweq	r0, #19
  dc:	0b0b000f 	bleq	2c0120 <__bss_end+0x2b6538>
  e0:	00001349 	andeq	r1, r0, r9, asr #6
  e4:	00001504 	andeq	r1, r0, r4, lsl #10
  e8:	01010500 	tsteq	r1, r0, lsl #10
  ec:	13011349 	movwne	r1, #4937	; 0x1349
  f0:	21060000 	mrscs	r0, (UNDEF: 6)
  f4:	2f134900 	svccs	0x00134900
  f8:	07000006 	streq	r0, [r0, -r6]
  fc:	0b0b0024 	bleq	2c0194 <__bss_end+0x2b65ac>
 100:	0e030b3e 	vmoveq.16	d3[0], r0
 104:	34080000 	strcc	r0, [r8], #-0
 108:	3a0e0300 	bcc	380d10 <__bss_end+0x377128>
 10c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 110:	3f13490b 	svccc	0x0013490b
 114:	00193c19 	andseq	r3, r9, r9, lsl ip
 118:	012e0900 			; <UNDEFINED> instruction: 0x012e0900
 11c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 120:	0b3b0b3a 	bleq	ec2e10 <__bss_end+0xeb9228>
 124:	13490b39 	movtne	r0, #39737	; 0x9b39
 128:	06120111 			; <UNDEFINED> instruction: 0x06120111
 12c:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 130:	00130119 	andseq	r0, r3, r9, lsl r1
 134:	00340a00 	eorseq	r0, r4, r0, lsl #20
 138:	0b3a0e03 	bleq	e8394c <__bss_end+0xe79d64>
 13c:	0b390b3b 	bleq	e42e30 <__bss_end+0xe39248>
 140:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 144:	240b0000 	strcs	r0, [fp], #-0
 148:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 14c:	0008030b 	andeq	r0, r8, fp, lsl #6
 150:	002e0c00 	eoreq	r0, lr, r0, lsl #24
 154:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 158:	0b3b0b3a 	bleq	ec2e48 <__bss_end+0xeb9260>
 15c:	01110b39 	tsteq	r1, r9, lsr fp
 160:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 164:	00194297 	mulseq	r9, r7, r2
 168:	01390d00 	teqeq	r9, r0, lsl #26
 16c:	0b3a0e03 	bleq	e83980 <__bss_end+0xe79d98>
 170:	13010b3b 	movwne	r0, #6971	; 0x1b3b
 174:	2e0e0000 	cdpcs	0, 0, cr0, cr14, cr0, {0}
 178:	03193f01 	tsteq	r9, #1, 30
 17c:	3b0b3a0e 	blcc	2ce9bc <__bss_end+0x2c4dd4>
 180:	3c0b390b 			; <UNDEFINED> instruction: 0x3c0b390b
 184:	00130119 	andseq	r0, r3, r9, lsl r1
 188:	00050f00 	andeq	r0, r5, r0, lsl #30
 18c:	00001349 	andeq	r1, r0, r9, asr #6
 190:	3f012e10 	svccc	0x00012e10
 194:	3a0e0319 	bcc	380e00 <__bss_end+0x377218>
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
 1c0:	3a080300 	bcc	200dc8 <__bss_end+0x1f71e0>
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
 1f4:	0b0b0024 	bleq	2c028c <__bss_end+0x2b66a4>
 1f8:	0e030b3e 	vmoveq.16	d3[0], r0
 1fc:	26030000 	strcs	r0, [r3], -r0
 200:	00134900 	andseq	r4, r3, r0, lsl #18
 204:	00240400 	eoreq	r0, r4, r0, lsl #8
 208:	0b3e0b0b 	bleq	f82e3c <__bss_end+0xf79254>
 20c:	00000803 	andeq	r0, r0, r3, lsl #16
 210:	03001605 	movweq	r1, #1541	; 0x605
 214:	3b0b3a0e 	blcc	2cea54 <__bss_end+0x2c4e6c>
 218:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 21c:	06000013 			; <UNDEFINED> instruction: 0x06000013
 220:	0e030104 	adfeqs	f0, f3, f4
 224:	0b3e196d 	bleq	f867e0 <__bss_end+0xf7cbf8>
 228:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 22c:	0b3b0b3a 	bleq	ec2f1c <__bss_end+0xeb9334>
 230:	13010b39 	movwne	r0, #6969	; 0x1b39
 234:	28070000 	stmdacs	r7, {}	; <UNPREDICTABLE>
 238:	1c0e0300 	stcne	3, cr0, [lr], {-0}
 23c:	0800000b 	stmdaeq	r0, {r0, r1, r3}
 240:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 244:	0b3b0b3a 	bleq	ec2f34 <__bss_end+0xeb934c>
 248:	13490b39 	movtne	r0, #39737	; 0x9b39
 24c:	1802196c 	stmdane	r2, {r2, r3, r5, r6, r8, fp, ip}
 250:	01090000 	mrseq	r0, (UNDEF: 9)
 254:	01134901 	tsteq	r3, r1, lsl #18
 258:	0a000013 	beq	2ac <shift+0x2ac>
 25c:	13490021 	movtne	r0, #36897	; 0x9021
 260:	00000b2f 	andeq	r0, r0, pc, lsr #22
 264:	0b000f0b 	bleq	3e98 <shift+0x3e98>
 268:	0013490b 	andseq	r4, r3, fp, lsl #18
 26c:	00280c00 	eoreq	r0, r8, r0, lsl #24
 270:	051c0e03 	ldreq	r0, [ip, #-3587]	; 0xfffff1fd
 274:	280d0000 	stmdacs	sp, {}	; <UNPREDICTABLE>
 278:	1c0e0300 	stcne	3, cr0, [lr], {-0}
 27c:	0e000006 	cdpeq	0, 0, cr0, cr0, cr6, {0}
 280:	0e030113 	mcreq	1, 0, r0, cr3, cr3, {0}
 284:	0b3a0b0b 	bleq	e82eb8 <__bss_end+0xe792d0>
 288:	0b390b3b 	bleq	e42f7c <__bss_end+0xe39394>
 28c:	00001301 	andeq	r1, r0, r1, lsl #6
 290:	03000d0f 	movweq	r0, #3343	; 0xd0f
 294:	3b0b3a0e 	blcc	2cead4 <__bss_end+0x2c4eec>
 298:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 29c:	000b3813 	andeq	r3, fp, r3, lsl r8
 2a0:	012e1000 			; <UNDEFINED> instruction: 0x012e1000
 2a4:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 2a8:	0b3b0b3a 	bleq	ec2f98 <__bss_end+0xeb93b0>
 2ac:	13490b39 	movtne	r0, #39737	; 0x9b39
 2b0:	06120111 			; <UNDEFINED> instruction: 0x06120111
 2b4:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 2b8:	00130119 	andseq	r0, r3, r9, lsl r1
 2bc:	00051100 	andeq	r1, r5, r0, lsl #2
 2c0:	0b3a0e03 	bleq	e83ad4 <__bss_end+0xe79eec>
 2c4:	0b390b3b 	bleq	e42fb8 <__bss_end+0xe393d0>
 2c8:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 2cc:	34120000 	ldrcc	r0, [r2], #-0
 2d0:	3a0e0300 	bcc	380ed8 <__bss_end+0x3772f0>
 2d4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 2d8:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 2dc:	13000018 	movwne	r0, #24
 2e0:	08030034 	stmdaeq	r3, {r2, r4, r5}
 2e4:	0b3b0b3a 	bleq	ec2fd4 <__bss_end+0xeb93ec>
 2e8:	13490b39 	movtne	r0, #39737	; 0x9b39
 2ec:	00001802 	andeq	r1, r0, r2, lsl #16
 2f0:	11010b14 	tstne	r1, r4, lsl fp
 2f4:	00061201 	andeq	r1, r6, r1, lsl #4
 2f8:	012e1500 			; <UNDEFINED> instruction: 0x012e1500
 2fc:	0b3a0e03 	bleq	e83b10 <__bss_end+0xe79f28>
 300:	0b390b3b 	bleq	e42ff4 <__bss_end+0xe3940c>
 304:	06120111 			; <UNDEFINED> instruction: 0x06120111
 308:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 30c:	00000019 	andeq	r0, r0, r9, lsl r0
 310:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
 314:	030b130e 	movweq	r1, #45838	; 0xb30e
 318:	110e1b0e 	tstne	lr, lr, lsl #22
 31c:	10061201 	andne	r1, r6, r1, lsl #4
 320:	02000017 	andeq	r0, r0, #23
 324:	0b0b0024 	bleq	2c03bc <__bss_end+0x2b67d4>
 328:	0e030b3e 	vmoveq.16	d3[0], r0
 32c:	26030000 	strcs	r0, [r3], -r0
 330:	00134900 	andseq	r4, r3, r0, lsl #18
 334:	00240400 	eoreq	r0, r4, r0, lsl #8
 338:	0b3e0b0b 	bleq	f82f6c <__bss_end+0xf79384>
 33c:	00000803 	andeq	r0, r0, r3, lsl #16
 340:	03001605 	movweq	r1, #1541	; 0x605
 344:	3b0b3a0e 	blcc	2ceb84 <__bss_end+0x2c4f9c>
 348:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 34c:	06000013 			; <UNDEFINED> instruction: 0x06000013
 350:	0e030113 	mcreq	1, 0, r0, cr3, cr3, {0}
 354:	0b3a0b0b 	bleq	e82f88 <__bss_end+0xe793a0>
 358:	0b390b3b 	bleq	e4304c <__bss_end+0xe39464>
 35c:	00001301 	andeq	r1, r0, r1, lsl #6
 360:	03000d07 	movweq	r0, #3335	; 0xd07
 364:	3b0b3a08 	blcc	2ceb8c <__bss_end+0x2c4fa4>
 368:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 36c:	000b3813 	andeq	r3, fp, r3, lsl r8
 370:	01040800 	tsteq	r4, r0, lsl #16
 374:	196d0e03 	stmdbne	sp!, {r0, r1, r9, sl, fp}^
 378:	0b0b0b3e 	bleq	2c3078 <__bss_end+0x2b9490>
 37c:	0b3a1349 	bleq	e850a8 <__bss_end+0xe7b4c0>
 380:	0b390b3b 	bleq	e43074 <__bss_end+0xe3948c>
 384:	00001301 	andeq	r1, r0, r1, lsl #6
 388:	03002809 	movweq	r2, #2057	; 0x809
 38c:	000b1c08 	andeq	r1, fp, r8, lsl #24
 390:	00280a00 	eoreq	r0, r8, r0, lsl #20
 394:	0b1c0e03 	bleq	703ba8 <__bss_end+0x6f9fc0>
 398:	340b0000 	strcc	r0, [fp], #-0
 39c:	3a0e0300 	bcc	380fa4 <__bss_end+0x3773bc>
 3a0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 3a4:	6c13490b 			; <UNDEFINED> instruction: 0x6c13490b
 3a8:	00180219 	andseq	r0, r8, r9, lsl r2
 3ac:	00020c00 	andeq	r0, r2, r0, lsl #24
 3b0:	193c0e03 	ldmdbne	ip!, {r0, r1, r9, sl, fp}
 3b4:	0f0d0000 	svceq	0x000d0000
 3b8:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
 3bc:	0e000013 	mcreq	0, 0, r0, cr0, cr3, {0}
 3c0:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
 3c4:	0b3b0b3a 	bleq	ec30b4 <__bss_end+0xeb94cc>
 3c8:	13490b39 	movtne	r0, #39737	; 0x9b39
 3cc:	00000b38 	andeq	r0, r0, r8, lsr fp
 3d0:	4901010f 	stmdbmi	r1, {r0, r1, r2, r3, r8}
 3d4:	00130113 	andseq	r0, r3, r3, lsl r1
 3d8:	00211000 	eoreq	r1, r1, r0
 3dc:	0b2f1349 	bleq	bc5108 <__bss_end+0xbbb520>
 3e0:	02110000 	andseq	r0, r1, #0
 3e4:	0b0e0301 	bleq	380ff0 <__bss_end+0x377408>
 3e8:	3b0b3a0b 	blcc	2cec1c <__bss_end+0x2c5034>
 3ec:	010b390b 	tsteq	fp, fp, lsl #18
 3f0:	12000013 	andne	r0, r0, #19
 3f4:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 3f8:	0b3a0e03 	bleq	e83c0c <__bss_end+0xe7a024>
 3fc:	0b390b3b 	bleq	e430f0 <__bss_end+0xe39508>
 400:	193c0e6e 	ldmdbne	ip!, {r1, r2, r3, r5, r6, r9, sl, fp}
 404:	13011364 	movwne	r1, #4964	; 0x1364
 408:	05130000 	ldreq	r0, [r3, #-0]
 40c:	34134900 	ldrcc	r4, [r3], #-2304	; 0xfffff700
 410:	14000019 	strne	r0, [r0], #-25	; 0xffffffe7
 414:	13490005 	movtne	r0, #36869	; 0x9005
 418:	2e150000 	cdpcs	0, 1, cr0, cr5, cr0, {0}
 41c:	03193f01 	tsteq	r9, #1, 30
 420:	3b0b3a0e 	blcc	2cec60 <__bss_end+0x2c5078>
 424:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 428:	3c13490e 			; <UNDEFINED> instruction: 0x3c13490e
 42c:	01136419 	tsteq	r3, r9, lsl r4
 430:	16000013 			; <UNDEFINED> instruction: 0x16000013
 434:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 438:	0b3a0e03 	bleq	e83c4c <__bss_end+0xe7a064>
 43c:	0b390b3b 	bleq	e43130 <__bss_end+0xe39548>
 440:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 444:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 448:	13011364 	movwne	r1, #4964	; 0x1364
 44c:	0d170000 	ldceq	0, cr0, [r7, #-0]
 450:	3a0e0300 	bcc	381058 <__bss_end+0x377470>
 454:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 458:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 45c:	000b320b 	andeq	r3, fp, fp, lsl #4
 460:	012e1800 			; <UNDEFINED> instruction: 0x012e1800
 464:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 468:	0b3b0b3a 	bleq	ec3158 <__bss_end+0xeb9570>
 46c:	0e6e0b39 	vmoveq.8	d14[5], r0
 470:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 474:	13011364 	movwne	r1, #4964	; 0x1364
 478:	2e190000 	cdpcs	0, 1, cr0, cr9, cr0, {0}
 47c:	03193f01 	tsteq	r9, #1, 30
 480:	3b0b3a0e 	blcc	2cecc0 <__bss_end+0x2c50d8>
 484:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 488:	3213490e 	andscc	r4, r3, #229376	; 0x38000
 48c:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
 490:	1a000013 	bne	4e4 <shift+0x4e4>
 494:	13490115 	movtne	r0, #37141	; 0x9115
 498:	13011364 	movwne	r1, #4964	; 0x1364
 49c:	1f1b0000 	svcne	0x001b0000
 4a0:	49131d00 	ldmdbmi	r3, {r8, sl, fp, ip}
 4a4:	1c000013 	stcne	0, cr0, [r0], {19}
 4a8:	0b0b0010 	bleq	2c04f0 <__bss_end+0x2b6908>
 4ac:	00001349 	andeq	r1, r0, r9, asr #6
 4b0:	0b000f1d 	bleq	412c <shift+0x412c>
 4b4:	1e00000b 	cdpne	0, 0, cr0, cr0, cr11, {0}
 4b8:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 4bc:	0b3b0b3a 	bleq	ec31ac <__bss_end+0xeb95c4>
 4c0:	13490b39 	movtne	r0, #39737	; 0x9b39
 4c4:	00001802 	andeq	r1, r0, r2, lsl #16
 4c8:	3f012e1f 	svccc	0x00012e1f
 4cc:	3a0e0319 	bcc	381138 <__bss_end+0x377550>
 4d0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 4d4:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 4d8:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
 4dc:	96184006 	ldrls	r4, [r8], -r6
 4e0:	13011942 	movwne	r1, #6466	; 0x1942
 4e4:	05200000 	streq	r0, [r0, #-0]!
 4e8:	3a0e0300 	bcc	3810f0 <__bss_end+0x377508>
 4ec:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 4f0:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 4f4:	21000018 	tstcs	r0, r8, lsl r0
 4f8:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 4fc:	0b3a0e03 	bleq	e83d10 <__bss_end+0xe7a128>
 500:	0b390b3b 	bleq	e431f4 <__bss_end+0xe3960c>
 504:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 508:	06120111 			; <UNDEFINED> instruction: 0x06120111
 50c:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 510:	00130119 	andseq	r0, r3, r9, lsl r1
 514:	00342200 	eorseq	r2, r4, r0, lsl #4
 518:	0b3a0803 	bleq	e8252c <__bss_end+0xe78944>
 51c:	0b390b3b 	bleq	e43210 <__bss_end+0xe39628>
 520:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 524:	2e230000 	cdpcs	0, 2, cr0, cr3, cr0, {0}
 528:	03193f01 	tsteq	r9, #1, 30
 52c:	3b0b3a0e 	blcc	2ced6c <__bss_end+0x2c5184>
 530:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 534:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 538:	97184006 	ldrls	r4, [r8, -r6]
 53c:	13011942 	movwne	r1, #6466	; 0x1942
 540:	2e240000 	cdpcs	0, 2, cr0, cr4, cr0, {0}
 544:	03193f00 	tsteq	r9, #0, 30
 548:	3b0b3a0e 	blcc	2ced88 <__bss_end+0x2c51a0>
 54c:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 550:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 554:	97184006 	ldrls	r4, [r8, -r6]
 558:	00001942 	andeq	r1, r0, r2, asr #18
 55c:	3f012e25 	svccc	0x00012e25
 560:	3a0e0319 	bcc	3811cc <__bss_end+0x3775e4>
 564:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 568:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 56c:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
 570:	97184006 	ldrls	r4, [r8, -r6]
 574:	00001942 	andeq	r1, r0, r2, asr #18
 578:	01110100 	tsteq	r1, r0, lsl #2
 57c:	0b130e25 	bleq	4c3e18 <__bss_end+0x4ba230>
 580:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
 584:	06120111 			; <UNDEFINED> instruction: 0x06120111
 588:	00001710 	andeq	r1, r0, r0, lsl r7
 58c:	01013902 	tsteq	r1, r2, lsl #18
 590:	03000013 	movweq	r0, #19
 594:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 598:	0b3b0b3a 	bleq	ec3288 <__bss_end+0xeb96a0>
 59c:	13490b39 	movtne	r0, #39737	; 0x9b39
 5a0:	0a1c193c 	beq	706a98 <__bss_end+0x6fceb0>
 5a4:	3a040000 	bcc	1005ac <__bss_end+0xf69c4>
 5a8:	3b0b3a00 	blcc	2cedb0 <__bss_end+0x2c51c8>
 5ac:	180b390b 	stmdane	fp, {r0, r1, r3, r8, fp, ip, sp}
 5b0:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
 5b4:	13490101 	movtne	r0, #37121	; 0x9101
 5b8:	00001301 	andeq	r1, r0, r1, lsl #6
 5bc:	49002106 	stmdbmi	r0, {r1, r2, r8, sp}
 5c0:	000b2f13 	andeq	r2, fp, r3, lsl pc
 5c4:	00260700 	eoreq	r0, r6, r0, lsl #14
 5c8:	00001349 	andeq	r1, r0, r9, asr #6
 5cc:	0b002408 	bleq	95f4 <__udivsi3+0x190>
 5d0:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 5d4:	0900000e 	stmdbeq	r0, {r1, r2, r3}
 5d8:	13470034 	movtne	r0, #28724	; 0x7034
 5dc:	2e0a0000 	cdpcs	0, 0, cr0, cr10, cr0, {0}
 5e0:	03193f01 	tsteq	r9, #1, 30
 5e4:	3b0b3a0e 	blcc	2cee24 <__bss_end+0x2c523c>
 5e8:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 5ec:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 5f0:	96184006 	ldrls	r4, [r8], -r6
 5f4:	13011942 	movwne	r1, #6466	; 0x1942
 5f8:	050b0000 	streq	r0, [fp, #-0]
 5fc:	3a080300 	bcc	201204 <__bss_end+0x1f761c>
 600:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 604:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 608:	0c000018 	stceq	0, cr0, [r0], {24}
 60c:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 610:	0b3b0b3a 	bleq	ec3300 <__bss_end+0xeb9718>
 614:	13490b39 	movtne	r0, #39737	; 0x9b39
 618:	00001802 	andeq	r1, r0, r2, lsl #16
 61c:	0300340d 	movweq	r3, #1037	; 0x40d
 620:	3b0b3a08 	blcc	2cee48 <__bss_end+0x2c5260>
 624:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 628:	00180213 	andseq	r0, r8, r3, lsl r2
 62c:	000f0e00 	andeq	r0, pc, r0, lsl #28
 630:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 634:	2e0f0000 	cdpcs	0, 0, cr0, cr15, cr0, {0}
 638:	03193f01 	tsteq	r9, #1, 30
 63c:	3b0b3a0e 	blcc	2cee7c <__bss_end+0x2c5294>
 640:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 644:	1113490e 	tstne	r3, lr, lsl #18
 648:	40061201 	andmi	r1, r6, r1, lsl #4
 64c:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
 650:	00001301 	andeq	r1, r0, r1, lsl #6
 654:	03000510 	movweq	r0, #1296	; 0x510
 658:	3b0b3a0e 	blcc	2cee98 <__bss_end+0x2c52b0>
 65c:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 660:	00180213 	andseq	r0, r8, r3, lsl r2
 664:	00241100 	eoreq	r1, r4, r0, lsl #2
 668:	0b3e0b0b 	bleq	f8329c <__bss_end+0xf796b4>
 66c:	00000803 	andeq	r0, r0, r3, lsl #16
 670:	3f012e12 	svccc	0x00012e12
 674:	3a0e0319 	bcc	3812e0 <__bss_end+0x3776f8>
 678:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 67c:	110e6e0b 	tstne	lr, fp, lsl #28
 680:	40061201 	andmi	r1, r6, r1, lsl #4
 684:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
 688:	00001301 	andeq	r1, r0, r1, lsl #6
 68c:	11010b13 	tstne	r1, r3, lsl fp
 690:	00061201 	andeq	r1, r6, r1, lsl #4
 694:	00261400 	eoreq	r1, r6, r0, lsl #8
 698:	0f150000 	svceq	0x00150000
 69c:	000b0b00 	andeq	r0, fp, r0, lsl #22
 6a0:	012e1600 			; <UNDEFINED> instruction: 0x012e1600
 6a4:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 6a8:	0b3b0b3a 	bleq	ec3398 <__bss_end+0xeb97b0>
 6ac:	0e6e0b39 	vmoveq.8	d14[5], r0
 6b0:	01111349 	tsteq	r1, r9, asr #6
 6b4:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 6b8:	01194296 			; <UNDEFINED> instruction: 0x01194296
 6bc:	17000013 	smladne	r0, r3, r0, r0
 6c0:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 6c4:	0b3a0e03 	bleq	e83ed8 <__bss_end+0xe7a2f0>
 6c8:	0b390b3b 	bleq	e433bc <__bss_end+0xe397d4>
 6cc:	01110e6e 	tsteq	r1, lr, ror #28
 6d0:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 6d4:	00194296 	mulseq	r9, r6, r2
 6d8:	11010000 	mrsne	r0, (UNDEF: 1)
 6dc:	11061000 	mrsne	r1, (UNDEF: 6)
 6e0:	03011201 	movweq	r1, #4609	; 0x1201
 6e4:	250e1b0e 	strcs	r1, [lr, #-2830]	; 0xfffff4f2
 6e8:	0005130e 	andeq	r1, r5, lr, lsl #6
 6ec:	11010000 	mrsne	r0, (UNDEF: 1)
 6f0:	11061000 	mrsne	r1, (UNDEF: 6)
 6f4:	03011201 	movweq	r1, #4609	; 0x1201
 6f8:	250e1b0e 	strcs	r1, [lr, #-2830]	; 0xfffff4f2
 6fc:	0005130e 	andeq	r1, r5, lr, lsl #6
 700:	11010000 	mrsne	r0, (UNDEF: 1)
 704:	11061000 	mrsne	r1, (UNDEF: 6)
 708:	03011201 	movweq	r1, #4609	; 0x1201
 70c:	250e1b0e 	strcs	r1, [lr, #-2830]	; 0xfffff4f2
 710:	0005130e 	andeq	r1, r5, lr, lsl #6
 714:	11010000 	mrsne	r0, (UNDEF: 1)
 718:	11061000 	mrsne	r1, (UNDEF: 6)
 71c:	03011201 	movweq	r1, #4609	; 0x1201
 720:	250e1b0e 	strcs	r1, [lr, #-2830]	; 0xfffff4f2
 724:	0005130e 	andeq	r1, r5, lr, lsl #6
 728:	11010000 	mrsne	r0, (UNDEF: 1)
 72c:	130e2501 	movwne	r2, #58625	; 0xe501
 730:	1b0e030b 	blne	381364 <__bss_end+0x37777c>
 734:	0017100e 	andseq	r1, r7, lr
 738:	00240200 	eoreq	r0, r4, r0, lsl #4
 73c:	0b3e0b0b 	bleq	f83370 <__bss_end+0xf79788>
 740:	00000803 	andeq	r0, r0, r3, lsl #16
 744:	0b002403 	bleq	9758 <__addsf3+0xd8>
 748:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 74c:	0400000e 	streq	r0, [r0], #-14
 750:	0e030104 	adfeqs	f0, f3, f4
 754:	0b0b0b3e 	bleq	2c3454 <__bss_end+0x2b986c>
 758:	0b3a1349 	bleq	e85484 <__bss_end+0xe7b89c>
 75c:	0b390b3b 	bleq	e43450 <__bss_end+0xe39868>
 760:	00001301 	andeq	r1, r0, r1, lsl #6
 764:	03002805 	movweq	r2, #2053	; 0x805
 768:	000b1c0e 	andeq	r1, fp, lr, lsl #24
 76c:	01130600 	tsteq	r3, r0, lsl #12
 770:	0b0b0e03 	bleq	2c3f84 <__bss_end+0x2ba39c>
 774:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 778:	13010b39 	movwne	r0, #6969	; 0x1b39
 77c:	0d070000 	stceq	0, cr0, [r7, #-0]
 780:	3a0e0300 	bcc	381388 <__bss_end+0x3777a0>
 784:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 788:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 78c:	0800000b 	stmdaeq	r0, {r0, r1, r3}
 790:	13490026 	movtne	r0, #36902	; 0x9026
 794:	01090000 	mrseq	r0, (UNDEF: 9)
 798:	01134901 	tsteq	r3, r1, lsl #18
 79c:	0a000013 	beq	7f0 <shift+0x7f0>
 7a0:	13490021 	movtne	r0, #36897	; 0x9021
 7a4:	00000b2f 	andeq	r0, r0, pc, lsr #22
 7a8:	0300340b 	movweq	r3, #1035	; 0x40b
 7ac:	3b0b3a0e 	blcc	2cefec <__bss_end+0x2c5404>
 7b0:	490b3905 	stmdbmi	fp, {r0, r2, r8, fp, ip, sp}
 7b4:	000a1c13 	andeq	r1, sl, r3, lsl ip
 7b8:	00150c00 	andseq	r0, r5, r0, lsl #24
 7bc:	00001927 	andeq	r1, r0, r7, lsr #18
 7c0:	0b000f0d 	bleq	43fc <shift+0x43fc>
 7c4:	0013490b 	andseq	r4, r3, fp, lsl #18
 7c8:	01040e00 	tsteq	r4, r0, lsl #28
 7cc:	0b3e0e03 	bleq	f83fe0 <__bss_end+0xf7a3f8>
 7d0:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 7d4:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 7d8:	13010b39 	movwne	r0, #6969	; 0x1b39
 7dc:	160f0000 	strne	r0, [pc], -r0
 7e0:	3a0e0300 	bcc	3813e8 <__bss_end+0x377800>
 7e4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 7e8:	0013490b 	andseq	r4, r3, fp, lsl #18
 7ec:	00211000 	eoreq	r1, r1, r0
 7f0:	34110000 	ldrcc	r0, [r1], #-0
 7f4:	3a0e0300 	bcc	3813fc <__bss_end+0x377814>
 7f8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 7fc:	3f13490b 	svccc	0x0013490b
 800:	00193c19 	andseq	r3, r9, r9, lsl ip
 804:	00341200 	eorseq	r1, r4, r0, lsl #4
 808:	0b3a1347 	bleq	e8552c <__bss_end+0xe7b944>
 80c:	0b39053b 	bleq	e41d00 <__bss_end+0xe38118>
 810:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 814:	01000000 	mrseq	r0, (UNDEF: 0)
 818:	0e250111 	mcreq	1, 1, r0, cr5, cr1, {0}
 81c:	0e030b13 	vmoveq.32	d3[0], r0
 820:	01110e1b 	tsteq	r1, fp, lsl lr
 824:	17100612 			; <UNDEFINED> instruction: 0x17100612
 828:	24020000 	strcs	r0, [r2], #-0
 82c:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 830:	000e030b 	andeq	r0, lr, fp, lsl #6
 834:	00240300 	eoreq	r0, r4, r0, lsl #6
 838:	0b3e0b0b 	bleq	f8346c <__bss_end+0xf79884>
 83c:	00000803 	andeq	r0, r0, r3, lsl #16
 840:	03010404 	movweq	r0, #5124	; 0x1404
 844:	0b0b3e0e 	bleq	2d0084 <__bss_end+0x2c649c>
 848:	3a13490b 	bcc	4d2c7c <__bss_end+0x4c9094>
 84c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 850:	0013010b 	andseq	r0, r3, fp, lsl #2
 854:	00280500 	eoreq	r0, r8, r0, lsl #10
 858:	0b1c0e03 	bleq	70406c <__bss_end+0x6fa484>
 85c:	13060000 	movwne	r0, #24576	; 0x6000
 860:	0b0e0301 	bleq	38146c <__bss_end+0x377884>
 864:	3b0b3a0b 	blcc	2cf098 <__bss_end+0x2c54b0>
 868:	010b3905 	tsteq	fp, r5, lsl #18
 86c:	07000013 	smladeq	r0, r3, r0, r0
 870:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
 874:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 878:	13490b39 	movtne	r0, #39737	; 0x9b39
 87c:	00000b38 	andeq	r0, r0, r8, lsr fp
 880:	49002608 	stmdbmi	r0, {r3, r9, sl, sp}
 884:	09000013 	stmdbeq	r0, {r0, r1, r4}
 888:	13490101 	movtne	r0, #37121	; 0x9101
 88c:	00001301 	andeq	r1, r0, r1, lsl #6
 890:	4900210a 	stmdbmi	r0, {r1, r3, r8, sp}
 894:	000b2f13 	andeq	r2, fp, r3, lsl pc
 898:	00340b00 	eorseq	r0, r4, r0, lsl #22
 89c:	0b3a0e03 	bleq	e840b0 <__bss_end+0xe7a4c8>
 8a0:	0b39053b 	bleq	e41d94 <__bss_end+0xe381ac>
 8a4:	0a1c1349 	beq	7055d0 <__bss_end+0x6fb9e8>
 8a8:	160c0000 	strne	r0, [ip], -r0
 8ac:	3a0e0300 	bcc	3814b4 <__bss_end+0x3778cc>
 8b0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 8b4:	0013490b 	andseq	r4, r3, fp, lsl #18
 8b8:	012e0d00 			; <UNDEFINED> instruction: 0x012e0d00
 8bc:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 8c0:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 8c4:	19270b39 	stmdbne	r7!, {r0, r3, r4, r5, r8, r9, fp}
 8c8:	01111349 	tsteq	r1, r9, asr #6
 8cc:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 8d0:	01194297 			; <UNDEFINED> instruction: 0x01194297
 8d4:	0e000013 	mcreq	0, 0, r0, cr0, cr3, {0}
 8d8:	08030005 	stmdaeq	r3, {r0, r2}
 8dc:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 8e0:	13490b39 	movtne	r0, #39737	; 0x9b39
 8e4:	42b71702 	adcsmi	r1, r7, #524288	; 0x80000
 8e8:	0f000017 	svceq	0x00000017
 8ec:	01018289 	smlabbeq	r1, r9, r2, r8
 8f0:	42950111 	addsmi	r0, r5, #1073741828	; 0x40000004
 8f4:	01133119 	tsteq	r3, r9, lsl r1
 8f8:	10000013 	andne	r0, r0, r3, lsl r0
 8fc:	0001828a 	andeq	r8, r1, sl, lsl #5
 900:	42911802 	addsmi	r1, r1, #131072	; 0x20000
 904:	11000018 	tstne	r0, r8, lsl r0
 908:	01018289 	smlabbeq	r1, r9, r2, r8
 90c:	13310111 	teqne	r1, #1073741828	; 0x40000004
 910:	2e120000 	cdpcs	0, 1, cr0, cr2, cr0, {0}
 914:	3c193f00 	ldccc	15, cr3, [r9], {-0}
 918:	030e6e19 	movweq	r6, #60953	; 0xee19
 91c:	3b0b3a0e 	blcc	2cf15c <__bss_end+0x2c5574>
 920:	000b390b 	andeq	r3, fp, fp, lsl #18
 924:	11010000 	mrsne	r0, (UNDEF: 1)
 928:	130e2501 	movwne	r2, #58625	; 0xe501
 92c:	1b0e030b 	blne	381560 <__bss_end+0x377978>
 930:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 934:	00171006 	andseq	r1, r7, r6
 938:	00240200 	eoreq	r0, r4, r0, lsl #4
 93c:	0b3e0b0b 	bleq	f83570 <__bss_end+0xf79988>
 940:	00000e03 	andeq	r0, r0, r3, lsl #28
 944:	0b002403 	bleq	9958 <__aeabi_ldivmod+0x94>
 948:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 94c:	04000008 	streq	r0, [r0], #-8
 950:	0e030104 	adfeqs	f0, f3, f4
 954:	0b0b0b3e 	bleq	2c3654 <__bss_end+0x2b9a6c>
 958:	0b3a1349 	bleq	e85684 <__bss_end+0xe7ba9c>
 95c:	0b390b3b 	bleq	e43650 <__bss_end+0xe39a68>
 960:	00001301 	andeq	r1, r0, r1, lsl #6
 964:	03002805 	movweq	r2, #2053	; 0x805
 968:	000b1c0e 	andeq	r1, fp, lr, lsl #24
 96c:	01130600 	tsteq	r3, r0, lsl #12
 970:	0b0b0e03 	bleq	2c4184 <__bss_end+0x2ba59c>
 974:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 978:	13010b39 	movwne	r0, #6969	; 0x1b39
 97c:	0d070000 	stceq	0, cr0, [r7, #-0]
 980:	3a0e0300 	bcc	381588 <__bss_end+0x3779a0>
 984:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 988:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 98c:	0800000b 	stmdaeq	r0, {r0, r1, r3}
 990:	13490026 	movtne	r0, #36902	; 0x9026
 994:	01090000 	mrseq	r0, (UNDEF: 9)
 998:	01134901 	tsteq	r3, r1, lsl #18
 99c:	0a000013 	beq	9f0 <shift+0x9f0>
 9a0:	13490021 	movtne	r0, #36897	; 0x9021
 9a4:	00000b2f 	andeq	r0, r0, pc, lsr #22
 9a8:	0300340b 	movweq	r3, #1035	; 0x40b
 9ac:	3b0b3a0e 	blcc	2cf1ec <__bss_end+0x2c5604>
 9b0:	490b3905 	stmdbmi	fp, {r0, r2, r8, fp, ip, sp}
 9b4:	000a1c13 	andeq	r1, sl, r3, lsl ip
 9b8:	00160c00 	andseq	r0, r6, r0, lsl #24
 9bc:	0b3a0e03 	bleq	e841d0 <__bss_end+0xe7a5e8>
 9c0:	0b390b3b 	bleq	e436b4 <__bss_end+0xe39acc>
 9c4:	00001349 	andeq	r1, r0, r9, asr #6
 9c8:	3f012e0d 	svccc	0x00012e0d
 9cc:	3a0e0319 	bcc	381638 <__bss_end+0x377a50>
 9d0:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 9d4:	4919270b 	ldmdbmi	r9, {r0, r1, r3, r8, r9, sl, sp}
 9d8:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
 9dc:	97184006 	ldrls	r4, [r8, -r6]
 9e0:	00001942 	andeq	r1, r0, r2, asr #18
 9e4:	0300050e 	movweq	r0, #1294	; 0x50e
 9e8:	3b0b3a08 	blcc	2cf210 <__bss_end+0x2c5628>
 9ec:	490b3905 	stmdbmi	fp, {r0, r2, r8, fp, ip, sp}
 9f0:	b7170213 			; <UNDEFINED> instruction: 0xb7170213
 9f4:	00001742 	andeq	r1, r0, r2, asr #14
 9f8:	0300340f 	movweq	r3, #1039	; 0x40f
 9fc:	3b0b3a08 	blcc	2cf224 <__bss_end+0x2c563c>
 a00:	490b3905 	stmdbmi	fp, {r0, r2, r8, fp, ip, sp}
 a04:	b7170213 			; <UNDEFINED> instruction: 0xb7170213
 a08:	00001742 	andeq	r1, r0, r2, asr #14
 a0c:	01110100 	tsteq	r1, r0, lsl #2
 a10:	0b130e25 	bleq	4c42ac <__bss_end+0x4ba6c4>
 a14:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
 a18:	06120111 			; <UNDEFINED> instruction: 0x06120111
 a1c:	00001710 	andeq	r1, r0, r0, lsl r7
 a20:	0b002402 	bleq	9a30 <__udivmoddi4+0x28>
 a24:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 a28:	0300000e 	movweq	r0, #14
 a2c:	0b0b0024 	bleq	2c0ac4 <__bss_end+0x2b6edc>
 a30:	08030b3e 	stmdaeq	r3, {r1, r2, r3, r4, r5, r8, r9, fp}
 a34:	04040000 	streq	r0, [r4], #-0
 a38:	3e0e0301 	cdpcc	3, 0, cr0, cr14, cr1, {0}
 a3c:	490b0b0b 	stmdbmi	fp, {r0, r1, r3, r8, r9, fp}
 a40:	3b0b3a13 	blcc	2cf294 <__bss_end+0x2c56ac>
 a44:	010b390b 	tsteq	fp, fp, lsl #18
 a48:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
 a4c:	0e030028 	cdpeq	0, 0, cr0, cr3, cr8, {1}
 a50:	00000b1c 	andeq	r0, r0, ip, lsl fp
 a54:	03011306 	movweq	r1, #4870	; 0x1306
 a58:	3a0b0b0e 	bcc	2c3698 <__bss_end+0x2b9ab0>
 a5c:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 a60:	0013010b 	andseq	r0, r3, fp, lsl #2
 a64:	000d0700 	andeq	r0, sp, r0, lsl #14
 a68:	0b3a0e03 	bleq	e8427c <__bss_end+0xe7a694>
 a6c:	0b39053b 	bleq	e41f60 <__bss_end+0xe38378>
 a70:	0b381349 	bleq	e0579c <__bss_end+0xdfbbb4>
 a74:	26080000 	strcs	r0, [r8], -r0
 a78:	00134900 	andseq	r4, r3, r0, lsl #18
 a7c:	01010900 	tsteq	r1, r0, lsl #18
 a80:	13011349 	movwne	r1, #4937	; 0x1349
 a84:	210a0000 	mrscs	r0, (UNDEF: 10)
 a88:	2f134900 	svccs	0x00134900
 a8c:	0b00000b 	bleq	ac0 <shift+0xac0>
 a90:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 a94:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 a98:	13490b39 	movtne	r0, #39737	; 0x9b39
 a9c:	00000a1c 	andeq	r0, r0, ip, lsl sl
 aa0:	0300160c 	movweq	r1, #1548	; 0x60c
 aa4:	3b0b3a0e 	blcc	2cf2e4 <__bss_end+0x2c56fc>
 aa8:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 aac:	0d000013 	stceq	0, cr0, [r0, #-76]	; 0xffffffb4
 ab0:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 ab4:	0b3a0e03 	bleq	e842c8 <__bss_end+0xe7a6e0>
 ab8:	0b39053b 	bleq	e41fac <__bss_end+0xe383c4>
 abc:	13491927 	movtne	r1, #39207	; 0x9927
 ac0:	06120111 			; <UNDEFINED> instruction: 0x06120111
 ac4:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 ac8:	00130119 	andseq	r0, r3, r9, lsl r1
 acc:	00050e00 	andeq	r0, r5, r0, lsl #28
 ad0:	0b3a0803 	bleq	e82ae4 <__bss_end+0xe78efc>
 ad4:	0b39053b 	bleq	e41fc8 <__bss_end+0xe383e0>
 ad8:	17021349 	strne	r1, [r2, -r9, asr #6]
 adc:	001742b7 			; <UNDEFINED> instruction: 0x001742b7
 ae0:	00050f00 	andeq	r0, r5, r0, lsl #30
 ae4:	0b3a0803 	bleq	e82af8 <__bss_end+0xe78f10>
 ae8:	0b39053b 	bleq	e41fdc <__bss_end+0xe383f4>
 aec:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 af0:	34100000 	ldrcc	r0, [r0], #-0
 af4:	3a080300 	bcc	2016fc <__bss_end+0x1f7b14>
 af8:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 afc:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 b00:	1742b717 	smlaldne	fp, r2, r7, r7
 b04:	0f110000 	svceq	0x00110000
 b08:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
 b0c:	00000013 	andeq	r0, r0, r3, lsl r0

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
  74:	00000180 	andeq	r0, r0, r0, lsl #3
	...
  80:	0000001c 	andeq	r0, r0, ip, lsl r0
  84:	06370002 	ldrteq	r0, [r7], -r2
  88:	00040000 	andeq	r0, r4, r0
  8c:	00000000 	andeq	r0, r0, r0
  90:	000083ac 	andeq	r8, r0, ip, lsr #7
  94:	0000045c 	andeq	r0, r0, ip, asr r4
	...
  a0:	0000001c 	andeq	r0, r0, ip, lsl r0
  a4:	11cc0002 	bicne	r0, ip, r2
  a8:	00040000 	andeq	r0, r4, r0
  ac:	00000000 	andeq	r0, r0, r0
  b0:	00008808 	andeq	r8, r0, r8, lsl #16
  b4:	00000c5c 	andeq	r0, r0, ip, asr ip
	...
  c0:	0000001c 	andeq	r0, r0, ip, lsl r0
  c4:	17fd0002 	ldrbne	r0, [sp, r2]!
  c8:	00040000 	andeq	r0, r4, r0
  cc:	00000000 	andeq	r0, r0, r0
  d0:	00009464 	andeq	r9, r0, r4, ror #8
  d4:	0000020c 	andeq	r0, r0, ip, lsl #4
	...
  e0:	0000001c 	andeq	r0, r0, ip, lsl r0
  e4:	18230002 	stmdane	r3!, {r1}
  e8:	00040000 	andeq	r0, r4, r0
  ec:	00000000 	andeq	r0, r0, r0
  f0:	00009670 	andeq	r9, r0, r0, ror r6
  f4:	00000004 	andeq	r0, r0, r4
	...
 100:	0000001c 	andeq	r0, r0, ip, lsl r0
 104:	18490002 	stmdane	r9, {r1}^
 108:	00040000 	andeq	r0, r4, r0
 10c:	00000000 	andeq	r0, r0, r0
 110:	00009674 	andeq	r9, r0, r4, ror r6
 114:	00000250 	andeq	r0, r0, r0, asr r2
	...
 120:	0000001c 	andeq	r0, r0, ip, lsl r0
 124:	186f0002 	stmdane	pc!, {r1}^	; <UNPREDICTABLE>
 128:	00040000 	andeq	r0, r4, r0
 12c:	00000000 	andeq	r0, r0, r0
 130:	000098c4 	andeq	r9, r0, r4, asr #17
 134:	000000d4 	ldrdeq	r0, [r0], -r4
	...
 140:	00000014 	andeq	r0, r0, r4, lsl r0
 144:	18950002 	ldmne	r5, {r1}
 148:	00040000 	andeq	r0, r4, r0
	...
 158:	0000001c 	andeq	r0, r0, ip, lsl r0
 15c:	1bc30002 	blne	ff0c016c <__bss_end+0xff0b6584>
 160:	00040000 	andeq	r0, r4, r0
 164:	00000000 	andeq	r0, r0, r0
 168:	00009998 	muleq	r0, r8, r9
 16c:	00000030 	andeq	r0, r0, r0, lsr r0
	...
 178:	0000001c 	andeq	r0, r0, ip, lsl r0
 17c:	1ecd0002 	cdpne	0, 12, cr0, cr13, cr2, {0}
 180:	00040000 	andeq	r0, r4, r0
 184:	00000000 	andeq	r0, r0, r0
 188:	000099c8 	andeq	r9, r0, r8, asr #19
 18c:	00000040 	andeq	r0, r0, r0, asr #32
	...
 198:	0000001c 	andeq	r0, r0, ip, lsl r0
 19c:	21fb0002 	mvnscs	r0, r2
 1a0:	00040000 	andeq	r0, r4, r0
 1a4:	00000000 	andeq	r0, r0, r0
 1a8:	00009a08 	andeq	r9, r0, r8, lsl #20
 1ac:	00000120 	andeq	r0, r0, r0, lsr #2
	...

Disassembly of section .debug_str:

00000000 <.debug_str>:
       0:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; ffffff4c <__bss_end+0xffff6364>
       4:	72742f65 	rsbsvc	r2, r4, #404	; 0x194
       8:	6c696665 	stclvs	6, cr6, [r9], #-404	; 0xfffffe6c
       c:	6d65732f 	stclvs	3, cr7, [r5, #-188]!	; 0xffffff44
      10:	756f732f 	strbvc	r7, [pc, #-815]!	; fffffce9 <__bss_end+0xffff6101>
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
      40:	752f7365 	strvc	r7, [pc, #-869]!	; fffffce3 <__bss_end+0xffff60fb>
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
      dc:	2b6b7a36 	blcs	1ade9bc <__bss_end+0x1ad4dd4>
      e0:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
      e4:	672d2067 	strvs	r2, [sp, -r7, rrx]!
      e8:	304f2d20 	subcc	r2, pc, r0, lsr #26
      ec:	304f2d20 	subcc	r2, pc, r0, lsr #26
      f0:	625f5f00 	subsvs	r5, pc, #0, 30
      f4:	655f7373 	ldrbvs	r7, [pc, #-883]	; fffffd89 <__bss_end+0xffff61a1>
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
     160:	755f6962 	ldrbvc	r6, [pc, #-2402]	; fffff806 <__bss_end+0xffff5c1e>
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
     260:	2b432055 	blcs	10c83bc <__bss_end+0x10be7d4>
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
     2c4:	7a6a3637 	bvc	1a8dba8 <__bss_end+0x1a83fc0>
     2c8:	20732d66 	rsbscs	r2, r3, r6, ror #26
     2cc:	72616d2d 	rsbvc	r6, r1, #2880	; 0xb40
     2d0:	6d2d206d 	stcvs	0, cr2, [sp, #-436]!	; 0xfffffe4c
     2d4:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
     2d8:	6d72613d 	ldfvse	f6, [r2, #-244]!	; 0xffffff0c
     2dc:	6b7a3676 	blvs	1e8dcbc <__bss_end+0x1e840d4>
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
     334:	49006572 	stmdbmi	r0, {r1, r4, r5, r6, r8, sl, sp, lr}
     338:	6665646e 	strbtvs	r6, [r5], -lr, ror #8
     33c:	74696e69 	strbtvc	r6, [r9], #-3689	; 0xfffff197
     340:	74730065 	ldrbtvc	r0, [r3], #-101	; 0xffffff9b
     344:	676e6972 			; <UNDEFINED> instruction: 0x676e6972
     348:	5f524200 	svcpl	0x00524200
     34c:	30303432 	eorscc	r3, r0, r2, lsr r4
     350:	75616200 	strbvc	r6, [r1, #-512]!	; 0xfffffe00
     354:	61725f64 	cmnvs	r2, r4, ror #30
     358:	42006574 	andmi	r6, r0, #116, 10	; 0x1d000000
     35c:	38345f52 	ldmdacc	r4!, {r1, r4, r6, r8, r9, sl, fp, ip, lr}
     360:	6c003030 	stcvs	0, cr3, [r0], {48}	; 0x30
     364:	5f747361 	svcpl	0x00747361
     368:	6b636974 	blvs	18da940 <__bss_end+0x18d0d58>
     36c:	78614d00 	stmdavc	r1!, {r8, sl, fp, lr}^
     370:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     374:	656d616e 	strbvs	r6, [sp, #-366]!	; 0xfffffe92
     378:	676e654c 	strbvs	r6, [lr, -ip, asr #10]!
     37c:	44006874 	strmi	r6, [r0], #-2164	; 0xfffff78c
     380:	6c646165 	stfvse	f6, [r4], #-404	; 0xfffffe6c
     384:	5f656e69 	svcpl	0x00656e69
     388:	68636e55 	stmdavs	r3!, {r0, r2, r4, r6, r9, sl, fp, sp, lr}^
     38c:	65676e61 	strbvs	r6, [r7, #-3681]!	; 0xfffff19f
     390:	6f4e0064 	svcvs	0x004e0064
     394:	79666974 	stmdbvc	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
     398:	006c6c41 	rsbeq	r6, ip, r1, asr #24
     39c:	5241554e 	subpl	r5, r1, #327155712	; 0x13800000
     3a0:	61425f54 	cmpvs	r2, r4, asr pc
     3a4:	525f6475 	subspl	r6, pc, #1962934272	; 0x75000000
     3a8:	00657461 	rsbeq	r7, r5, r1, ror #8
     3ac:	72616843 	rsbvc	r6, r1, #4390912	; 0x430000
     3b0:	4300375f 	movwmi	r3, #1887	; 0x75f
     3b4:	5f726168 	svcpl	0x00726168
     3b8:	614d0038 	cmpvs	sp, r8, lsr r0
     3bc:	72505f78 	subsvc	r5, r0, #120, 30	; 0x1e0
     3c0:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     3c4:	704f5f73 	subvc	r5, pc, r3, ror pc	; <UNPREDICTABLE>
     3c8:	64656e65 	strbtvs	r6, [r5], #-3685	; 0xfffff19b
     3cc:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     3d0:	4e007365 	cdpmi	3, 0, cr7, cr0, cr5, {3}
     3d4:	6c69466f 	stclvs	6, cr4, [r9], #-444	; 0xfffffe44
     3d8:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     3dc:	446d6574 	strbtmi	r6, [sp], #-1396	; 0xfffffa8c
     3e0:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
     3e4:	65530072 	ldrbvs	r0, [r3, #-114]	; 0xffffff8e
     3e8:	61505f74 	cmpvs	r0, r4, ror pc
     3ec:	736d6172 	cmnvc	sp, #-2147483620	; 0x8000001c
     3f0:	6f687300 	svcvs	0x00687300
     3f4:	75207472 	strvc	r7, [r0, #-1138]!	; 0xfffffb8e
     3f8:	6769736e 	strbvs	r7, [r9, -lr, ror #6]!
     3fc:	2064656e 	rsbcs	r6, r4, lr, ror #10
     400:	00746e69 	rsbseq	r6, r4, r9, ror #28
     404:	61736944 	cmnvs	r3, r4, asr #18
     408:	5f656c62 	svcpl	0x00656c62
     40c:	6e657645 	cdpvs	6, 6, cr7, cr5, cr5, {2}
     410:	65445f74 	strbvs	r5, [r4, #-3956]	; 0xfffff08c
     414:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
     418:	006e6f69 	rsbeq	r6, lr, r9, ror #30
     41c:	6c6f6f62 	stclvs	15, cr6, [pc], #-392	; 29c <shift+0x29c>
     420:	5f524200 	svcpl	0x00524200
     424:	30323931 	eorscc	r3, r2, r1, lsr r9
     428:	52420030 	subpl	r0, r2, #48	; 0x30
     42c:	3438335f 	ldrtcc	r3, [r8], #-863	; 0xfffffca1
     430:	4e003030 	mcrmi	0, 0, r3, cr0, cr0, {1}
     434:	54524155 	ldrbpl	r4, [r2], #-341	; 0xfffffeab
     438:	6f6c425f 	svcvs	0x006c425f
     43c:	6e696b63 	vnmulvs.f64	d22, d9, d19
     440:	65525f67 	ldrbvs	r5, [r2, #-3943]	; 0xfffff099
     444:	42006461 	andmi	r6, r0, #1627389952	; 0x61000000
     448:	37355f52 			; <UNDEFINED> instruction: 0x37355f52
     44c:	00303036 	eorseq	r3, r0, r6, lsr r0
     450:	315f5242 	cmpcc	pc, r2, asr #4
     454:	30323531 	eorscc	r3, r2, r1, lsr r5
     458:	614d0030 	cmpvs	sp, r0, lsr r0
     45c:	44534678 	ldrbmi	r4, [r3], #-1656	; 0xfffff988
     460:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
     464:	6d614e72 	stclvs	14, cr4, [r1, #-456]!	; 0xfffffe38
     468:	6e654c65 	cdpvs	12, 6, cr4, cr5, cr5, {3}
     46c:	00687467 	rsbeq	r7, r8, r7, ror #8
     470:	6b636f4c 	blvs	18dc1a8 <__bss_end+0x18d25c0>
     474:	6c6e555f 	cfstr64vs	mvdx5, [lr], #-380	; 0xfffffe84
     478:	656b636f 	strbvs	r6, [fp, #-879]!	; 0xfffffc91
     47c:	70660064 	rsbvc	r0, r6, r4, rrx
     480:	00737475 	rsbseq	r7, r3, r5, ror r4
     484:	6b636f4c 	blvs	18dc1bc <__bss_end+0x18d25d4>
     488:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
     48c:	0064656b 	rsbeq	r6, r4, fp, ror #10
     490:	52415554 	subpl	r5, r1, #84, 10	; 0x15000000
     494:	4f495f54 	svcmi	0x00495f54
     498:	5f6c7443 	svcpl	0x006c7443
     49c:	61726150 	cmnvs	r2, r0, asr r1
     4a0:	5200736d 	andpl	r7, r0, #-1275068415	; 0xb4000001
     4a4:	5f646165 	svcpl	0x00646165
     4a8:	74697257 	strbtvc	r7, [r9], #-599	; 0xfffffda9
     4ac:	65470065 	strbvs	r0, [r7, #-101]	; 0xffffff9b
     4b0:	61505f74 	cmpvs	r0, r4, ror pc
     4b4:	736d6172 	cmnvc	sp, #-2147483620	; 0x8000001c
     4b8:	78614d00 	stmdavc	r1!, {r8, sl, fp, lr}^
     4bc:	68746150 	ldmdavs	r4!, {r4, r6, r8, sp, lr}^
     4c0:	676e654c 	strbvs	r6, [lr, -ip, asr #10]!
     4c4:	75006874 	strvc	r6, [r0, #-2164]	; 0xfffff78c
     4c8:	6769736e 	strbvs	r7, [r9, -lr, ror #6]!
     4cc:	2064656e 	rsbcs	r6, r4, lr, ror #10
     4d0:	72616863 	rsbvc	r6, r1, #6488064	; 0x630000
     4d4:	766e4900 	strbtvc	r4, [lr], -r0, lsl #18
     4d8:	64696c61 	strbtvs	r6, [r9], #-3169	; 0xfffff39f
     4dc:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
     4e0:	00656c64 	rsbeq	r6, r5, r4, ror #24
     4e4:	726f6873 	rsbvc	r6, pc, #7536640	; 0x730000
     4e8:	6e692074 	mcrvs	0, 3, r2, cr9, cr4, {3}
     4ec:	61750074 	cmnvs	r5, r4, ror r0
     4f0:	665f7472 			; <UNDEFINED> instruction: 0x665f7472
     4f4:	00656c69 	rsbeq	r6, r5, r9, ror #24
     4f8:	62616e45 	rsbvs	r6, r1, #1104	; 0x450
     4fc:	455f656c 	ldrbmi	r6, [pc, #-1388]	; ffffff98 <__bss_end+0xffff63b0>
     500:	746e6576 	strbtvc	r6, [lr], #-1398	; 0xfffffa8a
     504:	7465445f 	strbtvc	r4, [r5], #-1119	; 0xfffffba1
     508:	69746365 	ldmdbvs	r4!, {r0, r2, r5, r6, r8, r9, sp, lr}^
     50c:	62006e6f 	andvs	r6, r0, #1776	; 0x6f0
     510:	6b636f6c 	blvs	18dc2c8 <__bss_end+0x18d26e0>
     514:	00676e69 	rsbeq	r6, r7, r9, ror #28
     518:	746e6975 	strbtvc	r6, [lr], #-2421	; 0xfffff68b
     51c:	745f3233 	ldrbvc	r3, [pc], #-563	; 524 <shift+0x524>
     520:	63697400 	cmnvs	r9, #0, 8
     524:	6675626b 	ldrbtvs	r6, [r5], -fp, ror #4
     528:	72617000 	rsbvc	r7, r1, #0
     52c:	00736d61 	rsbseq	r6, r3, r1, ror #26
     530:	64616552 	strbtvs	r6, [r1], #-1362	; 0xfffffaae
     534:	6c6e4f5f 	stclvs	15, cr4, [lr], #-380	; 0xfffffe84
     538:	6f4e0079 	svcvs	0x004e0079
     53c:	6c425f6e 	mcrrvs	15, 6, r5, r2, cr14
     540:	696b636f 	stmdbvs	fp!, {r0, r1, r2, r3, r5, r6, r8, r9, sp, lr}^
     544:	6100676e 	tstvs	r0, lr, ror #14
     548:	00766772 	rsbseq	r6, r6, r2, ror r7
     54c:	434f494e 	movtmi	r4, #63822	; 0xf94e
     550:	4f5f6c74 	svcmi	0x005f6c74
     554:	61726570 	cmnvs	r2, r0, ror r5
     558:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     55c:	5f524200 	svcpl	0x00524200
     560:	30303231 	eorscc	r3, r0, r1, lsr r2
     564:	6f682f00 	svcvs	0x00682f00
     568:	742f656d 	strtvc	r6, [pc], #-1389	; 570 <shift+0x570>
     56c:	69666572 	stmdbvs	r6!, {r1, r4, r5, r6, r8, sl, sp, lr}^
     570:	65732f6c 	ldrbvs	r2, [r3, #-3948]!	; 0xfffff094
     574:	6f732f6d 	svcvs	0x00732f6d
     578:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
     57c:	73752f73 	cmnvc	r5, #460	; 0x1cc
     580:	70737265 	rsbsvc	r7, r3, r5, ror #4
     584:	2f656361 	svccs	0x00656361
     588:	67676f6c 	strbvs	r6, [r7, -ip, ror #30]!
     58c:	745f7265 	ldrbvc	r7, [pc], #-613	; 594 <shift+0x594>
     590:	2f6b7361 	svccs	0x006b7361
     594:	6e69616d 	powvsez	f6, f1, #5.0
     598:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
     59c:	41554e00 	cmpmi	r5, r0, lsl #28
     5a0:	435f5452 	cmpmi	pc, #1375731712	; 0x52000000
     5a4:	5f726168 	svcpl	0x00726168
     5a8:	676e654c 	strbvs	r6, [lr, -ip, asr #10]!
     5ac:	42006874 	andmi	r6, r0, #116, 16	; 0x740000
     5b0:	36395f52 	shsaxcc	r5, r9, r2
     5b4:	61003030 	tstvs	r0, r0, lsr r0
     5b8:	00636772 	rsbeq	r6, r3, r2, ror r7
     5bc:	74697257 	strbtvc	r7, [r9], #-599	; 0xfffffda9
     5c0:	6e4f5f65 	cdpvs	15, 4, cr5, cr15, cr5, {3}
     5c4:	6300796c 	movwvs	r7, #2412	; 0x96c
     5c8:	5f726168 	svcpl	0x00726168
     5cc:	676e656c 	strbvs	r6, [lr, -ip, ror #10]!
     5d0:	6c006874 	stcvs	8, cr6, [r0], {116}	; 0x74
     5d4:	6970676f 	ldmdbvs	r0!, {r0, r1, r2, r3, r5, r6, r8, r9, sl, sp, lr}^
     5d8:	54006570 	strpl	r6, [r0], #-1392	; 0xfffffa90
     5dc:	5f6b6369 	svcpl	0x006b6369
     5e0:	6e756f43 	cdpvs	15, 7, cr6, cr5, cr3, {2}
     5e4:	704f0074 	subvc	r0, pc, r4, ror r0	; <UNPREDICTABLE>
     5e8:	5f006e65 	svcpl	0x00006e65
     5ec:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     5f0:	6f725043 	svcvs	0x00725043
     5f4:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     5f8:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     5fc:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     600:	6c423132 	stfvse	f3, [r2], {50}	; 0x32
     604:	5f6b636f 	svcpl	0x006b636f
     608:	72727543 	rsbsvc	r7, r2, #281018368	; 0x10c00000
     60c:	5f746e65 	svcpl	0x00746e65
     610:	636f7250 	cmnvs	pc, #80, 4
     614:	45737365 	ldrbmi	r7, [r3, #-869]!	; 0xfffffc9b
     618:	6c630076 	stclvs	0, cr0, [r3], #-472	; 0xfffffe28
     61c:	0065736f 	rsbeq	r7, r5, pc, ror #6
     620:	76657270 			; <UNDEFINED> instruction: 0x76657270
     624:	74655300 	strbtvc	r5, [r5], #-768	; 0xfffffd00
     628:	6c65525f 	sfmvs	f5, 2, [r5], #-380	; 0xfffffe84
     62c:	76697461 	strbtvc	r7, [r9], -r1, ror #8
     630:	6e550065 	cdpvs	0, 5, cr0, cr5, cr5, {3}
     634:	5f70616d 	svcpl	0x0070616d
     638:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     63c:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
     640:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     644:	74657200 	strbtvc	r7, [r5], #-512	; 0xfffffe00
     648:	006c6176 	rsbeq	r6, ip, r6, ror r1
     64c:	7275636e 	rsbsvc	r6, r5, #-1207959551	; 0xb8000001
     650:	6c614d00 	stclvs	13, cr4, [r1], #-0
     654:	00636f6c 	rsbeq	r6, r3, ip, ror #30
     658:	6f72506d 	svcvs	0x0072506d
     65c:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     660:	73694c5f 	cmnvc	r9, #24320	; 0x5f00
     664:	65485f74 	strbvs	r5, [r8, #-3956]	; 0xfffff08c
     668:	5f006461 	svcpl	0x00006461
     66c:	314b4e5a 	cmpcc	fp, sl, asr lr
     670:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     674:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     678:	614d5f73 	hvcvs	54771	; 0xd5f3
     67c:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     680:	47393172 			; <UNDEFINED> instruction: 0x47393172
     684:	435f7465 	cmpmi	pc, #1694498816	; 0x65000000
     688:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
     68c:	505f746e 	subspl	r7, pc, lr, ror #8
     690:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     694:	76457373 			; <UNDEFINED> instruction: 0x76457373
     698:	6e647200 	cdpvs	2, 6, cr7, cr4, cr0, {0}
     69c:	6e006d75 	mcrvs	13, 0, r6, cr0, cr5, {3}
     6a0:	00747865 	rsbseq	r7, r4, r5, ror #16
     6a4:	5f746547 	svcpl	0x00746547
     6a8:	636f7250 	cmnvs	pc, #80, 4
     6ac:	5f737365 	svcpl	0x00737365
     6b0:	505f7942 	subspl	r7, pc, r2, asr #18
     6b4:	5f004449 	svcpl	0x00004449
     6b8:	7331315a 	teqvc	r1, #-2147483626	; 0x80000016
     6bc:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     6c0:	6569795f 	strbvs	r7, [r9, #-2399]!	; 0xfffff6a1
     6c4:	0076646c 	rsbseq	r6, r6, ip, ror #8
     6c8:	4957534e 	ldmdbmi	r7, {r1, r2, r3, r6, r8, r9, ip, lr}^
     6cc:	6f72505f 	svcvs	0x0072505f
     6d0:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     6d4:	7265535f 	rsbvc	r5, r5, #2080374785	; 0x7c000001
     6d8:	65636976 	strbvs	r6, [r3, #-2422]!	; 0xfffff68a
     6dc:	74634100 	strbtvc	r4, [r3], #-256	; 0xffffff00
     6e0:	5f657669 	svcpl	0x00657669
     6e4:	636f7250 	cmnvs	pc, #80, 4
     6e8:	5f737365 	svcpl	0x00737365
     6ec:	6e756f43 	cdpvs	15, 7, cr6, cr5, cr3, {2}
     6f0:	72430074 	subvc	r0, r3, #116	; 0x74
     6f4:	65746165 	ldrbvs	r6, [r4, #-357]!	; 0xfffffe9b
     6f8:	6f72505f 	svcvs	0x0072505f
     6fc:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     700:	315a5f00 	cmpcc	sl, r0, lsl #30
     704:	74657337 	strbtvc	r7, [r5], #-823	; 0xfffffcc9
     708:	7361745f 	cmnvc	r1, #1593835520	; 0x5f000000
     70c:	65645f6b 	strbvs	r5, [r4, #-3947]!	; 0xfffff095
     710:	696c6461 	stmdbvs	ip!, {r0, r5, r6, sl, sp, lr}^
     714:	006a656e 	rsbeq	r6, sl, lr, ror #10
     718:	74696177 	strbtvc	r6, [r9], #-375	; 0xfffffe89
     71c:	61747300 	cmnvs	r4, r0, lsl #6
     720:	5f006574 	svcpl	0x00006574
     724:	6f6e365a 	svcvs	0x006e365a
     728:	79666974 	stmdbvc	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
     72c:	47006a6a 	strmi	r6, [r0, -sl, ror #20]
     730:	535f7465 	cmppl	pc, #1694498816	; 0x65000000
     734:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     738:	72656c75 	rsbvc	r6, r5, #29952	; 0x7500
     73c:	666e495f 			; <UNDEFINED> instruction: 0x666e495f
     740:	5043006f 	subpl	r0, r3, pc, rrx
     744:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     748:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 584 <shift+0x584>
     74c:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     750:	5f007265 	svcpl	0x00007265
     754:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     758:	6f725043 	svcvs	0x00725043
     75c:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     760:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     764:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     768:	65473831 	strbvs	r3, [r7, #-2097]	; 0xfffff7cf
     76c:	63535f74 	cmpvs	r3, #116, 30	; 0x1d0
     770:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
     774:	5f72656c 	svcpl	0x0072656c
     778:	6f666e49 	svcvs	0x00666e49
     77c:	4e303245 	cdpmi	2, 3, cr3, cr0, cr5, {2}
     780:	5f746547 	svcpl	0x00746547
     784:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     788:	6e495f64 	cdpvs	15, 4, cr5, cr9, cr4, {3}
     78c:	545f6f66 	ldrbpl	r6, [pc], #-3942	; 794 <shift+0x794>
     790:	50657079 	rsbpl	r7, r5, r9, ror r0
     794:	5a5f0076 	bpl	17c0974 <__bss_end+0x17b6d8c>
     798:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     79c:	636f7250 	cmnvs	pc, #80, 4
     7a0:	5f737365 	svcpl	0x00737365
     7a4:	616e614d 	cmnvs	lr, sp, asr #2
     7a8:	32726567 	rsbscc	r6, r2, #432013312	; 0x19c00000
     7ac:	6e614831 	mcrvs	8, 3, r4, cr1, cr1, {1}
     7b0:	5f656c64 	svcpl	0x00656c64
     7b4:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     7b8:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
     7bc:	535f6d65 	cmppl	pc, #6464	; 0x1940
     7c0:	32454957 	subcc	r4, r5, #1425408	; 0x15c000
     7c4:	57534e33 	smmlarpl	r3, r3, lr, r4
     7c8:	69465f49 	stmdbvs	r6, {r0, r3, r6, r8, r9, sl, fp, ip, lr}^
     7cc:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
     7d0:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
     7d4:	7265535f 	rsbvc	r5, r5, #2080374785	; 0x7c000001
     7d8:	65636976 	strbvs	r6, [r3, #-2422]!	; 0xfffff68a
     7dc:	526a6a6a 	rsbpl	r6, sl, #434176	; 0x6a000
     7e0:	53543131 	cmppl	r4, #1073741836	; 0x4000000c
     7e4:	525f4957 	subspl	r4, pc, #1425408	; 0x15c000
     7e8:	6c757365 	ldclvs	3, cr7, [r5], #-404	; 0xfffffe6c
     7ec:	706f0074 	rsbvc	r0, pc, r4, ror r0	; <UNPREDICTABLE>
     7f0:	64656e65 	strbtvs	r6, [r5], #-3685	; 0xfffff19b
     7f4:	6c69665f 	stclvs	6, cr6, [r9], #-380	; 0xfffffe84
     7f8:	46007365 	strmi	r7, [r0], -r5, ror #6
     7fc:	006c6961 	rsbeq	r6, ip, r1, ror #18
     800:	55504354 	ldrbpl	r4, [r0, #-852]	; 0xfffffcac
     804:	6e6f435f 	mcrvs	3, 3, r4, cr15, cr15, {2}
     808:	74786574 	ldrbtvc	r6, [r8], #-1396	; 0xfffffa8c
     80c:	61654400 	cmnvs	r5, r0, lsl #8
     810:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
     814:	78650065 	stmdavc	r5!, {r0, r2, r5, r6}^
     818:	6f637469 	svcvs	0x00637469
     81c:	74006564 	strvc	r6, [r0], #-1380	; 0xfffffa9c
     820:	30726274 	rsbscc	r6, r2, r4, ror r2
     824:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     828:	50433631 	subpl	r3, r3, r1, lsr r6
     82c:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     830:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 66c <shift+0x66c>
     834:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     838:	34317265 	ldrtcc	r7, [r1], #-613	; 0xfffffd9b
     83c:	69746f4e 	ldmdbvs	r4!, {r1, r2, r3, r6, r8, r9, sl, fp, sp, lr}^
     840:	505f7966 	subspl	r7, pc, r6, ror #18
     844:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     848:	6a457373 	bvs	115d61c <__bss_end+0x1153a34>
     84c:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     850:	4449505f 	strbmi	r5, [r9], #-95	; 0xffffffa1
     854:	746f6e00 	strbtvc	r6, [pc], #-3584	; 85c <shift+0x85c>
     858:	65696669 	strbvs	r6, [r9, #-1641]!	; 0xfffff997
     85c:	65645f64 	strbvs	r5, [r4, #-3940]!	; 0xfffff09c
     860:	696c6461 	stmdbvs	ip!, {r0, r5, r6, sl, sp, lr}^
     864:	5f00656e 	svcpl	0x0000656e
     868:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     86c:	6f725043 	svcvs	0x00725043
     870:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     874:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     878:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     87c:	6e553831 	mrcvs	8, 2, r3, cr5, cr1, {1}
     880:	5f70616d 	svcpl	0x0070616d
     884:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     888:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
     88c:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     890:	5f006a45 	svcpl	0x00006a45
     894:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     898:	6f725043 	svcvs	0x00725043
     89c:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     8a0:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     8a4:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     8a8:	6f4e3431 	svcvs	0x004e3431
     8ac:	79666974 	stmdbvc	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
     8b0:	6f72505f 	svcvs	0x0072505f
     8b4:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     8b8:	32315045 	eorscc	r5, r1, #69	; 0x45
     8bc:	73615454 	cmnvc	r1, #84, 8	; 0x54000000
     8c0:	74535f6b 	ldrbvc	r5, [r3], #-3947	; 0xfffff095
     8c4:	74637572 	strbtvc	r7, [r3], #-1394	; 0xfffffa8e
     8c8:	68637300 	stmdavs	r3!, {r8, r9, ip, sp, lr}^
     8cc:	795f6465 	ldmdbvc	pc, {r0, r2, r5, r6, sl, sp, lr}^	; <UNPREDICTABLE>
     8d0:	646c6569 	strbtvs	r6, [ip], #-1385	; 0xfffffa97
     8d4:	63697400 	cmnvs	r9, #0, 8
     8d8:	6f635f6b 	svcvs	0x00635f6b
     8dc:	5f746e75 	svcpl	0x00746e75
     8e0:	75716572 	ldrbvc	r6, [r1, #-1394]!	; 0xfffffa8e
     8e4:	64657269 	strbtvs	r7, [r5], #-617	; 0xfffffd97
     8e8:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     8ec:	50433631 	subpl	r3, r3, r1, lsr r6
     8f0:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     8f4:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 730 <shift+0x730>
     8f8:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     8fc:	32317265 	eorscc	r7, r1, #1342177286	; 0x50000006
     900:	466e7552 			; <UNDEFINED> instruction: 0x466e7552
     904:	74737269 	ldrbtvc	r7, [r3], #-617	; 0xfffffd97
     908:	6b736154 	blvs	1cd8e60 <__bss_end+0x1ccf278>
     90c:	5f007645 	svcpl	0x00007645
     910:	6734325a 			; <UNDEFINED> instruction: 0x6734325a
     914:	615f7465 	cmpvs	pc, r5, ror #8
     918:	76697463 	strbtvc	r7, [r9], -r3, ror #8
     91c:	72705f65 	rsbsvc	r5, r0, #404	; 0x194
     920:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     924:	6f635f73 	svcvs	0x00635f73
     928:	76746e75 			; <UNDEFINED> instruction: 0x76746e75
     92c:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     930:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
     934:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     938:	6f72505f 	svcvs	0x0072505f
     93c:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     940:	70695000 	rsbvc	r5, r9, r0
     944:	69465f65 	stmdbvs	r6, {r0, r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     948:	505f656c 	subspl	r6, pc, ip, ror #10
     94c:	69666572 	stmdbvs	r6!, {r1, r4, r5, r6, r8, sl, sp, lr}^
     950:	614d0078 	hvcvs	53256	; 0xd008
     954:	69465f70 	stmdbvs	r6, {r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     958:	545f656c 	ldrbpl	r6, [pc], #-1388	; 960 <shift+0x960>
     95c:	75435f6f 	strbvc	r5, [r3, #-3951]	; 0xfffff091
     960:	6e657272 	mcrvs	2, 3, r7, cr5, cr2, {3}
     964:	6c420074 	mcrrvs	0, 7, r0, r2, cr4
     968:	5f6b636f 	svcpl	0x006b636f
     96c:	72727543 	rsbsvc	r7, r2, #281018368	; 0x10c00000
     970:	5f746e65 	svcpl	0x00746e65
     974:	636f7250 	cmnvs	pc, #80, 4
     978:	00737365 	rsbseq	r7, r3, r5, ror #6
     97c:	34315a5f 	ldrtcc	r5, [r1], #-2655	; 0xfffff5a1
     980:	5f746567 	svcpl	0x00746567
     984:	6b636974 	blvs	18daf5c <__bss_end+0x18d1374>
     988:	756f635f 	strbvc	r6, [pc, #-863]!	; 631 <shift+0x631>
     98c:	0076746e 	rsbseq	r7, r6, lr, ror #8
     990:	69676f6c 	stmdbvs	r7!, {r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
     994:	5f6c6163 	svcpl	0x006c6163
     998:	61657262 	cmnvs	r5, r2, ror #4
     99c:	6148006b 	cmpvs	r8, fp, rrx
     9a0:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     9a4:	6f72505f 	svcvs	0x0072505f
     9a8:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     9ac:	4957535f 	ldmdbmi	r7, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     9b0:	656c7300 	strbvs	r7, [ip, #-768]!	; 0xfffffd00
     9b4:	53007065 	movwpl	r7, #101	; 0x65
     9b8:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     9bc:	5f656c75 	svcpl	0x00656c75
     9c0:	00464445 	subeq	r4, r6, r5, asr #8
     9c4:	74696157 	strbtvc	r6, [r9], #-343	; 0xfffffea9
     9c8:	395a5f00 	ldmdbcc	sl, {r8, r9, sl, fp, ip, lr}^
     9cc:	6d726574 	cfldr64vs	mvdx6, [r2, #-464]!	; 0xfffffe30
     9d0:	74616e69 	strbtvc	r6, [r1], #-3689	; 0xfffff197
     9d4:	49006965 	stmdbmi	r0, {r0, r2, r5, r6, r8, fp, sp, lr}
     9d8:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
     9dc:	74707572 	ldrbtvc	r7, [r0], #-1394	; 0xfffffa8e
     9e0:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
     9e4:	656c535f 	strbvs	r5, [ip, #-863]!	; 0xfffffca1
     9e8:	6f007065 	svcvs	0x00007065
     9ec:	61726570 	cmnvs	r2, r0, ror r5
     9f0:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     9f4:	355a5f00 	ldrbcc	r5, [sl, #-3840]	; 0xfffff100
     9f8:	736f6c63 	cmnvc	pc, #25344	; 0x6300
     9fc:	6d006a65 	vstrvs	s12, [r0, #-404]	; 0xfffffe6c
     a00:	7473614c 	ldrbtvc	r6, [r3], #-332	; 0xfffffeb4
     a04:	4449505f 	strbmi	r5, [r9], #-95	; 0xffffffa1
     a08:	6f6c4200 	svcvs	0x006c4200
     a0c:	64656b63 	strbtvs	r6, [r5], #-2915	; 0xfffff49d
     a10:	65474e00 	strbvs	r4, [r7, #-3584]	; 0xfffff200
     a14:	63535f74 	cmpvs	r3, #116, 30	; 0x1d0
     a18:	5f646568 	svcpl	0x00646568
     a1c:	6f666e49 	svcvs	0x00666e49
     a20:	7079545f 	rsbsvc	r5, r9, pc, asr r4
     a24:	5a5f0065 	bpl	17c0bc0 <__bss_end+0x17b6fd8>
     a28:	74656736 	strbtvc	r6, [r5], #-1846	; 0xfffff8ca
     a2c:	76646970 			; <UNDEFINED> instruction: 0x76646970
     a30:	616e6600 	cmnvs	lr, r0, lsl #12
     a34:	5200656d 	andpl	r6, r0, #457179136	; 0x1b400000
     a38:	616e6e75 	smcvs	59109	; 0xe6e5
     a3c:	00656c62 	rsbeq	r6, r5, r2, ror #24
     a40:	7361544e 	cmnvc	r1, #1308622848	; 0x4e000000
     a44:	74535f6b 	ldrbvc	r5, [r3], #-3947	; 0xfffff095
     a48:	00657461 	rsbeq	r7, r5, r1, ror #8
     a4c:	65686373 	strbvs	r6, [r8, #-883]!	; 0xfffffc8d
     a50:	6f635f64 	svcvs	0x00635f64
     a54:	65746e75 	ldrbvs	r6, [r4, #-3701]!	; 0xfffff18b
     a58:	4e470072 	mcrmi	0, 2, r0, cr7, cr2, {3}
     a5c:	2b432055 	blcs	10c8bb8 <__bss_end+0x10befd0>
     a60:	2034312b 	eorscs	r3, r4, fp, lsr #2
     a64:	332e3031 			; <UNDEFINED> instruction: 0x332e3031
     a68:	3220312e 	eorcc	r3, r0, #-2147483637	; 0x8000000b
     a6c:	30313230 	eorscc	r3, r1, r0, lsr r2
     a70:	20313236 	eorscs	r3, r1, r6, lsr r2
     a74:	6c657228 	sfmvs	f7, 2, [r5], #-160	; 0xffffff60
     a78:	65736165 	ldrbvs	r6, [r3, #-357]!	; 0xfffffe9b
     a7c:	6d2d2029 	stcvs	0, cr2, [sp, #-164]!	; 0xffffff5c
     a80:	616f6c66 	cmnvs	pc, r6, ror #24
     a84:	62612d74 	rsbvs	r2, r1, #116, 26	; 0x1d00
     a88:	61683d69 	cmnvs	r8, r9, ror #26
     a8c:	2d206472 	cfstrscs	mvf6, [r0, #-456]!	; 0xfffffe38
     a90:	7570666d 	ldrbvc	r6, [r0, #-1645]!	; 0xfffff993
     a94:	7066763d 	rsbvc	r7, r6, sp, lsr r6
     a98:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
     a9c:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
     aa0:	6962612d 	stmdbvs	r2!, {r0, r2, r3, r5, r8, sp, lr}^
     aa4:	7261683d 	rsbvc	r6, r1, #3997696	; 0x3d0000
     aa8:	6d2d2064 	stcvs	0, cr2, [sp, #-400]!	; 0xfffffe70
     aac:	3d757066 	ldclcc	0, cr7, [r5, #-408]!	; 0xfffffe68
     ab0:	20706676 	rsbscs	r6, r0, r6, ror r6
     ab4:	75746d2d 	ldrbvc	r6, [r4, #-3373]!	; 0xfffff2d3
     ab8:	613d656e 	teqvs	sp, lr, ror #10
     abc:	31316d72 	teqcc	r1, r2, ror sp
     ac0:	7a6a3637 	bvc	1a8e3a4 <__bss_end+0x1a847bc>
     ac4:	20732d66 	rsbscs	r2, r3, r6, ror #26
     ac8:	72616d2d 	rsbvc	r6, r1, #2880	; 0xb40
     acc:	6d2d206d 	stcvs	0, cr2, [sp, #-436]!	; 0xfffffe4c
     ad0:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
     ad4:	6d72613d 	ldfvse	f6, [r2, #-244]!	; 0xffffff0c
     ad8:	6b7a3676 	blvs	1e8e4b8 <__bss_end+0x1e848d0>
     adc:	2070662b 	rsbscs	r6, r0, fp, lsr #12
     ae0:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
     ae4:	672d2067 	strvs	r2, [sp, -r7, rrx]!
     ae8:	304f2d20 	subcc	r2, pc, r0, lsr #26
     aec:	304f2d20 	subcc	r2, pc, r0, lsr #26
     af0:	6e662d20 	cdpvs	13, 6, cr2, cr6, cr0, {1}
     af4:	78652d6f 	stmdavc	r5!, {r0, r1, r2, r3, r5, r6, r8, sl, fp, sp}^
     af8:	74706563 	ldrbtvc	r6, [r0], #-1379	; 0xfffffa9d
     afc:	736e6f69 	cmnvc	lr, #420	; 0x1a4
     b00:	6e662d20 	cdpvs	13, 6, cr2, cr6, cr0, {1}
     b04:	74722d6f 	ldrbtvc	r2, [r2], #-3439	; 0xfffff291
     b08:	77006974 	smlsdxvc	r0, r4, r9, r6
     b0c:	65746972 	ldrbvs	r6, [r4, #-2418]!	; 0xfffff68e
     b10:	69786500 	ldmdbvs	r8!, {r8, sl, sp, lr}^
     b14:	6f635f74 	svcvs	0x00635f74
     b18:	5f006564 	svcpl	0x00006564
     b1c:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     b20:	6f725043 	svcvs	0x00725043
     b24:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     b28:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     b2c:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     b30:	72625334 	rsbvc	r5, r2, #52, 6	; 0xd0000000
     b34:	006a456b 	rsbeq	r4, sl, fp, ror #10
     b38:	65686373 	strbvs	r6, [r8, #-883]!	; 0xfffffc8d
     b3c:	74735f64 	ldrbtvc	r5, [r3], #-3940	; 0xfffff09c
     b40:	63697461 	cmnvs	r9, #1627389952	; 0x61000000
     b44:	6972705f 	ldmdbvs	r2!, {r0, r1, r2, r3, r4, r6, ip, sp, lr}^
     b48:	7469726f 	strbtvc	r7, [r9], #-623	; 0xfffffd91
     b4c:	69740079 	ldmdbvs	r4!, {r0, r3, r4, r5, r6}^
     b50:	00736b63 	rsbseq	r6, r3, r3, ror #22
     b54:	6863536d 	stmdavs	r3!, {r0, r2, r3, r5, r6, r8, r9, ip, lr}^
     b58:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
     b5c:	6e465f65 	cdpvs	15, 4, cr5, cr6, cr5, {3}
     b60:	706f0063 	rsbvc	r0, pc, r3, rrx
     b64:	5f006e65 	svcpl	0x00006e65
     b68:	6970345a 	ldmdbvs	r0!, {r1, r3, r4, r6, sl, ip, sp}^
     b6c:	4b506570 	blmi	141a134 <__bss_end+0x141054c>
     b70:	4e006a63 	vmlsmi.f32	s12, s0, s7
     b74:	64616544 	strbtvs	r6, [r1], #-1348	; 0xfffffabc
     b78:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
     b7c:	6275535f 	rsbsvs	r5, r5, #2080374785	; 0x7c000001
     b80:	76726573 			; <UNDEFINED> instruction: 0x76726573
     b84:	00656369 	rsbeq	r6, r5, r9, ror #6
     b88:	5f746567 	svcpl	0x00746567
     b8c:	6b636974 	blvs	18db164 <__bss_end+0x18d157c>
     b90:	756f635f 	strbvc	r6, [pc, #-863]!	; 839 <shift+0x839>
     b94:	4e00746e 	cdpmi	4, 0, cr7, cr0, cr14, {3}
     b98:	6669746f 	strbtvs	r7, [r9], -pc, ror #8
     b9c:	61700079 	cmnvs	r0, r9, ror r0
     ba0:	006d6172 	rsbeq	r6, sp, r2, ror r1
     ba4:	77355a5f 			; <UNDEFINED> instruction: 0x77355a5f
     ba8:	65746972 	ldrbvs	r6, [r4, #-2418]!	; 0xfffff68e
     bac:	634b506a 	movtvs	r5, #45162	; 0xb06a
     bb0:	7552006a 	ldrbvc	r0, [r2, #-106]	; 0xffffff96
     bb4:	7269466e 	rsbvc	r4, r9, #115343360	; 0x6e00000
     bb8:	61547473 	cmpvs	r4, r3, ror r4
     bbc:	67006b73 	smlsdxvs	r0, r3, fp, r6
     bc0:	745f7465 	ldrbvc	r7, [pc], #-1125	; bc8 <shift+0xbc8>
     bc4:	5f6b7361 	svcpl	0x006b7361
     bc8:	6b636974 	blvs	18db1a0 <__bss_end+0x18d15b8>
     bcc:	6f745f73 	svcvs	0x00745f73
     bd0:	6165645f 	cmnvs	r5, pc, asr r4
     bd4:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
     bd8:	75620065 	strbvc	r0, [r2, #-101]!	; 0xffffff9b
     bdc:	69735f66 	ldmdbvs	r3!, {r1, r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     be0:	7000657a 	andvc	r6, r0, sl, ror r5
     be4:	69737968 	ldmdbvs	r3!, {r3, r5, r6, r8, fp, ip, sp, lr}^
     be8:	5f6c6163 	svcpl	0x006c6163
     bec:	61657262 	cmnvs	r5, r2, ror #4
     bf0:	6f5a006b 	svcvs	0x005a006b
     bf4:	6569626d 	strbvs	r6, [r9, #-621]!	; 0xfffffd93
     bf8:	6f682f00 	svcvs	0x00682f00
     bfc:	742f656d 	strtvc	r6, [pc], #-1389	; c04 <shift+0xc04>
     c00:	69666572 	stmdbvs	r6!, {r1, r4, r5, r6, r8, sl, sp, lr}^
     c04:	65732f6c 	ldrbvs	r2, [r3, #-3948]!	; 0xfffff094
     c08:	6f732f6d 	svcvs	0x00732f6d
     c0c:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
     c10:	75622f73 	strbvc	r2, [r2, #-3955]!	; 0xfffff08d
     c14:	00646c69 	rsbeq	r6, r4, r9, ror #24
     c18:	5f746547 	svcpl	0x00746547
     c1c:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     c20:	6e495f64 	cdpvs	15, 4, cr5, cr9, cr4, {3}
     c24:	73006f66 	movwvc	r6, #3942	; 0xf66
     c28:	745f7465 	ldrbvc	r7, [pc], #-1125	; c30 <shift+0xc30>
     c2c:	5f6b7361 	svcpl	0x006b7361
     c30:	64616564 	strbtvs	r6, [r1], #-1380	; 0xfffffa9c
     c34:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
     c38:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     c3c:	50433631 	subpl	r3, r3, r1, lsr r6
     c40:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     c44:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; a80 <shift+0xa80>
     c48:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     c4c:	53387265 	teqpl	r8, #1342177286	; 0x50000006
     c50:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     c54:	45656c75 	strbmi	r6, [r5, #-3189]!	; 0xfffff38b
     c58:	5a5f0076 	bpl	17c0e38 <__bss_end+0x17b7250>
     c5c:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     c60:	636f7250 	cmnvs	pc, #80, 4
     c64:	5f737365 	svcpl	0x00737365
     c68:	616e614d 	cmnvs	lr, sp, asr #2
     c6c:	31726567 	cmncc	r2, r7, ror #10
     c70:	70614d39 	rsbvc	r4, r1, r9, lsr sp
     c74:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     c78:	6f545f65 	svcvs	0x00545f65
     c7c:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
     c80:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     c84:	49355045 	ldmdbmi	r5!, {r0, r2, r6, ip, lr}
     c88:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     c8c:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     c90:	50433631 	subpl	r3, r3, r1, lsr r6
     c94:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     c98:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; ad4 <shift+0xad4>
     c9c:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     ca0:	32317265 	eorscc	r7, r1, #1342177286	; 0x50000006
     ca4:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     ca8:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
     cac:	4644455f 			; <UNDEFINED> instruction: 0x4644455f
     cb0:	5f007645 	svcpl	0x00007645
     cb4:	6c73355a 	cfldr64vs	mvdx3, [r3], #-360	; 0xfffffe98
     cb8:	6a706565 	bvs	1c1a254 <__bss_end+0x1c1066c>
     cbc:	6547006a 	strbvs	r0, [r7, #-106]	; 0xffffff96
     cc0:	65525f74 	ldrbvs	r5, [r2, #-3956]	; 0xfffff08c
     cc4:	6e69616d 	powvsez	f6, f1, #5.0
     cc8:	00676e69 	rsbeq	r6, r7, r9, ror #28
     ccc:	36325a5f 			; <UNDEFINED> instruction: 0x36325a5f
     cd0:	5f746567 	svcpl	0x00746567
     cd4:	6b736174 	blvs	1cd92ac <__bss_end+0x1ccf6c4>
     cd8:	6369745f 	cmnvs	r9, #1593835520	; 0x5f000000
     cdc:	745f736b 	ldrbvc	r7, [pc], #-875	; ce4 <shift+0xce4>
     ce0:	65645f6f 	strbvs	r5, [r4, #-3951]!	; 0xfffff091
     ce4:	696c6461 	stmdbvs	ip!, {r0, r5, r6, sl, sp, lr}^
     ce8:	0076656e 	rsbseq	r6, r6, lr, ror #10
     cec:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; c38 <shift+0xc38>
     cf0:	72742f65 	rsbsvc	r2, r4, #404	; 0x194
     cf4:	6c696665 	stclvs	6, cr6, [r9], #-404	; 0xfffffe6c
     cf8:	6d65732f 	stclvs	3, cr7, [r5, #-188]!	; 0xffffff44
     cfc:	756f732f 	strbvc	r7, [pc, #-815]!	; 9d5 <shift+0x9d5>
     d00:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
     d04:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
     d08:	2f62696c 	svccs	0x0062696c
     d0c:	2f637273 	svccs	0x00637273
     d10:	66647473 			; <UNDEFINED> instruction: 0x66647473
     d14:	2e656c69 	cdpcs	12, 6, cr6, cr5, cr9, {3}
     d18:	00707063 	rsbseq	r7, r0, r3, rrx
     d1c:	4957534e 	ldmdbmi	r7, {r1, r2, r3, r6, r8, r9, ip, lr}^
     d20:	7365525f 	cmnvc	r5, #-268435451	; 0xf0000005
     d24:	5f746c75 	svcpl	0x00746c75
     d28:	65646f43 	strbvs	r6, [r4, #-3907]!	; 0xfffff0bd
     d2c:	6e755200 	cdpvs	2, 7, cr5, cr5, cr0, {0}
     d30:	676e696e 	strbvs	r6, [lr, -lr, ror #18]!
     d34:	6e727700 	cdpvs	7, 7, cr7, cr2, cr0, {0}
     d38:	5f006d75 	svcpl	0x00006d75
     d3c:	6177345a 	cmnvs	r7, sl, asr r4
     d40:	6a6a7469 	bvs	1a9deec <__bss_end+0x1a94304>
     d44:	5a5f006a 	bpl	17c0ef4 <__bss_end+0x17b730c>
     d48:	636f6935 	cmnvs	pc, #868352	; 0xd4000
     d4c:	316a6c74 	smccc	42692	; 0xa6c4
     d50:	4f494e36 	svcmi	0x00494e36
     d54:	5f6c7443 	svcpl	0x006c7443
     d58:	7265704f 	rsbvc	r7, r5, #79	; 0x4f
     d5c:	6f697461 	svcvs	0x00697461
     d60:	0076506e 	rsbseq	r5, r6, lr, rrx
     d64:	74636f69 	strbtvc	r6, [r3], #-3945	; 0xfffff097
     d68:	6572006c 	ldrbvs	r0, [r2, #-108]!	; 0xffffff94
     d6c:	746e6374 	strbtvc	r6, [lr], #-884	; 0xfffffc8c
     d70:	75436d00 	strbvc	r6, [r3, #-3328]	; 0xfffff300
     d74:	6e657272 	mcrvs	2, 3, r7, cr5, cr2, {3}
     d78:	61545f74 	cmpvs	r4, r4, ror pc
     d7c:	4e5f6b73 	vmovmi.s8	r6, d15[3]
     d80:	0065646f 	rsbeq	r6, r5, pc, ror #8
     d84:	69746f6e 	ldmdbvs	r4!, {r1, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
     d88:	74007966 	strvc	r7, [r0], #-2406	; 0xfffff69a
     d8c:	696d7265 	stmdbvs	sp!, {r0, r2, r5, r6, r9, ip, sp, lr}^
     d90:	6574616e 	ldrbvs	r6, [r4, #-366]!	; 0xfffffe92
     d94:	646f6d00 	strbtvs	r6, [pc], #-3328	; d9c <shift+0xd9c>
     d98:	70630065 	rsbvc	r0, r3, r5, rrx
     d9c:	6f635f75 	svcvs	0x00635f75
     da0:	7865746e 	stmdavc	r5!, {r1, r2, r3, r5, r6, sl, ip, sp, lr}^
     da4:	75620074 	strbvc	r0, [r2, #-116]!	; 0xffffff8c
     da8:	72656666 	rsbvc	r6, r5, #106954752	; 0x6600000
     dac:	656c7300 	strbvs	r7, [ip, #-768]!	; 0xfffffd00
     db0:	745f7065 	ldrbvc	r7, [pc], #-101	; db8 <shift+0xdb8>
     db4:	72656d69 	rsbvc	r6, r5, #6720	; 0x1a40
     db8:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     dbc:	4336314b 	teqmi	r6, #-1073741806	; 0xc0000012
     dc0:	636f7250 	cmnvs	pc, #80, 4
     dc4:	5f737365 	svcpl	0x00737365
     dc8:	616e614d 	cmnvs	lr, sp, asr #2
     dcc:	31726567 	cmncc	r2, r7, ror #10
     dd0:	74654738 	strbtvc	r4, [r5], #-1848	; 0xfffff8c8
     dd4:	6f72505f 	svcvs	0x0072505f
     dd8:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     ddc:	5f79425f 	svcpl	0x0079425f
     de0:	45444950 	strbmi	r4, [r4, #-2384]	; 0xfffff6b0
     de4:	6148006a 	cmpvs	r8, sl, rrx
     de8:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     dec:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     df0:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     df4:	5f6d6574 	svcpl	0x006d6574
     df8:	00495753 	subeq	r5, r9, r3, asr r7
     dfc:	314e5a5f 	cmpcc	lr, pc, asr sl
     e00:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     e04:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     e08:	614d5f73 	hvcvs	54771	; 0xd5f3
     e0c:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     e10:	53313172 	teqpl	r1, #-2147483620	; 0x8000001c
     e14:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     e18:	5f656c75 	svcpl	0x00656c75
     e1c:	76455252 			; <UNDEFINED> instruction: 0x76455252
     e20:	73617400 	cmnvc	r1, #0, 8
     e24:	5a5f006b 	bpl	17c0fd8 <__bss_end+0x17b73f0>
     e28:	61657234 	cmnvs	r5, r4, lsr r2
     e2c:	63506a64 	cmpvs	r0, #100, 20	; 0x64000
     e30:	6253006a 	subsvs	r0, r3, #106	; 0x6a
     e34:	4e006b72 	vmovmi.16	d0[1], r6
     e38:	6669746f 	strbtvs	r7, [r9], -pc, ror #8
     e3c:	72505f79 	subsvc	r5, r0, #484	; 0x1e4
     e40:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     e44:	63530073 	cmpvs	r3, #115	; 0x73
     e48:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
     e4c:	5f00656c 	svcpl	0x0000656c
     e50:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     e54:	6f725043 	svcvs	0x00725043
     e58:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     e5c:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     e60:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     e64:	69775339 	ldmdbvs	r7!, {r0, r3, r4, r5, r8, r9, ip, lr}^
     e68:	5f686374 	svcpl	0x00686374
     e6c:	50456f54 	subpl	r6, r5, r4, asr pc
     e70:	50433831 	subpl	r3, r3, r1, lsr r8
     e74:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     e78:	4c5f7373 	mrrcmi	3, 7, r7, pc, cr3	; <UNPREDICTABLE>
     e7c:	5f747369 	svcpl	0x00747369
     e80:	65646f4e 	strbvs	r6, [r4, #-3918]!	; 0xfffff0b2
     e84:	68635300 	stmdavs	r3!, {r8, r9, ip, lr}^
     e88:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
     e8c:	52525f65 	subspl	r5, r2, #404	; 0x194
     e90:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     e94:	50433631 	subpl	r3, r3, r1, lsr r6
     e98:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     e9c:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; cd8 <shift+0xcd8>
     ea0:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     ea4:	38317265 	ldmdacc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
     ea8:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     eac:	505f656c 	subspl	r6, pc, ip, ror #10
     eb0:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     eb4:	535f7373 	cmppl	pc, #-872415231	; 0xcc000001
     eb8:	32454957 	subcc	r4, r5, #1425408	; 0x15c000
     ebc:	57534e30 	smmlarpl	r3, r0, lr, r4
     ec0:	72505f49 	subsvc	r5, r0, #292	; 0x124
     ec4:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     ec8:	65535f73 	ldrbvs	r5, [r3, #-3955]	; 0xfffff08d
     ecc:	63697672 	cmnvs	r9, #119537664	; 0x7200000
     ed0:	6a6a6a65 	bvs	1a9b86c <__bss_end+0x1a91c84>
     ed4:	54313152 	ldrtpl	r3, [r1], #-338	; 0xfffffeae
     ed8:	5f495753 	svcpl	0x00495753
     edc:	75736552 	ldrbvc	r6, [r3, #-1362]!	; 0xfffffaae
     ee0:	5f00746c 	svcpl	0x0000746c
     ee4:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     ee8:	6f725043 	svcvs	0x00725043
     eec:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     ef0:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     ef4:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     ef8:	72433431 	subvc	r3, r3, #822083584	; 0x31000000
     efc:	65746165 	ldrbvs	r6, [r4, #-357]!	; 0xfffffe9b
     f00:	6f72505f 	svcvs	0x0072505f
     f04:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     f08:	6a685045 	bvs	1a15024 <__bss_end+0x1a0b43c>
     f0c:	77530062 	ldrbvc	r0, [r3, -r2, rrx]
     f10:	68637469 	stmdavs	r3!, {r0, r3, r5, r6, sl, ip, sp, lr}^
     f14:	006f545f 	rsbeq	r5, pc, pc, asr r4	; <UNPREDICTABLE>
     f18:	4957534e 	ldmdbmi	r7, {r1, r2, r3, r6, r8, r9, ip, lr}^
     f1c:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     f20:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     f24:	5f6d6574 	svcpl	0x006d6574
     f28:	76726553 			; <UNDEFINED> instruction: 0x76726553
     f2c:	00656369 	rsbeq	r6, r5, r9, ror #6
     f30:	63746572 	cmnvs	r4, #478150656	; 0x1c800000
     f34:	0065646f 	rsbeq	r6, r5, pc, ror #8
     f38:	5f746567 	svcpl	0x00746567
     f3c:	69746361 	ldmdbvs	r4!, {r0, r5, r6, r8, r9, sp, lr}^
     f40:	705f6576 	subsvc	r6, pc, r6, ror r5	; <UNPREDICTABLE>
     f44:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     f48:	635f7373 	cmpvs	pc, #-872415231	; 0xcc000001
     f4c:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
     f50:	6c696600 	stclvs	6, cr6, [r9], #-0
     f54:	6d616e65 	stclvs	14, cr6, [r1, #-404]!	; 0xfffffe6c
     f58:	72460065 	subvc	r0, r6, #101	; 0x65
     f5c:	72006565 	andvc	r6, r0, #423624704	; 0x19400000
     f60:	00646165 	rsbeq	r6, r4, r5, ror #2
     f64:	736f6c43 	cmnvc	pc, #17152	; 0x4300
     f68:	65680065 	strbvs	r0, [r8, #-101]!	; 0xffffff9b
     f6c:	735f7061 	cmpvc	pc, #97	; 0x61
     f70:	74726174 	ldrbtvc	r6, [r2], #-372	; 0xfffffe8c
     f74:	74656700 	strbtvc	r6, [r5], #-1792	; 0xfffff900
     f78:	00646970 	rsbeq	r6, r4, r0, ror r9
     f7c:	6f345a5f 	svcvs	0x00345a5f
     f80:	506e6570 	rsbpl	r6, lr, r0, ror r5
     f84:	3531634b 	ldrcc	r6, [r1, #-843]!	; 0xfffffcb5
     f88:	6c69464e 	stclvs	6, cr4, [r9], #-312	; 0xfffffec8
     f8c:	704f5f65 	subvc	r5, pc, r5, ror #30
     f90:	4d5f6e65 	ldclmi	14, cr6, [pc, #-404]	; e04 <shift+0xe04>
     f94:	0065646f 	rsbeq	r6, r5, pc, ror #8
     f98:	6c656959 			; <UNDEFINED> instruction: 0x6c656959
     f9c:	5a5f0064 	bpl	17c1134 <__bss_end+0x17b754c>
     fa0:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     fa4:	636f7250 	cmnvs	pc, #80, 4
     fa8:	5f737365 	svcpl	0x00737365
     fac:	616e614d 	cmnvs	lr, sp, asr #2
     fb0:	43726567 	cmnmi	r2, #432013312	; 0x19c00000
     fb4:	00764534 	rsbseq	r4, r6, r4, lsr r5
     fb8:	6d726554 	cfldr64vs	mvdx6, [r2, #-336]!	; 0xfffffeb0
     fbc:	74616e69 	strbtvc	r6, [r1], #-3689	; 0xfffff197
     fc0:	4f490065 	svcmi	0x00490065
     fc4:	006c7443 	rsbeq	r7, ip, r3, asr #8
     fc8:	73375a5f 	teqvc	r7, #389120	; 0x5f000
     fcc:	636e7274 	cmnvs	lr, #116, 4	; 0x40000007
     fd0:	63507970 	cmpvs	r0, #112, 18	; 0x1c0000
     fd4:	69634b50 	stmdbvs	r3!, {r4, r6, r8, r9, fp, lr}^
     fd8:	365a5f00 	ldrbcc	r5, [sl], -r0, lsl #30
     fdc:	636d656d 	cmnvs	sp, #457179136	; 0x1b400000
     fe0:	4b507970 	blmi	141f5a8 <__bss_end+0x14159c0>
     fe4:	69765076 	ldmdbvs	r6!, {r1, r2, r4, r5, r6, ip, lr}^
     fe8:	315a5f00 	cmpcc	sl, r0, lsl #30
     fec:	74656734 	strbtvc	r6, [r5], #-1844	; 0xfffff8cc
     ff0:	706e695f 	rsbvc	r6, lr, pc, asr r9
     ff4:	745f7475 	ldrbvc	r7, [pc], #-1141	; ffc <shift+0xffc>
     ff8:	50657079 	rsbpl	r7, r5, r9, ror r0
     ffc:	5f00634b 	svcpl	0x0000634b
    1000:	5f6e345a 	svcpl	0x006e345a
    1004:	69697574 	stmdbvs	r9!, {r2, r4, r5, r6, r8, sl, ip, sp, lr}^
    1008:	6f746100 	svcvs	0x00746100
    100c:	65670066 	strbvs	r0, [r7, #-102]!	; 0xffffff9a
    1010:	6e695f74 	mcrvs	15, 3, r5, cr9, cr4, {3}
    1014:	5f747570 	svcpl	0x00747570
    1018:	65707974 	ldrbvs	r7, [r0, #-2420]!	; 0xfffff68c
    101c:	6f746100 	svcvs	0x00746100
    1020:	5a5f0069 	bpl	17c11cc <__bss_end+0x17b75e4>
    1024:	6f746134 	svcvs	0x00746134
    1028:	634b5066 	movtvs	r5, #45158	; 0xb066
    102c:	73656400 	cmnvc	r5, #0, 8
    1030:	6e690074 	mcrvs	0, 3, r0, cr9, cr4, {3}
    1034:	00747570 	rsbseq	r7, r4, r0, ror r5
    1038:	6e676973 			; <UNDEFINED> instruction: 0x6e676973
    103c:	72747300 	rsbsvc	r7, r4, #0, 6
    1040:	00746163 	rsbseq	r6, r4, r3, ror #2
    1044:	62355a5f 	eorsvs	r5, r5, #389120	; 0x5f000
    1048:	6f72657a 	svcvs	0x0072657a
    104c:	00697650 	rsbeq	r7, r9, r0, asr r6
    1050:	6e727473 	mrcvs	4, 3, r7, cr2, cr3, {3}
    1054:	00797063 	rsbseq	r7, r9, r3, rrx
    1058:	73365a5f 	teqvc	r6, #389120	; 0x5f000
    105c:	61637274 	smcvs	14116	; 0x3724
    1060:	50635074 	rsbpl	r5, r3, r4, ror r0
    1064:	2f00634b 	svccs	0x0000634b
    1068:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
    106c:	6572742f 	ldrbvs	r7, [r2, #-1071]!	; 0xfffffbd1
    1070:	2f6c6966 	svccs	0x006c6966
    1074:	2f6d6573 	svccs	0x006d6573
    1078:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
    107c:	2f736563 	svccs	0x00736563
    1080:	6c647473 	cfstrdvs	mvd7, [r4], #-460	; 0xfffffe34
    1084:	732f6269 			; <UNDEFINED> instruction: 0x732f6269
    1088:	732f6372 			; <UNDEFINED> instruction: 0x732f6372
    108c:	74736474 	ldrbtvc	r6, [r3], #-1140	; 0xfffffb8c
    1090:	676e6972 			; <UNDEFINED> instruction: 0x676e6972
    1094:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
    1098:	72747300 	rsbsvc	r7, r4, #0, 6
    109c:	7461636e 	strbtvc	r6, [r1], #-878	; 0xfffffc92
    10a0:	6c617700 	stclvs	7, cr7, [r1], #-0
    10a4:	0072656b 	rsbseq	r6, r2, fp, ror #10
    10a8:	74636166 	strbtvc	r6, [r3], #-358	; 0xfffffe9a
    10ac:	6900726f 	stmdbvs	r0, {r0, r1, r2, r3, r5, r6, r9, ip, sp, lr}
    10b0:	00616f74 	rsbeq	r6, r1, r4, ror pc
    10b4:	69736f70 	ldmdbvs	r3!, {r4, r5, r6, r8, r9, sl, fp, sp, lr}^
    10b8:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
    10bc:	6d656d00 	stclvs	13, cr6, [r5, #-0]
    10c0:	00747364 	rsbseq	r7, r4, r4, ror #6
    10c4:	72616843 	rsbvc	r6, r1, #4390912	; 0x430000
    10c8:	766e6f43 	strbtvc	r6, [lr], -r3, asr #30
    10cc:	00727241 	rsbseq	r7, r2, r1, asr #4
    10d0:	616f7466 	cmnvs	pc, r6, ror #8
    10d4:	6d756e00 	ldclvs	14, cr6, [r5, #-0]
    10d8:	00726562 	rsbseq	r6, r2, r2, ror #10
    10dc:	736d656d 	cmnvc	sp, #457179136	; 0x1b400000
    10e0:	6e006372 	mcrvs	3, 0, r6, cr0, cr2, {3}
    10e4:	65626d75 	strbvs	r6, [r2, #-3445]!	; 0xfffff28b
    10e8:	61003272 	tstvs	r0, r2, ror r2
    10ec:	72657466 	rsbvc	r7, r5, #1711276032	; 0x66000000
    10f0:	50636544 	rsbpl	r6, r3, r4, asr #10
    10f4:	746e696f 	strbtvc	r6, [lr], #-2415	; 0xfffff691
    10f8:	657a6200 	ldrbvs	r6, [sl, #-512]!	; 0xfffffe00
    10fc:	6d006f72 	stcvs	15, cr6, [r0, #-456]	; 0xfffffe38
    1100:	70636d65 	rsbvc	r6, r3, r5, ror #26
    1104:	74730079 	ldrbtvc	r0, [r3], #-121	; 0xffffff87
    1108:	6d636e72 	stclvs	14, cr6, [r3, #-456]!	; 0xfffffe38
    110c:	72740070 	rsbsvc	r0, r4, #112	; 0x70
    1110:	696c6961 	stmdbvs	ip!, {r0, r5, r6, r8, fp, sp, lr}^
    1114:	645f676e 	ldrbvs	r6, [pc], #-1902	; 111c <shift+0x111c>
    1118:	6f00746f 	svcvs	0x0000746f
    111c:	75707475 	ldrbvc	r7, [r0, #-1141]!	; 0xfffffb8b
    1120:	656c0074 	strbvs	r0, [ip, #-116]!	; 0xffffff8c
    1124:	6874676e 	ldmdavs	r4!, {r1, r2, r3, r5, r6, r8, r9, sl, sp, lr}^
    1128:	5f6e0032 	svcpl	0x006e0032
    112c:	5f007574 	svcpl	0x00007574
    1130:	7473365a 	ldrbtvc	r3, [r3], #-1626	; 0xfffff9a6
    1134:	6e656c72 	mcrvs	12, 3, r6, cr5, cr2, {3}
    1138:	00634b50 	rsbeq	r4, r3, r0, asr fp
    113c:	73375a5f 	teqvc	r7, #389120	; 0x5f000
    1140:	636e7274 	cmnvs	lr, #116, 4	; 0x40000007
    1144:	4b50706d 	blmi	141d300 <__bss_end+0x1413718>
    1148:	5f305363 	svcpl	0x00305363
    114c:	5a5f0069 	bpl	17c12f8 <__bss_end+0x17b7710>
    1150:	6f746134 	svcvs	0x00746134
    1154:	634b5069 	movtvs	r5, #45161	; 0xb069
    1158:	345a5f00 	ldrbcc	r5, [sl], #-3840	; 0xfffff100
    115c:	616f7469 	cmnvs	pc, r9, ror #8
    1160:	6a635069 	bvs	18d530c <__bss_end+0x18cb724>
    1164:	345a5f00 	ldrbcc	r5, [sl], #-3840	; 0xfffff100
    1168:	616f7466 	cmnvs	pc, r6, ror #8
    116c:	00635066 	rsbeq	r5, r3, r6, rrx
    1170:	6f6d656d 	svcvs	0x006d656d
    1174:	73007972 	movwvc	r7, #2418	; 0x972
    1178:	656c7274 	strbvs	r7, [ip, #-628]!	; 0xfffffd8c
    117c:	5a5f006e 	bpl	17c133c <__bss_end+0x17b7754>
    1180:	72747337 	rsbsvc	r7, r4, #-603979776	; 0xdc000000
    1184:	7461636e 	strbtvc	r6, [r1], #-878	; 0xfffffc92
    1188:	4b506350 	blmi	1419ed0 <__bss_end+0x14102e8>
    118c:	2e006963 	vmlscs.f16	s12, s0, s7	; <UNPREDICTABLE>
    1190:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1194:	2f2e2e2f 	svccs	0x002e2e2f
    1198:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    119c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    11a0:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
    11a4:	2f636367 	svccs	0x00636367
    11a8:	666e6f63 	strbtvs	r6, [lr], -r3, ror #30
    11ac:	612f6769 			; <UNDEFINED> instruction: 0x612f6769
    11b0:	6c2f6d72 	stcvs	13, cr6, [pc], #-456	; ff0 <shift+0xff0>
    11b4:	66316269 	ldrtvs	r6, [r1], -r9, ror #4
    11b8:	73636e75 	cmnvc	r3, #1872	; 0x750
    11bc:	2f00532e 	svccs	0x0000532e
    11c0:	6c697562 	cfstr64vs	mvdx7, [r9], #-392	; 0xfffffe78
    11c4:	63672f64 	cmnvs	r7, #100, 30	; 0x190
    11c8:	72612d63 	rsbvc	r2, r1, #6336	; 0x18c0
    11cc:	6f6e2d6d 	svcvs	0x006e2d6d
    11d0:	652d656e 	strvs	r6, [sp, #-1390]!	; 0xfffffa92
    11d4:	2d696261 	sfmcs	f6, 2, [r9, #-388]!	; 0xfffffe7c
    11d8:	67665968 	strbvs	r5, [r6, -r8, ror #18]!
    11dc:	672f344b 	strvs	r3, [pc, -fp, asr #8]!
    11e0:	612d6363 			; <UNDEFINED> instruction: 0x612d6363
    11e4:	6e2d6d72 	mcrvs	13, 1, r6, cr13, cr2, {3}
    11e8:	2d656e6f 	stclcs	14, cr6, [r5, #-444]!	; 0xfffffe44
    11ec:	69626165 	stmdbvs	r2!, {r0, r2, r5, r6, r8, sp, lr}^
    11f0:	2e30312d 	rsfcssp	f3, f0, #5.0
    11f4:	30322d33 	eorscc	r2, r2, r3, lsr sp
    11f8:	302e3132 	eorcc	r3, lr, r2, lsr r1
    11fc:	75622f37 	strbvc	r2, [r2, #-3895]!	; 0xfffff0c9
    1200:	2f646c69 	svccs	0x00646c69
    1204:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
    1208:	656e6f6e 	strbvs	r6, [lr, #-3950]!	; 0xfffff092
    120c:	6261652d 	rsbvs	r6, r1, #188743680	; 0xb400000
    1210:	72612f69 	rsbvc	r2, r1, #420	; 0x1a4
    1214:	35762f6d 	ldrbcc	r2, [r6, #-3949]!	; 0xfffff093
    1218:	682f6574 	stmdavs	pc!, {r2, r4, r5, r6, r8, sl, sp, lr}	; <UNPREDICTABLE>
    121c:	2f647261 	svccs	0x00647261
    1220:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    1224:	47006363 	strmi	r6, [r0, -r3, ror #6]
    1228:	4120554e 			; <UNDEFINED> instruction: 0x4120554e
    122c:	2e322053 	mrccs	0, 1, r2, cr2, cr3, {2}
    1230:	2e003733 	mcrcs	7, 0, r3, cr0, cr3, {1}
    1234:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1238:	2f2e2e2f 	svccs	0x002e2e2f
    123c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1240:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1244:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
    1248:	2f636367 	svccs	0x00636367
    124c:	666e6f63 	strbtvs	r6, [lr], -r3, ror #30
    1250:	612f6769 			; <UNDEFINED> instruction: 0x612f6769
    1254:	692f6d72 	stmdbvs	pc!, {r1, r4, r5, r6, r8, sl, fp, sp, lr}	; <UNPREDICTABLE>
    1258:	37656565 	strbcc	r6, [r5, -r5, ror #10]!
    125c:	732d3435 			; <UNDEFINED> instruction: 0x732d3435
    1260:	00532e66 	subseq	r2, r3, r6, ror #28
    1264:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1268:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    126c:	2f2e2e2f 	svccs	0x002e2e2f
    1270:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1274:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
    1278:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    127c:	6e6f632f 	cdpvs	3, 6, cr6, cr15, cr15, {1}
    1280:	2f676966 	svccs	0x00676966
    1284:	2f6d7261 	svccs	0x006d7261
    1288:	62617062 	rsbvs	r7, r1, #98	; 0x62
    128c:	00532e69 	subseq	r2, r3, r9, ror #28
    1290:	5f617369 	svcpl	0x00617369
    1294:	5f746962 	svcpl	0x00746962
    1298:	64657270 	strbtvs	r7, [r5], #-624	; 0xfffffd90
    129c:	00736572 	rsbseq	r6, r3, r2, ror r5
    12a0:	5f617369 	svcpl	0x00617369
    12a4:	5f746962 	svcpl	0x00746962
    12a8:	5f706676 	svcpl	0x00706676
    12ac:	65736162 	ldrbvs	r6, [r3, #-354]!	; 0xfffffe9e
    12b0:	6d6f6300 	stclvs	3, cr6, [pc, #-0]	; 12b8 <shift+0x12b8>
    12b4:	78656c70 	stmdavc	r5!, {r4, r5, r6, sl, fp, sp, lr}^
    12b8:	6f6c6620 	svcvs	0x006c6620
    12bc:	69007461 	stmdbvs	r0, {r0, r5, r6, sl, ip, sp, lr}
    12c0:	6e5f6173 	mrcvs	1, 2, r6, cr15, cr3, {3}
    12c4:	7469626f 	strbtvc	r6, [r9], #-623	; 0xfffffd91
    12c8:	61736900 	cmnvs	r3, r0, lsl #18
    12cc:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    12d0:	65766d5f 	ldrbvs	r6, [r6, #-3423]!	; 0xfffff2a1
    12d4:	6f6c665f 	svcvs	0x006c665f
    12d8:	69007461 	stmdbvs	r0, {r0, r5, r6, sl, ip, sp, lr}
    12dc:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    12e0:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
    12e4:	00363170 	eorseq	r3, r6, r0, ror r1
    12e8:	5f617369 	svcpl	0x00617369
    12ec:	5f746962 	svcpl	0x00746962
    12f0:	00636573 	rsbeq	r6, r3, r3, ror r5
    12f4:	5f617369 	svcpl	0x00617369
    12f8:	5f746962 	svcpl	0x00746962
    12fc:	76696461 	strbtvc	r6, [r9], -r1, ror #8
    1300:	61736900 	cmnvs	r3, r0, lsl #18
    1304:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1308:	6975715f 	ldmdbvs	r5!, {r0, r1, r2, r3, r4, r6, r8, ip, sp, lr}^
    130c:	6e5f6b72 	vmovvs.s8	r6, d15[3]
    1310:	6f765f6f 	svcvs	0x00765f6f
    1314:	6974616c 	ldmdbvs	r4!, {r2, r3, r5, r6, r8, sp, lr}^
    1318:	635f656c 	cmpvs	pc, #108, 10	; 0x1b000000
    131c:	73690065 	cmnvc	r9, #101	; 0x65
    1320:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1324:	706d5f74 	rsbvc	r5, sp, r4, ror pc
    1328:	61736900 	cmnvs	r3, r0, lsl #18
    132c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1330:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1334:	00743576 	rsbseq	r3, r4, r6, ror r5
    1338:	5f617369 	svcpl	0x00617369
    133c:	5f746962 	svcpl	0x00746962
    1340:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    1344:	00657435 	rsbeq	r7, r5, r5, lsr r4
    1348:	5f617369 	svcpl	0x00617369
    134c:	5f746962 	svcpl	0x00746962
    1350:	6e6f656e 	cdpvs	5, 6, cr6, cr15, cr14, {3}
    1354:	61736900 	cmnvs	r3, r0, lsl #18
    1358:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    135c:	3166625f 	cmncc	r6, pc, asr r2
    1360:	50460036 	subpl	r0, r6, r6, lsr r0
    1364:	5f524353 	svcpl	0x00524353
    1368:	4d554e45 	ldclmi	14, cr4, [r5, #-276]	; 0xfffffeec
    136c:	53504600 	cmppl	r0, #0, 12
    1370:	6e5f5243 	cdpvs	2, 5, cr5, cr15, cr3, {2}
    1374:	7176637a 	cmnvc	r6, sl, ror r3
    1378:	4e455f63 	cdpmi	15, 4, cr5, cr5, cr3, {3}
    137c:	56004d55 			; <UNDEFINED> instruction: 0x56004d55
    1380:	455f5250 	ldrbmi	r5, [pc, #-592]	; 1138 <shift+0x1138>
    1384:	004d554e 	subeq	r5, sp, lr, asr #10
    1388:	74696266 	strbtvc	r6, [r9], #-614	; 0xfffffd9a
    138c:	706d695f 	rsbvc	r6, sp, pc, asr r9
    1390:	6163696c 	cmnvs	r3, ip, ror #18
    1394:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
    1398:	5f305000 	svcpl	0x00305000
    139c:	4d554e45 	ldclmi	14, cr4, [r5, #-276]	; 0xfffffeec
    13a0:	61736900 	cmnvs	r3, r0, lsl #18
    13a4:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    13a8:	7972635f 	ldmdbvc	r2!, {r0, r1, r2, r3, r4, r6, r8, r9, sp, lr}^
    13ac:	006f7470 	rsbeq	r7, pc, r0, ror r4	; <UNPREDICTABLE>
    13b0:	20554e47 	subscs	r4, r5, r7, asr #28
    13b4:	20373143 	eorscs	r3, r7, r3, asr #2
    13b8:	332e3031 			; <UNDEFINED> instruction: 0x332e3031
    13bc:	3220312e 	eorcc	r3, r0, #-2147483637	; 0x8000000b
    13c0:	30313230 	eorscc	r3, r1, r0, lsr r2
    13c4:	20313236 	eorscs	r3, r1, r6, lsr r2
    13c8:	6c657228 	sfmvs	f7, 2, [r5], #-160	; 0xffffff60
    13cc:	65736165 	ldrbvs	r6, [r3, #-357]!	; 0xfffffe9b
    13d0:	6d2d2029 	stcvs	0, cr2, [sp, #-164]!	; 0xffffff5c
    13d4:	206d7261 	rsbcs	r7, sp, r1, ror #4
    13d8:	6c666d2d 	stclvs	13, cr6, [r6], #-180	; 0xffffff4c
    13dc:	2d74616f 	ldfcse	f6, [r4, #-444]!	; 0xfffffe44
    13e0:	3d696261 	sfmcc	f6, 2, [r9, #-388]!	; 0xfffffe7c
    13e4:	64726168 	ldrbtvs	r6, [r2], #-360	; 0xfffffe98
    13e8:	616d2d20 	cmnvs	sp, r0, lsr #26
    13ec:	3d686372 	stclcc	3, cr6, [r8, #-456]!	; 0xfffffe38
    13f0:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    13f4:	2b657435 	blcs	195e4d0 <__bss_end+0x19548e8>
    13f8:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
    13fc:	672d2067 	strvs	r2, [sp, -r7, rrx]!
    1400:	20672d20 	rsbcs	r2, r7, r0, lsr #26
    1404:	20324f2d 	eorscs	r4, r2, sp, lsr #30
    1408:	20324f2d 	eorscs	r4, r2, sp, lsr #30
    140c:	20324f2d 	eorscs	r4, r2, sp, lsr #30
    1410:	7562662d 	strbvc	r6, [r2, #-1581]!	; 0xfffff9d3
    1414:	69646c69 	stmdbvs	r4!, {r0, r3, r5, r6, sl, fp, sp, lr}^
    1418:	6c2d676e 	stcvs	7, cr6, [sp], #-440	; 0xfffffe48
    141c:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    1420:	662d2063 	strtvs	r2, [sp], -r3, rrx
    1424:	732d6f6e 			; <UNDEFINED> instruction: 0x732d6f6e
    1428:	6b636174 	blvs	18d9a00 <__bss_end+0x18cfe18>
    142c:	6f72702d 	svcvs	0x0072702d
    1430:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
    1434:	2d20726f 	sfmcs	f7, 4, [r0, #-444]!	; 0xfffffe44
    1438:	2d6f6e66 	stclcs	14, cr6, [pc, #-408]!	; 12a8 <shift+0x12a8>
    143c:	696c6e69 	stmdbvs	ip!, {r0, r3, r5, r6, r9, sl, fp, sp, lr}^
    1440:	2d20656e 	cfstr32cs	mvfx6, [r0, #-440]!	; 0xfffffe48
    1444:	73697666 	cmnvc	r9, #106954752	; 0x6600000
    1448:	6c696269 	sfmvs	f6, 2, [r9], #-420	; 0xfffffe5c
    144c:	3d797469 	cfldrdcc	mvd7, [r9, #-420]!	; 0xfffffe5c
    1450:	64646968 	strbtvs	r6, [r4], #-2408	; 0xfffff698
    1454:	69006e65 	stmdbvs	r0, {r0, r2, r5, r6, r9, sl, fp, sp, lr}
    1458:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    145c:	745f7469 	ldrbvc	r7, [pc], #-1129	; 1464 <shift+0x1464>
    1460:	00766964 	rsbseq	r6, r6, r4, ror #18
    1464:	736e6f63 	cmnvc	lr, #396	; 0x18c
    1468:	61736900 	cmnvs	r3, r0, lsl #18
    146c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1470:	6d77695f 			; <UNDEFINED> instruction: 0x6d77695f
    1474:	0074786d 	rsbseq	r7, r4, sp, ror #16
    1478:	58435046 	stmdapl	r3, {r1, r2, r6, ip, lr}^
    147c:	455f5354 	ldrbmi	r5, [pc, #-852]	; 1130 <shift+0x1130>
    1480:	004d554e 	subeq	r5, sp, lr, asr #10
    1484:	5f617369 	svcpl	0x00617369
    1488:	5f746962 	svcpl	0x00746962
    148c:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    1490:	73690036 	cmnvc	r9, #54	; 0x36
    1494:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1498:	766d5f74 	uqsub16vc	r5, sp, r4
    149c:	73690065 	cmnvc	r9, #101	; 0x65
    14a0:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    14a4:	77695f74 			; <UNDEFINED> instruction: 0x77695f74
    14a8:	74786d6d 	ldrbtvc	r6, [r8], #-3437	; 0xfffff293
    14ac:	73690032 	cmnvc	r9, #50	; 0x32
    14b0:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    14b4:	64635f74 	strbtvs	r5, [r3], #-3956	; 0xfffff08c
    14b8:	30706365 	rsbscc	r6, r0, r5, ror #6
    14bc:	61736900 	cmnvs	r3, r0, lsl #18
    14c0:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    14c4:	6564635f 	strbvs	r6, [r4, #-863]!	; 0xfffffca1
    14c8:	00317063 	eorseq	r7, r1, r3, rrx
    14cc:	5f617369 	svcpl	0x00617369
    14d0:	5f746962 	svcpl	0x00746962
    14d4:	63656463 	cmnvs	r5, #1660944384	; 0x63000000
    14d8:	69003270 	stmdbvs	r0, {r4, r5, r6, r9, ip, sp}
    14dc:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    14e0:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
    14e4:	70636564 	rsbvc	r6, r3, r4, ror #10
    14e8:	73690033 	cmnvc	r9, #51	; 0x33
    14ec:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    14f0:	64635f74 	strbtvs	r5, [r3], #-3956	; 0xfffff08c
    14f4:	34706365 	ldrbtcc	r6, [r0], #-869	; 0xfffffc9b
    14f8:	61736900 	cmnvs	r3, r0, lsl #18
    14fc:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1500:	5f70665f 	svcpl	0x0070665f
    1504:	006c6264 	rsbeq	r6, ip, r4, ror #4
    1508:	5f617369 	svcpl	0x00617369
    150c:	5f746962 	svcpl	0x00746962
    1510:	63656463 	cmnvs	r5, #1660944384	; 0x63000000
    1514:	69003670 	stmdbvs	r0, {r4, r5, r6, r9, sl, ip, sp}
    1518:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    151c:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
    1520:	70636564 	rsbvc	r6, r3, r4, ror #10
    1524:	73690037 	cmnvc	r9, #55	; 0x37
    1528:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    152c:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    1530:	6b36766d 	blvs	d9eeec <__bss_end+0xd95304>
    1534:	61736900 	cmnvs	r3, r0, lsl #18
    1538:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    153c:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1540:	315f3876 	cmpcc	pc, r6, ror r8	; <UNPREDICTABLE>
    1544:	616d5f6d 	cmnvs	sp, sp, ror #30
    1548:	61006e69 	tstvs	r0, r9, ror #28
    154c:	0065746e 	rsbeq	r7, r5, lr, ror #8
    1550:	5f617369 	svcpl	0x00617369
    1554:	5f746962 	svcpl	0x00746962
    1558:	65736d63 	ldrbvs	r6, [r3, #-3427]!	; 0xfffff29d
    155c:	6e6f6c00 	cdpvs	12, 6, cr6, cr15, cr0, {0}
    1560:	6f642067 	svcvs	0x00642067
    1564:	656c6275 	strbvs	r6, [ip, #-629]!	; 0xfffffd8b
    1568:	2f2e2e00 	svccs	0x002e2e00
    156c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1570:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1574:	2f2e2e2f 	svccs	0x002e2e2f
    1578:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; 14c8 <shift+0x14c8>
    157c:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    1580:	696c2f63 	stmdbvs	ip!, {r0, r1, r5, r6, r8, r9, sl, fp, sp}^
    1584:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    1588:	00632e32 	rsbeq	r2, r3, r2, lsr lr
    158c:	5f617369 	svcpl	0x00617369
    1590:	5f746962 	svcpl	0x00746962
    1594:	35767066 	ldrbcc	r7, [r6, #-102]!	; 0xffffff9a
    1598:	61736900 	cmnvs	r3, r0, lsl #18
    159c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    15a0:	6373785f 	cmnvs	r3, #6225920	; 0x5f0000
    15a4:	00656c61 	rsbeq	r6, r5, r1, ror #24
    15a8:	676e6f6c 	strbvs	r6, [lr, -ip, ror #30]!
    15ac:	6e6f6c20 	cdpvs	12, 6, cr6, cr15, cr0, {1}
    15b0:	6e752067 	cdpvs	0, 7, cr2, cr5, cr7, {3}
    15b4:	6e676973 			; <UNDEFINED> instruction: 0x6e676973
    15b8:	69206465 	stmdbvs	r0!, {r0, r2, r5, r6, sl, sp, lr}
    15bc:	6900746e 	stmdbvs	r0, {r1, r2, r3, r5, r6, sl, ip, sp, lr}
    15c0:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    15c4:	715f7469 	cmpvc	pc, r9, ror #8
    15c8:	6b726975 	blvs	1c9bba4 <__bss_end+0x1c91fbc>
    15cc:	336d635f 	cmncc	sp, #2080374785	; 0x7c000001
    15d0:	72646c5f 	rsbvc	r6, r4, #24320	; 0x5f00
    15d4:	73690064 	cmnvc	r9, #100	; 0x64
    15d8:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    15dc:	38695f74 	stmdacc	r9!, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    15e0:	69006d6d 	stmdbvs	r0, {r0, r2, r3, r5, r6, r8, sl, fp, sp, lr}
    15e4:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    15e8:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
    15ec:	33645f70 	cmncc	r4, #112, 30	; 0x1c0
    15f0:	73690032 	cmnvc	r9, #50	; 0x32
    15f4:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    15f8:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    15fc:	6537766d 	ldrvs	r7, [r7, #-1645]!	; 0xfffff993
    1600:	7369006d 	cmnvc	r9, #109	; 0x6d
    1604:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1608:	706c5f74 	rsbvc	r5, ip, r4, ror pc
    160c:	61006561 	tstvs	r0, r1, ror #10
    1610:	695f6c6c 	ldmdbvs	pc, {r2, r3, r5, r6, sl, fp, sp, lr}^	; <UNPREDICTABLE>
    1614:	696c706d 	stmdbvs	ip!, {r0, r2, r3, r5, r6, ip, sp, lr}^
    1618:	665f6465 	ldrbvs	r6, [pc], -r5, ror #8
    161c:	73746962 	cmnvc	r4, #1605632	; 0x188000
    1620:	61736900 	cmnvs	r3, r0, lsl #18
    1624:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1628:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    162c:	315f3876 	cmpcc	pc, r6, ror r8	; <UNPREDICTABLE>
    1630:	61736900 	cmnvs	r3, r0, lsl #18
    1634:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1638:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    163c:	325f3876 	subscc	r3, pc, #7733248	; 0x760000
    1640:	61736900 	cmnvs	r3, r0, lsl #18
    1644:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1648:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    164c:	335f3876 	cmpcc	pc, #7733248	; 0x760000
    1650:	61736900 	cmnvs	r3, r0, lsl #18
    1654:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1658:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    165c:	345f3876 	ldrbcc	r3, [pc], #-2166	; 1664 <shift+0x1664>
    1660:	61736900 	cmnvs	r3, r0, lsl #18
    1664:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1668:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    166c:	355f3876 	ldrbcc	r3, [pc, #-2166]	; dfe <shift+0xdfe>
    1670:	61736900 	cmnvs	r3, r0, lsl #18
    1674:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1678:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    167c:	365f3876 			; <UNDEFINED> instruction: 0x365f3876
    1680:	61736900 	cmnvs	r3, r0, lsl #18
    1684:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1688:	0062735f 	rsbeq	r7, r2, pc, asr r3
    168c:	5f617369 	svcpl	0x00617369
    1690:	5f6d756e 	svcpl	0x006d756e
    1694:	73746962 	cmnvc	r4, #1605632	; 0x188000
    1698:	61736900 	cmnvs	r3, r0, lsl #18
    169c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    16a0:	616d735f 	cmnvs	sp, pc, asr r3
    16a4:	756d6c6c 	strbvc	r6, [sp, #-3180]!	; 0xfffff394
    16a8:	7566006c 	strbvc	r0, [r6, #-108]!	; 0xffffff94
    16ac:	705f636e 	subsvc	r6, pc, lr, ror #6
    16b0:	63007274 	movwvs	r7, #628	; 0x274
    16b4:	6c706d6f 	ldclvs	13, cr6, [r0], #-444	; 0xfffffe44
    16b8:	64207865 	strtvs	r7, [r0], #-2149	; 0xfffff79b
    16bc:	6c62756f 	cfstr64vs	mvdx7, [r2], #-444	; 0xfffffe44
    16c0:	424e0065 	submi	r0, lr, #101	; 0x65
    16c4:	5f50465f 	svcpl	0x0050465f
    16c8:	52535953 	subspl	r5, r3, #1359872	; 0x14c000
    16cc:	00534745 	subseq	r4, r3, r5, asr #14
    16d0:	5f617369 	svcpl	0x00617369
    16d4:	5f746962 	svcpl	0x00746962
    16d8:	63656463 	cmnvs	r5, #1660944384	; 0x63000000
    16dc:	69003570 	stmdbvs	r0, {r4, r5, r6, r8, sl, ip, sp}
    16e0:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    16e4:	765f7469 	ldrbvc	r7, [pc], -r9, ror #8
    16e8:	32767066 	rsbscc	r7, r6, #102	; 0x66
    16ec:	61736900 	cmnvs	r3, r0, lsl #18
    16f0:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    16f4:	7066765f 	rsbvc	r7, r6, pc, asr r6
    16f8:	69003376 	stmdbvs	r0, {r1, r2, r4, r5, r6, r8, r9, ip, sp}
    16fc:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1700:	765f7469 	ldrbvc	r7, [pc], -r9, ror #8
    1704:	34767066 	ldrbtcc	r7, [r6], #-102	; 0xffffff9a
    1708:	43504600 	cmpmi	r0, #0, 12
    170c:	534e5458 	movtpl	r5, #58456	; 0xe458
    1710:	554e455f 	strbpl	r4, [lr, #-1375]	; 0xfffffaa1
    1714:	7369004d 	cmnvc	r9, #77	; 0x4d
    1718:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    171c:	68745f74 	ldmdavs	r4!, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    1720:	00626d75 	rsbeq	r6, r2, r5, ror sp
    1724:	5f617369 	svcpl	0x00617369
    1728:	5f746962 	svcpl	0x00746962
    172c:	36317066 	ldrtcc	r7, [r1], -r6, rrx
    1730:	766e6f63 	strbtvc	r6, [lr], -r3, ror #30
    1734:	61736900 	cmnvs	r3, r0, lsl #18
    1738:	6165665f 	cmnvs	r5, pc, asr r6
    173c:	65727574 	ldrbvs	r7, [r2, #-1396]!	; 0xfffffa8c
    1740:	61736900 	cmnvs	r3, r0, lsl #18
    1744:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1748:	746f6e5f 	strbtvc	r6, [pc], #-3679	; 1750 <shift+0x1750>
    174c:	7369006d 	cmnvc	r9, #109	; 0x6d
    1750:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1754:	75715f74 	ldrbvc	r5, [r1, #-3956]!	; 0xfffff08c
    1758:	5f6b7269 	svcpl	0x006b7269
    175c:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    1760:	007a6b36 	rsbseq	r6, sl, r6, lsr fp
    1764:	5f617369 	svcpl	0x00617369
    1768:	5f746962 	svcpl	0x00746962
    176c:	33637263 	cmncc	r3, #805306374	; 0x30000006
    1770:	73690032 	cmnvc	r9, #50	; 0x32
    1774:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1778:	75715f74 	ldrbvc	r5, [r1, #-3956]!	; 0xfffff08c
    177c:	5f6b7269 	svcpl	0x006b7269
    1780:	615f6f6e 	cmpvs	pc, lr, ror #30
    1784:	70636d73 	rsbvc	r6, r3, r3, ror sp
    1788:	73690075 	cmnvc	r9, #117	; 0x75
    178c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1790:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    1794:	0034766d 	eorseq	r7, r4, sp, ror #12
    1798:	5f617369 	svcpl	0x00617369
    179c:	5f746962 	svcpl	0x00746962
    17a0:	6d756874 	ldclvs	8, cr6, [r5, #-464]!	; 0xfffffe30
    17a4:	69003262 	stmdbvs	r0, {r1, r5, r6, r9, ip, sp}
    17a8:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    17ac:	625f7469 	subsvs	r7, pc, #1761607680	; 0x69000000
    17b0:	69003865 	stmdbvs	r0, {r0, r2, r5, r6, fp, ip, sp}
    17b4:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    17b8:	615f7469 	cmpvs	pc, r9, ror #8
    17bc:	37766d72 			; <UNDEFINED> instruction: 0x37766d72
    17c0:	61736900 	cmnvs	r3, r0, lsl #18
    17c4:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    17c8:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    17cc:	76003876 			; <UNDEFINED> instruction: 0x76003876
    17d0:	735f7066 	cmpvc	pc, #102	; 0x66
    17d4:	65727379 	ldrbvs	r7, [r2, #-889]!	; 0xfffffc87
    17d8:	655f7367 	ldrbvs	r7, [pc, #-871]	; 1479 <shift+0x1479>
    17dc:	646f636e 	strbtvs	r6, [pc], #-878	; 17e4 <shift+0x17e4>
    17e0:	00676e69 	rsbeq	r6, r7, r9, ror #28
    17e4:	5f617369 	svcpl	0x00617369
    17e8:	5f746962 	svcpl	0x00746962
    17ec:	36317066 	ldrtcc	r7, [r1], -r6, rrx
    17f0:	006c6d66 	rsbeq	r6, ip, r6, ror #26
    17f4:	5f617369 	svcpl	0x00617369
    17f8:	5f746962 	svcpl	0x00746962
    17fc:	70746f64 	rsbsvc	r6, r4, r4, ror #30
    1800:	00646f72 	rsbeq	r6, r4, r2, ror pc
    1804:	69665f5f 	stmdbvs	r6!, {r0, r1, r2, r3, r4, r6, r8, r9, sl, fp, ip, lr}^
    1808:	736e7578 	cmnvc	lr, #120, 10	; 0x1e000000
    180c:	69646673 	stmdbvs	r4!, {r0, r1, r4, r5, r6, r9, sl, sp, lr}^
    1810:	74465300 	strbvc	r5, [r6], #-768	; 0xfffffd00
    1814:	00657079 	rsbeq	r7, r5, r9, ror r0
    1818:	65615f5f 	strbvs	r5, [r1, #-3935]!	; 0xfffff0a1
    181c:	5f696261 	svcpl	0x00696261
    1820:	6c753266 	lfmvs	f3, 2, [r5], #-408	; 0xfffffe68
    1824:	5f5f007a 	svcpl	0x005f007a
    1828:	73786966 	cmnvc	r8, #1671168	; 0x198000
    182c:	00696466 	rsbeq	r6, r9, r6, ror #8
    1830:	79744644 	ldmdbvc	r4!, {r2, r6, r9, sl, lr}^
    1834:	55006570 	strpl	r6, [r0, #-1392]	; 0xfffffa90
    1838:	79744953 	ldmdbvc	r4!, {r0, r1, r4, r6, r8, fp, lr}^
    183c:	55006570 	strpl	r6, [r0, #-1392]	; 0xfffffa90
    1840:	79744944 	ldmdbvc	r4!, {r2, r6, r8, fp, lr}^
    1844:	47006570 	smlsdxmi	r0, r0, r5, r6
    1848:	4320554e 			; <UNDEFINED> instruction: 0x4320554e
    184c:	31203731 			; <UNDEFINED> instruction: 0x31203731
    1850:	2e332e30 	mrccs	14, 1, r2, cr3, cr0, {1}
    1854:	30322031 	eorscc	r2, r2, r1, lsr r0
    1858:	36303132 			; <UNDEFINED> instruction: 0x36303132
    185c:	28203132 	stmdacs	r0!, {r1, r4, r5, r8, ip, sp}
    1860:	656c6572 	strbvs	r6, [ip, #-1394]!	; 0xfffffa8e
    1864:	29657361 	stmdbcs	r5!, {r0, r5, r6, r8, r9, ip, sp, lr}^
    1868:	616d2d20 	cmnvs	sp, r0, lsr #26
    186c:	2d206d72 	stccs	13, cr6, [r0, #-456]!	; 0xfffffe38
    1870:	6f6c666d 	svcvs	0x006c666d
    1874:	612d7461 			; <UNDEFINED> instruction: 0x612d7461
    1878:	683d6962 	ldmdavs	sp!, {r1, r5, r6, r8, fp, sp, lr}
    187c:	20647261 	rsbcs	r7, r4, r1, ror #4
    1880:	72616d2d 	rsbvc	r6, r1, #2880	; 0xb40
    1884:	613d6863 	teqvs	sp, r3, ror #16
    1888:	35766d72 	ldrbcc	r6, [r6, #-3442]!	; 0xfffff28e
    188c:	662b6574 			; <UNDEFINED> instruction: 0x662b6574
    1890:	672d2070 			; <UNDEFINED> instruction: 0x672d2070
    1894:	20672d20 	rsbcs	r2, r7, r0, lsr #26
    1898:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
    189c:	2d20324f 	sfmcs	f3, 4, [r0, #-316]!	; 0xfffffec4
    18a0:	2d20324f 	sfmcs	f3, 4, [r0, #-316]!	; 0xfffffec4
    18a4:	2d20324f 	sfmcs	f3, 4, [r0, #-316]!	; 0xfffffec4
    18a8:	69756266 	ldmdbvs	r5!, {r1, r2, r5, r6, r9, sp, lr}^
    18ac:	6e69646c 	cdpvs	4, 6, cr6, cr9, cr12, {3}
    18b0:	696c2d67 	stmdbvs	ip!, {r0, r1, r2, r5, r6, r8, sl, fp, sp}^
    18b4:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    18b8:	6e662d20 	cdpvs	13, 6, cr2, cr6, cr0, {1}
    18bc:	74732d6f 	ldrbtvc	r2, [r3], #-3439	; 0xfffff291
    18c0:	2d6b6361 	stclcs	3, cr6, [fp, #-388]!	; 0xfffffe7c
    18c4:	746f7270 	strbtvc	r7, [pc], #-624	; 18cc <shift+0x18cc>
    18c8:	6f746365 	svcvs	0x00746365
    18cc:	662d2072 			; <UNDEFINED> instruction: 0x662d2072
    18d0:	692d6f6e 	pushvs	{r1, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}
    18d4:	6e696c6e 	cdpvs	12, 6, cr6, cr9, cr14, {3}
    18d8:	662d2065 	strtvs	r2, [sp], -r5, rrx
    18dc:	65637865 	strbvs	r7, [r3, #-2149]!	; 0xfffff79b
    18e0:	6f697470 	svcvs	0x00697470
    18e4:	2d20736e 	stccs	3, cr7, [r0, #-440]!	; 0xfffffe48
    18e8:	73697666 	cmnvc	r9, #106954752	; 0x6600000
    18ec:	6c696269 	sfmvs	f6, 2, [r9], #-420	; 0xfffffe5c
    18f0:	3d797469 	cfldrdcc	mvd7, [r9, #-420]!	; 0xfffffe5c
    18f4:	64646968 	strbtvs	r6, [r4], #-2408	; 0xfffff698
    18f8:	5f006e65 	svcpl	0x00006e65
    18fc:	6964755f 	stmdbvs	r4!, {r0, r1, r2, r3, r4, r6, r8, sl, ip, sp, lr}^
    1900:	646f6d76 	strbtvs	r6, [pc], #-3446	; 1908 <shift+0x1908>
    1904:	00346964 	eorseq	r6, r4, r4, ror #18

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
  20:	8b040e42 	blhi	103930 <__bss_end+0xf9d48>
  24:	0b0d4201 	bleq	350830 <__bss_end+0x346c48>
  28:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
  2c:	00000ecb 	andeq	r0, r0, fp, asr #29
  30:	0000001c 	andeq	r0, r0, ip, lsl r0
  34:	00000000 	andeq	r0, r0, r0
  38:	00008064 	andeq	r8, r0, r4, rrx
  3c:	00000040 	andeq	r0, r0, r0, asr #32
  40:	8b080e42 	blhi	203950 <__bss_end+0x1f9d68>
  44:	42018e02 	andmi	r8, r1, #2, 28
  48:	5a040b0c 	bpl	102c80 <__bss_end+0xf9098>
  4c:	00080d0c 	andeq	r0, r8, ip, lsl #26
  50:	0000000c 	andeq	r0, r0, ip
  54:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
  58:	7c020001 	stcvc	0, cr0, [r2], {1}
  5c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
  60:	0000001c 	andeq	r0, r0, ip, lsl r0
  64:	00000050 	andeq	r0, r0, r0, asr r0
  68:	000080a4 	andeq	r8, r0, r4, lsr #1
  6c:	00000038 	andeq	r0, r0, r8, lsr r0
  70:	8b040e42 	blhi	103980 <__bss_end+0xf9d98>
  74:	0b0d4201 	bleq	350880 <__bss_end+0x346c98>
  78:	420d0d54 	andmi	r0, sp, #84, 26	; 0x1500
  7c:	00000ecb 	andeq	r0, r0, fp, asr #29
  80:	0000001c 	andeq	r0, r0, ip, lsl r0
  84:	00000050 	andeq	r0, r0, r0, asr r0
  88:	000080dc 	ldrdeq	r8, [r0], -ip
  8c:	0000002c 	andeq	r0, r0, ip, lsr #32
  90:	8b040e42 	blhi	1039a0 <__bss_end+0xf9db8>
  94:	0b0d4201 	bleq	3508a0 <__bss_end+0x346cb8>
  98:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
  9c:	00000ecb 	andeq	r0, r0, fp, asr #29
  a0:	0000001c 	andeq	r0, r0, ip, lsl r0
  a4:	00000050 	andeq	r0, r0, r0, asr r0
  a8:	00008108 	andeq	r8, r0, r8, lsl #2
  ac:	00000020 	andeq	r0, r0, r0, lsr #32
  b0:	8b040e42 	blhi	1039c0 <__bss_end+0xf9dd8>
  b4:	0b0d4201 	bleq	3508c0 <__bss_end+0x346cd8>
  b8:	420d0d48 	andmi	r0, sp, #72, 26	; 0x1200
  bc:	00000ecb 	andeq	r0, r0, fp, asr #29
  c0:	0000001c 	andeq	r0, r0, ip, lsl r0
  c4:	00000050 	andeq	r0, r0, r0, asr r0
  c8:	00008128 	andeq	r8, r0, r8, lsr #2
  cc:	00000018 	andeq	r0, r0, r8, lsl r0
  d0:	8b040e42 	blhi	1039e0 <__bss_end+0xf9df8>
  d4:	0b0d4201 	bleq	3508e0 <__bss_end+0x346cf8>
  d8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  dc:	00000ecb 	andeq	r0, r0, fp, asr #29
  e0:	0000001c 	andeq	r0, r0, ip, lsl r0
  e4:	00000050 	andeq	r0, r0, r0, asr r0
  e8:	00008140 	andeq	r8, r0, r0, asr #2
  ec:	00000018 	andeq	r0, r0, r8, lsl r0
  f0:	8b040e42 	blhi	103a00 <__bss_end+0xf9e18>
  f4:	0b0d4201 	bleq	350900 <__bss_end+0x346d18>
  f8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  fc:	00000ecb 	andeq	r0, r0, fp, asr #29
 100:	0000001c 	andeq	r0, r0, ip, lsl r0
 104:	00000050 	andeq	r0, r0, r0, asr r0
 108:	00008158 	andeq	r8, r0, r8, asr r1
 10c:	00000018 	andeq	r0, r0, r8, lsl r0
 110:	8b040e42 	blhi	103a20 <__bss_end+0xf9e38>
 114:	0b0d4201 	bleq	350920 <__bss_end+0x346d38>
 118:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
 11c:	00000ecb 	andeq	r0, r0, fp, asr #29
 120:	00000014 	andeq	r0, r0, r4, lsl r0
 124:	00000050 	andeq	r0, r0, r0, asr r0
 128:	00008170 	andeq	r8, r0, r0, ror r1
 12c:	0000000c 	andeq	r0, r0, ip
 130:	8b040e42 	blhi	103a40 <__bss_end+0xf9e58>
 134:	0b0d4201 	bleq	350940 <__bss_end+0x346d58>
 138:	0000001c 	andeq	r0, r0, ip, lsl r0
 13c:	00000050 	andeq	r0, r0, r0, asr r0
 140:	0000817c 	andeq	r8, r0, ip, ror r1
 144:	00000058 	andeq	r0, r0, r8, asr r0
 148:	8b080e42 	blhi	203a58 <__bss_end+0x1f9e70>
 14c:	42018e02 	andmi	r8, r1, #2, 28
 150:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 154:	00080d0c 	andeq	r0, r8, ip, lsl #26
 158:	0000001c 	andeq	r0, r0, ip, lsl r0
 15c:	00000050 	andeq	r0, r0, r0, asr r0
 160:	000081d4 	ldrdeq	r8, [r0], -r4
 164:	00000058 	andeq	r0, r0, r8, asr r0
 168:	8b080e42 	blhi	203a78 <__bss_end+0x1f9e90>
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
 198:	8b080e42 	blhi	203aa8 <__bss_end+0x1f9ec0>
 19c:	42018e02 	andmi	r8, r1, #2, 28
 1a0:	58040b0c 	stmdapl	r4, {r2, r3, r8, r9, fp}
 1a4:	00080d0c 	andeq	r0, r8, ip, lsl #26
 1a8:	00000018 	andeq	r0, r0, r8, lsl r0
 1ac:	00000178 	andeq	r0, r0, r8, ror r1
 1b0:	00008268 	andeq	r8, r0, r8, ror #4
 1b4:	00000144 	andeq	r0, r0, r4, asr #2
 1b8:	8b080e42 	blhi	203ac8 <__bss_end+0x1f9ee0>
 1bc:	42018e02 	andmi	r8, r1, #2, 28
 1c0:	00040b0c 	andeq	r0, r4, ip, lsl #22
 1c4:	0000000c 	andeq	r0, r0, ip
 1c8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 1cc:	7c020001 	stcvc	0, cr0, [r2], {1}
 1d0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 1d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1d8:	000001c4 	andeq	r0, r0, r4, asr #3
 1dc:	000083ac 	andeq	r8, r0, ip, lsr #7
 1e0:	0000002c 	andeq	r0, r0, ip, lsr #32
 1e4:	8b040e42 	blhi	103af4 <__bss_end+0xf9f0c>
 1e8:	0b0d4201 	bleq	3509f4 <__bss_end+0x346e0c>
 1ec:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 1f0:	00000ecb 	andeq	r0, r0, fp, asr #29
 1f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1f8:	000001c4 	andeq	r0, r0, r4, asr #3
 1fc:	000083d8 	ldrdeq	r8, [r0], -r8	; <UNPREDICTABLE>
 200:	0000002c 	andeq	r0, r0, ip, lsr #32
 204:	8b040e42 	blhi	103b14 <__bss_end+0xf9f2c>
 208:	0b0d4201 	bleq	350a14 <__bss_end+0x346e2c>
 20c:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 210:	00000ecb 	andeq	r0, r0, fp, asr #29
 214:	0000001c 	andeq	r0, r0, ip, lsl r0
 218:	000001c4 	andeq	r0, r0, r4, asr #3
 21c:	00008404 	andeq	r8, r0, r4, lsl #8
 220:	0000001c 	andeq	r0, r0, ip, lsl r0
 224:	8b040e42 	blhi	103b34 <__bss_end+0xf9f4c>
 228:	0b0d4201 	bleq	350a34 <__bss_end+0x346e4c>
 22c:	420d0d46 	andmi	r0, sp, #4480	; 0x1180
 230:	00000ecb 	andeq	r0, r0, fp, asr #29
 234:	0000001c 	andeq	r0, r0, ip, lsl r0
 238:	000001c4 	andeq	r0, r0, r4, asr #3
 23c:	00008420 	andeq	r8, r0, r0, lsr #8
 240:	00000044 	andeq	r0, r0, r4, asr #32
 244:	8b040e42 	blhi	103b54 <__bss_end+0xf9f6c>
 248:	0b0d4201 	bleq	350a54 <__bss_end+0x346e6c>
 24c:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 250:	00000ecb 	andeq	r0, r0, fp, asr #29
 254:	0000001c 	andeq	r0, r0, ip, lsl r0
 258:	000001c4 	andeq	r0, r0, r4, asr #3
 25c:	00008464 	andeq	r8, r0, r4, ror #8
 260:	00000050 	andeq	r0, r0, r0, asr r0
 264:	8b040e42 	blhi	103b74 <__bss_end+0xf9f8c>
 268:	0b0d4201 	bleq	350a74 <__bss_end+0x346e8c>
 26c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 270:	00000ecb 	andeq	r0, r0, fp, asr #29
 274:	0000001c 	andeq	r0, r0, ip, lsl r0
 278:	000001c4 	andeq	r0, r0, r4, asr #3
 27c:	000084b4 			; <UNDEFINED> instruction: 0x000084b4
 280:	00000050 	andeq	r0, r0, r0, asr r0
 284:	8b040e42 	blhi	103b94 <__bss_end+0xf9fac>
 288:	0b0d4201 	bleq	350a94 <__bss_end+0x346eac>
 28c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 290:	00000ecb 	andeq	r0, r0, fp, asr #29
 294:	0000001c 	andeq	r0, r0, ip, lsl r0
 298:	000001c4 	andeq	r0, r0, r4, asr #3
 29c:	00008504 	andeq	r8, r0, r4, lsl #10
 2a0:	0000002c 	andeq	r0, r0, ip, lsr #32
 2a4:	8b040e42 	blhi	103bb4 <__bss_end+0xf9fcc>
 2a8:	0b0d4201 	bleq	350ab4 <__bss_end+0x346ecc>
 2ac:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 2b0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2b4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2b8:	000001c4 	andeq	r0, r0, r4, asr #3
 2bc:	00008530 	andeq	r8, r0, r0, lsr r5
 2c0:	00000050 	andeq	r0, r0, r0, asr r0
 2c4:	8b040e42 	blhi	103bd4 <__bss_end+0xf9fec>
 2c8:	0b0d4201 	bleq	350ad4 <__bss_end+0x346eec>
 2cc:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 2d0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2d8:	000001c4 	andeq	r0, r0, r4, asr #3
 2dc:	00008580 	andeq	r8, r0, r0, lsl #11
 2e0:	00000044 	andeq	r0, r0, r4, asr #32
 2e4:	8b040e42 	blhi	103bf4 <__bss_end+0xfa00c>
 2e8:	0b0d4201 	bleq	350af4 <__bss_end+0x346f0c>
 2ec:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 2f0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2f8:	000001c4 	andeq	r0, r0, r4, asr #3
 2fc:	000085c4 	andeq	r8, r0, r4, asr #11
 300:	00000050 	andeq	r0, r0, r0, asr r0
 304:	8b040e42 	blhi	103c14 <__bss_end+0xfa02c>
 308:	0b0d4201 	bleq	350b14 <__bss_end+0x346f2c>
 30c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 310:	00000ecb 	andeq	r0, r0, fp, asr #29
 314:	0000001c 	andeq	r0, r0, ip, lsl r0
 318:	000001c4 	andeq	r0, r0, r4, asr #3
 31c:	00008614 	andeq	r8, r0, r4, lsl r6
 320:	00000054 	andeq	r0, r0, r4, asr r0
 324:	8b040e42 	blhi	103c34 <__bss_end+0xfa04c>
 328:	0b0d4201 	bleq	350b34 <__bss_end+0x346f4c>
 32c:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 330:	00000ecb 	andeq	r0, r0, fp, asr #29
 334:	0000001c 	andeq	r0, r0, ip, lsl r0
 338:	000001c4 	andeq	r0, r0, r4, asr #3
 33c:	00008668 	andeq	r8, r0, r8, ror #12
 340:	0000003c 	andeq	r0, r0, ip, lsr r0
 344:	8b040e42 	blhi	103c54 <__bss_end+0xfa06c>
 348:	0b0d4201 	bleq	350b54 <__bss_end+0x346f6c>
 34c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 350:	00000ecb 	andeq	r0, r0, fp, asr #29
 354:	0000001c 	andeq	r0, r0, ip, lsl r0
 358:	000001c4 	andeq	r0, r0, r4, asr #3
 35c:	000086a4 	andeq	r8, r0, r4, lsr #13
 360:	0000003c 	andeq	r0, r0, ip, lsr r0
 364:	8b040e42 	blhi	103c74 <__bss_end+0xfa08c>
 368:	0b0d4201 	bleq	350b74 <__bss_end+0x346f8c>
 36c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 370:	00000ecb 	andeq	r0, r0, fp, asr #29
 374:	0000001c 	andeq	r0, r0, ip, lsl r0
 378:	000001c4 	andeq	r0, r0, r4, asr #3
 37c:	000086e0 	andeq	r8, r0, r0, ror #13
 380:	0000003c 	andeq	r0, r0, ip, lsr r0
 384:	8b040e42 	blhi	103c94 <__bss_end+0xfa0ac>
 388:	0b0d4201 	bleq	350b94 <__bss_end+0x346fac>
 38c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 390:	00000ecb 	andeq	r0, r0, fp, asr #29
 394:	0000001c 	andeq	r0, r0, ip, lsl r0
 398:	000001c4 	andeq	r0, r0, r4, asr #3
 39c:	0000871c 	andeq	r8, r0, ip, lsl r7
 3a0:	0000003c 	andeq	r0, r0, ip, lsr r0
 3a4:	8b040e42 	blhi	103cb4 <__bss_end+0xfa0cc>
 3a8:	0b0d4201 	bleq	350bb4 <__bss_end+0x346fcc>
 3ac:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 3b0:	00000ecb 	andeq	r0, r0, fp, asr #29
 3b4:	0000001c 	andeq	r0, r0, ip, lsl r0
 3b8:	000001c4 	andeq	r0, r0, r4, asr #3
 3bc:	00008758 	andeq	r8, r0, r8, asr r7
 3c0:	000000b0 	strheq	r0, [r0], -r0	; <UNPREDICTABLE>
 3c4:	8b080e42 	blhi	203cd4 <__bss_end+0x1fa0ec>
 3c8:	42018e02 	andmi	r8, r1, #2, 28
 3cc:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 3d0:	080d0c50 	stmdaeq	sp, {r4, r6, sl, fp}
 3d4:	0000000c 	andeq	r0, r0, ip
 3d8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 3dc:	7c020001 	stcvc	0, cr0, [r2], {1}
 3e0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 3e4:	0000001c 	andeq	r0, r0, ip, lsl r0
 3e8:	000003d4 	ldrdeq	r0, [r0], -r4
 3ec:	00008808 	andeq	r8, r0, r8, lsl #16
 3f0:	00000178 	andeq	r0, r0, r8, ror r1
 3f4:	8b080e42 	blhi	203d04 <__bss_end+0x1fa11c>
 3f8:	42018e02 	andmi	r8, r1, #2, 28
 3fc:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 400:	080d0cb4 	stmdaeq	sp, {r2, r4, r5, r7, sl, fp}
 404:	0000001c 	andeq	r0, r0, ip, lsl r0
 408:	000003d4 	ldrdeq	r0, [r0], -r4
 40c:	00008980 	andeq	r8, r0, r0, lsl #19
 410:	000000cc 	andeq	r0, r0, ip, asr #1
 414:	8b080e42 	blhi	203d24 <__bss_end+0x1fa13c>
 418:	42018e02 	andmi	r8, r1, #2, 28
 41c:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 420:	080d0c60 	stmdaeq	sp, {r5, r6, sl, fp}
 424:	0000001c 	andeq	r0, r0, ip, lsl r0
 428:	000003d4 	ldrdeq	r0, [r0], -r4
 42c:	00008a4c 	andeq	r8, r0, ip, asr #20
 430:	00000100 	andeq	r0, r0, r0, lsl #2
 434:	8b040e42 	blhi	103d44 <__bss_end+0xfa15c>
 438:	0b0d4201 	bleq	350c44 <__bss_end+0x34705c>
 43c:	0d0d7802 	stceq	8, cr7, [sp, #-8]
 440:	000ecb42 	andeq	ip, lr, r2, asr #22
 444:	0000001c 	andeq	r0, r0, ip, lsl r0
 448:	000003d4 	ldrdeq	r0, [r0], -r4
 44c:	00008b4c 	andeq	r8, r0, ip, asr #22
 450:	0000015c 	andeq	r0, r0, ip, asr r1
 454:	8b040e42 	blhi	103d64 <__bss_end+0xfa17c>
 458:	0b0d4201 	bleq	350c64 <__bss_end+0x34707c>
 45c:	0d0d9c02 	stceq	12, cr9, [sp, #-8]
 460:	000ecb42 	andeq	ip, lr, r2, asr #22
 464:	0000001c 	andeq	r0, r0, ip, lsl r0
 468:	000003d4 	ldrdeq	r0, [r0], -r4
 46c:	00008ca8 	andeq	r8, r0, r8, lsr #25
 470:	000000c0 	andeq	r0, r0, r0, asr #1
 474:	8b040e42 	blhi	103d84 <__bss_end+0xfa19c>
 478:	0b0d4201 	bleq	350c84 <__bss_end+0x34709c>
 47c:	0d0d5802 	stceq	8, cr5, [sp, #-8]
 480:	000ecb42 	andeq	ip, lr, r2, asr #22
 484:	0000001c 	andeq	r0, r0, ip, lsl r0
 488:	000003d4 	ldrdeq	r0, [r0], -r4
 48c:	00008d68 	andeq	r8, r0, r8, ror #26
 490:	000000ac 	andeq	r0, r0, ip, lsr #1
 494:	8b040e42 	blhi	103da4 <__bss_end+0xfa1bc>
 498:	0b0d4201 	bleq	350ca4 <__bss_end+0x3470bc>
 49c:	0d0d4e02 	stceq	14, cr4, [sp, #-8]
 4a0:	000ecb42 	andeq	ip, lr, r2, asr #22
 4a4:	0000001c 	andeq	r0, r0, ip, lsl r0
 4a8:	000003d4 	ldrdeq	r0, [r0], -r4
 4ac:	00008e14 	andeq	r8, r0, r4, lsl lr
 4b0:	00000054 	andeq	r0, r0, r4, asr r0
 4b4:	8b040e42 	blhi	103dc4 <__bss_end+0xfa1dc>
 4b8:	0b0d4201 	bleq	350cc4 <__bss_end+0x3470dc>
 4bc:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 4c0:	00000ecb 	andeq	r0, r0, fp, asr #29
 4c4:	0000001c 	andeq	r0, r0, ip, lsl r0
 4c8:	000003d4 	ldrdeq	r0, [r0], -r4
 4cc:	00008e68 	andeq	r8, r0, r8, ror #28
 4d0:	000000ac 	andeq	r0, r0, ip, lsr #1
 4d4:	8b080e42 	blhi	203de4 <__bss_end+0x1fa1fc>
 4d8:	42018e02 	andmi	r8, r1, #2, 28
 4dc:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 4e0:	080d0c50 	stmdaeq	sp, {r4, r6, sl, fp}
 4e4:	0000001c 	andeq	r0, r0, ip, lsl r0
 4e8:	000003d4 	ldrdeq	r0, [r0], -r4
 4ec:	00008f14 	andeq	r8, r0, r4, lsl pc
 4f0:	000000d8 	ldrdeq	r0, [r0], -r8
 4f4:	8b080e42 	blhi	203e04 <__bss_end+0x1fa21c>
 4f8:	42018e02 	andmi	r8, r1, #2, 28
 4fc:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 500:	080d0c66 	stmdaeq	sp, {r1, r2, r5, r6, sl, fp}
 504:	0000001c 	andeq	r0, r0, ip, lsl r0
 508:	000003d4 	ldrdeq	r0, [r0], -r4
 50c:	00008fec 	andeq	r8, r0, ip, ror #31
 510:	00000068 	andeq	r0, r0, r8, rrx
 514:	8b040e42 	blhi	103e24 <__bss_end+0xfa23c>
 518:	0b0d4201 	bleq	350d24 <__bss_end+0x34713c>
 51c:	420d0d6c 	andmi	r0, sp, #108, 26	; 0x1b00
 520:	00000ecb 	andeq	r0, r0, fp, asr #29
 524:	0000001c 	andeq	r0, r0, ip, lsl r0
 528:	000003d4 	ldrdeq	r0, [r0], -r4
 52c:	00009054 	andeq	r9, r0, r4, asr r0
 530:	00000080 	andeq	r0, r0, r0, lsl #1
 534:	8b040e42 	blhi	103e44 <__bss_end+0xfa25c>
 538:	0b0d4201 	bleq	350d44 <__bss_end+0x34715c>
 53c:	420d0d78 	andmi	r0, sp, #120, 26	; 0x1e00
 540:	00000ecb 	andeq	r0, r0, fp, asr #29
 544:	0000001c 	andeq	r0, r0, ip, lsl r0
 548:	000003d4 	ldrdeq	r0, [r0], -r4
 54c:	000090d4 	ldrdeq	r9, [r0], -r4
 550:	00000068 	andeq	r0, r0, r8, rrx
 554:	8b040e42 	blhi	103e64 <__bss_end+0xfa27c>
 558:	0b0d4201 	bleq	350d64 <__bss_end+0x34717c>
 55c:	420d0d6c 	andmi	r0, sp, #108, 26	; 0x1b00
 560:	00000ecb 	andeq	r0, r0, fp, asr #29
 564:	0000002c 	andeq	r0, r0, ip, lsr #32
 568:	000003d4 	ldrdeq	r0, [r0], -r4
 56c:	0000913c 	andeq	r9, r0, ip, lsr r1
 570:	00000328 	andeq	r0, r0, r8, lsr #6
 574:	84200e42 	strthi	r0, [r0], #-3650	; 0xfffff1be
 578:	86078508 	strhi	r8, [r7], -r8, lsl #10
 57c:	88058706 	stmdahi	r5, {r1, r2, r8, r9, sl, pc}
 580:	8b038904 	blhi	e2998 <__bss_end+0xd8db0>
 584:	42018e02 	andmi	r8, r1, #2, 28
 588:	03040b0c 	movweq	r0, #19212	; 0x4b0c
 58c:	0d0c018a 	stfeqs	f0, [ip, #-552]	; 0xfffffdd8
 590:	00000020 	andeq	r0, r0, r0, lsr #32
 594:	0000000c 	andeq	r0, r0, ip
 598:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 59c:	7c010001 	stcvc	0, cr0, [r1], {1}
 5a0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 5a4:	0000000c 	andeq	r0, r0, ip
 5a8:	00000594 	muleq	r0, r4, r5
 5ac:	00009464 	andeq	r9, r0, r4, ror #8
 5b0:	000001ec 	andeq	r0, r0, ip, ror #3
 5b4:	0000000c 	andeq	r0, r0, ip
 5b8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 5bc:	7c020001 	stcvc	0, cr0, [r2], {1}
 5c0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 5c4:	00000010 	andeq	r0, r0, r0, lsl r0
 5c8:	000005b4 			; <UNDEFINED> instruction: 0x000005b4
 5cc:	00009674 	andeq	r9, r0, r4, ror r6
 5d0:	0000019c 	muleq	r0, ip, r1
 5d4:	0bce020a 	bleq	ff380e04 <__bss_end+0xff37721c>
 5d8:	00000010 	andeq	r0, r0, r0, lsl r0
 5dc:	000005b4 			; <UNDEFINED> instruction: 0x000005b4
 5e0:	00009810 	andeq	r9, r0, r0, lsl r8
 5e4:	00000028 	andeq	r0, r0, r8, lsr #32
 5e8:	000b540a 	andeq	r5, fp, sl, lsl #8
 5ec:	00000010 	andeq	r0, r0, r0, lsl r0
 5f0:	000005b4 			; <UNDEFINED> instruction: 0x000005b4
 5f4:	00009838 	andeq	r9, r0, r8, lsr r8
 5f8:	0000008c 	andeq	r0, r0, ip, lsl #1
 5fc:	0b46020a 	bleq	1180e2c <__bss_end+0x1177244>
 600:	0000000c 	andeq	r0, r0, ip
 604:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 608:	7c020001 	stcvc	0, cr0, [r2], {1}
 60c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 610:	00000030 	andeq	r0, r0, r0, lsr r0
 614:	00000600 	andeq	r0, r0, r0, lsl #12
 618:	000098c4 	andeq	r9, r0, r4, asr #17
 61c:	000000d4 	ldrdeq	r0, [r0], -r4
 620:	8e100e5a 	mrchi	14, 0, r0, cr0, cr10, {2}
 624:	460a4a03 	strmi	r4, [sl], -r3, lsl #20
 628:	42100ece 	andsmi	r0, r0, #3296	; 0xce0
 62c:	460a4a0b 	strmi	r4, [sl], -fp, lsl #20
 630:	4a100ece 	bmi	404170 <__bss_end+0x3fa588>
 634:	460a460b 	strmi	r4, [sl], -fp, lsl #12
 638:	46100ece 	ldrmi	r0, [r0], -lr, asr #29
 63c:	0ece4c0b 	cdpeq	12, 12, cr4, cr14, cr11, {0}
 640:	00000010 	andeq	r0, r0, r0, lsl r0
 644:	0000000c 	andeq	r0, r0, ip
 648:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 64c:	7c020001 	stcvc	0, cr0, [r2], {1}
 650:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 654:	00000014 	andeq	r0, r0, r4, lsl r0
 658:	00000644 	andeq	r0, r0, r4, asr #12
 65c:	00009998 	muleq	r0, r8, r9
 660:	00000030 	andeq	r0, r0, r0, lsr r0
 664:	84080e4e 	strhi	r0, [r8], #-3662	; 0xfffff1b2
 668:	00018e02 	andeq	r8, r1, r2, lsl #28
 66c:	0000000c 	andeq	r0, r0, ip
 670:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 674:	7c020001 	stcvc	0, cr0, [r2], {1}
 678:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 67c:	0000000c 	andeq	r0, r0, ip
 680:	0000066c 	andeq	r0, r0, ip, ror #12
 684:	000099c8 	andeq	r9, r0, r8, asr #19
 688:	00000040 	andeq	r0, r0, r0, asr #32
 68c:	0000000c 	andeq	r0, r0, ip
 690:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 694:	7c020001 	stcvc	0, cr0, [r2], {1}
 698:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 69c:	00000020 	andeq	r0, r0, r0, lsr #32
 6a0:	0000068c 	andeq	r0, r0, ip, lsl #13
 6a4:	00009a08 	andeq	r9, r0, r8, lsl #20
 6a8:	00000120 	andeq	r0, r0, r0, lsr #2
 6ac:	841c0e46 	ldrhi	r0, [ip], #-3654	; 0xfffff1ba
 6b0:	86068507 	strhi	r8, [r6], -r7, lsl #10
 6b4:	88048705 	stmdahi	r4, {r0, r2, r8, r9, sl, pc}
 6b8:	8e028903 	vmlahi.f16	s16, s4, s6	; <UNPREDICTABLE>
 6bc:	00000001 	andeq	r0, r0, r1

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

