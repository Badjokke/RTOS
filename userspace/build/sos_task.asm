
./sos_task:     file format elf32-littlearm


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
    805c:	00009c80 	andeq	r9, r0, r0, lsl #25
    8060:	00009c98 	muleq	r0, r8, ip

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
    8080:	eb000089 	bl	82ac <main>
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
    81cc:	00009c80 	andeq	r9, r0, r0, lsl #25
    81d0:	00009c80 	andeq	r9, r0, r0, lsl #25

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
    8224:	00009c80 	andeq	r9, r0, r0, lsl #25
    8228:	00009c80 	andeq	r9, r0, r0, lsl #25

0000822c <_Z5blinkb>:
_Z5blinkb():
/home/trefil/sem/sources/userspace/sos_task/main.cpp:23

uint32_t sos_led;
uint32_t button;

void blink(bool short_blink)
{
    822c:	e92d4800 	push	{fp, lr}
    8230:	e28db004 	add	fp, sp, #4
    8234:	e24dd008 	sub	sp, sp, #8
    8238:	e1a03000 	mov	r3, r0
    823c:	e54b3005 	strb	r3, [fp, #-5]
/home/trefil/sem/sources/userspace/sos_task/main.cpp:24
	write(sos_led, "1", 1);
    8240:	e59f3058 	ldr	r3, [pc, #88]	; 82a0 <_Z5blinkb+0x74>
    8244:	e5933000 	ldr	r3, [r3]
    8248:	e3a02001 	mov	r2, #1
    824c:	e59f1050 	ldr	r1, [pc, #80]	; 82a4 <_Z5blinkb+0x78>
    8250:	e1a00003 	mov	r0, r3
    8254:	eb0000b1 	bl	8520 <_Z5writejPKcj>
/home/trefil/sem/sources/userspace/sos_task/main.cpp:25
	sleep(short_blink ? 0x800 : 0x1000);
    8258:	e55b3005 	ldrb	r3, [fp, #-5]
    825c:	e3530000 	cmp	r3, #0
    8260:	0a000001 	beq	826c <_Z5blinkb+0x40>
/home/trefil/sem/sources/userspace/sos_task/main.cpp:25 (discriminator 1)
    8264:	e3a03b02 	mov	r3, #2048	; 0x800
    8268:	ea000000 	b	8270 <_Z5blinkb+0x44>
/home/trefil/sem/sources/userspace/sos_task/main.cpp:25 (discriminator 2)
    826c:	e3a03a01 	mov	r3, #4096	; 0x1000
/home/trefil/sem/sources/userspace/sos_task/main.cpp:25 (discriminator 4)
    8270:	e3e01001 	mvn	r1, #1
    8274:	e1a00003 	mov	r0, r3
    8278:	eb000100 	bl	8680 <_Z5sleepjj>
/home/trefil/sem/sources/userspace/sos_task/main.cpp:26 (discriminator 4)
	write(sos_led, "0", 1);
    827c:	e59f301c 	ldr	r3, [pc, #28]	; 82a0 <_Z5blinkb+0x74>
    8280:	e5933000 	ldr	r3, [r3]
    8284:	e3a02001 	mov	r2, #1
    8288:	e59f1018 	ldr	r1, [pc, #24]	; 82a8 <_Z5blinkb+0x7c>
    828c:	e1a00003 	mov	r0, r3
    8290:	eb0000a2 	bl	8520 <_Z5writejPKcj>
/home/trefil/sem/sources/userspace/sos_task/main.cpp:27 (discriminator 4)
}
    8294:	e320f000 	nop	{0}
    8298:	e24bd004 	sub	sp, fp, #4
    829c:	e8bd8800 	pop	{fp, pc}
    82a0:	00009c80 	andeq	r9, r0, r0, lsl #25
    82a4:	00009c00 	andeq	r9, r0, r0, lsl #24
    82a8:	00009c04 	andeq	r9, r0, r4, lsl #24

000082ac <main>:
main():
/home/trefil/sem/sources/userspace/sos_task/main.cpp:30

int main(int argc, char** argv)
{
    82ac:	e92d4800 	push	{fp, lr}
    82b0:	e28db004 	add	fp, sp, #4
    82b4:	e24dd010 	sub	sp, sp, #16
    82b8:	e50b0010 	str	r0, [fp, #-16]
    82bc:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/userspace/sos_task/main.cpp:31
	sos_led = open("DEV:gpio/18", NFile_Open_Mode::Write_Only);
    82c0:	e3a01001 	mov	r1, #1
    82c4:	e59f0134 	ldr	r0, [pc, #308]	; 8400 <main+0x154>
    82c8:	eb00006f 	bl	848c <_Z4openPKc15NFile_Open_Mode>
    82cc:	e1a03000 	mov	r3, r0
    82d0:	e59f212c 	ldr	r2, [pc, #300]	; 8404 <main+0x158>
    82d4:	e5823000 	str	r3, [r2]
/home/trefil/sem/sources/userspace/sos_task/main.cpp:32
	button = open("DEV:gpio/16", NFile_Open_Mode::Read_Only);
    82d8:	e3a01000 	mov	r1, #0
    82dc:	e59f0124 	ldr	r0, [pc, #292]	; 8408 <main+0x15c>
    82e0:	eb000069 	bl	848c <_Z4openPKc15NFile_Open_Mode>
    82e4:	e1a03000 	mov	r3, r0
    82e8:	e59f211c 	ldr	r2, [pc, #284]	; 840c <main+0x160>
    82ec:	e5823000 	str	r3, [r2]
/home/trefil/sem/sources/userspace/sos_task/main.cpp:34

	NGPIO_Interrupt_Type irtype = NGPIO_Interrupt_Type::Rising_Edge;
    82f0:	e3a03000 	mov	r3, #0
    82f4:	e50b300c 	str	r3, [fp, #-12]
/home/trefil/sem/sources/userspace/sos_task/main.cpp:35
	ioctl(button, NIOCtl_Operation::Enable_Event_Detection, &irtype);
    82f8:	e59f310c 	ldr	r3, [pc, #268]	; 840c <main+0x160>
    82fc:	e5933000 	ldr	r3, [r3]
    8300:	e24b200c 	sub	r2, fp, #12
    8304:	e3a01002 	mov	r1, #2
    8308:	e1a00003 	mov	r0, r3
    830c:	eb0000a2 	bl	859c <_Z5ioctlj16NIOCtl_OperationPv>
/home/trefil/sem/sources/userspace/sos_task/main.cpp:37

	uint32_t logpipe = pipe("log", 32);
    8310:	e3a01020 	mov	r1, #32
    8314:	e59f00f4 	ldr	r0, [pc, #244]	; 8410 <main+0x164>
    8318:	eb000129 	bl	87c4 <_Z4pipePKcj>
    831c:	e50b0008 	str	r0, [fp, #-8]
/home/trefil/sem/sources/userspace/sos_task/main.cpp:42 (discriminator 1)

	while (true)
	{
		// pockame na stisk klavesy
		wait(button, 1, 0x300);
    8320:	e59f30e4 	ldr	r3, [pc, #228]	; 840c <main+0x160>
    8324:	e5933000 	ldr	r3, [r3]
    8328:	e3a02c03 	mov	r2, #768	; 0x300
    832c:	e3a01001 	mov	r1, #1
    8330:	e1a00003 	mov	r0, r3
    8334:	eb0000bd 	bl	8630 <_Z4waitjjj>
/home/trefil/sem/sources/userspace/sos_task/main.cpp:51 (discriminator 1)
		// 2) my mame deadline 0x300
		// 3) log task ma deadline 0x1000
		// 4) jiny task ma deadline 0x500
		// jiny task dostane prednost pred log taskem, a pokud nesplni v kratkem case svou ulohu, tento task prekroci deadline
		// TODO: inverzi priorit bychom docasne zvysili prioritu (zkratili deadline) log tasku, aby vyprazdnil pipe a my se mohli odblokovat co nejdrive
		write(logpipe, "SOS!", 5);
    8338:	e3a02005 	mov	r2, #5
    833c:	e59f10d0 	ldr	r1, [pc, #208]	; 8414 <main+0x168>
    8340:	e51b0008 	ldr	r0, [fp, #-8]
    8344:	eb000075 	bl	8520 <_Z5writejPKcj>
/home/trefil/sem/sources/userspace/sos_task/main.cpp:53 (discriminator 1)

		blink(true);
    8348:	e3a00001 	mov	r0, #1
    834c:	ebffffb6 	bl	822c <_Z5blinkb>
/home/trefil/sem/sources/userspace/sos_task/main.cpp:54 (discriminator 1)
		sleep(symbol_tick_delay);
    8350:	e3e01001 	mvn	r1, #1
    8354:	e3a00b01 	mov	r0, #1024	; 0x400
    8358:	eb0000c8 	bl	8680 <_Z5sleepjj>
/home/trefil/sem/sources/userspace/sos_task/main.cpp:55 (discriminator 1)
		blink(true);
    835c:	e3a00001 	mov	r0, #1
    8360:	ebffffb1 	bl	822c <_Z5blinkb>
/home/trefil/sem/sources/userspace/sos_task/main.cpp:56 (discriminator 1)
		sleep(symbol_tick_delay);
    8364:	e3e01001 	mvn	r1, #1
    8368:	e3a00b01 	mov	r0, #1024	; 0x400
    836c:	eb0000c3 	bl	8680 <_Z5sleepjj>
/home/trefil/sem/sources/userspace/sos_task/main.cpp:57 (discriminator 1)
		blink(true);
    8370:	e3a00001 	mov	r0, #1
    8374:	ebffffac 	bl	822c <_Z5blinkb>
/home/trefil/sem/sources/userspace/sos_task/main.cpp:59 (discriminator 1)

		sleep(char_tick_delay);
    8378:	e3e01001 	mvn	r1, #1
    837c:	e3a00a01 	mov	r0, #4096	; 0x1000
    8380:	eb0000be 	bl	8680 <_Z5sleepjj>
/home/trefil/sem/sources/userspace/sos_task/main.cpp:61 (discriminator 1)

		blink(false);
    8384:	e3a00000 	mov	r0, #0
    8388:	ebffffa7 	bl	822c <_Z5blinkb>
/home/trefil/sem/sources/userspace/sos_task/main.cpp:62 (discriminator 1)
		sleep(symbol_tick_delay);
    838c:	e3e01001 	mvn	r1, #1
    8390:	e3a00b01 	mov	r0, #1024	; 0x400
    8394:	eb0000b9 	bl	8680 <_Z5sleepjj>
/home/trefil/sem/sources/userspace/sos_task/main.cpp:63 (discriminator 1)
		blink(false);
    8398:	e3a00000 	mov	r0, #0
    839c:	ebffffa2 	bl	822c <_Z5blinkb>
/home/trefil/sem/sources/userspace/sos_task/main.cpp:64 (discriminator 1)
		sleep(symbol_tick_delay);
    83a0:	e3e01001 	mvn	r1, #1
    83a4:	e3a00b01 	mov	r0, #1024	; 0x400
    83a8:	eb0000b4 	bl	8680 <_Z5sleepjj>
/home/trefil/sem/sources/userspace/sos_task/main.cpp:65 (discriminator 1)
		blink(false);
    83ac:	e3a00000 	mov	r0, #0
    83b0:	ebffff9d 	bl	822c <_Z5blinkb>
/home/trefil/sem/sources/userspace/sos_task/main.cpp:66 (discriminator 1)
		sleep(symbol_tick_delay);
    83b4:	e3e01001 	mvn	r1, #1
    83b8:	e3a00b01 	mov	r0, #1024	; 0x400
    83bc:	eb0000af 	bl	8680 <_Z5sleepjj>
/home/trefil/sem/sources/userspace/sos_task/main.cpp:68 (discriminator 1)

		sleep(char_tick_delay);
    83c0:	e3e01001 	mvn	r1, #1
    83c4:	e3a00a01 	mov	r0, #4096	; 0x1000
    83c8:	eb0000ac 	bl	8680 <_Z5sleepjj>
/home/trefil/sem/sources/userspace/sos_task/main.cpp:70 (discriminator 1)

		blink(true);
    83cc:	e3a00001 	mov	r0, #1
    83d0:	ebffff95 	bl	822c <_Z5blinkb>
/home/trefil/sem/sources/userspace/sos_task/main.cpp:71 (discriminator 1)
		sleep(symbol_tick_delay);
    83d4:	e3e01001 	mvn	r1, #1
    83d8:	e3a00b01 	mov	r0, #1024	; 0x400
    83dc:	eb0000a7 	bl	8680 <_Z5sleepjj>
/home/trefil/sem/sources/userspace/sos_task/main.cpp:72 (discriminator 1)
		blink(true);
    83e0:	e3a00001 	mov	r0, #1
    83e4:	ebffff90 	bl	822c <_Z5blinkb>
/home/trefil/sem/sources/userspace/sos_task/main.cpp:73 (discriminator 1)
		sleep(symbol_tick_delay);
    83e8:	e3e01001 	mvn	r1, #1
    83ec:	e3a00b01 	mov	r0, #1024	; 0x400
    83f0:	eb0000a2 	bl	8680 <_Z5sleepjj>
/home/trefil/sem/sources/userspace/sos_task/main.cpp:74 (discriminator 1)
		blink(true);
    83f4:	e3a00001 	mov	r0, #1
    83f8:	ebffff8b 	bl	822c <_Z5blinkb>
/home/trefil/sem/sources/userspace/sos_task/main.cpp:42 (discriminator 1)
		wait(button, 1, 0x300);
    83fc:	eaffffc7 	b	8320 <main+0x74>
    8400:	00009c08 	andeq	r9, r0, r8, lsl #24
    8404:	00009c80 	andeq	r9, r0, r0, lsl #25
    8408:	00009c14 	andeq	r9, r0, r4, lsl ip
    840c:	00009c84 	andeq	r9, r0, r4, lsl #25
    8410:	00009c20 	andeq	r9, r0, r0, lsr #24
    8414:	00009c24 	andeq	r9, r0, r4, lsr #24

00008418 <_Z6getpidv>:
_Z6getpidv():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:5
#include <stdfile.h>
#include <stdstring.h>

uint32_t getpid()
{
    8418:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    841c:	e28db000 	add	fp, sp, #0
    8420:	e24dd00c 	sub	sp, sp, #12
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:8
    uint32_t pid;

    asm volatile("swi 0");
    8424:	ef000000 	svc	0x00000000
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:9
    asm volatile("mov %0, r0" : "=r" (pid));
    8428:	e1a03000 	mov	r3, r0
    842c:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:11

    return pid;
    8430:	e51b3008 	ldr	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:12
}
    8434:	e1a00003 	mov	r0, r3
    8438:	e28bd000 	add	sp, fp, #0
    843c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8440:	e12fff1e 	bx	lr

00008444 <_Z9terminatei>:
_Z9terminatei():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:15

void terminate(int exitcode)
{
    8444:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8448:	e28db000 	add	fp, sp, #0
    844c:	e24dd00c 	sub	sp, sp, #12
    8450:	e50b0008 	str	r0, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:16
    asm volatile("mov r0, %0" : : "r" (exitcode));
    8454:	e51b3008 	ldr	r3, [fp, #-8]
    8458:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:17
    asm volatile("swi 1");
    845c:	ef000001 	svc	0x00000001
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:18
}
    8460:	e320f000 	nop	{0}
    8464:	e28bd000 	add	sp, fp, #0
    8468:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    846c:	e12fff1e 	bx	lr

00008470 <_Z11sched_yieldv>:
_Z11sched_yieldv():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:21

void sched_yield()
{
    8470:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8474:	e28db000 	add	fp, sp, #0
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:22
    asm volatile("swi 2");
    8478:	ef000002 	svc	0x00000002
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:23
}
    847c:	e320f000 	nop	{0}
    8480:	e28bd000 	add	sp, fp, #0
    8484:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8488:	e12fff1e 	bx	lr

0000848c <_Z4openPKc15NFile_Open_Mode>:
_Z4openPKc15NFile_Open_Mode():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:26

uint32_t open(const char* filename, NFile_Open_Mode mode)
{
    848c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8490:	e28db000 	add	fp, sp, #0
    8494:	e24dd014 	sub	sp, sp, #20
    8498:	e50b0010 	str	r0, [fp, #-16]
    849c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:29
    uint32_t file;

    asm volatile("mov r0, %0" : : "r" (filename));
    84a0:	e51b3010 	ldr	r3, [fp, #-16]
    84a4:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:30
    asm volatile("mov r1, %0" : : "r" (mode));
    84a8:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    84ac:	e1a01003 	mov	r1, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:31
    asm volatile("swi 64");
    84b0:	ef000040 	svc	0x00000040
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:32
    asm volatile("mov %0, r0" : "=r" (file));
    84b4:	e1a03000 	mov	r3, r0
    84b8:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:34

    return file;
    84bc:	e51b3008 	ldr	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:35
}
    84c0:	e1a00003 	mov	r0, r3
    84c4:	e28bd000 	add	sp, fp, #0
    84c8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    84cc:	e12fff1e 	bx	lr

000084d0 <_Z4readjPcj>:
_Z4readjPcj():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:38

uint32_t read(uint32_t file, char* const buffer, uint32_t size)
{
    84d0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    84d4:	e28db000 	add	fp, sp, #0
    84d8:	e24dd01c 	sub	sp, sp, #28
    84dc:	e50b0010 	str	r0, [fp, #-16]
    84e0:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    84e4:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:41
    uint32_t rdnum;

    asm volatile("mov r0, %0" : : "r" (file));
    84e8:	e51b3010 	ldr	r3, [fp, #-16]
    84ec:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:42
    asm volatile("mov r1, %0" : : "r" (buffer));
    84f0:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    84f4:	e1a01003 	mov	r1, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:43
    asm volatile("mov r2, %0" : : "r" (size));
    84f8:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    84fc:	e1a02003 	mov	r2, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:44
    asm volatile("swi 65");
    8500:	ef000041 	svc	0x00000041
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:45
    asm volatile("mov %0, r0" : "=r" (rdnum));
    8504:	e1a03000 	mov	r3, r0
    8508:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:47

    return rdnum;
    850c:	e51b3008 	ldr	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:48
}
    8510:	e1a00003 	mov	r0, r3
    8514:	e28bd000 	add	sp, fp, #0
    8518:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    851c:	e12fff1e 	bx	lr

00008520 <_Z5writejPKcj>:
_Z5writejPKcj():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:52


uint32_t write(uint32_t file, const char* buffer, uint32_t size)
{
    8520:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8524:	e28db000 	add	fp, sp, #0
    8528:	e24dd01c 	sub	sp, sp, #28
    852c:	e50b0010 	str	r0, [fp, #-16]
    8530:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8534:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:55
    uint32_t wrnum;

    asm volatile("mov r0, %0" : : "r" (file));
    8538:	e51b3010 	ldr	r3, [fp, #-16]
    853c:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:56
    asm volatile("mov r1, %0" : : "r" (buffer));
    8540:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8544:	e1a01003 	mov	r1, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:57
    asm volatile("mov r2, %0" : : "r" (size));
    8548:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    854c:	e1a02003 	mov	r2, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:58
    asm volatile("swi 66");
    8550:	ef000042 	svc	0x00000042
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:59
    asm volatile("mov %0, r0" : "=r" (wrnum));
    8554:	e1a03000 	mov	r3, r0
    8558:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:61

    return wrnum;
    855c:	e51b3008 	ldr	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:62
}
    8560:	e1a00003 	mov	r0, r3
    8564:	e28bd000 	add	sp, fp, #0
    8568:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    856c:	e12fff1e 	bx	lr

00008570 <_Z5closej>:
_Z5closej():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:65

void close(uint32_t file)
{
    8570:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8574:	e28db000 	add	fp, sp, #0
    8578:	e24dd00c 	sub	sp, sp, #12
    857c:	e50b0008 	str	r0, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:66
    asm volatile("mov r0, %0" : : "r" (file));
    8580:	e51b3008 	ldr	r3, [fp, #-8]
    8584:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:67
    asm volatile("swi 67");
    8588:	ef000043 	svc	0x00000043
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:68
}
    858c:	e320f000 	nop	{0}
    8590:	e28bd000 	add	sp, fp, #0
    8594:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8598:	e12fff1e 	bx	lr

0000859c <_Z5ioctlj16NIOCtl_OperationPv>:
_Z5ioctlj16NIOCtl_OperationPv():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:71

uint32_t ioctl(uint32_t file, NIOCtl_Operation operation, void* param)
{
    859c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    85a0:	e28db000 	add	fp, sp, #0
    85a4:	e24dd01c 	sub	sp, sp, #28
    85a8:	e50b0010 	str	r0, [fp, #-16]
    85ac:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    85b0:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:74
    uint32_t retcode;

    asm volatile("mov r0, %0" : : "r" (file));
    85b4:	e51b3010 	ldr	r3, [fp, #-16]
    85b8:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:75
    asm volatile("mov r1, %0" : : "r" (operation));
    85bc:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    85c0:	e1a01003 	mov	r1, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:76
    asm volatile("mov r2, %0" : : "r" (param));
    85c4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    85c8:	e1a02003 	mov	r2, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:77
    asm volatile("swi 68");
    85cc:	ef000044 	svc	0x00000044
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:78
    asm volatile("mov %0, r0" : "=r" (retcode));
    85d0:	e1a03000 	mov	r3, r0
    85d4:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:80

    return retcode;
    85d8:	e51b3008 	ldr	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:81
}
    85dc:	e1a00003 	mov	r0, r3
    85e0:	e28bd000 	add	sp, fp, #0
    85e4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    85e8:	e12fff1e 	bx	lr

000085ec <_Z6notifyjj>:
_Z6notifyjj():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:84

uint32_t notify(uint32_t file, uint32_t count)
{
    85ec:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    85f0:	e28db000 	add	fp, sp, #0
    85f4:	e24dd014 	sub	sp, sp, #20
    85f8:	e50b0010 	str	r0, [fp, #-16]
    85fc:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:87
    uint32_t retcnt;

    asm volatile("mov r0, %0" : : "r" (file));
    8600:	e51b3010 	ldr	r3, [fp, #-16]
    8604:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:88
    asm volatile("mov r1, %0" : : "r" (count));
    8608:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    860c:	e1a01003 	mov	r1, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:89
    asm volatile("swi 69");
    8610:	ef000045 	svc	0x00000045
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:90
    asm volatile("mov %0, r0" : "=r" (retcnt));
    8614:	e1a03000 	mov	r3, r0
    8618:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:92

    return retcnt;
    861c:	e51b3008 	ldr	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:93
}
    8620:	e1a00003 	mov	r0, r3
    8624:	e28bd000 	add	sp, fp, #0
    8628:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    862c:	e12fff1e 	bx	lr

00008630 <_Z4waitjjj>:
_Z4waitjjj():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:96

NSWI_Result_Code wait(uint32_t file, uint32_t count, uint32_t notified_deadline)
{
    8630:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8634:	e28db000 	add	fp, sp, #0
    8638:	e24dd01c 	sub	sp, sp, #28
    863c:	e50b0010 	str	r0, [fp, #-16]
    8640:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8644:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:99
    NSWI_Result_Code retcode;

    asm volatile("mov r0, %0" : : "r" (file));
    8648:	e51b3010 	ldr	r3, [fp, #-16]
    864c:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:100
    asm volatile("mov r1, %0" : : "r" (count));
    8650:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8654:	e1a01003 	mov	r1, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:101
    asm volatile("mov r2, %0" : : "r" (notified_deadline));
    8658:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    865c:	e1a02003 	mov	r2, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:102
    asm volatile("swi 70");
    8660:	ef000046 	svc	0x00000046
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:103
    asm volatile("mov %0, r0" : "=r" (retcode));
    8664:	e1a03000 	mov	r3, r0
    8668:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:105

    return retcode;
    866c:	e51b3008 	ldr	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:106
}
    8670:	e1a00003 	mov	r0, r3
    8674:	e28bd000 	add	sp, fp, #0
    8678:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    867c:	e12fff1e 	bx	lr

00008680 <_Z5sleepjj>:
_Z5sleepjj():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:109

bool sleep(uint32_t ticks, uint32_t notified_deadline)
{
    8680:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8684:	e28db000 	add	fp, sp, #0
    8688:	e24dd014 	sub	sp, sp, #20
    868c:	e50b0010 	str	r0, [fp, #-16]
    8690:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:112
    uint32_t retcode;

    asm volatile("mov r0, %0" : : "r" (ticks));
    8694:	e51b3010 	ldr	r3, [fp, #-16]
    8698:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:113
    asm volatile("mov r1, %0" : : "r" (notified_deadline));
    869c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    86a0:	e1a01003 	mov	r1, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:114
    asm volatile("swi 3");
    86a4:	ef000003 	svc	0x00000003
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:115
    asm volatile("mov %0, r0" : "=r" (retcode));
    86a8:	e1a03000 	mov	r3, r0
    86ac:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:117

    return retcode;
    86b0:	e51b3008 	ldr	r3, [fp, #-8]
    86b4:	e3530000 	cmp	r3, #0
    86b8:	13a03001 	movne	r3, #1
    86bc:	03a03000 	moveq	r3, #0
    86c0:	e6ef3073 	uxtb	r3, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:118
}
    86c4:	e1a00003 	mov	r0, r3
    86c8:	e28bd000 	add	sp, fp, #0
    86cc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    86d0:	e12fff1e 	bx	lr

000086d4 <_Z24get_active_process_countv>:
_Z24get_active_process_countv():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:121

uint32_t get_active_process_count()
{
    86d4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    86d8:	e28db000 	add	fp, sp, #0
    86dc:	e24dd00c 	sub	sp, sp, #12
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:122
    const NGet_Sched_Info_Type req = NGet_Sched_Info_Type::Active_Process_Count;
    86e0:	e3a03000 	mov	r3, #0
    86e4:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:125
    uint32_t retval;

    asm volatile("mov r0, %0" : : "r" (req));
    86e8:	e3a03000 	mov	r3, #0
    86ec:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:126
    asm volatile("mov r1, %0" : : "r" (&retval));
    86f0:	e24b300c 	sub	r3, fp, #12
    86f4:	e1a01003 	mov	r1, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:127
    asm volatile("swi 4");
    86f8:	ef000004 	svc	0x00000004
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:129

    return retval;
    86fc:	e51b300c 	ldr	r3, [fp, #-12]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:130
}
    8700:	e1a00003 	mov	r0, r3
    8704:	e28bd000 	add	sp, fp, #0
    8708:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    870c:	e12fff1e 	bx	lr

00008710 <_Z14get_tick_countv>:
_Z14get_tick_countv():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:133

uint32_t get_tick_count()
{
    8710:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8714:	e28db000 	add	fp, sp, #0
    8718:	e24dd00c 	sub	sp, sp, #12
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:134
    const NGet_Sched_Info_Type req = NGet_Sched_Info_Type::Tick_Count;
    871c:	e3a03001 	mov	r3, #1
    8720:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:137
    uint32_t retval;

    asm volatile("mov r0, %0" : : "r" (req));
    8724:	e3a03001 	mov	r3, #1
    8728:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:138
    asm volatile("mov r1, %0" : : "r" (&retval));
    872c:	e24b300c 	sub	r3, fp, #12
    8730:	e1a01003 	mov	r1, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:139
    asm volatile("swi 4");
    8734:	ef000004 	svc	0x00000004
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:141

    return retval;
    8738:	e51b300c 	ldr	r3, [fp, #-12]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:142
}
    873c:	e1a00003 	mov	r0, r3
    8740:	e28bd000 	add	sp, fp, #0
    8744:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8748:	e12fff1e 	bx	lr

0000874c <_Z17set_task_deadlinej>:
_Z17set_task_deadlinej():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:145

void set_task_deadline(uint32_t tick_count_required)
{
    874c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8750:	e28db000 	add	fp, sp, #0
    8754:	e24dd014 	sub	sp, sp, #20
    8758:	e50b0010 	str	r0, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:146
    const NDeadline_Subservice req = NDeadline_Subservice::Set_Relative;
    875c:	e3a03000 	mov	r3, #0
    8760:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:148

    asm volatile("mov r0, %0" : : "r" (req));
    8764:	e3a03000 	mov	r3, #0
    8768:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:149
    asm volatile("mov r1, %0" : : "r" (&tick_count_required));
    876c:	e24b3010 	sub	r3, fp, #16
    8770:	e1a01003 	mov	r1, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:150
    asm volatile("swi 5");
    8774:	ef000005 	svc	0x00000005
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:151
}
    8778:	e320f000 	nop	{0}
    877c:	e28bd000 	add	sp, fp, #0
    8780:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8784:	e12fff1e 	bx	lr

00008788 <_Z26get_task_ticks_to_deadlinev>:
_Z26get_task_ticks_to_deadlinev():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:154

uint32_t get_task_ticks_to_deadline()
{
    8788:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    878c:	e28db000 	add	fp, sp, #0
    8790:	e24dd00c 	sub	sp, sp, #12
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:155
    const NDeadline_Subservice req = NDeadline_Subservice::Get_Remaining;
    8794:	e3a03001 	mov	r3, #1
    8798:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:158
    uint32_t ticks;

    asm volatile("mov r0, %0" : : "r" (req));
    879c:	e3a03001 	mov	r3, #1
    87a0:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:159
    asm volatile("mov r1, %0" : : "r" (&ticks));
    87a4:	e24b300c 	sub	r3, fp, #12
    87a8:	e1a01003 	mov	r1, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:160
    asm volatile("swi 5");
    87ac:	ef000005 	svc	0x00000005
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:162

    return ticks;
    87b0:	e51b300c 	ldr	r3, [fp, #-12]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:163
}
    87b4:	e1a00003 	mov	r0, r3
    87b8:	e28bd000 	add	sp, fp, #0
    87bc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    87c0:	e12fff1e 	bx	lr

000087c4 <_Z4pipePKcj>:
_Z4pipePKcj():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:168

const char Pipe_File_Prefix[] = "SYS:pipe/";

uint32_t pipe(const char* name, uint32_t buf_size)
{
    87c4:	e92d4800 	push	{fp, lr}
    87c8:	e28db004 	add	fp, sp, #4
    87cc:	e24dd050 	sub	sp, sp, #80	; 0x50
    87d0:	e50b0050 	str	r0, [fp, #-80]	; 0xffffffb0
    87d4:	e50b1054 	str	r1, [fp, #-84]	; 0xffffffac
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:170
    char fname[64];
    strncpy(fname, Pipe_File_Prefix, sizeof(Pipe_File_Prefix));
    87d8:	e24b3048 	sub	r3, fp, #72	; 0x48
    87dc:	e3a0200a 	mov	r2, #10
    87e0:	e59f1088 	ldr	r1, [pc, #136]	; 8870 <_Z4pipePKcj+0xac>
    87e4:	e1a00003 	mov	r0, r3
    87e8:	eb00014a 	bl	8d18 <_Z7strncpyPcPKci>
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:171
    strncpy(fname + sizeof(Pipe_File_Prefix), name, sizeof(fname) - sizeof(Pipe_File_Prefix) - 1);
    87ec:	e24b3048 	sub	r3, fp, #72	; 0x48
    87f0:	e283300a 	add	r3, r3, #10
    87f4:	e3a02035 	mov	r2, #53	; 0x35
    87f8:	e51b1050 	ldr	r1, [fp, #-80]	; 0xffffffb0
    87fc:	e1a00003 	mov	r0, r3
    8800:	eb000144 	bl	8d18 <_Z7strncpyPcPKci>
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:173

    int ncur = sizeof(Pipe_File_Prefix) + strlen(name);
    8804:	e51b0050 	ldr	r0, [fp, #-80]	; 0xffffffb0
    8808:	eb00019d 	bl	8e84 <_Z6strlenPKc>
    880c:	e1a03000 	mov	r3, r0
    8810:	e283300a 	add	r3, r3, #10
    8814:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:175

    fname[ncur++] = '#';
    8818:	e51b3008 	ldr	r3, [fp, #-8]
    881c:	e2832001 	add	r2, r3, #1
    8820:	e50b2008 	str	r2, [fp, #-8]
    8824:	e2433004 	sub	r3, r3, #4
    8828:	e083300b 	add	r3, r3, fp
    882c:	e3a02023 	mov	r2, #35	; 0x23
    8830:	e5432044 	strb	r2, [r3, #-68]	; 0xffffffbc
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:177

    itoa(buf_size, &fname[ncur], 10);
    8834:	e51b0054 	ldr	r0, [fp, #-84]	; 0xffffffac
    8838:	e24b2048 	sub	r2, fp, #72	; 0x48
    883c:	e51b3008 	ldr	r3, [fp, #-8]
    8840:	e0823003 	add	r3, r2, r3
    8844:	e3a0200a 	mov	r2, #10
    8848:	e1a01003 	mov	r1, r3
    884c:	eb000009 	bl	8878 <_Z4itoaiPcj>
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:179

    return open(fname, NFile_Open_Mode::Read_Write);
    8850:	e24b3048 	sub	r3, fp, #72	; 0x48
    8854:	e3a01002 	mov	r1, #2
    8858:	e1a00003 	mov	r0, r3
    885c:	ebffff0a 	bl	848c <_Z4openPKc15NFile_Open_Mode>
    8860:	e1a03000 	mov	r3, r0
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:180
}
    8864:	e1a00003 	mov	r0, r3
    8868:	e24bd004 	sub	sp, fp, #4
    886c:	e8bd8800 	pop	{fp, pc}
    8870:	00009c58 	andeq	r9, r0, r8, asr ip
    8874:	00000000 	andeq	r0, r0, r0

00008878 <_Z4itoaiPcj>:
_Z4itoaiPcj():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:9
{
    const char CharConvArr[] = "0123456789ABCDEF";
}

void itoa(int input, char* output, unsigned int base)
{
    8878:	e92d4800 	push	{fp, lr}
    887c:	e28db004 	add	fp, sp, #4
    8880:	e24dd020 	sub	sp, sp, #32
    8884:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    8888:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    888c:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:10
    int i = 0;
    8890:	e3a03000 	mov	r3, #0
    8894:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:11
    int j = 0;
    8898:	e3a03000 	mov	r3, #0
    889c:	e50b300c 	str	r3, [fp, #-12]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:13

	while (input > 0)
    88a0:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    88a4:	e3530000 	cmp	r3, #0
    88a8:	da000015 	ble	8904 <_Z4itoaiPcj+0x8c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:15
	{
		output[i] = CharConvArr[input % base];
    88ac:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    88b0:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    88b4:	e1a00003 	mov	r0, r3
    88b8:	eb000380 	bl	96c0 <__aeabi_uidivmod>
    88bc:	e1a03001 	mov	r3, r1
    88c0:	e1a01003 	mov	r1, r3
    88c4:	e51b3008 	ldr	r3, [fp, #-8]
    88c8:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    88cc:	e0823003 	add	r3, r2, r3
    88d0:	e59f2114 	ldr	r2, [pc, #276]	; 89ec <_Z4itoaiPcj+0x174>
    88d4:	e7d22001 	ldrb	r2, [r2, r1]
    88d8:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:16
		input /= base;
    88dc:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    88e0:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    88e4:	e1a00003 	mov	r0, r3
    88e8:	eb0002f9 	bl	94d4 <__udivsi3>
    88ec:	e1a03000 	mov	r3, r0
    88f0:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:17
		i++;
    88f4:	e51b3008 	ldr	r3, [fp, #-8]
    88f8:	e2833001 	add	r3, r3, #1
    88fc:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:13
	while (input > 0)
    8900:	eaffffe6 	b	88a0 <_Z4itoaiPcj+0x28>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:20
	}

    if (i == 0)
    8904:	e51b3008 	ldr	r3, [fp, #-8]
    8908:	e3530000 	cmp	r3, #0
    890c:	1a000007 	bne	8930 <_Z4itoaiPcj+0xb8>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:22
    {
        output[i] = CharConvArr[0];
    8910:	e51b3008 	ldr	r3, [fp, #-8]
    8914:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8918:	e0823003 	add	r3, r2, r3
    891c:	e3a02030 	mov	r2, #48	; 0x30
    8920:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:23
        i++;
    8924:	e51b3008 	ldr	r3, [fp, #-8]
    8928:	e2833001 	add	r3, r3, #1
    892c:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:26
    }

	output[i] = '\0';
    8930:	e51b3008 	ldr	r3, [fp, #-8]
    8934:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8938:	e0823003 	add	r3, r2, r3
    893c:	e3a02000 	mov	r2, #0
    8940:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:27
	i--;
    8944:	e51b3008 	ldr	r3, [fp, #-8]
    8948:	e2433001 	sub	r3, r3, #1
    894c:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:29 (discriminator 2)

	for (j; j <= i/2; j++)
    8950:	e51b3008 	ldr	r3, [fp, #-8]
    8954:	e1a02fa3 	lsr	r2, r3, #31
    8958:	e0823003 	add	r3, r2, r3
    895c:	e1a030c3 	asr	r3, r3, #1
    8960:	e1a02003 	mov	r2, r3
    8964:	e51b300c 	ldr	r3, [fp, #-12]
    8968:	e1530002 	cmp	r3, r2
    896c:	ca00001b 	bgt	89e0 <_Z4itoaiPcj+0x168>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:31 (discriminator 1)
	{
		char c = output[i - j];
    8970:	e51b2008 	ldr	r2, [fp, #-8]
    8974:	e51b300c 	ldr	r3, [fp, #-12]
    8978:	e0423003 	sub	r3, r2, r3
    897c:	e1a02003 	mov	r2, r3
    8980:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8984:	e0833002 	add	r3, r3, r2
    8988:	e5d33000 	ldrb	r3, [r3]
    898c:	e54b300d 	strb	r3, [fp, #-13]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:32 (discriminator 1)
		output[i - j] = output[j];
    8990:	e51b300c 	ldr	r3, [fp, #-12]
    8994:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8998:	e0822003 	add	r2, r2, r3
    899c:	e51b1008 	ldr	r1, [fp, #-8]
    89a0:	e51b300c 	ldr	r3, [fp, #-12]
    89a4:	e0413003 	sub	r3, r1, r3
    89a8:	e1a01003 	mov	r1, r3
    89ac:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    89b0:	e0833001 	add	r3, r3, r1
    89b4:	e5d22000 	ldrb	r2, [r2]
    89b8:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:33 (discriminator 1)
		output[j] = c;
    89bc:	e51b300c 	ldr	r3, [fp, #-12]
    89c0:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    89c4:	e0823003 	add	r3, r2, r3
    89c8:	e55b200d 	ldrb	r2, [fp, #-13]
    89cc:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:29 (discriminator 1)
	for (j; j <= i/2; j++)
    89d0:	e51b300c 	ldr	r3, [fp, #-12]
    89d4:	e2833001 	add	r3, r3, #1
    89d8:	e50b300c 	str	r3, [fp, #-12]
    89dc:	eaffffdb 	b	8950 <_Z4itoaiPcj+0xd8>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:36
	}

}
    89e0:	e320f000 	nop	{0}
    89e4:	e24bd004 	sub	sp, fp, #4
    89e8:	e8bd8800 	pop	{fp, pc}
    89ec:	00009c64 	andeq	r9, r0, r4, ror #24

000089f0 <_Z4atoiPKc>:
_Z4atoiPKc():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:39

int atoi(const char* input)
{
    89f0:	e92d4800 	push	{fp, lr}
    89f4:	e28db004 	add	fp, sp, #4
    89f8:	e24dd010 	sub	sp, sp, #16
    89fc:	e50b0010 	str	r0, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:40
    if(strlen(input) == 1)
    8a00:	e51b0010 	ldr	r0, [fp, #-16]
    8a04:	eb00011e 	bl	8e84 <_Z6strlenPKc>
    8a08:	e1a03000 	mov	r3, r0
    8a0c:	e3530001 	cmp	r3, #1
    8a10:	03a03001 	moveq	r3, #1
    8a14:	13a03000 	movne	r3, #0
    8a18:	e6ef3073 	uxtb	r3, r3
    8a1c:	e3530000 	cmp	r3, #0
    8a20:	0a000003 	beq	8a34 <_Z4atoiPKc+0x44>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:41
        return *input - '0';
    8a24:	e51b3010 	ldr	r3, [fp, #-16]
    8a28:	e5d33000 	ldrb	r3, [r3]
    8a2c:	e2433030 	sub	r3, r3, #48	; 0x30
    8a30:	ea00001e 	b	8ab0 <_Z4atoiPKc+0xc0>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:42
	int output = 0;
    8a34:	e3a03000 	mov	r3, #0
    8a38:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:44

	while (*input != '\0')
    8a3c:	e51b3010 	ldr	r3, [fp, #-16]
    8a40:	e5d33000 	ldrb	r3, [r3]
    8a44:	e3530000 	cmp	r3, #0
    8a48:	0a000017 	beq	8aac <_Z4atoiPKc+0xbc>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:46
	{
		output *= 10;
    8a4c:	e51b2008 	ldr	r2, [fp, #-8]
    8a50:	e1a03002 	mov	r3, r2
    8a54:	e1a03103 	lsl	r3, r3, #2
    8a58:	e0833002 	add	r3, r3, r2
    8a5c:	e1a03083 	lsl	r3, r3, #1
    8a60:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:47
		if (*input > '9' || *input < '0')
    8a64:	e51b3010 	ldr	r3, [fp, #-16]
    8a68:	e5d33000 	ldrb	r3, [r3]
    8a6c:	e3530039 	cmp	r3, #57	; 0x39
    8a70:	8a00000d 	bhi	8aac <_Z4atoiPKc+0xbc>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:47 (discriminator 1)
    8a74:	e51b3010 	ldr	r3, [fp, #-16]
    8a78:	e5d33000 	ldrb	r3, [r3]
    8a7c:	e353002f 	cmp	r3, #47	; 0x2f
    8a80:	9a000009 	bls	8aac <_Z4atoiPKc+0xbc>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:50
			break;

		output += *input - '0';
    8a84:	e51b3010 	ldr	r3, [fp, #-16]
    8a88:	e5d33000 	ldrb	r3, [r3]
    8a8c:	e2433030 	sub	r3, r3, #48	; 0x30
    8a90:	e51b2008 	ldr	r2, [fp, #-8]
    8a94:	e0823003 	add	r3, r2, r3
    8a98:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:52

		input++;
    8a9c:	e51b3010 	ldr	r3, [fp, #-16]
    8aa0:	e2833001 	add	r3, r3, #1
    8aa4:	e50b3010 	str	r3, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:44
	while (*input != '\0')
    8aa8:	eaffffe3 	b	8a3c <_Z4atoiPKc+0x4c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:55
	}

	return output;
    8aac:	e51b3008 	ldr	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:56
}
    8ab0:	e1a00003 	mov	r0, r3
    8ab4:	e24bd004 	sub	sp, fp, #4
    8ab8:	e8bd8800 	pop	{fp, pc}

00008abc <_Z14get_input_typePKc>:
_Z14get_input_typePKc():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:60
//return 1 pokud int
//return 2 pokud float
//return 0 pokud neni cislo
int get_input_type(const char * input){
    8abc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8ac0:	e28db000 	add	fp, sp, #0
    8ac4:	e24dd014 	sub	sp, sp, #20
    8ac8:	e50b0010 	str	r0, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:62
    //existence tecky
    bool dot = false;
    8acc:	e3a03000 	mov	r3, #0
    8ad0:	e54b3005 	strb	r3, [fp, #-5]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:63
    bool trailing_dot = false;
    8ad4:	e3a03000 	mov	r3, #0
    8ad8:	e54b3006 	strb	r3, [fp, #-6]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:64
    while(*input != '\0'){
    8adc:	e51b3010 	ldr	r3, [fp, #-16]
    8ae0:	e5d33000 	ldrb	r3, [r3]
    8ae4:	e3530000 	cmp	r3, #0
    8ae8:	0a000023 	beq	8b7c <_Z14get_input_typePKc+0xc0>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:65
        char c = *input;
    8aec:	e51b3010 	ldr	r3, [fp, #-16]
    8af0:	e5d33000 	ldrb	r3, [r3]
    8af4:	e54b3007 	strb	r3, [fp, #-7]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:66
        if(c == '.' && !dot){
    8af8:	e55b3007 	ldrb	r3, [fp, #-7]
    8afc:	e353002e 	cmp	r3, #46	; 0x2e
    8b00:	1a00000c 	bne	8b38 <_Z14get_input_typePKc+0x7c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:66 (discriminator 1)
    8b04:	e55b3005 	ldrb	r3, [fp, #-5]
    8b08:	e2233001 	eor	r3, r3, #1
    8b0c:	e6ef3073 	uxtb	r3, r3
    8b10:	e3530000 	cmp	r3, #0
    8b14:	0a000007 	beq	8b38 <_Z14get_input_typePKc+0x7c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:67 (discriminator 2)
            dot = true;
    8b18:	e3a03001 	mov	r3, #1
    8b1c:	e54b3005 	strb	r3, [fp, #-5]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:68 (discriminator 2)
            trailing_dot = true;
    8b20:	e3a03001 	mov	r3, #1
    8b24:	e54b3006 	strb	r3, [fp, #-6]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:69 (discriminator 2)
            input++;
    8b28:	e51b3010 	ldr	r3, [fp, #-16]
    8b2c:	e2833001 	add	r3, r3, #1
    8b30:	e50b3010 	str	r3, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:70 (discriminator 2)
            continue;
    8b34:	ea00000f 	b	8b78 <_Z14get_input_typePKc+0xbc>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:73
        }
        //nenumericky znak
        if(c < '0' || c > '9')return 0;
    8b38:	e55b3007 	ldrb	r3, [fp, #-7]
    8b3c:	e353002f 	cmp	r3, #47	; 0x2f
    8b40:	9a000002 	bls	8b50 <_Z14get_input_typePKc+0x94>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:73 (discriminator 2)
    8b44:	e55b3007 	ldrb	r3, [fp, #-7]
    8b48:	e3530039 	cmp	r3, #57	; 0x39
    8b4c:	9a000001 	bls	8b58 <_Z14get_input_typePKc+0x9c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:73 (discriminator 3)
    8b50:	e3a03000 	mov	r3, #0
    8b54:	ea000014 	b	8bac <_Z14get_input_typePKc+0xf0>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:75
        //retezec obsahuje tecku a numericke znaky -> tecka je "validni", tedy neni to tecka na konci intu napriklad
        if(dot)
    8b58:	e55b3005 	ldrb	r3, [fp, #-5]
    8b5c:	e3530000 	cmp	r3, #0
    8b60:	0a000001 	beq	8b6c <_Z14get_input_typePKc+0xb0>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:76
            trailing_dot = false;
    8b64:	e3a03000 	mov	r3, #0
    8b68:	e54b3006 	strb	r3, [fp, #-6]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:77
    input++;
    8b6c:	e51b3010 	ldr	r3, [fp, #-16]
    8b70:	e2833001 	add	r3, r3, #1
    8b74:	e50b3010 	str	r3, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:64
    while(*input != '\0'){
    8b78:	eaffffd7 	b	8adc <_Z14get_input_typePKc+0x20>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:79
    }
    if(trailing_dot)return 0;
    8b7c:	e55b3006 	ldrb	r3, [fp, #-6]
    8b80:	e3530000 	cmp	r3, #0
    8b84:	0a000001 	beq	8b90 <_Z14get_input_typePKc+0xd4>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:79 (discriminator 1)
    8b88:	e3a03000 	mov	r3, #0
    8b8c:	ea000006 	b	8bac <_Z14get_input_typePKc+0xf0>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:81
    //float pokud retezec obsahuje non-trailing tecku, 1 pokud je to int
    return dot? 2:1;
    8b90:	e55b3005 	ldrb	r3, [fp, #-5]
    8b94:	e3530000 	cmp	r3, #0
    8b98:	0a000001 	beq	8ba4 <_Z14get_input_typePKc+0xe8>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:81 (discriminator 1)
    8b9c:	e3a03002 	mov	r3, #2
    8ba0:	ea000000 	b	8ba8 <_Z14get_input_typePKc+0xec>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:81 (discriminator 2)
    8ba4:	e3a03001 	mov	r3, #1
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:81
    8ba8:	e320f000 	nop	{0}
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:83

}
    8bac:	e1a00003 	mov	r0, r3
    8bb0:	e28bd000 	add	sp, fp, #0
    8bb4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8bb8:	e12fff1e 	bx	lr

00008bbc <_Z4atofPKc>:
_Z4atofPKc():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:87


//string to float
float atof(const char* input){
    8bbc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8bc0:	e28db000 	add	fp, sp, #0
    8bc4:	e24dd03c 	sub	sp, sp, #60	; 0x3c
    8bc8:	e50b0038 	str	r0, [fp, #-56]	; 0xffffffc8
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:88
    double output = 0.0;
    8bcc:	e3a02000 	mov	r2, #0
    8bd0:	e3a03000 	mov	r3, #0
    8bd4:	e14b20fc 	strd	r2, [fp, #-12]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:89
    double factor = 10;
    8bd8:	e3a02000 	mov	r2, #0
    8bdc:	e59f312c 	ldr	r3, [pc, #300]	; 8d10 <_Z4atofPKc+0x154>
    8be0:	e14b21fc 	strd	r2, [fp, #-28]	; 0xffffffe4
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:91
    //cast za desetinnou carkou
    double tmp = 0.0;
    8be4:	e3a02000 	mov	r2, #0
    8be8:	e3a03000 	mov	r3, #0
    8bec:	e14b22f4 	strd	r2, [fp, #-36]	; 0xffffffdc
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:92
    int counter = 0;
    8bf0:	e3a03000 	mov	r3, #0
    8bf4:	e50b3028 	str	r3, [fp, #-40]	; 0xffffffd8
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:93
    int scale = 1;
    8bf8:	e3a03001 	mov	r3, #1
    8bfc:	e50b3010 	str	r3, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:94
    bool afterDecPoint = false;
    8c00:	e3a03000 	mov	r3, #0
    8c04:	e54b3011 	strb	r3, [fp, #-17]	; 0xffffffef
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:96

    while(*input != '\0'){
    8c08:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    8c0c:	e5d33000 	ldrb	r3, [r3]
    8c10:	e3530000 	cmp	r3, #0
    8c14:	0a000034 	beq	8cec <_Z4atofPKc+0x130>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:97
        if (*input == '.'){
    8c18:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    8c1c:	e5d33000 	ldrb	r3, [r3]
    8c20:	e353002e 	cmp	r3, #46	; 0x2e
    8c24:	1a000005 	bne	8c40 <_Z4atofPKc+0x84>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:98 (discriminator 1)
            afterDecPoint = true;
    8c28:	e3a03001 	mov	r3, #1
    8c2c:	e54b3011 	strb	r3, [fp, #-17]	; 0xffffffef
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:99 (discriminator 1)
            input++;
    8c30:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    8c34:	e2833001 	add	r3, r3, #1
    8c38:	e50b3038 	str	r3, [fp, #-56]	; 0xffffffc8
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:100 (discriminator 1)
            continue;
    8c3c:	ea000029 	b	8ce8 <_Z4atofPKc+0x12c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:102
        }
        else if (*input > '9' || *input < '0')break;
    8c40:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    8c44:	e5d33000 	ldrb	r3, [r3]
    8c48:	e3530039 	cmp	r3, #57	; 0x39
    8c4c:	8a000026 	bhi	8cec <_Z4atofPKc+0x130>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:102 (discriminator 1)
    8c50:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    8c54:	e5d33000 	ldrb	r3, [r3]
    8c58:	e353002f 	cmp	r3, #47	; 0x2f
    8c5c:	9a000022 	bls	8cec <_Z4atofPKc+0x130>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:103
        double val = *input - '0';
    8c60:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    8c64:	e5d33000 	ldrb	r3, [r3]
    8c68:	e2433030 	sub	r3, r3, #48	; 0x30
    8c6c:	ee073a90 	vmov	s15, r3
    8c70:	eeb87be7 	vcvt.f64.s32	d7, s15
    8c74:	ed0b7b0d 	vstr	d7, [fp, #-52]	; 0xffffffcc
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:104
        if(afterDecPoint){
    8c78:	e55b3011 	ldrb	r3, [fp, #-17]	; 0xffffffef
    8c7c:	e3530000 	cmp	r3, #0
    8c80:	0a00000f 	beq	8cc4 <_Z4atofPKc+0x108>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:105
            scale /= 10;
    8c84:	e51b3010 	ldr	r3, [fp, #-16]
    8c88:	e59f2084 	ldr	r2, [pc, #132]	; 8d14 <_Z4atofPKc+0x158>
    8c8c:	e0c21392 	smull	r1, r2, r2, r3
    8c90:	e1a02142 	asr	r2, r2, #2
    8c94:	e1a03fc3 	asr	r3, r3, #31
    8c98:	e0423003 	sub	r3, r2, r3
    8c9c:	e50b3010 	str	r3, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:106
            output = output + val * scale;
    8ca0:	e51b3010 	ldr	r3, [fp, #-16]
    8ca4:	ee073a90 	vmov	s15, r3
    8ca8:	eeb86be7 	vcvt.f64.s32	d6, s15
    8cac:	ed1b7b0d 	vldr	d7, [fp, #-52]	; 0xffffffcc
    8cb0:	ee267b07 	vmul.f64	d7, d6, d7
    8cb4:	ed1b6b03 	vldr	d6, [fp, #-12]
    8cb8:	ee367b07 	vadd.f64	d7, d6, d7
    8cbc:	ed0b7b03 	vstr	d7, [fp, #-12]
    8cc0:	ea000005 	b	8cdc <_Z4atofPKc+0x120>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:109
        }
        else
            output = output * 10 + val;
    8cc4:	ed1b7b03 	vldr	d7, [fp, #-12]
    8cc8:	ed9f6b0e 	vldr	d6, [pc, #56]	; 8d08 <_Z4atofPKc+0x14c>
    8ccc:	ee277b06 	vmul.f64	d7, d7, d6
    8cd0:	ed1b6b0d 	vldr	d6, [fp, #-52]	; 0xffffffcc
    8cd4:	ee367b07 	vadd.f64	d7, d6, d7
    8cd8:	ed0b7b03 	vstr	d7, [fp, #-12]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:111

        input++;
    8cdc:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    8ce0:	e2833001 	add	r3, r3, #1
    8ce4:	e50b3038 	str	r3, [fp, #-56]	; 0xffffffc8
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:96
    while(*input != '\0'){
    8ce8:	eaffffc6 	b	8c08 <_Z4atofPKc+0x4c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:113
    }
    return output;
    8cec:	ed1b7b03 	vldr	d7, [fp, #-12]
    8cf0:	eef77bc7 	vcvt.f32.f64	s15, d7
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:114
}
    8cf4:	eeb00a67 	vmov.f32	s0, s15
    8cf8:	e28bd000 	add	sp, fp, #0
    8cfc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8d00:	e12fff1e 	bx	lr
    8d04:	e320f000 	nop	{0}
    8d08:	00000000 	andeq	r0, r0, r0
    8d0c:	40240000 	eormi	r0, r4, r0
    8d10:	40240000 	eormi	r0, r4, r0
    8d14:	66666667 	strbtvs	r6, [r6], -r7, ror #12

00008d18 <_Z7strncpyPcPKci>:
_Z7strncpyPcPKci():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:116
char* strncpy(char* dest, const char *src, int num)
{
    8d18:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8d1c:	e28db000 	add	fp, sp, #0
    8d20:	e24dd01c 	sub	sp, sp, #28
    8d24:	e50b0010 	str	r0, [fp, #-16]
    8d28:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8d2c:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:119
	int i;

	for (i = 0; i < num && src[i] != '\0'; i++)
    8d30:	e3a03000 	mov	r3, #0
    8d34:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:119 (discriminator 4)
    8d38:	e51b2008 	ldr	r2, [fp, #-8]
    8d3c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8d40:	e1520003 	cmp	r2, r3
    8d44:	aa000011 	bge	8d90 <_Z7strncpyPcPKci+0x78>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:119 (discriminator 2)
    8d48:	e51b3008 	ldr	r3, [fp, #-8]
    8d4c:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    8d50:	e0823003 	add	r3, r2, r3
    8d54:	e5d33000 	ldrb	r3, [r3]
    8d58:	e3530000 	cmp	r3, #0
    8d5c:	0a00000b 	beq	8d90 <_Z7strncpyPcPKci+0x78>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:120 (discriminator 3)
		dest[i] = src[i];
    8d60:	e51b3008 	ldr	r3, [fp, #-8]
    8d64:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    8d68:	e0822003 	add	r2, r2, r3
    8d6c:	e51b3008 	ldr	r3, [fp, #-8]
    8d70:	e51b1010 	ldr	r1, [fp, #-16]
    8d74:	e0813003 	add	r3, r1, r3
    8d78:	e5d22000 	ldrb	r2, [r2]
    8d7c:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:119 (discriminator 3)
	for (i = 0; i < num && src[i] != '\0'; i++)
    8d80:	e51b3008 	ldr	r3, [fp, #-8]
    8d84:	e2833001 	add	r3, r3, #1
    8d88:	e50b3008 	str	r3, [fp, #-8]
    8d8c:	eaffffe9 	b	8d38 <_Z7strncpyPcPKci+0x20>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:121 (discriminator 2)
	for (; i < num; i++)
    8d90:	e51b2008 	ldr	r2, [fp, #-8]
    8d94:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8d98:	e1520003 	cmp	r2, r3
    8d9c:	aa000008 	bge	8dc4 <_Z7strncpyPcPKci+0xac>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:122 (discriminator 1)
		dest[i] = '\0';
    8da0:	e51b3008 	ldr	r3, [fp, #-8]
    8da4:	e51b2010 	ldr	r2, [fp, #-16]
    8da8:	e0823003 	add	r3, r2, r3
    8dac:	e3a02000 	mov	r2, #0
    8db0:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:121 (discriminator 1)
	for (; i < num; i++)
    8db4:	e51b3008 	ldr	r3, [fp, #-8]
    8db8:	e2833001 	add	r3, r3, #1
    8dbc:	e50b3008 	str	r3, [fp, #-8]
    8dc0:	eafffff2 	b	8d90 <_Z7strncpyPcPKci+0x78>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:124

   return dest;
    8dc4:	e51b3010 	ldr	r3, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:125
}
    8dc8:	e1a00003 	mov	r0, r3
    8dcc:	e28bd000 	add	sp, fp, #0
    8dd0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8dd4:	e12fff1e 	bx	lr

00008dd8 <_Z7strncmpPKcS0_i>:
_Z7strncmpPKcS0_i():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:128

int strncmp(const char *s1, const char *s2, int num)
{
    8dd8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8ddc:	e28db000 	add	fp, sp, #0
    8de0:	e24dd01c 	sub	sp, sp, #28
    8de4:	e50b0010 	str	r0, [fp, #-16]
    8de8:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8dec:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:130
	unsigned char u1, u2;
  	while (num-- > 0)
    8df0:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8df4:	e2432001 	sub	r2, r3, #1
    8df8:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
    8dfc:	e3530000 	cmp	r3, #0
    8e00:	c3a03001 	movgt	r3, #1
    8e04:	d3a03000 	movle	r3, #0
    8e08:	e6ef3073 	uxtb	r3, r3
    8e0c:	e3530000 	cmp	r3, #0
    8e10:	0a000016 	beq	8e70 <_Z7strncmpPKcS0_i+0x98>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:132
    {
      	u1 = (unsigned char) *s1++;
    8e14:	e51b3010 	ldr	r3, [fp, #-16]
    8e18:	e2832001 	add	r2, r3, #1
    8e1c:	e50b2010 	str	r2, [fp, #-16]
    8e20:	e5d33000 	ldrb	r3, [r3]
    8e24:	e54b3005 	strb	r3, [fp, #-5]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:133
     	u2 = (unsigned char) *s2++;
    8e28:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8e2c:	e2832001 	add	r2, r3, #1
    8e30:	e50b2014 	str	r2, [fp, #-20]	; 0xffffffec
    8e34:	e5d33000 	ldrb	r3, [r3]
    8e38:	e54b3006 	strb	r3, [fp, #-6]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:134
      	if (u1 != u2)
    8e3c:	e55b2005 	ldrb	r2, [fp, #-5]
    8e40:	e55b3006 	ldrb	r3, [fp, #-6]
    8e44:	e1520003 	cmp	r2, r3
    8e48:	0a000003 	beq	8e5c <_Z7strncmpPKcS0_i+0x84>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:135
        	return u1 - u2;
    8e4c:	e55b2005 	ldrb	r2, [fp, #-5]
    8e50:	e55b3006 	ldrb	r3, [fp, #-6]
    8e54:	e0423003 	sub	r3, r2, r3
    8e58:	ea000005 	b	8e74 <_Z7strncmpPKcS0_i+0x9c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:136
      	if (u1 == '\0')
    8e5c:	e55b3005 	ldrb	r3, [fp, #-5]
    8e60:	e3530000 	cmp	r3, #0
    8e64:	1affffe1 	bne	8df0 <_Z7strncmpPKcS0_i+0x18>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:137
        	return 0;
    8e68:	e3a03000 	mov	r3, #0
    8e6c:	ea000000 	b	8e74 <_Z7strncmpPKcS0_i+0x9c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:140
    }

  	return 0;
    8e70:	e3a03000 	mov	r3, #0
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:141
}
    8e74:	e1a00003 	mov	r0, r3
    8e78:	e28bd000 	add	sp, fp, #0
    8e7c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8e80:	e12fff1e 	bx	lr

00008e84 <_Z6strlenPKc>:
_Z6strlenPKc():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:144

int strlen(const char* s)
{
    8e84:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8e88:	e28db000 	add	fp, sp, #0
    8e8c:	e24dd014 	sub	sp, sp, #20
    8e90:	e50b0010 	str	r0, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:145
	int i = 0;
    8e94:	e3a03000 	mov	r3, #0
    8e98:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:147

	while (s[i] != '\0')
    8e9c:	e51b3008 	ldr	r3, [fp, #-8]
    8ea0:	e51b2010 	ldr	r2, [fp, #-16]
    8ea4:	e0823003 	add	r3, r2, r3
    8ea8:	e5d33000 	ldrb	r3, [r3]
    8eac:	e3530000 	cmp	r3, #0
    8eb0:	0a000003 	beq	8ec4 <_Z6strlenPKc+0x40>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:148
		i++;
    8eb4:	e51b3008 	ldr	r3, [fp, #-8]
    8eb8:	e2833001 	add	r3, r3, #1
    8ebc:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:147
	while (s[i] != '\0')
    8ec0:	eafffff5 	b	8e9c <_Z6strlenPKc+0x18>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:150

	return i;
    8ec4:	e51b3008 	ldr	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:151
}
    8ec8:	e1a00003 	mov	r0, r3
    8ecc:	e28bd000 	add	sp, fp, #0
    8ed0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8ed4:	e12fff1e 	bx	lr

00008ed8 <_Z6strcatPcPKc>:
_Z6strcatPcPKc():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:154
//unsafe varianta
//muze nastat buffer overflow attack
char* strcat(char* dest, const char* src){
    8ed8:	e92d4800 	push	{fp, lr}
    8edc:	e28db004 	add	fp, sp, #4
    8ee0:	e24dd018 	sub	sp, sp, #24
    8ee4:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    8ee8:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:155
    int n = strlen(src);
    8eec:	e51b001c 	ldr	r0, [fp, #-28]	; 0xffffffe4
    8ef0:	ebffffe3 	bl	8e84 <_Z6strlenPKc>
    8ef4:	e50b0010 	str	r0, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:156
    int m = strlen(dest);
    8ef8:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    8efc:	ebffffe0 	bl	8e84 <_Z6strlenPKc>
    8f00:	e50b0008 	str	r0, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:157
    int walker = 0;
    8f04:	e3a03000 	mov	r3, #0
    8f08:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:158
    for(int i = 0;i < n; i++)
    8f0c:	e3a03000 	mov	r3, #0
    8f10:	e50b300c 	str	r3, [fp, #-12]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:158 (discriminator 3)
    8f14:	e51b200c 	ldr	r2, [fp, #-12]
    8f18:	e51b3010 	ldr	r3, [fp, #-16]
    8f1c:	e1520003 	cmp	r2, r3
    8f20:	aa00000e 	bge	8f60 <_Z6strcatPcPKc+0x88>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:159 (discriminator 2)
        dest[m++] = src[i];
    8f24:	e51b300c 	ldr	r3, [fp, #-12]
    8f28:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8f2c:	e0822003 	add	r2, r2, r3
    8f30:	e51b3008 	ldr	r3, [fp, #-8]
    8f34:	e2831001 	add	r1, r3, #1
    8f38:	e50b1008 	str	r1, [fp, #-8]
    8f3c:	e1a01003 	mov	r1, r3
    8f40:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8f44:	e0833001 	add	r3, r3, r1
    8f48:	e5d22000 	ldrb	r2, [r2]
    8f4c:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:158 (discriminator 2)
    for(int i = 0;i < n; i++)
    8f50:	e51b300c 	ldr	r3, [fp, #-12]
    8f54:	e2833001 	add	r3, r3, #1
    8f58:	e50b300c 	str	r3, [fp, #-12]
    8f5c:	eaffffec 	b	8f14 <_Z6strcatPcPKc+0x3c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:160
    dest[m] = '\0';
    8f60:	e51b3008 	ldr	r3, [fp, #-8]
    8f64:	e51b2018 	ldr	r2, [fp, #-24]	; 0xffffffe8
    8f68:	e0823003 	add	r3, r2, r3
    8f6c:	e3a02000 	mov	r2, #0
    8f70:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:161
    return dest;
    8f74:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:163

}
    8f78:	e1a00003 	mov	r0, r3
    8f7c:	e24bd004 	sub	sp, fp, #4
    8f80:	e8bd8800 	pop	{fp, pc}

00008f84 <_Z7strncatPcPKci>:
_Z7strncatPcPKci():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:164
char* strncat(char* dest, const char* src,int size){
    8f84:	e92d4800 	push	{fp, lr}
    8f88:	e28db004 	add	fp, sp, #4
    8f8c:	e24dd020 	sub	sp, sp, #32
    8f90:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    8f94:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    8f98:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:165
    int walker = 0;
    8f9c:	e3a03000 	mov	r3, #0
    8fa0:	e50b3010 	str	r3, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:167
    //najdi odkud muzeme kopirovat, tedy konec retezce
    int m = strlen(dest);
    8fa4:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    8fa8:	ebffffb5 	bl	8e84 <_Z6strlenPKc>
    8fac:	e50b0008 	str	r0, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:169
    //nevejdu se
    if(m >= size)return dest;
    8fb0:	e51b2008 	ldr	r2, [fp, #-8]
    8fb4:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8fb8:	e1520003 	cmp	r2, r3
    8fbc:	ba000001 	blt	8fc8 <_Z7strncatPcPKci+0x44>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:169 (discriminator 1)
    8fc0:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8fc4:	ea000021 	b	9050 <_Z7strncatPcPKci+0xcc>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:171

    for(int i = 0;i < size; i++){
    8fc8:	e3a03000 	mov	r3, #0
    8fcc:	e50b300c 	str	r3, [fp, #-12]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:171 (discriminator 1)
    8fd0:	e51b200c 	ldr	r2, [fp, #-12]
    8fd4:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8fd8:	e1520003 	cmp	r2, r3
    8fdc:	aa000015 	bge	9038 <_Z7strncatPcPKci+0xb4>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:172
        if(src[i] == '\0')break;
    8fe0:	e51b300c 	ldr	r3, [fp, #-12]
    8fe4:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8fe8:	e0823003 	add	r3, r2, r3
    8fec:	e5d33000 	ldrb	r3, [r3]
    8ff0:	e3530000 	cmp	r3, #0
    8ff4:	0a00000e 	beq	9034 <_Z7strncatPcPKci+0xb0>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:173 (discriminator 2)
        dest[m++] = src[i];
    8ff8:	e51b300c 	ldr	r3, [fp, #-12]
    8ffc:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    9000:	e0822003 	add	r2, r2, r3
    9004:	e51b3008 	ldr	r3, [fp, #-8]
    9008:	e2831001 	add	r1, r3, #1
    900c:	e50b1008 	str	r1, [fp, #-8]
    9010:	e1a01003 	mov	r1, r3
    9014:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9018:	e0833001 	add	r3, r3, r1
    901c:	e5d22000 	ldrb	r2, [r2]
    9020:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:171 (discriminator 2)
    for(int i = 0;i < size; i++){
    9024:	e51b300c 	ldr	r3, [fp, #-12]
    9028:	e2833001 	add	r3, r3, #1
    902c:	e50b300c 	str	r3, [fp, #-12]
    9030:	eaffffe6 	b	8fd0 <_Z7strncatPcPKci+0x4c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:172
        if(src[i] == '\0')break;
    9034:	e320f000 	nop	{0}
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:175
    }
    dest[m] = '\0';
    9038:	e51b3008 	ldr	r3, [fp, #-8]
    903c:	e51b2018 	ldr	r2, [fp, #-24]	; 0xffffffe8
    9040:	e0823003 	add	r3, r2, r3
    9044:	e3a02000 	mov	r2, #0
    9048:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:176
    return dest;
    904c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:178

}
    9050:	e1a00003 	mov	r0, r3
    9054:	e24bd004 	sub	sp, fp, #4
    9058:	e8bd8800 	pop	{fp, pc}

0000905c <_Z5bzeroPvi>:
_Z5bzeroPvi():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:182


void bzero(void* memory, int length)
{
    905c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9060:	e28db000 	add	fp, sp, #0
    9064:	e24dd014 	sub	sp, sp, #20
    9068:	e50b0010 	str	r0, [fp, #-16]
    906c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:183
	char* mem = reinterpret_cast<char*>(memory);
    9070:	e51b3010 	ldr	r3, [fp, #-16]
    9074:	e50b300c 	str	r3, [fp, #-12]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:185

	for (int i = 0; i < length; i++)
    9078:	e3a03000 	mov	r3, #0
    907c:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:185 (discriminator 3)
    9080:	e51b2008 	ldr	r2, [fp, #-8]
    9084:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9088:	e1520003 	cmp	r2, r3
    908c:	aa000008 	bge	90b4 <_Z5bzeroPvi+0x58>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:186 (discriminator 2)
		mem[i] = 0;
    9090:	e51b3008 	ldr	r3, [fp, #-8]
    9094:	e51b200c 	ldr	r2, [fp, #-12]
    9098:	e0823003 	add	r3, r2, r3
    909c:	e3a02000 	mov	r2, #0
    90a0:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:185 (discriminator 2)
	for (int i = 0; i < length; i++)
    90a4:	e51b3008 	ldr	r3, [fp, #-8]
    90a8:	e2833001 	add	r3, r3, #1
    90ac:	e50b3008 	str	r3, [fp, #-8]
    90b0:	eafffff2 	b	9080 <_Z5bzeroPvi+0x24>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:187
}
    90b4:	e320f000 	nop	{0}
    90b8:	e28bd000 	add	sp, fp, #0
    90bc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    90c0:	e12fff1e 	bx	lr

000090c4 <_Z6memcpyPKvPvi>:
_Z6memcpyPKvPvi():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:190

void memcpy(const void* src, void* dst, int num)
{
    90c4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    90c8:	e28db000 	add	fp, sp, #0
    90cc:	e24dd024 	sub	sp, sp, #36	; 0x24
    90d0:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    90d4:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    90d8:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:191
	const char* memsrc = reinterpret_cast<const char*>(src);
    90dc:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    90e0:	e50b300c 	str	r3, [fp, #-12]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:192
	char* memdst = reinterpret_cast<char*>(dst);
    90e4:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    90e8:	e50b3010 	str	r3, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:194

	for (int i = 0; i < num; i++)
    90ec:	e3a03000 	mov	r3, #0
    90f0:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:194 (discriminator 3)
    90f4:	e51b2008 	ldr	r2, [fp, #-8]
    90f8:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    90fc:	e1520003 	cmp	r2, r3
    9100:	aa00000b 	bge	9134 <_Z6memcpyPKvPvi+0x70>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:195 (discriminator 2)
		memdst[i] = memsrc[i];
    9104:	e51b3008 	ldr	r3, [fp, #-8]
    9108:	e51b200c 	ldr	r2, [fp, #-12]
    910c:	e0822003 	add	r2, r2, r3
    9110:	e51b3008 	ldr	r3, [fp, #-8]
    9114:	e51b1010 	ldr	r1, [fp, #-16]
    9118:	e0813003 	add	r3, r1, r3
    911c:	e5d22000 	ldrb	r2, [r2]
    9120:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:194 (discriminator 2)
	for (int i = 0; i < num; i++)
    9124:	e51b3008 	ldr	r3, [fp, #-8]
    9128:	e2833001 	add	r3, r3, #1
    912c:	e50b3008 	str	r3, [fp, #-8]
    9130:	eaffffef 	b	90f4 <_Z6memcpyPKvPvi+0x30>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:196
}
    9134:	e320f000 	nop	{0}
    9138:	e28bd000 	add	sp, fp, #0
    913c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9140:	e12fff1e 	bx	lr

00009144 <_Z4n_tuii>:
_Z4n_tuii():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:201



int n_tu(int number, int count)
{
    9144:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9148:	e28db000 	add	fp, sp, #0
    914c:	e24dd014 	sub	sp, sp, #20
    9150:	e50b0010 	str	r0, [fp, #-16]
    9154:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:202
    int result = 1;
    9158:	e3a03001 	mov	r3, #1
    915c:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:203
    while(count-- > 0)
    9160:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9164:	e2432001 	sub	r2, r3, #1
    9168:	e50b2014 	str	r2, [fp, #-20]	; 0xffffffec
    916c:	e3530000 	cmp	r3, #0
    9170:	c3a03001 	movgt	r3, #1
    9174:	d3a03000 	movle	r3, #0
    9178:	e6ef3073 	uxtb	r3, r3
    917c:	e3530000 	cmp	r3, #0
    9180:	0a000004 	beq	9198 <_Z4n_tuii+0x54>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:204
        result *= number;
    9184:	e51b3008 	ldr	r3, [fp, #-8]
    9188:	e51b2010 	ldr	r2, [fp, #-16]
    918c:	e0030392 	mul	r3, r2, r3
    9190:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:203
    while(count-- > 0)
    9194:	eafffff1 	b	9160 <_Z4n_tuii+0x1c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:206

    return result;
    9198:	e51b3008 	ldr	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:207
}
    919c:	e1a00003 	mov	r0, r3
    91a0:	e28bd000 	add	sp, fp, #0
    91a4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    91a8:	e12fff1e 	bx	lr

000091ac <_Z4ftoafPc>:
_Z4ftoafPc():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:211

/*** Convert float to string ***/
void ftoa(float f, char r[])
{
    91ac:	e92d4bf0 	push	{r4, r5, r6, r7, r8, r9, fp, lr}
    91b0:	e28db01c 	add	fp, sp, #28
    91b4:	e24dd068 	sub	sp, sp, #104	; 0x68
    91b8:	ed0b0a16 	vstr	s0, [fp, #-88]	; 0xffffffa8
    91bc:	e50b005c 	str	r0, [fp, #-92]	; 0xffffffa4
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:215
    long long int length, length2, i, number, position, sign;
    float number2;

    sign = -1;   // -1 == positive number
    91c0:	e3e02000 	mvn	r2, #0
    91c4:	e3e03000 	mvn	r3, #0
    91c8:	e14b24fc 	strd	r2, [fp, #-76]	; 0xffffffb4
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:216
    if (f < 0)
    91cc:	ed5b7a16 	vldr	s15, [fp, #-88]	; 0xffffffa8
    91d0:	eef57ac0 	vcmpe.f32	s15, #0.0
    91d4:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    91d8:	5a000005 	bpl	91f4 <_Z4ftoafPc+0x48>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:218
    {
        sign = '-';
    91dc:	e3a0202d 	mov	r2, #45	; 0x2d
    91e0:	e3a03000 	mov	r3, #0
    91e4:	e14b24fc 	strd	r2, [fp, #-76]	; 0xffffffb4
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:219
        f *= -1;
    91e8:	ed5b7a16 	vldr	s15, [fp, #-88]	; 0xffffffa8
    91ec:	eef17a67 	vneg.f32	s15, s15
    91f0:	ed4b7a16 	vstr	s15, [fp, #-88]	; 0xffffffa8
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:222
    }

    number2 = f;
    91f4:	e51b3058 	ldr	r3, [fp, #-88]	; 0xffffffa8
    91f8:	e50b3050 	str	r3, [fp, #-80]	; 0xffffffb0
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:223
    number = f;
    91fc:	e51b0058 	ldr	r0, [fp, #-88]	; 0xffffffa8
    9200:	eb000200 	bl	9a08 <__aeabi_f2lz>
    9204:	e1a02000 	mov	r2, r0
    9208:	e1a03001 	mov	r3, r1
    920c:	e14b23fc 	strd	r2, [fp, #-60]	; 0xffffffc4
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:224
    length = 0;  // Size of decimal part
    9210:	e3a02000 	mov	r2, #0
    9214:	e3a03000 	mov	r3, #0
    9218:	e14b22f4 	strd	r2, [fp, #-36]	; 0xffffffdc
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:225
    length2 = 0; // Size of tenth
    921c:	e3a02000 	mov	r2, #0
    9220:	e3a03000 	mov	r3, #0
    9224:	e14b22fc 	strd	r2, [fp, #-44]	; 0xffffffd4
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:228

    /* Calculate length2 tenth part */
    while( (number2 - (float)number) != 0.0 && !((number2 - (float)number) < 0.0) )
    9228:	e14b03dc 	ldrd	r0, [fp, #-60]	; 0xffffffc4
    922c:	eb0001a1 	bl	98b8 <__aeabi_l2f>
    9230:	ee070a10 	vmov	s14, r0
    9234:	ed5b7a14 	vldr	s15, [fp, #-80]	; 0xffffffb0
    9238:	ee777ac7 	vsub.f32	s15, s15, s14
    923c:	eef57a40 	vcmp.f32	s15, #0.0
    9240:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    9244:	0a00001b 	beq	92b8 <_Z4ftoafPc+0x10c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:228 (discriminator 1)
    9248:	e14b03dc 	ldrd	r0, [fp, #-60]	; 0xffffffc4
    924c:	eb000199 	bl	98b8 <__aeabi_l2f>
    9250:	ee070a10 	vmov	s14, r0
    9254:	ed5b7a14 	vldr	s15, [fp, #-80]	; 0xffffffb0
    9258:	ee777ac7 	vsub.f32	s15, s15, s14
    925c:	eef57ac0 	vcmpe.f32	s15, #0.0
    9260:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    9264:	4a000013 	bmi	92b8 <_Z4ftoafPc+0x10c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:230
    {
        number2 = f * (n_tu(10.0, length2 + 1));
    9268:	e51b302c 	ldr	r3, [fp, #-44]	; 0xffffffd4
    926c:	e2833001 	add	r3, r3, #1
    9270:	e1a01003 	mov	r1, r3
    9274:	e3a0000a 	mov	r0, #10
    9278:	ebffffb1 	bl	9144 <_Z4n_tuii>
    927c:	ee070a90 	vmov	s15, r0
    9280:	eef87ae7 	vcvt.f32.s32	s15, s15
    9284:	ed1b7a16 	vldr	s14, [fp, #-88]	; 0xffffffa8
    9288:	ee677a27 	vmul.f32	s15, s14, s15
    928c:	ed4b7a14 	vstr	s15, [fp, #-80]	; 0xffffffb0
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:231
        number = number2;
    9290:	e51b0050 	ldr	r0, [fp, #-80]	; 0xffffffb0
    9294:	eb0001db 	bl	9a08 <__aeabi_f2lz>
    9298:	e1a02000 	mov	r2, r0
    929c:	e1a03001 	mov	r3, r1
    92a0:	e14b23fc 	strd	r2, [fp, #-60]	; 0xffffffc4
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:233

        length2++;
    92a4:	e14b22dc 	ldrd	r2, [fp, #-44]	; 0xffffffd4
    92a8:	e2926001 	adds	r6, r2, #1
    92ac:	e2a37000 	adc	r7, r3, #0
    92b0:	e14b62fc 	strd	r6, [fp, #-44]	; 0xffffffd4
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:228
    while( (number2 - (float)number) != 0.0 && !((number2 - (float)number) < 0.0) )
    92b4:	eaffffdb 	b	9228 <_Z4ftoafPc+0x7c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:237
    }

    /* Calculate length decimal part */
    for (length = (f > 1) ? 0 : 1; f > 1; length++)
    92b8:	ed5b7a16 	vldr	s15, [fp, #-88]	; 0xffffffa8
    92bc:	ed9f7a82 	vldr	s14, [pc, #520]	; 94cc <_Z4ftoafPc+0x320>
    92c0:	eef47ac7 	vcmpe.f32	s15, s14
    92c4:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    92c8:	c3a03001 	movgt	r3, #1
    92cc:	d3a03000 	movle	r3, #0
    92d0:	e6ef3073 	uxtb	r3, r3
    92d4:	e2233001 	eor	r3, r3, #1
    92d8:	e6ef3073 	uxtb	r3, r3
    92dc:	e6ef3073 	uxtb	r3, r3
    92e0:	e3a02000 	mov	r2, #0
    92e4:	e50b3064 	str	r3, [fp, #-100]	; 0xffffff9c
    92e8:	e50b2060 	str	r2, [fp, #-96]	; 0xffffffa0
    92ec:	e14b26d4 	ldrd	r2, [fp, #-100]	; 0xffffff9c
    92f0:	e14b22f4 	strd	r2, [fp, #-36]	; 0xffffffdc
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:237 (discriminator 3)
    92f4:	ed5b7a16 	vldr	s15, [fp, #-88]	; 0xffffffa8
    92f8:	ed9f7a73 	vldr	s14, [pc, #460]	; 94cc <_Z4ftoafPc+0x320>
    92fc:	eef47ac7 	vcmpe.f32	s15, s14
    9300:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    9304:	da00000b 	ble	9338 <_Z4ftoafPc+0x18c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:238 (discriminator 2)
        f /= 10;
    9308:	ed1b7a16 	vldr	s14, [fp, #-88]	; 0xffffffa8
    930c:	eddf6a6f 	vldr	s13, [pc, #444]	; 94d0 <_Z4ftoafPc+0x324>
    9310:	eec77a26 	vdiv.f32	s15, s14, s13
    9314:	ed4b7a16 	vstr	s15, [fp, #-88]	; 0xffffffa8
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:237 (discriminator 2)
    for (length = (f > 1) ? 0 : 1; f > 1; length++)
    9318:	e14b22d4 	ldrd	r2, [fp, #-36]	; 0xffffffdc
    931c:	e2921001 	adds	r1, r2, #1
    9320:	e50b106c 	str	r1, [fp, #-108]	; 0xffffff94
    9324:	e2a33000 	adc	r3, r3, #0
    9328:	e50b3068 	str	r3, [fp, #-104]	; 0xffffff98
    932c:	e14b26dc 	ldrd	r2, [fp, #-108]	; 0xffffff94
    9330:	e14b22f4 	strd	r2, [fp, #-36]	; 0xffffffdc
    9334:	eaffffee 	b	92f4 <_Z4ftoafPc+0x148>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:240

    position = length;
    9338:	e14b22d4 	ldrd	r2, [fp, #-36]	; 0xffffffdc
    933c:	e14b24f4 	strd	r2, [fp, #-68]	; 0xffffffbc
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:241
    length = length + 1 + length2;
    9340:	e14b22d4 	ldrd	r2, [fp, #-36]	; 0xffffffdc
    9344:	e2924001 	adds	r4, r2, #1
    9348:	e2a35000 	adc	r5, r3, #0
    934c:	e14b22dc 	ldrd	r2, [fp, #-44]	; 0xffffffd4
    9350:	e0921004 	adds	r1, r2, r4
    9354:	e50b1074 	str	r1, [fp, #-116]	; 0xffffff8c
    9358:	e0a33005 	adc	r3, r3, r5
    935c:	e50b3070 	str	r3, [fp, #-112]	; 0xffffff90
    9360:	e14b27d4 	ldrd	r2, [fp, #-116]	; 0xffffff8c
    9364:	e14b22f4 	strd	r2, [fp, #-36]	; 0xffffffdc
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:242
    number = number2;
    9368:	e51b0050 	ldr	r0, [fp, #-80]	; 0xffffffb0
    936c:	eb0001a5 	bl	9a08 <__aeabi_f2lz>
    9370:	e1a02000 	mov	r2, r0
    9374:	e1a03001 	mov	r3, r1
    9378:	e14b23fc 	strd	r2, [fp, #-60]	; 0xffffffc4
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:243
    if (sign == '-')
    937c:	e14b24dc 	ldrd	r2, [fp, #-76]	; 0xffffffb4
    9380:	e242102d 	sub	r1, r2, #45	; 0x2d
    9384:	e1913003 	orrs	r3, r1, r3
    9388:	1a00000d 	bne	93c4 <_Z4ftoafPc+0x218>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:245
    {
        length++;
    938c:	e14b22d4 	ldrd	r2, [fp, #-36]	; 0xffffffdc
    9390:	e2921001 	adds	r1, r2, #1
    9394:	e50b107c 	str	r1, [fp, #-124]	; 0xffffff84
    9398:	e2a33000 	adc	r3, r3, #0
    939c:	e50b3078 	str	r3, [fp, #-120]	; 0xffffff88
    93a0:	e14b27dc 	ldrd	r2, [fp, #-124]	; 0xffffff84
    93a4:	e14b22f4 	strd	r2, [fp, #-36]	; 0xffffffdc
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:246
        position++;
    93a8:	e14b24d4 	ldrd	r2, [fp, #-68]	; 0xffffffbc
    93ac:	e2921001 	adds	r1, r2, #1
    93b0:	e50b1084 	str	r1, [fp, #-132]	; 0xffffff7c
    93b4:	e2a33000 	adc	r3, r3, #0
    93b8:	e50b3080 	str	r3, [fp, #-128]	; 0xffffff80
    93bc:	e14b28d4 	ldrd	r2, [fp, #-132]	; 0xffffff7c
    93c0:	e14b24f4 	strd	r2, [fp, #-68]	; 0xffffffbc
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:249
    }

    for (i = length; i >= 0 ; i--)
    93c4:	e14b22d4 	ldrd	r2, [fp, #-36]	; 0xffffffdc
    93c8:	e14b23f4 	strd	r2, [fp, #-52]	; 0xffffffcc
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:249 (discriminator 1)
    93cc:	e14b23d4 	ldrd	r2, [fp, #-52]	; 0xffffffcc
    93d0:	e3530000 	cmp	r3, #0
    93d4:	ba000039 	blt	94c0 <_Z4ftoafPc+0x314>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:251
    {
        if (i == (length))
    93d8:	e14b03d4 	ldrd	r0, [fp, #-52]	; 0xffffffcc
    93dc:	e14b22d4 	ldrd	r2, [fp, #-36]	; 0xffffffdc
    93e0:	e1510003 	cmp	r1, r3
    93e4:	01500002 	cmpeq	r0, r2
    93e8:	1a000005 	bne	9404 <_Z4ftoafPc+0x258>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:252
            r[i] = '\0';
    93ec:	e51b3034 	ldr	r3, [fp, #-52]	; 0xffffffcc
    93f0:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    93f4:	e0823003 	add	r3, r2, r3
    93f8:	e3a02000 	mov	r2, #0
    93fc:	e5c32000 	strb	r2, [r3]
    9400:	ea000029 	b	94ac <_Z4ftoafPc+0x300>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:253
        else if(i == (position))
    9404:	e14b03d4 	ldrd	r0, [fp, #-52]	; 0xffffffcc
    9408:	e14b24d4 	ldrd	r2, [fp, #-68]	; 0xffffffbc
    940c:	e1510003 	cmp	r1, r3
    9410:	01500002 	cmpeq	r0, r2
    9414:	1a000005 	bne	9430 <_Z4ftoafPc+0x284>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:254
            r[i] = '.';
    9418:	e51b3034 	ldr	r3, [fp, #-52]	; 0xffffffcc
    941c:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    9420:	e0823003 	add	r3, r2, r3
    9424:	e3a0202e 	mov	r2, #46	; 0x2e
    9428:	e5c32000 	strb	r2, [r3]
    942c:	ea00001e 	b	94ac <_Z4ftoafPc+0x300>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:255
        else if(sign == '-' && i == 0)
    9430:	e14b24dc 	ldrd	r2, [fp, #-76]	; 0xffffffb4
    9434:	e242102d 	sub	r1, r2, #45	; 0x2d
    9438:	e1913003 	orrs	r3, r1, r3
    943c:	1a000008 	bne	9464 <_Z4ftoafPc+0x2b8>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:255 (discriminator 1)
    9440:	e14b23d4 	ldrd	r2, [fp, #-52]	; 0xffffffcc
    9444:	e1923003 	orrs	r3, r2, r3
    9448:	1a000005 	bne	9464 <_Z4ftoafPc+0x2b8>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:256
            r[i] = '-';
    944c:	e51b3034 	ldr	r3, [fp, #-52]	; 0xffffffcc
    9450:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    9454:	e0823003 	add	r3, r2, r3
    9458:	e3a0202d 	mov	r2, #45	; 0x2d
    945c:	e5c32000 	strb	r2, [r3]
    9460:	ea000011 	b	94ac <_Z4ftoafPc+0x300>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:259
        else
        {
            r[i] = (number % 10) + '0';
    9464:	e14b03dc 	ldrd	r0, [fp, #-60]	; 0xffffffc4
    9468:	e3a0200a 	mov	r2, #10
    946c:	e3a03000 	mov	r3, #0
    9470:	eb00012f 	bl	9934 <__aeabi_ldivmod>
    9474:	e6ef2072 	uxtb	r2, r2
    9478:	e51b3034 	ldr	r3, [fp, #-52]	; 0xffffffcc
    947c:	e51b105c 	ldr	r1, [fp, #-92]	; 0xffffffa4
    9480:	e0813003 	add	r3, r1, r3
    9484:	e2822030 	add	r2, r2, #48	; 0x30
    9488:	e6ef2072 	uxtb	r2, r2
    948c:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:260
            number /=10;
    9490:	e14b03dc 	ldrd	r0, [fp, #-60]	; 0xffffffc4
    9494:	e3a0200a 	mov	r2, #10
    9498:	e3a03000 	mov	r3, #0
    949c:	eb000124 	bl	9934 <__aeabi_ldivmod>
    94a0:	e1a02000 	mov	r2, r0
    94a4:	e1a03001 	mov	r3, r1
    94a8:	e14b23fc 	strd	r2, [fp, #-60]	; 0xffffffc4
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:249 (discriminator 2)
    for (i = length; i >= 0 ; i--)
    94ac:	e14b23d4 	ldrd	r2, [fp, #-52]	; 0xffffffcc
    94b0:	e2528001 	subs	r8, r2, #1
    94b4:	e2c39000 	sbc	r9, r3, #0
    94b8:	e14b83f4 	strd	r8, [fp, #-52]	; 0xffffffcc
    94bc:	eaffffc2 	b	93cc <_Z4ftoafPc+0x220>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:263
        }
    }
}
    94c0:	e320f000 	nop	{0}
    94c4:	e24bd01c 	sub	sp, fp, #28
    94c8:	e8bd8bf0 	pop	{r4, r5, r6, r7, r8, r9, fp, pc}
    94cc:	3f800000 	svccc	0x00800000
    94d0:	41200000 			; <UNDEFINED> instruction: 0x41200000

000094d4 <__udivsi3>:
__udivsi3():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1104
    94d4:	e2512001 	subs	r2, r1, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1106
    94d8:	012fff1e 	bxeq	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1107
    94dc:	3a000074 	bcc	96b4 <__udivsi3+0x1e0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1108
    94e0:	e1500001 	cmp	r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1109
    94e4:	9a00006b 	bls	9698 <__udivsi3+0x1c4>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1110
    94e8:	e1110002 	tst	r1, r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1111
    94ec:	0a00006c 	beq	96a4 <__udivsi3+0x1d0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1113
    94f0:	e16f3f10 	clz	r3, r0
    94f4:	e16f2f11 	clz	r2, r1
    94f8:	e0423003 	sub	r3, r2, r3
    94fc:	e273301f 	rsbs	r3, r3, #31
    9500:	10833083 	addne	r3, r3, r3, lsl #1
    9504:	e3a02000 	mov	r2, #0
    9508:	108ff103 	addne	pc, pc, r3, lsl #2
    950c:	e1a00000 	nop			; (mov r0, r0)
    9510:	e1500f81 	cmp	r0, r1, lsl #31
    9514:	e0a22002 	adc	r2, r2, r2
    9518:	20400f81 	subcs	r0, r0, r1, lsl #31
    951c:	e1500f01 	cmp	r0, r1, lsl #30
    9520:	e0a22002 	adc	r2, r2, r2
    9524:	20400f01 	subcs	r0, r0, r1, lsl #30
    9528:	e1500e81 	cmp	r0, r1, lsl #29
    952c:	e0a22002 	adc	r2, r2, r2
    9530:	20400e81 	subcs	r0, r0, r1, lsl #29
    9534:	e1500e01 	cmp	r0, r1, lsl #28
    9538:	e0a22002 	adc	r2, r2, r2
    953c:	20400e01 	subcs	r0, r0, r1, lsl #28
    9540:	e1500d81 	cmp	r0, r1, lsl #27
    9544:	e0a22002 	adc	r2, r2, r2
    9548:	20400d81 	subcs	r0, r0, r1, lsl #27
    954c:	e1500d01 	cmp	r0, r1, lsl #26
    9550:	e0a22002 	adc	r2, r2, r2
    9554:	20400d01 	subcs	r0, r0, r1, lsl #26
    9558:	e1500c81 	cmp	r0, r1, lsl #25
    955c:	e0a22002 	adc	r2, r2, r2
    9560:	20400c81 	subcs	r0, r0, r1, lsl #25
    9564:	e1500c01 	cmp	r0, r1, lsl #24
    9568:	e0a22002 	adc	r2, r2, r2
    956c:	20400c01 	subcs	r0, r0, r1, lsl #24
    9570:	e1500b81 	cmp	r0, r1, lsl #23
    9574:	e0a22002 	adc	r2, r2, r2
    9578:	20400b81 	subcs	r0, r0, r1, lsl #23
    957c:	e1500b01 	cmp	r0, r1, lsl #22
    9580:	e0a22002 	adc	r2, r2, r2
    9584:	20400b01 	subcs	r0, r0, r1, lsl #22
    9588:	e1500a81 	cmp	r0, r1, lsl #21
    958c:	e0a22002 	adc	r2, r2, r2
    9590:	20400a81 	subcs	r0, r0, r1, lsl #21
    9594:	e1500a01 	cmp	r0, r1, lsl #20
    9598:	e0a22002 	adc	r2, r2, r2
    959c:	20400a01 	subcs	r0, r0, r1, lsl #20
    95a0:	e1500981 	cmp	r0, r1, lsl #19
    95a4:	e0a22002 	adc	r2, r2, r2
    95a8:	20400981 	subcs	r0, r0, r1, lsl #19
    95ac:	e1500901 	cmp	r0, r1, lsl #18
    95b0:	e0a22002 	adc	r2, r2, r2
    95b4:	20400901 	subcs	r0, r0, r1, lsl #18
    95b8:	e1500881 	cmp	r0, r1, lsl #17
    95bc:	e0a22002 	adc	r2, r2, r2
    95c0:	20400881 	subcs	r0, r0, r1, lsl #17
    95c4:	e1500801 	cmp	r0, r1, lsl #16
    95c8:	e0a22002 	adc	r2, r2, r2
    95cc:	20400801 	subcs	r0, r0, r1, lsl #16
    95d0:	e1500781 	cmp	r0, r1, lsl #15
    95d4:	e0a22002 	adc	r2, r2, r2
    95d8:	20400781 	subcs	r0, r0, r1, lsl #15
    95dc:	e1500701 	cmp	r0, r1, lsl #14
    95e0:	e0a22002 	adc	r2, r2, r2
    95e4:	20400701 	subcs	r0, r0, r1, lsl #14
    95e8:	e1500681 	cmp	r0, r1, lsl #13
    95ec:	e0a22002 	adc	r2, r2, r2
    95f0:	20400681 	subcs	r0, r0, r1, lsl #13
    95f4:	e1500601 	cmp	r0, r1, lsl #12
    95f8:	e0a22002 	adc	r2, r2, r2
    95fc:	20400601 	subcs	r0, r0, r1, lsl #12
    9600:	e1500581 	cmp	r0, r1, lsl #11
    9604:	e0a22002 	adc	r2, r2, r2
    9608:	20400581 	subcs	r0, r0, r1, lsl #11
    960c:	e1500501 	cmp	r0, r1, lsl #10
    9610:	e0a22002 	adc	r2, r2, r2
    9614:	20400501 	subcs	r0, r0, r1, lsl #10
    9618:	e1500481 	cmp	r0, r1, lsl #9
    961c:	e0a22002 	adc	r2, r2, r2
    9620:	20400481 	subcs	r0, r0, r1, lsl #9
    9624:	e1500401 	cmp	r0, r1, lsl #8
    9628:	e0a22002 	adc	r2, r2, r2
    962c:	20400401 	subcs	r0, r0, r1, lsl #8
    9630:	e1500381 	cmp	r0, r1, lsl #7
    9634:	e0a22002 	adc	r2, r2, r2
    9638:	20400381 	subcs	r0, r0, r1, lsl #7
    963c:	e1500301 	cmp	r0, r1, lsl #6
    9640:	e0a22002 	adc	r2, r2, r2
    9644:	20400301 	subcs	r0, r0, r1, lsl #6
    9648:	e1500281 	cmp	r0, r1, lsl #5
    964c:	e0a22002 	adc	r2, r2, r2
    9650:	20400281 	subcs	r0, r0, r1, lsl #5
    9654:	e1500201 	cmp	r0, r1, lsl #4
    9658:	e0a22002 	adc	r2, r2, r2
    965c:	20400201 	subcs	r0, r0, r1, lsl #4
    9660:	e1500181 	cmp	r0, r1, lsl #3
    9664:	e0a22002 	adc	r2, r2, r2
    9668:	20400181 	subcs	r0, r0, r1, lsl #3
    966c:	e1500101 	cmp	r0, r1, lsl #2
    9670:	e0a22002 	adc	r2, r2, r2
    9674:	20400101 	subcs	r0, r0, r1, lsl #2
    9678:	e1500081 	cmp	r0, r1, lsl #1
    967c:	e0a22002 	adc	r2, r2, r2
    9680:	20400081 	subcs	r0, r0, r1, lsl #1
    9684:	e1500001 	cmp	r0, r1
    9688:	e0a22002 	adc	r2, r2, r2
    968c:	20400001 	subcs	r0, r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1115
    9690:	e1a00002 	mov	r0, r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1116
    9694:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1119
    9698:	03a00001 	moveq	r0, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1120
    969c:	13a00000 	movne	r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1121
    96a0:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1123
    96a4:	e16f2f11 	clz	r2, r1
    96a8:	e262201f 	rsb	r2, r2, #31
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1125
    96ac:	e1a00230 	lsr	r0, r0, r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1126
    96b0:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1130
    96b4:	e3500000 	cmp	r0, #0
    96b8:	13e00000 	mvnne	r0, #0
    96bc:	ea000007 	b	96e0 <__aeabi_idiv0>

000096c0 <__aeabi_uidivmod>:
__aeabi_uidivmod():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1161
    96c0:	e3510000 	cmp	r1, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1162
    96c4:	0afffffa 	beq	96b4 <__udivsi3+0x1e0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1163
    96c8:	e92d4003 	push	{r0, r1, lr}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1164
    96cc:	ebffff80 	bl	94d4 <__udivsi3>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1165
    96d0:	e8bd4006 	pop	{r1, r2, lr}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1166
    96d4:	e0030092 	mul	r3, r2, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1167
    96d8:	e0411003 	sub	r1, r1, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1168
    96dc:	e12fff1e 	bx	lr

000096e0 <__aeabi_idiv0>:
__aeabi_ldiv0():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1466
    96e0:	e12fff1e 	bx	lr

000096e4 <__aeabi_frsub>:
__aeabi_frsub():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:59
    96e4:	e2200102 	eor	r0, r0, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:60
    96e8:	ea000000 	b	96f0 <__addsf3>

000096ec <__aeabi_fsub>:
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:65
    96ec:	e2211102 	eor	r1, r1, #-2147483648	; 0x80000000

000096f0 <__addsf3>:
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:74
    96f0:	e1b02080 	lsls	r2, r0, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:76
    96f4:	11b03081 	lslsne	r3, r1, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:77
    96f8:	11320003 	teqne	r2, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:78
    96fc:	11f0cc42 	mvnsne	ip, r2, asr #24
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:79
    9700:	11f0cc43 	mvnsne	ip, r3, asr #24
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:80
    9704:	0a00003c 	beq	97fc <__addsf3+0x10c>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:84
    9708:	e1a02c22 	lsr	r2, r2, #24
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:85
    970c:	e0723c23 	rsbs	r3, r2, r3, lsr #24
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:87
    9710:	c0822003 	addgt	r2, r2, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:88
    9714:	c0201001 	eorgt	r1, r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:89
    9718:	c0210000 	eorgt	r0, r1, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:90
    971c:	c0201001 	eorgt	r1, r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:92
    9720:	b2633000 	rsblt	r3, r3, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:97
    9724:	e3530019 	cmp	r3, #25
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:99
    9728:	812fff1e 	bxhi	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:102
    972c:	e3100102 	tst	r0, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:103
    9730:	e3800502 	orr	r0, r0, #8388608	; 0x800000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:104
    9734:	e3c004ff 	bic	r0, r0, #-16777216	; 0xff000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:106
    9738:	12600000 	rsbne	r0, r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:107
    973c:	e3110102 	tst	r1, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:108
    9740:	e3811502 	orr	r1, r1, #8388608	; 0x800000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:109
    9744:	e3c114ff 	bic	r1, r1, #-16777216	; 0xff000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:111
    9748:	12611000 	rsbne	r1, r1, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:115
    974c:	e1320003 	teq	r2, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:116
    9750:	0a000023 	beq	97e4 <__addsf3+0xf4>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:120
    9754:	e2422001 	sub	r2, r2, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:124
    9758:	e0900351 	adds	r0, r0, r1, asr r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:125
    975c:	e2633020 	rsb	r3, r3, #32
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:126
    9760:	e1a01311 	lsl	r1, r1, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:129
    9764:	e2003102 	and	r3, r0, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:130
    9768:	5a000001 	bpl	9774 <__addsf3+0x84>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:135
    976c:	e2711000 	rsbs	r1, r1, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:136
    9770:	e2e00000 	rsc	r0, r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:141
    9774:	e3500502 	cmp	r0, #8388608	; 0x800000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:142
    9778:	3a00000b 	bcc	97ac <__addsf3+0xbc>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:143
    977c:	e3500401 	cmp	r0, #16777216	; 0x1000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:144
    9780:	3a000004 	bcc	9798 <__addsf3+0xa8>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:147
    9784:	e1b000a0 	lsrs	r0, r0, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:148
    9788:	e1a01061 	rrx	r1, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:149
    978c:	e2822001 	add	r2, r2, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:152
    9790:	e35200fe 	cmp	r2, #254	; 0xfe
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:153
    9794:	2a00002d 	bcs	9850 <__addsf3+0x160>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:160
    9798:	e3510102 	cmp	r1, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:161
    979c:	e0a00b82 	adc	r0, r0, r2, lsl #23
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:163
    97a0:	03c00001 	biceq	r0, r0, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:164
    97a4:	e1800003 	orr	r0, r0, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:165
    97a8:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:169
    97ac:	e1b01081 	lsls	r1, r1, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:170
    97b0:	e0a00000 	adc	r0, r0, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:171
    97b4:	e2522001 	subs	r2, r2, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:173
    97b8:	23500502 	cmpcs	r0, #8388608	; 0x800000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:174
    97bc:	2afffff5 	bcs	9798 <__addsf3+0xa8>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:199
    97c0:	e16fcf10 	clz	ip, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:200
    97c4:	e24cc008 	sub	ip, ip, #8
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:201
    97c8:	e052200c 	subs	r2, r2, ip
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:202
    97cc:	e1a00c10 	lsl	r0, r0, ip
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:209
    97d0:	a0800b82 	addge	r0, r0, r2, lsl #23
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:210
    97d4:	b2622000 	rsblt	r2, r2, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:211
    97d8:	a1800003 	orrge	r0, r0, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:217
    97dc:	b1830230 	orrlt	r0, r3, r0, lsr r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:219
    97e0:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:224
    97e4:	e3320000 	teq	r2, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:225
    97e8:	e2211502 	eor	r1, r1, #8388608	; 0x800000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:227
    97ec:	02200502 	eoreq	r0, r0, #8388608	; 0x800000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:228
    97f0:	02822001 	addeq	r2, r2, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:229
    97f4:	12433001 	subne	r3, r3, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:230
    97f8:	eaffffd5 	b	9754 <__addsf3+0x64>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:233
    97fc:	e1a03081 	lsl	r3, r1, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:235
    9800:	e1f0cc42 	mvns	ip, r2, asr #24
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:237
    9804:	11f0cc43 	mvnsne	ip, r3, asr #24
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:238
    9808:	0a000013 	beq	985c <__addsf3+0x16c>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:240
    980c:	e1320003 	teq	r2, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:241
    9810:	0a000002 	beq	9820 <__addsf3+0x130>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:244
    9814:	e3320000 	teq	r2, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:246
    9818:	01a00001 	moveq	r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:247
    981c:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:249
    9820:	e1300001 	teq	r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:253
    9824:	13a00000 	movne	r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:254
    9828:	112fff1e 	bxne	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:257
    982c:	e31204ff 	tst	r2, #-16777216	; 0xff000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:258
    9830:	1a000002 	bne	9840 <__addsf3+0x150>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:259
    9834:	e1b00080 	lsls	r0, r0, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:261
    9838:	23800102 	orrcs	r0, r0, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:262
    983c:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:263
    9840:	e2922402 	adds	r2, r2, #33554432	; 0x2000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:265
    9844:	32800502 	addcc	r0, r0, #8388608	; 0x800000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:266
    9848:	312fff1e 	bxcc	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:267
    984c:	e2003102 	and	r3, r0, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:271
    9850:	e383047f 	orr	r0, r3, #2130706432	; 0x7f000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:272
    9854:	e3800502 	orr	r0, r0, #8388608	; 0x800000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:273
    9858:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:282
    985c:	e1f02c42 	mvns	r2, r2, asr #24
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:284
    9860:	11a00001 	movne	r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:285
    9864:	01f03c43 	mvnseq	r3, r3, asr #24
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:286
    9868:	11a01000 	movne	r1, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:287
    986c:	e1b02480 	lsls	r2, r0, #9
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:289
    9870:	01b03481 	lslseq	r3, r1, #9
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:290
    9874:	01300001 	teqeq	r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:291
    9878:	13800501 	orrne	r0, r0, #4194304	; 0x400000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:292
    987c:	e12fff1e 	bx	lr

00009880 <__aeabi_ui2f>:
__aeabi_ui2f():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:305
    9880:	e3a03000 	mov	r3, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:306
    9884:	ea000001 	b	9890 <__aeabi_i2f+0x8>

00009888 <__aeabi_i2f>:
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:311
    9888:	e2103102 	ands	r3, r0, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:313
    988c:	42600000 	rsbmi	r0, r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:315
    9890:	e1b0c000 	movs	ip, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:317
    9894:	012fff1e 	bxeq	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:320
    9898:	e383344b 	orr	r3, r3, #1258291200	; 0x4b000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:323
    989c:	e1a01000 	mov	r1, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:325
    98a0:	e3a00000 	mov	r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:326
    98a4:	ea00000f 	b	98e8 <__aeabi_l2f+0x30>

000098a8 <__aeabi_ul2f>:
__floatundisf():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:338
    98a8:	e1902001 	orrs	r2, r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:340
    98ac:	012fff1e 	bxeq	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:342
    98b0:	e3a03000 	mov	r3, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:343
    98b4:	ea000005 	b	98d0 <__aeabi_l2f+0x18>

000098b8 <__aeabi_l2f>:
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:348
    98b8:	e1902001 	orrs	r2, r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:350
    98bc:	012fff1e 	bxeq	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:352
    98c0:	e2113102 	ands	r3, r1, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:353
    98c4:	5a000001 	bpl	98d0 <__aeabi_l2f+0x18>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:358
    98c8:	e2700000 	rsbs	r0, r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:359
    98cc:	e2e11000 	rsc	r1, r1, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:362
    98d0:	e1b0c001 	movs	ip, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:364
    98d4:	01a0c000 	moveq	ip, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:365
    98d8:	01a01000 	moveq	r1, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:366
    98dc:	03a00000 	moveq	r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:369
    98e0:	e383345b 	orr	r3, r3, #1526726656	; 0x5b000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:371
    98e4:	02433201 	subeq	r3, r3, #268435456	; 0x10000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:372
    98e8:	e2433502 	sub	r3, r3, #8388608	; 0x800000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:397
    98ec:	e16f2f1c 	clz	r2, ip
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:398
    98f0:	e2522008 	subs	r2, r2, #8
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:402
    98f4:	e0433b82 	sub	r3, r3, r2, lsl #23
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:403
    98f8:	ba000006 	blt	9918 <__aeabi_l2f+0x60>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:405
    98fc:	e0833211 	add	r3, r3, r1, lsl r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:406
    9900:	e1a0c210 	lsl	ip, r0, r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:407
    9904:	e2622020 	rsb	r2, r2, #32
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:408
    9908:	e35c0102 	cmp	ip, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:409
    990c:	e0a30230 	adc	r0, r3, r0, lsr r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:411
    9910:	03c00001 	biceq	r0, r0, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:412
    9914:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:414
    9918:	e2822020 	add	r2, r2, #32
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:415
    991c:	e1a0c211 	lsl	ip, r1, r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:416
    9920:	e2622020 	rsb	r2, r2, #32
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:417
    9924:	e190008c 	orrs	r0, r0, ip, lsl #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:418
    9928:	e0a30231 	adc	r0, r3, r1, lsr r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:420
    992c:	01c00fac 	biceq	r0, r0, ip, lsr #31
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:421
    9930:	e12fff1e 	bx	lr

00009934 <__aeabi_ldivmod>:
__aeabi_ldivmod():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:186
    9934:	e3530000 	cmp	r3, #0
    9938:	03520000 	cmpeq	r2, #0
    993c:	1a000007 	bne	9960 <__aeabi_ldivmod+0x2c>
    9940:	e3510000 	cmp	r1, #0
    9944:	b3a01102 	movlt	r1, #-2147483648	; 0x80000000
    9948:	b3a00000 	movlt	r0, #0
    994c:	ba000002 	blt	995c <__aeabi_ldivmod+0x28>
    9950:	03500000 	cmpeq	r0, #0
    9954:	13e01102 	mvnne	r1, #-2147483648	; 0x80000000
    9958:	13e00000 	mvnne	r0, #0
    995c:	eaffff5f 	b	96e0 <__aeabi_idiv0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:188
    9960:	e24dd008 	sub	sp, sp, #8
    9964:	e92d6000 	push	{sp, lr}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:189
    9968:	e3510000 	cmp	r1, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:190
    996c:	ba000006 	blt	998c <__aeabi_ldivmod+0x58>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:191
    9970:	e3530000 	cmp	r3, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:192
    9974:	ba000011 	blt	99c0 <__aeabi_ldivmod+0x8c>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:194
    9978:	eb00003e 	bl	9a78 <__udivmoddi4>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:196
    997c:	e59de004 	ldr	lr, [sp, #4]
    9980:	e28dd008 	add	sp, sp, #8
    9984:	e8bd000c 	pop	{r2, r3}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:197
    9988:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:201
    998c:	e2700000 	rsbs	r0, r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:202
    9990:	e0c11081 	sbc	r1, r1, r1, lsl #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:203
    9994:	e3530000 	cmp	r3, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:204
    9998:	ba000011 	blt	99e4 <__aeabi_ldivmod+0xb0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:206
    999c:	eb000035 	bl	9a78 <__udivmoddi4>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:208
    99a0:	e59de004 	ldr	lr, [sp, #4]
    99a4:	e28dd008 	add	sp, sp, #8
    99a8:	e8bd000c 	pop	{r2, r3}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:209
    99ac:	e2700000 	rsbs	r0, r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:210
    99b0:	e0c11081 	sbc	r1, r1, r1, lsl #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:211
    99b4:	e2722000 	rsbs	r2, r2, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:212
    99b8:	e0c33083 	sbc	r3, r3, r3, lsl #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:213
    99bc:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:217
    99c0:	e2722000 	rsbs	r2, r2, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:218
    99c4:	e0c33083 	sbc	r3, r3, r3, lsl #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:220
    99c8:	eb00002a 	bl	9a78 <__udivmoddi4>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:222
    99cc:	e59de004 	ldr	lr, [sp, #4]
    99d0:	e28dd008 	add	sp, sp, #8
    99d4:	e8bd000c 	pop	{r2, r3}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:223
    99d8:	e2700000 	rsbs	r0, r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:224
    99dc:	e0c11081 	sbc	r1, r1, r1, lsl #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:225
    99e0:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:229
    99e4:	e2722000 	rsbs	r2, r2, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:230
    99e8:	e0c33083 	sbc	r3, r3, r3, lsl #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:232
    99ec:	eb000021 	bl	9a78 <__udivmoddi4>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:233
    99f0:	e59de004 	ldr	lr, [sp, #4]
    99f4:	e28dd008 	add	sp, sp, #8
    99f8:	e8bd000c 	pop	{r2, r3}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:234
    99fc:	e2722000 	rsbs	r2, r2, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:235
    9a00:	e0c33083 	sbc	r3, r3, r3, lsl #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:236
    9a04:	e12fff1e 	bx	lr

00009a08 <__aeabi_f2lz>:
__fixsfdi():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1530
    9a08:	ee070a90 	vmov	s15, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1531
    9a0c:	eef57ac0 	vcmpe.f32	s15, #0.0
    9a10:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    9a14:	4a000000 	bmi	9a1c <__aeabi_f2lz+0x14>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1533
    9a18:	ea000006 	b	9a38 <__aeabi_f2ulz>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1532
    9a1c:	eef17a67 	vneg.f32	s15, s15
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1530
    9a20:	e92d4010 	push	{r4, lr}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1532
    9a24:	ee170a90 	vmov	r0, s15
    9a28:	eb000002 	bl	9a38 <__aeabi_f2ulz>
    9a2c:	e2700000 	rsbs	r0, r0, #0
    9a30:	e2e11000 	rsc	r1, r1, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1534
    9a34:	e8bd8010 	pop	{r4, pc}

00009a38 <__aeabi_f2ulz>:
__fixunssfdi():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1471
    9a38:	ee070a90 	vmov	s15, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1476
    9a3c:	ed9f6b09 	vldr	d6, [pc, #36]	; 9a68 <__aeabi_f2ulz+0x30>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1481
    9a40:	ed9f5b0a 	vldr	d5, [pc, #40]	; 9a70 <__aeabi_f2ulz+0x38>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1471
    9a44:	eeb77ae7 	vcvt.f64.f32	d7, s15
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1476
    9a48:	ee276b06 	vmul.f64	d6, d7, d6
    9a4c:	eebc6bc6 	vcvt.u32.f64	s12, d6
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1481
    9a50:	eeb84b46 	vcvt.f64.u32	d4, s12
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1524
    9a54:	ee161a10 	vmov	r1, s12
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1481
    9a58:	ee047b45 	vmls.f64	d7, d4, d5
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1524
    9a5c:	eefc7bc7 	vcvt.u32.f64	s15, d7
    9a60:	ee170a90 	vmov	r0, s15
    9a64:	e12fff1e 	bx	lr
    9a68:	00000000 	andeq	r0, r0, r0
    9a6c:	3df00000 	ldclcc	0, cr0, [r0]
    9a70:	00000000 	andeq	r0, r0, r0
    9a74:	41f00000 	mvnsmi	r0, r0

00009a78 <__udivmoddi4>:
__udivmoddi4():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:960
    9a78:	e1500002 	cmp	r0, r2
    9a7c:	e0d1c003 	sbcs	ip, r1, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:948
    9a80:	e92d43f0 	push	{r4, r5, r6, r7, r8, r9, lr}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:949
    9a84:	33a05000 	movcc	r5, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:948
    9a88:	e59d701c 	ldr	r7, [sp, #28]
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:949
    9a8c:	31a06005 	movcc	r6, r5
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:960
    9a90:	3a00003b 	bcc	9b84 <__udivmoddi4+0x10c>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:962
    9a94:	e3530000 	cmp	r3, #0
    9a98:	016fcf12 	clzeq	ip, r2
    9a9c:	116fef13 	clzne	lr, r3
    9aa0:	028ce020 	addeq	lr, ip, #32
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:963
    9aa4:	e3510000 	cmp	r1, #0
    9aa8:	016fcf10 	clzeq	ip, r0
    9aac:	028cc020 	addeq	ip, ip, #32
    9ab0:	116fcf11 	clzne	ip, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:965
    9ab4:	e04ec00c 	sub	ip, lr, ip
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:966
    9ab8:	e1a03c13 	lsl	r3, r3, ip
    9abc:	e24c9020 	sub	r9, ip, #32
    9ac0:	e1833912 	orr	r3, r3, r2, lsl r9
    9ac4:	e1a04c12 	lsl	r4, r2, ip
    9ac8:	e26c8020 	rsb	r8, ip, #32
    9acc:	e1833832 	orr	r3, r3, r2, lsr r8
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:973
    9ad0:	e1500004 	cmp	r0, r4
    9ad4:	e0d12003 	sbcs	r2, r1, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:949
    9ad8:	33a05000 	movcc	r5, #0
    9adc:	31a06005 	movcc	r6, r5
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:973
    9ae0:	3a000005 	bcc	9afc <__udivmoddi4+0x84>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:976
    9ae4:	e3a05001 	mov	r5, #1
    9ae8:	e1a06915 	lsl	r6, r5, r9
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:975
    9aec:	e0500004 	subs	r0, r0, r4
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:976
    9af0:	e1866835 	orr	r6, r6, r5, lsr r8
    9af4:	e1a05c15 	lsl	r5, r5, ip
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:975
    9af8:	e0c11003 	sbc	r1, r1, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:979
    9afc:	e35c0000 	cmp	ip, #0
    9b00:	0a00001f 	beq	9b84 <__udivmoddi4+0x10c>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:981
    9b04:	e1a040a4 	lsr	r4, r4, #1
    9b08:	e1844f83 	orr	r4, r4, r3, lsl #31
    9b0c:	e1a020a3 	lsr	r2, r3, #1
    9b10:	e1a0e00c 	mov	lr, ip
    9b14:	ea000007 	b	9b38 <__udivmoddi4+0xc0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:989
    9b18:	e0503004 	subs	r3, r0, r4
    9b1c:	e0c11002 	sbc	r1, r1, r2
    9b20:	e0933003 	adds	r3, r3, r3
    9b24:	e0a11001 	adc	r1, r1, r1
    9b28:	e2930001 	adds	r0, r3, #1
    9b2c:	e2a11000 	adc	r1, r1, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:993
    9b30:	e25ee001 	subs	lr, lr, #1
    9b34:	0a000006 	beq	9b54 <__udivmoddi4+0xdc>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:988
    9b38:	e1500004 	cmp	r0, r4
    9b3c:	e0d13002 	sbcs	r3, r1, r2
    9b40:	2afffff4 	bcs	9b18 <__udivmoddi4+0xa0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:991
    9b44:	e0900000 	adds	r0, r0, r0
    9b48:	e0a11001 	adc	r1, r1, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:993
    9b4c:	e25ee001 	subs	lr, lr, #1
    9b50:	1afffff8 	bne	9b38 <__udivmoddi4+0xc0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:997
    9b54:	e0955000 	adds	r5, r5, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:998
    9b58:	e1a00c30 	lsr	r0, r0, ip
    9b5c:	e1800811 	orr	r0, r0, r1, lsl r8
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:997
    9b60:	e0a66001 	adc	r6, r6, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:998
    9b64:	e1800931 	orr	r0, r0, r1, lsr r9
    9b68:	e1a01c31 	lsr	r1, r1, ip
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:999
    9b6c:	e1a03c10 	lsl	r3, r0, ip
    9b70:	e1a0cc11 	lsl	ip, r1, ip
    9b74:	e18cc910 	orr	ip, ip, r0, lsl r9
    9b78:	e18cc830 	orr	ip, ip, r0, lsr r8
    9b7c:	e0555003 	subs	r5, r5, r3
    9b80:	e0c6600c 	sbc	r6, r6, ip
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1003
    9b84:	e3570000 	cmp	r7, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1004
    9b88:	11c700f0 	strdne	r0, [r7]
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1006
    9b8c:	e1a00005 	mov	r0, r5
    9b90:	e1a01006 	mov	r1, r6
    9b94:	e8bd83f0 	pop	{r4, r5, r6, r7, r8, r9, pc}

Disassembly of section .rodata:

00009b98 <_ZL13Lock_Unlocked>:
    9b98:	00000000 	andeq	r0, r0, r0

00009b9c <_ZL11Lock_Locked>:
    9b9c:	00000001 	andeq	r0, r0, r1

00009ba0 <_ZL21MaxFSDriverNameLength>:
    9ba0:	00000010 	andeq	r0, r0, r0, lsl r0

00009ba4 <_ZL17MaxFilenameLength>:
    9ba4:	00000010 	andeq	r0, r0, r0, lsl r0

00009ba8 <_ZL13MaxPathLength>:
    9ba8:	00000080 	andeq	r0, r0, r0, lsl #1

00009bac <_ZL18NoFilesystemDriver>:
    9bac:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009bb0 <_ZL9NotifyAll>:
    9bb0:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009bb4 <_ZL24Max_Process_Opened_Files>:
    9bb4:	00000010 	andeq	r0, r0, r0, lsl r0

00009bb8 <_ZL10Indefinite>:
    9bb8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009bbc <_ZL18Deadline_Unchanged>:
    9bbc:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

00009bc0 <_ZL14Invalid_Handle>:
    9bc0:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009bc4 <_ZN3halL18Default_Clock_RateE>:
    9bc4:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}

00009bc8 <_ZN3halL15Peripheral_BaseE>:
    9bc8:	20000000 	andcs	r0, r0, r0

00009bcc <_ZN3halL9GPIO_BaseE>:
    9bcc:	20200000 	eorcs	r0, r0, r0

00009bd0 <_ZN3halL14GPIO_Pin_CountE>:
    9bd0:	00000036 	andeq	r0, r0, r6, lsr r0

00009bd4 <_ZN3halL8AUX_BaseE>:
    9bd4:	20215000 	eorcs	r5, r1, r0

00009bd8 <_ZN3halL25Interrupt_Controller_BaseE>:
    9bd8:	2000b200 	andcs	fp, r0, r0, lsl #4

00009bdc <_ZN3halL10Timer_BaseE>:
    9bdc:	2000b400 	andcs	fp, r0, r0, lsl #8

00009be0 <_ZN3halL17System_Timer_BaseE>:
    9be0:	20003000 	andcs	r3, r0, r0

00009be4 <_ZN3halL9TRNG_BaseE>:
    9be4:	20104000 	andscs	r4, r0, r0

00009be8 <_ZN3halL9BSC0_BaseE>:
    9be8:	20205000 	eorcs	r5, r0, r0

00009bec <_ZN3halL9BSC1_BaseE>:
    9bec:	20804000 	addcs	r4, r0, r0

00009bf0 <_ZN3halL9BSC2_BaseE>:
    9bf0:	20805000 	addcs	r5, r0, r0

00009bf4 <_ZL11Invalid_Pin>:
    9bf4:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009bf8 <_ZL17symbol_tick_delay>:
    9bf8:	00000400 	andeq	r0, r0, r0, lsl #8

00009bfc <_ZL15char_tick_delay>:
    9bfc:	00001000 	andeq	r1, r0, r0
    9c00:	00000031 	andeq	r0, r0, r1, lsr r0
    9c04:	00000030 	andeq	r0, r0, r0, lsr r0
    9c08:	3a564544 	bcc	159b120 <__bss_end+0x1591488>
    9c0c:	6f697067 	svcvs	0x00697067
    9c10:	0038312f 	eorseq	r3, r8, pc, lsr #2
    9c14:	3a564544 	bcc	159b12c <__bss_end+0x1591494>
    9c18:	6f697067 	svcvs	0x00697067
    9c1c:	0036312f 	eorseq	r3, r6, pc, lsr #2
    9c20:	00676f6c 	rsbeq	r6, r7, ip, ror #30
    9c24:	21534f53 	cmpcs	r3, r3, asr pc
    9c28:	00000000 	andeq	r0, r0, r0

00009c2c <_ZL13Lock_Unlocked>:
    9c2c:	00000000 	andeq	r0, r0, r0

00009c30 <_ZL11Lock_Locked>:
    9c30:	00000001 	andeq	r0, r0, r1

00009c34 <_ZL21MaxFSDriverNameLength>:
    9c34:	00000010 	andeq	r0, r0, r0, lsl r0

00009c38 <_ZL17MaxFilenameLength>:
    9c38:	00000010 	andeq	r0, r0, r0, lsl r0

00009c3c <_ZL13MaxPathLength>:
    9c3c:	00000080 	andeq	r0, r0, r0, lsl #1

00009c40 <_ZL18NoFilesystemDriver>:
    9c40:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009c44 <_ZL9NotifyAll>:
    9c44:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009c48 <_ZL24Max_Process_Opened_Files>:
    9c48:	00000010 	andeq	r0, r0, r0, lsl r0

00009c4c <_ZL10Indefinite>:
    9c4c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009c50 <_ZL18Deadline_Unchanged>:
    9c50:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

00009c54 <_ZL14Invalid_Handle>:
    9c54:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009c58 <_ZL16Pipe_File_Prefix>:
    9c58:	3a535953 	bcc	14e01ac <__bss_end+0x14d6514>
    9c5c:	65706970 	ldrbvs	r6, [r0, #-2416]!	; 0xfffff690
    9c60:	0000002f 	andeq	r0, r0, pc, lsr #32

00009c64 <_ZN12_GLOBAL__N_1L11CharConvArrE>:
    9c64:	33323130 	teqcc	r2, #48, 2
    9c68:	37363534 			; <UNDEFINED> instruction: 0x37363534
    9c6c:	42413938 	submi	r3, r1, #56, 18	; 0xe0000
    9c70:	46454443 	strbmi	r4, [r5], -r3, asr #8
	...

Disassembly of section .ARM.exidx:

00009c78 <__CTOR_LIST__-0x8>:
    9c78:	7ffffe00 	svcvc	0x00fffe00
    9c7c:	00000001 	andeq	r0, r0, r1

Disassembly of section .bss:

00009c80 <sos_led>:
__bss_start():
    9c80:	00000000 	andeq	r0, r0, r0

00009c84 <button>:
	...

Disassembly of section .ARM.attributes:

00000000 <.ARM.attributes>:
   0:	00002e41 	andeq	r2, r0, r1, asr #28
   4:	61656100 	cmnvs	r5, r0, lsl #2
   8:	01006962 	tsteq	r0, r2, ror #18
   c:	00000024 	andeq	r0, r0, r4, lsr #32
  10:	4b5a3605 	blmi	168d82c <__bss_end+0x1683b94>
  14:	08070600 	stmdaeq	r7, {r9, sl}
  18:	0a010901 	beq	42424 <__bss_end+0x3878c>
  1c:	14041202 	strne	r1, [r4], #-514	; 0xfffffdfe
  20:	17011501 	strne	r1, [r1, -r1, lsl #10]
  24:	1a011803 	bne	46038 <__bss_end+0x3c3a0>
  28:	22011c01 	andcs	r1, r1, #256	; 0x100
  2c:	Address 0x000000000000002c is out of bounds.


Disassembly of section .comment:

00000000 <.comment>:
   0:	3a434347 	bcc	10d0d24 <__bss_end+0x10c708c>
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
      e0:	db010100 	blle	404e8 <__bss_end+0x36850>
      e4:	03000000 	movweq	r0, #0
      e8:	00005200 	andeq	r5, r0, r0, lsl #4
      ec:	fb010200 	blx	408f6 <__bss_end+0x36c5e>
      f0:	01000d0e 	tsteq	r0, lr, lsl #26
      f4:	00010101 	andeq	r0, r1, r1, lsl #2
      f8:	00010000 	andeq	r0, r1, r0
      fc:	682f0100 	stmdavs	pc!, {r8}	; <UNPREDICTABLE>
     100:	2f656d6f 	svccs	0x00656d6f
     104:	66657274 			; <UNDEFINED> instruction: 0x66657274
     108:	732f6c69 			; <UNDEFINED> instruction: 0x732f6c69
     10c:	732f6d65 			; <UNDEFINED> instruction: 0x732f6d65
     110:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
     114:	752f7365 	strvc	r7, [pc, #-869]!	; fffffdb7 <__bss_end+0xffff611f>
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
     14c:	0a05830b 	beq	160d80 <__bss_end+0x1570e8>
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
     178:	4a030402 	bmi	c1188 <__bss_end+0xb74f0>
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
     1ac:	4a020402 	bmi	811bc <__bss_end+0x77524>
     1b0:	02000205 	andeq	r0, r0, #1342177280	; 0x50000000
     1b4:	052d0204 	streq	r0, [sp, #-516]!	; 0xfffffdfc
     1b8:	01058509 	tsteq	r5, r9, lsl #10
     1bc:	000a022f 	andeq	r0, sl, pc, lsr #4
     1c0:	02720101 	rsbseq	r0, r2, #1073741824	; 0x40000000
     1c4:	00030000 	andeq	r0, r3, r0
     1c8:	000001b1 			; <UNDEFINED> instruction: 0x000001b1
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
     200:	5f736f73 	svcpl	0x00736f73
     204:	6b736174 	blvs	1cd87dc <__bss_end+0x1cceb44>
     208:	6f682f00 	svcvs	0x00682f00
     20c:	742f656d 	strtvc	r6, [pc], #-1389	; 214 <shift+0x214>
     210:	69666572 	stmdbvs	r6!, {r1, r4, r5, r6, r8, sl, sp, lr}^
     214:	65732f6c 	ldrbvs	r2, [r3, #-3948]!	; 0xfffff094
     218:	6f732f6d 	svcvs	0x00732f6d
     21c:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
     220:	73752f73 	cmnvc	r5, #460	; 0x1cc
     224:	70737265 	rsbsvc	r7, r3, r5, ror #4
     228:	2f656361 	svccs	0x00656361
     22c:	6b2f2e2e 	blvs	bcbaec <__bss_end+0xbc1e54>
     230:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
     234:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
     238:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
     23c:	72702f65 	rsbsvc	r2, r0, #404	; 0x194
     240:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     244:	682f0073 	stmdavs	pc!, {r0, r1, r4, r5, r6}	; <UNPREDICTABLE>
     248:	2f656d6f 	svccs	0x00656d6f
     24c:	66657274 			; <UNDEFINED> instruction: 0x66657274
     250:	732f6c69 			; <UNDEFINED> instruction: 0x732f6c69
     254:	732f6d65 			; <UNDEFINED> instruction: 0x732f6d65
     258:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
     25c:	752f7365 	strvc	r7, [pc, #-869]!	; fffffeff <__bss_end+0xffff6267>
     260:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
     264:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
     268:	2f2e2e2f 	svccs	0x002e2e2f
     26c:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
     270:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
     274:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
     278:	662f6564 	strtvs	r6, [pc], -r4, ror #10
     27c:	682f0073 	stmdavs	pc!, {r0, r1, r4, r5, r6}	; <UNPREDICTABLE>
     280:	2f656d6f 	svccs	0x00656d6f
     284:	66657274 			; <UNDEFINED> instruction: 0x66657274
     288:	732f6c69 			; <UNDEFINED> instruction: 0x732f6c69
     28c:	732f6d65 			; <UNDEFINED> instruction: 0x732f6d65
     290:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
     294:	752f7365 	strvc	r7, [pc, #-869]!	; ffffff37 <__bss_end+0xffff629f>
     298:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
     29c:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
     2a0:	2f2e2e2f 	svccs	0x002e2e2f
     2a4:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
     2a8:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
     2ac:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
     2b0:	622f6564 	eorvs	r6, pc, #100, 10	; 0x19000000
     2b4:	6472616f 	ldrbtvs	r6, [r2], #-367	; 0xfffffe91
     2b8:	6970722f 	ldmdbvs	r0!, {r0, r1, r2, r3, r5, r9, ip, sp, lr}^
     2bc:	61682f30 	cmnvs	r8, r0, lsr pc
     2c0:	682f006c 	stmdavs	pc!, {r2, r3, r5, r6}	; <UNPREDICTABLE>
     2c4:	2f656d6f 	svccs	0x00656d6f
     2c8:	66657274 			; <UNDEFINED> instruction: 0x66657274
     2cc:	732f6c69 			; <UNDEFINED> instruction: 0x732f6c69
     2d0:	732f6d65 			; <UNDEFINED> instruction: 0x732f6d65
     2d4:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
     2d8:	752f7365 	strvc	r7, [pc, #-869]!	; ffffff7b <__bss_end+0xffff62e3>
     2dc:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
     2e0:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
     2e4:	2f2e2e2f 	svccs	0x002e2e2f
     2e8:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
     2ec:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
     2f0:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
     2f4:	642f6564 	strtvs	r6, [pc], #-1380	; 2fc <shift+0x2fc>
     2f8:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
     2fc:	00007372 	andeq	r7, r0, r2, ror r3
     300:	6e69616d 	powvsez	f6, f1, #5.0
     304:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
     308:	00000100 	andeq	r0, r0, r0, lsl #2
     30c:	2e697773 	mcrcs	7, 3, r7, cr9, cr3, {3}
     310:	00020068 	andeq	r0, r2, r8, rrx
     314:	69707300 	ldmdbvs	r0!, {r8, r9, ip, sp, lr}^
     318:	636f6c6e 	cmnvs	pc, #28160	; 0x6e00
     31c:	00682e6b 	rsbeq	r2, r8, fp, ror #28
     320:	66000002 	strvs	r0, [r0], -r2
     324:	73656c69 	cmnvc	r5, #26880	; 0x6900
     328:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     32c:	00682e6d 	rsbeq	r2, r8, sp, ror #28
     330:	70000003 	andvc	r0, r0, r3
     334:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     338:	682e7373 	stmdavs	lr!, {r0, r1, r4, r5, r6, r8, r9, ip, sp, lr}
     33c:	00000200 	andeq	r0, r0, r0, lsl #4
     340:	636f7270 	cmnvs	pc, #112, 4
     344:	5f737365 	svcpl	0x00737365
     348:	616e616d 	cmnvs	lr, sp, ror #2
     34c:	2e726567 	cdpcs	5, 7, cr6, cr2, cr7, {3}
     350:	00020068 	andeq	r0, r2, r8, rrx
     354:	72657000 	rsbvc	r7, r5, #0
     358:	65687069 	strbvs	r7, [r8, #-105]!	; 0xffffff97
     35c:	736c6172 	cmnvc	ip, #-2147483620	; 0x8000001c
     360:	0400682e 	streq	r6, [r0], #-2094	; 0xfffff7d2
     364:	70670000 	rsbvc	r0, r7, r0
     368:	682e6f69 	stmdavs	lr!, {r0, r3, r5, r6, r8, r9, sl, fp, sp, lr}
     36c:	00000500 	andeq	r0, r0, r0, lsl #10
     370:	64746e69 	ldrbtvs	r6, [r4], #-3689	; 0xfffff197
     374:	682e6665 	stmdavs	lr!, {r0, r2, r5, r6, r9, sl, sp, lr}
     378:	00000400 	andeq	r0, r0, r0, lsl #8
     37c:	00010500 	andeq	r0, r1, r0, lsl #10
     380:	822c0205 	eorhi	r0, ip, #1342177280	; 0x50000000
     384:	16030000 	strne	r0, [r3], -r0
     388:	9f070501 	svcls	0x00070501
     38c:	040200bb 	streq	r0, [r2], #-187	; 0xffffff45
     390:	00660601 	rsbeq	r0, r6, r1, lsl #12
     394:	4a020402 	bmi	813a4 <__bss_end+0x7770c>
     398:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
     39c:	0402002e 	streq	r0, [r2], #-46	; 0xffffffd2
     3a0:	05670604 	strbeq	r0, [r7, #-1540]!	; 0xfffff9fc
     3a4:	04020001 	streq	r0, [r2], #-1
     3a8:	05bdbb04 	ldreq	fp, [sp, #2820]!	; 0xb04
     3ac:	0a059f10 	beq	167ff4 <__bss_end+0x15e35c>
     3b0:	4b0f0582 	blmi	3c19c0 <__bss_end+0x3b7d28>
     3b4:	05820905 	streq	r0, [r2, #2309]	; 0x905
     3b8:	07054c17 	smladeq	r5, r7, ip, r4
     3bc:	bc19054b 	cfldr32lt	mvfx0, [r9], {75}	; 0x4b
     3c0:	02000705 	andeq	r0, r0, #1310720	; 0x140000
     3c4:	05870104 	streq	r0, [r7, #260]	; 0x104
     3c8:	04020008 	streq	r0, [r2], #-8
     3cc:	ba090301 	blt	240fd8 <__bss_end+0x237340>
     3d0:	01040200 	mrseq	r0, R12_usr
     3d4:	04020084 	streq	r0, [r2], #-132	; 0xffffff7c
     3d8:	02004b01 	andeq	r4, r0, #1024	; 0x400
     3dc:	00670104 	rsbeq	r0, r7, r4, lsl #2
     3e0:	4b010402 	blmi	413f0 <__bss_end+0x37758>
     3e4:	01040200 	mrseq	r0, R12_usr
     3e8:	04020067 	streq	r0, [r2], #-103	; 0xffffff99
     3ec:	02004c01 	andeq	r4, r0, #256	; 0x100
     3f0:	00680104 	rsbeq	r0, r8, r4, lsl #2
     3f4:	4b010402 	blmi	41404 <__bss_end+0x3776c>
     3f8:	01040200 	mrseq	r0, R12_usr
     3fc:	04020067 	streq	r0, [r2], #-103	; 0xffffff99
     400:	02004b01 	andeq	r4, r0, #1024	; 0x400
     404:	00670104 	rsbeq	r0, r7, r4, lsl #2
     408:	4b010402 	blmi	41418 <__bss_end+0x37780>
     40c:	01040200 	mrseq	r0, R12_usr
     410:	04020068 	streq	r0, [r2], #-104	; 0xffffff98
     414:	02006801 	andeq	r6, r0, #65536	; 0x10000
     418:	004b0104 	subeq	r0, fp, r4, lsl #2
     41c:	67010402 	strvs	r0, [r1, -r2, lsl #8]
     420:	01040200 	mrseq	r0, R12_usr
     424:	0402004b 	streq	r0, [r2], #-75	; 0xffffffb5
     428:	07056701 	streq	r6, [r5, -r1, lsl #14]
     42c:	01040200 	mrseq	r0, R12_usr
     430:	024a6003 	subeq	r6, sl, #3
     434:	0101000e 	tsteq	r1, lr
     438:	00000218 	andeq	r0, r0, r8, lsl r2
     43c:	012d0003 			; <UNDEFINED> instruction: 0x012d0003
     440:	01020000 	mrseq	r0, (UNDEF: 2)
     444:	000d0efb 	strdeq	r0, [sp], -fp
     448:	01010101 	tsteq	r1, r1, lsl #2
     44c:	01000000 	mrseq	r0, (UNDEF: 0)
     450:	2f010000 	svccs	0x00010000
     454:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
     458:	6572742f 	ldrbvs	r7, [r2, #-1071]!	; 0xfffffbd1
     45c:	2f6c6966 	svccs	0x006c6966
     460:	2f6d6573 	svccs	0x006d6573
     464:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
     468:	2f736563 	svccs	0x00736563
     46c:	6c647473 	cfstrdvs	mvd7, [r4], #-460	; 0xfffffe34
     470:	732f6269 			; <UNDEFINED> instruction: 0x732f6269
     474:	2f006372 	svccs	0x00006372
     478:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
     47c:	6572742f 	ldrbvs	r7, [r2, #-1071]!	; 0xfffffbd1
     480:	2f6c6966 	svccs	0x006c6966
     484:	2f6d6573 	svccs	0x006d6573
     488:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
     48c:	2f736563 	svccs	0x00736563
     490:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
     494:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
     498:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
     49c:	702f6564 	eorvc	r6, pc, r4, ror #10
     4a0:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     4a4:	2f007373 	svccs	0x00007373
     4a8:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
     4ac:	6572742f 	ldrbvs	r7, [r2, #-1071]!	; 0xfffffbd1
     4b0:	2f6c6966 	svccs	0x006c6966
     4b4:	2f6d6573 	svccs	0x006d6573
     4b8:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
     4bc:	2f736563 	svccs	0x00736563
     4c0:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
     4c4:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
     4c8:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
     4cc:	662f6564 	strtvs	r6, [pc], -r4, ror #10
     4d0:	682f0073 	stmdavs	pc!, {r0, r1, r4, r5, r6}	; <UNPREDICTABLE>
     4d4:	2f656d6f 	svccs	0x00656d6f
     4d8:	66657274 			; <UNDEFINED> instruction: 0x66657274
     4dc:	732f6c69 			; <UNDEFINED> instruction: 0x732f6c69
     4e0:	732f6d65 			; <UNDEFINED> instruction: 0x732f6d65
     4e4:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
     4e8:	6b2f7365 	blvs	bdd284 <__bss_end+0xbd35ec>
     4ec:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
     4f0:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
     4f4:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
     4f8:	6f622f65 	svcvs	0x00622f65
     4fc:	2f647261 	svccs	0x00647261
     500:	30697072 	rsbcc	r7, r9, r2, ror r0
     504:	6c61682f 	stclvs	8, cr6, [r1], #-188	; 0xffffff44
     508:	74730000 	ldrbtvc	r0, [r3], #-0
     50c:	6c696664 	stclvs	6, cr6, [r9], #-400	; 0xfffffe70
     510:	70632e65 	rsbvc	r2, r3, r5, ror #28
     514:	00010070 	andeq	r0, r1, r0, ror r0
     518:	69777300 	ldmdbvs	r7!, {r8, r9, ip, sp, lr}^
     51c:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
     520:	70730000 	rsbsvc	r0, r3, r0
     524:	6f6c6e69 	svcvs	0x006c6e69
     528:	682e6b63 	stmdavs	lr!, {r0, r1, r5, r6, r8, r9, fp, sp, lr}
     52c:	00000200 	andeq	r0, r0, r0, lsl #4
     530:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
     534:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
     538:	682e6d65 	stmdavs	lr!, {r0, r2, r5, r6, r8, sl, fp, sp, lr}
     53c:	00000300 	andeq	r0, r0, r0, lsl #6
     540:	636f7270 	cmnvs	pc, #112, 4
     544:	2e737365 	cdpcs	3, 7, cr7, cr3, cr5, {3}
     548:	00020068 	andeq	r0, r2, r8, rrx
     54c:	6f727000 	svcvs	0x00727000
     550:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     554:	6e616d5f 	mcrvs	13, 3, r6, cr1, cr15, {2}
     558:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     55c:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
     560:	6e690000 	cdpvs	0, 6, cr0, cr9, cr0, {0}
     564:	66656474 			; <UNDEFINED> instruction: 0x66656474
     568:	0400682e 	streq	r6, [r0], #-2094	; 0xfffff7d2
     56c:	05000000 	streq	r0, [r0, #-0]
     570:	02050001 	andeq	r0, r5, #1
     574:	00008418 	andeq	r8, r0, r8, lsl r4
     578:	69050516 	stmdbvs	r5, {r1, r2, r4, r8, sl}
     57c:	4c0c052f 	cfstr32mi	mvfx0, [ip], {47}	; 0x2f
     580:	852f0105 	strhi	r0, [pc, #-261]!	; 483 <shift+0x483>
     584:	4b830505 	blmi	fe0c19a0 <__bss_end+0xfe0b7d08>
     588:	852f0105 	strhi	r0, [pc, #-261]!	; 48b <shift+0x48b>
     58c:	054b0505 	strbeq	r0, [fp, #-1285]	; 0xfffffafb
     590:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
     594:	4b4ba105 	blmi	12e89b0 <__bss_end+0x12ded18>
     598:	4c0c052f 	cfstr32mi	mvfx0, [ip], {47}	; 0x2f
     59c:	852f0105 	strhi	r0, [pc, #-261]!	; 49f <shift+0x49f>
     5a0:	4bbd0505 	blmi	fef419bc <__bss_end+0xfef37d24>
     5a4:	052f4b4b 	streq	r4, [pc, #-2891]!	; fffffa61 <__bss_end+0xffff5dc9>
     5a8:	01054c0c 	tsteq	r5, ip, lsl #24
     5ac:	0505862f 	streq	r8, [r5, #-1583]	; 0xfffff9d1
     5b0:	4b4b4bbd 	blmi	12d34ac <__bss_end+0x12c9814>
     5b4:	4c0c052f 	cfstr32mi	mvfx0, [ip], {47}	; 0x2f
     5b8:	852f0105 	strhi	r0, [pc, #-261]!	; 4bb <shift+0x4bb>
     5bc:	4b830505 	blmi	fe0c19d8 <__bss_end+0xfe0b7d40>
     5c0:	852f0105 	strhi	r0, [pc, #-261]!	; 4c3 <shift+0x4c3>
     5c4:	4bbd0505 	blmi	fef419e0 <__bss_end+0xfef37d48>
     5c8:	052f4b4b 	streq	r4, [pc, #-2891]!	; fffffa85 <__bss_end+0xffff5ded>
     5cc:	01054c0c 	tsteq	r5, ip, lsl #24
     5d0:	0505852f 	streq	r8, [r5, #-1327]	; 0xfffffad1
     5d4:	2f4b4ba1 	svccs	0x004b4ba1
     5d8:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
     5dc:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
     5e0:	4b4bbd05 	blmi	12ef9fc <__bss_end+0x12e5d64>
     5e4:	0c052f4b 	stceq	15, cr2, [r5], {75}	; 0x4b
     5e8:	2f01054c 	svccs	0x0001054c
     5ec:	a1050585 	smlabbge	r5, r5, r5, r0
     5f0:	052f4b4b 	streq	r4, [pc, #-2891]!	; fffffaad <__bss_end+0xffff5e15>
     5f4:	01054c0c 	tsteq	r5, ip, lsl #24
     5f8:	2005859f 	mulcs	r5, pc, r5	; <UNPREDICTABLE>
     5fc:	4d050567 	cfstr32mi	mvfx0, [r5, #-412]	; 0xfffffe64
     600:	0c054b4b 			; <UNDEFINED> instruction: 0x0c054b4b
     604:	2f010530 	svccs	0x00010530
     608:	67200585 	strvs	r0, [r0, -r5, lsl #11]!
     60c:	4b4d0505 	blmi	1341a28 <__bss_end+0x1337d90>
     610:	300c054b 	andcc	r0, ip, fp, asr #10
     614:	852f0105 	strhi	r0, [pc, #-261]!	; 517 <shift+0x517>
     618:	05832005 	streq	r2, [r3, #5]
     61c:	4b4b4c05 	blmi	12d3638 <__bss_end+0x12c99a0>
     620:	852f0105 	strhi	r0, [pc, #-261]!	; 523 <shift+0x523>
     624:	05672005 	strbeq	r2, [r7, #-5]!
     628:	4b4b4d05 	blmi	12d3a44 <__bss_end+0x12c9dac>
     62c:	05300c05 	ldreq	r0, [r0, #-3077]!	; 0xfffff3fb
     630:	05872f01 	streq	r2, [r7, #3841]	; 0xf01
     634:	059fa00c 	ldreq	sl, [pc, #12]	; 648 <shift+0x648>
     638:	2905bc31 	stmdbcs	r5, {r0, r4, r5, sl, fp, ip, sp, pc}
     63c:	2e360566 	cdpcs	5, 3, cr0, cr6, cr6, {3}
     640:	05300f05 	ldreq	r0, [r0, #-3845]!	; 0xfffff0fb
     644:	09056613 	stmdbeq	r5, {r0, r1, r4, r9, sl, sp, lr}
     648:	d8100584 	ldmdale	r0, {r2, r7, r8, sl}
     64c:	029f0105 	addseq	r0, pc, #1073741825	; 0x40000001
     650:	01010008 	tsteq	r1, r8
     654:	0000050d 	andeq	r0, r0, sp, lsl #10
     658:	00480003 	subeq	r0, r8, r3
     65c:	01020000 	mrseq	r0, (UNDEF: 2)
     660:	000d0efb 	strdeq	r0, [sp], -fp
     664:	01010101 	tsteq	r1, r1, lsl #2
     668:	01000000 	mrseq	r0, (UNDEF: 0)
     66c:	2f010000 	svccs	0x00010000
     670:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
     674:	6572742f 	ldrbvs	r7, [r2, #-1071]!	; 0xfffffbd1
     678:	2f6c6966 	svccs	0x006c6966
     67c:	2f6d6573 	svccs	0x006d6573
     680:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
     684:	2f736563 	svccs	0x00736563
     688:	6c647473 	cfstrdvs	mvd7, [r4], #-460	; 0xfffffe34
     68c:	732f6269 			; <UNDEFINED> instruction: 0x732f6269
     690:	00006372 	andeq	r6, r0, r2, ror r3
     694:	73647473 	cmnvc	r4, #1929379840	; 0x73000000
     698:	6e697274 	mcrvs	2, 3, r7, cr9, cr4, {3}
     69c:	70632e67 	rsbvc	r2, r3, r7, ror #28
     6a0:	00010070 	andeq	r0, r1, r0, ror r0
     6a4:	01050000 	mrseq	r0, (UNDEF: 5)
     6a8:	78020500 	stmdavc	r2, {r8, sl}
     6ac:	1a000088 	bne	8d4 <shift+0x8d4>
     6b0:	4bbb0905 	blmi	feec2acc <__bss_end+0xfeeb8e34>
     6b4:	054c0f05 	strbeq	r0, [ip, #-3845]	; 0xfffff0fb
     6b8:	2105681b 	tstcs	r5, fp, lsl r8
     6bc:	9e0a052e 	cfsh32ls	mvfx0, mvfx10, #30
     6c0:	052e0b05 	streq	r0, [lr, #-2821]!	; 0xfffff4fb
     6c4:	0d054a27 	vstreq	s8, [r5, #-156]	; 0xffffff64
     6c8:	2f09054a 	svccs	0x0009054a
     6cc:	05bb0405 	ldreq	r0, [fp, #1029]!	; 0x405
     6d0:	05056202 	streq	r6, [r5, #-514]	; 0xfffffdfe
     6d4:	68100535 	ldmdavs	r0, {r0, r2, r4, r5, r8, sl}
     6d8:	052e1105 	streq	r1, [lr, #-261]!	; 0xfffffefb
     6dc:	13054a22 	movwne	r4, #23074	; 0x5a22
     6e0:	2f0a052e 	svccs	0x000a052e
     6e4:	05690905 	strbeq	r0, [r9, #-2309]!	; 0xfffff6fb
     6e8:	0c052e0a 	stceq	14, cr2, [r5], {10}
     6ec:	4b03054a 	blmi	c1c1c <__bss_end+0xb7f84>
     6f0:	02001005 	andeq	r1, r0, #5
     6f4:	05680204 	strbeq	r0, [r8, #-516]!	; 0xfffffdfc
     6f8:	0402000c 	streq	r0, [r2], #-12
     6fc:	15059e02 	strne	r9, [r5, #-3586]	; 0xfffff1fe
     700:	01040200 	mrseq	r0, R12_usr
     704:	00180568 	andseq	r0, r8, r8, ror #10
     708:	82010402 	andhi	r0, r1, #33554432	; 0x2000000
     70c:	02000805 	andeq	r0, r0, #327680	; 0x50000
     710:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
     714:	0402001a 	streq	r0, [r2], #-26	; 0xffffffe6
     718:	1b054b01 	blne	153324 <__bss_end+0x14968c>
     71c:	01040200 	mrseq	r0, R12_usr
     720:	000c052e 	andeq	r0, ip, lr, lsr #10
     724:	4a010402 	bmi	41734 <__bss_end+0x37a9c>
     728:	02000f05 	andeq	r0, r0, #5, 30
     72c:	05820104 	streq	r0, [r2, #260]	; 0x104
     730:	0402001b 	streq	r0, [r2], #-27	; 0xffffffe5
     734:	11054a01 	tstne	r5, r1, lsl #20
     738:	01040200 	mrseq	r0, R12_usr
     73c:	000a052e 	andeq	r0, sl, lr, lsr #10
     740:	2f010402 	svccs	0x00010402
     744:	02000b05 	andeq	r0, r0, #5120	; 0x1400
     748:	052e0104 	streq	r0, [lr, #-260]!	; 0xfffffefc
     74c:	0402000d 	streq	r0, [r2], #-13
     750:	02054a01 	andeq	r4, r5, #4096	; 0x1000
     754:	01040200 	mrseq	r0, R12_usr
     758:	89010546 	stmdbhi	r1, {r1, r2, r6, r8, sl}
     75c:	830e0585 	movwhi	r0, #58757	; 0xe585
     760:	05661605 	strbeq	r1, [r6, #-1541]!	; 0xfffff9fb
     764:	10058205 	andne	r8, r5, r5, lsl #4
     768:	4a19054b 	bmi	641c9c <__bss_end+0x638004>
     76c:	054b0605 	strbeq	r0, [fp, #-1541]	; 0xfffff9fb
     770:	10054c09 	andne	r4, r5, r9, lsl #24
     774:	4c0a054a 	cfstr32mi	mvfx0, [sl], {74}	; 0x4a
     778:	05bb0705 	ldreq	r0, [fp, #1797]!	; 0x705
     77c:	17054a03 	strne	r4, [r5, -r3, lsl #20]
     780:	01040200 	mrseq	r0, R12_usr
     784:	0014054a 	andseq	r0, r4, sl, asr #10
     788:	4a010402 	bmi	41798 <__bss_end+0x37b00>
     78c:	054d0d05 	strbeq	r0, [sp, #-3333]	; 0xfffff2fb
     790:	0a054a14 	beq	152fe8 <__bss_end+0x149350>
     794:	6808052e 	stmdavs	r8, {r1, r2, r3, r5, r8, sl}
     798:	78030205 	stmdavc	r3, {r0, r2, r9}
     79c:	03090566 	movweq	r0, #38246	; 0x9566
     7a0:	01052e0b 	tsteq	r5, fp, lsl #28
     7a4:	6a27052f 	bvs	9c1c68 <__bss_end+0x9b7fd0>
     7a8:	4b840a05 	blmi	fe102fc4 <__bss_end+0xfe0f932c>
     7ac:	054b0b05 	strbeq	r0, [fp, #-2821]	; 0xfffff4fb
     7b0:	0e054a12 			; <UNDEFINED> instruction: 0x0e054a12
     7b4:	6709054b 	strvs	r0, [r9, -fp, asr #10]
     7b8:	02001805 	andeq	r1, r0, #327680	; 0x50000
     7bc:	05660104 	strbeq	r0, [r6, #-260]!	; 0xfffffefc
     7c0:	04020015 	streq	r0, [r2], #-21	; 0xffffffeb
     7c4:	11056601 	tstne	r5, r1, lsl #12
     7c8:	02040200 	andeq	r0, r4, #0, 4
     7cc:	001a054b 	andseq	r0, sl, fp, asr #10
     7d0:	4b020402 	blmi	817e0 <__bss_end+0x77b48>
     7d4:	02001205 	andeq	r1, r0, #1342177280	; 0x50000000
     7d8:	054b0204 	strbeq	r0, [fp, #-516]	; 0xfffffdfc
     7dc:	0402000d 	streq	r0, [r2], #-13
     7e0:	09056702 	stmdbeq	r5, {r1, r8, r9, sl, sp, lr}
     7e4:	00140531 	andseq	r0, r4, r1, lsr r5
     7e8:	66020402 	strvs	r0, [r2], -r2, lsl #8
     7ec:	02002605 	andeq	r2, r0, #5242880	; 0x500000
     7f0:	05660304 	strbeq	r0, [r6, #-772]!	; 0xfffffcfc
     7f4:	1a054c09 	bne	153820 <__bss_end+0x149b88>
     7f8:	4b0a0567 	blmi	281d9c <__bss_end+0x278104>
     7fc:	73030505 	movwvc	r0, #13573	; 0x3505
     800:	2e0f0366 	cdpcs	3, 0, cr0, cr15, cr6, {3}
     804:	02001c05 	andeq	r1, r0, #1280	; 0x500
     808:	05660104 	strbeq	r0, [r6, #-260]!	; 0xfffffefc
     80c:	02004c0f 	andeq	r4, r0, #3840	; 0xf00
     810:	66060104 	strvs	r0, [r6], -r4, lsl #2
     814:	02001305 	andeq	r1, r0, #335544320	; 0x14000000
     818:	2e060104 	adfcss	f0, f6, f4
     81c:	02000f05 	andeq	r0, r0, #5, 30
     820:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
     824:	01052e13 	tsteq	r5, r3, lsl lr
     828:	861e0530 			; <UNDEFINED> instruction: 0x861e0530
     82c:	67830c05 	strvs	r0, [r3, r5, lsl #24]
     830:	67090568 	strvs	r0, [r9, -r8, ror #10]
     834:	4b0a054b 	blmi	281d68 <__bss_end+0x2780d0>
     838:	054c0b05 	strbeq	r0, [ip, #-2821]	; 0xfffff4fb
     83c:	0d054a12 	vstreq	s8, [r5, #-72]	; 0xffffffb8
     840:	4a09054b 	bmi	241d74 <__bss_end+0x2380dc>
     844:	02001b05 	andeq	r1, r0, #5120	; 0x1400
     848:	054b0104 	strbeq	r0, [fp, #-260]	; 0xfffffefc
     84c:	04020012 	streq	r0, [r2], #-18	; 0xffffffee
     850:	0d054b01 	vstreq	d4, [r5, #-4]
     854:	01040200 	mrseq	r0, R12_usr
     858:	30120567 	andscc	r0, r2, r7, ror #10
     85c:	054a0e05 	strbeq	r0, [sl, #-3589]	; 0xfffff1fb
     860:	04020022 	streq	r0, [r2], #-34	; 0xffffffde
     864:	1f054a01 	svcne	0x00054a01
     868:	01040200 	mrseq	r0, R12_usr
     86c:	4b16054a 	blmi	581d9c <__bss_end+0x578104>
     870:	054a1d05 	strbeq	r1, [sl, #-3333]	; 0xfffff2fb
     874:	09052e10 	stmdbeq	r5, {r4, r9, sl, fp, sp}
     878:	67130567 	ldrvs	r0, [r3, -r7, ror #10]
     87c:	05d72305 	ldrbeq	r2, [r7, #773]	; 0x305
     880:	1d059e14 	stcne	14, cr9, [r5, #-80]	; 0xffffffb0
     884:	66140585 	ldrvs	r0, [r4], -r5, lsl #11
     888:	05680e05 	strbeq	r0, [r8, #-3589]!	; 0xfffff1fb
     88c:	66710305 	ldrbtvs	r0, [r1], -r5, lsl #6
     890:	11030c05 	tstne	r3, r5, lsl #24
     894:	4b01052e 	blmi	41d54 <__bss_end+0x380bc>
     898:	09052208 	stmdbeq	r5, {r3, r9, sp}
     89c:	001605bd 			; <UNDEFINED> instruction: 0x001605bd
     8a0:	4a040402 	bmi	1018b0 <__bss_end+0xf7c18>
     8a4:	02001d05 	andeq	r1, r0, #320	; 0x140
     8a8:	05820204 	streq	r0, [r2, #516]	; 0x204
     8ac:	0402001e 	streq	r0, [r2], #-30	; 0xffffffe2
     8b0:	16052e02 	strne	r2, [r5], -r2, lsl #28
     8b4:	02040200 	andeq	r0, r4, #0, 4
     8b8:	00110566 	andseq	r0, r1, r6, ror #10
     8bc:	4b030402 	blmi	c18cc <__bss_end+0xb7c34>
     8c0:	02001205 	andeq	r1, r0, #1342177280	; 0x50000000
     8c4:	052e0304 	streq	r0, [lr, #-772]!	; 0xfffffcfc
     8c8:	04020008 	streq	r0, [r2], #-8
     8cc:	09054a03 	stmdbeq	r5, {r0, r1, r9, fp, lr}
     8d0:	03040200 	movweq	r0, #16896	; 0x4200
     8d4:	0012052e 	andseq	r0, r2, lr, lsr #10
     8d8:	4a030402 	bmi	c18e8 <__bss_end+0xb7c50>
     8dc:	02000b05 	andeq	r0, r0, #5120	; 0x1400
     8e0:	052e0304 	streq	r0, [lr, #-772]!	; 0xfffffcfc
     8e4:	04020002 	streq	r0, [r2], #-2
     8e8:	0b052d03 	bleq	14bcfc <__bss_end+0x142064>
     8ec:	02040200 	andeq	r0, r4, #0, 4
     8f0:	00080584 	andeq	r0, r8, r4, lsl #11
     8f4:	83010402 	movwhi	r0, #5122	; 0x1402
     8f8:	02000905 	andeq	r0, r0, #81920	; 0x14000
     8fc:	052e0104 	streq	r0, [lr, #-260]!	; 0xfffffefc
     900:	0402000b 	streq	r0, [r2], #-11
     904:	02054a01 	andeq	r4, r5, #4096	; 0x1000
     908:	01040200 	mrseq	r0, R12_usr
     90c:	850b0549 	strhi	r0, [fp, #-1353]	; 0xfffffab7
     910:	852f0105 	strhi	r0, [pc, #-261]!	; 813 <shift+0x813>
     914:	05bc0e05 	ldreq	r0, [ip, #3589]!	; 0xe05
     918:	20056611 	andcs	r6, r5, r1, lsl r6
     91c:	660b05bc 			; <UNDEFINED> instruction: 0x660b05bc
     920:	054b1f05 	strbeq	r1, [fp, #-3845]	; 0xfffff0fb
     924:	0805660a 	stmdaeq	r5, {r1, r3, r9, sl, sp, lr}
     928:	8311054b 	tsthi	r1, #314572800	; 0x12c00000
     92c:	052e1605 	streq	r1, [lr, #-1541]!	; 0xfffff9fb
     930:	11056708 	tstne	r5, r8, lsl #14
     934:	4d0b0567 	cfstr32mi	mvfx0, [fp, #-412]	; 0xfffffe64
     938:	852f0105 	strhi	r0, [pc, #-261]!	; 83b <shift+0x83b>
     93c:	05830605 	streq	r0, [r3, #1541]	; 0x605
     940:	0c054c0b 	stceq	12, cr4, [r5], {11}
     944:	660e052e 	strvs	r0, [lr], -lr, lsr #10
     948:	054b0405 	strbeq	r0, [fp, #-1029]	; 0xfffffbfb
     94c:	09056502 	stmdbeq	r5, {r1, r8, sl, sp, lr}
     950:	2f010531 	svccs	0x00010531
     954:	05852a05 	streq	r2, [r5, #2565]	; 0xa05
     958:	05679f13 	strbeq	r9, [r7, #-3859]!	; 0xfffff0ed
     95c:	0d056709 	stceq	7, cr6, [r5, #-36]	; 0xffffffdc
     960:	0015054b 	andseq	r0, r5, fp, asr #10
     964:	4a030402 	bmi	c1974 <__bss_end+0xb7cdc>
     968:	02001905 	andeq	r1, r0, #81920	; 0x14000
     96c:	05830204 	streq	r0, [r3, #516]	; 0x204
     970:	0402001a 	streq	r0, [r2], #-26	; 0xffffffe6
     974:	0f052e02 	svceq	0x00052e02
     978:	02040200 	andeq	r0, r4, #0, 4
     97c:	0011054a 	andseq	r0, r1, sl, asr #10
     980:	82020402 	andhi	r0, r2, #33554432	; 0x2000000
     984:	02001a05 	andeq	r1, r0, #20480	; 0x5000
     988:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
     98c:	04020013 	streq	r0, [r2], #-19	; 0xffffffed
     990:	05052e02 	streq	r2, [r5, #-3586]	; 0xfffff1fe
     994:	02040200 	andeq	r0, r4, #0, 4
     998:	840a052d 	strhi	r0, [sl], #-1325	; 0xfffffad3
     99c:	052e0b05 	streq	r0, [lr, #-2821]!	; 0xfffff4fb
     9a0:	0c054a0d 			; <UNDEFINED> instruction: 0x0c054a0d
     9a4:	3001054b 	andcc	r0, r1, fp, asr #10
     9a8:	05673405 	strbeq	r3, [r7, #-1029]!	; 0xfffffbfb
     9ac:	1305bb09 	movwne	fp, #23305	; 0x5b09
     9b0:	6805054c 	stmdavs	r5, {r2, r3, r6, r8, sl}
     9b4:	02001905 	andeq	r1, r0, #81920	; 0x14000
     9b8:	05820104 	streq	r0, [r2, #260]	; 0x104
     9bc:	15054c0d 	strne	r4, [r5, #-3085]	; 0xfffff3f3
     9c0:	01040200 	mrseq	r0, R12_usr
     9c4:	8310054a 	tsthi	r0, #310378496	; 0x12800000
     9c8:	052e1105 	streq	r1, [lr, #-261]!	; 0xfffffefb
     9cc:	19056609 	stmdbne	r5, {r0, r3, r9, sl, sp, lr}
     9d0:	02040200 	andeq	r0, r4, #0, 4
     9d4:	001a054b 	andseq	r0, sl, fp, asr #10
     9d8:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
     9dc:	02000f05 	andeq	r0, r0, #5, 30
     9e0:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
     9e4:	04020011 	streq	r0, [r2], #-17	; 0xffffffef
     9e8:	1a058202 	bne	1611f8 <__bss_end+0x157560>
     9ec:	02040200 	andeq	r0, r4, #0, 4
     9f0:	0013054a 	andseq	r0, r3, sl, asr #10
     9f4:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
     9f8:	02000505 	andeq	r0, r0, #20971520	; 0x1400000
     9fc:	052c0204 	streq	r0, [ip, #-516]!	; 0xfffffdfc
     a00:	0a05831b 	beq	161674 <__bss_end+0x1579dc>
     a04:	2e0b0531 	mcrcs	5, 0, r0, cr11, cr1, {1}
     a08:	054a0d05 	strbeq	r0, [sl, #-3333]	; 0xfffff2fb
     a0c:	01054b0c 	tsteq	r5, ip, lsl #22
     a10:	08056a30 	stmdaeq	r5, {r4, r5, r9, fp, sp, lr}
     a14:	4c0b059f 	cfstr32mi	mvfx0, [fp], {159}	; 0x9f
     a18:	02001405 	andeq	r1, r0, #83886080	; 0x5000000
     a1c:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
     a20:	04020007 	streq	r0, [r2], #-7
     a24:	08058302 	stmdaeq	r5, {r1, r8, r9, pc}
     a28:	02040200 	andeq	r0, r4, #0, 4
     a2c:	000a052e 	andeq	r0, sl, lr, lsr #10
     a30:	4a020402 	bmi	81a40 <__bss_end+0x77da8>
     a34:	02000205 	andeq	r0, r0, #1342177280	; 0x50000000
     a38:	05490204 	strbeq	r0, [r9, #-516]	; 0xfffffdfc
     a3c:	05858401 	streq	r8, [r5, #1025]	; 0x401
     a40:	0805bb0e 	stmdaeq	r5, {r1, r2, r3, r8, r9, fp, ip, sp, pc}
     a44:	4c0b054b 	cfstr32mi	mvfx0, [fp], {75}	; 0x4b
     a48:	02001405 	andeq	r1, r0, #83886080	; 0x5000000
     a4c:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
     a50:	04020016 	streq	r0, [r2], #-22	; 0xffffffea
     a54:	17058302 	strne	r8, [r5, -r2, lsl #6]
     a58:	02040200 	andeq	r0, r4, #0, 4
     a5c:	000a052e 	andeq	r0, sl, lr, lsr #10
     a60:	4a020402 	bmi	81a70 <__bss_end+0x77dd8>
     a64:	02000b05 	andeq	r0, r0, #5120	; 0x1400
     a68:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
     a6c:	04020017 	streq	r0, [r2], #-23	; 0xffffffe9
     a70:	0d054a02 	vstreq	s8, [r5, #-8]
     a74:	02040200 	andeq	r0, r4, #0, 4
     a78:	0002052e 	andeq	r0, r2, lr, lsr #10
     a7c:	2d020402 	cfstrscs	mvf0, [r2, #-8]
     a80:	87840105 	strhi	r0, [r4, r5, lsl #2]
     a84:	059f0905 	ldreq	r0, [pc, #2309]	; 1391 <shift+0x1391>
     a88:	13054b10 	movwne	r4, #23312	; 0x5b10
     a8c:	bb100566 	bllt	40202c <__bss_end+0x3f8394>
     a90:	05810505 	streq	r0, [r1, #1285]	; 0x505
     a94:	0105310c 	tsteq	r5, ip, lsl #2
     a98:	0a05862f 	beq	16235c <__bss_end+0x1586c4>
     a9c:	670505a2 	strvs	r0, [r5, -r2, lsr #11]
     aa0:	05840e05 	streq	r0, [r4, #3589]	; 0xe05
     aa4:	0d05670b 	stceq	7, cr6, [r5, #-44]	; 0xffffffd4
     aa8:	4b0c0569 	blmi	302054 <__bss_end+0x2f83bc>
     aac:	670d059f 			; <UNDEFINED> instruction: 0x670d059f
     ab0:	05691705 	strbeq	r1, [r9, #-1797]!	; 0xfffff8fb
     ab4:	2d056615 	stccs	6, cr6, [r5, #-84]	; 0xffffffac
     ab8:	003d054a 	eorseq	r0, sp, sl, asr #10
     abc:	66010402 	strvs	r0, [r1], -r2, lsl #8
     ac0:	02003b05 	andeq	r3, r0, #5120	; 0x1400
     ac4:	05660104 	strbeq	r0, [r6, #-260]!	; 0xfffffefc
     ac8:	0402002d 	streq	r0, [r2], #-45	; 0xffffffd3
     acc:	2b054a01 	blcs	1532d8 <__bss_end+0x149640>
     ad0:	4a1c0568 	bmi	702078 <__bss_end+0x6f83e0>
     ad4:	05821505 	streq	r1, [r2, #1285]	; 0x505
     ad8:	10052e11 	andne	r2, r5, r1, lsl lr
     adc:	0505a067 	streq	sl, [r5, #-103]	; 0xffffff99
     ae0:	0316057d 	tsteq	r6, #524288000	; 0x1f400000
     ae4:	1b052e09 	blne	14c310 <__bss_end+0x142678>
     ae8:	4a1105d6 	bmi	442248 <__bss_end+0x4385b0>
     aec:	02002605 	andeq	r2, r0, #5242880	; 0x500000
     af0:	05ba0304 	ldreq	r0, [sl, #772]!	; 0x304
     af4:	0402000b 	streq	r0, [r2], #-11
     af8:	05059f02 	streq	r9, [r5, #-3842]	; 0xfffff0fe
     afc:	02040200 	andeq	r0, r4, #0, 4
     b00:	f50e0581 			; <UNDEFINED> instruction: 0xf50e0581
     b04:	054b1505 	strbeq	r1, [fp, #-1285]	; 0xfffffafb
     b08:	05d7660c 	ldrbeq	r6, [r7, #1548]	; 0x60c
     b0c:	0f059f05 	svceq	0x00059f05
     b10:	d7110584 	ldrle	r0, [r1, -r4, lsl #11]
     b14:	05d90c05 	ldrbeq	r0, [r9, #3077]	; 0xc05
     b18:	04020018 	streq	r0, [r2], #-24	; 0xffffffe8
     b1c:	09054a01 	stmdbeq	r5, {r0, r9, fp, lr}
     b20:	9f100568 	svcls	0x00100568
     b24:	05661205 	strbeq	r1, [r6, #-517]!	; 0xfffffdfb
     b28:	1005670e 	andne	r6, r5, lr, lsl #14
     b2c:	6612059f 			; <UNDEFINED> instruction: 0x6612059f
     b30:	05670e05 	strbeq	r0, [r7, #-3589]!	; 0xfffff1fb
     b34:	0402001d 	streq	r0, [r2], #-29	; 0xffffffe3
     b38:	10058201 	andne	r8, r5, r1, lsl #4
     b3c:	66120567 	ldrvs	r0, [r2], -r7, ror #10
     b40:	05691c05 	strbeq	r1, [r9, #-3077]!	; 0xfffff3fb
     b44:	10058222 	andne	r8, r5, r2, lsr #4
     b48:	6622052e 	strtvs	r0, [r2], -lr, lsr #10
     b4c:	054a1205 	strbeq	r1, [sl, #-517]	; 0xfffffdfb
     b50:	05052f14 	streq	r2, [r5, #-3860]	; 0xfffff0ec
     b54:	02040200 	andeq	r0, r4, #0, 4
     b58:	05d67503 	ldrbeq	r7, [r6, #1283]	; 0x503
     b5c:	9e0e0301 	cdpls	3, 0, cr0, cr14, cr1, {0}
     b60:	01000a02 	tsteq	r0, r2, lsl #20
     b64:	00007901 	andeq	r7, r0, r1, lsl #18
     b68:	46000300 	strmi	r0, [r0], -r0, lsl #6
     b6c:	02000000 	andeq	r0, r0, #0
     b70:	0d0efb01 	vstreq	d15, [lr, #-4]
     b74:	01010100 	mrseq	r0, (UNDEF: 17)
     b78:	00000001 	andeq	r0, r0, r1
     b7c:	01000001 	tsteq	r0, r1
     b80:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     b84:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     b88:	2f2e2e2f 	svccs	0x002e2e2f
     b8c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     b90:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
     b94:	63636762 	cmnvs	r3, #25690112	; 0x1880000
     b98:	6e6f632f 	cdpvs	3, 6, cr6, cr15, cr15, {1}
     b9c:	2f676966 	svccs	0x00676966
     ba0:	006d7261 	rsbeq	r7, sp, r1, ror #4
     ba4:	62696c00 	rsbvs	r6, r9, #0, 24
     ba8:	6e756631 	mrcvs	6, 3, r6, cr5, cr1, {1}
     bac:	532e7363 			; <UNDEFINED> instruction: 0x532e7363
     bb0:	00000100 	andeq	r0, r0, r0, lsl #2
     bb4:	02050000 	andeq	r0, r5, #0
     bb8:	000094d4 	ldrdeq	r9, [r0], -r4
     bbc:	0108cf03 	tsteq	r8, r3, lsl #30
     bc0:	2f2f2f30 	svccs	0x002f2f30
     bc4:	02302f2f 	eorseq	r2, r0, #47, 30	; 0xbc
     bc8:	2f1401d0 	svccs	0x001401d0
     bcc:	302f2f31 	eorcc	r2, pc, r1, lsr pc	; <UNPREDICTABLE>
     bd0:	03322f4c 	teqeq	r2, #76, 30	; 0x130
     bd4:	2f2f661f 	svccs	0x002f661f
     bd8:	2f2f2f2f 	svccs	0x002f2f2f
     bdc:	0002022f 	andeq	r0, r2, pc, lsr #4
     be0:	005c0101 	subseq	r0, ip, r1, lsl #2
     be4:	00030000 	andeq	r0, r3, r0
     be8:	00000046 	andeq	r0, r0, r6, asr #32
     bec:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
     bf0:	0101000d 	tsteq	r1, sp
     bf4:	00000101 	andeq	r0, r0, r1, lsl #2
     bf8:	00000100 	andeq	r0, r0, r0, lsl #2
     bfc:	2f2e2e01 	svccs	0x002e2e01
     c00:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     c04:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     c08:	2f2e2e2f 	svccs	0x002e2e2f
     c0c:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; b5c <shift+0xb5c>
     c10:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
     c14:	6f632f63 	svcvs	0x00632f63
     c18:	6769666e 	strbvs	r6, [r9, -lr, ror #12]!
     c1c:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
     c20:	696c0000 	stmdbvs	ip!, {}^	; <UNPREDICTABLE>
     c24:	75663162 	strbvc	r3, [r6, #-354]!	; 0xfffffe9e
     c28:	2e73636e 	cdpcs	3, 7, cr6, cr3, cr14, {3}
     c2c:	00010053 	andeq	r0, r1, r3, asr r0
     c30:	05000000 	streq	r0, [r0, #-0]
     c34:	0096e002 	addseq	lr, r6, r2
     c38:	0bb90300 	bleq	fee41840 <__bss_end+0xfee37ba8>
     c3c:	00020201 	andeq	r0, r2, r1, lsl #4
     c40:	00fb0101 	rscseq	r0, fp, r1, lsl #2
     c44:	00030000 	andeq	r0, r3, r0
     c48:	00000047 	andeq	r0, r0, r7, asr #32
     c4c:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
     c50:	0101000d 	tsteq	r1, sp
     c54:	00000101 	andeq	r0, r0, r1, lsl #2
     c58:	00000100 	andeq	r0, r0, r0, lsl #2
     c5c:	2f2e2e01 	svccs	0x002e2e01
     c60:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     c64:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     c68:	2f2e2e2f 	svccs	0x002e2e2f
     c6c:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; bbc <shift+0xbbc>
     c70:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
     c74:	6f632f63 	svcvs	0x00632f63
     c78:	6769666e 	strbvs	r6, [r9, -lr, ror #12]!
     c7c:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
     c80:	65690000 	strbvs	r0, [r9, #-0]!
     c84:	35376565 	ldrcc	r6, [r7, #-1381]!	; 0xfffffa9b
     c88:	66732d34 			; <UNDEFINED> instruction: 0x66732d34
     c8c:	0100532e 	tsteq	r0, lr, lsr #6
     c90:	00000000 	andeq	r0, r0, r0
     c94:	96e40205 	strbtls	r0, [r4], r5, lsl #4
     c98:	3a030000 	bcc	c0ca0 <__bss_end+0xb7008>
     c9c:	03332f01 	teqeq	r3, #1, 30
     ca0:	2f302e09 	svccs	0x00302e09
     ca4:	322f2f2f 	eorcc	r2, pc, #47, 30	; 0xbc
     ca8:	2f2f302f 	svccs	0x002f302f
     cac:	3033302f 	eorscc	r3, r3, pc, lsr #32
     cb0:	302f2f31 	eorcc	r2, pc, r1, lsr pc	; <UNPREDICTABLE>
     cb4:	302f2f2f 	eorcc	r2, pc, pc, lsr #30
     cb8:	32322f32 	eorscc	r2, r2, #50, 30	; 0xc8
     cbc:	2f312f2f 	svccs	0x00312f2f
     cc0:	2f332f33 	svccs	0x00332f33
     cc4:	2f312f2f 	svccs	0x00312f2f
     cc8:	352f312f 	strcc	r3, [pc, #-303]!	; ba1 <shift+0xba1>
     ccc:	2f2f302f 	svccs	0x002f302f
     cd0:	302f2f32 	eorcc	r2, pc, r2, lsr pc	; <UNPREDICTABLE>
     cd4:	2e19032f 	cdpcs	3, 1, cr0, cr9, cr15, {1}
     cd8:	352f2f2f 	strcc	r2, [pc, #-3887]!	; fffffdb1 <__bss_end+0xffff6119>
     cdc:	30342f2f 	eorscc	r2, r4, pc, lsr #30
     ce0:	2f302f33 	svccs	0x00302f33
     ce4:	30312f2f 	eorscc	r2, r1, pc, lsr #30
     ce8:	2f302f30 	svccs	0x00302f30
     cec:	302f3031 	eorcc	r3, pc, r1, lsr r0	; <UNPREDICTABLE>
     cf0:	2f312f32 	svccs	0x00312f32
     cf4:	2f2f302f 	svccs	0x002f302f
     cf8:	322f2f30 	eorcc	r2, pc, #48, 30	; 0xc0
     cfc:	09032f2f 	stmdbeq	r3, {r0, r1, r2, r3, r5, r8, r9, sl, fp, sp}
     d00:	2f2f302e 	svccs	0x002f302e
     d04:	2f2f302f 	svccs	0x002f302f
     d08:	2e0d032f 	cdpcs	3, 0, cr0, cr13, cr15, {1}
     d0c:	3030332f 	eorscc	r3, r0, pc, lsr #6
     d10:	30313130 	eorscc	r3, r1, r0, lsr r1
     d14:	2e0c032f 	cdpcs	3, 0, cr0, cr12, cr15, {1}
     d18:	332f3030 			; <UNDEFINED> instruction: 0x332f3030
     d1c:	332f3030 			; <UNDEFINED> instruction: 0x332f3030
     d20:	2f30312f 	svccs	0x0030312f
     d24:	2f30312f 	svccs	0x0030312f
     d28:	2f2e1903 	svccs	0x002e1903
     d2c:	2f302f32 	svccs	0x00302f32
     d30:	302f2f2f 	eorcc	r2, pc, pc, lsr #30
     d34:	2f2f302f 	svccs	0x002f302f
     d38:	2f302f2f 	svccs	0x00302f2f
     d3c:	01000202 	tsteq	r0, r2, lsl #4
     d40:	00007a01 	andeq	r7, r0, r1, lsl #20
     d44:	42000300 	andmi	r0, r0, #0, 6
     d48:	02000000 	andeq	r0, r0, #0
     d4c:	0d0efb01 	vstreq	d15, [lr, #-4]
     d50:	01010100 	mrseq	r0, (UNDEF: 17)
     d54:	00000001 	andeq	r0, r0, r1
     d58:	01000001 	tsteq	r0, r1
     d5c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     d60:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     d64:	2f2e2e2f 	svccs	0x002e2e2f
     d68:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     d6c:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
     d70:	63636762 	cmnvs	r3, #25690112	; 0x1880000
     d74:	6e6f632f 	cdpvs	3, 6, cr6, cr15, cr15, {1}
     d78:	2f676966 	svccs	0x00676966
     d7c:	006d7261 	rsbeq	r7, sp, r1, ror #4
     d80:	61706200 	cmnvs	r0, r0, lsl #4
     d84:	532e6962 			; <UNDEFINED> instruction: 0x532e6962
     d88:	00000100 	andeq	r0, r0, r0, lsl #2
     d8c:	02050000 	andeq	r0, r5, #0
     d90:	00009934 	andeq	r9, r0, r4, lsr r9
     d94:	0101b903 	tsteq	r1, r3, lsl #18
     d98:	2f4b5a08 	svccs	0x004b5a08
     d9c:	30302f2f 	eorscc	r2, r0, pc, lsr #30
     da0:	2f2f3267 	svccs	0x002f3267
     da4:	6730302f 	ldrvs	r3, [r0, -pc, lsr #32]!
     da8:	2f2f2f2f 	svccs	0x002f2f2f
     dac:	30302f32 	eorscc	r2, r0, r2, lsr pc
     db0:	322f2f67 	eorcc	r2, pc, #412	; 0x19c
     db4:	672f302f 	strvs	r3, [pc, -pc, lsr #32]!
     db8:	02022f2f 	andeq	r2, r2, #47, 30	; 0xbc
     dbc:	a4010100 	strge	r0, [r1], #-256	; 0xffffff00
     dc0:	03000000 	movweq	r0, #0
     dc4:	00009e00 	andeq	r9, r0, r0, lsl #28
     dc8:	fb010200 	blx	415d2 <__bss_end+0x3793a>
     dcc:	01000d0e 	tsteq	r0, lr, lsl #26
     dd0:	00010101 	andeq	r0, r1, r1, lsl #2
     dd4:	00010000 	andeq	r0, r1, r0
     dd8:	2e2e0100 	sufcse	f0, f6, f0
     ddc:	2f2e2e2f 	svccs	0x002e2e2f
     de0:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     de4:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     de8:	672f2e2f 	strvs	r2, [pc, -pc, lsr #28]!
     dec:	2e006363 	cdpcs	3, 0, cr6, cr0, cr3, {3}
     df0:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     df4:	2f2e2e2f 	svccs	0x002e2e2f
     df8:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     dfc:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     e00:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
     e04:	2f636367 	svccs	0x00636367
     e08:	672f2e2e 	strvs	r2, [pc, -lr, lsr #28]!
     e0c:	632f6363 			; <UNDEFINED> instruction: 0x632f6363
     e10:	69666e6f 	stmdbvs	r6!, {r0, r1, r2, r3, r5, r6, r9, sl, fp, sp, lr}^
     e14:	72612f67 	rsbvc	r2, r1, #412	; 0x19c
     e18:	2e2e006d 	cdpcs	0, 2, cr0, cr14, cr13, {3}
     e1c:	2f2e2e2f 	svccs	0x002e2e2f
     e20:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     e24:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     e28:	2f2e2e2f 	svccs	0x002e2e2f
     e2c:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
     e30:	00006363 	andeq	r6, r0, r3, ror #6
     e34:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
     e38:	2e617369 	cdpcs	3, 6, cr7, cr1, cr9, {3}
     e3c:	00010068 	andeq	r0, r1, r8, rrx
     e40:	6d726100 	ldfvse	f6, [r2, #-0]
     e44:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
     e48:	62670000 	rsbvs	r0, r7, #0
     e4c:	74632d6c 	strbtvc	r2, [r3], #-3436	; 0xfffff294
     e50:	2e73726f 	cdpcs	2, 7, cr7, cr3, cr15, {3}
     e54:	00030068 	andeq	r0, r3, r8, rrx
     e58:	62696c00 	rsbvs	r6, r9, #0, 24
     e5c:	32636367 	rsbcc	r6, r3, #-1677721599	; 0x9c000001
     e60:	0300632e 	movweq	r6, #814	; 0x32e
     e64:	a7000000 	strge	r0, [r0, -r0]
     e68:	03000000 	movweq	r0, #0
     e6c:	00006800 	andeq	r6, r0, r0, lsl #16
     e70:	fb010200 	blx	4167a <__bss_end+0x379e2>
     e74:	01000d0e 	tsteq	r0, lr, lsl #26
     e78:	00010101 	andeq	r0, r1, r1, lsl #2
     e7c:	00010000 	andeq	r0, r1, r0
     e80:	2e2e0100 	sufcse	f0, f6, f0
     e84:	2f2e2e2f 	svccs	0x002e2e2f
     e88:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     e8c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     e90:	2f2e2e2f 	svccs	0x002e2e2f
     e94:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
     e98:	2e006363 	cdpcs	3, 0, cr6, cr0, cr3, {3}
     e9c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     ea0:	2f2e2e2f 	svccs	0x002e2e2f
     ea4:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     ea8:	2f2e2f2e 	svccs	0x002e2f2e
     eac:	00636367 	rsbeq	r6, r3, r7, ror #6
     eb0:	62696c00 	rsbvs	r6, r9, #0, 24
     eb4:	32636367 	rsbcc	r6, r3, #-1677721599	; 0x9c000001
     eb8:	0100632e 	tsteq	r0, lr, lsr #6
     ebc:	72610000 	rsbvc	r0, r1, #0
     ec0:	73692d6d 	cmnvc	r9, #6976	; 0x1b40
     ec4:	00682e61 	rsbeq	r2, r8, r1, ror #28
     ec8:	6c000002 	stcvs	0, cr0, [r0], {2}
     ecc:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
     ed0:	682e3263 	stmdavs	lr!, {r0, r1, r5, r6, r9, ip, sp}
     ed4:	00000100 	andeq	r0, r0, r0, lsl #2
     ed8:	00010500 	andeq	r0, r1, r0, lsl #10
     edc:	9a080205 	bls	2016f8 <__bss_end+0x1f7a60>
     ee0:	f9030000 			; <UNDEFINED> instruction: 0xf9030000
     ee4:	0305010b 	movweq	r0, #20747	; 0x510b
     ee8:	06010513 			; <UNDEFINED> instruction: 0x06010513
     eec:	2f060511 	svccs	0x00060511
     ef0:	68060305 	stmdavs	r6, {r0, r2, r8, r9}
     ef4:	01060a05 	tsteq	r6, r5, lsl #20
     ef8:	2d060505 	cfstr32cs	mvfx0, [r6, #-20]	; 0xffffffec
     efc:	01060e05 	tsteq	r6, r5, lsl #28
     f00:	052c0105 	streq	r0, [ip, #-261]!	; 0xfffffefb
     f04:	052e300e 	streq	r3, [lr, #-14]!
     f08:	01052e0c 	tsteq	r5, ip, lsl #28
     f0c:	0002024c 	andeq	r0, r2, ip, asr #4
     f10:	00b60101 	adcseq	r0, r6, r1, lsl #2
     f14:	00030000 	andeq	r0, r3, r0
     f18:	00000068 	andeq	r0, r0, r8, rrx
     f1c:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
     f20:	0101000d 	tsteq	r1, sp
     f24:	00000101 	andeq	r0, r0, r1, lsl #2
     f28:	00000100 	andeq	r0, r0, r0, lsl #2
     f2c:	2f2e2e01 	svccs	0x002e2e01
     f30:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     f34:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     f38:	2f2e2e2f 	svccs	0x002e2e2f
     f3c:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; e8c <shift+0xe8c>
     f40:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
     f44:	2e2e0063 	cdpcs	0, 2, cr0, cr14, cr3, {3}
     f48:	2f2e2e2f 	svccs	0x002e2e2f
     f4c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     f50:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     f54:	672f2e2f 	strvs	r2, [pc, -pc, lsr #28]!
     f58:	00006363 	andeq	r6, r0, r3, ror #6
     f5c:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
     f60:	2e326363 	cdpcs	3, 3, cr6, cr2, cr3, {3}
     f64:	00010063 	andeq	r0, r1, r3, rrx
     f68:	6d726100 	ldfvse	f6, [r2, #-0]
     f6c:	6173692d 	cmnvs	r3, sp, lsr #18
     f70:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
     f74:	696c0000 	stmdbvs	ip!, {}^	; <UNPREDICTABLE>
     f78:	63636762 	cmnvs	r3, #25690112	; 0x1880000
     f7c:	00682e32 	rsbeq	r2, r8, r2, lsr lr
     f80:	00000001 	andeq	r0, r0, r1
     f84:	05000105 	streq	r0, [r0, #-261]	; 0xfffffefb
     f88:	009a3802 	addseq	r3, sl, r2, lsl #16
     f8c:	0bb90300 	bleq	fee41b94 <__bss_end+0xfee37efc>
     f90:	17030501 	strne	r0, [r3, -r1, lsl #10]
     f94:	01061005 	tsteq	r6, r5
     f98:	05331905 	ldreq	r1, [r3, #-2309]!	; 0xfffff6fb
     f9c:	10053327 	andne	r3, r5, r7, lsr #6
     fa0:	052e7603 	streq	r7, [lr, #-1539]!	; 0xfffff9fd
     fa4:	05330603 	ldreq	r0, [r3, #-1539]!	; 0xfffff9fd
     fa8:	05010619 	streq	r0, [r1, #-1561]	; 0xfffff9e7
     fac:	03052e10 	movweq	r2, #24080	; 0x5e10
     fb0:	05153306 	ldreq	r3, [r5, #-774]	; 0xfffffcfa
     fb4:	050f061b 	streq	r0, [pc, #-1563]	; 9a1 <shift+0x9a1>
     fb8:	2e2b0301 	cdpcs	3, 2, cr0, cr11, cr1, {0}
     fbc:	55031905 	strpl	r1, [r3, #-2309]	; 0xfffff6fb
     fc0:	0301052e 	movweq	r0, #5422	; 0x152e
     fc4:	024a2e2b 	subeq	r2, sl, #688	; 0x2b0
     fc8:	0101000a 	tsteq	r1, sl
     fcc:	00000169 	andeq	r0, r0, r9, ror #2
     fd0:	00680003 	rsbeq	r0, r8, r3
     fd4:	01020000 	mrseq	r0, (UNDEF: 2)
     fd8:	000d0efb 	strdeq	r0, [sp], -fp
     fdc:	01010101 	tsteq	r1, r1, lsl #2
     fe0:	01000000 	mrseq	r0, (UNDEF: 0)
     fe4:	2e010000 	cdpcs	0, 0, cr0, cr1, cr0, {0}
     fe8:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     fec:	2f2e2e2f 	svccs	0x002e2e2f
     ff0:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     ff4:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     ff8:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
     ffc:	00636367 	rsbeq	r6, r3, r7, ror #6
    1000:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1004:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1008:	2f2e2e2f 	svccs	0x002e2e2f
    100c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1010:	6363672f 	cmnvs	r3, #12320768	; 0xbc0000
    1014:	696c0000 	stmdbvs	ip!, {}^	; <UNPREDICTABLE>
    1018:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    101c:	00632e32 	rsbeq	r2, r3, r2, lsr lr
    1020:	61000001 	tstvs	r0, r1
    1024:	692d6d72 	pushvs	{r1, r4, r5, r6, r8, sl, fp, sp, lr}
    1028:	682e6173 	stmdavs	lr!, {r0, r1, r4, r5, r6, r8, sp, lr}
    102c:	00000200 	andeq	r0, r0, r0, lsl #4
    1030:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    1034:	2e326363 	cdpcs	3, 3, cr6, cr2, cr3, {3}
    1038:	00010068 	andeq	r0, r1, r8, rrx
    103c:	01050000 	mrseq	r0, (UNDEF: 5)
    1040:	78020500 	stmdavc	r2, {r8, sl}
    1044:	0300009a 	movweq	r0, #154	; 0x9a
    1048:	050107b3 	streq	r0, [r1, #-1971]	; 0xfffff84d
    104c:	03131303 	tsteq	r3, #201326592	; 0xc000000
    1050:	0605010a 	streq	r0, [r5], -sl, lsl #2
    1054:	01050106 	tsteq	r5, r6, lsl #2
    1058:	054a7403 	strbeq	r7, [sl, #-1027]	; 0xfffffbfd
    105c:	01052f0b 	tsteq	r5, fp, lsl #30
    1060:	2f0b052d 	svccs	0x000b052d
    1064:	0b030605 	bleq	c2880 <__bss_end+0xb8be8>
    1068:	0607052e 	streq	r0, [r7], -lr, lsr #10
    106c:	060d0530 			; <UNDEFINED> instruction: 0x060d0530
    1070:	06070501 	streq	r0, [r7], -r1, lsl #10
    1074:	060d0583 	streq	r0, [sp], -r3, lsl #11
    1078:	07054a01 	streq	r4, [r5, -r1, lsl #20]
    107c:	09054c06 	stmdbeq	r5, {r1, r2, sl, fp, lr}
    1080:	07050106 	streq	r0, [r5, -r6, lsl #2]
    1084:	09052f06 	stmdbeq	r5, {r1, r2, r8, r9, sl, fp, sp}
    1088:	052e0106 	streq	r0, [lr, #-262]!	; 0xfffffefa
    108c:	05a50607 	streq	r0, [r5, #1543]!	; 0x607
    1090:	2e01060a 	cfmadd32cs	mvax0, mvfx0, mvfx1, mvfx10
    1094:	68030b05 	stmdavs	r3, {r0, r2, r8, r9, fp}
    1098:	030a052e 	movweq	r0, #42286	; 0xa52e
    109c:	04054a18 	streq	r4, [r5], #-2584	; 0xfffff5e8
    10a0:	06053006 	streq	r3, [r5], -r6
    10a4:	2f491306 	svccs	0x00491306
    10a8:	06040549 	streq	r0, [r4], -r9, asr #10
    10ac:	1507052f 	strne	r0, [r7, #-1327]	; 0xfffffad1
    10b0:	01060a05 	tsteq	r6, r5, lsl #20
    10b4:	4c060405 	cfstrsmi	mvf0, [r6], {5}
    10b8:	01060605 	tsteq	r6, r5, lsl #12
    10bc:	0604052e 	streq	r0, [r4], -lr, lsr #10
    10c0:	0606054e 	streq	r0, [r6], -lr, asr #10
    10c4:	520b050e 	andpl	r0, fp, #58720256	; 0x3800000
    10c8:	054a1005 	strbeq	r1, [sl, #-5]
    10cc:	052e4a05 	streq	r4, [lr, #-2565]!	; 0xfffff5fb
    10d0:	05310608 	ldreq	r0, [r1, #-1544]!	; 0xfffff9f8
    10d4:	0605130e 	streq	r1, [r5], -lr, lsl #6
    10d8:	052e0106 	streq	r0, [lr, #-262]!	; 0xfffffefa
    10dc:	79030604 	stmdbvc	r3, {r2, r9, sl}
    10e0:	1408052e 	strne	r0, [r8], #-1326	; 0xfffffad2
    10e4:	14130305 	ldrne	r0, [r3], #-773	; 0xfffffcfb
    10e8:	0f060b05 	svceq	0x00060b05
    10ec:	2e690505 	cdpcs	5, 6, cr0, cr9, cr5, {0}
    10f0:	2f060805 	svccs	0x00060805
    10f4:	05130e05 	ldreq	r0, [r3, #-3589]	; 0xfffff1fb
    10f8:	2e010606 	cfmadd32cs	mvax0, mvfx0, mvfx1, mvfx6
    10fc:	32060405 	andcc	r0, r6, #83886080	; 0x5000000
    1100:	01060605 	tsteq	r6, r5, lsl #12
    1104:	0405492f 	streq	r4, [r5], #-2351	; 0xfffff6d1
    1108:	06052f06 	streq	r2, [r5], -r6, lsl #30
    110c:	04050106 	streq	r0, [r5], #-262	; 0xfffffefa
    1110:	0f054b06 	svceq	0x00054b06
    1114:	054a0106 	strbeq	r0, [sl, #-262]	; 0xfffffefa
    1118:	052e4a06 	streq	r4, [lr, #-2566]!	; 0xfffff5fa
    111c:	05320603 	ldreq	r0, [r2, #-1539]!	; 0xfffff9fd
    1120:	05010606 	streq	r0, [r1, #-1542]	; 0xfffff9fa
    1124:	052f0605 	streq	r0, [pc, #-1541]!	; b27 <shift+0xb27>
    1128:	05010609 	streq	r0, [r1, #-1545]	; 0xfffff9f7
    112c:	052f0603 	streq	r0, [pc, #-1539]!	; b31 <shift+0xb31>
    1130:	2e130601 	cfmsub32cs	mvax0, mvfx0, mvfx3, mvfx1
    1134:	01000402 	tsteq	r0, r2, lsl #8
    1138:	Address 0x0000000000001138 is out of bounds.


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
      34:	fb0c0000 	blx	30003e <__bss_end+0x2f63a6>
      38:	2a000000 	bcs	40 <shift+0x40>
      3c:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
      40:	9c000080 	stcls	0, cr0, [r0], {128}	; 0x80
      44:	5a000000 	bpl	4c <shift+0x4c>
      48:	02000000 	andeq	r0, r0, #0
      4c:	0000012c 	andeq	r0, r0, ip, lsr #2
      50:	31150601 	tstcc	r5, r1, lsl #12
      54:	03000000 	movweq	r0, #0
      58:	15ee0704 	strbne	r0, [lr, #1796]!	; 0x704
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
     128:	000015ee 	andeq	r1, r0, lr, ror #11
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
     174:	cb104801 	blgt	412180 <__bss_end+0x4084e8>
     178:	d4000000 	strle	r0, [r0], #-0
     17c:	58000081 	stmdapl	r0, {r0, r7}
     180:	01000000 	mrseq	r0, (UNDEF: 0)
     184:	0000cb9c 	muleq	r0, ip, fp
     188:	01800a00 	orreq	r0, r0, r0, lsl #20
     18c:	4a010000 	bmi	40194 <__bss_end+0x364fc>
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
     1d4:	5b0c0000 	blpl	3001dc <__bss_end+0x2f6544>
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
     24c:	8b120f01 	blhi	483e58 <__bss_end+0x47a1c0>
     250:	0f000001 	svceq	0x00000001
     254:	0000019e 	muleq	r0, lr, r1
     258:	03231000 			; <UNDEFINED> instruction: 0x03231000
     25c:	0a010000 	beq	40264 <__bss_end+0x365cc>
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
     2b4:	8b140074 	blhi	50048c <__bss_end+0x4f67f4>
     2b8:	a4000001 	strge	r0, [r0], #-1
     2bc:	38000080 	stmdacc	r0, {r7}
     2c0:	01000000 	mrseq	r0, (UNDEF: 0)
     2c4:	0067139c 	mlseq	r7, ip, r3, r1
     2c8:	9e2f0a01 	vmulls.f32	s0, s30, s2
     2cc:	02000001 	andeq	r0, r0, #1
     2d0:	00007491 	muleq	r0, r1, r4
     2d4:	000008e9 	andeq	r0, r0, r9, ror #17
     2d8:	01e00004 	mvneq	r0, r4
     2dc:	01040000 	mrseq	r0, (UNDEF: 4)
     2e0:	0000025e 	andeq	r0, r0, lr, asr r2
     2e4:	000b1604 	andeq	r1, fp, r4, lsl #12
     2e8:	00002a00 	andeq	r2, r0, r0, lsl #20
     2ec:	00822c00 	addeq	r2, r2, r0, lsl #24
     2f0:	0001ec00 	andeq	lr, r1, r0, lsl #24
     2f4:	0001c200 	andeq	ip, r1, r0, lsl #4
     2f8:	08010200 	stmdaeq	r1, {r9}
     2fc:	00000abd 			; <UNDEFINED> instruction: 0x00000abd
     300:	63050202 	movwvs	r0, #20994	; 0x5202
     304:	03000009 	movweq	r0, #9
     308:	6e690504 	cdpvs	5, 6, cr0, cr9, cr4, {0}
     30c:	01020074 	tsteq	r2, r4, ror r0
     310:	000ab408 	andeq	fp, sl, r8, lsl #8
     314:	07020200 	streq	r0, [r2, -r0, lsl #4]
     318:	00000ba2 	andeq	r0, r0, r2, lsr #23
     31c:	00057404 	andeq	r7, r5, r4, lsl #8
     320:	07090900 	streq	r0, [r9, -r0, lsl #18]
     324:	00000059 	andeq	r0, r0, r9, asr r0
     328:	00004805 	andeq	r4, r0, r5, lsl #16
     32c:	07040200 	streq	r0, [r4, -r0, lsl #4]
     330:	000015ee 	andeq	r1, r0, lr, ror #11
     334:	00005905 	andeq	r5, r0, r5, lsl #18
     338:	0c580600 	mrrceq	6, 0, r0, r8, cr0
     33c:	02080000 	andeq	r0, r8, #0
     340:	008b0806 	addeq	r0, fp, r6, lsl #16
     344:	72070000 	andvc	r0, r7, #0
     348:	08020030 	stmdaeq	r2, {r4, r5}
     34c:	0000480e 	andeq	r4, r0, lr, lsl #16
     350:	72070000 	andvc	r0, r7, #0
     354:	09020031 	stmdbeq	r2, {r0, r4, r5}
     358:	0000480e 	andeq	r4, r0, lr, lsl #16
     35c:	08000400 	stmdaeq	r0, {sl}
     360:	000009c4 	andeq	r0, r0, r4, asr #19
     364:	00330405 	eorseq	r0, r3, r5, lsl #8
     368:	1e020000 	cdpne	0, 0, cr0, cr2, cr0, {0}
     36c:	0000ce0c 	andeq	ip, r0, ip, lsl #28
     370:	056c0900 	strbeq	r0, [ip, #-2304]!	; 0xfffff700
     374:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
     378:	000006b5 			; <UNDEFINED> instruction: 0x000006b5
     37c:	09e60901 	stmibeq	r6!, {r0, r8, fp}^
     380:	09020000 	stmdbeq	r2, {}	; <UNPREDICTABLE>
     384:	00000ad7 	ldrdeq	r0, [r0], -r7
     388:	069b0903 	ldreq	r0, [fp], r3, lsl #18
     38c:	09040000 	stmdbeq	r4, {}	; <UNPREDICTABLE>
     390:	00000942 	andeq	r0, r0, r2, asr #18
     394:	0ac20905 	beq	ff0827b0 <__bss_end+0xff078b18>
     398:	09060000 	stmdbeq	r6, {}	; <UNPREDICTABLE>
     39c:	00000b56 	andeq	r0, r0, r6, asr fp
     3a0:	ac080007 	stcge	0, cr0, [r8], {7}
     3a4:	05000009 	streq	r0, [r0, #-9]
     3a8:	00003304 	andeq	r3, r0, r4, lsl #6
     3ac:	0c490200 	sfmeq	f0, 2, [r9], {-0}
     3b0:	0000010b 	andeq	r0, r0, fp, lsl #2
     3b4:	00064c09 	andeq	r4, r6, r9, lsl #24
     3b8:	b0090000 	andlt	r0, r9, r0
     3bc:	01000006 	tsteq	r0, r6
     3c0:	000bdf09 	andeq	sp, fp, r9, lsl #30
     3c4:	8f090200 	svchi	0x00090200
     3c8:	03000008 	movweq	r0, #8
     3cc:	0006aa09 	andeq	sl, r6, r9, lsl #20
     3d0:	fa090400 	blx	2413d8 <__bss_end+0x237740>
     3d4:	05000006 	streq	r0, [r0, #-6]
     3d8:	0005a609 	andeq	sl, r5, r9, lsl #12
     3dc:	08000600 	stmdaeq	r0, {r9, sl}
     3e0:	0000058b 	andeq	r0, r0, fp, lsl #11
     3e4:	00330405 	eorseq	r0, r3, r5, lsl #8
     3e8:	70020000 	andvc	r0, r2, r0
     3ec:	0001360c 	andeq	r3, r1, ip, lsl #12
     3f0:	0aa90900 	beq	fea427f8 <__bss_end+0xfea38b60>
     3f4:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
     3f8:	000004b1 			; <UNDEFINED> instruction: 0x000004b1
     3fc:	0a0a0901 	beq	282808 <__bss_end+0x278b70>
     400:	09020000 	stmdbeq	r2, {}	; <UNPREDICTABLE>
     404:	0000094b 	andeq	r0, r0, fp, asr #18
     408:	630a0003 	movwvs	r0, #40963	; 0xa003
     40c:	03000008 	movweq	r0, #8
     410:	00541405 	subseq	r1, r4, r5, lsl #8
     414:	03050000 	movweq	r0, #20480	; 0x5000
     418:	00009b98 	muleq	r0, r8, fp
     41c:	000a3d0a 	andeq	r3, sl, sl, lsl #26
     420:	14060300 	strne	r0, [r6], #-768	; 0xfffffd00
     424:	00000054 	andeq	r0, r0, r4, asr r0
     428:	9b9c0305 	blls	fe701044 <__bss_end+0xfe6f73ac>
     42c:	0f0a0000 	svceq	0x000a0000
     430:	04000007 	streq	r0, [r0], #-7
     434:	00541a07 	subseq	r1, r4, r7, lsl #20
     438:	03050000 	movweq	r0, #20480	; 0x5000
     43c:	00009ba0 	andeq	r9, r0, r0, lsr #23
     440:	0009740a 	andeq	r7, r9, sl, lsl #8
     444:	1a090400 	bne	24144c <__bss_end+0x2377b4>
     448:	00000054 	andeq	r0, r0, r4, asr r0
     44c:	9ba40305 	blls	fe901068 <__bss_end+0xfe8f73d0>
     450:	010a0000 	mrseq	r0, (UNDEF: 10)
     454:	04000007 	streq	r0, [r0], #-7
     458:	00541a0b 	subseq	r1, r4, fp, lsl #20
     45c:	03050000 	movweq	r0, #20480	; 0x5000
     460:	00009ba8 	andeq	r9, r0, r8, lsr #23
     464:	0009270a 	andeq	r2, r9, sl, lsl #14
     468:	1a0d0400 	bne	341470 <__bss_end+0x3377d8>
     46c:	00000054 	andeq	r0, r0, r4, asr r0
     470:	9bac0305 	blls	feb0108c <__bss_end+0xfeaf73f4>
     474:	4c0a0000 	stcmi	0, cr0, [sl], {-0}
     478:	04000005 	streq	r0, [r0], #-5
     47c:	00541a0f 	subseq	r1, r4, pc, lsl #20
     480:	03050000 	movweq	r0, #20480	; 0x5000
     484:	00009bb0 			; <UNDEFINED> instruction: 0x00009bb0
     488:	000fed08 	andeq	lr, pc, r8, lsl #26
     48c:	33040500 	movwcc	r0, #17664	; 0x4500
     490:	04000000 	streq	r0, [r0], #-0
     494:	01d90c1b 	bicseq	r0, r9, fp, lsl ip
     498:	ef090000 	svc	0x00090000
     49c:	00000004 	andeq	r0, r0, r4
     4a0:	000b0209 	andeq	r0, fp, r9, lsl #4
     4a4:	da090100 	ble	2408ac <__bss_end+0x236c14>
     4a8:	0200000b 	andeq	r0, r0, #11
     4ac:	03a70b00 			; <UNDEFINED> instruction: 0x03a70b00
     4b0:	01020000 	mrseq	r0, (UNDEF: 2)
     4b4:	00079902 	andeq	r9, r7, r2, lsl #18
     4b8:	d9040c00 	stmdble	r4, {sl, fp}
     4bc:	0a000001 	beq	4c8 <shift+0x4c8>
     4c0:	00000505 	andeq	r0, r0, r5, lsl #10
     4c4:	54140405 	ldrpl	r0, [r4], #-1029	; 0xfffffbfb
     4c8:	05000000 	streq	r0, [r0, #-0]
     4cc:	009bb403 	addseq	fp, fp, r3, lsl #8
     4d0:	09ec0a00 	stmibeq	ip!, {r9, fp}^
     4d4:	07050000 	streq	r0, [r5, -r0]
     4d8:	00005414 	andeq	r5, r0, r4, lsl r4
     4dc:	b8030500 	stmdalt	r3, {r8, sl}
     4e0:	0a00009b 	beq	754 <shift+0x754>
     4e4:	00000455 	andeq	r0, r0, r5, asr r4
     4e8:	54140a05 	ldrpl	r0, [r4], #-2565	; 0xfffff5fb
     4ec:	05000000 	streq	r0, [r0, #-0]
     4f0:	009bbc03 	addseq	fp, fp, r3, lsl #24
     4f4:	05ab0800 	streq	r0, [fp, #2048]!	; 0x800
     4f8:	04050000 	streq	r0, [r5], #-0
     4fc:	00000033 	andeq	r0, r0, r3, lsr r0
     500:	580c0d05 	stmdapl	ip, {r0, r2, r8, sl, fp}
     504:	0d000002 	stceq	0, cr0, [r0, #-8]
     508:	0077654e 	rsbseq	r6, r7, lr, asr #10
     50c:	04100900 	ldreq	r0, [r0], #-2304	; 0xfffff700
     510:	09010000 	stmdbeq	r1, {}	; <UNPREDICTABLE>
     514:	0000044d 	andeq	r0, r0, sp, asr #8
     518:	05c40902 	strbeq	r0, [r4, #2306]	; 0x902
     51c:	09030000 	stmdbeq	r3, {}	; <UNPREDICTABLE>
     520:	00000ac9 	andeq	r0, r0, r9, asr #21
     524:	04040904 	streq	r0, [r4], #-2308	; 0xfffff6fc
     528:	00050000 	andeq	r0, r5, r0
     52c:	00051e06 	andeq	r1, r5, r6, lsl #28
     530:	1b051000 	blne	144538 <__bss_end+0x13a8a0>
     534:	00029708 	andeq	r9, r2, r8, lsl #14
     538:	726c0700 	rsbvc	r0, ip, #0, 14
     53c:	131d0500 	tstne	sp, #0, 10
     540:	00000297 	muleq	r0, r7, r2
     544:	70730700 	rsbsvc	r0, r3, r0, lsl #14
     548:	131e0500 	tstne	lr, #0, 10
     54c:	00000297 	muleq	r0, r7, r2
     550:	63700704 	cmnvs	r0, #4, 14	; 0x100000
     554:	131f0500 	tstne	pc, #0, 10
     558:	00000297 	muleq	r0, r7, r2
     55c:	09a60e08 	stmibeq	r6!, {r3, r9, sl, fp}
     560:	20050000 	andcs	r0, r5, r0
     564:	00029713 	andeq	r9, r2, r3, lsl r7
     568:	02000c00 	andeq	r0, r0, #0, 24
     56c:	15e90704 	strbne	r0, [r9, #1796]!	; 0x704
     570:	97050000 	strls	r0, [r5, -r0]
     574:	06000002 	streq	r0, [r0], -r2
     578:	0000068e 	andeq	r0, r0, lr, lsl #13
     57c:	0828057c 	stmdaeq	r8!, {r2, r3, r4, r5, r6, r8, sl}
     580:	0000035a 	andeq	r0, r0, sl, asr r3
     584:	0006310e 	andeq	r3, r6, lr, lsl #2
     588:	122a0500 	eorne	r0, sl, #0, 10
     58c:	00000258 	andeq	r0, r0, r8, asr r2
     590:	69700700 	ldmdbvs	r0!, {r8, r9, sl}^
     594:	2b050064 	blcs	14072c <__bss_end+0x136a94>
     598:	00005912 	andeq	r5, r0, r2, lsl r9
     59c:	fc0e1000 	stc2	0, cr1, [lr], {-0}
     5a0:	0500000a 	streq	r0, [r0, #-10]
     5a4:	0221112c 	eoreq	r1, r1, #44, 2
     5a8:	0e140000 	cdpeq	0, 1, cr0, cr4, cr0, {0}
     5ac:	00000a9b 	muleq	r0, fp, sl
     5b0:	59122d05 	ldmdbpl	r2, {r0, r2, r8, sl, fp, sp}
     5b4:	18000000 	stmdane	r0, {}	; <UNPREDICTABLE>
     5b8:	0003370e 	andeq	r3, r3, lr, lsl #14
     5bc:	122e0500 	eorne	r0, lr, #0, 10
     5c0:	00000059 	andeq	r0, r0, r9, asr r0
     5c4:	09d90e1c 	ldmibeq	r9, {r2, r3, r4, r9, sl, fp}^
     5c8:	2f050000 	svccs	0x00050000
     5cc:	00035a0c 	andeq	r5, r3, ip, lsl #20
     5d0:	c00e2000 	andgt	r2, lr, r0
     5d4:	05000003 	streq	r0, [r0, #-3]
     5d8:	00330930 	eorseq	r0, r3, r0, lsr r9
     5dc:	0e600000 	cdpeq	0, 6, cr0, cr0, cr0, {0}
     5e0:	000005ef 	andeq	r0, r0, pc, ror #11
     5e4:	480e3105 	stmdami	lr, {r0, r2, r8, ip, sp}
     5e8:	64000000 	strvs	r0, [r0], #-0
     5ec:	0008e40e 	andeq	lr, r8, lr, lsl #8
     5f0:	0e330500 	cfabs32eq	mvfx0, mvfx3
     5f4:	00000048 	andeq	r0, r0, r8, asr #32
     5f8:	08db0e68 	ldmeq	fp, {r3, r5, r6, r9, sl, fp}^
     5fc:	34050000 	strcc	r0, [r5], #-0
     600:	0000480e 	andeq	r4, r0, lr, lsl #16
     604:	7d0e6c00 	stcvc	12, cr6, [lr, #-0]
     608:	05000005 	streq	r0, [r0, #-5]
     60c:	00480e35 	subeq	r0, r8, r5, lsr lr
     610:	0e700000 	cdpeq	0, 7, cr0, cr0, cr0, {0}
     614:	00000997 	muleq	r0, r7, r9
     618:	480e3605 	stmdami	lr, {r0, r2, r9, sl, ip, sp}
     61c:	74000000 	strvc	r0, [r0], #-0
     620:	000bb50e 	andeq	fp, fp, lr, lsl #10
     624:	0e370500 	cfabs32eq	mvfx0, mvfx7
     628:	00000048 	andeq	r0, r0, r8, asr #32
     62c:	e50f0078 	str	r0, [pc, #-120]	; 5bc <shift+0x5bc>
     630:	6a000001 	bvs	63c <shift+0x63c>
     634:	10000003 	andne	r0, r0, r3
     638:	00000059 	andeq	r0, r0, r9, asr r0
     63c:	3e0a000f 	cdpcc	0, 0, cr0, cr10, cr15, {0}
     640:	06000004 	streq	r0, [r0], -r4
     644:	0054140a 	subseq	r1, r4, sl, lsl #8
     648:	03050000 	movweq	r0, #20480	; 0x5000
     64c:	00009bc0 	andeq	r9, r0, r0, asr #23
     650:	00074a08 	andeq	r4, r7, r8, lsl #20
     654:	33040500 	movwcc	r0, #17664	; 0x4500
     658:	06000000 	streq	r0, [r0], -r0
     65c:	039b0c0d 	orrseq	r0, fp, #3328	; 0xd00
     660:	e5090000 	str	r0, [r9, #-0]
     664:	0000000b 	andeq	r0, r0, fp
     668:	000b4b09 	andeq	r4, fp, r9, lsl #22
     66c:	06000100 	streq	r0, [r0], -r0, lsl #2
     670:	0000061e 	andeq	r0, r0, lr, lsl r6
     674:	081b060c 	ldmdaeq	fp, {r2, r3, r9, sl}
     678:	000003d0 	ldrdeq	r0, [r0], -r0	; <UNPREDICTABLE>
     67c:	0004bc0e 	andeq	fp, r4, lr, lsl #24
     680:	191d0600 	ldmdbne	sp, {r9, sl}
     684:	000003d0 	ldrdeq	r0, [r0], -r0	; <UNPREDICTABLE>
     688:	040b0e00 	streq	r0, [fp], #-3584	; 0xfffff200
     68c:	1e060000 	cdpne	0, 0, cr0, cr6, cr0, {0}
     690:	0003d019 	andeq	sp, r3, r9, lsl r0
     694:	6e0e0400 	cfcpysvs	mvf0, mvf14
     698:	06000007 	streq	r0, [r0], -r7
     69c:	03d6131f 	bicseq	r1, r6, #2080374784	; 0x7c000000
     6a0:	00080000 	andeq	r0, r8, r0
     6a4:	039b040c 	orrseq	r0, fp, #12, 8	; 0xc000000
     6a8:	040c0000 	streq	r0, [ip], #-0
     6ac:	000002a3 	andeq	r0, r0, r3, lsr #5
     6b0:	00098611 	andeq	r8, r9, r1, lsl r6
     6b4:	22061400 	andcs	r1, r6, #0, 8
     6b8:	00069d07 	andeq	r9, r6, r7, lsl #26
     6bc:	08710e00 	ldmdaeq	r1!, {r9, sl, fp}^
     6c0:	26060000 	strcs	r0, [r6], -r0
     6c4:	00004812 	andeq	r4, r0, r2, lsl r8
     6c8:	130e0000 	movwne	r0, #57344	; 0xe000
     6cc:	06000008 	streq	r0, [r0], -r8
     6d0:	03d01d29 	bicseq	r1, r0, #2624	; 0xa40
     6d4:	0e040000 	cdpeq	0, 0, cr0, cr4, cr0, {0}
     6d8:	000005cc 	andeq	r0, r0, ip, asr #11
     6dc:	d01d2c06 	andsle	r2, sp, r6, lsl #24
     6e0:	08000003 	stmdaeq	r0, {r0, r1}
     6e4:	00088512 	andeq	r8, r8, r2, lsl r5
     6e8:	0e2f0600 	cfmadda32eq	mvax0, mvax0, mvfx15, mvfx0
     6ec:	000005fb 	strdeq	r0, [r0], -fp
     6f0:	00000424 	andeq	r0, r0, r4, lsr #8
     6f4:	0000042f 	andeq	r0, r0, pc, lsr #8
     6f8:	0006a213 	andeq	sl, r6, r3, lsl r2
     6fc:	03d01400 	bicseq	r1, r0, #0, 8
     700:	15000000 	strne	r0, [r0, #-0]
     704:	000006d1 	ldrdeq	r0, [r0], -r1
     708:	650e3106 	strvs	r3, [lr, #-262]	; 0xfffffefa
     70c:	de000006 	cdple	0, 0, cr0, cr0, cr6, {0}
     710:	47000001 	strmi	r0, [r0, -r1]
     714:	52000004 	andpl	r0, r0, #4
     718:	13000004 	movwne	r0, #4
     71c:	000006a2 	andeq	r0, r0, r2, lsr #13
     720:	0003d614 	andeq	sp, r3, r4, lsl r6
     724:	dd160000 	ldcle	0, cr0, [r6, #-0]
     728:	0600000a 	streq	r0, [r0], -sl
     72c:	07251d35 			; <UNDEFINED> instruction: 0x07251d35
     730:	03d00000 	bicseq	r0, r0, #0
     734:	6b020000 	blvs	8073c <__bss_end+0x76aa4>
     738:	71000004 	tstvc	r0, r4
     73c:	13000004 	movwne	r0, #4
     740:	000006a2 	andeq	r0, r0, r2, lsr #13
     744:	05b71600 	ldreq	r1, [r7, #1536]!	; 0x600
     748:	37060000 	strcc	r0, [r6, -r0]
     74c:	0008951d 	andeq	r9, r8, sp, lsl r5
     750:	0003d000 	andeq	sp, r3, r0
     754:	048a0200 	streq	r0, [sl], #512	; 0x200
     758:	04900000 	ldreq	r0, [r0], #0
     75c:	a2130000 	andsge	r0, r3, #0
     760:	00000006 	andeq	r0, r0, r6
     764:	00082617 	andeq	r2, r8, r7, lsl r6
     768:	31390600 	teqcc	r9, r0, lsl #12
     76c:	000006bb 			; <UNDEFINED> instruction: 0x000006bb
     770:	8616020c 	ldrhi	r0, [r6], -ip, lsl #4
     774:	06000009 	streq	r0, [r0], -r9
     778:	06e0093c 			; <UNDEFINED> instruction: 0x06e0093c
     77c:	06a20000 	strteq	r0, [r2], r0
     780:	b7010000 	strlt	r0, [r1, -r0]
     784:	bd000004 	stclt	0, cr0, [r0, #-16]
     788:	13000004 	movwne	r0, #4
     78c:	000006a2 	andeq	r0, r0, r2, lsr #13
     790:	0b871600 	bleq	fe1c5f98 <__bss_end+0xfe1bc300>
     794:	3d060000 	stccc	0, cr0, [r6, #-0]
     798:	00041912 	andeq	r1, r4, r2, lsl r9
     79c:	00004800 	andeq	r4, r0, r0, lsl #16
     7a0:	04d60100 	ldrbeq	r0, [r6], #256	; 0x100
     7a4:	04e10000 	strbteq	r0, [r1], #0
     7a8:	a2130000 	andsge	r0, r3, #0
     7ac:	14000006 	strne	r0, [r0], #-6
     7b0:	00000048 	andeq	r0, r0, r8, asr #32
     7b4:	063d1600 	ldrteq	r1, [sp], -r0, lsl #12
     7b8:	3f060000 	svccc	0x00060000
     7bc:	00048612 	andeq	r8, r4, r2, lsl r6
     7c0:	00004800 	andeq	r4, r0, r0, lsl #16
     7c4:	04fa0100 	ldrbteq	r0, [sl], #256	; 0x100
     7c8:	050f0000 	streq	r0, [pc, #-0]	; 7d0 <shift+0x7d0>
     7cc:	a2130000 	andsge	r0, r3, #0
     7d0:	14000006 	strne	r0, [r0], #-6
     7d4:	000006c4 	andeq	r0, r0, r4, asr #13
     7d8:	00005914 	andeq	r5, r0, r4, lsl r9
     7dc:	01de1400 	bicseq	r1, lr, r0, lsl #8
     7e0:	18000000 	stmdane	r0, {}	; <UNPREDICTABLE>
     7e4:	00000651 	andeq	r0, r0, r1, asr r6
     7e8:	730e4106 	movwvc	r4, #57606	; 0xe106
     7ec:	01000007 	tsteq	r0, r7
     7f0:	00000524 	andeq	r0, r0, r4, lsr #10
     7f4:	0000052a 	andeq	r0, r0, sl, lsr #10
     7f8:	0006a213 	andeq	sl, r6, r3, lsl r2
     7fc:	0d180000 	ldceq	0, cr0, [r8, #-0]
     800:	0600000b 	streq	r0, [r0], -fp
     804:	052b0e43 	streq	r0, [fp, #-3651]!	; 0xfffff1bd
     808:	3f010000 	svccc	0x00010000
     80c:	45000005 	strmi	r0, [r0, #-5]
     810:	13000005 	movwne	r0, #5
     814:	000006a2 	andeq	r0, r0, r2, lsr #13
     818:	04681600 	strbteq	r1, [r8], #-1536	; 0xfffffa00
     81c:	46060000 	strmi	r0, [r6], -r0
     820:	0004c117 	andeq	ip, r4, r7, lsl r1
     824:	0003d600 	andeq	sp, r3, r0, lsl #12
     828:	055e0100 	ldrbeq	r0, [lr, #-256]	; 0xffffff00
     82c:	05640000 	strbeq	r0, [r4, #-0]!
     830:	ca130000 	bgt	4c0838 <__bss_end+0x4b6ba0>
     834:	00000006 	andeq	r0, r0, r6
     838:	0009f716 	andeq	pc, r9, r6, lsl r7	; <UNPREDICTABLE>
     83c:	17490600 	strbne	r0, [r9, -r0, lsl #12]
     840:	0000034d 	andeq	r0, r0, sp, asr #6
     844:	000003d6 	ldrdeq	r0, [r0], -r6
     848:	00057d01 	andeq	r7, r5, r1, lsl #26
     84c:	00058800 	andeq	r8, r5, r0, lsl #16
     850:	06ca1300 	strbeq	r1, [sl], r0, lsl #6
     854:	48140000 	ldmdami	r4, {}	; <UNPREDICTABLE>
     858:	00000000 	andeq	r0, r0, r0
     85c:	00055618 	andeq	r5, r5, r8, lsl r6
     860:	0e4c0600 	cdpeq	6, 4, cr0, cr12, cr0, {0}
     864:	00000834 	andeq	r0, r0, r4, lsr r8
     868:	00059d01 	andeq	r9, r5, r1, lsl #26
     86c:	0005a300 	andeq	sl, r5, r0, lsl #6
     870:	06a21300 	strteq	r1, [r2], r0, lsl #6
     874:	16000000 	strne	r0, [r0], -r0
     878:	000006d1 	ldrdeq	r0, [r0], -r1
     87c:	ff0e4e06 			; <UNDEFINED> instruction: 0xff0e4e06
     880:	de000008 	cdple	0, 0, cr0, cr0, cr8, {0}
     884:	01000001 	tsteq	r0, r1
     888:	000005bc 			; <UNDEFINED> instruction: 0x000005bc
     88c:	000005c7 	andeq	r0, r0, r7, asr #11
     890:	0006a213 	andeq	sl, r6, r3, lsl r2
     894:	00481400 	subeq	r1, r8, r0, lsl #8
     898:	16000000 	strne	r0, [r0], -r0
     89c:	000003f0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
     8a0:	7a125106 	bvc	494cc0 <__bss_end+0x48b028>
     8a4:	48000003 	stmdami	r0, {r0, r1}
     8a8:	01000000 	mrseq	r0, (UNDEF: 0)
     8ac:	000005e0 	andeq	r0, r0, r0, ror #11
     8b0:	000005eb 	andeq	r0, r0, fp, ror #11
     8b4:	0006a213 	andeq	sl, r6, r3, lsl r2
     8b8:	01e51400 	mvneq	r1, r0, lsl #8
     8bc:	16000000 	strne	r0, [r0], -r0
     8c0:	000003ad 	andeq	r0, r0, sp, lsr #7
     8c4:	5b0e5406 	blpl	3958e4 <__bss_end+0x38bc4c>
     8c8:	de00000b 	cdple	0, 0, cr0, cr0, cr11, {0}
     8cc:	01000001 	tsteq	r0, r1
     8d0:	00000604 	andeq	r0, r0, r4, lsl #12
     8d4:	0000060f 	andeq	r0, r0, pc, lsl #12
     8d8:	0006a213 	andeq	sl, r6, r3, lsl r2
     8dc:	00481400 	subeq	r1, r8, r0, lsl #8
     8e0:	18000000 	stmdane	r0, {}	; <UNPREDICTABLE>
     8e4:	000003ca 	andeq	r0, r0, sl, asr #7
     8e8:	490e5706 	stmdbmi	lr, {r1, r2, r8, r9, sl, ip, lr}
     8ec:	0100000a 	tsteq	r0, sl
     8f0:	00000624 	andeq	r0, r0, r4, lsr #12
     8f4:	00000643 	andeq	r0, r0, r3, asr #12
     8f8:	0006a213 	andeq	sl, r6, r3, lsl r2
     8fc:	008b1400 	addeq	r1, fp, r0, lsl #8
     900:	48140000 	ldmdami	r4, {}	; <UNPREDICTABLE>
     904:	14000000 	strne	r0, [r0], #-0
     908:	00000048 	andeq	r0, r0, r8, asr #32
     90c:	00004814 	andeq	r4, r0, r4, lsl r8
     910:	06d01400 	ldrbeq	r1, [r0], r0, lsl #8
     914:	18000000 	stmdane	r0, {}	; <UNPREDICTABLE>
     918:	00000b8c 	andeq	r0, r0, ip, lsl #23
     91c:	0c0e5906 			; <UNDEFINED> instruction: 0x0c0e5906
     920:	0100000c 	tsteq	r0, ip
     924:	00000658 	andeq	r0, r0, r8, asr r6
     928:	00000677 	andeq	r0, r0, r7, ror r6
     92c:	0006a213 	andeq	sl, r6, r3, lsl r2
     930:	00ce1400 	sbceq	r1, lr, r0, lsl #8
     934:	48140000 	ldmdami	r4, {}	; <UNPREDICTABLE>
     938:	14000000 	strne	r0, [r0], #-0
     93c:	00000048 	andeq	r0, r0, r8, asr #32
     940:	00004814 	andeq	r4, r0, r4, lsl r8
     944:	06d01400 	ldrbeq	r1, [r0], r0, lsl #8
     948:	19000000 	stmdbne	r0, {}	; <UNPREDICTABLE>
     94c:	000003dd 	ldrdeq	r0, [r0], -sp
     950:	9e0e5c06 	cdpls	12, 0, cr5, cr14, cr6, {0}
     954:	de000007 	cdple	0, 0, cr0, cr0, cr7, {0}
     958:	01000001 	tsteq	r0, r1
     95c:	0000068c 	andeq	r0, r0, ip, lsl #13
     960:	0006a213 	andeq	sl, r6, r3, lsl r2
     964:	037c1400 	cmneq	ip, #0, 8
     968:	d6140000 	ldrle	r0, [r4], -r0
     96c:	00000006 	andeq	r0, r0, r6
     970:	03dc0500 	bicseq	r0, ip, #0, 10
     974:	040c0000 	streq	r0, [ip], #-0
     978:	000003dc 	ldrdeq	r0, [r0], -ip
     97c:	0003d01a 	andeq	sp, r3, sl, lsl r0
     980:	0006b500 	andeq	fp, r6, r0, lsl #10
     984:	0006bb00 	andeq	fp, r6, r0, lsl #22
     988:	06a21300 	strteq	r1, [r2], r0, lsl #6
     98c:	1b000000 	blne	994 <shift+0x994>
     990:	000003dc 	ldrdeq	r0, [r0], -ip
     994:	000006a8 	andeq	r0, r0, r8, lsr #13
     998:	003a040c 	eorseq	r0, sl, ip, lsl #8
     99c:	040c0000 	streq	r0, [ip], #-0
     9a0:	0000069d 	muleq	r0, sp, r6
     9a4:	0065041c 	rsbeq	r0, r5, ip, lsl r4
     9a8:	041d0000 	ldreq	r0, [sp], #-0
     9ac:	6c61681e 	stclvs	8, cr6, [r1], #-120	; 0xffffff88
     9b0:	0b050700 	bleq	1425b8 <__bss_end+0x138920>
     9b4:	000007a2 	andeq	r0, r0, r2, lsr #15
     9b8:	0008001f 	andeq	r0, r8, pc, lsl r0
     9bc:	19070700 	stmdbne	r7, {r8, r9, sl}
     9c0:	00000060 	andeq	r0, r0, r0, rrx
     9c4:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}
     9c8:	000a211f 	andeq	r2, sl, pc, lsl r1
     9cc:	1a0a0700 	bne	2825d4 <__bss_end+0x27893c>
     9d0:	0000029e 	muleq	r0, lr, r2
     9d4:	20000000 	andcs	r0, r0, r0
     9d8:	00047c1f 	andeq	r7, r4, pc, lsl ip
     9dc:	1a0d0700 	bne	3425e4 <__bss_end+0x33894c>
     9e0:	0000029e 	muleq	r0, lr, r2
     9e4:	20200000 	eorcs	r0, r0, r0
     9e8:	00075f20 	andeq	r5, r7, r0, lsr #30
     9ec:	15100700 	ldrne	r0, [r0, #-1792]	; 0xfffff900
     9f0:	00000054 	andeq	r0, r0, r4, asr r0
     9f4:	0ae91f36 	beq	ffa486d4 <__bss_end+0xffa3ea3c>
     9f8:	42070000 	andmi	r0, r7, #0
     9fc:	00029e1a 	andeq	r9, r2, sl, lsl lr
     a00:	21500000 	cmpcs	r0, r0
     a04:	0bc01f20 	bleq	ff00868c <__bss_end+0xfeffe9f4>
     a08:	71070000 	mrsvc	r0, (UNDEF: 7)
     a0c:	00029e1a 	andeq	r9, r2, sl, lsl lr
     a10:	00b20000 	adcseq	r0, r2, r0
     a14:	06c61f20 	strbeq	r1, [r6], r0, lsr #30
     a18:	a4070000 	strge	r0, [r7], #-0
     a1c:	00029e1a 	andeq	r9, r2, sl, lsl lr
     a20:	00b40000 	adcseq	r0, r4, r0
     a24:	06bf1f20 	ldrteq	r1, [pc], r0, lsr #30
     a28:	b2070000 	andlt	r0, r7, #0
     a2c:	00029e1d 	andeq	r9, r2, sp, lsl lr
     a30:	00300000 	eorseq	r0, r0, r0
     a34:	07f61f20 	ldrbeq	r1, [r6, r0, lsr #30]!
     a38:	c0070000 	andgt	r0, r7, r0
     a3c:	00029e1d 	andeq	r9, r2, sp, lsl lr
     a40:	10400000 	subne	r0, r0, r0
     a44:	08bb1f20 	ldmeq	fp!, {r5, r8, r9, sl, fp, ip}
     a48:	cb070000 	blgt	1c0a50 <__bss_end+0x1b6db8>
     a4c:	00029e1a 	andeq	r9, r2, sl, lsl lr
     a50:	20500000 	subscs	r0, r0, r0
     a54:	059c1f20 	ldreq	r1, [ip, #3872]	; 0xf20
     a58:	cc070000 	stcgt	0, cr0, [r7], {-0}
     a5c:	00029e1a 	andeq	r9, r2, sl, lsl lr
     a60:	80400000 	subhi	r0, r0, r0
     a64:	0af21f20 	beq	ffc886ec <__bss_end+0xffc7ea54>
     a68:	cd070000 	stcgt	0, cr0, [r7, #-0]
     a6c:	00029e1a 	andeq	r9, r2, sl, lsl lr
     a70:	80500000 	subshi	r0, r0, r0
     a74:	e4210020 	strt	r0, [r1], #-32	; 0xffffffe0
     a78:	21000006 	tstcs	r0, r6
     a7c:	000006f4 	strdeq	r0, [r0], -r4
     a80:	00070421 	andeq	r0, r7, r1, lsr #8
     a84:	07142100 	ldreq	r2, [r4, -r0, lsl #2]
     a88:	21210000 			; <UNDEFINED> instruction: 0x21210000
     a8c:	21000007 	tstcs	r0, r7
     a90:	00000731 	andeq	r0, r0, r1, lsr r7
     a94:	00074121 	andeq	r4, r7, r1, lsr #2
     a98:	07512100 	ldrbeq	r2, [r1, -r0, lsl #2]
     a9c:	61210000 			; <UNDEFINED> instruction: 0x61210000
     aa0:	21000007 	tstcs	r0, r7
     aa4:	00000771 	andeq	r0, r0, r1, ror r7
     aa8:	00078121 	andeq	r8, r7, r1, lsr #2
     aac:	07912100 	ldreq	r2, [r1, r0, lsl #2]
     ab0:	310a0000 	mrscc	r0, (UNDEF: 10)
     ab4:	0800000a 	stmdaeq	r0, {r1, r3}
     ab8:	00541408 	subseq	r1, r4, r8, lsl #8
     abc:	03050000 	movweq	r0, #20480	; 0x5000
     ac0:	00009bf4 	strdeq	r9, [r0], -r4
     ac4:	0007e108 	andeq	lr, r7, r8, lsl #2
     ac8:	33040500 	movwcc	r0, #17664	; 0x4500
     acc:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
     ad0:	081b0c1d 	ldmdaeq	fp, {r0, r2, r3, r4, sl, fp}
     ad4:	c5090000 	strgt	r0, [r9, #-0]
     ad8:	00000008 	andeq	r0, r0, r8
     adc:	0008f209 	andeq	pc, r8, r9, lsl #4
     ae0:	d6090100 	strle	r0, [r9], -r0, lsl #2
     ae4:	02000008 	andeq	r0, r0, #8
     ae8:	776f4c0d 	strbvc	r4, [pc, -sp, lsl #24]!
     aec:	0a000300 	beq	16f4 <shift+0x16f4>
     af0:	00000bfa 	strdeq	r0, [r0], -sl
     af4:	54141001 	ldrpl	r1, [r4], #-1
     af8:	05000000 	streq	r0, [r0, #-0]
     afc:	009bf803 	addseq	pc, fp, r3, lsl #16
     b00:	05df0a00 	ldrbeq	r0, [pc, #2560]	; 1508 <shift+0x1508>
     b04:	11010000 	mrsne	r0, (UNDEF: 1)
     b08:	00005414 	andeq	r5, r0, r4, lsl r4
     b0c:	fc030500 	stc2	5, cr0, [r3], {-0}
     b10:	2200009b 	andcs	r0, r0, #155	; 0x9b
     b14:	00000436 	andeq	r0, r0, r6, lsr r4
     b18:	480a1301 	stmdami	sl, {r0, r8, r9, ip}
     b1c:	05000000 	streq	r0, [r0, #-0]
     b20:	009c8003 	addseq	r8, ip, r3
     b24:	065e2200 	ldrbeq	r2, [lr], -r0, lsl #4
     b28:	14010000 	strne	r0, [r1], #-0
     b2c:	0000480a 	andeq	r4, r0, sl, lsl #16
     b30:	84030500 	strhi	r0, [r3], #-1280	; 0xfffffb00
     b34:	2300009c 	movwcs	r0, #156	; 0x9c
     b38:	00001582 	andeq	r1, r0, r2, lsl #11
     b3c:	33051d01 	movwcc	r1, #23809	; 0x5d01
     b40:	ac000000 	stcge	0, cr0, [r0], {-0}
     b44:	6c000082 	stcvs	0, cr0, [r0], {130}	; 0x82
     b48:	01000001 	tsteq	r0, r1
     b4c:	0008ba9c 	muleq	r8, ip, sl
     b50:	08d12400 	ldmeq	r1, {sl, sp}^
     b54:	1d010000 	stcne	0, cr0, [r1, #-0]
     b58:	0000330e 	andeq	r3, r0, lr, lsl #6
     b5c:	6c910200 	lfmvs	f0, 4, [r1], {0}
     b60:	0008ed24 	andeq	lr, r8, r4, lsr #26
     b64:	1b1d0100 	blne	740f6c <__bss_end+0x7372d4>
     b68:	000008ba 			; <UNDEFINED> instruction: 0x000008ba
     b6c:	25689102 	strbcs	r9, [r8, #-258]!	; 0xfffffefe
     b70:	0000096d 	andeq	r0, r0, sp, ror #18
     b74:	f0172201 			; <UNDEFINED> instruction: 0xf0172201
     b78:	02000007 	andeq	r0, r0, #7
     b7c:	3a257091 	bcc	95cdc8 <__bss_end+0x953130>
     b80:	01000009 	tsteq	r0, r9
     b84:	00480b25 	subeq	r0, r8, r5, lsr #22
     b88:	91020000 	mrsls	r0, (UNDEF: 2)
     b8c:	040c0074 	streq	r0, [ip], #-116	; 0xffffff8c
     b90:	000008c0 	andeq	r0, r0, r0, asr #17
     b94:	0025040c 	eoreq	r0, r5, ip, lsl #8
     b98:	ff260000 			; <UNDEFINED> instruction: 0xff260000
     b9c:	01000004 	tsteq	r0, r4
     ba0:	087b0616 	ldmdaeq	fp!, {r1, r2, r4, r9, sl}^
     ba4:	822c0000 	eorhi	r0, ip, #0
     ba8:	00800000 	addeq	r0, r0, r0
     bac:	9c010000 	stcls	0, cr0, [r1], {-0}
     bb0:	0004f924 	andeq	pc, r4, r4, lsr #18
     bb4:	11160100 	tstne	r6, r0, lsl #2
     bb8:	000001de 	ldrdeq	r0, [r0], -lr
     bbc:	00779102 	rsbseq	r9, r7, r2, lsl #2
     bc0:	000b9100 	andeq	r9, fp, r0, lsl #2
     bc4:	33000400 	movwcc	r0, #1024	; 0x400
     bc8:	04000004 	streq	r0, [r0], #-4
     bcc:	000d6c01 	andeq	r6, sp, r1, lsl #24
     bd0:	0f050400 	svceq	0x00050400
     bd4:	0e960000 	cdpeq	0, 9, cr0, cr6, cr0, {0}
     bd8:	84180000 	ldrhi	r0, [r8], #-0
     bdc:	045c0000 	ldrbeq	r0, [ip], #-0
     be0:	04380000 	ldrteq	r0, [r8], #-0
     be4:	01020000 	mrseq	r0, (UNDEF: 2)
     be8:	000abd08 	andeq	fp, sl, r8, lsl #26
     bec:	00250300 	eoreq	r0, r5, r0, lsl #6
     bf0:	02020000 	andeq	r0, r2, #0
     bf4:	00096305 	andeq	r6, r9, r5, lsl #6
     bf8:	05040400 	streq	r0, [r4, #-1024]	; 0xfffffc00
     bfc:	00746e69 	rsbseq	r6, r4, r9, ror #28
     c00:	b4080102 	strlt	r0, [r8], #-258	; 0xfffffefe
     c04:	0200000a 	andeq	r0, r0, #10
     c08:	0ba20702 	bleq	fe882818 <__bss_end+0xfe878b80>
     c0c:	74050000 	strvc	r0, [r5], #-0
     c10:	07000005 	streq	r0, [r0, -r5]
     c14:	005e0709 	subseq	r0, lr, r9, lsl #14
     c18:	4d030000 	stcmi	0, cr0, [r3, #-0]
     c1c:	02000000 	andeq	r0, r0, #0
     c20:	15ee0704 	strbne	r0, [lr, #1796]!	; 0x704
     c24:	58060000 	stmdapl	r6, {}	; <UNPREDICTABLE>
     c28:	0800000c 	stmdaeq	r0, {r2, r3}
     c2c:	8b080602 	blhi	20243c <__bss_end+0x1f87a4>
     c30:	07000000 	streq	r0, [r0, -r0]
     c34:	02003072 	andeq	r3, r0, #114	; 0x72
     c38:	004d0e08 	subeq	r0, sp, r8, lsl #28
     c3c:	07000000 	streq	r0, [r0, -r0]
     c40:	02003172 	andeq	r3, r0, #-2147483620	; 0x8000001c
     c44:	004d0e09 	subeq	r0, sp, r9, lsl #28
     c48:	00040000 	andeq	r0, r4, r0
     c4c:	000f3508 	andeq	r3, pc, r8, lsl #10
     c50:	38040500 	stmdacc	r4, {r8, sl}
     c54:	02000000 	andeq	r0, r0, #0
     c58:	00a90c0d 	adceq	r0, r9, sp, lsl #24
     c5c:	4f090000 	svcmi	0x00090000
     c60:	0a00004b 	beq	d94 <shift+0xd94>
     c64:	00000cc2 	andeq	r0, r0, r2, asr #25
     c68:	c4080001 	strgt	r0, [r8], #-1
     c6c:	05000009 	streq	r0, [r0, #-9]
     c70:	00003804 	andeq	r3, r0, r4, lsl #16
     c74:	0c1e0200 	lfmeq	f0, 4, [lr], {-0}
     c78:	000000ec 	andeq	r0, r0, ip, ror #1
     c7c:	00056c0a 	andeq	r6, r5, sl, lsl #24
     c80:	b50a0000 	strlt	r0, [sl, #-0]
     c84:	01000006 	tsteq	r0, r6
     c88:	0009e60a 	andeq	lr, r9, sl, lsl #12
     c8c:	d70a0200 	strle	r0, [sl, -r0, lsl #4]
     c90:	0300000a 	movweq	r0, #10
     c94:	00069b0a 	andeq	r9, r6, sl, lsl #22
     c98:	420a0400 	andmi	r0, sl, #0, 8
     c9c:	05000009 	streq	r0, [r0, #-9]
     ca0:	000ac20a 	andeq	ip, sl, sl, lsl #4
     ca4:	560a0600 	strpl	r0, [sl], -r0, lsl #12
     ca8:	0700000b 	streq	r0, [r0, -fp]
     cac:	09ac0800 	stmibeq	ip!, {fp}
     cb0:	04050000 	streq	r0, [r5], #-0
     cb4:	00000038 	andeq	r0, r0, r8, lsr r0
     cb8:	290c4902 	stmdbcs	ip, {r1, r8, fp, lr}
     cbc:	0a000001 	beq	cc8 <shift+0xcc8>
     cc0:	0000064c 	andeq	r0, r0, ip, asr #12
     cc4:	06b00a00 	ldrteq	r0, [r0], r0, lsl #20
     cc8:	0a010000 	beq	40cd0 <__bss_end+0x37038>
     ccc:	00000bdf 	ldrdeq	r0, [r0], -pc	; <UNPREDICTABLE>
     cd0:	088f0a02 	stmeq	pc, {r1, r9, fp}	; <UNPREDICTABLE>
     cd4:	0a030000 	beq	c0cdc <__bss_end+0xb7044>
     cd8:	000006aa 	andeq	r0, r0, sl, lsr #13
     cdc:	06fa0a04 	ldrbteq	r0, [sl], r4, lsl #20
     ce0:	0a050000 	beq	140ce8 <__bss_end+0x137050>
     ce4:	000005a6 	andeq	r0, r0, r6, lsr #11
     ce8:	8b080006 	blhi	200d08 <__bss_end+0x1f7070>
     cec:	05000005 	streq	r0, [r0, #-5]
     cf0:	00003804 	andeq	r3, r0, r4, lsl #16
     cf4:	0c700200 	lfmeq	f0, 2, [r0], #-0
     cf8:	00000154 	andeq	r0, r0, r4, asr r1
     cfc:	000aa90a 	andeq	sl, sl, sl, lsl #18
     d00:	b10a0000 	mrslt	r0, (UNDEF: 10)
     d04:	01000004 	tsteq	r0, r4
     d08:	000a0a0a 	andeq	r0, sl, sl, lsl #20
     d0c:	4b0a0200 	blmi	281514 <__bss_end+0x27787c>
     d10:	03000009 	movweq	r0, #9
     d14:	08630b00 	stmdaeq	r3!, {r8, r9, fp}^
     d18:	05030000 	streq	r0, [r3, #-0]
     d1c:	00005914 	andeq	r5, r0, r4, lsl r9
     d20:	2c030500 	cfstr32cs	mvfx0, [r3], {-0}
     d24:	0b00009c 	bleq	f9c <shift+0xf9c>
     d28:	00000a3d 	andeq	r0, r0, sp, lsr sl
     d2c:	59140603 	ldmdbpl	r4, {r0, r1, r9, sl}
     d30:	05000000 	streq	r0, [r0, #-0]
     d34:	009c3003 	addseq	r3, ip, r3
     d38:	070f0b00 	streq	r0, [pc, -r0, lsl #22]
     d3c:	07040000 	streq	r0, [r4, -r0]
     d40:	0000591a 	andeq	r5, r0, sl, lsl r9
     d44:	34030500 	strcc	r0, [r3], #-1280	; 0xfffffb00
     d48:	0b00009c 	bleq	fc0 <shift+0xfc0>
     d4c:	00000974 	andeq	r0, r0, r4, ror r9
     d50:	591a0904 	ldmdbpl	sl, {r2, r8, fp}
     d54:	05000000 	streq	r0, [r0, #-0]
     d58:	009c3803 	addseq	r3, ip, r3, lsl #16
     d5c:	07010b00 	streq	r0, [r1, -r0, lsl #22]
     d60:	0b040000 	bleq	100d68 <__bss_end+0xf70d0>
     d64:	0000591a 	andeq	r5, r0, sl, lsl r9
     d68:	3c030500 	cfstr32cc	mvfx0, [r3], {-0}
     d6c:	0b00009c 	bleq	fe4 <shift+0xfe4>
     d70:	00000927 	andeq	r0, r0, r7, lsr #18
     d74:	591a0d04 	ldmdbpl	sl, {r2, r8, sl, fp}
     d78:	05000000 	streq	r0, [r0, #-0]
     d7c:	009c4003 	addseq	r4, ip, r3
     d80:	054c0b00 	strbeq	r0, [ip, #-2816]	; 0xfffff500
     d84:	0f040000 	svceq	0x00040000
     d88:	0000591a 	andeq	r5, r0, sl, lsl r9
     d8c:	44030500 	strmi	r0, [r3], #-1280	; 0xfffffb00
     d90:	0800009c 	stmdaeq	r0, {r2, r3, r4, r7}
     d94:	00000fed 	andeq	r0, r0, sp, ror #31
     d98:	00380405 	eorseq	r0, r8, r5, lsl #8
     d9c:	1b040000 	blne	100da4 <__bss_end+0xf710c>
     da0:	0001f70c 	andeq	pc, r1, ip, lsl #14
     da4:	04ef0a00 	strbteq	r0, [pc], #2560	; dac <shift+0xdac>
     da8:	0a000000 	beq	db0 <shift+0xdb0>
     dac:	00000b02 	andeq	r0, r0, r2, lsl #22
     db0:	0bda0a01 	bleq	ff6835bc <__bss_end+0xff679924>
     db4:	00020000 	andeq	r0, r2, r0
     db8:	0003a70c 	andeq	sl, r3, ip, lsl #14
     dbc:	02010200 	andeq	r0, r1, #0, 4
     dc0:	00000799 	muleq	r0, r9, r7
     dc4:	002c040d 	eoreq	r0, ip, sp, lsl #8
     dc8:	040d0000 	streq	r0, [sp], #-0
     dcc:	000001f7 	strdeq	r0, [r0], -r7
     dd0:	0005050b 	andeq	r0, r5, fp, lsl #10
     dd4:	14040500 	strne	r0, [r4], #-1280	; 0xfffffb00
     dd8:	00000059 	andeq	r0, r0, r9, asr r0
     ddc:	9c480305 	mcrrls	3, 0, r0, r8, cr5
     de0:	ec0b0000 	stc	0, cr0, [fp], {-0}
     de4:	05000009 	streq	r0, [r0, #-9]
     de8:	00591407 	subseq	r1, r9, r7, lsl #8
     dec:	03050000 	movweq	r0, #20480	; 0x5000
     df0:	00009c4c 	andeq	r9, r0, ip, asr #24
     df4:	0004550b 	andeq	r5, r4, fp, lsl #10
     df8:	140a0500 	strne	r0, [sl], #-1280	; 0xfffffb00
     dfc:	00000059 	andeq	r0, r0, r9, asr r0
     e00:	9c500305 	mrrcls	3, 0, r0, r0, cr5	; <UNPREDICTABLE>
     e04:	ab080000 	blge	200e0c <__bss_end+0x1f7174>
     e08:	05000005 	streq	r0, [r0, #-5]
     e0c:	00003804 	andeq	r3, r0, r4, lsl #16
     e10:	0c0d0500 	cfstr32eq	mvfx0, [sp], {-0}
     e14:	0000027c 	andeq	r0, r0, ip, ror r2
     e18:	77654e09 	strbvc	r4, [r5, -r9, lsl #28]!
     e1c:	100a0000 	andne	r0, sl, r0
     e20:	01000004 	tsteq	r0, r4
     e24:	00044d0a 	andeq	r4, r4, sl, lsl #26
     e28:	c40a0200 	strgt	r0, [sl], #-512	; 0xfffffe00
     e2c:	03000005 	movweq	r0, #5
     e30:	000ac90a 	andeq	ip, sl, sl, lsl #18
     e34:	040a0400 	streq	r0, [sl], #-1024	; 0xfffffc00
     e38:	05000004 	streq	r0, [r0, #-4]
     e3c:	051e0600 	ldreq	r0, [lr, #-1536]	; 0xfffffa00
     e40:	05100000 	ldreq	r0, [r0, #-0]
     e44:	02bb081b 	adcseq	r0, fp, #1769472	; 0x1b0000
     e48:	6c070000 	stcvs	0, cr0, [r7], {-0}
     e4c:	1d050072 	stcne	0, cr0, [r5, #-456]	; 0xfffffe38
     e50:	0002bb13 	andeq	fp, r2, r3, lsl fp
     e54:	73070000 	movwvc	r0, #28672	; 0x7000
     e58:	1e050070 	mcrne	0, 0, r0, cr5, cr0, {3}
     e5c:	0002bb13 	andeq	fp, r2, r3, lsl fp
     e60:	70070400 	andvc	r0, r7, r0, lsl #8
     e64:	1f050063 	svcne	0x00050063
     e68:	0002bb13 	andeq	fp, r2, r3, lsl fp
     e6c:	a60e0800 	strge	r0, [lr], -r0, lsl #16
     e70:	05000009 	streq	r0, [r0, #-9]
     e74:	02bb1320 	adcseq	r1, fp, #32, 6	; 0x80000000
     e78:	000c0000 	andeq	r0, ip, r0
     e7c:	e9070402 	stmdb	r7, {r1, sl}
     e80:	06000015 			; <UNDEFINED> instruction: 0x06000015
     e84:	0000068e 	andeq	r0, r0, lr, lsl #13
     e88:	0828057c 	stmdaeq	r8!, {r2, r3, r4, r5, r6, r8, sl}
     e8c:	00000379 	andeq	r0, r0, r9, ror r3
     e90:	0006310e 	andeq	r3, r6, lr, lsl #2
     e94:	122a0500 	eorne	r0, sl, #0, 10
     e98:	0000027c 	andeq	r0, r0, ip, ror r2
     e9c:	69700700 	ldmdbvs	r0!, {r8, r9, sl}^
     ea0:	2b050064 	blcs	141038 <__bss_end+0x1373a0>
     ea4:	00005e12 	andeq	r5, r0, r2, lsl lr
     ea8:	fc0e1000 	stc2	0, cr1, [lr], {-0}
     eac:	0500000a 	streq	r0, [r0, #-10]
     eb0:	0245112c 	subeq	r1, r5, #44, 2
     eb4:	0e140000 	cdpeq	0, 1, cr0, cr4, cr0, {0}
     eb8:	00000a9b 	muleq	r0, fp, sl
     ebc:	5e122d05 	cdppl	13, 1, cr2, cr2, cr5, {0}
     ec0:	18000000 	stmdane	r0, {}	; <UNPREDICTABLE>
     ec4:	0003370e 	andeq	r3, r3, lr, lsl #14
     ec8:	122e0500 	eorne	r0, lr, #0, 10
     ecc:	0000005e 	andeq	r0, r0, lr, asr r0
     ed0:	09d90e1c 	ldmibeq	r9, {r2, r3, r4, r9, sl, fp}^
     ed4:	2f050000 	svccs	0x00050000
     ed8:	0003790c 	andeq	r7, r3, ip, lsl #18
     edc:	c00e2000 	andgt	r2, lr, r0
     ee0:	05000003 	streq	r0, [r0, #-3]
     ee4:	00380930 	eorseq	r0, r8, r0, lsr r9
     ee8:	0e600000 	cdpeq	0, 6, cr0, cr0, cr0, {0}
     eec:	000005ef 	andeq	r0, r0, pc, ror #11
     ef0:	4d0e3105 	stfmis	f3, [lr, #-20]	; 0xffffffec
     ef4:	64000000 	strvs	r0, [r0], #-0
     ef8:	0008e40e 	andeq	lr, r8, lr, lsl #8
     efc:	0e330500 	cfabs32eq	mvfx0, mvfx3
     f00:	0000004d 	andeq	r0, r0, sp, asr #32
     f04:	08db0e68 	ldmeq	fp, {r3, r5, r6, r9, sl, fp}^
     f08:	34050000 	strcc	r0, [r5], #-0
     f0c:	00004d0e 	andeq	r4, r0, lr, lsl #26
     f10:	7d0e6c00 	stcvc	12, cr6, [lr, #-0]
     f14:	05000005 	streq	r0, [r0, #-5]
     f18:	004d0e35 	subeq	r0, sp, r5, lsr lr
     f1c:	0e700000 	cdpeq	0, 7, cr0, cr0, cr0, {0}
     f20:	00000997 	muleq	r0, r7, r9
     f24:	4d0e3605 	stcmi	6, cr3, [lr, #-20]	; 0xffffffec
     f28:	74000000 	strvc	r0, [r0], #-0
     f2c:	000bb50e 	andeq	fp, fp, lr, lsl #10
     f30:	0e370500 	cfabs32eq	mvfx0, mvfx7
     f34:	0000004d 	andeq	r0, r0, sp, asr #32
     f38:	090f0078 	stmdbeq	pc, {r3, r4, r5, r6}	; <UNPREDICTABLE>
     f3c:	89000002 	stmdbhi	r0, {r1}
     f40:	10000003 	andne	r0, r0, r3
     f44:	0000005e 	andeq	r0, r0, lr, asr r0
     f48:	3e0b000f 	cdpcc	0, 0, cr0, cr11, cr15, {0}
     f4c:	06000004 	streq	r0, [r0], -r4
     f50:	0059140a 	subseq	r1, r9, sl, lsl #8
     f54:	03050000 	movweq	r0, #20480	; 0x5000
     f58:	00009c54 	andeq	r9, r0, r4, asr ip
     f5c:	00074a08 	andeq	r4, r7, r8, lsl #20
     f60:	38040500 	stmdacc	r4, {r8, sl}
     f64:	06000000 	streq	r0, [r0], -r0
     f68:	03ba0c0d 			; <UNDEFINED> instruction: 0x03ba0c0d
     f6c:	e50a0000 	str	r0, [sl, #-0]
     f70:	0000000b 	andeq	r0, r0, fp
     f74:	000b4b0a 	andeq	r4, fp, sl, lsl #22
     f78:	03000100 	movweq	r0, #256	; 0x100
     f7c:	0000039b 	muleq	r0, fp, r3
     f80:	000e3a08 	andeq	r3, lr, r8, lsl #20
     f84:	38040500 	stmdacc	r4, {r8, sl}
     f88:	06000000 	streq	r0, [r0], -r0
     f8c:	03de0c14 	bicseq	r0, lr, #20, 24	; 0x1400
     f90:	6a0a0000 	bvs	280f98 <__bss_end+0x277300>
     f94:	0000000c 	andeq	r0, r0, ip
     f98:	000ed70a 	andeq	sp, lr, sl, lsl #14
     f9c:	03000100 	movweq	r0, #256	; 0x100
     fa0:	000003bf 			; <UNDEFINED> instruction: 0x000003bf
     fa4:	00061e06 	andeq	r1, r6, r6, lsl #28
     fa8:	1b060c00 	blne	183fb0 <__bss_end+0x17a318>
     fac:	00041808 	andeq	r1, r4, r8, lsl #16
     fb0:	04bc0e00 	ldrteq	r0, [ip], #3584	; 0xe00
     fb4:	1d060000 	stcne	0, cr0, [r6, #-0]
     fb8:	00041819 	andeq	r1, r4, r9, lsl r8
     fbc:	0b0e0000 	bleq	380fc4 <__bss_end+0x37732c>
     fc0:	06000004 	streq	r0, [r0], -r4
     fc4:	0418191e 	ldreq	r1, [r8], #-2334	; 0xfffff6e2
     fc8:	0e040000 	cdpeq	0, 0, cr0, cr4, cr0, {0}
     fcc:	0000076e 	andeq	r0, r0, lr, ror #14
     fd0:	1e131f06 	cdpne	15, 1, cr1, cr3, cr6, {0}
     fd4:	08000004 	stmdaeq	r0, {r2}
     fd8:	e3040d00 	movw	r0, #19712	; 0x4d00
     fdc:	0d000003 	stceq	0, cr0, [r0, #-12]
     fe0:	0002c204 	andeq	ip, r2, r4, lsl #4
     fe4:	09861100 	stmibeq	r6, {r8, ip}
     fe8:	06140000 	ldreq	r0, [r4], -r0
     fec:	06e50722 	strbteq	r0, [r5], r2, lsr #14
     ff0:	710e0000 	mrsvc	r0, (UNDEF: 14)
     ff4:	06000008 	streq	r0, [r0], -r8
     ff8:	004d1226 	subeq	r1, sp, r6, lsr #4
     ffc:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    1000:	00000813 	andeq	r0, r0, r3, lsl r8
    1004:	181d2906 	ldmdane	sp, {r1, r2, r8, fp, sp}
    1008:	04000004 	streq	r0, [r0], #-4
    100c:	0005cc0e 	andeq	ip, r5, lr, lsl #24
    1010:	1d2c0600 	stcne	6, cr0, [ip, #-0]
    1014:	00000418 	andeq	r0, r0, r8, lsl r4
    1018:	08851208 	stmeq	r5, {r3, r9, ip}
    101c:	2f060000 	svccs	0x00060000
    1020:	0005fb0e 	andeq	pc, r5, lr, lsl #22
    1024:	00046c00 	andeq	r6, r4, r0, lsl #24
    1028:	00047700 	andeq	r7, r4, r0, lsl #14
    102c:	06ea1300 	strbteq	r1, [sl], r0, lsl #6
    1030:	18140000 	ldmdane	r4, {}	; <UNPREDICTABLE>
    1034:	00000004 	andeq	r0, r0, r4
    1038:	0006d115 	andeq	sp, r6, r5, lsl r1
    103c:	0e310600 	cfmsuba32eq	mvax0, mvax0, mvfx1, mvfx0
    1040:	00000665 	andeq	r0, r0, r5, ror #12
    1044:	000001fc 	strdeq	r0, [r0], -ip
    1048:	0000048f 	andeq	r0, r0, pc, lsl #9
    104c:	0000049a 	muleq	r0, sl, r4
    1050:	0006ea13 	andeq	lr, r6, r3, lsl sl
    1054:	041e1400 	ldreq	r1, [lr], #-1024	; 0xfffffc00
    1058:	16000000 	strne	r0, [r0], -r0
    105c:	00000add 	ldrdeq	r0, [r0], -sp
    1060:	251d3506 	ldrcs	r3, [sp, #-1286]	; 0xfffffafa
    1064:	18000007 	stmdane	r0, {r0, r1, r2}
    1068:	02000004 	andeq	r0, r0, #4
    106c:	000004b3 			; <UNDEFINED> instruction: 0x000004b3
    1070:	000004b9 			; <UNDEFINED> instruction: 0x000004b9
    1074:	0006ea13 	andeq	lr, r6, r3, lsl sl
    1078:	b7160000 	ldrlt	r0, [r6, -r0]
    107c:	06000005 	streq	r0, [r0], -r5
    1080:	08951d37 	ldmeq	r5, {r0, r1, r2, r4, r5, r8, sl, fp, ip}
    1084:	04180000 	ldreq	r0, [r8], #-0
    1088:	d2020000 	andle	r0, r2, #0
    108c:	d8000004 	stmdale	r0, {r2}
    1090:	13000004 	movwne	r0, #4
    1094:	000006ea 	andeq	r0, r0, sl, ror #13
    1098:	08261700 	stmdaeq	r6!, {r8, r9, sl, ip}
    109c:	39060000 	stmdbcc	r6, {}	; <UNPREDICTABLE>
    10a0:	00070331 	andeq	r0, r7, r1, lsr r3
    10a4:	16020c00 	strne	r0, [r2], -r0, lsl #24
    10a8:	00000986 	andeq	r0, r0, r6, lsl #19
    10ac:	e0093c06 	and	r3, r9, r6, lsl #24
    10b0:	ea000006 	b	10d0 <shift+0x10d0>
    10b4:	01000006 	tsteq	r0, r6
    10b8:	000004ff 	strdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    10bc:	00000505 	andeq	r0, r0, r5, lsl #10
    10c0:	0006ea13 	andeq	lr, r6, r3, lsl sl
    10c4:	87160000 	ldrhi	r0, [r6, -r0]
    10c8:	0600000b 	streq	r0, [r0], -fp
    10cc:	0419123d 	ldreq	r1, [r9], #-573	; 0xfffffdc3
    10d0:	004d0000 	subeq	r0, sp, r0
    10d4:	1e010000 	cdpne	0, 0, cr0, cr1, cr0, {0}
    10d8:	29000005 	stmdbcs	r0, {r0, r2}
    10dc:	13000005 	movwne	r0, #5
    10e0:	000006ea 	andeq	r0, r0, sl, ror #13
    10e4:	00004d14 	andeq	r4, r0, r4, lsl sp
    10e8:	3d160000 	ldccc	0, cr0, [r6, #-0]
    10ec:	06000006 	streq	r0, [r0], -r6
    10f0:	0486123f 	streq	r1, [r6], #575	; 0x23f
    10f4:	004d0000 	subeq	r0, sp, r0
    10f8:	42010000 	andmi	r0, r1, #0
    10fc:	57000005 	strpl	r0, [r0, -r5]
    1100:	13000005 	movwne	r0, #5
    1104:	000006ea 	andeq	r0, r0, sl, ror #13
    1108:	00070c14 	andeq	r0, r7, r4, lsl ip
    110c:	005e1400 	subseq	r1, lr, r0, lsl #8
    1110:	fc140000 	ldc2	0, cr0, [r4], {-0}
    1114:	00000001 	andeq	r0, r0, r1
    1118:	00065118 	andeq	r5, r6, r8, lsl r1
    111c:	0e410600 	cdpeq	6, 4, cr0, cr1, cr0, {0}
    1120:	00000773 	andeq	r0, r0, r3, ror r7
    1124:	00056c01 	andeq	r6, r5, r1, lsl #24
    1128:	00057200 	andeq	r7, r5, r0, lsl #4
    112c:	06ea1300 	strbteq	r1, [sl], r0, lsl #6
    1130:	18000000 	stmdane	r0, {}	; <UNPREDICTABLE>
    1134:	00000b0d 	andeq	r0, r0, sp, lsl #22
    1138:	2b0e4306 	blcs	391d58 <__bss_end+0x3880c0>
    113c:	01000005 	tsteq	r0, r5
    1140:	00000587 	andeq	r0, r0, r7, lsl #11
    1144:	0000058d 	andeq	r0, r0, sp, lsl #11
    1148:	0006ea13 	andeq	lr, r6, r3, lsl sl
    114c:	68160000 	ldmdavs	r6, {}	; <UNPREDICTABLE>
    1150:	06000004 	streq	r0, [r0], -r4
    1154:	04c11746 	strbeq	r1, [r1], #1862	; 0x746
    1158:	041e0000 	ldreq	r0, [lr], #-0
    115c:	a6010000 	strge	r0, [r1], -r0
    1160:	ac000005 	stcge	0, cr0, [r0], {5}
    1164:	13000005 	movwne	r0, #5
    1168:	00000712 	andeq	r0, r0, r2, lsl r7
    116c:	09f71600 	ldmibeq	r7!, {r9, sl, ip}^
    1170:	49060000 	stmdbmi	r6, {}	; <UNPREDICTABLE>
    1174:	00034d17 	andeq	r4, r3, r7, lsl sp
    1178:	00041e00 	andeq	r1, r4, r0, lsl #28
    117c:	05c50100 	strbeq	r0, [r5, #256]	; 0x100
    1180:	05d00000 	ldrbeq	r0, [r0]
    1184:	12130000 	andsne	r0, r3, #0
    1188:	14000007 	strne	r0, [r0], #-7
    118c:	0000004d 	andeq	r0, r0, sp, asr #32
    1190:	05561800 	ldrbeq	r1, [r6, #-2048]	; 0xfffff800
    1194:	4c060000 	stcmi	0, cr0, [r6], {-0}
    1198:	0008340e 	andeq	r3, r8, lr, lsl #8
    119c:	05e50100 	strbeq	r0, [r5, #256]!	; 0x100
    11a0:	05eb0000 	strbeq	r0, [fp, #0]!
    11a4:	ea130000 	b	4c11ac <__bss_end+0x4b7514>
    11a8:	00000006 	andeq	r0, r0, r6
    11ac:	0006d116 	andeq	sp, r6, r6, lsl r1
    11b0:	0e4e0600 	cdpeq	6, 4, cr0, cr14, cr0, {0}
    11b4:	000008ff 	strdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    11b8:	000001fc 	strdeq	r0, [r0], -ip
    11bc:	00060401 	andeq	r0, r6, r1, lsl #8
    11c0:	00060f00 	andeq	r0, r6, r0, lsl #30
    11c4:	06ea1300 	strbteq	r1, [sl], r0, lsl #6
    11c8:	4d140000 	ldcmi	0, cr0, [r4, #-0]
    11cc:	00000000 	andeq	r0, r0, r0
    11d0:	0003f016 	andeq	pc, r3, r6, lsl r0	; <UNPREDICTABLE>
    11d4:	12510600 	subsne	r0, r1, #0, 12
    11d8:	0000037a 	andeq	r0, r0, sl, ror r3
    11dc:	0000004d 	andeq	r0, r0, sp, asr #32
    11e0:	00062801 	andeq	r2, r6, r1, lsl #16
    11e4:	00063300 	andeq	r3, r6, r0, lsl #6
    11e8:	06ea1300 	strbteq	r1, [sl], r0, lsl #6
    11ec:	09140000 	ldmdbeq	r4, {}	; <UNPREDICTABLE>
    11f0:	00000002 	andeq	r0, r0, r2
    11f4:	0003ad16 	andeq	sl, r3, r6, lsl sp
    11f8:	0e540600 	cdpeq	6, 5, cr0, cr4, cr0, {0}
    11fc:	00000b5b 	andeq	r0, r0, fp, asr fp
    1200:	000001fc 	strdeq	r0, [r0], -ip
    1204:	00064c01 	andeq	r4, r6, r1, lsl #24
    1208:	00065700 	andeq	r5, r6, r0, lsl #14
    120c:	06ea1300 	strbteq	r1, [sl], r0, lsl #6
    1210:	4d140000 	ldcmi	0, cr0, [r4, #-0]
    1214:	00000000 	andeq	r0, r0, r0
    1218:	0003ca18 	andeq	ip, r3, r8, lsl sl
    121c:	0e570600 	cdpeq	6, 5, cr0, cr7, cr0, {0}
    1220:	00000a49 	andeq	r0, r0, r9, asr #20
    1224:	00066c01 	andeq	r6, r6, r1, lsl #24
    1228:	00068b00 	andeq	r8, r6, r0, lsl #22
    122c:	06ea1300 	strbteq	r1, [sl], r0, lsl #6
    1230:	a9140000 	ldmdbge	r4, {}	; <UNPREDICTABLE>
    1234:	14000000 	strne	r0, [r0], #-0
    1238:	0000004d 	andeq	r0, r0, sp, asr #32
    123c:	00004d14 	andeq	r4, r0, r4, lsl sp
    1240:	004d1400 	subeq	r1, sp, r0, lsl #8
    1244:	18140000 	ldmdane	r4, {}	; <UNPREDICTABLE>
    1248:	00000007 	andeq	r0, r0, r7
    124c:	000b8c18 	andeq	r8, fp, r8, lsl ip
    1250:	0e590600 	cdpeq	6, 5, cr0, cr9, cr0, {0}
    1254:	00000c0c 	andeq	r0, r0, ip, lsl #24
    1258:	0006a001 	andeq	sl, r6, r1
    125c:	0006bf00 	andeq	fp, r6, r0, lsl #30
    1260:	06ea1300 	strbteq	r1, [sl], r0, lsl #6
    1264:	ec140000 	ldc	0, cr0, [r4], {-0}
    1268:	14000000 	strne	r0, [r0], #-0
    126c:	0000004d 	andeq	r0, r0, sp, asr #32
    1270:	00004d14 	andeq	r4, r0, r4, lsl sp
    1274:	004d1400 	subeq	r1, sp, r0, lsl #8
    1278:	18140000 	ldmdane	r4, {}	; <UNPREDICTABLE>
    127c:	00000007 	andeq	r0, r0, r7
    1280:	0003dd19 	andeq	sp, r3, r9, lsl sp
    1284:	0e5c0600 	cdpeq	6, 5, cr0, cr12, cr0, {0}
    1288:	0000079e 	muleq	r0, lr, r7
    128c:	000001fc 	strdeq	r0, [r0], -ip
    1290:	0006d401 	andeq	sp, r6, r1, lsl #8
    1294:	06ea1300 	strbteq	r1, [sl], r0, lsl #6
    1298:	9b140000 	blls	5012a0 <__bss_end+0x4f7608>
    129c:	14000003 	strne	r0, [r0], #-3
    12a0:	0000071e 	andeq	r0, r0, lr, lsl r7
    12a4:	24030000 	strcs	r0, [r3], #-0
    12a8:	0d000004 	stceq	0, cr0, [r0, #-16]
    12ac:	00042404 	andeq	r2, r4, r4, lsl #8
    12b0:	04181a00 	ldreq	r1, [r8], #-2560	; 0xfffff600
    12b4:	06fd0000 	ldrbteq	r0, [sp], r0
    12b8:	07030000 	streq	r0, [r3, -r0]
    12bc:	ea130000 	b	4c12c4 <__bss_end+0x4b762c>
    12c0:	00000006 	andeq	r0, r0, r6
    12c4:	0004241b 	andeq	r2, r4, fp, lsl r4
    12c8:	0006f000 	andeq	pc, r6, r0
    12cc:	3f040d00 	svccc	0x00040d00
    12d0:	0d000000 	stceq	0, cr0, [r0, #-0]
    12d4:	0006e504 	andeq	lr, r6, r4, lsl #10
    12d8:	65041c00 	strvs	r1, [r4, #-3072]	; 0xfffff400
    12dc:	1d000000 	stcne	0, cr0, [r0, #-0]
    12e0:	002c0f04 	eoreq	r0, ip, r4, lsl #30
    12e4:	07300000 	ldreq	r0, [r0, -r0]!
    12e8:	5e100000 	cdppl	0, 1, cr0, cr0, cr0, {0}
    12ec:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
    12f0:	07200300 	streq	r0, [r0, -r0, lsl #6]!
    12f4:	0e1e0000 	cdpeq	0, 1, cr0, cr14, cr0, {0}
    12f8:	0100000d 	tsteq	r0, sp
    12fc:	07300ca5 	ldreq	r0, [r0, -r5, lsr #25]!
    1300:	03050000 	movweq	r0, #20480	; 0x5000
    1304:	00009c58 	andeq	r9, r0, r8, asr ip
    1308:	00093d1f 	andeq	r3, r9, pc, lsl sp
    130c:	0aa70100 	beq	fe9c1714 <__bss_end+0xfe9b7a7c>
    1310:	00000e2e 	andeq	r0, r0, lr, lsr #28
    1314:	0000004d 	andeq	r0, r0, sp, asr #32
    1318:	000087c4 	andeq	r8, r0, r4, asr #15
    131c:	000000b0 	strheq	r0, [r0], -r0	; <UNPREDICTABLE>
    1320:	07a59c01 	streq	r9, [r5, r1, lsl #24]!
    1324:	d0200000 	eorle	r0, r0, r0
    1328:	0100000f 	tsteq	r0, pc
    132c:	02031ba7 	andeq	r1, r3, #171008	; 0x29c00
    1330:	91030000 	mrsls	r0, (UNDEF: 3)
    1334:	8d207fac 	stchi	15, cr7, [r0, #-688]!	; 0xfffffd50
    1338:	0100000e 	tsteq	r0, lr
    133c:	004d2aa7 	subeq	r2, sp, r7, lsr #21
    1340:	91030000 	mrsls	r0, (UNDEF: 3)
    1344:	661e7fa8 	ldrvs	r7, [lr], -r8, lsr #31
    1348:	0100000d 	tsteq	r0, sp
    134c:	07a50aa9 	streq	r0, [r5, r9, lsr #21]!
    1350:	91030000 	mrsls	r0, (UNDEF: 3)
    1354:	7e1e7fb4 	mrcvc	15, 0, r7, cr14, cr4, {5}
    1358:	0100000c 	tsteq	r0, ip
    135c:	003809ad 	eorseq	r0, r8, sp, lsr #19
    1360:	91020000 	mrsls	r0, (UNDEF: 2)
    1364:	250f0074 	strcs	r0, [pc, #-116]	; 12f8 <shift+0x12f8>
    1368:	b5000000 	strlt	r0, [r0, #-0]
    136c:	10000007 	andne	r0, r0, r7
    1370:	0000005e 	andeq	r0, r0, lr, asr r0
    1374:	7221003f 	eorvc	r0, r1, #63	; 0x3f
    1378:	0100000e 	tsteq	r0, lr
    137c:	0ee50a99 			; <UNDEFINED> instruction: 0x0ee50a99
    1380:	004d0000 	subeq	r0, sp, r0
    1384:	87880000 	strhi	r0, [r8, r0]
    1388:	003c0000 	eorseq	r0, ip, r0
    138c:	9c010000 	stcls	0, cr0, [r1], {-0}
    1390:	000007f2 	strdeq	r0, [r0], -r2
    1394:	71657222 	cmnvc	r5, r2, lsr #4
    1398:	209b0100 	addscs	r0, fp, r0, lsl #2
    139c:	000003de 	ldrdeq	r0, [r0], -lr
    13a0:	1e749102 	expnes	f1, f2
    13a4:	00000e23 	andeq	r0, r0, r3, lsr #28
    13a8:	4d0e9c01 	stcmi	12, cr9, [lr, #-4]
    13ac:	02000000 	andeq	r0, r0, #0
    13b0:	23007091 	movwcs	r7, #145	; 0x91
    13b4:	00000eb5 			; <UNDEFINED> instruction: 0x00000eb5
    13b8:	9a069001 	bls	1a53c4 <__bss_end+0x19b72c>
    13bc:	4c00000c 	stcmi	0, cr0, [r0], {12}
    13c0:	3c000087 	stccc	0, cr0, [r0], {135}	; 0x87
    13c4:	01000000 	mrseq	r0, (UNDEF: 0)
    13c8:	00082b9c 	muleq	r8, ip, fp
    13cc:	0cdc2000 	ldcleq	0, cr2, [ip], {0}
    13d0:	90010000 	andls	r0, r1, r0
    13d4:	00004d21 	andeq	r4, r0, r1, lsr #26
    13d8:	6c910200 	lfmvs	f0, 4, [r1], {0}
    13dc:	71657222 	cmnvc	r5, r2, lsr #4
    13e0:	20920100 	addscs	r0, r2, r0, lsl #2
    13e4:	000003de 	ldrdeq	r0, [r0], -lr
    13e8:	00749102 	rsbseq	r9, r4, r2, lsl #2
    13ec:	000e4f21 	andeq	r4, lr, r1, lsr #30
    13f0:	0a840100 	beq	fe1017f8 <__bss_end+0xfe0f7b60>
    13f4:	00000d1f 	andeq	r0, r0, pc, lsl sp
    13f8:	0000004d 	andeq	r0, r0, sp, asr #32
    13fc:	00008710 	andeq	r8, r0, r0, lsl r7
    1400:	0000003c 	andeq	r0, r0, ip, lsr r0
    1404:	08689c01 	stmdaeq	r8!, {r0, sl, fp, ip, pc}^
    1408:	72220000 	eorvc	r0, r2, #0
    140c:	01007165 	tsteq	r0, r5, ror #2
    1410:	03ba2086 			; <UNDEFINED> instruction: 0x03ba2086
    1414:	91020000 	mrsls	r0, (UNDEF: 2)
    1418:	0c771e74 	ldcleq	14, cr1, [r7], #-464	; 0xfffffe30
    141c:	87010000 	strhi	r0, [r1, -r0]
    1420:	00004d0e 	andeq	r4, r0, lr, lsl #26
    1424:	70910200 	addsvc	r0, r1, r0, lsl #4
    1428:	0fb32100 	svceq	0x00b32100
    142c:	78010000 	stmdavc	r1, {}	; <UNPREDICTABLE>
    1430:	000cf00a 	andeq	pc, ip, sl
    1434:	00004d00 	andeq	r4, r0, r0, lsl #26
    1438:	0086d400 	addeq	sp, r6, r0, lsl #8
    143c:	00003c00 	andeq	r3, r0, r0, lsl #24
    1440:	a59c0100 	ldrge	r0, [ip, #256]	; 0x100
    1444:	22000008 	andcs	r0, r0, #8
    1448:	00716572 	rsbseq	r6, r1, r2, ror r5
    144c:	ba207a01 	blt	81fc58 <__bss_end+0x815fc0>
    1450:	02000003 	andeq	r0, r0, #3
    1454:	771e7491 			; <UNDEFINED> instruction: 0x771e7491
    1458:	0100000c 	tsteq	r0, ip
    145c:	004d0e7b 	subeq	r0, sp, fp, ror lr
    1460:	91020000 	mrsls	r0, (UNDEF: 2)
    1464:	33210070 			; <UNDEFINED> instruction: 0x33210070
    1468:	0100000d 	tsteq	r0, sp
    146c:	0ec7066c 	cdpeq	6, 12, cr0, cr7, cr12, {3}
    1470:	01fc0000 	mvnseq	r0, r0
    1474:	86800000 	strhi	r0, [r0], r0
    1478:	00540000 	subseq	r0, r4, r0
    147c:	9c010000 	stcls	0, cr0, [r1], {-0}
    1480:	000008f1 	strdeq	r0, [r0], -r1
    1484:	000e2320 	andeq	r2, lr, r0, lsr #6
    1488:	156c0100 	strbne	r0, [ip, #-256]!	; 0xffffff00
    148c:	0000004d 	andeq	r0, r0, sp, asr #32
    1490:	206c9102 	rsbcs	r9, ip, r2, lsl #2
    1494:	000008db 	ldrdeq	r0, [r0], -fp
    1498:	4d256c01 	stcmi	12, cr6, [r5, #-4]!
    149c:	02000000 	andeq	r0, r0, #0
    14a0:	ab1e6891 	blge	79b6ec <__bss_end+0x791a54>
    14a4:	0100000f 	tsteq	r0, pc
    14a8:	004d0e6e 	subeq	r0, sp, lr, ror #28
    14ac:	91020000 	mrsls	r0, (UNDEF: 2)
    14b0:	b1210074 			; <UNDEFINED> instruction: 0xb1210074
    14b4:	0100000c 	tsteq	r0, ip
    14b8:	0f4c125f 	svceq	0x004c125f
    14bc:	008b0000 	addeq	r0, fp, r0
    14c0:	86300000 	ldrthi	r0, [r0], -r0
    14c4:	00500000 	subseq	r0, r0, r0
    14c8:	9c010000 	stcls	0, cr0, [r1], {-0}
    14cc:	0000094c 	andeq	r0, r0, ip, asr #18
    14d0:	000ed220 	andeq	sp, lr, r0, lsr #4
    14d4:	205f0100 	subscs	r0, pc, r0, lsl #2
    14d8:	0000004d 	andeq	r0, r0, sp, asr #32
    14dc:	206c9102 	rsbcs	r9, ip, r2, lsl #2
    14e0:	00000e58 	andeq	r0, r0, r8, asr lr
    14e4:	4d2f5f01 	stcmi	15, cr5, [pc, #-4]!	; 14e8 <shift+0x14e8>
    14e8:	02000000 	andeq	r0, r0, #0
    14ec:	db206891 	blle	81b738 <__bss_end+0x811aa0>
    14f0:	01000008 	tsteq	r0, r8
    14f4:	004d3f5f 	subeq	r3, sp, pc, asr pc
    14f8:	91020000 	mrsls	r0, (UNDEF: 2)
    14fc:	0fab1e64 	svceq	0x00ab1e64
    1500:	61010000 	mrsvs	r0, (UNDEF: 1)
    1504:	00008b16 	andeq	r8, r0, r6, lsl fp
    1508:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    150c:	0f822100 	svceq	0x00822100
    1510:	53010000 	movwpl	r0, #4096	; 0x1000
    1514:	000cb60a 	andeq	fp, ip, sl, lsl #12
    1518:	00004d00 	andeq	r4, r0, r0, lsl #26
    151c:	0085ec00 	addeq	lr, r5, r0, lsl #24
    1520:	00004400 	andeq	r4, r0, r0, lsl #8
    1524:	989c0100 	ldmls	ip, {r8}
    1528:	20000009 	andcs	r0, r0, r9
    152c:	00000ed2 	ldrdeq	r0, [r0], -r2
    1530:	4d1a5301 	ldcmi	3, cr5, [sl, #-4]
    1534:	02000000 	andeq	r0, r0, #0
    1538:	58206c91 	stmdapl	r0!, {r0, r4, r7, sl, fp, sp, lr}
    153c:	0100000e 	tsteq	r0, lr
    1540:	004d2953 	subeq	r2, sp, r3, asr r9
    1544:	91020000 	mrsls	r0, (UNDEF: 2)
    1548:	0f7b1e68 	svceq	0x007b1e68
    154c:	55010000 	strpl	r0, [r1, #-0]
    1550:	00004d0e 	andeq	r4, r0, lr, lsl #26
    1554:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1558:	0f752100 	svceq	0x00752100
    155c:	46010000 	strmi	r0, [r1], -r0
    1560:	000f570a 	andeq	r5, pc, sl, lsl #14
    1564:	00004d00 	andeq	r4, r0, r0, lsl #26
    1568:	00859c00 	addeq	r9, r5, r0, lsl #24
    156c:	00005000 	andeq	r5, r0, r0
    1570:	f39c0100 	vaddw.u16	q0, q6, d0
    1574:	20000009 	andcs	r0, r0, r9
    1578:	00000ed2 	ldrdeq	r0, [r0], -r2
    157c:	4d194601 	ldcmi	6, cr4, [r9, #-4]
    1580:	02000000 	andeq	r0, r0, #0
    1584:	47206c91 			; <UNDEFINED> instruction: 0x47206c91
    1588:	0100000d 	tsteq	r0, sp
    158c:	01293046 			; <UNDEFINED> instruction: 0x01293046
    1590:	91020000 	mrsls	r0, (UNDEF: 2)
    1594:	0e5e2068 	cdpeq	0, 5, cr2, cr14, cr8, {3}
    1598:	46010000 	strmi	r0, [r1], -r0
    159c:	00071e41 	andeq	r1, r7, r1, asr #28
    15a0:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    15a4:	000fab1e 	andeq	sl, pc, lr, lsl fp	; <UNPREDICTABLE>
    15a8:	0e480100 	dvfeqe	f0, f0, f0
    15ac:	0000004d 	andeq	r0, r0, sp, asr #32
    15b0:	00749102 	rsbseq	r9, r4, r2, lsl #2
    15b4:	000c6423 	andeq	r6, ip, r3, lsr #8
    15b8:	06400100 	strbeq	r0, [r0], -r0, lsl #2
    15bc:	00000d51 	andeq	r0, r0, r1, asr sp
    15c0:	00008570 	andeq	r8, r0, r0, ror r5
    15c4:	0000002c 	andeq	r0, r0, ip, lsr #32
    15c8:	0a1d9c01 	beq	7685d4 <__bss_end+0x75e93c>
    15cc:	d2200000 	eorle	r0, r0, #0
    15d0:	0100000e 	tsteq	r0, lr
    15d4:	004d1540 	subeq	r1, sp, r0, asr #10
    15d8:	91020000 	mrsls	r0, (UNDEF: 2)
    15dc:	1d210074 	stcne	0, cr0, [r1, #-464]!	; 0xfffffe30
    15e0:	0100000e 	tsteq	r0, lr
    15e4:	0e640a33 			; <UNDEFINED> instruction: 0x0e640a33
    15e8:	004d0000 	subeq	r0, sp, r0
    15ec:	85200000 	strhi	r0, [r0, #-0]!
    15f0:	00500000 	subseq	r0, r0, r0
    15f4:	9c010000 	stcls	0, cr0, [r1], {-0}
    15f8:	00000a78 	andeq	r0, r0, r8, ror sl
    15fc:	000ed220 	andeq	sp, lr, r0, lsr #4
    1600:	19330100 	ldmdbne	r3!, {r8}
    1604:	0000004d 	andeq	r0, r0, sp, asr #32
    1608:	206c9102 	rsbcs	r9, ip, r2, lsl #2
    160c:	00000f98 	muleq	r0, r8, pc	; <UNPREDICTABLE>
    1610:	032b3301 			; <UNDEFINED> instruction: 0x032b3301
    1614:	02000002 	andeq	r0, r0, #2
    1618:	91206891 			; <UNDEFINED> instruction: 0x91206891
    161c:	0100000e 	tsteq	r0, lr
    1620:	004d3c33 	subeq	r3, sp, r3, lsr ip
    1624:	91020000 	mrsls	r0, (UNDEF: 2)
    1628:	0f461e64 	svceq	0x00461e64
    162c:	35010000 	strcc	r0, [r1, #-0]
    1630:	00004d0e 	andeq	r4, r0, lr, lsl #26
    1634:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1638:	0fd52100 	svceq	0x00d52100
    163c:	25010000 	strcs	r0, [r1, #-0]
    1640:	000f9f0a 	andeq	r9, pc, sl, lsl #30
    1644:	00004d00 	andeq	r4, r0, r0, lsl #26
    1648:	0084d000 	addeq	sp, r4, r0
    164c:	00005000 	andeq	r5, r0, r0
    1650:	d39c0100 	orrsle	r0, ip, #0, 2
    1654:	2000000a 	andcs	r0, r0, sl
    1658:	00000ed2 	ldrdeq	r0, [r0], -r2
    165c:	4d182501 	cfldr32mi	mvfx2, [r8, #-4]
    1660:	02000000 	andeq	r0, r0, #0
    1664:	98206c91 	stmdals	r0!, {r0, r4, r7, sl, fp, sp, lr}
    1668:	0100000f 	tsteq	r0, pc
    166c:	0ad92a25 	beq	ff64bf08 <__bss_end+0xff642270>
    1670:	91020000 	mrsls	r0, (UNDEF: 2)
    1674:	0e912068 	cdpeq	0, 9, cr2, cr1, cr8, {3}
    1678:	25010000 	strcs	r0, [r1, #-0]
    167c:	00004d3b 	andeq	r4, r0, fp, lsr sp
    1680:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    1684:	000c831e 	andeq	r8, ip, lr, lsl r3
    1688:	0e270100 	sufeqs	f0, f7, f0
    168c:	0000004d 	andeq	r0, r0, sp, asr #32
    1690:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1694:	0025040d 	eoreq	r0, r5, sp, lsl #8
    1698:	d3030000 	movwle	r0, #12288	; 0x3000
    169c:	2100000a 	tstcs	r0, sl
    16a0:	00000e29 	andeq	r0, r0, r9, lsr #28
    16a4:	e10a1901 	tst	sl, r1, lsl #18
    16a8:	4d00000f 	stcmi	0, cr0, [r0, #-60]	; 0xffffffc4
    16ac:	8c000000 	stchi	0, cr0, [r0], {-0}
    16b0:	44000084 	strmi	r0, [r0], #-132	; 0xffffff7c
    16b4:	01000000 	mrseq	r0, (UNDEF: 0)
    16b8:	000b2a9c 	muleq	fp, ip, sl
    16bc:	0fcc2000 	svceq	0x00cc2000
    16c0:	19010000 	stmdbne	r1, {}	; <UNPREDICTABLE>
    16c4:	0002031b 	andeq	r0, r2, fp, lsl r3
    16c8:	6c910200 	lfmvs	f0, 4, [r1], {0}
    16cc:	000f9320 	andeq	r9, pc, r0, lsr #6
    16d0:	35190100 	ldrcc	r0, [r9, #-256]	; 0xffffff00
    16d4:	000001d2 	ldrdeq	r0, [r0], -r2
    16d8:	1e689102 	lgnnee	f1, f2
    16dc:	00000ed2 	ldrdeq	r0, [r0], -r2
    16e0:	4d0e1b01 	vstrmi	d1, [lr, #-4]
    16e4:	02000000 	andeq	r0, r0, #0
    16e8:	24007491 	strcs	r7, [r0], #-1169	; 0xfffffb6f
    16ec:	00000cd0 	ldrdeq	r0, [r0], -r0	; <UNPREDICTABLE>
    16f0:	89061401 	stmdbhi	r6, {r0, sl, ip}
    16f4:	7000000c 	andvc	r0, r0, ip
    16f8:	1c000084 	stcne	0, cr0, [r0], {132}	; 0x84
    16fc:	01000000 	mrseq	r0, (UNDEF: 0)
    1700:	0f89239c 	svceq	0x0089239c
    1704:	0e010000 	cdpeq	0, 0, cr0, cr1, cr0, {0}
    1708:	000d3906 	andeq	r3, sp, r6, lsl #18
    170c:	00844400 	addeq	r4, r4, r0, lsl #8
    1710:	00002c00 	andeq	r2, r0, r0, lsl #24
    1714:	6a9c0100 	bvs	fe701b1c <__bss_end+0xfe6f7e84>
    1718:	2000000b 	andcs	r0, r0, fp
    171c:	00000cc7 	andeq	r0, r0, r7, asr #25
    1720:	38140e01 	ldmdacc	r4, {r0, r9, sl, fp}
    1724:	02000000 	andeq	r0, r0, #0
    1728:	25007491 	strcs	r7, [r0, #-1169]	; 0xfffffb6f
    172c:	00000fda 	ldrdeq	r0, [r0], -sl
    1730:	5b0a0401 	blpl	28273c <__bss_end+0x278aa4>
    1734:	4d00000d 	stcmi	0, cr0, [r0, #-52]	; 0xffffffcc
    1738:	18000000 	stmdane	r0, {}	; <UNPREDICTABLE>
    173c:	2c000084 	stccs	0, cr0, [r0], {132}	; 0x84
    1740:	01000000 	mrseq	r0, (UNDEF: 0)
    1744:	6970229c 	ldmdbvs	r0!, {r2, r3, r4, r7, r9, sp}^
    1748:	06010064 	streq	r0, [r1], -r4, rrx
    174c:	00004d0e 	andeq	r4, r0, lr, lsl #26
    1750:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1754:	062d0000 	strteq	r0, [sp], -r0
    1758:	00040000 	andeq	r0, r4, r0
    175c:	0000069c 	muleq	r0, ip, r6
    1760:	0d6c0104 	stfeqe	f0, [ip, #-16]!
    1764:	9c040000 	stcls	0, cr0, [r4], {-0}
    1768:	96000010 			; <UNDEFINED> instruction: 0x96000010
    176c:	7800000e 	stmdavc	r0, {r1, r2, r3}
    1770:	5c000088 	stcpl	0, cr0, [r0], {136}	; 0x88
    1774:	5400000c 	strpl	r0, [r0], #-12
    1778:	02000006 	andeq	r0, r0, #6
    177c:	00000049 	andeq	r0, r0, r9, asr #32
    1780:	0010f903 	andseq	pc, r0, r3, lsl #18
    1784:	10050100 	andne	r0, r5, r0, lsl #2
    1788:	00000061 	andeq	r0, r0, r1, rrx
    178c:	32313011 	eorscc	r3, r1, #17
    1790:	36353433 			; <UNDEFINED> instruction: 0x36353433
    1794:	41393837 	teqmi	r9, r7, lsr r8
    1798:	45444342 	strbmi	r4, [r4, #-834]	; 0xfffffcbe
    179c:	04000046 	streq	r0, [r0], #-70	; 0xffffffba
    17a0:	25010301 	strcs	r0, [r1, #-769]	; 0xfffffcff
    17a4:	05000000 	streq	r0, [r0, #-0]
    17a8:	00000074 	andeq	r0, r0, r4, ror r0
    17ac:	00000061 	andeq	r0, r0, r1, rrx
    17b0:	00006606 	andeq	r6, r0, r6, lsl #12
    17b4:	07001000 	streq	r1, [r0, -r0]
    17b8:	00000051 	andeq	r0, r0, r1, asr r0
    17bc:	ee070408 	cdp	4, 0, cr0, cr7, cr8, {0}
    17c0:	08000015 	stmdaeq	r0, {r0, r2, r4}
    17c4:	0abd0801 	beq	fef437d0 <__bss_end+0xfef39b38>
    17c8:	6d070000 	stcvs	0, cr0, [r7, #-0]
    17cc:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
    17d0:	0000002a 	andeq	r0, r0, sl, lsr #32
    17d4:	0011050a 	andseq	r0, r1, sl, lsl #10
    17d8:	06d20100 	ldrbeq	r0, [r2], r0, lsl #2
    17dc:	0000119a 	muleq	r0, sl, r1
    17e0:	000091ac 	andeq	r9, r0, ip, lsr #3
    17e4:	00000328 	andeq	r0, r0, r8, lsr #6
    17e8:	011f9c01 	tsteq	pc, r1, lsl #24
    17ec:	660b0000 	strvs	r0, [fp], -r0
    17f0:	11d20100 	bicsne	r0, r2, r0, lsl #2
    17f4:	0000011f 	andeq	r0, r0, pc, lsl r1
    17f8:	7fa49103 	svcvc	0x00a49103
    17fc:	0100720b 	tsteq	r0, fp, lsl #4
    1800:	012619d2 	ldrdeq	r1, [r6, -r2]!
    1804:	91030000 	mrsls	r0, (UNDEF: 3)
    1808:	ac0c7fa0 	stcge	15, cr7, [ip], {160}	; 0xa0
    180c:	01000011 	tsteq	r0, r1, lsl r0
    1810:	012c13d4 	ldrdeq	r1, [ip, -r4]!
    1814:	91020000 	mrsls	r0, (UNDEF: 2)
    1818:	11570c58 	cmpne	r7, r8, asr ip
    181c:	d4010000 	strle	r0, [r1], #-0
    1820:	00012c1b 	andeq	r2, r1, fp, lsl ip
    1824:	50910200 	addspl	r0, r1, r0, lsl #4
    1828:	0100690d 	tsteq	r0, sp, lsl #18
    182c:	012c24d4 	ldrdeq	r2, [ip, -r4]!
    1830:	91020000 	mrsls	r0, (UNDEF: 2)
    1834:	110a0c48 	tstne	sl, r8, asr #24
    1838:	d4010000 	strle	r0, [r1], #-0
    183c:	00012c27 	andeq	r2, r1, r7, lsr #24
    1840:	40910200 	addsmi	r0, r1, r0, lsl #4
    1844:	0010e90c 	andseq	lr, r0, ip, lsl #18
    1848:	2fd40100 	svccs	0x00d40100
    184c:	0000012c 	andeq	r0, r0, ip, lsr #2
    1850:	7fb89103 	svcvc	0x00b89103
    1854:	00106d0c 	andseq	r6, r0, ip, lsl #26
    1858:	39d40100 	ldmibcc	r4, {r8}^
    185c:	0000012c 	andeq	r0, r0, ip, lsr #2
    1860:	7fb09103 	svcvc	0x00b09103
    1864:	0011180c 	andseq	r1, r1, ip, lsl #16
    1868:	0bd50100 	bleq	ff541c70 <__bss_end+0xff537fd8>
    186c:	0000011f 	andeq	r0, r0, pc, lsl r1
    1870:	7fac9103 	svcvc	0x00ac9103
    1874:	04040800 	streq	r0, [r4], #-2048	; 0xfffff800
    1878:	000012f5 	strdeq	r1, [r0], -r5
    187c:	006d040e 	rsbeq	r0, sp, lr, lsl #8
    1880:	08080000 	stmdaeq	r8, {}	; <UNPREDICTABLE>
    1884:	00024305 	andeq	r4, r2, r5, lsl #6
    1888:	115f0f00 	cmpne	pc, r0, lsl #30
    188c:	c8010000 	stmdagt	r1, {}	; <UNPREDICTABLE>
    1890:	00103405 	andseq	r3, r0, r5, lsl #8
    1894:	00017f00 	andeq	r7, r1, r0, lsl #30
    1898:	00914400 	addseq	r4, r1, r0, lsl #8
    189c:	00006800 	andeq	r6, r0, r0, lsl #16
    18a0:	7f9c0100 	svcvc	0x009c0100
    18a4:	10000001 	andne	r0, r0, r1
    18a8:	0000110a 	andeq	r1, r0, sl, lsl #2
    18ac:	7f0ec801 	svcvc	0x000ec801
    18b0:	02000001 	andeq	r0, r0, #1
    18b4:	58106c91 	ldmdapl	r0, {r0, r4, r7, sl, fp, sp, lr}
    18b8:	0100000e 	tsteq	r0, lr
    18bc:	017f1ac8 	cmneq	pc, r8, asr #21
    18c0:	91020000 	mrsls	r0, (UNDEF: 2)
    18c4:	01250c68 			; <UNDEFINED> instruction: 0x01250c68
    18c8:	ca010000 	bgt	418d0 <__bss_end+0x37c38>
    18cc:	00017f09 	andeq	r7, r1, r9, lsl #30
    18d0:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    18d4:	05041100 	streq	r1, [r4, #-256]	; 0xffffff00
    18d8:	00746e69 	rsbseq	r6, r4, r9, ror #28
    18dc:	00113412 	andseq	r3, r1, r2, lsl r4
    18e0:	06bd0100 	ldrteq	r0, [sp], r0, lsl #2
    18e4:	0000100e 	andeq	r1, r0, lr
    18e8:	000090c4 	andeq	r9, r0, r4, asr #1
    18ec:	00000080 	andeq	r0, r0, r0, lsl #1
    18f0:	02039c01 	andeq	r9, r3, #256	; 0x100
    18f4:	730b0000 	movwvc	r0, #45056	; 0xb000
    18f8:	01006372 	tsteq	r0, r2, ror r3
    18fc:	020319bd 	andeq	r1, r3, #3096576	; 0x2f4000
    1900:	91020000 	mrsls	r0, (UNDEF: 2)
    1904:	73640b64 	cmnvc	r4, #100, 22	; 0x19000
    1908:	bd010074 	stclt	0, cr0, [r1, #-464]	; 0xfffffe30
    190c:	00020a24 	andeq	r0, r2, r4, lsr #20
    1910:	60910200 	addsvs	r0, r1, r0, lsl #4
    1914:	6d756e0b 	ldclvs	14, cr6, [r5, #-44]!	; 0xffffffd4
    1918:	2dbd0100 	ldfcss	f0, [sp]
    191c:	0000017f 	andeq	r0, r0, pc, ror r1
    1920:	0c5c9102 	ldfeqp	f1, [ip], {2}
    1924:	00001111 	andeq	r1, r0, r1, lsl r1
    1928:	0c0ebf01 	stceq	15, cr11, [lr], {1}
    192c:	02000002 	andeq	r0, r0, #2
    1930:	f20c7091 	vqadd.s8	d7, d28, d1
    1934:	01000010 	tsteq	r0, r0, lsl r0
    1938:	012608c0 	smlawteq	r6, r0, r8, r0
    193c:	91020000 	mrsls	r0, (UNDEF: 2)
    1940:	90ec136c 	rscls	r1, ip, ip, ror #6
    1944:	00480000 	subeq	r0, r8, r0
    1948:	690d0000 	stmdbvs	sp, {}	; <UNPREDICTABLE>
    194c:	0bc20100 	bleq	ff081d54 <__bss_end+0xff0780bc>
    1950:	0000017f 	andeq	r0, r0, pc, ror r1
    1954:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1958:	09040e00 	stmdbeq	r4, {r9, sl, fp}
    195c:	14000002 	strne	r0, [r0], #-2
    1960:	040e0415 	streq	r0, [lr], #-1045	; 0xfffffbeb
    1964:	00000074 	andeq	r0, r0, r4, ror r0
    1968:	00112e12 	andseq	r2, r1, r2, lsl lr
    196c:	06b50100 	ldrteq	r0, [r5], r0, lsl #2
    1970:	00001079 	andeq	r1, r0, r9, ror r0
    1974:	0000905c 	andeq	r9, r0, ip, asr r0
    1978:	00000068 	andeq	r0, r0, r8, rrx
    197c:	02719c01 	rsbseq	r9, r1, #256	; 0x100
    1980:	a5100000 	ldrge	r0, [r0, #-0]
    1984:	01000011 	tsteq	r0, r1, lsl r0
    1988:	020a12b5 	andeq	r1, sl, #1342177291	; 0x5000000b
    198c:	91020000 	mrsls	r0, (UNDEF: 2)
    1990:	11ac106c 			; <UNDEFINED> instruction: 0x11ac106c
    1994:	b5010000 	strlt	r0, [r1, #-0]
    1998:	00017f1e 	andeq	r7, r1, lr, lsl pc
    199c:	68910200 	ldmvs	r1, {r9}
    19a0:	6d656d0d 	stclvs	13, cr6, [r5, #-52]!	; 0xffffffcc
    19a4:	08b70100 	ldmeq	r7!, {r8}
    19a8:	00000126 	andeq	r0, r0, r6, lsr #2
    19ac:	13709102 	cmnne	r0, #-2147483648	; 0x80000000
    19b0:	00009078 	andeq	r9, r0, r8, ror r0
    19b4:	0000003c 	andeq	r0, r0, ip, lsr r0
    19b8:	0100690d 	tsteq	r0, sp, lsl #18
    19bc:	017f0bb9 	ldrheq	r0, [pc, #-185]	; 190b <shift+0x190b>
    19c0:	91020000 	mrsls	r0, (UNDEF: 2)
    19c4:	16000074 			; <UNDEFINED> instruction: 0x16000074
    19c8:	000010ce 	andeq	r1, r0, lr, asr #1
    19cc:	ba07a401 	blt	1ea9d8 <__bss_end+0x1e0d40>
    19d0:	26000011 			; <UNDEFINED> instruction: 0x26000011
    19d4:	84000001 	strhi	r0, [r0], #-1
    19d8:	d800008f 	stmdale	r0, {r0, r1, r2, r3, r7}
    19dc:	01000000 	mrseq	r0, (UNDEF: 0)
    19e0:	0002f09c 	muleq	r2, ip, r0
    19e4:	10621000 	rsbne	r1, r2, r0
    19e8:	a4010000 	strge	r0, [r1], #-0
    19ec:	00012615 	andeq	r2, r1, r5, lsl r6
    19f0:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    19f4:	6372730b 	cmnvs	r2, #738197504	; 0x2c000000
    19f8:	27a40100 	strcs	r0, [r4, r0, lsl #2]!
    19fc:	0000020c 	andeq	r0, r0, ip, lsl #4
    1a00:	10609102 	rsbne	r9, r0, r2, lsl #2
    1a04:	00000e91 	muleq	r0, r1, lr
    1a08:	7f2fa401 	svcvc	0x002fa401
    1a0c:	02000001 	andeq	r0, r0, #1
    1a10:	d60c5c91 			; <UNDEFINED> instruction: 0xd60c5c91
    1a14:	01000010 	tsteq	r0, r0, lsl r0
    1a18:	017f09a5 	cmneq	pc, r5, lsr #19
    1a1c:	91020000 	mrsls	r0, (UNDEF: 2)
    1a20:	006d0d6c 	rsbeq	r0, sp, ip, ror #26
    1a24:	7f09a701 	svcvc	0x0009a701
    1a28:	02000001 	andeq	r0, r0, #1
    1a2c:	c8137491 	ldmdagt	r3, {r0, r4, r7, sl, ip, sp, lr}
    1a30:	7000008f 	andvc	r0, r0, pc, lsl #1
    1a34:	0d000000 	stceq	0, cr0, [r0, #-0]
    1a38:	ab010069 	blge	41be4 <__bss_end+0x37f4c>
    1a3c:	00017f0d 	andeq	r7, r1, sp, lsl #30
    1a40:	70910200 	addsvc	r0, r1, r0, lsl #4
    1a44:	72160000 	andsvc	r0, r6, #0
    1a48:	01000010 	tsteq	r0, r0, lsl r0
    1a4c:	108d079a 	umullne	r0, sp, sl, r7
    1a50:	01260000 			; <UNDEFINED> instruction: 0x01260000
    1a54:	8ed80000 	cdphi	0, 13, cr0, cr8, cr0, {0}
    1a58:	00ac0000 	adceq	r0, ip, r0
    1a5c:	9c010000 	stcls	0, cr0, [r1], {-0}
    1a60:	0000036d 	andeq	r0, r0, sp, ror #6
    1a64:	00106210 	andseq	r6, r0, r0, lsl r2
    1a68:	149a0100 	ldrne	r0, [sl], #256	; 0x100
    1a6c:	00000126 	andeq	r0, r0, r6, lsr #2
    1a70:	0b649102 	bleq	1925e80 <__bss_end+0x191c1e8>
    1a74:	00637273 	rsbeq	r7, r3, r3, ror r2
    1a78:	0c269a01 			; <UNDEFINED> instruction: 0x0c269a01
    1a7c:	02000002 	andeq	r0, r0, #2
    1a80:	6e0d6091 	mcrvs	0, 0, r6, cr13, cr1, {4}
    1a84:	099b0100 	ldmibeq	fp, {r8}
    1a88:	0000017f 	andeq	r0, r0, pc, ror r1
    1a8c:	0d6c9102 	stfeqp	f1, [ip, #-8]!
    1a90:	9c01006d 	stcls	0, cr0, [r1], {109}	; 0x6d
    1a94:	00017f09 	andeq	r7, r1, r9, lsl #30
    1a98:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1a9c:	0010d60c 	andseq	sp, r0, ip, lsl #12
    1aa0:	099d0100 	ldmibeq	sp, {r8}
    1aa4:	0000017f 	andeq	r0, r0, pc, ror r1
    1aa8:	13689102 	cmnne	r8, #-2147483648	; 0x80000000
    1aac:	00008f0c 	andeq	r8, r0, ip, lsl #30
    1ab0:	00000054 	andeq	r0, r0, r4, asr r0
    1ab4:	0100690d 	tsteq	r0, sp, lsl #18
    1ab8:	017f0d9e 			; <UNDEFINED> instruction: 0x017f0d9e
    1abc:	91020000 	mrsls	r0, (UNDEF: 2)
    1ac0:	0f000070 	svceq	0x00000070
    1ac4:	000011b3 			; <UNDEFINED> instruction: 0x000011b3
    1ac8:	64058f01 	strvs	r8, [r5], #-3841	; 0xfffff0ff
    1acc:	7f000011 	svcvc	0x00000011
    1ad0:	84000001 	strhi	r0, [r0], #-1
    1ad4:	5400008e 	strpl	r0, [r0], #-142	; 0xffffff72
    1ad8:	01000000 	mrseq	r0, (UNDEF: 0)
    1adc:	0003a69c 	muleq	r3, ip, r6
    1ae0:	00730b00 	rsbseq	r0, r3, r0, lsl #22
    1ae4:	0c188f01 	ldceq	15, cr8, [r8], {1}
    1ae8:	02000002 	andeq	r0, r0, #2
    1aec:	690d6c91 	stmdbvs	sp, {r0, r4, r7, sl, fp, sp, lr}
    1af0:	06910100 	ldreq	r0, [r1], r0, lsl #2
    1af4:	0000017f 	andeq	r0, r0, pc, ror r1
    1af8:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1afc:	00113b0f 	andseq	r3, r1, pc, lsl #22
    1b00:	057f0100 	ldrbeq	r0, [pc, #-256]!	; 1a08 <shift+0x1a08>
    1b04:	00001171 	andeq	r1, r0, r1, ror r1
    1b08:	0000017f 	andeq	r0, r0, pc, ror r1
    1b0c:	00008dd8 	ldrdeq	r8, [r0], -r8	; <UNPREDICTABLE>
    1b10:	000000ac 	andeq	r0, r0, ip, lsr #1
    1b14:	040c9c01 	streq	r9, [ip], #-3073	; 0xfffff3ff
    1b18:	730b0000 	movwvc	r0, #45056	; 0xb000
    1b1c:	7f010031 	svcvc	0x00010031
    1b20:	00020c19 	andeq	r0, r2, r9, lsl ip
    1b24:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1b28:	0032730b 	eorseq	r7, r2, fp, lsl #6
    1b2c:	0c297f01 	stceq	15, cr7, [r9], #-4
    1b30:	02000002 	andeq	r0, r0, #2
    1b34:	6e0b6891 	mcrvs	8, 0, r6, cr11, cr1, {4}
    1b38:	01006d75 	tsteq	r0, r5, ror sp
    1b3c:	017f317f 	cmneq	pc, pc, ror r1	; <UNPREDICTABLE>
    1b40:	91020000 	mrsls	r0, (UNDEF: 2)
    1b44:	31750d64 	cmncc	r5, r4, ror #26
    1b48:	10810100 	addne	r0, r1, r0, lsl #2
    1b4c:	0000040c 	andeq	r0, r0, ip, lsl #8
    1b50:	0d779102 	ldfeqp	f1, [r7, #-8]!
    1b54:	01003275 	tsteq	r0, r5, ror r2
    1b58:	040c1481 	streq	r1, [ip], #-1153	; 0xfffffb7f
    1b5c:	91020000 	mrsls	r0, (UNDEF: 2)
    1b60:	01080076 	tsteq	r8, r6, ror r0
    1b64:	000ab408 	andeq	fp, sl, r8, lsl #8
    1b68:	10850f00 	addne	r0, r5, r0, lsl #30
    1b6c:	73010000 	movwvc	r0, #4096	; 0x1000
    1b70:	000ffd07 	andeq	pc, pc, r7, lsl #26
    1b74:	00012600 	andeq	r2, r1, r0, lsl #12
    1b78:	008d1800 	addeq	r1, sp, r0, lsl #16
    1b7c:	0000c000 	andeq	ip, r0, r0
    1b80:	6c9c0100 	ldfvss	f0, [ip], {0}
    1b84:	10000004 	andne	r0, r0, r4
    1b88:	00001062 	andeq	r1, r0, r2, rrx
    1b8c:	26157301 	ldrcs	r7, [r5], -r1, lsl #6
    1b90:	02000001 	andeq	r0, r0, #1
    1b94:	730b6c91 	movwvc	r6, #48273	; 0xbc91
    1b98:	01006372 	tsteq	r0, r2, ror r3
    1b9c:	020c2773 	andeq	r2, ip, #30146560	; 0x1cc0000
    1ba0:	91020000 	mrsls	r0, (UNDEF: 2)
    1ba4:	756e0b68 	strbvc	r0, [lr, #-2920]!	; 0xfffff498
    1ba8:	7301006d 	movwvc	r0, #4205	; 0x106d
    1bac:	00017f30 	andeq	r7, r1, r0, lsr pc
    1bb0:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    1bb4:	0100690d 	tsteq	r0, sp, lsl #18
    1bb8:	017f0675 	cmneq	pc, r5, ror r6	; <UNPREDICTABLE>
    1bbc:	91020000 	mrsls	r0, (UNDEF: 2)
    1bc0:	3e0f0074 	mcrcc	0, 0, r0, cr15, cr4, {3}
    1bc4:	01000010 	tsteq	r0, r0, lsl r0
    1bc8:	10570757 	subsne	r0, r7, r7, asr r7
    1bcc:	011f0000 	tsteq	pc, r0
    1bd0:	8bbc0000 	blhi	fef01bd8 <__bss_end+0xfeef7f40>
    1bd4:	015c0000 	cmpeq	ip, r0
    1bd8:	9c010000 	stcls	0, cr0, [r1], {-0}
    1bdc:	0000050d 	andeq	r0, r0, sp, lsl #10
    1be0:	00106710 	andseq	r6, r0, r0, lsl r7
    1be4:	18570100 	ldmdane	r7, {r8}^
    1be8:	0000020c 	andeq	r0, r0, ip, lsl #4
    1bec:	0c449102 	stfeqp	f1, [r4], {2}
    1bf0:	00001150 	andeq	r1, r0, r0, asr r1
    1bf4:	0d0c5801 	stceq	8, cr5, [ip, #-4]
    1bf8:	02000005 	andeq	r0, r0, #5
    1bfc:	dd0c7091 	stcle	0, cr7, [ip, #-580]	; 0xfffffdbc
    1c00:	01000010 	tsteq	r0, r0, lsl r0
    1c04:	050d0c59 	streq	r0, [sp, #-3161]	; 0xfffff3a7
    1c08:	91020000 	mrsls	r0, (UNDEF: 2)
    1c0c:	6d740d60 	ldclvs	13, cr0, [r4, #-384]!	; 0xfffffe80
    1c10:	5b010070 	blpl	41dd8 <__bss_end+0x38140>
    1c14:	00050d0c 	andeq	r0, r5, ip, lsl #26
    1c18:	58910200 	ldmpl	r1, {r9}
    1c1c:	000aa10c 	andeq	sl, sl, ip, lsl #2
    1c20:	095c0100 	ldmdbeq	ip, {r8}^
    1c24:	0000017f 	andeq	r0, r0, pc, ror r1
    1c28:	0c549102 	ldfeqp	f1, [r4], {2}
    1c2c:	000015de 	ldrdeq	r1, [r0], -lr
    1c30:	7f095d01 	svcvc	0x00095d01
    1c34:	02000001 	andeq	r0, r0, #1
    1c38:	200c6c91 	mulcs	ip, r1, ip
    1c3c:	01000011 	tsteq	r0, r1, lsl r0
    1c40:	05140a5e 	ldreq	r0, [r4, #-2654]	; 0xfffff5a2
    1c44:	91020000 	mrsls	r0, (UNDEF: 2)
    1c48:	8c18136b 	ldchi	3, cr1, [r8], {107}	; 0x6b
    1c4c:	00d00000 	sbcseq	r0, r0, r0
    1c50:	760d0000 	strvc	r0, [sp], -r0
    1c54:	01006c61 	tsteq	r0, r1, ror #24
    1c58:	050d1067 	streq	r1, [sp, #-103]	; 0xffffff99
    1c5c:	91020000 	mrsls	r0, (UNDEF: 2)
    1c60:	08000048 	stmdaeq	r0, {r3, r6}
    1c64:	159e0408 	ldrne	r0, [lr, #1032]	; 0x408
    1c68:	01080000 	mrseq	r0, (UNDEF: 8)
    1c6c:	00079902 	andeq	r9, r7, r2, lsl #18
    1c70:	10430f00 	subne	r0, r3, r0, lsl #30
    1c74:	3c010000 	stccc	0, cr0, [r1], {-0}
    1c78:	00101e05 	andseq	r1, r0, r5, lsl #28
    1c7c:	00017f00 	andeq	r7, r1, r0, lsl #30
    1c80:	008abc00 	addeq	fp, sl, r0, lsl #24
    1c84:	00010000 	andeq	r0, r1, r0
    1c88:	7e9c0100 	fmlvce	f0, f4, f0
    1c8c:	10000005 	andne	r0, r0, r5
    1c90:	00001067 	andeq	r1, r0, r7, rrx
    1c94:	0c213c01 	stceq	12, cr3, [r1], #-4
    1c98:	02000002 	andeq	r0, r0, #2
    1c9c:	640d6c91 	strvs	r6, [sp], #-3217	; 0xfffff36f
    1ca0:	0100746f 	tsteq	r0, pc, ror #8
    1ca4:	05140a3e 	ldreq	r0, [r4, #-2622]	; 0xfffff5c2
    1ca8:	91020000 	mrsls	r0, (UNDEF: 2)
    1cac:	11430c77 	hvcne	12487	; 0x30c7
    1cb0:	3f010000 	svccc	0x00010000
    1cb4:	0005140a 	andeq	r1, r5, sl, lsl #8
    1cb8:	76910200 	ldrvc	r0, [r1], r0, lsl #4
    1cbc:	008aec13 	addeq	lr, sl, r3, lsl ip
    1cc0:	00008c00 	andeq	r8, r0, r0, lsl #24
    1cc4:	00630d00 	rsbeq	r0, r3, r0, lsl #26
    1cc8:	6d0e4101 	stfvss	f4, [lr, #-4]
    1ccc:	02000000 	andeq	r0, r0, #0
    1cd0:	00007591 	muleq	r0, r1, r5
    1cd4:	00105216 	andseq	r5, r0, r6, lsl r2
    1cd8:	05260100 	streq	r0, [r6, #-256]!	; 0xffffff00
    1cdc:	00001183 	andeq	r1, r0, r3, lsl #3
    1ce0:	0000017f 	andeq	r0, r0, pc, ror r1
    1ce4:	000089f0 	strdeq	r8, [r0], -r0
    1ce8:	000000cc 	andeq	r0, r0, ip, asr #1
    1cec:	05bb9c01 	ldreq	r9, [fp, #3073]!	; 0xc01
    1cf0:	67100000 	ldrvs	r0, [r0, -r0]
    1cf4:	01000010 	tsteq	r0, r0, lsl r0
    1cf8:	020c1626 	andeq	r1, ip, #39845888	; 0x2600000
    1cfc:	91020000 	mrsls	r0, (UNDEF: 2)
    1d00:	11500c6c 	cmpne	r0, ip, ror #24
    1d04:	2a010000 	bcs	41d0c <__bss_end+0x38074>
    1d08:	00017f06 	andeq	r7, r1, r6, lsl #30
    1d0c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1d10:	10e41700 	rscne	r1, r4, r0, lsl #14
    1d14:	08010000 	stmdaeq	r1, {}	; <UNPREDICTABLE>
    1d18:	00118e06 	andseq	r8, r1, r6, lsl #28
    1d1c:	00887800 	addeq	r7, r8, r0, lsl #16
    1d20:	00017800 	andeq	r7, r1, r0, lsl #16
    1d24:	109c0100 	addsne	r0, ip, r0, lsl #2
    1d28:	00001067 	andeq	r1, r0, r7, rrx
    1d2c:	7f0f0801 	svcvc	0x000f0801
    1d30:	02000001 	andeq	r0, r0, #1
    1d34:	50106491 	mulspl	r0, r1, r4
    1d38:	01000011 	tsteq	r0, r1, lsl r0
    1d3c:	01261c08 			; <UNDEFINED> instruction: 0x01261c08
    1d40:	91020000 	mrsls	r0, (UNDEF: 2)
    1d44:	12e81060 	rscne	r1, r8, #96	; 0x60
    1d48:	08010000 	stmdaeq	r1, {}	; <UNPREDICTABLE>
    1d4c:	00006631 	andeq	r6, r0, r1, lsr r6
    1d50:	5c910200 	lfmpl	f0, 4, [r1], {0}
    1d54:	0100690d 	tsteq	r0, sp, lsl #18
    1d58:	017f090a 	cmneq	pc, sl, lsl #18
    1d5c:	91020000 	mrsls	r0, (UNDEF: 2)
    1d60:	006a0d74 	rsbeq	r0, sl, r4, ror sp
    1d64:	7f090b01 	svcvc	0x00090b01
    1d68:	02000001 	andeq	r0, r0, #1
    1d6c:	70137091 	mulsvc	r3, r1, r0
    1d70:	60000089 	andvs	r0, r0, r9, lsl #1
    1d74:	0d000000 	stceq	0, cr0, [r0, #-0]
    1d78:	1f010063 	svcne	0x00010063
    1d7c:	00006d08 	andeq	r6, r0, r8, lsl #26
    1d80:	6f910200 	svcvs	0x00910200
    1d84:	22000000 	andcs	r0, r0, #0
    1d88:	02000000 	andeq	r0, r0, #0
    1d8c:	0007fd00 	andeq	pc, r7, r0, lsl #26
    1d90:	65010400 	strvs	r0, [r1, #-1024]	; 0xfffffc00
    1d94:	d400000b 	strle	r0, [r0], #-11
    1d98:	e0000094 	mul	r0, r4, r0
    1d9c:	cb000096 	blgt	1ffc <shift+0x1ffc>
    1da0:	fb000011 	blx	1dee <shift+0x1dee>
    1da4:	63000011 	movwvs	r0, #17
    1da8:	01000012 	tsteq	r0, r2, lsl r0
    1dac:	00002280 	andeq	r2, r0, r0, lsl #5
    1db0:	11000200 	mrsne	r0, R8_usr
    1db4:	04000008 	streq	r0, [r0], #-8
    1db8:	000be201 	andeq	lr, fp, r1, lsl #4
    1dbc:	0096e000 	addseq	lr, r6, r0
    1dc0:	0096e400 	addseq	lr, r6, r0, lsl #8
    1dc4:	0011cb00 	andseq	ip, r1, r0, lsl #22
    1dc8:	0011fb00 	andseq	pc, r1, r0, lsl #22
    1dcc:	00126300 	andseq	r6, r2, r0, lsl #6
    1dd0:	22800100 	addcs	r0, r0, #0, 2
    1dd4:	02000000 	andeq	r0, r0, #0
    1dd8:	00082500 	andeq	r2, r8, r0, lsl #10
    1ddc:	42010400 	andmi	r0, r1, #0, 8
    1de0:	e400000c 	str	r0, [r0], #-12
    1de4:	34000096 	strcc	r0, [r0], #-150	; 0xffffff6a
    1de8:	6f000099 	svcvs	0x00000099
    1dec:	fb000012 	blx	1e3e <shift+0x1e3e>
    1df0:	63000011 	movwvs	r0, #17
    1df4:	01000012 	tsteq	r0, r2, lsl r0
    1df8:	00002280 	andeq	r2, r0, r0, lsl #5
    1dfc:	39000200 	stmdbcc	r0, {r9}
    1e00:	04000008 	streq	r0, [r0], #-8
    1e04:	000d4101 	andeq	r4, sp, r1, lsl #2
    1e08:	00993400 	addseq	r3, r9, r0, lsl #8
    1e0c:	009a0800 	addseq	r0, sl, r0, lsl #16
    1e10:	0012a000 	andseq	sl, r2, r0
    1e14:	0011fb00 	andseq	pc, r1, r0, lsl #22
    1e18:	00126300 	andseq	r6, r2, r0, lsl #6
    1e1c:	2a800100 	bcs	fe002224 <__bss_end+0xfdff858c>
    1e20:	04000003 	streq	r0, [r0], #-3
    1e24:	00084d00 	andeq	r4, r8, r0, lsl #26
    1e28:	ec010400 	cfstrs	mvf0, [r1], {-0}
    1e2c:	0c000013 	stceq	0, cr0, [r0], {19}
    1e30:	000015a5 	andeq	r1, r0, r5, lsr #11
    1e34:	000011fb 	strdeq	r1, [r0], -fp
    1e38:	00000dbf 			; <UNDEFINED> instruction: 0x00000dbf
    1e3c:	69050402 	stmdbvs	r5, {r1, sl}
    1e40:	0300746e 	movweq	r7, #1134	; 0x46e
    1e44:	15ee0704 	strbne	r0, [lr, #1796]!	; 0x704
    1e48:	08030000 	stmdaeq	r3, {}	; <UNPREDICTABLE>
    1e4c:	00024305 	andeq	r4, r2, r5, lsl #6
    1e50:	04080300 	streq	r0, [r8], #-768	; 0xfffffd00
    1e54:	00001599 	muleq	r0, r9, r5
    1e58:	b4080103 	strlt	r0, [r8], #-259	; 0xfffffefd
    1e5c:	0300000a 	movweq	r0, #10
    1e60:	0ab60601 	beq	fed8366c <__bss_end+0xfed799d4>
    1e64:	71040000 	mrsvc	r0, (UNDEF: 4)
    1e68:	07000017 	smladeq	r0, r7, r0, r0
    1e6c:	00003901 	andeq	r3, r0, r1, lsl #18
    1e70:	06170100 	ldreq	r0, [r7], -r0, lsl #2
    1e74:	000001d4 	ldrdeq	r0, [r0], -r4
    1e78:	0012fb05 	andseq	pc, r2, r5, lsl #22
    1e7c:	20050000 	andcs	r0, r5, r0
    1e80:	01000018 	tsteq	r0, r8, lsl r0
    1e84:	0014ce05 	andseq	ip, r4, r5, lsl #28
    1e88:	8c050200 	sfmhi	f0, 4, [r5], {-0}
    1e8c:	03000015 	movweq	r0, #21
    1e90:	00178a05 	andseq	r8, r7, r5, lsl #20
    1e94:	30050400 	andcc	r0, r5, r0, lsl #8
    1e98:	05000018 	streq	r0, [r0, #-24]	; 0xffffffe8
    1e9c:	0017a005 	andseq	sl, r7, r5
    1ea0:	d5050600 	strle	r0, [r5, #-1536]	; 0xfffffa00
    1ea4:	07000015 	smladeq	r0, r5, r0, r0
    1ea8:	00171b05 	andseq	r1, r7, r5, lsl #22
    1eac:	29050800 	stmdbcs	r5, {fp}
    1eb0:	09000017 	stmdbeq	r0, {r0, r1, r2, r4}
    1eb4:	00173705 	andseq	r3, r7, r5, lsl #14
    1eb8:	3e050a00 	vmlacc.f32	s0, s10, s0
    1ebc:	0b000016 	bleq	1f1c <shift+0x1f1c>
    1ec0:	00162e05 	andseq	r2, r6, r5, lsl #28
    1ec4:	17050c00 	strne	r0, [r5, -r0, lsl #24]
    1ec8:	0d000013 	stceq	0, cr0, [r0, #-76]	; 0xffffffb4
    1ecc:	00133005 	andseq	r3, r3, r5
    1ed0:	1f050e00 	svcne	0x00050e00
    1ed4:	0f000016 	svceq	0x00000016
    1ed8:	0017e305 	andseq	lr, r7, r5, lsl #6
    1edc:	60051000 	andvs	r1, r5, r0
    1ee0:	11000017 	tstne	r0, r7, lsl r0
    1ee4:	0017d405 	andseq	sp, r7, r5, lsl #8
    1ee8:	dd051200 	sfmle	f1, 4, [r5, #-0]
    1eec:	13000013 	movwne	r0, #19
    1ef0:	00135a05 	andseq	r5, r3, r5, lsl #20
    1ef4:	24051400 	strcs	r1, [r5], #-1024	; 0xfffffc00
    1ef8:	15000013 	strne	r0, [r0, #-19]	; 0xffffffed
    1efc:	0016bd05 	andseq	fp, r6, r5, lsl #26
    1f00:	91051600 	tstls	r5, r0, lsl #12
    1f04:	17000013 	smladne	r0, r3, r0, r0
    1f08:	0012cc05 	andseq	ip, r2, r5, lsl #24
    1f0c:	c6051800 	strgt	r1, [r5], -r0, lsl #16
    1f10:	19000017 	stmdbne	r0, {r0, r1, r2, r4}
    1f14:	0015fb05 	andseq	pc, r5, r5, lsl #22
    1f18:	d5051a00 	strle	r1, [r5, #-2560]	; 0xfffff600
    1f1c:	1b000016 	blne	1f7c <shift+0x1f7c>
    1f20:	00136505 	andseq	r6, r3, r5, lsl #10
    1f24:	71051c00 	tstvc	r5, r0, lsl #24
    1f28:	1d000015 	stcne	0, cr0, [r0, #-84]	; 0xffffffac
    1f2c:	0014c005 	andseq	ip, r4, r5
    1f30:	52051e00 	andpl	r1, r5, #0, 28
    1f34:	1f000017 	svcne	0x00000017
    1f38:	0017ae05 	andseq	sl, r7, r5, lsl #28
    1f3c:	ef052000 	svc	0x00052000
    1f40:	21000017 	tstcs	r0, r7, lsl r0
    1f44:	0017fd05 	andseq	pc, r7, r5, lsl #26
    1f48:	12052200 	andne	r2, r5, #0, 4
    1f4c:	23000016 	movwcs	r0, #22
    1f50:	00153505 	andseq	r3, r5, r5, lsl #10
    1f54:	74052400 	strvc	r2, [r5], #-1024	; 0xfffffc00
    1f58:	25000013 	strcs	r0, [r0, #-19]	; 0xffffffed
    1f5c:	0015c805 	andseq	ip, r5, r5, lsl #16
    1f60:	da052600 	ble	14b768 <__bss_end+0x141ad0>
    1f64:	27000014 	smladcs	r0, r4, r0, r0
    1f68:	00177d05 	andseq	r7, r7, r5, lsl #26
    1f6c:	ea052800 	b	14bf74 <__bss_end+0x1422dc>
    1f70:	29000014 	stmdbcs	r0, {r2, r4}
    1f74:	0014f905 	andseq	pc, r4, r5, lsl #18
    1f78:	08052a00 	stmdaeq	r5, {r9, fp, sp}
    1f7c:	2b000015 	blcs	1fd8 <shift+0x1fd8>
    1f80:	00151705 	andseq	r1, r5, r5, lsl #14
    1f84:	a5052c00 	strge	r2, [r5, #-3072]	; 0xfffff400
    1f88:	2d000014 	stccs	0, cr0, [r0, #-80]	; 0xffffffb0
    1f8c:	00152605 	andseq	r2, r5, r5, lsl #12
    1f90:	0c052e00 	stceq	14, cr2, [r5], {-0}
    1f94:	2f000017 	svccs	0x00000017
    1f98:	00154405 	andseq	r4, r5, r5, lsl #8
    1f9c:	53053000 	movwpl	r3, #20480	; 0x5000
    1fa0:	31000015 	tstcc	r0, r5, lsl r0
    1fa4:	00130505 	andseq	r0, r3, r5, lsl #10
    1fa8:	5d053200 	sfmpl	f3, 4, [r5, #-0]
    1fac:	33000016 	movwcc	r0, #22
    1fb0:	00166d05 	andseq	r6, r6, r5, lsl #26
    1fb4:	7d053400 	cfstrsvc	mvf3, [r5, #-0]
    1fb8:	35000016 	strcc	r0, [r0, #-22]	; 0xffffffea
    1fbc:	00149305 	andseq	r9, r4, r5, lsl #6
    1fc0:	8d053600 	stchi	6, cr3, [r5, #-0]
    1fc4:	37000016 	smladcc	r0, r6, r0, r0
    1fc8:	00169d05 	andseq	r9, r6, r5, lsl #26
    1fcc:	ad053800 	stcge	8, cr3, [r5, #-0]
    1fd0:	39000016 	stmdbcc	r0, {r1, r2, r4}
    1fd4:	00138405 	andseq	r8, r3, r5, lsl #8
    1fd8:	3d053a00 	vstrcc	s6, [r5, #-0]
    1fdc:	3b000013 	blcc	2030 <shift+0x2030>
    1fe0:	00156205 	andseq	r6, r5, r5, lsl #4
    1fe4:	dc053c00 	stcle	12, cr3, [r5], {-0}
    1fe8:	3d000012 	stccc	0, cr0, [r0, #-72]	; 0xffffffb8
    1fec:	0016c805 	andseq	ip, r6, r5, lsl #16
    1ff0:	06003e00 	streq	r3, [r0], -r0, lsl #28
    1ff4:	000013c4 	andeq	r1, r0, r4, asr #7
    1ff8:	026b0102 	rsbeq	r0, fp, #-2147483648	; 0x80000000
    1ffc:	0001ff08 	andeq	pc, r1, r8, lsl #30
    2000:	15870700 	strne	r0, [r7, #1792]	; 0x700
    2004:	70010000 	andvc	r0, r1, r0
    2008:	00471402 	subeq	r1, r7, r2, lsl #8
    200c:	07000000 	streq	r0, [r0, -r0]
    2010:	000014a0 	andeq	r1, r0, r0, lsr #9
    2014:	14027101 	strne	r7, [r2], #-257	; 0xfffffeff
    2018:	00000047 	andeq	r0, r0, r7, asr #32
    201c:	d4080001 	strle	r0, [r8], #-1
    2020:	09000001 	stmdbeq	r0, {r0}
    2024:	000001ff 	strdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    2028:	00000214 	andeq	r0, r0, r4, lsl r2
    202c:	0000240a 	andeq	r2, r0, sl, lsl #8
    2030:	08001100 	stmdaeq	r0, {r8, ip}
    2034:	00000204 	andeq	r0, r0, r4, lsl #4
    2038:	00164b0b 	andseq	r4, r6, fp, lsl #22
    203c:	02740100 	rsbseq	r0, r4, #0, 2
    2040:	00021426 	andeq	r1, r2, r6, lsr #8
    2044:	3d3a2400 	cfldrscc	mvf2, [sl, #-0]
    2048:	3d0f3d0a 	stccc	13, cr3, [pc, #-40]	; 2028 <shift+0x2028>
    204c:	3d323d24 	ldccc	13, cr3, [r2, #-144]!	; 0xffffff70
    2050:	3d053d02 	stccc	13, cr3, [r5, #-8]
    2054:	3d0d3d13 	stccc	13, cr3, [sp, #-76]	; 0xffffffb4
    2058:	3d233d0c 	stccc	13, cr3, [r3, #-48]!	; 0xffffffd0
    205c:	3d263d11 	stccc	13, cr3, [r6, #-68]!	; 0xffffffbc
    2060:	3d173d01 	ldccc	13, cr3, [r7, #-4]
    2064:	3d093d08 	stccc	13, cr3, [r9, #-32]	; 0xffffffe0
    2068:	02030000 	andeq	r0, r3, #0
    206c:	000ba207 	andeq	sl, fp, r7, lsl #4
    2070:	08010300 	stmdaeq	r1, {r8, r9}
    2074:	00000abd 			; <UNDEFINED> instruction: 0x00000abd
    2078:	59040d0c 	stmdbpl	r4, {r2, r3, r8, sl, fp}
    207c:	0e000002 	cdpeq	0, 0, cr0, cr0, cr2, {0}
    2080:	0000180b 	andeq	r1, r0, fp, lsl #16
    2084:	00390107 	eorseq	r0, r9, r7, lsl #2
    2088:	f7020000 			; <UNDEFINED> instruction: 0xf7020000
    208c:	029e0604 	addseq	r0, lr, #4, 12	; 0x400000
    2090:	9e050000 	cdpls	0, 0, cr0, cr5, cr0, {0}
    2094:	00000013 	andeq	r0, r0, r3, lsl r0
    2098:	0013a905 	andseq	sl, r3, r5, lsl #18
    209c:	bb050100 	bllt	1424a4 <__bss_end+0x13880c>
    20a0:	02000013 	andeq	r0, r0, #19
    20a4:	0013d505 	andseq	sp, r3, r5, lsl #10
    20a8:	45050300 	strmi	r0, [r5, #-768]	; 0xfffffd00
    20ac:	04000017 	streq	r0, [r0], #-23	; 0xffffffe9
    20b0:	0014b405 	andseq	fp, r4, r5, lsl #8
    20b4:	fe050500 	cdp2	5, 0, cr0, cr5, cr0, {0}
    20b8:	06000016 			; <UNDEFINED> instruction: 0x06000016
    20bc:	05020300 	streq	r0, [r2, #-768]	; 0xfffffd00
    20c0:	00000963 	andeq	r0, r0, r3, ror #18
    20c4:	e4070803 	str	r0, [r7], #-2051	; 0xfffff7fd
    20c8:	03000015 	movweq	r0, #21
    20cc:	12f50404 	rscsne	r0, r5, #4, 8	; 0x4000000
    20d0:	08030000 	stmdaeq	r3, {}	; <UNPREDICTABLE>
    20d4:	0012ed03 	andseq	lr, r2, r3, lsl #26
    20d8:	04080300 	streq	r0, [r8], #-768	; 0xfffffd00
    20dc:	0000159e 	muleq	r0, lr, r5
    20e0:	ef031003 	svc	0x00031003
    20e4:	0f000016 	svceq	0x00000016
    20e8:	000016e6 	andeq	r1, r0, r6, ror #13
    20ec:	5a102a03 	bpl	40c900 <__bss_end+0x402c68>
    20f0:	09000002 	stmdbeq	r0, {r1}
    20f4:	000002c8 	andeq	r0, r0, r8, asr #5
    20f8:	000002df 	ldrdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    20fc:	0c110010 	ldceq	0, cr0, [r1], {16}
    2100:	03000003 	movweq	r0, #3
    2104:	02d4112f 	sbcseq	r1, r4, #-1073741813	; 0xc000000b
    2108:	00110000 	andseq	r0, r1, r0
    210c:	03000002 	movweq	r0, #2
    2110:	02d41130 	sbcseq	r1, r4, #48, 2
    2114:	c8090000 	stmdagt	r9, {}	; <UNPREDICTABLE>
    2118:	07000002 	streq	r0, [r0, -r2]
    211c:	0a000003 	beq	2130 <shift+0x2130>
    2120:	00000024 	andeq	r0, r0, r4, lsr #32
    2124:	df120001 	svcle	0x00120001
    2128:	04000002 	streq	r0, [r0], #-2
    212c:	f70a0933 			; <UNDEFINED> instruction: 0xf70a0933
    2130:	05000002 	streq	r0, [r0, #-2]
    2134:	009c8003 	addseq	r8, ip, r3
    2138:	02eb1200 	rsceq	r1, fp, #0, 4
    213c:	34040000 	strcc	r0, [r4], #-0
    2140:	02f70a09 	rscseq	r0, r7, #36864	; 0x9000
    2144:	03050000 	movweq	r0, #20480	; 0x5000
    2148:	00009c80 	andeq	r9, r0, r0, lsl #25
    214c:	00030600 	andeq	r0, r3, r0, lsl #12
    2150:	3a000400 	bcc	3158 <shift+0x3158>
    2154:	04000009 	streq	r0, [r0], #-9
    2158:	0013ec01 	andseq	lr, r3, r1, lsl #24
    215c:	15a50c00 	strne	r0, [r5, #3072]!	; 0xc00
    2160:	11fb0000 	mvnsne	r0, r0
    2164:	9a080000 	bls	20216c <__bss_end+0x1f84d4>
    2168:	00300000 	eorseq	r0, r0, r0
    216c:	0e670000 	cdpeq	0, 6, cr0, cr7, cr0, {0}
    2170:	04020000 	streq	r0, [r2], #-0
    2174:	0012f504 	andseq	pc, r2, r4, lsl #10
    2178:	05040300 	streq	r0, [r4, #-768]	; 0xfffffd00
    217c:	00746e69 	rsbseq	r6, r4, r9, ror #28
    2180:	ee070402 	cdp	4, 0, cr0, cr7, cr2, {0}
    2184:	02000015 	andeq	r0, r0, #21
    2188:	02430508 	subeq	r0, r3, #8, 10	; 0x2000000
    218c:	08020000 	stmdaeq	r2, {}	; <UNPREDICTABLE>
    2190:	00159904 	andseq	r9, r5, r4, lsl #18
    2194:	08010200 	stmdaeq	r1, {r9}
    2198:	00000ab4 			; <UNDEFINED> instruction: 0x00000ab4
    219c:	b6060102 	strlt	r0, [r6], -r2, lsl #2
    21a0:	0400000a 	streq	r0, [r0], #-10
    21a4:	00001771 	andeq	r1, r0, r1, ror r7
    21a8:	00480107 	subeq	r0, r8, r7, lsl #2
    21ac:	17020000 	strne	r0, [r2, -r0]
    21b0:	0001e306 	andeq	lr, r1, r6, lsl #6
    21b4:	12fb0500 	rscsne	r0, fp, #0, 10
    21b8:	05000000 	streq	r0, [r0, #-0]
    21bc:	00001820 	andeq	r1, r0, r0, lsr #16
    21c0:	14ce0501 	strbne	r0, [lr], #1281	; 0x501
    21c4:	05020000 	streq	r0, [r2, #-0]
    21c8:	0000158c 	andeq	r1, r0, ip, lsl #11
    21cc:	178a0503 	strne	r0, [sl, r3, lsl #10]
    21d0:	05040000 	streq	r0, [r4, #-0]
    21d4:	00001830 	andeq	r1, r0, r0, lsr r8
    21d8:	17a00505 	strne	r0, [r0, r5, lsl #10]!
    21dc:	05060000 	streq	r0, [r6, #-0]
    21e0:	000015d5 	ldrdeq	r1, [r0], -r5
    21e4:	171b0507 	ldrne	r0, [fp, -r7, lsl #10]
    21e8:	05080000 	streq	r0, [r8, #-0]
    21ec:	00001729 	andeq	r1, r0, r9, lsr #14
    21f0:	17370509 	ldrne	r0, [r7, -r9, lsl #10]!
    21f4:	050a0000 	streq	r0, [sl, #-0]
    21f8:	0000163e 	andeq	r1, r0, lr, lsr r6
    21fc:	162e050b 	strtne	r0, [lr], -fp, lsl #10
    2200:	050c0000 	streq	r0, [ip, #-0]
    2204:	00001317 	andeq	r1, r0, r7, lsl r3
    2208:	1330050d 	teqne	r0, #54525952	; 0x3400000
    220c:	050e0000 	streq	r0, [lr, #-0]
    2210:	0000161f 	andeq	r1, r0, pc, lsl r6
    2214:	17e3050f 	strbne	r0, [r3, pc, lsl #10]!
    2218:	05100000 	ldreq	r0, [r0, #-0]
    221c:	00001760 	andeq	r1, r0, r0, ror #14
    2220:	17d40511 	bfine	r0, r1, #10, #11
    2224:	05120000 	ldreq	r0, [r2, #-0]
    2228:	000013dd 	ldrdeq	r1, [r0], -sp
    222c:	135a0513 	cmpne	sl, #79691776	; 0x4c00000
    2230:	05140000 	ldreq	r0, [r4, #-0]
    2234:	00001324 	andeq	r1, r0, r4, lsr #6
    2238:	16bd0515 	ssatne	r0, #30, r5, lsl #10
    223c:	05160000 	ldreq	r0, [r6, #-0]
    2240:	00001391 	muleq	r0, r1, r3
    2244:	12cc0517 	sbcne	r0, ip, #96468992	; 0x5c00000
    2248:	05180000 	ldreq	r0, [r8, #-0]
    224c:	000017c6 	andeq	r1, r0, r6, asr #15
    2250:	15fb0519 	ldrbne	r0, [fp, #1305]!	; 0x519
    2254:	051a0000 	ldreq	r0, [sl, #-0]
    2258:	000016d5 	ldrdeq	r1, [r0], -r5
    225c:	1365051b 	cmnne	r5, #113246208	; 0x6c00000
    2260:	051c0000 	ldreq	r0, [ip, #-0]
    2264:	00001571 	andeq	r1, r0, r1, ror r5
    2268:	14c0051d 	strbne	r0, [r0], #1309	; 0x51d
    226c:	051e0000 	ldreq	r0, [lr, #-0]
    2270:	00001752 	andeq	r1, r0, r2, asr r7
    2274:	17ae051f 			; <UNDEFINED> instruction: 0x17ae051f
    2278:	05200000 	streq	r0, [r0, #-0]!
    227c:	000017ef 	andeq	r1, r0, pc, ror #15
    2280:	17fd0521 	ldrbne	r0, [sp, r1, lsr #10]!
    2284:	05220000 	streq	r0, [r2, #-0]!
    2288:	00001612 	andeq	r1, r0, r2, lsl r6
    228c:	15350523 	ldrne	r0, [r5, #-1315]!	; 0xfffffadd
    2290:	05240000 	streq	r0, [r4, #-0]!
    2294:	00001374 	andeq	r1, r0, r4, ror r3
    2298:	15c80525 	strbne	r0, [r8, #1317]	; 0x525
    229c:	05260000 	streq	r0, [r6, #-0]!
    22a0:	000014da 	ldrdeq	r1, [r0], -sl
    22a4:	177d0527 	ldrbne	r0, [sp, -r7, lsr #10]!
    22a8:	05280000 	streq	r0, [r8, #-0]!
    22ac:	000014ea 	andeq	r1, r0, sl, ror #9
    22b0:	14f90529 	ldrbtne	r0, [r9], #1321	; 0x529
    22b4:	052a0000 	streq	r0, [sl, #-0]!
    22b8:	00001508 	andeq	r1, r0, r8, lsl #10
    22bc:	1517052b 	ldrne	r0, [r7, #-1323]	; 0xfffffad5
    22c0:	052c0000 	streq	r0, [ip, #-0]!
    22c4:	000014a5 	andeq	r1, r0, r5, lsr #9
    22c8:	1526052d 	strne	r0, [r6, #-1325]!	; 0xfffffad3
    22cc:	052e0000 	streq	r0, [lr, #-0]!
    22d0:	0000170c 	andeq	r1, r0, ip, lsl #14
    22d4:	1544052f 	strbne	r0, [r4, #-1327]	; 0xfffffad1
    22d8:	05300000 	ldreq	r0, [r0, #-0]!
    22dc:	00001553 	andeq	r1, r0, r3, asr r5
    22e0:	13050531 	movwne	r0, #21809	; 0x5531
    22e4:	05320000 	ldreq	r0, [r2, #-0]!
    22e8:	0000165d 	andeq	r1, r0, sp, asr r6
    22ec:	166d0533 			; <UNDEFINED> instruction: 0x166d0533
    22f0:	05340000 	ldreq	r0, [r4, #-0]!
    22f4:	0000167d 	andeq	r1, r0, sp, ror r6
    22f8:	14930535 	ldrne	r0, [r3], #1333	; 0x535
    22fc:	05360000 	ldreq	r0, [r6, #-0]!
    2300:	0000168d 	andeq	r1, r0, sp, lsl #13
    2304:	169d0537 			; <UNDEFINED> instruction: 0x169d0537
    2308:	05380000 	ldreq	r0, [r8, #-0]!
    230c:	000016ad 	andeq	r1, r0, sp, lsr #13
    2310:	13840539 	orrne	r0, r4, #239075328	; 0xe400000
    2314:	053a0000 	ldreq	r0, [sl, #-0]!
    2318:	0000133d 	andeq	r1, r0, sp, lsr r3
    231c:	1562053b 	strbne	r0, [r2, #-1339]!	; 0xfffffac5
    2320:	053c0000 	ldreq	r0, [ip, #-0]!
    2324:	000012dc 	ldrdeq	r1, [r0], -ip
    2328:	16c8053d 			; <UNDEFINED> instruction: 0x16c8053d
    232c:	003e0000 	eorseq	r0, lr, r0
    2330:	0013c406 	andseq	ip, r3, r6, lsl #8
    2334:	6b020200 	blvs	82b3c <__bss_end+0x78ea4>
    2338:	020e0802 	andeq	r0, lr, #131072	; 0x20000
    233c:	87070000 	strhi	r0, [r7, -r0]
    2340:	02000015 	andeq	r0, r0, #21
    2344:	56140270 			; <UNDEFINED> instruction: 0x56140270
    2348:	00000000 	andeq	r0, r0, r0
    234c:	0014a007 	andseq	sl, r4, r7
    2350:	02710200 	rsbseq	r0, r1, #0, 4
    2354:	00005614 	andeq	r5, r0, r4, lsl r6
    2358:	08000100 	stmdaeq	r0, {r8}
    235c:	000001e3 	andeq	r0, r0, r3, ror #3
    2360:	00020e09 	andeq	r0, r2, r9, lsl #28
    2364:	00022300 	andeq	r2, r2, r0, lsl #6
    2368:	00330a00 	eorseq	r0, r3, r0, lsl #20
    236c:	00110000 	andseq	r0, r1, r0
    2370:	00021308 	andeq	r1, r2, r8, lsl #6
    2374:	164b0b00 	strbne	r0, [fp], -r0, lsl #22
    2378:	74020000 	strvc	r0, [r2], #-0
    237c:	02232602 	eoreq	r2, r3, #2097152	; 0x200000
    2380:	3a240000 	bcc	902388 <__bss_end+0x8f86f0>
    2384:	0f3d0a3d 	svceq	0x003d0a3d
    2388:	323d243d 	eorscc	r2, sp, #1023410176	; 0x3d000000
    238c:	053d023d 	ldreq	r0, [sp, #-573]!	; 0xfffffdc3
    2390:	0d3d133d 	ldceq	3, cr1, [sp, #-244]!	; 0xffffff0c
    2394:	233d0c3d 	teqcs	sp, #15616	; 0x3d00
    2398:	263d113d 			; <UNDEFINED> instruction: 0x263d113d
    239c:	173d013d 			; <UNDEFINED> instruction: 0x173d013d
    23a0:	093d083d 	ldmdbeq	sp!, {r0, r2, r3, r4, r5, fp}
    23a4:	0200003d 	andeq	r0, r0, #61	; 0x3d
    23a8:	0ba20702 	bleq	fe883fb8 <__bss_end+0xfe87a320>
    23ac:	01020000 	mrseq	r0, (UNDEF: 2)
    23b0:	000abd08 	andeq	fp, sl, r8, lsl #26
    23b4:	05020200 	streq	r0, [r2, #-512]	; 0xfffffe00
    23b8:	00000963 	andeq	r0, r0, r3, ror #18
    23bc:	00187c0c 	andseq	r7, r8, ip, lsl #24
    23c0:	0f840300 	svceq	0x00840300
    23c4:	0000003a 	andeq	r0, r0, sl, lsr r0
    23c8:	e4070802 	str	r0, [r7], #-2050	; 0xfffff7fe
    23cc:	0c000015 	stceq	0, cr0, [r0], {21}
    23d0:	0000184d 	andeq	r1, r0, sp, asr #16
    23d4:	25109303 	ldrcs	r9, [r0, #-771]	; 0xfffffcfd
    23d8:	02000000 	andeq	r0, r0, #0
    23dc:	12ed0308 	rscne	r0, sp, #8, 6	; 0x20000000
    23e0:	08020000 	stmdaeq	r2, {}	; <UNPREDICTABLE>
    23e4:	00159e04 	andseq	r9, r5, r4, lsl #28
    23e8:	03100200 	tsteq	r0, #0, 4
    23ec:	000016ef 	andeq	r1, r0, pc, ror #13
    23f0:	0018620d 	andseq	r6, r8, sp, lsl #4
    23f4:	05f90100 	ldrbeq	r0, [r9, #256]!	; 0x100
    23f8:	00026f01 	andeq	r6, r2, r1, lsl #30
    23fc:	009a0800 	addseq	r0, sl, r0, lsl #16
    2400:	00003000 	andeq	r3, r0, r0
    2404:	fd9c0100 	ldc2	1, cr0, [ip]
    2408:	0e000002 	cdpeq	0, 0, cr0, cr0, cr2, {0}
    240c:	f9010061 			; <UNDEFINED> instruction: 0xf9010061
    2410:	02821305 	addeq	r1, r2, #335544320	; 0x14000000
    2414:	00080000 	andeq	r0, r8, r0
    2418:	00000000 	andeq	r0, r0, r0
    241c:	1c0f0000 	stcne	0, cr0, [pc], {-0}
    2420:	fd00009a 	stc2	0, cr0, [r0, #-616]	; 0xfffffd98
    2424:	e8000002 	stmda	r0, {r1}
    2428:	10000002 	andne	r0, r0, r2
    242c:	f3055001 	vhadd.u8	d5, d5, d1
    2430:	2500f503 	strcs	pc, [r0, #-1283]	; 0xfffffafd
    2434:	9a2c1100 	bls	b0683c <__bss_end+0xafcba4>
    2438:	02fd0000 	rscseq	r0, sp, #0
    243c:	01100000 	tsteq	r0, r0
    2440:	03f30650 	mvnseq	r0, #80, 12	; 0x5000000
    2444:	1f2500f5 	svcne	0x002500f5
    2448:	54120000 	ldrpl	r0, [r2], #-0
    244c:	40000018 	andmi	r0, r0, r8, lsl r0
    2450:	01000018 	tsteq	r0, r8, lsl r0
    2454:	2a00033b 	bcs	3148 <shift+0x3148>
    2458:	04000003 	streq	r0, [r0], #-3
    245c:	000a4900 	andeq	r4, sl, r0, lsl #18
    2460:	ec010400 	cfstrs	mvf0, [r1], {-0}
    2464:	0c000013 	stceq	0, cr0, [r0], {19}
    2468:	000015a5 	andeq	r1, r0, r5, lsr #11
    246c:	000011fb 	strdeq	r1, [r0], -fp
    2470:	00009a38 	andeq	r9, r0, r8, lsr sl
    2474:	00000040 	andeq	r0, r0, r0, asr #32
    2478:	00000f12 	andeq	r0, r0, r2, lsl pc
    247c:	9e040802 	cdpls	8, 0, cr0, cr4, cr2, {0}
    2480:	02000015 	andeq	r0, r0, #21
    2484:	15ee0704 	strbne	r0, [lr, #1796]!	; 0x704
    2488:	04020000 	streq	r0, [r2], #-0
    248c:	0012f504 	andseq	pc, r2, r4, lsl #10
    2490:	05040300 	streq	r0, [r4, #-768]	; 0xfffffd00
    2494:	00746e69 	rsbseq	r6, r4, r9, ror #28
    2498:	43050802 	movwmi	r0, #22530	; 0x5802
    249c:	02000002 	andeq	r0, r0, #2
    24a0:	15990408 	ldrne	r0, [r9, #1032]	; 0x408
    24a4:	01020000 	mrseq	r0, (UNDEF: 2)
    24a8:	000ab408 	andeq	fp, sl, r8, lsl #8
    24ac:	06010200 	streq	r0, [r1], -r0, lsl #4
    24b0:	00000ab6 			; <UNDEFINED> instruction: 0x00000ab6
    24b4:	00177104 	andseq	r7, r7, r4, lsl #2
    24b8:	4f010700 	svcmi	0x00010700
    24bc:	02000000 	andeq	r0, r0, #0
    24c0:	01ea0617 	mvneq	r0, r7, lsl r6
    24c4:	fb050000 	blx	1424ce <__bss_end+0x138836>
    24c8:	00000012 	andeq	r0, r0, r2, lsl r0
    24cc:	00182005 	andseq	r2, r8, r5
    24d0:	ce050100 	adfgts	f0, f5, f0
    24d4:	02000014 	andeq	r0, r0, #20
    24d8:	00158c05 	andseq	r8, r5, r5, lsl #24
    24dc:	8a050300 	bhi	1430e4 <__bss_end+0x13944c>
    24e0:	04000017 	streq	r0, [r0], #-23	; 0xffffffe9
    24e4:	00183005 	andseq	r3, r8, r5
    24e8:	a0050500 	andge	r0, r5, r0, lsl #10
    24ec:	06000017 			; <UNDEFINED> instruction: 0x06000017
    24f0:	0015d505 	andseq	sp, r5, r5, lsl #10
    24f4:	1b050700 	blne	1440fc <__bss_end+0x13a464>
    24f8:	08000017 	stmdaeq	r0, {r0, r1, r2, r4}
    24fc:	00172905 	andseq	r2, r7, r5, lsl #18
    2500:	37050900 	strcc	r0, [r5, -r0, lsl #18]
    2504:	0a000017 	beq	2568 <shift+0x2568>
    2508:	00163e05 	andseq	r3, r6, r5, lsl #28
    250c:	2e050b00 	vmlacs.f64	d0, d5, d0
    2510:	0c000016 	stceq	0, cr0, [r0], {22}
    2514:	00131705 	andseq	r1, r3, r5, lsl #14
    2518:	30050d00 	andcc	r0, r5, r0, lsl #26
    251c:	0e000013 	mcreq	0, 0, r0, cr0, cr3, {0}
    2520:	00161f05 	andseq	r1, r6, r5, lsl #30
    2524:	e3050f00 	movw	r0, #24320	; 0x5f00
    2528:	10000017 	andne	r0, r0, r7, lsl r0
    252c:	00176005 	andseq	r6, r7, r5
    2530:	d4051100 	strle	r1, [r5], #-256	; 0xffffff00
    2534:	12000017 	andne	r0, r0, #23
    2538:	0013dd05 	andseq	sp, r3, r5, lsl #26
    253c:	5a051300 	bpl	147144 <__bss_end+0x13d4ac>
    2540:	14000013 	strne	r0, [r0], #-19	; 0xffffffed
    2544:	00132405 	andseq	r2, r3, r5, lsl #8
    2548:	bd051500 	cfstr32lt	mvfx1, [r5, #-0]
    254c:	16000016 			; <UNDEFINED> instruction: 0x16000016
    2550:	00139105 	andseq	r9, r3, r5, lsl #2
    2554:	cc051700 	stcgt	7, cr1, [r5], {-0}
    2558:	18000012 	stmdane	r0, {r1, r4}
    255c:	0017c605 	andseq	ip, r7, r5, lsl #12
    2560:	fb051900 	blx	14896a <__bss_end+0x13ecd2>
    2564:	1a000015 	bne	25c0 <shift+0x25c0>
    2568:	0016d505 	andseq	sp, r6, r5, lsl #10
    256c:	65051b00 	strvs	r1, [r5, #-2816]	; 0xfffff500
    2570:	1c000013 	stcne	0, cr0, [r0], {19}
    2574:	00157105 	andseq	r7, r5, r5, lsl #2
    2578:	c0051d00 	andgt	r1, r5, r0, lsl #26
    257c:	1e000014 	mcrne	0, 0, r0, cr0, cr4, {0}
    2580:	00175205 	andseq	r5, r7, r5, lsl #4
    2584:	ae051f00 	cdpge	15, 0, cr1, cr5, cr0, {0}
    2588:	20000017 	andcs	r0, r0, r7, lsl r0
    258c:	0017ef05 	andseq	lr, r7, r5, lsl #30
    2590:	fd052100 	stc2	1, cr2, [r5, #-0]
    2594:	22000017 	andcs	r0, r0, #23
    2598:	00161205 	andseq	r1, r6, r5, lsl #4
    259c:	35052300 	strcc	r2, [r5, #-768]	; 0xfffffd00
    25a0:	24000015 	strcs	r0, [r0], #-21	; 0xffffffeb
    25a4:	00137405 	andseq	r7, r3, r5, lsl #8
    25a8:	c8052500 	stmdagt	r5, {r8, sl, sp}
    25ac:	26000015 			; <UNDEFINED> instruction: 0x26000015
    25b0:	0014da05 	andseq	sp, r4, r5, lsl #20
    25b4:	7d052700 	stcvc	7, cr2, [r5, #-0]
    25b8:	28000017 	stmdacs	r0, {r0, r1, r2, r4}
    25bc:	0014ea05 	andseq	lr, r4, r5, lsl #20
    25c0:	f9052900 			; <UNDEFINED> instruction: 0xf9052900
    25c4:	2a000014 	bcs	261c <shift+0x261c>
    25c8:	00150805 	andseq	r0, r5, r5, lsl #16
    25cc:	17052b00 	strne	r2, [r5, -r0, lsl #22]
    25d0:	2c000015 	stccs	0, cr0, [r0], {21}
    25d4:	0014a505 	andseq	sl, r4, r5, lsl #10
    25d8:	26052d00 	strcs	r2, [r5], -r0, lsl #26
    25dc:	2e000015 	mcrcs	0, 0, r0, cr0, cr5, {0}
    25e0:	00170c05 	andseq	r0, r7, r5, lsl #24
    25e4:	44052f00 	strmi	r2, [r5], #-3840	; 0xfffff100
    25e8:	30000015 	andcc	r0, r0, r5, lsl r0
    25ec:	00155305 	andseq	r5, r5, r5, lsl #6
    25f0:	05053100 	streq	r3, [r5, #-256]	; 0xffffff00
    25f4:	32000013 	andcc	r0, r0, #19
    25f8:	00165d05 	andseq	r5, r6, r5, lsl #26
    25fc:	6d053300 	stcvs	3, cr3, [r5, #-0]
    2600:	34000016 	strcc	r0, [r0], #-22	; 0xffffffea
    2604:	00167d05 	andseq	r7, r6, r5, lsl #26
    2608:	93053500 	movwls	r3, #21760	; 0x5500
    260c:	36000014 			; <UNDEFINED> instruction: 0x36000014
    2610:	00168d05 	andseq	r8, r6, r5, lsl #26
    2614:	9d053700 	stcls	7, cr3, [r5, #-0]
    2618:	38000016 	stmdacc	r0, {r1, r2, r4}
    261c:	0016ad05 	andseq	sl, r6, r5, lsl #26
    2620:	84053900 	strhi	r3, [r5], #-2304	; 0xfffff700
    2624:	3a000013 	bcc	2678 <shift+0x2678>
    2628:	00133d05 	andseq	r3, r3, r5, lsl #26
    262c:	62053b00 	andvs	r3, r5, #0, 22
    2630:	3c000015 	stccc	0, cr0, [r0], {21}
    2634:	0012dc05 	andseq	sp, r2, r5, lsl #24
    2638:	c8053d00 	stmdagt	r5, {r8, sl, fp, ip, sp}
    263c:	3e000016 	mcrcc	0, 0, r0, cr0, cr6, {0}
    2640:	13c40600 	bicne	r0, r4, #0, 12
    2644:	02020000 	andeq	r0, r2, #0
    2648:	1508026b 	strne	r0, [r8, #-619]	; 0xfffffd95
    264c:	07000002 	streq	r0, [r0, -r2]
    2650:	00001587 	andeq	r1, r0, r7, lsl #11
    2654:	14027002 	strne	r7, [r2], #-2
    2658:	0000005d 	andeq	r0, r0, sp, asr r0
    265c:	14a00700 	strtne	r0, [r0], #1792	; 0x700
    2660:	71020000 	mrsvc	r0, (UNDEF: 2)
    2664:	005d1402 	subseq	r1, sp, r2, lsl #8
    2668:	00010000 	andeq	r0, r1, r0
    266c:	0001ea08 	andeq	lr, r1, r8, lsl #20
    2670:	02150900 	andseq	r0, r5, #0, 18
    2674:	022a0000 	eoreq	r0, sl, #0
    2678:	2c0a0000 	stccs	0, cr0, [sl], {-0}
    267c:	11000000 	mrsne	r0, (UNDEF: 0)
    2680:	021a0800 	andseq	r0, sl, #0, 16
    2684:	4b0b0000 	blmi	2c268c <__bss_end+0x2b89f4>
    2688:	02000016 	andeq	r0, r0, #22
    268c:	2a260274 	bcs	983064 <__bss_end+0x9793cc>
    2690:	24000002 	strcs	r0, [r0], #-2
    2694:	3d0a3d3a 	stccc	13, cr3, [sl, #-232]	; 0xffffff18
    2698:	3d243d0f 	stccc	13, cr3, [r4, #-60]!	; 0xffffffc4
    269c:	3d023d32 	stccc	13, cr3, [r2, #-200]	; 0xffffff38
    26a0:	3d133d05 	ldccc	13, cr3, [r3, #-20]	; 0xffffffec
    26a4:	3d0c3d0d 	stccc	13, cr3, [ip, #-52]	; 0xffffffcc
    26a8:	3d113d23 	ldccc	13, cr3, [r1, #-140]	; 0xffffff74
    26ac:	3d013d26 	stccc	13, cr3, [r1, #-152]	; 0xffffff68
    26b0:	3d083d17 	stccc	13, cr3, [r8, #-92]	; 0xffffffa4
    26b4:	00003d09 	andeq	r3, r0, r9, lsl #26
    26b8:	a2070202 	andge	r0, r7, #536870912	; 0x20000000
    26bc:	0200000b 	andeq	r0, r0, #11
    26c0:	0abd0801 	beq	fef446cc <__bss_end+0xfef3aa34>
    26c4:	02020000 	andeq	r0, r2, #0
    26c8:	00096305 	andeq	r6, r9, r5, lsl #6
    26cc:	18730c00 	ldmdane	r3!, {sl, fp}^
    26d0:	81030000 	mrshi	r0, (UNDEF: 3)
    26d4:	00002c16 	andeq	r2, r0, r6, lsl ip
    26d8:	02760800 	rsbseq	r0, r6, #0, 16
    26dc:	7b0c0000 	blvc	3026e4 <__bss_end+0x2f8a4c>
    26e0:	03000018 	movweq	r0, #24
    26e4:	02931685 	addseq	r1, r3, #139460608	; 0x8500000
    26e8:	08020000 	stmdaeq	r2, {}	; <UNPREDICTABLE>
    26ec:	0015e407 	andseq	lr, r5, r7, lsl #8
    26f0:	184d0c00 	stmdane	sp, {sl, fp}^
    26f4:	93030000 	movwls	r0, #12288	; 0x3000
    26f8:	00003310 	andeq	r3, r0, r0, lsl r3
    26fc:	03080200 	movweq	r0, #33280	; 0x8200
    2700:	000012ed 	andeq	r1, r0, sp, ror #5
    2704:	00186c0c 	andseq	r6, r8, ip, lsl #24
    2708:	10970300 	addsne	r0, r7, r0, lsl #6
    270c:	00000025 	andeq	r0, r0, r5, lsr #32
    2710:	0002ad08 	andeq	sl, r2, r8, lsl #26
    2714:	03100200 	tsteq	r0, #0, 4
    2718:	000016ef 	andeq	r1, r0, pc, ror #13
    271c:	0018400d 	andseq	r4, r8, sp
    2720:	05b90100 	ldreq	r0, [r9, #256]!	; 0x100
    2724:	00028701 	andeq	r8, r2, r1, lsl #14
    2728:	009a3800 	addseq	r3, sl, r0, lsl #16
    272c:	00004000 	andeq	r4, r0, r0
    2730:	0e9c0100 	fmleqe	f0, f4, f0
    2734:	b9010061 	stmdblt	r1, {r0, r5, r6}
    2738:	029a1605 	addseq	r1, sl, #5242880	; 0x500000
    273c:	004a0000 	subeq	r0, sl, r0
    2740:	00460000 	subeq	r0, r6, r0
    2744:	640f0000 	strvs	r0, [pc], #-0	; 274c <shift+0x274c>
    2748:	01006166 	tsteq	r0, r6, ror #2
    274c:	b91005bf 	ldmdblt	r0, {r0, r1, r2, r3, r4, r5, r7, r8, sl}
    2750:	73000002 	movwvc	r0, #2
    2754:	6d000000 	stcvs	0, cr0, [r0, #-0]
    2758:	0f000000 	svceq	0x00000000
    275c:	01006968 	tsteq	r0, r8, ror #18
    2760:	821005c4 	andshi	r0, r0, #196, 10	; 0x31000000
    2764:	b1000002 	tstlt	r0, r2
    2768:	af000000 	svcge	0x00000000
    276c:	0f000000 	svceq	0x00000000
    2770:	01006f6c 	tsteq	r0, ip, ror #30
    2774:	821005c9 	andshi	r0, r0, #843055104	; 0x32400000
    2778:	cb000002 	blgt	2788 <shift+0x2788>
    277c:	c5000000 	strgt	r0, [r0, #-0]
    2780:	00000000 	andeq	r0, r0, r0
    2784:	00038000 	andeq	r8, r3, r0
    2788:	30000400 	andcc	r0, r0, r0, lsl #8
    278c:	0400000b 	streq	r0, [r0], #-11
    2790:	00188301 	andseq	r8, r8, r1, lsl #6
    2794:	15a50c00 	strne	r0, [r5, #3072]!	; 0xc00
    2798:	11fb0000 	mvnsne	r0, r0
    279c:	9a780000 	bls	1e027a4 <__bss_end+0x1df8b0c>
    27a0:	01200000 			; <UNDEFINED> instruction: 0x01200000
    27a4:	0fcc0000 	svceq	0x00cc0000
    27a8:	08020000 	stmdaeq	r2, {}	; <UNPREDICTABLE>
    27ac:	0015e407 	andseq	lr, r5, r7, lsl #8
    27b0:	05040300 	streq	r0, [r4, #-768]	; 0xfffffd00
    27b4:	00746e69 	rsbseq	r6, r4, r9, ror #28
    27b8:	ee070402 	cdp	4, 0, cr0, cr7, cr2, {0}
    27bc:	02000015 	andeq	r0, r0, #21
    27c0:	02430508 	subeq	r0, r3, #8, 10	; 0x2000000
    27c4:	08020000 	stmdaeq	r2, {}	; <UNPREDICTABLE>
    27c8:	00159904 	andseq	r9, r5, r4, lsl #18
    27cc:	08010200 	stmdaeq	r1, {r9}
    27d0:	00000ab4 			; <UNDEFINED> instruction: 0x00000ab4
    27d4:	b6060102 	strlt	r0, [r6], -r2, lsl #2
    27d8:	0400000a 	streq	r0, [r0], #-10
    27dc:	00001771 	andeq	r1, r0, r1, ror r7
    27e0:	00480107 	subeq	r0, r8, r7, lsl #2
    27e4:	17020000 	strne	r0, [r2, -r0]
    27e8:	0001e306 	andeq	lr, r1, r6, lsl #6
    27ec:	12fb0500 	rscsne	r0, fp, #0, 10
    27f0:	05000000 	streq	r0, [r0, #-0]
    27f4:	00001820 	andeq	r1, r0, r0, lsr #16
    27f8:	14ce0501 	strbne	r0, [lr], #1281	; 0x501
    27fc:	05020000 	streq	r0, [r2, #-0]
    2800:	0000158c 	andeq	r1, r0, ip, lsl #11
    2804:	178a0503 	strne	r0, [sl, r3, lsl #10]
    2808:	05040000 	streq	r0, [r4, #-0]
    280c:	00001830 	andeq	r1, r0, r0, lsr r8
    2810:	17a00505 	strne	r0, [r0, r5, lsl #10]!
    2814:	05060000 	streq	r0, [r6, #-0]
    2818:	000015d5 	ldrdeq	r1, [r0], -r5
    281c:	171b0507 	ldrne	r0, [fp, -r7, lsl #10]
    2820:	05080000 	streq	r0, [r8, #-0]
    2824:	00001729 	andeq	r1, r0, r9, lsr #14
    2828:	17370509 	ldrne	r0, [r7, -r9, lsl #10]!
    282c:	050a0000 	streq	r0, [sl, #-0]
    2830:	0000163e 	andeq	r1, r0, lr, lsr r6
    2834:	162e050b 	strtne	r0, [lr], -fp, lsl #10
    2838:	050c0000 	streq	r0, [ip, #-0]
    283c:	00001317 	andeq	r1, r0, r7, lsl r3
    2840:	1330050d 	teqne	r0, #54525952	; 0x3400000
    2844:	050e0000 	streq	r0, [lr, #-0]
    2848:	0000161f 	andeq	r1, r0, pc, lsl r6
    284c:	17e3050f 	strbne	r0, [r3, pc, lsl #10]!
    2850:	05100000 	ldreq	r0, [r0, #-0]
    2854:	00001760 	andeq	r1, r0, r0, ror #14
    2858:	17d40511 	bfine	r0, r1, #10, #11
    285c:	05120000 	ldreq	r0, [r2, #-0]
    2860:	000013dd 	ldrdeq	r1, [r0], -sp
    2864:	135a0513 	cmpne	sl, #79691776	; 0x4c00000
    2868:	05140000 	ldreq	r0, [r4, #-0]
    286c:	00001324 	andeq	r1, r0, r4, lsr #6
    2870:	16bd0515 	ssatne	r0, #30, r5, lsl #10
    2874:	05160000 	ldreq	r0, [r6, #-0]
    2878:	00001391 	muleq	r0, r1, r3
    287c:	12cc0517 	sbcne	r0, ip, #96468992	; 0x5c00000
    2880:	05180000 	ldreq	r0, [r8, #-0]
    2884:	000017c6 	andeq	r1, r0, r6, asr #15
    2888:	15fb0519 	ldrbne	r0, [fp, #1305]!	; 0x519
    288c:	051a0000 	ldreq	r0, [sl, #-0]
    2890:	000016d5 	ldrdeq	r1, [r0], -r5
    2894:	1365051b 	cmnne	r5, #113246208	; 0x6c00000
    2898:	051c0000 	ldreq	r0, [ip, #-0]
    289c:	00001571 	andeq	r1, r0, r1, ror r5
    28a0:	14c0051d 	strbne	r0, [r0], #1309	; 0x51d
    28a4:	051e0000 	ldreq	r0, [lr, #-0]
    28a8:	00001752 	andeq	r1, r0, r2, asr r7
    28ac:	17ae051f 			; <UNDEFINED> instruction: 0x17ae051f
    28b0:	05200000 	streq	r0, [r0, #-0]!
    28b4:	000017ef 	andeq	r1, r0, pc, ror #15
    28b8:	17fd0521 	ldrbne	r0, [sp, r1, lsr #10]!
    28bc:	05220000 	streq	r0, [r2, #-0]!
    28c0:	00001612 	andeq	r1, r0, r2, lsl r6
    28c4:	15350523 	ldrne	r0, [r5, #-1315]!	; 0xfffffadd
    28c8:	05240000 	streq	r0, [r4, #-0]!
    28cc:	00001374 	andeq	r1, r0, r4, ror r3
    28d0:	15c80525 	strbne	r0, [r8, #1317]	; 0x525
    28d4:	05260000 	streq	r0, [r6, #-0]!
    28d8:	000014da 	ldrdeq	r1, [r0], -sl
    28dc:	177d0527 	ldrbne	r0, [sp, -r7, lsr #10]!
    28e0:	05280000 	streq	r0, [r8, #-0]!
    28e4:	000014ea 	andeq	r1, r0, sl, ror #9
    28e8:	14f90529 	ldrbtne	r0, [r9], #1321	; 0x529
    28ec:	052a0000 	streq	r0, [sl, #-0]!
    28f0:	00001508 	andeq	r1, r0, r8, lsl #10
    28f4:	1517052b 	ldrne	r0, [r7, #-1323]	; 0xfffffad5
    28f8:	052c0000 	streq	r0, [ip, #-0]!
    28fc:	000014a5 	andeq	r1, r0, r5, lsr #9
    2900:	1526052d 	strne	r0, [r6, #-1325]!	; 0xfffffad3
    2904:	052e0000 	streq	r0, [lr, #-0]!
    2908:	0000170c 	andeq	r1, r0, ip, lsl #14
    290c:	1544052f 	strbne	r0, [r4, #-1327]	; 0xfffffad1
    2910:	05300000 	ldreq	r0, [r0, #-0]!
    2914:	00001553 	andeq	r1, r0, r3, asr r5
    2918:	13050531 	movwne	r0, #21809	; 0x5531
    291c:	05320000 	ldreq	r0, [r2, #-0]!
    2920:	0000165d 	andeq	r1, r0, sp, asr r6
    2924:	166d0533 			; <UNDEFINED> instruction: 0x166d0533
    2928:	05340000 	ldreq	r0, [r4, #-0]!
    292c:	0000167d 	andeq	r1, r0, sp, ror r6
    2930:	14930535 	ldrne	r0, [r3], #1333	; 0x535
    2934:	05360000 	ldreq	r0, [r6, #-0]!
    2938:	0000168d 	andeq	r1, r0, sp, lsl #13
    293c:	169d0537 			; <UNDEFINED> instruction: 0x169d0537
    2940:	05380000 	ldreq	r0, [r8, #-0]!
    2944:	000016ad 	andeq	r1, r0, sp, lsr #13
    2948:	13840539 	orrne	r0, r4, #239075328	; 0xe400000
    294c:	053a0000 	ldreq	r0, [sl, #-0]!
    2950:	0000133d 	andeq	r1, r0, sp, lsr r3
    2954:	1562053b 	strbne	r0, [r2, #-1339]!	; 0xfffffac5
    2958:	053c0000 	ldreq	r0, [ip, #-0]!
    295c:	000012dc 	ldrdeq	r1, [r0], -ip
    2960:	16c8053d 			; <UNDEFINED> instruction: 0x16c8053d
    2964:	003e0000 	eorseq	r0, lr, r0
    2968:	0013c406 	andseq	ip, r3, r6, lsl #8
    296c:	6b020200 	blvs	83174 <__bss_end+0x794dc>
    2970:	020e0802 	andeq	r0, lr, #131072	; 0x20000
    2974:	87070000 	strhi	r0, [r7, -r0]
    2978:	02000015 	andeq	r0, r0, #21
    297c:	56140270 			; <UNDEFINED> instruction: 0x56140270
    2980:	00000000 	andeq	r0, r0, r0
    2984:	0014a007 	andseq	sl, r4, r7
    2988:	02710200 	rsbseq	r0, r1, #0, 4
    298c:	00005614 	andeq	r5, r0, r4, lsl r6
    2990:	08000100 	stmdaeq	r0, {r8}
    2994:	000001e3 	andeq	r0, r0, r3, ror #3
    2998:	00020e09 	andeq	r0, r2, r9, lsl #28
    299c:	00022300 	andeq	r2, r2, r0, lsl #6
    29a0:	00330a00 	eorseq	r0, r3, r0, lsl #20
    29a4:	00110000 	andseq	r0, r1, r0
    29a8:	00021308 	andeq	r1, r2, r8, lsl #6
    29ac:	164b0b00 	strbne	r0, [fp], -r0, lsl #22
    29b0:	74020000 	strvc	r0, [r2], #-0
    29b4:	02232602 	eoreq	r2, r3, #2097152	; 0x200000
    29b8:	3a240000 	bcc	9029c0 <__bss_end+0x8f8d28>
    29bc:	0f3d0a3d 	svceq	0x003d0a3d
    29c0:	323d243d 	eorscc	r2, sp, #1023410176	; 0x3d000000
    29c4:	053d023d 	ldreq	r0, [sp, #-573]!	; 0xfffffdc3
    29c8:	0d3d133d 	ldceq	3, cr1, [sp, #-244]!	; 0xffffff0c
    29cc:	233d0c3d 	teqcs	sp, #15616	; 0x3d00
    29d0:	263d113d 			; <UNDEFINED> instruction: 0x263d113d
    29d4:	173d013d 			; <UNDEFINED> instruction: 0x173d013d
    29d8:	093d083d 	ldmdbeq	sp!, {r0, r2, r3, r4, r5, fp}
    29dc:	0200003d 	andeq	r0, r0, #61	; 0x3d
    29e0:	0ba20702 	bleq	fe8845f0 <__bss_end+0xfe87a958>
    29e4:	01020000 	mrseq	r0, (UNDEF: 2)
    29e8:	000abd08 	andeq	fp, sl, r8, lsl #26
    29ec:	05020200 	streq	r0, [r2, #-512]	; 0xfffffe00
    29f0:	00000963 	andeq	r0, r0, r3, ror #18
    29f4:	0018730c 	andseq	r7, r8, ip, lsl #6
    29f8:	16810300 	strne	r0, [r1], r0, lsl #6
    29fc:	00000033 	andeq	r0, r0, r3, lsr r0
    2a00:	00187b0c 	andseq	r7, r8, ip, lsl #22
    2a04:	16850300 	strne	r0, [r5], r0, lsl #6
    2a08:	00000025 	andeq	r0, r0, r5, lsr #32
    2a0c:	f5040402 			; <UNDEFINED> instruction: 0xf5040402
    2a10:	02000012 	andeq	r0, r0, #18
    2a14:	12ed0308 	rscne	r0, sp, #8, 6	; 0x20000000
    2a18:	08020000 	stmdaeq	r2, {}	; <UNPREDICTABLE>
    2a1c:	00159e04 	andseq	r9, r5, r4, lsl #28
    2a20:	03100200 	tsteq	r0, #0, 4
    2a24:	000016ef 	andeq	r1, r0, pc, ror #13
    2a28:	0019370d 	andseq	r3, r9, sp, lsl #14
    2a2c:	03b30100 			; <UNDEFINED> instruction: 0x03b30100
    2a30:	00027b01 	andeq	r7, r2, r1, lsl #22
    2a34:	009a7800 	addseq	r7, sl, r0, lsl #16
    2a38:	00012000 	andeq	r2, r1, r0
    2a3c:	7d9c0100 	ldfvcs	f0, [ip]
    2a40:	0e000003 	cdpeq	0, 0, cr0, cr0, cr3, {0}
    2a44:	b301006e 	movwlt	r0, #4206	; 0x106e
    2a48:	027b1703 	rsbseq	r1, fp, #786432	; 0xc0000
    2a4c:	01490000 	mrseq	r0, (UNDEF: 73)
    2a50:	01450000 	mrseq	r0, (UNDEF: 69)
    2a54:	640e0000 	strvs	r0, [lr], #-0
    2a58:	03b30100 			; <UNDEFINED> instruction: 0x03b30100
    2a5c:	00027b22 	andeq	r7, r2, r2, lsr #22
    2a60:	00017500 	andeq	r7, r1, r0, lsl #10
    2a64:	00017100 	andeq	r7, r1, r0, lsl #2
    2a68:	70720f00 	rsbsvc	r0, r2, r0, lsl #30
    2a6c:	03b30100 			; <UNDEFINED> instruction: 0x03b30100
    2a70:	00037d2e 	andeq	r7, r3, lr, lsr #26
    2a74:	00910200 	addseq	r0, r1, r0, lsl #4
    2a78:	01007110 	tsteq	r0, r0, lsl r1
    2a7c:	7b0b03b5 	blvc	2c3958 <__bss_end+0x2b9cc0>
    2a80:	a5000002 	strge	r0, [r0, #-2]
    2a84:	9d000001 	stcls	0, cr0, [r0, #-4]
    2a88:	10000001 	andne	r0, r0, r1
    2a8c:	b5010072 	strlt	r0, [r1, #-114]	; 0xffffff8e
    2a90:	027b1203 	rsbseq	r1, fp, #805306368	; 0x30000000
    2a94:	01fb0000 	mvnseq	r0, r0
    2a98:	01f10000 	mvnseq	r0, r0
    2a9c:	79100000 	ldmdbvc	r0, {}	; <UNPREDICTABLE>
    2aa0:	03b50100 			; <UNDEFINED> instruction: 0x03b50100
    2aa4:	00027b19 	andeq	r7, r2, r9, lsl fp
    2aa8:	00025900 	andeq	r5, r2, r0, lsl #18
    2aac:	00025300 	andeq	r5, r2, r0, lsl #6
    2ab0:	7a6c1000 	bvc	1b06ab8 <__bss_end+0x1afce20>
    2ab4:	b6010031 			; <UNDEFINED> instruction: 0xb6010031
    2ab8:	026f0a03 	rsbeq	r0, pc, #12288	; 0x3000
    2abc:	02930000 	addseq	r0, r3, #0
    2ac0:	02910000 	addseq	r0, r1, #0
    2ac4:	6c100000 	ldcvs	0, cr0, [r0], {-0}
    2ac8:	0100327a 	tsteq	r0, sl, ror r2
    2acc:	6f0f03b6 	svcvs	0x000f03b6
    2ad0:	aa000002 	bge	2ae0 <shift+0x2ae0>
    2ad4:	a8000002 	stmdage	r0, {r1}
    2ad8:	10000002 	andne	r0, r0, r2
    2adc:	b6010069 	strlt	r0, [r1], -r9, rrx
    2ae0:	026f1403 	rsbeq	r1, pc, #50331648	; 0x3000000
    2ae4:	02c90000 	sbceq	r0, r9, #0
    2ae8:	02bd0000 	adcseq	r0, sp, #0
    2aec:	6b100000 	blvs	402af4 <__bss_end+0x3f8e5c>
    2af0:	03b60100 			; <UNDEFINED> instruction: 0x03b60100
    2af4:	00026f17 	andeq	r6, r2, r7, lsl pc
    2af8:	00031b00 	andeq	r1, r3, r0, lsl #22
    2afc:	00031700 	andeq	r1, r3, r0, lsl #14
    2b00:	04110000 	ldreq	r0, [r1], #-0
    2b04:	0000027b 	andeq	r0, r0, fp, ror r2
	...

Disassembly of section .debug_abbrev:

00000000 <.debug_abbrev>:
   0:	10001101 	andne	r1, r0, r1, lsl #2
   4:	12011106 	andne	r1, r1, #-2147483647	; 0x80000001
   8:	1b0e0301 	blne	380c14 <__bss_end+0x376f7c>
   c:	130e250e 	movwne	r2, #58638	; 0xe50e
  10:	00000005 	andeq	r0, r0, r5
  14:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
  18:	030b130e 	movweq	r1, #45838	; 0xb30e
  1c:	110e1b0e 	tstne	lr, lr, lsl #22
  20:	10061201 	andne	r1, r6, r1, lsl #4
  24:	02000017 	andeq	r0, r0, #23
  28:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
  2c:	0b3b0b3a 	bleq	ec2d1c <__bss_end+0xeb9084>
  30:	13490b39 	movtne	r0, #39737	; 0x9b39
  34:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
  38:	24030000 	strcs	r0, [r3], #-0
  3c:	3e0b0b00 	vmlacc.f64	d0, d11, d0
  40:	000e030b 	andeq	r0, lr, fp, lsl #6
  44:	012e0400 			; <UNDEFINED> instruction: 0x012e0400
  48:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
  4c:	0b3b0b3a 	bleq	ec2d3c <__bss_end+0xeb90a4>
  50:	01110b39 	tsteq	r1, r9, lsr fp
  54:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
  58:	01194296 			; <UNDEFINED> instruction: 0x01194296
  5c:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
  60:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
  64:	0b3b0b3a 	bleq	ec2d54 <__bss_end+0xeb90bc>
  68:	13490b39 	movtne	r0, #39737	; 0x9b39
  6c:	00001802 	andeq	r1, r0, r2, lsl #16
  70:	0b002406 	bleq	9090 <_Z5bzeroPvi+0x34>
  74:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
  78:	07000008 	streq	r0, [r0, -r8]
  7c:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
  80:	0b3a0e03 	bleq	e83894 <__bss_end+0xe79bfc>
  84:	0b390b3b 	bleq	e42d78 <__bss_end+0xe390e0>
  88:	06120111 			; <UNDEFINED> instruction: 0x06120111
  8c:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
  90:	00130119 	andseq	r0, r3, r9, lsl r1
  94:	010b0800 	tsteq	fp, r0, lsl #16
  98:	06120111 			; <UNDEFINED> instruction: 0x06120111
  9c:	34090000 	strcc	r0, [r9], #-0
  a0:	3a080300 	bcc	200ca8 <__bss_end+0x1f7010>
  a4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
  a8:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
  ac:	0a000018 	beq	114 <shift+0x114>
  b0:	0b0b000f 	bleq	2c00f4 <__bss_end+0x2b645c>
  b4:	00001349 	andeq	r1, r0, r9, asr #6
  b8:	01110100 	tsteq	r1, r0, lsl #2
  bc:	0b130e25 	bleq	4c3958 <__bss_end+0x4b9cc0>
  c0:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
  c4:	06120111 			; <UNDEFINED> instruction: 0x06120111
  c8:	00001710 	andeq	r1, r0, r0, lsl r7
  cc:	03001602 	movweq	r1, #1538	; 0x602
  d0:	3b0b3a0e 	blcc	2ce910 <__bss_end+0x2c4c78>
  d4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
  d8:	03000013 	movweq	r0, #19
  dc:	0b0b000f 	bleq	2c0120 <__bss_end+0x2b6488>
  e0:	00001349 	andeq	r1, r0, r9, asr #6
  e4:	00001504 	andeq	r1, r0, r4, lsl #10
  e8:	01010500 	tsteq	r1, r0, lsl #10
  ec:	13011349 	movwne	r1, #4937	; 0x1349
  f0:	21060000 	mrscs	r0, (UNDEF: 6)
  f4:	2f134900 	svccs	0x00134900
  f8:	07000006 	streq	r0, [r0, -r6]
  fc:	0b0b0024 	bleq	2c0194 <__bss_end+0x2b64fc>
 100:	0e030b3e 	vmoveq.16	d3[0], r0
 104:	34080000 	strcc	r0, [r8], #-0
 108:	3a0e0300 	bcc	380d10 <__bss_end+0x377078>
 10c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 110:	3f13490b 	svccc	0x0013490b
 114:	00193c19 	andseq	r3, r9, r9, lsl ip
 118:	012e0900 			; <UNDEFINED> instruction: 0x012e0900
 11c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 120:	0b3b0b3a 	bleq	ec2e10 <__bss_end+0xeb9178>
 124:	13490b39 	movtne	r0, #39737	; 0x9b39
 128:	06120111 			; <UNDEFINED> instruction: 0x06120111
 12c:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 130:	00130119 	andseq	r0, r3, r9, lsl r1
 134:	00340a00 	eorseq	r0, r4, r0, lsl #20
 138:	0b3a0e03 	bleq	e8394c <__bss_end+0xe79cb4>
 13c:	0b390b3b 	bleq	e42e30 <__bss_end+0xe39198>
 140:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 144:	240b0000 	strcs	r0, [fp], #-0
 148:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 14c:	0008030b 	andeq	r0, r8, fp, lsl #6
 150:	002e0c00 	eoreq	r0, lr, r0, lsl #24
 154:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 158:	0b3b0b3a 	bleq	ec2e48 <__bss_end+0xeb91b0>
 15c:	01110b39 	tsteq	r1, r9, lsr fp
 160:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 164:	00194297 	mulseq	r9, r7, r2
 168:	01390d00 	teqeq	r9, r0, lsl #26
 16c:	0b3a0e03 	bleq	e83980 <__bss_end+0xe79ce8>
 170:	13010b3b 	movwne	r0, #6971	; 0x1b3b
 174:	2e0e0000 	cdpcs	0, 0, cr0, cr14, cr0, {0}
 178:	03193f01 	tsteq	r9, #1, 30
 17c:	3b0b3a0e 	blcc	2ce9bc <__bss_end+0x2c4d24>
 180:	3c0b390b 			; <UNDEFINED> instruction: 0x3c0b390b
 184:	00130119 	andseq	r0, r3, r9, lsl r1
 188:	00050f00 	andeq	r0, r5, r0, lsl #30
 18c:	00001349 	andeq	r1, r0, r9, asr #6
 190:	3f012e10 	svccc	0x00012e10
 194:	3a0e0319 	bcc	380e00 <__bss_end+0x377168>
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
 1c0:	3a080300 	bcc	200dc8 <__bss_end+0x1f7130>
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
 1f4:	0b0b0024 	bleq	2c028c <__bss_end+0x2b65f4>
 1f8:	0e030b3e 	vmoveq.16	d3[0], r0
 1fc:	24030000 	strcs	r0, [r3], #-0
 200:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 204:	0008030b 	andeq	r0, r8, fp, lsl #6
 208:	00160400 	andseq	r0, r6, r0, lsl #8
 20c:	0b3a0e03 	bleq	e83a20 <__bss_end+0xe79d88>
 210:	0b390b3b 	bleq	e42f04 <__bss_end+0xe3926c>
 214:	00001349 	andeq	r1, r0, r9, asr #6
 218:	49002605 	stmdbmi	r0, {r0, r2, r9, sl, sp}
 21c:	06000013 			; <UNDEFINED> instruction: 0x06000013
 220:	0e030113 	mcreq	1, 0, r0, cr3, cr3, {0}
 224:	0b3a0b0b 	bleq	e82e58 <__bss_end+0xe791c0>
 228:	0b390b3b 	bleq	e42f1c <__bss_end+0xe39284>
 22c:	00001301 	andeq	r1, r0, r1, lsl #6
 230:	03000d07 	movweq	r0, #3335	; 0xd07
 234:	3b0b3a08 	blcc	2cea5c <__bss_end+0x2c4dc4>
 238:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 23c:	000b3813 	andeq	r3, fp, r3, lsl r8
 240:	01040800 	tsteq	r4, r0, lsl #16
 244:	196d0e03 	stmdbne	sp!, {r0, r1, r9, sl, fp}^
 248:	0b0b0b3e 	bleq	2c2f48 <__bss_end+0x2b92b0>
 24c:	0b3a1349 	bleq	e84f78 <__bss_end+0xe7b2e0>
 250:	0b390b3b 	bleq	e42f44 <__bss_end+0xe392ac>
 254:	00001301 	andeq	r1, r0, r1, lsl #6
 258:	03002809 	movweq	r2, #2057	; 0x809
 25c:	000b1c0e 	andeq	r1, fp, lr, lsl #24
 260:	00340a00 	eorseq	r0, r4, r0, lsl #20
 264:	0b3a0e03 	bleq	e83a78 <__bss_end+0xe79de0>
 268:	0b390b3b 	bleq	e42f5c <__bss_end+0xe392c4>
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
 294:	0b3b0b3a 	bleq	ec2f84 <__bss_end+0xeb92ec>
 298:	13490b39 	movtne	r0, #39737	; 0x9b39
 29c:	00000b38 	andeq	r0, r0, r8, lsr fp
 2a0:	4901010f 	stmdbmi	r1, {r0, r1, r2, r3, r8}
 2a4:	00130113 	andseq	r0, r3, r3, lsl r1
 2a8:	00211000 	eoreq	r1, r1, r0
 2ac:	0b2f1349 	bleq	bc4fd8 <__bss_end+0xbbb340>
 2b0:	02110000 	andseq	r0, r1, #0
 2b4:	0b0e0301 	bleq	380ec0 <__bss_end+0x377228>
 2b8:	3b0b3a0b 	blcc	2ceaec <__bss_end+0x2c4e54>
 2bc:	010b390b 	tsteq	fp, fp, lsl #18
 2c0:	12000013 	andne	r0, r0, #19
 2c4:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 2c8:	0b3a0e03 	bleq	e83adc <__bss_end+0xe79e44>
 2cc:	0b390b3b 	bleq	e42fc0 <__bss_end+0xe39328>
 2d0:	193c0e6e 	ldmdbne	ip!, {r1, r2, r3, r5, r6, r9, sl, fp}
 2d4:	13011364 	movwne	r1, #4964	; 0x1364
 2d8:	05130000 	ldreq	r0, [r3, #-0]
 2dc:	34134900 	ldrcc	r4, [r3], #-2304	; 0xfffff700
 2e0:	14000019 	strne	r0, [r0], #-25	; 0xffffffe7
 2e4:	13490005 	movtne	r0, #36869	; 0x9005
 2e8:	2e150000 	cdpcs	0, 1, cr0, cr5, cr0, {0}
 2ec:	03193f01 	tsteq	r9, #1, 30
 2f0:	3b0b3a0e 	blcc	2ceb30 <__bss_end+0x2c4e98>
 2f4:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 2f8:	3c13490e 			; <UNDEFINED> instruction: 0x3c13490e
 2fc:	01136419 	tsteq	r3, r9, lsl r4
 300:	16000013 			; <UNDEFINED> instruction: 0x16000013
 304:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 308:	0b3a0e03 	bleq	e83b1c <__bss_end+0xe79e84>
 30c:	0b390b3b 	bleq	e43000 <__bss_end+0xe39368>
 310:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 314:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 318:	13011364 	movwne	r1, #4964	; 0x1364
 31c:	0d170000 	ldceq	0, cr0, [r7, #-0]
 320:	3a0e0300 	bcc	380f28 <__bss_end+0x377290>
 324:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 328:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 32c:	000b320b 	andeq	r3, fp, fp, lsl #4
 330:	012e1800 			; <UNDEFINED> instruction: 0x012e1800
 334:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 338:	0b3b0b3a 	bleq	ec3028 <__bss_end+0xeb9390>
 33c:	0e6e0b39 	vmoveq.8	d14[5], r0
 340:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 344:	13011364 	movwne	r1, #4964	; 0x1364
 348:	2e190000 	cdpcs	0, 1, cr0, cr9, cr0, {0}
 34c:	03193f01 	tsteq	r9, #1, 30
 350:	3b0b3a0e 	blcc	2ceb90 <__bss_end+0x2c4ef8>
 354:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 358:	3213490e 	andscc	r4, r3, #229376	; 0x38000
 35c:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
 360:	1a000013 	bne	3b4 <shift+0x3b4>
 364:	13490115 	movtne	r0, #37141	; 0x9115
 368:	13011364 	movwne	r1, #4964	; 0x1364
 36c:	1f1b0000 	svcne	0x001b0000
 370:	49131d00 	ldmdbmi	r3, {r8, sl, fp, ip}
 374:	1c000013 	stcne	0, cr0, [r0], {19}
 378:	0b0b0010 	bleq	2c03c0 <__bss_end+0x2b6728>
 37c:	00001349 	andeq	r1, r0, r9, asr #6
 380:	0b000f1d 	bleq	3ffc <shift+0x3ffc>
 384:	1e00000b 	cdpne	0, 0, cr0, cr0, cr11, {0}
 388:	08030139 	stmdaeq	r3, {r0, r3, r4, r5, r8}
 38c:	0b3b0b3a 	bleq	ec307c <__bss_end+0xeb93e4>
 390:	13010b39 	movwne	r0, #6969	; 0x1b39
 394:	341f0000 	ldrcc	r0, [pc], #-0	; 39c <shift+0x39c>
 398:	3a0e0300 	bcc	380fa0 <__bss_end+0x377308>
 39c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 3a0:	3c13490b 			; <UNDEFINED> instruction: 0x3c13490b
 3a4:	6c061c19 	stcvs	12, cr1, [r6], {25}
 3a8:	20000019 	andcs	r0, r0, r9, lsl r0
 3ac:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 3b0:	0b3b0b3a 	bleq	ec30a0 <__bss_end+0xeb9408>
 3b4:	13490b39 	movtne	r0, #39737	; 0x9b39
 3b8:	0b1c193c 	bleq	7068b0 <__bss_end+0x6fcc18>
 3bc:	0000196c 	andeq	r1, r0, ip, ror #18
 3c0:	47003421 	strmi	r3, [r0, -r1, lsr #8]
 3c4:	22000013 	andcs	r0, r0, #19
 3c8:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 3cc:	0b3b0b3a 	bleq	ec30bc <__bss_end+0xeb9424>
 3d0:	13490b39 	movtne	r0, #39737	; 0x9b39
 3d4:	1802193f 	stmdane	r2, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
 3d8:	2e230000 	cdpcs	0, 2, cr0, cr3, cr0, {0}
 3dc:	03193f01 	tsteq	r9, #1, 30
 3e0:	3b0b3a0e 	blcc	2cec20 <__bss_end+0x2c4f88>
 3e4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 3e8:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
 3ec:	96184006 	ldrls	r4, [r8], -r6
 3f0:	13011942 	movwne	r1, #6466	; 0x1942
 3f4:	05240000 	streq	r0, [r4, #-0]!
 3f8:	3a0e0300 	bcc	381000 <__bss_end+0x377368>
 3fc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 400:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 404:	25000018 	strcs	r0, [r0, #-24]	; 0xffffffe8
 408:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 40c:	0b3b0b3a 	bleq	ec30fc <__bss_end+0xeb9464>
 410:	13490b39 	movtne	r0, #39737	; 0x9b39
 414:	00001802 	andeq	r1, r0, r2, lsl #16
 418:	3f012e26 	svccc	0x00012e26
 41c:	3a0e0319 	bcc	381088 <__bss_end+0x3773f0>
 420:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 424:	110e6e0b 	tstne	lr, fp, lsl #28
 428:	40061201 	andmi	r1, r6, r1, lsl #4
 42c:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
 430:	01000000 	mrseq	r0, (UNDEF: 0)
 434:	0e250111 	mcreq	1, 1, r0, cr5, cr1, {0}
 438:	0e030b13 	vmoveq.32	d3[0], r0
 43c:	01110e1b 	tsteq	r1, fp, lsl lr
 440:	17100612 			; <UNDEFINED> instruction: 0x17100612
 444:	24020000 	strcs	r0, [r2], #-0
 448:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 44c:	000e030b 	andeq	r0, lr, fp, lsl #6
 450:	00260300 	eoreq	r0, r6, r0, lsl #6
 454:	00001349 	andeq	r1, r0, r9, asr #6
 458:	0b002404 	bleq	9470 <_Z4ftoafPc+0x2c4>
 45c:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 460:	05000008 	streq	r0, [r0, #-8]
 464:	0e030016 	mcreq	0, 0, r0, cr3, cr6, {0}
 468:	0b3b0b3a 	bleq	ec3158 <__bss_end+0xeb94c0>
 46c:	13490b39 	movtne	r0, #39737	; 0x9b39
 470:	13060000 	movwne	r0, #24576	; 0x6000
 474:	0b0e0301 	bleq	381080 <__bss_end+0x3773e8>
 478:	3b0b3a0b 	blcc	2cecac <__bss_end+0x2c5014>
 47c:	010b390b 	tsteq	fp, fp, lsl #18
 480:	07000013 	smladeq	r0, r3, r0, r0
 484:	0803000d 	stmdaeq	r3, {r0, r2, r3}
 488:	0b3b0b3a 	bleq	ec3178 <__bss_end+0xeb94e0>
 48c:	13490b39 	movtne	r0, #39737	; 0x9b39
 490:	00000b38 	andeq	r0, r0, r8, lsr fp
 494:	03010408 	movweq	r0, #5128	; 0x1408
 498:	3e196d0e 	cdpcc	13, 1, cr6, cr9, cr14, {0}
 49c:	490b0b0b 	stmdbmi	fp, {r0, r1, r3, r8, r9, fp}
 4a0:	3b0b3a13 	blcc	2cecf4 <__bss_end+0x2c505c>
 4a4:	010b390b 	tsteq	fp, fp, lsl #18
 4a8:	09000013 	stmdbeq	r0, {r0, r1, r4}
 4ac:	08030028 	stmdaeq	r3, {r3, r5}
 4b0:	00000b1c 	andeq	r0, r0, ip, lsl fp
 4b4:	0300280a 	movweq	r2, #2058	; 0x80a
 4b8:	000b1c0e 	andeq	r1, fp, lr, lsl #24
 4bc:	00340b00 	eorseq	r0, r4, r0, lsl #22
 4c0:	0b3a0e03 	bleq	e83cd4 <__bss_end+0xe7a03c>
 4c4:	0b390b3b 	bleq	e431b8 <__bss_end+0xe39520>
 4c8:	196c1349 	stmdbne	ip!, {r0, r3, r6, r8, r9, ip}^
 4cc:	00001802 	andeq	r1, r0, r2, lsl #16
 4d0:	0300020c 	movweq	r0, #524	; 0x20c
 4d4:	00193c0e 	andseq	r3, r9, lr, lsl #24
 4d8:	000f0d00 	andeq	r0, pc, r0, lsl #26
 4dc:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 4e0:	0d0e0000 	stceq	0, cr0, [lr, #-0]
 4e4:	3a0e0300 	bcc	3810ec <__bss_end+0x377454>
 4e8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 4ec:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 4f0:	0f00000b 	svceq	0x0000000b
 4f4:	13490101 	movtne	r0, #37121	; 0x9101
 4f8:	00001301 	andeq	r1, r0, r1, lsl #6
 4fc:	49002110 	stmdbmi	r0, {r4, r8, sp}
 500:	000b2f13 	andeq	r2, fp, r3, lsl pc
 504:	01021100 	mrseq	r1, (UNDEF: 18)
 508:	0b0b0e03 	bleq	2c3d1c <__bss_end+0x2ba084>
 50c:	0b3b0b3a 	bleq	ec31fc <__bss_end+0xeb9564>
 510:	13010b39 	movwne	r0, #6969	; 0x1b39
 514:	2e120000 	cdpcs	0, 1, cr0, cr2, cr0, {0}
 518:	03193f01 	tsteq	r9, #1, 30
 51c:	3b0b3a0e 	blcc	2ced5c <__bss_end+0x2c50c4>
 520:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 524:	64193c0e 	ldrvs	r3, [r9], #-3086	; 0xfffff3f2
 528:	00130113 	andseq	r0, r3, r3, lsl r1
 52c:	00051300 	andeq	r1, r5, r0, lsl #6
 530:	19341349 	ldmdbne	r4!, {r0, r3, r6, r8, r9, ip}
 534:	05140000 	ldreq	r0, [r4, #-0]
 538:	00134900 	andseq	r4, r3, r0, lsl #18
 53c:	012e1500 			; <UNDEFINED> instruction: 0x012e1500
 540:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 544:	0b3b0b3a 	bleq	ec3234 <__bss_end+0xeb959c>
 548:	0e6e0b39 	vmoveq.8	d14[5], r0
 54c:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
 550:	13011364 	movwne	r1, #4964	; 0x1364
 554:	2e160000 	cdpcs	0, 1, cr0, cr6, cr0, {0}
 558:	03193f01 	tsteq	r9, #1, 30
 55c:	3b0b3a0e 	blcc	2ced9c <__bss_end+0x2c5104>
 560:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 564:	3213490e 	andscc	r4, r3, #229376	; 0x38000
 568:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
 56c:	00130113 	andseq	r0, r3, r3, lsl r1
 570:	000d1700 	andeq	r1, sp, r0, lsl #14
 574:	0b3a0e03 	bleq	e83d88 <__bss_end+0xe7a0f0>
 578:	0b390b3b 	bleq	e4326c <__bss_end+0xe395d4>
 57c:	0b381349 	bleq	e052a8 <__bss_end+0xdfb610>
 580:	00000b32 	andeq	r0, r0, r2, lsr fp
 584:	3f012e18 	svccc	0x00012e18
 588:	3a0e0319 	bcc	3811f4 <__bss_end+0x37755c>
 58c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 590:	320e6e0b 	andcc	r6, lr, #11, 28	; 0xb0
 594:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
 598:	00130113 	andseq	r0, r3, r3, lsl r1
 59c:	012e1900 			; <UNDEFINED> instruction: 0x012e1900
 5a0:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 5a4:	0b3b0b3a 	bleq	ec3294 <__bss_end+0xeb95fc>
 5a8:	0e6e0b39 	vmoveq.8	d14[5], r0
 5ac:	0b321349 	bleq	c852d8 <__bss_end+0xc7b640>
 5b0:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 5b4:	151a0000 	ldrne	r0, [sl, #-0]
 5b8:	64134901 	ldrvs	r4, [r3], #-2305	; 0xfffff6ff
 5bc:	00130113 	andseq	r0, r3, r3, lsl r1
 5c0:	001f1b00 	andseq	r1, pc, r0, lsl #22
 5c4:	1349131d 	movtne	r1, #37661	; 0x931d
 5c8:	101c0000 	andsne	r0, ip, r0
 5cc:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
 5d0:	1d000013 	stcne	0, cr0, [r0, #-76]	; 0xffffffb4
 5d4:	0b0b000f 	bleq	2c0618 <__bss_end+0x2b6980>
 5d8:	341e0000 	ldrcc	r0, [lr], #-0
 5dc:	3a0e0300 	bcc	3811e4 <__bss_end+0x37754c>
 5e0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 5e4:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 5e8:	1f000018 	svcne	0x00000018
 5ec:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 5f0:	0b3a0e03 	bleq	e83e04 <__bss_end+0xe7a16c>
 5f4:	0b390b3b 	bleq	e432e8 <__bss_end+0xe39650>
 5f8:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 5fc:	06120111 			; <UNDEFINED> instruction: 0x06120111
 600:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 604:	00130119 	andseq	r0, r3, r9, lsl r1
 608:	00052000 	andeq	r2, r5, r0
 60c:	0b3a0e03 	bleq	e83e20 <__bss_end+0xe7a188>
 610:	0b390b3b 	bleq	e43304 <__bss_end+0xe3966c>
 614:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 618:	2e210000 	cdpcs	0, 2, cr0, cr1, cr0, {0}
 61c:	03193f01 	tsteq	r9, #1, 30
 620:	3b0b3a0e 	blcc	2cee60 <__bss_end+0x2c51c8>
 624:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 628:	1113490e 	tstne	r3, lr, lsl #18
 62c:	40061201 	andmi	r1, r6, r1, lsl #4
 630:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
 634:	00001301 	andeq	r1, r0, r1, lsl #6
 638:	03003422 	movweq	r3, #1058	; 0x422
 63c:	3b0b3a08 	blcc	2cee64 <__bss_end+0x2c51cc>
 640:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 644:	00180213 	andseq	r0, r8, r3, lsl r2
 648:	012e2300 			; <UNDEFINED> instruction: 0x012e2300
 64c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 650:	0b3b0b3a 	bleq	ec3340 <__bss_end+0xeb96a8>
 654:	0e6e0b39 	vmoveq.8	d14[5], r0
 658:	06120111 			; <UNDEFINED> instruction: 0x06120111
 65c:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 660:	00130119 	andseq	r0, r3, r9, lsl r1
 664:	002e2400 	eoreq	r2, lr, r0, lsl #8
 668:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 66c:	0b3b0b3a 	bleq	ec335c <__bss_end+0xeb96c4>
 670:	0e6e0b39 	vmoveq.8	d14[5], r0
 674:	06120111 			; <UNDEFINED> instruction: 0x06120111
 678:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 67c:	25000019 	strcs	r0, [r0, #-25]	; 0xffffffe7
 680:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 684:	0b3a0e03 	bleq	e83e98 <__bss_end+0xe7a200>
 688:	0b390b3b 	bleq	e4337c <__bss_end+0xe396e4>
 68c:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 690:	06120111 			; <UNDEFINED> instruction: 0x06120111
 694:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 698:	00000019 	andeq	r0, r0, r9, lsl r0
 69c:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
 6a0:	030b130e 	movweq	r1, #45838	; 0xb30e
 6a4:	110e1b0e 	tstne	lr, lr, lsl #22
 6a8:	10061201 	andne	r1, r6, r1, lsl #4
 6ac:	02000017 	andeq	r0, r0, #23
 6b0:	13010139 	movwne	r0, #4409	; 0x1139
 6b4:	34030000 	strcc	r0, [r3], #-0
 6b8:	3a0e0300 	bcc	3812c0 <__bss_end+0x377628>
 6bc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 6c0:	3c13490b 			; <UNDEFINED> instruction: 0x3c13490b
 6c4:	000a1c19 	andeq	r1, sl, r9, lsl ip
 6c8:	003a0400 	eorseq	r0, sl, r0, lsl #8
 6cc:	0b3b0b3a 	bleq	ec33bc <__bss_end+0xeb9724>
 6d0:	13180b39 	tstne	r8, #58368	; 0xe400
 6d4:	01050000 	mrseq	r0, (UNDEF: 5)
 6d8:	01134901 	tsteq	r3, r1, lsl #18
 6dc:	06000013 			; <UNDEFINED> instruction: 0x06000013
 6e0:	13490021 	movtne	r0, #36897	; 0x9021
 6e4:	00000b2f 	andeq	r0, r0, pc, lsr #22
 6e8:	49002607 	stmdbmi	r0, {r0, r1, r2, r9, sl, sp}
 6ec:	08000013 	stmdaeq	r0, {r0, r1, r4}
 6f0:	0b0b0024 	bleq	2c0788 <__bss_end+0x2b6af0>
 6f4:	0e030b3e 	vmoveq.16	d3[0], r0
 6f8:	34090000 	strcc	r0, [r9], #-0
 6fc:	00134700 	andseq	r4, r3, r0, lsl #14
 700:	012e0a00 			; <UNDEFINED> instruction: 0x012e0a00
 704:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 708:	0b3b0b3a 	bleq	ec33f8 <__bss_end+0xeb9760>
 70c:	0e6e0b39 	vmoveq.8	d14[5], r0
 710:	06120111 			; <UNDEFINED> instruction: 0x06120111
 714:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 718:	00130119 	andseq	r0, r3, r9, lsl r1
 71c:	00050b00 	andeq	r0, r5, r0, lsl #22
 720:	0b3a0803 	bleq	e82734 <__bss_end+0xe78a9c>
 724:	0b390b3b 	bleq	e43418 <__bss_end+0xe39780>
 728:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 72c:	340c0000 	strcc	r0, [ip], #-0
 730:	3a0e0300 	bcc	381338 <__bss_end+0x3776a0>
 734:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 738:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 73c:	0d000018 	stceq	0, cr0, [r0, #-96]	; 0xffffffa0
 740:	08030034 	stmdaeq	r3, {r2, r4, r5}
 744:	0b3b0b3a 	bleq	ec3434 <__bss_end+0xeb979c>
 748:	13490b39 	movtne	r0, #39737	; 0x9b39
 74c:	00001802 	andeq	r1, r0, r2, lsl #16
 750:	0b000f0e 	bleq	4390 <shift+0x4390>
 754:	0013490b 	andseq	r4, r3, fp, lsl #18
 758:	012e0f00 			; <UNDEFINED> instruction: 0x012e0f00
 75c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 760:	0b3b0b3a 	bleq	ec3450 <__bss_end+0xeb97b8>
 764:	0e6e0b39 	vmoveq.8	d14[5], r0
 768:	01111349 	tsteq	r1, r9, asr #6
 76c:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 770:	01194297 			; <UNDEFINED> instruction: 0x01194297
 774:	10000013 	andne	r0, r0, r3, lsl r0
 778:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
 77c:	0b3b0b3a 	bleq	ec346c <__bss_end+0xeb97d4>
 780:	13490b39 	movtne	r0, #39737	; 0x9b39
 784:	00001802 	andeq	r1, r0, r2, lsl #16
 788:	0b002411 	bleq	97d4 <__addsf3+0xe4>
 78c:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 790:	12000008 	andne	r0, r0, #8
 794:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 798:	0b3a0e03 	bleq	e83fac <__bss_end+0xe7a314>
 79c:	0b390b3b 	bleq	e43490 <__bss_end+0xe397f8>
 7a0:	01110e6e 	tsteq	r1, lr, ror #28
 7a4:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 7a8:	01194297 			; <UNDEFINED> instruction: 0x01194297
 7ac:	13000013 	movwne	r0, #19
 7b0:	0111010b 	tsteq	r1, fp, lsl #2
 7b4:	00000612 	andeq	r0, r0, r2, lsl r6
 7b8:	00002614 	andeq	r2, r0, r4, lsl r6
 7bc:	000f1500 	andeq	r1, pc, r0, lsl #10
 7c0:	00000b0b 	andeq	r0, r0, fp, lsl #22
 7c4:	3f012e16 	svccc	0x00012e16
 7c8:	3a0e0319 	bcc	381434 <__bss_end+0x37779c>
 7cc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 7d0:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 7d4:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
 7d8:	96184006 	ldrls	r4, [r8], -r6
 7dc:	13011942 	movwne	r1, #6466	; 0x1942
 7e0:	2e170000 	cdpcs	0, 1, cr0, cr7, cr0, {0}
 7e4:	03193f01 	tsteq	r9, #1, 30
 7e8:	3b0b3a0e 	blcc	2cf028 <__bss_end+0x2c5390>
 7ec:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 7f0:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 7f4:	96184006 	ldrls	r4, [r8], -r6
 7f8:	00001942 	andeq	r1, r0, r2, asr #18
 7fc:	00110100 	andseq	r0, r1, r0, lsl #2
 800:	01110610 	tsteq	r1, r0, lsl r6
 804:	0e030112 	mcreq	1, 0, r0, cr3, cr2, {0}
 808:	0e250e1b 	mcreq	14, 1, r0, cr5, cr11, {0}
 80c:	00000513 	andeq	r0, r0, r3, lsl r5
 810:	00110100 	andseq	r0, r1, r0, lsl #2
 814:	01110610 	tsteq	r1, r0, lsl r6
 818:	0e030112 	mcreq	1, 0, r0, cr3, cr2, {0}
 81c:	0e250e1b 	mcreq	14, 1, r0, cr5, cr11, {0}
 820:	00000513 	andeq	r0, r0, r3, lsl r5
 824:	00110100 	andseq	r0, r1, r0, lsl #2
 828:	01110610 	tsteq	r1, r0, lsl r6
 82c:	0e030112 	mcreq	1, 0, r0, cr3, cr2, {0}
 830:	0e250e1b 	mcreq	14, 1, r0, cr5, cr11, {0}
 834:	00000513 	andeq	r0, r0, r3, lsl r5
 838:	00110100 	andseq	r0, r1, r0, lsl #2
 83c:	01110610 	tsteq	r1, r0, lsl r6
 840:	0e030112 	mcreq	1, 0, r0, cr3, cr2, {0}
 844:	0e250e1b 	mcreq	14, 1, r0, cr5, cr11, {0}
 848:	00000513 	andeq	r0, r0, r3, lsl r5
 84c:	01110100 	tsteq	r1, r0, lsl #2
 850:	0b130e25 	bleq	4c40ec <__bss_end+0x4ba454>
 854:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
 858:	00001710 	andeq	r1, r0, r0, lsl r7
 85c:	0b002402 	bleq	986c <__addsf3+0x17c>
 860:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 864:	03000008 	movweq	r0, #8
 868:	0b0b0024 	bleq	2c0900 <__bss_end+0x2b6c68>
 86c:	0e030b3e 	vmoveq.16	d3[0], r0
 870:	04040000 	streq	r0, [r4], #-0
 874:	3e0e0301 	cdpcc	3, 0, cr0, cr14, cr1, {0}
 878:	490b0b0b 	stmdbmi	fp, {r0, r1, r3, r8, r9, fp}
 87c:	3b0b3a13 	blcc	2cf0d0 <__bss_end+0x2c5438>
 880:	010b390b 	tsteq	fp, fp, lsl #18
 884:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
 888:	0e030028 	cdpeq	0, 0, cr0, cr3, cr8, {1}
 88c:	00000b1c 	andeq	r0, r0, ip, lsl fp
 890:	03011306 	movweq	r1, #4870	; 0x1306
 894:	3a0b0b0e 	bcc	2c34d4 <__bss_end+0x2b983c>
 898:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 89c:	0013010b 	andseq	r0, r3, fp, lsl #2
 8a0:	000d0700 	andeq	r0, sp, r0, lsl #14
 8a4:	0b3a0e03 	bleq	e840b8 <__bss_end+0xe7a420>
 8a8:	0b39053b 	bleq	e41d9c <__bss_end+0xe38104>
 8ac:	0b381349 	bleq	e055d8 <__bss_end+0xdfb940>
 8b0:	26080000 	strcs	r0, [r8], -r0
 8b4:	00134900 	andseq	r4, r3, r0, lsl #18
 8b8:	01010900 	tsteq	r1, r0, lsl #18
 8bc:	13011349 	movwne	r1, #4937	; 0x1349
 8c0:	210a0000 	mrscs	r0, (UNDEF: 10)
 8c4:	2f134900 	svccs	0x00134900
 8c8:	0b00000b 	bleq	8fc <shift+0x8fc>
 8cc:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 8d0:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 8d4:	13490b39 	movtne	r0, #39737	; 0x9b39
 8d8:	00000a1c 	andeq	r0, r0, ip, lsl sl
 8dc:	2700150c 	strcs	r1, [r0, -ip, lsl #10]
 8e0:	0d000019 	stceq	0, cr0, [r0, #-100]	; 0xffffff9c
 8e4:	0b0b000f 	bleq	2c0928 <__bss_end+0x2b6c90>
 8e8:	00001349 	andeq	r1, r0, r9, asr #6
 8ec:	0301040e 	movweq	r0, #5134	; 0x140e
 8f0:	0b0b3e0e 	bleq	2d0130 <__bss_end+0x2c6498>
 8f4:	3a13490b 	bcc	4d2d28 <__bss_end+0x4c9090>
 8f8:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 8fc:	0013010b 	andseq	r0, r3, fp, lsl #2
 900:	00160f00 	andseq	r0, r6, r0, lsl #30
 904:	0b3a0e03 	bleq	e84118 <__bss_end+0xe7a480>
 908:	0b390b3b 	bleq	e435fc <__bss_end+0xe39964>
 90c:	00001349 	andeq	r1, r0, r9, asr #6
 910:	00002110 	andeq	r2, r0, r0, lsl r1
 914:	00341100 	eorseq	r1, r4, r0, lsl #2
 918:	0b3a0e03 	bleq	e8412c <__bss_end+0xe7a494>
 91c:	0b390b3b 	bleq	e43610 <__bss_end+0xe39978>
 920:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
 924:	0000193c 	andeq	r1, r0, ip, lsr r9
 928:	47003412 	smladmi	r0, r2, r4, r3
 92c:	3b0b3a13 	blcc	2cf180 <__bss_end+0x2c54e8>
 930:	490b3905 	stmdbmi	fp, {r0, r2, r8, fp, ip, sp}
 934:	00180213 	andseq	r0, r8, r3, lsl r2
 938:	11010000 	mrsne	r0, (UNDEF: 1)
 93c:	130e2501 	movwne	r2, #58625	; 0xe501
 940:	1b0e030b 	blne	381574 <__bss_end+0x3778dc>
 944:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 948:	00171006 	andseq	r1, r7, r6
 94c:	00240200 	eoreq	r0, r4, r0, lsl #4
 950:	0b3e0b0b 	bleq	f83584 <__bss_end+0xf798ec>
 954:	00000e03 	andeq	r0, r0, r3, lsl #28
 958:	0b002403 	bleq	996c <__aeabi_ldivmod+0x38>
 95c:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 960:	04000008 	streq	r0, [r0], #-8
 964:	0e030104 	adfeqs	f0, f3, f4
 968:	0b0b0b3e 	bleq	2c3668 <__bss_end+0x2b99d0>
 96c:	0b3a1349 	bleq	e85698 <__bss_end+0xe7ba00>
 970:	0b390b3b 	bleq	e43664 <__bss_end+0xe399cc>
 974:	00001301 	andeq	r1, r0, r1, lsl #6
 978:	03002805 	movweq	r2, #2053	; 0x805
 97c:	000b1c0e 	andeq	r1, fp, lr, lsl #24
 980:	01130600 	tsteq	r3, r0, lsl #12
 984:	0b0b0e03 	bleq	2c4198 <__bss_end+0x2ba500>
 988:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 98c:	13010b39 	movwne	r0, #6969	; 0x1b39
 990:	0d070000 	stceq	0, cr0, [r7, #-0]
 994:	3a0e0300 	bcc	38159c <__bss_end+0x377904>
 998:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 99c:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 9a0:	0800000b 	stmdaeq	r0, {r0, r1, r3}
 9a4:	13490026 	movtne	r0, #36902	; 0x9026
 9a8:	01090000 	mrseq	r0, (UNDEF: 9)
 9ac:	01134901 	tsteq	r3, r1, lsl #18
 9b0:	0a000013 	beq	a04 <shift+0xa04>
 9b4:	13490021 	movtne	r0, #36897	; 0x9021
 9b8:	00000b2f 	andeq	r0, r0, pc, lsr #22
 9bc:	0300340b 	movweq	r3, #1035	; 0x40b
 9c0:	3b0b3a0e 	blcc	2cf200 <__bss_end+0x2c5568>
 9c4:	490b3905 	stmdbmi	fp, {r0, r2, r8, fp, ip, sp}
 9c8:	000a1c13 	andeq	r1, sl, r3, lsl ip
 9cc:	00160c00 	andseq	r0, r6, r0, lsl #24
 9d0:	0b3a0e03 	bleq	e841e4 <__bss_end+0xe7a54c>
 9d4:	0b390b3b 	bleq	e436c8 <__bss_end+0xe39a30>
 9d8:	00001349 	andeq	r1, r0, r9, asr #6
 9dc:	3f012e0d 	svccc	0x00012e0d
 9e0:	3a0e0319 	bcc	38164c <__bss_end+0x3779b4>
 9e4:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 9e8:	4919270b 	ldmdbmi	r9, {r0, r1, r3, r8, r9, sl, sp}
 9ec:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
 9f0:	97184006 	ldrls	r4, [r8, -r6]
 9f4:	13011942 	movwne	r1, #6466	; 0x1942
 9f8:	050e0000 	streq	r0, [lr, #-0]
 9fc:	3a080300 	bcc	201604 <__bss_end+0x1f796c>
 a00:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 a04:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 a08:	1742b717 	smlaldne	fp, r2, r7, r7
 a0c:	890f0000 	stmdbhi	pc, {}	; <UNPREDICTABLE>
 a10:	11010182 	smlabbne	r1, r2, r1, r0
 a14:	19429501 	stmdbne	r2, {r0, r8, sl, ip, pc}^
 a18:	13011331 	movwne	r1, #4913	; 0x1331
 a1c:	8a100000 	bhi	400a24 <__bss_end+0x3f6d8c>
 a20:	02000182 	andeq	r0, r0, #-2147483616	; 0x80000020
 a24:	18429118 	stmdane	r2, {r3, r4, r8, ip, pc}^
 a28:	89110000 	ldmdbhi	r1, {}	; <UNPREDICTABLE>
 a2c:	11010182 	smlabbne	r1, r2, r1, r0
 a30:	00133101 	andseq	r3, r3, r1, lsl #2
 a34:	002e1200 	eoreq	r1, lr, r0, lsl #4
 a38:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
 a3c:	0e030e6e 	cdpeq	14, 0, cr0, cr3, cr14, {3}
 a40:	0b3b0b3a 	bleq	ec3730 <__bss_end+0xeb9a98>
 a44:	00000b39 	andeq	r0, r0, r9, lsr fp
 a48:	01110100 	tsteq	r1, r0, lsl #2
 a4c:	0b130e25 	bleq	4c42e8 <__bss_end+0x4ba650>
 a50:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
 a54:	06120111 			; <UNDEFINED> instruction: 0x06120111
 a58:	00001710 	andeq	r1, r0, r0, lsl r7
 a5c:	0b002402 	bleq	9a6c <__aeabi_f2ulz+0x34>
 a60:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 a64:	0300000e 	movweq	r0, #14
 a68:	0b0b0024 	bleq	2c0b00 <__bss_end+0x2b6e68>
 a6c:	08030b3e 	stmdaeq	r3, {r1, r2, r3, r4, r5, r8, r9, fp}
 a70:	04040000 	streq	r0, [r4], #-0
 a74:	3e0e0301 	cdpcc	3, 0, cr0, cr14, cr1, {0}
 a78:	490b0b0b 	stmdbmi	fp, {r0, r1, r3, r8, r9, fp}
 a7c:	3b0b3a13 	blcc	2cf2d0 <__bss_end+0x2c5638>
 a80:	010b390b 	tsteq	fp, fp, lsl #18
 a84:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
 a88:	0e030028 	cdpeq	0, 0, cr0, cr3, cr8, {1}
 a8c:	00000b1c 	andeq	r0, r0, ip, lsl fp
 a90:	03011306 	movweq	r1, #4870	; 0x1306
 a94:	3a0b0b0e 	bcc	2c36d4 <__bss_end+0x2b9a3c>
 a98:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 a9c:	0013010b 	andseq	r0, r3, fp, lsl #2
 aa0:	000d0700 	andeq	r0, sp, r0, lsl #14
 aa4:	0b3a0e03 	bleq	e842b8 <__bss_end+0xe7a620>
 aa8:	0b39053b 	bleq	e41f9c <__bss_end+0xe38304>
 aac:	0b381349 	bleq	e057d8 <__bss_end+0xdfbb40>
 ab0:	26080000 	strcs	r0, [r8], -r0
 ab4:	00134900 	andseq	r4, r3, r0, lsl #18
 ab8:	01010900 	tsteq	r1, r0, lsl #18
 abc:	13011349 	movwne	r1, #4937	; 0x1349
 ac0:	210a0000 	mrscs	r0, (UNDEF: 10)
 ac4:	2f134900 	svccs	0x00134900
 ac8:	0b00000b 	bleq	afc <shift+0xafc>
 acc:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 ad0:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 ad4:	13490b39 	movtne	r0, #39737	; 0x9b39
 ad8:	00000a1c 	andeq	r0, r0, ip, lsl sl
 adc:	0300160c 	movweq	r1, #1548	; 0x60c
 ae0:	3b0b3a0e 	blcc	2cf320 <__bss_end+0x2c5688>
 ae4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 ae8:	0d000013 	stceq	0, cr0, [r0, #-76]	; 0xffffffb4
 aec:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 af0:	0b3a0e03 	bleq	e84304 <__bss_end+0xe7a66c>
 af4:	0b39053b 	bleq	e41fe8 <__bss_end+0xe38350>
 af8:	13491927 	movtne	r1, #39207	; 0x9927
 afc:	06120111 			; <UNDEFINED> instruction: 0x06120111
 b00:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 b04:	0e000019 	mcreq	0, 0, r0, cr0, cr9, {0}
 b08:	08030005 	stmdaeq	r3, {r0, r2}
 b0c:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 b10:	13490b39 	movtne	r0, #39737	; 0x9b39
 b14:	42b71702 	adcsmi	r1, r7, #524288	; 0x80000
 b18:	0f000017 	svceq	0x00000017
 b1c:	08030034 	stmdaeq	r3, {r2, r4, r5}
 b20:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 b24:	13490b39 	movtne	r0, #39737	; 0x9b39
 b28:	42b71702 	adcsmi	r1, r7, #524288	; 0x80000
 b2c:	00000017 	andeq	r0, r0, r7, lsl r0
 b30:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
 b34:	030b130e 	movweq	r1, #45838	; 0xb30e
 b38:	110e1b0e 	tstne	lr, lr, lsl #22
 b3c:	10061201 	andne	r1, r6, r1, lsl #4
 b40:	02000017 	andeq	r0, r0, #23
 b44:	0b0b0024 	bleq	2c0bdc <__bss_end+0x2b6f44>
 b48:	0e030b3e 	vmoveq.16	d3[0], r0
 b4c:	24030000 	strcs	r0, [r3], #-0
 b50:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 b54:	0008030b 	andeq	r0, r8, fp, lsl #6
 b58:	01040400 	tsteq	r4, r0, lsl #8
 b5c:	0b3e0e03 	bleq	f84370 <__bss_end+0xf7a6d8>
 b60:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 b64:	0b3b0b3a 	bleq	ec3854 <__bss_end+0xeb9bbc>
 b68:	13010b39 	movwne	r0, #6969	; 0x1b39
 b6c:	28050000 	stmdacs	r5, {}	; <UNPREDICTABLE>
 b70:	1c0e0300 	stcne	3, cr0, [lr], {-0}
 b74:	0600000b 	streq	r0, [r0], -fp
 b78:	0e030113 	mcreq	1, 0, r0, cr3, cr3, {0}
 b7c:	0b3a0b0b 	bleq	e837b0 <__bss_end+0xe79b18>
 b80:	0b39053b 	bleq	e42074 <__bss_end+0xe383dc>
 b84:	00001301 	andeq	r1, r0, r1, lsl #6
 b88:	03000d07 	movweq	r0, #3335	; 0xd07
 b8c:	3b0b3a0e 	blcc	2cf3cc <__bss_end+0x2c5734>
 b90:	490b3905 	stmdbmi	fp, {r0, r2, r8, fp, ip, sp}
 b94:	000b3813 	andeq	r3, fp, r3, lsl r8
 b98:	00260800 	eoreq	r0, r6, r0, lsl #16
 b9c:	00001349 	andeq	r1, r0, r9, asr #6
 ba0:	49010109 	stmdbmi	r1, {r0, r3, r8}
 ba4:	00130113 	andseq	r0, r3, r3, lsl r1
 ba8:	00210a00 	eoreq	r0, r1, r0, lsl #20
 bac:	0b2f1349 	bleq	bc58d8 <__bss_end+0xbbbc40>
 bb0:	340b0000 	strcc	r0, [fp], #-0
 bb4:	3a0e0300 	bcc	3817bc <__bss_end+0x377b24>
 bb8:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 bbc:	1c13490b 			; <UNDEFINED> instruction: 0x1c13490b
 bc0:	0c00000a 	stceq	0, cr0, [r0], {10}
 bc4:	0e030016 	mcreq	0, 0, r0, cr3, cr6, {0}
 bc8:	0b3b0b3a 	bleq	ec38b8 <__bss_end+0xeb9c20>
 bcc:	13490b39 	movtne	r0, #39737	; 0x9b39
 bd0:	2e0d0000 	cdpcs	0, 0, cr0, cr13, cr0, {0}
 bd4:	03193f01 	tsteq	r9, #1, 30
 bd8:	3b0b3a0e 	blcc	2cf418 <__bss_end+0x2c5780>
 bdc:	270b3905 	strcs	r3, [fp, -r5, lsl #18]
 be0:	11134919 	tstne	r3, r9, lsl r9
 be4:	40061201 	andmi	r1, r6, r1, lsl #4
 be8:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
 bec:	00001301 	andeq	r1, r0, r1, lsl #6
 bf0:	0300050e 	movweq	r0, #1294	; 0x50e
 bf4:	3b0b3a08 	blcc	2cf41c <__bss_end+0x2c5784>
 bf8:	490b3905 	stmdbmi	fp, {r0, r2, r8, fp, ip, sp}
 bfc:	b7170213 			; <UNDEFINED> instruction: 0xb7170213
 c00:	00001742 	andeq	r1, r0, r2, asr #14
 c04:	0300050f 	movweq	r0, #1295	; 0x50f
 c08:	3b0b3a08 	blcc	2cf430 <__bss_end+0x2c5798>
 c0c:	490b3905 	stmdbmi	fp, {r0, r2, r8, fp, ip, sp}
 c10:	00180213 	andseq	r0, r8, r3, lsl r2
 c14:	00341000 	eorseq	r1, r4, r0
 c18:	0b3a0803 	bleq	e82c2c <__bss_end+0xe78f94>
 c1c:	0b39053b 	bleq	e42110 <__bss_end+0xe38478>
 c20:	17021349 	strne	r1, [r2, -r9, asr #6]
 c24:	001742b7 			; <UNDEFINED> instruction: 0x001742b7
 c28:	000f1100 	andeq	r1, pc, r0, lsl #2
 c2c:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 c30:	Address 0x0000000000000c30 is out of bounds.


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
  74:	000001ec 	andeq	r0, r0, ip, ror #3
	...
  80:	0000001c 	andeq	r0, r0, ip, lsl r0
  84:	0bc10002 	bleq	ff040094 <__bss_end+0xff0363fc>
  88:	00040000 	andeq	r0, r4, r0
  8c:	00000000 	andeq	r0, r0, r0
  90:	00008418 	andeq	r8, r0, r8, lsl r4
  94:	0000045c 	andeq	r0, r0, ip, asr r4
	...
  a0:	0000001c 	andeq	r0, r0, ip, lsl r0
  a4:	17560002 	ldrbne	r0, [r6, -r2]
  a8:	00040000 	andeq	r0, r4, r0
  ac:	00000000 	andeq	r0, r0, r0
  b0:	00008878 	andeq	r8, r0, r8, ror r8
  b4:	00000c5c 	andeq	r0, r0, ip, asr ip
	...
  c0:	0000001c 	andeq	r0, r0, ip, lsl r0
  c4:	1d870002 	stcne	0, cr0, [r7, #8]
  c8:	00040000 	andeq	r0, r4, r0
  cc:	00000000 	andeq	r0, r0, r0
  d0:	000094d4 	ldrdeq	r9, [r0], -r4
  d4:	0000020c 	andeq	r0, r0, ip, lsl #4
	...
  e0:	0000001c 	andeq	r0, r0, ip, lsl r0
  e4:	1dad0002 	stcne	0, cr0, [sp, #8]!
  e8:	00040000 	andeq	r0, r4, r0
  ec:	00000000 	andeq	r0, r0, r0
  f0:	000096e0 	andeq	r9, r0, r0, ror #13
  f4:	00000004 	andeq	r0, r0, r4
	...
 100:	0000001c 	andeq	r0, r0, ip, lsl r0
 104:	1dd30002 	ldclne	0, cr0, [r3, #8]
 108:	00040000 	andeq	r0, r4, r0
 10c:	00000000 	andeq	r0, r0, r0
 110:	000096e4 	andeq	r9, r0, r4, ror #13
 114:	00000250 	andeq	r0, r0, r0, asr r2
	...
 120:	0000001c 	andeq	r0, r0, ip, lsl r0
 124:	1df90002 	ldclne	0, cr0, [r9, #8]!
 128:	00040000 	andeq	r0, r4, r0
 12c:	00000000 	andeq	r0, r0, r0
 130:	00009934 	andeq	r9, r0, r4, lsr r9
 134:	000000d4 	ldrdeq	r0, [r0], -r4
	...
 140:	00000014 	andeq	r0, r0, r4, lsl r0
 144:	1e1f0002 	cdpne	0, 1, cr0, cr15, cr2, {0}
 148:	00040000 	andeq	r0, r4, r0
	...
 158:	0000001c 	andeq	r0, r0, ip, lsl r0
 15c:	214d0002 	cmpcs	sp, r2
 160:	00040000 	andeq	r0, r4, r0
 164:	00000000 	andeq	r0, r0, r0
 168:	00009a08 	andeq	r9, r0, r8, lsl #20
 16c:	00000030 	andeq	r0, r0, r0, lsr r0
	...
 178:	0000001c 	andeq	r0, r0, ip, lsl r0
 17c:	24570002 	ldrbcs	r0, [r7], #-2
 180:	00040000 	andeq	r0, r4, r0
 184:	00000000 	andeq	r0, r0, r0
 188:	00009a38 	andeq	r9, r0, r8, lsr sl
 18c:	00000040 	andeq	r0, r0, r0, asr #32
	...
 198:	0000001c 	andeq	r0, r0, ip, lsl r0
 19c:	27850002 	strcs	r0, [r5, r2]
 1a0:	00040000 	andeq	r0, r4, r0
 1a4:	00000000 	andeq	r0, r0, r0
 1a8:	00009a78 	andeq	r9, r0, r8, ror sl
 1ac:	00000120 	andeq	r0, r0, r0, lsr #2
	...

Disassembly of section .debug_str:

00000000 <.debug_str>:
       0:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; ffffff4c <__bss_end+0xffff62b4>
       4:	72742f65 	rsbsvc	r2, r4, #404	; 0x194
       8:	6c696665 	stclvs	6, cr6, [r9], #-404	; 0xfffffe6c
       c:	6d65732f 	stclvs	3, cr7, [r5, #-188]!	; 0xffffff44
      10:	756f732f 	strbvc	r7, [pc, #-815]!	; fffffce9 <__bss_end+0xffff6051>
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
      40:	752f7365 	strvc	r7, [pc, #-869]!	; fffffce3 <__bss_end+0xffff604b>
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
      dc:	2b6b7a36 	blcs	1ade9bc <__bss_end+0x1ad4d24>
      e0:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
      e4:	672d2067 	strvs	r2, [sp, -r7, rrx]!
      e8:	304f2d20 	subcc	r2, pc, r0, lsr #26
      ec:	304f2d20 	subcc	r2, pc, r0, lsr #26
      f0:	625f5f00 	subsvs	r5, pc, #0, 30
      f4:	655f7373 	ldrbvs	r7, [pc, #-883]	; fffffd89 <__bss_end+0xffff60f1>
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
     160:	755f6962 	ldrbvc	r6, [pc, #-2402]	; fffff806 <__bss_end+0xffff5b6e>
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
     260:	2b432055 	blcs	10c83bc <__bss_end+0x10be724>
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
     2c4:	7a6a3637 	bvc	1a8dba8 <__bss_end+0x1a83f10>
     2c8:	20732d66 	rsbscs	r2, r3, r6, ror #26
     2cc:	72616d2d 	rsbvc	r6, r1, #2880	; 0xb40
     2d0:	6d2d206d 	stcvs	0, cr2, [sp, #-436]!	; 0xfffffe4c
     2d4:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
     2d8:	6d72613d 	ldfvse	f6, [r2, #-244]!	; 0xffffff0c
     2dc:	6b7a3676 	blvs	1e8dcbc <__bss_end+0x1e84024>
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
     378:	5a5f006a 	bpl	17c0528 <__bss_end+0x17b6890>
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
     434:	6f73006a 	svcvs	0x0073006a
     438:	656c5f73 	strbvs	r5, [ip, #-3955]!	; 0xfffff08d
     43c:	6e490064 	cdpvs	0, 4, cr0, cr9, cr4, {3}
     440:	696c6176 	stmdbvs	ip!, {r1, r2, r4, r5, r6, r8, sp, lr}^
     444:	61485f64 	cmpvs	r8, r4, ror #30
     448:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     44c:	6e755200 	cdpvs	2, 7, cr5, cr5, cr0, {0}
     450:	676e696e 	strbvs	r6, [lr, -lr, ror #18]!
     454:	61654400 	cmnvs	r5, r0, lsl #8
     458:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
     45c:	6e555f65 	cdpvs	15, 5, cr5, cr5, cr5, {3}
     460:	6e616863 	cdpvs	8, 6, cr6, cr1, cr3, {3}
     464:	00646567 	rsbeq	r6, r4, r7, ror #10
     468:	5f746547 	svcpl	0x00746547
     46c:	72727543 	rsbsvc	r7, r2, #281018368	; 0x10c00000
     470:	5f746e65 	svcpl	0x00746e65
     474:	636f7250 	cmnvs	pc, #80, 4
     478:	00737365 	rsbseq	r7, r3, r5, ror #6
     47c:	4f495047 	svcmi	0x00495047
     480:	7361425f 	cmnvc	r1, #-268435451	; 0xf0000005
     484:	5a5f0065 	bpl	17c0620 <__bss_end+0x17b6988>
     488:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     48c:	636f7250 	cmnvs	pc, #80, 4
     490:	5f737365 	svcpl	0x00737365
     494:	616e614d 	cmnvs	lr, sp, asr #2
     498:	31726567 	cmncc	r2, r7, ror #10
     49c:	65724334 	ldrbvs	r4, [r2, #-820]!	; 0xfffffccc
     4a0:	5f657461 	svcpl	0x00657461
     4a4:	636f7250 	cmnvs	pc, #80, 4
     4a8:	45737365 	ldrbmi	r7, [r3, #-869]!	; 0xfffffc9b
     4ac:	626a6850 	rsbvs	r6, sl, #80, 16	; 0x500000
     4b0:	74655300 	strbtvc	r5, [r5], #-768	; 0xfffffd00
     4b4:	7261505f 	rsbvc	r5, r1, #95	; 0x5f
     4b8:	00736d61 	rsbseq	r6, r3, r1, ror #26
     4bc:	76657270 			; <UNDEFINED> instruction: 0x76657270
     4c0:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     4c4:	4336314b 	teqmi	r6, #-1073741806	; 0xc0000012
     4c8:	636f7250 	cmnvs	pc, #80, 4
     4cc:	5f737365 	svcpl	0x00737365
     4d0:	616e614d 	cmnvs	lr, sp, asr #2
     4d4:	31726567 	cmncc	r2, r7, ror #10
     4d8:	74654739 	strbtvc	r4, [r5], #-1849	; 0xfffff8c7
     4dc:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
     4e0:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     4e4:	6f72505f 	svcvs	0x0072505f
     4e8:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     4ec:	52007645 	andpl	r7, r0, #72351744	; 0x4500000
     4f0:	5f646165 	svcpl	0x00646165
     4f4:	796c6e4f 	stmdbvc	ip!, {r0, r1, r2, r3, r6, r9, sl, fp, sp, lr}^
     4f8:	6f687300 	svcvs	0x00687300
     4fc:	625f7472 	subsvs	r7, pc, #1912602624	; 0x72000000
     500:	6b6e696c 	blvs	1b9aab8 <__bss_end+0x1b90e20>
     504:	78614d00 	stmdavc	r1!, {r8, sl, fp, lr}^
     508:	6f72505f 	svcvs	0x0072505f
     50c:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     510:	65704f5f 	ldrbvs	r4, [r0, #-3935]!	; 0xfffff0a1
     514:	5f64656e 	svcpl	0x0064656e
     518:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     51c:	43540073 	cmpmi	r4, #115	; 0x73
     520:	435f5550 	cmpmi	pc, #80, 10	; 0x14000000
     524:	65746e6f 	ldrbvs	r6, [r4, #-3695]!	; 0xfffff191
     528:	5f007478 	svcpl	0x00007478
     52c:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     530:	6f725043 	svcvs	0x00725043
     534:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     538:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     53c:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     540:	68635338 	stmdavs	r3!, {r3, r4, r5, r8, r9, ip, lr}^
     544:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
     548:	00764565 	rsbseq	r4, r6, r5, ror #10
     54c:	69746f4e 	ldmdbvs	r4!, {r1, r2, r3, r6, r8, r9, sl, fp, sp, lr}^
     550:	6c417966 	mcrrvs	9, 6, r7, r1, cr6	; <UNPREDICTABLE>
     554:	6c42006c 	mcrrvs	0, 6, r0, r2, cr12
     558:	5f6b636f 	svcpl	0x006b636f
     55c:	72727543 	rsbsvc	r7, r2, #281018368	; 0x10c00000
     560:	5f746e65 	svcpl	0x00746e65
     564:	636f7250 	cmnvs	pc, #80, 4
     568:	00737365 	rsbseq	r7, r3, r5, ror #6
     56c:	5f746547 	svcpl	0x00746547
     570:	00444950 	subeq	r4, r4, r0, asr r9
     574:	746e6975 	strbtvc	r6, [lr], #-2421	; 0xfffff68b
     578:	745f3233 	ldrbvc	r3, [pc], #-563	; 580 <shift+0x580>
     57c:	676f6c00 	strbvs	r6, [pc, -r0, lsl #24]!
     580:	6c616369 	stclvs	3, cr6, [r1], #-420	; 0xfffffe5c
     584:	6572625f 	ldrbvs	r6, [r2, #-607]!	; 0xfffffda1
     588:	4e006b61 	vmlsmi.f64	d6, d0, d17
     58c:	74434f49 	strbvc	r4, [r3], #-3913	; 0xfffff0b7
     590:	704f5f6c 	subvc	r5, pc, ip, ror #30
     594:	74617265 	strbtvc	r7, [r1], #-613	; 0xfffffd9b
     598:	006e6f69 	rsbeq	r6, lr, r9, ror #30
     59c:	31435342 	cmpcc	r3, r2, asr #6
     5a0:	7361425f 	cmnvc	r1, #-268435451	; 0xf0000005
     5a4:	61570065 	cmpvs	r7, r5, rrx
     5a8:	4e007469 	cdpmi	4, 0, cr7, cr0, cr9, {3}
     5ac:	6b736154 	blvs	1cd8b04 <__bss_end+0x1ccee6c>
     5b0:	6174535f 	cmnvs	r4, pc, asr r3
     5b4:	53006574 	movwpl	r6, #1396	; 0x574
     5b8:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     5bc:	5f656c75 	svcpl	0x00656c75
     5c0:	00464445 	subeq	r4, r6, r5, asr #8
     5c4:	636f6c42 	cmnvs	pc, #16896	; 0x4200
     5c8:	0064656b 	rsbeq	r6, r4, fp, ror #10
     5cc:	7275436d 	rsbsvc	r4, r5, #-1275068415	; 0xb4000001
     5d0:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     5d4:	7361545f 	cmnvc	r1, #1593835520	; 0x5f000000
     5d8:	6f4e5f6b 	svcvs	0x004e5f6b
     5dc:	63006564 	movwvs	r6, #1380	; 0x564
     5e0:	5f726168 	svcpl	0x00726168
     5e4:	6b636974 	blvs	18dabbc <__bss_end+0x18d0f24>
     5e8:	6c65645f 	cfstrdvs	mvd6, [r5], #-380	; 0xfffffe84
     5ec:	73007961 	movwvc	r7, #2401	; 0x961
     5f0:	7065656c 	rsbvc	r6, r5, ip, ror #10
     5f4:	6d69745f 	cfstrdvs	mvd7, [r9, #-380]!	; 0xfffffe84
     5f8:	5f007265 	svcpl	0x00007265
     5fc:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     600:	6f725043 	svcvs	0x00725043
     604:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     608:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     60c:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     610:	69775339 	ldmdbvs	r7!, {r0, r3, r4, r5, r8, r9, ip, lr}^
     614:	5f686374 	svcpl	0x00686374
     618:	50456f54 	subpl	r6, r5, r4, asr pc
     61c:	50433831 	subpl	r3, r3, r1, lsr r8
     620:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     624:	4c5f7373 	mrrcmi	3, 7, r7, pc, cr3	; <UNPREDICTABLE>
     628:	5f747369 	svcpl	0x00747369
     62c:	65646f4e 	strbvs	r6, [r4, #-3918]!	; 0xfffff0b2
     630:	75706300 	ldrbvc	r6, [r0, #-768]!	; 0xfffffd00
     634:	6e6f635f 	mcrvs	3, 3, r6, cr15, cr15, {2}
     638:	74786574 	ldrbtvc	r6, [r8], #-1396	; 0xfffffa8c
     63c:	65724300 	ldrbvs	r4, [r2, #-768]!	; 0xfffffd00
     640:	5f657461 	svcpl	0x00657461
     644:	636f7250 	cmnvs	pc, #80, 4
     648:	00737365 	rsbseq	r7, r3, r5, ror #6
     64c:	6e65704f 	cdpvs	0, 6, cr7, cr5, cr15, {2}
     650:	6e755200 	cdpvs	2, 7, cr5, cr5, cr0, {0}
     654:	73726946 	cmnvc	r2, #1146880	; 0x118000
     658:	73615474 	cmnvc	r1, #116, 8	; 0x74000000
     65c:	7562006b 	strbvc	r0, [r2, #-107]!	; 0xffffff95
     660:	6e6f7474 	mcrvs	4, 3, r7, cr15, cr4, {3}
     664:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     668:	50433631 	subpl	r3, r3, r1, lsr r6
     66c:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     670:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 4ac <shift+0x4ac>
     674:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     678:	34317265 	ldrtcc	r7, [r1], #-613	; 0xfffffd9b
     67c:	69746f4e 	ldmdbvs	r4!, {r1, r2, r3, r6, r8, r9, sl, fp, sp, lr}^
     680:	505f7966 	subspl	r7, pc, r6, ror #18
     684:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     688:	50457373 	subpl	r7, r5, r3, ror r3
     68c:	54543231 	ldrbpl	r3, [r4], #-561	; 0xfffffdcf
     690:	5f6b7361 	svcpl	0x006b7361
     694:	75727453 	ldrbvc	r7, [r2, #-1107]!	; 0xfffffbad
     698:	47007463 	strmi	r7, [r0, -r3, ror #8]
     69c:	535f7465 	cmppl	pc, #1694498816	; 0x65000000
     6a0:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     6a4:	666e495f 			; <UNDEFINED> instruction: 0x666e495f
     6a8:	4f49006f 	svcmi	0x0049006f
     6ac:	006c7443 	rsbeq	r7, ip, r3, asr #8
     6b0:	64616552 	strbtvs	r6, [r1], #-1362	; 0xfffffaae
     6b4:	72655400 	rsbvc	r5, r5, #0, 8
     6b8:	616e696d 	cmnvs	lr, sp, ror #18
     6bc:	53006574 	movwpl	r6, #1396	; 0x574
     6c0:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     6c4:	69545f6d 	ldmdbvs	r4, {r0, r2, r3, r5, r6, r8, r9, sl, fp, ip, lr}^
     6c8:	5f72656d 	svcpl	0x0072656d
     6cc:	65736142 	ldrbvs	r6, [r3, #-322]!	; 0xfffffebe
     6d0:	746f4e00 	strbtvc	r4, [pc], #-3584	; 6d8 <shift+0x6d8>
     6d4:	5f796669 	svcpl	0x00796669
     6d8:	636f7250 	cmnvs	pc, #80, 4
     6dc:	00737365 	rsbseq	r7, r3, r5, ror #6
     6e0:	314e5a5f 	cmpcc	lr, pc, asr sl
     6e4:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     6e8:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     6ec:	614d5f73 	hvcvs	54771	; 0xd5f3
     6f0:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     6f4:	45344372 	ldrmi	r4, [r4, #-882]!	; 0xfffffc8e
     6f8:	6f4e0076 	svcvs	0x004e0076
     6fc:	79666974 	stmdbvc	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
     700:	78614d00 	stmdavc	r1!, {r8, sl, fp, lr}^
     704:	68746150 	ldmdavs	r4!, {r4, r6, r8, sp, lr}^
     708:	676e654c 	strbvs	r6, [lr, -ip, asr #10]!
     70c:	4d006874 	stcmi	8, cr6, [r0, #-464]	; 0xfffffe30
     710:	53467861 	movtpl	r7, #26721	; 0x6861
     714:	76697244 	strbtvc	r7, [r9], -r4, asr #4
     718:	614e7265 	cmpvs	lr, r5, ror #4
     71c:	654c656d 	strbvs	r6, [ip, #-1389]	; 0xfffffa93
     720:	6874676e 	ldmdavs	r4!, {r1, r2, r3, r5, r6, r8, r9, sl, sp, lr}^
     724:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     728:	50433631 	subpl	r3, r3, r1, lsr r6
     72c:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     730:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 56c <shift+0x56c>
     734:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     738:	31317265 	teqcc	r1, r5, ror #4
     73c:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     740:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
     744:	4552525f 	ldrbmi	r5, [r2, #-607]	; 0xfffffda1
     748:	474e0076 	smlsldxmi	r0, lr, r6, r0
     74c:	535f7465 	cmppl	pc, #1694498816	; 0x65000000
     750:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     754:	666e495f 			; <UNDEFINED> instruction: 0x666e495f
     758:	79545f6f 	ldmdbvc	r4, {r0, r1, r2, r3, r5, r6, r8, r9, sl, fp, ip, lr}^
     75c:	47006570 	smlsdxmi	r0, r0, r5, r6
     760:	5f4f4950 	svcpl	0x004f4950
     764:	5f6e6950 	svcpl	0x006e6950
     768:	6e756f43 	cdpvs	15, 7, cr6, cr5, cr3, {2}
     76c:	61740074 	cmnvs	r4, r4, ror r0
     770:	5f006b73 	svcpl	0x00006b73
     774:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     778:	6f725043 	svcvs	0x00725043
     77c:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     780:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     784:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     788:	75523231 	ldrbvc	r3, [r2, #-561]	; 0xfffffdcf
     78c:	7269466e 	rsbvc	r4, r9, #115343360	; 0x6e00000
     790:	61547473 	cmpvs	r4, r3, ror r4
     794:	76456b73 			; <UNDEFINED> instruction: 0x76456b73
     798:	6f6f6200 	svcvs	0x006f6200
     79c:	5a5f006c 	bpl	17c0954 <__bss_end+0x17b6cbc>
     7a0:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     7a4:	636f7250 	cmnvs	pc, #80, 4
     7a8:	5f737365 	svcpl	0x00737365
     7ac:	616e614d 	cmnvs	lr, sp, asr #2
     7b0:	31726567 	cmncc	r2, r7, ror #10
     7b4:	74654738 	strbtvc	r4, [r5], #-1848	; 0xfffff8c8
     7b8:	6863535f 	stmdavs	r3!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     7bc:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
     7c0:	495f7265 	ldmdbmi	pc, {r0, r2, r5, r6, r9, ip, sp, lr}^	; <UNPREDICTABLE>
     7c4:	456f666e 	strbmi	r6, [pc, #-1646]!	; 15e <shift+0x15e>
     7c8:	474e3032 	smlaldxmi	r3, lr, r2, r0
     7cc:	535f7465 	cmppl	pc, #1694498816	; 0x65000000
     7d0:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     7d4:	666e495f 			; <UNDEFINED> instruction: 0x666e495f
     7d8:	79545f6f 	ldmdbvc	r4, {r0, r1, r2, r3, r5, r6, r8, r9, sl, fp, ip, lr}^
     7dc:	76506570 			; <UNDEFINED> instruction: 0x76506570
     7e0:	50474e00 	subpl	r4, r7, r0, lsl #28
     7e4:	495f4f49 	ldmdbmi	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     7e8:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
     7ec:	74707572 	ldrbtvc	r7, [r0], #-1394	; 0xfffffa8e
     7f0:	7079545f 	rsbsvc	r5, r9, pc, asr r4
     7f4:	52540065 	subspl	r0, r4, #101	; 0x65
     7f8:	425f474e 	subsmi	r4, pc, #20447232	; 0x1380000
     7fc:	00657361 	rsbeq	r7, r5, r1, ror #6
     800:	61666544 	cmnvs	r6, r4, asr #10
     804:	5f746c75 	svcpl	0x00746c75
     808:	636f6c43 	cmnvs	pc, #17152	; 0x4300
     80c:	61525f6b 	cmpvs	r2, fp, ror #30
     810:	6d006574 	cfstr32vs	mvfx6, [r0, #-464]	; 0xfffffe30
     814:	636f7250 	cmnvs	pc, #80, 4
     818:	5f737365 	svcpl	0x00737365
     81c:	7473694c 	ldrbtvc	r6, [r3], #-2380	; 0xfffff6b4
     820:	6165485f 	cmnvs	r5, pc, asr r8
     824:	536d0064 	cmnpl	sp, #100	; 0x64
     828:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     82c:	5f656c75 	svcpl	0x00656c75
     830:	00636e46 	rsbeq	r6, r3, r6, asr #28
     834:	314e5a5f 	cmpcc	lr, pc, asr sl
     838:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     83c:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     840:	614d5f73 	hvcvs	54771	; 0xd5f3
     844:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     848:	42313272 	eorsmi	r3, r1, #536870919	; 0x20000007
     84c:	6b636f6c 	blvs	18dc604 <__bss_end+0x18d296c>
     850:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
     854:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     858:	6f72505f 	svcvs	0x0072505f
     85c:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     860:	4c007645 	stcmi	6, cr7, [r0], {69}	; 0x45
     864:	5f6b636f 	svcpl	0x006b636f
     868:	6f6c6e55 	svcvs	0x006c6e55
     86c:	64656b63 	strbtvs	r6, [r5], #-2915	; 0xfffff49d
     870:	614c6d00 	cmpvs	ip, r0, lsl #26
     874:	505f7473 	subspl	r7, pc, r3, ror r4	; <UNPREDICTABLE>
     878:	5f004449 	svcpl	0x00004449
     87c:	6c62355a 	cfstr64vs	mvdx3, [r2], #-360	; 0xfffffe98
     880:	626b6e69 	rsbvs	r6, fp, #1680	; 0x690
     884:	69775300 	ldmdbvs	r7!, {r8, r9, ip, lr}^
     888:	5f686374 	svcpl	0x00686374
     88c:	43006f54 	movwmi	r6, #3924	; 0xf54
     890:	65736f6c 	ldrbvs	r6, [r3, #-3948]!	; 0xfffff094
     894:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     898:	50433631 	subpl	r3, r3, r1, lsr r6
     89c:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     8a0:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 6dc <shift+0x6dc>
     8a4:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     8a8:	32317265 	eorscc	r7, r1, #1342177286	; 0x50000006
     8ac:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     8b0:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
     8b4:	4644455f 			; <UNDEFINED> instruction: 0x4644455f
     8b8:	42007645 	andmi	r7, r0, #72351744	; 0x4500000
     8bc:	5f304353 	svcpl	0x00304353
     8c0:	65736142 	ldrbvs	r6, [r3, #-322]!	; 0xfffffebe
     8c4:	73695200 	cmnvc	r9, #0, 4
     8c8:	5f676e69 	svcpl	0x00676e69
     8cc:	65676445 	strbvs	r6, [r7, #-1093]!	; 0xfffffbbb
     8d0:	67726100 	ldrbvs	r6, [r2, -r0, lsl #2]!
     8d4:	69480063 	stmdbvs	r8, {r0, r1, r5, r6}^
     8d8:	6e006867 	cdpvs	8, 0, cr6, cr0, cr7, {3}
     8dc:	6669746f 	strbtvs	r7, [r9], -pc, ror #8
     8e0:	5f646569 	svcpl	0x00646569
     8e4:	64616564 	strbtvs	r6, [r1], #-1380	; 0xfffffa9c
     8e8:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
     8ec:	67726100 	ldrbvs	r6, [r2, -r0, lsl #2]!
     8f0:	61460076 	hvcvs	24582	; 0x6006
     8f4:	6e696c6c 	cdpvs	12, 6, cr6, cr9, cr12, {3}
     8f8:	64455f67 	strbvs	r5, [r5], #-3943	; 0xfffff099
     8fc:	5f006567 	svcpl	0x00006567
     900:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     904:	6f725043 	svcvs	0x00725043
     908:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     90c:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     910:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     914:	6f4e3431 	svcvs	0x004e3431
     918:	79666974 	stmdbvc	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
     91c:	6f72505f 	svcvs	0x0072505f
     920:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     924:	4e006a45 	vmlsmi.f32	s12, s0, s10
     928:	6c69466f 	stclvs	6, cr4, [r9], #-444	; 0xfffffe44
     92c:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     930:	446d6574 	strbtmi	r6, [sp], #-1396	; 0xfffffa8c
     934:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
     938:	6f6c0072 	svcvs	0x006c0072
     93c:	70697067 	rsbvc	r7, r9, r7, rrx
     940:	65440065 	strbvs	r0, [r4, #-101]	; 0xffffff9b
     944:	696c6461 	stmdbvs	ip!, {r0, r5, r6, sl, sp, lr}^
     948:	4400656e 	strmi	r6, [r0], #-1390	; 0xfffffa92
     94c:	62617369 	rsbvs	r7, r1, #-1543503871	; 0xa4000001
     950:	455f656c 	ldrbmi	r6, [pc, #-1388]	; 3ec <shift+0x3ec>
     954:	746e6576 	strbtvc	r6, [lr], #-1398	; 0xfffffa8a
     958:	7465445f 	strbtvc	r4, [r5], #-1119	; 0xfffffba1
     95c:	69746365 	ldmdbvs	r4!, {r0, r2, r5, r6, r8, r9, sp, lr}^
     960:	73006e6f 	movwvc	r6, #3695	; 0xe6f
     964:	74726f68 	ldrbtvc	r6, [r2], #-3944	; 0xfffff098
     968:	746e6920 	strbtvc	r6, [lr], #-2336	; 0xfffff6e0
     96c:	74726900 	ldrbtvc	r6, [r2], #-2304	; 0xfffff700
     970:	00657079 	rsbeq	r7, r5, r9, ror r0
     974:	4678614d 	ldrbtmi	r6, [r8], -sp, asr #2
     978:	6e656c69 	cdpvs	12, 6, cr6, cr5, cr9, {3}
     97c:	4c656d61 	stclmi	13, cr6, [r5], #-388	; 0xfffffe7c
     980:	74676e65 	strbtvc	r6, [r7], #-3685	; 0xfffff19b
     984:	50430068 	subpl	r0, r3, r8, rrx
     988:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     98c:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 7c8 <shift+0x7c8>
     990:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     994:	70007265 	andvc	r7, r0, r5, ror #4
     998:	69737968 	ldmdbvs	r3!, {r3, r5, r6, r8, fp, ip, sp, lr}^
     99c:	5f6c6163 	svcpl	0x006c6163
     9a0:	61657262 	cmnvs	r5, r2, ror #4
     9a4:	7474006b 	ldrbtvc	r0, [r4], #-107	; 0xffffff95
     9a8:	00307262 	eorseq	r7, r0, r2, ror #4
     9ac:	4957534e 	ldmdbmi	r7, {r1, r2, r3, r6, r8, r9, ip, lr}^
     9b0:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     9b4:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     9b8:	5f6d6574 	svcpl	0x006d6574
     9bc:	76726553 			; <UNDEFINED> instruction: 0x76726553
     9c0:	00656369 	rsbeq	r6, r5, r9, ror #6
     9c4:	4957534e 	ldmdbmi	r7, {r1, r2, r3, r6, r8, r9, ip, lr}^
     9c8:	6f72505f 	svcvs	0x0072505f
     9cc:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     9d0:	7265535f 	rsbvc	r5, r5, #2080374785	; 0x7c000001
     9d4:	65636976 	strbvs	r6, [r3, #-2422]!	; 0xfffff68a
     9d8:	65706f00 	ldrbvs	r6, [r0, #-3840]!	; 0xfffff100
     9dc:	5f64656e 	svcpl	0x0064656e
     9e0:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
     9e4:	69590073 	ldmdbvs	r9, {r0, r1, r4, r5, r6}^
     9e8:	00646c65 	rsbeq	r6, r4, r5, ror #24
     9ec:	65646e49 	strbvs	r6, [r4, #-3657]!	; 0xfffff1b7
     9f0:	696e6966 	stmdbvs	lr!, {r1, r2, r5, r6, r8, fp, sp, lr}^
     9f4:	47006574 	smlsdxmi	r0, r4, r5, r6
     9f8:	505f7465 	subspl	r7, pc, r5, ror #8
     9fc:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     a00:	425f7373 	subsmi	r7, pc, #-872415231	; 0xcc000001
     a04:	49505f79 	ldmdbmi	r0, {r0, r3, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     a08:	6e450044 	cdpvs	0, 4, cr0, cr5, cr4, {2}
     a0c:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
     a10:	6576455f 	ldrbvs	r4, [r6, #-1375]!	; 0xfffffaa1
     a14:	445f746e 	ldrbmi	r7, [pc], #-1134	; a1c <shift+0xa1c>
     a18:	63657465 	cmnvs	r5, #1694498816	; 0x65000000
     a1c:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     a20:	72655000 	rsbvc	r5, r5, #0
     a24:	65687069 	strbvs	r7, [r8, #-105]!	; 0xffffff97
     a28:	5f6c6172 	svcpl	0x006c6172
     a2c:	65736142 	ldrbvs	r6, [r3, #-322]!	; 0xfffffebe
     a30:	766e4900 	strbtvc	r4, [lr], -r0, lsl #18
     a34:	64696c61 	strbtvs	r6, [r9], #-3169	; 0xfffff39f
     a38:	6e69505f 	mcrvs	0, 3, r5, cr9, cr15, {2}
     a3c:	636f4c00 	cmnvs	pc, #0, 24
     a40:	6f4c5f6b 	svcvs	0x004c5f6b
     a44:	64656b63 	strbtvs	r6, [r5], #-2915	; 0xfffff49d
     a48:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     a4c:	50433631 	subpl	r3, r3, r1, lsr r6
     a50:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     a54:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 890 <shift+0x890>
     a58:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     a5c:	38317265 	ldmdacc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
     a60:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     a64:	505f656c 	subspl	r6, pc, ip, ror #10
     a68:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     a6c:	535f7373 	cmppl	pc, #-872415231	; 0xcc000001
     a70:	32454957 	subcc	r4, r5, #1425408	; 0x15c000
     a74:	57534e30 	smmlarpl	r3, r0, lr, r4
     a78:	72505f49 	subsvc	r5, r0, #292	; 0x124
     a7c:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     a80:	65535f73 	ldrbvs	r5, [r3, #-3955]	; 0xfffff08d
     a84:	63697672 	cmnvs	r9, #119537664	; 0x7200000
     a88:	6a6a6a65 	bvs	1a9b424 <__bss_end+0x1a9178c>
     a8c:	54313152 	ldrtpl	r3, [r1], #-338	; 0xfffffeae
     a90:	5f495753 	svcpl	0x00495753
     a94:	75736552 	ldrbvc	r6, [r3, #-1362]!	; 0xfffffaae
     a98:	7300746c 	movwvc	r7, #1132	; 0x46c
     a9c:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     aa0:	756f635f 	strbvc	r6, [pc, #-863]!	; 749 <shift+0x749>
     aa4:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
     aa8:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     aac:	7261505f 	rsbvc	r5, r1, #95	; 0x5f
     ab0:	00736d61 	rsbseq	r6, r3, r1, ror #26
     ab4:	69736e75 	ldmdbvs	r3!, {r0, r2, r4, r5, r6, r9, sl, fp, sp, lr}^
     ab8:	64656e67 	strbtvs	r6, [r5], #-3687	; 0xfffff199
     abc:	61686320 	cmnvs	r8, r0, lsr #6
     ac0:	614d0072 	hvcvs	53250	; 0xd002
     ac4:	636f6c6c 	cmnvs	pc, #108, 24	; 0x6c00
     ac8:	746e4900 	strbtvc	r4, [lr], #-2304	; 0xfffff700
     acc:	75727265 	ldrbvc	r7, [r2, #-613]!	; 0xfffffd9b
     ad0:	62617470 	rsbvs	r7, r1, #112, 8	; 0x70000000
     ad4:	535f656c 	cmppl	pc, #108, 10	; 0x1b000000
     ad8:	7065656c 	rsbvc	r6, r5, ip, ror #10
     adc:	68635300 	stmdavs	r3!, {r8, r9, ip, lr}^
     ae0:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
     ae4:	52525f65 	subspl	r5, r2, #404	; 0x194
     ae8:	58554100 	ldmdapl	r5, {r8, lr}^
     aec:	7361425f 	cmnvc	r1, #-268435451	; 0xf0000005
     af0:	53420065 	movtpl	r0, #8293	; 0x2065
     af4:	425f3243 	subsmi	r3, pc, #805306372	; 0x30000004
     af8:	00657361 	rsbeq	r7, r5, r1, ror #6
     afc:	74617473 	strbtvc	r7, [r1], #-1139	; 0xfffffb8d
     b00:	72570065 	subsvc	r0, r7, #101	; 0x65
     b04:	5f657469 	svcpl	0x00657469
     b08:	796c6e4f 	stmdbvc	ip!, {r0, r1, r2, r3, r6, r9, sl, fp, sp, lr}^
     b0c:	68635300 	stmdavs	r3!, {r8, r9, ip, lr}^
     b10:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
     b14:	682f0065 	stmdavs	pc!, {r0, r2, r5, r6}	; <UNPREDICTABLE>
     b18:	2f656d6f 	svccs	0x00656d6f
     b1c:	66657274 			; <UNDEFINED> instruction: 0x66657274
     b20:	732f6c69 			; <UNDEFINED> instruction: 0x732f6c69
     b24:	732f6d65 			; <UNDEFINED> instruction: 0x732f6d65
     b28:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
     b2c:	752f7365 	strvc	r7, [pc, #-869]!	; 7cf <shift+0x7cf>
     b30:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
     b34:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
     b38:	736f732f 	cmnvc	pc, #-1140850688	; 0xbc000000
     b3c:	7361745f 	cmnvc	r1, #1593835520	; 0x5f000000
     b40:	616d2f6b 	cmnvs	sp, fp, ror #30
     b44:	632e6e69 			; <UNDEFINED> instruction: 0x632e6e69
     b48:	54007070 	strpl	r7, [r0], #-112	; 0xffffff90
     b4c:	5f6b6369 	svcpl	0x006b6369
     b50:	6e756f43 	cdpvs	15, 7, cr6, cr5, cr3, {2}
     b54:	72460074 	subvc	r0, r6, #116	; 0x74
     b58:	5f006565 	svcpl	0x00006565
     b5c:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     b60:	6f725043 	svcvs	0x00725043
     b64:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     b68:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     b6c:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     b70:	6e553831 	mrcvs	8, 2, r3, cr5, cr1, {1}
     b74:	5f70616d 	svcpl	0x0070616d
     b78:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     b7c:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
     b80:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     b84:	53006a45 	movwpl	r6, #2629	; 0xa45
     b88:	006b7262 	rsbeq	r7, fp, r2, ror #4
     b8c:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     b90:	465f656c 	ldrbmi	r6, [pc], -ip, ror #10
     b94:	73656c69 	cmnvc	r5, #26880	; 0x6900
     b98:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     b9c:	57535f6d 	ldrbpl	r5, [r3, -sp, ror #30]
     ba0:	68730049 	ldmdavs	r3!, {r0, r3, r6}^
     ba4:	2074726f 	rsbscs	r7, r4, pc, ror #4
     ba8:	69736e75 	ldmdbvs	r3!, {r0, r2, r4, r5, r6, r9, sl, fp, sp, lr}^
     bac:	64656e67 	strbtvs	r6, [r5], #-3687	; 0xfffff199
     bb0:	746e6920 	strbtvc	r6, [lr], #-2336	; 0xfffff6e0
     bb4:	61656800 	cmnvs	r5, r0, lsl #16
     bb8:	74735f70 	ldrbtvc	r5, [r3], #-3952	; 0xfffff090
     bbc:	00747261 	rsbseq	r7, r4, r1, ror #4
     bc0:	65746e49 	ldrbvs	r6, [r4, #-3657]!	; 0xfffff1b7
     bc4:	70757272 	rsbsvc	r7, r5, r2, ror r2
     bc8:	6f435f74 	svcvs	0x00435f74
     bcc:	6f72746e 	svcvs	0x0072746e
     bd0:	72656c6c 	rsbvc	r6, r5, #108, 24	; 0x6c00
     bd4:	7361425f 	cmnvc	r1, #-268435451	; 0xf0000005
     bd8:	65520065 	ldrbvs	r0, [r2, #-101]	; 0xffffff9b
     bdc:	575f6461 	ldrbpl	r6, [pc, -r1, ror #8]
     be0:	65746972 	ldrbvs	r6, [r4, #-2418]!	; 0xfffff68e
     be4:	74634100 	strbtvc	r4, [r3], #-256	; 0xffffff00
     be8:	5f657669 	svcpl	0x00657669
     bec:	636f7250 	cmnvs	pc, #80, 4
     bf0:	5f737365 	svcpl	0x00737365
     bf4:	6e756f43 	cdpvs	15, 7, cr6, cr5, cr3, {2}
     bf8:	79730074 	ldmdbvc	r3!, {r2, r4, r5, r6}^
     bfc:	6c6f626d 	sfmvs	f6, 2, [pc], #-436	; a50 <shift+0xa50>
     c00:	6369745f 	cmnvs	r9, #1593835520	; 0x5f000000
     c04:	65645f6b 	strbvs	r5, [r4, #-3947]!	; 0xfffff095
     c08:	0079616c 	rsbseq	r6, r9, ip, ror #2
     c0c:	314e5a5f 	cmpcc	lr, pc, asr sl
     c10:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     c14:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     c18:	614d5f73 	hvcvs	54771	; 0xd5f3
     c1c:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     c20:	48313272 	ldmdami	r1!, {r1, r4, r5, r6, r9, ip, sp}
     c24:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     c28:	69465f65 	stmdbvs	r6, {r0, r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     c2c:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
     c30:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
     c34:	4957535f 	ldmdbmi	r7, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     c38:	4e333245 	cdpmi	2, 3, cr3, cr3, cr5, {2}
     c3c:	5f495753 	svcpl	0x00495753
     c40:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     c44:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
     c48:	535f6d65 	cmppl	pc, #6464	; 0x1940
     c4c:	69767265 	ldmdbvs	r6!, {r0, r2, r5, r6, r9, ip, sp, lr}^
     c50:	6a6a6563 	bvs	1a9a1e4 <__bss_end+0x1a9054c>
     c54:	3131526a 	teqcc	r1, sl, ror #4
     c58:	49575354 	ldmdbmi	r7, {r2, r4, r6, r8, r9, ip, lr}^
     c5c:	7365525f 	cmnvc	r5, #-268435451	; 0xf0000005
     c60:	00746c75 	rsbseq	r6, r4, r5, ror ip
     c64:	736f6c63 	cmnvc	pc, #25344	; 0x6300
     c68:	65530065 	ldrbvs	r0, [r3, #-101]	; 0xffffff9b
     c6c:	65525f74 	ldrbvs	r5, [r2, #-3956]	; 0xfffff08c
     c70:	6974616c 	ldmdbvs	r4!, {r2, r3, r5, r6, r8, sp, lr}^
     c74:	72006576 	andvc	r6, r0, #494927872	; 0x1d800000
     c78:	61767465 	cmnvs	r6, r5, ror #8
     c7c:	636e006c 	cmnvs	lr, #108	; 0x6c
     c80:	72007275 	andvc	r7, r0, #1342177287	; 0x50000007
     c84:	6d756e64 	ldclvs	14, cr6, [r5, #-400]!	; 0xfffffe70
     c88:	315a5f00 	cmpcc	sl, r0, lsl #30
     c8c:	68637331 	stmdavs	r3!, {r0, r4, r5, r8, r9, ip, sp, lr}^
     c90:	795f6465 	ldmdbvc	pc, {r0, r2, r5, r6, sl, sp, lr}^	; <UNPREDICTABLE>
     c94:	646c6569 	strbtvs	r6, [ip], #-1385	; 0xfffffa97
     c98:	5a5f0076 	bpl	17c0e78 <__bss_end+0x17b71e0>
     c9c:	65733731 	ldrbvs	r3, [r3, #-1841]!	; 0xfffff8cf
     ca0:	61745f74 	cmnvs	r4, r4, ror pc
     ca4:	645f6b73 	ldrbvs	r6, [pc], #-2931	; cac <shift+0xcac>
     ca8:	6c646165 	stfvse	f6, [r4], #-404	; 0xfffffe6c
     cac:	6a656e69 	bvs	195c658 <__bss_end+0x19529c0>
     cb0:	69617700 	stmdbvs	r1!, {r8, r9, sl, ip, sp, lr}^
     cb4:	5a5f0074 	bpl	17c0e8c <__bss_end+0x17b71f4>
     cb8:	746f6e36 	strbtvc	r6, [pc], #-3638	; cc0 <shift+0xcc0>
     cbc:	6a796669 	bvs	1e5a668 <__bss_end+0x1e509d0>
     cc0:	6146006a 	cmpvs	r6, sl, rrx
     cc4:	65006c69 	strvs	r6, [r0, #-3177]	; 0xfffff397
     cc8:	63746978 	cmnvs	r4, #120, 18	; 0x1e0000
     ccc:	0065646f 	rsbeq	r6, r5, pc, ror #8
     cd0:	65686373 	strbvs	r6, [r8, #-883]!	; 0xfffffc8d
     cd4:	69795f64 	ldmdbvs	r9!, {r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     cd8:	00646c65 	rsbeq	r6, r4, r5, ror #24
     cdc:	6b636974 	blvs	18db2b4 <__bss_end+0x18d161c>
     ce0:	756f635f 	strbvc	r6, [pc, #-863]!	; 989 <shift+0x989>
     ce4:	725f746e 	subsvc	r7, pc, #1845493760	; 0x6e000000
     ce8:	69757165 	ldmdbvs	r5!, {r0, r2, r5, r6, r8, ip, sp, lr}^
     cec:	00646572 	rsbeq	r6, r4, r2, ror r5
     cf0:	34325a5f 	ldrtcc	r5, [r2], #-2655	; 0xfffff5a1
     cf4:	5f746567 	svcpl	0x00746567
     cf8:	69746361 	ldmdbvs	r4!, {r0, r5, r6, r8, r9, sp, lr}^
     cfc:	705f6576 	subsvc	r6, pc, r6, ror r5	; <UNPREDICTABLE>
     d00:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     d04:	635f7373 	cmpvs	pc, #-872415231	; 0xcc000001
     d08:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
     d0c:	69500076 	ldmdbvs	r0, {r1, r2, r4, r5, r6}^
     d10:	465f6570 			; <UNDEFINED> instruction: 0x465f6570
     d14:	5f656c69 	svcpl	0x00656c69
     d18:	66657250 			; <UNDEFINED> instruction: 0x66657250
     d1c:	5f007869 	svcpl	0x00007869
     d20:	6734315a 			; <UNDEFINED> instruction: 0x6734315a
     d24:	745f7465 	ldrbvc	r7, [pc], #-1125	; d2c <shift+0xd2c>
     d28:	5f6b6369 	svcpl	0x006b6369
     d2c:	6e756f63 	cdpvs	15, 7, cr6, cr5, cr3, {3}
     d30:	73007674 	movwvc	r7, #1652	; 0x674
     d34:	7065656c 	rsbvc	r6, r5, ip, ror #10
     d38:	395a5f00 	ldmdbcc	sl, {r8, r9, sl, fp, ip, lr}^
     d3c:	6d726574 	cfldr64vs	mvdx6, [r2, #-464]!	; 0xfffffe30
     d40:	74616e69 	strbtvc	r6, [r1], #-3689	; 0xfffff197
     d44:	6f006965 	svcvs	0x00006965
     d48:	61726570 	cmnvs	r2, r0, ror r5
     d4c:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     d50:	355a5f00 	ldrbcc	r5, [sl, #-3840]	; 0xfffff100
     d54:	736f6c63 	cmnvc	pc, #25344	; 0x6300
     d58:	5f006a65 	svcpl	0x00006a65
     d5c:	6567365a 	strbvs	r3, [r7, #-1626]!	; 0xfffff9a6
     d60:	64697074 	strbtvs	r7, [r9], #-116	; 0xffffff8c
     d64:	6e660076 	mcrvs	0, 3, r0, cr6, cr6, {3}
     d68:	00656d61 	rsbeq	r6, r5, r1, ror #26
     d6c:	20554e47 	subscs	r4, r5, r7, asr #28
     d70:	312b2b43 			; <UNDEFINED> instruction: 0x312b2b43
     d74:	30312034 	eorscc	r2, r1, r4, lsr r0
     d78:	312e332e 			; <UNDEFINED> instruction: 0x312e332e
     d7c:	32303220 	eorscc	r3, r0, #32, 4
     d80:	32363031 	eorscc	r3, r6, #49	; 0x31
     d84:	72282031 	eorvc	r2, r8, #49	; 0x31
     d88:	61656c65 	cmnvs	r5, r5, ror #24
     d8c:	20296573 	eorcs	r6, r9, r3, ror r5
     d90:	6c666d2d 	stclvs	13, cr6, [r6], #-180	; 0xffffff4c
     d94:	2d74616f 	ldfcse	f6, [r4, #-444]!	; 0xfffffe44
     d98:	3d696261 	sfmcc	f6, 2, [r9, #-388]!	; 0xfffffe7c
     d9c:	64726168 	ldrbtvs	r6, [r2], #-360	; 0xfffffe98
     da0:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
     da4:	763d7570 			; <UNDEFINED> instruction: 0x763d7570
     da8:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
     dac:	6f6c666d 	svcvs	0x006c666d
     db0:	612d7461 			; <UNDEFINED> instruction: 0x612d7461
     db4:	683d6962 	ldmdavs	sp!, {r1, r5, r6, r8, fp, sp, lr}
     db8:	20647261 	rsbcs	r7, r4, r1, ror #4
     dbc:	70666d2d 	rsbvc	r6, r6, sp, lsr #26
     dc0:	66763d75 			; <UNDEFINED> instruction: 0x66763d75
     dc4:	6d2d2070 	stcvs	0, cr2, [sp, #-448]!	; 0xfffffe40
     dc8:	656e7574 	strbvs	r7, [lr, #-1396]!	; 0xfffffa8c
     dcc:	6d72613d 	ldfvse	f6, [r2, #-244]!	; 0xffffff0c
     dd0:	36373131 			; <UNDEFINED> instruction: 0x36373131
     dd4:	2d667a6a 	vstmdbcs	r6!, {s15-s120}
     dd8:	6d2d2073 	stcvs	0, cr2, [sp, #-460]!	; 0xfffffe34
     ddc:	206d7261 	rsbcs	r7, sp, r1, ror #4
     de0:	72616d2d 	rsbvc	r6, r1, #2880	; 0xb40
     de4:	613d6863 	teqvs	sp, r3, ror #16
     de8:	36766d72 			; <UNDEFINED> instruction: 0x36766d72
     dec:	662b6b7a 			; <UNDEFINED> instruction: 0x662b6b7a
     df0:	672d2070 			; <UNDEFINED> instruction: 0x672d2070
     df4:	20672d20 	rsbcs	r2, r7, r0, lsr #26
     df8:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
     dfc:	2d20304f 	stccs	0, cr3, [r0, #-316]!	; 0xfffffec4
     e00:	2d20304f 	stccs	0, cr3, [r0, #-316]!	; 0xfffffec4
     e04:	2d6f6e66 	stclcs	14, cr6, [pc, #-408]!	; c74 <shift+0xc74>
     e08:	65637865 	strbvs	r7, [r3, #-2149]!	; 0xfffff79b
     e0c:	6f697470 	svcvs	0x00697470
     e10:	2d20736e 	stccs	3, cr7, [r0, #-440]!	; 0xfffffe48
     e14:	2d6f6e66 	stclcs	14, cr6, [pc, #-408]!	; c84 <shift+0xc84>
     e18:	69747472 	ldmdbvs	r4!, {r1, r4, r5, r6, sl, ip, sp, lr}^
     e1c:	69727700 	ldmdbvs	r2!, {r8, r9, sl, ip, sp, lr}^
     e20:	74006574 	strvc	r6, [r0], #-1396	; 0xfffffa8c
     e24:	736b6369 	cmnvc	fp, #-1543503871	; 0xa4000001
     e28:	65706f00 	ldrbvs	r6, [r0, #-3840]!	; 0xfffff100
     e2c:	5a5f006e 	bpl	17c0fec <__bss_end+0x17b7354>
     e30:	70697034 	rsbvc	r7, r9, r4, lsr r0
     e34:	634b5065 	movtvs	r5, #45157	; 0xb065
     e38:	444e006a 	strbmi	r0, [lr], #-106	; 0xffffff96
     e3c:	6c646165 	stfvse	f6, [r4], #-404	; 0xfffffe6c
     e40:	5f656e69 	svcpl	0x00656e69
     e44:	73627553 	cmnvc	r2, #348127232	; 0x14c00000
     e48:	69767265 	ldmdbvs	r6!, {r0, r2, r5, r6, r9, ip, sp, lr}^
     e4c:	67006563 	strvs	r6, [r0, -r3, ror #10]
     e50:	745f7465 	ldrbvc	r7, [pc], #-1125	; e58 <shift+0xe58>
     e54:	5f6b6369 	svcpl	0x006b6369
     e58:	6e756f63 	cdpvs	15, 7, cr6, cr5, cr3, {3}
     e5c:	61700074 	cmnvs	r0, r4, ror r0
     e60:	006d6172 	rsbeq	r6, sp, r2, ror r1
     e64:	77355a5f 			; <UNDEFINED> instruction: 0x77355a5f
     e68:	65746972 	ldrbvs	r6, [r4, #-2418]!	; 0xfffff68e
     e6c:	634b506a 	movtvs	r5, #45162	; 0xb06a
     e70:	6567006a 	strbvs	r0, [r7, #-106]!	; 0xffffff96
     e74:	61745f74 	cmnvs	r4, r4, ror pc
     e78:	745f6b73 	ldrbvc	r6, [pc], #-2931	; e80 <shift+0xe80>
     e7c:	736b6369 	cmnvc	fp, #-1543503871	; 0xa4000001
     e80:	5f6f745f 	svcpl	0x006f745f
     e84:	64616564 	strbtvs	r6, [r1], #-1380	; 0xfffffa9c
     e88:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
     e8c:	66756200 	ldrbtvs	r6, [r5], -r0, lsl #4
     e90:	7a69735f 	bvc	1a5dc14 <__bss_end+0x1a53f7c>
     e94:	682f0065 	stmdavs	pc!, {r0, r2, r5, r6}	; <UNPREDICTABLE>
     e98:	2f656d6f 	svccs	0x00656d6f
     e9c:	66657274 			; <UNDEFINED> instruction: 0x66657274
     ea0:	732f6c69 			; <UNDEFINED> instruction: 0x732f6c69
     ea4:	732f6d65 			; <UNDEFINED> instruction: 0x732f6d65
     ea8:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
     eac:	622f7365 	eorvs	r7, pc, #-1811939327	; 0x94000001
     eb0:	646c6975 	strbtvs	r6, [ip], #-2421	; 0xfffff68b
     eb4:	74657300 	strbtvc	r7, [r5], #-768	; 0xfffffd00
     eb8:	7361745f 	cmnvc	r1, #1593835520	; 0x5f000000
     ebc:	65645f6b 	strbvs	r5, [r4, #-3947]!	; 0xfffff095
     ec0:	696c6461 	stmdbvs	ip!, {r0, r5, r6, sl, sp, lr}^
     ec4:	5f00656e 	svcpl	0x0000656e
     ec8:	6c73355a 	cfldr64vs	mvdx3, [r3], #-360	; 0xfffffe98
     ecc:	6a706565 	bvs	1c1a468 <__bss_end+0x1c107d0>
     ed0:	6966006a 	stmdbvs	r6!, {r1, r3, r5, r6}^
     ed4:	4700656c 	strmi	r6, [r0, -ip, ror #10]
     ed8:	525f7465 	subspl	r7, pc, #1694498816	; 0x65000000
     edc:	69616d65 	stmdbvs	r1!, {r0, r2, r5, r6, r8, sl, fp, sp, lr}^
     ee0:	676e696e 	strbvs	r6, [lr, -lr, ror #18]!
     ee4:	325a5f00 	subscc	r5, sl, #0, 30
     ee8:	74656736 	strbtvc	r6, [r5], #-1846	; 0xfffff8ca
     eec:	7361745f 	cmnvc	r1, #1593835520	; 0x5f000000
     ef0:	69745f6b 	ldmdbvs	r4!, {r0, r1, r3, r5, r6, r8, r9, sl, fp, ip, lr}^
     ef4:	5f736b63 	svcpl	0x00736b63
     ef8:	645f6f74 	ldrbvs	r6, [pc], #-3956	; f00 <shift+0xf00>
     efc:	6c646165 	stfvse	f6, [r4], #-404	; 0xfffffe6c
     f00:	76656e69 	strbtvc	r6, [r5], -r9, ror #28
     f04:	6f682f00 	svcvs	0x00682f00
     f08:	742f656d 	strtvc	r6, [pc], #-1389	; f10 <shift+0xf10>
     f0c:	69666572 	stmdbvs	r6!, {r1, r4, r5, r6, r8, sl, sp, lr}^
     f10:	65732f6c 	ldrbvs	r2, [r3, #-3948]!	; 0xfffff094
     f14:	6f732f6d 	svcvs	0x00732f6d
     f18:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
     f1c:	74732f73 	ldrbtvc	r2, [r3], #-3955	; 0xfffff08d
     f20:	62696c64 	rsbvs	r6, r9, #100, 24	; 0x6400
     f24:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
     f28:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
     f2c:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
     f30:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
     f34:	57534e00 	ldrbpl	r4, [r3, -r0, lsl #28]
     f38:	65525f49 	ldrbvs	r5, [r2, #-3913]	; 0xfffff0b7
     f3c:	746c7573 	strbtvc	r7, [ip], #-1395	; 0xfffffa8d
     f40:	646f435f 	strbtvs	r4, [pc], #-863	; f48 <shift+0xf48>
     f44:	72770065 	rsbsvc	r0, r7, #101	; 0x65
     f48:	006d756e 	rsbeq	r7, sp, lr, ror #10
     f4c:	77345a5f 			; <UNDEFINED> instruction: 0x77345a5f
     f50:	6a746961 	bvs	1d1b4dc <__bss_end+0x1d11844>
     f54:	5f006a6a 	svcpl	0x00006a6a
     f58:	6f69355a 	svcvs	0x0069355a
     f5c:	6a6c7463 	bvs	1b1e0f0 <__bss_end+0x1b14458>
     f60:	494e3631 	stmdbmi	lr, {r0, r4, r5, r9, sl, ip, sp}^
     f64:	6c74434f 	ldclvs	3, cr4, [r4], #-316	; 0xfffffec4
     f68:	65704f5f 	ldrbvs	r4, [r0, #-3935]!	; 0xfffff0a1
     f6c:	69746172 	ldmdbvs	r4!, {r1, r4, r5, r6, r8, sp, lr}^
     f70:	76506e6f 	ldrbvc	r6, [r0], -pc, ror #28
     f74:	636f6900 	cmnvs	pc, #0, 18
     f78:	72006c74 	andvc	r6, r0, #116, 24	; 0x7400
     f7c:	6e637465 	cdpvs	4, 6, cr7, cr3, cr5, {3}
     f80:	6f6e0074 	svcvs	0x006e0074
     f84:	79666974 	stmdbvc	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
     f88:	72657400 	rsbvc	r7, r5, #0, 8
     f8c:	616e696d 	cmnvs	lr, sp, ror #18
     f90:	6d006574 	cfstr32vs	mvfx6, [r0, #-464]	; 0xfffffe30
     f94:	0065646f 	rsbeq	r6, r5, pc, ror #8
     f98:	66667562 	strbtvs	r7, [r6], -r2, ror #10
     f9c:	5f007265 	svcpl	0x00007265
     fa0:	6572345a 	ldrbvs	r3, [r2, #-1114]!	; 0xfffffba6
     fa4:	506a6461 	rsbpl	r6, sl, r1, ror #8
     fa8:	72006a63 	andvc	r6, r0, #405504	; 0x63000
     fac:	6f637465 	svcvs	0x00637465
     fb0:	67006564 	strvs	r6, [r0, -r4, ror #10]
     fb4:	615f7465 	cmpvs	pc, r5, ror #8
     fb8:	76697463 	strbtvc	r7, [r9], -r3, ror #8
     fbc:	72705f65 	rsbsvc	r5, r0, #404	; 0x194
     fc0:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     fc4:	6f635f73 	svcvs	0x00635f73
     fc8:	00746e75 	rsbseq	r6, r4, r5, ror lr
     fcc:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
     fd0:	656d616e 	strbvs	r6, [sp, #-366]!	; 0xfffffe92
     fd4:	61657200 	cmnvs	r5, r0, lsl #4
     fd8:	65670064 	strbvs	r0, [r7, #-100]!	; 0xffffff9c
     fdc:	64697074 	strbtvs	r7, [r9], #-116	; 0xffffff8c
     fe0:	345a5f00 	ldrbcc	r5, [sl], #-3840	; 0xfffff100
     fe4:	6e65706f 	cdpvs	0, 6, cr7, cr5, cr15, {3}
     fe8:	31634b50 	cmncc	r3, r0, asr fp
     fec:	69464e35 	stmdbvs	r6, {r0, r2, r4, r5, r9, sl, fp, lr}^
     ff0:	4f5f656c 	svcmi	0x005f656c
     ff4:	5f6e6570 	svcpl	0x006e6570
     ff8:	65646f4d 	strbvs	r6, [r4, #-3917]!	; 0xfffff0b3
     ffc:	375a5f00 	ldrbcc	r5, [sl, -r0, lsl #30]
    1000:	6e727473 	mrcvs	4, 3, r7, cr2, cr3, {3}
    1004:	50797063 	rsbspl	r7, r9, r3, rrx
    1008:	634b5063 	movtvs	r5, #45155	; 0xb063
    100c:	5a5f0069 	bpl	17c11b8 <__bss_end+0x17b7520>
    1010:	6d656d36 	stclvs	13, cr6, [r5, #-216]!	; 0xffffff28
    1014:	50797063 	rsbspl	r7, r9, r3, rrx
    1018:	7650764b 	ldrbvc	r7, [r0], -fp, asr #12
    101c:	5a5f0069 	bpl	17c11c8 <__bss_end+0x17b7530>
    1020:	65673431 	strbvs	r3, [r7, #-1073]!	; 0xfffffbcf
    1024:	6e695f74 	mcrvs	15, 3, r5, cr9, cr4, {3}
    1028:	5f747570 	svcpl	0x00747570
    102c:	65707974 	ldrbvs	r7, [r0, #-2420]!	; 0xfffff68c
    1030:	00634b50 	rsbeq	r4, r3, r0, asr fp
    1034:	6e345a5f 			; <UNDEFINED> instruction: 0x6e345a5f
    1038:	6975745f 	ldmdbvs	r5!, {r0, r1, r2, r3, r4, r6, sl, ip, sp, lr}^
    103c:	74610069 	strbtvc	r0, [r1], #-105	; 0xffffff97
    1040:	6700666f 	strvs	r6, [r0, -pc, ror #12]
    1044:	695f7465 	ldmdbvs	pc, {r0, r2, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
    1048:	7475706e 	ldrbtvc	r7, [r5], #-110	; 0xffffff92
    104c:	7079745f 	rsbsvc	r7, r9, pc, asr r4
    1050:	74610065 	strbtvc	r0, [r1], #-101	; 0xffffff9b
    1054:	5f00696f 	svcpl	0x0000696f
    1058:	7461345a 	strbtvc	r3, [r1], #-1114	; 0xfffffba6
    105c:	4b50666f 	blmi	141aa20 <__bss_end+0x1410d88>
    1060:	65640063 	strbvs	r0, [r4, #-99]!	; 0xffffff9d
    1064:	69007473 	stmdbvs	r0, {r0, r1, r4, r5, r6, sl, ip, sp, lr}
    1068:	7475706e 	ldrbtvc	r7, [r5], #-110	; 0xffffff92
    106c:	67697300 	strbvs	r7, [r9, -r0, lsl #6]!
    1070:	7473006e 	ldrbtvc	r0, [r3], #-110	; 0xffffff92
    1074:	74616372 	strbtvc	r6, [r1], #-882	; 0xfffffc8e
    1078:	355a5f00 	ldrbcc	r5, [sl, #-3840]	; 0xfffff100
    107c:	72657a62 	rsbvc	r7, r5, #401408	; 0x62000
    1080:	6976506f 	ldmdbvs	r6!, {r0, r1, r2, r3, r5, r6, ip, lr}^
    1084:	72747300 	rsbsvc	r7, r4, #0, 6
    1088:	7970636e 	ldmdbvc	r0!, {r1, r2, r3, r5, r6, r8, r9, sp, lr}^
    108c:	365a5f00 	ldrbcc	r5, [sl], -r0, lsl #30
    1090:	63727473 	cmnvs	r2, #1929379840	; 0x73000000
    1094:	63507461 	cmpvs	r0, #1627389952	; 0x61000000
    1098:	00634b50 	rsbeq	r4, r3, r0, asr fp
    109c:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; fe8 <shift+0xfe8>
    10a0:	72742f65 	rsbsvc	r2, r4, #404	; 0x194
    10a4:	6c696665 	stclvs	6, cr6, [r9], #-404	; 0xfffffe6c
    10a8:	6d65732f 	stclvs	3, cr7, [r5, #-188]!	; 0xffffff44
    10ac:	756f732f 	strbvc	r7, [pc, #-815]!	; d85 <shift+0xd85>
    10b0:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
    10b4:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
    10b8:	2f62696c 	svccs	0x0062696c
    10bc:	2f637273 	svccs	0x00637273
    10c0:	73647473 	cmnvc	r4, #1929379840	; 0x73000000
    10c4:	6e697274 	mcrvs	2, 3, r7, cr9, cr4, {3}
    10c8:	70632e67 	rsbvc	r2, r3, r7, ror #28
    10cc:	74730070 	ldrbtvc	r0, [r3], #-112	; 0xffffff90
    10d0:	61636e72 	smcvs	14050	; 0x36e2
    10d4:	61770074 	cmnvs	r7, r4, ror r0
    10d8:	72656b6c 	rsbvc	r6, r5, #108, 22	; 0x1b000
    10dc:	63616600 	cmnvs	r1, #0, 12
    10e0:	00726f74 	rsbseq	r6, r2, r4, ror pc
    10e4:	616f7469 	cmnvs	pc, r9, ror #8
    10e8:	736f7000 	cmnvc	pc, #0
    10ec:	6f697469 	svcvs	0x00697469
    10f0:	656d006e 	strbvs	r0, [sp, #-110]!	; 0xffffff92
    10f4:	7473646d 	ldrbtvc	r6, [r3], #-1133	; 0xfffffb93
    10f8:	61684300 	cmnvs	r8, r0, lsl #6
    10fc:	6e6f4372 	mcrvs	3, 3, r4, cr15, cr2, {3}
    1100:	72724176 	rsbsvc	r4, r2, #-2147483619	; 0x8000001d
    1104:	6f746600 	svcvs	0x00746600
    1108:	756e0061 	strbvc	r0, [lr, #-97]!	; 0xffffff9f
    110c:	7265626d 	rsbvc	r6, r5, #-805306362	; 0xd0000006
    1110:	6d656d00 	stclvs	13, cr6, [r5, #-0]
    1114:	00637273 	rsbeq	r7, r3, r3, ror r2
    1118:	626d756e 	rsbvs	r7, sp, #461373440	; 0x1b800000
    111c:	00327265 	eorseq	r7, r2, r5, ror #4
    1120:	65746661 	ldrbvs	r6, [r4, #-1633]!	; 0xfffff99f
    1124:	63654472 	cmnvs	r5, #1912602624	; 0x72000000
    1128:	6e696f50 	mcrvs	15, 3, r6, cr9, cr0, {2}
    112c:	7a620074 	bvc	1881304 <__bss_end+0x187766c>
    1130:	006f7265 	rsbeq	r7, pc, r5, ror #4
    1134:	636d656d 	cmnvs	sp, #457179136	; 0x1b400000
    1138:	73007970 	movwvc	r7, #2416	; 0x970
    113c:	636e7274 	cmnvs	lr, #116, 4	; 0x40000007
    1140:	7400706d 	strvc	r7, [r0], #-109	; 0xffffff93
    1144:	6c696172 	stfvse	f6, [r9], #-456	; 0xfffffe38
    1148:	5f676e69 	svcpl	0x00676e69
    114c:	00746f64 	rsbseq	r6, r4, r4, ror #30
    1150:	7074756f 	rsbsvc	r7, r4, pc, ror #10
    1154:	6c007475 	cfstrsvs	mvf7, [r0], {117}	; 0x75
    1158:	74676e65 	strbtvc	r6, [r7], #-3685	; 0xfffff19b
    115c:	6e003268 	cdpvs	2, 0, cr3, cr0, cr8, {3}
    1160:	0075745f 	rsbseq	r7, r5, pc, asr r4
    1164:	73365a5f 	teqvc	r6, #389120	; 0x5f000
    1168:	656c7274 	strbvs	r7, [ip, #-628]!	; 0xfffffd8c
    116c:	634b506e 	movtvs	r5, #45166	; 0xb06e
    1170:	375a5f00 	ldrbcc	r5, [sl, -r0, lsl #30]
    1174:	6e727473 	mrcvs	4, 3, r7, cr2, cr3, {3}
    1178:	50706d63 	rsbspl	r6, r0, r3, ror #26
    117c:	3053634b 	subscc	r6, r3, fp, asr #6
    1180:	5f00695f 	svcpl	0x0000695f
    1184:	7461345a 	strbtvc	r3, [r1], #-1114	; 0xfffffba6
    1188:	4b50696f 	blmi	141b74c <__bss_end+0x1411ab4>
    118c:	5a5f0063 	bpl	17c1320 <__bss_end+0x17b7688>
    1190:	6f746934 	svcvs	0x00746934
    1194:	63506961 	cmpvs	r0, #1589248	; 0x184000
    1198:	5a5f006a 	bpl	17c1348 <__bss_end+0x17b76b0>
    119c:	6f746634 	svcvs	0x00746634
    11a0:	63506661 	cmpvs	r0, #101711872	; 0x6100000
    11a4:	6d656d00 	stclvs	13, cr6, [r5, #-0]
    11a8:	0079726f 	rsbseq	r7, r9, pc, ror #4
    11ac:	676e656c 	strbvs	r6, [lr, -ip, ror #10]!
    11b0:	73006874 	movwvc	r6, #2164	; 0x874
    11b4:	656c7274 	strbvs	r7, [ip, #-628]!	; 0xfffffd8c
    11b8:	5a5f006e 	bpl	17c1378 <__bss_end+0x17b76e0>
    11bc:	72747337 	rsbsvc	r7, r4, #-603979776	; 0xdc000000
    11c0:	7461636e 	strbtvc	r6, [r1], #-878	; 0xfffffc92
    11c4:	4b506350 	blmi	1419f0c <__bss_end+0x1410274>
    11c8:	2e006963 	vmlscs.f16	s12, s0, s7	; <UNPREDICTABLE>
    11cc:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    11d0:	2f2e2e2f 	svccs	0x002e2e2f
    11d4:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    11d8:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    11dc:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
    11e0:	2f636367 	svccs	0x00636367
    11e4:	666e6f63 	strbtvs	r6, [lr], -r3, ror #30
    11e8:	612f6769 			; <UNDEFINED> instruction: 0x612f6769
    11ec:	6c2f6d72 	stcvs	13, cr6, [pc], #-456	; 102c <shift+0x102c>
    11f0:	66316269 	ldrtvs	r6, [r1], -r9, ror #4
    11f4:	73636e75 	cmnvc	r3, #1872	; 0x750
    11f8:	2f00532e 	svccs	0x0000532e
    11fc:	6c697562 	cfstr64vs	mvdx7, [r9], #-392	; 0xfffffe78
    1200:	63672f64 	cmnvs	r7, #100, 30	; 0x190
    1204:	72612d63 	rsbvc	r2, r1, #6336	; 0x18c0
    1208:	6f6e2d6d 	svcvs	0x006e2d6d
    120c:	652d656e 	strvs	r6, [sp, #-1390]!	; 0xfffffa92
    1210:	2d696261 	sfmcs	f6, 2, [r9, #-388]!	; 0xfffffe7c
    1214:	67665968 	strbvs	r5, [r6, -r8, ror #18]!
    1218:	672f344b 	strvs	r3, [pc, -fp, asr #8]!
    121c:	612d6363 			; <UNDEFINED> instruction: 0x612d6363
    1220:	6e2d6d72 	mcrvs	13, 1, r6, cr13, cr2, {3}
    1224:	2d656e6f 	stclcs	14, cr6, [r5, #-444]!	; 0xfffffe44
    1228:	69626165 	stmdbvs	r2!, {r0, r2, r5, r6, r8, sp, lr}^
    122c:	2e30312d 	rsfcssp	f3, f0, #5.0
    1230:	30322d33 	eorscc	r2, r2, r3, lsr sp
    1234:	302e3132 	eorcc	r3, lr, r2, lsr r1
    1238:	75622f37 	strbvc	r2, [r2, #-3895]!	; 0xfffff0c9
    123c:	2f646c69 	svccs	0x00646c69
    1240:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
    1244:	656e6f6e 	strbvs	r6, [lr, #-3950]!	; 0xfffff092
    1248:	6261652d 	rsbvs	r6, r1, #188743680	; 0xb400000
    124c:	72612f69 	rsbvc	r2, r1, #420	; 0x1a4
    1250:	35762f6d 	ldrbcc	r2, [r6, #-3949]!	; 0xfffff093
    1254:	682f6574 	stmdavs	pc!, {r2, r4, r5, r6, r8, sl, sp, lr}	; <UNPREDICTABLE>
    1258:	2f647261 	svccs	0x00647261
    125c:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    1260:	47006363 	strmi	r6, [r0, -r3, ror #6]
    1264:	4120554e 			; <UNDEFINED> instruction: 0x4120554e
    1268:	2e322053 	mrccs	0, 1, r2, cr2, cr3, {2}
    126c:	2e003733 	mcrcs	7, 0, r3, cr0, cr3, {1}
    1270:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1274:	2f2e2e2f 	svccs	0x002e2e2f
    1278:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    127c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1280:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
    1284:	2f636367 	svccs	0x00636367
    1288:	666e6f63 	strbtvs	r6, [lr], -r3, ror #30
    128c:	612f6769 			; <UNDEFINED> instruction: 0x612f6769
    1290:	692f6d72 	stmdbvs	pc!, {r1, r4, r5, r6, r8, sl, fp, sp, lr}	; <UNPREDICTABLE>
    1294:	37656565 	strbcc	r6, [r5, -r5, ror #10]!
    1298:	732d3435 			; <UNDEFINED> instruction: 0x732d3435
    129c:	00532e66 	subseq	r2, r3, r6, ror #28
    12a0:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    12a4:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    12a8:	2f2e2e2f 	svccs	0x002e2e2f
    12ac:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    12b0:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
    12b4:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    12b8:	6e6f632f 	cdpvs	3, 6, cr6, cr15, cr15, {1}
    12bc:	2f676966 	svccs	0x00676966
    12c0:	2f6d7261 	svccs	0x006d7261
    12c4:	62617062 	rsbvs	r7, r1, #98	; 0x62
    12c8:	00532e69 	subseq	r2, r3, r9, ror #28
    12cc:	5f617369 	svcpl	0x00617369
    12d0:	5f746962 	svcpl	0x00746962
    12d4:	64657270 	strbtvs	r7, [r5], #-624	; 0xfffffd90
    12d8:	00736572 	rsbseq	r6, r3, r2, ror r5
    12dc:	5f617369 	svcpl	0x00617369
    12e0:	5f746962 	svcpl	0x00746962
    12e4:	5f706676 	svcpl	0x00706676
    12e8:	65736162 	ldrbvs	r6, [r3, #-354]!	; 0xfffffe9e
    12ec:	6d6f6300 	stclvs	3, cr6, [pc, #-0]	; 12f4 <shift+0x12f4>
    12f0:	78656c70 	stmdavc	r5!, {r4, r5, r6, sl, fp, sp, lr}^
    12f4:	6f6c6620 	svcvs	0x006c6620
    12f8:	69007461 	stmdbvs	r0, {r0, r5, r6, sl, ip, sp, lr}
    12fc:	6e5f6173 	mrcvs	1, 2, r6, cr15, cr3, {3}
    1300:	7469626f 	strbtvc	r6, [r9], #-623	; 0xfffffd91
    1304:	61736900 	cmnvs	r3, r0, lsl #18
    1308:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    130c:	65766d5f 	ldrbvs	r6, [r6, #-3423]!	; 0xfffff2a1
    1310:	6f6c665f 	svcvs	0x006c665f
    1314:	69007461 	stmdbvs	r0, {r0, r5, r6, sl, ip, sp, lr}
    1318:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    131c:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
    1320:	00363170 	eorseq	r3, r6, r0, ror r1
    1324:	5f617369 	svcpl	0x00617369
    1328:	5f746962 	svcpl	0x00746962
    132c:	00636573 	rsbeq	r6, r3, r3, ror r5
    1330:	5f617369 	svcpl	0x00617369
    1334:	5f746962 	svcpl	0x00746962
    1338:	76696461 	strbtvc	r6, [r9], -r1, ror #8
    133c:	61736900 	cmnvs	r3, r0, lsl #18
    1340:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1344:	6975715f 	ldmdbvs	r5!, {r0, r1, r2, r3, r4, r6, r8, ip, sp, lr}^
    1348:	6e5f6b72 	vmovvs.s8	r6, d15[3]
    134c:	6f765f6f 	svcvs	0x00765f6f
    1350:	6974616c 	ldmdbvs	r4!, {r2, r3, r5, r6, r8, sp, lr}^
    1354:	635f656c 	cmpvs	pc, #108, 10	; 0x1b000000
    1358:	73690065 	cmnvc	r9, #101	; 0x65
    135c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1360:	706d5f74 	rsbvc	r5, sp, r4, ror pc
    1364:	61736900 	cmnvs	r3, r0, lsl #18
    1368:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    136c:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1370:	00743576 	rsbseq	r3, r4, r6, ror r5
    1374:	5f617369 	svcpl	0x00617369
    1378:	5f746962 	svcpl	0x00746962
    137c:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    1380:	00657435 	rsbeq	r7, r5, r5, lsr r4
    1384:	5f617369 	svcpl	0x00617369
    1388:	5f746962 	svcpl	0x00746962
    138c:	6e6f656e 	cdpvs	5, 6, cr6, cr15, cr14, {3}
    1390:	61736900 	cmnvs	r3, r0, lsl #18
    1394:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1398:	3166625f 	cmncc	r6, pc, asr r2
    139c:	50460036 	subpl	r0, r6, r6, lsr r0
    13a0:	5f524353 	svcpl	0x00524353
    13a4:	4d554e45 	ldclmi	14, cr4, [r5, #-276]	; 0xfffffeec
    13a8:	53504600 	cmppl	r0, #0, 12
    13ac:	6e5f5243 	cdpvs	2, 5, cr5, cr15, cr3, {2}
    13b0:	7176637a 	cmnvc	r6, sl, ror r3
    13b4:	4e455f63 	cdpmi	15, 4, cr5, cr5, cr3, {3}
    13b8:	56004d55 			; <UNDEFINED> instruction: 0x56004d55
    13bc:	455f5250 	ldrbmi	r5, [pc, #-592]	; 1174 <shift+0x1174>
    13c0:	004d554e 	subeq	r5, sp, lr, asr #10
    13c4:	74696266 	strbtvc	r6, [r9], #-614	; 0xfffffd9a
    13c8:	706d695f 	rsbvc	r6, sp, pc, asr r9
    13cc:	6163696c 	cmnvs	r3, ip, ror #18
    13d0:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
    13d4:	5f305000 	svcpl	0x00305000
    13d8:	4d554e45 	ldclmi	14, cr4, [r5, #-276]	; 0xfffffeec
    13dc:	61736900 	cmnvs	r3, r0, lsl #18
    13e0:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    13e4:	7972635f 	ldmdbvc	r2!, {r0, r1, r2, r3, r4, r6, r8, r9, sp, lr}^
    13e8:	006f7470 	rsbeq	r7, pc, r0, ror r4	; <UNPREDICTABLE>
    13ec:	20554e47 	subscs	r4, r5, r7, asr #28
    13f0:	20373143 	eorscs	r3, r7, r3, asr #2
    13f4:	332e3031 			; <UNDEFINED> instruction: 0x332e3031
    13f8:	3220312e 	eorcc	r3, r0, #-2147483637	; 0x8000000b
    13fc:	30313230 	eorscc	r3, r1, r0, lsr r2
    1400:	20313236 	eorscs	r3, r1, r6, lsr r2
    1404:	6c657228 	sfmvs	f7, 2, [r5], #-160	; 0xffffff60
    1408:	65736165 	ldrbvs	r6, [r3, #-357]!	; 0xfffffe9b
    140c:	6d2d2029 	stcvs	0, cr2, [sp, #-164]!	; 0xffffff5c
    1410:	206d7261 	rsbcs	r7, sp, r1, ror #4
    1414:	6c666d2d 	stclvs	13, cr6, [r6], #-180	; 0xffffff4c
    1418:	2d74616f 	ldfcse	f6, [r4, #-444]!	; 0xfffffe44
    141c:	3d696261 	sfmcc	f6, 2, [r9, #-388]!	; 0xfffffe7c
    1420:	64726168 	ldrbtvs	r6, [r2], #-360	; 0xfffffe98
    1424:	616d2d20 	cmnvs	sp, r0, lsr #26
    1428:	3d686372 	stclcc	3, cr6, [r8, #-456]!	; 0xfffffe38
    142c:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    1430:	2b657435 	blcs	195e50c <__bss_end+0x1954874>
    1434:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
    1438:	672d2067 	strvs	r2, [sp, -r7, rrx]!
    143c:	20672d20 	rsbcs	r2, r7, r0, lsr #26
    1440:	20324f2d 	eorscs	r4, r2, sp, lsr #30
    1444:	20324f2d 	eorscs	r4, r2, sp, lsr #30
    1448:	20324f2d 	eorscs	r4, r2, sp, lsr #30
    144c:	7562662d 	strbvc	r6, [r2, #-1581]!	; 0xfffff9d3
    1450:	69646c69 	stmdbvs	r4!, {r0, r3, r5, r6, sl, fp, sp, lr}^
    1454:	6c2d676e 	stcvs	7, cr6, [sp], #-440	; 0xfffffe48
    1458:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    145c:	662d2063 	strtvs	r2, [sp], -r3, rrx
    1460:	732d6f6e 			; <UNDEFINED> instruction: 0x732d6f6e
    1464:	6b636174 	blvs	18d9a3c <__bss_end+0x18cfda4>
    1468:	6f72702d 	svcvs	0x0072702d
    146c:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
    1470:	2d20726f 	sfmcs	f7, 4, [r0, #-444]!	; 0xfffffe44
    1474:	2d6f6e66 	stclcs	14, cr6, [pc, #-408]!	; 12e4 <shift+0x12e4>
    1478:	696c6e69 	stmdbvs	ip!, {r0, r3, r5, r6, r9, sl, fp, sp, lr}^
    147c:	2d20656e 	cfstr32cs	mvfx6, [r0, #-440]!	; 0xfffffe48
    1480:	73697666 	cmnvc	r9, #106954752	; 0x6600000
    1484:	6c696269 	sfmvs	f6, 2, [r9], #-420	; 0xfffffe5c
    1488:	3d797469 	cfldrdcc	mvd7, [r9, #-420]!	; 0xfffffe5c
    148c:	64646968 	strbtvs	r6, [r4], #-2408	; 0xfffff698
    1490:	69006e65 	stmdbvs	r0, {r0, r2, r5, r6, r9, sl, fp, sp, lr}
    1494:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1498:	745f7469 	ldrbvc	r7, [pc], #-1129	; 14a0 <shift+0x14a0>
    149c:	00766964 	rsbseq	r6, r6, r4, ror #18
    14a0:	736e6f63 	cmnvc	lr, #396	; 0x18c
    14a4:	61736900 	cmnvs	r3, r0, lsl #18
    14a8:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    14ac:	6d77695f 			; <UNDEFINED> instruction: 0x6d77695f
    14b0:	0074786d 	rsbseq	r7, r4, sp, ror #16
    14b4:	58435046 	stmdapl	r3, {r1, r2, r6, ip, lr}^
    14b8:	455f5354 	ldrbmi	r5, [pc, #-852]	; 116c <shift+0x116c>
    14bc:	004d554e 	subeq	r5, sp, lr, asr #10
    14c0:	5f617369 	svcpl	0x00617369
    14c4:	5f746962 	svcpl	0x00746962
    14c8:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    14cc:	73690036 	cmnvc	r9, #54	; 0x36
    14d0:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    14d4:	766d5f74 	uqsub16vc	r5, sp, r4
    14d8:	73690065 	cmnvc	r9, #101	; 0x65
    14dc:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    14e0:	77695f74 			; <UNDEFINED> instruction: 0x77695f74
    14e4:	74786d6d 	ldrbtvc	r6, [r8], #-3437	; 0xfffff293
    14e8:	73690032 	cmnvc	r9, #50	; 0x32
    14ec:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    14f0:	64635f74 	strbtvs	r5, [r3], #-3956	; 0xfffff08c
    14f4:	30706365 	rsbscc	r6, r0, r5, ror #6
    14f8:	61736900 	cmnvs	r3, r0, lsl #18
    14fc:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1500:	6564635f 	strbvs	r6, [r4, #-863]!	; 0xfffffca1
    1504:	00317063 	eorseq	r7, r1, r3, rrx
    1508:	5f617369 	svcpl	0x00617369
    150c:	5f746962 	svcpl	0x00746962
    1510:	63656463 	cmnvs	r5, #1660944384	; 0x63000000
    1514:	69003270 	stmdbvs	r0, {r4, r5, r6, r9, ip, sp}
    1518:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    151c:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
    1520:	70636564 	rsbvc	r6, r3, r4, ror #10
    1524:	73690033 	cmnvc	r9, #51	; 0x33
    1528:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    152c:	64635f74 	strbtvs	r5, [r3], #-3956	; 0xfffff08c
    1530:	34706365 	ldrbtcc	r6, [r0], #-869	; 0xfffffc9b
    1534:	61736900 	cmnvs	r3, r0, lsl #18
    1538:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    153c:	5f70665f 	svcpl	0x0070665f
    1540:	006c6264 	rsbeq	r6, ip, r4, ror #4
    1544:	5f617369 	svcpl	0x00617369
    1548:	5f746962 	svcpl	0x00746962
    154c:	63656463 	cmnvs	r5, #1660944384	; 0x63000000
    1550:	69003670 	stmdbvs	r0, {r4, r5, r6, r9, sl, ip, sp}
    1554:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1558:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
    155c:	70636564 	rsbvc	r6, r3, r4, ror #10
    1560:	73690037 	cmnvc	r9, #55	; 0x37
    1564:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1568:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    156c:	6b36766d 	blvs	d9ef28 <__bss_end+0xd95290>
    1570:	61736900 	cmnvs	r3, r0, lsl #18
    1574:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1578:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    157c:	315f3876 	cmpcc	pc, r6, ror r8	; <UNPREDICTABLE>
    1580:	616d5f6d 	cmnvs	sp, sp, ror #30
    1584:	61006e69 	tstvs	r0, r9, ror #28
    1588:	0065746e 	rsbeq	r7, r5, lr, ror #8
    158c:	5f617369 	svcpl	0x00617369
    1590:	5f746962 	svcpl	0x00746962
    1594:	65736d63 	ldrbvs	r6, [r3, #-3427]!	; 0xfffff29d
    1598:	6e6f6c00 	cdpvs	12, 6, cr6, cr15, cr0, {0}
    159c:	6f642067 	svcvs	0x00642067
    15a0:	656c6275 	strbvs	r6, [ip, #-629]!	; 0xfffffd8b
    15a4:	2f2e2e00 	svccs	0x002e2e00
    15a8:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    15ac:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    15b0:	2f2e2e2f 	svccs	0x002e2e2f
    15b4:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; 1504 <shift+0x1504>
    15b8:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    15bc:	696c2f63 	stmdbvs	ip!, {r0, r1, r5, r6, r8, r9, sl, fp, sp}^
    15c0:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    15c4:	00632e32 	rsbeq	r2, r3, r2, lsr lr
    15c8:	5f617369 	svcpl	0x00617369
    15cc:	5f746962 	svcpl	0x00746962
    15d0:	35767066 	ldrbcc	r7, [r6, #-102]!	; 0xffffff9a
    15d4:	61736900 	cmnvs	r3, r0, lsl #18
    15d8:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    15dc:	6373785f 	cmnvs	r3, #6225920	; 0x5f0000
    15e0:	00656c61 	rsbeq	r6, r5, r1, ror #24
    15e4:	676e6f6c 	strbvs	r6, [lr, -ip, ror #30]!
    15e8:	6e6f6c20 	cdpvs	12, 6, cr6, cr15, cr0, {1}
    15ec:	6e752067 	cdpvs	0, 7, cr2, cr5, cr7, {3}
    15f0:	6e676973 			; <UNDEFINED> instruction: 0x6e676973
    15f4:	69206465 	stmdbvs	r0!, {r0, r2, r5, r6, sl, sp, lr}
    15f8:	6900746e 	stmdbvs	r0, {r1, r2, r3, r5, r6, sl, ip, sp, lr}
    15fc:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1600:	715f7469 	cmpvc	pc, r9, ror #8
    1604:	6b726975 	blvs	1c9bbe0 <__bss_end+0x1c91f48>
    1608:	336d635f 	cmncc	sp, #2080374785	; 0x7c000001
    160c:	72646c5f 	rsbvc	r6, r4, #24320	; 0x5f00
    1610:	73690064 	cmnvc	r9, #100	; 0x64
    1614:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1618:	38695f74 	stmdacc	r9!, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    161c:	69006d6d 	stmdbvs	r0, {r0, r2, r3, r5, r6, r8, sl, fp, sp, lr}
    1620:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1624:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
    1628:	33645f70 	cmncc	r4, #112, 30	; 0x1c0
    162c:	73690032 	cmnvc	r9, #50	; 0x32
    1630:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1634:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    1638:	6537766d 	ldrvs	r7, [r7, #-1645]!	; 0xfffff993
    163c:	7369006d 	cmnvc	r9, #109	; 0x6d
    1640:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1644:	706c5f74 	rsbvc	r5, ip, r4, ror pc
    1648:	61006561 	tstvs	r0, r1, ror #10
    164c:	695f6c6c 	ldmdbvs	pc, {r2, r3, r5, r6, sl, fp, sp, lr}^	; <UNPREDICTABLE>
    1650:	696c706d 	stmdbvs	ip!, {r0, r2, r3, r5, r6, ip, sp, lr}^
    1654:	665f6465 	ldrbvs	r6, [pc], -r5, ror #8
    1658:	73746962 	cmnvc	r4, #1605632	; 0x188000
    165c:	61736900 	cmnvs	r3, r0, lsl #18
    1660:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1664:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1668:	315f3876 	cmpcc	pc, r6, ror r8	; <UNPREDICTABLE>
    166c:	61736900 	cmnvs	r3, r0, lsl #18
    1670:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1674:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1678:	325f3876 	subscc	r3, pc, #7733248	; 0x760000
    167c:	61736900 	cmnvs	r3, r0, lsl #18
    1680:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1684:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1688:	335f3876 	cmpcc	pc, #7733248	; 0x760000
    168c:	61736900 	cmnvs	r3, r0, lsl #18
    1690:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1694:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1698:	345f3876 	ldrbcc	r3, [pc], #-2166	; 16a0 <shift+0x16a0>
    169c:	61736900 	cmnvs	r3, r0, lsl #18
    16a0:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    16a4:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    16a8:	355f3876 	ldrbcc	r3, [pc, #-2166]	; e3a <shift+0xe3a>
    16ac:	61736900 	cmnvs	r3, r0, lsl #18
    16b0:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    16b4:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    16b8:	365f3876 			; <UNDEFINED> instruction: 0x365f3876
    16bc:	61736900 	cmnvs	r3, r0, lsl #18
    16c0:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    16c4:	0062735f 	rsbeq	r7, r2, pc, asr r3
    16c8:	5f617369 	svcpl	0x00617369
    16cc:	5f6d756e 	svcpl	0x006d756e
    16d0:	73746962 	cmnvc	r4, #1605632	; 0x188000
    16d4:	61736900 	cmnvs	r3, r0, lsl #18
    16d8:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    16dc:	616d735f 	cmnvs	sp, pc, asr r3
    16e0:	756d6c6c 	strbvc	r6, [sp, #-3180]!	; 0xfffff394
    16e4:	7566006c 	strbvc	r0, [r6, #-108]!	; 0xffffff94
    16e8:	705f636e 	subsvc	r6, pc, lr, ror #6
    16ec:	63007274 	movwvs	r7, #628	; 0x274
    16f0:	6c706d6f 	ldclvs	13, cr6, [r0], #-444	; 0xfffffe44
    16f4:	64207865 	strtvs	r7, [r0], #-2149	; 0xfffff79b
    16f8:	6c62756f 	cfstr64vs	mvdx7, [r2], #-444	; 0xfffffe44
    16fc:	424e0065 	submi	r0, lr, #101	; 0x65
    1700:	5f50465f 	svcpl	0x0050465f
    1704:	52535953 	subspl	r5, r3, #1359872	; 0x14c000
    1708:	00534745 	subseq	r4, r3, r5, asr #14
    170c:	5f617369 	svcpl	0x00617369
    1710:	5f746962 	svcpl	0x00746962
    1714:	63656463 	cmnvs	r5, #1660944384	; 0x63000000
    1718:	69003570 	stmdbvs	r0, {r4, r5, r6, r8, sl, ip, sp}
    171c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1720:	765f7469 	ldrbvc	r7, [pc], -r9, ror #8
    1724:	32767066 	rsbscc	r7, r6, #102	; 0x66
    1728:	61736900 	cmnvs	r3, r0, lsl #18
    172c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1730:	7066765f 	rsbvc	r7, r6, pc, asr r6
    1734:	69003376 	stmdbvs	r0, {r1, r2, r4, r5, r6, r8, r9, ip, sp}
    1738:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    173c:	765f7469 	ldrbvc	r7, [pc], -r9, ror #8
    1740:	34767066 	ldrbtcc	r7, [r6], #-102	; 0xffffff9a
    1744:	43504600 	cmpmi	r0, #0, 12
    1748:	534e5458 	movtpl	r5, #58456	; 0xe458
    174c:	554e455f 	strbpl	r4, [lr, #-1375]	; 0xfffffaa1
    1750:	7369004d 	cmnvc	r9, #77	; 0x4d
    1754:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1758:	68745f74 	ldmdavs	r4!, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    175c:	00626d75 	rsbeq	r6, r2, r5, ror sp
    1760:	5f617369 	svcpl	0x00617369
    1764:	5f746962 	svcpl	0x00746962
    1768:	36317066 	ldrtcc	r7, [r1], -r6, rrx
    176c:	766e6f63 	strbtvc	r6, [lr], -r3, ror #30
    1770:	61736900 	cmnvs	r3, r0, lsl #18
    1774:	6165665f 	cmnvs	r5, pc, asr r6
    1778:	65727574 	ldrbvs	r7, [r2, #-1396]!	; 0xfffffa8c
    177c:	61736900 	cmnvs	r3, r0, lsl #18
    1780:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1784:	746f6e5f 	strbtvc	r6, [pc], #-3679	; 178c <shift+0x178c>
    1788:	7369006d 	cmnvc	r9, #109	; 0x6d
    178c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1790:	75715f74 	ldrbvc	r5, [r1, #-3956]!	; 0xfffff08c
    1794:	5f6b7269 	svcpl	0x006b7269
    1798:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    179c:	007a6b36 	rsbseq	r6, sl, r6, lsr fp
    17a0:	5f617369 	svcpl	0x00617369
    17a4:	5f746962 	svcpl	0x00746962
    17a8:	33637263 	cmncc	r3, #805306374	; 0x30000006
    17ac:	73690032 	cmnvc	r9, #50	; 0x32
    17b0:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    17b4:	75715f74 	ldrbvc	r5, [r1, #-3956]!	; 0xfffff08c
    17b8:	5f6b7269 	svcpl	0x006b7269
    17bc:	615f6f6e 	cmpvs	pc, lr, ror #30
    17c0:	70636d73 	rsbvc	r6, r3, r3, ror sp
    17c4:	73690075 	cmnvc	r9, #117	; 0x75
    17c8:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    17cc:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    17d0:	0034766d 	eorseq	r7, r4, sp, ror #12
    17d4:	5f617369 	svcpl	0x00617369
    17d8:	5f746962 	svcpl	0x00746962
    17dc:	6d756874 	ldclvs	8, cr6, [r5, #-464]!	; 0xfffffe30
    17e0:	69003262 	stmdbvs	r0, {r1, r5, r6, r9, ip, sp}
    17e4:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    17e8:	625f7469 	subsvs	r7, pc, #1761607680	; 0x69000000
    17ec:	69003865 	stmdbvs	r0, {r0, r2, r5, r6, fp, ip, sp}
    17f0:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    17f4:	615f7469 	cmpvs	pc, r9, ror #8
    17f8:	37766d72 			; <UNDEFINED> instruction: 0x37766d72
    17fc:	61736900 	cmnvs	r3, r0, lsl #18
    1800:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1804:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1808:	76003876 			; <UNDEFINED> instruction: 0x76003876
    180c:	735f7066 	cmpvc	pc, #102	; 0x66
    1810:	65727379 	ldrbvs	r7, [r2, #-889]!	; 0xfffffc87
    1814:	655f7367 	ldrbvs	r7, [pc, #-871]	; 14b5 <shift+0x14b5>
    1818:	646f636e 	strbtvs	r6, [pc], #-878	; 1820 <shift+0x1820>
    181c:	00676e69 	rsbeq	r6, r7, r9, ror #28
    1820:	5f617369 	svcpl	0x00617369
    1824:	5f746962 	svcpl	0x00746962
    1828:	36317066 	ldrtcc	r7, [r1], -r6, rrx
    182c:	006c6d66 	rsbeq	r6, ip, r6, ror #26
    1830:	5f617369 	svcpl	0x00617369
    1834:	5f746962 	svcpl	0x00746962
    1838:	70746f64 	rsbsvc	r6, r4, r4, ror #30
    183c:	00646f72 	rsbeq	r6, r4, r2, ror pc
    1840:	69665f5f 	stmdbvs	r6!, {r0, r1, r2, r3, r4, r6, r8, r9, sl, fp, ip, lr}^
    1844:	736e7578 	cmnvc	lr, #120, 10	; 0x1e000000
    1848:	69646673 	stmdbvs	r4!, {r0, r1, r4, r5, r6, r9, sl, sp, lr}^
    184c:	74465300 	strbvc	r5, [r6], #-768	; 0xfffffd00
    1850:	00657079 	rsbeq	r7, r5, r9, ror r0
    1854:	65615f5f 	strbvs	r5, [r1, #-3935]!	; 0xfffff0a1
    1858:	5f696261 	svcpl	0x00696261
    185c:	6c753266 	lfmvs	f3, 2, [r5], #-408	; 0xfffffe68
    1860:	5f5f007a 	svcpl	0x005f007a
    1864:	73786966 	cmnvc	r8, #1671168	; 0x198000
    1868:	00696466 	rsbeq	r6, r9, r6, ror #8
    186c:	79744644 	ldmdbvc	r4!, {r2, r6, r9, sl, lr}^
    1870:	55006570 	strpl	r6, [r0, #-1392]	; 0xfffffa90
    1874:	79744953 	ldmdbvc	r4!, {r0, r1, r4, r6, r8, fp, lr}^
    1878:	55006570 	strpl	r6, [r0, #-1392]	; 0xfffffa90
    187c:	79744944 	ldmdbvc	r4!, {r2, r6, r8, fp, lr}^
    1880:	47006570 	smlsdxmi	r0, r0, r5, r6
    1884:	4320554e 			; <UNDEFINED> instruction: 0x4320554e
    1888:	31203731 			; <UNDEFINED> instruction: 0x31203731
    188c:	2e332e30 	mrccs	14, 1, r2, cr3, cr0, {1}
    1890:	30322031 	eorscc	r2, r2, r1, lsr r0
    1894:	36303132 			; <UNDEFINED> instruction: 0x36303132
    1898:	28203132 	stmdacs	r0!, {r1, r4, r5, r8, ip, sp}
    189c:	656c6572 	strbvs	r6, [ip, #-1394]!	; 0xfffffa8e
    18a0:	29657361 	stmdbcs	r5!, {r0, r5, r6, r8, r9, ip, sp, lr}^
    18a4:	616d2d20 	cmnvs	sp, r0, lsr #26
    18a8:	2d206d72 	stccs	13, cr6, [r0, #-456]!	; 0xfffffe38
    18ac:	6f6c666d 	svcvs	0x006c666d
    18b0:	612d7461 			; <UNDEFINED> instruction: 0x612d7461
    18b4:	683d6962 	ldmdavs	sp!, {r1, r5, r6, r8, fp, sp, lr}
    18b8:	20647261 	rsbcs	r7, r4, r1, ror #4
    18bc:	72616d2d 	rsbvc	r6, r1, #2880	; 0xb40
    18c0:	613d6863 	teqvs	sp, r3, ror #16
    18c4:	35766d72 	ldrbcc	r6, [r6, #-3442]!	; 0xfffff28e
    18c8:	662b6574 			; <UNDEFINED> instruction: 0x662b6574
    18cc:	672d2070 			; <UNDEFINED> instruction: 0x672d2070
    18d0:	20672d20 	rsbcs	r2, r7, r0, lsr #26
    18d4:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
    18d8:	2d20324f 	sfmcs	f3, 4, [r0, #-316]!	; 0xfffffec4
    18dc:	2d20324f 	sfmcs	f3, 4, [r0, #-316]!	; 0xfffffec4
    18e0:	2d20324f 	sfmcs	f3, 4, [r0, #-316]!	; 0xfffffec4
    18e4:	69756266 	ldmdbvs	r5!, {r1, r2, r5, r6, r9, sp, lr}^
    18e8:	6e69646c 	cdpvs	4, 6, cr6, cr9, cr12, {3}
    18ec:	696c2d67 	stmdbvs	ip!, {r0, r1, r2, r5, r6, r8, sl, fp, sp}^
    18f0:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    18f4:	6e662d20 	cdpvs	13, 6, cr2, cr6, cr0, {1}
    18f8:	74732d6f 	ldrbtvc	r2, [r3], #-3439	; 0xfffff291
    18fc:	2d6b6361 	stclcs	3, cr6, [fp, #-388]!	; 0xfffffe7c
    1900:	746f7270 	strbtvc	r7, [pc], #-624	; 1908 <shift+0x1908>
    1904:	6f746365 	svcvs	0x00746365
    1908:	662d2072 			; <UNDEFINED> instruction: 0x662d2072
    190c:	692d6f6e 	pushvs	{r1, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}
    1910:	6e696c6e 	cdpvs	12, 6, cr6, cr9, cr14, {3}
    1914:	662d2065 	strtvs	r2, [sp], -r5, rrx
    1918:	65637865 	strbvs	r7, [r3, #-2149]!	; 0xfffff79b
    191c:	6f697470 	svcvs	0x00697470
    1920:	2d20736e 	stccs	3, cr7, [r0, #-440]!	; 0xfffffe48
    1924:	73697666 	cmnvc	r9, #106954752	; 0x6600000
    1928:	6c696269 	sfmvs	f6, 2, [r9], #-420	; 0xfffffe5c
    192c:	3d797469 	cfldrdcc	mvd7, [r9, #-420]!	; 0xfffffe5c
    1930:	64646968 	strbtvs	r6, [r4], #-2408	; 0xfffff698
    1934:	5f006e65 	svcpl	0x00006e65
    1938:	6964755f 	stmdbvs	r4!, {r0, r1, r2, r3, r4, r6, r8, sl, ip, sp, lr}^
    193c:	646f6d76 	strbtvs	r6, [pc], #-3446	; 1944 <shift+0x1944>
    1940:	00346964 	eorseq	r6, r4, r4, ror #18

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
  20:	8b040e42 	blhi	103930 <__bss_end+0xf9c98>
  24:	0b0d4201 	bleq	350830 <__bss_end+0x346b98>
  28:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
  2c:	00000ecb 	andeq	r0, r0, fp, asr #29
  30:	0000001c 	andeq	r0, r0, ip, lsl r0
  34:	00000000 	andeq	r0, r0, r0
  38:	00008064 	andeq	r8, r0, r4, rrx
  3c:	00000040 	andeq	r0, r0, r0, asr #32
  40:	8b080e42 	blhi	203950 <__bss_end+0x1f9cb8>
  44:	42018e02 	andmi	r8, r1, #2, 28
  48:	5a040b0c 	bpl	102c80 <__bss_end+0xf8fe8>
  4c:	00080d0c 	andeq	r0, r8, ip, lsl #26
  50:	0000000c 	andeq	r0, r0, ip
  54:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
  58:	7c020001 	stcvc	0, cr0, [r2], {1}
  5c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
  60:	0000001c 	andeq	r0, r0, ip, lsl r0
  64:	00000050 	andeq	r0, r0, r0, asr r0
  68:	000080a4 	andeq	r8, r0, r4, lsr #1
  6c:	00000038 	andeq	r0, r0, r8, lsr r0
  70:	8b040e42 	blhi	103980 <__bss_end+0xf9ce8>
  74:	0b0d4201 	bleq	350880 <__bss_end+0x346be8>
  78:	420d0d54 	andmi	r0, sp, #84, 26	; 0x1500
  7c:	00000ecb 	andeq	r0, r0, fp, asr #29
  80:	0000001c 	andeq	r0, r0, ip, lsl r0
  84:	00000050 	andeq	r0, r0, r0, asr r0
  88:	000080dc 	ldrdeq	r8, [r0], -ip
  8c:	0000002c 	andeq	r0, r0, ip, lsr #32
  90:	8b040e42 	blhi	1039a0 <__bss_end+0xf9d08>
  94:	0b0d4201 	bleq	3508a0 <__bss_end+0x346c08>
  98:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
  9c:	00000ecb 	andeq	r0, r0, fp, asr #29
  a0:	0000001c 	andeq	r0, r0, ip, lsl r0
  a4:	00000050 	andeq	r0, r0, r0, asr r0
  a8:	00008108 	andeq	r8, r0, r8, lsl #2
  ac:	00000020 	andeq	r0, r0, r0, lsr #32
  b0:	8b040e42 	blhi	1039c0 <__bss_end+0xf9d28>
  b4:	0b0d4201 	bleq	3508c0 <__bss_end+0x346c28>
  b8:	420d0d48 	andmi	r0, sp, #72, 26	; 0x1200
  bc:	00000ecb 	andeq	r0, r0, fp, asr #29
  c0:	0000001c 	andeq	r0, r0, ip, lsl r0
  c4:	00000050 	andeq	r0, r0, r0, asr r0
  c8:	00008128 	andeq	r8, r0, r8, lsr #2
  cc:	00000018 	andeq	r0, r0, r8, lsl r0
  d0:	8b040e42 	blhi	1039e0 <__bss_end+0xf9d48>
  d4:	0b0d4201 	bleq	3508e0 <__bss_end+0x346c48>
  d8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  dc:	00000ecb 	andeq	r0, r0, fp, asr #29
  e0:	0000001c 	andeq	r0, r0, ip, lsl r0
  e4:	00000050 	andeq	r0, r0, r0, asr r0
  e8:	00008140 	andeq	r8, r0, r0, asr #2
  ec:	00000018 	andeq	r0, r0, r8, lsl r0
  f0:	8b040e42 	blhi	103a00 <__bss_end+0xf9d68>
  f4:	0b0d4201 	bleq	350900 <__bss_end+0x346c68>
  f8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  fc:	00000ecb 	andeq	r0, r0, fp, asr #29
 100:	0000001c 	andeq	r0, r0, ip, lsl r0
 104:	00000050 	andeq	r0, r0, r0, asr r0
 108:	00008158 	andeq	r8, r0, r8, asr r1
 10c:	00000018 	andeq	r0, r0, r8, lsl r0
 110:	8b040e42 	blhi	103a20 <__bss_end+0xf9d88>
 114:	0b0d4201 	bleq	350920 <__bss_end+0x346c88>
 118:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
 11c:	00000ecb 	andeq	r0, r0, fp, asr #29
 120:	00000014 	andeq	r0, r0, r4, lsl r0
 124:	00000050 	andeq	r0, r0, r0, asr r0
 128:	00008170 	andeq	r8, r0, r0, ror r1
 12c:	0000000c 	andeq	r0, r0, ip
 130:	8b040e42 	blhi	103a40 <__bss_end+0xf9da8>
 134:	0b0d4201 	bleq	350940 <__bss_end+0x346ca8>
 138:	0000001c 	andeq	r0, r0, ip, lsl r0
 13c:	00000050 	andeq	r0, r0, r0, asr r0
 140:	0000817c 	andeq	r8, r0, ip, ror r1
 144:	00000058 	andeq	r0, r0, r8, asr r0
 148:	8b080e42 	blhi	203a58 <__bss_end+0x1f9dc0>
 14c:	42018e02 	andmi	r8, r1, #2, 28
 150:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 154:	00080d0c 	andeq	r0, r8, ip, lsl #26
 158:	0000001c 	andeq	r0, r0, ip, lsl r0
 15c:	00000050 	andeq	r0, r0, r0, asr r0
 160:	000081d4 	ldrdeq	r8, [r0], -r4
 164:	00000058 	andeq	r0, r0, r8, asr r0
 168:	8b080e42 	blhi	203a78 <__bss_end+0x1f9de0>
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
 194:	00000080 	andeq	r0, r0, r0, lsl #1
 198:	8b080e42 	blhi	203aa8 <__bss_end+0x1f9e10>
 19c:	42018e02 	andmi	r8, r1, #2, 28
 1a0:	74040b0c 	strvc	r0, [r4], #-2828	; 0xfffff4f4
 1a4:	00080d0c 	andeq	r0, r8, ip, lsl #26
 1a8:	00000018 	andeq	r0, r0, r8, lsl r0
 1ac:	00000178 	andeq	r0, r0, r8, ror r1
 1b0:	000082ac 	andeq	r8, r0, ip, lsr #5
 1b4:	0000016c 	andeq	r0, r0, ip, ror #2
 1b8:	8b080e42 	blhi	203ac8 <__bss_end+0x1f9e30>
 1bc:	42018e02 	andmi	r8, r1, #2, 28
 1c0:	00040b0c 	andeq	r0, r4, ip, lsl #22
 1c4:	0000000c 	andeq	r0, r0, ip
 1c8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 1cc:	7c020001 	stcvc	0, cr0, [r2], {1}
 1d0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 1d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1d8:	000001c4 	andeq	r0, r0, r4, asr #3
 1dc:	00008418 	andeq	r8, r0, r8, lsl r4
 1e0:	0000002c 	andeq	r0, r0, ip, lsr #32
 1e4:	8b040e42 	blhi	103af4 <__bss_end+0xf9e5c>
 1e8:	0b0d4201 	bleq	3509f4 <__bss_end+0x346d5c>
 1ec:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 1f0:	00000ecb 	andeq	r0, r0, fp, asr #29
 1f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1f8:	000001c4 	andeq	r0, r0, r4, asr #3
 1fc:	00008444 	andeq	r8, r0, r4, asr #8
 200:	0000002c 	andeq	r0, r0, ip, lsr #32
 204:	8b040e42 	blhi	103b14 <__bss_end+0xf9e7c>
 208:	0b0d4201 	bleq	350a14 <__bss_end+0x346d7c>
 20c:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 210:	00000ecb 	andeq	r0, r0, fp, asr #29
 214:	0000001c 	andeq	r0, r0, ip, lsl r0
 218:	000001c4 	andeq	r0, r0, r4, asr #3
 21c:	00008470 	andeq	r8, r0, r0, ror r4
 220:	0000001c 	andeq	r0, r0, ip, lsl r0
 224:	8b040e42 	blhi	103b34 <__bss_end+0xf9e9c>
 228:	0b0d4201 	bleq	350a34 <__bss_end+0x346d9c>
 22c:	420d0d46 	andmi	r0, sp, #4480	; 0x1180
 230:	00000ecb 	andeq	r0, r0, fp, asr #29
 234:	0000001c 	andeq	r0, r0, ip, lsl r0
 238:	000001c4 	andeq	r0, r0, r4, asr #3
 23c:	0000848c 	andeq	r8, r0, ip, lsl #9
 240:	00000044 	andeq	r0, r0, r4, asr #32
 244:	8b040e42 	blhi	103b54 <__bss_end+0xf9ebc>
 248:	0b0d4201 	bleq	350a54 <__bss_end+0x346dbc>
 24c:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 250:	00000ecb 	andeq	r0, r0, fp, asr #29
 254:	0000001c 	andeq	r0, r0, ip, lsl r0
 258:	000001c4 	andeq	r0, r0, r4, asr #3
 25c:	000084d0 	ldrdeq	r8, [r0], -r0
 260:	00000050 	andeq	r0, r0, r0, asr r0
 264:	8b040e42 	blhi	103b74 <__bss_end+0xf9edc>
 268:	0b0d4201 	bleq	350a74 <__bss_end+0x346ddc>
 26c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 270:	00000ecb 	andeq	r0, r0, fp, asr #29
 274:	0000001c 	andeq	r0, r0, ip, lsl r0
 278:	000001c4 	andeq	r0, r0, r4, asr #3
 27c:	00008520 	andeq	r8, r0, r0, lsr #10
 280:	00000050 	andeq	r0, r0, r0, asr r0
 284:	8b040e42 	blhi	103b94 <__bss_end+0xf9efc>
 288:	0b0d4201 	bleq	350a94 <__bss_end+0x346dfc>
 28c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 290:	00000ecb 	andeq	r0, r0, fp, asr #29
 294:	0000001c 	andeq	r0, r0, ip, lsl r0
 298:	000001c4 	andeq	r0, r0, r4, asr #3
 29c:	00008570 	andeq	r8, r0, r0, ror r5
 2a0:	0000002c 	andeq	r0, r0, ip, lsr #32
 2a4:	8b040e42 	blhi	103bb4 <__bss_end+0xf9f1c>
 2a8:	0b0d4201 	bleq	350ab4 <__bss_end+0x346e1c>
 2ac:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 2b0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2b4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2b8:	000001c4 	andeq	r0, r0, r4, asr #3
 2bc:	0000859c 	muleq	r0, ip, r5
 2c0:	00000050 	andeq	r0, r0, r0, asr r0
 2c4:	8b040e42 	blhi	103bd4 <__bss_end+0xf9f3c>
 2c8:	0b0d4201 	bleq	350ad4 <__bss_end+0x346e3c>
 2cc:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 2d0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2d8:	000001c4 	andeq	r0, r0, r4, asr #3
 2dc:	000085ec 	andeq	r8, r0, ip, ror #11
 2e0:	00000044 	andeq	r0, r0, r4, asr #32
 2e4:	8b040e42 	blhi	103bf4 <__bss_end+0xf9f5c>
 2e8:	0b0d4201 	bleq	350af4 <__bss_end+0x346e5c>
 2ec:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 2f0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2f8:	000001c4 	andeq	r0, r0, r4, asr #3
 2fc:	00008630 	andeq	r8, r0, r0, lsr r6
 300:	00000050 	andeq	r0, r0, r0, asr r0
 304:	8b040e42 	blhi	103c14 <__bss_end+0xf9f7c>
 308:	0b0d4201 	bleq	350b14 <__bss_end+0x346e7c>
 30c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 310:	00000ecb 	andeq	r0, r0, fp, asr #29
 314:	0000001c 	andeq	r0, r0, ip, lsl r0
 318:	000001c4 	andeq	r0, r0, r4, asr #3
 31c:	00008680 	andeq	r8, r0, r0, lsl #13
 320:	00000054 	andeq	r0, r0, r4, asr r0
 324:	8b040e42 	blhi	103c34 <__bss_end+0xf9f9c>
 328:	0b0d4201 	bleq	350b34 <__bss_end+0x346e9c>
 32c:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 330:	00000ecb 	andeq	r0, r0, fp, asr #29
 334:	0000001c 	andeq	r0, r0, ip, lsl r0
 338:	000001c4 	andeq	r0, r0, r4, asr #3
 33c:	000086d4 	ldrdeq	r8, [r0], -r4
 340:	0000003c 	andeq	r0, r0, ip, lsr r0
 344:	8b040e42 	blhi	103c54 <__bss_end+0xf9fbc>
 348:	0b0d4201 	bleq	350b54 <__bss_end+0x346ebc>
 34c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 350:	00000ecb 	andeq	r0, r0, fp, asr #29
 354:	0000001c 	andeq	r0, r0, ip, lsl r0
 358:	000001c4 	andeq	r0, r0, r4, asr #3
 35c:	00008710 	andeq	r8, r0, r0, lsl r7
 360:	0000003c 	andeq	r0, r0, ip, lsr r0
 364:	8b040e42 	blhi	103c74 <__bss_end+0xf9fdc>
 368:	0b0d4201 	bleq	350b74 <__bss_end+0x346edc>
 36c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 370:	00000ecb 	andeq	r0, r0, fp, asr #29
 374:	0000001c 	andeq	r0, r0, ip, lsl r0
 378:	000001c4 	andeq	r0, r0, r4, asr #3
 37c:	0000874c 	andeq	r8, r0, ip, asr #14
 380:	0000003c 	andeq	r0, r0, ip, lsr r0
 384:	8b040e42 	blhi	103c94 <__bss_end+0xf9ffc>
 388:	0b0d4201 	bleq	350b94 <__bss_end+0x346efc>
 38c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 390:	00000ecb 	andeq	r0, r0, fp, asr #29
 394:	0000001c 	andeq	r0, r0, ip, lsl r0
 398:	000001c4 	andeq	r0, r0, r4, asr #3
 39c:	00008788 	andeq	r8, r0, r8, lsl #15
 3a0:	0000003c 	andeq	r0, r0, ip, lsr r0
 3a4:	8b040e42 	blhi	103cb4 <__bss_end+0xfa01c>
 3a8:	0b0d4201 	bleq	350bb4 <__bss_end+0x346f1c>
 3ac:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 3b0:	00000ecb 	andeq	r0, r0, fp, asr #29
 3b4:	0000001c 	andeq	r0, r0, ip, lsl r0
 3b8:	000001c4 	andeq	r0, r0, r4, asr #3
 3bc:	000087c4 	andeq	r8, r0, r4, asr #15
 3c0:	000000b0 	strheq	r0, [r0], -r0	; <UNPREDICTABLE>
 3c4:	8b080e42 	blhi	203cd4 <__bss_end+0x1fa03c>
 3c8:	42018e02 	andmi	r8, r1, #2, 28
 3cc:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 3d0:	080d0c50 	stmdaeq	sp, {r4, r6, sl, fp}
 3d4:	0000000c 	andeq	r0, r0, ip
 3d8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 3dc:	7c020001 	stcvc	0, cr0, [r2], {1}
 3e0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 3e4:	0000001c 	andeq	r0, r0, ip, lsl r0
 3e8:	000003d4 	ldrdeq	r0, [r0], -r4
 3ec:	00008878 	andeq	r8, r0, r8, ror r8
 3f0:	00000178 	andeq	r0, r0, r8, ror r1
 3f4:	8b080e42 	blhi	203d04 <__bss_end+0x1fa06c>
 3f8:	42018e02 	andmi	r8, r1, #2, 28
 3fc:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 400:	080d0cb4 	stmdaeq	sp, {r2, r4, r5, r7, sl, fp}
 404:	0000001c 	andeq	r0, r0, ip, lsl r0
 408:	000003d4 	ldrdeq	r0, [r0], -r4
 40c:	000089f0 	strdeq	r8, [r0], -r0
 410:	000000cc 	andeq	r0, r0, ip, asr #1
 414:	8b080e42 	blhi	203d24 <__bss_end+0x1fa08c>
 418:	42018e02 	andmi	r8, r1, #2, 28
 41c:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 420:	080d0c60 	stmdaeq	sp, {r5, r6, sl, fp}
 424:	0000001c 	andeq	r0, r0, ip, lsl r0
 428:	000003d4 	ldrdeq	r0, [r0], -r4
 42c:	00008abc 			; <UNDEFINED> instruction: 0x00008abc
 430:	00000100 	andeq	r0, r0, r0, lsl #2
 434:	8b040e42 	blhi	103d44 <__bss_end+0xfa0ac>
 438:	0b0d4201 	bleq	350c44 <__bss_end+0x346fac>
 43c:	0d0d7802 	stceq	8, cr7, [sp, #-8]
 440:	000ecb42 	andeq	ip, lr, r2, asr #22
 444:	0000001c 	andeq	r0, r0, ip, lsl r0
 448:	000003d4 	ldrdeq	r0, [r0], -r4
 44c:	00008bbc 			; <UNDEFINED> instruction: 0x00008bbc
 450:	0000015c 	andeq	r0, r0, ip, asr r1
 454:	8b040e42 	blhi	103d64 <__bss_end+0xfa0cc>
 458:	0b0d4201 	bleq	350c64 <__bss_end+0x346fcc>
 45c:	0d0d9c02 	stceq	12, cr9, [sp, #-8]
 460:	000ecb42 	andeq	ip, lr, r2, asr #22
 464:	0000001c 	andeq	r0, r0, ip, lsl r0
 468:	000003d4 	ldrdeq	r0, [r0], -r4
 46c:	00008d18 	andeq	r8, r0, r8, lsl sp
 470:	000000c0 	andeq	r0, r0, r0, asr #1
 474:	8b040e42 	blhi	103d84 <__bss_end+0xfa0ec>
 478:	0b0d4201 	bleq	350c84 <__bss_end+0x346fec>
 47c:	0d0d5802 	stceq	8, cr5, [sp, #-8]
 480:	000ecb42 	andeq	ip, lr, r2, asr #22
 484:	0000001c 	andeq	r0, r0, ip, lsl r0
 488:	000003d4 	ldrdeq	r0, [r0], -r4
 48c:	00008dd8 	ldrdeq	r8, [r0], -r8	; <UNPREDICTABLE>
 490:	000000ac 	andeq	r0, r0, ip, lsr #1
 494:	8b040e42 	blhi	103da4 <__bss_end+0xfa10c>
 498:	0b0d4201 	bleq	350ca4 <__bss_end+0x34700c>
 49c:	0d0d4e02 	stceq	14, cr4, [sp, #-8]
 4a0:	000ecb42 	andeq	ip, lr, r2, asr #22
 4a4:	0000001c 	andeq	r0, r0, ip, lsl r0
 4a8:	000003d4 	ldrdeq	r0, [r0], -r4
 4ac:	00008e84 	andeq	r8, r0, r4, lsl #29
 4b0:	00000054 	andeq	r0, r0, r4, asr r0
 4b4:	8b040e42 	blhi	103dc4 <__bss_end+0xfa12c>
 4b8:	0b0d4201 	bleq	350cc4 <__bss_end+0x34702c>
 4bc:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 4c0:	00000ecb 	andeq	r0, r0, fp, asr #29
 4c4:	0000001c 	andeq	r0, r0, ip, lsl r0
 4c8:	000003d4 	ldrdeq	r0, [r0], -r4
 4cc:	00008ed8 	ldrdeq	r8, [r0], -r8	; <UNPREDICTABLE>
 4d0:	000000ac 	andeq	r0, r0, ip, lsr #1
 4d4:	8b080e42 	blhi	203de4 <__bss_end+0x1fa14c>
 4d8:	42018e02 	andmi	r8, r1, #2, 28
 4dc:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 4e0:	080d0c50 	stmdaeq	sp, {r4, r6, sl, fp}
 4e4:	0000001c 	andeq	r0, r0, ip, lsl r0
 4e8:	000003d4 	ldrdeq	r0, [r0], -r4
 4ec:	00008f84 	andeq	r8, r0, r4, lsl #31
 4f0:	000000d8 	ldrdeq	r0, [r0], -r8
 4f4:	8b080e42 	blhi	203e04 <__bss_end+0x1fa16c>
 4f8:	42018e02 	andmi	r8, r1, #2, 28
 4fc:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 500:	080d0c66 	stmdaeq	sp, {r1, r2, r5, r6, sl, fp}
 504:	0000001c 	andeq	r0, r0, ip, lsl r0
 508:	000003d4 	ldrdeq	r0, [r0], -r4
 50c:	0000905c 	andeq	r9, r0, ip, asr r0
 510:	00000068 	andeq	r0, r0, r8, rrx
 514:	8b040e42 	blhi	103e24 <__bss_end+0xfa18c>
 518:	0b0d4201 	bleq	350d24 <__bss_end+0x34708c>
 51c:	420d0d6c 	andmi	r0, sp, #108, 26	; 0x1b00
 520:	00000ecb 	andeq	r0, r0, fp, asr #29
 524:	0000001c 	andeq	r0, r0, ip, lsl r0
 528:	000003d4 	ldrdeq	r0, [r0], -r4
 52c:	000090c4 	andeq	r9, r0, r4, asr #1
 530:	00000080 	andeq	r0, r0, r0, lsl #1
 534:	8b040e42 	blhi	103e44 <__bss_end+0xfa1ac>
 538:	0b0d4201 	bleq	350d44 <__bss_end+0x3470ac>
 53c:	420d0d78 	andmi	r0, sp, #120, 26	; 0x1e00
 540:	00000ecb 	andeq	r0, r0, fp, asr #29
 544:	0000001c 	andeq	r0, r0, ip, lsl r0
 548:	000003d4 	ldrdeq	r0, [r0], -r4
 54c:	00009144 	andeq	r9, r0, r4, asr #2
 550:	00000068 	andeq	r0, r0, r8, rrx
 554:	8b040e42 	blhi	103e64 <__bss_end+0xfa1cc>
 558:	0b0d4201 	bleq	350d64 <__bss_end+0x3470cc>
 55c:	420d0d6c 	andmi	r0, sp, #108, 26	; 0x1b00
 560:	00000ecb 	andeq	r0, r0, fp, asr #29
 564:	0000002c 	andeq	r0, r0, ip, lsr #32
 568:	000003d4 	ldrdeq	r0, [r0], -r4
 56c:	000091ac 	andeq	r9, r0, ip, lsr #3
 570:	00000328 	andeq	r0, r0, r8, lsr #6
 574:	84200e42 	strthi	r0, [r0], #-3650	; 0xfffff1be
 578:	86078508 	strhi	r8, [r7], -r8, lsl #10
 57c:	88058706 	stmdahi	r5, {r1, r2, r8, r9, sl, pc}
 580:	8b038904 	blhi	e2998 <__bss_end+0xd8d00>
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
 5ac:	000094d4 	ldrdeq	r9, [r0], -r4
 5b0:	000001ec 	andeq	r0, r0, ip, ror #3
 5b4:	0000000c 	andeq	r0, r0, ip
 5b8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 5bc:	7c020001 	stcvc	0, cr0, [r2], {1}
 5c0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 5c4:	00000010 	andeq	r0, r0, r0, lsl r0
 5c8:	000005b4 			; <UNDEFINED> instruction: 0x000005b4
 5cc:	000096e4 	andeq	r9, r0, r4, ror #13
 5d0:	0000019c 	muleq	r0, ip, r1
 5d4:	0bce020a 	bleq	ff380e04 <__bss_end+0xff37716c>
 5d8:	00000010 	andeq	r0, r0, r0, lsl r0
 5dc:	000005b4 			; <UNDEFINED> instruction: 0x000005b4
 5e0:	00009880 	andeq	r9, r0, r0, lsl #17
 5e4:	00000028 	andeq	r0, r0, r8, lsr #32
 5e8:	000b540a 	andeq	r5, fp, sl, lsl #8
 5ec:	00000010 	andeq	r0, r0, r0, lsl r0
 5f0:	000005b4 			; <UNDEFINED> instruction: 0x000005b4
 5f4:	000098a8 	andeq	r9, r0, r8, lsr #17
 5f8:	0000008c 	andeq	r0, r0, ip, lsl #1
 5fc:	0b46020a 	bleq	1180e2c <__bss_end+0x1177194>
 600:	0000000c 	andeq	r0, r0, ip
 604:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 608:	7c020001 	stcvc	0, cr0, [r2], {1}
 60c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 610:	00000030 	andeq	r0, r0, r0, lsr r0
 614:	00000600 	andeq	r0, r0, r0, lsl #12
 618:	00009934 	andeq	r9, r0, r4, lsr r9
 61c:	000000d4 	ldrdeq	r0, [r0], -r4
 620:	8e100e5a 	mrchi	14, 0, r0, cr0, cr10, {2}
 624:	460a4a03 	strmi	r4, [sl], -r3, lsl #20
 628:	42100ece 	andsmi	r0, r0, #3296	; 0xce0
 62c:	460a4a0b 	strmi	r4, [sl], -fp, lsl #20
 630:	4a100ece 	bmi	404170 <__bss_end+0x3fa4d8>
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
 65c:	00009a08 	andeq	r9, r0, r8, lsl #20
 660:	00000030 	andeq	r0, r0, r0, lsr r0
 664:	84080e4e 	strhi	r0, [r8], #-3662	; 0xfffff1b2
 668:	00018e02 	andeq	r8, r1, r2, lsl #28
 66c:	0000000c 	andeq	r0, r0, ip
 670:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 674:	7c020001 	stcvc	0, cr0, [r2], {1}
 678:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 67c:	0000000c 	andeq	r0, r0, ip
 680:	0000066c 	andeq	r0, r0, ip, ror #12
 684:	00009a38 	andeq	r9, r0, r8, lsr sl
 688:	00000040 	andeq	r0, r0, r0, asr #32
 68c:	0000000c 	andeq	r0, r0, ip
 690:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 694:	7c020001 	stcvc	0, cr0, [r2], {1}
 698:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 69c:	00000020 	andeq	r0, r0, r0, lsr #32
 6a0:	0000068c 	andeq	r0, r0, ip, lsl #13
 6a4:	00009a78 	andeq	r9, r0, r8, ror sl
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

