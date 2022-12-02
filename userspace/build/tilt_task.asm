
./tilt_task:     file format elf32-littlearm


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
    805c:	00009b30 	andeq	r9, r0, r0, lsr fp
    8060:	00009b40 	andeq	r9, r0, r0, asr #22

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
    8080:	eb000069 	bl	822c <main>
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
    81cc:	00009b30 	andeq	r9, r0, r0, lsr fp
    81d0:	00009b30 	andeq	r9, r0, r0, lsr fp

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
    8224:	00009b30 	andeq	r9, r0, r0, lsr fp
    8228:	00009b30 	andeq	r9, r0, r0, lsr fp

0000822c <main>:
main():
/home/trefil/sem/sources/userspace/tilt_task/main.cpp:15
 * 
 * Ceka na vstup ze senzoru naklonu, a prehraje neco na buzzeru (PWM) dle naklonu
 **/

int main(int argc, char** argv)
{
    822c:	e92d4800 	push	{fp, lr}
    8230:	e28db004 	add	fp, sp, #4
    8234:	e24dd020 	sub	sp, sp, #32
    8238:	e50b0020 	str	r0, [fp, #-32]	; 0xffffffe0
    823c:	e50b1024 	str	r1, [fp, #-36]	; 0xffffffdc
/home/trefil/sem/sources/userspace/tilt_task/main.cpp:16
	char state = '0';
    8240:	e3a03030 	mov	r3, #48	; 0x30
    8244:	e54b3011 	strb	r3, [fp, #-17]	; 0xffffffef
/home/trefil/sem/sources/userspace/tilt_task/main.cpp:17
	char oldstate = '0';
    8248:	e3a03030 	mov	r3, #48	; 0x30
    824c:	e54b3005 	strb	r3, [fp, #-5]
/home/trefil/sem/sources/userspace/tilt_task/main.cpp:19

	uint32_t tiltsensor_file = open("DEV:gpio/23", NFile_Open_Mode::Read_Only);
    8250:	e3a01000 	mov	r1, #0
    8254:	e59f009c 	ldr	r0, [pc, #156]	; 82f8 <main+0xcc>
    8258:	eb000047 	bl	837c <_Z4openPKc15NFile_Open_Mode>
    825c:	e50b000c 	str	r0, [fp, #-12]
/home/trefil/sem/sources/userspace/tilt_task/main.cpp:27
	NGPIO_Interrupt_Type irtype;
	
	//irtype = NGPIO_Interrupt_Type::Rising_Edge;
	//ioctl(tiltsensor_file, NIOCtl_Operation::Enable_Event_Detection, &irtype);

	irtype = NGPIO_Interrupt_Type::Falling_Edge;
    8260:	e3a03001 	mov	r3, #1
    8264:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/userspace/tilt_task/main.cpp:28
	ioctl(tiltsensor_file, NIOCtl_Operation::Enable_Event_Detection, &irtype);
    8268:	e24b3018 	sub	r3, fp, #24
    826c:	e1a02003 	mov	r2, r3
    8270:	e3a01002 	mov	r1, #2
    8274:	e51b000c 	ldr	r0, [fp, #-12]
    8278:	eb000083 	bl	848c <_Z5ioctlj16NIOCtl_OperationPv>
/home/trefil/sem/sources/userspace/tilt_task/main.cpp:30

	uint32_t logpipe = pipe("log", 32);
    827c:	e3a01020 	mov	r1, #32
    8280:	e59f0074 	ldr	r0, [pc, #116]	; 82fc <main+0xd0>
    8284:	eb00010a 	bl	86b4 <_Z4pipePKcj>
    8288:	e50b0010 	str	r0, [fp, #-16]
/home/trefil/sem/sources/userspace/tilt_task/main.cpp:34

	while (true)
	{
		wait(tiltsensor_file, 0x800);
    828c:	e3e02001 	mvn	r2, #1
    8290:	e3a01b02 	mov	r1, #2048	; 0x800
    8294:	e51b000c 	ldr	r0, [fp, #-12]
    8298:	eb0000a0 	bl	8520 <_Z4waitjjj>
/home/trefil/sem/sources/userspace/tilt_task/main.cpp:39

		// "debounce" - tilt senzor bude chvili flappovat mezi vysokou a nizkou urovni
		//sleep(0x100, Deadline_Unchanged);

		read(tiltsensor_file, &state, 1);
    829c:	e24b3011 	sub	r3, fp, #17
    82a0:	e3a02001 	mov	r2, #1
    82a4:	e1a01003 	mov	r1, r3
    82a8:	e51b000c 	ldr	r0, [fp, #-12]
    82ac:	eb000043 	bl	83c0 <_Z4readjPcj>
/home/trefil/sem/sources/userspace/tilt_task/main.cpp:43

		//if (state != oldstate)
		{
			if (state == '0')
    82b0:	e55b3011 	ldrb	r3, [fp, #-17]	; 0xffffffef
    82b4:	e3530030 	cmp	r3, #48	; 0x30
    82b8:	1a000004 	bne	82d0 <main+0xa4>
/home/trefil/sem/sources/userspace/tilt_task/main.cpp:45
			{
				write(logpipe, "Tilt UP", 7);
    82bc:	e3a02007 	mov	r2, #7
    82c0:	e59f1038 	ldr	r1, [pc, #56]	; 8300 <main+0xd4>
    82c4:	e51b0010 	ldr	r0, [fp, #-16]
    82c8:	eb000050 	bl	8410 <_Z5writejPKcj>
    82cc:	ea000003 	b	82e0 <main+0xb4>
/home/trefil/sem/sources/userspace/tilt_task/main.cpp:49
			}
			else
			{
				write(logpipe, "Tilt DOWN", 10);
    82d0:	e3a0200a 	mov	r2, #10
    82d4:	e59f1028 	ldr	r1, [pc, #40]	; 8304 <main+0xd8>
    82d8:	e51b0010 	ldr	r0, [fp, #-16]
    82dc:	eb00004b 	bl	8410 <_Z5writejPKcj>
/home/trefil/sem/sources/userspace/tilt_task/main.cpp:51
			}
			oldstate = state;
    82e0:	e55b3011 	ldrb	r3, [fp, #-17]	; 0xffffffef
    82e4:	e54b3005 	strb	r3, [fp, #-5]
/home/trefil/sem/sources/userspace/tilt_task/main.cpp:54
		}

		sleep(0x1000, Indefinite/*0x100*/);
    82e8:	e3e01000 	mvn	r1, #0
    82ec:	e3a00a01 	mov	r0, #4096	; 0x1000
    82f0:	eb00009e 	bl	8570 <_Z5sleepjj>
/home/trefil/sem/sources/userspace/tilt_task/main.cpp:34
		wait(tiltsensor_file, 0x800);
    82f4:	eaffffe4 	b	828c <main+0x60>
    82f8:	00009ab8 			; <UNDEFINED> instruction: 0x00009ab8
    82fc:	00009ac4 	andeq	r9, r0, r4, asr #21
    8300:	00009ac8 	andeq	r9, r0, r8, asr #21
    8304:	00009ad0 	ldrdeq	r9, [r0], -r0

00008308 <_Z6getpidv>:
_Z6getpidv():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:5
#include <stdfile.h>
#include <stdstring.h>

uint32_t getpid()
{
    8308:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    830c:	e28db000 	add	fp, sp, #0
    8310:	e24dd00c 	sub	sp, sp, #12
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:8
    uint32_t pid;

    asm volatile("swi 0");
    8314:	ef000000 	svc	0x00000000
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:9
    asm volatile("mov %0, r0" : "=r" (pid));
    8318:	e1a03000 	mov	r3, r0
    831c:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:11

    return pid;
    8320:	e51b3008 	ldr	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:12
}
    8324:	e1a00003 	mov	r0, r3
    8328:	e28bd000 	add	sp, fp, #0
    832c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8330:	e12fff1e 	bx	lr

00008334 <_Z9terminatei>:
_Z9terminatei():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:15

void terminate(int exitcode)
{
    8334:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8338:	e28db000 	add	fp, sp, #0
    833c:	e24dd00c 	sub	sp, sp, #12
    8340:	e50b0008 	str	r0, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:16
    asm volatile("mov r0, %0" : : "r" (exitcode));
    8344:	e51b3008 	ldr	r3, [fp, #-8]
    8348:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:17
    asm volatile("swi 1");
    834c:	ef000001 	svc	0x00000001
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:18
}
    8350:	e320f000 	nop	{0}
    8354:	e28bd000 	add	sp, fp, #0
    8358:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    835c:	e12fff1e 	bx	lr

00008360 <_Z11sched_yieldv>:
_Z11sched_yieldv():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:21

void sched_yield()
{
    8360:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8364:	e28db000 	add	fp, sp, #0
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:22
    asm volatile("swi 2");
    8368:	ef000002 	svc	0x00000002
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:23
}
    836c:	e320f000 	nop	{0}
    8370:	e28bd000 	add	sp, fp, #0
    8374:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8378:	e12fff1e 	bx	lr

0000837c <_Z4openPKc15NFile_Open_Mode>:
_Z4openPKc15NFile_Open_Mode():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:26

uint32_t open(const char* filename, NFile_Open_Mode mode)
{
    837c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8380:	e28db000 	add	fp, sp, #0
    8384:	e24dd014 	sub	sp, sp, #20
    8388:	e50b0010 	str	r0, [fp, #-16]
    838c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:29
    uint32_t file;

    asm volatile("mov r0, %0" : : "r" (filename));
    8390:	e51b3010 	ldr	r3, [fp, #-16]
    8394:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:30
    asm volatile("mov r1, %0" : : "r" (mode));
    8398:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    839c:	e1a01003 	mov	r1, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:31
    asm volatile("swi 64");
    83a0:	ef000040 	svc	0x00000040
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:32
    asm volatile("mov %0, r0" : "=r" (file));
    83a4:	e1a03000 	mov	r3, r0
    83a8:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:34

    return file;
    83ac:	e51b3008 	ldr	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:35
}
    83b0:	e1a00003 	mov	r0, r3
    83b4:	e28bd000 	add	sp, fp, #0
    83b8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    83bc:	e12fff1e 	bx	lr

000083c0 <_Z4readjPcj>:
_Z4readjPcj():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:38

uint32_t read(uint32_t file, char* const buffer, uint32_t size)
{
    83c0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    83c4:	e28db000 	add	fp, sp, #0
    83c8:	e24dd01c 	sub	sp, sp, #28
    83cc:	e50b0010 	str	r0, [fp, #-16]
    83d0:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    83d4:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:41
    uint32_t rdnum;

    asm volatile("mov r0, %0" : : "r" (file));
    83d8:	e51b3010 	ldr	r3, [fp, #-16]
    83dc:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:42
    asm volatile("mov r1, %0" : : "r" (buffer));
    83e0:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    83e4:	e1a01003 	mov	r1, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:43
    asm volatile("mov r2, %0" : : "r" (size));
    83e8:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    83ec:	e1a02003 	mov	r2, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:44
    asm volatile("swi 65");
    83f0:	ef000041 	svc	0x00000041
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:45
    asm volatile("mov %0, r0" : "=r" (rdnum));
    83f4:	e1a03000 	mov	r3, r0
    83f8:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:47

    return rdnum;
    83fc:	e51b3008 	ldr	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:48
}
    8400:	e1a00003 	mov	r0, r3
    8404:	e28bd000 	add	sp, fp, #0
    8408:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    840c:	e12fff1e 	bx	lr

00008410 <_Z5writejPKcj>:
_Z5writejPKcj():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:52


uint32_t write(uint32_t file, const char* buffer, uint32_t size)
{
    8410:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8414:	e28db000 	add	fp, sp, #0
    8418:	e24dd01c 	sub	sp, sp, #28
    841c:	e50b0010 	str	r0, [fp, #-16]
    8420:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8424:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:55
    uint32_t wrnum;

    asm volatile("mov r0, %0" : : "r" (file));
    8428:	e51b3010 	ldr	r3, [fp, #-16]
    842c:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:56
    asm volatile("mov r1, %0" : : "r" (buffer));
    8430:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8434:	e1a01003 	mov	r1, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:57
    asm volatile("mov r2, %0" : : "r" (size));
    8438:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    843c:	e1a02003 	mov	r2, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:58
    asm volatile("swi 66");
    8440:	ef000042 	svc	0x00000042
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:59
    asm volatile("mov %0, r0" : "=r" (wrnum));
    8444:	e1a03000 	mov	r3, r0
    8448:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:61

    return wrnum;
    844c:	e51b3008 	ldr	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:62
}
    8450:	e1a00003 	mov	r0, r3
    8454:	e28bd000 	add	sp, fp, #0
    8458:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    845c:	e12fff1e 	bx	lr

00008460 <_Z5closej>:
_Z5closej():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:65

void close(uint32_t file)
{
    8460:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8464:	e28db000 	add	fp, sp, #0
    8468:	e24dd00c 	sub	sp, sp, #12
    846c:	e50b0008 	str	r0, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:66
    asm volatile("mov r0, %0" : : "r" (file));
    8470:	e51b3008 	ldr	r3, [fp, #-8]
    8474:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:67
    asm volatile("swi 67");
    8478:	ef000043 	svc	0x00000043
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:68
}
    847c:	e320f000 	nop	{0}
    8480:	e28bd000 	add	sp, fp, #0
    8484:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8488:	e12fff1e 	bx	lr

0000848c <_Z5ioctlj16NIOCtl_OperationPv>:
_Z5ioctlj16NIOCtl_OperationPv():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:71

uint32_t ioctl(uint32_t file, NIOCtl_Operation operation, void* param)
{
    848c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8490:	e28db000 	add	fp, sp, #0
    8494:	e24dd01c 	sub	sp, sp, #28
    8498:	e50b0010 	str	r0, [fp, #-16]
    849c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    84a0:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:74
    uint32_t retcode;

    asm volatile("mov r0, %0" : : "r" (file));
    84a4:	e51b3010 	ldr	r3, [fp, #-16]
    84a8:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:75
    asm volatile("mov r1, %0" : : "r" (operation));
    84ac:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    84b0:	e1a01003 	mov	r1, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:76
    asm volatile("mov r2, %0" : : "r" (param));
    84b4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    84b8:	e1a02003 	mov	r2, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:77
    asm volatile("swi 68");
    84bc:	ef000044 	svc	0x00000044
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:78
    asm volatile("mov %0, r0" : "=r" (retcode));
    84c0:	e1a03000 	mov	r3, r0
    84c4:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:80

    return retcode;
    84c8:	e51b3008 	ldr	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:81
}
    84cc:	e1a00003 	mov	r0, r3
    84d0:	e28bd000 	add	sp, fp, #0
    84d4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    84d8:	e12fff1e 	bx	lr

000084dc <_Z6notifyjj>:
_Z6notifyjj():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:84

uint32_t notify(uint32_t file, uint32_t count)
{
    84dc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    84e0:	e28db000 	add	fp, sp, #0
    84e4:	e24dd014 	sub	sp, sp, #20
    84e8:	e50b0010 	str	r0, [fp, #-16]
    84ec:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:87
    uint32_t retcnt;

    asm volatile("mov r0, %0" : : "r" (file));
    84f0:	e51b3010 	ldr	r3, [fp, #-16]
    84f4:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:88
    asm volatile("mov r1, %0" : : "r" (count));
    84f8:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    84fc:	e1a01003 	mov	r1, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:89
    asm volatile("swi 69");
    8500:	ef000045 	svc	0x00000045
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:90
    asm volatile("mov %0, r0" : "=r" (retcnt));
    8504:	e1a03000 	mov	r3, r0
    8508:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:92

    return retcnt;
    850c:	e51b3008 	ldr	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:93
}
    8510:	e1a00003 	mov	r0, r3
    8514:	e28bd000 	add	sp, fp, #0
    8518:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    851c:	e12fff1e 	bx	lr

00008520 <_Z4waitjjj>:
_Z4waitjjj():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:96

NSWI_Result_Code wait(uint32_t file, uint32_t count, uint32_t notified_deadline)
{
    8520:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8524:	e28db000 	add	fp, sp, #0
    8528:	e24dd01c 	sub	sp, sp, #28
    852c:	e50b0010 	str	r0, [fp, #-16]
    8530:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8534:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:99
    NSWI_Result_Code retcode;

    asm volatile("mov r0, %0" : : "r" (file));
    8538:	e51b3010 	ldr	r3, [fp, #-16]
    853c:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:100
    asm volatile("mov r1, %0" : : "r" (count));
    8540:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8544:	e1a01003 	mov	r1, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:101
    asm volatile("mov r2, %0" : : "r" (notified_deadline));
    8548:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    854c:	e1a02003 	mov	r2, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:102
    asm volatile("swi 70");
    8550:	ef000046 	svc	0x00000046
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:103
    asm volatile("mov %0, r0" : "=r" (retcode));
    8554:	e1a03000 	mov	r3, r0
    8558:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:105

    return retcode;
    855c:	e51b3008 	ldr	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:106
}
    8560:	e1a00003 	mov	r0, r3
    8564:	e28bd000 	add	sp, fp, #0
    8568:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    856c:	e12fff1e 	bx	lr

00008570 <_Z5sleepjj>:
_Z5sleepjj():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:109

bool sleep(uint32_t ticks, uint32_t notified_deadline)
{
    8570:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8574:	e28db000 	add	fp, sp, #0
    8578:	e24dd014 	sub	sp, sp, #20
    857c:	e50b0010 	str	r0, [fp, #-16]
    8580:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:112
    uint32_t retcode;

    asm volatile("mov r0, %0" : : "r" (ticks));
    8584:	e51b3010 	ldr	r3, [fp, #-16]
    8588:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:113
    asm volatile("mov r1, %0" : : "r" (notified_deadline));
    858c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8590:	e1a01003 	mov	r1, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:114
    asm volatile("swi 3");
    8594:	ef000003 	svc	0x00000003
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:115
    asm volatile("mov %0, r0" : "=r" (retcode));
    8598:	e1a03000 	mov	r3, r0
    859c:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:117

    return retcode;
    85a0:	e51b3008 	ldr	r3, [fp, #-8]
    85a4:	e3530000 	cmp	r3, #0
    85a8:	13a03001 	movne	r3, #1
    85ac:	03a03000 	moveq	r3, #0
    85b0:	e6ef3073 	uxtb	r3, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:118
}
    85b4:	e1a00003 	mov	r0, r3
    85b8:	e28bd000 	add	sp, fp, #0
    85bc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    85c0:	e12fff1e 	bx	lr

000085c4 <_Z24get_active_process_countv>:
_Z24get_active_process_countv():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:121

uint32_t get_active_process_count()
{
    85c4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    85c8:	e28db000 	add	fp, sp, #0
    85cc:	e24dd00c 	sub	sp, sp, #12
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:122
    const NGet_Sched_Info_Type req = NGet_Sched_Info_Type::Active_Process_Count;
    85d0:	e3a03000 	mov	r3, #0
    85d4:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:125
    uint32_t retval;

    asm volatile("mov r0, %0" : : "r" (req));
    85d8:	e3a03000 	mov	r3, #0
    85dc:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:126
    asm volatile("mov r1, %0" : : "r" (&retval));
    85e0:	e24b300c 	sub	r3, fp, #12
    85e4:	e1a01003 	mov	r1, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:127
    asm volatile("swi 4");
    85e8:	ef000004 	svc	0x00000004
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:129

    return retval;
    85ec:	e51b300c 	ldr	r3, [fp, #-12]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:130
}
    85f0:	e1a00003 	mov	r0, r3
    85f4:	e28bd000 	add	sp, fp, #0
    85f8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    85fc:	e12fff1e 	bx	lr

00008600 <_Z14get_tick_countv>:
_Z14get_tick_countv():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:133

uint32_t get_tick_count()
{
    8600:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8604:	e28db000 	add	fp, sp, #0
    8608:	e24dd00c 	sub	sp, sp, #12
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:134
    const NGet_Sched_Info_Type req = NGet_Sched_Info_Type::Tick_Count;
    860c:	e3a03001 	mov	r3, #1
    8610:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:137
    uint32_t retval;

    asm volatile("mov r0, %0" : : "r" (req));
    8614:	e3a03001 	mov	r3, #1
    8618:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:138
    asm volatile("mov r1, %0" : : "r" (&retval));
    861c:	e24b300c 	sub	r3, fp, #12
    8620:	e1a01003 	mov	r1, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:139
    asm volatile("swi 4");
    8624:	ef000004 	svc	0x00000004
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:141

    return retval;
    8628:	e51b300c 	ldr	r3, [fp, #-12]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:142
}
    862c:	e1a00003 	mov	r0, r3
    8630:	e28bd000 	add	sp, fp, #0
    8634:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8638:	e12fff1e 	bx	lr

0000863c <_Z17set_task_deadlinej>:
_Z17set_task_deadlinej():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:145

void set_task_deadline(uint32_t tick_count_required)
{
    863c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8640:	e28db000 	add	fp, sp, #0
    8644:	e24dd014 	sub	sp, sp, #20
    8648:	e50b0010 	str	r0, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:146
    const NDeadline_Subservice req = NDeadline_Subservice::Set_Relative;
    864c:	e3a03000 	mov	r3, #0
    8650:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:148

    asm volatile("mov r0, %0" : : "r" (req));
    8654:	e3a03000 	mov	r3, #0
    8658:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:149
    asm volatile("mov r1, %0" : : "r" (&tick_count_required));
    865c:	e24b3010 	sub	r3, fp, #16
    8660:	e1a01003 	mov	r1, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:150
    asm volatile("swi 5");
    8664:	ef000005 	svc	0x00000005
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:151
}
    8668:	e320f000 	nop	{0}
    866c:	e28bd000 	add	sp, fp, #0
    8670:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8674:	e12fff1e 	bx	lr

00008678 <_Z26get_task_ticks_to_deadlinev>:
_Z26get_task_ticks_to_deadlinev():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:154

uint32_t get_task_ticks_to_deadline()
{
    8678:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    867c:	e28db000 	add	fp, sp, #0
    8680:	e24dd00c 	sub	sp, sp, #12
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:155
    const NDeadline_Subservice req = NDeadline_Subservice::Get_Remaining;
    8684:	e3a03001 	mov	r3, #1
    8688:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:158
    uint32_t ticks;

    asm volatile("mov r0, %0" : : "r" (req));
    868c:	e3a03001 	mov	r3, #1
    8690:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:159
    asm volatile("mov r1, %0" : : "r" (&ticks));
    8694:	e24b300c 	sub	r3, fp, #12
    8698:	e1a01003 	mov	r1, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:160
    asm volatile("swi 5");
    869c:	ef000005 	svc	0x00000005
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:162

    return ticks;
    86a0:	e51b300c 	ldr	r3, [fp, #-12]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:163
}
    86a4:	e1a00003 	mov	r0, r3
    86a8:	e28bd000 	add	sp, fp, #0
    86ac:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    86b0:	e12fff1e 	bx	lr

000086b4 <_Z4pipePKcj>:
_Z4pipePKcj():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:168

const char Pipe_File_Prefix[] = "SYS:pipe/";

uint32_t pipe(const char* name, uint32_t buf_size)
{
    86b4:	e92d4800 	push	{fp, lr}
    86b8:	e28db004 	add	fp, sp, #4
    86bc:	e24dd050 	sub	sp, sp, #80	; 0x50
    86c0:	e50b0050 	str	r0, [fp, #-80]	; 0xffffffb0
    86c4:	e50b1054 	str	r1, [fp, #-84]	; 0xffffffac
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:170
    char fname[64];
    strncpy(fname, Pipe_File_Prefix, sizeof(Pipe_File_Prefix));
    86c8:	e24b3048 	sub	r3, fp, #72	; 0x48
    86cc:	e3a0200a 	mov	r2, #10
    86d0:	e59f1088 	ldr	r1, [pc, #136]	; 8760 <_Z4pipePKcj+0xac>
    86d4:	e1a00003 	mov	r0, r3
    86d8:	eb00013e 	bl	8bd8 <_Z7strncpyPcPKci>
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:171
    strncpy(fname + sizeof(Pipe_File_Prefix), name, sizeof(fname) - sizeof(Pipe_File_Prefix) - 1);
    86dc:	e24b3048 	sub	r3, fp, #72	; 0x48
    86e0:	e283300a 	add	r3, r3, #10
    86e4:	e3a02035 	mov	r2, #53	; 0x35
    86e8:	e51b1050 	ldr	r1, [fp, #-80]	; 0xffffffb0
    86ec:	e1a00003 	mov	r0, r3
    86f0:	eb000138 	bl	8bd8 <_Z7strncpyPcPKci>
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:173

    int ncur = sizeof(Pipe_File_Prefix) + strlen(name);
    86f4:	e51b0050 	ldr	r0, [fp, #-80]	; 0xffffffb0
    86f8:	eb000191 	bl	8d44 <_Z6strlenPKc>
    86fc:	e1a03000 	mov	r3, r0
    8700:	e283300a 	add	r3, r3, #10
    8704:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:175

    fname[ncur++] = '#';
    8708:	e51b3008 	ldr	r3, [fp, #-8]
    870c:	e2832001 	add	r2, r3, #1
    8710:	e50b2008 	str	r2, [fp, #-8]
    8714:	e2433004 	sub	r3, r3, #4
    8718:	e083300b 	add	r3, r3, fp
    871c:	e3a02023 	mov	r2, #35	; 0x23
    8720:	e5432044 	strb	r2, [r3, #-68]	; 0xffffffbc
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:177

    itoa(buf_size, &fname[ncur], 10);
    8724:	e51b0054 	ldr	r0, [fp, #-84]	; 0xffffffac
    8728:	e24b2048 	sub	r2, fp, #72	; 0x48
    872c:	e51b3008 	ldr	r3, [fp, #-8]
    8730:	e0823003 	add	r3, r2, r3
    8734:	e3a0200a 	mov	r2, #10
    8738:	e1a01003 	mov	r1, r3
    873c:	eb000009 	bl	8768 <_Z4itoaiPcj>
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:179

    return open(fname, NFile_Open_Mode::Read_Write);
    8740:	e24b3048 	sub	r3, fp, #72	; 0x48
    8744:	e3a01002 	mov	r1, #2
    8748:	e1a00003 	mov	r0, r3
    874c:	ebffff0a 	bl	837c <_Z4openPKc15NFile_Open_Mode>
    8750:	e1a03000 	mov	r3, r0
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:180
}
    8754:	e1a00003 	mov	r0, r3
    8758:	e24bd004 	sub	sp, fp, #4
    875c:	e8bd8800 	pop	{fp, pc}
    8760:	00009b08 	andeq	r9, r0, r8, lsl #22
    8764:	00000000 	andeq	r0, r0, r0

00008768 <_Z4itoaiPcj>:
_Z4itoaiPcj():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:9
{
    const char CharConvArr[] = "0123456789ABCDEF";
}

void itoa(int input, char* output, unsigned int base)
{
    8768:	e92d4800 	push	{fp, lr}
    876c:	e28db004 	add	fp, sp, #4
    8770:	e24dd020 	sub	sp, sp, #32
    8774:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    8778:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    877c:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:10
    int i = 0;
    8780:	e3a03000 	mov	r3, #0
    8784:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:11
    int j = 0;
    8788:	e3a03000 	mov	r3, #0
    878c:	e50b300c 	str	r3, [fp, #-12]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:13

	while (input > 0)
    8790:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8794:	e3530000 	cmp	r3, #0
    8798:	da000015 	ble	87f4 <_Z4itoaiPcj+0x8c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:15
	{
		output[i] = CharConvArr[input % base];
    879c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    87a0:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    87a4:	e1a00003 	mov	r0, r3
    87a8:	eb000374 	bl	9580 <__aeabi_uidivmod>
    87ac:	e1a03001 	mov	r3, r1
    87b0:	e1a01003 	mov	r1, r3
    87b4:	e51b3008 	ldr	r3, [fp, #-8]
    87b8:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    87bc:	e0823003 	add	r3, r2, r3
    87c0:	e59f2114 	ldr	r2, [pc, #276]	; 88dc <_Z4itoaiPcj+0x174>
    87c4:	e7d22001 	ldrb	r2, [r2, r1]
    87c8:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:16
		input /= base;
    87cc:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    87d0:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    87d4:	e1a00003 	mov	r0, r3
    87d8:	eb0002ed 	bl	9394 <__udivsi3>
    87dc:	e1a03000 	mov	r3, r0
    87e0:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:17
		i++;
    87e4:	e51b3008 	ldr	r3, [fp, #-8]
    87e8:	e2833001 	add	r3, r3, #1
    87ec:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:13
	while (input > 0)
    87f0:	eaffffe6 	b	8790 <_Z4itoaiPcj+0x28>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:20
	}

    if (i == 0)
    87f4:	e51b3008 	ldr	r3, [fp, #-8]
    87f8:	e3530000 	cmp	r3, #0
    87fc:	1a000007 	bne	8820 <_Z4itoaiPcj+0xb8>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:22
    {
        output[i] = CharConvArr[0];
    8800:	e51b3008 	ldr	r3, [fp, #-8]
    8804:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8808:	e0823003 	add	r3, r2, r3
    880c:	e3a02030 	mov	r2, #48	; 0x30
    8810:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:23
        i++;
    8814:	e51b3008 	ldr	r3, [fp, #-8]
    8818:	e2833001 	add	r3, r3, #1
    881c:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:26
    }

	output[i] = '\0';
    8820:	e51b3008 	ldr	r3, [fp, #-8]
    8824:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8828:	e0823003 	add	r3, r2, r3
    882c:	e3a02000 	mov	r2, #0
    8830:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:27
	i--;
    8834:	e51b3008 	ldr	r3, [fp, #-8]
    8838:	e2433001 	sub	r3, r3, #1
    883c:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:29 (discriminator 2)

	for (j; j <= i/2; j++)
    8840:	e51b3008 	ldr	r3, [fp, #-8]
    8844:	e1a02fa3 	lsr	r2, r3, #31
    8848:	e0823003 	add	r3, r2, r3
    884c:	e1a030c3 	asr	r3, r3, #1
    8850:	e1a02003 	mov	r2, r3
    8854:	e51b300c 	ldr	r3, [fp, #-12]
    8858:	e1530002 	cmp	r3, r2
    885c:	ca00001b 	bgt	88d0 <_Z4itoaiPcj+0x168>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:31 (discriminator 1)
	{
		char c = output[i - j];
    8860:	e51b2008 	ldr	r2, [fp, #-8]
    8864:	e51b300c 	ldr	r3, [fp, #-12]
    8868:	e0423003 	sub	r3, r2, r3
    886c:	e1a02003 	mov	r2, r3
    8870:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8874:	e0833002 	add	r3, r3, r2
    8878:	e5d33000 	ldrb	r3, [r3]
    887c:	e54b300d 	strb	r3, [fp, #-13]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:32 (discriminator 1)
		output[i - j] = output[j];
    8880:	e51b300c 	ldr	r3, [fp, #-12]
    8884:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8888:	e0822003 	add	r2, r2, r3
    888c:	e51b1008 	ldr	r1, [fp, #-8]
    8890:	e51b300c 	ldr	r3, [fp, #-12]
    8894:	e0413003 	sub	r3, r1, r3
    8898:	e1a01003 	mov	r1, r3
    889c:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    88a0:	e0833001 	add	r3, r3, r1
    88a4:	e5d22000 	ldrb	r2, [r2]
    88a8:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:33 (discriminator 1)
		output[j] = c;
    88ac:	e51b300c 	ldr	r3, [fp, #-12]
    88b0:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    88b4:	e0823003 	add	r3, r2, r3
    88b8:	e55b200d 	ldrb	r2, [fp, #-13]
    88bc:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:29 (discriminator 1)
	for (j; j <= i/2; j++)
    88c0:	e51b300c 	ldr	r3, [fp, #-12]
    88c4:	e2833001 	add	r3, r3, #1
    88c8:	e50b300c 	str	r3, [fp, #-12]
    88cc:	eaffffdb 	b	8840 <_Z4itoaiPcj+0xd8>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:36
	}

}
    88d0:	e320f000 	nop	{0}
    88d4:	e24bd004 	sub	sp, fp, #4
    88d8:	e8bd8800 	pop	{fp, pc}
    88dc:	00009b14 	andeq	r9, r0, r4, lsl fp

000088e0 <_Z4atoiPKc>:
_Z4atoiPKc():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:39

int atoi(const char* input)
{
    88e0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    88e4:	e28db000 	add	fp, sp, #0
    88e8:	e24dd014 	sub	sp, sp, #20
    88ec:	e50b0010 	str	r0, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:40
	int output = 0;
    88f0:	e3a03000 	mov	r3, #0
    88f4:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:42

	while (*input != '\0')
    88f8:	e51b3010 	ldr	r3, [fp, #-16]
    88fc:	e5d33000 	ldrb	r3, [r3]
    8900:	e3530000 	cmp	r3, #0
    8904:	0a000017 	beq	8968 <_Z4atoiPKc+0x88>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:44
	{
		output *= 10;
    8908:	e51b2008 	ldr	r2, [fp, #-8]
    890c:	e1a03002 	mov	r3, r2
    8910:	e1a03103 	lsl	r3, r3, #2
    8914:	e0833002 	add	r3, r3, r2
    8918:	e1a03083 	lsl	r3, r3, #1
    891c:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:45
		if (*input > '9' || *input < '0')
    8920:	e51b3010 	ldr	r3, [fp, #-16]
    8924:	e5d33000 	ldrb	r3, [r3]
    8928:	e3530039 	cmp	r3, #57	; 0x39
    892c:	8a00000d 	bhi	8968 <_Z4atoiPKc+0x88>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:45 (discriminator 1)
    8930:	e51b3010 	ldr	r3, [fp, #-16]
    8934:	e5d33000 	ldrb	r3, [r3]
    8938:	e353002f 	cmp	r3, #47	; 0x2f
    893c:	9a000009 	bls	8968 <_Z4atoiPKc+0x88>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:48
			break;

		output += *input - '0';
    8940:	e51b3010 	ldr	r3, [fp, #-16]
    8944:	e5d33000 	ldrb	r3, [r3]
    8948:	e2433030 	sub	r3, r3, #48	; 0x30
    894c:	e51b2008 	ldr	r2, [fp, #-8]
    8950:	e0823003 	add	r3, r2, r3
    8954:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:50

		input++;
    8958:	e51b3010 	ldr	r3, [fp, #-16]
    895c:	e2833001 	add	r3, r3, #1
    8960:	e50b3010 	str	r3, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:42
	while (*input != '\0')
    8964:	eaffffe3 	b	88f8 <_Z4atoiPKc+0x18>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:53
	}

	return output;
    8968:	e51b3008 	ldr	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:54
}
    896c:	e1a00003 	mov	r0, r3
    8970:	e28bd000 	add	sp, fp, #0
    8974:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8978:	e12fff1e 	bx	lr

0000897c <_Z14get_input_typePKc>:
_Z14get_input_typePKc():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:58
//return 1 pokud int
//return 2 pokud float
//return 0 pokud neni cislo
int get_input_type(const char * input){
    897c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8980:	e28db000 	add	fp, sp, #0
    8984:	e24dd014 	sub	sp, sp, #20
    8988:	e50b0010 	str	r0, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:60
    //existence tecky
    bool dot = false;
    898c:	e3a03000 	mov	r3, #0
    8990:	e54b3005 	strb	r3, [fp, #-5]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:61
    bool trailing_dot = false;
    8994:	e3a03000 	mov	r3, #0
    8998:	e54b3006 	strb	r3, [fp, #-6]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:62
    while(*input != '\0'){
    899c:	e51b3010 	ldr	r3, [fp, #-16]
    89a0:	e5d33000 	ldrb	r3, [r3]
    89a4:	e3530000 	cmp	r3, #0
    89a8:	0a000023 	beq	8a3c <_Z14get_input_typePKc+0xc0>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:63
        char c = *input;
    89ac:	e51b3010 	ldr	r3, [fp, #-16]
    89b0:	e5d33000 	ldrb	r3, [r3]
    89b4:	e54b3007 	strb	r3, [fp, #-7]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:64
        if(c == '.' && !dot){
    89b8:	e55b3007 	ldrb	r3, [fp, #-7]
    89bc:	e353002e 	cmp	r3, #46	; 0x2e
    89c0:	1a00000c 	bne	89f8 <_Z14get_input_typePKc+0x7c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:64 (discriminator 1)
    89c4:	e55b3005 	ldrb	r3, [fp, #-5]
    89c8:	e2233001 	eor	r3, r3, #1
    89cc:	e6ef3073 	uxtb	r3, r3
    89d0:	e3530000 	cmp	r3, #0
    89d4:	0a000007 	beq	89f8 <_Z14get_input_typePKc+0x7c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:65 (discriminator 2)
            dot = true;
    89d8:	e3a03001 	mov	r3, #1
    89dc:	e54b3005 	strb	r3, [fp, #-5]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:66 (discriminator 2)
            trailing_dot = true;
    89e0:	e3a03001 	mov	r3, #1
    89e4:	e54b3006 	strb	r3, [fp, #-6]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:67 (discriminator 2)
            input++;
    89e8:	e51b3010 	ldr	r3, [fp, #-16]
    89ec:	e2833001 	add	r3, r3, #1
    89f0:	e50b3010 	str	r3, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:68 (discriminator 2)
            continue;
    89f4:	ea00000f 	b	8a38 <_Z14get_input_typePKc+0xbc>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:71
        }
        //nenumericky znak
        if(c < '0' || c > '9')return 0;
    89f8:	e55b3007 	ldrb	r3, [fp, #-7]
    89fc:	e353002f 	cmp	r3, #47	; 0x2f
    8a00:	9a000002 	bls	8a10 <_Z14get_input_typePKc+0x94>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:71 (discriminator 2)
    8a04:	e55b3007 	ldrb	r3, [fp, #-7]
    8a08:	e3530039 	cmp	r3, #57	; 0x39
    8a0c:	9a000001 	bls	8a18 <_Z14get_input_typePKc+0x9c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:71 (discriminator 3)
    8a10:	e3a03000 	mov	r3, #0
    8a14:	ea000014 	b	8a6c <_Z14get_input_typePKc+0xf0>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:73
        //retezec obsahuje tecku a numericke znaky -> tecka je "validni", tedy neni to tecka na konci intu napriklad
        if(dot)
    8a18:	e55b3005 	ldrb	r3, [fp, #-5]
    8a1c:	e3530000 	cmp	r3, #0
    8a20:	0a000001 	beq	8a2c <_Z14get_input_typePKc+0xb0>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:74
            trailing_dot = false;
    8a24:	e3a03000 	mov	r3, #0
    8a28:	e54b3006 	strb	r3, [fp, #-6]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:75
    input++;
    8a2c:	e51b3010 	ldr	r3, [fp, #-16]
    8a30:	e2833001 	add	r3, r3, #1
    8a34:	e50b3010 	str	r3, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:62
    while(*input != '\0'){
    8a38:	eaffffd7 	b	899c <_Z14get_input_typePKc+0x20>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:77
    }
    if(trailing_dot)return 0;
    8a3c:	e55b3006 	ldrb	r3, [fp, #-6]
    8a40:	e3530000 	cmp	r3, #0
    8a44:	0a000001 	beq	8a50 <_Z14get_input_typePKc+0xd4>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:77 (discriminator 1)
    8a48:	e3a03000 	mov	r3, #0
    8a4c:	ea000006 	b	8a6c <_Z14get_input_typePKc+0xf0>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:79
    //float pokud retezec obsahuje non-trailing tecku, 1 pokud je to int
    return dot? 2:1;
    8a50:	e55b3005 	ldrb	r3, [fp, #-5]
    8a54:	e3530000 	cmp	r3, #0
    8a58:	0a000001 	beq	8a64 <_Z14get_input_typePKc+0xe8>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:79 (discriminator 1)
    8a5c:	e3a03002 	mov	r3, #2
    8a60:	ea000000 	b	8a68 <_Z14get_input_typePKc+0xec>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:79 (discriminator 2)
    8a64:	e3a03001 	mov	r3, #1
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:79
    8a68:	e320f000 	nop	{0}
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:81

}
    8a6c:	e1a00003 	mov	r0, r3
    8a70:	e28bd000 	add	sp, fp, #0
    8a74:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8a78:	e12fff1e 	bx	lr

00008a7c <_Z4atofPKc>:
_Z4atofPKc():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:85


//string to float
float atof(const char* input){
    8a7c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8a80:	e28db000 	add	fp, sp, #0
    8a84:	e24dd03c 	sub	sp, sp, #60	; 0x3c
    8a88:	e50b0038 	str	r0, [fp, #-56]	; 0xffffffc8
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:86
    double output = 0.0;
    8a8c:	e3a02000 	mov	r2, #0
    8a90:	e3a03000 	mov	r3, #0
    8a94:	e14b20fc 	strd	r2, [fp, #-12]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:87
    double factor = 10;
    8a98:	e3a02000 	mov	r2, #0
    8a9c:	e59f312c 	ldr	r3, [pc, #300]	; 8bd0 <_Z4atofPKc+0x154>
    8aa0:	e14b21fc 	strd	r2, [fp, #-28]	; 0xffffffe4
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:89
    //cast za desetinnou carkou
    double tmp = 0.0;
    8aa4:	e3a02000 	mov	r2, #0
    8aa8:	e3a03000 	mov	r3, #0
    8aac:	e14b22f4 	strd	r2, [fp, #-36]	; 0xffffffdc
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:90
    int counter = 0;
    8ab0:	e3a03000 	mov	r3, #0
    8ab4:	e50b3028 	str	r3, [fp, #-40]	; 0xffffffd8
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:91
    int scale = 1;
    8ab8:	e3a03001 	mov	r3, #1
    8abc:	e50b3010 	str	r3, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:92
    bool afterDecPoint = false;
    8ac0:	e3a03000 	mov	r3, #0
    8ac4:	e54b3011 	strb	r3, [fp, #-17]	; 0xffffffef
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:94

    while(*input != '\0'){
    8ac8:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    8acc:	e5d33000 	ldrb	r3, [r3]
    8ad0:	e3530000 	cmp	r3, #0
    8ad4:	0a000034 	beq	8bac <_Z4atofPKc+0x130>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:95
        if (*input == '.'){
    8ad8:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    8adc:	e5d33000 	ldrb	r3, [r3]
    8ae0:	e353002e 	cmp	r3, #46	; 0x2e
    8ae4:	1a000005 	bne	8b00 <_Z4atofPKc+0x84>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:96 (discriminator 1)
            afterDecPoint = true;
    8ae8:	e3a03001 	mov	r3, #1
    8aec:	e54b3011 	strb	r3, [fp, #-17]	; 0xffffffef
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:97 (discriminator 1)
            input++;
    8af0:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    8af4:	e2833001 	add	r3, r3, #1
    8af8:	e50b3038 	str	r3, [fp, #-56]	; 0xffffffc8
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:98 (discriminator 1)
            continue;
    8afc:	ea000029 	b	8ba8 <_Z4atofPKc+0x12c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:100
        }
        else if (*input > '9' || *input < '0')break;
    8b00:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    8b04:	e5d33000 	ldrb	r3, [r3]
    8b08:	e3530039 	cmp	r3, #57	; 0x39
    8b0c:	8a000026 	bhi	8bac <_Z4atofPKc+0x130>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:100 (discriminator 1)
    8b10:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    8b14:	e5d33000 	ldrb	r3, [r3]
    8b18:	e353002f 	cmp	r3, #47	; 0x2f
    8b1c:	9a000022 	bls	8bac <_Z4atofPKc+0x130>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:101
        double val = *input - '0';
    8b20:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    8b24:	e5d33000 	ldrb	r3, [r3]
    8b28:	e2433030 	sub	r3, r3, #48	; 0x30
    8b2c:	ee073a90 	vmov	s15, r3
    8b30:	eeb87be7 	vcvt.f64.s32	d7, s15
    8b34:	ed0b7b0d 	vstr	d7, [fp, #-52]	; 0xffffffcc
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:102
        if(afterDecPoint){
    8b38:	e55b3011 	ldrb	r3, [fp, #-17]	; 0xffffffef
    8b3c:	e3530000 	cmp	r3, #0
    8b40:	0a00000f 	beq	8b84 <_Z4atofPKc+0x108>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:103
            scale /= 10;
    8b44:	e51b3010 	ldr	r3, [fp, #-16]
    8b48:	e59f2084 	ldr	r2, [pc, #132]	; 8bd4 <_Z4atofPKc+0x158>
    8b4c:	e0c21392 	smull	r1, r2, r2, r3
    8b50:	e1a02142 	asr	r2, r2, #2
    8b54:	e1a03fc3 	asr	r3, r3, #31
    8b58:	e0423003 	sub	r3, r2, r3
    8b5c:	e50b3010 	str	r3, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:104
            output = output + val * scale;
    8b60:	e51b3010 	ldr	r3, [fp, #-16]
    8b64:	ee073a90 	vmov	s15, r3
    8b68:	eeb86be7 	vcvt.f64.s32	d6, s15
    8b6c:	ed1b7b0d 	vldr	d7, [fp, #-52]	; 0xffffffcc
    8b70:	ee267b07 	vmul.f64	d7, d6, d7
    8b74:	ed1b6b03 	vldr	d6, [fp, #-12]
    8b78:	ee367b07 	vadd.f64	d7, d6, d7
    8b7c:	ed0b7b03 	vstr	d7, [fp, #-12]
    8b80:	ea000005 	b	8b9c <_Z4atofPKc+0x120>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:107
        }
        else
            output = output * 10 + val;
    8b84:	ed1b7b03 	vldr	d7, [fp, #-12]
    8b88:	ed9f6b0e 	vldr	d6, [pc, #56]	; 8bc8 <_Z4atofPKc+0x14c>
    8b8c:	ee277b06 	vmul.f64	d7, d7, d6
    8b90:	ed1b6b0d 	vldr	d6, [fp, #-52]	; 0xffffffcc
    8b94:	ee367b07 	vadd.f64	d7, d6, d7
    8b98:	ed0b7b03 	vstr	d7, [fp, #-12]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:109

        input++;
    8b9c:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    8ba0:	e2833001 	add	r3, r3, #1
    8ba4:	e50b3038 	str	r3, [fp, #-56]	; 0xffffffc8
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:94
    while(*input != '\0'){
    8ba8:	eaffffc6 	b	8ac8 <_Z4atofPKc+0x4c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:111
    }
    return output;
    8bac:	ed1b7b03 	vldr	d7, [fp, #-12]
    8bb0:	eef77bc7 	vcvt.f32.f64	s15, d7
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:112
}
    8bb4:	eeb00a67 	vmov.f32	s0, s15
    8bb8:	e28bd000 	add	sp, fp, #0
    8bbc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8bc0:	e12fff1e 	bx	lr
    8bc4:	e320f000 	nop	{0}
    8bc8:	00000000 	andeq	r0, r0, r0
    8bcc:	40240000 	eormi	r0, r4, r0
    8bd0:	40240000 	eormi	r0, r4, r0
    8bd4:	66666667 	strbtvs	r6, [r6], -r7, ror #12

00008bd8 <_Z7strncpyPcPKci>:
_Z7strncpyPcPKci():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:114
char* strncpy(char* dest, const char *src, int num)
{
    8bd8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8bdc:	e28db000 	add	fp, sp, #0
    8be0:	e24dd01c 	sub	sp, sp, #28
    8be4:	e50b0010 	str	r0, [fp, #-16]
    8be8:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8bec:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:117
	int i;

	for (i = 0; i < num && src[i] != '\0'; i++)
    8bf0:	e3a03000 	mov	r3, #0
    8bf4:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:117 (discriminator 4)
    8bf8:	e51b2008 	ldr	r2, [fp, #-8]
    8bfc:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8c00:	e1520003 	cmp	r2, r3
    8c04:	aa000011 	bge	8c50 <_Z7strncpyPcPKci+0x78>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:117 (discriminator 2)
    8c08:	e51b3008 	ldr	r3, [fp, #-8]
    8c0c:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    8c10:	e0823003 	add	r3, r2, r3
    8c14:	e5d33000 	ldrb	r3, [r3]
    8c18:	e3530000 	cmp	r3, #0
    8c1c:	0a00000b 	beq	8c50 <_Z7strncpyPcPKci+0x78>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:118 (discriminator 3)
		dest[i] = src[i];
    8c20:	e51b3008 	ldr	r3, [fp, #-8]
    8c24:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    8c28:	e0822003 	add	r2, r2, r3
    8c2c:	e51b3008 	ldr	r3, [fp, #-8]
    8c30:	e51b1010 	ldr	r1, [fp, #-16]
    8c34:	e0813003 	add	r3, r1, r3
    8c38:	e5d22000 	ldrb	r2, [r2]
    8c3c:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:117 (discriminator 3)
	for (i = 0; i < num && src[i] != '\0'; i++)
    8c40:	e51b3008 	ldr	r3, [fp, #-8]
    8c44:	e2833001 	add	r3, r3, #1
    8c48:	e50b3008 	str	r3, [fp, #-8]
    8c4c:	eaffffe9 	b	8bf8 <_Z7strncpyPcPKci+0x20>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:119 (discriminator 2)
	for (; i < num; i++)
    8c50:	e51b2008 	ldr	r2, [fp, #-8]
    8c54:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8c58:	e1520003 	cmp	r2, r3
    8c5c:	aa000008 	bge	8c84 <_Z7strncpyPcPKci+0xac>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:120 (discriminator 1)
		dest[i] = '\0';
    8c60:	e51b3008 	ldr	r3, [fp, #-8]
    8c64:	e51b2010 	ldr	r2, [fp, #-16]
    8c68:	e0823003 	add	r3, r2, r3
    8c6c:	e3a02000 	mov	r2, #0
    8c70:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:119 (discriminator 1)
	for (; i < num; i++)
    8c74:	e51b3008 	ldr	r3, [fp, #-8]
    8c78:	e2833001 	add	r3, r3, #1
    8c7c:	e50b3008 	str	r3, [fp, #-8]
    8c80:	eafffff2 	b	8c50 <_Z7strncpyPcPKci+0x78>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:122

   return dest;
    8c84:	e51b3010 	ldr	r3, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:123
}
    8c88:	e1a00003 	mov	r0, r3
    8c8c:	e28bd000 	add	sp, fp, #0
    8c90:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8c94:	e12fff1e 	bx	lr

00008c98 <_Z7strncmpPKcS0_i>:
_Z7strncmpPKcS0_i():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:126

int strncmp(const char *s1, const char *s2, int num)
{
    8c98:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8c9c:	e28db000 	add	fp, sp, #0
    8ca0:	e24dd01c 	sub	sp, sp, #28
    8ca4:	e50b0010 	str	r0, [fp, #-16]
    8ca8:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8cac:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:128
	unsigned char u1, u2;
  	while (num-- > 0)
    8cb0:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8cb4:	e2432001 	sub	r2, r3, #1
    8cb8:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
    8cbc:	e3530000 	cmp	r3, #0
    8cc0:	c3a03001 	movgt	r3, #1
    8cc4:	d3a03000 	movle	r3, #0
    8cc8:	e6ef3073 	uxtb	r3, r3
    8ccc:	e3530000 	cmp	r3, #0
    8cd0:	0a000016 	beq	8d30 <_Z7strncmpPKcS0_i+0x98>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:130
    {
      	u1 = (unsigned char) *s1++;
    8cd4:	e51b3010 	ldr	r3, [fp, #-16]
    8cd8:	e2832001 	add	r2, r3, #1
    8cdc:	e50b2010 	str	r2, [fp, #-16]
    8ce0:	e5d33000 	ldrb	r3, [r3]
    8ce4:	e54b3005 	strb	r3, [fp, #-5]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:131
     	u2 = (unsigned char) *s2++;
    8ce8:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8cec:	e2832001 	add	r2, r3, #1
    8cf0:	e50b2014 	str	r2, [fp, #-20]	; 0xffffffec
    8cf4:	e5d33000 	ldrb	r3, [r3]
    8cf8:	e54b3006 	strb	r3, [fp, #-6]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:132
      	if (u1 != u2)
    8cfc:	e55b2005 	ldrb	r2, [fp, #-5]
    8d00:	e55b3006 	ldrb	r3, [fp, #-6]
    8d04:	e1520003 	cmp	r2, r3
    8d08:	0a000003 	beq	8d1c <_Z7strncmpPKcS0_i+0x84>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:133
        	return u1 - u2;
    8d0c:	e55b2005 	ldrb	r2, [fp, #-5]
    8d10:	e55b3006 	ldrb	r3, [fp, #-6]
    8d14:	e0423003 	sub	r3, r2, r3
    8d18:	ea000005 	b	8d34 <_Z7strncmpPKcS0_i+0x9c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:134
      	if (u1 == '\0')
    8d1c:	e55b3005 	ldrb	r3, [fp, #-5]
    8d20:	e3530000 	cmp	r3, #0
    8d24:	1affffe1 	bne	8cb0 <_Z7strncmpPKcS0_i+0x18>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:135
        	return 0;
    8d28:	e3a03000 	mov	r3, #0
    8d2c:	ea000000 	b	8d34 <_Z7strncmpPKcS0_i+0x9c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:138
    }

  	return 0;
    8d30:	e3a03000 	mov	r3, #0
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:139
}
    8d34:	e1a00003 	mov	r0, r3
    8d38:	e28bd000 	add	sp, fp, #0
    8d3c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8d40:	e12fff1e 	bx	lr

00008d44 <_Z6strlenPKc>:
_Z6strlenPKc():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:142

int strlen(const char* s)
{
    8d44:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8d48:	e28db000 	add	fp, sp, #0
    8d4c:	e24dd014 	sub	sp, sp, #20
    8d50:	e50b0010 	str	r0, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:143
	int i = 0;
    8d54:	e3a03000 	mov	r3, #0
    8d58:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:145

	while (s[i] != '\0')
    8d5c:	e51b3008 	ldr	r3, [fp, #-8]
    8d60:	e51b2010 	ldr	r2, [fp, #-16]
    8d64:	e0823003 	add	r3, r2, r3
    8d68:	e5d33000 	ldrb	r3, [r3]
    8d6c:	e3530000 	cmp	r3, #0
    8d70:	0a000003 	beq	8d84 <_Z6strlenPKc+0x40>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:146
		i++;
    8d74:	e51b3008 	ldr	r3, [fp, #-8]
    8d78:	e2833001 	add	r3, r3, #1
    8d7c:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:145
	while (s[i] != '\0')
    8d80:	eafffff5 	b	8d5c <_Z6strlenPKc+0x18>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:148

	return i;
    8d84:	e51b3008 	ldr	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:149
}
    8d88:	e1a00003 	mov	r0, r3
    8d8c:	e28bd000 	add	sp, fp, #0
    8d90:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8d94:	e12fff1e 	bx	lr

00008d98 <_Z6strcatPcPKc>:
_Z6strcatPcPKc():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:152
//unsafe varianta
//muze nastat buffer overflow attack
char* strcat(char* dest, const char* src){
    8d98:	e92d4800 	push	{fp, lr}
    8d9c:	e28db004 	add	fp, sp, #4
    8da0:	e24dd018 	sub	sp, sp, #24
    8da4:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    8da8:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:153
    int n = strlen(src);
    8dac:	e51b001c 	ldr	r0, [fp, #-28]	; 0xffffffe4
    8db0:	ebffffe3 	bl	8d44 <_Z6strlenPKc>
    8db4:	e50b0010 	str	r0, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:154
    int m = strlen(dest);
    8db8:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    8dbc:	ebffffe0 	bl	8d44 <_Z6strlenPKc>
    8dc0:	e50b0008 	str	r0, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:155
    int walker = 0;
    8dc4:	e3a03000 	mov	r3, #0
    8dc8:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:156
    for(int i = 0;i < n; i++)
    8dcc:	e3a03000 	mov	r3, #0
    8dd0:	e50b300c 	str	r3, [fp, #-12]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:156 (discriminator 3)
    8dd4:	e51b200c 	ldr	r2, [fp, #-12]
    8dd8:	e51b3010 	ldr	r3, [fp, #-16]
    8ddc:	e1520003 	cmp	r2, r3
    8de0:	aa00000e 	bge	8e20 <_Z6strcatPcPKc+0x88>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:157 (discriminator 2)
        dest[m++] = src[i];
    8de4:	e51b300c 	ldr	r3, [fp, #-12]
    8de8:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8dec:	e0822003 	add	r2, r2, r3
    8df0:	e51b3008 	ldr	r3, [fp, #-8]
    8df4:	e2831001 	add	r1, r3, #1
    8df8:	e50b1008 	str	r1, [fp, #-8]
    8dfc:	e1a01003 	mov	r1, r3
    8e00:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8e04:	e0833001 	add	r3, r3, r1
    8e08:	e5d22000 	ldrb	r2, [r2]
    8e0c:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:156 (discriminator 2)
    for(int i = 0;i < n; i++)
    8e10:	e51b300c 	ldr	r3, [fp, #-12]
    8e14:	e2833001 	add	r3, r3, #1
    8e18:	e50b300c 	str	r3, [fp, #-12]
    8e1c:	eaffffec 	b	8dd4 <_Z6strcatPcPKc+0x3c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:158
    dest[m] = '\0';
    8e20:	e51b3008 	ldr	r3, [fp, #-8]
    8e24:	e51b2018 	ldr	r2, [fp, #-24]	; 0xffffffe8
    8e28:	e0823003 	add	r3, r2, r3
    8e2c:	e3a02000 	mov	r2, #0
    8e30:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:159
    return dest;
    8e34:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:161

}
    8e38:	e1a00003 	mov	r0, r3
    8e3c:	e24bd004 	sub	sp, fp, #4
    8e40:	e8bd8800 	pop	{fp, pc}

00008e44 <_Z7strncatPcPKci>:
_Z7strncatPcPKci():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:162
char* strncat(char* dest, const char* src,int size){
    8e44:	e92d4800 	push	{fp, lr}
    8e48:	e28db004 	add	fp, sp, #4
    8e4c:	e24dd020 	sub	sp, sp, #32
    8e50:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    8e54:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    8e58:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:163
    int walker = 0;
    8e5c:	e3a03000 	mov	r3, #0
    8e60:	e50b3010 	str	r3, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:165
    //najdi odkud muzeme kopirovat, tedy konec retezce
    int m = strlen(dest);
    8e64:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    8e68:	ebffffb5 	bl	8d44 <_Z6strlenPKc>
    8e6c:	e50b0008 	str	r0, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:167
    //nevejdu se
    if(m >= size)return dest;
    8e70:	e51b2008 	ldr	r2, [fp, #-8]
    8e74:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8e78:	e1520003 	cmp	r2, r3
    8e7c:	ba000001 	blt	8e88 <_Z7strncatPcPKci+0x44>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:167 (discriminator 1)
    8e80:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8e84:	ea000021 	b	8f10 <_Z7strncatPcPKci+0xcc>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:169

    for(int i = 0;i < size; i++){
    8e88:	e3a03000 	mov	r3, #0
    8e8c:	e50b300c 	str	r3, [fp, #-12]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:169 (discriminator 1)
    8e90:	e51b200c 	ldr	r2, [fp, #-12]
    8e94:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8e98:	e1520003 	cmp	r2, r3
    8e9c:	aa000015 	bge	8ef8 <_Z7strncatPcPKci+0xb4>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:170
        if(src[i] == '\0')break;
    8ea0:	e51b300c 	ldr	r3, [fp, #-12]
    8ea4:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8ea8:	e0823003 	add	r3, r2, r3
    8eac:	e5d33000 	ldrb	r3, [r3]
    8eb0:	e3530000 	cmp	r3, #0
    8eb4:	0a00000e 	beq	8ef4 <_Z7strncatPcPKci+0xb0>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:171 (discriminator 2)
        dest[m++] = src[i];
    8eb8:	e51b300c 	ldr	r3, [fp, #-12]
    8ebc:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8ec0:	e0822003 	add	r2, r2, r3
    8ec4:	e51b3008 	ldr	r3, [fp, #-8]
    8ec8:	e2831001 	add	r1, r3, #1
    8ecc:	e50b1008 	str	r1, [fp, #-8]
    8ed0:	e1a01003 	mov	r1, r3
    8ed4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8ed8:	e0833001 	add	r3, r3, r1
    8edc:	e5d22000 	ldrb	r2, [r2]
    8ee0:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:169 (discriminator 2)
    for(int i = 0;i < size; i++){
    8ee4:	e51b300c 	ldr	r3, [fp, #-12]
    8ee8:	e2833001 	add	r3, r3, #1
    8eec:	e50b300c 	str	r3, [fp, #-12]
    8ef0:	eaffffe6 	b	8e90 <_Z7strncatPcPKci+0x4c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:170
        if(src[i] == '\0')break;
    8ef4:	e320f000 	nop	{0}
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:173
    }
    dest[m] = '\0';
    8ef8:	e51b3008 	ldr	r3, [fp, #-8]
    8efc:	e51b2018 	ldr	r2, [fp, #-24]	; 0xffffffe8
    8f00:	e0823003 	add	r3, r2, r3
    8f04:	e3a02000 	mov	r2, #0
    8f08:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:174
    return dest;
    8f0c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:176

}
    8f10:	e1a00003 	mov	r0, r3
    8f14:	e24bd004 	sub	sp, fp, #4
    8f18:	e8bd8800 	pop	{fp, pc}

00008f1c <_Z5bzeroPvi>:
_Z5bzeroPvi():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:180


void bzero(void* memory, int length)
{
    8f1c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8f20:	e28db000 	add	fp, sp, #0
    8f24:	e24dd014 	sub	sp, sp, #20
    8f28:	e50b0010 	str	r0, [fp, #-16]
    8f2c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:181
	char* mem = reinterpret_cast<char*>(memory);
    8f30:	e51b3010 	ldr	r3, [fp, #-16]
    8f34:	e50b300c 	str	r3, [fp, #-12]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:183

	for (int i = 0; i < length; i++)
    8f38:	e3a03000 	mov	r3, #0
    8f3c:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:183 (discriminator 3)
    8f40:	e51b2008 	ldr	r2, [fp, #-8]
    8f44:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8f48:	e1520003 	cmp	r2, r3
    8f4c:	aa000008 	bge	8f74 <_Z5bzeroPvi+0x58>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:184 (discriminator 2)
		mem[i] = 0;
    8f50:	e51b3008 	ldr	r3, [fp, #-8]
    8f54:	e51b200c 	ldr	r2, [fp, #-12]
    8f58:	e0823003 	add	r3, r2, r3
    8f5c:	e3a02000 	mov	r2, #0
    8f60:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:183 (discriminator 2)
	for (int i = 0; i < length; i++)
    8f64:	e51b3008 	ldr	r3, [fp, #-8]
    8f68:	e2833001 	add	r3, r3, #1
    8f6c:	e50b3008 	str	r3, [fp, #-8]
    8f70:	eafffff2 	b	8f40 <_Z5bzeroPvi+0x24>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:185
}
    8f74:	e320f000 	nop	{0}
    8f78:	e28bd000 	add	sp, fp, #0
    8f7c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8f80:	e12fff1e 	bx	lr

00008f84 <_Z6memcpyPKvPvi>:
_Z6memcpyPKvPvi():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:188

void memcpy(const void* src, void* dst, int num)
{
    8f84:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8f88:	e28db000 	add	fp, sp, #0
    8f8c:	e24dd024 	sub	sp, sp, #36	; 0x24
    8f90:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    8f94:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    8f98:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:189
	const char* memsrc = reinterpret_cast<const char*>(src);
    8f9c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8fa0:	e50b300c 	str	r3, [fp, #-12]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:190
	char* memdst = reinterpret_cast<char*>(dst);
    8fa4:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8fa8:	e50b3010 	str	r3, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:192

	for (int i = 0; i < num; i++)
    8fac:	e3a03000 	mov	r3, #0
    8fb0:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:192 (discriminator 3)
    8fb4:	e51b2008 	ldr	r2, [fp, #-8]
    8fb8:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8fbc:	e1520003 	cmp	r2, r3
    8fc0:	aa00000b 	bge	8ff4 <_Z6memcpyPKvPvi+0x70>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:193 (discriminator 2)
		memdst[i] = memsrc[i];
    8fc4:	e51b3008 	ldr	r3, [fp, #-8]
    8fc8:	e51b200c 	ldr	r2, [fp, #-12]
    8fcc:	e0822003 	add	r2, r2, r3
    8fd0:	e51b3008 	ldr	r3, [fp, #-8]
    8fd4:	e51b1010 	ldr	r1, [fp, #-16]
    8fd8:	e0813003 	add	r3, r1, r3
    8fdc:	e5d22000 	ldrb	r2, [r2]
    8fe0:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:192 (discriminator 2)
	for (int i = 0; i < num; i++)
    8fe4:	e51b3008 	ldr	r3, [fp, #-8]
    8fe8:	e2833001 	add	r3, r3, #1
    8fec:	e50b3008 	str	r3, [fp, #-8]
    8ff0:	eaffffef 	b	8fb4 <_Z6memcpyPKvPvi+0x30>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:194
}
    8ff4:	e320f000 	nop	{0}
    8ff8:	e28bd000 	add	sp, fp, #0
    8ffc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9000:	e12fff1e 	bx	lr

00009004 <_Z4n_tuii>:
_Z4n_tuii():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:199



int n_tu(int number, int count)
{
    9004:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9008:	e28db000 	add	fp, sp, #0
    900c:	e24dd014 	sub	sp, sp, #20
    9010:	e50b0010 	str	r0, [fp, #-16]
    9014:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:200
    int result = 1;
    9018:	e3a03001 	mov	r3, #1
    901c:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:201
    while(count-- > 0)
    9020:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9024:	e2432001 	sub	r2, r3, #1
    9028:	e50b2014 	str	r2, [fp, #-20]	; 0xffffffec
    902c:	e3530000 	cmp	r3, #0
    9030:	c3a03001 	movgt	r3, #1
    9034:	d3a03000 	movle	r3, #0
    9038:	e6ef3073 	uxtb	r3, r3
    903c:	e3530000 	cmp	r3, #0
    9040:	0a000004 	beq	9058 <_Z4n_tuii+0x54>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:202
        result *= number;
    9044:	e51b3008 	ldr	r3, [fp, #-8]
    9048:	e51b2010 	ldr	r2, [fp, #-16]
    904c:	e0030392 	mul	r3, r2, r3
    9050:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:201
    while(count-- > 0)
    9054:	eafffff1 	b	9020 <_Z4n_tuii+0x1c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:204

    return result;
    9058:	e51b3008 	ldr	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:205
}
    905c:	e1a00003 	mov	r0, r3
    9060:	e28bd000 	add	sp, fp, #0
    9064:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9068:	e12fff1e 	bx	lr

0000906c <_Z4ftoafPc>:
_Z4ftoafPc():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:209

/*** Convert float to string ***/
void ftoa(float f, char r[])
{
    906c:	e92d4bf0 	push	{r4, r5, r6, r7, r8, r9, fp, lr}
    9070:	e28db01c 	add	fp, sp, #28
    9074:	e24dd068 	sub	sp, sp, #104	; 0x68
    9078:	ed0b0a16 	vstr	s0, [fp, #-88]	; 0xffffffa8
    907c:	e50b005c 	str	r0, [fp, #-92]	; 0xffffffa4
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:213
    long long int length, length2, i, number, position, sign;
    float number2;

    sign = -1;   // -1 == positive number
    9080:	e3e02000 	mvn	r2, #0
    9084:	e3e03000 	mvn	r3, #0
    9088:	e14b24fc 	strd	r2, [fp, #-76]	; 0xffffffb4
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:214
    if (f < 0)
    908c:	ed5b7a16 	vldr	s15, [fp, #-88]	; 0xffffffa8
    9090:	eef57ac0 	vcmpe.f32	s15, #0.0
    9094:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    9098:	5a000005 	bpl	90b4 <_Z4ftoafPc+0x48>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:216
    {
        sign = '-';
    909c:	e3a0202d 	mov	r2, #45	; 0x2d
    90a0:	e3a03000 	mov	r3, #0
    90a4:	e14b24fc 	strd	r2, [fp, #-76]	; 0xffffffb4
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:217
        f *= -1;
    90a8:	ed5b7a16 	vldr	s15, [fp, #-88]	; 0xffffffa8
    90ac:	eef17a67 	vneg.f32	s15, s15
    90b0:	ed4b7a16 	vstr	s15, [fp, #-88]	; 0xffffffa8
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:220
    }

    number2 = f;
    90b4:	e51b3058 	ldr	r3, [fp, #-88]	; 0xffffffa8
    90b8:	e50b3050 	str	r3, [fp, #-80]	; 0xffffffb0
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:221
    number = f;
    90bc:	e51b0058 	ldr	r0, [fp, #-88]	; 0xffffffa8
    90c0:	eb000200 	bl	98c8 <__aeabi_f2lz>
    90c4:	e1a02000 	mov	r2, r0
    90c8:	e1a03001 	mov	r3, r1
    90cc:	e14b23fc 	strd	r2, [fp, #-60]	; 0xffffffc4
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:222
    length = 0;  // Size of decimal part
    90d0:	e3a02000 	mov	r2, #0
    90d4:	e3a03000 	mov	r3, #0
    90d8:	e14b22f4 	strd	r2, [fp, #-36]	; 0xffffffdc
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:223
    length2 = 0; // Size of tenth
    90dc:	e3a02000 	mov	r2, #0
    90e0:	e3a03000 	mov	r3, #0
    90e4:	e14b22fc 	strd	r2, [fp, #-44]	; 0xffffffd4
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:226

    /* Calculate length2 tenth part */
    while( (number2 - (float)number) != 0.0 && !((number2 - (float)number) < 0.0) )
    90e8:	e14b03dc 	ldrd	r0, [fp, #-60]	; 0xffffffc4
    90ec:	eb0001a1 	bl	9778 <__aeabi_l2f>
    90f0:	ee070a10 	vmov	s14, r0
    90f4:	ed5b7a14 	vldr	s15, [fp, #-80]	; 0xffffffb0
    90f8:	ee777ac7 	vsub.f32	s15, s15, s14
    90fc:	eef57a40 	vcmp.f32	s15, #0.0
    9100:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    9104:	0a00001b 	beq	9178 <_Z4ftoafPc+0x10c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:226 (discriminator 1)
    9108:	e14b03dc 	ldrd	r0, [fp, #-60]	; 0xffffffc4
    910c:	eb000199 	bl	9778 <__aeabi_l2f>
    9110:	ee070a10 	vmov	s14, r0
    9114:	ed5b7a14 	vldr	s15, [fp, #-80]	; 0xffffffb0
    9118:	ee777ac7 	vsub.f32	s15, s15, s14
    911c:	eef57ac0 	vcmpe.f32	s15, #0.0
    9120:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    9124:	4a000013 	bmi	9178 <_Z4ftoafPc+0x10c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:228
    {
        number2 = f * (n_tu(10.0, length2 + 1));
    9128:	e51b302c 	ldr	r3, [fp, #-44]	; 0xffffffd4
    912c:	e2833001 	add	r3, r3, #1
    9130:	e1a01003 	mov	r1, r3
    9134:	e3a0000a 	mov	r0, #10
    9138:	ebffffb1 	bl	9004 <_Z4n_tuii>
    913c:	ee070a90 	vmov	s15, r0
    9140:	eef87ae7 	vcvt.f32.s32	s15, s15
    9144:	ed1b7a16 	vldr	s14, [fp, #-88]	; 0xffffffa8
    9148:	ee677a27 	vmul.f32	s15, s14, s15
    914c:	ed4b7a14 	vstr	s15, [fp, #-80]	; 0xffffffb0
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:229
        number = number2;
    9150:	e51b0050 	ldr	r0, [fp, #-80]	; 0xffffffb0
    9154:	eb0001db 	bl	98c8 <__aeabi_f2lz>
    9158:	e1a02000 	mov	r2, r0
    915c:	e1a03001 	mov	r3, r1
    9160:	e14b23fc 	strd	r2, [fp, #-60]	; 0xffffffc4
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:231

        length2++;
    9164:	e14b22dc 	ldrd	r2, [fp, #-44]	; 0xffffffd4
    9168:	e2926001 	adds	r6, r2, #1
    916c:	e2a37000 	adc	r7, r3, #0
    9170:	e14b62fc 	strd	r6, [fp, #-44]	; 0xffffffd4
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:226
    while( (number2 - (float)number) != 0.0 && !((number2 - (float)number) < 0.0) )
    9174:	eaffffdb 	b	90e8 <_Z4ftoafPc+0x7c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:235
    }

    /* Calculate length decimal part */
    for (length = (f > 1) ? 0 : 1; f > 1; length++)
    9178:	ed5b7a16 	vldr	s15, [fp, #-88]	; 0xffffffa8
    917c:	ed9f7a82 	vldr	s14, [pc, #520]	; 938c <_Z4ftoafPc+0x320>
    9180:	eef47ac7 	vcmpe.f32	s15, s14
    9184:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    9188:	c3a03001 	movgt	r3, #1
    918c:	d3a03000 	movle	r3, #0
    9190:	e6ef3073 	uxtb	r3, r3
    9194:	e2233001 	eor	r3, r3, #1
    9198:	e6ef3073 	uxtb	r3, r3
    919c:	e6ef3073 	uxtb	r3, r3
    91a0:	e3a02000 	mov	r2, #0
    91a4:	e50b3064 	str	r3, [fp, #-100]	; 0xffffff9c
    91a8:	e50b2060 	str	r2, [fp, #-96]	; 0xffffffa0
    91ac:	e14b26d4 	ldrd	r2, [fp, #-100]	; 0xffffff9c
    91b0:	e14b22f4 	strd	r2, [fp, #-36]	; 0xffffffdc
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:235 (discriminator 3)
    91b4:	ed5b7a16 	vldr	s15, [fp, #-88]	; 0xffffffa8
    91b8:	ed9f7a73 	vldr	s14, [pc, #460]	; 938c <_Z4ftoafPc+0x320>
    91bc:	eef47ac7 	vcmpe.f32	s15, s14
    91c0:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    91c4:	da00000b 	ble	91f8 <_Z4ftoafPc+0x18c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:236 (discriminator 2)
        f /= 10;
    91c8:	ed1b7a16 	vldr	s14, [fp, #-88]	; 0xffffffa8
    91cc:	eddf6a6f 	vldr	s13, [pc, #444]	; 9390 <_Z4ftoafPc+0x324>
    91d0:	eec77a26 	vdiv.f32	s15, s14, s13
    91d4:	ed4b7a16 	vstr	s15, [fp, #-88]	; 0xffffffa8
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:235 (discriminator 2)
    for (length = (f > 1) ? 0 : 1; f > 1; length++)
    91d8:	e14b22d4 	ldrd	r2, [fp, #-36]	; 0xffffffdc
    91dc:	e2921001 	adds	r1, r2, #1
    91e0:	e50b106c 	str	r1, [fp, #-108]	; 0xffffff94
    91e4:	e2a33000 	adc	r3, r3, #0
    91e8:	e50b3068 	str	r3, [fp, #-104]	; 0xffffff98
    91ec:	e14b26dc 	ldrd	r2, [fp, #-108]	; 0xffffff94
    91f0:	e14b22f4 	strd	r2, [fp, #-36]	; 0xffffffdc
    91f4:	eaffffee 	b	91b4 <_Z4ftoafPc+0x148>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:238

    position = length;
    91f8:	e14b22d4 	ldrd	r2, [fp, #-36]	; 0xffffffdc
    91fc:	e14b24f4 	strd	r2, [fp, #-68]	; 0xffffffbc
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:239
    length = length + 1 + length2;
    9200:	e14b22d4 	ldrd	r2, [fp, #-36]	; 0xffffffdc
    9204:	e2924001 	adds	r4, r2, #1
    9208:	e2a35000 	adc	r5, r3, #0
    920c:	e14b22dc 	ldrd	r2, [fp, #-44]	; 0xffffffd4
    9210:	e0921004 	adds	r1, r2, r4
    9214:	e50b1074 	str	r1, [fp, #-116]	; 0xffffff8c
    9218:	e0a33005 	adc	r3, r3, r5
    921c:	e50b3070 	str	r3, [fp, #-112]	; 0xffffff90
    9220:	e14b27d4 	ldrd	r2, [fp, #-116]	; 0xffffff8c
    9224:	e14b22f4 	strd	r2, [fp, #-36]	; 0xffffffdc
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:240
    number = number2;
    9228:	e51b0050 	ldr	r0, [fp, #-80]	; 0xffffffb0
    922c:	eb0001a5 	bl	98c8 <__aeabi_f2lz>
    9230:	e1a02000 	mov	r2, r0
    9234:	e1a03001 	mov	r3, r1
    9238:	e14b23fc 	strd	r2, [fp, #-60]	; 0xffffffc4
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:241
    if (sign == '-')
    923c:	e14b24dc 	ldrd	r2, [fp, #-76]	; 0xffffffb4
    9240:	e242102d 	sub	r1, r2, #45	; 0x2d
    9244:	e1913003 	orrs	r3, r1, r3
    9248:	1a00000d 	bne	9284 <_Z4ftoafPc+0x218>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:243
    {
        length++;
    924c:	e14b22d4 	ldrd	r2, [fp, #-36]	; 0xffffffdc
    9250:	e2921001 	adds	r1, r2, #1
    9254:	e50b107c 	str	r1, [fp, #-124]	; 0xffffff84
    9258:	e2a33000 	adc	r3, r3, #0
    925c:	e50b3078 	str	r3, [fp, #-120]	; 0xffffff88
    9260:	e14b27dc 	ldrd	r2, [fp, #-124]	; 0xffffff84
    9264:	e14b22f4 	strd	r2, [fp, #-36]	; 0xffffffdc
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:244
        position++;
    9268:	e14b24d4 	ldrd	r2, [fp, #-68]	; 0xffffffbc
    926c:	e2921001 	adds	r1, r2, #1
    9270:	e50b1084 	str	r1, [fp, #-132]	; 0xffffff7c
    9274:	e2a33000 	adc	r3, r3, #0
    9278:	e50b3080 	str	r3, [fp, #-128]	; 0xffffff80
    927c:	e14b28d4 	ldrd	r2, [fp, #-132]	; 0xffffff7c
    9280:	e14b24f4 	strd	r2, [fp, #-68]	; 0xffffffbc
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:247
    }

    for (i = length; i >= 0 ; i--)
    9284:	e14b22d4 	ldrd	r2, [fp, #-36]	; 0xffffffdc
    9288:	e14b23f4 	strd	r2, [fp, #-52]	; 0xffffffcc
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:247 (discriminator 1)
    928c:	e14b23d4 	ldrd	r2, [fp, #-52]	; 0xffffffcc
    9290:	e3530000 	cmp	r3, #0
    9294:	ba000039 	blt	9380 <_Z4ftoafPc+0x314>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:249
    {
        if (i == (length))
    9298:	e14b03d4 	ldrd	r0, [fp, #-52]	; 0xffffffcc
    929c:	e14b22d4 	ldrd	r2, [fp, #-36]	; 0xffffffdc
    92a0:	e1510003 	cmp	r1, r3
    92a4:	01500002 	cmpeq	r0, r2
    92a8:	1a000005 	bne	92c4 <_Z4ftoafPc+0x258>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:250
            r[i] = '\0';
    92ac:	e51b3034 	ldr	r3, [fp, #-52]	; 0xffffffcc
    92b0:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    92b4:	e0823003 	add	r3, r2, r3
    92b8:	e3a02000 	mov	r2, #0
    92bc:	e5c32000 	strb	r2, [r3]
    92c0:	ea000029 	b	936c <_Z4ftoafPc+0x300>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:251
        else if(i == (position))
    92c4:	e14b03d4 	ldrd	r0, [fp, #-52]	; 0xffffffcc
    92c8:	e14b24d4 	ldrd	r2, [fp, #-68]	; 0xffffffbc
    92cc:	e1510003 	cmp	r1, r3
    92d0:	01500002 	cmpeq	r0, r2
    92d4:	1a000005 	bne	92f0 <_Z4ftoafPc+0x284>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:252
            r[i] = '.';
    92d8:	e51b3034 	ldr	r3, [fp, #-52]	; 0xffffffcc
    92dc:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    92e0:	e0823003 	add	r3, r2, r3
    92e4:	e3a0202e 	mov	r2, #46	; 0x2e
    92e8:	e5c32000 	strb	r2, [r3]
    92ec:	ea00001e 	b	936c <_Z4ftoafPc+0x300>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:253
        else if(sign == '-' && i == 0)
    92f0:	e14b24dc 	ldrd	r2, [fp, #-76]	; 0xffffffb4
    92f4:	e242102d 	sub	r1, r2, #45	; 0x2d
    92f8:	e1913003 	orrs	r3, r1, r3
    92fc:	1a000008 	bne	9324 <_Z4ftoafPc+0x2b8>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:253 (discriminator 1)
    9300:	e14b23d4 	ldrd	r2, [fp, #-52]	; 0xffffffcc
    9304:	e1923003 	orrs	r3, r2, r3
    9308:	1a000005 	bne	9324 <_Z4ftoafPc+0x2b8>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:254
            r[i] = '-';
    930c:	e51b3034 	ldr	r3, [fp, #-52]	; 0xffffffcc
    9310:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    9314:	e0823003 	add	r3, r2, r3
    9318:	e3a0202d 	mov	r2, #45	; 0x2d
    931c:	e5c32000 	strb	r2, [r3]
    9320:	ea000011 	b	936c <_Z4ftoafPc+0x300>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:257
        else
        {
            r[i] = (number % 10) + '0';
    9324:	e14b03dc 	ldrd	r0, [fp, #-60]	; 0xffffffc4
    9328:	e3a0200a 	mov	r2, #10
    932c:	e3a03000 	mov	r3, #0
    9330:	eb00012f 	bl	97f4 <__aeabi_ldivmod>
    9334:	e6ef2072 	uxtb	r2, r2
    9338:	e51b3034 	ldr	r3, [fp, #-52]	; 0xffffffcc
    933c:	e51b105c 	ldr	r1, [fp, #-92]	; 0xffffffa4
    9340:	e0813003 	add	r3, r1, r3
    9344:	e2822030 	add	r2, r2, #48	; 0x30
    9348:	e6ef2072 	uxtb	r2, r2
    934c:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:258
            number /=10;
    9350:	e14b03dc 	ldrd	r0, [fp, #-60]	; 0xffffffc4
    9354:	e3a0200a 	mov	r2, #10
    9358:	e3a03000 	mov	r3, #0
    935c:	eb000124 	bl	97f4 <__aeabi_ldivmod>
    9360:	e1a02000 	mov	r2, r0
    9364:	e1a03001 	mov	r3, r1
    9368:	e14b23fc 	strd	r2, [fp, #-60]	; 0xffffffc4
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:247 (discriminator 2)
    for (i = length; i >= 0 ; i--)
    936c:	e14b23d4 	ldrd	r2, [fp, #-52]	; 0xffffffcc
    9370:	e2528001 	subs	r8, r2, #1
    9374:	e2c39000 	sbc	r9, r3, #0
    9378:	e14b83f4 	strd	r8, [fp, #-52]	; 0xffffffcc
    937c:	eaffffc2 	b	928c <_Z4ftoafPc+0x220>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:261
        }
    }
}
    9380:	e320f000 	nop	{0}
    9384:	e24bd01c 	sub	sp, fp, #28
    9388:	e8bd8bf0 	pop	{r4, r5, r6, r7, r8, r9, fp, pc}
    938c:	3f800000 	svccc	0x00800000
    9390:	41200000 			; <UNDEFINED> instruction: 0x41200000

00009394 <__udivsi3>:
__udivsi3():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1104
    9394:	e2512001 	subs	r2, r1, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1106
    9398:	012fff1e 	bxeq	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1107
    939c:	3a000074 	bcc	9574 <__udivsi3+0x1e0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1108
    93a0:	e1500001 	cmp	r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1109
    93a4:	9a00006b 	bls	9558 <__udivsi3+0x1c4>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1110
    93a8:	e1110002 	tst	r1, r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1111
    93ac:	0a00006c 	beq	9564 <__udivsi3+0x1d0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1113
    93b0:	e16f3f10 	clz	r3, r0
    93b4:	e16f2f11 	clz	r2, r1
    93b8:	e0423003 	sub	r3, r2, r3
    93bc:	e273301f 	rsbs	r3, r3, #31
    93c0:	10833083 	addne	r3, r3, r3, lsl #1
    93c4:	e3a02000 	mov	r2, #0
    93c8:	108ff103 	addne	pc, pc, r3, lsl #2
    93cc:	e1a00000 	nop			; (mov r0, r0)
    93d0:	e1500f81 	cmp	r0, r1, lsl #31
    93d4:	e0a22002 	adc	r2, r2, r2
    93d8:	20400f81 	subcs	r0, r0, r1, lsl #31
    93dc:	e1500f01 	cmp	r0, r1, lsl #30
    93e0:	e0a22002 	adc	r2, r2, r2
    93e4:	20400f01 	subcs	r0, r0, r1, lsl #30
    93e8:	e1500e81 	cmp	r0, r1, lsl #29
    93ec:	e0a22002 	adc	r2, r2, r2
    93f0:	20400e81 	subcs	r0, r0, r1, lsl #29
    93f4:	e1500e01 	cmp	r0, r1, lsl #28
    93f8:	e0a22002 	adc	r2, r2, r2
    93fc:	20400e01 	subcs	r0, r0, r1, lsl #28
    9400:	e1500d81 	cmp	r0, r1, lsl #27
    9404:	e0a22002 	adc	r2, r2, r2
    9408:	20400d81 	subcs	r0, r0, r1, lsl #27
    940c:	e1500d01 	cmp	r0, r1, lsl #26
    9410:	e0a22002 	adc	r2, r2, r2
    9414:	20400d01 	subcs	r0, r0, r1, lsl #26
    9418:	e1500c81 	cmp	r0, r1, lsl #25
    941c:	e0a22002 	adc	r2, r2, r2
    9420:	20400c81 	subcs	r0, r0, r1, lsl #25
    9424:	e1500c01 	cmp	r0, r1, lsl #24
    9428:	e0a22002 	adc	r2, r2, r2
    942c:	20400c01 	subcs	r0, r0, r1, lsl #24
    9430:	e1500b81 	cmp	r0, r1, lsl #23
    9434:	e0a22002 	adc	r2, r2, r2
    9438:	20400b81 	subcs	r0, r0, r1, lsl #23
    943c:	e1500b01 	cmp	r0, r1, lsl #22
    9440:	e0a22002 	adc	r2, r2, r2
    9444:	20400b01 	subcs	r0, r0, r1, lsl #22
    9448:	e1500a81 	cmp	r0, r1, lsl #21
    944c:	e0a22002 	adc	r2, r2, r2
    9450:	20400a81 	subcs	r0, r0, r1, lsl #21
    9454:	e1500a01 	cmp	r0, r1, lsl #20
    9458:	e0a22002 	adc	r2, r2, r2
    945c:	20400a01 	subcs	r0, r0, r1, lsl #20
    9460:	e1500981 	cmp	r0, r1, lsl #19
    9464:	e0a22002 	adc	r2, r2, r2
    9468:	20400981 	subcs	r0, r0, r1, lsl #19
    946c:	e1500901 	cmp	r0, r1, lsl #18
    9470:	e0a22002 	adc	r2, r2, r2
    9474:	20400901 	subcs	r0, r0, r1, lsl #18
    9478:	e1500881 	cmp	r0, r1, lsl #17
    947c:	e0a22002 	adc	r2, r2, r2
    9480:	20400881 	subcs	r0, r0, r1, lsl #17
    9484:	e1500801 	cmp	r0, r1, lsl #16
    9488:	e0a22002 	adc	r2, r2, r2
    948c:	20400801 	subcs	r0, r0, r1, lsl #16
    9490:	e1500781 	cmp	r0, r1, lsl #15
    9494:	e0a22002 	adc	r2, r2, r2
    9498:	20400781 	subcs	r0, r0, r1, lsl #15
    949c:	e1500701 	cmp	r0, r1, lsl #14
    94a0:	e0a22002 	adc	r2, r2, r2
    94a4:	20400701 	subcs	r0, r0, r1, lsl #14
    94a8:	e1500681 	cmp	r0, r1, lsl #13
    94ac:	e0a22002 	adc	r2, r2, r2
    94b0:	20400681 	subcs	r0, r0, r1, lsl #13
    94b4:	e1500601 	cmp	r0, r1, lsl #12
    94b8:	e0a22002 	adc	r2, r2, r2
    94bc:	20400601 	subcs	r0, r0, r1, lsl #12
    94c0:	e1500581 	cmp	r0, r1, lsl #11
    94c4:	e0a22002 	adc	r2, r2, r2
    94c8:	20400581 	subcs	r0, r0, r1, lsl #11
    94cc:	e1500501 	cmp	r0, r1, lsl #10
    94d0:	e0a22002 	adc	r2, r2, r2
    94d4:	20400501 	subcs	r0, r0, r1, lsl #10
    94d8:	e1500481 	cmp	r0, r1, lsl #9
    94dc:	e0a22002 	adc	r2, r2, r2
    94e0:	20400481 	subcs	r0, r0, r1, lsl #9
    94e4:	e1500401 	cmp	r0, r1, lsl #8
    94e8:	e0a22002 	adc	r2, r2, r2
    94ec:	20400401 	subcs	r0, r0, r1, lsl #8
    94f0:	e1500381 	cmp	r0, r1, lsl #7
    94f4:	e0a22002 	adc	r2, r2, r2
    94f8:	20400381 	subcs	r0, r0, r1, lsl #7
    94fc:	e1500301 	cmp	r0, r1, lsl #6
    9500:	e0a22002 	adc	r2, r2, r2
    9504:	20400301 	subcs	r0, r0, r1, lsl #6
    9508:	e1500281 	cmp	r0, r1, lsl #5
    950c:	e0a22002 	adc	r2, r2, r2
    9510:	20400281 	subcs	r0, r0, r1, lsl #5
    9514:	e1500201 	cmp	r0, r1, lsl #4
    9518:	e0a22002 	adc	r2, r2, r2
    951c:	20400201 	subcs	r0, r0, r1, lsl #4
    9520:	e1500181 	cmp	r0, r1, lsl #3
    9524:	e0a22002 	adc	r2, r2, r2
    9528:	20400181 	subcs	r0, r0, r1, lsl #3
    952c:	e1500101 	cmp	r0, r1, lsl #2
    9530:	e0a22002 	adc	r2, r2, r2
    9534:	20400101 	subcs	r0, r0, r1, lsl #2
    9538:	e1500081 	cmp	r0, r1, lsl #1
    953c:	e0a22002 	adc	r2, r2, r2
    9540:	20400081 	subcs	r0, r0, r1, lsl #1
    9544:	e1500001 	cmp	r0, r1
    9548:	e0a22002 	adc	r2, r2, r2
    954c:	20400001 	subcs	r0, r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1115
    9550:	e1a00002 	mov	r0, r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1116
    9554:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1119
    9558:	03a00001 	moveq	r0, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1120
    955c:	13a00000 	movne	r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1121
    9560:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1123
    9564:	e16f2f11 	clz	r2, r1
    9568:	e262201f 	rsb	r2, r2, #31
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1125
    956c:	e1a00230 	lsr	r0, r0, r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1126
    9570:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1130
    9574:	e3500000 	cmp	r0, #0
    9578:	13e00000 	mvnne	r0, #0
    957c:	ea000007 	b	95a0 <__aeabi_idiv0>

00009580 <__aeabi_uidivmod>:
__aeabi_uidivmod():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1161
    9580:	e3510000 	cmp	r1, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1162
    9584:	0afffffa 	beq	9574 <__udivsi3+0x1e0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1163
    9588:	e92d4003 	push	{r0, r1, lr}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1164
    958c:	ebffff80 	bl	9394 <__udivsi3>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1165
    9590:	e8bd4006 	pop	{r1, r2, lr}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1166
    9594:	e0030092 	mul	r3, r2, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1167
    9598:	e0411003 	sub	r1, r1, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1168
    959c:	e12fff1e 	bx	lr

000095a0 <__aeabi_idiv0>:
__aeabi_ldiv0():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1466
    95a0:	e12fff1e 	bx	lr

000095a4 <__aeabi_frsub>:
__aeabi_frsub():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:59
    95a4:	e2200102 	eor	r0, r0, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:60
    95a8:	ea000000 	b	95b0 <__addsf3>

000095ac <__aeabi_fsub>:
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:65
    95ac:	e2211102 	eor	r1, r1, #-2147483648	; 0x80000000

000095b0 <__addsf3>:
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:74
    95b0:	e1b02080 	lsls	r2, r0, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:76
    95b4:	11b03081 	lslsne	r3, r1, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:77
    95b8:	11320003 	teqne	r2, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:78
    95bc:	11f0cc42 	mvnsne	ip, r2, asr #24
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:79
    95c0:	11f0cc43 	mvnsne	ip, r3, asr #24
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:80
    95c4:	0a00003c 	beq	96bc <__addsf3+0x10c>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:84
    95c8:	e1a02c22 	lsr	r2, r2, #24
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:85
    95cc:	e0723c23 	rsbs	r3, r2, r3, lsr #24
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:87
    95d0:	c0822003 	addgt	r2, r2, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:88
    95d4:	c0201001 	eorgt	r1, r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:89
    95d8:	c0210000 	eorgt	r0, r1, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:90
    95dc:	c0201001 	eorgt	r1, r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:92
    95e0:	b2633000 	rsblt	r3, r3, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:97
    95e4:	e3530019 	cmp	r3, #25
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:99
    95e8:	812fff1e 	bxhi	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:102
    95ec:	e3100102 	tst	r0, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:103
    95f0:	e3800502 	orr	r0, r0, #8388608	; 0x800000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:104
    95f4:	e3c004ff 	bic	r0, r0, #-16777216	; 0xff000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:106
    95f8:	12600000 	rsbne	r0, r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:107
    95fc:	e3110102 	tst	r1, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:108
    9600:	e3811502 	orr	r1, r1, #8388608	; 0x800000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:109
    9604:	e3c114ff 	bic	r1, r1, #-16777216	; 0xff000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:111
    9608:	12611000 	rsbne	r1, r1, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:115
    960c:	e1320003 	teq	r2, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:116
    9610:	0a000023 	beq	96a4 <__addsf3+0xf4>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:120
    9614:	e2422001 	sub	r2, r2, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:124
    9618:	e0900351 	adds	r0, r0, r1, asr r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:125
    961c:	e2633020 	rsb	r3, r3, #32
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:126
    9620:	e1a01311 	lsl	r1, r1, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:129
    9624:	e2003102 	and	r3, r0, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:130
    9628:	5a000001 	bpl	9634 <__addsf3+0x84>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:135
    962c:	e2711000 	rsbs	r1, r1, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:136
    9630:	e2e00000 	rsc	r0, r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:141
    9634:	e3500502 	cmp	r0, #8388608	; 0x800000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:142
    9638:	3a00000b 	bcc	966c <__addsf3+0xbc>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:143
    963c:	e3500401 	cmp	r0, #16777216	; 0x1000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:144
    9640:	3a000004 	bcc	9658 <__addsf3+0xa8>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:147
    9644:	e1b000a0 	lsrs	r0, r0, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:148
    9648:	e1a01061 	rrx	r1, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:149
    964c:	e2822001 	add	r2, r2, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:152
    9650:	e35200fe 	cmp	r2, #254	; 0xfe
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:153
    9654:	2a00002d 	bcs	9710 <__addsf3+0x160>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:160
    9658:	e3510102 	cmp	r1, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:161
    965c:	e0a00b82 	adc	r0, r0, r2, lsl #23
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:163
    9660:	03c00001 	biceq	r0, r0, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:164
    9664:	e1800003 	orr	r0, r0, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:165
    9668:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:169
    966c:	e1b01081 	lsls	r1, r1, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:170
    9670:	e0a00000 	adc	r0, r0, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:171
    9674:	e2522001 	subs	r2, r2, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:173
    9678:	23500502 	cmpcs	r0, #8388608	; 0x800000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:174
    967c:	2afffff5 	bcs	9658 <__addsf3+0xa8>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:199
    9680:	e16fcf10 	clz	ip, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:200
    9684:	e24cc008 	sub	ip, ip, #8
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:201
    9688:	e052200c 	subs	r2, r2, ip
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:202
    968c:	e1a00c10 	lsl	r0, r0, ip
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:209
    9690:	a0800b82 	addge	r0, r0, r2, lsl #23
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:210
    9694:	b2622000 	rsblt	r2, r2, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:211
    9698:	a1800003 	orrge	r0, r0, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:217
    969c:	b1830230 	orrlt	r0, r3, r0, lsr r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:219
    96a0:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:224
    96a4:	e3320000 	teq	r2, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:225
    96a8:	e2211502 	eor	r1, r1, #8388608	; 0x800000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:227
    96ac:	02200502 	eoreq	r0, r0, #8388608	; 0x800000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:228
    96b0:	02822001 	addeq	r2, r2, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:229
    96b4:	12433001 	subne	r3, r3, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:230
    96b8:	eaffffd5 	b	9614 <__addsf3+0x64>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:233
    96bc:	e1a03081 	lsl	r3, r1, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:235
    96c0:	e1f0cc42 	mvns	ip, r2, asr #24
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:237
    96c4:	11f0cc43 	mvnsne	ip, r3, asr #24
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:238
    96c8:	0a000013 	beq	971c <__addsf3+0x16c>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:240
    96cc:	e1320003 	teq	r2, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:241
    96d0:	0a000002 	beq	96e0 <__addsf3+0x130>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:244
    96d4:	e3320000 	teq	r2, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:246
    96d8:	01a00001 	moveq	r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:247
    96dc:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:249
    96e0:	e1300001 	teq	r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:253
    96e4:	13a00000 	movne	r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:254
    96e8:	112fff1e 	bxne	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:257
    96ec:	e31204ff 	tst	r2, #-16777216	; 0xff000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:258
    96f0:	1a000002 	bne	9700 <__addsf3+0x150>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:259
    96f4:	e1b00080 	lsls	r0, r0, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:261
    96f8:	23800102 	orrcs	r0, r0, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:262
    96fc:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:263
    9700:	e2922402 	adds	r2, r2, #33554432	; 0x2000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:265
    9704:	32800502 	addcc	r0, r0, #8388608	; 0x800000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:266
    9708:	312fff1e 	bxcc	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:267
    970c:	e2003102 	and	r3, r0, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:271
    9710:	e383047f 	orr	r0, r3, #2130706432	; 0x7f000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:272
    9714:	e3800502 	orr	r0, r0, #8388608	; 0x800000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:273
    9718:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:282
    971c:	e1f02c42 	mvns	r2, r2, asr #24
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:284
    9720:	11a00001 	movne	r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:285
    9724:	01f03c43 	mvnseq	r3, r3, asr #24
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:286
    9728:	11a01000 	movne	r1, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:287
    972c:	e1b02480 	lsls	r2, r0, #9
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:289
    9730:	01b03481 	lslseq	r3, r1, #9
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:290
    9734:	01300001 	teqeq	r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:291
    9738:	13800501 	orrne	r0, r0, #4194304	; 0x400000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:292
    973c:	e12fff1e 	bx	lr

00009740 <__aeabi_ui2f>:
__aeabi_ui2f():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:305
    9740:	e3a03000 	mov	r3, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:306
    9744:	ea000001 	b	9750 <__aeabi_i2f+0x8>

00009748 <__aeabi_i2f>:
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:311
    9748:	e2103102 	ands	r3, r0, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:313
    974c:	42600000 	rsbmi	r0, r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:315
    9750:	e1b0c000 	movs	ip, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:317
    9754:	012fff1e 	bxeq	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:320
    9758:	e383344b 	orr	r3, r3, #1258291200	; 0x4b000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:323
    975c:	e1a01000 	mov	r1, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:325
    9760:	e3a00000 	mov	r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:326
    9764:	ea00000f 	b	97a8 <__aeabi_l2f+0x30>

00009768 <__aeabi_ul2f>:
__floatundisf():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:338
    9768:	e1902001 	orrs	r2, r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:340
    976c:	012fff1e 	bxeq	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:342
    9770:	e3a03000 	mov	r3, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:343
    9774:	ea000005 	b	9790 <__aeabi_l2f+0x18>

00009778 <__aeabi_l2f>:
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:348
    9778:	e1902001 	orrs	r2, r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:350
    977c:	012fff1e 	bxeq	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:352
    9780:	e2113102 	ands	r3, r1, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:353
    9784:	5a000001 	bpl	9790 <__aeabi_l2f+0x18>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:358
    9788:	e2700000 	rsbs	r0, r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:359
    978c:	e2e11000 	rsc	r1, r1, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:362
    9790:	e1b0c001 	movs	ip, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:364
    9794:	01a0c000 	moveq	ip, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:365
    9798:	01a01000 	moveq	r1, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:366
    979c:	03a00000 	moveq	r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:369
    97a0:	e383345b 	orr	r3, r3, #1526726656	; 0x5b000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:371
    97a4:	02433201 	subeq	r3, r3, #268435456	; 0x10000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:372
    97a8:	e2433502 	sub	r3, r3, #8388608	; 0x800000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:397
    97ac:	e16f2f1c 	clz	r2, ip
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:398
    97b0:	e2522008 	subs	r2, r2, #8
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:402
    97b4:	e0433b82 	sub	r3, r3, r2, lsl #23
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:403
    97b8:	ba000006 	blt	97d8 <__aeabi_l2f+0x60>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:405
    97bc:	e0833211 	add	r3, r3, r1, lsl r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:406
    97c0:	e1a0c210 	lsl	ip, r0, r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:407
    97c4:	e2622020 	rsb	r2, r2, #32
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:408
    97c8:	e35c0102 	cmp	ip, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:409
    97cc:	e0a30230 	adc	r0, r3, r0, lsr r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:411
    97d0:	03c00001 	biceq	r0, r0, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:412
    97d4:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:414
    97d8:	e2822020 	add	r2, r2, #32
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:415
    97dc:	e1a0c211 	lsl	ip, r1, r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:416
    97e0:	e2622020 	rsb	r2, r2, #32
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:417
    97e4:	e190008c 	orrs	r0, r0, ip, lsl #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:418
    97e8:	e0a30231 	adc	r0, r3, r1, lsr r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:420
    97ec:	01c00fac 	biceq	r0, r0, ip, lsr #31
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:421
    97f0:	e12fff1e 	bx	lr

000097f4 <__aeabi_ldivmod>:
__aeabi_ldivmod():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:186
    97f4:	e3530000 	cmp	r3, #0
    97f8:	03520000 	cmpeq	r2, #0
    97fc:	1a000007 	bne	9820 <__aeabi_ldivmod+0x2c>
    9800:	e3510000 	cmp	r1, #0
    9804:	b3a01102 	movlt	r1, #-2147483648	; 0x80000000
    9808:	b3a00000 	movlt	r0, #0
    980c:	ba000002 	blt	981c <__aeabi_ldivmod+0x28>
    9810:	03500000 	cmpeq	r0, #0
    9814:	13e01102 	mvnne	r1, #-2147483648	; 0x80000000
    9818:	13e00000 	mvnne	r0, #0
    981c:	eaffff5f 	b	95a0 <__aeabi_idiv0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:188
    9820:	e24dd008 	sub	sp, sp, #8
    9824:	e92d6000 	push	{sp, lr}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:189
    9828:	e3510000 	cmp	r1, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:190
    982c:	ba000006 	blt	984c <__aeabi_ldivmod+0x58>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:191
    9830:	e3530000 	cmp	r3, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:192
    9834:	ba000011 	blt	9880 <__aeabi_ldivmod+0x8c>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:194
    9838:	eb00003e 	bl	9938 <__udivmoddi4>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:196
    983c:	e59de004 	ldr	lr, [sp, #4]
    9840:	e28dd008 	add	sp, sp, #8
    9844:	e8bd000c 	pop	{r2, r3}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:197
    9848:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:201
    984c:	e2700000 	rsbs	r0, r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:202
    9850:	e0c11081 	sbc	r1, r1, r1, lsl #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:203
    9854:	e3530000 	cmp	r3, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:204
    9858:	ba000011 	blt	98a4 <__aeabi_ldivmod+0xb0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:206
    985c:	eb000035 	bl	9938 <__udivmoddi4>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:208
    9860:	e59de004 	ldr	lr, [sp, #4]
    9864:	e28dd008 	add	sp, sp, #8
    9868:	e8bd000c 	pop	{r2, r3}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:209
    986c:	e2700000 	rsbs	r0, r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:210
    9870:	e0c11081 	sbc	r1, r1, r1, lsl #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:211
    9874:	e2722000 	rsbs	r2, r2, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:212
    9878:	e0c33083 	sbc	r3, r3, r3, lsl #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:213
    987c:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:217
    9880:	e2722000 	rsbs	r2, r2, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:218
    9884:	e0c33083 	sbc	r3, r3, r3, lsl #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:220
    9888:	eb00002a 	bl	9938 <__udivmoddi4>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:222
    988c:	e59de004 	ldr	lr, [sp, #4]
    9890:	e28dd008 	add	sp, sp, #8
    9894:	e8bd000c 	pop	{r2, r3}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:223
    9898:	e2700000 	rsbs	r0, r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:224
    989c:	e0c11081 	sbc	r1, r1, r1, lsl #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:225
    98a0:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:229
    98a4:	e2722000 	rsbs	r2, r2, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:230
    98a8:	e0c33083 	sbc	r3, r3, r3, lsl #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:232
    98ac:	eb000021 	bl	9938 <__udivmoddi4>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:233
    98b0:	e59de004 	ldr	lr, [sp, #4]
    98b4:	e28dd008 	add	sp, sp, #8
    98b8:	e8bd000c 	pop	{r2, r3}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:234
    98bc:	e2722000 	rsbs	r2, r2, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:235
    98c0:	e0c33083 	sbc	r3, r3, r3, lsl #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:236
    98c4:	e12fff1e 	bx	lr

000098c8 <__aeabi_f2lz>:
__fixsfdi():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1530
    98c8:	ee070a90 	vmov	s15, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1531
    98cc:	eef57ac0 	vcmpe.f32	s15, #0.0
    98d0:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    98d4:	4a000000 	bmi	98dc <__aeabi_f2lz+0x14>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1533
    98d8:	ea000006 	b	98f8 <__aeabi_f2ulz>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1532
    98dc:	eef17a67 	vneg.f32	s15, s15
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1530
    98e0:	e92d4010 	push	{r4, lr}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1532
    98e4:	ee170a90 	vmov	r0, s15
    98e8:	eb000002 	bl	98f8 <__aeabi_f2ulz>
    98ec:	e2700000 	rsbs	r0, r0, #0
    98f0:	e2e11000 	rsc	r1, r1, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1534
    98f4:	e8bd8010 	pop	{r4, pc}

000098f8 <__aeabi_f2ulz>:
__fixunssfdi():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1471
    98f8:	ee070a90 	vmov	s15, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1476
    98fc:	ed9f6b09 	vldr	d6, [pc, #36]	; 9928 <__aeabi_f2ulz+0x30>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1481
    9900:	ed9f5b0a 	vldr	d5, [pc, #40]	; 9930 <__aeabi_f2ulz+0x38>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1471
    9904:	eeb77ae7 	vcvt.f64.f32	d7, s15
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1476
    9908:	ee276b06 	vmul.f64	d6, d7, d6
    990c:	eebc6bc6 	vcvt.u32.f64	s12, d6
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1481
    9910:	eeb84b46 	vcvt.f64.u32	d4, s12
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1524
    9914:	ee161a10 	vmov	r1, s12
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1481
    9918:	ee047b45 	vmls.f64	d7, d4, d5
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1524
    991c:	eefc7bc7 	vcvt.u32.f64	s15, d7
    9920:	ee170a90 	vmov	r0, s15
    9924:	e12fff1e 	bx	lr
    9928:	00000000 	andeq	r0, r0, r0
    992c:	3df00000 	ldclcc	0, cr0, [r0]
    9930:	00000000 	andeq	r0, r0, r0
    9934:	41f00000 	mvnsmi	r0, r0

00009938 <__udivmoddi4>:
__udivmoddi4():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:960
    9938:	e1500002 	cmp	r0, r2
    993c:	e0d1c003 	sbcs	ip, r1, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:948
    9940:	e92d43f0 	push	{r4, r5, r6, r7, r8, r9, lr}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:949
    9944:	33a05000 	movcc	r5, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:948
    9948:	e59d701c 	ldr	r7, [sp, #28]
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:949
    994c:	31a06005 	movcc	r6, r5
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:960
    9950:	3a00003b 	bcc	9a44 <__udivmoddi4+0x10c>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:962
    9954:	e3530000 	cmp	r3, #0
    9958:	016fcf12 	clzeq	ip, r2
    995c:	116fef13 	clzne	lr, r3
    9960:	028ce020 	addeq	lr, ip, #32
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:963
    9964:	e3510000 	cmp	r1, #0
    9968:	016fcf10 	clzeq	ip, r0
    996c:	028cc020 	addeq	ip, ip, #32
    9970:	116fcf11 	clzne	ip, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:965
    9974:	e04ec00c 	sub	ip, lr, ip
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:966
    9978:	e1a03c13 	lsl	r3, r3, ip
    997c:	e24c9020 	sub	r9, ip, #32
    9980:	e1833912 	orr	r3, r3, r2, lsl r9
    9984:	e1a04c12 	lsl	r4, r2, ip
    9988:	e26c8020 	rsb	r8, ip, #32
    998c:	e1833832 	orr	r3, r3, r2, lsr r8
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:973
    9990:	e1500004 	cmp	r0, r4
    9994:	e0d12003 	sbcs	r2, r1, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:949
    9998:	33a05000 	movcc	r5, #0
    999c:	31a06005 	movcc	r6, r5
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:973
    99a0:	3a000005 	bcc	99bc <__udivmoddi4+0x84>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:976
    99a4:	e3a05001 	mov	r5, #1
    99a8:	e1a06915 	lsl	r6, r5, r9
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:975
    99ac:	e0500004 	subs	r0, r0, r4
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:976
    99b0:	e1866835 	orr	r6, r6, r5, lsr r8
    99b4:	e1a05c15 	lsl	r5, r5, ip
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:975
    99b8:	e0c11003 	sbc	r1, r1, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:979
    99bc:	e35c0000 	cmp	ip, #0
    99c0:	0a00001f 	beq	9a44 <__udivmoddi4+0x10c>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:981
    99c4:	e1a040a4 	lsr	r4, r4, #1
    99c8:	e1844f83 	orr	r4, r4, r3, lsl #31
    99cc:	e1a020a3 	lsr	r2, r3, #1
    99d0:	e1a0e00c 	mov	lr, ip
    99d4:	ea000007 	b	99f8 <__udivmoddi4+0xc0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:989
    99d8:	e0503004 	subs	r3, r0, r4
    99dc:	e0c11002 	sbc	r1, r1, r2
    99e0:	e0933003 	adds	r3, r3, r3
    99e4:	e0a11001 	adc	r1, r1, r1
    99e8:	e2930001 	adds	r0, r3, #1
    99ec:	e2a11000 	adc	r1, r1, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:993
    99f0:	e25ee001 	subs	lr, lr, #1
    99f4:	0a000006 	beq	9a14 <__udivmoddi4+0xdc>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:988
    99f8:	e1500004 	cmp	r0, r4
    99fc:	e0d13002 	sbcs	r3, r1, r2
    9a00:	2afffff4 	bcs	99d8 <__udivmoddi4+0xa0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:991
    9a04:	e0900000 	adds	r0, r0, r0
    9a08:	e0a11001 	adc	r1, r1, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:993
    9a0c:	e25ee001 	subs	lr, lr, #1
    9a10:	1afffff8 	bne	99f8 <__udivmoddi4+0xc0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:997
    9a14:	e0955000 	adds	r5, r5, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:998
    9a18:	e1a00c30 	lsr	r0, r0, ip
    9a1c:	e1800811 	orr	r0, r0, r1, lsl r8
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:997
    9a20:	e0a66001 	adc	r6, r6, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:998
    9a24:	e1800931 	orr	r0, r0, r1, lsr r9
    9a28:	e1a01c31 	lsr	r1, r1, ip
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:999
    9a2c:	e1a03c10 	lsl	r3, r0, ip
    9a30:	e1a0cc11 	lsl	ip, r1, ip
    9a34:	e18cc910 	orr	ip, ip, r0, lsl r9
    9a38:	e18cc830 	orr	ip, ip, r0, lsr r8
    9a3c:	e0555003 	subs	r5, r5, r3
    9a40:	e0c6600c 	sbc	r6, r6, ip
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1003
    9a44:	e3570000 	cmp	r7, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1004
    9a48:	11c700f0 	strdne	r0, [r7]
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1006
    9a4c:	e1a00005 	mov	r0, r5
    9a50:	e1a01006 	mov	r1, r6
    9a54:	e8bd83f0 	pop	{r4, r5, r6, r7, r8, r9, pc}

Disassembly of section .rodata:

00009a58 <_ZL13Lock_Unlocked>:
    9a58:	00000000 	andeq	r0, r0, r0

00009a5c <_ZL11Lock_Locked>:
    9a5c:	00000001 	andeq	r0, r0, r1

00009a60 <_ZL21MaxFSDriverNameLength>:
    9a60:	00000010 	andeq	r0, r0, r0, lsl r0

00009a64 <_ZL17MaxFilenameLength>:
    9a64:	00000010 	andeq	r0, r0, r0, lsl r0

00009a68 <_ZL13MaxPathLength>:
    9a68:	00000080 	andeq	r0, r0, r0, lsl #1

00009a6c <_ZL18NoFilesystemDriver>:
    9a6c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009a70 <_ZL9NotifyAll>:
    9a70:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009a74 <_ZL24Max_Process_Opened_Files>:
    9a74:	00000010 	andeq	r0, r0, r0, lsl r0

00009a78 <_ZL10Indefinite>:
    9a78:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009a7c <_ZL18Deadline_Unchanged>:
    9a7c:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

00009a80 <_ZL14Invalid_Handle>:
    9a80:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009a84 <_ZN3halL18Default_Clock_RateE>:
    9a84:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}

00009a88 <_ZN3halL15Peripheral_BaseE>:
    9a88:	20000000 	andcs	r0, r0, r0

00009a8c <_ZN3halL9GPIO_BaseE>:
    9a8c:	20200000 	eorcs	r0, r0, r0

00009a90 <_ZN3halL14GPIO_Pin_CountE>:
    9a90:	00000036 	andeq	r0, r0, r6, lsr r0

00009a94 <_ZN3halL8AUX_BaseE>:
    9a94:	20215000 	eorcs	r5, r1, r0

00009a98 <_ZN3halL25Interrupt_Controller_BaseE>:
    9a98:	2000b200 	andcs	fp, r0, r0, lsl #4

00009a9c <_ZN3halL10Timer_BaseE>:
    9a9c:	2000b400 	andcs	fp, r0, r0, lsl #8

00009aa0 <_ZN3halL17System_Timer_BaseE>:
    9aa0:	20003000 	andcs	r3, r0, r0

00009aa4 <_ZN3halL9TRNG_BaseE>:
    9aa4:	20104000 	andscs	r4, r0, r0

00009aa8 <_ZN3halL9BSC0_BaseE>:
    9aa8:	20205000 	eorcs	r5, r0, r0

00009aac <_ZN3halL9BSC1_BaseE>:
    9aac:	20804000 	addcs	r4, r0, r0

00009ab0 <_ZN3halL9BSC2_BaseE>:
    9ab0:	20805000 	addcs	r5, r0, r0

00009ab4 <_ZL11Invalid_Pin>:
    9ab4:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
    9ab8:	3a564544 	bcc	159afd0 <__bss_end+0x1591490>
    9abc:	6f697067 	svcvs	0x00697067
    9ac0:	0033322f 	eorseq	r3, r3, pc, lsr #4
    9ac4:	00676f6c 	rsbeq	r6, r7, ip, ror #30
    9ac8:	746c6954 	strbtvc	r6, [ip], #-2388	; 0xfffff6ac
    9acc:	00505520 	subseq	r5, r0, r0, lsr #10
    9ad0:	746c6954 	strbtvc	r6, [ip], #-2388	; 0xfffff6ac
    9ad4:	574f4420 	strbpl	r4, [pc, -r0, lsr #8]
    9ad8:	0000004e 	andeq	r0, r0, lr, asr #32

00009adc <_ZL13Lock_Unlocked>:
    9adc:	00000000 	andeq	r0, r0, r0

00009ae0 <_ZL11Lock_Locked>:
    9ae0:	00000001 	andeq	r0, r0, r1

00009ae4 <_ZL21MaxFSDriverNameLength>:
    9ae4:	00000010 	andeq	r0, r0, r0, lsl r0

00009ae8 <_ZL17MaxFilenameLength>:
    9ae8:	00000010 	andeq	r0, r0, r0, lsl r0

00009aec <_ZL13MaxPathLength>:
    9aec:	00000080 	andeq	r0, r0, r0, lsl #1

00009af0 <_ZL18NoFilesystemDriver>:
    9af0:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009af4 <_ZL9NotifyAll>:
    9af4:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009af8 <_ZL24Max_Process_Opened_Files>:
    9af8:	00000010 	andeq	r0, r0, r0, lsl r0

00009afc <_ZL10Indefinite>:
    9afc:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009b00 <_ZL18Deadline_Unchanged>:
    9b00:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

00009b04 <_ZL14Invalid_Handle>:
    9b04:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009b08 <_ZL16Pipe_File_Prefix>:
    9b08:	3a535953 	bcc	14e005c <__bss_end+0x14d651c>
    9b0c:	65706970 	ldrbvs	r6, [r0, #-2416]!	; 0xfffff690
    9b10:	0000002f 	andeq	r0, r0, pc, lsr #32

00009b14 <_ZN12_GLOBAL__N_1L11CharConvArrE>:
    9b14:	33323130 	teqcc	r2, #48, 2
    9b18:	37363534 			; <UNDEFINED> instruction: 0x37363534
    9b1c:	42413938 	submi	r3, r1, #56, 18	; 0xe0000
    9b20:	46454443 	strbmi	r4, [r5], -r3, asr #8
	...

Disassembly of section .ARM.exidx:

00009b28 <__CTOR_LIST__-0x8>:
    9b28:	7ffffe10 	svcvc	0x00fffe10
    9b2c:	00000001 	andeq	r0, r0, r1

Disassembly of section .bss:

00009b30 <__bss_start>:
	...

Disassembly of section .ARM.attributes:

00000000 <.ARM.attributes>:
   0:	00002e41 	andeq	r2, r0, r1, asr #28
   4:	61656100 	cmnvs	r5, r0, lsl #2
   8:	01006962 	tsteq	r0, r2, ror #18
   c:	00000024 	andeq	r0, r0, r4, lsr #32
  10:	4b5a3605 	blmi	168d82c <__bss_end+0x1683cec>
  14:	08070600 	stmdaeq	r7, {r9, sl}
  18:	0a010901 	beq	42424 <__bss_end+0x388e4>
  1c:	14041202 	strne	r1, [r4], #-514	; 0xfffffdfe
  20:	17011501 	strne	r1, [r1, -r1, lsl #10]
  24:	1a011803 	bne	46038 <__bss_end+0x3c4f8>
  28:	22011c01 	andcs	r1, r1, #256	; 0x100
  2c:	Address 0x000000000000002c is out of bounds.


Disassembly of section .comment:

00000000 <.comment>:
   0:	3a434347 	bcc	10d0d24 <__bss_end+0x10c71e4>
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
      e0:	db010100 	blle	404e8 <__bss_end+0x369a8>
      e4:	03000000 	movweq	r0, #0
      e8:	00005200 	andeq	r5, r0, r0, lsl #4
      ec:	fb010200 	blx	408f6 <__bss_end+0x36db6>
      f0:	01000d0e 	tsteq	r0, lr, lsl #26
      f4:	00010101 	andeq	r0, r1, r1, lsl #2
      f8:	00010000 	andeq	r0, r1, r0
      fc:	682f0100 	stmdavs	pc!, {r8}	; <UNPREDICTABLE>
     100:	2f656d6f 	svccs	0x00656d6f
     104:	66657274 			; <UNDEFINED> instruction: 0x66657274
     108:	732f6c69 			; <UNDEFINED> instruction: 0x732f6c69
     10c:	732f6d65 			; <UNDEFINED> instruction: 0x732f6d65
     110:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
     114:	752f7365 	strvc	r7, [pc, #-869]!	; fffffdb7 <__bss_end+0xffff6277>
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
     14c:	0a05830b 	beq	160d80 <__bss_end+0x157240>
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
     178:	4a030402 	bmi	c1188 <__bss_end+0xb7648>
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
     1ac:	4a020402 	bmi	811bc <__bss_end+0x7767c>
     1b0:	02000205 	andeq	r0, r0, #1342177280	; 0x50000000
     1b4:	052d0204 	streq	r0, [sp, #-516]!	; 0xfffffdfc
     1b8:	01058509 	tsteq	r5, r9, lsl #10
     1bc:	000a022f 	andeq	r0, sl, pc, lsr #4
     1c0:	01f20101 	mvnseq	r0, r1, lsl #2
     1c4:	00030000 	andeq	r0, r3, r0
     1c8:	000001b2 			; <UNDEFINED> instruction: 0x000001b2
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
     200:	746c6974 	strbtvc	r6, [ip], #-2420	; 0xfffff68c
     204:	7361745f 	cmnvc	r1, #1593835520	; 0x5f000000
     208:	682f006b 	stmdavs	pc!, {r0, r1, r3, r5, r6}	; <UNPREDICTABLE>
     20c:	2f656d6f 	svccs	0x00656d6f
     210:	66657274 			; <UNDEFINED> instruction: 0x66657274
     214:	732f6c69 			; <UNDEFINED> instruction: 0x732f6c69
     218:	732f6d65 			; <UNDEFINED> instruction: 0x732f6d65
     21c:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
     220:	752f7365 	strvc	r7, [pc, #-869]!	; fffffec3 <__bss_end+0xffff6383>
     224:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
     228:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
     22c:	2f2e2e2f 	svccs	0x002e2e2f
     230:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
     234:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
     238:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
     23c:	702f6564 	eorvc	r6, pc, r4, ror #10
     240:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     244:	2f007373 	svccs	0x00007373
     248:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
     24c:	6572742f 	ldrbvs	r7, [r2, #-1071]!	; 0xfffffbd1
     250:	2f6c6966 	svccs	0x006c6966
     254:	2f6d6573 	svccs	0x006d6573
     258:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
     25c:	2f736563 	svccs	0x00736563
     260:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
     264:	63617073 	cmnvs	r1, #115	; 0x73
     268:	2e2e2f65 	cdpcs	15, 2, cr2, cr14, cr5, {3}
     26c:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
     270:	2f6c656e 	svccs	0x006c656e
     274:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
     278:	2f656475 	svccs	0x00656475
     27c:	2f007366 	svccs	0x00007366
     280:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
     284:	6572742f 	ldrbvs	r7, [r2, #-1071]!	; 0xfffffbd1
     288:	2f6c6966 	svccs	0x006c6966
     28c:	2f6d6573 	svccs	0x006d6573
     290:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
     294:	2f736563 	svccs	0x00736563
     298:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
     29c:	63617073 	cmnvs	r1, #115	; 0x73
     2a0:	2e2e2f65 	cdpcs	15, 2, cr2, cr14, cr5, {3}
     2a4:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
     2a8:	2f6c656e 	svccs	0x006c656e
     2ac:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
     2b0:	2f656475 	svccs	0x00656475
     2b4:	72616f62 	rsbvc	r6, r1, #392	; 0x188
     2b8:	70722f64 	rsbsvc	r2, r2, r4, ror #30
     2bc:	682f3069 	stmdavs	pc!, {r0, r3, r5, r6, ip, sp}	; <UNPREDICTABLE>
     2c0:	2f006c61 	svccs	0x00006c61
     2c4:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
     2c8:	6572742f 	ldrbvs	r7, [r2, #-1071]!	; 0xfffffbd1
     2cc:	2f6c6966 	svccs	0x006c6966
     2d0:	2f6d6573 	svccs	0x006d6573
     2d4:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
     2d8:	2f736563 	svccs	0x00736563
     2dc:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
     2e0:	63617073 	cmnvs	r1, #115	; 0x73
     2e4:	2e2e2f65 	cdpcs	15, 2, cr2, cr14, cr5, {3}
     2e8:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
     2ec:	2f6c656e 	svccs	0x006c656e
     2f0:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
     2f4:	2f656475 	svccs	0x00656475
     2f8:	76697264 	strbtvc	r7, [r9], -r4, ror #4
     2fc:	00737265 	rsbseq	r7, r3, r5, ror #4
     300:	69616d00 	stmdbvs	r1!, {r8, sl, fp, sp, lr}^
     304:	70632e6e 	rsbvc	r2, r3, lr, ror #28
     308:	00010070 	andeq	r0, r1, r0, ror r0
     30c:	69777300 	ldmdbvs	r7!, {r8, r9, ip, sp, lr}^
     310:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
     314:	70730000 	rsbsvc	r0, r3, r0
     318:	6f6c6e69 	svcvs	0x006c6e69
     31c:	682e6b63 	stmdavs	lr!, {r0, r1, r5, r6, r8, r9, fp, sp, lr}
     320:	00000200 	andeq	r0, r0, r0, lsl #4
     324:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
     328:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
     32c:	682e6d65 	stmdavs	lr!, {r0, r2, r5, r6, r8, sl, fp, sp, lr}
     330:	00000300 	andeq	r0, r0, r0, lsl #6
     334:	636f7270 	cmnvs	pc, #112, 4
     338:	2e737365 	cdpcs	3, 7, cr7, cr3, cr5, {3}
     33c:	00020068 	andeq	r0, r2, r8, rrx
     340:	6f727000 	svcvs	0x00727000
     344:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     348:	6e616d5f 	mcrvs	13, 3, r6, cr1, cr15, {2}
     34c:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     350:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
     354:	65700000 	ldrbvs	r0, [r0, #-0]!
     358:	68706972 	ldmdavs	r0!, {r1, r4, r5, r6, r8, fp, sp, lr}^
     35c:	6c617265 	sfmvs	f7, 2, [r1], #-404	; 0xfffffe6c
     360:	00682e73 	rsbeq	r2, r8, r3, ror lr
     364:	67000004 	strvs	r0, [r0, -r4]
     368:	2e6f6970 			; <UNDEFINED> instruction: 0x2e6f6970
     36c:	00050068 	andeq	r0, r5, r8, rrx
     370:	746e6900 	strbtvc	r6, [lr], #-2304	; 0xfffff700
     374:	2e666564 	cdpcs	5, 6, cr6, cr6, cr4, {3}
     378:	00040068 	andeq	r0, r4, r8, rrx
     37c:	01050000 	mrseq	r0, (UNDEF: 5)
     380:	2c020500 	cfstr32cs	mvfx0, [r2], {-0}
     384:	03000082 	movweq	r0, #130	; 0x82
     388:	0705010e 	streq	r0, [r5, -lr, lsl #2]
     38c:	21054b9f 			; <UNDEFINED> instruction: 0x21054b9f
     390:	8a09054c 	bhi	2418c8 <__bss_end+0x237d88>
     394:	054b0705 	strbeq	r0, [fp, #-1797]	; 0xfffff8fb
     398:	0705a019 	smladeq	r5, r9, r0, sl
     39c:	0e058786 	cdpeq	7, 0, cr8, cr5, cr6, {4}
     3a0:	2e0405a2 	cfsh32cs	mvfx0, mvfx4, #-46
     3a4:	a24c0a05 	subge	r0, ip, #20480	; 0x5000
     3a8:	05840d05 	streq	r0, [r4, #3333]	; 0xd05
     3ac:	07054d08 	streq	r4, [r5, -r8, lsl #26]
     3b0:	02666c03 	rsbeq	r6, r6, #768	; 0x300
     3b4:	0101000a 	tsteq	r1, sl
     3b8:	00000218 	andeq	r0, r0, r8, lsl r2
     3bc:	012d0003 			; <UNDEFINED> instruction: 0x012d0003
     3c0:	01020000 	mrseq	r0, (UNDEF: 2)
     3c4:	000d0efb 	strdeq	r0, [sp], -fp
     3c8:	01010101 	tsteq	r1, r1, lsl #2
     3cc:	01000000 	mrseq	r0, (UNDEF: 0)
     3d0:	2f010000 	svccs	0x00010000
     3d4:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
     3d8:	6572742f 	ldrbvs	r7, [r2, #-1071]!	; 0xfffffbd1
     3dc:	2f6c6966 	svccs	0x006c6966
     3e0:	2f6d6573 	svccs	0x006d6573
     3e4:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
     3e8:	2f736563 	svccs	0x00736563
     3ec:	6c647473 	cfstrdvs	mvd7, [r4], #-460	; 0xfffffe34
     3f0:	732f6269 			; <UNDEFINED> instruction: 0x732f6269
     3f4:	2f006372 	svccs	0x00006372
     3f8:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
     3fc:	6572742f 	ldrbvs	r7, [r2, #-1071]!	; 0xfffffbd1
     400:	2f6c6966 	svccs	0x006c6966
     404:	2f6d6573 	svccs	0x006d6573
     408:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
     40c:	2f736563 	svccs	0x00736563
     410:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
     414:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
     418:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
     41c:	702f6564 	eorvc	r6, pc, r4, ror #10
     420:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     424:	2f007373 	svccs	0x00007373
     428:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
     42c:	6572742f 	ldrbvs	r7, [r2, #-1071]!	; 0xfffffbd1
     430:	2f6c6966 	svccs	0x006c6966
     434:	2f6d6573 	svccs	0x006d6573
     438:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
     43c:	2f736563 	svccs	0x00736563
     440:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
     444:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
     448:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
     44c:	662f6564 	strtvs	r6, [pc], -r4, ror #10
     450:	682f0073 	stmdavs	pc!, {r0, r1, r4, r5, r6}	; <UNPREDICTABLE>
     454:	2f656d6f 	svccs	0x00656d6f
     458:	66657274 			; <UNDEFINED> instruction: 0x66657274
     45c:	732f6c69 			; <UNDEFINED> instruction: 0x732f6c69
     460:	732f6d65 			; <UNDEFINED> instruction: 0x732f6d65
     464:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
     468:	6b2f7365 	blvs	bdd204 <__bss_end+0xbd36c4>
     46c:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
     470:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
     474:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
     478:	6f622f65 	svcvs	0x00622f65
     47c:	2f647261 	svccs	0x00647261
     480:	30697072 	rsbcc	r7, r9, r2, ror r0
     484:	6c61682f 	stclvs	8, cr6, [r1], #-188	; 0xffffff44
     488:	74730000 	ldrbtvc	r0, [r3], #-0
     48c:	6c696664 	stclvs	6, cr6, [r9], #-400	; 0xfffffe70
     490:	70632e65 	rsbvc	r2, r3, r5, ror #28
     494:	00010070 	andeq	r0, r1, r0, ror r0
     498:	69777300 	ldmdbvs	r7!, {r8, r9, ip, sp, lr}^
     49c:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
     4a0:	70730000 	rsbsvc	r0, r3, r0
     4a4:	6f6c6e69 	svcvs	0x006c6e69
     4a8:	682e6b63 	stmdavs	lr!, {r0, r1, r5, r6, r8, r9, fp, sp, lr}
     4ac:	00000200 	andeq	r0, r0, r0, lsl #4
     4b0:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
     4b4:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
     4b8:	682e6d65 	stmdavs	lr!, {r0, r2, r5, r6, r8, sl, fp, sp, lr}
     4bc:	00000300 	andeq	r0, r0, r0, lsl #6
     4c0:	636f7270 	cmnvs	pc, #112, 4
     4c4:	2e737365 	cdpcs	3, 7, cr7, cr3, cr5, {3}
     4c8:	00020068 	andeq	r0, r2, r8, rrx
     4cc:	6f727000 	svcvs	0x00727000
     4d0:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     4d4:	6e616d5f 	mcrvs	13, 3, r6, cr1, cr15, {2}
     4d8:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     4dc:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
     4e0:	6e690000 	cdpvs	0, 6, cr0, cr9, cr0, {0}
     4e4:	66656474 			; <UNDEFINED> instruction: 0x66656474
     4e8:	0400682e 	streq	r6, [r0], #-2094	; 0xfffff7d2
     4ec:	05000000 	streq	r0, [r0, #-0]
     4f0:	02050001 	andeq	r0, r5, #1
     4f4:	00008308 	andeq	r8, r0, r8, lsl #6
     4f8:	69050516 	stmdbvs	r5, {r1, r2, r4, r8, sl}
     4fc:	4c0c052f 	cfstr32mi	mvfx0, [ip], {47}	; 0x2f
     500:	852f0105 	strhi	r0, [pc, #-261]!	; 403 <shift+0x403>
     504:	4b830505 	blmi	fe0c1920 <__bss_end+0xfe0b7de0>
     508:	852f0105 	strhi	r0, [pc, #-261]!	; 40b <shift+0x40b>
     50c:	054b0505 	strbeq	r0, [fp, #-1285]	; 0xfffffafb
     510:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
     514:	4b4ba105 	blmi	12e8930 <__bss_end+0x12dedf0>
     518:	4c0c052f 	cfstr32mi	mvfx0, [ip], {47}	; 0x2f
     51c:	852f0105 	strhi	r0, [pc, #-261]!	; 41f <shift+0x41f>
     520:	4bbd0505 	blmi	fef4193c <__bss_end+0xfef37dfc>
     524:	052f4b4b 	streq	r4, [pc, #-2891]!	; fffff9e1 <__bss_end+0xffff5ea1>
     528:	01054c0c 	tsteq	r5, ip, lsl #24
     52c:	0505862f 	streq	r8, [r5, #-1583]	; 0xfffff9d1
     530:	4b4b4bbd 	blmi	12d342c <__bss_end+0x12c98ec>
     534:	4c0c052f 	cfstr32mi	mvfx0, [ip], {47}	; 0x2f
     538:	852f0105 	strhi	r0, [pc, #-261]!	; 43b <shift+0x43b>
     53c:	4b830505 	blmi	fe0c1958 <__bss_end+0xfe0b7e18>
     540:	852f0105 	strhi	r0, [pc, #-261]!	; 443 <shift+0x443>
     544:	4bbd0505 	blmi	fef41960 <__bss_end+0xfef37e20>
     548:	052f4b4b 	streq	r4, [pc, #-2891]!	; fffffa05 <__bss_end+0xffff5ec5>
     54c:	01054c0c 	tsteq	r5, ip, lsl #24
     550:	0505852f 	streq	r8, [r5, #-1327]	; 0xfffffad1
     554:	2f4b4ba1 	svccs	0x004b4ba1
     558:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
     55c:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
     560:	4b4bbd05 	blmi	12ef97c <__bss_end+0x12e5e3c>
     564:	0c052f4b 	stceq	15, cr2, [r5], {75}	; 0x4b
     568:	2f01054c 	svccs	0x0001054c
     56c:	a1050585 	smlabbge	r5, r5, r5, r0
     570:	052f4b4b 	streq	r4, [pc, #-2891]!	; fffffa2d <__bss_end+0xffff5eed>
     574:	01054c0c 	tsteq	r5, ip, lsl #24
     578:	2005859f 	mulcs	r5, pc, r5	; <UNPREDICTABLE>
     57c:	4d050567 	cfstr32mi	mvfx0, [r5, #-412]	; 0xfffffe64
     580:	0c054b4b 			; <UNDEFINED> instruction: 0x0c054b4b
     584:	2f010530 	svccs	0x00010530
     588:	67200585 	strvs	r0, [r0, -r5, lsl #11]!
     58c:	4b4d0505 	blmi	13419a8 <__bss_end+0x1337e68>
     590:	300c054b 	andcc	r0, ip, fp, asr #10
     594:	852f0105 	strhi	r0, [pc, #-261]!	; 497 <shift+0x497>
     598:	05832005 	streq	r2, [r3, #5]
     59c:	4b4b4c05 	blmi	12d35b8 <__bss_end+0x12c9a78>
     5a0:	852f0105 	strhi	r0, [pc, #-261]!	; 4a3 <shift+0x4a3>
     5a4:	05672005 	strbeq	r2, [r7, #-5]!
     5a8:	4b4b4d05 	blmi	12d39c4 <__bss_end+0x12c9e84>
     5ac:	05300c05 	ldreq	r0, [r0, #-3077]!	; 0xfffff3fb
     5b0:	05872f01 	streq	r2, [r7, #3841]	; 0xf01
     5b4:	059fa00c 	ldreq	sl, [pc, #12]	; 5c8 <shift+0x5c8>
     5b8:	2905bc31 	stmdbcs	r5, {r0, r4, r5, sl, fp, ip, sp, pc}
     5bc:	2e360566 	cdpcs	5, 3, cr0, cr6, cr6, {3}
     5c0:	05300f05 	ldreq	r0, [r0, #-3845]!	; 0xfffff0fb
     5c4:	09056613 	stmdbeq	r5, {r0, r1, r4, r9, sl, sp, lr}
     5c8:	d8100584 	ldmdale	r0, {r2, r7, r8, sl}
     5cc:	029f0105 	addseq	r0, pc, #1073741825	; 0x40000001
     5d0:	01010008 	tsteq	r1, r8
     5d4:	000004fe 	strdeq	r0, [r0], -lr
     5d8:	00480003 	subeq	r0, r8, r3
     5dc:	01020000 	mrseq	r0, (UNDEF: 2)
     5e0:	000d0efb 	strdeq	r0, [sp], -fp
     5e4:	01010101 	tsteq	r1, r1, lsl #2
     5e8:	01000000 	mrseq	r0, (UNDEF: 0)
     5ec:	2f010000 	svccs	0x00010000
     5f0:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
     5f4:	6572742f 	ldrbvs	r7, [r2, #-1071]!	; 0xfffffbd1
     5f8:	2f6c6966 	svccs	0x006c6966
     5fc:	2f6d6573 	svccs	0x006d6573
     600:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
     604:	2f736563 	svccs	0x00736563
     608:	6c647473 	cfstrdvs	mvd7, [r4], #-460	; 0xfffffe34
     60c:	732f6269 			; <UNDEFINED> instruction: 0x732f6269
     610:	00006372 	andeq	r6, r0, r2, ror r3
     614:	73647473 	cmnvc	r4, #1929379840	; 0x73000000
     618:	6e697274 	mcrvs	2, 3, r7, cr9, cr4, {3}
     61c:	70632e67 	rsbvc	r2, r3, r7, ror #28
     620:	00010070 	andeq	r0, r1, r0, ror r0
     624:	01050000 	mrseq	r0, (UNDEF: 5)
     628:	68020500 	stmdavs	r2, {r8, sl}
     62c:	1a000087 	bne	850 <shift+0x850>
     630:	4bbb0905 	blmi	feec2a4c <__bss_end+0xfeeb8f0c>
     634:	054c0f05 	strbeq	r0, [ip, #-3845]	; 0xfffff0fb
     638:	2105681b 	tstcs	r5, fp, lsl r8
     63c:	9e0a052e 	cfsh32ls	mvfx0, mvfx10, #30
     640:	052e0b05 	streq	r0, [lr, #-2821]!	; 0xfffff4fb
     644:	0d054a27 	vstreq	s8, [r5, #-156]	; 0xffffff64
     648:	2f09054a 	svccs	0x0009054a
     64c:	05bb0405 	ldreq	r0, [fp, #1029]!	; 0x405
     650:	05056202 	streq	r6, [r5, #-514]	; 0xfffffdfe
     654:	68100535 	ldmdavs	r0, {r0, r2, r4, r5, r8, sl}
     658:	052e1105 	streq	r1, [lr, #-261]!	; 0xfffffefb
     65c:	13054a22 	movwne	r4, #23074	; 0x5a22
     660:	2f0a052e 	svccs	0x000a052e
     664:	05690905 	strbeq	r0, [r9, #-2309]!	; 0xfffff6fb
     668:	0c052e0a 	stceq	14, cr2, [r5], {10}
     66c:	4b03054a 	blmi	c1b9c <__bss_end+0xb805c>
     670:	02001005 	andeq	r1, r0, #5
     674:	05680204 	strbeq	r0, [r8, #-516]!	; 0xfffffdfc
     678:	0402000c 	streq	r0, [r2], #-12
     67c:	15059e02 	strne	r9, [r5, #-3586]	; 0xfffff1fe
     680:	01040200 	mrseq	r0, R12_usr
     684:	00180568 	andseq	r0, r8, r8, ror #10
     688:	82010402 	andhi	r0, r1, #33554432	; 0x2000000
     68c:	02000805 	andeq	r0, r0, #327680	; 0x50000
     690:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
     694:	0402001a 	streq	r0, [r2], #-26	; 0xffffffe6
     698:	1b054b01 	blne	1532a4 <__bss_end+0x149764>
     69c:	01040200 	mrseq	r0, R12_usr
     6a0:	000c052e 	andeq	r0, ip, lr, lsr #10
     6a4:	4a010402 	bmi	416b4 <__bss_end+0x37b74>
     6a8:	02000f05 	andeq	r0, r0, #5, 30
     6ac:	05820104 	streq	r0, [r2, #260]	; 0x104
     6b0:	0402001b 	streq	r0, [r2], #-27	; 0xffffffe5
     6b4:	11054a01 	tstne	r5, r1, lsl #20
     6b8:	01040200 	mrseq	r0, R12_usr
     6bc:	000a052e 	andeq	r0, sl, lr, lsr #10
     6c0:	2f010402 	svccs	0x00010402
     6c4:	02000b05 	andeq	r0, r0, #5120	; 0x1400
     6c8:	052e0104 	streq	r0, [lr, #-260]!	; 0xfffffefc
     6cc:	0402000d 	streq	r0, [r2], #-13
     6d0:	02054a01 	andeq	r4, r5, #4096	; 0x1000
     6d4:	01040200 	mrseq	r0, R12_usr
     6d8:	89010546 	stmdbhi	r1, {r1, r2, r6, r8, sl}
     6dc:	83060585 	movwhi	r0, #25989	; 0x6585
     6e0:	054c0905 	strbeq	r0, [ip, #-2309]	; 0xfffff6fb
     6e4:	0a054a10 	beq	152f2c <__bss_end+0x1493ec>
     6e8:	bb07054c 	bllt	1c1c20 <__bss_end+0x1b80e0>
     6ec:	054a0305 	strbeq	r0, [sl, #-773]	; 0xfffffcfb
     6f0:	04020017 	streq	r0, [r2], #-23	; 0xffffffe9
     6f4:	14054a01 	strne	r4, [r5], #-2561	; 0xfffff5ff
     6f8:	01040200 	mrseq	r0, R12_usr
     6fc:	4d0d054a 	cfstr32mi	mvfx0, [sp, #-296]	; 0xfffffed8
     700:	054a1405 	strbeq	r1, [sl, #-1029]	; 0xfffffbfb
     704:	08052e0a 	stmdaeq	r5, {r1, r3, r9, sl, fp, sp}
     708:	03020568 	movweq	r0, #9576	; 0x2568
     70c:	09056678 	stmdbeq	r5, {r3, r4, r5, r6, r9, sl, sp, lr}
     710:	052e0b03 	streq	r0, [lr, #-2819]!	; 0xfffff4fd
     714:	27052f01 	strcs	r2, [r5, -r1, lsl #30]
     718:	840a0586 	strhi	r0, [sl], #-1414	; 0xfffffa7a
     71c:	4b0b054b 	blmi	2c1c50 <__bss_end+0x2b8110>
     720:	054a1205 	strbeq	r1, [sl, #-517]	; 0xfffffdfb
     724:	09054b0e 	stmdbeq	r5, {r1, r2, r3, r8, r9, fp, lr}
     728:	00180567 	andseq	r0, r8, r7, ror #10
     72c:	66010402 	strvs	r0, [r1], -r2, lsl #8
     730:	02001505 	andeq	r1, r0, #20971520	; 0x1400000
     734:	05660104 	strbeq	r0, [r6, #-260]!	; 0xfffffefc
     738:	04020011 	streq	r0, [r2], #-17	; 0xffffffef
     73c:	1a054b02 	bne	15334c <__bss_end+0x14980c>
     740:	02040200 	andeq	r0, r4, #0, 4
     744:	0012054b 	andseq	r0, r2, fp, asr #10
     748:	4b020402 	blmi	81758 <__bss_end+0x77c18>
     74c:	02000d05 	andeq	r0, r0, #320	; 0x140
     750:	05670204 	strbeq	r0, [r7, #-516]!	; 0xfffffdfc
     754:	14053109 	strne	r3, [r5], #-265	; 0xfffffef7
     758:	02040200 	andeq	r0, r4, #0, 4
     75c:	00260566 	eoreq	r0, r6, r6, ror #10
     760:	66030402 	strvs	r0, [r3], -r2, lsl #8
     764:	054c0905 	strbeq	r0, [ip, #-2309]	; 0xfffff6fb
     768:	0a05671a 	beq	15a3d8 <__bss_end+0x150898>
     76c:	0305054b 	movweq	r0, #21835	; 0x554b
     770:	0f036673 	svceq	0x00036673
     774:	001c052e 	andseq	r0, ip, lr, lsr #10
     778:	66010402 	strvs	r0, [r1], -r2, lsl #8
     77c:	004c0f05 	subeq	r0, ip, r5, lsl #30
     780:	06010402 	streq	r0, [r1], -r2, lsl #8
     784:	00130566 	andseq	r0, r3, r6, ror #10
     788:	06010402 	streq	r0, [r1], -r2, lsl #8
     78c:	000f052e 	andeq	r0, pc, lr, lsr #10
     790:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
     794:	052e1305 	streq	r1, [lr, #-773]!	; 0xfffffcfb
     798:	1e053001 	cdpne	0, 0, cr3, cr5, cr1, {0}
     79c:	830c0586 	movwhi	r0, #50566	; 0xc586
     7a0:	09056867 	stmdbeq	r5, {r0, r1, r2, r5, r6, fp, sp, lr}
     7a4:	0a054b67 	beq	153548 <__bss_end+0x149a08>
     7a8:	4c0b054b 	cfstr32mi	mvfx0, [fp], {75}	; 0x4b
     7ac:	054a1205 	strbeq	r1, [sl, #-517]	; 0xfffffdfb
     7b0:	09054b0d 	stmdbeq	r5, {r0, r2, r3, r8, r9, fp, lr}
     7b4:	001b054a 	andseq	r0, fp, sl, asr #10
     7b8:	4b010402 	blmi	417c8 <__bss_end+0x37c88>
     7bc:	02001205 	andeq	r1, r0, #1342177280	; 0x50000000
     7c0:	054b0104 	strbeq	r0, [fp, #-260]	; 0xfffffefc
     7c4:	0402000d 	streq	r0, [r2], #-13
     7c8:	12056701 	andne	r6, r5, #262144	; 0x40000
     7cc:	4a0e0530 	bmi	381c94 <__bss_end+0x378154>
     7d0:	02002205 	andeq	r2, r0, #1342177280	; 0x50000000
     7d4:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
     7d8:	0402001f 	streq	r0, [r2], #-31	; 0xffffffe1
     7dc:	16054a01 	strne	r4, [r5], -r1, lsl #20
     7e0:	4a1d054b 	bmi	741d14 <__bss_end+0x7381d4>
     7e4:	052e1005 	streq	r1, [lr, #-5]!
     7e8:	13056709 	movwne	r6, #22281	; 0x5709
     7ec:	d7230567 	strle	r0, [r3, -r7, ror #10]!
     7f0:	059e1405 	ldreq	r1, [lr, #1029]	; 0x405
     7f4:	1405851d 	strne	r8, [r5], #-1309	; 0xfffffae3
     7f8:	680e0566 	stmdavs	lr, {r1, r2, r5, r6, r8, sl}
     7fc:	71030505 	tstvc	r3, r5, lsl #10
     800:	030c0566 	movweq	r0, #50534	; 0xc566
     804:	01052e11 	tsteq	r5, r1, lsl lr
     808:	0522084b 	streq	r0, [r2, #-2123]!	; 0xfffff7b5
     80c:	1605bd09 	strne	fp, [r5], -r9, lsl #26
     810:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
     814:	001d054a 	andseq	r0, sp, sl, asr #10
     818:	82020402 	andhi	r0, r2, #33554432	; 0x2000000
     81c:	02001e05 	andeq	r1, r0, #5, 28	; 0x50
     820:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
     824:	04020016 	streq	r0, [r2], #-22	; 0xffffffea
     828:	11056602 	tstne	r5, r2, lsl #12
     82c:	03040200 	movweq	r0, #16896	; 0x4200
     830:	0012054b 	andseq	r0, r2, fp, asr #10
     834:	2e030402 	cdpcs	4, 0, cr0, cr3, cr2, {0}
     838:	02000805 	andeq	r0, r0, #327680	; 0x50000
     83c:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
     840:	04020009 	streq	r0, [r2], #-9
     844:	12052e03 	andne	r2, r5, #3, 28	; 0x30
     848:	03040200 	movweq	r0, #16896	; 0x4200
     84c:	000b054a 	andeq	r0, fp, sl, asr #10
     850:	2e030402 	cdpcs	4, 0, cr0, cr3, cr2, {0}
     854:	02000205 	andeq	r0, r0, #1342177280	; 0x50000000
     858:	052d0304 	streq	r0, [sp, #-772]!	; 0xfffffcfc
     85c:	0402000b 	streq	r0, [r2], #-11
     860:	08058402 	stmdaeq	r5, {r1, sl, pc}
     864:	01040200 	mrseq	r0, R12_usr
     868:	00090583 	andeq	r0, r9, r3, lsl #11
     86c:	2e010402 	cdpcs	4, 0, cr0, cr1, cr2, {0}
     870:	02000b05 	andeq	r0, r0, #5120	; 0x1400
     874:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
     878:	04020002 	streq	r0, [r2], #-2
     87c:	0b054901 	bleq	152c88 <__bss_end+0x149148>
     880:	2f010585 	svccs	0x00010585
     884:	bc0e0585 	cfstr32lt	mvfx0, [lr], {133}	; 0x85
     888:	05661105 	strbeq	r1, [r6, #-261]!	; 0xfffffefb
     88c:	0b05bc20 	bleq	16f914 <__bss_end+0x165dd4>
     890:	4b1f0566 	blmi	7c1e30 <__bss_end+0x7b82f0>
     894:	05660a05 	strbeq	r0, [r6, #-2565]!	; 0xfffff5fb
     898:	11054b08 	tstne	r5, r8, lsl #22
     89c:	2e160583 	cdpcs	5, 1, cr0, cr6, cr3, {4}
     8a0:	05670805 	strbeq	r0, [r7, #-2053]!	; 0xfffff7fb
     8a4:	0b056711 	bleq	15a4f0 <__bss_end+0x1509b0>
     8a8:	2f01054d 	svccs	0x0001054d
     8ac:	83060585 	movwhi	r0, #25989	; 0x6585
     8b0:	054c0b05 	strbeq	r0, [ip, #-2821]	; 0xfffff4fb
     8b4:	0e052e0c 	cdpeq	14, 0, cr2, cr5, cr12, {0}
     8b8:	4b040566 	blmi	101e58 <__bss_end+0xf8318>
     8bc:	05650205 	strbeq	r0, [r5, #-517]!	; 0xfffffdfb
     8c0:	01053109 	tsteq	r5, r9, lsl #2
     8c4:	852a052f 	strhi	r0, [sl, #-1327]!	; 0xfffffad1
     8c8:	679f1305 	ldrvs	r1, [pc, r5, lsl #6]
     8cc:	05670905 	strbeq	r0, [r7, #-2309]!	; 0xfffff6fb
     8d0:	15054b0d 	strne	r4, [r5, #-2829]	; 0xfffff4f3
     8d4:	03040200 	movweq	r0, #16896	; 0x4200
     8d8:	0019054a 	andseq	r0, r9, sl, asr #10
     8dc:	83020402 	movwhi	r0, #9218	; 0x2402
     8e0:	02001a05 	andeq	r1, r0, #20480	; 0x5000
     8e4:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
     8e8:	0402000f 	streq	r0, [r2], #-15
     8ec:	11054a02 	tstne	r5, r2, lsl #20
     8f0:	02040200 	andeq	r0, r4, #0, 4
     8f4:	001a0582 	andseq	r0, sl, r2, lsl #11
     8f8:	4a020402 	bmi	81908 <__bss_end+0x77dc8>
     8fc:	02001305 	andeq	r1, r0, #335544320	; 0x14000000
     900:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
     904:	04020005 	streq	r0, [r2], #-5
     908:	0a052d02 	beq	14bd18 <__bss_end+0x1421d8>
     90c:	2e0b0584 	cfsh32cs	mvfx0, mvfx11, #-60
     910:	054a0d05 	strbeq	r0, [sl, #-3333]	; 0xfffff2fb
     914:	01054b0c 	tsteq	r5, ip, lsl #22
     918:	67340530 			; <UNDEFINED> instruction: 0x67340530
     91c:	05bb0905 	ldreq	r0, [fp, #2309]!	; 0x905
     920:	05054c13 	streq	r4, [r5, #-3091]	; 0xfffff3ed
     924:	00190568 	andseq	r0, r9, r8, ror #10
     928:	82010402 	andhi	r0, r1, #33554432	; 0x2000000
     92c:	054c0d05 	strbeq	r0, [ip, #-3333]	; 0xfffff2fb
     930:	04020015 	streq	r0, [r2], #-21	; 0xffffffeb
     934:	10054a01 	andne	r4, r5, r1, lsl #20
     938:	2e110583 	cdpcs	5, 1, cr0, cr1, cr3, {4}
     93c:	05660905 	strbeq	r0, [r6, #-2309]!	; 0xfffff6fb
     940:	04020019 	streq	r0, [r2], #-25	; 0xffffffe7
     944:	1a054b02 	bne	153554 <__bss_end+0x149a14>
     948:	02040200 	andeq	r0, r4, #0, 4
     94c:	000f052e 	andeq	r0, pc, lr, lsr #10
     950:	4a020402 	bmi	81960 <__bss_end+0x77e20>
     954:	02001105 	andeq	r1, r0, #1073741825	; 0x40000001
     958:	05820204 	streq	r0, [r2, #516]	; 0x204
     95c:	0402001a 	streq	r0, [r2], #-26	; 0xffffffe6
     960:	13054a02 	movwne	r4, #23042	; 0x5a02
     964:	02040200 	andeq	r0, r4, #0, 4
     968:	0005052e 	andeq	r0, r5, lr, lsr #10
     96c:	2c020402 	cfstrscs	mvf0, [r2], {2}
     970:	05831b05 	streq	r1, [r3, #2821]	; 0xb05
     974:	0b05310a 	bleq	14cda4 <__bss_end+0x143264>
     978:	4a0d052e 	bmi	341e38 <__bss_end+0x3382f8>
     97c:	054b0c05 	strbeq	r0, [fp, #-3077]	; 0xfffff3fb
     980:	056a3001 	strbeq	r3, [sl, #-1]!
     984:	0b059f08 	bleq	1685ac <__bss_end+0x15ea6c>
     988:	0014054c 	andseq	r0, r4, ip, asr #10
     98c:	4a030402 	bmi	c199c <__bss_end+0xb7e5c>
     990:	02000705 	andeq	r0, r0, #1310720	; 0x140000
     994:	05830204 	streq	r0, [r3, #516]	; 0x204
     998:	04020008 	streq	r0, [r2], #-8
     99c:	0a052e02 	beq	14c1ac <__bss_end+0x14266c>
     9a0:	02040200 	andeq	r0, r4, #0, 4
     9a4:	0002054a 	andeq	r0, r2, sl, asr #10
     9a8:	49020402 	stmdbmi	r2, {r1, sl}
     9ac:	85840105 	strhi	r0, [r4, #261]	; 0x105
     9b0:	05bb0e05 	ldreq	r0, [fp, #3589]!	; 0xe05
     9b4:	0b054b08 	bleq	1535dc <__bss_end+0x149a9c>
     9b8:	0014054c 	andseq	r0, r4, ip, asr #10
     9bc:	4a030402 	bmi	c19cc <__bss_end+0xb7e8c>
     9c0:	02001605 	andeq	r1, r0, #5242880	; 0x500000
     9c4:	05830204 	streq	r0, [r3, #516]	; 0x204
     9c8:	04020017 	streq	r0, [r2], #-23	; 0xffffffe9
     9cc:	0a052e02 	beq	14c1dc <__bss_end+0x14269c>
     9d0:	02040200 	andeq	r0, r4, #0, 4
     9d4:	000b054a 	andeq	r0, fp, sl, asr #10
     9d8:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
     9dc:	02001705 	andeq	r1, r0, #1310720	; 0x140000
     9e0:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
     9e4:	0402000d 	streq	r0, [r2], #-13
     9e8:	02052e02 	andeq	r2, r5, #2, 28
     9ec:	02040200 	andeq	r0, r4, #0, 4
     9f0:	8401052d 	strhi	r0, [r1], #-1325	; 0xfffffad3
     9f4:	9f090587 	svcls	0x00090587
     9f8:	054b1005 	strbeq	r1, [fp, #-5]
     9fc:	10056613 	andne	r6, r5, r3, lsl r6
     a00:	810505bb 			; <UNDEFINED> instruction: 0x810505bb
     a04:	05310c05 	ldreq	r0, [r1, #-3077]!	; 0xfffff3fb
     a08:	05862f01 	streq	r2, [r6, #3841]	; 0xf01
     a0c:	0505a20a 	streq	sl, [r5, #-522]	; 0xfffffdf6
     a10:	840e0567 	strhi	r0, [lr], #-1383	; 0xfffffa99
     a14:	05670b05 	strbeq	r0, [r7, #-2821]!	; 0xfffff4fb
     a18:	0c05690d 			; <UNDEFINED> instruction: 0x0c05690d
     a1c:	0d059f4b 	stceq	15, cr9, [r5, #-300]	; 0xfffffed4
     a20:	69170567 	ldmdbvs	r7, {r0, r1, r2, r5, r6, r8, sl}
     a24:	05661505 	strbeq	r1, [r6, #-1285]!	; 0xfffffafb
     a28:	3d054a2d 	vstrcc	s8, [r5, #-180]	; 0xffffff4c
     a2c:	01040200 	mrseq	r0, R12_usr
     a30:	003b0566 	eorseq	r0, fp, r6, ror #10
     a34:	66010402 	strvs	r0, [r1], -r2, lsl #8
     a38:	02002d05 	andeq	r2, r0, #320	; 0x140
     a3c:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
     a40:	1c05682b 	stcne	8, cr6, [r5], {43}	; 0x2b
     a44:	8215054a 	andshi	r0, r5, #310378496	; 0x12800000
     a48:	052e1105 	streq	r1, [lr, #-261]!	; 0xfffffefb
     a4c:	05a06710 	streq	r6, [r0, #1808]!	; 0x710
     a50:	16057d05 	strne	r7, [r5], -r5, lsl #26
     a54:	052e0903 	streq	r0, [lr, #-2307]!	; 0xfffff6fd
     a58:	1105d61b 	tstne	r5, fp, lsl r6
     a5c:	0026054a 	eoreq	r0, r6, sl, asr #10
     a60:	ba030402 	blt	c1a70 <__bss_end+0xb7f30>
     a64:	02000b05 	andeq	r0, r0, #5120	; 0x1400
     a68:	059f0204 	ldreq	r0, [pc, #516]	; c74 <shift+0xc74>
     a6c:	04020005 	streq	r0, [r2], #-5
     a70:	0e058102 	mvfeqs	f0, f2
     a74:	4b1505f5 	blmi	542250 <__bss_end+0x538710>
     a78:	d7660c05 	strble	r0, [r6, -r5, lsl #24]!
     a7c:	059f0505 	ldreq	r0, [pc, #1285]	; f89 <shift+0xf89>
     a80:	1105840f 	tstne	r5, pc, lsl #8
     a84:	d90c05d7 	stmdble	ip, {r0, r1, r2, r4, r6, r7, r8, sl}
     a88:	02001805 	andeq	r1, r0, #327680	; 0x50000
     a8c:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
     a90:	10056809 	andne	r6, r5, r9, lsl #16
     a94:	6612059f 			; <UNDEFINED> instruction: 0x6612059f
     a98:	05670e05 	strbeq	r0, [r7, #-3589]!	; 0xfffff1fb
     a9c:	12059f10 	andne	r9, r5, #16, 30	; 0x40
     aa0:	670e0566 	strvs	r0, [lr, -r6, ror #10]
     aa4:	02001d05 	andeq	r1, r0, #320	; 0x140
     aa8:	05820104 	streq	r0, [r2, #260]	; 0x104
     aac:	12056710 	andne	r6, r5, #16, 14	; 0x400000
     ab0:	691c0566 	ldmdbvs	ip, {r1, r2, r5, r6, r8, sl}
     ab4:	05822205 	streq	r2, [r2, #517]	; 0x205
     ab8:	22052e10 	andcs	r2, r5, #16, 28	; 0x100
     abc:	4a120566 	bmi	48205c <__bss_end+0x47851c>
     ac0:	052f1405 	streq	r1, [pc, #-1029]!	; 6c3 <shift+0x6c3>
     ac4:	04020005 	streq	r0, [r2], #-5
     ac8:	d6750302 	ldrbtle	r0, [r5], -r2, lsl #6
     acc:	0e030105 	adfeqs	f0, f3, f5
     ad0:	000a029e 	muleq	sl, lr, r2
     ad4:	00790101 	rsbseq	r0, r9, r1, lsl #2
     ad8:	00030000 	andeq	r0, r3, r0
     adc:	00000046 	andeq	r0, r0, r6, asr #32
     ae0:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
     ae4:	0101000d 	tsteq	r1, sp
     ae8:	00000101 	andeq	r0, r0, r1, lsl #2
     aec:	00000100 	andeq	r0, r0, r0, lsl #2
     af0:	2f2e2e01 	svccs	0x002e2e01
     af4:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     af8:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     afc:	2f2e2e2f 	svccs	0x002e2e2f
     b00:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; a50 <shift+0xa50>
     b04:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
     b08:	6f632f63 	svcvs	0x00632f63
     b0c:	6769666e 	strbvs	r6, [r9, -lr, ror #12]!
     b10:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
     b14:	696c0000 	stmdbvs	ip!, {}^	; <UNPREDICTABLE>
     b18:	75663162 	strbvc	r3, [r6, #-354]!	; 0xfffffe9e
     b1c:	2e73636e 	cdpcs	3, 7, cr6, cr3, cr14, {3}
     b20:	00010053 	andeq	r0, r1, r3, asr r0
     b24:	05000000 	streq	r0, [r0, #-0]
     b28:	00939402 	addseq	r9, r3, r2, lsl #8
     b2c:	08cf0300 	stmiaeq	pc, {r8, r9}^	; <UNPREDICTABLE>
     b30:	2f2f3001 	svccs	0x002f3001
     b34:	302f2f2f 	eorcc	r2, pc, pc, lsr #30
     b38:	1401d002 	strne	sp, [r1], #-2
     b3c:	2f2f312f 	svccs	0x002f312f
     b40:	322f4c30 	eorcc	r4, pc, #48, 24	; 0x3000
     b44:	2f661f03 	svccs	0x00661f03
     b48:	2f2f2f2f 	svccs	0x002f2f2f
     b4c:	02022f2f 	andeq	r2, r2, #47, 30	; 0xbc
     b50:	5c010100 	stfpls	f0, [r1], {-0}
     b54:	03000000 	movweq	r0, #0
     b58:	00004600 	andeq	r4, r0, r0, lsl #12
     b5c:	fb010200 	blx	41366 <__bss_end+0x37826>
     b60:	01000d0e 	tsteq	r0, lr, lsl #26
     b64:	00010101 	andeq	r0, r1, r1, lsl #2
     b68:	00010000 	andeq	r0, r1, r0
     b6c:	2e2e0100 	sufcse	f0, f6, f0
     b70:	2f2e2e2f 	svccs	0x002e2e2f
     b74:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     b78:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     b7c:	2f2e2e2f 	svccs	0x002e2e2f
     b80:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
     b84:	632f6363 			; <UNDEFINED> instruction: 0x632f6363
     b88:	69666e6f 	stmdbvs	r6!, {r0, r1, r2, r3, r5, r6, r9, sl, fp, sp, lr}^
     b8c:	72612f67 	rsbvc	r2, r1, #412	; 0x19c
     b90:	6c00006d 	stcvs	0, cr0, [r0], {109}	; 0x6d
     b94:	66316269 	ldrtvs	r6, [r1], -r9, ror #4
     b98:	73636e75 	cmnvc	r3, #1872	; 0x750
     b9c:	0100532e 	tsteq	r0, lr, lsr #6
     ba0:	00000000 	andeq	r0, r0, r0
     ba4:	95a00205 	strls	r0, [r0, #517]!	; 0x205
     ba8:	b9030000 	stmdblt	r3, {}	; <UNPREDICTABLE>
     bac:	0202010b 	andeq	r0, r2, #-1073741822	; 0xc0000002
     bb0:	fb010100 	blx	40fba <__bss_end+0x3747a>
     bb4:	03000000 	movweq	r0, #0
     bb8:	00004700 	andeq	r4, r0, r0, lsl #14
     bbc:	fb010200 	blx	413c6 <__bss_end+0x37886>
     bc0:	01000d0e 	tsteq	r0, lr, lsl #26
     bc4:	00010101 	andeq	r0, r1, r1, lsl #2
     bc8:	00010000 	andeq	r0, r1, r0
     bcc:	2e2e0100 	sufcse	f0, f6, f0
     bd0:	2f2e2e2f 	svccs	0x002e2e2f
     bd4:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     bd8:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     bdc:	2f2e2e2f 	svccs	0x002e2e2f
     be0:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
     be4:	632f6363 			; <UNDEFINED> instruction: 0x632f6363
     be8:	69666e6f 	stmdbvs	r6!, {r0, r1, r2, r3, r5, r6, r9, sl, fp, sp, lr}^
     bec:	72612f67 	rsbvc	r2, r1, #412	; 0x19c
     bf0:	6900006d 	stmdbvs	r0, {r0, r2, r3, r5, r6}
     bf4:	37656565 	strbcc	r6, [r5, -r5, ror #10]!
     bf8:	732d3435 			; <UNDEFINED> instruction: 0x732d3435
     bfc:	00532e66 	subseq	r2, r3, r6, ror #28
     c00:	00000001 	andeq	r0, r0, r1
     c04:	a4020500 	strge	r0, [r2], #-1280	; 0xfffffb00
     c08:	03000095 	movweq	r0, #149	; 0x95
     c0c:	332f013a 			; <UNDEFINED> instruction: 0x332f013a
     c10:	302e0903 	eorcc	r0, lr, r3, lsl #18
     c14:	2f2f2f2f 	svccs	0x002f2f2f
     c18:	2f302f32 	svccs	0x00302f32
     c1c:	33302f2f 	teqcc	r0, #47, 30	; 0xbc
     c20:	2f2f3130 	svccs	0x002f3130
     c24:	2f2f2f30 	svccs	0x002f2f30
     c28:	322f3230 	eorcc	r3, pc, #48, 4
     c2c:	312f2f32 			; <UNDEFINED> instruction: 0x312f2f32
     c30:	332f332f 			; <UNDEFINED> instruction: 0x332f332f
     c34:	312f2f2f 			; <UNDEFINED> instruction: 0x312f2f2f
     c38:	2f312f2f 	svccs	0x00312f2f
     c3c:	2f302f35 	svccs	0x00302f35
     c40:	2f2f322f 	svccs	0x002f322f
     c44:	19032f30 	stmdbne	r3, {r4, r5, r8, r9, sl, fp, sp}
     c48:	2f2f2f2e 	svccs	0x002f2f2e
     c4c:	342f2f35 	strtcc	r2, [pc], #-3893	; c54 <shift+0xc54>
     c50:	302f3330 	eorcc	r3, pc, r0, lsr r3	; <UNPREDICTABLE>
     c54:	312f2f2f 			; <UNDEFINED> instruction: 0x312f2f2f
     c58:	302f3030 	eorcc	r3, pc, r0, lsr r0	; <UNPREDICTABLE>
     c5c:	2f30312f 	svccs	0x0030312f
     c60:	312f3230 			; <UNDEFINED> instruction: 0x312f3230
     c64:	2f302f2f 	svccs	0x00302f2f
     c68:	2f2f302f 	svccs	0x002f302f
     c6c:	032f2f32 			; <UNDEFINED> instruction: 0x032f2f32
     c70:	2f302e09 	svccs	0x00302e09
     c74:	2f302f2f 	svccs	0x00302f2f
     c78:	0d032f2f 	stceq	15, cr2, [r3, #-188]	; 0xffffff44
     c7c:	30332f2e 	eorscc	r2, r3, lr, lsr #30
     c80:	31313030 	teqcc	r1, r0, lsr r0
     c84:	0c032f30 	stceq	15, cr2, [r3], {48}	; 0x30
     c88:	2f30302e 	svccs	0x0030302e
     c8c:	2f303033 	svccs	0x00303033
     c90:	30312f33 	eorscc	r2, r1, r3, lsr pc
     c94:	30312f2f 	eorscc	r2, r1, pc, lsr #30
     c98:	2e19032f 	cdpcs	3, 1, cr0, cr9, cr15, {1}
     c9c:	302f322f 	eorcc	r3, pc, pc, lsr #4
     ca0:	2f2f2f2f 	svccs	0x002f2f2f
     ca4:	2f302f30 	svccs	0x00302f30
     ca8:	302f2f2f 	eorcc	r2, pc, pc, lsr #30
     cac:	0002022f 	andeq	r0, r2, pc, lsr #4
     cb0:	007a0101 	rsbseq	r0, sl, r1, lsl #2
     cb4:	00030000 	andeq	r0, r3, r0
     cb8:	00000042 	andeq	r0, r0, r2, asr #32
     cbc:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
     cc0:	0101000d 	tsteq	r1, sp
     cc4:	00000101 	andeq	r0, r0, r1, lsl #2
     cc8:	00000100 	andeq	r0, r0, r0, lsl #2
     ccc:	2f2e2e01 	svccs	0x002e2e01
     cd0:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     cd4:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     cd8:	2f2e2e2f 	svccs	0x002e2e2f
     cdc:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; c2c <shift+0xc2c>
     ce0:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
     ce4:	6f632f63 	svcvs	0x00632f63
     ce8:	6769666e 	strbvs	r6, [r9, -lr, ror #12]!
     cec:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
     cf0:	70620000 	rsbvc	r0, r2, r0
     cf4:	2e696261 	cdpcs	2, 6, cr6, cr9, cr1, {3}
     cf8:	00010053 	andeq	r0, r1, r3, asr r0
     cfc:	05000000 	streq	r0, [r0, #-0]
     d00:	0097f402 	addseq	pc, r7, r2, lsl #8
     d04:	01b90300 			; <UNDEFINED> instruction: 0x01b90300
     d08:	4b5a0801 	blmi	1682d14 <__bss_end+0x16791d4>
     d0c:	302f2f2f 	eorcc	r2, pc, pc, lsr #30
     d10:	2f326730 	svccs	0x00326730
     d14:	30302f2f 	eorscc	r2, r0, pc, lsr #30
     d18:	2f2f2f67 	svccs	0x002f2f67
     d1c:	302f322f 	eorcc	r3, pc, pc, lsr #4
     d20:	2f2f6730 	svccs	0x002f6730
     d24:	2f302f32 	svccs	0x00302f32
     d28:	022f2f67 	eoreq	r2, pc, #412	; 0x19c
     d2c:	01010002 	tsteq	r1, r2
     d30:	000000a4 	andeq	r0, r0, r4, lsr #1
     d34:	009e0003 	addseq	r0, lr, r3
     d38:	01020000 	mrseq	r0, (UNDEF: 2)
     d3c:	000d0efb 	strdeq	r0, [sp], -fp
     d40:	01010101 	tsteq	r1, r1, lsl #2
     d44:	01000000 	mrseq	r0, (UNDEF: 0)
     d48:	2e010000 	cdpcs	0, 0, cr0, cr1, cr0, {0}
     d4c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     d50:	2f2e2e2f 	svccs	0x002e2e2f
     d54:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     d58:	2f2e2f2e 	svccs	0x002e2f2e
     d5c:	00636367 	rsbeq	r6, r3, r7, ror #6
     d60:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     d64:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     d68:	2f2e2e2f 	svccs	0x002e2e2f
     d6c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     d70:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
     d74:	63636762 	cmnvs	r3, #25690112	; 0x1880000
     d78:	2f2e2e2f 	svccs	0x002e2e2f
     d7c:	2f636367 	svccs	0x00636367
     d80:	666e6f63 	strbtvs	r6, [lr], -r3, ror #30
     d84:	612f6769 			; <UNDEFINED> instruction: 0x612f6769
     d88:	2e006d72 	mcrcs	13, 0, r6, cr0, cr2, {3}
     d8c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     d90:	2f2e2e2f 	svccs	0x002e2e2f
     d94:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     d98:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     d9c:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
     da0:	00636367 	rsbeq	r6, r3, r7, ror #6
     da4:	6d726100 	ldfvse	f6, [r2, #-0]
     da8:	6173692d 	cmnvs	r3, sp, lsr #18
     dac:	0100682e 	tsteq	r0, lr, lsr #16
     db0:	72610000 	rsbvc	r0, r1, #0
     db4:	00682e6d 	rsbeq	r2, r8, sp, ror #28
     db8:	67000002 	strvs	r0, [r0, -r2]
     dbc:	632d6c62 			; <UNDEFINED> instruction: 0x632d6c62
     dc0:	73726f74 	cmnvc	r2, #116, 30	; 0x1d0
     dc4:	0300682e 	movweq	r6, #2094	; 0x82e
     dc8:	696c0000 	stmdbvs	ip!, {}^	; <UNPREDICTABLE>
     dcc:	63636762 	cmnvs	r3, #25690112	; 0x1880000
     dd0:	00632e32 	rsbeq	r2, r3, r2, lsr lr
     dd4:	00000003 	andeq	r0, r0, r3
     dd8:	000000a7 	andeq	r0, r0, r7, lsr #1
     ddc:	00680003 	rsbeq	r0, r8, r3
     de0:	01020000 	mrseq	r0, (UNDEF: 2)
     de4:	000d0efb 	strdeq	r0, [sp], -fp
     de8:	01010101 	tsteq	r1, r1, lsl #2
     dec:	01000000 	mrseq	r0, (UNDEF: 0)
     df0:	2e010000 	cdpcs	0, 0, cr0, cr1, cr0, {0}
     df4:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     df8:	2f2e2e2f 	svccs	0x002e2e2f
     dfc:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     e00:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     e04:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
     e08:	00636367 	rsbeq	r6, r3, r7, ror #6
     e0c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     e10:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     e14:	2f2e2e2f 	svccs	0x002e2e2f
     e18:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     e1c:	6363672f 	cmnvs	r3, #12320768	; 0xbc0000
     e20:	696c0000 	stmdbvs	ip!, {}^	; <UNPREDICTABLE>
     e24:	63636762 	cmnvs	r3, #25690112	; 0x1880000
     e28:	00632e32 	rsbeq	r2, r3, r2, lsr lr
     e2c:	61000001 	tstvs	r0, r1
     e30:	692d6d72 	pushvs	{r1, r4, r5, r6, r8, sl, fp, sp, lr}
     e34:	682e6173 	stmdavs	lr!, {r0, r1, r4, r5, r6, r8, sp, lr}
     e38:	00000200 	andeq	r0, r0, r0, lsl #4
     e3c:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
     e40:	2e326363 	cdpcs	3, 3, cr6, cr2, cr3, {3}
     e44:	00010068 	andeq	r0, r1, r8, rrx
     e48:	01050000 	mrseq	r0, (UNDEF: 5)
     e4c:	c8020500 	stmdagt	r2, {r8, sl}
     e50:	03000098 	movweq	r0, #152	; 0x98
     e54:	05010bf9 	streq	r0, [r1, #-3065]	; 0xfffff407
     e58:	01051303 	tsteq	r5, r3, lsl #6
     e5c:	06051106 	streq	r1, [r5], -r6, lsl #2
     e60:	0603052f 	streq	r0, [r3], -pc, lsr #10
     e64:	060a0568 	streq	r0, [sl], -r8, ror #10
     e68:	06050501 	streq	r0, [r5], -r1, lsl #10
     e6c:	060e052d 	streq	r0, [lr], -sp, lsr #10
     e70:	2c010501 	cfstr32cs	mvfx0, [r1], {1}
     e74:	2e300e05 	cdpcs	14, 3, cr0, cr0, cr5, {0}
     e78:	052e0c05 	streq	r0, [lr, #-3077]!	; 0xfffff3fb
     e7c:	02024c01 	andeq	r4, r2, #256	; 0x100
     e80:	b6010100 	strlt	r0, [r1], -r0, lsl #2
     e84:	03000000 	movweq	r0, #0
     e88:	00006800 	andeq	r6, r0, r0, lsl #16
     e8c:	fb010200 	blx	41696 <__bss_end+0x37b56>
     e90:	01000d0e 	tsteq	r0, lr, lsl #26
     e94:	00010101 	andeq	r0, r1, r1, lsl #2
     e98:	00010000 	andeq	r0, r1, r0
     e9c:	2e2e0100 	sufcse	f0, f6, f0
     ea0:	2f2e2e2f 	svccs	0x002e2e2f
     ea4:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     ea8:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     eac:	2f2e2e2f 	svccs	0x002e2e2f
     eb0:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
     eb4:	2e006363 	cdpcs	3, 0, cr6, cr0, cr3, {3}
     eb8:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     ebc:	2f2e2e2f 	svccs	0x002e2e2f
     ec0:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     ec4:	2f2e2f2e 	svccs	0x002e2f2e
     ec8:	00636367 	rsbeq	r6, r3, r7, ror #6
     ecc:	62696c00 	rsbvs	r6, r9, #0, 24
     ed0:	32636367 	rsbcc	r6, r3, #-1677721599	; 0x9c000001
     ed4:	0100632e 	tsteq	r0, lr, lsr #6
     ed8:	72610000 	rsbvc	r0, r1, #0
     edc:	73692d6d 	cmnvc	r9, #6976	; 0x1b40
     ee0:	00682e61 	rsbeq	r2, r8, r1, ror #28
     ee4:	6c000002 	stcvs	0, cr0, [r0], {2}
     ee8:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
     eec:	682e3263 	stmdavs	lr!, {r0, r1, r5, r6, r9, ip, sp}
     ef0:	00000100 	andeq	r0, r0, r0, lsl #2
     ef4:	00010500 	andeq	r0, r1, r0, lsl #10
     ef8:	98f80205 	ldmls	r8!, {r0, r2, r9}^
     efc:	b9030000 	stmdblt	r3, {}	; <UNPREDICTABLE>
     f00:	0305010b 	movweq	r0, #20747	; 0x510b
     f04:	06100517 			; <UNDEFINED> instruction: 0x06100517
     f08:	33190501 	tstcc	r9, #4194304	; 0x400000
     f0c:	05332705 	ldreq	r2, [r3, #-1797]!	; 0xfffff8fb
     f10:	2e760310 	mrccs	3, 3, r0, cr6, cr0, {0}
     f14:	33060305 	movwcc	r0, #25349	; 0x6305
     f18:	01061905 	tsteq	r6, r5, lsl #18
     f1c:	052e1005 	streq	r1, [lr, #-5]!
     f20:	15330603 	ldrne	r0, [r3, #-1539]!	; 0xfffff9fd
     f24:	0f061b05 	svceq	0x00061b05
     f28:	2b030105 	blcs	c1344 <__bss_end+0xb7804>
     f2c:	0319052e 	tsteq	r9, #192937984	; 0xb800000
     f30:	01052e55 	tsteq	r5, r5, asr lr
     f34:	4a2e2b03 	bmi	b8bb48 <__bss_end+0xb82008>
     f38:	01000a02 	tsteq	r0, r2, lsl #20
     f3c:	00016901 	andeq	r6, r1, r1, lsl #18
     f40:	68000300 	stmdavs	r0, {r8, r9}
     f44:	02000000 	andeq	r0, r0, #0
     f48:	0d0efb01 	vstreq	d15, [lr, #-4]
     f4c:	01010100 	mrseq	r0, (UNDEF: 17)
     f50:	00000001 	andeq	r0, r0, r1
     f54:	01000001 	tsteq	r0, r1
     f58:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     f5c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     f60:	2f2e2e2f 	svccs	0x002e2e2f
     f64:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     f68:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
     f6c:	63636762 	cmnvs	r3, #25690112	; 0x1880000
     f70:	2f2e2e00 	svccs	0x002e2e00
     f74:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     f78:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     f7c:	2f2e2e2f 	svccs	0x002e2e2f
     f80:	63672f2e 	cmnvs	r7, #46, 30	; 0xb8
     f84:	6c000063 	stcvs	0, cr0, [r0], {99}	; 0x63
     f88:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
     f8c:	632e3263 			; <UNDEFINED> instruction: 0x632e3263
     f90:	00000100 	andeq	r0, r0, r0, lsl #2
     f94:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
     f98:	2e617369 	cdpcs	3, 6, cr7, cr1, cr9, {3}
     f9c:	00020068 	andeq	r0, r2, r8, rrx
     fa0:	62696c00 	rsbvs	r6, r9, #0, 24
     fa4:	32636367 	rsbcc	r6, r3, #-1677721599	; 0x9c000001
     fa8:	0100682e 	tsteq	r0, lr, lsr #16
     fac:	05000000 	streq	r0, [r0, #-0]
     fb0:	02050001 	andeq	r0, r5, #1
     fb4:	00009938 	andeq	r9, r0, r8, lsr r9
     fb8:	0107b303 	tsteq	r7, r3, lsl #6
     fbc:	13130305 	tstne	r3, #335544320	; 0x14000000
     fc0:	05010a03 	streq	r0, [r1, #-2563]	; 0xfffff5fd
     fc4:	05010606 	streq	r0, [r1, #-1542]	; 0xfffff9fa
     fc8:	4a740301 	bmi	1d01bd4 <__bss_end+0x1cf8094>
     fcc:	052f0b05 	streq	r0, [pc, #-2821]!	; 4cf <shift+0x4cf>
     fd0:	0b052d01 	bleq	14c3dc <__bss_end+0x14289c>
     fd4:	0306052f 	movweq	r0, #25903	; 0x652f
     fd8:	07052e0b 	streq	r2, [r5, -fp, lsl #28]
     fdc:	0d053006 	stceq	0, cr3, [r5, #-24]	; 0xffffffe8
     fe0:	07050106 	streq	r0, [r5, -r6, lsl #2]
     fe4:	0d058306 	stceq	3, cr8, [r5, #-24]	; 0xffffffe8
     fe8:	054a0106 	strbeq	r0, [sl, #-262]	; 0xfffffefa
     fec:	054c0607 	strbeq	r0, [ip, #-1543]	; 0xfffff9f9
     ff0:	05010609 	streq	r0, [r1, #-1545]	; 0xfffff9f7
     ff4:	052f0607 	streq	r0, [pc, #-1543]!	; 9f5 <shift+0x9f5>
     ff8:	2e010609 	cfmadd32cs	mvax0, mvfx0, mvfx1, mvfx9
     ffc:	a5060705 	strge	r0, [r6, #-1797]	; 0xfffff8fb
    1000:	01060a05 	tsteq	r6, r5, lsl #20
    1004:	030b052e 	movweq	r0, #46382	; 0xb52e
    1008:	0a052e68 	beq	14c9b0 <__bss_end+0x142e70>
    100c:	054a1803 	strbeq	r1, [sl, #-2051]	; 0xfffff7fd
    1010:	05300604 	ldreq	r0, [r0, #-1540]!	; 0xfffff9fc
    1014:	49130606 	ldmdbmi	r3, {r1, r2, r9, sl}
    1018:	0405492f 	streq	r4, [r5], #-2351	; 0xfffff6d1
    101c:	07052f06 	streq	r2, [r5, -r6, lsl #30]
    1020:	060a0515 			; <UNDEFINED> instruction: 0x060a0515
    1024:	06040501 	streq	r0, [r4], -r1, lsl #10
    1028:	0606054c 	streq	r0, [r6], -ip, asr #10
    102c:	04052e01 	streq	r2, [r5], #-3585	; 0xfffff1ff
    1030:	06054e06 	streq	r4, [r5], -r6, lsl #28
    1034:	0b050e06 	bleq	144854 <__bss_end+0x13ad14>
    1038:	4a100552 	bmi	402588 <__bss_end+0x3f8a48>
    103c:	2e4a0505 	cdpcs	5, 4, cr0, cr10, cr5, {0}
    1040:	31060805 	tstcc	r6, r5, lsl #16
    1044:	05130e05 	ldreq	r0, [r3, #-3589]	; 0xfffff1fb
    1048:	2e010606 	cfmadd32cs	mvax0, mvfx0, mvfx1, mvfx6
    104c:	03060405 	movweq	r0, #25605	; 0x6405
    1050:	08052e79 	stmdaeq	r5, {r0, r3, r4, r5, r6, r9, sl, fp, sp}
    1054:	13030514 	movwne	r0, #13588	; 0x3514
    1058:	060b0514 			; <UNDEFINED> instruction: 0x060b0514
    105c:	6905050f 	stmdbvs	r5, {r0, r1, r2, r3, r8, sl}
    1060:	0608052e 	streq	r0, [r8], -lr, lsr #10
    1064:	130e052f 	movwne	r0, #58671	; 0xe52f
    1068:	01060605 	tsteq	r6, r5, lsl #12
    106c:	0604052e 	streq	r0, [r4], -lr, lsr #10
    1070:	06060532 			; <UNDEFINED> instruction: 0x06060532
    1074:	05492f01 	strbeq	r2, [r9, #-3841]	; 0xfffff0ff
    1078:	052f0604 	streq	r0, [pc, #-1540]!	; a7c <shift+0xa7c>
    107c:	05010606 	streq	r0, [r1, #-1542]	; 0xfffff9fa
    1080:	054b0604 	strbeq	r0, [fp, #-1540]	; 0xfffff9fc
    1084:	4a01060f 	bmi	428c8 <__bss_end+0x38d88>
    1088:	2e4a0605 	cdpcs	6, 4, cr0, cr10, cr5, {0}
    108c:	32060305 	andcc	r0, r6, #335544320	; 0x14000000
    1090:	01060605 	tsteq	r6, r5, lsl #12
    1094:	2f060505 	svccs	0x00060505
    1098:	01060905 	tsteq	r6, r5, lsl #18
    109c:	2f060305 	svccs	0x00060305
    10a0:	13060105 	movwne	r0, #24837	; 0x6105
    10a4:	0004022e 	andeq	r0, r4, lr, lsr #4
    10a8:	Address 0x00000000000010a8 is out of bounds.


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
      34:	fb0c0000 	blx	30003e <__bss_end+0x2f64fe>
      38:	2a000000 	bcs	40 <shift+0x40>
      3c:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
      40:	9c000080 	stcls	0, cr0, [r0], {128}	; 0x80
      44:	5a000000 	bpl	4c <shift+0x4c>
      48:	02000000 	andeq	r0, r0, #0
      4c:	0000012c 	andeq	r0, r0, ip, lsr #2
      50:	31150601 	tstcc	r5, r1, lsl #12
      54:	03000000 	movweq	r0, #0
      58:	15b60704 	ldrne	r0, [r6, #1796]!	; 0x704
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
     128:	000015b6 			; <UNDEFINED> instruction: 0x000015b6
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
     174:	cb104801 	blgt	412180 <__bss_end+0x408640>
     178:	d4000000 	strle	r0, [r0], #-0
     17c:	58000081 	stmdapl	r0, {r0, r7}
     180:	01000000 	mrseq	r0, (UNDEF: 0)
     184:	0000cb9c 	muleq	r0, ip, fp
     188:	01800a00 	orreq	r0, r0, r0, lsl #20
     18c:	4a010000 	bmi	40194 <__bss_end+0x36654>
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
     1d4:	5b0c0000 	blpl	3001dc <__bss_end+0x2f669c>
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
     24c:	8b120f01 	blhi	483e58 <__bss_end+0x47a318>
     250:	0f000001 	svceq	0x00000001
     254:	0000019e 	muleq	r0, lr, r1
     258:	03231000 			; <UNDEFINED> instruction: 0x03231000
     25c:	0a010000 	beq	40264 <__bss_end+0x36724>
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
     2b4:	8b140074 	blhi	50048c <__bss_end+0x4f694c>
     2b8:	a4000001 	strge	r0, [r0], #-1
     2bc:	38000080 	stmdacc	r0, {r7}
     2c0:	01000000 	mrseq	r0, (UNDEF: 0)
     2c4:	0067139c 	mlseq	r7, ip, r3, r1
     2c8:	9e2f0a01 	vmulls.f32	s0, s30, s2
     2cc:	02000001 	andeq	r0, r0, #1
     2d0:	00007491 	muleq	r0, r1, r4
     2d4:	000008a8 	andeq	r0, r0, r8, lsr #17
     2d8:	01e00004 	mvneq	r0, r4
     2dc:	01040000 	mrseq	r0, (UNDEF: 4)
     2e0:	0000025e 	andeq	r0, r0, lr, asr r2
     2e4:	0009e404 	andeq	lr, r9, r4, lsl #8
     2e8:	00002a00 	andeq	r2, r0, r0, lsl #20
     2ec:	00822c00 	addeq	r2, r2, r0, lsl #24
     2f0:	0000dc00 	andeq	sp, r0, r0, lsl #24
     2f4:	0001c200 	andeq	ip, r1, r0, lsl #4
     2f8:	08010200 	stmdaeq	r1, {r9}
     2fc:	0000091e 	andeq	r0, r0, lr, lsl r9
     300:	6a050202 	bvs	140b10 <__bss_end+0x136fd0>
     304:	03000009 	movweq	r0, #9
     308:	6e690504 	cdpvs	5, 6, cr0, cr9, cr4, {0}
     30c:	01020074 	tsteq	r2, r4, ror r0
     310:	00091508 	andeq	r1, r9, r8, lsl #10
     314:	07020200 	streq	r0, [r2, -r0, lsl #4]
     318:	00000720 	andeq	r0, r0, r0, lsr #14
     31c:	0009b304 	andeq	fp, r9, r4, lsl #6
     320:	07090900 	streq	r0, [r9, -r0, lsl #18]
     324:	00000059 	andeq	r0, r0, r9, asr r0
     328:	00004805 	andeq	r4, r0, r5, lsl #16
     32c:	07040200 	streq	r0, [r4, -r0, lsl #4]
     330:	000015b6 			; <UNDEFINED> instruction: 0x000015b6
     334:	00005905 	andeq	r5, r0, r5, lsl #18
     338:	05580600 	ldrbeq	r0, [r8, #-1536]	; 0xfffffa00
     33c:	02080000 	andeq	r0, r8, #0
     340:	008b0806 	addeq	r0, fp, r6, lsl #16
     344:	72070000 	andvc	r0, r7, #0
     348:	08020030 	stmdaeq	r2, {r4, r5}
     34c:	0000480e 	andeq	r4, r0, lr, lsl #16
     350:	72070000 	andvc	r0, r7, #0
     354:	09020031 	stmdbeq	r2, {r0, r4, r5}
     358:	0000480e 	andeq	r4, r0, lr, lsl #16
     35c:	08000400 	stmdaeq	r0, {sl}
     360:	000005de 	ldrdeq	r0, [r0], -lr
     364:	00330405 	eorseq	r0, r3, r5, lsl #8
     368:	1e020000 	cdpne	0, 0, cr0, cr2, cr0, {0}
     36c:	0000ce0c 	andeq	ip, r0, ip, lsl #28
     370:	05cc0900 	strbeq	r0, [ip, #2304]	; 0x900
     374:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
     378:	00000c19 	andeq	r0, r0, r9, lsl ip
     37c:	0bf90901 	bleq	ffe42788 <__bss_end+0xffe38c48>
     380:	09020000 	stmdbeq	r2, {}	; <UNPREDICTABLE>
     384:	0000076b 	andeq	r0, r0, fp, ror #14
     388:	08990903 	ldmeq	r9, {r0, r1, r8, fp}
     38c:	09040000 	stmdbeq	r4, {}	; <UNPREDICTABLE>
     390:	00000595 	muleq	r0, r5, r5
     394:	03d90905 	bicseq	r0, r9, #81920	; 0x14000
     398:	09060000 	stmdbeq	r6, {}	; <UNPREDICTABLE>
     39c:	00000bd3 	ldrdeq	r0, [r0], -r3
     3a0:	ac080007 	stcge	0, cr0, [r8], {7}
     3a4:	0500000b 	streq	r0, [r0, #-11]
     3a8:	00003304 	andeq	r3, r0, r4, lsl #6
     3ac:	0c490200 	sfmeq	f0, 2, [r9], {-0}
     3b0:	0000010b 	andeq	r0, r0, fp, lsl #2
     3b4:	00034d09 	andeq	r4, r3, r9, lsl #26
     3b8:	42090000 	andmi	r0, r9, #0
     3bc:	01000004 	tsteq	r0, r4
     3c0:	00088c09 	andeq	r8, r8, r9, lsl #24
     3c4:	d8090200 	stmdale	r9, {r9}
     3c8:	0300000b 	movweq	r0, #11
     3cc:	000c2309 	andeq	r2, ip, r9, lsl #6
     3d0:	37090400 	strcc	r0, [r9, -r0, lsl #8]
     3d4:	05000008 	streq	r0, [r0, #-8]
     3d8:	00074009 	andeq	r4, r7, r9
     3dc:	08000600 	stmdaeq	r0, {r9, sl}
     3e0:	00000b66 	andeq	r0, r0, r6, ror #22
     3e4:	00330405 	eorseq	r0, r3, r5, lsl #8
     3e8:	70020000 	andvc	r0, r2, r0
     3ec:	0001360c 	andeq	r3, r1, ip, lsl #12
     3f0:	08fc0900 	ldmeq	ip!, {r8, fp}^
     3f4:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
     3f8:	000006f4 	strdeq	r0, [r0], -r4
     3fc:	09740901 	ldmdbeq	r4!, {r0, r8, fp}^
     400:	09020000 	stmdbeq	r2, {}	; <UNPREDICTABLE>
     404:	00000745 	andeq	r0, r0, r5, asr #14
     408:	5e0a0003 	cdppl	0, 0, cr0, cr10, cr3, {0}
     40c:	03000008 	movweq	r0, #8
     410:	00541405 	subseq	r1, r4, r5, lsl #8
     414:	03050000 	movweq	r0, #20480	; 0x5000
     418:	00009a58 	andeq	r9, r0, r8, asr sl
     41c:	00086c0a 	andeq	r6, r8, sl, lsl #24
     420:	14060300 	strne	r0, [r6], #-768	; 0xfffffd00
     424:	00000054 	andeq	r0, r0, r4, asr r0
     428:	9a5c0305 	bls	1701044 <__bss_end+0x16f7504>
     42c:	210a0000 	mrscs	r0, (UNDEF: 10)
     430:	04000008 	streq	r0, [r0], #-8
     434:	00541a07 	subseq	r1, r4, r7, lsl #20
     438:	03050000 	movweq	r0, #20480	; 0x5000
     43c:	00009a60 	andeq	r9, r0, r0, ror #20
     440:	00046b0a 	andeq	r6, r4, sl, lsl #22
     444:	1a090400 	bne	24144c <__bss_end+0x23790c>
     448:	00000054 	andeq	r0, r0, r4, asr r0
     44c:	9a640305 	bls	1901068 <__bss_end+0x18f7528>
     450:	070a0000 	streq	r0, [sl, -r0]
     454:	04000009 	streq	r0, [r0], #-9
     458:	00541a0b 	subseq	r1, r4, fp, lsl #20
     45c:	03050000 	movweq	r0, #20480	; 0x5000
     460:	00009a68 	andeq	r9, r0, r8, ror #20
     464:	0006e10a 	andeq	lr, r6, sl, lsl #2
     468:	1a0d0400 	bne	341470 <__bss_end+0x337930>
     46c:	00000054 	andeq	r0, r0, r4, asr r0
     470:	9a6c0305 	bls	1b0108c <__bss_end+0x1af754c>
     474:	7e0a0000 	cdpvc	0, 0, cr0, cr10, cr0, {0}
     478:	04000005 	streq	r0, [r0], #-5
     47c:	00541a0f 	subseq	r1, r4, pc, lsl #20
     480:	03050000 	movweq	r0, #20480	; 0x5000
     484:	00009a70 	andeq	r9, r0, r0, ror sl
     488:	000fb508 	andeq	fp, pc, r8, lsl #10
     48c:	33040500 	movwcc	r0, #17664	; 0x4500
     490:	04000000 	streq	r0, [r0], #-0
     494:	01d90c1b 	bicseq	r0, r9, fp, lsl ip
     498:	26090000 	strcs	r0, [r9], -r0
     49c:	0000000a 	andeq	r0, r0, sl
     4a0:	000bee09 	andeq	lr, fp, r9, lsl #28
     4a4:	87090100 	strhi	r0, [r9, -r0, lsl #2]
     4a8:	02000008 	andeq	r0, r0, #8
     4ac:	08f60b00 	ldmeq	r6!, {r8, r9, fp}^
     4b0:	01020000 	mrseq	r0, (UNDEF: 2)
     4b4:	00077102 	andeq	r7, r7, r2, lsl #2
     4b8:	d9040c00 	stmdble	r4, {sl, fp}
     4bc:	0a000001 	beq	4c8 <shift+0x4c8>
     4c0:	00000629 	andeq	r0, r0, r9, lsr #12
     4c4:	54140405 	ldrpl	r0, [r4], #-1029	; 0xfffffbfb
     4c8:	05000000 	streq	r0, [r0, #-0]
     4cc:	009a7403 	addseq	r7, sl, r3, lsl #8
     4d0:	03420a00 	movteq	r0, #10752	; 0x2a00
     4d4:	07050000 	streq	r0, [r5, -r0]
     4d8:	00005414 	andeq	r5, r0, r4, lsl r4
     4dc:	78030500 	stmdavc	r3, {r8, sl}
     4e0:	0a00009a 	beq	750 <shift+0x750>
     4e4:	00000499 	muleq	r0, r9, r4
     4e8:	54140a05 	ldrpl	r0, [r4], #-2565	; 0xfffff5fb
     4ec:	05000000 	streq	r0, [r0, #-0]
     4f0:	009a7c03 	addseq	r7, sl, r3, lsl #24
     4f4:	07a60800 	streq	r0, [r6, r0, lsl #16]!
     4f8:	04050000 	streq	r0, [r5], #-0
     4fc:	00000033 	andeq	r0, r0, r3, lsr r0
     500:	580c0d05 	stmdapl	ip, {r0, r2, r8, sl, fp}
     504:	0d000002 	stceq	0, cr0, [r0, #-8]
     508:	0077654e 	rsbseq	r6, r7, lr, asr #10
     50c:	079d0900 	ldreq	r0, [sp, r0, lsl #18]
     510:	09010000 	stmdbeq	r1, {}	; <UNPREDICTABLE>
     514:	0000099b 	muleq	r0, fp, r9
     518:	07800902 	streq	r0, [r0, r2, lsl #18]
     51c:	09030000 	stmdbeq	r3, {}	; <UNPREDICTABLE>
     520:	0000075d 	andeq	r0, r0, sp, asr r7
     524:	08920904 	ldmeq	r2, {r2, r8, fp}
     528:	00050000 	andeq	r0, r5, r0
     52c:	00058806 	andeq	r8, r5, r6, lsl #16
     530:	1b051000 	blne	144538 <__bss_end+0x13a9f8>
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
     55c:	059e0e08 	ldreq	r0, [lr, #3592]	; 0xe08
     560:	20050000 	andcs	r0, r5, r0
     564:	00029713 	andeq	r9, r2, r3, lsl r7
     568:	02000c00 	andeq	r0, r0, #0, 24
     56c:	15b10704 	ldrne	r0, [r1, #1796]!	; 0x704
     570:	97050000 	strls	r0, [r5, -r0]
     574:	06000002 	streq	r0, [r0], -r2
     578:	000003af 	andeq	r0, r0, pc, lsr #7
     57c:	0828057c 	stmdaeq	r8!, {r2, r3, r4, r5, r6, r8, sl}
     580:	0000035a 	andeq	r0, r0, sl, asr r3
     584:	000a1a0e 	andeq	r1, sl, lr, lsl #20
     588:	122a0500 	eorne	r0, sl, #0, 10
     58c:	00000258 	andeq	r0, r0, r8, asr r2
     590:	69700700 	ldmdbvs	r0!, {r8, r9, sl}^
     594:	2b050064 	blcs	14072c <__bss_end+0x136bec>
     598:	00005912 	andeq	r5, r0, r2, lsl r9
     59c:	290e1000 	stmdbcs	lr, {ip}
     5a0:	05000004 	streq	r0, [r0, #-4]
     5a4:	0221112c 	eoreq	r1, r1, #44, 2
     5a8:	0e140000 	cdpeq	0, 1, cr0, cr4, cr0, {0}
     5ac:	000007b2 			; <UNDEFINED> instruction: 0x000007b2
     5b0:	59122d05 	ldmdbpl	r2, {r0, r2, r8, sl, fp, sp}
     5b4:	18000000 	stmdane	r0, {}	; <UNPREDICTABLE>
     5b8:	0007c00e 	andeq	ip, r7, lr
     5bc:	122e0500 	eorne	r0, lr, #0, 10
     5c0:	00000059 	andeq	r0, r0, r9, asr r0
     5c4:	05710e1c 	ldrbeq	r0, [r1, #-3612]!	; 0xfffff1e4
     5c8:	2f050000 	svccs	0x00050000
     5cc:	00035a0c 	andeq	r5, r3, ip, lsl #20
     5d0:	d60e2000 	strle	r2, [lr], -r0
     5d4:	05000007 	streq	r0, [r0, #-7]
     5d8:	00330930 	eorseq	r0, r3, r0, lsr r9
     5dc:	0e600000 	cdpeq	0, 6, cr0, cr0, cr0, {0}
     5e0:	00000a30 	andeq	r0, r0, r0, lsr sl
     5e4:	480e3105 	stmdami	lr, {r0, r2, r8, ip, sp}
     5e8:	64000000 	strvs	r0, [r0], #-0
     5ec:	0005fc0e 	andeq	pc, r5, lr, lsl #24
     5f0:	0e330500 	cfabs32eq	mvfx0, mvfx3
     5f4:	00000048 	andeq	r0, r0, r8, asr #32
     5f8:	05f30e68 	ldrbeq	r0, [r3, #3688]!	; 0xe68
     5fc:	34050000 	strcc	r0, [r5], #-0
     600:	0000480e 	andeq	r4, r0, lr, lsl #16
     604:	ff0e6c00 			; <UNDEFINED> instruction: 0xff0e6c00
     608:	05000006 	streq	r0, [r0, #-6]
     60c:	00480e35 	subeq	r0, r8, r5, lsr lr
     610:	0e700000 	cdpeq	0, 7, cr0, cr0, cr0, {0}
     614:	00000878 	andeq	r0, r0, r8, ror r8
     618:	480e3605 	stmdami	lr, {r0, r2, r9, sl, ip, sp}
     61c:	74000000 	strvc	r0, [r0], #-0
     620:	000be30e 	andeq	lr, fp, lr, lsl #6
     624:	0e370500 	cfabs32eq	mvfx0, mvfx7
     628:	00000048 	andeq	r0, r0, r8, asr #32
     62c:	e50f0078 	str	r0, [pc, #-120]	; 5bc <shift+0x5bc>
     630:	6a000001 	bvs	63c <shift+0x63c>
     634:	10000003 	andne	r0, r0, r3
     638:	00000059 	andeq	r0, r0, r9, asr r0
     63c:	c40a000f 	strgt	r0, [sl], #-15
     640:	0600000b 	streq	r0, [r0], -fp
     644:	0054140a 	subseq	r1, r4, sl, lsl #8
     648:	03050000 	movweq	r0, #20480	; 0x5000
     64c:	00009a80 	andeq	r9, r0, r0, lsl #21
     650:	00078808 	andeq	r8, r7, r8, lsl #16
     654:	33040500 	movwcc	r0, #17664	; 0x4500
     658:	06000000 	streq	r0, [r0], -r0
     65c:	039b0c0d 	orrseq	r0, fp, #3328	; 0xd00
     660:	47090000 	strmi	r0, [r9, -r0]
     664:	00000004 	andeq	r0, r0, r4
     668:	00033709 	andeq	r3, r3, r9, lsl #14
     66c:	06000100 	streq	r0, [r0], -r0, lsl #2
     670:	00000af0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
     674:	081b060c 	ldmdaeq	fp, {r2, r3, r9, sl}
     678:	000003d0 	ldrdeq	r0, [r0], -r0	; <UNPREDICTABLE>
     67c:	0003810e 	andeq	r8, r3, lr, lsl #2
     680:	191d0600 	ldmdbne	sp, {r9, sl}
     684:	000003d0 	ldrdeq	r0, [r0], -r0	; <UNPREDICTABLE>
     688:	04210e00 	strteq	r0, [r1], #-3584	; 0xfffff200
     68c:	1e060000 	cdpne	0, 0, cr0, cr6, cr0, {0}
     690:	0003d019 	andeq	sp, r3, r9, lsl r0
     694:	a40e0400 	strge	r0, [lr], #-1024	; 0xfffffc00
     698:	0600000a 	streq	r0, [r0], -sl
     69c:	03d6131f 	bicseq	r1, r6, #2080374784	; 0x7c000000
     6a0:	00080000 	andeq	r0, r8, r0
     6a4:	039b040c 	orrseq	r0, fp, #12, 8	; 0xc000000
     6a8:	040c0000 	streq	r0, [ip], #-0
     6ac:	000002a3 	andeq	r0, r0, r3, lsr #5
     6b0:	0004ac11 	andeq	sl, r4, r1, lsl ip
     6b4:	22061400 	andcs	r1, r6, #0, 8
     6b8:	00069d07 	andeq	r9, r6, r7, lsl #26
     6bc:	07760e00 	ldrbeq	r0, [r6, -r0, lsl #28]!
     6c0:	26060000 	strcs	r0, [r6], -r0
     6c4:	00004812 	andeq	r4, r0, r2, lsl r8
     6c8:	e00e0000 	and	r0, lr, r0
     6cc:	06000003 	streq	r0, [r0], -r3
     6d0:	03d01d29 	bicseq	r1, r0, #2624	; 0xa40
     6d4:	0e040000 	cdpeq	0, 0, cr0, cr4, cr0, {0}
     6d8:	000009d1 	ldrdeq	r0, [r0], -r1
     6dc:	d01d2c06 	andsle	r2, sp, r6, lsl #24
     6e0:	08000003 	stmdaeq	r0, {r0, r1}
     6e4:	000ba212 	andeq	sl, fp, r2, lsl r2
     6e8:	0e2f0600 	cfmadda32eq	mvax0, mvax0, mvfx15, mvfx0
     6ec:	00000acd 	andeq	r0, r0, sp, asr #21
     6f0:	00000424 	andeq	r0, r0, r4, lsr #8
     6f4:	0000042f 	andeq	r0, r0, pc, lsr #8
     6f8:	0006a213 	andeq	sl, r6, r3, lsl r2
     6fc:	03d01400 	bicseq	r1, r0, #0, 8
     700:	15000000 	strne	r0, [r0, #-0]
     704:	00000ab5 			; <UNDEFINED> instruction: 0x00000ab5
     708:	860e3106 	strhi	r3, [lr], -r6, lsl #2
     70c:	de000003 	cdple	0, 0, cr0, cr0, cr3, {0}
     710:	47000001 	strmi	r0, [r0, -r1]
     714:	52000004 	andpl	r0, r0, #4
     718:	13000004 	movwne	r0, #4
     71c:	000006a2 	andeq	r0, r0, r2, lsr #13
     720:	0003d614 	andeq	sp, r3, r4, lsl r6
     724:	03160000 	tsteq	r6, #0
     728:	0600000b 	streq	r0, [r0], -fp
     72c:	0a7f1d35 	beq	1fc7c08 <__bss_end+0x1fbe0c8>
     730:	03d00000 	bicseq	r0, r0, #0
     734:	6b020000 	blvs	8073c <__bss_end+0x76bfc>
     738:	71000004 	tstvc	r0, r4
     73c:	13000004 	movwne	r0, #4
     740:	000006a2 	andeq	r0, r0, r2, lsr #13
     744:	07331600 	ldreq	r1, [r3, -r0, lsl #12]!
     748:	37060000 	strcc	r0, [r6, -r0]
     74c:	0009351d 	andeq	r3, r9, sp, lsl r5
     750:	0003d000 	andeq	sp, r3, r0
     754:	048a0200 	streq	r0, [sl], #512	; 0x200
     758:	04900000 	ldreq	r0, [r0], #0
     75c:	a2130000 	andsge	r0, r3, #0
     760:	00000006 	andeq	r0, r0, r6
     764:	00080917 	andeq	r0, r8, r7, lsl r9
     768:	31390600 	teqcc	r9, r0, lsl #12
     76c:	000006bb 			; <UNDEFINED> instruction: 0x000006bb
     770:	ac16020c 	lfmge	f0, 4, [r6], {12}
     774:	06000004 	streq	r0, [r0], -r4
     778:	0bff093c 	bleq	fffc2c70 <__bss_end+0xfffb9130>
     77c:	06a20000 	strteq	r0, [r2], r0
     780:	b7010000 	strlt	r0, [r1, -r0]
     784:	bd000004 	stclt	0, cr0, [r0, #-16]
     788:	13000004 	movwne	r0, #4
     78c:	000006a2 	andeq	r0, r0, r2, lsr #13
     790:	0ab01600 	beq	fec05f98 <__bss_end+0xfebfc458>
     794:	3d060000 	stccc	0, cr0, [r6, #-0]
     798:	0007e012 	andeq	lr, r7, r2, lsl r0
     79c:	00004800 	andeq	r4, r0, r0, lsl #16
     7a0:	04d60100 	ldrbeq	r0, [r6], #256	; 0x100
     7a4:	04e10000 	strbteq	r0, [r1], #0
     7a8:	a2130000 	andsge	r0, r3, #0
     7ac:	14000006 	strne	r0, [r0], #-6
     7b0:	00000048 	andeq	r0, r0, r8, asr #32
     7b4:	045c1600 	ldrbeq	r1, [ip], #-1536	; 0xfffffa00
     7b8:	3f060000 	svccc	0x00060000
     7bc:	000b7712 	andeq	r7, fp, r2, lsl r7
     7c0:	00004800 	andeq	r4, r0, r0, lsl #16
     7c4:	04fa0100 	ldrbteq	r0, [sl], #256	; 0x100
     7c8:	050f0000 	streq	r0, [pc, #-0]	; 7d0 <shift+0x7d0>
     7cc:	a2130000 	andsge	r0, r3, #0
     7d0:	14000006 	strne	r0, [r0], #-6
     7d4:	000006c4 	andeq	r0, r0, r4, asr #13
     7d8:	00005914 	andeq	r5, r0, r4, lsl r9
     7dc:	01de1400 	bicseq	r1, lr, r0, lsl #8
     7e0:	18000000 	stmdane	r0, {}	; <UNPREDICTABLE>
     7e4:	00000851 	andeq	r0, r0, r1, asr r8
     7e8:	7d0e4106 	stfvcs	f4, [lr, #-24]	; 0xffffffe8
     7ec:	01000006 	tsteq	r0, r6
     7f0:	00000524 	andeq	r0, r0, r4, lsr #10
     7f4:	0000052a 	andeq	r0, r0, sl, lsr #10
     7f8:	0006a213 	andeq	sl, r6, r3, lsl r2
     7fc:	c4180000 	ldrgt	r0, [r8], #-0
     800:	0600000a 	streq	r0, [r0], -sl
     804:	08a80e43 	stmiaeq	r8!, {r0, r1, r6, r9, sl, fp}
     808:	3f010000 	svccc	0x00010000
     80c:	45000005 	strmi	r0, [r0, #-5]
     810:	13000005 	movwne	r0, #5
     814:	000006a2 	andeq	r0, r0, r2, lsr #13
     818:	06a31600 	strteq	r1, [r3], r0, lsl #12
     81c:	46060000 	strmi	r0, [r6], -r0
     820:	0003f317 	andeq	pc, r3, r7, lsl r3	; <UNPREDICTABLE>
     824:	0003d600 	andeq	sp, r3, r0, lsl #12
     828:	055e0100 	ldrbeq	r0, [lr, #-256]	; 0xffffff00
     82c:	05640000 	strbeq	r0, [r4, #-0]!
     830:	ca130000 	bgt	4c0838 <__bss_end+0x4b6cf8>
     834:	00000006 	andeq	r0, r0, r6
     838:	00042f16 	andeq	r2, r4, r6, lsl pc
     83c:	17490600 	strbne	r0, [r9, -r0, lsl #12]
     840:	00000a3c 	andeq	r0, r0, ip, lsr sl
     844:	000003d6 	ldrdeq	r0, [r0], -r6
     848:	00057d01 	andeq	r7, r5, r1, lsl #26
     84c:	00058800 	andeq	r8, r5, r0, lsl #16
     850:	06ca1300 	strbeq	r1, [sl], r0, lsl #6
     854:	48140000 	ldmdami	r4, {}	; <UNPREDICTABLE>
     858:	00000000 	andeq	r0, r0, r0
     85c:	0006cb18 	andeq	ip, r6, r8, lsl fp
     860:	0e4c0600 	cdpeq	6, 4, cr0, cr12, cr0, {0}
     864:	00000352 	andeq	r0, r0, r2, asr r3
     868:	00059d01 	andeq	r9, r5, r1, lsl #26
     86c:	0005a300 	andeq	sl, r5, r0, lsl #6
     870:	06a21300 	strteq	r1, [r2], r0, lsl #6
     874:	16000000 	strne	r0, [r0], -r0
     878:	00000ab5 			; <UNDEFINED> instruction: 0x00000ab5
     87c:	a40e4e06 	strge	r4, [lr], #-3590	; 0xfffff1fa
     880:	de000005 	cdple	0, 0, cr0, cr0, cr5, {0}
     884:	01000001 	tsteq	r0, r1
     888:	000005bc 			; <UNDEFINED> instruction: 0x000005bc
     88c:	000005c7 	andeq	r0, r0, r7, asr #11
     890:	0006a213 	andeq	sl, r6, r3, lsl r2
     894:	00481400 	subeq	r1, r8, r0, lsl #8
     898:	16000000 	strne	r0, [r0], -r0
     89c:	000006b7 			; <UNDEFINED> instruction: 0x000006b7
     8a0:	c9125106 	ldmdbgt	r2, {r1, r2, r8, ip, lr}
     8a4:	48000008 	stmdami	r0, {r3}
     8a8:	01000000 	mrseq	r0, (UNDEF: 0)
     8ac:	000005e0 	andeq	r0, r0, r0, ror #11
     8b0:	000005eb 	andeq	r0, r0, fp, ror #11
     8b4:	0006a213 	andeq	sl, r6, r3, lsl r2
     8b8:	01e51400 	mvneq	r1, r0, lsl #8
     8bc:	16000000 	strne	r0, [r0], -r0
     8c0:	000003bc 			; <UNDEFINED> instruction: 0x000003bc
     8c4:	420e5406 	andmi	r5, lr, #100663296	; 0x6000000
     8c8:	de000006 	cdple	0, 0, cr0, cr0, cr6, {0}
     8cc:	01000001 	tsteq	r0, r1
     8d0:	00000604 	andeq	r0, r0, r4, lsl #12
     8d4:	0000060f 	andeq	r0, r0, pc, lsl #12
     8d8:	0006a213 	andeq	sl, r6, r3, lsl r2
     8dc:	00481400 	subeq	r1, r8, r0, lsl #8
     8e0:	18000000 	stmdane	r0, {}	; <UNPREDICTABLE>
     8e4:	0000070d 	andeq	r0, r0, sp, lsl #14
     8e8:	0f0e5706 	svceq	0x000e5706
     8ec:	0100000b 	tsteq	r0, fp
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
     918:	00000a69 	andeq	r0, r0, r9, ror #20
     91c:	0c0e5906 			; <UNDEFINED> instruction: 0x0c0e5906
     920:	01000005 	tsteq	r0, r5
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
     94c:	00000486 	andeq	r0, r0, r6, lsl #9
     950:	bd0e5c06 	stclt	12, cr5, [lr, #-24]	; 0xffffffe8
     954:	de000004 	cdple	0, 0, cr0, cr0, cr4, {0}
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
     9b0:	0b050700 	bleq	1425b8 <__bss_end+0x138a78>
     9b4:	000007a2 	andeq	r0, r0, r2, lsr #15
     9b8:	00083e1f 	andeq	r3, r8, pc, lsl lr
     9bc:	19070700 	stmdbne	r7, {r8, r9, sl}
     9c0:	00000060 	andeq	r0, r0, r0, rrx
     9c4:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}
     9c8:	00098b1f 	andeq	r8, r9, pc, lsl fp
     9cc:	1a0a0700 	bne	2825d4 <__bss_end+0x278a94>
     9d0:	0000029e 	muleq	r0, lr, r2
     9d4:	20000000 	andcs	r0, r0, r0
     9d8:	0008171f 	andeq	r1, r8, pc, lsl r7
     9dc:	1a0d0700 	bne	3425e4 <__bss_end+0x338aa4>
     9e0:	0000029e 	muleq	r0, lr, r2
     9e4:	20200000 	eorcs	r0, r0, r0
     9e8:	00095b20 	andeq	r5, r9, r0, lsr #22
     9ec:	15100700 	ldrne	r0, [r0, #-1792]	; 0xfffff900
     9f0:	00000054 	andeq	r0, r0, r4, asr r0
     9f4:	047d1f36 	ldrbteq	r1, [sp], #-3894	; 0xfffff0ca
     9f8:	42070000 	andmi	r0, r7, #0
     9fc:	00029e1a 	andeq	r9, r2, sl, lsl lr
     a00:	21500000 	cmpcs	r0, r0
     a04:	06051f20 	streq	r1, [r5], -r0, lsr #30
     a08:	71070000 	mrsvc	r0, (UNDEF: 7)
     a0c:	00029e1a 	andeq	r9, r2, sl, lsl lr
     a10:	00b20000 	adcseq	r0, r2, r0
     a14:	092a1f20 	stmdbeq	sl!, {r5, r8, r9, sl, fp, ip}
     a18:	a4070000 	strge	r0, [r7], #-0
     a1c:	00029e1a 	andeq	r9, r2, sl, lsl lr
     a20:	00b40000 	adcseq	r0, r4, r0
     a24:	09231f20 	stmdbeq	r3!, {r5, r8, r9, sl, fp, ip}
     a28:	b2070000 	andlt	r0, r7, #0
     a2c:	00029e1d 	andeq	r9, r2, sp, lsl lr
     a30:	00300000 	eorseq	r0, r0, r0
     a34:	066e1f20 	strbteq	r1, [lr], -r0, lsr #30
     a38:	c0070000 	andgt	r0, r7, r0
     a3c:	00029e1d 	andeq	r9, r2, sp, lsl lr
     a40:	10400000 	subne	r0, r0, r0
     a44:	05d41f20 	ldrbeq	r1, [r4, #3872]	; 0xf20
     a48:	cb070000 	blgt	1c0a50 <__bss_end+0x1b6f10>
     a4c:	00029e1a 	andeq	r9, r2, sl, lsl lr
     a50:	20500000 	subscs	r0, r0, r0
     a54:	061f1f20 	ldreq	r1, [pc], -r0, lsr #30
     a58:	cc070000 	stcgt	0, cr0, [r7], {-0}
     a5c:	00029e1a 	andeq	r9, r2, sl, lsl lr
     a60:	80400000 	subhi	r0, r0, r0
     a64:	03cf1f20 	biceq	r1, pc, #32, 30	; 0x80
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
     ab0:	fd0a0000 	stc2	0, cr0, [sl, #-0]
     ab4:	08000007 	stmdaeq	r0, {r0, r1, r2}
     ab8:	00541408 	subseq	r1, r4, r8, lsl #8
     abc:	03050000 	movweq	r0, #20480	; 0x5000
     ac0:	00009ab4 			; <UNDEFINED> instruction: 0x00009ab4
     ac4:	0009bc08 	andeq	fp, r9, r8, lsl #24
     ac8:	33040500 	movwcc	r0, #17664	; 0x4500
     acc:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
     ad0:	081b0c1d 	ldmdaeq	fp, {r0, r2, r3, r4, sl, fp}
     ad4:	00090000 	andeq	r0, r9, r0
     ad8:	00000005 	andeq	r0, r0, r5
     adc:	00056409 	andeq	r6, r5, r9, lsl #8
     ae0:	78090100 	stmdavc	r9, {r8}
     ae4:	02000006 	andeq	r0, r0, #6
     ae8:	776f4c0d 	strbvc	r4, [pc, -sp, lsl #24]!
     aec:	22000300 	andcs	r0, r0, #0, 6
     af0:	0000154a 	andeq	r1, r0, sl, asr #10
     af4:	33050e01 	movwcc	r0, #24065	; 0x5e01
     af8:	2c000000 	stccs	0, cr0, [r0], {-0}
     afc:	dc000082 	stcle	0, cr0, [r0], {130}	; 0x82
     b00:	01000000 	mrseq	r0, (UNDEF: 0)
     b04:	00089f9c 	muleq	r8, ip, pc	; <UNPREDICTABLE>
     b08:	0bde2300 	bleq	ff789710 <__bss_end+0xff77fbd0>
     b0c:	0e010000 	cdpeq	0, 0, cr0, cr1, cr0, {0}
     b10:	0000330e 	andeq	r3, r0, lr, lsl #6
     b14:	5c910200 	lfmpl	f0, 4, [r1], {0}
     b18:	000b6123 	andeq	r6, fp, r3, lsr #2
     b1c:	1b0e0100 	blne	380f24 <__bss_end+0x3773e4>
     b20:	0000089f 	muleq	r0, pc, r8	; <UNPREDICTABLE>
     b24:	24589102 	ldrbcs	r9, [r8], #-258	; 0xfffffefe
     b28:	00000429 	andeq	r0, r0, r9, lsr #8
     b2c:	25071001 	strcs	r1, [r7, #-1]
     b30:	02000000 	andeq	r0, r0, #0
     b34:	26246b91 			; <UNDEFINED> instruction: 0x26246b91
     b38:	01000004 	tsteq	r0, r4
     b3c:	00250711 	eoreq	r0, r5, r1, lsl r7
     b40:	91020000 	mrsls	r0, (UNDEF: 2)
     b44:	09a32477 	stmibeq	r3!, {r0, r1, r2, r4, r5, r6, sl, sp}
     b48:	13010000 	movwne	r0, #4096	; 0x1000
     b4c:	0000480b 	andeq	r4, r0, fp, lsl #16
     b50:	70910200 	addsvc	r0, r1, r0, lsl #4
     b54:	000aa924 	andeq	sl, sl, r4, lsr #18
     b58:	17160100 	ldrne	r0, [r6, -r0, lsl #2]
     b5c:	000007f0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
     b60:	24649102 	strbtcs	r9, [r4], #-258	; 0xfffffefe
     b64:	00000c29 	andeq	r0, r0, r9, lsr #24
     b68:	480b1e01 	stmdami	fp, {r0, r9, sl, fp, ip}
     b6c:	02000000 	andeq	r0, r0, #0
     b70:	0c006c91 	stceq	12, cr6, [r0], {145}	; 0x91
     b74:	0008a504 	andeq	sl, r8, r4, lsl #10
     b78:	25040c00 	strcs	r0, [r4, #-3072]	; 0xfffff400
     b7c:	00000000 	andeq	r0, r0, r0
     b80:	00000b91 	muleq	r0, r1, fp
     b84:	04060004 	streq	r0, [r6], #-4
     b88:	01040000 	mrseq	r0, (UNDEF: 4)
     b8c:	00000d39 	andeq	r0, r0, r9, lsr sp
     b90:	000ecd04 	andeq	ip, lr, r4, lsl #26
     b94:	000e6300 	andeq	r6, lr, r0, lsl #6
     b98:	00830800 	addeq	r0, r3, r0, lsl #16
     b9c:	00045c00 	andeq	r5, r4, r0, lsl #24
     ba0:	0003b800 	andeq	fp, r3, r0, lsl #16
     ba4:	08010200 	stmdaeq	r1, {r9}
     ba8:	0000091e 	andeq	r0, r0, lr, lsl r9
     bac:	00002503 	andeq	r2, r0, r3, lsl #10
     bb0:	05020200 	streq	r0, [r2, #-512]	; 0xfffffe00
     bb4:	0000096a 	andeq	r0, r0, sl, ror #18
     bb8:	69050404 	stmdbvs	r5, {r2, sl}
     bbc:	0200746e 	andeq	r7, r0, #1845493760	; 0x6e000000
     bc0:	09150801 	ldmdbeq	r5, {r0, fp}
     bc4:	02020000 	andeq	r0, r2, #0
     bc8:	00072007 	andeq	r2, r7, r7
     bcc:	09b30500 	ldmibeq	r3!, {r8, sl}
     bd0:	09070000 	stmdbeq	r7, {}	; <UNPREDICTABLE>
     bd4:	00005e07 	andeq	r5, r0, r7, lsl #28
     bd8:	004d0300 	subeq	r0, sp, r0, lsl #6
     bdc:	04020000 	streq	r0, [r2], #-0
     be0:	0015b607 	andseq	fp, r5, r7, lsl #12
     be4:	05580600 	ldrbeq	r0, [r8, #-1536]	; 0xfffffa00
     be8:	02080000 	andeq	r0, r8, #0
     bec:	008b0806 	addeq	r0, fp, r6, lsl #16
     bf0:	72070000 	andvc	r0, r7, #0
     bf4:	08020030 	stmdaeq	r2, {r4, r5}
     bf8:	00004d0e 	andeq	r4, r0, lr, lsl #26
     bfc:	72070000 	andvc	r0, r7, #0
     c00:	09020031 	stmdbeq	r2, {r0, r4, r5}
     c04:	00004d0e 	andeq	r4, r0, lr, lsl #26
     c08:	08000400 	stmdaeq	r0, {sl}
     c0c:	00000efd 	strdeq	r0, [r0], -sp
     c10:	00380405 	eorseq	r0, r8, r5, lsl #8
     c14:	0d020000 	stceq	0, cr0, [r2, #-0]
     c18:	0000a90c 	andeq	sl, r0, ip, lsl #18
     c1c:	4b4f0900 	blmi	13c3024 <__bss_end+0x13b94e4>
     c20:	8f0a0000 	svchi	0x000a0000
     c24:	0100000c 	tsteq	r0, ip
     c28:	05de0800 	ldrbeq	r0, [lr, #2048]	; 0x800
     c2c:	04050000 	streq	r0, [r5], #-0
     c30:	00000038 	andeq	r0, r0, r8, lsr r0
     c34:	ec0c1e02 	stc	14, cr1, [ip], {2}
     c38:	0a000000 	beq	c40 <shift+0xc40>
     c3c:	000005cc 	andeq	r0, r0, ip, asr #11
     c40:	0c190a00 			; <UNDEFINED> instruction: 0x0c190a00
     c44:	0a010000 	beq	40c4c <__bss_end+0x3710c>
     c48:	00000bf9 	strdeq	r0, [r0], -r9
     c4c:	076b0a02 	strbeq	r0, [fp, -r2, lsl #20]!
     c50:	0a030000 	beq	c0c58 <__bss_end+0xb7118>
     c54:	00000899 	muleq	r0, r9, r8
     c58:	05950a04 	ldreq	r0, [r5, #2564]	; 0xa04
     c5c:	0a050000 	beq	140c64 <__bss_end+0x137124>
     c60:	000003d9 	ldrdeq	r0, [r0], -r9
     c64:	0bd30a06 	bleq	ff4c3484 <__bss_end+0xff4b9944>
     c68:	00070000 	andeq	r0, r7, r0
     c6c:	000bac08 	andeq	sl, fp, r8, lsl #24
     c70:	38040500 	stmdacc	r4, {r8, sl}
     c74:	02000000 	andeq	r0, r0, #0
     c78:	01290c49 			; <UNDEFINED> instruction: 0x01290c49
     c7c:	4d0a0000 	stcmi	0, cr0, [sl, #-0]
     c80:	00000003 	andeq	r0, r0, r3
     c84:	0004420a 	andeq	r4, r4, sl, lsl #4
     c88:	8c0a0100 	stfhis	f0, [sl], {-0}
     c8c:	02000008 	andeq	r0, r0, #8
     c90:	000bd80a 	andeq	sp, fp, sl, lsl #16
     c94:	230a0300 	movwcs	r0, #41728	; 0xa300
     c98:	0400000c 	streq	r0, [r0], #-12
     c9c:	0008370a 	andeq	r3, r8, sl, lsl #14
     ca0:	400a0500 	andmi	r0, sl, r0, lsl #10
     ca4:	06000007 	streq	r0, [r0], -r7
     ca8:	0b660800 	bleq	1982cb0 <__bss_end+0x1979170>
     cac:	04050000 	streq	r0, [r5], #-0
     cb0:	00000038 	andeq	r0, r0, r8, lsr r0
     cb4:	540c7002 	strpl	r7, [ip], #-2
     cb8:	0a000001 	beq	cc4 <shift+0xcc4>
     cbc:	000008fc 	strdeq	r0, [r0], -ip
     cc0:	06f40a00 	ldrbteq	r0, [r4], r0, lsl #20
     cc4:	0a010000 	beq	40ccc <__bss_end+0x3718c>
     cc8:	00000974 	andeq	r0, r0, r4, ror r9
     ccc:	07450a02 	strbeq	r0, [r5, -r2, lsl #20]
     cd0:	00030000 	andeq	r0, r3, r0
     cd4:	00085e0b 	andeq	r5, r8, fp, lsl #28
     cd8:	14050300 	strne	r0, [r5], #-768	; 0xfffffd00
     cdc:	00000059 	andeq	r0, r0, r9, asr r0
     ce0:	9adc0305 	bls	ff7018fc <__bss_end+0xff6f7dbc>
     ce4:	6c0b0000 	stcvs	0, cr0, [fp], {-0}
     ce8:	03000008 	movweq	r0, #8
     cec:	00591406 	subseq	r1, r9, r6, lsl #8
     cf0:	03050000 	movweq	r0, #20480	; 0x5000
     cf4:	00009ae0 	andeq	r9, r0, r0, ror #21
     cf8:	0008210b 	andeq	r2, r8, fp, lsl #2
     cfc:	1a070400 	bne	1c1d04 <__bss_end+0x1b81c4>
     d00:	00000059 	andeq	r0, r0, r9, asr r0
     d04:	9ae40305 	bls	ff901920 <__bss_end+0xff8f7de0>
     d08:	6b0b0000 	blvs	2c0d10 <__bss_end+0x2b71d0>
     d0c:	04000004 	streq	r0, [r0], #-4
     d10:	00591a09 	subseq	r1, r9, r9, lsl #20
     d14:	03050000 	movweq	r0, #20480	; 0x5000
     d18:	00009ae8 	andeq	r9, r0, r8, ror #21
     d1c:	0009070b 	andeq	r0, r9, fp, lsl #14
     d20:	1a0b0400 	bne	2c1d28 <__bss_end+0x2b81e8>
     d24:	00000059 	andeq	r0, r0, r9, asr r0
     d28:	9aec0305 	bls	ffb01944 <__bss_end+0xffaf7e04>
     d2c:	e10b0000 	mrs	r0, (UNDEF: 11)
     d30:	04000006 	streq	r0, [r0], #-6
     d34:	00591a0d 	subseq	r1, r9, sp, lsl #20
     d38:	03050000 	movweq	r0, #20480	; 0x5000
     d3c:	00009af0 	strdeq	r9, [r0], -r0
     d40:	00057e0b 	andeq	r7, r5, fp, lsl #28
     d44:	1a0f0400 	bne	3c1d4c <__bss_end+0x3b820c>
     d48:	00000059 	andeq	r0, r0, r9, asr r0
     d4c:	9af40305 	bls	ffd01968 <__bss_end+0xffcf7e28>
     d50:	b5080000 	strlt	r0, [r8, #-0]
     d54:	0500000f 	streq	r0, [r0, #-15]
     d58:	00003804 	andeq	r3, r0, r4, lsl #16
     d5c:	0c1b0400 	cfldrseq	mvf0, [fp], {-0}
     d60:	000001f7 	strdeq	r0, [r0], -r7
     d64:	000a260a 	andeq	r2, sl, sl, lsl #12
     d68:	ee0a0000 	cdp	0, 0, cr0, cr10, cr0, {0}
     d6c:	0100000b 	tsteq	r0, fp
     d70:	0008870a 	andeq	r8, r8, sl, lsl #14
     d74:	0c000200 	sfmeq	f0, 4, [r0], {-0}
     d78:	000008f6 	strdeq	r0, [r0], -r6
     d7c:	71020102 	tstvc	r2, r2, lsl #2
     d80:	0d000007 	stceq	0, cr0, [r0, #-28]	; 0xffffffe4
     d84:	00002c04 	andeq	r2, r0, r4, lsl #24
     d88:	f7040d00 			; <UNDEFINED> instruction: 0xf7040d00
     d8c:	0b000001 	bleq	d98 <shift+0xd98>
     d90:	00000629 	andeq	r0, r0, r9, lsr #12
     d94:	59140405 	ldmdbpl	r4, {r0, r2, sl}
     d98:	05000000 	streq	r0, [r0, #-0]
     d9c:	009af803 	addseq	pc, sl, r3, lsl #16
     da0:	03420b00 	movteq	r0, #11008	; 0x2b00
     da4:	07050000 	streq	r0, [r5, -r0]
     da8:	00005914 	andeq	r5, r0, r4, lsl r9
     dac:	fc030500 	stc2	5, cr0, [r3], {-0}
     db0:	0b00009a 	bleq	1020 <shift+0x1020>
     db4:	00000499 	muleq	r0, r9, r4
     db8:	59140a05 	ldmdbpl	r4, {r0, r2, r9, fp}
     dbc:	05000000 	streq	r0, [r0, #-0]
     dc0:	009b0003 	addseq	r0, fp, r3
     dc4:	07a60800 	streq	r0, [r6, r0, lsl #16]!
     dc8:	04050000 	streq	r0, [r5], #-0
     dcc:	00000038 	andeq	r0, r0, r8, lsr r0
     dd0:	7c0c0d05 	stcvc	13, cr0, [ip], {5}
     dd4:	09000002 	stmdbeq	r0, {r1}
     dd8:	0077654e 	rsbseq	r6, r7, lr, asr #10
     ddc:	079d0a00 	ldreq	r0, [sp, r0, lsl #20]
     de0:	0a010000 	beq	40de8 <__bss_end+0x372a8>
     de4:	0000099b 	muleq	r0, fp, r9
     de8:	07800a02 	streq	r0, [r0, r2, lsl #20]
     dec:	0a030000 	beq	c0df4 <__bss_end+0xb72b4>
     df0:	0000075d 	andeq	r0, r0, sp, asr r7
     df4:	08920a04 	ldmeq	r2, {r2, r9, fp}
     df8:	00050000 	andeq	r0, r5, r0
     dfc:	00058806 	andeq	r8, r5, r6, lsl #16
     e00:	1b051000 	blne	144e08 <__bss_end+0x13b2c8>
     e04:	0002bb08 	andeq	fp, r2, r8, lsl #22
     e08:	726c0700 	rsbvc	r0, ip, #0, 14
     e0c:	131d0500 	tstne	sp, #0, 10
     e10:	000002bb 			; <UNDEFINED> instruction: 0x000002bb
     e14:	70730700 	rsbsvc	r0, r3, r0, lsl #14
     e18:	131e0500 	tstne	lr, #0, 10
     e1c:	000002bb 			; <UNDEFINED> instruction: 0x000002bb
     e20:	63700704 	cmnvs	r0, #4, 14	; 0x100000
     e24:	131f0500 	tstne	pc, #0, 10
     e28:	000002bb 			; <UNDEFINED> instruction: 0x000002bb
     e2c:	059e0e08 	ldreq	r0, [lr, #3592]	; 0xe08
     e30:	20050000 	andcs	r0, r5, r0
     e34:	0002bb13 	andeq	fp, r2, r3, lsl fp
     e38:	02000c00 	andeq	r0, r0, #0, 24
     e3c:	15b10704 	ldrne	r0, [r1, #1796]!	; 0x704
     e40:	af060000 	svcge	0x00060000
     e44:	7c000003 	stcvc	0, cr0, [r0], {3}
     e48:	79082805 	stmdbvc	r8, {r0, r2, fp, sp}
     e4c:	0e000003 	cdpeq	0, 0, cr0, cr0, cr3, {0}
     e50:	00000a1a 	andeq	r0, r0, sl, lsl sl
     e54:	7c122a05 			; <UNDEFINED> instruction: 0x7c122a05
     e58:	00000002 	andeq	r0, r0, r2
     e5c:	64697007 	strbtvs	r7, [r9], #-7
     e60:	122b0500 	eorne	r0, fp, #0, 10
     e64:	0000005e 	andeq	r0, r0, lr, asr r0
     e68:	04290e10 	strteq	r0, [r9], #-3600	; 0xfffff1f0
     e6c:	2c050000 	stccs	0, cr0, [r5], {-0}
     e70:	00024511 	andeq	r4, r2, r1, lsl r5
     e74:	b20e1400 	andlt	r1, lr, #0, 8
     e78:	05000007 	streq	r0, [r0, #-7]
     e7c:	005e122d 	subseq	r1, lr, sp, lsr #4
     e80:	0e180000 	cdpeq	0, 1, cr0, cr8, cr0, {0}
     e84:	000007c0 	andeq	r0, r0, r0, asr #15
     e88:	5e122e05 	cdppl	14, 1, cr2, cr2, cr5, {0}
     e8c:	1c000000 	stcne	0, cr0, [r0], {-0}
     e90:	0005710e 	andeq	r7, r5, lr, lsl #2
     e94:	0c2f0500 	cfstr32eq	mvfx0, [pc], #-0	; e9c <shift+0xe9c>
     e98:	00000379 	andeq	r0, r0, r9, ror r3
     e9c:	07d60e20 	ldrbeq	r0, [r6, r0, lsr #28]
     ea0:	30050000 	andcc	r0, r5, r0
     ea4:	00003809 	andeq	r3, r0, r9, lsl #16
     ea8:	300e6000 	andcc	r6, lr, r0
     eac:	0500000a 	streq	r0, [r0, #-10]
     eb0:	004d0e31 	subeq	r0, sp, r1, lsr lr
     eb4:	0e640000 	cdpeq	0, 6, cr0, cr4, cr0, {0}
     eb8:	000005fc 	strdeq	r0, [r0], -ip
     ebc:	4d0e3305 	stcmi	3, cr3, [lr, #-20]	; 0xffffffec
     ec0:	68000000 	stmdavs	r0, {}	; <UNPREDICTABLE>
     ec4:	0005f30e 	andeq	pc, r5, lr, lsl #6
     ec8:	0e340500 	cfabs32eq	mvfx0, mvfx4
     ecc:	0000004d 	andeq	r0, r0, sp, asr #32
     ed0:	06ff0e6c 	ldrbteq	r0, [pc], ip, ror #28
     ed4:	35050000 	strcc	r0, [r5, #-0]
     ed8:	00004d0e 	andeq	r4, r0, lr, lsl #26
     edc:	780e7000 	stmdavc	lr, {ip, sp, lr}
     ee0:	05000008 	streq	r0, [r0, #-8]
     ee4:	004d0e36 	subeq	r0, sp, r6, lsr lr
     ee8:	0e740000 	cdpeq	0, 7, cr0, cr4, cr0, {0}
     eec:	00000be3 	andeq	r0, r0, r3, ror #23
     ef0:	4d0e3705 	stcmi	7, cr3, [lr, #-20]	; 0xffffffec
     ef4:	78000000 	stmdavc	r0, {}	; <UNPREDICTABLE>
     ef8:	02090f00 	andeq	r0, r9, #0, 30
     efc:	03890000 	orreq	r0, r9, #0
     f00:	5e100000 	cdppl	0, 1, cr0, cr0, cr0, {0}
     f04:	0f000000 	svceq	0x00000000
     f08:	0bc40b00 	bleq	ff103b10 <__bss_end+0xff0f9fd0>
     f0c:	0a060000 	beq	180f14 <__bss_end+0x1773d4>
     f10:	00005914 	andeq	r5, r0, r4, lsl r9
     f14:	04030500 	streq	r0, [r3], #-1280	; 0xfffffb00
     f18:	0800009b 	stmdaeq	r0, {r0, r1, r3, r4, r7}
     f1c:	00000788 	andeq	r0, r0, r8, lsl #15
     f20:	00380405 	eorseq	r0, r8, r5, lsl #8
     f24:	0d060000 	stceq	0, cr0, [r6, #-0]
     f28:	0003ba0c 	andeq	fp, r3, ip, lsl #20
     f2c:	04470a00 	strbeq	r0, [r7], #-2560	; 0xfffff600
     f30:	0a000000 	beq	f38 <shift+0xf38>
     f34:	00000337 	andeq	r0, r0, r7, lsr r3
     f38:	9b030001 	blls	c0f44 <__bss_end+0xb7404>
     f3c:	08000003 	stmdaeq	r0, {r0, r1}
     f40:	00000e07 	andeq	r0, r0, r7, lsl #28
     f44:	00380405 	eorseq	r0, r8, r5, lsl #8
     f48:	14060000 	strne	r0, [r6], #-0
     f4c:	0003de0c 	andeq	sp, r3, ip, lsl #28
     f50:	0c370a00 			; <UNDEFINED> instruction: 0x0c370a00
     f54:	0a000000 	beq	f5c <shift+0xf5c>
     f58:	00000e9f 	muleq	r0, pc, lr	; <UNPREDICTABLE>
     f5c:	bf030001 	svclt	0x00030001
     f60:	06000003 	streq	r0, [r0], -r3
     f64:	00000af0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
     f68:	081b060c 	ldmdaeq	fp, {r2, r3, r9, sl}
     f6c:	00000418 	andeq	r0, r0, r8, lsl r4
     f70:	0003810e 	andeq	r8, r3, lr, lsl #2
     f74:	191d0600 	ldmdbne	sp, {r9, sl}
     f78:	00000418 	andeq	r0, r0, r8, lsl r4
     f7c:	04210e00 	strteq	r0, [r1], #-3584	; 0xfffff200
     f80:	1e060000 	cdpne	0, 0, cr0, cr6, cr0, {0}
     f84:	00041819 	andeq	r1, r4, r9, lsl r8
     f88:	a40e0400 	strge	r0, [lr], #-1024	; 0xfffffc00
     f8c:	0600000a 	streq	r0, [r0], -sl
     f90:	041e131f 	ldreq	r1, [lr], #-799	; 0xfffffce1
     f94:	00080000 	andeq	r0, r8, r0
     f98:	03e3040d 	mvneq	r0, #218103808	; 0xd000000
     f9c:	040d0000 	streq	r0, [sp], #-0
     fa0:	000002c2 	andeq	r0, r0, r2, asr #5
     fa4:	0004ac11 	andeq	sl, r4, r1, lsl ip
     fa8:	22061400 	andcs	r1, r6, #0, 8
     fac:	0006e507 	andeq	lr, r6, r7, lsl #10
     fb0:	07760e00 	ldrbeq	r0, [r6, -r0, lsl #28]!
     fb4:	26060000 	strcs	r0, [r6], -r0
     fb8:	00004d12 	andeq	r4, r0, r2, lsl sp
     fbc:	e00e0000 	and	r0, lr, r0
     fc0:	06000003 	streq	r0, [r0], -r3
     fc4:	04181d29 	ldreq	r1, [r8], #-3369	; 0xfffff2d7
     fc8:	0e040000 	cdpeq	0, 0, cr0, cr4, cr0, {0}
     fcc:	000009d1 	ldrdeq	r0, [r0], -r1
     fd0:	181d2c06 	ldmdane	sp, {r1, r2, sl, fp, sp}
     fd4:	08000004 	stmdaeq	r0, {r2}
     fd8:	000ba212 	andeq	sl, fp, r2, lsl r2
     fdc:	0e2f0600 	cfmadda32eq	mvax0, mvax0, mvfx15, mvfx0
     fe0:	00000acd 	andeq	r0, r0, sp, asr #21
     fe4:	0000046c 	andeq	r0, r0, ip, ror #8
     fe8:	00000477 	andeq	r0, r0, r7, ror r4
     fec:	0006ea13 	andeq	lr, r6, r3, lsl sl
     ff0:	04181400 	ldreq	r1, [r8], #-1024	; 0xfffffc00
     ff4:	15000000 	strne	r0, [r0, #-0]
     ff8:	00000ab5 			; <UNDEFINED> instruction: 0x00000ab5
     ffc:	860e3106 	strhi	r3, [lr], -r6, lsl #2
    1000:	fc000003 	stc2	0, cr0, [r0], {3}
    1004:	8f000001 	svchi	0x00000001
    1008:	9a000004 	bls	1020 <shift+0x1020>
    100c:	13000004 	movwne	r0, #4
    1010:	000006ea 	andeq	r0, r0, sl, ror #13
    1014:	00041e14 	andeq	r1, r4, r4, lsl lr
    1018:	03160000 	tsteq	r6, #0
    101c:	0600000b 	streq	r0, [r0], -fp
    1020:	0a7f1d35 	beq	1fc84fc <__bss_end+0x1fbe9bc>
    1024:	04180000 	ldreq	r0, [r8], #-0
    1028:	b3020000 	movwlt	r0, #8192	; 0x2000
    102c:	b9000004 	stmdblt	r0, {r2}
    1030:	13000004 	movwne	r0, #4
    1034:	000006ea 	andeq	r0, r0, sl, ror #13
    1038:	07331600 	ldreq	r1, [r3, -r0, lsl #12]!
    103c:	37060000 	strcc	r0, [r6, -r0]
    1040:	0009351d 	andeq	r3, r9, sp, lsl r5
    1044:	00041800 	andeq	r1, r4, r0, lsl #16
    1048:	04d20200 	ldrbeq	r0, [r2], #512	; 0x200
    104c:	04d80000 	ldrbeq	r0, [r8], #0
    1050:	ea130000 	b	4c1058 <__bss_end+0x4b7518>
    1054:	00000006 	andeq	r0, r0, r6
    1058:	00080917 	andeq	r0, r8, r7, lsl r9
    105c:	31390600 	teqcc	r9, r0, lsl #12
    1060:	00000703 	andeq	r0, r0, r3, lsl #14
    1064:	ac16020c 	lfmge	f0, 4, [r6], {12}
    1068:	06000004 	streq	r0, [r0], -r4
    106c:	0bff093c 	bleq	fffc3564 <__bss_end+0xfffb9a24>
    1070:	06ea0000 	strbteq	r0, [sl], r0
    1074:	ff010000 			; <UNDEFINED> instruction: 0xff010000
    1078:	05000004 	streq	r0, [r0, #-4]
    107c:	13000005 	movwne	r0, #5
    1080:	000006ea 	andeq	r0, r0, sl, ror #13
    1084:	0ab01600 	beq	fec0688c <__bss_end+0xfebfcd4c>
    1088:	3d060000 	stccc	0, cr0, [r6, #-0]
    108c:	0007e012 	andeq	lr, r7, r2, lsl r0
    1090:	00004d00 	andeq	r4, r0, r0, lsl #26
    1094:	051e0100 	ldreq	r0, [lr, #-256]	; 0xffffff00
    1098:	05290000 	streq	r0, [r9, #-0]!
    109c:	ea130000 	b	4c10a4 <__bss_end+0x4b7564>
    10a0:	14000006 	strne	r0, [r0], #-6
    10a4:	0000004d 	andeq	r0, r0, sp, asr #32
    10a8:	045c1600 	ldrbeq	r1, [ip], #-1536	; 0xfffffa00
    10ac:	3f060000 	svccc	0x00060000
    10b0:	000b7712 	andeq	r7, fp, r2, lsl r7
    10b4:	00004d00 	andeq	r4, r0, r0, lsl #26
    10b8:	05420100 	strbeq	r0, [r2, #-256]	; 0xffffff00
    10bc:	05570000 	ldrbeq	r0, [r7, #-0]
    10c0:	ea130000 	b	4c10c8 <__bss_end+0x4b7588>
    10c4:	14000006 	strne	r0, [r0], #-6
    10c8:	0000070c 	andeq	r0, r0, ip, lsl #14
    10cc:	00005e14 	andeq	r5, r0, r4, lsl lr
    10d0:	01fc1400 	mvnseq	r1, r0, lsl #8
    10d4:	18000000 	stmdane	r0, {}	; <UNPREDICTABLE>
    10d8:	00000851 	andeq	r0, r0, r1, asr r8
    10dc:	7d0e4106 	stfvcs	f4, [lr, #-24]	; 0xffffffe8
    10e0:	01000006 	tsteq	r0, r6
    10e4:	0000056c 	andeq	r0, r0, ip, ror #10
    10e8:	00000572 	andeq	r0, r0, r2, ror r5
    10ec:	0006ea13 	andeq	lr, r6, r3, lsl sl
    10f0:	c4180000 	ldrgt	r0, [r8], #-0
    10f4:	0600000a 	streq	r0, [r0], -sl
    10f8:	08a80e43 	stmiaeq	r8!, {r0, r1, r6, r9, sl, fp}
    10fc:	87010000 	strhi	r0, [r1, -r0]
    1100:	8d000005 	stchi	0, cr0, [r0, #-20]	; 0xffffffec
    1104:	13000005 	movwne	r0, #5
    1108:	000006ea 	andeq	r0, r0, sl, ror #13
    110c:	06a31600 	strteq	r1, [r3], r0, lsl #12
    1110:	46060000 	strmi	r0, [r6], -r0
    1114:	0003f317 	andeq	pc, r3, r7, lsl r3	; <UNPREDICTABLE>
    1118:	00041e00 	andeq	r1, r4, r0, lsl #28
    111c:	05a60100 	streq	r0, [r6, #256]!	; 0x100
    1120:	05ac0000 	streq	r0, [ip, #0]!
    1124:	12130000 	andsne	r0, r3, #0
    1128:	00000007 	andeq	r0, r0, r7
    112c:	00042f16 	andeq	r2, r4, r6, lsl pc
    1130:	17490600 	strbne	r0, [r9, -r0, lsl #12]
    1134:	00000a3c 	andeq	r0, r0, ip, lsr sl
    1138:	0000041e 	andeq	r0, r0, lr, lsl r4
    113c:	0005c501 	andeq	ip, r5, r1, lsl #10
    1140:	0005d000 	andeq	sp, r5, r0
    1144:	07121300 	ldreq	r1, [r2, -r0, lsl #6]
    1148:	4d140000 	ldcmi	0, cr0, [r4, #-0]
    114c:	00000000 	andeq	r0, r0, r0
    1150:	0006cb18 	andeq	ip, r6, r8, lsl fp
    1154:	0e4c0600 	cdpeq	6, 4, cr0, cr12, cr0, {0}
    1158:	00000352 	andeq	r0, r0, r2, asr r3
    115c:	0005e501 	andeq	lr, r5, r1, lsl #10
    1160:	0005eb00 	andeq	lr, r5, r0, lsl #22
    1164:	06ea1300 	strbteq	r1, [sl], r0, lsl #6
    1168:	16000000 	strne	r0, [r0], -r0
    116c:	00000ab5 			; <UNDEFINED> instruction: 0x00000ab5
    1170:	a40e4e06 	strge	r4, [lr], #-3590	; 0xfffff1fa
    1174:	fc000005 	stc2	0, cr0, [r0], {5}
    1178:	01000001 	tsteq	r0, r1
    117c:	00000604 	andeq	r0, r0, r4, lsl #12
    1180:	0000060f 	andeq	r0, r0, pc, lsl #12
    1184:	0006ea13 	andeq	lr, r6, r3, lsl sl
    1188:	004d1400 	subeq	r1, sp, r0, lsl #8
    118c:	16000000 	strne	r0, [r0], -r0
    1190:	000006b7 			; <UNDEFINED> instruction: 0x000006b7
    1194:	c9125106 	ldmdbgt	r2, {r1, r2, r8, ip, lr}
    1198:	4d000008 	stcmi	0, cr0, [r0, #-32]	; 0xffffffe0
    119c:	01000000 	mrseq	r0, (UNDEF: 0)
    11a0:	00000628 	andeq	r0, r0, r8, lsr #12
    11a4:	00000633 	andeq	r0, r0, r3, lsr r6
    11a8:	0006ea13 	andeq	lr, r6, r3, lsl sl
    11ac:	02091400 	andeq	r1, r9, #0, 8
    11b0:	16000000 	strne	r0, [r0], -r0
    11b4:	000003bc 			; <UNDEFINED> instruction: 0x000003bc
    11b8:	420e5406 	andmi	r5, lr, #100663296	; 0x6000000
    11bc:	fc000006 	stc2	0, cr0, [r0], {6}
    11c0:	01000001 	tsteq	r0, r1
    11c4:	0000064c 	andeq	r0, r0, ip, asr #12
    11c8:	00000657 	andeq	r0, r0, r7, asr r6
    11cc:	0006ea13 	andeq	lr, r6, r3, lsl sl
    11d0:	004d1400 	subeq	r1, sp, r0, lsl #8
    11d4:	18000000 	stmdane	r0, {}	; <UNPREDICTABLE>
    11d8:	0000070d 	andeq	r0, r0, sp, lsl #14
    11dc:	0f0e5706 	svceq	0x000e5706
    11e0:	0100000b 	tsteq	r0, fp
    11e4:	0000066c 	andeq	r0, r0, ip, ror #12
    11e8:	0000068b 	andeq	r0, r0, fp, lsl #13
    11ec:	0006ea13 	andeq	lr, r6, r3, lsl sl
    11f0:	00a91400 	adceq	r1, r9, r0, lsl #8
    11f4:	4d140000 	ldcmi	0, cr0, [r4, #-0]
    11f8:	14000000 	strne	r0, [r0], #-0
    11fc:	0000004d 	andeq	r0, r0, sp, asr #32
    1200:	00004d14 	andeq	r4, r0, r4, lsl sp
    1204:	07181400 	ldreq	r1, [r8, -r0, lsl #8]
    1208:	18000000 	stmdane	r0, {}	; <UNPREDICTABLE>
    120c:	00000a69 	andeq	r0, r0, r9, ror #20
    1210:	0c0e5906 			; <UNDEFINED> instruction: 0x0c0e5906
    1214:	01000005 	tsteq	r0, r5
    1218:	000006a0 	andeq	r0, r0, r0, lsr #13
    121c:	000006bf 			; <UNDEFINED> instruction: 0x000006bf
    1220:	0006ea13 	andeq	lr, r6, r3, lsl sl
    1224:	00ec1400 	rsceq	r1, ip, r0, lsl #8
    1228:	4d140000 	ldcmi	0, cr0, [r4, #-0]
    122c:	14000000 	strne	r0, [r0], #-0
    1230:	0000004d 	andeq	r0, r0, sp, asr #32
    1234:	00004d14 	andeq	r4, r0, r4, lsl sp
    1238:	07181400 	ldreq	r1, [r8, -r0, lsl #8]
    123c:	19000000 	stmdbne	r0, {}	; <UNPREDICTABLE>
    1240:	00000486 	andeq	r0, r0, r6, lsl #9
    1244:	bd0e5c06 	stclt	12, cr5, [lr, #-24]	; 0xffffffe8
    1248:	fc000004 	stc2	0, cr0, [r0], {4}
    124c:	01000001 	tsteq	r0, r1
    1250:	000006d4 	ldrdeq	r0, [r0], -r4
    1254:	0006ea13 	andeq	lr, r6, r3, lsl sl
    1258:	039b1400 	orrseq	r1, fp, #0, 8
    125c:	1e140000 	cdpne	0, 1, cr0, cr4, cr0, {0}
    1260:	00000007 	andeq	r0, r0, r7
    1264:	04240300 	strteq	r0, [r4], #-768	; 0xfffffd00
    1268:	040d0000 	streq	r0, [sp], #-0
    126c:	00000424 	andeq	r0, r0, r4, lsr #8
    1270:	0004181a 	andeq	r1, r4, sl, lsl r8
    1274:	0006fd00 	andeq	pc, r6, r0, lsl #26
    1278:	00070300 	andeq	r0, r7, r0, lsl #6
    127c:	06ea1300 	strbteq	r1, [sl], r0, lsl #6
    1280:	1b000000 	blne	1288 <shift+0x1288>
    1284:	00000424 	andeq	r0, r0, r4, lsr #8
    1288:	000006f0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
    128c:	003f040d 	eorseq	r0, pc, sp, lsl #8
    1290:	040d0000 	streq	r0, [sp], #-0
    1294:	000006e5 	andeq	r0, r0, r5, ror #13
    1298:	0065041c 	rsbeq	r0, r5, ip, lsl r4
    129c:	041d0000 	ldreq	r0, [sp], #-0
    12a0:	00002c0f 	andeq	r2, r0, pc, lsl #24
    12a4:	00073000 	andeq	r3, r7, r0
    12a8:	005e1000 	subseq	r1, lr, r0
    12ac:	00090000 	andeq	r0, r9, r0
    12b0:	00072003 	andeq	r2, r7, r3
    12b4:	0cdb1e00 	ldcleq	14, cr1, [fp], {0}
    12b8:	a5010000 	strge	r0, [r1, #-0]
    12bc:	0007300c 	andeq	r3, r7, ip
    12c0:	08030500 	stmdaeq	r3, {r8, sl}
    12c4:	1f00009b 	svcne	0x0000009b
    12c8:	00000c2c 	andeq	r0, r0, ip, lsr #24
    12cc:	fb0aa701 	blx	2aaeda <__bss_end+0x2a139a>
    12d0:	4d00000d 	stcmi	0, cr0, [r0, #-52]	; 0xffffffcc
    12d4:	b4000000 	strlt	r0, [r0], #-0
    12d8:	b0000086 	andlt	r0, r0, r6, lsl #1
    12dc:	01000000 	mrseq	r0, (UNDEF: 0)
    12e0:	0007a59c 	muleq	r7, ip, r5
    12e4:	0f982000 	svceq	0x00982000
    12e8:	a7010000 	strge	r0, [r1, -r0]
    12ec:	0002031b 	andeq	r0, r2, fp, lsl r3
    12f0:	ac910300 	ldcge	3, cr0, [r1], {0}
    12f4:	0e5a207f 	mrceq	0, 2, r2, cr10, cr15, {3}
    12f8:	a7010000 	strge	r0, [r1, -r0]
    12fc:	00004d2a 	andeq	r4, r0, sl, lsr #26
    1300:	a8910300 	ldmge	r1, {r8, r9}
    1304:	0d331e7f 	ldceq	14, cr1, [r3, #-508]!	; 0xfffffe04
    1308:	a9010000 	stmdbge	r1, {}	; <UNPREDICTABLE>
    130c:	0007a50a 	andeq	sl, r7, sl, lsl #10
    1310:	b4910300 	ldrlt	r0, [r1], #768	; 0x300
    1314:	0c4b1e7f 	mcrreq	14, 7, r1, fp, cr15
    1318:	ad010000 	stcge	0, cr0, [r1, #-0]
    131c:	00003809 	andeq	r3, r0, r9, lsl #16
    1320:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1324:	00250f00 	eoreq	r0, r5, r0, lsl #30
    1328:	07b50000 	ldreq	r0, [r5, r0]!
    132c:	5e100000 	cdppl	0, 1, cr0, cr0, cr0, {0}
    1330:	3f000000 	svccc	0x00000000
    1334:	0e3f2100 	rsfeqe	f2, f7, f0
    1338:	99010000 	stmdbls	r1, {}	; <UNPREDICTABLE>
    133c:	000ead0a 	andeq	sl, lr, sl, lsl #26
    1340:	00004d00 	andeq	r4, r0, r0, lsl #26
    1344:	00867800 	addeq	r7, r6, r0, lsl #16
    1348:	00003c00 	andeq	r3, r0, r0, lsl #24
    134c:	f29c0100 	vaddw.s16	q0, q6, d0
    1350:	22000007 	andcs	r0, r0, #7
    1354:	00716572 	rsbseq	r6, r1, r2, ror r5
    1358:	de209b01 	vmulle.f64	d9, d0, d1
    135c:	02000003 	andeq	r0, r0, #3
    1360:	f01e7491 			; <UNDEFINED> instruction: 0xf01e7491
    1364:	0100000d 	tsteq	r0, sp
    1368:	004d0e9c 	umaaleq	r0, sp, ip, lr
    136c:	91020000 	mrsls	r0, (UNDEF: 2)
    1370:	82230070 	eorhi	r0, r3, #112	; 0x70
    1374:	0100000e 	tsteq	r0, lr
    1378:	0c670690 	stcleq	6, cr0, [r7], #-576	; 0xfffffdc0
    137c:	863c0000 	ldrthi	r0, [ip], -r0
    1380:	003c0000 	eorseq	r0, ip, r0
    1384:	9c010000 	stcls	0, cr0, [r1], {-0}
    1388:	0000082b 	andeq	r0, r0, fp, lsr #16
    138c:	000ca920 	andeq	sl, ip, r0, lsr #18
    1390:	21900100 	orrscs	r0, r0, r0, lsl #2
    1394:	0000004d 	andeq	r0, r0, sp, asr #32
    1398:	226c9102 	rsbcs	r9, ip, #-2147483648	; 0x80000000
    139c:	00716572 	rsbseq	r6, r1, r2, ror r5
    13a0:	de209201 	cdple	2, 2, cr9, cr0, cr1, {0}
    13a4:	02000003 	andeq	r0, r0, #3
    13a8:	21007491 			; <UNDEFINED> instruction: 0x21007491
    13ac:	00000e1c 	andeq	r0, r0, ip, lsl lr
    13b0:	ec0a8401 	cfstrs	mvf8, [sl], {1}
    13b4:	4d00000c 	stcmi	0, cr0, [r0, #-48]	; 0xffffffd0
    13b8:	00000000 	andeq	r0, r0, r0
    13bc:	3c000086 	stccc	0, cr0, [r0], {134}	; 0x86
    13c0:	01000000 	mrseq	r0, (UNDEF: 0)
    13c4:	0008689c 	muleq	r8, ip, r8
    13c8:	65722200 	ldrbvs	r2, [r2, #-512]!	; 0xfffffe00
    13cc:	86010071 			; <UNDEFINED> instruction: 0x86010071
    13d0:	0003ba20 	andeq	fp, r3, r0, lsr #20
    13d4:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    13d8:	000c441e 	andeq	r4, ip, lr, lsl r4
    13dc:	0e870100 	rmfeqs	f0, f7, f0
    13e0:	0000004d 	andeq	r0, r0, sp, asr #32
    13e4:	00709102 	rsbseq	r9, r0, r2, lsl #2
    13e8:	000f7b21 	andeq	r7, pc, r1, lsr #22
    13ec:	0a780100 	beq	1e017f4 <__bss_end+0x1df7cb4>
    13f0:	00000cbd 			; <UNDEFINED> instruction: 0x00000cbd
    13f4:	0000004d 	andeq	r0, r0, sp, asr #32
    13f8:	000085c4 	andeq	r8, r0, r4, asr #11
    13fc:	0000003c 	andeq	r0, r0, ip, lsr r0
    1400:	08a59c01 	stmiaeq	r5!, {r0, sl, fp, ip, pc}
    1404:	72220000 	eorvc	r0, r2, #0
    1408:	01007165 	tsteq	r0, r5, ror #2
    140c:	03ba207a 			; <UNDEFINED> instruction: 0x03ba207a
    1410:	91020000 	mrsls	r0, (UNDEF: 2)
    1414:	0c441e74 	mcrreq	14, 7, r1, r4, cr4
    1418:	7b010000 	blvc	41420 <__bss_end+0x378e0>
    141c:	00004d0e 	andeq	r4, r0, lr, lsl #26
    1420:	70910200 	addsvc	r0, r1, r0, lsl #4
    1424:	0d002100 	stfeqs	f2, [r0, #-0]
    1428:	6c010000 	stcvs	0, cr0, [r1], {-0}
    142c:	000e9406 	andeq	r9, lr, r6, lsl #8
    1430:	0001fc00 	andeq	pc, r1, r0, lsl #24
    1434:	00857000 	addeq	r7, r5, r0
    1438:	00005400 	andeq	r5, r0, r0, lsl #8
    143c:	f19c0100 			; <UNDEFINED> instruction: 0xf19c0100
    1440:	20000008 	andcs	r0, r0, r8
    1444:	00000df0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
    1448:	4d156c01 	ldcmi	12, cr6, [r5, #-4]
    144c:	02000000 	andeq	r0, r0, #0
    1450:	f3206c91 	vqrdmlsh.s32	d6, d16, d1
    1454:	01000005 	tsteq	r0, r5
    1458:	004d256c 	subeq	r2, sp, ip, ror #10
    145c:	91020000 	mrsls	r0, (UNDEF: 2)
    1460:	0f731e68 	svceq	0x00731e68
    1464:	6e010000 	cdpvs	0, 0, cr0, cr1, cr0, {0}
    1468:	00004d0e 	andeq	r4, r0, lr, lsl #26
    146c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1470:	0c7e2100 	ldfeqe	f2, [lr], #-0
    1474:	5f010000 	svcpl	0x00010000
    1478:	000f1412 	andeq	r1, pc, r2, lsl r4	; <UNPREDICTABLE>
    147c:	00008b00 	andeq	r8, r0, r0, lsl #22
    1480:	00852000 	addeq	r2, r5, r0
    1484:	00005000 	andeq	r5, r0, r0
    1488:	4c9c0100 	ldfmis	f0, [ip], {0}
    148c:	20000009 	andcs	r0, r0, r9
    1490:	000009ae 	andeq	r0, r0, lr, lsr #19
    1494:	4d205f01 	stcmi	15, cr5, [r0, #-4]!
    1498:	02000000 	andeq	r0, r0, #0
    149c:	25206c91 	strcs	r6, [r0, #-3217]!	; 0xfffff36f
    14a0:	0100000e 	tsteq	r0, lr
    14a4:	004d2f5f 	subeq	r2, sp, pc, asr pc
    14a8:	91020000 	mrsls	r0, (UNDEF: 2)
    14ac:	05f32068 	ldrbeq	r2, [r3, #104]!	; 0x68
    14b0:	5f010000 	svcpl	0x00010000
    14b4:	00004d3f 	andeq	r4, r0, pc, lsr sp
    14b8:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    14bc:	000f731e 	andeq	r7, pc, lr, lsl r3	; <UNPREDICTABLE>
    14c0:	16610100 	strbtne	r0, [r1], -r0, lsl #2
    14c4:	0000008b 	andeq	r0, r0, fp, lsl #1
    14c8:	00749102 	rsbseq	r9, r4, r2, lsl #2
    14cc:	000f4a21 	andeq	r4, pc, r1, lsr #20
    14d0:	0a530100 	beq	14c18d8 <__bss_end+0x14b7d98>
    14d4:	00000c83 	andeq	r0, r0, r3, lsl #25
    14d8:	0000004d 	andeq	r0, r0, sp, asr #32
    14dc:	000084dc 	ldrdeq	r8, [r0], -ip
    14e0:	00000044 	andeq	r0, r0, r4, asr #32
    14e4:	09989c01 	ldmibeq	r8, {r0, sl, fp, ip, pc}
    14e8:	ae200000 	cdpge	0, 2, cr0, cr0, cr0, {0}
    14ec:	01000009 	tsteq	r0, r9
    14f0:	004d1a53 	subeq	r1, sp, r3, asr sl
    14f4:	91020000 	mrsls	r0, (UNDEF: 2)
    14f8:	0e25206c 	cdpeq	0, 2, cr2, cr5, cr12, {3}
    14fc:	53010000 	movwpl	r0, #4096	; 0x1000
    1500:	00004d29 	andeq	r4, r0, r9, lsr #26
    1504:	68910200 	ldmvs	r1, {r9}
    1508:	000f431e 	andeq	r4, pc, lr, lsl r3	; <UNPREDICTABLE>
    150c:	0e550100 	rdfeqs	f0, f5, f0
    1510:	0000004d 	andeq	r0, r0, sp, asr #32
    1514:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1518:	000f3d21 	andeq	r3, pc, r1, lsr #26
    151c:	0a460100 	beq	1181924 <__bss_end+0x1177de4>
    1520:	00000f1f 	andeq	r0, r0, pc, lsl pc
    1524:	0000004d 	andeq	r0, r0, sp, asr #32
    1528:	0000848c 	andeq	r8, r0, ip, lsl #9
    152c:	00000050 	andeq	r0, r0, r0, asr r0
    1530:	09f39c01 	ldmibeq	r3!, {r0, sl, fp, ip, pc}^
    1534:	ae200000 	cdpge	0, 2, cr0, cr0, cr0, {0}
    1538:	01000009 	tsteq	r0, r9
    153c:	004d1946 	subeq	r1, sp, r6, asr #18
    1540:	91020000 	mrsls	r0, (UNDEF: 2)
    1544:	0d14206c 	ldceq	0, cr2, [r4, #-432]	; 0xfffffe50
    1548:	46010000 	strmi	r0, [r1], -r0
    154c:	00012930 	andeq	r2, r1, r0, lsr r9
    1550:	68910200 	ldmvs	r1, {r9}
    1554:	000e2b20 	andeq	r2, lr, r0, lsr #22
    1558:	41460100 	mrsmi	r0, (UNDEF: 86)
    155c:	0000071e 	andeq	r0, r0, lr, lsl r7
    1560:	1e649102 	lgnnes	f1, f2
    1564:	00000f73 	andeq	r0, r0, r3, ror pc
    1568:	4d0e4801 	stcmi	8, cr4, [lr, #-4]
    156c:	02000000 	andeq	r0, r0, #0
    1570:	23007491 	movwcs	r7, #1169	; 0x491
    1574:	00000c31 	andeq	r0, r0, r1, lsr ip
    1578:	1e064001 	cdpne	0, 0, cr4, cr6, cr1, {0}
    157c:	6000000d 	andvs	r0, r0, sp
    1580:	2c000084 	stccs	0, cr0, [r0], {132}	; 0x84
    1584:	01000000 	mrseq	r0, (UNDEF: 0)
    1588:	000a1d9c 	muleq	sl, ip, sp
    158c:	09ae2000 	stmibeq	lr!, {sp}
    1590:	40010000 	andmi	r0, r1, r0
    1594:	00004d15 	andeq	r4, r0, r5, lsl sp
    1598:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    159c:	0dea2100 	stfeqe	f2, [sl]
    15a0:	33010000 	movwcc	r0, #4096	; 0x1000
    15a4:	000e310a 	andeq	r3, lr, sl, lsl #2
    15a8:	00004d00 	andeq	r4, r0, r0, lsl #26
    15ac:	00841000 	addeq	r1, r4, r0
    15b0:	00005000 	andeq	r5, r0, r0
    15b4:	789c0100 	ldmvc	ip, {r8}
    15b8:	2000000a 	andcs	r0, r0, sl
    15bc:	000009ae 	andeq	r0, r0, lr, lsr #19
    15c0:	4d193301 	ldcmi	3, cr3, [r9, #-4]
    15c4:	02000000 	andeq	r0, r0, #0
    15c8:	60206c91 	mlavs	r0, r1, ip, r6
    15cc:	0100000f 	tsteq	r0, pc
    15d0:	02032b33 	andeq	r2, r3, #52224	; 0xcc00
    15d4:	91020000 	mrsls	r0, (UNDEF: 2)
    15d8:	0e5e2068 	cdpeq	0, 5, cr2, cr14, cr8, {3}
    15dc:	33010000 	movwcc	r0, #4096	; 0x1000
    15e0:	00004d3c 	andeq	r4, r0, ip, lsr sp
    15e4:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    15e8:	000f0e1e 	andeq	r0, pc, lr, lsl lr	; <UNPREDICTABLE>
    15ec:	0e350100 	rsfeqs	f0, f5, f0
    15f0:	0000004d 	andeq	r0, r0, sp, asr #32
    15f4:	00749102 	rsbseq	r9, r4, r2, lsl #2
    15f8:	000f9d21 	andeq	r9, pc, r1, lsr #26
    15fc:	0a250100 	beq	941a04 <__bss_end+0x937ec4>
    1600:	00000f67 	andeq	r0, r0, r7, ror #30
    1604:	0000004d 	andeq	r0, r0, sp, asr #32
    1608:	000083c0 	andeq	r8, r0, r0, asr #7
    160c:	00000050 	andeq	r0, r0, r0, asr r0
    1610:	0ad39c01 	beq	ff4e861c <__bss_end+0xff4deadc>
    1614:	ae200000 	cdpge	0, 2, cr0, cr0, cr0, {0}
    1618:	01000009 	tsteq	r0, r9
    161c:	004d1825 	subeq	r1, sp, r5, lsr #16
    1620:	91020000 	mrsls	r0, (UNDEF: 2)
    1624:	0f60206c 	svceq	0x0060206c
    1628:	25010000 	strcs	r0, [r1, #-0]
    162c:	000ad92a 	andeq	sp, sl, sl, lsr #18
    1630:	68910200 	ldmvs	r1, {r9}
    1634:	000e5e20 	andeq	r5, lr, r0, lsr #28
    1638:	3b250100 	blcc	941a40 <__bss_end+0x937f00>
    163c:	0000004d 	andeq	r0, r0, sp, asr #32
    1640:	1e649102 	lgnnes	f1, f2
    1644:	00000c50 	andeq	r0, r0, r0, asr ip
    1648:	4d0e2701 	stcmi	7, cr2, [lr, #-4]
    164c:	02000000 	andeq	r0, r0, #0
    1650:	0d007491 	cfstrseq	mvf7, [r0, #-580]	; 0xfffffdbc
    1654:	00002504 	andeq	r2, r0, r4, lsl #10
    1658:	0ad30300 	beq	ff4c2260 <__bss_end+0xff4b8720>
    165c:	f6210000 			; <UNDEFINED> instruction: 0xf6210000
    1660:	0100000d 	tsteq	r0, sp
    1664:	0fa90a19 	svceq	0x00a90a19
    1668:	004d0000 	subeq	r0, sp, r0
    166c:	837c0000 	cmnhi	ip, #0
    1670:	00440000 	subeq	r0, r4, r0
    1674:	9c010000 	stcls	0, cr0, [r1], {-0}
    1678:	00000b2a 	andeq	r0, r0, sl, lsr #22
    167c:	000f9420 	andeq	r9, pc, r0, lsr #8
    1680:	1b190100 	blne	641a88 <__bss_end+0x637f48>
    1684:	00000203 	andeq	r0, r0, r3, lsl #4
    1688:	206c9102 	rsbcs	r9, ip, r2, lsl #2
    168c:	00000f5b 	andeq	r0, r0, fp, asr pc
    1690:	d2351901 	eorsle	r1, r5, #16384	; 0x4000
    1694:	02000001 	andeq	r0, r0, #1
    1698:	ae1e6891 	mrcge	8, 0, r6, cr14, cr1, {4}
    169c:	01000009 	tsteq	r0, r9
    16a0:	004d0e1b 	subeq	r0, sp, fp, lsl lr
    16a4:	91020000 	mrsls	r0, (UNDEF: 2)
    16a8:	9d240074 	stcls	0, cr0, [r4, #-464]!	; 0xfffffe30
    16ac:	0100000c 	tsteq	r0, ip
    16b0:	0c560614 	mrrceq	6, 1, r0, r6, cr4
    16b4:	83600000 	cmnhi	r0, #0
    16b8:	001c0000 	andseq	r0, ip, r0
    16bc:	9c010000 	stcls	0, cr0, [r1], {-0}
    16c0:	000f5123 	andeq	r5, pc, r3, lsr #2
    16c4:	060e0100 	streq	r0, [lr], -r0, lsl #2
    16c8:	00000d06 	andeq	r0, r0, r6, lsl #26
    16cc:	00008334 	andeq	r8, r0, r4, lsr r3
    16d0:	0000002c 	andeq	r0, r0, ip, lsr #32
    16d4:	0b6a9c01 	bleq	1aa86e0 <__bss_end+0x1a9eba0>
    16d8:	94200000 	strtls	r0, [r0], #-0
    16dc:	0100000c 	tsteq	r0, ip
    16e0:	0038140e 	eorseq	r1, r8, lr, lsl #8
    16e4:	91020000 	mrsls	r0, (UNDEF: 2)
    16e8:	a2250074 	eorge	r0, r5, #116	; 0x74
    16ec:	0100000f 	tsteq	r0, pc
    16f0:	0d280a04 	vstmdbeq	r8!, {s0-s3}
    16f4:	004d0000 	subeq	r0, sp, r0
    16f8:	83080000 	movwhi	r0, #32768	; 0x8000
    16fc:	002c0000 	eoreq	r0, ip, r0
    1700:	9c010000 	stcls	0, cr0, [r1], {-0}
    1704:	64697022 	strbtvs	r7, [r9], #-34	; 0xffffffde
    1708:	0e060100 	adfeqs	f0, f6, f0
    170c:	0000004d 	andeq	r0, r0, sp, asr #32
    1710:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1714:	00062d00 	andeq	r2, r6, r0, lsl #26
    1718:	6f000400 	svcvs	0x00000400
    171c:	04000006 	streq	r0, [r0], #-6
    1720:	000d3901 	andeq	r3, sp, r1, lsl #18
    1724:	10640400 	rsbne	r0, r4, r0, lsl #8
    1728:	0e630000 	cdpeq	0, 6, cr0, cr3, cr0, {0}
    172c:	87680000 	strbhi	r0, [r8, -r0]!
    1730:	0c2c0000 	stceq	0, cr0, [ip], #-0
    1734:	05d40000 	ldrbeq	r0, [r4]
    1738:	49020000 	stmdbmi	r2, {}	; <UNPREDICTABLE>
    173c:	03000000 	movweq	r0, #0
    1740:	000010c1 	andeq	r1, r0, r1, asr #1
    1744:	61100501 	tstvs	r0, r1, lsl #10
    1748:	11000000 	mrsne	r0, (UNDEF: 0)
    174c:	33323130 	teqcc	r2, #48, 2
    1750:	37363534 			; <UNDEFINED> instruction: 0x37363534
    1754:	42413938 	submi	r3, r1, #56, 18	; 0xe0000
    1758:	46454443 	strbmi	r4, [r5], -r3, asr #8
    175c:	01040000 	mrseq	r0, (UNDEF: 4)
    1760:	00250103 	eoreq	r0, r5, r3, lsl #2
    1764:	74050000 	strvc	r0, [r5], #-0
    1768:	61000000 	mrsvs	r0, (UNDEF: 0)
    176c:	06000000 	streq	r0, [r0], -r0
    1770:	00000066 	andeq	r0, r0, r6, rrx
    1774:	51070010 	tstpl	r7, r0, lsl r0
    1778:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    177c:	15b60704 	ldrne	r0, [r6, #1796]!	; 0x704
    1780:	01080000 	mrseq	r0, (UNDEF: 8)
    1784:	00091e08 	andeq	r1, r9, r8, lsl #28
    1788:	006d0700 	rsbeq	r0, sp, r0, lsl #14
    178c:	2a090000 	bcs	241794 <__bss_end+0x237c54>
    1790:	0a000000 	beq	1798 <shift+0x1798>
    1794:	000010cd 	andeq	r1, r0, sp, asr #1
    1798:	6206d001 	andvs	sp, r6, #1
    179c:	6c000011 	stcvs	0, cr0, [r0], {17}
    17a0:	28000090 	stmdacs	r0, {r4, r7}
    17a4:	01000003 	tsteq	r0, r3
    17a8:	00011f9c 	muleq	r1, ip, pc	; <UNPREDICTABLE>
    17ac:	00660b00 	rsbeq	r0, r6, r0, lsl #22
    17b0:	1f11d001 	svcne	0x0011d001
    17b4:	03000001 	movweq	r0, #1
    17b8:	0b7fa491 	bleq	1feaa04 <__bss_end+0x1fe0ec4>
    17bc:	d0010072 	andle	r0, r1, r2, ror r0
    17c0:	00012619 	andeq	r2, r1, r9, lsl r6
    17c4:	a0910300 	addsge	r0, r1, r0, lsl #6
    17c8:	11740c7f 	cmnne	r4, pc, ror ip
    17cc:	d2010000 	andle	r0, r1, #0
    17d0:	00012c13 	andeq	r2, r1, r3, lsl ip
    17d4:	58910200 	ldmpl	r1, {r9}
    17d8:	00111f0c 	andseq	r1, r1, ip, lsl #30
    17dc:	1bd20100 	blne	ff481be4 <__bss_end+0xff4780a4>
    17e0:	0000012c 	andeq	r0, r0, ip, lsr #2
    17e4:	0d509102 	ldfeqp	f1, [r0, #-8]
    17e8:	d2010069 	andle	r0, r1, #105	; 0x69
    17ec:	00012c24 	andeq	r2, r1, r4, lsr #24
    17f0:	48910200 	ldmmi	r1, {r9}
    17f4:	0010d20c 	andseq	sp, r0, ip, lsl #4
    17f8:	27d20100 	ldrbcs	r0, [r2, r0, lsl #2]
    17fc:	0000012c 	andeq	r0, r0, ip, lsr #2
    1800:	0c409102 	stfeqp	f1, [r0], {2}
    1804:	000010b1 	strheq	r1, [r0], -r1	; <UNPREDICTABLE>
    1808:	2c2fd201 	sfmcs	f5, 1, [pc], #-4	; 180c <shift+0x180c>
    180c:	03000001 	movweq	r0, #1
    1810:	0c7fb891 	ldcleq	8, cr11, [pc], #-580	; 15d4 <shift+0x15d4>
    1814:	00001035 	andeq	r1, r0, r5, lsr r0
    1818:	2c39d201 	lfmcs	f5, 1, [r9], #-4
    181c:	03000001 	movweq	r0, #1
    1820:	0c7fb091 	ldcleq	0, cr11, [pc], #-580	; 15e4 <shift+0x15e4>
    1824:	000010e0 	andeq	r1, r0, r0, ror #1
    1828:	1f0bd301 	svcne	0x000bd301
    182c:	03000001 	movweq	r0, #1
    1830:	007fac91 			; <UNDEFINED> instruction: 0x007fac91
    1834:	bd040408 	cfstrslt	mvf0, [r4, #-32]	; 0xffffffe0
    1838:	0e000012 	mcreq	0, 0, r0, cr0, cr2, {0}
    183c:	00006d04 	andeq	r6, r0, r4, lsl #26
    1840:	05080800 	streq	r0, [r8, #-2048]	; 0xfffff800
    1844:	00000243 	andeq	r0, r0, r3, asr #4
    1848:	0011270f 	andseq	r2, r1, pc, lsl #14
    184c:	05c60100 	strbeq	r0, [r6, #256]	; 0x100
    1850:	00000ffc 	strdeq	r0, [r0], -ip
    1854:	0000017f 	andeq	r0, r0, pc, ror r1
    1858:	00009004 	andeq	r9, r0, r4
    185c:	00000068 	andeq	r0, r0, r8, rrx
    1860:	017f9c01 	cmneq	pc, r1, lsl #24
    1864:	d2100000 	andsle	r0, r0, #0
    1868:	01000010 	tsteq	r0, r0, lsl r0
    186c:	017f0ec6 	cmneq	pc, r6, asr #29
    1870:	91020000 	mrsls	r0, (UNDEF: 2)
    1874:	0e25106c 	cdpeq	0, 2, cr1, cr5, cr12, {3}
    1878:	c6010000 	strgt	r0, [r1], -r0
    187c:	00017f1a 	andeq	r7, r1, sl, lsl pc
    1880:	68910200 	ldmvs	r1, {r9}
    1884:	0001250c 	andeq	r2, r1, ip, lsl #10
    1888:	09c80100 	stmibeq	r8, {r8}^
    188c:	0000017f 	andeq	r0, r0, pc, ror r1
    1890:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1894:	69050411 	stmdbvs	r5, {r0, r4, sl}
    1898:	1200746e 	andne	r7, r0, #1845493760	; 0x6e000000
    189c:	000010fc 	strdeq	r1, [r0], -ip
    18a0:	d606bb01 	strle	fp, [r6], -r1, lsl #22
    18a4:	8400000f 	strhi	r0, [r0], #-15
    18a8:	8000008f 	andhi	r0, r0, pc, lsl #1
    18ac:	01000000 	mrseq	r0, (UNDEF: 0)
    18b0:	0002039c 	muleq	r2, ip, r3
    18b4:	72730b00 	rsbsvc	r0, r3, #0, 22
    18b8:	bb010063 	bllt	41a4c <__bss_end+0x37f0c>
    18bc:	00020319 	andeq	r0, r2, r9, lsl r3
    18c0:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    18c4:	7473640b 	ldrbtvc	r6, [r3], #-1035	; 0xfffffbf5
    18c8:	24bb0100 	ldrtcs	r0, [fp], #256	; 0x100
    18cc:	0000020a 	andeq	r0, r0, sl, lsl #4
    18d0:	0b609102 	bleq	1825ce0 <__bss_end+0x181c1a0>
    18d4:	006d756e 	rsbeq	r7, sp, lr, ror #10
    18d8:	7f2dbb01 	svcvc	0x002dbb01
    18dc:	02000001 	andeq	r0, r0, #1
    18e0:	d90c5c91 	stmdble	ip, {r0, r4, r7, sl, fp, ip, lr}
    18e4:	01000010 	tsteq	r0, r0, lsl r0
    18e8:	020c0ebd 	andeq	r0, ip, #3024	; 0xbd0
    18ec:	91020000 	mrsls	r0, (UNDEF: 2)
    18f0:	10ba0c70 	adcsne	r0, sl, r0, ror ip
    18f4:	be010000 	cdplt	0, 0, cr0, cr1, cr0, {0}
    18f8:	00012608 	andeq	r2, r1, r8, lsl #12
    18fc:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1900:	008fac13 	addeq	sl, pc, r3, lsl ip	; <UNPREDICTABLE>
    1904:	00004800 	andeq	r4, r0, r0, lsl #16
    1908:	00690d00 	rsbeq	r0, r9, r0, lsl #26
    190c:	7f0bc001 	svcvc	0x000bc001
    1910:	02000001 	andeq	r0, r0, #1
    1914:	00007491 	muleq	r0, r1, r4
    1918:	0209040e 	andeq	r0, r9, #234881024	; 0xe000000
    191c:	15140000 	ldrne	r0, [r4, #-0]
    1920:	74040e04 	strvc	r0, [r4], #-3588	; 0xfffff1fc
    1924:	12000000 	andne	r0, r0, #0
    1928:	000010f6 	strdeq	r1, [r0], -r6
    192c:	4106b301 	tstmi	r6, r1, lsl #6
    1930:	1c000010 	stcne	0, cr0, [r0], {16}
    1934:	6800008f 	stmdavs	r0, {r0, r1, r2, r3, r7}
    1938:	01000000 	mrseq	r0, (UNDEF: 0)
    193c:	0002719c 	muleq	r2, ip, r1
    1940:	116d1000 	cmnne	sp, r0
    1944:	b3010000 	movwlt	r0, #4096	; 0x1000
    1948:	00020a12 	andeq	r0, r2, r2, lsl sl
    194c:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1950:	00117410 	andseq	r7, r1, r0, lsl r4
    1954:	1eb30100 	frdnes	f0, f3, f0
    1958:	0000017f 	andeq	r0, r0, pc, ror r1
    195c:	0d689102 	stfeqp	f1, [r8, #-8]!
    1960:	006d656d 	rsbeq	r6, sp, sp, ror #10
    1964:	2608b501 	strcs	fp, [r8], -r1, lsl #10
    1968:	02000001 	andeq	r0, r0, #1
    196c:	38137091 	ldmdacc	r3, {r0, r4, r7, ip, sp, lr}
    1970:	3c00008f 	stccc	0, cr0, [r0], {143}	; 0x8f
    1974:	0d000000 	stceq	0, cr0, [r0, #-0]
    1978:	b7010069 	strlt	r0, [r1, -r9, rrx]
    197c:	00017f0b 	andeq	r7, r1, fp, lsl #30
    1980:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1984:	96160000 	ldrls	r0, [r6], -r0
    1988:	01000010 	tsteq	r0, r0, lsl r0
    198c:	118207a2 	orrne	r0, r2, r2, lsr #15
    1990:	01260000 			; <UNDEFINED> instruction: 0x01260000
    1994:	8e440000 	cdphi	0, 4, cr0, cr4, cr0, {0}
    1998:	00d80000 	sbcseq	r0, r8, r0
    199c:	9c010000 	stcls	0, cr0, [r1], {-0}
    19a0:	000002f0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
    19a4:	00102a10 	andseq	r2, r0, r0, lsl sl
    19a8:	15a20100 	strne	r0, [r2, #256]!	; 0x100
    19ac:	00000126 	andeq	r0, r0, r6, lsr #2
    19b0:	0b649102 	bleq	1925dc0 <__bss_end+0x191c280>
    19b4:	00637273 	rsbeq	r7, r3, r3, ror r2
    19b8:	0c27a201 	sfmeq	f2, 1, [r7], #-4
    19bc:	02000002 	andeq	r0, r0, #2
    19c0:	5e106091 	mrcpl	0, 0, r6, cr0, cr1, {4}
    19c4:	0100000e 	tsteq	r0, lr
    19c8:	017f2fa2 	cmneq	pc, r2, lsr #31
    19cc:	91020000 	mrsls	r0, (UNDEF: 2)
    19d0:	109e0c5c 	addsne	r0, lr, ip, asr ip
    19d4:	a3010000 	movwge	r0, #4096	; 0x1000
    19d8:	00017f09 	andeq	r7, r1, r9, lsl #30
    19dc:	6c910200 	lfmvs	f0, 4, [r1], {0}
    19e0:	01006d0d 	tsteq	r0, sp, lsl #26
    19e4:	017f09a5 	cmneq	pc, r5, lsr #19
    19e8:	91020000 	mrsls	r0, (UNDEF: 2)
    19ec:	8e881374 	mcrhi	3, 4, r1, cr8, cr4, {3}
    19f0:	00700000 	rsbseq	r0, r0, r0
    19f4:	690d0000 	stmdbvs	sp, {}	; <UNPREDICTABLE>
    19f8:	0da90100 	stfeqs	f0, [r9]
    19fc:	0000017f 	andeq	r0, r0, pc, ror r1
    1a00:	00709102 	rsbseq	r9, r0, r2, lsl #2
    1a04:	103a1600 	eorsne	r1, sl, r0, lsl #12
    1a08:	98010000 	stmdals	r1, {}	; <UNPREDICTABLE>
    1a0c:	00105507 	andseq	r5, r0, r7, lsl #10
    1a10:	00012600 	andeq	r2, r1, r0, lsl #12
    1a14:	008d9800 	addeq	r9, sp, r0, lsl #16
    1a18:	0000ac00 	andeq	sl, r0, r0, lsl #24
    1a1c:	6d9c0100 	ldfvss	f0, [ip]
    1a20:	10000003 	andne	r0, r0, r3
    1a24:	0000102a 	andeq	r1, r0, sl, lsr #32
    1a28:	26149801 	ldrcs	r9, [r4], -r1, lsl #16
    1a2c:	02000001 	andeq	r0, r0, #1
    1a30:	730b6491 	movwvc	r6, #46225	; 0xb491
    1a34:	01006372 	tsteq	r0, r2, ror r3
    1a38:	020c2698 	andeq	r2, ip, #152, 12	; 0x9800000
    1a3c:	91020000 	mrsls	r0, (UNDEF: 2)
    1a40:	006e0d60 	rsbeq	r0, lr, r0, ror #26
    1a44:	7f099901 	svcvc	0x00099901
    1a48:	02000001 	andeq	r0, r0, #1
    1a4c:	6d0d6c91 	stcvs	12, cr6, [sp, #-580]	; 0xfffffdbc
    1a50:	099a0100 	ldmibeq	sl, {r8}
    1a54:	0000017f 	andeq	r0, r0, pc, ror r1
    1a58:	0c749102 	ldfeqp	f1, [r4], #-8
    1a5c:	0000109e 	muleq	r0, lr, r0
    1a60:	7f099b01 	svcvc	0x00099b01
    1a64:	02000001 	andeq	r0, r0, #1
    1a68:	cc136891 	ldcgt	8, cr6, [r3], {145}	; 0x91
    1a6c:	5400008d 	strpl	r0, [r0], #-141	; 0xffffff73
    1a70:	0d000000 	stceq	0, cr0, [r0, #-0]
    1a74:	9c010069 	stcls	0, cr0, [r1], {105}	; 0x69
    1a78:	00017f0d 	andeq	r7, r1, sp, lsl #30
    1a7c:	70910200 	addsvc	r0, r1, r0, lsl #4
    1a80:	7b0f0000 	blvc	3c1a88 <__bss_end+0x3b7f48>
    1a84:	01000011 	tsteq	r0, r1, lsl r0
    1a88:	112c058d 	smlawbne	ip, sp, r5, r0
    1a8c:	017f0000 	cmneq	pc, r0
    1a90:	8d440000 	stclhi	0, cr0, [r4, #-0]
    1a94:	00540000 	subseq	r0, r4, r0
    1a98:	9c010000 	stcls	0, cr0, [r1], {-0}
    1a9c:	000003a6 	andeq	r0, r0, r6, lsr #7
    1aa0:	0100730b 	tsteq	r0, fp, lsl #6
    1aa4:	020c188d 	andeq	r1, ip, #9240576	; 0x8d0000
    1aa8:	91020000 	mrsls	r0, (UNDEF: 2)
    1aac:	00690d6c 	rsbeq	r0, r9, ip, ror #26
    1ab0:	7f068f01 	svcvc	0x00068f01
    1ab4:	02000001 	andeq	r0, r0, #1
    1ab8:	0f007491 	svceq	0x00007491
    1abc:	00001103 	andeq	r1, r0, r3, lsl #2
    1ac0:	39057d01 	stmdbcc	r5, {r0, r8, sl, fp, ip, sp, lr}
    1ac4:	7f000011 	svcvc	0x00000011
    1ac8:	98000001 	stmdals	r0, {r0}
    1acc:	ac00008c 	stcge	0, cr0, [r0], {140}	; 0x8c
    1ad0:	01000000 	mrseq	r0, (UNDEF: 0)
    1ad4:	00040c9c 	muleq	r4, ip, ip
    1ad8:	31730b00 	cmncc	r3, r0, lsl #22
    1adc:	197d0100 	ldmdbne	sp!, {r8}^
    1ae0:	0000020c 	andeq	r0, r0, ip, lsl #4
    1ae4:	0b6c9102 	bleq	1b25ef4 <__bss_end+0x1b1c3b4>
    1ae8:	01003273 	tsteq	r0, r3, ror r2
    1aec:	020c297d 	andeq	r2, ip, #2048000	; 0x1f4000
    1af0:	91020000 	mrsls	r0, (UNDEF: 2)
    1af4:	756e0b68 	strbvc	r0, [lr, #-2920]!	; 0xfffff498
    1af8:	7d01006d 	stcvc	0, cr0, [r1, #-436]	; 0xfffffe4c
    1afc:	00017f31 	andeq	r7, r1, r1, lsr pc
    1b00:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    1b04:	0031750d 	eorseq	r7, r1, sp, lsl #10
    1b08:	0c107f01 	ldceq	15, cr7, [r0], {1}
    1b0c:	02000004 	andeq	r0, r0, #4
    1b10:	750d7791 	strvc	r7, [sp, #-1937]	; 0xfffff86f
    1b14:	7f010032 	svcvc	0x00010032
    1b18:	00040c14 	andeq	r0, r4, r4, lsl ip
    1b1c:	76910200 	ldrvc	r0, [r1], r0, lsl #4
    1b20:	08010800 	stmdaeq	r1, {fp}
    1b24:	00000915 	andeq	r0, r0, r5, lsl r9
    1b28:	00104d0f 	andseq	r4, r0, pc, lsl #26
    1b2c:	07710100 	ldrbeq	r0, [r1, -r0, lsl #2]!
    1b30:	00000fc5 	andeq	r0, r0, r5, asr #31
    1b34:	00000126 	andeq	r0, r0, r6, lsr #2
    1b38:	00008bd8 	ldrdeq	r8, [r0], -r8	; <UNPREDICTABLE>
    1b3c:	000000c0 	andeq	r0, r0, r0, asr #1
    1b40:	046c9c01 	strbteq	r9, [ip], #-3073	; 0xfffff3ff
    1b44:	2a100000 	bcs	401b4c <__bss_end+0x3f800c>
    1b48:	01000010 	tsteq	r0, r0, lsl r0
    1b4c:	01261571 			; <UNDEFINED> instruction: 0x01261571
    1b50:	91020000 	mrsls	r0, (UNDEF: 2)
    1b54:	72730b6c 	rsbsvc	r0, r3, #108, 22	; 0x1b000
    1b58:	71010063 	tstvc	r1, r3, rrx
    1b5c:	00020c27 	andeq	r0, r2, r7, lsr #24
    1b60:	68910200 	ldmvs	r1, {r9}
    1b64:	6d756e0b 	ldclvs	14, cr6, [r5, #-44]!	; 0xffffffd4
    1b68:	30710100 	rsbscc	r0, r1, r0, lsl #2
    1b6c:	0000017f 	andeq	r0, r0, pc, ror r1
    1b70:	0d649102 	stfeqp	f1, [r4, #-8]!
    1b74:	73010069 	movwvc	r0, #4201	; 0x1069
    1b78:	00017f06 	andeq	r7, r1, r6, lsl #30
    1b7c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1b80:	10060f00 	andne	r0, r6, r0, lsl #30
    1b84:	55010000 	strpl	r0, [r1, #-0]
    1b88:	00101f07 	andseq	r1, r0, r7, lsl #30
    1b8c:	00011f00 	andeq	r1, r1, r0, lsl #30
    1b90:	008a7c00 	addeq	r7, sl, r0, lsl #24
    1b94:	00015c00 	andeq	r5, r1, r0, lsl #24
    1b98:	0d9c0100 	ldfeqs	f0, [ip]
    1b9c:	10000005 	andne	r0, r0, r5
    1ba0:	0000102f 	andeq	r1, r0, pc, lsr #32
    1ba4:	0c185501 	cfldr32eq	mvfx5, [r8], {1}
    1ba8:	02000002 	andeq	r0, r0, #2
    1bac:	180c4491 	stmdane	ip, {r0, r4, r7, sl, lr}
    1bb0:	01000011 	tsteq	r0, r1, lsl r0
    1bb4:	050d0c56 	streq	r0, [sp, #-3158]	; 0xfffff3aa
    1bb8:	91020000 	mrsls	r0, (UNDEF: 2)
    1bbc:	10a50c70 	adcne	r0, r5, r0, ror ip
    1bc0:	57010000 	strpl	r0, [r1, -r0]
    1bc4:	00050d0c 	andeq	r0, r5, ip, lsl #26
    1bc8:	60910200 	addsvs	r0, r1, r0, lsl #4
    1bcc:	706d740d 	rsbvc	r7, sp, sp, lsl #8
    1bd0:	0c590100 	ldfeqe	f0, [r9], {-0}
    1bd4:	0000050d 	andeq	r0, r0, sp, lsl #10
    1bd8:	0c589102 	ldfeqp	f1, [r8], {2}
    1bdc:	000007b8 			; <UNDEFINED> instruction: 0x000007b8
    1be0:	7f095a01 	svcvc	0x00095a01
    1be4:	02000001 	andeq	r0, r0, #1
    1be8:	a60c5491 			; <UNDEFINED> instruction: 0xa60c5491
    1bec:	01000015 	tsteq	r0, r5, lsl r0
    1bf0:	017f095b 	cmneq	pc, fp, asr r9	; <UNPREDICTABLE>
    1bf4:	91020000 	mrsls	r0, (UNDEF: 2)
    1bf8:	10e80c6c 	rscne	r0, r8, ip, ror #24
    1bfc:	5c010000 	stcpl	0, cr0, [r1], {-0}
    1c00:	0005140a 	andeq	r1, r5, sl, lsl #8
    1c04:	6b910200 	blvs	fe44240c <__bss_end+0xfe4388cc>
    1c08:	008ad813 	addeq	sp, sl, r3, lsl r8
    1c0c:	0000d000 	andeq	sp, r0, r0
    1c10:	61760d00 	cmnvs	r6, r0, lsl #26
    1c14:	6501006c 	strvs	r0, [r1, #-108]	; 0xffffff94
    1c18:	00050d10 	andeq	r0, r5, r0, lsl sp
    1c1c:	48910200 	ldmmi	r1, {r9}
    1c20:	08080000 	stmdaeq	r8, {}	; <UNPREDICTABLE>
    1c24:	00156604 	andseq	r6, r5, r4, lsl #12
    1c28:	02010800 	andeq	r0, r1, #0, 16
    1c2c:	00000771 	andeq	r0, r0, r1, ror r7
    1c30:	00100b0f 	andseq	r0, r0, pc, lsl #22
    1c34:	053a0100 	ldreq	r0, [sl, #-256]!	; 0xffffff00
    1c38:	00000fe6 	andeq	r0, r0, r6, ror #31
    1c3c:	0000017f 	andeq	r0, r0, pc, ror r1
    1c40:	0000897c 	andeq	r8, r0, ip, ror r9
    1c44:	00000100 	andeq	r0, r0, r0, lsl #2
    1c48:	057e9c01 	ldrbeq	r9, [lr, #-3073]!	; 0xfffff3ff
    1c4c:	2f100000 	svccs	0x00100000
    1c50:	01000010 	tsteq	r0, r0, lsl r0
    1c54:	020c213a 	andeq	r2, ip, #-2147483634	; 0x8000000e
    1c58:	91020000 	mrsls	r0, (UNDEF: 2)
    1c5c:	6f640d6c 	svcvs	0x00640d6c
    1c60:	3c010074 	stccc	0, cr0, [r1], {116}	; 0x74
    1c64:	0005140a 	andeq	r1, r5, sl, lsl #8
    1c68:	77910200 	ldrvc	r0, [r1, r0, lsl #4]
    1c6c:	00110b0c 	andseq	r0, r1, ip, lsl #22
    1c70:	0a3d0100 	beq	f42078 <__bss_end+0xf38538>
    1c74:	00000514 	andeq	r0, r0, r4, lsl r5
    1c78:	13769102 	cmnne	r6, #-2147483648	; 0x80000000
    1c7c:	000089ac 	andeq	r8, r0, ip, lsr #19
    1c80:	0000008c 	andeq	r0, r0, ip, lsl #1
    1c84:	0100630d 	tsteq	r0, sp, lsl #6
    1c88:	006d0e3f 	rsbeq	r0, sp, pc, lsr lr
    1c8c:	91020000 	mrsls	r0, (UNDEF: 2)
    1c90:	0f000075 	svceq	0x00000075
    1c94:	0000101a 	andeq	r1, r0, sl, lsl r0
    1c98:	4b052601 	blmi	14b4a4 <__bss_end+0x141964>
    1c9c:	7f000011 	svcvc	0x00000011
    1ca0:	e0000001 	and	r0, r0, r1
    1ca4:	9c000088 	stcls	0, cr0, [r0], {136}	; 0x88
    1ca8:	01000000 	mrseq	r0, (UNDEF: 0)
    1cac:	0005bb9c 	muleq	r5, ip, fp
    1cb0:	102f1000 	eorne	r1, pc, r0
    1cb4:	26010000 	strcs	r0, [r1], -r0
    1cb8:	00020c16 	andeq	r0, r2, r6, lsl ip
    1cbc:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1cc0:	0011180c 	andseq	r1, r1, ip, lsl #16
    1cc4:	06280100 	strteq	r0, [r8], -r0, lsl #2
    1cc8:	0000017f 	andeq	r0, r0, pc, ror r1
    1ccc:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1cd0:	0010ac17 	andseq	sl, r0, r7, lsl ip
    1cd4:	06080100 	streq	r0, [r8], -r0, lsl #2
    1cd8:	00001156 	andeq	r1, r0, r6, asr r1
    1cdc:	00008768 	andeq	r8, r0, r8, ror #14
    1ce0:	00000178 	andeq	r0, r0, r8, ror r1
    1ce4:	2f109c01 	svccs	0x00109c01
    1ce8:	01000010 	tsteq	r0, r0, lsl r0
    1cec:	017f0f08 	cmneq	pc, r8, lsl #30
    1cf0:	91020000 	mrsls	r0, (UNDEF: 2)
    1cf4:	11181064 	tstne	r8, r4, rrx
    1cf8:	08010000 	stmdaeq	r1, {}	; <UNPREDICTABLE>
    1cfc:	0001261c 	andeq	r2, r1, ip, lsl r6
    1d00:	60910200 	addsvs	r0, r1, r0, lsl #4
    1d04:	0012b010 	andseq	fp, r2, r0, lsl r0
    1d08:	31080100 	mrscc	r0, (UNDEF: 24)
    1d0c:	00000066 	andeq	r0, r0, r6, rrx
    1d10:	0d5c9102 	ldfeqp	f1, [ip, #-8]
    1d14:	0a010069 	beq	41ec0 <__bss_end+0x38380>
    1d18:	00017f09 	andeq	r7, r1, r9, lsl #30
    1d1c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1d20:	01006a0d 	tsteq	r0, sp, lsl #20
    1d24:	017f090b 	cmneq	pc, fp, lsl #18
    1d28:	91020000 	mrsls	r0, (UNDEF: 2)
    1d2c:	88601370 	stmdahi	r0!, {r4, r5, r6, r8, r9, ip}^
    1d30:	00600000 	rsbeq	r0, r0, r0
    1d34:	630d0000 	movwvs	r0, #53248	; 0xd000
    1d38:	081f0100 	ldmdaeq	pc, {r8}	; <UNPREDICTABLE>
    1d3c:	0000006d 	andeq	r0, r0, sp, rrx
    1d40:	006f9102 	rsbeq	r9, pc, r2, lsl #2
    1d44:	00220000 	eoreq	r0, r2, r0
    1d48:	00020000 	andeq	r0, r2, r0
    1d4c:	000007d0 	ldrdeq	r0, [r0], -r0	; <UNPREDICTABLE>
    1d50:	0ad60104 	beq	ff582168 <__bss_end+0xff578628>
    1d54:	93940000 	orrsls	r0, r4, #0
    1d58:	95a00000 	strls	r0, [r0, #0]!
    1d5c:	11930000 	orrsne	r0, r3, r0
    1d60:	11c30000 	bicne	r0, r3, r0
    1d64:	122b0000 	eorne	r0, fp, #0
    1d68:	80010000 	andhi	r0, r1, r0
    1d6c:	00000022 	andeq	r0, r0, r2, lsr #32
    1d70:	07e40002 	strbeq	r0, [r4, r2]!
    1d74:	01040000 	mrseq	r0, (UNDEF: 4)
    1d78:	00000b53 	andeq	r0, r0, r3, asr fp
    1d7c:	000095a0 	andeq	r9, r0, r0, lsr #11
    1d80:	000095a4 	andeq	r9, r0, r4, lsr #11
    1d84:	00001193 	muleq	r0, r3, r1
    1d88:	000011c3 	andeq	r1, r0, r3, asr #3
    1d8c:	0000122b 	andeq	r1, r0, fp, lsr #4
    1d90:	00228001 	eoreq	r8, r2, r1
    1d94:	00020000 	andeq	r0, r2, r0
    1d98:	000007f8 	strdeq	r0, [r0], -r8
    1d9c:	0bb30104 	bleq	fecc21b4 <__bss_end+0xfecb8674>
    1da0:	95a40000 	strls	r0, [r4, #0]!
    1da4:	97f40000 	ldrbls	r0, [r4, r0]!
    1da8:	12370000 	eorsne	r0, r7, #0
    1dac:	11c30000 	bicne	r0, r3, r0
    1db0:	122b0000 	eorne	r0, fp, #0
    1db4:	80010000 	andhi	r0, r1, r0
    1db8:	00000022 	andeq	r0, r0, r2, lsr #32
    1dbc:	080c0002 	stmdaeq	ip, {r1}
    1dc0:	01040000 	mrseq	r0, (UNDEF: 4)
    1dc4:	00000cb2 			; <UNDEFINED> instruction: 0x00000cb2
    1dc8:	000097f4 	strdeq	r9, [r0], -r4
    1dcc:	000098c8 	andeq	r9, r0, r8, asr #17
    1dd0:	00001268 	andeq	r1, r0, r8, ror #4
    1dd4:	000011c3 	andeq	r1, r0, r3, asr #3
    1dd8:	0000122b 	andeq	r1, r0, fp, lsr #4
    1ddc:	032a8001 			; <UNDEFINED> instruction: 0x032a8001
    1de0:	00040000 	andeq	r0, r4, r0
    1de4:	00000820 	andeq	r0, r0, r0, lsr #16
    1de8:	13b40104 			; <UNDEFINED> instruction: 0x13b40104
    1dec:	6d0c0000 	stcvs	0, cr0, [ip, #-0]
    1df0:	c3000015 	movwgt	r0, #21
    1df4:	30000011 	andcc	r0, r0, r1, lsl r0
    1df8:	0200000d 	andeq	r0, r0, #13
    1dfc:	6e690504 	cdpvs	5, 6, cr0, cr9, cr4, {0}
    1e00:	04030074 	streq	r0, [r3], #-116	; 0xffffff8c
    1e04:	0015b607 	andseq	fp, r5, r7, lsl #12
    1e08:	05080300 	streq	r0, [r8, #-768]	; 0xfffffd00
    1e0c:	00000243 	andeq	r0, r0, r3, asr #4
    1e10:	61040803 	tstvs	r4, r3, lsl #16
    1e14:	03000015 	movweq	r0, #21
    1e18:	09150801 	ldmdbeq	r5, {r0, fp}
    1e1c:	01030000 	mrseq	r0, (UNDEF: 3)
    1e20:	00091706 	andeq	r1, r9, r6, lsl #14
    1e24:	17390400 	ldrne	r0, [r9, -r0, lsl #8]!
    1e28:	01070000 	mrseq	r0, (UNDEF: 7)
    1e2c:	00000039 	andeq	r0, r0, r9, lsr r0
    1e30:	d4061701 	strle	r1, [r6], #-1793	; 0xfffff8ff
    1e34:	05000001 	streq	r0, [r0, #-1]
    1e38:	000012c3 	andeq	r1, r0, r3, asr #5
    1e3c:	17e80500 	strbne	r0, [r8, r0, lsl #10]!
    1e40:	05010000 	streq	r0, [r1, #-0]
    1e44:	00001496 	muleq	r0, r6, r4
    1e48:	15540502 	ldrbne	r0, [r4, #-1282]	; 0xfffffafe
    1e4c:	05030000 	streq	r0, [r3, #-0]
    1e50:	00001752 	andeq	r1, r0, r2, asr r7
    1e54:	17f80504 	ldrbne	r0, [r8, r4, lsl #10]!
    1e58:	05050000 	streq	r0, [r5, #-0]
    1e5c:	00001768 	andeq	r1, r0, r8, ror #14
    1e60:	159d0506 	ldrne	r0, [sp, #1286]	; 0x506
    1e64:	05070000 	streq	r0, [r7, #-0]
    1e68:	000016e3 	andeq	r1, r0, r3, ror #13
    1e6c:	16f10508 	ldrbtne	r0, [r1], r8, lsl #10
    1e70:	05090000 	streq	r0, [r9, #-0]
    1e74:	000016ff 	strdeq	r1, [r0], -pc	; <UNPREDICTABLE>
    1e78:	1606050a 	strne	r0, [r6], -sl, lsl #10
    1e7c:	050b0000 	streq	r0, [fp, #-0]
    1e80:	000015f6 	strdeq	r1, [r0], -r6
    1e84:	12df050c 	sbcsne	r0, pc, #12, 10	; 0x3000000
    1e88:	050d0000 	streq	r0, [sp, #-0]
    1e8c:	000012f8 	strdeq	r1, [r0], -r8
    1e90:	15e7050e 	strbne	r0, [r7, #1294]!	; 0x50e
    1e94:	050f0000 	streq	r0, [pc, #-0]	; 1e9c <shift+0x1e9c>
    1e98:	000017ab 	andeq	r1, r0, fp, lsr #15
    1e9c:	17280510 			; <UNDEFINED> instruction: 0x17280510
    1ea0:	05110000 	ldreq	r0, [r1, #-0]
    1ea4:	0000179c 	muleq	r0, ip, r7
    1ea8:	13a50512 			; <UNDEFINED> instruction: 0x13a50512
    1eac:	05130000 	ldreq	r0, [r3, #-0]
    1eb0:	00001322 	andeq	r1, r0, r2, lsr #6
    1eb4:	12ec0514 	rscne	r0, ip, #20, 10	; 0x5000000
    1eb8:	05150000 	ldreq	r0, [r5, #-0]
    1ebc:	00001685 	andeq	r1, r0, r5, lsl #13
    1ec0:	13590516 	cmpne	r9, #92274688	; 0x5800000
    1ec4:	05170000 	ldreq	r0, [r7, #-0]
    1ec8:	00001294 	muleq	r0, r4, r2
    1ecc:	178e0518 	usada8ne	lr, r8, r5, r0
    1ed0:	05190000 	ldreq	r0, [r9, #-0]
    1ed4:	000015c3 	andeq	r1, r0, r3, asr #11
    1ed8:	169d051a 			; <UNDEFINED> instruction: 0x169d051a
    1edc:	051b0000 	ldreq	r0, [fp, #-0]
    1ee0:	0000132d 	andeq	r1, r0, sp, lsr #6
    1ee4:	1539051c 	ldrne	r0, [r9, #-1308]!	; 0xfffffae4
    1ee8:	051d0000 	ldreq	r0, [sp, #-0]
    1eec:	00001488 	andeq	r1, r0, r8, lsl #9
    1ef0:	171a051e 			; <UNDEFINED> instruction: 0x171a051e
    1ef4:	051f0000 	ldreq	r0, [pc, #-0]	; 1efc <shift+0x1efc>
    1ef8:	00001776 	andeq	r1, r0, r6, ror r7
    1efc:	17b70520 	ldrne	r0, [r7, r0, lsr #10]!
    1f00:	05210000 	streq	r0, [r1, #-0]!
    1f04:	000017c5 	andeq	r1, r0, r5, asr #15
    1f08:	15da0522 	ldrbne	r0, [sl, #1314]	; 0x522
    1f0c:	05230000 	streq	r0, [r3, #-0]!
    1f10:	000014fd 	strdeq	r1, [r0], -sp
    1f14:	133c0524 	teqne	ip, #36, 10	; 0x9000000
    1f18:	05250000 	streq	r0, [r5, #-0]!
    1f1c:	00001590 	muleq	r0, r0, r5
    1f20:	14a20526 	strtne	r0, [r2], #1318	; 0x526
    1f24:	05270000 	streq	r0, [r7, #-0]!
    1f28:	00001745 	andeq	r1, r0, r5, asr #14
    1f2c:	14b20528 	ldrtne	r0, [r2], #1320	; 0x528
    1f30:	05290000 	streq	r0, [r9, #-0]!
    1f34:	000014c1 	andeq	r1, r0, r1, asr #9
    1f38:	14d0052a 	ldrbne	r0, [r0], #1322	; 0x52a
    1f3c:	052b0000 	streq	r0, [fp, #-0]!
    1f40:	000014df 	ldrdeq	r1, [r0], -pc	; <UNPREDICTABLE>
    1f44:	146d052c 	strbtne	r0, [sp], #-1324	; 0xfffffad4
    1f48:	052d0000 	streq	r0, [sp, #-0]!
    1f4c:	000014ee 	andeq	r1, r0, lr, ror #9
    1f50:	16d4052e 	ldrbne	r0, [r4], lr, lsr #10
    1f54:	052f0000 	streq	r0, [pc, #-0]!	; 1f5c <shift+0x1f5c>
    1f58:	0000150c 	andeq	r1, r0, ip, lsl #10
    1f5c:	151b0530 	ldrne	r0, [fp, #-1328]	; 0xfffffad0
    1f60:	05310000 	ldreq	r0, [r1, #-0]!
    1f64:	000012cd 	andeq	r1, r0, sp, asr #5
    1f68:	16250532 			; <UNDEFINED> instruction: 0x16250532
    1f6c:	05330000 	ldreq	r0, [r3, #-0]!
    1f70:	00001635 	andeq	r1, r0, r5, lsr r6
    1f74:	16450534 			; <UNDEFINED> instruction: 0x16450534
    1f78:	05350000 	ldreq	r0, [r5, #-0]!
    1f7c:	0000145b 	andeq	r1, r0, fp, asr r4
    1f80:	16550536 			; <UNDEFINED> instruction: 0x16550536
    1f84:	05370000 	ldreq	r0, [r7, #-0]!
    1f88:	00001665 	andeq	r1, r0, r5, ror #12
    1f8c:	16750538 			; <UNDEFINED> instruction: 0x16750538
    1f90:	05390000 	ldreq	r0, [r9, #-0]!
    1f94:	0000134c 	andeq	r1, r0, ip, asr #6
    1f98:	1305053a 	movwne	r0, #21818	; 0x553a
    1f9c:	053b0000 	ldreq	r0, [fp, #-0]!
    1fa0:	0000152a 	andeq	r1, r0, sl, lsr #10
    1fa4:	12a4053c 	adcne	r0, r4, #60, 10	; 0xf000000
    1fa8:	053d0000 	ldreq	r0, [sp, #-0]!
    1fac:	00001690 	muleq	r0, r0, r6
    1fb0:	8c06003e 	stchi	0, cr0, [r6], {62}	; 0x3e
    1fb4:	02000013 	andeq	r0, r0, #19
    1fb8:	08026b01 	stmdaeq	r2, {r0, r8, r9, fp, sp, lr}
    1fbc:	000001ff 	strdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    1fc0:	00154f07 	andseq	r4, r5, r7, lsl #30
    1fc4:	02700100 	rsbseq	r0, r0, #0, 2
    1fc8:	00004714 	andeq	r4, r0, r4, lsl r7
    1fcc:	68070000 	stmdavs	r7, {}	; <UNPREDICTABLE>
    1fd0:	01000014 	tsteq	r0, r4, lsl r0
    1fd4:	47140271 			; <UNDEFINED> instruction: 0x47140271
    1fd8:	01000000 	mrseq	r0, (UNDEF: 0)
    1fdc:	01d40800 	bicseq	r0, r4, r0, lsl #16
    1fe0:	ff090000 			; <UNDEFINED> instruction: 0xff090000
    1fe4:	14000001 	strne	r0, [r0], #-1
    1fe8:	0a000002 	beq	1ff8 <shift+0x1ff8>
    1fec:	00000024 	andeq	r0, r0, r4, lsr #32
    1ff0:	04080011 	streq	r0, [r8], #-17	; 0xffffffef
    1ff4:	0b000002 	bleq	2004 <shift+0x2004>
    1ff8:	00001613 	andeq	r1, r0, r3, lsl r6
    1ffc:	26027401 	strcs	r7, [r2], -r1, lsl #8
    2000:	00000214 	andeq	r0, r0, r4, lsl r2
    2004:	0a3d3a24 	beq	f5089c <__bss_end+0xf46d5c>
    2008:	243d0f3d 	ldrtcs	r0, [sp], #-3901	; 0xfffff0c3
    200c:	023d323d 	eorseq	r3, sp, #-805306365	; 0xd0000003
    2010:	133d053d 	teqne	sp, #255852544	; 0xf400000
    2014:	0c3d0d3d 	ldceq	13, cr0, [sp], #-244	; 0xffffff0c
    2018:	113d233d 	teqne	sp, sp, lsr r3
    201c:	013d263d 	teqeq	sp, sp, lsr r6
    2020:	083d173d 	ldmdaeq	sp!, {r0, r2, r3, r4, r5, r8, r9, sl, ip}
    2024:	003d093d 	eorseq	r0, sp, sp, lsr r9
    2028:	07020300 	streq	r0, [r2, -r0, lsl #6]
    202c:	00000720 	andeq	r0, r0, r0, lsr #14
    2030:	1e080103 	adfnee	f0, f0, f3
    2034:	0c000009 	stceq	0, cr0, [r0], {9}
    2038:	0259040d 	subseq	r0, r9, #218103808	; 0xd000000
    203c:	d30e0000 	movwle	r0, #57344	; 0xe000
    2040:	07000017 	smladeq	r0, r7, r0, r0
    2044:	00003901 	andeq	r3, r0, r1, lsl #18
    2048:	04f70200 	ldrbteq	r0, [r7], #512	; 0x200
    204c:	00029e06 	andeq	r9, r2, r6, lsl #28
    2050:	13660500 	cmnne	r6, #0, 10
    2054:	05000000 	streq	r0, [r0, #-0]
    2058:	00001371 	andeq	r1, r0, r1, ror r3
    205c:	13830501 	orrne	r0, r3, #4194304	; 0x400000
    2060:	05020000 	streq	r0, [r2, #-0]
    2064:	0000139d 	muleq	r0, sp, r3
    2068:	170d0503 	strne	r0, [sp, -r3, lsl #10]
    206c:	05040000 	streq	r0, [r4, #-0]
    2070:	0000147c 	andeq	r1, r0, ip, ror r4
    2074:	16c60505 	strbne	r0, [r6], r5, lsl #10
    2078:	00060000 	andeq	r0, r6, r0
    207c:	6a050203 	bvs	142890 <__bss_end+0x138d50>
    2080:	03000009 	movweq	r0, #9
    2084:	15ac0708 	strne	r0, [ip, #1800]!	; 0x708
    2088:	04030000 	streq	r0, [r3], #-0
    208c:	0012bd04 	andseq	fp, r2, r4, lsl #26
    2090:	03080300 	movweq	r0, #33536	; 0x8300
    2094:	000012b5 			; <UNDEFINED> instruction: 0x000012b5
    2098:	66040803 	strvs	r0, [r4], -r3, lsl #16
    209c:	03000015 	movweq	r0, #21
    20a0:	16b70310 	ssatne	r0, #24, r0, lsl #6
    20a4:	ae0f0000 	cdpge	0, 0, cr0, cr15, cr0, {0}
    20a8:	03000016 	movweq	r0, #22
    20ac:	025a102a 	subseq	r1, sl, #42	; 0x2a
    20b0:	c8090000 	stmdagt	r9, {}	; <UNPREDICTABLE>
    20b4:	df000002 	svcle	0x00000002
    20b8:	10000002 	andne	r0, r0, r2
    20bc:	030c1100 	movweq	r1, #49408	; 0xc100
    20c0:	2f030000 	svccs	0x00030000
    20c4:	0002d411 	andeq	sp, r2, r1, lsl r4
    20c8:	02001100 	andeq	r1, r0, #0, 2
    20cc:	30030000 	andcc	r0, r3, r0
    20d0:	0002d411 	andeq	sp, r2, r1, lsl r4
    20d4:	02c80900 	sbceq	r0, r8, #0, 18
    20d8:	03070000 	movweq	r0, #28672	; 0x7000
    20dc:	240a0000 	strcs	r0, [sl], #-0
    20e0:	01000000 	mrseq	r0, (UNDEF: 0)
    20e4:	02df1200 	sbcseq	r1, pc, #0, 4
    20e8:	33040000 	movwcc	r0, #16384	; 0x4000
    20ec:	02f70a09 	rscseq	r0, r7, #36864	; 0x9000
    20f0:	03050000 	movweq	r0, #20480	; 0x5000
    20f4:	00009b30 	andeq	r9, r0, r0, lsr fp
    20f8:	0002eb12 	andeq	lr, r2, r2, lsl fp
    20fc:	09340400 	ldmdbeq	r4!, {sl}
    2100:	0002f70a 	andeq	pc, r2, sl, lsl #14
    2104:	30030500 	andcc	r0, r3, r0, lsl #10
    2108:	0000009b 	muleq	r0, fp, r0
    210c:	00000306 	andeq	r0, r0, r6, lsl #6
    2110:	090d0004 	stmdbeq	sp, {r2}
    2114:	01040000 	mrseq	r0, (UNDEF: 4)
    2118:	000013b4 			; <UNDEFINED> instruction: 0x000013b4
    211c:	00156d0c 	andseq	r6, r5, ip, lsl #26
    2120:	0011c300 	andseq	ip, r1, r0, lsl #6
    2124:	0098c800 	addseq	ip, r8, r0, lsl #16
    2128:	00003000 	andeq	r3, r0, r0
    212c:	000dd800 	andeq	sp, sp, r0, lsl #16
    2130:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
    2134:	000012bd 			; <UNDEFINED> instruction: 0x000012bd
    2138:	69050403 	stmdbvs	r5, {r0, r1, sl}
    213c:	0200746e 	andeq	r7, r0, #1845493760	; 0x6e000000
    2140:	15b60704 	ldrne	r0, [r6, #1796]!	; 0x704
    2144:	08020000 	stmdaeq	r2, {}	; <UNPREDICTABLE>
    2148:	00024305 	andeq	r4, r2, r5, lsl #6
    214c:	04080200 	streq	r0, [r8], #-512	; 0xfffffe00
    2150:	00001561 	andeq	r1, r0, r1, ror #10
    2154:	15080102 	strne	r0, [r8, #-258]	; 0xfffffefe
    2158:	02000009 	andeq	r0, r0, #9
    215c:	09170601 	ldmdbeq	r7, {r0, r9, sl}
    2160:	39040000 	stmdbcc	r4, {}	; <UNPREDICTABLE>
    2164:	07000017 	smladeq	r0, r7, r0, r0
    2168:	00004801 	andeq	r4, r0, r1, lsl #16
    216c:	06170200 	ldreq	r0, [r7], -r0, lsl #4
    2170:	000001e3 	andeq	r0, r0, r3, ror #3
    2174:	0012c305 	andseq	ip, r2, r5, lsl #6
    2178:	e8050000 	stmda	r5, {}	; <UNPREDICTABLE>
    217c:	01000017 	tsteq	r0, r7, lsl r0
    2180:	00149605 	andseq	r9, r4, r5, lsl #12
    2184:	54050200 	strpl	r0, [r5], #-512	; 0xfffffe00
    2188:	03000015 	movweq	r0, #21
    218c:	00175205 	andseq	r5, r7, r5, lsl #4
    2190:	f8050400 			; <UNDEFINED> instruction: 0xf8050400
    2194:	05000017 	streq	r0, [r0, #-23]	; 0xffffffe9
    2198:	00176805 	andseq	r6, r7, r5, lsl #16
    219c:	9d050600 	stcls	6, cr0, [r5, #-0]
    21a0:	07000015 	smladeq	r0, r5, r0, r0
    21a4:	0016e305 	andseq	lr, r6, r5, lsl #6
    21a8:	f1050800 			; <UNDEFINED> instruction: 0xf1050800
    21ac:	09000016 	stmdbeq	r0, {r1, r2, r4}
    21b0:	0016ff05 	andseq	pc, r6, r5, lsl #30
    21b4:	06050a00 	streq	r0, [r5], -r0, lsl #20
    21b8:	0b000016 	bleq	2218 <shift+0x2218>
    21bc:	0015f605 	andseq	pc, r5, r5, lsl #12
    21c0:	df050c00 	svcle	0x00050c00
    21c4:	0d000012 	stceq	0, cr0, [r0, #-72]	; 0xffffffb8
    21c8:	0012f805 	andseq	pc, r2, r5, lsl #16
    21cc:	e7050e00 	str	r0, [r5, -r0, lsl #28]
    21d0:	0f000015 	svceq	0x00000015
    21d4:	0017ab05 	andseq	sl, r7, r5, lsl #22
    21d8:	28051000 	stmdacs	r5, {ip}
    21dc:	11000017 	tstne	r0, r7, lsl r0
    21e0:	00179c05 	andseq	r9, r7, r5, lsl #24
    21e4:	a5051200 	strge	r1, [r5, #-512]	; 0xfffffe00
    21e8:	13000013 	movwne	r0, #19
    21ec:	00132205 	andseq	r2, r3, r5, lsl #4
    21f0:	ec051400 	cfstrs	mvf1, [r5], {-0}
    21f4:	15000012 	strne	r0, [r0, #-18]	; 0xffffffee
    21f8:	00168505 	andseq	r8, r6, r5, lsl #10
    21fc:	59051600 	stmdbpl	r5, {r9, sl, ip}
    2200:	17000013 	smladne	r0, r3, r0, r0
    2204:	00129405 	andseq	r9, r2, r5, lsl #8
    2208:	8e051800 	cdphi	8, 0, cr1, cr5, cr0, {0}
    220c:	19000017 	stmdbne	r0, {r0, r1, r2, r4}
    2210:	0015c305 	andseq	ip, r5, r5, lsl #6
    2214:	9d051a00 	vstrls	s2, [r5, #-0]
    2218:	1b000016 	blne	2278 <shift+0x2278>
    221c:	00132d05 	andseq	r2, r3, r5, lsl #26
    2220:	39051c00 	stmdbcc	r5, {sl, fp, ip}
    2224:	1d000015 	stcne	0, cr0, [r0, #-84]	; 0xffffffac
    2228:	00148805 	andseq	r8, r4, r5, lsl #16
    222c:	1a051e00 	bne	149a34 <__bss_end+0x13fef4>
    2230:	1f000017 	svcne	0x00000017
    2234:	00177605 	andseq	r7, r7, r5, lsl #12
    2238:	b7052000 	strlt	r2, [r5, -r0]
    223c:	21000017 	tstcs	r0, r7, lsl r0
    2240:	0017c505 	andseq	ip, r7, r5, lsl #10
    2244:	da052200 	ble	14aa4c <__bss_end+0x140f0c>
    2248:	23000015 	movwcs	r0, #21
    224c:	0014fd05 	andseq	pc, r4, r5, lsl #26
    2250:	3c052400 	cfstrscc	mvf2, [r5], {-0}
    2254:	25000013 	strcs	r0, [r0, #-19]	; 0xffffffed
    2258:	00159005 	andseq	r9, r5, r5
    225c:	a2052600 	andge	r2, r5, #0, 12
    2260:	27000014 	smladcs	r0, r4, r0, r0
    2264:	00174505 	andseq	r4, r7, r5, lsl #10
    2268:	b2052800 	andlt	r2, r5, #0, 16
    226c:	29000014 	stmdbcs	r0, {r2, r4}
    2270:	0014c105 	andseq	ip, r4, r5, lsl #2
    2274:	d0052a00 	andle	r2, r5, r0, lsl #20
    2278:	2b000014 	blcs	22d0 <shift+0x22d0>
    227c:	0014df05 	andseq	sp, r4, r5, lsl #30
    2280:	6d052c00 	stcvs	12, cr2, [r5, #-0]
    2284:	2d000014 	stccs	0, cr0, [r0, #-80]	; 0xffffffb0
    2288:	0014ee05 	andseq	lr, r4, r5, lsl #28
    228c:	d4052e00 	strle	r2, [r5], #-3584	; 0xfffff200
    2290:	2f000016 	svccs	0x00000016
    2294:	00150c05 	andseq	r0, r5, r5, lsl #24
    2298:	1b053000 	blne	14e2a0 <__bss_end+0x144760>
    229c:	31000015 	tstcc	r0, r5, lsl r0
    22a0:	0012cd05 	andseq	ip, r2, r5, lsl #26
    22a4:	25053200 	strcs	r3, [r5, #-512]	; 0xfffffe00
    22a8:	33000016 	movwcc	r0, #22
    22ac:	00163505 	andseq	r3, r6, r5, lsl #10
    22b0:	45053400 	strmi	r3, [r5, #-1024]	; 0xfffffc00
    22b4:	35000016 	strcc	r0, [r0, #-22]	; 0xffffffea
    22b8:	00145b05 	andseq	r5, r4, r5, lsl #22
    22bc:	55053600 	strpl	r3, [r5, #-1536]	; 0xfffffa00
    22c0:	37000016 	smladcc	r0, r6, r0, r0
    22c4:	00166505 	andseq	r6, r6, r5, lsl #10
    22c8:	75053800 	strvc	r3, [r5, #-2048]	; 0xfffff800
    22cc:	39000016 	stmdbcc	r0, {r1, r2, r4}
    22d0:	00134c05 	andseq	r4, r3, r5, lsl #24
    22d4:	05053a00 	streq	r3, [r5, #-2560]	; 0xfffff600
    22d8:	3b000013 	blcc	232c <shift+0x232c>
    22dc:	00152a05 	andseq	r2, r5, r5, lsl #20
    22e0:	a4053c00 	strge	r3, [r5], #-3072	; 0xfffff400
    22e4:	3d000012 	stccc	0, cr0, [r0, #-72]	; 0xffffffb8
    22e8:	00169005 	andseq	r9, r6, r5
    22ec:	06003e00 	streq	r3, [r0], -r0, lsl #28
    22f0:	0000138c 	andeq	r1, r0, ip, lsl #7
    22f4:	026b0202 	rsbeq	r0, fp, #536870912	; 0x20000000
    22f8:	00020e08 	andeq	r0, r2, r8, lsl #28
    22fc:	154f0700 	strbne	r0, [pc, #-1792]	; 1c04 <shift+0x1c04>
    2300:	70020000 	andvc	r0, r2, r0
    2304:	00561402 	subseq	r1, r6, r2, lsl #8
    2308:	07000000 	streq	r0, [r0, -r0]
    230c:	00001468 	andeq	r1, r0, r8, ror #8
    2310:	14027102 	strne	r7, [r2], #-258	; 0xfffffefe
    2314:	00000056 	andeq	r0, r0, r6, asr r0
    2318:	e3080001 	movw	r0, #32769	; 0x8001
    231c:	09000001 	stmdbeq	r0, {r0}
    2320:	0000020e 	andeq	r0, r0, lr, lsl #4
    2324:	00000223 	andeq	r0, r0, r3, lsr #4
    2328:	0000330a 	andeq	r3, r0, sl, lsl #6
    232c:	08001100 	stmdaeq	r0, {r8, ip}
    2330:	00000213 	andeq	r0, r0, r3, lsl r2
    2334:	0016130b 	andseq	r1, r6, fp, lsl #6
    2338:	02740200 	rsbseq	r0, r4, #0, 4
    233c:	00022326 	andeq	r2, r2, r6, lsr #6
    2340:	3d3a2400 	cfldrscc	mvf2, [sl, #-0]
    2344:	3d0f3d0a 	stccc	13, cr3, [pc, #-40]	; 2324 <shift+0x2324>
    2348:	3d323d24 	ldccc	13, cr3, [r2, #-144]!	; 0xffffff70
    234c:	3d053d02 	stccc	13, cr3, [r5, #-8]
    2350:	3d0d3d13 	stccc	13, cr3, [sp, #-76]	; 0xffffffb4
    2354:	3d233d0c 	stccc	13, cr3, [r3, #-48]!	; 0xffffffd0
    2358:	3d263d11 	stccc	13, cr3, [r6, #-68]!	; 0xffffffbc
    235c:	3d173d01 	ldccc	13, cr3, [r7, #-4]
    2360:	3d093d08 	stccc	13, cr3, [r9, #-32]	; 0xffffffe0
    2364:	02020000 	andeq	r0, r2, #0
    2368:	00072007 	andeq	r2, r7, r7
    236c:	08010200 	stmdaeq	r1, {r9}
    2370:	0000091e 	andeq	r0, r0, lr, lsl r9
    2374:	6a050202 	bvs	142b84 <__bss_end+0x139044>
    2378:	0c000009 	stceq	0, cr0, [r0], {9}
    237c:	00001844 	andeq	r1, r0, r4, asr #16
    2380:	3a0f8403 	bcc	3e3394 <__bss_end+0x3d9854>
    2384:	02000000 	andeq	r0, r0, #0
    2388:	15ac0708 	strne	r0, [ip, #1800]!	; 0x708
    238c:	150c0000 	strne	r0, [ip, #-0]
    2390:	03000018 	movweq	r0, #24
    2394:	00251093 	mlaeq	r5, r3, r0, r1
    2398:	08020000 	stmdaeq	r2, {}	; <UNPREDICTABLE>
    239c:	0012b503 	andseq	fp, r2, r3, lsl #10
    23a0:	04080200 	streq	r0, [r8], #-512	; 0xfffffe00
    23a4:	00001566 	andeq	r1, r0, r6, ror #10
    23a8:	b7031002 	strlt	r1, [r3, -r2]
    23ac:	0d000016 	stceq	0, cr0, [r0, #-88]	; 0xffffffa8
    23b0:	0000182a 	andeq	r1, r0, sl, lsr #16
    23b4:	0105f901 	tsteq	r5, r1, lsl #18	; <UNPREDICTABLE>
    23b8:	0000026f 	andeq	r0, r0, pc, ror #4
    23bc:	000098c8 	andeq	r9, r0, r8, asr #17
    23c0:	00000030 	andeq	r0, r0, r0, lsr r0
    23c4:	02fd9c01 	rscseq	r9, sp, #256	; 0x100
    23c8:	610e0000 	mrsvs	r0, (UNDEF: 14)
    23cc:	05f90100 	ldrbeq	r0, [r9, #256]!	; 0x100
    23d0:	00028213 	andeq	r8, r2, r3, lsl r2
    23d4:	00000800 	andeq	r0, r0, r0, lsl #16
    23d8:	00000000 	andeq	r0, r0, r0
    23dc:	98dc0f00 	ldmls	ip, {r8, r9, sl, fp}^
    23e0:	02fd0000 	rscseq	r0, sp, #0
    23e4:	02e80000 	rsceq	r0, r8, #0
    23e8:	01100000 	tsteq	r0, r0
    23ec:	03f30550 	mvnseq	r0, #80, 10	; 0x14000000
    23f0:	002500f5 	strdeq	r0, [r5], -r5	; <UNPREDICTABLE>
    23f4:	0098ec11 	addseq	lr, r8, r1, lsl ip
    23f8:	0002fd00 	andeq	pc, r2, r0, lsl #26
    23fc:	50011000 	andpl	r1, r1, r0
    2400:	f503f306 			; <UNDEFINED> instruction: 0xf503f306
    2404:	001f2500 	andseq	r2, pc, r0, lsl #10
    2408:	181c1200 	ldmdane	ip, {r9, ip}
    240c:	18080000 	stmdane	r8, {}	; <UNPREDICTABLE>
    2410:	3b010000 	blcc	42418 <__bss_end+0x388d8>
    2414:	032a0003 			; <UNDEFINED> instruction: 0x032a0003
    2418:	00040000 	andeq	r0, r4, r0
    241c:	00000a1c 	andeq	r0, r0, ip, lsl sl
    2420:	13b40104 			; <UNDEFINED> instruction: 0x13b40104
    2424:	6d0c0000 	stcvs	0, cr0, [ip, #-0]
    2428:	c3000015 	movwgt	r0, #21
    242c:	f8000011 			; <UNDEFINED> instruction: 0xf8000011
    2430:	40000098 	mulmi	r0, r8, r0
    2434:	83000000 	movwhi	r0, #0
    2438:	0200000e 	andeq	r0, r0, #14
    243c:	15660408 	strbne	r0, [r6, #-1032]!	; 0xfffffbf8
    2440:	04020000 	streq	r0, [r2], #-0
    2444:	0015b607 	andseq	fp, r5, r7, lsl #12
    2448:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
    244c:	000012bd 			; <UNDEFINED> instruction: 0x000012bd
    2450:	69050403 	stmdbvs	r5, {r0, r1, sl}
    2454:	0200746e 	andeq	r7, r0, #1845493760	; 0x6e000000
    2458:	02430508 	subeq	r0, r3, #8, 10	; 0x2000000
    245c:	08020000 	stmdaeq	r2, {}	; <UNPREDICTABLE>
    2460:	00156104 	andseq	r6, r5, r4, lsl #2
    2464:	08010200 	stmdaeq	r1, {r9}
    2468:	00000915 	andeq	r0, r0, r5, lsl r9
    246c:	17060102 	strne	r0, [r6, -r2, lsl #2]
    2470:	04000009 	streq	r0, [r0], #-9
    2474:	00001739 	andeq	r1, r0, r9, lsr r7
    2478:	004f0107 	subeq	r0, pc, r7, lsl #2
    247c:	17020000 	strne	r0, [r2, -r0]
    2480:	0001ea06 	andeq	lr, r1, r6, lsl #20
    2484:	12c30500 	sbcne	r0, r3, #0, 10
    2488:	05000000 	streq	r0, [r0, #-0]
    248c:	000017e8 	andeq	r1, r0, r8, ror #15
    2490:	14960501 	ldrne	r0, [r6], #1281	; 0x501
    2494:	05020000 	streq	r0, [r2, #-0]
    2498:	00001554 	andeq	r1, r0, r4, asr r5
    249c:	17520503 	ldrbne	r0, [r2, -r3, lsl #10]
    24a0:	05040000 	streq	r0, [r4, #-0]
    24a4:	000017f8 	strdeq	r1, [r0], -r8
    24a8:	17680505 	strbne	r0, [r8, -r5, lsl #10]!
    24ac:	05060000 	streq	r0, [r6, #-0]
    24b0:	0000159d 	muleq	r0, sp, r5
    24b4:	16e30507 	strbtne	r0, [r3], r7, lsl #10
    24b8:	05080000 	streq	r0, [r8, #-0]
    24bc:	000016f1 	strdeq	r1, [r0], -r1	; <UNPREDICTABLE>
    24c0:	16ff0509 	ldrbtne	r0, [pc], r9, lsl #10
    24c4:	050a0000 	streq	r0, [sl, #-0]
    24c8:	00001606 	andeq	r1, r0, r6, lsl #12
    24cc:	15f6050b 	ldrbne	r0, [r6, #1291]!	; 0x50b
    24d0:	050c0000 	streq	r0, [ip, #-0]
    24d4:	000012df 	ldrdeq	r1, [r0], -pc	; <UNPREDICTABLE>
    24d8:	12f8050d 	rscsne	r0, r8, #54525952	; 0x3400000
    24dc:	050e0000 	streq	r0, [lr, #-0]
    24e0:	000015e7 	andeq	r1, r0, r7, ror #11
    24e4:	17ab050f 	strne	r0, [fp, pc, lsl #10]!
    24e8:	05100000 	ldreq	r0, [r0, #-0]
    24ec:	00001728 	andeq	r1, r0, r8, lsr #14
    24f0:	179c0511 			; <UNDEFINED> instruction: 0x179c0511
    24f4:	05120000 	ldreq	r0, [r2, #-0]
    24f8:	000013a5 	andeq	r1, r0, r5, lsr #7
    24fc:	13220513 			; <UNDEFINED> instruction: 0x13220513
    2500:	05140000 	ldreq	r0, [r4, #-0]
    2504:	000012ec 	andeq	r1, r0, ip, ror #5
    2508:	16850515 	pkhbtne	r0, r5, r5, lsl #10
    250c:	05160000 	ldreq	r0, [r6, #-0]
    2510:	00001359 	andeq	r1, r0, r9, asr r3
    2514:	12940517 	addsne	r0, r4, #96468992	; 0x5c00000
    2518:	05180000 	ldreq	r0, [r8, #-0]
    251c:	0000178e 	andeq	r1, r0, lr, lsl #15
    2520:	15c30519 	strbne	r0, [r3, #1305]	; 0x519
    2524:	051a0000 	ldreq	r0, [sl, #-0]
    2528:	0000169d 	muleq	r0, sp, r6
    252c:	132d051b 			; <UNDEFINED> instruction: 0x132d051b
    2530:	051c0000 	ldreq	r0, [ip, #-0]
    2534:	00001539 	andeq	r1, r0, r9, lsr r5
    2538:	1488051d 	strne	r0, [r8], #1309	; 0x51d
    253c:	051e0000 	ldreq	r0, [lr, #-0]
    2540:	0000171a 	andeq	r1, r0, sl, lsl r7
    2544:	1776051f 			; <UNDEFINED> instruction: 0x1776051f
    2548:	05200000 	streq	r0, [r0, #-0]!
    254c:	000017b7 			; <UNDEFINED> instruction: 0x000017b7
    2550:	17c50521 	strbne	r0, [r5, r1, lsr #10]
    2554:	05220000 	streq	r0, [r2, #-0]!
    2558:	000015da 	ldrdeq	r1, [r0], -sl
    255c:	14fd0523 	ldrbtne	r0, [sp], #1315	; 0x523
    2560:	05240000 	streq	r0, [r4, #-0]!
    2564:	0000133c 	andeq	r1, r0, ip, lsr r3
    2568:	15900525 	ldrne	r0, [r0, #1317]	; 0x525
    256c:	05260000 	streq	r0, [r6, #-0]!
    2570:	000014a2 	andeq	r1, r0, r2, lsr #9
    2574:	17450527 	strbne	r0, [r5, -r7, lsr #10]
    2578:	05280000 	streq	r0, [r8, #-0]!
    257c:	000014b2 			; <UNDEFINED> instruction: 0x000014b2
    2580:	14c10529 	strbne	r0, [r1], #1321	; 0x529
    2584:	052a0000 	streq	r0, [sl, #-0]!
    2588:	000014d0 	ldrdeq	r1, [r0], -r0
    258c:	14df052b 	ldrbne	r0, [pc], #1323	; 2594 <shift+0x2594>
    2590:	052c0000 	streq	r0, [ip, #-0]!
    2594:	0000146d 	andeq	r1, r0, sp, ror #8
    2598:	14ee052d 	strbtne	r0, [lr], #1325	; 0x52d
    259c:	052e0000 	streq	r0, [lr, #-0]!
    25a0:	000016d4 	ldrdeq	r1, [r0], -r4
    25a4:	150c052f 	strne	r0, [ip, #-1327]	; 0xfffffad1
    25a8:	05300000 	ldreq	r0, [r0, #-0]!
    25ac:	0000151b 	andeq	r1, r0, fp, lsl r5
    25b0:	12cd0531 	sbcne	r0, sp, #205520896	; 0xc400000
    25b4:	05320000 	ldreq	r0, [r2, #-0]!
    25b8:	00001625 	andeq	r1, r0, r5, lsr #12
    25bc:	16350533 			; <UNDEFINED> instruction: 0x16350533
    25c0:	05340000 	ldreq	r0, [r4, #-0]!
    25c4:	00001645 	andeq	r1, r0, r5, asr #12
    25c8:	145b0535 	ldrbne	r0, [fp], #-1333	; 0xfffffacb
    25cc:	05360000 	ldreq	r0, [r6, #-0]!
    25d0:	00001655 	andeq	r1, r0, r5, asr r6
    25d4:	16650537 			; <UNDEFINED> instruction: 0x16650537
    25d8:	05380000 	ldreq	r0, [r8, #-0]!
    25dc:	00001675 	andeq	r1, r0, r5, ror r6
    25e0:	134c0539 	movtne	r0, #50489	; 0xc539
    25e4:	053a0000 	ldreq	r0, [sl, #-0]!
    25e8:	00001305 	andeq	r1, r0, r5, lsl #6
    25ec:	152a053b 	strne	r0, [sl, #-1339]!	; 0xfffffac5
    25f0:	053c0000 	ldreq	r0, [ip, #-0]!
    25f4:	000012a4 	andeq	r1, r0, r4, lsr #5
    25f8:	1690053d 			; <UNDEFINED> instruction: 0x1690053d
    25fc:	003e0000 	eorseq	r0, lr, r0
    2600:	00138c06 	andseq	r8, r3, r6, lsl #24
    2604:	6b020200 	blvs	82e0c <__bss_end+0x792cc>
    2608:	02150802 	andseq	r0, r5, #131072	; 0x20000
    260c:	4f070000 	svcmi	0x00070000
    2610:	02000015 	andeq	r0, r0, #21
    2614:	5d140270 	lfmpl	f0, 4, [r4, #-448]	; 0xfffffe40
    2618:	00000000 	andeq	r0, r0, r0
    261c:	00146807 	andseq	r6, r4, r7, lsl #16
    2620:	02710200 	rsbseq	r0, r1, #0, 4
    2624:	00005d14 	andeq	r5, r0, r4, lsl sp
    2628:	08000100 	stmdaeq	r0, {r8}
    262c:	000001ea 	andeq	r0, r0, sl, ror #3
    2630:	00021509 	andeq	r1, r2, r9, lsl #10
    2634:	00022a00 	andeq	r2, r2, r0, lsl #20
    2638:	002c0a00 	eoreq	r0, ip, r0, lsl #20
    263c:	00110000 	andseq	r0, r1, r0
    2640:	00021a08 	andeq	r1, r2, r8, lsl #20
    2644:	16130b00 	ldrne	r0, [r3], -r0, lsl #22
    2648:	74020000 	strvc	r0, [r2], #-0
    264c:	022a2602 	eoreq	r2, sl, #2097152	; 0x200000
    2650:	3a240000 	bcc	902658 <__bss_end+0x8f8b18>
    2654:	0f3d0a3d 	svceq	0x003d0a3d
    2658:	323d243d 	eorscc	r2, sp, #1023410176	; 0x3d000000
    265c:	053d023d 	ldreq	r0, [sp, #-573]!	; 0xfffffdc3
    2660:	0d3d133d 	ldceq	3, cr1, [sp, #-244]!	; 0xffffff0c
    2664:	233d0c3d 	teqcs	sp, #15616	; 0x3d00
    2668:	263d113d 			; <UNDEFINED> instruction: 0x263d113d
    266c:	173d013d 			; <UNDEFINED> instruction: 0x173d013d
    2670:	093d083d 	ldmdbeq	sp!, {r0, r2, r3, r4, r5, fp}
    2674:	0200003d 	andeq	r0, r0, #61	; 0x3d
    2678:	07200702 	streq	r0, [r0, -r2, lsl #14]!
    267c:	01020000 	mrseq	r0, (UNDEF: 2)
    2680:	00091e08 	andeq	r1, r9, r8, lsl #28
    2684:	05020200 	streq	r0, [r2, #-512]	; 0xfffffe00
    2688:	0000096a 	andeq	r0, r0, sl, ror #18
    268c:	00183b0c 	andseq	r3, r8, ip, lsl #22
    2690:	16810300 	strne	r0, [r1], r0, lsl #6
    2694:	0000002c 	andeq	r0, r0, ip, lsr #32
    2698:	00027608 	andeq	r7, r2, r8, lsl #12
    269c:	18430c00 	stmdane	r3, {sl, fp}^
    26a0:	85030000 	strhi	r0, [r3, #-0]
    26a4:	00029316 	andeq	r9, r2, r6, lsl r3
    26a8:	07080200 	streq	r0, [r8, -r0, lsl #4]
    26ac:	000015ac 	andeq	r1, r0, ip, lsr #11
    26b0:	0018150c 	andseq	r1, r8, ip, lsl #10
    26b4:	10930300 	addsne	r0, r3, r0, lsl #6
    26b8:	00000033 	andeq	r0, r0, r3, lsr r0
    26bc:	b5030802 	strlt	r0, [r3, #-2050]	; 0xfffff7fe
    26c0:	0c000012 	stceq	0, cr0, [r0], {18}
    26c4:	00001834 	andeq	r1, r0, r4, lsr r8
    26c8:	25109703 	ldrcs	r9, [r0, #-1795]	; 0xfffff8fd
    26cc:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    26d0:	000002ad 	andeq	r0, r0, sp, lsr #5
    26d4:	b7031002 	strlt	r1, [r3, -r2]
    26d8:	0d000016 	stceq	0, cr0, [r0, #-88]	; 0xffffffa8
    26dc:	00001808 	andeq	r1, r0, r8, lsl #16
    26e0:	0105b901 	tsteq	r5, r1, lsl #18
    26e4:	00000287 	andeq	r0, r0, r7, lsl #5
    26e8:	000098f8 	strdeq	r9, [r0], -r8
    26ec:	00000040 	andeq	r0, r0, r0, asr #32
    26f0:	610e9c01 	tstvs	lr, r1, lsl #24
    26f4:	05b90100 	ldreq	r0, [r9, #256]!	; 0x100
    26f8:	00029a16 	andeq	r9, r2, r6, lsl sl
    26fc:	00004a00 	andeq	r4, r0, r0, lsl #20
    2700:	00004600 	andeq	r4, r0, r0, lsl #12
    2704:	66640f00 	strbtvs	r0, [r4], -r0, lsl #30
    2708:	bf010061 	svclt	0x00010061
    270c:	02b91005 	adcseq	r1, r9, #5
    2710:	00730000 	rsbseq	r0, r3, r0
    2714:	006d0000 	rsbeq	r0, sp, r0
    2718:	680f0000 	stmdavs	pc, {}	; <UNPREDICTABLE>
    271c:	c4010069 	strgt	r0, [r1], #-105	; 0xffffff97
    2720:	02821005 	addeq	r1, r2, #5
    2724:	00b10000 	adcseq	r0, r1, r0
    2728:	00af0000 	adceq	r0, pc, r0
    272c:	6c0f0000 	stcvs	0, cr0, [pc], {-0}
    2730:	c901006f 	stmdbgt	r1, {r0, r1, r2, r3, r5, r6}
    2734:	02821005 	addeq	r1, r2, #5
    2738:	00cb0000 	sbceq	r0, fp, r0
    273c:	00c50000 	sbceq	r0, r5, r0
    2740:	00000000 	andeq	r0, r0, r0
    2744:	00000380 	andeq	r0, r0, r0, lsl #7
    2748:	0b030004 	bleq	c2760 <__bss_end+0xb8c20>
    274c:	01040000 	mrseq	r0, (UNDEF: 4)
    2750:	0000184b 	andeq	r1, r0, fp, asr #16
    2754:	00156d0c 	andseq	r6, r5, ip, lsl #26
    2758:	0011c300 	andseq	ip, r1, r0, lsl #6
    275c:	00993800 	addseq	r3, r9, r0, lsl #16
    2760:	00012000 	andeq	r2, r1, r0
    2764:	000f3d00 	andeq	r3, pc, r0, lsl #26
    2768:	07080200 	streq	r0, [r8, -r0, lsl #4]
    276c:	000015ac 	andeq	r1, r0, ip, lsr #11
    2770:	69050403 	stmdbvs	r5, {r0, r1, sl}
    2774:	0200746e 	andeq	r7, r0, #1845493760	; 0x6e000000
    2778:	15b60704 	ldrne	r0, [r6, #1796]!	; 0x704
    277c:	08020000 	stmdaeq	r2, {}	; <UNPREDICTABLE>
    2780:	00024305 	andeq	r4, r2, r5, lsl #6
    2784:	04080200 	streq	r0, [r8], #-512	; 0xfffffe00
    2788:	00001561 	andeq	r1, r0, r1, ror #10
    278c:	15080102 	strne	r0, [r8, #-258]	; 0xfffffefe
    2790:	02000009 	andeq	r0, r0, #9
    2794:	09170601 	ldmdbeq	r7, {r0, r9, sl}
    2798:	39040000 	stmdbcc	r4, {}	; <UNPREDICTABLE>
    279c:	07000017 	smladeq	r0, r7, r0, r0
    27a0:	00004801 	andeq	r4, r0, r1, lsl #16
    27a4:	06170200 	ldreq	r0, [r7], -r0, lsl #4
    27a8:	000001e3 	andeq	r0, r0, r3, ror #3
    27ac:	0012c305 	andseq	ip, r2, r5, lsl #6
    27b0:	e8050000 	stmda	r5, {}	; <UNPREDICTABLE>
    27b4:	01000017 	tsteq	r0, r7, lsl r0
    27b8:	00149605 	andseq	r9, r4, r5, lsl #12
    27bc:	54050200 	strpl	r0, [r5], #-512	; 0xfffffe00
    27c0:	03000015 	movweq	r0, #21
    27c4:	00175205 	andseq	r5, r7, r5, lsl #4
    27c8:	f8050400 			; <UNDEFINED> instruction: 0xf8050400
    27cc:	05000017 	streq	r0, [r0, #-23]	; 0xffffffe9
    27d0:	00176805 	andseq	r6, r7, r5, lsl #16
    27d4:	9d050600 	stcls	6, cr0, [r5, #-0]
    27d8:	07000015 	smladeq	r0, r5, r0, r0
    27dc:	0016e305 	andseq	lr, r6, r5, lsl #6
    27e0:	f1050800 			; <UNDEFINED> instruction: 0xf1050800
    27e4:	09000016 	stmdbeq	r0, {r1, r2, r4}
    27e8:	0016ff05 	andseq	pc, r6, r5, lsl #30
    27ec:	06050a00 	streq	r0, [r5], -r0, lsl #20
    27f0:	0b000016 	bleq	2850 <shift+0x2850>
    27f4:	0015f605 	andseq	pc, r5, r5, lsl #12
    27f8:	df050c00 	svcle	0x00050c00
    27fc:	0d000012 	stceq	0, cr0, [r0, #-72]	; 0xffffffb8
    2800:	0012f805 	andseq	pc, r2, r5, lsl #16
    2804:	e7050e00 	str	r0, [r5, -r0, lsl #28]
    2808:	0f000015 	svceq	0x00000015
    280c:	0017ab05 	andseq	sl, r7, r5, lsl #22
    2810:	28051000 	stmdacs	r5, {ip}
    2814:	11000017 	tstne	r0, r7, lsl r0
    2818:	00179c05 	andseq	r9, r7, r5, lsl #24
    281c:	a5051200 	strge	r1, [r5, #-512]	; 0xfffffe00
    2820:	13000013 	movwne	r0, #19
    2824:	00132205 	andseq	r2, r3, r5, lsl #4
    2828:	ec051400 	cfstrs	mvf1, [r5], {-0}
    282c:	15000012 	strne	r0, [r0, #-18]	; 0xffffffee
    2830:	00168505 	andseq	r8, r6, r5, lsl #10
    2834:	59051600 	stmdbpl	r5, {r9, sl, ip}
    2838:	17000013 	smladne	r0, r3, r0, r0
    283c:	00129405 	andseq	r9, r2, r5, lsl #8
    2840:	8e051800 	cdphi	8, 0, cr1, cr5, cr0, {0}
    2844:	19000017 	stmdbne	r0, {r0, r1, r2, r4}
    2848:	0015c305 	andseq	ip, r5, r5, lsl #6
    284c:	9d051a00 	vstrls	s2, [r5, #-0]
    2850:	1b000016 	blne	28b0 <shift+0x28b0>
    2854:	00132d05 	andseq	r2, r3, r5, lsl #26
    2858:	39051c00 	stmdbcc	r5, {sl, fp, ip}
    285c:	1d000015 	stcne	0, cr0, [r0, #-84]	; 0xffffffac
    2860:	00148805 	andseq	r8, r4, r5, lsl #16
    2864:	1a051e00 	bne	14a06c <__bss_end+0x14052c>
    2868:	1f000017 	svcne	0x00000017
    286c:	00177605 	andseq	r7, r7, r5, lsl #12
    2870:	b7052000 	strlt	r2, [r5, -r0]
    2874:	21000017 	tstcs	r0, r7, lsl r0
    2878:	0017c505 	andseq	ip, r7, r5, lsl #10
    287c:	da052200 	ble	14b084 <__bss_end+0x141544>
    2880:	23000015 	movwcs	r0, #21
    2884:	0014fd05 	andseq	pc, r4, r5, lsl #26
    2888:	3c052400 	cfstrscc	mvf2, [r5], {-0}
    288c:	25000013 	strcs	r0, [r0, #-19]	; 0xffffffed
    2890:	00159005 	andseq	r9, r5, r5
    2894:	a2052600 	andge	r2, r5, #0, 12
    2898:	27000014 	smladcs	r0, r4, r0, r0
    289c:	00174505 	andseq	r4, r7, r5, lsl #10
    28a0:	b2052800 	andlt	r2, r5, #0, 16
    28a4:	29000014 	stmdbcs	r0, {r2, r4}
    28a8:	0014c105 	andseq	ip, r4, r5, lsl #2
    28ac:	d0052a00 	andle	r2, r5, r0, lsl #20
    28b0:	2b000014 	blcs	2908 <shift+0x2908>
    28b4:	0014df05 	andseq	sp, r4, r5, lsl #30
    28b8:	6d052c00 	stcvs	12, cr2, [r5, #-0]
    28bc:	2d000014 	stccs	0, cr0, [r0, #-80]	; 0xffffffb0
    28c0:	0014ee05 	andseq	lr, r4, r5, lsl #28
    28c4:	d4052e00 	strle	r2, [r5], #-3584	; 0xfffff200
    28c8:	2f000016 	svccs	0x00000016
    28cc:	00150c05 	andseq	r0, r5, r5, lsl #24
    28d0:	1b053000 	blne	14e8d8 <__bss_end+0x144d98>
    28d4:	31000015 	tstcc	r0, r5, lsl r0
    28d8:	0012cd05 	andseq	ip, r2, r5, lsl #26
    28dc:	25053200 	strcs	r3, [r5, #-512]	; 0xfffffe00
    28e0:	33000016 	movwcc	r0, #22
    28e4:	00163505 	andseq	r3, r6, r5, lsl #10
    28e8:	45053400 	strmi	r3, [r5, #-1024]	; 0xfffffc00
    28ec:	35000016 	strcc	r0, [r0, #-22]	; 0xffffffea
    28f0:	00145b05 	andseq	r5, r4, r5, lsl #22
    28f4:	55053600 	strpl	r3, [r5, #-1536]	; 0xfffffa00
    28f8:	37000016 	smladcc	r0, r6, r0, r0
    28fc:	00166505 	andseq	r6, r6, r5, lsl #10
    2900:	75053800 	strvc	r3, [r5, #-2048]	; 0xfffff800
    2904:	39000016 	stmdbcc	r0, {r1, r2, r4}
    2908:	00134c05 	andseq	r4, r3, r5, lsl #24
    290c:	05053a00 	streq	r3, [r5, #-2560]	; 0xfffff600
    2910:	3b000013 	blcc	2964 <shift+0x2964>
    2914:	00152a05 	andseq	r2, r5, r5, lsl #20
    2918:	a4053c00 	strge	r3, [r5], #-3072	; 0xfffff400
    291c:	3d000012 	stccc	0, cr0, [r0, #-72]	; 0xffffffb8
    2920:	00169005 	andseq	r9, r6, r5
    2924:	06003e00 	streq	r3, [r0], -r0, lsl #28
    2928:	0000138c 	andeq	r1, r0, ip, lsl #7
    292c:	026b0202 	rsbeq	r0, fp, #536870912	; 0x20000000
    2930:	00020e08 	andeq	r0, r2, r8, lsl #28
    2934:	154f0700 	strbne	r0, [pc, #-1792]	; 223c <shift+0x223c>
    2938:	70020000 	andvc	r0, r2, r0
    293c:	00561402 	subseq	r1, r6, r2, lsl #8
    2940:	07000000 	streq	r0, [r0, -r0]
    2944:	00001468 	andeq	r1, r0, r8, ror #8
    2948:	14027102 	strne	r7, [r2], #-258	; 0xfffffefe
    294c:	00000056 	andeq	r0, r0, r6, asr r0
    2950:	e3080001 	movw	r0, #32769	; 0x8001
    2954:	09000001 	stmdbeq	r0, {r0}
    2958:	0000020e 	andeq	r0, r0, lr, lsl #4
    295c:	00000223 	andeq	r0, r0, r3, lsr #4
    2960:	0000330a 	andeq	r3, r0, sl, lsl #6
    2964:	08001100 	stmdaeq	r0, {r8, ip}
    2968:	00000213 	andeq	r0, r0, r3, lsl r2
    296c:	0016130b 	andseq	r1, r6, fp, lsl #6
    2970:	02740200 	rsbseq	r0, r4, #0, 4
    2974:	00022326 	andeq	r2, r2, r6, lsr #6
    2978:	3d3a2400 	cfldrscc	mvf2, [sl, #-0]
    297c:	3d0f3d0a 	stccc	13, cr3, [pc, #-40]	; 295c <shift+0x295c>
    2980:	3d323d24 	ldccc	13, cr3, [r2, #-144]!	; 0xffffff70
    2984:	3d053d02 	stccc	13, cr3, [r5, #-8]
    2988:	3d0d3d13 	stccc	13, cr3, [sp, #-76]	; 0xffffffb4
    298c:	3d233d0c 	stccc	13, cr3, [r3, #-48]!	; 0xffffffd0
    2990:	3d263d11 	stccc	13, cr3, [r6, #-68]!	; 0xffffffbc
    2994:	3d173d01 	ldccc	13, cr3, [r7, #-4]
    2998:	3d093d08 	stccc	13, cr3, [r9, #-32]	; 0xffffffe0
    299c:	02020000 	andeq	r0, r2, #0
    29a0:	00072007 	andeq	r2, r7, r7
    29a4:	08010200 	stmdaeq	r1, {r9}
    29a8:	0000091e 	andeq	r0, r0, lr, lsl r9
    29ac:	6a050202 	bvs	1431bc <__bss_end+0x13967c>
    29b0:	0c000009 	stceq	0, cr0, [r0], {9}
    29b4:	0000183b 	andeq	r1, r0, fp, lsr r8
    29b8:	33168103 	tstcc	r6, #-1073741824	; 0xc0000000
    29bc:	0c000000 	stceq	0, cr0, [r0], {-0}
    29c0:	00001843 	andeq	r1, r0, r3, asr #16
    29c4:	25168503 	ldrcs	r8, [r6, #-1283]	; 0xfffffafd
    29c8:	02000000 	andeq	r0, r0, #0
    29cc:	12bd0404 	adcsne	r0, sp, #4, 8	; 0x4000000
    29d0:	08020000 	stmdaeq	r2, {}	; <UNPREDICTABLE>
    29d4:	0012b503 	andseq	fp, r2, r3, lsl #10
    29d8:	04080200 	streq	r0, [r8], #-512	; 0xfffffe00
    29dc:	00001566 	andeq	r1, r0, r6, ror #10
    29e0:	b7031002 	strlt	r1, [r3, -r2]
    29e4:	0d000016 	stceq	0, cr0, [r0, #-88]	; 0xffffffa8
    29e8:	000018ff 	strdeq	r1, [r0], -pc	; <UNPREDICTABLE>
    29ec:	0103b301 	tsteq	r3, r1, lsl #6
    29f0:	0000027b 	andeq	r0, r0, fp, ror r2
    29f4:	00009938 	andeq	r9, r0, r8, lsr r9
    29f8:	00000120 	andeq	r0, r0, r0, lsr #2
    29fc:	037d9c01 	cmneq	sp, #256	; 0x100
    2a00:	6e0e0000 	cdpvs	0, 0, cr0, cr14, cr0, {0}
    2a04:	03b30100 			; <UNDEFINED> instruction: 0x03b30100
    2a08:	00027b17 	andeq	r7, r2, r7, lsl fp
    2a0c:	00014900 	andeq	r4, r1, r0, lsl #18
    2a10:	00014500 	andeq	r4, r1, r0, lsl #10
    2a14:	00640e00 	rsbeq	r0, r4, r0, lsl #28
    2a18:	2203b301 	andcs	fp, r3, #67108864	; 0x4000000
    2a1c:	0000027b 	andeq	r0, r0, fp, ror r2
    2a20:	00000175 	andeq	r0, r0, r5, ror r1
    2a24:	00000171 	andeq	r0, r0, r1, ror r1
    2a28:	0070720f 	rsbseq	r7, r0, pc, lsl #4
    2a2c:	2e03b301 	cdpcs	3, 0, cr11, cr3, cr1, {0}
    2a30:	0000037d 	andeq	r0, r0, sp, ror r3
    2a34:	10009102 	andne	r9, r0, r2, lsl #2
    2a38:	b5010071 	strlt	r0, [r1, #-113]	; 0xffffff8f
    2a3c:	027b0b03 	rsbseq	r0, fp, #3072	; 0xc00
    2a40:	01a50000 			; <UNDEFINED> instruction: 0x01a50000
    2a44:	019d0000 	orrseq	r0, sp, r0
    2a48:	72100000 	andsvc	r0, r0, #0
    2a4c:	03b50100 			; <UNDEFINED> instruction: 0x03b50100
    2a50:	00027b12 	andeq	r7, r2, r2, lsl fp
    2a54:	0001fb00 	andeq	pc, r1, r0, lsl #22
    2a58:	0001f100 	andeq	pc, r1, r0, lsl #2
    2a5c:	00791000 	rsbseq	r1, r9, r0
    2a60:	1903b501 	stmdbne	r3, {r0, r8, sl, ip, sp, pc}
    2a64:	0000027b 	andeq	r0, r0, fp, ror r2
    2a68:	00000259 	andeq	r0, r0, r9, asr r2
    2a6c:	00000253 	andeq	r0, r0, r3, asr r2
    2a70:	317a6c10 	cmncc	sl, r0, lsl ip
    2a74:	03b60100 			; <UNDEFINED> instruction: 0x03b60100
    2a78:	00026f0a 	andeq	r6, r2, sl, lsl #30
    2a7c:	00029300 	andeq	r9, r2, r0, lsl #6
    2a80:	00029100 	andeq	r9, r2, r0, lsl #2
    2a84:	7a6c1000 	bvc	1b06a8c <__bss_end+0x1afcf4c>
    2a88:	b6010032 			; <UNDEFINED> instruction: 0xb6010032
    2a8c:	026f0f03 	rsbeq	r0, pc, #3, 30
    2a90:	02aa0000 	adceq	r0, sl, #0
    2a94:	02a80000 	adceq	r0, r8, #0
    2a98:	69100000 	ldmdbvs	r0, {}	; <UNPREDICTABLE>
    2a9c:	03b60100 			; <UNDEFINED> instruction: 0x03b60100
    2aa0:	00026f14 	andeq	r6, r2, r4, lsl pc
    2aa4:	0002c900 	andeq	ip, r2, r0, lsl #18
    2aa8:	0002bd00 	andeq	fp, r2, r0, lsl #26
    2aac:	006b1000 	rsbeq	r1, fp, r0
    2ab0:	1703b601 	strne	fp, [r3, -r1, lsl #12]
    2ab4:	0000026f 	andeq	r0, r0, pc, ror #4
    2ab8:	0000031b 	andeq	r0, r0, fp, lsl r3
    2abc:	00000317 	andeq	r0, r0, r7, lsl r3
    2ac0:	7b041100 	blvc	106ec8 <__bss_end+0xfd388>
    2ac4:	00000002 	andeq	r0, r0, r2

Disassembly of section .debug_abbrev:

00000000 <.debug_abbrev>:
   0:	10001101 	andne	r1, r0, r1, lsl #2
   4:	12011106 	andne	r1, r1, #-2147483647	; 0x80000001
   8:	1b0e0301 	blne	380c14 <__bss_end+0x3770d4>
   c:	130e250e 	movwne	r2, #58638	; 0xe50e
  10:	00000005 	andeq	r0, r0, r5
  14:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
  18:	030b130e 	movweq	r1, #45838	; 0xb30e
  1c:	110e1b0e 	tstne	lr, lr, lsl #22
  20:	10061201 	andne	r1, r6, r1, lsl #4
  24:	02000017 	andeq	r0, r0, #23
  28:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
  2c:	0b3b0b3a 	bleq	ec2d1c <__bss_end+0xeb91dc>
  30:	13490b39 	movtne	r0, #39737	; 0x9b39
  34:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
  38:	24030000 	strcs	r0, [r3], #-0
  3c:	3e0b0b00 	vmlacc.f64	d0, d11, d0
  40:	000e030b 	andeq	r0, lr, fp, lsl #6
  44:	012e0400 			; <UNDEFINED> instruction: 0x012e0400
  48:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
  4c:	0b3b0b3a 	bleq	ec2d3c <__bss_end+0xeb91fc>
  50:	01110b39 	tsteq	r1, r9, lsr fp
  54:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
  58:	01194296 			; <UNDEFINED> instruction: 0x01194296
  5c:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
  60:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
  64:	0b3b0b3a 	bleq	ec2d54 <__bss_end+0xeb9214>
  68:	13490b39 	movtne	r0, #39737	; 0x9b39
  6c:	00001802 	andeq	r1, r0, r2, lsl #16
  70:	0b002406 	bleq	9090 <_Z4ftoafPc+0x24>
  74:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
  78:	07000008 	streq	r0, [r0, -r8]
  7c:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
  80:	0b3a0e03 	bleq	e83894 <__bss_end+0xe79d54>
  84:	0b390b3b 	bleq	e42d78 <__bss_end+0xe39238>
  88:	06120111 			; <UNDEFINED> instruction: 0x06120111
  8c:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
  90:	00130119 	andseq	r0, r3, r9, lsl r1
  94:	010b0800 	tsteq	fp, r0, lsl #16
  98:	06120111 			; <UNDEFINED> instruction: 0x06120111
  9c:	34090000 	strcc	r0, [r9], #-0
  a0:	3a080300 	bcc	200ca8 <__bss_end+0x1f7168>
  a4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
  a8:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
  ac:	0a000018 	beq	114 <shift+0x114>
  b0:	0b0b000f 	bleq	2c00f4 <__bss_end+0x2b65b4>
  b4:	00001349 	andeq	r1, r0, r9, asr #6
  b8:	01110100 	tsteq	r1, r0, lsl #2
  bc:	0b130e25 	bleq	4c3958 <__bss_end+0x4b9e18>
  c0:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
  c4:	06120111 			; <UNDEFINED> instruction: 0x06120111
  c8:	00001710 	andeq	r1, r0, r0, lsl r7
  cc:	03001602 	movweq	r1, #1538	; 0x602
  d0:	3b0b3a0e 	blcc	2ce910 <__bss_end+0x2c4dd0>
  d4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
  d8:	03000013 	movweq	r0, #19
  dc:	0b0b000f 	bleq	2c0120 <__bss_end+0x2b65e0>
  e0:	00001349 	andeq	r1, r0, r9, asr #6
  e4:	00001504 	andeq	r1, r0, r4, lsl #10
  e8:	01010500 	tsteq	r1, r0, lsl #10
  ec:	13011349 	movwne	r1, #4937	; 0x1349
  f0:	21060000 	mrscs	r0, (UNDEF: 6)
  f4:	2f134900 	svccs	0x00134900
  f8:	07000006 	streq	r0, [r0, -r6]
  fc:	0b0b0024 	bleq	2c0194 <__bss_end+0x2b6654>
 100:	0e030b3e 	vmoveq.16	d3[0], r0
 104:	34080000 	strcc	r0, [r8], #-0
 108:	3a0e0300 	bcc	380d10 <__bss_end+0x3771d0>
 10c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 110:	3f13490b 	svccc	0x0013490b
 114:	00193c19 	andseq	r3, r9, r9, lsl ip
 118:	012e0900 			; <UNDEFINED> instruction: 0x012e0900
 11c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 120:	0b3b0b3a 	bleq	ec2e10 <__bss_end+0xeb92d0>
 124:	13490b39 	movtne	r0, #39737	; 0x9b39
 128:	06120111 			; <UNDEFINED> instruction: 0x06120111
 12c:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 130:	00130119 	andseq	r0, r3, r9, lsl r1
 134:	00340a00 	eorseq	r0, r4, r0, lsl #20
 138:	0b3a0e03 	bleq	e8394c <__bss_end+0xe79e0c>
 13c:	0b390b3b 	bleq	e42e30 <__bss_end+0xe392f0>
 140:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 144:	240b0000 	strcs	r0, [fp], #-0
 148:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 14c:	0008030b 	andeq	r0, r8, fp, lsl #6
 150:	002e0c00 	eoreq	r0, lr, r0, lsl #24
 154:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 158:	0b3b0b3a 	bleq	ec2e48 <__bss_end+0xeb9308>
 15c:	01110b39 	tsteq	r1, r9, lsr fp
 160:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 164:	00194297 	mulseq	r9, r7, r2
 168:	01390d00 	teqeq	r9, r0, lsl #26
 16c:	0b3a0e03 	bleq	e83980 <__bss_end+0xe79e40>
 170:	13010b3b 	movwne	r0, #6971	; 0x1b3b
 174:	2e0e0000 	cdpcs	0, 0, cr0, cr14, cr0, {0}
 178:	03193f01 	tsteq	r9, #1, 30
 17c:	3b0b3a0e 	blcc	2ce9bc <__bss_end+0x2c4e7c>
 180:	3c0b390b 			; <UNDEFINED> instruction: 0x3c0b390b
 184:	00130119 	andseq	r0, r3, r9, lsl r1
 188:	00050f00 	andeq	r0, r5, r0, lsl #30
 18c:	00001349 	andeq	r1, r0, r9, asr #6
 190:	3f012e10 	svccc	0x00012e10
 194:	3a0e0319 	bcc	380e00 <__bss_end+0x3772c0>
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
 1c0:	3a080300 	bcc	200dc8 <__bss_end+0x1f7288>
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
 1f4:	0b0b0024 	bleq	2c028c <__bss_end+0x2b674c>
 1f8:	0e030b3e 	vmoveq.16	d3[0], r0
 1fc:	24030000 	strcs	r0, [r3], #-0
 200:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 204:	0008030b 	andeq	r0, r8, fp, lsl #6
 208:	00160400 	andseq	r0, r6, r0, lsl #8
 20c:	0b3a0e03 	bleq	e83a20 <__bss_end+0xe79ee0>
 210:	0b390b3b 	bleq	e42f04 <__bss_end+0xe393c4>
 214:	00001349 	andeq	r1, r0, r9, asr #6
 218:	49002605 	stmdbmi	r0, {r0, r2, r9, sl, sp}
 21c:	06000013 			; <UNDEFINED> instruction: 0x06000013
 220:	0e030113 	mcreq	1, 0, r0, cr3, cr3, {0}
 224:	0b3a0b0b 	bleq	e82e58 <__bss_end+0xe79318>
 228:	0b390b3b 	bleq	e42f1c <__bss_end+0xe393dc>
 22c:	00001301 	andeq	r1, r0, r1, lsl #6
 230:	03000d07 	movweq	r0, #3335	; 0xd07
 234:	3b0b3a08 	blcc	2cea5c <__bss_end+0x2c4f1c>
 238:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 23c:	000b3813 	andeq	r3, fp, r3, lsl r8
 240:	01040800 	tsteq	r4, r0, lsl #16
 244:	196d0e03 	stmdbne	sp!, {r0, r1, r9, sl, fp}^
 248:	0b0b0b3e 	bleq	2c2f48 <__bss_end+0x2b9408>
 24c:	0b3a1349 	bleq	e84f78 <__bss_end+0xe7b438>
 250:	0b390b3b 	bleq	e42f44 <__bss_end+0xe39404>
 254:	00001301 	andeq	r1, r0, r1, lsl #6
 258:	03002809 	movweq	r2, #2057	; 0x809
 25c:	000b1c0e 	andeq	r1, fp, lr, lsl #24
 260:	00340a00 	eorseq	r0, r4, r0, lsl #20
 264:	0b3a0e03 	bleq	e83a78 <__bss_end+0xe79f38>
 268:	0b390b3b 	bleq	e42f5c <__bss_end+0xe3941c>
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
 294:	0b3b0b3a 	bleq	ec2f84 <__bss_end+0xeb9444>
 298:	13490b39 	movtne	r0, #39737	; 0x9b39
 29c:	00000b38 	andeq	r0, r0, r8, lsr fp
 2a0:	4901010f 	stmdbmi	r1, {r0, r1, r2, r3, r8}
 2a4:	00130113 	andseq	r0, r3, r3, lsl r1
 2a8:	00211000 	eoreq	r1, r1, r0
 2ac:	0b2f1349 	bleq	bc4fd8 <__bss_end+0xbbb498>
 2b0:	02110000 	andseq	r0, r1, #0
 2b4:	0b0e0301 	bleq	380ec0 <__bss_end+0x377380>
 2b8:	3b0b3a0b 	blcc	2ceaec <__bss_end+0x2c4fac>
 2bc:	010b390b 	tsteq	fp, fp, lsl #18
 2c0:	12000013 	andne	r0, r0, #19
 2c4:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 2c8:	0b3a0e03 	bleq	e83adc <__bss_end+0xe79f9c>
 2cc:	0b390b3b 	bleq	e42fc0 <__bss_end+0xe39480>
 2d0:	193c0e6e 	ldmdbne	ip!, {r1, r2, r3, r5, r6, r9, sl, fp}
 2d4:	13011364 	movwne	r1, #4964	; 0x1364
 2d8:	05130000 	ldreq	r0, [r3, #-0]
 2dc:	34134900 	ldrcc	r4, [r3], #-2304	; 0xfffff700
 2e0:	14000019 	strne	r0, [r0], #-25	; 0xffffffe7
 2e4:	13490005 	movtne	r0, #36869	; 0x9005
 2e8:	2e150000 	cdpcs	0, 1, cr0, cr5, cr0, {0}
 2ec:	03193f01 	tsteq	r9, #1, 30
 2f0:	3b0b3a0e 	blcc	2ceb30 <__bss_end+0x2c4ff0>
 2f4:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 2f8:	3c13490e 			; <UNDEFINED> instruction: 0x3c13490e
 2fc:	01136419 	tsteq	r3, r9, lsl r4
 300:	16000013 			; <UNDEFINED> instruction: 0x16000013
 304:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 308:	0b3a0e03 	bleq	e83b1c <__bss_end+0xe79fdc>
 30c:	0b390b3b 	bleq	e43000 <__bss_end+0xe394c0>
 310:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 314:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 318:	13011364 	movwne	r1, #4964	; 0x1364
 31c:	0d170000 	ldceq	0, cr0, [r7, #-0]
 320:	3a0e0300 	bcc	380f28 <__bss_end+0x3773e8>
 324:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 328:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 32c:	000b320b 	andeq	r3, fp, fp, lsl #4
 330:	012e1800 			; <UNDEFINED> instruction: 0x012e1800
 334:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 338:	0b3b0b3a 	bleq	ec3028 <__bss_end+0xeb94e8>
 33c:	0e6e0b39 	vmoveq.8	d14[5], r0
 340:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 344:	13011364 	movwne	r1, #4964	; 0x1364
 348:	2e190000 	cdpcs	0, 1, cr0, cr9, cr0, {0}
 34c:	03193f01 	tsteq	r9, #1, 30
 350:	3b0b3a0e 	blcc	2ceb90 <__bss_end+0x2c5050>
 354:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 358:	3213490e 	andscc	r4, r3, #229376	; 0x38000
 35c:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
 360:	1a000013 	bne	3b4 <shift+0x3b4>
 364:	13490115 	movtne	r0, #37141	; 0x9115
 368:	13011364 	movwne	r1, #4964	; 0x1364
 36c:	1f1b0000 	svcne	0x001b0000
 370:	49131d00 	ldmdbmi	r3, {r8, sl, fp, ip}
 374:	1c000013 	stcne	0, cr0, [r0], {19}
 378:	0b0b0010 	bleq	2c03c0 <__bss_end+0x2b6880>
 37c:	00001349 	andeq	r1, r0, r9, asr #6
 380:	0b000f1d 	bleq	3ffc <shift+0x3ffc>
 384:	1e00000b 	cdpne	0, 0, cr0, cr0, cr11, {0}
 388:	08030139 	stmdaeq	r3, {r0, r3, r4, r5, r8}
 38c:	0b3b0b3a 	bleq	ec307c <__bss_end+0xeb953c>
 390:	13010b39 	movwne	r0, #6969	; 0x1b39
 394:	341f0000 	ldrcc	r0, [pc], #-0	; 39c <shift+0x39c>
 398:	3a0e0300 	bcc	380fa0 <__bss_end+0x377460>
 39c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 3a0:	3c13490b 			; <UNDEFINED> instruction: 0x3c13490b
 3a4:	6c061c19 	stcvs	12, cr1, [r6], {25}
 3a8:	20000019 	andcs	r0, r0, r9, lsl r0
 3ac:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 3b0:	0b3b0b3a 	bleq	ec30a0 <__bss_end+0xeb9560>
 3b4:	13490b39 	movtne	r0, #39737	; 0x9b39
 3b8:	0b1c193c 	bleq	7068b0 <__bss_end+0x6fcd70>
 3bc:	0000196c 	andeq	r1, r0, ip, ror #18
 3c0:	47003421 	strmi	r3, [r0, -r1, lsr #8]
 3c4:	22000013 	andcs	r0, r0, #19
 3c8:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 3cc:	0b3a0e03 	bleq	e83be0 <__bss_end+0xe7a0a0>
 3d0:	0b390b3b 	bleq	e430c4 <__bss_end+0xe39584>
 3d4:	01111349 	tsteq	r1, r9, asr #6
 3d8:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 3dc:	01194296 			; <UNDEFINED> instruction: 0x01194296
 3e0:	23000013 	movwcs	r0, #19
 3e4:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
 3e8:	0b3b0b3a 	bleq	ec30d8 <__bss_end+0xeb9598>
 3ec:	13490b39 	movtne	r0, #39737	; 0x9b39
 3f0:	00001802 	andeq	r1, r0, r2, lsl #16
 3f4:	03003424 	movweq	r3, #1060	; 0x424
 3f8:	3b0b3a0e 	blcc	2cec38 <__bss_end+0x2c50f8>
 3fc:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 400:	00180213 	andseq	r0, r8, r3, lsl r2
 404:	11010000 	mrsne	r0, (UNDEF: 1)
 408:	130e2501 	movwne	r2, #58625	; 0xe501
 40c:	1b0e030b 	blne	381040 <__bss_end+0x377500>
 410:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 414:	00171006 	andseq	r1, r7, r6
 418:	00240200 	eoreq	r0, r4, r0, lsl #4
 41c:	0b3e0b0b 	bleq	f83050 <__bss_end+0xf79510>
 420:	00000e03 	andeq	r0, r0, r3, lsl #28
 424:	49002603 	stmdbmi	r0, {r0, r1, r9, sl, sp}
 428:	04000013 	streq	r0, [r0], #-19	; 0xffffffed
 42c:	0b0b0024 	bleq	2c04c4 <__bss_end+0x2b6984>
 430:	08030b3e 	stmdaeq	r3, {r1, r2, r3, r4, r5, r8, r9, fp}
 434:	16050000 	strne	r0, [r5], -r0
 438:	3a0e0300 	bcc	381040 <__bss_end+0x377500>
 43c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 440:	0013490b 	andseq	r4, r3, fp, lsl #18
 444:	01130600 	tsteq	r3, r0, lsl #12
 448:	0b0b0e03 	bleq	2c3c5c <__bss_end+0x2ba11c>
 44c:	0b3b0b3a 	bleq	ec313c <__bss_end+0xeb95fc>
 450:	13010b39 	movwne	r0, #6969	; 0x1b39
 454:	0d070000 	stceq	0, cr0, [r7, #-0]
 458:	3a080300 	bcc	201060 <__bss_end+0x1f7520>
 45c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 460:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 464:	0800000b 	stmdaeq	r0, {r0, r1, r3}
 468:	0e030104 	adfeqs	f0, f3, f4
 46c:	0b3e196d 	bleq	f86a28 <__bss_end+0xf7cee8>
 470:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 474:	0b3b0b3a 	bleq	ec3164 <__bss_end+0xeb9624>
 478:	13010b39 	movwne	r0, #6969	; 0x1b39
 47c:	28090000 	stmdacs	r9, {}	; <UNPREDICTABLE>
 480:	1c080300 	stcne	3, cr0, [r8], {-0}
 484:	0a00000b 	beq	4b8 <shift+0x4b8>
 488:	0e030028 	cdpeq	0, 0, cr0, cr3, cr8, {1}
 48c:	00000b1c 	andeq	r0, r0, ip, lsl fp
 490:	0300340b 	movweq	r3, #1035	; 0x40b
 494:	3b0b3a0e 	blcc	2cecd4 <__bss_end+0x2c5194>
 498:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 49c:	02196c13 	andseq	r6, r9, #4864	; 0x1300
 4a0:	0c000018 	stceq	0, cr0, [r0], {24}
 4a4:	0e030002 	cdpeq	0, 0, cr0, cr3, cr2, {0}
 4a8:	0000193c 	andeq	r1, r0, ip, lsr r9
 4ac:	0b000f0d 	bleq	40e8 <shift+0x40e8>
 4b0:	0013490b 	andseq	r4, r3, fp, lsl #18
 4b4:	000d0e00 	andeq	r0, sp, r0, lsl #28
 4b8:	0b3a0e03 	bleq	e83ccc <__bss_end+0xe7a18c>
 4bc:	0b390b3b 	bleq	e431b0 <__bss_end+0xe39670>
 4c0:	0b381349 	bleq	e051ec <__bss_end+0xdfb6ac>
 4c4:	010f0000 	mrseq	r0, CPSR
 4c8:	01134901 	tsteq	r3, r1, lsl #18
 4cc:	10000013 	andne	r0, r0, r3, lsl r0
 4d0:	13490021 	movtne	r0, #36897	; 0x9021
 4d4:	00000b2f 	andeq	r0, r0, pc, lsr #22
 4d8:	03010211 	movweq	r0, #4625	; 0x1211
 4dc:	3a0b0b0e 	bcc	2c311c <__bss_end+0x2b95dc>
 4e0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 4e4:	0013010b 	andseq	r0, r3, fp, lsl #2
 4e8:	012e1200 			; <UNDEFINED> instruction: 0x012e1200
 4ec:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 4f0:	0b3b0b3a 	bleq	ec31e0 <__bss_end+0xeb96a0>
 4f4:	0e6e0b39 	vmoveq.8	d14[5], r0
 4f8:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 4fc:	00001301 	andeq	r1, r0, r1, lsl #6
 500:	49000513 	stmdbmi	r0, {r0, r1, r4, r8, sl}
 504:	00193413 	andseq	r3, r9, r3, lsl r4
 508:	00051400 	andeq	r1, r5, r0, lsl #8
 50c:	00001349 	andeq	r1, r0, r9, asr #6
 510:	3f012e15 	svccc	0x00012e15
 514:	3a0e0319 	bcc	381180 <__bss_end+0x377640>
 518:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 51c:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 520:	64193c13 	ldrvs	r3, [r9], #-3091	; 0xfffff3ed
 524:	00130113 	andseq	r0, r3, r3, lsl r1
 528:	012e1600 			; <UNDEFINED> instruction: 0x012e1600
 52c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 530:	0b3b0b3a 	bleq	ec3220 <__bss_end+0xeb96e0>
 534:	0e6e0b39 	vmoveq.8	d14[5], r0
 538:	0b321349 	bleq	c85264 <__bss_end+0xc7b724>
 53c:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 540:	00001301 	andeq	r1, r0, r1, lsl #6
 544:	03000d17 	movweq	r0, #3351	; 0xd17
 548:	3b0b3a0e 	blcc	2ced88 <__bss_end+0x2c5248>
 54c:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 550:	320b3813 	andcc	r3, fp, #1245184	; 0x130000
 554:	1800000b 	stmdane	r0, {r0, r1, r3}
 558:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 55c:	0b3a0e03 	bleq	e83d70 <__bss_end+0xe7a230>
 560:	0b390b3b 	bleq	e43254 <__bss_end+0xe39714>
 564:	0b320e6e 	bleq	c83f24 <__bss_end+0xc7a3e4>
 568:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 56c:	00001301 	andeq	r1, r0, r1, lsl #6
 570:	3f012e19 	svccc	0x00012e19
 574:	3a0e0319 	bcc	3811e0 <__bss_end+0x3776a0>
 578:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 57c:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 580:	3c0b3213 	sfmcc	f3, 4, [fp], {19}
 584:	00136419 	andseq	r6, r3, r9, lsl r4
 588:	01151a00 	tsteq	r5, r0, lsl #20
 58c:	13641349 	cmnne	r4, #603979777	; 0x24000001
 590:	00001301 	andeq	r1, r0, r1, lsl #6
 594:	1d001f1b 	stcne	15, cr1, [r0, #-108]	; 0xffffff94
 598:	00134913 	andseq	r4, r3, r3, lsl r9
 59c:	00101c00 	andseq	r1, r0, r0, lsl #24
 5a0:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 5a4:	0f1d0000 	svceq	0x001d0000
 5a8:	000b0b00 	andeq	r0, fp, r0, lsl #22
 5ac:	00341e00 	eorseq	r1, r4, r0, lsl #28
 5b0:	0b3a0e03 	bleq	e83dc4 <__bss_end+0xe7a284>
 5b4:	0b390b3b 	bleq	e432a8 <__bss_end+0xe39768>
 5b8:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 5bc:	2e1f0000 	cdpcs	0, 1, cr0, cr15, cr0, {0}
 5c0:	03193f01 	tsteq	r9, #1, 30
 5c4:	3b0b3a0e 	blcc	2cee04 <__bss_end+0x2c52c4>
 5c8:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 5cc:	1113490e 	tstne	r3, lr, lsl #18
 5d0:	40061201 	andmi	r1, r6, r1, lsl #4
 5d4:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
 5d8:	00001301 	andeq	r1, r0, r1, lsl #6
 5dc:	03000520 	movweq	r0, #1312	; 0x520
 5e0:	3b0b3a0e 	blcc	2cee20 <__bss_end+0x2c52e0>
 5e4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 5e8:	00180213 	andseq	r0, r8, r3, lsl r2
 5ec:	012e2100 			; <UNDEFINED> instruction: 0x012e2100
 5f0:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 5f4:	0b3b0b3a 	bleq	ec32e4 <__bss_end+0xeb97a4>
 5f8:	0e6e0b39 	vmoveq.8	d14[5], r0
 5fc:	01111349 	tsteq	r1, r9, asr #6
 600:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 604:	01194297 			; <UNDEFINED> instruction: 0x01194297
 608:	22000013 	andcs	r0, r0, #19
 60c:	08030034 	stmdaeq	r3, {r2, r4, r5}
 610:	0b3b0b3a 	bleq	ec3300 <__bss_end+0xeb97c0>
 614:	13490b39 	movtne	r0, #39737	; 0x9b39
 618:	00001802 	andeq	r1, r0, r2, lsl #16
 61c:	3f012e23 	svccc	0x00012e23
 620:	3a0e0319 	bcc	38128c <__bss_end+0x37774c>
 624:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 628:	110e6e0b 	tstne	lr, fp, lsl #28
 62c:	40061201 	andmi	r1, r6, r1, lsl #4
 630:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
 634:	00001301 	andeq	r1, r0, r1, lsl #6
 638:	3f002e24 	svccc	0x00002e24
 63c:	3a0e0319 	bcc	3812a8 <__bss_end+0x377768>
 640:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 644:	110e6e0b 	tstne	lr, fp, lsl #28
 648:	40061201 	andmi	r1, r6, r1, lsl #4
 64c:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
 650:	2e250000 	cdpcs	0, 2, cr0, cr5, cr0, {0}
 654:	03193f01 	tsteq	r9, #1, 30
 658:	3b0b3a0e 	blcc	2cee98 <__bss_end+0x2c5358>
 65c:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 660:	1113490e 	tstne	r3, lr, lsl #18
 664:	40061201 	andmi	r1, r6, r1, lsl #4
 668:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
 66c:	01000000 	mrseq	r0, (UNDEF: 0)
 670:	0e250111 	mcreq	1, 1, r0, cr5, cr1, {0}
 674:	0e030b13 	vmoveq.32	d3[0], r0
 678:	01110e1b 	tsteq	r1, fp, lsl lr
 67c:	17100612 			; <UNDEFINED> instruction: 0x17100612
 680:	39020000 	stmdbcc	r2, {}	; <UNPREDICTABLE>
 684:	00130101 	andseq	r0, r3, r1, lsl #2
 688:	00340300 	eorseq	r0, r4, r0, lsl #6
 68c:	0b3a0e03 	bleq	e83ea0 <__bss_end+0xe7a360>
 690:	0b390b3b 	bleq	e43384 <__bss_end+0xe39844>
 694:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
 698:	00000a1c 	andeq	r0, r0, ip, lsl sl
 69c:	3a003a04 	bcc	eeb4 <__bss_end+0x5374>
 6a0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 6a4:	0013180b 	andseq	r1, r3, fp, lsl #16
 6a8:	01010500 	tsteq	r1, r0, lsl #10
 6ac:	13011349 	movwne	r1, #4937	; 0x1349
 6b0:	21060000 	mrscs	r0, (UNDEF: 6)
 6b4:	2f134900 	svccs	0x00134900
 6b8:	0700000b 	streq	r0, [r0, -fp]
 6bc:	13490026 	movtne	r0, #36902	; 0x9026
 6c0:	24080000 	strcs	r0, [r8], #-0
 6c4:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 6c8:	000e030b 	andeq	r0, lr, fp, lsl #6
 6cc:	00340900 	eorseq	r0, r4, r0, lsl #18
 6d0:	00001347 	andeq	r1, r0, r7, asr #6
 6d4:	3f012e0a 	svccc	0x00012e0a
 6d8:	3a0e0319 	bcc	381344 <__bss_end+0x377804>
 6dc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 6e0:	110e6e0b 	tstne	lr, fp, lsl #28
 6e4:	40061201 	andmi	r1, r6, r1, lsl #4
 6e8:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
 6ec:	00001301 	andeq	r1, r0, r1, lsl #6
 6f0:	0300050b 	movweq	r0, #1291	; 0x50b
 6f4:	3b0b3a08 	blcc	2cef1c <__bss_end+0x2c53dc>
 6f8:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 6fc:	00180213 	andseq	r0, r8, r3, lsl r2
 700:	00340c00 	eorseq	r0, r4, r0, lsl #24
 704:	0b3a0e03 	bleq	e83f18 <__bss_end+0xe7a3d8>
 708:	0b390b3b 	bleq	e433fc <__bss_end+0xe398bc>
 70c:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 710:	340d0000 	strcc	r0, [sp], #-0
 714:	3a080300 	bcc	20131c <__bss_end+0x1f77dc>
 718:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 71c:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 720:	0e000018 	mcreq	0, 0, r0, cr0, cr8, {0}
 724:	0b0b000f 	bleq	2c0768 <__bss_end+0x2b6c28>
 728:	00001349 	andeq	r1, r0, r9, asr #6
 72c:	3f012e0f 	svccc	0x00012e0f
 730:	3a0e0319 	bcc	38139c <__bss_end+0x37785c>
 734:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 738:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 73c:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
 740:	97184006 	ldrls	r4, [r8, -r6]
 744:	13011942 	movwne	r1, #6466	; 0x1942
 748:	05100000 	ldreq	r0, [r0, #-0]
 74c:	3a0e0300 	bcc	381354 <__bss_end+0x377814>
 750:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 754:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 758:	11000018 	tstne	r0, r8, lsl r0
 75c:	0b0b0024 	bleq	2c07f4 <__bss_end+0x2b6cb4>
 760:	08030b3e 	stmdaeq	r3, {r1, r2, r3, r4, r5, r8, r9, fp}
 764:	2e120000 	cdpcs	0, 1, cr0, cr2, cr0, {0}
 768:	03193f01 	tsteq	r9, #1, 30
 76c:	3b0b3a0e 	blcc	2cefac <__bss_end+0x2c546c>
 770:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 774:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 778:	97184006 	ldrls	r4, [r8, -r6]
 77c:	13011942 	movwne	r1, #6466	; 0x1942
 780:	0b130000 	bleq	4c0788 <__bss_end+0x4b6c48>
 784:	12011101 	andne	r1, r1, #1073741824	; 0x40000000
 788:	14000006 	strne	r0, [r0], #-6
 78c:	00000026 	andeq	r0, r0, r6, lsr #32
 790:	0b000f15 	bleq	43ec <shift+0x43ec>
 794:	1600000b 	strne	r0, [r0], -fp
 798:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 79c:	0b3a0e03 	bleq	e83fb0 <__bss_end+0xe7a470>
 7a0:	0b390b3b 	bleq	e43494 <__bss_end+0xe39954>
 7a4:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 7a8:	06120111 			; <UNDEFINED> instruction: 0x06120111
 7ac:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 7b0:	00130119 	andseq	r0, r3, r9, lsl r1
 7b4:	012e1700 			; <UNDEFINED> instruction: 0x012e1700
 7b8:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 7bc:	0b3b0b3a 	bleq	ec34ac <__bss_end+0xeb996c>
 7c0:	0e6e0b39 	vmoveq.8	d14[5], r0
 7c4:	06120111 			; <UNDEFINED> instruction: 0x06120111
 7c8:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 7cc:	00000019 	andeq	r0, r0, r9, lsl r0
 7d0:	10001101 	andne	r1, r0, r1, lsl #2
 7d4:	12011106 	andne	r1, r1, #-2147483647	; 0x80000001
 7d8:	1b0e0301 	blne	3813e4 <__bss_end+0x3778a4>
 7dc:	130e250e 	movwne	r2, #58638	; 0xe50e
 7e0:	00000005 	andeq	r0, r0, r5
 7e4:	10001101 	andne	r1, r0, r1, lsl #2
 7e8:	12011106 	andne	r1, r1, #-2147483647	; 0x80000001
 7ec:	1b0e0301 	blne	3813f8 <__bss_end+0x3778b8>
 7f0:	130e250e 	movwne	r2, #58638	; 0xe50e
 7f4:	00000005 	andeq	r0, r0, r5
 7f8:	10001101 	andne	r1, r0, r1, lsl #2
 7fc:	12011106 	andne	r1, r1, #-2147483647	; 0x80000001
 800:	1b0e0301 	blne	38140c <__bss_end+0x3778cc>
 804:	130e250e 	movwne	r2, #58638	; 0xe50e
 808:	00000005 	andeq	r0, r0, r5
 80c:	10001101 	andne	r1, r0, r1, lsl #2
 810:	12011106 	andne	r1, r1, #-2147483647	; 0x80000001
 814:	1b0e0301 	blne	381420 <__bss_end+0x3778e0>
 818:	130e250e 	movwne	r2, #58638	; 0xe50e
 81c:	00000005 	andeq	r0, r0, r5
 820:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
 824:	030b130e 	movweq	r1, #45838	; 0xb30e
 828:	100e1b0e 	andne	r1, lr, lr, lsl #22
 82c:	02000017 	andeq	r0, r0, #23
 830:	0b0b0024 	bleq	2c08c8 <__bss_end+0x2b6d88>
 834:	08030b3e 	stmdaeq	r3, {r1, r2, r3, r4, r5, r8, r9, fp}
 838:	24030000 	strcs	r0, [r3], #-0
 83c:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 840:	000e030b 	andeq	r0, lr, fp, lsl #6
 844:	01040400 	tsteq	r4, r0, lsl #8
 848:	0b3e0e03 	bleq	f8405c <__bss_end+0xf7a51c>
 84c:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 850:	0b3b0b3a 	bleq	ec3540 <__bss_end+0xeb9a00>
 854:	13010b39 	movwne	r0, #6969	; 0x1b39
 858:	28050000 	stmdacs	r5, {}	; <UNPREDICTABLE>
 85c:	1c0e0300 	stcne	3, cr0, [lr], {-0}
 860:	0600000b 	streq	r0, [r0], -fp
 864:	0e030113 	mcreq	1, 0, r0, cr3, cr3, {0}
 868:	0b3a0b0b 	bleq	e8349c <__bss_end+0xe7995c>
 86c:	0b39053b 	bleq	e41d60 <__bss_end+0xe38220>
 870:	00001301 	andeq	r1, r0, r1, lsl #6
 874:	03000d07 	movweq	r0, #3335	; 0xd07
 878:	3b0b3a0e 	blcc	2cf0b8 <__bss_end+0x2c5578>
 87c:	490b3905 	stmdbmi	fp, {r0, r2, r8, fp, ip, sp}
 880:	000b3813 	andeq	r3, fp, r3, lsl r8
 884:	00260800 	eoreq	r0, r6, r0, lsl #16
 888:	00001349 	andeq	r1, r0, r9, asr #6
 88c:	49010109 	stmdbmi	r1, {r0, r3, r8}
 890:	00130113 	andseq	r0, r3, r3, lsl r1
 894:	00210a00 	eoreq	r0, r1, r0, lsl #20
 898:	0b2f1349 	bleq	bc55c4 <__bss_end+0xbbba84>
 89c:	340b0000 	strcc	r0, [fp], #-0
 8a0:	3a0e0300 	bcc	3814a8 <__bss_end+0x377968>
 8a4:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 8a8:	1c13490b 			; <UNDEFINED> instruction: 0x1c13490b
 8ac:	0c00000a 	stceq	0, cr0, [r0], {10}
 8b0:	19270015 	stmdbne	r7!, {r0, r2, r4}
 8b4:	0f0d0000 	svceq	0x000d0000
 8b8:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
 8bc:	0e000013 	mcreq	0, 0, r0, cr0, cr3, {0}
 8c0:	0e030104 	adfeqs	f0, f3, f4
 8c4:	0b0b0b3e 	bleq	2c35c4 <__bss_end+0x2b9a84>
 8c8:	0b3a1349 	bleq	e855f4 <__bss_end+0xe7bab4>
 8cc:	0b39053b 	bleq	e41dc0 <__bss_end+0xe38280>
 8d0:	00001301 	andeq	r1, r0, r1, lsl #6
 8d4:	0300160f 	movweq	r1, #1551	; 0x60f
 8d8:	3b0b3a0e 	blcc	2cf118 <__bss_end+0x2c55d8>
 8dc:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 8e0:	10000013 	andne	r0, r0, r3, lsl r0
 8e4:	00000021 	andeq	r0, r0, r1, lsr #32
 8e8:	03003411 	movweq	r3, #1041	; 0x411
 8ec:	3b0b3a0e 	blcc	2cf12c <__bss_end+0x2c55ec>
 8f0:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 8f4:	3c193f13 	ldccc	15, cr3, [r9], {19}
 8f8:	12000019 	andne	r0, r0, #25
 8fc:	13470034 	movtne	r0, #28724	; 0x7034
 900:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 904:	13490b39 	movtne	r0, #39737	; 0x9b39
 908:	00001802 	andeq	r1, r0, r2, lsl #16
 90c:	01110100 	tsteq	r1, r0, lsl #2
 910:	0b130e25 	bleq	4c41ac <__bss_end+0x4ba66c>
 914:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
 918:	06120111 			; <UNDEFINED> instruction: 0x06120111
 91c:	00001710 	andeq	r1, r0, r0, lsl r7
 920:	0b002402 	bleq	9930 <__aeabi_f2ulz+0x38>
 924:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 928:	0300000e 	movweq	r0, #14
 92c:	0b0b0024 	bleq	2c09c4 <__bss_end+0x2b6e84>
 930:	08030b3e 	stmdaeq	r3, {r1, r2, r3, r4, r5, r8, r9, fp}
 934:	04040000 	streq	r0, [r4], #-0
 938:	3e0e0301 	cdpcc	3, 0, cr0, cr14, cr1, {0}
 93c:	490b0b0b 	stmdbmi	fp, {r0, r1, r3, r8, r9, fp}
 940:	3b0b3a13 	blcc	2cf194 <__bss_end+0x2c5654>
 944:	010b390b 	tsteq	fp, fp, lsl #18
 948:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
 94c:	0e030028 	cdpeq	0, 0, cr0, cr3, cr8, {1}
 950:	00000b1c 	andeq	r0, r0, ip, lsl fp
 954:	03011306 	movweq	r1, #4870	; 0x1306
 958:	3a0b0b0e 	bcc	2c3598 <__bss_end+0x2b9a58>
 95c:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 960:	0013010b 	andseq	r0, r3, fp, lsl #2
 964:	000d0700 	andeq	r0, sp, r0, lsl #14
 968:	0b3a0e03 	bleq	e8417c <__bss_end+0xe7a63c>
 96c:	0b39053b 	bleq	e41e60 <__bss_end+0xe38320>
 970:	0b381349 	bleq	e0569c <__bss_end+0xdfbb5c>
 974:	26080000 	strcs	r0, [r8], -r0
 978:	00134900 	andseq	r4, r3, r0, lsl #18
 97c:	01010900 	tsteq	r1, r0, lsl #18
 980:	13011349 	movwne	r1, #4937	; 0x1349
 984:	210a0000 	mrscs	r0, (UNDEF: 10)
 988:	2f134900 	svccs	0x00134900
 98c:	0b00000b 	bleq	9c0 <shift+0x9c0>
 990:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 994:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 998:	13490b39 	movtne	r0, #39737	; 0x9b39
 99c:	00000a1c 	andeq	r0, r0, ip, lsl sl
 9a0:	0300160c 	movweq	r1, #1548	; 0x60c
 9a4:	3b0b3a0e 	blcc	2cf1e4 <__bss_end+0x2c56a4>
 9a8:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 9ac:	0d000013 	stceq	0, cr0, [r0, #-76]	; 0xffffffb4
 9b0:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 9b4:	0b3a0e03 	bleq	e841c8 <__bss_end+0xe7a688>
 9b8:	0b39053b 	bleq	e41eac <__bss_end+0xe3836c>
 9bc:	13491927 	movtne	r1, #39207	; 0x9927
 9c0:	06120111 			; <UNDEFINED> instruction: 0x06120111
 9c4:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 9c8:	00130119 	andseq	r0, r3, r9, lsl r1
 9cc:	00050e00 	andeq	r0, r5, r0, lsl #28
 9d0:	0b3a0803 	bleq	e829e4 <__bss_end+0xe78ea4>
 9d4:	0b39053b 	bleq	e41ec8 <__bss_end+0xe38388>
 9d8:	17021349 	strne	r1, [r2, -r9, asr #6]
 9dc:	001742b7 			; <UNDEFINED> instruction: 0x001742b7
 9e0:	82890f00 	addhi	r0, r9, #0, 30
 9e4:	01110101 	tsteq	r1, r1, lsl #2
 9e8:	31194295 			; <UNDEFINED> instruction: 0x31194295
 9ec:	00130113 	andseq	r0, r3, r3, lsl r1
 9f0:	828a1000 	addhi	r1, sl, #0
 9f4:	18020001 	stmdane	r2, {r0}
 9f8:	00184291 	mulseq	r8, r1, r2
 9fc:	82891100 	addhi	r1, r9, #0, 2
 a00:	01110101 	tsteq	r1, r1, lsl #2
 a04:	00001331 	andeq	r1, r0, r1, lsr r3
 a08:	3f002e12 	svccc	0x00002e12
 a0c:	6e193c19 	mrcvs	12, 0, r3, cr9, cr9, {0}
 a10:	3a0e030e 	bcc	381650 <__bss_end+0x377b10>
 a14:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 a18:	0000000b 	andeq	r0, r0, fp
 a1c:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
 a20:	030b130e 	movweq	r1, #45838	; 0xb30e
 a24:	110e1b0e 	tstne	lr, lr, lsl #22
 a28:	10061201 	andne	r1, r6, r1, lsl #4
 a2c:	02000017 	andeq	r0, r0, #23
 a30:	0b0b0024 	bleq	2c0ac8 <__bss_end+0x2b6f88>
 a34:	0e030b3e 	vmoveq.16	d3[0], r0
 a38:	24030000 	strcs	r0, [r3], #-0
 a3c:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 a40:	0008030b 	andeq	r0, r8, fp, lsl #6
 a44:	01040400 	tsteq	r4, r0, lsl #8
 a48:	0b3e0e03 	bleq	f8425c <__bss_end+0xf7a71c>
 a4c:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 a50:	0b3b0b3a 	bleq	ec3740 <__bss_end+0xeb9c00>
 a54:	13010b39 	movwne	r0, #6969	; 0x1b39
 a58:	28050000 	stmdacs	r5, {}	; <UNPREDICTABLE>
 a5c:	1c0e0300 	stcne	3, cr0, [lr], {-0}
 a60:	0600000b 	streq	r0, [r0], -fp
 a64:	0e030113 	mcreq	1, 0, r0, cr3, cr3, {0}
 a68:	0b3a0b0b 	bleq	e8369c <__bss_end+0xe79b5c>
 a6c:	0b39053b 	bleq	e41f60 <__bss_end+0xe38420>
 a70:	00001301 	andeq	r1, r0, r1, lsl #6
 a74:	03000d07 	movweq	r0, #3335	; 0xd07
 a78:	3b0b3a0e 	blcc	2cf2b8 <__bss_end+0x2c5778>
 a7c:	490b3905 	stmdbmi	fp, {r0, r2, r8, fp, ip, sp}
 a80:	000b3813 	andeq	r3, fp, r3, lsl r8
 a84:	00260800 	eoreq	r0, r6, r0, lsl #16
 a88:	00001349 	andeq	r1, r0, r9, asr #6
 a8c:	49010109 	stmdbmi	r1, {r0, r3, r8}
 a90:	00130113 	andseq	r0, r3, r3, lsl r1
 a94:	00210a00 	eoreq	r0, r1, r0, lsl #20
 a98:	0b2f1349 	bleq	bc57c4 <__bss_end+0xbbbc84>
 a9c:	340b0000 	strcc	r0, [fp], #-0
 aa0:	3a0e0300 	bcc	3816a8 <__bss_end+0x377b68>
 aa4:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 aa8:	1c13490b 			; <UNDEFINED> instruction: 0x1c13490b
 aac:	0c00000a 	stceq	0, cr0, [r0], {10}
 ab0:	0e030016 	mcreq	0, 0, r0, cr3, cr6, {0}
 ab4:	0b3b0b3a 	bleq	ec37a4 <__bss_end+0xeb9c64>
 ab8:	13490b39 	movtne	r0, #39737	; 0x9b39
 abc:	2e0d0000 	cdpcs	0, 0, cr0, cr13, cr0, {0}
 ac0:	03193f01 	tsteq	r9, #1, 30
 ac4:	3b0b3a0e 	blcc	2cf304 <__bss_end+0x2c57c4>
 ac8:	270b3905 	strcs	r3, [fp, -r5, lsl #18]
 acc:	11134919 	tstne	r3, r9, lsl r9
 ad0:	40061201 	andmi	r1, r6, r1, lsl #4
 ad4:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
 ad8:	050e0000 	streq	r0, [lr, #-0]
 adc:	3a080300 	bcc	2016e4 <__bss_end+0x1f7ba4>
 ae0:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 ae4:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 ae8:	1742b717 	smlaldne	fp, r2, r7, r7
 aec:	340f0000 	strcc	r0, [pc], #-0	; af4 <shift+0xaf4>
 af0:	3a080300 	bcc	2016f8 <__bss_end+0x1f7bb8>
 af4:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 af8:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 afc:	1742b717 	smlaldne	fp, r2, r7, r7
 b00:	01000000 	mrseq	r0, (UNDEF: 0)
 b04:	0e250111 	mcreq	1, 1, r0, cr5, cr1, {0}
 b08:	0e030b13 	vmoveq.32	d3[0], r0
 b0c:	01110e1b 	tsteq	r1, fp, lsl lr
 b10:	17100612 			; <UNDEFINED> instruction: 0x17100612
 b14:	24020000 	strcs	r0, [r2], #-0
 b18:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 b1c:	000e030b 	andeq	r0, lr, fp, lsl #6
 b20:	00240300 	eoreq	r0, r4, r0, lsl #6
 b24:	0b3e0b0b 	bleq	f83758 <__bss_end+0xf79c18>
 b28:	00000803 	andeq	r0, r0, r3, lsl #16
 b2c:	03010404 	movweq	r0, #5124	; 0x1404
 b30:	0b0b3e0e 	bleq	2d0370 <__bss_end+0x2c6830>
 b34:	3a13490b 	bcc	4d2f68 <__bss_end+0x4c9428>
 b38:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 b3c:	0013010b 	andseq	r0, r3, fp, lsl #2
 b40:	00280500 	eoreq	r0, r8, r0, lsl #10
 b44:	0b1c0e03 	bleq	704358 <__bss_end+0x6fa818>
 b48:	13060000 	movwne	r0, #24576	; 0x6000
 b4c:	0b0e0301 	bleq	381758 <__bss_end+0x377c18>
 b50:	3b0b3a0b 	blcc	2cf384 <__bss_end+0x2c5844>
 b54:	010b3905 	tsteq	fp, r5, lsl #18
 b58:	07000013 	smladeq	r0, r3, r0, r0
 b5c:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
 b60:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 b64:	13490b39 	movtne	r0, #39737	; 0x9b39
 b68:	00000b38 	andeq	r0, r0, r8, lsr fp
 b6c:	49002608 	stmdbmi	r0, {r3, r9, sl, sp}
 b70:	09000013 	stmdbeq	r0, {r0, r1, r4}
 b74:	13490101 	movtne	r0, #37121	; 0x9101
 b78:	00001301 	andeq	r1, r0, r1, lsl #6
 b7c:	4900210a 	stmdbmi	r0, {r1, r3, r8, sp}
 b80:	000b2f13 	andeq	r2, fp, r3, lsl pc
 b84:	00340b00 	eorseq	r0, r4, r0, lsl #22
 b88:	0b3a0e03 	bleq	e8439c <__bss_end+0xe7a85c>
 b8c:	0b39053b 	bleq	e42080 <__bss_end+0xe38540>
 b90:	0a1c1349 	beq	7058bc <__bss_end+0x6fbd7c>
 b94:	160c0000 	strne	r0, [ip], -r0
 b98:	3a0e0300 	bcc	3817a0 <__bss_end+0x377c60>
 b9c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 ba0:	0013490b 	andseq	r4, r3, fp, lsl #18
 ba4:	012e0d00 			; <UNDEFINED> instruction: 0x012e0d00
 ba8:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 bac:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 bb0:	19270b39 	stmdbne	r7!, {r0, r3, r4, r5, r8, r9, fp}
 bb4:	01111349 	tsteq	r1, r9, asr #6
 bb8:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 bbc:	01194297 			; <UNDEFINED> instruction: 0x01194297
 bc0:	0e000013 	mcreq	0, 0, r0, cr0, cr3, {0}
 bc4:	08030005 	stmdaeq	r3, {r0, r2}
 bc8:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 bcc:	13490b39 	movtne	r0, #39737	; 0x9b39
 bd0:	42b71702 	adcsmi	r1, r7, #524288	; 0x80000
 bd4:	0f000017 	svceq	0x00000017
 bd8:	08030005 	stmdaeq	r3, {r0, r2}
 bdc:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 be0:	13490b39 	movtne	r0, #39737	; 0x9b39
 be4:	00001802 	andeq	r1, r0, r2, lsl #16
 be8:	03003410 	movweq	r3, #1040	; 0x410
 bec:	3b0b3a08 	blcc	2cf414 <__bss_end+0x2c58d4>
 bf0:	490b3905 	stmdbmi	fp, {r0, r2, r8, fp, ip, sp}
 bf4:	b7170213 			; <UNDEFINED> instruction: 0xb7170213
 bf8:	00001742 	andeq	r1, r0, r2, asr #14
 bfc:	0b000f11 	bleq	4848 <shift+0x4848>
 c00:	0013490b 	andseq	r4, r3, fp, lsl #18
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
  74:	000000dc 	ldrdeq	r0, [r0], -ip
	...
  80:	0000001c 	andeq	r0, r0, ip, lsl r0
  84:	0b800002 	bleq	fe000094 <__bss_end+0xfdff6554>
  88:	00040000 	andeq	r0, r4, r0
  8c:	00000000 	andeq	r0, r0, r0
  90:	00008308 	andeq	r8, r0, r8, lsl #6
  94:	0000045c 	andeq	r0, r0, ip, asr r4
	...
  a0:	0000001c 	andeq	r0, r0, ip, lsl r0
  a4:	17150002 	ldrne	r0, [r5, -r2]
  a8:	00040000 	andeq	r0, r4, r0
  ac:	00000000 	andeq	r0, r0, r0
  b0:	00008768 	andeq	r8, r0, r8, ror #14
  b4:	00000c2c 	andeq	r0, r0, ip, lsr #24
	...
  c0:	0000001c 	andeq	r0, r0, ip, lsl r0
  c4:	1d460002 	stclne	0, cr0, [r6, #-8]
  c8:	00040000 	andeq	r0, r4, r0
  cc:	00000000 	andeq	r0, r0, r0
  d0:	00009394 	muleq	r0, r4, r3
  d4:	0000020c 	andeq	r0, r0, ip, lsl #4
	...
  e0:	0000001c 	andeq	r0, r0, ip, lsl r0
  e4:	1d6c0002 	stclne	0, cr0, [ip, #-8]!
  e8:	00040000 	andeq	r0, r4, r0
  ec:	00000000 	andeq	r0, r0, r0
  f0:	000095a0 	andeq	r9, r0, r0, lsr #11
  f4:	00000004 	andeq	r0, r0, r4
	...
 100:	0000001c 	andeq	r0, r0, ip, lsl r0
 104:	1d920002 	ldcne	0, cr0, [r2, #8]
 108:	00040000 	andeq	r0, r4, r0
 10c:	00000000 	andeq	r0, r0, r0
 110:	000095a4 	andeq	r9, r0, r4, lsr #11
 114:	00000250 	andeq	r0, r0, r0, asr r2
	...
 120:	0000001c 	andeq	r0, r0, ip, lsl r0
 124:	1db80002 	ldcne	0, cr0, [r8, #8]!
 128:	00040000 	andeq	r0, r4, r0
 12c:	00000000 	andeq	r0, r0, r0
 130:	000097f4 	strdeq	r9, [r0], -r4
 134:	000000d4 	ldrdeq	r0, [r0], -r4
	...
 140:	00000014 	andeq	r0, r0, r4, lsl r0
 144:	1dde0002 	ldclne	0, cr0, [lr, #8]
 148:	00040000 	andeq	r0, r4, r0
	...
 158:	0000001c 	andeq	r0, r0, ip, lsl r0
 15c:	210c0002 	tstcs	ip, r2
 160:	00040000 	andeq	r0, r4, r0
 164:	00000000 	andeq	r0, r0, r0
 168:	000098c8 	andeq	r9, r0, r8, asr #17
 16c:	00000030 	andeq	r0, r0, r0, lsr r0
	...
 178:	0000001c 	andeq	r0, r0, ip, lsl r0
 17c:	24160002 	ldrcs	r0, [r6], #-2
 180:	00040000 	andeq	r0, r4, r0
 184:	00000000 	andeq	r0, r0, r0
 188:	000098f8 	strdeq	r9, [r0], -r8
 18c:	00000040 	andeq	r0, r0, r0, asr #32
	...
 198:	0000001c 	andeq	r0, r0, ip, lsl r0
 19c:	27440002 	strbcs	r0, [r4, -r2]
 1a0:	00040000 	andeq	r0, r4, r0
 1a4:	00000000 	andeq	r0, r0, r0
 1a8:	00009938 	andeq	r9, r0, r8, lsr r9
 1ac:	00000120 	andeq	r0, r0, r0, lsr #2
	...

Disassembly of section .debug_str:

00000000 <.debug_str>:
       0:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; ffffff4c <__bss_end+0xffff640c>
       4:	72742f65 	rsbsvc	r2, r4, #404	; 0x194
       8:	6c696665 	stclvs	6, cr6, [r9], #-404	; 0xfffffe6c
       c:	6d65732f 	stclvs	3, cr7, [r5, #-188]!	; 0xffffff44
      10:	756f732f 	strbvc	r7, [pc, #-815]!	; fffffce9 <__bss_end+0xffff61a9>
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
      40:	752f7365 	strvc	r7, [pc, #-869]!	; fffffce3 <__bss_end+0xffff61a3>
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
      dc:	2b6b7a36 	blcs	1ade9bc <__bss_end+0x1ad4e7c>
      e0:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
      e4:	672d2067 	strvs	r2, [sp, -r7, rrx]!
      e8:	304f2d20 	subcc	r2, pc, r0, lsr #26
      ec:	304f2d20 	subcc	r2, pc, r0, lsr #26
      f0:	625f5f00 	subsvs	r5, pc, #0, 30
      f4:	655f7373 	ldrbvs	r7, [pc, #-883]	; fffffd89 <__bss_end+0xffff6249>
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
     160:	755f6962 	ldrbvc	r6, [pc, #-2402]	; fffff806 <__bss_end+0xffff5cc6>
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
     260:	2b432055 	blcs	10c83bc <__bss_end+0x10be87c>
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
     2c4:	7a6a3637 	bvc	1a8dba8 <__bss_end+0x1a84068>
     2c8:	20732d66 	rsbscs	r2, r3, r6, ror #26
     2cc:	72616d2d 	rsbvc	r6, r1, #2880	; 0xb40
     2d0:	6d2d206d 	stcvs	0, cr2, [sp, #-436]!	; 0xfffffe4c
     2d4:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
     2d8:	6d72613d 	ldfvse	f6, [r2, #-244]!	; 0xffffff0c
     2dc:	6b7a3676 	blvs	1e8dcbc <__bss_end+0x1e8417c>
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
     334:	54006572 	strpl	r6, [r0], #-1394	; 0xfffffa8e
     338:	5f6b6369 	svcpl	0x006b6369
     33c:	6e756f43 	cdpvs	15, 7, cr6, cr5, cr3, {2}
     340:	6e490074 	mcrvs	0, 2, r0, cr9, cr4, {3}
     344:	69666564 	stmdbvs	r6!, {r2, r5, r6, r8, sl, sp, lr}^
     348:	6574696e 	ldrbvs	r6, [r4, #-2414]!	; 0xfffff692
     34c:	65704f00 	ldrbvs	r4, [r0, #-3840]!	; 0xfffff100
     350:	5a5f006e 	bpl	17c0510 <__bss_end+0x17b69d0>
     354:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     358:	636f7250 	cmnvs	pc, #80, 4
     35c:	5f737365 	svcpl	0x00737365
     360:	616e614d 	cmnvs	lr, sp, asr #2
     364:	32726567 	rsbscc	r6, r2, #432013312	; 0x19c00000
     368:	6f6c4231 	svcvs	0x006c4231
     36c:	435f6b63 	cmpmi	pc, #101376	; 0x18c00
     370:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
     374:	505f746e 	subspl	r7, pc, lr, ror #8
     378:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     37c:	76457373 			; <UNDEFINED> instruction: 0x76457373
     380:	65727000 	ldrbvs	r7, [r2, #-0]!
     384:	5a5f0076 	bpl	17c0564 <__bss_end+0x17b6a24>
     388:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     38c:	636f7250 	cmnvs	pc, #80, 4
     390:	5f737365 	svcpl	0x00737365
     394:	616e614d 	cmnvs	lr, sp, asr #2
     398:	31726567 	cmncc	r2, r7, ror #10
     39c:	746f4e34 	strbtvc	r4, [pc], #-3636	; 3a4 <shift+0x3a4>
     3a0:	5f796669 	svcpl	0x00796669
     3a4:	636f7250 	cmnvs	pc, #80, 4
     3a8:	45737365 	ldrbmi	r7, [r3, #-869]!	; 0xfffffc9b
     3ac:	54323150 	ldrtpl	r3, [r2], #-336	; 0xfffffeb0
     3b0:	6b736154 	blvs	1cd8908 <__bss_end+0x1ccedc8>
     3b4:	7274535f 	rsbsvc	r5, r4, #2080374785	; 0x7c000001
     3b8:	00746375 	rsbseq	r6, r4, r5, ror r3
     3bc:	616d6e55 	cmnvs	sp, r5, asr lr
     3c0:	69465f70 	stmdbvs	r6, {r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     3c4:	435f656c 	cmpmi	pc, #108, 10	; 0x1b000000
     3c8:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
     3cc:	4200746e 	andmi	r7, r0, #1845493760	; 0x6e000000
     3d0:	5f324353 	svcpl	0x00324353
     3d4:	65736142 	ldrbvs	r6, [r3, #-322]!	; 0xfffffebe
     3d8:	6c614d00 	stclvs	13, cr4, [r1], #-0
     3dc:	00636f6c 	rsbeq	r6, r3, ip, ror #30
     3e0:	6f72506d 	svcvs	0x0072506d
     3e4:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     3e8:	73694c5f 	cmnvc	r9, #24320	; 0x5f00
     3ec:	65485f74 	strbvs	r5, [r8, #-3956]	; 0xfffff08c
     3f0:	5f006461 	svcpl	0x00006461
     3f4:	314b4e5a 	cmpcc	fp, sl, asr lr
     3f8:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     3fc:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     400:	614d5f73 	hvcvs	54771	; 0xd5f3
     404:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     408:	47393172 			; <UNDEFINED> instruction: 0x47393172
     40c:	435f7465 	cmpmi	pc, #1694498816	; 0x65000000
     410:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
     414:	505f746e 	subspl	r7, pc, lr, ror #8
     418:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     41c:	76457373 			; <UNDEFINED> instruction: 0x76457373
     420:	78656e00 	stmdavc	r5!, {r9, sl, fp, sp, lr}^
     424:	6c6f0074 	stclvs	0, cr0, [pc], #-464	; 25c <shift+0x25c>
     428:	61747364 	cmnvs	r4, r4, ror #6
     42c:	47006574 	smlsdxmi	r0, r4, r5, r6
     430:	505f7465 	subspl	r7, pc, r5, ror #8
     434:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     438:	425f7373 	subsmi	r7, pc, #-872415231	; 0xcc000001
     43c:	49505f79 	ldmdbmi	r0, {r0, r3, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     440:	65520044 	ldrbvs	r0, [r2, #-68]	; 0xffffffbc
     444:	41006461 	tstmi	r0, r1, ror #8
     448:	76697463 	strbtvc	r7, [r9], -r3, ror #8
     44c:	72505f65 	subsvc	r5, r0, #404	; 0x194
     450:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     454:	6f435f73 	svcvs	0x00435f73
     458:	00746e75 	rsbseq	r6, r4, r5, ror lr
     45c:	61657243 	cmnvs	r5, r3, asr #4
     460:	505f6574 	subspl	r6, pc, r4, ror r5	; <UNPREDICTABLE>
     464:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     468:	4d007373 	stcmi	3, cr7, [r0, #-460]	; 0xfffffe34
     46c:	69467861 	stmdbvs	r6, {r0, r5, r6, fp, ip, sp, lr}^
     470:	616e656c 	cmnvs	lr, ip, ror #10
     474:	654c656d 	strbvs	r6, [ip, #-1389]	; 0xfffffa93
     478:	6874676e 	ldmdavs	r4!, {r1, r2, r3, r5, r6, r8, r9, sl, sp, lr}^
     47c:	58554100 	ldmdapl	r5, {r8, lr}^
     480:	7361425f 	cmnvc	r1, #-268435451	; 0xf0000005
     484:	65470065 	strbvs	r0, [r7, #-101]	; 0xffffff9b
     488:	63535f74 	cmpvs	r3, #116, 30	; 0x1d0
     48c:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
     490:	5f72656c 	svcpl	0x0072656c
     494:	6f666e49 	svcvs	0x00666e49
     498:	61654400 	cmnvs	r5, r0, lsl #8
     49c:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
     4a0:	6e555f65 	cdpvs	15, 5, cr5, cr5, cr5, {3}
     4a4:	6e616863 	cdpvs	8, 6, cr6, cr1, cr3, {3}
     4a8:	00646567 	rsbeq	r6, r4, r7, ror #10
     4ac:	6f725043 	svcvs	0x00725043
     4b0:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     4b4:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     4b8:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     4bc:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     4c0:	50433631 	subpl	r3, r3, r1, lsr r6
     4c4:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     4c8:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 304 <shift+0x304>
     4cc:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     4d0:	38317265 	ldmdacc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
     4d4:	5f746547 	svcpl	0x00746547
     4d8:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     4dc:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
     4e0:	6e495f72 	mcrvs	15, 2, r5, cr9, cr2, {3}
     4e4:	32456f66 	subcc	r6, r5, #408	; 0x198
     4e8:	65474e30 	strbvs	r4, [r7, #-3632]	; 0xfffff1d0
     4ec:	63535f74 	cmpvs	r3, #116, 30	; 0x1d0
     4f0:	5f646568 	svcpl	0x00646568
     4f4:	6f666e49 	svcvs	0x00666e49
     4f8:	7079545f 	rsbsvc	r5, r9, pc, asr r4
     4fc:	00765065 	rsbseq	r5, r6, r5, rrx
     500:	69736952 	ldmdbvs	r3!, {r1, r4, r6, r8, fp, sp, lr}^
     504:	455f676e 	ldrbmi	r6, [pc, #-1902]	; fffffd9e <__bss_end+0xffff625e>
     508:	00656764 	rsbeq	r6, r5, r4, ror #14
     50c:	314e5a5f 	cmpcc	lr, pc, asr sl
     510:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     514:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     518:	614d5f73 	hvcvs	54771	; 0xd5f3
     51c:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     520:	48313272 	ldmdami	r1!, {r1, r4, r5, r6, r9, ip, sp}
     524:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     528:	69465f65 	stmdbvs	r6, {r0, r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     52c:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
     530:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
     534:	4957535f 	ldmdbmi	r7, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     538:	4e333245 	cdpmi	2, 3, cr3, cr3, cr5, {2}
     53c:	5f495753 	svcpl	0x00495753
     540:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     544:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
     548:	535f6d65 	cmppl	pc, #6464	; 0x1940
     54c:	69767265 	ldmdbvs	r6!, {r0, r2, r5, r6, r9, ip, sp, lr}^
     550:	6a6a6563 	bvs	1a99ae4 <__bss_end+0x1a8ffa4>
     554:	3131526a 	teqcc	r1, sl, ror #4
     558:	49575354 	ldmdbmi	r7, {r2, r4, r6, r8, r9, ip, lr}^
     55c:	7365525f 	cmnvc	r5, #-268435451	; 0xf0000005
     560:	00746c75 	rsbseq	r6, r4, r5, ror ip
     564:	6c6c6146 	stfvse	f6, [ip], #-280	; 0xfffffee8
     568:	5f676e69 	svcpl	0x00676e69
     56c:	65676445 	strbvs	r6, [r7, #-1093]!	; 0xfffffbbb
     570:	65706f00 	ldrbvs	r6, [r0, #-3840]!	; 0xfffff100
     574:	5f64656e 	svcpl	0x0064656e
     578:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
     57c:	6f4e0073 	svcvs	0x004e0073
     580:	79666974 	stmdbvc	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
     584:	006c6c41 	rsbeq	r6, ip, r1, asr #24
     588:	55504354 	ldrbpl	r4, [r0, #-852]	; 0xfffffcac
     58c:	6e6f435f 	mcrvs	3, 3, r4, cr15, cr15, {2}
     590:	74786574 	ldrbtvc	r6, [r8], #-1396	; 0xfffffa8c
     594:	61654400 	cmnvs	r5, r0, lsl #8
     598:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
     59c:	74740065 	ldrbtvc	r0, [r4], #-101	; 0xffffff9b
     5a0:	00307262 	eorseq	r7, r0, r2, ror #4
     5a4:	314e5a5f 	cmpcc	lr, pc, asr sl
     5a8:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     5ac:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     5b0:	614d5f73 	hvcvs	54771	; 0xd5f3
     5b4:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     5b8:	4e343172 	mrcmi	1, 1, r3, cr4, cr2, {3}
     5bc:	6669746f 	strbtvs	r7, [r9], -pc, ror #8
     5c0:	72505f79 	subsvc	r5, r0, #484	; 0x1e4
     5c4:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     5c8:	006a4573 	rsbeq	r4, sl, r3, ror r5
     5cc:	5f746547 	svcpl	0x00746547
     5d0:	00444950 	subeq	r4, r4, r0, asr r9
     5d4:	30435342 	subcc	r5, r3, r2, asr #6
     5d8:	7361425f 	cmnvc	r1, #-268435451	; 0xf0000005
     5dc:	534e0065 	movtpl	r0, #57445	; 0xe065
     5e0:	505f4957 	subspl	r4, pc, r7, asr r9	; <UNPREDICTABLE>
     5e4:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     5e8:	535f7373 	cmppl	pc, #-872415231	; 0xcc000001
     5ec:	69767265 	ldmdbvs	r6!, {r0, r2, r5, r6, r9, ip, sp, lr}^
     5f0:	6e006563 	cfsh32vs	mvfx6, mvfx0, #51
     5f4:	6669746f 	strbtvs	r7, [r9], -pc, ror #8
     5f8:	5f646569 	svcpl	0x00646569
     5fc:	64616564 	strbtvs	r6, [r1], #-1380	; 0xfffffa9c
     600:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
     604:	746e4900 	strbtvc	r4, [lr], #-2304	; 0xfffff700
     608:	75727265 	ldrbvc	r7, [r2, #-613]!	; 0xfffffd9b
     60c:	435f7470 	cmpmi	pc, #112, 8	; 0x70000000
     610:	72746e6f 	rsbsvc	r6, r4, #1776	; 0x6f0
     614:	656c6c6f 	strbvs	r6, [ip, #-3183]!	; 0xfffff391
     618:	61425f72 	hvcvs	9714	; 0x25f2
     61c:	42006573 	andmi	r6, r0, #482344960	; 0x1cc00000
     620:	5f314353 	svcpl	0x00314353
     624:	65736142 	ldrbvs	r6, [r3, #-322]!	; 0xfffffebe
     628:	78614d00 	stmdavc	r1!, {r8, sl, fp, lr}^
     62c:	6f72505f 	svcvs	0x0072505f
     630:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     634:	65704f5f 	ldrbvs	r4, [r0, #-3935]!	; 0xfffff0a1
     638:	5f64656e 	svcpl	0x0064656e
     63c:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     640:	5a5f0073 	bpl	17c0814 <__bss_end+0x17b6cd4>
     644:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     648:	636f7250 	cmnvs	pc, #80, 4
     64c:	5f737365 	svcpl	0x00737365
     650:	616e614d 	cmnvs	lr, sp, asr #2
     654:	31726567 	cmncc	r2, r7, ror #10
     658:	6d6e5538 	cfstr64vs	mvdx5, [lr, #-224]!	; 0xffffff20
     65c:	465f7061 	ldrbmi	r7, [pc], -r1, rrx
     660:	5f656c69 	svcpl	0x00656c69
     664:	72727543 	rsbsvc	r7, r2, #281018368	; 0x10c00000
     668:	45746e65 	ldrbmi	r6, [r4, #-3685]!	; 0xfffff19b
     66c:	5254006a 	subspl	r0, r4, #106	; 0x6a
     670:	425f474e 	subsmi	r4, pc, #20447232	; 0x1380000
     674:	00657361 	rsbeq	r7, r5, r1, ror #6
     678:	68676948 	stmdavs	r7!, {r3, r6, r8, fp, sp, lr}^
     67c:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     680:	50433631 	subpl	r3, r3, r1, lsr r6
     684:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     688:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 4c4 <shift+0x4c4>
     68c:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     690:	32317265 	eorscc	r7, r1, #1342177286	; 0x50000006
     694:	466e7552 			; <UNDEFINED> instruction: 0x466e7552
     698:	74737269 	ldrbtvc	r7, [r3], #-617	; 0xfffffd97
     69c:	6b736154 	blvs	1cd8bf4 <__bss_end+0x1ccf0b4>
     6a0:	47007645 	strmi	r7, [r0, -r5, asr #12]
     6a4:	435f7465 	cmpmi	pc, #1694498816	; 0x65000000
     6a8:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
     6ac:	505f746e 	subspl	r7, pc, lr, ror #8
     6b0:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     6b4:	4d007373 	stcmi	3, cr7, [r0, #-460]	; 0xfffffe34
     6b8:	465f7061 	ldrbmi	r7, [pc], -r1, rrx
     6bc:	5f656c69 	svcpl	0x00656c69
     6c0:	435f6f54 	cmpmi	pc, #84, 30	; 0x150
     6c4:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
     6c8:	4200746e 	andmi	r7, r0, #1845493760	; 0x6e000000
     6cc:	6b636f6c 	blvs	18dc484 <__bss_end+0x18d2944>
     6d0:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
     6d4:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     6d8:	6f72505f 	svcvs	0x0072505f
     6dc:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     6e0:	466f4e00 	strbtmi	r4, [pc], -r0, lsl #28
     6e4:	73656c69 	cmnvc	r5, #26880	; 0x6900
     6e8:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     6ec:	6972446d 	ldmdbvs	r2!, {r0, r2, r3, r5, r6, sl, lr}^
     6f0:	00726576 	rsbseq	r6, r2, r6, ror r5
     6f4:	5f746553 	svcpl	0x00746553
     6f8:	61726150 	cmnvs	r2, r0, asr r1
     6fc:	6c00736d 	stcvs	3, cr7, [r0], {109}	; 0x6d
     700:	6369676f 	cmnvs	r9, #29097984	; 0x1bc0000
     704:	625f6c61 	subsvs	r6, pc, #24832	; 0x6100
     708:	6b616572 	blvs	1859cd8 <__bss_end+0x1850198>
     70c:	6e614800 	cdpvs	8, 6, cr4, cr1, cr0, {0}
     710:	5f656c64 	svcpl	0x00656c64
     714:	636f7250 	cmnvs	pc, #80, 4
     718:	5f737365 	svcpl	0x00737365
     71c:	00495753 	subeq	r5, r9, r3, asr r7
     720:	726f6873 	rsbvc	r6, pc, #7536640	; 0x730000
     724:	6e752074 	mrcvs	0, 3, r2, cr5, cr4, {3}
     728:	6e676973 			; <UNDEFINED> instruction: 0x6e676973
     72c:	69206465 	stmdbvs	r0!, {r0, r2, r5, r6, sl, sp, lr}
     730:	5300746e 	movwpl	r7, #1134	; 0x46e
     734:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     738:	5f656c75 	svcpl	0x00656c75
     73c:	00464445 	subeq	r4, r6, r5, asr #8
     740:	74696157 	strbtvc	r6, [r9], #-343	; 0xfffffea9
     744:	73694400 	cmnvc	r9, #0, 8
     748:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
     74c:	6576455f 	ldrbvs	r4, [r6, #-1375]!	; 0xfffffaa1
     750:	445f746e 	ldrbmi	r7, [pc], #-1134	; 758 <shift+0x758>
     754:	63657465 	cmnvs	r5, #1694498816	; 0x65000000
     758:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     75c:	746e4900 	strbtvc	r4, [lr], #-2304	; 0xfffff700
     760:	75727265 	ldrbvc	r7, [r2, #-613]!	; 0xfffffd9b
     764:	62617470 	rsbvs	r7, r1, #112, 8	; 0x70000000
     768:	535f656c 	cmppl	pc, #108, 10	; 0x1b000000
     76c:	7065656c 	rsbvc	r6, r5, ip, ror #10
     770:	6f6f6200 	svcvs	0x006f6200
     774:	4c6d006c 	stclmi	0, cr0, [sp], #-432	; 0xfffffe50
     778:	5f747361 	svcpl	0x00747361
     77c:	00444950 	subeq	r4, r4, r0, asr r9
     780:	636f6c42 	cmnvs	pc, #16896	; 0x4200
     784:	0064656b 	rsbeq	r6, r4, fp, ror #10
     788:	7465474e 	strbtvc	r4, [r5], #-1870	; 0xfffff8b2
     78c:	6863535f 	stmdavs	r3!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     790:	495f6465 	ldmdbmi	pc, {r0, r2, r5, r6, sl, sp, lr}^	; <UNPREDICTABLE>
     794:	5f6f666e 	svcpl	0x006f666e
     798:	65707954 	ldrbvs	r7, [r0, #-2388]!	; 0xfffff6ac
     79c:	6e755200 	cdpvs	2, 7, cr5, cr5, cr0, {0}
     7a0:	6c62616e 	stfvse	f6, [r2], #-440	; 0xfffffe48
     7a4:	544e0065 	strbpl	r0, [lr], #-101	; 0xffffff9b
     7a8:	5f6b7361 	svcpl	0x006b7361
     7ac:	74617453 	strbtvc	r7, [r1], #-1107	; 0xfffffbad
     7b0:	63730065 	cmnvs	r3, #101	; 0x65
     7b4:	5f646568 	svcpl	0x00646568
     7b8:	6e756f63 	cdpvs	15, 7, cr6, cr5, cr3, {3}
     7bc:	00726574 	rsbseq	r6, r2, r4, ror r5
     7c0:	65686373 	strbvs	r6, [r8, #-883]!	; 0xfffffc8d
     7c4:	74735f64 	ldrbtvc	r5, [r3], #-3940	; 0xfffff09c
     7c8:	63697461 	cmnvs	r9, #1627389952	; 0x61000000
     7cc:	6972705f 	ldmdbvs	r2!, {r0, r1, r2, r3, r4, r6, ip, sp, lr}^
     7d0:	7469726f 	strbtvc	r7, [r9], #-623	; 0xfffffd91
     7d4:	78650079 	stmdavc	r5!, {r0, r3, r4, r5, r6}^
     7d8:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
     7dc:	0065646f 	rsbeq	r6, r5, pc, ror #8
     7e0:	314e5a5f 	cmpcc	lr, pc, asr sl
     7e4:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     7e8:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     7ec:	614d5f73 	hvcvs	54771	; 0xd5f3
     7f0:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     7f4:	62533472 	subsvs	r3, r3, #1912602624	; 0x72000000
     7f8:	6a456b72 	bvs	115b5c8 <__bss_end+0x1151a88>
     7fc:	766e4900 	strbtvc	r4, [lr], -r0, lsl #18
     800:	64696c61 	strbtvs	r6, [r9], #-3169	; 0xfffff39f
     804:	6e69505f 	mcrvs	0, 3, r5, cr9, cr15, {2}
     808:	63536d00 	cmpvs	r3, #0, 26
     80c:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
     810:	465f656c 	ldrbmi	r6, [pc], -ip, ror #10
     814:	4700636e 	strmi	r6, [r0, -lr, ror #6]
     818:	5f4f4950 	svcpl	0x004f4950
     81c:	65736142 	ldrbvs	r6, [r3, #-322]!	; 0xfffffebe
     820:	78614d00 	stmdavc	r1!, {r8, sl, fp, lr}^
     824:	72445346 	subvc	r5, r4, #402653185	; 0x18000001
     828:	72657669 	rsbvc	r7, r5, #110100480	; 0x6900000
     82c:	656d614e 	strbvs	r6, [sp, #-334]!	; 0xfffffeb2
     830:	676e654c 	strbvs	r6, [lr, -ip, asr #10]!
     834:	4e006874 	mcrmi	8, 0, r6, cr0, cr4, {3}
     838:	6669746f 	strbtvs	r7, [r9], -pc, ror #8
     83c:	65440079 	strbvs	r0, [r4, #-121]	; 0xffffff87
     840:	6c756166 	ldfvse	f6, [r5], #-408	; 0xfffffe68
     844:	6c435f74 	mcrrvs	15, 7, r5, r3, cr4
     848:	5f6b636f 	svcpl	0x006b636f
     84c:	65746152 	ldrbvs	r6, [r4, #-338]!	; 0xfffffeae
     850:	6e755200 	cdpvs	2, 7, cr5, cr5, cr0, {0}
     854:	73726946 	cmnvc	r2, #1146880	; 0x118000
     858:	73615474 	cmnvc	r1, #116, 8	; 0x74000000
     85c:	6f4c006b 	svcvs	0x004c006b
     860:	555f6b63 	ldrbpl	r6, [pc, #-2915]	; fffffd05 <__bss_end+0xffff61c5>
     864:	636f6c6e 	cmnvs	pc, #28160	; 0x6e00
     868:	0064656b 	rsbeq	r6, r4, fp, ror #10
     86c:	6b636f4c 	blvs	18dc5a4 <__bss_end+0x18d2a64>
     870:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
     874:	0064656b 	rsbeq	r6, r4, fp, ror #10
     878:	73796870 	cmnvc	r9, #112, 16	; 0x700000
     87c:	6c616369 	stclvs	3, cr6, [r1], #-420	; 0xfffffe5c
     880:	6572625f 	ldrbvs	r6, [r2, #-607]!	; 0xfffffda1
     884:	52006b61 	andpl	r6, r0, #99328	; 0x18400
     888:	5f646165 	svcpl	0x00646165
     88c:	74697257 	strbtvc	r7, [r9], #-599	; 0xfffffda9
     890:	6f5a0065 	svcvs	0x005a0065
     894:	6569626d 	strbvs	r6, [r9, #-621]!	; 0xfffffd93
     898:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     89c:	6863535f 	stmdavs	r3!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     8a0:	495f6465 	ldmdbmi	pc, {r0, r2, r5, r6, sl, sp, lr}^	; <UNPREDICTABLE>
     8a4:	006f666e 	rsbeq	r6, pc, lr, ror #12
     8a8:	314e5a5f 	cmpcc	lr, pc, asr sl
     8ac:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     8b0:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     8b4:	614d5f73 	hvcvs	54771	; 0xd5f3
     8b8:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     8bc:	63533872 	cmpvs	r3, #7471104	; 0x720000
     8c0:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
     8c4:	7645656c 	strbvc	r6, [r5], -ip, ror #10
     8c8:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     8cc:	50433631 	subpl	r3, r3, r1, lsr r6
     8d0:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     8d4:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 710 <shift+0x710>
     8d8:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     8dc:	39317265 	ldmdbcc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
     8e0:	5f70614d 	svcpl	0x0070614d
     8e4:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     8e8:	5f6f545f 	svcpl	0x006f545f
     8ec:	72727543 	rsbsvc	r7, r2, #281018368	; 0x10c00000
     8f0:	45746e65 	ldrbmi	r6, [r4, #-3685]!	; 0xfffff19b
     8f4:	46493550 			; <UNDEFINED> instruction: 0x46493550
     8f8:	00656c69 	rsbeq	r6, r5, r9, ror #24
     8fc:	5f746547 	svcpl	0x00746547
     900:	61726150 	cmnvs	r2, r0, asr r1
     904:	4d00736d 	stcmi	3, cr7, [r0, #-436]	; 0xfffffe4c
     908:	61507861 	cmpvs	r0, r1, ror #16
     90c:	654c6874 	strbvs	r6, [ip, #-2164]	; 0xfffff78c
     910:	6874676e 	ldmdavs	r4!, {r1, r2, r3, r5, r6, r8, r9, sl, sp, lr}^
     914:	736e7500 	cmnvc	lr, #0, 10
     918:	656e6769 	strbvs	r6, [lr, #-1897]!	; 0xfffff897
     91c:	68632064 	stmdavs	r3!, {r2, r5, r6, sp}^
     920:	53007261 	movwpl	r7, #609	; 0x261
     924:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     928:	69545f6d 	ldmdbvs	r4, {r0, r2, r3, r5, r6, r8, r9, sl, fp, ip, lr}^
     92c:	5f72656d 	svcpl	0x0072656d
     930:	65736142 	ldrbvs	r6, [r3, #-322]!	; 0xfffffebe
     934:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     938:	50433631 	subpl	r3, r3, r1, lsr r6
     93c:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     940:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 77c <shift+0x77c>
     944:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     948:	32317265 	eorscc	r7, r1, #1342177286	; 0x50000006
     94c:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     950:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
     954:	4644455f 			; <UNDEFINED> instruction: 0x4644455f
     958:	47007645 	strmi	r7, [r0, -r5, asr #12]
     95c:	5f4f4950 	svcpl	0x004f4950
     960:	5f6e6950 	svcpl	0x006e6950
     964:	6e756f43 	cdpvs	15, 7, cr6, cr5, cr3, {2}
     968:	68730074 	ldmdavs	r3!, {r2, r4, r5, r6}^
     96c:	2074726f 	rsbscs	r7, r4, pc, ror #4
     970:	00746e69 	rsbseq	r6, r4, r9, ror #28
     974:	62616e45 	rsbvs	r6, r1, #1104	; 0x450
     978:	455f656c 	ldrbmi	r6, [pc, #-1388]	; 414 <shift+0x414>
     97c:	746e6576 	strbtvc	r6, [lr], #-1398	; 0xfffffa8a
     980:	7465445f 	strbtvc	r4, [r5], #-1119	; 0xfffffba1
     984:	69746365 	ldmdbvs	r4!, {r0, r2, r5, r6, r8, r9, sp, lr}^
     988:	50006e6f 	andpl	r6, r0, pc, ror #28
     98c:	70697265 	rsbvc	r7, r9, r5, ror #4
     990:	61726568 	cmnvs	r2, r8, ror #10
     994:	61425f6c 	cmpvs	r2, ip, ror #30
     998:	52006573 	andpl	r6, r0, #482344960	; 0x1cc00000
     99c:	696e6e75 	stmdbvs	lr!, {r0, r2, r4, r5, r6, r9, sl, fp, sp, lr}^
     9a0:	7400676e 	strvc	r6, [r0], #-1902	; 0xfffff892
     9a4:	73746c69 	cmnvc	r4, #26880	; 0x6900
     9a8:	6f736e65 	svcvs	0x00736e65
     9ac:	69665f72 	stmdbvs	r6!, {r1, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     9b0:	7500656c 	strvc	r6, [r0, #-1388]	; 0xfffffa94
     9b4:	33746e69 	cmncc	r4, #1680	; 0x690
     9b8:	00745f32 	rsbseq	r5, r4, r2, lsr pc
     9bc:	4950474e 	ldmdbmi	r0, {r1, r2, r3, r6, r8, r9, sl, lr}^
     9c0:	6e495f4f 	cdpvs	15, 4, cr5, cr9, cr15, {2}
     9c4:	72726574 	rsbsvc	r6, r2, #116, 10	; 0x1d000000
     9c8:	5f747075 	svcpl	0x00747075
     9cc:	65707954 	ldrbvs	r7, [r0, #-2388]!	; 0xfffff6ac
     9d0:	75436d00 	strbvc	r6, [r3, #-3328]	; 0xfffff300
     9d4:	6e657272 	mcrvs	2, 3, r7, cr5, cr2, {3}
     9d8:	61545f74 	cmpvs	r4, r4, ror pc
     9dc:	4e5f6b73 	vmovmi.s8	r6, d15[3]
     9e0:	0065646f 	rsbeq	r6, r5, pc, ror #8
     9e4:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 930 <shift+0x930>
     9e8:	72742f65 	rsbsvc	r2, r4, #404	; 0x194
     9ec:	6c696665 	stclvs	6, cr6, [r9], #-404	; 0xfffffe6c
     9f0:	6d65732f 	stclvs	3, cr7, [r5, #-188]!	; 0xffffff44
     9f4:	756f732f 	strbvc	r7, [pc, #-815]!	; 6cd <shift+0x6cd>
     9f8:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
     9fc:	6573752f 	ldrbvs	r7, [r3, #-1327]!	; 0xfffffad1
     a00:	61707372 	cmnvs	r0, r2, ror r3
     a04:	742f6563 	strtvc	r6, [pc], #-1379	; a0c <shift+0xa0c>
     a08:	5f746c69 	svcpl	0x00746c69
     a0c:	6b736174 	blvs	1cd8fe4 <__bss_end+0x1ccf4a4>
     a10:	69616d2f 	stmdbvs	r1!, {r0, r1, r2, r3, r5, r8, sl, fp, sp, lr}^
     a14:	70632e6e 	rsbvc	r2, r3, lr, ror #28
     a18:	70630070 	rsbvc	r0, r3, r0, ror r0
     a1c:	6f635f75 	svcvs	0x00635f75
     a20:	7865746e 	stmdavc	r5!, {r1, r2, r3, r5, r6, sl, ip, sp, lr}^
     a24:	65520074 	ldrbvs	r0, [r2, #-116]	; 0xffffff8c
     a28:	4f5f6461 	svcmi	0x005f6461
     a2c:	00796c6e 	rsbseq	r6, r9, lr, ror #24
     a30:	65656c73 	strbvs	r6, [r5, #-3187]!	; 0xfffff38d
     a34:	69745f70 	ldmdbvs	r4!, {r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     a38:	0072656d 	rsbseq	r6, r2, sp, ror #10
     a3c:	4b4e5a5f 	blmi	13973c0 <__bss_end+0x138d880>
     a40:	50433631 	subpl	r3, r3, r1, lsr r6
     a44:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     a48:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 884 <shift+0x884>
     a4c:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     a50:	38317265 	ldmdacc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
     a54:	5f746547 	svcpl	0x00746547
     a58:	636f7250 	cmnvs	pc, #80, 4
     a5c:	5f737365 	svcpl	0x00737365
     a60:	505f7942 	subspl	r7, pc, r2, asr #18
     a64:	6a454449 	bvs	1151b90 <__bss_end+0x1148050>
     a68:	6e614800 	cdpvs	8, 6, cr4, cr1, cr0, {0}
     a6c:	5f656c64 	svcpl	0x00656c64
     a70:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     a74:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
     a78:	535f6d65 	cmppl	pc, #6464	; 0x1940
     a7c:	5f004957 	svcpl	0x00004957
     a80:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     a84:	6f725043 	svcvs	0x00725043
     a88:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     a8c:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     a90:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     a94:	63533131 	cmpvs	r3, #1073741836	; 0x4000000c
     a98:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
     a9c:	525f656c 	subspl	r6, pc, #108, 10	; 0x1b000000
     aa0:	00764552 	rsbseq	r4, r6, r2, asr r5
     aa4:	6b736174 	blvs	1cd907c <__bss_end+0x1ccf53c>
     aa8:	74726900 	ldrbtvc	r6, [r2], #-2304	; 0xfffff700
     aac:	00657079 	rsbeq	r7, r5, r9, ror r0
     ab0:	6b726253 	blvs	1c99404 <__bss_end+0x1c8f8c4>
     ab4:	746f4e00 	strbtvc	r4, [pc], #-3584	; abc <shift+0xabc>
     ab8:	5f796669 	svcpl	0x00796669
     abc:	636f7250 	cmnvs	pc, #80, 4
     ac0:	00737365 	rsbseq	r7, r3, r5, ror #6
     ac4:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     ac8:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
     acc:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     ad0:	50433631 	subpl	r3, r3, r1, lsr r6
     ad4:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     ad8:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 914 <shift+0x914>
     adc:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     ae0:	53397265 	teqpl	r9, #1342177286	; 0x50000006
     ae4:	63746977 	cmnvs	r4, #1949696	; 0x1dc000
     ae8:	6f545f68 	svcvs	0x00545f68
     aec:	38315045 	ldmdacc	r1!, {r0, r2, r6, ip, lr}
     af0:	6f725043 	svcvs	0x00725043
     af4:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     af8:	73694c5f 	cmnvc	r9, #24320	; 0x5f00
     afc:	6f4e5f74 	svcvs	0x004e5f74
     b00:	53006564 	movwpl	r6, #1380	; 0x564
     b04:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     b08:	5f656c75 	svcpl	0x00656c75
     b0c:	5f005252 	svcpl	0x00005252
     b10:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     b14:	6f725043 	svcvs	0x00725043
     b18:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     b1c:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     b20:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     b24:	61483831 	cmpvs	r8, r1, lsr r8
     b28:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     b2c:	6f72505f 	svcvs	0x0072505f
     b30:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     b34:	4957535f 	ldmdbmi	r7, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     b38:	4e303245 	cdpmi	2, 3, cr3, cr0, cr5, {2}
     b3c:	5f495753 	svcpl	0x00495753
     b40:	636f7250 	cmnvs	pc, #80, 4
     b44:	5f737365 	svcpl	0x00737365
     b48:	76726553 			; <UNDEFINED> instruction: 0x76726553
     b4c:	6a656369 	bvs	19598f8 <__bss_end+0x194fdb8>
     b50:	31526a6a 	cmpcc	r2, sl, ror #20
     b54:	57535431 	smmlarpl	r3, r1, r4, r5
     b58:	65525f49 	ldrbvs	r5, [r2, #-3913]	; 0xfffff0b7
     b5c:	746c7573 	strbtvc	r7, [ip], #-1395	; 0xfffffa8d
     b60:	67726100 	ldrbvs	r6, [r2, -r0, lsl #2]!
     b64:	494e0076 	stmdbmi	lr, {r1, r2, r4, r5, r6}^
     b68:	6c74434f 	ldclvs	3, cr4, [r4], #-316	; 0xfffffec4
     b6c:	65704f5f 	ldrbvs	r4, [r0, #-3935]!	; 0xfffff0a1
     b70:	69746172 	ldmdbvs	r4!, {r1, r4, r5, r6, r8, sp, lr}^
     b74:	5f006e6f 	svcpl	0x00006e6f
     b78:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     b7c:	6f725043 	svcvs	0x00725043
     b80:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     b84:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     b88:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     b8c:	72433431 	subvc	r3, r3, #822083584	; 0x31000000
     b90:	65746165 	ldrbvs	r6, [r4, #-357]!	; 0xfffffe9b
     b94:	6f72505f 	svcvs	0x0072505f
     b98:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     b9c:	6a685045 	bvs	1a14cb8 <__bss_end+0x1a0b178>
     ba0:	77530062 	ldrbvc	r0, [r3, -r2, rrx]
     ba4:	68637469 	stmdavs	r3!, {r0, r3, r5, r6, sl, ip, sp, lr}^
     ba8:	006f545f 	rsbeq	r5, pc, pc, asr r4	; <UNPREDICTABLE>
     bac:	4957534e 	ldmdbmi	r7, {r1, r2, r3, r6, r8, r9, ip, lr}^
     bb0:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     bb4:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     bb8:	5f6d6574 	svcpl	0x006d6574
     bbc:	76726553 			; <UNDEFINED> instruction: 0x76726553
     bc0:	00656369 	rsbeq	r6, r5, r9, ror #6
     bc4:	61766e49 	cmnvs	r6, r9, asr #28
     bc8:	5f64696c 	svcpl	0x0064696c
     bcc:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     bd0:	4600656c 	strmi	r6, [r0], -ip, ror #10
     bd4:	00656572 	rsbeq	r6, r5, r2, ror r5
     bd8:	736f6c43 	cmnvc	pc, #17152	; 0x4300
     bdc:	72610065 	rsbvc	r0, r1, #101	; 0x65
     be0:	68006367 	stmdavs	r0, {r0, r1, r2, r5, r6, r8, r9, sp, lr}
     be4:	5f706165 	svcpl	0x00706165
     be8:	72617473 	rsbvc	r7, r1, #1929379840	; 0x73000000
     bec:	72570074 	subsvc	r0, r7, #116	; 0x74
     bf0:	5f657469 	svcpl	0x00657469
     bf4:	796c6e4f 	stmdbvc	ip!, {r0, r1, r2, r3, r6, r9, sl, fp, sp, lr}^
     bf8:	65695900 	strbvs	r5, [r9, #-2304]!	; 0xfffff700
     bfc:	5f00646c 	svcpl	0x0000646c
     c00:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     c04:	6f725043 	svcvs	0x00725043
     c08:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     c0c:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     c10:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     c14:	76453443 	strbvc	r3, [r5], -r3, asr #8
     c18:	72655400 	rsbvc	r5, r5, #0, 8
     c1c:	616e696d 	cmnvs	lr, sp, ror #18
     c20:	49006574 	stmdbmi	r0, {r2, r4, r5, r6, r8, sl, sp, lr}
     c24:	6c74434f 	ldclvs	3, cr4, [r4], #-316	; 0xfffffec4
     c28:	676f6c00 	strbvs	r6, [pc, -r0, lsl #24]!
     c2c:	65706970 	ldrbvs	r6, [r0, #-2416]!	; 0xfffff690
     c30:	6f6c6300 	svcvs	0x006c6300
     c34:	53006573 	movwpl	r6, #1395	; 0x573
     c38:	525f7465 	subspl	r7, pc, #1694498816	; 0x65000000
     c3c:	74616c65 	strbtvc	r6, [r1], #-3173	; 0xfffff39b
     c40:	00657669 	rsbeq	r7, r5, r9, ror #12
     c44:	76746572 			; <UNDEFINED> instruction: 0x76746572
     c48:	6e006c61 	cdpvs	12, 0, cr6, cr0, cr1, {3}
     c4c:	00727563 	rsbseq	r7, r2, r3, ror #10
     c50:	756e6472 	strbvc	r6, [lr, #-1138]!	; 0xfffffb8e
     c54:	5a5f006d 	bpl	17c0e10 <__bss_end+0x17b72d0>
     c58:	63733131 	cmnvs	r3, #1073741836	; 0x4000000c
     c5c:	5f646568 	svcpl	0x00646568
     c60:	6c656979 			; <UNDEFINED> instruction: 0x6c656979
     c64:	5f007664 	svcpl	0x00007664
     c68:	7337315a 	teqvc	r7, #-2147483626	; 0x80000016
     c6c:	745f7465 	ldrbvc	r7, [pc], #-1125	; c74 <shift+0xc74>
     c70:	5f6b7361 	svcpl	0x006b7361
     c74:	64616564 	strbtvs	r6, [r1], #-1380	; 0xfffffa9c
     c78:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
     c7c:	6177006a 	cmnvs	r7, sl, rrx
     c80:	5f007469 	svcpl	0x00007469
     c84:	6f6e365a 	svcvs	0x006e365a
     c88:	79666974 	stmdbvc	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
     c8c:	46006a6a 	strmi	r6, [r0], -sl, ror #20
     c90:	006c6961 	rsbeq	r6, ip, r1, ror #18
     c94:	74697865 	strbtvc	r7, [r9], #-2149	; 0xfffff79b
     c98:	65646f63 	strbvs	r6, [r4, #-3939]!	; 0xfffff09d
     c9c:	68637300 	stmdavs	r3!, {r8, r9, ip, sp, lr}^
     ca0:	795f6465 	ldmdbvc	pc, {r0, r2, r5, r6, sl, sp, lr}^	; <UNPREDICTABLE>
     ca4:	646c6569 	strbtvs	r6, [ip], #-1385	; 0xfffffa97
     ca8:	63697400 	cmnvs	r9, #0, 8
     cac:	6f635f6b 	svcvs	0x00635f6b
     cb0:	5f746e75 	svcpl	0x00746e75
     cb4:	75716572 	ldrbvc	r6, [r1, #-1394]!	; 0xfffffa8e
     cb8:	64657269 	strbtvs	r7, [r5], #-617	; 0xfffffd97
     cbc:	325a5f00 	subscc	r5, sl, #0, 30
     cc0:	74656734 	strbtvc	r6, [r5], #-1844	; 0xfffff8cc
     cc4:	7463615f 	strbtvc	r6, [r3], #-351	; 0xfffffea1
     cc8:	5f657669 	svcpl	0x00657669
     ccc:	636f7270 	cmnvs	pc, #112, 4
     cd0:	5f737365 	svcpl	0x00737365
     cd4:	6e756f63 	cdpvs	15, 7, cr6, cr5, cr3, {3}
     cd8:	50007674 	andpl	r7, r0, r4, ror r6
     cdc:	5f657069 	svcpl	0x00657069
     ce0:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     ce4:	6572505f 	ldrbvs	r5, [r2, #-95]!	; 0xffffffa1
     ce8:	00786966 	rsbseq	r6, r8, r6, ror #18
     cec:	34315a5f 	ldrtcc	r5, [r1], #-2655	; 0xfffff5a1
     cf0:	5f746567 	svcpl	0x00746567
     cf4:	6b636974 	blvs	18db2cc <__bss_end+0x18d178c>
     cf8:	756f635f 	strbvc	r6, [pc, #-863]!	; 9a1 <shift+0x9a1>
     cfc:	0076746e 	rsbseq	r7, r6, lr, ror #8
     d00:	65656c73 	strbvs	r6, [r5, #-3187]!	; 0xfffff38d
     d04:	5a5f0070 	bpl	17c0ecc <__bss_end+0x17b738c>
     d08:	72657439 	rsbvc	r7, r5, #956301312	; 0x39000000
     d0c:	616e696d 	cmnvs	lr, sp, ror #18
     d10:	00696574 	rsbeq	r6, r9, r4, ror r5
     d14:	7265706f 	rsbvc	r7, r5, #111	; 0x6f
     d18:	6f697461 	svcvs	0x00697461
     d1c:	5a5f006e 	bpl	17c0edc <__bss_end+0x17b739c>
     d20:	6f6c6335 	svcvs	0x006c6335
     d24:	006a6573 	rsbeq	r6, sl, r3, ror r5
     d28:	67365a5f 			; <UNDEFINED> instruction: 0x67365a5f
     d2c:	69707465 	ldmdbvs	r0!, {r0, r2, r5, r6, sl, ip, sp, lr}^
     d30:	66007664 	strvs	r7, [r0], -r4, ror #12
     d34:	656d616e 	strbvs	r6, [sp, #-366]!	; 0xfffffe92
     d38:	554e4700 	strbpl	r4, [lr, #-1792]	; 0xfffff900
     d3c:	2b2b4320 	blcs	ad19c4 <__bss_end+0xac7e84>
     d40:	31203431 			; <UNDEFINED> instruction: 0x31203431
     d44:	2e332e30 	mrccs	14, 1, r2, cr3, cr0, {1}
     d48:	30322031 	eorscc	r2, r2, r1, lsr r0
     d4c:	36303132 			; <UNDEFINED> instruction: 0x36303132
     d50:	28203132 	stmdacs	r0!, {r1, r4, r5, r8, ip, sp}
     d54:	656c6572 	strbvs	r6, [ip, #-1394]!	; 0xfffffa8e
     d58:	29657361 	stmdbcs	r5!, {r0, r5, r6, r8, r9, ip, sp, lr}^
     d5c:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
     d60:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
     d64:	6962612d 	stmdbvs	r2!, {r0, r2, r3, r5, r8, sp, lr}^
     d68:	7261683d 	rsbvc	r6, r1, #3997696	; 0x3d0000
     d6c:	6d2d2064 	stcvs	0, cr2, [sp, #-400]!	; 0xfffffe70
     d70:	3d757066 	ldclcc	0, cr7, [r5, #-408]!	; 0xfffffe68
     d74:	20706676 	rsbscs	r6, r0, r6, ror r6
     d78:	6c666d2d 	stclvs	13, cr6, [r6], #-180	; 0xffffff4c
     d7c:	2d74616f 	ldfcse	f6, [r4, #-444]!	; 0xfffffe44
     d80:	3d696261 	sfmcc	f6, 2, [r9, #-388]!	; 0xfffffe7c
     d84:	64726168 	ldrbtvs	r6, [r2], #-360	; 0xfffffe98
     d88:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
     d8c:	763d7570 			; <UNDEFINED> instruction: 0x763d7570
     d90:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
     d94:	6e75746d 	cdpvs	4, 7, cr7, cr5, cr13, {3}
     d98:	72613d65 	rsbvc	r3, r1, #6464	; 0x1940
     d9c:	3731316d 	ldrcc	r3, [r1, -sp, ror #2]!
     da0:	667a6a36 			; <UNDEFINED> instruction: 0x667a6a36
     da4:	2d20732d 	stccs	3, cr7, [r0, #-180]!	; 0xffffff4c
     da8:	6d72616d 	ldfvse	f6, [r2, #-436]!	; 0xfffffe4c
     dac:	616d2d20 	cmnvs	sp, r0, lsr #26
     db0:	3d686372 	stclcc	3, cr6, [r8, #-456]!	; 0xfffffe38
     db4:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
     db8:	2b6b7a36 	blcs	1adf698 <__bss_end+0x1ad5b58>
     dbc:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
     dc0:	672d2067 	strvs	r2, [sp, -r7, rrx]!
     dc4:	20672d20 	rsbcs	r2, r7, r0, lsr #26
     dc8:	20304f2d 	eorscs	r4, r0, sp, lsr #30
     dcc:	20304f2d 	eorscs	r4, r0, sp, lsr #30
     dd0:	6f6e662d 	svcvs	0x006e662d
     dd4:	6378652d 	cmnvs	r8, #188743680	; 0xb400000
     dd8:	69747065 	ldmdbvs	r4!, {r0, r2, r5, r6, ip, sp, lr}^
     ddc:	20736e6f 	rsbscs	r6, r3, pc, ror #28
     de0:	6f6e662d 	svcvs	0x006e662d
     de4:	7474722d 	ldrbtvc	r7, [r4], #-557	; 0xfffffdd3
     de8:	72770069 	rsbsvc	r0, r7, #105	; 0x69
     dec:	00657469 	rsbeq	r7, r5, r9, ror #8
     df0:	6b636974 	blvs	18db3c8 <__bss_end+0x18d1888>
     df4:	706f0073 	rsbvc	r0, pc, r3, ror r0	; <UNPREDICTABLE>
     df8:	5f006e65 	svcpl	0x00006e65
     dfc:	6970345a 	ldmdbvs	r0!, {r1, r3, r4, r6, sl, ip, sp}^
     e00:	4b506570 	blmi	141a3c8 <__bss_end+0x1410888>
     e04:	4e006a63 	vmlsmi.f32	s12, s0, s7
     e08:	64616544 	strbtvs	r6, [r1], #-1348	; 0xfffffabc
     e0c:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
     e10:	6275535f 	rsbsvs	r5, r5, #2080374785	; 0x7c000001
     e14:	76726573 			; <UNDEFINED> instruction: 0x76726573
     e18:	00656369 	rsbeq	r6, r5, r9, ror #6
     e1c:	5f746567 	svcpl	0x00746567
     e20:	6b636974 	blvs	18db3f8 <__bss_end+0x18d18b8>
     e24:	756f635f 	strbvc	r6, [pc, #-863]!	; acd <shift+0xacd>
     e28:	7000746e 	andvc	r7, r0, lr, ror #8
     e2c:	6d617261 	sfmvs	f7, 2, [r1, #-388]!	; 0xfffffe7c
     e30:	355a5f00 	ldrbcc	r5, [sl, #-3840]	; 0xfffff100
     e34:	74697277 	strbtvc	r7, [r9], #-631	; 0xfffffd89
     e38:	4b506a65 	blmi	141b7d4 <__bss_end+0x1411c94>
     e3c:	67006a63 	strvs	r6, [r0, -r3, ror #20]
     e40:	745f7465 	ldrbvc	r7, [pc], #-1125	; e48 <shift+0xe48>
     e44:	5f6b7361 	svcpl	0x006b7361
     e48:	6b636974 	blvs	18db420 <__bss_end+0x18d18e0>
     e4c:	6f745f73 	svcvs	0x00745f73
     e50:	6165645f 	cmnvs	r5, pc, asr r4
     e54:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
     e58:	75620065 	strbvc	r0, [r2, #-101]!	; 0xffffff9b
     e5c:	69735f66 	ldmdbvs	r3!, {r1, r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     e60:	2f00657a 	svccs	0x0000657a
     e64:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
     e68:	6572742f 	ldrbvs	r7, [r2, #-1071]!	; 0xfffffbd1
     e6c:	2f6c6966 	svccs	0x006c6966
     e70:	2f6d6573 	svccs	0x006d6573
     e74:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
     e78:	2f736563 	svccs	0x00736563
     e7c:	6c697562 	cfstr64vs	mvdx7, [r9], #-392	; 0xfffffe78
     e80:	65730064 	ldrbvs	r0, [r3, #-100]!	; 0xffffff9c
     e84:	61745f74 	cmnvs	r4, r4, ror pc
     e88:	645f6b73 	ldrbvs	r6, [pc], #-2931	; e90 <shift+0xe90>
     e8c:	6c646165 	stfvse	f6, [r4], #-404	; 0xfffffe6c
     e90:	00656e69 	rsbeq	r6, r5, r9, ror #28
     e94:	73355a5f 	teqvc	r5, #389120	; 0x5f000
     e98:	7065656c 	rsbvc	r6, r5, ip, ror #10
     e9c:	47006a6a 	strmi	r6, [r0, -sl, ror #20]
     ea0:	525f7465 	subspl	r7, pc, #1694498816	; 0x65000000
     ea4:	69616d65 	stmdbvs	r1!, {r0, r2, r5, r6, r8, sl, fp, sp, lr}^
     ea8:	676e696e 	strbvs	r6, [lr, -lr, ror #18]!
     eac:	325a5f00 	subscc	r5, sl, #0, 30
     eb0:	74656736 	strbtvc	r6, [r5], #-1846	; 0xfffff8ca
     eb4:	7361745f 	cmnvc	r1, #1593835520	; 0x5f000000
     eb8:	69745f6b 	ldmdbvs	r4!, {r0, r1, r3, r5, r6, r8, r9, sl, fp, ip, lr}^
     ebc:	5f736b63 	svcpl	0x00736b63
     ec0:	645f6f74 	ldrbvs	r6, [pc], #-3956	; ec8 <shift+0xec8>
     ec4:	6c646165 	stfvse	f6, [r4], #-404	; 0xfffffe6c
     ec8:	76656e69 	strbtvc	r6, [r5], -r9, ror #28
     ecc:	6f682f00 	svcvs	0x00682f00
     ed0:	742f656d 	strtvc	r6, [pc], #-1389	; ed8 <shift+0xed8>
     ed4:	69666572 	stmdbvs	r6!, {r1, r4, r5, r6, r8, sl, sp, lr}^
     ed8:	65732f6c 	ldrbvs	r2, [r3, #-3948]!	; 0xfffff094
     edc:	6f732f6d 	svcvs	0x00732f6d
     ee0:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
     ee4:	74732f73 	ldrbtvc	r2, [r3], #-3955	; 0xfffff08d
     ee8:	62696c64 	rsbvs	r6, r9, #100, 24	; 0x6400
     eec:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
     ef0:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
     ef4:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
     ef8:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
     efc:	57534e00 	ldrbpl	r4, [r3, -r0, lsl #28]
     f00:	65525f49 	ldrbvs	r5, [r2, #-3913]	; 0xfffff0b7
     f04:	746c7573 	strbtvc	r7, [ip], #-1395	; 0xfffffa8d
     f08:	646f435f 	strbtvs	r4, [pc], #-863	; f10 <shift+0xf10>
     f0c:	72770065 	rsbsvc	r0, r7, #101	; 0x65
     f10:	006d756e 	rsbeq	r7, sp, lr, ror #10
     f14:	77345a5f 			; <UNDEFINED> instruction: 0x77345a5f
     f18:	6a746961 	bvs	1d1b4a4 <__bss_end+0x1d11964>
     f1c:	5f006a6a 	svcpl	0x00006a6a
     f20:	6f69355a 	svcvs	0x0069355a
     f24:	6a6c7463 	bvs	1b1e0b8 <__bss_end+0x1b14578>
     f28:	494e3631 	stmdbmi	lr, {r0, r4, r5, r9, sl, ip, sp}^
     f2c:	6c74434f 	ldclvs	3, cr4, [r4], #-316	; 0xfffffec4
     f30:	65704f5f 	ldrbvs	r4, [r0, #-3935]!	; 0xfffff0a1
     f34:	69746172 	ldmdbvs	r4!, {r1, r4, r5, r6, r8, sp, lr}^
     f38:	76506e6f 	ldrbvc	r6, [r0], -pc, ror #28
     f3c:	636f6900 	cmnvs	pc, #0, 18
     f40:	72006c74 	andvc	r6, r0, #116, 24	; 0x7400
     f44:	6e637465 	cdpvs	4, 6, cr7, cr3, cr5, {3}
     f48:	6f6e0074 	svcvs	0x006e0074
     f4c:	79666974 	stmdbvc	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
     f50:	72657400 	rsbvc	r7, r5, #0, 8
     f54:	616e696d 	cmnvs	lr, sp, ror #18
     f58:	6d006574 	cfstr32vs	mvfx6, [r0, #-464]	; 0xfffffe30
     f5c:	0065646f 	rsbeq	r6, r5, pc, ror #8
     f60:	66667562 	strbtvs	r7, [r6], -r2, ror #10
     f64:	5f007265 	svcpl	0x00007265
     f68:	6572345a 	ldrbvs	r3, [r2, #-1114]!	; 0xfffffba6
     f6c:	506a6461 	rsbpl	r6, sl, r1, ror #8
     f70:	72006a63 	andvc	r6, r0, #405504	; 0x63000
     f74:	6f637465 	svcvs	0x00637465
     f78:	67006564 	strvs	r6, [r0, -r4, ror #10]
     f7c:	615f7465 	cmpvs	pc, r5, ror #8
     f80:	76697463 	strbtvc	r7, [r9], -r3, ror #8
     f84:	72705f65 	rsbsvc	r5, r0, #404	; 0x194
     f88:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     f8c:	6f635f73 	svcvs	0x00635f73
     f90:	00746e75 	rsbseq	r6, r4, r5, ror lr
     f94:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
     f98:	656d616e 	strbvs	r6, [sp, #-366]!	; 0xfffffe92
     f9c:	61657200 	cmnvs	r5, r0, lsl #4
     fa0:	65670064 	strbvs	r0, [r7, #-100]!	; 0xffffff9c
     fa4:	64697074 	strbtvs	r7, [r9], #-116	; 0xffffff8c
     fa8:	345a5f00 	ldrbcc	r5, [sl], #-3840	; 0xfffff100
     fac:	6e65706f 	cdpvs	0, 6, cr7, cr5, cr15, {3}
     fb0:	31634b50 	cmncc	r3, r0, asr fp
     fb4:	69464e35 	stmdbvs	r6, {r0, r2, r4, r5, r9, sl, fp, lr}^
     fb8:	4f5f656c 	svcmi	0x005f656c
     fbc:	5f6e6570 	svcpl	0x006e6570
     fc0:	65646f4d 	strbvs	r6, [r4, #-3917]!	; 0xfffff0b3
     fc4:	375a5f00 	ldrbcc	r5, [sl, -r0, lsl #30]
     fc8:	6e727473 	mrcvs	4, 3, r7, cr2, cr3, {3}
     fcc:	50797063 	rsbspl	r7, r9, r3, rrx
     fd0:	634b5063 	movtvs	r5, #45155	; 0xb063
     fd4:	5a5f0069 	bpl	17c1180 <__bss_end+0x17b7640>
     fd8:	6d656d36 	stclvs	13, cr6, [r5, #-216]!	; 0xffffff28
     fdc:	50797063 	rsbspl	r7, r9, r3, rrx
     fe0:	7650764b 	ldrbvc	r7, [r0], -fp, asr #12
     fe4:	5a5f0069 	bpl	17c1190 <__bss_end+0x17b7650>
     fe8:	65673431 	strbvs	r3, [r7, #-1073]!	; 0xfffffbcf
     fec:	6e695f74 	mcrvs	15, 3, r5, cr9, cr4, {3}
     ff0:	5f747570 	svcpl	0x00747570
     ff4:	65707974 	ldrbvs	r7, [r0, #-2420]!	; 0xfffff68c
     ff8:	00634b50 	rsbeq	r4, r3, r0, asr fp
     ffc:	6e345a5f 			; <UNDEFINED> instruction: 0x6e345a5f
    1000:	6975745f 	ldmdbvs	r5!, {r0, r1, r2, r3, r4, r6, sl, ip, sp, lr}^
    1004:	74610069 	strbtvc	r0, [r1], #-105	; 0xffffff97
    1008:	6700666f 	strvs	r6, [r0, -pc, ror #12]
    100c:	695f7465 	ldmdbvs	pc, {r0, r2, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
    1010:	7475706e 	ldrbtvc	r7, [r5], #-110	; 0xffffff92
    1014:	7079745f 	rsbsvc	r7, r9, pc, asr r4
    1018:	74610065 	strbtvc	r0, [r1], #-101	; 0xffffff9b
    101c:	5f00696f 	svcpl	0x0000696f
    1020:	7461345a 	strbtvc	r3, [r1], #-1114	; 0xfffffba6
    1024:	4b50666f 	blmi	141a9e8 <__bss_end+0x1410ea8>
    1028:	65640063 	strbvs	r0, [r4, #-99]!	; 0xffffff9d
    102c:	69007473 	stmdbvs	r0, {r0, r1, r4, r5, r6, sl, ip, sp, lr}
    1030:	7475706e 	ldrbtvc	r7, [r5], #-110	; 0xffffff92
    1034:	67697300 	strbvs	r7, [r9, -r0, lsl #6]!
    1038:	7473006e 	ldrbtvc	r0, [r3], #-110	; 0xffffff92
    103c:	74616372 	strbtvc	r6, [r1], #-882	; 0xfffffc8e
    1040:	355a5f00 	ldrbcc	r5, [sl, #-3840]	; 0xfffff100
    1044:	72657a62 	rsbvc	r7, r5, #401408	; 0x62000
    1048:	6976506f 	ldmdbvs	r6!, {r0, r1, r2, r3, r5, r6, ip, lr}^
    104c:	72747300 	rsbsvc	r7, r4, #0, 6
    1050:	7970636e 	ldmdbvc	r0!, {r1, r2, r3, r5, r6, r8, r9, sp, lr}^
    1054:	365a5f00 	ldrbcc	r5, [sl], -r0, lsl #30
    1058:	63727473 	cmnvs	r2, #1929379840	; 0x73000000
    105c:	63507461 	cmpvs	r0, #1627389952	; 0x61000000
    1060:	00634b50 	rsbeq	r4, r3, r0, asr fp
    1064:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; fb0 <shift+0xfb0>
    1068:	72742f65 	rsbsvc	r2, r4, #404	; 0x194
    106c:	6c696665 	stclvs	6, cr6, [r9], #-404	; 0xfffffe6c
    1070:	6d65732f 	stclvs	3, cr7, [r5, #-188]!	; 0xffffff44
    1074:	756f732f 	strbvc	r7, [pc, #-815]!	; d4d <shift+0xd4d>
    1078:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
    107c:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
    1080:	2f62696c 	svccs	0x0062696c
    1084:	2f637273 	svccs	0x00637273
    1088:	73647473 	cmnvc	r4, #1929379840	; 0x73000000
    108c:	6e697274 	mcrvs	2, 3, r7, cr9, cr4, {3}
    1090:	70632e67 	rsbvc	r2, r3, r7, ror #28
    1094:	74730070 	ldrbtvc	r0, [r3], #-112	; 0xffffff90
    1098:	61636e72 	smcvs	14050	; 0x36e2
    109c:	61770074 	cmnvs	r7, r4, ror r0
    10a0:	72656b6c 	rsbvc	r6, r5, #108, 22	; 0x1b000
    10a4:	63616600 	cmnvs	r1, #0, 12
    10a8:	00726f74 	rsbseq	r6, r2, r4, ror pc
    10ac:	616f7469 	cmnvs	pc, r9, ror #8
    10b0:	736f7000 	cmnvc	pc, #0
    10b4:	6f697469 	svcvs	0x00697469
    10b8:	656d006e 	strbvs	r0, [sp, #-110]!	; 0xffffff92
    10bc:	7473646d 	ldrbtvc	r6, [r3], #-1133	; 0xfffffb93
    10c0:	61684300 	cmnvs	r8, r0, lsl #6
    10c4:	6e6f4372 	mcrvs	3, 3, r4, cr15, cr2, {3}
    10c8:	72724176 	rsbsvc	r4, r2, #-2147483619	; 0x8000001d
    10cc:	6f746600 	svcvs	0x00746600
    10d0:	756e0061 	strbvc	r0, [lr, #-97]!	; 0xffffff9f
    10d4:	7265626d 	rsbvc	r6, r5, #-805306362	; 0xd0000006
    10d8:	6d656d00 	stclvs	13, cr6, [r5, #-0]
    10dc:	00637273 	rsbeq	r7, r3, r3, ror r2
    10e0:	626d756e 	rsbvs	r7, sp, #461373440	; 0x1b800000
    10e4:	00327265 	eorseq	r7, r2, r5, ror #4
    10e8:	65746661 	ldrbvs	r6, [r4, #-1633]!	; 0xfffff99f
    10ec:	63654472 	cmnvs	r5, #1912602624	; 0x72000000
    10f0:	6e696f50 	mcrvs	15, 3, r6, cr9, cr0, {2}
    10f4:	7a620074 	bvc	18812cc <__bss_end+0x187778c>
    10f8:	006f7265 	rsbeq	r7, pc, r5, ror #4
    10fc:	636d656d 	cmnvs	sp, #457179136	; 0x1b400000
    1100:	73007970 	movwvc	r7, #2416	; 0x970
    1104:	636e7274 	cmnvs	lr, #116, 4	; 0x40000007
    1108:	7400706d 	strvc	r7, [r0], #-109	; 0xffffff93
    110c:	6c696172 	stfvse	f6, [r9], #-456	; 0xfffffe38
    1110:	5f676e69 	svcpl	0x00676e69
    1114:	00746f64 	rsbseq	r6, r4, r4, ror #30
    1118:	7074756f 	rsbsvc	r7, r4, pc, ror #10
    111c:	6c007475 	cfstrsvs	mvf7, [r0], {117}	; 0x75
    1120:	74676e65 	strbtvc	r6, [r7], #-3685	; 0xfffff19b
    1124:	6e003268 	cdpvs	2, 0, cr3, cr0, cr8, {3}
    1128:	0075745f 	rsbseq	r7, r5, pc, asr r4
    112c:	73365a5f 	teqvc	r6, #389120	; 0x5f000
    1130:	656c7274 	strbvs	r7, [ip, #-628]!	; 0xfffffd8c
    1134:	634b506e 	movtvs	r5, #45166	; 0xb06e
    1138:	375a5f00 	ldrbcc	r5, [sl, -r0, lsl #30]
    113c:	6e727473 	mrcvs	4, 3, r7, cr2, cr3, {3}
    1140:	50706d63 	rsbspl	r6, r0, r3, ror #26
    1144:	3053634b 	subscc	r6, r3, fp, asr #6
    1148:	5f00695f 	svcpl	0x0000695f
    114c:	7461345a 	strbtvc	r3, [r1], #-1114	; 0xfffffba6
    1150:	4b50696f 	blmi	141b714 <__bss_end+0x1411bd4>
    1154:	5a5f0063 	bpl	17c12e8 <__bss_end+0x17b77a8>
    1158:	6f746934 	svcvs	0x00746934
    115c:	63506961 	cmpvs	r0, #1589248	; 0x184000
    1160:	5a5f006a 	bpl	17c1310 <__bss_end+0x17b77d0>
    1164:	6f746634 	svcvs	0x00746634
    1168:	63506661 	cmpvs	r0, #101711872	; 0x6100000
    116c:	6d656d00 	stclvs	13, cr6, [r5, #-0]
    1170:	0079726f 	rsbseq	r7, r9, pc, ror #4
    1174:	676e656c 	strbvs	r6, [lr, -ip, ror #10]!
    1178:	73006874 	movwvc	r6, #2164	; 0x874
    117c:	656c7274 	strbvs	r7, [ip, #-628]!	; 0xfffffd8c
    1180:	5a5f006e 	bpl	17c1340 <__bss_end+0x17b7800>
    1184:	72747337 	rsbsvc	r7, r4, #-603979776	; 0xdc000000
    1188:	7461636e 	strbtvc	r6, [r1], #-878	; 0xfffffc92
    118c:	4b506350 	blmi	1419ed4 <__bss_end+0x1410394>
    1190:	2e006963 	vmlscs.f16	s12, s0, s7	; <UNPREDICTABLE>
    1194:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1198:	2f2e2e2f 	svccs	0x002e2e2f
    119c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    11a0:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    11a4:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
    11a8:	2f636367 	svccs	0x00636367
    11ac:	666e6f63 	strbtvs	r6, [lr], -r3, ror #30
    11b0:	612f6769 			; <UNDEFINED> instruction: 0x612f6769
    11b4:	6c2f6d72 	stcvs	13, cr6, [pc], #-456	; ff4 <shift+0xff4>
    11b8:	66316269 	ldrtvs	r6, [r1], -r9, ror #4
    11bc:	73636e75 	cmnvc	r3, #1872	; 0x750
    11c0:	2f00532e 	svccs	0x0000532e
    11c4:	6c697562 	cfstr64vs	mvdx7, [r9], #-392	; 0xfffffe78
    11c8:	63672f64 	cmnvs	r7, #100, 30	; 0x190
    11cc:	72612d63 	rsbvc	r2, r1, #6336	; 0x18c0
    11d0:	6f6e2d6d 	svcvs	0x006e2d6d
    11d4:	652d656e 	strvs	r6, [sp, #-1390]!	; 0xfffffa92
    11d8:	2d696261 	sfmcs	f6, 2, [r9, #-388]!	; 0xfffffe7c
    11dc:	67665968 	strbvs	r5, [r6, -r8, ror #18]!
    11e0:	672f344b 	strvs	r3, [pc, -fp, asr #8]!
    11e4:	612d6363 			; <UNDEFINED> instruction: 0x612d6363
    11e8:	6e2d6d72 	mcrvs	13, 1, r6, cr13, cr2, {3}
    11ec:	2d656e6f 	stclcs	14, cr6, [r5, #-444]!	; 0xfffffe44
    11f0:	69626165 	stmdbvs	r2!, {r0, r2, r5, r6, r8, sp, lr}^
    11f4:	2e30312d 	rsfcssp	f3, f0, #5.0
    11f8:	30322d33 	eorscc	r2, r2, r3, lsr sp
    11fc:	302e3132 	eorcc	r3, lr, r2, lsr r1
    1200:	75622f37 	strbvc	r2, [r2, #-3895]!	; 0xfffff0c9
    1204:	2f646c69 	svccs	0x00646c69
    1208:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
    120c:	656e6f6e 	strbvs	r6, [lr, #-3950]!	; 0xfffff092
    1210:	6261652d 	rsbvs	r6, r1, #188743680	; 0xb400000
    1214:	72612f69 	rsbvc	r2, r1, #420	; 0x1a4
    1218:	35762f6d 	ldrbcc	r2, [r6, #-3949]!	; 0xfffff093
    121c:	682f6574 	stmdavs	pc!, {r2, r4, r5, r6, r8, sl, sp, lr}	; <UNPREDICTABLE>
    1220:	2f647261 	svccs	0x00647261
    1224:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    1228:	47006363 	strmi	r6, [r0, -r3, ror #6]
    122c:	4120554e 			; <UNDEFINED> instruction: 0x4120554e
    1230:	2e322053 	mrccs	0, 1, r2, cr2, cr3, {2}
    1234:	2e003733 	mcrcs	7, 0, r3, cr0, cr3, {1}
    1238:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    123c:	2f2e2e2f 	svccs	0x002e2e2f
    1240:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1244:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1248:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
    124c:	2f636367 	svccs	0x00636367
    1250:	666e6f63 	strbtvs	r6, [lr], -r3, ror #30
    1254:	612f6769 			; <UNDEFINED> instruction: 0x612f6769
    1258:	692f6d72 	stmdbvs	pc!, {r1, r4, r5, r6, r8, sl, fp, sp, lr}	; <UNPREDICTABLE>
    125c:	37656565 	strbcc	r6, [r5, -r5, ror #10]!
    1260:	732d3435 			; <UNDEFINED> instruction: 0x732d3435
    1264:	00532e66 	subseq	r2, r3, r6, ror #28
    1268:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    126c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1270:	2f2e2e2f 	svccs	0x002e2e2f
    1274:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1278:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
    127c:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    1280:	6e6f632f 	cdpvs	3, 6, cr6, cr15, cr15, {1}
    1284:	2f676966 	svccs	0x00676966
    1288:	2f6d7261 	svccs	0x006d7261
    128c:	62617062 	rsbvs	r7, r1, #98	; 0x62
    1290:	00532e69 	subseq	r2, r3, r9, ror #28
    1294:	5f617369 	svcpl	0x00617369
    1298:	5f746962 	svcpl	0x00746962
    129c:	64657270 	strbtvs	r7, [r5], #-624	; 0xfffffd90
    12a0:	00736572 	rsbseq	r6, r3, r2, ror r5
    12a4:	5f617369 	svcpl	0x00617369
    12a8:	5f746962 	svcpl	0x00746962
    12ac:	5f706676 	svcpl	0x00706676
    12b0:	65736162 	ldrbvs	r6, [r3, #-354]!	; 0xfffffe9e
    12b4:	6d6f6300 	stclvs	3, cr6, [pc, #-0]	; 12bc <shift+0x12bc>
    12b8:	78656c70 	stmdavc	r5!, {r4, r5, r6, sl, fp, sp, lr}^
    12bc:	6f6c6620 	svcvs	0x006c6620
    12c0:	69007461 	stmdbvs	r0, {r0, r5, r6, sl, ip, sp, lr}
    12c4:	6e5f6173 	mrcvs	1, 2, r6, cr15, cr3, {3}
    12c8:	7469626f 	strbtvc	r6, [r9], #-623	; 0xfffffd91
    12cc:	61736900 	cmnvs	r3, r0, lsl #18
    12d0:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    12d4:	65766d5f 	ldrbvs	r6, [r6, #-3423]!	; 0xfffff2a1
    12d8:	6f6c665f 	svcvs	0x006c665f
    12dc:	69007461 	stmdbvs	r0, {r0, r5, r6, sl, ip, sp, lr}
    12e0:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    12e4:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
    12e8:	00363170 	eorseq	r3, r6, r0, ror r1
    12ec:	5f617369 	svcpl	0x00617369
    12f0:	5f746962 	svcpl	0x00746962
    12f4:	00636573 	rsbeq	r6, r3, r3, ror r5
    12f8:	5f617369 	svcpl	0x00617369
    12fc:	5f746962 	svcpl	0x00746962
    1300:	76696461 	strbtvc	r6, [r9], -r1, ror #8
    1304:	61736900 	cmnvs	r3, r0, lsl #18
    1308:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    130c:	6975715f 	ldmdbvs	r5!, {r0, r1, r2, r3, r4, r6, r8, ip, sp, lr}^
    1310:	6e5f6b72 	vmovvs.s8	r6, d15[3]
    1314:	6f765f6f 	svcvs	0x00765f6f
    1318:	6974616c 	ldmdbvs	r4!, {r2, r3, r5, r6, r8, sp, lr}^
    131c:	635f656c 	cmpvs	pc, #108, 10	; 0x1b000000
    1320:	73690065 	cmnvc	r9, #101	; 0x65
    1324:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1328:	706d5f74 	rsbvc	r5, sp, r4, ror pc
    132c:	61736900 	cmnvs	r3, r0, lsl #18
    1330:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1334:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1338:	00743576 	rsbseq	r3, r4, r6, ror r5
    133c:	5f617369 	svcpl	0x00617369
    1340:	5f746962 	svcpl	0x00746962
    1344:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    1348:	00657435 	rsbeq	r7, r5, r5, lsr r4
    134c:	5f617369 	svcpl	0x00617369
    1350:	5f746962 	svcpl	0x00746962
    1354:	6e6f656e 	cdpvs	5, 6, cr6, cr15, cr14, {3}
    1358:	61736900 	cmnvs	r3, r0, lsl #18
    135c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1360:	3166625f 	cmncc	r6, pc, asr r2
    1364:	50460036 	subpl	r0, r6, r6, lsr r0
    1368:	5f524353 	svcpl	0x00524353
    136c:	4d554e45 	ldclmi	14, cr4, [r5, #-276]	; 0xfffffeec
    1370:	53504600 	cmppl	r0, #0, 12
    1374:	6e5f5243 	cdpvs	2, 5, cr5, cr15, cr3, {2}
    1378:	7176637a 	cmnvc	r6, sl, ror r3
    137c:	4e455f63 	cdpmi	15, 4, cr5, cr5, cr3, {3}
    1380:	56004d55 			; <UNDEFINED> instruction: 0x56004d55
    1384:	455f5250 	ldrbmi	r5, [pc, #-592]	; 113c <shift+0x113c>
    1388:	004d554e 	subeq	r5, sp, lr, asr #10
    138c:	74696266 	strbtvc	r6, [r9], #-614	; 0xfffffd9a
    1390:	706d695f 	rsbvc	r6, sp, pc, asr r9
    1394:	6163696c 	cmnvs	r3, ip, ror #18
    1398:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
    139c:	5f305000 	svcpl	0x00305000
    13a0:	4d554e45 	ldclmi	14, cr4, [r5, #-276]	; 0xfffffeec
    13a4:	61736900 	cmnvs	r3, r0, lsl #18
    13a8:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    13ac:	7972635f 	ldmdbvc	r2!, {r0, r1, r2, r3, r4, r6, r8, r9, sp, lr}^
    13b0:	006f7470 	rsbeq	r7, pc, r0, ror r4	; <UNPREDICTABLE>
    13b4:	20554e47 	subscs	r4, r5, r7, asr #28
    13b8:	20373143 	eorscs	r3, r7, r3, asr #2
    13bc:	332e3031 			; <UNDEFINED> instruction: 0x332e3031
    13c0:	3220312e 	eorcc	r3, r0, #-2147483637	; 0x8000000b
    13c4:	30313230 	eorscc	r3, r1, r0, lsr r2
    13c8:	20313236 	eorscs	r3, r1, r6, lsr r2
    13cc:	6c657228 	sfmvs	f7, 2, [r5], #-160	; 0xffffff60
    13d0:	65736165 	ldrbvs	r6, [r3, #-357]!	; 0xfffffe9b
    13d4:	6d2d2029 	stcvs	0, cr2, [sp, #-164]!	; 0xffffff5c
    13d8:	206d7261 	rsbcs	r7, sp, r1, ror #4
    13dc:	6c666d2d 	stclvs	13, cr6, [r6], #-180	; 0xffffff4c
    13e0:	2d74616f 	ldfcse	f6, [r4, #-444]!	; 0xfffffe44
    13e4:	3d696261 	sfmcc	f6, 2, [r9, #-388]!	; 0xfffffe7c
    13e8:	64726168 	ldrbtvs	r6, [r2], #-360	; 0xfffffe98
    13ec:	616d2d20 	cmnvs	sp, r0, lsr #26
    13f0:	3d686372 	stclcc	3, cr6, [r8, #-456]!	; 0xfffffe38
    13f4:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    13f8:	2b657435 	blcs	195e4d4 <__bss_end+0x1954994>
    13fc:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
    1400:	672d2067 	strvs	r2, [sp, -r7, rrx]!
    1404:	20672d20 	rsbcs	r2, r7, r0, lsr #26
    1408:	20324f2d 	eorscs	r4, r2, sp, lsr #30
    140c:	20324f2d 	eorscs	r4, r2, sp, lsr #30
    1410:	20324f2d 	eorscs	r4, r2, sp, lsr #30
    1414:	7562662d 	strbvc	r6, [r2, #-1581]!	; 0xfffff9d3
    1418:	69646c69 	stmdbvs	r4!, {r0, r3, r5, r6, sl, fp, sp, lr}^
    141c:	6c2d676e 	stcvs	7, cr6, [sp], #-440	; 0xfffffe48
    1420:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    1424:	662d2063 	strtvs	r2, [sp], -r3, rrx
    1428:	732d6f6e 			; <UNDEFINED> instruction: 0x732d6f6e
    142c:	6b636174 	blvs	18d9a04 <__bss_end+0x18cfec4>
    1430:	6f72702d 	svcvs	0x0072702d
    1434:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
    1438:	2d20726f 	sfmcs	f7, 4, [r0, #-444]!	; 0xfffffe44
    143c:	2d6f6e66 	stclcs	14, cr6, [pc, #-408]!	; 12ac <shift+0x12ac>
    1440:	696c6e69 	stmdbvs	ip!, {r0, r3, r5, r6, r9, sl, fp, sp, lr}^
    1444:	2d20656e 	cfstr32cs	mvfx6, [r0, #-440]!	; 0xfffffe48
    1448:	73697666 	cmnvc	r9, #106954752	; 0x6600000
    144c:	6c696269 	sfmvs	f6, 2, [r9], #-420	; 0xfffffe5c
    1450:	3d797469 	cfldrdcc	mvd7, [r9, #-420]!	; 0xfffffe5c
    1454:	64646968 	strbtvs	r6, [r4], #-2408	; 0xfffff698
    1458:	69006e65 	stmdbvs	r0, {r0, r2, r5, r6, r9, sl, fp, sp, lr}
    145c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1460:	745f7469 	ldrbvc	r7, [pc], #-1129	; 1468 <shift+0x1468>
    1464:	00766964 	rsbseq	r6, r6, r4, ror #18
    1468:	736e6f63 	cmnvc	lr, #396	; 0x18c
    146c:	61736900 	cmnvs	r3, r0, lsl #18
    1470:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1474:	6d77695f 			; <UNDEFINED> instruction: 0x6d77695f
    1478:	0074786d 	rsbseq	r7, r4, sp, ror #16
    147c:	58435046 	stmdapl	r3, {r1, r2, r6, ip, lr}^
    1480:	455f5354 	ldrbmi	r5, [pc, #-852]	; 1134 <shift+0x1134>
    1484:	004d554e 	subeq	r5, sp, lr, asr #10
    1488:	5f617369 	svcpl	0x00617369
    148c:	5f746962 	svcpl	0x00746962
    1490:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    1494:	73690036 	cmnvc	r9, #54	; 0x36
    1498:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    149c:	766d5f74 	uqsub16vc	r5, sp, r4
    14a0:	73690065 	cmnvc	r9, #101	; 0x65
    14a4:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    14a8:	77695f74 			; <UNDEFINED> instruction: 0x77695f74
    14ac:	74786d6d 	ldrbtvc	r6, [r8], #-3437	; 0xfffff293
    14b0:	73690032 	cmnvc	r9, #50	; 0x32
    14b4:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    14b8:	64635f74 	strbtvs	r5, [r3], #-3956	; 0xfffff08c
    14bc:	30706365 	rsbscc	r6, r0, r5, ror #6
    14c0:	61736900 	cmnvs	r3, r0, lsl #18
    14c4:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    14c8:	6564635f 	strbvs	r6, [r4, #-863]!	; 0xfffffca1
    14cc:	00317063 	eorseq	r7, r1, r3, rrx
    14d0:	5f617369 	svcpl	0x00617369
    14d4:	5f746962 	svcpl	0x00746962
    14d8:	63656463 	cmnvs	r5, #1660944384	; 0x63000000
    14dc:	69003270 	stmdbvs	r0, {r4, r5, r6, r9, ip, sp}
    14e0:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    14e4:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
    14e8:	70636564 	rsbvc	r6, r3, r4, ror #10
    14ec:	73690033 	cmnvc	r9, #51	; 0x33
    14f0:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    14f4:	64635f74 	strbtvs	r5, [r3], #-3956	; 0xfffff08c
    14f8:	34706365 	ldrbtcc	r6, [r0], #-869	; 0xfffffc9b
    14fc:	61736900 	cmnvs	r3, r0, lsl #18
    1500:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1504:	5f70665f 	svcpl	0x0070665f
    1508:	006c6264 	rsbeq	r6, ip, r4, ror #4
    150c:	5f617369 	svcpl	0x00617369
    1510:	5f746962 	svcpl	0x00746962
    1514:	63656463 	cmnvs	r5, #1660944384	; 0x63000000
    1518:	69003670 	stmdbvs	r0, {r4, r5, r6, r9, sl, ip, sp}
    151c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1520:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
    1524:	70636564 	rsbvc	r6, r3, r4, ror #10
    1528:	73690037 	cmnvc	r9, #55	; 0x37
    152c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1530:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    1534:	6b36766d 	blvs	d9eef0 <__bss_end+0xd953b0>
    1538:	61736900 	cmnvs	r3, r0, lsl #18
    153c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1540:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1544:	315f3876 	cmpcc	pc, r6, ror r8	; <UNPREDICTABLE>
    1548:	616d5f6d 	cmnvs	sp, sp, ror #30
    154c:	61006e69 	tstvs	r0, r9, ror #28
    1550:	0065746e 	rsbeq	r7, r5, lr, ror #8
    1554:	5f617369 	svcpl	0x00617369
    1558:	5f746962 	svcpl	0x00746962
    155c:	65736d63 	ldrbvs	r6, [r3, #-3427]!	; 0xfffff29d
    1560:	6e6f6c00 	cdpvs	12, 6, cr6, cr15, cr0, {0}
    1564:	6f642067 	svcvs	0x00642067
    1568:	656c6275 	strbvs	r6, [ip, #-629]!	; 0xfffffd8b
    156c:	2f2e2e00 	svccs	0x002e2e00
    1570:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1574:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1578:	2f2e2e2f 	svccs	0x002e2e2f
    157c:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; 14cc <shift+0x14cc>
    1580:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    1584:	696c2f63 	stmdbvs	ip!, {r0, r1, r5, r6, r8, r9, sl, fp, sp}^
    1588:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    158c:	00632e32 	rsbeq	r2, r3, r2, lsr lr
    1590:	5f617369 	svcpl	0x00617369
    1594:	5f746962 	svcpl	0x00746962
    1598:	35767066 	ldrbcc	r7, [r6, #-102]!	; 0xffffff9a
    159c:	61736900 	cmnvs	r3, r0, lsl #18
    15a0:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    15a4:	6373785f 	cmnvs	r3, #6225920	; 0x5f0000
    15a8:	00656c61 	rsbeq	r6, r5, r1, ror #24
    15ac:	676e6f6c 	strbvs	r6, [lr, -ip, ror #30]!
    15b0:	6e6f6c20 	cdpvs	12, 6, cr6, cr15, cr0, {1}
    15b4:	6e752067 	cdpvs	0, 7, cr2, cr5, cr7, {3}
    15b8:	6e676973 			; <UNDEFINED> instruction: 0x6e676973
    15bc:	69206465 	stmdbvs	r0!, {r0, r2, r5, r6, sl, sp, lr}
    15c0:	6900746e 	stmdbvs	r0, {r1, r2, r3, r5, r6, sl, ip, sp, lr}
    15c4:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    15c8:	715f7469 	cmpvc	pc, r9, ror #8
    15cc:	6b726975 	blvs	1c9bba8 <__bss_end+0x1c92068>
    15d0:	336d635f 	cmncc	sp, #2080374785	; 0x7c000001
    15d4:	72646c5f 	rsbvc	r6, r4, #24320	; 0x5f00
    15d8:	73690064 	cmnvc	r9, #100	; 0x64
    15dc:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    15e0:	38695f74 	stmdacc	r9!, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    15e4:	69006d6d 	stmdbvs	r0, {r0, r2, r3, r5, r6, r8, sl, fp, sp, lr}
    15e8:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    15ec:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
    15f0:	33645f70 	cmncc	r4, #112, 30	; 0x1c0
    15f4:	73690032 	cmnvc	r9, #50	; 0x32
    15f8:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    15fc:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    1600:	6537766d 	ldrvs	r7, [r7, #-1645]!	; 0xfffff993
    1604:	7369006d 	cmnvc	r9, #109	; 0x6d
    1608:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    160c:	706c5f74 	rsbvc	r5, ip, r4, ror pc
    1610:	61006561 	tstvs	r0, r1, ror #10
    1614:	695f6c6c 	ldmdbvs	pc, {r2, r3, r5, r6, sl, fp, sp, lr}^	; <UNPREDICTABLE>
    1618:	696c706d 	stmdbvs	ip!, {r0, r2, r3, r5, r6, ip, sp, lr}^
    161c:	665f6465 	ldrbvs	r6, [pc], -r5, ror #8
    1620:	73746962 	cmnvc	r4, #1605632	; 0x188000
    1624:	61736900 	cmnvs	r3, r0, lsl #18
    1628:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    162c:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1630:	315f3876 	cmpcc	pc, r6, ror r8	; <UNPREDICTABLE>
    1634:	61736900 	cmnvs	r3, r0, lsl #18
    1638:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    163c:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1640:	325f3876 	subscc	r3, pc, #7733248	; 0x760000
    1644:	61736900 	cmnvs	r3, r0, lsl #18
    1648:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    164c:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1650:	335f3876 	cmpcc	pc, #7733248	; 0x760000
    1654:	61736900 	cmnvs	r3, r0, lsl #18
    1658:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    165c:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1660:	345f3876 	ldrbcc	r3, [pc], #-2166	; 1668 <shift+0x1668>
    1664:	61736900 	cmnvs	r3, r0, lsl #18
    1668:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    166c:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1670:	355f3876 	ldrbcc	r3, [pc, #-2166]	; e02 <shift+0xe02>
    1674:	61736900 	cmnvs	r3, r0, lsl #18
    1678:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    167c:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1680:	365f3876 			; <UNDEFINED> instruction: 0x365f3876
    1684:	61736900 	cmnvs	r3, r0, lsl #18
    1688:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    168c:	0062735f 	rsbeq	r7, r2, pc, asr r3
    1690:	5f617369 	svcpl	0x00617369
    1694:	5f6d756e 	svcpl	0x006d756e
    1698:	73746962 	cmnvc	r4, #1605632	; 0x188000
    169c:	61736900 	cmnvs	r3, r0, lsl #18
    16a0:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    16a4:	616d735f 	cmnvs	sp, pc, asr r3
    16a8:	756d6c6c 	strbvc	r6, [sp, #-3180]!	; 0xfffff394
    16ac:	7566006c 	strbvc	r0, [r6, #-108]!	; 0xffffff94
    16b0:	705f636e 	subsvc	r6, pc, lr, ror #6
    16b4:	63007274 	movwvs	r7, #628	; 0x274
    16b8:	6c706d6f 	ldclvs	13, cr6, [r0], #-444	; 0xfffffe44
    16bc:	64207865 	strtvs	r7, [r0], #-2149	; 0xfffff79b
    16c0:	6c62756f 	cfstr64vs	mvdx7, [r2], #-444	; 0xfffffe44
    16c4:	424e0065 	submi	r0, lr, #101	; 0x65
    16c8:	5f50465f 	svcpl	0x0050465f
    16cc:	52535953 	subspl	r5, r3, #1359872	; 0x14c000
    16d0:	00534745 	subseq	r4, r3, r5, asr #14
    16d4:	5f617369 	svcpl	0x00617369
    16d8:	5f746962 	svcpl	0x00746962
    16dc:	63656463 	cmnvs	r5, #1660944384	; 0x63000000
    16e0:	69003570 	stmdbvs	r0, {r4, r5, r6, r8, sl, ip, sp}
    16e4:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    16e8:	765f7469 	ldrbvc	r7, [pc], -r9, ror #8
    16ec:	32767066 	rsbscc	r7, r6, #102	; 0x66
    16f0:	61736900 	cmnvs	r3, r0, lsl #18
    16f4:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    16f8:	7066765f 	rsbvc	r7, r6, pc, asr r6
    16fc:	69003376 	stmdbvs	r0, {r1, r2, r4, r5, r6, r8, r9, ip, sp}
    1700:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1704:	765f7469 	ldrbvc	r7, [pc], -r9, ror #8
    1708:	34767066 	ldrbtcc	r7, [r6], #-102	; 0xffffff9a
    170c:	43504600 	cmpmi	r0, #0, 12
    1710:	534e5458 	movtpl	r5, #58456	; 0xe458
    1714:	554e455f 	strbpl	r4, [lr, #-1375]	; 0xfffffaa1
    1718:	7369004d 	cmnvc	r9, #77	; 0x4d
    171c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1720:	68745f74 	ldmdavs	r4!, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    1724:	00626d75 	rsbeq	r6, r2, r5, ror sp
    1728:	5f617369 	svcpl	0x00617369
    172c:	5f746962 	svcpl	0x00746962
    1730:	36317066 	ldrtcc	r7, [r1], -r6, rrx
    1734:	766e6f63 	strbtvc	r6, [lr], -r3, ror #30
    1738:	61736900 	cmnvs	r3, r0, lsl #18
    173c:	6165665f 	cmnvs	r5, pc, asr r6
    1740:	65727574 	ldrbvs	r7, [r2, #-1396]!	; 0xfffffa8c
    1744:	61736900 	cmnvs	r3, r0, lsl #18
    1748:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    174c:	746f6e5f 	strbtvc	r6, [pc], #-3679	; 1754 <shift+0x1754>
    1750:	7369006d 	cmnvc	r9, #109	; 0x6d
    1754:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1758:	75715f74 	ldrbvc	r5, [r1, #-3956]!	; 0xfffff08c
    175c:	5f6b7269 	svcpl	0x006b7269
    1760:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    1764:	007a6b36 	rsbseq	r6, sl, r6, lsr fp
    1768:	5f617369 	svcpl	0x00617369
    176c:	5f746962 	svcpl	0x00746962
    1770:	33637263 	cmncc	r3, #805306374	; 0x30000006
    1774:	73690032 	cmnvc	r9, #50	; 0x32
    1778:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    177c:	75715f74 	ldrbvc	r5, [r1, #-3956]!	; 0xfffff08c
    1780:	5f6b7269 	svcpl	0x006b7269
    1784:	615f6f6e 	cmpvs	pc, lr, ror #30
    1788:	70636d73 	rsbvc	r6, r3, r3, ror sp
    178c:	73690075 	cmnvc	r9, #117	; 0x75
    1790:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1794:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    1798:	0034766d 	eorseq	r7, r4, sp, ror #12
    179c:	5f617369 	svcpl	0x00617369
    17a0:	5f746962 	svcpl	0x00746962
    17a4:	6d756874 	ldclvs	8, cr6, [r5, #-464]!	; 0xfffffe30
    17a8:	69003262 	stmdbvs	r0, {r1, r5, r6, r9, ip, sp}
    17ac:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    17b0:	625f7469 	subsvs	r7, pc, #1761607680	; 0x69000000
    17b4:	69003865 	stmdbvs	r0, {r0, r2, r5, r6, fp, ip, sp}
    17b8:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    17bc:	615f7469 	cmpvs	pc, r9, ror #8
    17c0:	37766d72 			; <UNDEFINED> instruction: 0x37766d72
    17c4:	61736900 	cmnvs	r3, r0, lsl #18
    17c8:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    17cc:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    17d0:	76003876 			; <UNDEFINED> instruction: 0x76003876
    17d4:	735f7066 	cmpvc	pc, #102	; 0x66
    17d8:	65727379 	ldrbvs	r7, [r2, #-889]!	; 0xfffffc87
    17dc:	655f7367 	ldrbvs	r7, [pc, #-871]	; 147d <shift+0x147d>
    17e0:	646f636e 	strbtvs	r6, [pc], #-878	; 17e8 <shift+0x17e8>
    17e4:	00676e69 	rsbeq	r6, r7, r9, ror #28
    17e8:	5f617369 	svcpl	0x00617369
    17ec:	5f746962 	svcpl	0x00746962
    17f0:	36317066 	ldrtcc	r7, [r1], -r6, rrx
    17f4:	006c6d66 	rsbeq	r6, ip, r6, ror #26
    17f8:	5f617369 	svcpl	0x00617369
    17fc:	5f746962 	svcpl	0x00746962
    1800:	70746f64 	rsbsvc	r6, r4, r4, ror #30
    1804:	00646f72 	rsbeq	r6, r4, r2, ror pc
    1808:	69665f5f 	stmdbvs	r6!, {r0, r1, r2, r3, r4, r6, r8, r9, sl, fp, ip, lr}^
    180c:	736e7578 	cmnvc	lr, #120, 10	; 0x1e000000
    1810:	69646673 	stmdbvs	r4!, {r0, r1, r4, r5, r6, r9, sl, sp, lr}^
    1814:	74465300 	strbvc	r5, [r6], #-768	; 0xfffffd00
    1818:	00657079 	rsbeq	r7, r5, r9, ror r0
    181c:	65615f5f 	strbvs	r5, [r1, #-3935]!	; 0xfffff0a1
    1820:	5f696261 	svcpl	0x00696261
    1824:	6c753266 	lfmvs	f3, 2, [r5], #-408	; 0xfffffe68
    1828:	5f5f007a 	svcpl	0x005f007a
    182c:	73786966 	cmnvc	r8, #1671168	; 0x198000
    1830:	00696466 	rsbeq	r6, r9, r6, ror #8
    1834:	79744644 	ldmdbvc	r4!, {r2, r6, r9, sl, lr}^
    1838:	55006570 	strpl	r6, [r0, #-1392]	; 0xfffffa90
    183c:	79744953 	ldmdbvc	r4!, {r0, r1, r4, r6, r8, fp, lr}^
    1840:	55006570 	strpl	r6, [r0, #-1392]	; 0xfffffa90
    1844:	79744944 	ldmdbvc	r4!, {r2, r6, r8, fp, lr}^
    1848:	47006570 	smlsdxmi	r0, r0, r5, r6
    184c:	4320554e 			; <UNDEFINED> instruction: 0x4320554e
    1850:	31203731 			; <UNDEFINED> instruction: 0x31203731
    1854:	2e332e30 	mrccs	14, 1, r2, cr3, cr0, {1}
    1858:	30322031 	eorscc	r2, r2, r1, lsr r0
    185c:	36303132 			; <UNDEFINED> instruction: 0x36303132
    1860:	28203132 	stmdacs	r0!, {r1, r4, r5, r8, ip, sp}
    1864:	656c6572 	strbvs	r6, [ip, #-1394]!	; 0xfffffa8e
    1868:	29657361 	stmdbcs	r5!, {r0, r5, r6, r8, r9, ip, sp, lr}^
    186c:	616d2d20 	cmnvs	sp, r0, lsr #26
    1870:	2d206d72 	stccs	13, cr6, [r0, #-456]!	; 0xfffffe38
    1874:	6f6c666d 	svcvs	0x006c666d
    1878:	612d7461 			; <UNDEFINED> instruction: 0x612d7461
    187c:	683d6962 	ldmdavs	sp!, {r1, r5, r6, r8, fp, sp, lr}
    1880:	20647261 	rsbcs	r7, r4, r1, ror #4
    1884:	72616d2d 	rsbvc	r6, r1, #2880	; 0xb40
    1888:	613d6863 	teqvs	sp, r3, ror #16
    188c:	35766d72 	ldrbcc	r6, [r6, #-3442]!	; 0xfffff28e
    1890:	662b6574 			; <UNDEFINED> instruction: 0x662b6574
    1894:	672d2070 			; <UNDEFINED> instruction: 0x672d2070
    1898:	20672d20 	rsbcs	r2, r7, r0, lsr #26
    189c:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
    18a0:	2d20324f 	sfmcs	f3, 4, [r0, #-316]!	; 0xfffffec4
    18a4:	2d20324f 	sfmcs	f3, 4, [r0, #-316]!	; 0xfffffec4
    18a8:	2d20324f 	sfmcs	f3, 4, [r0, #-316]!	; 0xfffffec4
    18ac:	69756266 	ldmdbvs	r5!, {r1, r2, r5, r6, r9, sp, lr}^
    18b0:	6e69646c 	cdpvs	4, 6, cr6, cr9, cr12, {3}
    18b4:	696c2d67 	stmdbvs	ip!, {r0, r1, r2, r5, r6, r8, sl, fp, sp}^
    18b8:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    18bc:	6e662d20 	cdpvs	13, 6, cr2, cr6, cr0, {1}
    18c0:	74732d6f 	ldrbtvc	r2, [r3], #-3439	; 0xfffff291
    18c4:	2d6b6361 	stclcs	3, cr6, [fp, #-388]!	; 0xfffffe7c
    18c8:	746f7270 	strbtvc	r7, [pc], #-624	; 18d0 <shift+0x18d0>
    18cc:	6f746365 	svcvs	0x00746365
    18d0:	662d2072 			; <UNDEFINED> instruction: 0x662d2072
    18d4:	692d6f6e 	pushvs	{r1, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}
    18d8:	6e696c6e 	cdpvs	12, 6, cr6, cr9, cr14, {3}
    18dc:	662d2065 	strtvs	r2, [sp], -r5, rrx
    18e0:	65637865 	strbvs	r7, [r3, #-2149]!	; 0xfffff79b
    18e4:	6f697470 	svcvs	0x00697470
    18e8:	2d20736e 	stccs	3, cr7, [r0, #-440]!	; 0xfffffe48
    18ec:	73697666 	cmnvc	r9, #106954752	; 0x6600000
    18f0:	6c696269 	sfmvs	f6, 2, [r9], #-420	; 0xfffffe5c
    18f4:	3d797469 	cfldrdcc	mvd7, [r9, #-420]!	; 0xfffffe5c
    18f8:	64646968 	strbtvs	r6, [r4], #-2408	; 0xfffff698
    18fc:	5f006e65 	svcpl	0x00006e65
    1900:	6964755f 	stmdbvs	r4!, {r0, r1, r2, r3, r4, r6, r8, sl, ip, sp, lr}^
    1904:	646f6d76 	strbtvs	r6, [pc], #-3446	; 190c <shift+0x190c>
    1908:	00346964 	eorseq	r6, r4, r4, ror #18

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
  20:	8b040e42 	blhi	103930 <__bss_end+0xf9df0>
  24:	0b0d4201 	bleq	350830 <__bss_end+0x346cf0>
  28:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
  2c:	00000ecb 	andeq	r0, r0, fp, asr #29
  30:	0000001c 	andeq	r0, r0, ip, lsl r0
  34:	00000000 	andeq	r0, r0, r0
  38:	00008064 	andeq	r8, r0, r4, rrx
  3c:	00000040 	andeq	r0, r0, r0, asr #32
  40:	8b080e42 	blhi	203950 <__bss_end+0x1f9e10>
  44:	42018e02 	andmi	r8, r1, #2, 28
  48:	5a040b0c 	bpl	102c80 <__bss_end+0xf9140>
  4c:	00080d0c 	andeq	r0, r8, ip, lsl #26
  50:	0000000c 	andeq	r0, r0, ip
  54:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
  58:	7c020001 	stcvc	0, cr0, [r2], {1}
  5c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
  60:	0000001c 	andeq	r0, r0, ip, lsl r0
  64:	00000050 	andeq	r0, r0, r0, asr r0
  68:	000080a4 	andeq	r8, r0, r4, lsr #1
  6c:	00000038 	andeq	r0, r0, r8, lsr r0
  70:	8b040e42 	blhi	103980 <__bss_end+0xf9e40>
  74:	0b0d4201 	bleq	350880 <__bss_end+0x346d40>
  78:	420d0d54 	andmi	r0, sp, #84, 26	; 0x1500
  7c:	00000ecb 	andeq	r0, r0, fp, asr #29
  80:	0000001c 	andeq	r0, r0, ip, lsl r0
  84:	00000050 	andeq	r0, r0, r0, asr r0
  88:	000080dc 	ldrdeq	r8, [r0], -ip
  8c:	0000002c 	andeq	r0, r0, ip, lsr #32
  90:	8b040e42 	blhi	1039a0 <__bss_end+0xf9e60>
  94:	0b0d4201 	bleq	3508a0 <__bss_end+0x346d60>
  98:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
  9c:	00000ecb 	andeq	r0, r0, fp, asr #29
  a0:	0000001c 	andeq	r0, r0, ip, lsl r0
  a4:	00000050 	andeq	r0, r0, r0, asr r0
  a8:	00008108 	andeq	r8, r0, r8, lsl #2
  ac:	00000020 	andeq	r0, r0, r0, lsr #32
  b0:	8b040e42 	blhi	1039c0 <__bss_end+0xf9e80>
  b4:	0b0d4201 	bleq	3508c0 <__bss_end+0x346d80>
  b8:	420d0d48 	andmi	r0, sp, #72, 26	; 0x1200
  bc:	00000ecb 	andeq	r0, r0, fp, asr #29
  c0:	0000001c 	andeq	r0, r0, ip, lsl r0
  c4:	00000050 	andeq	r0, r0, r0, asr r0
  c8:	00008128 	andeq	r8, r0, r8, lsr #2
  cc:	00000018 	andeq	r0, r0, r8, lsl r0
  d0:	8b040e42 	blhi	1039e0 <__bss_end+0xf9ea0>
  d4:	0b0d4201 	bleq	3508e0 <__bss_end+0x346da0>
  d8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  dc:	00000ecb 	andeq	r0, r0, fp, asr #29
  e0:	0000001c 	andeq	r0, r0, ip, lsl r0
  e4:	00000050 	andeq	r0, r0, r0, asr r0
  e8:	00008140 	andeq	r8, r0, r0, asr #2
  ec:	00000018 	andeq	r0, r0, r8, lsl r0
  f0:	8b040e42 	blhi	103a00 <__bss_end+0xf9ec0>
  f4:	0b0d4201 	bleq	350900 <__bss_end+0x346dc0>
  f8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  fc:	00000ecb 	andeq	r0, r0, fp, asr #29
 100:	0000001c 	andeq	r0, r0, ip, lsl r0
 104:	00000050 	andeq	r0, r0, r0, asr r0
 108:	00008158 	andeq	r8, r0, r8, asr r1
 10c:	00000018 	andeq	r0, r0, r8, lsl r0
 110:	8b040e42 	blhi	103a20 <__bss_end+0xf9ee0>
 114:	0b0d4201 	bleq	350920 <__bss_end+0x346de0>
 118:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
 11c:	00000ecb 	andeq	r0, r0, fp, asr #29
 120:	00000014 	andeq	r0, r0, r4, lsl r0
 124:	00000050 	andeq	r0, r0, r0, asr r0
 128:	00008170 	andeq	r8, r0, r0, ror r1
 12c:	0000000c 	andeq	r0, r0, ip
 130:	8b040e42 	blhi	103a40 <__bss_end+0xf9f00>
 134:	0b0d4201 	bleq	350940 <__bss_end+0x346e00>
 138:	0000001c 	andeq	r0, r0, ip, lsl r0
 13c:	00000050 	andeq	r0, r0, r0, asr r0
 140:	0000817c 	andeq	r8, r0, ip, ror r1
 144:	00000058 	andeq	r0, r0, r8, asr r0
 148:	8b080e42 	blhi	203a58 <__bss_end+0x1f9f18>
 14c:	42018e02 	andmi	r8, r1, #2, 28
 150:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 154:	00080d0c 	andeq	r0, r8, ip, lsl #26
 158:	0000001c 	andeq	r0, r0, ip, lsl r0
 15c:	00000050 	andeq	r0, r0, r0, asr r0
 160:	000081d4 	ldrdeq	r8, [r0], -r4
 164:	00000058 	andeq	r0, r0, r8, asr r0
 168:	8b080e42 	blhi	203a78 <__bss_end+0x1f9f38>
 16c:	42018e02 	andmi	r8, r1, #2, 28
 170:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 174:	00080d0c 	andeq	r0, r8, ip, lsl #26
 178:	0000000c 	andeq	r0, r0, ip
 17c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 180:	7c020001 	stcvc	0, cr0, [r2], {1}
 184:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 188:	00000018 	andeq	r0, r0, r8, lsl r0
 18c:	00000178 	andeq	r0, r0, r8, ror r1
 190:	0000822c 	andeq	r8, r0, ip, lsr #4
 194:	000000dc 	ldrdeq	r0, [r0], -ip
 198:	8b080e42 	blhi	203aa8 <__bss_end+0x1f9f68>
 19c:	42018e02 	andmi	r8, r1, #2, 28
 1a0:	00040b0c 	andeq	r0, r4, ip, lsl #22
 1a4:	0000000c 	andeq	r0, r0, ip
 1a8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 1ac:	7c020001 	stcvc	0, cr0, [r2], {1}
 1b0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 1b4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1b8:	000001a4 	andeq	r0, r0, r4, lsr #3
 1bc:	00008308 	andeq	r8, r0, r8, lsl #6
 1c0:	0000002c 	andeq	r0, r0, ip, lsr #32
 1c4:	8b040e42 	blhi	103ad4 <__bss_end+0xf9f94>
 1c8:	0b0d4201 	bleq	3509d4 <__bss_end+0x346e94>
 1cc:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 1d0:	00000ecb 	andeq	r0, r0, fp, asr #29
 1d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1d8:	000001a4 	andeq	r0, r0, r4, lsr #3
 1dc:	00008334 	andeq	r8, r0, r4, lsr r3
 1e0:	0000002c 	andeq	r0, r0, ip, lsr #32
 1e4:	8b040e42 	blhi	103af4 <__bss_end+0xf9fb4>
 1e8:	0b0d4201 	bleq	3509f4 <__bss_end+0x346eb4>
 1ec:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 1f0:	00000ecb 	andeq	r0, r0, fp, asr #29
 1f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1f8:	000001a4 	andeq	r0, r0, r4, lsr #3
 1fc:	00008360 	andeq	r8, r0, r0, ror #6
 200:	0000001c 	andeq	r0, r0, ip, lsl r0
 204:	8b040e42 	blhi	103b14 <__bss_end+0xf9fd4>
 208:	0b0d4201 	bleq	350a14 <__bss_end+0x346ed4>
 20c:	420d0d46 	andmi	r0, sp, #4480	; 0x1180
 210:	00000ecb 	andeq	r0, r0, fp, asr #29
 214:	0000001c 	andeq	r0, r0, ip, lsl r0
 218:	000001a4 	andeq	r0, r0, r4, lsr #3
 21c:	0000837c 	andeq	r8, r0, ip, ror r3
 220:	00000044 	andeq	r0, r0, r4, asr #32
 224:	8b040e42 	blhi	103b34 <__bss_end+0xf9ff4>
 228:	0b0d4201 	bleq	350a34 <__bss_end+0x346ef4>
 22c:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 230:	00000ecb 	andeq	r0, r0, fp, asr #29
 234:	0000001c 	andeq	r0, r0, ip, lsl r0
 238:	000001a4 	andeq	r0, r0, r4, lsr #3
 23c:	000083c0 	andeq	r8, r0, r0, asr #7
 240:	00000050 	andeq	r0, r0, r0, asr r0
 244:	8b040e42 	blhi	103b54 <__bss_end+0xfa014>
 248:	0b0d4201 	bleq	350a54 <__bss_end+0x346f14>
 24c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 250:	00000ecb 	andeq	r0, r0, fp, asr #29
 254:	0000001c 	andeq	r0, r0, ip, lsl r0
 258:	000001a4 	andeq	r0, r0, r4, lsr #3
 25c:	00008410 	andeq	r8, r0, r0, lsl r4
 260:	00000050 	andeq	r0, r0, r0, asr r0
 264:	8b040e42 	blhi	103b74 <__bss_end+0xfa034>
 268:	0b0d4201 	bleq	350a74 <__bss_end+0x346f34>
 26c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 270:	00000ecb 	andeq	r0, r0, fp, asr #29
 274:	0000001c 	andeq	r0, r0, ip, lsl r0
 278:	000001a4 	andeq	r0, r0, r4, lsr #3
 27c:	00008460 	andeq	r8, r0, r0, ror #8
 280:	0000002c 	andeq	r0, r0, ip, lsr #32
 284:	8b040e42 	blhi	103b94 <__bss_end+0xfa054>
 288:	0b0d4201 	bleq	350a94 <__bss_end+0x346f54>
 28c:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 290:	00000ecb 	andeq	r0, r0, fp, asr #29
 294:	0000001c 	andeq	r0, r0, ip, lsl r0
 298:	000001a4 	andeq	r0, r0, r4, lsr #3
 29c:	0000848c 	andeq	r8, r0, ip, lsl #9
 2a0:	00000050 	andeq	r0, r0, r0, asr r0
 2a4:	8b040e42 	blhi	103bb4 <__bss_end+0xfa074>
 2a8:	0b0d4201 	bleq	350ab4 <__bss_end+0x346f74>
 2ac:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 2b0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2b4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2b8:	000001a4 	andeq	r0, r0, r4, lsr #3
 2bc:	000084dc 	ldrdeq	r8, [r0], -ip
 2c0:	00000044 	andeq	r0, r0, r4, asr #32
 2c4:	8b040e42 	blhi	103bd4 <__bss_end+0xfa094>
 2c8:	0b0d4201 	bleq	350ad4 <__bss_end+0x346f94>
 2cc:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 2d0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2d8:	000001a4 	andeq	r0, r0, r4, lsr #3
 2dc:	00008520 	andeq	r8, r0, r0, lsr #10
 2e0:	00000050 	andeq	r0, r0, r0, asr r0
 2e4:	8b040e42 	blhi	103bf4 <__bss_end+0xfa0b4>
 2e8:	0b0d4201 	bleq	350af4 <__bss_end+0x346fb4>
 2ec:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 2f0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2f8:	000001a4 	andeq	r0, r0, r4, lsr #3
 2fc:	00008570 	andeq	r8, r0, r0, ror r5
 300:	00000054 	andeq	r0, r0, r4, asr r0
 304:	8b040e42 	blhi	103c14 <__bss_end+0xfa0d4>
 308:	0b0d4201 	bleq	350b14 <__bss_end+0x346fd4>
 30c:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 310:	00000ecb 	andeq	r0, r0, fp, asr #29
 314:	0000001c 	andeq	r0, r0, ip, lsl r0
 318:	000001a4 	andeq	r0, r0, r4, lsr #3
 31c:	000085c4 	andeq	r8, r0, r4, asr #11
 320:	0000003c 	andeq	r0, r0, ip, lsr r0
 324:	8b040e42 	blhi	103c34 <__bss_end+0xfa0f4>
 328:	0b0d4201 	bleq	350b34 <__bss_end+0x346ff4>
 32c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 330:	00000ecb 	andeq	r0, r0, fp, asr #29
 334:	0000001c 	andeq	r0, r0, ip, lsl r0
 338:	000001a4 	andeq	r0, r0, r4, lsr #3
 33c:	00008600 	andeq	r8, r0, r0, lsl #12
 340:	0000003c 	andeq	r0, r0, ip, lsr r0
 344:	8b040e42 	blhi	103c54 <__bss_end+0xfa114>
 348:	0b0d4201 	bleq	350b54 <__bss_end+0x347014>
 34c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 350:	00000ecb 	andeq	r0, r0, fp, asr #29
 354:	0000001c 	andeq	r0, r0, ip, lsl r0
 358:	000001a4 	andeq	r0, r0, r4, lsr #3
 35c:	0000863c 	andeq	r8, r0, ip, lsr r6
 360:	0000003c 	andeq	r0, r0, ip, lsr r0
 364:	8b040e42 	blhi	103c74 <__bss_end+0xfa134>
 368:	0b0d4201 	bleq	350b74 <__bss_end+0x347034>
 36c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 370:	00000ecb 	andeq	r0, r0, fp, asr #29
 374:	0000001c 	andeq	r0, r0, ip, lsl r0
 378:	000001a4 	andeq	r0, r0, r4, lsr #3
 37c:	00008678 	andeq	r8, r0, r8, ror r6
 380:	0000003c 	andeq	r0, r0, ip, lsr r0
 384:	8b040e42 	blhi	103c94 <__bss_end+0xfa154>
 388:	0b0d4201 	bleq	350b94 <__bss_end+0x347054>
 38c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 390:	00000ecb 	andeq	r0, r0, fp, asr #29
 394:	0000001c 	andeq	r0, r0, ip, lsl r0
 398:	000001a4 	andeq	r0, r0, r4, lsr #3
 39c:	000086b4 			; <UNDEFINED> instruction: 0x000086b4
 3a0:	000000b0 	strheq	r0, [r0], -r0	; <UNPREDICTABLE>
 3a4:	8b080e42 	blhi	203cb4 <__bss_end+0x1fa174>
 3a8:	42018e02 	andmi	r8, r1, #2, 28
 3ac:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 3b0:	080d0c50 	stmdaeq	sp, {r4, r6, sl, fp}
 3b4:	0000000c 	andeq	r0, r0, ip
 3b8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 3bc:	7c020001 	stcvc	0, cr0, [r2], {1}
 3c0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 3c4:	0000001c 	andeq	r0, r0, ip, lsl r0
 3c8:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 3cc:	00008768 	andeq	r8, r0, r8, ror #14
 3d0:	00000178 	andeq	r0, r0, r8, ror r1
 3d4:	8b080e42 	blhi	203ce4 <__bss_end+0x1fa1a4>
 3d8:	42018e02 	andmi	r8, r1, #2, 28
 3dc:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 3e0:	080d0cb4 	stmdaeq	sp, {r2, r4, r5, r7, sl, fp}
 3e4:	0000001c 	andeq	r0, r0, ip, lsl r0
 3e8:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 3ec:	000088e0 	andeq	r8, r0, r0, ror #17
 3f0:	0000009c 	muleq	r0, ip, r0
 3f4:	8b040e42 	blhi	103d04 <__bss_end+0xfa1c4>
 3f8:	0b0d4201 	bleq	350c04 <__bss_end+0x3470c4>
 3fc:	0d0d4602 	stceq	6, cr4, [sp, #-8]
 400:	000ecb42 	andeq	ip, lr, r2, asr #22
 404:	0000001c 	andeq	r0, r0, ip, lsl r0
 408:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 40c:	0000897c 	andeq	r8, r0, ip, ror r9
 410:	00000100 	andeq	r0, r0, r0, lsl #2
 414:	8b040e42 	blhi	103d24 <__bss_end+0xfa1e4>
 418:	0b0d4201 	bleq	350c24 <__bss_end+0x3470e4>
 41c:	0d0d7802 	stceq	8, cr7, [sp, #-8]
 420:	000ecb42 	andeq	ip, lr, r2, asr #22
 424:	0000001c 	andeq	r0, r0, ip, lsl r0
 428:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 42c:	00008a7c 	andeq	r8, r0, ip, ror sl
 430:	0000015c 	andeq	r0, r0, ip, asr r1
 434:	8b040e42 	blhi	103d44 <__bss_end+0xfa204>
 438:	0b0d4201 	bleq	350c44 <__bss_end+0x347104>
 43c:	0d0d9c02 	stceq	12, cr9, [sp, #-8]
 440:	000ecb42 	andeq	ip, lr, r2, asr #22
 444:	0000001c 	andeq	r0, r0, ip, lsl r0
 448:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 44c:	00008bd8 	ldrdeq	r8, [r0], -r8	; <UNPREDICTABLE>
 450:	000000c0 	andeq	r0, r0, r0, asr #1
 454:	8b040e42 	blhi	103d64 <__bss_end+0xfa224>
 458:	0b0d4201 	bleq	350c64 <__bss_end+0x347124>
 45c:	0d0d5802 	stceq	8, cr5, [sp, #-8]
 460:	000ecb42 	andeq	ip, lr, r2, asr #22
 464:	0000001c 	andeq	r0, r0, ip, lsl r0
 468:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 46c:	00008c98 	muleq	r0, r8, ip
 470:	000000ac 	andeq	r0, r0, ip, lsr #1
 474:	8b040e42 	blhi	103d84 <__bss_end+0xfa244>
 478:	0b0d4201 	bleq	350c84 <__bss_end+0x347144>
 47c:	0d0d4e02 	stceq	14, cr4, [sp, #-8]
 480:	000ecb42 	andeq	ip, lr, r2, asr #22
 484:	0000001c 	andeq	r0, r0, ip, lsl r0
 488:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 48c:	00008d44 	andeq	r8, r0, r4, asr #26
 490:	00000054 	andeq	r0, r0, r4, asr r0
 494:	8b040e42 	blhi	103da4 <__bss_end+0xfa264>
 498:	0b0d4201 	bleq	350ca4 <__bss_end+0x347164>
 49c:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 4a0:	00000ecb 	andeq	r0, r0, fp, asr #29
 4a4:	0000001c 	andeq	r0, r0, ip, lsl r0
 4a8:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 4ac:	00008d98 	muleq	r0, r8, sp
 4b0:	000000ac 	andeq	r0, r0, ip, lsr #1
 4b4:	8b080e42 	blhi	203dc4 <__bss_end+0x1fa284>
 4b8:	42018e02 	andmi	r8, r1, #2, 28
 4bc:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 4c0:	080d0c50 	stmdaeq	sp, {r4, r6, sl, fp}
 4c4:	0000001c 	andeq	r0, r0, ip, lsl r0
 4c8:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 4cc:	00008e44 	andeq	r8, r0, r4, asr #28
 4d0:	000000d8 	ldrdeq	r0, [r0], -r8
 4d4:	8b080e42 	blhi	203de4 <__bss_end+0x1fa2a4>
 4d8:	42018e02 	andmi	r8, r1, #2, 28
 4dc:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 4e0:	080d0c66 	stmdaeq	sp, {r1, r2, r5, r6, sl, fp}
 4e4:	0000001c 	andeq	r0, r0, ip, lsl r0
 4e8:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 4ec:	00008f1c 	andeq	r8, r0, ip, lsl pc
 4f0:	00000068 	andeq	r0, r0, r8, rrx
 4f4:	8b040e42 	blhi	103e04 <__bss_end+0xfa2c4>
 4f8:	0b0d4201 	bleq	350d04 <__bss_end+0x3471c4>
 4fc:	420d0d6c 	andmi	r0, sp, #108, 26	; 0x1b00
 500:	00000ecb 	andeq	r0, r0, fp, asr #29
 504:	0000001c 	andeq	r0, r0, ip, lsl r0
 508:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 50c:	00008f84 	andeq	r8, r0, r4, lsl #31
 510:	00000080 	andeq	r0, r0, r0, lsl #1
 514:	8b040e42 	blhi	103e24 <__bss_end+0xfa2e4>
 518:	0b0d4201 	bleq	350d24 <__bss_end+0x3471e4>
 51c:	420d0d78 	andmi	r0, sp, #120, 26	; 0x1e00
 520:	00000ecb 	andeq	r0, r0, fp, asr #29
 524:	0000001c 	andeq	r0, r0, ip, lsl r0
 528:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 52c:	00009004 	andeq	r9, r0, r4
 530:	00000068 	andeq	r0, r0, r8, rrx
 534:	8b040e42 	blhi	103e44 <__bss_end+0xfa304>
 538:	0b0d4201 	bleq	350d44 <__bss_end+0x347204>
 53c:	420d0d6c 	andmi	r0, sp, #108, 26	; 0x1b00
 540:	00000ecb 	andeq	r0, r0, fp, asr #29
 544:	0000002c 	andeq	r0, r0, ip, lsr #32
 548:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 54c:	0000906c 	andeq	r9, r0, ip, rrx
 550:	00000328 	andeq	r0, r0, r8, lsr #6
 554:	84200e42 	strthi	r0, [r0], #-3650	; 0xfffff1be
 558:	86078508 	strhi	r8, [r7], -r8, lsl #10
 55c:	88058706 	stmdahi	r5, {r1, r2, r8, r9, sl, pc}
 560:	8b038904 	blhi	e2978 <__bss_end+0xd8e38>
 564:	42018e02 	andmi	r8, r1, #2, 28
 568:	03040b0c 	movweq	r0, #19212	; 0x4b0c
 56c:	0d0c018a 	stfeqs	f0, [ip, #-552]	; 0xfffffdd8
 570:	00000020 	andeq	r0, r0, r0, lsr #32
 574:	0000000c 	andeq	r0, r0, ip
 578:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 57c:	7c010001 	stcvc	0, cr0, [r1], {1}
 580:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 584:	0000000c 	andeq	r0, r0, ip
 588:	00000574 	andeq	r0, r0, r4, ror r5
 58c:	00009394 	muleq	r0, r4, r3
 590:	000001ec 	andeq	r0, r0, ip, ror #3
 594:	0000000c 	andeq	r0, r0, ip
 598:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 59c:	7c020001 	stcvc	0, cr0, [r2], {1}
 5a0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 5a4:	00000010 	andeq	r0, r0, r0, lsl r0
 5a8:	00000594 	muleq	r0, r4, r5
 5ac:	000095a4 	andeq	r9, r0, r4, lsr #11
 5b0:	0000019c 	muleq	r0, ip, r1
 5b4:	0bce020a 	bleq	ff380de4 <__bss_end+0xff3772a4>
 5b8:	00000010 	andeq	r0, r0, r0, lsl r0
 5bc:	00000594 	muleq	r0, r4, r5
 5c0:	00009740 	andeq	r9, r0, r0, asr #14
 5c4:	00000028 	andeq	r0, r0, r8, lsr #32
 5c8:	000b540a 	andeq	r5, fp, sl, lsl #8
 5cc:	00000010 	andeq	r0, r0, r0, lsl r0
 5d0:	00000594 	muleq	r0, r4, r5
 5d4:	00009768 	andeq	r9, r0, r8, ror #14
 5d8:	0000008c 	andeq	r0, r0, ip, lsl #1
 5dc:	0b46020a 	bleq	1180e0c <__bss_end+0x11772cc>
 5e0:	0000000c 	andeq	r0, r0, ip
 5e4:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 5e8:	7c020001 	stcvc	0, cr0, [r2], {1}
 5ec:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 5f0:	00000030 	andeq	r0, r0, r0, lsr r0
 5f4:	000005e0 	andeq	r0, r0, r0, ror #11
 5f8:	000097f4 	strdeq	r9, [r0], -r4
 5fc:	000000d4 	ldrdeq	r0, [r0], -r4
 600:	8e100e5a 	mrchi	14, 0, r0, cr0, cr10, {2}
 604:	460a4a03 	strmi	r4, [sl], -r3, lsl #20
 608:	42100ece 	andsmi	r0, r0, #3296	; 0xce0
 60c:	460a4a0b 	strmi	r4, [sl], -fp, lsl #20
 610:	4a100ece 	bmi	404150 <__bss_end+0x3fa610>
 614:	460a460b 	strmi	r4, [sl], -fp, lsl #12
 618:	46100ece 	ldrmi	r0, [r0], -lr, asr #29
 61c:	0ece4c0b 	cdpeq	12, 12, cr4, cr14, cr11, {0}
 620:	00000010 	andeq	r0, r0, r0, lsl r0
 624:	0000000c 	andeq	r0, r0, ip
 628:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 62c:	7c020001 	stcvc	0, cr0, [r2], {1}
 630:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 634:	00000014 	andeq	r0, r0, r4, lsl r0
 638:	00000624 	andeq	r0, r0, r4, lsr #12
 63c:	000098c8 	andeq	r9, r0, r8, asr #17
 640:	00000030 	andeq	r0, r0, r0, lsr r0
 644:	84080e4e 	strhi	r0, [r8], #-3662	; 0xfffff1b2
 648:	00018e02 	andeq	r8, r1, r2, lsl #28
 64c:	0000000c 	andeq	r0, r0, ip
 650:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 654:	7c020001 	stcvc	0, cr0, [r2], {1}
 658:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 65c:	0000000c 	andeq	r0, r0, ip
 660:	0000064c 	andeq	r0, r0, ip, asr #12
 664:	000098f8 	strdeq	r9, [r0], -r8
 668:	00000040 	andeq	r0, r0, r0, asr #32
 66c:	0000000c 	andeq	r0, r0, ip
 670:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 674:	7c020001 	stcvc	0, cr0, [r2], {1}
 678:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 67c:	00000020 	andeq	r0, r0, r0, lsr #32
 680:	0000066c 	andeq	r0, r0, ip, ror #12
 684:	00009938 	andeq	r9, r0, r8, lsr r9
 688:	00000120 	andeq	r0, r0, r0, lsr #2
 68c:	841c0e46 	ldrhi	r0, [ip], #-3654	; 0xfffff1ba
 690:	86068507 	strhi	r8, [r6], -r7, lsl #10
 694:	88048705 	stmdahi	r4, {r0, r2, r8, r9, sl, pc}
 698:	8e028903 	vmlahi.f16	s16, s4, s6	; <UNPREDICTABLE>
 69c:	00000001 	andeq	r0, r0, r1

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

