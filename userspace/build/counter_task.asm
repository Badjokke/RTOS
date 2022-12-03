
./counter_task:     file format elf32-littlearm


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
    805c:	00009c18 	andeq	r9, r0, r8, lsl ip
    8060:	00009c28 	andeq	r9, r0, r8, lsr #24

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
    81cc:	00009c18 	andeq	r9, r0, r8, lsl ip
    81d0:	00009c18 	andeq	r9, r0, r8, lsl ip

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
    8224:	00009c18 	andeq	r9, r0, r8, lsl ip
    8228:	00009c18 	andeq	r9, r0, r8, lsl ip

0000822c <main>:
main():
/home/trefil/sem/sources/userspace/counter_task/main.cpp:17
 *  - vzestupne pokud je prepinac 1 v poloze "zapnuto", jinak sestupne
 *  - rychle pokud je prepinac 2 v poloze "zapnuto", jinak pomalu
 **/

int main(int argc, char** argv)
{
    822c:	e92d4800 	push	{fp, lr}
    8230:	e28db004 	add	fp, sp, #4
    8234:	e24dd020 	sub	sp, sp, #32
    8238:	e50b0020 	str	r0, [fp, #-32]	; 0xffffffe0
    823c:	e50b1024 	str	r1, [fp, #-36]	; 0xffffffdc
/home/trefil/sem/sources/userspace/counter_task/main.cpp:18
	uint32_t display_file = open("DEV:segd", NFile_Open_Mode::Write_Only);
    8240:	e3a01001 	mov	r1, #1
    8244:	e59f0164 	ldr	r0, [pc, #356]	; 83b0 <main+0x184>
    8248:	eb000079 	bl	8434 <_Z4openPKc15NFile_Open_Mode>
    824c:	e50b000c 	str	r0, [fp, #-12]
/home/trefil/sem/sources/userspace/counter_task/main.cpp:19
	uint32_t switch1_file = open("DEV:gpio/4", NFile_Open_Mode::Read_Only);
    8250:	e3a01000 	mov	r1, #0
    8254:	e59f0158 	ldr	r0, [pc, #344]	; 83b4 <main+0x188>
    8258:	eb000075 	bl	8434 <_Z4openPKc15NFile_Open_Mode>
    825c:	e50b0010 	str	r0, [fp, #-16]
/home/trefil/sem/sources/userspace/counter_task/main.cpp:20
	uint32_t switch2_file = open("DEV:gpio/17", NFile_Open_Mode::Read_Only);
    8260:	e3a01000 	mov	r1, #0
    8264:	e59f014c 	ldr	r0, [pc, #332]	; 83b8 <main+0x18c>
    8268:	eb000071 	bl	8434 <_Z4openPKc15NFile_Open_Mode>
    826c:	e50b0014 	str	r0, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/userspace/counter_task/main.cpp:22

	unsigned int counter = 0;
    8270:	e3a03000 	mov	r3, #0
    8274:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/userspace/counter_task/main.cpp:23
	bool fast = false;
    8278:	e3a03000 	mov	r3, #0
    827c:	e54b3015 	strb	r3, [fp, #-21]	; 0xffffffeb
/home/trefil/sem/sources/userspace/counter_task/main.cpp:24
	bool ascending = true;
    8280:	e3a03001 	mov	r3, #1
    8284:	e54b3016 	strb	r3, [fp, #-22]	; 0xffffffea
/home/trefil/sem/sources/userspace/counter_task/main.cpp:26

	set_task_deadline(fast ? 0x1000 : 0x2800);
    8288:	e55b3015 	ldrb	r3, [fp, #-21]	; 0xffffffeb
    828c:	e3530000 	cmp	r3, #0
    8290:	0a000001 	beq	829c <main+0x70>
/home/trefil/sem/sources/userspace/counter_task/main.cpp:26 (discriminator 1)
    8294:	e3a03a01 	mov	r3, #4096	; 0x1000
    8298:	ea000000 	b	82a0 <main+0x74>
/home/trefil/sem/sources/userspace/counter_task/main.cpp:26 (discriminator 2)
    829c:	e3a03b0a 	mov	r3, #10240	; 0x2800
/home/trefil/sem/sources/userspace/counter_task/main.cpp:26 (discriminator 4)
    82a0:	e1a00003 	mov	r0, r3
    82a4:	eb000112 	bl	86f4 <_Z17set_task_deadlinej>
/home/trefil/sem/sources/userspace/counter_task/main.cpp:30

	while (true)
	{
		char tmp = '0';
    82a8:	e3a03030 	mov	r3, #48	; 0x30
    82ac:	e54b3017 	strb	r3, [fp, #-23]	; 0xffffffe9
/home/trefil/sem/sources/userspace/counter_task/main.cpp:32

		read(switch1_file, &tmp, 1);
    82b0:	e24b3017 	sub	r3, fp, #23
    82b4:	e3a02001 	mov	r2, #1
    82b8:	e1a01003 	mov	r1, r3
    82bc:	e51b0010 	ldr	r0, [fp, #-16]
    82c0:	eb00006c 	bl	8478 <_Z4readjPcj>
/home/trefil/sem/sources/userspace/counter_task/main.cpp:33
		ascending = (tmp == '1');
    82c4:	e55b3017 	ldrb	r3, [fp, #-23]	; 0xffffffe9
    82c8:	e3530031 	cmp	r3, #49	; 0x31
    82cc:	03a03001 	moveq	r3, #1
    82d0:	13a03000 	movne	r3, #0
    82d4:	e54b3016 	strb	r3, [fp, #-22]	; 0xffffffea
/home/trefil/sem/sources/userspace/counter_task/main.cpp:35

		read(switch2_file, &tmp, 1);
    82d8:	e24b3017 	sub	r3, fp, #23
    82dc:	e3a02001 	mov	r2, #1
    82e0:	e1a01003 	mov	r1, r3
    82e4:	e51b0014 	ldr	r0, [fp, #-20]	; 0xffffffec
    82e8:	eb000062 	bl	8478 <_Z4readjPcj>
/home/trefil/sem/sources/userspace/counter_task/main.cpp:36
		fast = (tmp == '1');
    82ec:	e55b3017 	ldrb	r3, [fp, #-23]	; 0xffffffe9
    82f0:	e3530031 	cmp	r3, #49	; 0x31
    82f4:	03a03001 	moveq	r3, #1
    82f8:	13a03000 	movne	r3, #0
    82fc:	e54b3015 	strb	r3, [fp, #-21]	; 0xffffffeb
/home/trefil/sem/sources/userspace/counter_task/main.cpp:38

		if (ascending)
    8300:	e55b3016 	ldrb	r3, [fp, #-22]	; 0xffffffea
    8304:	e3530000 	cmp	r3, #0
    8308:	0a000003 	beq	831c <main+0xf0>
/home/trefil/sem/sources/userspace/counter_task/main.cpp:39
			counter++;
    830c:	e51b3008 	ldr	r3, [fp, #-8]
    8310:	e2833001 	add	r3, r3, #1
    8314:	e50b3008 	str	r3, [fp, #-8]
    8318:	ea000002 	b	8328 <main+0xfc>
/home/trefil/sem/sources/userspace/counter_task/main.cpp:41
		else
			counter--;
    831c:	e51b3008 	ldr	r3, [fp, #-8]
    8320:	e2433001 	sub	r3, r3, #1
    8324:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/userspace/counter_task/main.cpp:43

		tmp = '0' + (counter % 10);
    8328:	e51b1008 	ldr	r1, [fp, #-8]
    832c:	e59f3088 	ldr	r3, [pc, #136]	; 83bc <main+0x190>
    8330:	e0832193 	umull	r2, r3, r3, r1
    8334:	e1a021a3 	lsr	r2, r3, #3
    8338:	e1a03002 	mov	r3, r2
    833c:	e1a03103 	lsl	r3, r3, #2
    8340:	e0833002 	add	r3, r3, r2
    8344:	e1a03083 	lsl	r3, r3, #1
    8348:	e0412003 	sub	r2, r1, r3
    834c:	e6ef3072 	uxtb	r3, r2
    8350:	e2833030 	add	r3, r3, #48	; 0x30
    8354:	e6ef3073 	uxtb	r3, r3
    8358:	e54b3017 	strb	r3, [fp, #-23]	; 0xffffffe9
/home/trefil/sem/sources/userspace/counter_task/main.cpp:44
		write(display_file, &tmp, 1);
    835c:	e24b3017 	sub	r3, fp, #23
    8360:	e3a02001 	mov	r2, #1
    8364:	e1a01003 	mov	r1, r3
    8368:	e51b000c 	ldr	r0, [fp, #-12]
    836c:	eb000055 	bl	84c8 <_Z5writejPKcj>
/home/trefil/sem/sources/userspace/counter_task/main.cpp:46

		sleep(fast ? 0x400 : 0x600, fast ? 0x1000 : 0x2800);
    8370:	e55b3015 	ldrb	r3, [fp, #-21]	; 0xffffffeb
    8374:	e3530000 	cmp	r3, #0
    8378:	0a000001 	beq	8384 <main+0x158>
/home/trefil/sem/sources/userspace/counter_task/main.cpp:46 (discriminator 1)
    837c:	e3a02b01 	mov	r2, #1024	; 0x400
    8380:	ea000000 	b	8388 <main+0x15c>
/home/trefil/sem/sources/userspace/counter_task/main.cpp:46 (discriminator 2)
    8384:	e3a02c06 	mov	r2, #1536	; 0x600
/home/trefil/sem/sources/userspace/counter_task/main.cpp:46 (discriminator 4)
    8388:	e55b3015 	ldrb	r3, [fp, #-21]	; 0xffffffeb
    838c:	e3530000 	cmp	r3, #0
    8390:	0a000001 	beq	839c <main+0x170>
/home/trefil/sem/sources/userspace/counter_task/main.cpp:46 (discriminator 5)
    8394:	e3a03a01 	mov	r3, #4096	; 0x1000
    8398:	ea000000 	b	83a0 <main+0x174>
/home/trefil/sem/sources/userspace/counter_task/main.cpp:46 (discriminator 6)
    839c:	e3a03b0a 	mov	r3, #10240	; 0x2800
/home/trefil/sem/sources/userspace/counter_task/main.cpp:46 (discriminator 8)
    83a0:	e1a01003 	mov	r1, r3
    83a4:	e1a00002 	mov	r0, r2
    83a8:	eb00009e 	bl	8628 <_Z5sleepjj>
/home/trefil/sem/sources/userspace/counter_task/main.cpp:47 (discriminator 8)
	}
    83ac:	eaffffbd 	b	82a8 <main+0x7c>
    83b0:	00009ba0 	andeq	r9, r0, r0, lsr #23
    83b4:	00009bac 	andeq	r9, r0, ip, lsr #23
    83b8:	00009bb8 			; <UNDEFINED> instruction: 0x00009bb8
    83bc:	cccccccd 	stclgt	12, cr12, [ip], {205}	; 0xcd

000083c0 <_Z6getpidv>:
_Z6getpidv():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:5
#include <stdfile.h>
#include <stdstring.h>

uint32_t getpid()
{
    83c0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    83c4:	e28db000 	add	fp, sp, #0
    83c8:	e24dd00c 	sub	sp, sp, #12
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:8
    uint32_t pid;

    asm volatile("swi 0");
    83cc:	ef000000 	svc	0x00000000
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:9
    asm volatile("mov %0, r0" : "=r" (pid));
    83d0:	e1a03000 	mov	r3, r0
    83d4:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:11

    return pid;
    83d8:	e51b3008 	ldr	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:12
}
    83dc:	e1a00003 	mov	r0, r3
    83e0:	e28bd000 	add	sp, fp, #0
    83e4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    83e8:	e12fff1e 	bx	lr

000083ec <_Z9terminatei>:
_Z9terminatei():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:15

void terminate(int exitcode)
{
    83ec:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    83f0:	e28db000 	add	fp, sp, #0
    83f4:	e24dd00c 	sub	sp, sp, #12
    83f8:	e50b0008 	str	r0, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:16
    asm volatile("mov r0, %0" : : "r" (exitcode));
    83fc:	e51b3008 	ldr	r3, [fp, #-8]
    8400:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:17
    asm volatile("swi 1");
    8404:	ef000001 	svc	0x00000001
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:18
}
    8408:	e320f000 	nop	{0}
    840c:	e28bd000 	add	sp, fp, #0
    8410:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8414:	e12fff1e 	bx	lr

00008418 <_Z11sched_yieldv>:
_Z11sched_yieldv():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:21

void sched_yield()
{
    8418:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    841c:	e28db000 	add	fp, sp, #0
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:22
    asm volatile("swi 2");
    8420:	ef000002 	svc	0x00000002
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:23
}
    8424:	e320f000 	nop	{0}
    8428:	e28bd000 	add	sp, fp, #0
    842c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8430:	e12fff1e 	bx	lr

00008434 <_Z4openPKc15NFile_Open_Mode>:
_Z4openPKc15NFile_Open_Mode():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:26

uint32_t open(const char* filename, NFile_Open_Mode mode)
{
    8434:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8438:	e28db000 	add	fp, sp, #0
    843c:	e24dd014 	sub	sp, sp, #20
    8440:	e50b0010 	str	r0, [fp, #-16]
    8444:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:29
    uint32_t file;

    asm volatile("mov r0, %0" : : "r" (filename));
    8448:	e51b3010 	ldr	r3, [fp, #-16]
    844c:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:30
    asm volatile("mov r1, %0" : : "r" (mode));
    8450:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8454:	e1a01003 	mov	r1, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:31
    asm volatile("swi 64");
    8458:	ef000040 	svc	0x00000040
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:32
    asm volatile("mov %0, r0" : "=r" (file));
    845c:	e1a03000 	mov	r3, r0
    8460:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:34

    return file;
    8464:	e51b3008 	ldr	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:35
}
    8468:	e1a00003 	mov	r0, r3
    846c:	e28bd000 	add	sp, fp, #0
    8470:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8474:	e12fff1e 	bx	lr

00008478 <_Z4readjPcj>:
_Z4readjPcj():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:38

uint32_t read(uint32_t file, char* const buffer, uint32_t size)
{
    8478:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    847c:	e28db000 	add	fp, sp, #0
    8480:	e24dd01c 	sub	sp, sp, #28
    8484:	e50b0010 	str	r0, [fp, #-16]
    8488:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    848c:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:41
    uint32_t rdnum;

    asm volatile("mov r0, %0" : : "r" (file));
    8490:	e51b3010 	ldr	r3, [fp, #-16]
    8494:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:42
    asm volatile("mov r1, %0" : : "r" (buffer));
    8498:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    849c:	e1a01003 	mov	r1, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:43
    asm volatile("mov r2, %0" : : "r" (size));
    84a0:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    84a4:	e1a02003 	mov	r2, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:44
    asm volatile("swi 65");
    84a8:	ef000041 	svc	0x00000041
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:45
    asm volatile("mov %0, r0" : "=r" (rdnum));
    84ac:	e1a03000 	mov	r3, r0
    84b0:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:47

    return rdnum;
    84b4:	e51b3008 	ldr	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:48
}
    84b8:	e1a00003 	mov	r0, r3
    84bc:	e28bd000 	add	sp, fp, #0
    84c0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    84c4:	e12fff1e 	bx	lr

000084c8 <_Z5writejPKcj>:
_Z5writejPKcj():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:52


uint32_t write(uint32_t file, const char* buffer, uint32_t size)
{
    84c8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    84cc:	e28db000 	add	fp, sp, #0
    84d0:	e24dd01c 	sub	sp, sp, #28
    84d4:	e50b0010 	str	r0, [fp, #-16]
    84d8:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    84dc:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:55
    uint32_t wrnum;

    asm volatile("mov r0, %0" : : "r" (file));
    84e0:	e51b3010 	ldr	r3, [fp, #-16]
    84e4:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:56
    asm volatile("mov r1, %0" : : "r" (buffer));
    84e8:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    84ec:	e1a01003 	mov	r1, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:57
    asm volatile("mov r2, %0" : : "r" (size));
    84f0:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    84f4:	e1a02003 	mov	r2, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:58
    asm volatile("swi 66");
    84f8:	ef000042 	svc	0x00000042
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:59
    asm volatile("mov %0, r0" : "=r" (wrnum));
    84fc:	e1a03000 	mov	r3, r0
    8500:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:61

    return wrnum;
    8504:	e51b3008 	ldr	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:62
}
    8508:	e1a00003 	mov	r0, r3
    850c:	e28bd000 	add	sp, fp, #0
    8510:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8514:	e12fff1e 	bx	lr

00008518 <_Z5closej>:
_Z5closej():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:65

void close(uint32_t file)
{
    8518:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    851c:	e28db000 	add	fp, sp, #0
    8520:	e24dd00c 	sub	sp, sp, #12
    8524:	e50b0008 	str	r0, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:66
    asm volatile("mov r0, %0" : : "r" (file));
    8528:	e51b3008 	ldr	r3, [fp, #-8]
    852c:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:67
    asm volatile("swi 67");
    8530:	ef000043 	svc	0x00000043
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:68
}
    8534:	e320f000 	nop	{0}
    8538:	e28bd000 	add	sp, fp, #0
    853c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8540:	e12fff1e 	bx	lr

00008544 <_Z5ioctlj16NIOCtl_OperationPv>:
_Z5ioctlj16NIOCtl_OperationPv():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:71

uint32_t ioctl(uint32_t file, NIOCtl_Operation operation, void* param)
{
    8544:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8548:	e28db000 	add	fp, sp, #0
    854c:	e24dd01c 	sub	sp, sp, #28
    8550:	e50b0010 	str	r0, [fp, #-16]
    8554:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8558:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:74
    uint32_t retcode;

    asm volatile("mov r0, %0" : : "r" (file));
    855c:	e51b3010 	ldr	r3, [fp, #-16]
    8560:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:75
    asm volatile("mov r1, %0" : : "r" (operation));
    8564:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8568:	e1a01003 	mov	r1, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:76
    asm volatile("mov r2, %0" : : "r" (param));
    856c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8570:	e1a02003 	mov	r2, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:77
    asm volatile("swi 68");
    8574:	ef000044 	svc	0x00000044
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:78
    asm volatile("mov %0, r0" : "=r" (retcode));
    8578:	e1a03000 	mov	r3, r0
    857c:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:80

    return retcode;
    8580:	e51b3008 	ldr	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:81
}
    8584:	e1a00003 	mov	r0, r3
    8588:	e28bd000 	add	sp, fp, #0
    858c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8590:	e12fff1e 	bx	lr

00008594 <_Z6notifyjj>:
_Z6notifyjj():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:84

uint32_t notify(uint32_t file, uint32_t count)
{
    8594:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8598:	e28db000 	add	fp, sp, #0
    859c:	e24dd014 	sub	sp, sp, #20
    85a0:	e50b0010 	str	r0, [fp, #-16]
    85a4:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:87
    uint32_t retcnt;

    asm volatile("mov r0, %0" : : "r" (file));
    85a8:	e51b3010 	ldr	r3, [fp, #-16]
    85ac:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:88
    asm volatile("mov r1, %0" : : "r" (count));
    85b0:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    85b4:	e1a01003 	mov	r1, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:89
    asm volatile("swi 69");
    85b8:	ef000045 	svc	0x00000045
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:90
    asm volatile("mov %0, r0" : "=r" (retcnt));
    85bc:	e1a03000 	mov	r3, r0
    85c0:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:92

    return retcnt;
    85c4:	e51b3008 	ldr	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:93
}
    85c8:	e1a00003 	mov	r0, r3
    85cc:	e28bd000 	add	sp, fp, #0
    85d0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    85d4:	e12fff1e 	bx	lr

000085d8 <_Z4waitjjj>:
_Z4waitjjj():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:96

NSWI_Result_Code wait(uint32_t file, uint32_t count, uint32_t notified_deadline)
{
    85d8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    85dc:	e28db000 	add	fp, sp, #0
    85e0:	e24dd01c 	sub	sp, sp, #28
    85e4:	e50b0010 	str	r0, [fp, #-16]
    85e8:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    85ec:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:99
    NSWI_Result_Code retcode;

    asm volatile("mov r0, %0" : : "r" (file));
    85f0:	e51b3010 	ldr	r3, [fp, #-16]
    85f4:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:100
    asm volatile("mov r1, %0" : : "r" (count));
    85f8:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    85fc:	e1a01003 	mov	r1, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:101
    asm volatile("mov r2, %0" : : "r" (notified_deadline));
    8600:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8604:	e1a02003 	mov	r2, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:102
    asm volatile("swi 70");
    8608:	ef000046 	svc	0x00000046
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:103
    asm volatile("mov %0, r0" : "=r" (retcode));
    860c:	e1a03000 	mov	r3, r0
    8610:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:105

    return retcode;
    8614:	e51b3008 	ldr	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:106
}
    8618:	e1a00003 	mov	r0, r3
    861c:	e28bd000 	add	sp, fp, #0
    8620:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8624:	e12fff1e 	bx	lr

00008628 <_Z5sleepjj>:
_Z5sleepjj():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:109

bool sleep(uint32_t ticks, uint32_t notified_deadline)
{
    8628:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    862c:	e28db000 	add	fp, sp, #0
    8630:	e24dd014 	sub	sp, sp, #20
    8634:	e50b0010 	str	r0, [fp, #-16]
    8638:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:112
    uint32_t retcode;

    asm volatile("mov r0, %0" : : "r" (ticks));
    863c:	e51b3010 	ldr	r3, [fp, #-16]
    8640:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:113
    asm volatile("mov r1, %0" : : "r" (notified_deadline));
    8644:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8648:	e1a01003 	mov	r1, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:114
    asm volatile("swi 3");
    864c:	ef000003 	svc	0x00000003
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:115
    asm volatile("mov %0, r0" : "=r" (retcode));
    8650:	e1a03000 	mov	r3, r0
    8654:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:117

    return retcode;
    8658:	e51b3008 	ldr	r3, [fp, #-8]
    865c:	e3530000 	cmp	r3, #0
    8660:	13a03001 	movne	r3, #1
    8664:	03a03000 	moveq	r3, #0
    8668:	e6ef3073 	uxtb	r3, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:118
}
    866c:	e1a00003 	mov	r0, r3
    8670:	e28bd000 	add	sp, fp, #0
    8674:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8678:	e12fff1e 	bx	lr

0000867c <_Z24get_active_process_countv>:
_Z24get_active_process_countv():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:121

uint32_t get_active_process_count()
{
    867c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8680:	e28db000 	add	fp, sp, #0
    8684:	e24dd00c 	sub	sp, sp, #12
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:122
    const NGet_Sched_Info_Type req = NGet_Sched_Info_Type::Active_Process_Count;
    8688:	e3a03000 	mov	r3, #0
    868c:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:125
    uint32_t retval;

    asm volatile("mov r0, %0" : : "r" (req));
    8690:	e3a03000 	mov	r3, #0
    8694:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:126
    asm volatile("mov r1, %0" : : "r" (&retval));
    8698:	e24b300c 	sub	r3, fp, #12
    869c:	e1a01003 	mov	r1, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:127
    asm volatile("swi 4");
    86a0:	ef000004 	svc	0x00000004
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:129

    return retval;
    86a4:	e51b300c 	ldr	r3, [fp, #-12]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:130
}
    86a8:	e1a00003 	mov	r0, r3
    86ac:	e28bd000 	add	sp, fp, #0
    86b0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    86b4:	e12fff1e 	bx	lr

000086b8 <_Z14get_tick_countv>:
_Z14get_tick_countv():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:133

uint32_t get_tick_count()
{
    86b8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    86bc:	e28db000 	add	fp, sp, #0
    86c0:	e24dd00c 	sub	sp, sp, #12
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:134
    const NGet_Sched_Info_Type req = NGet_Sched_Info_Type::Tick_Count;
    86c4:	e3a03001 	mov	r3, #1
    86c8:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:137
    uint32_t retval;

    asm volatile("mov r0, %0" : : "r" (req));
    86cc:	e3a03001 	mov	r3, #1
    86d0:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:138
    asm volatile("mov r1, %0" : : "r" (&retval));
    86d4:	e24b300c 	sub	r3, fp, #12
    86d8:	e1a01003 	mov	r1, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:139
    asm volatile("swi 4");
    86dc:	ef000004 	svc	0x00000004
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:141

    return retval;
    86e0:	e51b300c 	ldr	r3, [fp, #-12]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:142
}
    86e4:	e1a00003 	mov	r0, r3
    86e8:	e28bd000 	add	sp, fp, #0
    86ec:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    86f0:	e12fff1e 	bx	lr

000086f4 <_Z17set_task_deadlinej>:
_Z17set_task_deadlinej():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:145

void set_task_deadline(uint32_t tick_count_required)
{
    86f4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    86f8:	e28db000 	add	fp, sp, #0
    86fc:	e24dd014 	sub	sp, sp, #20
    8700:	e50b0010 	str	r0, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:146
    const NDeadline_Subservice req = NDeadline_Subservice::Set_Relative;
    8704:	e3a03000 	mov	r3, #0
    8708:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:148

    asm volatile("mov r0, %0" : : "r" (req));
    870c:	e3a03000 	mov	r3, #0
    8710:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:149
    asm volatile("mov r1, %0" : : "r" (&tick_count_required));
    8714:	e24b3010 	sub	r3, fp, #16
    8718:	e1a01003 	mov	r1, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:150
    asm volatile("swi 5");
    871c:	ef000005 	svc	0x00000005
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:151
}
    8720:	e320f000 	nop	{0}
    8724:	e28bd000 	add	sp, fp, #0
    8728:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    872c:	e12fff1e 	bx	lr

00008730 <_Z26get_task_ticks_to_deadlinev>:
_Z26get_task_ticks_to_deadlinev():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:154

uint32_t get_task_ticks_to_deadline()
{
    8730:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8734:	e28db000 	add	fp, sp, #0
    8738:	e24dd00c 	sub	sp, sp, #12
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:155
    const NDeadline_Subservice req = NDeadline_Subservice::Get_Remaining;
    873c:	e3a03001 	mov	r3, #1
    8740:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:158
    uint32_t ticks;

    asm volatile("mov r0, %0" : : "r" (req));
    8744:	e3a03001 	mov	r3, #1
    8748:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:159
    asm volatile("mov r1, %0" : : "r" (&ticks));
    874c:	e24b300c 	sub	r3, fp, #12
    8750:	e1a01003 	mov	r1, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:160
    asm volatile("swi 5");
    8754:	ef000005 	svc	0x00000005
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:162

    return ticks;
    8758:	e51b300c 	ldr	r3, [fp, #-12]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:163
}
    875c:	e1a00003 	mov	r0, r3
    8760:	e28bd000 	add	sp, fp, #0
    8764:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8768:	e12fff1e 	bx	lr

0000876c <_Z4pipePKcj>:
_Z4pipePKcj():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:168

const char Pipe_File_Prefix[] = "SYS:pipe/";

uint32_t pipe(const char* name, uint32_t buf_size)
{
    876c:	e92d4800 	push	{fp, lr}
    8770:	e28db004 	add	fp, sp, #4
    8774:	e24dd050 	sub	sp, sp, #80	; 0x50
    8778:	e50b0050 	str	r0, [fp, #-80]	; 0xffffffb0
    877c:	e50b1054 	str	r1, [fp, #-84]	; 0xffffffac
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:170
    char fname[64];
    strncpy(fname, Pipe_File_Prefix, sizeof(Pipe_File_Prefix));
    8780:	e24b3048 	sub	r3, fp, #72	; 0x48
    8784:	e3a0200a 	mov	r2, #10
    8788:	e59f1088 	ldr	r1, [pc, #136]	; 8818 <_Z4pipePKcj+0xac>
    878c:	e1a00003 	mov	r0, r3
    8790:	eb00014a 	bl	8cc0 <_Z7strncpyPcPKci>
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:171
    strncpy(fname + sizeof(Pipe_File_Prefix), name, sizeof(fname) - sizeof(Pipe_File_Prefix) - 1);
    8794:	e24b3048 	sub	r3, fp, #72	; 0x48
    8798:	e283300a 	add	r3, r3, #10
    879c:	e3a02035 	mov	r2, #53	; 0x35
    87a0:	e51b1050 	ldr	r1, [fp, #-80]	; 0xffffffb0
    87a4:	e1a00003 	mov	r0, r3
    87a8:	eb000144 	bl	8cc0 <_Z7strncpyPcPKci>
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:173

    int ncur = sizeof(Pipe_File_Prefix) + strlen(name);
    87ac:	e51b0050 	ldr	r0, [fp, #-80]	; 0xffffffb0
    87b0:	eb00019d 	bl	8e2c <_Z6strlenPKc>
    87b4:	e1a03000 	mov	r3, r0
    87b8:	e283300a 	add	r3, r3, #10
    87bc:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:175

    fname[ncur++] = '#';
    87c0:	e51b3008 	ldr	r3, [fp, #-8]
    87c4:	e2832001 	add	r2, r3, #1
    87c8:	e50b2008 	str	r2, [fp, #-8]
    87cc:	e2433004 	sub	r3, r3, #4
    87d0:	e083300b 	add	r3, r3, fp
    87d4:	e3a02023 	mov	r2, #35	; 0x23
    87d8:	e5432044 	strb	r2, [r3, #-68]	; 0xffffffbc
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:177

    itoa(buf_size, &fname[ncur], 10);
    87dc:	e51b0054 	ldr	r0, [fp, #-84]	; 0xffffffac
    87e0:	e24b2048 	sub	r2, fp, #72	; 0x48
    87e4:	e51b3008 	ldr	r3, [fp, #-8]
    87e8:	e0823003 	add	r3, r2, r3
    87ec:	e3a0200a 	mov	r2, #10
    87f0:	e1a01003 	mov	r1, r3
    87f4:	eb000009 	bl	8820 <_Z4itoaiPcj>
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:179

    return open(fname, NFile_Open_Mode::Read_Write);
    87f8:	e24b3048 	sub	r3, fp, #72	; 0x48
    87fc:	e3a01002 	mov	r1, #2
    8800:	e1a00003 	mov	r0, r3
    8804:	ebffff0a 	bl	8434 <_Z4openPKc15NFile_Open_Mode>
    8808:	e1a03000 	mov	r3, r0
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:180
}
    880c:	e1a00003 	mov	r0, r3
    8810:	e24bd004 	sub	sp, fp, #4
    8814:	e8bd8800 	pop	{fp, pc}
    8818:	00009bf0 	strdeq	r9, [r0], -r0
    881c:	00000000 	andeq	r0, r0, r0

00008820 <_Z4itoaiPcj>:
_Z4itoaiPcj():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:9
{
    const char CharConvArr[] = "0123456789ABCDEF";
}

void itoa(int input, char* output, unsigned int base)
{
    8820:	e92d4800 	push	{fp, lr}
    8824:	e28db004 	add	fp, sp, #4
    8828:	e24dd020 	sub	sp, sp, #32
    882c:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    8830:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    8834:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:10
    int i = 0;
    8838:	e3a03000 	mov	r3, #0
    883c:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:11
    int j = 0;
    8840:	e3a03000 	mov	r3, #0
    8844:	e50b300c 	str	r3, [fp, #-12]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:13

	while (input > 0)
    8848:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    884c:	e3530000 	cmp	r3, #0
    8850:	da000015 	ble	88ac <_Z4itoaiPcj+0x8c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:15
	{
		output[i] = CharConvArr[input % base];
    8854:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8858:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    885c:	e1a00003 	mov	r0, r3
    8860:	eb000380 	bl	9668 <__aeabi_uidivmod>
    8864:	e1a03001 	mov	r3, r1
    8868:	e1a01003 	mov	r1, r3
    886c:	e51b3008 	ldr	r3, [fp, #-8]
    8870:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8874:	e0823003 	add	r3, r2, r3
    8878:	e59f2114 	ldr	r2, [pc, #276]	; 8994 <_Z4itoaiPcj+0x174>
    887c:	e7d22001 	ldrb	r2, [r2, r1]
    8880:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:16
		input /= base;
    8884:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8888:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    888c:	e1a00003 	mov	r0, r3
    8890:	eb0002f9 	bl	947c <__udivsi3>
    8894:	e1a03000 	mov	r3, r0
    8898:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:17
		i++;
    889c:	e51b3008 	ldr	r3, [fp, #-8]
    88a0:	e2833001 	add	r3, r3, #1
    88a4:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:13
	while (input > 0)
    88a8:	eaffffe6 	b	8848 <_Z4itoaiPcj+0x28>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:20
	}

    if (i == 0)
    88ac:	e51b3008 	ldr	r3, [fp, #-8]
    88b0:	e3530000 	cmp	r3, #0
    88b4:	1a000007 	bne	88d8 <_Z4itoaiPcj+0xb8>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:22
    {
        output[i] = CharConvArr[0];
    88b8:	e51b3008 	ldr	r3, [fp, #-8]
    88bc:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    88c0:	e0823003 	add	r3, r2, r3
    88c4:	e3a02030 	mov	r2, #48	; 0x30
    88c8:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:23
        i++;
    88cc:	e51b3008 	ldr	r3, [fp, #-8]
    88d0:	e2833001 	add	r3, r3, #1
    88d4:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:26
    }

	output[i] = '\0';
    88d8:	e51b3008 	ldr	r3, [fp, #-8]
    88dc:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    88e0:	e0823003 	add	r3, r2, r3
    88e4:	e3a02000 	mov	r2, #0
    88e8:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:27
	i--;
    88ec:	e51b3008 	ldr	r3, [fp, #-8]
    88f0:	e2433001 	sub	r3, r3, #1
    88f4:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:29 (discriminator 2)

	for (j; j <= i/2; j++)
    88f8:	e51b3008 	ldr	r3, [fp, #-8]
    88fc:	e1a02fa3 	lsr	r2, r3, #31
    8900:	e0823003 	add	r3, r2, r3
    8904:	e1a030c3 	asr	r3, r3, #1
    8908:	e1a02003 	mov	r2, r3
    890c:	e51b300c 	ldr	r3, [fp, #-12]
    8910:	e1530002 	cmp	r3, r2
    8914:	ca00001b 	bgt	8988 <_Z4itoaiPcj+0x168>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:31 (discriminator 1)
	{
		char c = output[i - j];
    8918:	e51b2008 	ldr	r2, [fp, #-8]
    891c:	e51b300c 	ldr	r3, [fp, #-12]
    8920:	e0423003 	sub	r3, r2, r3
    8924:	e1a02003 	mov	r2, r3
    8928:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    892c:	e0833002 	add	r3, r3, r2
    8930:	e5d33000 	ldrb	r3, [r3]
    8934:	e54b300d 	strb	r3, [fp, #-13]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:32 (discriminator 1)
		output[i - j] = output[j];
    8938:	e51b300c 	ldr	r3, [fp, #-12]
    893c:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8940:	e0822003 	add	r2, r2, r3
    8944:	e51b1008 	ldr	r1, [fp, #-8]
    8948:	e51b300c 	ldr	r3, [fp, #-12]
    894c:	e0413003 	sub	r3, r1, r3
    8950:	e1a01003 	mov	r1, r3
    8954:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8958:	e0833001 	add	r3, r3, r1
    895c:	e5d22000 	ldrb	r2, [r2]
    8960:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:33 (discriminator 1)
		output[j] = c;
    8964:	e51b300c 	ldr	r3, [fp, #-12]
    8968:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    896c:	e0823003 	add	r3, r2, r3
    8970:	e55b200d 	ldrb	r2, [fp, #-13]
    8974:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:29 (discriminator 1)
	for (j; j <= i/2; j++)
    8978:	e51b300c 	ldr	r3, [fp, #-12]
    897c:	e2833001 	add	r3, r3, #1
    8980:	e50b300c 	str	r3, [fp, #-12]
    8984:	eaffffdb 	b	88f8 <_Z4itoaiPcj+0xd8>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:36
	}

}
    8988:	e320f000 	nop	{0}
    898c:	e24bd004 	sub	sp, fp, #4
    8990:	e8bd8800 	pop	{fp, pc}
    8994:	00009bfc 	strdeq	r9, [r0], -ip

00008998 <_Z4atoiPKc>:
_Z4atoiPKc():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:39

int atoi(const char* input)
{
    8998:	e92d4800 	push	{fp, lr}
    899c:	e28db004 	add	fp, sp, #4
    89a0:	e24dd010 	sub	sp, sp, #16
    89a4:	e50b0010 	str	r0, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:40
    if(strlen(input) == 1)
    89a8:	e51b0010 	ldr	r0, [fp, #-16]
    89ac:	eb00011e 	bl	8e2c <_Z6strlenPKc>
    89b0:	e1a03000 	mov	r3, r0
    89b4:	e3530001 	cmp	r3, #1
    89b8:	03a03001 	moveq	r3, #1
    89bc:	13a03000 	movne	r3, #0
    89c0:	e6ef3073 	uxtb	r3, r3
    89c4:	e3530000 	cmp	r3, #0
    89c8:	0a000003 	beq	89dc <_Z4atoiPKc+0x44>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:41
        return *input - '0';
    89cc:	e51b3010 	ldr	r3, [fp, #-16]
    89d0:	e5d33000 	ldrb	r3, [r3]
    89d4:	e2433030 	sub	r3, r3, #48	; 0x30
    89d8:	ea00001e 	b	8a58 <_Z4atoiPKc+0xc0>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:42
	int output = 0;
    89dc:	e3a03000 	mov	r3, #0
    89e0:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:44

	while (*input != '\0')
    89e4:	e51b3010 	ldr	r3, [fp, #-16]
    89e8:	e5d33000 	ldrb	r3, [r3]
    89ec:	e3530000 	cmp	r3, #0
    89f0:	0a000017 	beq	8a54 <_Z4atoiPKc+0xbc>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:46
	{
		output *= 10;
    89f4:	e51b2008 	ldr	r2, [fp, #-8]
    89f8:	e1a03002 	mov	r3, r2
    89fc:	e1a03103 	lsl	r3, r3, #2
    8a00:	e0833002 	add	r3, r3, r2
    8a04:	e1a03083 	lsl	r3, r3, #1
    8a08:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:47
		if (*input > '9' || *input < '0')
    8a0c:	e51b3010 	ldr	r3, [fp, #-16]
    8a10:	e5d33000 	ldrb	r3, [r3]
    8a14:	e3530039 	cmp	r3, #57	; 0x39
    8a18:	8a00000d 	bhi	8a54 <_Z4atoiPKc+0xbc>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:47 (discriminator 1)
    8a1c:	e51b3010 	ldr	r3, [fp, #-16]
    8a20:	e5d33000 	ldrb	r3, [r3]
    8a24:	e353002f 	cmp	r3, #47	; 0x2f
    8a28:	9a000009 	bls	8a54 <_Z4atoiPKc+0xbc>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:50
			break;

		output += *input - '0';
    8a2c:	e51b3010 	ldr	r3, [fp, #-16]
    8a30:	e5d33000 	ldrb	r3, [r3]
    8a34:	e2433030 	sub	r3, r3, #48	; 0x30
    8a38:	e51b2008 	ldr	r2, [fp, #-8]
    8a3c:	e0823003 	add	r3, r2, r3
    8a40:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:52

		input++;
    8a44:	e51b3010 	ldr	r3, [fp, #-16]
    8a48:	e2833001 	add	r3, r3, #1
    8a4c:	e50b3010 	str	r3, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:44
	while (*input != '\0')
    8a50:	eaffffe3 	b	89e4 <_Z4atoiPKc+0x4c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:55
	}

	return output;
    8a54:	e51b3008 	ldr	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:56
}
    8a58:	e1a00003 	mov	r0, r3
    8a5c:	e24bd004 	sub	sp, fp, #4
    8a60:	e8bd8800 	pop	{fp, pc}

00008a64 <_Z14get_input_typePKc>:
_Z14get_input_typePKc():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:60
//return 1 pokud int
//return 2 pokud float
//return 0 pokud neni cislo
int get_input_type(const char * input){
    8a64:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8a68:	e28db000 	add	fp, sp, #0
    8a6c:	e24dd014 	sub	sp, sp, #20
    8a70:	e50b0010 	str	r0, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:62
    //existence tecky
    bool dot = false;
    8a74:	e3a03000 	mov	r3, #0
    8a78:	e54b3005 	strb	r3, [fp, #-5]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:63
    bool trailing_dot = false;
    8a7c:	e3a03000 	mov	r3, #0
    8a80:	e54b3006 	strb	r3, [fp, #-6]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:64
    while(*input != '\0'){
    8a84:	e51b3010 	ldr	r3, [fp, #-16]
    8a88:	e5d33000 	ldrb	r3, [r3]
    8a8c:	e3530000 	cmp	r3, #0
    8a90:	0a000023 	beq	8b24 <_Z14get_input_typePKc+0xc0>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:65
        char c = *input;
    8a94:	e51b3010 	ldr	r3, [fp, #-16]
    8a98:	e5d33000 	ldrb	r3, [r3]
    8a9c:	e54b3007 	strb	r3, [fp, #-7]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:66
        if(c == '.' && !dot){
    8aa0:	e55b3007 	ldrb	r3, [fp, #-7]
    8aa4:	e353002e 	cmp	r3, #46	; 0x2e
    8aa8:	1a00000c 	bne	8ae0 <_Z14get_input_typePKc+0x7c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:66 (discriminator 1)
    8aac:	e55b3005 	ldrb	r3, [fp, #-5]
    8ab0:	e2233001 	eor	r3, r3, #1
    8ab4:	e6ef3073 	uxtb	r3, r3
    8ab8:	e3530000 	cmp	r3, #0
    8abc:	0a000007 	beq	8ae0 <_Z14get_input_typePKc+0x7c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:67 (discriminator 2)
            dot = true;
    8ac0:	e3a03001 	mov	r3, #1
    8ac4:	e54b3005 	strb	r3, [fp, #-5]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:68 (discriminator 2)
            trailing_dot = true;
    8ac8:	e3a03001 	mov	r3, #1
    8acc:	e54b3006 	strb	r3, [fp, #-6]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:69 (discriminator 2)
            input++;
    8ad0:	e51b3010 	ldr	r3, [fp, #-16]
    8ad4:	e2833001 	add	r3, r3, #1
    8ad8:	e50b3010 	str	r3, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:70 (discriminator 2)
            continue;
    8adc:	ea00000f 	b	8b20 <_Z14get_input_typePKc+0xbc>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:73
        }
        //nenumericky znak
        if(c < '0' || c > '9')return 0;
    8ae0:	e55b3007 	ldrb	r3, [fp, #-7]
    8ae4:	e353002f 	cmp	r3, #47	; 0x2f
    8ae8:	9a000002 	bls	8af8 <_Z14get_input_typePKc+0x94>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:73 (discriminator 2)
    8aec:	e55b3007 	ldrb	r3, [fp, #-7]
    8af0:	e3530039 	cmp	r3, #57	; 0x39
    8af4:	9a000001 	bls	8b00 <_Z14get_input_typePKc+0x9c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:73 (discriminator 3)
    8af8:	e3a03000 	mov	r3, #0
    8afc:	ea000014 	b	8b54 <_Z14get_input_typePKc+0xf0>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:75
        //retezec obsahuje tecku a numericke znaky -> tecka je "validni", tedy neni to tecka na konci intu napriklad
        if(dot)
    8b00:	e55b3005 	ldrb	r3, [fp, #-5]
    8b04:	e3530000 	cmp	r3, #0
    8b08:	0a000001 	beq	8b14 <_Z14get_input_typePKc+0xb0>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:76
            trailing_dot = false;
    8b0c:	e3a03000 	mov	r3, #0
    8b10:	e54b3006 	strb	r3, [fp, #-6]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:77
    input++;
    8b14:	e51b3010 	ldr	r3, [fp, #-16]
    8b18:	e2833001 	add	r3, r3, #1
    8b1c:	e50b3010 	str	r3, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:64
    while(*input != '\0'){
    8b20:	eaffffd7 	b	8a84 <_Z14get_input_typePKc+0x20>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:79
    }
    if(trailing_dot)return 0;
    8b24:	e55b3006 	ldrb	r3, [fp, #-6]
    8b28:	e3530000 	cmp	r3, #0
    8b2c:	0a000001 	beq	8b38 <_Z14get_input_typePKc+0xd4>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:79 (discriminator 1)
    8b30:	e3a03000 	mov	r3, #0
    8b34:	ea000006 	b	8b54 <_Z14get_input_typePKc+0xf0>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:81
    //float pokud retezec obsahuje non-trailing tecku, 1 pokud je to int
    return dot? 2:1;
    8b38:	e55b3005 	ldrb	r3, [fp, #-5]
    8b3c:	e3530000 	cmp	r3, #0
    8b40:	0a000001 	beq	8b4c <_Z14get_input_typePKc+0xe8>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:81 (discriminator 1)
    8b44:	e3a03002 	mov	r3, #2
    8b48:	ea000000 	b	8b50 <_Z14get_input_typePKc+0xec>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:81 (discriminator 2)
    8b4c:	e3a03001 	mov	r3, #1
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:81
    8b50:	e320f000 	nop	{0}
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:83

}
    8b54:	e1a00003 	mov	r0, r3
    8b58:	e28bd000 	add	sp, fp, #0
    8b5c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8b60:	e12fff1e 	bx	lr

00008b64 <_Z4atofPKc>:
_Z4atofPKc():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:87


//string to float
float atof(const char* input){
    8b64:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8b68:	e28db000 	add	fp, sp, #0
    8b6c:	e24dd03c 	sub	sp, sp, #60	; 0x3c
    8b70:	e50b0038 	str	r0, [fp, #-56]	; 0xffffffc8
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:88
    double output = 0.0;
    8b74:	e3a02000 	mov	r2, #0
    8b78:	e3a03000 	mov	r3, #0
    8b7c:	e14b20fc 	strd	r2, [fp, #-12]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:89
    double factor = 10;
    8b80:	e3a02000 	mov	r2, #0
    8b84:	e59f312c 	ldr	r3, [pc, #300]	; 8cb8 <_Z4atofPKc+0x154>
    8b88:	e14b21fc 	strd	r2, [fp, #-28]	; 0xffffffe4
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:91
    //cast za desetinnou carkou
    double tmp = 0.0;
    8b8c:	e3a02000 	mov	r2, #0
    8b90:	e3a03000 	mov	r3, #0
    8b94:	e14b22f4 	strd	r2, [fp, #-36]	; 0xffffffdc
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:92
    int counter = 0;
    8b98:	e3a03000 	mov	r3, #0
    8b9c:	e50b3028 	str	r3, [fp, #-40]	; 0xffffffd8
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:93
    int scale = 1;
    8ba0:	e3a03001 	mov	r3, #1
    8ba4:	e50b3010 	str	r3, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:94
    bool afterDecPoint = false;
    8ba8:	e3a03000 	mov	r3, #0
    8bac:	e54b3011 	strb	r3, [fp, #-17]	; 0xffffffef
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:96

    while(*input != '\0'){
    8bb0:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    8bb4:	e5d33000 	ldrb	r3, [r3]
    8bb8:	e3530000 	cmp	r3, #0
    8bbc:	0a000034 	beq	8c94 <_Z4atofPKc+0x130>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:97
        if (*input == '.'){
    8bc0:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    8bc4:	e5d33000 	ldrb	r3, [r3]
    8bc8:	e353002e 	cmp	r3, #46	; 0x2e
    8bcc:	1a000005 	bne	8be8 <_Z4atofPKc+0x84>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:98 (discriminator 1)
            afterDecPoint = true;
    8bd0:	e3a03001 	mov	r3, #1
    8bd4:	e54b3011 	strb	r3, [fp, #-17]	; 0xffffffef
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:99 (discriminator 1)
            input++;
    8bd8:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    8bdc:	e2833001 	add	r3, r3, #1
    8be0:	e50b3038 	str	r3, [fp, #-56]	; 0xffffffc8
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:100 (discriminator 1)
            continue;
    8be4:	ea000029 	b	8c90 <_Z4atofPKc+0x12c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:102
        }
        else if (*input > '9' || *input < '0')break;
    8be8:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    8bec:	e5d33000 	ldrb	r3, [r3]
    8bf0:	e3530039 	cmp	r3, #57	; 0x39
    8bf4:	8a000026 	bhi	8c94 <_Z4atofPKc+0x130>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:102 (discriminator 1)
    8bf8:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    8bfc:	e5d33000 	ldrb	r3, [r3]
    8c00:	e353002f 	cmp	r3, #47	; 0x2f
    8c04:	9a000022 	bls	8c94 <_Z4atofPKc+0x130>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:103
        double val = *input - '0';
    8c08:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    8c0c:	e5d33000 	ldrb	r3, [r3]
    8c10:	e2433030 	sub	r3, r3, #48	; 0x30
    8c14:	ee073a90 	vmov	s15, r3
    8c18:	eeb87be7 	vcvt.f64.s32	d7, s15
    8c1c:	ed0b7b0d 	vstr	d7, [fp, #-52]	; 0xffffffcc
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:104
        if(afterDecPoint){
    8c20:	e55b3011 	ldrb	r3, [fp, #-17]	; 0xffffffef
    8c24:	e3530000 	cmp	r3, #0
    8c28:	0a00000f 	beq	8c6c <_Z4atofPKc+0x108>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:105
            scale /= 10;
    8c2c:	e51b3010 	ldr	r3, [fp, #-16]
    8c30:	e59f2084 	ldr	r2, [pc, #132]	; 8cbc <_Z4atofPKc+0x158>
    8c34:	e0c21392 	smull	r1, r2, r2, r3
    8c38:	e1a02142 	asr	r2, r2, #2
    8c3c:	e1a03fc3 	asr	r3, r3, #31
    8c40:	e0423003 	sub	r3, r2, r3
    8c44:	e50b3010 	str	r3, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:106
            output = output + val * scale;
    8c48:	e51b3010 	ldr	r3, [fp, #-16]
    8c4c:	ee073a90 	vmov	s15, r3
    8c50:	eeb86be7 	vcvt.f64.s32	d6, s15
    8c54:	ed1b7b0d 	vldr	d7, [fp, #-52]	; 0xffffffcc
    8c58:	ee267b07 	vmul.f64	d7, d6, d7
    8c5c:	ed1b6b03 	vldr	d6, [fp, #-12]
    8c60:	ee367b07 	vadd.f64	d7, d6, d7
    8c64:	ed0b7b03 	vstr	d7, [fp, #-12]
    8c68:	ea000005 	b	8c84 <_Z4atofPKc+0x120>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:109
        }
        else
            output = output * 10 + val;
    8c6c:	ed1b7b03 	vldr	d7, [fp, #-12]
    8c70:	ed9f6b0e 	vldr	d6, [pc, #56]	; 8cb0 <_Z4atofPKc+0x14c>
    8c74:	ee277b06 	vmul.f64	d7, d7, d6
    8c78:	ed1b6b0d 	vldr	d6, [fp, #-52]	; 0xffffffcc
    8c7c:	ee367b07 	vadd.f64	d7, d6, d7
    8c80:	ed0b7b03 	vstr	d7, [fp, #-12]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:111

        input++;
    8c84:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    8c88:	e2833001 	add	r3, r3, #1
    8c8c:	e50b3038 	str	r3, [fp, #-56]	; 0xffffffc8
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:96
    while(*input != '\0'){
    8c90:	eaffffc6 	b	8bb0 <_Z4atofPKc+0x4c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:113
    }
    return output;
    8c94:	ed1b7b03 	vldr	d7, [fp, #-12]
    8c98:	eef77bc7 	vcvt.f32.f64	s15, d7
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:114
}
    8c9c:	eeb00a67 	vmov.f32	s0, s15
    8ca0:	e28bd000 	add	sp, fp, #0
    8ca4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8ca8:	e12fff1e 	bx	lr
    8cac:	e320f000 	nop	{0}
    8cb0:	00000000 	andeq	r0, r0, r0
    8cb4:	40240000 	eormi	r0, r4, r0
    8cb8:	40240000 	eormi	r0, r4, r0
    8cbc:	66666667 	strbtvs	r6, [r6], -r7, ror #12

00008cc0 <_Z7strncpyPcPKci>:
_Z7strncpyPcPKci():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:116
char* strncpy(char* dest, const char *src, int num)
{
    8cc0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8cc4:	e28db000 	add	fp, sp, #0
    8cc8:	e24dd01c 	sub	sp, sp, #28
    8ccc:	e50b0010 	str	r0, [fp, #-16]
    8cd0:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8cd4:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:119
	int i;

	for (i = 0; i < num && src[i] != '\0'; i++)
    8cd8:	e3a03000 	mov	r3, #0
    8cdc:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:119 (discriminator 4)
    8ce0:	e51b2008 	ldr	r2, [fp, #-8]
    8ce4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8ce8:	e1520003 	cmp	r2, r3
    8cec:	aa000011 	bge	8d38 <_Z7strncpyPcPKci+0x78>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:119 (discriminator 2)
    8cf0:	e51b3008 	ldr	r3, [fp, #-8]
    8cf4:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    8cf8:	e0823003 	add	r3, r2, r3
    8cfc:	e5d33000 	ldrb	r3, [r3]
    8d00:	e3530000 	cmp	r3, #0
    8d04:	0a00000b 	beq	8d38 <_Z7strncpyPcPKci+0x78>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:120 (discriminator 3)
		dest[i] = src[i];
    8d08:	e51b3008 	ldr	r3, [fp, #-8]
    8d0c:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    8d10:	e0822003 	add	r2, r2, r3
    8d14:	e51b3008 	ldr	r3, [fp, #-8]
    8d18:	e51b1010 	ldr	r1, [fp, #-16]
    8d1c:	e0813003 	add	r3, r1, r3
    8d20:	e5d22000 	ldrb	r2, [r2]
    8d24:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:119 (discriminator 3)
	for (i = 0; i < num && src[i] != '\0'; i++)
    8d28:	e51b3008 	ldr	r3, [fp, #-8]
    8d2c:	e2833001 	add	r3, r3, #1
    8d30:	e50b3008 	str	r3, [fp, #-8]
    8d34:	eaffffe9 	b	8ce0 <_Z7strncpyPcPKci+0x20>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:121 (discriminator 2)
	for (; i < num; i++)
    8d38:	e51b2008 	ldr	r2, [fp, #-8]
    8d3c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8d40:	e1520003 	cmp	r2, r3
    8d44:	aa000008 	bge	8d6c <_Z7strncpyPcPKci+0xac>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:122 (discriminator 1)
		dest[i] = '\0';
    8d48:	e51b3008 	ldr	r3, [fp, #-8]
    8d4c:	e51b2010 	ldr	r2, [fp, #-16]
    8d50:	e0823003 	add	r3, r2, r3
    8d54:	e3a02000 	mov	r2, #0
    8d58:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:121 (discriminator 1)
	for (; i < num; i++)
    8d5c:	e51b3008 	ldr	r3, [fp, #-8]
    8d60:	e2833001 	add	r3, r3, #1
    8d64:	e50b3008 	str	r3, [fp, #-8]
    8d68:	eafffff2 	b	8d38 <_Z7strncpyPcPKci+0x78>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:124

   return dest;
    8d6c:	e51b3010 	ldr	r3, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:125
}
    8d70:	e1a00003 	mov	r0, r3
    8d74:	e28bd000 	add	sp, fp, #0
    8d78:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8d7c:	e12fff1e 	bx	lr

00008d80 <_Z7strncmpPKcS0_i>:
_Z7strncmpPKcS0_i():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:128

int strncmp(const char *s1, const char *s2, int num)
{
    8d80:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8d84:	e28db000 	add	fp, sp, #0
    8d88:	e24dd01c 	sub	sp, sp, #28
    8d8c:	e50b0010 	str	r0, [fp, #-16]
    8d90:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8d94:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:130
	unsigned char u1, u2;
  	while (num-- > 0)
    8d98:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8d9c:	e2432001 	sub	r2, r3, #1
    8da0:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
    8da4:	e3530000 	cmp	r3, #0
    8da8:	c3a03001 	movgt	r3, #1
    8dac:	d3a03000 	movle	r3, #0
    8db0:	e6ef3073 	uxtb	r3, r3
    8db4:	e3530000 	cmp	r3, #0
    8db8:	0a000016 	beq	8e18 <_Z7strncmpPKcS0_i+0x98>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:132
    {
      	u1 = (unsigned char) *s1++;
    8dbc:	e51b3010 	ldr	r3, [fp, #-16]
    8dc0:	e2832001 	add	r2, r3, #1
    8dc4:	e50b2010 	str	r2, [fp, #-16]
    8dc8:	e5d33000 	ldrb	r3, [r3]
    8dcc:	e54b3005 	strb	r3, [fp, #-5]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:133
     	u2 = (unsigned char) *s2++;
    8dd0:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8dd4:	e2832001 	add	r2, r3, #1
    8dd8:	e50b2014 	str	r2, [fp, #-20]	; 0xffffffec
    8ddc:	e5d33000 	ldrb	r3, [r3]
    8de0:	e54b3006 	strb	r3, [fp, #-6]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:134
      	if (u1 != u2)
    8de4:	e55b2005 	ldrb	r2, [fp, #-5]
    8de8:	e55b3006 	ldrb	r3, [fp, #-6]
    8dec:	e1520003 	cmp	r2, r3
    8df0:	0a000003 	beq	8e04 <_Z7strncmpPKcS0_i+0x84>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:135
        	return u1 - u2;
    8df4:	e55b2005 	ldrb	r2, [fp, #-5]
    8df8:	e55b3006 	ldrb	r3, [fp, #-6]
    8dfc:	e0423003 	sub	r3, r2, r3
    8e00:	ea000005 	b	8e1c <_Z7strncmpPKcS0_i+0x9c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:136
      	if (u1 == '\0')
    8e04:	e55b3005 	ldrb	r3, [fp, #-5]
    8e08:	e3530000 	cmp	r3, #0
    8e0c:	1affffe1 	bne	8d98 <_Z7strncmpPKcS0_i+0x18>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:137
        	return 0;
    8e10:	e3a03000 	mov	r3, #0
    8e14:	ea000000 	b	8e1c <_Z7strncmpPKcS0_i+0x9c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:140
    }

  	return 0;
    8e18:	e3a03000 	mov	r3, #0
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:141
}
    8e1c:	e1a00003 	mov	r0, r3
    8e20:	e28bd000 	add	sp, fp, #0
    8e24:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8e28:	e12fff1e 	bx	lr

00008e2c <_Z6strlenPKc>:
_Z6strlenPKc():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:144

int strlen(const char* s)
{
    8e2c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8e30:	e28db000 	add	fp, sp, #0
    8e34:	e24dd014 	sub	sp, sp, #20
    8e38:	e50b0010 	str	r0, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:145
	int i = 0;
    8e3c:	e3a03000 	mov	r3, #0
    8e40:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:147

	while (s[i] != '\0')
    8e44:	e51b3008 	ldr	r3, [fp, #-8]
    8e48:	e51b2010 	ldr	r2, [fp, #-16]
    8e4c:	e0823003 	add	r3, r2, r3
    8e50:	e5d33000 	ldrb	r3, [r3]
    8e54:	e3530000 	cmp	r3, #0
    8e58:	0a000003 	beq	8e6c <_Z6strlenPKc+0x40>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:148
		i++;
    8e5c:	e51b3008 	ldr	r3, [fp, #-8]
    8e60:	e2833001 	add	r3, r3, #1
    8e64:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:147
	while (s[i] != '\0')
    8e68:	eafffff5 	b	8e44 <_Z6strlenPKc+0x18>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:150

	return i;
    8e6c:	e51b3008 	ldr	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:151
}
    8e70:	e1a00003 	mov	r0, r3
    8e74:	e28bd000 	add	sp, fp, #0
    8e78:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8e7c:	e12fff1e 	bx	lr

00008e80 <_Z6strcatPcPKc>:
_Z6strcatPcPKc():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:154
//unsafe varianta
//muze nastat buffer overflow attack
char* strcat(char* dest, const char* src){
    8e80:	e92d4800 	push	{fp, lr}
    8e84:	e28db004 	add	fp, sp, #4
    8e88:	e24dd018 	sub	sp, sp, #24
    8e8c:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    8e90:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:155
    int n = strlen(src);
    8e94:	e51b001c 	ldr	r0, [fp, #-28]	; 0xffffffe4
    8e98:	ebffffe3 	bl	8e2c <_Z6strlenPKc>
    8e9c:	e50b0010 	str	r0, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:156
    int m = strlen(dest);
    8ea0:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    8ea4:	ebffffe0 	bl	8e2c <_Z6strlenPKc>
    8ea8:	e50b0008 	str	r0, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:157
    int walker = 0;
    8eac:	e3a03000 	mov	r3, #0
    8eb0:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:158
    for(int i = 0;i < n; i++)
    8eb4:	e3a03000 	mov	r3, #0
    8eb8:	e50b300c 	str	r3, [fp, #-12]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:158 (discriminator 3)
    8ebc:	e51b200c 	ldr	r2, [fp, #-12]
    8ec0:	e51b3010 	ldr	r3, [fp, #-16]
    8ec4:	e1520003 	cmp	r2, r3
    8ec8:	aa00000e 	bge	8f08 <_Z6strcatPcPKc+0x88>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:159 (discriminator 2)
        dest[m++] = src[i];
    8ecc:	e51b300c 	ldr	r3, [fp, #-12]
    8ed0:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8ed4:	e0822003 	add	r2, r2, r3
    8ed8:	e51b3008 	ldr	r3, [fp, #-8]
    8edc:	e2831001 	add	r1, r3, #1
    8ee0:	e50b1008 	str	r1, [fp, #-8]
    8ee4:	e1a01003 	mov	r1, r3
    8ee8:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8eec:	e0833001 	add	r3, r3, r1
    8ef0:	e5d22000 	ldrb	r2, [r2]
    8ef4:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:158 (discriminator 2)
    for(int i = 0;i < n; i++)
    8ef8:	e51b300c 	ldr	r3, [fp, #-12]
    8efc:	e2833001 	add	r3, r3, #1
    8f00:	e50b300c 	str	r3, [fp, #-12]
    8f04:	eaffffec 	b	8ebc <_Z6strcatPcPKc+0x3c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:160
    dest[m] = '\0';
    8f08:	e51b3008 	ldr	r3, [fp, #-8]
    8f0c:	e51b2018 	ldr	r2, [fp, #-24]	; 0xffffffe8
    8f10:	e0823003 	add	r3, r2, r3
    8f14:	e3a02000 	mov	r2, #0
    8f18:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:161
    return dest;
    8f1c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:163

}
    8f20:	e1a00003 	mov	r0, r3
    8f24:	e24bd004 	sub	sp, fp, #4
    8f28:	e8bd8800 	pop	{fp, pc}

00008f2c <_Z7strncatPcPKci>:
_Z7strncatPcPKci():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:164
char* strncat(char* dest, const char* src,int size){
    8f2c:	e92d4800 	push	{fp, lr}
    8f30:	e28db004 	add	fp, sp, #4
    8f34:	e24dd020 	sub	sp, sp, #32
    8f38:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    8f3c:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    8f40:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:165
    int walker = 0;
    8f44:	e3a03000 	mov	r3, #0
    8f48:	e50b3010 	str	r3, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:167
    //najdi odkud muzeme kopirovat, tedy konec retezce
    int m = strlen(dest);
    8f4c:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    8f50:	ebffffb5 	bl	8e2c <_Z6strlenPKc>
    8f54:	e50b0008 	str	r0, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:169
    //nevejdu se
    if(m >= size)return dest;
    8f58:	e51b2008 	ldr	r2, [fp, #-8]
    8f5c:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8f60:	e1520003 	cmp	r2, r3
    8f64:	ba000001 	blt	8f70 <_Z7strncatPcPKci+0x44>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:169 (discriminator 1)
    8f68:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8f6c:	ea000021 	b	8ff8 <_Z7strncatPcPKci+0xcc>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:171

    for(int i = 0;i < size; i++){
    8f70:	e3a03000 	mov	r3, #0
    8f74:	e50b300c 	str	r3, [fp, #-12]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:171 (discriminator 1)
    8f78:	e51b200c 	ldr	r2, [fp, #-12]
    8f7c:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8f80:	e1520003 	cmp	r2, r3
    8f84:	aa000015 	bge	8fe0 <_Z7strncatPcPKci+0xb4>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:172
        if(src[i] == '\0')break;
    8f88:	e51b300c 	ldr	r3, [fp, #-12]
    8f8c:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8f90:	e0823003 	add	r3, r2, r3
    8f94:	e5d33000 	ldrb	r3, [r3]
    8f98:	e3530000 	cmp	r3, #0
    8f9c:	0a00000e 	beq	8fdc <_Z7strncatPcPKci+0xb0>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:173 (discriminator 2)
        dest[m++] = src[i];
    8fa0:	e51b300c 	ldr	r3, [fp, #-12]
    8fa4:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8fa8:	e0822003 	add	r2, r2, r3
    8fac:	e51b3008 	ldr	r3, [fp, #-8]
    8fb0:	e2831001 	add	r1, r3, #1
    8fb4:	e50b1008 	str	r1, [fp, #-8]
    8fb8:	e1a01003 	mov	r1, r3
    8fbc:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8fc0:	e0833001 	add	r3, r3, r1
    8fc4:	e5d22000 	ldrb	r2, [r2]
    8fc8:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:171 (discriminator 2)
    for(int i = 0;i < size; i++){
    8fcc:	e51b300c 	ldr	r3, [fp, #-12]
    8fd0:	e2833001 	add	r3, r3, #1
    8fd4:	e50b300c 	str	r3, [fp, #-12]
    8fd8:	eaffffe6 	b	8f78 <_Z7strncatPcPKci+0x4c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:172
        if(src[i] == '\0')break;
    8fdc:	e320f000 	nop	{0}
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:175
    }
    dest[m] = '\0';
    8fe0:	e51b3008 	ldr	r3, [fp, #-8]
    8fe4:	e51b2018 	ldr	r2, [fp, #-24]	; 0xffffffe8
    8fe8:	e0823003 	add	r3, r2, r3
    8fec:	e3a02000 	mov	r2, #0
    8ff0:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:176
    return dest;
    8ff4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:178

}
    8ff8:	e1a00003 	mov	r0, r3
    8ffc:	e24bd004 	sub	sp, fp, #4
    9000:	e8bd8800 	pop	{fp, pc}

00009004 <_Z5bzeroPvi>:
_Z5bzeroPvi():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:182


void bzero(void* memory, int length)
{
    9004:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9008:	e28db000 	add	fp, sp, #0
    900c:	e24dd014 	sub	sp, sp, #20
    9010:	e50b0010 	str	r0, [fp, #-16]
    9014:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:183
	char* mem = reinterpret_cast<char*>(memory);
    9018:	e51b3010 	ldr	r3, [fp, #-16]
    901c:	e50b300c 	str	r3, [fp, #-12]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:185

	for (int i = 0; i < length; i++)
    9020:	e3a03000 	mov	r3, #0
    9024:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:185 (discriminator 3)
    9028:	e51b2008 	ldr	r2, [fp, #-8]
    902c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9030:	e1520003 	cmp	r2, r3
    9034:	aa000008 	bge	905c <_Z5bzeroPvi+0x58>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:186 (discriminator 2)
		mem[i] = 0;
    9038:	e51b3008 	ldr	r3, [fp, #-8]
    903c:	e51b200c 	ldr	r2, [fp, #-12]
    9040:	e0823003 	add	r3, r2, r3
    9044:	e3a02000 	mov	r2, #0
    9048:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:185 (discriminator 2)
	for (int i = 0; i < length; i++)
    904c:	e51b3008 	ldr	r3, [fp, #-8]
    9050:	e2833001 	add	r3, r3, #1
    9054:	e50b3008 	str	r3, [fp, #-8]
    9058:	eafffff2 	b	9028 <_Z5bzeroPvi+0x24>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:187
}
    905c:	e320f000 	nop	{0}
    9060:	e28bd000 	add	sp, fp, #0
    9064:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9068:	e12fff1e 	bx	lr

0000906c <_Z6memcpyPKvPvi>:
_Z6memcpyPKvPvi():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:190

void memcpy(const void* src, void* dst, int num)
{
    906c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9070:	e28db000 	add	fp, sp, #0
    9074:	e24dd024 	sub	sp, sp, #36	; 0x24
    9078:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    907c:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    9080:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:191
	const char* memsrc = reinterpret_cast<const char*>(src);
    9084:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9088:	e50b300c 	str	r3, [fp, #-12]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:192
	char* memdst = reinterpret_cast<char*>(dst);
    908c:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    9090:	e50b3010 	str	r3, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:194

	for (int i = 0; i < num; i++)
    9094:	e3a03000 	mov	r3, #0
    9098:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:194 (discriminator 3)
    909c:	e51b2008 	ldr	r2, [fp, #-8]
    90a0:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    90a4:	e1520003 	cmp	r2, r3
    90a8:	aa00000b 	bge	90dc <_Z6memcpyPKvPvi+0x70>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:195 (discriminator 2)
		memdst[i] = memsrc[i];
    90ac:	e51b3008 	ldr	r3, [fp, #-8]
    90b0:	e51b200c 	ldr	r2, [fp, #-12]
    90b4:	e0822003 	add	r2, r2, r3
    90b8:	e51b3008 	ldr	r3, [fp, #-8]
    90bc:	e51b1010 	ldr	r1, [fp, #-16]
    90c0:	e0813003 	add	r3, r1, r3
    90c4:	e5d22000 	ldrb	r2, [r2]
    90c8:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:194 (discriminator 2)
	for (int i = 0; i < num; i++)
    90cc:	e51b3008 	ldr	r3, [fp, #-8]
    90d0:	e2833001 	add	r3, r3, #1
    90d4:	e50b3008 	str	r3, [fp, #-8]
    90d8:	eaffffef 	b	909c <_Z6memcpyPKvPvi+0x30>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:196
}
    90dc:	e320f000 	nop	{0}
    90e0:	e28bd000 	add	sp, fp, #0
    90e4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    90e8:	e12fff1e 	bx	lr

000090ec <_Z4n_tuii>:
_Z4n_tuii():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:201



int n_tu(int number, int count)
{
    90ec:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    90f0:	e28db000 	add	fp, sp, #0
    90f4:	e24dd014 	sub	sp, sp, #20
    90f8:	e50b0010 	str	r0, [fp, #-16]
    90fc:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:202
    int result = 1;
    9100:	e3a03001 	mov	r3, #1
    9104:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:203
    while(count-- > 0)
    9108:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    910c:	e2432001 	sub	r2, r3, #1
    9110:	e50b2014 	str	r2, [fp, #-20]	; 0xffffffec
    9114:	e3530000 	cmp	r3, #0
    9118:	c3a03001 	movgt	r3, #1
    911c:	d3a03000 	movle	r3, #0
    9120:	e6ef3073 	uxtb	r3, r3
    9124:	e3530000 	cmp	r3, #0
    9128:	0a000004 	beq	9140 <_Z4n_tuii+0x54>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:204
        result *= number;
    912c:	e51b3008 	ldr	r3, [fp, #-8]
    9130:	e51b2010 	ldr	r2, [fp, #-16]
    9134:	e0030392 	mul	r3, r2, r3
    9138:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:203
    while(count-- > 0)
    913c:	eafffff1 	b	9108 <_Z4n_tuii+0x1c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:206

    return result;
    9140:	e51b3008 	ldr	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:207
}
    9144:	e1a00003 	mov	r0, r3
    9148:	e28bd000 	add	sp, fp, #0
    914c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9150:	e12fff1e 	bx	lr

00009154 <_Z4ftoafPc>:
_Z4ftoafPc():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:211

/*** Convert float to string ***/
void ftoa(float f, char r[])
{
    9154:	e92d4bf0 	push	{r4, r5, r6, r7, r8, r9, fp, lr}
    9158:	e28db01c 	add	fp, sp, #28
    915c:	e24dd068 	sub	sp, sp, #104	; 0x68
    9160:	ed0b0a16 	vstr	s0, [fp, #-88]	; 0xffffffa8
    9164:	e50b005c 	str	r0, [fp, #-92]	; 0xffffffa4
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:215
    long long int length, length2, i, number, position, sign;
    float number2;

    sign = -1;   // -1 == positive number
    9168:	e3e02000 	mvn	r2, #0
    916c:	e3e03000 	mvn	r3, #0
    9170:	e14b24fc 	strd	r2, [fp, #-76]	; 0xffffffb4
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:216
    if (f < 0)
    9174:	ed5b7a16 	vldr	s15, [fp, #-88]	; 0xffffffa8
    9178:	eef57ac0 	vcmpe.f32	s15, #0.0
    917c:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    9180:	5a000005 	bpl	919c <_Z4ftoafPc+0x48>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:218
    {
        sign = '-';
    9184:	e3a0202d 	mov	r2, #45	; 0x2d
    9188:	e3a03000 	mov	r3, #0
    918c:	e14b24fc 	strd	r2, [fp, #-76]	; 0xffffffb4
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:219
        f *= -1;
    9190:	ed5b7a16 	vldr	s15, [fp, #-88]	; 0xffffffa8
    9194:	eef17a67 	vneg.f32	s15, s15
    9198:	ed4b7a16 	vstr	s15, [fp, #-88]	; 0xffffffa8
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:222
    }

    number2 = f;
    919c:	e51b3058 	ldr	r3, [fp, #-88]	; 0xffffffa8
    91a0:	e50b3050 	str	r3, [fp, #-80]	; 0xffffffb0
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:223
    number = f;
    91a4:	e51b0058 	ldr	r0, [fp, #-88]	; 0xffffffa8
    91a8:	eb000200 	bl	99b0 <__aeabi_f2lz>
    91ac:	e1a02000 	mov	r2, r0
    91b0:	e1a03001 	mov	r3, r1
    91b4:	e14b23fc 	strd	r2, [fp, #-60]	; 0xffffffc4
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:224
    length = 0;  // Size of decimal part
    91b8:	e3a02000 	mov	r2, #0
    91bc:	e3a03000 	mov	r3, #0
    91c0:	e14b22f4 	strd	r2, [fp, #-36]	; 0xffffffdc
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:225
    length2 = 0; // Size of tenth
    91c4:	e3a02000 	mov	r2, #0
    91c8:	e3a03000 	mov	r3, #0
    91cc:	e14b22fc 	strd	r2, [fp, #-44]	; 0xffffffd4
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:228

    /* Calculate length2 tenth part */
    while( (number2 - (float)number) != 0.0 && !((number2 - (float)number) < 0.0) )
    91d0:	e14b03dc 	ldrd	r0, [fp, #-60]	; 0xffffffc4
    91d4:	eb0001a1 	bl	9860 <__aeabi_l2f>
    91d8:	ee070a10 	vmov	s14, r0
    91dc:	ed5b7a14 	vldr	s15, [fp, #-80]	; 0xffffffb0
    91e0:	ee777ac7 	vsub.f32	s15, s15, s14
    91e4:	eef57a40 	vcmp.f32	s15, #0.0
    91e8:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    91ec:	0a00001b 	beq	9260 <_Z4ftoafPc+0x10c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:228 (discriminator 1)
    91f0:	e14b03dc 	ldrd	r0, [fp, #-60]	; 0xffffffc4
    91f4:	eb000199 	bl	9860 <__aeabi_l2f>
    91f8:	ee070a10 	vmov	s14, r0
    91fc:	ed5b7a14 	vldr	s15, [fp, #-80]	; 0xffffffb0
    9200:	ee777ac7 	vsub.f32	s15, s15, s14
    9204:	eef57ac0 	vcmpe.f32	s15, #0.0
    9208:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    920c:	4a000013 	bmi	9260 <_Z4ftoafPc+0x10c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:230
    {
        number2 = f * (n_tu(10.0, length2 + 1));
    9210:	e51b302c 	ldr	r3, [fp, #-44]	; 0xffffffd4
    9214:	e2833001 	add	r3, r3, #1
    9218:	e1a01003 	mov	r1, r3
    921c:	e3a0000a 	mov	r0, #10
    9220:	ebffffb1 	bl	90ec <_Z4n_tuii>
    9224:	ee070a90 	vmov	s15, r0
    9228:	eef87ae7 	vcvt.f32.s32	s15, s15
    922c:	ed1b7a16 	vldr	s14, [fp, #-88]	; 0xffffffa8
    9230:	ee677a27 	vmul.f32	s15, s14, s15
    9234:	ed4b7a14 	vstr	s15, [fp, #-80]	; 0xffffffb0
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:231
        number = number2;
    9238:	e51b0050 	ldr	r0, [fp, #-80]	; 0xffffffb0
    923c:	eb0001db 	bl	99b0 <__aeabi_f2lz>
    9240:	e1a02000 	mov	r2, r0
    9244:	e1a03001 	mov	r3, r1
    9248:	e14b23fc 	strd	r2, [fp, #-60]	; 0xffffffc4
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:233

        length2++;
    924c:	e14b22dc 	ldrd	r2, [fp, #-44]	; 0xffffffd4
    9250:	e2926001 	adds	r6, r2, #1
    9254:	e2a37000 	adc	r7, r3, #0
    9258:	e14b62fc 	strd	r6, [fp, #-44]	; 0xffffffd4
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:228
    while( (number2 - (float)number) != 0.0 && !((number2 - (float)number) < 0.0) )
    925c:	eaffffdb 	b	91d0 <_Z4ftoafPc+0x7c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:237
    }

    /* Calculate length decimal part */
    for (length = (f > 1) ? 0 : 1; f > 1; length++)
    9260:	ed5b7a16 	vldr	s15, [fp, #-88]	; 0xffffffa8
    9264:	ed9f7a82 	vldr	s14, [pc, #520]	; 9474 <_Z4ftoafPc+0x320>
    9268:	eef47ac7 	vcmpe.f32	s15, s14
    926c:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    9270:	c3a03001 	movgt	r3, #1
    9274:	d3a03000 	movle	r3, #0
    9278:	e6ef3073 	uxtb	r3, r3
    927c:	e2233001 	eor	r3, r3, #1
    9280:	e6ef3073 	uxtb	r3, r3
    9284:	e6ef3073 	uxtb	r3, r3
    9288:	e3a02000 	mov	r2, #0
    928c:	e50b3064 	str	r3, [fp, #-100]	; 0xffffff9c
    9290:	e50b2060 	str	r2, [fp, #-96]	; 0xffffffa0
    9294:	e14b26d4 	ldrd	r2, [fp, #-100]	; 0xffffff9c
    9298:	e14b22f4 	strd	r2, [fp, #-36]	; 0xffffffdc
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:237 (discriminator 3)
    929c:	ed5b7a16 	vldr	s15, [fp, #-88]	; 0xffffffa8
    92a0:	ed9f7a73 	vldr	s14, [pc, #460]	; 9474 <_Z4ftoafPc+0x320>
    92a4:	eef47ac7 	vcmpe.f32	s15, s14
    92a8:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    92ac:	da00000b 	ble	92e0 <_Z4ftoafPc+0x18c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:238 (discriminator 2)
        f /= 10;
    92b0:	ed1b7a16 	vldr	s14, [fp, #-88]	; 0xffffffa8
    92b4:	eddf6a6f 	vldr	s13, [pc, #444]	; 9478 <_Z4ftoafPc+0x324>
    92b8:	eec77a26 	vdiv.f32	s15, s14, s13
    92bc:	ed4b7a16 	vstr	s15, [fp, #-88]	; 0xffffffa8
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:237 (discriminator 2)
    for (length = (f > 1) ? 0 : 1; f > 1; length++)
    92c0:	e14b22d4 	ldrd	r2, [fp, #-36]	; 0xffffffdc
    92c4:	e2921001 	adds	r1, r2, #1
    92c8:	e50b106c 	str	r1, [fp, #-108]	; 0xffffff94
    92cc:	e2a33000 	adc	r3, r3, #0
    92d0:	e50b3068 	str	r3, [fp, #-104]	; 0xffffff98
    92d4:	e14b26dc 	ldrd	r2, [fp, #-108]	; 0xffffff94
    92d8:	e14b22f4 	strd	r2, [fp, #-36]	; 0xffffffdc
    92dc:	eaffffee 	b	929c <_Z4ftoafPc+0x148>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:240

    position = length;
    92e0:	e14b22d4 	ldrd	r2, [fp, #-36]	; 0xffffffdc
    92e4:	e14b24f4 	strd	r2, [fp, #-68]	; 0xffffffbc
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:241
    length = length + 1 + length2;
    92e8:	e14b22d4 	ldrd	r2, [fp, #-36]	; 0xffffffdc
    92ec:	e2924001 	adds	r4, r2, #1
    92f0:	e2a35000 	adc	r5, r3, #0
    92f4:	e14b22dc 	ldrd	r2, [fp, #-44]	; 0xffffffd4
    92f8:	e0921004 	adds	r1, r2, r4
    92fc:	e50b1074 	str	r1, [fp, #-116]	; 0xffffff8c
    9300:	e0a33005 	adc	r3, r3, r5
    9304:	e50b3070 	str	r3, [fp, #-112]	; 0xffffff90
    9308:	e14b27d4 	ldrd	r2, [fp, #-116]	; 0xffffff8c
    930c:	e14b22f4 	strd	r2, [fp, #-36]	; 0xffffffdc
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:242
    number = number2;
    9310:	e51b0050 	ldr	r0, [fp, #-80]	; 0xffffffb0
    9314:	eb0001a5 	bl	99b0 <__aeabi_f2lz>
    9318:	e1a02000 	mov	r2, r0
    931c:	e1a03001 	mov	r3, r1
    9320:	e14b23fc 	strd	r2, [fp, #-60]	; 0xffffffc4
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:243
    if (sign == '-')
    9324:	e14b24dc 	ldrd	r2, [fp, #-76]	; 0xffffffb4
    9328:	e242102d 	sub	r1, r2, #45	; 0x2d
    932c:	e1913003 	orrs	r3, r1, r3
    9330:	1a00000d 	bne	936c <_Z4ftoafPc+0x218>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:245
    {
        length++;
    9334:	e14b22d4 	ldrd	r2, [fp, #-36]	; 0xffffffdc
    9338:	e2921001 	adds	r1, r2, #1
    933c:	e50b107c 	str	r1, [fp, #-124]	; 0xffffff84
    9340:	e2a33000 	adc	r3, r3, #0
    9344:	e50b3078 	str	r3, [fp, #-120]	; 0xffffff88
    9348:	e14b27dc 	ldrd	r2, [fp, #-124]	; 0xffffff84
    934c:	e14b22f4 	strd	r2, [fp, #-36]	; 0xffffffdc
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:246
        position++;
    9350:	e14b24d4 	ldrd	r2, [fp, #-68]	; 0xffffffbc
    9354:	e2921001 	adds	r1, r2, #1
    9358:	e50b1084 	str	r1, [fp, #-132]	; 0xffffff7c
    935c:	e2a33000 	adc	r3, r3, #0
    9360:	e50b3080 	str	r3, [fp, #-128]	; 0xffffff80
    9364:	e14b28d4 	ldrd	r2, [fp, #-132]	; 0xffffff7c
    9368:	e14b24f4 	strd	r2, [fp, #-68]	; 0xffffffbc
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:249
    }

    for (i = length; i >= 0 ; i--)
    936c:	e14b22d4 	ldrd	r2, [fp, #-36]	; 0xffffffdc
    9370:	e14b23f4 	strd	r2, [fp, #-52]	; 0xffffffcc
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:249 (discriminator 1)
    9374:	e14b23d4 	ldrd	r2, [fp, #-52]	; 0xffffffcc
    9378:	e3530000 	cmp	r3, #0
    937c:	ba000039 	blt	9468 <_Z4ftoafPc+0x314>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:251
    {
        if (i == (length))
    9380:	e14b03d4 	ldrd	r0, [fp, #-52]	; 0xffffffcc
    9384:	e14b22d4 	ldrd	r2, [fp, #-36]	; 0xffffffdc
    9388:	e1510003 	cmp	r1, r3
    938c:	01500002 	cmpeq	r0, r2
    9390:	1a000005 	bne	93ac <_Z4ftoafPc+0x258>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:252
            r[i] = '\0';
    9394:	e51b3034 	ldr	r3, [fp, #-52]	; 0xffffffcc
    9398:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    939c:	e0823003 	add	r3, r2, r3
    93a0:	e3a02000 	mov	r2, #0
    93a4:	e5c32000 	strb	r2, [r3]
    93a8:	ea000029 	b	9454 <_Z4ftoafPc+0x300>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:253
        else if(i == (position))
    93ac:	e14b03d4 	ldrd	r0, [fp, #-52]	; 0xffffffcc
    93b0:	e14b24d4 	ldrd	r2, [fp, #-68]	; 0xffffffbc
    93b4:	e1510003 	cmp	r1, r3
    93b8:	01500002 	cmpeq	r0, r2
    93bc:	1a000005 	bne	93d8 <_Z4ftoafPc+0x284>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:254
            r[i] = '.';
    93c0:	e51b3034 	ldr	r3, [fp, #-52]	; 0xffffffcc
    93c4:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    93c8:	e0823003 	add	r3, r2, r3
    93cc:	e3a0202e 	mov	r2, #46	; 0x2e
    93d0:	e5c32000 	strb	r2, [r3]
    93d4:	ea00001e 	b	9454 <_Z4ftoafPc+0x300>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:255
        else if(sign == '-' && i == 0)
    93d8:	e14b24dc 	ldrd	r2, [fp, #-76]	; 0xffffffb4
    93dc:	e242102d 	sub	r1, r2, #45	; 0x2d
    93e0:	e1913003 	orrs	r3, r1, r3
    93e4:	1a000008 	bne	940c <_Z4ftoafPc+0x2b8>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:255 (discriminator 1)
    93e8:	e14b23d4 	ldrd	r2, [fp, #-52]	; 0xffffffcc
    93ec:	e1923003 	orrs	r3, r2, r3
    93f0:	1a000005 	bne	940c <_Z4ftoafPc+0x2b8>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:256
            r[i] = '-';
    93f4:	e51b3034 	ldr	r3, [fp, #-52]	; 0xffffffcc
    93f8:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    93fc:	e0823003 	add	r3, r2, r3
    9400:	e3a0202d 	mov	r2, #45	; 0x2d
    9404:	e5c32000 	strb	r2, [r3]
    9408:	ea000011 	b	9454 <_Z4ftoafPc+0x300>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:259
        else
        {
            r[i] = (number % 10) + '0';
    940c:	e14b03dc 	ldrd	r0, [fp, #-60]	; 0xffffffc4
    9410:	e3a0200a 	mov	r2, #10
    9414:	e3a03000 	mov	r3, #0
    9418:	eb00012f 	bl	98dc <__aeabi_ldivmod>
    941c:	e6ef2072 	uxtb	r2, r2
    9420:	e51b3034 	ldr	r3, [fp, #-52]	; 0xffffffcc
    9424:	e51b105c 	ldr	r1, [fp, #-92]	; 0xffffffa4
    9428:	e0813003 	add	r3, r1, r3
    942c:	e2822030 	add	r2, r2, #48	; 0x30
    9430:	e6ef2072 	uxtb	r2, r2
    9434:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:260
            number /=10;
    9438:	e14b03dc 	ldrd	r0, [fp, #-60]	; 0xffffffc4
    943c:	e3a0200a 	mov	r2, #10
    9440:	e3a03000 	mov	r3, #0
    9444:	eb000124 	bl	98dc <__aeabi_ldivmod>
    9448:	e1a02000 	mov	r2, r0
    944c:	e1a03001 	mov	r3, r1
    9450:	e14b23fc 	strd	r2, [fp, #-60]	; 0xffffffc4
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:249 (discriminator 2)
    for (i = length; i >= 0 ; i--)
    9454:	e14b23d4 	ldrd	r2, [fp, #-52]	; 0xffffffcc
    9458:	e2528001 	subs	r8, r2, #1
    945c:	e2c39000 	sbc	r9, r3, #0
    9460:	e14b83f4 	strd	r8, [fp, #-52]	; 0xffffffcc
    9464:	eaffffc2 	b	9374 <_Z4ftoafPc+0x220>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:263
        }
    }
}
    9468:	e320f000 	nop	{0}
    946c:	e24bd01c 	sub	sp, fp, #28
    9470:	e8bd8bf0 	pop	{r4, r5, r6, r7, r8, r9, fp, pc}
    9474:	3f800000 	svccc	0x00800000
    9478:	41200000 			; <UNDEFINED> instruction: 0x41200000

0000947c <__udivsi3>:
__udivsi3():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1104
    947c:	e2512001 	subs	r2, r1, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1106
    9480:	012fff1e 	bxeq	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1107
    9484:	3a000074 	bcc	965c <__udivsi3+0x1e0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1108
    9488:	e1500001 	cmp	r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1109
    948c:	9a00006b 	bls	9640 <__udivsi3+0x1c4>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1110
    9490:	e1110002 	tst	r1, r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1111
    9494:	0a00006c 	beq	964c <__udivsi3+0x1d0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1113
    9498:	e16f3f10 	clz	r3, r0
    949c:	e16f2f11 	clz	r2, r1
    94a0:	e0423003 	sub	r3, r2, r3
    94a4:	e273301f 	rsbs	r3, r3, #31
    94a8:	10833083 	addne	r3, r3, r3, lsl #1
    94ac:	e3a02000 	mov	r2, #0
    94b0:	108ff103 	addne	pc, pc, r3, lsl #2
    94b4:	e1a00000 	nop			; (mov r0, r0)
    94b8:	e1500f81 	cmp	r0, r1, lsl #31
    94bc:	e0a22002 	adc	r2, r2, r2
    94c0:	20400f81 	subcs	r0, r0, r1, lsl #31
    94c4:	e1500f01 	cmp	r0, r1, lsl #30
    94c8:	e0a22002 	adc	r2, r2, r2
    94cc:	20400f01 	subcs	r0, r0, r1, lsl #30
    94d0:	e1500e81 	cmp	r0, r1, lsl #29
    94d4:	e0a22002 	adc	r2, r2, r2
    94d8:	20400e81 	subcs	r0, r0, r1, lsl #29
    94dc:	e1500e01 	cmp	r0, r1, lsl #28
    94e0:	e0a22002 	adc	r2, r2, r2
    94e4:	20400e01 	subcs	r0, r0, r1, lsl #28
    94e8:	e1500d81 	cmp	r0, r1, lsl #27
    94ec:	e0a22002 	adc	r2, r2, r2
    94f0:	20400d81 	subcs	r0, r0, r1, lsl #27
    94f4:	e1500d01 	cmp	r0, r1, lsl #26
    94f8:	e0a22002 	adc	r2, r2, r2
    94fc:	20400d01 	subcs	r0, r0, r1, lsl #26
    9500:	e1500c81 	cmp	r0, r1, lsl #25
    9504:	e0a22002 	adc	r2, r2, r2
    9508:	20400c81 	subcs	r0, r0, r1, lsl #25
    950c:	e1500c01 	cmp	r0, r1, lsl #24
    9510:	e0a22002 	adc	r2, r2, r2
    9514:	20400c01 	subcs	r0, r0, r1, lsl #24
    9518:	e1500b81 	cmp	r0, r1, lsl #23
    951c:	e0a22002 	adc	r2, r2, r2
    9520:	20400b81 	subcs	r0, r0, r1, lsl #23
    9524:	e1500b01 	cmp	r0, r1, lsl #22
    9528:	e0a22002 	adc	r2, r2, r2
    952c:	20400b01 	subcs	r0, r0, r1, lsl #22
    9530:	e1500a81 	cmp	r0, r1, lsl #21
    9534:	e0a22002 	adc	r2, r2, r2
    9538:	20400a81 	subcs	r0, r0, r1, lsl #21
    953c:	e1500a01 	cmp	r0, r1, lsl #20
    9540:	e0a22002 	adc	r2, r2, r2
    9544:	20400a01 	subcs	r0, r0, r1, lsl #20
    9548:	e1500981 	cmp	r0, r1, lsl #19
    954c:	e0a22002 	adc	r2, r2, r2
    9550:	20400981 	subcs	r0, r0, r1, lsl #19
    9554:	e1500901 	cmp	r0, r1, lsl #18
    9558:	e0a22002 	adc	r2, r2, r2
    955c:	20400901 	subcs	r0, r0, r1, lsl #18
    9560:	e1500881 	cmp	r0, r1, lsl #17
    9564:	e0a22002 	adc	r2, r2, r2
    9568:	20400881 	subcs	r0, r0, r1, lsl #17
    956c:	e1500801 	cmp	r0, r1, lsl #16
    9570:	e0a22002 	adc	r2, r2, r2
    9574:	20400801 	subcs	r0, r0, r1, lsl #16
    9578:	e1500781 	cmp	r0, r1, lsl #15
    957c:	e0a22002 	adc	r2, r2, r2
    9580:	20400781 	subcs	r0, r0, r1, lsl #15
    9584:	e1500701 	cmp	r0, r1, lsl #14
    9588:	e0a22002 	adc	r2, r2, r2
    958c:	20400701 	subcs	r0, r0, r1, lsl #14
    9590:	e1500681 	cmp	r0, r1, lsl #13
    9594:	e0a22002 	adc	r2, r2, r2
    9598:	20400681 	subcs	r0, r0, r1, lsl #13
    959c:	e1500601 	cmp	r0, r1, lsl #12
    95a0:	e0a22002 	adc	r2, r2, r2
    95a4:	20400601 	subcs	r0, r0, r1, lsl #12
    95a8:	e1500581 	cmp	r0, r1, lsl #11
    95ac:	e0a22002 	adc	r2, r2, r2
    95b0:	20400581 	subcs	r0, r0, r1, lsl #11
    95b4:	e1500501 	cmp	r0, r1, lsl #10
    95b8:	e0a22002 	adc	r2, r2, r2
    95bc:	20400501 	subcs	r0, r0, r1, lsl #10
    95c0:	e1500481 	cmp	r0, r1, lsl #9
    95c4:	e0a22002 	adc	r2, r2, r2
    95c8:	20400481 	subcs	r0, r0, r1, lsl #9
    95cc:	e1500401 	cmp	r0, r1, lsl #8
    95d0:	e0a22002 	adc	r2, r2, r2
    95d4:	20400401 	subcs	r0, r0, r1, lsl #8
    95d8:	e1500381 	cmp	r0, r1, lsl #7
    95dc:	e0a22002 	adc	r2, r2, r2
    95e0:	20400381 	subcs	r0, r0, r1, lsl #7
    95e4:	e1500301 	cmp	r0, r1, lsl #6
    95e8:	e0a22002 	adc	r2, r2, r2
    95ec:	20400301 	subcs	r0, r0, r1, lsl #6
    95f0:	e1500281 	cmp	r0, r1, lsl #5
    95f4:	e0a22002 	adc	r2, r2, r2
    95f8:	20400281 	subcs	r0, r0, r1, lsl #5
    95fc:	e1500201 	cmp	r0, r1, lsl #4
    9600:	e0a22002 	adc	r2, r2, r2
    9604:	20400201 	subcs	r0, r0, r1, lsl #4
    9608:	e1500181 	cmp	r0, r1, lsl #3
    960c:	e0a22002 	adc	r2, r2, r2
    9610:	20400181 	subcs	r0, r0, r1, lsl #3
    9614:	e1500101 	cmp	r0, r1, lsl #2
    9618:	e0a22002 	adc	r2, r2, r2
    961c:	20400101 	subcs	r0, r0, r1, lsl #2
    9620:	e1500081 	cmp	r0, r1, lsl #1
    9624:	e0a22002 	adc	r2, r2, r2
    9628:	20400081 	subcs	r0, r0, r1, lsl #1
    962c:	e1500001 	cmp	r0, r1
    9630:	e0a22002 	adc	r2, r2, r2
    9634:	20400001 	subcs	r0, r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1115
    9638:	e1a00002 	mov	r0, r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1116
    963c:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1119
    9640:	03a00001 	moveq	r0, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1120
    9644:	13a00000 	movne	r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1121
    9648:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1123
    964c:	e16f2f11 	clz	r2, r1
    9650:	e262201f 	rsb	r2, r2, #31
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1125
    9654:	e1a00230 	lsr	r0, r0, r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1126
    9658:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1130
    965c:	e3500000 	cmp	r0, #0
    9660:	13e00000 	mvnne	r0, #0
    9664:	ea000007 	b	9688 <__aeabi_idiv0>

00009668 <__aeabi_uidivmod>:
__aeabi_uidivmod():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1161
    9668:	e3510000 	cmp	r1, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1162
    966c:	0afffffa 	beq	965c <__udivsi3+0x1e0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1163
    9670:	e92d4003 	push	{r0, r1, lr}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1164
    9674:	ebffff80 	bl	947c <__udivsi3>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1165
    9678:	e8bd4006 	pop	{r1, r2, lr}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1166
    967c:	e0030092 	mul	r3, r2, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1167
    9680:	e0411003 	sub	r1, r1, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1168
    9684:	e12fff1e 	bx	lr

00009688 <__aeabi_idiv0>:
__aeabi_ldiv0():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1466
    9688:	e12fff1e 	bx	lr

0000968c <__aeabi_frsub>:
__aeabi_frsub():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:59
    968c:	e2200102 	eor	r0, r0, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:60
    9690:	ea000000 	b	9698 <__addsf3>

00009694 <__aeabi_fsub>:
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:65
    9694:	e2211102 	eor	r1, r1, #-2147483648	; 0x80000000

00009698 <__addsf3>:
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:74
    9698:	e1b02080 	lsls	r2, r0, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:76
    969c:	11b03081 	lslsne	r3, r1, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:77
    96a0:	11320003 	teqne	r2, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:78
    96a4:	11f0cc42 	mvnsne	ip, r2, asr #24
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:79
    96a8:	11f0cc43 	mvnsne	ip, r3, asr #24
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:80
    96ac:	0a00003c 	beq	97a4 <__addsf3+0x10c>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:84
    96b0:	e1a02c22 	lsr	r2, r2, #24
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:85
    96b4:	e0723c23 	rsbs	r3, r2, r3, lsr #24
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:87
    96b8:	c0822003 	addgt	r2, r2, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:88
    96bc:	c0201001 	eorgt	r1, r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:89
    96c0:	c0210000 	eorgt	r0, r1, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:90
    96c4:	c0201001 	eorgt	r1, r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:92
    96c8:	b2633000 	rsblt	r3, r3, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:97
    96cc:	e3530019 	cmp	r3, #25
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:99
    96d0:	812fff1e 	bxhi	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:102
    96d4:	e3100102 	tst	r0, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:103
    96d8:	e3800502 	orr	r0, r0, #8388608	; 0x800000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:104
    96dc:	e3c004ff 	bic	r0, r0, #-16777216	; 0xff000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:106
    96e0:	12600000 	rsbne	r0, r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:107
    96e4:	e3110102 	tst	r1, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:108
    96e8:	e3811502 	orr	r1, r1, #8388608	; 0x800000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:109
    96ec:	e3c114ff 	bic	r1, r1, #-16777216	; 0xff000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:111
    96f0:	12611000 	rsbne	r1, r1, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:115
    96f4:	e1320003 	teq	r2, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:116
    96f8:	0a000023 	beq	978c <__addsf3+0xf4>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:120
    96fc:	e2422001 	sub	r2, r2, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:124
    9700:	e0900351 	adds	r0, r0, r1, asr r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:125
    9704:	e2633020 	rsb	r3, r3, #32
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:126
    9708:	e1a01311 	lsl	r1, r1, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:129
    970c:	e2003102 	and	r3, r0, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:130
    9710:	5a000001 	bpl	971c <__addsf3+0x84>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:135
    9714:	e2711000 	rsbs	r1, r1, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:136
    9718:	e2e00000 	rsc	r0, r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:141
    971c:	e3500502 	cmp	r0, #8388608	; 0x800000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:142
    9720:	3a00000b 	bcc	9754 <__addsf3+0xbc>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:143
    9724:	e3500401 	cmp	r0, #16777216	; 0x1000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:144
    9728:	3a000004 	bcc	9740 <__addsf3+0xa8>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:147
    972c:	e1b000a0 	lsrs	r0, r0, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:148
    9730:	e1a01061 	rrx	r1, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:149
    9734:	e2822001 	add	r2, r2, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:152
    9738:	e35200fe 	cmp	r2, #254	; 0xfe
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:153
    973c:	2a00002d 	bcs	97f8 <__addsf3+0x160>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:160
    9740:	e3510102 	cmp	r1, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:161
    9744:	e0a00b82 	adc	r0, r0, r2, lsl #23
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:163
    9748:	03c00001 	biceq	r0, r0, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:164
    974c:	e1800003 	orr	r0, r0, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:165
    9750:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:169
    9754:	e1b01081 	lsls	r1, r1, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:170
    9758:	e0a00000 	adc	r0, r0, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:171
    975c:	e2522001 	subs	r2, r2, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:173
    9760:	23500502 	cmpcs	r0, #8388608	; 0x800000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:174
    9764:	2afffff5 	bcs	9740 <__addsf3+0xa8>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:199
    9768:	e16fcf10 	clz	ip, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:200
    976c:	e24cc008 	sub	ip, ip, #8
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:201
    9770:	e052200c 	subs	r2, r2, ip
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:202
    9774:	e1a00c10 	lsl	r0, r0, ip
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:209
    9778:	a0800b82 	addge	r0, r0, r2, lsl #23
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:210
    977c:	b2622000 	rsblt	r2, r2, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:211
    9780:	a1800003 	orrge	r0, r0, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:217
    9784:	b1830230 	orrlt	r0, r3, r0, lsr r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:219
    9788:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:224
    978c:	e3320000 	teq	r2, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:225
    9790:	e2211502 	eor	r1, r1, #8388608	; 0x800000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:227
    9794:	02200502 	eoreq	r0, r0, #8388608	; 0x800000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:228
    9798:	02822001 	addeq	r2, r2, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:229
    979c:	12433001 	subne	r3, r3, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:230
    97a0:	eaffffd5 	b	96fc <__addsf3+0x64>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:233
    97a4:	e1a03081 	lsl	r3, r1, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:235
    97a8:	e1f0cc42 	mvns	ip, r2, asr #24
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:237
    97ac:	11f0cc43 	mvnsne	ip, r3, asr #24
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:238
    97b0:	0a000013 	beq	9804 <__addsf3+0x16c>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:240
    97b4:	e1320003 	teq	r2, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:241
    97b8:	0a000002 	beq	97c8 <__addsf3+0x130>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:244
    97bc:	e3320000 	teq	r2, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:246
    97c0:	01a00001 	moveq	r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:247
    97c4:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:249
    97c8:	e1300001 	teq	r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:253
    97cc:	13a00000 	movne	r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:254
    97d0:	112fff1e 	bxne	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:257
    97d4:	e31204ff 	tst	r2, #-16777216	; 0xff000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:258
    97d8:	1a000002 	bne	97e8 <__addsf3+0x150>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:259
    97dc:	e1b00080 	lsls	r0, r0, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:261
    97e0:	23800102 	orrcs	r0, r0, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:262
    97e4:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:263
    97e8:	e2922402 	adds	r2, r2, #33554432	; 0x2000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:265
    97ec:	32800502 	addcc	r0, r0, #8388608	; 0x800000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:266
    97f0:	312fff1e 	bxcc	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:267
    97f4:	e2003102 	and	r3, r0, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:271
    97f8:	e383047f 	orr	r0, r3, #2130706432	; 0x7f000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:272
    97fc:	e3800502 	orr	r0, r0, #8388608	; 0x800000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:273
    9800:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:282
    9804:	e1f02c42 	mvns	r2, r2, asr #24
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:284
    9808:	11a00001 	movne	r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:285
    980c:	01f03c43 	mvnseq	r3, r3, asr #24
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:286
    9810:	11a01000 	movne	r1, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:287
    9814:	e1b02480 	lsls	r2, r0, #9
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:289
    9818:	01b03481 	lslseq	r3, r1, #9
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:290
    981c:	01300001 	teqeq	r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:291
    9820:	13800501 	orrne	r0, r0, #4194304	; 0x400000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:292
    9824:	e12fff1e 	bx	lr

00009828 <__aeabi_ui2f>:
__aeabi_ui2f():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:305
    9828:	e3a03000 	mov	r3, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:306
    982c:	ea000001 	b	9838 <__aeabi_i2f+0x8>

00009830 <__aeabi_i2f>:
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:311
    9830:	e2103102 	ands	r3, r0, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:313
    9834:	42600000 	rsbmi	r0, r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:315
    9838:	e1b0c000 	movs	ip, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:317
    983c:	012fff1e 	bxeq	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:320
    9840:	e383344b 	orr	r3, r3, #1258291200	; 0x4b000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:323
    9844:	e1a01000 	mov	r1, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:325
    9848:	e3a00000 	mov	r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:326
    984c:	ea00000f 	b	9890 <__aeabi_l2f+0x30>

00009850 <__aeabi_ul2f>:
__floatundisf():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:338
    9850:	e1902001 	orrs	r2, r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:340
    9854:	012fff1e 	bxeq	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:342
    9858:	e3a03000 	mov	r3, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:343
    985c:	ea000005 	b	9878 <__aeabi_l2f+0x18>

00009860 <__aeabi_l2f>:
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:348
    9860:	e1902001 	orrs	r2, r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:350
    9864:	012fff1e 	bxeq	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:352
    9868:	e2113102 	ands	r3, r1, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:353
    986c:	5a000001 	bpl	9878 <__aeabi_l2f+0x18>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:358
    9870:	e2700000 	rsbs	r0, r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:359
    9874:	e2e11000 	rsc	r1, r1, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:362
    9878:	e1b0c001 	movs	ip, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:364
    987c:	01a0c000 	moveq	ip, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:365
    9880:	01a01000 	moveq	r1, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:366
    9884:	03a00000 	moveq	r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:369
    9888:	e383345b 	orr	r3, r3, #1526726656	; 0x5b000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:371
    988c:	02433201 	subeq	r3, r3, #268435456	; 0x10000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:372
    9890:	e2433502 	sub	r3, r3, #8388608	; 0x800000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:397
    9894:	e16f2f1c 	clz	r2, ip
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:398
    9898:	e2522008 	subs	r2, r2, #8
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:402
    989c:	e0433b82 	sub	r3, r3, r2, lsl #23
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:403
    98a0:	ba000006 	blt	98c0 <__aeabi_l2f+0x60>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:405
    98a4:	e0833211 	add	r3, r3, r1, lsl r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:406
    98a8:	e1a0c210 	lsl	ip, r0, r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:407
    98ac:	e2622020 	rsb	r2, r2, #32
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:408
    98b0:	e35c0102 	cmp	ip, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:409
    98b4:	e0a30230 	adc	r0, r3, r0, lsr r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:411
    98b8:	03c00001 	biceq	r0, r0, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:412
    98bc:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:414
    98c0:	e2822020 	add	r2, r2, #32
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:415
    98c4:	e1a0c211 	lsl	ip, r1, r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:416
    98c8:	e2622020 	rsb	r2, r2, #32
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:417
    98cc:	e190008c 	orrs	r0, r0, ip, lsl #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:418
    98d0:	e0a30231 	adc	r0, r3, r1, lsr r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:420
    98d4:	01c00fac 	biceq	r0, r0, ip, lsr #31
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:421
    98d8:	e12fff1e 	bx	lr

000098dc <__aeabi_ldivmod>:
__aeabi_ldivmod():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:186
    98dc:	e3530000 	cmp	r3, #0
    98e0:	03520000 	cmpeq	r2, #0
    98e4:	1a000007 	bne	9908 <__aeabi_ldivmod+0x2c>
    98e8:	e3510000 	cmp	r1, #0
    98ec:	b3a01102 	movlt	r1, #-2147483648	; 0x80000000
    98f0:	b3a00000 	movlt	r0, #0
    98f4:	ba000002 	blt	9904 <__aeabi_ldivmod+0x28>
    98f8:	03500000 	cmpeq	r0, #0
    98fc:	13e01102 	mvnne	r1, #-2147483648	; 0x80000000
    9900:	13e00000 	mvnne	r0, #0
    9904:	eaffff5f 	b	9688 <__aeabi_idiv0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:188
    9908:	e24dd008 	sub	sp, sp, #8
    990c:	e92d6000 	push	{sp, lr}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:189
    9910:	e3510000 	cmp	r1, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:190
    9914:	ba000006 	blt	9934 <__aeabi_ldivmod+0x58>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:191
    9918:	e3530000 	cmp	r3, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:192
    991c:	ba000011 	blt	9968 <__aeabi_ldivmod+0x8c>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:194
    9920:	eb00003e 	bl	9a20 <__udivmoddi4>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:196
    9924:	e59de004 	ldr	lr, [sp, #4]
    9928:	e28dd008 	add	sp, sp, #8
    992c:	e8bd000c 	pop	{r2, r3}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:197
    9930:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:201
    9934:	e2700000 	rsbs	r0, r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:202
    9938:	e0c11081 	sbc	r1, r1, r1, lsl #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:203
    993c:	e3530000 	cmp	r3, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:204
    9940:	ba000011 	blt	998c <__aeabi_ldivmod+0xb0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:206
    9944:	eb000035 	bl	9a20 <__udivmoddi4>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:208
    9948:	e59de004 	ldr	lr, [sp, #4]
    994c:	e28dd008 	add	sp, sp, #8
    9950:	e8bd000c 	pop	{r2, r3}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:209
    9954:	e2700000 	rsbs	r0, r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:210
    9958:	e0c11081 	sbc	r1, r1, r1, lsl #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:211
    995c:	e2722000 	rsbs	r2, r2, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:212
    9960:	e0c33083 	sbc	r3, r3, r3, lsl #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:213
    9964:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:217
    9968:	e2722000 	rsbs	r2, r2, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:218
    996c:	e0c33083 	sbc	r3, r3, r3, lsl #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:220
    9970:	eb00002a 	bl	9a20 <__udivmoddi4>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:222
    9974:	e59de004 	ldr	lr, [sp, #4]
    9978:	e28dd008 	add	sp, sp, #8
    997c:	e8bd000c 	pop	{r2, r3}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:223
    9980:	e2700000 	rsbs	r0, r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:224
    9984:	e0c11081 	sbc	r1, r1, r1, lsl #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:225
    9988:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:229
    998c:	e2722000 	rsbs	r2, r2, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:230
    9990:	e0c33083 	sbc	r3, r3, r3, lsl #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:232
    9994:	eb000021 	bl	9a20 <__udivmoddi4>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:233
    9998:	e59de004 	ldr	lr, [sp, #4]
    999c:	e28dd008 	add	sp, sp, #8
    99a0:	e8bd000c 	pop	{r2, r3}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:234
    99a4:	e2722000 	rsbs	r2, r2, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:235
    99a8:	e0c33083 	sbc	r3, r3, r3, lsl #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:236
    99ac:	e12fff1e 	bx	lr

000099b0 <__aeabi_f2lz>:
__fixsfdi():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1530
    99b0:	ee070a90 	vmov	s15, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1531
    99b4:	eef57ac0 	vcmpe.f32	s15, #0.0
    99b8:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    99bc:	4a000000 	bmi	99c4 <__aeabi_f2lz+0x14>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1533
    99c0:	ea000006 	b	99e0 <__aeabi_f2ulz>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1532
    99c4:	eef17a67 	vneg.f32	s15, s15
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1530
    99c8:	e92d4010 	push	{r4, lr}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1532
    99cc:	ee170a90 	vmov	r0, s15
    99d0:	eb000002 	bl	99e0 <__aeabi_f2ulz>
    99d4:	e2700000 	rsbs	r0, r0, #0
    99d8:	e2e11000 	rsc	r1, r1, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1534
    99dc:	e8bd8010 	pop	{r4, pc}

000099e0 <__aeabi_f2ulz>:
__fixunssfdi():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1471
    99e0:	ee070a90 	vmov	s15, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1476
    99e4:	ed9f6b09 	vldr	d6, [pc, #36]	; 9a10 <__aeabi_f2ulz+0x30>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1481
    99e8:	ed9f5b0a 	vldr	d5, [pc, #40]	; 9a18 <__aeabi_f2ulz+0x38>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1471
    99ec:	eeb77ae7 	vcvt.f64.f32	d7, s15
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1476
    99f0:	ee276b06 	vmul.f64	d6, d7, d6
    99f4:	eebc6bc6 	vcvt.u32.f64	s12, d6
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1481
    99f8:	eeb84b46 	vcvt.f64.u32	d4, s12
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1524
    99fc:	ee161a10 	vmov	r1, s12
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1481
    9a00:	ee047b45 	vmls.f64	d7, d4, d5
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1524
    9a04:	eefc7bc7 	vcvt.u32.f64	s15, d7
    9a08:	ee170a90 	vmov	r0, s15
    9a0c:	e12fff1e 	bx	lr
    9a10:	00000000 	andeq	r0, r0, r0
    9a14:	3df00000 	ldclcc	0, cr0, [r0]
    9a18:	00000000 	andeq	r0, r0, r0
    9a1c:	41f00000 	mvnsmi	r0, r0

00009a20 <__udivmoddi4>:
__udivmoddi4():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:960
    9a20:	e1500002 	cmp	r0, r2
    9a24:	e0d1c003 	sbcs	ip, r1, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:948
    9a28:	e92d43f0 	push	{r4, r5, r6, r7, r8, r9, lr}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:949
    9a2c:	33a05000 	movcc	r5, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:948
    9a30:	e59d701c 	ldr	r7, [sp, #28]
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:949
    9a34:	31a06005 	movcc	r6, r5
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:960
    9a38:	3a00003b 	bcc	9b2c <__udivmoddi4+0x10c>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:962
    9a3c:	e3530000 	cmp	r3, #0
    9a40:	016fcf12 	clzeq	ip, r2
    9a44:	116fef13 	clzne	lr, r3
    9a48:	028ce020 	addeq	lr, ip, #32
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:963
    9a4c:	e3510000 	cmp	r1, #0
    9a50:	016fcf10 	clzeq	ip, r0
    9a54:	028cc020 	addeq	ip, ip, #32
    9a58:	116fcf11 	clzne	ip, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:965
    9a5c:	e04ec00c 	sub	ip, lr, ip
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:966
    9a60:	e1a03c13 	lsl	r3, r3, ip
    9a64:	e24c9020 	sub	r9, ip, #32
    9a68:	e1833912 	orr	r3, r3, r2, lsl r9
    9a6c:	e1a04c12 	lsl	r4, r2, ip
    9a70:	e26c8020 	rsb	r8, ip, #32
    9a74:	e1833832 	orr	r3, r3, r2, lsr r8
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:973
    9a78:	e1500004 	cmp	r0, r4
    9a7c:	e0d12003 	sbcs	r2, r1, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:949
    9a80:	33a05000 	movcc	r5, #0
    9a84:	31a06005 	movcc	r6, r5
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:973
    9a88:	3a000005 	bcc	9aa4 <__udivmoddi4+0x84>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:976
    9a8c:	e3a05001 	mov	r5, #1
    9a90:	e1a06915 	lsl	r6, r5, r9
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:975
    9a94:	e0500004 	subs	r0, r0, r4
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:976
    9a98:	e1866835 	orr	r6, r6, r5, lsr r8
    9a9c:	e1a05c15 	lsl	r5, r5, ip
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:975
    9aa0:	e0c11003 	sbc	r1, r1, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:979
    9aa4:	e35c0000 	cmp	ip, #0
    9aa8:	0a00001f 	beq	9b2c <__udivmoddi4+0x10c>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:981
    9aac:	e1a040a4 	lsr	r4, r4, #1
    9ab0:	e1844f83 	orr	r4, r4, r3, lsl #31
    9ab4:	e1a020a3 	lsr	r2, r3, #1
    9ab8:	e1a0e00c 	mov	lr, ip
    9abc:	ea000007 	b	9ae0 <__udivmoddi4+0xc0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:989
    9ac0:	e0503004 	subs	r3, r0, r4
    9ac4:	e0c11002 	sbc	r1, r1, r2
    9ac8:	e0933003 	adds	r3, r3, r3
    9acc:	e0a11001 	adc	r1, r1, r1
    9ad0:	e2930001 	adds	r0, r3, #1
    9ad4:	e2a11000 	adc	r1, r1, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:993
    9ad8:	e25ee001 	subs	lr, lr, #1
    9adc:	0a000006 	beq	9afc <__udivmoddi4+0xdc>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:988
    9ae0:	e1500004 	cmp	r0, r4
    9ae4:	e0d13002 	sbcs	r3, r1, r2
    9ae8:	2afffff4 	bcs	9ac0 <__udivmoddi4+0xa0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:991
    9aec:	e0900000 	adds	r0, r0, r0
    9af0:	e0a11001 	adc	r1, r1, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:993
    9af4:	e25ee001 	subs	lr, lr, #1
    9af8:	1afffff8 	bne	9ae0 <__udivmoddi4+0xc0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:997
    9afc:	e0955000 	adds	r5, r5, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:998
    9b00:	e1a00c30 	lsr	r0, r0, ip
    9b04:	e1800811 	orr	r0, r0, r1, lsl r8
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:997
    9b08:	e0a66001 	adc	r6, r6, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:998
    9b0c:	e1800931 	orr	r0, r0, r1, lsr r9
    9b10:	e1a01c31 	lsr	r1, r1, ip
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:999
    9b14:	e1a03c10 	lsl	r3, r0, ip
    9b18:	e1a0cc11 	lsl	ip, r1, ip
    9b1c:	e18cc910 	orr	ip, ip, r0, lsl r9
    9b20:	e18cc830 	orr	ip, ip, r0, lsr r8
    9b24:	e0555003 	subs	r5, r5, r3
    9b28:	e0c6600c 	sbc	r6, r6, ip
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1003
    9b2c:	e3570000 	cmp	r7, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1004
    9b30:	11c700f0 	strdne	r0, [r7]
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1006
    9b34:	e1a00005 	mov	r0, r5
    9b38:	e1a01006 	mov	r1, r6
    9b3c:	e8bd83f0 	pop	{r4, r5, r6, r7, r8, r9, pc}

Disassembly of section .rodata:

00009b40 <_ZL13Lock_Unlocked>:
    9b40:	00000000 	andeq	r0, r0, r0

00009b44 <_ZL11Lock_Locked>:
    9b44:	00000001 	andeq	r0, r0, r1

00009b48 <_ZL21MaxFSDriverNameLength>:
    9b48:	00000010 	andeq	r0, r0, r0, lsl r0

00009b4c <_ZL17MaxFilenameLength>:
    9b4c:	00000010 	andeq	r0, r0, r0, lsl r0

00009b50 <_ZL13MaxPathLength>:
    9b50:	00000080 	andeq	r0, r0, r0, lsl #1

00009b54 <_ZL18NoFilesystemDriver>:
    9b54:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009b58 <_ZL9NotifyAll>:
    9b58:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009b5c <_ZL24Max_Process_Opened_Files>:
    9b5c:	00000010 	andeq	r0, r0, r0, lsl r0

00009b60 <_ZL10Indefinite>:
    9b60:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009b64 <_ZL18Deadline_Unchanged>:
    9b64:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

00009b68 <_ZL14Invalid_Handle>:
    9b68:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009b6c <_ZN3halL18Default_Clock_RateE>:
    9b6c:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}

00009b70 <_ZN3halL15Peripheral_BaseE>:
    9b70:	20000000 	andcs	r0, r0, r0

00009b74 <_ZN3halL9GPIO_BaseE>:
    9b74:	20200000 	eorcs	r0, r0, r0

00009b78 <_ZN3halL14GPIO_Pin_CountE>:
    9b78:	00000036 	andeq	r0, r0, r6, lsr r0

00009b7c <_ZN3halL8AUX_BaseE>:
    9b7c:	20215000 	eorcs	r5, r1, r0

00009b80 <_ZN3halL25Interrupt_Controller_BaseE>:
    9b80:	2000b200 	andcs	fp, r0, r0, lsl #4

00009b84 <_ZN3halL10Timer_BaseE>:
    9b84:	2000b400 	andcs	fp, r0, r0, lsl #8

00009b88 <_ZN3halL17System_Timer_BaseE>:
    9b88:	20003000 	andcs	r3, r0, r0

00009b8c <_ZN3halL9TRNG_BaseE>:
    9b8c:	20104000 	andscs	r4, r0, r0

00009b90 <_ZN3halL9BSC0_BaseE>:
    9b90:	20205000 	eorcs	r5, r0, r0

00009b94 <_ZN3halL9BSC1_BaseE>:
    9b94:	20804000 	addcs	r4, r0, r0

00009b98 <_ZN3halL9BSC2_BaseE>:
    9b98:	20805000 	addcs	r5, r0, r0

00009b9c <_ZL11Invalid_Pin>:
    9b9c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
    9ba0:	3a564544 	bcc	159b0b8 <__bss_end+0x1591490>
    9ba4:	64676573 	strbtvs	r6, [r7], #-1395	; 0xfffffa8d
    9ba8:	00000000 	andeq	r0, r0, r0
    9bac:	3a564544 	bcc	159b0c4 <__bss_end+0x159149c>
    9bb0:	6f697067 	svcvs	0x00697067
    9bb4:	0000342f 	andeq	r3, r0, pc, lsr #8
    9bb8:	3a564544 	bcc	159b0d0 <__bss_end+0x15914a8>
    9bbc:	6f697067 	svcvs	0x00697067
    9bc0:	0037312f 	eorseq	r3, r7, pc, lsr #2

00009bc4 <_ZL13Lock_Unlocked>:
    9bc4:	00000000 	andeq	r0, r0, r0

00009bc8 <_ZL11Lock_Locked>:
    9bc8:	00000001 	andeq	r0, r0, r1

00009bcc <_ZL21MaxFSDriverNameLength>:
    9bcc:	00000010 	andeq	r0, r0, r0, lsl r0

00009bd0 <_ZL17MaxFilenameLength>:
    9bd0:	00000010 	andeq	r0, r0, r0, lsl r0

00009bd4 <_ZL13MaxPathLength>:
    9bd4:	00000080 	andeq	r0, r0, r0, lsl #1

00009bd8 <_ZL18NoFilesystemDriver>:
    9bd8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009bdc <_ZL9NotifyAll>:
    9bdc:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009be0 <_ZL24Max_Process_Opened_Files>:
    9be0:	00000010 	andeq	r0, r0, r0, lsl r0

00009be4 <_ZL10Indefinite>:
    9be4:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009be8 <_ZL18Deadline_Unchanged>:
    9be8:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

00009bec <_ZL14Invalid_Handle>:
    9bec:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009bf0 <_ZL16Pipe_File_Prefix>:
    9bf0:	3a535953 	bcc	14e0144 <__bss_end+0x14d651c>
    9bf4:	65706970 	ldrbvs	r6, [r0, #-2416]!	; 0xfffff690
    9bf8:	0000002f 	andeq	r0, r0, pc, lsr #32

00009bfc <_ZN12_GLOBAL__N_1L11CharConvArrE>:
    9bfc:	33323130 	teqcc	r2, #48, 2
    9c00:	37363534 			; <UNDEFINED> instruction: 0x37363534
    9c04:	42413938 	submi	r3, r1, #56, 18	; 0xe0000
    9c08:	46454443 	strbmi	r4, [r5], -r3, asr #8
	...

Disassembly of section .ARM.exidx:

00009c10 <__CTOR_LIST__-0x8>:
    9c10:	7ffffe10 	svcvc	0x00fffe10
    9c14:	00000001 	andeq	r0, r0, r1

Disassembly of section .bss:

00009c18 <__bss_start>:
	...

Disassembly of section .ARM.attributes:

00000000 <.ARM.attributes>:
   0:	00002e41 	andeq	r2, r0, r1, asr #28
   4:	61656100 	cmnvs	r5, r0, lsl #2
   8:	01006962 	tsteq	r0, r2, ror #18
   c:	00000024 	andeq	r0, r0, r4, lsr #32
  10:	4b5a3605 	blmi	168d82c <__bss_end+0x1683c04>
  14:	08070600 	stmdaeq	r7, {r9, sl}
  18:	0a010901 	beq	42424 <__bss_end+0x387fc>
  1c:	14041202 	strne	r1, [r4], #-514	; 0xfffffdfe
  20:	17011501 	strne	r1, [r1, -r1, lsl #10]
  24:	1a011803 	bne	46038 <__bss_end+0x3c410>
  28:	22011c01 	andcs	r1, r1, #256	; 0x100
  2c:	Address 0x000000000000002c is out of bounds.


Disassembly of section .comment:

00000000 <.comment>:
   0:	3a434347 	bcc	10d0d24 <__bss_end+0x10c70fc>
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
      e0:	db010100 	blle	404e8 <__bss_end+0x368c0>
      e4:	03000000 	movweq	r0, #0
      e8:	00005200 	andeq	r5, r0, r0, lsl #4
      ec:	fb010200 	blx	408f6 <__bss_end+0x36cce>
      f0:	01000d0e 	tsteq	r0, lr, lsl #26
      f4:	00010101 	andeq	r0, r1, r1, lsl #2
      f8:	00010000 	andeq	r0, r1, r0
      fc:	682f0100 	stmdavs	pc!, {r8}	; <UNPREDICTABLE>
     100:	2f656d6f 	svccs	0x00656d6f
     104:	66657274 			; <UNDEFINED> instruction: 0x66657274
     108:	732f6c69 			; <UNDEFINED> instruction: 0x732f6c69
     10c:	732f6d65 			; <UNDEFINED> instruction: 0x732f6d65
     110:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
     114:	752f7365 	strvc	r7, [pc, #-869]!	; fffffdb7 <__bss_end+0xffff618f>
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
     14c:	0a05830b 	beq	160d80 <__bss_end+0x157158>
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
     178:	4a030402 	bmi	c1188 <__bss_end+0xb7560>
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
     1ac:	4a020402 	bmi	811bc <__bss_end+0x77594>
     1b0:	02000205 	andeq	r0, r0, #1342177280	; 0x50000000
     1b4:	052d0204 	streq	r0, [sp, #-516]!	; 0xfffffdfc
     1b8:	01058509 	tsteq	r5, r9, lsl #10
     1bc:	000a022f 	andeq	r0, sl, pc, lsr #4
     1c0:	023d0101 	eorseq	r0, sp, #1073741824	; 0x40000000
     1c4:	00030000 	andeq	r0, r3, r0
     1c8:	000001b5 			; <UNDEFINED> instruction: 0x000001b5
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
     200:	6e756f63 	cdpvs	15, 7, cr6, cr5, cr3, {3}
     204:	5f726574 	svcpl	0x00726574
     208:	6b736174 	blvs	1cd87e0 <__bss_end+0x1ccebb8>
     20c:	6f682f00 	svcvs	0x00682f00
     210:	742f656d 	strtvc	r6, [pc], #-1389	; 218 <shift+0x218>
     214:	69666572 	stmdbvs	r6!, {r1, r4, r5, r6, r8, sl, sp, lr}^
     218:	65732f6c 	ldrbvs	r2, [r3, #-3948]!	; 0xfffff094
     21c:	6f732f6d 	svcvs	0x00732f6d
     220:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
     224:	73752f73 	cmnvc	r5, #460	; 0x1cc
     228:	70737265 	rsbsvc	r7, r3, r5, ror #4
     22c:	2f656361 	svccs	0x00656361
     230:	6b2f2e2e 	blvs	bcbaf0 <__bss_end+0xbc1ec8>
     234:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
     238:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
     23c:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
     240:	72702f65 	rsbsvc	r2, r0, #404	; 0x194
     244:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     248:	682f0073 	stmdavs	pc!, {r0, r1, r4, r5, r6}	; <UNPREDICTABLE>
     24c:	2f656d6f 	svccs	0x00656d6f
     250:	66657274 			; <UNDEFINED> instruction: 0x66657274
     254:	732f6c69 			; <UNDEFINED> instruction: 0x732f6c69
     258:	732f6d65 			; <UNDEFINED> instruction: 0x732f6d65
     25c:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
     260:	752f7365 	strvc	r7, [pc, #-869]!	; ffffff03 <__bss_end+0xffff62db>
     264:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
     268:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
     26c:	2f2e2e2f 	svccs	0x002e2e2f
     270:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
     274:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
     278:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
     27c:	662f6564 	strtvs	r6, [pc], -r4, ror #10
     280:	682f0073 	stmdavs	pc!, {r0, r1, r4, r5, r6}	; <UNPREDICTABLE>
     284:	2f656d6f 	svccs	0x00656d6f
     288:	66657274 			; <UNDEFINED> instruction: 0x66657274
     28c:	732f6c69 			; <UNDEFINED> instruction: 0x732f6c69
     290:	732f6d65 			; <UNDEFINED> instruction: 0x732f6d65
     294:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
     298:	752f7365 	strvc	r7, [pc, #-869]!	; ffffff3b <__bss_end+0xffff6313>
     29c:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
     2a0:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
     2a4:	2f2e2e2f 	svccs	0x002e2e2f
     2a8:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
     2ac:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
     2b0:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
     2b4:	622f6564 	eorvs	r6, pc, #100, 10	; 0x19000000
     2b8:	6472616f 	ldrbtvs	r6, [r2], #-367	; 0xfffffe91
     2bc:	6970722f 	ldmdbvs	r0!, {r0, r1, r2, r3, r5, r9, ip, sp, lr}^
     2c0:	61682f30 	cmnvs	r8, r0, lsr pc
     2c4:	682f006c 	stmdavs	pc!, {r2, r3, r5, r6}	; <UNPREDICTABLE>
     2c8:	2f656d6f 	svccs	0x00656d6f
     2cc:	66657274 			; <UNDEFINED> instruction: 0x66657274
     2d0:	732f6c69 			; <UNDEFINED> instruction: 0x732f6c69
     2d4:	732f6d65 			; <UNDEFINED> instruction: 0x732f6d65
     2d8:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
     2dc:	752f7365 	strvc	r7, [pc, #-869]!	; ffffff7f <__bss_end+0xffff6357>
     2e0:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
     2e4:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
     2e8:	2f2e2e2f 	svccs	0x002e2e2f
     2ec:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
     2f0:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
     2f4:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
     2f8:	642f6564 	strtvs	r6, [pc], #-1380	; 300 <shift+0x300>
     2fc:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
     300:	00007372 	andeq	r7, r0, r2, ror r3
     304:	6e69616d 	powvsez	f6, f1, #5.0
     308:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
     30c:	00000100 	andeq	r0, r0, r0, lsl #2
     310:	2e697773 	mcrcs	7, 3, r7, cr9, cr3, {3}
     314:	00020068 	andeq	r0, r2, r8, rrx
     318:	69707300 	ldmdbvs	r0!, {r8, r9, ip, sp, lr}^
     31c:	636f6c6e 	cmnvs	pc, #28160	; 0x6e00
     320:	00682e6b 	rsbeq	r2, r8, fp, ror #28
     324:	66000002 	strvs	r0, [r0], -r2
     328:	73656c69 	cmnvc	r5, #26880	; 0x6900
     32c:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     330:	00682e6d 	rsbeq	r2, r8, sp, ror #28
     334:	70000003 	andvc	r0, r0, r3
     338:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     33c:	682e7373 	stmdavs	lr!, {r0, r1, r4, r5, r6, r8, r9, ip, sp, lr}
     340:	00000200 	andeq	r0, r0, r0, lsl #4
     344:	636f7270 	cmnvs	pc, #112, 4
     348:	5f737365 	svcpl	0x00737365
     34c:	616e616d 	cmnvs	lr, sp, ror #2
     350:	2e726567 	cdpcs	5, 7, cr6, cr2, cr7, {3}
     354:	00020068 	andeq	r0, r2, r8, rrx
     358:	72657000 	rsbvc	r7, r5, #0
     35c:	65687069 	strbvs	r7, [r8, #-105]!	; 0xffffff97
     360:	736c6172 	cmnvc	ip, #-2147483620	; 0x8000001c
     364:	0400682e 	streq	r6, [r0], #-2094	; 0xfffff7d2
     368:	70670000 	rsbvc	r0, r7, r0
     36c:	682e6f69 	stmdavs	lr!, {r0, r3, r5, r6, r8, r9, sl, fp, sp, lr}
     370:	00000500 	andeq	r0, r0, r0, lsl #10
     374:	64746e69 	ldrbtvs	r6, [r4], #-3689	; 0xfffff197
     378:	682e6665 	stmdavs	lr!, {r0, r2, r5, r6, r9, sl, sp, lr}
     37c:	00000400 	andeq	r0, r0, r0, lsl #8
     380:	00010500 	andeq	r0, r1, r0, lsl #10
     384:	822c0205 	eorhi	r0, ip, #1342177280	; 0x50000000
     388:	10030000 	andne	r0, r3, r0
     38c:	9f1e0501 	svcls	0x001e0501
     390:	0f058383 	svceq	0x00058383
     394:	4b070584 	blmi	1c19ac <__bss_end+0x1b7d84>
     398:	4c13054b 	cfldr32mi	mvfx0, [r3], {75}	; 0x4b
     39c:	01040200 	mrseq	r0, R12_usr
     3a0:	02006606 	andeq	r6, r0, #6291456	; 0x600000
     3a4:	004a0204 	subeq	r0, sl, r4, lsl #4
     3a8:	2e040402 	cdpcs	4, 0, cr0, cr4, cr2, {0}
     3ac:	4e060805 	cdpmi	8, 0, cr0, cr6, cr5, {0}
     3b0:	054c0705 	strbeq	r0, [ip, #-1797]	; 0xfffff8fb
     3b4:	0d059f14 	stceq	15, cr9, [r5, #-80]	; 0xffffffb0
     3b8:	8407052e 	strhi	r0, [r7], #-1326	; 0xfffffad2
     3bc:	059f0f05 	ldreq	r0, [pc, #3845]	; 12c9 <shift+0x12c9>
     3c0:	03052e08 	movweq	r2, #24072	; 0x5e08
     3c4:	670b0584 	strvs	r0, [fp, -r4, lsl #11]
     3c8:	68180584 	ldmdavs	r8, {r2, r7, r8, sl}
     3cc:	20080d05 	andcs	r0, r8, r5, lsl #26
     3d0:	05660705 	strbeq	r0, [r6, #-1797]!	; 0xfffff8fb
     3d4:	00a02f08 	adceq	r2, r0, r8, lsl #30
     3d8:	06010402 	streq	r0, [r1], -r2, lsl #8
     3dc:	04020066 	streq	r0, [r2], #-102	; 0xffffff9a
     3e0:	02004a02 	andeq	r4, r0, #8192	; 0x2000
     3e4:	002e0404 	eoreq	r0, lr, r4, lsl #8
     3e8:	66050402 	strvs	r0, [r5], -r2, lsl #8
     3ec:	06040200 	streq	r0, [r4], -r0, lsl #4
     3f0:	0402004a 	streq	r0, [r2], #-74	; 0xffffffb6
     3f4:	02052e08 	andeq	r2, r5, #8, 28	; 0x80
     3f8:	08040200 	stmdaeq	r4, {r9}
     3fc:	0a026706 	beq	9a01c <__bss_end+0x903f4>
     400:	18010100 	stmdane	r1, {r8}
     404:	03000002 	movweq	r0, #2
     408:	00012d00 	andeq	r2, r1, r0, lsl #26
     40c:	fb010200 	blx	40c16 <__bss_end+0x36fee>
     410:	01000d0e 	tsteq	r0, lr, lsl #26
     414:	00010101 	andeq	r0, r1, r1, lsl #2
     418:	00010000 	andeq	r0, r1, r0
     41c:	682f0100 	stmdavs	pc!, {r8}	; <UNPREDICTABLE>
     420:	2f656d6f 	svccs	0x00656d6f
     424:	66657274 			; <UNDEFINED> instruction: 0x66657274
     428:	732f6c69 			; <UNDEFINED> instruction: 0x732f6c69
     42c:	732f6d65 			; <UNDEFINED> instruction: 0x732f6d65
     430:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
     434:	732f7365 			; <UNDEFINED> instruction: 0x732f7365
     438:	696c6474 	stmdbvs	ip!, {r2, r4, r5, r6, sl, sp, lr}^
     43c:	72732f62 	rsbsvc	r2, r3, #392	; 0x188
     440:	682f0063 	stmdavs	pc!, {r0, r1, r5, r6}	; <UNPREDICTABLE>
     444:	2f656d6f 	svccs	0x00656d6f
     448:	66657274 			; <UNDEFINED> instruction: 0x66657274
     44c:	732f6c69 			; <UNDEFINED> instruction: 0x732f6c69
     450:	732f6d65 			; <UNDEFINED> instruction: 0x732f6d65
     454:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
     458:	6b2f7365 	blvs	bdd1f4 <__bss_end+0xbd35cc>
     45c:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
     460:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
     464:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
     468:	72702f65 	rsbsvc	r2, r0, #404	; 0x194
     46c:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     470:	682f0073 	stmdavs	pc!, {r0, r1, r4, r5, r6}	; <UNPREDICTABLE>
     474:	2f656d6f 	svccs	0x00656d6f
     478:	66657274 			; <UNDEFINED> instruction: 0x66657274
     47c:	732f6c69 			; <UNDEFINED> instruction: 0x732f6c69
     480:	732f6d65 			; <UNDEFINED> instruction: 0x732f6d65
     484:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
     488:	6b2f7365 	blvs	bdd224 <__bss_end+0xbd35fc>
     48c:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
     490:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
     494:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
     498:	73662f65 	cmnvc	r6, #404	; 0x194
     49c:	6f682f00 	svcvs	0x00682f00
     4a0:	742f656d 	strtvc	r6, [pc], #-1389	; 4a8 <shift+0x4a8>
     4a4:	69666572 	stmdbvs	r6!, {r1, r4, r5, r6, r8, sl, sp, lr}^
     4a8:	65732f6c 	ldrbvs	r2, [r3, #-3948]!	; 0xfffff094
     4ac:	6f732f6d 	svcvs	0x00732f6d
     4b0:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
     4b4:	656b2f73 	strbvs	r2, [fp, #-3955]!	; 0xfffff08d
     4b8:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
     4bc:	636e692f 	cmnvs	lr, #770048	; 0xbc000
     4c0:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
     4c4:	616f622f 	cmnvs	pc, pc, lsr #4
     4c8:	722f6472 	eorvc	r6, pc, #1912602624	; 0x72000000
     4cc:	2f306970 	svccs	0x00306970
     4d0:	006c6168 	rsbeq	r6, ip, r8, ror #2
     4d4:	64747300 	ldrbtvs	r7, [r4], #-768	; 0xfffffd00
     4d8:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
     4dc:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
     4e0:	00000100 	andeq	r0, r0, r0, lsl #2
     4e4:	2e697773 	mcrcs	7, 3, r7, cr9, cr3, {3}
     4e8:	00020068 	andeq	r0, r2, r8, rrx
     4ec:	69707300 	ldmdbvs	r0!, {r8, r9, ip, sp, lr}^
     4f0:	636f6c6e 	cmnvs	pc, #28160	; 0x6e00
     4f4:	00682e6b 	rsbeq	r2, r8, fp, ror #28
     4f8:	66000002 	strvs	r0, [r0], -r2
     4fc:	73656c69 	cmnvc	r5, #26880	; 0x6900
     500:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     504:	00682e6d 	rsbeq	r2, r8, sp, ror #28
     508:	70000003 	andvc	r0, r0, r3
     50c:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     510:	682e7373 	stmdavs	lr!, {r0, r1, r4, r5, r6, r8, r9, ip, sp, lr}
     514:	00000200 	andeq	r0, r0, r0, lsl #4
     518:	636f7270 	cmnvs	pc, #112, 4
     51c:	5f737365 	svcpl	0x00737365
     520:	616e616d 	cmnvs	lr, sp, ror #2
     524:	2e726567 	cdpcs	5, 7, cr6, cr2, cr7, {3}
     528:	00020068 	andeq	r0, r2, r8, rrx
     52c:	746e6900 	strbtvc	r6, [lr], #-2304	; 0xfffff700
     530:	2e666564 	cdpcs	5, 6, cr6, cr6, cr4, {3}
     534:	00040068 	andeq	r0, r4, r8, rrx
     538:	01050000 	mrseq	r0, (UNDEF: 5)
     53c:	c0020500 	andgt	r0, r2, r0, lsl #10
     540:	16000083 	strne	r0, [r0], -r3, lsl #1
     544:	2f690505 	svccs	0x00690505
     548:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
     54c:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
     550:	054b8305 	strbeq	r8, [fp, #-773]	; 0xfffffcfb
     554:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
     558:	01054b05 	tsteq	r5, r5, lsl #22
     55c:	0505852f 	streq	r8, [r5, #-1327]	; 0xfffffad1
     560:	2f4b4ba1 	svccs	0x004b4ba1
     564:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
     568:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
     56c:	4b4bbd05 	blmi	12ef988 <__bss_end+0x12e5d60>
     570:	0c052f4b 	stceq	15, cr2, [r5], {75}	; 0x4b
     574:	2f01054c 	svccs	0x0001054c
     578:	bd050586 	cfstr32lt	mvfx0, [r5, #-536]	; 0xfffffde8
     57c:	2f4b4b4b 	svccs	0x004b4b4b
     580:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
     584:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
     588:	054b8305 	strbeq	r8, [fp, #-773]	; 0xfffffcfb
     58c:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
     590:	4b4bbd05 	blmi	12ef9ac <__bss_end+0x12e5d84>
     594:	0c052f4b 	stceq	15, cr2, [r5], {75}	; 0x4b
     598:	2f01054c 	svccs	0x0001054c
     59c:	a1050585 	smlabbge	r5, r5, r5, r0
     5a0:	052f4b4b 	streq	r4, [pc, #-2891]!	; fffffa5d <__bss_end+0xffff5e35>
     5a4:	01054c0c 	tsteq	r5, ip, lsl #24
     5a8:	0505852f 	streq	r8, [r5, #-1327]	; 0xfffffad1
     5ac:	4b4b4bbd 	blmi	12d34a8 <__bss_end+0x12c9880>
     5b0:	4c0c052f 	cfstr32mi	mvfx0, [ip], {47}	; 0x2f
     5b4:	852f0105 	strhi	r0, [pc, #-261]!	; 4b7 <shift+0x4b7>
     5b8:	4ba10505 	blmi	fe8419d4 <__bss_end+0xfe837dac>
     5bc:	0c052f4b 	stceq	15, cr2, [r5], {75}	; 0x4b
     5c0:	9f01054c 	svcls	0x0001054c
     5c4:	67200585 	strvs	r0, [r0, -r5, lsl #11]!
     5c8:	4b4d0505 	blmi	13419e4 <__bss_end+0x1337dbc>
     5cc:	300c054b 	andcc	r0, ip, fp, asr #10
     5d0:	852f0105 	strhi	r0, [pc, #-261]!	; 4d3 <shift+0x4d3>
     5d4:	05672005 	strbeq	r2, [r7, #-5]!
     5d8:	4b4b4d05 	blmi	12d39f4 <__bss_end+0x12c9dcc>
     5dc:	05300c05 	ldreq	r0, [r0, #-3077]!	; 0xfffff3fb
     5e0:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
     5e4:	05058320 	streq	r8, [r5, #-800]	; 0xfffffce0
     5e8:	054b4b4c 	strbeq	r4, [fp, #-2892]	; 0xfffff4b4
     5ec:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
     5f0:	05056720 	streq	r6, [r5, #-1824]	; 0xfffff8e0
     5f4:	054b4b4d 	strbeq	r4, [fp, #-2893]	; 0xfffff4b3
     5f8:	0105300c 	tsteq	r5, ip
     5fc:	0c05872f 	stceq	7, cr8, [r5], {47}	; 0x2f
     600:	31059fa0 	smlatbcc	r5, r0, pc, r9	; <UNPREDICTABLE>
     604:	662905bc 			; <UNDEFINED> instruction: 0x662905bc
     608:	052e3605 	streq	r3, [lr, #-1541]!	; 0xfffff9fb
     60c:	1305300f 	movwne	r3, #20495	; 0x500f
     610:	84090566 	strhi	r0, [r9], #-1382	; 0xfffffa9a
     614:	05d81005 	ldrbeq	r1, [r8, #5]
     618:	08029f01 	stmdaeq	r2, {r0, r8, r9, sl, fp, ip, pc}
     61c:	0d010100 	stfeqs	f0, [r1, #-0]
     620:	03000005 	movweq	r0, #5
     624:	00004800 	andeq	r4, r0, r0, lsl #16
     628:	fb010200 	blx	40e32 <__bss_end+0x3720a>
     62c:	01000d0e 	tsteq	r0, lr, lsl #26
     630:	00010101 	andeq	r0, r1, r1, lsl #2
     634:	00010000 	andeq	r0, r1, r0
     638:	682f0100 	stmdavs	pc!, {r8}	; <UNPREDICTABLE>
     63c:	2f656d6f 	svccs	0x00656d6f
     640:	66657274 			; <UNDEFINED> instruction: 0x66657274
     644:	732f6c69 			; <UNDEFINED> instruction: 0x732f6c69
     648:	732f6d65 			; <UNDEFINED> instruction: 0x732f6d65
     64c:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
     650:	732f7365 			; <UNDEFINED> instruction: 0x732f7365
     654:	696c6474 	stmdbvs	ip!, {r2, r4, r5, r6, sl, sp, lr}^
     658:	72732f62 	rsbsvc	r2, r3, #392	; 0x188
     65c:	73000063 	movwvc	r0, #99	; 0x63
     660:	74736474 	ldrbtvc	r6, [r3], #-1140	; 0xfffffb8c
     664:	676e6972 			; <UNDEFINED> instruction: 0x676e6972
     668:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
     66c:	00000100 	andeq	r0, r0, r0, lsl #2
     670:	00010500 	andeq	r0, r1, r0, lsl #10
     674:	88200205 	stmdahi	r0!, {r0, r2, r9}
     678:	051a0000 	ldreq	r0, [sl, #-0]
     67c:	054bbb09 	strbeq	fp, [fp, #-2825]	; 0xfffff4f7
     680:	1b054c0f 	blne	1536c4 <__bss_end+0x149a9c>
     684:	2e210568 	cfsh64cs	mvdx0, mvdx1, #56
     688:	059e0a05 	ldreq	r0, [lr, #2565]	; 0xa05
     68c:	27052e0b 	strcs	r2, [r5, -fp, lsl #28]
     690:	4a0d054a 	bmi	341bc0 <__bss_end+0x337f98>
     694:	052f0905 	streq	r0, [pc, #-2309]!	; fffffd97 <__bss_end+0xffff616f>
     698:	0205bb04 	andeq	fp, r5, #4, 22	; 0x1000
     69c:	35050562 	strcc	r0, [r5, #-1378]	; 0xfffffa9e
     6a0:	05681005 	strbeq	r1, [r8, #-5]!
     6a4:	22052e11 	andcs	r2, r5, #272	; 0x110
     6a8:	2e13054a 	cfmac32cs	mvfx0, mvfx3, mvfx10
     6ac:	052f0a05 	streq	r0, [pc, #-2565]!	; fffffcaf <__bss_end+0xffff6087>
     6b0:	0a056909 	beq	15aadc <__bss_end+0x150eb4>
     6b4:	4a0c052e 	bmi	301b74 <__bss_end+0x2f7f4c>
     6b8:	054b0305 	strbeq	r0, [fp, #-773]	; 0xfffffcfb
     6bc:	04020010 	streq	r0, [r2], #-16
     6c0:	0c056802 	stceq	8, cr6, [r5], {2}
     6c4:	02040200 	andeq	r0, r4, #0, 4
     6c8:	0015059e 	mulseq	r5, lr, r5
     6cc:	68010402 	stmdavs	r1, {r1, sl}
     6d0:	02001805 	andeq	r1, r0, #327680	; 0x50000
     6d4:	05820104 	streq	r0, [r2, #260]	; 0x104
     6d8:	04020008 	streq	r0, [r2], #-8
     6dc:	1a054a01 	bne	152ee8 <__bss_end+0x1492c0>
     6e0:	01040200 	mrseq	r0, R12_usr
     6e4:	001b054b 	andseq	r0, fp, fp, asr #10
     6e8:	2e010402 	cdpcs	4, 0, cr0, cr1, cr2, {0}
     6ec:	02000c05 	andeq	r0, r0, #1280	; 0x500
     6f0:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
     6f4:	0402000f 	streq	r0, [r2], #-15
     6f8:	1b058201 	blne	160f04 <__bss_end+0x1572dc>
     6fc:	01040200 	mrseq	r0, R12_usr
     700:	0011054a 	andseq	r0, r1, sl, asr #10
     704:	2e010402 	cdpcs	4, 0, cr0, cr1, cr2, {0}
     708:	02000a05 	andeq	r0, r0, #20480	; 0x5000
     70c:	052f0104 	streq	r0, [pc, #-260]!	; 610 <shift+0x610>
     710:	0402000b 	streq	r0, [r2], #-11
     714:	0d052e01 	stceq	14, cr2, [r5, #-4]
     718:	01040200 	mrseq	r0, R12_usr
     71c:	0002054a 	andeq	r0, r2, sl, asr #10
     720:	46010402 	strmi	r0, [r1], -r2, lsl #8
     724:	85890105 	strhi	r0, [r9, #261]	; 0x105
     728:	05830e05 	streq	r0, [r3, #3589]	; 0xe05
     72c:	05056616 	streq	r6, [r5, #-1558]	; 0xfffff9ea
     730:	4b100582 	blmi	401d40 <__bss_end+0x3f8118>
     734:	054a1905 	strbeq	r1, [sl, #-2309]	; 0xfffff6fb
     738:	09054b06 	stmdbeq	r5, {r1, r2, r8, r9, fp, lr}
     73c:	4a10054c 	bmi	401c74 <__bss_end+0x3f804c>
     740:	054c0a05 	strbeq	r0, [ip, #-2565]	; 0xfffff5fb
     744:	0305bb07 	movweq	fp, #23303	; 0x5b07
     748:	0017054a 	andseq	r0, r7, sl, asr #10
     74c:	4a010402 	bmi	4175c <__bss_end+0x37b34>
     750:	02001405 	andeq	r1, r0, #83886080	; 0x5000000
     754:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
     758:	14054d0d 	strne	r4, [r5], #-3341	; 0xfffff2f3
     75c:	2e0a054a 	cfsh32cs	mvfx0, mvfx10, #42
     760:	05680805 	strbeq	r0, [r8, #-2053]!	; 0xfffff7fb
     764:	66780302 	ldrbtvs	r0, [r8], -r2, lsl #6
     768:	0b030905 	bleq	c2b84 <__bss_end+0xb8f5c>
     76c:	2f01052e 	svccs	0x0001052e
     770:	056a2705 	strbeq	r2, [sl, #-1797]!	; 0xfffff8fb
     774:	054b840a 	strbeq	r8, [fp, #-1034]	; 0xfffffbf6
     778:	12054b0b 	andne	r4, r5, #11264	; 0x2c00
     77c:	4b0e054a 	blmi	381cac <__bss_end+0x378084>
     780:	05670905 	strbeq	r0, [r7, #-2309]!	; 0xfffff6fb
     784:	04020018 	streq	r0, [r2], #-24	; 0xffffffe8
     788:	15056601 	strne	r6, [r5, #-1537]	; 0xfffff9ff
     78c:	01040200 	mrseq	r0, R12_usr
     790:	00110566 	andseq	r0, r1, r6, ror #10
     794:	4b020402 	blmi	817a4 <__bss_end+0x77b7c>
     798:	02001a05 	andeq	r1, r0, #20480	; 0x5000
     79c:	054b0204 	strbeq	r0, [fp, #-516]	; 0xfffffdfc
     7a0:	04020012 	streq	r0, [r2], #-18	; 0xffffffee
     7a4:	0d054b02 	vstreq	d4, [r5, #-8]
     7a8:	02040200 	andeq	r0, r4, #0, 4
     7ac:	31090567 	tstcc	r9, r7, ror #10
     7b0:	02001405 	andeq	r1, r0, #83886080	; 0x5000000
     7b4:	05660204 	strbeq	r0, [r6, #-516]!	; 0xfffffdfc
     7b8:	04020026 	streq	r0, [r2], #-38	; 0xffffffda
     7bc:	09056603 	stmdbeq	r5, {r0, r1, r9, sl, sp, lr}
     7c0:	671a054c 	ldrvs	r0, [sl, -ip, asr #10]
     7c4:	054b0a05 	strbeq	r0, [fp, #-2565]	; 0xfffff5fb
     7c8:	66730305 	ldrbtvs	r0, [r3], -r5, lsl #6
     7cc:	052e0f03 	streq	r0, [lr, #-3843]!	; 0xfffff0fd
     7d0:	0402001c 	streq	r0, [r2], #-28	; 0xffffffe4
     7d4:	0f056601 	svceq	0x00056601
     7d8:	0402004c 	streq	r0, [r2], #-76	; 0xffffffb4
     7dc:	05660601 	strbeq	r0, [r6, #-1537]!	; 0xfffff9ff
     7e0:	04020013 	streq	r0, [r2], #-19	; 0xffffffed
     7e4:	052e0601 	streq	r0, [lr, #-1537]!	; 0xfffff9ff
     7e8:	0402000f 	streq	r0, [r2], #-15
     7ec:	13052e02 	movwne	r2, #24066	; 0x5e02
     7f0:	3001052e 	andcc	r0, r1, lr, lsr #10
     7f4:	05861e05 	streq	r1, [r6, #3589]	; 0xe05
     7f8:	6867830c 	stmdavs	r7!, {r2, r3, r8, r9, pc}^
     7fc:	4b670905 	blmi	19c2c18 <__bss_end+0x19b8ff0>
     800:	054b0a05 	strbeq	r0, [fp, #-2565]	; 0xfffff5fb
     804:	12054c0b 	andne	r4, r5, #2816	; 0xb00
     808:	4b0d054a 	blmi	341d38 <__bss_end+0x338110>
     80c:	054a0905 	strbeq	r0, [sl, #-2309]	; 0xfffff6fb
     810:	0402001b 	streq	r0, [r2], #-27	; 0xffffffe5
     814:	12054b01 	andne	r4, r5, #1024	; 0x400
     818:	01040200 	mrseq	r0, R12_usr
     81c:	000d054b 	andeq	r0, sp, fp, asr #10
     820:	67010402 	strvs	r0, [r1, -r2, lsl #8]
     824:	05301205 	ldreq	r1, [r0, #-517]!	; 0xfffffdfb
     828:	22054a0e 	andcs	r4, r5, #57344	; 0xe000
     82c:	01040200 	mrseq	r0, R12_usr
     830:	001f054a 	andseq	r0, pc, sl, asr #10
     834:	4a010402 	bmi	41844 <__bss_end+0x37c1c>
     838:	054b1605 	strbeq	r1, [fp, #-1541]	; 0xfffff9fb
     83c:	10054a1d 	andne	r4, r5, sp, lsl sl
     840:	6709052e 	strvs	r0, [r9, -lr, lsr #10]
     844:	05671305 	strbeq	r1, [r7, #-773]!	; 0xfffffcfb
     848:	1405d723 	strne	sp, [r5], #-1827	; 0xfffff8dd
     84c:	851d059e 	ldrhi	r0, [sp, #-1438]	; 0xfffffa62
     850:	05661405 	strbeq	r1, [r6, #-1029]!	; 0xfffffbfb
     854:	0505680e 	streq	r6, [r5, #-2062]	; 0xfffff7f2
     858:	05667103 	strbeq	r7, [r6, #-259]!	; 0xfffffefd
     85c:	2e11030c 	cdpcs	3, 1, cr0, cr1, cr12, {0}
     860:	084b0105 	stmdaeq	fp, {r0, r2, r8}^
     864:	bd090522 	cfstr32lt	mvfx0, [r9, #-136]	; 0xffffff78
     868:	02001605 	andeq	r1, r0, #5242880	; 0x500000
     86c:	054a0404 	strbeq	r0, [sl, #-1028]	; 0xfffffbfc
     870:	0402001d 	streq	r0, [r2], #-29	; 0xffffffe3
     874:	1e058202 	cdpne	2, 0, cr8, cr5, cr2, {0}
     878:	02040200 	andeq	r0, r4, #0, 4
     87c:	0016052e 	andseq	r0, r6, lr, lsr #10
     880:	66020402 	strvs	r0, [r2], -r2, lsl #8
     884:	02001105 	andeq	r1, r0, #1073741825	; 0x40000001
     888:	054b0304 	strbeq	r0, [fp, #-772]	; 0xfffffcfc
     88c:	04020012 	streq	r0, [r2], #-18	; 0xffffffee
     890:	08052e03 	stmdaeq	r5, {r0, r1, r9, sl, fp, sp}
     894:	03040200 	movweq	r0, #16896	; 0x4200
     898:	0009054a 	andeq	r0, r9, sl, asr #10
     89c:	2e030402 	cdpcs	4, 0, cr0, cr3, cr2, {0}
     8a0:	02001205 	andeq	r1, r0, #1342177280	; 0x50000000
     8a4:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
     8a8:	0402000b 	streq	r0, [r2], #-11
     8ac:	02052e03 	andeq	r2, r5, #3, 28	; 0x30
     8b0:	03040200 	movweq	r0, #16896	; 0x4200
     8b4:	000b052d 	andeq	r0, fp, sp, lsr #10
     8b8:	84020402 	strhi	r0, [r2], #-1026	; 0xfffffbfe
     8bc:	02000805 	andeq	r0, r0, #327680	; 0x50000
     8c0:	05830104 	streq	r0, [r3, #260]	; 0x104
     8c4:	04020009 	streq	r0, [r2], #-9
     8c8:	0b052e01 	bleq	14c0d4 <__bss_end+0x1424ac>
     8cc:	01040200 	mrseq	r0, R12_usr
     8d0:	0002054a 	andeq	r0, r2, sl, asr #10
     8d4:	49010402 	stmdbmi	r1, {r1, sl}
     8d8:	05850b05 	streq	r0, [r5, #2821]	; 0xb05
     8dc:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
     8e0:	1105bc0e 	tstne	r5, lr, lsl #24
     8e4:	bc200566 	cfstr32lt	mvfx0, [r0], #-408	; 0xfffffe68
     8e8:	05660b05 	strbeq	r0, [r6, #-2821]!	; 0xfffff4fb
     8ec:	0a054b1f 	beq	153570 <__bss_end+0x149948>
     8f0:	4b080566 	blmi	201e90 <__bss_end+0x1f8268>
     8f4:	05831105 	streq	r1, [r3, #261]	; 0x105
     8f8:	08052e16 	stmdaeq	r5, {r1, r2, r4, r9, sl, fp, sp}
     8fc:	67110567 	ldrvs	r0, [r1, -r7, ror #10]
     900:	054d0b05 	strbeq	r0, [sp, #-2821]	; 0xfffff4fb
     904:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
     908:	0b058306 	bleq	161528 <__bss_end+0x157900>
     90c:	2e0c054c 	cfsh32cs	mvfx0, mvfx12, #44
     910:	05660e05 	strbeq	r0, [r6, #-3589]!	; 0xfffff1fb
     914:	02054b04 	andeq	r4, r5, #4, 22	; 0x1000
     918:	31090565 	tstcc	r9, r5, ror #10
     91c:	052f0105 	streq	r0, [pc, #-261]!	; 81f <shift+0x81f>
     920:	1305852a 	movwne	r8, #21802	; 0x552a
     924:	0905679f 	stmdbeq	r5, {r0, r1, r2, r3, r4, r7, r8, r9, sl, sp, lr}
     928:	4b0d0567 	blmi	341ecc <__bss_end+0x3382a4>
     92c:	02001505 	andeq	r1, r0, #20971520	; 0x1400000
     930:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
     934:	04020019 	streq	r0, [r2], #-25	; 0xffffffe7
     938:	1a058302 	bne	161548 <__bss_end+0x157920>
     93c:	02040200 	andeq	r0, r4, #0, 4
     940:	000f052e 	andeq	r0, pc, lr, lsr #10
     944:	4a020402 	bmi	81954 <__bss_end+0x77d2c>
     948:	02001105 	andeq	r1, r0, #1073741825	; 0x40000001
     94c:	05820204 	streq	r0, [r2, #516]	; 0x204
     950:	0402001a 	streq	r0, [r2], #-26	; 0xffffffe6
     954:	13054a02 	movwne	r4, #23042	; 0x5a02
     958:	02040200 	andeq	r0, r4, #0, 4
     95c:	0005052e 	andeq	r0, r5, lr, lsr #10
     960:	2d020402 	cfstrscs	mvf0, [r2, #-8]
     964:	05840a05 	streq	r0, [r4, #2565]	; 0xa05
     968:	0d052e0b 	stceq	14, cr2, [r5, #-44]	; 0xffffffd4
     96c:	4b0c054a 	blmi	301e9c <__bss_end+0x2f8274>
     970:	05300105 	ldreq	r0, [r0, #-261]!	; 0xfffffefb
     974:	09056734 	stmdbeq	r5, {r2, r4, r5, r8, r9, sl, sp, lr}
     978:	4c1305bb 	cfldr32mi	mvfx0, [r3], {187}	; 0xbb
     97c:	05680505 	strbeq	r0, [r8, #-1285]!	; 0xfffffafb
     980:	04020019 	streq	r0, [r2], #-25	; 0xffffffe7
     984:	0d058201 	sfmeq	f0, 1, [r5, #-4]
     988:	0015054c 	andseq	r0, r5, ip, asr #10
     98c:	4a010402 	bmi	4199c <__bss_end+0x37d74>
     990:	05831005 	streq	r1, [r3, #5]
     994:	09052e11 	stmdbeq	r5, {r0, r4, r9, sl, fp, sp}
     998:	00190566 	andseq	r0, r9, r6, ror #10
     99c:	4b020402 	blmi	819ac <__bss_end+0x77d84>
     9a0:	02001a05 	andeq	r1, r0, #20480	; 0x5000
     9a4:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
     9a8:	0402000f 	streq	r0, [r2], #-15
     9ac:	11054a02 	tstne	r5, r2, lsl #20
     9b0:	02040200 	andeq	r0, r4, #0, 4
     9b4:	001a0582 	andseq	r0, sl, r2, lsl #11
     9b8:	4a020402 	bmi	819c8 <__bss_end+0x77da0>
     9bc:	02001305 	andeq	r1, r0, #335544320	; 0x14000000
     9c0:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
     9c4:	04020005 	streq	r0, [r2], #-5
     9c8:	1b052c02 	blne	14b9d8 <__bss_end+0x141db0>
     9cc:	310a0583 	smlabbcc	sl, r3, r5, r0
     9d0:	052e0b05 	streq	r0, [lr, #-2821]!	; 0xfffff4fb
     9d4:	0c054a0d 			; <UNDEFINED> instruction: 0x0c054a0d
     9d8:	3001054b 	andcc	r0, r1, fp, asr #10
     9dc:	9f08056a 	svcls	0x0008056a
     9e0:	054c0b05 	strbeq	r0, [ip, #-2821]	; 0xfffff4fb
     9e4:	04020014 	streq	r0, [r2], #-20	; 0xffffffec
     9e8:	07054a03 	streq	r4, [r5, -r3, lsl #20]
     9ec:	02040200 	andeq	r0, r4, #0, 4
     9f0:	00080583 	andeq	r0, r8, r3, lsl #11
     9f4:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
     9f8:	02000a05 	andeq	r0, r0, #20480	; 0x5000
     9fc:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
     a00:	04020002 	streq	r0, [r2], #-2
     a04:	01054902 	tsteq	r5, r2, lsl #18
     a08:	0e058584 	cfsh32eq	mvfx8, mvfx5, #-60
     a0c:	4b0805bb 	blmi	202100 <__bss_end+0x1f84d8>
     a10:	054c0b05 	strbeq	r0, [ip, #-2821]	; 0xfffff4fb
     a14:	04020014 	streq	r0, [r2], #-20	; 0xffffffec
     a18:	16054a03 	strne	r4, [r5], -r3, lsl #20
     a1c:	02040200 	andeq	r0, r4, #0, 4
     a20:	00170583 	andseq	r0, r7, r3, lsl #11
     a24:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
     a28:	02000a05 	andeq	r0, r0, #20480	; 0x5000
     a2c:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
     a30:	0402000b 	streq	r0, [r2], #-11
     a34:	17052e02 	strne	r2, [r5, -r2, lsl #28]
     a38:	02040200 	andeq	r0, r4, #0, 4
     a3c:	000d054a 	andeq	r0, sp, sl, asr #10
     a40:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
     a44:	02000205 	andeq	r0, r0, #1342177280	; 0x50000000
     a48:	052d0204 	streq	r0, [sp, #-516]!	; 0xfffffdfc
     a4c:	05878401 	streq	r8, [r7, #1025]	; 0x401
     a50:	10059f09 	andne	r9, r5, r9, lsl #30
     a54:	6613054b 	ldrvs	r0, [r3], -fp, asr #10
     a58:	05bb1005 	ldreq	r1, [fp, #5]!
     a5c:	0c058105 	stfeqd	f0, [r5], {5}
     a60:	2f010531 	svccs	0x00010531
     a64:	a20a0586 	andge	r0, sl, #562036736	; 0x21800000
     a68:	05670505 	strbeq	r0, [r7, #-1285]!	; 0xfffffafb
     a6c:	0b05840e 	bleq	161aac <__bss_end+0x157e84>
     a70:	690d0567 	stmdbvs	sp, {r0, r1, r2, r5, r6, r8, sl}
     a74:	9f4b0c05 	svcls	0x004b0c05
     a78:	05670d05 	strbeq	r0, [r7, #-3333]!	; 0xfffff2fb
     a7c:	15056917 	strne	r6, [r5, #-2327]	; 0xfffff6e9
     a80:	4a2d0566 	bmi	b42020 <__bss_end+0xb383f8>
     a84:	02003d05 	andeq	r3, r0, #320	; 0x140
     a88:	05660104 	strbeq	r0, [r6, #-260]!	; 0xfffffefc
     a8c:	0402003b 	streq	r0, [r2], #-59	; 0xffffffc5
     a90:	2d056601 	stccs	6, cr6, [r5, #-4]
     a94:	01040200 	mrseq	r0, R12_usr
     a98:	682b054a 	stmdavs	fp!, {r1, r3, r6, r8, sl}
     a9c:	054a1c05 	strbeq	r1, [sl, #-3077]	; 0xfffff3fb
     aa0:	11058215 	tstne	r5, r5, lsl r2
     aa4:	6710052e 	ldrvs	r0, [r0, -lr, lsr #10]
     aa8:	7d0505a0 	cfstr32vc	mvfx0, [r5, #-640]	; 0xfffffd80
     aac:	09031605 	stmdbeq	r3, {r0, r2, r9, sl, ip}
     ab0:	d61b052e 	ldrle	r0, [fp], -lr, lsr #10
     ab4:	054a1105 	strbeq	r1, [sl, #-261]	; 0xfffffefb
     ab8:	04020026 	streq	r0, [r2], #-38	; 0xffffffda
     abc:	0b05ba03 	bleq	16f2d0 <__bss_end+0x1656a8>
     ac0:	02040200 	andeq	r0, r4, #0, 4
     ac4:	0005059f 	muleq	r5, pc, r5	; <UNPREDICTABLE>
     ac8:	81020402 	tsthi	r2, r2, lsl #8
     acc:	05f50e05 	ldrbeq	r0, [r5, #3589]!	; 0xe05
     ad0:	0c054b15 			; <UNDEFINED> instruction: 0x0c054b15
     ad4:	0505d766 	streq	sp, [r5, #-1894]	; 0xfffff89a
     ad8:	840f059f 	strhi	r0, [pc], #-1439	; ae0 <shift+0xae0>
     adc:	05d71105 	ldrbeq	r1, [r7, #261]	; 0x105
     ae0:	1805d90c 	stmdane	r5, {r2, r3, r8, fp, ip, lr, pc}
     ae4:	01040200 	mrseq	r0, R12_usr
     ae8:	6809054a 	stmdavs	r9, {r1, r3, r6, r8, sl}
     aec:	059f1005 	ldreq	r1, [pc, #5]	; af9 <shift+0xaf9>
     af0:	0e056612 	mcreq	6, 0, r6, cr5, cr2, {0}
     af4:	9f100567 	svcls	0x00100567
     af8:	05661205 	strbeq	r1, [r6, #-517]!	; 0xfffffdfb
     afc:	1d05670e 	stcne	7, cr6, [r5, #-56]	; 0xffffffc8
     b00:	01040200 	mrseq	r0, R12_usr
     b04:	67100582 	ldrvs	r0, [r0, -r2, lsl #11]
     b08:	05661205 	strbeq	r1, [r6, #-517]!	; 0xfffffdfb
     b0c:	2205691c 	andcs	r6, r5, #28, 18	; 0x70000
     b10:	2e100582 	cdpcs	5, 1, cr0, cr0, cr2, {4}
     b14:	05662205 	strbeq	r2, [r6, #-517]!	; 0xfffffdfb
     b18:	14054a12 	strne	r4, [r5], #-2578	; 0xfffff5ee
     b1c:	0005052f 	andeq	r0, r5, pc, lsr #10
     b20:	03020402 	movweq	r0, #9218	; 0x2402
     b24:	0105d675 	tsteq	r5, r5, ror r6
     b28:	029e0e03 	addseq	r0, lr, #3, 28	; 0x30
     b2c:	0101000a 	tsteq	r1, sl
     b30:	00000079 	andeq	r0, r0, r9, ror r0
     b34:	00460003 	subeq	r0, r6, r3
     b38:	01020000 	mrseq	r0, (UNDEF: 2)
     b3c:	000d0efb 	strdeq	r0, [sp], -fp
     b40:	01010101 	tsteq	r1, r1, lsl #2
     b44:	01000000 	mrseq	r0, (UNDEF: 0)
     b48:	2e010000 	cdpcs	0, 0, cr0, cr1, cr0, {0}
     b4c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     b50:	2f2e2e2f 	svccs	0x002e2e2f
     b54:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     b58:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     b5c:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
     b60:	2f636367 	svccs	0x00636367
     b64:	666e6f63 	strbtvs	r6, [lr], -r3, ror #30
     b68:	612f6769 			; <UNDEFINED> instruction: 0x612f6769
     b6c:	00006d72 	andeq	r6, r0, r2, ror sp
     b70:	3162696c 	cmncc	r2, ip, ror #18
     b74:	636e7566 	cmnvs	lr, #427819008	; 0x19800000
     b78:	00532e73 	subseq	r2, r3, r3, ror lr
     b7c:	00000001 	andeq	r0, r0, r1
     b80:	7c020500 	cfstr32vc	mvfx0, [r2], {-0}
     b84:	03000094 	movweq	r0, #148	; 0x94
     b88:	300108cf 	andcc	r0, r1, pc, asr #17
     b8c:	2f2f2f2f 	svccs	0x002f2f2f
     b90:	d002302f 	andle	r3, r2, pc, lsr #32
     b94:	312f1401 			; <UNDEFINED> instruction: 0x312f1401
     b98:	4c302f2f 	ldcmi	15, cr2, [r0], #-188	; 0xffffff44
     b9c:	1f03322f 	svcne	0x0003322f
     ba0:	2f2f2f66 	svccs	0x002f2f66
     ba4:	2f2f2f2f 	svccs	0x002f2f2f
     ba8:	01000202 	tsteq	r0, r2, lsl #4
     bac:	00005c01 	andeq	r5, r0, r1, lsl #24
     bb0:	46000300 	strmi	r0, [r0], -r0, lsl #6
     bb4:	02000000 	andeq	r0, r0, #0
     bb8:	0d0efb01 	vstreq	d15, [lr, #-4]
     bbc:	01010100 	mrseq	r0, (UNDEF: 17)
     bc0:	00000001 	andeq	r0, r0, r1
     bc4:	01000001 	tsteq	r0, r1
     bc8:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     bcc:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     bd0:	2f2e2e2f 	svccs	0x002e2e2f
     bd4:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     bd8:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
     bdc:	63636762 	cmnvs	r3, #25690112	; 0x1880000
     be0:	6e6f632f 	cdpvs	3, 6, cr6, cr15, cr15, {1}
     be4:	2f676966 	svccs	0x00676966
     be8:	006d7261 	rsbeq	r7, sp, r1, ror #4
     bec:	62696c00 	rsbvs	r6, r9, #0, 24
     bf0:	6e756631 	mrcvs	6, 3, r6, cr5, cr1, {1}
     bf4:	532e7363 			; <UNDEFINED> instruction: 0x532e7363
     bf8:	00000100 	andeq	r0, r0, r0, lsl #2
     bfc:	02050000 	andeq	r0, r5, #0
     c00:	00009688 	andeq	r9, r0, r8, lsl #13
     c04:	010bb903 	tsteq	fp, r3, lsl #18
     c08:	01000202 	tsteq	r0, r2, lsl #4
     c0c:	0000fb01 	andeq	pc, r0, r1, lsl #22
     c10:	47000300 	strmi	r0, [r0, -r0, lsl #6]
     c14:	02000000 	andeq	r0, r0, #0
     c18:	0d0efb01 	vstreq	d15, [lr, #-4]
     c1c:	01010100 	mrseq	r0, (UNDEF: 17)
     c20:	00000001 	andeq	r0, r0, r1
     c24:	01000001 	tsteq	r0, r1
     c28:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     c2c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     c30:	2f2e2e2f 	svccs	0x002e2e2f
     c34:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     c38:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
     c3c:	63636762 	cmnvs	r3, #25690112	; 0x1880000
     c40:	6e6f632f 	cdpvs	3, 6, cr6, cr15, cr15, {1}
     c44:	2f676966 	svccs	0x00676966
     c48:	006d7261 	rsbeq	r7, sp, r1, ror #4
     c4c:	65656900 	strbvs	r6, [r5, #-2304]!	; 0xfffff700
     c50:	34353765 	ldrtcc	r3, [r5], #-1893	; 0xfffff89b
     c54:	2e66732d 	cdpcs	3, 6, cr7, cr6, cr13, {1}
     c58:	00010053 	andeq	r0, r1, r3, asr r0
     c5c:	05000000 	streq	r0, [r0, #-0]
     c60:	00968c02 	addseq	r8, r6, r2, lsl #24
     c64:	013a0300 	teqeq	sl, r0, lsl #6
     c68:	0903332f 	stmdbeq	r3, {r0, r1, r2, r3, r5, r8, r9, ip, sp}
     c6c:	2f2f302e 	svccs	0x002f302e
     c70:	2f322f2f 	svccs	0x00322f2f
     c74:	2f2f2f30 	svccs	0x002f2f30
     c78:	31303330 	teqcc	r0, r0, lsr r3
     c7c:	2f302f2f 	svccs	0x00302f2f
     c80:	32302f2f 	eorscc	r2, r0, #47, 30	; 0xbc
     c84:	2f32322f 	svccs	0x0032322f
     c88:	332f312f 			; <UNDEFINED> instruction: 0x332f312f
     c8c:	2f2f332f 	svccs	0x002f332f
     c90:	2f2f312f 	svccs	0x002f312f
     c94:	2f352f31 	svccs	0x00352f31
     c98:	322f2f30 	eorcc	r2, pc, #48, 30	; 0xc0
     c9c:	2f302f2f 	svccs	0x00302f2f
     ca0:	2f2e1903 	svccs	0x002e1903
     ca4:	2f352f2f 	svccs	0x00352f2f
     ca8:	3330342f 	teqcc	r0, #788529152	; 0x2f000000
     cac:	2f2f302f 	svccs	0x002f302f
     cb0:	3030312f 	eorscc	r3, r0, pc, lsr #2
     cb4:	312f302f 			; <UNDEFINED> instruction: 0x312f302f
     cb8:	32302f30 	eorscc	r2, r0, #48, 30	; 0xc0
     cbc:	2f2f312f 	svccs	0x002f312f
     cc0:	302f2f30 	eorcc	r2, pc, r0, lsr pc	; <UNPREDICTABLE>
     cc4:	2f322f2f 	svccs	0x00322f2f
     cc8:	2e09032f 	cdpcs	3, 0, cr0, cr9, cr15, {1}
     ccc:	2f2f2f30 	svccs	0x002f2f30
     cd0:	2f2f2f30 	svccs	0x002f2f30
     cd4:	2f2e0d03 	svccs	0x002e0d03
     cd8:	30303033 	eorscc	r3, r0, r3, lsr r0
     cdc:	2f303131 	svccs	0x00303131
     ce0:	302e0c03 	eorcc	r0, lr, r3, lsl #24
     ce4:	30332f30 	eorscc	r2, r3, r0, lsr pc
     ce8:	2f332f30 	svccs	0x00332f30
     cec:	2f2f3031 	svccs	0x002f3031
     cf0:	032f3031 			; <UNDEFINED> instruction: 0x032f3031
     cf4:	322f2e19 	eorcc	r2, pc, #400	; 0x190
     cf8:	2f2f302f 	svccs	0x002f302f
     cfc:	2f302f2f 	svccs	0x00302f2f
     d00:	2f2f2f30 	svccs	0x002f2f30
     d04:	022f302f 	eoreq	r3, pc, #47	; 0x2f
     d08:	01010002 	tsteq	r1, r2
     d0c:	0000007a 	andeq	r0, r0, sl, ror r0
     d10:	00420003 	subeq	r0, r2, r3
     d14:	01020000 	mrseq	r0, (UNDEF: 2)
     d18:	000d0efb 	strdeq	r0, [sp], -fp
     d1c:	01010101 	tsteq	r1, r1, lsl #2
     d20:	01000000 	mrseq	r0, (UNDEF: 0)
     d24:	2e010000 	cdpcs	0, 0, cr0, cr1, cr0, {0}
     d28:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     d2c:	2f2e2e2f 	svccs	0x002e2e2f
     d30:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     d34:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     d38:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
     d3c:	2f636367 	svccs	0x00636367
     d40:	666e6f63 	strbtvs	r6, [lr], -r3, ror #30
     d44:	612f6769 			; <UNDEFINED> instruction: 0x612f6769
     d48:	00006d72 	andeq	r6, r0, r2, ror sp
     d4c:	62617062 	rsbvs	r7, r1, #98	; 0x62
     d50:	00532e69 	subseq	r2, r3, r9, ror #28
     d54:	00000001 	andeq	r0, r0, r1
     d58:	dc020500 	cfstr32le	mvfx0, [r2], {-0}
     d5c:	03000098 	movweq	r0, #152	; 0x98
     d60:	080101b9 	stmdaeq	r1, {r0, r3, r4, r5, r7, r8}
     d64:	2f2f4b5a 	svccs	0x002f4b5a
     d68:	6730302f 	ldrvs	r3, [r0, -pc, lsr #32]!
     d6c:	2f2f2f32 	svccs	0x002f2f32
     d70:	2f673030 	svccs	0x00673030
     d74:	322f2f2f 	eorcc	r2, pc, #47, 30	; 0xbc
     d78:	6730302f 	ldrvs	r3, [r0, -pc, lsr #32]!
     d7c:	2f322f2f 	svccs	0x00322f2f
     d80:	2f672f30 	svccs	0x00672f30
     d84:	0002022f 	andeq	r0, r2, pc, lsr #4
     d88:	00a40101 	adceq	r0, r4, r1, lsl #2
     d8c:	00030000 	andeq	r0, r3, r0
     d90:	0000009e 	muleq	r0, lr, r0
     d94:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
     d98:	0101000d 	tsteq	r1, sp
     d9c:	00000101 	andeq	r0, r0, r1, lsl #2
     da0:	00000100 	andeq	r0, r0, r0, lsl #2
     da4:	2f2e2e01 	svccs	0x002e2e01
     da8:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     dac:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     db0:	2f2e2e2f 	svccs	0x002e2e2f
     db4:	63672f2e 	cmnvs	r7, #46, 30	; 0xb8
     db8:	2e2e0063 	cdpcs	0, 2, cr0, cr14, cr3, {3}
     dbc:	2f2e2e2f 	svccs	0x002e2e2f
     dc0:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     dc4:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     dc8:	2f2e2e2f 	svccs	0x002e2e2f
     dcc:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
     dd0:	2e2f6363 	cdpcs	3, 2, cr6, cr15, cr3, {3}
     dd4:	63672f2e 	cmnvs	r7, #46, 30	; 0xb8
     dd8:	6f632f63 	svcvs	0x00632f63
     ddc:	6769666e 	strbvs	r6, [r9, -lr, ror #12]!
     de0:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
     de4:	2f2e2e00 	svccs	0x002e2e00
     de8:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     dec:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     df0:	2f2e2e2f 	svccs	0x002e2e2f
     df4:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; d44 <shift+0xd44>
     df8:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
     dfc:	61000063 	tstvs	r0, r3, rrx
     e00:	692d6d72 	pushvs	{r1, r4, r5, r6, r8, sl, fp, sp, lr}
     e04:	682e6173 	stmdavs	lr!, {r0, r1, r4, r5, r6, r8, sp, lr}
     e08:	00000100 	andeq	r0, r0, r0, lsl #2
     e0c:	2e6d7261 	cdpcs	2, 6, cr7, cr13, cr1, {3}
     e10:	00020068 	andeq	r0, r2, r8, rrx
     e14:	6c626700 	stclvs	7, cr6, [r2], #-0
     e18:	6f74632d 	svcvs	0x0074632d
     e1c:	682e7372 	stmdavs	lr!, {r1, r4, r5, r6, r8, r9, ip, sp, lr}
     e20:	00000300 	andeq	r0, r0, r0, lsl #6
     e24:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
     e28:	2e326363 	cdpcs	3, 3, cr6, cr2, cr3, {3}
     e2c:	00030063 	andeq	r0, r3, r3, rrx
     e30:	00a70000 	adceq	r0, r7, r0
     e34:	00030000 	andeq	r0, r3, r0
     e38:	00000068 	andeq	r0, r0, r8, rrx
     e3c:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
     e40:	0101000d 	tsteq	r1, sp
     e44:	00000101 	andeq	r0, r0, r1, lsl #2
     e48:	00000100 	andeq	r0, r0, r0, lsl #2
     e4c:	2f2e2e01 	svccs	0x002e2e01
     e50:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     e54:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     e58:	2f2e2e2f 	svccs	0x002e2e2f
     e5c:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; dac <shift+0xdac>
     e60:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
     e64:	2e2e0063 	cdpcs	0, 2, cr0, cr14, cr3, {3}
     e68:	2f2e2e2f 	svccs	0x002e2e2f
     e6c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     e70:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     e74:	672f2e2f 	strvs	r2, [pc, -pc, lsr #28]!
     e78:	00006363 	andeq	r6, r0, r3, ror #6
     e7c:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
     e80:	2e326363 	cdpcs	3, 3, cr6, cr2, cr3, {3}
     e84:	00010063 	andeq	r0, r1, r3, rrx
     e88:	6d726100 	ldfvse	f6, [r2, #-0]
     e8c:	6173692d 	cmnvs	r3, sp, lsr #18
     e90:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
     e94:	696c0000 	stmdbvs	ip!, {}^	; <UNPREDICTABLE>
     e98:	63636762 	cmnvs	r3, #25690112	; 0x1880000
     e9c:	00682e32 	rsbeq	r2, r8, r2, lsr lr
     ea0:	00000001 	andeq	r0, r0, r1
     ea4:	05000105 	streq	r0, [r0, #-261]	; 0xfffffefb
     ea8:	0099b002 	addseq	fp, r9, r2
     eac:	0bf90300 	bleq	ffe41ab4 <__bss_end+0xffe37e8c>
     eb0:	13030501 	movwne	r0, #13569	; 0x3501
     eb4:	11060105 	tstne	r6, r5, lsl #2
     eb8:	052f0605 	streq	r0, [pc, #-1541]!	; 8bb <shift+0x8bb>
     ebc:	05680603 	strbeq	r0, [r8, #-1539]!	; 0xfffff9fd
     ec0:	0501060a 	streq	r0, [r1, #-1546]	; 0xfffff9f6
     ec4:	052d0605 	streq	r0, [sp, #-1541]!	; 0xfffff9fb
     ec8:	0501060e 	streq	r0, [r1, #-1550]	; 0xfffff9f2
     ecc:	0e052c01 	cdpeq	12, 0, cr2, cr5, cr1, {0}
     ed0:	0c052e30 	stceq	14, cr2, [r5], {48}	; 0x30
     ed4:	4c01052e 	cfstr32mi	mvfx0, [r1], {46}	; 0x2e
     ed8:	01000202 	tsteq	r0, r2, lsl #4
     edc:	0000b601 	andeq	fp, r0, r1, lsl #12
     ee0:	68000300 	stmdavs	r0, {r8, r9}
     ee4:	02000000 	andeq	r0, r0, #0
     ee8:	0d0efb01 	vstreq	d15, [lr, #-4]
     eec:	01010100 	mrseq	r0, (UNDEF: 17)
     ef0:	00000001 	andeq	r0, r0, r1
     ef4:	01000001 	tsteq	r0, r1
     ef8:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     efc:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     f00:	2f2e2e2f 	svccs	0x002e2e2f
     f04:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     f08:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
     f0c:	63636762 	cmnvs	r3, #25690112	; 0x1880000
     f10:	2f2e2e00 	svccs	0x002e2e00
     f14:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     f18:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     f1c:	2f2e2e2f 	svccs	0x002e2e2f
     f20:	63672f2e 	cmnvs	r7, #46, 30	; 0xb8
     f24:	6c000063 	stcvs	0, cr0, [r0], {99}	; 0x63
     f28:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
     f2c:	632e3263 			; <UNDEFINED> instruction: 0x632e3263
     f30:	00000100 	andeq	r0, r0, r0, lsl #2
     f34:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
     f38:	2e617369 	cdpcs	3, 6, cr7, cr1, cr9, {3}
     f3c:	00020068 	andeq	r0, r2, r8, rrx
     f40:	62696c00 	rsbvs	r6, r9, #0, 24
     f44:	32636367 	rsbcc	r6, r3, #-1677721599	; 0x9c000001
     f48:	0100682e 	tsteq	r0, lr, lsr #16
     f4c:	05000000 	streq	r0, [r0, #-0]
     f50:	02050001 	andeq	r0, r5, #1
     f54:	000099e0 	andeq	r9, r0, r0, ror #19
     f58:	010bb903 	tsteq	fp, r3, lsl #18
     f5c:	05170305 	ldreq	r0, [r7, #-773]	; 0xfffffcfb
     f60:	05010610 	streq	r0, [r1, #-1552]	; 0xfffff9f0
     f64:	27053319 	smladcs	r5, r9, r3, r3
     f68:	03100533 	tsteq	r0, #213909504	; 0xcc00000
     f6c:	03052e76 	movweq	r2, #24182	; 0x5e76
     f70:	19053306 	stmdbne	r5, {r1, r2, r8, r9, ip, sp}
     f74:	10050106 	andne	r0, r5, r6, lsl #2
     f78:	0603052e 	streq	r0, [r3], -lr, lsr #10
     f7c:	1b051533 	blne	146450 <__bss_end+0x13c828>
     f80:	01050f06 	tsteq	r5, r6, lsl #30
     f84:	052e2b03 	streq	r2, [lr, #-2819]!	; 0xfffff4fd
     f88:	2e550319 	mrccs	3, 2, r0, cr5, cr9, {0}
     f8c:	2b030105 	blcs	c13a8 <__bss_end+0xb7780>
     f90:	0a024a2e 	beq	93850 <__bss_end+0x89c28>
     f94:	69010100 	stmdbvs	r1, {r8}
     f98:	03000001 	movweq	r0, #1
     f9c:	00006800 	andeq	r6, r0, r0, lsl #16
     fa0:	fb010200 	blx	417aa <__bss_end+0x37b82>
     fa4:	01000d0e 	tsteq	r0, lr, lsl #26
     fa8:	00010101 	andeq	r0, r1, r1, lsl #2
     fac:	00010000 	andeq	r0, r1, r0
     fb0:	2e2e0100 	sufcse	f0, f6, f0
     fb4:	2f2e2e2f 	svccs	0x002e2e2f
     fb8:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     fbc:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     fc0:	2f2e2e2f 	svccs	0x002e2e2f
     fc4:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
     fc8:	2e006363 	cdpcs	3, 0, cr6, cr0, cr3, {3}
     fcc:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     fd0:	2f2e2e2f 	svccs	0x002e2e2f
     fd4:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     fd8:	2f2e2f2e 	svccs	0x002e2f2e
     fdc:	00636367 	rsbeq	r6, r3, r7, ror #6
     fe0:	62696c00 	rsbvs	r6, r9, #0, 24
     fe4:	32636367 	rsbcc	r6, r3, #-1677721599	; 0x9c000001
     fe8:	0100632e 	tsteq	r0, lr, lsr #6
     fec:	72610000 	rsbvc	r0, r1, #0
     ff0:	73692d6d 	cmnvc	r9, #6976	; 0x1b40
     ff4:	00682e61 	rsbeq	r2, r8, r1, ror #28
     ff8:	6c000002 	stcvs	0, cr0, [r0], {2}
     ffc:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    1000:	682e3263 	stmdavs	lr!, {r0, r1, r5, r6, r9, ip, sp}
    1004:	00000100 	andeq	r0, r0, r0, lsl #2
    1008:	00010500 	andeq	r0, r1, r0, lsl #10
    100c:	9a200205 	bls	801828 <__bss_end+0x7f7c00>
    1010:	b3030000 	movwlt	r0, #12288	; 0x3000
    1014:	03050107 	movweq	r0, #20743	; 0x5107
    1018:	0a031313 	beq	c5c6c <__bss_end+0xbc044>
    101c:	06060501 	streq	r0, [r6], -r1, lsl #10
    1020:	03010501 	movweq	r0, #5377	; 0x1501
    1024:	0b054a74 	bleq	1539fc <__bss_end+0x149dd4>
    1028:	2d01052f 	cfstr32cs	mvfx0, [r1, #-188]	; 0xffffff44
    102c:	052f0b05 	streq	r0, [pc, #-2821]!	; 52f <shift+0x52f>
    1030:	2e0b0306 	cdpcs	3, 0, cr0, cr11, cr6, {0}
    1034:	30060705 	andcc	r0, r6, r5, lsl #14
    1038:	01060d05 	tsteq	r6, r5, lsl #26
    103c:	83060705 	movwhi	r0, #26373	; 0x6705
    1040:	01060d05 	tsteq	r6, r5, lsl #26
    1044:	0607054a 	streq	r0, [r7], -sl, asr #10
    1048:	0609054c 	streq	r0, [r9], -ip, asr #10
    104c:	06070501 	streq	r0, [r7], -r1, lsl #10
    1050:	0609052f 	streq	r0, [r9], -pc, lsr #10
    1054:	07052e01 	streq	r2, [r5, -r1, lsl #28]
    1058:	0a05a506 	beq	16a478 <__bss_end+0x160850>
    105c:	052e0106 	streq	r0, [lr, #-262]!	; 0xfffffefa
    1060:	2e68030b 	cdpcs	3, 6, cr0, cr8, cr11, {0}
    1064:	18030a05 	stmdane	r3, {r0, r2, r9, fp}
    1068:	0604054a 	streq	r0, [r4], -sl, asr #10
    106c:	06060530 			; <UNDEFINED> instruction: 0x06060530
    1070:	492f4913 	stmdbmi	pc!, {r0, r1, r4, r8, fp, lr}	; <UNPREDICTABLE>
    1074:	2f060405 	svccs	0x00060405
    1078:	05150705 	ldreq	r0, [r5, #-1797]	; 0xfffff8fb
    107c:	0501060a 	streq	r0, [r1, #-1546]	; 0xfffff9f6
    1080:	054c0604 	strbeq	r0, [ip, #-1540]	; 0xfffff9fc
    1084:	2e010606 	cfmadd32cs	mvax0, mvfx0, mvfx1, mvfx6
    1088:	4e060405 	cdpmi	4, 0, cr0, cr6, cr5, {0}
    108c:	0e060605 	cfmadd32eq	mvax0, mvfx0, mvfx6, mvfx5
    1090:	05520b05 	ldrbeq	r0, [r2, #-2821]	; 0xfffff4fb
    1094:	05054a10 	streq	r4, [r5, #-2576]	; 0xfffff5f0
    1098:	08052e4a 	stmdaeq	r5, {r1, r3, r6, r9, sl, fp, sp}
    109c:	0e053106 	adfeqs	f3, f5, f6
    10a0:	06060513 			; <UNDEFINED> instruction: 0x06060513
    10a4:	04052e01 	streq	r2, [r5], #-3585	; 0xfffff1ff
    10a8:	2e790306 	cdpcs	3, 7, cr0, cr9, cr6, {0}
    10ac:	05140805 	ldreq	r0, [r4, #-2053]	; 0xfffff7fb
    10b0:	05141303 	ldreq	r1, [r4, #-771]	; 0xfffffcfd
    10b4:	050f060b 	streq	r0, [pc, #-1547]	; ab1 <shift+0xab1>
    10b8:	052e6905 	streq	r6, [lr, #-2309]!	; 0xfffff6fb
    10bc:	052f0608 	streq	r0, [pc, #-1544]!	; abc <shift+0xabc>
    10c0:	0605130e 	streq	r1, [r5], -lr, lsl #6
    10c4:	052e0106 	streq	r0, [lr, #-262]!	; 0xfffffefa
    10c8:	05320604 	ldreq	r0, [r2, #-1540]!	; 0xfffff9fc
    10cc:	2f010606 	svccs	0x00010606
    10d0:	06040549 	streq	r0, [r4], -r9, asr #10
    10d4:	0606052f 	streq	r0, [r6], -pc, lsr #10
    10d8:	06040501 	streq	r0, [r4], -r1, lsl #10
    10dc:	060f054b 	streq	r0, [pc], -fp, asr #10
    10e0:	06054a01 	streq	r4, [r5], -r1, lsl #20
    10e4:	03052e4a 	movweq	r2, #24138	; 0x5e4a
    10e8:	06053206 	streq	r3, [r5], -r6, lsl #4
    10ec:	05050106 	streq	r0, [r5, #-262]	; 0xfffffefa
    10f0:	09052f06 	stmdbeq	r5, {r1, r2, r8, r9, sl, fp, sp}
    10f4:	03050106 	movweq	r0, #20742	; 0x5106
    10f8:	01052f06 	tsteq	r5, r6, lsl #30
    10fc:	022e1306 	eoreq	r1, lr, #402653184	; 0x18000000
    1100:	01010004 	tsteq	r1, r4

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
      34:	fb0c0000 	blx	30003e <__bss_end+0x2f6416>
      38:	2a000000 	bcs	40 <shift+0x40>
      3c:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
      40:	9c000080 	stcls	0, cr0, [r0], {128}	; 0x80
      44:	5a000000 	bpl	4c <shift+0x4c>
      48:	02000000 	andeq	r0, r0, #0
      4c:	0000012c 	andeq	r0, r0, ip, lsr #2
      50:	31150601 	tstcc	r5, r1, lsl #12
      54:	03000000 	movweq	r0, #0
      58:	159f0704 	ldrne	r0, [pc, #1796]	; 764 <shift+0x764>
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
     128:	0000159f 	muleq	r0, pc, r5	; <UNPREDICTABLE>
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
     174:	cb104801 	blgt	412180 <__bss_end+0x408558>
     178:	d4000000 	strle	r0, [r0], #-0
     17c:	58000081 	stmdapl	r0, {r0, r7}
     180:	01000000 	mrseq	r0, (UNDEF: 0)
     184:	0000cb9c 	muleq	r0, ip, fp
     188:	01800a00 	orreq	r0, r0, r0, lsl #20
     18c:	4a010000 	bmi	40194 <__bss_end+0x3656c>
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
     1d4:	5b0c0000 	blpl	3001dc <__bss_end+0x2f65b4>
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
     24c:	8b120f01 	blhi	483e58 <__bss_end+0x47a230>
     250:	0f000001 	svceq	0x00000001
     254:	0000019e 	muleq	r0, lr, r1
     258:	03231000 			; <UNDEFINED> instruction: 0x03231000
     25c:	0a010000 	beq	40264 <__bss_end+0x3663c>
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
     2b4:	8b140074 	blhi	50048c <__bss_end+0x4f6864>
     2b8:	a4000001 	strge	r0, [r0], #-1
     2bc:	38000080 	stmdacc	r0, {r7}
     2c0:	01000000 	mrseq	r0, (UNDEF: 0)
     2c4:	0067139c 	mlseq	r7, ip, r3, r1
     2c8:	9e2f0a01 	vmulls.f32	s0, s30, s2
     2cc:	02000001 	andeq	r0, r0, #1
     2d0:	00007491 	muleq	r0, r1, r4
     2d4:	0000087a 	andeq	r0, r0, sl, ror r8
     2d8:	01e00004 	mvneq	r0, r4
     2dc:	01040000 	mrseq	r0, (UNDEF: 4)
     2e0:	0000025e 	andeq	r0, r0, lr, asr r2
     2e4:	0005c704 	andeq	ip, r5, r4, lsl #14
     2e8:	00002a00 	andeq	r2, r0, r0, lsl #20
     2ec:	00822c00 	addeq	r2, r2, r0, lsl #24
     2f0:	00019400 	andeq	r9, r1, r0, lsl #8
     2f4:	0001c200 	andeq	ip, r1, r0, lsl #4
     2f8:	08010200 	stmdaeq	r1, {r9}
     2fc:	00000925 	andeq	r0, r0, r5, lsr #18
     300:	71050202 	tstvc	r5, r2, lsl #4
     304:	03000009 	movweq	r0, #9
     308:	6e690504 	cdpvs	5, 6, cr0, cr9, cr4, {0}
     30c:	01020074 	tsteq	r2, r4, ror r0
     310:	00091c08 	andeq	r1, r9, r8, lsl #24
     314:	07020200 	streq	r0, [r2, -r0, lsl #4]
     318:	00000734 	andeq	r0, r0, r4, lsr r7
     31c:	00099f04 	andeq	r9, r9, r4, lsl #30
     320:	07090900 	streq	r0, [r9, -r0, lsl #18]
     324:	00000059 	andeq	r0, r0, r9, asr r0
     328:	00004805 	andeq	r4, r0, r5, lsl #16
     32c:	07040200 	streq	r0, [r4, -r0, lsl #4]
     330:	0000159f 	muleq	r0, pc, r5	; <UNPREDICTABLE>
     334:	00005905 	andeq	r5, r0, r5, lsl #18
     338:	054e0600 	strbeq	r0, [lr, #-1536]	; 0xfffffa00
     33c:	02080000 	andeq	r0, r8, #0
     340:	008b0806 	addeq	r0, fp, r6, lsl #16
     344:	72070000 	andvc	r0, r7, #0
     348:	08020030 	stmdaeq	r2, {r4, r5}
     34c:	0000480e 	andeq	r4, r0, lr, lsl #16
     350:	72070000 	andvc	r0, r7, #0
     354:	09020031 	stmdbeq	r2, {r0, r4, r5}
     358:	0000480e 	andeq	r4, r0, lr, lsl #16
     35c:	08000400 	stmdaeq	r0, {sl}
     360:	0000076d 	andeq	r0, r0, sp, ror #14
     364:	00330405 	eorseq	r0, r3, r5, lsl #8
     368:	1e020000 	cdpne	0, 0, cr0, cr2, cr0, {0}
     36c:	0000ce0c 	andeq	ip, r0, ip, lsl #28
     370:	05b50900 	ldreq	r0, [r5, #2304]!	; 0x900
     374:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
     378:	00000baf 	andeq	r0, r0, pc, lsr #23
     37c:	0b8f0901 	bleq	fe3c2788 <__bss_end+0xfe3b8b60>
     380:	09020000 	stmdbeq	r2, {}	; <UNPREDICTABLE>
     384:	00000767 	andeq	r0, r0, r7, ror #14
     388:	08ab0903 	stmiaeq	fp!, {r0, r1, r8, fp}
     38c:	09040000 	stmdbeq	r4, {}	; <UNPREDICTABLE>
     390:	0000057e 	andeq	r0, r0, lr, ror r5
     394:	03de0905 	bicseq	r0, lr, #81920	; 0x14000
     398:	09060000 	stmdbeq	r6, {}	; <UNPREDICTABLE>
     39c:	00000b5c 	andeq	r0, r0, ip, asr fp
     3a0:	35080007 	strcc	r0, [r8, #-7]
     3a4:	0500000b 	streq	r0, [r0, #-11]
     3a8:	00003304 	andeq	r3, r0, r4, lsl #6
     3ac:	0c490200 	sfmeq	f0, 2, [r9], {-0}
     3b0:	0000010b 	andeq	r0, r0, fp, lsl #2
     3b4:	00034d09 	andeq	r4, r3, r9, lsl #26
     3b8:	3e090000 	cdpcc	0, 0, cr0, cr9, cr0, {0}
     3bc:	01000004 	tsteq	r0, r4
     3c0:	00089e09 	andeq	r9, r8, r9, lsl #28
     3c4:	61090200 	mrsvs	r0, R9_fiq
     3c8:	0300000b 	movweq	r0, #11
     3cc:	000bb909 	andeq	fp, fp, r9, lsl #18
     3d0:	49090400 	stmdbmi	r9, {sl}
     3d4:	05000008 	streq	r0, [r0, #-8]
     3d8:	00075409 	andeq	r5, r7, r9, lsl #8
     3dc:	0a000600 	beq	1be4 <shift+0x1be4>
     3e0:	00000870 	andeq	r0, r0, r0, ror r8
     3e4:	54140503 	ldrpl	r0, [r4], #-1283	; 0xfffffafd
     3e8:	05000000 	streq	r0, [r0, #-0]
     3ec:	009b4003 	addseq	r4, fp, r3
     3f0:	087e0a00 	ldmdaeq	lr!, {r9, fp}^
     3f4:	06030000 	streq	r0, [r3], -r0
     3f8:	00005414 	andeq	r5, r0, r4, lsl r4
     3fc:	44030500 	strmi	r0, [r3], #-1280	; 0xfffffb00
     400:	0a00009b 	beq	674 <shift+0x674>
     404:	00000833 	andeq	r0, r0, r3, lsr r8
     408:	541a0704 	ldrpl	r0, [sl], #-1796	; 0xfffff8fc
     40c:	05000000 	streq	r0, [r0, #-0]
     410:	009b4803 	addseq	r4, fp, r3, lsl #16
     414:	046d0a00 	strbteq	r0, [sp], #-2560	; 0xfffff600
     418:	09040000 	stmdbeq	r4, {}	; <UNPREDICTABLE>
     41c:	0000541a 	andeq	r5, r0, sl, lsl r4
     420:	4c030500 	cfstr32mi	mvfx0, [r3], {-0}
     424:	0a00009b 	beq	698 <shift+0x698>
     428:	0000090e 	andeq	r0, r0, lr, lsl #18
     42c:	541a0b04 	ldrpl	r0, [sl], #-2820	; 0xfffff4fc
     430:	05000000 	streq	r0, [r0, #-0]
     434:	009b5003 	addseq	r5, fp, r3
     438:	07000a00 	streq	r0, [r0, -r0, lsl #20]
     43c:	0d040000 	stceq	0, cr0, [r4, #-0]
     440:	0000541a 	andeq	r5, r0, sl, lsl r4
     444:	54030500 	strpl	r0, [r3], #-1280	; 0xfffffb00
     448:	0a00009b 	beq	6bc <shift+0x6bc>
     44c:	00000567 	andeq	r0, r0, r7, ror #10
     450:	541a0f04 	ldrpl	r0, [sl], #-3844	; 0xfffff0fc
     454:	05000000 	streq	r0, [r0, #-0]
     458:	009b5803 	addseq	r5, fp, r3, lsl #16
     45c:	0f9e0800 	svceq	0x009e0800
     460:	04050000 	streq	r0, [r5], #-0
     464:	00000033 	andeq	r0, r0, r3, lsr r0
     468:	ae0c1b04 	vmlage.f64	d1, d12, d4
     46c:	09000001 	stmdbeq	r0, {r0}
     470:	000009c7 	andeq	r0, r0, r7, asr #19
     474:	0b840900 	bleq	fe10287c <__bss_end+0xfe0f8c54>
     478:	09010000 	stmdbeq	r1, {}	; <UNPREDICTABLE>
     47c:	00000899 	muleq	r0, r9, r8
     480:	080b0002 	stmdaeq	fp, {r1}
     484:	02000009 	andeq	r0, r0, #9
     488:	078f0201 	streq	r0, [pc, r1, lsl #4]
     48c:	040c0000 	streq	r0, [ip], #-0
     490:	000001ae 	andeq	r0, r0, lr, lsr #3
     494:	0006360a 	andeq	r3, r6, sl, lsl #12
     498:	14040500 	strne	r0, [r4], #-1280	; 0xfffffb00
     49c:	00000054 	andeq	r0, r0, r4, asr r0
     4a0:	9b5c0305 	blls	17010bc <__bss_end+0x16f7494>
     4a4:	420a0000 	andmi	r0, sl, #0
     4a8:	05000003 	streq	r0, [r0, #-3]
     4ac:	00541407 	subseq	r1, r4, r7, lsl #8
     4b0:	03050000 	movweq	r0, #20480	; 0x5000
     4b4:	00009b60 	andeq	r9, r0, r0, ror #22
     4b8:	00049b0a 	andeq	r9, r4, sl, lsl #22
     4bc:	140a0500 	strne	r0, [sl], #-1280	; 0xfffffb00
     4c0:	00000054 	andeq	r0, r0, r4, asr r0
     4c4:	9b640305 	blls	19010e0 <__bss_end+0x18f74b8>
     4c8:	c4080000 	strgt	r0, [r8], #-0
     4cc:	05000007 	streq	r0, [r0, #-7]
     4d0:	00003304 	andeq	r3, r0, r4, lsl #6
     4d4:	0c0d0500 	cfstr32eq	mvfx0, [sp], {-0}
     4d8:	0000022d 	andeq	r0, r0, sp, lsr #4
     4dc:	77654e0d 	strbvc	r4, [r5, -sp, lsl #28]!
     4e0:	bb090000 	bllt	2404e8 <__bss_end+0x2368c0>
     4e4:	01000007 	tsteq	r0, r7
     4e8:	00099709 	andeq	r9, r9, r9, lsl #14
     4ec:	9e090200 	cdpls	2, 0, cr0, cr9, cr0, {0}
     4f0:	03000007 	movweq	r0, #7
     4f4:	00075909 	andeq	r5, r7, r9, lsl #18
     4f8:	a4090400 	strge	r0, [r9], #-1024	; 0xfffffc00
     4fc:	05000008 	streq	r0, [r0, #-8]
     500:	05710600 	ldrbeq	r0, [r1, #-1536]!	; 0xfffffa00
     504:	05100000 	ldreq	r0, [r0, #-0]
     508:	026c081b 	rsbeq	r0, ip, #1769472	; 0x1b0000
     50c:	6c070000 	stcvs	0, cr0, [r7], {-0}
     510:	1d050072 	stcne	0, cr0, [r5, #-456]	; 0xfffffe38
     514:	00026c13 	andeq	r6, r2, r3, lsl ip
     518:	73070000 	movwvc	r0, #28672	; 0x7000
     51c:	1e050070 	mcrne	0, 0, r0, cr5, cr0, {3}
     520:	00026c13 	andeq	r6, r2, r3, lsl ip
     524:	70070400 	andvc	r0, r7, r0, lsl #8
     528:	1f050063 	svcne	0x00050063
     52c:	00026c13 	andeq	r6, r2, r3, lsl ip
     530:	870e0800 	strhi	r0, [lr, -r0, lsl #16]
     534:	05000005 	streq	r0, [r0, #-5]
     538:	026c1320 	rsbeq	r1, ip, #32, 6	; 0x80000000
     53c:	000c0000 	andeq	r0, ip, r0
     540:	9a070402 	bls	1c1550 <__bss_end+0x1b7928>
     544:	05000015 	streq	r0, [r0, #-21]	; 0xffffffeb
     548:	0000026c 	andeq	r0, r0, ip, ror #4
     54c:	0003af06 	andeq	sl, r3, r6, lsl #30
     550:	28057c00 	stmdacs	r5, {sl, fp, ip, sp, lr}
     554:	00032f08 	andeq	r2, r3, r8, lsl #30
     558:	09bb0e00 	ldmibeq	fp!, {r9, sl, fp}
     55c:	2a050000 	bcs	140564 <__bss_end+0x13693c>
     560:	00022d12 	andeq	r2, r2, r2, lsl sp
     564:	70070000 	andvc	r0, r7, r0
     568:	05006469 	streq	r6, [r0, #-1129]	; 0xfffffb97
     56c:	0059122b 	subseq	r1, r9, fp, lsr #4
     570:	0e100000 	cdpeq	0, 1, cr0, cr0, cr0, {0}
     574:	00000467 	andeq	r0, r0, r7, ror #8
     578:	f6112c05 			; <UNDEFINED> instruction: 0xf6112c05
     57c:	14000001 	strne	r0, [r0], #-1
     580:	0007d00e 	andeq	sp, r7, lr
     584:	122d0500 	eorne	r0, sp, #0, 10
     588:	00000059 	andeq	r0, r0, r9, asr r0
     58c:	07de0e18 	bfieq	r0, r8, #28, #3
     590:	2e050000 	cdpcs	0, 0, cr0, cr5, cr0, {0}
     594:	00005912 	andeq	r5, r0, r2, lsl r9
     598:	5a0e1c00 	bpl	3875a0 <__bss_end+0x37d978>
     59c:	05000005 	streq	r0, [r0, #-5]
     5a0:	032f0c2f 			; <UNDEFINED> instruction: 0x032f0c2f
     5a4:	0e200000 	cdpeq	0, 2, cr0, cr0, cr0, {0}
     5a8:	000007f4 	strdeq	r0, [r0], -r4
     5ac:	33093005 	movwcc	r3, #36869	; 0x9005
     5b0:	60000000 	andvs	r0, r0, r0
     5b4:	0009d10e 	andeq	sp, r9, lr, lsl #2
     5b8:	0e310500 	cfabs32eq	mvfx0, mvfx1
     5bc:	00000048 	andeq	r0, r0, r8, asr #32
     5c0:	06090e64 	streq	r0, [r9], -r4, ror #28
     5c4:	33050000 	movwcc	r0, #20480	; 0x5000
     5c8:	0000480e 	andeq	r4, r0, lr, lsl #16
     5cc:	000e6800 	andeq	r6, lr, r0, lsl #16
     5d0:	05000006 	streq	r0, [r0, #-6]
     5d4:	00480e34 	subeq	r0, r8, r4, lsr lr
     5d8:	0e6c0000 	cdpeq	0, 6, cr0, cr12, cr0, {0}
     5dc:	00000713 	andeq	r0, r0, r3, lsl r7
     5e0:	480e3505 	stmdami	lr, {r0, r2, r8, sl, ip, sp}
     5e4:	70000000 	andvc	r0, r0, r0
     5e8:	00088a0e 	andeq	r8, r8, lr, lsl #20
     5ec:	0e360500 	cfabs32eq	mvfx0, mvfx6
     5f0:	00000048 	andeq	r0, r0, r8, asr #32
     5f4:	0b6c0e74 	bleq	1b03fcc <__bss_end+0x1afa3a4>
     5f8:	37050000 	strcc	r0, [r5, -r0]
     5fc:	0000480e 	andeq	r4, r0, lr, lsl #16
     600:	0f007800 	svceq	0x00007800
     604:	000001ba 			; <UNDEFINED> instruction: 0x000001ba
     608:	0000033f 	andeq	r0, r0, pc, lsr r3
     60c:	00005910 	andeq	r5, r0, r0, lsl r9
     610:	0a000f00 	beq	4218 <shift+0x4218>
     614:	00000b4d 	andeq	r0, r0, sp, asr #22
     618:	54140a06 	ldrpl	r0, [r4], #-2566	; 0xfffff5fa
     61c:	05000000 	streq	r0, [r0, #-0]
     620:	009b6803 	addseq	r6, fp, r3, lsl #16
     624:	07a60800 	streq	r0, [r6, r0, lsl #16]!
     628:	04050000 	streq	r0, [r5], #-0
     62c:	00000033 	andeq	r0, r0, r3, lsr r0
     630:	700c0d06 	andvc	r0, ip, r6, lsl #26
     634:	09000003 	stmdbeq	r0, {r0, r1}
     638:	00000443 	andeq	r0, r0, r3, asr #8
     63c:	03370900 	teqeq	r7, #0, 18
     640:	00010000 	andeq	r0, r1, r0
     644:	000a8a06 	andeq	r8, sl, r6, lsl #20
     648:	1b060c00 	blne	183650 <__bss_end+0x179a28>
     64c:	0003a508 	andeq	sl, r3, r8, lsl #10
     650:	03810e00 	orreq	r0, r1, #0, 28
     654:	1d060000 	stcne	0, cr0, [r6, #-0]
     658:	0003a519 	andeq	sl, r3, r9, lsl r5
     65c:	260e0000 	strcs	r0, [lr], -r0
     660:	06000004 	streq	r0, [r0], -r4
     664:	03a5191e 			; <UNDEFINED> instruction: 0x03a5191e
     668:	0e040000 	cdpeq	0, 0, cr0, cr4, cr0, {0}
     66c:	00000a45 	andeq	r0, r0, r5, asr #20
     670:	ab131f06 	blge	4c8290 <__bss_end+0x4be668>
     674:	08000003 	stmdaeq	r0, {r0, r1}
     678:	70040c00 	andvc	r0, r4, r0, lsl #24
     67c:	0c000003 	stceq	0, cr0, [r0], {3}
     680:	00027804 	andeq	r7, r2, r4, lsl #16
     684:	04ae1100 	strteq	r1, [lr], #256	; 0x100
     688:	06140000 	ldreq	r0, [r4], -r0
     68c:	06720722 	ldrbteq	r0, [r2], -r2, lsr #14
     690:	940e0000 	strls	r0, [lr], #-0
     694:	06000007 	streq	r0, [r0], -r7
     698:	00481226 	subeq	r1, r8, r6, lsr #4
     69c:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
     6a0:	000003e5 	andeq	r0, r0, r5, ror #7
     6a4:	a51d2906 	ldrge	r2, [sp, #-2310]	; 0xfffff6fa
     6a8:	04000003 	streq	r0, [r0], #-3
     6ac:	0009a80e 	andeq	sl, r9, lr, lsl #16
     6b0:	1d2c0600 	stcne	6, cr0, [ip, #-0]
     6b4:	000003a5 	andeq	r0, r0, r5, lsr #7
     6b8:	0b2b1208 	bleq	ac4ee0 <__bss_end+0xabb2b8>
     6bc:	2f060000 	svccs	0x00060000
     6c0:	000a670e 	andeq	r6, sl, lr, lsl #14
     6c4:	0003f900 	andeq	pc, r3, r0, lsl #18
     6c8:	00040400 	andeq	r0, r4, r0, lsl #8
     6cc:	06771300 	ldrbteq	r1, [r7], -r0, lsl #6
     6d0:	a5140000 	ldrge	r0, [r4, #-0]
     6d4:	00000003 	andeq	r0, r0, r3
     6d8:	000a4f15 	andeq	r4, sl, r5, lsl pc
     6dc:	0e310600 	cfmsuba32eq	mvax0, mvax0, mvfx1, mvfx0
     6e0:	00000386 	andeq	r0, r0, r6, lsl #7
     6e4:	000001b3 			; <UNDEFINED> instruction: 0x000001b3
     6e8:	0000041c 	andeq	r0, r0, ip, lsl r4
     6ec:	00000427 	andeq	r0, r0, r7, lsr #8
     6f0:	00067713 	andeq	r7, r6, r3, lsl r7
     6f4:	03ab1400 			; <UNDEFINED> instruction: 0x03ab1400
     6f8:	16000000 	strne	r0, [r0], -r0
     6fc:	00000a9d 	muleq	r0, sp, sl
     700:	201d3506 	andscs	r3, sp, r6, lsl #10
     704:	a500000a 	strge	r0, [r0, #-10]
     708:	02000003 	andeq	r0, r0, #3
     70c:	00000440 	andeq	r0, r0, r0, asr #8
     710:	00000446 	andeq	r0, r0, r6, asr #8
     714:	00067713 	andeq	r7, r6, r3, lsl r7
     718:	47160000 	ldrmi	r0, [r6, -r0]
     71c:	06000007 	streq	r0, [r0], -r7
     720:	093c1d37 	ldmdbeq	ip!, {r0, r1, r2, r4, r5, r8, sl, fp, ip}
     724:	03a50000 			; <UNDEFINED> instruction: 0x03a50000
     728:	5f020000 	svcpl	0x00020000
     72c:	65000004 	strvs	r0, [r0, #-4]
     730:	13000004 	movwne	r0, #4
     734:	00000677 	andeq	r0, r0, r7, ror r6
     738:	081b1700 	ldmdaeq	fp, {r8, r9, sl, ip}
     73c:	39060000 	stmdbcc	r6, {}	; <UNPREDICTABLE>
     740:	00069031 	andeq	r9, r6, r1, lsr r0
     744:	16020c00 	strne	r0, [r2], -r0, lsl #24
     748:	000004ae 	andeq	r0, r0, lr, lsr #9
     74c:	95093c06 	strls	r3, [r9, #-3078]	; 0xfffff3fa
     750:	7700000b 	strvc	r0, [r0, -fp]
     754:	01000006 	tsteq	r0, r6
     758:	0000048c 	andeq	r0, r0, ip, lsl #9
     75c:	00000492 	muleq	r0, r2, r4
     760:	00067713 	andeq	r7, r6, r3, lsl r7
     764:	4a160000 	bmi	58076c <__bss_end+0x576b44>
     768:	0600000a 	streq	r0, [r0], -sl
     76c:	07fe123d 			; <UNDEFINED> instruction: 0x07fe123d
     770:	00480000 	subeq	r0, r8, r0
     774:	ab010000 	blge	4077c <__bss_end+0x36b54>
     778:	b6000004 	strlt	r0, [r0], -r4
     77c:	13000004 	movwne	r0, #4
     780:	00000677 	andeq	r0, r0, r7, ror r6
     784:	00004814 	andeq	r4, r0, r4, lsl r8
     788:	58160000 	ldmdapl	r6, {}	; <UNPREDICTABLE>
     78c:	06000004 	streq	r0, [r0], -r4
     790:	0b00123f 	bleq	5094 <shift+0x5094>
     794:	00480000 	subeq	r0, r8, r0
     798:	cf010000 	svcgt	0x00010000
     79c:	e4000004 	str	r0, [r0], #-4
     7a0:	13000004 	movwne	r0, #4
     7a4:	00000677 	andeq	r0, r0, r7, ror r6
     7a8:	00069914 	andeq	r9, r6, r4, lsl r9
     7ac:	00591400 	subseq	r1, r9, r0, lsl #8
     7b0:	b3140000 	tstlt	r4, #0
     7b4:	00000001 	andeq	r0, r0, r1
     7b8:	00086318 	andeq	r6, r8, r8, lsl r3
     7bc:	0e410600 	cdpeq	6, 4, cr0, cr1, cr0, {0}
     7c0:	00000685 	andeq	r0, r0, r5, lsl #13
     7c4:	0004f901 	andeq	pc, r4, r1, lsl #18
     7c8:	0004ff00 	andeq	pc, r4, r0, lsl #30
     7cc:	06771300 	ldrbteq	r1, [r7], -r0, lsl #6
     7d0:	18000000 	stmdane	r0, {}	; <UNPREDICTABLE>
     7d4:	00000a5e 	andeq	r0, r0, lr, asr sl
     7d8:	ba0e4306 	blt	3913f8 <__bss_end+0x3877d0>
     7dc:	01000008 	tsteq	r0, r8
     7e0:	00000514 	andeq	r0, r0, r4, lsl r5
     7e4:	0000051a 	andeq	r0, r0, sl, lsl r5
     7e8:	00067713 	andeq	r7, r6, r3, lsl r7
     7ec:	b5160000 	ldrlt	r0, [r6, #-0]
     7f0:	06000006 	streq	r0, [r0], -r6
     7f4:	03f81746 	mvnseq	r1, #18350080	; 0x1180000
     7f8:	03ab0000 			; <UNDEFINED> instruction: 0x03ab0000
     7fc:	33010000 	movwcc	r0, #4096	; 0x1000
     800:	39000005 	stmdbcc	r0, {r0, r2}
     804:	13000005 	movwne	r0, #5
     808:	0000069f 	muleq	r0, pc, r6	; <UNPREDICTABLE>
     80c:	042b1600 	strteq	r1, [fp], #-1536	; 0xfffffa00
     810:	49060000 	stmdbmi	r6, {}	; <UNPREDICTABLE>
     814:	0009dd17 	andeq	sp, r9, r7, lsl sp
     818:	0003ab00 	andeq	sl, r3, r0, lsl #22
     81c:	05520100 	ldrbeq	r0, [r2, #-256]	; 0xffffff00
     820:	055d0000 	ldrbeq	r0, [sp, #-0]
     824:	9f130000 	svcls	0x00130000
     828:	14000006 	strne	r0, [r0], #-6
     82c:	00000048 	andeq	r0, r0, r8, asr #32
     830:	06dd1800 	ldrbeq	r1, [sp], r0, lsl #16
     834:	4c060000 	stcmi	0, cr0, [r6], {-0}
     838:	0003520e 	andeq	r5, r3, lr, lsl #4
     83c:	05720100 	ldrbeq	r0, [r2, #-256]!	; 0xffffff00
     840:	05780000 	ldrbeq	r0, [r8, #-0]!
     844:	77130000 	ldrvc	r0, [r3, -r0]
     848:	00000006 	andeq	r0, r0, r6
     84c:	000a4f16 	andeq	r4, sl, r6, lsl pc
     850:	0e4e0600 	cdpeq	6, 4, cr0, cr14, cr0, {0}
     854:	0000058d 	andeq	r0, r0, sp, lsl #11
     858:	000001b3 			; <UNDEFINED> instruction: 0x000001b3
     85c:	00059101 	andeq	r9, r5, r1, lsl #2
     860:	00059c00 	andeq	r9, r5, r0, lsl #24
     864:	06771300 	ldrbteq	r1, [r7], -r0, lsl #6
     868:	48140000 	ldmdami	r4, {}	; <UNPREDICTABLE>
     86c:	00000000 	andeq	r0, r0, r0
     870:	0006c916 	andeq	ip, r6, r6, lsl r9
     874:	12510600 	subsne	r0, r1, #0, 12
     878:	000008db 	ldrdeq	r0, [r0], -fp
     87c:	00000048 	andeq	r0, r0, r8, asr #32
     880:	0005b501 	andeq	fp, r5, r1, lsl #10
     884:	0005c000 	andeq	ip, r5, r0
     888:	06771300 	ldrbteq	r1, [r7], -r0, lsl #6
     88c:	ba140000 	blt	500894 <__bss_end+0x4f6c6c>
     890:	00000001 	andeq	r0, r0, r1
     894:	0003c116 	andeq	ip, r3, r6, lsl r1
     898:	0e540600 	cdpeq	6, 5, cr0, cr4, cr0, {0}
     89c:	0000064f 	andeq	r0, r0, pc, asr #12
     8a0:	000001b3 			; <UNDEFINED> instruction: 0x000001b3
     8a4:	0005d901 	andeq	sp, r5, r1, lsl #18
     8a8:	0005e400 	andeq	lr, r5, r0, lsl #8
     8ac:	06771300 	ldrbteq	r1, [r7], -r0, lsl #6
     8b0:	48140000 	ldmdami	r4, {}	; <UNPREDICTABLE>
     8b4:	00000000 	andeq	r0, r0, r0
     8b8:	00072118 	andeq	r2, r7, r8, lsl r1
     8bc:	0e570600 	cdpeq	6, 5, cr0, cr7, cr0, {0}
     8c0:	00000aa9 	andeq	r0, r0, r9, lsr #21
     8c4:	0005f901 	andeq	pc, r5, r1, lsl #18
     8c8:	00061800 	andeq	r1, r6, r0, lsl #16
     8cc:	06771300 	ldrbteq	r1, [r7], -r0, lsl #6
     8d0:	8b140000 	blhi	5008d8 <__bss_end+0x4f6cb0>
     8d4:	14000000 	strne	r0, [r0], #-0
     8d8:	00000048 	andeq	r0, r0, r8, asr #32
     8dc:	00004814 	andeq	r4, r0, r4, lsl r8
     8e0:	00481400 	subeq	r1, r8, r0, lsl #8
     8e4:	a5140000 	ldrge	r0, [r4, #-0]
     8e8:	00000006 	andeq	r0, r0, r6
     8ec:	000a0a18 	andeq	r0, sl, r8, lsl sl
     8f0:	0e590600 	cdpeq	6, 5, cr0, cr9, cr0, {0}
     8f4:	00000502 	andeq	r0, r0, r2, lsl #10
     8f8:	00062d01 	andeq	r2, r6, r1, lsl #26
     8fc:	00064c00 	andeq	r4, r6, r0, lsl #24
     900:	06771300 	ldrbteq	r1, [r7], -r0, lsl #6
     904:	ce140000 	cdpgt	0, 1, cr0, cr4, cr0, {0}
     908:	14000000 	strne	r0, [r0], #-0
     90c:	00000048 	andeq	r0, r0, r8, asr #32
     910:	00004814 	andeq	r4, r0, r4, lsl r8
     914:	00481400 	subeq	r1, r8, r0, lsl #8
     918:	a5140000 	ldrge	r0, [r4, #-0]
     91c:	00000006 	andeq	r0, r0, r6
     920:	00048819 	andeq	r8, r4, r9, lsl r8
     924:	0e5c0600 	cdpeq	6, 5, cr0, cr12, cr0, {0}
     928:	000004bf 			; <UNDEFINED> instruction: 0x000004bf
     92c:	000001b3 			; <UNDEFINED> instruction: 0x000001b3
     930:	00066101 	andeq	r6, r6, r1, lsl #2
     934:	06771300 	ldrbteq	r1, [r7], -r0, lsl #6
     938:	51140000 	tstpl	r4, r0
     93c:	14000003 	strne	r0, [r0], #-3
     940:	000006ab 	andeq	r0, r0, fp, lsr #13
     944:	b1050000 	mrslt	r0, (UNDEF: 5)
     948:	0c000003 	stceq	0, cr0, [r0], {3}
     94c:	0003b104 	andeq	fp, r3, r4, lsl #2
     950:	03a51a00 			; <UNDEFINED> instruction: 0x03a51a00
     954:	068a0000 	streq	r0, [sl], r0
     958:	06900000 	ldreq	r0, [r0], r0
     95c:	77130000 	ldrvc	r0, [r3, -r0]
     960:	00000006 	andeq	r0, r0, r6
     964:	0003b11b 	andeq	fp, r3, fp, lsl r1
     968:	00067d00 	andeq	r7, r6, r0, lsl #26
     96c:	3a040c00 	bcc	103974 <__bss_end+0xf9d4c>
     970:	0c000000 	stceq	0, cr0, [r0], {-0}
     974:	00067204 	andeq	r7, r6, r4, lsl #4
     978:	65041c00 	strvs	r1, [r4, #-3072]	; 0xfffff400
     97c:	1d000000 	stcne	0, cr0, [r0, #-0]
     980:	61681e04 	cmnvs	r8, r4, lsl #28
     984:	0507006c 	streq	r0, [r7, #-108]	; 0xffffff94
     988:	0007770b 	andeq	r7, r7, fp, lsl #14
     98c:	08501f00 	ldmdaeq	r0, {r8, r9, sl, fp, ip}^
     990:	07070000 	streq	r0, [r7, -r0]
     994:	00006019 	andeq	r6, r0, r9, lsl r0
     998:	e6b28000 	ldrt	r8, [r2], r0
     99c:	09871f0e 	stmibeq	r7, {r1, r2, r3, r8, r9, sl, fp, ip}
     9a0:	0a070000 	beq	1c09a8 <__bss_end+0x1b6d80>
     9a4:	0002731a 	andeq	r7, r2, sl, lsl r3
     9a8:	00000000 	andeq	r0, r0, r0
     9ac:	08291f20 	stmdaeq	r9!, {r5, r8, r9, sl, fp, ip}
     9b0:	0d070000 	stceq	0, cr0, [r7, #-0]
     9b4:	0002731a 	andeq	r7, r2, sl, lsl r3
     9b8:	20000000 	andcs	r0, r0, r0
     9bc:	09622020 	stmdbeq	r2!, {r5, sp}^
     9c0:	10070000 	andne	r0, r7, r0
     9c4:	00005415 	andeq	r5, r0, r5, lsl r4
     9c8:	7f1f3600 	svcvc	0x001f3600
     9cc:	07000004 	streq	r0, [r0, -r4]
     9d0:	02731a42 	rsbseq	r1, r3, #270336	; 0x42000
     9d4:	50000000 	andpl	r0, r0, r0
     9d8:	121f2021 	andsne	r2, pc, #33	; 0x21
     9dc:	07000006 	streq	r0, [r0, -r6]
     9e0:	02731a71 	rsbseq	r1, r3, #462848	; 0x71000
     9e4:	b2000000 	andlt	r0, r0, #0
     9e8:	311f2000 	tstcc	pc, r0
     9ec:	07000009 	streq	r0, [r0, -r9]
     9f0:	02731aa4 	rsbseq	r1, r3, #164, 20	; 0xa4000
     9f4:	b4000000 	strlt	r0, [r0], #-0
     9f8:	2a1f2000 	bcs	7c8a00 <__bss_end+0x7bedd8>
     9fc:	07000009 	streq	r0, [r0, -r9]
     a00:	02731db2 	rsbseq	r1, r3, #11392	; 0x2c80
     a04:	30000000 	andcc	r0, r0, r0
     a08:	7b1f2000 	blvc	7c8a10 <__bss_end+0x7bede8>
     a0c:	07000006 	streq	r0, [r0, -r6]
     a10:	02731dc0 	rsbseq	r1, r3, #192, 26	; 0x3000
     a14:	40000000 	andmi	r0, r0, r0
     a18:	bd1f2010 	ldclt	0, cr2, [pc, #-64]	; 9e0 <shift+0x9e0>
     a1c:	07000005 	streq	r0, [r0, -r5]
     a20:	02731acb 	rsbseq	r1, r3, #831488	; 0xcb000
     a24:	50000000 	andpl	r0, r0, r0
     a28:	2c1f2020 	ldccs	0, cr2, [pc], {32}
     a2c:	07000006 	streq	r0, [r0, -r6]
     a30:	02731acc 	rsbseq	r1, r3, #204, 20	; 0xcc000
     a34:	40000000 	andmi	r0, r0, r0
     a38:	d41f2080 	ldrle	r2, [pc], #-128	; a40 <shift+0xa40>
     a3c:	07000003 	streq	r0, [r0, -r3]
     a40:	02731acd 	rsbseq	r1, r3, #839680	; 0xcd000
     a44:	50000000 	andpl	r0, r0, r0
     a48:	21002080 	smlabbcs	r0, r0, r0, r2
     a4c:	000006b9 			; <UNDEFINED> instruction: 0x000006b9
     a50:	0006c921 	andeq	ip, r6, r1, lsr #18
     a54:	06d92100 	ldrbeq	r2, [r9], r0, lsl #2
     a58:	e9210000 	stmdb	r1!, {}	; <UNPREDICTABLE>
     a5c:	21000006 	tstcs	r0, r6
     a60:	000006f6 	strdeq	r0, [r0], -r6
     a64:	00070621 	andeq	r0, r7, r1, lsr #12
     a68:	07162100 	ldreq	r2, [r6, -r0, lsl #2]
     a6c:	26210000 	strtcs	r0, [r1], -r0
     a70:	21000007 	tstcs	r0, r7
     a74:	00000736 	andeq	r0, r0, r6, lsr r7
     a78:	00074621 	andeq	r4, r7, r1, lsr #12
     a7c:	07562100 	ldrbeq	r2, [r6, -r0, lsl #2]
     a80:	66210000 	strtvs	r0, [r1], -r0
     a84:	0a000007 	beq	aa8 <shift+0xaa8>
     a88:	0000097b 	andeq	r0, r0, fp, ror r9
     a8c:	54140808 	ldrpl	r0, [r4], #-2056	; 0xfffff7f8
     a90:	05000000 	streq	r0, [r0, #-0]
     a94:	009b9c03 	addseq	r9, fp, r3, lsl #24
     a98:	15332200 	ldrne	r2, [r3, #-512]!	; 0xfffffe00
     a9c:	10010000 	andne	r0, r1, r0
     aa0:	00003305 	andeq	r3, r0, r5, lsl #6
     aa4:	00822c00 	addeq	r2, r2, r0, lsl #24
     aa8:	00019400 	andeq	r9, r1, r0, lsl #8
     aac:	719c0100 	orrsvc	r0, ip, r0, lsl #2
     ab0:	23000008 	movwcs	r0, #8
     ab4:	00000b67 	andeq	r0, r0, r7, ror #22
     ab8:	330e1001 	movwcc	r1, #57345	; 0xe001
     abc:	02000000 	andeq	r0, r0, #0
     ac0:	fb235c91 	blx	8d7d0e <__bss_end+0x8ce0e6>
     ac4:	0100000a 	tsteq	r0, sl
     ac8:	08711b10 	ldmdaeq	r1!, {r4, r8, r9, fp, ip}^
     acc:	91020000 	mrsls	r0, (UNDEF: 2)
     ad0:	07822458 			; <UNDEFINED> instruction: 0x07822458
     ad4:	12010000 	andne	r0, r1, #0
     ad8:	0000480b 	andeq	r4, r0, fp, lsl #16
     adc:	70910200 	addsvc	r0, r1, r0, lsl #4
     ae0:	000b7724 	andeq	r7, fp, r4, lsr #14
     ae4:	0b130100 	bleq	4c0eec <__bss_end+0x4b72c4>
     ae8:	00000048 	andeq	r0, r0, r8, asr #32
     aec:	246c9102 	strbtcs	r9, [ip], #-258	; 0xfffffefe
     af0:	000006f3 	strdeq	r0, [r0], -r3
     af4:	480b1401 	stmdami	fp, {r0, sl, ip}
     af8:	02000000 	andeq	r0, r0, #0
     afc:	d6246891 			; <UNDEFINED> instruction: 0xd6246891
     b00:	01000007 	tsteq	r0, r7
     b04:	00590f16 	subseq	r0, r9, r6, lsl pc
     b08:	91020000 	mrsls	r0, (UNDEF: 2)
     b0c:	03bc2474 			; <UNDEFINED> instruction: 0x03bc2474
     b10:	17010000 	strne	r0, [r1, -r0]
     b14:	0001b307 	andeq	fp, r1, r7, lsl #6
     b18:	67910200 	ldrvs	r0, [r1, r0, lsl #4]
     b1c:	0006ab24 	andeq	sl, r6, r4, lsr #22
     b20:	07180100 	ldreq	r0, [r8, -r0, lsl #2]
     b24:	000001b3 			; <UNDEFINED> instruction: 0x000001b3
     b28:	25669102 	strbcs	r9, [r6, #-258]!	; 0xfffffefe
     b2c:	000082a8 	andeq	r8, r0, r8, lsr #5
     b30:	00000104 	andeq	r0, r0, r4, lsl #2
     b34:	706d7426 	rsbvc	r7, sp, r6, lsr #8
     b38:	081e0100 	ldmdaeq	lr, {r8}
     b3c:	00000025 	andeq	r0, r0, r5, lsr #32
     b40:	00659102 	rsbeq	r9, r5, r2, lsl #2
     b44:	77040c00 	strvc	r0, [r4, -r0, lsl #24]
     b48:	0c000008 	stceq	0, cr0, [r0], {8}
     b4c:	00002504 	andeq	r2, r0, r4, lsl #10
     b50:	0b910000 	bleq	fe440b58 <__bss_end+0xfe436f30>
     b54:	00040000 	andeq	r0, r4, r0
     b58:	00000420 	andeq	r0, r0, r0, lsr #8
     b5c:	0cef0104 	stfeqe	f0, [pc], #16	; b74 <shift+0xb74>
     b60:	a5040000 	strge	r0, [r4, #-0]
     b64:	1900000e 	stmdbne	r0, {r1, r2, r3}
     b68:	c000000e 	andgt	r0, r0, lr
     b6c:	5c000083 	stcpl	0, cr0, [r0], {131}	; 0x83
     b70:	03000004 	movweq	r0, #4
     b74:	02000004 	andeq	r0, r0, #4
     b78:	09250801 	stmdbeq	r5!, {r0, fp}
     b7c:	25030000 	strcs	r0, [r3, #-0]
     b80:	02000000 	andeq	r0, r0, #0
     b84:	09710502 	ldmdbeq	r1!, {r1, r8, sl}^
     b88:	04040000 	streq	r0, [r4], #-0
     b8c:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
     b90:	08010200 	stmdaeq	r1, {r9}
     b94:	0000091c 	andeq	r0, r0, ip, lsl r9
     b98:	34070202 	strcc	r0, [r7], #-514	; 0xfffffdfe
     b9c:	05000007 	streq	r0, [r0, #-7]
     ba0:	0000099f 	muleq	r0, pc, r9	; <UNPREDICTABLE>
     ba4:	5e070907 	vmlapl.f16	s0, s14, s14	; <UNPREDICTABLE>
     ba8:	03000000 	movweq	r0, #0
     bac:	0000004d 	andeq	r0, r0, sp, asr #32
     bb0:	9f070402 	svcls	0x00070402
     bb4:	06000015 			; <UNDEFINED> instruction: 0x06000015
     bb8:	0000054e 	andeq	r0, r0, lr, asr #10
     bbc:	08060208 	stmdaeq	r6, {r3, r9}
     bc0:	0000008b 	andeq	r0, r0, fp, lsl #1
     bc4:	00307207 	eorseq	r7, r0, r7, lsl #4
     bc8:	4d0e0802 	stcmi	8, cr0, [lr, #-8]
     bcc:	00000000 	andeq	r0, r0, r0
     bd0:	00317207 	eorseq	r7, r1, r7, lsl #4
     bd4:	4d0e0902 	vstrmi.16	s0, [lr, #-4]	; <UNPREDICTABLE>
     bd8:	04000000 	streq	r0, [r0], #-0
     bdc:	0ed50800 	cdpeq	8, 13, cr0, cr5, cr0, {0}
     be0:	04050000 	streq	r0, [r5], #-0
     be4:	00000038 	andeq	r0, r0, r8, lsr r0
     be8:	a90c0d02 	stmdbge	ip, {r1, r8, sl, fp}
     bec:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
     bf0:	00004b4f 	andeq	r4, r0, pc, asr #22
     bf4:	000c220a 	andeq	r2, ip, sl, lsl #4
     bf8:	08000100 	stmdaeq	r0, {r8}
     bfc:	0000076d 	andeq	r0, r0, sp, ror #14
     c00:	00380405 	eorseq	r0, r8, r5, lsl #8
     c04:	1e020000 	cdpne	0, 0, cr0, cr2, cr0, {0}
     c08:	0000ec0c 	andeq	lr, r0, ip, lsl #24
     c0c:	05b50a00 	ldreq	r0, [r5, #2560]!	; 0xa00
     c10:	0a000000 	beq	c18 <shift+0xc18>
     c14:	00000baf 	andeq	r0, r0, pc, lsr #23
     c18:	0b8f0a01 	bleq	fe3c3424 <__bss_end+0xfe3b97fc>
     c1c:	0a020000 	beq	80c24 <__bss_end+0x76ffc>
     c20:	00000767 	andeq	r0, r0, r7, ror #14
     c24:	08ab0a03 	stmiaeq	fp!, {r0, r1, r9, fp}
     c28:	0a040000 	beq	100c30 <__bss_end+0xf7008>
     c2c:	0000057e 	andeq	r0, r0, lr, ror r5
     c30:	03de0a05 	bicseq	r0, lr, #20480	; 0x5000
     c34:	0a060000 	beq	180c3c <__bss_end+0x177014>
     c38:	00000b5c 	andeq	r0, r0, ip, asr fp
     c3c:	35080007 	strcc	r0, [r8, #-7]
     c40:	0500000b 	streq	r0, [r0, #-11]
     c44:	00003804 	andeq	r3, r0, r4, lsl #16
     c48:	0c490200 	sfmeq	f0, 2, [r9], {-0}
     c4c:	00000129 	andeq	r0, r0, r9, lsr #2
     c50:	00034d0a 	andeq	r4, r3, sl, lsl #26
     c54:	3e0a0000 	cdpcc	0, 0, cr0, cr10, cr0, {0}
     c58:	01000004 	tsteq	r0, r4
     c5c:	00089e0a 	andeq	r9, r8, sl, lsl #28
     c60:	610a0200 	mrsvs	r0, R10_fiq
     c64:	0300000b 	movweq	r0, #11
     c68:	000bb90a 	andeq	fp, fp, sl, lsl #18
     c6c:	490a0400 	stmdbmi	sl, {sl}
     c70:	05000008 	streq	r0, [r0, #-8]
     c74:	0007540a 	andeq	r5, r7, sl, lsl #8
     c78:	08000600 	stmdaeq	r0, {r9, sl}
     c7c:	00000f4b 	andeq	r0, r0, fp, asr #30
     c80:	00380405 	eorseq	r0, r8, r5, lsl #8
     c84:	70020000 	andvc	r0, r2, r0
     c88:	0001540c 	andeq	r5, r1, ip, lsl #8
     c8c:	0e4a0a00 	vmlaeq.f32	s1, s20, s0
     c90:	0a000000 	beq	c98 <shift+0xc98>
     c94:	00000c7f 	andeq	r0, r0, pc, ror ip
     c98:	0e6e0a01 	vmuleq.f32	s1, s28, s2
     c9c:	0a020000 	beq	80ca4 <__bss_end+0x7707c>
     ca0:	00000ca4 	andeq	r0, r0, r4, lsr #25
     ca4:	700b0003 	andvc	r0, fp, r3
     ca8:	03000008 	movweq	r0, #8
     cac:	00591405 	subseq	r1, r9, r5, lsl #8
     cb0:	03050000 	movweq	r0, #20480	; 0x5000
     cb4:	00009bc4 	andeq	r9, r0, r4, asr #23
     cb8:	00087e0b 	andeq	r7, r8, fp, lsl #28
     cbc:	14060300 	strne	r0, [r6], #-768	; 0xfffffd00
     cc0:	00000059 	andeq	r0, r0, r9, asr r0
     cc4:	9bc80305 	blls	ff2018e0 <__bss_end+0xff1f7cb8>
     cc8:	330b0000 	movwcc	r0, #45056	; 0xb000
     ccc:	04000008 	streq	r0, [r0], #-8
     cd0:	00591a07 	subseq	r1, r9, r7, lsl #20
     cd4:	03050000 	movweq	r0, #20480	; 0x5000
     cd8:	00009bcc 	andeq	r9, r0, ip, asr #23
     cdc:	00046d0b 	andeq	r6, r4, fp, lsl #26
     ce0:	1a090400 	bne	241ce8 <__bss_end+0x2380c0>
     ce4:	00000059 	andeq	r0, r0, r9, asr r0
     ce8:	9bd00305 	blls	ff401904 <__bss_end+0xff3f7cdc>
     cec:	0e0b0000 	cdpeq	0, 0, cr0, cr11, cr0, {0}
     cf0:	04000009 	streq	r0, [r0], #-9
     cf4:	00591a0b 	subseq	r1, r9, fp, lsl #20
     cf8:	03050000 	movweq	r0, #20480	; 0x5000
     cfc:	00009bd4 	ldrdeq	r9, [r0], -r4
     d00:	0007000b 	andeq	r0, r7, fp
     d04:	1a0d0400 	bne	341d0c <__bss_end+0x3380e4>
     d08:	00000059 	andeq	r0, r0, r9, asr r0
     d0c:	9bd80305 	blls	ff601928 <__bss_end+0xff5f7d00>
     d10:	670b0000 	strvs	r0, [fp, -r0]
     d14:	04000005 	streq	r0, [r0], #-5
     d18:	00591a0f 	subseq	r1, r9, pc, lsl #20
     d1c:	03050000 	movweq	r0, #20480	; 0x5000
     d20:	00009bdc 	ldrdeq	r9, [r0], -ip
     d24:	000f9e08 	andeq	r9, pc, r8, lsl #28
     d28:	38040500 	stmdacc	r4, {r8, sl}
     d2c:	04000000 	streq	r0, [r0], #-0
     d30:	01f70c1b 	mvnseq	r0, fp, lsl ip
     d34:	c70a0000 	strgt	r0, [sl, -r0]
     d38:	00000009 	andeq	r0, r0, r9
     d3c:	000b840a 	andeq	r8, fp, sl, lsl #8
     d40:	990a0100 	stmdbls	sl, {r8}
     d44:	02000008 	andeq	r0, r0, #8
     d48:	09080c00 	stmdbeq	r8, {sl, fp}
     d4c:	01020000 	mrseq	r0, (UNDEF: 2)
     d50:	00078f02 	andeq	r8, r7, r2, lsl #30
     d54:	2c040d00 	stccs	13, cr0, [r4], {-0}
     d58:	0d000000 	stceq	0, cr0, [r0, #-0]
     d5c:	0001f704 	andeq	pc, r1, r4, lsl #14
     d60:	06360b00 	ldrteq	r0, [r6], -r0, lsl #22
     d64:	04050000 	streq	r0, [r5], #-0
     d68:	00005914 	andeq	r5, r0, r4, lsl r9
     d6c:	e0030500 	and	r0, r3, r0, lsl #10
     d70:	0b00009b 	bleq	fe4 <shift+0xfe4>
     d74:	00000342 	andeq	r0, r0, r2, asr #6
     d78:	59140705 	ldmdbpl	r4, {r0, r2, r8, r9, sl}
     d7c:	05000000 	streq	r0, [r0, #-0]
     d80:	009be403 	addseq	lr, fp, r3, lsl #8
     d84:	049b0b00 	ldreq	r0, [fp], #2816	; 0xb00
     d88:	0a050000 	beq	140d90 <__bss_end+0x137168>
     d8c:	00005914 	andeq	r5, r0, r4, lsl r9
     d90:	e8030500 	stmda	r3, {r8, sl}
     d94:	0800009b 	stmdaeq	r0, {r0, r1, r3, r4, r7}
     d98:	000007c4 	andeq	r0, r0, r4, asr #15
     d9c:	00380405 	eorseq	r0, r8, r5, lsl #8
     da0:	0d050000 	stceq	0, cr0, [r5, #-0]
     da4:	00027c0c 	andeq	r7, r2, ip, lsl #24
     da8:	654e0900 	strbvs	r0, [lr, #-2304]	; 0xfffff700
     dac:	0a000077 	beq	f90 <shift+0xf90>
     db0:	000007bb 			; <UNDEFINED> instruction: 0x000007bb
     db4:	09970a01 	ldmibeq	r7, {r0, r9, fp}
     db8:	0a020000 	beq	80dc0 <__bss_end+0x77198>
     dbc:	0000079e 	muleq	r0, lr, r7
     dc0:	07590a03 	ldrbeq	r0, [r9, -r3, lsl #20]
     dc4:	0a040000 	beq	100dcc <__bss_end+0xf71a4>
     dc8:	000008a4 	andeq	r0, r0, r4, lsr #17
     dcc:	71060005 	tstvc	r6, r5
     dd0:	10000005 	andne	r0, r0, r5
     dd4:	bb081b05 	bllt	2079f0 <__bss_end+0x1fddc8>
     dd8:	07000002 	streq	r0, [r0, -r2]
     ddc:	0500726c 	streq	r7, [r0, #-620]	; 0xfffffd94
     de0:	02bb131d 	adcseq	r1, fp, #1946157056	; 0x74000000
     de4:	07000000 	streq	r0, [r0, -r0]
     de8:	05007073 	streq	r7, [r0, #-115]	; 0xffffff8d
     dec:	02bb131e 	adcseq	r1, fp, #2013265920	; 0x78000000
     df0:	07040000 	streq	r0, [r4, -r0]
     df4:	05006370 	streq	r6, [r0, #-880]	; 0xfffffc90
     df8:	02bb131f 	adcseq	r1, fp, #2080374784	; 0x7c000000
     dfc:	0e080000 	cdpeq	0, 0, cr0, cr8, cr0, {0}
     e00:	00000587 	andeq	r0, r0, r7, lsl #11
     e04:	bb132005 	bllt	4c8e20 <__bss_end+0x4bf1f8>
     e08:	0c000002 	stceq	0, cr0, [r0], {2}
     e0c:	07040200 	streq	r0, [r4, -r0, lsl #4]
     e10:	0000159a 	muleq	r0, sl, r5
     e14:	0003af06 	andeq	sl, r3, r6, lsl #30
     e18:	28057c00 	stmdacs	r5, {sl, fp, ip, sp, lr}
     e1c:	00037908 	andeq	r7, r3, r8, lsl #18
     e20:	09bb0e00 	ldmibeq	fp!, {r9, sl, fp}
     e24:	2a050000 	bcs	140e2c <__bss_end+0x137204>
     e28:	00027c12 	andeq	r7, r2, r2, lsl ip
     e2c:	70070000 	andvc	r0, r7, r0
     e30:	05006469 	streq	r6, [r0, #-1129]	; 0xfffffb97
     e34:	005e122b 	subseq	r1, lr, fp, lsr #4
     e38:	0e100000 	cdpeq	0, 1, cr0, cr0, cr0, {0}
     e3c:	00000467 	andeq	r0, r0, r7, ror #8
     e40:	45112c05 	ldrmi	r2, [r1, #-3077]	; 0xfffff3fb
     e44:	14000002 	strne	r0, [r0], #-2
     e48:	0007d00e 	andeq	sp, r7, lr
     e4c:	122d0500 	eorne	r0, sp, #0, 10
     e50:	0000005e 	andeq	r0, r0, lr, asr r0
     e54:	07de0e18 	bfieq	r0, r8, #28, #3
     e58:	2e050000 	cdpcs	0, 0, cr0, cr5, cr0, {0}
     e5c:	00005e12 	andeq	r5, r0, r2, lsl lr
     e60:	5a0e1c00 	bpl	387e68 <__bss_end+0x37e240>
     e64:	05000005 	streq	r0, [r0, #-5]
     e68:	03790c2f 	cmneq	r9, #12032	; 0x2f00
     e6c:	0e200000 	cdpeq	0, 2, cr0, cr0, cr0, {0}
     e70:	000007f4 	strdeq	r0, [r0], -r4
     e74:	38093005 	stmdacc	r9, {r0, r2, ip, sp}
     e78:	60000000 	andvs	r0, r0, r0
     e7c:	0009d10e 	andeq	sp, r9, lr, lsl #2
     e80:	0e310500 	cfabs32eq	mvfx0, mvfx1
     e84:	0000004d 	andeq	r0, r0, sp, asr #32
     e88:	06090e64 	streq	r0, [r9], -r4, ror #28
     e8c:	33050000 	movwcc	r0, #20480	; 0x5000
     e90:	00004d0e 	andeq	r4, r0, lr, lsl #26
     e94:	000e6800 	andeq	r6, lr, r0, lsl #16
     e98:	05000006 	streq	r0, [r0, #-6]
     e9c:	004d0e34 	subeq	r0, sp, r4, lsr lr
     ea0:	0e6c0000 	cdpeq	0, 6, cr0, cr12, cr0, {0}
     ea4:	00000713 	andeq	r0, r0, r3, lsl r7
     ea8:	4d0e3505 	cfstr32mi	mvfx3, [lr, #-20]	; 0xffffffec
     eac:	70000000 	andvc	r0, r0, r0
     eb0:	00088a0e 	andeq	r8, r8, lr, lsl #20
     eb4:	0e360500 	cfabs32eq	mvfx0, mvfx6
     eb8:	0000004d 	andeq	r0, r0, sp, asr #32
     ebc:	0b6c0e74 	bleq	1b04894 <__bss_end+0x1afac6c>
     ec0:	37050000 	strcc	r0, [r5, -r0]
     ec4:	00004d0e 	andeq	r4, r0, lr, lsl #26
     ec8:	0f007800 	svceq	0x00007800
     ecc:	00000209 	andeq	r0, r0, r9, lsl #4
     ed0:	00000389 	andeq	r0, r0, r9, lsl #7
     ed4:	00005e10 	andeq	r5, r0, r0, lsl lr
     ed8:	0b000f00 	bleq	4ae0 <shift+0x4ae0>
     edc:	00000b4d 	andeq	r0, r0, sp, asr #22
     ee0:	59140a06 	ldmdbpl	r4, {r1, r2, r9, fp}
     ee4:	05000000 	streq	r0, [r0, #-0]
     ee8:	009bec03 	addseq	lr, fp, r3, lsl #24
     eec:	07a60800 	streq	r0, [r6, r0, lsl #16]!
     ef0:	04050000 	streq	r0, [r5], #-0
     ef4:	00000038 	andeq	r0, r0, r8, lsr r0
     ef8:	ba0c0d06 	blt	304318 <__bss_end+0x2fa6f0>
     efc:	0a000003 	beq	f10 <shift+0xf10>
     f00:	00000443 	andeq	r0, r0, r3, asr #8
     f04:	03370a00 	teqeq	r7, #0, 20
     f08:	00010000 	andeq	r0, r1, r0
     f0c:	00039b03 	andeq	r9, r3, r3, lsl #22
     f10:	0dbd0800 	ldceq	8, cr0, [sp]
     f14:	04050000 	streq	r0, [r5], #-0
     f18:	00000038 	andeq	r0, r0, r8, lsr r0
     f1c:	de0c1406 	cdple	4, 0, cr1, cr12, cr6, {0}
     f20:	0a000003 	beq	f34 <shift+0xf34>
     f24:	00000bc5 	andeq	r0, r0, r5, asr #23
     f28:	0e600a00 	vmuleq.f32	s1, s0, s0
     f2c:	00010000 	andeq	r0, r1, r0
     f30:	0003bf03 	andeq	fp, r3, r3, lsl #30
     f34:	0a8a0600 	beq	fe28273c <__bss_end+0xfe278b14>
     f38:	060c0000 	streq	r0, [ip], -r0
     f3c:	0418081b 	ldreq	r0, [r8], #-2075	; 0xfffff7e5
     f40:	810e0000 	mrshi	r0, (UNDEF: 14)
     f44:	06000003 	streq	r0, [r0], -r3
     f48:	0418191d 	ldreq	r1, [r8], #-2333	; 0xfffff6e3
     f4c:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
     f50:	00000426 	andeq	r0, r0, r6, lsr #8
     f54:	18191e06 	ldmdane	r9, {r1, r2, r9, sl, fp, ip}
     f58:	04000004 	streq	r0, [r0], #-4
     f5c:	000a450e 	andeq	r4, sl, lr, lsl #10
     f60:	131f0600 	tstne	pc, #0, 12
     f64:	0000041e 	andeq	r0, r0, lr, lsl r4
     f68:	040d0008 	streq	r0, [sp], #-8
     f6c:	000003e3 	andeq	r0, r0, r3, ror #7
     f70:	02c2040d 	sbceq	r0, r2, #218103808	; 0xd000000
     f74:	ae110000 	cdpge	0, 1, cr0, cr1, cr0, {0}
     f78:	14000004 	strne	r0, [r0], #-4
     f7c:	e5072206 	str	r2, [r7, #-518]	; 0xfffffdfa
     f80:	0e000006 	cdpeq	0, 0, cr0, cr0, cr6, {0}
     f84:	00000794 	muleq	r0, r4, r7
     f88:	4d122606 	ldcmi	6, cr2, [r2, #-24]	; 0xffffffe8
     f8c:	00000000 	andeq	r0, r0, r0
     f90:	0003e50e 	andeq	lr, r3, lr, lsl #10
     f94:	1d290600 	stcne	6, cr0, [r9, #-0]
     f98:	00000418 	andeq	r0, r0, r8, lsl r4
     f9c:	09a80e04 	stmibeq	r8!, {r2, r9, sl, fp}
     fa0:	2c060000 	stccs	0, cr0, [r6], {-0}
     fa4:	0004181d 	andeq	r1, r4, sp, lsl r8
     fa8:	2b120800 	blcs	482fb0 <__bss_end+0x479388>
     fac:	0600000b 	streq	r0, [r0], -fp
     fb0:	0a670e2f 	beq	19c4874 <__bss_end+0x19bac4c>
     fb4:	046c0000 	strbteq	r0, [ip], #-0
     fb8:	04770000 	ldrbteq	r0, [r7], #-0
     fbc:	ea130000 	b	4c0fc4 <__bss_end+0x4b739c>
     fc0:	14000006 	strne	r0, [r0], #-6
     fc4:	00000418 	andeq	r0, r0, r8, lsl r4
     fc8:	0a4f1500 	beq	13c63d0 <__bss_end+0x13bc7a8>
     fcc:	31060000 	mrscc	r0, (UNDEF: 6)
     fd0:	0003860e 	andeq	r8, r3, lr, lsl #12
     fd4:	0001fc00 	andeq	pc, r1, r0, lsl #24
     fd8:	00048f00 	andeq	r8, r4, r0, lsl #30
     fdc:	00049a00 	andeq	r9, r4, r0, lsl #20
     fe0:	06ea1300 	strbteq	r1, [sl], r0, lsl #6
     fe4:	1e140000 	cdpne	0, 1, cr0, cr4, cr0, {0}
     fe8:	00000004 	andeq	r0, r0, r4
     fec:	000a9d16 	andeq	r9, sl, r6, lsl sp
     ff0:	1d350600 	ldcne	6, cr0, [r5, #-0]
     ff4:	00000a20 	andeq	r0, r0, r0, lsr #20
     ff8:	00000418 	andeq	r0, r0, r8, lsl r4
     ffc:	0004b302 	andeq	fp, r4, r2, lsl #6
    1000:	0004b900 	andeq	fp, r4, r0, lsl #18
    1004:	06ea1300 	strbteq	r1, [sl], r0, lsl #6
    1008:	16000000 	strne	r0, [r0], -r0
    100c:	00000747 	andeq	r0, r0, r7, asr #14
    1010:	3c1d3706 	ldccc	7, cr3, [sp], {6}
    1014:	18000009 	stmdane	r0, {r0, r3}
    1018:	02000004 	andeq	r0, r0, #4
    101c:	000004d2 	ldrdeq	r0, [r0], -r2
    1020:	000004d8 	ldrdeq	r0, [r0], -r8
    1024:	0006ea13 	andeq	lr, r6, r3, lsl sl
    1028:	1b170000 	blne	5c1030 <__bss_end+0x5b7408>
    102c:	06000008 	streq	r0, [r0], -r8
    1030:	07033139 	smladxeq	r3, r9, r1, r3
    1034:	020c0000 	andeq	r0, ip, #0
    1038:	0004ae16 	andeq	sl, r4, r6, lsl lr
    103c:	093c0600 	ldmdbeq	ip!, {r9, sl}
    1040:	00000b95 	muleq	r0, r5, fp
    1044:	000006ea 	andeq	r0, r0, sl, ror #13
    1048:	0004ff01 	andeq	pc, r4, r1, lsl #30
    104c:	00050500 	andeq	r0, r5, r0, lsl #10
    1050:	06ea1300 	strbteq	r1, [sl], r0, lsl #6
    1054:	16000000 	strne	r0, [r0], -r0
    1058:	00000a4a 	andeq	r0, r0, sl, asr #20
    105c:	fe123d06 	cdp2	13, 1, cr3, cr2, cr6, {0}
    1060:	4d000007 	stcmi	0, cr0, [r0, #-28]	; 0xffffffe4
    1064:	01000000 	mrseq	r0, (UNDEF: 0)
    1068:	0000051e 	andeq	r0, r0, lr, lsl r5
    106c:	00000529 	andeq	r0, r0, r9, lsr #10
    1070:	0006ea13 	andeq	lr, r6, r3, lsl sl
    1074:	004d1400 	subeq	r1, sp, r0, lsl #8
    1078:	16000000 	strne	r0, [r0], -r0
    107c:	00000458 	andeq	r0, r0, r8, asr r4
    1080:	00123f06 	andseq	r3, r2, r6, lsl #30
    1084:	4d00000b 	stcmi	0, cr0, [r0, #-44]	; 0xffffffd4
    1088:	01000000 	mrseq	r0, (UNDEF: 0)
    108c:	00000542 	andeq	r0, r0, r2, asr #10
    1090:	00000557 	andeq	r0, r0, r7, asr r5
    1094:	0006ea13 	andeq	lr, r6, r3, lsl sl
    1098:	070c1400 	streq	r1, [ip, -r0, lsl #8]
    109c:	5e140000 	cdppl	0, 1, cr0, cr4, cr0, {0}
    10a0:	14000000 	strne	r0, [r0], #-0
    10a4:	000001fc 	strdeq	r0, [r0], -ip
    10a8:	08631800 	stmdaeq	r3!, {fp, ip}^
    10ac:	41060000 	mrsmi	r0, (UNDEF: 6)
    10b0:	0006850e 	andeq	r8, r6, lr, lsl #10
    10b4:	056c0100 	strbeq	r0, [ip, #-256]!	; 0xffffff00
    10b8:	05720000 	ldrbeq	r0, [r2, #-0]!
    10bc:	ea130000 	b	4c10c4 <__bss_end+0x4b749c>
    10c0:	00000006 	andeq	r0, r0, r6
    10c4:	000a5e18 	andeq	r5, sl, r8, lsl lr
    10c8:	0e430600 	cdpeq	6, 4, cr0, cr3, cr0, {0}
    10cc:	000008ba 			; <UNDEFINED> instruction: 0x000008ba
    10d0:	00058701 	andeq	r8, r5, r1, lsl #14
    10d4:	00058d00 	andeq	r8, r5, r0, lsl #26
    10d8:	06ea1300 	strbteq	r1, [sl], r0, lsl #6
    10dc:	16000000 	strne	r0, [r0], -r0
    10e0:	000006b5 			; <UNDEFINED> instruction: 0x000006b5
    10e4:	f8174606 			; <UNDEFINED> instruction: 0xf8174606
    10e8:	1e000003 	cdpne	0, 0, cr0, cr0, cr3, {0}
    10ec:	01000004 	tsteq	r0, r4
    10f0:	000005a6 	andeq	r0, r0, r6, lsr #11
    10f4:	000005ac 	andeq	r0, r0, ip, lsr #11
    10f8:	00071213 	andeq	r1, r7, r3, lsl r2
    10fc:	2b160000 	blcs	581104 <__bss_end+0x5774dc>
    1100:	06000004 	streq	r0, [r0], -r4
    1104:	09dd1749 	ldmibeq	sp, {r0, r3, r6, r8, r9, sl, ip}^
    1108:	041e0000 	ldreq	r0, [lr], #-0
    110c:	c5010000 	strgt	r0, [r1, #-0]
    1110:	d0000005 	andle	r0, r0, r5
    1114:	13000005 	movwne	r0, #5
    1118:	00000712 	andeq	r0, r0, r2, lsl r7
    111c:	00004d14 	andeq	r4, r0, r4, lsl sp
    1120:	dd180000 	ldcle	0, cr0, [r8, #-0]
    1124:	06000006 	streq	r0, [r0], -r6
    1128:	03520e4c 	cmpeq	r2, #76, 28	; 0x4c0
    112c:	e5010000 	str	r0, [r1, #-0]
    1130:	eb000005 	bl	114c <shift+0x114c>
    1134:	13000005 	movwne	r0, #5
    1138:	000006ea 	andeq	r0, r0, sl, ror #13
    113c:	0a4f1600 	beq	13c6944 <__bss_end+0x13bcd1c>
    1140:	4e060000 	cdpmi	0, 0, cr0, cr6, cr0, {0}
    1144:	00058d0e 	andeq	r8, r5, lr, lsl #26
    1148:	0001fc00 	andeq	pc, r1, r0, lsl #24
    114c:	06040100 	streq	r0, [r4], -r0, lsl #2
    1150:	060f0000 	streq	r0, [pc], -r0
    1154:	ea130000 	b	4c115c <__bss_end+0x4b7534>
    1158:	14000006 	strne	r0, [r0], #-6
    115c:	0000004d 	andeq	r0, r0, sp, asr #32
    1160:	06c91600 	strbeq	r1, [r9], r0, lsl #12
    1164:	51060000 	mrspl	r0, (UNDEF: 6)
    1168:	0008db12 	andeq	sp, r8, r2, lsl fp
    116c:	00004d00 	andeq	r4, r0, r0, lsl #26
    1170:	06280100 	strteq	r0, [r8], -r0, lsl #2
    1174:	06330000 	ldrteq	r0, [r3], -r0
    1178:	ea130000 	b	4c1180 <__bss_end+0x4b7558>
    117c:	14000006 	strne	r0, [r0], #-6
    1180:	00000209 	andeq	r0, r0, r9, lsl #4
    1184:	03c11600 	biceq	r1, r1, #0, 12
    1188:	54060000 	strpl	r0, [r6], #-0
    118c:	00064f0e 	andeq	r4, r6, lr, lsl #30
    1190:	0001fc00 	andeq	pc, r1, r0, lsl #24
    1194:	064c0100 	strbeq	r0, [ip], -r0, lsl #2
    1198:	06570000 	ldrbeq	r0, [r7], -r0
    119c:	ea130000 	b	4c11a4 <__bss_end+0x4b757c>
    11a0:	14000006 	strne	r0, [r0], #-6
    11a4:	0000004d 	andeq	r0, r0, sp, asr #32
    11a8:	07211800 	streq	r1, [r1, -r0, lsl #16]!
    11ac:	57060000 	strpl	r0, [r6, -r0]
    11b0:	000aa90e 	andeq	sl, sl, lr, lsl #18
    11b4:	066c0100 	strbteq	r0, [ip], -r0, lsl #2
    11b8:	068b0000 	streq	r0, [fp], r0
    11bc:	ea130000 	b	4c11c4 <__bss_end+0x4b759c>
    11c0:	14000006 	strne	r0, [r0], #-6
    11c4:	000000a9 	andeq	r0, r0, r9, lsr #1
    11c8:	00004d14 	andeq	r4, r0, r4, lsl sp
    11cc:	004d1400 	subeq	r1, sp, r0, lsl #8
    11d0:	4d140000 	ldcmi	0, cr0, [r4, #-0]
    11d4:	14000000 	strne	r0, [r0], #-0
    11d8:	00000718 	andeq	r0, r0, r8, lsl r7
    11dc:	0a0a1800 	beq	2871e4 <__bss_end+0x27d5bc>
    11e0:	59060000 	stmdbpl	r6, {}	; <UNPREDICTABLE>
    11e4:	0005020e 	andeq	r0, r5, lr, lsl #4
    11e8:	06a00100 	strteq	r0, [r0], r0, lsl #2
    11ec:	06bf0000 	ldrteq	r0, [pc], r0
    11f0:	ea130000 	b	4c11f8 <__bss_end+0x4b75d0>
    11f4:	14000006 	strne	r0, [r0], #-6
    11f8:	000000ec 	andeq	r0, r0, ip, ror #1
    11fc:	00004d14 	andeq	r4, r0, r4, lsl sp
    1200:	004d1400 	subeq	r1, sp, r0, lsl #8
    1204:	4d140000 	ldcmi	0, cr0, [r4, #-0]
    1208:	14000000 	strne	r0, [r0], #-0
    120c:	00000718 	andeq	r0, r0, r8, lsl r7
    1210:	04881900 	streq	r1, [r8], #2304	; 0x900
    1214:	5c060000 	stcpl	0, cr0, [r6], {-0}
    1218:	0004bf0e 	andeq	fp, r4, lr, lsl #30
    121c:	0001fc00 	andeq	pc, r1, r0, lsl #24
    1220:	06d40100 	ldrbeq	r0, [r4], r0, lsl #2
    1224:	ea130000 	b	4c122c <__bss_end+0x4b7604>
    1228:	14000006 	strne	r0, [r0], #-6
    122c:	0000039b 	muleq	r0, fp, r3
    1230:	00071e14 	andeq	r1, r7, r4, lsl lr
    1234:	03000000 	movweq	r0, #0
    1238:	00000424 	andeq	r0, r0, r4, lsr #8
    123c:	0424040d 	strteq	r0, [r4], #-1037	; 0xfffffbf3
    1240:	181a0000 	ldmdane	sl, {}	; <UNPREDICTABLE>
    1244:	fd000004 	stc2	0, cr0, [r0, #-16]
    1248:	03000006 	movweq	r0, #6
    124c:	13000007 	movwne	r0, #7
    1250:	000006ea 	andeq	r0, r0, sl, ror #13
    1254:	04241b00 	strteq	r1, [r4], #-2816	; 0xfffff500
    1258:	06f00000 	ldrbteq	r0, [r0], r0
    125c:	040d0000 	streq	r0, [sp], #-0
    1260:	0000003f 	andeq	r0, r0, pc, lsr r0
    1264:	06e5040d 	strbteq	r0, [r5], sp, lsl #8
    1268:	041c0000 	ldreq	r0, [ip], #-0
    126c:	00000065 	andeq	r0, r0, r5, rrx
    1270:	2c0f041d 	cfstrscs	mvf0, [pc], {29}
    1274:	30000000 	andcc	r0, r0, r0
    1278:	10000007 	andne	r0, r0, r7
    127c:	0000005e 	andeq	r0, r0, lr, asr r0
    1280:	20030009 	andcs	r0, r3, r9
    1284:	1e000007 	cdpne	0, 0, cr0, cr0, cr7, {0}
    1288:	00000c6e 	andeq	r0, r0, lr, ror #24
    128c:	300ca501 	andcc	sl, ip, r1, lsl #10
    1290:	05000007 	streq	r0, [r0, #-7]
    1294:	009bf003 	addseq	pc, fp, r3
    1298:	0bde1f00 	bleq	ff788ea0 <__bss_end+0xff77f278>
    129c:	a7010000 	strge	r0, [r1, -r0]
    12a0:	000db10a 	andeq	fp, sp, sl, lsl #2
    12a4:	00004d00 	andeq	r4, r0, r0, lsl #26
    12a8:	00876c00 	addeq	r6, r7, r0, lsl #24
    12ac:	0000b000 	andeq	fp, r0, r0
    12b0:	a59c0100 	ldrge	r0, [ip, #256]	; 0x100
    12b4:	20000007 	andcs	r0, r0, r7
    12b8:	00000f81 	andeq	r0, r0, r1, lsl #31
    12bc:	031ba701 	tsteq	fp, #262144	; 0x40000
    12c0:	03000002 	movweq	r0, #2
    12c4:	207fac91 			; <UNDEFINED> instruction: 0x207fac91
    12c8:	00000e10 	andeq	r0, r0, r0, lsl lr
    12cc:	4d2aa701 	stcmi	7, cr10, [sl, #-4]!
    12d0:	03000000 	movweq	r0, #0
    12d4:	1e7fa891 	mrcne	8, 3, sl, cr15, cr1, {4}
    12d8:	00000ce9 	andeq	r0, r0, r9, ror #25
    12dc:	a50aa901 	strge	sl, [sl, #-2305]	; 0xfffff6ff
    12e0:	03000007 	movweq	r0, #7
    12e4:	1e7fb491 	mrcne	4, 3, fp, cr15, cr1, {4}
    12e8:	00000bd9 	ldrdeq	r0, [r0], -r9
    12ec:	3809ad01 	stmdacc	r9, {r0, r8, sl, fp, sp, pc}
    12f0:	02000000 	andeq	r0, r0, #0
    12f4:	0f007491 	svceq	0x00007491
    12f8:	00000025 	andeq	r0, r0, r5, lsr #32
    12fc:	000007b5 			; <UNDEFINED> instruction: 0x000007b5
    1300:	00005e10 	andeq	r5, r0, r0, lsl lr
    1304:	21003f00 	tstcs	r0, r0, lsl #30
    1308:	00000df5 	strdeq	r0, [r0], -r5
    130c:	850a9901 	strhi	r9, [sl, #-2305]	; 0xfffff6ff
    1310:	4d00000e 	stcmi	0, cr0, [r0, #-56]	; 0xffffffc8
    1314:	30000000 	andcc	r0, r0, r0
    1318:	3c000087 	stccc	0, cr0, [r0], {135}	; 0x87
    131c:	01000000 	mrseq	r0, (UNDEF: 0)
    1320:	0007f29c 	muleq	r7, ip, r2
    1324:	65722200 	ldrbvs	r2, [r2, #-512]!	; 0xfffffe00
    1328:	9b010071 	blls	414f4 <__bss_end+0x378cc>
    132c:	0003de20 	andeq	sp, r3, r0, lsr #28
    1330:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1334:	000da61e 	andeq	sl, sp, lr, lsl r6
    1338:	0e9c0100 	fmleqe	f0, f4, f0
    133c:	0000004d 	andeq	r0, r0, sp, asr #32
    1340:	00709102 	rsbseq	r9, r0, r2, lsl #2
    1344:	000e3823 	andeq	r3, lr, r3, lsr #16
    1348:	06900100 	ldreq	r0, [r0], r0, lsl #2
    134c:	00000bfa 	strdeq	r0, [r0], -sl
    1350:	000086f4 	strdeq	r8, [r0], -r4
    1354:	0000003c 	andeq	r0, r0, ip, lsr r0
    1358:	082b9c01 	stmdaeq	fp!, {r0, sl, fp, ip, pc}
    135c:	3c200000 	stccc	0, cr0, [r0], #-0
    1360:	0100000c 	tsteq	r0, ip
    1364:	004d2190 	umaaleq	r2, sp, r0, r1
    1368:	91020000 	mrsls	r0, (UNDEF: 2)
    136c:	6572226c 	ldrbvs	r2, [r2, #-620]!	; 0xfffffd94
    1370:	92010071 	andls	r0, r1, #113	; 0x71
    1374:	0003de20 	andeq	sp, r3, r0, lsr #28
    1378:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    137c:	0dd22100 	ldfeqe	f2, [r2]
    1380:	84010000 	strhi	r0, [r1], #-0
    1384:	000c8a0a 	andeq	r8, ip, sl, lsl #20
    1388:	00004d00 	andeq	r4, r0, r0, lsl #26
    138c:	0086b800 	addeq	fp, r6, r0, lsl #16
    1390:	00003c00 	andeq	r3, r0, r0, lsl #24
    1394:	689c0100 	ldmvs	ip, {r8}
    1398:	22000008 	andcs	r0, r0, #8
    139c:	00716572 	rsbseq	r6, r1, r2, ror r5
    13a0:	ba208601 	blt	822bac <__bss_end+0x818f84>
    13a4:	02000003 	andeq	r0, r0, #3
    13a8:	d21e7491 	andsle	r7, lr, #-1862270976	; 0x91000000
    13ac:	0100000b 	tsteq	r0, fp
    13b0:	004d0e87 	subeq	r0, sp, r7, lsl #29
    13b4:	91020000 	mrsls	r0, (UNDEF: 2)
    13b8:	64210070 	strtvs	r0, [r1], #-112	; 0xffffff90
    13bc:	0100000f 	tsteq	r0, pc
    13c0:	0c500a78 	mrrceq	10, 7, r0, r0, cr8	; <UNPREDICTABLE>
    13c4:	004d0000 	subeq	r0, sp, r0
    13c8:	867c0000 	ldrbthi	r0, [ip], -r0
    13cc:	003c0000 	eorseq	r0, ip, r0
    13d0:	9c010000 	stcls	0, cr0, [r1], {-0}
    13d4:	000008a5 	andeq	r0, r0, r5, lsr #17
    13d8:	71657222 	cmnvc	r5, r2, lsr #4
    13dc:	207a0100 	rsbscs	r0, sl, r0, lsl #2
    13e0:	000003ba 			; <UNDEFINED> instruction: 0x000003ba
    13e4:	1e749102 	expnes	f1, f2
    13e8:	00000bd2 	ldrdeq	r0, [r0], -r2
    13ec:	4d0e7b01 	vstrmi	d7, [lr, #-4]
    13f0:	02000000 	andeq	r0, r0, #0
    13f4:	21007091 	swpcs	r7, r1, [r0]
    13f8:	00000c9e 	muleq	r0, lr, ip
    13fc:	55066c01 	strpl	r6, [r6, #-3073]	; 0xfffff3ff
    1400:	fc00000e 	stc2	0, cr0, [r0], {14}
    1404:	28000001 	stmdacs	r0, {r0}
    1408:	54000086 	strpl	r0, [r0], #-134	; 0xffffff7a
    140c:	01000000 	mrseq	r0, (UNDEF: 0)
    1410:	0008f19c 	muleq	r8, ip, r1
    1414:	0da62000 	stceq	0, cr2, [r6]
    1418:	6c010000 	stcvs	0, cr0, [r1], {-0}
    141c:	00004d15 	andeq	r4, r0, r5, lsl sp
    1420:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1424:	00060020 	andeq	r0, r6, r0, lsr #32
    1428:	256c0100 	strbcs	r0, [ip, #-256]!	; 0xffffff00
    142c:	0000004d 	andeq	r0, r0, sp, asr #32
    1430:	1e689102 	lgnnee	f1, f2
    1434:	00000f5c 	andeq	r0, r0, ip, asr pc
    1438:	4d0e6e01 	stcmi	14, cr6, [lr, #-4]
    143c:	02000000 	andeq	r0, r0, #0
    1440:	21007491 			; <UNDEFINED> instruction: 0x21007491
    1444:	00000c11 	andeq	r0, r0, r1, lsl ip
    1448:	ec125f01 	ldc	15, cr5, [r2], {1}
    144c:	8b00000e 	blhi	148c <shift+0x148c>
    1450:	d8000000 	stmdale	r0, {}	; <UNPREDICTABLE>
    1454:	50000085 	andpl	r0, r0, r5, lsl #1
    1458:	01000000 	mrseq	r0, (UNDEF: 0)
    145c:	00094c9c 	muleq	r9, ip, ip
    1460:	0b7f2000 	bleq	1fc9468 <__bss_end+0x1fbf840>
    1464:	5f010000 	svcpl	0x00010000
    1468:	00004d20 	andeq	r4, r0, r0, lsr #26
    146c:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1470:	000ddb20 	andeq	sp, sp, r0, lsr #22
    1474:	2f5f0100 	svccs	0x005f0100
    1478:	0000004d 	andeq	r0, r0, sp, asr #32
    147c:	20689102 	rsbcs	r9, r8, r2, lsl #2
    1480:	00000600 	andeq	r0, r0, r0, lsl #12
    1484:	4d3f5f01 	ldcmi	15, cr5, [pc, #-4]!	; 1488 <shift+0x1488>
    1488:	02000000 	andeq	r0, r0, #0
    148c:	5c1e6491 	cfldrspl	mvf6, [lr], {145}	; 0x91
    1490:	0100000f 	tsteq	r0, pc
    1494:	008b1661 	addeq	r1, fp, r1, ror #12
    1498:	91020000 	mrsls	r0, (UNDEF: 2)
    149c:	22210074 	eorcs	r0, r1, #116	; 0x74
    14a0:	0100000f 	tsteq	r0, pc
    14a4:	0c160a53 			; <UNDEFINED> instruction: 0x0c160a53
    14a8:	004d0000 	subeq	r0, sp, r0
    14ac:	85940000 	ldrhi	r0, [r4]
    14b0:	00440000 	subeq	r0, r4, r0
    14b4:	9c010000 	stcls	0, cr0, [r1], {-0}
    14b8:	00000998 	muleq	r0, r8, r9
    14bc:	000b7f20 	andeq	r7, fp, r0, lsr #30
    14c0:	1a530100 	bne	14c18c8 <__bss_end+0x14b7ca0>
    14c4:	0000004d 	andeq	r0, r0, sp, asr #32
    14c8:	206c9102 	rsbcs	r9, ip, r2, lsl #2
    14cc:	00000ddb 	ldrdeq	r0, [r0], -fp
    14d0:	4d295301 	stcmi	3, cr5, [r9, #-4]!
    14d4:	02000000 	andeq	r0, r0, #0
    14d8:	1b1e6891 	blne	79b724 <__bss_end+0x791afc>
    14dc:	0100000f 	tsteq	r0, pc
    14e0:	004d0e55 	subeq	r0, sp, r5, asr lr
    14e4:	91020000 	mrsls	r0, (UNDEF: 2)
    14e8:	15210074 	strne	r0, [r1, #-116]!	; 0xffffff8c
    14ec:	0100000f 	tsteq	r0, pc
    14f0:	0ef70a46 	vrintxeq.f32	s1, s12
    14f4:	004d0000 	subeq	r0, sp, r0
    14f8:	85440000 	strbhi	r0, [r4, #-0]
    14fc:	00500000 	subseq	r0, r0, r0
    1500:	9c010000 	stcls	0, cr0, [r1], {-0}
    1504:	000009f3 	strdeq	r0, [r0], -r3
    1508:	000b7f20 	andeq	r7, fp, r0, lsr #30
    150c:	19460100 	stmdbne	r6, {r8}^
    1510:	0000004d 	andeq	r0, r0, sp, asr #32
    1514:	206c9102 	rsbcs	r9, ip, r2, lsl #2
    1518:	00000cca 	andeq	r0, r0, sl, asr #25
    151c:	29304601 	ldmdbcs	r0!, {r0, r9, sl, lr}
    1520:	02000001 	andeq	r0, r0, #1
    1524:	e1206891 			; <UNDEFINED> instruction: 0xe1206891
    1528:	0100000d 	tsteq	r0, sp
    152c:	071e4146 	ldreq	r4, [lr, -r6, asr #2]
    1530:	91020000 	mrsls	r0, (UNDEF: 2)
    1534:	0f5c1e64 	svceq	0x005c1e64
    1538:	48010000 	stmdami	r1, {}	; <UNPREDICTABLE>
    153c:	00004d0e 	andeq	r4, r0, lr, lsl #26
    1540:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1544:	0bbf2300 	bleq	fefca14c <__bss_end+0xfefc0524>
    1548:	40010000 	andmi	r0, r1, r0
    154c:	000cd406 	andeq	sp, ip, r6, lsl #8
    1550:	00851800 	addeq	r1, r5, r0, lsl #16
    1554:	00002c00 	andeq	r2, r0, r0, lsl #24
    1558:	1d9c0100 	ldfnes	f0, [ip]
    155c:	2000000a 	andcs	r0, r0, sl
    1560:	00000b7f 	andeq	r0, r0, pc, ror fp
    1564:	4d154001 	ldcmi	0, cr4, [r5, #-4]
    1568:	02000000 	andeq	r0, r0, #0
    156c:	21007491 			; <UNDEFINED> instruction: 0x21007491
    1570:	00000da0 	andeq	r0, r0, r0, lsr #27
    1574:	e70a3301 	str	r3, [sl, -r1, lsl #6]
    1578:	4d00000d 	stcmi	0, cr0, [r0, #-52]	; 0xffffffcc
    157c:	c8000000 	stmdagt	r0, {}	; <UNPREDICTABLE>
    1580:	50000084 	andpl	r0, r0, r4, lsl #1
    1584:	01000000 	mrseq	r0, (UNDEF: 0)
    1588:	000a789c 	muleq	sl, ip, r8
    158c:	0b7f2000 	bleq	1fc9594 <__bss_end+0x1fbf96c>
    1590:	33010000 	movwcc	r0, #4096	; 0x1000
    1594:	00004d19 	andeq	r4, r0, r9, lsl sp
    1598:	6c910200 	lfmvs	f0, 4, [r1], {0}
    159c:	000f3820 	andeq	r3, pc, r0, lsr #16
    15a0:	2b330100 	blcs	cc19a8 <__bss_end+0xcb7d80>
    15a4:	00000203 	andeq	r0, r0, r3, lsl #4
    15a8:	20689102 	rsbcs	r9, r8, r2, lsl #2
    15ac:	00000e14 	andeq	r0, r0, r4, lsl lr
    15b0:	4d3c3301 	ldcmi	3, cr3, [ip, #-4]!
    15b4:	02000000 	andeq	r0, r0, #0
    15b8:	e61e6491 			; <UNDEFINED> instruction: 0xe61e6491
    15bc:	0100000e 	tsteq	r0, lr
    15c0:	004d0e35 	subeq	r0, sp, r5, lsr lr
    15c4:	91020000 	mrsls	r0, (UNDEF: 2)
    15c8:	86210074 			; <UNDEFINED> instruction: 0x86210074
    15cc:	0100000f 	tsteq	r0, pc
    15d0:	0f3f0a25 	svceq	0x003f0a25
    15d4:	004d0000 	subeq	r0, sp, r0
    15d8:	84780000 	ldrbthi	r0, [r8], #-0
    15dc:	00500000 	subseq	r0, r0, r0
    15e0:	9c010000 	stcls	0, cr0, [r1], {-0}
    15e4:	00000ad3 	ldrdeq	r0, [r0], -r3
    15e8:	000b7f20 	andeq	r7, fp, r0, lsr #30
    15ec:	18250100 	stmdane	r5!, {r8}
    15f0:	0000004d 	andeq	r0, r0, sp, asr #32
    15f4:	206c9102 	rsbcs	r9, ip, r2, lsl #2
    15f8:	00000f38 	andeq	r0, r0, r8, lsr pc
    15fc:	d92a2501 	stmdble	sl!, {r0, r8, sl, sp}
    1600:	0200000a 	andeq	r0, r0, #10
    1604:	14206891 	strtne	r6, [r0], #-2193	; 0xfffff76f
    1608:	0100000e 	tsteq	r0, lr
    160c:	004d3b25 	subeq	r3, sp, r5, lsr #22
    1610:	91020000 	mrsls	r0, (UNDEF: 2)
    1614:	0be31e64 	bleq	ff8c8fac <__bss_end+0xff8bf384>
    1618:	27010000 	strcs	r0, [r1, -r0]
    161c:	00004d0e 	andeq	r4, r0, lr, lsl #26
    1620:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1624:	25040d00 	strcs	r0, [r4, #-3328]	; 0xfffff300
    1628:	03000000 	movweq	r0, #0
    162c:	00000ad3 	ldrdeq	r0, [r0], -r3
    1630:	000dac21 	andeq	sl, sp, r1, lsr #24
    1634:	0a190100 	beq	641a3c <__bss_end+0x637e14>
    1638:	00000f92 	muleq	r0, r2, pc	; <UNPREDICTABLE>
    163c:	0000004d 	andeq	r0, r0, sp, asr #32
    1640:	00008434 	andeq	r8, r0, r4, lsr r4
    1644:	00000044 	andeq	r0, r0, r4, asr #32
    1648:	0b2a9c01 	bleq	aa8654 <__bss_end+0xa9ea2c>
    164c:	7d200000 	stcvc	0, cr0, [r0, #-0]
    1650:	0100000f 	tsteq	r0, pc
    1654:	02031b19 	andeq	r1, r3, #25600	; 0x6400
    1658:	91020000 	mrsls	r0, (UNDEF: 2)
    165c:	0f33206c 	svceq	0x0033206c
    1660:	19010000 	stmdbne	r1, {}	; <UNPREDICTABLE>
    1664:	0001d235 	andeq	sp, r1, r5, lsr r2
    1668:	68910200 	ldmvs	r1, {r9}
    166c:	000b7f1e 	andeq	r7, fp, lr, lsl pc
    1670:	0e1b0100 	mufeqe	f0, f3, f0
    1674:	0000004d 	andeq	r0, r0, sp, asr #32
    1678:	00749102 	rsbseq	r9, r4, r2, lsl #2
    167c:	000c3024 	andeq	r3, ip, r4, lsr #32
    1680:	06140100 	ldreq	r0, [r4], -r0, lsl #2
    1684:	00000be9 	andeq	r0, r0, r9, ror #23
    1688:	00008418 	andeq	r8, r0, r8, lsl r4
    168c:	0000001c 	andeq	r0, r0, ip, lsl r0
    1690:	29239c01 	stmdbcs	r3!, {r0, sl, fp, ip, pc}
    1694:	0100000f 	tsteq	r0, pc
    1698:	0cbc060e 	ldceq	6, cr0, [ip], #56	; 0x38
    169c:	83ec0000 	mvnhi	r0, #0
    16a0:	002c0000 	eoreq	r0, ip, r0
    16a4:	9c010000 	stcls	0, cr0, [r1], {-0}
    16a8:	00000b6a 	andeq	r0, r0, sl, ror #22
    16ac:	000c2720 	andeq	r2, ip, r0, lsr #14
    16b0:	140e0100 	strne	r0, [lr], #-256	; 0xffffff00
    16b4:	00000038 	andeq	r0, r0, r8, lsr r0
    16b8:	00749102 	rsbseq	r9, r4, r2, lsl #2
    16bc:	000f8b25 	andeq	r8, pc, r5, lsr #22
    16c0:	0a040100 	beq	101ac8 <__bss_end+0xf7ea0>
    16c4:	00000cde 	ldrdeq	r0, [r0], -lr
    16c8:	0000004d 	andeq	r0, r0, sp, asr #32
    16cc:	000083c0 	andeq	r8, r0, r0, asr #7
    16d0:	0000002c 	andeq	r0, r0, ip, lsr #32
    16d4:	70229c01 	eorvc	r9, r2, r1, lsl #24
    16d8:	01006469 	tsteq	r0, r9, ror #8
    16dc:	004d0e06 	subeq	r0, sp, r6, lsl #28
    16e0:	91020000 	mrsls	r0, (UNDEF: 2)
    16e4:	2d000074 	stccs	0, cr0, [r0, #-464]	; 0xfffffe30
    16e8:	04000006 	streq	r0, [r0], #-6
    16ec:	00068900 	andeq	r8, r6, r0, lsl #18
    16f0:	ef010400 	svc	0x00010400
    16f4:	0400000c 	streq	r0, [r0], #-12
    16f8:	0000104d 	andeq	r1, r0, sp, asr #32
    16fc:	00000e19 	andeq	r0, r0, r9, lsl lr
    1700:	00008820 	andeq	r8, r0, r0, lsr #16
    1704:	00000c5c 	andeq	r0, r0, ip, asr ip
    1708:	0000061f 	andeq	r0, r0, pc, lsl r6
    170c:	00004902 	andeq	r4, r0, r2, lsl #18
    1710:	10aa0300 	adcne	r0, sl, r0, lsl #6
    1714:	05010000 	streq	r0, [r1, #-0]
    1718:	00006110 	andeq	r6, r0, r0, lsl r1
    171c:	31301100 	teqcc	r0, r0, lsl #2
    1720:	35343332 	ldrcc	r3, [r4, #-818]!	; 0xfffffcce
    1724:	39383736 	ldmdbcc	r8!, {r1, r2, r4, r5, r8, r9, sl, ip, sp}
    1728:	44434241 	strbmi	r4, [r3], #-577	; 0xfffffdbf
    172c:	00004645 	andeq	r4, r0, r5, asr #12
    1730:	01030104 	tsteq	r3, r4, lsl #2
    1734:	00000025 	andeq	r0, r0, r5, lsr #32
    1738:	00007405 	andeq	r7, r0, r5, lsl #8
    173c:	00006100 	andeq	r6, r0, r0, lsl #2
    1740:	00660600 	rsbeq	r0, r6, r0, lsl #12
    1744:	00100000 	andseq	r0, r0, r0
    1748:	00005107 	andeq	r5, r0, r7, lsl #2
    174c:	07040800 	streq	r0, [r4, -r0, lsl #16]
    1750:	0000159f 	muleq	r0, pc, r5	; <UNPREDICTABLE>
    1754:	25080108 	strcs	r0, [r8, #-264]	; 0xfffffef8
    1758:	07000009 	streq	r0, [r0, -r9]
    175c:	0000006d 	andeq	r0, r0, sp, rrx
    1760:	00002a09 	andeq	r2, r0, r9, lsl #20
    1764:	10b60a00 	adcsne	r0, r6, r0, lsl #20
    1768:	d2010000 	andle	r0, r1, #0
    176c:	00114b06 	andseq	r4, r1, r6, lsl #22
    1770:	00915400 	addseq	r5, r1, r0, lsl #8
    1774:	00032800 	andeq	r2, r3, r0, lsl #16
    1778:	1f9c0100 	svcne	0x009c0100
    177c:	0b000001 	bleq	1788 <shift+0x1788>
    1780:	d2010066 	andle	r0, r1, #102	; 0x66
    1784:	00011f11 	andeq	r1, r1, r1, lsl pc
    1788:	a4910300 	ldrge	r0, [r1], #768	; 0x300
    178c:	00720b7f 	rsbseq	r0, r2, pc, ror fp
    1790:	2619d201 	ldrcs	sp, [r9], -r1, lsl #4
    1794:	03000001 	movweq	r0, #1
    1798:	0c7fa091 	ldcleq	0, cr10, [pc], #-580	; 155c <shift+0x155c>
    179c:	0000115d 	andeq	r1, r0, sp, asr r1
    17a0:	2c13d401 	cfldrscs	mvf13, [r3], {1}
    17a4:	02000001 	andeq	r0, r0, #1
    17a8:	080c5891 	stmdaeq	ip, {r0, r4, r7, fp, ip, lr}
    17ac:	01000011 	tsteq	r0, r1, lsl r0
    17b0:	012c1bd4 	ldrdeq	r1, [ip, -r4]!
    17b4:	91020000 	mrsls	r0, (UNDEF: 2)
    17b8:	00690d50 	rsbeq	r0, r9, r0, asr sp
    17bc:	2c24d401 	cfstrscs	mvf13, [r4], #-4
    17c0:	02000001 	andeq	r0, r0, #1
    17c4:	bb0c4891 	bllt	313a10 <__bss_end+0x309de8>
    17c8:	01000010 	tsteq	r0, r0, lsl r0
    17cc:	012c27d4 	ldrdeq	r2, [ip, -r4]!
    17d0:	91020000 	mrsls	r0, (UNDEF: 2)
    17d4:	109a0c40 	addsne	r0, sl, r0, asr #24
    17d8:	d4010000 	strle	r0, [r1], #-0
    17dc:	00012c2f 	andeq	r2, r1, pc, lsr #24
    17e0:	b8910300 	ldmlt	r1, {r8, r9}
    17e4:	101e0c7f 	andsne	r0, lr, pc, ror ip
    17e8:	d4010000 	strle	r0, [r1], #-0
    17ec:	00012c39 	andeq	r2, r1, r9, lsr ip
    17f0:	b0910300 	addslt	r0, r1, r0, lsl #6
    17f4:	10c90c7f 	sbcne	r0, r9, pc, ror ip
    17f8:	d5010000 	strle	r0, [r1, #-0]
    17fc:	00011f0b 	andeq	r1, r1, fp, lsl #30
    1800:	ac910300 	ldcge	3, cr0, [r1], {0}
    1804:	0408007f 	streq	r0, [r8], #-127	; 0xffffff81
    1808:	0012a604 	andseq	sl, r2, r4, lsl #12
    180c:	6d040e00 	stcvs	14, cr0, [r4, #-0]
    1810:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    1814:	02430508 	subeq	r0, r3, #8, 10	; 0x2000000
    1818:	100f0000 	andne	r0, pc, r0
    181c:	01000011 	tsteq	r0, r1, lsl r0
    1820:	0fe505c8 	svceq	0x00e505c8
    1824:	017f0000 	cmneq	pc, r0
    1828:	90ec0000 	rscls	r0, ip, r0
    182c:	00680000 	rsbeq	r0, r8, r0
    1830:	9c010000 	stcls	0, cr0, [r1], {-0}
    1834:	0000017f 	andeq	r0, r0, pc, ror r1
    1838:	0010bb10 	andseq	fp, r0, r0, lsl fp
    183c:	0ec80100 	poleqe	f0, f0, f0
    1840:	0000017f 	andeq	r0, r0, pc, ror r1
    1844:	106c9102 	rsbne	r9, ip, r2, lsl #2
    1848:	00000ddb 	ldrdeq	r0, [r0], -fp
    184c:	7f1ac801 	svcvc	0x001ac801
    1850:	02000001 	andeq	r0, r0, #1
    1854:	250c6891 	strcs	r6, [ip, #-2193]	; 0xfffff76f
    1858:	01000001 	tsteq	r0, r1
    185c:	017f09ca 	cmneq	pc, sl, asr #19
    1860:	91020000 	mrsls	r0, (UNDEF: 2)
    1864:	04110074 	ldreq	r0, [r1], #-116	; 0xffffff8c
    1868:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
    186c:	10e51200 	rscne	r1, r5, r0, lsl #4
    1870:	bd010000 	stclt	0, cr0, [r1, #-0]
    1874:	000fbf06 	andeq	fp, pc, r6, lsl #30
    1878:	00906c00 	addseq	r6, r0, r0, lsl #24
    187c:	00008000 	andeq	r8, r0, r0
    1880:	039c0100 	orrseq	r0, ip, #0, 2
    1884:	0b000002 	bleq	1894 <shift+0x1894>
    1888:	00637273 	rsbeq	r7, r3, r3, ror r2
    188c:	0319bd01 	tsteq	r9, #1, 26	; 0x40
    1890:	02000002 	andeq	r0, r0, #2
    1894:	640b6491 	strvs	r6, [fp], #-1169	; 0xfffffb6f
    1898:	01007473 	tsteq	r0, r3, ror r4
    189c:	020a24bd 	andeq	r2, sl, #-1124073472	; 0xbd000000
    18a0:	91020000 	mrsls	r0, (UNDEF: 2)
    18a4:	756e0b60 	strbvc	r0, [lr, #-2912]!	; 0xfffff4a0
    18a8:	bd01006d 	stclt	0, cr0, [r1, #-436]	; 0xfffffe4c
    18ac:	00017f2d 	andeq	r7, r1, sp, lsr #30
    18b0:	5c910200 	lfmpl	f0, 4, [r1], {0}
    18b4:	0010c20c 	andseq	ip, r0, ip, lsl #4
    18b8:	0ebf0100 	frdeqe	f0, f7, f0
    18bc:	0000020c 	andeq	r0, r0, ip, lsl #4
    18c0:	0c709102 	ldfeqp	f1, [r0], #-8
    18c4:	000010a3 	andeq	r1, r0, r3, lsr #1
    18c8:	2608c001 	strcs	ip, [r8], -r1
    18cc:	02000001 	andeq	r0, r0, #1
    18d0:	94136c91 	ldrls	r6, [r3], #-3217	; 0xfffff36f
    18d4:	48000090 	stmdami	r0, {r4, r7}
    18d8:	0d000000 	stceq	0, cr0, [r0, #-0]
    18dc:	c2010069 	andgt	r0, r1, #105	; 0x69
    18e0:	00017f0b 	andeq	r7, r1, fp, lsl #30
    18e4:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    18e8:	040e0000 	streq	r0, [lr], #-0
    18ec:	00000209 	andeq	r0, r0, r9, lsl #4
    18f0:	0e041514 	mcreq	5, 0, r1, cr4, cr4, {0}
    18f4:	00007404 	andeq	r7, r0, r4, lsl #8
    18f8:	10df1200 	sbcsne	r1, pc, r0, lsl #4
    18fc:	b5010000 	strlt	r0, [r1, #-0]
    1900:	00102a06 	andseq	r2, r0, r6, lsl #20
    1904:	00900400 	addseq	r0, r0, r0, lsl #8
    1908:	00006800 	andeq	r6, r0, r0, lsl #16
    190c:	719c0100 	orrsvc	r0, ip, r0, lsl #2
    1910:	10000002 	andne	r0, r0, r2
    1914:	00001156 	andeq	r1, r0, r6, asr r1
    1918:	0a12b501 	beq	4aed24 <__bss_end+0x4a50fc>
    191c:	02000002 	andeq	r0, r0, #2
    1920:	5d106c91 	ldcpl	12, cr6, [r0, #-580]	; 0xfffffdbc
    1924:	01000011 	tsteq	r0, r1, lsl r0
    1928:	017f1eb5 	ldrheq	r1, [pc, #-229]	; 184b <shift+0x184b>
    192c:	91020000 	mrsls	r0, (UNDEF: 2)
    1930:	656d0d68 	strbvs	r0, [sp, #-3432]!	; 0xfffff298
    1934:	b701006d 	strlt	r0, [r1, -sp, rrx]
    1938:	00012608 	andeq	r2, r1, r8, lsl #12
    193c:	70910200 	addsvc	r0, r1, r0, lsl #4
    1940:	00902013 	addseq	r2, r0, r3, lsl r0
    1944:	00003c00 	andeq	r3, r0, r0, lsl #24
    1948:	00690d00 	rsbeq	r0, r9, r0, lsl #26
    194c:	7f0bb901 	svcvc	0x000bb901
    1950:	02000001 	andeq	r0, r0, #1
    1954:	00007491 	muleq	r0, r1, r4
    1958:	00107f16 	andseq	r7, r0, r6, lsl pc
    195c:	07a40100 	streq	r0, [r4, r0, lsl #2]!
    1960:	0000116b 	andeq	r1, r0, fp, ror #2
    1964:	00000126 	andeq	r0, r0, r6, lsr #2
    1968:	00008f2c 	andeq	r8, r0, ip, lsr #30
    196c:	000000d8 	ldrdeq	r0, [r0], -r8
    1970:	02f09c01 	rscseq	r9, r0, #256	; 0x100
    1974:	13100000 	tstne	r0, #0
    1978:	01000010 	tsteq	r0, r0, lsl r0
    197c:	012615a4 			; <UNDEFINED> instruction: 0x012615a4
    1980:	91020000 	mrsls	r0, (UNDEF: 2)
    1984:	72730b64 	rsbsvc	r0, r3, #100, 22	; 0x19000
    1988:	a4010063 	strge	r0, [r1], #-99	; 0xffffff9d
    198c:	00020c27 	andeq	r0, r2, r7, lsr #24
    1990:	60910200 	addsvs	r0, r1, r0, lsl #4
    1994:	000e1410 	andeq	r1, lr, r0, lsl r4
    1998:	2fa40100 	svccs	0x00a40100
    199c:	0000017f 	andeq	r0, r0, pc, ror r1
    19a0:	0c5c9102 	ldfeqp	f1, [ip], {2}
    19a4:	00001087 	andeq	r1, r0, r7, lsl #1
    19a8:	7f09a501 	svcvc	0x0009a501
    19ac:	02000001 	andeq	r0, r0, #1
    19b0:	6d0d6c91 	stcvs	12, cr6, [sp, #-580]	; 0xfffffdbc
    19b4:	09a70100 	stmibeq	r7!, {r8}
    19b8:	0000017f 	andeq	r0, r0, pc, ror r1
    19bc:	13749102 	cmnne	r4, #-2147483648	; 0x80000000
    19c0:	00008f70 	andeq	r8, r0, r0, ror pc
    19c4:	00000070 	andeq	r0, r0, r0, ror r0
    19c8:	0100690d 	tsteq	r0, sp, lsl #18
    19cc:	017f0dab 	cmneq	pc, fp, lsr #27
    19d0:	91020000 	mrsls	r0, (UNDEF: 2)
    19d4:	16000070 			; <UNDEFINED> instruction: 0x16000070
    19d8:	00001023 	andeq	r1, r0, r3, lsr #32
    19dc:	3e079a01 	vmlacc.f32	s18, s14, s2
    19e0:	26000010 			; <UNDEFINED> instruction: 0x26000010
    19e4:	80000001 	andhi	r0, r0, r1
    19e8:	ac00008e 	stcge	0, cr0, [r0], {142}	; 0x8e
    19ec:	01000000 	mrseq	r0, (UNDEF: 0)
    19f0:	00036d9c 	muleq	r3, ip, sp
    19f4:	10131000 	andsne	r1, r3, r0
    19f8:	9a010000 	bls	41a00 <__bss_end+0x37dd8>
    19fc:	00012614 	andeq	r2, r1, r4, lsl r6
    1a00:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    1a04:	6372730b 	cmnvs	r2, #738197504	; 0x2c000000
    1a08:	269a0100 	ldrcs	r0, [sl], r0, lsl #2
    1a0c:	0000020c 	andeq	r0, r0, ip, lsl #4
    1a10:	0d609102 	stfeqp	f1, [r0, #-8]!
    1a14:	9b01006e 	blls	41bd4 <__bss_end+0x37fac>
    1a18:	00017f09 	andeq	r7, r1, r9, lsl #30
    1a1c:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1a20:	01006d0d 	tsteq	r0, sp, lsl #26
    1a24:	017f099c 			; <UNDEFINED> instruction: 0x017f099c
    1a28:	91020000 	mrsls	r0, (UNDEF: 2)
    1a2c:	10870c74 	addne	r0, r7, r4, ror ip
    1a30:	9d010000 	stcls	0, cr0, [r1, #-0]
    1a34:	00017f09 	andeq	r7, r1, r9, lsl #30
    1a38:	68910200 	ldmvs	r1, {r9}
    1a3c:	008eb413 	addeq	fp, lr, r3, lsl r4
    1a40:	00005400 	andeq	r5, r0, r0, lsl #8
    1a44:	00690d00 	rsbeq	r0, r9, r0, lsl #26
    1a48:	7f0d9e01 	svcvc	0x000d9e01
    1a4c:	02000001 	andeq	r0, r0, #1
    1a50:	00007091 	muleq	r0, r1, r0
    1a54:	0011640f 	andseq	r6, r1, pc, lsl #8
    1a58:	058f0100 	streq	r0, [pc, #256]	; 1b60 <shift+0x1b60>
    1a5c:	00001115 	andeq	r1, r0, r5, lsl r1
    1a60:	0000017f 	andeq	r0, r0, pc, ror r1
    1a64:	00008e2c 	andeq	r8, r0, ip, lsr #28
    1a68:	00000054 	andeq	r0, r0, r4, asr r0
    1a6c:	03a69c01 			; <UNDEFINED> instruction: 0x03a69c01
    1a70:	730b0000 	movwvc	r0, #45056	; 0xb000
    1a74:	188f0100 	stmne	pc, {r8}	; <UNPREDICTABLE>
    1a78:	0000020c 	andeq	r0, r0, ip, lsl #4
    1a7c:	0d6c9102 	stfeqp	f1, [ip, #-8]!
    1a80:	91010069 	tstls	r1, r9, rrx
    1a84:	00017f06 	andeq	r7, r1, r6, lsl #30
    1a88:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1a8c:	10ec0f00 	rscne	r0, ip, r0, lsl #30
    1a90:	7f010000 	svcvc	0x00010000
    1a94:	00112205 	andseq	r2, r1, r5, lsl #4
    1a98:	00017f00 	andeq	r7, r1, r0, lsl #30
    1a9c:	008d8000 	addeq	r8, sp, r0
    1aa0:	0000ac00 	andeq	sl, r0, r0, lsl #24
    1aa4:	0c9c0100 	ldfeqs	f0, [ip], {0}
    1aa8:	0b000004 	bleq	1ac0 <shift+0x1ac0>
    1aac:	01003173 	tsteq	r0, r3, ror r1
    1ab0:	020c197f 	andeq	r1, ip, #2080768	; 0x1fc000
    1ab4:	91020000 	mrsls	r0, (UNDEF: 2)
    1ab8:	32730b6c 	rsbscc	r0, r3, #108, 22	; 0x1b000
    1abc:	297f0100 	ldmdbcs	pc!, {r8}^	; <UNPREDICTABLE>
    1ac0:	0000020c 	andeq	r0, r0, ip, lsl #4
    1ac4:	0b689102 	bleq	1a25ed4 <__bss_end+0x1a1c2ac>
    1ac8:	006d756e 	rsbeq	r7, sp, lr, ror #10
    1acc:	7f317f01 	svcvc	0x00317f01
    1ad0:	02000001 	andeq	r0, r0, #1
    1ad4:	750d6491 	strvc	r6, [sp, #-1169]	; 0xfffffb6f
    1ad8:	81010031 	tsthi	r1, r1, lsr r0
    1adc:	00040c10 	andeq	r0, r4, r0, lsl ip
    1ae0:	77910200 	ldrvc	r0, [r1, r0, lsl #4]
    1ae4:	0032750d 	eorseq	r7, r2, sp, lsl #10
    1ae8:	0c148101 	ldfeqd	f0, [r4], {1}
    1aec:	02000004 	andeq	r0, r0, #4
    1af0:	08007691 	stmdaeq	r0, {r0, r4, r7, r9, sl, ip, sp, lr}
    1af4:	091c0801 	ldmdbeq	ip, {r0, fp}
    1af8:	360f0000 	strcc	r0, [pc], -r0
    1afc:	01000010 	tsteq	r0, r0, lsl r0
    1b00:	0fae0773 	svceq	0x00ae0773
    1b04:	01260000 			; <UNDEFINED> instruction: 0x01260000
    1b08:	8cc00000 	stclhi	0, cr0, [r0], {0}
    1b0c:	00c00000 	sbceq	r0, r0, r0
    1b10:	9c010000 	stcls	0, cr0, [r1], {-0}
    1b14:	0000046c 	andeq	r0, r0, ip, ror #8
    1b18:	00101310 	andseq	r1, r0, r0, lsl r3
    1b1c:	15730100 	ldrbne	r0, [r3, #-256]!	; 0xffffff00
    1b20:	00000126 	andeq	r0, r0, r6, lsr #2
    1b24:	0b6c9102 	bleq	1b25f34 <__bss_end+0x1b1c30c>
    1b28:	00637273 	rsbeq	r7, r3, r3, ror r2
    1b2c:	0c277301 	stceq	3, cr7, [r7], #-4
    1b30:	02000002 	andeq	r0, r0, #2
    1b34:	6e0b6891 	mcrvs	8, 0, r6, cr11, cr1, {4}
    1b38:	01006d75 	tsteq	r0, r5, ror sp
    1b3c:	017f3073 	cmneq	pc, r3, ror r0	; <UNPREDICTABLE>
    1b40:	91020000 	mrsls	r0, (UNDEF: 2)
    1b44:	00690d64 	rsbeq	r0, r9, r4, ror #26
    1b48:	7f067501 	svcvc	0x00067501
    1b4c:	02000001 	andeq	r0, r0, #1
    1b50:	0f007491 	svceq	0x00007491
    1b54:	00000fef 	andeq	r0, r0, pc, ror #31
    1b58:	08075701 	stmdaeq	r7, {r0, r8, r9, sl, ip, lr}
    1b5c:	1f000010 	svcne	0x00000010
    1b60:	64000001 	strvs	r0, [r0], #-1
    1b64:	5c00008b 	stcpl	0, cr0, [r0], {139}	; 0x8b
    1b68:	01000001 	tsteq	r0, r1
    1b6c:	00050d9c 	muleq	r5, ip, sp
    1b70:	10181000 	andsne	r1, r8, r0
    1b74:	57010000 	strpl	r0, [r1, -r0]
    1b78:	00020c18 	andeq	r0, r2, r8, lsl ip
    1b7c:	44910200 	ldrmi	r0, [r1], #512	; 0x200
    1b80:	0011010c 	andseq	r0, r1, ip, lsl #2
    1b84:	0c580100 	ldfeqe	f0, [r8], {-0}
    1b88:	0000050d 	andeq	r0, r0, sp, lsl #10
    1b8c:	0c709102 	ldfeqp	f1, [r0], #-8
    1b90:	0000108e 	andeq	r1, r0, lr, lsl #1
    1b94:	0d0c5901 	vstreq.16	s10, [ip, #-2]	; <UNPREDICTABLE>
    1b98:	02000005 	andeq	r0, r0, #5
    1b9c:	740d6091 	strvc	r6, [sp], #-145	; 0xffffff6f
    1ba0:	0100706d 	tsteq	r0, sp, rrx
    1ba4:	050d0c5b 	streq	r0, [sp, #-3163]	; 0xfffff3a5
    1ba8:	91020000 	mrsls	r0, (UNDEF: 2)
    1bac:	07d60c58 			; <UNDEFINED> instruction: 0x07d60c58
    1bb0:	5c010000 	stcpl	0, cr0, [r1], {-0}
    1bb4:	00017f09 	andeq	r7, r1, r9, lsl #30
    1bb8:	54910200 	ldrpl	r0, [r1], #512	; 0x200
    1bbc:	00158f0c 	andseq	r8, r5, ip, lsl #30
    1bc0:	095d0100 	ldmdbeq	sp, {r8}^
    1bc4:	0000017f 	andeq	r0, r0, pc, ror r1
    1bc8:	0c6c9102 	stfeqp	f1, [ip], #-8
    1bcc:	000010d1 	ldrdeq	r1, [r0], -r1	; <UNPREDICTABLE>
    1bd0:	140a5e01 	strne	r5, [sl], #-3585	; 0xfffff1ff
    1bd4:	02000005 	andeq	r0, r0, #5
    1bd8:	c0136b91 	mulsgt	r3, r1, fp
    1bdc:	d000008b 	andle	r0, r0, fp, lsl #1
    1be0:	0d000000 	stceq	0, cr0, [r0, #-0]
    1be4:	006c6176 	rsbeq	r6, ip, r6, ror r1
    1be8:	0d106701 	ldceq	7, cr6, [r0, #-4]
    1bec:	02000005 	andeq	r0, r0, #5
    1bf0:	00004891 	muleq	r0, r1, r8
    1bf4:	4f040808 	svcmi	0x00040808
    1bf8:	08000015 	stmdaeq	r0, {r0, r2, r4}
    1bfc:	078f0201 	streq	r0, [pc, r1, lsl #4]
    1c00:	f40f0000 	vst4.8	{d0-d3}, [pc], r0
    1c04:	0100000f 	tsteq	r0, pc
    1c08:	0fcf053c 	svceq	0x00cf053c
    1c0c:	017f0000 	cmneq	pc, r0
    1c10:	8a640000 	bhi	1901c18 <__bss_end+0x18f7ff0>
    1c14:	01000000 	mrseq	r0, (UNDEF: 0)
    1c18:	9c010000 	stcls	0, cr0, [r1], {-0}
    1c1c:	0000057e 	andeq	r0, r0, lr, ror r5
    1c20:	00101810 	andseq	r1, r0, r0, lsl r8
    1c24:	213c0100 	teqcs	ip, r0, lsl #2
    1c28:	0000020c 	andeq	r0, r0, ip, lsl #4
    1c2c:	0d6c9102 	stfeqp	f1, [ip, #-8]!
    1c30:	00746f64 	rsbseq	r6, r4, r4, ror #30
    1c34:	140a3e01 	strne	r3, [sl], #-3585	; 0xfffff1ff
    1c38:	02000005 	andeq	r0, r0, #5
    1c3c:	f40c7791 	vst1.32	{d7}, [ip :64], r1
    1c40:	01000010 	tsteq	r0, r0, lsl r0
    1c44:	05140a3f 	ldreq	r0, [r4, #-2623]	; 0xfffff5c1
    1c48:	91020000 	mrsls	r0, (UNDEF: 2)
    1c4c:	8a941376 	bhi	fe506a2c <__bss_end+0xfe4fce04>
    1c50:	008c0000 	addeq	r0, ip, r0
    1c54:	630d0000 	movwvs	r0, #53248	; 0xd000
    1c58:	0e410100 	dvfeqs	f0, f1, f0
    1c5c:	0000006d 	andeq	r0, r0, sp, rrx
    1c60:	00759102 	rsbseq	r9, r5, r2, lsl #2
    1c64:	10031600 	andne	r1, r3, r0, lsl #12
    1c68:	26010000 	strcs	r0, [r1], -r0
    1c6c:	00113405 	andseq	r3, r1, r5, lsl #8
    1c70:	00017f00 	andeq	r7, r1, r0, lsl #30
    1c74:	00899800 	addeq	r9, r9, r0, lsl #16
    1c78:	0000cc00 	andeq	ip, r0, r0, lsl #24
    1c7c:	bb9c0100 	bllt	fe702084 <__bss_end+0xfe6f845c>
    1c80:	10000005 	andne	r0, r0, r5
    1c84:	00001018 	andeq	r1, r0, r8, lsl r0
    1c88:	0c162601 	ldceq	6, cr2, [r6], {1}
    1c8c:	02000002 	andeq	r0, r0, #2
    1c90:	010c6c91 			; <UNDEFINED> instruction: 0x010c6c91
    1c94:	01000011 	tsteq	r0, r1, lsl r0
    1c98:	017f062a 	cmneq	pc, sl, lsr #12
    1c9c:	91020000 	mrsls	r0, (UNDEF: 2)
    1ca0:	95170074 	ldrls	r0, [r7, #-116]	; 0xffffff8c
    1ca4:	01000010 	tsteq	r0, r0, lsl r0
    1ca8:	113f0608 	teqne	pc, r8, lsl #12
    1cac:	88200000 	stmdahi	r0!, {}	; <UNPREDICTABLE>
    1cb0:	01780000 	cmneq	r8, r0
    1cb4:	9c010000 	stcls	0, cr0, [r1], {-0}
    1cb8:	00101810 	andseq	r1, r0, r0, lsl r8
    1cbc:	0f080100 	svceq	0x00080100
    1cc0:	0000017f 	andeq	r0, r0, pc, ror r1
    1cc4:	10649102 	rsbne	r9, r4, r2, lsl #2
    1cc8:	00001101 	andeq	r1, r0, r1, lsl #2
    1ccc:	261c0801 	ldrcs	r0, [ip], -r1, lsl #16
    1cd0:	02000001 	andeq	r0, r0, #1
    1cd4:	99106091 	ldmdbls	r0, {r0, r4, r7, sp, lr}
    1cd8:	01000012 	tsteq	r0, r2, lsl r0
    1cdc:	00663108 	rsbeq	r3, r6, r8, lsl #2
    1ce0:	91020000 	mrsls	r0, (UNDEF: 2)
    1ce4:	00690d5c 	rsbeq	r0, r9, ip, asr sp
    1ce8:	7f090a01 	svcvc	0x00090a01
    1cec:	02000001 	andeq	r0, r0, #1
    1cf0:	6a0d7491 	bvs	35ef3c <__bss_end+0x355314>
    1cf4:	090b0100 	stmdbeq	fp, {r8}
    1cf8:	0000017f 	andeq	r0, r0, pc, ror r1
    1cfc:	13709102 	cmnne	r0, #-2147483648	; 0x80000000
    1d00:	00008918 	andeq	r8, r0, r8, lsl r9
    1d04:	00000060 	andeq	r0, r0, r0, rrx
    1d08:	0100630d 	tsteq	r0, sp, lsl #6
    1d0c:	006d081f 	rsbeq	r0, sp, pc, lsl r8
    1d10:	91020000 	mrsls	r0, (UNDEF: 2)
    1d14:	0000006f 	andeq	r0, r0, pc, rrx
    1d18:	00000022 	andeq	r0, r0, r2, lsr #32
    1d1c:	07ea0002 	strbeq	r0, [sl, r2]!
    1d20:	01040000 	mrseq	r0, (UNDEF: 4)
    1d24:	00000b30 	andeq	r0, r0, r0, lsr fp
    1d28:	0000947c 	andeq	r9, r0, ip, ror r4
    1d2c:	00009688 	andeq	r9, r0, r8, lsl #13
    1d30:	0000117c 	andeq	r1, r0, ip, ror r1
    1d34:	000011ac 	andeq	r1, r0, ip, lsr #3
    1d38:	00001214 	andeq	r1, r0, r4, lsl r2
    1d3c:	00228001 	eoreq	r8, r2, r1
    1d40:	00020000 	andeq	r0, r2, r0
    1d44:	000007fe 	strdeq	r0, [r0], -lr
    1d48:	0bad0104 	bleq	feb42160 <__bss_end+0xfeb38538>
    1d4c:	96880000 	strls	r0, [r8], r0
    1d50:	968c0000 	strls	r0, [ip], r0
    1d54:	117c0000 	cmnne	ip, r0
    1d58:	11ac0000 			; <UNDEFINED> instruction: 0x11ac0000
    1d5c:	12140000 	andsne	r0, r4, #0
    1d60:	80010000 	andhi	r0, r1, r0
    1d64:	00000022 	andeq	r0, r0, r2, lsr #32
    1d68:	08120002 	ldmdaeq	r2, {r1}
    1d6c:	01040000 	mrseq	r0, (UNDEF: 4)
    1d70:	00000c0d 	andeq	r0, r0, sp, lsl #24
    1d74:	0000968c 	andeq	r9, r0, ip, lsl #13
    1d78:	000098dc 	ldrdeq	r9, [r0], -ip
    1d7c:	00001220 	andeq	r1, r0, r0, lsr #4
    1d80:	000011ac 	andeq	r1, r0, ip, lsr #3
    1d84:	00001214 	andeq	r1, r0, r4, lsl r2
    1d88:	00228001 	eoreq	r8, r2, r1
    1d8c:	00020000 	andeq	r0, r2, r0
    1d90:	00000826 	andeq	r0, r0, r6, lsr #16
    1d94:	0d0c0104 	stfeqs	f0, [ip, #-16]
    1d98:	98dc0000 	ldmls	ip, {}^	; <UNPREDICTABLE>
    1d9c:	99b00000 	ldmibls	r0!, {}	; <UNPREDICTABLE>
    1da0:	12510000 	subsne	r0, r1, #0
    1da4:	11ac0000 			; <UNDEFINED> instruction: 0x11ac0000
    1da8:	12140000 	andsne	r0, r4, #0
    1dac:	80010000 	andhi	r0, r1, r0
    1db0:	0000032a 	andeq	r0, r0, sl, lsr #6
    1db4:	083a0004 	ldmdaeq	sl!, {r2}
    1db8:	01040000 	mrseq	r0, (UNDEF: 4)
    1dbc:	0000139d 	muleq	r0, sp, r3
    1dc0:	0015560c 	andseq	r5, r5, ip, lsl #12
    1dc4:	0011ac00 	andseq	sl, r1, r0, lsl #24
    1dc8:	000d8a00 	andeq	r8, sp, r0, lsl #20
    1dcc:	05040200 	streq	r0, [r4, #-512]	; 0xfffffe00
    1dd0:	00746e69 	rsbseq	r6, r4, r9, ror #28
    1dd4:	9f070403 	svcls	0x00070403
    1dd8:	03000015 	movweq	r0, #21
    1ddc:	02430508 	subeq	r0, r3, #8, 10	; 0x2000000
    1de0:	08030000 	stmdaeq	r3, {}	; <UNPREDICTABLE>
    1de4:	00154a04 	andseq	r4, r5, r4, lsl #20
    1de8:	08010300 	stmdaeq	r1, {r8, r9}
    1dec:	0000091c 	andeq	r0, r0, ip, lsl r9
    1df0:	1e060103 	adfnes	f0, f6, f3
    1df4:	04000009 	streq	r0, [r0], #-9
    1df8:	00001722 	andeq	r1, r0, r2, lsr #14
    1dfc:	00390107 	eorseq	r0, r9, r7, lsl #2
    1e00:	17010000 	strne	r0, [r1, -r0]
    1e04:	0001d406 	andeq	sp, r1, r6, lsl #8
    1e08:	12ac0500 	adcne	r0, ip, #0, 10
    1e0c:	05000000 	streq	r0, [r0, #-0]
    1e10:	000017d1 	ldrdeq	r1, [r0], -r1	; <UNPREDICTABLE>
    1e14:	147f0501 	ldrbtne	r0, [pc], #-1281	; 1e1c <shift+0x1e1c>
    1e18:	05020000 	streq	r0, [r2, #-0]
    1e1c:	0000153d 	andeq	r1, r0, sp, lsr r5
    1e20:	173b0503 	ldrne	r0, [fp, -r3, lsl #10]!
    1e24:	05040000 	streq	r0, [r4, #-0]
    1e28:	000017e1 	andeq	r1, r0, r1, ror #15
    1e2c:	17510505 	ldrbne	r0, [r1, -r5, lsl #10]
    1e30:	05060000 	streq	r0, [r6, #-0]
    1e34:	00001586 	andeq	r1, r0, r6, lsl #11
    1e38:	16cc0507 	strbne	r0, [ip], r7, lsl #10
    1e3c:	05080000 	streq	r0, [r8, #-0]
    1e40:	000016da 	ldrdeq	r1, [r0], -sl
    1e44:	16e80509 	strbtne	r0, [r8], r9, lsl #10
    1e48:	050a0000 	streq	r0, [sl, #-0]
    1e4c:	000015ef 	andeq	r1, r0, pc, ror #11
    1e50:	15df050b 	ldrbne	r0, [pc, #1291]	; 2363 <shift+0x2363>
    1e54:	050c0000 	streq	r0, [ip, #-0]
    1e58:	000012c8 	andeq	r1, r0, r8, asr #5
    1e5c:	12e1050d 	rscne	r0, r1, #54525952	; 0x3400000
    1e60:	050e0000 	streq	r0, [lr, #-0]
    1e64:	000015d0 	ldrdeq	r1, [r0], -r0
    1e68:	1794050f 	ldrne	r0, [r4, pc, lsl #10]
    1e6c:	05100000 	ldreq	r0, [r0, #-0]
    1e70:	00001711 	andeq	r1, r0, r1, lsl r7
    1e74:	17850511 	usada8ne	r5, r1, r5, r0
    1e78:	05120000 	ldreq	r0, [r2, #-0]
    1e7c:	0000138e 	andeq	r1, r0, lr, lsl #7
    1e80:	130b0513 	movwne	r0, #46355	; 0xb513
    1e84:	05140000 	ldreq	r0, [r4, #-0]
    1e88:	000012d5 	ldrdeq	r1, [r0], -r5
    1e8c:	166e0515 			; <UNDEFINED> instruction: 0x166e0515
    1e90:	05160000 	ldreq	r0, [r6, #-0]
    1e94:	00001342 	andeq	r1, r0, r2, asr #6
    1e98:	127d0517 	rsbsne	r0, sp, #96468992	; 0x5c00000
    1e9c:	05180000 	ldreq	r0, [r8, #-0]
    1ea0:	00001777 	andeq	r1, r0, r7, ror r7
    1ea4:	15ac0519 	strne	r0, [ip, #1305]!	; 0x519
    1ea8:	051a0000 	ldreq	r0, [sl, #-0]
    1eac:	00001686 	andeq	r1, r0, r6, lsl #13
    1eb0:	1316051b 	tstne	r6, #113246208	; 0x6c00000
    1eb4:	051c0000 	ldreq	r0, [ip, #-0]
    1eb8:	00001522 	andeq	r1, r0, r2, lsr #10
    1ebc:	1471051d 	ldrbtne	r0, [r1], #-1309	; 0xfffffae3
    1ec0:	051e0000 	ldreq	r0, [lr, #-0]
    1ec4:	00001703 	andeq	r1, r0, r3, lsl #14
    1ec8:	175f051f 	smmlane	pc, pc, r5, r0	; <UNPREDICTABLE>
    1ecc:	05200000 	streq	r0, [r0, #-0]!
    1ed0:	000017a0 	andeq	r1, r0, r0, lsr #15
    1ed4:	17ae0521 	strne	r0, [lr, r1, lsr #10]!
    1ed8:	05220000 	streq	r0, [r2, #-0]!
    1edc:	000015c3 	andeq	r1, r0, r3, asr #11
    1ee0:	14e60523 	strbtne	r0, [r6], #1315	; 0x523
    1ee4:	05240000 	streq	r0, [r4, #-0]!
    1ee8:	00001325 	andeq	r1, r0, r5, lsr #6
    1eec:	15790525 	ldrbne	r0, [r9, #-1317]!	; 0xfffffadb
    1ef0:	05260000 	streq	r0, [r6, #-0]!
    1ef4:	0000148b 	andeq	r1, r0, fp, lsl #9
    1ef8:	172e0527 	strne	r0, [lr, -r7, lsr #10]!
    1efc:	05280000 	streq	r0, [r8, #-0]!
    1f00:	0000149b 	muleq	r0, fp, r4
    1f04:	14aa0529 	strtne	r0, [sl], #1321	; 0x529
    1f08:	052a0000 	streq	r0, [sl, #-0]!
    1f0c:	000014b9 			; <UNDEFINED> instruction: 0x000014b9
    1f10:	14c8052b 	strbne	r0, [r8], #1323	; 0x52b
    1f14:	052c0000 	streq	r0, [ip, #-0]!
    1f18:	00001456 	andeq	r1, r0, r6, asr r4
    1f1c:	14d7052d 	ldrbne	r0, [r7], #1325	; 0x52d
    1f20:	052e0000 	streq	r0, [lr, #-0]!
    1f24:	000016bd 			; <UNDEFINED> instruction: 0x000016bd
    1f28:	14f5052f 	ldrbtne	r0, [r5], #1327	; 0x52f
    1f2c:	05300000 	ldreq	r0, [r0, #-0]!
    1f30:	00001504 	andeq	r1, r0, r4, lsl #10
    1f34:	12b60531 	adcsne	r0, r6, #205520896	; 0xc400000
    1f38:	05320000 	ldreq	r0, [r2, #-0]!
    1f3c:	0000160e 	andeq	r1, r0, lr, lsl #12
    1f40:	161e0533 			; <UNDEFINED> instruction: 0x161e0533
    1f44:	05340000 	ldreq	r0, [r4, #-0]!
    1f48:	0000162e 	andeq	r1, r0, lr, lsr #12
    1f4c:	14440535 	strbne	r0, [r4], #-1333	; 0xfffffacb
    1f50:	05360000 	ldreq	r0, [r6, #-0]!
    1f54:	0000163e 	andeq	r1, r0, lr, lsr r6
    1f58:	164e0537 			; <UNDEFINED> instruction: 0x164e0537
    1f5c:	05380000 	ldreq	r0, [r8, #-0]!
    1f60:	0000165e 	andeq	r1, r0, lr, asr r6
    1f64:	13350539 	teqne	r5, #239075328	; 0xe400000
    1f68:	053a0000 	ldreq	r0, [sl, #-0]!
    1f6c:	000012ee 	andeq	r1, r0, lr, ror #5
    1f70:	1513053b 	ldrne	r0, [r3, #-1339]	; 0xfffffac5
    1f74:	053c0000 	ldreq	r0, [ip, #-0]!
    1f78:	0000128d 	andeq	r1, r0, sp, lsl #5
    1f7c:	1679053d 			; <UNDEFINED> instruction: 0x1679053d
    1f80:	003e0000 	eorseq	r0, lr, r0
    1f84:	00137506 	andseq	r7, r3, r6, lsl #10
    1f88:	6b010200 	blvs	42790 <__bss_end+0x38b68>
    1f8c:	01ff0802 	mvnseq	r0, r2, lsl #16
    1f90:	38070000 	stmdacc	r7, {}	; <UNPREDICTABLE>
    1f94:	01000015 	tsteq	r0, r5, lsl r0
    1f98:	47140270 			; <UNDEFINED> instruction: 0x47140270
    1f9c:	00000000 	andeq	r0, r0, r0
    1fa0:	00145107 	andseq	r5, r4, r7, lsl #2
    1fa4:	02710100 	rsbseq	r0, r1, #0, 2
    1fa8:	00004714 	andeq	r4, r0, r4, lsl r7
    1fac:	08000100 	stmdaeq	r0, {r8}
    1fb0:	000001d4 	ldrdeq	r0, [r0], -r4
    1fb4:	0001ff09 	andeq	pc, r1, r9, lsl #30
    1fb8:	00021400 	andeq	r1, r2, r0, lsl #8
    1fbc:	00240a00 	eoreq	r0, r4, r0, lsl #20
    1fc0:	00110000 	andseq	r0, r1, r0
    1fc4:	00020408 	andeq	r0, r2, r8, lsl #8
    1fc8:	15fc0b00 	ldrbne	r0, [ip, #2816]!	; 0xb00
    1fcc:	74010000 	strvc	r0, [r1], #-0
    1fd0:	02142602 	andseq	r2, r4, #2097152	; 0x200000
    1fd4:	3a240000 	bcc	901fdc <__bss_end+0x8f83b4>
    1fd8:	0f3d0a3d 	svceq	0x003d0a3d
    1fdc:	323d243d 	eorscc	r2, sp, #1023410176	; 0x3d000000
    1fe0:	053d023d 	ldreq	r0, [sp, #-573]!	; 0xfffffdc3
    1fe4:	0d3d133d 	ldceq	3, cr1, [sp, #-244]!	; 0xffffff0c
    1fe8:	233d0c3d 	teqcs	sp, #15616	; 0x3d00
    1fec:	263d113d 			; <UNDEFINED> instruction: 0x263d113d
    1ff0:	173d013d 			; <UNDEFINED> instruction: 0x173d013d
    1ff4:	093d083d 	ldmdbeq	sp!, {r0, r2, r3, r4, r5, fp}
    1ff8:	0300003d 	movweq	r0, #61	; 0x3d
    1ffc:	07340702 	ldreq	r0, [r4, -r2, lsl #14]!
    2000:	01030000 	mrseq	r0, (UNDEF: 3)
    2004:	00092508 	andeq	r2, r9, r8, lsl #10
    2008:	040d0c00 	streq	r0, [sp], #-3072	; 0xfffff400
    200c:	00000259 	andeq	r0, r0, r9, asr r2
    2010:	0017bc0e 	andseq	fp, r7, lr, lsl #24
    2014:	39010700 	stmdbcc	r1, {r8, r9, sl}
    2018:	02000000 	andeq	r0, r0, #0
    201c:	9e0604f7 	mcrls	4, 0, r0, cr6, cr7, {7}
    2020:	05000002 	streq	r0, [r0, #-2]
    2024:	0000134f 	andeq	r1, r0, pc, asr #6
    2028:	135a0500 	cmpne	sl, #0, 10
    202c:	05010000 	streq	r0, [r1, #-0]
    2030:	0000136c 	andeq	r1, r0, ip, ror #6
    2034:	13860502 	orrne	r0, r6, #8388608	; 0x800000
    2038:	05030000 	streq	r0, [r3, #-0]
    203c:	000016f6 	strdeq	r1, [r0], -r6
    2040:	14650504 	strbtne	r0, [r5], #-1284	; 0xfffffafc
    2044:	05050000 	streq	r0, [r5, #-0]
    2048:	000016af 	andeq	r1, r0, pc, lsr #13
    204c:	02030006 	andeq	r0, r3, #6
    2050:	00097105 	andeq	r7, r9, r5, lsl #2
    2054:	07080300 	streq	r0, [r8, -r0, lsl #6]
    2058:	00001595 	muleq	r0, r5, r5
    205c:	a6040403 	strge	r0, [r4], -r3, lsl #8
    2060:	03000012 	movweq	r0, #18
    2064:	129e0308 	addsne	r0, lr, #8, 6	; 0x20000000
    2068:	08030000 	stmdaeq	r3, {}	; <UNPREDICTABLE>
    206c:	00154f04 	andseq	r4, r5, r4, lsl #30
    2070:	03100300 	tsteq	r0, #0, 6
    2074:	000016a0 	andeq	r1, r0, r0, lsr #13
    2078:	0016970f 	andseq	r9, r6, pc, lsl #14
    207c:	102a0300 	eorne	r0, sl, r0, lsl #6
    2080:	0000025a 	andeq	r0, r0, sl, asr r2
    2084:	0002c809 	andeq	ip, r2, r9, lsl #16
    2088:	0002df00 	andeq	sp, r2, r0, lsl #30
    208c:	11001000 	mrsne	r1, (UNDEF: 0)
    2090:	0000030c 	andeq	r0, r0, ip, lsl #6
    2094:	d4112f03 	ldrle	r2, [r1], #-3843	; 0xfffff0fd
    2098:	11000002 	tstne	r0, r2
    209c:	00000200 	andeq	r0, r0, r0, lsl #4
    20a0:	d4113003 	ldrle	r3, [r1], #-3
    20a4:	09000002 	stmdbeq	r0, {r1}
    20a8:	000002c8 	andeq	r0, r0, r8, asr #5
    20ac:	00000307 	andeq	r0, r0, r7, lsl #6
    20b0:	0000240a 	andeq	r2, r0, sl, lsl #8
    20b4:	12000100 	andne	r0, r0, #0, 2
    20b8:	000002df 	ldrdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    20bc:	0a093304 	beq	24ecd4 <__bss_end+0x2450ac>
    20c0:	000002f7 	strdeq	r0, [r0], -r7
    20c4:	9c180305 	ldcls	3, cr0, [r8], {5}
    20c8:	eb120000 	bl	4820d0 <__bss_end+0x4784a8>
    20cc:	04000002 	streq	r0, [r0], #-2
    20d0:	f70a0934 			; <UNDEFINED> instruction: 0xf70a0934
    20d4:	05000002 	streq	r0, [r0, #-2]
    20d8:	009c1803 	addseq	r1, ip, r3, lsl #16
    20dc:	03060000 	movweq	r0, #24576	; 0x6000
    20e0:	00040000 	andeq	r0, r4, r0
    20e4:	00000927 	andeq	r0, r0, r7, lsr #18
    20e8:	139d0104 	orrsne	r0, sp, #4, 2
    20ec:	560c0000 	strpl	r0, [ip], -r0
    20f0:	ac000015 	stcge	0, cr0, [r0], {21}
    20f4:	b0000011 	andlt	r0, r0, r1, lsl r0
    20f8:	30000099 	mulcc	r0, r9, r0
    20fc:	32000000 	andcc	r0, r0, #0
    2100:	0200000e 	andeq	r0, r0, #14
    2104:	12a60404 	adcne	r0, r6, #4, 8	; 0x4000000
    2108:	04030000 	streq	r0, [r3], #-0
    210c:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
    2110:	07040200 	streq	r0, [r4, -r0, lsl #4]
    2114:	0000159f 	muleq	r0, pc, r5	; <UNPREDICTABLE>
    2118:	43050802 	movwmi	r0, #22530	; 0x5802
    211c:	02000002 	andeq	r0, r0, #2
    2120:	154a0408 	strbne	r0, [sl, #-1032]	; 0xfffffbf8
    2124:	01020000 	mrseq	r0, (UNDEF: 2)
    2128:	00091c08 	andeq	r1, r9, r8, lsl #24
    212c:	06010200 	streq	r0, [r1], -r0, lsl #4
    2130:	0000091e 	andeq	r0, r0, lr, lsl r9
    2134:	00172204 	andseq	r2, r7, r4, lsl #4
    2138:	48010700 	stmdami	r1, {r8, r9, sl}
    213c:	02000000 	andeq	r0, r0, #0
    2140:	01e30617 	mvneq	r0, r7, lsl r6
    2144:	ac050000 	stcge	0, cr0, [r5], {-0}
    2148:	00000012 	andeq	r0, r0, r2, lsl r0
    214c:	0017d105 	andseq	sp, r7, r5, lsl #2
    2150:	7f050100 	svcvc	0x00050100
    2154:	02000014 	andeq	r0, r0, #20
    2158:	00153d05 	andseq	r3, r5, r5, lsl #26
    215c:	3b050300 	blcc	142d64 <__bss_end+0x13913c>
    2160:	04000017 	streq	r0, [r0], #-23	; 0xffffffe9
    2164:	0017e105 	andseq	lr, r7, r5, lsl #2
    2168:	51050500 	tstpl	r5, r0, lsl #10
    216c:	06000017 			; <UNDEFINED> instruction: 0x06000017
    2170:	00158605 	andseq	r8, r5, r5, lsl #12
    2174:	cc050700 	stcgt	7, cr0, [r5], {-0}
    2178:	08000016 	stmdaeq	r0, {r1, r2, r4}
    217c:	0016da05 	andseq	sp, r6, r5, lsl #20
    2180:	e8050900 	stmda	r5, {r8, fp}
    2184:	0a000016 	beq	21e4 <shift+0x21e4>
    2188:	0015ef05 	andseq	lr, r5, r5, lsl #30
    218c:	df050b00 	svcle	0x00050b00
    2190:	0c000015 	stceq	0, cr0, [r0], {21}
    2194:	0012c805 	andseq	ip, r2, r5, lsl #16
    2198:	e1050d00 	tst	r5, r0, lsl #26
    219c:	0e000012 	mcreq	0, 0, r0, cr0, cr2, {0}
    21a0:	0015d005 	andseq	sp, r5, r5
    21a4:	94050f00 	strls	r0, [r5], #-3840	; 0xfffff100
    21a8:	10000017 	andne	r0, r0, r7, lsl r0
    21ac:	00171105 	andseq	r1, r7, r5, lsl #2
    21b0:	85051100 	strhi	r1, [r5, #-256]	; 0xffffff00
    21b4:	12000017 	andne	r0, r0, #23
    21b8:	00138e05 	andseq	r8, r3, r5, lsl #28
    21bc:	0b051300 	bleq	146dc4 <__bss_end+0x13d19c>
    21c0:	14000013 	strne	r0, [r0], #-19	; 0xffffffed
    21c4:	0012d505 	andseq	sp, r2, r5, lsl #10
    21c8:	6e051500 	cfsh32vs	mvfx1, mvfx5, #0
    21cc:	16000016 			; <UNDEFINED> instruction: 0x16000016
    21d0:	00134205 	andseq	r4, r3, r5, lsl #4
    21d4:	7d051700 	stcvc	7, cr1, [r5, #-0]
    21d8:	18000012 	stmdane	r0, {r1, r4}
    21dc:	00177705 	andseq	r7, r7, r5, lsl #14
    21e0:	ac051900 			; <UNDEFINED> instruction: 0xac051900
    21e4:	1a000015 	bne	2240 <shift+0x2240>
    21e8:	00168605 	andseq	r8, r6, r5, lsl #12
    21ec:	16051b00 	strne	r1, [r5], -r0, lsl #22
    21f0:	1c000013 	stcne	0, cr0, [r0], {19}
    21f4:	00152205 	andseq	r2, r5, r5, lsl #4
    21f8:	71051d00 	tstvc	r5, r0, lsl #26
    21fc:	1e000014 	mcrne	0, 0, r0, cr0, cr4, {0}
    2200:	00170305 	andseq	r0, r7, r5, lsl #6
    2204:	5f051f00 	svcpl	0x00051f00
    2208:	20000017 	andcs	r0, r0, r7, lsl r0
    220c:	0017a005 	andseq	sl, r7, r5
    2210:	ae052100 	adfges	f2, f5, f0
    2214:	22000017 	andcs	r0, r0, #23
    2218:	0015c305 	andseq	ip, r5, r5, lsl #6
    221c:	e6052300 	str	r2, [r5], -r0, lsl #6
    2220:	24000014 	strcs	r0, [r0], #-20	; 0xffffffec
    2224:	00132505 	andseq	r2, r3, r5, lsl #10
    2228:	79052500 	stmdbvc	r5, {r8, sl, sp}
    222c:	26000015 			; <UNDEFINED> instruction: 0x26000015
    2230:	00148b05 	andseq	r8, r4, r5, lsl #22
    2234:	2e052700 	cdpcs	7, 0, cr2, cr5, cr0, {0}
    2238:	28000017 	stmdacs	r0, {r0, r1, r2, r4}
    223c:	00149b05 	andseq	r9, r4, r5, lsl #22
    2240:	aa052900 	bge	14c648 <__bss_end+0x142a20>
    2244:	2a000014 	bcs	229c <shift+0x229c>
    2248:	0014b905 	andseq	fp, r4, r5, lsl #18
    224c:	c8052b00 	stmdagt	r5, {r8, r9, fp, sp}
    2250:	2c000014 	stccs	0, cr0, [r0], {20}
    2254:	00145605 	andseq	r5, r4, r5, lsl #12
    2258:	d7052d00 	strle	r2, [r5, -r0, lsl #26]
    225c:	2e000014 	mcrcs	0, 0, r0, cr0, cr4, {0}
    2260:	0016bd05 	andseq	fp, r6, r5, lsl #26
    2264:	f5052f00 			; <UNDEFINED> instruction: 0xf5052f00
    2268:	30000014 	andcc	r0, r0, r4, lsl r0
    226c:	00150405 	andseq	r0, r5, r5, lsl #8
    2270:	b6053100 	strlt	r3, [r5], -r0, lsl #2
    2274:	32000012 	andcc	r0, r0, #18
    2278:	00160e05 	andseq	r0, r6, r5, lsl #28
    227c:	1e053300 	cdpne	3, 0, cr3, cr5, cr0, {0}
    2280:	34000016 	strcc	r0, [r0], #-22	; 0xffffffea
    2284:	00162e05 	andseq	r2, r6, r5, lsl #28
    2288:	44053500 	strmi	r3, [r5], #-1280	; 0xfffffb00
    228c:	36000014 			; <UNDEFINED> instruction: 0x36000014
    2290:	00163e05 	andseq	r3, r6, r5, lsl #28
    2294:	4e053700 	cdpmi	7, 0, cr3, cr5, cr0, {0}
    2298:	38000016 	stmdacc	r0, {r1, r2, r4}
    229c:	00165e05 	andseq	r5, r6, r5, lsl #28
    22a0:	35053900 	strcc	r3, [r5, #-2304]	; 0xfffff700
    22a4:	3a000013 	bcc	22f8 <shift+0x22f8>
    22a8:	0012ee05 	andseq	lr, r2, r5, lsl #28
    22ac:	13053b00 	movwne	r3, #23296	; 0x5b00
    22b0:	3c000015 	stccc	0, cr0, [r0], {21}
    22b4:	00128d05 	andseq	r8, r2, r5, lsl #26
    22b8:	79053d00 	stmdbvc	r5, {r8, sl, fp, ip, sp}
    22bc:	3e000016 	mcrcc	0, 0, r0, cr0, cr6, {0}
    22c0:	13750600 	cmnne	r5, #0, 12
    22c4:	02020000 	andeq	r0, r2, #0
    22c8:	0e08026b 	cdpeq	2, 0, cr0, cr8, cr11, {3}
    22cc:	07000002 	streq	r0, [r0, -r2]
    22d0:	00001538 	andeq	r1, r0, r8, lsr r5
    22d4:	14027002 	strne	r7, [r2], #-2
    22d8:	00000056 	andeq	r0, r0, r6, asr r0
    22dc:	14510700 	ldrbne	r0, [r1], #-1792	; 0xfffff900
    22e0:	71020000 	mrsvc	r0, (UNDEF: 2)
    22e4:	00561402 	subseq	r1, r6, r2, lsl #8
    22e8:	00010000 	andeq	r0, r1, r0
    22ec:	0001e308 	andeq	lr, r1, r8, lsl #6
    22f0:	020e0900 	andeq	r0, lr, #0, 18
    22f4:	02230000 	eoreq	r0, r3, #0
    22f8:	330a0000 	movwcc	r0, #40960	; 0xa000
    22fc:	11000000 	mrsne	r0, (UNDEF: 0)
    2300:	02130800 	andseq	r0, r3, #0, 16
    2304:	fc0b0000 	stc2	0, cr0, [fp], {-0}
    2308:	02000015 	andeq	r0, r0, #21
    230c:	23260274 			; <UNDEFINED> instruction: 0x23260274
    2310:	24000002 	strcs	r0, [r0], #-2
    2314:	3d0a3d3a 	stccc	13, cr3, [sl, #-232]	; 0xffffff18
    2318:	3d243d0f 	stccc	13, cr3, [r4, #-60]!	; 0xffffffc4
    231c:	3d023d32 	stccc	13, cr3, [r2, #-200]	; 0xffffff38
    2320:	3d133d05 	ldccc	13, cr3, [r3, #-20]	; 0xffffffec
    2324:	3d0c3d0d 	stccc	13, cr3, [ip, #-52]	; 0xffffffcc
    2328:	3d113d23 	ldccc	13, cr3, [r1, #-140]	; 0xffffff74
    232c:	3d013d26 	stccc	13, cr3, [r1, #-152]	; 0xffffff68
    2330:	3d083d17 	stccc	13, cr3, [r8, #-92]	; 0xffffffa4
    2334:	00003d09 	andeq	r3, r0, r9, lsl #26
    2338:	34070202 	strcc	r0, [r7], #-514	; 0xfffffdfe
    233c:	02000007 	andeq	r0, r0, #7
    2340:	09250801 	stmdbeq	r5!, {r0, fp}
    2344:	02020000 	andeq	r0, r2, #0
    2348:	00097105 	andeq	r7, r9, r5, lsl #2
    234c:	182d0c00 	stmdane	sp!, {sl, fp}
    2350:	84030000 	strhi	r0, [r3], #-0
    2354:	00003a0f 	andeq	r3, r0, pc, lsl #20
    2358:	07080200 	streq	r0, [r8, -r0, lsl #4]
    235c:	00001595 	muleq	r0, r5, r5
    2360:	0017fe0c 	andseq	pc, r7, ip, lsl #28
    2364:	10930300 	addsne	r0, r3, r0, lsl #6
    2368:	00000025 	andeq	r0, r0, r5, lsr #32
    236c:	9e030802 	cdpls	8, 0, cr0, cr3, cr2, {0}
    2370:	02000012 	andeq	r0, r0, #18
    2374:	154f0408 	strbne	r0, [pc, #-1032]	; 1f74 <shift+0x1f74>
    2378:	10020000 	andne	r0, r2, r0
    237c:	0016a003 	andseq	sl, r6, r3
    2380:	18130d00 	ldmdane	r3, {r8, sl, fp}
    2384:	f9010000 			; <UNDEFINED> instruction: 0xf9010000
    2388:	026f0105 	rsbeq	r0, pc, #1073741825	; 0x40000001
    238c:	99b00000 	ldmibls	r0!, {}	; <UNPREDICTABLE>
    2390:	00300000 	eorseq	r0, r0, r0
    2394:	9c010000 	stcls	0, cr0, [r1], {-0}
    2398:	000002fd 	strdeq	r0, [r0], -sp
    239c:	0100610e 	tsteq	r0, lr, lsl #2
    23a0:	821305f9 	andshi	r0, r3, #1044381696	; 0x3e400000
    23a4:	08000002 	stmdaeq	r0, {r1}
    23a8:	00000000 	andeq	r0, r0, r0
    23ac:	0f000000 	svceq	0x00000000
    23b0:	000099c4 	andeq	r9, r0, r4, asr #19
    23b4:	000002fd 	strdeq	r0, [r0], -sp
    23b8:	000002e8 	andeq	r0, r0, r8, ror #5
    23bc:	05500110 	ldrbeq	r0, [r0, #-272]	; 0xfffffef0
    23c0:	00f503f3 	ldrshteq	r0, [r5], #51	; 0x33
    23c4:	d4110025 	ldrle	r0, [r1], #-37	; 0xffffffdb
    23c8:	fd000099 	stc2	0, cr0, [r0, #-612]	; 0xfffffd9c
    23cc:	10000002 	andne	r0, r0, r2
    23d0:	f3065001 	vhadd.u8	d5, d6, d1
    23d4:	2500f503 	strcs	pc, [r0, #-1283]	; 0xfffffafd
    23d8:	1200001f 	andne	r0, r0, #31
    23dc:	00001805 	andeq	r1, r0, r5, lsl #16
    23e0:	000017f1 	strdeq	r1, [r0], -r1	; <UNPREDICTABLE>
    23e4:	00033b01 	andeq	r3, r3, r1, lsl #22
    23e8:	0000032a 	andeq	r0, r0, sl, lsr #6
    23ec:	0a360004 	beq	d82404 <__bss_end+0xd787dc>
    23f0:	01040000 	mrseq	r0, (UNDEF: 4)
    23f4:	0000139d 	muleq	r0, sp, r3
    23f8:	0015560c 	andseq	r5, r5, ip, lsl #12
    23fc:	0011ac00 	andseq	sl, r1, r0, lsl #24
    2400:	0099e000 	addseq	lr, r9, r0
    2404:	00004000 	andeq	r4, r0, r0
    2408:	000edd00 	andeq	sp, lr, r0, lsl #26
    240c:	04080200 	streq	r0, [r8], #-512	; 0xfffffe00
    2410:	0000154f 	andeq	r1, r0, pc, asr #10
    2414:	9f070402 	svcls	0x00070402
    2418:	02000015 	andeq	r0, r0, #21
    241c:	12a60404 	adcne	r0, r6, #4, 8	; 0x4000000
    2420:	04030000 	streq	r0, [r3], #-0
    2424:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
    2428:	05080200 	streq	r0, [r8, #-512]	; 0xfffffe00
    242c:	00000243 	andeq	r0, r0, r3, asr #4
    2430:	4a040802 	bmi	104440 <__bss_end+0xfa818>
    2434:	02000015 	andeq	r0, r0, #21
    2438:	091c0801 	ldmdbeq	ip, {r0, fp}
    243c:	01020000 	mrseq	r0, (UNDEF: 2)
    2440:	00091e06 	andeq	r1, r9, r6, lsl #28
    2444:	17220400 	strne	r0, [r2, -r0, lsl #8]!
    2448:	01070000 	mrseq	r0, (UNDEF: 7)
    244c:	0000004f 	andeq	r0, r0, pc, asr #32
    2450:	ea061702 	b	188060 <__bss_end+0x17e438>
    2454:	05000001 	streq	r0, [r0, #-1]
    2458:	000012ac 	andeq	r1, r0, ip, lsr #5
    245c:	17d10500 	ldrbne	r0, [r1, r0, lsl #10]
    2460:	05010000 	streq	r0, [r1, #-0]
    2464:	0000147f 	andeq	r1, r0, pc, ror r4
    2468:	153d0502 	ldrne	r0, [sp, #-1282]!	; 0xfffffafe
    246c:	05030000 	streq	r0, [r3, #-0]
    2470:	0000173b 	andeq	r1, r0, fp, lsr r7
    2474:	17e10504 	strbne	r0, [r1, r4, lsl #10]!
    2478:	05050000 	streq	r0, [r5, #-0]
    247c:	00001751 	andeq	r1, r0, r1, asr r7
    2480:	15860506 	strne	r0, [r6, #1286]	; 0x506
    2484:	05070000 	streq	r0, [r7, #-0]
    2488:	000016cc 	andeq	r1, r0, ip, asr #13
    248c:	16da0508 	ldrbne	r0, [sl], r8, lsl #10
    2490:	05090000 	streq	r0, [r9, #-0]
    2494:	000016e8 	andeq	r1, r0, r8, ror #13
    2498:	15ef050a 	strbne	r0, [pc, #1290]!	; 29aa <shift+0x29aa>
    249c:	050b0000 	streq	r0, [fp, #-0]
    24a0:	000015df 	ldrdeq	r1, [r0], -pc	; <UNPREDICTABLE>
    24a4:	12c8050c 	sbcne	r0, r8, #12, 10	; 0x3000000
    24a8:	050d0000 	streq	r0, [sp, #-0]
    24ac:	000012e1 	andeq	r1, r0, r1, ror #5
    24b0:	15d0050e 	ldrbne	r0, [r0, #1294]	; 0x50e
    24b4:	050f0000 	streq	r0, [pc, #-0]	; 24bc <shift+0x24bc>
    24b8:	00001794 	muleq	r0, r4, r7
    24bc:	17110510 			; <UNDEFINED> instruction: 0x17110510
    24c0:	05110000 	ldreq	r0, [r1, #-0]
    24c4:	00001785 	andeq	r1, r0, r5, lsl #15
    24c8:	138e0512 	orrne	r0, lr, #75497472	; 0x4800000
    24cc:	05130000 	ldreq	r0, [r3, #-0]
    24d0:	0000130b 	andeq	r1, r0, fp, lsl #6
    24d4:	12d50514 	sbcsne	r0, r5, #20, 10	; 0x5000000
    24d8:	05150000 	ldreq	r0, [r5, #-0]
    24dc:	0000166e 	andeq	r1, r0, lr, ror #12
    24e0:	13420516 	movtne	r0, #9494	; 0x2516
    24e4:	05170000 	ldreq	r0, [r7, #-0]
    24e8:	0000127d 	andeq	r1, r0, sp, ror r2
    24ec:	17770518 			; <UNDEFINED> instruction: 0x17770518
    24f0:	05190000 	ldreq	r0, [r9, #-0]
    24f4:	000015ac 	andeq	r1, r0, ip, lsr #11
    24f8:	1686051a 	pkhbtne	r0, r6, sl, lsl #10
    24fc:	051b0000 	ldreq	r0, [fp, #-0]
    2500:	00001316 	andeq	r1, r0, r6, lsl r3
    2504:	1522051c 	strne	r0, [r2, #-1308]!	; 0xfffffae4
    2508:	051d0000 	ldreq	r0, [sp, #-0]
    250c:	00001471 	andeq	r1, r0, r1, ror r4
    2510:	1703051e 	smladne	r3, lr, r5, r0
    2514:	051f0000 	ldreq	r0, [pc, #-0]	; 251c <shift+0x251c>
    2518:	0000175f 	andeq	r1, r0, pc, asr r7
    251c:	17a00520 	strne	r0, [r0, r0, lsr #10]!
    2520:	05210000 	streq	r0, [r1, #-0]!
    2524:	000017ae 	andeq	r1, r0, lr, lsr #15
    2528:	15c30522 	strbne	r0, [r3, #1314]	; 0x522
    252c:	05230000 	streq	r0, [r3, #-0]!
    2530:	000014e6 	andeq	r1, r0, r6, ror #9
    2534:	13250524 			; <UNDEFINED> instruction: 0x13250524
    2538:	05250000 	streq	r0, [r5, #-0]!
    253c:	00001579 	andeq	r1, r0, r9, ror r5
    2540:	148b0526 	strne	r0, [fp], #1318	; 0x526
    2544:	05270000 	streq	r0, [r7, #-0]!
    2548:	0000172e 	andeq	r1, r0, lr, lsr #14
    254c:	149b0528 	ldrne	r0, [fp], #1320	; 0x528
    2550:	05290000 	streq	r0, [r9, #-0]!
    2554:	000014aa 	andeq	r1, r0, sl, lsr #9
    2558:	14b9052a 	ldrtne	r0, [r9], #1322	; 0x52a
    255c:	052b0000 	streq	r0, [fp, #-0]!
    2560:	000014c8 	andeq	r1, r0, r8, asr #9
    2564:	1456052c 	ldrbne	r0, [r6], #-1324	; 0xfffffad4
    2568:	052d0000 	streq	r0, [sp, #-0]!
    256c:	000014d7 	ldrdeq	r1, [r0], -r7
    2570:	16bd052e 	ldrtne	r0, [sp], lr, lsr #10
    2574:	052f0000 	streq	r0, [pc, #-0]!	; 257c <shift+0x257c>
    2578:	000014f5 	strdeq	r1, [r0], -r5
    257c:	15040530 	strne	r0, [r4, #-1328]	; 0xfffffad0
    2580:	05310000 	ldreq	r0, [r1, #-0]!
    2584:	000012b6 			; <UNDEFINED> instruction: 0x000012b6
    2588:	160e0532 			; <UNDEFINED> instruction: 0x160e0532
    258c:	05330000 	ldreq	r0, [r3, #-0]!
    2590:	0000161e 	andeq	r1, r0, lr, lsl r6
    2594:	162e0534 			; <UNDEFINED> instruction: 0x162e0534
    2598:	05350000 	ldreq	r0, [r5, #-0]!
    259c:	00001444 	andeq	r1, r0, r4, asr #8
    25a0:	163e0536 			; <UNDEFINED> instruction: 0x163e0536
    25a4:	05370000 	ldreq	r0, [r7, #-0]!
    25a8:	0000164e 	andeq	r1, r0, lr, asr #12
    25ac:	165e0538 			; <UNDEFINED> instruction: 0x165e0538
    25b0:	05390000 	ldreq	r0, [r9, #-0]!
    25b4:	00001335 	andeq	r1, r0, r5, lsr r3
    25b8:	12ee053a 	rscne	r0, lr, #243269632	; 0xe800000
    25bc:	053b0000 	ldreq	r0, [fp, #-0]!
    25c0:	00001513 	andeq	r1, r0, r3, lsl r5
    25c4:	128d053c 	addne	r0, sp, #60, 10	; 0xf000000
    25c8:	053d0000 	ldreq	r0, [sp, #-0]!
    25cc:	00001679 	andeq	r1, r0, r9, ror r6
    25d0:	7506003e 	strvc	r0, [r6, #-62]	; 0xffffffc2
    25d4:	02000013 	andeq	r0, r0, #19
    25d8:	08026b02 	stmdaeq	r2, {r1, r8, r9, fp, sp, lr}
    25dc:	00000215 	andeq	r0, r0, r5, lsl r2
    25e0:	00153807 	andseq	r3, r5, r7, lsl #16
    25e4:	02700200 	rsbseq	r0, r0, #0, 4
    25e8:	00005d14 	andeq	r5, r0, r4, lsl sp
    25ec:	51070000 	mrspl	r0, (UNDEF: 7)
    25f0:	02000014 	andeq	r0, r0, #20
    25f4:	5d140271 	lfmpl	f0, 4, [r4, #-452]	; 0xfffffe3c
    25f8:	01000000 	mrseq	r0, (UNDEF: 0)
    25fc:	01ea0800 	mvneq	r0, r0, lsl #16
    2600:	15090000 	strne	r0, [r9, #-0]
    2604:	2a000002 	bcs	2614 <shift+0x2614>
    2608:	0a000002 	beq	2618 <shift+0x2618>
    260c:	0000002c 	andeq	r0, r0, ip, lsr #32
    2610:	1a080011 	bne	20265c <__bss_end+0x1f8a34>
    2614:	0b000002 	bleq	2624 <shift+0x2624>
    2618:	000015fc 	strdeq	r1, [r0], -ip
    261c:	26027402 	strcs	r7, [r2], -r2, lsl #8
    2620:	0000022a 	andeq	r0, r0, sl, lsr #4
    2624:	0a3d3a24 	beq	f50ebc <__bss_end+0xf47294>
    2628:	243d0f3d 	ldrtcs	r0, [sp], #-3901	; 0xfffff0c3
    262c:	023d323d 	eorseq	r3, sp, #-805306365	; 0xd0000003
    2630:	133d053d 	teqne	sp, #255852544	; 0xf400000
    2634:	0c3d0d3d 	ldceq	13, cr0, [sp], #-244	; 0xffffff0c
    2638:	113d233d 	teqne	sp, sp, lsr r3
    263c:	013d263d 	teqeq	sp, sp, lsr r6
    2640:	083d173d 	ldmdaeq	sp!, {r0, r2, r3, r4, r5, r8, r9, sl, ip}
    2644:	003d093d 	eorseq	r0, sp, sp, lsr r9
    2648:	07020200 	streq	r0, [r2, -r0, lsl #4]
    264c:	00000734 	andeq	r0, r0, r4, lsr r7
    2650:	25080102 	strcs	r0, [r8, #-258]	; 0xfffffefe
    2654:	02000009 	andeq	r0, r0, #9
    2658:	09710502 	ldmdbeq	r1!, {r1, r8, sl}^
    265c:	240c0000 	strcs	r0, [ip], #-0
    2660:	03000018 	movweq	r0, #24
    2664:	002c1681 	eoreq	r1, ip, r1, lsl #13
    2668:	76080000 	strvc	r0, [r8], -r0
    266c:	0c000002 	stceq	0, cr0, [r0], {2}
    2670:	0000182c 	andeq	r1, r0, ip, lsr #16
    2674:	93168503 	tstls	r6, #12582912	; 0xc00000
    2678:	02000002 	andeq	r0, r0, #2
    267c:	15950708 	ldrne	r0, [r5, #1800]	; 0x708
    2680:	fe0c0000 	cdp2	0, 0, cr0, cr12, cr0, {0}
    2684:	03000017 	movweq	r0, #23
    2688:	00331093 	mlaseq	r3, r3, r0, r1
    268c:	08020000 	stmdaeq	r2, {}	; <UNPREDICTABLE>
    2690:	00129e03 	andseq	r9, r2, r3, lsl #28
    2694:	181d0c00 	ldmdane	sp, {sl, fp}
    2698:	97030000 	strls	r0, [r3, -r0]
    269c:	00002510 	andeq	r2, r0, r0, lsl r5
    26a0:	02ad0800 	adceq	r0, sp, #0, 16
    26a4:	10020000 	andne	r0, r2, r0
    26a8:	0016a003 	andseq	sl, r6, r3
    26ac:	17f10d00 	ldrbne	r0, [r1, r0, lsl #26]!
    26b0:	b9010000 	stmdblt	r1, {}	; <UNPREDICTABLE>
    26b4:	02870105 	addeq	r0, r7, #1073741825	; 0x40000001
    26b8:	99e00000 	stmibls	r0!, {}^	; <UNPREDICTABLE>
    26bc:	00400000 	subeq	r0, r0, r0
    26c0:	9c010000 	stcls	0, cr0, [r1], {-0}
    26c4:	0100610e 	tsteq	r0, lr, lsl #2
    26c8:	9a1605b9 	bls	583db4 <__bss_end+0x57a18c>
    26cc:	4a000002 	bmi	26dc <shift+0x26dc>
    26d0:	46000000 	strmi	r0, [r0], -r0
    26d4:	0f000000 	svceq	0x00000000
    26d8:	00616664 	rsbeq	r6, r1, r4, ror #12
    26dc:	1005bf01 	andne	fp, r5, r1, lsl #30
    26e0:	000002b9 			; <UNDEFINED> instruction: 0x000002b9
    26e4:	00000073 	andeq	r0, r0, r3, ror r0
    26e8:	0000006d 	andeq	r0, r0, sp, rrx
    26ec:	0069680f 	rsbeq	r6, r9, pc, lsl #16
    26f0:	1005c401 	andne	ip, r5, r1, lsl #8
    26f4:	00000282 	andeq	r0, r0, r2, lsl #5
    26f8:	000000b1 	strheq	r0, [r0], -r1
    26fc:	000000af 	andeq	r0, r0, pc, lsr #1
    2700:	006f6c0f 	rsbeq	r6, pc, pc, lsl #24
    2704:	1005c901 	andne	ip, r5, r1, lsl #18
    2708:	00000282 	andeq	r0, r0, r2, lsl #5
    270c:	000000cb 	andeq	r0, r0, fp, asr #1
    2710:	000000c5 	andeq	r0, r0, r5, asr #1
    2714:	03800000 	orreq	r0, r0, #0
    2718:	00040000 	andeq	r0, r4, r0
    271c:	00000b1d 	andeq	r0, r0, sp, lsl fp
    2720:	18340104 	ldmdane	r4!, {r2, r8}
    2724:	560c0000 	strpl	r0, [ip], -r0
    2728:	ac000015 	stcge	0, cr0, [r0], {21}
    272c:	20000011 	andcs	r0, r0, r1, lsl r0
    2730:	2000009a 	mulcs	r0, sl, r0
    2734:	97000001 	strls	r0, [r0, -r1]
    2738:	0200000f 	andeq	r0, r0, #15
    273c:	15950708 	ldrne	r0, [r5, #1800]	; 0x708
    2740:	04030000 	streq	r0, [r3], #-0
    2744:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
    2748:	07040200 	streq	r0, [r4, -r0, lsl #4]
    274c:	0000159f 	muleq	r0, pc, r5	; <UNPREDICTABLE>
    2750:	43050802 	movwmi	r0, #22530	; 0x5802
    2754:	02000002 	andeq	r0, r0, #2
    2758:	154a0408 	strbne	r0, [sl, #-1032]	; 0xfffffbf8
    275c:	01020000 	mrseq	r0, (UNDEF: 2)
    2760:	00091c08 	andeq	r1, r9, r8, lsl #24
    2764:	06010200 	streq	r0, [r1], -r0, lsl #4
    2768:	0000091e 	andeq	r0, r0, lr, lsl r9
    276c:	00172204 	andseq	r2, r7, r4, lsl #4
    2770:	48010700 	stmdami	r1, {r8, r9, sl}
    2774:	02000000 	andeq	r0, r0, #0
    2778:	01e30617 	mvneq	r0, r7, lsl r6
    277c:	ac050000 	stcge	0, cr0, [r5], {-0}
    2780:	00000012 	andeq	r0, r0, r2, lsl r0
    2784:	0017d105 	andseq	sp, r7, r5, lsl #2
    2788:	7f050100 	svcvc	0x00050100
    278c:	02000014 	andeq	r0, r0, #20
    2790:	00153d05 	andseq	r3, r5, r5, lsl #26
    2794:	3b050300 	blcc	14339c <__bss_end+0x139774>
    2798:	04000017 	streq	r0, [r0], #-23	; 0xffffffe9
    279c:	0017e105 	andseq	lr, r7, r5, lsl #2
    27a0:	51050500 	tstpl	r5, r0, lsl #10
    27a4:	06000017 			; <UNDEFINED> instruction: 0x06000017
    27a8:	00158605 	andseq	r8, r5, r5, lsl #12
    27ac:	cc050700 	stcgt	7, cr0, [r5], {-0}
    27b0:	08000016 	stmdaeq	r0, {r1, r2, r4}
    27b4:	0016da05 	andseq	sp, r6, r5, lsl #20
    27b8:	e8050900 	stmda	r5, {r8, fp}
    27bc:	0a000016 	beq	281c <shift+0x281c>
    27c0:	0015ef05 	andseq	lr, r5, r5, lsl #30
    27c4:	df050b00 	svcle	0x00050b00
    27c8:	0c000015 	stceq	0, cr0, [r0], {21}
    27cc:	0012c805 	andseq	ip, r2, r5, lsl #16
    27d0:	e1050d00 	tst	r5, r0, lsl #26
    27d4:	0e000012 	mcreq	0, 0, r0, cr0, cr2, {0}
    27d8:	0015d005 	andseq	sp, r5, r5
    27dc:	94050f00 	strls	r0, [r5], #-3840	; 0xfffff100
    27e0:	10000017 	andne	r0, r0, r7, lsl r0
    27e4:	00171105 	andseq	r1, r7, r5, lsl #2
    27e8:	85051100 	strhi	r1, [r5, #-256]	; 0xffffff00
    27ec:	12000017 	andne	r0, r0, #23
    27f0:	00138e05 	andseq	r8, r3, r5, lsl #28
    27f4:	0b051300 	bleq	1473fc <__bss_end+0x13d7d4>
    27f8:	14000013 	strne	r0, [r0], #-19	; 0xffffffed
    27fc:	0012d505 	andseq	sp, r2, r5, lsl #10
    2800:	6e051500 	cfsh32vs	mvfx1, mvfx5, #0
    2804:	16000016 			; <UNDEFINED> instruction: 0x16000016
    2808:	00134205 	andseq	r4, r3, r5, lsl #4
    280c:	7d051700 	stcvc	7, cr1, [r5, #-0]
    2810:	18000012 	stmdane	r0, {r1, r4}
    2814:	00177705 	andseq	r7, r7, r5, lsl #14
    2818:	ac051900 			; <UNDEFINED> instruction: 0xac051900
    281c:	1a000015 	bne	2878 <shift+0x2878>
    2820:	00168605 	andseq	r8, r6, r5, lsl #12
    2824:	16051b00 	strne	r1, [r5], -r0, lsl #22
    2828:	1c000013 	stcne	0, cr0, [r0], {19}
    282c:	00152205 	andseq	r2, r5, r5, lsl #4
    2830:	71051d00 	tstvc	r5, r0, lsl #26
    2834:	1e000014 	mcrne	0, 0, r0, cr0, cr4, {0}
    2838:	00170305 	andseq	r0, r7, r5, lsl #6
    283c:	5f051f00 	svcpl	0x00051f00
    2840:	20000017 	andcs	r0, r0, r7, lsl r0
    2844:	0017a005 	andseq	sl, r7, r5
    2848:	ae052100 	adfges	f2, f5, f0
    284c:	22000017 	andcs	r0, r0, #23
    2850:	0015c305 	andseq	ip, r5, r5, lsl #6
    2854:	e6052300 	str	r2, [r5], -r0, lsl #6
    2858:	24000014 	strcs	r0, [r0], #-20	; 0xffffffec
    285c:	00132505 	andseq	r2, r3, r5, lsl #10
    2860:	79052500 	stmdbvc	r5, {r8, sl, sp}
    2864:	26000015 			; <UNDEFINED> instruction: 0x26000015
    2868:	00148b05 	andseq	r8, r4, r5, lsl #22
    286c:	2e052700 	cdpcs	7, 0, cr2, cr5, cr0, {0}
    2870:	28000017 	stmdacs	r0, {r0, r1, r2, r4}
    2874:	00149b05 	andseq	r9, r4, r5, lsl #22
    2878:	aa052900 	bge	14cc80 <__bss_end+0x143058>
    287c:	2a000014 	bcs	28d4 <shift+0x28d4>
    2880:	0014b905 	andseq	fp, r4, r5, lsl #18
    2884:	c8052b00 	stmdagt	r5, {r8, r9, fp, sp}
    2888:	2c000014 	stccs	0, cr0, [r0], {20}
    288c:	00145605 	andseq	r5, r4, r5, lsl #12
    2890:	d7052d00 	strle	r2, [r5, -r0, lsl #26]
    2894:	2e000014 	mcrcs	0, 0, r0, cr0, cr4, {0}
    2898:	0016bd05 	andseq	fp, r6, r5, lsl #26
    289c:	f5052f00 			; <UNDEFINED> instruction: 0xf5052f00
    28a0:	30000014 	andcc	r0, r0, r4, lsl r0
    28a4:	00150405 	andseq	r0, r5, r5, lsl #8
    28a8:	b6053100 	strlt	r3, [r5], -r0, lsl #2
    28ac:	32000012 	andcc	r0, r0, #18
    28b0:	00160e05 	andseq	r0, r6, r5, lsl #28
    28b4:	1e053300 	cdpne	3, 0, cr3, cr5, cr0, {0}
    28b8:	34000016 	strcc	r0, [r0], #-22	; 0xffffffea
    28bc:	00162e05 	andseq	r2, r6, r5, lsl #28
    28c0:	44053500 	strmi	r3, [r5], #-1280	; 0xfffffb00
    28c4:	36000014 			; <UNDEFINED> instruction: 0x36000014
    28c8:	00163e05 	andseq	r3, r6, r5, lsl #28
    28cc:	4e053700 	cdpmi	7, 0, cr3, cr5, cr0, {0}
    28d0:	38000016 	stmdacc	r0, {r1, r2, r4}
    28d4:	00165e05 	andseq	r5, r6, r5, lsl #28
    28d8:	35053900 	strcc	r3, [r5, #-2304]	; 0xfffff700
    28dc:	3a000013 	bcc	2930 <shift+0x2930>
    28e0:	0012ee05 	andseq	lr, r2, r5, lsl #28
    28e4:	13053b00 	movwne	r3, #23296	; 0x5b00
    28e8:	3c000015 	stccc	0, cr0, [r0], {21}
    28ec:	00128d05 	andseq	r8, r2, r5, lsl #26
    28f0:	79053d00 	stmdbvc	r5, {r8, sl, fp, ip, sp}
    28f4:	3e000016 	mcrcc	0, 0, r0, cr0, cr6, {0}
    28f8:	13750600 	cmnne	r5, #0, 12
    28fc:	02020000 	andeq	r0, r2, #0
    2900:	0e08026b 	cdpeq	2, 0, cr0, cr8, cr11, {3}
    2904:	07000002 	streq	r0, [r0, -r2]
    2908:	00001538 	andeq	r1, r0, r8, lsr r5
    290c:	14027002 	strne	r7, [r2], #-2
    2910:	00000056 	andeq	r0, r0, r6, asr r0
    2914:	14510700 	ldrbne	r0, [r1], #-1792	; 0xfffff900
    2918:	71020000 	mrsvc	r0, (UNDEF: 2)
    291c:	00561402 	subseq	r1, r6, r2, lsl #8
    2920:	00010000 	andeq	r0, r1, r0
    2924:	0001e308 	andeq	lr, r1, r8, lsl #6
    2928:	020e0900 	andeq	r0, lr, #0, 18
    292c:	02230000 	eoreq	r0, r3, #0
    2930:	330a0000 	movwcc	r0, #40960	; 0xa000
    2934:	11000000 	mrsne	r0, (UNDEF: 0)
    2938:	02130800 	andseq	r0, r3, #0, 16
    293c:	fc0b0000 	stc2	0, cr0, [fp], {-0}
    2940:	02000015 	andeq	r0, r0, #21
    2944:	23260274 			; <UNDEFINED> instruction: 0x23260274
    2948:	24000002 	strcs	r0, [r0], #-2
    294c:	3d0a3d3a 	stccc	13, cr3, [sl, #-232]	; 0xffffff18
    2950:	3d243d0f 	stccc	13, cr3, [r4, #-60]!	; 0xffffffc4
    2954:	3d023d32 	stccc	13, cr3, [r2, #-200]	; 0xffffff38
    2958:	3d133d05 	ldccc	13, cr3, [r3, #-20]	; 0xffffffec
    295c:	3d0c3d0d 	stccc	13, cr3, [ip, #-52]	; 0xffffffcc
    2960:	3d113d23 	ldccc	13, cr3, [r1, #-140]	; 0xffffff74
    2964:	3d013d26 	stccc	13, cr3, [r1, #-152]	; 0xffffff68
    2968:	3d083d17 	stccc	13, cr3, [r8, #-92]	; 0xffffffa4
    296c:	00003d09 	andeq	r3, r0, r9, lsl #26
    2970:	34070202 	strcc	r0, [r7], #-514	; 0xfffffdfe
    2974:	02000007 	andeq	r0, r0, #7
    2978:	09250801 	stmdbeq	r5!, {r0, fp}
    297c:	02020000 	andeq	r0, r2, #0
    2980:	00097105 	andeq	r7, r9, r5, lsl #2
    2984:	18240c00 	stmdane	r4!, {sl, fp}
    2988:	81030000 	mrshi	r0, (UNDEF: 3)
    298c:	00003316 	andeq	r3, r0, r6, lsl r3
    2990:	182c0c00 	stmdane	ip!, {sl, fp}
    2994:	85030000 	strhi	r0, [r3, #-0]
    2998:	00002516 	andeq	r2, r0, r6, lsl r5
    299c:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
    29a0:	000012a6 	andeq	r1, r0, r6, lsr #5
    29a4:	9e030802 	cdpls	8, 0, cr0, cr3, cr2, {0}
    29a8:	02000012 	andeq	r0, r0, #18
    29ac:	154f0408 	strbne	r0, [pc, #-1032]	; 25ac <shift+0x25ac>
    29b0:	10020000 	andne	r0, r2, r0
    29b4:	0016a003 	andseq	sl, r6, r3
    29b8:	18e80d00 	stmiane	r8!, {r8, sl, fp}^
    29bc:	b3010000 	movwlt	r0, #4096	; 0x1000
    29c0:	027b0103 	rsbseq	r0, fp, #-1073741824	; 0xc0000000
    29c4:	9a200000 	bls	8029cc <__bss_end+0x7f8da4>
    29c8:	01200000 			; <UNDEFINED> instruction: 0x01200000
    29cc:	9c010000 	stcls	0, cr0, [r1], {-0}
    29d0:	0000037d 	andeq	r0, r0, sp, ror r3
    29d4:	01006e0e 	tsteq	r0, lr, lsl #28
    29d8:	7b1703b3 	blvc	5c38ac <__bss_end+0x5b9c84>
    29dc:	49000002 	stmdbmi	r0, {r1}
    29e0:	45000001 	strmi	r0, [r0, #-1]
    29e4:	0e000001 	cdpeq	0, 0, cr0, cr0, cr1, {0}
    29e8:	b3010064 	movwlt	r0, #4196	; 0x1064
    29ec:	027b2203 	rsbseq	r2, fp, #805306368	; 0x30000000
    29f0:	01750000 	cmneq	r5, r0
    29f4:	01710000 	cmneq	r1, r0
    29f8:	720f0000 	andvc	r0, pc, #0
    29fc:	b3010070 	movwlt	r0, #4208	; 0x1070
    2a00:	037d2e03 	cmneq	sp, #3, 28	; 0x30
    2a04:	91020000 	mrsls	r0, (UNDEF: 2)
    2a08:	00711000 	rsbseq	r1, r1, r0
    2a0c:	0b03b501 	bleq	efe18 <__bss_end+0xe61f0>
    2a10:	0000027b 	andeq	r0, r0, fp, ror r2
    2a14:	000001a5 	andeq	r0, r0, r5, lsr #3
    2a18:	0000019d 	muleq	r0, sp, r1
    2a1c:	01007210 	tsteq	r0, r0, lsl r2
    2a20:	7b1203b5 	blvc	4838fc <__bss_end+0x479cd4>
    2a24:	fb000002 	blx	2a36 <shift+0x2a36>
    2a28:	f1000001 	cps	#1
    2a2c:	10000001 	andne	r0, r0, r1
    2a30:	b5010079 	strlt	r0, [r1, #-121]	; 0xffffff87
    2a34:	027b1903 	rsbseq	r1, fp, #49152	; 0xc000
    2a38:	02590000 	subseq	r0, r9, #0
    2a3c:	02530000 	subseq	r0, r3, #0
    2a40:	6c100000 	ldcvs	0, cr0, [r0], {-0}
    2a44:	0100317a 	tsteq	r0, sl, ror r1
    2a48:	6f0a03b6 	svcvs	0x000a03b6
    2a4c:	93000002 	movwls	r0, #2
    2a50:	91000002 	tstls	r0, r2
    2a54:	10000002 	andne	r0, r0, r2
    2a58:	00327a6c 	eorseq	r7, r2, ip, ror #20
    2a5c:	0f03b601 	svceq	0x0003b601
    2a60:	0000026f 	andeq	r0, r0, pc, ror #4
    2a64:	000002aa 	andeq	r0, r0, sl, lsr #5
    2a68:	000002a8 	andeq	r0, r0, r8, lsr #5
    2a6c:	01006910 	tsteq	r0, r0, lsl r9
    2a70:	6f1403b6 	svcvs	0x001403b6
    2a74:	c9000002 	stmdbgt	r0, {r1}
    2a78:	bd000002 	stclt	0, cr0, [r0, #-8]
    2a7c:	10000002 	andne	r0, r0, r2
    2a80:	b601006b 	strlt	r0, [r1], -fp, rrx
    2a84:	026f1703 	rsbeq	r1, pc, #786432	; 0xc0000
    2a88:	031b0000 	tsteq	fp, #0
    2a8c:	03170000 	tsteq	r7, #0
    2a90:	11000000 	mrsne	r0, (UNDEF: 0)
    2a94:	00027b04 	andeq	r7, r2, r4, lsl #22
	...

Disassembly of section .debug_abbrev:

00000000 <.debug_abbrev>:
   0:	10001101 	andne	r1, r0, r1, lsl #2
   4:	12011106 	andne	r1, r1, #-2147483647	; 0x80000001
   8:	1b0e0301 	blne	380c14 <__bss_end+0x376fec>
   c:	130e250e 	movwne	r2, #58638	; 0xe50e
  10:	00000005 	andeq	r0, r0, r5
  14:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
  18:	030b130e 	movweq	r1, #45838	; 0xb30e
  1c:	110e1b0e 	tstne	lr, lr, lsl #22
  20:	10061201 	andne	r1, r6, r1, lsl #4
  24:	02000017 	andeq	r0, r0, #23
  28:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
  2c:	0b3b0b3a 	bleq	ec2d1c <__bss_end+0xeb90f4>
  30:	13490b39 	movtne	r0, #39737	; 0x9b39
  34:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
  38:	24030000 	strcs	r0, [r3], #-0
  3c:	3e0b0b00 	vmlacc.f64	d0, d11, d0
  40:	000e030b 	andeq	r0, lr, fp, lsl #6
  44:	012e0400 			; <UNDEFINED> instruction: 0x012e0400
  48:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
  4c:	0b3b0b3a 	bleq	ec2d3c <__bss_end+0xeb9114>
  50:	01110b39 	tsteq	r1, r9, lsr fp
  54:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
  58:	01194296 			; <UNDEFINED> instruction: 0x01194296
  5c:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
  60:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
  64:	0b3b0b3a 	bleq	ec2d54 <__bss_end+0xeb912c>
  68:	13490b39 	movtne	r0, #39737	; 0x9b39
  6c:	00001802 	andeq	r1, r0, r2, lsl #16
  70:	0b002406 	bleq	9090 <_Z6memcpyPKvPvi+0x24>
  74:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
  78:	07000008 	streq	r0, [r0, -r8]
  7c:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
  80:	0b3a0e03 	bleq	e83894 <__bss_end+0xe79c6c>
  84:	0b390b3b 	bleq	e42d78 <__bss_end+0xe39150>
  88:	06120111 			; <UNDEFINED> instruction: 0x06120111
  8c:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
  90:	00130119 	andseq	r0, r3, r9, lsl r1
  94:	010b0800 	tsteq	fp, r0, lsl #16
  98:	06120111 			; <UNDEFINED> instruction: 0x06120111
  9c:	34090000 	strcc	r0, [r9], #-0
  a0:	3a080300 	bcc	200ca8 <__bss_end+0x1f7080>
  a4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
  a8:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
  ac:	0a000018 	beq	114 <shift+0x114>
  b0:	0b0b000f 	bleq	2c00f4 <__bss_end+0x2b64cc>
  b4:	00001349 	andeq	r1, r0, r9, asr #6
  b8:	01110100 	tsteq	r1, r0, lsl #2
  bc:	0b130e25 	bleq	4c3958 <__bss_end+0x4b9d30>
  c0:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
  c4:	06120111 			; <UNDEFINED> instruction: 0x06120111
  c8:	00001710 	andeq	r1, r0, r0, lsl r7
  cc:	03001602 	movweq	r1, #1538	; 0x602
  d0:	3b0b3a0e 	blcc	2ce910 <__bss_end+0x2c4ce8>
  d4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
  d8:	03000013 	movweq	r0, #19
  dc:	0b0b000f 	bleq	2c0120 <__bss_end+0x2b64f8>
  e0:	00001349 	andeq	r1, r0, r9, asr #6
  e4:	00001504 	andeq	r1, r0, r4, lsl #10
  e8:	01010500 	tsteq	r1, r0, lsl #10
  ec:	13011349 	movwne	r1, #4937	; 0x1349
  f0:	21060000 	mrscs	r0, (UNDEF: 6)
  f4:	2f134900 	svccs	0x00134900
  f8:	07000006 	streq	r0, [r0, -r6]
  fc:	0b0b0024 	bleq	2c0194 <__bss_end+0x2b656c>
 100:	0e030b3e 	vmoveq.16	d3[0], r0
 104:	34080000 	strcc	r0, [r8], #-0
 108:	3a0e0300 	bcc	380d10 <__bss_end+0x3770e8>
 10c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 110:	3f13490b 	svccc	0x0013490b
 114:	00193c19 	andseq	r3, r9, r9, lsl ip
 118:	012e0900 			; <UNDEFINED> instruction: 0x012e0900
 11c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 120:	0b3b0b3a 	bleq	ec2e10 <__bss_end+0xeb91e8>
 124:	13490b39 	movtne	r0, #39737	; 0x9b39
 128:	06120111 			; <UNDEFINED> instruction: 0x06120111
 12c:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 130:	00130119 	andseq	r0, r3, r9, lsl r1
 134:	00340a00 	eorseq	r0, r4, r0, lsl #20
 138:	0b3a0e03 	bleq	e8394c <__bss_end+0xe79d24>
 13c:	0b390b3b 	bleq	e42e30 <__bss_end+0xe39208>
 140:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 144:	240b0000 	strcs	r0, [fp], #-0
 148:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 14c:	0008030b 	andeq	r0, r8, fp, lsl #6
 150:	002e0c00 	eoreq	r0, lr, r0, lsl #24
 154:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 158:	0b3b0b3a 	bleq	ec2e48 <__bss_end+0xeb9220>
 15c:	01110b39 	tsteq	r1, r9, lsr fp
 160:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 164:	00194297 	mulseq	r9, r7, r2
 168:	01390d00 	teqeq	r9, r0, lsl #26
 16c:	0b3a0e03 	bleq	e83980 <__bss_end+0xe79d58>
 170:	13010b3b 	movwne	r0, #6971	; 0x1b3b
 174:	2e0e0000 	cdpcs	0, 0, cr0, cr14, cr0, {0}
 178:	03193f01 	tsteq	r9, #1, 30
 17c:	3b0b3a0e 	blcc	2ce9bc <__bss_end+0x2c4d94>
 180:	3c0b390b 			; <UNDEFINED> instruction: 0x3c0b390b
 184:	00130119 	andseq	r0, r3, r9, lsl r1
 188:	00050f00 	andeq	r0, r5, r0, lsl #30
 18c:	00001349 	andeq	r1, r0, r9, asr #6
 190:	3f012e10 	svccc	0x00012e10
 194:	3a0e0319 	bcc	380e00 <__bss_end+0x3771d8>
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
 1c0:	3a080300 	bcc	200dc8 <__bss_end+0x1f71a0>
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
 1f4:	0b0b0024 	bleq	2c028c <__bss_end+0x2b6664>
 1f8:	0e030b3e 	vmoveq.16	d3[0], r0
 1fc:	24030000 	strcs	r0, [r3], #-0
 200:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 204:	0008030b 	andeq	r0, r8, fp, lsl #6
 208:	00160400 	andseq	r0, r6, r0, lsl #8
 20c:	0b3a0e03 	bleq	e83a20 <__bss_end+0xe79df8>
 210:	0b390b3b 	bleq	e42f04 <__bss_end+0xe392dc>
 214:	00001349 	andeq	r1, r0, r9, asr #6
 218:	49002605 	stmdbmi	r0, {r0, r2, r9, sl, sp}
 21c:	06000013 			; <UNDEFINED> instruction: 0x06000013
 220:	0e030113 	mcreq	1, 0, r0, cr3, cr3, {0}
 224:	0b3a0b0b 	bleq	e82e58 <__bss_end+0xe79230>
 228:	0b390b3b 	bleq	e42f1c <__bss_end+0xe392f4>
 22c:	00001301 	andeq	r1, r0, r1, lsl #6
 230:	03000d07 	movweq	r0, #3335	; 0xd07
 234:	3b0b3a08 	blcc	2cea5c <__bss_end+0x2c4e34>
 238:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 23c:	000b3813 	andeq	r3, fp, r3, lsl r8
 240:	01040800 	tsteq	r4, r0, lsl #16
 244:	196d0e03 	stmdbne	sp!, {r0, r1, r9, sl, fp}^
 248:	0b0b0b3e 	bleq	2c2f48 <__bss_end+0x2b9320>
 24c:	0b3a1349 	bleq	e84f78 <__bss_end+0xe7b350>
 250:	0b390b3b 	bleq	e42f44 <__bss_end+0xe3931c>
 254:	00001301 	andeq	r1, r0, r1, lsl #6
 258:	03002809 	movweq	r2, #2057	; 0x809
 25c:	000b1c0e 	andeq	r1, fp, lr, lsl #24
 260:	00340a00 	eorseq	r0, r4, r0, lsl #20
 264:	0b3a0e03 	bleq	e83a78 <__bss_end+0xe79e50>
 268:	0b390b3b 	bleq	e42f5c <__bss_end+0xe39334>
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
 294:	0b3b0b3a 	bleq	ec2f84 <__bss_end+0xeb935c>
 298:	13490b39 	movtne	r0, #39737	; 0x9b39
 29c:	00000b38 	andeq	r0, r0, r8, lsr fp
 2a0:	4901010f 	stmdbmi	r1, {r0, r1, r2, r3, r8}
 2a4:	00130113 	andseq	r0, r3, r3, lsl r1
 2a8:	00211000 	eoreq	r1, r1, r0
 2ac:	0b2f1349 	bleq	bc4fd8 <__bss_end+0xbbb3b0>
 2b0:	02110000 	andseq	r0, r1, #0
 2b4:	0b0e0301 	bleq	380ec0 <__bss_end+0x377298>
 2b8:	3b0b3a0b 	blcc	2ceaec <__bss_end+0x2c4ec4>
 2bc:	010b390b 	tsteq	fp, fp, lsl #18
 2c0:	12000013 	andne	r0, r0, #19
 2c4:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 2c8:	0b3a0e03 	bleq	e83adc <__bss_end+0xe79eb4>
 2cc:	0b390b3b 	bleq	e42fc0 <__bss_end+0xe39398>
 2d0:	193c0e6e 	ldmdbne	ip!, {r1, r2, r3, r5, r6, r9, sl, fp}
 2d4:	13011364 	movwne	r1, #4964	; 0x1364
 2d8:	05130000 	ldreq	r0, [r3, #-0]
 2dc:	34134900 	ldrcc	r4, [r3], #-2304	; 0xfffff700
 2e0:	14000019 	strne	r0, [r0], #-25	; 0xffffffe7
 2e4:	13490005 	movtne	r0, #36869	; 0x9005
 2e8:	2e150000 	cdpcs	0, 1, cr0, cr5, cr0, {0}
 2ec:	03193f01 	tsteq	r9, #1, 30
 2f0:	3b0b3a0e 	blcc	2ceb30 <__bss_end+0x2c4f08>
 2f4:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 2f8:	3c13490e 			; <UNDEFINED> instruction: 0x3c13490e
 2fc:	01136419 	tsteq	r3, r9, lsl r4
 300:	16000013 			; <UNDEFINED> instruction: 0x16000013
 304:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 308:	0b3a0e03 	bleq	e83b1c <__bss_end+0xe79ef4>
 30c:	0b390b3b 	bleq	e43000 <__bss_end+0xe393d8>
 310:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 314:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 318:	13011364 	movwne	r1, #4964	; 0x1364
 31c:	0d170000 	ldceq	0, cr0, [r7, #-0]
 320:	3a0e0300 	bcc	380f28 <__bss_end+0x377300>
 324:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 328:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 32c:	000b320b 	andeq	r3, fp, fp, lsl #4
 330:	012e1800 			; <UNDEFINED> instruction: 0x012e1800
 334:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 338:	0b3b0b3a 	bleq	ec3028 <__bss_end+0xeb9400>
 33c:	0e6e0b39 	vmoveq.8	d14[5], r0
 340:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 344:	13011364 	movwne	r1, #4964	; 0x1364
 348:	2e190000 	cdpcs	0, 1, cr0, cr9, cr0, {0}
 34c:	03193f01 	tsteq	r9, #1, 30
 350:	3b0b3a0e 	blcc	2ceb90 <__bss_end+0x2c4f68>
 354:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 358:	3213490e 	andscc	r4, r3, #229376	; 0x38000
 35c:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
 360:	1a000013 	bne	3b4 <shift+0x3b4>
 364:	13490115 	movtne	r0, #37141	; 0x9115
 368:	13011364 	movwne	r1, #4964	; 0x1364
 36c:	1f1b0000 	svcne	0x001b0000
 370:	49131d00 	ldmdbmi	r3, {r8, sl, fp, ip}
 374:	1c000013 	stcne	0, cr0, [r0], {19}
 378:	0b0b0010 	bleq	2c03c0 <__bss_end+0x2b6798>
 37c:	00001349 	andeq	r1, r0, r9, asr #6
 380:	0b000f1d 	bleq	3ffc <shift+0x3ffc>
 384:	1e00000b 	cdpne	0, 0, cr0, cr0, cr11, {0}
 388:	08030139 	stmdaeq	r3, {r0, r3, r4, r5, r8}
 38c:	0b3b0b3a 	bleq	ec307c <__bss_end+0xeb9454>
 390:	13010b39 	movwne	r0, #6969	; 0x1b39
 394:	341f0000 	ldrcc	r0, [pc], #-0	; 39c <shift+0x39c>
 398:	3a0e0300 	bcc	380fa0 <__bss_end+0x377378>
 39c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 3a0:	3c13490b 			; <UNDEFINED> instruction: 0x3c13490b
 3a4:	6c061c19 	stcvs	12, cr1, [r6], {25}
 3a8:	20000019 	andcs	r0, r0, r9, lsl r0
 3ac:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 3b0:	0b3b0b3a 	bleq	ec30a0 <__bss_end+0xeb9478>
 3b4:	13490b39 	movtne	r0, #39737	; 0x9b39
 3b8:	0b1c193c 	bleq	7068b0 <__bss_end+0x6fcc88>
 3bc:	0000196c 	andeq	r1, r0, ip, ror #18
 3c0:	47003421 	strmi	r3, [r0, -r1, lsr #8]
 3c4:	22000013 	andcs	r0, r0, #19
 3c8:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 3cc:	0b3a0e03 	bleq	e83be0 <__bss_end+0xe79fb8>
 3d0:	0b390b3b 	bleq	e430c4 <__bss_end+0xe3949c>
 3d4:	01111349 	tsteq	r1, r9, asr #6
 3d8:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 3dc:	01194296 			; <UNDEFINED> instruction: 0x01194296
 3e0:	23000013 	movwcs	r0, #19
 3e4:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
 3e8:	0b3b0b3a 	bleq	ec30d8 <__bss_end+0xeb94b0>
 3ec:	13490b39 	movtne	r0, #39737	; 0x9b39
 3f0:	00001802 	andeq	r1, r0, r2, lsl #16
 3f4:	03003424 	movweq	r3, #1060	; 0x424
 3f8:	3b0b3a0e 	blcc	2cec38 <__bss_end+0x2c5010>
 3fc:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 400:	00180213 	andseq	r0, r8, r3, lsl r2
 404:	010b2500 	tsteq	fp, r0, lsl #10
 408:	06120111 			; <UNDEFINED> instruction: 0x06120111
 40c:	34260000 	strtcc	r0, [r6], #-0
 410:	3a080300 	bcc	201018 <__bss_end+0x1f73f0>
 414:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 418:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 41c:	00000018 	andeq	r0, r0, r8, lsl r0
 420:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
 424:	030b130e 	movweq	r1, #45838	; 0xb30e
 428:	110e1b0e 	tstne	lr, lr, lsl #22
 42c:	10061201 	andne	r1, r6, r1, lsl #4
 430:	02000017 	andeq	r0, r0, #23
 434:	0b0b0024 	bleq	2c04cc <__bss_end+0x2b68a4>
 438:	0e030b3e 	vmoveq.16	d3[0], r0
 43c:	26030000 	strcs	r0, [r3], -r0
 440:	00134900 	andseq	r4, r3, r0, lsl #18
 444:	00240400 	eoreq	r0, r4, r0, lsl #8
 448:	0b3e0b0b 	bleq	f8307c <__bss_end+0xf79454>
 44c:	00000803 	andeq	r0, r0, r3, lsl #16
 450:	03001605 	movweq	r1, #1541	; 0x605
 454:	3b0b3a0e 	blcc	2cec94 <__bss_end+0x2c506c>
 458:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 45c:	06000013 			; <UNDEFINED> instruction: 0x06000013
 460:	0e030113 	mcreq	1, 0, r0, cr3, cr3, {0}
 464:	0b3a0b0b 	bleq	e83098 <__bss_end+0xe79470>
 468:	0b390b3b 	bleq	e4315c <__bss_end+0xe39534>
 46c:	00001301 	andeq	r1, r0, r1, lsl #6
 470:	03000d07 	movweq	r0, #3335	; 0xd07
 474:	3b0b3a08 	blcc	2cec9c <__bss_end+0x2c5074>
 478:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 47c:	000b3813 	andeq	r3, fp, r3, lsl r8
 480:	01040800 	tsteq	r4, r0, lsl #16
 484:	196d0e03 	stmdbne	sp!, {r0, r1, r9, sl, fp}^
 488:	0b0b0b3e 	bleq	2c3188 <__bss_end+0x2b9560>
 48c:	0b3a1349 	bleq	e851b8 <__bss_end+0xe7b590>
 490:	0b390b3b 	bleq	e43184 <__bss_end+0xe3955c>
 494:	00001301 	andeq	r1, r0, r1, lsl #6
 498:	03002809 	movweq	r2, #2057	; 0x809
 49c:	000b1c08 	andeq	r1, fp, r8, lsl #24
 4a0:	00280a00 	eoreq	r0, r8, r0, lsl #20
 4a4:	0b1c0e03 	bleq	703cb8 <__bss_end+0x6fa090>
 4a8:	340b0000 	strcc	r0, [fp], #-0
 4ac:	3a0e0300 	bcc	3810b4 <__bss_end+0x37748c>
 4b0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 4b4:	6c13490b 			; <UNDEFINED> instruction: 0x6c13490b
 4b8:	00180219 	andseq	r0, r8, r9, lsl r2
 4bc:	00020c00 	andeq	r0, r2, r0, lsl #24
 4c0:	193c0e03 	ldmdbne	ip!, {r0, r1, r9, sl, fp}
 4c4:	0f0d0000 	svceq	0x000d0000
 4c8:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
 4cc:	0e000013 	mcreq	0, 0, r0, cr0, cr3, {0}
 4d0:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
 4d4:	0b3b0b3a 	bleq	ec31c4 <__bss_end+0xeb959c>
 4d8:	13490b39 	movtne	r0, #39737	; 0x9b39
 4dc:	00000b38 	andeq	r0, r0, r8, lsr fp
 4e0:	4901010f 	stmdbmi	r1, {r0, r1, r2, r3, r8}
 4e4:	00130113 	andseq	r0, r3, r3, lsl r1
 4e8:	00211000 	eoreq	r1, r1, r0
 4ec:	0b2f1349 	bleq	bc5218 <__bss_end+0xbbb5f0>
 4f0:	02110000 	andseq	r0, r1, #0
 4f4:	0b0e0301 	bleq	381100 <__bss_end+0x3774d8>
 4f8:	3b0b3a0b 	blcc	2ced2c <__bss_end+0x2c5104>
 4fc:	010b390b 	tsteq	fp, fp, lsl #18
 500:	12000013 	andne	r0, r0, #19
 504:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 508:	0b3a0e03 	bleq	e83d1c <__bss_end+0xe7a0f4>
 50c:	0b390b3b 	bleq	e43200 <__bss_end+0xe395d8>
 510:	193c0e6e 	ldmdbne	ip!, {r1, r2, r3, r5, r6, r9, sl, fp}
 514:	13011364 	movwne	r1, #4964	; 0x1364
 518:	05130000 	ldreq	r0, [r3, #-0]
 51c:	34134900 	ldrcc	r4, [r3], #-2304	; 0xfffff700
 520:	14000019 	strne	r0, [r0], #-25	; 0xffffffe7
 524:	13490005 	movtne	r0, #36869	; 0x9005
 528:	2e150000 	cdpcs	0, 1, cr0, cr5, cr0, {0}
 52c:	03193f01 	tsteq	r9, #1, 30
 530:	3b0b3a0e 	blcc	2ced70 <__bss_end+0x2c5148>
 534:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 538:	3c13490e 			; <UNDEFINED> instruction: 0x3c13490e
 53c:	01136419 	tsteq	r3, r9, lsl r4
 540:	16000013 			; <UNDEFINED> instruction: 0x16000013
 544:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 548:	0b3a0e03 	bleq	e83d5c <__bss_end+0xe7a134>
 54c:	0b390b3b 	bleq	e43240 <__bss_end+0xe39618>
 550:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 554:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 558:	13011364 	movwne	r1, #4964	; 0x1364
 55c:	0d170000 	ldceq	0, cr0, [r7, #-0]
 560:	3a0e0300 	bcc	381168 <__bss_end+0x377540>
 564:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 568:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 56c:	000b320b 	andeq	r3, fp, fp, lsl #4
 570:	012e1800 			; <UNDEFINED> instruction: 0x012e1800
 574:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 578:	0b3b0b3a 	bleq	ec3268 <__bss_end+0xeb9640>
 57c:	0e6e0b39 	vmoveq.8	d14[5], r0
 580:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 584:	13011364 	movwne	r1, #4964	; 0x1364
 588:	2e190000 	cdpcs	0, 1, cr0, cr9, cr0, {0}
 58c:	03193f01 	tsteq	r9, #1, 30
 590:	3b0b3a0e 	blcc	2cedd0 <__bss_end+0x2c51a8>
 594:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 598:	3213490e 	andscc	r4, r3, #229376	; 0x38000
 59c:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
 5a0:	1a000013 	bne	5f4 <shift+0x5f4>
 5a4:	13490115 	movtne	r0, #37141	; 0x9115
 5a8:	13011364 	movwne	r1, #4964	; 0x1364
 5ac:	1f1b0000 	svcne	0x001b0000
 5b0:	49131d00 	ldmdbmi	r3, {r8, sl, fp, ip}
 5b4:	1c000013 	stcne	0, cr0, [r0], {19}
 5b8:	0b0b0010 	bleq	2c0600 <__bss_end+0x2b69d8>
 5bc:	00001349 	andeq	r1, r0, r9, asr #6
 5c0:	0b000f1d 	bleq	423c <shift+0x423c>
 5c4:	1e00000b 	cdpne	0, 0, cr0, cr0, cr11, {0}
 5c8:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 5cc:	0b3b0b3a 	bleq	ec32bc <__bss_end+0xeb9694>
 5d0:	13490b39 	movtne	r0, #39737	; 0x9b39
 5d4:	00001802 	andeq	r1, r0, r2, lsl #16
 5d8:	3f012e1f 	svccc	0x00012e1f
 5dc:	3a0e0319 	bcc	381248 <__bss_end+0x377620>
 5e0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 5e4:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 5e8:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
 5ec:	96184006 	ldrls	r4, [r8], -r6
 5f0:	13011942 	movwne	r1, #6466	; 0x1942
 5f4:	05200000 	streq	r0, [r0, #-0]!
 5f8:	3a0e0300 	bcc	381200 <__bss_end+0x3775d8>
 5fc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 600:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 604:	21000018 	tstcs	r0, r8, lsl r0
 608:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 60c:	0b3a0e03 	bleq	e83e20 <__bss_end+0xe7a1f8>
 610:	0b390b3b 	bleq	e43304 <__bss_end+0xe396dc>
 614:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 618:	06120111 			; <UNDEFINED> instruction: 0x06120111
 61c:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 620:	00130119 	andseq	r0, r3, r9, lsl r1
 624:	00342200 	eorseq	r2, r4, r0, lsl #4
 628:	0b3a0803 	bleq	e8263c <__bss_end+0xe78a14>
 62c:	0b390b3b 	bleq	e43320 <__bss_end+0xe396f8>
 630:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 634:	2e230000 	cdpcs	0, 2, cr0, cr3, cr0, {0}
 638:	03193f01 	tsteq	r9, #1, 30
 63c:	3b0b3a0e 	blcc	2cee7c <__bss_end+0x2c5254>
 640:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 644:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 648:	97184006 	ldrls	r4, [r8, -r6]
 64c:	13011942 	movwne	r1, #6466	; 0x1942
 650:	2e240000 	cdpcs	0, 2, cr0, cr4, cr0, {0}
 654:	03193f00 	tsteq	r9, #0, 30
 658:	3b0b3a0e 	blcc	2cee98 <__bss_end+0x2c5270>
 65c:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 660:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 664:	97184006 	ldrls	r4, [r8, -r6]
 668:	00001942 	andeq	r1, r0, r2, asr #18
 66c:	3f012e25 	svccc	0x00012e25
 670:	3a0e0319 	bcc	3812dc <__bss_end+0x3776b4>
 674:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 678:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 67c:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
 680:	97184006 	ldrls	r4, [r8, -r6]
 684:	00001942 	andeq	r1, r0, r2, asr #18
 688:	01110100 	tsteq	r1, r0, lsl #2
 68c:	0b130e25 	bleq	4c3f28 <__bss_end+0x4ba300>
 690:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
 694:	06120111 			; <UNDEFINED> instruction: 0x06120111
 698:	00001710 	andeq	r1, r0, r0, lsl r7
 69c:	01013902 	tsteq	r1, r2, lsl #18
 6a0:	03000013 	movweq	r0, #19
 6a4:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 6a8:	0b3b0b3a 	bleq	ec3398 <__bss_end+0xeb9770>
 6ac:	13490b39 	movtne	r0, #39737	; 0x9b39
 6b0:	0a1c193c 	beq	706ba8 <__bss_end+0x6fcf80>
 6b4:	3a040000 	bcc	1006bc <__bss_end+0xf6a94>
 6b8:	3b0b3a00 	blcc	2ceec0 <__bss_end+0x2c5298>
 6bc:	180b390b 	stmdane	fp, {r0, r1, r3, r8, fp, ip, sp}
 6c0:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
 6c4:	13490101 	movtne	r0, #37121	; 0x9101
 6c8:	00001301 	andeq	r1, r0, r1, lsl #6
 6cc:	49002106 	stmdbmi	r0, {r1, r2, r8, sp}
 6d0:	000b2f13 	andeq	r2, fp, r3, lsl pc
 6d4:	00260700 	eoreq	r0, r6, r0, lsl #14
 6d8:	00001349 	andeq	r1, r0, r9, asr #6
 6dc:	0b002408 	bleq	9704 <__addsf3+0x6c>
 6e0:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 6e4:	0900000e 	stmdbeq	r0, {r1, r2, r3}
 6e8:	13470034 	movtne	r0, #28724	; 0x7034
 6ec:	2e0a0000 	cdpcs	0, 0, cr0, cr10, cr0, {0}
 6f0:	03193f01 	tsteq	r9, #1, 30
 6f4:	3b0b3a0e 	blcc	2cef34 <__bss_end+0x2c530c>
 6f8:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 6fc:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 700:	96184006 	ldrls	r4, [r8], -r6
 704:	13011942 	movwne	r1, #6466	; 0x1942
 708:	050b0000 	streq	r0, [fp, #-0]
 70c:	3a080300 	bcc	201314 <__bss_end+0x1f76ec>
 710:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 714:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 718:	0c000018 	stceq	0, cr0, [r0], {24}
 71c:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 720:	0b3b0b3a 	bleq	ec3410 <__bss_end+0xeb97e8>
 724:	13490b39 	movtne	r0, #39737	; 0x9b39
 728:	00001802 	andeq	r1, r0, r2, lsl #16
 72c:	0300340d 	movweq	r3, #1037	; 0x40d
 730:	3b0b3a08 	blcc	2cef58 <__bss_end+0x2c5330>
 734:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 738:	00180213 	andseq	r0, r8, r3, lsl r2
 73c:	000f0e00 	andeq	r0, pc, r0, lsl #28
 740:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 744:	2e0f0000 	cdpcs	0, 0, cr0, cr15, cr0, {0}
 748:	03193f01 	tsteq	r9, #1, 30
 74c:	3b0b3a0e 	blcc	2cef8c <__bss_end+0x2c5364>
 750:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 754:	1113490e 	tstne	r3, lr, lsl #18
 758:	40061201 	andmi	r1, r6, r1, lsl #4
 75c:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
 760:	00001301 	andeq	r1, r0, r1, lsl #6
 764:	03000510 	movweq	r0, #1296	; 0x510
 768:	3b0b3a0e 	blcc	2cefa8 <__bss_end+0x2c5380>
 76c:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 770:	00180213 	andseq	r0, r8, r3, lsl r2
 774:	00241100 	eoreq	r1, r4, r0, lsl #2
 778:	0b3e0b0b 	bleq	f833ac <__bss_end+0xf79784>
 77c:	00000803 	andeq	r0, r0, r3, lsl #16
 780:	3f012e12 	svccc	0x00012e12
 784:	3a0e0319 	bcc	3813f0 <__bss_end+0x3777c8>
 788:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 78c:	110e6e0b 	tstne	lr, fp, lsl #28
 790:	40061201 	andmi	r1, r6, r1, lsl #4
 794:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
 798:	00001301 	andeq	r1, r0, r1, lsl #6
 79c:	11010b13 	tstne	r1, r3, lsl fp
 7a0:	00061201 	andeq	r1, r6, r1, lsl #4
 7a4:	00261400 	eoreq	r1, r6, r0, lsl #8
 7a8:	0f150000 	svceq	0x00150000
 7ac:	000b0b00 	andeq	r0, fp, r0, lsl #22
 7b0:	012e1600 			; <UNDEFINED> instruction: 0x012e1600
 7b4:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 7b8:	0b3b0b3a 	bleq	ec34a8 <__bss_end+0xeb9880>
 7bc:	0e6e0b39 	vmoveq.8	d14[5], r0
 7c0:	01111349 	tsteq	r1, r9, asr #6
 7c4:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 7c8:	01194296 			; <UNDEFINED> instruction: 0x01194296
 7cc:	17000013 	smladne	r0, r3, r0, r0
 7d0:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 7d4:	0b3a0e03 	bleq	e83fe8 <__bss_end+0xe7a3c0>
 7d8:	0b390b3b 	bleq	e434cc <__bss_end+0xe398a4>
 7dc:	01110e6e 	tsteq	r1, lr, ror #28
 7e0:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 7e4:	00194296 	mulseq	r9, r6, r2
 7e8:	11010000 	mrsne	r0, (UNDEF: 1)
 7ec:	11061000 	mrsne	r1, (UNDEF: 6)
 7f0:	03011201 	movweq	r1, #4609	; 0x1201
 7f4:	250e1b0e 	strcs	r1, [lr, #-2830]	; 0xfffff4f2
 7f8:	0005130e 	andeq	r1, r5, lr, lsl #6
 7fc:	11010000 	mrsne	r0, (UNDEF: 1)
 800:	11061000 	mrsne	r1, (UNDEF: 6)
 804:	03011201 	movweq	r1, #4609	; 0x1201
 808:	250e1b0e 	strcs	r1, [lr, #-2830]	; 0xfffff4f2
 80c:	0005130e 	andeq	r1, r5, lr, lsl #6
 810:	11010000 	mrsne	r0, (UNDEF: 1)
 814:	11061000 	mrsne	r1, (UNDEF: 6)
 818:	03011201 	movweq	r1, #4609	; 0x1201
 81c:	250e1b0e 	strcs	r1, [lr, #-2830]	; 0xfffff4f2
 820:	0005130e 	andeq	r1, r5, lr, lsl #6
 824:	11010000 	mrsne	r0, (UNDEF: 1)
 828:	11061000 	mrsne	r1, (UNDEF: 6)
 82c:	03011201 	movweq	r1, #4609	; 0x1201
 830:	250e1b0e 	strcs	r1, [lr, #-2830]	; 0xfffff4f2
 834:	0005130e 	andeq	r1, r5, lr, lsl #6
 838:	11010000 	mrsne	r0, (UNDEF: 1)
 83c:	130e2501 	movwne	r2, #58625	; 0xe501
 840:	1b0e030b 	blne	381474 <__bss_end+0x37784c>
 844:	0017100e 	andseq	r1, r7, lr
 848:	00240200 	eoreq	r0, r4, r0, lsl #4
 84c:	0b3e0b0b 	bleq	f83480 <__bss_end+0xf79858>
 850:	00000803 	andeq	r0, r0, r3, lsl #16
 854:	0b002403 	bleq	9868 <__aeabi_l2f+0x8>
 858:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 85c:	0400000e 	streq	r0, [r0], #-14
 860:	0e030104 	adfeqs	f0, f3, f4
 864:	0b0b0b3e 	bleq	2c3564 <__bss_end+0x2b993c>
 868:	0b3a1349 	bleq	e85594 <__bss_end+0xe7b96c>
 86c:	0b390b3b 	bleq	e43560 <__bss_end+0xe39938>
 870:	00001301 	andeq	r1, r0, r1, lsl #6
 874:	03002805 	movweq	r2, #2053	; 0x805
 878:	000b1c0e 	andeq	r1, fp, lr, lsl #24
 87c:	01130600 	tsteq	r3, r0, lsl #12
 880:	0b0b0e03 	bleq	2c4094 <__bss_end+0x2ba46c>
 884:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 888:	13010b39 	movwne	r0, #6969	; 0x1b39
 88c:	0d070000 	stceq	0, cr0, [r7, #-0]
 890:	3a0e0300 	bcc	381498 <__bss_end+0x377870>
 894:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 898:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 89c:	0800000b 	stmdaeq	r0, {r0, r1, r3}
 8a0:	13490026 	movtne	r0, #36902	; 0x9026
 8a4:	01090000 	mrseq	r0, (UNDEF: 9)
 8a8:	01134901 	tsteq	r3, r1, lsl #18
 8ac:	0a000013 	beq	900 <shift+0x900>
 8b0:	13490021 	movtne	r0, #36897	; 0x9021
 8b4:	00000b2f 	andeq	r0, r0, pc, lsr #22
 8b8:	0300340b 	movweq	r3, #1035	; 0x40b
 8bc:	3b0b3a0e 	blcc	2cf0fc <__bss_end+0x2c54d4>
 8c0:	490b3905 	stmdbmi	fp, {r0, r2, r8, fp, ip, sp}
 8c4:	000a1c13 	andeq	r1, sl, r3, lsl ip
 8c8:	00150c00 	andseq	r0, r5, r0, lsl #24
 8cc:	00001927 	andeq	r1, r0, r7, lsr #18
 8d0:	0b000f0d 	bleq	450c <shift+0x450c>
 8d4:	0013490b 	andseq	r4, r3, fp, lsl #18
 8d8:	01040e00 	tsteq	r4, r0, lsl #28
 8dc:	0b3e0e03 	bleq	f840f0 <__bss_end+0xf7a4c8>
 8e0:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 8e4:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 8e8:	13010b39 	movwne	r0, #6969	; 0x1b39
 8ec:	160f0000 	strne	r0, [pc], -r0
 8f0:	3a0e0300 	bcc	3814f8 <__bss_end+0x3778d0>
 8f4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 8f8:	0013490b 	andseq	r4, r3, fp, lsl #18
 8fc:	00211000 	eoreq	r1, r1, r0
 900:	34110000 	ldrcc	r0, [r1], #-0
 904:	3a0e0300 	bcc	38150c <__bss_end+0x3778e4>
 908:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 90c:	3f13490b 	svccc	0x0013490b
 910:	00193c19 	andseq	r3, r9, r9, lsl ip
 914:	00341200 	eorseq	r1, r4, r0, lsl #4
 918:	0b3a1347 	bleq	e8563c <__bss_end+0xe7ba14>
 91c:	0b39053b 	bleq	e41e10 <__bss_end+0xe381e8>
 920:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 924:	01000000 	mrseq	r0, (UNDEF: 0)
 928:	0e250111 	mcreq	1, 1, r0, cr5, cr1, {0}
 92c:	0e030b13 	vmoveq.32	d3[0], r0
 930:	01110e1b 	tsteq	r1, fp, lsl lr
 934:	17100612 			; <UNDEFINED> instruction: 0x17100612
 938:	24020000 	strcs	r0, [r2], #-0
 93c:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 940:	000e030b 	andeq	r0, lr, fp, lsl #6
 944:	00240300 	eoreq	r0, r4, r0, lsl #6
 948:	0b3e0b0b 	bleq	f8357c <__bss_end+0xf79954>
 94c:	00000803 	andeq	r0, r0, r3, lsl #16
 950:	03010404 	movweq	r0, #5124	; 0x1404
 954:	0b0b3e0e 	bleq	2d0194 <__bss_end+0x2c656c>
 958:	3a13490b 	bcc	4d2d8c <__bss_end+0x4c9164>
 95c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 960:	0013010b 	andseq	r0, r3, fp, lsl #2
 964:	00280500 	eoreq	r0, r8, r0, lsl #10
 968:	0b1c0e03 	bleq	70417c <__bss_end+0x6fa554>
 96c:	13060000 	movwne	r0, #24576	; 0x6000
 970:	0b0e0301 	bleq	38157c <__bss_end+0x377954>
 974:	3b0b3a0b 	blcc	2cf1a8 <__bss_end+0x2c5580>
 978:	010b3905 	tsteq	fp, r5, lsl #18
 97c:	07000013 	smladeq	r0, r3, r0, r0
 980:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
 984:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 988:	13490b39 	movtne	r0, #39737	; 0x9b39
 98c:	00000b38 	andeq	r0, r0, r8, lsr fp
 990:	49002608 	stmdbmi	r0, {r3, r9, sl, sp}
 994:	09000013 	stmdbeq	r0, {r0, r1, r4}
 998:	13490101 	movtne	r0, #37121	; 0x9101
 99c:	00001301 	andeq	r1, r0, r1, lsl #6
 9a0:	4900210a 	stmdbmi	r0, {r1, r3, r8, sp}
 9a4:	000b2f13 	andeq	r2, fp, r3, lsl pc
 9a8:	00340b00 	eorseq	r0, r4, r0, lsl #22
 9ac:	0b3a0e03 	bleq	e841c0 <__bss_end+0xe7a598>
 9b0:	0b39053b 	bleq	e41ea4 <__bss_end+0xe3827c>
 9b4:	0a1c1349 	beq	7056e0 <__bss_end+0x6fbab8>
 9b8:	160c0000 	strne	r0, [ip], -r0
 9bc:	3a0e0300 	bcc	3815c4 <__bss_end+0x37799c>
 9c0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 9c4:	0013490b 	andseq	r4, r3, fp, lsl #18
 9c8:	012e0d00 			; <UNDEFINED> instruction: 0x012e0d00
 9cc:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 9d0:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 9d4:	19270b39 	stmdbne	r7!, {r0, r3, r4, r5, r8, r9, fp}
 9d8:	01111349 	tsteq	r1, r9, asr #6
 9dc:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 9e0:	01194297 			; <UNDEFINED> instruction: 0x01194297
 9e4:	0e000013 	mcreq	0, 0, r0, cr0, cr3, {0}
 9e8:	08030005 	stmdaeq	r3, {r0, r2}
 9ec:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 9f0:	13490b39 	movtne	r0, #39737	; 0x9b39
 9f4:	42b71702 	adcsmi	r1, r7, #524288	; 0x80000
 9f8:	0f000017 	svceq	0x00000017
 9fc:	01018289 	smlabbeq	r1, r9, r2, r8
 a00:	42950111 	addsmi	r0, r5, #1073741828	; 0x40000004
 a04:	01133119 	tsteq	r3, r9, lsl r1
 a08:	10000013 	andne	r0, r0, r3, lsl r0
 a0c:	0001828a 	andeq	r8, r1, sl, lsl #5
 a10:	42911802 	addsmi	r1, r1, #131072	; 0x20000
 a14:	11000018 	tstne	r0, r8, lsl r0
 a18:	01018289 	smlabbeq	r1, r9, r2, r8
 a1c:	13310111 	teqne	r1, #1073741828	; 0x40000004
 a20:	2e120000 	cdpcs	0, 1, cr0, cr2, cr0, {0}
 a24:	3c193f00 	ldccc	15, cr3, [r9], {-0}
 a28:	030e6e19 	movweq	r6, #60953	; 0xee19
 a2c:	3b0b3a0e 	blcc	2cf26c <__bss_end+0x2c5644>
 a30:	000b390b 	andeq	r3, fp, fp, lsl #18
 a34:	11010000 	mrsne	r0, (UNDEF: 1)
 a38:	130e2501 	movwne	r2, #58625	; 0xe501
 a3c:	1b0e030b 	blne	381670 <__bss_end+0x377a48>
 a40:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 a44:	00171006 	andseq	r1, r7, r6
 a48:	00240200 	eoreq	r0, r4, r0, lsl #4
 a4c:	0b3e0b0b 	bleq	f83680 <__bss_end+0xf79a58>
 a50:	00000e03 	andeq	r0, r0, r3, lsl #28
 a54:	0b002403 	bleq	9a68 <__udivmoddi4+0x48>
 a58:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 a5c:	04000008 	streq	r0, [r0], #-8
 a60:	0e030104 	adfeqs	f0, f3, f4
 a64:	0b0b0b3e 	bleq	2c3764 <__bss_end+0x2b9b3c>
 a68:	0b3a1349 	bleq	e85794 <__bss_end+0xe7bb6c>
 a6c:	0b390b3b 	bleq	e43760 <__bss_end+0xe39b38>
 a70:	00001301 	andeq	r1, r0, r1, lsl #6
 a74:	03002805 	movweq	r2, #2053	; 0x805
 a78:	000b1c0e 	andeq	r1, fp, lr, lsl #24
 a7c:	01130600 	tsteq	r3, r0, lsl #12
 a80:	0b0b0e03 	bleq	2c4294 <__bss_end+0x2ba66c>
 a84:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 a88:	13010b39 	movwne	r0, #6969	; 0x1b39
 a8c:	0d070000 	stceq	0, cr0, [r7, #-0]
 a90:	3a0e0300 	bcc	381698 <__bss_end+0x377a70>
 a94:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 a98:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 a9c:	0800000b 	stmdaeq	r0, {r0, r1, r3}
 aa0:	13490026 	movtne	r0, #36902	; 0x9026
 aa4:	01090000 	mrseq	r0, (UNDEF: 9)
 aa8:	01134901 	tsteq	r3, r1, lsl #18
 aac:	0a000013 	beq	b00 <shift+0xb00>
 ab0:	13490021 	movtne	r0, #36897	; 0x9021
 ab4:	00000b2f 	andeq	r0, r0, pc, lsr #22
 ab8:	0300340b 	movweq	r3, #1035	; 0x40b
 abc:	3b0b3a0e 	blcc	2cf2fc <__bss_end+0x2c56d4>
 ac0:	490b3905 	stmdbmi	fp, {r0, r2, r8, fp, ip, sp}
 ac4:	000a1c13 	andeq	r1, sl, r3, lsl ip
 ac8:	00160c00 	andseq	r0, r6, r0, lsl #24
 acc:	0b3a0e03 	bleq	e842e0 <__bss_end+0xe7a6b8>
 ad0:	0b390b3b 	bleq	e437c4 <__bss_end+0xe39b9c>
 ad4:	00001349 	andeq	r1, r0, r9, asr #6
 ad8:	3f012e0d 	svccc	0x00012e0d
 adc:	3a0e0319 	bcc	381748 <__bss_end+0x377b20>
 ae0:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 ae4:	4919270b 	ldmdbmi	r9, {r0, r1, r3, r8, r9, sl, sp}
 ae8:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
 aec:	97184006 	ldrls	r4, [r8, -r6]
 af0:	00001942 	andeq	r1, r0, r2, asr #18
 af4:	0300050e 	movweq	r0, #1294	; 0x50e
 af8:	3b0b3a08 	blcc	2cf320 <__bss_end+0x2c56f8>
 afc:	490b3905 	stmdbmi	fp, {r0, r2, r8, fp, ip, sp}
 b00:	b7170213 			; <UNDEFINED> instruction: 0xb7170213
 b04:	00001742 	andeq	r1, r0, r2, asr #14
 b08:	0300340f 	movweq	r3, #1039	; 0x40f
 b0c:	3b0b3a08 	blcc	2cf334 <__bss_end+0x2c570c>
 b10:	490b3905 	stmdbmi	fp, {r0, r2, r8, fp, ip, sp}
 b14:	b7170213 			; <UNDEFINED> instruction: 0xb7170213
 b18:	00001742 	andeq	r1, r0, r2, asr #14
 b1c:	01110100 	tsteq	r1, r0, lsl #2
 b20:	0b130e25 	bleq	4c43bc <__bss_end+0x4ba794>
 b24:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
 b28:	06120111 			; <UNDEFINED> instruction: 0x06120111
 b2c:	00001710 	andeq	r1, r0, r0, lsl r7
 b30:	0b002402 	bleq	9b40 <_ZL13Lock_Unlocked>
 b34:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 b38:	0300000e 	movweq	r0, #14
 b3c:	0b0b0024 	bleq	2c0bd4 <__bss_end+0x2b6fac>
 b40:	08030b3e 	stmdaeq	r3, {r1, r2, r3, r4, r5, r8, r9, fp}
 b44:	04040000 	streq	r0, [r4], #-0
 b48:	3e0e0301 	cdpcc	3, 0, cr0, cr14, cr1, {0}
 b4c:	490b0b0b 	stmdbmi	fp, {r0, r1, r3, r8, r9, fp}
 b50:	3b0b3a13 	blcc	2cf3a4 <__bss_end+0x2c577c>
 b54:	010b390b 	tsteq	fp, fp, lsl #18
 b58:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
 b5c:	0e030028 	cdpeq	0, 0, cr0, cr3, cr8, {1}
 b60:	00000b1c 	andeq	r0, r0, ip, lsl fp
 b64:	03011306 	movweq	r1, #4870	; 0x1306
 b68:	3a0b0b0e 	bcc	2c37a8 <__bss_end+0x2b9b80>
 b6c:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 b70:	0013010b 	andseq	r0, r3, fp, lsl #2
 b74:	000d0700 	andeq	r0, sp, r0, lsl #14
 b78:	0b3a0e03 	bleq	e8438c <__bss_end+0xe7a764>
 b7c:	0b39053b 	bleq	e42070 <__bss_end+0xe38448>
 b80:	0b381349 	bleq	e058ac <__bss_end+0xdfbc84>
 b84:	26080000 	strcs	r0, [r8], -r0
 b88:	00134900 	andseq	r4, r3, r0, lsl #18
 b8c:	01010900 	tsteq	r1, r0, lsl #18
 b90:	13011349 	movwne	r1, #4937	; 0x1349
 b94:	210a0000 	mrscs	r0, (UNDEF: 10)
 b98:	2f134900 	svccs	0x00134900
 b9c:	0b00000b 	bleq	bd0 <shift+0xbd0>
 ba0:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 ba4:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 ba8:	13490b39 	movtne	r0, #39737	; 0x9b39
 bac:	00000a1c 	andeq	r0, r0, ip, lsl sl
 bb0:	0300160c 	movweq	r1, #1548	; 0x60c
 bb4:	3b0b3a0e 	blcc	2cf3f4 <__bss_end+0x2c57cc>
 bb8:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 bbc:	0d000013 	stceq	0, cr0, [r0, #-76]	; 0xffffffb4
 bc0:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 bc4:	0b3a0e03 	bleq	e843d8 <__bss_end+0xe7a7b0>
 bc8:	0b39053b 	bleq	e420bc <__bss_end+0xe38494>
 bcc:	13491927 	movtne	r1, #39207	; 0x9927
 bd0:	06120111 			; <UNDEFINED> instruction: 0x06120111
 bd4:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 bd8:	00130119 	andseq	r0, r3, r9, lsl r1
 bdc:	00050e00 	andeq	r0, r5, r0, lsl #28
 be0:	0b3a0803 	bleq	e82bf4 <__bss_end+0xe78fcc>
 be4:	0b39053b 	bleq	e420d8 <__bss_end+0xe384b0>
 be8:	17021349 	strne	r1, [r2, -r9, asr #6]
 bec:	001742b7 			; <UNDEFINED> instruction: 0x001742b7
 bf0:	00050f00 	andeq	r0, r5, r0, lsl #30
 bf4:	0b3a0803 	bleq	e82c08 <__bss_end+0xe78fe0>
 bf8:	0b39053b 	bleq	e420ec <__bss_end+0xe384c4>
 bfc:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 c00:	34100000 	ldrcc	r0, [r0], #-0
 c04:	3a080300 	bcc	20180c <__bss_end+0x1f7be4>
 c08:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 c0c:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 c10:	1742b717 	smlaldne	fp, r2, r7, r7
 c14:	0f110000 	svceq	0x00110000
 c18:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
 c1c:	00000013 	andeq	r0, r0, r3, lsl r0

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
  74:	00000194 	muleq	r0, r4, r1
	...
  80:	0000001c 	andeq	r0, r0, ip, lsl r0
  84:	0b520002 	bleq	1480094 <__bss_end+0x147646c>
  88:	00040000 	andeq	r0, r4, r0
  8c:	00000000 	andeq	r0, r0, r0
  90:	000083c0 	andeq	r8, r0, r0, asr #7
  94:	0000045c 	andeq	r0, r0, ip, asr r4
	...
  a0:	0000001c 	andeq	r0, r0, ip, lsl r0
  a4:	16e70002 	strbtne	r0, [r7], r2
  a8:	00040000 	andeq	r0, r4, r0
  ac:	00000000 	andeq	r0, r0, r0
  b0:	00008820 	andeq	r8, r0, r0, lsr #16
  b4:	00000c5c 	andeq	r0, r0, ip, asr ip
	...
  c0:	0000001c 	andeq	r0, r0, ip, lsl r0
  c4:	1d180002 	ldcne	0, cr0, [r8, #-8]
  c8:	00040000 	andeq	r0, r4, r0
  cc:	00000000 	andeq	r0, r0, r0
  d0:	0000947c 	andeq	r9, r0, ip, ror r4
  d4:	0000020c 	andeq	r0, r0, ip, lsl #4
	...
  e0:	0000001c 	andeq	r0, r0, ip, lsl r0
  e4:	1d3e0002 	ldcne	0, cr0, [lr, #-8]!
  e8:	00040000 	andeq	r0, r4, r0
  ec:	00000000 	andeq	r0, r0, r0
  f0:	00009688 	andeq	r9, r0, r8, lsl #13
  f4:	00000004 	andeq	r0, r0, r4
	...
 100:	0000001c 	andeq	r0, r0, ip, lsl r0
 104:	1d640002 	stclne	0, cr0, [r4, #-8]!
 108:	00040000 	andeq	r0, r4, r0
 10c:	00000000 	andeq	r0, r0, r0
 110:	0000968c 	andeq	r9, r0, ip, lsl #13
 114:	00000250 	andeq	r0, r0, r0, asr r2
	...
 120:	0000001c 	andeq	r0, r0, ip, lsl r0
 124:	1d8a0002 	stcne	0, cr0, [sl, #8]
 128:	00040000 	andeq	r0, r4, r0
 12c:	00000000 	andeq	r0, r0, r0
 130:	000098dc 	ldrdeq	r9, [r0], -ip
 134:	000000d4 	ldrdeq	r0, [r0], -r4
	...
 140:	00000014 	andeq	r0, r0, r4, lsl r0
 144:	1db00002 	ldcne	0, cr0, [r0, #8]!
 148:	00040000 	andeq	r0, r4, r0
	...
 158:	0000001c 	andeq	r0, r0, ip, lsl r0
 15c:	20de0002 	sbcscs	r0, lr, r2
 160:	00040000 	andeq	r0, r4, r0
 164:	00000000 	andeq	r0, r0, r0
 168:	000099b0 			; <UNDEFINED> instruction: 0x000099b0
 16c:	00000030 	andeq	r0, r0, r0, lsr r0
	...
 178:	0000001c 	andeq	r0, r0, ip, lsl r0
 17c:	23e80002 	mvncs	r0, #2
 180:	00040000 	andeq	r0, r4, r0
 184:	00000000 	andeq	r0, r0, r0
 188:	000099e0 	andeq	r9, r0, r0, ror #19
 18c:	00000040 	andeq	r0, r0, r0, asr #32
	...
 198:	0000001c 	andeq	r0, r0, ip, lsl r0
 19c:	27160002 	ldrcs	r0, [r6, -r2]
 1a0:	00040000 	andeq	r0, r4, r0
 1a4:	00000000 	andeq	r0, r0, r0
 1a8:	00009a20 	andeq	r9, r0, r0, lsr #20
 1ac:	00000120 	andeq	r0, r0, r0, lsr #2
	...

Disassembly of section .debug_str:

00000000 <.debug_str>:
       0:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; ffffff4c <__bss_end+0xffff6324>
       4:	72742f65 	rsbsvc	r2, r4, #404	; 0x194
       8:	6c696665 	stclvs	6, cr6, [r9], #-404	; 0xfffffe6c
       c:	6d65732f 	stclvs	3, cr7, [r5, #-188]!	; 0xffffff44
      10:	756f732f 	strbvc	r7, [pc, #-815]!	; fffffce9 <__bss_end+0xffff60c1>
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
      40:	752f7365 	strvc	r7, [pc, #-869]!	; fffffce3 <__bss_end+0xffff60bb>
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
      dc:	2b6b7a36 	blcs	1ade9bc <__bss_end+0x1ad4d94>
      e0:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
      e4:	672d2067 	strvs	r2, [sp, -r7, rrx]!
      e8:	304f2d20 	subcc	r2, pc, r0, lsr #26
      ec:	304f2d20 	subcc	r2, pc, r0, lsr #26
      f0:	625f5f00 	subsvs	r5, pc, #0, 30
      f4:	655f7373 	ldrbvs	r7, [pc, #-883]	; fffffd89 <__bss_end+0xffff6161>
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
     160:	755f6962 	ldrbvc	r6, [pc, #-2402]	; fffff806 <__bss_end+0xffff5bde>
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
     260:	2b432055 	blcs	10c83bc <__bss_end+0x10be794>
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
     2c4:	7a6a3637 	bvc	1a8dba8 <__bss_end+0x1a83f80>
     2c8:	20732d66 	rsbscs	r2, r3, r6, ror #26
     2cc:	72616d2d 	rsbvc	r6, r1, #2880	; 0xb40
     2d0:	6d2d206d 	stcvs	0, cr2, [sp, #-436]!	; 0xfffffe4c
     2d4:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
     2d8:	6d72613d 	ldfvse	f6, [r2, #-244]!	; 0xffffff0c
     2dc:	6b7a3676 	blvs	1e8dcbc <__bss_end+0x1e84094>
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
     350:	5a5f006e 	bpl	17c0510 <__bss_end+0x17b68e8>
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
     384:	5a5f0076 	bpl	17c0564 <__bss_end+0x17b693c>
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
     3b0:	6b736154 	blvs	1cd8908 <__bss_end+0x1ccece0>
     3b4:	7274535f 	rsbsvc	r5, r4, #2080374785	; 0x7c000001
     3b8:	00746375 	rsbseq	r6, r4, r5, ror r3
     3bc:	74736166 	ldrbtvc	r6, [r3], #-358	; 0xfffffe9a
     3c0:	6d6e5500 	cfstr64vs	mvdx5, [lr, #-0]
     3c4:	465f7061 	ldrbmi	r7, [pc], -r1, rrx
     3c8:	5f656c69 	svcpl	0x00656c69
     3cc:	72727543 	rsbsvc	r7, r2, #281018368	; 0x10c00000
     3d0:	00746e65 	rsbseq	r6, r4, r5, ror #28
     3d4:	32435342 	subcc	r5, r3, #134217729	; 0x8000001
     3d8:	7361425f 	cmnvc	r1, #-268435451	; 0xf0000005
     3dc:	614d0065 	cmpvs	sp, r5, rrx
     3e0:	636f6c6c 	cmnvs	pc, #108, 24	; 0x6c00
     3e4:	72506d00 	subsvc	r6, r0, #0, 26
     3e8:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     3ec:	694c5f73 	stmdbvs	ip, {r0, r1, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     3f0:	485f7473 	ldmdami	pc, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
     3f4:	00646165 	rsbeq	r6, r4, r5, ror #2
     3f8:	4b4e5a5f 	blmi	1396d7c <__bss_end+0x138d154>
     3fc:	50433631 	subpl	r3, r3, r1, lsr r6
     400:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     404:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 240 <shift+0x240>
     408:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     40c:	39317265 	ldmdbcc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
     410:	5f746547 	svcpl	0x00746547
     414:	72727543 	rsbsvc	r7, r2, #281018368	; 0x10c00000
     418:	5f746e65 	svcpl	0x00746e65
     41c:	636f7250 	cmnvs	pc, #80, 4
     420:	45737365 	ldrbmi	r7, [r3, #-869]!	; 0xfffffc9b
     424:	656e0076 	strbvs	r0, [lr, #-118]!	; 0xffffff8a
     428:	47007478 	smlsdxmi	r0, r8, r4, r7
     42c:	505f7465 	subspl	r7, pc, r5, ror #8
     430:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     434:	425f7373 	subsmi	r7, pc, #-872415231	; 0xcc000001
     438:	49505f79 	ldmdbmi	r0, {r0, r3, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     43c:	65520044 	ldrbvs	r0, [r2, #-68]	; 0xffffffbc
     440:	41006461 	tstmi	r0, r1, ror #8
     444:	76697463 	strbtvc	r7, [r9], -r3, ror #8
     448:	72505f65 	subsvc	r5, r0, #404	; 0x194
     44c:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     450:	6f435f73 	svcvs	0x00435f73
     454:	00746e75 	rsbseq	r6, r4, r5, ror lr
     458:	61657243 	cmnvs	r5, r3, asr #4
     45c:	505f6574 	subspl	r6, pc, r4, ror r5	; <UNPREDICTABLE>
     460:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     464:	73007373 	movwvc	r7, #883	; 0x373
     468:	65746174 	ldrbvs	r6, [r4, #-372]!	; 0xfffffe8c
     46c:	78614d00 	stmdavc	r1!, {r8, sl, fp, lr}^
     470:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     474:	656d616e 	strbvs	r6, [sp, #-366]!	; 0xfffffe92
     478:	676e654c 	strbvs	r6, [lr, -ip, asr #10]!
     47c:	41006874 	tstmi	r0, r4, ror r8
     480:	425f5855 	subsmi	r5, pc, #5570560	; 0x550000
     484:	00657361 	rsbeq	r7, r5, r1, ror #6
     488:	5f746547 	svcpl	0x00746547
     48c:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     490:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
     494:	6e495f72 	mcrvs	15, 2, r5, cr9, cr2, {3}
     498:	44006f66 	strmi	r6, [r0], #-3942	; 0xfffff09a
     49c:	6c646165 	stfvse	f6, [r4], #-404	; 0xfffffe6c
     4a0:	5f656e69 	svcpl	0x00656e69
     4a4:	68636e55 	stmdavs	r3!, {r0, r2, r4, r6, r9, sl, fp, sp, lr}^
     4a8:	65676e61 	strbvs	r6, [r7, #-3681]!	; 0xfffff19f
     4ac:	50430064 	subpl	r0, r3, r4, rrx
     4b0:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     4b4:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 2f0 <shift+0x2f0>
     4b8:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     4bc:	5f007265 	svcpl	0x00007265
     4c0:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     4c4:	6f725043 	svcvs	0x00725043
     4c8:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     4cc:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     4d0:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     4d4:	65473831 	strbvs	r3, [r7, #-2097]	; 0xfffff7cf
     4d8:	63535f74 	cmpvs	r3, #116, 30	; 0x1d0
     4dc:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
     4e0:	5f72656c 	svcpl	0x0072656c
     4e4:	6f666e49 	svcvs	0x00666e49
     4e8:	4e303245 	cdpmi	2, 3, cr3, cr0, cr5, {2}
     4ec:	5f746547 	svcpl	0x00746547
     4f0:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     4f4:	6e495f64 	cdpvs	15, 4, cr5, cr9, cr4, {3}
     4f8:	545f6f66 	ldrbpl	r6, [pc], #-3942	; 500 <shift+0x500>
     4fc:	50657079 	rsbpl	r7, r5, r9, ror r0
     500:	5a5f0076 	bpl	17c06e0 <__bss_end+0x17b6ab8>
     504:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     508:	636f7250 	cmnvs	pc, #80, 4
     50c:	5f737365 	svcpl	0x00737365
     510:	616e614d 	cmnvs	lr, sp, asr #2
     514:	32726567 	rsbscc	r6, r2, #432013312	; 0x19c00000
     518:	6e614831 	mcrvs	8, 3, r4, cr1, cr1, {1}
     51c:	5f656c64 	svcpl	0x00656c64
     520:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     524:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
     528:	535f6d65 	cmppl	pc, #6464	; 0x1940
     52c:	32454957 	subcc	r4, r5, #1425408	; 0x15c000
     530:	57534e33 	smmlarpl	r3, r3, lr, r4
     534:	69465f49 	stmdbvs	r6, {r0, r3, r6, r8, r9, sl, fp, ip, lr}^
     538:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
     53c:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
     540:	7265535f 	rsbvc	r5, r5, #2080374785	; 0x7c000001
     544:	65636976 	strbvs	r6, [r3, #-2422]!	; 0xfffff68a
     548:	526a6a6a 	rsbpl	r6, sl, #434176	; 0x6a000
     54c:	53543131 	cmppl	r4, #1073741836	; 0x4000000c
     550:	525f4957 	subspl	r4, pc, #1425408	; 0x15c000
     554:	6c757365 	ldclvs	3, cr7, [r5], #-404	; 0xfffffe6c
     558:	706f0074 	rsbvc	r0, pc, r4, ror r0	; <UNPREDICTABLE>
     55c:	64656e65 	strbtvs	r6, [r5], #-3685	; 0xfffff19b
     560:	6c69665f 	stclvs	6, cr6, [r9], #-380	; 0xfffffe84
     564:	4e007365 	cdpmi	3, 0, cr7, cr0, cr5, {3}
     568:	6669746f 	strbtvs	r7, [r9], -pc, ror #8
     56c:	6c6c4179 	stfvse	f4, [ip], #-484	; 0xfffffe1c
     570:	50435400 	subpl	r5, r3, r0, lsl #8
     574:	6f435f55 	svcvs	0x00435f55
     578:	7865746e 	stmdavc	r5!, {r1, r2, r3, r5, r6, sl, ip, sp, lr}^
     57c:	65440074 	strbvs	r0, [r4, #-116]	; 0xffffff8c
     580:	696c6461 	stmdbvs	ip!, {r0, r5, r6, sl, sp, lr}^
     584:	7400656e 	strvc	r6, [r0], #-1390	; 0xfffffa92
     588:	30726274 	rsbscc	r6, r2, r4, ror r2
     58c:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     590:	50433631 	subpl	r3, r3, r1, lsr r6
     594:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     598:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 3d4 <shift+0x3d4>
     59c:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     5a0:	34317265 	ldrtcc	r7, [r1], #-613	; 0xfffffd9b
     5a4:	69746f4e 	ldmdbvs	r4!, {r1, r2, r3, r6, r8, r9, sl, fp, sp, lr}^
     5a8:	505f7966 	subspl	r7, pc, r6, ror #18
     5ac:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     5b0:	6a457373 	bvs	115d384 <__bss_end+0x115375c>
     5b4:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     5b8:	4449505f 	strbmi	r5, [r9], #-95	; 0xffffffa1
     5bc:	43534200 	cmpmi	r3, #0, 4
     5c0:	61425f30 	cmpvs	r2, r0, lsr pc
     5c4:	2f006573 	svccs	0x00006573
     5c8:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
     5cc:	6572742f 	ldrbvs	r7, [r2, #-1071]!	; 0xfffffbd1
     5d0:	2f6c6966 	svccs	0x006c6966
     5d4:	2f6d6573 	svccs	0x006d6573
     5d8:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
     5dc:	2f736563 	svccs	0x00736563
     5e0:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
     5e4:	63617073 	cmnvs	r1, #115	; 0x73
     5e8:	6f632f65 	svcvs	0x00632f65
     5ec:	65746e75 	ldrbvs	r6, [r4, #-3701]!	; 0xfffff18b
     5f0:	61745f72 	cmnvs	r4, r2, ror pc
     5f4:	6d2f6b73 	fstmdbxvs	pc!, {d6-d62}	;@ Deprecated
     5f8:	2e6e6961 	vnmulcs.f16	s13, s28, s3	; <UNPREDICTABLE>
     5fc:	00707063 	rsbseq	r7, r0, r3, rrx
     600:	69746f6e 	ldmdbvs	r4!, {r1, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
     604:	64656966 	strbtvs	r6, [r5], #-2406	; 0xfffff69a
     608:	6165645f 	cmnvs	r5, pc, asr r4
     60c:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
     610:	6e490065 	cdpvs	0, 4, cr0, cr9, cr5, {3}
     614:	72726574 	rsbsvc	r6, r2, #116, 10	; 0x1d000000
     618:	5f747075 	svcpl	0x00747075
     61c:	746e6f43 	strbtvc	r6, [lr], #-3907	; 0xfffff0bd
     620:	6c6c6f72 	stclvs	15, cr6, [ip], #-456	; 0xfffffe38
     624:	425f7265 	subsmi	r7, pc, #1342177286	; 0x50000006
     628:	00657361 	rsbeq	r7, r5, r1, ror #6
     62c:	31435342 	cmpcc	r3, r2, asr #6
     630:	7361425f 	cmnvc	r1, #-268435451	; 0xf0000005
     634:	614d0065 	cmpvs	sp, r5, rrx
     638:	72505f78 	subsvc	r5, r0, #120, 30	; 0x1e0
     63c:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     640:	704f5f73 	subvc	r5, pc, r3, ror pc	; <UNPREDICTABLE>
     644:	64656e65 	strbtvs	r6, [r5], #-3685	; 0xfffff19b
     648:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     64c:	5f007365 	svcpl	0x00007365
     650:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     654:	6f725043 	svcvs	0x00725043
     658:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     65c:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     660:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     664:	6e553831 	mrcvs	8, 2, r3, cr5, cr1, {1}
     668:	5f70616d 	svcpl	0x0070616d
     66c:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     670:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
     674:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     678:	54006a45 	strpl	r6, [r0], #-2629	; 0xfffff5bb
     67c:	5f474e52 	svcpl	0x00474e52
     680:	65736142 	ldrbvs	r6, [r3, #-322]!	; 0xfffffebe
     684:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     688:	50433631 	subpl	r3, r3, r1, lsr r6
     68c:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     690:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 4cc <shift+0x4cc>
     694:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     698:	32317265 	eorscc	r7, r1, #1342177286	; 0x50000006
     69c:	466e7552 			; <UNDEFINED> instruction: 0x466e7552
     6a0:	74737269 	ldrbtvc	r7, [r3], #-617	; 0xfffffd97
     6a4:	6b736154 	blvs	1cd8bfc <__bss_end+0x1ccefd4>
     6a8:	61007645 	tstvs	r0, r5, asr #12
     6ac:	6e656373 	mcrvs	3, 3, r6, cr5, cr3, {3}
     6b0:	676e6964 	strbvs	r6, [lr, -r4, ror #18]!
     6b4:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     6b8:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
     6bc:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     6c0:	6f72505f 	svcvs	0x0072505f
     6c4:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     6c8:	70614d00 	rsbvc	r4, r1, r0, lsl #26
     6cc:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     6d0:	6f545f65 	svcvs	0x00545f65
     6d4:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
     6d8:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     6dc:	6f6c4200 	svcvs	0x006c4200
     6e0:	435f6b63 	cmpmi	pc, #101376	; 0x18c00
     6e4:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
     6e8:	505f746e 	subspl	r7, pc, lr, ror #8
     6ec:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     6f0:	73007373 	movwvc	r7, #883	; 0x373
     6f4:	63746977 	cmnvs	r4, #1949696	; 0x1dc000
     6f8:	665f3268 	ldrbvs	r3, [pc], -r8, ror #4
     6fc:	00656c69 	rsbeq	r6, r5, r9, ror #24
     700:	69466f4e 	stmdbvs	r6, {r1, r2, r3, r6, r8, r9, sl, fp, sp, lr}^
     704:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
     708:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
     70c:	76697244 	strbtvc	r7, [r9], -r4, asr #4
     710:	6c007265 	sfmvs	f7, 4, [r0], {101}	; 0x65
     714:	6369676f 	cmnvs	r9, #29097984	; 0x1bc0000
     718:	625f6c61 	subsvs	r6, pc, #24832	; 0x6100
     71c:	6b616572 	blvs	1859cec <__bss_end+0x18500c4>
     720:	6e614800 	cdpvs	8, 6, cr4, cr1, cr0, {0}
     724:	5f656c64 	svcpl	0x00656c64
     728:	636f7250 	cmnvs	pc, #80, 4
     72c:	5f737365 	svcpl	0x00737365
     730:	00495753 	subeq	r5, r9, r3, asr r7
     734:	726f6873 	rsbvc	r6, pc, #7536640	; 0x730000
     738:	6e752074 	mrcvs	0, 3, r2, cr5, cr4, {3}
     73c:	6e676973 			; <UNDEFINED> instruction: 0x6e676973
     740:	69206465 	stmdbvs	r0!, {r0, r2, r5, r6, sl, sp, lr}
     744:	5300746e 	movwpl	r7, #1134	; 0x46e
     748:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     74c:	5f656c75 	svcpl	0x00656c75
     750:	00464445 	subeq	r4, r6, r5, asr #8
     754:	74696157 	strbtvc	r6, [r9], #-343	; 0xfffffea9
     758:	746e4900 	strbtvc	r4, [lr], #-2304	; 0xfffff700
     75c:	75727265 	ldrbvc	r7, [r2, #-613]!	; 0xfffffd9b
     760:	62617470 	rsbvs	r7, r1, #112, 8	; 0x70000000
     764:	535f656c 	cmppl	pc, #108, 10	; 0x1b000000
     768:	7065656c 	rsbvc	r6, r5, ip, ror #10
     76c:	57534e00 	ldrbpl	r4, [r3, -r0, lsl #28]
     770:	72505f49 	subsvc	r5, r0, #292	; 0x124
     774:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     778:	65535f73 	ldrbvs	r5, [r3, #-3955]	; 0xfffff08d
     77c:	63697672 	cmnvs	r9, #119537664	; 0x7200000
     780:	69640065 	stmdbvs	r4!, {r0, r2, r5, r6}^
     784:	616c7073 	smcvs	50947	; 0xc703
     788:	69665f79 	stmdbvs	r6!, {r0, r3, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     78c:	6200656c 	andvs	r6, r0, #108, 10	; 0x1b000000
     790:	006c6f6f 	rsbeq	r6, ip, pc, ror #30
     794:	73614c6d 	cmnvc	r1, #27904	; 0x6d00
     798:	49505f74 	ldmdbmi	r0, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     79c:	6c420044 	mcrrvs	0, 4, r0, r2, cr4
     7a0:	656b636f 	strbvs	r6, [fp, #-879]!	; 0xfffffc91
     7a4:	474e0064 	strbmi	r0, [lr, -r4, rrx]
     7a8:	535f7465 	cmppl	pc, #1694498816	; 0x65000000
     7ac:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     7b0:	666e495f 			; <UNDEFINED> instruction: 0x666e495f
     7b4:	79545f6f 	ldmdbvc	r4, {r0, r1, r2, r3, r5, r6, r8, r9, sl, fp, ip, lr}^
     7b8:	52006570 	andpl	r6, r0, #112, 10	; 0x1c000000
     7bc:	616e6e75 	smcvs	59109	; 0xe6e5
     7c0:	00656c62 	rsbeq	r6, r5, r2, ror #24
     7c4:	7361544e 	cmnvc	r1, #1308622848	; 0x4e000000
     7c8:	74535f6b 	ldrbvc	r5, [r3], #-3947	; 0xfffff095
     7cc:	00657461 	rsbeq	r7, r5, r1, ror #8
     7d0:	65686373 	strbvs	r6, [r8, #-883]!	; 0xfffffc8d
     7d4:	6f635f64 	svcvs	0x00635f64
     7d8:	65746e75 	ldrbvs	r6, [r4, #-3701]!	; 0xfffff18b
     7dc:	63730072 	cmnvs	r3, #114	; 0x72
     7e0:	5f646568 	svcpl	0x00646568
     7e4:	74617473 	strbtvc	r7, [r1], #-1139	; 0xfffffb8d
     7e8:	705f6369 	subsvc	r6, pc, r9, ror #6
     7ec:	726f6972 	rsbvc	r6, pc, #1867776	; 0x1c8000
     7f0:	00797469 	rsbseq	r7, r9, r9, ror #8
     7f4:	74697865 	strbtvc	r7, [r9], #-2149	; 0xfffff79b
     7f8:	646f635f 	strbtvs	r6, [pc], #-863	; 800 <shift+0x800>
     7fc:	5a5f0065 	bpl	17c0998 <__bss_end+0x17b6d70>
     800:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     804:	636f7250 	cmnvs	pc, #80, 4
     808:	5f737365 	svcpl	0x00737365
     80c:	616e614d 	cmnvs	lr, sp, asr #2
     810:	34726567 	ldrbtcc	r6, [r2], #-1383	; 0xfffffa99
     814:	6b726253 	blvs	1c99168 <__bss_end+0x1c8f540>
     818:	6d006a45 	vstrvs	s12, [r0, #-276]	; 0xfffffeec
     81c:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     820:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
     824:	636e465f 	cmnvs	lr, #99614720	; 0x5f00000
     828:	49504700 	ldmdbmi	r0, {r8, r9, sl, lr}^
     82c:	61425f4f 	cmpvs	r2, pc, asr #30
     830:	4d006573 	cfstr32mi	mvfx6, [r0, #-460]	; 0xfffffe34
     834:	53467861 	movtpl	r7, #26721	; 0x6861
     838:	76697244 	strbtvc	r7, [r9], -r4, asr #4
     83c:	614e7265 	cmpvs	lr, r5, ror #4
     840:	654c656d 	strbvs	r6, [ip, #-1389]	; 0xfffffa93
     844:	6874676e 	ldmdavs	r4!, {r1, r2, r3, r5, r6, r8, r9, sl, sp, lr}^
     848:	746f4e00 	strbtvc	r4, [pc], #-3584	; 850 <shift+0x850>
     84c:	00796669 	rsbseq	r6, r9, r9, ror #12
     850:	61666544 	cmnvs	r6, r4, asr #10
     854:	5f746c75 	svcpl	0x00746c75
     858:	636f6c43 	cmnvs	pc, #17152	; 0x4300
     85c:	61525f6b 	cmpvs	r2, fp, ror #30
     860:	52006574 	andpl	r6, r0, #116, 10	; 0x1d000000
     864:	69466e75 	stmdbvs	r6, {r0, r2, r4, r5, r6, r9, sl, fp, sp, lr}^
     868:	54747372 	ldrbtpl	r7, [r4], #-882	; 0xfffffc8e
     86c:	006b7361 	rsbeq	r7, fp, r1, ror #6
     870:	6b636f4c 	blvs	18dc5a8 <__bss_end+0x18d2980>
     874:	6c6e555f 	cfstr64vs	mvdx5, [lr], #-380	; 0xfffffe84
     878:	656b636f 	strbvs	r6, [fp, #-879]!	; 0xfffffc91
     87c:	6f4c0064 	svcvs	0x004c0064
     880:	4c5f6b63 	mrrcmi	11, 6, r6, pc, cr3	; <UNPREDICTABLE>
     884:	656b636f 	strbvs	r6, [fp, #-879]!	; 0xfffffc91
     888:	68700064 	ldmdavs	r0!, {r2, r5, r6}^
     88c:	63697379 	cmnvs	r9, #-469762047	; 0xe4000001
     890:	625f6c61 	subsvs	r6, pc, #24832	; 0x6100
     894:	6b616572 	blvs	1859e64 <__bss_end+0x185023c>
     898:	61655200 	cmnvs	r5, r0, lsl #4
     89c:	72575f64 	subsvc	r5, r7, #100, 30	; 0x190
     8a0:	00657469 	rsbeq	r7, r5, r9, ror #8
     8a4:	626d6f5a 	rsbvs	r6, sp, #360	; 0x168
     8a8:	47006569 	strmi	r6, [r0, -r9, ror #10]
     8ac:	535f7465 	cmppl	pc, #1694498816	; 0x65000000
     8b0:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     8b4:	666e495f 			; <UNDEFINED> instruction: 0x666e495f
     8b8:	5a5f006f 	bpl	17c0a7c <__bss_end+0x17b6e54>
     8bc:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     8c0:	636f7250 	cmnvs	pc, #80, 4
     8c4:	5f737365 	svcpl	0x00737365
     8c8:	616e614d 	cmnvs	lr, sp, asr #2
     8cc:	38726567 	ldmdacc	r2!, {r0, r1, r2, r5, r6, r8, sl, sp, lr}^
     8d0:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     8d4:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
     8d8:	5f007645 	svcpl	0x00007645
     8dc:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     8e0:	6f725043 	svcvs	0x00725043
     8e4:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     8e8:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     8ec:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     8f0:	614d3931 	cmpvs	sp, r1, lsr r9
     8f4:	69465f70 	stmdbvs	r6, {r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     8f8:	545f656c 	ldrbpl	r6, [pc], #-1388	; 900 <shift+0x900>
     8fc:	75435f6f 	strbvc	r5, [r3, #-3951]	; 0xfffff091
     900:	6e657272 	mcrvs	2, 3, r7, cr5, cr2, {3}
     904:	35504574 	ldrbcc	r4, [r0, #-1396]	; 0xfffffa8c
     908:	6c694649 	stclvs	6, cr4, [r9], #-292	; 0xfffffedc
     90c:	614d0065 	cmpvs	sp, r5, rrx
     910:	74615078 	strbtvc	r5, [r1], #-120	; 0xffffff88
     914:	6e654c68 	cdpvs	12, 6, cr4, cr5, cr8, {3}
     918:	00687467 	rsbeq	r7, r8, r7, ror #8
     91c:	69736e75 	ldmdbvs	r3!, {r0, r2, r4, r5, r6, r9, sl, fp, sp, lr}^
     920:	64656e67 	strbtvs	r6, [r5], #-3687	; 0xfffff199
     924:	61686320 	cmnvs	r8, r0, lsr #6
     928:	79530072 	ldmdbvc	r3, {r1, r4, r5, r6}^
     92c:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
     930:	6d69545f 	cfstrdvs	mvd5, [r9, #-380]!	; 0xfffffe84
     934:	425f7265 	subsmi	r7, pc, #1342177286	; 0x50000006
     938:	00657361 	rsbeq	r7, r5, r1, ror #6
     93c:	314e5a5f 	cmpcc	lr, pc, asr sl
     940:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     944:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     948:	614d5f73 	hvcvs	54771	; 0xd5f3
     94c:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     950:	53323172 	teqpl	r2, #-2147483620	; 0x8000001c
     954:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     958:	5f656c75 	svcpl	0x00656c75
     95c:	45464445 	strbmi	r4, [r6, #-1093]	; 0xfffffbbb
     960:	50470076 	subpl	r0, r7, r6, ror r0
     964:	505f4f49 	subspl	r4, pc, r9, asr #30
     968:	435f6e69 	cmpmi	pc, #1680	; 0x690
     96c:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
     970:	6f687300 	svcvs	0x00687300
     974:	69207472 	stmdbvs	r0!, {r1, r4, r5, r6, sl, ip, sp, lr}
     978:	4900746e 	stmdbmi	r0, {r1, r2, r3, r5, r6, sl, ip, sp, lr}
     97c:	6c61766e 	stclvs	6, cr7, [r1], #-440	; 0xfffffe48
     980:	505f6469 	subspl	r6, pc, r9, ror #8
     984:	50006e69 	andpl	r6, r0, r9, ror #28
     988:	70697265 	rsbvc	r7, r9, r5, ror #4
     98c:	61726568 	cmnvs	r2, r8, ror #10
     990:	61425f6c 	cmpvs	r2, ip, ror #30
     994:	52006573 	andpl	r6, r0, #482344960	; 0x1cc00000
     998:	696e6e75 	stmdbvs	lr!, {r0, r2, r4, r5, r6, r9, sl, fp, sp, lr}^
     99c:	7500676e 	strvc	r6, [r0, #-1902]	; 0xfffff892
     9a0:	33746e69 	cmncc	r4, #1680	; 0x690
     9a4:	00745f32 	rsbseq	r5, r4, r2, lsr pc
     9a8:	7275436d 	rsbsvc	r4, r5, #-1275068415	; 0xb4000001
     9ac:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     9b0:	7361545f 	cmnvc	r1, #1593835520	; 0x5f000000
     9b4:	6f4e5f6b 	svcvs	0x004e5f6b
     9b8:	63006564 	movwvs	r6, #1380	; 0x564
     9bc:	635f7570 	cmpvs	pc, #112, 10	; 0x1c000000
     9c0:	65746e6f 	ldrbvs	r6, [r4, #-3695]!	; 0xfffff191
     9c4:	52007478 	andpl	r7, r0, #120, 8	; 0x78000000
     9c8:	5f646165 	svcpl	0x00646165
     9cc:	796c6e4f 	stmdbvc	ip!, {r0, r1, r2, r3, r6, r9, sl, fp, sp, lr}^
     9d0:	656c7300 	strbvs	r7, [ip, #-768]!	; 0xfffffd00
     9d4:	745f7065 	ldrbvc	r7, [pc], #-101	; 9dc <shift+0x9dc>
     9d8:	72656d69 	rsbvc	r6, r5, #6720	; 0x1a40
     9dc:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     9e0:	4336314b 	teqmi	r6, #-1073741806	; 0xc0000012
     9e4:	636f7250 	cmnvs	pc, #80, 4
     9e8:	5f737365 	svcpl	0x00737365
     9ec:	616e614d 	cmnvs	lr, sp, asr #2
     9f0:	31726567 	cmncc	r2, r7, ror #10
     9f4:	74654738 	strbtvc	r4, [r5], #-1848	; 0xfffff8c8
     9f8:	6f72505f 	svcvs	0x0072505f
     9fc:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     a00:	5f79425f 	svcpl	0x0079425f
     a04:	45444950 	strbmi	r4, [r4, #-2384]	; 0xfffff6b0
     a08:	6148006a 	cmpvs	r8, sl, rrx
     a0c:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     a10:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     a14:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     a18:	5f6d6574 	svcpl	0x006d6574
     a1c:	00495753 	subeq	r5, r9, r3, asr r7
     a20:	314e5a5f 	cmpcc	lr, pc, asr sl
     a24:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     a28:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     a2c:	614d5f73 	hvcvs	54771	; 0xd5f3
     a30:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     a34:	53313172 	teqpl	r1, #-2147483620	; 0x8000001c
     a38:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     a3c:	5f656c75 	svcpl	0x00656c75
     a40:	76455252 			; <UNDEFINED> instruction: 0x76455252
     a44:	73617400 	cmnvc	r1, #0, 8
     a48:	6253006b 	subsvs	r0, r3, #107	; 0x6b
     a4c:	4e006b72 	vmovmi.16	d0[1], r6
     a50:	6669746f 	strbtvs	r7, [r9], -pc, ror #8
     a54:	72505f79 	subsvc	r5, r0, #484	; 0x1e4
     a58:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     a5c:	63530073 	cmpvs	r3, #115	; 0x73
     a60:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
     a64:	5f00656c 	svcpl	0x0000656c
     a68:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     a6c:	6f725043 	svcvs	0x00725043
     a70:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     a74:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     a78:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     a7c:	69775339 	ldmdbvs	r7!, {r0, r3, r4, r5, r8, r9, ip, lr}^
     a80:	5f686374 	svcpl	0x00686374
     a84:	50456f54 	subpl	r6, r5, r4, asr pc
     a88:	50433831 	subpl	r3, r3, r1, lsr r8
     a8c:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     a90:	4c5f7373 	mrrcmi	3, 7, r7, pc, cr3	; <UNPREDICTABLE>
     a94:	5f747369 	svcpl	0x00747369
     a98:	65646f4e 	strbvs	r6, [r4, #-3918]!	; 0xfffff0b2
     a9c:	68635300 	stmdavs	r3!, {r8, r9, ip, lr}^
     aa0:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
     aa4:	52525f65 	subspl	r5, r2, #404	; 0x194
     aa8:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     aac:	50433631 	subpl	r3, r3, r1, lsr r6
     ab0:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     ab4:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 8f0 <shift+0x8f0>
     ab8:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     abc:	38317265 	ldmdacc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
     ac0:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     ac4:	505f656c 	subspl	r6, pc, ip, ror #10
     ac8:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     acc:	535f7373 	cmppl	pc, #-872415231	; 0xcc000001
     ad0:	32454957 	subcc	r4, r5, #1425408	; 0x15c000
     ad4:	57534e30 	smmlarpl	r3, r0, lr, r4
     ad8:	72505f49 	subsvc	r5, r0, #292	; 0x124
     adc:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     ae0:	65535f73 	ldrbvs	r5, [r3, #-3955]	; 0xfffff08d
     ae4:	63697672 	cmnvs	r9, #119537664	; 0x7200000
     ae8:	6a6a6a65 	bvs	1a9b484 <__bss_end+0x1a9185c>
     aec:	54313152 	ldrtpl	r3, [r1], #-338	; 0xfffffeae
     af0:	5f495753 	svcpl	0x00495753
     af4:	75736552 	ldrbvc	r6, [r3, #-1362]!	; 0xfffffaae
     af8:	6100746c 	tstvs	r0, ip, ror #8
     afc:	00766772 	rsbseq	r6, r6, r2, ror r7
     b00:	314e5a5f 	cmpcc	lr, pc, asr sl
     b04:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     b08:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     b0c:	614d5f73 	hvcvs	54771	; 0xd5f3
     b10:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     b14:	43343172 	teqmi	r4, #-2147483620	; 0x8000001c
     b18:	74616572 	strbtvc	r6, [r1], #-1394	; 0xfffffa8e
     b1c:	72505f65 	subsvc	r5, r0, #404	; 0x194
     b20:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     b24:	68504573 	ldmdavs	r0, {r0, r1, r4, r5, r6, r8, sl, lr}^
     b28:	5300626a 	movwpl	r6, #618	; 0x26a
     b2c:	63746977 	cmnvs	r4, #1949696	; 0x1dc000
     b30:	6f545f68 	svcvs	0x00545f68
     b34:	57534e00 	ldrbpl	r4, [r3, -r0, lsl #28]
     b38:	69465f49 	stmdbvs	r6, {r0, r3, r6, r8, r9, sl, fp, ip, lr}^
     b3c:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
     b40:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
     b44:	7265535f 	rsbvc	r5, r5, #2080374785	; 0x7c000001
     b48:	65636976 	strbvs	r6, [r3, #-2422]!	; 0xfffff68a
     b4c:	766e4900 	strbtvc	r4, [lr], -r0, lsl #18
     b50:	64696c61 	strbtvs	r6, [r9], #-3169	; 0xfffff39f
     b54:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
     b58:	00656c64 	rsbeq	r6, r5, r4, ror #24
     b5c:	65657246 	strbvs	r7, [r5, #-582]!	; 0xfffffdba
     b60:	6f6c4300 	svcvs	0x006c4300
     b64:	61006573 	tstvs	r0, r3, ror r5
     b68:	00636772 	rsbeq	r6, r3, r2, ror r7
     b6c:	70616568 	rsbvc	r6, r1, r8, ror #10
     b70:	6174735f 	cmnvs	r4, pc, asr r3
     b74:	73007472 	movwvc	r7, #1138	; 0x472
     b78:	63746977 	cmnvs	r4, #1949696	; 0x1dc000
     b7c:	665f3168 	ldrbvs	r3, [pc], -r8, ror #2
     b80:	00656c69 	rsbeq	r6, r5, r9, ror #24
     b84:	74697257 	strbtvc	r7, [r9], #-599	; 0xfffffda9
     b88:	6e4f5f65 	cdpvs	15, 4, cr5, cr15, cr5, {3}
     b8c:	5900796c 	stmdbpl	r0, {r2, r3, r5, r6, r8, fp, ip, sp, lr}
     b90:	646c6569 	strbtvs	r6, [ip], #-1385	; 0xfffffa97
     b94:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     b98:	50433631 	subpl	r3, r3, r1, lsr r6
     b9c:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     ba0:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 9dc <shift+0x9dc>
     ba4:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     ba8:	34437265 	strbcc	r7, [r3], #-613	; 0xfffffd9b
     bac:	54007645 	strpl	r7, [r0], #-1605	; 0xfffff9bb
     bb0:	696d7265 	stmdbvs	sp!, {r0, r2, r5, r6, r9, ip, sp, lr}^
     bb4:	6574616e 	ldrbvs	r6, [r4, #-366]!	; 0xfffffe92
     bb8:	434f4900 	movtmi	r4, #63744	; 0xf900
     bbc:	63006c74 	movwvs	r6, #3188	; 0xc74
     bc0:	65736f6c 	ldrbvs	r6, [r3, #-3948]!	; 0xfffff094
     bc4:	74655300 	strbtvc	r5, [r5], #-768	; 0xfffffd00
     bc8:	6c65525f 	sfmvs	f5, 2, [r5], #-380	; 0xfffffe84
     bcc:	76697461 	strbtvc	r7, [r9], -r1, ror #8
     bd0:	65720065 	ldrbvs	r0, [r2, #-101]!	; 0xffffff9b
     bd4:	6c617674 	stclvs	6, cr7, [r1], #-464	; 0xfffffe30
     bd8:	75636e00 	strbvc	r6, [r3, #-3584]!	; 0xfffff200
     bdc:	69700072 	ldmdbvs	r0!, {r1, r4, r5, r6}^
     be0:	72006570 	andvc	r6, r0, #112, 10	; 0x1c000000
     be4:	6d756e64 	ldclvs	14, cr6, [r5, #-400]!	; 0xfffffe70
     be8:	315a5f00 	cmpcc	sl, r0, lsl #30
     bec:	68637331 	stmdavs	r3!, {r0, r4, r5, r8, r9, ip, sp, lr}^
     bf0:	795f6465 	ldmdbvc	pc, {r0, r2, r5, r6, sl, sp, lr}^	; <UNPREDICTABLE>
     bf4:	646c6569 	strbtvs	r6, [ip], #-1385	; 0xfffffa97
     bf8:	5a5f0076 	bpl	17c0dd8 <__bss_end+0x17b71b0>
     bfc:	65733731 	ldrbvs	r3, [r3, #-1841]!	; 0xfffff8cf
     c00:	61745f74 	cmnvs	r4, r4, ror pc
     c04:	645f6b73 	ldrbvs	r6, [pc], #-2931	; c0c <shift+0xc0c>
     c08:	6c646165 	stfvse	f6, [r4], #-404	; 0xfffffe6c
     c0c:	6a656e69 	bvs	195c5b8 <__bss_end+0x1952990>
     c10:	69617700 	stmdbvs	r1!, {r8, r9, sl, ip, sp, lr}^
     c14:	5a5f0074 	bpl	17c0dec <__bss_end+0x17b71c4>
     c18:	746f6e36 	strbtvc	r6, [pc], #-3638	; c20 <shift+0xc20>
     c1c:	6a796669 	bvs	1e5a5c8 <__bss_end+0x1e509a0>
     c20:	6146006a 	cmpvs	r6, sl, rrx
     c24:	65006c69 	strvs	r6, [r0, #-3177]	; 0xfffff397
     c28:	63746978 	cmnvs	r4, #120, 18	; 0x1e0000
     c2c:	0065646f 	rsbeq	r6, r5, pc, ror #8
     c30:	65686373 	strbvs	r6, [r8, #-883]!	; 0xfffffc8d
     c34:	69795f64 	ldmdbvs	r9!, {r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     c38:	00646c65 	rsbeq	r6, r4, r5, ror #24
     c3c:	6b636974 	blvs	18db214 <__bss_end+0x18d15ec>
     c40:	756f635f 	strbvc	r6, [pc, #-863]!	; 8e9 <shift+0x8e9>
     c44:	725f746e 	subsvc	r7, pc, #1845493760	; 0x6e000000
     c48:	69757165 	ldmdbvs	r5!, {r0, r2, r5, r6, r8, ip, sp, lr}^
     c4c:	00646572 	rsbeq	r6, r4, r2, ror r5
     c50:	34325a5f 	ldrtcc	r5, [r2], #-2655	; 0xfffff5a1
     c54:	5f746567 	svcpl	0x00746567
     c58:	69746361 	ldmdbvs	r4!, {r0, r5, r6, r8, r9, sp, lr}^
     c5c:	705f6576 	subsvc	r6, pc, r6, ror r5	; <UNPREDICTABLE>
     c60:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     c64:	635f7373 	cmpvs	pc, #-872415231	; 0xcc000001
     c68:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
     c6c:	69500076 	ldmdbvs	r0, {r1, r2, r4, r5, r6}^
     c70:	465f6570 			; <UNDEFINED> instruction: 0x465f6570
     c74:	5f656c69 	svcpl	0x00656c69
     c78:	66657250 			; <UNDEFINED> instruction: 0x66657250
     c7c:	53007869 	movwpl	r7, #2153	; 0x869
     c80:	505f7465 	subspl	r7, pc, r5, ror #8
     c84:	6d617261 	sfmvs	f7, 2, [r1, #-388]!	; 0xfffffe7c
     c88:	5a5f0073 	bpl	17c0e5c <__bss_end+0x17b7234>
     c8c:	65673431 	strbvs	r3, [r7, #-1073]!	; 0xfffffbcf
     c90:	69745f74 	ldmdbvs	r4!, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     c94:	635f6b63 	cmpvs	pc, #101376	; 0x18c00
     c98:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
     c9c:	6c730076 	ldclvs	0, cr0, [r3], #-472	; 0xfffffe28
     ca0:	00706565 	rsbseq	r6, r0, r5, ror #10
     ca4:	61736944 	cmnvs	r3, r4, asr #18
     ca8:	5f656c62 	svcpl	0x00656c62
     cac:	6e657645 	cdpvs	6, 6, cr7, cr5, cr5, {2}
     cb0:	65445f74 	strbvs	r5, [r4, #-3956]	; 0xfffff08c
     cb4:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
     cb8:	006e6f69 	rsbeq	r6, lr, r9, ror #30
     cbc:	74395a5f 	ldrtvc	r5, [r9], #-2655	; 0xfffff5a1
     cc0:	696d7265 	stmdbvs	sp!, {r0, r2, r5, r6, r9, ip, sp, lr}^
     cc4:	6574616e 	ldrbvs	r6, [r4, #-366]!	; 0xfffffe92
     cc8:	706f0069 	rsbvc	r0, pc, r9, rrx
     ccc:	74617265 	strbtvc	r7, [r1], #-613	; 0xfffffd9b
     cd0:	006e6f69 	rsbeq	r6, lr, r9, ror #30
     cd4:	63355a5f 	teqvs	r5, #389120	; 0x5f000
     cd8:	65736f6c 	ldrbvs	r6, [r3, #-3948]!	; 0xfffff094
     cdc:	5a5f006a 	bpl	17c0e8c <__bss_end+0x17b7264>
     ce0:	74656736 	strbtvc	r6, [r5], #-1846	; 0xfffff8ca
     ce4:	76646970 			; <UNDEFINED> instruction: 0x76646970
     ce8:	616e6600 	cmnvs	lr, r0, lsl #12
     cec:	4700656d 	strmi	r6, [r0, -sp, ror #10]
     cf0:	4320554e 			; <UNDEFINED> instruction: 0x4320554e
     cf4:	34312b2b 	ldrtcc	r2, [r1], #-2859	; 0xfffff4d5
     cf8:	2e303120 	rsfcssp	f3, f0, f0
     cfc:	20312e33 	eorscs	r2, r1, r3, lsr lr
     d00:	31323032 	teqcc	r2, r2, lsr r0
     d04:	31323630 	teqcc	r2, r0, lsr r6
     d08:	65722820 	ldrbvs	r2, [r2, #-2080]!	; 0xfffff7e0
     d0c:	7361656c 	cmnvc	r1, #108, 10	; 0x1b000000
     d10:	2d202965 			; <UNDEFINED> instruction: 0x2d202965
     d14:	6f6c666d 	svcvs	0x006c666d
     d18:	612d7461 			; <UNDEFINED> instruction: 0x612d7461
     d1c:	683d6962 	ldmdavs	sp!, {r1, r5, r6, r8, fp, sp, lr}
     d20:	20647261 	rsbcs	r7, r4, r1, ror #4
     d24:	70666d2d 	rsbvc	r6, r6, sp, lsr #26
     d28:	66763d75 			; <UNDEFINED> instruction: 0x66763d75
     d2c:	6d2d2070 	stcvs	0, cr2, [sp, #-448]!	; 0xfffffe40
     d30:	616f6c66 	cmnvs	pc, r6, ror #24
     d34:	62612d74 	rsbvs	r2, r1, #116, 26	; 0x1d00
     d38:	61683d69 	cmnvs	r8, r9, ror #26
     d3c:	2d206472 	cfstrscs	mvf6, [r0, #-456]!	; 0xfffffe38
     d40:	7570666d 	ldrbvc	r6, [r0, #-1645]!	; 0xfffff993
     d44:	7066763d 	rsbvc	r7, r6, sp, lsr r6
     d48:	746d2d20 	strbtvc	r2, [sp], #-3360	; 0xfffff2e0
     d4c:	3d656e75 	stclcc	14, cr6, [r5, #-468]!	; 0xfffffe2c
     d50:	316d7261 	cmncc	sp, r1, ror #4
     d54:	6a363731 	bvs	d8ea20 <__bss_end+0xd84df8>
     d58:	732d667a 			; <UNDEFINED> instruction: 0x732d667a
     d5c:	616d2d20 	cmnvs	sp, r0, lsr #26
     d60:	2d206d72 	stccs	13, cr6, [r0, #-456]!	; 0xfffffe38
     d64:	6372616d 	cmnvs	r2, #1073741851	; 0x4000001b
     d68:	72613d68 	rsbvc	r3, r1, #104, 26	; 0x1a00
     d6c:	7a36766d 	bvc	d9e728 <__bss_end+0xd94b00>
     d70:	70662b6b 	rsbvc	r2, r6, fp, ror #22
     d74:	20672d20 	rsbcs	r2, r7, r0, lsr #26
     d78:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
     d7c:	4f2d2067 	svcmi	0x002d2067
     d80:	4f2d2030 	svcmi	0x002d2030
     d84:	662d2030 			; <UNDEFINED> instruction: 0x662d2030
     d88:	652d6f6e 	strvs	r6, [sp, #-3950]!	; 0xfffff092
     d8c:	70656378 	rsbvc	r6, r5, r8, ror r3
     d90:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     d94:	662d2073 			; <UNDEFINED> instruction: 0x662d2073
     d98:	722d6f6e 	eorvc	r6, sp, #440	; 0x1b8
     d9c:	00697474 	rsbeq	r7, r9, r4, ror r4
     da0:	74697277 	strbtvc	r7, [r9], #-631	; 0xfffffd89
     da4:	69740065 	ldmdbvs	r4!, {r0, r2, r5, r6}^
     da8:	00736b63 	rsbseq	r6, r3, r3, ror #22
     dac:	6e65706f 	cdpvs	0, 6, cr7, cr5, cr15, {3}
     db0:	345a5f00 	ldrbcc	r5, [sl], #-3840	; 0xfffff100
     db4:	65706970 	ldrbvs	r6, [r0, #-2416]!	; 0xfffff690
     db8:	6a634b50 	bvs	18d3b00 <__bss_end+0x18c9ed8>
     dbc:	65444e00 	strbvs	r4, [r4, #-3584]	; 0xfffff200
     dc0:	696c6461 	stmdbvs	ip!, {r0, r5, r6, sl, sp, lr}^
     dc4:	535f656e 	cmppl	pc, #461373440	; 0x1b800000
     dc8:	65736275 	ldrbvs	r6, [r3, #-629]!	; 0xfffffd8b
     dcc:	63697672 	cmnvs	r9, #119537664	; 0x7200000
     dd0:	65670065 	strbvs	r0, [r7, #-101]!	; 0xffffff9b
     dd4:	69745f74 	ldmdbvs	r4!, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     dd8:	635f6b63 	cmpvs	pc, #101376	; 0x18c00
     ddc:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
     de0:	72617000 	rsbvc	r7, r1, #0
     de4:	5f006d61 	svcpl	0x00006d61
     de8:	7277355a 	rsbsvc	r3, r7, #377487360	; 0x16800000
     dec:	6a657469 	bvs	195df98 <__bss_end+0x1954370>
     df0:	6a634b50 	bvs	18d3b38 <__bss_end+0x18c9f10>
     df4:	74656700 	strbtvc	r6, [r5], #-1792	; 0xfffff900
     df8:	7361745f 	cmnvc	r1, #1593835520	; 0x5f000000
     dfc:	69745f6b 	ldmdbvs	r4!, {r0, r1, r3, r5, r6, r8, r9, sl, fp, ip, lr}^
     e00:	5f736b63 	svcpl	0x00736b63
     e04:	645f6f74 	ldrbvs	r6, [pc], #-3956	; e0c <shift+0xe0c>
     e08:	6c646165 	stfvse	f6, [r4], #-404	; 0xfffffe6c
     e0c:	00656e69 	rsbeq	r6, r5, r9, ror #28
     e10:	5f667562 	svcpl	0x00667562
     e14:	657a6973 	ldrbvs	r6, [sl, #-2419]!	; 0xfffff68d
     e18:	6f682f00 	svcvs	0x00682f00
     e1c:	742f656d 	strtvc	r6, [pc], #-1389	; e24 <shift+0xe24>
     e20:	69666572 	stmdbvs	r6!, {r1, r4, r5, r6, r8, sl, sp, lr}^
     e24:	65732f6c 	ldrbvs	r2, [r3, #-3948]!	; 0xfffff094
     e28:	6f732f6d 	svcvs	0x00732f6d
     e2c:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
     e30:	75622f73 	strbvc	r2, [r2, #-3955]!	; 0xfffff08d
     e34:	00646c69 	rsbeq	r6, r4, r9, ror #24
     e38:	5f746573 	svcpl	0x00746573
     e3c:	6b736174 	blvs	1cd9414 <__bss_end+0x1ccf7ec>
     e40:	6165645f 	cmnvs	r5, pc, asr r4
     e44:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
     e48:	65470065 	strbvs	r0, [r7, #-101]	; 0xffffff9b
     e4c:	61505f74 	cmpvs	r0, r4, ror pc
     e50:	736d6172 	cmnvc	sp, #-2147483620	; 0x8000001c
     e54:	355a5f00 	ldrbcc	r5, [sl, #-3840]	; 0xfffff100
     e58:	65656c73 	strbvs	r6, [r5, #-3187]!	; 0xfffff38d
     e5c:	006a6a70 	rsbeq	r6, sl, r0, ror sl
     e60:	5f746547 	svcpl	0x00746547
     e64:	616d6552 	cmnvs	sp, r2, asr r5
     e68:	6e696e69 	cdpvs	14, 6, cr6, cr9, cr9, {3}
     e6c:	6e450067 	cdpvs	0, 4, cr0, cr5, cr7, {3}
     e70:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
     e74:	6576455f 	ldrbvs	r4, [r6, #-1375]!	; 0xfffffaa1
     e78:	445f746e 	ldrbmi	r7, [pc], #-1134	; e80 <shift+0xe80>
     e7c:	63657465 	cmnvs	r5, #1694498816	; 0x65000000
     e80:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     e84:	325a5f00 	subscc	r5, sl, #0, 30
     e88:	74656736 	strbtvc	r6, [r5], #-1846	; 0xfffff8ca
     e8c:	7361745f 	cmnvc	r1, #1593835520	; 0x5f000000
     e90:	69745f6b 	ldmdbvs	r4!, {r0, r1, r3, r5, r6, r8, r9, sl, fp, ip, lr}^
     e94:	5f736b63 	svcpl	0x00736b63
     e98:	645f6f74 	ldrbvs	r6, [pc], #-3956	; ea0 <shift+0xea0>
     e9c:	6c646165 	stfvse	f6, [r4], #-404	; 0xfffffe6c
     ea0:	76656e69 	strbtvc	r6, [r5], -r9, ror #28
     ea4:	6f682f00 	svcvs	0x00682f00
     ea8:	742f656d 	strtvc	r6, [pc], #-1389	; eb0 <shift+0xeb0>
     eac:	69666572 	stmdbvs	r6!, {r1, r4, r5, r6, r8, sl, sp, lr}^
     eb0:	65732f6c 	ldrbvs	r2, [r3, #-3948]!	; 0xfffff094
     eb4:	6f732f6d 	svcvs	0x00732f6d
     eb8:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
     ebc:	74732f73 	ldrbtvc	r2, [r3], #-3955	; 0xfffff08d
     ec0:	62696c64 	rsbvs	r6, r9, #100, 24	; 0x6400
     ec4:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
     ec8:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
     ecc:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
     ed0:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
     ed4:	57534e00 	ldrbpl	r4, [r3, -r0, lsl #28]
     ed8:	65525f49 	ldrbvs	r5, [r2, #-3913]	; 0xfffff0b7
     edc:	746c7573 	strbtvc	r7, [ip], #-1395	; 0xfffffa8d
     ee0:	646f435f 	strbtvs	r4, [pc], #-863	; ee8 <shift+0xee8>
     ee4:	72770065 	rsbsvc	r0, r7, #101	; 0x65
     ee8:	006d756e 	rsbeq	r7, sp, lr, ror #10
     eec:	77345a5f 			; <UNDEFINED> instruction: 0x77345a5f
     ef0:	6a746961 	bvs	1d1b47c <__bss_end+0x1d11854>
     ef4:	5f006a6a 	svcpl	0x00006a6a
     ef8:	6f69355a 	svcvs	0x0069355a
     efc:	6a6c7463 	bvs	1b1e090 <__bss_end+0x1b14468>
     f00:	494e3631 	stmdbmi	lr, {r0, r4, r5, r9, sl, ip, sp}^
     f04:	6c74434f 	ldclvs	3, cr4, [r4], #-316	; 0xfffffec4
     f08:	65704f5f 	ldrbvs	r4, [r0, #-3935]!	; 0xfffff0a1
     f0c:	69746172 	ldmdbvs	r4!, {r1, r4, r5, r6, r8, sp, lr}^
     f10:	76506e6f 	ldrbvc	r6, [r0], -pc, ror #28
     f14:	636f6900 	cmnvs	pc, #0, 18
     f18:	72006c74 	andvc	r6, r0, #116, 24	; 0x7400
     f1c:	6e637465 	cdpvs	4, 6, cr7, cr3, cr5, {3}
     f20:	6f6e0074 	svcvs	0x006e0074
     f24:	79666974 	stmdbvc	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
     f28:	72657400 	rsbvc	r7, r5, #0, 8
     f2c:	616e696d 	cmnvs	lr, sp, ror #18
     f30:	6d006574 	cfstr32vs	mvfx6, [r0, #-464]	; 0xfffffe30
     f34:	0065646f 	rsbeq	r6, r5, pc, ror #8
     f38:	66667562 	strbtvs	r7, [r6], -r2, ror #10
     f3c:	5f007265 	svcpl	0x00007265
     f40:	6572345a 	ldrbvs	r3, [r2, #-1114]!	; 0xfffffba6
     f44:	506a6461 	rsbpl	r6, sl, r1, ror #8
     f48:	4e006a63 	vmlsmi.f32	s12, s0, s7
     f4c:	74434f49 	strbvc	r4, [r3], #-3913	; 0xfffff0b7
     f50:	704f5f6c 	subvc	r5, pc, ip, ror #30
     f54:	74617265 	strbtvc	r7, [r1], #-613	; 0xfffffd9b
     f58:	006e6f69 	rsbeq	r6, lr, r9, ror #30
     f5c:	63746572 	cmnvs	r4, #478150656	; 0x1c800000
     f60:	0065646f 	rsbeq	r6, r5, pc, ror #8
     f64:	5f746567 	svcpl	0x00746567
     f68:	69746361 	ldmdbvs	r4!, {r0, r5, r6, r8, r9, sp, lr}^
     f6c:	705f6576 	subsvc	r6, pc, r6, ror r5	; <UNPREDICTABLE>
     f70:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     f74:	635f7373 	cmpvs	pc, #-872415231	; 0xcc000001
     f78:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
     f7c:	6c696600 	stclvs	6, cr6, [r9], #-0
     f80:	6d616e65 	stclvs	14, cr6, [r1, #-404]!	; 0xfffffe6c
     f84:	65720065 	ldrbvs	r0, [r2, #-101]!	; 0xffffff9b
     f88:	67006461 	strvs	r6, [r0, -r1, ror #8]
     f8c:	69707465 	ldmdbvs	r0!, {r0, r2, r5, r6, sl, ip, sp, lr}^
     f90:	5a5f0064 	bpl	17c1128 <__bss_end+0x17b7500>
     f94:	65706f34 	ldrbvs	r6, [r0, #-3892]!	; 0xfffff0cc
     f98:	634b506e 	movtvs	r5, #45166	; 0xb06e
     f9c:	464e3531 			; <UNDEFINED> instruction: 0x464e3531
     fa0:	5f656c69 	svcpl	0x00656c69
     fa4:	6e65704f 	cdpvs	0, 6, cr7, cr5, cr15, {2}
     fa8:	646f4d5f 	strbtvs	r4, [pc], #-3423	; fb0 <shift+0xfb0>
     fac:	5a5f0065 	bpl	17c1148 <__bss_end+0x17b7520>
     fb0:	72747337 	rsbsvc	r7, r4, #-603979776	; 0xdc000000
     fb4:	7970636e 	ldmdbvc	r0!, {r1, r2, r3, r5, r6, r8, r9, sp, lr}^
     fb8:	4b506350 	blmi	1419d00 <__bss_end+0x14100d8>
     fbc:	5f006963 	svcpl	0x00006963
     fc0:	656d365a 	strbvs	r3, [sp, #-1626]!	; 0xfffff9a6
     fc4:	7970636d 	ldmdbvc	r0!, {r0, r2, r3, r5, r6, r8, r9, sp, lr}^
     fc8:	50764b50 	rsbspl	r4, r6, r0, asr fp
     fcc:	5f006976 	svcpl	0x00006976
     fd0:	6734315a 			; <UNDEFINED> instruction: 0x6734315a
     fd4:	695f7465 	ldmdbvs	pc, {r0, r2, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
     fd8:	7475706e 	ldrbtvc	r7, [r5], #-110	; 0xffffff92
     fdc:	7079745f 	rsbsvc	r7, r9, pc, asr r4
     fe0:	634b5065 	movtvs	r5, #45157	; 0xb065
     fe4:	345a5f00 	ldrbcc	r5, [sl], #-3840	; 0xfffff100
     fe8:	75745f6e 	ldrbvc	r5, [r4, #-3950]!	; 0xfffff092
     fec:	61006969 	tstvs	r0, r9, ror #18
     ff0:	00666f74 	rsbeq	r6, r6, r4, ror pc
     ff4:	5f746567 	svcpl	0x00746567
     ff8:	75706e69 	ldrbvc	r6, [r0, #-3689]!	; 0xfffff197
     ffc:	79745f74 	ldmdbvc	r4!, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    1000:	61006570 	tstvs	r0, r0, ror r5
    1004:	00696f74 	rsbeq	r6, r9, r4, ror pc
    1008:	61345a5f 	teqvs	r4, pc, asr sl
    100c:	50666f74 	rsbpl	r6, r6, r4, ror pc
    1010:	6400634b 	strvs	r6, [r0], #-843	; 0xfffffcb5
    1014:	00747365 	rsbseq	r7, r4, r5, ror #6
    1018:	75706e69 	ldrbvc	r6, [r0, #-3689]!	; 0xfffff197
    101c:	69730074 	ldmdbvs	r3!, {r2, r4, r5, r6}^
    1020:	73006e67 	movwvc	r6, #3687	; 0xe67
    1024:	61637274 	smcvs	14116	; 0x3724
    1028:	5a5f0074 	bpl	17c1200 <__bss_end+0x17b75d8>
    102c:	657a6235 	ldrbvs	r6, [sl, #-565]!	; 0xfffffdcb
    1030:	76506f72 	usub16vc	r6, r0, r2
    1034:	74730069 	ldrbtvc	r0, [r3], #-105	; 0xffffff97
    1038:	70636e72 	rsbvc	r6, r3, r2, ror lr
    103c:	5a5f0079 	bpl	17c1228 <__bss_end+0x17b7600>
    1040:	72747336 	rsbsvc	r7, r4, #-671088640	; 0xd8000000
    1044:	50746163 	rsbspl	r6, r4, r3, ror #2
    1048:	634b5063 	movtvs	r5, #45155	; 0xb063
    104c:	6f682f00 	svcvs	0x00682f00
    1050:	742f656d 	strtvc	r6, [pc], #-1389	; 1058 <shift+0x1058>
    1054:	69666572 	stmdbvs	r6!, {r1, r4, r5, r6, r8, sl, sp, lr}^
    1058:	65732f6c 	ldrbvs	r2, [r3, #-3948]!	; 0xfffff094
    105c:	6f732f6d 	svcvs	0x00732f6d
    1060:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
    1064:	74732f73 	ldrbtvc	r2, [r3], #-3955	; 0xfffff08d
    1068:	62696c64 	rsbvs	r6, r9, #100, 24	; 0x6400
    106c:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
    1070:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
    1074:	69727473 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
    1078:	632e676e 			; <UNDEFINED> instruction: 0x632e676e
    107c:	73007070 	movwvc	r7, #112	; 0x70
    1080:	636e7274 	cmnvs	lr, #116, 4	; 0x40000007
    1084:	77007461 	strvc	r7, [r0, -r1, ror #8]
    1088:	656b6c61 	strbvs	r6, [fp, #-3169]!	; 0xfffff39f
    108c:	61660072 	smcvs	24578	; 0x6002
    1090:	726f7463 	rsbvc	r7, pc, #1660944384	; 0x63000000
    1094:	6f746900 	svcvs	0x00746900
    1098:	6f700061 	svcvs	0x00700061
    109c:	69746973 	ldmdbvs	r4!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
    10a0:	6d006e6f 	stcvs	14, cr6, [r0, #-444]	; 0xfffffe44
    10a4:	73646d65 	cmnvc	r4, #6464	; 0x1940
    10a8:	68430074 	stmdavs	r3, {r2, r4, r5, r6}^
    10ac:	6f437261 	svcvs	0x00437261
    10b0:	7241766e 	subvc	r7, r1, #115343360	; 0x6e00000
    10b4:	74660072 	strbtvc	r0, [r6], #-114	; 0xffffff8e
    10b8:	6e00616f 	adfvssz	f6, f0, #10.0
    10bc:	65626d75 	strbvs	r6, [r2, #-3445]!	; 0xfffff28b
    10c0:	656d0072 	strbvs	r0, [sp, #-114]!	; 0xffffff8e
    10c4:	6372736d 	cmnvs	r2, #-1275068415	; 0xb4000001
    10c8:	6d756e00 	ldclvs	14, cr6, [r5, #-0]
    10cc:	32726562 	rsbscc	r6, r2, #411041792	; 0x18800000
    10d0:	74666100 	strbtvc	r6, [r6], #-256	; 0xffffff00
    10d4:	65447265 	strbvs	r7, [r4, #-613]	; 0xfffffd9b
    10d8:	696f5063 	stmdbvs	pc!, {r0, r1, r5, r6, ip, lr}^	; <UNPREDICTABLE>
    10dc:	6200746e 	andvs	r7, r0, #1845493760	; 0x6e000000
    10e0:	6f72657a 	svcvs	0x0072657a
    10e4:	6d656d00 	stclvs	13, cr6, [r5, #-0]
    10e8:	00797063 	rsbseq	r7, r9, r3, rrx
    10ec:	6e727473 	mrcvs	4, 3, r7, cr2, cr3, {3}
    10f0:	00706d63 	rsbseq	r6, r0, r3, ror #26
    10f4:	69617274 	stmdbvs	r1!, {r2, r4, r5, r6, r9, ip, sp, lr}^
    10f8:	676e696c 	strbvs	r6, [lr, -ip, ror #18]!
    10fc:	746f645f 	strbtvc	r6, [pc], #-1119	; 1104 <shift+0x1104>
    1100:	74756f00 	ldrbtvc	r6, [r5], #-3840	; 0xfffff100
    1104:	00747570 	rsbseq	r7, r4, r0, ror r5
    1108:	676e656c 	strbvs	r6, [lr, -ip, ror #10]!
    110c:	00326874 	eorseq	r6, r2, r4, ror r8
    1110:	75745f6e 	ldrbvc	r5, [r4, #-3950]!	; 0xfffff092
    1114:	365a5f00 	ldrbcc	r5, [sl], -r0, lsl #30
    1118:	6c727473 	cfldrdvs	mvd7, [r2], #-460	; 0xfffffe34
    111c:	4b506e65 	blmi	141cab8 <__bss_end+0x1412e90>
    1120:	5a5f0063 	bpl	17c12b4 <__bss_end+0x17b768c>
    1124:	72747337 	rsbsvc	r7, r4, #-603979776	; 0xdc000000
    1128:	706d636e 	rsbvc	r6, sp, lr, ror #6
    112c:	53634b50 	cmnpl	r3, #80, 22	; 0x14000
    1130:	00695f30 	rsbeq	r5, r9, r0, lsr pc
    1134:	61345a5f 	teqvs	r4, pc, asr sl
    1138:	50696f74 	rsbpl	r6, r9, r4, ror pc
    113c:	5f00634b 	svcpl	0x0000634b
    1140:	7469345a 	strbtvc	r3, [r9], #-1114	; 0xfffffba6
    1144:	5069616f 	rsbpl	r6, r9, pc, ror #2
    1148:	5f006a63 	svcpl	0x00006a63
    114c:	7466345a 	strbtvc	r3, [r6], #-1114	; 0xfffffba6
    1150:	5066616f 	rsbpl	r6, r6, pc, ror #2
    1154:	656d0063 	strbvs	r0, [sp, #-99]!	; 0xffffff9d
    1158:	79726f6d 	ldmdbvc	r2!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
    115c:	6e656c00 	cdpvs	12, 6, cr6, cr5, cr0, {0}
    1160:	00687467 	rsbeq	r7, r8, r7, ror #8
    1164:	6c727473 	cfldrdvs	mvd7, [r2], #-460	; 0xfffffe34
    1168:	5f006e65 	svcpl	0x00006e65
    116c:	7473375a 	ldrbtvc	r3, [r3], #-1882	; 0xfffff8a6
    1170:	61636e72 	smcvs	14050	; 0x36e2
    1174:	50635074 	rsbpl	r5, r3, r4, ror r0
    1178:	0069634b 	rsbeq	r6, r9, fp, asr #6
    117c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1180:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1184:	2f2e2e2f 	svccs	0x002e2e2f
    1188:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    118c:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
    1190:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    1194:	6e6f632f 	cdpvs	3, 6, cr6, cr15, cr15, {1}
    1198:	2f676966 	svccs	0x00676966
    119c:	2f6d7261 	svccs	0x006d7261
    11a0:	3162696c 	cmncc	r2, ip, ror #18
    11a4:	636e7566 	cmnvs	lr, #427819008	; 0x19800000
    11a8:	00532e73 	subseq	r2, r3, r3, ror lr
    11ac:	6975622f 	ldmdbvs	r5!, {r0, r1, r2, r3, r5, r9, sp, lr}^
    11b0:	672f646c 	strvs	r6, [pc, -ip, ror #8]!
    11b4:	612d6363 			; <UNDEFINED> instruction: 0x612d6363
    11b8:	6e2d6d72 	mcrvs	13, 1, r6, cr13, cr2, {3}
    11bc:	2d656e6f 	stclcs	14, cr6, [r5, #-444]!	; 0xfffffe44
    11c0:	69626165 	stmdbvs	r2!, {r0, r2, r5, r6, r8, sp, lr}^
    11c4:	6659682d 	ldrbvs	r6, [r9], -sp, lsr #16
    11c8:	2f344b67 	svccs	0x00344b67
    11cc:	2d636367 	stclcs	3, cr6, [r3, #-412]!	; 0xfffffe64
    11d0:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
    11d4:	656e6f6e 	strbvs	r6, [lr, #-3950]!	; 0xfffff092
    11d8:	6261652d 	rsbvs	r6, r1, #188743680	; 0xb400000
    11dc:	30312d69 	eorscc	r2, r1, r9, ror #26
    11e0:	322d332e 	eorcc	r3, sp, #-1207959552	; 0xb8000000
    11e4:	2e313230 	mrccs	2, 1, r3, cr1, cr0, {1}
    11e8:	622f3730 	eorvs	r3, pc, #48, 14	; 0xc00000
    11ec:	646c6975 	strbtvs	r6, [ip], #-2421	; 0xfffff68b
    11f0:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
    11f4:	6e6f6e2d 	cdpvs	14, 6, cr6, cr15, cr13, {1}
    11f8:	61652d65 	cmnvs	r5, r5, ror #26
    11fc:	612f6962 			; <UNDEFINED> instruction: 0x612f6962
    1200:	762f6d72 			; <UNDEFINED> instruction: 0x762f6d72
    1204:	2f657435 	svccs	0x00657435
    1208:	64726168 	ldrbtvs	r6, [r2], #-360	; 0xfffffe98
    120c:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
    1210:	00636367 	rsbeq	r6, r3, r7, ror #6
    1214:	20554e47 	subscs	r4, r5, r7, asr #28
    1218:	32205341 	eorcc	r5, r0, #67108865	; 0x4000001
    121c:	0037332e 	eorseq	r3, r7, lr, lsr #6
    1220:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1224:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1228:	2f2e2e2f 	svccs	0x002e2e2f
    122c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1230:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
    1234:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    1238:	6e6f632f 	cdpvs	3, 6, cr6, cr15, cr15, {1}
    123c:	2f676966 	svccs	0x00676966
    1240:	2f6d7261 	svccs	0x006d7261
    1244:	65656569 	strbvs	r6, [r5, #-1385]!	; 0xfffffa97
    1248:	2d343537 	cfldr32cs	mvfx3, [r4, #-220]!	; 0xffffff24
    124c:	532e6673 			; <UNDEFINED> instruction: 0x532e6673
    1250:	2f2e2e00 	svccs	0x002e2e00
    1254:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1258:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    125c:	2f2e2e2f 	svccs	0x002e2e2f
    1260:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; 11b0 <shift+0x11b0>
    1264:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    1268:	6f632f63 	svcvs	0x00632f63
    126c:	6769666e 	strbvs	r6, [r9, -lr, ror #12]!
    1270:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
    1274:	6170622f 	cmnvs	r0, pc, lsr #4
    1278:	532e6962 			; <UNDEFINED> instruction: 0x532e6962
    127c:	61736900 	cmnvs	r3, r0, lsl #18
    1280:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1284:	6572705f 	ldrbvs	r7, [r2, #-95]!	; 0xffffffa1
    1288:	73657264 	cmnvc	r5, #100, 4	; 0x40000006
    128c:	61736900 	cmnvs	r3, r0, lsl #18
    1290:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1294:	7066765f 	rsbvc	r7, r6, pc, asr r6
    1298:	7361625f 	cmnvc	r1, #-268435451	; 0xf0000005
    129c:	6f630065 	svcvs	0x00630065
    12a0:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
    12a4:	6c662078 	stclvs	0, cr2, [r6], #-480	; 0xfffffe20
    12a8:	0074616f 	rsbseq	r6, r4, pc, ror #2
    12ac:	5f617369 	svcpl	0x00617369
    12b0:	69626f6e 	stmdbvs	r2!, {r1, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
    12b4:	73690074 	cmnvc	r9, #116	; 0x74
    12b8:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    12bc:	766d5f74 	uqsub16vc	r5, sp, r4
    12c0:	6c665f65 	stclvs	15, cr5, [r6], #-404	; 0xfffffe6c
    12c4:	0074616f 	rsbseq	r6, r4, pc, ror #2
    12c8:	5f617369 	svcpl	0x00617369
    12cc:	5f746962 	svcpl	0x00746962
    12d0:	36317066 	ldrtcc	r7, [r1], -r6, rrx
    12d4:	61736900 	cmnvs	r3, r0, lsl #18
    12d8:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    12dc:	6365735f 	cmnvs	r5, #2080374785	; 0x7c000001
    12e0:	61736900 	cmnvs	r3, r0, lsl #18
    12e4:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    12e8:	6964615f 	stmdbvs	r4!, {r0, r1, r2, r3, r4, r6, r8, sp, lr}^
    12ec:	73690076 	cmnvc	r9, #118	; 0x76
    12f0:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    12f4:	75715f74 	ldrbvc	r5, [r1, #-3956]!	; 0xfffff08c
    12f8:	5f6b7269 	svcpl	0x006b7269
    12fc:	765f6f6e 	ldrbvc	r6, [pc], -lr, ror #30
    1300:	74616c6f 	strbtvc	r6, [r1], #-3183	; 0xfffff391
    1304:	5f656c69 	svcpl	0x00656c69
    1308:	69006563 	stmdbvs	r0, {r0, r1, r5, r6, r8, sl, sp, lr}
    130c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1310:	6d5f7469 	cfldrdvs	mvd7, [pc, #-420]	; 1174 <shift+0x1174>
    1314:	73690070 	cmnvc	r9, #112	; 0x70
    1318:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    131c:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    1320:	7435766d 	ldrtvc	r7, [r5], #-1645	; 0xfffff993
    1324:	61736900 	cmnvs	r3, r0, lsl #18
    1328:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    132c:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1330:	65743576 	ldrbvs	r3, [r4, #-1398]!	; 0xfffffa8a
    1334:	61736900 	cmnvs	r3, r0, lsl #18
    1338:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    133c:	6f656e5f 	svcvs	0x00656e5f
    1340:	7369006e 	cmnvc	r9, #110	; 0x6e
    1344:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1348:	66625f74 	uqsub16vs	r5, r2, r4
    134c:	46003631 			; <UNDEFINED> instruction: 0x46003631
    1350:	52435350 	subpl	r5, r3, #80, 6	; 0x40000001
    1354:	554e455f 	strbpl	r4, [lr, #-1375]	; 0xfffffaa1
    1358:	5046004d 	subpl	r0, r6, sp, asr #32
    135c:	5f524353 	svcpl	0x00524353
    1360:	76637a6e 	strbtvc	r7, [r3], -lr, ror #20
    1364:	455f6371 	ldrbmi	r6, [pc, #-881]	; ffb <shift+0xffb>
    1368:	004d554e 	subeq	r5, sp, lr, asr #10
    136c:	5f525056 	svcpl	0x00525056
    1370:	4d554e45 	ldclmi	14, cr4, [r5, #-276]	; 0xfffffeec
    1374:	69626600 	stmdbvs	r2!, {r9, sl, sp, lr}^
    1378:	6d695f74 	stclvs	15, cr5, [r9, #-464]!	; 0xfffffe30
    137c:	63696c70 	cmnvs	r9, #112, 24	; 0x7000
    1380:	6f697461 	svcvs	0x00697461
    1384:	3050006e 	subscc	r0, r0, lr, rrx
    1388:	554e455f 	strbpl	r4, [lr, #-1375]	; 0xfffffaa1
    138c:	7369004d 	cmnvc	r9, #77	; 0x4d
    1390:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1394:	72635f74 	rsbvc	r5, r3, #116, 30	; 0x1d0
    1398:	6f747079 	svcvs	0x00747079
    139c:	554e4700 	strbpl	r4, [lr, #-1792]	; 0xfffff900
    13a0:	37314320 	ldrcc	r4, [r1, -r0, lsr #6]!
    13a4:	2e303120 	rsfcssp	f3, f0, f0
    13a8:	20312e33 	eorscs	r2, r1, r3, lsr lr
    13ac:	31323032 	teqcc	r2, r2, lsr r0
    13b0:	31323630 	teqcc	r2, r0, lsr r6
    13b4:	65722820 	ldrbvs	r2, [r2, #-2080]!	; 0xfffff7e0
    13b8:	7361656c 	cmnvc	r1, #108, 10	; 0x1b000000
    13bc:	2d202965 			; <UNDEFINED> instruction: 0x2d202965
    13c0:	6d72616d 	ldfvse	f6, [r2, #-436]!	; 0xfffffe4c
    13c4:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
    13c8:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
    13cc:	6962612d 	stmdbvs	r2!, {r0, r2, r3, r5, r8, sp, lr}^
    13d0:	7261683d 	rsbvc	r6, r1, #3997696	; 0x3d0000
    13d4:	6d2d2064 	stcvs	0, cr2, [sp, #-400]!	; 0xfffffe70
    13d8:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    13dc:	6d72613d 	ldfvse	f6, [r2, #-244]!	; 0xffffff0c
    13e0:	65743576 	ldrbvs	r3, [r4, #-1398]!	; 0xfffffa8a
    13e4:	2070662b 	rsbscs	r6, r0, fp, lsr #12
    13e8:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
    13ec:	672d2067 	strvs	r2, [sp, -r7, rrx]!
    13f0:	324f2d20 	subcc	r2, pc, #32, 26	; 0x800
    13f4:	324f2d20 	subcc	r2, pc, #32, 26	; 0x800
    13f8:	324f2d20 	subcc	r2, pc, #32, 26	; 0x800
    13fc:	62662d20 	rsbvs	r2, r6, #32, 26	; 0x800
    1400:	646c6975 	strbtvs	r6, [ip], #-2421	; 0xfffff68b
    1404:	2d676e69 	stclcs	14, cr6, [r7, #-420]!	; 0xfffffe5c
    1408:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    140c:	2d206363 	stccs	3, cr6, [r0, #-396]!	; 0xfffffe74
    1410:	2d6f6e66 	stclcs	14, cr6, [pc, #-408]!	; 1280 <shift+0x1280>
    1414:	63617473 	cmnvs	r1, #1929379840	; 0x73000000
    1418:	72702d6b 	rsbsvc	r2, r0, #6848	; 0x1ac0
    141c:	6365746f 	cmnvs	r5, #1862270976	; 0x6f000000
    1420:	20726f74 	rsbscs	r6, r2, r4, ror pc
    1424:	6f6e662d 	svcvs	0x006e662d
    1428:	6c6e692d 			; <UNDEFINED> instruction: 0x6c6e692d
    142c:	20656e69 	rsbcs	r6, r5, r9, ror #28
    1430:	6976662d 	ldmdbvs	r6!, {r0, r2, r3, r5, r9, sl, sp, lr}^
    1434:	69626973 	stmdbvs	r2!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
    1438:	7974696c 	ldmdbvc	r4!, {r2, r3, r5, r6, r8, fp, sp, lr}^
    143c:	6469683d 	strbtvs	r6, [r9], #-2109	; 0xfffff7c3
    1440:	006e6564 	rsbeq	r6, lr, r4, ror #10
    1444:	5f617369 	svcpl	0x00617369
    1448:	5f746962 	svcpl	0x00746962
    144c:	76696474 			; <UNDEFINED> instruction: 0x76696474
    1450:	6e6f6300 	cdpvs	3, 6, cr6, cr15, cr0, {0}
    1454:	73690073 	cmnvc	r9, #115	; 0x73
    1458:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    145c:	77695f74 			; <UNDEFINED> instruction: 0x77695f74
    1460:	74786d6d 	ldrbtvc	r6, [r8], #-3437	; 0xfffff293
    1464:	43504600 	cmpmi	r0, #0, 12
    1468:	5f535458 	svcpl	0x00535458
    146c:	4d554e45 	ldclmi	14, cr4, [r5, #-276]	; 0xfffffeec
    1470:	61736900 	cmnvs	r3, r0, lsl #18
    1474:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1478:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    147c:	69003676 	stmdbvs	r0, {r1, r2, r4, r5, r6, r9, sl, ip, sp}
    1480:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1484:	6d5f7469 	cfldrdvs	mvd7, [pc, #-420]	; 12e8 <shift+0x12e8>
    1488:	69006576 	stmdbvs	r0, {r1, r2, r4, r5, r6, r8, sl, sp, lr}
    148c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1490:	695f7469 	ldmdbvs	pc, {r0, r3, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
    1494:	786d6d77 	stmdavc	sp!, {r0, r1, r2, r4, r5, r6, r8, sl, fp, sp, lr}^
    1498:	69003274 	stmdbvs	r0, {r2, r4, r5, r6, r9, ip, sp}
    149c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    14a0:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
    14a4:	70636564 	rsbvc	r6, r3, r4, ror #10
    14a8:	73690030 	cmnvc	r9, #48	; 0x30
    14ac:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    14b0:	64635f74 	strbtvs	r5, [r3], #-3956	; 0xfffff08c
    14b4:	31706365 	cmncc	r0, r5, ror #6
    14b8:	61736900 	cmnvs	r3, r0, lsl #18
    14bc:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    14c0:	6564635f 	strbvs	r6, [r4, #-863]!	; 0xfffffca1
    14c4:	00327063 	eorseq	r7, r2, r3, rrx
    14c8:	5f617369 	svcpl	0x00617369
    14cc:	5f746962 	svcpl	0x00746962
    14d0:	63656463 	cmnvs	r5, #1660944384	; 0x63000000
    14d4:	69003370 	stmdbvs	r0, {r4, r5, r6, r8, r9, ip, sp}
    14d8:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    14dc:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
    14e0:	70636564 	rsbvc	r6, r3, r4, ror #10
    14e4:	73690034 	cmnvc	r9, #52	; 0x34
    14e8:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    14ec:	70665f74 	rsbvc	r5, r6, r4, ror pc
    14f0:	6c62645f 	cfstrdvs	mvd6, [r2], #-380	; 0xfffffe84
    14f4:	61736900 	cmnvs	r3, r0, lsl #18
    14f8:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    14fc:	6564635f 	strbvs	r6, [r4, #-863]!	; 0xfffffca1
    1500:	00367063 	eorseq	r7, r6, r3, rrx
    1504:	5f617369 	svcpl	0x00617369
    1508:	5f746962 	svcpl	0x00746962
    150c:	63656463 	cmnvs	r5, #1660944384	; 0x63000000
    1510:	69003770 	stmdbvs	r0, {r4, r5, r6, r8, r9, sl, ip, sp}
    1514:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1518:	615f7469 	cmpvs	pc, r9, ror #8
    151c:	36766d72 			; <UNDEFINED> instruction: 0x36766d72
    1520:	7369006b 	cmnvc	r9, #107	; 0x6b
    1524:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1528:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    152c:	5f38766d 	svcpl	0x0038766d
    1530:	6d5f6d31 	ldclvs	13, cr6, [pc, #-196]	; 1474 <shift+0x1474>
    1534:	006e6961 	rsbeq	r6, lr, r1, ror #18
    1538:	65746e61 	ldrbvs	r6, [r4, #-3681]!	; 0xfffff19f
    153c:	61736900 	cmnvs	r3, r0, lsl #18
    1540:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1544:	736d635f 	cmnvc	sp, #2080374785	; 0x7c000001
    1548:	6f6c0065 	svcvs	0x006c0065
    154c:	6420676e 	strtvs	r6, [r0], #-1902	; 0xfffff892
    1550:	6c62756f 	cfstr64vs	mvdx7, [r2], #-444	; 0xfffffe44
    1554:	2e2e0065 	cdpcs	0, 2, cr0, cr14, cr5, {3}
    1558:	2f2e2e2f 	svccs	0x002e2e2f
    155c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1560:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1564:	2f2e2e2f 	svccs	0x002e2e2f
    1568:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    156c:	6c2f6363 	stcvs	3, cr6, [pc], #-396	; 13e8 <shift+0x13e8>
    1570:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    1574:	632e3263 			; <UNDEFINED> instruction: 0x632e3263
    1578:	61736900 	cmnvs	r3, r0, lsl #18
    157c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1580:	7670665f 			; <UNDEFINED> instruction: 0x7670665f
    1584:	73690035 	cmnvc	r9, #53	; 0x35
    1588:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    158c:	73785f74 	cmnvc	r8, #116, 30	; 0x1d0
    1590:	656c6163 	strbvs	r6, [ip, #-355]!	; 0xfffffe9d
    1594:	6e6f6c00 	cdpvs	12, 6, cr6, cr15, cr0, {0}
    1598:	6f6c2067 	svcvs	0x006c2067
    159c:	7520676e 	strvc	r6, [r0, #-1902]!	; 0xfffff892
    15a0:	6769736e 	strbvs	r7, [r9, -lr, ror #6]!
    15a4:	2064656e 	rsbcs	r6, r4, lr, ror #10
    15a8:	00746e69 	rsbseq	r6, r4, r9, ror #28
    15ac:	5f617369 	svcpl	0x00617369
    15b0:	5f746962 	svcpl	0x00746962
    15b4:	72697571 	rsbvc	r7, r9, #473956352	; 0x1c400000
    15b8:	6d635f6b 	stclvs	15, cr5, [r3, #-428]!	; 0xfffffe54
    15bc:	646c5f33 	strbtvs	r5, [ip], #-3891	; 0xfffff0cd
    15c0:	69006472 	stmdbvs	r0, {r1, r4, r5, r6, sl, sp, lr}
    15c4:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    15c8:	695f7469 	ldmdbvs	pc, {r0, r3, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
    15cc:	006d6d38 	rsbeq	r6, sp, r8, lsr sp
    15d0:	5f617369 	svcpl	0x00617369
    15d4:	5f746962 	svcpl	0x00746962
    15d8:	645f7066 	ldrbvs	r7, [pc], #-102	; 15e0 <shift+0x15e0>
    15dc:	69003233 	stmdbvs	r0, {r0, r1, r4, r5, r9, ip, sp}
    15e0:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    15e4:	615f7469 	cmpvs	pc, r9, ror #8
    15e8:	37766d72 			; <UNDEFINED> instruction: 0x37766d72
    15ec:	69006d65 	stmdbvs	r0, {r0, r2, r5, r6, r8, sl, fp, sp, lr}
    15f0:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    15f4:	6c5f7469 	cfldrdvs	mvd7, [pc], {105}	; 0x69
    15f8:	00656170 	rsbeq	r6, r5, r0, ror r1
    15fc:	5f6c6c61 	svcpl	0x006c6c61
    1600:	6c706d69 	ldclvs	13, cr6, [r0], #-420	; 0xfffffe5c
    1604:	5f646569 	svcpl	0x00646569
    1608:	74696266 	strbtvc	r6, [r9], #-614	; 0xfffffd9a
    160c:	73690073 	cmnvc	r9, #115	; 0x73
    1610:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1614:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    1618:	5f38766d 	svcpl	0x0038766d
    161c:	73690031 	cmnvc	r9, #49	; 0x31
    1620:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1624:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    1628:	5f38766d 	svcpl	0x0038766d
    162c:	73690032 	cmnvc	r9, #50	; 0x32
    1630:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1634:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    1638:	5f38766d 	svcpl	0x0038766d
    163c:	73690033 	cmnvc	r9, #51	; 0x33
    1640:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1644:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    1648:	5f38766d 	svcpl	0x0038766d
    164c:	73690034 	cmnvc	r9, #52	; 0x34
    1650:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1654:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    1658:	5f38766d 	svcpl	0x0038766d
    165c:	73690035 	cmnvc	r9, #53	; 0x35
    1660:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1664:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    1668:	5f38766d 	svcpl	0x0038766d
    166c:	73690036 	cmnvc	r9, #54	; 0x36
    1670:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1674:	62735f74 	rsbsvs	r5, r3, #116, 30	; 0x1d0
    1678:	61736900 	cmnvs	r3, r0, lsl #18
    167c:	6d756e5f 	ldclvs	14, cr6, [r5, #-380]!	; 0xfffffe84
    1680:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1684:	73690073 	cmnvc	r9, #115	; 0x73
    1688:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    168c:	6d735f74 	ldclvs	15, cr5, [r3, #-464]!	; 0xfffffe30
    1690:	6d6c6c61 	stclvs	12, cr6, [ip, #-388]!	; 0xfffffe7c
    1694:	66006c75 			; <UNDEFINED> instruction: 0x66006c75
    1698:	5f636e75 	svcpl	0x00636e75
    169c:	00727470 	rsbseq	r7, r2, r0, ror r4
    16a0:	706d6f63 	rsbvc	r6, sp, r3, ror #30
    16a4:	2078656c 	rsbscs	r6, r8, ip, ror #10
    16a8:	62756f64 	rsbsvs	r6, r5, #100, 30	; 0x190
    16ac:	4e00656c 	cfsh32mi	mvfx6, mvfx0, #60
    16b0:	50465f42 	subpl	r5, r6, r2, asr #30
    16b4:	5359535f 	cmppl	r9, #2080374785	; 0x7c000001
    16b8:	53474552 	movtpl	r4, #30034	; 0x7552
    16bc:	61736900 	cmnvs	r3, r0, lsl #18
    16c0:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    16c4:	6564635f 	strbvs	r6, [r4, #-863]!	; 0xfffffca1
    16c8:	00357063 	eorseq	r7, r5, r3, rrx
    16cc:	5f617369 	svcpl	0x00617369
    16d0:	5f746962 	svcpl	0x00746962
    16d4:	76706676 			; <UNDEFINED> instruction: 0x76706676
    16d8:	73690032 	cmnvc	r9, #50	; 0x32
    16dc:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    16e0:	66765f74 	uhsub16vs	r5, r6, r4
    16e4:	00337670 	eorseq	r7, r3, r0, ror r6
    16e8:	5f617369 	svcpl	0x00617369
    16ec:	5f746962 	svcpl	0x00746962
    16f0:	76706676 			; <UNDEFINED> instruction: 0x76706676
    16f4:	50460034 	subpl	r0, r6, r4, lsr r0
    16f8:	4e545843 	cdpmi	8, 5, cr5, cr4, cr3, {2}
    16fc:	4e455f53 	mcrmi	15, 2, r5, cr5, cr3, {2}
    1700:	69004d55 	stmdbvs	r0, {r0, r2, r4, r6, r8, sl, fp, lr}
    1704:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1708:	745f7469 	ldrbvc	r7, [pc], #-1129	; 1710 <shift+0x1710>
    170c:	626d7568 	rsbvs	r7, sp, #104, 10	; 0x1a000000
    1710:	61736900 	cmnvs	r3, r0, lsl #18
    1714:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1718:	3170665f 	cmncc	r0, pc, asr r6
    171c:	6e6f6336 	mcrvs	3, 3, r6, cr15, cr6, {1}
    1720:	73690076 	cmnvc	r9, #118	; 0x76
    1724:	65665f61 	strbvs	r5, [r6, #-3937]!	; 0xfffff09f
    1728:	72757461 	rsbsvc	r7, r5, #1627389952	; 0x61000000
    172c:	73690065 	cmnvc	r9, #101	; 0x65
    1730:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1734:	6f6e5f74 	svcvs	0x006e5f74
    1738:	69006d74 	stmdbvs	r0, {r2, r4, r5, r6, r8, sl, fp, sp, lr}
    173c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1740:	715f7469 	cmpvc	pc, r9, ror #8
    1744:	6b726975 	blvs	1c9bd20 <__bss_end+0x1c920f8>
    1748:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    174c:	7a6b3676 	bvc	1acf12c <__bss_end+0x1ac5504>
    1750:	61736900 	cmnvs	r3, r0, lsl #18
    1754:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1758:	6372635f 	cmnvs	r2, #2080374785	; 0x7c000001
    175c:	69003233 	stmdbvs	r0, {r0, r1, r4, r5, r9, ip, sp}
    1760:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1764:	715f7469 	cmpvc	pc, r9, ror #8
    1768:	6b726975 	blvs	1c9bd44 <__bss_end+0x1c9211c>
    176c:	5f6f6e5f 	svcpl	0x006f6e5f
    1770:	636d7361 	cmnvs	sp, #-2080374783	; 0x84000001
    1774:	69007570 	stmdbvs	r0, {r4, r5, r6, r8, sl, ip, sp, lr}
    1778:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    177c:	615f7469 	cmpvs	pc, r9, ror #8
    1780:	34766d72 	ldrbtcc	r6, [r6], #-3442	; 0xfffff28e
    1784:	61736900 	cmnvs	r3, r0, lsl #18
    1788:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    178c:	7568745f 	strbvc	r7, [r8, #-1119]!	; 0xfffffba1
    1790:	0032626d 	eorseq	r6, r2, sp, ror #4
    1794:	5f617369 	svcpl	0x00617369
    1798:	5f746962 	svcpl	0x00746962
    179c:	00386562 	eorseq	r6, r8, r2, ror #10
    17a0:	5f617369 	svcpl	0x00617369
    17a4:	5f746962 	svcpl	0x00746962
    17a8:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    17ac:	73690037 	cmnvc	r9, #55	; 0x37
    17b0:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    17b4:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    17b8:	0038766d 	eorseq	r7, r8, sp, ror #12
    17bc:	5f706676 	svcpl	0x00706676
    17c0:	72737973 	rsbsvc	r7, r3, #1884160	; 0x1cc000
    17c4:	5f736765 	svcpl	0x00736765
    17c8:	6f636e65 	svcvs	0x00636e65
    17cc:	676e6964 	strbvs	r6, [lr, -r4, ror #18]!
    17d0:	61736900 	cmnvs	r3, r0, lsl #18
    17d4:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    17d8:	3170665f 	cmncc	r0, pc, asr r6
    17dc:	6c6d6636 	stclvs	6, cr6, [sp], #-216	; 0xffffff28
    17e0:	61736900 	cmnvs	r3, r0, lsl #18
    17e4:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    17e8:	746f645f 	strbtvc	r6, [pc], #-1119	; 17f0 <shift+0x17f0>
    17ec:	646f7270 	strbtvs	r7, [pc], #-624	; 17f4 <shift+0x17f4>
    17f0:	665f5f00 	ldrbvs	r5, [pc], -r0, lsl #30
    17f4:	6e757869 	cdpvs	8, 7, cr7, cr5, cr9, {3}
    17f8:	64667373 	strbtvs	r7, [r6], #-883	; 0xfffffc8d
    17fc:	46530069 	ldrbmi	r0, [r3], -r9, rrx
    1800:	65707974 	ldrbvs	r7, [r0, #-2420]!	; 0xfffff68c
    1804:	615f5f00 	cmpvs	pc, r0, lsl #30
    1808:	69626165 	stmdbvs	r2!, {r0, r2, r5, r6, r8, sp, lr}^
    180c:	7532665f 	ldrvc	r6, [r2, #-1631]!	; 0xfffff9a1
    1810:	5f007a6c 	svcpl	0x00007a6c
    1814:	7869665f 	stmdavc	r9!, {r0, r1, r2, r3, r4, r6, r9, sl, sp, lr}^
    1818:	69646673 	stmdbvs	r4!, {r0, r1, r4, r5, r6, r9, sl, sp, lr}^
    181c:	74464400 	strbvc	r4, [r6], #-1024	; 0xfffffc00
    1820:	00657079 	rsbeq	r7, r5, r9, ror r0
    1824:	74495355 	strbvc	r5, [r9], #-853	; 0xfffffcab
    1828:	00657079 	rsbeq	r7, r5, r9, ror r0
    182c:	74494455 	strbvc	r4, [r9], #-1109	; 0xfffffbab
    1830:	00657079 	rsbeq	r7, r5, r9, ror r0
    1834:	20554e47 	subscs	r4, r5, r7, asr #28
    1838:	20373143 	eorscs	r3, r7, r3, asr #2
    183c:	332e3031 			; <UNDEFINED> instruction: 0x332e3031
    1840:	3220312e 	eorcc	r3, r0, #-2147483637	; 0x8000000b
    1844:	30313230 	eorscc	r3, r1, r0, lsr r2
    1848:	20313236 	eorscs	r3, r1, r6, lsr r2
    184c:	6c657228 	sfmvs	f7, 2, [r5], #-160	; 0xffffff60
    1850:	65736165 	ldrbvs	r6, [r3, #-357]!	; 0xfffffe9b
    1854:	6d2d2029 	stcvs	0, cr2, [sp, #-164]!	; 0xffffff5c
    1858:	206d7261 	rsbcs	r7, sp, r1, ror #4
    185c:	6c666d2d 	stclvs	13, cr6, [r6], #-180	; 0xffffff4c
    1860:	2d74616f 	ldfcse	f6, [r4, #-444]!	; 0xfffffe44
    1864:	3d696261 	sfmcc	f6, 2, [r9, #-388]!	; 0xfffffe7c
    1868:	64726168 	ldrbtvs	r6, [r2], #-360	; 0xfffffe98
    186c:	616d2d20 	cmnvs	sp, r0, lsr #26
    1870:	3d686372 	stclcc	3, cr6, [r8, #-456]!	; 0xfffffe38
    1874:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    1878:	2b657435 	blcs	195e954 <__bss_end+0x1954d2c>
    187c:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
    1880:	672d2067 	strvs	r2, [sp, -r7, rrx]!
    1884:	20672d20 	rsbcs	r2, r7, r0, lsr #26
    1888:	20324f2d 	eorscs	r4, r2, sp, lsr #30
    188c:	20324f2d 	eorscs	r4, r2, sp, lsr #30
    1890:	20324f2d 	eorscs	r4, r2, sp, lsr #30
    1894:	7562662d 	strbvc	r6, [r2, #-1581]!	; 0xfffff9d3
    1898:	69646c69 	stmdbvs	r4!, {r0, r3, r5, r6, sl, fp, sp, lr}^
    189c:	6c2d676e 	stcvs	7, cr6, [sp], #-440	; 0xfffffe48
    18a0:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    18a4:	662d2063 	strtvs	r2, [sp], -r3, rrx
    18a8:	732d6f6e 			; <UNDEFINED> instruction: 0x732d6f6e
    18ac:	6b636174 	blvs	18d9e84 <__bss_end+0x18d025c>
    18b0:	6f72702d 	svcvs	0x0072702d
    18b4:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
    18b8:	2d20726f 	sfmcs	f7, 4, [r0, #-444]!	; 0xfffffe44
    18bc:	2d6f6e66 	stclcs	14, cr6, [pc, #-408]!	; 172c <shift+0x172c>
    18c0:	696c6e69 	stmdbvs	ip!, {r0, r3, r5, r6, r9, sl, fp, sp, lr}^
    18c4:	2d20656e 	cfstr32cs	mvfx6, [r0, #-440]!	; 0xfffffe48
    18c8:	63786566 	cmnvs	r8, #427819008	; 0x19800000
    18cc:	69747065 	ldmdbvs	r4!, {r0, r2, r5, r6, ip, sp, lr}^
    18d0:	20736e6f 	rsbscs	r6, r3, pc, ror #28
    18d4:	6976662d 	ldmdbvs	r6!, {r0, r2, r3, r5, r9, sl, sp, lr}^
    18d8:	69626973 	stmdbvs	r2!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
    18dc:	7974696c 	ldmdbvc	r4!, {r2, r3, r5, r6, r8, fp, sp, lr}^
    18e0:	6469683d 	strbtvs	r6, [r9], #-2109	; 0xfffff7c3
    18e4:	006e6564 	rsbeq	r6, lr, r4, ror #10
    18e8:	64755f5f 	ldrbtvs	r5, [r5], #-3935	; 0xfffff0a1
    18ec:	6f6d7669 	svcvs	0x006d7669
    18f0:	34696464 	strbtcc	r6, [r9], #-1124	; 0xfffffb9c
	...

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
  20:	8b040e42 	blhi	103930 <__bss_end+0xf9d08>
  24:	0b0d4201 	bleq	350830 <__bss_end+0x346c08>
  28:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
  2c:	00000ecb 	andeq	r0, r0, fp, asr #29
  30:	0000001c 	andeq	r0, r0, ip, lsl r0
  34:	00000000 	andeq	r0, r0, r0
  38:	00008064 	andeq	r8, r0, r4, rrx
  3c:	00000040 	andeq	r0, r0, r0, asr #32
  40:	8b080e42 	blhi	203950 <__bss_end+0x1f9d28>
  44:	42018e02 	andmi	r8, r1, #2, 28
  48:	5a040b0c 	bpl	102c80 <__bss_end+0xf9058>
  4c:	00080d0c 	andeq	r0, r8, ip, lsl #26
  50:	0000000c 	andeq	r0, r0, ip
  54:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
  58:	7c020001 	stcvc	0, cr0, [r2], {1}
  5c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
  60:	0000001c 	andeq	r0, r0, ip, lsl r0
  64:	00000050 	andeq	r0, r0, r0, asr r0
  68:	000080a4 	andeq	r8, r0, r4, lsr #1
  6c:	00000038 	andeq	r0, r0, r8, lsr r0
  70:	8b040e42 	blhi	103980 <__bss_end+0xf9d58>
  74:	0b0d4201 	bleq	350880 <__bss_end+0x346c58>
  78:	420d0d54 	andmi	r0, sp, #84, 26	; 0x1500
  7c:	00000ecb 	andeq	r0, r0, fp, asr #29
  80:	0000001c 	andeq	r0, r0, ip, lsl r0
  84:	00000050 	andeq	r0, r0, r0, asr r0
  88:	000080dc 	ldrdeq	r8, [r0], -ip
  8c:	0000002c 	andeq	r0, r0, ip, lsr #32
  90:	8b040e42 	blhi	1039a0 <__bss_end+0xf9d78>
  94:	0b0d4201 	bleq	3508a0 <__bss_end+0x346c78>
  98:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
  9c:	00000ecb 	andeq	r0, r0, fp, asr #29
  a0:	0000001c 	andeq	r0, r0, ip, lsl r0
  a4:	00000050 	andeq	r0, r0, r0, asr r0
  a8:	00008108 	andeq	r8, r0, r8, lsl #2
  ac:	00000020 	andeq	r0, r0, r0, lsr #32
  b0:	8b040e42 	blhi	1039c0 <__bss_end+0xf9d98>
  b4:	0b0d4201 	bleq	3508c0 <__bss_end+0x346c98>
  b8:	420d0d48 	andmi	r0, sp, #72, 26	; 0x1200
  bc:	00000ecb 	andeq	r0, r0, fp, asr #29
  c0:	0000001c 	andeq	r0, r0, ip, lsl r0
  c4:	00000050 	andeq	r0, r0, r0, asr r0
  c8:	00008128 	andeq	r8, r0, r8, lsr #2
  cc:	00000018 	andeq	r0, r0, r8, lsl r0
  d0:	8b040e42 	blhi	1039e0 <__bss_end+0xf9db8>
  d4:	0b0d4201 	bleq	3508e0 <__bss_end+0x346cb8>
  d8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  dc:	00000ecb 	andeq	r0, r0, fp, asr #29
  e0:	0000001c 	andeq	r0, r0, ip, lsl r0
  e4:	00000050 	andeq	r0, r0, r0, asr r0
  e8:	00008140 	andeq	r8, r0, r0, asr #2
  ec:	00000018 	andeq	r0, r0, r8, lsl r0
  f0:	8b040e42 	blhi	103a00 <__bss_end+0xf9dd8>
  f4:	0b0d4201 	bleq	350900 <__bss_end+0x346cd8>
  f8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  fc:	00000ecb 	andeq	r0, r0, fp, asr #29
 100:	0000001c 	andeq	r0, r0, ip, lsl r0
 104:	00000050 	andeq	r0, r0, r0, asr r0
 108:	00008158 	andeq	r8, r0, r8, asr r1
 10c:	00000018 	andeq	r0, r0, r8, lsl r0
 110:	8b040e42 	blhi	103a20 <__bss_end+0xf9df8>
 114:	0b0d4201 	bleq	350920 <__bss_end+0x346cf8>
 118:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
 11c:	00000ecb 	andeq	r0, r0, fp, asr #29
 120:	00000014 	andeq	r0, r0, r4, lsl r0
 124:	00000050 	andeq	r0, r0, r0, asr r0
 128:	00008170 	andeq	r8, r0, r0, ror r1
 12c:	0000000c 	andeq	r0, r0, ip
 130:	8b040e42 	blhi	103a40 <__bss_end+0xf9e18>
 134:	0b0d4201 	bleq	350940 <__bss_end+0x346d18>
 138:	0000001c 	andeq	r0, r0, ip, lsl r0
 13c:	00000050 	andeq	r0, r0, r0, asr r0
 140:	0000817c 	andeq	r8, r0, ip, ror r1
 144:	00000058 	andeq	r0, r0, r8, asr r0
 148:	8b080e42 	blhi	203a58 <__bss_end+0x1f9e30>
 14c:	42018e02 	andmi	r8, r1, #2, 28
 150:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 154:	00080d0c 	andeq	r0, r8, ip, lsl #26
 158:	0000001c 	andeq	r0, r0, ip, lsl r0
 15c:	00000050 	andeq	r0, r0, r0, asr r0
 160:	000081d4 	ldrdeq	r8, [r0], -r4
 164:	00000058 	andeq	r0, r0, r8, asr r0
 168:	8b080e42 	blhi	203a78 <__bss_end+0x1f9e50>
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
 194:	00000194 	muleq	r0, r4, r1
 198:	8b080e42 	blhi	203aa8 <__bss_end+0x1f9e80>
 19c:	42018e02 	andmi	r8, r1, #2, 28
 1a0:	00040b0c 	andeq	r0, r4, ip, lsl #22
 1a4:	0000000c 	andeq	r0, r0, ip
 1a8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 1ac:	7c020001 	stcvc	0, cr0, [r2], {1}
 1b0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 1b4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1b8:	000001a4 	andeq	r0, r0, r4, lsr #3
 1bc:	000083c0 	andeq	r8, r0, r0, asr #7
 1c0:	0000002c 	andeq	r0, r0, ip, lsr #32
 1c4:	8b040e42 	blhi	103ad4 <__bss_end+0xf9eac>
 1c8:	0b0d4201 	bleq	3509d4 <__bss_end+0x346dac>
 1cc:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 1d0:	00000ecb 	andeq	r0, r0, fp, asr #29
 1d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1d8:	000001a4 	andeq	r0, r0, r4, lsr #3
 1dc:	000083ec 	andeq	r8, r0, ip, ror #7
 1e0:	0000002c 	andeq	r0, r0, ip, lsr #32
 1e4:	8b040e42 	blhi	103af4 <__bss_end+0xf9ecc>
 1e8:	0b0d4201 	bleq	3509f4 <__bss_end+0x346dcc>
 1ec:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 1f0:	00000ecb 	andeq	r0, r0, fp, asr #29
 1f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1f8:	000001a4 	andeq	r0, r0, r4, lsr #3
 1fc:	00008418 	andeq	r8, r0, r8, lsl r4
 200:	0000001c 	andeq	r0, r0, ip, lsl r0
 204:	8b040e42 	blhi	103b14 <__bss_end+0xf9eec>
 208:	0b0d4201 	bleq	350a14 <__bss_end+0x346dec>
 20c:	420d0d46 	andmi	r0, sp, #4480	; 0x1180
 210:	00000ecb 	andeq	r0, r0, fp, asr #29
 214:	0000001c 	andeq	r0, r0, ip, lsl r0
 218:	000001a4 	andeq	r0, r0, r4, lsr #3
 21c:	00008434 	andeq	r8, r0, r4, lsr r4
 220:	00000044 	andeq	r0, r0, r4, asr #32
 224:	8b040e42 	blhi	103b34 <__bss_end+0xf9f0c>
 228:	0b0d4201 	bleq	350a34 <__bss_end+0x346e0c>
 22c:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 230:	00000ecb 	andeq	r0, r0, fp, asr #29
 234:	0000001c 	andeq	r0, r0, ip, lsl r0
 238:	000001a4 	andeq	r0, r0, r4, lsr #3
 23c:	00008478 	andeq	r8, r0, r8, ror r4
 240:	00000050 	andeq	r0, r0, r0, asr r0
 244:	8b040e42 	blhi	103b54 <__bss_end+0xf9f2c>
 248:	0b0d4201 	bleq	350a54 <__bss_end+0x346e2c>
 24c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 250:	00000ecb 	andeq	r0, r0, fp, asr #29
 254:	0000001c 	andeq	r0, r0, ip, lsl r0
 258:	000001a4 	andeq	r0, r0, r4, lsr #3
 25c:	000084c8 	andeq	r8, r0, r8, asr #9
 260:	00000050 	andeq	r0, r0, r0, asr r0
 264:	8b040e42 	blhi	103b74 <__bss_end+0xf9f4c>
 268:	0b0d4201 	bleq	350a74 <__bss_end+0x346e4c>
 26c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 270:	00000ecb 	andeq	r0, r0, fp, asr #29
 274:	0000001c 	andeq	r0, r0, ip, lsl r0
 278:	000001a4 	andeq	r0, r0, r4, lsr #3
 27c:	00008518 	andeq	r8, r0, r8, lsl r5
 280:	0000002c 	andeq	r0, r0, ip, lsr #32
 284:	8b040e42 	blhi	103b94 <__bss_end+0xf9f6c>
 288:	0b0d4201 	bleq	350a94 <__bss_end+0x346e6c>
 28c:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 290:	00000ecb 	andeq	r0, r0, fp, asr #29
 294:	0000001c 	andeq	r0, r0, ip, lsl r0
 298:	000001a4 	andeq	r0, r0, r4, lsr #3
 29c:	00008544 	andeq	r8, r0, r4, asr #10
 2a0:	00000050 	andeq	r0, r0, r0, asr r0
 2a4:	8b040e42 	blhi	103bb4 <__bss_end+0xf9f8c>
 2a8:	0b0d4201 	bleq	350ab4 <__bss_end+0x346e8c>
 2ac:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 2b0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2b4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2b8:	000001a4 	andeq	r0, r0, r4, lsr #3
 2bc:	00008594 	muleq	r0, r4, r5
 2c0:	00000044 	andeq	r0, r0, r4, asr #32
 2c4:	8b040e42 	blhi	103bd4 <__bss_end+0xf9fac>
 2c8:	0b0d4201 	bleq	350ad4 <__bss_end+0x346eac>
 2cc:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 2d0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2d8:	000001a4 	andeq	r0, r0, r4, lsr #3
 2dc:	000085d8 	ldrdeq	r8, [r0], -r8	; <UNPREDICTABLE>
 2e0:	00000050 	andeq	r0, r0, r0, asr r0
 2e4:	8b040e42 	blhi	103bf4 <__bss_end+0xf9fcc>
 2e8:	0b0d4201 	bleq	350af4 <__bss_end+0x346ecc>
 2ec:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 2f0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2f8:	000001a4 	andeq	r0, r0, r4, lsr #3
 2fc:	00008628 	andeq	r8, r0, r8, lsr #12
 300:	00000054 	andeq	r0, r0, r4, asr r0
 304:	8b040e42 	blhi	103c14 <__bss_end+0xf9fec>
 308:	0b0d4201 	bleq	350b14 <__bss_end+0x346eec>
 30c:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 310:	00000ecb 	andeq	r0, r0, fp, asr #29
 314:	0000001c 	andeq	r0, r0, ip, lsl r0
 318:	000001a4 	andeq	r0, r0, r4, lsr #3
 31c:	0000867c 	andeq	r8, r0, ip, ror r6
 320:	0000003c 	andeq	r0, r0, ip, lsr r0
 324:	8b040e42 	blhi	103c34 <__bss_end+0xfa00c>
 328:	0b0d4201 	bleq	350b34 <__bss_end+0x346f0c>
 32c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 330:	00000ecb 	andeq	r0, r0, fp, asr #29
 334:	0000001c 	andeq	r0, r0, ip, lsl r0
 338:	000001a4 	andeq	r0, r0, r4, lsr #3
 33c:	000086b8 			; <UNDEFINED> instruction: 0x000086b8
 340:	0000003c 	andeq	r0, r0, ip, lsr r0
 344:	8b040e42 	blhi	103c54 <__bss_end+0xfa02c>
 348:	0b0d4201 	bleq	350b54 <__bss_end+0x346f2c>
 34c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 350:	00000ecb 	andeq	r0, r0, fp, asr #29
 354:	0000001c 	andeq	r0, r0, ip, lsl r0
 358:	000001a4 	andeq	r0, r0, r4, lsr #3
 35c:	000086f4 	strdeq	r8, [r0], -r4
 360:	0000003c 	andeq	r0, r0, ip, lsr r0
 364:	8b040e42 	blhi	103c74 <__bss_end+0xfa04c>
 368:	0b0d4201 	bleq	350b74 <__bss_end+0x346f4c>
 36c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 370:	00000ecb 	andeq	r0, r0, fp, asr #29
 374:	0000001c 	andeq	r0, r0, ip, lsl r0
 378:	000001a4 	andeq	r0, r0, r4, lsr #3
 37c:	00008730 	andeq	r8, r0, r0, lsr r7
 380:	0000003c 	andeq	r0, r0, ip, lsr r0
 384:	8b040e42 	blhi	103c94 <__bss_end+0xfa06c>
 388:	0b0d4201 	bleq	350b94 <__bss_end+0x346f6c>
 38c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 390:	00000ecb 	andeq	r0, r0, fp, asr #29
 394:	0000001c 	andeq	r0, r0, ip, lsl r0
 398:	000001a4 	andeq	r0, r0, r4, lsr #3
 39c:	0000876c 	andeq	r8, r0, ip, ror #14
 3a0:	000000b0 	strheq	r0, [r0], -r0	; <UNPREDICTABLE>
 3a4:	8b080e42 	blhi	203cb4 <__bss_end+0x1fa08c>
 3a8:	42018e02 	andmi	r8, r1, #2, 28
 3ac:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 3b0:	080d0c50 	stmdaeq	sp, {r4, r6, sl, fp}
 3b4:	0000000c 	andeq	r0, r0, ip
 3b8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 3bc:	7c020001 	stcvc	0, cr0, [r2], {1}
 3c0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 3c4:	0000001c 	andeq	r0, r0, ip, lsl r0
 3c8:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 3cc:	00008820 	andeq	r8, r0, r0, lsr #16
 3d0:	00000178 	andeq	r0, r0, r8, ror r1
 3d4:	8b080e42 	blhi	203ce4 <__bss_end+0x1fa0bc>
 3d8:	42018e02 	andmi	r8, r1, #2, 28
 3dc:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 3e0:	080d0cb4 	stmdaeq	sp, {r2, r4, r5, r7, sl, fp}
 3e4:	0000001c 	andeq	r0, r0, ip, lsl r0
 3e8:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 3ec:	00008998 	muleq	r0, r8, r9
 3f0:	000000cc 	andeq	r0, r0, ip, asr #1
 3f4:	8b080e42 	blhi	203d04 <__bss_end+0x1fa0dc>
 3f8:	42018e02 	andmi	r8, r1, #2, 28
 3fc:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 400:	080d0c60 	stmdaeq	sp, {r5, r6, sl, fp}
 404:	0000001c 	andeq	r0, r0, ip, lsl r0
 408:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 40c:	00008a64 	andeq	r8, r0, r4, ror #20
 410:	00000100 	andeq	r0, r0, r0, lsl #2
 414:	8b040e42 	blhi	103d24 <__bss_end+0xfa0fc>
 418:	0b0d4201 	bleq	350c24 <__bss_end+0x346ffc>
 41c:	0d0d7802 	stceq	8, cr7, [sp, #-8]
 420:	000ecb42 	andeq	ip, lr, r2, asr #22
 424:	0000001c 	andeq	r0, r0, ip, lsl r0
 428:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 42c:	00008b64 	andeq	r8, r0, r4, ror #22
 430:	0000015c 	andeq	r0, r0, ip, asr r1
 434:	8b040e42 	blhi	103d44 <__bss_end+0xfa11c>
 438:	0b0d4201 	bleq	350c44 <__bss_end+0x34701c>
 43c:	0d0d9c02 	stceq	12, cr9, [sp, #-8]
 440:	000ecb42 	andeq	ip, lr, r2, asr #22
 444:	0000001c 	andeq	r0, r0, ip, lsl r0
 448:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 44c:	00008cc0 	andeq	r8, r0, r0, asr #25
 450:	000000c0 	andeq	r0, r0, r0, asr #1
 454:	8b040e42 	blhi	103d64 <__bss_end+0xfa13c>
 458:	0b0d4201 	bleq	350c64 <__bss_end+0x34703c>
 45c:	0d0d5802 	stceq	8, cr5, [sp, #-8]
 460:	000ecb42 	andeq	ip, lr, r2, asr #22
 464:	0000001c 	andeq	r0, r0, ip, lsl r0
 468:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 46c:	00008d80 	andeq	r8, r0, r0, lsl #27
 470:	000000ac 	andeq	r0, r0, ip, lsr #1
 474:	8b040e42 	blhi	103d84 <__bss_end+0xfa15c>
 478:	0b0d4201 	bleq	350c84 <__bss_end+0x34705c>
 47c:	0d0d4e02 	stceq	14, cr4, [sp, #-8]
 480:	000ecb42 	andeq	ip, lr, r2, asr #22
 484:	0000001c 	andeq	r0, r0, ip, lsl r0
 488:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 48c:	00008e2c 	andeq	r8, r0, ip, lsr #28
 490:	00000054 	andeq	r0, r0, r4, asr r0
 494:	8b040e42 	blhi	103da4 <__bss_end+0xfa17c>
 498:	0b0d4201 	bleq	350ca4 <__bss_end+0x34707c>
 49c:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 4a0:	00000ecb 	andeq	r0, r0, fp, asr #29
 4a4:	0000001c 	andeq	r0, r0, ip, lsl r0
 4a8:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 4ac:	00008e80 	andeq	r8, r0, r0, lsl #29
 4b0:	000000ac 	andeq	r0, r0, ip, lsr #1
 4b4:	8b080e42 	blhi	203dc4 <__bss_end+0x1fa19c>
 4b8:	42018e02 	andmi	r8, r1, #2, 28
 4bc:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 4c0:	080d0c50 	stmdaeq	sp, {r4, r6, sl, fp}
 4c4:	0000001c 	andeq	r0, r0, ip, lsl r0
 4c8:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 4cc:	00008f2c 	andeq	r8, r0, ip, lsr #30
 4d0:	000000d8 	ldrdeq	r0, [r0], -r8
 4d4:	8b080e42 	blhi	203de4 <__bss_end+0x1fa1bc>
 4d8:	42018e02 	andmi	r8, r1, #2, 28
 4dc:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 4e0:	080d0c66 	stmdaeq	sp, {r1, r2, r5, r6, sl, fp}
 4e4:	0000001c 	andeq	r0, r0, ip, lsl r0
 4e8:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 4ec:	00009004 	andeq	r9, r0, r4
 4f0:	00000068 	andeq	r0, r0, r8, rrx
 4f4:	8b040e42 	blhi	103e04 <__bss_end+0xfa1dc>
 4f8:	0b0d4201 	bleq	350d04 <__bss_end+0x3470dc>
 4fc:	420d0d6c 	andmi	r0, sp, #108, 26	; 0x1b00
 500:	00000ecb 	andeq	r0, r0, fp, asr #29
 504:	0000001c 	andeq	r0, r0, ip, lsl r0
 508:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 50c:	0000906c 	andeq	r9, r0, ip, rrx
 510:	00000080 	andeq	r0, r0, r0, lsl #1
 514:	8b040e42 	blhi	103e24 <__bss_end+0xfa1fc>
 518:	0b0d4201 	bleq	350d24 <__bss_end+0x3470fc>
 51c:	420d0d78 	andmi	r0, sp, #120, 26	; 0x1e00
 520:	00000ecb 	andeq	r0, r0, fp, asr #29
 524:	0000001c 	andeq	r0, r0, ip, lsl r0
 528:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 52c:	000090ec 	andeq	r9, r0, ip, ror #1
 530:	00000068 	andeq	r0, r0, r8, rrx
 534:	8b040e42 	blhi	103e44 <__bss_end+0xfa21c>
 538:	0b0d4201 	bleq	350d44 <__bss_end+0x34711c>
 53c:	420d0d6c 	andmi	r0, sp, #108, 26	; 0x1b00
 540:	00000ecb 	andeq	r0, r0, fp, asr #29
 544:	0000002c 	andeq	r0, r0, ip, lsr #32
 548:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 54c:	00009154 	andeq	r9, r0, r4, asr r1
 550:	00000328 	andeq	r0, r0, r8, lsr #6
 554:	84200e42 	strthi	r0, [r0], #-3650	; 0xfffff1be
 558:	86078508 	strhi	r8, [r7], -r8, lsl #10
 55c:	88058706 	stmdahi	r5, {r1, r2, r8, r9, sl, pc}
 560:	8b038904 	blhi	e2978 <__bss_end+0xd8d50>
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
 58c:	0000947c 	andeq	r9, r0, ip, ror r4
 590:	000001ec 	andeq	r0, r0, ip, ror #3
 594:	0000000c 	andeq	r0, r0, ip
 598:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 59c:	7c020001 	stcvc	0, cr0, [r2], {1}
 5a0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 5a4:	00000010 	andeq	r0, r0, r0, lsl r0
 5a8:	00000594 	muleq	r0, r4, r5
 5ac:	0000968c 	andeq	r9, r0, ip, lsl #13
 5b0:	0000019c 	muleq	r0, ip, r1
 5b4:	0bce020a 	bleq	ff380de4 <__bss_end+0xff3771bc>
 5b8:	00000010 	andeq	r0, r0, r0, lsl r0
 5bc:	00000594 	muleq	r0, r4, r5
 5c0:	00009828 	andeq	r9, r0, r8, lsr #16
 5c4:	00000028 	andeq	r0, r0, r8, lsr #32
 5c8:	000b540a 	andeq	r5, fp, sl, lsl #8
 5cc:	00000010 	andeq	r0, r0, r0, lsl r0
 5d0:	00000594 	muleq	r0, r4, r5
 5d4:	00009850 	andeq	r9, r0, r0, asr r8
 5d8:	0000008c 	andeq	r0, r0, ip, lsl #1
 5dc:	0b46020a 	bleq	1180e0c <__bss_end+0x11771e4>
 5e0:	0000000c 	andeq	r0, r0, ip
 5e4:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 5e8:	7c020001 	stcvc	0, cr0, [r2], {1}
 5ec:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 5f0:	00000030 	andeq	r0, r0, r0, lsr r0
 5f4:	000005e0 	andeq	r0, r0, r0, ror #11
 5f8:	000098dc 	ldrdeq	r9, [r0], -ip
 5fc:	000000d4 	ldrdeq	r0, [r0], -r4
 600:	8e100e5a 	mrchi	14, 0, r0, cr0, cr10, {2}
 604:	460a4a03 	strmi	r4, [sl], -r3, lsl #20
 608:	42100ece 	andsmi	r0, r0, #3296	; 0xce0
 60c:	460a4a0b 	strmi	r4, [sl], -fp, lsl #20
 610:	4a100ece 	bmi	404150 <__bss_end+0x3fa528>
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
 63c:	000099b0 			; <UNDEFINED> instruction: 0x000099b0
 640:	00000030 	andeq	r0, r0, r0, lsr r0
 644:	84080e4e 	strhi	r0, [r8], #-3662	; 0xfffff1b2
 648:	00018e02 	andeq	r8, r1, r2, lsl #28
 64c:	0000000c 	andeq	r0, r0, ip
 650:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 654:	7c020001 	stcvc	0, cr0, [r2], {1}
 658:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 65c:	0000000c 	andeq	r0, r0, ip
 660:	0000064c 	andeq	r0, r0, ip, asr #12
 664:	000099e0 	andeq	r9, r0, r0, ror #19
 668:	00000040 	andeq	r0, r0, r0, asr #32
 66c:	0000000c 	andeq	r0, r0, ip
 670:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 674:	7c020001 	stcvc	0, cr0, [r2], {1}
 678:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 67c:	00000020 	andeq	r0, r0, r0, lsr #32
 680:	0000066c 	andeq	r0, r0, ip, ror #12
 684:	00009a20 	andeq	r9, r0, r0, lsr #20
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

