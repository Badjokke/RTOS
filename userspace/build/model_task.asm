
./model_task:     file format elf32-littlearm


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
    805c:	0000c0dc 	ldrdeq	ip, [r0], -ip	; <UNPREDICTABLE>
    8060:	0000c0f8 	strdeq	ip, [r0], -r8

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
    8080:	eb0000f1 	bl	844c <main>
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
    81cc:	0000c0d8 	ldrdeq	ip, [r0], -r8
    81d0:	0000c0dc 	ldrdeq	ip, [r0], -ip	; <UNPREDICTABLE>

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
    8224:	0000c0dc 	ldrdeq	ip, [r0], -ip	; <UNPREDICTABLE>
    8228:	0000c0dc 	ldrdeq	ip, [r0], -ip	; <UNPREDICTABLE>

0000822c <_Z10dummy_dataPf>:
_Z10dummy_dataPf():
/home/trefil/sem/sources/userspace/model_task/main.cpp:19
const int POPULATION_COUNT = 500;
const int EPOCH_COUNT = 50;
const int DATA_WINDOW_SIZE = 20;

//vytvor sample data pro model
void dummy_data(float* data){
    822c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8230:	e28db000 	add	fp, sp, #0
    8234:	e24dd00c 	sub	sp, sp, #12
    8238:	e50b0008 	str	r0, [fp, #-8]
/home/trefil/sem/sources/userspace/model_task/main.cpp:21
    //sample data
    data[0] = 3.487;
    823c:	e51b3008 	ldr	r3, [fp, #-8]
    8240:	e59f2140 	ldr	r2, [pc, #320]	; 8388 <_Z10dummy_dataPf+0x15c>
    8244:	e5832000 	str	r2, [r3]
/home/trefil/sem/sources/userspace/model_task/main.cpp:22
    data[1] = 4.486;
    8248:	e51b3008 	ldr	r3, [fp, #-8]
    824c:	e2833004 	add	r3, r3, #4
    8250:	e59f2134 	ldr	r2, [pc, #308]	; 838c <_Z10dummy_dataPf+0x160>
    8254:	e5832000 	str	r2, [r3]
/home/trefil/sem/sources/userspace/model_task/main.cpp:23
    data[2] = 5.876;
    8258:	e51b3008 	ldr	r3, [fp, #-8]
    825c:	e2833008 	add	r3, r3, #8
    8260:	e59f2128 	ldr	r2, [pc, #296]	; 8390 <_Z10dummy_dataPf+0x164>
    8264:	e5832000 	str	r2, [r3]
/home/trefil/sem/sources/userspace/model_task/main.cpp:24
    data[3] = 6.4876;
    8268:	e51b3008 	ldr	r3, [fp, #-8]
    826c:	e283300c 	add	r3, r3, #12
    8270:	e59f211c 	ldr	r2, [pc, #284]	; 8394 <_Z10dummy_dataPf+0x168>
    8274:	e5832000 	str	r2, [r3]
/home/trefil/sem/sources/userspace/model_task/main.cpp:26

    data[4] = 7.486;
    8278:	e51b3008 	ldr	r3, [fp, #-8]
    827c:	e2833010 	add	r3, r3, #16
    8280:	e59f2110 	ldr	r2, [pc, #272]	; 8398 <_Z10dummy_dataPf+0x16c>
    8284:	e5832000 	str	r2, [r3]
/home/trefil/sem/sources/userspace/model_task/main.cpp:27
    data[5] = 8.4876;
    8288:	e51b3008 	ldr	r3, [fp, #-8]
    828c:	e2833014 	add	r3, r3, #20
    8290:	e59f2104 	ldr	r2, [pc, #260]	; 839c <_Z10dummy_dataPf+0x170>
    8294:	e5832000 	str	r2, [r3]
/home/trefil/sem/sources/userspace/model_task/main.cpp:28
    data[6] = 9.476;
    8298:	e51b3008 	ldr	r3, [fp, #-8]
    829c:	e2833018 	add	r3, r3, #24
    82a0:	e59f20f8 	ldr	r2, [pc, #248]	; 83a0 <_Z10dummy_dataPf+0x174>
    82a4:	e5832000 	str	r2, [r3]
/home/trefil/sem/sources/userspace/model_task/main.cpp:29
    data[7] = 11.76;
    82a8:	e51b3008 	ldr	r3, [fp, #-8]
    82ac:	e283301c 	add	r3, r3, #28
    82b0:	e59f20ec 	ldr	r2, [pc, #236]	; 83a4 <_Z10dummy_dataPf+0x178>
    82b4:	e5832000 	str	r2, [r3]
/home/trefil/sem/sources/userspace/model_task/main.cpp:30
    data[8] = 13.76;
    82b8:	e51b3008 	ldr	r3, [fp, #-8]
    82bc:	e2833020 	add	r3, r3, #32
    82c0:	e59f20e0 	ldr	r2, [pc, #224]	; 83a8 <_Z10dummy_dataPf+0x17c>
    82c4:	e5832000 	str	r2, [r3]
/home/trefil/sem/sources/userspace/model_task/main.cpp:31
    data[9] = 16.4876;
    82c8:	e51b3008 	ldr	r3, [fp, #-8]
    82cc:	e2833024 	add	r3, r3, #36	; 0x24
    82d0:	e59f20d4 	ldr	r2, [pc, #212]	; 83ac <_Z10dummy_dataPf+0x180>
    82d4:	e5832000 	str	r2, [r3]
/home/trefil/sem/sources/userspace/model_task/main.cpp:32
    data[10] = 16.4876;
    82d8:	e51b3008 	ldr	r3, [fp, #-8]
    82dc:	e2833028 	add	r3, r3, #40	; 0x28
    82e0:	e59f20c4 	ldr	r2, [pc, #196]	; 83ac <_Z10dummy_dataPf+0x180>
    82e4:	e5832000 	str	r2, [r3]
/home/trefil/sem/sources/userspace/model_task/main.cpp:33
    data[11] = 16.876;
    82e8:	e51b3008 	ldr	r3, [fp, #-8]
    82ec:	e283302c 	add	r3, r3, #44	; 0x2c
    82f0:	e59f20b8 	ldr	r2, [pc, #184]	; 83b0 <_Z10dummy_dataPf+0x184>
    82f4:	e5832000 	str	r2, [r3]
/home/trefil/sem/sources/userspace/model_task/main.cpp:34
    data[12] = 16.9876;
    82f8:	e51b3008 	ldr	r3, [fp, #-8]
    82fc:	e2833030 	add	r3, r3, #48	; 0x30
    8300:	e59f20ac 	ldr	r2, [pc, #172]	; 83b4 <_Z10dummy_dataPf+0x188>
    8304:	e5832000 	str	r2, [r3]
/home/trefil/sem/sources/userspace/model_task/main.cpp:35
    data[13] = 17.4876;
    8308:	e51b3008 	ldr	r3, [fp, #-8]
    830c:	e2833034 	add	r3, r3, #52	; 0x34
    8310:	e59f20a0 	ldr	r2, [pc, #160]	; 83b8 <_Z10dummy_dataPf+0x18c>
    8314:	e5832000 	str	r2, [r3]
/home/trefil/sem/sources/userspace/model_task/main.cpp:36
    data[14] = 17.9876;
    8318:	e51b3008 	ldr	r3, [fp, #-8]
    831c:	e2833038 	add	r3, r3, #56	; 0x38
    8320:	e59f2094 	ldr	r2, [pc, #148]	; 83bc <_Z10dummy_dataPf+0x190>
    8324:	e5832000 	str	r2, [r3]
/home/trefil/sem/sources/userspace/model_task/main.cpp:37
    data[15] = 18.4876;
    8328:	e51b3008 	ldr	r3, [fp, #-8]
    832c:	e283303c 	add	r3, r3, #60	; 0x3c
    8330:	e59f2088 	ldr	r2, [pc, #136]	; 83c0 <_Z10dummy_dataPf+0x194>
    8334:	e5832000 	str	r2, [r3]
/home/trefil/sem/sources/userspace/model_task/main.cpp:38
    data[16] = 18.9876;
    8338:	e51b3008 	ldr	r3, [fp, #-8]
    833c:	e2833040 	add	r3, r3, #64	; 0x40
    8340:	e59f207c 	ldr	r2, [pc, #124]	; 83c4 <_Z10dummy_dataPf+0x198>
    8344:	e5832000 	str	r2, [r3]
/home/trefil/sem/sources/userspace/model_task/main.cpp:39
    data[17] = 19.4576;
    8348:	e51b3008 	ldr	r3, [fp, #-8]
    834c:	e2833044 	add	r3, r3, #68	; 0x44
    8350:	e59f2070 	ldr	r2, [pc, #112]	; 83c8 <_Z10dummy_dataPf+0x19c>
    8354:	e5832000 	str	r2, [r3]
/home/trefil/sem/sources/userspace/model_task/main.cpp:40
    data[18] = 19.4576;
    8358:	e51b3008 	ldr	r3, [fp, #-8]
    835c:	e2833048 	add	r3, r3, #72	; 0x48
    8360:	e59f2060 	ldr	r2, [pc, #96]	; 83c8 <_Z10dummy_dataPf+0x19c>
    8364:	e5832000 	str	r2, [r3]
/home/trefil/sem/sources/userspace/model_task/main.cpp:41
    data[19] = 19.9876;
    8368:	e51b3008 	ldr	r3, [fp, #-8]
    836c:	e283304c 	add	r3, r3, #76	; 0x4c
    8370:	e59f2054 	ldr	r2, [pc, #84]	; 83cc <_Z10dummy_dataPf+0x1a0>
    8374:	e5832000 	str	r2, [r3]
/home/trefil/sem/sources/userspace/model_task/main.cpp:44


}
    8378:	e320f000 	nop	{0}
    837c:	e28bd000 	add	sp, fp, #0
    8380:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8384:	e12fff1e 	bx	lr
    8388:	405f2b02 	subsmi	r2, pc, r2, lsl #22
    838c:	408f8d50 	addmi	r8, pc, r0, asr sp	; <UNPREDICTABLE>
    8390:	40bc0831 	adcsmi	r0, ip, r1, lsr r8
    8394:	40cf9a6b 	sbcmi	r9, pc, fp, ror #20
    8398:	40ef8d50 	rscmi	r8, pc, r0, asr sp	; <UNPREDICTABLE>
    839c:	4107cd36 	tstmi	r7, r6, lsr sp
    83a0:	41179db2 			; <UNDEFINED> instruction: 0x41179db2
    83a4:	413c28f6 	teqmi	ip, r6	; <illegal shifter operand>
    83a8:	415c28f6 	ldrshmi	r2, [ip, #-134]	; 0xffffff7a
    83ac:	4183e69b 			; <UNDEFINED> instruction: 0x4183e69b
    83b0:	4187020c 	orrmi	r0, r7, ip, lsl #4
    83b4:	4187e69b 			; <UNDEFINED> instruction: 0x4187e69b
    83b8:	418be69b 			; <UNDEFINED> instruction: 0x418be69b
    83bc:	418fe69b 			; <UNDEFINED> instruction: 0x418fe69b
    83c0:	4193e69b 			; <UNDEFINED> instruction: 0x4193e69b
    83c4:	4197e69b 			; <UNDEFINED> instruction: 0x4197e69b
    83c8:	419ba92a 	orrsmi	sl, fp, sl, lsr #18
    83cc:	419fe69b 			; <UNDEFINED> instruction: 0x419fe69b

000083d0 <_Z16hello_uart_worldP6Buffer>:
_Z16hello_uart_worldP6Buffer():
/home/trefil/sem/sources/userspace/model_task/main.cpp:46
//vypis na uart uvodni srandicky
void hello_uart_world(Buffer* bfr){
    83d0:	e92d4800 	push	{fp, lr}
    83d4:	e28db004 	add	fp, sp, #4
    83d8:	e24dd008 	sub	sp, sp, #8
    83dc:	e50b0008 	str	r0, [fp, #-8]
/home/trefil/sem/sources/userspace/model_task/main.cpp:47
    bfr->Write_Line("CalcOS v1.1\n");
    83e0:	e59f104c 	ldr	r1, [pc, #76]	; 8434 <_Z16hello_uart_worldP6Buffer+0x64>
    83e4:	e51b0008 	ldr	r0, [fp, #-8]
    83e8:	eb000720 	bl	a070 <_ZN6Buffer10Write_LineEPKc>
/home/trefil/sem/sources/userspace/model_task/main.cpp:48
    bfr->Write_Line("Autor: Jiri Trefil (A22N0060P)\n");
    83ec:	e59f1044 	ldr	r1, [pc, #68]	; 8438 <_Z16hello_uart_worldP6Buffer+0x68>
    83f0:	e51b0008 	ldr	r0, [fp, #-8]
    83f4:	eb00071d 	bl	a070 <_ZN6Buffer10Write_LineEPKc>
/home/trefil/sem/sources/userspace/model_task/main.cpp:49
    bfr->Write_Line("Zadejte nejprve casovy rozestup a predikcni okenko v minutach\n");
    83f8:	e59f103c 	ldr	r1, [pc, #60]	; 843c <_Z16hello_uart_worldP6Buffer+0x6c>
    83fc:	e51b0008 	ldr	r0, [fp, #-8]
    8400:	eb00071a 	bl	a070 <_ZN6Buffer10Write_LineEPKc>
/home/trefil/sem/sources/userspace/model_task/main.cpp:50
    bfr->Write_Line("Dale podporovany prikazy: stop, parameters\n");
    8404:	e59f1034 	ldr	r1, [pc, #52]	; 8440 <_Z16hello_uart_worldP6Buffer+0x70>
    8408:	e51b0008 	ldr	r0, [fp, #-8]
    840c:	eb000717 	bl	a070 <_ZN6Buffer10Write_LineEPKc>
/home/trefil/sem/sources/userspace/model_task/main.cpp:51
    bfr->Write_Line("stop - zastavi fitting modelu\n");
    8410:	e59f102c 	ldr	r1, [pc, #44]	; 8444 <_Z16hello_uart_worldP6Buffer+0x74>
    8414:	e51b0008 	ldr	r0, [fp, #-8]
    8418:	eb000714 	bl	a070 <_ZN6Buffer10Write_LineEPKc>
/home/trefil/sem/sources/userspace/model_task/main.cpp:52
    bfr->Write_Line("parameters - vypise parametry modelu\n");
    841c:	e59f1024 	ldr	r1, [pc, #36]	; 8448 <_Z16hello_uart_worldP6Buffer+0x78>
    8420:	e51b0008 	ldr	r0, [fp, #-8]
    8424:	eb000711 	bl	a070 <_ZN6Buffer10Write_LineEPKc>
/home/trefil/sem/sources/userspace/model_task/main.cpp:53
}
    8428:	e320f000 	nop	{0}
    842c:	e24bd004 	sub	sp, fp, #4
    8430:	e8bd8800 	pop	{fp, pc}
    8434:	0000be10 	andeq	fp, r0, r0, lsl lr
    8438:	0000be20 	andeq	fp, r0, r0, lsr #28
    843c:	0000be40 	andeq	fp, r0, r0, asr #28
    8440:	0000be80 	andeq	fp, r0, r0, lsl #29
    8444:	0000beac 	andeq	fp, r0, ip, lsr #29
    8448:	0000becc 	andeq	fp, r0, ip, asr #29

0000844c <main>:
main():
/home/trefil/sem/sources/userspace/model_task/main.cpp:56


int main(){
    844c:	e92d4810 	push	{r4, fp, lr}
    8450:	e28db008 	add	fp, sp, #8
    8454:	e24ddf53 	sub	sp, sp, #332	; 0x14c
/home/trefil/sem/sources/userspace/model_task/main.cpp:58
    //otevri uart na read/write
    uint32_t uart_file = open("DEV:uart/0", NFile_Open_Mode::Read_Write);
    8458:	e3a01002 	mov	r1, #2
    845c:	e59f0118 	ldr	r0, [pc, #280]	; 857c <main+0x130>
    8460:	eb0007cf 	bl	a3a4 <_Z4openPKc15NFile_Open_Mode>
    8464:	e50b0010 	str	r0, [fp, #-16]
/home/trefil/sem/sources/userspace/model_task/main.cpp:70
    //user input
    char* t_pred;
    char* t_delta;

    //pomocne stringy pro strcat funkci, abych nejak rozumne odpovdel uzivateli, neni to uplne hezke
    char tmp1[] = "OK, predpoved ";
    8468:	e59f3110 	ldr	r3, [pc, #272]	; 8580 <main+0x134>
    846c:	e24bc030 	sub	ip, fp, #48	; 0x30
    8470:	e893000f 	ldm	r3, {r0, r1, r2, r3}
    8474:	e8ac0007 	stmia	ip!, {r0, r1, r2}
    8478:	e1cc30b0 	strh	r3, [ip]
    847c:	e28cc002 	add	ip, ip, #2
    8480:	e1a03823 	lsr	r3, r3, #16
    8484:	e5cc3000 	strb	r3, [ip]
/home/trefil/sem/sources/userspace/model_task/main.cpp:71
    char tmp2[] = "OK, krokovani ";
    8488:	e59f30f4 	ldr	r3, [pc, #244]	; 8584 <main+0x138>
    848c:	e24bc040 	sub	ip, fp, #64	; 0x40
    8490:	e893000f 	ldm	r3, {r0, r1, r2, r3}
    8494:	e8ac0007 	stmia	ip!, {r0, r1, r2}
    8498:	e1cc30b0 	strh	r3, [ip]
    849c:	e28cc002 	add	ip, ip, #2
    84a0:	e1a03823 	lsr	r3, r3, #16
    84a4:	e5cc3000 	strb	r3, [ip]
/home/trefil/sem/sources/userspace/model_task/main.cpp:72
    char tmp3[] = " minut\n";
    84a8:	e59f20d8 	ldr	r2, [pc, #216]	; 8588 <main+0x13c>
    84ac:	e24b3048 	sub	r3, fp, #72	; 0x48
    84b0:	e8920003 	ldm	r2, {r0, r1}
    84b4:	e8830003 	stm	r3, {r0, r1}
/home/trefil/sem/sources/userspace/model_task/main.cpp:75

    //buffer pro vyhazovani outputu uzivateli
    char tmp_str[255] = {0};
    84b8:	e3a03000 	mov	r3, #0
    84bc:	e50b3148 	str	r3, [fp, #-328]	; 0xfffffeb8
    84c0:	e24b3f51 	sub	r3, fp, #324	; 0x144
    84c4:	e3a020fb 	mov	r2, #251	; 0xfb
    84c8:	e3a01000 	mov	r1, #0
    84cc:	e1a00003 	mov	r0, r3
    84d0:	eb000dfa 	bl	bcc0 <memset>
/home/trefil/sem/sources/userspace/model_task/main.cpp:80

    //data = new float[window_size];
    //dummy_data(data);

    bfr = new Buffer(uart_file);
    84d4:	e3a00f43 	mov	r0, #268	; 0x10c
    84d8:	eb00002c 	bl	8590 <_Znwj>
    84dc:	e1a03000 	mov	r3, r0
    84e0:	e1a04003 	mov	r4, r3
    84e4:	e51b1010 	ldr	r1, [fp, #-16]
    84e8:	e1a00004 	mov	r0, r4
    84ec:	eb00068b 	bl	9f20 <_ZN6BufferC1Ej>
    84f0:	e50b4014 	str	r4, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/userspace/model_task/main.cpp:83

    //vypis uzivateli uvodni povidani
    hello_uart_world(bfr);
    84f4:	e51b0014 	ldr	r0, [fp, #-20]	; 0xffffffec
    84f8:	ebffffb4 	bl	83d0 <_Z16hello_uart_worldP6Buffer>
/home/trefil/sem/sources/userspace/model_task/main.cpp:105
    bfr->Write_Line(tmp_str);
    tmp_str[0] = '\0';
    */

    //vyparsuj hodnoty od uzivatele na inty
    const int T_DELTA_NUM = 5;//atoi(t_delta);
    84fc:	e3a03005 	mov	r3, #5
    8500:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/userspace/model_task/main.cpp:106
    const int T_PRED_NUM = 15;//atoi(t_pred);
    8504:	e3a0300f 	mov	r3, #15
    8508:	e50b301c 	str	r3, [fp, #-28]	; 0xffffffe4
/home/trefil/sem/sources/userspace/model_task/main.cpp:109

    //trida ktera v podstate obaluje hlavni vypocet a interakci s uzivatelem
    m = new Model(T_DELTA_NUM,T_PRED_NUM,POPULATION_COUNT,EPOCH_COUNT,DATA_WINDOW_SIZE);
    850c:	e3a0003c 	mov	r0, #60	; 0x3c
    8510:	eb00001e 	bl	8590 <_Znwj>
    8514:	e1a03000 	mov	r3, r0
    8518:	e1a04003 	mov	r4, r3
    851c:	e3a03014 	mov	r3, #20
    8520:	e58d3004 	str	r3, [sp, #4]
    8524:	e3a03032 	mov	r3, #50	; 0x32
    8528:	e58d3000 	str	r3, [sp]
    852c:	e3a03f7d 	mov	r3, #500	; 0x1f4
    8530:	e3a0200f 	mov	r2, #15
    8534:	e3a01005 	mov	r1, #5
    8538:	e1a00004 	mov	r0, r4
    853c:	eb00001f 	bl	85c0 <_ZN5ModelC1Eiiiii>
    8540:	e50b4020 	str	r4, [fp, #-32]	; 0xffffffe0
/home/trefil/sem/sources/userspace/model_task/main.cpp:111

    m->Set_Buffer(bfr);
    8544:	e51b1014 	ldr	r1, [fp, #-20]	; 0xffffffec
    8548:	e51b0020 	ldr	r0, [fp, #-32]	; 0xffffffe0
    854c:	eb0002bc 	bl	9044 <_ZN5Model10Set_BufferEP6Buffer>
/home/trefil/sem/sources/userspace/model_task/main.cpp:122
        bfr->Write_Line(tmp_str);
        bfr->Write_Line("\n");
    }
        */
//hlavni smycka programu
    m->Run();
    8550:	e51b0020 	ldr	r0, [fp, #-32]	; 0xffffffe0
    8554:	eb00043a 	bl	9644 <_ZN5Model3RunEv>
/home/trefil/sem/sources/userspace/model_task/main.cpp:125

    //sem bych nikdy nemel spadnout
    bfr->Write_Line("Single task konec, cauky mnauky\n");
    8558:	e59f102c 	ldr	r1, [pc, #44]	; 858c <main+0x140>
    855c:	e51b0014 	ldr	r0, [fp, #-20]	; 0xffffffec
    8560:	eb0006c2 	bl	a070 <_ZN6Buffer10Write_LineEPKc>
/home/trefil/sem/sources/userspace/model_task/main.cpp:126
    close(uart_file);
    8564:	e51b0010 	ldr	r0, [fp, #-16]
    8568:	eb0007c6 	bl	a488 <_Z5closej>
/home/trefil/sem/sources/userspace/model_task/main.cpp:131

    /**
     * todo free pameti neumim
     */
    return 0;
    856c:	e3a03000 	mov	r3, #0
/home/trefil/sem/sources/userspace/model_task/main.cpp:133

}
    8570:	e1a00003 	mov	r0, r3
    8574:	e24bd008 	sub	sp, fp, #8
    8578:	e8bd8810 	pop	{r4, fp, pc}
    857c:	0000bef4 	strdeq	fp, [r0], -r4
    8580:	0000bf24 	andeq	fp, r0, r4, lsr #30
    8584:	0000bf34 	andeq	fp, r0, r4, lsr pc
    8588:	0000bf44 	andeq	fp, r0, r4, asr #30
    858c:	0000bf00 	andeq	fp, r0, r0, lsl #30

00008590 <_Znwj>:
_Znwj():
/home/trefil/sem/sources/userspace/../stdlib/include/memory.h:5
#pragma once
#include <Heap_Manager.h>
#include <hal/intdef.h>

inline void* operator new(uint32_t size){
    8590:	e92d4800 	push	{fp, lr}
    8594:	e28db004 	add	fp, sp, #4
    8598:	e24dd008 	sub	sp, sp, #8
    859c:	e50b0008 	str	r0, [fp, #-8]
/home/trefil/sem/sources/userspace/../stdlib/include/memory.h:6
    return h.Alloc(size);
    85a0:	e51b1008 	ldr	r1, [fp, #-8]
    85a4:	e59f0010 	ldr	r0, [pc, #16]	; 85bc <_Znwj+0x2c>
    85a8:	eb0005c9 	bl	9cd4 <_ZN12Heap_Manager5AllocEj>
    85ac:	e1a03000 	mov	r3, r0
/home/trefil/sem/sources/userspace/../stdlib/include/memory.h:7
}
    85b0:	e1a00003 	mov	r0, r3
    85b4:	e24bd004 	sub	sp, fp, #4
    85b8:	e8bd8800 	pop	{fp, pc}
    85bc:	0000c0dc 	ldrdeq	ip, [r0], -ip	; <UNPREDICTABLE>

000085c0 <_ZN5ModelC1Eiiiii>:
_ZN5ModelC2Eiiiii():
/home/trefil/sem/sources/userspace/Model/Model.cpp:3
#include <Model.h>

Model::Model(int t_delta, int t_pred,int population_count, int epoch_count, int window_size):
    85c0:	e92d4800 	push	{fp, lr}
    85c4:	e28db004 	add	fp, sp, #4
    85c8:	e24dd010 	sub	sp, sp, #16
    85cc:	e50b0008 	str	r0, [fp, #-8]
    85d0:	e50b100c 	str	r1, [fp, #-12]
    85d4:	e50b2010 	str	r2, [fp, #-16]
    85d8:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/userspace/Model/Model.cpp:8
t_delta(t_delta),
t_pred(t_pred),
population_count(population_count),
epoch_count(epoch_count),
window_size(window_size)
    85dc:	e51b3008 	ldr	r3, [fp, #-8]
    85e0:	e51b200c 	ldr	r2, [fp, #-12]
    85e4:	e5832000 	str	r2, [r3]
    85e8:	e51b3008 	ldr	r3, [fp, #-8]
    85ec:	e51b2010 	ldr	r2, [fp, #-16]
    85f0:	e5832004 	str	r2, [r3, #4]
    85f4:	e51b3008 	ldr	r3, [fp, #-8]
    85f8:	e3e02004 	mvn	r2, #4
    85fc:	e5832008 	str	r2, [r3, #8]
    8600:	e51b3008 	ldr	r3, [fp, #-8]
    8604:	e3a02005 	mov	r2, #5
    8608:	e583200c 	str	r2, [r3, #12]
    860c:	e51b3008 	ldr	r3, [fp, #-8]
    8610:	e59b2008 	ldr	r2, [fp, #8]
    8614:	e5832010 	str	r2, [r3, #16]
    8618:	e51b3008 	ldr	r3, [fp, #-8]
    861c:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    8620:	e5832014 	str	r2, [r3, #20]
    8624:	e51b3008 	ldr	r3, [fp, #-8]
    8628:	e3a02000 	mov	r2, #0
    862c:	e5c32018 	strb	r2, [r3, #24]
    8630:	e51b3008 	ldr	r3, [fp, #-8]
    8634:	e59b2004 	ldr	r2, [fp, #4]
    8638:	e5832020 	str	r2, [r3, #32]
    863c:	e51b3008 	ldr	r3, [fp, #-8]
    8640:	e3a02000 	mov	r2, #0
    8644:	e5832024 	str	r2, [r3, #36]	; 0x24
    8648:	e51b3008 	ldr	r3, [fp, #-8]
    864c:	e3a02000 	mov	r2, #0
    8650:	e5832028 	str	r2, [r3, #40]	; 0x28
    8654:	e51b3008 	ldr	r3, [fp, #-8]
    8658:	e3a02000 	mov	r2, #0
    865c:	e583202c 	str	r2, [r3, #44]	; 0x2c
    8660:	e51b3008 	ldr	r3, [fp, #-8]
    8664:	e59f2030 	ldr	r2, [pc, #48]	; 869c <_ZN5ModelC1Eiiiii+0xdc>
    8668:	e5832034 	str	r2, [r3, #52]	; 0x34
    866c:	e51b3008 	ldr	r3, [fp, #-8]
    8670:	e3a02000 	mov	r2, #0
    8674:	e5832038 	str	r2, [r3, #56]	; 0x38
/home/trefil/sem/sources/userspace/Model/Model.cpp:11
{
    //alokuj pamet na halde po struktury, ktere potrebuji
    Init();
    8678:	e51b0008 	ldr	r0, [fp, #-8]
    867c:	eb0001a0 	bl	8d04 <_ZN5Model4InitEv>
/home/trefil/sem/sources/userspace/Model/Model.cpp:12
    data_pointer = 0;
    8680:	e51b3008 	ldr	r3, [fp, #-8]
    8684:	e3a02000 	mov	r2, #0
    8688:	e583201c 	str	r2, [r3, #28]
/home/trefil/sem/sources/userspace/Model/Model.cpp:13
};
    868c:	e51b3008 	ldr	r3, [fp, #-8]
    8690:	e1a00003 	mov	r0, r3
    8694:	e24bd004 	sub	sp, fp, #4
    8698:	e8bd8800 	pop	{fp, pc}
    869c:	3e4ccccd 	cdpcc	12, 4, cr12, cr12, cr13, {6}

000086a0 <_ZN5Model6Calc_BEfff>:
_ZN5Model6Calc_BEfff():
/home/trefil/sem/sources/userspace/Model/Model.cpp:15

float Model::Calc_B(float D, float E, float y){
    86a0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    86a4:	e28db000 	add	fp, sp, #0
    86a8:	e24dd014 	sub	sp, sp, #20
    86ac:	e50b0008 	str	r0, [fp, #-8]
    86b0:	ed0b0a03 	vstr	s0, [fp, #-12]
    86b4:	ed4b0a04 	vstr	s1, [fp, #-16]
    86b8:	ed0b1a05 	vstr	s2, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/userspace/Model/Model.cpp:16
    return (D / E) * derivative_value + (1.0/E) * y;
    86bc:	ed5b6a03 	vldr	s13, [fp, #-12]
    86c0:	ed1b7a04 	vldr	s14, [fp, #-16]
    86c4:	eec67a87 	vdiv.f32	s15, s13, s14
    86c8:	ed9f7a10 	vldr	s14, [pc, #64]	; 8710 <_ZN5Model6Calc_BEfff+0x70>
    86cc:	ee677a87 	vmul.f32	s15, s15, s14
    86d0:	eeb76ae7 	vcvt.f64.f32	d6, s15
    86d4:	ed5b7a04 	vldr	s15, [fp, #-16]
    86d8:	eeb77ae7 	vcvt.f64.f32	d7, s15
    86dc:	ed9f4b09 	vldr	d4, [pc, #36]	; 8708 <_ZN5Model6Calc_BEfff+0x68>
    86e0:	ee845b07 	vdiv.f64	d5, d4, d7
    86e4:	ed5b7a05 	vldr	s15, [fp, #-20]	; 0xffffffec
    86e8:	eeb77ae7 	vcvt.f64.f32	d7, s15
    86ec:	ee257b07 	vmul.f64	d7, d5, d7
    86f0:	ee367b07 	vadd.f64	d7, d6, d7
    86f4:	eef77bc7 	vcvt.f32.f64	s15, d7
/home/trefil/sem/sources/userspace/Model/Model.cpp:17
}
    86f8:	eeb00a67 	vmov.f32	s0, s15
    86fc:	e28bd000 	add	sp, fp, #0
    8700:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8704:	e12fff1e 	bx	lr
    8708:	00000000 	andeq	r0, r0, r0
    870c:	3ff00000 	svccc	0x00f00000	; IMB
    8710:	37422e45 	strbcc	r2, [r2, -r5, asr #28]

00008714 <_ZN5Model20Calculate_PredictionEPff>:
_ZN5Model20Calculate_PredictionEPff():
/home/trefil/sem/sources/userspace/Model/Model.cpp:22


//parameters - parametry clena populace, y - hodnota v case t
//vysledek je hodnota v case t+t_pred
float Model::Calculate_Prediction(float* parameters, float y){
    8714:	e92d4800 	push	{fp, lr}
    8718:	e28db004 	add	fp, sp, #4
    871c:	e24dd030 	sub	sp, sp, #48	; 0x30
    8720:	e50b0028 	str	r0, [fp, #-40]	; 0xffffffd8
    8724:	e50b102c 	str	r1, [fp, #-44]	; 0xffffffd4
    8728:	ed0b0a0c 	vstr	s0, [fp, #-48]	; 0xffffffd0
/home/trefil/sem/sources/userspace/Model/Model.cpp:23
    float A = parameters[0];
    872c:	e51b302c 	ldr	r3, [fp, #-44]	; 0xffffffd4
    8730:	e5933000 	ldr	r3, [r3]
    8734:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/userspace/Model/Model.cpp:24
    float B = parameters[1];
    8738:	e51b302c 	ldr	r3, [fp, #-44]	; 0xffffffd4
    873c:	e5933004 	ldr	r3, [r3, #4]
    8740:	e50b300c 	str	r3, [fp, #-12]
/home/trefil/sem/sources/userspace/Model/Model.cpp:25
    float C = parameters[2];
    8744:	e51b302c 	ldr	r3, [fp, #-44]	; 0xffffffd4
    8748:	e5933008 	ldr	r3, [r3, #8]
    874c:	e50b3010 	str	r3, [fp, #-16]
/home/trefil/sem/sources/userspace/Model/Model.cpp:26
    float D = parameters[3];
    8750:	e51b302c 	ldr	r3, [fp, #-44]	; 0xffffffd4
    8754:	e593300c 	ldr	r3, [r3, #12]
    8758:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/userspace/Model/Model.cpp:27
    float E = parameters[4];
    875c:	e51b302c 	ldr	r3, [fp, #-44]	; 0xffffffd4
    8760:	e5933010 	ldr	r3, [r3, #16]
    8764:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/userspace/Model/Model.cpp:29

    float b_t = Calc_B(D,E,y);
    8768:	ed1b1a0c 	vldr	s2, [fp, #-48]	; 0xffffffd0
    876c:	ed5b0a06 	vldr	s1, [fp, #-24]	; 0xffffffe8
    8770:	ed1b0a05 	vldr	s0, [fp, #-20]	; 0xffffffec
    8774:	e51b0028 	ldr	r0, [fp, #-40]	; 0xffffffd8
    8778:	ebffffc8 	bl	86a0 <_ZN5Model6Calc_BEfff>
    877c:	ed0b0a07 	vstr	s0, [fp, #-28]	; 0xffffffe4
/home/trefil/sem/sources/userspace/Model/Model.cpp:30
    float y_predicted = A * b_t + B * b_t * (b_t - y) + C;
    8780:	ed1b7a02 	vldr	s14, [fp, #-8]
    8784:	ed5b7a07 	vldr	s15, [fp, #-28]	; 0xffffffe4
    8788:	ee277a27 	vmul.f32	s14, s14, s15
    878c:	ed5b6a03 	vldr	s13, [fp, #-12]
    8790:	ed5b7a07 	vldr	s15, [fp, #-28]	; 0xffffffe4
    8794:	ee666aa7 	vmul.f32	s13, s13, s15
    8798:	ed1b6a07 	vldr	s12, [fp, #-28]	; 0xffffffe4
    879c:	ed5b7a0c 	vldr	s15, [fp, #-48]	; 0xffffffd0
    87a0:	ee767a67 	vsub.f32	s15, s12, s15
    87a4:	ee667aa7 	vmul.f32	s15, s13, s15
    87a8:	ee777a27 	vadd.f32	s15, s14, s15
    87ac:	ed1b7a04 	vldr	s14, [fp, #-16]
    87b0:	ee777a27 	vadd.f32	s15, s14, s15
    87b4:	ed4b7a08 	vstr	s15, [fp, #-32]	; 0xffffffe0
/home/trefil/sem/sources/userspace/Model/Model.cpp:31
    return y_predicted;
    87b8:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    87bc:	ee073a90 	vmov	s15, r3
/home/trefil/sem/sources/userspace/Model/Model.cpp:32
}
    87c0:	eeb00a67 	vmov.f32	s0, s15
    87c4:	e24bd004 	sub	sp, fp, #4
    87c8:	e8bd8800 	pop	{fp, pc}

000087cc <_ZN5Model7PredictEP9Tribesman>:
_ZN5Model7PredictEP9Tribesman():
/home/trefil/sem/sources/userspace/Model/Model.cpp:36


//predikce od borce
void Model::Predict(Tribesman* tribesman){
    87cc:	e92d4800 	push	{fp, lr}
    87d0:	e28db004 	add	fp, sp, #4
    87d4:	e24dd010 	sub	sp, sp, #16
    87d8:	e50b0010 	str	r0, [fp, #-16]
    87dc:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/userspace/Model/Model.cpp:39
    //pro vsechna data, ktera mam udelej predikci
    //tedy pro vsechna y(t) vypocti y(t+t_pred)
    for(int i = 0; i < data_pointer; i++){
    87e0:	e3a03000 	mov	r3, #0
    87e4:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/userspace/Model/Model.cpp:39 (discriminator 3)
    87e8:	e51b3010 	ldr	r3, [fp, #-16]
    87ec:	e593301c 	ldr	r3, [r3, #28]
    87f0:	e51b2008 	ldr	r2, [fp, #-8]
    87f4:	e1520003 	cmp	r2, r3
    87f8:	aa000015 	bge	8854 <_ZN5Model7PredictEP9Tribesman+0x88>
/home/trefil/sem/sources/userspace/Model/Model.cpp:40 (discriminator 2)
        float prediction = Calculate_Prediction(tribesman->parameters,this->data[i]);
    87fc:	e51b1014 	ldr	r1, [fp, #-20]	; 0xffffffec
    8800:	e51b3010 	ldr	r3, [fp, #-16]
    8804:	e5932038 	ldr	r2, [r3, #56]	; 0x38
    8808:	e51b3008 	ldr	r3, [fp, #-8]
    880c:	e1a03103 	lsl	r3, r3, #2
    8810:	e0823003 	add	r3, r2, r3
    8814:	edd37a00 	vldr	s15, [r3]
    8818:	eeb00a67 	vmov.f32	s0, s15
    881c:	e51b0010 	ldr	r0, [fp, #-16]
    8820:	ebffffbb 	bl	8714 <_ZN5Model20Calculate_PredictionEPff>
    8824:	ed0b0a03 	vstr	s0, [fp, #-12]
/home/trefil/sem/sources/userspace/Model/Model.cpp:41 (discriminator 2)
        tribesman->predicted_values[i] = prediction;
    8828:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    882c:	e5932018 	ldr	r2, [r3, #24]
    8830:	e51b3008 	ldr	r3, [fp, #-8]
    8834:	e1a03103 	lsl	r3, r3, #2
    8838:	e0823003 	add	r3, r2, r3
    883c:	e51b200c 	ldr	r2, [fp, #-12]
    8840:	e5832000 	str	r2, [r3]
/home/trefil/sem/sources/userspace/Model/Model.cpp:39 (discriminator 2)
    for(int i = 0; i < data_pointer; i++){
    8844:	e51b3008 	ldr	r3, [fp, #-8]
    8848:	e2833001 	add	r3, r3, #1
    884c:	e50b3008 	str	r3, [fp, #-8]
    8850:	eaffffe4 	b	87e8 <_ZN5Model7PredictEP9Tribesman+0x1c>
/home/trefil/sem/sources/userspace/Model/Model.cpp:43
    }
}
    8854:	e320f000 	nop	{0}
    8858:	e24bd004 	sub	sp, fp, #4
    885c:	e8bd8800 	pop	{fp, pc}

00008860 <_ZN5Model17Calculate_FitnessEP9Tribesman>:
_ZN5Model17Calculate_FitnessEP9Tribesman():
/home/trefil/sem/sources/userspace/Model/Model.cpp:47
//vypocitnej fitness clena populace
//cim vyssi fitness, tim hur na tom
//fitness funkce je prumerna vzdalenost predikce od spravne hodnoty
float Model::Calculate_Fitness(Tribesman* tribesman){
    8860:	e92d4800 	push	{fp, lr}
    8864:	e28db004 	add	fp, sp, #4
    8868:	e24dd028 	sub	sp, sp, #40	; 0x28
    886c:	e50b0028 	str	r0, [fp, #-40]	; 0xffffffd8
    8870:	e50b102c 	str	r1, [fp, #-44]	; 0xffffffd4
/home/trefil/sem/sources/userspace/Model/Model.cpp:49
    //predikovana hodnota na indexu i ve skutecnych datech lezi na indexu i + time_shift
    int time_shift = t_pred / t_delta;
    8874:	e51b3028 	ldr	r3, [fp, #-40]	; 0xffffffd8
    8878:	e5932004 	ldr	r2, [r3, #4]
    887c:	e51b3028 	ldr	r3, [fp, #-40]	; 0xffffffd8
    8880:	e5933000 	ldr	r3, [r3]
    8884:	e1a01003 	mov	r1, r3
    8888:	e1a00002 	mov	r0, r2
    888c:	eb000b4d 	bl	b5c8 <__divsi3>
    8890:	e1a03000 	mov	r3, r0
    8894:	e50b3010 	str	r3, [fp, #-16]
/home/trefil/sem/sources/userspace/Model/Model.cpp:50
    float fitness = 0;
    8898:	e3a03000 	mov	r3, #0
    889c:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/userspace/Model/Model.cpp:51
    float diff = 0;
    88a0:	e3a03000 	mov	r3, #0
    88a4:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/userspace/Model/Model.cpp:54
    int i;

    for(i = 0; i < window_size; i++){
    88a8:	e3a03000 	mov	r3, #0
    88ac:	e50b300c 	str	r3, [fp, #-12]
/home/trefil/sem/sources/userspace/Model/Model.cpp:54 (discriminator 1)
    88b0:	e51b3028 	ldr	r3, [fp, #-40]	; 0xffffffd8
    88b4:	e5933010 	ldr	r3, [r3, #16]
    88b8:	e51b200c 	ldr	r2, [fp, #-12]
    88bc:	e1520003 	cmp	r2, r3
    88c0:	aa000028 	bge	8968 <_ZN5Model17Calculate_FitnessEP9Tribesman+0x108>
/home/trefil/sem/sources/userspace/Model/Model.cpp:55
        float y_predicted = tribesman->predicted_values[i];
    88c4:	e51b302c 	ldr	r3, [fp, #-44]	; 0xffffffd4
    88c8:	e5932018 	ldr	r2, [r3, #24]
    88cc:	e51b300c 	ldr	r3, [fp, #-12]
    88d0:	e1a03103 	lsl	r3, r3, #2
    88d4:	e0823003 	add	r3, r2, r3
    88d8:	e5933000 	ldr	r3, [r3]
    88dc:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/userspace/Model/Model.cpp:56
        int index = i + time_shift;
    88e0:	e51b200c 	ldr	r2, [fp, #-12]
    88e4:	e51b3010 	ldr	r3, [fp, #-16]
    88e8:	e0823003 	add	r3, r2, r3
    88ec:	e50b301c 	str	r3, [fp, #-28]	; 0xffffffe4
/home/trefil/sem/sources/userspace/Model/Model.cpp:59
        //data od tohoto bodu jeste nemame k dispozici -> nemuzeme je pouzit pro fitness funkci
        //nebo nemame nic napocitano
        if(index >= data_pointer)break;
    88f0:	e51b3028 	ldr	r3, [fp, #-40]	; 0xffffffd8
    88f4:	e593301c 	ldr	r3, [r3, #28]
    88f8:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    88fc:	e1520003 	cmp	r2, r3
    8900:	aa000017 	bge	8964 <_ZN5Model17Calculate_FitnessEP9Tribesman+0x104>
/home/trefil/sem/sources/userspace/Model/Model.cpp:60 (discriminator 2)
        float y = this->data[index];
    8904:	e51b3028 	ldr	r3, [fp, #-40]	; 0xffffffd8
    8908:	e5932038 	ldr	r2, [r3, #56]	; 0x38
    890c:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8910:	e1a03103 	lsl	r3, r3, #2
    8914:	e0823003 	add	r3, r2, r3
    8918:	e5933000 	ldr	r3, [r3]
    891c:	e50b3020 	str	r3, [fp, #-32]	; 0xffffffe0
/home/trefil/sem/sources/userspace/Model/Model.cpp:63 (discriminator 2)
        //pricti rozdil ctvercu
        //diff += y_predicted - y;
        diff += (y_predicted*y_predicted) - 2 * (y_predicted*y) + (y*y);
    8920:	ed5b7a06 	vldr	s15, [fp, #-24]	; 0xffffffe8
    8924:	ee277aa7 	vmul.f32	s14, s15, s15
    8928:	ed5b6a06 	vldr	s13, [fp, #-24]	; 0xffffffe8
    892c:	ed5b7a08 	vldr	s15, [fp, #-32]	; 0xffffffe0
    8930:	ee667aa7 	vmul.f32	s15, s13, s15
    8934:	ee777aa7 	vadd.f32	s15, s15, s15
    8938:	ee377a67 	vsub.f32	s14, s14, s15
    893c:	ed5b7a08 	vldr	s15, [fp, #-32]	; 0xffffffe0
    8940:	ee677aa7 	vmul.f32	s15, s15, s15
    8944:	ee777a27 	vadd.f32	s15, s14, s15
    8948:	ed1b7a02 	vldr	s14, [fp, #-8]
    894c:	ee777a27 	vadd.f32	s15, s14, s15
    8950:	ed4b7a02 	vstr	s15, [fp, #-8]
/home/trefil/sem/sources/userspace/Model/Model.cpp:54 (discriminator 2)
    for(i = 0; i < window_size; i++){
    8954:	e51b300c 	ldr	r3, [fp, #-12]
    8958:	e2833001 	add	r3, r3, #1
    895c:	e50b300c 	str	r3, [fp, #-12]
    8960:	eaffffd2 	b	88b0 <_ZN5Model17Calculate_FitnessEP9Tribesman+0x50>
/home/trefil/sem/sources/userspace/Model/Model.cpp:59
        if(index >= data_pointer)break;
    8964:	e320f000 	nop	{0}
/home/trefil/sem/sources/userspace/Model/Model.cpp:66
    }
    //zajima nas absolutni chyba
    if(diff < 0)
    8968:	ed5b7a02 	vldr	s15, [fp, #-8]
    896c:	eef57ac0 	vcmpe.f32	s15, #0.0
    8970:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    8974:	5a000002 	bpl	8984 <_ZN5Model17Calculate_FitnessEP9Tribesman+0x124>
/home/trefil/sem/sources/userspace/Model/Model.cpp:67
        diff = -diff;
    8978:	ed5b7a02 	vldr	s15, [fp, #-8]
    897c:	eef17a67 	vneg.f32	s15, s15
    8980:	ed4b7a02 	vstr	s15, [fp, #-8]
/home/trefil/sem/sources/userspace/Model/Model.cpp:71
    //aritmeticky prumer
    //pokud jej mame z ceho vypocitat
    //pokud nemame, vrat empty -> nemam dost dat na to, abych vyhodnotil spravnost clena populace
    if(i == 0 ) return EMPTY;
    8984:	e51b300c 	ldr	r3, [fp, #-12]
    8988:	e3530000 	cmp	r3, #0
    898c:	1a000001 	bne	8998 <_ZN5Model17Calculate_FitnessEP9Tribesman+0x138>
/home/trefil/sem/sources/userspace/Model/Model.cpp:71 (discriminator 1)
    8990:	e59f302c 	ldr	r3, [pc, #44]	; 89c4 <_ZN5Model17Calculate_FitnessEP9Tribesman+0x164>
    8994:	ea000006 	b	89b4 <_ZN5Model17Calculate_FitnessEP9Tribesman+0x154>
/home/trefil/sem/sources/userspace/Model/Model.cpp:73
    //aritmeticky prumer sumy rozdilu actual_y - predicted_y
    fitness = (float)diff / i;
    8998:	e51b300c 	ldr	r3, [fp, #-12]
    899c:	ee073a90 	vmov	s15, r3
    89a0:	eeb87ae7 	vcvt.f32.s32	s14, s15
    89a4:	ed5b6a02 	vldr	s13, [fp, #-8]
    89a8:	eec67a87 	vdiv.f32	s15, s13, s14
    89ac:	ed4b7a05 	vstr	s15, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/userspace/Model/Model.cpp:74
    return fitness;
    89b0:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/userspace/Model/Model.cpp:75
}
    89b4:	ee073a90 	vmov	s15, r3
    89b8:	eeb00a67 	vmov.f32	s0, s15
    89bc:	e24bd004 	sub	sp, fp, #4
    89c0:	e8bd8800 	pop	{fp, pc}
    89c4:	c2280000 	eorgt	r0, r8, #0

000089c8 <_ZN5Model16First_GenerationEv>:
_ZN5Model16First_GenerationEv():
/home/trefil/sem/sources/userspace/Model/Model.cpp:80


//inicializace hodnot tribesmanu
//tedy randomizace parametru A,B,C,D,E
void Model::First_Generation(){
    89c8:	e92d4800 	push	{fp, lr}
    89cc:	e28db004 	add	fp, sp, #4
    89d0:	e24dd018 	sub	sp, sp, #24
    89d4:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/userspace/Model/Model.cpp:81
    for(int i = 0; i < population_count; i++){
    89d8:	e3a03000 	mov	r3, #0
    89dc:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/userspace/Model/Model.cpp:81 (discriminator 1)
    89e0:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    89e4:	e5933014 	ldr	r3, [r3, #20]
    89e8:	e51b2008 	ldr	r2, [fp, #-8]
    89ec:	e1520003 	cmp	r2, r3
    89f0:	aa00002f 	bge	8ab4 <_ZN5Model16First_GenerationEv+0xec>
/home/trefil/sem/sources/userspace/Model/Model.cpp:82
        Tribesman* tribesman = this->population[i];
    89f4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    89f8:	e5932024 	ldr	r2, [r3, #36]	; 0x24
    89fc:	e51b3008 	ldr	r3, [fp, #-8]
    8a00:	e1a03103 	lsl	r3, r3, #2
    8a04:	e0823003 	add	r3, r2, r3
    8a08:	e5933000 	ldr	r3, [r3]
    8a0c:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/userspace/Model/Model.cpp:84
        //pseudorandom parametry A...E
        for(int j = 0; j < PARAMETER_COUNT; j++)
    8a10:	e3a03000 	mov	r3, #0
    8a14:	e50b300c 	str	r3, [fp, #-12]
/home/trefil/sem/sources/userspace/Model/Model.cpp:84 (discriminator 3)
    8a18:	e51b300c 	ldr	r3, [fp, #-12]
    8a1c:	e3530004 	cmp	r3, #4
    8a20:	ca00000d 	bgt	8a5c <_ZN5Model16First_GenerationEv+0x94>
/home/trefil/sem/sources/userspace/Model/Model.cpp:85 (discriminator 2)
            tribesman->parameters[j] = this->random->Get_Float();
    8a24:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8a28:	e593302c 	ldr	r3, [r3, #44]	; 0x2c
    8a2c:	e1a00003 	mov	r0, r3
    8a30:	eb000524 	bl	9ec8 <_ZN16Random_Generator9Get_FloatEv>
    8a34:	eef07a40 	vmov.f32	s15, s0
    8a38:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    8a3c:	e51b300c 	ldr	r3, [fp, #-12]
    8a40:	e1a03103 	lsl	r3, r3, #2
    8a44:	e0823003 	add	r3, r2, r3
    8a48:	edc37a00 	vstr	s15, [r3]
/home/trefil/sem/sources/userspace/Model/Model.cpp:84 (discriminator 2)
        for(int j = 0; j < PARAMETER_COUNT; j++)
    8a4c:	e51b300c 	ldr	r3, [fp, #-12]
    8a50:	e2833001 	add	r3, r3, #1
    8a54:	e50b300c 	str	r3, [fp, #-12]
    8a58:	eaffffee 	b	8a18 <_ZN5Model16First_GenerationEv+0x50>
/home/trefil/sem/sources/userspace/Model/Model.cpp:87
        //nic jeste neni predikovano
        for(int j = 0; j < window_size; j++)
    8a5c:	e3a03000 	mov	r3, #0
    8a60:	e50b3010 	str	r3, [fp, #-16]
/home/trefil/sem/sources/userspace/Model/Model.cpp:87 (discriminator 3)
    8a64:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8a68:	e5933010 	ldr	r3, [r3, #16]
    8a6c:	e51b2010 	ldr	r2, [fp, #-16]
    8a70:	e1520003 	cmp	r2, r3
    8a74:	aa00000a 	bge	8aa4 <_ZN5Model16First_GenerationEv+0xdc>
/home/trefil/sem/sources/userspace/Model/Model.cpp:88 (discriminator 2)
            tribesman->predicted_values[j] = EMPTY;
    8a78:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8a7c:	e5932018 	ldr	r2, [r3, #24]
    8a80:	e51b3010 	ldr	r3, [fp, #-16]
    8a84:	e1a03103 	lsl	r3, r3, #2
    8a88:	e0823003 	add	r3, r2, r3
    8a8c:	e59f202c 	ldr	r2, [pc, #44]	; 8ac0 <_ZN5Model16First_GenerationEv+0xf8>
    8a90:	e5832000 	str	r2, [r3]
/home/trefil/sem/sources/userspace/Model/Model.cpp:87 (discriminator 2)
        for(int j = 0; j < window_size; j++)
    8a94:	e51b3010 	ldr	r3, [fp, #-16]
    8a98:	e2833001 	add	r3, r3, #1
    8a9c:	e50b3010 	str	r3, [fp, #-16]
    8aa0:	eaffffef 	b	8a64 <_ZN5Model16First_GenerationEv+0x9c>
/home/trefil/sem/sources/userspace/Model/Model.cpp:81 (discriminator 2)
    for(int i = 0; i < population_count; i++){
    8aa4:	e51b3008 	ldr	r3, [fp, #-8]
    8aa8:	e2833001 	add	r3, r3, #1
    8aac:	e50b3008 	str	r3, [fp, #-8]
    8ab0:	eaffffca 	b	89e0 <_ZN5Model16First_GenerationEv+0x18>
/home/trefil/sem/sources/userspace/Model/Model.cpp:90
    }
}
    8ab4:	e320f000 	nop	{0}
    8ab8:	e24bd004 	sub	sp, fp, #4
    8abc:	e8bd8800 	pop	{fp, pc}
    8ac0:	c2280000 	eorgt	r0, r8, #0

00008ac4 <_ZN5Model9Set_AlphaEP9Tribesman>:
_ZN5Model9Set_AlphaEP9Tribesman():
/home/trefil/sem/sources/userspace/Model/Model.cpp:93
//prekopiruj @param t do @param this->alpha
//na konci epochy ulozime nejlepsiho z generace
void Model::Set_Alpha(Tribesman* t){
    8ac4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8ac8:	e28db000 	add	fp, sp, #0
    8acc:	e24dd014 	sub	sp, sp, #20
    8ad0:	e50b0010 	str	r0, [fp, #-16]
    8ad4:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/userspace/Model/Model.cpp:94
    for(int i = 0; i < PARAMETER_COUNT; i++)
    8ad8:	e3a03000 	mov	r3, #0
    8adc:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/userspace/Model/Model.cpp:94 (discriminator 3)
    8ae0:	e51b3008 	ldr	r3, [fp, #-8]
    8ae4:	e3530004 	cmp	r3, #4
    8ae8:	ca00000e 	bgt	8b28 <_ZN5Model9Set_AlphaEP9Tribesman+0x64>
/home/trefil/sem/sources/userspace/Model/Model.cpp:95 (discriminator 2)
        this->alpha->parameters[i] = t->parameters[i];
    8aec:	e51b3010 	ldr	r3, [fp, #-16]
    8af0:	e5931028 	ldr	r1, [r3, #40]	; 0x28
    8af4:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    8af8:	e51b3008 	ldr	r3, [fp, #-8]
    8afc:	e1a03103 	lsl	r3, r3, #2
    8b00:	e0823003 	add	r3, r2, r3
    8b04:	e5932000 	ldr	r2, [r3]
    8b08:	e51b3008 	ldr	r3, [fp, #-8]
    8b0c:	e1a03103 	lsl	r3, r3, #2
    8b10:	e0813003 	add	r3, r1, r3
    8b14:	e5832000 	str	r2, [r3]
/home/trefil/sem/sources/userspace/Model/Model.cpp:94 (discriminator 2)
    for(int i = 0; i < PARAMETER_COUNT; i++)
    8b18:	e51b3008 	ldr	r3, [fp, #-8]
    8b1c:	e2833001 	add	r3, r3, #1
    8b20:	e50b3008 	str	r3, [fp, #-8]
    8b24:	eaffffed 	b	8ae0 <_ZN5Model9Set_AlphaEP9Tribesman+0x1c>
/home/trefil/sem/sources/userspace/Model/Model.cpp:96
    for(int i = 0; i < window_size; i++)
    8b28:	e3a03000 	mov	r3, #0
    8b2c:	e50b300c 	str	r3, [fp, #-12]
/home/trefil/sem/sources/userspace/Model/Model.cpp:96 (discriminator 3)
    8b30:	e51b3010 	ldr	r3, [fp, #-16]
    8b34:	e5933010 	ldr	r3, [r3, #16]
    8b38:	e51b200c 	ldr	r2, [fp, #-12]
    8b3c:	e1520003 	cmp	r2, r3
    8b40:	aa000010 	bge	8b88 <_ZN5Model9Set_AlphaEP9Tribesman+0xc4>
/home/trefil/sem/sources/userspace/Model/Model.cpp:97 (discriminator 2)
        this->alpha->predicted_values[i] = t->predicted_values[i];
    8b44:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8b48:	e5932018 	ldr	r2, [r3, #24]
    8b4c:	e51b300c 	ldr	r3, [fp, #-12]
    8b50:	e1a03103 	lsl	r3, r3, #2
    8b54:	e0822003 	add	r2, r2, r3
    8b58:	e51b3010 	ldr	r3, [fp, #-16]
    8b5c:	e5933028 	ldr	r3, [r3, #40]	; 0x28
    8b60:	e5931018 	ldr	r1, [r3, #24]
    8b64:	e51b300c 	ldr	r3, [fp, #-12]
    8b68:	e1a03103 	lsl	r3, r3, #2
    8b6c:	e0813003 	add	r3, r1, r3
    8b70:	e5922000 	ldr	r2, [r2]
    8b74:	e5832000 	str	r2, [r3]
/home/trefil/sem/sources/userspace/Model/Model.cpp:96 (discriminator 2)
    for(int i = 0; i < window_size; i++)
    8b78:	e51b300c 	ldr	r3, [fp, #-12]
    8b7c:	e2833001 	add	r3, r3, #1
    8b80:	e50b300c 	str	r3, [fp, #-12]
    8b84:	eaffffe9 	b	8b30 <_ZN5Model9Set_AlphaEP9Tribesman+0x6c>
/home/trefil/sem/sources/userspace/Model/Model.cpp:98
    this->alpha->fitness = t->fitness;
    8b88:	e51b3010 	ldr	r3, [fp, #-16]
    8b8c:	e5933028 	ldr	r3, [r3, #40]	; 0x28
    8b90:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    8b94:	e5922014 	ldr	r2, [r2, #20]
    8b98:	e5832014 	str	r2, [r3, #20]
/home/trefil/sem/sources/userspace/Model/Model.cpp:99
}
    8b9c:	e320f000 	nop	{0}
    8ba0:	e28bd000 	add	sp, fp, #0
    8ba4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8ba8:	e12fff1e 	bx	lr

00008bac <_ZN5Model16Print_ParametersEv>:
_ZN5Model16Print_ParametersEv():
/home/trefil/sem/sources/userspace/Model/Model.cpp:102
//vypise parametry nejlepsiho
//tedy @attribute Alpha clena populace
void Model::Print_Parameters(){
    8bac:	e92d4800 	push	{fp, lr}
    8bb0:	e28db004 	add	fp, sp, #4
    8bb4:	e24dd0c0 	sub	sp, sp, #192	; 0xc0
    8bb8:	e50b00c0 	str	r0, [fp, #-192]	; 0xffffff40
/home/trefil/sem/sources/userspace/Model/Model.cpp:104
    //nejaky dostatecny velky buffer pro nase potreby
    char temp_buffer[128] = {0};
    8bbc:	e3a03000 	mov	r3, #0
    8bc0:	e50b3090 	str	r3, [fp, #-144]	; 0xffffff70
    8bc4:	e24b308c 	sub	r3, fp, #140	; 0x8c
    8bc8:	e3a0207c 	mov	r2, #124	; 0x7c
    8bcc:	e3a01000 	mov	r1, #0
    8bd0:	e1a00003 	mov	r0, r3
    8bd4:	eb000c39 	bl	bcc0 <memset>
/home/trefil/sem/sources/userspace/Model/Model.cpp:105
    char params[PARAMETER_COUNT][PARAMETER_COUNT] = {"A = ","B = ","C = ","D = ", "E = "};
    8bd8:	e59f3118 	ldr	r3, [pc, #280]	; 8cf8 <_ZN5Model16Print_ParametersEv+0x14c>
    8bdc:	e24bc0ac 	sub	ip, fp, #172	; 0xac
    8be0:	e1a0e003 	mov	lr, r3
    8be4:	e8be000f 	ldm	lr!, {r0, r1, r2, r3}
    8be8:	e8ac000f 	stmia	ip!, {r0, r1, r2, r3}
    8bec:	e89e0007 	ldm	lr, {r0, r1, r2}
    8bf0:	e8ac0003 	stmia	ip!, {r0, r1}
    8bf4:	e5cc2000 	strb	r2, [ip]
/home/trefil/sem/sources/userspace/Model/Model.cpp:106
    char temp_float_buffer[10] = {0};
    8bf8:	e3a03000 	mov	r3, #0
    8bfc:	e50b30b8 	str	r3, [fp, #-184]	; 0xffffff48
    8c00:	e24b30b4 	sub	r3, fp, #180	; 0xb4
    8c04:	e3a02000 	mov	r2, #0
    8c08:	e5832000 	str	r2, [r3]
    8c0c:	e1c320b4 	strh	r2, [r3, #4]
/home/trefil/sem/sources/userspace/Model/Model.cpp:107
    Tribesman* tmp = this->alpha;
    8c10:	e51b30c0 	ldr	r3, [fp, #-192]	; 0xffffff40
    8c14:	e5933028 	ldr	r3, [r3, #40]	; 0x28
    8c18:	e50b300c 	str	r3, [fp, #-12]
/home/trefil/sem/sources/userspace/Model/Model.cpp:109

    for(int i = 0; i < PARAMETER_COUNT; i++){
    8c1c:	e3a03000 	mov	r3, #0
    8c20:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/userspace/Model/Model.cpp:109 (discriminator 1)
    8c24:	e51b3008 	ldr	r3, [fp, #-8]
    8c28:	e3530004 	cmp	r3, #4
    8c2c:	ca000023 	bgt	8cc0 <_ZN5Model16Print_ParametersEv+0x114>
/home/trefil/sem/sources/userspace/Model/Model.cpp:110
        float f = tmp->parameters[i];
    8c30:	e51b200c 	ldr	r2, [fp, #-12]
    8c34:	e51b3008 	ldr	r3, [fp, #-8]
    8c38:	e1a03103 	lsl	r3, r3, #2
    8c3c:	e0823003 	add	r3, r2, r3
    8c40:	e5933000 	ldr	r3, [r3]
    8c44:	e50b3010 	str	r3, [fp, #-16]
/home/trefil/sem/sources/userspace/Model/Model.cpp:111
        ftoa(f,temp_float_buffer);
    8c48:	e24b30b8 	sub	r3, fp, #184	; 0xb8
    8c4c:	e1a00003 	mov	r0, r3
    8c50:	ed1b0a04 	vldr	s0, [fp, #-16]
    8c54:	eb00090e 	bl	b094 <_Z4ftoafPc>
/home/trefil/sem/sources/userspace/Model/Model.cpp:112
        strcat(temp_buffer,params[i]);
    8c58:	e24b10ac 	sub	r1, fp, #172	; 0xac
    8c5c:	e51b2008 	ldr	r2, [fp, #-8]
    8c60:	e1a03002 	mov	r3, r2
    8c64:	e1a03103 	lsl	r3, r3, #2
    8c68:	e0833002 	add	r3, r3, r2
    8c6c:	e0812003 	add	r2, r1, r3
    8c70:	e24b3090 	sub	r3, fp, #144	; 0x90
    8c74:	e1a01002 	mov	r1, r2
    8c78:	e1a00003 	mov	r0, r3
    8c7c:	eb00084f 	bl	adc0 <_Z6strcatPcPKc>
/home/trefil/sem/sources/userspace/Model/Model.cpp:113
        strcat(temp_buffer,temp_float_buffer);
    8c80:	e24b20b8 	sub	r2, fp, #184	; 0xb8
    8c84:	e24b3090 	sub	r3, fp, #144	; 0x90
    8c88:	e1a01002 	mov	r1, r2
    8c8c:	e1a00003 	mov	r0, r3
    8c90:	eb00084a 	bl	adc0 <_Z6strcatPcPKc>
/home/trefil/sem/sources/userspace/Model/Model.cpp:114
        if(i != PARAMETER_COUNT - 1)
    8c94:	e51b3008 	ldr	r3, [fp, #-8]
    8c98:	e3530004 	cmp	r3, #4
    8c9c:	0a000003 	beq	8cb0 <_ZN5Model16Print_ParametersEv+0x104>
/home/trefil/sem/sources/userspace/Model/Model.cpp:115
            strcat(temp_buffer,",");
    8ca0:	e24b3090 	sub	r3, fp, #144	; 0x90
    8ca4:	e59f1050 	ldr	r1, [pc, #80]	; 8cfc <_ZN5Model16Print_ParametersEv+0x150>
    8ca8:	e1a00003 	mov	r0, r3
    8cac:	eb000843 	bl	adc0 <_Z6strcatPcPKc>
/home/trefil/sem/sources/userspace/Model/Model.cpp:109 (discriminator 2)
    for(int i = 0; i < PARAMETER_COUNT; i++){
    8cb0:	e51b3008 	ldr	r3, [fp, #-8]
    8cb4:	e2833001 	add	r3, r3, #1
    8cb8:	e50b3008 	str	r3, [fp, #-8]
    8cbc:	eaffffd8 	b	8c24 <_ZN5Model16Print_ParametersEv+0x78>
/home/trefil/sem/sources/userspace/Model/Model.cpp:117
    }
    this->bfr->Write_Line(temp_buffer);
    8cc0:	e51b30c0 	ldr	r3, [fp, #-192]	; 0xffffff40
    8cc4:	e5933030 	ldr	r3, [r3, #48]	; 0x30
    8cc8:	e24b2090 	sub	r2, fp, #144	; 0x90
    8ccc:	e1a01002 	mov	r1, r2
    8cd0:	e1a00003 	mov	r0, r3
    8cd4:	eb0004e5 	bl	a070 <_ZN6Buffer10Write_LineEPKc>
/home/trefil/sem/sources/userspace/Model/Model.cpp:118
    this->bfr->Write_Line("\n");
    8cd8:	e51b30c0 	ldr	r3, [fp, #-192]	; 0xffffff40
    8cdc:	e5933030 	ldr	r3, [r3, #48]	; 0x30
    8ce0:	e59f1018 	ldr	r1, [pc, #24]	; 8d00 <_ZN5Model16Print_ParametersEv+0x154>
    8ce4:	e1a00003 	mov	r0, r3
    8ce8:	eb0004e0 	bl	a070 <_ZN6Buffer10Write_LineEPKc>
/home/trefil/sem/sources/userspace/Model/Model.cpp:121


}
    8cec:	e320f000 	nop	{0}
    8cf0:	e24bd004 	sub	sp, fp, #4
    8cf4:	e8bd8800 	pop	{fp, pc}
    8cf8:	0000bf80 	andeq	fp, r0, r0, lsl #31
    8cfc:	0000bf78 	andeq	fp, r0, r8, ror pc
    8d00:	0000bf7c 	andeq	fp, r0, ip, ror pc

00008d04 <_ZN5Model4InitEv>:
_ZN5Model4InitEv():
/home/trefil/sem/sources/userspace/Model/Model.cpp:123
// inicializuj populaci
void Model::Init() {
    8d04:	e92d4810 	push	{r4, fp, lr}
    8d08:	e28db008 	add	fp, sp, #8
    8d0c:	e24dd024 	sub	sp, sp, #36	; 0x24
    8d10:	e50b0020 	str	r0, [fp, #-32]	; 0xffffffe0
/home/trefil/sem/sources/userspace/Model/Model.cpp:124
    this->population = reinterpret_cast<Tribesman**>(malloc(sizeof(Tribesman*) * population_count));
    8d14:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8d18:	e5933014 	ldr	r3, [r3, #20]
    8d1c:	e1a03103 	lsl	r3, r3, #2
    8d20:	e1a00003 	mov	r0, r3
    8d24:	eb00030a 	bl	9954 <_Z6mallocj>
    8d28:	e1a02000 	mov	r2, r0
    8d2c:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8d30:	e5832024 	str	r2, [r3, #36]	; 0x24
/home/trefil/sem/sources/userspace/Model/Model.cpp:126

    for(int i = 0; i < population_count;i++){
    8d34:	e3a03000 	mov	r3, #0
    8d38:	e50b3010 	str	r3, [fp, #-16]
/home/trefil/sem/sources/userspace/Model/Model.cpp:126 (discriminator 1)
    8d3c:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8d40:	e5933014 	ldr	r3, [r3, #20]
    8d44:	e51b2010 	ldr	r2, [fp, #-16]
    8d48:	e1520003 	cmp	r2, r3
    8d4c:	aa000034 	bge	8e24 <_ZN5Model4InitEv+0x120>
/home/trefil/sem/sources/userspace/Model/Model.cpp:127
        this->population[i] = new Tribesman;//reinterpret_cast<Tribesman*>(malloc(sizeof(Tribesman)));
    8d50:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8d54:	e5932024 	ldr	r2, [r3, #36]	; 0x24
    8d58:	e51b3010 	ldr	r3, [fp, #-16]
    8d5c:	e1a03103 	lsl	r3, r3, #2
    8d60:	e0824003 	add	r4, r2, r3
    8d64:	e3a0001c 	mov	r0, #28
    8d68:	ebfffe08 	bl	8590 <_Znwj>
    8d6c:	e1a03000 	mov	r3, r0
    8d70:	e5843000 	str	r3, [r4]
/home/trefil/sem/sources/userspace/Model/Model.cpp:129
        //struktura pro predikovane hodnoty
        this->population[i]->predicted_values = new float[window_size];
    8d74:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8d78:	e5933010 	ldr	r3, [r3, #16]
    8d7c:	e373022e 	cmn	r3, #-536870910	; 0xe0000002
    8d80:	8a000001 	bhi	8d8c <_ZN5Model4InitEv+0x88>
/home/trefil/sem/sources/userspace/Model/Model.cpp:129 (discriminator 1)
    8d84:	e1a03103 	lsl	r3, r3, #2
    8d88:	ea000000 	b	8d90 <_ZN5Model4InitEv+0x8c>
/home/trefil/sem/sources/userspace/Model/Model.cpp:129 (discriminator 2)
    8d8c:	e3e03000 	mvn	r3, #0
/home/trefil/sem/sources/userspace/Model/Model.cpp:129 (discriminator 4)
    8d90:	e51b2020 	ldr	r2, [fp, #-32]	; 0xffffffe0
    8d94:	e5921024 	ldr	r1, [r2, #36]	; 0x24
    8d98:	e51b2010 	ldr	r2, [fp, #-16]
    8d9c:	e1a02102 	lsl	r2, r2, #2
    8da0:	e0812002 	add	r2, r1, r2
    8da4:	e5924000 	ldr	r4, [r2]
    8da8:	e1a00003 	mov	r0, r3
    8dac:	eb0002dc 	bl	9924 <_Znaj>
    8db0:	e1a03000 	mov	r3, r0
    8db4:	e5843018 	str	r3, [r4, #24]
/home/trefil/sem/sources/userspace/Model/Model.cpp:133 (discriminator 4)
        //vynuluj hodnoty - aby tam nebyl pripadne nejaky bordylek
        //bss sekce je vynulovana, takze by tam nemel byt nejaky svinec
        //ale pro pripad, ze tam svinec je, tak nechceme, aby umrel task na neco hloupeho
        for(int j = 0; j < window_size; j++)
    8db8:	e3a03000 	mov	r3, #0
    8dbc:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/userspace/Model/Model.cpp:133 (discriminator 3)
    8dc0:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8dc4:	e5933010 	ldr	r3, [r3, #16]
    8dc8:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    8dcc:	e1520003 	cmp	r2, r3
    8dd0:	aa00000f 	bge	8e14 <_ZN5Model4InitEv+0x110>
/home/trefil/sem/sources/userspace/Model/Model.cpp:134 (discriminator 2)
            this->population[i]->predicted_values[j]= 0;
    8dd4:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8dd8:	e5932024 	ldr	r2, [r3, #36]	; 0x24
    8ddc:	e51b3010 	ldr	r3, [fp, #-16]
    8de0:	e1a03103 	lsl	r3, r3, #2
    8de4:	e0823003 	add	r3, r2, r3
    8de8:	e5933000 	ldr	r3, [r3]
    8dec:	e5932018 	ldr	r2, [r3, #24]
    8df0:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8df4:	e1a03103 	lsl	r3, r3, #2
    8df8:	e0823003 	add	r3, r2, r3
    8dfc:	e3a02000 	mov	r2, #0
    8e00:	e5832000 	str	r2, [r3]
/home/trefil/sem/sources/userspace/Model/Model.cpp:133 (discriminator 2)
        for(int j = 0; j < window_size; j++)
    8e04:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8e08:	e2833001 	add	r3, r3, #1
    8e0c:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
    8e10:	eaffffea 	b	8dc0 <_ZN5Model4InitEv+0xbc>
/home/trefil/sem/sources/userspace/Model/Model.cpp:126 (discriminator 2)
    for(int i = 0; i < population_count;i++){
    8e14:	e51b3010 	ldr	r3, [fp, #-16]
    8e18:	e2833001 	add	r3, r3, #1
    8e1c:	e50b3010 	str	r3, [fp, #-16]
    8e20:	eaffffc5 	b	8d3c <_ZN5Model4InitEv+0x38>
/home/trefil/sem/sources/userspace/Model/Model.cpp:137

    }
    this->data = new float[window_size];
    8e24:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8e28:	e5933010 	ldr	r3, [r3, #16]
    8e2c:	e373022e 	cmn	r3, #-536870910	; 0xe0000002
    8e30:	8a000001 	bhi	8e3c <_ZN5Model4InitEv+0x138>
/home/trefil/sem/sources/userspace/Model/Model.cpp:137 (discriminator 1)
    8e34:	e1a03103 	lsl	r3, r3, #2
    8e38:	ea000000 	b	8e40 <_ZN5Model4InitEv+0x13c>
/home/trefil/sem/sources/userspace/Model/Model.cpp:137 (discriminator 2)
    8e3c:	e3e03000 	mvn	r3, #0
/home/trefil/sem/sources/userspace/Model/Model.cpp:137 (discriminator 4)
    8e40:	e1a00003 	mov	r0, r3
    8e44:	eb0002b6 	bl	9924 <_Znaj>
    8e48:	e1a03000 	mov	r3, r0
    8e4c:	e1a02003 	mov	r2, r3
    8e50:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8e54:	e5832038 	str	r2, [r3, #56]	; 0x38
/home/trefil/sem/sources/userspace/Model/Model.cpp:139 (discriminator 4)
    //*1000 abych to mohl rozumne prevadet na floaty
    this->random = new Random_Generator(min_parameter_value * 1000, max_parameter_value * 1000, 4, 1, 42);
    8e58:	e3a0001c 	mov	r0, #28
    8e5c:	ebfffdcb 	bl	8590 <_Znwj>
    8e60:	e1a03000 	mov	r3, r0
    8e64:	e1a04003 	mov	r4, r3
    8e68:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8e6c:	e5932008 	ldr	r2, [r3, #8]
    8e70:	e1a03002 	mov	r3, r2
    8e74:	e1a03283 	lsl	r3, r3, #5
    8e78:	e0433002 	sub	r3, r3, r2
    8e7c:	e1a03103 	lsl	r3, r3, #2
    8e80:	e0833002 	add	r3, r3, r2
    8e84:	e1a03183 	lsl	r3, r3, #3
    8e88:	e1a01003 	mov	r1, r3
    8e8c:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8e90:	e593200c 	ldr	r2, [r3, #12]
    8e94:	e1a03002 	mov	r3, r2
    8e98:	e1a03283 	lsl	r3, r3, #5
    8e9c:	e0433002 	sub	r3, r3, r2
    8ea0:	e1a03103 	lsl	r3, r3, #2
    8ea4:	e0833002 	add	r3, r3, r2
    8ea8:	e1a03183 	lsl	r3, r3, #3
    8eac:	e1a02003 	mov	r2, r3
    8eb0:	e3a0302a 	mov	r3, #42	; 0x2a
    8eb4:	e58d3004 	str	r3, [sp, #4]
    8eb8:	e3a03001 	mov	r3, #1
    8ebc:	e58d3000 	str	r3, [sp]
    8ec0:	e3a03004 	mov	r3, #4
    8ec4:	e1a00004 	mov	r0, r4
    8ec8:	eb0003bc 	bl	9dc0 <_ZN16Random_GeneratorC1Eiiiii>
    8ecc:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8ed0:	e583402c 	str	r4, [r3, #44]	; 0x2c
/home/trefil/sem/sources/userspace/Model/Model.cpp:142 (discriminator 4)

    //init nejlepsiho z generace
    this->alpha = new Tribesman;
    8ed4:	e3a0001c 	mov	r0, #28
    8ed8:	ebfffdac 	bl	8590 <_Znwj>
    8edc:	e1a03000 	mov	r3, r0
    8ee0:	e1a02003 	mov	r2, r3
    8ee4:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8ee8:	e5832028 	str	r2, [r3, #40]	; 0x28
/home/trefil/sem/sources/userspace/Model/Model.cpp:143 (discriminator 4)
    this->alpha->predicted_values = new float[window_size];
    8eec:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8ef0:	e5933010 	ldr	r3, [r3, #16]
    8ef4:	e373022e 	cmn	r3, #-536870910	; 0xe0000002
    8ef8:	8a000001 	bhi	8f04 <_ZN5Model4InitEv+0x200>
/home/trefil/sem/sources/userspace/Model/Model.cpp:143 (discriminator 1)
    8efc:	e1a03103 	lsl	r3, r3, #2
    8f00:	ea000000 	b	8f08 <_ZN5Model4InitEv+0x204>
/home/trefil/sem/sources/userspace/Model/Model.cpp:143 (discriminator 2)
    8f04:	e3e03000 	mvn	r3, #0
/home/trefil/sem/sources/userspace/Model/Model.cpp:143 (discriminator 4)
    8f08:	e51b2020 	ldr	r2, [fp, #-32]	; 0xffffffe0
    8f0c:	e5924028 	ldr	r4, [r2, #40]	; 0x28
    8f10:	e1a00003 	mov	r0, r3
    8f14:	eb000282 	bl	9924 <_Znaj>
    8f18:	e1a03000 	mov	r3, r0
    8f1c:	e5843018 	str	r3, [r4, #24]
/home/trefil/sem/sources/userspace/Model/Model.cpp:144 (discriminator 4)
    for(int j = 0; j < window_size; j++)
    8f20:	e3a03000 	mov	r3, #0
    8f24:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/userspace/Model/Model.cpp:144 (discriminator 3)
    8f28:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8f2c:	e5933010 	ldr	r3, [r3, #16]
    8f30:	e51b2018 	ldr	r2, [fp, #-24]	; 0xffffffe8
    8f34:	e1520003 	cmp	r2, r3
    8f38:	aa00000b 	bge	8f6c <_ZN5Model4InitEv+0x268>
/home/trefil/sem/sources/userspace/Model/Model.cpp:145 (discriminator 2)
        this->alpha->predicted_values[j] = 0;
    8f3c:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8f40:	e5933028 	ldr	r3, [r3, #40]	; 0x28
    8f44:	e5932018 	ldr	r2, [r3, #24]
    8f48:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8f4c:	e1a03103 	lsl	r3, r3, #2
    8f50:	e0823003 	add	r3, r2, r3
    8f54:	e3a02000 	mov	r2, #0
    8f58:	e5832000 	str	r2, [r3]
/home/trefil/sem/sources/userspace/Model/Model.cpp:144 (discriminator 2)
    for(int j = 0; j < window_size; j++)
    8f5c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8f60:	e2833001 	add	r3, r3, #1
    8f64:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
    8f68:	eaffffee 	b	8f28 <_ZN5Model4InitEv+0x224>
/home/trefil/sem/sources/userspace/Model/Model.cpp:146
    First_Generation();
    8f6c:	e51b0020 	ldr	r0, [fp, #-32]	; 0xffffffe0
    8f70:	ebfffe94 	bl	89c8 <_ZN5Model16First_GenerationEv>
/home/trefil/sem/sources/userspace/Model/Model.cpp:148

}
    8f74:	e320f000 	nop	{0}
    8f78:	e24bd008 	sub	sp, fp, #8
    8f7c:	e8bd8810 	pop	{r4, fp, pc}

00008f80 <_ZN5Model19Is_Data_Window_FullEv>:
_ZN5Model19Is_Data_Window_FullEv():
/home/trefil/sem/sources/userspace/Model/Model.cpp:149
bool Model::Is_Data_Window_Full(){
    8f80:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8f84:	e28db000 	add	fp, sp, #0
    8f88:	e24dd00c 	sub	sp, sp, #12
    8f8c:	e50b0008 	str	r0, [fp, #-8]
/home/trefil/sem/sources/userspace/Model/Model.cpp:150
    return data_pointer == window_size;
    8f90:	e51b3008 	ldr	r3, [fp, #-8]
    8f94:	e593201c 	ldr	r2, [r3, #28]
    8f98:	e51b3008 	ldr	r3, [fp, #-8]
    8f9c:	e5933010 	ldr	r3, [r3, #16]
    8fa0:	e1520003 	cmp	r2, r3
    8fa4:	03a03001 	moveq	r3, #1
    8fa8:	13a03000 	movne	r3, #0
    8fac:	e6ef3073 	uxtb	r3, r3
/home/trefil/sem/sources/userspace/Model/Model.cpp:151
}
    8fb0:	e1a00003 	mov	r0, r3
    8fb4:	e28bd000 	add	sp, fp, #0
    8fb8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8fbc:	e12fff1e 	bx	lr

00008fc0 <_ZN5Model15Add_Data_SampleEf>:
_ZN5Model15Add_Data_SampleEf():
/home/trefil/sem/sources/userspace/Model/Model.cpp:153

bool Model::Add_Data_Sample(float y){
    8fc0:	e92d4800 	push	{fp, lr}
    8fc4:	e28db004 	add	fp, sp, #4
    8fc8:	e24dd008 	sub	sp, sp, #8
    8fcc:	e50b0008 	str	r0, [fp, #-8]
    8fd0:	ed0b0a03 	vstr	s0, [fp, #-12]
/home/trefil/sem/sources/userspace/Model/Model.cpp:154
    if(Is_Data_Window_Full()){
    8fd4:	e51b0008 	ldr	r0, [fp, #-8]
    8fd8:	ebffffe8 	bl	8f80 <_ZN5Model19Is_Data_Window_FullEv>
    8fdc:	e1a03000 	mov	r3, r0
    8fe0:	e3530000 	cmp	r3, #0
    8fe4:	0a000006 	beq	9004 <_ZN5Model15Add_Data_SampleEf+0x44>
/home/trefil/sem/sources/userspace/Model/Model.cpp:155
        this->bfr->Write_Line("Dalsi datovy vzorek se mi nevejde do okenka \n");
    8fe8:	e51b3008 	ldr	r3, [fp, #-8]
    8fec:	e5933030 	ldr	r3, [r3, #48]	; 0x30
    8ff0:	e59f1048 	ldr	r1, [pc, #72]	; 9040 <_ZN5Model15Add_Data_SampleEf+0x80>
    8ff4:	e1a00003 	mov	r0, r3
    8ff8:	eb00041c 	bl	a070 <_ZN6Buffer10Write_LineEPKc>
/home/trefil/sem/sources/userspace/Model/Model.cpp:156
        return false;
    8ffc:	e3a03000 	mov	r3, #0
    9000:	ea00000b 	b	9034 <_ZN5Model15Add_Data_SampleEf+0x74>
/home/trefil/sem/sources/userspace/Model/Model.cpp:158
    }
    this->data[data_pointer++] = y;
    9004:	e51b3008 	ldr	r3, [fp, #-8]
    9008:	e5932038 	ldr	r2, [r3, #56]	; 0x38
    900c:	e51b3008 	ldr	r3, [fp, #-8]
    9010:	e593301c 	ldr	r3, [r3, #28]
    9014:	e2830001 	add	r0, r3, #1
    9018:	e51b1008 	ldr	r1, [fp, #-8]
    901c:	e581001c 	str	r0, [r1, #28]
    9020:	e1a03103 	lsl	r3, r3, #2
    9024:	e0823003 	add	r3, r2, r3
    9028:	e51b200c 	ldr	r2, [fp, #-12]
    902c:	e5832000 	str	r2, [r3]
/home/trefil/sem/sources/userspace/Model/Model.cpp:159
    return true;
    9030:	e3a03001 	mov	r3, #1
/home/trefil/sem/sources/userspace/Model/Model.cpp:160
}
    9034:	e1a00003 	mov	r0, r3
    9038:	e24bd004 	sub	sp, fp, #4
    903c:	e8bd8800 	pop	{fp, pc}
    9040:	0000bf9c 	muleq	r0, ip, pc	; <UNPREDICTABLE>

00009044 <_ZN5Model10Set_BufferEP6Buffer>:
_ZN5Model10Set_BufferEP6Buffer():
/home/trefil/sem/sources/userspace/Model/Model.cpp:162

void Model::Set_Buffer(Buffer* bfr){
    9044:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9048:	e28db000 	add	fp, sp, #0
    904c:	e24dd00c 	sub	sp, sp, #12
    9050:	e50b0008 	str	r0, [fp, #-8]
    9054:	e50b100c 	str	r1, [fp, #-12]
/home/trefil/sem/sources/userspace/Model/Model.cpp:163
    this->bfr = bfr;
    9058:	e51b3008 	ldr	r3, [fp, #-8]
    905c:	e51b200c 	ldr	r2, [fp, #-12]
    9060:	e5832030 	str	r2, [r3, #48]	; 0x30
/home/trefil/sem/sources/userspace/Model/Model.cpp:164
}
    9064:	e320f000 	nop	{0}
    9068:	e28bd000 	add	sp, fp, #0
    906c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9070:	e12fff1e 	bx	lr

00009074 <_ZN5Model16Get_Data_SamplesEv>:
_ZN5Model16Get_Data_SamplesEv():
/home/trefil/sem/sources/userspace/Model/Model.cpp:166

float* Model::Get_Data_Samples(){
    9074:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9078:	e28db000 	add	fp, sp, #0
    907c:	e24dd00c 	sub	sp, sp, #12
    9080:	e50b0008 	str	r0, [fp, #-8]
/home/trefil/sem/sources/userspace/Model/Model.cpp:167
    return this->data;
    9084:	e51b3008 	ldr	r3, [fp, #-8]
    9088:	e5933038 	ldr	r3, [r3, #56]	; 0x38
/home/trefil/sem/sources/userspace/Model/Model.cpp:168
}
    908c:	e1a00003 	mov	r0, r3
    9090:	e28bd000 	add	sp, fp, #0
    9094:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9098:	e12fff1e 	bx	lr

0000909c <_ZN5Model15Gene_Pool_PartyEPP9Tribesman>:
_ZN5Model15Gene_Pool_PartyEPP9Tribesman():
/home/trefil/sem/sources/userspace/Model/Model.cpp:170
//20% smetanky populace prezije, zbytek je nahrazen krizenim, tedy ppst krizeni = 0.2
void Model::Gene_Pool_Party(Tribesman** population){
    909c:	e92d4810 	push	{r4, fp, lr}
    90a0:	e28db008 	add	fp, sp, #8
    90a4:	e24dd03c 	sub	sp, sp, #60	; 0x3c
    90a8:	e50b0040 	str	r0, [fp, #-64]	; 0xffffffc0
    90ac:	e50b1044 	str	r1, [fp, #-68]	; 0xffffffbc
/home/trefil/sem/sources/userspace/Model/Model.cpp:172
    // stanovime hranici krizeni
    int cross_boundary = this->random->Get_Int() % PARAMETER_COUNT;
    90b0:	e51b3040 	ldr	r3, [fp, #-64]	; 0xffffffc0
    90b4:	e593302c 	ldr	r3, [r3, #44]	; 0x2c
    90b8:	e1a00003 	mov	r0, r3
    90bc:	eb00035d 	bl	9e38 <_ZN16Random_Generator7Get_IntEv>
    90c0:	e1a02000 	mov	r2, r0
    90c4:	e59f3284 	ldr	r3, [pc, #644]	; 9350 <_ZN5Model15Gene_Pool_PartyEPP9Tribesman+0x2b4>
    90c8:	e0c31293 	smull	r1, r3, r3, r2
    90cc:	e1a010c3 	asr	r1, r3, #1
    90d0:	e1a03fc2 	asr	r3, r2, #31
    90d4:	e0411003 	sub	r1, r1, r3
    90d8:	e1a03001 	mov	r3, r1
    90dc:	e1a03103 	lsl	r3, r3, #2
    90e0:	e0833001 	add	r3, r3, r1
    90e4:	e0423003 	sub	r3, r2, r3
    90e8:	e50b3024 	str	r3, [fp, #-36]	; 0xffffffdc
/home/trefil/sem/sources/userspace/Model/Model.cpp:174
    //dedime z leveho rodice nebo praveho
    bool left_parent = this->random->Get_Int() % 2 == 0;
    90ec:	e51b3040 	ldr	r3, [fp, #-64]	; 0xffffffc0
    90f0:	e593302c 	ldr	r3, [r3, #44]	; 0x2c
    90f4:	e1a00003 	mov	r0, r3
    90f8:	eb00034e 	bl	9e38 <_ZN16Random_Generator7Get_IntEv>
    90fc:	e1a03000 	mov	r3, r0
    9100:	e2033001 	and	r3, r3, #1
    9104:	e3530000 	cmp	r3, #0
    9108:	03a03001 	moveq	r3, #1
    910c:	13a03000 	movne	r3, #0
    9110:	e54b3025 	strb	r3, [fp, #-37]	; 0xffffffdb
/home/trefil/sem/sources/userspace/Model/Model.cpp:178
    //odtud zacinam nahrazovat
    //tedy <start> clenu populace zustane
    //z nich vznikne start / 2 novych clenu krizenim
    int start = this->population_count * 0.2;
    9114:	e51b3040 	ldr	r3, [fp, #-64]	; 0xffffffc0
    9118:	e5933014 	ldr	r3, [r3, #20]
    911c:	ee073a90 	vmov	s15, r3
    9120:	eeb87be7 	vcvt.f64.s32	d7, s15
    9124:	ed9f6b87 	vldr	d6, [pc, #540]	; 9348 <_ZN5Model15Gene_Pool_PartyEPP9Tribesman+0x2ac>
    9128:	ee277b06 	vmul.f64	d7, d7, d6
    912c:	eefd7bc7 	vcvt.s32.f64	s15, d7
    9130:	ee173a90 	vmov	r3, s15
    9134:	e50b3010 	str	r3, [fp, #-16]
/home/trefil/sem/sources/userspace/Model/Model.cpp:180
    //tolik potrebujeme vytvorit novych clenu populace
    int new_pop_count = population_count - start;
    9138:	e51b3040 	ldr	r3, [fp, #-64]	; 0xffffffc0
    913c:	e5932014 	ldr	r2, [r3, #20]
    9140:	e51b3010 	ldr	r3, [fp, #-16]
    9144:	e0423003 	sub	r3, r2, r3
    9148:	e50b302c 	str	r3, [fp, #-44]	; 0xffffffd4
/home/trefil/sem/sources/userspace/Model/Model.cpp:182
    //vytvor deti z top 20 % clenu populace
    int pointer = 0;
    914c:	e3a03000 	mov	r3, #0
    9150:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/userspace/Model/Model.cpp:185

    //od start po party_stop se budou vznikat potomci krizenim
    int party_stop = start + start / 2;
    9154:	e51b3010 	ldr	r3, [fp, #-16]
    9158:	e1a02fa3 	lsr	r2, r3, #31
    915c:	e0823003 	add	r3, r2, r3
    9160:	e1a030c3 	asr	r3, r3, #1
    9164:	e1a02003 	mov	r2, r3
    9168:	e51b3010 	ldr	r3, [fp, #-16]
    916c:	e0833002 	add	r3, r3, r2
    9170:	e50b3030 	str	r3, [fp, #-48]	; 0xffffffd0
/home/trefil/sem/sources/userspace/Model/Model.cpp:187 (discriminator 1)
    //cleny populace do indexu start ponecham
    for(start; start < party_stop ;start++){
    9174:	e51b2010 	ldr	r2, [fp, #-16]
    9178:	e51b3030 	ldr	r3, [fp, #-48]	; 0xffffffd0
    917c:	e1520003 	cmp	r2, r3
    9180:	aa00004b 	bge	92b4 <_ZN5Model15Gene_Pool_PartyEPP9Tribesman+0x218>
/home/trefil/sem/sources/userspace/Model/Model.cpp:188
        Tribesman* l_parent = population[pointer];
    9184:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9188:	e1a03103 	lsl	r3, r3, #2
    918c:	e51b2044 	ldr	r2, [fp, #-68]	; 0xffffffbc
    9190:	e0823003 	add	r3, r2, r3
    9194:	e5933000 	ldr	r3, [r3]
    9198:	e50b3034 	str	r3, [fp, #-52]	; 0xffffffcc
/home/trefil/sem/sources/userspace/Model/Model.cpp:189
        Tribesman* r_parent = population[pointer + 1];
    919c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    91a0:	e2833001 	add	r3, r3, #1
    91a4:	e1a03103 	lsl	r3, r3, #2
    91a8:	e51b2044 	ldr	r2, [fp, #-68]	; 0xffffffbc
    91ac:	e0823003 	add	r3, r2, r3
    91b0:	e5933000 	ldr	r3, [r3]
    91b4:	e50b3038 	str	r3, [fp, #-56]	; 0xffffffc8
/home/trefil/sem/sources/userspace/Model/Model.cpp:191

        for(int i = 0; i < cross_boundary; i++)
    91b8:	e3a03000 	mov	r3, #0
    91bc:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/userspace/Model/Model.cpp:191 (discriminator 2)
    91c0:	e51b2018 	ldr	r2, [fp, #-24]	; 0xffffffe8
    91c4:	e51b3024 	ldr	r3, [fp, #-36]	; 0xffffffdc
    91c8:	e1520003 	cmp	r2, r3
    91cc:	aa00001a 	bge	923c <_ZN5Model15Gene_Pool_PartyEPP9Tribesman+0x1a0>
/home/trefil/sem/sources/userspace/Model/Model.cpp:192
            population[start]->parameters[i] = left_parent? l_parent->parameters[i] : r_parent->parameters[i];
    91d0:	e55b3025 	ldrb	r3, [fp, #-37]	; 0xffffffdb
    91d4:	e3530000 	cmp	r3, #0
    91d8:	0a000005 	beq	91f4 <_ZN5Model15Gene_Pool_PartyEPP9Tribesman+0x158>
/home/trefil/sem/sources/userspace/Model/Model.cpp:192 (discriminator 1)
    91dc:	e51b2034 	ldr	r2, [fp, #-52]	; 0xffffffcc
    91e0:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    91e4:	e1a03103 	lsl	r3, r3, #2
    91e8:	e0823003 	add	r3, r2, r3
    91ec:	e5933000 	ldr	r3, [r3]
    91f0:	ea000004 	b	9208 <_ZN5Model15Gene_Pool_PartyEPP9Tribesman+0x16c>
/home/trefil/sem/sources/userspace/Model/Model.cpp:192 (discriminator 2)
    91f4:	e51b2038 	ldr	r2, [fp, #-56]	; 0xffffffc8
    91f8:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    91fc:	e1a03103 	lsl	r3, r3, #2
    9200:	e0823003 	add	r3, r2, r3
    9204:	e5933000 	ldr	r3, [r3]
/home/trefil/sem/sources/userspace/Model/Model.cpp:192 (discriminator 4)
    9208:	e51b2010 	ldr	r2, [fp, #-16]
    920c:	e1a02102 	lsl	r2, r2, #2
    9210:	e51b1044 	ldr	r1, [fp, #-68]	; 0xffffffbc
    9214:	e0812002 	add	r2, r1, r2
    9218:	e5921000 	ldr	r1, [r2]
    921c:	e51b2018 	ldr	r2, [fp, #-24]	; 0xffffffe8
    9220:	e1a02102 	lsl	r2, r2, #2
    9224:	e0812002 	add	r2, r1, r2
    9228:	e5823000 	str	r3, [r2]
/home/trefil/sem/sources/userspace/Model/Model.cpp:191 (discriminator 4)
        for(int i = 0; i < cross_boundary; i++)
    922c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9230:	e2833001 	add	r3, r3, #1
    9234:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
    9238:	eaffffe0 	b	91c0 <_ZN5Model15Gene_Pool_PartyEPP9Tribesman+0x124>
/home/trefil/sem/sources/userspace/Model/Model.cpp:193
        for(int j = cross_boundary; j < PARAMETER_COUNT; j++)
    923c:	e51b3024 	ldr	r3, [fp, #-36]	; 0xffffffdc
    9240:	e50b301c 	str	r3, [fp, #-28]	; 0xffffffe4
/home/trefil/sem/sources/userspace/Model/Model.cpp:193 (discriminator 3)
    9244:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    9248:	e3530004 	cmp	r3, #4
    924c:	ca000011 	bgt	9298 <_ZN5Model15Gene_Pool_PartyEPP9Tribesman+0x1fc>
/home/trefil/sem/sources/userspace/Model/Model.cpp:194 (discriminator 2)
            population[start]->parameters[j] = this->random->Get_Float();
    9250:	e51b3040 	ldr	r3, [fp, #-64]	; 0xffffffc0
    9254:	e593102c 	ldr	r1, [r3, #44]	; 0x2c
    9258:	e51b3010 	ldr	r3, [fp, #-16]
    925c:	e1a03103 	lsl	r3, r3, #2
    9260:	e51b2044 	ldr	r2, [fp, #-68]	; 0xffffffbc
    9264:	e0823003 	add	r3, r2, r3
    9268:	e5934000 	ldr	r4, [r3]
    926c:	e1a00001 	mov	r0, r1
    9270:	eb000314 	bl	9ec8 <_ZN16Random_Generator9Get_FloatEv>
    9274:	eef07a40 	vmov.f32	s15, s0
    9278:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    927c:	e1a03103 	lsl	r3, r3, #2
    9280:	e0843003 	add	r3, r4, r3
    9284:	edc37a00 	vstr	s15, [r3]
/home/trefil/sem/sources/userspace/Model/Model.cpp:193 (discriminator 2)
        for(int j = cross_boundary; j < PARAMETER_COUNT; j++)
    9288:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    928c:	e2833001 	add	r3, r3, #1
    9290:	e50b301c 	str	r3, [fp, #-28]	; 0xffffffe4
    9294:	eaffffea 	b	9244 <_ZN5Model15Gene_Pool_PartyEPP9Tribesman+0x1a8>
/home/trefil/sem/sources/userspace/Model/Model.cpp:195
        pointer += 2;
    9298:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    929c:	e2833002 	add	r3, r3, #2
    92a0:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/userspace/Model/Model.cpp:187
    for(start; start < party_stop ;start++){
    92a4:	e51b3010 	ldr	r3, [fp, #-16]
    92a8:	e2833001 	add	r3, r3, #1
    92ac:	e50b3010 	str	r3, [fp, #-16]
    92b0:	eaffffaf 	b	9174 <_ZN5Model15Gene_Pool_PartyEPP9Tribesman+0xd8>
/home/trefil/sem/sources/userspace/Model/Model.cpp:198 (discriminator 1)
    }
    //vytvor random nove cleny populace
    for(start; start < new_pop_count; start++){
    92b4:	e51b2010 	ldr	r2, [fp, #-16]
    92b8:	e51b302c 	ldr	r3, [fp, #-44]	; 0xffffffd4
    92bc:	e1520003 	cmp	r2, r3
    92c0:	aa00001c 	bge	9338 <_ZN5Model15Gene_Pool_PartyEPP9Tribesman+0x29c>
/home/trefil/sem/sources/userspace/Model/Model.cpp:199
        Tribesman* new_tribesman = population[start];
    92c4:	e51b3010 	ldr	r3, [fp, #-16]
    92c8:	e1a03103 	lsl	r3, r3, #2
    92cc:	e51b2044 	ldr	r2, [fp, #-68]	; 0xffffffbc
    92d0:	e0823003 	add	r3, r2, r3
    92d4:	e5933000 	ldr	r3, [r3]
    92d8:	e50b303c 	str	r3, [fp, #-60]	; 0xffffffc4
/home/trefil/sem/sources/userspace/Model/Model.cpp:201
        //vytvor "nove" cleny populace
        for(int i = 0; i < PARAMETER_COUNT; i++)
    92dc:	e3a03000 	mov	r3, #0
    92e0:	e50b3020 	str	r3, [fp, #-32]	; 0xffffffe0
/home/trefil/sem/sources/userspace/Model/Model.cpp:201 (discriminator 3)
    92e4:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    92e8:	e3530004 	cmp	r3, #4
    92ec:	ca00000d 	bgt	9328 <_ZN5Model15Gene_Pool_PartyEPP9Tribesman+0x28c>
/home/trefil/sem/sources/userspace/Model/Model.cpp:202 (discriminator 2)
            new_tribesman->parameters[i] = random->Get_Float();
    92f0:	e51b3040 	ldr	r3, [fp, #-64]	; 0xffffffc0
    92f4:	e593302c 	ldr	r3, [r3, #44]	; 0x2c
    92f8:	e1a00003 	mov	r0, r3
    92fc:	eb0002f1 	bl	9ec8 <_ZN16Random_Generator9Get_FloatEv>
    9300:	eef07a40 	vmov.f32	s15, s0
    9304:	e51b203c 	ldr	r2, [fp, #-60]	; 0xffffffc4
    9308:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    930c:	e1a03103 	lsl	r3, r3, #2
    9310:	e0823003 	add	r3, r2, r3
    9314:	edc37a00 	vstr	s15, [r3]
/home/trefil/sem/sources/userspace/Model/Model.cpp:201 (discriminator 2)
        for(int i = 0; i < PARAMETER_COUNT; i++)
    9318:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    931c:	e2833001 	add	r3, r3, #1
    9320:	e50b3020 	str	r3, [fp, #-32]	; 0xffffffe0
    9324:	eaffffee 	b	92e4 <_ZN5Model15Gene_Pool_PartyEPP9Tribesman+0x248>
/home/trefil/sem/sources/userspace/Model/Model.cpp:198
    for(start; start < new_pop_count; start++){
    9328:	e51b3010 	ldr	r3, [fp, #-16]
    932c:	e2833001 	add	r3, r3, #1
    9330:	e50b3010 	str	r3, [fp, #-16]
    9334:	eaffffde 	b	92b4 <_ZN5Model15Gene_Pool_PartyEPP9Tribesman+0x218>
/home/trefil/sem/sources/userspace/Model/Model.cpp:207

    }


}
    9338:	e320f000 	nop	{0}
    933c:	e24bd008 	sub	sp, fp, #8
    9340:	e8bd8810 	pop	{r4, fp, pc}
    9344:	e320f000 	nop	{0}
    9348:	9999999a 	ldmibls	r9, {r1, r3, r4, r7, r8, fp, ip, pc}
    934c:	3fc99999 	svccc	0x00c99999
    9350:	66666667 	strbtvs	r6, [r6], -r7, ror #12

00009354 <_ZN5Model19Eval_String_CommandEPKc>:
_ZN5Model19Eval_String_CommandEPKc():
/home/trefil/sem/sources/userspace/Model/Model.cpp:208
void Model::Eval_String_Command(const char *str){
    9354:	e92d4800 	push	{fp, lr}
    9358:	e28db004 	add	fp, sp, #4
    935c:	e24dd008 	sub	sp, sp, #8
    9360:	e50b0008 	str	r0, [fp, #-8]
    9364:	e50b100c 	str	r1, [fp, #-12]
/home/trefil/sem/sources/userspace/Model/Model.cpp:209
    if(!strncmp("parameters",str,strlen("parameters"))){
    9368:	e59f00bc 	ldr	r0, [pc, #188]	; 942c <_ZN5Model19Eval_String_CommandEPKc+0xd8>
    936c:	eb00067e 	bl	ad6c <_Z6strlenPKc>
    9370:	e1a03000 	mov	r3, r0
    9374:	e1a02003 	mov	r2, r3
    9378:	e51b100c 	ldr	r1, [fp, #-12]
    937c:	e59f00a8 	ldr	r0, [pc, #168]	; 942c <_ZN5Model19Eval_String_CommandEPKc+0xd8>
    9380:	eb00064e 	bl	acc0 <_Z7strncmpPKcS0_i>
    9384:	e1a03000 	mov	r3, r0
    9388:	e3530000 	cmp	r3, #0
    938c:	03a03001 	moveq	r3, #1
    9390:	13a03000 	movne	r3, #0
    9394:	e6ef3073 	uxtb	r3, r3
    9398:	e3530000 	cmp	r3, #0
    939c:	0a000002 	beq	93ac <_ZN5Model19Eval_String_CommandEPKc+0x58>
/home/trefil/sem/sources/userspace/Model/Model.cpp:210
        Print_Parameters();
    93a0:	e51b0008 	ldr	r0, [fp, #-8]
    93a4:	ebfffe00 	bl	8bac <_ZN5Model16Print_ParametersEv>
/home/trefil/sem/sources/userspace/Model/Model.cpp:211
        return;
    93a8:	ea00001d 	b	9424 <_ZN5Model19Eval_String_CommandEPKc+0xd0>
/home/trefil/sem/sources/userspace/Model/Model.cpp:213
    }
    else if(!strncmp("stop",str,strlen("stop"))){
    93ac:	e59f007c 	ldr	r0, [pc, #124]	; 9430 <_ZN5Model19Eval_String_CommandEPKc+0xdc>
    93b0:	eb00066d 	bl	ad6c <_Z6strlenPKc>
    93b4:	e1a03000 	mov	r3, r0
    93b8:	e1a02003 	mov	r2, r3
    93bc:	e51b100c 	ldr	r1, [fp, #-12]
    93c0:	e59f0068 	ldr	r0, [pc, #104]	; 9430 <_ZN5Model19Eval_String_CommandEPKc+0xdc>
    93c4:	eb00063d 	bl	acc0 <_Z7strncmpPKcS0_i>
    93c8:	e1a03000 	mov	r3, r0
    93cc:	e3530000 	cmp	r3, #0
    93d0:	03a03001 	moveq	r3, #1
    93d4:	13a03000 	movne	r3, #0
    93d8:	e6ef3073 	uxtb	r3, r3
    93dc:	e3530000 	cmp	r3, #0
    93e0:	0a000008 	beq	9408 <_ZN5Model19Eval_String_CommandEPKc+0xb4>
/home/trefil/sem/sources/userspace/Model/Model.cpp:214
        this->bfr->Write_Line("Zastavuji vypocet\n");
    93e4:	e51b3008 	ldr	r3, [fp, #-8]
    93e8:	e5933030 	ldr	r3, [r3, #48]	; 0x30
    93ec:	e59f1040 	ldr	r1, [pc, #64]	; 9434 <_ZN5Model19Eval_String_CommandEPKc+0xe0>
    93f0:	e1a00003 	mov	r0, r3
    93f4:	eb00031d 	bl	a070 <_ZN6Buffer10Write_LineEPKc>
/home/trefil/sem/sources/userspace/Model/Model.cpp:215
        is_fitting = false;
    93f8:	e51b3008 	ldr	r3, [fp, #-8]
    93fc:	e3a02000 	mov	r2, #0
    9400:	e5c32018 	strb	r2, [r3, #24]
/home/trefil/sem/sources/userspace/Model/Model.cpp:216
        return;
    9404:	ea000006 	b	9424 <_ZN5Model19Eval_String_CommandEPKc+0xd0>
/home/trefil/sem/sources/userspace/Model/Model.cpp:219
    }
    else
        this->bfr->Write_Line("Neznamy prikaz\n");
    9408:	e51b3008 	ldr	r3, [fp, #-8]
    940c:	e5933030 	ldr	r3, [r3, #48]	; 0x30
    9410:	e59f1020 	ldr	r1, [pc, #32]	; 9438 <_ZN5Model19Eval_String_CommandEPKc+0xe4>
    9414:	e1a00003 	mov	r0, r3
    9418:	eb000314 	bl	a070 <_ZN6Buffer10Write_LineEPKc>
/home/trefil/sem/sources/userspace/Model/Model.cpp:220
    Prompt_User();
    941c:	e51b0008 	ldr	r0, [fp, #-8]
    9420:	eb00007a 	bl	9610 <_ZN5Model11Prompt_UserEv>
/home/trefil/sem/sources/userspace/Model/Model.cpp:223


}
    9424:	e24bd004 	sub	sp, fp, #4
    9428:	e8bd8800 	pop	{fp, pc}
    942c:	0000bfcc 	andeq	fp, r0, ip, asr #31
    9430:	0000bfd8 	ldrdeq	fp, [r0], -r8
    9434:	0000bfe0 	andeq	fp, r0, r0, ror #31
    9438:	0000bff4 	strdeq	fp, [r0], -r4

0000943c <_ZN5Model10CheckpointEv>:
_ZN5Model10CheckpointEv():
/home/trefil/sem/sources/userspace/Model/Model.cpp:226


void Model::Checkpoint(){
    943c:	e92d4800 	push	{fp, lr}
    9440:	e28db004 	add	fp, sp, #4
    9444:	e24dd018 	sub	sp, sp, #24
    9448:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/userspace/Model/Model.cpp:227
    char* line = this->bfr->Read_Uart_Line();
    944c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9450:	e5933030 	ldr	r3, [r3, #48]	; 0x30
    9454:	e1a00003 	mov	r0, r3
    9458:	eb000315 	bl	a0b4 <_ZN6Buffer14Read_Uart_LineEv>
    945c:	e50b0008 	str	r0, [fp, #-8]
/home/trefil/sem/sources/userspace/Model/Model.cpp:229
    //nic jsem neprecetl
    if(line == nullptr)return;
    9460:	e51b3008 	ldr	r3, [fp, #-8]
    9464:	e3530000 	cmp	r3, #0
    9468:	0a000030 	beq	9530 <_ZN5Model10CheckpointEv+0xf4>
/home/trefil/sem/sources/userspace/Model/Model.cpp:231
    //kouknu se, co jsem precetl
    int type = get_input_type(line);
    946c:	e51b0008 	ldr	r0, [fp, #-8]
    9470:	eb00054b 	bl	a9a4 <_Z14get_input_typePKc>
    9474:	e50b000c 	str	r0, [fp, #-12]
/home/trefil/sem/sources/userspace/Model/Model.cpp:234
    float f;
    int i;
    switch (type) {
    9478:	e51b300c 	ldr	r3, [fp, #-12]
    947c:	e3530002 	cmp	r3, #2
    9480:	0a00000d 	beq	94bc <_ZN5Model10CheckpointEv+0x80>
    9484:	e51b300c 	ldr	r3, [fp, #-12]
    9488:	e3530002 	cmp	r3, #2
    948c:	ca00002c 	bgt	9544 <_ZN5Model10CheckpointEv+0x108>
    9490:	e51b300c 	ldr	r3, [fp, #-12]
    9494:	e3530000 	cmp	r3, #0
    9498:	0a000003 	beq	94ac <_ZN5Model10CheckpointEv+0x70>
    949c:	e51b300c 	ldr	r3, [fp, #-12]
    94a0:	e3530001 	cmp	r3, #1
    94a4:	0a000011 	beq	94f0 <_ZN5Model10CheckpointEv+0xb4>
    94a8:	ea000025 	b	9544 <_ZN5Model10CheckpointEv+0x108>
/home/trefil/sem/sources/userspace/Model/Model.cpp:236
        case STRING_INPUT:
            Eval_String_Command(line);
    94ac:	e51b1008 	ldr	r1, [fp, #-8]
    94b0:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    94b4:	ebffffa6 	bl	9354 <_ZN5Model19Eval_String_CommandEPKc>
/home/trefil/sem/sources/userspace/Model/Model.cpp:237
            break;
    94b8:	ea000021 	b	9544 <_ZN5Model10CheckpointEv+0x108>
/home/trefil/sem/sources/userspace/Model/Model.cpp:239
        case FLOAT_INPUT:
            f = atof(line);
    94bc:	e51b0008 	ldr	r0, [fp, #-8]
    94c0:	eb000577 	bl	aaa4 <_Z4atofPKc>
    94c4:	ed0b0a04 	vstr	s0, [fp, #-16]
/home/trefil/sem/sources/userspace/Model/Model.cpp:240
            if(Add_Data_Sample(f))
    94c8:	ed1b0a04 	vldr	s0, [fp, #-16]
    94cc:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    94d0:	ebfffeba 	bl	8fc0 <_ZN5Model15Add_Data_SampleEf>
    94d4:	e1a03000 	mov	r3, r0
    94d8:	e3530000 	cmp	r3, #0
    94dc:	0a000015 	beq	9538 <_ZN5Model10CheckpointEv+0xfc>
/home/trefil/sem/sources/userspace/Model/Model.cpp:241
               is_fitting = true;
    94e0:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    94e4:	e3a02001 	mov	r2, #1
    94e8:	e5c32018 	strb	r2, [r3, #24]
/home/trefil/sem/sources/userspace/Model/Model.cpp:242
            break;
    94ec:	ea000011 	b	9538 <_ZN5Model10CheckpointEv+0xfc>
/home/trefil/sem/sources/userspace/Model/Model.cpp:244
        case INT_INPUT:
            i = atoi(line);
    94f0:	e51b0008 	ldr	r0, [fp, #-8]
    94f4:	eb000503 	bl	a908 <_Z4atoiPKc>
    94f8:	e50b0014 	str	r0, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/userspace/Model/Model.cpp:245
            if(Add_Data_Sample(i))
    94fc:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9500:	ee073a90 	vmov	s15, r3
    9504:	eef87ae7 	vcvt.f32.s32	s15, s15
    9508:	eeb00a67 	vmov.f32	s0, s15
    950c:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    9510:	ebfffeaa 	bl	8fc0 <_ZN5Model15Add_Data_SampleEf>
    9514:	e1a03000 	mov	r3, r0
    9518:	e3530000 	cmp	r3, #0
    951c:	0a000007 	beq	9540 <_ZN5Model10CheckpointEv+0x104>
/home/trefil/sem/sources/userspace/Model/Model.cpp:246
              is_fitting = true;
    9520:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9524:	e3a02001 	mov	r2, #1
    9528:	e5c32018 	strb	r2, [r3, #24]
/home/trefil/sem/sources/userspace/Model/Model.cpp:247
            break;
    952c:	ea000003 	b	9540 <_ZN5Model10CheckpointEv+0x104>
/home/trefil/sem/sources/userspace/Model/Model.cpp:229
    if(line == nullptr)return;
    9530:	e320f000 	nop	{0}
    9534:	ea000002 	b	9544 <_ZN5Model10CheckpointEv+0x108>
/home/trefil/sem/sources/userspace/Model/Model.cpp:242
            break;
    9538:	e320f000 	nop	{0}
    953c:	ea000000 	b	9544 <_ZN5Model10CheckpointEv+0x108>
/home/trefil/sem/sources/userspace/Model/Model.cpp:247
            break;
    9540:	e320f000 	nop	{0}
/home/trefil/sem/sources/userspace/Model/Model.cpp:249
    }
}
    9544:	e24bd004 	sub	sp, fp, #4
    9548:	e8bd8800 	pop	{fp, pc}

0000954c <_ZN5Model8MutationEPP9Tribesman>:
_ZN5Model8MutationEPP9Tribesman():
/home/trefil/sem/sources/userspace/Model/Model.cpp:251

void Model::Mutation(Tribesman** population){
    954c:	e92d4810 	push	{r4, fp, lr}
    9550:	e28db008 	add	fp, sp, #8
    9554:	e24dd014 	sub	sp, sp, #20
    9558:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    955c:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
/home/trefil/sem/sources/userspace/Model/Model.cpp:252
    int parameter_to_mutate = random->Get_Int() % PARAMETER_COUNT;
    9560:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9564:	e593302c 	ldr	r3, [r3, #44]	; 0x2c
    9568:	e1a00003 	mov	r0, r3
    956c:	eb000231 	bl	9e38 <_ZN16Random_Generator7Get_IntEv>
    9570:	e1a02000 	mov	r2, r0
    9574:	e59f3090 	ldr	r3, [pc, #144]	; 960c <_ZN5Model8MutationEPP9Tribesman+0xc0>
    9578:	e0c31293 	smull	r1, r3, r3, r2
    957c:	e1a010c3 	asr	r1, r3, #1
    9580:	e1a03fc2 	asr	r3, r2, #31
    9584:	e0411003 	sub	r1, r1, r3
    9588:	e1a03001 	mov	r3, r1
    958c:	e1a03103 	lsl	r3, r3, #2
    9590:	e0833001 	add	r3, r3, r1
    9594:	e0423003 	sub	r3, r2, r3
    9598:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/userspace/Model/Model.cpp:253
    for(int i = 0; i < population_count; i++)
    959c:	e3a03000 	mov	r3, #0
    95a0:	e50b3010 	str	r3, [fp, #-16]
/home/trefil/sem/sources/userspace/Model/Model.cpp:253 (discriminator 3)
    95a4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    95a8:	e5933014 	ldr	r3, [r3, #20]
    95ac:	e51b2010 	ldr	r2, [fp, #-16]
    95b0:	e1520003 	cmp	r2, r3
    95b4:	aa000011 	bge	9600 <_ZN5Model8MutationEPP9Tribesman+0xb4>
/home/trefil/sem/sources/userspace/Model/Model.cpp:254 (discriminator 2)
        population[i]->parameters[parameter_to_mutate] = random->Get_Float();
    95b8:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    95bc:	e593102c 	ldr	r1, [r3, #44]	; 0x2c
    95c0:	e51b3010 	ldr	r3, [fp, #-16]
    95c4:	e1a03103 	lsl	r3, r3, #2
    95c8:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    95cc:	e0823003 	add	r3, r2, r3
    95d0:	e5934000 	ldr	r4, [r3]
    95d4:	e1a00001 	mov	r0, r1
    95d8:	eb00023a 	bl	9ec8 <_ZN16Random_Generator9Get_FloatEv>
    95dc:	eef07a40 	vmov.f32	s15, s0
    95e0:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    95e4:	e1a03103 	lsl	r3, r3, #2
    95e8:	e0843003 	add	r3, r4, r3
    95ec:	edc37a00 	vstr	s15, [r3]
/home/trefil/sem/sources/userspace/Model/Model.cpp:253 (discriminator 2)
    for(int i = 0; i < population_count; i++)
    95f0:	e51b3010 	ldr	r3, [fp, #-16]
    95f4:	e2833001 	add	r3, r3, #1
    95f8:	e50b3010 	str	r3, [fp, #-16]
    95fc:	eaffffe8 	b	95a4 <_ZN5Model8MutationEPP9Tribesman+0x58>
/home/trefil/sem/sources/userspace/Model/Model.cpp:256

}
    9600:	e320f000 	nop	{0}
    9604:	e24bd008 	sub	sp, fp, #8
    9608:	e8bd8810 	pop	{r4, fp, pc}
    960c:	66666667 	strbtvs	r6, [r6], -r7, ror #12

00009610 <_ZN5Model11Prompt_UserEv>:
_ZN5Model11Prompt_UserEv():
/home/trefil/sem/sources/userspace/Model/Model.cpp:258
//vizualni pobidnuti uzivatele k zadani vstupu
void Model::Prompt_User(){
    9610:	e92d4800 	push	{fp, lr}
    9614:	e28db004 	add	fp, sp, #4
    9618:	e24dd008 	sub	sp, sp, #8
    961c:	e50b0008 	str	r0, [fp, #-8]
/home/trefil/sem/sources/userspace/Model/Model.cpp:259
    this->bfr->Write_Line(">");
    9620:	e51b3008 	ldr	r3, [fp, #-8]
    9624:	e5933030 	ldr	r3, [r3, #48]	; 0x30
    9628:	e59f1010 	ldr	r1, [pc, #16]	; 9640 <_ZN5Model11Prompt_UserEv+0x30>
    962c:	e1a00003 	mov	r0, r3
    9630:	eb00028e 	bl	a070 <_ZN6Buffer10Write_LineEPKc>
/home/trefil/sem/sources/userspace/Model/Model.cpp:260
}
    9634:	e320f000 	nop	{0}
    9638:	e24bd004 	sub	sp, fp, #4
    963c:	e8bd8800 	pop	{fp, pc}
    9640:	0000c004 	andeq	ip, r0, r4

00009644 <_ZN5Model3RunEv>:
_ZN5Model3RunEv():
/home/trefil/sem/sources/userspace/Model/Model.cpp:263

//main loop of the task
void Model::Run(){
    9644:	e92d4800 	push	{fp, lr}
    9648:	e28db004 	add	fp, sp, #4
    964c:	e24dd038 	sub	sp, sp, #56	; 0x38
    9650:	e50b0038 	str	r0, [fp, #-56]	; 0xffffffc8
/home/trefil/sem/sources/userspace/Model/Model.cpp:267
    char float_buffer[20];
    //main loop of the program
    while(1){
        Prompt_User();
    9654:	e51b0038 	ldr	r0, [fp, #-56]	; 0xffffffc8
    9658:	ebffffec 	bl	9610 <_ZN5Model11Prompt_UserEv>
/home/trefil/sem/sources/userspace/Model/Model.cpp:269
        //pokud nefitim, tak spim a dotazuju se, jestli neco neni na uartu
        while(!is_fitting){
    965c:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    9660:	e5d33018 	ldrb	r3, [r3, #24]
    9664:	e3530000 	cmp	r3, #0
    9668:	1a000003 	bne	967c <_ZN5Model3RunEv+0x38>
/home/trefil/sem/sources/userspace/Model/Model.cpp:270
            asm volatile("wfi");
    966c:	e320f003 	wfi
/home/trefil/sem/sources/userspace/Model/Model.cpp:271
            Checkpoint();
    9670:	e51b0038 	ldr	r0, [fp, #-56]	; 0xffffffc8
    9674:	ebffff70 	bl	943c <_ZN5Model10CheckpointEv>
/home/trefil/sem/sources/userspace/Model/Model.cpp:269
        while(!is_fitting){
    9678:	eafffff7 	b	965c <_ZN5Model3RunEv+0x18>
/home/trefil/sem/sources/userspace/Model/Model.cpp:273
        }
        bool not_enough_data = false;
    967c:	e3a03000 	mov	r3, #0
    9680:	e54b3005 	strb	r3, [fp, #-5]
/home/trefil/sem/sources/userspace/Model/Model.cpp:274
        bfr->Write_Line("Pocitam...\n");
    9684:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    9688:	e5933030 	ldr	r3, [r3, #48]	; 0x30
    968c:	e59f1280 	ldr	r1, [pc, #640]	; 9914 <_ZN5Model3RunEv+0x2d0>
    9690:	e1a00003 	mov	r0, r3
    9694:	eb000275 	bl	a070 <_ZN6Buffer10Write_LineEPKc>
/home/trefil/sem/sources/userspace/Model/Model.cpp:276
    //let pres vsechny epochy
        for(int i = 0; i < epoch_count; i++){
    9698:	e3a03000 	mov	r3, #0
    969c:	e50b300c 	str	r3, [fp, #-12]
/home/trefil/sem/sources/userspace/Model/Model.cpp:276 (discriminator 1)
    96a0:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    96a4:	e5933020 	ldr	r3, [r3, #32]
    96a8:	e51b200c 	ldr	r2, [fp, #-12]
    96ac:	e1520003 	cmp	r2, r3
    96b0:	aa00006c 	bge	9868 <_ZN5Model3RunEv+0x224>
/home/trefil/sem/sources/userspace/Model/Model.cpp:278
            //kontroluji, jestli neprisel stop prikaz, pokud jo, zastavuji vypocet
            if(!is_fitting)break;
    96b4:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    96b8:	e5d33018 	ldrb	r3, [r3, #24]
    96bc:	e2233001 	eor	r3, r3, #1
    96c0:	e6ef3073 	uxtb	r3, r3
    96c4:	e3530000 	cmp	r3, #0
    96c8:	1a000063 	bne	985c <_ZN5Model3RunEv+0x218>
/home/trefil/sem/sources/userspace/Model/Model.cpp:279
            for(int i = 0; i < population_count; i++){
    96cc:	e3a03000 	mov	r3, #0
    96d0:	e50b3010 	str	r3, [fp, #-16]
/home/trefil/sem/sources/userspace/Model/Model.cpp:279 (discriminator 1)
    96d4:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    96d8:	e5933014 	ldr	r3, [r3, #20]
    96dc:	e51b2010 	ldr	r2, [fp, #-16]
    96e0:	e1520003 	cmp	r2, r3
    96e4:	aa000030 	bge	97ac <_ZN5Model3RunEv+0x168>
/home/trefil/sem/sources/userspace/Model/Model.cpp:281
                //predikuj
                Predict(population[i]);
    96e8:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    96ec:	e5932024 	ldr	r2, [r3, #36]	; 0x24
    96f0:	e51b3010 	ldr	r3, [fp, #-16]
    96f4:	e1a03103 	lsl	r3, r3, #2
    96f8:	e0823003 	add	r3, r2, r3
    96fc:	e5933000 	ldr	r3, [r3]
    9700:	e1a01003 	mov	r1, r3
    9704:	e51b0038 	ldr	r0, [fp, #-56]	; 0xffffffc8
    9708:	ebfffc2f 	bl	87cc <_ZN5Model7PredictEP9Tribesman>
/home/trefil/sem/sources/userspace/Model/Model.cpp:283
                //ohodnot spravnost reseni
                float f = Calculate_Fitness(population[i]);
    970c:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    9710:	e5932024 	ldr	r2, [r3, #36]	; 0x24
    9714:	e51b3010 	ldr	r3, [fp, #-16]
    9718:	e1a03103 	lsl	r3, r3, #2
    971c:	e0823003 	add	r3, r2, r3
    9720:	e5933000 	ldr	r3, [r3]
    9724:	e1a01003 	mov	r1, r3
    9728:	e51b0038 	ldr	r0, [fp, #-56]	; 0xffffffc8
    972c:	ebfffc4b 	bl	8860 <_ZN5Model17Calculate_FitnessEP9Tribesman>
    9730:	ed0b0a06 	vstr	s0, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/userspace/Model/Model.cpp:284
                if(f == EMPTY){
    9734:	ed5b7a06 	vldr	s15, [fp, #-24]	; 0xffffffe8
    9738:	ed9f7a74 	vldr	s14, [pc, #464]	; 9910 <_ZN5Model3RunEv+0x2cc>
    973c:	eef47a47 	vcmp.f32	s15, s14
    9740:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    9744:	1a00000a 	bne	9774 <_ZN5Model3RunEv+0x130>
/home/trefil/sem/sources/userspace/Model/Model.cpp:286
                    //jeste nemam dost dat pro ohodnoceni, utecu
                    bfr->Write_Line("NaN\n");
    9748:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    974c:	e5933030 	ldr	r3, [r3, #48]	; 0x30
    9750:	e59f11c0 	ldr	r1, [pc, #448]	; 9918 <_ZN5Model3RunEv+0x2d4>
    9754:	e1a00003 	mov	r0, r3
    9758:	eb000244 	bl	a070 <_ZN6Buffer10Write_LineEPKc>
/home/trefil/sem/sources/userspace/Model/Model.cpp:288
                    //nastavim priznak, ze nemam dost dat -> nema smysl cokoliv jineho delat
                    not_enough_data = true;
    975c:	e3a03001 	mov	r3, #1
    9760:	e54b3005 	strb	r3, [fp, #-5]
/home/trefil/sem/sources/userspace/Model/Model.cpp:289
                    is_fitting = false;
    9764:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    9768:	e3a02000 	mov	r2, #0
    976c:	e5c32018 	strb	r2, [r3, #24]
/home/trefil/sem/sources/userspace/Model/Model.cpp:290
                    break;
    9770:	ea00000d 	b	97ac <_ZN5Model3RunEv+0x168>
/home/trefil/sem/sources/userspace/Model/Model.cpp:292 (discriminator 2)
                }
                population[i]->fitness = f;
    9774:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    9778:	e5932024 	ldr	r2, [r3, #36]	; 0x24
    977c:	e51b3010 	ldr	r3, [fp, #-16]
    9780:	e1a03103 	lsl	r3, r3, #2
    9784:	e0823003 	add	r3, r2, r3
    9788:	e5933000 	ldr	r3, [r3]
    978c:	e51b2018 	ldr	r2, [fp, #-24]	; 0xffffffe8
    9790:	e5832014 	str	r2, [r3, #20]
/home/trefil/sem/sources/userspace/Model/Model.cpp:293 (discriminator 2)
                Checkpoint();
    9794:	e51b0038 	ldr	r0, [fp, #-56]	; 0xffffffc8
    9798:	ebffff27 	bl	943c <_ZN5Model10CheckpointEv>
/home/trefil/sem/sources/userspace/Model/Model.cpp:279 (discriminator 2)
            for(int i = 0; i < population_count; i++){
    979c:	e51b3010 	ldr	r3, [fp, #-16]
    97a0:	e2833001 	add	r3, r3, #1
    97a4:	e50b3010 	str	r3, [fp, #-16]
    97a8:	eaffffc9 	b	96d4 <_ZN5Model3RunEv+0x90>
/home/trefil/sem/sources/userspace/Model/Model.cpp:295
            }
            if(not_enough_data)break;
    97ac:	e55b3005 	ldrb	r3, [fp, #-5]
    97b0:	e3530000 	cmp	r3, #0
    97b4:	1a00002a 	bne	9864 <_ZN5Model3RunEv+0x220>
/home/trefil/sem/sources/userspace/Model/Model.cpp:298

        //serad od nejlepsich po nejhorsi
            Sort_Tribesman(population,population_count);
    97b8:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    97bc:	e5932024 	ldr	r2, [r3, #36]	; 0x24
    97c0:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    97c4:	e5933014 	ldr	r3, [r3, #20]
    97c8:	e1a01003 	mov	r1, r3
    97cc:	e1a00002 	mov	r0, r2
    97d0:	eb0000f9 	bl	9bbc <_Z14Sort_TribesmanPP9Tribesmani>
/home/trefil/sem/sources/userspace/Model/Model.cpp:301
            //nejlepsiho aktualni populace nastav jako alpha samce

        Set_Alpha(population[0]);
    97d4:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    97d8:	e5933024 	ldr	r3, [r3, #36]	; 0x24
    97dc:	e5933000 	ldr	r3, [r3]
    97e0:	e1a01003 	mov	r1, r3
    97e4:	e51b0038 	ldr	r0, [fp, #-56]	; 0xffffffc8
    97e8:	ebfffcb5 	bl	8ac4 <_ZN5Model9Set_AlphaEP9Tribesman>
/home/trefil/sem/sources/userspace/Model/Model.cpp:306
            //minimalni chyba -- perfektne si to sedne
            //nebo je to dostatecne dobra aproximace
            //if(this->alpha->fitness == 0 || this->alpha->fitness < min_error)
              //  break;
            Checkpoint();
    97ec:	e51b0038 	ldr	r0, [fp, #-56]	; 0xffffffc8
    97f0:	ebffff11 	bl	943c <_ZN5Model10CheckpointEv>
/home/trefil/sem/sources/userspace/Model/Model.cpp:309
            //prekrizi nejsilnejsi

        Gene_Pool_Party(population);
    97f4:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    97f8:	e5933024 	ldr	r3, [r3, #36]	; 0x24
    97fc:	e1a01003 	mov	r1, r3
    9800:	e51b0038 	ldr	r0, [fp, #-56]	; 0xffffffc8
    9804:	ebfffe24 	bl	909c <_ZN5Model15Gene_Pool_PartyEPP9Tribesman>
/home/trefil/sem/sources/userspace/Model/Model.cpp:312
            //mutace

        Mutation(population);
    9808:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    980c:	e5933024 	ldr	r3, [r3, #36]	; 0x24
    9810:	e1a01003 	mov	r1, r3
    9814:	e51b0038 	ldr	r0, [fp, #-56]	; 0xffffffc8
    9818:	ebffff4b 	bl	954c <_ZN5Model8MutationEPP9Tribesman>
/home/trefil/sem/sources/userspace/Model/Model.cpp:313
        Checkpoint();
    981c:	e51b0038 	ldr	r0, [fp, #-56]	; 0xffffffc8
    9820:	ebffff05 	bl	943c <_ZN5Model10CheckpointEv>
/home/trefil/sem/sources/userspace/Model/Model.cpp:315
        //spal nejake CPU cykly -> umyslne zpomaleni vypoctu pro test responzivity uart kanalu
        for(int i = 0; i < 0x88888 * 10;i++)
    9824:	e3a03000 	mov	r3, #0
    9828:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/userspace/Model/Model.cpp:315 (discriminator 3)
    982c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9830:	e59f20e4 	ldr	r2, [pc, #228]	; 991c <_ZN5Model3RunEv+0x2d8>
    9834:	e1530002 	cmp	r3, r2
    9838:	ca000003 	bgt	984c <_ZN5Model3RunEv+0x208>
/home/trefil/sem/sources/userspace/Model/Model.cpp:315 (discriminator 2)
    983c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9840:	e2833001 	add	r3, r3, #1
    9844:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
    9848:	eafffff7 	b	982c <_ZN5Model3RunEv+0x1e8>
/home/trefil/sem/sources/userspace/Model/Model.cpp:276 (discriminator 2)
        for(int i = 0; i < epoch_count; i++){
    984c:	e51b300c 	ldr	r3, [fp, #-12]
    9850:	e2833001 	add	r3, r3, #1
    9854:	e50b300c 	str	r3, [fp, #-12]
    9858:	eaffff90 	b	96a0 <_ZN5Model3RunEv+0x5c>
/home/trefil/sem/sources/userspace/Model/Model.cpp:278
            if(!is_fitting)break;
    985c:	e320f000 	nop	{0}
    9860:	ea000000 	b	9868 <_ZN5Model3RunEv+0x224>
/home/trefil/sem/sources/userspace/Model/Model.cpp:295
            if(not_enough_data)break;
    9864:	e320f000 	nop	{0}
/home/trefil/sem/sources/userspace/Model/Model.cpp:320
            ;
        }
        //pokud nemam data, neni co vypsat
        //pokud uzivatel zastavil vypocet, taky utec
        if(not_enough_data || !is_fitting)continue;
    9868:	e55b3005 	ldrb	r3, [fp, #-5]
    986c:	e3530000 	cmp	r3, #0
    9870:	1a000024 	bne	9908 <_ZN5Model3RunEv+0x2c4>
/home/trefil/sem/sources/userspace/Model/Model.cpp:320 (discriminator 2)
    9874:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    9878:	e5d33018 	ldrb	r3, [r3, #24]
    987c:	e2233001 	eor	r3, r3, #1
    9880:	e6ef3073 	uxtb	r3, r3
    9884:	e3530000 	cmp	r3, #0
    9888:	1a00001e 	bne	9908 <_ZN5Model3RunEv+0x2c4>
/home/trefil/sem/sources/userspace/Model/Model.cpp:322
        //posledni predicted hodnota je odpoved na vstup od uzivatele
        float predicted_value = this->alpha->predicted_values[data_pointer - 1];
    988c:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    9890:	e5933028 	ldr	r3, [r3, #40]	; 0x28
    9894:	e5932018 	ldr	r2, [r3, #24]
    9898:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    989c:	e593301c 	ldr	r3, [r3, #28]
    98a0:	e2433107 	sub	r3, r3, #-1073741823	; 0xc0000001
    98a4:	e1a03103 	lsl	r3, r3, #2
    98a8:	e0823003 	add	r3, r2, r3
    98ac:	e5933000 	ldr	r3, [r3]
    98b0:	e50b301c 	str	r3, [fp, #-28]	; 0xffffffe4
/home/trefil/sem/sources/userspace/Model/Model.cpp:323
        ftoa(predicted_value,float_buffer);
    98b4:	e24b3030 	sub	r3, fp, #48	; 0x30
    98b8:	e1a00003 	mov	r0, r3
    98bc:	ed1b0a07 	vldr	s0, [fp, #-28]	; 0xffffffe4
    98c0:	eb0005f3 	bl	b094 <_Z4ftoafPc>
/home/trefil/sem/sources/userspace/Model/Model.cpp:324
        this->bfr->Write_Line(float_buffer);
    98c4:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    98c8:	e5933030 	ldr	r3, [r3, #48]	; 0x30
    98cc:	e24b2030 	sub	r2, fp, #48	; 0x30
    98d0:	e1a01002 	mov	r1, r2
    98d4:	e1a00003 	mov	r0, r3
    98d8:	eb0001e4 	bl	a070 <_ZN6Buffer10Write_LineEPKc>
/home/trefil/sem/sources/userspace/Model/Model.cpp:325
        this->bfr->Write_Line("\n");
    98dc:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    98e0:	e5933030 	ldr	r3, [r3, #48]	; 0x30
    98e4:	e59f1034 	ldr	r1, [pc, #52]	; 9920 <_ZN5Model3RunEv+0x2dc>
    98e8:	e1a00003 	mov	r0, r3
    98ec:	eb0001df 	bl	a070 <_ZN6Buffer10Write_LineEPKc>
/home/trefil/sem/sources/userspace/Model/Model.cpp:326
        float_buffer[0] = '\0';
    98f0:	e3a03000 	mov	r3, #0
    98f4:	e54b3030 	strb	r3, [fp, #-48]	; 0xffffffd0
/home/trefil/sem/sources/userspace/Model/Model.cpp:328
        //dopocital jsem, nastavim vlajecku
        is_fitting = false;
    98f8:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    98fc:	e3a02000 	mov	r2, #0
    9900:	e5c32018 	strb	r2, [r3, #24]
    9904:	eaffff52 	b	9654 <_ZN5Model3RunEv+0x10>
/home/trefil/sem/sources/userspace/Model/Model.cpp:320
        if(not_enough_data || !is_fitting)continue;
    9908:	e320f000 	nop	{0}
/home/trefil/sem/sources/userspace/Model/Model.cpp:329
    }
    990c:	eaffff50 	b	9654 <_ZN5Model3RunEv+0x10>
    9910:	c2280000 	eorgt	r0, r8, #0
    9914:	0000c008 	andeq	ip, r0, r8
    9918:	0000c014 	andeq	ip, r0, r4, lsl r0
    991c:	0055554f 	subseq	r5, r5, pc, asr #10
    9920:	0000bf7c 	andeq	fp, r0, ip, ror pc

00009924 <_Znaj>:
_Znaj():
/home/trefil/sem/sources/userspace/../stdlib/include/memory.h:14
inline void *operator new(uint32_t, void *p)
{
    return p;
}
inline void *operator new[](uint32_t size)
{
    9924:	e92d4800 	push	{fp, lr}
    9928:	e28db004 	add	fp, sp, #4
    992c:	e24dd008 	sub	sp, sp, #8
    9930:	e50b0008 	str	r0, [fp, #-8]
/home/trefil/sem/sources/userspace/../stdlib/include/memory.h:15
    return h.Alloc(size);
    9934:	e51b1008 	ldr	r1, [fp, #-8]
    9938:	e59f0010 	ldr	r0, [pc, #16]	; 9950 <_Znaj+0x2c>
    993c:	eb0000e4 	bl	9cd4 <_ZN12Heap_Manager5AllocEj>
    9940:	e1a03000 	mov	r3, r0
/home/trefil/sem/sources/userspace/../stdlib/include/memory.h:16
}
    9944:	e1a00003 	mov	r0, r3
    9948:	e24bd004 	sub	sp, fp, #4
    994c:	e8bd8800 	pop	{fp, pc}
    9950:	0000c0dc 	ldrdeq	ip, [r0], -ip	; <UNPREDICTABLE>

00009954 <_Z6mallocj>:
_Z6mallocj():
/home/trefil/sem/sources/userspace/../stdlib/include/memory.h:18

inline void* malloc(uint32_t size){
    9954:	e92d4800 	push	{fp, lr}
    9958:	e28db004 	add	fp, sp, #4
    995c:	e24dd008 	sub	sp, sp, #8
    9960:	e50b0008 	str	r0, [fp, #-8]
/home/trefil/sem/sources/userspace/../stdlib/include/memory.h:19
    return h.Alloc(size);
    9964:	e51b1008 	ldr	r1, [fp, #-8]
    9968:	e59f0010 	ldr	r0, [pc, #16]	; 9980 <_Z6mallocj+0x2c>
    996c:	eb0000d8 	bl	9cd4 <_ZN12Heap_Manager5AllocEj>
    9970:	e1a03000 	mov	r3, r0
/home/trefil/sem/sources/userspace/../stdlib/include/memory.h:20
    9974:	e1a00003 	mov	r0, r3
    9978:	e24bd004 	sub	sp, fp, #4
    997c:	e8bd8800 	pop	{fp, pc}
    9980:	0000c0dc 	ldrdeq	ip, [r0], -ip	; <UNPREDICTABLE>

00009984 <_Z5splitPP9Tribesmanii>:
_Z5splitPP9Tribesmanii():
/home/trefil/sem/sources/userspace/Model/Sort.cpp:4
#include <Sort.h>


int split(Tribesman** tribesman,  int left,  int right){
    9984:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9988:	e28db000 	add	fp, sp, #0
    998c:	e24dd01c 	sub	sp, sp, #28
    9990:	e50b0010 	str	r0, [fp, #-16]
    9994:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    9998:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/userspace/Model/Sort.cpp:5
    Tribesman* pivot = tribesman[right];
    999c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    99a0:	e1a03103 	lsl	r3, r3, #2
    99a4:	e51b2010 	ldr	r2, [fp, #-16]
    99a8:	e0823003 	add	r3, r2, r3
    99ac:	e5933000 	ldr	r3, [r3]
    99b0:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/userspace/Model/Sort.cpp:8
    while(1){
        //dokud je left pointer mensi jak right a prvky jsou mensi jak pivot, tak se hybej
        while((left < right) && (tribesman[left]->fitness < pivot->fitness))
    99b4:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    99b8:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    99bc:	e1520003 	cmp	r2, r3
    99c0:	aa000014 	bge	9a18 <_Z5splitPP9Tribesmanii+0x94>
/home/trefil/sem/sources/userspace/Model/Sort.cpp:8 (discriminator 1)
    99c4:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    99c8:	e1a03103 	lsl	r3, r3, #2
    99cc:	e51b2010 	ldr	r2, [fp, #-16]
    99d0:	e0823003 	add	r3, r2, r3
    99d4:	e5933000 	ldr	r3, [r3]
    99d8:	ed937a05 	vldr	s14, [r3, #20]
    99dc:	e51b3008 	ldr	r3, [fp, #-8]
    99e0:	edd37a05 	vldr	s15, [r3, #20]
    99e4:	eeb47ae7 	vcmpe.f32	s14, s15
    99e8:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    99ec:	43a03001 	movmi	r3, #1
    99f0:	53a03000 	movpl	r3, #0
    99f4:	e6ef3073 	uxtb	r3, r3
    99f8:	e2233001 	eor	r3, r3, #1
    99fc:	e6ef3073 	uxtb	r3, r3
    9a00:	e3530000 	cmp	r3, #0
    9a04:	1a000003 	bne	9a18 <_Z5splitPP9Tribesmanii+0x94>
/home/trefil/sem/sources/userspace/Model/Sort.cpp:9
                left++;
    9a08:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9a0c:	e2833001 	add	r3, r3, #1
    9a10:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/userspace/Model/Sort.cpp:8
        while((left < right) && (tribesman[left]->fitness < pivot->fitness))
    9a14:	eaffffe6 	b	99b4 <_Z5splitPP9Tribesmanii+0x30>
/home/trefil/sem/sources/userspace/Model/Sort.cpp:11
        //nasel jsem misto na swap, hod left na right
        if(left<right){
    9a18:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    9a1c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9a20:	e1520003 	cmp	r2, r3
    9a24:	aa000037 	bge	9b08 <_Z5splitPP9Tribesmanii+0x184>
/home/trefil/sem/sources/userspace/Model/Sort.cpp:12
            tribesman[right] = tribesman[left];
    9a28:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9a2c:	e1a03103 	lsl	r3, r3, #2
    9a30:	e51b2010 	ldr	r2, [fp, #-16]
    9a34:	e0822003 	add	r2, r2, r3
    9a38:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9a3c:	e1a03103 	lsl	r3, r3, #2
    9a40:	e51b1010 	ldr	r1, [fp, #-16]
    9a44:	e0813003 	add	r3, r1, r3
    9a48:	e5922000 	ldr	r2, [r2]
    9a4c:	e5832000 	str	r2, [r3]
/home/trefil/sem/sources/userspace/Model/Sort.cpp:13
            right--;
    9a50:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9a54:	e2433001 	sub	r3, r3, #1
    9a58:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/userspace/Model/Sort.cpp:17
        }else //v teto casti pole uz nemuzu nic vymenit
            break;
        //logika stejna, jenom hybu right pointerem, ne left pointerem
        while((left < right) && (tribesman[right]->fitness > pivot->fitness))
    9a5c:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    9a60:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9a64:	e1520003 	cmp	r2, r3
    9a68:	aa000014 	bge	9ac0 <_Z5splitPP9Tribesmanii+0x13c>
/home/trefil/sem/sources/userspace/Model/Sort.cpp:17 (discriminator 1)
    9a6c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9a70:	e1a03103 	lsl	r3, r3, #2
    9a74:	e51b2010 	ldr	r2, [fp, #-16]
    9a78:	e0823003 	add	r3, r2, r3
    9a7c:	e5933000 	ldr	r3, [r3]
    9a80:	ed937a05 	vldr	s14, [r3, #20]
    9a84:	e51b3008 	ldr	r3, [fp, #-8]
    9a88:	edd37a05 	vldr	s15, [r3, #20]
    9a8c:	eeb47ae7 	vcmpe.f32	s14, s15
    9a90:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    9a94:	c3a03001 	movgt	r3, #1
    9a98:	d3a03000 	movle	r3, #0
    9a9c:	e6ef3073 	uxtb	r3, r3
    9aa0:	e2233001 	eor	r3, r3, #1
    9aa4:	e6ef3073 	uxtb	r3, r3
    9aa8:	e3530000 	cmp	r3, #0
    9aac:	1a000003 	bne	9ac0 <_Z5splitPP9Tribesmanii+0x13c>
/home/trefil/sem/sources/userspace/Model/Sort.cpp:18
            right--;
    9ab0:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9ab4:	e2433001 	sub	r3, r3, #1
    9ab8:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/userspace/Model/Sort.cpp:17
        while((left < right) && (tribesman[right]->fitness > pivot->fitness))
    9abc:	eaffffe6 	b	9a5c <_Z5splitPP9Tribesmanii+0xd8>
/home/trefil/sem/sources/userspace/Model/Sort.cpp:19
        if(left<right){
    9ac0:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    9ac4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9ac8:	e1520003 	cmp	r2, r3
    9acc:	aa00000f 	bge	9b10 <_Z5splitPP9Tribesmanii+0x18c>
/home/trefil/sem/sources/userspace/Model/Sort.cpp:20
            tribesman[left] = tribesman[right];
    9ad0:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9ad4:	e1a03103 	lsl	r3, r3, #2
    9ad8:	e51b2010 	ldr	r2, [fp, #-16]
    9adc:	e0822003 	add	r2, r2, r3
    9ae0:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9ae4:	e1a03103 	lsl	r3, r3, #2
    9ae8:	e51b1010 	ldr	r1, [fp, #-16]
    9aec:	e0813003 	add	r3, r1, r3
    9af0:	e5922000 	ldr	r2, [r2]
    9af4:	e5832000 	str	r2, [r3]
/home/trefil/sem/sources/userspace/Model/Sort.cpp:21
            left++;
    9af8:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9afc:	e2833001 	add	r3, r3, #1
    9b00:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/userspace/Model/Sort.cpp:8
        while((left < right) && (tribesman[left]->fitness < pivot->fitness))
    9b04:	eaffffaa 	b	99b4 <_Z5splitPP9Tribesmanii+0x30>
/home/trefil/sem/sources/userspace/Model/Sort.cpp:15
            break;
    9b08:	e320f000 	nop	{0}
    9b0c:	ea000000 	b	9b14 <_Z5splitPP9Tribesmanii+0x190>
/home/trefil/sem/sources/userspace/Model/Sort.cpp:22
        }else break;
    9b10:	e320f000 	nop	{0}
/home/trefil/sem/sources/userspace/Model/Sort.cpp:25
    }
    //na left bude dira pro pivotni prvek
    tribesman[left] = pivot;
    9b14:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9b18:	e1a03103 	lsl	r3, r3, #2
    9b1c:	e51b2010 	ldr	r2, [fp, #-16]
    9b20:	e0823003 	add	r3, r2, r3
    9b24:	e51b2008 	ldr	r2, [fp, #-8]
    9b28:	e5832000 	str	r2, [r3]
/home/trefil/sem/sources/userspace/Model/Sort.cpp:27
    //vrat split index
    return left;
    9b2c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/userspace/Model/Sort.cpp:29

}
    9b30:	e1a00003 	mov	r0, r3
    9b34:	e28bd000 	add	sp, fp, #0
    9b38:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9b3c:	e12fff1e 	bx	lr

00009b40 <_Z4sortPP9Tribesmanii>:
_Z4sortPP9Tribesmanii():
/home/trefil/sem/sources/userspace/Model/Sort.cpp:32

//serad borce podle jejich fitness
void sort(Tribesman** tribesman,  int start,  int end){
    9b40:	e92d4800 	push	{fp, lr}
    9b44:	e28db004 	add	fp, sp, #4
    9b48:	e24dd018 	sub	sp, sp, #24
    9b4c:	e50b0010 	str	r0, [fp, #-16]
    9b50:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    9b54:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/userspace/Model/Sort.cpp:33
    if(start >= end)return;
    9b58:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    9b5c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9b60:	e1520003 	cmp	r2, r3
    9b64:	aa000011 	bge	9bb0 <_Z4sortPP9Tribesmanii+0x70>
/home/trefil/sem/sources/userspace/Model/Sort.cpp:35
    //misto, kde se nam pole rozpadne na dve "podpole", ktere se budou radit
    int index = split(tribesman,start,end);
    9b68:	e51b2018 	ldr	r2, [fp, #-24]	; 0xffffffe8
    9b6c:	e51b1014 	ldr	r1, [fp, #-20]	; 0xffffffec
    9b70:	e51b0010 	ldr	r0, [fp, #-16]
    9b74:	ebffff82 	bl	9984 <_Z5splitPP9Tribesmanii>
    9b78:	e50b0008 	str	r0, [fp, #-8]
/home/trefil/sem/sources/userspace/Model/Sort.cpp:38
    //vime, ze pivotni prvek uz je na spravnem miste, tedy vsechny prvky index-1 jsou mensi a index+1 jsou vetsi
    //nebudu jej proto uz kontrolovat
    sort(tribesman,start,index - 1);
    9b7c:	e51b3008 	ldr	r3, [fp, #-8]
    9b80:	e2433001 	sub	r3, r3, #1
    9b84:	e1a02003 	mov	r2, r3
    9b88:	e51b1014 	ldr	r1, [fp, #-20]	; 0xffffffec
    9b8c:	e51b0010 	ldr	r0, [fp, #-16]
    9b90:	ebffffea 	bl	9b40 <_Z4sortPP9Tribesmanii>
/home/trefil/sem/sources/userspace/Model/Sort.cpp:39
    sort(tribesman,index+1,end);
    9b94:	e51b3008 	ldr	r3, [fp, #-8]
    9b98:	e2833001 	add	r3, r3, #1
    9b9c:	e51b2018 	ldr	r2, [fp, #-24]	; 0xffffffe8
    9ba0:	e1a01003 	mov	r1, r3
    9ba4:	e51b0010 	ldr	r0, [fp, #-16]
    9ba8:	ebffffe4 	bl	9b40 <_Z4sortPP9Tribesmanii>
    9bac:	ea000000 	b	9bb4 <_Z4sortPP9Tribesmanii+0x74>
/home/trefil/sem/sources/userspace/Model/Sort.cpp:33
    if(start >= end)return;
    9bb0:	e320f000 	nop	{0}
/home/trefil/sem/sources/userspace/Model/Sort.cpp:40
}
    9bb4:	e24bd004 	sub	sp, fp, #4
    9bb8:	e8bd8800 	pop	{fp, pc}

00009bbc <_Z14Sort_TribesmanPP9Tribesmani>:
_Z14Sort_TribesmanPP9Tribesmani():
/home/trefil/sem/sources/userspace/Model/Sort.cpp:44

//jakysi qsort pro serazeni
//prepis do nerekurzivni verze vhodny pro RTOS
void Sort_Tribesman(Tribesman** tribesman,  int len){
    9bbc:	e92d4800 	push	{fp, lr}
    9bc0:	e28db004 	add	fp, sp, #4
    9bc4:	e24dd008 	sub	sp, sp, #8
    9bc8:	e50b0008 	str	r0, [fp, #-8]
    9bcc:	e50b100c 	str	r1, [fp, #-12]
/home/trefil/sem/sources/userspace/Model/Sort.cpp:45
    sort(tribesman,0,len-1);
    9bd0:	e51b300c 	ldr	r3, [fp, #-12]
    9bd4:	e2433001 	sub	r3, r3, #1
    9bd8:	e1a02003 	mov	r2, r3
    9bdc:	e3a01000 	mov	r1, #0
    9be0:	e51b0008 	ldr	r0, [fp, #-8]
    9be4:	ebffffd5 	bl	9b40 <_Z4sortPP9Tribesmanii>
/home/trefil/sem/sources/userspace/Model/Sort.cpp:46
    9be8:	e320f000 	nop	{0}
    9bec:	e24bd004 	sub	sp, fp, #4
    9bf0:	e8bd8800 	pop	{fp, pc}

00009bf4 <_ZN12Heap_ManagerC1Ev>:
_ZN12Heap_ManagerC2Ev():
/home/trefil/sem/sources/stdlib/src/Heap_Manager.cpp:6
#include <Heap_Manager.h>

//spravce pameti na halde uzivatelskeho procesu
//inkrementalni alokace a neumi free
//aby umel free nejak rozumne, nutne implementovat napriklad seznamem der/procesu nebo buddy systemem
Heap_Manager::Heap_Manager(){};
    9bf4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9bf8:	e28db000 	add	fp, sp, #0
    9bfc:	e24dd00c 	sub	sp, sp, #12
    9c00:	e50b0008 	str	r0, [fp, #-8]
    9c04:	e51b3008 	ldr	r3, [fp, #-8]
    9c08:	e3a02000 	mov	r2, #0
    9c0c:	e5832000 	str	r2, [r3]
    9c10:	e51b3008 	ldr	r3, [fp, #-8]
    9c14:	e3a02000 	mov	r2, #0
    9c18:	e5832004 	str	r2, [r3, #4]
    9c1c:	e51b3008 	ldr	r3, [fp, #-8]
    9c20:	e3a02a21 	mov	r2, #135168	; 0x21000
    9c24:	e5832008 	str	r2, [r3, #8]
    9c28:	e51b3008 	ldr	r3, [fp, #-8]
    9c2c:	e1a00003 	mov	r0, r3
    9c30:	e28bd000 	add	sp, fp, #0
    9c34:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9c38:	e12fff1e 	bx	lr

00009c3c <_ZN12Heap_Manager4SbrkEv>:
_ZN12Heap_Manager4SbrkEv():
/home/trefil/sem/sources/stdlib/src/Heap_Manager.cpp:8
//syscall pro prideleni pameti na halde od kernelu
void Heap_Manager::Sbrk(){
    9c3c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9c40:	e28db000 	add	fp, sp, #0
    9c44:	e24dd014 	sub	sp, sp, #20
    9c48:	e50b0010 	str	r0, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/Heap_Manager.cpp:12

    uint32_t rdnum;
    //uint32_t increment_count = Get_Increment_Count();
    asm volatile("mov r0, %0" : : "r" (increment_size));
    9c4c:	e51b3010 	ldr	r3, [fp, #-16]
    9c50:	e5933008 	ldr	r3, [r3, #8]
    9c54:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/Heap_Manager.cpp:13
    asm volatile("swi 6");
    9c58:	ef000006 	svc	0x00000006
/home/trefil/sem/sources/stdlib/src/Heap_Manager.cpp:14
    asm volatile("mov %0, r0" : "=r" (rdnum));
    9c5c:	e1a03000 	mov	r3, r0
    9c60:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/Heap_Manager.cpp:17
    //pokud je to muj prvni kus haldy, vrat pointer na zacatek haldy
    //dal si tohle ukazovatko spravuje stdlib sam
    if(mem_address == 0)
    9c64:	e51b3010 	ldr	r3, [fp, #-16]
    9c68:	e5933000 	ldr	r3, [r3]
    9c6c:	e3530000 	cmp	r3, #0
    9c70:	1a000002 	bne	9c80 <_ZN12Heap_Manager4SbrkEv+0x44>
/home/trefil/sem/sources/stdlib/src/Heap_Manager.cpp:18
        mem_address = rdnum;
    9c74:	e51b3010 	ldr	r3, [fp, #-16]
    9c78:	e51b2008 	ldr	r2, [fp, #-8]
    9c7c:	e5832000 	str	r2, [r3]
/home/trefil/sem/sources/stdlib/src/Heap_Manager.cpp:19
    remainder += increment_size;
    9c80:	e51b3010 	ldr	r3, [fp, #-16]
    9c84:	e5932004 	ldr	r2, [r3, #4]
    9c88:	e51b3010 	ldr	r3, [fp, #-16]
    9c8c:	e5933008 	ldr	r3, [r3, #8]
    9c90:	e0822003 	add	r2, r2, r3
    9c94:	e51b3010 	ldr	r3, [fp, #-16]
    9c98:	e5832004 	str	r2, [r3, #4]
/home/trefil/sem/sources/stdlib/src/Heap_Manager.cpp:20
}
    9c9c:	e320f000 	nop	{0}
    9ca0:	e28bd000 	add	sp, fp, #0
    9ca4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9ca8:	e12fff1e 	bx	lr

00009cac <_ZN12Heap_Manager15Get_Mem_AddressEv>:
_ZN12Heap_Manager15Get_Mem_AddressEv():
/home/trefil/sem/sources/stdlib/src/Heap_Manager.cpp:23
//dej mi aktualni adresu, kam chces zapisovat na halde
//pouzito pro pripadny debugging
uint32_t Heap_Manager::Get_Mem_Address(){
    9cac:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9cb0:	e28db000 	add	fp, sp, #0
    9cb4:	e24dd00c 	sub	sp, sp, #12
    9cb8:	e50b0008 	str	r0, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/Heap_Manager.cpp:24
    return mem_address;
    9cbc:	e51b3008 	ldr	r3, [fp, #-8]
    9cc0:	e5933000 	ldr	r3, [r3]
/home/trefil/sem/sources/stdlib/src/Heap_Manager.cpp:25
}
    9cc4:	e1a00003 	mov	r0, r3
    9cc8:	e28bd000 	add	sp, fp, #0
    9ccc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9cd0:	e12fff1e 	bx	lr

00009cd4 <_ZN12Heap_Manager5AllocEj>:
_ZN12Heap_Manager5AllocEj():
/home/trefil/sem/sources/stdlib/src/Heap_Manager.cpp:27
//alokuj mi na halde velikost @param size
void* Heap_Manager::Alloc(uint32_t size){
    9cd4:	e92d4800 	push	{fp, lr}
    9cd8:	e28db004 	add	fp, sp, #4
    9cdc:	e24dd010 	sub	sp, sp, #16
    9ce0:	e50b0010 	str	r0, [fp, #-16]
    9ce4:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/stdlib/src/Heap_Manager.cpp:29
    //uz se mi vic nevejde, musim syscallnout, dokud se vejdu
    while(size > remainder)
    9ce8:	e51b3010 	ldr	r3, [fp, #-16]
    9cec:	e5933004 	ldr	r3, [r3, #4]
    9cf0:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    9cf4:	e1520003 	cmp	r2, r3
    9cf8:	9a000002 	bls	9d08 <_ZN12Heap_Manager5AllocEj+0x34>
/home/trefil/sem/sources/stdlib/src/Heap_Manager.cpp:30
        Sbrk();
    9cfc:	e51b0010 	ldr	r0, [fp, #-16]
    9d00:	ebffffcd 	bl	9c3c <_ZN12Heap_Manager4SbrkEv>
/home/trefil/sem/sources/stdlib/src/Heap_Manager.cpp:29
    while(size > remainder)
    9d04:	eafffff7 	b	9ce8 <_ZN12Heap_Manager5AllocEj+0x14>
/home/trefil/sem/sources/stdlib/src/Heap_Manager.cpp:31
    uint32_t address = mem_address;
    9d08:	e51b3010 	ldr	r3, [fp, #-16]
    9d0c:	e5933000 	ldr	r3, [r3]
    9d10:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/Heap_Manager.cpp:32
    mem_address += size;
    9d14:	e51b3010 	ldr	r3, [fp, #-16]
    9d18:	e5932000 	ldr	r2, [r3]
    9d1c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9d20:	e0822003 	add	r2, r2, r3
    9d24:	e51b3010 	ldr	r3, [fp, #-16]
    9d28:	e5832000 	str	r2, [r3]
/home/trefil/sem/sources/stdlib/src/Heap_Manager.cpp:35

    //mam o size pameti mene k dispozici
    remainder -= size;
    9d2c:	e51b3010 	ldr	r3, [fp, #-16]
    9d30:	e5932004 	ldr	r2, [r3, #4]
    9d34:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9d38:	e0422003 	sub	r2, r2, r3
    9d3c:	e51b3010 	ldr	r3, [fp, #-16]
    9d40:	e5832004 	str	r2, [r3, #4]
/home/trefil/sem/sources/stdlib/src/Heap_Manager.cpp:37

    return reinterpret_cast<void*>(address);
    9d44:	e51b3008 	ldr	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/Heap_Manager.cpp:38
}
    9d48:	e1a00003 	mov	r0, r3
    9d4c:	e24bd004 	sub	sp, fp, #4
    9d50:	e8bd8800 	pop	{fp, pc}

00009d54 <_Z41__static_initialization_and_destruction_0ii>:
_Z41__static_initialization_and_destruction_0ii():
/home/trefil/sem/sources/stdlib/src/Heap_Manager.cpp:39
Heap_Manager h;
    9d54:	e92d4800 	push	{fp, lr}
    9d58:	e28db004 	add	fp, sp, #4
    9d5c:	e24dd008 	sub	sp, sp, #8
    9d60:	e50b0008 	str	r0, [fp, #-8]
    9d64:	e50b100c 	str	r1, [fp, #-12]
    9d68:	e51b3008 	ldr	r3, [fp, #-8]
    9d6c:	e3530001 	cmp	r3, #1
    9d70:	1a000005 	bne	9d8c <_Z41__static_initialization_and_destruction_0ii+0x38>
/home/trefil/sem/sources/stdlib/src/Heap_Manager.cpp:39 (discriminator 1)
    9d74:	e51b300c 	ldr	r3, [fp, #-12]
    9d78:	e59f2018 	ldr	r2, [pc, #24]	; 9d98 <_Z41__static_initialization_and_destruction_0ii+0x44>
    9d7c:	e1530002 	cmp	r3, r2
    9d80:	1a000001 	bne	9d8c <_Z41__static_initialization_and_destruction_0ii+0x38>
/home/trefil/sem/sources/stdlib/src/Heap_Manager.cpp:39 (discriminator 3)
    9d84:	e59f0010 	ldr	r0, [pc, #16]	; 9d9c <_Z41__static_initialization_and_destruction_0ii+0x48>
    9d88:	ebffff99 	bl	9bf4 <_ZN12Heap_ManagerC1Ev>
/home/trefil/sem/sources/stdlib/src/Heap_Manager.cpp:39
    9d8c:	e320f000 	nop	{0}
    9d90:	e24bd004 	sub	sp, fp, #4
    9d94:	e8bd8800 	pop	{fp, pc}
    9d98:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>
    9d9c:	0000c0dc 	ldrdeq	ip, [r0], -ip	; <UNPREDICTABLE>

00009da0 <_GLOBAL__sub_I__ZN12Heap_ManagerC2Ev>:
_GLOBAL__sub_I__ZN12Heap_ManagerC2Ev():
/home/trefil/sem/sources/stdlib/src/Heap_Manager.cpp:39
    9da0:	e92d4800 	push	{fp, lr}
    9da4:	e28db004 	add	fp, sp, #4
    9da8:	e59f1008 	ldr	r1, [pc, #8]	; 9db8 <_GLOBAL__sub_I__ZN12Heap_ManagerC2Ev+0x18>
    9dac:	e3a00001 	mov	r0, #1
    9db0:	ebffffe7 	bl	9d54 <_Z41__static_initialization_and_destruction_0ii>
    9db4:	e8bd8800 	pop	{fp, pc}
    9db8:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>
    9dbc:	00000000 	andeq	r0, r0, r0

00009dc0 <_ZN16Random_GeneratorC1Eiiiii>:
_ZN16Random_GeneratorC2Eiiiii():
/home/trefil/sem/sources/stdlib/src/Random.cpp:5
#include <Random.h>

//pseudorandom generator cisel pro nahodnodnost parametru populace
//neni uplne optimalni nebo idealni, ale pro demonstracni ucely snad ok
Random_Generator::Random_Generator(int min, int max, int a,int c, int seed):
    9dc0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9dc4:	e28db000 	add	fp, sp, #0
    9dc8:	e24dd014 	sub	sp, sp, #20
    9dcc:	e50b0008 	str	r0, [fp, #-8]
    9dd0:	e50b100c 	str	r1, [fp, #-12]
    9dd4:	e50b2010 	str	r2, [fp, #-16]
    9dd8:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/stdlib/src/Random.cpp:6
        a(a),max(max),seed(seed), min(min), c(c)
    9ddc:	e51b3008 	ldr	r3, [fp, #-8]
    9de0:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    9de4:	e5832000 	str	r2, [r3]
    9de8:	e51b3008 	ldr	r3, [fp, #-8]
    9dec:	e59b2004 	ldr	r2, [fp, #4]
    9df0:	e5832004 	str	r2, [r3, #4]
    9df4:	e51b3008 	ldr	r3, [fp, #-8]
    9df8:	e51b200c 	ldr	r2, [fp, #-12]
    9dfc:	e5832008 	str	r2, [r3, #8]
    9e00:	e51b3008 	ldr	r3, [fp, #-8]
    9e04:	e51b2010 	ldr	r2, [fp, #-16]
    9e08:	e583200c 	str	r2, [r3, #12]
    9e0c:	e51b3008 	ldr	r3, [fp, #-8]
    9e10:	e59b2008 	ldr	r2, [fp, #8]
    9e14:	e5832010 	str	r2, [r3, #16]
    9e18:	e51b3008 	ldr	r3, [fp, #-8]
    9e1c:	e3a02000 	mov	r2, #0
    9e20:	e5832018 	str	r2, [r3, #24]
/home/trefil/sem/sources/stdlib/src/Random.cpp:7
{}
    9e24:	e51b3008 	ldr	r3, [fp, #-8]
    9e28:	e1a00003 	mov	r0, r3
    9e2c:	e28bd000 	add	sp, fp, #0
    9e30:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9e34:	e12fff1e 	bx	lr

00009e38 <_ZN16Random_Generator7Get_IntEv>:
_ZN16Random_Generator7Get_IntEv():
/home/trefil/sem/sources/stdlib/src/Random.cpp:10

//TODO lepsi random engine
int Random_Generator::Get_Int(){
    9e38:	e92d4800 	push	{fp, lr}
    9e3c:	e28db004 	add	fp, sp, #4
    9e40:	e24dd010 	sub	sp, sp, #16
    9e44:	e50b0010 	str	r0, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/Random.cpp:11
    if(previously_generated == 0)
    9e48:	e51b3010 	ldr	r3, [fp, #-16]
    9e4c:	e5933018 	ldr	r3, [r3, #24]
    9e50:	e3530000 	cmp	r3, #0
    9e54:	1a000003 	bne	9e68 <_ZN16Random_Generator7Get_IntEv+0x30>
/home/trefil/sem/sources/stdlib/src/Random.cpp:12
        previously_generated = seed;
    9e58:	e51b3010 	ldr	r3, [fp, #-16]
    9e5c:	e5932010 	ldr	r2, [r3, #16]
    9e60:	e51b3010 	ldr	r3, [fp, #-16]
    9e64:	e5832018 	str	r2, [r3, #24]
/home/trefil/sem/sources/stdlib/src/Random.cpp:13
    int tmp = (a*previously_generated + c );
    9e68:	e51b3010 	ldr	r3, [fp, #-16]
    9e6c:	e5933000 	ldr	r3, [r3]
    9e70:	e51b2010 	ldr	r2, [fp, #-16]
    9e74:	e5922018 	ldr	r2, [r2, #24]
    9e78:	e0020392 	mul	r2, r2, r3
    9e7c:	e51b3010 	ldr	r3, [fp, #-16]
    9e80:	e5933004 	ldr	r3, [r3, #4]
    9e84:	e0823003 	add	r3, r2, r3
    9e88:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/Random.cpp:14
    int numero = tmp % max;
    9e8c:	e51b3010 	ldr	r3, [fp, #-16]
    9e90:	e593200c 	ldr	r2, [r3, #12]
    9e94:	e51b3008 	ldr	r3, [fp, #-8]
    9e98:	e1a01002 	mov	r1, r2
    9e9c:	e1a00003 	mov	r0, r3
    9ea0:	eb000650 	bl	b7e8 <__aeabi_idivmod>
    9ea4:	e1a03001 	mov	r3, r1
    9ea8:	e50b300c 	str	r3, [fp, #-12]
/home/trefil/sem/sources/stdlib/src/Random.cpp:17


    previously_generated = numero;
    9eac:	e51b3010 	ldr	r3, [fp, #-16]
    9eb0:	e51b200c 	ldr	r2, [fp, #-12]
    9eb4:	e5832018 	str	r2, [r3, #24]
/home/trefil/sem/sources/stdlib/src/Random.cpp:18
    return numero;
    9eb8:	e51b300c 	ldr	r3, [fp, #-12]
/home/trefil/sem/sources/stdlib/src/Random.cpp:19
}
    9ebc:	e1a00003 	mov	r0, r3
    9ec0:	e24bd004 	sub	sp, fp, #4
    9ec4:	e8bd8800 	pop	{fp, pc}

00009ec8 <_ZN16Random_Generator9Get_FloatEv>:
_ZN16Random_Generator9Get_FloatEv():
/home/trefil/sem/sources/stdlib/src/Random.cpp:23


//vrat float v intervalu <min,max>
float Random_Generator::Get_Float() {
    9ec8:	e92d4800 	push	{fp, lr}
    9ecc:	e28db004 	add	fp, sp, #4
    9ed0:	e24dd010 	sub	sp, sp, #16
    9ed4:	e50b0010 	str	r0, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/Random.cpp:24
    int rand = Get_Int();
    9ed8:	e51b0010 	ldr	r0, [fp, #-16]
    9edc:	ebffffd5 	bl	9e38 <_ZN16Random_Generator7Get_IntEv>
    9ee0:	e50b0008 	str	r0, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/Random.cpp:25
    float rand_float = rand / 1000.0;
    9ee4:	e51b3008 	ldr	r3, [fp, #-8]
    9ee8:	ee073a90 	vmov	s15, r3
    9eec:	eeb86be7 	vcvt.f64.s32	d6, s15
    9ef0:	ed9f5b08 	vldr	d5, [pc, #32]	; 9f18 <_ZN16Random_Generator9Get_FloatEv+0x50>
    9ef4:	ee867b05 	vdiv.f64	d7, d6, d5
    9ef8:	eef77bc7 	vcvt.f32.f64	s15, d7
    9efc:	ed4b7a03 	vstr	s15, [fp, #-12]
/home/trefil/sem/sources/stdlib/src/Random.cpp:26
    return rand_float;
    9f00:	e51b300c 	ldr	r3, [fp, #-12]
    9f04:	ee073a90 	vmov	s15, r3
/home/trefil/sem/sources/stdlib/src/Random.cpp:27
    9f08:	eeb00a67 	vmov.f32	s0, s15
    9f0c:	e24bd004 	sub	sp, fp, #4
    9f10:	e8bd8800 	pop	{fp, pc}
    9f14:	e320f000 	nop	{0}
    9f18:	00000000 	andeq	r0, r0, r0
    9f1c:	408f4000 	addmi	r4, pc, r0

00009f20 <_ZN6BufferC1Ej>:
_ZN6BufferC2Ej():
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:6
#include <stdbuffer.h>




Buffer::Buffer(uint32_t file_desc):file(file_desc){};
    9f20:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9f24:	e28db000 	add	fp, sp, #0
    9f28:	e24dd00c 	sub	sp, sp, #12
    9f2c:	e50b0008 	str	r0, [fp, #-8]
    9f30:	e50b100c 	str	r1, [fp, #-12]
    9f34:	e51b3008 	ldr	r3, [fp, #-8]
    9f38:	e3a02000 	mov	r2, #0
    9f3c:	e5832000 	str	r2, [r3]
    9f40:	e51b3008 	ldr	r3, [fp, #-8]
    9f44:	e3a02000 	mov	r2, #0
    9f48:	e5832004 	str	r2, [r3, #4]
    9f4c:	e51b3008 	ldr	r3, [fp, #-8]
    9f50:	e51b200c 	ldr	r2, [fp, #-12]
    9f54:	e5832088 	str	r2, [r3, #136]	; 0x88
    9f58:	e51b3008 	ldr	r3, [fp, #-8]
    9f5c:	e1a00003 	mov	r0, r3
    9f60:	e28bd000 	add	sp, fp, #0
    9f64:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9f68:	e12fff1e 	bx	lr

00009f6c <_ZN6Buffer8Is_EmptyEv>:
_ZN6Buffer8Is_EmptyEv():
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:9

//jsem prazdny?
bool Buffer::Is_Empty(){
    9f6c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9f70:	e28db000 	add	fp, sp, #0
    9f74:	e24dd00c 	sub	sp, sp, #12
    9f78:	e50b0008 	str	r0, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:10
    return read_pointer == write_pointer;
    9f7c:	e51b3008 	ldr	r3, [fp, #-8]
    9f80:	e5932000 	ldr	r2, [r3]
    9f84:	e51b3008 	ldr	r3, [fp, #-8]
    9f88:	e5933004 	ldr	r3, [r3, #4]
    9f8c:	e1520003 	cmp	r2, r3
    9f90:	03a03001 	moveq	r3, #1
    9f94:	13a03000 	movne	r3, #0
    9f98:	e6ef3073 	uxtb	r3, r3
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:11
}
    9f9c:	e1a00003 	mov	r0, r3
    9fa0:	e28bd000 	add	sp, fp, #0
    9fa4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9fa8:	e12fff1e 	bx	lr

00009fac <_ZN6Buffer7Is_FullEv>:
_ZN6Buffer7Is_FullEv():
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:13
//jsem plny?
bool Buffer::Is_Full(){
    9fac:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9fb0:	e28db000 	add	fp, sp, #0
    9fb4:	e24dd00c 	sub	sp, sp, #12
    9fb8:	e50b0008 	str	r0, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:14
    return write_pointer == buffer_size;
    9fbc:	e51b3008 	ldr	r3, [fp, #-8]
    9fc0:	e5933004 	ldr	r3, [r3, #4]
    9fc4:	e3530080 	cmp	r3, #128	; 0x80
    9fc8:	03a03001 	moveq	r3, #1
    9fcc:	13a03000 	movne	r3, #0
    9fd0:	e6ef3073 	uxtb	r3, r3
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:15
}
    9fd4:	e1a00003 	mov	r0, r3
    9fd8:	e28bd000 	add	sp, fp, #0
    9fdc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9fe0:	e12fff1e 	bx	lr

00009fe4 <_ZN6Buffer8Add_ByteEc>:
_ZN6Buffer8Add_ByteEc():
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:17
//pridej byte do bufferu
void Buffer::Add_Byte(char c){
    9fe4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9fe8:	e28db000 	add	fp, sp, #0
    9fec:	e24dd00c 	sub	sp, sp, #12
    9ff0:	e50b0008 	str	r0, [fp, #-8]
    9ff4:	e1a03001 	mov	r3, r1
    9ff8:	e54b3009 	strb	r3, [fp, #-9]
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:18
    out_buffer[write_pointer] = c;
    9ffc:	e51b3008 	ldr	r3, [fp, #-8]
    a000:	e5933004 	ldr	r3, [r3, #4]
    a004:	e51b2008 	ldr	r2, [fp, #-8]
    a008:	e0823003 	add	r3, r2, r3
    a00c:	e55b2009 	ldrb	r2, [fp, #-9]
    a010:	e5c3208c 	strb	r2, [r3, #140]	; 0x8c
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:19
    write_pointer++;
    a014:	e51b3008 	ldr	r3, [fp, #-8]
    a018:	e5933004 	ldr	r3, [r3, #4]
    a01c:	e2832001 	add	r2, r3, #1
    a020:	e51b3008 	ldr	r3, [fp, #-8]
    a024:	e5832004 	str	r2, [r3, #4]
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:20
}
    a028:	e320f000 	nop	{0}
    a02c:	e28bd000 	add	sp, fp, #0
    a030:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    a034:	e12fff1e 	bx	lr

0000a038 <_ZN6Buffer5ClearEv>:
_ZN6Buffer5ClearEv():
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:22
//vycisti buffer
void Buffer::Clear(){
    a038:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    a03c:	e28db000 	add	fp, sp, #0
    a040:	e24dd00c 	sub	sp, sp, #12
    a044:	e50b0008 	str	r0, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:23
    read_pointer = 0;
    a048:	e51b3008 	ldr	r3, [fp, #-8]
    a04c:	e3a02000 	mov	r2, #0
    a050:	e5832000 	str	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:24
    write_pointer = 0;
    a054:	e51b3008 	ldr	r3, [fp, #-8]
    a058:	e3a02000 	mov	r2, #0
    a05c:	e5832004 	str	r2, [r3, #4]
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:25
}
    a060:	e320f000 	nop	{0}
    a064:	e28bd000 	add	sp, fp, #0
    a068:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    a06c:	e12fff1e 	bx	lr

0000a070 <_ZN6Buffer10Write_LineEPKc>:
_ZN6Buffer10Write_LineEPKc():
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:28
//vypis na uart
//vlastne neni write line, ale write, endline znak to neposila, pokud neni obsazen v retezci
void Buffer::Write_Line(const char* str){
    a070:	e92d4810 	push	{r4, fp, lr}
    a074:	e28db008 	add	fp, sp, #8
    a078:	e24dd00c 	sub	sp, sp, #12
    a07c:	e50b0010 	str	r0, [fp, #-16]
    a080:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:29
    write(file, str, strlen(str));
    a084:	e51b3010 	ldr	r3, [fp, #-16]
    a088:	e5934088 	ldr	r4, [r3, #136]	; 0x88
    a08c:	e51b0014 	ldr	r0, [fp, #-20]	; 0xffffffec
    a090:	eb000335 	bl	ad6c <_Z6strlenPKc>
    a094:	e1a03000 	mov	r3, r0
    a098:	e1a02003 	mov	r2, r3
    a09c:	e51b1014 	ldr	r1, [fp, #-20]	; 0xffffffec
    a0a0:	e1a00004 	mov	r0, r4
    a0a4:	eb0000e3 	bl	a438 <_Z5writejPKcj>
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:30
}
    a0a8:	e320f000 	nop	{0}
    a0ac:	e24bd008 	sub	sp, fp, #8
    a0b0:	e8bd8810 	pop	{r4, fp, pc}

0000a0b4 <_ZN6Buffer14Read_Uart_LineEv>:
_ZN6Buffer14Read_Uart_LineEv():
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:38
//potom vsechny prectete z kernel bufferu nakopiruje do interniho bufferu
//nasledne v tomto bufferu hleda uceleny user input, tedy <neco>\r pro qemu
//pri detekci ucelenho inputu vrati tento input
//jinak vraci nullptr -> uzivatel nic nezadal
//neni blokujici
char* Buffer::Read_Uart_Line(){
    a0b4:	e92d4800 	push	{fp, lr}
    a0b8:	e28db004 	add	fp, sp, #4
    a0bc:	e24dd018 	sub	sp, sp, #24
    a0c0:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:40
    //precti user input na uartu, pokud ho mam kam ulozit
    bool out_buffer_full = Is_Full();
    a0c4:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    a0c8:	ebffffb7 	bl	9fac <_ZN6Buffer7Is_FullEv>
    a0cc:	e1a03000 	mov	r3, r0
    a0d0:	e54b300a 	strb	r3, [fp, #-10]
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:42
    //pokud neni muj output buffer plny - zeptej se jadra, jestli neni neco na uartu
    if(!out_buffer_full){
    a0d4:	e55b300a 	ldrb	r3, [fp, #-10]
    a0d8:	e2233001 	eor	r3, r3, #1
    a0dc:	e6ef3073 	uxtb	r3, r3
    a0e0:	e3530000 	cmp	r3, #0
    a0e4:	0a00000d 	beq	a120 <_ZN6Buffer14Read_Uart_LineEv+0x6c>
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:43
        uint32_t count = read(file,buffer,buffer_size);
    a0e8:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    a0ec:	e5930088 	ldr	r0, [r3, #136]	; 0x88
    a0f0:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    a0f4:	e2833008 	add	r3, r3, #8
    a0f8:	e3a02080 	mov	r2, #128	; 0x80
    a0fc:	e1a01003 	mov	r1, r3
    a100:	eb0000b8 	bl	a3e8 <_Z4readjPcj>
    a104:	e50b0010 	str	r0, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:45
        //neco jsem precetl - vloz do bufferu
        if(count > 0)
    a108:	e51b3010 	ldr	r3, [fp, #-16]
    a10c:	e3530000 	cmp	r3, #0
    a110:	0a000002 	beq	a120 <_ZN6Buffer14Read_Uart_LineEv+0x6c>
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:46
            Add_Bytes(count);
    a114:	e51b1010 	ldr	r1, [fp, #-16]
    a118:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    a11c:	eb00004a 	bl	a24c <_ZN6Buffer9Add_BytesEj>
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:49
        }
    //nic nemam - utec
    if(write_pointer == 0)return nullptr;
    a120:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    a124:	e5933004 	ldr	r3, [r3, #4]
    a128:	e3530000 	cmp	r3, #0
    a12c:	1a000001 	bne	a138 <_ZN6Buffer14Read_Uart_LineEv+0x84>
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:49 (discriminator 1)
    a130:	e3a03000 	mov	r3, #0
    a134:	ea000041 	b	a240 <_ZN6Buffer14Read_Uart_LineEv+0x18c>
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:51
    uint16_t i,j;
    bool line_found = false;
    a138:	e3a03000 	mov	r3, #0
    a13c:	e54b3009 	strb	r3, [fp, #-9]
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:53
    //TODO optimalizace pres read/write pointery, kontroluji znaky, ktere uz jsou zkontrolovane
    for(i = 0; i < write_pointer; i++){
    a140:	e3a03000 	mov	r3, #0
    a144:	e14b30b6 	strh	r3, [fp, #-6]
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:53 (discriminator 1)
    a148:	e15b20b6 	ldrh	r2, [fp, #-6]
    a14c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    a150:	e5933004 	ldr	r3, [r3, #4]
    a154:	e1520003 	cmp	r2, r3
    a158:	2a00000c 	bcs	a190 <_ZN6Buffer14Read_Uart_LineEv+0xdc>
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:54
        if(out_buffer[i] == '\r'){
    a15c:	e15b30b6 	ldrh	r3, [fp, #-6]
    a160:	e51b2018 	ldr	r2, [fp, #-24]	; 0xffffffe8
    a164:	e0823003 	add	r3, r2, r3
    a168:	e5d3308c 	ldrb	r3, [r3, #140]	; 0x8c
    a16c:	e353000d 	cmp	r3, #13
    a170:	1a000002 	bne	a180 <_ZN6Buffer14Read_Uart_LineEv+0xcc>
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:55
            line_found = true;
    a174:	e3a03001 	mov	r3, #1
    a178:	e54b3009 	strb	r3, [fp, #-9]
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:56
            break;
    a17c:	ea000003 	b	a190 <_ZN6Buffer14Read_Uart_LineEv+0xdc>
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:53 (discriminator 2)
    for(i = 0; i < write_pointer; i++){
    a180:	e15b30b6 	ldrh	r3, [fp, #-6]
    a184:	e2833001 	add	r3, r3, #1
    a188:	e14b30b6 	strh	r3, [fp, #-6]
    a18c:	eaffffed 	b	a148 <_ZN6Buffer14Read_Uart_LineEv+0x94>
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:62
        }
    }

    //buffer je plny a zaroven jsem nenasel newline, zacni prepisovat data v bufferu
    //nemelo by nastat pri beznem pouzivani single-task vypoctu
    if(!line_found){
    a190:	e55b3009 	ldrb	r3, [fp, #-9]
    a194:	e2233001 	eor	r3, r3, #1
    a198:	e6ef3073 	uxtb	r3, r3
    a19c:	e3530000 	cmp	r3, #0
    a1a0:	0a000006 	beq	a1c0 <_ZN6Buffer14Read_Uart_LineEv+0x10c>
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:63
        if(out_buffer_full)
    a1a4:	e55b300a 	ldrb	r3, [fp, #-10]
    a1a8:	e3530000 	cmp	r3, #0
    a1ac:	0a000001 	beq	a1b8 <_ZN6Buffer14Read_Uart_LineEv+0x104>
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:64
            Clear();
    a1b0:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    a1b4:	ebffff9f 	bl	a038 <_ZN6Buffer5ClearEv>
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:65
        return nullptr;
    a1b8:	e3a03000 	mov	r3, #0
    a1bc:	ea00001f 	b	a240 <_ZN6Buffer14Read_Uart_LineEv+0x18c>
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:69
    }
    //asi trochu memory hog
    //mozna nevhodne pro RTOS, protoze nemuze garantovat cas alokace na halde / samotnou alokaci
    char* bfr = new char[i];
    a1c0:	e15b30b6 	ldrh	r3, [fp, #-6]
    a1c4:	e1a00003 	mov	r0, r3
    a1c8:	ebfffdd5 	bl	9924 <_Znaj>
    a1cc:	e1a03000 	mov	r3, r0
    a1d0:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:71
    // prekopiruj string a posli ho ven
    for(j = 0; j < i; j++)
    a1d4:	e3a03000 	mov	r3, #0
    a1d8:	e14b30b8 	strh	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:71 (discriminator 3)
    a1dc:	e15b20b8 	ldrh	r2, [fp, #-8]
    a1e0:	e15b30b6 	ldrh	r3, [fp, #-6]
    a1e4:	e1520003 	cmp	r2, r3
    a1e8:	2a00000b 	bcs	a21c <_ZN6Buffer14Read_Uart_LineEv+0x168>
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:72 (discriminator 2)
        bfr[j] = out_buffer[j];
    a1ec:	e15b20b8 	ldrh	r2, [fp, #-8]
    a1f0:	e15b30b8 	ldrh	r3, [fp, #-8]
    a1f4:	e51b1014 	ldr	r1, [fp, #-20]	; 0xffffffec
    a1f8:	e0813003 	add	r3, r1, r3
    a1fc:	e51b1018 	ldr	r1, [fp, #-24]	; 0xffffffe8
    a200:	e0812002 	add	r2, r1, r2
    a204:	e5d2208c 	ldrb	r2, [r2, #140]	; 0x8c
    a208:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:71 (discriminator 2)
    for(j = 0; j < i; j++)
    a20c:	e15b30b8 	ldrh	r3, [fp, #-8]
    a210:	e2833001 	add	r3, r3, #1
    a214:	e14b30b8 	strh	r3, [fp, #-8]
    a218:	eaffffef 	b	a1dc <_ZN6Buffer14Read_Uart_LineEv+0x128>
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:73
    bfr[j] = '\0';
    a21c:	e15b30b8 	ldrh	r3, [fp, #-8]
    a220:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    a224:	e0823003 	add	r3, r2, r3
    a228:	e3a02000 	mov	r2, #0
    a22c:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:76

    //precetl jsem radek vstupu, "flush" buffer
    write_pointer = 0;
    a230:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    a234:	e3a02000 	mov	r2, #0
    a238:	e5832004 	str	r2, [r3, #4]
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:77
    return bfr;
    a23c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:79

    }
    a240:	e1a00003 	mov	r0, r3
    a244:	e24bd004 	sub	sp, fp, #4
    a248:	e8bd8800 	pop	{fp, pc}

0000a24c <_ZN6Buffer9Add_BytesEj>:
_ZN6Buffer9Add_BytesEj():
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:81
//pridej @param len byteu do bufferu
void Buffer::Add_Bytes(uint32_t len){
    a24c:	e92d4800 	push	{fp, lr}
    a250:	e28db004 	add	fp, sp, #4
    a254:	e24dd010 	sub	sp, sp, #16
    a258:	e50b0010 	str	r0, [fp, #-16]
    a25c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:82
    for(uint32_t i = 0; i < len; i++){
    a260:	e3a03000 	mov	r3, #0
    a264:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:82 (discriminator 3)
    a268:	e51b2008 	ldr	r2, [fp, #-8]
    a26c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    a270:	e1520003 	cmp	r2, r3
    a274:	2a00000b 	bcs	a2a8 <_ZN6Buffer9Add_BytesEj+0x5c>
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:83 (discriminator 2)
        Add_Byte(buffer[i]);
    a278:	e51b2010 	ldr	r2, [fp, #-16]
    a27c:	e51b3008 	ldr	r3, [fp, #-8]
    a280:	e0823003 	add	r3, r2, r3
    a284:	e2833008 	add	r3, r3, #8
    a288:	e5d33000 	ldrb	r3, [r3]
    a28c:	e1a01003 	mov	r1, r3
    a290:	e51b0010 	ldr	r0, [fp, #-16]
    a294:	ebffff52 	bl	9fe4 <_ZN6Buffer8Add_ByteEc>
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:82 (discriminator 2)
    for(uint32_t i = 0; i < len; i++){
    a298:	e51b3008 	ldr	r3, [fp, #-8]
    a29c:	e2833001 	add	r3, r3, #1
    a2a0:	e50b3008 	str	r3, [fp, #-8]
    a2a4:	eaffffef 	b	a268 <_ZN6Buffer9Add_BytesEj+0x1c>
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:85
    }
}
    a2a8:	e320f000 	nop	{0}
    a2ac:	e24bd004 	sub	sp, fp, #4
    a2b0:	e8bd8800 	pop	{fp, pc}

0000a2b4 <_ZN6Buffer23Read_Uart_Line_BlockingEi>:
_ZN6Buffer23Read_Uart_Line_BlockingEi():
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:87
//zablokuj se nad ctenim uartu dokud nedostanes user input
char* Buffer::Read_Uart_Line_Blocking(int expected_type){
    a2b4:	e92d4800 	push	{fp, lr}
    a2b8:	e28db004 	add	fp, sp, #4
    a2bc:	e24dd010 	sub	sp, sp, #16
    a2c0:	e50b0010 	str	r0, [fp, #-16]
    a2c4:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:91
    char* line;
    while(1){
        //samotne cteni neni blokuji -> tocime se dokolecka dokola
        line = Read_Uart_Line();
    a2c8:	e51b0010 	ldr	r0, [fp, #-16]
    a2cc:	ebffff78 	bl	a0b4 <_ZN6Buffer14Read_Uart_LineEv>
    a2d0:	e50b0008 	str	r0, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:93
        //prisel mi vstup od uzivatele
        if(line != nullptr){
    a2d4:	e51b3008 	ldr	r3, [fp, #-8]
    a2d8:	e3530000 	cmp	r3, #0
    a2dc:	0a00000b 	beq	a310 <_ZN6Buffer23Read_Uart_Line_BlockingEi+0x5c>
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:95
            //mrkneme se, co je za datovy typ precteny radek od uzivatele
            int type = get_input_type(line);
    a2e0:	e51b0008 	ldr	r0, [fp, #-8]
    a2e4:	eb0001ae 	bl	a9a4 <_Z14get_input_typePKc>
    a2e8:	e50b000c 	str	r0, [fp, #-12]
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:96
            if(type == expected_type)
    a2ec:	e51b200c 	ldr	r2, [fp, #-12]
    a2f0:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    a2f4:	e1520003 	cmp	r2, r3
    a2f8:	0a000006 	beq	a318 <_ZN6Buffer23Read_Uart_Line_BlockingEi+0x64>
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:99
                break;

            Write_Line("Neplatny vstup\n");
    a2fc:	e59f1028 	ldr	r1, [pc, #40]	; a32c <_ZN6Buffer23Read_Uart_Line_BlockingEi+0x78>
    a300:	e51b0010 	ldr	r0, [fp, #-16]
    a304:	ebffff59 	bl	a070 <_ZN6Buffer10Write_LineEPKc>
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:100
            line = nullptr;
    a308:	e3a03000 	mov	r3, #0
    a30c:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:103
        }
        //nic tam nebylo - spi, dokud neprijde IRQ, v pripade semestralky IRQ chodi pouze z UARTU
        asm volatile("wfi");
    a310:	e320f003 	wfi
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:104
    }
    a314:	eaffffeb 	b	a2c8 <_ZN6Buffer23Read_Uart_Line_BlockingEi+0x14>
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:97
                break;
    a318:	e320f000 	nop	{0}
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:105
    return line;
    a31c:	e51b3008 	ldr	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:106
    a320:	e1a00003 	mov	r0, r3
    a324:	e24bd004 	sub	sp, fp, #4
    a328:	e8bd8800 	pop	{fp, pc}
    a32c:	0000c074 	andeq	ip, r0, r4, ror r0

0000a330 <_Z6getpidv>:
_Z6getpidv():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:5
#include <stdfile.h>
#include <stdstring.h>

uint32_t getpid()
{
    a330:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    a334:	e28db000 	add	fp, sp, #0
    a338:	e24dd00c 	sub	sp, sp, #12
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:8
    uint32_t pid;

    asm volatile("swi 0");
    a33c:	ef000000 	svc	0x00000000
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:9
    asm volatile("mov %0, r0" : "=r" (pid));
    a340:	e1a03000 	mov	r3, r0
    a344:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:11

    return pid;
    a348:	e51b3008 	ldr	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:12
}
    a34c:	e1a00003 	mov	r0, r3
    a350:	e28bd000 	add	sp, fp, #0
    a354:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    a358:	e12fff1e 	bx	lr

0000a35c <_Z9terminatei>:
_Z9terminatei():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:15

void terminate(int exitcode)
{
    a35c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    a360:	e28db000 	add	fp, sp, #0
    a364:	e24dd00c 	sub	sp, sp, #12
    a368:	e50b0008 	str	r0, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:16
    asm volatile("mov r0, %0" : : "r" (exitcode));
    a36c:	e51b3008 	ldr	r3, [fp, #-8]
    a370:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:17
    asm volatile("swi 1");
    a374:	ef000001 	svc	0x00000001
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:18
}
    a378:	e320f000 	nop	{0}
    a37c:	e28bd000 	add	sp, fp, #0
    a380:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    a384:	e12fff1e 	bx	lr

0000a388 <_Z11sched_yieldv>:
_Z11sched_yieldv():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:21

void sched_yield()
{
    a388:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    a38c:	e28db000 	add	fp, sp, #0
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:22
    asm volatile("swi 2");
    a390:	ef000002 	svc	0x00000002
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:23
}
    a394:	e320f000 	nop	{0}
    a398:	e28bd000 	add	sp, fp, #0
    a39c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    a3a0:	e12fff1e 	bx	lr

0000a3a4 <_Z4openPKc15NFile_Open_Mode>:
_Z4openPKc15NFile_Open_Mode():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:26

uint32_t open(const char* filename, NFile_Open_Mode mode)
{
    a3a4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    a3a8:	e28db000 	add	fp, sp, #0
    a3ac:	e24dd014 	sub	sp, sp, #20
    a3b0:	e50b0010 	str	r0, [fp, #-16]
    a3b4:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:29
    uint32_t file;

    asm volatile("mov r0, %0" : : "r" (filename));
    a3b8:	e51b3010 	ldr	r3, [fp, #-16]
    a3bc:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:30
    asm volatile("mov r1, %0" : : "r" (mode));
    a3c0:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    a3c4:	e1a01003 	mov	r1, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:31
    asm volatile("swi 64");
    a3c8:	ef000040 	svc	0x00000040
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:32
    asm volatile("mov %0, r0" : "=r" (file));
    a3cc:	e1a03000 	mov	r3, r0
    a3d0:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:34

    return file;
    a3d4:	e51b3008 	ldr	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:35
}
    a3d8:	e1a00003 	mov	r0, r3
    a3dc:	e28bd000 	add	sp, fp, #0
    a3e0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    a3e4:	e12fff1e 	bx	lr

0000a3e8 <_Z4readjPcj>:
_Z4readjPcj():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:38

uint32_t read(uint32_t file, char* const buffer, uint32_t size)
{
    a3e8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    a3ec:	e28db000 	add	fp, sp, #0
    a3f0:	e24dd01c 	sub	sp, sp, #28
    a3f4:	e50b0010 	str	r0, [fp, #-16]
    a3f8:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    a3fc:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:41
    uint32_t rdnum;

    asm volatile("mov r0, %0" : : "r" (file));
    a400:	e51b3010 	ldr	r3, [fp, #-16]
    a404:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:42
    asm volatile("mov r1, %0" : : "r" (buffer));
    a408:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    a40c:	e1a01003 	mov	r1, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:43
    asm volatile("mov r2, %0" : : "r" (size));
    a410:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    a414:	e1a02003 	mov	r2, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:44
    asm volatile("swi 65");
    a418:	ef000041 	svc	0x00000041
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:45
    asm volatile("mov %0, r0" : "=r" (rdnum));
    a41c:	e1a03000 	mov	r3, r0
    a420:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:47

    return rdnum;
    a424:	e51b3008 	ldr	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:48
}
    a428:	e1a00003 	mov	r0, r3
    a42c:	e28bd000 	add	sp, fp, #0
    a430:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    a434:	e12fff1e 	bx	lr

0000a438 <_Z5writejPKcj>:
_Z5writejPKcj():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:52


uint32_t write(uint32_t file, const char* buffer, uint32_t size)
{
    a438:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    a43c:	e28db000 	add	fp, sp, #0
    a440:	e24dd01c 	sub	sp, sp, #28
    a444:	e50b0010 	str	r0, [fp, #-16]
    a448:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    a44c:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:55
    uint32_t wrnum;

    asm volatile("mov r0, %0" : : "r" (file));
    a450:	e51b3010 	ldr	r3, [fp, #-16]
    a454:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:56
    asm volatile("mov r1, %0" : : "r" (buffer));
    a458:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    a45c:	e1a01003 	mov	r1, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:57
    asm volatile("mov r2, %0" : : "r" (size));
    a460:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    a464:	e1a02003 	mov	r2, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:58
    asm volatile("swi 66");
    a468:	ef000042 	svc	0x00000042
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:59
    asm volatile("mov %0, r0" : "=r" (wrnum));
    a46c:	e1a03000 	mov	r3, r0
    a470:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:61

    return wrnum;
    a474:	e51b3008 	ldr	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:62
}
    a478:	e1a00003 	mov	r0, r3
    a47c:	e28bd000 	add	sp, fp, #0
    a480:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    a484:	e12fff1e 	bx	lr

0000a488 <_Z5closej>:
_Z5closej():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:65

void close(uint32_t file)
{
    a488:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    a48c:	e28db000 	add	fp, sp, #0
    a490:	e24dd00c 	sub	sp, sp, #12
    a494:	e50b0008 	str	r0, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:66
    asm volatile("mov r0, %0" : : "r" (file));
    a498:	e51b3008 	ldr	r3, [fp, #-8]
    a49c:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:67
    asm volatile("swi 67");
    a4a0:	ef000043 	svc	0x00000043
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:68
}
    a4a4:	e320f000 	nop	{0}
    a4a8:	e28bd000 	add	sp, fp, #0
    a4ac:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    a4b0:	e12fff1e 	bx	lr

0000a4b4 <_Z5ioctlj16NIOCtl_OperationPv>:
_Z5ioctlj16NIOCtl_OperationPv():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:71

uint32_t ioctl(uint32_t file, NIOCtl_Operation operation, void* param)
{
    a4b4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    a4b8:	e28db000 	add	fp, sp, #0
    a4bc:	e24dd01c 	sub	sp, sp, #28
    a4c0:	e50b0010 	str	r0, [fp, #-16]
    a4c4:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    a4c8:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:74
    uint32_t retcode;

    asm volatile("mov r0, %0" : : "r" (file));
    a4cc:	e51b3010 	ldr	r3, [fp, #-16]
    a4d0:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:75
    asm volatile("mov r1, %0" : : "r" (operation));
    a4d4:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    a4d8:	e1a01003 	mov	r1, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:76
    asm volatile("mov r2, %0" : : "r" (param));
    a4dc:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    a4e0:	e1a02003 	mov	r2, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:77
    asm volatile("swi 68");
    a4e4:	ef000044 	svc	0x00000044
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:78
    asm volatile("mov %0, r0" : "=r" (retcode));
    a4e8:	e1a03000 	mov	r3, r0
    a4ec:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:80

    return retcode;
    a4f0:	e51b3008 	ldr	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:81
}
    a4f4:	e1a00003 	mov	r0, r3
    a4f8:	e28bd000 	add	sp, fp, #0
    a4fc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    a500:	e12fff1e 	bx	lr

0000a504 <_Z6notifyjj>:
_Z6notifyjj():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:84

uint32_t notify(uint32_t file, uint32_t count)
{
    a504:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    a508:	e28db000 	add	fp, sp, #0
    a50c:	e24dd014 	sub	sp, sp, #20
    a510:	e50b0010 	str	r0, [fp, #-16]
    a514:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:87
    uint32_t retcnt;

    asm volatile("mov r0, %0" : : "r" (file));
    a518:	e51b3010 	ldr	r3, [fp, #-16]
    a51c:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:88
    asm volatile("mov r1, %0" : : "r" (count));
    a520:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    a524:	e1a01003 	mov	r1, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:89
    asm volatile("swi 69");
    a528:	ef000045 	svc	0x00000045
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:90
    asm volatile("mov %0, r0" : "=r" (retcnt));
    a52c:	e1a03000 	mov	r3, r0
    a530:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:92

    return retcnt;
    a534:	e51b3008 	ldr	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:93
}
    a538:	e1a00003 	mov	r0, r3
    a53c:	e28bd000 	add	sp, fp, #0
    a540:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    a544:	e12fff1e 	bx	lr

0000a548 <_Z4waitjjj>:
_Z4waitjjj():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:96

NSWI_Result_Code wait(uint32_t file, uint32_t count, uint32_t notified_deadline)
{
    a548:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    a54c:	e28db000 	add	fp, sp, #0
    a550:	e24dd01c 	sub	sp, sp, #28
    a554:	e50b0010 	str	r0, [fp, #-16]
    a558:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    a55c:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:99
    NSWI_Result_Code retcode;

    asm volatile("mov r0, %0" : : "r" (file));
    a560:	e51b3010 	ldr	r3, [fp, #-16]
    a564:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:100
    asm volatile("mov r1, %0" : : "r" (count));
    a568:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    a56c:	e1a01003 	mov	r1, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:101
    asm volatile("mov r2, %0" : : "r" (notified_deadline));
    a570:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    a574:	e1a02003 	mov	r2, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:102
    asm volatile("swi 70");
    a578:	ef000046 	svc	0x00000046
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:103
    asm volatile("mov %0, r0" : "=r" (retcode));
    a57c:	e1a03000 	mov	r3, r0
    a580:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:105

    return retcode;
    a584:	e51b3008 	ldr	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:106
}
    a588:	e1a00003 	mov	r0, r3
    a58c:	e28bd000 	add	sp, fp, #0
    a590:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    a594:	e12fff1e 	bx	lr

0000a598 <_Z5sleepjj>:
_Z5sleepjj():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:109

bool sleep(uint32_t ticks, uint32_t notified_deadline)
{
    a598:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    a59c:	e28db000 	add	fp, sp, #0
    a5a0:	e24dd014 	sub	sp, sp, #20
    a5a4:	e50b0010 	str	r0, [fp, #-16]
    a5a8:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:112
    uint32_t retcode;

    asm volatile("mov r0, %0" : : "r" (ticks));
    a5ac:	e51b3010 	ldr	r3, [fp, #-16]
    a5b0:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:113
    asm volatile("mov r1, %0" : : "r" (notified_deadline));
    a5b4:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    a5b8:	e1a01003 	mov	r1, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:114
    asm volatile("swi 3");
    a5bc:	ef000003 	svc	0x00000003
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:115
    asm volatile("mov %0, r0" : "=r" (retcode));
    a5c0:	e1a03000 	mov	r3, r0
    a5c4:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:117

    return retcode;
    a5c8:	e51b3008 	ldr	r3, [fp, #-8]
    a5cc:	e3530000 	cmp	r3, #0
    a5d0:	13a03001 	movne	r3, #1
    a5d4:	03a03000 	moveq	r3, #0
    a5d8:	e6ef3073 	uxtb	r3, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:118
}
    a5dc:	e1a00003 	mov	r0, r3
    a5e0:	e28bd000 	add	sp, fp, #0
    a5e4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    a5e8:	e12fff1e 	bx	lr

0000a5ec <_Z24get_active_process_countv>:
_Z24get_active_process_countv():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:121

uint32_t get_active_process_count()
{
    a5ec:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    a5f0:	e28db000 	add	fp, sp, #0
    a5f4:	e24dd00c 	sub	sp, sp, #12
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:122
    const NGet_Sched_Info_Type req = NGet_Sched_Info_Type::Active_Process_Count;
    a5f8:	e3a03000 	mov	r3, #0
    a5fc:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:125
    uint32_t retval;

    asm volatile("mov r0, %0" : : "r" (req));
    a600:	e3a03000 	mov	r3, #0
    a604:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:126
    asm volatile("mov r1, %0" : : "r" (&retval));
    a608:	e24b300c 	sub	r3, fp, #12
    a60c:	e1a01003 	mov	r1, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:127
    asm volatile("swi 4");
    a610:	ef000004 	svc	0x00000004
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:129

    return retval;
    a614:	e51b300c 	ldr	r3, [fp, #-12]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:130
}
    a618:	e1a00003 	mov	r0, r3
    a61c:	e28bd000 	add	sp, fp, #0
    a620:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    a624:	e12fff1e 	bx	lr

0000a628 <_Z14get_tick_countv>:
_Z14get_tick_countv():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:133

uint32_t get_tick_count()
{
    a628:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    a62c:	e28db000 	add	fp, sp, #0
    a630:	e24dd00c 	sub	sp, sp, #12
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:134
    const NGet_Sched_Info_Type req = NGet_Sched_Info_Type::Tick_Count;
    a634:	e3a03001 	mov	r3, #1
    a638:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:137
    uint32_t retval;

    asm volatile("mov r0, %0" : : "r" (req));
    a63c:	e3a03001 	mov	r3, #1
    a640:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:138
    asm volatile("mov r1, %0" : : "r" (&retval));
    a644:	e24b300c 	sub	r3, fp, #12
    a648:	e1a01003 	mov	r1, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:139
    asm volatile("swi 4");
    a64c:	ef000004 	svc	0x00000004
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:141

    return retval;
    a650:	e51b300c 	ldr	r3, [fp, #-12]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:142
}
    a654:	e1a00003 	mov	r0, r3
    a658:	e28bd000 	add	sp, fp, #0
    a65c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    a660:	e12fff1e 	bx	lr

0000a664 <_Z17set_task_deadlinej>:
_Z17set_task_deadlinej():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:145

void set_task_deadline(uint32_t tick_count_required)
{
    a664:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    a668:	e28db000 	add	fp, sp, #0
    a66c:	e24dd014 	sub	sp, sp, #20
    a670:	e50b0010 	str	r0, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:146
    const NDeadline_Subservice req = NDeadline_Subservice::Set_Relative;
    a674:	e3a03000 	mov	r3, #0
    a678:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:148

    asm volatile("mov r0, %0" : : "r" (req));
    a67c:	e3a03000 	mov	r3, #0
    a680:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:149
    asm volatile("mov r1, %0" : : "r" (&tick_count_required));
    a684:	e24b3010 	sub	r3, fp, #16
    a688:	e1a01003 	mov	r1, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:150
    asm volatile("swi 5");
    a68c:	ef000005 	svc	0x00000005
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:151
}
    a690:	e320f000 	nop	{0}
    a694:	e28bd000 	add	sp, fp, #0
    a698:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    a69c:	e12fff1e 	bx	lr

0000a6a0 <_Z26get_task_ticks_to_deadlinev>:
_Z26get_task_ticks_to_deadlinev():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:154

uint32_t get_task_ticks_to_deadline()
{
    a6a0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    a6a4:	e28db000 	add	fp, sp, #0
    a6a8:	e24dd00c 	sub	sp, sp, #12
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:155
    const NDeadline_Subservice req = NDeadline_Subservice::Get_Remaining;
    a6ac:	e3a03001 	mov	r3, #1
    a6b0:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:158
    uint32_t ticks;

    asm volatile("mov r0, %0" : : "r" (req));
    a6b4:	e3a03001 	mov	r3, #1
    a6b8:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:159
    asm volatile("mov r1, %0" : : "r" (&ticks));
    a6bc:	e24b300c 	sub	r3, fp, #12
    a6c0:	e1a01003 	mov	r1, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:160
    asm volatile("swi 5");
    a6c4:	ef000005 	svc	0x00000005
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:162

    return ticks;
    a6c8:	e51b300c 	ldr	r3, [fp, #-12]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:163
}
    a6cc:	e1a00003 	mov	r0, r3
    a6d0:	e28bd000 	add	sp, fp, #0
    a6d4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    a6d8:	e12fff1e 	bx	lr

0000a6dc <_Z4pipePKcj>:
_Z4pipePKcj():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:168

const char Pipe_File_Prefix[] = "SYS:pipe/";

uint32_t pipe(const char* name, uint32_t buf_size)
{
    a6dc:	e92d4800 	push	{fp, lr}
    a6e0:	e28db004 	add	fp, sp, #4
    a6e4:	e24dd050 	sub	sp, sp, #80	; 0x50
    a6e8:	e50b0050 	str	r0, [fp, #-80]	; 0xffffffb0
    a6ec:	e50b1054 	str	r1, [fp, #-84]	; 0xffffffac
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:170
    char fname[64];
    strncpy(fname, Pipe_File_Prefix, sizeof(Pipe_File_Prefix));
    a6f0:	e24b3048 	sub	r3, fp, #72	; 0x48
    a6f4:	e3a0200a 	mov	r2, #10
    a6f8:	e59f1088 	ldr	r1, [pc, #136]	; a788 <_Z4pipePKcj+0xac>
    a6fc:	e1a00003 	mov	r0, r3
    a700:	eb00013e 	bl	ac00 <_Z7strncpyPcPKci>
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:171
    strncpy(fname + sizeof(Pipe_File_Prefix), name, sizeof(fname) - sizeof(Pipe_File_Prefix) - 1);
    a704:	e24b3048 	sub	r3, fp, #72	; 0x48
    a708:	e283300a 	add	r3, r3, #10
    a70c:	e3a02035 	mov	r2, #53	; 0x35
    a710:	e51b1050 	ldr	r1, [fp, #-80]	; 0xffffffb0
    a714:	e1a00003 	mov	r0, r3
    a718:	eb000138 	bl	ac00 <_Z7strncpyPcPKci>
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:173

    int ncur = sizeof(Pipe_File_Prefix) + strlen(name);
    a71c:	e51b0050 	ldr	r0, [fp, #-80]	; 0xffffffb0
    a720:	eb000191 	bl	ad6c <_Z6strlenPKc>
    a724:	e1a03000 	mov	r3, r0
    a728:	e283300a 	add	r3, r3, #10
    a72c:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:175

    fname[ncur++] = '#';
    a730:	e51b3008 	ldr	r3, [fp, #-8]
    a734:	e2832001 	add	r2, r3, #1
    a738:	e50b2008 	str	r2, [fp, #-8]
    a73c:	e2433004 	sub	r3, r3, #4
    a740:	e083300b 	add	r3, r3, fp
    a744:	e3a02023 	mov	r2, #35	; 0x23
    a748:	e5432044 	strb	r2, [r3, #-68]	; 0xffffffbc
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:177

    itoa(buf_size, &fname[ncur], 10);
    a74c:	e51b0054 	ldr	r0, [fp, #-84]	; 0xffffffac
    a750:	e24b2048 	sub	r2, fp, #72	; 0x48
    a754:	e51b3008 	ldr	r3, [fp, #-8]
    a758:	e0823003 	add	r3, r2, r3
    a75c:	e3a0200a 	mov	r2, #10
    a760:	e1a01003 	mov	r1, r3
    a764:	eb000009 	bl	a790 <_Z4itoaiPcj>
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:179

    return open(fname, NFile_Open_Mode::Read_Write);
    a768:	e24b3048 	sub	r3, fp, #72	; 0x48
    a76c:	e3a01002 	mov	r1, #2
    a770:	e1a00003 	mov	r0, r3
    a774:	ebffff0a 	bl	a3a4 <_Z4openPKc15NFile_Open_Mode>
    a778:	e1a03000 	mov	r3, r0
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:180
}
    a77c:	e1a00003 	mov	r0, r3
    a780:	e24bd004 	sub	sp, fp, #4
    a784:	e8bd8800 	pop	{fp, pc}
    a788:	0000c0b0 	strheq	ip, [r0], -r0
    a78c:	00000000 	andeq	r0, r0, r0

0000a790 <_Z4itoaiPcj>:
_Z4itoaiPcj():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:9
{
    const char CharConvArr[] = "0123456789ABCDEF";
}

void itoa(int input, char* output, unsigned int base)
{
    a790:	e92d4800 	push	{fp, lr}
    a794:	e28db004 	add	fp, sp, #4
    a798:	e24dd020 	sub	sp, sp, #32
    a79c:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    a7a0:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    a7a4:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:10
    int i = 0;
    a7a8:	e3a03000 	mov	r3, #0
    a7ac:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:11
    int j = 0;
    a7b0:	e3a03000 	mov	r3, #0
    a7b4:	e50b300c 	str	r3, [fp, #-12]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:13

	while (input > 0)
    a7b8:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    a7bc:	e3530000 	cmp	r3, #0
    a7c0:	da000015 	ble	a81c <_Z4itoaiPcj+0x8c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:15
	{
		output[i] = CharConvArr[input % base];
    a7c4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    a7c8:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    a7cc:	e1a00003 	mov	r0, r3
    a7d0:	eb000374 	bl	b5a8 <__aeabi_uidivmod>
    a7d4:	e1a03001 	mov	r3, r1
    a7d8:	e1a01003 	mov	r1, r3
    a7dc:	e51b3008 	ldr	r3, [fp, #-8]
    a7e0:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    a7e4:	e0823003 	add	r3, r2, r3
    a7e8:	e59f2114 	ldr	r2, [pc, #276]	; a904 <_Z4itoaiPcj+0x174>
    a7ec:	e7d22001 	ldrb	r2, [r2, r1]
    a7f0:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:16
		input /= base;
    a7f4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    a7f8:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    a7fc:	e1a00003 	mov	r0, r3
    a800:	eb0002ed 	bl	b3bc <__udivsi3>
    a804:	e1a03000 	mov	r3, r0
    a808:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:17
		i++;
    a80c:	e51b3008 	ldr	r3, [fp, #-8]
    a810:	e2833001 	add	r3, r3, #1
    a814:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:13
	while (input > 0)
    a818:	eaffffe6 	b	a7b8 <_Z4itoaiPcj+0x28>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:20
	}

    if (i == 0)
    a81c:	e51b3008 	ldr	r3, [fp, #-8]
    a820:	e3530000 	cmp	r3, #0
    a824:	1a000007 	bne	a848 <_Z4itoaiPcj+0xb8>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:22
    {
        output[i] = CharConvArr[0];
    a828:	e51b3008 	ldr	r3, [fp, #-8]
    a82c:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    a830:	e0823003 	add	r3, r2, r3
    a834:	e3a02030 	mov	r2, #48	; 0x30
    a838:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:23
        i++;
    a83c:	e51b3008 	ldr	r3, [fp, #-8]
    a840:	e2833001 	add	r3, r3, #1
    a844:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:26
    }

	output[i] = '\0';
    a848:	e51b3008 	ldr	r3, [fp, #-8]
    a84c:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    a850:	e0823003 	add	r3, r2, r3
    a854:	e3a02000 	mov	r2, #0
    a858:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:27
	i--;
    a85c:	e51b3008 	ldr	r3, [fp, #-8]
    a860:	e2433001 	sub	r3, r3, #1
    a864:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:29 (discriminator 2)

	for (j; j <= i/2; j++)
    a868:	e51b3008 	ldr	r3, [fp, #-8]
    a86c:	e1a02fa3 	lsr	r2, r3, #31
    a870:	e0823003 	add	r3, r2, r3
    a874:	e1a030c3 	asr	r3, r3, #1
    a878:	e1a02003 	mov	r2, r3
    a87c:	e51b300c 	ldr	r3, [fp, #-12]
    a880:	e1530002 	cmp	r3, r2
    a884:	ca00001b 	bgt	a8f8 <_Z4itoaiPcj+0x168>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:31 (discriminator 1)
	{
		char c = output[i - j];
    a888:	e51b2008 	ldr	r2, [fp, #-8]
    a88c:	e51b300c 	ldr	r3, [fp, #-12]
    a890:	e0423003 	sub	r3, r2, r3
    a894:	e1a02003 	mov	r2, r3
    a898:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    a89c:	e0833002 	add	r3, r3, r2
    a8a0:	e5d33000 	ldrb	r3, [r3]
    a8a4:	e54b300d 	strb	r3, [fp, #-13]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:32 (discriminator 1)
		output[i - j] = output[j];
    a8a8:	e51b300c 	ldr	r3, [fp, #-12]
    a8ac:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    a8b0:	e0822003 	add	r2, r2, r3
    a8b4:	e51b1008 	ldr	r1, [fp, #-8]
    a8b8:	e51b300c 	ldr	r3, [fp, #-12]
    a8bc:	e0413003 	sub	r3, r1, r3
    a8c0:	e1a01003 	mov	r1, r3
    a8c4:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    a8c8:	e0833001 	add	r3, r3, r1
    a8cc:	e5d22000 	ldrb	r2, [r2]
    a8d0:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:33 (discriminator 1)
		output[j] = c;
    a8d4:	e51b300c 	ldr	r3, [fp, #-12]
    a8d8:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    a8dc:	e0823003 	add	r3, r2, r3
    a8e0:	e55b200d 	ldrb	r2, [fp, #-13]
    a8e4:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:29 (discriminator 1)
	for (j; j <= i/2; j++)
    a8e8:	e51b300c 	ldr	r3, [fp, #-12]
    a8ec:	e2833001 	add	r3, r3, #1
    a8f0:	e50b300c 	str	r3, [fp, #-12]
    a8f4:	eaffffdb 	b	a868 <_Z4itoaiPcj+0xd8>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:36
	}

}
    a8f8:	e320f000 	nop	{0}
    a8fc:	e24bd004 	sub	sp, fp, #4
    a900:	e8bd8800 	pop	{fp, pc}
    a904:	0000c0bc 	strheq	ip, [r0], -ip	; <UNPREDICTABLE>

0000a908 <_Z4atoiPKc>:
_Z4atoiPKc():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:39

int atoi(const char* input)
{
    a908:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    a90c:	e28db000 	add	fp, sp, #0
    a910:	e24dd014 	sub	sp, sp, #20
    a914:	e50b0010 	str	r0, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:40
	int output = 0;
    a918:	e3a03000 	mov	r3, #0
    a91c:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:42

	while (*input != '\0')
    a920:	e51b3010 	ldr	r3, [fp, #-16]
    a924:	e5d33000 	ldrb	r3, [r3]
    a928:	e3530000 	cmp	r3, #0
    a92c:	0a000017 	beq	a990 <_Z4atoiPKc+0x88>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:44
	{
		output *= 10;
    a930:	e51b2008 	ldr	r2, [fp, #-8]
    a934:	e1a03002 	mov	r3, r2
    a938:	e1a03103 	lsl	r3, r3, #2
    a93c:	e0833002 	add	r3, r3, r2
    a940:	e1a03083 	lsl	r3, r3, #1
    a944:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:45
		if (*input > '9' || *input < '0')
    a948:	e51b3010 	ldr	r3, [fp, #-16]
    a94c:	e5d33000 	ldrb	r3, [r3]
    a950:	e3530039 	cmp	r3, #57	; 0x39
    a954:	8a00000d 	bhi	a990 <_Z4atoiPKc+0x88>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:45 (discriminator 1)
    a958:	e51b3010 	ldr	r3, [fp, #-16]
    a95c:	e5d33000 	ldrb	r3, [r3]
    a960:	e353002f 	cmp	r3, #47	; 0x2f
    a964:	9a000009 	bls	a990 <_Z4atoiPKc+0x88>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:48
			break;

		output += *input - '0';
    a968:	e51b3010 	ldr	r3, [fp, #-16]
    a96c:	e5d33000 	ldrb	r3, [r3]
    a970:	e2433030 	sub	r3, r3, #48	; 0x30
    a974:	e51b2008 	ldr	r2, [fp, #-8]
    a978:	e0823003 	add	r3, r2, r3
    a97c:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:50

		input++;
    a980:	e51b3010 	ldr	r3, [fp, #-16]
    a984:	e2833001 	add	r3, r3, #1
    a988:	e50b3010 	str	r3, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:42
	while (*input != '\0')
    a98c:	eaffffe3 	b	a920 <_Z4atoiPKc+0x18>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:53
	}

	return output;
    a990:	e51b3008 	ldr	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:54
}
    a994:	e1a00003 	mov	r0, r3
    a998:	e28bd000 	add	sp, fp, #0
    a99c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    a9a0:	e12fff1e 	bx	lr

0000a9a4 <_Z14get_input_typePKc>:
_Z14get_input_typePKc():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:58
//return 1 pokud int
//return 2 pokud float
//return 0 pokud neni cislo
int get_input_type(const char * input){
    a9a4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    a9a8:	e28db000 	add	fp, sp, #0
    a9ac:	e24dd014 	sub	sp, sp, #20
    a9b0:	e50b0010 	str	r0, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:60
    //existence tecky
    bool dot = false;
    a9b4:	e3a03000 	mov	r3, #0
    a9b8:	e54b3005 	strb	r3, [fp, #-5]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:61
    bool trailing_dot = false;
    a9bc:	e3a03000 	mov	r3, #0
    a9c0:	e54b3006 	strb	r3, [fp, #-6]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:62
    while(*input != '\0'){
    a9c4:	e51b3010 	ldr	r3, [fp, #-16]
    a9c8:	e5d33000 	ldrb	r3, [r3]
    a9cc:	e3530000 	cmp	r3, #0
    a9d0:	0a000023 	beq	aa64 <_Z14get_input_typePKc+0xc0>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:63
        char c = *input;
    a9d4:	e51b3010 	ldr	r3, [fp, #-16]
    a9d8:	e5d33000 	ldrb	r3, [r3]
    a9dc:	e54b3007 	strb	r3, [fp, #-7]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:64
        if(c == '.' && !dot){
    a9e0:	e55b3007 	ldrb	r3, [fp, #-7]
    a9e4:	e353002e 	cmp	r3, #46	; 0x2e
    a9e8:	1a00000c 	bne	aa20 <_Z14get_input_typePKc+0x7c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:64 (discriminator 1)
    a9ec:	e55b3005 	ldrb	r3, [fp, #-5]
    a9f0:	e2233001 	eor	r3, r3, #1
    a9f4:	e6ef3073 	uxtb	r3, r3
    a9f8:	e3530000 	cmp	r3, #0
    a9fc:	0a000007 	beq	aa20 <_Z14get_input_typePKc+0x7c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:65 (discriminator 2)
            dot = true;
    aa00:	e3a03001 	mov	r3, #1
    aa04:	e54b3005 	strb	r3, [fp, #-5]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:66 (discriminator 2)
            trailing_dot = true;
    aa08:	e3a03001 	mov	r3, #1
    aa0c:	e54b3006 	strb	r3, [fp, #-6]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:67 (discriminator 2)
            input++;
    aa10:	e51b3010 	ldr	r3, [fp, #-16]
    aa14:	e2833001 	add	r3, r3, #1
    aa18:	e50b3010 	str	r3, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:68 (discriminator 2)
            continue;
    aa1c:	ea00000f 	b	aa60 <_Z14get_input_typePKc+0xbc>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:71
        }
        //nenumericky znak
        if(c < '0' || c > '9')return 0;
    aa20:	e55b3007 	ldrb	r3, [fp, #-7]
    aa24:	e353002f 	cmp	r3, #47	; 0x2f
    aa28:	9a000002 	bls	aa38 <_Z14get_input_typePKc+0x94>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:71 (discriminator 2)
    aa2c:	e55b3007 	ldrb	r3, [fp, #-7]
    aa30:	e3530039 	cmp	r3, #57	; 0x39
    aa34:	9a000001 	bls	aa40 <_Z14get_input_typePKc+0x9c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:71 (discriminator 3)
    aa38:	e3a03000 	mov	r3, #0
    aa3c:	ea000014 	b	aa94 <_Z14get_input_typePKc+0xf0>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:73
        //retezec obsahuje tecku a numericke znaky -> tecka je "validni", tedy neni to tecka na konci intu napriklad
        if(dot)
    aa40:	e55b3005 	ldrb	r3, [fp, #-5]
    aa44:	e3530000 	cmp	r3, #0
    aa48:	0a000001 	beq	aa54 <_Z14get_input_typePKc+0xb0>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:74
            trailing_dot = false;
    aa4c:	e3a03000 	mov	r3, #0
    aa50:	e54b3006 	strb	r3, [fp, #-6]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:75
    input++;
    aa54:	e51b3010 	ldr	r3, [fp, #-16]
    aa58:	e2833001 	add	r3, r3, #1
    aa5c:	e50b3010 	str	r3, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:62
    while(*input != '\0'){
    aa60:	eaffffd7 	b	a9c4 <_Z14get_input_typePKc+0x20>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:77
    }
    if(trailing_dot)return 0;
    aa64:	e55b3006 	ldrb	r3, [fp, #-6]
    aa68:	e3530000 	cmp	r3, #0
    aa6c:	0a000001 	beq	aa78 <_Z14get_input_typePKc+0xd4>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:77 (discriminator 1)
    aa70:	e3a03000 	mov	r3, #0
    aa74:	ea000006 	b	aa94 <_Z14get_input_typePKc+0xf0>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:79
    //float pokud retezec obsahuje non-trailing tecku, 1 pokud je to int
    return dot? 2:1;
    aa78:	e55b3005 	ldrb	r3, [fp, #-5]
    aa7c:	e3530000 	cmp	r3, #0
    aa80:	0a000001 	beq	aa8c <_Z14get_input_typePKc+0xe8>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:79 (discriminator 1)
    aa84:	e3a03002 	mov	r3, #2
    aa88:	ea000000 	b	aa90 <_Z14get_input_typePKc+0xec>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:79 (discriminator 2)
    aa8c:	e3a03001 	mov	r3, #1
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:79
    aa90:	e320f000 	nop	{0}
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:81

}
    aa94:	e1a00003 	mov	r0, r3
    aa98:	e28bd000 	add	sp, fp, #0
    aa9c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    aaa0:	e12fff1e 	bx	lr

0000aaa4 <_Z4atofPKc>:
_Z4atofPKc():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:85


//string to float
float atof(const char* input){
    aaa4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    aaa8:	e28db000 	add	fp, sp, #0
    aaac:	e24dd03c 	sub	sp, sp, #60	; 0x3c
    aab0:	e50b0038 	str	r0, [fp, #-56]	; 0xffffffc8
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:86
    double output = 0.0;
    aab4:	e3a02000 	mov	r2, #0
    aab8:	e3a03000 	mov	r3, #0
    aabc:	e14b20fc 	strd	r2, [fp, #-12]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:87
    double factor = 10;
    aac0:	e3a02000 	mov	r2, #0
    aac4:	e59f312c 	ldr	r3, [pc, #300]	; abf8 <_Z4atofPKc+0x154>
    aac8:	e14b21fc 	strd	r2, [fp, #-28]	; 0xffffffe4
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:89
    //cast za desetinnou carkou
    double tmp = 0.0;
    aacc:	e3a02000 	mov	r2, #0
    aad0:	e3a03000 	mov	r3, #0
    aad4:	e14b22f4 	strd	r2, [fp, #-36]	; 0xffffffdc
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:90
    int counter = 0;
    aad8:	e3a03000 	mov	r3, #0
    aadc:	e50b3028 	str	r3, [fp, #-40]	; 0xffffffd8
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:91
    int scale = 1;
    aae0:	e3a03001 	mov	r3, #1
    aae4:	e50b3010 	str	r3, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:92
    bool afterDecPoint = false;
    aae8:	e3a03000 	mov	r3, #0
    aaec:	e54b3011 	strb	r3, [fp, #-17]	; 0xffffffef
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:94

    while(*input != '\0'){
    aaf0:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    aaf4:	e5d33000 	ldrb	r3, [r3]
    aaf8:	e3530000 	cmp	r3, #0
    aafc:	0a000034 	beq	abd4 <_Z4atofPKc+0x130>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:95
        if (*input == '.'){
    ab00:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    ab04:	e5d33000 	ldrb	r3, [r3]
    ab08:	e353002e 	cmp	r3, #46	; 0x2e
    ab0c:	1a000005 	bne	ab28 <_Z4atofPKc+0x84>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:96 (discriminator 1)
            afterDecPoint = true;
    ab10:	e3a03001 	mov	r3, #1
    ab14:	e54b3011 	strb	r3, [fp, #-17]	; 0xffffffef
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:97 (discriminator 1)
            input++;
    ab18:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    ab1c:	e2833001 	add	r3, r3, #1
    ab20:	e50b3038 	str	r3, [fp, #-56]	; 0xffffffc8
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:98 (discriminator 1)
            continue;
    ab24:	ea000029 	b	abd0 <_Z4atofPKc+0x12c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:100
        }
        else if (*input > '9' || *input < '0')break;
    ab28:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    ab2c:	e5d33000 	ldrb	r3, [r3]
    ab30:	e3530039 	cmp	r3, #57	; 0x39
    ab34:	8a000026 	bhi	abd4 <_Z4atofPKc+0x130>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:100 (discriminator 1)
    ab38:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    ab3c:	e5d33000 	ldrb	r3, [r3]
    ab40:	e353002f 	cmp	r3, #47	; 0x2f
    ab44:	9a000022 	bls	abd4 <_Z4atofPKc+0x130>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:101
        double val = *input - '0';
    ab48:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    ab4c:	e5d33000 	ldrb	r3, [r3]
    ab50:	e2433030 	sub	r3, r3, #48	; 0x30
    ab54:	ee073a90 	vmov	s15, r3
    ab58:	eeb87be7 	vcvt.f64.s32	d7, s15
    ab5c:	ed0b7b0d 	vstr	d7, [fp, #-52]	; 0xffffffcc
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:102
        if(afterDecPoint){
    ab60:	e55b3011 	ldrb	r3, [fp, #-17]	; 0xffffffef
    ab64:	e3530000 	cmp	r3, #0
    ab68:	0a00000f 	beq	abac <_Z4atofPKc+0x108>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:103
            scale /= 10;
    ab6c:	e51b3010 	ldr	r3, [fp, #-16]
    ab70:	e59f2084 	ldr	r2, [pc, #132]	; abfc <_Z4atofPKc+0x158>
    ab74:	e0c21392 	smull	r1, r2, r2, r3
    ab78:	e1a02142 	asr	r2, r2, #2
    ab7c:	e1a03fc3 	asr	r3, r3, #31
    ab80:	e0423003 	sub	r3, r2, r3
    ab84:	e50b3010 	str	r3, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:104
            output = output + val * scale;
    ab88:	e51b3010 	ldr	r3, [fp, #-16]
    ab8c:	ee073a90 	vmov	s15, r3
    ab90:	eeb86be7 	vcvt.f64.s32	d6, s15
    ab94:	ed1b7b0d 	vldr	d7, [fp, #-52]	; 0xffffffcc
    ab98:	ee267b07 	vmul.f64	d7, d6, d7
    ab9c:	ed1b6b03 	vldr	d6, [fp, #-12]
    aba0:	ee367b07 	vadd.f64	d7, d6, d7
    aba4:	ed0b7b03 	vstr	d7, [fp, #-12]
    aba8:	ea000005 	b	abc4 <_Z4atofPKc+0x120>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:107
        }
        else
            output = output * 10 + val;
    abac:	ed1b7b03 	vldr	d7, [fp, #-12]
    abb0:	ed9f6b0e 	vldr	d6, [pc, #56]	; abf0 <_Z4atofPKc+0x14c>
    abb4:	ee277b06 	vmul.f64	d7, d7, d6
    abb8:	ed1b6b0d 	vldr	d6, [fp, #-52]	; 0xffffffcc
    abbc:	ee367b07 	vadd.f64	d7, d6, d7
    abc0:	ed0b7b03 	vstr	d7, [fp, #-12]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:109

        input++;
    abc4:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    abc8:	e2833001 	add	r3, r3, #1
    abcc:	e50b3038 	str	r3, [fp, #-56]	; 0xffffffc8
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:94
    while(*input != '\0'){
    abd0:	eaffffc6 	b	aaf0 <_Z4atofPKc+0x4c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:111
    }
    return output;
    abd4:	ed1b7b03 	vldr	d7, [fp, #-12]
    abd8:	eef77bc7 	vcvt.f32.f64	s15, d7
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:112
}
    abdc:	eeb00a67 	vmov.f32	s0, s15
    abe0:	e28bd000 	add	sp, fp, #0
    abe4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    abe8:	e12fff1e 	bx	lr
    abec:	e320f000 	nop	{0}
    abf0:	00000000 	andeq	r0, r0, r0
    abf4:	40240000 	eormi	r0, r4, r0
    abf8:	40240000 	eormi	r0, r4, r0
    abfc:	66666667 	strbtvs	r6, [r6], -r7, ror #12

0000ac00 <_Z7strncpyPcPKci>:
_Z7strncpyPcPKci():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:114
char* strncpy(char* dest, const char *src, int num)
{
    ac00:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    ac04:	e28db000 	add	fp, sp, #0
    ac08:	e24dd01c 	sub	sp, sp, #28
    ac0c:	e50b0010 	str	r0, [fp, #-16]
    ac10:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    ac14:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:117
	int i;

	for (i = 0; i < num && src[i] != '\0'; i++)
    ac18:	e3a03000 	mov	r3, #0
    ac1c:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:117 (discriminator 4)
    ac20:	e51b2008 	ldr	r2, [fp, #-8]
    ac24:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    ac28:	e1520003 	cmp	r2, r3
    ac2c:	aa000011 	bge	ac78 <_Z7strncpyPcPKci+0x78>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:117 (discriminator 2)
    ac30:	e51b3008 	ldr	r3, [fp, #-8]
    ac34:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    ac38:	e0823003 	add	r3, r2, r3
    ac3c:	e5d33000 	ldrb	r3, [r3]
    ac40:	e3530000 	cmp	r3, #0
    ac44:	0a00000b 	beq	ac78 <_Z7strncpyPcPKci+0x78>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:118 (discriminator 3)
		dest[i] = src[i];
    ac48:	e51b3008 	ldr	r3, [fp, #-8]
    ac4c:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    ac50:	e0822003 	add	r2, r2, r3
    ac54:	e51b3008 	ldr	r3, [fp, #-8]
    ac58:	e51b1010 	ldr	r1, [fp, #-16]
    ac5c:	e0813003 	add	r3, r1, r3
    ac60:	e5d22000 	ldrb	r2, [r2]
    ac64:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:117 (discriminator 3)
	for (i = 0; i < num && src[i] != '\0'; i++)
    ac68:	e51b3008 	ldr	r3, [fp, #-8]
    ac6c:	e2833001 	add	r3, r3, #1
    ac70:	e50b3008 	str	r3, [fp, #-8]
    ac74:	eaffffe9 	b	ac20 <_Z7strncpyPcPKci+0x20>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:119 (discriminator 2)
	for (; i < num; i++)
    ac78:	e51b2008 	ldr	r2, [fp, #-8]
    ac7c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    ac80:	e1520003 	cmp	r2, r3
    ac84:	aa000008 	bge	acac <_Z7strncpyPcPKci+0xac>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:120 (discriminator 1)
		dest[i] = '\0';
    ac88:	e51b3008 	ldr	r3, [fp, #-8]
    ac8c:	e51b2010 	ldr	r2, [fp, #-16]
    ac90:	e0823003 	add	r3, r2, r3
    ac94:	e3a02000 	mov	r2, #0
    ac98:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:119 (discriminator 1)
	for (; i < num; i++)
    ac9c:	e51b3008 	ldr	r3, [fp, #-8]
    aca0:	e2833001 	add	r3, r3, #1
    aca4:	e50b3008 	str	r3, [fp, #-8]
    aca8:	eafffff2 	b	ac78 <_Z7strncpyPcPKci+0x78>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:122

   return dest;
    acac:	e51b3010 	ldr	r3, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:123
}
    acb0:	e1a00003 	mov	r0, r3
    acb4:	e28bd000 	add	sp, fp, #0
    acb8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    acbc:	e12fff1e 	bx	lr

0000acc0 <_Z7strncmpPKcS0_i>:
_Z7strncmpPKcS0_i():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:126

int strncmp(const char *s1, const char *s2, int num)
{
    acc0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    acc4:	e28db000 	add	fp, sp, #0
    acc8:	e24dd01c 	sub	sp, sp, #28
    accc:	e50b0010 	str	r0, [fp, #-16]
    acd0:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    acd4:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:128
	unsigned char u1, u2;
  	while (num-- > 0)
    acd8:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    acdc:	e2432001 	sub	r2, r3, #1
    ace0:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
    ace4:	e3530000 	cmp	r3, #0
    ace8:	c3a03001 	movgt	r3, #1
    acec:	d3a03000 	movle	r3, #0
    acf0:	e6ef3073 	uxtb	r3, r3
    acf4:	e3530000 	cmp	r3, #0
    acf8:	0a000016 	beq	ad58 <_Z7strncmpPKcS0_i+0x98>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:130
    {
      	u1 = (unsigned char) *s1++;
    acfc:	e51b3010 	ldr	r3, [fp, #-16]
    ad00:	e2832001 	add	r2, r3, #1
    ad04:	e50b2010 	str	r2, [fp, #-16]
    ad08:	e5d33000 	ldrb	r3, [r3]
    ad0c:	e54b3005 	strb	r3, [fp, #-5]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:131
     	u2 = (unsigned char) *s2++;
    ad10:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    ad14:	e2832001 	add	r2, r3, #1
    ad18:	e50b2014 	str	r2, [fp, #-20]	; 0xffffffec
    ad1c:	e5d33000 	ldrb	r3, [r3]
    ad20:	e54b3006 	strb	r3, [fp, #-6]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:132
      	if (u1 != u2)
    ad24:	e55b2005 	ldrb	r2, [fp, #-5]
    ad28:	e55b3006 	ldrb	r3, [fp, #-6]
    ad2c:	e1520003 	cmp	r2, r3
    ad30:	0a000003 	beq	ad44 <_Z7strncmpPKcS0_i+0x84>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:133
        	return u1 - u2;
    ad34:	e55b2005 	ldrb	r2, [fp, #-5]
    ad38:	e55b3006 	ldrb	r3, [fp, #-6]
    ad3c:	e0423003 	sub	r3, r2, r3
    ad40:	ea000005 	b	ad5c <_Z7strncmpPKcS0_i+0x9c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:134
      	if (u1 == '\0')
    ad44:	e55b3005 	ldrb	r3, [fp, #-5]
    ad48:	e3530000 	cmp	r3, #0
    ad4c:	1affffe1 	bne	acd8 <_Z7strncmpPKcS0_i+0x18>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:135
        	return 0;
    ad50:	e3a03000 	mov	r3, #0
    ad54:	ea000000 	b	ad5c <_Z7strncmpPKcS0_i+0x9c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:138
    }

  	return 0;
    ad58:	e3a03000 	mov	r3, #0
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:139
}
    ad5c:	e1a00003 	mov	r0, r3
    ad60:	e28bd000 	add	sp, fp, #0
    ad64:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    ad68:	e12fff1e 	bx	lr

0000ad6c <_Z6strlenPKc>:
_Z6strlenPKc():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:142

int strlen(const char* s)
{
    ad6c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    ad70:	e28db000 	add	fp, sp, #0
    ad74:	e24dd014 	sub	sp, sp, #20
    ad78:	e50b0010 	str	r0, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:143
	int i = 0;
    ad7c:	e3a03000 	mov	r3, #0
    ad80:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:145

	while (s[i] != '\0')
    ad84:	e51b3008 	ldr	r3, [fp, #-8]
    ad88:	e51b2010 	ldr	r2, [fp, #-16]
    ad8c:	e0823003 	add	r3, r2, r3
    ad90:	e5d33000 	ldrb	r3, [r3]
    ad94:	e3530000 	cmp	r3, #0
    ad98:	0a000003 	beq	adac <_Z6strlenPKc+0x40>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:146
		i++;
    ad9c:	e51b3008 	ldr	r3, [fp, #-8]
    ada0:	e2833001 	add	r3, r3, #1
    ada4:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:145
	while (s[i] != '\0')
    ada8:	eafffff5 	b	ad84 <_Z6strlenPKc+0x18>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:148

	return i;
    adac:	e51b3008 	ldr	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:149
}
    adb0:	e1a00003 	mov	r0, r3
    adb4:	e28bd000 	add	sp, fp, #0
    adb8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    adbc:	e12fff1e 	bx	lr

0000adc0 <_Z6strcatPcPKc>:
_Z6strcatPcPKc():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:152
//unsafe varianta
//muze nastat buffer overflow attack
char* strcat(char* dest, const char* src){
    adc0:	e92d4800 	push	{fp, lr}
    adc4:	e28db004 	add	fp, sp, #4
    adc8:	e24dd018 	sub	sp, sp, #24
    adcc:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    add0:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:153
    int n = strlen(src);
    add4:	e51b001c 	ldr	r0, [fp, #-28]	; 0xffffffe4
    add8:	ebffffe3 	bl	ad6c <_Z6strlenPKc>
    addc:	e50b0010 	str	r0, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:154
    int m = strlen(dest);
    ade0:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    ade4:	ebffffe0 	bl	ad6c <_Z6strlenPKc>
    ade8:	e50b0008 	str	r0, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:155
    int walker = 0;
    adec:	e3a03000 	mov	r3, #0
    adf0:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:156
    for(int i = 0;i < n; i++)
    adf4:	e3a03000 	mov	r3, #0
    adf8:	e50b300c 	str	r3, [fp, #-12]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:156 (discriminator 3)
    adfc:	e51b200c 	ldr	r2, [fp, #-12]
    ae00:	e51b3010 	ldr	r3, [fp, #-16]
    ae04:	e1520003 	cmp	r2, r3
    ae08:	aa00000e 	bge	ae48 <_Z6strcatPcPKc+0x88>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:157 (discriminator 2)
        dest[m++] = src[i];
    ae0c:	e51b300c 	ldr	r3, [fp, #-12]
    ae10:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    ae14:	e0822003 	add	r2, r2, r3
    ae18:	e51b3008 	ldr	r3, [fp, #-8]
    ae1c:	e2831001 	add	r1, r3, #1
    ae20:	e50b1008 	str	r1, [fp, #-8]
    ae24:	e1a01003 	mov	r1, r3
    ae28:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    ae2c:	e0833001 	add	r3, r3, r1
    ae30:	e5d22000 	ldrb	r2, [r2]
    ae34:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:156 (discriminator 2)
    for(int i = 0;i < n; i++)
    ae38:	e51b300c 	ldr	r3, [fp, #-12]
    ae3c:	e2833001 	add	r3, r3, #1
    ae40:	e50b300c 	str	r3, [fp, #-12]
    ae44:	eaffffec 	b	adfc <_Z6strcatPcPKc+0x3c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:158
    dest[m] = '\0';
    ae48:	e51b3008 	ldr	r3, [fp, #-8]
    ae4c:	e51b2018 	ldr	r2, [fp, #-24]	; 0xffffffe8
    ae50:	e0823003 	add	r3, r2, r3
    ae54:	e3a02000 	mov	r2, #0
    ae58:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:159
    return dest;
    ae5c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:161

}
    ae60:	e1a00003 	mov	r0, r3
    ae64:	e24bd004 	sub	sp, fp, #4
    ae68:	e8bd8800 	pop	{fp, pc}

0000ae6c <_Z7strncatPcPKci>:
_Z7strncatPcPKci():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:162
char* strncat(char* dest, const char* src,int size){
    ae6c:	e92d4800 	push	{fp, lr}
    ae70:	e28db004 	add	fp, sp, #4
    ae74:	e24dd020 	sub	sp, sp, #32
    ae78:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    ae7c:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    ae80:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:163
    int walker = 0;
    ae84:	e3a03000 	mov	r3, #0
    ae88:	e50b3010 	str	r3, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:165
    //najdi odkud muzeme kopirovat, tedy konec retezce
    int m = strlen(dest);
    ae8c:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    ae90:	ebffffb5 	bl	ad6c <_Z6strlenPKc>
    ae94:	e50b0008 	str	r0, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:167
    //nevejdu se
    if(m >= size)return dest;
    ae98:	e51b2008 	ldr	r2, [fp, #-8]
    ae9c:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    aea0:	e1520003 	cmp	r2, r3
    aea4:	ba000001 	blt	aeb0 <_Z7strncatPcPKci+0x44>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:167 (discriminator 1)
    aea8:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    aeac:	ea000021 	b	af38 <_Z7strncatPcPKci+0xcc>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:169

    for(int i = 0;i < size; i++){
    aeb0:	e3a03000 	mov	r3, #0
    aeb4:	e50b300c 	str	r3, [fp, #-12]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:169 (discriminator 1)
    aeb8:	e51b200c 	ldr	r2, [fp, #-12]
    aebc:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    aec0:	e1520003 	cmp	r2, r3
    aec4:	aa000015 	bge	af20 <_Z7strncatPcPKci+0xb4>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:170
        if(src[i] == '\0')break;
    aec8:	e51b300c 	ldr	r3, [fp, #-12]
    aecc:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    aed0:	e0823003 	add	r3, r2, r3
    aed4:	e5d33000 	ldrb	r3, [r3]
    aed8:	e3530000 	cmp	r3, #0
    aedc:	0a00000e 	beq	af1c <_Z7strncatPcPKci+0xb0>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:171 (discriminator 2)
        dest[m++] = src[i];
    aee0:	e51b300c 	ldr	r3, [fp, #-12]
    aee4:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    aee8:	e0822003 	add	r2, r2, r3
    aeec:	e51b3008 	ldr	r3, [fp, #-8]
    aef0:	e2831001 	add	r1, r3, #1
    aef4:	e50b1008 	str	r1, [fp, #-8]
    aef8:	e1a01003 	mov	r1, r3
    aefc:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    af00:	e0833001 	add	r3, r3, r1
    af04:	e5d22000 	ldrb	r2, [r2]
    af08:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:169 (discriminator 2)
    for(int i = 0;i < size; i++){
    af0c:	e51b300c 	ldr	r3, [fp, #-12]
    af10:	e2833001 	add	r3, r3, #1
    af14:	e50b300c 	str	r3, [fp, #-12]
    af18:	eaffffe6 	b	aeb8 <_Z7strncatPcPKci+0x4c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:170
        if(src[i] == '\0')break;
    af1c:	e320f000 	nop	{0}
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:173
    }
    dest[m] = '\0';
    af20:	e51b3008 	ldr	r3, [fp, #-8]
    af24:	e51b2018 	ldr	r2, [fp, #-24]	; 0xffffffe8
    af28:	e0823003 	add	r3, r2, r3
    af2c:	e3a02000 	mov	r2, #0
    af30:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:174
    return dest;
    af34:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:176

}
    af38:	e1a00003 	mov	r0, r3
    af3c:	e24bd004 	sub	sp, fp, #4
    af40:	e8bd8800 	pop	{fp, pc}

0000af44 <_Z5bzeroPvi>:
_Z5bzeroPvi():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:180


void bzero(void* memory, int length)
{
    af44:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    af48:	e28db000 	add	fp, sp, #0
    af4c:	e24dd014 	sub	sp, sp, #20
    af50:	e50b0010 	str	r0, [fp, #-16]
    af54:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:181
	char* mem = reinterpret_cast<char*>(memory);
    af58:	e51b3010 	ldr	r3, [fp, #-16]
    af5c:	e50b300c 	str	r3, [fp, #-12]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:183

	for (int i = 0; i < length; i++)
    af60:	e3a03000 	mov	r3, #0
    af64:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:183 (discriminator 3)
    af68:	e51b2008 	ldr	r2, [fp, #-8]
    af6c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    af70:	e1520003 	cmp	r2, r3
    af74:	aa000008 	bge	af9c <_Z5bzeroPvi+0x58>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:184 (discriminator 2)
		mem[i] = 0;
    af78:	e51b3008 	ldr	r3, [fp, #-8]
    af7c:	e51b200c 	ldr	r2, [fp, #-12]
    af80:	e0823003 	add	r3, r2, r3
    af84:	e3a02000 	mov	r2, #0
    af88:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:183 (discriminator 2)
	for (int i = 0; i < length; i++)
    af8c:	e51b3008 	ldr	r3, [fp, #-8]
    af90:	e2833001 	add	r3, r3, #1
    af94:	e50b3008 	str	r3, [fp, #-8]
    af98:	eafffff2 	b	af68 <_Z5bzeroPvi+0x24>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:185
}
    af9c:	e320f000 	nop	{0}
    afa0:	e28bd000 	add	sp, fp, #0
    afa4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    afa8:	e12fff1e 	bx	lr

0000afac <_Z6memcpyPKvPvi>:
_Z6memcpyPKvPvi():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:188

void memcpy(const void* src, void* dst, int num)
{
    afac:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    afb0:	e28db000 	add	fp, sp, #0
    afb4:	e24dd024 	sub	sp, sp, #36	; 0x24
    afb8:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    afbc:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    afc0:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:189
	const char* memsrc = reinterpret_cast<const char*>(src);
    afc4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    afc8:	e50b300c 	str	r3, [fp, #-12]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:190
	char* memdst = reinterpret_cast<char*>(dst);
    afcc:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    afd0:	e50b3010 	str	r3, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:192

	for (int i = 0; i < num; i++)
    afd4:	e3a03000 	mov	r3, #0
    afd8:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:192 (discriminator 3)
    afdc:	e51b2008 	ldr	r2, [fp, #-8]
    afe0:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    afe4:	e1520003 	cmp	r2, r3
    afe8:	aa00000b 	bge	b01c <_Z6memcpyPKvPvi+0x70>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:193 (discriminator 2)
		memdst[i] = memsrc[i];
    afec:	e51b3008 	ldr	r3, [fp, #-8]
    aff0:	e51b200c 	ldr	r2, [fp, #-12]
    aff4:	e0822003 	add	r2, r2, r3
    aff8:	e51b3008 	ldr	r3, [fp, #-8]
    affc:	e51b1010 	ldr	r1, [fp, #-16]
    b000:	e0813003 	add	r3, r1, r3
    b004:	e5d22000 	ldrb	r2, [r2]
    b008:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:192 (discriminator 2)
	for (int i = 0; i < num; i++)
    b00c:	e51b3008 	ldr	r3, [fp, #-8]
    b010:	e2833001 	add	r3, r3, #1
    b014:	e50b3008 	str	r3, [fp, #-8]
    b018:	eaffffef 	b	afdc <_Z6memcpyPKvPvi+0x30>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:194
}
    b01c:	e320f000 	nop	{0}
    b020:	e28bd000 	add	sp, fp, #0
    b024:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    b028:	e12fff1e 	bx	lr

0000b02c <_Z4n_tuii>:
_Z4n_tuii():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:199



int n_tu(int number, int count)
{
    b02c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    b030:	e28db000 	add	fp, sp, #0
    b034:	e24dd014 	sub	sp, sp, #20
    b038:	e50b0010 	str	r0, [fp, #-16]
    b03c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:200
    int result = 1;
    b040:	e3a03001 	mov	r3, #1
    b044:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:201
    while(count-- > 0)
    b048:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    b04c:	e2432001 	sub	r2, r3, #1
    b050:	e50b2014 	str	r2, [fp, #-20]	; 0xffffffec
    b054:	e3530000 	cmp	r3, #0
    b058:	c3a03001 	movgt	r3, #1
    b05c:	d3a03000 	movle	r3, #0
    b060:	e6ef3073 	uxtb	r3, r3
    b064:	e3530000 	cmp	r3, #0
    b068:	0a000004 	beq	b080 <_Z4n_tuii+0x54>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:202
        result *= number;
    b06c:	e51b3008 	ldr	r3, [fp, #-8]
    b070:	e51b2010 	ldr	r2, [fp, #-16]
    b074:	e0030392 	mul	r3, r2, r3
    b078:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:201
    while(count-- > 0)
    b07c:	eafffff1 	b	b048 <_Z4n_tuii+0x1c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:204

    return result;
    b080:	e51b3008 	ldr	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:205
}
    b084:	e1a00003 	mov	r0, r3
    b088:	e28bd000 	add	sp, fp, #0
    b08c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    b090:	e12fff1e 	bx	lr

0000b094 <_Z4ftoafPc>:
_Z4ftoafPc():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:209

/*** Convert float to string ***/
void ftoa(float f, char r[])
{
    b094:	e92d4bf0 	push	{r4, r5, r6, r7, r8, r9, fp, lr}
    b098:	e28db01c 	add	fp, sp, #28
    b09c:	e24dd068 	sub	sp, sp, #104	; 0x68
    b0a0:	ed0b0a16 	vstr	s0, [fp, #-88]	; 0xffffffa8
    b0a4:	e50b005c 	str	r0, [fp, #-92]	; 0xffffffa4
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:213
    long long int length, length2, i, number, position, sign;
    float number2;

    sign = -1;   // -1 == positive number
    b0a8:	e3e02000 	mvn	r2, #0
    b0ac:	e3e03000 	mvn	r3, #0
    b0b0:	e14b24fc 	strd	r2, [fp, #-76]	; 0xffffffb4
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:214
    if (f < 0)
    b0b4:	ed5b7a16 	vldr	s15, [fp, #-88]	; 0xffffffa8
    b0b8:	eef57ac0 	vcmpe.f32	s15, #0.0
    b0bc:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    b0c0:	5a000005 	bpl	b0dc <_Z4ftoafPc+0x48>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:216
    {
        sign = '-';
    b0c4:	e3a0202d 	mov	r2, #45	; 0x2d
    b0c8:	e3a03000 	mov	r3, #0
    b0cc:	e14b24fc 	strd	r2, [fp, #-76]	; 0xffffffb4
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:217
        f *= -1;
    b0d0:	ed5b7a16 	vldr	s15, [fp, #-88]	; 0xffffffa8
    b0d4:	eef17a67 	vneg.f32	s15, s15
    b0d8:	ed4b7a16 	vstr	s15, [fp, #-88]	; 0xffffffa8
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:220
    }

    number2 = f;
    b0dc:	e51b3058 	ldr	r3, [fp, #-88]	; 0xffffffa8
    b0e0:	e50b3050 	str	r3, [fp, #-80]	; 0xffffffb0
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:221
    number = f;
    b0e4:	e51b0058 	ldr	r0, [fp, #-88]	; 0xffffffa8
    b0e8:	eb000290 	bl	bb30 <__aeabi_f2lz>
    b0ec:	e1a02000 	mov	r2, r0
    b0f0:	e1a03001 	mov	r3, r1
    b0f4:	e14b23fc 	strd	r2, [fp, #-60]	; 0xffffffc4
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:222
    length = 0;  // Size of decimal part
    b0f8:	e3a02000 	mov	r2, #0
    b0fc:	e3a03000 	mov	r3, #0
    b100:	e14b22f4 	strd	r2, [fp, #-36]	; 0xffffffdc
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:223
    length2 = 0; // Size of tenth
    b104:	e3a02000 	mov	r2, #0
    b108:	e3a03000 	mov	r3, #0
    b10c:	e14b22fc 	strd	r2, [fp, #-44]	; 0xffffffd4
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:226

    /* Calculate length2 tenth part */
    while( (number2 - (float)number) != 0.0 && !((number2 - (float)number) < 0.0) )
    b110:	e14b03dc 	ldrd	r0, [fp, #-60]	; 0xffffffc4
    b114:	eb000231 	bl	b9e0 <__aeabi_l2f>
    b118:	ee070a10 	vmov	s14, r0
    b11c:	ed5b7a14 	vldr	s15, [fp, #-80]	; 0xffffffb0
    b120:	ee777ac7 	vsub.f32	s15, s15, s14
    b124:	eef57a40 	vcmp.f32	s15, #0.0
    b128:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    b12c:	0a00001b 	beq	b1a0 <_Z4ftoafPc+0x10c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:226 (discriminator 1)
    b130:	e14b03dc 	ldrd	r0, [fp, #-60]	; 0xffffffc4
    b134:	eb000229 	bl	b9e0 <__aeabi_l2f>
    b138:	ee070a10 	vmov	s14, r0
    b13c:	ed5b7a14 	vldr	s15, [fp, #-80]	; 0xffffffb0
    b140:	ee777ac7 	vsub.f32	s15, s15, s14
    b144:	eef57ac0 	vcmpe.f32	s15, #0.0
    b148:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    b14c:	4a000013 	bmi	b1a0 <_Z4ftoafPc+0x10c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:228
    {
        number2 = f * (n_tu(10.0, length2 + 1));
    b150:	e51b302c 	ldr	r3, [fp, #-44]	; 0xffffffd4
    b154:	e2833001 	add	r3, r3, #1
    b158:	e1a01003 	mov	r1, r3
    b15c:	e3a0000a 	mov	r0, #10
    b160:	ebffffb1 	bl	b02c <_Z4n_tuii>
    b164:	ee070a90 	vmov	s15, r0
    b168:	eef87ae7 	vcvt.f32.s32	s15, s15
    b16c:	ed1b7a16 	vldr	s14, [fp, #-88]	; 0xffffffa8
    b170:	ee677a27 	vmul.f32	s15, s14, s15
    b174:	ed4b7a14 	vstr	s15, [fp, #-80]	; 0xffffffb0
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:229
        number = number2;
    b178:	e51b0050 	ldr	r0, [fp, #-80]	; 0xffffffb0
    b17c:	eb00026b 	bl	bb30 <__aeabi_f2lz>
    b180:	e1a02000 	mov	r2, r0
    b184:	e1a03001 	mov	r3, r1
    b188:	e14b23fc 	strd	r2, [fp, #-60]	; 0xffffffc4
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:231

        length2++;
    b18c:	e14b22dc 	ldrd	r2, [fp, #-44]	; 0xffffffd4
    b190:	e2926001 	adds	r6, r2, #1
    b194:	e2a37000 	adc	r7, r3, #0
    b198:	e14b62fc 	strd	r6, [fp, #-44]	; 0xffffffd4
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:226
    while( (number2 - (float)number) != 0.0 && !((number2 - (float)number) < 0.0) )
    b19c:	eaffffdb 	b	b110 <_Z4ftoafPc+0x7c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:235
    }

    /* Calculate length decimal part */
    for (length = (f > 1) ? 0 : 1; f > 1; length++)
    b1a0:	ed5b7a16 	vldr	s15, [fp, #-88]	; 0xffffffa8
    b1a4:	ed9f7a82 	vldr	s14, [pc, #520]	; b3b4 <_Z4ftoafPc+0x320>
    b1a8:	eef47ac7 	vcmpe.f32	s15, s14
    b1ac:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    b1b0:	c3a03001 	movgt	r3, #1
    b1b4:	d3a03000 	movle	r3, #0
    b1b8:	e6ef3073 	uxtb	r3, r3
    b1bc:	e2233001 	eor	r3, r3, #1
    b1c0:	e6ef3073 	uxtb	r3, r3
    b1c4:	e6ef3073 	uxtb	r3, r3
    b1c8:	e3a02000 	mov	r2, #0
    b1cc:	e50b3064 	str	r3, [fp, #-100]	; 0xffffff9c
    b1d0:	e50b2060 	str	r2, [fp, #-96]	; 0xffffffa0
    b1d4:	e14b26d4 	ldrd	r2, [fp, #-100]	; 0xffffff9c
    b1d8:	e14b22f4 	strd	r2, [fp, #-36]	; 0xffffffdc
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:235 (discriminator 3)
    b1dc:	ed5b7a16 	vldr	s15, [fp, #-88]	; 0xffffffa8
    b1e0:	ed9f7a73 	vldr	s14, [pc, #460]	; b3b4 <_Z4ftoafPc+0x320>
    b1e4:	eef47ac7 	vcmpe.f32	s15, s14
    b1e8:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    b1ec:	da00000b 	ble	b220 <_Z4ftoafPc+0x18c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:236 (discriminator 2)
        f /= 10;
    b1f0:	ed1b7a16 	vldr	s14, [fp, #-88]	; 0xffffffa8
    b1f4:	eddf6a6f 	vldr	s13, [pc, #444]	; b3b8 <_Z4ftoafPc+0x324>
    b1f8:	eec77a26 	vdiv.f32	s15, s14, s13
    b1fc:	ed4b7a16 	vstr	s15, [fp, #-88]	; 0xffffffa8
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:235 (discriminator 2)
    for (length = (f > 1) ? 0 : 1; f > 1; length++)
    b200:	e14b22d4 	ldrd	r2, [fp, #-36]	; 0xffffffdc
    b204:	e2921001 	adds	r1, r2, #1
    b208:	e50b106c 	str	r1, [fp, #-108]	; 0xffffff94
    b20c:	e2a33000 	adc	r3, r3, #0
    b210:	e50b3068 	str	r3, [fp, #-104]	; 0xffffff98
    b214:	e14b26dc 	ldrd	r2, [fp, #-108]	; 0xffffff94
    b218:	e14b22f4 	strd	r2, [fp, #-36]	; 0xffffffdc
    b21c:	eaffffee 	b	b1dc <_Z4ftoafPc+0x148>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:238

    position = length;
    b220:	e14b22d4 	ldrd	r2, [fp, #-36]	; 0xffffffdc
    b224:	e14b24f4 	strd	r2, [fp, #-68]	; 0xffffffbc
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:239
    length = length + 1 + length2;
    b228:	e14b22d4 	ldrd	r2, [fp, #-36]	; 0xffffffdc
    b22c:	e2924001 	adds	r4, r2, #1
    b230:	e2a35000 	adc	r5, r3, #0
    b234:	e14b22dc 	ldrd	r2, [fp, #-44]	; 0xffffffd4
    b238:	e0921004 	adds	r1, r2, r4
    b23c:	e50b1074 	str	r1, [fp, #-116]	; 0xffffff8c
    b240:	e0a33005 	adc	r3, r3, r5
    b244:	e50b3070 	str	r3, [fp, #-112]	; 0xffffff90
    b248:	e14b27d4 	ldrd	r2, [fp, #-116]	; 0xffffff8c
    b24c:	e14b22f4 	strd	r2, [fp, #-36]	; 0xffffffdc
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:240
    number = number2;
    b250:	e51b0050 	ldr	r0, [fp, #-80]	; 0xffffffb0
    b254:	eb000235 	bl	bb30 <__aeabi_f2lz>
    b258:	e1a02000 	mov	r2, r0
    b25c:	e1a03001 	mov	r3, r1
    b260:	e14b23fc 	strd	r2, [fp, #-60]	; 0xffffffc4
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:241
    if (sign == '-')
    b264:	e14b24dc 	ldrd	r2, [fp, #-76]	; 0xffffffb4
    b268:	e242102d 	sub	r1, r2, #45	; 0x2d
    b26c:	e1913003 	orrs	r3, r1, r3
    b270:	1a00000d 	bne	b2ac <_Z4ftoafPc+0x218>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:243
    {
        length++;
    b274:	e14b22d4 	ldrd	r2, [fp, #-36]	; 0xffffffdc
    b278:	e2921001 	adds	r1, r2, #1
    b27c:	e50b107c 	str	r1, [fp, #-124]	; 0xffffff84
    b280:	e2a33000 	adc	r3, r3, #0
    b284:	e50b3078 	str	r3, [fp, #-120]	; 0xffffff88
    b288:	e14b27dc 	ldrd	r2, [fp, #-124]	; 0xffffff84
    b28c:	e14b22f4 	strd	r2, [fp, #-36]	; 0xffffffdc
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:244
        position++;
    b290:	e14b24d4 	ldrd	r2, [fp, #-68]	; 0xffffffbc
    b294:	e2921001 	adds	r1, r2, #1
    b298:	e50b1084 	str	r1, [fp, #-132]	; 0xffffff7c
    b29c:	e2a33000 	adc	r3, r3, #0
    b2a0:	e50b3080 	str	r3, [fp, #-128]	; 0xffffff80
    b2a4:	e14b28d4 	ldrd	r2, [fp, #-132]	; 0xffffff7c
    b2a8:	e14b24f4 	strd	r2, [fp, #-68]	; 0xffffffbc
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:247
    }

    for (i = length; i >= 0 ; i--)
    b2ac:	e14b22d4 	ldrd	r2, [fp, #-36]	; 0xffffffdc
    b2b0:	e14b23f4 	strd	r2, [fp, #-52]	; 0xffffffcc
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:247 (discriminator 1)
    b2b4:	e14b23d4 	ldrd	r2, [fp, #-52]	; 0xffffffcc
    b2b8:	e3530000 	cmp	r3, #0
    b2bc:	ba000039 	blt	b3a8 <_Z4ftoafPc+0x314>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:249
    {
        if (i == (length))
    b2c0:	e14b03d4 	ldrd	r0, [fp, #-52]	; 0xffffffcc
    b2c4:	e14b22d4 	ldrd	r2, [fp, #-36]	; 0xffffffdc
    b2c8:	e1510003 	cmp	r1, r3
    b2cc:	01500002 	cmpeq	r0, r2
    b2d0:	1a000005 	bne	b2ec <_Z4ftoafPc+0x258>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:250
            r[i] = '\0';
    b2d4:	e51b3034 	ldr	r3, [fp, #-52]	; 0xffffffcc
    b2d8:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    b2dc:	e0823003 	add	r3, r2, r3
    b2e0:	e3a02000 	mov	r2, #0
    b2e4:	e5c32000 	strb	r2, [r3]
    b2e8:	ea000029 	b	b394 <_Z4ftoafPc+0x300>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:251
        else if(i == (position))
    b2ec:	e14b03d4 	ldrd	r0, [fp, #-52]	; 0xffffffcc
    b2f0:	e14b24d4 	ldrd	r2, [fp, #-68]	; 0xffffffbc
    b2f4:	e1510003 	cmp	r1, r3
    b2f8:	01500002 	cmpeq	r0, r2
    b2fc:	1a000005 	bne	b318 <_Z4ftoafPc+0x284>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:252
            r[i] = '.';
    b300:	e51b3034 	ldr	r3, [fp, #-52]	; 0xffffffcc
    b304:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    b308:	e0823003 	add	r3, r2, r3
    b30c:	e3a0202e 	mov	r2, #46	; 0x2e
    b310:	e5c32000 	strb	r2, [r3]
    b314:	ea00001e 	b	b394 <_Z4ftoafPc+0x300>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:253
        else if(sign == '-' && i == 0)
    b318:	e14b24dc 	ldrd	r2, [fp, #-76]	; 0xffffffb4
    b31c:	e242102d 	sub	r1, r2, #45	; 0x2d
    b320:	e1913003 	orrs	r3, r1, r3
    b324:	1a000008 	bne	b34c <_Z4ftoafPc+0x2b8>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:253 (discriminator 1)
    b328:	e14b23d4 	ldrd	r2, [fp, #-52]	; 0xffffffcc
    b32c:	e1923003 	orrs	r3, r2, r3
    b330:	1a000005 	bne	b34c <_Z4ftoafPc+0x2b8>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:254
            r[i] = '-';
    b334:	e51b3034 	ldr	r3, [fp, #-52]	; 0xffffffcc
    b338:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    b33c:	e0823003 	add	r3, r2, r3
    b340:	e3a0202d 	mov	r2, #45	; 0x2d
    b344:	e5c32000 	strb	r2, [r3]
    b348:	ea000011 	b	b394 <_Z4ftoafPc+0x300>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:257
        else
        {
            r[i] = (number % 10) + '0';
    b34c:	e14b03dc 	ldrd	r0, [fp, #-60]	; 0xffffffc4
    b350:	e3a0200a 	mov	r2, #10
    b354:	e3a03000 	mov	r3, #0
    b358:	eb0001bf 	bl	ba5c <__aeabi_ldivmod>
    b35c:	e6ef2072 	uxtb	r2, r2
    b360:	e51b3034 	ldr	r3, [fp, #-52]	; 0xffffffcc
    b364:	e51b105c 	ldr	r1, [fp, #-92]	; 0xffffffa4
    b368:	e0813003 	add	r3, r1, r3
    b36c:	e2822030 	add	r2, r2, #48	; 0x30
    b370:	e6ef2072 	uxtb	r2, r2
    b374:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:258
            number /=10;
    b378:	e14b03dc 	ldrd	r0, [fp, #-60]	; 0xffffffc4
    b37c:	e3a0200a 	mov	r2, #10
    b380:	e3a03000 	mov	r3, #0
    b384:	eb0001b4 	bl	ba5c <__aeabi_ldivmod>
    b388:	e1a02000 	mov	r2, r0
    b38c:	e1a03001 	mov	r3, r1
    b390:	e14b23fc 	strd	r2, [fp, #-60]	; 0xffffffc4
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:247 (discriminator 2)
    for (i = length; i >= 0 ; i--)
    b394:	e14b23d4 	ldrd	r2, [fp, #-52]	; 0xffffffcc
    b398:	e2528001 	subs	r8, r2, #1
    b39c:	e2c39000 	sbc	r9, r3, #0
    b3a0:	e14b83f4 	strd	r8, [fp, #-52]	; 0xffffffcc
    b3a4:	eaffffc2 	b	b2b4 <_Z4ftoafPc+0x220>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:261
        }
    }
}
    b3a8:	e320f000 	nop	{0}
    b3ac:	e24bd01c 	sub	sp, fp, #28
    b3b0:	e8bd8bf0 	pop	{r4, r5, r6, r7, r8, r9, fp, pc}
    b3b4:	3f800000 	svccc	0x00800000
    b3b8:	41200000 			; <UNDEFINED> instruction: 0x41200000

0000b3bc <__udivsi3>:
__udivsi3():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1104
    b3bc:	e2512001 	subs	r2, r1, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1106
    b3c0:	012fff1e 	bxeq	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1107
    b3c4:	3a000074 	bcc	b59c <__udivsi3+0x1e0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1108
    b3c8:	e1500001 	cmp	r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1109
    b3cc:	9a00006b 	bls	b580 <__udivsi3+0x1c4>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1110
    b3d0:	e1110002 	tst	r1, r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1111
    b3d4:	0a00006c 	beq	b58c <__udivsi3+0x1d0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1113
    b3d8:	e16f3f10 	clz	r3, r0
    b3dc:	e16f2f11 	clz	r2, r1
    b3e0:	e0423003 	sub	r3, r2, r3
    b3e4:	e273301f 	rsbs	r3, r3, #31
    b3e8:	10833083 	addne	r3, r3, r3, lsl #1
    b3ec:	e3a02000 	mov	r2, #0
    b3f0:	108ff103 	addne	pc, pc, r3, lsl #2
    b3f4:	e1a00000 	nop			; (mov r0, r0)
    b3f8:	e1500f81 	cmp	r0, r1, lsl #31
    b3fc:	e0a22002 	adc	r2, r2, r2
    b400:	20400f81 	subcs	r0, r0, r1, lsl #31
    b404:	e1500f01 	cmp	r0, r1, lsl #30
    b408:	e0a22002 	adc	r2, r2, r2
    b40c:	20400f01 	subcs	r0, r0, r1, lsl #30
    b410:	e1500e81 	cmp	r0, r1, lsl #29
    b414:	e0a22002 	adc	r2, r2, r2
    b418:	20400e81 	subcs	r0, r0, r1, lsl #29
    b41c:	e1500e01 	cmp	r0, r1, lsl #28
    b420:	e0a22002 	adc	r2, r2, r2
    b424:	20400e01 	subcs	r0, r0, r1, lsl #28
    b428:	e1500d81 	cmp	r0, r1, lsl #27
    b42c:	e0a22002 	adc	r2, r2, r2
    b430:	20400d81 	subcs	r0, r0, r1, lsl #27
    b434:	e1500d01 	cmp	r0, r1, lsl #26
    b438:	e0a22002 	adc	r2, r2, r2
    b43c:	20400d01 	subcs	r0, r0, r1, lsl #26
    b440:	e1500c81 	cmp	r0, r1, lsl #25
    b444:	e0a22002 	adc	r2, r2, r2
    b448:	20400c81 	subcs	r0, r0, r1, lsl #25
    b44c:	e1500c01 	cmp	r0, r1, lsl #24
    b450:	e0a22002 	adc	r2, r2, r2
    b454:	20400c01 	subcs	r0, r0, r1, lsl #24
    b458:	e1500b81 	cmp	r0, r1, lsl #23
    b45c:	e0a22002 	adc	r2, r2, r2
    b460:	20400b81 	subcs	r0, r0, r1, lsl #23
    b464:	e1500b01 	cmp	r0, r1, lsl #22
    b468:	e0a22002 	adc	r2, r2, r2
    b46c:	20400b01 	subcs	r0, r0, r1, lsl #22
    b470:	e1500a81 	cmp	r0, r1, lsl #21
    b474:	e0a22002 	adc	r2, r2, r2
    b478:	20400a81 	subcs	r0, r0, r1, lsl #21
    b47c:	e1500a01 	cmp	r0, r1, lsl #20
    b480:	e0a22002 	adc	r2, r2, r2
    b484:	20400a01 	subcs	r0, r0, r1, lsl #20
    b488:	e1500981 	cmp	r0, r1, lsl #19
    b48c:	e0a22002 	adc	r2, r2, r2
    b490:	20400981 	subcs	r0, r0, r1, lsl #19
    b494:	e1500901 	cmp	r0, r1, lsl #18
    b498:	e0a22002 	adc	r2, r2, r2
    b49c:	20400901 	subcs	r0, r0, r1, lsl #18
    b4a0:	e1500881 	cmp	r0, r1, lsl #17
    b4a4:	e0a22002 	adc	r2, r2, r2
    b4a8:	20400881 	subcs	r0, r0, r1, lsl #17
    b4ac:	e1500801 	cmp	r0, r1, lsl #16
    b4b0:	e0a22002 	adc	r2, r2, r2
    b4b4:	20400801 	subcs	r0, r0, r1, lsl #16
    b4b8:	e1500781 	cmp	r0, r1, lsl #15
    b4bc:	e0a22002 	adc	r2, r2, r2
    b4c0:	20400781 	subcs	r0, r0, r1, lsl #15
    b4c4:	e1500701 	cmp	r0, r1, lsl #14
    b4c8:	e0a22002 	adc	r2, r2, r2
    b4cc:	20400701 	subcs	r0, r0, r1, lsl #14
    b4d0:	e1500681 	cmp	r0, r1, lsl #13
    b4d4:	e0a22002 	adc	r2, r2, r2
    b4d8:	20400681 	subcs	r0, r0, r1, lsl #13
    b4dc:	e1500601 	cmp	r0, r1, lsl #12
    b4e0:	e0a22002 	adc	r2, r2, r2
    b4e4:	20400601 	subcs	r0, r0, r1, lsl #12
    b4e8:	e1500581 	cmp	r0, r1, lsl #11
    b4ec:	e0a22002 	adc	r2, r2, r2
    b4f0:	20400581 	subcs	r0, r0, r1, lsl #11
    b4f4:	e1500501 	cmp	r0, r1, lsl #10
    b4f8:	e0a22002 	adc	r2, r2, r2
    b4fc:	20400501 	subcs	r0, r0, r1, lsl #10
    b500:	e1500481 	cmp	r0, r1, lsl #9
    b504:	e0a22002 	adc	r2, r2, r2
    b508:	20400481 	subcs	r0, r0, r1, lsl #9
    b50c:	e1500401 	cmp	r0, r1, lsl #8
    b510:	e0a22002 	adc	r2, r2, r2
    b514:	20400401 	subcs	r0, r0, r1, lsl #8
    b518:	e1500381 	cmp	r0, r1, lsl #7
    b51c:	e0a22002 	adc	r2, r2, r2
    b520:	20400381 	subcs	r0, r0, r1, lsl #7
    b524:	e1500301 	cmp	r0, r1, lsl #6
    b528:	e0a22002 	adc	r2, r2, r2
    b52c:	20400301 	subcs	r0, r0, r1, lsl #6
    b530:	e1500281 	cmp	r0, r1, lsl #5
    b534:	e0a22002 	adc	r2, r2, r2
    b538:	20400281 	subcs	r0, r0, r1, lsl #5
    b53c:	e1500201 	cmp	r0, r1, lsl #4
    b540:	e0a22002 	adc	r2, r2, r2
    b544:	20400201 	subcs	r0, r0, r1, lsl #4
    b548:	e1500181 	cmp	r0, r1, lsl #3
    b54c:	e0a22002 	adc	r2, r2, r2
    b550:	20400181 	subcs	r0, r0, r1, lsl #3
    b554:	e1500101 	cmp	r0, r1, lsl #2
    b558:	e0a22002 	adc	r2, r2, r2
    b55c:	20400101 	subcs	r0, r0, r1, lsl #2
    b560:	e1500081 	cmp	r0, r1, lsl #1
    b564:	e0a22002 	adc	r2, r2, r2
    b568:	20400081 	subcs	r0, r0, r1, lsl #1
    b56c:	e1500001 	cmp	r0, r1
    b570:	e0a22002 	adc	r2, r2, r2
    b574:	20400001 	subcs	r0, r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1115
    b578:	e1a00002 	mov	r0, r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1116
    b57c:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1119
    b580:	03a00001 	moveq	r0, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1120
    b584:	13a00000 	movne	r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1121
    b588:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1123
    b58c:	e16f2f11 	clz	r2, r1
    b590:	e262201f 	rsb	r2, r2, #31
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1125
    b594:	e1a00230 	lsr	r0, r0, r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1126
    b598:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1130
    b59c:	e3500000 	cmp	r0, #0
    b5a0:	13e00000 	mvnne	r0, #0
    b5a4:	ea000097 	b	b808 <__aeabi_idiv0>

0000b5a8 <__aeabi_uidivmod>:
__aeabi_uidivmod():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1161
    b5a8:	e3510000 	cmp	r1, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1162
    b5ac:	0afffffa 	beq	b59c <__udivsi3+0x1e0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1163
    b5b0:	e92d4003 	push	{r0, r1, lr}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1164
    b5b4:	ebffff80 	bl	b3bc <__udivsi3>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1165
    b5b8:	e8bd4006 	pop	{r1, r2, lr}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1166
    b5bc:	e0030092 	mul	r3, r2, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1167
    b5c0:	e0411003 	sub	r1, r1, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1168
    b5c4:	e12fff1e 	bx	lr

0000b5c8 <__divsi3>:
__divsi3():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1297
    b5c8:	e3510000 	cmp	r1, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1298
    b5cc:	0a000081 	beq	b7d8 <.divsi3_skip_div0_test+0x208>

0000b5d0 <.divsi3_skip_div0_test>:
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1300
    b5d0:	e020c001 	eor	ip, r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1302
    b5d4:	42611000 	rsbmi	r1, r1, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1303
    b5d8:	e2512001 	subs	r2, r1, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1304
    b5dc:	0a000070 	beq	b7a4 <.divsi3_skip_div0_test+0x1d4>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1305
    b5e0:	e1b03000 	movs	r3, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1307
    b5e4:	42603000 	rsbmi	r3, r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1308
    b5e8:	e1530001 	cmp	r3, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1309
    b5ec:	9a00006f 	bls	b7b0 <.divsi3_skip_div0_test+0x1e0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1310
    b5f0:	e1110002 	tst	r1, r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1311
    b5f4:	0a000071 	beq	b7c0 <.divsi3_skip_div0_test+0x1f0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1313
    b5f8:	e16f2f13 	clz	r2, r3
    b5fc:	e16f0f11 	clz	r0, r1
    b600:	e0402002 	sub	r2, r0, r2
    b604:	e272201f 	rsbs	r2, r2, #31
    b608:	10822082 	addne	r2, r2, r2, lsl #1
    b60c:	e3a00000 	mov	r0, #0
    b610:	108ff102 	addne	pc, pc, r2, lsl #2
    b614:	e1a00000 	nop			; (mov r0, r0)
    b618:	e1530f81 	cmp	r3, r1, lsl #31
    b61c:	e0a00000 	adc	r0, r0, r0
    b620:	20433f81 	subcs	r3, r3, r1, lsl #31
    b624:	e1530f01 	cmp	r3, r1, lsl #30
    b628:	e0a00000 	adc	r0, r0, r0
    b62c:	20433f01 	subcs	r3, r3, r1, lsl #30
    b630:	e1530e81 	cmp	r3, r1, lsl #29
    b634:	e0a00000 	adc	r0, r0, r0
    b638:	20433e81 	subcs	r3, r3, r1, lsl #29
    b63c:	e1530e01 	cmp	r3, r1, lsl #28
    b640:	e0a00000 	adc	r0, r0, r0
    b644:	20433e01 	subcs	r3, r3, r1, lsl #28
    b648:	e1530d81 	cmp	r3, r1, lsl #27
    b64c:	e0a00000 	adc	r0, r0, r0
    b650:	20433d81 	subcs	r3, r3, r1, lsl #27
    b654:	e1530d01 	cmp	r3, r1, lsl #26
    b658:	e0a00000 	adc	r0, r0, r0
    b65c:	20433d01 	subcs	r3, r3, r1, lsl #26
    b660:	e1530c81 	cmp	r3, r1, lsl #25
    b664:	e0a00000 	adc	r0, r0, r0
    b668:	20433c81 	subcs	r3, r3, r1, lsl #25
    b66c:	e1530c01 	cmp	r3, r1, lsl #24
    b670:	e0a00000 	adc	r0, r0, r0
    b674:	20433c01 	subcs	r3, r3, r1, lsl #24
    b678:	e1530b81 	cmp	r3, r1, lsl #23
    b67c:	e0a00000 	adc	r0, r0, r0
    b680:	20433b81 	subcs	r3, r3, r1, lsl #23
    b684:	e1530b01 	cmp	r3, r1, lsl #22
    b688:	e0a00000 	adc	r0, r0, r0
    b68c:	20433b01 	subcs	r3, r3, r1, lsl #22
    b690:	e1530a81 	cmp	r3, r1, lsl #21
    b694:	e0a00000 	adc	r0, r0, r0
    b698:	20433a81 	subcs	r3, r3, r1, lsl #21
    b69c:	e1530a01 	cmp	r3, r1, lsl #20
    b6a0:	e0a00000 	adc	r0, r0, r0
    b6a4:	20433a01 	subcs	r3, r3, r1, lsl #20
    b6a8:	e1530981 	cmp	r3, r1, lsl #19
    b6ac:	e0a00000 	adc	r0, r0, r0
    b6b0:	20433981 	subcs	r3, r3, r1, lsl #19
    b6b4:	e1530901 	cmp	r3, r1, lsl #18
    b6b8:	e0a00000 	adc	r0, r0, r0
    b6bc:	20433901 	subcs	r3, r3, r1, lsl #18
    b6c0:	e1530881 	cmp	r3, r1, lsl #17
    b6c4:	e0a00000 	adc	r0, r0, r0
    b6c8:	20433881 	subcs	r3, r3, r1, lsl #17
    b6cc:	e1530801 	cmp	r3, r1, lsl #16
    b6d0:	e0a00000 	adc	r0, r0, r0
    b6d4:	20433801 	subcs	r3, r3, r1, lsl #16
    b6d8:	e1530781 	cmp	r3, r1, lsl #15
    b6dc:	e0a00000 	adc	r0, r0, r0
    b6e0:	20433781 	subcs	r3, r3, r1, lsl #15
    b6e4:	e1530701 	cmp	r3, r1, lsl #14
    b6e8:	e0a00000 	adc	r0, r0, r0
    b6ec:	20433701 	subcs	r3, r3, r1, lsl #14
    b6f0:	e1530681 	cmp	r3, r1, lsl #13
    b6f4:	e0a00000 	adc	r0, r0, r0
    b6f8:	20433681 	subcs	r3, r3, r1, lsl #13
    b6fc:	e1530601 	cmp	r3, r1, lsl #12
    b700:	e0a00000 	adc	r0, r0, r0
    b704:	20433601 	subcs	r3, r3, r1, lsl #12
    b708:	e1530581 	cmp	r3, r1, lsl #11
    b70c:	e0a00000 	adc	r0, r0, r0
    b710:	20433581 	subcs	r3, r3, r1, lsl #11
    b714:	e1530501 	cmp	r3, r1, lsl #10
    b718:	e0a00000 	adc	r0, r0, r0
    b71c:	20433501 	subcs	r3, r3, r1, lsl #10
    b720:	e1530481 	cmp	r3, r1, lsl #9
    b724:	e0a00000 	adc	r0, r0, r0
    b728:	20433481 	subcs	r3, r3, r1, lsl #9
    b72c:	e1530401 	cmp	r3, r1, lsl #8
    b730:	e0a00000 	adc	r0, r0, r0
    b734:	20433401 	subcs	r3, r3, r1, lsl #8
    b738:	e1530381 	cmp	r3, r1, lsl #7
    b73c:	e0a00000 	adc	r0, r0, r0
    b740:	20433381 	subcs	r3, r3, r1, lsl #7
    b744:	e1530301 	cmp	r3, r1, lsl #6
    b748:	e0a00000 	adc	r0, r0, r0
    b74c:	20433301 	subcs	r3, r3, r1, lsl #6
    b750:	e1530281 	cmp	r3, r1, lsl #5
    b754:	e0a00000 	adc	r0, r0, r0
    b758:	20433281 	subcs	r3, r3, r1, lsl #5
    b75c:	e1530201 	cmp	r3, r1, lsl #4
    b760:	e0a00000 	adc	r0, r0, r0
    b764:	20433201 	subcs	r3, r3, r1, lsl #4
    b768:	e1530181 	cmp	r3, r1, lsl #3
    b76c:	e0a00000 	adc	r0, r0, r0
    b770:	20433181 	subcs	r3, r3, r1, lsl #3
    b774:	e1530101 	cmp	r3, r1, lsl #2
    b778:	e0a00000 	adc	r0, r0, r0
    b77c:	20433101 	subcs	r3, r3, r1, lsl #2
    b780:	e1530081 	cmp	r3, r1, lsl #1
    b784:	e0a00000 	adc	r0, r0, r0
    b788:	20433081 	subcs	r3, r3, r1, lsl #1
    b78c:	e1530001 	cmp	r3, r1
    b790:	e0a00000 	adc	r0, r0, r0
    b794:	20433001 	subcs	r3, r3, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1315
    b798:	e35c0000 	cmp	ip, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1317
    b79c:	42600000 	rsbmi	r0, r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1318
    b7a0:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1320
    b7a4:	e13c0000 	teq	ip, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1322
    b7a8:	42600000 	rsbmi	r0, r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1323
    b7ac:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1326
    b7b0:	33a00000 	movcc	r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1328
    b7b4:	01a00fcc 	asreq	r0, ip, #31
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1329
    b7b8:	03800001 	orreq	r0, r0, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1330
    b7bc:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1332
    b7c0:	e16f2f11 	clz	r2, r1
    b7c4:	e262201f 	rsb	r2, r2, #31
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1334
    b7c8:	e35c0000 	cmp	ip, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1335
    b7cc:	e1a00233 	lsr	r0, r3, r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1337
    b7d0:	42600000 	rsbmi	r0, r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1338
    b7d4:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1342
    b7d8:	e3500000 	cmp	r0, #0
    b7dc:	c3e00102 	mvngt	r0, #-2147483648	; 0x80000000
    b7e0:	b3a00102 	movlt	r0, #-2147483648	; 0x80000000
    b7e4:	ea000007 	b	b808 <__aeabi_idiv0>

0000b7e8 <__aeabi_idivmod>:
__aeabi_idivmod():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1373
    b7e8:	e3510000 	cmp	r1, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1374
    b7ec:	0afffff9 	beq	b7d8 <.divsi3_skip_div0_test+0x208>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1375
    b7f0:	e92d4003 	push	{r0, r1, lr}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1376
    b7f4:	ebffff75 	bl	b5d0 <.divsi3_skip_div0_test>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1377
    b7f8:	e8bd4006 	pop	{r1, r2, lr}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1378
    b7fc:	e0030092 	mul	r3, r2, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1379
    b800:	e0411003 	sub	r1, r1, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1380
    b804:	e12fff1e 	bx	lr

0000b808 <__aeabi_idiv0>:
__aeabi_ldiv0():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1466
    b808:	e12fff1e 	bx	lr

0000b80c <__aeabi_frsub>:
__aeabi_frsub():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:59
    b80c:	e2200102 	eor	r0, r0, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:60
    b810:	ea000000 	b	b818 <__addsf3>

0000b814 <__aeabi_fsub>:
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:65
    b814:	e2211102 	eor	r1, r1, #-2147483648	; 0x80000000

0000b818 <__addsf3>:
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:74
    b818:	e1b02080 	lsls	r2, r0, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:76
    b81c:	11b03081 	lslsne	r3, r1, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:77
    b820:	11320003 	teqne	r2, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:78
    b824:	11f0cc42 	mvnsne	ip, r2, asr #24
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:79
    b828:	11f0cc43 	mvnsne	ip, r3, asr #24
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:80
    b82c:	0a00003c 	beq	b924 <__addsf3+0x10c>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:84
    b830:	e1a02c22 	lsr	r2, r2, #24
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:85
    b834:	e0723c23 	rsbs	r3, r2, r3, lsr #24
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:87
    b838:	c0822003 	addgt	r2, r2, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:88
    b83c:	c0201001 	eorgt	r1, r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:89
    b840:	c0210000 	eorgt	r0, r1, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:90
    b844:	c0201001 	eorgt	r1, r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:92
    b848:	b2633000 	rsblt	r3, r3, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:97
    b84c:	e3530019 	cmp	r3, #25
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:99
    b850:	812fff1e 	bxhi	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:102
    b854:	e3100102 	tst	r0, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:103
    b858:	e3800502 	orr	r0, r0, #8388608	; 0x800000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:104
    b85c:	e3c004ff 	bic	r0, r0, #-16777216	; 0xff000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:106
    b860:	12600000 	rsbne	r0, r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:107
    b864:	e3110102 	tst	r1, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:108
    b868:	e3811502 	orr	r1, r1, #8388608	; 0x800000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:109
    b86c:	e3c114ff 	bic	r1, r1, #-16777216	; 0xff000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:111
    b870:	12611000 	rsbne	r1, r1, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:115
    b874:	e1320003 	teq	r2, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:116
    b878:	0a000023 	beq	b90c <__addsf3+0xf4>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:120
    b87c:	e2422001 	sub	r2, r2, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:124
    b880:	e0900351 	adds	r0, r0, r1, asr r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:125
    b884:	e2633020 	rsb	r3, r3, #32
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:126
    b888:	e1a01311 	lsl	r1, r1, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:129
    b88c:	e2003102 	and	r3, r0, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:130
    b890:	5a000001 	bpl	b89c <__addsf3+0x84>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:135
    b894:	e2711000 	rsbs	r1, r1, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:136
    b898:	e2e00000 	rsc	r0, r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:141
    b89c:	e3500502 	cmp	r0, #8388608	; 0x800000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:142
    b8a0:	3a00000b 	bcc	b8d4 <__addsf3+0xbc>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:143
    b8a4:	e3500401 	cmp	r0, #16777216	; 0x1000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:144
    b8a8:	3a000004 	bcc	b8c0 <__addsf3+0xa8>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:147
    b8ac:	e1b000a0 	lsrs	r0, r0, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:148
    b8b0:	e1a01061 	rrx	r1, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:149
    b8b4:	e2822001 	add	r2, r2, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:152
    b8b8:	e35200fe 	cmp	r2, #254	; 0xfe
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:153
    b8bc:	2a00002d 	bcs	b978 <__addsf3+0x160>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:160
    b8c0:	e3510102 	cmp	r1, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:161
    b8c4:	e0a00b82 	adc	r0, r0, r2, lsl #23
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:163
    b8c8:	03c00001 	biceq	r0, r0, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:164
    b8cc:	e1800003 	orr	r0, r0, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:165
    b8d0:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:169
    b8d4:	e1b01081 	lsls	r1, r1, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:170
    b8d8:	e0a00000 	adc	r0, r0, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:171
    b8dc:	e2522001 	subs	r2, r2, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:173
    b8e0:	23500502 	cmpcs	r0, #8388608	; 0x800000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:174
    b8e4:	2afffff5 	bcs	b8c0 <__addsf3+0xa8>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:199
    b8e8:	e16fcf10 	clz	ip, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:200
    b8ec:	e24cc008 	sub	ip, ip, #8
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:201
    b8f0:	e052200c 	subs	r2, r2, ip
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:202
    b8f4:	e1a00c10 	lsl	r0, r0, ip
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:209
    b8f8:	a0800b82 	addge	r0, r0, r2, lsl #23
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:210
    b8fc:	b2622000 	rsblt	r2, r2, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:211
    b900:	a1800003 	orrge	r0, r0, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:217
    b904:	b1830230 	orrlt	r0, r3, r0, lsr r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:219
    b908:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:224
    b90c:	e3320000 	teq	r2, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:225
    b910:	e2211502 	eor	r1, r1, #8388608	; 0x800000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:227
    b914:	02200502 	eoreq	r0, r0, #8388608	; 0x800000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:228
    b918:	02822001 	addeq	r2, r2, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:229
    b91c:	12433001 	subne	r3, r3, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:230
    b920:	eaffffd5 	b	b87c <__addsf3+0x64>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:233
    b924:	e1a03081 	lsl	r3, r1, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:235
    b928:	e1f0cc42 	mvns	ip, r2, asr #24
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:237
    b92c:	11f0cc43 	mvnsne	ip, r3, asr #24
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:238
    b930:	0a000013 	beq	b984 <__addsf3+0x16c>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:240
    b934:	e1320003 	teq	r2, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:241
    b938:	0a000002 	beq	b948 <__addsf3+0x130>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:244
    b93c:	e3320000 	teq	r2, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:246
    b940:	01a00001 	moveq	r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:247
    b944:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:249
    b948:	e1300001 	teq	r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:253
    b94c:	13a00000 	movne	r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:254
    b950:	112fff1e 	bxne	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:257
    b954:	e31204ff 	tst	r2, #-16777216	; 0xff000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:258
    b958:	1a000002 	bne	b968 <__addsf3+0x150>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:259
    b95c:	e1b00080 	lsls	r0, r0, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:261
    b960:	23800102 	orrcs	r0, r0, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:262
    b964:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:263
    b968:	e2922402 	adds	r2, r2, #33554432	; 0x2000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:265
    b96c:	32800502 	addcc	r0, r0, #8388608	; 0x800000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:266
    b970:	312fff1e 	bxcc	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:267
    b974:	e2003102 	and	r3, r0, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:271
    b978:	e383047f 	orr	r0, r3, #2130706432	; 0x7f000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:272
    b97c:	e3800502 	orr	r0, r0, #8388608	; 0x800000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:273
    b980:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:282
    b984:	e1f02c42 	mvns	r2, r2, asr #24
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:284
    b988:	11a00001 	movne	r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:285
    b98c:	01f03c43 	mvnseq	r3, r3, asr #24
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:286
    b990:	11a01000 	movne	r1, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:287
    b994:	e1b02480 	lsls	r2, r0, #9
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:289
    b998:	01b03481 	lslseq	r3, r1, #9
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:290
    b99c:	01300001 	teqeq	r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:291
    b9a0:	13800501 	orrne	r0, r0, #4194304	; 0x400000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:292
    b9a4:	e12fff1e 	bx	lr

0000b9a8 <__aeabi_ui2f>:
__aeabi_ui2f():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:305
    b9a8:	e3a03000 	mov	r3, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:306
    b9ac:	ea000001 	b	b9b8 <__aeabi_i2f+0x8>

0000b9b0 <__aeabi_i2f>:
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:311
    b9b0:	e2103102 	ands	r3, r0, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:313
    b9b4:	42600000 	rsbmi	r0, r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:315
    b9b8:	e1b0c000 	movs	ip, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:317
    b9bc:	012fff1e 	bxeq	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:320
    b9c0:	e383344b 	orr	r3, r3, #1258291200	; 0x4b000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:323
    b9c4:	e1a01000 	mov	r1, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:325
    b9c8:	e3a00000 	mov	r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:326
    b9cc:	ea00000f 	b	ba10 <__aeabi_l2f+0x30>

0000b9d0 <__aeabi_ul2f>:
__floatundisf():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:338
    b9d0:	e1902001 	orrs	r2, r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:340
    b9d4:	012fff1e 	bxeq	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:342
    b9d8:	e3a03000 	mov	r3, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:343
    b9dc:	ea000005 	b	b9f8 <__aeabi_l2f+0x18>

0000b9e0 <__aeabi_l2f>:
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:348
    b9e0:	e1902001 	orrs	r2, r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:350
    b9e4:	012fff1e 	bxeq	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:352
    b9e8:	e2113102 	ands	r3, r1, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:353
    b9ec:	5a000001 	bpl	b9f8 <__aeabi_l2f+0x18>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:358
    b9f0:	e2700000 	rsbs	r0, r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:359
    b9f4:	e2e11000 	rsc	r1, r1, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:362
    b9f8:	e1b0c001 	movs	ip, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:364
    b9fc:	01a0c000 	moveq	ip, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:365
    ba00:	01a01000 	moveq	r1, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:366
    ba04:	03a00000 	moveq	r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:369
    ba08:	e383345b 	orr	r3, r3, #1526726656	; 0x5b000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:371
    ba0c:	02433201 	subeq	r3, r3, #268435456	; 0x10000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:372
    ba10:	e2433502 	sub	r3, r3, #8388608	; 0x800000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:397
    ba14:	e16f2f1c 	clz	r2, ip
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:398
    ba18:	e2522008 	subs	r2, r2, #8
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:402
    ba1c:	e0433b82 	sub	r3, r3, r2, lsl #23
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:403
    ba20:	ba000006 	blt	ba40 <__aeabi_l2f+0x60>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:405
    ba24:	e0833211 	add	r3, r3, r1, lsl r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:406
    ba28:	e1a0c210 	lsl	ip, r0, r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:407
    ba2c:	e2622020 	rsb	r2, r2, #32
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:408
    ba30:	e35c0102 	cmp	ip, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:409
    ba34:	e0a30230 	adc	r0, r3, r0, lsr r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:411
    ba38:	03c00001 	biceq	r0, r0, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:412
    ba3c:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:414
    ba40:	e2822020 	add	r2, r2, #32
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:415
    ba44:	e1a0c211 	lsl	ip, r1, r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:416
    ba48:	e2622020 	rsb	r2, r2, #32
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:417
    ba4c:	e190008c 	orrs	r0, r0, ip, lsl #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:418
    ba50:	e0a30231 	adc	r0, r3, r1, lsr r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:420
    ba54:	01c00fac 	biceq	r0, r0, ip, lsr #31
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:421
    ba58:	e12fff1e 	bx	lr

0000ba5c <__aeabi_ldivmod>:
__aeabi_ldivmod():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:186
    ba5c:	e3530000 	cmp	r3, #0
    ba60:	03520000 	cmpeq	r2, #0
    ba64:	1a000007 	bne	ba88 <__aeabi_ldivmod+0x2c>
    ba68:	e3510000 	cmp	r1, #0
    ba6c:	b3a01102 	movlt	r1, #-2147483648	; 0x80000000
    ba70:	b3a00000 	movlt	r0, #0
    ba74:	ba000002 	blt	ba84 <__aeabi_ldivmod+0x28>
    ba78:	03500000 	cmpeq	r0, #0
    ba7c:	13e01102 	mvnne	r1, #-2147483648	; 0x80000000
    ba80:	13e00000 	mvnne	r0, #0
    ba84:	eaffff5f 	b	b808 <__aeabi_idiv0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:188
    ba88:	e24dd008 	sub	sp, sp, #8
    ba8c:	e92d6000 	push	{sp, lr}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:189
    ba90:	e3510000 	cmp	r1, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:190
    ba94:	ba000006 	blt	bab4 <__aeabi_ldivmod+0x58>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:191
    ba98:	e3530000 	cmp	r3, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:192
    ba9c:	ba000011 	blt	bae8 <__aeabi_ldivmod+0x8c>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:194
    baa0:	eb00003e 	bl	bba0 <__udivmoddi4>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:196
    baa4:	e59de004 	ldr	lr, [sp, #4]
    baa8:	e28dd008 	add	sp, sp, #8
    baac:	e8bd000c 	pop	{r2, r3}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:197
    bab0:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:201
    bab4:	e2700000 	rsbs	r0, r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:202
    bab8:	e0c11081 	sbc	r1, r1, r1, lsl #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:203
    babc:	e3530000 	cmp	r3, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:204
    bac0:	ba000011 	blt	bb0c <__aeabi_ldivmod+0xb0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:206
    bac4:	eb000035 	bl	bba0 <__udivmoddi4>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:208
    bac8:	e59de004 	ldr	lr, [sp, #4]
    bacc:	e28dd008 	add	sp, sp, #8
    bad0:	e8bd000c 	pop	{r2, r3}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:209
    bad4:	e2700000 	rsbs	r0, r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:210
    bad8:	e0c11081 	sbc	r1, r1, r1, lsl #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:211
    badc:	e2722000 	rsbs	r2, r2, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:212
    bae0:	e0c33083 	sbc	r3, r3, r3, lsl #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:213
    bae4:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:217
    bae8:	e2722000 	rsbs	r2, r2, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:218
    baec:	e0c33083 	sbc	r3, r3, r3, lsl #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:220
    baf0:	eb00002a 	bl	bba0 <__udivmoddi4>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:222
    baf4:	e59de004 	ldr	lr, [sp, #4]
    baf8:	e28dd008 	add	sp, sp, #8
    bafc:	e8bd000c 	pop	{r2, r3}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:223
    bb00:	e2700000 	rsbs	r0, r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:224
    bb04:	e0c11081 	sbc	r1, r1, r1, lsl #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:225
    bb08:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:229
    bb0c:	e2722000 	rsbs	r2, r2, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:230
    bb10:	e0c33083 	sbc	r3, r3, r3, lsl #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:232
    bb14:	eb000021 	bl	bba0 <__udivmoddi4>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:233
    bb18:	e59de004 	ldr	lr, [sp, #4]
    bb1c:	e28dd008 	add	sp, sp, #8
    bb20:	e8bd000c 	pop	{r2, r3}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:234
    bb24:	e2722000 	rsbs	r2, r2, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:235
    bb28:	e0c33083 	sbc	r3, r3, r3, lsl #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:236
    bb2c:	e12fff1e 	bx	lr

0000bb30 <__aeabi_f2lz>:
__fixsfdi():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1530
    bb30:	ee070a90 	vmov	s15, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1531
    bb34:	eef57ac0 	vcmpe.f32	s15, #0.0
    bb38:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    bb3c:	4a000000 	bmi	bb44 <__aeabi_f2lz+0x14>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1533
    bb40:	ea000006 	b	bb60 <__aeabi_f2ulz>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1532
    bb44:	eef17a67 	vneg.f32	s15, s15
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1530
    bb48:	e92d4010 	push	{r4, lr}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1532
    bb4c:	ee170a90 	vmov	r0, s15
    bb50:	eb000002 	bl	bb60 <__aeabi_f2ulz>
    bb54:	e2700000 	rsbs	r0, r0, #0
    bb58:	e2e11000 	rsc	r1, r1, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1534
    bb5c:	e8bd8010 	pop	{r4, pc}

0000bb60 <__aeabi_f2ulz>:
__fixunssfdi():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1471
    bb60:	ee070a90 	vmov	s15, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1476
    bb64:	ed9f6b09 	vldr	d6, [pc, #36]	; bb90 <__aeabi_f2ulz+0x30>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1481
    bb68:	ed9f5b0a 	vldr	d5, [pc, #40]	; bb98 <__aeabi_f2ulz+0x38>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1471
    bb6c:	eeb77ae7 	vcvt.f64.f32	d7, s15
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1476
    bb70:	ee276b06 	vmul.f64	d6, d7, d6
    bb74:	eebc6bc6 	vcvt.u32.f64	s12, d6
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1481
    bb78:	eeb84b46 	vcvt.f64.u32	d4, s12
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1524
    bb7c:	ee161a10 	vmov	r1, s12
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1481
    bb80:	ee047b45 	vmls.f64	d7, d4, d5
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1524
    bb84:	eefc7bc7 	vcvt.u32.f64	s15, d7
    bb88:	ee170a90 	vmov	r0, s15
    bb8c:	e12fff1e 	bx	lr
    bb90:	00000000 	andeq	r0, r0, r0
    bb94:	3df00000 	ldclcc	0, cr0, [r0]
    bb98:	00000000 	andeq	r0, r0, r0
    bb9c:	41f00000 	mvnsmi	r0, r0

0000bba0 <__udivmoddi4>:
__udivmoddi4():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:960
    bba0:	e1500002 	cmp	r0, r2
    bba4:	e0d1c003 	sbcs	ip, r1, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:948
    bba8:	e92d43f0 	push	{r4, r5, r6, r7, r8, r9, lr}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:949
    bbac:	33a05000 	movcc	r5, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:948
    bbb0:	e59d701c 	ldr	r7, [sp, #28]
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:949
    bbb4:	31a06005 	movcc	r6, r5
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:960
    bbb8:	3a00003b 	bcc	bcac <__udivmoddi4+0x10c>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:962
    bbbc:	e3530000 	cmp	r3, #0
    bbc0:	016fcf12 	clzeq	ip, r2
    bbc4:	116fef13 	clzne	lr, r3
    bbc8:	028ce020 	addeq	lr, ip, #32
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:963
    bbcc:	e3510000 	cmp	r1, #0
    bbd0:	016fcf10 	clzeq	ip, r0
    bbd4:	028cc020 	addeq	ip, ip, #32
    bbd8:	116fcf11 	clzne	ip, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:965
    bbdc:	e04ec00c 	sub	ip, lr, ip
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:966
    bbe0:	e1a03c13 	lsl	r3, r3, ip
    bbe4:	e24c9020 	sub	r9, ip, #32
    bbe8:	e1833912 	orr	r3, r3, r2, lsl r9
    bbec:	e1a04c12 	lsl	r4, r2, ip
    bbf0:	e26c8020 	rsb	r8, ip, #32
    bbf4:	e1833832 	orr	r3, r3, r2, lsr r8
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:973
    bbf8:	e1500004 	cmp	r0, r4
    bbfc:	e0d12003 	sbcs	r2, r1, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:949
    bc00:	33a05000 	movcc	r5, #0
    bc04:	31a06005 	movcc	r6, r5
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:973
    bc08:	3a000005 	bcc	bc24 <__udivmoddi4+0x84>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:976
    bc0c:	e3a05001 	mov	r5, #1
    bc10:	e1a06915 	lsl	r6, r5, r9
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:975
    bc14:	e0500004 	subs	r0, r0, r4
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:976
    bc18:	e1866835 	orr	r6, r6, r5, lsr r8
    bc1c:	e1a05c15 	lsl	r5, r5, ip
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:975
    bc20:	e0c11003 	sbc	r1, r1, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:979
    bc24:	e35c0000 	cmp	ip, #0
    bc28:	0a00001f 	beq	bcac <__udivmoddi4+0x10c>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:981
    bc2c:	e1a040a4 	lsr	r4, r4, #1
    bc30:	e1844f83 	orr	r4, r4, r3, lsl #31
    bc34:	e1a020a3 	lsr	r2, r3, #1
    bc38:	e1a0e00c 	mov	lr, ip
    bc3c:	ea000007 	b	bc60 <__udivmoddi4+0xc0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:989
    bc40:	e0503004 	subs	r3, r0, r4
    bc44:	e0c11002 	sbc	r1, r1, r2
    bc48:	e0933003 	adds	r3, r3, r3
    bc4c:	e0a11001 	adc	r1, r1, r1
    bc50:	e2930001 	adds	r0, r3, #1
    bc54:	e2a11000 	adc	r1, r1, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:993
    bc58:	e25ee001 	subs	lr, lr, #1
    bc5c:	0a000006 	beq	bc7c <__udivmoddi4+0xdc>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:988
    bc60:	e1500004 	cmp	r0, r4
    bc64:	e0d13002 	sbcs	r3, r1, r2
    bc68:	2afffff4 	bcs	bc40 <__udivmoddi4+0xa0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:991
    bc6c:	e0900000 	adds	r0, r0, r0
    bc70:	e0a11001 	adc	r1, r1, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:993
    bc74:	e25ee001 	subs	lr, lr, #1
    bc78:	1afffff8 	bne	bc60 <__udivmoddi4+0xc0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:997
    bc7c:	e0955000 	adds	r5, r5, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:998
    bc80:	e1a00c30 	lsr	r0, r0, ip
    bc84:	e1800811 	orr	r0, r0, r1, lsl r8
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:997
    bc88:	e0a66001 	adc	r6, r6, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:998
    bc8c:	e1800931 	orr	r0, r0, r1, lsr r9
    bc90:	e1a01c31 	lsr	r1, r1, ip
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:999
    bc94:	e1a03c10 	lsl	r3, r0, ip
    bc98:	e1a0cc11 	lsl	ip, r1, ip
    bc9c:	e18cc910 	orr	ip, ip, r0, lsl r9
    bca0:	e18cc830 	orr	ip, ip, r0, lsr r8
    bca4:	e0555003 	subs	r5, r5, r3
    bca8:	e0c6600c 	sbc	r6, r6, ip
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1003
    bcac:	e3570000 	cmp	r7, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1004
    bcb0:	11c700f0 	strdne	r0, [r7]
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1006
    bcb4:	e1a00005 	mov	r0, r5
    bcb8:	e1a01006 	mov	r1, r6
    bcbc:	e8bd83f0 	pop	{r4, r5, r6, r7, r8, r9, pc}

0000bcc0 <memset>:
memset():
/build/newlib-pB30de/newlib-3.3.0/build/arm-none-eabi/arm/v5te/hard/newlib/libc/string/../../../../../../../../newlib/libc/string/memset.c:51
    bcc0:	e3100003 	tst	r0, #3
    bcc4:	0a00003f 	beq	bdc8 <memset+0x108>
/build/newlib-pB30de/newlib-3.3.0/build/arm-none-eabi/arm/v5te/hard/newlib/libc/string/../../../../../../../../newlib/libc/string/memset.c:53
    bcc8:	e3520000 	cmp	r2, #0
    bccc:	e2422001 	sub	r2, r2, #1
    bcd0:	012fff1e 	bxeq	lr
/build/newlib-pB30de/newlib-3.3.0/build/arm-none-eabi/arm/v5te/hard/newlib/libc/string/../../../../../../../../newlib/libc/string/memset.c:54
    bcd4:	e201c0ff 	and	ip, r1, #255	; 0xff
/build/newlib-pB30de/newlib-3.3.0/build/arm-none-eabi/arm/v5te/hard/newlib/libc/string/../../../../../../../../newlib/libc/string/memset.c:42
    bcd8:	e1a03000 	mov	r3, r0
    bcdc:	ea000002 	b	bcec <memset+0x2c>
/build/newlib-pB30de/newlib-3.3.0/build/arm-none-eabi/arm/v5te/hard/newlib/libc/string/../../../../../../../../newlib/libc/string/memset.c:53
    bce0:	e2422001 	sub	r2, r2, #1
    bce4:	e3720001 	cmn	r2, #1
    bce8:	012fff1e 	bxeq	lr
/build/newlib-pB30de/newlib-3.3.0/build/arm-none-eabi/arm/v5te/hard/newlib/libc/string/../../../../../../../../newlib/libc/string/memset.c:54
    bcec:	e4c3c001 	strb	ip, [r3], #1
/build/newlib-pB30de/newlib-3.3.0/build/arm-none-eabi/arm/v5te/hard/newlib/libc/string/../../../../../../../../newlib/libc/string/memset.c:51
    bcf0:	e3130003 	tst	r3, #3
    bcf4:	1afffff9 	bne	bce0 <memset+0x20>
/build/newlib-pB30de/newlib-3.3.0/build/arm-none-eabi/arm/v5te/hard/newlib/libc/string/../../../../../../../../newlib/libc/string/memset.c:59
    bcf8:	e3520003 	cmp	r2, #3
    bcfc:	9a000027 	bls	bda0 <memset+0xe0>
/build/newlib-pB30de/newlib-3.3.0/build/arm-none-eabi/arm/v5te/hard/newlib/libc/string/../../../../../../../../newlib/libc/string/memset.c:41
    bd00:	e92d4030 	push	{r4, r5, lr}
/build/newlib-pB30de/newlib-3.3.0/build/arm-none-eabi/arm/v5te/hard/newlib/libc/string/../../../../../../../../newlib/libc/string/memset.c:48
    bd04:	e201e0ff 	and	lr, r1, #255	; 0xff
/build/newlib-pB30de/newlib-3.3.0/build/arm-none-eabi/arm/v5te/hard/newlib/libc/string/../../../../../../../../newlib/libc/string/memset.c:66
    bd08:	e18ee40e 	orr	lr, lr, lr, lsl #8
/build/newlib-pB30de/newlib-3.3.0/build/arm-none-eabi/arm/v5te/hard/newlib/libc/string/../../../../../../../../newlib/libc/string/memset.c:72
    bd0c:	e352000f 	cmp	r2, #15
/build/newlib-pB30de/newlib-3.3.0/build/arm-none-eabi/arm/v5te/hard/newlib/libc/string/../../../../../../../../newlib/libc/string/memset.c:67
    bd10:	e18ee80e 	orr	lr, lr, lr, lsl #16
/build/newlib-pB30de/newlib-3.3.0/build/arm-none-eabi/arm/v5te/hard/newlib/libc/string/../../../../../../../../newlib/libc/string/memset.c:72
    bd14:	9a00002d 	bls	bdd0 <memset+0x110>
    bd18:	e242c010 	sub	ip, r2, #16
    bd1c:	e3cc400f 	bic	r4, ip, #15
    bd20:	e2835020 	add	r5, r3, #32
    bd24:	e0855004 	add	r5, r5, r4
    bd28:	e1a0422c 	lsr	r4, ip, #4
    bd2c:	e283c010 	add	ip, r3, #16
/build/newlib-pB30de/newlib-3.3.0/build/arm-none-eabi/arm/v5te/hard/newlib/libc/string/../../../../../../../../newlib/libc/string/memset.c:74
    bd30:	e50ce010 	str	lr, [ip, #-16]
/build/newlib-pB30de/newlib-3.3.0/build/arm-none-eabi/arm/v5te/hard/newlib/libc/string/../../../../../../../../newlib/libc/string/memset.c:75
    bd34:	e50ce00c 	str	lr, [ip, #-12]
/build/newlib-pB30de/newlib-3.3.0/build/arm-none-eabi/arm/v5te/hard/newlib/libc/string/../../../../../../../../newlib/libc/string/memset.c:76
    bd38:	e50ce008 	str	lr, [ip, #-8]
/build/newlib-pB30de/newlib-3.3.0/build/arm-none-eabi/arm/v5te/hard/newlib/libc/string/../../../../../../../../newlib/libc/string/memset.c:77
    bd3c:	e50ce004 	str	lr, [ip, #-4]
/build/newlib-pB30de/newlib-3.3.0/build/arm-none-eabi/arm/v5te/hard/newlib/libc/string/../../../../../../../../newlib/libc/string/memset.c:72
    bd40:	e28cc010 	add	ip, ip, #16
    bd44:	e15c0005 	cmp	ip, r5
    bd48:	1afffff8 	bne	bd30 <memset+0x70>
/build/newlib-pB30de/newlib-3.3.0/build/arm-none-eabi/arm/v5te/hard/newlib/libc/string/../../../../../../../../newlib/libc/string/memset.c:77
    bd4c:	e284c001 	add	ip, r4, #1
/build/newlib-pB30de/newlib-3.3.0/build/arm-none-eabi/arm/v5te/hard/newlib/libc/string/../../../../../../../../newlib/libc/string/memset.c:81
    bd50:	e312000c 	tst	r2, #12
/build/newlib-pB30de/newlib-3.3.0/build/arm-none-eabi/arm/v5te/hard/newlib/libc/string/../../../../../../../../newlib/libc/string/memset.c:77
    bd54:	e083c20c 	add	ip, r3, ip, lsl #4
/build/newlib-pB30de/newlib-3.3.0/build/arm-none-eabi/arm/v5te/hard/newlib/libc/string/../../../../../../../../newlib/libc/string/memset.c:78
    bd58:	e202200f 	and	r2, r2, #15
/build/newlib-pB30de/newlib-3.3.0/build/arm-none-eabi/arm/v5te/hard/newlib/libc/string/../../../../../../../../newlib/libc/string/memset.c:81
    bd5c:	0a000017 	beq	bdc0 <memset+0x100>
    bd60:	e2423004 	sub	r3, r2, #4
    bd64:	e3c33003 	bic	r3, r3, #3
    bd68:	e2833004 	add	r3, r3, #4
    bd6c:	e08c3003 	add	r3, ip, r3
/build/newlib-pB30de/newlib-3.3.0/build/arm-none-eabi/arm/v5te/hard/newlib/libc/string/../../../../../../../../newlib/libc/string/memset.c:83
    bd70:	e48ce004 	str	lr, [ip], #4
/build/newlib-pB30de/newlib-3.3.0/build/arm-none-eabi/arm/v5te/hard/newlib/libc/string/../../../../../../../../newlib/libc/string/memset.c:81
    bd74:	e153000c 	cmp	r3, ip
    bd78:	1afffffc 	bne	bd70 <memset+0xb0>
/build/newlib-pB30de/newlib-3.3.0/build/arm-none-eabi/arm/v5te/hard/newlib/libc/string/../../../../../../../../newlib/libc/string/memset.c:84
    bd7c:	e2022003 	and	r2, r2, #3
/build/newlib-pB30de/newlib-3.3.0/build/arm-none-eabi/arm/v5te/hard/newlib/libc/string/../../../../../../../../newlib/libc/string/memset.c:92
    bd80:	e3520000 	cmp	r2, #0
    bd84:	08bd8030 	popeq	{r4, r5, pc}
/build/newlib-pB30de/newlib-3.3.0/build/arm-none-eabi/arm/v5te/hard/newlib/libc/string/../../../../../../../../newlib/libc/string/memset.c:54
    bd88:	e20110ff 	and	r1, r1, #255	; 0xff
    bd8c:	e0832002 	add	r2, r3, r2
/build/newlib-pB30de/newlib-3.3.0/build/arm-none-eabi/arm/v5te/hard/newlib/libc/string/../../../../../../../../newlib/libc/string/memset.c:93
    bd90:	e4c31001 	strb	r1, [r3], #1
/build/newlib-pB30de/newlib-3.3.0/build/arm-none-eabi/arm/v5te/hard/newlib/libc/string/../../../../../../../../newlib/libc/string/memset.c:92
    bd94:	e1520003 	cmp	r2, r3
    bd98:	1afffffc 	bne	bd90 <memset+0xd0>
    bd9c:	e8bd8030 	pop	{r4, r5, pc}
    bda0:	e3520000 	cmp	r2, #0
    bda4:	012fff1e 	bxeq	lr
/build/newlib-pB30de/newlib-3.3.0/build/arm-none-eabi/arm/v5te/hard/newlib/libc/string/../../../../../../../../newlib/libc/string/memset.c:54
    bda8:	e20110ff 	and	r1, r1, #255	; 0xff
    bdac:	e0832002 	add	r2, r3, r2
/build/newlib-pB30de/newlib-3.3.0/build/arm-none-eabi/arm/v5te/hard/newlib/libc/string/../../../../../../../../newlib/libc/string/memset.c:93
    bdb0:	e4c31001 	strb	r1, [r3], #1
/build/newlib-pB30de/newlib-3.3.0/build/arm-none-eabi/arm/v5te/hard/newlib/libc/string/../../../../../../../../newlib/libc/string/memset.c:92
    bdb4:	e1520003 	cmp	r2, r3
    bdb8:	1afffffc 	bne	bdb0 <memset+0xf0>
    bdbc:	e12fff1e 	bx	lr
/build/newlib-pB30de/newlib-3.3.0/build/arm-none-eabi/arm/v5te/hard/newlib/libc/string/../../../../../../../../newlib/libc/string/memset.c:77
    bdc0:	e1a0300c 	mov	r3, ip
    bdc4:	eaffffed 	b	bd80 <memset+0xc0>
/build/newlib-pB30de/newlib-3.3.0/build/arm-none-eabi/arm/v5te/hard/newlib/libc/string/../../../../../../../../newlib/libc/string/memset.c:42
    bdc8:	e1a03000 	mov	r3, r0
    bdcc:	eaffffc9 	b	bcf8 <memset+0x38>
/build/newlib-pB30de/newlib-3.3.0/build/arm-none-eabi/arm/v5te/hard/newlib/libc/string/../../../../../../../../newlib/libc/string/memset.c:72
    bdd0:	e1a0c003 	mov	ip, r3
    bdd4:	eaffffe1 	b	bd60 <memset+0xa0>

Disassembly of section .rodata:

0000bdd8 <_ZL13Lock_Unlocked>:
    bdd8:	00000000 	andeq	r0, r0, r0

0000bddc <_ZL11Lock_Locked>:
    bddc:	00000001 	andeq	r0, r0, r1

0000bde0 <_ZL21MaxFSDriverNameLength>:
    bde0:	00000010 	andeq	r0, r0, r0, lsl r0

0000bde4 <_ZL17MaxFilenameLength>:
    bde4:	00000010 	andeq	r0, r0, r0, lsl r0

0000bde8 <_ZL13MaxPathLength>:
    bde8:	00000080 	andeq	r0, r0, r0, lsl #1

0000bdec <_ZL18NoFilesystemDriver>:
    bdec:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000bdf0 <_ZL9NotifyAll>:
    bdf0:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000bdf4 <_ZL24Max_Process_Opened_Files>:
    bdf4:	00000010 	andeq	r0, r0, r0, lsl r0

0000bdf8 <_ZL10Indefinite>:
    bdf8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000bdfc <_ZL18Deadline_Unchanged>:
    bdfc:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

0000be00 <_ZL14Invalid_Handle>:
    be00:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000be04 <_ZL16POPULATION_COUNT>:
    be04:	000001f4 	strdeq	r0, [r0], -r4

0000be08 <_ZL11EPOCH_COUNT>:
    be08:	00000032 	andeq	r0, r0, r2, lsr r0

0000be0c <_ZL16DATA_WINDOW_SIZE>:
    be0c:	00000014 	andeq	r0, r0, r4, lsl r0
    be10:	636c6143 	cmnvs	ip, #-1073741808	; 0xc0000010
    be14:	7620534f 	strtvc	r5, [r0], -pc, asr #6
    be18:	0a312e31 	beq	c576e4 <__bss_end+0xc4b5ec>
    be1c:	00000000 	andeq	r0, r0, r0
    be20:	6f747541 	svcvs	0x00747541
    be24:	4a203a72 	bmi	81a7f4 <__bss_end+0x80e6fc>
    be28:	20697269 	rsbcs	r7, r9, r9, ror #4
    be2c:	66657254 			; <UNDEFINED> instruction: 0x66657254
    be30:	28206c69 	stmdacs	r0!, {r0, r3, r5, r6, sl, fp, sp, lr}
    be34:	4e323241 	cdpmi	2, 3, cr3, cr2, cr1, {2}
    be38:	30363030 	eorscc	r3, r6, r0, lsr r0
    be3c:	000a2950 	andeq	r2, sl, r0, asr r9
    be40:	6564615a 	strbvs	r6, [r4, #-346]!	; 0xfffffea6
    be44:	2065746a 	rsbcs	r7, r5, sl, ror #8
    be48:	706a656e 	rsbvc	r6, sl, lr, ror #10
    be4c:	20657672 	rsbcs	r7, r5, r2, ror r6
    be50:	6f736163 	svcvs	0x00736163
    be54:	72207976 	eorvc	r7, r0, #1933312	; 0x1d8000
    be58:	73657a6f 	cmnvc	r5, #454656	; 0x6f000
    be5c:	20707574 	rsbscs	r7, r0, r4, ror r5
    be60:	72702061 	rsbsvc	r2, r0, #97	; 0x61
    be64:	6b696465 	blvs	1a65000 <__bss_end+0x1a58f08>
    be68:	20696e63 	rsbcs	r6, r9, r3, ror #28
    be6c:	6e656b6f 	vnmulvs.f64	d22, d5, d31
    be70:	76206f6b 	strtvc	r6, [r0], -fp, ror #30
    be74:	6e696d20 	cdpvs	13, 6, cr6, cr9, cr0, {1}
    be78:	63617475 	cmnvs	r1, #1962934272	; 0x75000000
    be7c:	00000a68 	andeq	r0, r0, r8, ror #20
    be80:	656c6144 	strbvs	r6, [ip, #-324]!	; 0xfffffebc
    be84:	646f7020 	strbtvs	r7, [pc], #-32	; be8c <_ZL16DATA_WINDOW_SIZE+0x80>
    be88:	6f726f70 	svcvs	0x00726f70
    be8c:	796e6176 	stmdbvc	lr!, {r1, r2, r4, r5, r6, r8, sp, lr}^
    be90:	69727020 	ldmdbvs	r2!, {r5, ip, sp, lr}^
    be94:	797a616b 	ldmdbvc	sl!, {r0, r1, r3, r5, r6, r8, sp, lr}^
    be98:	7473203a 	ldrbtvc	r2, [r3], #-58	; 0xffffffc6
    be9c:	202c706f 	eorcs	r7, ip, pc, rrx
    bea0:	61726170 	cmnvs	r2, r0, ror r1
    bea4:	6574656d 	ldrbvs	r6, [r4, #-1389]!	; 0xfffffa93
    bea8:	000a7372 	andeq	r7, sl, r2, ror r3
    beac:	706f7473 	rsbvc	r7, pc, r3, ror r4	; <UNPREDICTABLE>
    beb0:	7a202d20 	bvc	817338 <__bss_end+0x80b240>
    beb4:	61747361 	cmnvs	r4, r1, ror #6
    beb8:	66206976 			; <UNDEFINED> instruction: 0x66206976
    bebc:	69747469 	ldmdbvs	r4!, {r0, r3, r5, r6, sl, ip, sp, lr}^
    bec0:	6d20676e 	stcvs	7, cr6, [r0, #-440]!	; 0xfffffe48
    bec4:	6c65646f 	cfstrdvs	mvd6, [r5], #-444	; 0xfffffe44
    bec8:	00000a75 	andeq	r0, r0, r5, ror sl
    becc:	61726170 	cmnvs	r2, r0, ror r1
    bed0:	6574656d 	ldrbvs	r6, [r4, #-1389]!	; 0xfffffa93
    bed4:	2d207372 	stccs	3, cr7, [r0, #-456]!	; 0xfffffe38
    bed8:	70797620 	rsbsvc	r7, r9, r0, lsr #12
    bedc:	20657369 	rsbcs	r7, r5, r9, ror #6
    bee0:	61726170 	cmnvs	r2, r0, ror r1
    bee4:	7274656d 	rsbsvc	r6, r4, #457179136	; 0x1b400000
    bee8:	6f6d2079 	svcvs	0x006d2079
    beec:	756c6564 	strbvc	r6, [ip, #-1380]!	; 0xfffffa9c
    bef0:	0000000a 	andeq	r0, r0, sl
    bef4:	3a564544 	bcc	159d40c <__bss_end+0x1591314>
    bef8:	74726175 	ldrbtvc	r6, [r2], #-373	; 0xfffffe8b
    befc:	0000302f 	andeq	r3, r0, pc, lsr #32
    bf00:	676e6953 			; <UNDEFINED> instruction: 0x676e6953
    bf04:	7420656c 	strtvc	r6, [r0], #-1388	; 0xfffffa94
    bf08:	206b7361 	rsbcs	r7, fp, r1, ror #6
    bf0c:	656e6f6b 	strbvs	r6, [lr, #-3947]!	; 0xfffff095
    bf10:	63202c63 			; <UNDEFINED> instruction: 0x63202c63
    bf14:	796b7561 	stmdbvc	fp!, {r0, r5, r6, r8, sl, ip, sp, lr}^
    bf18:	616e6d20 	cmnvs	lr, r0, lsr #26
    bf1c:	0a796b75 	beq	1e66cf8 <__bss_end+0x1e5ac00>
    bf20:	00000000 	andeq	r0, r0, r0
    bf24:	202c4b4f 	eorcs	r4, ip, pc, asr #22
    bf28:	64657270 	strbtvs	r7, [r5], #-624	; 0xfffffd90
    bf2c:	65766f70 	ldrbvs	r6, [r6, #-3952]!	; 0xfffff090
    bf30:	00002064 	andeq	r2, r0, r4, rrx
    bf34:	202c4b4f 	eorcs	r4, ip, pc, asr #22
    bf38:	6b6f726b 	blvs	1be88ec <__bss_end+0x1bdc7f4>
    bf3c:	6e61766f 	cdpvs	6, 6, cr7, cr1, cr15, {3}
    bf40:	00002069 	andeq	r2, r0, r9, rrx
    bf44:	6e696d20 	cdpvs	13, 6, cr6, cr9, cr0, {1}
    bf48:	000a7475 	andeq	r7, sl, r5, ror r4

0000bf4c <_ZL13Lock_Unlocked>:
    bf4c:	00000000 	andeq	r0, r0, r0

0000bf50 <_ZL11Lock_Locked>:
    bf50:	00000001 	andeq	r0, r0, r1

0000bf54 <_ZL21MaxFSDriverNameLength>:
    bf54:	00000010 	andeq	r0, r0, r0, lsl r0

0000bf58 <_ZL17MaxFilenameLength>:
    bf58:	00000010 	andeq	r0, r0, r0, lsl r0

0000bf5c <_ZL13MaxPathLength>:
    bf5c:	00000080 	andeq	r0, r0, r0, lsl #1

0000bf60 <_ZL18NoFilesystemDriver>:
    bf60:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000bf64 <_ZL9NotifyAll>:
    bf64:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000bf68 <_ZL24Max_Process_Opened_Files>:
    bf68:	00000010 	andeq	r0, r0, r0, lsl r0

0000bf6c <_ZL10Indefinite>:
    bf6c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000bf70 <_ZL18Deadline_Unchanged>:
    bf70:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

0000bf74 <_ZL14Invalid_Handle>:
    bf74:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
    bf78:	0000002c 	andeq	r0, r0, ip, lsr #32
    bf7c:	0000000a 	andeq	r0, r0, sl
    bf80:	203d2041 	eorscs	r2, sp, r1, asr #32
    bf84:	3d204200 	sfmcc	f4, 4, [r0, #-0]
    bf88:	20430020 	subcs	r0, r3, r0, lsr #32
    bf8c:	4400203d 	strmi	r2, [r0], #-61	; 0xffffffc3
    bf90:	00203d20 	eoreq	r3, r0, r0, lsr #26
    bf94:	203d2045 	eorscs	r2, sp, r5, asr #32
    bf98:	00000000 	andeq	r0, r0, r0
    bf9c:	736c6144 	cmnvc	ip, #68, 2
    bfa0:	61642069 	cmnvs	r4, r9, rrx
    bfa4:	79766f74 	ldmdbvc	r6!, {r2, r4, r5, r6, r8, r9, sl, fp, sp, lr}^
    bfa8:	6f7a7620 	svcvs	0x007a7620
    bfac:	206b6572 	rsbcs	r6, fp, r2, ror r5
    bfb0:	6d206573 	cfstr32vs	mvfx6, [r0, #-460]!	; 0xfffffe34
    bfb4:	656e2069 	strbvs	r2, [lr, #-105]!	; 0xffffff97
    bfb8:	646a6576 	strbtvs	r6, [sl], #-1398	; 0xfffffa8a
    bfbc:	6f642065 	svcvs	0x00642065
    bfc0:	656b6f20 	strbvs	r6, [fp, #-3872]!	; 0xfffff0e0
    bfc4:	20616b6e 	rsbcs	r6, r1, lr, ror #22
    bfc8:	0000000a 	andeq	r0, r0, sl
    bfcc:	61726170 	cmnvs	r2, r0, ror r1
    bfd0:	6574656d 	ldrbvs	r6, [r4, #-1389]!	; 0xfffffa93
    bfd4:	00007372 	andeq	r7, r0, r2, ror r3
    bfd8:	706f7473 	rsbvc	r7, pc, r3, ror r4	; <UNPREDICTABLE>
    bfdc:	00000000 	andeq	r0, r0, r0
    bfe0:	7473615a 	ldrbtvc	r6, [r3], #-346	; 0xfffffea6
    bfe4:	6a757661 	bvs	1d69970 <__bss_end+0x1d5d878>
    bfe8:	79762069 	ldmdbvc	r6!, {r0, r3, r5, r6, sp}^
    bfec:	65636f70 	strbvs	r6, [r3, #-3952]!	; 0xfffff090
    bff0:	00000a74 	andeq	r0, r0, r4, ror sl
    bff4:	6e7a654e 	cdpvs	5, 7, cr6, cr10, cr14, {2}
    bff8:	20796d61 	rsbscs	r6, r9, r1, ror #26
    bffc:	6b697270 	blvs	1a689c4 <__bss_end+0x1a5c8cc>
    c000:	000a7a61 	andeq	r7, sl, r1, ror #20
    c004:	0000003e 	andeq	r0, r0, lr, lsr r0
    c008:	69636f50 	stmdbvs	r3!, {r4, r6, r8, r9, sl, fp, sp, lr}^
    c00c:	2e6d6174 	mcrcs	1, 3, r6, cr13, cr4, {3}
    c010:	000a2e2e 	andeq	r2, sl, lr, lsr #28
    c014:	0a4e614e 	beq	13a4554 <__bss_end+0x139845c>
    c018:	00000000 	andeq	r0, r0, r0

0000c01c <_ZL13Lock_Unlocked>:
    c01c:	00000000 	andeq	r0, r0, r0

0000c020 <_ZL11Lock_Locked>:
    c020:	00000001 	andeq	r0, r0, r1

0000c024 <_ZL21MaxFSDriverNameLength>:
    c024:	00000010 	andeq	r0, r0, r0, lsl r0

0000c028 <_ZL17MaxFilenameLength>:
    c028:	00000010 	andeq	r0, r0, r0, lsl r0

0000c02c <_ZL13MaxPathLength>:
    c02c:	00000080 	andeq	r0, r0, r0, lsl #1

0000c030 <_ZL18NoFilesystemDriver>:
    c030:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000c034 <_ZL9NotifyAll>:
    c034:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000c038 <_ZL24Max_Process_Opened_Files>:
    c038:	00000010 	andeq	r0, r0, r0, lsl r0

0000c03c <_ZL10Indefinite>:
    c03c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000c040 <_ZL18Deadline_Unchanged>:
    c040:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

0000c044 <_ZL14Invalid_Handle>:
    c044:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000c048 <_ZL13Lock_Unlocked>:
    c048:	00000000 	andeq	r0, r0, r0

0000c04c <_ZL11Lock_Locked>:
    c04c:	00000001 	andeq	r0, r0, r1

0000c050 <_ZL21MaxFSDriverNameLength>:
    c050:	00000010 	andeq	r0, r0, r0, lsl r0

0000c054 <_ZL17MaxFilenameLength>:
    c054:	00000010 	andeq	r0, r0, r0, lsl r0

0000c058 <_ZL13MaxPathLength>:
    c058:	00000080 	andeq	r0, r0, r0, lsl #1

0000c05c <_ZL18NoFilesystemDriver>:
    c05c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000c060 <_ZL9NotifyAll>:
    c060:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000c064 <_ZL24Max_Process_Opened_Files>:
    c064:	00000010 	andeq	r0, r0, r0, lsl r0

0000c068 <_ZL10Indefinite>:
    c068:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000c06c <_ZL18Deadline_Unchanged>:
    c06c:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

0000c070 <_ZL14Invalid_Handle>:
    c070:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
    c074:	6c70654e 	cfldr64vs	mvdx6, [r0], #-312	; 0xfffffec8
    c078:	796e7461 	stmdbvc	lr!, {r0, r5, r6, sl, ip, sp, lr}^
    c07c:	74737620 	ldrbtvc	r7, [r3], #-1568	; 0xfffff9e0
    c080:	000a7075 	andeq	r7, sl, r5, ror r0

0000c084 <_ZL13Lock_Unlocked>:
    c084:	00000000 	andeq	r0, r0, r0

0000c088 <_ZL11Lock_Locked>:
    c088:	00000001 	andeq	r0, r0, r1

0000c08c <_ZL21MaxFSDriverNameLength>:
    c08c:	00000010 	andeq	r0, r0, r0, lsl r0

0000c090 <_ZL17MaxFilenameLength>:
    c090:	00000010 	andeq	r0, r0, r0, lsl r0

0000c094 <_ZL13MaxPathLength>:
    c094:	00000080 	andeq	r0, r0, r0, lsl #1

0000c098 <_ZL18NoFilesystemDriver>:
    c098:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000c09c <_ZL9NotifyAll>:
    c09c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000c0a0 <_ZL24Max_Process_Opened_Files>:
    c0a0:	00000010 	andeq	r0, r0, r0, lsl r0

0000c0a4 <_ZL10Indefinite>:
    c0a4:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000c0a8 <_ZL18Deadline_Unchanged>:
    c0a8:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

0000c0ac <_ZL14Invalid_Handle>:
    c0ac:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000c0b0 <_ZL16Pipe_File_Prefix>:
    c0b0:	3a535953 	bcc	14e2604 <__bss_end+0x14d650c>
    c0b4:	65706970 	ldrbvs	r6, [r0, #-2416]!	; 0xfffff690
    c0b8:	0000002f 	andeq	r0, r0, pc, lsr #32

0000c0bc <_ZN12_GLOBAL__N_1L11CharConvArrE>:
    c0bc:	33323130 	teqcc	r2, #48, 2
    c0c0:	37363534 			; <UNDEFINED> instruction: 0x37363534
    c0c4:	42413938 	submi	r3, r1, #56, 18	; 0xe0000
    c0c8:	46454443 	strbmi	r4, [r5], -r3, asr #8
	...

Disassembly of section .ARM.exidx:

0000c0d0 <.ARM.exidx>:
    c0d0:	7ffffad0 	svcvc	0x00fffad0
    c0d4:	00000001 	andeq	r0, r0, r1

Disassembly of section .data:

0000c0d8 <__CTOR_LIST__>:
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:2355
    c0d8:	00009da0 	andeq	r9, r0, r0, lsr #27

Disassembly of section .bss:

0000c0dc <h>:
	...

Disassembly of section .ARM.attributes:

00000000 <.ARM.attributes>:
   0:	00002e41 	andeq	r2, r0, r1, asr #28
   4:	61656100 	cmnvs	r5, r0, lsl #2
   8:	01006962 	tsteq	r0, r2, ror #18
   c:	00000024 	andeq	r0, r0, r4, lsr #32
  10:	4b5a3605 	blmi	168d82c <__bss_end+0x1681734>
  14:	08070600 	stmdaeq	r7, {r9, sl}
  18:	0a010901 	beq	42424 <__bss_end+0x3632c>
  1c:	14041202 	strne	r1, [r4], #-514	; 0xfffffdfe
  20:	17011501 	strne	r1, [r1, -r1, lsl #10]
  24:	1a011803 	bne	46038 <__bss_end+0x39f40>
  28:	22011c01 	andcs	r1, r1, #256	; 0x100
  2c:	Address 0x000000000000002c is out of bounds.


Disassembly of section .comment:

00000000 <.comment>:
   0:	3a434347 	bcc	10d0d24 <__bss_end+0x10c4c2c>
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
      e0:	db010100 	blle	404e8 <__bss_end+0x343f0>
      e4:	03000000 	movweq	r0, #0
      e8:	00005200 	andeq	r5, r0, r0, lsl #4
      ec:	fb010200 	blx	408f6 <__bss_end+0x347fe>
      f0:	01000d0e 	tsteq	r0, lr, lsl #26
      f4:	00010101 	andeq	r0, r1, r1, lsl #2
      f8:	00010000 	andeq	r0, r1, r0
      fc:	682f0100 	stmdavs	pc!, {r8}	; <UNPREDICTABLE>
     100:	2f656d6f 	svccs	0x00656d6f
     104:	66657274 			; <UNDEFINED> instruction: 0x66657274
     108:	732f6c69 			; <UNDEFINED> instruction: 0x732f6c69
     10c:	732f6d65 			; <UNDEFINED> instruction: 0x732f6d65
     110:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
     114:	752f7365 	strvc	r7, [pc, #-869]!	; fffffdb7 <__bss_end+0xffff3cbf>
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
     14c:	0a05830b 	beq	160d80 <__bss_end+0x154c88>
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
     178:	4a030402 	bmi	c1188 <__bss_end+0xb5090>
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
     1ac:	4a020402 	bmi	811bc <__bss_end+0x750c4>
     1b0:	02000205 	andeq	r0, r0, #1342177280	; 0x50000000
     1b4:	052d0204 	streq	r0, [sp, #-516]!	; 0xfffffdfc
     1b8:	01058509 	tsteq	r5, r9, lsl #10
     1bc:	000a022f 	andeq	r0, sl, pc, lsr #4
     1c0:	02e30101 	rsceq	r0, r3, #1073741824	; 0x40000000
     1c4:	00030000 	andeq	r0, r3, r0
     1c8:	000001f4 	strdeq	r0, [r0], -r4
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
     200:	732f2e2e 			; <UNDEFINED> instruction: 0x732f2e2e
     204:	696c6474 	stmdbvs	ip!, {r2, r4, r5, r6, sl, sp, lr}^
     208:	6e692f62 	cdpvs	15, 6, cr2, cr9, cr2, {3}
     20c:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
     210:	682f0065 	stmdavs	pc!, {r0, r2, r5, r6}	; <UNPREDICTABLE>
     214:	2f656d6f 	svccs	0x00656d6f
     218:	66657274 			; <UNDEFINED> instruction: 0x66657274
     21c:	732f6c69 			; <UNDEFINED> instruction: 0x732f6c69
     220:	732f6d65 			; <UNDEFINED> instruction: 0x732f6d65
     224:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
     228:	752f7365 	strvc	r7, [pc, #-869]!	; fffffecb <__bss_end+0xffff3dd3>
     22c:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
     230:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
     234:	646f6d2f 	strbtvs	r6, [pc], #-3375	; 23c <shift+0x23c>
     238:	745f6c65 	ldrbvc	r6, [pc], #-3173	; 240 <shift+0x240>
     23c:	006b7361 	rsbeq	r7, fp, r1, ror #6
     240:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 18c <shift+0x18c>
     244:	72742f65 	rsbsvc	r2, r4, #404	; 0x194
     248:	6c696665 	stclvs	6, cr6, [r9], #-404	; 0xfffffe6c
     24c:	6d65732f 	stclvs	3, cr7, [r5, #-188]!	; 0xffffff44
     250:	756f732f 	strbvc	r7, [pc, #-815]!	; ffffff29 <__bss_end+0xffff3e31>
     254:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
     258:	6573752f 	ldrbvs	r7, [r3, #-1327]!	; 0xfffffad1
     25c:	61707372 	cmnvs	r0, r2, ror r3
     260:	2e2f6563 	cfsh64cs	mvdx6, mvdx15, #51
     264:	656b2f2e 	strbvs	r2, [fp, #-3886]!	; 0xfffff0d2
     268:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
     26c:	636e692f 	cmnvs	lr, #770048	; 0xbc000
     270:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
     274:	6f72702f 	svcvs	0x0072702f
     278:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     27c:	6f682f00 	svcvs	0x00682f00
     280:	742f656d 	strtvc	r6, [pc], #-1389	; 288 <shift+0x288>
     284:	69666572 	stmdbvs	r6!, {r1, r4, r5, r6, r8, sl, sp, lr}^
     288:	65732f6c 	ldrbvs	r2, [r3, #-3948]!	; 0xfffff094
     28c:	6f732f6d 	svcvs	0x00732f6d
     290:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
     294:	73752f73 	cmnvc	r5, #460	; 0x1cc
     298:	70737265 	rsbsvc	r7, r3, r5, ror #4
     29c:	2f656361 	svccs	0x00656361
     2a0:	6b2f2e2e 	blvs	bcbb60 <__bss_end+0xbbfa68>
     2a4:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
     2a8:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
     2ac:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
     2b0:	73662f65 	cmnvc	r6, #404	; 0x194
     2b4:	6f682f00 	svcvs	0x00682f00
     2b8:	742f656d 	strtvc	r6, [pc], #-1389	; 2c0 <shift+0x2c0>
     2bc:	69666572 	stmdbvs	r6!, {r1, r4, r5, r6, r8, sl, sp, lr}^
     2c0:	65732f6c 	ldrbvs	r2, [r3, #-3948]!	; 0xfffff094
     2c4:	6f732f6d 	svcvs	0x00732f6d
     2c8:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
     2cc:	73752f73 	cmnvc	r5, #460	; 0x1cc
     2d0:	70737265 	rsbsvc	r7, r3, r5, ror #4
     2d4:	2f656361 	svccs	0x00656361
     2d8:	65646f4d 	strbvs	r6, [r4, #-3917]!	; 0xfffff0b3
     2dc:	682f006c 	stmdavs	pc!, {r2, r3, r5, r6}	; <UNPREDICTABLE>
     2e0:	2f656d6f 	svccs	0x00656d6f
     2e4:	66657274 			; <UNDEFINED> instruction: 0x66657274
     2e8:	732f6c69 			; <UNDEFINED> instruction: 0x732f6c69
     2ec:	732f6d65 			; <UNDEFINED> instruction: 0x732f6d65
     2f0:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
     2f4:	752f7365 	strvc	r7, [pc, #-869]!	; ffffff97 <__bss_end+0xffff3e9f>
     2f8:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
     2fc:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
     300:	2f2e2e2f 	svccs	0x002e2e2f
     304:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
     308:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
     30c:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
     310:	622f6564 	eorvs	r6, pc, #100, 10	; 0x19000000
     314:	6472616f 	ldrbtvs	r6, [r2], #-367	; 0xfffffe91
     318:	6970722f 	ldmdbvs	r0!, {r0, r1, r2, r3, r5, r9, ip, sp, lr}^
     31c:	61682f30 	cmnvs	r8, r0, lsr pc
     320:	6d00006c 	stcvs	0, cr0, [r0, #-432]	; 0xfffffe50
     324:	726f6d65 	rsbvc	r6, pc, #6464	; 0x1940
     328:	00682e79 	rsbeq	r2, r8, r9, ror lr
     32c:	6d000001 	stcvs	0, cr0, [r0, #-4]
     330:	2e6e6961 	vnmulcs.f16	s13, s28, s3	; <UNPREDICTABLE>
     334:	00707063 	rsbseq	r7, r0, r3, rrx
     338:	73000002 	movwvc	r0, #2
     33c:	6c6e6970 			; <UNDEFINED> instruction: 0x6c6e6970
     340:	2e6b636f 	cdpcs	3, 6, cr6, cr11, cr15, {3}
     344:	00030068 	andeq	r0, r3, r8, rrx
     348:	6c696600 	stclvs	6, cr6, [r9], #-0
     34c:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     350:	2e6d6574 	mcrcs	5, 3, r6, cr13, cr4, {3}
     354:	00040068 	andeq	r0, r4, r8, rrx
     358:	6f727000 	svcvs	0x00727000
     35c:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     360:	0300682e 	movweq	r6, #2094	; 0x82e
     364:	72700000 	rsbsvc	r0, r0, #0
     368:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     36c:	616d5f73 	smcvs	54771	; 0xd5f3
     370:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     374:	00682e72 	rsbeq	r2, r8, r2, ror lr
     378:	48000003 	stmdami	r0, {r0, r1}
     37c:	5f706165 	svcpl	0x00706165
     380:	616e614d 	cmnvs	lr, sp, asr #2
     384:	2e726567 	cdpcs	5, 7, cr6, cr2, cr7, {3}
     388:	00010068 	andeq	r0, r1, r8, rrx
     38c:	64747300 	ldrbtvs	r7, [r4], #-768	; 0xfffffd00
     390:	66667562 	strbtvs	r7, [r6], -r2, ror #10
     394:	682e7265 	stmdavs	lr!, {r0, r2, r5, r6, r9, ip, sp, lr}
     398:	00000100 	andeq	r0, r0, r0, lsl #2
     39c:	646e6152 	strbtvs	r6, [lr], #-338	; 0xfffffeae
     3a0:	682e6d6f 	stmdavs	lr!, {r0, r1, r2, r3, r5, r6, r8, sl, fp, sp, lr}
     3a4:	00000100 	andeq	r0, r0, r0, lsl #2
     3a8:	65646f4d 	strbvs	r6, [r4, #-3917]!	; 0xfffff0b3
     3ac:	00682e6c 	rsbeq	r2, r8, ip, ror #28
     3b0:	69000005 	stmdbvs	r0, {r0, r2}
     3b4:	6564746e 	strbvs	r7, [r4, #-1134]!	; 0xfffffb92
     3b8:	00682e66 	rsbeq	r2, r8, r6, ror #28
     3bc:	00000006 	andeq	r0, r0, r6
     3c0:	05002905 	streq	r2, [r0, #-2309]	; 0xfffff6fb
     3c4:	00859002 	addeq	r9, r5, r2
     3c8:	13051600 	movwne	r1, #22016	; 0x5600
     3cc:	83010583 	movwhi	r0, #5507	; 0x1583
     3d0:	01000802 	tsteq	r0, r2, lsl #16
     3d4:	05020401 	streq	r0, [r2, #-1025]	; 0xfffffbff
     3d8:	0205001d 	andeq	r0, r5, #29
     3dc:	0000822c 	andeq	r8, r0, ip, lsr #4
     3e0:	05011203 	streq	r1, [r1, #-515]	; 0xfffffdfd
     3e4:	0b05840d 	bleq	161420 <__bss_end+0x155328>
     3e8:	4a0d0567 	bmi	34198c <__bss_end+0x335894>
     3ec:	054b0b05 	strbeq	r0, [fp, #-2821]	; 0xfffff4fb
     3f0:	0b054a0d 	bleq	152c2c <__bss_end+0x146b34>
     3f4:	4a0d054b 	bmi	341928 <__bss_end+0x335830>
     3f8:	054c0b05 	strbeq	r0, [ip, #-2821]	; 0xfffff4fb
     3fc:	0b054a0d 	bleq	152c38 <__bss_end+0x146b40>
     400:	4a0d054b 	bmi	341934 <__bss_end+0x33583c>
     404:	054b0b05 	strbeq	r0, [fp, #-2821]	; 0xfffff4fb
     408:	0b054a0d 	bleq	152c44 <__bss_end+0x146b4c>
     40c:	4a0d054b 	bmi	341940 <__bss_end+0x335848>
     410:	054b0b05 	strbeq	r0, [fp, #-2821]	; 0xfffff4fb
     414:	0b054a0d 	bleq	152c50 <__bss_end+0x146b58>
     418:	4a0d054b 	bmi	34194c <__bss_end+0x335854>
     41c:	054b0c05 	strbeq	r0, [fp, #-3077]	; 0xfffff3fb
     420:	0c054a0e 			; <UNDEFINED> instruction: 0x0c054a0e
     424:	4a0e054b 	bmi	381958 <__bss_end+0x375860>
     428:	054b0c05 	strbeq	r0, [fp, #-3077]	; 0xfffff3fb
     42c:	0c054a0e 			; <UNDEFINED> instruction: 0x0c054a0e
     430:	4a0e054b 	bmi	381964 <__bss_end+0x37586c>
     434:	054b0c05 	strbeq	r0, [fp, #-3077]	; 0xfffff3fb
     438:	0c054a0e 			; <UNDEFINED> instruction: 0x0c054a0e
     43c:	4a0e054b 	bmi	381970 <__bss_end+0x375878>
     440:	054b0c05 	strbeq	r0, [fp, #-3077]	; 0xfffff3fb
     444:	0c054a0e 			; <UNDEFINED> instruction: 0x0c054a0e
     448:	4a0e054b 	bmi	38197c <__bss_end+0x375884>
     44c:	054b0c05 	strbeq	r0, [fp, #-3077]	; 0xfffff3fb
     450:	0c054a0e 			; <UNDEFINED> instruction: 0x0c054a0e
     454:	4a0e054b 	bmi	381988 <__bss_end+0x375890>
     458:	054d0105 	strbeq	r0, [sp, #-261]	; 0xfffffefb
     45c:	142c0223 	strtne	r0, [ip], #-547	; 0xfffffddd
     460:	67831405 	strvs	r1, [r3, r5, lsl #8]
     464:	67676767 	strbvs	r6, [r7, -r7, ror #14]!
     468:	05670105 	strbeq	r0, [r7, #-261]!	; 0xfffffefb
     46c:	0523080b 	streq	r0, [r3, #-2059]!	; 0xfffff7f5
     470:	0a05681e 	beq	15a4f0 <__bss_end+0x14e3f8>
     474:	f3820c03 	vmull.u8	q0, d2, d3
     478:	1f0585f3 	svcne	0x000585f3
     47c:	d60905db 			; <UNDEFINED> instruction: 0xd60905db
     480:	05311505 	ldreq	r1, [r1, #-1285]!	; 0xfffffafb
     484:	4a16030f 	bmi	5810c8 <__bss_end+0x574fd0>
     488:	4d57054b 	cfldr64mi	mvdx0, [r7, #-300]	; 0xfffffed4
     48c:	90080705 	andls	r0, r8, r5, lsl #14
     490:	05301205 	ldreq	r1, [r0, #-517]!	; 0xfffffdfb
     494:	660b030b 	strvs	r0, [fp], -fp, lsl #6
     498:	054d1405 	strbeq	r1, [sp, #-1029]	; 0xfffffbfb
     49c:	0c05670a 	stceq	7, cr6, [r5], {10}
     4a0:	3001054f 	andcc	r0, r1, pc, asr #10
     4a4:	01001002 	tsteq	r0, r2
     4a8:	00097901 	andeq	r7, r9, r1, lsl #18
     4ac:	c7000300 	strgt	r0, [r0, -r0, lsl #6]
     4b0:	02000001 	andeq	r0, r0, #1
     4b4:	0d0efb01 	vstreq	d15, [lr, #-4]
     4b8:	01010100 	mrseq	r0, (UNDEF: 17)
     4bc:	00000001 	andeq	r0, r0, r1
     4c0:	01000001 	tsteq	r0, r1
     4c4:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 410 <shift+0x410>
     4c8:	72742f65 	rsbsvc	r2, r4, #404	; 0x194
     4cc:	6c696665 	stclvs	6, cr6, [r9], #-404	; 0xfffffe6c
     4d0:	6d65732f 	stclvs	3, cr7, [r5, #-188]!	; 0xffffff44
     4d4:	756f732f 	strbvc	r7, [pc, #-815]!	; 1ad <shift+0x1ad>
     4d8:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
     4dc:	6573752f 	ldrbvs	r7, [r3, #-1327]!	; 0xfffffad1
     4e0:	61707372 	cmnvs	r0, r2, ror r3
     4e4:	2e2f6563 	cfsh64cs	mvdx6, mvdx15, #51
     4e8:	74732f2e 	ldrbtvc	r2, [r3], #-3886	; 0xfffff0d2
     4ec:	62696c64 	rsbvs	r6, r9, #100, 24	; 0x6400
     4f0:	636e692f 	cmnvs	lr, #770048	; 0xbc000
     4f4:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
     4f8:	6f682f00 	svcvs	0x00682f00
     4fc:	742f656d 	strtvc	r6, [pc], #-1389	; 504 <shift+0x504>
     500:	69666572 	stmdbvs	r6!, {r1, r4, r5, r6, r8, sl, sp, lr}^
     504:	65732f6c 	ldrbvs	r2, [r3, #-3948]!	; 0xfffff094
     508:	6f732f6d 	svcvs	0x00732f6d
     50c:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
     510:	73752f73 	cmnvc	r5, #460	; 0x1cc
     514:	70737265 	rsbsvc	r7, r3, r5, ror #4
     518:	2f656361 	svccs	0x00656361
     51c:	65646f4d 	strbvs	r6, [r4, #-3917]!	; 0xfffff0b3
     520:	682f006c 	stmdavs	pc!, {r2, r3, r5, r6}	; <UNPREDICTABLE>
     524:	2f656d6f 	svccs	0x00656d6f
     528:	66657274 			; <UNDEFINED> instruction: 0x66657274
     52c:	732f6c69 			; <UNDEFINED> instruction: 0x732f6c69
     530:	732f6d65 			; <UNDEFINED> instruction: 0x732f6d65
     534:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
     538:	752f7365 	strvc	r7, [pc, #-869]!	; 1db <shift+0x1db>
     53c:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
     540:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
     544:	2f2e2e2f 	svccs	0x002e2e2f
     548:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
     54c:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
     550:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
     554:	702f6564 	eorvc	r6, pc, r4, ror #10
     558:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     55c:	2f007373 	svccs	0x00007373
     560:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
     564:	6572742f 	ldrbvs	r7, [r2, #-1071]!	; 0xfffffbd1
     568:	2f6c6966 	svccs	0x006c6966
     56c:	2f6d6573 	svccs	0x006d6573
     570:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
     574:	2f736563 	svccs	0x00736563
     578:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
     57c:	63617073 	cmnvs	r1, #115	; 0x73
     580:	2e2e2f65 	cdpcs	15, 2, cr2, cr14, cr5, {3}
     584:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
     588:	2f6c656e 	svccs	0x006c656e
     58c:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
     590:	2f656475 	svccs	0x00656475
     594:	2f007366 	svccs	0x00007366
     598:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
     59c:	6572742f 	ldrbvs	r7, [r2, #-1071]!	; 0xfffffbd1
     5a0:	2f6c6966 	svccs	0x006c6966
     5a4:	2f6d6573 	svccs	0x006d6573
     5a8:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
     5ac:	2f736563 	svccs	0x00736563
     5b0:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
     5b4:	63617073 	cmnvs	r1, #115	; 0x73
     5b8:	2e2e2f65 	cdpcs	15, 2, cr2, cr14, cr5, {3}
     5bc:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
     5c0:	2f6c656e 	svccs	0x006c656e
     5c4:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
     5c8:	2f656475 	svccs	0x00656475
     5cc:	72616f62 	rsbvc	r6, r1, #392	; 0x188
     5d0:	70722f64 	rsbsvc	r2, r2, r4, ror #30
     5d4:	682f3069 	stmdavs	pc!, {r0, r3, r5, r6, ip, sp}	; <UNPREDICTABLE>
     5d8:	00006c61 	andeq	r6, r0, r1, ror #24
     5dc:	6f6d656d 	svcvs	0x006d656d
     5e0:	682e7972 	stmdavs	lr!, {r1, r4, r5, r6, r8, fp, ip, sp, lr}
     5e4:	00000100 	andeq	r0, r0, r0, lsl #2
     5e8:	65646f4d 	strbvs	r6, [r4, #-3917]!	; 0xfffff0b3
     5ec:	70632e6c 	rsbvc	r2, r3, ip, ror #28
     5f0:	00020070 	andeq	r0, r2, r0, ror r0
     5f4:	6e615200 	cdpvs	2, 6, cr5, cr1, cr0, {0}
     5f8:	2e6d6f64 	cdpcs	15, 6, cr6, cr13, cr4, {3}
     5fc:	00010068 	andeq	r0, r1, r8, rrx
     600:	61654800 	cmnvs	r5, r0, lsl #16
     604:	614d5f70 	hvcvs	54768	; 0xd5f0
     608:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     60c:	00682e72 	rsbeq	r2, r8, r2, ror lr
     610:	73000001 	movwvc	r0, #1
     614:	6c6e6970 			; <UNDEFINED> instruction: 0x6c6e6970
     618:	2e6b636f 	cdpcs	3, 6, cr6, cr11, cr15, {3}
     61c:	00030068 	andeq	r0, r3, r8, rrx
     620:	6c696600 	stclvs	6, cr6, [r9], #-0
     624:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     628:	2e6d6574 	mcrcs	5, 3, r6, cr13, cr4, {3}
     62c:	00040068 	andeq	r0, r4, r8, rrx
     630:	6f727000 	svcvs	0x00727000
     634:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     638:	0300682e 	movweq	r6, #2094	; 0x82e
     63c:	72700000 	rsbsvc	r0, r0, #0
     640:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     644:	616d5f73 	smcvs	54771	; 0xd5f3
     648:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     64c:	00682e72 	rsbeq	r2, r8, r2, ror lr
     650:	73000003 	movwvc	r0, #3
     654:	75626474 	strbvc	r6, [r2, #-1140]!	; 0xfffffb8c
     658:	72656666 	rsbvc	r6, r5, #106954752	; 0x6600000
     65c:	0100682e 	tsteq	r0, lr, lsr #16
     660:	6f4d0000 	svcvs	0x004d0000
     664:	2e6c6564 	cdpcs	5, 6, cr6, cr12, cr4, {3}
     668:	00020068 	andeq	r0, r2, r8, rrx
     66c:	746e6900 	strbtvc	r6, [lr], #-2304	; 0xfffff700
     670:	2e666564 	cdpcs	5, 6, cr6, cr6, cr4, {3}
     674:	00050068 	andeq	r0, r5, r8, rrx
     678:	29050000 	stmdbcs	r5, {}	; <UNPREDICTABLE>
     67c:	90020500 	andls	r0, r2, r0, lsl #10
     680:	16000085 	strne	r0, [r0], -r5, lsl #1
     684:	05831305 	streq	r1, [r3, #773]	; 0x305
     688:	08028301 	stmdaeq	r2, {r0, r8, r9, pc}
     68c:	05010100 	streq	r0, [r1, #-256]	; 0xffffff00
     690:	02050001 	andeq	r0, r5, #1
     694:	00009924 	andeq	r9, r0, r4, lsr #18
     698:	05010d03 	streq	r0, [r1, #-3331]	; 0xfffff2fd
     69c:	01058313 	tsteq	r5, r3, lsl r3
     6a0:	00080283 	andeq	r0, r8, r3, lsl #5
     6a4:	23050101 	movwcs	r0, #20737	; 0x5101
     6a8:	54020500 	strpl	r0, [r2], #-1280	; 0xfffffb00
     6ac:	03000099 	movweq	r0, #153	; 0x99
     6b0:	13050111 	movwne	r0, #20753	; 0x5111
     6b4:	83010583 	movwhi	r0, #5507	; 0x1583
     6b8:	01000802 	tsteq	r0, r2, lsl #16
     6bc:	05020401 	streq	r0, [r2, #-1025]	; 0xfffffbff
     6c0:	02050001 	andeq	r0, r5, #1
     6c4:	000085c0 	andeq	r8, r0, r0, asr #11
     6c8:	db180514 	blle	601b20 <__bss_end+0x5f5a28>
     6cc:	4e020905 	vmlami.f16	s0, s4, s10	; <UNPREDICTABLE>
     6d0:	4b120515 	blmi	481b2c <__bss_end+0x475a34>
     6d4:	05670105 	strbeq	r0, [r7, #-261]!	; 0xfffffefb
     6d8:	0f05a02f 	svceq	0x0005a02f
     6dc:	661405d7 			; <UNDEFINED> instruction: 0x661405d7
     6e0:	05662e05 	strbeq	r2, [r6, #-3589]!	; 0xfffff1fb
     6e4:	33054a2d 	movwcc	r4, #23085	; 0x5a2d
     6e8:	4a31054a 	bmi	c41c18 <__bss_end+0xc35b20>
     6ec:	052e2705 	streq	r2, [lr, #-1797]!	; 0xfffff8fb
     6f0:	01052e33 	tsteq	r5, r3, lsr lr
     6f4:	db3e052f 	blle	f81bb8 <__bss_end+0xf75ac0>
     6f8:	67bb0b05 	ldrvs	r0, [fp, r5, lsl #22]!
     6fc:	05676767 	strbeq	r6, [r7, #-1895]!	; 0xfffff899
     700:	1b056817 	blne	15a764 <__bss_end+0x14e66c>
     704:	662505bb 			; <UNDEFINED> instruction: 0x662505bb
     708:	05663205 	strbeq	r3, [r6, #-517]!	; 0xfffffdfb
     70c:	2105662b 	tstcs	r5, fp, lsr #12
     710:	2e0b052e 	cfsh32cs	mvfx0, mvfx11, #30
     714:	05670c05 	strbeq	r0, [r7, #-3077]!	; 0xfffff3fb
     718:	2a054b01 	bcs	153324 <__bss_end+0x14722c>
     71c:	a10d056a 	tstge	sp, sl, ror #10
     720:	02001805 	andeq	r1, r0, #327680	; 0x50000
     724:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
     728:	04020016 	streq	r0, [r2], #-22	; 0xffffffea
     72c:	3c054a03 			; <UNDEFINED> instruction: 0x3c054a03
     730:	02040200 	andeq	r0, r4, #0, 4
     734:	004d0567 	subeq	r0, sp, r7, ror #10
     738:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
     73c:	02005205 	andeq	r5, r0, #1342177280	; 0x50000000
     740:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
     744:	04020053 	streq	r0, [r2], #-83	; 0xffffffad
     748:	30052e02 	andcc	r2, r5, r2, lsl #28
     74c:	02040200 	andeq	r0, r4, #0, 4
     750:	0014054a 	andseq	r0, r4, sl, asr #10
     754:	9f020402 	svcls	0x00020402
     758:	02002505 	andeq	r2, r0, #20971520	; 0x1400000
     75c:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
     760:	04020026 	streq	r0, [r2], #-38	; 0xffffffda
     764:	28052e02 	stmdacs	r5, {r1, r9, sl, fp, sp}
     768:	02040200 	andeq	r0, r4, #0, 4
     76c:	0005054a 	andeq	r0, r5, sl, asr #10
     770:	48020402 	stmdami	r2, {r1, sl}
     774:	05860105 	streq	r0, [r6, #261]	; 0x105
     778:	16056a35 			; <UNDEFINED> instruction: 0x16056a35
     77c:	4a1f05a0 	bmi	7c1e04 <__bss_end+0x7b5d0c>
     780:	054a0905 	strbeq	r0, [sl, #-2309]	; 0xfffff6fb
     784:	4d4b9f0b 	stclmi	15, cr9, [fp, #-44]	; 0xffffffd4
     788:	02001405 	andeq	r1, r0, #83886080	; 0x5000000
     78c:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
     790:	04020012 	streq	r0, [r2], #-18	; 0xffffffee
     794:	28054a01 	stmdacs	r5, {r0, r9, fp, lr}
     798:	4a390567 	bmi	e41d3c <__bss_end+0xe35c44>
     79c:	052e3a05 	streq	r3, [lr, #-2565]!	; 0xfffff5fb
     7a0:	0d054a0f 	vstreq	s8, [r5, #-60]	; 0xffffffc4
     7a4:	8515054b 	ldrhi	r0, [r5, #-1355]	; 0xfffffab5
     7a8:	054a0905 	strbeq	r0, [sl, #-2309]	; 0xfffff6fb
     7ac:	04020019 	streq	r0, [r2], #-25	; 0xffffffe7
     7b0:	1e056702 	cdpne	7, 0, cr6, cr5, cr2, {0}
     7b4:	02040200 	andeq	r0, r4, #0, 4
     7b8:	0023054a 	eoreq	r0, r3, sl, asr #10
     7bc:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
     7c0:	02000f05 	andeq	r0, r0, #5, 30
     7c4:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
     7c8:	0402001d 	streq	r0, [r2], #-29	; 0xffffffe3
     7cc:	3d054d02 	stccc	13, cr4, [r5, #-8]
     7d0:	02040200 	andeq	r0, r4, #0, 4
     7d4:	002f054a 	eoreq	r0, pc, sl, asr #10
     7d8:	66020402 	strvs	r0, [r2], -r2, lsl #8
     7dc:	02002b05 	andeq	r2, r0, #5120	; 0x1400
     7e0:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
     7e4:	04020045 	streq	r0, [r2], #-69	; 0xffffffbb
     7e8:	41052e02 	tstmi	r5, r2, lsl #28
     7ec:	02040200 	andeq	r0, r4, #0, 4
     7f0:	000e054a 	andeq	r0, lr, sl, asr #10
     7f4:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
     7f8:	02000505 	andeq	r0, r0, #20971520	; 0x1400000
     7fc:	77030204 	strvc	r0, [r3, -r4, lsl #4]
     800:	87220566 	strhi	r0, [r2, -r6, ror #10]!
     804:	05350505 	ldreq	r0, [r5, #-1285]!	; 0xfffffafb
     808:	0505830e 	streq	r8, [r5, #-782]	; 0xfffffcf2
     80c:	0018056a 	andseq	r0, r8, sl, ror #10
     810:	66010402 	strvs	r0, [r1], -r2, lsl #8
     814:	054c1b05 	strbeq	r1, [ip, #-2821]	; 0xfffff4fb
     818:	0c05660d 	stceq	6, cr6, [r5], {13}
     81c:	2f010567 	svccs	0x00010567
     820:	05a31f05 	streq	r1, [r3, #3845]!	; 0xf05
     824:	1805830d 	stmdane	r5, {r0, r2, r3, r8, r9, pc}
     828:	01040200 	mrseq	r0, R12_usr
     82c:	0016054a 	andseq	r0, r6, sl, asr #10
     830:	4a010402 	bmi	41840 <__bss_end+0x35748>
     834:	05672605 	strbeq	r2, [r7, #-1541]!	; 0xfffff9fb
     838:	32054a31 	andcc	r4, r5, #200704	; 0x31000
     83c:	4a14052e 	bmi	501cfc <__bss_end+0x4f5c04>
     840:	054c1105 	strbeq	r1, [ip, #-261]	; 0xfffffefb
     844:	0402001a 	streq	r0, [r2], #-26	; 0xffffffe6
     848:	2e054a03 	vmlacs.f32	s8, s10, s6
     84c:	02040200 	andeq	r0, r4, #0, 4
     850:	003f0567 	eorseq	r0, pc, r7, ror #10
     854:	4a020402 	bmi	81864 <__bss_end+0x7576c>
     858:	02002605 	andeq	r2, r0, #5242880	; 0x500000
     85c:	05660204 	strbeq	r0, [r6, #-516]!	; 0xfffffdfc
     860:	04020009 	streq	r0, [r2], #-9
     864:	11059d02 	tstne	r5, r2, lsl #26
     868:	001c0585 	andseq	r0, ip, r5, lsl #11
     86c:	4a030402 	bmi	c187c <__bss_end+0xb5784>
     870:	02001a05 	andeq	r1, r0, #20480	; 0x5000
     874:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
     878:	04020018 	streq	r0, [r2], #-24	; 0xffffffe8
     87c:	29056702 	stmdbcs	r5, {r1, r8, r9, sl, sp, lr}
     880:	02040200 	andeq	r0, r4, #0, 4
     884:	002a054a 	eoreq	r0, sl, sl, asr #10
     888:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
     88c:	02002c05 	andeq	r2, r0, #1280	; 0x500
     890:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
     894:	04020009 	streq	r0, [r2], #-9
     898:	05054902 	streq	r4, [r5, #-2306]	; 0xfffff6fe
     89c:	02040200 	andeq	r0, r4, #0, 4
     8a0:	05827a03 	streq	r7, [r2, #2563]	; 0xa03
     8a4:	82090301 	andhi	r0, r9, #67108864	; 0x4000000
     8a8:	05852405 	streq	r2, [r5, #1029]	; 0x405
     8ac:	16059f0d 	strne	r9, [r5], -sp, lsl #30
     8b0:	03040200 	movweq	r0, #16896	; 0x4200
     8b4:	000f054a 	andeq	r0, pc, sl, asr #10
     8b8:	67020402 	strvs	r0, [r2, -r2, lsl #8]
     8bc:	02003505 	andeq	r3, r0, #20971520	; 0x1400000
     8c0:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
     8c4:	04020024 	streq	r0, [r2], #-36	; 0xffffffdc
     8c8:	05059e02 	streq	r9, [r5, #-3586]	; 0xfffff1fe
     8cc:	02040200 	andeq	r0, r4, #0, 4
     8d0:	840d0581 	strhi	r0, [sp], #-1409	; 0xfffffa7f
     8d4:	02001805 	andeq	r1, r0, #327680	; 0x50000
     8d8:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
     8dc:	04020016 	streq	r0, [r2], #-22	; 0xffffffea
     8e0:	2f054a03 	svccs	0x00054a03
     8e4:	02040200 	andeq	r0, r4, #0, 4
     8e8:	00400567 	subeq	r0, r0, r7, ror #10
     8ec:	4a020402 	bmi	818fc <__bss_end+0x75804>
     8f0:	02004105 	andeq	r4, r0, #1073741825	; 0x40000001
     8f4:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
     8f8:	0402000f 	streq	r0, [r2], #-15
     8fc:	16054a02 	strne	r4, [r5], -r2, lsl #20
     900:	02040200 	andeq	r0, r4, #0, 4
     904:	0027054a 	eoreq	r0, r7, sl, asr #10
     908:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
     90c:	02002805 	andeq	r2, r0, #327680	; 0x50000
     910:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
     914:	04020041 	streq	r0, [r2], #-65	; 0xffffffbf
     918:	2a054a02 	bcs	153128 <__bss_end+0x147030>
     91c:	02040200 	andeq	r0, r4, #0, 4
     920:	0005052e 	andeq	r0, r5, lr, lsr #10
     924:	2d020402 	cfstrscs	mvf0, [r2, #-8]
     928:	05840b05 	streq	r0, [r4, #2821]	; 0xb05
     92c:	1a054a1f 	bne	1531b0 <__bss_end+0x1470b8>
     930:	2f01054a 	svccs	0x0001054a
     934:	05851f05 	streq	r1, [r5, #3845]	; 0xf05
     938:	f3d7840a 	vraddhn.i32	d24, <illegal reg q3.5>, q5
     93c:	05bb1005 	ldreq	r1, [fp, #5]!
     940:	1605680d 	strne	r6, [r5], -sp, lsl #16
     944:	01040200 	mrseq	r0, R12_usr
     948:	670f054a 	strvs	r0, [pc, -sl, asr #10]
     94c:	05bb0d05 	ldreq	r0, [fp, #3333]!	; 0xd05
     950:	0f058324 	svceq	0x00058324
     954:	090583ba 	stmdbeq	r5, {r1, r3, r4, r5, r7, r8, r9, pc}
     958:	6713059f 			; <UNDEFINED> instruction: 0x6713059f
     95c:	02000505 	andeq	r0, r0, #20971520	; 0x1400000
     960:	7a030204 	bvc	c1178 <__bss_end+0xb5080>
     964:	8a0b0582 	bhi	2c1f74 <__bss_end+0x2b5e7c>
     968:	054a1a05 	strbeq	r1, [sl, #-2565]	; 0xfffff5fb
     96c:	1a05830b 	bne	1615a0 <__bss_end+0x1554a8>
     970:	6901054a 	stmdbvs	r1, {r1, r3, r6, r8, sl}
     974:	05bc1405 	ldreq	r1, [ip, #1029]!	; 0x405
     978:	3c058352 	stccc	3, cr8, [r5], {82}	; 0x52
     97c:	8216054a 	andshi	r0, r6, #310378496	; 0x12800000
     980:	054c0d05 	strbeq	r0, [ip, #-3333]	; 0xfffff2fb
     984:	04020018 	streq	r0, [r2], #-24	; 0xffffffe8
     988:	16054a01 	strne	r4, [r5], -r1, lsl #20
     98c:	01040200 	mrseq	r0, R12_usr
     990:	670f054a 	strvs	r0, [pc, -sl, asr #10]
     994:	054a1a05 	strbeq	r1, [sl, #-2565]	; 0xfffff5fb
     998:	23052e1b 	movwcs	r2, #24091	; 0x5e1b
     99c:	661d054a 	ldrvs	r0, [sp], -sl, asr #10
     9a0:	05303b05 	ldreq	r3, [r0, #-2821]!	; 0xfffff4fb
     9a4:	02004a46 	andeq	r4, r0, #286720	; 0x46000
     9a8:	4a060104 	bmi	180dc0 <__bss_end+0x174cc8>
     9ac:	02040200 	andeq	r0, r4, #0, 4
     9b0:	000f054a 	andeq	r0, pc, sl, asr #10
     9b4:	06040402 	streq	r0, [r4], -r2, lsl #8
     9b8:	001a052e 	andseq	r0, sl, lr, lsr #10
     9bc:	4a040402 	bmi	1019cc <__bss_end+0xf58d4>
     9c0:	02001b05 	andeq	r1, r0, #5120	; 0x1400
     9c4:	052e0404 	streq	r0, [lr, #-1028]!	; 0xfffffbfc
     9c8:	04020046 	streq	r0, [r2], #-70	; 0xffffffba
     9cc:	2f056604 	svccs	0x00056604
     9d0:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
     9d4:	00110566 	andseq	r0, r1, r6, ror #10
     9d8:	32040402 	andcc	r0, r4, #33554432	; 0x2000000
     9dc:	02001c05 	andeq	r1, r0, #1280	; 0x500
     9e0:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
     9e4:	0402001a 	streq	r0, [r2], #-26	; 0xffffffe6
     9e8:	13054a03 	movwne	r4, #23043	; 0x5a03
     9ec:	02040200 	andeq	r0, r4, #0, 4
     9f0:	001e0567 	andseq	r0, lr, r7, ror #10
     9f4:	4a020402 	bmi	81a04 <__bss_end+0x7590c>
     9f8:	02001f05 	andeq	r1, r0, #5, 30
     9fc:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
     a00:	04020022 	streq	r0, [r2], #-34	; 0xffffffde
     a04:	33056602 	movwcc	r6, #22018	; 0x5602
     a08:	02040200 	andeq	r0, r4, #0, 4
     a0c:	0034052e 	eorseq	r0, r4, lr, lsr #10
     a10:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
     a14:	02003505 	andeq	r3, r0, #20971520	; 0x1400000
     a18:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
     a1c:	04020009 	streq	r0, [r2], #-9
     a20:	05054902 	streq	r4, [r5, #-2306]	; 0xfffff6fe
     a24:	02040200 	andeq	r0, r4, #0, 4
     a28:	05827903 	streq	r7, [r2, #2307]	; 0x903
     a2c:	820b031c 	andhi	r0, fp, #28, 6	; 0x70000000
     a30:	004a2705 	subeq	r2, sl, r5, lsl #14
     a34:	06010402 	streq	r0, [r1], -r2, lsl #8
     a38:	0402004a 	streq	r0, [r2], #-74	; 0xffffffb6
     a3c:	02004a02 	andeq	r4, r0, #8192	; 0x2000
     a40:	052e0404 	streq	r0, [lr, #-1028]!	; 0xfffffbfc
     a44:	04020010 	streq	r0, [r2], #-16
     a48:	05820604 	streq	r0, [r2, #1540]	; 0x604
     a4c:	04020069 	streq	r0, [r2], #-105	; 0xffffff97
     a50:	29054c04 	stmdbcs	r5, {r2, sl, fp, lr}
     a54:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
     a58:	00690582 	rsbeq	r0, r9, r2, lsl #11
     a5c:	4a040402 	bmi	101a6c <__bss_end+0xf5974>
     a60:	02004505 	andeq	r4, r0, #20971520	; 0x1400000
     a64:	05d60404 	ldrbeq	r0, [r6, #1028]	; 0x404
     a68:	04020069 	streq	r0, [r2], #-105	; 0xffffff97
     a6c:	12054a04 	andne	r4, r5, #4, 20	; 0x4000
     a70:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
     a74:	1705ac08 	strne	sl, [r5, -r8, lsl #24]
     a78:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
     a7c:	0011054d 	andseq	r0, r1, sp, asr #10
     a80:	82040402 	andhi	r0, r4, #33554432	; 0x2000000
     a84:	02002f05 	andeq	r2, r0, #5, 30
     a88:	054b0404 	strbeq	r0, [fp, #-1028]	; 0xfffffbfc
     a8c:	0402003a 	streq	r0, [r2], #-58	; 0xffffffc6
     a90:	02004a04 	andeq	r4, r0, #4, 20	; 0x4000
     a94:	4a060104 	bmi	180eac <__bss_end+0x174db4>
     a98:	02040200 	andeq	r0, r4, #0, 4
     a9c:	000b054a 	andeq	r0, fp, sl, asr #10
     aa0:	06040402 	streq	r0, [r4], -r2, lsl #8
     aa4:	003a052e 	eorseq	r0, sl, lr, lsr #10
     aa8:	4a040402 	bmi	101ab8 <__bss_end+0xf59c0>
     aac:	02002305 	andeq	r2, r0, #335544320	; 0x14000000
     ab0:	05660404 	strbeq	r0, [r6, #-1028]!	; 0xfffffbfc
     ab4:	0402000d 	streq	r0, [r2], #-13
     ab8:	18052f04 	stmdane	r5, {r2, r8, r9, sl, fp, sp}
     abc:	03040200 	movweq	r0, #16896	; 0x4200
     ac0:	0016054a 	andseq	r0, r6, sl, asr #10
     ac4:	4a030402 	bmi	c1ad4 <__bss_end+0xb59dc>
     ac8:	02000f05 	andeq	r0, r0, #5, 30
     acc:	05670204 	strbeq	r0, [r7, #-516]!	; 0xfffffdfc
     ad0:	04020016 	streq	r0, [r2], #-22	; 0xffffffea
     ad4:	27054a02 	strcs	r4, [r5, -r2, lsl #20]
     ad8:	02040200 	andeq	r0, r4, #0, 4
     adc:	0028052e 	eoreq	r0, r8, lr, lsr #10
     ae0:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
     ae4:	02002a05 	andeq	r2, r0, #20480	; 0x5000
     ae8:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
     aec:	04020005 	streq	r0, [r2], #-5
     af0:	15054902 	strne	r4, [r5, #-2306]	; 0xfffff6fe
     af4:	4c010584 	cfstr32mi	mvfx0, [r1], {132}	; 0x84
     af8:	05672205 	strbeq	r2, [r7, #-517]!	; 0xfffffdfb
     afc:	1c05830c 	stcne	3, cr8, [r5], {12}
     b00:	bb01054a 	bllt	42030 <__bss_end+0x35f38>
     b04:	05842505 	streq	r2, [r4, #1285]	; 0x505
     b08:	05059f1b 	streq	r9, [r5, #-3867]	; 0xfffff0e5
     b0c:	4b0f0566 	blmi	3c20ac <__bss_end+0x3b5fb4>
     b10:	054a1e05 	strbeq	r1, [sl, #-3589]	; 0xfffff1fb
     b14:	0b056710 	bleq	15a75c <__bss_end+0x14e664>
     b18:	4a10054c 	bmi	402050 <__bss_end+0x3f5f58>
     b1c:	054a1c05 	strbeq	r1, [sl, #-3077]	; 0xfffff3fb
     b20:	2005661e 	andcs	r6, r5, lr, lsl r6
     b24:	4b0c054a 	blmi	302054 <__bss_end+0x2f5f5c>
     b28:	052f0105 	streq	r0, [pc, #-261]!	; a2b <shift+0xa2b>
     b2c:	0f058424 	svceq	0x00058424
     b30:	6701059f 			; <UNDEFINED> instruction: 0x6701059f
     b34:	05842105 	streq	r2, [r4, #261]	; 0x105
     b38:	01058312 	tsteq	r5, r2, lsl r3
     b3c:	8434054b 	ldrthi	r0, [r4], #-1355	; 0xfffffab5
     b40:	05a02005 	streq	r2, [r0, #5]!
     b44:	34054a2f 	strcc	r4, [r5], #-2607	; 0xfffff5d1
     b48:	081e0566 	ldmdaeq	lr, {r1, r2, r5, r6, r8, sl}
     b4c:	4a2d053e 	bmi	b4204c <__bss_end+0xb35f54>
     b50:	05663405 	strbeq	r3, [r6, #-1029]!	; 0xfffffbfb
     b54:	17052e37 	smladxne	r5, r7, lr, r2
     b58:	4a280586 	bmi	a02178 <__bss_end+0x9f6080>
     b5c:	05820905 	streq	r0, [r2, #2309]	; 0x905
     b60:	09056819 	stmdbeq	r5, {r0, r3, r4, fp, sp, lr}
     b64:	2405684a 	strcs	r6, [r5], #-2122	; 0xfffff7b6
     b68:	9e09054d 	cfsh32ls	mvfx0, mvfx9, #45
     b6c:	02001605 	andeq	r1, r0, #5242880	; 0x500000
     b70:	05680104 	strbeq	r0, [r8, #-260]!	; 0xfffffefc
     b74:	3105832a 	tstcc	r5, sl, lsr #6
     b78:	6614052e 	ldrvs	r0, [r4], -lr, lsr #10
     b7c:	054b3505 	strbeq	r3, [fp, #-1285]	; 0xfffffafb
     b80:	11059e14 	tstne	r5, r4, lsl lr
     b84:	001a054c 	andseq	r0, sl, ip, asr #10
     b88:	4a020402 	bmi	81b98 <__bss_end+0x75aa0>
     b8c:	00833b05 	addeq	r3, r3, r5, lsl #22
     b90:	06010402 	streq	r0, [r1], -r2, lsl #8
     b94:	04020066 	streq	r0, [r2], #-102	; 0xffffff9a
     b98:	1805ba02 	stmdane	r5, {r1, r9, fp, ip, sp, pc}
     b9c:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
     ba0:	1d059e06 	stcne	14, cr9, [r5, #-24]	; 0xffffffe8
     ba4:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
     ba8:	002e052e 	eoreq	r0, lr, lr, lsr #10
     bac:	82040402 	andhi	r0, r4, #33554432	; 0x2000000
     bb0:	02000905 	andeq	r0, r0, #81920	; 0x14000
     bb4:	05810404 	streq	r0, [r1, #1028]	; 0x404
     bb8:	27058411 	smladcs	r5, r1, r4, r8
     bbc:	03040200 	movweq	r0, #16896	; 0x4200
     bc0:	0036054a 	eorseq	r0, r6, sl, asr #10
     bc4:	67020402 	strvs	r0, [r2, -r2, lsl #8]
     bc8:	02001805 	andeq	r1, r0, #327680	; 0x50000
     bcc:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
     bd0:	0402001d 	streq	r0, [r2], #-29	; 0xffffffe3
     bd4:	47052e02 	strmi	r2, [r5, -r2, lsl #28]
     bd8:	02040200 	andeq	r0, r4, #0, 4
     bdc:	002e0582 	eoreq	r0, lr, r2, lsl #11
     be0:	66020402 	strvs	r0, [r2], -r2, lsl #8
     be4:	02000905 	andeq	r0, r0, #81920	; 0x14000
     be8:	05810204 	streq	r0, [r1, #516]	; 0x204
     bec:	05058411 	streq	r8, [r5, #-1041]	; 0xfffffbef
     bf0:	05667803 	strbeq	r7, [r6, #-2051]!	; 0xfffff7fd
     bf4:	04020016 	streq	r0, [r2], #-22	; 0xffffffea
     bf8:	820b0301 	andhi	r0, fp, #67108864	; 0x4000000
     bfc:	05832f05 	streq	r2, [r3, #3845]	; 0xf05
     c00:	14052e34 	strne	r2, [r5], #-3636	; 0xfffff1cc
     c04:	4c110566 	cfldr32mi	mvfx0, [r1], {102}	; 0x66
     c08:	02001a05 	andeq	r1, r0, #20480	; 0x5000
     c0c:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
     c10:	0402002c 	streq	r0, [r2], #-44	; 0xffffffd4
     c14:	3d056702 	stccc	7, cr6, [r5, #-8]
     c18:	02040200 	andeq	r0, r4, #0, 4
     c1c:	002a054a 	eoreq	r0, sl, sl, asr #10
     c20:	66020402 	strvs	r0, [r2], -r2, lsl #8
     c24:	02000905 	andeq	r0, r0, #81920	; 0x14000
     c28:	059d0204 	ldreq	r0, [sp, #516]	; 0x204
     c2c:	01057f05 	tsteq	r5, r5, lsl #30
     c30:	05820903 	streq	r0, [r2, #2307]	; 0x903
     c34:	1005d731 	andne	sp, r5, r1, lsr r7
     c38:	f208059f 	vqrshl.s8	d0, d15, d24
     c3c:	05820505 	streq	r0, [r2, #1285]	; 0x505
     c40:	09054b19 	stmdbeq	r5, {r0, r3, r4, r8, r9, fp, lr}
     c44:	3015054b 	andscc	r0, r5, fp, asr #10
     c48:	05f20d05 	ldrbeq	r0, [r2, #3333]!	; 0xd05
     c4c:	0f05820a 	svceq	0x0005820a
     c50:	4a1e054b 	bmi	782184 <__bss_end+0x77608c>
     c54:	05671405 	strbeq	r1, [r7, #-1029]!	; 0xfffffbfb
     c58:	0f056709 	svceq	0x00056709
     c5c:	4a1e0531 	bmi	782128 <__bss_end+0x776030>
     c60:	05671005 	strbeq	r1, [r7, #-5]!
     c64:	19054d01 	stmdbne	r5, {r0, r8, sl, fp, lr}
     c68:	831805bd 	tsthi	r8, #792723456	; 0x2f400000
     c6c:	054a2b05 	strbeq	r2, [sl, #-2821]	; 0xfffff4fb
     c70:	1e056805 	cdpne	8, 0, cr6, cr5, cr5, {0}
     c74:	69050568 	stmdbvs	r5, {r3, r5, r6, r8, sl}
     c78:	92082005 	andls	r2, r8, #5
     c7c:	05670d05 	strbeq	r0, [r7, #-3333]!	; 0xfffff2fb
     c80:	1f053015 	svcne	0x00053015
     c84:	820d0567 	andhi	r0, sp, #432013312	; 0x19c00000
     c88:	054b1b05 	strbeq	r1, [fp, #-2821]	; 0xfffff4fb
     c8c:	1505670d 	strne	r6, [r5, #-1805]	; 0xfffff8f3
     c90:	671f0530 			; <UNDEFINED> instruction: 0x671f0530
     c94:	05d60d05 	ldrbeq	r0, [r6, #3333]	; 0xd05
     c98:	0d054b1a 	vstreq	d4, [r5, #-104]	; 0xffffff98
     c9c:	03180567 	tsteq	r8, #432013312	; 0x19c00000
     ca0:	0d052e6e 	stceq	14, cr2, [r5, #-440]	; 0xfffffe48
     ca4:	4f4a0d03 	svcmi	0x004a0d03
     ca8:	05300105 	ldreq	r0, [r0, #-261]!	; 0xfffffefb
     cac:	1f054c2d 	svcne	0x00054c2d
     cb0:	4a2e059f 	bmi	b82334 <__bss_end+0xb7623c>
     cb4:	05663305 	strbeq	r3, [r6, #-773]!	; 0xfffffcfb
     cb8:	053d080d 	ldreq	r0, [sp, #-2061]!	; 0xfffff7f3
     cbc:	04020018 	streq	r0, [r2], #-24	; 0xffffffe8
     cc0:	16054a03 	strne	r4, [r5], -r3, lsl #20
     cc4:	03040200 	movweq	r0, #16896	; 0x4200
     cc8:	003a054a 	eorseq	r0, sl, sl, asr #10
     ccc:	67020402 	strvs	r0, [r2, -r2, lsl #8]
     cd0:	02001405 	andeq	r1, r0, #83886080	; 0x5000000
     cd4:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
     cd8:	04020015 	streq	r0, [r2], #-21	; 0xffffffeb
     cdc:	4b052e02 	blmi	14c4ec <__bss_end+0x1403f4>
     ce0:	02040200 	andeq	r0, r4, #0, 4
     ce4:	00380582 	eorseq	r0, r8, r2, lsl #11
     ce8:	66020402 	strvs	r0, [r2], -r2, lsl #8
     cec:	02000505 	andeq	r0, r0, #20971520	; 0x1400000
     cf0:	05810204 	streq	r0, [r1, #516]	; 0x204
     cf4:	1a058501 	bne	162100 <__bss_end+0x156008>
     cf8:	830b0584 	movwhi	r0, #46468	; 0xb584
     cfc:	054a1a05 	strbeq	r1, [sl, #-2565]	; 0xfffff5fb
     d00:	12056701 	andne	r6, r5, #262144	; 0x40000
     d04:	86140585 	ldrhi	r0, [r4], -r5, lsl #11
     d08:	054c1005 	strbeq	r1, [ip, #-5]
     d0c:	0d054a0f 	vstreq	s8, [r5, #-60]	; 0xffffffc4
     d10:	2f17054b 	svccs	0x0017054b
     d14:	05480905 	strbeq	r0, [r8, #-2309]	; 0xfffff6fb
     d18:	0905320e 	stmdbeq	r5, {r1, r2, r3, r9, ip, sp}
     d1c:	4a18054b 	bmi	602250 <__bss_end+0x5f6158>
     d20:	05681105 	strbeq	r1, [r8, #-261]!	; 0xfffffefb
     d24:	0402001c 	streq	r0, [r2], #-28	; 0xffffffe4
     d28:	1a054a01 	bne	153534 <__bss_end+0x14743c>
     d2c:	01040200 	mrseq	r0, R12_usr
     d30:	6811054a 	ldmdavs	r1, {r1, r3, r6, r8, sl}
     d34:	054a1005 	strbeq	r1, [sl, #-5]
     d38:	15054a0d 	strne	r4, [r5, #-2573]	; 0xfffff5f3
     d3c:	0020054b 	eoreq	r0, r0, fp, asr #10
     d40:	4a010402 	bmi	41d50 <__bss_end+0x35c58>
     d44:	02001e05 	andeq	r1, r0, #5, 28	; 0x50
     d48:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
     d4c:	24056819 	strcs	r6, [r5], #-2073	; 0xfffff7e7
     d50:	2e25054a 	cfsh64cs	mvdx0, mvdx5, #42
     d54:	054a1805 	strbeq	r1, [sl, #-2053]	; 0xfffff7fb
     d58:	3805842d 	stmdacc	r5, {r0, r2, r3, r5, sl, pc}
     d5c:	2e39054a 	cdpcs	5, 3, cr0, cr9, cr10, {2}
     d60:	054a2c05 	strbeq	r2, [sl, #-3077]	; 0xfffff3fb
     d64:	15059f11 	strne	r9, [r5, #-3857]	; 0xfffff0ef
     d68:	4a2405a0 	bmi	9023f0 <__bss_end+0x8f62f8>
     d6c:	05682505 	strbeq	r2, [r8, #-1285]!	; 0xfffffafb
     d70:	15054b20 	strne	r4, [r5, #-2848]	; 0xfffff4e0
     d74:	00110567 	andseq	r0, r1, r7, ror #10
     d78:	30020402 	andcc	r0, r2, r2, lsl #8
     d7c:	02001c05 	andeq	r1, r0, #1280	; 0x500
     d80:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
     d84:	0402001d 	streq	r0, [r2], #-29	; 0xffffffe3
     d88:	28052e02 	stmdacs	r5, {r1, r9, sl, fp, sp}
     d8c:	02040200 	andeq	r0, r4, #0, 4
     d90:	001b0566 	andseq	r0, fp, r6, ror #10
     d94:	4b020402 	blmi	81da4 <__bss_end+0x75cac>
     d98:	02000d05 	andeq	r0, r0, #320	; 0x140
     d9c:	72030204 	andvc	r0, r3, #4, 4	; 0x40000000
     da0:	8210034a 	andshi	r0, r0, #671088641	; 0x28000001
     da4:	05691b05 	strbeq	r1, [r9, #-2821]!	; 0xfffff4fb
     da8:	1205d913 	andne	sp, r5, #311296	; 0x4c000
     dac:	8717054a 	ldrhi	r0, [r7, -sl, asr #10]
     db0:	054d1805 	strbeq	r1, [sp, #-2053]	; 0xfffff7fb
     db4:	1305a111 	movwne	sl, #20753	; 0x5111
     db8:	4c11059f 	cfldr32mi	mvfx0, [r1], {159}	; 0x9f
     dbc:	02001a05 	andeq	r1, r0, #20480	; 0x5000
     dc0:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
     dc4:	04020009 	streq	r0, [r2], #-9
     dc8:	02008202 	andeq	r8, r0, #536870912	; 0x20000000
     dcc:	59030204 	stmdbpl	r3, {r2, r9}
     dd0:	841c0582 	ldrhi	r0, [ip], #-1410	; 0xfffffa7e
     dd4:	11032005 	tstne	r3, r5
     dd8:	0309054a 	movweq	r0, #38218	; 0x954a
     ddc:	20052e19 	andcs	r2, r5, r9, lsl lr
     de0:	02040200 	andeq	r0, r4, #0, 4
     de4:	001f0566 	andseq	r0, pc, r6, ror #10
     de8:	4a020402 	bmi	81df8 <__bss_end+0x75d00>
     dec:	02001c05 	andeq	r1, r0, #1280	; 0x500
     df0:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
     df4:	2e054c27 	cdpcs	12, 0, cr4, cr5, cr7, {1}
     df8:	2e3f054a 	cdpcs	5, 3, cr0, cr15, cr10, {2}
     dfc:	054a4f05 	strbeq	r4, [sl, #-3845]	; 0xfffff0fb
     e00:	0d05660f 	stceq	6, cr6, [r5, #-60]	; 0xffffffc4
     e04:	830f054b 	movwhi	r0, #62795	; 0xf54b
     e08:	054a1e05 	strbeq	r1, [sl, #-3589]	; 0xfffff1fb
     e0c:	1e05830f 	cdpne	3, 0, cr8, cr5, cr15, {0}
     e10:	6719054a 	ldrvs	r0, [r9, -sl, asr #10]
     e14:	054c1405 	strbeq	r1, [ip, #-1029]	; 0xfffffbfb
     e18:	8278032b 	rsbshi	r0, r8, #-1409286144	; 0xac000000
     e1c:	09030505 	stmdbeq	r3, {r0, r2, r8, sl}
     e20:	000c022e 	andeq	r0, ip, lr, lsr #4
     e24:	023e0101 	eorseq	r0, lr, #1073741824	; 0x40000000
     e28:	00030000 	andeq	r0, r3, r0
     e2c:	00000158 	andeq	r0, r0, r8, asr r1
     e30:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
     e34:	0101000d 	tsteq	r1, sp
     e38:	00000101 	andeq	r0, r0, r1, lsl #2
     e3c:	00000100 	andeq	r0, r0, r0, lsl #2
     e40:	6f682f01 	svcvs	0x00682f01
     e44:	742f656d 	strtvc	r6, [pc], #-1389	; e4c <shift+0xe4c>
     e48:	69666572 	stmdbvs	r6!, {r1, r4, r5, r6, r8, sl, sp, lr}^
     e4c:	65732f6c 	ldrbvs	r2, [r3, #-3948]!	; 0xfffff094
     e50:	6f732f6d 	svcvs	0x00732f6d
     e54:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
     e58:	73752f73 	cmnvc	r5, #460	; 0x1cc
     e5c:	70737265 	rsbsvc	r7, r3, r5, ror #4
     e60:	2f656361 	svccs	0x00656361
     e64:	65646f4d 	strbvs	r6, [r4, #-3917]!	; 0xfffff0b3
     e68:	682f006c 	stmdavs	pc!, {r2, r3, r5, r6}	; <UNPREDICTABLE>
     e6c:	2f656d6f 	svccs	0x00656d6f
     e70:	66657274 			; <UNDEFINED> instruction: 0x66657274
     e74:	732f6c69 			; <UNDEFINED> instruction: 0x732f6c69
     e78:	732f6d65 			; <UNDEFINED> instruction: 0x732f6d65
     e7c:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
     e80:	752f7365 	strvc	r7, [pc, #-869]!	; b23 <shift+0xb23>
     e84:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
     e88:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
     e8c:	2f2e2e2f 	svccs	0x002e2e2f
     e90:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
     e94:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
     e98:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
     e9c:	702f6564 	eorvc	r6, pc, r4, ror #10
     ea0:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     ea4:	2f007373 	svccs	0x00007373
     ea8:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
     eac:	6572742f 	ldrbvs	r7, [r2, #-1071]!	; 0xfffffbd1
     eb0:	2f6c6966 	svccs	0x006c6966
     eb4:	2f6d6573 	svccs	0x006d6573
     eb8:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
     ebc:	2f736563 	svccs	0x00736563
     ec0:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
     ec4:	63617073 	cmnvs	r1, #115	; 0x73
     ec8:	2e2e2f65 	cdpcs	15, 2, cr2, cr14, cr5, {3}
     ecc:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
     ed0:	2f6c656e 	svccs	0x006c656e
     ed4:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
     ed8:	2f656475 	svccs	0x00656475
     edc:	2f007366 	svccs	0x00007366
     ee0:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
     ee4:	6572742f 	ldrbvs	r7, [r2, #-1071]!	; 0xfffffbd1
     ee8:	2f6c6966 	svccs	0x006c6966
     eec:	2f6d6573 	svccs	0x006d6573
     ef0:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
     ef4:	2f736563 	svccs	0x00736563
     ef8:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
     efc:	63617073 	cmnvs	r1, #115	; 0x73
     f00:	2e2e2f65 	cdpcs	15, 2, cr2, cr14, cr5, {3}
     f04:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
     f08:	2f6c656e 	svccs	0x006c656e
     f0c:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
     f10:	2f656475 	svccs	0x00656475
     f14:	72616f62 	rsbvc	r6, r1, #392	; 0x188
     f18:	70722f64 	rsbsvc	r2, r2, r4, ror #30
     f1c:	682f3069 	stmdavs	pc!, {r0, r3, r5, r6, ip, sp}	; <UNPREDICTABLE>
     f20:	00006c61 	andeq	r6, r0, r1, ror #24
     f24:	74726f53 	ldrbtvc	r6, [r2], #-3923	; 0xfffff0ad
     f28:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
     f2c:	00000100 	andeq	r0, r0, r0, lsl #2
     f30:	6e697073 	mcrvs	0, 3, r7, cr9, cr3, {3}
     f34:	6b636f6c 	blvs	18dccec <__bss_end+0x18d0bf4>
     f38:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
     f3c:	69660000 	stmdbvs	r6!, {}^	; <UNPREDICTABLE>
     f40:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
     f44:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
     f48:	0300682e 	movweq	r6, #2094	; 0x82e
     f4c:	72700000 	rsbsvc	r0, r0, #0
     f50:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     f54:	00682e73 	rsbeq	r2, r8, r3, ror lr
     f58:	70000002 	andvc	r0, r0, r2
     f5c:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     f60:	6d5f7373 	ldclvs	3, cr7, [pc, #-460]	; d9c <shift+0xd9c>
     f64:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     f68:	682e7265 	stmdavs	lr!, {r0, r2, r5, r6, r9, ip, sp, lr}
     f6c:	00000200 	andeq	r0, r0, r0, lsl #4
     f70:	65646f4d 	strbvs	r6, [r4, #-3917]!	; 0xfffff0b3
     f74:	00682e6c 	rsbeq	r2, r8, ip, ror #28
     f78:	69000001 	stmdbvs	r0, {r0}
     f7c:	6564746e 	strbvs	r7, [r4, #-1134]!	; 0xfffffb92
     f80:	00682e66 	rsbeq	r2, r8, r6, ror #28
     f84:	00000004 	andeq	r0, r0, r4
     f88:	05003805 	streq	r3, [r0, #-2053]	; 0xfffff7fb
     f8c:	00998402 	addseq	r8, r9, r2, lsl #8
     f90:	22051500 	andcs	r1, r5, #0, 10
     f94:	2e2705bb 	mcrcs	5, 1, r0, cr7, cr11, {5}
     f98:	05661005 	strbeq	r1, [r6, #-5]!
     f9c:	2c054d1e 	stccs	13, cr4, [r5], {30}
     fa0:	01040200 	mrseq	r0, R12_usr
     fa4:	00300582 	eorseq	r0, r0, r2, lsl #11
     fa8:	2e010402 	cdpcs	4, 0, cr0, cr1, cr2, {0}
     fac:	02003305 	andeq	r3, r0, #335544320	; 0x14000000
     fb0:	05820104 	streq	r0, [r2, #260]	; 0x104
     fb4:	04020044 	streq	r0, [r2], #-68	; 0xffffffbc
     fb8:	3b052e01 	blcc	14c7c4 <__bss_end+0x1406cc>
     fbc:	01040200 	mrseq	r0, R12_usr
     fc0:	001e054a 	andseq	r0, lr, sl, asr #10
     fc4:	d6010402 	strle	r0, [r1], -r2, lsl #8
     fc8:	054b1505 	strbeq	r1, [fp, #-1285]	; 0xfffffafb
     fcc:	05316509 	ldreq	r6, [r1, #-1289]!	; 0xfffffaf7
     fd0:	2e05832a 	cdpcs	3, 0, cr8, cr5, cr10, {1}
     fd4:	6617052e 	ldrvs	r0, [r7], -lr, lsr #10
     fd8:	052e1c05 	streq	r1, [lr, #-3077]!	; 0xfffff3fb
     fdc:	1e05662e 	cfmadd32ne	mvax1, mvfx6, mvfx5, mvfx14
     fe0:	2f12052e 	svccs	0x0012052e
     fe4:	056a1e05 	strbeq	r1, [sl, #-3589]!	; 0xfffff1fb
     fe8:	0402002c 	streq	r0, [r2], #-44	; 0xffffffd4
     fec:	31058201 	tstcc	r5, r1, lsl #4
     ff0:	01040200 	mrseq	r0, R12_usr
     ff4:	0034052e 	eorseq	r0, r4, lr, lsr #10
     ff8:	82010402 	andhi	r0, r1, #33554432	; 0x2000000
     ffc:	02004505 	andeq	r4, r0, #20971520	; 0x1400000
    1000:	052e0104 	streq	r0, [lr, #-260]!	; 0xfffffefc
    1004:	0402003c 	streq	r0, [r2], #-60	; 0xffffffc4
    1008:	1e054a01 	vmlane.f32	s8, s10, s2
    100c:	01040200 	mrseq	r0, R12_usr
    1010:	4b1205d6 	blmi	482770 <__bss_end+0x476678>
    1014:	30650905 	rsbcc	r0, r5, r5, lsl #18
    1018:	05832905 	streq	r2, [r3, #2309]	; 0x905
    101c:	17052e2e 	strne	r2, [r5, -lr, lsr #28]
    1020:	2e1b0566 	cfmsc32cs	mvfx0, mvfx11, mvfx6
    1024:	05662e05 	strbeq	r2, [r6, #-3589]!	; 0xfffff1fb
    1028:	11052e1d 	tstne	r5, sp, lsl lr
    102c:	0309052f 	movweq	r0, #38191	; 0x952f
    1030:	0d056673 	stceq	6, cr6, [r5, #-460]	; 0xfffffe34
    1034:	510f0535 	tstpl	pc, r5, lsr r5	; <UNPREDICTABLE>
    1038:	2e130531 	mrccs	5, 0, r0, cr3, cr1, {1}
    103c:	05661505 	strbeq	r1, [r6, #-1285]!	; 0xfffffafb
    1040:	01054c0c 	tsteq	r5, ip, lsl #24
    1044:	85370530 	ldrhi	r0, [r7, #-1328]!	; 0xfffffad0
    1048:	05bb0505 	ldreq	r0, [fp, #1285]!	; 0x505
    104c:	09058416 	stmdbeq	r5, {r1, r2, r4, sl, pc}
    1050:	1505bba1 	strne	fp, [r5, #-2977]	; 0xfffff45f
    1054:	05d67a03 	ldrbeq	r7, [r6, #2563]	; 0xa03
    1058:	35053501 	strcc	r3, [r5, #-1281]	; 0xfffffaff
    105c:	9f09054e 	svcls	0x0009054e
    1060:	02bb0105 	adcseq	r0, fp, #1073741825	; 0x40000001
    1064:	01010006 	tsteq	r1, r6
    1068:	00000142 	andeq	r0, r0, r2, asr #2
    106c:	00c80003 	sbceq	r0, r8, r3
    1070:	01020000 	mrseq	r0, (UNDEF: 2)
    1074:	000d0efb 	strdeq	r0, [sp], -fp
    1078:	01010101 	tsteq	r1, r1, lsl #2
    107c:	01000000 	mrseq	r0, (UNDEF: 0)
    1080:	2f010000 	svccs	0x00010000
    1084:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
    1088:	6572742f 	ldrbvs	r7, [r2, #-1071]!	; 0xfffffbd1
    108c:	2f6c6966 	svccs	0x006c6966
    1090:	2f6d6573 	svccs	0x006d6573
    1094:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
    1098:	2f736563 	svccs	0x00736563
    109c:	6c647473 	cfstrdvs	mvd7, [r4], #-460	; 0xfffffe34
    10a0:	732f6269 			; <UNDEFINED> instruction: 0x732f6269
    10a4:	2f006372 	svccs	0x00006372
    10a8:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
    10ac:	6572742f 	ldrbvs	r7, [r2, #-1071]!	; 0xfffffbd1
    10b0:	2f6c6966 	svccs	0x006c6966
    10b4:	2f6d6573 	svccs	0x006d6573
    10b8:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
    10bc:	2f736563 	svccs	0x00736563
    10c0:	6c647473 	cfstrdvs	mvd7, [r4], #-460	; 0xfffffe34
    10c4:	692f6269 	stmdbvs	pc!, {r0, r3, r5, r6, r9, sp, lr}	; <UNPREDICTABLE>
    10c8:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
    10cc:	2f006564 	svccs	0x00006564
    10d0:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
    10d4:	6572742f 	ldrbvs	r7, [r2, #-1071]!	; 0xfffffbd1
    10d8:	2f6c6966 	svccs	0x006c6966
    10dc:	2f6d6573 	svccs	0x006d6573
    10e0:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
    10e4:	2f736563 	svccs	0x00736563
    10e8:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
    10ec:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
    10f0:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
    10f4:	622f6564 	eorvs	r6, pc, #100, 10	; 0x19000000
    10f8:	6472616f 	ldrbtvs	r6, [r2], #-367	; 0xfffffe91
    10fc:	6970722f 	ldmdbvs	r0!, {r0, r1, r2, r3, r5, r9, ip, sp, lr}^
    1100:	61682f30 	cmnvs	r8, r0, lsr pc
    1104:	4800006c 	stmdami	r0, {r2, r3, r5, r6}
    1108:	5f706165 	svcpl	0x00706165
    110c:	616e614d 	cmnvs	lr, sp, asr #2
    1110:	2e726567 	cdpcs	5, 7, cr6, cr2, cr7, {3}
    1114:	00707063 	rsbseq	r7, r0, r3, rrx
    1118:	48000001 	stmdami	r0, {r0}
    111c:	5f706165 	svcpl	0x00706165
    1120:	616e614d 	cmnvs	lr, sp, asr #2
    1124:	2e726567 	cdpcs	5, 7, cr6, cr2, cr7, {3}
    1128:	00020068 	andeq	r0, r2, r8, rrx
    112c:	746e6900 	strbtvc	r6, [lr], #-2304	; 0xfffff700
    1130:	2e666564 	cdpcs	5, 6, cr6, cr6, cr4, {3}
    1134:	00030068 	andeq	r0, r3, r8, rrx
    1138:	01050000 	mrseq	r0, (UNDEF: 5)
    113c:	f4020500 	vst3.8	{d0,d2,d4}, [r2], r0
    1140:	1700009b 			; <UNDEFINED> instruction: 0x1700009b
    1144:	05821c05 	streq	r1, [r2, #3077]	; 0xc05
    1148:	0520081e 	streq	r0, [r0, #-2078]!	; 0xfffff7e2
    114c:	2805a01a 	stmdacs	r5, {r1, r3, r4, sp, pc}
    1150:	4a050586 	bmi	142770 <__bss_end+0x136678>
    1154:	08052f2f 	stmdaeq	r5, {r0, r1, r2, r3, r5, r8, r9, sl, fp, sp}
    1158:	4a05054d 	bmi	142694 <__bss_end+0x13659c>
    115c:	054b1505 	strbeq	r1, [fp, #-1285]	; 0xfffffafb
    1160:	1205670f 	andne	r6, r5, #3932160	; 0x3c0000
    1164:	4a0f054a 	bmi	3c2694 <__bss_end+0x3b659c>
    1168:	05670105 	strbeq	r0, [r7, #-261]!	; 0xfffffefb
    116c:	0c058529 	cfstr32eq	mvfx8, [r5], {41}	; 0x29
    1170:	4b010583 	blmi	42784 <__bss_end+0x3668c>
    1174:	05842905 	streq	r2, [r4, #2309]	; 0x905
    1178:	1005a012 	andne	sl, r5, r2, lsl r0
    117c:	670d054a 	strvs	r0, [sp, -sl, asr #10]
    1180:	05490505 	strbeq	r0, [r9, #-1285]	; 0xfffffafb
    1184:	1105300e 	tstne	r5, lr
    1188:	bd0f0567 	cfstr32lt	mvfx0, [pc, #-412]	; ff4 <shift+0xff4>
    118c:	05bc2b05 	ldreq	r2, [ip, #2821]!	; 0xb05
    1190:	0f052f01 	svceq	0x00052f01
    1194:	02009e67 	andeq	r9, r0, #1648	; 0x670
    1198:	66060104 	strvs	r0, [r6], -r4, lsl #2
    119c:	02000e05 	andeq	r0, r0, #5, 28	; 0x50
    11a0:	82060304 	andhi	r0, r6, #4, 6	; 0x10000000
    11a4:	9e4a0f05 	cdpls	15, 4, cr0, cr10, cr5, {0}
    11a8:	000a024a 	andeq	r0, sl, sl, asr #4
    11ac:	00d50101 	sbcseq	r0, r5, r1, lsl #2
    11b0:	00030000 	andeq	r0, r3, r0
    11b4:	00000079 	andeq	r0, r0, r9, ror r0
    11b8:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
    11bc:	0101000d 	tsteq	r1, sp
    11c0:	00000101 	andeq	r0, r0, r1, lsl #2
    11c4:	00000100 	andeq	r0, r0, r0, lsl #2
    11c8:	6f682f01 	svcvs	0x00682f01
    11cc:	742f656d 	strtvc	r6, [pc], #-1389	; 11d4 <shift+0x11d4>
    11d0:	69666572 	stmdbvs	r6!, {r1, r4, r5, r6, r8, sl, sp, lr}^
    11d4:	65732f6c 	ldrbvs	r2, [r3, #-3948]!	; 0xfffff094
    11d8:	6f732f6d 	svcvs	0x00732f6d
    11dc:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
    11e0:	74732f73 	ldrbtvc	r2, [r3], #-3955	; 0xfffff08d
    11e4:	62696c64 	rsbvs	r6, r9, #100, 24	; 0x6400
    11e8:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
    11ec:	6f682f00 	svcvs	0x00682f00
    11f0:	742f656d 	strtvc	r6, [pc], #-1389	; 11f8 <shift+0x11f8>
    11f4:	69666572 	stmdbvs	r6!, {r1, r4, r5, r6, r8, sl, sp, lr}^
    11f8:	65732f6c 	ldrbvs	r2, [r3, #-3948]!	; 0xfffff094
    11fc:	6f732f6d 	svcvs	0x00732f6d
    1200:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
    1204:	74732f73 	ldrbtvc	r2, [r3], #-3955	; 0xfffff08d
    1208:	62696c64 	rsbvs	r6, r9, #100, 24	; 0x6400
    120c:	636e692f 	cmnvs	lr, #770048	; 0xbc000
    1210:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
    1214:	61520000 	cmpvs	r2, r0
    1218:	6d6f646e 	cfstrdvs	mvd6, [pc, #-440]!	; 1068 <shift+0x1068>
    121c:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
    1220:	00000100 	andeq	r0, r0, r0, lsl #2
    1224:	646e6152 	strbtvs	r6, [lr], #-338	; 0xfffffeae
    1228:	682e6d6f 	stmdavs	lr!, {r0, r1, r2, r3, r5, r6, r8, sl, fp, sp, lr}
    122c:	00000200 	andeq	r0, r0, r0, lsl #4
    1230:	00010500 	andeq	r0, r1, r0, lsl #10
    1234:	9dc00205 	sfmls	f0, 2, [r0, #20]
    1238:	05160000 	ldreq	r0, [r6, #-0]
    123c:	0205d730 	andeq	sp, r5, #48, 14	; 0xc00000
    1240:	05132402 	ldreq	r2, [r3, #-1026]	; 0xfffffbfe
    1244:	0805a120 	stmdaeq	r5, {r5, r8, sp, pc}
    1248:	4a050583 	bmi	14285c <__bss_end+0x136764>
    124c:	054b2005 	strbeq	r2, [fp, #-5]
    1250:	10054a1e 	andne	r4, r5, lr, lsl sl
    1254:	4a12054b 	bmi	482788 <__bss_end+0x476690>
    1258:	054a1105 	strbeq	r1, [sl, #-261]	; 0xfffffefb
    125c:	09052e29 	stmdbeq	r5, {r0, r3, r5, r9, sl, fp, sp}
    1260:	4b18054a 	blmi	602790 <__bss_end+0x5f6698>
    1264:	054a0905 	strbeq	r0, [sl, #-2309]	; 0xfffff6fb
    1268:	0c05bd1a 	stceq	13, cr11, [r5], {26}
    126c:	2f010567 	svccs	0x00010567
    1270:	056a2505 	strbeq	r2, [sl, #-1285]!	; 0xfffffafb
    1274:	1d058317 	stcne	3, cr8, [r5, #-92]	; 0xffffffa4
    1278:	9e0b0567 	cfsh32ls	mvfx0, mvfx11, #55
    127c:	054b0c05 	strbeq	r0, [fp, #-3077]	; 0xfffff3fb
    1280:	0c024b01 			; <UNDEFINED> instruction: 0x0c024b01
    1284:	ef010100 	svc	0x00010100
    1288:	03000002 	movweq	r0, #2
    128c:	00017b00 	andeq	r7, r1, r0, lsl #22
    1290:	fb010200 	blx	41a9a <__bss_end+0x359a2>
    1294:	01000d0e 	tsteq	r0, lr, lsl #26
    1298:	00010101 	andeq	r0, r1, r1, lsl #2
    129c:	00010000 	andeq	r0, r1, r0
    12a0:	682f0100 	stmdavs	pc!, {r8}	; <UNPREDICTABLE>
    12a4:	2f656d6f 	svccs	0x00656d6f
    12a8:	66657274 			; <UNDEFINED> instruction: 0x66657274
    12ac:	732f6c69 			; <UNDEFINED> instruction: 0x732f6c69
    12b0:	732f6d65 			; <UNDEFINED> instruction: 0x732f6d65
    12b4:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
    12b8:	732f7365 			; <UNDEFINED> instruction: 0x732f7365
    12bc:	696c6474 	stmdbvs	ip!, {r2, r4, r5, r6, sl, sp, lr}^
    12c0:	6e692f62 	cdpvs	15, 6, cr2, cr9, cr2, {3}
    12c4:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
    12c8:	682f0065 	stmdavs	pc!, {r0, r2, r5, r6}	; <UNPREDICTABLE>
    12cc:	2f656d6f 	svccs	0x00656d6f
    12d0:	66657274 			; <UNDEFINED> instruction: 0x66657274
    12d4:	732f6c69 			; <UNDEFINED> instruction: 0x732f6c69
    12d8:	732f6d65 			; <UNDEFINED> instruction: 0x732f6d65
    12dc:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
    12e0:	732f7365 			; <UNDEFINED> instruction: 0x732f7365
    12e4:	696c6474 	stmdbvs	ip!, {r2, r4, r5, r6, sl, sp, lr}^
    12e8:	72732f62 	rsbsvc	r2, r3, #392	; 0x188
    12ec:	682f0063 	stmdavs	pc!, {r0, r1, r5, r6}	; <UNPREDICTABLE>
    12f0:	2f656d6f 	svccs	0x00656d6f
    12f4:	66657274 			; <UNDEFINED> instruction: 0x66657274
    12f8:	732f6c69 			; <UNDEFINED> instruction: 0x732f6c69
    12fc:	732f6d65 			; <UNDEFINED> instruction: 0x732f6d65
    1300:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
    1304:	6b2f7365 	blvs	bde0a0 <__bss_end+0xbd1fa8>
    1308:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
    130c:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
    1310:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
    1314:	6f622f65 	svcvs	0x00622f65
    1318:	2f647261 	svccs	0x00647261
    131c:	30697072 	rsbcc	r7, r9, r2, ror r0
    1320:	6c61682f 	stclvs	8, cr6, [r1], #-188	; 0xffffff44
    1324:	6f682f00 	svcvs	0x00682f00
    1328:	742f656d 	strtvc	r6, [pc], #-1389	; 1330 <shift+0x1330>
    132c:	69666572 	stmdbvs	r6!, {r1, r4, r5, r6, r8, sl, sp, lr}^
    1330:	65732f6c 	ldrbvs	r2, [r3, #-3948]!	; 0xfffff094
    1334:	6f732f6d 	svcvs	0x00732f6d
    1338:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
    133c:	656b2f73 	strbvs	r2, [fp, #-3955]!	; 0xfffff08d
    1340:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
    1344:	636e692f 	cmnvs	lr, #770048	; 0xbc000
    1348:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
    134c:	6f72702f 	svcvs	0x0072702f
    1350:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    1354:	6f682f00 	svcvs	0x00682f00
    1358:	742f656d 	strtvc	r6, [pc], #-1389	; 1360 <shift+0x1360>
    135c:	69666572 	stmdbvs	r6!, {r1, r4, r5, r6, r8, sl, sp, lr}^
    1360:	65732f6c 	ldrbvs	r2, [r3, #-3948]!	; 0xfffff094
    1364:	6f732f6d 	svcvs	0x00732f6d
    1368:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
    136c:	656b2f73 	strbvs	r2, [fp, #-3955]!	; 0xfffff08d
    1370:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
    1374:	636e692f 	cmnvs	lr, #770048	; 0xbc000
    1378:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
    137c:	0073662f 	rsbseq	r6, r3, pc, lsr #12
    1380:	6d656d00 	stclvs	13, cr6, [r5, #-0]
    1384:	2e79726f 	cdpcs	2, 7, cr7, cr9, cr15, {3}
    1388:	00010068 	andeq	r0, r1, r8, rrx
    138c:	64747300 	ldrbtvs	r7, [r4], #-768	; 0xfffffd00
    1390:	66667562 	strbtvs	r7, [r6], -r2, ror #10
    1394:	632e7265 			; <UNDEFINED> instruction: 0x632e7265
    1398:	02007070 	andeq	r7, r0, #112	; 0x70
    139c:	6e690000 	cdpvs	0, 6, cr0, cr9, cr0, {0}
    13a0:	66656474 			; <UNDEFINED> instruction: 0x66656474
    13a4:	0300682e 	movweq	r6, #2094	; 0x82e
    13a8:	70730000 	rsbsvc	r0, r3, r0
    13ac:	6f6c6e69 	svcvs	0x006c6e69
    13b0:	682e6b63 	stmdavs	lr!, {r0, r1, r5, r6, r8, r9, fp, sp, lr}
    13b4:	00000400 	andeq	r0, r0, r0, lsl #8
    13b8:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
    13bc:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
    13c0:	682e6d65 	stmdavs	lr!, {r0, r2, r5, r6, r8, sl, fp, sp, lr}
    13c4:	00000500 	andeq	r0, r0, r0, lsl #10
    13c8:	636f7270 	cmnvs	pc, #112, 4
    13cc:	2e737365 	cdpcs	3, 7, cr7, cr3, cr5, {3}
    13d0:	00040068 	andeq	r0, r4, r8, rrx
    13d4:	6f727000 	svcvs	0x00727000
    13d8:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    13dc:	6e616d5f 	mcrvs	13, 3, r6, cr1, cr15, {2}
    13e0:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
    13e4:	0400682e 	streq	r6, [r0], #-2094	; 0xfffff7d2
    13e8:	65480000 	strbvs	r0, [r8, #-0]
    13ec:	4d5f7061 	ldclmi	0, cr7, [pc, #-388]	; 1270 <shift+0x1270>
    13f0:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
    13f4:	682e7265 	stmdavs	lr!, {r0, r2, r5, r6, r9, ip, sp, lr}
    13f8:	00000100 	andeq	r0, r0, r0, lsl #2
    13fc:	62647473 	rsbvs	r7, r4, #1929379840	; 0x73000000
    1400:	65666675 	strbvs	r6, [r6, #-1653]!	; 0xfffff98b
    1404:	00682e72 	rsbeq	r2, r8, r2, ror lr
    1408:	00000001 	andeq	r0, r0, r1
    140c:	05000105 	streq	r0, [r0, #-261]	; 0xfffffefb
    1410:	00992402 	addseq	r2, r9, r2, lsl #8
    1414:	010d0300 	mrseq	r0, SP_mon
    1418:	05831305 	streq	r1, [r3, #773]	; 0x305
    141c:	08028301 	stmdaeq	r2, {r0, r8, r9, pc}
    1420:	04010100 	streq	r0, [r1], #-256	; 0xffffff00
    1424:	00010502 	andeq	r0, r1, r2, lsl #10
    1428:	9f200205 	svcls	0x00200205
    142c:	05170000 	ldreq	r0, [r7, #-0]
    1430:	34059e32 	strcc	r9, [r5], #-3634	; 0xfffff1ce
    1434:	18052008 	stmdane	r5, {r3, sp}
    1438:	830c05a1 	movwhi	r0, #50593	; 0xc5a1
    143c:	054a1c05 	strbeq	r1, [sl, #-3077]	; 0xfffff3fb
    1440:	1705bb01 	strne	fp, [r5, -r1, lsl #22]
    1444:	830c0584 	movwhi	r0, #50564	; 0xc584
    1448:	054a1d05 	strbeq	r1, [sl, #-3333]	; 0xfffff2fb
    144c:	1e058301 	cdpne	3, 0, cr8, cr5, cr1, {0}
    1450:	bb100584 	bllt	402a68 <__bss_end+0x3f6970>
    1454:	054a1f05 	strbeq	r1, [sl, #-3845]	; 0xfffff0fb
    1458:	12058305 	andne	r8, r5, #335544320	; 0x14000000
    145c:	6701054a 	strvs	r0, [r1, -sl, asr #10]
    1460:	05841505 	streq	r1, [r4, #1285]	; 0x505
    1464:	13058312 	movwne	r8, #21266	; 0x5312
    1468:	67010567 	strvs	r0, [r1, -r7, ror #10]
    146c:	05852905 	streq	r2, [r5, #2309]	; 0x905
    1470:	1c059f0a 	stcne	15, cr9, [r5], {10}
    1474:	660a054a 	strvs	r0, [sl], -sl, asr #10
    1478:	05830105 	streq	r0, [r3, #261]	; 0x105
    147c:	23056e1f 	movwcs	r6, #24095	; 0x5e1f
    1480:	84080584 	strhi	r0, [r8], #-1412	; 0xfffffa7c
    1484:	05660505 	strbeq	r0, [r6, #-1285]!	; 0xfffffafb
    1488:	24054b1e 	strcs	r4, [r5], #-2846	; 0xfffff4e2
    148c:	4a1e054a 	bmi	7829bc <__bss_end+0x7768c4>
    1490:	05840905 	streq	r0, [r4, #2309]	; 0x905
    1494:	08056716 	stmdaeq	r5, {r1, r2, r4, r8, r9, sl, sp, lr}
    1498:	4a050569 	bmi	142a44 <__bss_end+0x13694c>
    149c:	02002205 	andeq	r2, r0, #1342177280	; 0x50000000
    14a0:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
    14a4:	0b054c0a 	bleq	1544d4 <__bss_end+0x1483dc>
    14a8:	0010054c 	andseq	r0, r0, ip, asr #10
    14ac:	4a010402 	bmi	424bc <__bss_end+0x363c4>
    14b0:	02001405 	andeq	r1, r0, #83886080	; 0x5000000
    14b4:	052e0104 	streq	r0, [lr, #-260]!	; 0xfffffefc
    14b8:	04020012 	streq	r0, [r2], #-18	; 0xffffffee
    14bc:	17054a01 	strne	r4, [r5, -r1, lsl #20]
    14c0:	2e18054b 	cfmac32cs	mvfx0, mvfx8, mvfx11
    14c4:	05660905 	strbeq	r0, [r6, #-2309]!	; 0xfffff6fb
    14c8:	0d054b18 	vstreq	d4, [r5, #-96]	; 0xffffffa0
    14cc:	0005054b 	andeq	r0, r5, fp, asr #10
    14d0:	2b020402 	blcs	824e0 <__bss_end+0x763e8>
    14d4:	09030805 	stmdbeq	r3, {r0, r2, fp}
    14d8:	66050582 	strvs	r0, [r5], -r2, lsl #11
    14dc:	054b0905 	strbeq	r0, [fp, #-2309]	; 0xfffff6fb
    14e0:	10056712 	andne	r6, r5, r2, lsl r7
    14e4:	4e1a054b 	cfmac32mi	mvfx0, mvfx10, mvfx11
    14e8:	052e1b05 	streq	r1, [lr, #-2821]!	; 0xfffff4fb
    14ec:	1205840b 	andne	r8, r5, #184549376	; 0xb000000
    14f0:	03040200 	movweq	r0, #16896	; 0x4200
    14f4:	001d054a 	andseq	r0, sp, sl, asr #10
    14f8:	83020402 	movwhi	r0, #9218	; 0x2402
    14fc:	02000d05 	andeq	r0, r0, #320	; 0x140
    1500:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
    1504:	0402000e 	streq	r0, [r2], #-14
    1508:	1e052e02 	cdpne	14, 0, cr2, cr5, cr2, {0}
    150c:	02040200 	andeq	r0, r4, #0, 4
    1510:	0010054a 	andseq	r0, r0, sl, asr #10
    1514:	66020402 	strvs	r0, [r2], -r2, lsl #8
    1518:	02000505 	andeq	r0, r0, #20971520	; 0x1400000
    151c:	052d0204 	streq	r0, [sp, #-516]!	; 0xfffffdfc
    1520:	0a058409 	beq	16254c <__bss_end+0x156454>
    1524:	4a0c052e 	bmi	3029e4 <__bss_end+0x2f68ec>
    1528:	054d1305 	strbeq	r1, [sp, #-773]	; 0xfffffcfb
    152c:	0505670c 	streq	r6, [r5, #-1804]	; 0xfffff8f4
    1530:	68250530 	stmdavs	r5!, {r4, r5, r8, sl}
    1534:	059f1205 	ldreq	r1, [pc, #517]	; 1741 <shift+0x1741>
    1538:	0402001b 	streq	r0, [r2], #-27	; 0xffffffe5
    153c:	11054a03 	tstne	r5, r3, lsl #20
    1540:	02040200 	andeq	r0, r4, #0, 4
    1544:	00050583 	andeq	r0, r5, r3, lsl #11
    1548:	f1020402 			; <UNDEFINED> instruction: 0xf1020402
    154c:	05850105 	streq	r0, [r5, #261]	; 0x105
    1550:	1e056839 	mcrne	8, 0, r6, cr5, cr9, {1}
    1554:	680905a2 	stmdavs	r9, {r1, r5, r7, r8, sl}
    1558:	05682605 	strbeq	r2, [r8, #-1541]!	; 0xfffff9fb
    155c:	1705670d 	strne	r6, [r5, -sp, lsl #14]
    1560:	67120585 	ldrvs	r0, [r2, -r5, lsl #11]
    1564:	054d0905 	strbeq	r0, [sp, #-2309]	; 0xfffff6fb
    1568:	11052f05 	tstne	r5, r5, lsl #30
    156c:	052e7903 	streq	r7, [lr, #-2307]!	; 0xfffff6fd
    1570:	0105360c 	tsteq	r5, ip, lsl #12
    1574:	0008022f 	andeq	r0, r8, pc, lsr #4
    1578:	02180101 	andseq	r0, r8, #1073741824	; 0x40000000
    157c:	00030000 	andeq	r0, r3, r0
    1580:	0000012d 	andeq	r0, r0, sp, lsr #2
    1584:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
    1588:	0101000d 	tsteq	r1, sp
    158c:	00000101 	andeq	r0, r0, r1, lsl #2
    1590:	00000100 	andeq	r0, r0, r0, lsl #2
    1594:	6f682f01 	svcvs	0x00682f01
    1598:	742f656d 	strtvc	r6, [pc], #-1389	; 15a0 <shift+0x15a0>
    159c:	69666572 	stmdbvs	r6!, {r1, r4, r5, r6, r8, sl, sp, lr}^
    15a0:	65732f6c 	ldrbvs	r2, [r3, #-3948]!	; 0xfffff094
    15a4:	6f732f6d 	svcvs	0x00732f6d
    15a8:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
    15ac:	74732f73 	ldrbtvc	r2, [r3], #-3955	; 0xfffff08d
    15b0:	62696c64 	rsbvs	r6, r9, #100, 24	; 0x6400
    15b4:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
    15b8:	6f682f00 	svcvs	0x00682f00
    15bc:	742f656d 	strtvc	r6, [pc], #-1389	; 15c4 <shift+0x15c4>
    15c0:	69666572 	stmdbvs	r6!, {r1, r4, r5, r6, r8, sl, sp, lr}^
    15c4:	65732f6c 	ldrbvs	r2, [r3, #-3948]!	; 0xfffff094
    15c8:	6f732f6d 	svcvs	0x00732f6d
    15cc:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
    15d0:	656b2f73 	strbvs	r2, [fp, #-3955]!	; 0xfffff08d
    15d4:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
    15d8:	636e692f 	cmnvs	lr, #770048	; 0xbc000
    15dc:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
    15e0:	6f72702f 	svcvs	0x0072702f
    15e4:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    15e8:	6f682f00 	svcvs	0x00682f00
    15ec:	742f656d 	strtvc	r6, [pc], #-1389	; 15f4 <shift+0x15f4>
    15f0:	69666572 	stmdbvs	r6!, {r1, r4, r5, r6, r8, sl, sp, lr}^
    15f4:	65732f6c 	ldrbvs	r2, [r3, #-3948]!	; 0xfffff094
    15f8:	6f732f6d 	svcvs	0x00732f6d
    15fc:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
    1600:	656b2f73 	strbvs	r2, [fp, #-3955]!	; 0xfffff08d
    1604:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
    1608:	636e692f 	cmnvs	lr, #770048	; 0xbc000
    160c:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
    1610:	0073662f 	rsbseq	r6, r3, pc, lsr #12
    1614:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 1560 <shift+0x1560>
    1618:	72742f65 	rsbsvc	r2, r4, #404	; 0x194
    161c:	6c696665 	stclvs	6, cr6, [r9], #-404	; 0xfffffe6c
    1620:	6d65732f 	stclvs	3, cr7, [r5, #-188]!	; 0xffffff44
    1624:	756f732f 	strbvc	r7, [pc, #-815]!	; 12fd <shift+0x12fd>
    1628:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
    162c:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
    1630:	2f6c656e 	svccs	0x006c656e
    1634:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
    1638:	2f656475 	svccs	0x00656475
    163c:	72616f62 	rsbvc	r6, r1, #392	; 0x188
    1640:	70722f64 	rsbsvc	r2, r2, r4, ror #30
    1644:	682f3069 	stmdavs	pc!, {r0, r3, r5, r6, ip, sp}	; <UNPREDICTABLE>
    1648:	00006c61 	andeq	r6, r0, r1, ror #24
    164c:	66647473 			; <UNDEFINED> instruction: 0x66647473
    1650:	2e656c69 	cdpcs	12, 6, cr6, cr5, cr9, {3}
    1654:	00707063 	rsbseq	r7, r0, r3, rrx
    1658:	73000001 	movwvc	r0, #1
    165c:	682e6977 	stmdavs	lr!, {r0, r1, r2, r4, r5, r6, r8, fp, sp, lr}
    1660:	00000200 	andeq	r0, r0, r0, lsl #4
    1664:	6e697073 	mcrvs	0, 3, r7, cr9, cr3, {3}
    1668:	6b636f6c 	blvs	18dd420 <__bss_end+0x18d1328>
    166c:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
    1670:	69660000 	stmdbvs	r6!, {}^	; <UNPREDICTABLE>
    1674:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
    1678:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
    167c:	0300682e 	movweq	r6, #2094	; 0x82e
    1680:	72700000 	rsbsvc	r0, r0, #0
    1684:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    1688:	00682e73 	rsbeq	r2, r8, r3, ror lr
    168c:	70000002 	andvc	r0, r0, r2
    1690:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    1694:	6d5f7373 	ldclvs	3, cr7, [pc, #-460]	; 14d0 <shift+0x14d0>
    1698:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
    169c:	682e7265 	stmdavs	lr!, {r0, r2, r5, r6, r9, ip, sp, lr}
    16a0:	00000200 	andeq	r0, r0, r0, lsl #4
    16a4:	64746e69 	ldrbtvs	r6, [r4], #-3689	; 0xfffff197
    16a8:	682e6665 	stmdavs	lr!, {r0, r2, r5, r6, r9, sl, sp, lr}
    16ac:	00000400 	andeq	r0, r0, r0, lsl #8
    16b0:	00010500 	andeq	r0, r1, r0, lsl #10
    16b4:	a3300205 	teqge	r0, #1342177280	; 0x50000000
    16b8:	05160000 	ldreq	r0, [r6, #-0]
    16bc:	052f6905 	streq	r6, [pc, #-2309]!	; dbf <shift+0xdbf>
    16c0:	01054c0c 	tsteq	r5, ip, lsl #24
    16c4:	0505852f 	streq	r8, [r5, #-1327]	; 0xfffffad1
    16c8:	01054b83 	smlabbeq	r5, r3, fp, r4
    16cc:	0505852f 	streq	r8, [r5, #-1327]	; 0xfffffad1
    16d0:	2f01054b 	svccs	0x0001054b
    16d4:	a1050585 	smlabbge	r5, r5, r5, r0
    16d8:	052f4b4b 	streq	r4, [pc, #-2891]!	; b95 <shift+0xb95>
    16dc:	01054c0c 	tsteq	r5, ip, lsl #24
    16e0:	0505852f 	streq	r8, [r5, #-1327]	; 0xfffffad1
    16e4:	4b4b4bbd 	blmi	12d45e0 <__bss_end+0x12c84e8>
    16e8:	4c0c052f 	cfstr32mi	mvfx0, [ip], {47}	; 0x2f
    16ec:	862f0105 	strthi	r0, [pc], -r5, lsl #2
    16f0:	4bbd0505 	blmi	fef42b0c <__bss_end+0xfef36a14>
    16f4:	052f4b4b 	streq	r4, [pc, #-2891]!	; bb1 <shift+0xbb1>
    16f8:	01054c0c 	tsteq	r5, ip, lsl #24
    16fc:	0505852f 	streq	r8, [r5, #-1327]	; 0xfffffad1
    1700:	01054b83 	smlabbeq	r5, r3, fp, r4
    1704:	0505852f 	streq	r8, [r5, #-1327]	; 0xfffffad1
    1708:	4b4b4bbd 	blmi	12d4604 <__bss_end+0x12c850c>
    170c:	4c0c052f 	cfstr32mi	mvfx0, [ip], {47}	; 0x2f
    1710:	852f0105 	strhi	r0, [pc, #-261]!	; 1613 <shift+0x1613>
    1714:	4ba10505 	blmi	fe842b30 <__bss_end+0xfe836a38>
    1718:	0c052f4b 	stceq	15, cr2, [r5], {75}	; 0x4b
    171c:	2f01054c 	svccs	0x0001054c
    1720:	bd050585 	cfstr32lt	mvfx0, [r5, #-532]	; 0xfffffdec
    1724:	2f4b4b4b 	svccs	0x004b4b4b
    1728:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
    172c:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
    1730:	4b4ba105 	blmi	12e9b4c <__bss_end+0x12dda54>
    1734:	4c0c052f 	cfstr32mi	mvfx0, [ip], {47}	; 0x2f
    1738:	859f0105 	ldrhi	r0, [pc, #261]	; 1845 <shift+0x1845>
    173c:	05672005 	strbeq	r2, [r7, #-5]!
    1740:	4b4b4d05 	blmi	12d4b5c <__bss_end+0x12c8a64>
    1744:	05300c05 	ldreq	r0, [r0, #-3077]!	; 0xfffff3fb
    1748:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
    174c:	05056720 	streq	r6, [r5, #-1824]	; 0xfffff8e0
    1750:	054b4b4d 	strbeq	r4, [fp, #-2893]	; 0xfffff4b3
    1754:	0105300c 	tsteq	r5, ip
    1758:	2005852f 	andcs	r8, r5, pc, lsr #10
    175c:	4c050583 	cfstr32mi	mvfx0, [r5], {131}	; 0x83
    1760:	01054b4b 	tsteq	r5, fp, asr #22
    1764:	2005852f 	andcs	r8, r5, pc, lsr #10
    1768:	4d050567 	cfstr32mi	mvfx0, [r5, #-412]	; 0xfffffe64
    176c:	0c054b4b 			; <UNDEFINED> instruction: 0x0c054b4b
    1770:	2f010530 	svccs	0x00010530
    1774:	a00c0587 	andge	r0, ip, r7, lsl #11
    1778:	bc31059f 	cfldr32lt	mvfx0, [r1], #-636	; 0xfffffd84
    177c:	05662905 	strbeq	r2, [r6, #-2309]!	; 0xfffff6fb
    1780:	0f052e36 	svceq	0x00052e36
    1784:	66130530 			; <UNDEFINED> instruction: 0x66130530
    1788:	05840905 	streq	r0, [r4, #2309]	; 0x905
    178c:	0105d810 	tsteq	r5, r0, lsl r8
    1790:	0008029f 	muleq	r8, pc, r2	; <UNPREDICTABLE>
    1794:	04fe0101 	ldrbteq	r0, [lr], #257	; 0x101
    1798:	00030000 	andeq	r0, r3, r0
    179c:	00000048 	andeq	r0, r0, r8, asr #32
    17a0:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
    17a4:	0101000d 	tsteq	r1, sp
    17a8:	00000101 	andeq	r0, r0, r1, lsl #2
    17ac:	00000100 	andeq	r0, r0, r0, lsl #2
    17b0:	6f682f01 	svcvs	0x00682f01
    17b4:	742f656d 	strtvc	r6, [pc], #-1389	; 17bc <shift+0x17bc>
    17b8:	69666572 	stmdbvs	r6!, {r1, r4, r5, r6, r8, sl, sp, lr}^
    17bc:	65732f6c 	ldrbvs	r2, [r3, #-3948]!	; 0xfffff094
    17c0:	6f732f6d 	svcvs	0x00732f6d
    17c4:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
    17c8:	74732f73 	ldrbtvc	r2, [r3], #-3955	; 0xfffff08d
    17cc:	62696c64 	rsbvs	r6, r9, #100, 24	; 0x6400
    17d0:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
    17d4:	74730000 	ldrbtvc	r0, [r3], #-0
    17d8:	72747364 	rsbsvc	r7, r4, #100, 6	; 0x90000001
    17dc:	2e676e69 	cdpcs	14, 6, cr6, cr7, cr9, {3}
    17e0:	00707063 	rsbseq	r7, r0, r3, rrx
    17e4:	00000001 	andeq	r0, r0, r1
    17e8:	05000105 	streq	r0, [r0, #-261]	; 0xfffffefb
    17ec:	00a79002 	adceq	r9, r7, r2
    17f0:	09051a00 	stmdbeq	r5, {r9, fp, ip}
    17f4:	0f054bbb 	svceq	0x00054bbb
    17f8:	681b054c 	ldmdavs	fp, {r2, r3, r6, r8, sl}
    17fc:	052e2105 	streq	r2, [lr, #-261]!	; 0xfffffefb
    1800:	0b059e0a 	bleq	169030 <__bss_end+0x15cf38>
    1804:	4a27052e 	bmi	9c2cc4 <__bss_end+0x9b6bcc>
    1808:	054a0d05 	strbeq	r0, [sl, #-3333]	; 0xfffff2fb
    180c:	04052f09 	streq	r2, [r5], #-3849	; 0xfffff0f7
    1810:	620205bb 	andvs	r0, r2, #784334848	; 0x2ec00000
    1814:	05350505 	ldreq	r0, [r5, #-1285]!	; 0xfffffafb
    1818:	11056810 	tstne	r5, r0, lsl r8
    181c:	4a22052e 	bmi	882cdc <__bss_end+0x876be4>
    1820:	052e1305 	streq	r1, [lr, #-773]!	; 0xfffffcfb
    1824:	09052f0a 	stmdbeq	r5, {r1, r3, r8, r9, sl, fp, sp}
    1828:	2e0a0569 	cfsh32cs	mvfx0, mvfx10, #57
    182c:	054a0c05 	strbeq	r0, [sl, #-3077]	; 0xfffff3fb
    1830:	10054b03 	andne	r4, r5, r3, lsl #22
    1834:	02040200 	andeq	r0, r4, #0, 4
    1838:	000c0568 	andeq	r0, ip, r8, ror #10
    183c:	9e020402 	cdpls	4, 0, cr0, cr2, cr2, {0}
    1840:	02001505 	andeq	r1, r0, #20971520	; 0x1400000
    1844:	05680104 	strbeq	r0, [r8, #-260]!	; 0xfffffefc
    1848:	04020018 	streq	r0, [r2], #-24	; 0xffffffe8
    184c:	08058201 	stmdaeq	r5, {r0, r9, pc}
    1850:	01040200 	mrseq	r0, R12_usr
    1854:	001a054a 	andseq	r0, sl, sl, asr #10
    1858:	4b010402 	blmi	42868 <__bss_end+0x36770>
    185c:	02001b05 	andeq	r1, r0, #5120	; 0x1400
    1860:	052e0104 	streq	r0, [lr, #-260]!	; 0xfffffefc
    1864:	0402000c 	streq	r0, [r2], #-12
    1868:	0f054a01 	svceq	0x00054a01
    186c:	01040200 	mrseq	r0, R12_usr
    1870:	001b0582 	andseq	r0, fp, r2, lsl #11
    1874:	4a010402 	bmi	42884 <__bss_end+0x3678c>
    1878:	02001105 	andeq	r1, r0, #1073741825	; 0x40000001
    187c:	052e0104 	streq	r0, [lr, #-260]!	; 0xfffffefc
    1880:	0402000a 	streq	r0, [r2], #-10
    1884:	0b052f01 	bleq	14d490 <__bss_end+0x141398>
    1888:	01040200 	mrseq	r0, R12_usr
    188c:	000d052e 	andeq	r0, sp, lr, lsr #10
    1890:	4a010402 	bmi	428a0 <__bss_end+0x367a8>
    1894:	02000205 	andeq	r0, r0, #1342177280	; 0x50000000
    1898:	05460104 	strbeq	r0, [r6, #-260]	; 0xfffffefc
    189c:	05858901 	streq	r8, [r5, #2305]	; 0x901
    18a0:	09058306 	stmdbeq	r5, {r1, r2, r8, r9, pc}
    18a4:	4a10054c 	bmi	402ddc <__bss_end+0x3f6ce4>
    18a8:	054c0a05 	strbeq	r0, [ip, #-2565]	; 0xfffff5fb
    18ac:	0305bb07 	movweq	fp, #23303	; 0x5b07
    18b0:	0017054a 	andseq	r0, r7, sl, asr #10
    18b4:	4a010402 	bmi	428c4 <__bss_end+0x367cc>
    18b8:	02001405 	andeq	r1, r0, #83886080	; 0x5000000
    18bc:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
    18c0:	14054d0d 	strne	r4, [r5], #-3341	; 0xfffff2f3
    18c4:	2e0a054a 	cfsh32cs	mvfx0, mvfx10, #42
    18c8:	05680805 	strbeq	r0, [r8, #-2053]!	; 0xfffff7fb
    18cc:	66780302 	ldrbtvs	r0, [r8], -r2, lsl #6
    18d0:	0b030905 	bleq	c3cec <__bss_end+0xb7bf4>
    18d4:	2f01052e 	svccs	0x0001052e
    18d8:	05862705 	streq	r2, [r6, #1797]	; 0x705
    18dc:	054b840a 	strbeq	r8, [fp, #-1034]	; 0xfffffbf6
    18e0:	12054b0b 	andne	r4, r5, #11264	; 0x2c00
    18e4:	4b0e054a 	blmi	382e14 <__bss_end+0x376d1c>
    18e8:	05670905 	strbeq	r0, [r7, #-2309]!	; 0xfffff6fb
    18ec:	04020018 	streq	r0, [r2], #-24	; 0xffffffe8
    18f0:	15056601 	strne	r6, [r5, #-1537]	; 0xfffff9ff
    18f4:	01040200 	mrseq	r0, R12_usr
    18f8:	00110566 	andseq	r0, r1, r6, ror #10
    18fc:	4b020402 	blmi	8290c <__bss_end+0x76814>
    1900:	02001a05 	andeq	r1, r0, #20480	; 0x5000
    1904:	054b0204 	strbeq	r0, [fp, #-516]	; 0xfffffdfc
    1908:	04020012 	streq	r0, [r2], #-18	; 0xffffffee
    190c:	0d054b02 	vstreq	d4, [r5, #-8]
    1910:	02040200 	andeq	r0, r4, #0, 4
    1914:	31090567 	tstcc	r9, r7, ror #10
    1918:	02001405 	andeq	r1, r0, #83886080	; 0x5000000
    191c:	05660204 	strbeq	r0, [r6, #-516]!	; 0xfffffdfc
    1920:	04020026 	streq	r0, [r2], #-38	; 0xffffffda
    1924:	09056603 	stmdbeq	r5, {r0, r1, r9, sl, sp, lr}
    1928:	671a054c 	ldrvs	r0, [sl, -ip, asr #10]
    192c:	054b0a05 	strbeq	r0, [fp, #-2565]	; 0xfffff5fb
    1930:	66730305 	ldrbtvs	r0, [r3], -r5, lsl #6
    1934:	052e0f03 	streq	r0, [lr, #-3843]!	; 0xfffff0fd
    1938:	0402001c 	streq	r0, [r2], #-28	; 0xffffffe4
    193c:	0f056601 	svceq	0x00056601
    1940:	0402004c 	streq	r0, [r2], #-76	; 0xffffffb4
    1944:	05660601 	strbeq	r0, [r6, #-1537]!	; 0xfffff9ff
    1948:	04020013 	streq	r0, [r2], #-19	; 0xffffffed
    194c:	052e0601 	streq	r0, [lr, #-1537]!	; 0xfffff9ff
    1950:	0402000f 	streq	r0, [r2], #-15
    1954:	13052e02 	movwne	r2, #24066	; 0x5e02
    1958:	3001052e 	andcc	r0, r1, lr, lsr #10
    195c:	05861e05 	streq	r1, [r6, #3589]	; 0xe05
    1960:	6867830c 	stmdavs	r7!, {r2, r3, r8, r9, pc}^
    1964:	4b670905 	blmi	19c3d80 <__bss_end+0x19b7c88>
    1968:	054b0a05 	strbeq	r0, [fp, #-2565]	; 0xfffff5fb
    196c:	12054c0b 	andne	r4, r5, #2816	; 0xb00
    1970:	4b0d054a 	blmi	342ea0 <__bss_end+0x336da8>
    1974:	054a0905 	strbeq	r0, [sl, #-2309]	; 0xfffff6fb
    1978:	0402001b 	streq	r0, [r2], #-27	; 0xffffffe5
    197c:	12054b01 	andne	r4, r5, #1024	; 0x400
    1980:	01040200 	mrseq	r0, R12_usr
    1984:	000d054b 	andeq	r0, sp, fp, asr #10
    1988:	67010402 	strvs	r0, [r1, -r2, lsl #8]
    198c:	05301205 	ldreq	r1, [r0, #-517]!	; 0xfffffdfb
    1990:	22054a0e 	andcs	r4, r5, #57344	; 0xe000
    1994:	01040200 	mrseq	r0, R12_usr
    1998:	001f054a 	andseq	r0, pc, sl, asr #10
    199c:	4a010402 	bmi	429ac <__bss_end+0x368b4>
    19a0:	054b1605 	strbeq	r1, [fp, #-1541]	; 0xfffff9fb
    19a4:	10054a1d 	andne	r4, r5, sp, lsl sl
    19a8:	6709052e 	strvs	r0, [r9, -lr, lsr #10]
    19ac:	05671305 	strbeq	r1, [r7, #-773]!	; 0xfffffcfb
    19b0:	1405d723 	strne	sp, [r5], #-1827	; 0xfffff8dd
    19b4:	851d059e 	ldrhi	r0, [sp, #-1438]	; 0xfffffa62
    19b8:	05661405 	strbeq	r1, [r6, #-1029]!	; 0xfffffbfb
    19bc:	0505680e 	streq	r6, [r5, #-2062]	; 0xfffff7f2
    19c0:	05667103 	strbeq	r7, [r6, #-259]!	; 0xfffffefd
    19c4:	2e11030c 	cdpcs	3, 1, cr0, cr1, cr12, {0}
    19c8:	084b0105 	stmdaeq	fp, {r0, r2, r8}^
    19cc:	bd090522 	cfstr32lt	mvfx0, [r9, #-136]	; 0xffffff78
    19d0:	02001605 	andeq	r1, r0, #5242880	; 0x500000
    19d4:	054a0404 	strbeq	r0, [sl, #-1028]	; 0xfffffbfc
    19d8:	0402001d 	streq	r0, [r2], #-29	; 0xffffffe3
    19dc:	1e058202 	cdpne	2, 0, cr8, cr5, cr2, {0}
    19e0:	02040200 	andeq	r0, r4, #0, 4
    19e4:	0016052e 	andseq	r0, r6, lr, lsr #10
    19e8:	66020402 	strvs	r0, [r2], -r2, lsl #8
    19ec:	02001105 	andeq	r1, r0, #1073741825	; 0x40000001
    19f0:	054b0304 	strbeq	r0, [fp, #-772]	; 0xfffffcfc
    19f4:	04020012 	streq	r0, [r2], #-18	; 0xffffffee
    19f8:	08052e03 	stmdaeq	r5, {r0, r1, r9, sl, fp, sp}
    19fc:	03040200 	movweq	r0, #16896	; 0x4200
    1a00:	0009054a 	andeq	r0, r9, sl, asr #10
    1a04:	2e030402 	cdpcs	4, 0, cr0, cr3, cr2, {0}
    1a08:	02001205 	andeq	r1, r0, #1342177280	; 0x50000000
    1a0c:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
    1a10:	0402000b 	streq	r0, [r2], #-11
    1a14:	02052e03 	andeq	r2, r5, #3, 28	; 0x30
    1a18:	03040200 	movweq	r0, #16896	; 0x4200
    1a1c:	000b052d 	andeq	r0, fp, sp, lsr #10
    1a20:	84020402 	strhi	r0, [r2], #-1026	; 0xfffffbfe
    1a24:	02000805 	andeq	r0, r0, #327680	; 0x50000
    1a28:	05830104 	streq	r0, [r3, #260]	; 0x104
    1a2c:	04020009 	streq	r0, [r2], #-9
    1a30:	0b052e01 	bleq	14d23c <__bss_end+0x141144>
    1a34:	01040200 	mrseq	r0, R12_usr
    1a38:	0002054a 	andeq	r0, r2, sl, asr #10
    1a3c:	49010402 	stmdbmi	r1, {r1, sl}
    1a40:	05850b05 	streq	r0, [r5, #2821]	; 0xb05
    1a44:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
    1a48:	1105bc0e 	tstne	r5, lr, lsl #24
    1a4c:	bc200566 	cfstr32lt	mvfx0, [r0], #-408	; 0xfffffe68
    1a50:	05660b05 	strbeq	r0, [r6, #-2821]!	; 0xfffff4fb
    1a54:	0a054b1f 	beq	1546d8 <__bss_end+0x1485e0>
    1a58:	4b080566 	blmi	202ff8 <__bss_end+0x1f6f00>
    1a5c:	05831105 	streq	r1, [r3, #261]	; 0x105
    1a60:	08052e16 	stmdaeq	r5, {r1, r2, r4, r9, sl, fp, sp}
    1a64:	67110567 	ldrvs	r0, [r1, -r7, ror #10]
    1a68:	054d0b05 	strbeq	r0, [sp, #-2821]	; 0xfffff4fb
    1a6c:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
    1a70:	0b058306 	bleq	162690 <__bss_end+0x156598>
    1a74:	2e0c054c 	cfsh32cs	mvfx0, mvfx12, #44
    1a78:	05660e05 	strbeq	r0, [r6, #-3589]!	; 0xfffff1fb
    1a7c:	02054b04 	andeq	r4, r5, #4, 22	; 0x1000
    1a80:	31090565 	tstcc	r9, r5, ror #10
    1a84:	052f0105 	streq	r0, [pc, #-261]!	; 1987 <shift+0x1987>
    1a88:	1305852a 	movwne	r8, #21802	; 0x552a
    1a8c:	0905679f 	stmdbeq	r5, {r0, r1, r2, r3, r4, r7, r8, r9, sl, sp, lr}
    1a90:	4b0d0567 	blmi	343034 <__bss_end+0x336f3c>
    1a94:	02001505 	andeq	r1, r0, #20971520	; 0x1400000
    1a98:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
    1a9c:	04020019 	streq	r0, [r2], #-25	; 0xffffffe7
    1aa0:	1a058302 	bne	1626b0 <__bss_end+0x1565b8>
    1aa4:	02040200 	andeq	r0, r4, #0, 4
    1aa8:	000f052e 	andeq	r0, pc, lr, lsr #10
    1aac:	4a020402 	bmi	82abc <__bss_end+0x769c4>
    1ab0:	02001105 	andeq	r1, r0, #1073741825	; 0x40000001
    1ab4:	05820204 	streq	r0, [r2, #516]	; 0x204
    1ab8:	0402001a 	streq	r0, [r2], #-26	; 0xffffffe6
    1abc:	13054a02 	movwne	r4, #23042	; 0x5a02
    1ac0:	02040200 	andeq	r0, r4, #0, 4
    1ac4:	0005052e 	andeq	r0, r5, lr, lsr #10
    1ac8:	2d020402 	cfstrscs	mvf0, [r2, #-8]
    1acc:	05840a05 	streq	r0, [r4, #2565]	; 0xa05
    1ad0:	0d052e0b 	stceq	14, cr2, [r5, #-44]	; 0xffffffd4
    1ad4:	4b0c054a 	blmi	303004 <__bss_end+0x2f6f0c>
    1ad8:	05300105 	ldreq	r0, [r0, #-261]!	; 0xfffffefb
    1adc:	09056734 	stmdbeq	r5, {r2, r4, r5, r8, r9, sl, sp, lr}
    1ae0:	4c1305bb 	cfldr32mi	mvfx0, [r3], {187}	; 0xbb
    1ae4:	05680505 	strbeq	r0, [r8, #-1285]!	; 0xfffffafb
    1ae8:	04020019 	streq	r0, [r2], #-25	; 0xffffffe7
    1aec:	0d058201 	sfmeq	f0, 1, [r5, #-4]
    1af0:	0015054c 	andseq	r0, r5, ip, asr #10
    1af4:	4a010402 	bmi	42b04 <__bss_end+0x36a0c>
    1af8:	05831005 	streq	r1, [r3, #5]
    1afc:	09052e11 	stmdbeq	r5, {r0, r4, r9, sl, fp, sp}
    1b00:	00190566 	andseq	r0, r9, r6, ror #10
    1b04:	4b020402 	blmi	82b14 <__bss_end+0x76a1c>
    1b08:	02001a05 	andeq	r1, r0, #20480	; 0x5000
    1b0c:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
    1b10:	0402000f 	streq	r0, [r2], #-15
    1b14:	11054a02 	tstne	r5, r2, lsl #20
    1b18:	02040200 	andeq	r0, r4, #0, 4
    1b1c:	001a0582 	andseq	r0, sl, r2, lsl #11
    1b20:	4a020402 	bmi	82b30 <__bss_end+0x76a38>
    1b24:	02001305 	andeq	r1, r0, #335544320	; 0x14000000
    1b28:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
    1b2c:	04020005 	streq	r0, [r2], #-5
    1b30:	1b052c02 	blne	14cb40 <__bss_end+0x140a48>
    1b34:	310a0583 	smlabbcc	sl, r3, r5, r0
    1b38:	052e0b05 	streq	r0, [lr, #-2821]!	; 0xfffff4fb
    1b3c:	0c054a0d 			; <UNDEFINED> instruction: 0x0c054a0d
    1b40:	3001054b 	andcc	r0, r1, fp, asr #10
    1b44:	9f08056a 	svcls	0x0008056a
    1b48:	054c0b05 	strbeq	r0, [ip, #-2821]	; 0xfffff4fb
    1b4c:	04020014 	streq	r0, [r2], #-20	; 0xffffffec
    1b50:	07054a03 	streq	r4, [r5, -r3, lsl #20]
    1b54:	02040200 	andeq	r0, r4, #0, 4
    1b58:	00080583 	andeq	r0, r8, r3, lsl #11
    1b5c:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
    1b60:	02000a05 	andeq	r0, r0, #20480	; 0x5000
    1b64:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
    1b68:	04020002 	streq	r0, [r2], #-2
    1b6c:	01054902 	tsteq	r5, r2, lsl #18
    1b70:	0e058584 	cfsh32eq	mvfx8, mvfx5, #-60
    1b74:	4b0805bb 	blmi	203268 <__bss_end+0x1f7170>
    1b78:	054c0b05 	strbeq	r0, [ip, #-2821]	; 0xfffff4fb
    1b7c:	04020014 	streq	r0, [r2], #-20	; 0xffffffec
    1b80:	16054a03 	strne	r4, [r5], -r3, lsl #20
    1b84:	02040200 	andeq	r0, r4, #0, 4
    1b88:	00170583 	andseq	r0, r7, r3, lsl #11
    1b8c:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
    1b90:	02000a05 	andeq	r0, r0, #20480	; 0x5000
    1b94:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
    1b98:	0402000b 	streq	r0, [r2], #-11
    1b9c:	17052e02 	strne	r2, [r5, -r2, lsl #28]
    1ba0:	02040200 	andeq	r0, r4, #0, 4
    1ba4:	000d054a 	andeq	r0, sp, sl, asr #10
    1ba8:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
    1bac:	02000205 	andeq	r0, r0, #1342177280	; 0x50000000
    1bb0:	052d0204 	streq	r0, [sp, #-516]!	; 0xfffffdfc
    1bb4:	05878401 	streq	r8, [r7, #1025]	; 0x401
    1bb8:	10059f09 	andne	r9, r5, r9, lsl #30
    1bbc:	6613054b 	ldrvs	r0, [r3], -fp, asr #10
    1bc0:	05bb1005 	ldreq	r1, [fp, #5]!
    1bc4:	0c058105 	stfeqd	f0, [r5], {5}
    1bc8:	2f010531 	svccs	0x00010531
    1bcc:	a20a0586 	andge	r0, sl, #562036736	; 0x21800000
    1bd0:	05670505 	strbeq	r0, [r7, #-1285]!	; 0xfffffafb
    1bd4:	0b05840e 	bleq	162c14 <__bss_end+0x156b1c>
    1bd8:	690d0567 	stmdbvs	sp, {r0, r1, r2, r5, r6, r8, sl}
    1bdc:	9f4b0c05 	svcls	0x004b0c05
    1be0:	05670d05 	strbeq	r0, [r7, #-3333]!	; 0xfffff2fb
    1be4:	15056917 	strne	r6, [r5, #-2327]	; 0xfffff6e9
    1be8:	4a2d0566 	bmi	b43188 <__bss_end+0xb37090>
    1bec:	02003d05 	andeq	r3, r0, #320	; 0x140
    1bf0:	05660104 	strbeq	r0, [r6, #-260]!	; 0xfffffefc
    1bf4:	0402003b 	streq	r0, [r2], #-59	; 0xffffffc5
    1bf8:	2d056601 	stccs	6, cr6, [r5, #-4]
    1bfc:	01040200 	mrseq	r0, R12_usr
    1c00:	682b054a 	stmdavs	fp!, {r1, r3, r6, r8, sl}
    1c04:	054a1c05 	strbeq	r1, [sl, #-3077]	; 0xfffff3fb
    1c08:	11058215 	tstne	r5, r5, lsl r2
    1c0c:	6710052e 	ldrvs	r0, [r0, -lr, lsr #10]
    1c10:	7d0505a0 	cfstr32vc	mvfx0, [r5, #-640]	; 0xfffffd80
    1c14:	09031605 	stmdbeq	r3, {r0, r2, r9, sl, ip}
    1c18:	d61b052e 	ldrle	r0, [fp], -lr, lsr #10
    1c1c:	054a1105 	strbeq	r1, [sl, #-261]	; 0xfffffefb
    1c20:	04020026 	streq	r0, [r2], #-38	; 0xffffffda
    1c24:	0b05ba03 	bleq	170438 <__bss_end+0x164340>
    1c28:	02040200 	andeq	r0, r4, #0, 4
    1c2c:	0005059f 	muleq	r5, pc, r5	; <UNPREDICTABLE>
    1c30:	81020402 	tsthi	r2, r2, lsl #8
    1c34:	05f50e05 	ldrbeq	r0, [r5, #3589]!	; 0xe05
    1c38:	0c054b15 			; <UNDEFINED> instruction: 0x0c054b15
    1c3c:	0505d766 	streq	sp, [r5, #-1894]	; 0xfffff89a
    1c40:	840f059f 	strhi	r0, [pc], #-1439	; 1c48 <shift+0x1c48>
    1c44:	05d71105 	ldrbeq	r1, [r7, #261]	; 0x105
    1c48:	1805d90c 	stmdane	r5, {r2, r3, r8, fp, ip, lr, pc}
    1c4c:	01040200 	mrseq	r0, R12_usr
    1c50:	6809054a 	stmdavs	r9, {r1, r3, r6, r8, sl}
    1c54:	059f1005 	ldreq	r1, [pc, #5]	; 1c61 <shift+0x1c61>
    1c58:	0e056612 	mcreq	6, 0, r6, cr5, cr2, {0}
    1c5c:	9f100567 	svcls	0x00100567
    1c60:	05661205 	strbeq	r1, [r6, #-517]!	; 0xfffffdfb
    1c64:	1d05670e 	stcne	7, cr6, [r5, #-56]	; 0xffffffc8
    1c68:	01040200 	mrseq	r0, R12_usr
    1c6c:	67100582 	ldrvs	r0, [r0, -r2, lsl #11]
    1c70:	05661205 	strbeq	r1, [r6, #-517]!	; 0xfffffdfb
    1c74:	2205691c 	andcs	r6, r5, #28, 18	; 0x70000
    1c78:	2e100582 	cdpcs	5, 1, cr0, cr0, cr2, {4}
    1c7c:	05662205 	strbeq	r2, [r6, #-517]!	; 0xfffffdfb
    1c80:	14054a12 	strne	r4, [r5], #-2578	; 0xfffff5ee
    1c84:	0005052f 	andeq	r0, r5, pc, lsr #10
    1c88:	03020402 	movweq	r0, #9218	; 0x2402
    1c8c:	0105d675 	tsteq	r5, r5, ror r6
    1c90:	029e0e03 	addseq	r0, lr, #3, 28	; 0x30
    1c94:	0101000a 	tsteq	r1, sl
    1c98:	00000079 	andeq	r0, r0, r9, ror r0
    1c9c:	00460003 	subeq	r0, r6, r3
    1ca0:	01020000 	mrseq	r0, (UNDEF: 2)
    1ca4:	000d0efb 	strdeq	r0, [sp], -fp
    1ca8:	01010101 	tsteq	r1, r1, lsl #2
    1cac:	01000000 	mrseq	r0, (UNDEF: 0)
    1cb0:	2e010000 	cdpcs	0, 0, cr0, cr1, cr0, {0}
    1cb4:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1cb8:	2f2e2e2f 	svccs	0x002e2e2f
    1cbc:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1cc0:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1cc4:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
    1cc8:	2f636367 	svccs	0x00636367
    1ccc:	666e6f63 	strbtvs	r6, [lr], -r3, ror #30
    1cd0:	612f6769 			; <UNDEFINED> instruction: 0x612f6769
    1cd4:	00006d72 	andeq	r6, r0, r2, ror sp
    1cd8:	3162696c 	cmncc	r2, ip, ror #18
    1cdc:	636e7566 	cmnvs	lr, #427819008	; 0x19800000
    1ce0:	00532e73 	subseq	r2, r3, r3, ror lr
    1ce4:	00000001 	andeq	r0, r0, r1
    1ce8:	bc020500 	cfstr32lt	mvfx0, [r2], {-0}
    1cec:	030000b3 	movweq	r0, #179	; 0xb3
    1cf0:	300108cf 	andcc	r0, r1, pc, asr #17
    1cf4:	2f2f2f2f 	svccs	0x002f2f2f
    1cf8:	d002302f 	andle	r3, r2, pc, lsr #32
    1cfc:	312f1401 			; <UNDEFINED> instruction: 0x312f1401
    1d00:	4c302f2f 	ldcmi	15, cr2, [r0], #-188	; 0xffffff44
    1d04:	1f03322f 	svcne	0x0003322f
    1d08:	2f2f2f66 	svccs	0x002f2f66
    1d0c:	2f2f2f2f 	svccs	0x002f2f2f
    1d10:	01000202 	tsteq	r0, r2, lsl #4
    1d14:	00008501 	andeq	r8, r0, r1, lsl #10
    1d18:	46000300 	strmi	r0, [r0], -r0, lsl #6
    1d1c:	02000000 	andeq	r0, r0, #0
    1d20:	0d0efb01 	vstreq	d15, [lr, #-4]
    1d24:	01010100 	mrseq	r0, (UNDEF: 17)
    1d28:	00000001 	andeq	r0, r0, r1
    1d2c:	01000001 	tsteq	r0, r1
    1d30:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1d34:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1d38:	2f2e2e2f 	svccs	0x002e2e2f
    1d3c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1d40:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
    1d44:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    1d48:	6e6f632f 	cdpvs	3, 6, cr6, cr15, cr15, {1}
    1d4c:	2f676966 	svccs	0x00676966
    1d50:	006d7261 	rsbeq	r7, sp, r1, ror #4
    1d54:	62696c00 	rsbvs	r6, r9, #0, 24
    1d58:	6e756631 	mrcvs	6, 3, r6, cr5, cr1, {1}
    1d5c:	532e7363 			; <UNDEFINED> instruction: 0x532e7363
    1d60:	00000100 	andeq	r0, r0, r0, lsl #2
    1d64:	02050000 	andeq	r0, r5, #0
    1d68:	0000b5c8 	andeq	fp, r0, r8, asr #11
    1d6c:	010a9003 	tsteq	sl, r3
    1d70:	2f30302f 	svccs	0x0030302f
    1d74:	2f302f2f 	svccs	0x00302f2f
    1d78:	302f2f2f 	eorcc	r2, pc, pc, lsr #30
    1d7c:	1401d002 	strne	sp, [r1], #-2
    1d80:	30302f30 	eorscc	r2, r0, r0, lsr pc
    1d84:	2f30312f 	svccs	0x0030312f
    1d88:	2f4c302f 	svccs	0x004c302f
    1d8c:	03322f30 	teqeq	r2, #48, 30	; 0xc0
    1d90:	2f2f821f 	svccs	0x002f821f
    1d94:	2f2f2f2f 	svccs	0x002f2f2f
    1d98:	0002022f 	andeq	r0, r2, pc, lsr #4
    1d9c:	005c0101 	subseq	r0, ip, r1, lsl #2
    1da0:	00030000 	andeq	r0, r3, r0
    1da4:	00000046 	andeq	r0, r0, r6, asr #32
    1da8:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
    1dac:	0101000d 	tsteq	r1, sp
    1db0:	00000101 	andeq	r0, r0, r1, lsl #2
    1db4:	00000100 	andeq	r0, r0, r0, lsl #2
    1db8:	2f2e2e01 	svccs	0x002e2e01
    1dbc:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1dc0:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1dc4:	2f2e2e2f 	svccs	0x002e2e2f
    1dc8:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; 1d18 <shift+0x1d18>
    1dcc:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    1dd0:	6f632f63 	svcvs	0x00632f63
    1dd4:	6769666e 	strbvs	r6, [r9, -lr, ror #12]!
    1dd8:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
    1ddc:	696c0000 	stmdbvs	ip!, {}^	; <UNPREDICTABLE>
    1de0:	75663162 	strbvc	r3, [r6, #-354]!	; 0xfffffe9e
    1de4:	2e73636e 	cdpcs	3, 7, cr6, cr3, cr14, {3}
    1de8:	00010053 	andeq	r0, r1, r3, asr r0
    1dec:	05000000 	streq	r0, [r0, #-0]
    1df0:	00b80802 	adcseq	r0, r8, r2, lsl #16
    1df4:	0bb90300 	bleq	fee429fc <__bss_end+0xfee36904>
    1df8:	00020201 	andeq	r0, r2, r1, lsl #4
    1dfc:	00fb0101 	rscseq	r0, fp, r1, lsl #2
    1e00:	00030000 	andeq	r0, r3, r0
    1e04:	00000047 	andeq	r0, r0, r7, asr #32
    1e08:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
    1e0c:	0101000d 	tsteq	r1, sp
    1e10:	00000101 	andeq	r0, r0, r1, lsl #2
    1e14:	00000100 	andeq	r0, r0, r0, lsl #2
    1e18:	2f2e2e01 	svccs	0x002e2e01
    1e1c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1e20:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1e24:	2f2e2e2f 	svccs	0x002e2e2f
    1e28:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; 1d78 <shift+0x1d78>
    1e2c:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    1e30:	6f632f63 	svcvs	0x00632f63
    1e34:	6769666e 	strbvs	r6, [r9, -lr, ror #12]!
    1e38:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
    1e3c:	65690000 	strbvs	r0, [r9, #-0]!
    1e40:	35376565 	ldrcc	r6, [r7, #-1381]!	; 0xfffffa9b
    1e44:	66732d34 			; <UNDEFINED> instruction: 0x66732d34
    1e48:	0100532e 	tsteq	r0, lr, lsr #6
    1e4c:	00000000 	andeq	r0, r0, r0
    1e50:	b80c0205 	stmdalt	ip, {r0, r2, r9}
    1e54:	3a030000 	bcc	c1e5c <__bss_end+0xb5d64>
    1e58:	03332f01 	teqeq	r3, #1, 30
    1e5c:	2f302e09 	svccs	0x00302e09
    1e60:	322f2f2f 	eorcc	r2, pc, #47, 30	; 0xbc
    1e64:	2f2f302f 	svccs	0x002f302f
    1e68:	3033302f 	eorscc	r3, r3, pc, lsr #32
    1e6c:	302f2f31 	eorcc	r2, pc, r1, lsr pc	; <UNPREDICTABLE>
    1e70:	302f2f2f 	eorcc	r2, pc, pc, lsr #30
    1e74:	32322f32 	eorscc	r2, r2, #50, 30	; 0xc8
    1e78:	2f312f2f 	svccs	0x00312f2f
    1e7c:	2f332f33 	svccs	0x00332f33
    1e80:	2f312f2f 	svccs	0x00312f2f
    1e84:	352f312f 	strcc	r3, [pc, #-303]!	; 1d5d <shift+0x1d5d>
    1e88:	2f2f302f 	svccs	0x002f302f
    1e8c:	302f2f32 	eorcc	r2, pc, r2, lsr pc	; <UNPREDICTABLE>
    1e90:	2e19032f 	cdpcs	3, 1, cr0, cr9, cr15, {1}
    1e94:	352f2f2f 	strcc	r2, [pc, #-3887]!	; f6d <shift+0xf6d>
    1e98:	30342f2f 	eorscc	r2, r4, pc, lsr #30
    1e9c:	2f302f33 	svccs	0x00302f33
    1ea0:	30312f2f 	eorscc	r2, r1, pc, lsr #30
    1ea4:	2f302f30 	svccs	0x00302f30
    1ea8:	302f3031 	eorcc	r3, pc, r1, lsr r0	; <UNPREDICTABLE>
    1eac:	2f312f32 	svccs	0x00312f32
    1eb0:	2f2f302f 	svccs	0x002f302f
    1eb4:	322f2f30 	eorcc	r2, pc, #48, 30	; 0xc0
    1eb8:	09032f2f 	stmdbeq	r3, {r0, r1, r2, r3, r5, r8, r9, sl, fp, sp}
    1ebc:	2f2f302e 	svccs	0x002f302e
    1ec0:	2f2f302f 	svccs	0x002f302f
    1ec4:	2e0d032f 	cdpcs	3, 0, cr0, cr13, cr15, {1}
    1ec8:	3030332f 	eorscc	r3, r0, pc, lsr #6
    1ecc:	30313130 	eorscc	r3, r1, r0, lsr r1
    1ed0:	2e0c032f 	cdpcs	3, 0, cr0, cr12, cr15, {1}
    1ed4:	332f3030 			; <UNDEFINED> instruction: 0x332f3030
    1ed8:	332f3030 			; <UNDEFINED> instruction: 0x332f3030
    1edc:	2f30312f 	svccs	0x0030312f
    1ee0:	2f30312f 	svccs	0x0030312f
    1ee4:	2f2e1903 	svccs	0x002e1903
    1ee8:	2f302f32 	svccs	0x00302f32
    1eec:	302f2f2f 	eorcc	r2, pc, pc, lsr #30
    1ef0:	2f2f302f 	svccs	0x002f302f
    1ef4:	2f302f2f 	svccs	0x00302f2f
    1ef8:	01000202 	tsteq	r0, r2, lsl #4
    1efc:	00007a01 	andeq	r7, r0, r1, lsl #20
    1f00:	42000300 	andmi	r0, r0, #0, 6
    1f04:	02000000 	andeq	r0, r0, #0
    1f08:	0d0efb01 	vstreq	d15, [lr, #-4]
    1f0c:	01010100 	mrseq	r0, (UNDEF: 17)
    1f10:	00000001 	andeq	r0, r0, r1
    1f14:	01000001 	tsteq	r0, r1
    1f18:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1f1c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1f20:	2f2e2e2f 	svccs	0x002e2e2f
    1f24:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1f28:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
    1f2c:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    1f30:	6e6f632f 	cdpvs	3, 6, cr6, cr15, cr15, {1}
    1f34:	2f676966 	svccs	0x00676966
    1f38:	006d7261 	rsbeq	r7, sp, r1, ror #4
    1f3c:	61706200 	cmnvs	r0, r0, lsl #4
    1f40:	532e6962 			; <UNDEFINED> instruction: 0x532e6962
    1f44:	00000100 	andeq	r0, r0, r0, lsl #2
    1f48:	02050000 	andeq	r0, r5, #0
    1f4c:	0000ba5c 	andeq	fp, r0, ip, asr sl
    1f50:	0101b903 	tsteq	r1, r3, lsl #18
    1f54:	2f4b5a08 	svccs	0x004b5a08
    1f58:	30302f2f 	eorscc	r2, r0, pc, lsr #30
    1f5c:	2f2f3267 	svccs	0x002f3267
    1f60:	6730302f 	ldrvs	r3, [r0, -pc, lsr #32]!
    1f64:	2f2f2f2f 	svccs	0x002f2f2f
    1f68:	30302f32 	eorscc	r2, r0, r2, lsr pc
    1f6c:	322f2f67 	eorcc	r2, pc, #412	; 0x19c
    1f70:	672f302f 	strvs	r3, [pc, -pc, lsr #32]!
    1f74:	02022f2f 	andeq	r2, r2, #47, 30	; 0xbc
    1f78:	a4010100 	strge	r0, [r1], #-256	; 0xffffff00
    1f7c:	03000000 	movweq	r0, #0
    1f80:	00009e00 	andeq	r9, r0, r0, lsl #28
    1f84:	fb010200 	blx	4278e <__bss_end+0x36696>
    1f88:	01000d0e 	tsteq	r0, lr, lsl #26
    1f8c:	00010101 	andeq	r0, r1, r1, lsl #2
    1f90:	00010000 	andeq	r0, r1, r0
    1f94:	2e2e0100 	sufcse	f0, f6, f0
    1f98:	2f2e2e2f 	svccs	0x002e2e2f
    1f9c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1fa0:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1fa4:	672f2e2f 	strvs	r2, [pc, -pc, lsr #28]!
    1fa8:	2e006363 	cdpcs	3, 0, cr6, cr0, cr3, {3}
    1fac:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1fb0:	2f2e2e2f 	svccs	0x002e2e2f
    1fb4:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1fb8:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1fbc:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
    1fc0:	2f636367 	svccs	0x00636367
    1fc4:	672f2e2e 	strvs	r2, [pc, -lr, lsr #28]!
    1fc8:	632f6363 			; <UNDEFINED> instruction: 0x632f6363
    1fcc:	69666e6f 	stmdbvs	r6!, {r0, r1, r2, r3, r5, r6, r9, sl, fp, sp, lr}^
    1fd0:	72612f67 	rsbvc	r2, r1, #412	; 0x19c
    1fd4:	2e2e006d 	cdpcs	0, 2, cr0, cr14, cr13, {3}
    1fd8:	2f2e2e2f 	svccs	0x002e2e2f
    1fdc:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1fe0:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1fe4:	2f2e2e2f 	svccs	0x002e2e2f
    1fe8:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    1fec:	00006363 	andeq	r6, r0, r3, ror #6
    1ff0:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
    1ff4:	2e617369 	cdpcs	3, 6, cr7, cr1, cr9, {3}
    1ff8:	00010068 	andeq	r0, r1, r8, rrx
    1ffc:	6d726100 	ldfvse	f6, [r2, #-0]
    2000:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
    2004:	62670000 	rsbvs	r0, r7, #0
    2008:	74632d6c 	strbtvc	r2, [r3], #-3436	; 0xfffff294
    200c:	2e73726f 	cdpcs	2, 7, cr7, cr3, cr15, {3}
    2010:	00030068 	andeq	r0, r3, r8, rrx
    2014:	62696c00 	rsbvs	r6, r9, #0, 24
    2018:	32636367 	rsbcc	r6, r3, #-1677721599	; 0x9c000001
    201c:	0300632e 	movweq	r6, #814	; 0x32e
    2020:	a7000000 	strge	r0, [r0, -r0]
    2024:	03000000 	movweq	r0, #0
    2028:	00006800 	andeq	r6, r0, r0, lsl #16
    202c:	fb010200 	blx	42836 <__bss_end+0x3673e>
    2030:	01000d0e 	tsteq	r0, lr, lsl #26
    2034:	00010101 	andeq	r0, r1, r1, lsl #2
    2038:	00010000 	andeq	r0, r1, r0
    203c:	2e2e0100 	sufcse	f0, f6, f0
    2040:	2f2e2e2f 	svccs	0x002e2e2f
    2044:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    2048:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    204c:	2f2e2e2f 	svccs	0x002e2e2f
    2050:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    2054:	2e006363 	cdpcs	3, 0, cr6, cr0, cr3, {3}
    2058:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    205c:	2f2e2e2f 	svccs	0x002e2e2f
    2060:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    2064:	2f2e2f2e 	svccs	0x002e2f2e
    2068:	00636367 	rsbeq	r6, r3, r7, ror #6
    206c:	62696c00 	rsbvs	r6, r9, #0, 24
    2070:	32636367 	rsbcc	r6, r3, #-1677721599	; 0x9c000001
    2074:	0100632e 	tsteq	r0, lr, lsr #6
    2078:	72610000 	rsbvc	r0, r1, #0
    207c:	73692d6d 	cmnvc	r9, #6976	; 0x1b40
    2080:	00682e61 	rsbeq	r2, r8, r1, ror #28
    2084:	6c000002 	stcvs	0, cr0, [r0], {2}
    2088:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    208c:	682e3263 	stmdavs	lr!, {r0, r1, r5, r6, r9, ip, sp}
    2090:	00000100 	andeq	r0, r0, r0, lsl #2
    2094:	00010500 	andeq	r0, r1, r0, lsl #10
    2098:	bb300205 	bllt	c028b4 <__bss_end+0xbf67bc>
    209c:	f9030000 			; <UNDEFINED> instruction: 0xf9030000
    20a0:	0305010b 	movweq	r0, #20747	; 0x510b
    20a4:	06010513 			; <UNDEFINED> instruction: 0x06010513
    20a8:	2f060511 	svccs	0x00060511
    20ac:	68060305 	stmdavs	r6, {r0, r2, r8, r9}
    20b0:	01060a05 	tsteq	r6, r5, lsl #20
    20b4:	2d060505 	cfstr32cs	mvfx0, [r6, #-20]	; 0xffffffec
    20b8:	01060e05 	tsteq	r6, r5, lsl #28
    20bc:	052c0105 	streq	r0, [ip, #-261]!	; 0xfffffefb
    20c0:	052e300e 	streq	r3, [lr, #-14]!
    20c4:	01052e0c 	tsteq	r5, ip, lsl #28
    20c8:	0002024c 	andeq	r0, r2, ip, asr #4
    20cc:	00b60101 	adcseq	r0, r6, r1, lsl #2
    20d0:	00030000 	andeq	r0, r3, r0
    20d4:	00000068 	andeq	r0, r0, r8, rrx
    20d8:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
    20dc:	0101000d 	tsteq	r1, sp
    20e0:	00000101 	andeq	r0, r0, r1, lsl #2
    20e4:	00000100 	andeq	r0, r0, r0, lsl #2
    20e8:	2f2e2e01 	svccs	0x002e2e01
    20ec:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    20f0:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    20f4:	2f2e2e2f 	svccs	0x002e2e2f
    20f8:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; 2048 <shift+0x2048>
    20fc:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    2100:	2e2e0063 	cdpcs	0, 2, cr0, cr14, cr3, {3}
    2104:	2f2e2e2f 	svccs	0x002e2e2f
    2108:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    210c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    2110:	672f2e2f 	strvs	r2, [pc, -pc, lsr #28]!
    2114:	00006363 	andeq	r6, r0, r3, ror #6
    2118:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    211c:	2e326363 	cdpcs	3, 3, cr6, cr2, cr3, {3}
    2120:	00010063 	andeq	r0, r1, r3, rrx
    2124:	6d726100 	ldfvse	f6, [r2, #-0]
    2128:	6173692d 	cmnvs	r3, sp, lsr #18
    212c:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
    2130:	696c0000 	stmdbvs	ip!, {}^	; <UNPREDICTABLE>
    2134:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    2138:	00682e32 	rsbeq	r2, r8, r2, lsr lr
    213c:	00000001 	andeq	r0, r0, r1
    2140:	05000105 	streq	r0, [r0, #-261]	; 0xfffffefb
    2144:	00bb6002 	adcseq	r6, fp, r2
    2148:	0bb90300 	bleq	fee42d50 <__bss_end+0xfee36c58>
    214c:	17030501 	strne	r0, [r3, -r1, lsl #10]
    2150:	01061005 	tsteq	r6, r5
    2154:	05331905 	ldreq	r1, [r3, #-2309]!	; 0xfffff6fb
    2158:	10053327 	andne	r3, r5, r7, lsr #6
    215c:	052e7603 	streq	r7, [lr, #-1539]!	; 0xfffff9fd
    2160:	05330603 	ldreq	r0, [r3, #-1539]!	; 0xfffff9fd
    2164:	05010619 	streq	r0, [r1, #-1561]	; 0xfffff9e7
    2168:	03052e10 	movweq	r2, #24080	; 0x5e10
    216c:	05153306 	ldreq	r3, [r5, #-774]	; 0xfffffcfa
    2170:	050f061b 	streq	r0, [pc, #-1563]	; 1b5d <shift+0x1b5d>
    2174:	2e2b0301 	cdpcs	3, 2, cr0, cr11, cr1, {0}
    2178:	55031905 	strpl	r1, [r3, #-2309]	; 0xfffff6fb
    217c:	0301052e 	movweq	r0, #5422	; 0x152e
    2180:	024a2e2b 	subeq	r2, sl, #688	; 0x2b0
    2184:	0101000a 	tsteq	r1, sl
    2188:	00000169 	andeq	r0, r0, r9, ror #2
    218c:	00680003 	rsbeq	r0, r8, r3
    2190:	01020000 	mrseq	r0, (UNDEF: 2)
    2194:	000d0efb 	strdeq	r0, [sp], -fp
    2198:	01010101 	tsteq	r1, r1, lsl #2
    219c:	01000000 	mrseq	r0, (UNDEF: 0)
    21a0:	2e010000 	cdpcs	0, 0, cr0, cr1, cr0, {0}
    21a4:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    21a8:	2f2e2e2f 	svccs	0x002e2e2f
    21ac:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    21b0:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    21b4:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
    21b8:	00636367 	rsbeq	r6, r3, r7, ror #6
    21bc:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    21c0:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    21c4:	2f2e2e2f 	svccs	0x002e2e2f
    21c8:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    21cc:	6363672f 	cmnvs	r3, #12320768	; 0xbc0000
    21d0:	696c0000 	stmdbvs	ip!, {}^	; <UNPREDICTABLE>
    21d4:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    21d8:	00632e32 	rsbeq	r2, r3, r2, lsr lr
    21dc:	61000001 	tstvs	r0, r1
    21e0:	692d6d72 	pushvs	{r1, r4, r5, r6, r8, sl, fp, sp, lr}
    21e4:	682e6173 	stmdavs	lr!, {r0, r1, r4, r5, r6, r8, sp, lr}
    21e8:	00000200 	andeq	r0, r0, r0, lsl #4
    21ec:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    21f0:	2e326363 	cdpcs	3, 3, cr6, cr2, cr3, {3}
    21f4:	00010068 	andeq	r0, r1, r8, rrx
    21f8:	01050000 	mrseq	r0, (UNDEF: 5)
    21fc:	a0020500 	andge	r0, r2, r0, lsl #10
    2200:	030000bb 	movweq	r0, #187	; 0xbb
    2204:	050107b3 	streq	r0, [r1, #-1971]	; 0xfffff84d
    2208:	03131303 	tsteq	r3, #201326592	; 0xc000000
    220c:	0605010a 	streq	r0, [r5], -sl, lsl #2
    2210:	01050106 	tsteq	r5, r6, lsl #2
    2214:	054a7403 	strbeq	r7, [sl, #-1027]	; 0xfffffbfd
    2218:	01052f0b 	tsteq	r5, fp, lsl #30
    221c:	2f0b052d 	svccs	0x000b052d
    2220:	0b030605 	bleq	c3a3c <__bss_end+0xb7944>
    2224:	0607052e 	streq	r0, [r7], -lr, lsr #10
    2228:	060d0530 			; <UNDEFINED> instruction: 0x060d0530
    222c:	06070501 	streq	r0, [r7], -r1, lsl #10
    2230:	060d0583 	streq	r0, [sp], -r3, lsl #11
    2234:	07054a01 	streq	r4, [r5, -r1, lsl #20]
    2238:	09054c06 	stmdbeq	r5, {r1, r2, sl, fp, lr}
    223c:	07050106 	streq	r0, [r5, -r6, lsl #2]
    2240:	09052f06 	stmdbeq	r5, {r1, r2, r8, r9, sl, fp, sp}
    2244:	052e0106 	streq	r0, [lr, #-262]!	; 0xfffffefa
    2248:	05a50607 	streq	r0, [r5, #1543]!	; 0x607
    224c:	2e01060a 	cfmadd32cs	mvax0, mvfx0, mvfx1, mvfx10
    2250:	68030b05 	stmdavs	r3, {r0, r2, r8, r9, fp}
    2254:	030a052e 	movweq	r0, #42286	; 0xa52e
    2258:	04054a18 	streq	r4, [r5], #-2584	; 0xfffff5e8
    225c:	06053006 	streq	r3, [r5], -r6
    2260:	2f491306 	svccs	0x00491306
    2264:	06040549 	streq	r0, [r4], -r9, asr #10
    2268:	1507052f 	strne	r0, [r7, #-1327]	; 0xfffffad1
    226c:	01060a05 	tsteq	r6, r5, lsl #20
    2270:	4c060405 	cfstrsmi	mvf0, [r6], {5}
    2274:	01060605 	tsteq	r6, r5, lsl #12
    2278:	0604052e 	streq	r0, [r4], -lr, lsr #10
    227c:	0606054e 	streq	r0, [r6], -lr, asr #10
    2280:	520b050e 	andpl	r0, fp, #58720256	; 0x3800000
    2284:	054a1005 	strbeq	r1, [sl, #-5]
    2288:	052e4a05 	streq	r4, [lr, #-2565]!	; 0xfffff5fb
    228c:	05310608 	ldreq	r0, [r1, #-1544]!	; 0xfffff9f8
    2290:	0605130e 	streq	r1, [r5], -lr, lsl #6
    2294:	052e0106 	streq	r0, [lr, #-262]!	; 0xfffffefa
    2298:	79030604 	stmdbvc	r3, {r2, r9, sl}
    229c:	1408052e 	strne	r0, [r8], #-1326	; 0xfffffad2
    22a0:	14130305 	ldrne	r0, [r3], #-773	; 0xfffffcfb
    22a4:	0f060b05 	svceq	0x00060b05
    22a8:	2e690505 	cdpcs	5, 6, cr0, cr9, cr5, {0}
    22ac:	2f060805 	svccs	0x00060805
    22b0:	05130e05 	ldreq	r0, [r3, #-3589]	; 0xfffff1fb
    22b4:	2e010606 	cfmadd32cs	mvax0, mvfx0, mvfx1, mvfx6
    22b8:	32060405 	andcc	r0, r6, #83886080	; 0x5000000
    22bc:	01060605 	tsteq	r6, r5, lsl #12
    22c0:	0405492f 	streq	r4, [r5], #-2351	; 0xfffff6d1
    22c4:	06052f06 	streq	r2, [r5], -r6, lsl #30
    22c8:	04050106 	streq	r0, [r5], #-262	; 0xfffffefa
    22cc:	0f054b06 	svceq	0x00054b06
    22d0:	054a0106 	strbeq	r0, [sl, #-262]	; 0xfffffefa
    22d4:	052e4a06 	streq	r4, [lr, #-2566]!	; 0xfffff5fa
    22d8:	05320603 	ldreq	r0, [r2, #-1539]!	; 0xfffff9fd
    22dc:	05010606 	streq	r0, [r1, #-1542]	; 0xfffff9fa
    22e0:	052f0605 	streq	r0, [pc, #-1541]!	; 1ce3 <shift+0x1ce3>
    22e4:	05010609 	streq	r0, [r1, #-1545]	; 0xfffff9f7
    22e8:	052f0603 	streq	r0, [pc, #-1539]!	; 1ced <shift+0x1ced>
    22ec:	2e130601 	cfmsub32cs	mvax0, mvfx0, mvfx3, mvfx1
    22f0:	01000402 	tsteq	r0, r2, lsl #8
    22f4:	0001db01 	andeq	sp, r1, r1, lsl #22
    22f8:	c2000300 	andgt	r0, r0, #0, 6
    22fc:	02000000 	andeq	r0, r0, #0
    2300:	0d0efb01 	vstreq	d15, [lr, #-4]
    2304:	01010100 	mrseq	r0, (UNDEF: 17)
    2308:	00000001 	andeq	r0, r0, r1
    230c:	01000001 	tsteq	r0, r1
    2310:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    2314:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    2318:	2f2e2e2f 	svccs	0x002e2e2f
    231c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    2320:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    2324:	2f2e2e2f 	svccs	0x002e2e2f
    2328:	6c77656e 	cfldr64vs	mvdx6, [r7], #-440	; 0xfffffe48
    232c:	6c2f6269 	sfmvs	f6, 4, [pc], #-420	; 2190 <shift+0x2190>
    2330:	2f636269 	svccs	0x00636269
    2334:	69727473 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
    2338:	2f00676e 	svccs	0x0000676e
    233c:	2f727375 	svccs	0x00727375
    2340:	2f62696c 	svccs	0x0062696c
    2344:	2f636367 	svccs	0x00636367
    2348:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
    234c:	656e6f6e 	strbvs	r6, [lr, #-3950]!	; 0xfffff092
    2350:	6261652d 	rsbvs	r6, r1, #188743680	; 0xb400000
    2354:	30312f69 	eorscc	r2, r1, r9, ror #30
    2358:	312e332e 			; <UNDEFINED> instruction: 0x312e332e
    235c:	636e692f 	cmnvs	lr, #770048	; 0xbc000
    2360:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
    2364:	75622f00 	strbvc	r2, [r2, #-3840]!	; 0xfffff100
    2368:	2f646c69 	svccs	0x00646c69
    236c:	6c77656e 	cfldr64vs	mvdx6, [r7], #-440	; 0xfffffe48
    2370:	702d6269 	eorvc	r6, sp, r9, ror #4
    2374:	64303342 	ldrtvs	r3, [r0], #-834	; 0xfffffcbe
    2378:	656e2f65 	strbvs	r2, [lr, #-3941]!	; 0xfffff09b
    237c:	62696c77 	rsbvs	r6, r9, #30464	; 0x7700
    2380:	332e332d 			; <UNDEFINED> instruction: 0x332e332d
    2384:	6e2f302e 	cdpvs	0, 2, cr3, cr15, cr14, {1}
    2388:	696c7765 	stmdbvs	ip!, {r0, r2, r5, r6, r8, r9, sl, ip, sp, lr}^
    238c:	696c2f62 	stmdbvs	ip!, {r1, r5, r6, r8, r9, sl, fp, sp}^
    2390:	692f6362 	stmdbvs	pc!, {r1, r5, r6, r8, r9, sp, lr}	; <UNPREDICTABLE>
    2394:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
    2398:	00006564 	andeq	r6, r0, r4, ror #10
    239c:	736d656d 	cmnvc	sp, #457179136	; 0x1b400000
    23a0:	632e7465 			; <UNDEFINED> instruction: 0x632e7465
    23a4:	00000100 	andeq	r0, r0, r0, lsl #2
    23a8:	64647473 	strbtvs	r7, [r4], #-1139	; 0xfffffb8d
    23ac:	682e6665 	stmdavs	lr!, {r0, r2, r5, r6, r9, sl, sp, lr}
    23b0:	00000200 	andeq	r0, r0, r0, lsl #4
    23b4:	69727473 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
    23b8:	682e676e 	stmdavs	lr!, {r1, r2, r3, r5, r6, r8, r9, sl, sp, lr}
    23bc:	00000300 	andeq	r0, r0, r0, lsl #6
    23c0:	00010500 	andeq	r0, r1, r0, lsl #10
    23c4:	bcc00205 	sfmlt	f0, 2, [r0], {5}
    23c8:	28030000 	stmdacs	r3, {}	; <UNPREDICTABLE>
    23cc:	13030501 	movwne	r0, #13569	; 0x3501
    23d0:	13131315 	tstne	r3, #1409286144	; 0x54000000
    23d4:	15060905 	strne	r0, [r6, #-2309]	; 0xfffff6fb
    23d8:	2e060305 	cdpcs	3, 0, cr0, cr6, cr5, {0}
    23dc:	05010905 	streq	r0, [r1, #-2309]	; 0xfffff6fb
    23e0:	0a053007 	beq	14e404 <__bss_end+0x14230c>
    23e4:	0c050106 	stfeqs	f0, [r5], {6}
    23e8:	2e0a052e 	cfsh32cs	mvfx0, mvfx10, #30
    23ec:	052f1005 	streq	r1, [pc, #-5]!	; 23ef <shift+0x23ef>
    23f0:	2e740309 	cdpcs	3, 7, cr0, cr4, cr9, {0}
    23f4:	0b030c05 	bleq	c5410 <__bss_end+0xb9318>
    23f8:	2e0a054a 	cfsh32cs	mvfx0, mvfx10, #42
    23fc:	4a060705 	bmi	184018 <__bss_end+0x177f20>
    2400:	05130905 	ldreq	r0, [r3, #-2309]	; 0xfffff6fb
    2404:	0501060e 	streq	r0, [r1, #-1550]	; 0xfffff9f2
    2408:	052b0609 	streq	r0, [fp, #-1545]!	; 0xfffff9f7
    240c:	06055203 	streq	r5, [r5], -r3, lsl #4
    2410:	01050106 	tsteq	r5, r6, lsl #2
    2414:	054a6e03 	strbeq	r6, [sl, #-3587]	; 0xfffff1fd
    2418:	07053510 	smladeq	r5, r0, r5, r3
    241c:	2e0e0306 	cdpcs	3, 0, cr0, cr14, cr6, {0}
    2420:	060e0516 			; <UNDEFINED> instruction: 0x060e0516
    2424:	06070501 	streq	r0, [r7], -r1, lsl #10
    2428:	060d052f 	streq	r0, [sp], -pc, lsr #10
    242c:	290e0517 	stmdbcs	lr, {r0, r1, r2, r4, r8, sl}
    2430:	2f060705 	svccs	0x00060705
    2434:	05011405 	streq	r1, [r1, #-1029]	; 0xfffffbfb
    2438:	2e06160d 	cfmadd32cs	mvax0, mvfx1, mvfx6, mvfx13
    243c:	bc060b05 			; <UNDEFINED> instruction: 0xbc060b05
    2440:	01061b05 	tsteq	r6, r5, lsl #22
    2444:	2f060b05 	svccs	0x00060b05
    2448:	01061b05 	tsteq	r6, r5, lsl #22
    244c:	2f060b05 	svccs	0x00060b05
    2450:	01061b05 	tsteq	r6, r5, lsl #22
    2454:	2f060b05 	svccs	0x00060b05
    2458:	01061b05 	tsteq	r6, r5, lsl #22
    245c:	2f060b05 	svccs	0x00060b05
    2460:	7a030d05 	bvc	c587c <__bss_end+0xb9784>
    2464:	052e0601 	streq	r0, [lr, #-1537]!	; 0xfffff9ff
    2468:	0d054f18 	stceq	15, cr4, [r5, #-96]	; 0xffffffa0
    246c:	2a180532 	bcs	60393c <__bss_end+0x5f7844>
    2470:	062f0d05 	strteq	r0, [pc], -r5, lsl #26
    2474:	2e2e0631 	mcrcs	6, 1, r0, cr14, cr1, {1}
    2478:	68060b05 	stmdavs	r6, {r0, r2, r8, r9, fp}
    247c:	01061b05 	tsteq	r6, r5, lsl #22
    2480:	2f060b05 	svccs	0x00060b05
    2484:	060f0d05 	streq	r0, [pc], -r5, lsl #26
    2488:	0609054d 	streq	r0, [r9], -sp, asr #10
    248c:	05010636 	streq	r0, [r1, #-1590]	; 0xfffff9ca
    2490:	4a5a0310 	bmi	16830d8 <__bss_end+0x1676fe0>
    2494:	0605052e 	streq	r0, [r5], -lr, lsr #10
    2498:	052e2703 	streq	r2, [lr, #-1795]!	; 0xfffff8fd
    249c:	0501060a 	streq	r0, [r1, #-1546]	; 0xfffff9f6
    24a0:	062d0609 	strteq	r0, [sp], -r9, lsl #12
    24a4:	06660601 	strbteq	r0, [r6], -r1, lsl #12
    24a8:	03100501 	tsteq	r0, #4194304	; 0x400000
    24ac:	052e4a5a 	streq	r4, [lr, #-2650]!	; 0xfffff5a6
    24b0:	27030605 	strcs	r0, [r3, -r5, lsl #12]
    24b4:	060a052e 	streq	r0, [sl], -lr, lsr #10
    24b8:	06090501 	streq	r0, [r9], -r1, lsl #10
    24bc:	0501062d 	streq	r0, [r1, #-1581]	; 0xfffff9d3
    24c0:	66710318 			; <UNDEFINED> instruction: 0x66710318
    24c4:	0309052e 	movweq	r0, #38190	; 0x952e
    24c8:	0d052e5d 	stceq	14, cr2, [r5, #-372]	; 0xfffffe8c
    24cc:	024a1e03 	subeq	r1, sl, #3, 28	; 0x30
    24d0:	01010004 	tsteq	r1, r4

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
      34:	fb0c0000 	blx	30003e <__bss_end+0x2f3f46>
      38:	2a000000 	bcs	40 <shift+0x40>
      3c:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
      40:	9c000080 	stcls	0, cr0, [r0], {128}	; 0x80
      44:	5a000000 	bpl	4c <shift+0x4c>
      48:	02000000 	andeq	r0, r0, #0
      4c:	0000012c 	andeq	r0, r0, ip, lsr #2
      50:	31150601 	tstcc	r5, r1, lsl #12
      54:	03000000 	movweq	r0, #0
      58:	1f980704 	svcne	0x00980704
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
     128:	00001f98 	muleq	r0, r8, pc	; <UNPREDICTABLE>
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
     174:	cb104801 	blgt	412180 <__bss_end+0x406088>
     178:	d4000000 	strle	r0, [r0], #-0
     17c:	58000081 	stmdapl	r0, {r0, r7}
     180:	01000000 	mrseq	r0, (UNDEF: 0)
     184:	0000cb9c 	muleq	r0, ip, fp
     188:	01800a00 	orreq	r0, r0, r0, lsl #20
     18c:	4a010000 	bmi	40194 <__bss_end+0x3409c>
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
     1d4:	5b0c0000 	blpl	3001dc <__bss_end+0x2f40e4>
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
     24c:	8b120f01 	blhi	483e58 <__bss_end+0x477d60>
     250:	0f000001 	svceq	0x00000001
     254:	0000019e 	muleq	r0, lr, r1
     258:	03231000 			; <UNDEFINED> instruction: 0x03231000
     25c:	0a010000 	beq	40264 <__bss_end+0x3416c>
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
     2b4:	8b140074 	blhi	50048c <__bss_end+0x4f4394>
     2b8:	a4000001 	strge	r0, [r0], #-1
     2bc:	38000080 	stmdacc	r0, {r7}
     2c0:	01000000 	mrseq	r0, (UNDEF: 0)
     2c4:	0067139c 	mlseq	r7, ip, r3, r1
     2c8:	9e2f0a01 	vmulls.f32	s0, s30, s2
     2cc:	02000001 	andeq	r0, r0, #1
     2d0:	00007491 	muleq	r0, r1, r4
     2d4:	000009e2 	andeq	r0, r0, r2, ror #19
     2d8:	01e00004 	mvneq	r0, r4
     2dc:	01040000 	mrseq	r0, (UNDEF: 4)
     2e0:	0000025e 	andeq	r0, r0, lr, asr r2
     2e4:	000b5a04 	andeq	r5, fp, r4, lsl #20
     2e8:	00002a00 	andeq	r2, r0, r0, lsl #20
	...
     2f4:	0001c200 	andeq	ip, r1, r0, lsl #4
     2f8:	08010200 	stmdaeq	r1, {r9}
     2fc:	00000860 	andeq	r0, r0, r0, ror #16
     300:	00002503 	andeq	r2, r0, r3, lsl #10
     304:	05020200 	streq	r0, [r2, #-512]	; 0xfffffe00
     308:	000008d9 	ldrdeq	r0, [r0], -r9
     30c:	69050404 	stmdbvs	r5, {r2, sl}
     310:	0300746e 	movweq	r7, #1134	; 0x46e
     314:	00000038 	andeq	r0, r0, r8, lsr r0
     318:	57080102 	strpl	r0, [r8, -r2, lsl #2]
     31c:	02000008 	andeq	r0, r0, #8
     320:	066a0702 	strbteq	r0, [sl], -r2, lsl #14
     324:	7f050000 	svcvc	0x00050000
     328:	0b000009 	bleq	354 <shift+0x354>
     32c:	00630709 	rsbeq	r0, r3, r9, lsl #14
     330:	52030000 	andpl	r0, r3, #0
     334:	02000000 	andeq	r0, r0, #0
     338:	1f980704 	svcne	0x00980704
     33c:	55060000 	strpl	r0, [r6, #-0]
     340:	03000007 	movweq	r0, #7
     344:	005e1405 	subseq	r1, lr, r5, lsl #8
     348:	03050000 	movweq	r0, #20480	; 0x5000
     34c:	0000bdd8 	ldrdeq	fp, [r0], -r8
     350:	0007c806 	andeq	ip, r7, r6, lsl #16
     354:	14060300 	strne	r0, [r6], #-768	; 0xfffffd00
     358:	0000005e 	andeq	r0, r0, lr, asr r0
     35c:	bddc0305 	ldcllt	3, cr0, [ip, #20]
     360:	1e060000 	cdpne	0, 0, cr0, cr6, cr0, {0}
     364:	04000007 	streq	r0, [r0], #-7
     368:	005e1a07 	subseq	r1, lr, r7, lsl #20
     36c:	03050000 	movweq	r0, #20480	; 0x5000
     370:	0000bde0 	andeq	fp, r0, r0, ror #27
     374:	0004a106 	andeq	sl, r4, r6, lsl #2
     378:	1a090400 	bne	241380 <__bss_end+0x235288>
     37c:	0000005e 	andeq	r0, r0, lr, asr r0
     380:	bde40305 	stcllt	3, cr0, [r4, #20]!
     384:	2c060000 	stccs	0, cr0, [r6], {-0}
     388:	04000008 	streq	r0, [r0], #-8
     38c:	005e1a0b 	subseq	r1, lr, fp, lsl #20
     390:	03050000 	movweq	r0, #20480	; 0x5000
     394:	0000bde8 	andeq	fp, r0, r8, ror #27
     398:	00065706 	andeq	r5, r6, r6, lsl #14
     39c:	1a0d0400 	bne	3413a4 <__bss_end+0x3352ac>
     3a0:	0000005e 	andeq	r0, r0, lr, asr r0
     3a4:	bdec0305 	stcllt	3, cr0, [ip, #20]!
     3a8:	24060000 	strcs	r0, [r6], #-0
     3ac:	04000005 	streq	r0, [r0], #-5
     3b0:	005e1a0f 	subseq	r1, lr, pc, lsl #20
     3b4:	03050000 	movweq	r0, #20480	; 0x5000
     3b8:	0000bdf0 	strdeq	fp, [r0], -r0
     3bc:	00196707 	andseq	r6, r9, r7, lsl #14
     3c0:	38040500 	stmdacc	r4, {r8, sl}
     3c4:	04000000 	streq	r0, [r0], #-0
     3c8:	010d0c1b 	tsteq	sp, fp, lsl ip
     3cc:	c8080000 	stmdagt	r8, {}	; <UNPREDICTABLE>
     3d0:	00000009 	andeq	r0, r0, r9
     3d4:	000b9908 	andeq	r9, fp, r8, lsl #18
     3d8:	ec080100 	stfs	f0, [r8], {-0}
     3dc:	02000007 	andeq	r0, r0, #7
     3e0:	02010200 	andeq	r0, r1, #0, 4
     3e4:	000006b6 			; <UNDEFINED> instruction: 0x000006b6
     3e8:	002c0409 	eoreq	r0, ip, r9, lsl #8
     3ec:	a0060000 	andge	r0, r6, r0
     3f0:	05000005 	streq	r0, [r0, #-5]
     3f4:	005e1404 	subseq	r1, lr, r4, lsl #8
     3f8:	03050000 	movweq	r0, #20480	; 0x5000
     3fc:	0000bdf4 	strdeq	fp, [r0], -r4
     400:	00033706 	andeq	r3, r3, r6, lsl #14
     404:	14070500 	strne	r0, [r7], #-1280	; 0xfffffb00
     408:	0000005e 	andeq	r0, r0, lr, asr r0
     40c:	bdf80305 	ldcllt	3, cr0, [r8, #20]!
     410:	f6060000 			; <UNDEFINED> instruction: 0xf6060000
     414:	05000004 	streq	r0, [r0, #-4]
     418:	005e140a 	subseq	r1, lr, sl, lsl #8
     41c:	03050000 	movweq	r0, #20480	; 0x5000
     420:	0000bdfc 	strdeq	fp, [r0], -ip
     424:	93070402 	movwls	r0, #29698	; 0x7402
     428:	0600001f 			; <UNDEFINED> instruction: 0x0600001f
     42c:	00000ac6 	andeq	r0, r0, r6, asr #21
     430:	5e140a06 	vnmlspl.f32	s0, s8, s12
     434:	05000000 	streq	r0, [r0, #-0]
     438:	00be0003 	adcseq	r0, lr, r3
     43c:	0b040a00 	bleq	102c44 <__bss_end+0xf6b4c>
     440:	00000593 	muleq	r0, r3, r5
     444:	0703070c 	streq	r0, [r3, -ip, lsl #14]
     448:	00000219 	andeq	r0, r0, r9, lsl r2
     44c:	000af40c 	andeq	pc, sl, ip, lsl #8
     450:	0e060700 	cdpeq	7, 0, cr0, cr6, cr0, {0}
     454:	00000052 	andeq	r0, r0, r2, asr r0
     458:	09750c00 	ldmdbeq	r5!, {sl, fp}^
     45c:	08070000 	stmdaeq	r7, {}	; <UNPREDICTABLE>
     460:	0000520e 	andeq	r5, r0, lr, lsl #4
     464:	f70c0400 			; <UNDEFINED> instruction: 0xf70c0400
     468:	07000007 	streq	r0, [r0, -r7]
     46c:	00520e0b 	subseq	r0, r2, fp, lsl #28
     470:	0d080000 	stceq	0, cr0, [r8, #-0]
     474:	00000593 	muleq	r0, r3, r5
     478:	1f050d07 	svcne	0x00050d07
     47c:	19000009 	stmdbne	r0, {r0, r3}
     480:	01000002 	tsteq	r0, r2
     484:	000001b8 			; <UNDEFINED> instruction: 0x000001b8
     488:	000001be 			; <UNDEFINED> instruction: 0x000001be
     48c:	0002190e 	andeq	r1, r2, lr, lsl #18
     490:	4b0f0000 	blmi	3c0498 <__bss_end+0x3b43a0>
     494:	0700000a 	streq	r0, [r0, -sl]
     498:	06bb0a0e 	ldrteq	r0, [fp], lr, lsl #20
     49c:	d3010000 	movwle	r0, #4096	; 0x1000
     4a0:	d9000001 	stmdble	r0, {r0}
     4a4:	0e000001 	cdpeq	0, 0, cr0, cr0, cr1, {0}
     4a8:	00000219 	andeq	r0, r0, r9, lsl r2
     4ac:	09100d00 	ldmdbeq	r0, {r8, sl, fp}
     4b0:	0f070000 	svceq	0x00070000
     4b4:	00052e0b 	andeq	r2, r5, fp, lsl #28
     4b8:	00016900 	andeq	r6, r1, r0, lsl #18
     4bc:	01f20100 	mvnseq	r0, r0, lsl #2
     4c0:	01fd0000 	mvnseq	r0, r0
     4c4:	190e0000 	stmdbne	lr, {}	; <UNPREDICTABLE>
     4c8:	10000002 	andne	r0, r0, r2
     4cc:	00000052 	andeq	r0, r0, r2, asr r0
     4d0:	0a3b1100 	beq	ec48d8 <__bss_end+0xeb87e0>
     4d4:	10070000 	andne	r0, r7, r0
     4d8:	0008a50e 	andeq	sl, r8, lr, lsl #10
     4dc:	00005200 	andeq	r5, r0, r0, lsl #4
     4e0:	02120100 	andseq	r0, r2, #0, 2
     4e4:	190e0000 	stmdbne	lr, {}	; <UNPREDICTABLE>
     4e8:	00000002 	andeq	r0, r0, r2
     4ec:	6b040900 	blvs	1028f4 <__bss_end+0xf67fc>
     4f0:	12000001 	andne	r0, r0, #1
     4f4:	12070068 	andne	r0, r7, #104	; 0x68
     4f8:	00016b15 	andeq	r6, r1, r5, lsl fp
     4fc:	0b181300 	bleq	605104 <__bss_end+0x5f900c>
     500:	010c0000 	mrseq	r0, (UNDEF: 12)
     504:	9e070708 	cdpls	7, 0, cr0, cr7, cr8, {0}
     508:	14000003 	strne	r0, [r0], #-3
     50c:	00000aa6 	andeq	r0, r0, r6, lsr #21
     510:	5e1b0908 	vnmlspl.f16	s0, s22, s16	; <UNPREDICTABLE>
     514:	80000000 	andhi	r0, r0, r0
     518:	0003600c 	andeq	r6, r3, ip
     51c:	0e0b0800 	cdpeq	8, 0, cr0, cr11, cr0, {0}
     520:	00000052 	andeq	r0, r0, r2, asr r0
     524:	046c0c00 	strbteq	r0, [ip], #-3072	; 0xfffff400
     528:	0c080000 	stceq	0, cr0, [r8], {-0}
     52c:	0000520e 	andeq	r5, r0, lr, lsl #4
     530:	090c0400 	stmdbeq	ip, {sl}
     534:	0800000d 	stmdaeq	r0, {r0, r2, r3}
     538:	039e0a0f 	orrseq	r0, lr, #61440	; 0xf000
     53c:	0c080000 	stceq	0, cr0, [r8], {-0}
     540:	000008e8 	andeq	r0, r0, r8, ror #17
     544:	520e1008 	andpl	r1, lr, #8
     548:	88000000 	stmdahi	r0, {}	; <UNPREDICTABLE>
     54c:	000ad50c 	andeq	sp, sl, ip, lsl #10
     550:	0a120800 	beq	482558 <__bss_end+0x476460>
     554:	0000039e 	muleq	r0, lr, r3
     558:	0916158c 	ldmdbeq	r6, {r2, r3, r7, r8, sl, ip}
     55c:	13080000 	movwne	r0, #32768	; 0x8000
     560:	00048b0a 	andeq	r8, r4, sl, lsl #22
     564:	00029900 	andeq	r9, r2, r0, lsl #18
     568:	0002a400 	andeq	sl, r2, r0, lsl #8
     56c:	03ae0e00 			; <UNDEFINED> instruction: 0x03ae0e00
     570:	25100000 	ldrcs	r0, [r0, #-0]
     574:	00000000 	andeq	r0, r0, r0
     578:	00080615 	andeq	r0, r8, r5, lsl r6
     57c:	0a140800 	beq	502584 <__bss_end+0x4f648c>
     580:	0000056b 	andeq	r0, r0, fp, ror #10
     584:	000002b8 			; <UNDEFINED> instruction: 0x000002b8
     588:	000002c3 	andeq	r0, r0, r3, asr #5
     58c:	0003ae0e 	andeq	sl, r3, lr, lsl #28
     590:	00521000 	subseq	r1, r2, r0
     594:	16000000 	strne	r0, [r0], -r0
     598:	00000bc2 	andeq	r0, r0, r2, asr #23
     59c:	580a1508 	stmdapl	sl, {r3, r8, sl, ip}
     5a0:	0d00000a 	stceq	0, cr0, [r0, #-40]	; 0xffffffd8
     5a4:	db000001 	blle	5b0 <shift+0x5b0>
     5a8:	e1000002 	tst	r0, r2
     5ac:	0e000002 	cdpeq	0, 0, cr0, cr0, cr2, {0}
     5b0:	000003ae 	andeq	r0, r0, lr, lsr #7
     5b4:	04041600 	streq	r1, [r4], #-1536	; 0xfffffa00
     5b8:	16080000 	strne	r0, [r8], -r0
     5bc:	000a150a 	andeq	r1, sl, sl, lsl #10
     5c0:	00010d00 	andeq	r0, r1, r0, lsl #26
     5c4:	0002f900 	andeq	pc, r2, r0, lsl #18
     5c8:	0002ff00 	andeq	pc, r2, r0, lsl #30
     5cc:	03ae0e00 			; <UNDEFINED> instruction: 0x03ae0e00
     5d0:	0d000000 	stceq	0, cr0, [r0, #-0]
     5d4:	00000b18 	andeq	r0, r0, r8, lsl fp
     5d8:	1f051808 	svcne	0x00051808
     5dc:	ae00000b 	cdpge	0, 0, cr0, cr0, cr11, {0}
     5e0:	01000003 	tsteq	r0, r3
     5e4:	00000318 	andeq	r0, r0, r8, lsl r3
     5e8:	00000323 	andeq	r0, r0, r3, lsr #6
     5ec:	0003ae0e 	andeq	sl, r3, lr, lsl #28
     5f0:	00521000 	subseq	r1, r2, r0
     5f4:	0d000000 	stceq	0, cr0, [r0, #-0]
     5f8:	000008ca 	andeq	r0, r0, sl, asr #17
     5fc:	3a0b1908 	bcc	2c6a24 <__bss_end+0x2ba92c>
     600:	b4000008 	strlt	r0, [r0], #-8
     604:	01000003 	tsteq	r0, r3
     608:	0000033c 	andeq	r0, r0, ip, lsr r3
     60c:	00000342 	andeq	r0, r0, r2, asr #6
     610:	0003ae0e 	andeq	sl, r3, lr, lsl #28
     614:	d40d0000 	strle	r0, [sp], #-0
     618:	08000007 	stmdaeq	r0, {r0, r1, r2}
     61c:	09d20b1a 	ldmibeq	r2, {r1, r3, r4, r8, r9, fp}^
     620:	03b40000 			; <UNDEFINED> instruction: 0x03b40000
     624:	5b010000 	blpl	4062c <__bss_end+0x34534>
     628:	66000003 	strvs	r0, [r0], -r3
     62c:	0e000003 	cdpeq	0, 0, cr0, cr0, cr3, {0}
     630:	000003ae 	andeq	r0, r0, lr, lsr #7
     634:	00003810 	andeq	r3, r0, r0, lsl r8
     638:	7d0f0000 	stcvc	0, cr0, [pc, #-0]	; 640 <shift+0x640>
     63c:	08000006 	stmdaeq	r0, {r1, r2}
     640:	099c0a1b 	ldmibeq	ip, {r0, r1, r3, r4, r9, fp}
     644:	7b010000 	blvc	4064c <__bss_end+0x34554>
     648:	81000003 	tsthi	r0, r3
     64c:	0e000003 	cdpeq	0, 0, cr0, cr0, cr3, {0}
     650:	000003ae 	andeq	r0, r0, lr, lsr #7
     654:	06ab1700 	strteq	r1, [fp], r0, lsl #14
     658:	1c080000 	stcne	0, cr0, [r8], {-0}
     65c:	0003bf0a 	andeq	fp, r3, sl, lsl #30
     660:	03920100 	orrseq	r0, r2, #0, 2
     664:	ae0e0000 	cdpge	0, 0, cr0, cr14, cr0, {0}
     668:	10000003 	andne	r0, r0, r3
     66c:	00000114 	andeq	r0, r0, r4, lsl r1
     670:	25180000 	ldrcs	r0, [r8, #-0]
     674:	ae000000 	cdpge	0, 0, cr0, cr0, cr0, {0}
     678:	19000003 	stmdbne	r0, {r0, r1}
     67c:	00000063 	andeq	r0, r0, r3, rrx
     680:	0409007f 	streq	r0, [r9], #-127	; 0xffffff81
     684:	00000229 	andeq	r0, r0, r9, lsr #4
     688:	00250409 	eoreq	r0, r5, r9, lsl #8
     68c:	490b0000 	stmdbmi	fp, {}	; <UNPREDICTABLE>
     690:	1c00000b 	stcne	0, cr0, [r0], {11}
     694:	91070309 	tstls	r7, r9, lsl #6
     698:	1a000004 	bne	6b0 <shift+0x6b0>
     69c:	05090061 	streq	r0, [r9, #-97]	; 0xffffff9f
     6a0:	00003809 	andeq	r3, r0, r9, lsl #16
     6a4:	631a0000 	tstvs	sl, #0
     6a8:	09060900 	stmdbeq	r6, {r8, fp}
     6ac:	00000038 	andeq	r0, r0, r8, lsr r0
     6b0:	696d1a04 	stmdbvs	sp!, {r2, r9, fp, ip}^
     6b4:	0709006e 	streq	r0, [r9, -lr, rrx]
     6b8:	00003809 	andeq	r3, r0, r9, lsl #16
     6bc:	6d1a0800 	ldcvs	8, cr0, [sl, #-0]
     6c0:	09007861 	stmdbeq	r0, {r0, r5, r6, fp, ip, sp, lr}
     6c4:	00380908 	eorseq	r0, r8, r8, lsl #18
     6c8:	0c0c0000 	stceq	0, cr0, [ip], {-0}
     6cc:	00000618 	andeq	r0, r0, r8, lsl r6
     6d0:	38090909 	stmdacc	r9, {r0, r3, r8, fp}
     6d4:	10000000 	andne	r0, r0, r0
     6d8:	0006f70c 	andeq	pc, r6, ip, lsl #14
     6dc:	090b0900 	stmdbeq	fp, {r8, fp}
     6e0:	00000038 	andeq	r0, r0, r8, lsr r0
     6e4:	09f80c14 	ldmibeq	r8!, {r2, r4, sl, fp}^
     6e8:	0c090000 	stceq	0, cr0, [r9], {-0}
     6ec:	00003809 	andeq	r3, r0, r9, lsl #16
     6f0:	490d1800 	stmdbmi	sp, {fp, ip}
     6f4:	0900000b 	stmdbeq	r0, {r0, r1, r3}
     6f8:	07630510 			; <UNDEFINED> instruction: 0x07630510
     6fc:	04910000 	ldreq	r0, [r1], #0
     700:	37010000 	strcc	r0, [r1, -r0]
     704:	56000004 	strpl	r0, [r0], -r4
     708:	0e000004 	cdpeq	0, 0, cr0, cr0, cr4, {0}
     70c:	00000491 	muleq	r0, r1, r4
     710:	00003810 	andeq	r3, r0, r0, lsl r8
     714:	00381000 	eorseq	r1, r8, r0
     718:	38100000 	ldmdacc	r0, {}	; <UNPREDICTABLE>
     71c:	10000000 	andne	r0, r0, r0
     720:	00000038 	andeq	r0, r0, r8, lsr r0
     724:	00003810 	andeq	r3, r0, r0, lsl r8
     728:	c40d0000 	strgt	r0, [sp], #-0
     72c:	09000004 	stmdbeq	r0, {r2}
     730:	03e40911 	mvneq	r0, #278528	; 0x44000
     734:	00380000 	eorseq	r0, r8, r0
     738:	6f010000 	svcvs	0x00010000
     73c:	75000004 	strvc	r0, [r0, #-4]
     740:	0e000004 	cdpeq	0, 0, cr0, cr0, cr4, {0}
     744:	00000491 	muleq	r0, r1, r4
     748:	03da1100 	bicseq	r1, sl, #0, 2
     74c:	13090000 	movwne	r0, #36864	; 0x9000
     750:	0009530b 	andeq	r5, r9, fp, lsl #6
     754:	00049700 	andeq	r9, r4, r0, lsl #14
     758:	048a0100 	streq	r0, [sl], #256	; 0x100
     75c:	910e0000 	mrsls	r0, (UNDEF: 14)
     760:	00000004 	andeq	r0, r0, r4
     764:	ba040900 	blt	102b6c <__bss_end+0xf6a74>
     768:	02000003 	andeq	r0, r0, #3
     76c:	1c9f0404 	cfldrsne	mvf0, [pc], {4}
     770:	97030000 	strls	r0, [r3, -r0]
     774:	1b000004 	blne	78c <shift+0x78c>
     778:	0000060e 	andeq	r0, r0, lr, lsl #12
     77c:	080f0a1c 	stmdaeq	pc, {r2, r3, r4, r9, fp}	; <UNPREDICTABLE>
     780:	000004d8 	ldrdeq	r0, [r0], -r8
     784:	00040c0c 	andeq	r0, r4, ip, lsl #24
     788:	0b110a00 	bleq	442f90 <__bss_end+0x436e98>
     78c:	000004d8 	ldrdeq	r0, [r0], -r8
     790:	0a0d0c00 	beq	343798 <__bss_end+0x3376a0>
     794:	130a0000 	movwne	r0, #40960	; 0xa000
     798:	0004970b 	andeq	r9, r4, fp, lsl #14
     79c:	420c1400 	andmi	r1, ip, #0, 8
     7a0:	0a000003 	beq	7b4 <shift+0x7b4>
     7a4:	04e80c15 	strbteq	r0, [r8], #3093	; 0xc15
     7a8:	00180000 	andseq	r0, r8, r0
     7ac:	00049718 	andeq	r9, r4, r8, lsl r7
     7b0:	0004e800 	andeq	lr, r4, r0, lsl #16
     7b4:	00631900 	rsbeq	r1, r3, r0, lsl #18
     7b8:	00040000 	andeq	r0, r4, r0
     7bc:	04970409 	ldreq	r0, [r7], #1033	; 0x409
     7c0:	6d0b0000 	stcvs	0, cr0, [fp, #-0]
     7c4:	3c000003 	stccc	0, cr0, [r0], {3}
     7c8:	34071b0a 	strcc	r1, [r7], #-2826	; 0xfffff4f6
     7cc:	0c000008 	stceq	0, cr0, [r0], {8}
     7d0:	00000b91 	muleq	r0, r1, fp
     7d4:	38091f0a 	stmdacc	r9, {r1, r3, r8, r9, sl, fp, ip}
     7d8:	00000000 	andeq	r0, r0, r0
     7dc:	000b420c 	andeq	r4, fp, ip, lsl #4
     7e0:	09210a00 	stmdbeq	r1!, {r9, fp}
     7e4:	00000038 	andeq	r0, r0, r8, lsr r0
     7e8:	0ae00c04 	beq	ff803800 <__bss_end+0xff7f7708>
     7ec:	230a0000 	movwcs	r0, #40960	; 0xa000
     7f0:	00003809 	andeq	r3, r0, r9, lsl #16
     7f4:	2e0c0800 	cdpcs	8, 0, cr0, cr12, cr0, {0}
     7f8:	0a00000b 	beq	82c <shift+0x82c>
     7fc:	00380924 	eorseq	r0, r8, r4, lsr #18
     800:	1c0c0000 	stcne	0, cr0, [ip], {-0}
     804:	00000a2a 	andeq	r0, r0, sl, lsr #20
     808:	9e1c260a 	cfmsub32ls	mvax0, mvfx2, mvfx12, mvfx10
     80c:	04000004 	streq	r0, [r0], #-4
     810:	37422e45 	strbcc	r2, [r2, -r5, asr #28]
     814:	0007120c 	andeq	r1, r7, ip, lsl #4
     818:	09280a00 	stmdbeq	r8!, {r9, fp}
     81c:	00000038 	andeq	r0, r0, r8, lsr r0
     820:	08940c10 	ldmeq	r4, {r4, sl, fp}
     824:	2a0a0000 	bcs	28082c <__bss_end+0x274734>
     828:	00003809 	andeq	r3, r0, r9, lsl #16
     82c:	7a0c1400 	bvc	305834 <__bss_end+0x2f973c>
     830:	0a000004 	beq	848 <shift+0x848>
     834:	010d0a2c 	tsteq	sp, ip, lsr #20
     838:	0c180000 	ldceq	0, cr0, [r8], {-0}
     83c:	000009af 	andeq	r0, r0, pc, lsr #19
     840:	38092e0a 	stmdacc	r9, {r1, r3, r9, sl, fp, sp}
     844:	1c000000 	stcne	0, cr0, [r0], {-0}
     848:	00068e0c 	andeq	r8, r6, ip, lsl #28
     84c:	09300a00 	ldmdbeq	r0!, {r9, fp}
     850:	00000038 	andeq	r0, r0, r8, lsr r0
     854:	08210c20 	stmdaeq	r1!, {r5, sl, fp}
     858:	320a0000 	andcc	r0, sl, #0
     85c:	00083411 	andeq	r3, r8, r1, lsl r4
     860:	850c2400 	strhi	r2, [ip, #-1024]	; 0xfffffc00
     864:	0a000004 	beq	87c <shift+0x87c>
     868:	083a1034 	ldmdaeq	sl!, {r2, r4, r5, ip}
     86c:	0c280000 	stceq	0, cr0, [r8], #-0
     870:	000006e4 	andeq	r0, r0, r4, ror #13
     874:	9117360a 	tstls	r7, sl, lsl #12
     878:	2c000004 	stccs	0, cr0, [r0], {4}
     87c:	7266621a 	rsbvc	r6, r6, #-1610612735	; 0xa0000001
     880:	0d380a00 	vldmdbeq	r8!, {s0-s-1}
     884:	000003ae 	andeq	r0, r0, lr, lsr #7
     888:	04cc0c30 	strbeq	r0, [ip], #3120	; 0xc30
     88c:	3b0a0000 	blcc	280894 <__bss_end+0x27479c>
     890:	0004970b 	andeq	r9, r4, fp, lsl #14
     894:	510c3400 	tstpl	ip, r0, lsl #8
     898:	0a00000c 	beq	8d0 <shift+0x8d0>
     89c:	04e80c3e 	strbteq	r0, [r8], #3134	; 0xc3e
     8a0:	16380000 	ldrtne	r0, [r8], -r0
     8a4:	00000bcb 	andeq	r0, r0, fp, asr #23
     8a8:	340a400a 	strcc	r4, [sl], #-10
     8ac:	0d000007 	stceq	0, cr0, [r0, #-28]	; 0xffffffe4
     8b0:	e7000001 	str	r0, [r0, -r1]
     8b4:	ed000005 	stc	0, cr0, [r0, #-20]	; 0xffffffec
     8b8:	0e000005 	cdpeq	0, 0, cr0, cr0, cr5, {0}
     8bc:	00000840 	andeq	r0, r0, r0, asr #16
     8c0:	08ed1600 	stmiaeq	sp!, {r9, sl, ip}^
     8c4:	420a0000 	andmi	r0, sl, #0
     8c8:	00079f0b 	andeq	r9, r7, fp, lsl #30
     8cc:	00049700 	andeq	r9, r4, r0, lsl #14
     8d0:	00060500 	andeq	r0, r6, r0, lsl #10
     8d4:	00061000 	andeq	r1, r6, r0
     8d8:	08400e00 	stmdaeq	r0, {r9, sl, fp}^
     8dc:	3a100000 	bcc	4008e4 <__bss_end+0x3f47ec>
     8e0:	00000008 	andeq	r0, r0, r8
     8e4:	00035b15 	andeq	r5, r3, r5, lsl fp
     8e8:	0a440a00 	beq	11030f0 <__bss_end+0x10f6ff8>
     8ec:	000004b3 			; <UNDEFINED> instruction: 0x000004b3
     8f0:	00000624 	andeq	r0, r0, r4, lsr #12
     8f4:	0000062a 	andeq	r0, r0, sl, lsr #12
     8f8:	0008400e 	andeq	r4, r8, lr
     8fc:	ff150000 			; <UNDEFINED> instruction: 0xff150000
     900:	0a000008 	beq	928 <shift+0x928>
     904:	06390a46 	ldrteq	r0, [r9], -r6, asr #20
     908:	063e0000 	ldrteq	r0, [lr], -r0
     90c:	06440000 	strbeq	r0, [r4], -r0
     910:	400e0000 	andmi	r0, lr, r0
     914:	00000008 	andeq	r0, r0, r8
     918:	00070715 	andeq	r0, r7, r5, lsl r7
     91c:	0a480a00 	beq	1203124 <__bss_end+0x11f702c>
     920:	00000445 	andeq	r0, r0, r5, asr #8
     924:	00000658 	andeq	r0, r0, r8, asr r6
     928:	0000065e 	andeq	r0, r0, lr, asr r6
     92c:	0008400e 	andeq	r4, r8, lr
     930:	ca160000 	bgt	580938 <__bss_end+0x574840>
     934:	0a000005 	beq	950 <shift+0x950>
     938:	08700b4a 	ldmdaeq	r0!, {r1, r3, r6, r8, r9, fp}^
     93c:	04970000 	ldreq	r0, [r7], #0
     940:	06760000 	ldrbteq	r0, [r6], -r0
     944:	06860000 	streq	r0, [r6], r0
     948:	400e0000 	andmi	r0, lr, r0
     94c:	10000008 	andne	r0, r0, r8
     950:	000004e8 	andeq	r0, r0, r8, ror #9
     954:	00049710 	andeq	r9, r4, r0, lsl r7
     958:	9a160000 	bls	580960 <__bss_end+0x574868>
     95c:	0a000006 	beq	97c <shift+0x97c>
     960:	050f0b4c 	streq	r0, [pc, #-2892]	; fffffe1c <__bss_end+0xffff3d24>
     964:	04970000 	ldreq	r0, [r7], #0
     968:	069e0000 	ldreq	r0, [lr], r0
     96c:	06b30000 	ldrteq	r0, [r3], r0
     970:	400e0000 	andmi	r0, lr, r0
     974:	10000008 	andne	r0, r0, r8
     978:	00000497 	muleq	r0, r7, r4
     97c:	00049710 	andeq	r9, r4, r0, lsl r7
     980:	04971000 	ldreq	r1, [r7], #0
     984:	15000000 	strne	r0, [r0, #-0]
     988:	000006a1 	andeq	r0, r0, r1, lsr #13
     98c:	f80a4e0a 			; <UNDEFINED> instruction: 0xf80a4e0a
     990:	c7000005 	strgt	r0, [r0, -r5]
     994:	d2000006 	andle	r0, r0, #6
     998:	0e000006 	cdpeq	0, 0, cr0, cr0, cr6, {0}
     99c:	00000840 	andeq	r0, r0, r0, asr #16
     9a0:	00083a10 	andeq	r3, r8, r0, lsl sl
     9a4:	53150000 	tstpl	r5, #0
     9a8:	0a000003 	beq	9bc <shift+0x9bc>
     9ac:	03840a50 	orreq	r0, r4, #80, 20	; 0x50000
     9b0:	06e60000 	strbteq	r0, [r6], r0
     9b4:	06f10000 	ldrbteq	r0, [r1], r0
     9b8:	400e0000 	andmi	r0, lr, r0
     9bc:	10000008 	andne	r0, r0, r8
     9c0:	0000083a 	andeq	r0, r0, sl, lsr r8
     9c4:	06d41500 	ldrbeq	r1, [r4], r0, lsl #10
     9c8:	520a0000 	andpl	r0, sl, #0
     9cc:	000a7e0a 	andeq	r7, sl, sl, lsl #28
     9d0:	00070500 	andeq	r0, r7, r0, lsl #10
     9d4:	00071000 	andeq	r1, r7, r0
     9d8:	08400e00 	stmdaeq	r0, {r9, sl, fp}^
     9dc:	34100000 	ldrcc	r0, [r0], #-0
     9e0:	00000008 	andeq	r0, r0, r8
     9e4:	000ab215 	andeq	fp, sl, r5, lsl r2
     9e8:	0a540a00 	beq	15031f0 <__bss_end+0x14f70f8>
     9ec:	000004d6 	ldrdeq	r0, [r0], -r6
     9f0:	00000724 	andeq	r0, r0, r4, lsr #14
     9f4:	0000072f 	andeq	r0, r0, pc, lsr #14
     9f8:	0008400e 	andeq	r4, r8, lr
     9fc:	08341000 	ldmdaeq	r4!, {ip}
     a00:	15000000 	strne	r0, [r0, #-0]
     a04:	000006eb 	andeq	r0, r0, fp, ror #13
     a08:	df0a560a 	svcle	0x000a560a
     a0c:	43000005 	movwmi	r0, #5
     a10:	49000007 	stmdbmi	r0, {r0, r1, r2}
     a14:	0e000007 	cdpeq	0, 0, cr0, cr0, cr7, {0}
     a18:	00000840 	andeq	r0, r0, r0, asr #16
     a1c:	09881500 	stmibeq	r8, {r8, sl, ip}
     a20:	580a0000 	stmdapl	sl, {}	; <UNPREDICTABLE>
     a24:	0005480a 	andeq	r4, r5, sl, lsl #16
     a28:	00075d00 	andeq	r5, r7, r0, lsl #26
     a2c:	00076800 	andeq	r6, r7, r0, lsl #16
     a30:	08400e00 	stmdaeq	r0, {r9, sl, fp}^
     a34:	14100000 	ldrne	r0, [r0], #-0
     a38:	00000001 	andeq	r0, r0, r1
     a3c:	000a6e16 	andeq	r6, sl, r6, lsl lr
     a40:	0a5a0a00 	beq	1683248 <__bss_end+0x1677150>
     a44:	000003a2 	andeq	r0, r0, r2, lsr #7
     a48:	0000010d 	andeq	r0, r0, sp, lsl #2
     a4c:	00000780 	andeq	r0, r0, r0, lsl #15
     a50:	0000078b 	andeq	r0, r0, fp, lsl #15
     a54:	0008400e 	andeq	r4, r8, lr
     a58:	04971000 	ldreq	r1, [r7], #0
     a5c:	15000000 	strne	r0, [r0, #-0]
     a60:	00000582 	andeq	r0, r0, r2, lsl #11
     a64:	810a5c0a 	tsthi	sl, sl, lsl #24
     a68:	9f000007 	svcls	0x00000007
     a6c:	a5000007 	strge	r0, [r0, #-7]
     a70:	0e000007 	cdpeq	0, 0, cr0, cr0, cr7, {0}
     a74:	00000840 	andeq	r0, r0, r0, asr #16
     a78:	036d0d00 	cmneq	sp, #0, 26
     a7c:	610a0000 	mrsvs	r0, (UNDEF: 10)
     a80:	000bdf05 	andeq	sp, fp, r5, lsl #30
     a84:	00084000 	andeq	r4, r8, r0
     a88:	07be0100 	ldreq	r0, [lr, r0, lsl #2]!
     a8c:	07dd0000 	ldrbeq	r0, [sp, r0]
     a90:	400e0000 	andmi	r0, lr, r0
     a94:	10000008 	andne	r0, r0, r8
     a98:	00000038 	andeq	r0, r0, r8, lsr r0
     a9c:	00003810 	andeq	r3, r0, r0, lsl r8
     aa0:	00381000 	eorseq	r1, r8, r0
     aa4:	38100000 	ldmdacc	r0, {}	; <UNPREDICTABLE>
     aa8:	10000000 	andne	r0, r0, r0
     aac:	00000038 	andeq	r0, r0, r8, lsr r0
     ab0:	06830f00 	streq	r0, [r3], r0, lsl #30
     ab4:	640a0000 	strvs	r0, [sl], #-0
     ab8:	000b000a 	andeq	r0, fp, sl
     abc:	07f20100 	ldrbeq	r0, [r2, r0, lsl #2]!
     ac0:	07fd0000 	ldrbeq	r0, [sp, r0]!
     ac4:	400e0000 	andmi	r0, lr, r0
     ac8:	10000008 	andne	r0, r0, r8
     acc:	000003ae 	andeq	r0, r0, lr, lsr #7
     ad0:	04340d00 	ldrteq	r0, [r4], #-3328	; 0xfffff300
     ad4:	660a0000 	strvs	r0, [sl], -r0
     ad8:	0009350c 	andeq	r3, r9, ip, lsl #10
     adc:	0004e800 	andeq	lr, r4, r0, lsl #16
     ae0:	08160100 	ldmdaeq	r6, {r8}
     ae4:	081c0000 	ldmdaeq	ip, {}	; <UNPREDICTABLE>
     ae8:	400e0000 	andmi	r0, lr, r0
     aec:	00000008 	andeq	r0, r0, r8
     af0:	6e75521d 	mrcvs	2, 3, r5, cr5, cr13, {0}
     af4:	0a680a00 	beq	1a032fc <__bss_end+0x19f7204>
     af8:	0000061d 	andeq	r0, r0, sp, lsl r6
     afc:	00082d01 	andeq	r2, r8, r1, lsl #26
     b00:	08400e00 	stmdaeq	r0, {r9, sl, fp}^
     b04:	00000000 	andeq	r0, r0, r0
     b08:	083a0409 	ldmdaeq	sl!, {r0, r3, sl}
     b0c:	04090000 	streq	r0, [r9], #-0
     b10:	000004a3 	andeq	r0, r0, r3, lsr #9
     b14:	04ee0409 	strbteq	r0, [lr], #1033	; 0x409
     b18:	b91e0000 	ldmdblt	lr, {}	; <UNPREDICTABLE>
     b1c:	02000005 	andeq	r0, r0, #5
     b20:	003f0b0e 	eorseq	r0, pc, lr, lsl #22
     b24:	03050000 	movweq	r0, #20480	; 0x5000
     b28:	0000be04 	andeq	fp, r0, r4, lsl #28
     b2c:	00062d1e 	andeq	r2, r6, lr, lsl sp
     b30:	0b0f0200 	bleq	3c1338 <__bss_end+0x3b5240>
     b34:	0000003f 	andeq	r0, r0, pc, lsr r0
     b38:	be080305 	cdplt	3, 0, cr0, cr8, cr5, {0}
     b3c:	731e0000 	tstvc	lr, #0
     b40:	02000003 	andeq	r0, r0, #3
     b44:	003f0b10 	eorseq	r0, pc, r0, lsl fp	; <UNPREDICTABLE>
     b48:	03050000 	movweq	r0, #20480	; 0x5000
     b4c:	0000be0c 	andeq	fp, r0, ip, lsl #28
     b50:	001f2c1f 	andseq	r2, pc, pc, lsl ip	; <UNPREDICTABLE>
     b54:	05380200 	ldreq	r0, [r8, #-512]!	; 0xfffffe00
     b58:	00000038 	andeq	r0, r0, r8, lsr r0
     b5c:	0000844c 	andeq	r8, r0, ip, asr #8
     b60:	00000144 	andeq	r0, r0, r4, asr #2
     b64:	09379c01 	ldmdbeq	r7!, {r0, sl, fp, ip, pc}
     b68:	e31e0000 	tst	lr, #0
     b6c:	02000008 	andeq	r0, r0, #8
     b70:	00520e3a 	subseq	r0, r2, sl, lsr lr
     b74:	91020000 	mrsls	r0, (UNDEF: 2)
     b78:	006d206c 	rsbeq	r2, sp, ip, rrx
     b7c:	400c3c02 	andmi	r3, ip, r2, lsl #24
     b80:	02000008 	andeq	r0, r0, #8
     b84:	62205c91 	eorvs	r5, r0, #37120	; 0x9100
     b88:	02007266 	andeq	r7, r0, #1610612742	; 0x60000006
     b8c:	03ae0d3e 			; <UNDEFINED> instruction: 0x03ae0d3e
     b90:	91020000 	mrsls	r0, (UNDEF: 2)
     b94:	0b422168 	bleq	108913c <__bss_end+0x107d044>
     b98:	42020000 	andmi	r0, r2, #0
     b9c:	0003b40b 	andeq	fp, r3, fp, lsl #8
     ba0:	0b912100 	bleq	fe448fa8 <__bss_end+0xfe43ceb0>
     ba4:	43020000 	movwmi	r0, #8192	; 0x2000
     ba8:	0003b40b 	andeq	fp, r3, fp, lsl #8
     bac:	04621e00 	strbteq	r1, [r2], #-3584	; 0xfffff200
     bb0:	46020000 	strmi	r0, [r2], -r0
     bb4:	0009370a 	andeq	r3, r9, sl, lsl #14
     bb8:	4c910200 	lfmmi	f0, 4, [r1], {0}
     bbc:	0004671e 	andeq	r6, r4, lr, lsl r7
     bc0:	0a470200 	beq	11c13c8 <__bss_end+0x11b52d0>
     bc4:	00000937 	andeq	r0, r0, r7, lsr r9
     bc8:	7fbc9103 	svcvc	0x00bc9103
     bcc:	00045d1e 	andeq	r5, r4, lr, lsl sp
     bd0:	0a480200 	beq	12013d8 <__bss_end+0x11f52e0>
     bd4:	00000947 	andeq	r0, r0, r7, asr #18
     bd8:	7fb49103 	svcvc	0x00b49103
     bdc:	000a501e 	andeq	r5, sl, lr, lsl r0
     be0:	0a4b0200 	beq	12c13e8 <__bss_end+0x12b52f0>
     be4:	00000957 	andeq	r0, r0, r7, asr r9
     be8:	7db49103 	ldfvcd	f1, [r4, #12]!
     bec:	0009bc1e 	andeq	fp, r9, lr, lsl ip
     bf0:	0f690200 	svceq	0x00690200
     bf4:	0000003f 	andeq	r0, r0, pc, lsr r0
     bf8:	1e649102 	lgnnes	f1, f2
     bfc:	00000abb 			; <UNDEFINED> instruction: 0x00000abb
     c00:	3f0f6a02 	svccc	0x000f6a02
     c04:	02000000 	andeq	r0, r0, #0
     c08:	18006091 	stmdane	r0, {r0, r4, r7, sp, lr}
     c0c:	00000025 	andeq	r0, r0, r5, lsr #32
     c10:	00000947 	andeq	r0, r0, r7, asr #18
     c14:	00006319 	andeq	r6, r0, r9, lsl r3
     c18:	18000e00 	stmdane	r0, {r9, sl, fp}
     c1c:	00000025 	andeq	r0, r0, r5, lsr #32
     c20:	00000957 	andeq	r0, r0, r7, asr r9
     c24:	00006319 	andeq	r6, r0, r9, lsl r3
     c28:	18000700 	stmdane	r0, {r8, r9, sl}
     c2c:	00000025 	andeq	r0, r0, r5, lsr #32
     c30:	00000967 	andeq	r0, r0, r7, ror #18
     c34:	00006319 	andeq	r6, r0, r9, lsl r3
     c38:	2200fe00 	andcs	pc, r0, #0, 28
     c3c:	00000bb1 			; <UNDEFINED> instruction: 0x00000bb1
     c40:	17062e02 	strne	r2, [r6, -r2, lsl #28]
     c44:	d0000004 	andle	r0, r0, r4
     c48:	7c000083 	stcvc	0, cr0, [r0], {131}	; 0x83
     c4c:	01000000 	mrseq	r0, (UNDEF: 0)
     c50:	0009919c 	muleq	r9, ip, r1
     c54:	66622300 	strbtvs	r2, [r2], -r0, lsl #6
     c58:	2e020072 	mcrcs	0, 0, r0, cr2, cr2, {3}
     c5c:	0003ae1f 	andeq	sl, r3, pc, lsl lr
     c60:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     c64:	08652400 	stmdaeq	r5!, {sl, sp}^
     c68:	13020000 	movwne	r0, #8192	; 0x2000
     c6c:	00081006 	andeq	r1, r8, r6
     c70:	00822c00 	addeq	r2, r2, r0, lsl #24
     c74:	0001a400 	andeq	sl, r1, r0, lsl #8
     c78:	bb9c0100 	bllt	fe701080 <__bss_end+0xfe6f4f88>
     c7c:	25000009 	strcs	r0, [r0, #-9]
     c80:	00000c51 	andeq	r0, r0, r1, asr ip
     c84:	e8181302 	ldmda	r8, {r1, r8, r9, ip}
     c88:	02000004 	andeq	r0, r0, #4
     c8c:	26007491 			; <UNDEFINED> instruction: 0x26007491
     c90:	00000ba4 	andeq	r0, r0, r4, lsr #23
     c94:	090e0501 	stmdbeq	lr, {r0, r8, sl}
     c98:	69000005 	stmdbvs	r0, {r0, r2}
     c9c:	90000001 	andls	r0, r0, r1
     ca0:	30000085 	andcc	r0, r0, r5, lsl #1
     ca4:	01000000 	mrseq	r0, (UNDEF: 0)
     ca8:	15b5259c 	ldrne	r2, [r5, #1436]!	; 0x59c
     cac:	05010000 	streq	r0, [r1, #-0]
     cb0:	00005224 	andeq	r5, r0, r4, lsr #4
     cb4:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     cb8:	111f0000 	tstne	pc, r0
     cbc:	00040000 	andeq	r0, r4, r0
     cc0:	00000487 	andeq	r0, r0, r7, lsl #9
     cc4:	025e0104 	subseq	r0, lr, #4, 2
     cc8:	5f040000 	svcpl	0x00040000
     ccc:	2a00000c 	bcs	d04 <shift+0xd04>
     cd0:	30000000 	andcc	r0, r0, r0
     cd4:	00000000 	andeq	r0, r0, r0
     cd8:	a9000000 	stmdbge	r0, {}	; <UNPREDICTABLE>
     cdc:	02000004 	andeq	r0, r0, #4
     ce0:	00000b49 	andeq	r0, r0, r9, asr #22
     ce4:	0703031c 	smladeq	r3, ip, r3, r0
     ce8:	000000fc 	strdeq	r0, [r0], -ip
     cec:	03006103 	movweq	r6, #259	; 0x103
     cf0:	00fc0905 	rscseq	r0, ip, r5, lsl #18
     cf4:	03000000 	movweq	r0, #0
     cf8:	06030063 	streq	r0, [r3], -r3, rrx
     cfc:	0000fc09 	andeq	pc, r0, r9, lsl #24
     d00:	6d030400 	cfstrsvs	mvf0, [r3, #-0]
     d04:	03006e69 	movweq	r6, #3689	; 0xe69
     d08:	00fc0907 	rscseq	r0, ip, r7, lsl #18
     d0c:	03080000 	movweq	r0, #32768	; 0x8000
     d10:	0078616d 	rsbseq	r6, r8, sp, ror #2
     d14:	fc090803 	stc2	8, cr0, [r9], {3}
     d18:	0c000000 	stceq	0, cr0, [r0], {-0}
     d1c:	00061804 	andeq	r1, r6, r4, lsl #16
     d20:	09090300 	stmdbeq	r9, {r8, r9}
     d24:	000000fc 	strdeq	r0, [r0], -ip
     d28:	06f70410 	usateq	r0, #23, r0, lsl #8
     d2c:	0b030000 	bleq	c0d34 <__bss_end+0xb4c3c>
     d30:	0000fc09 	andeq	pc, r0, r9, lsl #24
     d34:	f8041400 			; <UNDEFINED> instruction: 0xf8041400
     d38:	03000009 	movweq	r0, #9
     d3c:	00fc090c 	rscseq	r0, ip, ip, lsl #18
     d40:	05180000 	ldreq	r0, [r8, #-0]
     d44:	00000b49 	andeq	r0, r0, r9, asr #22
     d48:	63051003 	movwvs	r1, #20483	; 0x5003
     d4c:	03000007 	movweq	r0, #7
     d50:	01000001 	tsteq	r0, r1
     d54:	000000a2 	andeq	r0, r0, r2, lsr #1
     d58:	000000c1 	andeq	r0, r0, r1, asr #1
     d5c:	00010306 	andeq	r0, r1, r6, lsl #6
     d60:	00fc0700 	rscseq	r0, ip, r0, lsl #14
     d64:	fc070000 	stc2	0, cr0, [r7], {-0}
     d68:	07000000 	streq	r0, [r0, -r0]
     d6c:	000000fc 	strdeq	r0, [r0], -ip
     d70:	0000fc07 	andeq	pc, r0, r7, lsl #24
     d74:	00fc0700 	rscseq	r0, ip, r0, lsl #14
     d78:	05000000 	streq	r0, [r0, #-0]
     d7c:	000004c4 	andeq	r0, r0, r4, asr #9
     d80:	e4091103 	str	r1, [r9], #-259	; 0xfffffefd
     d84:	fc000003 	stc2	0, cr0, [r0], {3}
     d88:	01000000 	mrseq	r0, (UNDEF: 0)
     d8c:	000000da 	ldrdeq	r0, [r0], -sl
     d90:	000000e0 	andeq	r0, r0, r0, ror #1
     d94:	00010306 	andeq	r0, r1, r6, lsl #6
     d98:	da080000 	ble	200da0 <__bss_end+0x1f4ca8>
     d9c:	03000003 	movweq	r0, #3
     da0:	09530b13 	ldmdbeq	r3, {r0, r1, r4, r8, r9, fp}^
     da4:	01090000 	mrseq	r0, (UNDEF: 9)
     da8:	f5010000 			; <UNDEFINED> instruction: 0xf5010000
     dac:	06000000 	streq	r0, [r0], -r0
     db0:	00000103 	andeq	r0, r0, r3, lsl #2
     db4:	04090000 	streq	r0, [r9], #-0
     db8:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
     dbc:	25040a00 	strcs	r0, [r4, #-2560]	; 0xfffff600
     dc0:	0b000000 	bleq	dc8 <shift+0xdc8>
     dc4:	1c9f0404 	cfldrsne	mvf0, [pc], {4}
     dc8:	090c0000 	stmdbeq	ip, {}	; <UNPREDICTABLE>
     dcc:	0b000001 	bleq	dd8 <shift+0xdd8>
     dd0:	08600801 	stmdaeq	r0!, {r0, fp}^
     dd4:	150c0000 	strne	r0, [ip, #-0]
     dd8:	0b000001 	bleq	de4 <shift+0xde4>
     ddc:	08d90502 	ldmeq	r9, {r1, r8, sl}^
     de0:	010b0000 	mrseq	r0, (UNDEF: 11)
     de4:	00085708 	andeq	r5, r8, r8, lsl #14
     de8:	07020b00 	streq	r0, [r2, -r0, lsl #22]
     dec:	0000066a 	andeq	r0, r0, sl, ror #12
     df0:	00097f0d 	andeq	r7, r9, sp, lsl #30
     df4:	07090b00 	streq	r0, [r9, -r0, lsl #22]
     df8:	00000147 	andeq	r0, r0, r7, asr #2
     dfc:	0001360c 	andeq	r3, r1, ip, lsl #12
     e00:	07040b00 	streq	r0, [r4, -r0, lsl #22]
     e04:	00001f98 	muleq	r0, r8, pc	; <UNPREDICTABLE>
     e08:	00059302 	andeq	r9, r5, r2, lsl #6
     e0c:	03040c00 	movweq	r0, #19456	; 0x4c00
     e10:	0001fc07 	andeq	pc, r1, r7, lsl #24
     e14:	0af40400 	beq	ffd01e1c <__bss_end+0xffcf5d24>
     e18:	06040000 	streq	r0, [r4], -r0
     e1c:	0001360e 	andeq	r3, r1, lr, lsl #12
     e20:	75040000 	strvc	r0, [r4, #-0]
     e24:	04000009 	streq	r0, [r0], #-9
     e28:	01360e08 	teqeq	r6, r8, lsl #28
     e2c:	04040000 	streq	r0, [r4], #-0
     e30:	000007f7 	strdeq	r0, [r0], -r7
     e34:	360e0b04 	strcc	r0, [lr], -r4, lsl #22
     e38:	08000001 	stmdaeq	r0, {r0}
     e3c:	00059305 	andeq	r9, r5, r5, lsl #6
     e40:	050d0400 	streq	r0, [sp, #-1024]	; 0xfffffc00
     e44:	0000091f 	andeq	r0, r0, pc, lsl r9
     e48:	000001fc 	strdeq	r0, [r0], -ip
     e4c:	00019b01 	andeq	r9, r1, r1, lsl #22
     e50:	0001a100 	andeq	sl, r1, r0, lsl #2
     e54:	01fc0600 	mvnseq	r0, r0, lsl #12
     e58:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
     e5c:	00000a4b 	andeq	r0, r0, fp, asr #20
     e60:	bb0a0e04 	bllt	284678 <__bss_end+0x278580>
     e64:	01000006 	tsteq	r0, r6
     e68:	000001b6 			; <UNDEFINED> instruction: 0x000001b6
     e6c:	000001bc 			; <UNDEFINED> instruction: 0x000001bc
     e70:	0001fc06 	andeq	pc, r1, r6, lsl #24
     e74:	10050000 	andne	r0, r5, r0
     e78:	04000009 	streq	r0, [r0], #-9
     e7c:	052e0b0f 	streq	r0, [lr, #-2831]!	; 0xfffff4f1
     e80:	02020000 	andeq	r0, r2, #0
     e84:	d5010000 	strle	r0, [r1, #-0]
     e88:	e0000001 	and	r0, r0, r1
     e8c:	06000001 	streq	r0, [r0], -r1
     e90:	000001fc 	strdeq	r0, [r0], -ip
     e94:	00013607 	andeq	r3, r1, r7, lsl #12
     e98:	3b080000 	blcc	200ea0 <__bss_end+0x1f4da8>
     e9c:	0400000a 	streq	r0, [r0], #-10
     ea0:	08a50e10 	stmiaeq	r5!, {r4, r9, sl, fp}
     ea4:	01360000 	teqeq	r6, r0
     ea8:	f5010000 			; <UNDEFINED> instruction: 0xf5010000
     eac:	06000001 	streq	r0, [r0], -r1
     eb0:	000001fc 	strdeq	r0, [r0], -ip
     eb4:	040a0000 	streq	r0, [sl], #-0
     eb8:	0000014e 	andeq	r0, r0, lr, asr #2
     ebc:	6810040f 	ldmdavs	r0, {r0, r1, r2, r3, sl}
     ec0:	15120400 	ldrne	r0, [r2, #-1024]	; 0xfffffc00
     ec4:	0000014e 	andeq	r0, r0, lr, asr #2
     ec8:	00075511 	andeq	r5, r7, r1, lsl r5
     ecc:	14050500 	strne	r0, [r5], #-1280	; 0xfffffb00
     ed0:	00000142 	andeq	r0, r0, r2, asr #2
     ed4:	bf4c0305 	svclt	0x004c0305
     ed8:	c8110000 	ldmdagt	r1, {}	; <UNPREDICTABLE>
     edc:	05000007 	streq	r0, [r0, #-7]
     ee0:	01421406 	cmpeq	r2, r6, lsl #8
     ee4:	03050000 	movweq	r0, #20480	; 0x5000
     ee8:	0000bf50 	andeq	fp, r0, r0, asr pc
     eec:	00071e11 	andeq	r1, r7, r1, lsl lr
     ef0:	1a070600 	bne	1c26f8 <__bss_end+0x1b6600>
     ef4:	00000142 	andeq	r0, r0, r2, asr #2
     ef8:	bf540305 	svclt	0x00540305
     efc:	a1110000 	tstge	r1, r0
     f00:	06000004 	streq	r0, [r0], -r4
     f04:	01421a09 	cmpeq	r2, r9, lsl #20
     f08:	03050000 	movweq	r0, #20480	; 0x5000
     f0c:	0000bf58 	andeq	fp, r0, r8, asr pc
     f10:	00082c11 	andeq	r2, r8, r1, lsl ip
     f14:	1a0b0600 	bne	2c271c <__bss_end+0x2b6624>
     f18:	00000142 	andeq	r0, r0, r2, asr #2
     f1c:	bf5c0305 	svclt	0x005c0305
     f20:	57110000 	ldrpl	r0, [r1, -r0]
     f24:	06000006 	streq	r0, [r0], -r6
     f28:	01421a0d 	cmpeq	r2, sp, lsl #20
     f2c:	03050000 	movweq	r0, #20480	; 0x5000
     f30:	0000bf60 	andeq	fp, r0, r0, ror #30
     f34:	00052411 	andeq	r2, r5, r1, lsl r4
     f38:	1a0f0600 	bne	3c2740 <__bss_end+0x3b6648>
     f3c:	00000142 	andeq	r0, r0, r2, asr #2
     f40:	bf640305 	svclt	0x00640305
     f44:	010b0000 	mrseq	r0, (UNDEF: 11)
     f48:	0006b602 	andeq	fp, r6, r2, lsl #12
     f4c:	1c040a00 			; <UNDEFINED> instruction: 0x1c040a00
     f50:	11000001 	tstne	r0, r1
     f54:	000005a0 	andeq	r0, r0, r0, lsr #11
     f58:	42140407 	andsmi	r0, r4, #117440512	; 0x7000000
     f5c:	05000001 	streq	r0, [r0, #-1]
     f60:	00bf6803 	adcseq	r6, pc, r3, lsl #16
     f64:	03371100 	teqeq	r7, #0, 2
     f68:	07070000 	streq	r0, [r7, -r0]
     f6c:	00014214 	andeq	r4, r1, r4, lsl r2
     f70:	6c030500 	cfstr32vs	mvfx0, [r3], {-0}
     f74:	110000bf 	strhne	r0, [r0, -pc]
     f78:	000004f6 	strdeq	r0, [r0], -r6
     f7c:	42140a07 	andsmi	r0, r4, #28672	; 0x7000
     f80:	05000001 	streq	r0, [r0, #-1]
     f84:	00bf7003 	adcseq	r7, pc, r3
     f88:	07040b00 	streq	r0, [r4, -r0, lsl #22]
     f8c:	00001f93 	muleq	r0, r3, pc	; <UNPREDICTABLE>
     f90:	000ac611 	andeq	ip, sl, r1, lsl r6
     f94:	140a0800 	strne	r0, [sl], #-2048	; 0xfffff800
     f98:	00000142 	andeq	r0, r0, r2, asr #2
     f9c:	bf740305 	svclt	0x00740305
     fa0:	18120000 	ldmdane	r2, {}	; <UNPREDICTABLE>
     fa4:	0c00000b 	stceq	0, cr0, [r0], {11}
     fa8:	07070901 	streq	r0, [r7, -r1, lsl #18]
     fac:	0000045d 	andeq	r0, r0, sp, asr r4
     fb0:	000aa613 	andeq	sl, sl, r3, lsl r6
     fb4:	1b090900 	blne	2433bc <__bss_end+0x2372c4>
     fb8:	00000142 	andeq	r0, r0, r2, asr #2
     fbc:	03600480 	cmneq	r0, #128, 8	; 0x80000000
     fc0:	0b090000 	bleq	240fc8 <__bss_end+0x234ed0>
     fc4:	0001360e 	andeq	r3, r1, lr, lsl #12
     fc8:	6c040000 	stcvs	0, cr0, [r4], {-0}
     fcc:	09000004 	stmdbeq	r0, {r2}
     fd0:	01360e0c 	teqeq	r6, ip, lsl #28
     fd4:	04040000 	streq	r0, [r4], #-0
     fd8:	00000d09 	andeq	r0, r0, r9, lsl #26
     fdc:	5d0a0f09 	stcpl	15, cr0, [sl, #-36]	; 0xffffffdc
     fe0:	08000004 	stmdaeq	r0, {r2}
     fe4:	0008e804 	andeq	lr, r8, r4, lsl #16
     fe8:	0e100900 	vnmlseq.f16	s0, s0, s0	; <UNPREDICTABLE>
     fec:	00000136 	andeq	r0, r0, r6, lsr r1
     ff0:	0ad50488 	beq	ff542218 <__bss_end+0xff536120>
     ff4:	12090000 	andne	r0, r9, #0
     ff8:	00045d0a 	andeq	r5, r4, sl, lsl #26
     ffc:	16148c00 	ldrne	r8, [r4], -r0, lsl #24
    1000:	09000009 	stmdbeq	r0, {r0, r3}
    1004:	048b0a13 	streq	r0, [fp], #2579	; 0xa13
    1008:	03580000 	cmpeq	r8, #0
    100c:	03630000 	cmneq	r3, #0
    1010:	6d060000 	stcvs	0, cr0, [r6, #-0]
    1014:	07000004 	streq	r0, [r0, -r4]
    1018:	00000115 	andeq	r0, r0, r5, lsl r1
    101c:	08061400 	stmdaeq	r6, {sl, ip}
    1020:	14090000 	strne	r0, [r9], #-0
    1024:	00056b0a 	andeq	r6, r5, sl, lsl #22
    1028:	00037700 	andeq	r7, r3, r0, lsl #14
    102c:	00038200 	andeq	r8, r3, r0, lsl #4
    1030:	046d0600 	strbteq	r0, [sp], #-1536	; 0xfffffa00
    1034:	36070000 	strcc	r0, [r7], -r0
    1038:	00000001 	andeq	r0, r0, r1
    103c:	000bc215 	andeq	ip, fp, r5, lsl r2
    1040:	0a150900 	beq	543448 <__bss_end+0x537350>
    1044:	00000a58 	andeq	r0, r0, r8, asr sl
    1048:	0000028c 	andeq	r0, r0, ip, lsl #5
    104c:	0000039a 	muleq	r0, sl, r3
    1050:	000003a0 	andeq	r0, r0, r0, lsr #7
    1054:	00046d06 	andeq	r6, r4, r6, lsl #26
    1058:	04150000 	ldreq	r0, [r5], #-0
    105c:	09000004 	stmdbeq	r0, {r2}
    1060:	0a150a16 	beq	5438c0 <__bss_end+0x5377c8>
    1064:	028c0000 	addeq	r0, ip, #0
    1068:	03b80000 			; <UNDEFINED> instruction: 0x03b80000
    106c:	03be0000 			; <UNDEFINED> instruction: 0x03be0000
    1070:	6d060000 	stcvs	0, cr0, [r6, #-0]
    1074:	00000004 	andeq	r0, r0, r4
    1078:	000b1805 	andeq	r1, fp, r5, lsl #16
    107c:	05180900 	ldreq	r0, [r8, #-2304]	; 0xfffff700
    1080:	00000b1f 	andeq	r0, r0, pc, lsl fp
    1084:	0000046d 	andeq	r0, r0, sp, ror #8
    1088:	0003d701 	andeq	sp, r3, r1, lsl #14
    108c:	0003e200 	andeq	lr, r3, r0, lsl #4
    1090:	046d0600 	strbteq	r0, [sp], #-1536	; 0xfffffa00
    1094:	36070000 	strcc	r0, [r7], -r0
    1098:	00000001 	andeq	r0, r0, r1
    109c:	0008ca05 	andeq	ip, r8, r5, lsl #20
    10a0:	0b190900 	bleq	6434a8 <__bss_end+0x6373b0>
    10a4:	0000083a 	andeq	r0, r0, sl, lsr r8
    10a8:	00000473 	andeq	r0, r0, r3, ror r4
    10ac:	0003fb01 	andeq	pc, r3, r1, lsl #22
    10b0:	00040100 	andeq	r0, r4, r0, lsl #2
    10b4:	046d0600 	strbteq	r0, [sp], #-1536	; 0xfffffa00
    10b8:	05000000 	streq	r0, [r0, #-0]
    10bc:	000007d4 	ldrdeq	r0, [r0], -r4
    10c0:	d20b1a09 	andle	r1, fp, #36864	; 0x9000
    10c4:	73000009 	movwvc	r0, #9
    10c8:	01000004 	tsteq	r0, r4
    10cc:	0000041a 	andeq	r0, r0, sl, lsl r4
    10d0:	00000425 	andeq	r0, r0, r5, lsr #8
    10d4:	00046d06 	andeq	r6, r4, r6, lsl #26
    10d8:	00fc0700 	rscseq	r0, ip, r0, lsl #14
    10dc:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    10e0:	0000067d 	andeq	r0, r0, sp, ror r6
    10e4:	9c0a1b09 			; <UNDEFINED> instruction: 0x9c0a1b09
    10e8:	01000009 	tsteq	r0, r9
    10ec:	0000043a 	andeq	r0, r0, sl, lsr r4
    10f0:	00000440 	andeq	r0, r0, r0, asr #8
    10f4:	00046d06 	andeq	r6, r4, r6, lsl #26
    10f8:	ab160000 	blge	581100 <__bss_end+0x575008>
    10fc:	09000006 	stmdbeq	r0, {r1, r2}
    1100:	03bf0a1c 			; <UNDEFINED> instruction: 0x03bf0a1c
    1104:	51010000 	mrspl	r0, (UNDEF: 1)
    1108:	06000004 	streq	r0, [r0], -r4
    110c:	0000046d 	andeq	r0, r0, sp, ror #8
    1110:	00029307 	andeq	r9, r2, r7, lsl #6
    1114:	17000000 	strne	r0, [r0, -r0]
    1118:	00000115 	andeq	r0, r0, r5, lsl r1
    111c:	0000046d 	andeq	r0, r0, sp, ror #8
    1120:	00014718 	andeq	r4, r1, r8, lsl r7
    1124:	0a007f00 	beq	20d2c <__bss_end+0x14c34>
    1128:	0002e804 	andeq	lr, r2, r4, lsl #16
    112c:	15040a00 	strne	r0, [r4, #-2560]	; 0xfffff600
    1130:	19000001 	stmdbne	r0, {r0}
    1134:	0000060e 	andeq	r0, r0, lr, lsl #12
    1138:	080f0a1c 	stmdaeq	pc, {r2, r3, r4, r9, fp}	; <UNPREDICTABLE>
    113c:	000004ae 	andeq	r0, r0, lr, lsr #9
    1140:	00040c04 	andeq	r0, r4, r4, lsl #24
    1144:	0b110a00 	bleq	44394c <__bss_end+0x437854>
    1148:	000004ae 	andeq	r0, r0, lr, lsr #9
    114c:	0a0d0400 	beq	342154 <__bss_end+0x33605c>
    1150:	130a0000 	movwne	r0, #40960	; 0xa000
    1154:	0001090b 	andeq	r0, r1, fp, lsl #18
    1158:	42041400 	andmi	r1, r4, #0, 8
    115c:	0a000003 	beq	1170 <shift+0x1170>
    1160:	04be0c15 	ldrteq	r0, [lr], #3093	; 0xc15
    1164:	00180000 	andseq	r0, r8, r0
    1168:	00010917 	andeq	r0, r1, r7, lsl r9
    116c:	0004be00 	andeq	fp, r4, r0, lsl #28
    1170:	01471800 	cmpeq	r7, r0, lsl #16
    1174:	00040000 	andeq	r0, r4, r0
    1178:	0109040a 	tsteq	r9, sl, lsl #8
    117c:	6d020000 	stcvs	0, cr0, [r2, #-0]
    1180:	3c000003 	stccc	0, cr0, [r0], {3}
    1184:	0a071b0a 	beq	1c7db4 <__bss_end+0x1bbcbc>
    1188:	04000008 	streq	r0, [r0], #-8
    118c:	00000b91 	muleq	r0, r1, fp
    1190:	fc091f0a 	stc2	15, cr1, [r9], {10}
    1194:	00000000 	andeq	r0, r0, r0
    1198:	000b4204 	andeq	r4, fp, r4, lsl #4
    119c:	09210a00 	stmdbeq	r1!, {r9, fp}
    11a0:	000000fc 	strdeq	r0, [r0], -ip
    11a4:	0ae00404 	beq	ff8021bc <__bss_end+0xff7f60c4>
    11a8:	230a0000 	movwcs	r0, #40960	; 0xa000
    11ac:	0000fc09 	andeq	pc, r0, r9, lsl #24
    11b0:	2e040800 	cdpcs	8, 0, cr0, cr4, cr0, {0}
    11b4:	0a00000b 	beq	11e8 <shift+0x11e8>
    11b8:	00fc0924 	rscseq	r0, ip, r4, lsr #18
    11bc:	1a0c0000 	bne	3011c4 <__bss_end+0x2f50cc>
    11c0:	00000a2a 	andeq	r0, r0, sl, lsr #20
    11c4:	101c260a 	andsne	r2, ip, sl, lsl #12
    11c8:	04000001 	streq	r0, [r0], #-1
    11cc:	37422e45 	strbcc	r2, [r2, -r5, asr #28]
    11d0:	00071204 	andeq	r1, r7, r4, lsl #4
    11d4:	09280a00 	stmdbeq	r8!, {r9, fp}
    11d8:	000000fc 	strdeq	r0, [r0], -ip
    11dc:	08940410 	ldmeq	r4, {r4, sl}
    11e0:	2a0a0000 	bcs	2811e8 <__bss_end+0x2750f0>
    11e4:	0000fc09 	andeq	pc, r0, r9, lsl #24
    11e8:	7a041400 	bvc	1061f0 <__bss_end+0xfa0f8>
    11ec:	0a000004 	beq	1204 <shift+0x1204>
    11f0:	028c0a2c 	addeq	r0, ip, #44, 20	; 0x2c000
    11f4:	04180000 	ldreq	r0, [r8], #-0
    11f8:	000009af 	andeq	r0, r0, pc, lsr #19
    11fc:	fc092e0a 	stc2	14, cr2, [r9], {10}
    1200:	1c000000 	stcne	0, cr0, [r0], {-0}
    1204:	00068e04 	andeq	r8, r6, r4, lsl #28
    1208:	09300a00 	ldmdbeq	r0!, {r9, fp}
    120c:	000000fc 	strdeq	r0, [r0], -ip
    1210:	08210420 	stmdaeq	r1!, {r5, sl}
    1214:	320a0000 	andcc	r0, sl, #0
    1218:	00080a11 	andeq	r0, r8, r1, lsl sl
    121c:	85042400 	strhi	r2, [r4, #-1024]	; 0xfffffc00
    1220:	0a000004 	beq	1238 <shift+0x1238>
    1224:	08101034 	ldmdaeq	r0, {r2, r4, r5, ip}
    1228:	04280000 	strteq	r0, [r8], #-0
    122c:	000006e4 	andeq	r0, r0, r4, ror #13
    1230:	0317360a 	tsteq	r7, #10485760	; 0xa00000
    1234:	2c000001 	stccs	0, cr0, [r0], {1}
    1238:	72666203 	rsbvc	r6, r6, #805306368	; 0x30000000
    123c:	0d380a00 	vldmdbeq	r8!, {s0-s-1}
    1240:	0000046d 	andeq	r0, r0, sp, ror #8
    1244:	04cc0430 	strbeq	r0, [ip], #1072	; 0x430
    1248:	3b0a0000 	blcc	281250 <__bss_end+0x275158>
    124c:	0001090b 	andeq	r0, r1, fp, lsl #18
    1250:	51043400 	tstpl	r4, r0, lsl #8
    1254:	0a00000c 	beq	128c <shift+0x128c>
    1258:	04be0c3e 	ldrteq	r0, [lr], #3134	; 0xc3e
    125c:	15380000 	ldrne	r0, [r8, #-0]!
    1260:	00000bcb 	andeq	r0, r0, fp, asr #23
    1264:	340a400a 	strcc	r4, [sl], #-10
    1268:	8c000007 	stchi	0, cr0, [r0], {7}
    126c:	bd000002 	stclt	0, cr0, [r0, #-8]
    1270:	c3000005 	movwgt	r0, #5
    1274:	06000005 	streq	r0, [r0], -r5
    1278:	00000816 	andeq	r0, r0, r6, lsl r8
    127c:	08ed1500 	stmiaeq	sp!, {r8, sl, ip}^
    1280:	420a0000 	andmi	r0, sl, #0
    1284:	00079f0b 	andeq	r9, r7, fp, lsl #30
    1288:	00010900 	andeq	r0, r1, r0, lsl #18
    128c:	0005db00 	andeq	sp, r5, r0, lsl #22
    1290:	0005e600 	andeq	lr, r5, r0, lsl #12
    1294:	08160600 	ldmdaeq	r6, {r9, sl}
    1298:	10070000 	andne	r0, r7, r0
    129c:	00000008 	andeq	r0, r0, r8
    12a0:	00035b14 	andeq	r5, r3, r4, lsl fp
    12a4:	0a440a00 	beq	1103aac <__bss_end+0x10f79b4>
    12a8:	000004b3 			; <UNDEFINED> instruction: 0x000004b3
    12ac:	000005fa 	strdeq	r0, [r0], -sl
    12b0:	00000600 	andeq	r0, r0, r0, lsl #12
    12b4:	00081606 	andeq	r1, r8, r6, lsl #12
    12b8:	ff140000 			; <UNDEFINED> instruction: 0xff140000
    12bc:	0a000008 	beq	12e4 <shift+0x12e4>
    12c0:	06390a46 	ldrteq	r0, [r9], -r6, asr #20
    12c4:	06140000 	ldreq	r0, [r4], -r0
    12c8:	061a0000 	ldreq	r0, [sl], -r0
    12cc:	16060000 	strne	r0, [r6], -r0
    12d0:	00000008 	andeq	r0, r0, r8
    12d4:	00070714 	andeq	r0, r7, r4, lsl r7
    12d8:	0a480a00 	beq	1203ae0 <__bss_end+0x11f79e8>
    12dc:	00000445 	andeq	r0, r0, r5, asr #8
    12e0:	0000062e 	andeq	r0, r0, lr, lsr #12
    12e4:	00000634 	andeq	r0, r0, r4, lsr r6
    12e8:	00081606 	andeq	r1, r8, r6, lsl #12
    12ec:	ca150000 	bgt	5412f4 <__bss_end+0x5351fc>
    12f0:	0a000005 	beq	130c <shift+0x130c>
    12f4:	08700b4a 	ldmdaeq	r0!, {r1, r3, r6, r8, r9, fp}^
    12f8:	01090000 	mrseq	r0, (UNDEF: 9)
    12fc:	064c0000 	strbeq	r0, [ip], -r0
    1300:	065c0000 	ldrbeq	r0, [ip], -r0
    1304:	16060000 	strne	r0, [r6], -r0
    1308:	07000008 	streq	r0, [r0, -r8]
    130c:	000004be 			; <UNDEFINED> instruction: 0x000004be
    1310:	00010907 	andeq	r0, r1, r7, lsl #18
    1314:	9a150000 	bls	54131c <__bss_end+0x535224>
    1318:	0a000006 	beq	1338 <shift+0x1338>
    131c:	050f0b4c 	streq	r0, [pc, #-2892]	; 7d8 <shift+0x7d8>
    1320:	01090000 	mrseq	r0, (UNDEF: 9)
    1324:	06740000 	ldrbteq	r0, [r4], -r0
    1328:	06890000 	streq	r0, [r9], r0
    132c:	16060000 	strne	r0, [r6], -r0
    1330:	07000008 	streq	r0, [r0, -r8]
    1334:	00000109 	andeq	r0, r0, r9, lsl #2
    1338:	00010907 	andeq	r0, r1, r7, lsl #18
    133c:	01090700 	tsteq	r9, r0, lsl #14
    1340:	14000000 	strne	r0, [r0], #-0
    1344:	000006a1 	andeq	r0, r0, r1, lsr #13
    1348:	f80a4e0a 			; <UNDEFINED> instruction: 0xf80a4e0a
    134c:	9d000005 	stcls	0, cr0, [r0, #-20]	; 0xffffffec
    1350:	a8000006 	stmdage	r0, {r1, r2}
    1354:	06000006 	streq	r0, [r0], -r6
    1358:	00000816 	andeq	r0, r0, r6, lsl r8
    135c:	00081007 	andeq	r1, r8, r7
    1360:	53140000 	tstpl	r4, #0
    1364:	0a000003 	beq	1378 <shift+0x1378>
    1368:	03840a50 	orreq	r0, r4, #80, 20	; 0x50000
    136c:	06bc0000 	ldrteq	r0, [ip], r0
    1370:	06c70000 	strbeq	r0, [r7], r0
    1374:	16060000 	strne	r0, [r6], -r0
    1378:	07000008 	streq	r0, [r0, -r8]
    137c:	00000810 	andeq	r0, r0, r0, lsl r8
    1380:	06d41400 	ldrbeq	r1, [r4], r0, lsl #8
    1384:	520a0000 	andpl	r0, sl, #0
    1388:	000a7e0a 	andeq	r7, sl, sl, lsl #28
    138c:	0006db00 	andeq	sp, r6, r0, lsl #22
    1390:	0006e600 	andeq	lr, r6, r0, lsl #12
    1394:	08160600 	ldmdaeq	r6, {r9, sl}
    1398:	0a070000 	beq	1c13a0 <__bss_end+0x1b52a8>
    139c:	00000008 	andeq	r0, r0, r8
    13a0:	000ab214 	andeq	fp, sl, r4, lsl r2
    13a4:	0a540a00 	beq	1503bac <__bss_end+0x14f7ab4>
    13a8:	000004d6 	ldrdeq	r0, [r0], -r6
    13ac:	000006fa 	strdeq	r0, [r0], -sl
    13b0:	00000705 	andeq	r0, r0, r5, lsl #14
    13b4:	00081606 	andeq	r1, r8, r6, lsl #12
    13b8:	080a0700 	stmdaeq	sl, {r8, r9, sl}
    13bc:	14000000 	strne	r0, [r0], #-0
    13c0:	000006eb 	andeq	r0, r0, fp, ror #13
    13c4:	df0a560a 	svcle	0x000a560a
    13c8:	19000005 	stmdbne	r0, {r0, r2}
    13cc:	1f000007 	svcne	0x00000007
    13d0:	06000007 	streq	r0, [r0], -r7
    13d4:	00000816 	andeq	r0, r0, r6, lsl r8
    13d8:	09881400 	stmibeq	r8, {sl, ip}
    13dc:	580a0000 	stmdapl	sl, {}	; <UNPREDICTABLE>
    13e0:	0005480a 	andeq	r4, r5, sl, lsl #16
    13e4:	00073300 	andeq	r3, r7, r0, lsl #6
    13e8:	00073e00 	andeq	r3, r7, r0, lsl #28
    13ec:	08160600 	ldmdaeq	r6, {r9, sl}
    13f0:	93070000 	movwls	r0, #28672	; 0x7000
    13f4:	00000002 	andeq	r0, r0, r2
    13f8:	000a6e15 	andeq	r6, sl, r5, lsl lr
    13fc:	0a5a0a00 	beq	1683c04 <__bss_end+0x1677b0c>
    1400:	000003a2 	andeq	r0, r0, r2, lsr #7
    1404:	0000028c 	andeq	r0, r0, ip, lsl #5
    1408:	00000756 	andeq	r0, r0, r6, asr r7
    140c:	00000761 	andeq	r0, r0, r1, ror #14
    1410:	00081606 	andeq	r1, r8, r6, lsl #12
    1414:	01090700 	tsteq	r9, r0, lsl #14
    1418:	14000000 	strne	r0, [r0], #-0
    141c:	00000582 	andeq	r0, r0, r2, lsl #11
    1420:	810a5c0a 	tsthi	sl, sl, lsl #24
    1424:	75000007 	strvc	r0, [r0, #-7]
    1428:	7b000007 	blvc	144c <shift+0x144c>
    142c:	06000007 	streq	r0, [r0], -r7
    1430:	00000816 	andeq	r0, r0, r6, lsl r8
    1434:	036d0500 	cmneq	sp, #0, 10
    1438:	610a0000 	mrsvs	r0, (UNDEF: 10)
    143c:	000bdf05 	andeq	sp, fp, r5, lsl #30
    1440:	00081600 	andeq	r1, r8, r0, lsl #12
    1444:	07940100 	ldreq	r0, [r4, r0, lsl #2]
    1448:	07b30000 	ldreq	r0, [r3, r0]!
    144c:	16060000 	strne	r0, [r6], -r0
    1450:	07000008 	streq	r0, [r0, -r8]
    1454:	000000fc 	strdeq	r0, [r0], -ip
    1458:	0000fc07 	andeq	pc, r0, r7, lsl #24
    145c:	00fc0700 	rscseq	r0, ip, r0, lsl #14
    1460:	fc070000 	stc2	0, cr0, [r7], {-0}
    1464:	07000000 	streq	r0, [r0, -r0]
    1468:	000000fc 	strdeq	r0, [r0], -ip
    146c:	06830e00 	streq	r0, [r3], r0, lsl #28
    1470:	640a0000 	strvs	r0, [sl], #-0
    1474:	000b000a 	andeq	r0, fp, sl
    1478:	07c80100 	strbeq	r0, [r8, r0, lsl #2]
    147c:	07d30000 	ldrbeq	r0, [r3, r0]
    1480:	16060000 	strne	r0, [r6], -r0
    1484:	07000008 	streq	r0, [r0, -r8]
    1488:	0000046d 	andeq	r0, r0, sp, ror #8
    148c:	04340500 	ldrteq	r0, [r4], #-1280	; 0xfffffb00
    1490:	660a0000 	strvs	r0, [sl], -r0
    1494:	0009350c 	andeq	r3, r9, ip, lsl #10
    1498:	0004be00 	andeq	fp, r4, r0, lsl #28
    149c:	07ec0100 	strbeq	r0, [ip, r0, lsl #2]!
    14a0:	07f20000 	ldrbeq	r0, [r2, r0]!
    14a4:	16060000 	strne	r0, [r6], -r0
    14a8:	00000008 	andeq	r0, r0, r8
    14ac:	6e75521b 	mrcvs	2, 3, r5, cr5, cr11, {0}
    14b0:	0a680a00 	beq	1a03cb8 <__bss_end+0x19f7bc0>
    14b4:	0000061d 	andeq	r0, r0, sp, lsl r6
    14b8:	00080301 	andeq	r0, r8, r1, lsl #6
    14bc:	08160600 	ldmdaeq	r6, {r9, sl}
    14c0:	00000000 	andeq	r0, r0, r0
    14c4:	0810040a 	ldmdaeq	r0, {r1, r3, sl}
    14c8:	040a0000 	streq	r0, [sl], #-0
    14cc:	00000479 	andeq	r0, r0, r9, ror r4
    14d0:	04c4040a 	strbeq	r0, [r4], #1034	; 0x40a
    14d4:	160c0000 	strne	r0, [ip], -r0
    14d8:	1c000008 	stcne	0, cr0, [r0], {8}
    14dc:	000007f2 	strdeq	r0, [r0], -r2
    14e0:	06010702 	streq	r0, [r1], -r2, lsl #14
    14e4:	0000083c 	andeq	r0, r0, ip, lsr r8
    14e8:	00009644 	andeq	r9, r0, r4, asr #12
    14ec:	000002e0 	andeq	r0, r0, r0, ror #5
    14f0:	08e79c01 	stmiaeq	r7!, {r0, sl, fp, ip, pc}^
    14f4:	411d0000 	tstmi	sp, r0
    14f8:	1c00000c 	stcne	0, cr0, [r0], {12}
    14fc:	02000008 	andeq	r0, r0, #8
    1500:	a61e4491 			; <UNDEFINED> instruction: 0xa61e4491
    1504:	0200000c 	andeq	r0, r0, #12
    1508:	e70a0108 	str	r0, [sl, -r8, lsl #2]
    150c:	02000008 	andeq	r0, r0, #8
    1510:	541f4c91 	ldrpl	r4, [pc], #-3217	; 1518 <shift+0x1518>
    1514:	b8000096 	stmdalt	r0, {r1, r2, r4, r7}
    1518:	1e000002 	cdpne	0, 0, cr0, cr0, cr2, {0}
    151c:	00000c46 	andeq	r0, r0, r6, asr #24
    1520:	0e011102 	adfeqs	f1, f1, f2
    1524:	0000028c 	andeq	r0, r0, ip, lsl #5
    1528:	1e779102 	expnes	f1, f2
    152c:	00000d10 	andeq	r0, r0, r0, lsl sp
    1530:	0f014202 	svceq	0x00014202
    1534:	00000109 	andeq	r0, r0, r9, lsl #2
    1538:	1f609102 	svcne	0x00609102
    153c:	00009698 	muleq	r0, r8, r6
    1540:	000001d0 	ldrdeq	r0, [r0], -r0	; <UNPREDICTABLE>
    1544:	02006920 	andeq	r6, r0, #32, 18	; 0x80000
    1548:	fc110114 	ldc2	1, cr0, [r1], {20}
    154c:	02000000 	andeq	r0, r0, #0
    1550:	cc217091 	stcgt	0, cr7, [r1], #-580	; 0xfffffdbc
    1554:	e0000096 	mul	r0, r6, r0
    1558:	cc000000 	stcgt	0, cr0, [r0], {-0}
    155c:	20000008 	andcs	r0, r0, r8
    1560:	17020069 	strne	r0, [r2, -r9, rrx]
    1564:	00fc1501 	rscseq	r1, ip, r1, lsl #10
    1568:	91020000 	mrsls	r0, (UNDEF: 2)
    156c:	96e81f6c 	strbtls	r1, [r8], ip, ror #30
    1570:	00b40000 	adcseq	r0, r4, r0
    1574:	66200000 	strtvs	r0, [r0], -r0
    1578:	011b0200 	tsteq	fp, r0, lsl #4
    157c:	00010917 	andeq	r0, r1, r7, lsl r9
    1580:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    1584:	241f0000 	ldrcs	r0, [pc], #-0	; 158c <shift+0x158c>
    1588:	28000098 	stmdacs	r0, {r3, r4, r7}
    158c:	20000000 	andcs	r0, r0, r0
    1590:	3b020069 	blcc	8173c <__bss_end+0x75644>
    1594:	00fc1101 	rscseq	r1, ip, r1, lsl #2
    1598:	91020000 	mrsls	r0, (UNDEF: 2)
    159c:	00000068 	andeq	r0, r0, r8, rrx
    15a0:	01151700 	tsteq	r5, r0, lsl #14
    15a4:	08f70000 	ldmeq	r7!, {}^	; <UNPREDICTABLE>
    15a8:	47180000 	ldrmi	r0, [r8, -r0]
    15ac:	13000001 	movwne	r0, #1
    15b0:	07051c00 	streq	r1, [r5, -r0, lsl #24]
    15b4:	02020000 	andeq	r0, r2, #0
    15b8:	09120601 	ldmdbeq	r2, {r0, r9, sl}
    15bc:	96100000 	ldrls	r0, [r0], -r0
    15c0:	00340000 	eorseq	r0, r4, r0
    15c4:	9c010000 	stcls	0, cr0, [r1], {-0}
    15c8:	0000091f 	andeq	r0, r0, pc, lsl r9
    15cc:	000c411d 	andeq	r4, ip, sp, lsl r1
    15d0:	00081c00 	andeq	r1, r8, r0, lsl #24
    15d4:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    15d8:	06e62200 	strbteq	r2, [r6], r0, lsl #4
    15dc:	fb020000 	blx	815e6 <__bss_end+0x754ee>
    15e0:	00093906 	andeq	r3, r9, r6, lsl #18
    15e4:	00954c00 	addseq	r4, r5, r0, lsl #24
    15e8:	0000c400 	andeq	ip, r0, r0, lsl #8
    15ec:	7b9c0100 	blvc	fe7019f4 <__bss_end+0xfe6f58fc>
    15f0:	1d000009 	stcne	0, cr0, [r0, #-36]	; 0xffffffdc
    15f4:	00000c41 	andeq	r0, r0, r1, asr #24
    15f8:	0000081c 	andeq	r0, r0, ip, lsl r8
    15fc:	23649102 	cmncs	r4, #-2147483648	; 0x80000000
    1600:	00000821 	andeq	r0, r0, r1, lsr #16
    1604:	0a22fb02 	beq	8c0214 <__bss_end+0x8b411c>
    1608:	02000008 	andeq	r0, r0, #8
    160c:	f8246091 			; <UNDEFINED> instruction: 0xf8246091
    1610:	0200000b 	andeq	r0, r0, #11
    1614:	00fc09fc 	ldrshteq	r0, [ip], #156	; 0x9c
    1618:	91020000 	mrsls	r0, (UNDEF: 2)
    161c:	959c1f68 	ldrls	r1, [ip, #3944]	; 0xf68
    1620:	00640000 	rsbeq	r0, r4, r0
    1624:	69250000 	stmdbvs	r5!, {}	; <UNPREDICTABLE>
    1628:	0dfd0200 	lfmeq	f0, 2, [sp]
    162c:	000000fc 	strdeq	r0, [r0], -ip
    1630:	006c9102 	rsbeq	r9, ip, r2, lsl #2
    1634:	061a2200 	ldreq	r2, [sl], -r0, lsl #4
    1638:	e2020000 	and	r0, r2, #0
    163c:	00099506 	andeq	r9, r9, r6, lsl #10
    1640:	00943c00 	addseq	r3, r4, r0, lsl #24
    1644:	00011000 	andeq	r1, r1, r0
    1648:	da9c0100 	ble	fe701a50 <__bss_end+0xfe6f5958>
    164c:	1d000009 	stcne	0, cr0, [r0, #-36]	; 0xffffffdc
    1650:	00000c41 	andeq	r0, r0, r1, asr #24
    1654:	0000081c 	andeq	r0, r0, ip, lsl r8
    1658:	24649102 	strbtcs	r9, [r4], #-258	; 0xfffffefe
    165c:	00001276 	andeq	r1, r0, r6, ror r2
    1660:	730be302 	movwvc	lr, #45826	; 0xb302
    1664:	02000004 	andeq	r0, r0, #4
    1668:	18247491 	stmdane	r4!, {r0, r4, r7, sl, ip, sp, lr}
    166c:	02000022 	andeq	r0, r0, #34	; 0x22
    1670:	00fc09e7 	rscseq	r0, ip, r7, ror #19
    1674:	91020000 	mrsls	r0, (UNDEF: 2)
    1678:	00662570 	rsbeq	r2, r6, r0, ror r5
    167c:	090be802 	stmdbeq	fp, {r1, fp, sp, lr, pc}
    1680:	02000001 	andeq	r0, r0, #1
    1684:	69256c91 	stmdbvs	r5!, {r0, r4, r7, sl, fp, sp, lr}
    1688:	09e90200 	stmibeq	r9!, {r9}^
    168c:	000000fc 	strdeq	r0, [r0], -ip
    1690:	00689102 	rsbeq	r9, r8, r2, lsl #2
    1694:	00071f22 	andeq	r1, r7, r2, lsr #30
    1698:	06d00200 	ldrbeq	r0, [r0], r0, lsl #4
    169c:	000009f4 	strdeq	r0, [r0], -r4
    16a0:	00009354 	andeq	r9, r0, r4, asr r3
    16a4:	000000e8 	andeq	r0, r0, r8, ror #1
    16a8:	0a109c01 	beq	4286b4 <__bss_end+0x41c5bc>
    16ac:	411d0000 	tstmi	sp, r0
    16b0:	1c00000c 	stcne	0, cr0, [r0], {12}
    16b4:	02000008 	andeq	r0, r0, #8
    16b8:	73267491 			; <UNDEFINED> instruction: 0x73267491
    16bc:	02007274 	andeq	r7, r0, #116, 4	; 0x40000007
    16c0:	02932dd0 	addseq	r2, r3, #208, 26	; 0x3400
    16c4:	91020000 	mrsls	r0, (UNDEF: 2)
    16c8:	c7220070 			; <UNDEFINED> instruction: 0xc7220070
    16cc:	02000006 	andeq	r0, r0, #6
    16d0:	0a2a06aa 	beq	a83180 <__bss_end+0xa77088>
    16d4:	909c0000 	addsls	r0, ip, r0
    16d8:	02b80000 	adcseq	r0, r8, #0
    16dc:	9c010000 	stcls	0, cr0, [r1], {-0}
    16e0:	00000b30 	andeq	r0, r0, r0, lsr fp
    16e4:	000c411d 	andeq	r4, ip, sp, lsl r1
    16e8:	00081c00 	andeq	r1, r8, r0, lsl #24
    16ec:	bc910300 	ldclt	3, cr0, [r1], {0}
    16f0:	0821237f 	stmdaeq	r1!, {r0, r1, r2, r3, r4, r5, r6, r8, r9, sp}
    16f4:	aa020000 	bge	816fc <__bss_end+0x75604>
    16f8:	00080a29 	andeq	r0, r8, r9, lsr #20
    16fc:	b8910300 	ldmlt	r1, {r8, r9}
    1700:	0c92247f 	cfldrseq	mvf2, [r2], {127}	; 0x7f
    1704:	ac020000 	stcge	0, cr0, [r2], {-0}
    1708:	0000fc09 	andeq	pc, r0, r9, lsl #24
    170c:	58910200 	ldmpl	r1, {r9}
    1710:	000cea24 	andeq	lr, ip, r4, lsr #20
    1714:	0aae0200 	beq	feb81f1c <__bss_end+0xfeb75e24>
    1718:	0000028c 	andeq	r0, r0, ip, lsl #5
    171c:	24579102 	ldrbcs	r9, [r7], #-258	; 0xfffffefe
    1720:	0000194e 	andeq	r1, r0, lr, asr #18
    1724:	fc09b202 	stc2	2, cr11, [r9], {2}
    1728:	02000000 	andeq	r0, r0, #0
    172c:	d5246c91 	strle	r6, [r4, #-3217]!	; 0xfffff36f
    1730:	0200000c 	andeq	r0, r0, #12
    1734:	00fc09b4 	ldrhteq	r0, [ip], #148	; 0x94
    1738:	91020000 	mrsls	r0, (UNDEF: 2)
    173c:	09b42450 	ldmibeq	r4!, {r4, r6, sl, sp}
    1740:	b6020000 	strlt	r0, [r2], -r0
    1744:	0000fc09 	andeq	pc, r0, r9, lsl #24
    1748:	68910200 	ldmvs	r1, {r9}
    174c:	000c1824 	andeq	r1, ip, r4, lsr #16
    1750:	09b90200 	ldmibeq	r9!, {r9}
    1754:	000000fc 	strdeq	r0, [r0], -ip
    1758:	214c9102 	cmpcs	ip, r2, lsl #2
    175c:	00009184 	andeq	r9, r0, r4, lsl #3
    1760:	00000120 	andeq	r0, r0, r0, lsr #2
    1764:	00000aff 	strdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    1768:	000cfb24 	andeq	pc, ip, r4, lsr #22
    176c:	14bc0200 	ldrtne	r0, [ip], #512	; 0x200
    1770:	00000810 	andeq	r0, r0, r0, lsl r8
    1774:	24489102 	strbcs	r9, [r8], #-258	; 0xfffffefe
    1778:	00000c56 	andeq	r0, r0, r6, asr ip
    177c:	1014bd02 	andsne	fp, r4, r2, lsl #26
    1780:	02000008 	andeq	r0, r0, #8
    1784:	b8214491 	stmdalt	r1!, {r0, r4, r7, sl, lr}
    1788:	84000091 	strhi	r0, [r0], #-145	; 0xffffff6f
    178c:	e7000000 	str	r0, [r0, -r0]
    1790:	2500000a 	strcs	r0, [r0, #-10]
    1794:	bf020069 	svclt	0x00020069
    1798:	0000fc11 	andeq	pc, r0, r1, lsl ip	; <UNPREDICTABLE>
    179c:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    17a0:	923c1f00 	eorsls	r1, ip, #0, 30
    17a4:	005c0000 	subseq	r0, ip, r0
    17a8:	6a250000 	bvs	9417b0 <__bss_end+0x9356b8>
    17ac:	11c10200 	bicne	r0, r1, r0, lsl #4
    17b0:	000000fc 	strdeq	r0, [r0], -ip
    17b4:	00609102 	rsbeq	r9, r0, r2, lsl #2
    17b8:	92c41f00 	sbcls	r1, r4, #0, 30
    17bc:	00640000 	rsbeq	r0, r4, r0
    17c0:	33240000 			; <UNDEFINED> instruction: 0x33240000
    17c4:	0200000c 	andeq	r0, r0, #12
    17c8:	081014c7 	ldmdaeq	r0, {r0, r1, r2, r6, r7, sl, ip}
    17cc:	91020000 	mrsls	r0, (UNDEF: 2)
    17d0:	92dc1f40 	sbcsls	r1, ip, #64, 30	; 0x100
    17d4:	004c0000 	subeq	r0, ip, r0
    17d8:	69250000 	stmdbvs	r5!, {}	; <UNPREDICTABLE>
    17dc:	11c90200 	bicne	r0, r9, r0, lsl #4
    17e0:	000000fc 	strdeq	r0, [r0], -ip
    17e4:	005c9102 	subseq	r9, ip, r2, lsl #2
    17e8:	d3270000 			; <UNDEFINED> instruction: 0xd3270000
    17ec:	02000007 	andeq	r0, r0, #7
    17f0:	0b4a08a6 	bleq	1283a90 <__bss_end+0x1277998>
    17f4:	90740000 	rsbsls	r0, r4, r0
    17f8:	00280000 	eoreq	r0, r8, r0
    17fc:	9c010000 	stcls	0, cr0, [r1], {-0}
    1800:	00000b57 	andeq	r0, r0, r7, asr fp
    1804:	000c411d 	andeq	r4, ip, sp, lsl r1
    1808:	00081c00 	andeq	r1, r8, r0, lsl #24
    180c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1810:	07b32700 	ldreq	r2, [r3, r0, lsl #14]!
    1814:	a2020000 	andge	r0, r2, #0
    1818:	000b7106 	andeq	r7, fp, r6, lsl #2
    181c:	00904400 	addseq	r4, r0, r0, lsl #8
    1820:	00003000 	andeq	r3, r0, r0
    1824:	8d9c0100 	ldfhis	f0, [ip]
    1828:	1d00000b 	stcne	0, cr0, [r0, #-44]	; 0xffffffd4
    182c:	00000c41 	andeq	r0, r0, r1, asr #24
    1830:	0000081c 	andeq	r0, r0, ip, lsl r8
    1834:	26749102 	ldrbtcs	r9, [r4], -r2, lsl #2
    1838:	00726662 	rsbseq	r6, r2, r2, ror #12
    183c:	6d20a202 	sfmvs	f2, 1, [r0, #-8]!
    1840:	02000004 	andeq	r0, r0, #4
    1844:	22007091 	andcs	r7, r0, #145	; 0x91
    1848:	0000073e 	andeq	r0, r0, lr, lsr r7
    184c:	a7069902 	strge	r9, [r6, -r2, lsl #18]
    1850:	c000000b 	andgt	r0, r0, fp
    1854:	8400008f 	strhi	r0, [r0], #-143	; 0xffffff71
    1858:	01000000 	mrseq	r0, (UNDEF: 0)
    185c:	000bc19c 	muleq	fp, ip, r1
    1860:	0c411d00 	mcrreq	13, 0, r1, r1, cr0
    1864:	081c0000 	ldmdaeq	ip, {}	; <UNPREDICTABLE>
    1868:	91020000 	mrsls	r0, (UNDEF: 2)
    186c:	00792674 	rsbseq	r2, r9, r4, ror r6
    1870:	09239902 	stmdbeq	r3!, {r1, r8, fp, ip, pc}
    1874:	02000001 	andeq	r0, r0, #1
    1878:	27007091 			; <UNDEFINED> instruction: 0x27007091
    187c:	000005a5 	andeq	r0, r0, r5, lsr #11
    1880:	db069502 	blle	1a6c90 <__bss_end+0x19ab98>
    1884:	8000000b 	andhi	r0, r0, fp
    1888:	4000008f 	andmi	r0, r0, pc, lsl #1
    188c:	01000000 	mrseq	r0, (UNDEF: 0)
    1890:	000be89c 	muleq	fp, ip, r8
    1894:	0c411d00 	mcrreq	13, 0, r1, r1, cr0
    1898:	081c0000 	ldmdaeq	ip, {}	; <UNPREDICTABLE>
    189c:	91020000 	mrsls	r0, (UNDEF: 2)
    18a0:	e6220074 			; <UNDEFINED> instruction: 0xe6220074
    18a4:	02000005 	andeq	r0, r0, #5
    18a8:	0c02067b 	stceq	6, cr0, [r2], {123}	; 0x7b
    18ac:	8d040000 	stchi	0, cr0, [r4, #-0]
    18b0:	027c0000 	rsbseq	r0, ip, #0
    18b4:	9c010000 	stcls	0, cr0, [r1], {-0}
    18b8:	00000c58 	andeq	r0, r0, r8, asr ip
    18bc:	000c411d 	andeq	r4, ip, sp, lsl r1
    18c0:	00081c00 	andeq	r1, r8, r0, lsl #24
    18c4:	5c910200 	lfmpl	f0, 4, [r1], {0}
    18c8:	008d3421 	addeq	r3, sp, r1, lsr #8
    18cc:	0000f000 	andeq	pc, r0, r0
    18d0:	000c4000 	andeq	r4, ip, r0
    18d4:	00692500 	rsbeq	r2, r9, r0, lsl #10
    18d8:	fc0d7e02 	stc2	14, cr7, [sp], {2}
    18dc:	02000000 	andeq	r0, r0, #0
    18e0:	b81f6c91 	ldmdalt	pc, {r0, r4, r7, sl, fp, sp, lr}	; <UNPREDICTABLE>
    18e4:	5c00008d 	stcpl	0, cr0, [r0], {141}	; 0x8d
    18e8:	25000000 	strcs	r0, [r0, #-0]
    18ec:	8502006a 	strhi	r0, [r2, #-106]	; 0xffffff96
    18f0:	0000fc11 	andeq	pc, r0, r1, lsl ip	; <UNPREDICTABLE>
    18f4:	68910200 	ldmvs	r1, {r9}
    18f8:	201f0000 	andscs	r0, pc, r0
    18fc:	4c00008f 	stcmi	0, cr0, [r0], {143}	; 0x8f
    1900:	25000000 	strcs	r0, [r0, #-0]
    1904:	9002006a 	andls	r0, r2, sl, rrx
    1908:	0000fc0d 	andeq	pc, r0, sp, lsl #24
    190c:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    1910:	61220000 			; <UNDEFINED> instruction: 0x61220000
    1914:	02000007 	andeq	r0, r0, #7
    1918:	0c720666 	ldcleq	6, cr0, [r2], #-408	; 0xfffffe68
    191c:	8bac0000 	blhi	feb01924 <__bss_end+0xfeaf582c>
    1920:	01580000 	cmpeq	r8, r0
    1924:	9c010000 	stcls	0, cr0, [r1], {-0}
    1928:	00000ced 	andeq	r0, r0, sp, ror #25
    192c:	000c411d 	andeq	r4, ip, sp, lsl r1
    1930:	00081c00 	andeq	r1, r8, r0, lsl #24
    1934:	bc910300 	ldclt	3, cr0, [r1], {0}
    1938:	0d04247e 	cfstrseq	mvf2, [r4, #-504]	; 0xfffffe08
    193c:	68020000 	stmdavs	r2, {}	; <UNPREDICTABLE>
    1940:	00045d0a 	andeq	r5, r4, sl, lsl #26
    1944:	ec910300 	ldc	3, cr0, [r1], {0}
    1948:	0ce3247e 	cfstrdeq	mvd2, [r3], #504	; 0x1f8
    194c:	69020000 	stmdbvs	r2, {}	; <UNPREDICTABLE>
    1950:	000ced0a 	andeq	lr, ip, sl, lsl #26
    1954:	d0910300 	addsle	r0, r1, r0, lsl #6
    1958:	0ca1247e 	cfstrseq	mvf2, [r1], #504	; 0x1f8
    195c:	6a020000 	bvs	81964 <__bss_end+0x7586c>
    1960:	000d030a 	andeq	r0, sp, sl, lsl #6
    1964:	c4910300 	ldrgt	r0, [r1], #768	; 0x300
    1968:	6d74257e 	cfldr64vs	mvdx2, [r4, #-504]!	; 0xfffffe08
    196c:	6b020070 	blvs	81b34 <__bss_end+0x75a3c>
    1970:	00081010 	andeq	r1, r8, r0, lsl r0
    1974:	70910200 	addsvc	r0, r1, r0, lsl #4
    1978:	008c1c1f 	addeq	r1, ip, pc, lsl ip
    197c:	0000a400 	andeq	sl, r0, r0, lsl #8
    1980:	00692500 	rsbeq	r2, r9, r0, lsl #10
    1984:	fc0d6d02 	vdot.bf16	d6, d13, d2
    1988:	02000000 	andeq	r0, r0, #0
    198c:	301f7491 	mulscc	pc, r1, r4	; <UNPREDICTABLE>
    1990:	8000008c 	andhi	r0, r0, ip, lsl #1
    1994:	25000000 	strcs	r0, [r0, #-0]
    1998:	6e020066 	cdpvs	0, 0, cr0, cr2, cr6, {3}
    199c:	0001090f 	andeq	r0, r1, pc, lsl #18
    19a0:	6c910200 	lfmvs	f0, 4, [r1], {0}
    19a4:	17000000 	strne	r0, [r0, -r0]
    19a8:	00000115 	andeq	r0, r0, r5, lsl r1
    19ac:	00000d03 	andeq	r0, r0, r3, lsl #26
    19b0:	00014718 	andeq	r4, r1, r8, lsl r7
    19b4:	47180400 	ldrmi	r0, [r8, -r0, lsl #8]
    19b8:	04000001 	streq	r0, [r0], #-1
    19bc:	01151700 	tsteq	r5, r0, lsl #14
    19c0:	0d130000 	ldceq	0, cr0, [r3, #-0]
    19c4:	47180000 	ldrmi	r0, [r8, -r0]
    19c8:	09000001 	stmdbeq	r0, {r0}
    19cc:	06892700 	streq	r2, [r9], r0, lsl #14
    19d0:	5d020000 	stcpl	0, cr0, [r2, #-0]
    19d4:	000d2d06 	andeq	r2, sp, r6, lsl #26
    19d8:	008ac400 	addeq	ip, sl, r0, lsl #8
    19dc:	0000e800 	andeq	lr, r0, r0, lsl #16
    19e0:	799c0100 	ldmibvc	ip, {r8}
    19e4:	1d00000d 	stcne	0, cr0, [r0, #-52]	; 0xffffffcc
    19e8:	00000c41 	andeq	r0, r0, r1, asr #24
    19ec:	0000081c 	andeq	r0, r0, ip, lsl r8
    19f0:	266c9102 	strbtcs	r9, [ip], -r2, lsl #2
    19f4:	5d020074 	stcpl	0, cr0, [r2, #-464]	; 0xfffffe30
    19f8:	00081022 	andeq	r1, r8, r2, lsr #32
    19fc:	68910200 	ldmvs	r1, {r9}
    1a00:	008ad821 	addeq	sp, sl, r1, lsr #16
    1a04:	00005000 	andeq	r5, r0, r0
    1a08:	000d6100 	andeq	r6, sp, r0, lsl #2
    1a0c:	00692500 	rsbeq	r2, r9, r0, lsl #10
    1a10:	fc0d5e02 	stc2	14, cr5, [sp], {2}
    1a14:	02000000 	andeq	r0, r0, #0
    1a18:	1f007491 	svcne	0x00007491
    1a1c:	00008b28 	andeq	r8, r0, r8, lsr #22
    1a20:	00000060 	andeq	r0, r0, r0, rrx
    1a24:	02006925 	andeq	r6, r0, #606208	; 0x94000
    1a28:	00fc0d60 	rscseq	r0, ip, r0, ror #26
    1a2c:	91020000 	mrsls	r0, (UNDEF: 2)
    1a30:	22000070 	andcs	r0, r0, #112	; 0x70
    1a34:	00000600 	andeq	r0, r0, r0, lsl #12
    1a38:	93065002 	movwls	r5, #24578	; 0x6002
    1a3c:	c800000d 	stmdagt	r0, {r0, r2, r3}
    1a40:	fc000089 	stc2	0, cr0, [r0], {137}	; 0x89
    1a44:	01000000 	mrseq	r0, (UNDEF: 0)
    1a48:	000e029c 	muleq	lr, ip, r2
    1a4c:	0c411d00 	mcrreq	13, 0, r1, r1, cr0
    1a50:	081c0000 	ldmdaeq	ip, {}	; <UNPREDICTABLE>
    1a54:	91020000 	mrsls	r0, (UNDEF: 2)
    1a58:	89d81f64 	ldmibhi	r8, {r2, r5, r6, r8, r9, sl, fp, ip}^
    1a5c:	00dc0000 	sbcseq	r0, ip, r0
    1a60:	69250000 	stmdbvs	r5!, {}	; <UNPREDICTABLE>
    1a64:	0d510200 	lfmeq	f0, 2, [r1, #-0]
    1a68:	000000fc 	strdeq	r0, [r0], -ip
    1a6c:	1f749102 	svcne	0x00749102
    1a70:	000089f4 	strdeq	r8, [r0], -r4
    1a74:	000000b0 	strheq	r0, [r0], -r0	; <UNPREDICTABLE>
    1a78:	000c3724 	andeq	r3, ip, r4, lsr #14
    1a7c:	14520200 	ldrbne	r0, [r2], #-512	; 0xfffffe00
    1a80:	00000810 	andeq	r0, r0, r0, lsl r8
    1a84:	21689102 	cmncs	r8, r2, lsl #2
    1a88:	00008a10 	andeq	r8, r0, r0, lsl sl
    1a8c:	0000004c 	andeq	r0, r0, ip, asr #32
    1a90:	00000de8 	andeq	r0, r0, r8, ror #27
    1a94:	02006a25 	andeq	r6, r0, #151552	; 0x25000
    1a98:	00fc1154 	rscseq	r1, ip, r4, asr r1
    1a9c:	91020000 	mrsls	r0, (UNDEF: 2)
    1aa0:	5c1f0070 	ldcpl	0, cr0, [pc], {112}	; 0x70
    1aa4:	4800008a 	stmdami	r0, {r1, r3, r7}
    1aa8:	25000000 	strcs	r0, [r0, #-0]
    1aac:	5702006a 	strpl	r0, [r2, -sl, rrx]
    1ab0:	0000fc11 	andeq	pc, r0, r1, lsl ip	; <UNPREDICTABLE>
    1ab4:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1ab8:	00000000 	andeq	r0, r0, r0
    1abc:	0005c322 	andeq	ip, r5, r2, lsr #6
    1ac0:	072f0200 	streq	r0, [pc, -r0, lsl #4]!
    1ac4:	00000e1c 	andeq	r0, r0, ip, lsl lr
    1ac8:	00008860 	andeq	r8, r0, r0, ror #16
    1acc:	00000168 	andeq	r0, r0, r8, ror #2
    1ad0:	0ea39c01 	cdpeq	12, 10, cr9, cr3, cr1, {0}
    1ad4:	411d0000 	tstmi	sp, r0
    1ad8:	1c00000c 	stcne	0, cr0, [r0], {12}
    1adc:	02000008 	andeq	r0, r0, #8
    1ae0:	37235491 			; <UNDEFINED> instruction: 0x37235491
    1ae4:	0200000c 	andeq	r0, r0, #12
    1ae8:	08102b2f 	ldmdaeq	r0, {r0, r1, r2, r3, r5, r8, r9, fp, sp}
    1aec:	91020000 	mrsls	r0, (UNDEF: 2)
    1af0:	0cb32450 	cfldrseq	mvf2, [r3], #320	; 0x140
    1af4:	31020000 	mrscc	r0, (UNDEF: 2)
    1af8:	0000fc09 	andeq	pc, r0, r9, lsl #24
    1afc:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1b00:	000a0d24 	andeq	r0, sl, r4, lsr #26
    1b04:	0b320200 	bleq	c8230c <__bss_end+0xc76214>
    1b08:	00000109 	andeq	r0, r0, r9, lsl #2
    1b0c:	24689102 	strbtcs	r9, [r8], #-258	; 0xfffffefe
    1b10:	00000cf6 	strdeq	r0, [r0], -r6
    1b14:	090b3302 	stmdbeq	fp, {r1, r8, r9, ip, sp}
    1b18:	02000001 	andeq	r0, r0, #1
    1b1c:	69257491 	stmdbvs	r5!, {r0, r4, r7, sl, ip, sp, lr}
    1b20:	09340200 	ldmdbeq	r4!, {r9}
    1b24:	000000fc 	strdeq	r0, [r0], -ip
    1b28:	28709102 	ldmdacs	r0!, {r1, r8, ip, pc}^
    1b2c:	00000018 	andeq	r0, r0, r8, lsl r0
    1b30:	000cc924 	andeq	ip, ip, r4, lsr #18
    1b34:	0f370200 	svceq	0x00370200
    1b38:	00000109 	andeq	r0, r0, r9, lsl #2
    1b3c:	24649102 	strbtcs	r9, [r4], #-258	; 0xfffffefe
    1b40:	00000c12 	andeq	r0, r0, r2, lsl ip
    1b44:	fc0d3802 	stc2	8, cr3, [sp], {2}
    1b48:	02000000 	andeq	r0, r0, #0
    1b4c:	79256091 	stmdbvc	r5!, {r0, r4, r7, sp, lr}
    1b50:	0f3c0200 	svceq	0x003c0200
    1b54:	00000109 	andeq	r0, r0, r9, lsl #2
    1b58:	005c9102 	subseq	r9, ip, r2, lsl #2
    1b5c:	06a82200 	strteq	r2, [r8], r0, lsl #4
    1b60:	24020000 	strcs	r0, [r2], #-0
    1b64:	000ebd06 	andeq	fp, lr, r6, lsl #26
    1b68:	0087cc00 	addeq	ip, r7, r0, lsl #24
    1b6c:	00009400 	andeq	r9, r0, r0, lsl #8
    1b70:	099c0100 	ldmibeq	ip, {r8}
    1b74:	1d00000f 	stcne	0, cr0, [r0, #-60]	; 0xffffffc4
    1b78:	00000c41 	andeq	r0, r0, r1, asr #24
    1b7c:	0000081c 	andeq	r0, r0, ip, lsl r8
    1b80:	236c9102 	cmncs	ip, #-2147483648	; 0x80000000
    1b84:	00000c37 	andeq	r0, r0, r7, lsr ip
    1b88:	10202402 	eorne	r2, r0, r2, lsl #8
    1b8c:	02000008 	andeq	r0, r0, #8
    1b90:	e01f6891 	muls	pc, r1, r8	; <UNPREDICTABLE>
    1b94:	74000087 	strvc	r0, [r0], #-135	; 0xffffff79
    1b98:	25000000 	strcs	r0, [r0, #-0]
    1b9c:	27020069 	strcs	r0, [r2, -r9, rrx]
    1ba0:	0000fc0d 	andeq	pc, r0, sp, lsl #24
    1ba4:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1ba8:	0087fc1f 	addeq	pc, r7, pc, lsl ip	; <UNPREDICTABLE>
    1bac:	00004800 	andeq	r4, r0, r0, lsl #16
    1bb0:	0cbe2400 	cfldrseq	mvf2, [lr]
    1bb4:	28020000 	stmdacs	r2, {}	; <UNPREDICTABLE>
    1bb8:	0001090f 	andeq	r0, r1, pc, lsl #18
    1bbc:	70910200 	addsvc	r0, r1, r0, lsl #4
    1bc0:	22000000 	andcs	r0, r0, #0
    1bc4:	00000634 	andeq	r0, r0, r4, lsr r6
    1bc8:	23071602 	movwcs	r1, #30210	; 0x7602
    1bcc:	1400000f 	strne	r0, [r0], #-15
    1bd0:	b8000087 	stmdalt	r0, {r0, r1, r2, r7}
    1bd4:	01000000 	mrseq	r0, (UNDEF: 0)
    1bd8:	000fab9c 	muleq	pc, ip, fp	; <UNPREDICTABLE>
    1bdc:	0c411d00 	mcrreq	13, 0, r1, r1, cr0
    1be0:	081c0000 	ldmdaeq	ip, {}	; <UNPREDICTABLE>
    1be4:	91020000 	mrsls	r0, (UNDEF: 2)
    1be8:	040c2354 	streq	r2, [ip], #-852	; 0xfffffcac
    1bec:	16020000 	strne	r0, [r2], -r0
    1bf0:	0004be2a 	andeq	fp, r4, sl, lsr #28
    1bf4:	50910200 	addspl	r0, r1, r0, lsl #4
    1bf8:	02007926 	andeq	r7, r0, #622592	; 0x98000
    1bfc:	01093c16 	tsteq	r9, r6, lsl ip
    1c00:	91020000 	mrsls	r0, (UNDEF: 2)
    1c04:	0041254c 	subeq	r2, r1, ip, asr #10
    1c08:	090b1702 	stmdbeq	fp, {r1, r8, r9, sl, ip}
    1c0c:	02000001 	andeq	r0, r0, #1
    1c10:	42257491 	eormi	r7, r5, #-1862270976	; 0x91000000
    1c14:	0b180200 	bleq	60241c <__bss_end+0x5f6324>
    1c18:	00000109 	andeq	r0, r0, r9, lsl #2
    1c1c:	25709102 	ldrbcs	r9, [r0, #-258]!	; 0xfffffefe
    1c20:	19020043 	stmdbne	r2, {r0, r1, r6}
    1c24:	0001090b 	andeq	r0, r1, fp, lsl #18
    1c28:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1c2c:	02004425 	andeq	r4, r0, #620756992	; 0x25000000
    1c30:	01090b1a 	tsteq	r9, sl, lsl fp
    1c34:	91020000 	mrsls	r0, (UNDEF: 2)
    1c38:	00452568 	subeq	r2, r5, r8, ror #10
    1c3c:	090b1b02 	stmdbeq	fp, {r1, r8, r9, fp, ip}
    1c40:	02000001 	andeq	r0, r0, #1
    1c44:	62256491 	eorvs	r6, r5, #-1862270976	; 0x91000000
    1c48:	0200745f 	andeq	r7, r0, #1593835520	; 0x5f000000
    1c4c:	01090b1d 	tsteq	r9, sp, lsl fp
    1c50:	91020000 	mrsls	r0, (UNDEF: 2)
    1c54:	0cc92460 	cfstrdeq	mvd2, [r9], {96}	; 0x60
    1c58:	1e020000 	cdpne	0, 0, cr0, cr2, cr0, {0}
    1c5c:	0001090b 	andeq	r0, r1, fp, lsl #18
    1c60:	5c910200 	lfmpl	f0, 4, [r1], {0}
    1c64:	065c2700 	ldrbeq	r2, [ip], -r0, lsl #14
    1c68:	0f020000 	svceq	0x00020000
    1c6c:	000fc507 	andeq	ip, pc, r7, lsl #10
    1c70:	0086a000 	addeq	sl, r6, r0
    1c74:	00007400 	andeq	r7, r0, r0, lsl #8
    1c78:	f99c0100 			; <UNDEFINED> instruction: 0xf99c0100
    1c7c:	1d00000f 	stcne	0, cr0, [r0, #-60]	; 0xffffffc4
    1c80:	00000c41 	andeq	r0, r0, r1, asr #24
    1c84:	0000081c 	andeq	r0, r0, ip, lsl r8
    1c88:	26749102 	ldrbtcs	r9, [r4], -r2, lsl #2
    1c8c:	0f020044 	svceq	0x00020044
    1c90:	0001091b 	andeq	r0, r1, fp, lsl r9
    1c94:	70910200 	addsvc	r0, r1, r0, lsl #4
    1c98:	02004526 	andeq	r4, r0, #159383552	; 0x9800000
    1c9c:	0109240f 	tsteq	r9, pc, lsl #8
    1ca0:	91020000 	mrsls	r0, (UNDEF: 2)
    1ca4:	0079266c 	rsbseq	r2, r9, ip, ror #12
    1ca8:	092d0f02 	pusheq	{r1, r8, r9, sl, fp}
    1cac:	02000001 	andeq	r0, r0, #1
    1cb0:	29006891 	stmdbcs	r0, {r0, r4, r7, fp, sp, lr}
    1cb4:	0000077b 	andeq	r0, r0, fp, ror r7
    1cb8:	0a010302 	beq	428c8 <__bss_end+0x367d0>
    1cbc:	00000010 	andeq	r0, r0, r0, lsl r0
    1cc0:	00001050 	andeq	r1, r0, r0, asr r0
    1cc4:	000c412a 	andeq	r4, ip, sl, lsr #2
    1cc8:	00081c00 	andeq	r1, r8, r0, lsl #24
    1ccc:	0b912b00 	bleq	fe44c8d4 <__bss_end+0xfe4407dc>
    1cd0:	03020000 	movweq	r0, #8192	; 0x2000
    1cd4:	0000fc12 	andeq	pc, r0, r2, lsl ip	; <UNPREDICTABLE>
    1cd8:	0b422b00 	bleq	108c8e0 <__bss_end+0x10807e8>
    1cdc:	03020000 	movweq	r0, #8192	; 0x2000
    1ce0:	0000fc1f 	andeq	pc, r0, pc, lsl ip	; <UNPREDICTABLE>
    1ce4:	08942b00 	ldmeq	r4, {r8, r9, fp, sp}
    1ce8:	03020000 	movweq	r0, #8192	; 0x2000
    1cec:	0000fc2a 	andeq	pc, r0, sl, lsr #24
    1cf0:	068e2b00 	streq	r2, [lr], r0, lsl #22
    1cf4:	03020000 	movweq	r0, #8192	; 0x2000
    1cf8:	0000fc40 	andeq	pc, r0, r0, asr #24
    1cfc:	07122b00 	ldreq	r2, [r2, -r0, lsl #22]
    1d00:	03020000 	movweq	r0, #8192	; 0x2000
    1d04:	0000fc51 	andeq	pc, r0, r1, asr ip	; <UNPREDICTABLE>
    1d08:	f92c0000 			; <UNDEFINED> instruction: 0xf92c0000
    1d0c:	2000000f 	andcs	r0, r0, pc
    1d10:	6b00000d 	blvs	1d4c <shift+0x1d4c>
    1d14:	c0000010 	andgt	r0, r0, r0, lsl r0
    1d18:	e0000085 	and	r0, r0, r5, lsl #1
    1d1c:	01000000 	mrseq	r0, (UNDEF: 0)
    1d20:	00109c9c 	mulseq	r0, ip, ip
    1d24:	100a2d00 	andne	r2, sl, r0, lsl #26
    1d28:	91020000 	mrsls	r0, (UNDEF: 2)
    1d2c:	10132d74 	andsne	r2, r3, r4, ror sp
    1d30:	91020000 	mrsls	r0, (UNDEF: 2)
    1d34:	101f2d70 	andsne	r2, pc, r0, ror sp	; <UNPREDICTABLE>
    1d38:	91020000 	mrsls	r0, (UNDEF: 2)
    1d3c:	102b2d6c 	eorne	r2, fp, ip, ror #26
    1d40:	91020000 	mrsls	r0, (UNDEF: 2)
    1d44:	10372d68 	eorsne	r2, r7, r8, ror #26
    1d48:	91020000 	mrsls	r0, (UNDEF: 2)
    1d4c:	10432d00 	subne	r2, r3, r0, lsl #26
    1d50:	91020000 	mrsls	r0, (UNDEF: 2)
    1d54:	f12e0004 			; <UNDEFINED> instruction: 0xf12e0004
    1d58:	0100000b 	tsteq	r0, fp
    1d5c:	0d320e12 	ldceq	14, cr0, [r2, #-72]!	; 0xffffffb8
    1d60:	02020000 	andeq	r0, r2, #0
    1d64:	99540000 	ldmdbls	r4, {}^	; <UNPREDICTABLE>
    1d68:	00300000 	eorseq	r0, r0, r0
    1d6c:	9c010000 	stcls	0, cr0, [r1], {-0}
    1d70:	000010ca 	andeq	r1, r0, sl, asr #1
    1d74:	0015b523 	andseq	fp, r5, r3, lsr #10
    1d78:	1e120100 	mufnes	f0, f2, f0
    1d7c:	00000136 	andeq	r0, r0, r6, lsr r1
    1d80:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1d84:	000c232e 	andeq	r2, ip, lr, lsr #6
    1d88:	0e0d0100 	adfeqe	f0, f5, f0
    1d8c:	00000c0c 	andeq	r0, r0, ip, lsl #24
    1d90:	00000202 	andeq	r0, r0, r2, lsl #4
    1d94:	00009924 	andeq	r9, r0, r4, lsr #18
    1d98:	00000030 	andeq	r0, r0, r0, lsr r0
    1d9c:	10f89c01 	rscsne	r9, r8, r1, lsl #24
    1da0:	b5230000 	strlt	r0, [r3, #-0]!
    1da4:	01000015 	tsteq	r0, r5, lsl r0
    1da8:	0136260d 	teqeq	r6, sp, lsl #12
    1dac:	91020000 	mrsls	r0, (UNDEF: 2)
    1db0:	a42f0074 	strtge	r0, [pc], #-116	; 1db8 <shift+0x1db8>
    1db4:	0100000b 	tsteq	r0, fp
    1db8:	05090e05 	streq	r0, [r9, #-3589]	; 0xfffff1fb
    1dbc:	02020000 	andeq	r0, r2, #0
    1dc0:	85900000 	ldrhi	r0, [r0]
    1dc4:	00300000 	eorseq	r0, r0, r0
    1dc8:	9c010000 	stcls	0, cr0, [r1], {-0}
    1dcc:	0015b523 	andseq	fp, r5, r3, lsr #10
    1dd0:	24050100 	strcs	r0, [r5], #-256	; 0xffffff00
    1dd4:	00000136 	andeq	r0, r0, r6, lsr r1
    1dd8:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1ddc:	00027600 	andeq	r7, r2, r0, lsl #12
    1de0:	ad000400 	cfstrsge	mvf0, [r0, #-0]
    1de4:	04000007 	streq	r0, [r0], #-7
    1de8:	00025e01 	andeq	r5, r2, r1, lsl #28
    1dec:	0d420400 	cfstrdeq	mvd0, [r2, #-0]
    1df0:	002a0000 	eoreq	r0, sl, r0
    1df4:	99840000 	stmibls	r4, {}	; <UNPREDICTABLE>
    1df8:	02700000 	rsbseq	r0, r0, #0
    1dfc:	0e260000 	cdpeq	0, 2, cr0, cr6, cr0, {0}
    1e00:	04020000 	streq	r0, [r2], #-0
    1e04:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
    1e08:	04040300 	streq	r0, [r4], #-768	; 0xfffffd00
    1e0c:	00001c9f 	muleq	r0, pc, ip	; <UNPREDICTABLE>
    1e10:	60080103 	andvs	r0, r8, r3, lsl #2
    1e14:	03000008 	movweq	r0, #8
    1e18:	08d90502 	ldmeq	r9, {r1, r8, sl}^
    1e1c:	01030000 	mrseq	r0, (UNDEF: 3)
    1e20:	00085708 	andeq	r5, r8, r8, lsl #14
    1e24:	07020300 	streq	r0, [r2, -r0, lsl #6]
    1e28:	0000066a 	andeq	r0, r0, sl, ror #12
    1e2c:	00097f04 	andeq	r7, r9, r4, lsl #30
    1e30:	07090700 	streq	r0, [r9, -r0, lsl #14]
    1e34:	00000060 	andeq	r0, r0, r0, rrx
    1e38:	00004f05 	andeq	r4, r0, r5, lsl #30
    1e3c:	07040300 	streq	r0, [r4, -r0, lsl #6]
    1e40:	00001f98 	muleq	r0, r8, pc	; <UNPREDICTABLE>
    1e44:	00075506 	andeq	r5, r7, r6, lsl #10
    1e48:	14050200 	strne	r0, [r5], #-512	; 0xfffffe00
    1e4c:	0000005b 	andeq	r0, r0, fp, asr r0
    1e50:	c01c0305 	andsgt	r0, ip, r5, lsl #6
    1e54:	c8060000 	stmdagt	r6, {}	; <UNPREDICTABLE>
    1e58:	02000007 	andeq	r0, r0, #7
    1e5c:	005b1406 	subseq	r1, fp, r6, lsl #8
    1e60:	03050000 	movweq	r0, #20480	; 0x5000
    1e64:	0000c020 	andeq	ip, r0, r0, lsr #32
    1e68:	00071e06 	andeq	r1, r7, r6, lsl #28
    1e6c:	1a070300 	bne	1c2a74 <__bss_end+0x1b697c>
    1e70:	0000005b 	andeq	r0, r0, fp, asr r0
    1e74:	c0240305 	eorgt	r0, r4, r5, lsl #6
    1e78:	a1060000 	mrsge	r0, (UNDEF: 6)
    1e7c:	03000004 	movweq	r0, #4
    1e80:	005b1a09 	subseq	r1, fp, r9, lsl #20
    1e84:	03050000 	movweq	r0, #20480	; 0x5000
    1e88:	0000c028 	andeq	ip, r0, r8, lsr #32
    1e8c:	00082c06 	andeq	r2, r8, r6, lsl #24
    1e90:	1a0b0300 	bne	2c2a98 <__bss_end+0x2b69a0>
    1e94:	0000005b 	andeq	r0, r0, fp, asr r0
    1e98:	c02c0305 	eorgt	r0, ip, r5, lsl #6
    1e9c:	57060000 	strpl	r0, [r6, -r0]
    1ea0:	03000006 	movweq	r0, #6
    1ea4:	005b1a0d 	subseq	r1, fp, sp, lsl #20
    1ea8:	03050000 	movweq	r0, #20480	; 0x5000
    1eac:	0000c030 	andeq	ip, r0, r0, lsr r0
    1eb0:	00052406 	andeq	r2, r5, r6, lsl #8
    1eb4:	1a0f0300 	bne	3c2abc <__bss_end+0x3b69c4>
    1eb8:	0000005b 	andeq	r0, r0, fp, asr r0
    1ebc:	c0340305 	eorsgt	r0, r4, r5, lsl #6
    1ec0:	01030000 	mrseq	r0, (UNDEF: 3)
    1ec4:	0006b602 	andeq	fp, r6, r2, lsl #12
    1ec8:	05a00600 	streq	r0, [r0, #1536]!	; 0x600
    1ecc:	04040000 	streq	r0, [r4], #-0
    1ed0:	00005b14 	andeq	r5, r0, r4, lsl fp
    1ed4:	38030500 	stmdacc	r3, {r8, sl}
    1ed8:	060000c0 	streq	r0, [r0], -r0, asr #1
    1edc:	00000337 	andeq	r0, r0, r7, lsr r3
    1ee0:	5b140704 	blpl	503af8 <__bss_end+0x4f7a00>
    1ee4:	05000000 	streq	r0, [r0, #-0]
    1ee8:	00c03c03 	sbceq	r3, r0, r3, lsl #24
    1eec:	04f60600 	ldrbteq	r0, [r6], #1536	; 0x600
    1ef0:	0a040000 	beq	101ef8 <__bss_end+0xf5e00>
    1ef4:	00005b14 	andeq	r5, r0, r4, lsl fp
    1ef8:	40030500 	andmi	r0, r3, r0, lsl #10
    1efc:	030000c0 	movweq	r0, #192	; 0xc0
    1f00:	1f930704 	svcne	0x00930704
    1f04:	c6060000 	strgt	r0, [r6], -r0
    1f08:	0500000a 	streq	r0, [r0, #-10]
    1f0c:	005b140a 	subseq	r1, fp, sl, lsl #8
    1f10:	03050000 	movweq	r0, #20480	; 0x5000
    1f14:	0000c044 	andeq	ip, r0, r4, asr #32
    1f18:	00060e07 	andeq	r0, r6, r7, lsl #28
    1f1c:	0f061c00 	svceq	0x00061c00
    1f20:	00017008 	andeq	r7, r1, r8
    1f24:	040c0800 	streq	r0, [ip], #-2048	; 0xfffff800
    1f28:	11060000 	mrsne	r0, (UNDEF: 6)
    1f2c:	0001700b 	andeq	r7, r1, fp
    1f30:	0d080000 	stceq	0, cr0, [r8, #-0]
    1f34:	0600000a 	streq	r0, [r0], -sl
    1f38:	002c0b13 	eoreq	r0, ip, r3, lsl fp
    1f3c:	08140000 	ldmdaeq	r4, {}	; <UNPREDICTABLE>
    1f40:	00000342 	andeq	r0, r0, r2, asr #6
    1f44:	800c1506 	andhi	r1, ip, r6, lsl #10
    1f48:	18000001 	stmdane	r0, {r0}
    1f4c:	002c0900 	eoreq	r0, ip, r0, lsl #18
    1f50:	01800000 	orreq	r0, r0, r0
    1f54:	600a0000 	andvs	r0, sl, r0
    1f58:	04000000 	streq	r0, [r0], #-0
    1f5c:	2c040b00 			; <UNDEFINED> instruction: 0x2c040b00
    1f60:	0b000000 	bleq	1f68 <shift+0x1f68>
    1f64:	00018c04 	andeq	r8, r1, r4, lsl #24
    1f68:	3b040b00 	blcc	104b70 <__bss_end+0xf8a78>
    1f6c:	0c000001 	stceq	0, cr0, [r0], {1}
    1f70:	00000da5 	andeq	r0, r0, r5, lsr #27
    1f74:	74062c01 	strvc	r2, [r6], #-3073	; 0xfffff3ff
    1f78:	bc00000d 	stclt	0, cr0, [r0], {13}
    1f7c:	3800009b 	stmdacc	r0, {r0, r1, r3, r4, r7}
    1f80:	01000000 	mrseq	r0, (UNDEF: 0)
    1f84:	0001cb9c 	muleq	r1, ip, fp
    1f88:	0c370d00 	ldceq	13, cr0, [r7], #-0
    1f8c:	2c010000 	stccs	0, cr0, [r1], {-0}
    1f90:	00018621 	andeq	r8, r1, r1, lsr #12
    1f94:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1f98:	6e656c0e 	cdpvs	12, 6, cr6, cr5, cr14, {0}
    1f9c:	312c0100 			; <UNDEFINED> instruction: 0x312c0100
    1fa0:	00000025 	andeq	r0, r0, r5, lsr #32
    1fa4:	00709102 	rsbseq	r9, r0, r2, lsl #2
    1fa8:	000d940c 	andeq	r9, sp, ip, lsl #8
    1fac:	06200100 	strteq	r0, [r0], -r0, lsl #2
    1fb0:	00000db4 			; <UNDEFINED> instruction: 0x00000db4
    1fb4:	00009b40 	andeq	r9, r0, r0, asr #22
    1fb8:	0000007c 	andeq	r0, r0, ip, ror r0
    1fbc:	02229c01 	eoreq	r9, r2, #256	; 0x100
    1fc0:	370d0000 	strcc	r0, [sp, -r0]
    1fc4:	0100000c 	tsteq	r0, ip
    1fc8:	01861720 	orreq	r1, r6, r0, lsr #14
    1fcc:	91020000 	mrsls	r0, (UNDEF: 2)
    1fd0:	194e0d6c 	stmdbne	lr, {r2, r3, r5, r6, r8, sl, fp}^
    1fd4:	20010000 	andcs	r0, r1, r0
    1fd8:	00002527 	andeq	r2, r0, r7, lsr #10
    1fdc:	68910200 	ldmvs	r1, {r9}
    1fe0:	646e650e 	strbtvs	r6, [lr], #-1294	; 0xfffffaf2
    1fe4:	33200100 	nopcc	{0}	; <UNPREDICTABLE>
    1fe8:	00000025 	andeq	r0, r0, r5, lsr #32
    1fec:	0f649102 	svceq	0x00649102
    1ff0:	00000c12 	andeq	r0, r0, r2, lsl ip
    1ff4:	25092301 	strcs	r2, [r9, #-769]	; 0xfffffcff
    1ff8:	02000000 	andeq	r0, r0, #0
    1ffc:	10007491 	mulne	r0, r1, r4
    2000:	00000d9f 	muleq	r0, pc, sp	; <UNPREDICTABLE>
    2004:	d0050401 	andle	r0, r5, r1, lsl #8
    2008:	2500000d 	strcs	r0, [r0, #-13]
    200c:	84000000 	strhi	r0, [r0], #-0
    2010:	bc000099 	stclt	0, cr0, [r0], {153}	; 0x99
    2014:	01000001 	tsteq	r0, r1
    2018:	0c370d9c 	ldceq	13, cr0, [r7], #-624	; 0xfffffd90
    201c:	04010000 	streq	r0, [r1], #-0
    2020:	00018617 	andeq	r8, r1, r7, lsl r6
    2024:	6c910200 	lfmvs	f0, 4, [r1], {0}
    2028:	000d3d0d 	andeq	r3, sp, sp, lsl #26
    202c:	27040100 	strcs	r0, [r4, -r0, lsl #2]
    2030:	00000025 	andeq	r0, r0, r5, lsr #32
    2034:	0d689102 	stfeqp	f1, [r8, #-8]!
    2038:	00000d99 	muleq	r0, r9, sp
    203c:	25320401 	ldrcs	r0, [r2, #-1025]!	; 0xfffffbff
    2040:	02000000 	andeq	r0, r0, #0
    2044:	ca0f6491 	bgt	3db290 <__bss_end+0x3cf198>
    2048:	0100000d 	tsteq	r0, sp
    204c:	018c1005 	orreq	r1, ip, r5
    2050:	91020000 	mrsls	r0, (UNDEF: 2)
    2054:	4d000074 	stcmi	0, cr0, [r0, #-464]	; 0xfffffe30
    2058:	04000002 	streq	r0, [r0], #-2
    205c:	0008a800 	andeq	sl, r8, r0, lsl #16
    2060:	99010400 	stmdbls	r1, {sl}
    2064:	0400000e 	streq	r0, [r0], #-14
    2068:	00000e55 	andeq	r0, r0, r5, asr lr
    206c:	00000e36 	andeq	r0, r0, r6, lsr lr
    2070:	00009bf4 	strdeq	r9, [r0], -r4
    2074:	000001c8 	andeq	r0, r0, r8, asr #3
    2078:	00001068 	andeq	r1, r0, r8, rrx
    207c:	60080102 	andvs	r0, r8, r2, lsl #2
    2080:	02000008 	andeq	r0, r0, #8
    2084:	08d90502 	ldmeq	r9, {r1, r8, sl}^
    2088:	04030000 	streq	r0, [r3], #-0
    208c:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
    2090:	08010200 	stmdaeq	r1, {r9}
    2094:	00000857 	andeq	r0, r0, r7, asr r8
    2098:	6a070202 	bvs	1c28a8 <__bss_end+0x1b67b0>
    209c:	04000006 	streq	r0, [r0], #-6
    20a0:	0000097f 	andeq	r0, r0, pc, ror r9
    20a4:	54070903 	strpl	r0, [r7], #-2307	; 0xfffff6fd
    20a8:	02000000 	andeq	r0, r0, #0
    20ac:	1f980704 	svcne	0x00980704
    20b0:	93050000 	movwls	r0, #20480	; 0x5000
    20b4:	0c000005 	stceq	0, cr0, [r0], {5}
    20b8:	09070302 	stmdbeq	r7, {r1, r8, r9}
    20bc:	06000001 	streq	r0, [r0], -r1
    20c0:	00000af4 	strdeq	r0, [r0], -r4
    20c4:	480e0602 	stmdami	lr, {r1, r9, sl}
    20c8:	00000000 	andeq	r0, r0, r0
    20cc:	00097506 	andeq	r7, r9, r6, lsl #10
    20d0:	0e080200 	cdpeq	2, 0, cr0, cr8, cr0, {0}
    20d4:	00000048 	andeq	r0, r0, r8, asr #32
    20d8:	07f70604 	ldrbeq	r0, [r7, r4, lsl #12]!
    20dc:	0b020000 	bleq	820e4 <__bss_end+0x75fec>
    20e0:	0000480e 	andeq	r4, r0, lr, lsl #16
    20e4:	93070800 	movwls	r0, #30720	; 0x7800
    20e8:	02000005 	andeq	r0, r0, #5
    20ec:	091f050d 	ldmdbeq	pc, {r0, r2, r3, r8, sl}	; <UNPREDICTABLE>
    20f0:	01090000 	mrseq	r0, (UNDEF: 9)
    20f4:	a8010000 	stmdage	r1, {}	; <UNPREDICTABLE>
    20f8:	ae000000 	cdpge	0, 0, cr0, cr0, cr0, {0}
    20fc:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    2100:	00000109 	andeq	r0, r0, r9, lsl #2
    2104:	0a4b0900 	beq	12c450c <__bss_end+0x12b8414>
    2108:	0e020000 	cdpeq	0, 0, cr0, cr2, cr0, {0}
    210c:	0006bb0a 	andeq	fp, r6, sl, lsl #22
    2110:	00c30100 	sbceq	r0, r3, r0, lsl #2
    2114:	00c90000 	sbceq	r0, r9, r0
    2118:	09080000 	stmdbeq	r8, {}	; <UNPREDICTABLE>
    211c:	00000001 	andeq	r0, r0, r1
    2120:	00091007 	andeq	r1, r9, r7
    2124:	0b0f0200 	bleq	3c292c <__bss_end+0x3b6834>
    2128:	0000052e 	andeq	r0, r0, lr, lsr #10
    212c:	00000114 	andeq	r0, r0, r4, lsl r1
    2130:	0000e201 	andeq	lr, r0, r1, lsl #4
    2134:	0000ed00 	andeq	lr, r0, r0, lsl #26
    2138:	01090800 	tsteq	r9, r0, lsl #16
    213c:	480a0000 	stmdami	sl, {}	; <UNPREDICTABLE>
    2140:	00000000 	andeq	r0, r0, r0
    2144:	000a3b0b 	andeq	r3, sl, fp, lsl #22
    2148:	0e100200 	cdpeq	2, 1, cr0, cr0, cr0, {0}
    214c:	000008a5 	andeq	r0, r0, r5, lsr #17
    2150:	00000048 	andeq	r0, r0, r8, asr #32
    2154:	00010201 	andeq	r0, r1, r1, lsl #4
    2158:	01090800 	tsteq	r9, r0, lsl #16
    215c:	00000000 	andeq	r0, r0, r0
    2160:	005b040c 	subseq	r0, fp, ip, lsl #8
    2164:	090d0000 	stmdbeq	sp, {}	; <UNPREDICTABLE>
    2168:	0e000001 	cdpeq	0, 0, cr0, cr0, cr1, {0}
    216c:	00680f04 	rsbeq	r0, r8, r4, lsl #30
    2170:	5b151202 	blpl	546980 <__bss_end+0x53a888>
    2174:	10000000 	andne	r0, r0, r0
    2178:	00000116 	andeq	r0, r0, r6, lsl r1
    217c:	050e2701 	streq	r2, [lr, #-1793]	; 0xfffff8ff
    2180:	00c0dc03 	sbceq	sp, r0, r3, lsl #24
    2184:	0e111100 	mufeqs	f1, f1, f0
    2188:	9da00000 	stcls	0, cr0, [r0]
    218c:	001c0000 	andseq	r0, ip, r0
    2190:	9c010000 	stcls	0, cr0, [r1], {-0}
    2194:	000de712 	andeq	lr, sp, r2, lsl r7
    2198:	009d5400 	addseq	r5, sp, r0, lsl #8
    219c:	00004c00 	andeq	r4, r0, r0, lsl #24
    21a0:	6f9c0100 	svcvs	0x009c0100
    21a4:	13000001 	movwne	r0, #1
    21a8:	00000e8a 	andeq	r0, r0, sl, lsl #29
    21ac:	330f2701 	movwcc	r2, #63233	; 0xf701
    21b0:	02000000 	andeq	r0, r0, #0
    21b4:	50137491 	mulspl	r3, r1, r4
    21b8:	0100000f 	tsteq	r0, pc
    21bc:	00330f27 	eorseq	r0, r3, r7, lsr #30
    21c0:	91020000 	mrsls	r0, (UNDEF: 2)
    21c4:	c9140070 	ldmdbgt	r4, {r4, r5, r6}
    21c8:	01000000 	mrseq	r0, (UNDEF: 0)
    21cc:	0114071b 	tsteq	r4, fp, lsl r7
    21d0:	018d0000 	orreq	r0, sp, r0
    21d4:	9cd40000 	ldclls	0, cr0, [r4], {0}
    21d8:	00800000 	addeq	r0, r0, r0
    21dc:	9c010000 	stcls	0, cr0, [r1], {-0}
    21e0:	000001b8 			; <UNDEFINED> instruction: 0x000001b8
    21e4:	000c4115 	andeq	r4, ip, r5, lsl r1
    21e8:	00010f00 	andeq	r0, r1, r0, lsl #30
    21ec:	6c910200 	lfmvs	f0, 4, [r1], {0}
    21f0:	0015b513 	andseq	fp, r5, r3, lsl r5
    21f4:	241b0100 	ldrcs	r0, [fp], #-256	; 0xffffff00
    21f8:	00000048 	andeq	r0, r0, r8, asr #32
    21fc:	16689102 	strbtne	r9, [r8], -r2, lsl #2
    2200:	00000af8 	strdeq	r0, [r0], -r8
    2204:	480e1f01 	stmdami	lr, {r0, r8, r9, sl, fp, ip}
    2208:	02000000 	andeq	r0, r0, #0
    220c:	17007491 			; <UNDEFINED> instruction: 0x17007491
    2210:	000000ed 	andeq	r0, r0, sp, ror #1
    2214:	d20a1701 	andle	r1, sl, #262144	; 0x40000
    2218:	ac000001 	stcge	0, cr0, [r0], {1}
    221c:	2800009c 	stmdacs	r0, {r2, r3, r4, r7}
    2220:	01000000 	mrseq	r0, (UNDEF: 0)
    2224:	0001df9c 	muleq	r1, ip, pc	; <UNPREDICTABLE>
    2228:	0c411500 	cfstr64eq	mvdx1, [r1], {-0}
    222c:	010f0000 	mrseq	r0, CPSR
    2230:	91020000 	mrsls	r0, (UNDEF: 2)
    2234:	ae170074 	mrcge	0, 0, r0, cr7, cr4, {3}
    2238:	01000000 	mrseq	r0, (UNDEF: 0)
    223c:	01f90608 	mvnseq	r0, r8, lsl #12
    2240:	9c3c0000 	ldcls	0, cr0, [ip], #-0
    2244:	00700000 	rsbseq	r0, r0, r0
    2248:	9c010000 	stcls	0, cr0, [r1], {-0}
    224c:	00000215 	andeq	r0, r0, r5, lsl r2
    2250:	000c4115 	andeq	r4, ip, r5, lsl r1
    2254:	00010f00 	andeq	r0, r1, r0, lsl #30
    2258:	6c910200 	lfmvs	f0, 4, [r1], {0}
    225c:	000f4a16 	andeq	r4, pc, r6, lsl sl	; <UNPREDICTABLE>
    2260:	0e0a0100 	adfeqe	f0, f2, f0
    2264:	00000048 	andeq	r0, r0, r8, asr #32
    2268:	00749102 	rsbseq	r9, r4, r2, lsl #2
    226c:	00008f18 	andeq	r8, r0, r8, lsl pc
    2270:	01060100 	mrseq	r0, (UNDEF: 22)
    2274:	00000226 	andeq	r0, r0, r6, lsr #4
    2278:	00023000 	andeq	r3, r2, r0
    227c:	0c411900 	mcrreq	9, 0, r1, r1, cr0	; <UNPREDICTABLE>
    2280:	010f0000 	mrseq	r0, CPSR
    2284:	1a000000 	bne	228c <shift+0x228c>
    2288:	00000215 	andeq	r0, r0, r5, lsl r2
    228c:	00000e20 	andeq	r0, r0, r0, lsr #28
    2290:	00000247 	andeq	r0, r0, r7, asr #4
    2294:	00009bf4 	strdeq	r9, [r0], -r4
    2298:	00000048 	andeq	r0, r0, r8, asr #32
    229c:	261b9c01 	ldrcs	r9, [fp], -r1, lsl #24
    22a0:	02000002 	andeq	r0, r0, #2
    22a4:	00007491 	muleq	r0, r1, r4
    22a8:	00000237 	andeq	r0, r0, r7, lsr r2
    22ac:	0a5f0004 	beq	17c22c4 <__bss_end+0x17b61cc>
    22b0:	01040000 	mrseq	r0, (UNDEF: 4)
    22b4:	00000e99 	muleq	r0, r9, lr
    22b8:	000f9004 	andeq	r9, pc, r4
    22bc:	000e3600 	andeq	r3, lr, r0, lsl #12
    22c0:	009dc000 	addseq	ip, sp, r0
    22c4:	00016000 	andeq	r6, r1, r0
    22c8:	0011ae00 	andseq	sl, r1, r0, lsl #28
    22cc:	0b490200 	bleq	1242ad4 <__bss_end+0x12369dc>
    22d0:	021c0000 	andseq	r0, ip, #0
    22d4:	00fc0703 	rscseq	r0, ip, r3, lsl #14
    22d8:	61030000 	mrsvs	r0, (UNDEF: 3)
    22dc:	09050200 	stmdbeq	r5, {r9}
    22e0:	000000fc 	strdeq	r0, [r0], -ip
    22e4:	00630300 	rsbeq	r0, r3, r0, lsl #6
    22e8:	fc090602 	stc2	6, cr0, [r9], {2}
    22ec:	04000000 	streq	r0, [r0], #-0
    22f0:	6e696d03 	cdpvs	13, 6, cr6, cr9, cr3, {0}
    22f4:	09070200 	stmdbeq	r7, {r9}
    22f8:	000000fc 	strdeq	r0, [r0], -ip
    22fc:	616d0308 	cmnvs	sp, r8, lsl #6
    2300:	08020078 	stmdaeq	r2, {r3, r4, r5, r6}
    2304:	0000fc09 	andeq	pc, r0, r9, lsl #24
    2308:	18040c00 	stmdane	r4, {sl, fp}
    230c:	02000006 	andeq	r0, r0, #6
    2310:	00fc0909 	rscseq	r0, ip, r9, lsl #18
    2314:	04100000 	ldreq	r0, [r0], #-0
    2318:	000006f7 	strdeq	r0, [r0], -r7
    231c:	fc090b02 	stc2	11, cr0, [r9], {2}	; <UNPREDICTABLE>
    2320:	14000000 	strne	r0, [r0], #-0
    2324:	0009f804 	andeq	pc, r9, r4, lsl #16
    2328:	090c0200 	stmdbeq	ip, {r9}
    232c:	000000fc 	strdeq	r0, [r0], -ip
    2330:	0b490518 	bleq	1243798 <__bss_end+0x12376a0>
    2334:	10020000 	andne	r0, r2, r0
    2338:	00076305 	andeq	r6, r7, r5, lsl #6
    233c:	00010300 	andeq	r0, r1, r0, lsl #6
    2340:	00a20100 	adceq	r0, r2, r0, lsl #2
    2344:	00c10000 	sbceq	r0, r1, r0
    2348:	03060000 	movweq	r0, #24576	; 0x6000
    234c:	07000001 	streq	r0, [r0, -r1]
    2350:	000000fc 	strdeq	r0, [r0], -ip
    2354:	0000fc07 	andeq	pc, r0, r7, lsl #24
    2358:	00fc0700 	rscseq	r0, ip, r0, lsl #14
    235c:	fc070000 	stc2	0, cr0, [r7], {-0}
    2360:	07000000 	streq	r0, [r0, -r0]
    2364:	000000fc 	strdeq	r0, [r0], -ip
    2368:	04c40500 	strbeq	r0, [r4], #1280	; 0x500
    236c:	11020000 	mrsne	r0, (UNDEF: 2)
    2370:	0003e409 	andeq	lr, r3, r9, lsl #8
    2374:	0000fc00 	andeq	pc, r0, r0, lsl #24
    2378:	00da0100 	sbcseq	r0, sl, r0, lsl #2
    237c:	00e00000 	rsceq	r0, r0, r0
    2380:	03060000 	movweq	r0, #24576	; 0x6000
    2384:	00000001 	andeq	r0, r0, r1
    2388:	0003da08 	andeq	sp, r3, r8, lsl #20
    238c:	0b130200 	bleq	4c2b94 <__bss_end+0x4b6a9c>
    2390:	00000953 	andeq	r0, r0, r3, asr r9
    2394:	0000010e 	andeq	r0, r0, lr, lsl #2
    2398:	0000f501 	andeq	pc, r0, r1, lsl #10
    239c:	01030600 	tsteq	r3, r0, lsl #12
    23a0:	00000000 	andeq	r0, r0, r0
    23a4:	69050409 	stmdbvs	r5, {r0, r3, sl}
    23a8:	0a00746e 	beq	1f568 <__bss_end+0x13470>
    23ac:	00002504 	andeq	r2, r0, r4, lsl #10
    23b0:	01030b00 	tsteq	r3, r0, lsl #22
    23b4:	040c0000 	streq	r0, [ip], #-0
    23b8:	001c9f04 	andseq	r9, ip, r4, lsl #30
    23bc:	00e00d00 	rsceq	r0, r0, r0, lsl #26
    23c0:	17010000 	strne	r0, [r1, -r0]
    23c4:	00012f07 	andeq	r2, r1, r7, lsl #30
    23c8:	009ec800 	addseq	ip, lr, r0, lsl #16
    23cc:	00005800 	andeq	r5, r0, r0, lsl #16
    23d0:	5a9c0100 	bpl	fe7027d8 <__bss_end+0xfe6f66e0>
    23d4:	0e000001 	cdpeq	0, 0, cr0, cr0, cr1, {0}
    23d8:	00000c41 	andeq	r0, r0, r1, asr #24
    23dc:	00000109 	andeq	r0, r0, r9, lsl #2
    23e0:	0f6c9102 	svceq	0x006c9102
    23e4:	00000f8b 	andeq	r0, r0, fp, lsl #31
    23e8:	fc091801 	stc2	8, cr1, [r9], {1}
    23ec:	02000000 	andeq	r0, r0, #0
    23f0:	620f7491 	andvs	r7, pc, #-1862270976	; 0x91000000
    23f4:	0100000f 	tsteq	r0, pc
    23f8:	010e0b19 	tsteq	lr, r9, lsl fp
    23fc:	91020000 	mrsls	r0, (UNDEF: 2)
    2400:	c10d0070 	tstgt	sp, r0, ror r0
    2404:	01000000 	mrseq	r0, (UNDEF: 0)
    2408:	0174050a 	cmneq	r4, sl, lsl #10
    240c:	9e380000 	cdpls	0, 3, cr0, cr8, cr0, {0}
    2410:	00900000 	addseq	r0, r0, r0
    2414:	9c010000 	stcls	0, cr0, [r1], {-0}
    2418:	0000019f 	muleq	r0, pc, r1	; <UNPREDICTABLE>
    241c:	000c410e 	andeq	r4, ip, lr, lsl #2
    2420:	00010900 	andeq	r0, r1, r0, lsl #18
    2424:	6c910200 	lfmvs	f0, 4, [r1], {0}
    2428:	706d7410 	rsbvc	r7, sp, r0, lsl r4
    242c:	090d0100 	stmdbeq	sp, {r8}
    2430:	000000fc 	strdeq	r0, [r0], -ip
    2434:	0f749102 	svceq	0x00749102
    2438:	00000f5b 	andeq	r0, r0, fp, asr pc
    243c:	fc090e01 	stc2	14, cr0, [r9], {1}
    2440:	02000000 	andeq	r0, r0, #0
    2444:	11007091 	swpne	r7, r1, [r0]
    2448:	00000089 	andeq	r0, r0, r9, lsl #1
    244c:	b0010501 	andlt	r0, r1, r1, lsl #10
    2450:	00000001 	andeq	r0, r0, r1
    2454:	000001f2 	strdeq	r0, [r0], -r2
    2458:	000c4112 	andeq	r4, ip, r2, lsl r1
    245c:	00010900 	andeq	r0, r1, r0, lsl #18
    2460:	696d1300 	stmdbvs	sp!, {r8, r9, ip}^
    2464:	0501006e 	streq	r0, [r1, #-110]	; 0xffffff92
    2468:	0000fc28 	andeq	pc, r0, r8, lsr #24
    246c:	616d1300 	cmnvs	sp, r0, lsl #6
    2470:	05010078 	streq	r0, [r1, #-120]	; 0xffffff88
    2474:	0000fc31 	andeq	pc, r0, r1, lsr ip	; <UNPREDICTABLE>
    2478:	00611300 	rsbeq	r1, r1, r0, lsl #6
    247c:	fc3a0501 	ldc2	5, cr0, [sl], #-4
    2480:	13000000 	movwne	r0, #0
    2484:	05010063 	streq	r0, [r1, #-99]	; 0xffffff9d
    2488:	0000fc40 	andeq	pc, r0, r0, asr #24
    248c:	06181400 	ldreq	r1, [r8], -r0, lsl #8
    2490:	05010000 	streq	r0, [r1, #-0]
    2494:	0000fc47 	andeq	pc, r0, r7, asr #24
    2498:	9f150000 	svcls	0x00150000
    249c:	6d000001 	stcvs	0, cr0, [r0, #-4]
    24a0:	0900000f 	stmdbeq	r0, {r0, r1, r2, r3}
    24a4:	c0000002 	andgt	r0, r0, r2
    24a8:	7800009d 	stmdavc	r0, {r0, r2, r3, r4, r7}
    24ac:	01000000 	mrseq	r0, (UNDEF: 0)
    24b0:	01b0169c 	lslseq	r1, ip	; <illegal shifter operand>
    24b4:	91020000 	mrsls	r0, (UNDEF: 2)
    24b8:	01b91674 			; <UNDEFINED> instruction: 0x01b91674
    24bc:	91020000 	mrsls	r0, (UNDEF: 2)
    24c0:	01c51670 	biceq	r1, r5, r0, ror r6
    24c4:	91020000 	mrsls	r0, (UNDEF: 2)
    24c8:	01d1166c 	bicseq	r1, r1, ip, ror #12
    24cc:	91020000 	mrsls	r0, (UNDEF: 2)
    24d0:	01db1668 	bicseq	r1, fp, r8, ror #12
    24d4:	91020000 	mrsls	r0, (UNDEF: 2)
    24d8:	01e51600 	mvneq	r1, r0, lsl #12
    24dc:	91020000 	mrsls	r0, (UNDEF: 2)
    24e0:	27000004 	strcs	r0, [r0, -r4]
    24e4:	04000006 	streq	r0, [r0], #-6
    24e8:	000bb200 	andeq	fp, fp, r0, lsl #4
    24ec:	99010400 	stmdbls	r1, {sl}
    24f0:	0400000e 	streq	r0, [r0], #-14
    24f4:	0000100a 	andeq	r1, r0, sl
    24f8:	00000e36 	andeq	r0, r0, r6, lsr lr
    24fc:	00000070 	andeq	r0, r0, r0, ror r0
    2500:	00000000 	andeq	r0, r0, r0
    2504:	00001287 	andeq	r1, r0, r7, lsl #5
    2508:	60080102 	andvs	r0, r8, r2, lsl #2
    250c:	03000008 	movweq	r0, #8
    2510:	00000025 	andeq	r0, r0, r5, lsr #32
    2514:	d9050202 	stmdble	r5, {r1, r9}
    2518:	04000008 	streq	r0, [r0], #-8
    251c:	6e690504 	cdpvs	5, 6, cr0, cr9, cr4, {0}
    2520:	01020074 	tsteq	r2, r4, ror r0
    2524:	00085708 	andeq	r5, r8, r8, lsl #14
    2528:	0fcd0500 	svceq	0x00cd0500
    252c:	08030000 	stmdaeq	r3, {}	; <UNPREDICTABLE>
    2530:	00005207 	andeq	r5, r0, r7, lsl #4
    2534:	07020200 	streq	r0, [r2, -r0, lsl #4]
    2538:	0000066a 	andeq	r0, r0, sl, ror #12
    253c:	00097f05 	andeq	r7, r9, r5, lsl #30
    2540:	07090300 	streq	r0, [r9, -r0, lsl #6]
    2544:	0000006a 	andeq	r0, r0, sl, rrx
    2548:	00005903 	andeq	r5, r0, r3, lsl #18
    254c:	07040200 	streq	r0, [r4, -r0, lsl #4]
    2550:	00001f98 	muleq	r0, r8, pc	; <UNPREDICTABLE>
    2554:	00075506 	andeq	r5, r7, r6, lsl #10
    2558:	14050400 	strne	r0, [r5], #-1024	; 0xfffffc00
    255c:	00000065 	andeq	r0, r0, r5, rrx
    2560:	c0480305 	subgt	r0, r8, r5, lsl #6
    2564:	c8060000 	stmdagt	r6, {}	; <UNPREDICTABLE>
    2568:	04000007 	streq	r0, [r0], #-7
    256c:	00651406 	rsbeq	r1, r5, r6, lsl #8
    2570:	03050000 	movweq	r0, #20480	; 0x5000
    2574:	0000c04c 	andeq	ip, r0, ip, asr #32
    2578:	00071e06 	andeq	r1, r7, r6, lsl #28
    257c:	1a070500 	bne	1c3984 <__bss_end+0x1b788c>
    2580:	00000065 	andeq	r0, r0, r5, rrx
    2584:	c0500305 	subsgt	r0, r0, r5, lsl #6
    2588:	a1060000 	mrsge	r0, (UNDEF: 6)
    258c:	05000004 	streq	r0, [r0, #-4]
    2590:	00651a09 	rsbeq	r1, r5, r9, lsl #20
    2594:	03050000 	movweq	r0, #20480	; 0x5000
    2598:	0000c054 	andeq	ip, r0, r4, asr r0
    259c:	00082c06 	andeq	r2, r8, r6, lsl #24
    25a0:	1a0b0500 	bne	2c39a8 <__bss_end+0x2b78b0>
    25a4:	00000065 	andeq	r0, r0, r5, rrx
    25a8:	c0580305 	subsgt	r0, r8, r5, lsl #6
    25ac:	57060000 	strpl	r0, [r6, -r0]
    25b0:	05000006 	streq	r0, [r0, #-6]
    25b4:	00651a0d 	rsbeq	r1, r5, sp, lsl #20
    25b8:	03050000 	movweq	r0, #20480	; 0x5000
    25bc:	0000c05c 	andeq	ip, r0, ip, asr r0
    25c0:	00052406 	andeq	r2, r5, r6, lsl #8
    25c4:	1a0f0500 	bne	3c39cc <__bss_end+0x3b78d4>
    25c8:	00000065 	andeq	r0, r0, r5, rrx
    25cc:	c0600305 	rsbgt	r0, r0, r5, lsl #6
    25d0:	01020000 	mrseq	r0, (UNDEF: 2)
    25d4:	0006b602 	andeq	fp, r6, r2, lsl #12
    25d8:	2c040700 	stccs	7, cr0, [r4], {-0}
    25dc:	06000000 	streq	r0, [r0], -r0
    25e0:	000005a0 	andeq	r0, r0, r0, lsr #11
    25e4:	65140406 	ldrvs	r0, [r4, #-1030]	; 0xfffffbfa
    25e8:	05000000 	streq	r0, [r0, #-0]
    25ec:	00c06403 	sbceq	r6, r0, r3, lsl #8
    25f0:	03370600 	teqeq	r7, #0, 12
    25f4:	07060000 	streq	r0, [r6, -r0]
    25f8:	00006514 	andeq	r6, r0, r4, lsl r5
    25fc:	68030500 	stmdavs	r3, {r8, sl}
    2600:	060000c0 	streq	r0, [r0], -r0, asr #1
    2604:	000004f6 	strdeq	r0, [r0], -r6
    2608:	65140a06 	ldrvs	r0, [r4, #-2566]	; 0xfffff5fa
    260c:	05000000 	streq	r0, [r0, #-0]
    2610:	00c06c03 	sbceq	r6, r0, r3, lsl #24
    2614:	07040200 	streq	r0, [r4, -r0, lsl #4]
    2618:	00001f93 	muleq	r0, r3, pc	; <UNPREDICTABLE>
    261c:	000ac606 	andeq	ip, sl, r6, lsl #12
    2620:	140a0700 	strne	r0, [sl], #-1792	; 0xfffff900
    2624:	00000065 	andeq	r0, r0, r5, rrx
    2628:	c0700305 	rsbsgt	r0, r0, r5, lsl #6
    262c:	04080000 	streq	r0, [r8], #-0
    2630:	00059309 	andeq	r9, r5, r9, lsl #6
    2634:	03080c00 	movweq	r0, #35840	; 0x8c00
    2638:	0001fb07 	andeq	pc, r1, r7, lsl #22
    263c:	0af40a00 	beq	ffd04e44 <__bss_end+0xffcf8d4c>
    2640:	06080000 	streq	r0, [r8], -r0
    2644:	0000590e 	andeq	r5, r0, lr, lsl #18
    2648:	750a0000 	strvc	r0, [sl, #-0]
    264c:	08000009 	stmdaeq	r0, {r0, r3}
    2650:	00590e08 	subseq	r0, r9, r8, lsl #28
    2654:	0a040000 	beq	10265c <__bss_end+0xf6564>
    2658:	000007f7 	strdeq	r0, [r0], -r7
    265c:	590e0b08 	stmdbpl	lr, {r3, r8, r9, fp}
    2660:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    2664:	0005930b 	andeq	r9, r5, fp, lsl #6
    2668:	050d0800 	streq	r0, [sp, #-2048]	; 0xfffff800
    266c:	0000091f 	andeq	r0, r0, pc, lsl r9
    2670:	000001fb 	strdeq	r0, [r0], -fp
    2674:	00019a01 	andeq	r9, r1, r1, lsl #20
    2678:	0001a000 	andeq	sl, r1, r0
    267c:	01fb0c00 	mvnseq	r0, r0, lsl #24
    2680:	0d000000 	stceq	0, cr0, [r0, #-0]
    2684:	00000a4b 	andeq	r0, r0, fp, asr #20
    2688:	bb0a0e08 	bllt	285eb0 <__bss_end+0x279db8>
    268c:	01000006 	tsteq	r0, r6
    2690:	000001b5 			; <UNDEFINED> instruction: 0x000001b5
    2694:	000001bb 			; <UNDEFINED> instruction: 0x000001bb
    2698:	0001fb0c 	andeq	pc, r1, ip, lsl #22
    269c:	100b0000 	andne	r0, fp, r0
    26a0:	08000009 	stmdaeq	r0, {r0, r3}
    26a4:	052e0b0f 	streq	r0, [lr, #-2831]!	; 0xfffff4f1
    26a8:	014b0000 	mrseq	r0, (UNDEF: 75)
    26ac:	d4010000 	strle	r0, [r1], #-0
    26b0:	df000001 	svcle	0x00000001
    26b4:	0c000001 	stceq	0, cr0, [r0], {1}
    26b8:	000001fb 	strdeq	r0, [r0], -fp
    26bc:	0000590e 	andeq	r5, r0, lr, lsl #18
    26c0:	3b0f0000 	blcc	3c26c8 <__bss_end+0x3b65d0>
    26c4:	0800000a 	stmdaeq	r0, {r1, r3}
    26c8:	08a50e10 	stmiaeq	r5!, {r4, r9, sl, fp}
    26cc:	00590000 	subseq	r0, r9, r0
    26d0:	f4010000 	vst4.8	{d0-d3}, [r1], r0
    26d4:	0c000001 	stceq	0, cr0, [r0], {1}
    26d8:	000001fb 	strdeq	r0, [r0], -fp
    26dc:	04070000 	streq	r0, [r7], #-0
    26e0:	0000014d 	andeq	r0, r0, sp, asr #2
    26e4:	08006810 	stmdaeq	r0, {r4, fp, sp, lr}
    26e8:	014d1512 	cmpeq	sp, r2, lsl r5
    26ec:	18110000 	ldmdane	r1, {}	; <UNPREDICTABLE>
    26f0:	0c00000b 	stceq	0, cr0, [r0], {11}
    26f4:	07070901 	streq	r0, [r7, -r1, lsl #18]
    26f8:	00000380 	andeq	r0, r0, r0, lsl #7
    26fc:	000aa612 	andeq	sl, sl, r2, lsl r6
    2700:	1b090900 	blne	244b08 <__bss_end+0x238a10>
    2704:	00000065 	andeq	r0, r0, r5, rrx
    2708:	03600a80 	cmneq	r0, #128, 20	; 0x80000
    270c:	0b090000 	bleq	242714 <__bss_end+0x23661c>
    2710:	0000590e 	andeq	r5, r0, lr, lsl #18
    2714:	6c0a0000 	stcvs	0, cr0, [sl], {-0}
    2718:	09000004 	stmdbeq	r0, {r2}
    271c:	00590e0c 	subseq	r0, r9, ip, lsl #28
    2720:	0a040000 	beq	102728 <__bss_end+0xf6630>
    2724:	00000d09 	andeq	r0, r0, r9, lsl #26
    2728:	800a0f09 	andhi	r0, sl, r9, lsl #30
    272c:	08000003 	stmdaeq	r0, {r0, r1}
    2730:	0008e80a 	andeq	lr, r8, sl, lsl #16
    2734:	0e100900 	vnmlseq.f16	s0, s0, s0	; <UNPREDICTABLE>
    2738:	00000059 	andeq	r0, r0, r9, asr r0
    273c:	0ad50a88 	beq	ff545164 <__bss_end+0xff53906c>
    2740:	12090000 	andne	r0, r9, #0
    2744:	0003800a 	andeq	r8, r3, sl
    2748:	16138c00 	ldrne	r8, [r3], -r0, lsl #24
    274c:	09000009 	stmdbeq	r0, {r0, r3}
    2750:	048b0a13 	streq	r0, [fp], #2579	; 0xa13
    2754:	027b0000 	rsbseq	r0, fp, #0
    2758:	02860000 	addeq	r0, r6, #0
    275c:	900c0000 	andls	r0, ip, r0
    2760:	0e000003 	cdpeq	0, 0, cr0, cr0, cr3, {0}
    2764:	00000025 	andeq	r0, r0, r5, lsr #32
    2768:	08061300 	stmdaeq	r6, {r8, r9, ip}
    276c:	14090000 	strne	r0, [r9], #-0
    2770:	00056b0a 	andeq	r6, r5, sl, lsl #22
    2774:	00029a00 	andeq	r9, r2, r0, lsl #20
    2778:	0002a500 	andeq	sl, r2, r0, lsl #10
    277c:	03900c00 	orrseq	r0, r0, #0, 24
    2780:	590e0000 	stmdbpl	lr, {}	; <UNPREDICTABLE>
    2784:	00000000 	andeq	r0, r0, r0
    2788:	000bc214 	andeq	ip, fp, r4, lsl r2
    278c:	0a150900 	beq	544b94 <__bss_end+0x538a9c>
    2790:	00000a58 	andeq	r0, r0, r8, asr sl
    2794:	000000ef 	andeq	r0, r0, pc, ror #1
    2798:	000002bd 			; <UNDEFINED> instruction: 0x000002bd
    279c:	000002c3 	andeq	r0, r0, r3, asr #5
    27a0:	0003900c 	andeq	r9, r3, ip
    27a4:	04140000 	ldreq	r0, [r4], #-0
    27a8:	09000004 	stmdbeq	r0, {r2}
    27ac:	0a150a16 	beq	54500c <__bss_end+0x538f14>
    27b0:	00ef0000 	rsceq	r0, pc, r0
    27b4:	02db0000 	sbcseq	r0, fp, #0
    27b8:	02e10000 	rsceq	r0, r1, #0
    27bc:	900c0000 	andls	r0, ip, r0
    27c0:	00000003 	andeq	r0, r0, r3
    27c4:	000b180b 	andeq	r1, fp, fp, lsl #16
    27c8:	05180900 	ldreq	r0, [r8, #-2304]	; 0xfffff700
    27cc:	00000b1f 	andeq	r0, r0, pc, lsl fp
    27d0:	00000390 	muleq	r0, r0, r3
    27d4:	0002fa01 	andeq	pc, r2, r1, lsl #20
    27d8:	00030500 	andeq	r0, r3, r0, lsl #10
    27dc:	03900c00 	orrseq	r0, r0, #0, 24
    27e0:	590e0000 	stmdbpl	lr, {}	; <UNPREDICTABLE>
    27e4:	00000000 	andeq	r0, r0, r0
    27e8:	0008ca0b 	andeq	ip, r8, fp, lsl #20
    27ec:	0b190900 	bleq	644bf4 <__bss_end+0x638afc>
    27f0:	0000083a 	andeq	r0, r0, sl, lsr r8
    27f4:	0000039b 	muleq	r0, fp, r3
    27f8:	00031e01 	andeq	r1, r3, r1, lsl #28
    27fc:	00032400 	andeq	r2, r3, r0, lsl #8
    2800:	03900c00 	orrseq	r0, r0, #0, 24
    2804:	0b000000 	bleq	280c <shift+0x280c>
    2808:	000007d4 	ldrdeq	r0, [r0], -r4
    280c:	d20b1a09 	andle	r1, fp, #36864	; 0x9000
    2810:	9b000009 	blls	283c <shift+0x283c>
    2814:	01000003 	tsteq	r0, r3
    2818:	0000033d 	andeq	r0, r0, sp, lsr r3
    281c:	00000348 	andeq	r0, r0, r8, asr #6
    2820:	0003900c 	andeq	r9, r3, ip
    2824:	00380e00 	eorseq	r0, r8, r0, lsl #28
    2828:	0d000000 	stceq	0, cr0, [r0, #-0]
    282c:	0000067d 	andeq	r0, r0, sp, ror r6
    2830:	9c0a1b09 			; <UNDEFINED> instruction: 0x9c0a1b09
    2834:	01000009 	tsteq	r0, r9
    2838:	0000035d 	andeq	r0, r0, sp, asr r3
    283c:	00000363 	andeq	r0, r0, r3, ror #6
    2840:	0003900c 	andeq	r9, r3, ip
    2844:	ab150000 	blge	54284c <__bss_end+0x536754>
    2848:	09000006 	stmdbeq	r0, {r1, r2}
    284c:	03bf0a1c 			; <UNDEFINED> instruction: 0x03bf0a1c
    2850:	74010000 	strvc	r0, [r1], #-0
    2854:	0c000003 	stceq	0, cr0, [r0], {3}
    2858:	00000390 	muleq	r0, r0, r3
    285c:	0000f60e 	andeq	pc, r0, lr, lsl #12
    2860:	16000000 	strne	r0, [r0], -r0
    2864:	00000025 	andeq	r0, r0, r5, lsr #32
    2868:	00000390 	muleq	r0, r0, r3
    286c:	00006a17 	andeq	r6, r0, r7, lsl sl
    2870:	07007f00 	streq	r7, [r0, -r0, lsl #30]
    2874:	00020b04 	andeq	r0, r2, r4, lsl #22
    2878:	03900300 	orrseq	r0, r0, #0, 6
    287c:	04070000 	streq	r0, [r7], #-0
    2880:	00000025 	andeq	r0, r0, r5, lsr #32
    2884:	00032418 	andeq	r2, r3, r8, lsl r4
    2888:	07570200 	ldrbeq	r0, [r7, -r0, lsl #4]
    288c:	000003bb 			; <UNDEFINED> instruction: 0x000003bb
    2890:	0000a2b4 			; <UNDEFINED> instruction: 0x0000a2b4
    2894:	0000007c 	andeq	r0, r0, ip, ror r0
    2898:	03fb9c01 	mvnseq	r9, #256	; 0x100
    289c:	41190000 	tstmi	r9, r0
    28a0:	9600000c 	strls	r0, [r0], -ip
    28a4:	02000003 	andeq	r0, r0, #3
    28a8:	bf1a6c91 	svclt	0x001a6c91
    28ac:	0200000f 	andeq	r0, r0, #15
    28b0:	00382b57 	eorseq	r2, r8, r7, asr fp
    28b4:	91020000 	mrsls	r0, (UNDEF: 2)
    28b8:	12761b68 	rsbsne	r1, r6, #104, 22	; 0x1a000
    28bc:	58020000 	stmdapl	r2, {}	; <UNPREDICTABLE>
    28c0:	00039b0b 	andeq	r9, r3, fp, lsl #22
    28c4:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    28c8:	0000581c 	andeq	r5, r0, ip, lsl r8
    28cc:	22181b00 	andscs	r1, r8, #0, 22
    28d0:	5f020000 	svcpl	0x00020000
    28d4:	00003811 	andeq	r3, r0, r1, lsl r8
    28d8:	70910200 	addsvc	r0, r1, r0, lsl #4
    28dc:	86180000 	ldrhi	r0, [r8], -r0
    28e0:	02000002 	andeq	r0, r0, #2
    28e4:	04150651 	ldreq	r0, [r5], #-1617	; 0xfffff9af
    28e8:	a24c0000 	subge	r0, ip, #0
    28ec:	00680000 	rsbeq	r0, r8, r0
    28f0:	9c010000 	stcls	0, cr0, [r1], {-0}
    28f4:	00000448 	andeq	r0, r0, r8, asr #8
    28f8:	000c4119 	andeq	r4, ip, r9, lsl r1
    28fc:	00039600 	andeq	r9, r3, r0, lsl #12
    2900:	6c910200 	lfmvs	f0, 4, [r1], {0}
    2904:	6e656c1d 	mcrvs	12, 3, r6, cr5, cr13, {0}
    2908:	21510200 	cmpcs	r1, r0, lsl #4
    290c:	00000059 	andeq	r0, r0, r9, asr r0
    2910:	1e689102 	lgnnee	f1, f2
    2914:	0000a260 	andeq	sl, r0, r0, ror #4
    2918:	00000048 	andeq	r0, r0, r8, asr #32
    291c:	0200691f 	andeq	r6, r0, #507904	; 0x7c000
    2920:	00591252 	subseq	r1, r9, r2, asr r2
    2924:	91020000 	mrsls	r0, (UNDEF: 2)
    2928:	18000074 	stmdane	r0, {r2, r4, r5, r6}
    292c:	00000305 	andeq	r0, r0, r5, lsl #6
    2930:	62072602 	andvs	r2, r7, #2097152	; 0x200000
    2934:	b4000004 	strlt	r0, [r0], #-4
    2938:	980000a0 	stmdals	r0, {r5, r7}
    293c:	01000001 	tsteq	r0, r1
    2940:	0004cf9c 	muleq	r4, ip, pc	; <UNPREDICTABLE>
    2944:	0c411900 	mcrreq	9, 0, r1, r1, cr0	; <UNPREDICTABLE>
    2948:	03960000 	orrseq	r0, r6, #0
    294c:	91020000 	mrsls	r0, (UNDEF: 2)
    2950:	0ffa1b64 	svceq	0x00fa1b64
    2954:	28020000 	stmdacs	r2, {}	; <UNPREDICTABLE>
    2958:	0000ef0a 	andeq	lr, r0, sl, lsl #30
    295c:	72910200 	addsvc	r0, r1, #0, 4
    2960:	0200691f 	andeq	r6, r0, #507904	; 0x7c000
    2964:	00460e32 	subeq	r0, r6, r2, lsr lr
    2968:	91020000 	mrsls	r0, (UNDEF: 2)
    296c:	006a1f76 	rsbeq	r1, sl, r6, ror pc
    2970:	46103202 	ldrmi	r3, [r0], -r2, lsl #4
    2974:	02000000 	andeq	r0, r0, #0
    2978:	e51b7491 	ldr	r7, [fp, #-1169]	; 0xfffffb6f
    297c:	0200000f 	andeq	r0, r0, #15
    2980:	00ef0a33 	rsceq	r0, pc, r3, lsr sl	; <UNPREDICTABLE>
    2984:	91020000 	mrsls	r0, (UNDEF: 2)
    2988:	66621f73 	uqsub16vs	r1, r2, r3
    298c:	45020072 	strmi	r0, [r2, #-114]	; 0xffffff8e
    2990:	00039b0b 	andeq	r9, r3, fp, lsl #22
    2994:	68910200 	ldmvs	r1, {r9}
    2998:	00a0e81e 	adceq	lr, r0, lr, lsl r8
    299c:	00003800 	andeq	r3, r0, r0, lsl #16
    29a0:	07011b00 	streq	r1, [r1, -r0, lsl #22]
    29a4:	2b020000 	blcs	829ac <__bss_end+0x768b4>
    29a8:	00005912 	andeq	r5, r0, r2, lsl r9
    29ac:	6c910200 	lfmvs	f0, 4, [r1], {0}
    29b0:	63200000 	nopvs	{0}	; <UNPREDICTABLE>
    29b4:	02000003 	andeq	r0, r0, #3
    29b8:	0004e806 	andeq	lr, r4, r6, lsl #16
    29bc:	00a07000 	adceq	r7, r0, r0
    29c0:	00004400 	andeq	r4, r0, r0, lsl #8
    29c4:	049c0100 	ldreq	r0, [ip], #256	; 0x100
    29c8:	19000005 	stmdbne	r0, {r0, r2}
    29cc:	00000c41 	andeq	r0, r0, r1, asr #24
    29d0:	00000396 	muleq	r0, r6, r3
    29d4:	1d6c9102 	stfnep	f1, [ip, #-8]!
    29d8:	00727473 	rsbseq	r7, r2, r3, ror r4
    29dc:	f6251c02 			; <UNDEFINED> instruction: 0xf6251c02
    29e0:	02000000 	andeq	r0, r0, #0
    29e4:	21006891 			; <UNDEFINED> instruction: 0x21006891
    29e8:	00000348 	andeq	r0, r0, r8, asr #6
    29ec:	1e061602 	cfmadd32ne	mvax0, mvfx1, mvfx6, mvfx2
    29f0:	38000005 	stmdacc	r0, {r0, r2}
    29f4:	380000a0 	stmdacc	r0, {r5, r7}
    29f8:	01000000 	mrseq	r0, (UNDEF: 0)
    29fc:	00052b9c 	muleq	r5, ip, fp
    2a00:	0c411900 	mcrreq	9, 0, r1, r1, cr0	; <UNPREDICTABLE>
    2a04:	03960000 	orrseq	r0, r6, #0
    2a08:	91020000 	mrsls	r0, (UNDEF: 2)
    2a0c:	67210074 			; <UNDEFINED> instruction: 0x67210074
    2a10:	02000002 	andeq	r0, r0, #2
    2a14:	05450611 	strbeq	r0, [r5, #-1553]	; 0xfffff9ef
    2a18:	9fe40000 	svcls	0x00e40000
    2a1c:	00540000 	subseq	r0, r4, r0
    2a20:	9c010000 	stcls	0, cr0, [r1], {-0}
    2a24:	0000055f 	andeq	r0, r0, pc, asr r5
    2a28:	000c4119 	andeq	r4, ip, r9, lsl r1
    2a2c:	00039600 	andeq	r9, r3, r0, lsl #12
    2a30:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    2a34:	0200631d 	andeq	r6, r0, #1946157056	; 0x74000000
    2a38:	00251c11 	eoreq	r1, r5, r1, lsl ip
    2a3c:	91020000 	mrsls	r0, (UNDEF: 2)
    2a40:	c3210073 			; <UNDEFINED> instruction: 0xc3210073
    2a44:	02000002 	andeq	r0, r0, #2
    2a48:	0579060d 	ldrbeq	r0, [r9, #-1549]!	; 0xfffff9f3
    2a4c:	9fac0000 	svcls	0x00ac0000
    2a50:	00380000 	eorseq	r0, r8, r0
    2a54:	9c010000 	stcls	0, cr0, [r1], {-0}
    2a58:	00000586 	andeq	r0, r0, r6, lsl #11
    2a5c:	000c4119 	andeq	r4, ip, r9, lsl r1
    2a60:	00039600 	andeq	r9, r3, r0, lsl #12
    2a64:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    2a68:	02a52100 	adceq	r2, r5, #0, 2
    2a6c:	09020000 	stmdbeq	r2, {}	; <UNPREDICTABLE>
    2a70:	0005a006 	andeq	sl, r5, r6
    2a74:	009f6c00 	addseq	r6, pc, r0, lsl #24
    2a78:	00004000 	andeq	r4, r0, r0
    2a7c:	ad9c0100 	ldfges	f0, [ip]
    2a80:	19000005 	stmdbne	r0, {r0, r2}
    2a84:	00000c41 	andeq	r0, r0, r1, asr #24
    2a88:	00000396 	muleq	r0, r6, r3
    2a8c:	00749102 	rsbseq	r9, r4, r2, lsl #2
    2a90:	0002e122 	andeq	lr, r2, r2, lsr #2
    2a94:	01060200 	mrseq	r0, LR_usr
    2a98:	000005be 			; <UNDEFINED> instruction: 0x000005be
    2a9c:	0005d400 	andeq	sp, r5, r0, lsl #8
    2aa0:	0c412300 	mcrreq	3, 0, r2, r1, cr0
    2aa4:	03960000 	orrseq	r0, r6, #0
    2aa8:	f0240000 			; <UNDEFINED> instruction: 0xf0240000
    2aac:	0200000f 	andeq	r0, r0, #15
    2ab0:	00591906 	subseq	r1, r9, r6, lsl #18
    2ab4:	25000000 	strcs	r0, [r0, #-0]
    2ab8:	000005ad 	andeq	r0, r0, sp, lsr #11
    2abc:	00000fd6 	ldrdeq	r0, [r0], -r6
    2ac0:	000005ef 	andeq	r0, r0, pc, ror #11
    2ac4:	00009f20 	andeq	r9, r0, r0, lsr #30
    2ac8:	0000004c 	andeq	r0, r0, ip, asr #32
    2acc:	06009c01 	streq	r9, [r0], -r1, lsl #24
    2ad0:	be260000 	cdplt	0, 2, cr0, cr6, cr0, {0}
    2ad4:	02000005 	andeq	r0, r0, #5
    2ad8:	c7267491 			; <UNDEFINED> instruction: 0xc7267491
    2adc:	02000005 	andeq	r0, r0, #5
    2ae0:	27007091 			; <UNDEFINED> instruction: 0x27007091
    2ae4:	00000c23 	andeq	r0, r0, r3, lsr #24
    2ae8:	0c0e0d01 	stceq	13, cr0, [lr], {1}
    2aec:	4b00000c 	blmi	2b24 <shift+0x2b24>
    2af0:	24000001 	strcs	r0, [r0], #-1
    2af4:	30000099 	mulcc	r0, r9, r0
    2af8:	01000000 	mrseq	r0, (UNDEF: 0)
    2afc:	15b51a9c 	ldrne	r1, [r5, #2716]!	; 0xa9c
    2b00:	0d010000 	stceq	0, cr0, [r1, #-0]
    2b04:	00005926 	andeq	r5, r0, r6, lsr #18
    2b08:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    2b0c:	0b910000 	bleq	fe442b14 <__bss_end+0xfe436a1c>
    2b10:	00040000 	andeq	r0, r4, r0
    2b14:	00000e3b 	andeq	r0, r0, fp, lsr lr
    2b18:	0e990104 	fmleqe	f0, f1, f4
    2b1c:	c6040000 	strgt	r0, [r4], -r0
    2b20:	36000016 			; <UNDEFINED> instruction: 0x36000016
    2b24:	3000000e 	andcc	r0, r0, lr
    2b28:	5c0000a3 	stcpl	0, cr0, [r0], {163}	; 0xa3
    2b2c:	7a000004 	bvc	2b44 <shift+0x2b44>
    2b30:	02000015 	andeq	r0, r0, #21
    2b34:	08600801 	stmdaeq	r0!, {r0, fp}^
    2b38:	25030000 	strcs	r0, [r3, #-0]
    2b3c:	02000000 	andeq	r0, r0, #0
    2b40:	08d90502 	ldmeq	r9, {r1, r8, sl}^
    2b44:	04040000 	streq	r0, [r4], #-0
    2b48:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
    2b4c:	08010200 	stmdaeq	r1, {r9}
    2b50:	00000857 	andeq	r0, r0, r7, asr r8
    2b54:	6a070202 	bvs	1c3364 <__bss_end+0x1b726c>
    2b58:	05000006 	streq	r0, [r0, #-6]
    2b5c:	0000097f 	andeq	r0, r0, pc, ror r9
    2b60:	5e070907 	vmlapl.f16	s0, s14, s14	; <UNPREDICTABLE>
    2b64:	03000000 	movweq	r0, #0
    2b68:	0000004d 	andeq	r0, r0, sp, asr #32
    2b6c:	98070402 	stmdals	r7, {r1, sl}
    2b70:	0600001f 			; <UNDEFINED> instruction: 0x0600001f
    2b74:	00001247 	andeq	r1, r0, r7, asr #4
    2b78:	08060208 	stmdaeq	r6, {r3, r9}
    2b7c:	0000008b 	andeq	r0, r0, fp, lsl #1
    2b80:	00307207 	eorseq	r7, r0, r7, lsl #4
    2b84:	4d0e0802 	stcmi	8, cr0, [lr, #-8]
    2b88:	00000000 	andeq	r0, r0, r0
    2b8c:	00317207 	eorseq	r7, r1, r7, lsl #4
    2b90:	4d0e0902 	vstrmi.16	s0, [lr, #-4]	; <UNPREDICTABLE>
    2b94:	04000000 	streq	r0, [r0], #-0
    2b98:	16f60800 	ldrbtne	r0, [r6], r0, lsl #16
    2b9c:	04050000 	streq	r0, [r5], #-0
    2ba0:	00000038 	andeq	r0, r0, r8, lsr r0
    2ba4:	a90c0d02 	stmdbge	ip, {r1, r8, sl, fp}
    2ba8:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
    2bac:	00004b4f 	andeq	r4, r0, pc, asr #22
    2bb0:	0012600a 	andseq	r6, r2, sl
    2bb4:	08000100 	stmdaeq	r0, {r8}
    2bb8:	00001128 	andeq	r1, r0, r8, lsr #2
    2bbc:	00380405 	eorseq	r0, r8, r5, lsl #8
    2bc0:	1e020000 	cdpne	0, 0, cr0, cr2, cr0, {0}
    2bc4:	0000ec0c 	andeq	lr, r0, ip, lsl #24
    2bc8:	12b20a00 	adcsne	r0, r2, #0, 20
    2bcc:	0a000000 	beq	2bd4 <shift+0x2bd4>
    2bd0:	00001997 	muleq	r0, r7, r9
    2bd4:	19770a01 	ldmdbne	r7!, {r0, r9, fp}^
    2bd8:	0a020000 	beq	82be0 <__bss_end+0x76ae8>
    2bdc:	0000146d 	andeq	r1, r0, sp, ror #8
    2be0:	15d00a03 	ldrbne	r0, [r0, #2563]	; 0xa03
    2be4:	0a040000 	beq	102bec <__bss_end+0xf6af4>
    2be8:	00001272 	andeq	r1, r0, r2, ror r2
    2bec:	10b20a05 	adcsne	r0, r2, r5, lsl #20
    2bf0:	0a060000 	beq	182bf8 <__bss_end+0x176b00>
    2bf4:	00001939 	andeq	r1, r0, r9, lsr r9
    2bf8:	f7080007 			; <UNDEFINED> instruction: 0xf7080007
    2bfc:	05000018 	streq	r0, [r0, #-24]	; 0xffffffe8
    2c00:	00003804 	andeq	r3, r0, r4, lsl #16
    2c04:	0c490200 	sfmeq	f0, 2, [r9], {-0}
    2c08:	00000129 	andeq	r0, r0, r9, lsr #2
    2c0c:	0010470a 	andseq	r4, r0, sl, lsl #14
    2c10:	3d0a0000 	stccc	0, cr0, [sl, #-0]
    2c14:	01000011 	tsteq	r0, r1, lsl r0
    2c18:	0007f10a 	andeq	pc, r7, sl, lsl #2
    2c1c:	430a0200 	movwmi	r0, #41472	; 0xa200
    2c20:	03000019 	movweq	r0, #25
    2c24:	0019a10a 	andseq	sl, r9, sl, lsl #2
    2c28:	6e0a0400 	cfcpysvs	mvf0, mvf10
    2c2c:	05000015 	streq	r0, [r0, #-21]	; 0xffffffeb
    2c30:	0014340a 	andseq	r3, r4, sl, lsl #8
    2c34:	08000600 	stmdaeq	r0, {r9, sl}
    2c38:	000018b1 			; <UNDEFINED> instruction: 0x000018b1
    2c3c:	00380405 	eorseq	r0, r8, r5, lsl #8
    2c40:	70020000 	andvc	r0, r2, r0
    2c44:	0001540c 	andeq	r5, r1, ip, lsl #8
    2c48:	16450a00 	strbne	r0, [r5], -r0, lsl #20
    2c4c:	0a000000 	beq	2c54 <shift+0x2c54>
    2c50:	000013e1 	andeq	r1, r0, r1, ror #7
    2c54:	168f0a01 	strne	r0, [pc], r1, lsl #20
    2c58:	0a020000 	beq	82c60 <__bss_end+0x76b68>
    2c5c:	00001439 	andeq	r1, r0, r9, lsr r4
    2c60:	550b0003 	strpl	r0, [fp, #-3]
    2c64:	03000007 	movweq	r0, #7
    2c68:	00591405 	subseq	r1, r9, r5, lsl #8
    2c6c:	03050000 	movweq	r0, #20480	; 0x5000
    2c70:	0000c084 	andeq	ip, r0, r4, lsl #1
    2c74:	0007c80b 	andeq	ip, r7, fp, lsl #16
    2c78:	14060300 	strne	r0, [r6], #-768	; 0xfffffd00
    2c7c:	00000059 	andeq	r0, r0, r9, asr r0
    2c80:	c0880305 	addgt	r0, r8, r5, lsl #6
    2c84:	1e0b0000 	cdpne	0, 0, cr0, cr11, cr0, {0}
    2c88:	04000007 	streq	r0, [r0], #-7
    2c8c:	00591a07 	subseq	r1, r9, r7, lsl #20
    2c90:	03050000 	movweq	r0, #20480	; 0x5000
    2c94:	0000c08c 	andeq	ip, r0, ip, lsl #1
    2c98:	0004a10b 	andeq	sl, r4, fp, lsl #2
    2c9c:	1a090400 	bne	243ca4 <__bss_end+0x237bac>
    2ca0:	00000059 	andeq	r0, r0, r9, asr r0
    2ca4:	c0900305 	addsgt	r0, r0, r5, lsl #6
    2ca8:	2c0b0000 	stccs	0, cr0, [fp], {-0}
    2cac:	04000008 	streq	r0, [r0], #-8
    2cb0:	00591a0b 	subseq	r1, r9, fp, lsl #20
    2cb4:	03050000 	movweq	r0, #20480	; 0x5000
    2cb8:	0000c094 	muleq	r0, r4, r0
    2cbc:	0006570b 	andeq	r5, r6, fp, lsl #14
    2cc0:	1a0d0400 	bne	343cc8 <__bss_end+0x337bd0>
    2cc4:	00000059 	andeq	r0, r0, r9, asr r0
    2cc8:	c0980305 	addsgt	r0, r8, r5, lsl #6
    2ccc:	240b0000 	strcs	r0, [fp], #-0
    2cd0:	04000005 	streq	r0, [r0], #-5
    2cd4:	00591a0f 	subseq	r1, r9, pc, lsl #20
    2cd8:	03050000 	movweq	r0, #20480	; 0x5000
    2cdc:	0000c09c 	muleq	r0, ip, r0
    2ce0:	00196708 	andseq	r6, r9, r8, lsl #14
    2ce4:	38040500 	stmdacc	r4, {r8, sl}
    2ce8:	04000000 	streq	r0, [r0], #-0
    2cec:	01f70c1b 	mvnseq	r0, fp, lsl ip
    2cf0:	c80a0000 	stmdagt	sl, {}	; <UNPREDICTABLE>
    2cf4:	00000009 	andeq	r0, r0, r9
    2cf8:	000b990a 	andeq	r9, fp, sl, lsl #18
    2cfc:	ec0a0100 	stfs	f0, [sl], {-0}
    2d00:	02000007 	andeq	r0, r0, #7
    2d04:	163f0c00 	ldrtne	r0, [pc], -r0, lsl #24
    2d08:	01020000 	mrseq	r0, (UNDEF: 2)
    2d0c:	0006b602 	andeq	fp, r6, r2, lsl #12
    2d10:	2c040d00 	stccs	13, cr0, [r4], {-0}
    2d14:	0d000000 	stceq	0, cr0, [r0, #-0]
    2d18:	0001f704 	andeq	pc, r1, r4, lsl #14
    2d1c:	05a00b00 	streq	r0, [r0, #2816]!	; 0xb00
    2d20:	04050000 	streq	r0, [r5], #-0
    2d24:	00005914 	andeq	r5, r0, r4, lsl r9
    2d28:	a0030500 	andge	r0, r3, r0, lsl #10
    2d2c:	0b0000c0 	bleq	3034 <shift+0x3034>
    2d30:	00000337 	andeq	r0, r0, r7, lsr r3
    2d34:	59140705 	ldmdbpl	r4, {r0, r2, r8, r9, sl}
    2d38:	05000000 	streq	r0, [r0, #-0]
    2d3c:	00c0a403 	sbceq	sl, r0, r3, lsl #8
    2d40:	04f60b00 	ldrbteq	r0, [r6], #2816	; 0xb00
    2d44:	0a050000 	beq	142d4c <__bss_end+0x136c54>
    2d48:	00005914 	andeq	r5, r0, r4, lsl r9
    2d4c:	a8030500 	stmdage	r3, {r8, sl}
    2d50:	080000c0 	stmdaeq	r0, {r6, r7}
    2d54:	000014c8 	andeq	r1, r0, r8, asr #9
    2d58:	00380405 	eorseq	r0, r8, r5, lsl #8
    2d5c:	0d050000 	stceq	0, cr0, [r5, #-0]
    2d60:	00027c0c 	andeq	r7, r2, ip, lsl #24
    2d64:	654e0900 	strbvs	r0, [lr, #-2304]	; 0xfffff700
    2d68:	0a000077 	beq	2f4c <shift+0x2f4c>
    2d6c:	000014bf 			; <UNDEFINED> instruction: 0x000014bf
    2d70:	17070a01 	strne	r0, [r7, -r1, lsl #20]
    2d74:	0a020000 	beq	82d7c <__bss_end+0x76c84>
    2d78:	00001491 	muleq	r0, r1, r4
    2d7c:	145f0a03 	ldrbne	r0, [pc], #-2563	; 2d84 <shift+0x2d84>
    2d80:	0a040000 	beq	102d88 <__bss_end+0xf6c90>
    2d84:	000015c9 	andeq	r1, r0, r9, asr #11
    2d88:	65060005 	strvs	r0, [r6, #-5]
    2d8c:	10000012 	andne	r0, r0, r2, lsl r0
    2d90:	bb081b05 	bllt	2099ac <__bss_end+0x1fd8b4>
    2d94:	07000002 	streq	r0, [r0, -r2]
    2d98:	0500726c 	streq	r7, [r0, #-620]	; 0xfffffd94
    2d9c:	02bb131d 	adcseq	r1, fp, #1946157056	; 0x74000000
    2da0:	07000000 	streq	r0, [r0, -r0]
    2da4:	05007073 	streq	r7, [r0, #-115]	; 0xffffff8d
    2da8:	02bb131e 	adcseq	r1, fp, #2013265920	; 0x78000000
    2dac:	07040000 	streq	r0, [r4, -r0]
    2db0:	05006370 	streq	r6, [r0, #-880]	; 0xfffffc90
    2db4:	02bb131f 	adcseq	r1, fp, #2080374784	; 0x7c000000
    2db8:	0e080000 	cdpeq	0, 0, cr0, cr8, cr0, {0}
    2dbc:	00001284 	andeq	r1, r0, r4, lsl #5
    2dc0:	bb132005 	bllt	4caddc <__bss_end+0x4bece4>
    2dc4:	0c000002 	stceq	0, cr0, [r0], {2}
    2dc8:	07040200 	streq	r0, [r4, -r0, lsl #4]
    2dcc:	00001f93 	muleq	r0, r3, pc	; <UNPREDICTABLE>
    2dd0:	00132106 	andseq	r2, r3, r6, lsl #2
    2dd4:	28057c00 	stmdacs	r5, {sl, fp, ip, sp, lr}
    2dd8:	00037908 	andeq	r7, r3, r8, lsl #18
    2ddc:	17740e00 	ldrbne	r0, [r4, -r0, lsl #28]!
    2de0:	2a050000 	bcs	142de8 <__bss_end+0x136cf0>
    2de4:	00027c12 	andeq	r7, r2, r2, lsl ip
    2de8:	70070000 	andvc	r0, r7, r0
    2dec:	05006469 	streq	r6, [r0, #-1129]	; 0xfffffb97
    2df0:	005e122b 	subseq	r1, lr, fp, lsr #4
    2df4:	0e100000 	cdpeq	0, 1, cr0, cr0, cr0, {0}
    2df8:	00001182 	andeq	r1, r0, r2, lsl #3
    2dfc:	45112c05 	ldrmi	r2, [r1, #-3077]	; 0xfffff3fb
    2e00:	14000002 	strne	r0, [r0], #-2
    2e04:	0014d40e 	andseq	sp, r4, lr, lsl #8
    2e08:	122d0500 	eorne	r0, sp, #0, 10
    2e0c:	0000005e 	andeq	r0, r0, lr, asr r0
    2e10:	150f0e18 	strne	r0, [pc, #-3608]	; 2000 <shift+0x2000>
    2e14:	2e050000 	cdpcs	0, 0, cr0, cr5, cr0, {0}
    2e18:	00005e12 	andeq	r5, r0, r2, lsl lr
    2e1c:	530e1c00 	movwpl	r1, #60416	; 0xec00
    2e20:	05000012 	streq	r0, [r0, #-18]	; 0xffffffee
    2e24:	03790c2f 	cmneq	r9, #12032	; 0x2f00
    2e28:	0e200000 	cdpeq	0, 2, cr0, cr0, cr0, {0}
    2e2c:	000014e8 	andeq	r1, r0, r8, ror #9
    2e30:	38093005 	stmdacc	r9, {r0, r2, ip, sp}
    2e34:	60000000 	andvs	r0, r0, r0
    2e38:	0017800e 	andseq	r8, r7, lr
    2e3c:	0e310500 	cfabs32eq	mvfx0, mvfx1
    2e40:	0000004d 	andeq	r0, r0, sp, asr #32
    2e44:	12c30e64 	sbcne	r0, r3, #100, 28	; 0x640
    2e48:	33050000 	movwcc	r0, #20480	; 0x5000
    2e4c:	00004d0e 	andeq	r4, r0, lr, lsl #26
    2e50:	ba0e6800 	blt	39ce58 <__bss_end+0x390d60>
    2e54:	05000012 	streq	r0, [r0, #-18]	; 0xffffffee
    2e58:	004d0e34 	subeq	r0, sp, r4, lsr lr
    2e5c:	0e6c0000 	cdpeq	0, 6, cr0, cr12, cr0, {0}
    2e60:	00001400 	andeq	r1, r0, r0, lsl #8
    2e64:	4d0e3505 	cfstr32mi	mvfx3, [lr, #-20]	; 0xffffffec
    2e68:	70000000 	andvc	r0, r0, r0
    2e6c:	0015ba0e 	andseq	fp, r5, lr, lsl #20
    2e70:	0e360500 	cfabs32eq	mvfx0, mvfx6
    2e74:	0000004d 	andeq	r0, r0, sp, asr #32
    2e78:	19490e74 	stmdbne	r9, {r2, r4, r5, r6, r9, sl, fp}^
    2e7c:	37050000 	strcc	r0, [r5, -r0]
    2e80:	00004d0e 	andeq	r4, r0, lr, lsl #26
    2e84:	0f007800 	svceq	0x00007800
    2e88:	00000209 	andeq	r0, r0, r9, lsl #4
    2e8c:	00000389 	andeq	r0, r0, r9, lsl #7
    2e90:	00005e10 	andeq	r5, r0, r0, lsl lr
    2e94:	0b000f00 	bleq	6a9c <shift+0x6a9c>
    2e98:	00000ac6 	andeq	r0, r0, r6, asr #21
    2e9c:	59140a06 	ldmdbpl	r4, {r1, r2, r9, fp}
    2ea0:	05000000 	streq	r0, [r0, #-0]
    2ea4:	00c0ac03 	sbceq	sl, r0, r3, lsl #24
    2ea8:	14990800 	ldrne	r0, [r9], #2048	; 0x800
    2eac:	04050000 	streq	r0, [r5], #-0
    2eb0:	00000038 	andeq	r0, r0, r8, lsr r0
    2eb4:	ba0c0d06 	blt	3062d4 <__bss_end+0x2fa1dc>
    2eb8:	0a000003 	beq	2ecc <shift+0x2ecc>
    2ebc:	00001142 	andeq	r1, r0, r2, asr #2
    2ec0:	103c0a00 	eorsne	r0, ip, r0, lsl #20
    2ec4:	00010000 	andeq	r0, r1, r0
    2ec8:	00039b03 	andeq	r9, r3, r3, lsl #22
    2ecc:	154a0800 	strbne	r0, [sl, #-2048]	; 0xfffff800
    2ed0:	04050000 	streq	r0, [r5], #-0
    2ed4:	00000038 	andeq	r0, r0, r8, lsr r0
    2ed8:	de0c1406 	cdple	4, 0, cr1, cr12, cr6, {0}
    2edc:	0a000003 	beq	2ef0 <shift+0x2ef0>
    2ee0:	00001086 	andeq	r1, r0, r6, lsl #1
    2ee4:	16810a00 	strne	r0, [r1], r0, lsl #20
    2ee8:	00010000 	andeq	r0, r1, r0
    2eec:	0003bf03 	andeq	fp, r3, r3, lsl #30
    2ef0:	18400600 	stmdane	r0, {r9, sl}^
    2ef4:	060c0000 	streq	r0, [ip], -r0
    2ef8:	0418081b 	ldreq	r0, [r8], #-2075	; 0xfffff7e5
    2efc:	810e0000 	mrshi	r0, (UNDEF: 14)
    2f00:	06000010 			; <UNDEFINED> instruction: 0x06000010
    2f04:	0418191d 	ldreq	r1, [r8], #-2333	; 0xfffff6e3
    2f08:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    2f0c:	000010ff 	strdeq	r1, [r0], -pc	; <UNPREDICTABLE>
    2f10:	18191e06 	ldmdane	r9, {r1, r2, r9, sl, fp, ip}
    2f14:	04000004 	streq	r0, [r0], #-4
    2f18:	0017f40e 	andseq	pc, r7, lr, lsl #8
    2f1c:	131f0600 	tstne	pc, #0, 12
    2f20:	0000041e 	andeq	r0, r0, lr, lsl r4
    2f24:	040d0008 	streq	r0, [sp], #-8
    2f28:	000003e3 	andeq	r0, r0, r3, ror #7
    2f2c:	02c2040d 	sbceq	r0, r2, #218103808	; 0xd000000
    2f30:	a7110000 	ldrge	r0, [r1, -r0]
    2f34:	14000011 	strne	r0, [r0], #-17	; 0xffffffef
    2f38:	e5072206 	str	r2, [r7, #-518]	; 0xfffffdfa
    2f3c:	0e000006 	cdpeq	0, 0, cr0, cr0, cr6, {0}
    2f40:	00001487 	andeq	r1, r0, r7, lsl #9
    2f44:	4d122606 	ldcmi	6, cr2, [r2, #-24]	; 0xffffffe8
    2f48:	00000000 	andeq	r0, r0, r0
    2f4c:	0010b90e 	andseq	fp, r0, lr, lsl #18
    2f50:	1d290600 	stcne	6, cr0, [r9, #-0]
    2f54:	00000418 	andeq	r0, r0, r8, lsl r4
    2f58:	174b0e04 	strbne	r0, [fp, -r4, lsl #28]
    2f5c:	2c060000 	stccs	0, cr0, [r6], {-0}
    2f60:	0004181d 	andeq	r1, r4, sp, lsl r8
    2f64:	ed120800 	ldc	8, cr0, [r2, #-0]
    2f68:	06000018 			; <UNDEFINED> instruction: 0x06000018
    2f6c:	181d0e2f 	ldmdane	sp, {r0, r1, r2, r3, r5, r9, sl, fp}
    2f70:	046c0000 	strbteq	r0, [ip], #-0
    2f74:	04770000 	ldrbteq	r0, [r7], #-0
    2f78:	ea130000 	b	4c2f80 <__bss_end+0x4b6e88>
    2f7c:	14000006 	strne	r0, [r0], #-6
    2f80:	00000418 	andeq	r0, r0, r8, lsl r4
    2f84:	18051500 	stmdane	r5, {r8, sl, ip}
    2f88:	31060000 	mrscc	r0, (UNDEF: 6)
    2f8c:	0012f80e 	andseq	pc, r2, lr, lsl #16
    2f90:	0001fc00 	andeq	pc, r1, r0, lsl #24
    2f94:	00048f00 	andeq	r8, r4, r0, lsl #30
    2f98:	00049a00 	andeq	r9, r4, r0, lsl #20
    2f9c:	06ea1300 	strbteq	r1, [sl], r0, lsl #6
    2fa0:	1e140000 	cdpne	0, 1, cr0, cr4, cr0, {0}
    2fa4:	00000004 	andeq	r0, r0, r4
    2fa8:	00185316 	andseq	r5, r8, r6, lsl r3
    2fac:	1d350600 	ldcne	6, cr0, [r5, #-0]
    2fb0:	000017cf 	andeq	r1, r0, pc, asr #15
    2fb4:	00000418 	andeq	r0, r0, r8, lsl r4
    2fb8:	0004b302 	andeq	fp, r4, r2, lsl #6
    2fbc:	0004b900 	andeq	fp, r4, r0, lsl #18
    2fc0:	06ea1300 	strbteq	r1, [sl], r0, lsl #6
    2fc4:	16000000 	strne	r0, [r0], -r0
    2fc8:	00001427 	andeq	r1, r0, r7, lsr #8
    2fcc:	501d3706 	andspl	r3, sp, r6, lsl #14
    2fd0:	18000016 	stmdane	r0, {r1, r2, r4}
    2fd4:	02000004 	andeq	r0, r0, #4
    2fd8:	000004d2 	ldrdeq	r0, [r0], -r2
    2fdc:	000004d8 	ldrdeq	r0, [r0], -r8
    2fe0:	0006ea13 	andeq	lr, r6, r3, lsl sl
    2fe4:	2b170000 	blcs	5c2fec <__bss_end+0x5b6ef4>
    2fe8:	06000015 			; <UNDEFINED> instruction: 0x06000015
    2fec:	07033139 	smladxeq	r3, r9, r1, r3
    2ff0:	020c0000 	andeq	r0, ip, #0
    2ff4:	0011a716 	andseq	sl, r1, r6, lsl r7
    2ff8:	093c0600 	ldmdbeq	ip!, {r9, sl}
    2ffc:	0000197d 	andeq	r1, r0, sp, ror r9
    3000:	000006ea 	andeq	r0, r0, sl, ror #13
    3004:	0004ff01 	andeq	pc, r4, r1, lsl #30
    3008:	00050500 	andeq	r0, r5, r0, lsl #10
    300c:	06ea1300 	strbteq	r1, [sl], r0, lsl #6
    3010:	16000000 	strne	r0, [r0], -r0
    3014:	00000a4b 	andeq	r0, r0, fp, asr #20
    3018:	f2123d06 	vadd.f16	d3, d2, d6
    301c:	4d000014 	stcmi	0, cr0, [r0, #-80]	; 0xffffffb0
    3020:	01000000 	mrseq	r0, (UNDEF: 0)
    3024:	0000051e 	andeq	r0, r0, lr, lsl r5
    3028:	00000529 	andeq	r0, r0, r9, lsr #10
    302c:	0006ea13 	andeq	lr, r6, r3, lsl sl
    3030:	004d1400 	subeq	r1, sp, r0, lsl #8
    3034:	16000000 	strne	r0, [r0], -r0
    3038:	00001157 	andeq	r1, r0, r7, asr r1
    303c:	c2123f06 	andsgt	r3, r2, #6, 30
    3040:	4d000018 	stcmi	0, cr0, [r0, #-96]	; 0xffffffa0
    3044:	01000000 	mrseq	r0, (UNDEF: 0)
    3048:	00000542 	andeq	r0, r0, r2, asr #10
    304c:	00000557 	andeq	r0, r0, r7, asr r5
    3050:	0006ea13 	andeq	lr, r6, r3, lsl sl
    3054:	070c1400 	streq	r1, [ip, -r0, lsl #8]
    3058:	5e140000 	cdppl	0, 1, cr0, cr4, cr0, {0}
    305c:	14000000 	strne	r0, [r0], #-0
    3060:	000001fc 	strdeq	r0, [r0], -ip
    3064:	15891800 	strne	r1, [r9, #2048]	; 0x800
    3068:	41060000 	mrsmi	r0, (UNDEF: 6)
    306c:	00134e0e 	andseq	r4, r3, lr, lsl #28
    3070:	056c0100 	strbeq	r0, [ip, #-256]!	; 0xffffff00
    3074:	05720000 	ldrbeq	r0, [r2, #-0]!
    3078:	ea130000 	b	4c3080 <__bss_end+0x4b6f88>
    307c:	00000006 	andeq	r0, r0, r6
    3080:	00181418 	andseq	r1, r8, r8, lsl r4
    3084:	0e430600 	cdpeq	6, 4, cr0, cr3, cr0, {0}
    3088:	000015f1 	strdeq	r1, [r0], -r1	; <UNPREDICTABLE>
    308c:	00058701 	andeq	r8, r5, r1, lsl #14
    3090:	00058d00 	andeq	r8, r5, r0, lsl #26
    3094:	06ea1300 	strbteq	r1, [sl], r0, lsl #6
    3098:	16000000 	strne	r0, [r0], -r0
    309c:	00001392 	muleq	r0, r2, r3
    30a0:	d1174606 	tstle	r7, r6, lsl #12
    30a4:	1e000010 	mcrne	0, 0, r0, cr0, cr0, {0}
    30a8:	01000004 	tsteq	r0, r4
    30ac:	000005a6 	andeq	r0, r0, r6, lsr #11
    30b0:	000005ac 	andeq	r0, r0, ip, lsr #11
    30b4:	00071213 	andeq	r1, r7, r3, lsl r2
    30b8:	04160000 	ldreq	r0, [r6], #-0
    30bc:	06000011 			; <UNDEFINED> instruction: 0x06000011
    30c0:	178c1749 	strne	r1, [ip, r9, asr #14]
    30c4:	041e0000 	ldreq	r0, [lr], #-0
    30c8:	c5010000 	strgt	r0, [r1, #-0]
    30cc:	d0000005 	andle	r0, r0, r5
    30d0:	13000005 	movwne	r0, #5
    30d4:	00000712 	andeq	r0, r0, r2, lsl r7
    30d8:	00004d14 	andeq	r4, r0, r4, lsl sp
    30dc:	cb180000 	blgt	6030e4 <__bss_end+0x5f6fec>
    30e0:	06000013 			; <UNDEFINED> instruction: 0x06000013
    30e4:	104c0e4c 	subne	r0, ip, ip, asr #28
    30e8:	e5010000 	str	r0, [r1, #-0]
    30ec:	eb000005 	bl	3108 <shift+0x3108>
    30f0:	13000005 	movwne	r0, #5
    30f4:	000006ea 	andeq	r0, r0, sl, ror #13
    30f8:	18051600 	stmdane	r5, {r9, sl, ip}
    30fc:	4e060000 	cdpmi	0, 0, cr0, cr6, cr0, {0}
    3100:	00128a0e 	andseq	r8, r2, lr, lsl #20
    3104:	0001fc00 	andeq	pc, r1, r0, lsl #24
    3108:	06040100 	streq	r0, [r4], -r0, lsl #2
    310c:	060f0000 	streq	r0, [pc], -r0
    3110:	ea130000 	b	4c3118 <__bss_end+0x4b7020>
    3114:	14000006 	strne	r0, [r0], #-6
    3118:	0000004d 	andeq	r0, r0, sp, asr #32
    311c:	13b71600 			; <UNDEFINED> instruction: 0x13b71600
    3120:	51060000 	mrspl	r0, (UNDEF: 6)
    3124:	00161212 	andseq	r1, r6, r2, lsl r2
    3128:	00004d00 	andeq	r4, r0, r0, lsl #26
    312c:	06280100 	strteq	r0, [r8], -r0, lsl #2
    3130:	06330000 	ldrteq	r0, [r3], -r0
    3134:	ea130000 	b	4c313c <__bss_end+0x4b7044>
    3138:	14000006 	strne	r0, [r0], #-6
    313c:	00000209 	andeq	r0, r0, r9, lsl #4
    3140:	10931600 	addsne	r1, r3, r0, lsl #12
    3144:	54060000 	strpl	r0, [r6], #-0
    3148:	0012cc0e 	andseq	ip, r2, lr, lsl #24
    314c:	0001fc00 	andeq	pc, r1, r0, lsl #24
    3150:	064c0100 	strbeq	r0, [ip], -r0, lsl #2
    3154:	06570000 	ldrbeq	r0, [r7], -r0
    3158:	ea130000 	b	4c3160 <__bss_end+0x4b7068>
    315c:	14000006 	strne	r0, [r0], #-6
    3160:	0000004d 	andeq	r0, r0, sp, asr #32
    3164:	140e1800 	strne	r1, [lr], #-2048	; 0xfffff800
    3168:	57060000 	strpl	r0, [r6, -r0]
    316c:	00185f0e 	andseq	r5, r8, lr, lsl #30
    3170:	066c0100 	strbteq	r0, [ip], -r0, lsl #2
    3174:	068b0000 	streq	r0, [fp], r0
    3178:	ea130000 	b	4c3180 <__bss_end+0x4b7088>
    317c:	14000006 	strne	r0, [r0], #-6
    3180:	000000a9 	andeq	r0, r0, r9, lsr #1
    3184:	00004d14 	andeq	r4, r0, r4, lsl sp
    3188:	004d1400 	subeq	r1, sp, r0, lsl #8
    318c:	4d140000 	ldcmi	0, cr0, [r4, #-0]
    3190:	14000000 	strne	r0, [r0], #-0
    3194:	00000718 	andeq	r0, r0, r8, lsl r7
    3198:	17b91800 	ldrne	r1, [r9, r0, lsl #16]!
    319c:	59060000 	stmdbpl	r6, {}	; <UNPREDICTABLE>
    31a0:	0011fb0e 	andseq	pc, r1, lr, lsl #22
    31a4:	06a00100 	strteq	r0, [r0], r0, lsl #2
    31a8:	06bf0000 	ldrteq	r0, [pc], r0
    31ac:	ea130000 	b	4c31b4 <__bss_end+0x4b70bc>
    31b0:	14000006 	strne	r0, [r0], #-6
    31b4:	000000ec 	andeq	r0, r0, ip, ror #1
    31b8:	00004d14 	andeq	r4, r0, r4, lsl sp
    31bc:	004d1400 	subeq	r1, sp, r0, lsl #8
    31c0:	4d140000 	ldcmi	0, cr0, [r4, #-0]
    31c4:	14000000 	strne	r0, [r0], #-0
    31c8:	00000718 	andeq	r0, r0, r8, lsl r7
    31cc:	11941900 	orrsne	r1, r4, r0, lsl #18
    31d0:	5c060000 	stcpl	0, cr0, [r6], {-0}
    31d4:	0011b80e 	andseq	fp, r1, lr, lsl #16
    31d8:	0001fc00 	andeq	pc, r1, r0, lsl #24
    31dc:	06d40100 	ldrbeq	r0, [r4], r0, lsl #2
    31e0:	ea130000 	b	4c31e8 <__bss_end+0x4b70f0>
    31e4:	14000006 	strne	r0, [r0], #-6
    31e8:	0000039b 	muleq	r0, fp, r3
    31ec:	00071e14 	andeq	r1, r7, r4, lsl lr
    31f0:	03000000 	movweq	r0, #0
    31f4:	00000424 	andeq	r0, r0, r4, lsr #8
    31f8:	0424040d 	strteq	r0, [r4], #-1037	; 0xfffffbf3
    31fc:	181a0000 	ldmdane	sl, {}	; <UNPREDICTABLE>
    3200:	fd000004 	stc2	0, cr0, [r0, #-16]
    3204:	03000006 	movweq	r0, #6
    3208:	13000007 	movwne	r0, #7
    320c:	000006ea 	andeq	r0, r0, sl, ror #13
    3210:	04241b00 	strteq	r1, [r4], #-2816	; 0xfffff500
    3214:	06f00000 	ldrbteq	r0, [r0], r0
    3218:	040d0000 	streq	r0, [sp], #-0
    321c:	0000003f 	andeq	r0, r0, pc, lsr r0
    3220:	06e5040d 	strbteq	r0, [r5], sp, lsl #8
    3224:	041c0000 	ldreq	r0, [ip], #-0
    3228:	00000065 	andeq	r0, r0, r5, rrx
    322c:	2c0f041d 	cfstrscs	mvf0, [pc], {29}
    3230:	30000000 	andcc	r0, r0, r0
    3234:	10000007 	andne	r0, r0, r7
    3238:	0000005e 	andeq	r0, r0, lr, asr r0
    323c:	20030009 	andcs	r0, r3, r9
    3240:	1e000007 	cdpne	0, 0, cr0, cr0, cr7, {0}
    3244:	000013a6 	andeq	r1, r0, r6, lsr #7
    3248:	300ca501 	andcc	sl, ip, r1, lsl #10
    324c:	05000007 	streq	r0, [r0, #-7]
    3250:	00c0b003 	sbceq	fp, r0, r3
    3254:	10cc1f00 	sbcne	r1, ip, r0, lsl #30
    3258:	a7010000 	strge	r0, [r1, -r0]
    325c:	00153e0a 	andseq	r3, r5, sl, lsl #28
    3260:	00004d00 	andeq	r4, r0, r0, lsl #26
    3264:	00a6dc00 	adceq	sp, r6, r0, lsl #24
    3268:	0000b000 	andeq	fp, r0, r0
    326c:	a59c0100 	ldrge	r0, [ip, #256]	; 0x100
    3270:	20000007 	andcs	r0, r0, r7
    3274:	00001934 	andeq	r1, r0, r4, lsr r9
    3278:	031ba701 	tsteq	fp, #262144	; 0x40000
    327c:	03000002 	movweq	r0, #2
    3280:	207fac91 			; <UNDEFINED> instruction: 0x207fac91
    3284:	000015b1 			; <UNDEFINED> instruction: 0x000015b1
    3288:	4d2aa701 	stcmi	7, cr10, [sl, #-4]!
    328c:	03000000 	movweq	r0, #0
    3290:	1e7fa891 	mrcne	8, 3, sl, cr15, cr1, {4}
    3294:	000014b9 			; <UNDEFINED> instruction: 0x000014b9
    3298:	a50aa901 	strge	sl, [sl, #-2305]	; 0xfffff6ff
    329c:	03000007 	movweq	r0, #7
    32a0:	1e7fb491 	mrcne	4, 3, fp, cr15, cr1, {4}
    32a4:	000010ad 	andeq	r1, r0, sp, lsr #1
    32a8:	3809ad01 	stmdacc	r9, {r0, r8, sl, fp, sp, pc}
    32ac:	02000000 	andeq	r0, r0, #0
    32b0:	0f007491 	svceq	0x00007491
    32b4:	00000025 	andeq	r0, r0, r5, lsr #32
    32b8:	000007b5 			; <UNDEFINED> instruction: 0x000007b5
    32bc:	00005e10 	andeq	r5, r0, r0, lsl lr
    32c0:	21003f00 	tstcs	r0, r0, lsl #30
    32c4:	00001596 	muleq	r0, r6, r5
    32c8:	a60a9901 	strge	r9, [sl], -r1, lsl #18
    32cc:	4d000016 	stcmi	0, cr0, [r0, #-88]	; 0xffffffa8
    32d0:	a0000000 	andge	r0, r0, r0
    32d4:	3c0000a6 	stccc	0, cr0, [r0], {166}	; 0xa6
    32d8:	01000000 	mrseq	r0, (UNDEF: 0)
    32dc:	0007f29c 	muleq	r7, ip, r2
    32e0:	65722200 	ldrbvs	r2, [r2, #-512]!	; 0xfffffe00
    32e4:	9b010071 	blls	434b0 <__bss_end+0x373b8>
    32e8:	0003de20 	andeq	sp, r3, r0, lsr #28
    32ec:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    32f0:	0015251e 	andseq	r2, r5, lr, lsl r5
    32f4:	0e9c0100 	fmleqe	f0, f4, f0
    32f8:	0000004d 	andeq	r0, r0, sp, asr #32
    32fc:	00709102 	rsbseq	r9, r0, r2, lsl #2
    3300:	0015df23 	andseq	sp, r5, r3, lsr #30
    3304:	06900100 	ldreq	r0, [r0], r0, lsl #2
    3308:	00001166 	andeq	r1, r0, r6, ror #2
    330c:	0000a664 	andeq	sl, r0, r4, ror #12
    3310:	0000003c 	andeq	r0, r0, ip, lsr r0
    3314:	082b9c01 	stmdaeq	fp!, {r0, sl, fp, ip, pc}
    3318:	3a200000 	bcc	803320 <__bss_end+0x7f7228>
    331c:	01000013 	tsteq	r0, r3, lsl r0
    3320:	004d2190 	umaaleq	r2, sp, r0, r1
    3324:	91020000 	mrsls	r0, (UNDEF: 2)
    3328:	6572226c 	ldrbvs	r2, [r2, #-620]!	; 0xfffffd94
    332c:	92010071 	andls	r0, r1, #113	; 0x71
    3330:	0003de20 	andeq	sp, r3, r0, lsr #28
    3334:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    3338:	155f2100 	ldrbne	r2, [pc, #-256]	; 3240 <shift+0x3240>
    333c:	84010000 	strhi	r0, [r1], #-0
    3340:	0013ec0a 	andseq	lr, r3, sl, lsl #24
    3344:	00004d00 	andeq	r4, r0, r0, lsl #26
    3348:	00a62800 	adceq	r2, r6, r0, lsl #16
    334c:	00003c00 	andeq	r3, r0, r0, lsl #24
    3350:	689c0100 	ldmvs	ip, {r8}
    3354:	22000008 	andcs	r0, r0, #8
    3358:	00716572 	rsbseq	r6, r1, r2, ror r5
    335c:	ba208601 	blt	824b68 <__bss_end+0x818a70>
    3360:	02000003 	andeq	r0, r0, #3
    3364:	a61e7491 			; <UNDEFINED> instruction: 0xa61e7491
    3368:	01000010 	tsteq	r0, r0, lsl r0
    336c:	004d0e87 	subeq	r0, sp, r7, lsl #29
    3370:	91020000 	mrsls	r0, (UNDEF: 2)
    3374:	17210070 			; <UNDEFINED> instruction: 0x17210070
    3378:	01000019 	tsteq	r0, r9, lsl r0
    337c:	13740a78 	cmnne	r4, #120, 20	; 0x78000
    3380:	004d0000 	subeq	r0, sp, r0
    3384:	a5ec0000 	strbge	r0, [ip, #0]!
    3388:	003c0000 	eorseq	r0, ip, r0
    338c:	9c010000 	stcls	0, cr0, [r1], {-0}
    3390:	000008a5 	andeq	r0, r0, r5, lsr #17
    3394:	71657222 	cmnvc	r5, r2, lsr #4
    3398:	207a0100 	rsbscs	r0, sl, r0, lsl #2
    339c:	000003ba 			; <UNDEFINED> instruction: 0x000003ba
    33a0:	1e749102 	expnes	f1, f2
    33a4:	000010a6 	andeq	r1, r0, r6, lsr #1
    33a8:	4d0e7b01 	vstrmi	d7, [lr, #-4]
    33ac:	02000000 	andeq	r0, r0, #0
    33b0:	21007091 	swpcs	r7, r1, [r0]
    33b4:	00001421 	andeq	r1, r0, r1, lsr #8
    33b8:	76066c01 	strvc	r6, [r6], -r1, lsl #24
    33bc:	fc000016 	stc2	0, cr0, [r0], {22}
    33c0:	98000001 	stmdals	r0, {r0}
    33c4:	540000a5 	strpl	r0, [r0], #-165	; 0xffffff5b
    33c8:	01000000 	mrseq	r0, (UNDEF: 0)
    33cc:	0008f19c 	muleq	r8, ip, r1
    33d0:	15252000 	strne	r2, [r5, #-0]!
    33d4:	6c010000 	stcvs	0, cr0, [r1], {-0}
    33d8:	00004d15 	andeq	r4, r0, r5, lsl sp
    33dc:	6c910200 	lfmvs	f0, 4, [r1], {0}
    33e0:	0012ba20 	andseq	fp, r2, r0, lsr #20
    33e4:	256c0100 	strbcs	r0, [ip, #-256]!	; 0xffffff00
    33e8:	0000004d 	andeq	r0, r0, sp, asr #32
    33ec:	1e689102 	lgnnee	f1, f2
    33f0:	0000190f 	andeq	r1, r0, pc, lsl #18
    33f4:	4d0e6e01 	stcmi	14, cr6, [lr, #-4]
    33f8:	02000000 	andeq	r0, r0, #0
    33fc:	21007491 			; <UNDEFINED> instruction: 0x21007491
    3400:	0000117d 	andeq	r1, r0, sp, ror r1
    3404:	15125f01 	ldrne	r5, [r2, #-3841]	; 0xfffff0ff
    3408:	8b000017 	blhi	346c <shift+0x346c>
    340c:	48000000 	stmdami	r0, {}	; <UNPREDICTABLE>
    3410:	500000a5 	andpl	r0, r0, r5, lsr #1
    3414:	01000000 	mrseq	r0, (UNDEF: 0)
    3418:	00094c9c 	muleq	r9, ip, ip
    341c:	08e82000 	stmiaeq	r8!, {sp}^
    3420:	5f010000 	svcpl	0x00010000
    3424:	00004d20 	andeq	r4, r0, r0, lsr #26
    3428:	6c910200 	lfmvs	f0, 4, [r1], {0}
    342c:	00070120 	andeq	r0, r7, r0, lsr #2
    3430:	2f5f0100 	svccs	0x005f0100
    3434:	0000004d 	andeq	r0, r0, sp, asr #32
    3438:	20689102 	rsbcs	r9, r8, r2, lsl #2
    343c:	000012ba 			; <UNDEFINED> instruction: 0x000012ba
    3440:	4d3f5f01 	ldcmi	15, cr5, [pc, #-4]!	; 3444 <shift+0x3444>
    3444:	02000000 	andeq	r0, r0, #0
    3448:	0f1e6491 	svceq	0x001e6491
    344c:	01000019 	tsteq	r0, r9, lsl r0
    3450:	008b1661 	addeq	r1, fp, r1, ror #12
    3454:	91020000 	mrsls	r0, (UNDEF: 2)
    3458:	5e210074 	mcrpl	0, 1, r0, cr1, cr4, {3}
    345c:	01000017 	tsteq	r0, r7, lsl r0
    3460:	11880a53 	orrne	r0, r8, r3, asr sl
    3464:	004d0000 	subeq	r0, sp, r0
    3468:	a5040000 	strge	r0, [r4, #-0]
    346c:	00440000 	subeq	r0, r4, r0
    3470:	9c010000 	stcls	0, cr0, [r1], {-0}
    3474:	00000998 	muleq	r0, r8, r9
    3478:	0008e820 	andeq	lr, r8, r0, lsr #16
    347c:	1a530100 	bne	14c3884 <__bss_end+0x14b778c>
    3480:	0000004d 	andeq	r0, r0, sp, asr #32
    3484:	206c9102 	rsbcs	r9, ip, r2, lsl #2
    3488:	00000701 	andeq	r0, r0, r1, lsl #14
    348c:	4d295301 	stcmi	3, cr5, [r9, #-4]!
    3490:	02000000 	andeq	r0, r0, #0
    3494:	441e6891 	ldrmi	r6, [lr], #-2193	; 0xfffff76f
    3498:	01000017 	tsteq	r0, r7, lsl r0
    349c:	004d0e55 	subeq	r0, sp, r5, asr lr
    34a0:	91020000 	mrsls	r0, (UNDEF: 2)
    34a4:	3e210074 	mcrcc	0, 1, r0, cr1, cr4, {3}
    34a8:	01000017 	tsteq	r0, r7, lsl r0
    34ac:	17200a46 	strne	r0, [r0, -r6, asr #20]!
    34b0:	004d0000 	subeq	r0, sp, r0
    34b4:	a4b40000 	ldrtge	r0, [r4], #0
    34b8:	00500000 	subseq	r0, r0, r0
    34bc:	9c010000 	stcls	0, cr0, [r1], {-0}
    34c0:	000009f3 	strdeq	r0, [r0], -r3
    34c4:	0008e820 	andeq	lr, r8, r0, lsr #16
    34c8:	19460100 	stmdbne	r6, {r8}^
    34cc:	0000004d 	andeq	r0, r0, sp, asr #32
    34d0:	206c9102 	rsbcs	r9, ip, r2, lsl #2
    34d4:	00001473 	andeq	r1, r0, r3, ror r4
    34d8:	29304601 	ldmdbcs	r0!, {r0, r9, sl, lr}
    34dc:	02000001 	andeq	r0, r0, #1
    34e0:	75206891 	strvc	r6, [r0, #-2193]!	; 0xfffff76f
    34e4:	01000015 	tsteq	r0, r5, lsl r0
    34e8:	071e4146 	ldreq	r4, [lr, -r6, asr #2]
    34ec:	91020000 	mrsls	r0, (UNDEF: 2)
    34f0:	190f1e64 	stmdbne	pc, {r2, r5, r6, r9, sl, fp, ip}	; <UNPREDICTABLE>
    34f4:	48010000 	stmdami	r1, {}	; <UNPREDICTABLE>
    34f8:	00004d0e 	andeq	r4, r0, lr, lsl #26
    34fc:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    3500:	107b2300 	rsbsne	r2, fp, r0, lsl #6
    3504:	40010000 	andmi	r0, r1, r0
    3508:	00147d06 	andseq	r7, r4, r6, lsl #26
    350c:	00a48800 	adceq	r8, r4, r0, lsl #16
    3510:	00002c00 	andeq	r2, r0, r0, lsl #24
    3514:	1d9c0100 	ldfnes	f0, [ip]
    3518:	2000000a 	andcs	r0, r0, sl
    351c:	000008e8 	andeq	r0, r0, r8, ror #17
    3520:	4d154001 	ldcmi	0, cr4, [r5, #-4]
    3524:	02000000 	andeq	r0, r0, #0
    3528:	21007491 			; <UNDEFINED> instruction: 0x21007491
    352c:	000014e2 	andeq	r1, r0, r2, ror #9
    3530:	7b0a3301 	blvc	29013c <__bss_end+0x284044>
    3534:	4d000015 	stcmi	0, cr0, [r0, #-84]	; 0xffffffac
    3538:	38000000 	stmdacc	r0, {}	; <UNPREDICTABLE>
    353c:	500000a4 	andpl	r0, r0, r4, lsr #1
    3540:	01000000 	mrseq	r0, (UNDEF: 0)
    3544:	000a789c 	muleq	sl, ip, r8
    3548:	08e82000 	stmiaeq	r8!, {sp}^
    354c:	33010000 	movwcc	r0, #4096	; 0x1000
    3550:	00004d19 	andeq	r4, r0, r9, lsl sp
    3554:	6c910200 	lfmvs	f0, 4, [r1], {0}
    3558:	000d0920 	andeq	r0, sp, r0, lsr #18
    355c:	2b330100 	blcs	cc3964 <__bss_end+0xcb786c>
    3560:	00000203 	andeq	r0, r0, r3, lsl #4
    3564:	20689102 	rsbcs	r9, r8, r2, lsl #2
    3568:	000015b5 			; <UNDEFINED> instruction: 0x000015b5
    356c:	4d3c3301 	ldcmi	3, cr3, [ip, #-4]!
    3570:	02000000 	andeq	r0, r0, #0
    3574:	0f1e6491 	svceq	0x001e6491
    3578:	01000017 	tsteq	r0, r7, lsl r0
    357c:	004d0e35 	subeq	r0, sp, r5, lsr lr
    3580:	91020000 	mrsls	r0, (UNDEF: 2)
    3584:	3e210074 	mcrcc	0, 1, r0, cr1, cr4, {3}
    3588:	01000019 	tsteq	r0, r9, lsl r0
    358c:	17f90a25 	ldrbne	r0, [r9, r5, lsr #20]!
    3590:	004d0000 	subeq	r0, sp, r0
    3594:	a3e80000 	mvnge	r0, #0
    3598:	00500000 	subseq	r0, r0, r0
    359c:	9c010000 	stcls	0, cr0, [r1], {-0}
    35a0:	00000ad3 	ldrdeq	r0, [r0], -r3
    35a4:	0008e820 	andeq	lr, r8, r0, lsr #16
    35a8:	18250100 	stmdane	r5!, {r8}
    35ac:	0000004d 	andeq	r0, r0, sp, asr #32
    35b0:	206c9102 	rsbcs	r9, ip, r2, lsl #2
    35b4:	00000d09 	andeq	r0, r0, r9, lsl #26
    35b8:	d92a2501 	stmdble	sl!, {r0, r8, sl, sp}
    35bc:	0200000a 	andeq	r0, r0, #10
    35c0:	b5206891 	strlt	r6, [r0, #-2193]!	; 0xfffff76f
    35c4:	01000015 	tsteq	r0, r5, lsl r0
    35c8:	004d3b25 	subeq	r3, sp, r5, lsr #22
    35cc:	91020000 	mrsls	r0, (UNDEF: 2)
    35d0:	0f4a1e64 	svceq	0x004a1e64
    35d4:	27010000 	strcs	r0, [r1, -r0]
    35d8:	00004d0e 	andeq	r4, r0, lr, lsl #26
    35dc:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    35e0:	25040d00 	strcs	r0, [r4, #-3328]	; 0xfffff300
    35e4:	03000000 	movweq	r0, #0
    35e8:	00000ad3 	ldrdeq	r0, [r0], -r3
    35ec:	00153921 	andseq	r3, r5, r1, lsr #18
    35f0:	0a190100 	beq	6439f8 <__bss_end+0x637900>
    35f4:	0000195b 	andeq	r1, r0, fp, asr r9
    35f8:	0000004d 	andeq	r0, r0, sp, asr #32
    35fc:	0000a3a4 	andeq	sl, r0, r4, lsr #7
    3600:	00000044 	andeq	r0, r0, r4, asr #32
    3604:	0b2a9c01 	bleq	aaa610 <__bss_end+0xa9e518>
    3608:	30200000 	eorcc	r0, r0, r0
    360c:	01000019 	tsteq	r0, r9, lsl r0
    3610:	02031b19 	andeq	r1, r3, #25600	; 0x6400
    3614:	91020000 	mrsls	r0, (UNDEF: 2)
    3618:	176f206c 	strbne	r2, [pc, -ip, rrx]!
    361c:	19010000 	stmdbne	r1, {}	; <UNPREDICTABLE>
    3620:	0001d235 	andeq	sp, r1, r5, lsr r2
    3624:	68910200 	ldmvs	r1, {r9}
    3628:	0008e81e 	andeq	lr, r8, lr, lsl r8
    362c:	0e1b0100 	mufeqe	f0, f3, f0
    3630:	0000004d 	andeq	r0, r0, sp, asr #32
    3634:	00749102 	rsbseq	r9, r4, r2, lsl #2
    3638:	00132e24 	andseq	r2, r3, r4, lsr #28
    363c:	06140100 	ldreq	r0, [r4], -r0, lsl #2
    3640:	00001117 	andeq	r1, r0, r7, lsl r1
    3644:	0000a388 	andeq	sl, r0, r8, lsl #7
    3648:	0000001c 	andeq	r0, r0, ip, lsl r0
    364c:	65239c01 	strvs	r9, [r3, #-3073]!	; 0xfffff3ff
    3650:	01000017 	tsteq	r0, r7, lsl r0
    3654:	1451060e 	ldrbne	r0, [r1], #-1550	; 0xfffff9f2
    3658:	a35c0000 	cmpge	ip, #0
    365c:	002c0000 	eoreq	r0, ip, r0
    3660:	9c010000 	stcls	0, cr0, [r1], {-0}
    3664:	00000b6a 	andeq	r0, r0, sl, ror #22
    3668:	00127b20 	andseq	r7, r2, r0, lsr #22
    366c:	140e0100 	strne	r0, [lr], #-256	; 0xffffff00
    3670:	00000038 	andeq	r0, r0, r8, lsr r0
    3674:	00749102 	rsbseq	r9, r4, r2, lsl #2
    3678:	00195425 	andseq	r5, r9, r5, lsr #8
    367c:	0a040100 	beq	103a84 <__bss_end+0xf798c>
    3680:	000014ae 	andeq	r1, r0, lr, lsr #9
    3684:	0000004d 	andeq	r0, r0, sp, asr #32
    3688:	0000a330 	andeq	sl, r0, r0, lsr r3
    368c:	0000002c 	andeq	r0, r0, ip, lsr #32
    3690:	70229c01 	eorvc	r9, r2, r1, lsl #24
    3694:	01006469 	tsteq	r0, r9, ror #8
    3698:	004d0e06 	subeq	r0, sp, r6, lsl #28
    369c:	91020000 	mrsls	r0, (UNDEF: 2)
    36a0:	2d000074 	stccs	0, cr0, [r0, #-464]	; 0xfffffe30
    36a4:	04000006 	streq	r0, [r0], #-6
    36a8:	0010a400 	andseq	sl, r0, r0, lsl #8
    36ac:	99010400 	stmdbls	r1, {sl}
    36b0:	0400000e 	streq	r0, [r0], #-14
    36b4:	00001a46 	andeq	r1, r0, r6, asr #20
    36b8:	00000e36 	andeq	r0, r0, r6, lsr lr
    36bc:	0000a790 	muleq	r0, r0, r7
    36c0:	00000c2c 	andeq	r0, r0, ip, lsr #24
    36c4:	00001796 	muleq	r0, r6, r7
    36c8:	00004902 	andeq	r4, r0, r2, lsl #18
    36cc:	1aa30300 	bne	fe8c42d4 <__bss_end+0xfe8b81dc>
    36d0:	05010000 	streq	r0, [r1, #-0]
    36d4:	00006110 	andeq	r6, r0, r0, lsl r1
    36d8:	31301100 	teqcc	r0, r0, lsl #2
    36dc:	35343332 	ldrcc	r3, [r4, #-818]!	; 0xfffffcce
    36e0:	39383736 	ldmdbcc	r8!, {r1, r2, r4, r5, r8, r9, sl, ip, sp}
    36e4:	44434241 	strbmi	r4, [r3], #-577	; 0xfffffdbf
    36e8:	00004645 	andeq	r4, r0, r5, asr #12
    36ec:	01030104 	tsteq	r3, r4, lsl #2
    36f0:	00000025 	andeq	r0, r0, r5, lsr #32
    36f4:	00007405 	andeq	r7, r0, r5, lsl #8
    36f8:	00006100 	andeq	r6, r0, r0, lsl #2
    36fc:	00660600 	rsbeq	r0, r6, r0, lsl #12
    3700:	00100000 	andseq	r0, r0, r0
    3704:	00005107 	andeq	r5, r0, r7, lsl #2
    3708:	07040800 	streq	r0, [r4, -r0, lsl #16]
    370c:	00001f98 	muleq	r0, r8, pc	; <UNPREDICTABLE>
    3710:	60080108 	andvs	r0, r8, r8, lsl #2
    3714:	07000008 	streq	r0, [r0, -r8]
    3718:	0000006d 	andeq	r0, r0, sp, rrx
    371c:	00002a09 	andeq	r2, r0, r9, lsl #20
    3720:	1aaf0a00 	bne	febc5f28 <__bss_end+0xfebb9e30>
    3724:	d0010000 	andle	r0, r1, r0
    3728:	001b4406 	andseq	r4, fp, r6, lsl #8
    372c:	00b09400 	adcseq	r9, r0, r0, lsl #8
    3730:	00032800 	andeq	r2, r3, r0, lsl #16
    3734:	1f9c0100 	svcne	0x009c0100
    3738:	0b000001 	bleq	3744 <shift+0x3744>
    373c:	d0010066 	andle	r0, r1, r6, rrx
    3740:	00011f11 	andeq	r1, r1, r1, lsl pc
    3744:	a4910300 	ldrge	r0, [r1], #768	; 0x300
    3748:	00720b7f 	rsbseq	r0, r2, pc, ror fp
    374c:	2619d001 	ldrcs	sp, [r9], -r1
    3750:	03000001 	movweq	r0, #1
    3754:	0c7fa091 	ldcleq	0, cr10, [pc], #-580	; 3518 <shift+0x3518>
    3758:	00001b56 	andeq	r1, r0, r6, asr fp
    375c:	2c13d201 	lfmcs	f5, 1, [r3], {1}
    3760:	02000001 	andeq	r0, r0, #1
    3764:	010c5891 			; <UNDEFINED> instruction: 0x010c5891
    3768:	0100001b 	tsteq	r0, fp, lsl r0
    376c:	012c1bd2 	ldrdeq	r1, [ip, -r2]!
    3770:	91020000 	mrsls	r0, (UNDEF: 2)
    3774:	00690d50 	rsbeq	r0, r9, r0, asr sp
    3778:	2c24d201 	sfmcs	f5, 1, [r4], #-4
    377c:	02000001 	andeq	r0, r0, #1
    3780:	b40c4891 	strlt	r4, [ip], #-2193	; 0xfffff76f
    3784:	0100001a 	tsteq	r0, sl, lsl r0
    3788:	012c27d2 	ldrdeq	r2, [ip, -r2]!	; <UNPREDICTABLE>
    378c:	91020000 	mrsls	r0, (UNDEF: 2)
    3790:	1a930c40 	bne	fe4c6898 <__bss_end+0xfe4ba7a0>
    3794:	d2010000 	andle	r0, r1, #0
    3798:	00012c2f 	andeq	r2, r1, pc, lsr #24
    379c:	b8910300 	ldmlt	r1, {r8, r9}
    37a0:	1a170c7f 	bne	5c69a4 <__bss_end+0x5ba8ac>
    37a4:	d2010000 	andle	r0, r1, #0
    37a8:	00012c39 	andeq	r2, r1, r9, lsr ip
    37ac:	b0910300 	addslt	r0, r1, r0, lsl #6
    37b0:	1ac20c7f 	bne	ff0869b4 <__bss_end+0xff07a8bc>
    37b4:	d3010000 	movwle	r0, #4096	; 0x1000
    37b8:	00011f0b 	andeq	r1, r1, fp, lsl #30
    37bc:	ac910300 	ldcge	3, cr0, [r1], {0}
    37c0:	0408007f 	streq	r0, [r8], #-127	; 0xffffff81
    37c4:	001c9f04 	andseq	r9, ip, r4, lsl #30
    37c8:	6d040e00 	stcvs	14, cr0, [r4, #-0]
    37cc:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    37d0:	02430508 	subeq	r0, r3, #8, 10	; 0x2000000
    37d4:	090f0000 	stmdbeq	pc, {}	; <UNPREDICTABLE>
    37d8:	0100001b 	tsteq	r0, fp, lsl r0
    37dc:	19de05c6 	ldmibne	lr, {r1, r2, r6, r7, r8, sl}^
    37e0:	017f0000 	cmneq	pc, r0
    37e4:	b02c0000 	eorlt	r0, ip, r0
    37e8:	00680000 	rsbeq	r0, r8, r0
    37ec:	9c010000 	stcls	0, cr0, [r1], {-0}
    37f0:	0000017f 	andeq	r0, r0, pc, ror r1
    37f4:	001ab410 	andseq	fp, sl, r0, lsl r4
    37f8:	0ec60100 	poleqs	f0, f6, f0
    37fc:	0000017f 	andeq	r0, r0, pc, ror r1
    3800:	106c9102 	rsbne	r9, ip, r2, lsl #2
    3804:	00000701 	andeq	r0, r0, r1, lsl #14
    3808:	7f1ac601 	svcvc	0x001ac601
    380c:	02000001 	andeq	r0, r0, #1
    3810:	250c6891 	strcs	r6, [ip, #-2193]	; 0xfffff76f
    3814:	01000001 	tsteq	r0, r1
    3818:	017f09c8 	cmneq	pc, r8, asr #19
    381c:	91020000 	mrsls	r0, (UNDEF: 2)
    3820:	04110074 	ldreq	r0, [r1], #-116	; 0xffffff8c
    3824:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
    3828:	1ade1200 	bne	ff788030 <__bss_end+0xff77bf38>
    382c:	bb010000 	bllt	43834 <__bss_end+0x3773c>
    3830:	0019b806 	andseq	fp, r9, r6, lsl #16
    3834:	00afac00 	adceq	sl, pc, r0, lsl #24
    3838:	00008000 	andeq	r8, r0, r0
    383c:	039c0100 	orrseq	r0, ip, #0, 2
    3840:	0b000002 	bleq	3850 <shift+0x3850>
    3844:	00637273 	rsbeq	r7, r3, r3, ror r2
    3848:	0319bb01 	tsteq	r9, #1024	; 0x400
    384c:	02000002 	andeq	r0, r0, #2
    3850:	640b6491 	strvs	r6, [fp], #-1169	; 0xfffffb6f
    3854:	01007473 	tsteq	r0, r3, ror r4
    3858:	020a24bb 	andeq	r2, sl, #-1157627904	; 0xbb000000
    385c:	91020000 	mrsls	r0, (UNDEF: 2)
    3860:	756e0b60 	strbvc	r0, [lr, #-2912]!	; 0xfffff4a0
    3864:	bb01006d 	bllt	43a20 <__bss_end+0x37928>
    3868:	00017f2d 	andeq	r7, r1, sp, lsr #30
    386c:	5c910200 	lfmpl	f0, 4, [r1], {0}
    3870:	001abb0c 	andseq	fp, sl, ip, lsl #22
    3874:	0ebd0100 	frdeqe	f0, f5, f0
    3878:	0000020c 	andeq	r0, r0, ip, lsl #4
    387c:	0c709102 	ldfeqp	f1, [r0], #-8
    3880:	00001a9c 	muleq	r0, ip, sl
    3884:	2608be01 	strcs	fp, [r8], -r1, lsl #28
    3888:	02000001 	andeq	r0, r0, #1
    388c:	d4136c91 	ldrle	r6, [r3], #-3217	; 0xfffff36f
    3890:	480000af 	stmdami	r0, {r0, r1, r2, r3, r5, r7}
    3894:	0d000000 	stceq	0, cr0, [r0, #-0]
    3898:	c0010069 	andgt	r0, r1, r9, rrx
    389c:	00017f0b 	andeq	r7, r1, fp, lsl #30
    38a0:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    38a4:	040e0000 	streq	r0, [lr], #-0
    38a8:	00000209 	andeq	r0, r0, r9, lsl #4
    38ac:	0e041514 	mcreq	5, 0, r1, cr4, cr4, {0}
    38b0:	00007404 	andeq	r7, r0, r4, lsl #8
    38b4:	1ad81200 	bne	ff6080bc <__bss_end+0xff5fbfc4>
    38b8:	b3010000 	movwlt	r0, #4096	; 0x1000
    38bc:	001a2306 	andseq	r2, sl, r6, lsl #6
    38c0:	00af4400 	adceq	r4, pc, r0, lsl #8
    38c4:	00006800 	andeq	r6, r0, r0, lsl #16
    38c8:	719c0100 	orrsvc	r0, ip, r0, lsl #2
    38cc:	10000002 	andne	r0, r0, r2
    38d0:	00001b4f 	andeq	r1, r0, pc, asr #22
    38d4:	0a12b301 	beq	4b04e0 <__bss_end+0x4a43e8>
    38d8:	02000002 	andeq	r0, r0, #2
    38dc:	56106c91 			; <UNDEFINED> instruction: 0x56106c91
    38e0:	0100001b 	tsteq	r0, fp, lsl r0
    38e4:	017f1eb3 	ldrheq	r1, [pc, #-227]	; 3809 <shift+0x3809>
    38e8:	91020000 	mrsls	r0, (UNDEF: 2)
    38ec:	656d0d68 	strbvs	r0, [sp, #-3432]!	; 0xfffff298
    38f0:	b501006d 	strlt	r0, [r1, #-109]	; 0xffffff93
    38f4:	00012608 	andeq	r2, r1, r8, lsl #12
    38f8:	70910200 	addsvc	r0, r1, r0, lsl #4
    38fc:	00af6013 	adceq	r6, pc, r3, lsl r0	; <UNPREDICTABLE>
    3900:	00003c00 	andeq	r3, r0, r0, lsl #24
    3904:	00690d00 	rsbeq	r0, r9, r0, lsl #26
    3908:	7f0bb701 	svcvc	0x000bb701
    390c:	02000001 	andeq	r0, r0, #1
    3910:	00007491 	muleq	r0, r1, r4
    3914:	001a7816 	andseq	r7, sl, r6, lsl r8
    3918:	07a20100 	streq	r0, [r2, r0, lsl #2]!
    391c:	00001b64 	andeq	r1, r0, r4, ror #22
    3920:	00000126 	andeq	r0, r0, r6, lsr #2
    3924:	0000ae6c 	andeq	sl, r0, ip, ror #28
    3928:	000000d8 	ldrdeq	r0, [r0], -r8
    392c:	02f09c01 	rscseq	r9, r0, #256	; 0x100
    3930:	0c100000 	ldceq	0, cr0, [r0], {-0}
    3934:	0100001a 	tsteq	r0, sl, lsl r0
    3938:	012615a2 			; <UNDEFINED> instruction: 0x012615a2
    393c:	91020000 	mrsls	r0, (UNDEF: 2)
    3940:	72730b64 	rsbsvc	r0, r3, #100, 22	; 0x19000
    3944:	a2010063 	andge	r0, r1, #99	; 0x63
    3948:	00020c27 	andeq	r0, r2, r7, lsr #24
    394c:	60910200 	addsvs	r0, r1, r0, lsl #4
    3950:	0015b510 	andseq	fp, r5, r0, lsl r5
    3954:	2fa20100 	svccs	0x00a20100
    3958:	0000017f 	andeq	r0, r0, pc, ror r1
    395c:	0c5c9102 	ldfeqp	f1, [ip], {2}
    3960:	00001a80 	andeq	r1, r0, r0, lsl #21
    3964:	7f09a301 	svcvc	0x0009a301
    3968:	02000001 	andeq	r0, r0, #1
    396c:	6d0d6c91 	stcvs	12, cr6, [sp, #-580]	; 0xfffffdbc
    3970:	09a50100 	stmibeq	r5!, {r8}
    3974:	0000017f 	andeq	r0, r0, pc, ror r1
    3978:	13749102 	cmnne	r4, #-2147483648	; 0x80000000
    397c:	0000aeb0 			; <UNDEFINED> instruction: 0x0000aeb0
    3980:	00000070 	andeq	r0, r0, r0, ror r0
    3984:	0100690d 	tsteq	r0, sp, lsl #18
    3988:	017f0da9 	cmneq	pc, r9, lsr #27
    398c:	91020000 	mrsls	r0, (UNDEF: 2)
    3990:	16000070 			; <UNDEFINED> instruction: 0x16000070
    3994:	00001a1c 	andeq	r1, r0, ip, lsl sl
    3998:	37079801 	strcc	r9, [r7, -r1, lsl #16]
    399c:	2600001a 			; <UNDEFINED> instruction: 0x2600001a
    39a0:	c0000001 	andgt	r0, r0, r1
    39a4:	ac0000ad 	stcge	0, cr0, [r0], {173}	; 0xad
    39a8:	01000000 	mrseq	r0, (UNDEF: 0)
    39ac:	00036d9c 	muleq	r3, ip, sp
    39b0:	1a0c1000 	bne	3079b8 <__bss_end+0x2fb8c0>
    39b4:	98010000 	stmdals	r1, {}	; <UNPREDICTABLE>
    39b8:	00012614 	andeq	r2, r1, r4, lsl r6
    39bc:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    39c0:	6372730b 	cmnvs	r2, #738197504	; 0x2c000000
    39c4:	26980100 	ldrcs	r0, [r8], r0, lsl #2
    39c8:	0000020c 	andeq	r0, r0, ip, lsl #4
    39cc:	0d609102 	stfeqp	f1, [r0, #-8]!
    39d0:	9901006e 	stmdbls	r1, {r1, r2, r3, r5, r6}
    39d4:	00017f09 	andeq	r7, r1, r9, lsl #30
    39d8:	6c910200 	lfmvs	f0, 4, [r1], {0}
    39dc:	01006d0d 	tsteq	r0, sp, lsl #26
    39e0:	017f099a 			; <UNDEFINED> instruction: 0x017f099a
    39e4:	91020000 	mrsls	r0, (UNDEF: 2)
    39e8:	1a800c74 	bne	fe006bc0 <__bss_end+0xfdffaac8>
    39ec:	9b010000 	blls	439f4 <__bss_end+0x378fc>
    39f0:	00017f09 	andeq	r7, r1, r9, lsl #30
    39f4:	68910200 	ldmvs	r1, {r9}
    39f8:	00adf413 	adceq	pc, sp, r3, lsl r4	; <UNPREDICTABLE>
    39fc:	00005400 	andeq	r5, r0, r0, lsl #8
    3a00:	00690d00 	rsbeq	r0, r9, r0, lsl #26
    3a04:	7f0d9c01 	svcvc	0x000d9c01
    3a08:	02000001 	andeq	r0, r0, #1
    3a0c:	00007091 	muleq	r0, r1, r0
    3a10:	001b5d0f 	andseq	r5, fp, pc, lsl #26
    3a14:	058d0100 	streq	r0, [sp, #256]	; 0x100
    3a18:	00001b0e 	andeq	r1, r0, lr, lsl #22
    3a1c:	0000017f 	andeq	r0, r0, pc, ror r1
    3a20:	0000ad6c 	andeq	sl, r0, ip, ror #26
    3a24:	00000054 	andeq	r0, r0, r4, asr r0
    3a28:	03a69c01 			; <UNDEFINED> instruction: 0x03a69c01
    3a2c:	730b0000 	movwvc	r0, #45056	; 0xb000
    3a30:	188d0100 	stmne	sp, {r8}
    3a34:	0000020c 	andeq	r0, r0, ip, lsl #4
    3a38:	0d6c9102 	stfeqp	f1, [ip, #-8]!
    3a3c:	8f010069 	svchi	0x00010069
    3a40:	00017f06 	andeq	r7, r1, r6, lsl #30
    3a44:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    3a48:	1ae50f00 	bne	ff947650 <__bss_end+0xff93b558>
    3a4c:	7d010000 	stcvc	0, cr0, [r1, #-0]
    3a50:	001b1b05 	andseq	r1, fp, r5, lsl #22
    3a54:	00017f00 	andeq	r7, r1, r0, lsl #30
    3a58:	00acc000 	adceq	ip, ip, r0
    3a5c:	0000ac00 	andeq	sl, r0, r0, lsl #24
    3a60:	0c9c0100 	ldfeqs	f0, [ip], {0}
    3a64:	0b000004 	bleq	3a7c <shift+0x3a7c>
    3a68:	01003173 	tsteq	r0, r3, ror r1
    3a6c:	020c197d 	andeq	r1, ip, #2048000	; 0x1f4000
    3a70:	91020000 	mrsls	r0, (UNDEF: 2)
    3a74:	32730b6c 	rsbscc	r0, r3, #108, 22	; 0x1b000
    3a78:	297d0100 	ldmdbcs	sp!, {r8}^
    3a7c:	0000020c 	andeq	r0, r0, ip, lsl #4
    3a80:	0b689102 	bleq	1a27e90 <__bss_end+0x1a1bd98>
    3a84:	006d756e 	rsbeq	r7, sp, lr, ror #10
    3a88:	7f317d01 	svcvc	0x00317d01
    3a8c:	02000001 	andeq	r0, r0, #1
    3a90:	750d6491 	strvc	r6, [sp, #-1169]	; 0xfffffb6f
    3a94:	7f010031 	svcvc	0x00010031
    3a98:	00040c10 	andeq	r0, r4, r0, lsl ip
    3a9c:	77910200 	ldrvc	r0, [r1, r0, lsl #4]
    3aa0:	0032750d 	eorseq	r7, r2, sp, lsl #10
    3aa4:	0c147f01 	ldceq	15, cr7, [r4], {1}
    3aa8:	02000004 	andeq	r0, r0, #4
    3aac:	08007691 	stmdaeq	r0, {r0, r4, r7, r9, sl, ip, sp, lr}
    3ab0:	08570801 	ldmdaeq	r7, {r0, fp}^
    3ab4:	2f0f0000 	svccs	0x000f0000
    3ab8:	0100001a 	tsteq	r0, sl, lsl r0
    3abc:	19a70771 	stmibne	r7!, {r0, r4, r5, r6, r8, r9, sl}
    3ac0:	01260000 			; <UNDEFINED> instruction: 0x01260000
    3ac4:	ac000000 	stcge	0, cr0, [r0], {-0}
    3ac8:	00c00000 	sbceq	r0, r0, r0
    3acc:	9c010000 	stcls	0, cr0, [r1], {-0}
    3ad0:	0000046c 	andeq	r0, r0, ip, ror #8
    3ad4:	001a0c10 	andseq	r0, sl, r0, lsl ip
    3ad8:	15710100 	ldrbne	r0, [r1, #-256]!	; 0xffffff00
    3adc:	00000126 	andeq	r0, r0, r6, lsr #2
    3ae0:	0b6c9102 	bleq	1b27ef0 <__bss_end+0x1b1bdf8>
    3ae4:	00637273 	rsbeq	r7, r3, r3, ror r2
    3ae8:	0c277101 	stfeqs	f7, [r7], #-4
    3aec:	02000002 	andeq	r0, r0, #2
    3af0:	6e0b6891 	mcrvs	8, 0, r6, cr11, cr1, {4}
    3af4:	01006d75 	tsteq	r0, r5, ror sp
    3af8:	017f3071 	cmneq	pc, r1, ror r0	; <UNPREDICTABLE>
    3afc:	91020000 	mrsls	r0, (UNDEF: 2)
    3b00:	00690d64 	rsbeq	r0, r9, r4, ror #26
    3b04:	7f067301 	svcvc	0x00067301
    3b08:	02000001 	andeq	r0, r0, #1
    3b0c:	0f007491 	svceq	0x00007491
    3b10:	000019e8 	andeq	r1, r0, r8, ror #19
    3b14:	01075501 	tsteq	r7, r1, lsl #10
    3b18:	1f00001a 	svcne	0x0000001a
    3b1c:	a4000001 	strge	r0, [r0], #-1
    3b20:	5c0000aa 	stcpl	0, cr0, [r0], {170}	; 0xaa
    3b24:	01000001 	tsteq	r0, r1
    3b28:	00050d9c 	muleq	r5, ip, sp
    3b2c:	1a111000 	bne	447b34 <__bss_end+0x43ba3c>
    3b30:	55010000 	strpl	r0, [r1, #-0]
    3b34:	00020c18 	andeq	r0, r2, r8, lsl ip
    3b38:	44910200 	ldrmi	r0, [r1], #512	; 0x200
    3b3c:	001afa0c 	andseq	pc, sl, ip, lsl #20
    3b40:	0c560100 	ldfeqe	f0, [r6], {-0}
    3b44:	0000050d 	andeq	r0, r0, sp, lsl #10
    3b48:	0c709102 	ldfeqp	f1, [r0], #-8
    3b4c:	00001a87 	andeq	r1, r0, r7, lsl #21
    3b50:	0d0c5701 	stceq	7, cr5, [ip, #-4]
    3b54:	02000005 	andeq	r0, r0, #5
    3b58:	740d6091 	strvc	r6, [sp], #-145	; 0xffffff6f
    3b5c:	0100706d 	tsteq	r0, sp, rrx
    3b60:	050d0c59 	streq	r0, [sp, #-3161]	; 0xfffff3a7
    3b64:	91020000 	mrsls	r0, (UNDEF: 2)
    3b68:	14da0c58 	ldrbne	r0, [sl], #3160	; 0xc58
    3b6c:	5a010000 	bpl	43b74 <__bss_end+0x37a7c>
    3b70:	00017f09 	andeq	r7, r1, r9, lsl #30
    3b74:	54910200 	ldrpl	r0, [r1], #512	; 0x200
    3b78:	001f880c 	andseq	r8, pc, ip, lsl #16
    3b7c:	095b0100 	ldmdbeq	fp, {r8}^
    3b80:	0000017f 	andeq	r0, r0, pc, ror r1
    3b84:	0c6c9102 	stfeqp	f1, [ip], #-8
    3b88:	00001aca 	andeq	r1, r0, sl, asr #21
    3b8c:	140a5c01 	strne	r5, [sl], #-3073	; 0xfffff3ff
    3b90:	02000005 	andeq	r0, r0, #5
    3b94:	00136b91 	mulseq	r3, r1, fp
    3b98:	d00000ab 	andle	r0, r0, fp, lsr #1
    3b9c:	0d000000 	stceq	0, cr0, [r0, #-0]
    3ba0:	006c6176 	rsbeq	r6, ip, r6, ror r1
    3ba4:	0d106501 	cfldr32eq	mvfx6, [r0, #-4]
    3ba8:	02000005 	andeq	r0, r0, #5
    3bac:	00004891 	muleq	r0, r1, r8
    3bb0:	48040808 	stmdami	r4, {r3, fp}
    3bb4:	0800001f 	stmdaeq	r0, {r0, r1, r2, r3, r4}
    3bb8:	06b60201 	ldrteq	r0, [r6], r1, lsl #4
    3bbc:	ed0f0000 	stc	0, cr0, [pc, #-0]	; 3bc4 <shift+0x3bc4>
    3bc0:	01000019 	tsteq	r0, r9, lsl r0
    3bc4:	19c8053a 	stmibne	r8, {r1, r3, r4, r5, r8, sl}^
    3bc8:	017f0000 	cmneq	pc, r0
    3bcc:	a9a40000 	stmibge	r4!, {}	; <UNPREDICTABLE>
    3bd0:	01000000 	mrseq	r0, (UNDEF: 0)
    3bd4:	9c010000 	stcls	0, cr0, [r1], {-0}
    3bd8:	0000057e 	andeq	r0, r0, lr, ror r5
    3bdc:	001a1110 	andseq	r1, sl, r0, lsl r1
    3be0:	213a0100 	teqcs	sl, r0, lsl #2
    3be4:	0000020c 	andeq	r0, r0, ip, lsl #4
    3be8:	0d6c9102 	stfeqp	f1, [ip, #-8]!
    3bec:	00746f64 	rsbseq	r6, r4, r4, ror #30
    3bf0:	140a3c01 	strne	r3, [sl], #-3073	; 0xfffff3ff
    3bf4:	02000005 	andeq	r0, r0, #5
    3bf8:	ed0c7791 	stc	7, cr7, [ip, #-580]	; 0xfffffdbc
    3bfc:	0100001a 	tsteq	r0, sl, lsl r0
    3c00:	05140a3d 	ldreq	r0, [r4, #-2621]	; 0xfffff5c3
    3c04:	91020000 	mrsls	r0, (UNDEF: 2)
    3c08:	a9d41376 	ldmibge	r4, {r1, r2, r4, r5, r6, r8, r9, ip}^
    3c0c:	008c0000 	addeq	r0, ip, r0
    3c10:	630d0000 	movwvs	r0, #53248	; 0xd000
    3c14:	0e3f0100 	rsfeqe	f0, f7, f0
    3c18:	0000006d 	andeq	r0, r0, sp, rrx
    3c1c:	00759102 	rsbseq	r9, r5, r2, lsl #2
    3c20:	19fc0f00 	ldmibne	ip!, {r8, r9, sl, fp}^
    3c24:	26010000 	strcs	r0, [r1], -r0
    3c28:	001b2d05 	andseq	r2, fp, r5, lsl #26
    3c2c:	00017f00 	andeq	r7, r1, r0, lsl #30
    3c30:	00a90800 	adceq	r0, r9, r0, lsl #16
    3c34:	00009c00 	andeq	r9, r0, r0, lsl #24
    3c38:	bb9c0100 	bllt	fe704040 <__bss_end+0xfe6f7f48>
    3c3c:	10000005 	andne	r0, r0, r5
    3c40:	00001a11 	andeq	r1, r0, r1, lsl sl
    3c44:	0c162601 	ldceq	6, cr2, [r6], {1}
    3c48:	02000002 	andeq	r0, r0, #2
    3c4c:	fa0c6c91 	blx	31ee98 <__bss_end+0x312da0>
    3c50:	0100001a 	tsteq	r0, sl, lsl r0
    3c54:	017f0628 	cmneq	pc, r8, lsr #12
    3c58:	91020000 	mrsls	r0, (UNDEF: 2)
    3c5c:	8e170074 	mrchi	0, 0, r0, cr7, cr4, {3}
    3c60:	0100001a 	tsteq	r0, sl, lsl r0
    3c64:	1b380608 	blne	e0548c <__bss_end+0xdf9394>
    3c68:	a7900000 	ldrge	r0, [r0, r0]
    3c6c:	01780000 	cmneq	r8, r0
    3c70:	9c010000 	stcls	0, cr0, [r1], {-0}
    3c74:	001a1110 	andseq	r1, sl, r0, lsl r1
    3c78:	0f080100 	svceq	0x00080100
    3c7c:	0000017f 	andeq	r0, r0, pc, ror r1
    3c80:	10649102 	rsbne	r9, r4, r2, lsl #2
    3c84:	00001afa 	strdeq	r1, [r0], -sl
    3c88:	261c0801 	ldrcs	r0, [ip], -r1, lsl #16
    3c8c:	02000001 	andeq	r0, r0, #1
    3c90:	92106091 	andsls	r6, r0, #145	; 0x91
    3c94:	0100001c 	tsteq	r0, ip, lsl r0
    3c98:	00663108 	rsbeq	r3, r6, r8, lsl #2
    3c9c:	91020000 	mrsls	r0, (UNDEF: 2)
    3ca0:	00690d5c 	rsbeq	r0, r9, ip, asr sp
    3ca4:	7f090a01 	svcvc	0x00090a01
    3ca8:	02000001 	andeq	r0, r0, #1
    3cac:	6a0d7491 	bvs	360ef8 <__bss_end+0x354e00>
    3cb0:	090b0100 	stmdbeq	fp, {r8}
    3cb4:	0000017f 	andeq	r0, r0, pc, ror r1
    3cb8:	13709102 	cmnne	r0, #-2147483648	; 0x80000000
    3cbc:	0000a888 	andeq	sl, r0, r8, lsl #17
    3cc0:	00000060 	andeq	r0, r0, r0, rrx
    3cc4:	0100630d 	tsteq	r0, sp, lsl #6
    3cc8:	006d081f 	rsbeq	r0, sp, pc, lsl r8
    3ccc:	91020000 	mrsls	r0, (UNDEF: 2)
    3cd0:	0000006f 	andeq	r0, r0, pc, rrx
    3cd4:	00000022 	andeq	r0, r0, r2, lsr #32
    3cd8:	12050002 	andne	r0, r5, #2
    3cdc:	01040000 	mrseq	r0, (UNDEF: 4)
    3ce0:	00001c98 	muleq	r0, r8, ip
    3ce4:	0000b3bc 			; <UNDEFINED> instruction: 0x0000b3bc
    3ce8:	0000b5c8 	andeq	fp, r0, r8, asr #11
    3cec:	00001b75 	andeq	r1, r0, r5, ror fp
    3cf0:	00001ba5 	andeq	r1, r0, r5, lsr #23
    3cf4:	00001c0d 	andeq	r1, r0, sp, lsl #24
    3cf8:	00228001 	eoreq	r8, r2, r1
    3cfc:	00020000 	andeq	r0, r2, r0
    3d00:	00001219 	andeq	r1, r0, r9, lsl r2
    3d04:	1d150104 	ldfnes	f0, [r5, #-16]
    3d08:	b5c80000 	strblt	r0, [r8]
    3d0c:	b8080000 	stmdalt	r8, {}	; <UNPREDICTABLE>
    3d10:	1b750000 	blne	1d43d18 <__bss_end+0x1d37c20>
    3d14:	1ba50000 	blne	fe943d1c <__bss_end+0xfe937c24>
    3d18:	1c0d0000 	stcne	0, cr0, [sp], {-0}
    3d1c:	80010000 	andhi	r0, r1, r0
    3d20:	00000022 	andeq	r0, r0, r2, lsr #32
    3d24:	122d0002 	eorne	r0, sp, #2
    3d28:	01040000 	mrseq	r0, (UNDEF: 4)
    3d2c:	00001d9e 	muleq	r0, lr, sp
    3d30:	0000b808 	andeq	fp, r0, r8, lsl #16
    3d34:	0000b80c 	andeq	fp, r0, ip, lsl #16
    3d38:	00001b75 	andeq	r1, r0, r5, ror fp
    3d3c:	00001ba5 	andeq	r1, r0, r5, lsr #23
    3d40:	00001c0d 	andeq	r1, r0, sp, lsl #24
    3d44:	00228001 	eoreq	r8, r2, r1
    3d48:	00020000 	andeq	r0, r2, r0
    3d4c:	00001241 	andeq	r1, r0, r1, asr #4
    3d50:	1dfe0104 	ldfnee	f0, [lr, #16]!
    3d54:	b80c0000 	stmdalt	ip, {}	; <UNPREDICTABLE>
    3d58:	ba5c0000 	blt	1703d60 <__bss_end+0x16f7c68>
    3d5c:	1c190000 	ldcne	0, cr0, [r9], {-0}
    3d60:	1ba50000 	blne	fe943d68 <__bss_end+0xfe937c70>
    3d64:	1c0d0000 	stcne	0, cr0, [sp], {-0}
    3d68:	80010000 	andhi	r0, r1, r0
    3d6c:	00000022 	andeq	r0, r0, r2, lsr #32
    3d70:	12550002 	subsne	r0, r5, #2
    3d74:	01040000 	mrseq	r0, (UNDEF: 4)
    3d78:	00001efd 	strdeq	r1, [r0], -sp
    3d7c:	0000ba5c 	andeq	fp, r0, ip, asr sl
    3d80:	0000bb30 	andeq	fp, r0, r0, lsr fp
    3d84:	00001c4a 	andeq	r1, r0, sl, asr #24
    3d88:	00001ba5 	andeq	r1, r0, r5, lsr #23
    3d8c:	00001c0d 	andeq	r1, r0, sp, lsl #24
    3d90:	032a8001 			; <UNDEFINED> instruction: 0x032a8001
    3d94:	00040000 	andeq	r0, r4, r0
    3d98:	00001269 	andeq	r1, r0, r9, ror #4
    3d9c:	1d960104 	ldfnes	f0, [r6, #16]
    3da0:	4f0c0000 	svcmi	0x000c0000
    3da4:	a500001f 	strge	r0, [r0, #-31]	; 0xffffffe1
    3da8:	7b00001b 	blvc	3e1c <shift+0x3e1c>
    3dac:	0200001f 	andeq	r0, r0, #31
    3db0:	6e690504 	cdpvs	5, 6, cr0, cr9, cr4, {0}
    3db4:	04030074 	streq	r0, [r3], #-116	; 0xffffff8c
    3db8:	001f9807 	andseq	r9, pc, r7, lsl #16
    3dbc:	05080300 	streq	r0, [r8, #-768]	; 0xfffffd00
    3dc0:	00000243 	andeq	r0, r0, r3, asr #4
    3dc4:	43040803 	movwmi	r0, #18435	; 0x4803
    3dc8:	0300001f 	movweq	r0, #31
    3dcc:	08570801 	ldmdaeq	r7, {r0, fp}^
    3dd0:	01030000 	mrseq	r0, (UNDEF: 3)
    3dd4:	00085906 	andeq	r5, r8, r6, lsl #18
    3dd8:	211b0400 	tstcs	fp, r0, lsl #8
    3ddc:	01070000 	mrseq	r0, (UNDEF: 7)
    3de0:	00000039 	andeq	r0, r0, r9, lsr r0
    3de4:	d4061701 	strle	r1, [r6], #-1793	; 0xfffff8ff
    3de8:	05000001 	streq	r0, [r0, #-1]
    3dec:	00001ca5 	andeq	r1, r0, r5, lsr #25
    3df0:	21ca0500 	biccs	r0, sl, r0, lsl #10
    3df4:	05010000 	streq	r0, [r1, #-0]
    3df8:	00001e78 	andeq	r1, r0, r8, ror lr
    3dfc:	1f360502 	svcne	0x00360502
    3e00:	05030000 	streq	r0, [r3, #-0]
    3e04:	00002134 	andeq	r2, r0, r4, lsr r1
    3e08:	21da0504 	bicscs	r0, sl, r4, lsl #10
    3e0c:	05050000 	streq	r0, [r5, #-0]
    3e10:	0000214a 	andeq	r2, r0, sl, asr #2
    3e14:	1f7f0506 	svcne	0x007f0506
    3e18:	05070000 	streq	r0, [r7, #-0]
    3e1c:	000020c5 	andeq	r2, r0, r5, asr #1
    3e20:	20d30508 	sbcscs	r0, r3, r8, lsl #10
    3e24:	05090000 	streq	r0, [r9, #-0]
    3e28:	000020e1 	andeq	r2, r0, r1, ror #1
    3e2c:	1fe8050a 	svcne	0x00e8050a
    3e30:	050b0000 	streq	r0, [fp, #-0]
    3e34:	00001fd8 	ldrdeq	r1, [r0], -r8
    3e38:	1cc1050c 	cfstr64ne	mvdx0, [r1], {12}
    3e3c:	050d0000 	streq	r0, [sp, #-0]
    3e40:	00001cda 	ldrdeq	r1, [r0], -sl
    3e44:	1fc9050e 	svcne	0x00c9050e
    3e48:	050f0000 	streq	r0, [pc, #-0]	; 3e50 <shift+0x3e50>
    3e4c:	0000218d 	andeq	r2, r0, sp, lsl #3
    3e50:	210a0510 	tstcs	sl, r0, lsl r5
    3e54:	05110000 	ldreq	r0, [r1, #-0]
    3e58:	0000217e 	andeq	r2, r0, lr, ror r1
    3e5c:	1d870512 	cfstr32ne	mvfx0, [r7, #72]	; 0x48
    3e60:	05130000 	ldreq	r0, [r3, #-0]
    3e64:	00001d04 	andeq	r1, r0, r4, lsl #26
    3e68:	1cce0514 	cfstr64ne	mvdx0, [lr], {20}
    3e6c:	05150000 	ldreq	r0, [r5, #-0]
    3e70:	00002067 	andeq	r2, r0, r7, rrx
    3e74:	1d3b0516 	cfldr32ne	mvfx0, [fp, #-88]!	; 0xffffffa8
    3e78:	05170000 	ldreq	r0, [r7, #-0]
    3e7c:	00001c76 	andeq	r1, r0, r6, ror ip
    3e80:	21700518 	cmncs	r0, r8, lsl r5
    3e84:	05190000 	ldreq	r0, [r9, #-0]
    3e88:	00001fa5 	andeq	r1, r0, r5, lsr #31
    3e8c:	207f051a 	rsbscs	r0, pc, sl, lsl r5	; <UNPREDICTABLE>
    3e90:	051b0000 	ldreq	r0, [fp, #-0]
    3e94:	00001d0f 	andeq	r1, r0, pc, lsl #26
    3e98:	1f1b051c 	svcne	0x001b051c
    3e9c:	051d0000 	ldreq	r0, [sp, #-0]
    3ea0:	00001e6a 	andeq	r1, r0, sl, ror #28
    3ea4:	20fc051e 	rscscs	r0, ip, lr, lsl r5
    3ea8:	051f0000 	ldreq	r0, [pc, #-0]	; 3eb0 <shift+0x3eb0>
    3eac:	00002158 	andeq	r2, r0, r8, asr r1
    3eb0:	21990520 	orrscs	r0, r9, r0, lsr #10
    3eb4:	05210000 	streq	r0, [r1, #-0]!
    3eb8:	000021a7 	andeq	r2, r0, r7, lsr #3
    3ebc:	1fbc0522 	svcne	0x00bc0522
    3ec0:	05230000 	streq	r0, [r3, #-0]!
    3ec4:	00001edf 	ldrdeq	r1, [r0], -pc	; <UNPREDICTABLE>
    3ec8:	1d1e0524 	cfldr32ne	mvfx0, [lr, #-144]	; 0xffffff70
    3ecc:	05250000 	streq	r0, [r5, #-0]!
    3ed0:	00001f72 	andeq	r1, r0, r2, ror pc
    3ed4:	1e840526 	cdpne	5, 8, cr0, cr4, cr6, {1}
    3ed8:	05270000 	streq	r0, [r7, #-0]!
    3edc:	00002127 	andeq	r2, r0, r7, lsr #2
    3ee0:	1e940528 	cdpne	5, 9, cr0, cr4, cr8, {1}
    3ee4:	05290000 	streq	r0, [r9, #-0]!
    3ee8:	00001ea3 	andeq	r1, r0, r3, lsr #29
    3eec:	1eb2052a 	cdpne	5, 11, cr0, cr2, cr10, {1}
    3ef0:	052b0000 	streq	r0, [fp, #-0]!
    3ef4:	00001ec1 	andeq	r1, r0, r1, asr #29
    3ef8:	1e4f052c 	cdpne	5, 4, cr0, cr15, cr12, {1}
    3efc:	052d0000 	streq	r0, [sp, #-0]!
    3f00:	00001ed0 	ldrdeq	r1, [r0], -r0
    3f04:	20b6052e 	adcscs	r0, r6, lr, lsr #10
    3f08:	052f0000 	streq	r0, [pc, #-0]!	; 3f10 <shift+0x3f10>
    3f0c:	00001eee 	andeq	r1, r0, lr, ror #29
    3f10:	1efd0530 	mrcne	5, 7, r0, cr13, cr0, {1}
    3f14:	05310000 	ldreq	r0, [r1, #-0]!
    3f18:	00001caf 	andeq	r1, r0, pc, lsr #25
    3f1c:	20070532 	andcs	r0, r7, r2, lsr r5
    3f20:	05330000 	ldreq	r0, [r3, #-0]!
    3f24:	00002017 	andeq	r2, r0, r7, lsl r0
    3f28:	20270534 	eorcs	r0, r7, r4, lsr r5
    3f2c:	05350000 	ldreq	r0, [r5, #-0]!
    3f30:	00001e3d 	andeq	r1, r0, sp, lsr lr
    3f34:	20370536 	eorscs	r0, r7, r6, lsr r5
    3f38:	05370000 	ldreq	r0, [r7, #-0]!
    3f3c:	00002047 	andeq	r2, r0, r7, asr #32
    3f40:	20570538 	subscs	r0, r7, r8, lsr r5
    3f44:	05390000 	ldreq	r0, [r9, #-0]!
    3f48:	00001d2e 	andeq	r1, r0, lr, lsr #26
    3f4c:	1ce7053a 	cfstr64ne	mvdx0, [r7], #232	; 0xe8
    3f50:	053b0000 	ldreq	r0, [fp, #-0]!
    3f54:	00001f0c 	andeq	r1, r0, ip, lsl #30
    3f58:	1c86053c 	cfstr32ne	mvfx0, [r6], {60}	; 0x3c
    3f5c:	053d0000 	ldreq	r0, [sp, #-0]!
    3f60:	00002072 	andeq	r2, r0, r2, ror r0
    3f64:	6e06003e 	mcrvs	0, 0, r0, cr6, cr14, {1}
    3f68:	0200001d 	andeq	r0, r0, #29
    3f6c:	08026b01 	stmdaeq	r2, {r0, r8, r9, fp, sp, lr}
    3f70:	000001ff 	strdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    3f74:	001f3107 	andseq	r3, pc, r7, lsl #2
    3f78:	02700100 	rsbseq	r0, r0, #0, 2
    3f7c:	00004714 	andeq	r4, r0, r4, lsl r7
    3f80:	4a070000 	bmi	1c3f88 <__bss_end+0x1b7e90>
    3f84:	0100001e 	tsteq	r0, lr, lsl r0
    3f88:	47140271 			; <UNDEFINED> instruction: 0x47140271
    3f8c:	01000000 	mrseq	r0, (UNDEF: 0)
    3f90:	01d40800 	bicseq	r0, r4, r0, lsl #16
    3f94:	ff090000 			; <UNDEFINED> instruction: 0xff090000
    3f98:	14000001 	strne	r0, [r0], #-1
    3f9c:	0a000002 	beq	3fac <shift+0x3fac>
    3fa0:	00000024 	andeq	r0, r0, r4, lsr #32
    3fa4:	04080011 	streq	r0, [r8], #-17	; 0xffffffef
    3fa8:	0b000002 	bleq	3fb8 <shift+0x3fb8>
    3fac:	00001ff5 	strdeq	r1, [r0], -r5
    3fb0:	26027401 	strcs	r7, [r2], -r1, lsl #8
    3fb4:	00000214 	andeq	r0, r0, r4, lsl r2
    3fb8:	0a3d3a24 	beq	f52850 <__bss_end+0xf46758>
    3fbc:	243d0f3d 	ldrtcs	r0, [sp], #-3901	; 0xfffff0c3
    3fc0:	023d323d 	eorseq	r3, sp, #-805306365	; 0xd0000003
    3fc4:	133d053d 	teqne	sp, #255852544	; 0xf400000
    3fc8:	0c3d0d3d 	ldceq	13, cr0, [sp], #-244	; 0xffffff0c
    3fcc:	113d233d 	teqne	sp, sp, lsr r3
    3fd0:	013d263d 	teqeq	sp, sp, lsr r6
    3fd4:	083d173d 	ldmdaeq	sp!, {r0, r2, r3, r4, r5, r8, r9, sl, ip}
    3fd8:	003d093d 	eorseq	r0, sp, sp, lsr r9
    3fdc:	07020300 	streq	r0, [r2, -r0, lsl #6]
    3fe0:	0000066a 	andeq	r0, r0, sl, ror #12
    3fe4:	60080103 	andvs	r0, r8, r3, lsl #2
    3fe8:	0c000008 	stceq	0, cr0, [r0], {8}
    3fec:	0259040d 	subseq	r0, r9, #218103808	; 0xd000000
    3ff0:	b50e0000 	strlt	r0, [lr, #-0]
    3ff4:	07000021 	streq	r0, [r0, -r1, lsr #32]
    3ff8:	00003901 	andeq	r3, r0, r1, lsl #18
    3ffc:	04f70200 	ldrbteq	r0, [r7], #512	; 0x200
    4000:	00029e06 	andeq	r9, r2, r6, lsl #28
    4004:	1d480500 	cfstr64ne	mvdx0, [r8, #-0]
    4008:	05000000 	streq	r0, [r0, #-0]
    400c:	00001d53 	andeq	r1, r0, r3, asr sp
    4010:	1d650501 	cfstr64ne	mvdx0, [r5, #-4]!
    4014:	05020000 	streq	r0, [r2, #-0]
    4018:	00001d7f 	andeq	r1, r0, pc, ror sp
    401c:	20ef0503 	rsccs	r0, pc, r3, lsl #10
    4020:	05040000 	streq	r0, [r4, #-0]
    4024:	00001e5e 	andeq	r1, r0, lr, asr lr
    4028:	20a80505 	adccs	r0, r8, r5, lsl #10
    402c:	00060000 	andeq	r0, r6, r0
    4030:	d9050203 	stmdble	r5, {r0, r1, r9}
    4034:	03000008 	movweq	r0, #8
    4038:	1f8e0708 	svcne	0x008e0708
    403c:	04030000 	streq	r0, [r3], #-0
    4040:	001c9f04 	andseq	r9, ip, r4, lsl #30
    4044:	03080300 	movweq	r0, #33536	; 0x8300
    4048:	00001c97 	muleq	r0, r7, ip
    404c:	48040803 	stmdami	r4, {r0, r1, fp}
    4050:	0300001f 	movweq	r0, #31
    4054:	20990310 	addscs	r0, r9, r0, lsl r3
    4058:	900f0000 	andls	r0, pc, r0
    405c:	03000020 	movweq	r0, #32
    4060:	025a102a 	subseq	r1, sl, #42	; 0x2a
    4064:	c8090000 	stmdagt	r9, {}	; <UNPREDICTABLE>
    4068:	df000002 	svcle	0x00000002
    406c:	10000002 	andne	r0, r0, r2
    4070:	030c1100 	movweq	r1, #49408	; 0xc100
    4074:	2f030000 	svccs	0x00030000
    4078:	0002d411 	andeq	sp, r2, r1, lsl r4
    407c:	02001100 	andeq	r1, r0, #0, 2
    4080:	30030000 	andcc	r0, r3, r0
    4084:	0002d411 	andeq	sp, r2, r1, lsl r4
    4088:	02c80900 	sbceq	r0, r8, #0, 18
    408c:	03070000 	movweq	r0, #28672	; 0x7000
    4090:	240a0000 	strcs	r0, [sl], #-0
    4094:	01000000 	mrseq	r0, (UNDEF: 0)
    4098:	02df1200 	sbcseq	r1, pc, #0, 4
    409c:	33040000 	movwcc	r0, #16384	; 0x4000
    40a0:	02f70a09 	rscseq	r0, r7, #36864	; 0x9000
    40a4:	03050000 	movweq	r0, #20480	; 0x5000
    40a8:	0000c0d8 	ldrdeq	ip, [r0], -r8
    40ac:	0002eb12 	andeq	lr, r2, r2, lsl fp
    40b0:	09340400 	ldmdbeq	r4!, {sl}
    40b4:	0002f70a 	andeq	pc, r2, sl, lsl #14
    40b8:	dc030500 	cfstr32le	mvfx0, [r3], {-0}
    40bc:	000000c0 	andeq	r0, r0, r0, asr #1
    40c0:	00000306 	andeq	r0, r0, r6, lsl #6
    40c4:	13560004 	cmpne	r6, #4
    40c8:	01040000 	mrseq	r0, (UNDEF: 4)
    40cc:	00001d96 	muleq	r0, r6, sp
    40d0:	001f4f0c 	andseq	r4, pc, ip, lsl #30
    40d4:	001ba500 	andseq	sl, fp, r0, lsl #10
    40d8:	00bb3000 	adcseq	r3, fp, r0
    40dc:	00003000 	andeq	r3, r0, r0
    40e0:	00202300 	eoreq	r2, r0, r0, lsl #6
    40e4:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
    40e8:	00001c9f 	muleq	r0, pc, ip	; <UNPREDICTABLE>
    40ec:	69050403 	stmdbvs	r5, {r0, r1, sl}
    40f0:	0200746e 	andeq	r7, r0, #1845493760	; 0x6e000000
    40f4:	1f980704 	svcne	0x00980704
    40f8:	08020000 	stmdaeq	r2, {}	; <UNPREDICTABLE>
    40fc:	00024305 	andeq	r4, r2, r5, lsl #6
    4100:	04080200 	streq	r0, [r8], #-512	; 0xfffffe00
    4104:	00001f43 	andeq	r1, r0, r3, asr #30
    4108:	57080102 	strpl	r0, [r8, -r2, lsl #2]
    410c:	02000008 	andeq	r0, r0, #8
    4110:	08590601 	ldmdaeq	r9, {r0, r9, sl}^
    4114:	1b040000 	blne	10411c <__bss_end+0xf8024>
    4118:	07000021 	streq	r0, [r0, -r1, lsr #32]
    411c:	00004801 	andeq	r4, r0, r1, lsl #16
    4120:	06170200 	ldreq	r0, [r7], -r0, lsl #4
    4124:	000001e3 	andeq	r0, r0, r3, ror #3
    4128:	001ca505 	andseq	sl, ip, r5, lsl #10
    412c:	ca050000 	bgt	144134 <__bss_end+0x13803c>
    4130:	01000021 	tsteq	r0, r1, lsr #32
    4134:	001e7805 	andseq	r7, lr, r5, lsl #16
    4138:	36050200 	strcc	r0, [r5], -r0, lsl #4
    413c:	0300001f 	movweq	r0, #31
    4140:	00213405 	eoreq	r3, r1, r5, lsl #8
    4144:	da050400 	ble	14514c <__bss_end+0x139054>
    4148:	05000021 	streq	r0, [r0, #-33]	; 0xffffffdf
    414c:	00214a05 	eoreq	r4, r1, r5, lsl #20
    4150:	7f050600 	svcvc	0x00050600
    4154:	0700001f 	smladeq	r0, pc, r0, r0	; <UNPREDICTABLE>
    4158:	0020c505 	eoreq	ip, r0, r5, lsl #10
    415c:	d3050800 	movwle	r0, #22528	; 0x5800
    4160:	09000020 	stmdbeq	r0, {r5}
    4164:	0020e105 	eoreq	lr, r0, r5, lsl #2
    4168:	e8050a00 	stmda	r5, {r9, fp}
    416c:	0b00001f 	bleq	41f0 <shift+0x41f0>
    4170:	001fd805 	andseq	sp, pc, r5, lsl #16
    4174:	c1050c00 	tstgt	r5, r0, lsl #24
    4178:	0d00001c 	stceq	0, cr0, [r0, #-112]	; 0xffffff90
    417c:	001cda05 	andseq	sp, ip, r5, lsl #20
    4180:	c9050e00 	stmdbgt	r5, {r9, sl, fp}
    4184:	0f00001f 	svceq	0x0000001f
    4188:	00218d05 	eoreq	r8, r1, r5, lsl #26
    418c:	0a051000 	beq	148194 <__bss_end+0x13c09c>
    4190:	11000021 	tstne	r0, r1, lsr #32
    4194:	00217e05 	eoreq	r7, r1, r5, lsl #28
    4198:	87051200 	strhi	r1, [r5, -r0, lsl #4]
    419c:	1300001d 	movwne	r0, #29
    41a0:	001d0405 	andseq	r0, sp, r5, lsl #8
    41a4:	ce051400 	cfcpysgt	mvf1, mvf5
    41a8:	1500001c 	strne	r0, [r0, #-28]	; 0xffffffe4
    41ac:	00206705 	eoreq	r6, r0, r5, lsl #14
    41b0:	3b051600 	blcc	1499b8 <__bss_end+0x13d8c0>
    41b4:	1700001d 	smladne	r0, sp, r0, r0
    41b8:	001c7605 	andseq	r7, ip, r5, lsl #12
    41bc:	70051800 	andvc	r1, r5, r0, lsl #16
    41c0:	19000021 	stmdbne	r0, {r0, r5}
    41c4:	001fa505 	andseq	sl, pc, r5, lsl #10
    41c8:	7f051a00 	svcvc	0x00051a00
    41cc:	1b000020 	blne	4254 <shift+0x4254>
    41d0:	001d0f05 	andseq	r0, sp, r5, lsl #30
    41d4:	1b051c00 	blne	14b1dc <__bss_end+0x13f0e4>
    41d8:	1d00001f 	stcne	0, cr0, [r0, #-124]	; 0xffffff84
    41dc:	001e6a05 	andseq	r6, lr, r5, lsl #20
    41e0:	fc051e00 	stc2	14, cr1, [r5], {-0}
    41e4:	1f000020 	svcne	0x00000020
    41e8:	00215805 	eoreq	r5, r1, r5, lsl #16
    41ec:	99052000 	stmdbls	r5, {sp}
    41f0:	21000021 	tstcs	r0, r1, lsr #32
    41f4:	0021a705 	eoreq	sl, r1, r5, lsl #14
    41f8:	bc052200 	sfmlt	f2, 4, [r5], {-0}
    41fc:	2300001f 	movwcs	r0, #31
    4200:	001edf05 	andseq	sp, lr, r5, lsl #30
    4204:	1e052400 	cfcpysne	mvf2, mvf5
    4208:	2500001d 	strcs	r0, [r0, #-29]	; 0xffffffe3
    420c:	001f7205 	andseq	r7, pc, r5, lsl #4
    4210:	84052600 	strhi	r2, [r5], #-1536	; 0xfffffa00
    4214:	2700001e 	smladcs	r0, lr, r0, r0
    4218:	00212705 	eoreq	r2, r1, r5, lsl #14
    421c:	94052800 	strls	r2, [r5], #-2048	; 0xfffff800
    4220:	2900001e 	stmdbcs	r0, {r1, r2, r3, r4}
    4224:	001ea305 	andseq	sl, lr, r5, lsl #6
    4228:	b2052a00 	andlt	r2, r5, #0, 20
    422c:	2b00001e 	blcs	42ac <shift+0x42ac>
    4230:	001ec105 	andseq	ip, lr, r5, lsl #2
    4234:	4f052c00 	svcmi	0x00052c00
    4238:	2d00001e 	stccs	0, cr0, [r0, #-120]	; 0xffffff88
    423c:	001ed005 	andseq	sp, lr, r5
    4240:	b6052e00 	strlt	r2, [r5], -r0, lsl #28
    4244:	2f000020 	svccs	0x00000020
    4248:	001eee05 	andseq	lr, lr, r5, lsl #28
    424c:	fd053000 	stc2	0, cr3, [r5, #-0]
    4250:	3100001e 	tstcc	r0, lr, lsl r0
    4254:	001caf05 	andseq	sl, ip, r5, lsl #30
    4258:	07053200 	streq	r3, [r5, -r0, lsl #4]
    425c:	33000020 	movwcc	r0, #32
    4260:	00201705 	eoreq	r1, r0, r5, lsl #14
    4264:	27053400 	strcs	r3, [r5, -r0, lsl #8]
    4268:	35000020 	strcc	r0, [r0, #-32]	; 0xffffffe0
    426c:	001e3d05 	andseq	r3, lr, r5, lsl #26
    4270:	37053600 	strcc	r3, [r5, -r0, lsl #12]
    4274:	37000020 	strcc	r0, [r0, -r0, lsr #32]
    4278:	00204705 	eoreq	r4, r0, r5, lsl #14
    427c:	57053800 	strpl	r3, [r5, -r0, lsl #16]
    4280:	39000020 	stmdbcc	r0, {r5}
    4284:	001d2e05 	andseq	r2, sp, r5, lsl #28
    4288:	e7053a00 	str	r3, [r5, -r0, lsl #20]
    428c:	3b00001c 	blcc	4304 <shift+0x4304>
    4290:	001f0c05 	andseq	r0, pc, r5, lsl #24
    4294:	86053c00 	strhi	r3, [r5], -r0, lsl #24
    4298:	3d00001c 	stccc	0, cr0, [r0, #-112]	; 0xffffff90
    429c:	00207205 	eoreq	r7, r0, r5, lsl #4
    42a0:	06003e00 	streq	r3, [r0], -r0, lsl #28
    42a4:	00001d6e 	andeq	r1, r0, lr, ror #26
    42a8:	026b0202 	rsbeq	r0, fp, #536870912	; 0x20000000
    42ac:	00020e08 	andeq	r0, r2, r8, lsl #28
    42b0:	1f310700 	svcne	0x00310700
    42b4:	70020000 	andvc	r0, r2, r0
    42b8:	00561402 	subseq	r1, r6, r2, lsl #8
    42bc:	07000000 	streq	r0, [r0, -r0]
    42c0:	00001e4a 	andeq	r1, r0, sl, asr #28
    42c4:	14027102 	strne	r7, [r2], #-258	; 0xfffffefe
    42c8:	00000056 	andeq	r0, r0, r6, asr r0
    42cc:	e3080001 	movw	r0, #32769	; 0x8001
    42d0:	09000001 	stmdbeq	r0, {r0}
    42d4:	0000020e 	andeq	r0, r0, lr, lsl #4
    42d8:	00000223 	andeq	r0, r0, r3, lsr #4
    42dc:	0000330a 	andeq	r3, r0, sl, lsl #6
    42e0:	08001100 	stmdaeq	r0, {r8, ip}
    42e4:	00000213 	andeq	r0, r0, r3, lsl r2
    42e8:	001ff50b 	andseq	pc, pc, fp, lsl #10
    42ec:	02740200 	rsbseq	r0, r4, #0, 4
    42f0:	00022326 	andeq	r2, r2, r6, lsr #6
    42f4:	3d3a2400 	cfldrscc	mvf2, [sl, #-0]
    42f8:	3d0f3d0a 	stccc	13, cr3, [pc, #-40]	; 42d8 <shift+0x42d8>
    42fc:	3d323d24 	ldccc	13, cr3, [r2, #-144]!	; 0xffffff70
    4300:	3d053d02 	stccc	13, cr3, [r5, #-8]
    4304:	3d0d3d13 	stccc	13, cr3, [sp, #-76]	; 0xffffffb4
    4308:	3d233d0c 	stccc	13, cr3, [r3, #-48]!	; 0xffffffd0
    430c:	3d263d11 	stccc	13, cr3, [r6, #-68]!	; 0xffffffbc
    4310:	3d173d01 	ldccc	13, cr3, [r7, #-4]
    4314:	3d093d08 	stccc	13, cr3, [r9, #-32]	; 0xffffffe0
    4318:	02020000 	andeq	r0, r2, #0
    431c:	00066a07 	andeq	r6, r6, r7, lsl #20
    4320:	08010200 	stmdaeq	r1, {r9}
    4324:	00000860 	andeq	r0, r0, r0, ror #16
    4328:	d9050202 	stmdble	r5, {r1, r9}
    432c:	0c000008 	stceq	0, cr0, [r0], {8}
    4330:	00002226 	andeq	r2, r0, r6, lsr #4
    4334:	3a0f8403 	bcc	3e5348 <__bss_end+0x3d9250>
    4338:	02000000 	andeq	r0, r0, #0
    433c:	1f8e0708 	svcne	0x008e0708
    4340:	f70c0000 			; <UNDEFINED> instruction: 0xf70c0000
    4344:	03000021 	movweq	r0, #33	; 0x21
    4348:	00251093 	mlaeq	r5, r3, r0, r1
    434c:	08020000 	stmdaeq	r2, {}	; <UNPREDICTABLE>
    4350:	001c9703 	andseq	r9, ip, r3, lsl #14
    4354:	04080200 	streq	r0, [r8], #-512	; 0xfffffe00
    4358:	00001f48 	andeq	r1, r0, r8, asr #30
    435c:	99031002 	stmdbls	r3, {r1, ip}
    4360:	0d000020 	stceq	0, cr0, [r0, #-128]	; 0xffffff80
    4364:	0000220c 	andeq	r2, r0, ip, lsl #4
    4368:	0105f901 	tsteq	r5, r1, lsl #18	; <UNPREDICTABLE>
    436c:	0000026f 	andeq	r0, r0, pc, ror #4
    4370:	0000bb30 	andeq	fp, r0, r0, lsr fp
    4374:	00000030 	andeq	r0, r0, r0, lsr r0
    4378:	02fd9c01 	rscseq	r9, sp, #256	; 0x100
    437c:	610e0000 	mrsvs	r0, (UNDEF: 14)
    4380:	05f90100 	ldrbeq	r0, [r9, #256]!	; 0x100
    4384:	00028213 	andeq	r8, r2, r3, lsl r2
    4388:	00000800 	andeq	r0, r0, r0, lsl #16
    438c:	00000000 	andeq	r0, r0, r0
    4390:	bb440f00 	bllt	1107f98 <__bss_end+0x10fbea0>
    4394:	02fd0000 	rscseq	r0, sp, #0
    4398:	02e80000 	rsceq	r0, r8, #0
    439c:	01100000 	tsteq	r0, r0
    43a0:	03f30550 	mvnseq	r0, #80, 10	; 0x14000000
    43a4:	002500f5 	strdeq	r0, [r5], -r5	; <UNPREDICTABLE>
    43a8:	00bb5411 	adcseq	r5, fp, r1, lsl r4
    43ac:	0002fd00 	andeq	pc, r2, r0, lsl #26
    43b0:	50011000 	andpl	r1, r1, r0
    43b4:	f503f306 			; <UNDEFINED> instruction: 0xf503f306
    43b8:	001f2500 	andseq	r2, pc, r0, lsl #10
    43bc:	21fe1200 	mvnscs	r1, r0, lsl #4
    43c0:	21ea0000 	mvncs	r0, r0
    43c4:	3b010000 	blcc	443cc <__bss_end+0x382d4>
    43c8:	032a0003 			; <UNDEFINED> instruction: 0x032a0003
    43cc:	00040000 	andeq	r0, r4, r0
    43d0:	00001465 	andeq	r1, r0, r5, ror #8
    43d4:	1d960104 	ldfnes	f0, [r6, #16]
    43d8:	4f0c0000 	svcmi	0x000c0000
    43dc:	a500001f 	strge	r0, [r0, #-31]	; 0xffffffe1
    43e0:	6000001b 	andvs	r0, r0, fp, lsl r0
    43e4:	400000bb 	strhmi	r0, [r0], -fp
    43e8:	ce000000 	cdpgt	0, 0, cr0, cr0, cr0, {0}
    43ec:	02000020 	andeq	r0, r0, #32
    43f0:	1f480408 	svcne	0x00480408
    43f4:	04020000 	streq	r0, [r2], #-0
    43f8:	001f9807 	andseq	r9, pc, r7, lsl #16
    43fc:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
    4400:	00001c9f 	muleq	r0, pc, ip	; <UNPREDICTABLE>
    4404:	69050403 	stmdbvs	r5, {r0, r1, sl}
    4408:	0200746e 	andeq	r7, r0, #1845493760	; 0x6e000000
    440c:	02430508 	subeq	r0, r3, #8, 10	; 0x2000000
    4410:	08020000 	stmdaeq	r2, {}	; <UNPREDICTABLE>
    4414:	001f4304 	andseq	r4, pc, r4, lsl #6
    4418:	08010200 	stmdaeq	r1, {r9}
    441c:	00000857 	andeq	r0, r0, r7, asr r8
    4420:	59060102 	stmdbpl	r6, {r1, r8}
    4424:	04000008 	streq	r0, [r0], #-8
    4428:	0000211b 	andeq	r2, r0, fp, lsl r1
    442c:	004f0107 	subeq	r0, pc, r7, lsl #2
    4430:	17020000 	strne	r0, [r2, -r0]
    4434:	0001ea06 	andeq	lr, r1, r6, lsl #20
    4438:	1ca50500 	cfstr32ne	mvfx0, [r5]
    443c:	05000000 	streq	r0, [r0, #-0]
    4440:	000021ca 	andeq	r2, r0, sl, asr #3
    4444:	1e780501 	cdpne	5, 7, cr0, cr8, cr1, {0}
    4448:	05020000 	streq	r0, [r2, #-0]
    444c:	00001f36 	andeq	r1, r0, r6, lsr pc
    4450:	21340503 	teqcs	r4, r3, lsl #10
    4454:	05040000 	streq	r0, [r4, #-0]
    4458:	000021da 	ldrdeq	r2, [r0], -sl
    445c:	214a0505 	cmpcs	sl, r5, lsl #10
    4460:	05060000 	streq	r0, [r6, #-0]
    4464:	00001f7f 	andeq	r1, r0, pc, ror pc
    4468:	20c50507 	sbccs	r0, r5, r7, lsl #10
    446c:	05080000 	streq	r0, [r8, #-0]
    4470:	000020d3 	ldrdeq	r2, [r0], -r3
    4474:	20e10509 	rsccs	r0, r1, r9, lsl #10
    4478:	050a0000 	streq	r0, [sl, #-0]
    447c:	00001fe8 	andeq	r1, r0, r8, ror #31
    4480:	1fd8050b 	svcne	0x00d8050b
    4484:	050c0000 	streq	r0, [ip, #-0]
    4488:	00001cc1 	andeq	r1, r0, r1, asr #25
    448c:	1cda050d 	cfldr64ne	mvdx0, [sl], {13}
    4490:	050e0000 	streq	r0, [lr, #-0]
    4494:	00001fc9 	andeq	r1, r0, r9, asr #31
    4498:	218d050f 	orrcs	r0, sp, pc, lsl #10
    449c:	05100000 	ldreq	r0, [r0, #-0]
    44a0:	0000210a 	andeq	r2, r0, sl, lsl #2
    44a4:	217e0511 	cmncs	lr, r1, lsl r5
    44a8:	05120000 	ldreq	r0, [r2, #-0]
    44ac:	00001d87 	andeq	r1, r0, r7, lsl #27
    44b0:	1d040513 	cfstr32ne	mvfx0, [r4, #-76]	; 0xffffffb4
    44b4:	05140000 	ldreq	r0, [r4, #-0]
    44b8:	00001cce 	andeq	r1, r0, lr, asr #25
    44bc:	20670515 	rsbcs	r0, r7, r5, lsl r5
    44c0:	05160000 	ldreq	r0, [r6, #-0]
    44c4:	00001d3b 	andeq	r1, r0, fp, lsr sp
    44c8:	1c760517 	cfldr64ne	mvdx0, [r6], #-92	; 0xffffffa4
    44cc:	05180000 	ldreq	r0, [r8, #-0]
    44d0:	00002170 	andeq	r2, r0, r0, ror r1
    44d4:	1fa50519 	svcne	0x00a50519
    44d8:	051a0000 	ldreq	r0, [sl, #-0]
    44dc:	0000207f 	andeq	r2, r0, pc, ror r0
    44e0:	1d0f051b 	cfstr32ne	mvfx0, [pc, #-108]	; 447c <shift+0x447c>
    44e4:	051c0000 	ldreq	r0, [ip, #-0]
    44e8:	00001f1b 	andeq	r1, r0, fp, lsl pc
    44ec:	1e6a051d 	mcrne	5, 3, r0, cr10, cr13, {0}
    44f0:	051e0000 	ldreq	r0, [lr, #-0]
    44f4:	000020fc 	strdeq	r2, [r0], -ip
    44f8:	2158051f 	cmpcs	r8, pc, lsl r5
    44fc:	05200000 	streq	r0, [r0, #-0]!
    4500:	00002199 	muleq	r0, r9, r1
    4504:	21a70521 			; <UNDEFINED> instruction: 0x21a70521
    4508:	05220000 	streq	r0, [r2, #-0]!
    450c:	00001fbc 			; <UNDEFINED> instruction: 0x00001fbc
    4510:	1edf0523 	cdpne	5, 13, cr0, cr15, cr3, {1}
    4514:	05240000 	streq	r0, [r4, #-0]!
    4518:	00001d1e 	andeq	r1, r0, lr, lsl sp
    451c:	1f720525 	svcne	0x00720525
    4520:	05260000 	streq	r0, [r6, #-0]!
    4524:	00001e84 	andeq	r1, r0, r4, lsl #29
    4528:	21270527 			; <UNDEFINED> instruction: 0x21270527
    452c:	05280000 	streq	r0, [r8, #-0]!
    4530:	00001e94 	muleq	r0, r4, lr
    4534:	1ea30529 	cdpne	5, 10, cr0, cr3, cr9, {1}
    4538:	052a0000 	streq	r0, [sl, #-0]!
    453c:	00001eb2 			; <UNDEFINED> instruction: 0x00001eb2
    4540:	1ec1052b 	cdpne	5, 12, cr0, cr1, cr11, {1}
    4544:	052c0000 	streq	r0, [ip, #-0]!
    4548:	00001e4f 	andeq	r1, r0, pc, asr #28
    454c:	1ed0052d 	cdpne	5, 13, cr0, cr0, cr13, {1}
    4550:	052e0000 	streq	r0, [lr, #-0]!
    4554:	000020b6 	strheq	r2, [r0], -r6
    4558:	1eee052f 	cdpne	5, 14, cr0, cr14, cr15, {1}
    455c:	05300000 	ldreq	r0, [r0, #-0]!
    4560:	00001efd 	strdeq	r1, [r0], -sp
    4564:	1caf0531 	cfstr32ne	mvfx0, [pc], #196	; 4630 <shift+0x4630>
    4568:	05320000 	ldreq	r0, [r2, #-0]!
    456c:	00002007 	andeq	r2, r0, r7
    4570:	20170533 	andscs	r0, r7, r3, lsr r5
    4574:	05340000 	ldreq	r0, [r4, #-0]!
    4578:	00002027 	andeq	r2, r0, r7, lsr #32
    457c:	1e3d0535 	mrcne	5, 1, r0, cr13, cr5, {1}
    4580:	05360000 	ldreq	r0, [r6, #-0]!
    4584:	00002037 	andeq	r2, r0, r7, lsr r0
    4588:	20470537 	subcs	r0, r7, r7, lsr r5
    458c:	05380000 	ldreq	r0, [r8, #-0]!
    4590:	00002057 	andeq	r2, r0, r7, asr r0
    4594:	1d2e0539 	cfstr32ne	mvfx0, [lr, #-228]!	; 0xffffff1c
    4598:	053a0000 	ldreq	r0, [sl, #-0]!
    459c:	00001ce7 	andeq	r1, r0, r7, ror #25
    45a0:	1f0c053b 	svcne	0x000c053b
    45a4:	053c0000 	ldreq	r0, [ip, #-0]!
    45a8:	00001c86 	andeq	r1, r0, r6, lsl #25
    45ac:	2072053d 	rsbscs	r0, r2, sp, lsr r5
    45b0:	003e0000 	eorseq	r0, lr, r0
    45b4:	001d6e06 	andseq	r6, sp, r6, lsl #28
    45b8:	6b020200 	blvs	84dc0 <__bss_end+0x78cc8>
    45bc:	02150802 	andseq	r0, r5, #131072	; 0x20000
    45c0:	31070000 	mrscc	r0, (UNDEF: 7)
    45c4:	0200001f 	andeq	r0, r0, #31
    45c8:	5d140270 	lfmpl	f0, 4, [r4, #-448]	; 0xfffffe40
    45cc:	00000000 	andeq	r0, r0, r0
    45d0:	001e4a07 	andseq	r4, lr, r7, lsl #20
    45d4:	02710200 	rsbseq	r0, r1, #0, 4
    45d8:	00005d14 	andeq	r5, r0, r4, lsl sp
    45dc:	08000100 	stmdaeq	r0, {r8}
    45e0:	000001ea 	andeq	r0, r0, sl, ror #3
    45e4:	00021509 	andeq	r1, r2, r9, lsl #10
    45e8:	00022a00 	andeq	r2, r2, r0, lsl #20
    45ec:	002c0a00 	eoreq	r0, ip, r0, lsl #20
    45f0:	00110000 	andseq	r0, r1, r0
    45f4:	00021a08 	andeq	r1, r2, r8, lsl #20
    45f8:	1ff50b00 	svcne	0x00f50b00
    45fc:	74020000 	strvc	r0, [r2], #-0
    4600:	022a2602 	eoreq	r2, sl, #2097152	; 0x200000
    4604:	3a240000 	bcc	90460c <__bss_end+0x8f8514>
    4608:	0f3d0a3d 	svceq	0x003d0a3d
    460c:	323d243d 	eorscc	r2, sp, #1023410176	; 0x3d000000
    4610:	053d023d 	ldreq	r0, [sp, #-573]!	; 0xfffffdc3
    4614:	0d3d133d 	ldceq	3, cr1, [sp, #-244]!	; 0xffffff0c
    4618:	233d0c3d 	teqcs	sp, #15616	; 0x3d00
    461c:	263d113d 			; <UNDEFINED> instruction: 0x263d113d
    4620:	173d013d 			; <UNDEFINED> instruction: 0x173d013d
    4624:	093d083d 	ldmdbeq	sp!, {r0, r2, r3, r4, r5, fp}
    4628:	0200003d 	andeq	r0, r0, #61	; 0x3d
    462c:	066a0702 	strbteq	r0, [sl], -r2, lsl #14
    4630:	01020000 	mrseq	r0, (UNDEF: 2)
    4634:	00086008 	andeq	r6, r8, r8
    4638:	05020200 	streq	r0, [r2, #-512]	; 0xfffffe00
    463c:	000008d9 	ldrdeq	r0, [r0], -r9
    4640:	00221d0c 	eoreq	r1, r2, ip, lsl #26
    4644:	16810300 	strne	r0, [r1], r0, lsl #6
    4648:	0000002c 	andeq	r0, r0, ip, lsr #32
    464c:	00027608 	andeq	r7, r2, r8, lsl #12
    4650:	22250c00 	eorcs	r0, r5, #0, 24
    4654:	85030000 	strhi	r0, [r3, #-0]
    4658:	00029316 	andeq	r9, r2, r6, lsl r3
    465c:	07080200 	streq	r0, [r8, -r0, lsl #4]
    4660:	00001f8e 	andeq	r1, r0, lr, lsl #31
    4664:	0021f70c 	eoreq	pc, r1, ip, lsl #14
    4668:	10930300 	addsne	r0, r3, r0, lsl #6
    466c:	00000033 	andeq	r0, r0, r3, lsr r0
    4670:	97030802 	strls	r0, [r3, -r2, lsl #16]
    4674:	0c00001c 	stceq	0, cr0, [r0], {28}
    4678:	00002216 	andeq	r2, r0, r6, lsl r2
    467c:	25109703 	ldrcs	r9, [r0, #-1795]	; 0xfffff8fd
    4680:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    4684:	000002ad 	andeq	r0, r0, sp, lsr #5
    4688:	99031002 	stmdbls	r3, {r1, ip}
    468c:	0d000020 	stceq	0, cr0, [r0, #-128]	; 0xffffff80
    4690:	000021ea 	andeq	r2, r0, sl, ror #3
    4694:	0105b901 	tsteq	r5, r1, lsl #18
    4698:	00000287 	andeq	r0, r0, r7, lsl #5
    469c:	0000bb60 	andeq	fp, r0, r0, ror #22
    46a0:	00000040 	andeq	r0, r0, r0, asr #32
    46a4:	610e9c01 	tstvs	lr, r1, lsl #24
    46a8:	05b90100 	ldreq	r0, [r9, #256]!	; 0x100
    46ac:	00029a16 	andeq	r9, r2, r6, lsl sl
    46b0:	00004a00 	andeq	r4, r0, r0, lsl #20
    46b4:	00004600 	andeq	r4, r0, r0, lsl #12
    46b8:	66640f00 	strbtvs	r0, [r4], -r0, lsl #30
    46bc:	bf010061 	svclt	0x00010061
    46c0:	02b91005 	adcseq	r1, r9, #5
    46c4:	00730000 	rsbseq	r0, r3, r0
    46c8:	006d0000 	rsbeq	r0, sp, r0
    46cc:	680f0000 	stmdavs	pc, {}	; <UNPREDICTABLE>
    46d0:	c4010069 	strgt	r0, [r1], #-105	; 0xffffff97
    46d4:	02821005 	addeq	r1, r2, #5
    46d8:	00b10000 	adcseq	r0, r1, r0
    46dc:	00af0000 	adceq	r0, pc, r0
    46e0:	6c0f0000 	stcvs	0, cr0, [pc], {-0}
    46e4:	c901006f 	stmdbgt	r1, {r0, r1, r2, r3, r5, r6}
    46e8:	02821005 	addeq	r1, r2, #5
    46ec:	00cb0000 	sbceq	r0, fp, r0
    46f0:	00c50000 	sbceq	r0, r5, r0
    46f4:	00000000 	andeq	r0, r0, r0
    46f8:	00000380 	andeq	r0, r0, r0, lsl #7
    46fc:	154c0004 	strbne	r0, [ip, #-4]
    4700:	01040000 	mrseq	r0, (UNDEF: 4)
    4704:	0000222d 	andeq	r2, r0, sp, lsr #4
    4708:	001f4f0c 	andseq	r4, pc, ip, lsl #30
    470c:	001ba500 	andseq	sl, fp, r0, lsl #10
    4710:	00bba000 	adcseq	sl, fp, r0
    4714:	00012000 	andeq	r2, r1, r0
    4718:	00218800 	eoreq	r8, r1, r0, lsl #16
    471c:	07080200 	streq	r0, [r8, -r0, lsl #4]
    4720:	00001f8e 	andeq	r1, r0, lr, lsl #31
    4724:	69050403 	stmdbvs	r5, {r0, r1, sl}
    4728:	0200746e 	andeq	r7, r0, #1845493760	; 0x6e000000
    472c:	1f980704 	svcne	0x00980704
    4730:	08020000 	stmdaeq	r2, {}	; <UNPREDICTABLE>
    4734:	00024305 	andeq	r4, r2, r5, lsl #6
    4738:	04080200 	streq	r0, [r8], #-512	; 0xfffffe00
    473c:	00001f43 	andeq	r1, r0, r3, asr #30
    4740:	57080102 	strpl	r0, [r8, -r2, lsl #2]
    4744:	02000008 	andeq	r0, r0, #8
    4748:	08590601 	ldmdaeq	r9, {r0, r9, sl}^
    474c:	1b040000 	blne	104754 <__bss_end+0xf865c>
    4750:	07000021 	streq	r0, [r0, -r1, lsr #32]
    4754:	00004801 	andeq	r4, r0, r1, lsl #16
    4758:	06170200 	ldreq	r0, [r7], -r0, lsl #4
    475c:	000001e3 	andeq	r0, r0, r3, ror #3
    4760:	001ca505 	andseq	sl, ip, r5, lsl #10
    4764:	ca050000 	bgt	14476c <__bss_end+0x138674>
    4768:	01000021 	tsteq	r0, r1, lsr #32
    476c:	001e7805 	andseq	r7, lr, r5, lsl #16
    4770:	36050200 	strcc	r0, [r5], -r0, lsl #4
    4774:	0300001f 	movweq	r0, #31
    4778:	00213405 	eoreq	r3, r1, r5, lsl #8
    477c:	da050400 	ble	145784 <__bss_end+0x13968c>
    4780:	05000021 	streq	r0, [r0, #-33]	; 0xffffffdf
    4784:	00214a05 	eoreq	r4, r1, r5, lsl #20
    4788:	7f050600 	svcvc	0x00050600
    478c:	0700001f 	smladeq	r0, pc, r0, r0	; <UNPREDICTABLE>
    4790:	0020c505 	eoreq	ip, r0, r5, lsl #10
    4794:	d3050800 	movwle	r0, #22528	; 0x5800
    4798:	09000020 	stmdbeq	r0, {r5}
    479c:	0020e105 	eoreq	lr, r0, r5, lsl #2
    47a0:	e8050a00 	stmda	r5, {r9, fp}
    47a4:	0b00001f 	bleq	4828 <shift+0x4828>
    47a8:	001fd805 	andseq	sp, pc, r5, lsl #16
    47ac:	c1050c00 	tstgt	r5, r0, lsl #24
    47b0:	0d00001c 	stceq	0, cr0, [r0, #-112]	; 0xffffff90
    47b4:	001cda05 	andseq	sp, ip, r5, lsl #20
    47b8:	c9050e00 	stmdbgt	r5, {r9, sl, fp}
    47bc:	0f00001f 	svceq	0x0000001f
    47c0:	00218d05 	eoreq	r8, r1, r5, lsl #26
    47c4:	0a051000 	beq	1487cc <__bss_end+0x13c6d4>
    47c8:	11000021 	tstne	r0, r1, lsr #32
    47cc:	00217e05 	eoreq	r7, r1, r5, lsl #28
    47d0:	87051200 	strhi	r1, [r5, -r0, lsl #4]
    47d4:	1300001d 	movwne	r0, #29
    47d8:	001d0405 	andseq	r0, sp, r5, lsl #8
    47dc:	ce051400 	cfcpysgt	mvf1, mvf5
    47e0:	1500001c 	strne	r0, [r0, #-28]	; 0xffffffe4
    47e4:	00206705 	eoreq	r6, r0, r5, lsl #14
    47e8:	3b051600 	blcc	149ff0 <__bss_end+0x13def8>
    47ec:	1700001d 	smladne	r0, sp, r0, r0
    47f0:	001c7605 	andseq	r7, ip, r5, lsl #12
    47f4:	70051800 	andvc	r1, r5, r0, lsl #16
    47f8:	19000021 	stmdbne	r0, {r0, r5}
    47fc:	001fa505 	andseq	sl, pc, r5, lsl #10
    4800:	7f051a00 	svcvc	0x00051a00
    4804:	1b000020 	blne	488c <shift+0x488c>
    4808:	001d0f05 	andseq	r0, sp, r5, lsl #30
    480c:	1b051c00 	blne	14b814 <__bss_end+0x13f71c>
    4810:	1d00001f 	stcne	0, cr0, [r0, #-124]	; 0xffffff84
    4814:	001e6a05 	andseq	r6, lr, r5, lsl #20
    4818:	fc051e00 	stc2	14, cr1, [r5], {-0}
    481c:	1f000020 	svcne	0x00000020
    4820:	00215805 	eoreq	r5, r1, r5, lsl #16
    4824:	99052000 	stmdbls	r5, {sp}
    4828:	21000021 	tstcs	r0, r1, lsr #32
    482c:	0021a705 	eoreq	sl, r1, r5, lsl #14
    4830:	bc052200 	sfmlt	f2, 4, [r5], {-0}
    4834:	2300001f 	movwcs	r0, #31
    4838:	001edf05 	andseq	sp, lr, r5, lsl #30
    483c:	1e052400 	cfcpysne	mvf2, mvf5
    4840:	2500001d 	strcs	r0, [r0, #-29]	; 0xffffffe3
    4844:	001f7205 	andseq	r7, pc, r5, lsl #4
    4848:	84052600 	strhi	r2, [r5], #-1536	; 0xfffffa00
    484c:	2700001e 	smladcs	r0, lr, r0, r0
    4850:	00212705 	eoreq	r2, r1, r5, lsl #14
    4854:	94052800 	strls	r2, [r5], #-2048	; 0xfffff800
    4858:	2900001e 	stmdbcs	r0, {r1, r2, r3, r4}
    485c:	001ea305 	andseq	sl, lr, r5, lsl #6
    4860:	b2052a00 	andlt	r2, r5, #0, 20
    4864:	2b00001e 	blcs	48e4 <shift+0x48e4>
    4868:	001ec105 	andseq	ip, lr, r5, lsl #2
    486c:	4f052c00 	svcmi	0x00052c00
    4870:	2d00001e 	stccs	0, cr0, [r0, #-120]	; 0xffffff88
    4874:	001ed005 	andseq	sp, lr, r5
    4878:	b6052e00 	strlt	r2, [r5], -r0, lsl #28
    487c:	2f000020 	svccs	0x00000020
    4880:	001eee05 	andseq	lr, lr, r5, lsl #28
    4884:	fd053000 	stc2	0, cr3, [r5, #-0]
    4888:	3100001e 	tstcc	r0, lr, lsl r0
    488c:	001caf05 	andseq	sl, ip, r5, lsl #30
    4890:	07053200 	streq	r3, [r5, -r0, lsl #4]
    4894:	33000020 	movwcc	r0, #32
    4898:	00201705 	eoreq	r1, r0, r5, lsl #14
    489c:	27053400 	strcs	r3, [r5, -r0, lsl #8]
    48a0:	35000020 	strcc	r0, [r0, #-32]	; 0xffffffe0
    48a4:	001e3d05 	andseq	r3, lr, r5, lsl #26
    48a8:	37053600 	strcc	r3, [r5, -r0, lsl #12]
    48ac:	37000020 	strcc	r0, [r0, -r0, lsr #32]
    48b0:	00204705 	eoreq	r4, r0, r5, lsl #14
    48b4:	57053800 	strpl	r3, [r5, -r0, lsl #16]
    48b8:	39000020 	stmdbcc	r0, {r5}
    48bc:	001d2e05 	andseq	r2, sp, r5, lsl #28
    48c0:	e7053a00 	str	r3, [r5, -r0, lsl #20]
    48c4:	3b00001c 	blcc	493c <shift+0x493c>
    48c8:	001f0c05 	andseq	r0, pc, r5, lsl #24
    48cc:	86053c00 	strhi	r3, [r5], -r0, lsl #24
    48d0:	3d00001c 	stccc	0, cr0, [r0, #-112]	; 0xffffff90
    48d4:	00207205 	eoreq	r7, r0, r5, lsl #4
    48d8:	06003e00 	streq	r3, [r0], -r0, lsl #28
    48dc:	00001d6e 	andeq	r1, r0, lr, ror #26
    48e0:	026b0202 	rsbeq	r0, fp, #536870912	; 0x20000000
    48e4:	00020e08 	andeq	r0, r2, r8, lsl #28
    48e8:	1f310700 	svcne	0x00310700
    48ec:	70020000 	andvc	r0, r2, r0
    48f0:	00561402 	subseq	r1, r6, r2, lsl #8
    48f4:	07000000 	streq	r0, [r0, -r0]
    48f8:	00001e4a 	andeq	r1, r0, sl, asr #28
    48fc:	14027102 	strne	r7, [r2], #-258	; 0xfffffefe
    4900:	00000056 	andeq	r0, r0, r6, asr r0
    4904:	e3080001 	movw	r0, #32769	; 0x8001
    4908:	09000001 	stmdbeq	r0, {r0}
    490c:	0000020e 	andeq	r0, r0, lr, lsl #4
    4910:	00000223 	andeq	r0, r0, r3, lsr #4
    4914:	0000330a 	andeq	r3, r0, sl, lsl #6
    4918:	08001100 	stmdaeq	r0, {r8, ip}
    491c:	00000213 	andeq	r0, r0, r3, lsl r2
    4920:	001ff50b 	andseq	pc, pc, fp, lsl #10
    4924:	02740200 	rsbseq	r0, r4, #0, 4
    4928:	00022326 	andeq	r2, r2, r6, lsr #6
    492c:	3d3a2400 	cfldrscc	mvf2, [sl, #-0]
    4930:	3d0f3d0a 	stccc	13, cr3, [pc, #-40]	; 4910 <shift+0x4910>
    4934:	3d323d24 	ldccc	13, cr3, [r2, #-144]!	; 0xffffff70
    4938:	3d053d02 	stccc	13, cr3, [r5, #-8]
    493c:	3d0d3d13 	stccc	13, cr3, [sp, #-76]	; 0xffffffb4
    4940:	3d233d0c 	stccc	13, cr3, [r3, #-48]!	; 0xffffffd0
    4944:	3d263d11 	stccc	13, cr3, [r6, #-68]!	; 0xffffffbc
    4948:	3d173d01 	ldccc	13, cr3, [r7, #-4]
    494c:	3d093d08 	stccc	13, cr3, [r9, #-32]	; 0xffffffe0
    4950:	02020000 	andeq	r0, r2, #0
    4954:	00066a07 	andeq	r6, r6, r7, lsl #20
    4958:	08010200 	stmdaeq	r1, {r9}
    495c:	00000860 	andeq	r0, r0, r0, ror #16
    4960:	d9050202 	stmdble	r5, {r1, r9}
    4964:	0c000008 	stceq	0, cr0, [r0], {8}
    4968:	0000221d 	andeq	r2, r0, sp, lsl r2
    496c:	33168103 	tstcc	r6, #-1073741824	; 0xc0000000
    4970:	0c000000 	stceq	0, cr0, [r0], {-0}
    4974:	00002225 	andeq	r2, r0, r5, lsr #4
    4978:	25168503 	ldrcs	r8, [r6, #-1283]	; 0xfffffafd
    497c:	02000000 	andeq	r0, r0, #0
    4980:	1c9f0404 	cfldrsne	mvf0, [pc], {4}
    4984:	08020000 	stmdaeq	r2, {}	; <UNPREDICTABLE>
    4988:	001c9703 	andseq	r9, ip, r3, lsl #14
    498c:	04080200 	streq	r0, [r8], #-512	; 0xfffffe00
    4990:	00001f48 	andeq	r1, r0, r8, asr #30
    4994:	99031002 	stmdbls	r3, {r1, ip}
    4998:	0d000020 	stceq	0, cr0, [r0, #-128]	; 0xffffff80
    499c:	000022e1 	andeq	r2, r0, r1, ror #5
    49a0:	0103b301 	tsteq	r3, r1, lsl #6
    49a4:	0000027b 	andeq	r0, r0, fp, ror r2
    49a8:	0000bba0 	andeq	fp, r0, r0, lsr #23
    49ac:	00000120 	andeq	r0, r0, r0, lsr #2
    49b0:	037d9c01 	cmneq	sp, #256	; 0x100
    49b4:	6e0e0000 	cdpvs	0, 0, cr0, cr14, cr0, {0}
    49b8:	03b30100 			; <UNDEFINED> instruction: 0x03b30100
    49bc:	00027b17 	andeq	r7, r2, r7, lsl fp
    49c0:	00014900 	andeq	r4, r1, r0, lsl #18
    49c4:	00014500 	andeq	r4, r1, r0, lsl #10
    49c8:	00640e00 	rsbeq	r0, r4, r0, lsl #28
    49cc:	2203b301 	andcs	fp, r3, #67108864	; 0x4000000
    49d0:	0000027b 	andeq	r0, r0, fp, ror r2
    49d4:	00000175 	andeq	r0, r0, r5, ror r1
    49d8:	00000171 	andeq	r0, r0, r1, ror r1
    49dc:	0070720f 	rsbseq	r7, r0, pc, lsl #4
    49e0:	2e03b301 	cdpcs	3, 0, cr11, cr3, cr1, {0}
    49e4:	0000037d 	andeq	r0, r0, sp, ror r3
    49e8:	10009102 	andne	r9, r0, r2, lsl #2
    49ec:	b5010071 	strlt	r0, [r1, #-113]	; 0xffffff8f
    49f0:	027b0b03 	rsbseq	r0, fp, #3072	; 0xc00
    49f4:	01a50000 			; <UNDEFINED> instruction: 0x01a50000
    49f8:	019d0000 	orrseq	r0, sp, r0
    49fc:	72100000 	andsvc	r0, r0, #0
    4a00:	03b50100 			; <UNDEFINED> instruction: 0x03b50100
    4a04:	00027b12 	andeq	r7, r2, r2, lsl fp
    4a08:	0001fb00 	andeq	pc, r1, r0, lsl #22
    4a0c:	0001f100 	andeq	pc, r1, r0, lsl #2
    4a10:	00791000 	rsbseq	r1, r9, r0
    4a14:	1903b501 	stmdbne	r3, {r0, r8, sl, ip, sp, pc}
    4a18:	0000027b 	andeq	r0, r0, fp, ror r2
    4a1c:	00000259 	andeq	r0, r0, r9, asr r2
    4a20:	00000253 	andeq	r0, r0, r3, asr r2
    4a24:	317a6c10 	cmncc	sl, r0, lsl ip
    4a28:	03b60100 			; <UNDEFINED> instruction: 0x03b60100
    4a2c:	00026f0a 	andeq	r6, r2, sl, lsl #30
    4a30:	00029300 	andeq	r9, r2, r0, lsl #6
    4a34:	00029100 	andeq	r9, r2, r0, lsl #2
    4a38:	7a6c1000 	bvc	1b08a40 <__bss_end+0x1afc948>
    4a3c:	b6010032 			; <UNDEFINED> instruction: 0xb6010032
    4a40:	026f0f03 	rsbeq	r0, pc, #3, 30
    4a44:	02aa0000 	adceq	r0, sl, #0
    4a48:	02a80000 	adceq	r0, r8, #0
    4a4c:	69100000 	ldmdbvs	r0, {}	; <UNPREDICTABLE>
    4a50:	03b60100 			; <UNDEFINED> instruction: 0x03b60100
    4a54:	00026f14 	andeq	r6, r2, r4, lsl pc
    4a58:	0002c900 	andeq	ip, r2, r0, lsl #18
    4a5c:	0002bd00 	andeq	fp, r2, r0, lsl #26
    4a60:	006b1000 	rsbeq	r1, fp, r0
    4a64:	1703b601 	strne	fp, [r3, -r1, lsl #12]
    4a68:	0000026f 	andeq	r0, r0, pc, ror #4
    4a6c:	0000031b 	andeq	r0, r0, fp, lsl r3
    4a70:	00000317 	andeq	r0, r0, r7, lsl r3
    4a74:	7b041100 	blvc	108e7c <__bss_end+0xfcd84>
    4a78:	00000002 	andeq	r0, r0, r2
    4a7c:	00000139 	andeq	r0, r0, r9, lsr r1
    4a80:	164f0004 	strbne	r0, [pc], -r4
    4a84:	01040000 	mrseq	r0, (UNDEF: 4)
    4a88:	0000238d 	andeq	r2, r0, sp, lsl #7
    4a8c:	0023590c 	eoreq	r5, r3, ip, lsl #18
    4a90:	0022f500 	eoreq	pc, r2, r0, lsl #10
    4a94:	00bcc000 	adcseq	ip, ip, r0
    4a98:	00011800 	andeq	r1, r1, r0, lsl #16
    4a9c:	0022f500 	eoreq	pc, r2, r0, lsl #10
    4aa0:	05040200 	streq	r0, [r4, #-512]	; 0xfffffe00
    4aa4:	00746e69 	rsbseq	r6, r4, r9, ror #28
    4aa8:	0022ee03 	eoreq	lr, r2, r3, lsl #28
    4aac:	17d10200 	ldrbne	r0, [r1, r0, lsl #4]
    4ab0:	00000038 	andeq	r0, r0, r8, lsr r0
    4ab4:	98070404 	stmdals	r7, {r2, sl}
    4ab8:	0400001f 	streq	r0, [r0], #-31	; 0xffffffe1
    4abc:	02430508 	subeq	r0, r3, #8, 10	; 0x2000000
    4ac0:	08040000 	stmdaeq	r4, {}	; <UNPREDICTABLE>
    4ac4:	001f4304 	andseq	r4, pc, r4, lsl #6
    4ac8:	06010400 	streq	r0, [r1], -r0, lsl #8
    4acc:	00000859 	andeq	r0, r0, r9, asr r8
    4ad0:	57080104 	strpl	r0, [r8, -r4, lsl #2]
    4ad4:	04000008 	streq	r0, [r0], #-8
    4ad8:	08d90502 	ldmeq	r9, {r1, r8, sl}^
    4adc:	02040000 	andeq	r0, r4, #0
    4ae0:	00066a07 	andeq	r6, r6, r7, lsl #20
    4ae4:	05040400 	streq	r0, [r4, #-1024]	; 0xfffffc00
    4ae8:	00000248 	andeq	r0, r0, r8, asr #4
    4aec:	93070404 	movwls	r0, #29700	; 0x7404
    4af0:	0400001f 	streq	r0, [r0], #-31	; 0xffffffe1
    4af4:	1f8e0708 	svcne	0x008e0708
    4af8:	04050000 	streq	r0, [r5], #-0
    4afc:	00860406 	addeq	r0, r6, r6, lsl #8
    4b00:	01040000 	mrseq	r0, (UNDEF: 4)
    4b04:	00086008 	andeq	r6, r8, r8
    4b08:	23fd0700 	mvnscs	r0, #0, 14
    4b0c:	21030000 	mrscs	r0, (UNDEF: 3)
    4b10:	00007e09 	andeq	r7, r0, r9, lsl #28
    4b14:	00bcc000 	adcseq	ip, ip, r0
    4b18:	00011800 	andeq	r1, r1, r0, lsl #16
    4b1c:	369c0100 	ldrcc	r0, [ip], r0, lsl #2
    4b20:	08000001 	stmdaeq	r0, {r0}
    4b24:	2601006d 	strcs	r0, [r1], -sp, rrx
    4b28:	00007e0f 	andeq	r7, r0, pc, lsl #28
    4b2c:	09500100 	ldmdbeq	r0, {r8}^
    4b30:	27010063 	strcs	r0, [r1, -r3, rrx]
    4b34:	00002506 	andeq	r2, r0, r6, lsl #10
    4b38:	00034500 	andeq	r4, r3, r0, lsl #10
    4b3c:	00033b00 	andeq	r3, r3, r0, lsl #22
    4b40:	006e0900 	rsbeq	r0, lr, r0, lsl #18
    4b44:	2c092801 	stccs	8, cr2, [r9], {1}
    4b48:	9c000000 	stcls	0, cr0, [r0], {-0}
    4b4c:	8a000003 	bhi	4b60 <shift+0x4b60>
    4b50:	0a000003 	beq	4b64 <shift+0x4b64>
    4b54:	2a010073 	bcs	44d28 <__bss_end+0x38c30>
    4b58:	00008009 	andeq	r8, r0, r9
    4b5c:	00042300 	andeq	r2, r4, r0, lsl #6
    4b60:	00040d00 	andeq	r0, r4, r0, lsl #26
    4b64:	00690a00 	rsbeq	r0, r9, r0, lsl #20
    4b68:	38102d01 	ldmdacc	r0, {r0, r8, sl, fp, sp}
    4b6c:	b0000000 	andlt	r0, r0, r0
    4b70:	aa000004 	bge	4b88 <shift+0x4b88>
    4b74:	0b000004 	bleq	4b8c <shift+0x4b8c>
    4b78:	00000d09 	andeq	r0, r0, r9, lsl #26
    4b7c:	70112e01 	andsvc	r2, r1, r1, lsl #28
    4b80:	e5000000 	str	r0, [r0, #-0]
    4b84:	df000004 	svcle	0x00000004
    4b88:	0b000004 	bleq	4ba0 <shift+0x4ba0>
    4b8c:	0000234c 	andeq	r2, r0, ip, asr #6
    4b90:	36122f01 	ldrcc	r2, [r2], -r1, lsl #30
    4b94:	26000001 	strcs	r0, [r0], -r1
    4b98:	0e000005 	cdpeq	0, 0, cr0, cr0, cr5, {0}
    4b9c:	0a000005 	beq	4bb8 <shift+0x4bb8>
    4ba0:	30010064 	andcc	r0, r1, r4, rrx
    4ba4:	00003810 	andeq	r3, r0, r0, lsl r8
    4ba8:	0005c600 	andeq	ip, r5, r0, lsl #12
    4bac:	0005bc00 	andeq	fp, r5, r0, lsl #24
    4bb0:	04060000 	streq	r0, [r6], #-0
    4bb4:	00000070 	andeq	r0, r0, r0, ror r0
	...

Disassembly of section .debug_abbrev:

00000000 <.debug_abbrev>:
       0:	10001101 	andne	r1, r0, r1, lsl #2
       4:	12011106 	andne	r1, r1, #-2147483647	; 0x80000001
       8:	1b0e0301 	blne	380c14 <__bss_end+0x374b1c>
       c:	130e250e 	movwne	r2, #58638	; 0xe50e
      10:	00000005 	andeq	r0, r0, r5
      14:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
      18:	030b130e 	movweq	r1, #45838	; 0xb30e
      1c:	110e1b0e 	tstne	lr, lr, lsl #22
      20:	10061201 	andne	r1, r6, r1, lsl #4
      24:	02000017 	andeq	r0, r0, #23
      28:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
      2c:	0b3b0b3a 	bleq	ec2d1c <__bss_end+0xeb6c24>
      30:	13490b39 	movtne	r0, #39737	; 0x9b39
      34:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
      38:	24030000 	strcs	r0, [r3], #-0
      3c:	3e0b0b00 	vmlacc.f64	d0, d11, d0
      40:	000e030b 	andeq	r0, lr, fp, lsl #6
      44:	012e0400 			; <UNDEFINED> instruction: 0x012e0400
      48:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
      4c:	0b3b0b3a 	bleq	ec2d3c <__bss_end+0xeb6c44>
      50:	01110b39 	tsteq	r1, r9, lsr fp
      54:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
      58:	01194296 			; <UNDEFINED> instruction: 0x01194296
      5c:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
      60:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
      64:	0b3b0b3a 	bleq	ec2d54 <__bss_end+0xeb6c5c>
      68:	13490b39 	movtne	r0, #39737	; 0x9b39
      6c:	00001802 	andeq	r1, r0, r2, lsl #16
      70:	0b002406 	bleq	9090 <_ZN5Model16Get_Data_SamplesEv+0x1c>
      74:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
      78:	07000008 	streq	r0, [r0, -r8]
      7c:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
      80:	0b3a0e03 	bleq	e83894 <__bss_end+0xe7779c>
      84:	0b390b3b 	bleq	e42d78 <__bss_end+0xe36c80>
      88:	06120111 			; <UNDEFINED> instruction: 0x06120111
      8c:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
      90:	00130119 	andseq	r0, r3, r9, lsl r1
      94:	010b0800 	tsteq	fp, r0, lsl #16
      98:	06120111 			; <UNDEFINED> instruction: 0x06120111
      9c:	34090000 	strcc	r0, [r9], #-0
      a0:	3a080300 	bcc	200ca8 <__bss_end+0x1f4bb0>
      a4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
      a8:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
      ac:	0a000018 	beq	114 <shift+0x114>
      b0:	0b0b000f 	bleq	2c00f4 <__bss_end+0x2b3ffc>
      b4:	00001349 	andeq	r1, r0, r9, asr #6
      b8:	01110100 	tsteq	r1, r0, lsl #2
      bc:	0b130e25 	bleq	4c3958 <__bss_end+0x4b7860>
      c0:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
      c4:	06120111 			; <UNDEFINED> instruction: 0x06120111
      c8:	00001710 	andeq	r1, r0, r0, lsl r7
      cc:	03001602 	movweq	r1, #1538	; 0x602
      d0:	3b0b3a0e 	blcc	2ce910 <__bss_end+0x2c2818>
      d4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
      d8:	03000013 	movweq	r0, #19
      dc:	0b0b000f 	bleq	2c0120 <__bss_end+0x2b4028>
      e0:	00001349 	andeq	r1, r0, r9, asr #6
      e4:	00001504 	andeq	r1, r0, r4, lsl #10
      e8:	01010500 	tsteq	r1, r0, lsl #10
      ec:	13011349 	movwne	r1, #4937	; 0x1349
      f0:	21060000 	mrscs	r0, (UNDEF: 6)
      f4:	2f134900 	svccs	0x00134900
      f8:	07000006 	streq	r0, [r0, -r6]
      fc:	0b0b0024 	bleq	2c0194 <__bss_end+0x2b409c>
     100:	0e030b3e 	vmoveq.16	d3[0], r0
     104:	34080000 	strcc	r0, [r8], #-0
     108:	3a0e0300 	bcc	380d10 <__bss_end+0x374c18>
     10c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     110:	3f13490b 	svccc	0x0013490b
     114:	00193c19 	andseq	r3, r9, r9, lsl ip
     118:	012e0900 			; <UNDEFINED> instruction: 0x012e0900
     11c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
     120:	0b3b0b3a 	bleq	ec2e10 <__bss_end+0xeb6d18>
     124:	13490b39 	movtne	r0, #39737	; 0x9b39
     128:	06120111 			; <UNDEFINED> instruction: 0x06120111
     12c:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
     130:	00130119 	andseq	r0, r3, r9, lsl r1
     134:	00340a00 	eorseq	r0, r4, r0, lsl #20
     138:	0b3a0e03 	bleq	e8394c <__bss_end+0xe77854>
     13c:	0b390b3b 	bleq	e42e30 <__bss_end+0xe36d38>
     140:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
     144:	240b0000 	strcs	r0, [fp], #-0
     148:	3e0b0b00 	vmlacc.f64	d0, d11, d0
     14c:	0008030b 	andeq	r0, r8, fp, lsl #6
     150:	002e0c00 	eoreq	r0, lr, r0, lsl #24
     154:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
     158:	0b3b0b3a 	bleq	ec2e48 <__bss_end+0xeb6d50>
     15c:	01110b39 	tsteq	r1, r9, lsr fp
     160:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
     164:	00194297 	mulseq	r9, r7, r2
     168:	01390d00 	teqeq	r9, r0, lsl #26
     16c:	0b3a0e03 	bleq	e83980 <__bss_end+0xe77888>
     170:	13010b3b 	movwne	r0, #6971	; 0x1b3b
     174:	2e0e0000 	cdpcs	0, 0, cr0, cr14, cr0, {0}
     178:	03193f01 	tsteq	r9, #1, 30
     17c:	3b0b3a0e 	blcc	2ce9bc <__bss_end+0x2c28c4>
     180:	3c0b390b 			; <UNDEFINED> instruction: 0x3c0b390b
     184:	00130119 	andseq	r0, r3, r9, lsl r1
     188:	00050f00 	andeq	r0, r5, r0, lsl #30
     18c:	00001349 	andeq	r1, r0, r9, asr #6
     190:	3f012e10 	svccc	0x00012e10
     194:	3a0e0319 	bcc	380e00 <__bss_end+0x374d08>
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
     1c0:	3a080300 	bcc	200dc8 <__bss_end+0x1f4cd0>
     1c4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     1c8:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
     1cc:	14000018 	strne	r0, [r0], #-24	; 0xffffffe8
     1d0:	1347012e 	movtne	r0, #28974	; 0x712e
     1d4:	06120111 			; <UNDEFINED> instruction: 0x06120111
     1d8:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
     1dc:	00000019 	andeq	r0, r0, r9, lsl r0
     1e0:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
     1e4:	030b130e 	movweq	r1, #45838	; 0xb30e
     1e8:	550e1b0e 	strpl	r1, [lr, #-2830]	; 0xfffff4f2
     1ec:	10011117 	andne	r1, r1, r7, lsl r1
     1f0:	02000017 	andeq	r0, r0, #23
     1f4:	0b0b0024 	bleq	2c028c <__bss_end+0x2b4194>
     1f8:	0e030b3e 	vmoveq.16	d3[0], r0
     1fc:	26030000 	strcs	r0, [r3], -r0
     200:	00134900 	andseq	r4, r3, r0, lsl #18
     204:	00240400 	eoreq	r0, r4, r0, lsl #8
     208:	0b3e0b0b 	bleq	f82e3c <__bss_end+0xf76d44>
     20c:	00000803 	andeq	r0, r0, r3, lsl #16
     210:	03001605 	movweq	r1, #1541	; 0x605
     214:	3b0b3a0e 	blcc	2cea54 <__bss_end+0x2c295c>
     218:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     21c:	06000013 			; <UNDEFINED> instruction: 0x06000013
     220:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
     224:	0b3b0b3a 	bleq	ec2f14 <__bss_end+0xeb6e1c>
     228:	13490b39 	movtne	r0, #39737	; 0x9b39
     22c:	1802196c 	stmdane	r2, {r2, r3, r5, r6, r8, fp, ip}
     230:	04070000 	streq	r0, [r7], #-0
     234:	6d0e0301 	stcvs	3, cr0, [lr, #-4]
     238:	0b0b3e19 	bleq	2cfaa4 <__bss_end+0x2c39ac>
     23c:	3a13490b 	bcc	4d2670 <__bss_end+0x4c6578>
     240:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     244:	0013010b 	andseq	r0, r3, fp, lsl #2
     248:	00280800 	eoreq	r0, r8, r0, lsl #16
     24c:	0b1c0e03 	bleq	703a60 <__bss_end+0x6f7968>
     250:	0f090000 	svceq	0x00090000
     254:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
     258:	0a000013 	beq	2ac <shift+0x2ac>
     25c:	0b0b000f 	bleq	2c02a0 <__bss_end+0x2b41a8>
     260:	020b0000 	andeq	r0, fp, #0
     264:	0b0e0301 	bleq	380e70 <__bss_end+0x374d78>
     268:	3b0b3a0b 	blcc	2cea9c <__bss_end+0x2c29a4>
     26c:	010b390b 	tsteq	fp, fp, lsl #18
     270:	0c000013 	stceq	0, cr0, [r0], {19}
     274:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
     278:	0b3b0b3a 	bleq	ec2f68 <__bss_end+0xeb6e70>
     27c:	13490b39 	movtne	r0, #39737	; 0x9b39
     280:	00000b38 	andeq	r0, r0, r8, lsr fp
     284:	3f012e0d 	svccc	0x00012e0d
     288:	3a0e0319 	bcc	380ef4 <__bss_end+0x374dfc>
     28c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     290:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
     294:	3c0b3213 	sfmcc	f3, 4, [fp], {19}
     298:	01136419 	tsteq	r3, r9, lsl r4
     29c:	0e000013 	mcreq	0, 0, r0, cr0, cr3, {0}
     2a0:	13490005 	movtne	r0, #36869	; 0x9005
     2a4:	00001934 	andeq	r1, r0, r4, lsr r9
     2a8:	3f012e0f 	svccc	0x00012e0f
     2ac:	3a0e0319 	bcc	380f18 <__bss_end+0x374e20>
     2b0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     2b4:	320e6e0b 	andcc	r6, lr, #11, 28	; 0xb0
     2b8:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
     2bc:	00130113 	andseq	r0, r3, r3, lsl r1
     2c0:	00051000 	andeq	r1, r5, r0
     2c4:	00001349 	andeq	r1, r0, r9, asr #6
     2c8:	3f012e11 	svccc	0x00012e11
     2cc:	3a0e0319 	bcc	380f38 <__bss_end+0x374e40>
     2d0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     2d4:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
     2d8:	3c0b3213 	sfmcc	f3, 4, [fp], {19}
     2dc:	00136419 	andseq	r6, r3, r9, lsl r4
     2e0:	00341200 	eorseq	r1, r4, r0, lsl #4
     2e4:	0b3a0803 	bleq	e822f8 <__bss_end+0xe76200>
     2e8:	0b390b3b 	bleq	e42fdc <__bss_end+0xe36ee4>
     2ec:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
     2f0:	0000193c 	andeq	r1, r0, ip, lsr r9
     2f4:	03010213 	movweq	r0, #4627	; 0x1213
     2f8:	3a050b0e 	bcc	142f38 <__bss_end+0x136e40>
     2fc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     300:	0013010b 	andseq	r0, r3, fp, lsl #2
     304:	000d1400 	andeq	r1, sp, r0, lsl #8
     308:	0b3a0e03 	bleq	e83b1c <__bss_end+0xe77a24>
     30c:	0b390b3b 	bleq	e43000 <__bss_end+0xe36f08>
     310:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
     314:	0b1c193c 	bleq	70680c <__bss_end+0x6fa714>
     318:	2e150000 	cdpcs	0, 1, cr0, cr5, cr0, {0}
     31c:	03193f01 	tsteq	r9, #1, 30
     320:	3b0b3a0e 	blcc	2ceb60 <__bss_end+0x2c2a68>
     324:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
     328:	64193c0e 	ldrvs	r3, [r9], #-3086	; 0xfffff3f2
     32c:	00130113 	andseq	r0, r3, r3, lsl r1
     330:	012e1600 			; <UNDEFINED> instruction: 0x012e1600
     334:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
     338:	0b3b0b3a 	bleq	ec3028 <__bss_end+0xeb6f30>
     33c:	0e6e0b39 	vmoveq.8	d14[5], r0
     340:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
     344:	13011364 	movwne	r1, #4964	; 0x1364
     348:	2e170000 	cdpcs	0, 1, cr0, cr7, cr0, {0}
     34c:	03193f01 	tsteq	r9, #1, 30
     350:	3b0b3a0e 	blcc	2ceb90 <__bss_end+0x2c2a98>
     354:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
     358:	3c0b320e 	sfmcc	f3, 4, [fp], {14}
     35c:	00136419 	andseq	r6, r3, r9, lsl r4
     360:	01011800 	tsteq	r1, r0, lsl #16
     364:	13011349 	movwne	r1, #4937	; 0x1349
     368:	21190000 	tstcs	r9, r0
     36c:	2f134900 	svccs	0x00134900
     370:	1a00000b 	bne	3a4 <shift+0x3a4>
     374:	0803000d 	stmdaeq	r3, {r0, r2, r3}
     378:	0b3b0b3a 	bleq	ec3068 <__bss_end+0xeb6f70>
     37c:	13490b39 	movtne	r0, #39737	; 0x9b39
     380:	00000b38 	andeq	r0, r0, r8, lsr fp
     384:	0301131b 	movweq	r1, #4891	; 0x131b
     388:	3a0b0b0e 	bcc	2c2fc8 <__bss_end+0x2b6ed0>
     38c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     390:	0013010b 	andseq	r0, r3, fp, lsl #2
     394:	000d1c00 	andeq	r1, sp, r0, lsl #24
     398:	0b3a0e03 	bleq	e83bac <__bss_end+0xe77ab4>
     39c:	0b390b3b 	bleq	e43090 <__bss_end+0xe36f98>
     3a0:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
     3a4:	0a1c193c 	beq	70689c <__bss_end+0x6fa7a4>
     3a8:	0000196c 	andeq	r1, r0, ip, ror #18
     3ac:	3f012e1d 	svccc	0x00012e1d
     3b0:	3a080319 	bcc	20101c <__bss_end+0x1f4f24>
     3b4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     3b8:	320e6e0b 	andcc	r6, lr, #11, 28	; 0xb0
     3bc:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
     3c0:	1e000013 	mcrne	0, 0, r0, cr0, cr3, {0}
     3c4:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
     3c8:	0b3b0b3a 	bleq	ec30b8 <__bss_end+0xeb6fc0>
     3cc:	13490b39 	movtne	r0, #39737	; 0x9b39
     3d0:	00001802 	andeq	r1, r0, r2, lsl #16
     3d4:	3f012e1f 	svccc	0x00012e1f
     3d8:	3a0e0319 	bcc	381044 <__bss_end+0x374f4c>
     3dc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     3e0:	1113490b 	tstne	r3, fp, lsl #18
     3e4:	40061201 	andmi	r1, r6, r1, lsl #4
     3e8:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
     3ec:	00001301 	andeq	r1, r0, r1, lsl #6
     3f0:	03003420 	movweq	r3, #1056	; 0x420
     3f4:	3b0b3a08 	blcc	2cec1c <__bss_end+0x2c2b24>
     3f8:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     3fc:	00180213 	andseq	r0, r8, r3, lsl r2
     400:	00342100 	eorseq	r2, r4, r0, lsl #2
     404:	0b3a0e03 	bleq	e83c18 <__bss_end+0xe77b20>
     408:	0b390b3b 	bleq	e430fc <__bss_end+0xe37004>
     40c:	00001349 	andeq	r1, r0, r9, asr #6
     410:	3f012e22 	svccc	0x00012e22
     414:	3a0e0319 	bcc	381080 <__bss_end+0x374f88>
     418:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     41c:	110e6e0b 	tstne	lr, fp, lsl #28
     420:	40061201 	andmi	r1, r6, r1, lsl #4
     424:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
     428:	00001301 	andeq	r1, r0, r1, lsl #6
     42c:	03000523 	movweq	r0, #1315	; 0x523
     430:	3b0b3a08 	blcc	2cec58 <__bss_end+0x2c2b60>
     434:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     438:	00180213 	andseq	r0, r8, r3, lsl r2
     43c:	012e2400 			; <UNDEFINED> instruction: 0x012e2400
     440:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
     444:	0b3b0b3a 	bleq	ec3134 <__bss_end+0xeb703c>
     448:	0e6e0b39 	vmoveq.8	d14[5], r0
     44c:	06120111 			; <UNDEFINED> instruction: 0x06120111
     450:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
     454:	00130119 	andseq	r0, r3, r9, lsl r1
     458:	00052500 	andeq	r2, r5, r0, lsl #10
     45c:	0b3a0e03 	bleq	e83c70 <__bss_end+0xe77b78>
     460:	0b390b3b 	bleq	e43154 <__bss_end+0xe3705c>
     464:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
     468:	2e260000 	cdpcs	0, 2, cr0, cr6, cr0, {0}
     46c:	03193f01 	tsteq	r9, #1, 30
     470:	3b0b3a0e 	blcc	2cecb0 <__bss_end+0x2c2bb8>
     474:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
     478:	1113490e 	tstne	r3, lr, lsl #18
     47c:	40061201 	andmi	r1, r6, r1, lsl #4
     480:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
     484:	01000000 	mrseq	r0, (UNDEF: 0)
     488:	0e250111 	mcreq	1, 1, r0, cr5, cr1, {0}
     48c:	0e030b13 	vmoveq.32	d3[0], r0
     490:	17550e1b 	smmlane	r5, fp, lr, r0
     494:	17100111 			; <UNDEFINED> instruction: 0x17100111
     498:	02020000 	andeq	r0, r2, #0
     49c:	0b0e0301 	bleq	3810a8 <__bss_end+0x374fb0>
     4a0:	3b0b3a0b 	blcc	2cecd4 <__bss_end+0x2c2bdc>
     4a4:	010b390b 	tsteq	fp, fp, lsl #18
     4a8:	03000013 	movweq	r0, #19
     4ac:	0803000d 	stmdaeq	r3, {r0, r2, r3}
     4b0:	0b3b0b3a 	bleq	ec31a0 <__bss_end+0xeb70a8>
     4b4:	13490b39 	movtne	r0, #39737	; 0x9b39
     4b8:	00000b38 	andeq	r0, r0, r8, lsr fp
     4bc:	03000d04 	movweq	r0, #3332	; 0xd04
     4c0:	3b0b3a0e 	blcc	2ced00 <__bss_end+0x2c2c08>
     4c4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     4c8:	000b3813 	andeq	r3, fp, r3, lsl r8
     4cc:	012e0500 			; <UNDEFINED> instruction: 0x012e0500
     4d0:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
     4d4:	0b3b0b3a 	bleq	ec31c4 <__bss_end+0xeb70cc>
     4d8:	0e6e0b39 	vmoveq.8	d14[5], r0
     4dc:	0b321349 	bleq	c85208 <__bss_end+0xc79110>
     4e0:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
     4e4:	00001301 	andeq	r1, r0, r1, lsl #6
     4e8:	49000506 	stmdbmi	r0, {r1, r2, r8, sl}
     4ec:	00193413 	andseq	r3, r9, r3, lsl r4
     4f0:	00050700 	andeq	r0, r5, r0, lsl #14
     4f4:	00001349 	andeq	r1, r0, r9, asr #6
     4f8:	3f012e08 	svccc	0x00012e08
     4fc:	3a0e0319 	bcc	381168 <__bss_end+0x375070>
     500:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     504:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
     508:	3c0b3213 	sfmcc	f3, 4, [fp], {19}
     50c:	00136419 	andseq	r6, r3, r9, lsl r4
     510:	00240900 	eoreq	r0, r4, r0, lsl #18
     514:	0b3e0b0b 	bleq	f83148 <__bss_end+0xf77050>
     518:	00000803 	andeq	r0, r0, r3, lsl #16
     51c:	0b000f0a 	bleq	414c <shift+0x414c>
     520:	0013490b 	andseq	r4, r3, fp, lsl #18
     524:	00240b00 	eoreq	r0, r4, r0, lsl #22
     528:	0b3e0b0b 	bleq	f8315c <__bss_end+0xf77064>
     52c:	00000e03 	andeq	r0, r0, r3, lsl #28
     530:	4900260c 	stmdbmi	r0, {r2, r3, r9, sl, sp}
     534:	0d000013 	stceq	0, cr0, [r0, #-76]	; 0xffffffb4
     538:	0e030016 	mcreq	0, 0, r0, cr3, cr6, {0}
     53c:	0b3b0b3a 	bleq	ec322c <__bss_end+0xeb7134>
     540:	13490b39 	movtne	r0, #39737	; 0x9b39
     544:	2e0e0000 	cdpcs	0, 0, cr0, cr14, cr0, {0}
     548:	03193f01 	tsteq	r9, #1, 30
     54c:	3b0b3a0e 	blcc	2ced8c <__bss_end+0x2c2c94>
     550:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
     554:	3c0b320e 	sfmcc	f3, 4, [fp], {14}
     558:	01136419 	tsteq	r3, r9, lsl r4
     55c:	0f000013 	svceq	0x00000013
     560:	0b0b000f 	bleq	2c05a4 <__bss_end+0x2b44ac>
     564:	34100000 	ldrcc	r0, [r0], #-0
     568:	3a080300 	bcc	201170 <__bss_end+0x1f5078>
     56c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     570:	3f13490b 	svccc	0x0013490b
     574:	00193c19 	andseq	r3, r9, r9, lsl ip
     578:	00341100 	eorseq	r1, r4, r0, lsl #2
     57c:	0b3a0e03 	bleq	e83d90 <__bss_end+0xe77c98>
     580:	0b390b3b 	bleq	e43274 <__bss_end+0xe3717c>
     584:	196c1349 	stmdbne	ip!, {r0, r3, r6, r8, r9, ip}^
     588:	00001802 	andeq	r1, r0, r2, lsl #16
     58c:	03010212 	movweq	r0, #4626	; 0x1212
     590:	3a050b0e 	bcc	1431d0 <__bss_end+0x1370d8>
     594:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     598:	0013010b 	andseq	r0, r3, fp, lsl #2
     59c:	000d1300 	andeq	r1, sp, r0, lsl #6
     5a0:	0b3a0e03 	bleq	e83db4 <__bss_end+0xe77cbc>
     5a4:	0b390b3b 	bleq	e43298 <__bss_end+0xe371a0>
     5a8:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
     5ac:	0b1c193c 	bleq	706aa4 <__bss_end+0x6fa9ac>
     5b0:	2e140000 	cdpcs	0, 1, cr0, cr4, cr0, {0}
     5b4:	03193f01 	tsteq	r9, #1, 30
     5b8:	3b0b3a0e 	blcc	2cedf8 <__bss_end+0x2c2d00>
     5bc:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
     5c0:	64193c0e 	ldrvs	r3, [r9], #-3086	; 0xfffff3f2
     5c4:	00130113 	andseq	r0, r3, r3, lsl r1
     5c8:	012e1500 			; <UNDEFINED> instruction: 0x012e1500
     5cc:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
     5d0:	0b3b0b3a 	bleq	ec32c0 <__bss_end+0xeb71c8>
     5d4:	0e6e0b39 	vmoveq.8	d14[5], r0
     5d8:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
     5dc:	13011364 	movwne	r1, #4964	; 0x1364
     5e0:	2e160000 	cdpcs	0, 1, cr0, cr6, cr0, {0}
     5e4:	03193f01 	tsteq	r9, #1, 30
     5e8:	3b0b3a0e 	blcc	2cee28 <__bss_end+0x2c2d30>
     5ec:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
     5f0:	3c0b320e 	sfmcc	f3, 4, [fp], {14}
     5f4:	00136419 	andseq	r6, r3, r9, lsl r4
     5f8:	01011700 	tsteq	r1, r0, lsl #14
     5fc:	13011349 	movwne	r1, #4937	; 0x1349
     600:	21180000 	tstcs	r8, r0
     604:	2f134900 	svccs	0x00134900
     608:	1900000b 	stmdbne	r0, {r0, r1, r3}
     60c:	0e030113 	mcreq	1, 0, r0, cr3, cr3, {0}
     610:	0b3a0b0b 	bleq	e83244 <__bss_end+0xe7714c>
     614:	0b390b3b 	bleq	e43308 <__bss_end+0xe37210>
     618:	00001301 	andeq	r1, r0, r1, lsl #6
     61c:	03000d1a 	movweq	r0, #3354	; 0xd1a
     620:	3b0b3a0e 	blcc	2cee60 <__bss_end+0x2c2d68>
     624:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     628:	3c193f13 	ldccc	15, cr3, [r9], {19}
     62c:	6c0a1c19 	stcvs	12, cr1, [sl], {25}
     630:	1b000019 	blne	69c <shift+0x69c>
     634:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
     638:	0b3a0803 	bleq	e8264c <__bss_end+0xe76554>
     63c:	0b390b3b 	bleq	e43330 <__bss_end+0xe37238>
     640:	0b320e6e 	bleq	c84000 <__bss_end+0xc77f08>
     644:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
     648:	2e1c0000 	cdpcs	0, 1, cr0, cr12, cr0, {0}
     64c:	3a134701 	bcc	4d2258 <__bss_end+0x4c6160>
     650:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
     654:	1113640b 	tstne	r3, fp, lsl #8
     658:	40061201 	andmi	r1, r6, r1, lsl #4
     65c:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
     660:	00001301 	andeq	r1, r0, r1, lsl #6
     664:	0300051d 	movweq	r0, #1309	; 0x51d
     668:	3413490e 	ldrcc	r4, [r3], #-2318	; 0xfffff6f2
     66c:	00180219 	andseq	r0, r8, r9, lsl r2
     670:	00341e00 	eorseq	r1, r4, r0, lsl #28
     674:	0b3a0e03 	bleq	e83e88 <__bss_end+0xe77d90>
     678:	0b39053b 	bleq	e41b6c <__bss_end+0xe35a74>
     67c:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
     680:	0b1f0000 	bleq	7c0688 <__bss_end+0x7b4590>
     684:	12011101 	andne	r1, r1, #1073741824	; 0x40000000
     688:	20000006 	andcs	r0, r0, r6
     68c:	08030034 	stmdaeq	r3, {r2, r4, r5}
     690:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
     694:	13490b39 	movtne	r0, #39737	; 0x9b39
     698:	00001802 	andeq	r1, r0, r2, lsl #16
     69c:	11010b21 	tstne	r1, r1, lsr #22
     6a0:	01061201 	tsteq	r6, r1, lsl #4
     6a4:	22000013 	andcs	r0, r0, #19
     6a8:	1347012e 	movtne	r0, #28974	; 0x712e
     6ac:	0b3b0b3a 	bleq	ec339c <__bss_end+0xeb72a4>
     6b0:	13640b39 	cmnne	r4, #58368	; 0xe400
     6b4:	06120111 			; <UNDEFINED> instruction: 0x06120111
     6b8:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
     6bc:	00130119 	andseq	r0, r3, r9, lsl r1
     6c0:	00052300 	andeq	r2, r5, r0, lsl #6
     6c4:	0b3a0e03 	bleq	e83ed8 <__bss_end+0xe77de0>
     6c8:	0b390b3b 	bleq	e433bc <__bss_end+0xe372c4>
     6cc:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
     6d0:	34240000 	strtcc	r0, [r4], #-0
     6d4:	3a0e0300 	bcc	3812dc <__bss_end+0x3751e4>
     6d8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     6dc:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
     6e0:	25000018 	strcs	r0, [r0, #-24]	; 0xffffffe8
     6e4:	08030034 	stmdaeq	r3, {r2, r4, r5}
     6e8:	0b3b0b3a 	bleq	ec33d8 <__bss_end+0xeb72e0>
     6ec:	13490b39 	movtne	r0, #39737	; 0x9b39
     6f0:	00001802 	andeq	r1, r0, r2, lsl #16
     6f4:	03000526 	movweq	r0, #1318	; 0x526
     6f8:	3b0b3a08 	blcc	2cef20 <__bss_end+0x2c2e28>
     6fc:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     700:	00180213 	andseq	r0, r8, r3, lsl r2
     704:	012e2700 			; <UNDEFINED> instruction: 0x012e2700
     708:	0b3a1347 	bleq	e8542c <__bss_end+0xe79334>
     70c:	0b390b3b 	bleq	e43400 <__bss_end+0xe37308>
     710:	01111364 	tsteq	r1, r4, ror #6
     714:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
     718:	01194297 			; <UNDEFINED> instruction: 0x01194297
     71c:	28000013 	stmdacs	r0, {r0, r1, r4}
     720:	1755010b 	ldrbne	r0, [r5, -fp, lsl #2]
     724:	2e290000 	cdpcs	0, 2, cr0, cr9, cr0, {0}
     728:	3a134701 	bcc	4d2334 <__bss_end+0x4c623c>
     72c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     730:	2013640b 	andscs	r6, r3, fp, lsl #8
     734:	0013010b 	andseq	r0, r3, fp, lsl #2
     738:	00052a00 	andeq	r2, r5, r0, lsl #20
     73c:	13490e03 	movtne	r0, #40451	; 0x9e03
     740:	00001934 	andeq	r1, r0, r4, lsr r9
     744:	0300052b 	movweq	r0, #1323	; 0x52b
     748:	3b0b3a0e 	blcc	2cef88 <__bss_end+0x2c2e90>
     74c:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     750:	2c000013 	stccs	0, cr0, [r0], {19}
     754:	1331012e 	teqne	r1, #-2147483637	; 0x8000000b
     758:	13640e6e 	cmnne	r4, #1760	; 0x6e0
     75c:	06120111 			; <UNDEFINED> instruction: 0x06120111
     760:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
     764:	00130119 	andseq	r0, r3, r9, lsl r1
     768:	00052d00 	andeq	r2, r5, r0, lsl #26
     76c:	18021331 	stmdane	r2, {r0, r4, r5, r8, r9, ip}
     770:	2e2e0000 	cdpcs	0, 2, cr0, cr14, cr0, {0}
     774:	03193f01 	tsteq	r9, #1, 30
     778:	3b0b3a0e 	blcc	2cefb8 <__bss_end+0x2c2ec0>
     77c:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
     780:	1113490e 	tstne	r3, lr, lsl #18
     784:	40061201 	andmi	r1, r6, r1, lsl #4
     788:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
     78c:	00001301 	andeq	r1, r0, r1, lsl #6
     790:	3f012e2f 	svccc	0x00012e2f
     794:	3a0e0319 	bcc	381400 <__bss_end+0x375308>
     798:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     79c:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
     7a0:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
     7a4:	96184006 	ldrls	r4, [r8], -r6
     7a8:	00001942 	andeq	r1, r0, r2, asr #18
     7ac:	01110100 	tsteq	r1, r0, lsl #2
     7b0:	0b130e25 	bleq	4c404c <__bss_end+0x4b7f54>
     7b4:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
     7b8:	06120111 			; <UNDEFINED> instruction: 0x06120111
     7bc:	00001710 	andeq	r1, r0, r0, lsl r7
     7c0:	0b002402 	bleq	97d0 <_ZN5Model3RunEv+0x18c>
     7c4:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
     7c8:	03000008 	movweq	r0, #8
     7cc:	0b0b0024 	bleq	2c0864 <__bss_end+0x2b476c>
     7d0:	0e030b3e 	vmoveq.16	d3[0], r0
     7d4:	16040000 	strne	r0, [r4], -r0
     7d8:	3a0e0300 	bcc	3813e0 <__bss_end+0x3752e8>
     7dc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     7e0:	0013490b 	andseq	r4, r3, fp, lsl #18
     7e4:	00260500 	eoreq	r0, r6, r0, lsl #10
     7e8:	00001349 	andeq	r1, r0, r9, asr #6
     7ec:	03003406 	movweq	r3, #1030	; 0x406
     7f0:	3b0b3a0e 	blcc	2cf030 <__bss_end+0x2c2f38>
     7f4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     7f8:	02196c13 	andseq	r6, r9, #4864	; 0x1300
     7fc:	07000018 	smladeq	r0, r8, r0, r0
     800:	0e030113 	mcreq	1, 0, r0, cr3, cr3, {0}
     804:	0b3a0b0b 	bleq	e83438 <__bss_end+0xe77340>
     808:	0b390b3b 	bleq	e434fc <__bss_end+0xe37404>
     80c:	00001301 	andeq	r1, r0, r1, lsl #6
     810:	03000d08 	movweq	r0, #3336	; 0xd08
     814:	3b0b3a0e 	blcc	2cf054 <__bss_end+0x2c2f5c>
     818:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     81c:	000b3813 	andeq	r3, fp, r3, lsl r8
     820:	01010900 	tsteq	r1, r0, lsl #18
     824:	13011349 	movwne	r1, #4937	; 0x1349
     828:	210a0000 	mrscs	r0, (UNDEF: 10)
     82c:	2f134900 	svccs	0x00134900
     830:	0b00000b 	bleq	864 <shift+0x864>
     834:	0b0b000f 	bleq	2c0878 <__bss_end+0x2b4780>
     838:	00001349 	andeq	r1, r0, r9, asr #6
     83c:	3f012e0c 	svccc	0x00012e0c
     840:	3a0e0319 	bcc	3814ac <__bss_end+0x3753b4>
     844:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     848:	110e6e0b 	tstne	lr, fp, lsl #28
     84c:	40061201 	andmi	r1, r6, r1, lsl #4
     850:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
     854:	00001301 	andeq	r1, r0, r1, lsl #6
     858:	0300050d 	movweq	r0, #1293	; 0x50d
     85c:	3b0b3a0e 	blcc	2cf09c <__bss_end+0x2c2fa4>
     860:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     864:	00180213 	andseq	r0, r8, r3, lsl r2
     868:	00050e00 	andeq	r0, r5, r0, lsl #28
     86c:	0b3a0803 	bleq	e82880 <__bss_end+0xe76788>
     870:	0b390b3b 	bleq	e43564 <__bss_end+0xe3746c>
     874:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
     878:	340f0000 	strcc	r0, [pc], #-0	; 880 <shift+0x880>
     87c:	3a0e0300 	bcc	381484 <__bss_end+0x37538c>
     880:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     884:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
     888:	10000018 	andne	r0, r0, r8, lsl r0
     88c:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
     890:	0b3a0e03 	bleq	e840a4 <__bss_end+0xe77fac>
     894:	0b390b3b 	bleq	e43588 <__bss_end+0xe37490>
     898:	13490e6e 	movtne	r0, #40558	; 0x9e6e
     89c:	06120111 			; <UNDEFINED> instruction: 0x06120111
     8a0:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
     8a4:	00000019 	andeq	r0, r0, r9, lsl r0
     8a8:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
     8ac:	030b130e 	movweq	r1, #45838	; 0xb30e
     8b0:	110e1b0e 	tstne	lr, lr, lsl #22
     8b4:	10061201 	andne	r1, r6, r1, lsl #4
     8b8:	02000017 	andeq	r0, r0, #23
     8bc:	0b0b0024 	bleq	2c0954 <__bss_end+0x2b485c>
     8c0:	0e030b3e 	vmoveq.16	d3[0], r0
     8c4:	24030000 	strcs	r0, [r3], #-0
     8c8:	3e0b0b00 	vmlacc.f64	d0, d11, d0
     8cc:	0008030b 	andeq	r0, r8, fp, lsl #6
     8d0:	00160400 	andseq	r0, r6, r0, lsl #8
     8d4:	0b3a0e03 	bleq	e840e8 <__bss_end+0xe77ff0>
     8d8:	0b390b3b 	bleq	e435cc <__bss_end+0xe374d4>
     8dc:	00001349 	andeq	r1, r0, r9, asr #6
     8e0:	03010205 	movweq	r0, #4613	; 0x1205
     8e4:	3a0b0b0e 	bcc	2c3524 <__bss_end+0x2b742c>
     8e8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     8ec:	0013010b 	andseq	r0, r3, fp, lsl #2
     8f0:	000d0600 	andeq	r0, sp, r0, lsl #12
     8f4:	0b3a0e03 	bleq	e84108 <__bss_end+0xe78010>
     8f8:	0b390b3b 	bleq	e435ec <__bss_end+0xe374f4>
     8fc:	0b381349 	bleq	e05628 <__bss_end+0xdf9530>
     900:	2e070000 	cdpcs	0, 0, cr0, cr7, cr0, {0}
     904:	03193f01 	tsteq	r9, #1, 30
     908:	3b0b3a0e 	blcc	2cf148 <__bss_end+0x2c3050>
     90c:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
     910:	3213490e 	andscc	r4, r3, #229376	; 0x38000
     914:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
     918:	00130113 	andseq	r0, r3, r3, lsl r1
     91c:	00050800 	andeq	r0, r5, r0, lsl #16
     920:	19341349 	ldmdbne	r4!, {r0, r3, r6, r8, r9, ip}
     924:	2e090000 	cdpcs	0, 0, cr0, cr9, cr0, {0}
     928:	03193f01 	tsteq	r9, #1, 30
     92c:	3b0b3a0e 	blcc	2cf16c <__bss_end+0x2c3074>
     930:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
     934:	3c0b320e 	sfmcc	f3, 4, [fp], {14}
     938:	01136419 	tsteq	r3, r9, lsl r4
     93c:	0a000013 	beq	990 <shift+0x990>
     940:	13490005 	movtne	r0, #36869	; 0x9005
     944:	2e0b0000 	cdpcs	0, 0, cr0, cr11, cr0, {0}
     948:	03193f01 	tsteq	r9, #1, 30
     94c:	3b0b3a0e 	blcc	2cf18c <__bss_end+0x2c3094>
     950:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
     954:	3213490e 	andscc	r4, r3, #229376	; 0x38000
     958:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
     95c:	0c000013 	stceq	0, cr0, [r0], {19}
     960:	0b0b000f 	bleq	2c09a4 <__bss_end+0x2b48ac>
     964:	00001349 	andeq	r1, r0, r9, asr #6
     968:	4900260d 	stmdbmi	r0, {r0, r2, r3, r9, sl, sp}
     96c:	0e000013 	mcreq	0, 0, r0, cr0, cr3, {0}
     970:	0b0b000f 	bleq	2c09b4 <__bss_end+0x2b48bc>
     974:	340f0000 	strcc	r0, [pc], #-0	; 97c <shift+0x97c>
     978:	3a080300 	bcc	201580 <__bss_end+0x1f5488>
     97c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     980:	3f13490b 	svccc	0x0013490b
     984:	00193c19 	andseq	r3, r9, r9, lsl ip
     988:	00341000 	eorseq	r1, r4, r0
     98c:	0b3a1347 	bleq	e856b0 <__bss_end+0xe795b8>
     990:	0b390b3b 	bleq	e43684 <__bss_end+0xe3758c>
     994:	00001802 	andeq	r1, r0, r2, lsl #16
     998:	03002e11 	movweq	r2, #3601	; 0xe11
     99c:	1119340e 	tstne	r9, lr, lsl #8
     9a0:	40061201 	andmi	r1, r6, r1, lsl #4
     9a4:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
     9a8:	2e120000 	cdpcs	0, 1, cr0, cr2, cr0, {0}
     9ac:	340e0301 	strcc	r0, [lr], #-769	; 0xfffffcff
     9b0:	12011119 	andne	r1, r1, #1073741830	; 0x40000006
     9b4:	96184006 	ldrls	r4, [r8], -r6
     9b8:	13011942 	movwne	r1, #6466	; 0x1942
     9bc:	05130000 	ldreq	r0, [r3, #-0]
     9c0:	3a0e0300 	bcc	3815c8 <__bss_end+0x3754d0>
     9c4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     9c8:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
     9cc:	14000018 	strne	r0, [r0], #-24	; 0xffffffe8
     9d0:	1347012e 	movtne	r0, #28974	; 0x712e
     9d4:	0b3b0b3a 	bleq	ec36c4 <__bss_end+0xeb75cc>
     9d8:	13490b39 	movtne	r0, #39737	; 0x9b39
     9dc:	01111364 	tsteq	r1, r4, ror #6
     9e0:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
     9e4:	01194296 			; <UNDEFINED> instruction: 0x01194296
     9e8:	15000013 	strne	r0, [r0, #-19]	; 0xffffffed
     9ec:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
     9f0:	19341349 	ldmdbne	r4!, {r0, r3, r6, r8, r9, ip}
     9f4:	00001802 	andeq	r1, r0, r2, lsl #16
     9f8:	03003416 	movweq	r3, #1046	; 0x416
     9fc:	3b0b3a0e 	blcc	2cf23c <__bss_end+0x2c3144>
     a00:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     a04:	00180213 	andseq	r0, r8, r3, lsl r2
     a08:	012e1700 			; <UNDEFINED> instruction: 0x012e1700
     a0c:	0b3a1347 	bleq	e85730 <__bss_end+0xe79638>
     a10:	0b390b3b 	bleq	e43704 <__bss_end+0xe3760c>
     a14:	01111364 	tsteq	r1, r4, ror #6
     a18:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
     a1c:	01194297 			; <UNDEFINED> instruction: 0x01194297
     a20:	18000013 	stmdane	r0, {r0, r1, r4}
     a24:	1347012e 	movtne	r0, #28974	; 0x712e
     a28:	0b3b0b3a 	bleq	ec3718 <__bss_end+0xeb7620>
     a2c:	13640b39 	cmnne	r4, #58368	; 0xe400
     a30:	13010b20 	movwne	r0, #6944	; 0x1b20
     a34:	05190000 	ldreq	r0, [r9, #-0]
     a38:	490e0300 	stmdbmi	lr, {r8, r9}
     a3c:	00193413 	andseq	r3, r9, r3, lsl r4
     a40:	012e1a00 			; <UNDEFINED> instruction: 0x012e1a00
     a44:	0e6e1331 	mcreq	3, 3, r1, cr14, cr1, {1}
     a48:	01111364 	tsteq	r1, r4, ror #6
     a4c:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
     a50:	00194297 	mulseq	r9, r7, r2
     a54:	00051b00 	andeq	r1, r5, r0, lsl #22
     a58:	18021331 	stmdane	r2, {r0, r4, r5, r8, r9, ip}
     a5c:	01000000 	mrseq	r0, (UNDEF: 0)
     a60:	0e250111 	mcreq	1, 1, r0, cr5, cr1, {0}
     a64:	0e030b13 	vmoveq.32	d3[0], r0
     a68:	01110e1b 	tsteq	r1, fp, lsl lr
     a6c:	17100612 			; <UNDEFINED> instruction: 0x17100612
     a70:	02020000 	andeq	r0, r2, #0
     a74:	0b0e0301 	bleq	381680 <__bss_end+0x375588>
     a78:	3b0b3a0b 	blcc	2cf2ac <__bss_end+0x2c31b4>
     a7c:	010b390b 	tsteq	fp, fp, lsl #18
     a80:	03000013 	movweq	r0, #19
     a84:	0803000d 	stmdaeq	r3, {r0, r2, r3}
     a88:	0b3b0b3a 	bleq	ec3778 <__bss_end+0xeb7680>
     a8c:	13490b39 	movtne	r0, #39737	; 0x9b39
     a90:	00000b38 	andeq	r0, r0, r8, lsr fp
     a94:	03000d04 	movweq	r0, #3332	; 0xd04
     a98:	3b0b3a0e 	blcc	2cf2d8 <__bss_end+0x2c31e0>
     a9c:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     aa0:	000b3813 	andeq	r3, fp, r3, lsl r8
     aa4:	012e0500 			; <UNDEFINED> instruction: 0x012e0500
     aa8:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
     aac:	0b3b0b3a 	bleq	ec379c <__bss_end+0xeb76a4>
     ab0:	0e6e0b39 	vmoveq.8	d14[5], r0
     ab4:	0b321349 	bleq	c857e0 <__bss_end+0xc796e8>
     ab8:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
     abc:	00001301 	andeq	r1, r0, r1, lsl #6
     ac0:	49000506 	stmdbmi	r0, {r1, r2, r8, sl}
     ac4:	00193413 	andseq	r3, r9, r3, lsl r4
     ac8:	00050700 	andeq	r0, r5, r0, lsl #14
     acc:	00001349 	andeq	r1, r0, r9, asr #6
     ad0:	3f012e08 	svccc	0x00012e08
     ad4:	3a0e0319 	bcc	381740 <__bss_end+0x375648>
     ad8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     adc:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
     ae0:	3c0b3213 	sfmcc	f3, 4, [fp], {19}
     ae4:	00136419 	andseq	r6, r3, r9, lsl r4
     ae8:	00240900 	eoreq	r0, r4, r0, lsl #18
     aec:	0b3e0b0b 	bleq	f83720 <__bss_end+0xf77628>
     af0:	00000803 	andeq	r0, r0, r3, lsl #16
     af4:	0b000f0a 	bleq	4724 <shift+0x4724>
     af8:	0013490b 	andseq	r4, r3, fp, lsl #18
     afc:	00260b00 	eoreq	r0, r6, r0, lsl #22
     b00:	00001349 	andeq	r1, r0, r9, asr #6
     b04:	0b00240c 	bleq	9b3c <_Z5splitPP9Tribesmanii+0x1b8>
     b08:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
     b0c:	0d00000e 	stceq	0, cr0, [r0, #-56]	; 0xffffffc8
     b10:	1347012e 	movtne	r0, #28974	; 0x712e
     b14:	0b3b0b3a 	bleq	ec3804 <__bss_end+0xeb770c>
     b18:	13640b39 	cmnne	r4, #58368	; 0xe400
     b1c:	06120111 			; <UNDEFINED> instruction: 0x06120111
     b20:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
     b24:	00130119 	andseq	r0, r3, r9, lsl r1
     b28:	00050e00 	andeq	r0, r5, r0, lsl #28
     b2c:	13490e03 	movtne	r0, #40451	; 0x9e03
     b30:	18021934 	stmdane	r2, {r2, r4, r5, r8, fp, ip}
     b34:	340f0000 	strcc	r0, [pc], #-0	; b3c <shift+0xb3c>
     b38:	3a0e0300 	bcc	381740 <__bss_end+0x375648>
     b3c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     b40:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
     b44:	10000018 	andne	r0, r0, r8, lsl r0
     b48:	08030034 	stmdaeq	r3, {r2, r4, r5}
     b4c:	0b3b0b3a 	bleq	ec383c <__bss_end+0xeb7744>
     b50:	13490b39 	movtne	r0, #39737	; 0x9b39
     b54:	00001802 	andeq	r1, r0, r2, lsl #16
     b58:	47012e11 	smladmi	r1, r1, lr, r2
     b5c:	3b0b3a13 	blcc	2cf3b0 <__bss_end+0x2c32b8>
     b60:	640b390b 	strvs	r3, [fp], #-2315	; 0xfffff6f5
     b64:	010b2013 	tsteq	fp, r3, lsl r0
     b68:	12000013 	andne	r0, r0, #19
     b6c:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
     b70:	19341349 	ldmdbne	r4!, {r0, r3, r6, r8, r9, ip}
     b74:	05130000 	ldreq	r0, [r3, #-0]
     b78:	3a080300 	bcc	201780 <__bss_end+0x1f5688>
     b7c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     b80:	0013490b 	andseq	r4, r3, fp, lsl #18
     b84:	00051400 	andeq	r1, r5, r0, lsl #8
     b88:	0b3a0e03 	bleq	e8439c <__bss_end+0xe782a4>
     b8c:	0b390b3b 	bleq	e43880 <__bss_end+0xe37788>
     b90:	00001349 	andeq	r1, r0, r9, asr #6
     b94:	31012e15 	tstcc	r1, r5, lsl lr
     b98:	640e6e13 	strvs	r6, [lr], #-3603	; 0xfffff1ed
     b9c:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
     ba0:	97184006 	ldrls	r4, [r8, -r6]
     ba4:	00001942 	andeq	r1, r0, r2, asr #18
     ba8:	31000516 	tstcc	r0, r6, lsl r5
     bac:	00180213 	andseq	r0, r8, r3, lsl r2
     bb0:	11010000 	mrsne	r0, (UNDEF: 1)
     bb4:	130e2501 	movwne	r2, #58625	; 0xe501
     bb8:	1b0e030b 	blne	3817ec <__bss_end+0x3756f4>
     bbc:	1117550e 	tstne	r7, lr, lsl #10
     bc0:	00171001 	andseq	r1, r7, r1
     bc4:	00240200 	eoreq	r0, r4, r0, lsl #4
     bc8:	0b3e0b0b 	bleq	f837fc <__bss_end+0xf77704>
     bcc:	00000e03 	andeq	r0, r0, r3, lsl #28
     bd0:	49002603 	stmdbmi	r0, {r0, r1, r9, sl, sp}
     bd4:	04000013 	streq	r0, [r0], #-19	; 0xffffffed
     bd8:	0b0b0024 	bleq	2c0c70 <__bss_end+0x2b4b78>
     bdc:	08030b3e 	stmdaeq	r3, {r1, r2, r3, r4, r5, r8, r9, fp}
     be0:	16050000 	strne	r0, [r5], -r0
     be4:	3a0e0300 	bcc	3817ec <__bss_end+0x3756f4>
     be8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     bec:	0013490b 	andseq	r4, r3, fp, lsl #18
     bf0:	00340600 	eorseq	r0, r4, r0, lsl #12
     bf4:	0b3a0e03 	bleq	e84408 <__bss_end+0xe78310>
     bf8:	0b390b3b 	bleq	e438ec <__bss_end+0xe377f4>
     bfc:	196c1349 	stmdbne	ip!, {r0, r3, r6, r8, r9, ip}^
     c00:	00001802 	andeq	r1, r0, r2, lsl #16
     c04:	0b000f07 	bleq	4828 <shift+0x4828>
     c08:	0013490b 	andseq	r4, r3, fp, lsl #18
     c0c:	000f0800 	andeq	r0, pc, r0, lsl #16
     c10:	00000b0b 	andeq	r0, r0, fp, lsl #22
     c14:	03010209 	movweq	r0, #4617	; 0x1209
     c18:	3a0b0b0e 	bcc	2c3858 <__bss_end+0x2b7760>
     c1c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     c20:	0013010b 	andseq	r0, r3, fp, lsl #2
     c24:	000d0a00 	andeq	r0, sp, r0, lsl #20
     c28:	0b3a0e03 	bleq	e8443c <__bss_end+0xe78344>
     c2c:	0b390b3b 	bleq	e43920 <__bss_end+0xe37828>
     c30:	0b381349 	bleq	e0595c <__bss_end+0xdf9864>
     c34:	2e0b0000 	cdpcs	0, 0, cr0, cr11, cr0, {0}
     c38:	03193f01 	tsteq	r9, #1, 30
     c3c:	3b0b3a0e 	blcc	2cf47c <__bss_end+0x2c3384>
     c40:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
     c44:	3213490e 	andscc	r4, r3, #229376	; 0x38000
     c48:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
     c4c:	00130113 	andseq	r0, r3, r3, lsl r1
     c50:	00050c00 	andeq	r0, r5, r0, lsl #24
     c54:	19341349 	ldmdbne	r4!, {r0, r3, r6, r8, r9, ip}
     c58:	2e0d0000 	cdpcs	0, 0, cr0, cr13, cr0, {0}
     c5c:	03193f01 	tsteq	r9, #1, 30
     c60:	3b0b3a0e 	blcc	2cf4a0 <__bss_end+0x2c33a8>
     c64:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
     c68:	3c0b320e 	sfmcc	f3, 4, [fp], {14}
     c6c:	01136419 	tsteq	r3, r9, lsl r4
     c70:	0e000013 	mcreq	0, 0, r0, cr0, cr3, {0}
     c74:	13490005 	movtne	r0, #36869	; 0x9005
     c78:	2e0f0000 	cdpcs	0, 0, cr0, cr15, cr0, {0}
     c7c:	03193f01 	tsteq	r9, #1, 30
     c80:	3b0b3a0e 	blcc	2cf4c0 <__bss_end+0x2c33c8>
     c84:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
     c88:	3213490e 	andscc	r4, r3, #229376	; 0x38000
     c8c:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
     c90:	10000013 	andne	r0, r0, r3, lsl r0
     c94:	08030034 	stmdaeq	r3, {r2, r4, r5}
     c98:	0b3b0b3a 	bleq	ec3988 <__bss_end+0xeb7890>
     c9c:	13490b39 	movtne	r0, #39737	; 0x9b39
     ca0:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
     ca4:	02110000 	andseq	r0, r1, #0
     ca8:	0b0e0301 	bleq	3818b4 <__bss_end+0x3757bc>
     cac:	3b0b3a05 	blcc	2cf4c8 <__bss_end+0x2c33d0>
     cb0:	010b390b 	tsteq	fp, fp, lsl #18
     cb4:	12000013 	andne	r0, r0, #19
     cb8:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
     cbc:	0b3b0b3a 	bleq	ec39ac <__bss_end+0xeb78b4>
     cc0:	13490b39 	movtne	r0, #39737	; 0x9b39
     cc4:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
     cc8:	00000b1c 	andeq	r0, r0, ip, lsl fp
     ccc:	3f012e13 	svccc	0x00012e13
     cd0:	3a0e0319 	bcc	38193c <__bss_end+0x375844>
     cd4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     cd8:	3c0e6e0b 	stccc	14, cr6, [lr], {11}
     cdc:	01136419 	tsteq	r3, r9, lsl r4
     ce0:	14000013 	strne	r0, [r0], #-19	; 0xffffffed
     ce4:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
     ce8:	0b3a0e03 	bleq	e844fc <__bss_end+0xe78404>
     cec:	0b390b3b 	bleq	e439e0 <__bss_end+0xe378e8>
     cf0:	13490e6e 	movtne	r0, #40558	; 0x9e6e
     cf4:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
     cf8:	00001301 	andeq	r1, r0, r1, lsl #6
     cfc:	3f012e15 	svccc	0x00012e15
     d00:	3a0e0319 	bcc	38196c <__bss_end+0x375874>
     d04:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     d08:	320e6e0b 	andcc	r6, lr, #11, 28	; 0xb0
     d0c:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
     d10:	16000013 			; <UNDEFINED> instruction: 0x16000013
     d14:	13490101 	movtne	r0, #37121	; 0x9101
     d18:	00001301 	andeq	r1, r0, r1, lsl #6
     d1c:	49002117 	stmdbmi	r0, {r0, r1, r2, r4, r8, sp}
     d20:	000b2f13 	andeq	r2, fp, r3, lsl pc
     d24:	012e1800 			; <UNDEFINED> instruction: 0x012e1800
     d28:	0b3a1347 	bleq	e85a4c <__bss_end+0xe79954>
     d2c:	0b390b3b 	bleq	e43a20 <__bss_end+0xe37928>
     d30:	01111364 	tsteq	r1, r4, ror #6
     d34:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
     d38:	01194296 			; <UNDEFINED> instruction: 0x01194296
     d3c:	19000013 	stmdbne	r0, {r0, r1, r4}
     d40:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
     d44:	19341349 	ldmdbne	r4!, {r0, r3, r6, r8, r9, ip}
     d48:	00001802 	andeq	r1, r0, r2, lsl #16
     d4c:	0300051a 	movweq	r0, #1306	; 0x51a
     d50:	3b0b3a0e 	blcc	2cf590 <__bss_end+0x2c3498>
     d54:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     d58:	00180213 	andseq	r0, r8, r3, lsl r2
     d5c:	00341b00 	eorseq	r1, r4, r0, lsl #22
     d60:	0b3a0e03 	bleq	e84574 <__bss_end+0xe7847c>
     d64:	0b390b3b 	bleq	e43a58 <__bss_end+0xe37960>
     d68:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
     d6c:	0b1c0000 	bleq	700d74 <__bss_end+0x6f4c7c>
     d70:	00175501 	andseq	r5, r7, r1, lsl #10
     d74:	00051d00 	andeq	r1, r5, r0, lsl #26
     d78:	0b3a0803 	bleq	e82d8c <__bss_end+0xe76c94>
     d7c:	0b390b3b 	bleq	e43a70 <__bss_end+0xe37978>
     d80:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
     d84:	0b1e0000 	bleq	780d8c <__bss_end+0x774c94>
     d88:	12011101 	andne	r1, r1, #1073741824	; 0x40000000
     d8c:	1f000006 	svcne	0x00000006
     d90:	08030034 	stmdaeq	r3, {r2, r4, r5}
     d94:	0b3b0b3a 	bleq	ec3a84 <__bss_end+0xeb798c>
     d98:	13490b39 	movtne	r0, #39737	; 0x9b39
     d9c:	00001802 	andeq	r1, r0, r2, lsl #16
     da0:	47012e20 	strmi	r2, [r1, -r0, lsr #28]
     da4:	390b3a13 	stmdbcc	fp, {r0, r1, r4, r9, fp, ip, sp}
     da8:	1113640b 	tstne	r3, fp, lsl #8
     dac:	40061201 	andmi	r1, r6, r1, lsl #4
     db0:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
     db4:	00001301 	andeq	r1, r0, r1, lsl #6
     db8:	47012e21 	strmi	r2, [r1, -r1, lsr #28]
     dbc:	3b0b3a13 	blcc	2cf610 <__bss_end+0x2c3518>
     dc0:	640b390b 	strvs	r3, [fp], #-2315	; 0xfffff6f5
     dc4:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
     dc8:	97184006 	ldrls	r4, [r8, -r6]
     dcc:	13011942 	movwne	r1, #6466	; 0x1942
     dd0:	2e220000 	cdpcs	0, 2, cr0, cr2, cr0, {0}
     dd4:	3a134701 	bcc	4d29e0 <__bss_end+0x4c68e8>
     dd8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     ddc:	2013640b 	andscs	r6, r3, fp, lsl #8
     de0:	0013010b 	andseq	r0, r3, fp, lsl #2
     de4:	00052300 	andeq	r2, r5, r0, lsl #6
     de8:	13490e03 	movtne	r0, #40451	; 0x9e03
     dec:	00001934 	andeq	r1, r0, r4, lsr r9
     df0:	03000524 	movweq	r0, #1316	; 0x524
     df4:	3b0b3a0e 	blcc	2cf634 <__bss_end+0x2c353c>
     df8:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     dfc:	25000013 	strcs	r0, [r0, #-19]	; 0xffffffed
     e00:	1331012e 	teqne	r1, #-2147483637	; 0x8000000b
     e04:	13640e6e 	cmnne	r4, #1760	; 0x6e0
     e08:	06120111 			; <UNDEFINED> instruction: 0x06120111
     e0c:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
     e10:	00130119 	andseq	r0, r3, r9, lsl r1
     e14:	00052600 	andeq	r2, r5, r0, lsl #12
     e18:	18021331 	stmdane	r2, {r0, r4, r5, r8, r9, ip}
     e1c:	2e270000 	cdpcs	0, 2, cr0, cr7, cr0, {0}
     e20:	03193f01 	tsteq	r9, #1, 30
     e24:	3b0b3a0e 	blcc	2cf664 <__bss_end+0x2c356c>
     e28:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
     e2c:	1113490e 	tstne	r3, lr, lsl #18
     e30:	40061201 	andmi	r1, r6, r1, lsl #4
     e34:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
     e38:	01000000 	mrseq	r0, (UNDEF: 0)
     e3c:	0e250111 	mcreq	1, 1, r0, cr5, cr1, {0}
     e40:	0e030b13 	vmoveq.32	d3[0], r0
     e44:	01110e1b 	tsteq	r1, fp, lsl lr
     e48:	17100612 			; <UNDEFINED> instruction: 0x17100612
     e4c:	24020000 	strcs	r0, [r2], #-0
     e50:	3e0b0b00 	vmlacc.f64	d0, d11, d0
     e54:	000e030b 	andeq	r0, lr, fp, lsl #6
     e58:	00260300 	eoreq	r0, r6, r0, lsl #6
     e5c:	00001349 	andeq	r1, r0, r9, asr #6
     e60:	0b002404 	bleq	9e78 <_ZN16Random_Generator7Get_IntEv+0x40>
     e64:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
     e68:	05000008 	streq	r0, [r0, #-8]
     e6c:	0e030016 	mcreq	0, 0, r0, cr3, cr6, {0}
     e70:	0b3b0b3a 	bleq	ec3b60 <__bss_end+0xeb7a68>
     e74:	13490b39 	movtne	r0, #39737	; 0x9b39
     e78:	13060000 	movwne	r0, #24576	; 0x6000
     e7c:	0b0e0301 	bleq	381a88 <__bss_end+0x375990>
     e80:	3b0b3a0b 	blcc	2cf6b4 <__bss_end+0x2c35bc>
     e84:	010b390b 	tsteq	fp, fp, lsl #18
     e88:	07000013 	smladeq	r0, r3, r0, r0
     e8c:	0803000d 	stmdaeq	r3, {r0, r2, r3}
     e90:	0b3b0b3a 	bleq	ec3b80 <__bss_end+0xeb7a88>
     e94:	13490b39 	movtne	r0, #39737	; 0x9b39
     e98:	00000b38 	andeq	r0, r0, r8, lsr fp
     e9c:	03010408 	movweq	r0, #5128	; 0x1408
     ea0:	3e196d0e 	cdpcc	13, 1, cr6, cr9, cr14, {0}
     ea4:	490b0b0b 	stmdbmi	fp, {r0, r1, r3, r8, r9, fp}
     ea8:	3b0b3a13 	blcc	2cf6fc <__bss_end+0x2c3604>
     eac:	010b390b 	tsteq	fp, fp, lsl #18
     eb0:	09000013 	stmdbeq	r0, {r0, r1, r4}
     eb4:	08030028 	stmdaeq	r3, {r3, r5}
     eb8:	00000b1c 	andeq	r0, r0, ip, lsl fp
     ebc:	0300280a 	movweq	r2, #2058	; 0x80a
     ec0:	000b1c0e 	andeq	r1, fp, lr, lsl #24
     ec4:	00340b00 	eorseq	r0, r4, r0, lsl #22
     ec8:	0b3a0e03 	bleq	e846dc <__bss_end+0xe785e4>
     ecc:	0b390b3b 	bleq	e43bc0 <__bss_end+0xe37ac8>
     ed0:	196c1349 	stmdbne	ip!, {r0, r3, r6, r8, r9, ip}^
     ed4:	00001802 	andeq	r1, r0, r2, lsl #16
     ed8:	0300020c 	movweq	r0, #524	; 0x20c
     edc:	00193c0e 	andseq	r3, r9, lr, lsl #24
     ee0:	000f0d00 	andeq	r0, pc, r0, lsl #26
     ee4:	13490b0b 	movtne	r0, #39691	; 0x9b0b
     ee8:	0d0e0000 	stceq	0, cr0, [lr, #-0]
     eec:	3a0e0300 	bcc	381af4 <__bss_end+0x3759fc>
     ef0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     ef4:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
     ef8:	0f00000b 	svceq	0x0000000b
     efc:	13490101 	movtne	r0, #37121	; 0x9101
     f00:	00001301 	andeq	r1, r0, r1, lsl #6
     f04:	49002110 	stmdbmi	r0, {r4, r8, sp}
     f08:	000b2f13 	andeq	r2, fp, r3, lsl pc
     f0c:	01021100 	mrseq	r1, (UNDEF: 18)
     f10:	0b0b0e03 	bleq	2c4724 <__bss_end+0x2b862c>
     f14:	0b3b0b3a 	bleq	ec3c04 <__bss_end+0xeb7b0c>
     f18:	13010b39 	movwne	r0, #6969	; 0x1b39
     f1c:	2e120000 	cdpcs	0, 1, cr0, cr2, cr0, {0}
     f20:	03193f01 	tsteq	r9, #1, 30
     f24:	3b0b3a0e 	blcc	2cf764 <__bss_end+0x2c366c>
     f28:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
     f2c:	64193c0e 	ldrvs	r3, [r9], #-3086	; 0xfffff3f2
     f30:	00130113 	andseq	r0, r3, r3, lsl r1
     f34:	00051300 	andeq	r1, r5, r0, lsl #6
     f38:	19341349 	ldmdbne	r4!, {r0, r3, r6, r8, r9, ip}
     f3c:	05140000 	ldreq	r0, [r4, #-0]
     f40:	00134900 	andseq	r4, r3, r0, lsl #18
     f44:	012e1500 			; <UNDEFINED> instruction: 0x012e1500
     f48:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
     f4c:	0b3b0b3a 	bleq	ec3c3c <__bss_end+0xeb7b44>
     f50:	0e6e0b39 	vmoveq.8	d14[5], r0
     f54:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
     f58:	13011364 	movwne	r1, #4964	; 0x1364
     f5c:	2e160000 	cdpcs	0, 1, cr0, cr6, cr0, {0}
     f60:	03193f01 	tsteq	r9, #1, 30
     f64:	3b0b3a0e 	blcc	2cf7a4 <__bss_end+0x2c36ac>
     f68:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
     f6c:	3213490e 	andscc	r4, r3, #229376	; 0x38000
     f70:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
     f74:	00130113 	andseq	r0, r3, r3, lsl r1
     f78:	000d1700 	andeq	r1, sp, r0, lsl #14
     f7c:	0b3a0e03 	bleq	e84790 <__bss_end+0xe78698>
     f80:	0b390b3b 	bleq	e43c74 <__bss_end+0xe37b7c>
     f84:	0b381349 	bleq	e05cb0 <__bss_end+0xdf9bb8>
     f88:	00000b32 	andeq	r0, r0, r2, lsr fp
     f8c:	3f012e18 	svccc	0x00012e18
     f90:	3a0e0319 	bcc	381bfc <__bss_end+0x375b04>
     f94:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     f98:	320e6e0b 	andcc	r6, lr, #11, 28	; 0xb0
     f9c:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
     fa0:	00130113 	andseq	r0, r3, r3, lsl r1
     fa4:	012e1900 			; <UNDEFINED> instruction: 0x012e1900
     fa8:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
     fac:	0b3b0b3a 	bleq	ec3c9c <__bss_end+0xeb7ba4>
     fb0:	0e6e0b39 	vmoveq.8	d14[5], r0
     fb4:	0b321349 	bleq	c85ce0 <__bss_end+0xc79be8>
     fb8:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
     fbc:	151a0000 	ldrne	r0, [sl, #-0]
     fc0:	64134901 	ldrvs	r4, [r3], #-2305	; 0xfffff6ff
     fc4:	00130113 	andseq	r0, r3, r3, lsl r1
     fc8:	001f1b00 	andseq	r1, pc, r0, lsl #22
     fcc:	1349131d 	movtne	r1, #37661	; 0x931d
     fd0:	101c0000 	andsne	r0, ip, r0
     fd4:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
     fd8:	1d000013 	stcne	0, cr0, [r0, #-76]	; 0xffffffb4
     fdc:	0b0b000f 	bleq	2c1020 <__bss_end+0x2b4f28>
     fe0:	341e0000 	ldrcc	r0, [lr], #-0
     fe4:	3a0e0300 	bcc	381bec <__bss_end+0x375af4>
     fe8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     fec:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
     ff0:	1f000018 	svcne	0x00000018
     ff4:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
     ff8:	0b3a0e03 	bleq	e8480c <__bss_end+0xe78714>
     ffc:	0b390b3b 	bleq	e43cf0 <__bss_end+0xe37bf8>
    1000:	13490e6e 	movtne	r0, #40558	; 0x9e6e
    1004:	06120111 			; <UNDEFINED> instruction: 0x06120111
    1008:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
    100c:	00130119 	andseq	r0, r3, r9, lsl r1
    1010:	00052000 	andeq	r2, r5, r0
    1014:	0b3a0e03 	bleq	e84828 <__bss_end+0xe78730>
    1018:	0b390b3b 	bleq	e43d0c <__bss_end+0xe37c14>
    101c:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
    1020:	2e210000 	cdpcs	0, 2, cr0, cr1, cr0, {0}
    1024:	03193f01 	tsteq	r9, #1, 30
    1028:	3b0b3a0e 	blcc	2cf868 <__bss_end+0x2c3770>
    102c:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
    1030:	1113490e 	tstne	r3, lr, lsl #18
    1034:	40061201 	andmi	r1, r6, r1, lsl #4
    1038:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
    103c:	00001301 	andeq	r1, r0, r1, lsl #6
    1040:	03003422 	movweq	r3, #1058	; 0x422
    1044:	3b0b3a08 	blcc	2cf86c <__bss_end+0x2c3774>
    1048:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
    104c:	00180213 	andseq	r0, r8, r3, lsl r2
    1050:	012e2300 			; <UNDEFINED> instruction: 0x012e2300
    1054:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
    1058:	0b3b0b3a 	bleq	ec3d48 <__bss_end+0xeb7c50>
    105c:	0e6e0b39 	vmoveq.8	d14[5], r0
    1060:	06120111 			; <UNDEFINED> instruction: 0x06120111
    1064:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
    1068:	00130119 	andseq	r0, r3, r9, lsl r1
    106c:	002e2400 	eoreq	r2, lr, r0, lsl #8
    1070:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
    1074:	0b3b0b3a 	bleq	ec3d64 <__bss_end+0xeb7c6c>
    1078:	0e6e0b39 	vmoveq.8	d14[5], r0
    107c:	06120111 			; <UNDEFINED> instruction: 0x06120111
    1080:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
    1084:	25000019 	strcs	r0, [r0, #-25]	; 0xffffffe7
    1088:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
    108c:	0b3a0e03 	bleq	e848a0 <__bss_end+0xe787a8>
    1090:	0b390b3b 	bleq	e43d84 <__bss_end+0xe37c8c>
    1094:	13490e6e 	movtne	r0, #40558	; 0x9e6e
    1098:	06120111 			; <UNDEFINED> instruction: 0x06120111
    109c:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
    10a0:	00000019 	andeq	r0, r0, r9, lsl r0
    10a4:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
    10a8:	030b130e 	movweq	r1, #45838	; 0xb30e
    10ac:	110e1b0e 	tstne	lr, lr, lsl #22
    10b0:	10061201 	andne	r1, r6, r1, lsl #4
    10b4:	02000017 	andeq	r0, r0, #23
    10b8:	13010139 	movwne	r0, #4409	; 0x1139
    10bc:	34030000 	strcc	r0, [r3], #-0
    10c0:	3a0e0300 	bcc	381cc8 <__bss_end+0x375bd0>
    10c4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    10c8:	3c13490b 			; <UNDEFINED> instruction: 0x3c13490b
    10cc:	000a1c19 	andeq	r1, sl, r9, lsl ip
    10d0:	003a0400 	eorseq	r0, sl, r0, lsl #8
    10d4:	0b3b0b3a 	bleq	ec3dc4 <__bss_end+0xeb7ccc>
    10d8:	13180b39 	tstne	r8, #58368	; 0xe400
    10dc:	01050000 	mrseq	r0, (UNDEF: 5)
    10e0:	01134901 	tsteq	r3, r1, lsl #18
    10e4:	06000013 			; <UNDEFINED> instruction: 0x06000013
    10e8:	13490021 	movtne	r0, #36897	; 0x9021
    10ec:	00000b2f 	andeq	r0, r0, pc, lsr #22
    10f0:	49002607 	stmdbmi	r0, {r0, r1, r2, r9, sl, sp}
    10f4:	08000013 	stmdaeq	r0, {r0, r1, r4}
    10f8:	0b0b0024 	bleq	2c1190 <__bss_end+0x2b5098>
    10fc:	0e030b3e 	vmoveq.16	d3[0], r0
    1100:	34090000 	strcc	r0, [r9], #-0
    1104:	00134700 	andseq	r4, r3, r0, lsl #14
    1108:	012e0a00 			; <UNDEFINED> instruction: 0x012e0a00
    110c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
    1110:	0b3b0b3a 	bleq	ec3e00 <__bss_end+0xeb7d08>
    1114:	0e6e0b39 	vmoveq.8	d14[5], r0
    1118:	06120111 			; <UNDEFINED> instruction: 0x06120111
    111c:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
    1120:	00130119 	andseq	r0, r3, r9, lsl r1
    1124:	00050b00 	andeq	r0, r5, r0, lsl #22
    1128:	0b3a0803 	bleq	e8313c <__bss_end+0xe77044>
    112c:	0b390b3b 	bleq	e43e20 <__bss_end+0xe37d28>
    1130:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
    1134:	340c0000 	strcc	r0, [ip], #-0
    1138:	3a0e0300 	bcc	381d40 <__bss_end+0x375c48>
    113c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    1140:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
    1144:	0d000018 	stceq	0, cr0, [r0, #-96]	; 0xffffffa0
    1148:	08030034 	stmdaeq	r3, {r2, r4, r5}
    114c:	0b3b0b3a 	bleq	ec3e3c <__bss_end+0xeb7d44>
    1150:	13490b39 	movtne	r0, #39737	; 0x9b39
    1154:	00001802 	andeq	r1, r0, r2, lsl #16
    1158:	0b000f0e 	bleq	4d98 <shift+0x4d98>
    115c:	0013490b 	andseq	r4, r3, fp, lsl #18
    1160:	012e0f00 			; <UNDEFINED> instruction: 0x012e0f00
    1164:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
    1168:	0b3b0b3a 	bleq	ec3e58 <__bss_end+0xeb7d60>
    116c:	0e6e0b39 	vmoveq.8	d14[5], r0
    1170:	01111349 	tsteq	r1, r9, asr #6
    1174:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
    1178:	01194297 			; <UNDEFINED> instruction: 0x01194297
    117c:	10000013 	andne	r0, r0, r3, lsl r0
    1180:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
    1184:	0b3b0b3a 	bleq	ec3e74 <__bss_end+0xeb7d7c>
    1188:	13490b39 	movtne	r0, #39737	; 0x9b39
    118c:	00001802 	andeq	r1, r0, r2, lsl #16
    1190:	0b002411 	bleq	a1dc <_ZN6Buffer14Read_Uart_LineEv+0x128>
    1194:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
    1198:	12000008 	andne	r0, r0, #8
    119c:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
    11a0:	0b3a0e03 	bleq	e849b4 <__bss_end+0xe788bc>
    11a4:	0b390b3b 	bleq	e43e98 <__bss_end+0xe37da0>
    11a8:	01110e6e 	tsteq	r1, lr, ror #28
    11ac:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
    11b0:	01194297 			; <UNDEFINED> instruction: 0x01194297
    11b4:	13000013 	movwne	r0, #19
    11b8:	0111010b 	tsteq	r1, fp, lsl #2
    11bc:	00000612 	andeq	r0, r0, r2, lsl r6
    11c0:	00002614 	andeq	r2, r0, r4, lsl r6
    11c4:	000f1500 	andeq	r1, pc, r0, lsl #10
    11c8:	00000b0b 	andeq	r0, r0, fp, lsl #22
    11cc:	3f012e16 	svccc	0x00012e16
    11d0:	3a0e0319 	bcc	381e3c <__bss_end+0x375d44>
    11d4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    11d8:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
    11dc:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
    11e0:	96184006 	ldrls	r4, [r8], -r6
    11e4:	13011942 	movwne	r1, #6466	; 0x1942
    11e8:	2e170000 	cdpcs	0, 1, cr0, cr7, cr0, {0}
    11ec:	03193f01 	tsteq	r9, #1, 30
    11f0:	3b0b3a0e 	blcc	2cfa30 <__bss_end+0x2c3938>
    11f4:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
    11f8:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
    11fc:	96184006 	ldrls	r4, [r8], -r6
    1200:	00001942 	andeq	r1, r0, r2, asr #18
    1204:	00110100 	andseq	r0, r1, r0, lsl #2
    1208:	01110610 	tsteq	r1, r0, lsl r6
    120c:	0e030112 	mcreq	1, 0, r0, cr3, cr2, {0}
    1210:	0e250e1b 	mcreq	14, 1, r0, cr5, cr11, {0}
    1214:	00000513 	andeq	r0, r0, r3, lsl r5
    1218:	00110100 	andseq	r0, r1, r0, lsl #2
    121c:	01110610 	tsteq	r1, r0, lsl r6
    1220:	0e030112 	mcreq	1, 0, r0, cr3, cr2, {0}
    1224:	0e250e1b 	mcreq	14, 1, r0, cr5, cr11, {0}
    1228:	00000513 	andeq	r0, r0, r3, lsl r5
    122c:	00110100 	andseq	r0, r1, r0, lsl #2
    1230:	01110610 	tsteq	r1, r0, lsl r6
    1234:	0e030112 	mcreq	1, 0, r0, cr3, cr2, {0}
    1238:	0e250e1b 	mcreq	14, 1, r0, cr5, cr11, {0}
    123c:	00000513 	andeq	r0, r0, r3, lsl r5
    1240:	00110100 	andseq	r0, r1, r0, lsl #2
    1244:	01110610 	tsteq	r1, r0, lsl r6
    1248:	0e030112 	mcreq	1, 0, r0, cr3, cr2, {0}
    124c:	0e250e1b 	mcreq	14, 1, r0, cr5, cr11, {0}
    1250:	00000513 	andeq	r0, r0, r3, lsl r5
    1254:	00110100 	andseq	r0, r1, r0, lsl #2
    1258:	01110610 	tsteq	r1, r0, lsl r6
    125c:	0e030112 	mcreq	1, 0, r0, cr3, cr2, {0}
    1260:	0e250e1b 	mcreq	14, 1, r0, cr5, cr11, {0}
    1264:	00000513 	andeq	r0, r0, r3, lsl r5
    1268:	01110100 	tsteq	r1, r0, lsl #2
    126c:	0b130e25 	bleq	4c4b08 <__bss_end+0x4b8a10>
    1270:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
    1274:	00001710 	andeq	r1, r0, r0, lsl r7
    1278:	0b002402 	bleq	a288 <_ZN6Buffer9Add_BytesEj+0x3c>
    127c:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
    1280:	03000008 	movweq	r0, #8
    1284:	0b0b0024 	bleq	2c131c <__bss_end+0x2b5224>
    1288:	0e030b3e 	vmoveq.16	d3[0], r0
    128c:	04040000 	streq	r0, [r4], #-0
    1290:	3e0e0301 	cdpcc	3, 0, cr0, cr14, cr1, {0}
    1294:	490b0b0b 	stmdbmi	fp, {r0, r1, r3, r8, r9, fp}
    1298:	3b0b3a13 	blcc	2cfaec <__bss_end+0x2c39f4>
    129c:	010b390b 	tsteq	fp, fp, lsl #18
    12a0:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
    12a4:	0e030028 	cdpeq	0, 0, cr0, cr3, cr8, {1}
    12a8:	00000b1c 	andeq	r0, r0, ip, lsl fp
    12ac:	03011306 	movweq	r1, #4870	; 0x1306
    12b0:	3a0b0b0e 	bcc	2c3ef0 <__bss_end+0x2b7df8>
    12b4:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
    12b8:	0013010b 	andseq	r0, r3, fp, lsl #2
    12bc:	000d0700 	andeq	r0, sp, r0, lsl #14
    12c0:	0b3a0e03 	bleq	e84ad4 <__bss_end+0xe789dc>
    12c4:	0b39053b 	bleq	e427b8 <__bss_end+0xe366c0>
    12c8:	0b381349 	bleq	e05ff4 <__bss_end+0xdf9efc>
    12cc:	26080000 	strcs	r0, [r8], -r0
    12d0:	00134900 	andseq	r4, r3, r0, lsl #18
    12d4:	01010900 	tsteq	r1, r0, lsl #18
    12d8:	13011349 	movwne	r1, #4937	; 0x1349
    12dc:	210a0000 	mrscs	r0, (UNDEF: 10)
    12e0:	2f134900 	svccs	0x00134900
    12e4:	0b00000b 	bleq	1318 <shift+0x1318>
    12e8:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
    12ec:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
    12f0:	13490b39 	movtne	r0, #39737	; 0x9b39
    12f4:	00000a1c 	andeq	r0, r0, ip, lsl sl
    12f8:	2700150c 	strcs	r1, [r0, -ip, lsl #10]
    12fc:	0d000019 	stceq	0, cr0, [r0, #-100]	; 0xffffff9c
    1300:	0b0b000f 	bleq	2c1344 <__bss_end+0x2b524c>
    1304:	00001349 	andeq	r1, r0, r9, asr #6
    1308:	0301040e 	movweq	r0, #5134	; 0x140e
    130c:	0b0b3e0e 	bleq	2d0b4c <__bss_end+0x2c4a54>
    1310:	3a13490b 	bcc	4d3744 <__bss_end+0x4c764c>
    1314:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
    1318:	0013010b 	andseq	r0, r3, fp, lsl #2
    131c:	00160f00 	andseq	r0, r6, r0, lsl #30
    1320:	0b3a0e03 	bleq	e84b34 <__bss_end+0xe78a3c>
    1324:	0b390b3b 	bleq	e44018 <__bss_end+0xe37f20>
    1328:	00001349 	andeq	r1, r0, r9, asr #6
    132c:	00002110 	andeq	r2, r0, r0, lsl r1
    1330:	00341100 	eorseq	r1, r4, r0, lsl #2
    1334:	0b3a0e03 	bleq	e84b48 <__bss_end+0xe78a50>
    1338:	0b390b3b 	bleq	e4402c <__bss_end+0xe37f34>
    133c:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
    1340:	0000193c 	andeq	r1, r0, ip, lsr r9
    1344:	47003412 	smladmi	r0, r2, r4, r3
    1348:	3b0b3a13 	blcc	2cfb9c <__bss_end+0x2c3aa4>
    134c:	490b3905 	stmdbmi	fp, {r0, r2, r8, fp, ip, sp}
    1350:	00180213 	andseq	r0, r8, r3, lsl r2
    1354:	11010000 	mrsne	r0, (UNDEF: 1)
    1358:	130e2501 	movwne	r2, #58625	; 0xe501
    135c:	1b0e030b 	blne	381f90 <__bss_end+0x375e98>
    1360:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
    1364:	00171006 	andseq	r1, r7, r6
    1368:	00240200 	eoreq	r0, r4, r0, lsl #4
    136c:	0b3e0b0b 	bleq	f83fa0 <__bss_end+0xf77ea8>
    1370:	00000e03 	andeq	r0, r0, r3, lsl #28
    1374:	0b002403 	bleq	a388 <_Z11sched_yieldv>
    1378:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
    137c:	04000008 	streq	r0, [r0], #-8
    1380:	0e030104 	adfeqs	f0, f3, f4
    1384:	0b0b0b3e 	bleq	2c4084 <__bss_end+0x2b7f8c>
    1388:	0b3a1349 	bleq	e860b4 <__bss_end+0xe79fbc>
    138c:	0b390b3b 	bleq	e44080 <__bss_end+0xe37f88>
    1390:	00001301 	andeq	r1, r0, r1, lsl #6
    1394:	03002805 	movweq	r2, #2053	; 0x805
    1398:	000b1c0e 	andeq	r1, fp, lr, lsl #24
    139c:	01130600 	tsteq	r3, r0, lsl #12
    13a0:	0b0b0e03 	bleq	2c4bb4 <__bss_end+0x2b8abc>
    13a4:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
    13a8:	13010b39 	movwne	r0, #6969	; 0x1b39
    13ac:	0d070000 	stceq	0, cr0, [r7, #-0]
    13b0:	3a0e0300 	bcc	381fb8 <__bss_end+0x375ec0>
    13b4:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
    13b8:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
    13bc:	0800000b 	stmdaeq	r0, {r0, r1, r3}
    13c0:	13490026 	movtne	r0, #36902	; 0x9026
    13c4:	01090000 	mrseq	r0, (UNDEF: 9)
    13c8:	01134901 	tsteq	r3, r1, lsl #18
    13cc:	0a000013 	beq	1420 <shift+0x1420>
    13d0:	13490021 	movtne	r0, #36897	; 0x9021
    13d4:	00000b2f 	andeq	r0, r0, pc, lsr #22
    13d8:	0300340b 	movweq	r3, #1035	; 0x40b
    13dc:	3b0b3a0e 	blcc	2cfc1c <__bss_end+0x2c3b24>
    13e0:	490b3905 	stmdbmi	fp, {r0, r2, r8, fp, ip, sp}
    13e4:	000a1c13 	andeq	r1, sl, r3, lsl ip
    13e8:	00160c00 	andseq	r0, r6, r0, lsl #24
    13ec:	0b3a0e03 	bleq	e84c00 <__bss_end+0xe78b08>
    13f0:	0b390b3b 	bleq	e440e4 <__bss_end+0xe37fec>
    13f4:	00001349 	andeq	r1, r0, r9, asr #6
    13f8:	3f012e0d 	svccc	0x00012e0d
    13fc:	3a0e0319 	bcc	382068 <__bss_end+0x375f70>
    1400:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
    1404:	4919270b 	ldmdbmi	r9, {r0, r1, r3, r8, r9, sl, sp}
    1408:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
    140c:	97184006 	ldrls	r4, [r8, -r6]
    1410:	13011942 	movwne	r1, #6466	; 0x1942
    1414:	050e0000 	streq	r0, [lr, #-0]
    1418:	3a080300 	bcc	202020 <__bss_end+0x1f5f28>
    141c:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
    1420:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
    1424:	1742b717 	smlaldne	fp, r2, r7, r7
    1428:	890f0000 	stmdbhi	pc, {}	; <UNPREDICTABLE>
    142c:	11010182 	smlabbne	r1, r2, r1, r0
    1430:	19429501 	stmdbne	r2, {r0, r8, sl, ip, pc}^
    1434:	13011331 	movwne	r1, #4913	; 0x1331
    1438:	8a100000 	bhi	401440 <__bss_end+0x3f5348>
    143c:	02000182 	andeq	r0, r0, #-2147483616	; 0x80000020
    1440:	18429118 	stmdane	r2, {r3, r4, r8, ip, pc}^
    1444:	89110000 	ldmdbhi	r1, {}	; <UNPREDICTABLE>
    1448:	11010182 	smlabbne	r1, r2, r1, r0
    144c:	00133101 	andseq	r3, r3, r1, lsl #2
    1450:	002e1200 	eoreq	r1, lr, r0, lsl #4
    1454:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
    1458:	0e030e6e 	cdpeq	14, 0, cr0, cr3, cr14, {3}
    145c:	0b3b0b3a 	bleq	ec414c <__bss_end+0xeb8054>
    1460:	00000b39 	andeq	r0, r0, r9, lsr fp
    1464:	01110100 	tsteq	r1, r0, lsl #2
    1468:	0b130e25 	bleq	4c4d04 <__bss_end+0x4b8c0c>
    146c:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
    1470:	06120111 			; <UNDEFINED> instruction: 0x06120111
    1474:	00001710 	andeq	r1, r0, r0, lsl r7
    1478:	0b002402 	bleq	a488 <_Z5closej>
    147c:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
    1480:	0300000e 	movweq	r0, #14
    1484:	0b0b0024 	bleq	2c151c <__bss_end+0x2b5424>
    1488:	08030b3e 	stmdaeq	r3, {r1, r2, r3, r4, r5, r8, r9, fp}
    148c:	04040000 	streq	r0, [r4], #-0
    1490:	3e0e0301 	cdpcc	3, 0, cr0, cr14, cr1, {0}
    1494:	490b0b0b 	stmdbmi	fp, {r0, r1, r3, r8, r9, fp}
    1498:	3b0b3a13 	blcc	2cfcec <__bss_end+0x2c3bf4>
    149c:	010b390b 	tsteq	fp, fp, lsl #18
    14a0:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
    14a4:	0e030028 	cdpeq	0, 0, cr0, cr3, cr8, {1}
    14a8:	00000b1c 	andeq	r0, r0, ip, lsl fp
    14ac:	03011306 	movweq	r1, #4870	; 0x1306
    14b0:	3a0b0b0e 	bcc	2c40f0 <__bss_end+0x2b7ff8>
    14b4:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
    14b8:	0013010b 	andseq	r0, r3, fp, lsl #2
    14bc:	000d0700 	andeq	r0, sp, r0, lsl #14
    14c0:	0b3a0e03 	bleq	e84cd4 <__bss_end+0xe78bdc>
    14c4:	0b39053b 	bleq	e429b8 <__bss_end+0xe368c0>
    14c8:	0b381349 	bleq	e061f4 <__bss_end+0xdfa0fc>
    14cc:	26080000 	strcs	r0, [r8], -r0
    14d0:	00134900 	andseq	r4, r3, r0, lsl #18
    14d4:	01010900 	tsteq	r1, r0, lsl #18
    14d8:	13011349 	movwne	r1, #4937	; 0x1349
    14dc:	210a0000 	mrscs	r0, (UNDEF: 10)
    14e0:	2f134900 	svccs	0x00134900
    14e4:	0b00000b 	bleq	1518 <shift+0x1518>
    14e8:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
    14ec:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
    14f0:	13490b39 	movtne	r0, #39737	; 0x9b39
    14f4:	00000a1c 	andeq	r0, r0, ip, lsl sl
    14f8:	0300160c 	movweq	r1, #1548	; 0x60c
    14fc:	3b0b3a0e 	blcc	2cfd3c <__bss_end+0x2c3c44>
    1500:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
    1504:	0d000013 	stceq	0, cr0, [r0, #-76]	; 0xffffffb4
    1508:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
    150c:	0b3a0e03 	bleq	e84d20 <__bss_end+0xe78c28>
    1510:	0b39053b 	bleq	e42a04 <__bss_end+0xe3690c>
    1514:	13491927 	movtne	r1, #39207	; 0x9927
    1518:	06120111 			; <UNDEFINED> instruction: 0x06120111
    151c:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
    1520:	0e000019 	mcreq	0, 0, r0, cr0, cr9, {0}
    1524:	08030005 	stmdaeq	r3, {r0, r2}
    1528:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
    152c:	13490b39 	movtne	r0, #39737	; 0x9b39
    1530:	42b71702 	adcsmi	r1, r7, #524288	; 0x80000
    1534:	0f000017 	svceq	0x00000017
    1538:	08030034 	stmdaeq	r3, {r2, r4, r5}
    153c:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
    1540:	13490b39 	movtne	r0, #39737	; 0x9b39
    1544:	42b71702 	adcsmi	r1, r7, #524288	; 0x80000
    1548:	00000017 	andeq	r0, r0, r7, lsl r0
    154c:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
    1550:	030b130e 	movweq	r1, #45838	; 0xb30e
    1554:	110e1b0e 	tstne	lr, lr, lsl #22
    1558:	10061201 	andne	r1, r6, r1, lsl #4
    155c:	02000017 	andeq	r0, r0, #23
    1560:	0b0b0024 	bleq	2c15f8 <__bss_end+0x2b5500>
    1564:	0e030b3e 	vmoveq.16	d3[0], r0
    1568:	24030000 	strcs	r0, [r3], #-0
    156c:	3e0b0b00 	vmlacc.f64	d0, d11, d0
    1570:	0008030b 	andeq	r0, r8, fp, lsl #6
    1574:	01040400 	tsteq	r4, r0, lsl #8
    1578:	0b3e0e03 	bleq	f84d8c <__bss_end+0xf78c94>
    157c:	13490b0b 	movtne	r0, #39691	; 0x9b0b
    1580:	0b3b0b3a 	bleq	ec4270 <__bss_end+0xeb8178>
    1584:	13010b39 	movwne	r0, #6969	; 0x1b39
    1588:	28050000 	stmdacs	r5, {}	; <UNPREDICTABLE>
    158c:	1c0e0300 	stcne	3, cr0, [lr], {-0}
    1590:	0600000b 	streq	r0, [r0], -fp
    1594:	0e030113 	mcreq	1, 0, r0, cr3, cr3, {0}
    1598:	0b3a0b0b 	bleq	e841cc <__bss_end+0xe780d4>
    159c:	0b39053b 	bleq	e42a90 <__bss_end+0xe36998>
    15a0:	00001301 	andeq	r1, r0, r1, lsl #6
    15a4:	03000d07 	movweq	r0, #3335	; 0xd07
    15a8:	3b0b3a0e 	blcc	2cfde8 <__bss_end+0x2c3cf0>
    15ac:	490b3905 	stmdbmi	fp, {r0, r2, r8, fp, ip, sp}
    15b0:	000b3813 	andeq	r3, fp, r3, lsl r8
    15b4:	00260800 	eoreq	r0, r6, r0, lsl #16
    15b8:	00001349 	andeq	r1, r0, r9, asr #6
    15bc:	49010109 	stmdbmi	r1, {r0, r3, r8}
    15c0:	00130113 	andseq	r0, r3, r3, lsl r1
    15c4:	00210a00 	eoreq	r0, r1, r0, lsl #20
    15c8:	0b2f1349 	bleq	bc62f4 <__bss_end+0xbba1fc>
    15cc:	340b0000 	strcc	r0, [fp], #-0
    15d0:	3a0e0300 	bcc	3821d8 <__bss_end+0x3760e0>
    15d4:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
    15d8:	1c13490b 			; <UNDEFINED> instruction: 0x1c13490b
    15dc:	0c00000a 	stceq	0, cr0, [r0], {10}
    15e0:	0e030016 	mcreq	0, 0, r0, cr3, cr6, {0}
    15e4:	0b3b0b3a 	bleq	ec42d4 <__bss_end+0xeb81dc>
    15e8:	13490b39 	movtne	r0, #39737	; 0x9b39
    15ec:	2e0d0000 	cdpcs	0, 0, cr0, cr13, cr0, {0}
    15f0:	03193f01 	tsteq	r9, #1, 30
    15f4:	3b0b3a0e 	blcc	2cfe34 <__bss_end+0x2c3d3c>
    15f8:	270b3905 	strcs	r3, [fp, -r5, lsl #18]
    15fc:	11134919 	tstne	r3, r9, lsl r9
    1600:	40061201 	andmi	r1, r6, r1, lsl #4
    1604:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
    1608:	00001301 	andeq	r1, r0, r1, lsl #6
    160c:	0300050e 	movweq	r0, #1294	; 0x50e
    1610:	3b0b3a08 	blcc	2cfe38 <__bss_end+0x2c3d40>
    1614:	490b3905 	stmdbmi	fp, {r0, r2, r8, fp, ip, sp}
    1618:	b7170213 			; <UNDEFINED> instruction: 0xb7170213
    161c:	00001742 	andeq	r1, r0, r2, asr #14
    1620:	0300050f 	movweq	r0, #1295	; 0x50f
    1624:	3b0b3a08 	blcc	2cfe4c <__bss_end+0x2c3d54>
    1628:	490b3905 	stmdbmi	fp, {r0, r2, r8, fp, ip, sp}
    162c:	00180213 	andseq	r0, r8, r3, lsl r2
    1630:	00341000 	eorseq	r1, r4, r0
    1634:	0b3a0803 	bleq	e83648 <__bss_end+0xe77550>
    1638:	0b39053b 	bleq	e42b2c <__bss_end+0xe36a34>
    163c:	17021349 	strne	r1, [r2, -r9, asr #6]
    1640:	001742b7 			; <UNDEFINED> instruction: 0x001742b7
    1644:	000f1100 	andeq	r1, pc, r0, lsl #2
    1648:	13490b0b 	movtne	r0, #39691	; 0x9b0b
    164c:	01000000 	mrseq	r0, (UNDEF: 0)
    1650:	0e250111 	mcreq	1, 1, r0, cr5, cr1, {0}
    1654:	0e030b13 	vmoveq.32	d3[0], r0
    1658:	01110e1b 	tsteq	r1, fp, lsl lr
    165c:	17100612 			; <UNDEFINED> instruction: 0x17100612
    1660:	24020000 	strcs	r0, [r2], #-0
    1664:	3e0b0b00 	vmlacc.f64	d0, d11, d0
    1668:	0008030b 	andeq	r0, r8, fp, lsl #6
    166c:	00160300 	andseq	r0, r6, r0, lsl #6
    1670:	0b3a0e03 	bleq	e84e84 <__bss_end+0xe78d8c>
    1674:	0b390b3b 	bleq	e44368 <__bss_end+0xe38270>
    1678:	00001349 	andeq	r1, r0, r9, asr #6
    167c:	0b002404 	bleq	a694 <_Z17set_task_deadlinej+0x30>
    1680:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
    1684:	0500000e 	streq	r0, [r0, #-14]
    1688:	0b0b000f 	bleq	2c16cc <__bss_end+0x2b55d4>
    168c:	0f060000 	svceq	0x00060000
    1690:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
    1694:	07000013 	smladeq	r0, r3, r0, r0
    1698:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
    169c:	0b3a0e03 	bleq	e84eb0 <__bss_end+0xe78db8>
    16a0:	0b390b3b 	bleq	e44394 <__bss_end+0xe3829c>
    16a4:	13491927 	movtne	r1, #39207	; 0x9927
    16a8:	06120111 			; <UNDEFINED> instruction: 0x06120111
    16ac:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
    16b0:	00130119 	andseq	r0, r3, r9, lsl r1
    16b4:	00050800 	andeq	r0, r5, r0, lsl #16
    16b8:	0b3a0803 	bleq	e836cc <__bss_end+0xe775d4>
    16bc:	0b390b3b 	bleq	e443b0 <__bss_end+0xe382b8>
    16c0:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
    16c4:	05090000 	streq	r0, [r9, #-0]
    16c8:	3a080300 	bcc	2022d0 <__bss_end+0x1f61d8>
    16cc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    16d0:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
    16d4:	1742b717 	smlaldne	fp, r2, r7, r7
    16d8:	340a0000 	strcc	r0, [sl], #-0
    16dc:	3a080300 	bcc	2022e4 <__bss_end+0x1f61ec>
    16e0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    16e4:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
    16e8:	1742b717 	smlaldne	fp, r2, r7, r7
    16ec:	340b0000 	strcc	r0, [fp], #-0
    16f0:	3a0e0300 	bcc	3822f8 <__bss_end+0x376200>
    16f4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    16f8:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
    16fc:	1742b717 	smlaldne	fp, r2, r7, r7
    1700:	Address 0x0000000000001700 is out of bounds.


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
  60:	00000024 	andeq	r0, r0, r4, lsr #32
  64:	02d40002 	sbcseq	r0, r4, #2
  68:	00040000 	andeq	r0, r4, r0
  6c:	00000000 	andeq	r0, r0, r0
  70:	0000822c 	andeq	r8, r0, ip, lsr #4
  74:	00000364 	andeq	r0, r0, r4, ror #6
  78:	00008590 	muleq	r0, r0, r5
  7c:	00000030 	andeq	r0, r0, r0, lsr r0
	...
  88:	00000034 	andeq	r0, r0, r4, lsr r0
  8c:	0cba0002 	ldceq	0, cr0, [sl], #8
  90:	00040000 	andeq	r0, r4, r0
  94:	00000000 	andeq	r0, r0, r0
  98:	000085c0 	andeq	r8, r0, r0, asr #11
  9c:	00001364 	andeq	r1, r0, r4, ror #6
  a0:	00008590 	muleq	r0, r0, r5
  a4:	00000030 	andeq	r0, r0, r0, lsr r0
  a8:	00009924 	andeq	r9, r0, r4, lsr #18
  ac:	00000030 	andeq	r0, r0, r0, lsr r0
  b0:	00009954 	andeq	r9, r0, r4, asr r9
  b4:	00000030 	andeq	r0, r0, r0, lsr r0
	...
  c0:	0000001c 	andeq	r0, r0, ip, lsl r0
  c4:	1ddd0002 	ldclne	0, cr0, [sp, #8]
  c8:	00040000 	andeq	r0, r4, r0
  cc:	00000000 	andeq	r0, r0, r0
  d0:	00009984 	andeq	r9, r0, r4, lsl #19
  d4:	00000270 	andeq	r0, r0, r0, ror r2
	...
  e0:	0000001c 	andeq	r0, r0, ip, lsl r0
  e4:	20570002 	subscs	r0, r7, r2
  e8:	00040000 	andeq	r0, r4, r0
  ec:	00000000 	andeq	r0, r0, r0
  f0:	00009bf4 	strdeq	r9, [r0], -r4
  f4:	000001c8 	andeq	r0, r0, r8, asr #3
	...
 100:	0000001c 	andeq	r0, r0, ip, lsl r0
 104:	22a80002 	adccs	r0, r8, #2
 108:	00040000 	andeq	r0, r4, r0
 10c:	00000000 	andeq	r0, r0, r0
 110:	00009dc0 	andeq	r9, r0, r0, asr #27
 114:	00000160 	andeq	r0, r0, r0, ror #2
	...
 120:	00000024 	andeq	r0, r0, r4, lsr #32
 124:	24e30002 	strbtcs	r0, [r3], #2
 128:	00040000 	andeq	r0, r4, r0
 12c:	00000000 	andeq	r0, r0, r0
 130:	00009f20 	andeq	r9, r0, r0, lsr #30
 134:	00000410 	andeq	r0, r0, r0, lsl r4
 138:	00009924 	andeq	r9, r0, r4, lsr #18
 13c:	00000030 	andeq	r0, r0, r0, lsr r0
	...
 148:	0000001c 	andeq	r0, r0, ip, lsl r0
 14c:	2b0e0002 	blcs	38015c <__bss_end+0x374064>
 150:	00040000 	andeq	r0, r4, r0
 154:	00000000 	andeq	r0, r0, r0
 158:	0000a330 	andeq	sl, r0, r0, lsr r3
 15c:	0000045c 	andeq	r0, r0, ip, asr r4
	...
 168:	0000001c 	andeq	r0, r0, ip, lsl r0
 16c:	36a30002 	strtcc	r0, [r3], r2
 170:	00040000 	andeq	r0, r4, r0
 174:	00000000 	andeq	r0, r0, r0
 178:	0000a790 	muleq	r0, r0, r7
 17c:	00000c2c 	andeq	r0, r0, ip, lsr #24
	...
 188:	0000001c 	andeq	r0, r0, ip, lsl r0
 18c:	3cd40002 	ldclcc	0, cr0, [r4], {2}
 190:	00040000 	andeq	r0, r4, r0
 194:	00000000 	andeq	r0, r0, r0
 198:	0000b3bc 			; <UNDEFINED> instruction: 0x0000b3bc
 19c:	0000020c 	andeq	r0, r0, ip, lsl #4
	...
 1a8:	0000001c 	andeq	r0, r0, ip, lsl r0
 1ac:	3cfa0002 	ldclcc	0, cr0, [sl], #8
 1b0:	00040000 	andeq	r0, r4, r0
 1b4:	00000000 	andeq	r0, r0, r0
 1b8:	0000b5c8 	andeq	fp, r0, r8, asr #11
 1bc:	00000240 	andeq	r0, r0, r0, asr #4
	...
 1c8:	0000001c 	andeq	r0, r0, ip, lsl r0
 1cc:	3d200002 	stccc	0, cr0, [r0, #-8]!
 1d0:	00040000 	andeq	r0, r4, r0
 1d4:	00000000 	andeq	r0, r0, r0
 1d8:	0000b808 	andeq	fp, r0, r8, lsl #16
 1dc:	00000004 	andeq	r0, r0, r4
	...
 1e8:	0000001c 	andeq	r0, r0, ip, lsl r0
 1ec:	3d460002 	stclcc	0, cr0, [r6, #-8]
 1f0:	00040000 	andeq	r0, r4, r0
 1f4:	00000000 	andeq	r0, r0, r0
 1f8:	0000b80c 	andeq	fp, r0, ip, lsl #16
 1fc:	00000250 	andeq	r0, r0, r0, asr r2
	...
 208:	0000001c 	andeq	r0, r0, ip, lsl r0
 20c:	3d6c0002 	stclcc	0, cr0, [ip, #-8]!
 210:	00040000 	andeq	r0, r4, r0
 214:	00000000 	andeq	r0, r0, r0
 218:	0000ba5c 	andeq	fp, r0, ip, asr sl
 21c:	000000d4 	ldrdeq	r0, [r0], -r4
	...
 228:	00000014 	andeq	r0, r0, r4, lsl r0
 22c:	3d920002 	ldccc	0, cr0, [r2, #8]
 230:	00040000 	andeq	r0, r4, r0
	...
 240:	0000001c 	andeq	r0, r0, ip, lsl r0
 244:	40c00002 	sbcmi	r0, r0, r2
 248:	00040000 	andeq	r0, r4, r0
 24c:	00000000 	andeq	r0, r0, r0
 250:	0000bb30 	andeq	fp, r0, r0, lsr fp
 254:	00000030 	andeq	r0, r0, r0, lsr r0
	...
 260:	0000001c 	andeq	r0, r0, ip, lsl r0
 264:	43ca0002 	bicmi	r0, sl, #2
 268:	00040000 	andeq	r0, r4, r0
 26c:	00000000 	andeq	r0, r0, r0
 270:	0000bb60 	andeq	fp, r0, r0, ror #22
 274:	00000040 	andeq	r0, r0, r0, asr #32
	...
 280:	0000001c 	andeq	r0, r0, ip, lsl r0
 284:	46f80002 	ldrbtmi	r0, [r8], r2
 288:	00040000 	andeq	r0, r4, r0
 28c:	00000000 	andeq	r0, r0, r0
 290:	0000bba0 	andeq	fp, r0, r0, lsr #23
 294:	00000120 	andeq	r0, r0, r0, lsr #2
	...
 2a0:	0000001c 	andeq	r0, r0, ip, lsl r0
 2a4:	4a7c0002 	bmi	1f002b4 <__bss_end+0x1ef41bc>
 2a8:	00040000 	andeq	r0, r4, r0
 2ac:	00000000 	andeq	r0, r0, r0
 2b0:	0000bcc0 	andeq	fp, r0, r0, asr #25
 2b4:	00000118 	andeq	r0, r0, r8, lsl r1
	...

Disassembly of section .debug_str:

00000000 <.debug_str>:
       0:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; ffffff4c <__bss_end+0xffff3e54>
       4:	72742f65 	rsbsvc	r2, r4, #404	; 0x194
       8:	6c696665 	stclvs	6, cr6, [r9], #-404	; 0xfffffe6c
       c:	6d65732f 	stclvs	3, cr7, [r5, #-188]!	; 0xffffff44
      10:	756f732f 	strbvc	r7, [pc, #-815]!	; fffffce9 <__bss_end+0xffff3bf1>
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
      40:	752f7365 	strvc	r7, [pc, #-869]!	; fffffce3 <__bss_end+0xffff3beb>
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
      dc:	2b6b7a36 	blcs	1ade9bc <__bss_end+0x1ad28c4>
      e0:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
      e4:	672d2067 	strvs	r2, [sp, -r7, rrx]!
      e8:	304f2d20 	subcc	r2, pc, r0, lsr #26
      ec:	304f2d20 	subcc	r2, pc, r0, lsr #26
      f0:	625f5f00 	subsvs	r5, pc, #0, 30
      f4:	655f7373 	ldrbvs	r7, [pc, #-883]	; fffffd89 <__bss_end+0xffff3c91>
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
     160:	755f6962 	ldrbvc	r6, [pc, #-2402]	; fffff806 <__bss_end+0xffff370e>
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
     260:	2b432055 	blcs	10c83bc <__bss_end+0x10bc2c4>
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
     2c4:	7a6a3637 	bvc	1a8dba8 <__bss_end+0x1a81ab0>
     2c8:	20732d66 	rsbscs	r2, r3, r6, ror #26
     2cc:	72616d2d 	rsbvc	r6, r1, #2880	; 0xb40
     2d0:	6d2d206d 	stcvs	0, cr2, [sp, #-436]!	; 0xfffffe4c
     2d4:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
     2d8:	6d72613d 	ldfvse	f6, [r2, #-244]!	; 0xffffff0c
     2dc:	6b7a3676 	blvs	1e8dcbc <__bss_end+0x1e81bc4>
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
     340:	72700065 	rsbsvc	r0, r0, #101	; 0x65
     344:	63696465 	cmnvs	r9, #1694498816	; 0x65000000
     348:	5f646574 	svcpl	0x00646574
     34c:	756c6176 	strbvc	r6, [ip, #-374]!	; 0xfffffe8a
     350:	50007365 	andpl	r7, r0, r5, ror #6
     354:	69646572 	stmdbvs	r4!, {r1, r4, r5, r6, r8, sl, sp, lr}^
     358:	49007463 	stmdbmi	r0, {r0, r1, r5, r6, sl, ip, sp, lr}
     35c:	0074696e 	rsbseq	r6, r4, lr, ror #18
     360:	64616572 	strbtvs	r6, [r1], #-1394	; 0xfffffa8e
     364:	696f705f 	stmdbvs	pc!, {r0, r1, r2, r3, r4, r6, ip, sp, lr}^	; <UNPREDICTABLE>
     368:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
     36c:	646f4d00 	strbtvs	r4, [pc], #-3328	; 374 <shift+0x374>
     370:	44006c65 	strmi	r6, [r0], #-3173	; 0xfffff39b
     374:	5f415441 	svcpl	0x00415441
     378:	444e4957 	strbmi	r4, [lr], #-2391	; 0xfffff6a9
     37c:	535f574f 	cmppl	pc, #20709376	; 0x13c0000
     380:	00455a49 	subeq	r5, r5, r9, asr #20
     384:	354e5a5f 	strbcc	r5, [lr, #-2655]	; 0xfffff5a1
     388:	65646f4d 	strbvs	r6, [r4, #-3917]!	; 0xfffff0b3
     38c:	7250376c 	subsvc	r3, r0, #108, 14	; 0x1b00000
     390:	63696465 	cmnvs	r9, #1694498816	; 0x65000000
     394:	39504574 	ldmdbcc	r0, {r2, r4, r5, r6, r8, sl, lr}^
     398:	62697254 	rsbvs	r7, r9, #84, 4	; 0x40000005
     39c:	616d7365 	cmnvs	sp, r5, ror #6
     3a0:	5a5f006e 	bpl	17c0560 <__bss_end+0x17b4468>
     3a4:	6f4d354e 	svcvs	0x004d354e
     3a8:	316c6564 	cmncc	ip, r4, ror #10
     3ac:	64644135 	strbtvs	r4, [r4], #-309	; 0xfffffecb
     3b0:	7461445f 	strbtvc	r4, [r1], #-1119	; 0xfffffba1
     3b4:	61535f61 	cmpvs	r3, r1, ror #30
     3b8:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
     3bc:	5f006645 	svcpl	0x00006645
     3c0:	42364e5a 	eorsmi	r4, r6, #1440	; 0x5a0
     3c4:	65666675 	strbvs	r6, [r6, #-1653]!	; 0xfffff98b
     3c8:	57303172 			; <UNDEFINED> instruction: 0x57303172
     3cc:	65746972 	ldrbvs	r6, [r4, #-2418]!	; 0xfffff68e
     3d0:	6e694c5f 	mcrvs	12, 3, r4, cr9, cr15, {2}
     3d4:	4b504565 	blmi	1411970 <__bss_end+0x1405878>
     3d8:	65470063 	strbvs	r0, [r7, #-99]	; 0xffffff9d
     3dc:	6c465f74 	mcrrvs	15, 7, r5, r6, cr4
     3e0:	0074616f 	rsbseq	r6, r4, pc, ror #2
     3e4:	314e5a5f 	cmpcc	lr, pc, asr sl
     3e8:	6e615236 	mcrvs	2, 3, r5, cr1, cr6, {1}
     3ec:	5f6d6f64 	svcpl	0x006d6f64
     3f0:	656e6547 	strbvs	r6, [lr, #-1351]!	; 0xfffffab9
     3f4:	6f746172 	svcvs	0x00746172
     3f8:	65473772 	strbvs	r3, [r7, #-1906]	; 0xfffff88e
     3fc:	6e495f74 	mcrvs	15, 2, r5, cr9, cr4, {3}
     400:	00764574 	rsbseq	r4, r6, r4, ror r5
     404:	465f7349 	ldrbmi	r7, [pc], -r9, asr #6
     408:	006c6c75 	rsbeq	r6, ip, r5, ror ip
     40c:	61726170 	cmnvs	r2, r0, ror r1
     410:	6574656d 	ldrbvs	r6, [r4, #-1389]!	; 0xfffffa93
     414:	5f007372 	svcpl	0x00007372
     418:	6836315a 	ldmdavs	r6!, {r1, r3, r4, r6, r8, ip, sp}
     41c:	6f6c6c65 	svcvs	0x006c6c65
     420:	7261755f 	rsbvc	r7, r1, #398458880	; 0x17c00000
     424:	6f775f74 	svcvs	0x00775f74
     428:	50646c72 	rsbpl	r6, r4, r2, ror ip
     42c:	66754236 			; <UNDEFINED> instruction: 0x66754236
     430:	00726566 	rsbseq	r6, r2, r6, ror #10
     434:	5f746547 	svcpl	0x00746547
     438:	61746144 	cmnvs	r4, r4, asr #2
     43c:	6d61535f 	stclvs	3, cr5, [r1, #-380]!	; 0xfffffe84
     440:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
     444:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     448:	646f4d35 	strbtvs	r4, [pc], #-3381	; 450 <shift+0x450>
     44c:	30316c65 	eorscc	r6, r1, r5, ror #24
     450:	63656843 	cmnvs	r5, #4390912	; 0x430000
     454:	696f706b 	stmdbvs	pc!, {r0, r1, r3, r5, r6, ip, sp, lr}^	; <UNPREDICTABLE>
     458:	7645746e 	strbvc	r7, [r5], -lr, ror #8
     45c:	706d7400 	rsbvc	r7, sp, r0, lsl #8
     460:	6d740033 	ldclvs	0, cr0, [r4, #-204]!	; 0xffffff34
     464:	74003170 	strvc	r3, [r0], #-368	; 0xfffffe90
     468:	0032706d 	eorseq	r7, r2, sp, rrx
     46c:	74697277 	strbtvc	r7, [r9], #-631	; 0xfffffd89
     470:	6f705f65 	svcvs	0x00705f65
     474:	65746e69 	ldrbvs	r6, [r4, #-3689]!	; 0xfffff197
     478:	73690072 	cmnvc	r9, #114	; 0x72
     47c:	7469665f 	strbtvc	r6, [r9], #-1631	; 0xfffff9a1
     480:	676e6974 			; <UNDEFINED> instruction: 0x676e6974
     484:	706c6100 	rsbvc	r6, ip, r0, lsl #2
     488:	5f006168 	svcpl	0x00006168
     48c:	42364e5a 	eorsmi	r4, r6, #1440	; 0x5a0
     490:	65666675 	strbvs	r6, [r6, #-1653]!	; 0xfffff98b
     494:	64413872 	strbvs	r3, [r1], #-2162	; 0xfffff78e
     498:	79425f64 	stmdbvc	r2, {r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     49c:	63456574 	movtvs	r6, #21876	; 0x5574
     4a0:	78614d00 	stmdavc	r1!, {r8, sl, fp, lr}^
     4a4:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     4a8:	656d616e 	strbvs	r6, [sp, #-366]!	; 0xfffffe92
     4ac:	676e654c 	strbvs	r6, [lr, -ip, asr #10]!
     4b0:	5f006874 	svcpl	0x00006874
     4b4:	4d354e5a 	ldcmi	14, cr4, [r5, #-360]!	; 0xfffffe98
     4b8:	6c65646f 	cfstrdvs	mvd6, [r5], #-444	; 0xfffffe44
     4bc:	696e4934 	stmdbvs	lr!, {r2, r4, r5, r8, fp, lr}^
     4c0:	00764574 	rsbseq	r4, r6, r4, ror r5
     4c4:	5f746547 	svcpl	0x00746547
     4c8:	00746e49 	rsbseq	r6, r4, r9, asr #28
     4cc:	5f6e696d 	svcpl	0x006e696d
     4d0:	6f727265 	svcvs	0x00727265
     4d4:	5a5f0072 	bpl	17c06a4 <__bss_end+0x17b45ac>
     4d8:	6f4d354e 	svcvs	0x004d354e
     4dc:	386c6564 	stmdacc	ip!, {r2, r5, r6, r8, sl, sp, lr}^
     4e0:	6174754d 	cmnvs	r4, sp, asr #10
     4e4:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     4e8:	39505045 	ldmdbcc	r0, {r0, r2, r6, ip, lr}^
     4ec:	62697254 	rsbvs	r7, r9, #84, 4	; 0x40000005
     4f0:	616d7365 	cmnvs	sp, r5, ror #6
     4f4:	6544006e 	strbvs	r0, [r4, #-110]	; 0xffffff92
     4f8:	696c6461 	stmdbvs	ip!, {r0, r5, r6, sl, sp, lr}^
     4fc:	555f656e 	ldrbpl	r6, [pc, #-1390]	; ffffff96 <__bss_end+0xffff3e9e>
     500:	6168636e 	cmnvs	r8, lr, ror #6
     504:	6465676e 	strbtvs	r6, [r5], #-1902	; 0xfffff892
     508:	6e5a5f00 	cdpvs	15, 5, cr5, cr10, cr0, {0}
     50c:	5f006a77 	svcpl	0x00006a77
     510:	4d354e5a 	ldcmi	14, cr4, [r5, #-360]!	; 0xfffffe98
     514:	6c65646f 	cfstrdvs	mvd6, [r5], #-444	; 0xfffffe44
     518:	6c614336 	stclvs	3, cr4, [r1], #-216	; 0xffffff28
     51c:	45425f63 	strbmi	r5, [r2, #-3939]	; 0xfffff09d
     520:	00666666 	rsbeq	r6, r6, r6, ror #12
     524:	69746f4e 	ldmdbvs	r4!, {r1, r2, r3, r6, r8, r9, sl, fp, sp, lr}^
     528:	6c417966 	mcrrvs	9, 6, r7, r1, cr6	; <UNPREDICTABLE>
     52c:	5a5f006c 	bpl	17c06e4 <__bss_end+0x17b45ec>
     530:	4832314e 	ldmdami	r2!, {r1, r2, r3, r6, r8, ip, sp}
     534:	5f706165 	svcpl	0x00706165
     538:	616e614d 	cmnvs	lr, sp, asr #2
     53c:	35726567 	ldrbcc	r6, [r2, #-1383]!	; 0xfffffa99
     540:	6f6c6c41 	svcvs	0x006c6c41
     544:	006a4563 	rsbeq	r4, sl, r3, ror #10
     548:	354e5a5f 	strbcc	r5, [lr, #-2655]	; 0xfffff5a1
     54c:	65646f4d 	strbvs	r6, [r4, #-3917]!	; 0xfffff0b3
     550:	4539316c 	ldrmi	r3, [r9, #-364]!	; 0xfffffe94
     554:	5f6c6176 	svcpl	0x006c6176
     558:	69727453 	ldmdbvs	r2!, {r0, r1, r4, r6, sl, ip, sp, lr}^
     55c:	435f676e 	cmpmi	pc, #28835840	; 0x1b80000
     560:	616d6d6f 	cmnvs	sp, pc, ror #26
     564:	5045646e 	subpl	r6, r5, lr, ror #8
     568:	5f00634b 	svcpl	0x0000634b
     56c:	42364e5a 	eorsmi	r4, r6, #1440	; 0x5a0
     570:	65666675 	strbvs	r6, [r6, #-1653]!	; 0xfffff98b
     574:	64413972 	strbvs	r3, [r1], #-2418	; 0xfffff68e
     578:	79425f64 	stmdbvc	r2, {r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     57c:	45736574 	ldrbmi	r6, [r3, #-1396]!	; 0xfffffa8c
     580:	7250006a 	subsvc	r0, r0, #106	; 0x6a
     584:	5f746e69 	svcpl	0x00746e69
     588:	61726150 	cmnvs	r2, r0, asr r1
     58c:	6574656d 	ldrbvs	r6, [r4, #-1389]!	; 0xfffffa93
     590:	48007372 	stmdami	r0, {r1, r4, r5, r6, r8, r9, ip, sp, lr}
     594:	5f706165 	svcpl	0x00706165
     598:	616e614d 	cmnvs	lr, sp, asr #2
     59c:	00726567 	rsbseq	r6, r2, r7, ror #10
     5a0:	5f78614d 	svcpl	0x0078614d
     5a4:	636f7250 	cmnvs	pc, #80, 4
     5a8:	5f737365 	svcpl	0x00737365
     5ac:	6e65704f 	cdpvs	0, 6, cr7, cr5, cr15, {2}
     5b0:	465f6465 	ldrbmi	r6, [pc], -r5, ror #8
     5b4:	73656c69 	cmnvc	r5, #26880	; 0x6900
     5b8:	504f5000 	subpl	r5, pc, r0
     5bc:	54414c55 	strbpl	r4, [r1], #-3157	; 0xfffff3ab
     5c0:	5f4e4f49 	svcpl	0x004e4f49
     5c4:	4e554f43 	cdpmi	15, 5, cr4, cr5, cr3, {2}
     5c8:	61430054 	qdaddvs	r0, r4, r3
     5cc:	6c75636c 	ldclvs	3, cr6, [r5], #-432	; 0xfffffe50
     5d0:	5f657461 	svcpl	0x00657461
     5d4:	64657250 	strbtvs	r7, [r5], #-592	; 0xfffffdb0
     5d8:	69746369 	ldmdbvs	r4!, {r0, r3, r5, r6, r8, r9, sp, lr}^
     5dc:	5f006e6f 	svcpl	0x00006e6f
     5e0:	4d354e5a 	ldcmi	14, cr4, [r5, #-360]!	; 0xfffffe98
     5e4:	6c65646f 	cfstrdvs	mvd6, [r5], #-444	; 0xfffffe44
     5e8:	72503131 	subsvc	r3, r0, #1073741836	; 0x4000000c
     5ec:	74706d6f 	ldrbtvc	r6, [r0], #-3439	; 0xfffff291
     5f0:	6573555f 	ldrbvs	r5, [r3, #-1375]!	; 0xfffffaa1
     5f4:	00764572 	rsbseq	r4, r6, r2, ror r5
     5f8:	354e5a5f 	strbcc	r5, [lr, #-2655]	; 0xfffff5a1
     5fc:	65646f4d 	strbvs	r6, [r4, #-3917]!	; 0xfffff0b3
     600:	6553396c 	ldrbvs	r3, [r3, #-2412]	; 0xfffff694
     604:	6c415f74 	mcrrvs	15, 7, r5, r1, cr4
     608:	45616870 	strbmi	r6, [r1, #-2160]!	; 0xfffff790
     60c:	72543950 	subsvc	r3, r4, #80, 18	; 0x140000
     610:	73656269 	cmnvc	r5, #-1879048186	; 0x90000006
     614:	006e616d 	rsbeq	r6, lr, sp, ror #2
     618:	64656573 	strbtvs	r6, [r5], #-1395	; 0xfffffa8d
     61c:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     620:	646f4d35 	strbtvs	r4, [pc], #-3381	; 628 <shift+0x628>
     624:	52336c65 	eorspl	r6, r3, #25856	; 0x6500
     628:	76456e75 			; <UNDEFINED> instruction: 0x76456e75
     62c:	4f504500 	svcmi	0x00504500
     630:	435f4843 	cmpmi	pc, #4390912	; 0x430000
     634:	544e554f 	strbpl	r5, [lr], #-1359	; 0xfffffab1
     638:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     63c:	646f4d35 	strbtvs	r4, [pc], #-3381	; 644 <shift+0x644>
     640:	36316c65 	ldrtcc	r6, [r1], -r5, ror #24
     644:	73726946 	cmnvc	r2, #1146880	; 0x118000
     648:	65475f74 	strbvs	r5, [r7, #-3956]	; 0xfffff08c
     64c:	6172656e 	cmnvs	r2, lr, ror #10
     650:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     654:	4e007645 	cfmadd32mi	mvax2, mvfx7, mvfx0, mvfx5
     658:	6c69466f 	stclvs	6, cr4, [r9], #-444	; 0xfffffe44
     65c:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     660:	446d6574 	strbtmi	r6, [sp], #-1396	; 0xfffffa8c
     664:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
     668:	68730072 	ldmdavs	r3!, {r1, r4, r5, r6}^
     66c:	2074726f 	rsbscs	r7, r4, pc, ror #4
     670:	69736e75 	ldmdbvs	r3!, {r0, r2, r4, r5, r6, r9, sl, fp, sp, lr}^
     674:	64656e67 	strbtvs	r6, [r5], #-3687	; 0xfffff199
     678:	746e6920 	strbtvc	r6, [lr], #-2336	; 0xfffff6e0
     67c:	656c4300 	strbvs	r4, [ip, #-768]!	; 0xfffffd00
     680:	53007261 	movwpl	r7, #609	; 0x261
     684:	425f7465 	subsmi	r7, pc, #1694498816	; 0x65000000
     688:	65666675 	strbvs	r6, [r6, #-1653]!	; 0xfffff98b
     68c:	70650072 	rsbvc	r0, r5, r2, ror r0
     690:	5f68636f 	svcpl	0x0068636f
     694:	6e756f63 	cdpvs	15, 7, cr6, cr5, cr3, {3}
     698:	61430074 	hvcvs	12292	; 0x3004
     69c:	425f636c 	subsmi	r6, pc, #108, 6	; 0xb0000001
     6a0:	74655300 	strbtvc	r5, [r5], #-768	; 0xfffffd00
     6a4:	706c415f 	rsbvc	r4, ip, pc, asr r1
     6a8:	57006168 	strpl	r6, [r0, -r8, ror #2]
     6ac:	65746972 	ldrbvs	r6, [r4, #-2418]!	; 0xfffff68e
     6b0:	6e694c5f 	mcrvs	12, 3, r4, cr9, cr15, {2}
     6b4:	6f620065 	svcvs	0x00620065
     6b8:	5f006c6f 	svcpl	0x00006c6f
     6bc:	32314e5a 	eorscc	r4, r1, #1440	; 0x5a0
     6c0:	70616548 	rsbvc	r6, r1, r8, asr #10
     6c4:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     6c8:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     6cc:	72625334 	rsbvc	r5, r2, #52, 6	; 0xd0000000
     6d0:	0076456b 	rsbseq	r4, r6, fp, ror #10
     6d4:	656e6547 	strbvs	r6, [lr, #-1351]!	; 0xfffffab9
     6d8:	6f6f505f 	svcvs	0x006f505f
     6dc:	61505f6c 	cmpvs	r0, ip, ror #30
     6e0:	00797472 	rsbseq	r7, r9, r2, ror r4
     6e4:	646e6172 	strbtvs	r6, [lr], #-370	; 0xfffffe8e
     6e8:	50006d6f 	andpl	r6, r0, pc, ror #26
     6ec:	706d6f72 	rsbvc	r6, sp, r2, ror pc
     6f0:	73555f74 	cmpvc	r5, #116, 30	; 0x1d0
     6f4:	67007265 	strvs	r7, [r0, -r5, ror #4]
     6f8:	72656e65 	rsbvc	r6, r5, #1616	; 0x650
     6fc:	64657461 	strbtvs	r7, [r5], #-1121	; 0xfffffb9f
     700:	756f635f 	strbvc	r6, [pc, #-863]!	; 3a9 <shift+0x3a9>
     704:	4300746e 	movwmi	r7, #1134	; 0x46e
     708:	6b636568 	blvs	18d9cb0 <__bss_end+0x18cdbb8>
     70c:	6e696f70 	mcrvs	15, 3, r6, cr9, cr0, {3}
     710:	69770074 	ldmdbvs	r7!, {r2, r4, r5, r6}^
     714:	776f646e 	strbvc	r6, [pc, -lr, ror #8]!
     718:	7a69735f 	bvc	1a5d49c <__bss_end+0x1a513a4>
     71c:	614d0065 	cmpvs	sp, r5, rrx
     720:	44534678 	ldrbmi	r4, [r3], #-1656	; 0xfffff988
     724:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
     728:	6d614e72 	stclvs	14, cr4, [r1, #-456]!	; 0xfffffe38
     72c:	6e654c65 	cdpvs	12, 6, cr4, cr5, cr5, {3}
     730:	00687467 	rsbeq	r7, r8, r7, ror #8
     734:	354e5a5f 	strbcc	r5, [lr, #-2655]	; 0xfffff5a1
     738:	65646f4d 	strbvs	r6, [r4, #-3917]!	; 0xfffff0b3
     73c:	4939316c 	ldmdbmi	r9!, {r2, r3, r5, r6, r8, ip, sp}
     740:	61445f73 	hvcvs	17907	; 0x45f3
     744:	575f6174 			; <UNDEFINED> instruction: 0x575f6174
     748:	6f646e69 	svcvs	0x00646e69
     74c:	75465f77 	strbvc	r5, [r6, #-3959]	; 0xfffff089
     750:	76456c6c 	strbvc	r6, [r5], -ip, ror #24
     754:	636f4c00 	cmnvs	pc, #0, 24
     758:	6e555f6b 	cdpvs	15, 5, cr5, cr5, cr11, {3}
     75c:	6b636f6c 	blvs	18dc514 <__bss_end+0x18d041c>
     760:	5f006465 	svcpl	0x00006465
     764:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     768:	646e6152 	strbtvs	r6, [lr], #-338	; 0xfffffeae
     76c:	475f6d6f 	ldrbmi	r6, [pc, -pc, ror #26]
     770:	72656e65 	rsbvc	r6, r5, #1616	; 0x650
     774:	726f7461 	rsbvc	r7, pc, #1627389952	; 0x61000000
     778:	69453443 	stmdbvs	r5, {r0, r1, r6, sl, ip, sp}^
     77c:	69696969 	stmdbvs	r9!, {r0, r3, r5, r6, r8, fp, sp, lr}^
     780:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     784:	646f4d35 	strbtvs	r4, [pc], #-3381	; 78c <shift+0x78c>
     788:	36316c65 	ldrtcc	r6, [r1], -r5, ror #24
     78c:	6e697250 	mcrvs	2, 3, r7, cr9, cr0, {2}
     790:	61505f74 	cmpvs	r0, r4, ror pc
     794:	656d6172 	strbvs	r6, [sp, #-370]!	; 0xfffffe8e
     798:	73726574 	cmnvc	r2, #116, 10	; 0x1d000000
     79c:	5f007645 	svcpl	0x00007645
     7a0:	4d354e5a 	ldcmi	14, cr4, [r5, #-360]!	; 0xfffffe98
     7a4:	6c65646f 	cfstrdvs	mvd6, [r5], #-444	; 0xfffffe44
     7a8:	61433731 	cmpvs	r3, r1, lsr r7
     7ac:	6c75636c 	ldclvs	3, cr6, [r5], #-432	; 0xfffffe50
     7b0:	5f657461 	svcpl	0x00657461
     7b4:	6e746946 	vsubvs.f16	s13, s8, s12	; <UNPREDICTABLE>
     7b8:	45737365 	ldrbmi	r7, [r3, #-869]!	; 0xfffffc9b
     7bc:	72543950 	subsvc	r3, r4, #80, 18	; 0x140000
     7c0:	73656269 	cmnvc	r5, #-1879048186	; 0x90000006
     7c4:	006e616d 	rsbeq	r6, lr, sp, ror #2
     7c8:	6b636f4c 	blvs	18dc500 <__bss_end+0x18d0408>
     7cc:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
     7d0:	0064656b 	rsbeq	r6, r4, fp, ror #10
     7d4:	64616552 	strbtvs	r6, [r1], #-1362	; 0xfffffaae
     7d8:	7261555f 	rsbvc	r5, r1, #398458880	; 0x17c00000
     7dc:	694c5f74 	stmdbvs	ip, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     7e0:	425f656e 	subsmi	r6, pc, #461373440	; 0x1b800000
     7e4:	6b636f6c 	blvs	18dc59c <__bss_end+0x18d04a4>
     7e8:	00676e69 	rsbeq	r6, r7, r9, ror #28
     7ec:	64616552 	strbtvs	r6, [r1], #-1362	; 0xfffffaae
     7f0:	6972575f 	ldmdbvs	r2!, {r0, r1, r2, r3, r4, r6, r8, r9, sl, ip, lr}^
     7f4:	69006574 	stmdbvs	r0, {r2, r4, r5, r6, r8, sl, sp, lr}
     7f8:	6572636e 	ldrbvs	r6, [r2, #-878]!	; 0xfffffc92
     7fc:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
     800:	7a69735f 	bvc	1a5d584 <__bss_end+0x1a5148c>
     804:	64410065 	strbvs	r0, [r1], #-101	; 0xffffff9b
     808:	79425f64 	stmdbvc	r2, {r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     80c:	00736574 	rsbseq	r6, r3, r4, ror r5
     810:	30315a5f 	eorscc	r5, r1, pc, asr sl
     814:	6d6d7564 	cfstr64vs	mvdx7, [sp, #-400]!	; 0xfffffe70
     818:	61645f79 	smcvs	17913	; 0x45f9
     81c:	66506174 			; <UNDEFINED> instruction: 0x66506174
     820:	706f7000 	rsbvc	r7, pc, r0
     824:	74616c75 	strbtvc	r6, [r1], #-3189	; 0xfffff38b
     828:	006e6f69 	rsbeq	r6, lr, r9, ror #30
     82c:	5078614d 	rsbspl	r6, r8, sp, asr #2
     830:	4c687461 	cfstrdmi	mvd7, [r8], #-388	; 0xfffffe7c
     834:	74676e65 	strbtvc	r6, [r7], #-3685	; 0xfffff19b
     838:	5a5f0068 	bpl	17c09e0 <__bss_end+0x17b48e8>
     83c:	7542364e 	strbvc	r3, [r2, #-1614]	; 0xfffff9b2
     840:	72656666 	rsbvc	r6, r5, #106954752	; 0x6600000
     844:	65523431 	ldrbvs	r3, [r2, #-1073]	; 0xfffffbcf
     848:	555f6461 	ldrbpl	r6, [pc, #-1121]	; 3ef <shift+0x3ef>
     84c:	5f747261 	svcpl	0x00747261
     850:	656e694c 	strbvs	r6, [lr, #-2380]!	; 0xfffff6b4
     854:	75007645 	strvc	r7, [r0, #-1605]	; 0xfffff9bb
     858:	6769736e 	strbvs	r7, [r9, -lr, ror #6]!
     85c:	2064656e 	rsbcs	r6, r4, lr, ror #10
     860:	72616863 	rsbvc	r6, r1, #6488064	; 0x630000
     864:	6d756400 	cfldrdvs	mvd6, [r5, #-0]
     868:	645f796d 	ldrbvs	r7, [pc], #-2413	; 870 <shift+0x870>
     86c:	00617461 	rsbeq	r7, r1, r1, ror #8
     870:	354e5a5f 	strbcc	r5, [lr, #-2655]	; 0xfffff5a1
     874:	65646f4d 	strbvs	r6, [r4, #-3917]!	; 0xfffff0b3
     878:	4330326c 	teqmi	r0, #108, 4	; 0xc0000006
     87c:	75636c61 	strbvc	r6, [r3, #-3169]!	; 0xfffff39f
     880:	6574616c 	ldrbvs	r6, [r4, #-364]!	; 0xfffffe94
     884:	6572505f 	ldrbvs	r5, [r2, #-95]!	; 0xffffffa1
     888:	74636964 	strbtvc	r6, [r3], #-2404	; 0xfffff69c
     88c:	456e6f69 	strbmi	r6, [lr, #-3945]!	; 0xfffff097
     890:	00666650 	rsbeq	r6, r6, r0, asr r6
     894:	75706f70 	ldrbvc	r6, [r0, #-3952]!	; 0xfffff090
     898:	6974616c 	ldmdbvs	r4!, {r2, r3, r5, r6, r8, sp, lr}^
     89c:	635f6e6f 	cmpvs	pc, #1776	; 0x6f0
     8a0:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
     8a4:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     8a8:	65483231 	strbvs	r3, [r8, #-561]	; 0xfffffdcf
     8ac:	4d5f7061 	ldclmi	0, cr7, [pc, #-388]	; 730 <shift+0x730>
     8b0:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     8b4:	35317265 	ldrcc	r7, [r1, #-613]!	; 0xfffffd9b
     8b8:	5f746547 	svcpl	0x00746547
     8bc:	5f6d654d 	svcpl	0x006d654d
     8c0:	72646441 	rsbvc	r6, r4, #1090519040	; 0x41000000
     8c4:	45737365 	ldrbmi	r7, [r3, #-869]!	; 0xfffffc9b
     8c8:	65520076 	ldrbvs	r0, [r2, #-118]	; 0xffffff8a
     8cc:	555f6461 	ldrbpl	r6, [pc, #-1121]	; 473 <shift+0x473>
     8d0:	5f747261 	svcpl	0x00747261
     8d4:	656e694c 	strbvs	r6, [lr, #-2380]!	; 0xfffff6b4
     8d8:	6f687300 	svcvs	0x00687300
     8dc:	69207472 	stmdbvs	r0!, {r1, r4, r5, r6, sl, ip, sp, lr}
     8e0:	7500746e 	strvc	r7, [r0, #-1134]	; 0xfffffb92
     8e4:	5f747261 	svcpl	0x00747261
     8e8:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
     8ec:	6c614300 	stclvs	3, cr4, [r1], #-0
     8f0:	616c7563 	cmnvs	ip, r3, ror #10
     8f4:	465f6574 			; <UNDEFINED> instruction: 0x465f6574
     8f8:	656e7469 	strbvs	r7, [lr, #-1129]!	; 0xfffffb97
     8fc:	46007373 			; <UNDEFINED> instruction: 0x46007373
     900:	74737269 	ldrbtvc	r7, [r3], #-617	; 0xfffffd97
     904:	6e65475f 	mcrvs	7, 3, r4, cr5, cr15, {2}
     908:	74617265 	strbtvc	r7, [r1], #-613	; 0xfffffd9b
     90c:	006e6f69 	rsbeq	r6, lr, r9, ror #30
     910:	6f6c6c41 	svcvs	0x006c6c41
     914:	64410063 	strbvs	r0, [r1], #-99	; 0xffffff9d
     918:	79425f64 	stmdbvc	r2, {r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     91c:	5f006574 	svcpl	0x00006574
     920:	32314e5a 	eorscc	r4, r1, #1440	; 0x5a0
     924:	70616548 	rsbvc	r6, r1, r8, asr #10
     928:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     92c:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     930:	76453443 	strbvc	r3, [r5], -r3, asr #8
     934:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     938:	646f4d35 	strbtvs	r4, [pc], #-3381	; 940 <shift+0x940>
     93c:	36316c65 	ldrtcc	r6, [r1], -r5, ror #24
     940:	5f746547 	svcpl	0x00746547
     944:	61746144 	cmnvs	r4, r4, asr #2
     948:	6d61535f 	stclvs	3, cr5, [r1, #-380]!	; 0xfffffe84
     94c:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
     950:	5f007645 	svcpl	0x00007645
     954:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     958:	646e6152 	strbtvs	r6, [lr], #-338	; 0xfffffeae
     95c:	475f6d6f 	ldrbmi	r6, [pc, -pc, ror #26]
     960:	72656e65 	rsbvc	r6, r5, #1616	; 0x650
     964:	726f7461 	rsbvc	r7, pc, #1627389952	; 0x61000000
     968:	74654739 	strbtvc	r4, [r5], #-1849	; 0xfffff8c7
     96c:	6f6c465f 	svcvs	0x006c465f
     970:	76457461 	strbvc	r7, [r5], -r1, ror #8
     974:	6d657200 	sfmvs	f7, 2, [r5, #-0]
     978:	646e6961 	strbtvs	r6, [lr], #-2401	; 0xfffff69f
     97c:	75007265 	strvc	r7, [r0, #-613]	; 0xfffffd9b
     980:	33746e69 	cmncc	r4, #1680	; 0x690
     984:	00745f32 	rsbseq	r5, r4, r2, lsr pc
     988:	6c617645 	stclvs	6, cr7, [r1], #-276	; 0xfffffeec
     98c:	7274535f 	rsbsvc	r5, r4, #2080374785	; 0x7c000001
     990:	5f676e69 	svcpl	0x00676e69
     994:	6d6d6f43 	stclvs	15, cr6, [sp, #-268]!	; 0xfffffef4
     998:	00646e61 	rsbeq	r6, r4, r1, ror #28
     99c:	364e5a5f 			; <UNDEFINED> instruction: 0x364e5a5f
     9a0:	66667542 	strbtvs	r7, [r6], -r2, asr #10
     9a4:	43357265 	teqmi	r5, #1342177286	; 0x50000006
     9a8:	7261656c 	rsbvc	r6, r1, #108, 10	; 0x1b000000
     9ac:	64007645 	strvs	r7, [r0], #-1605	; 0xfffff9bb
     9b0:	5f617461 	svcpl	0x00617461
     9b4:	6e696f70 	mcrvs	15, 3, r6, cr9, cr0, {3}
     9b8:	00726574 	rsbseq	r6, r2, r4, ror r5
     9bc:	45445f54 	strbmi	r5, [r4, #-3924]	; 0xfffff0ac
     9c0:	5f41544c 	svcpl	0x0041544c
     9c4:	004d554e 	subeq	r5, sp, lr, asr #10
     9c8:	64616552 	strbtvs	r6, [r1], #-1362	; 0xfffffaae
     9cc:	6c6e4f5f 	stclvs	15, cr4, [lr], #-380	; 0xfffffe84
     9d0:	5a5f0079 	bpl	17c0bbc <__bss_end+0x17b4ac4>
     9d4:	7542364e 	strbvc	r3, [r2, #-1614]	; 0xfffff9b2
     9d8:	72656666 	rsbvc	r6, r5, #106954752	; 0x6600000
     9dc:	65523332 	ldrbvs	r3, [r2, #-818]	; 0xfffffcce
     9e0:	555f6461 	ldrbpl	r6, [pc, #-1121]	; 587 <shift+0x587>
     9e4:	5f747261 	svcpl	0x00747261
     9e8:	656e694c 	strbvs	r6, [lr, #-2380]!	; 0xfffff6b4
     9ec:	6f6c425f 	svcvs	0x006c425f
     9f0:	6e696b63 	vnmulvs.f64	d22, d9, d19
     9f4:	00694567 	rsbeq	r4, r9, r7, ror #10
     9f8:	76657270 			; <UNDEFINED> instruction: 0x76657270
     9fc:	73756f69 	cmnvc	r5, #420	; 0x1a4
     a00:	675f796c 	ldrbvs	r7, [pc, -ip, ror #18]
     a04:	72656e65 	rsbvc	r6, r5, #1616	; 0x650
     a08:	64657461 	strbtvs	r7, [r5], #-1121	; 0xfffffb9f
     a0c:	74696600 	strbtvc	r6, [r9], #-1536	; 0xfffffa00
     a10:	7373656e 	cmnvc	r3, #461373440	; 0x1b800000
     a14:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     a18:	66754236 			; <UNDEFINED> instruction: 0x66754236
     a1c:	37726566 	ldrbcc	r6, [r2, -r6, ror #10]!
     a20:	465f7349 	ldrbmi	r7, [pc], -r9, asr #6
     a24:	456c6c75 	strbmi	r6, [ip, #-3189]!	; 0xfffff38b
     a28:	65640076 	strbvs	r0, [r4, #-118]!	; 0xffffff8a
     a2c:	61766972 	cmnvs	r6, r2, ror r9
     a30:	65766974 	ldrbvs	r6, [r6, #-2420]!	; 0xfffff68c
     a34:	6c61765f 	stclvs	6, cr7, [r1], #-380	; 0xfffffe84
     a38:	47006575 	smlsdxmi	r0, r5, r5, r6
     a3c:	4d5f7465 	cfldrdmi	mvd7, [pc, #-404]	; 8b0 <shift+0x8b0>
     a40:	415f6d65 	cmpmi	pc, r5, ror #26
     a44:	65726464 	ldrbvs	r6, [r2, #-1124]!	; 0xfffffb9c
     a48:	53007373 	movwpl	r7, #883	; 0x373
     a4c:	006b7262 	rsbeq	r7, fp, r2, ror #4
     a50:	5f706d74 	svcpl	0x00706d74
     a54:	00727473 	rsbseq	r7, r2, r3, ror r4
     a58:	364e5a5f 			; <UNDEFINED> instruction: 0x364e5a5f
     a5c:	66667542 	strbtvs	r7, [r6], -r2, asr #10
     a60:	49387265 	ldmdbmi	r8!, {r0, r2, r5, r6, r9, ip, sp, lr}
     a64:	6d455f73 	stclvs	15, cr5, [r5, #-460]	; 0xfffffe34
     a68:	45797470 	ldrbmi	r7, [r9, #-1136]!	; 0xfffffb90
     a6c:	64410076 	strbvs	r0, [r1], #-118	; 0xffffff8a
     a70:	61445f64 	cmpvs	r4, r4, ror #30
     a74:	535f6174 	cmppl	pc, #116, 2
     a78:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
     a7c:	5a5f0065 	bpl	17c0c18 <__bss_end+0x17b4b20>
     a80:	6f4d354e 	svcvs	0x004d354e
     a84:	316c6564 	cmncc	ip, r4, ror #10
     a88:	6e654735 	mcrvs	7, 3, r4, cr5, cr5, {1}
     a8c:	6f505f65 	svcvs	0x00505f65
     a90:	505f6c6f 	subspl	r6, pc, pc, ror #24
     a94:	79747261 	ldmdbvc	r4!, {r0, r5, r6, r9, ip, sp, lr}^
     a98:	39505045 	ldmdbcc	r0, {r0, r2, r6, ip, lr}^
     a9c:	62697254 	rsbvs	r7, r9, #84, 4	; 0x40000005
     aa0:	616d7365 	cmnvs	sp, r5, ror #6
     aa4:	7562006e 	strbvc	r0, [r2, #-110]!	; 0xffffff92
     aa8:	72656666 	rsbvc	r6, r5, #106954752	; 0x6600000
     aac:	7a69735f 	bvc	1a5d830 <__bss_end+0x1a51738>
     ab0:	754d0065 	strbvc	r0, [sp, #-101]	; 0xffffff9b
     ab4:	69746174 	ldmdbvs	r4!, {r2, r4, r5, r6, r8, sp, lr}^
     ab8:	54006e6f 	strpl	r6, [r0], #-3695	; 0xfffff191
     abc:	4552505f 	ldrbmi	r5, [r2, #-95]	; 0xffffffa1
     ac0:	554e5f44 	strbpl	r5, [lr, #-3908]	; 0xfffff0bc
     ac4:	6e49004d 	cdpvs	0, 4, cr0, cr9, cr13, {2}
     ac8:	696c6176 	stmdbvs	ip!, {r1, r2, r4, r5, r6, r8, sp, lr}^
     acc:	61485f64 	cmpvs	r8, r4, ror #30
     ad0:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     ad4:	74756f00 	ldrbtvc	r6, [r5], #-3840	; 0xfffff100
     ad8:	6675625f 			; <UNDEFINED> instruction: 0x6675625f
     adc:	00726566 	rsbseq	r6, r2, r6, ror #10
     ae0:	5f6e696d 	svcpl	0x006e696d
     ae4:	61726170 	cmnvs	r2, r0, ror r1
     ae8:	6574656d 	ldrbvs	r6, [r4, #-1389]!	; 0xfffffa93
     aec:	61765f72 	cmnvs	r6, r2, ror pc
     af0:	0065756c 	rsbeq	r7, r5, ip, ror #10
     af4:	5f6d656d 	svcpl	0x006d656d
     af8:	72646461 	rsbvc	r6, r4, #1627389952	; 0x61000000
     afc:	00737365 	rsbseq	r7, r3, r5, ror #6
     b00:	354e5a5f 	strbcc	r5, [lr, #-2655]	; 0xfffff5a1
     b04:	65646f4d 	strbvs	r6, [r4, #-3917]!	; 0xfffff0b3
     b08:	5330316c 	teqpl	r0, #108, 2
     b0c:	425f7465 	subsmi	r7, pc, #1694498816	; 0x65000000
     b10:	65666675 	strbvs	r6, [r6, #-1653]!	; 0xfffff98b
     b14:	36504572 			; <UNDEFINED> instruction: 0x36504572
     b18:	66667542 	strbtvs	r7, [r6], -r2, asr #10
     b1c:	5f007265 	svcpl	0x00007265
     b20:	42364e5a 	eorsmi	r4, r6, #1440	; 0x5a0
     b24:	65666675 	strbvs	r6, [r6, #-1653]!	; 0xfffff98b
     b28:	45344372 	ldrmi	r4, [r4, #-882]!	; 0xfffffc8e
     b2c:	616d006a 	cmnvs	sp, sl, rrx
     b30:	61705f78 	cmnvs	r0, r8, ror pc
     b34:	656d6172 	strbvs	r6, [sp, #-370]!	; 0xfffffe8e
     b38:	5f726574 	svcpl	0x00726574
     b3c:	756c6176 	strbvc	r6, [ip, #-374]!	; 0xfffffe8a
     b40:	5f740065 	svcpl	0x00740065
     b44:	64657270 	strbtvs	r7, [r5], #-624	; 0xfffffd90
     b48:	6e615200 	cdpvs	2, 6, cr5, cr1, cr0, {0}
     b4c:	5f6d6f64 	svcpl	0x006d6f64
     b50:	656e6547 	strbvs	r6, [lr, #-1351]!	; 0xfffffab9
     b54:	6f746172 	svcvs	0x00746172
     b58:	682f0072 	stmdavs	pc!, {r1, r4, r5, r6}	; <UNPREDICTABLE>
     b5c:	2f656d6f 	svccs	0x00656d6f
     b60:	66657274 			; <UNDEFINED> instruction: 0x66657274
     b64:	732f6c69 			; <UNDEFINED> instruction: 0x732f6c69
     b68:	732f6d65 			; <UNDEFINED> instruction: 0x732f6d65
     b6c:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
     b70:	752f7365 	strvc	r7, [pc, #-869]!	; 813 <shift+0x813>
     b74:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
     b78:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
     b7c:	646f6d2f 	strbtvs	r6, [pc], #-3375	; b84 <shift+0xb84>
     b80:	745f6c65 	ldrbvc	r6, [pc], #-3173	; b88 <shift+0xb88>
     b84:	2f6b7361 	svccs	0x006b7361
     b88:	6e69616d 	powvsez	f6, f1, #5.0
     b8c:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
     b90:	645f7400 	ldrbvs	r7, [pc], #-1024	; b98 <shift+0xb98>
     b94:	61746c65 	cmnvs	r4, r5, ror #24
     b98:	69725700 	ldmdbvs	r2!, {r8, r9, sl, ip, lr}^
     b9c:	4f5f6574 	svcmi	0x005f6574
     ba0:	00796c6e 	rsbseq	r6, r9, lr, ror #24
     ba4:	7265706f 	rsbvc	r7, r5, #111	; 0x6f
     ba8:	726f7461 	rsbvc	r7, pc, #1627389952	; 0x61000000
     bac:	77656e20 	strbvc	r6, [r5, -r0, lsr #28]!
     bb0:	6c656800 	stclvs	8, cr6, [r5], #-0
     bb4:	755f6f6c 	ldrbvc	r6, [pc, #-3948]	; fffffc50 <__bss_end+0xffff3b58>
     bb8:	5f747261 	svcpl	0x00747261
     bbc:	6c726f77 	ldclvs	15, cr6, [r2], #-476	; 0xfffffe24
     bc0:	73490064 	movtvc	r0, #36964	; 0x9064
     bc4:	706d455f 	rsbvc	r4, sp, pc, asr r5
     bc8:	49007974 	stmdbmi	r0, {r2, r4, r5, r6, r8, fp, ip, sp, lr}
     bcc:	61445f73 	hvcvs	17907	; 0x45f3
     bd0:	575f6174 			; <UNDEFINED> instruction: 0x575f6174
     bd4:	6f646e69 	svcvs	0x00646e69
     bd8:	75465f77 	strbvc	r5, [r6, #-3959]	; 0xfffff089
     bdc:	5f006c6c 	svcpl	0x00006c6c
     be0:	4d354e5a 	ldcmi	14, cr4, [r5, #-360]!	; 0xfffffe98
     be4:	6c65646f 	cfstrdvs	mvd6, [r5], #-444	; 0xfffffe44
     be8:	69453443 	stmdbvs	r5, {r0, r1, r6, sl, ip, sp}^
     bec:	69696969 	stmdbvs	r9!, {r0, r3, r5, r6, r8, fp, sp, lr}^
     bf0:	6c616d00 	stclvs	13, cr6, [r1], #-0
     bf4:	00636f6c 	rsbeq	r6, r3, ip, ror #30
     bf8:	61726170 	cmnvs	r2, r0, ror r1
     bfc:	6574656d 	ldrbvs	r6, [r4, #-1389]!	; 0xfffffa93
     c00:	6f745f72 	svcvs	0x00745f72
     c04:	74756d5f 	ldrbtvc	r6, [r5], #-3423	; 0xfffff2a1
     c08:	00657461 	rsbeq	r7, r5, r1, ror #8
     c0c:	616e5a5f 	cmnvs	lr, pc, asr sl
     c10:	6e69006a 	cdpvs	0, 6, cr0, cr9, cr10, {3}
     c14:	00786564 	rsbseq	r6, r8, r4, ror #10
     c18:	74726170 	ldrbtvc	r6, [r2], #-368	; 0xfffffe90
     c1c:	74735f79 	ldrbtvc	r5, [r3], #-3961	; 0xfffff087
     c20:	6f00706f 	svcvs	0x0000706f
     c24:	61726570 	cmnvs	r2, r0, ror r5
     c28:	20726f74 	rsbscs	r6, r2, r4, ror pc
     c2c:	2077656e 	rsbscs	r6, r7, lr, ror #10
     c30:	6e005d5b 	mcrvs	13, 0, r5, cr0, cr11, {2}
     c34:	745f7765 	ldrbvc	r7, [pc], #-1893	; c3c <shift+0xc3c>
     c38:	65626972 	strbvs	r6, [r2, #-2418]!	; 0xfffff68e
     c3c:	6e616d73 	mcrvs	13, 3, r6, cr1, cr3, {3}
     c40:	69687400 	stmdbvs	r8!, {sl, ip, sp, lr}^
     c44:	6f6e0073 	svcvs	0x006e0073
     c48:	6e655f74 	mcrvs	15, 3, r5, cr5, cr4, {3}
     c4c:	6867756f 	stmdavs	r7!, {r0, r1, r2, r3, r5, r6, r8, sl, ip, sp, lr}^
     c50:	7461645f 	strbtvc	r6, [r1], #-1119	; 0xfffffba1
     c54:	5f720061 	svcpl	0x00720061
     c58:	65726170 	ldrbvs	r6, [r2, #-368]!	; 0xfffffe90
     c5c:	2f00746e 	svccs	0x0000746e
     c60:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
     c64:	6572742f 	ldrbvs	r7, [r2, #-1071]!	; 0xfffffbd1
     c68:	2f6c6966 	svccs	0x006c6966
     c6c:	2f6d6573 	svccs	0x006d6573
     c70:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
     c74:	2f736563 	svccs	0x00736563
     c78:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
     c7c:	63617073 	cmnvs	r1, #115	; 0x73
     c80:	6f4d2f65 	svcvs	0x004d2f65
     c84:	2f6c6564 	svccs	0x006c6564
     c88:	65646f4d 	strbvs	r6, [r4, #-3917]!	; 0xfffff0b3
     c8c:	70632e6c 	rsbvc	r2, r3, ip, ror #28
     c90:	72630070 	rsbvc	r0, r3, #112	; 0x70
     c94:	5f73736f 	svcpl	0x0073736f
     c98:	6e756f62 	cdpvs	15, 7, cr6, cr5, cr2, {3}
     c9c:	79726164 	ldmdbvc	r2!, {r2, r5, r6, r8, sp, lr}^
     ca0:	6d657400 	cfstrdvs	mvd7, [r5, #-0]
     ca4:	6c665f70 	stclvs	15, cr5, [r6], #-448	; 0xfffffe40
     ca8:	5f74616f 	svcpl	0x0074616f
     cac:	66667562 	strbtvs	r7, [r6], -r2, ror #10
     cb0:	74007265 	strvc	r7, [r0], #-613	; 0xfffffd9b
     cb4:	5f656d69 	svcpl	0x00656d69
     cb8:	66696873 			; <UNDEFINED> instruction: 0x66696873
     cbc:	72700074 	rsbsvc	r0, r0, #116	; 0x74
     cc0:	63696465 	cmnvs	r9, #1694498816	; 0x65000000
     cc4:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     cc8:	705f7900 	subsvc	r7, pc, r0, lsl #18
     ccc:	69646572 	stmdbvs	r4!, {r1, r4, r5, r6, r8, sl, sp, lr}^
     cd0:	64657463 	strbtvs	r7, [r5], #-1123	; 0xfffffb9d
     cd4:	77656e00 	strbvc	r6, [r5, -r0, lsl #28]!
     cd8:	706f705f 	rsbvc	r7, pc, pc, asr r0	; <UNPREDICTABLE>
     cdc:	756f635f 	strbvc	r6, [pc, #-863]!	; 985 <shift+0x985>
     ce0:	7000746e 	andvc	r7, r0, lr, ror #8
     ce4:	6d617261 	sfmvs	f7, 2, [r1, #-388]!	; 0xfffffe7c
     ce8:	656c0073 	strbvs	r0, [ip, #-115]!	; 0xffffff8d
     cec:	705f7466 	subsvc	r7, pc, r6, ror #8
     cf0:	6e657261 	cdpvs	2, 6, cr7, cr5, cr1, {3}
     cf4:	69640074 	stmdbvs	r4!, {r2, r4, r5, r6}^
     cf8:	6c006666 	stcvs	6, cr6, [r0], {102}	; 0x66
     cfc:	7261705f 	rsbvc	r7, r1, #95	; 0x5f
     d00:	00746e65 	rsbseq	r6, r4, r5, ror #28
     d04:	706d6574 	rsbvc	r6, sp, r4, ror r5
     d08:	6675625f 			; <UNDEFINED> instruction: 0x6675625f
     d0c:	00726566 	rsbseq	r6, r2, r6, ror #10
     d10:	64657270 	strbtvs	r7, [r5], #-624	; 0xfffffd90
     d14:	65746369 	ldrbvs	r6, [r4, #-873]!	; 0xfffffc97
     d18:	61765f64 	cmnvs	r6, r4, ror #30
     d1c:	0065756c 	rsbeq	r7, r5, ip, ror #10
     d20:	354e5a5f 	strbcc	r5, [lr, #-2655]	; 0xfffff5a1
     d24:	65646f4d 	strbvs	r6, [r4, #-3917]!	; 0xfffff0b3
     d28:	4532436c 	ldrmi	r4, [r2, #-876]!	; 0xfffffc94
     d2c:	69696969 	stmdbvs	r9!, {r0, r3, r5, r6, r8, fp, sp, lr}^
     d30:	5a5f0069 	bpl	17c0edc <__bss_end+0x17b4de4>
     d34:	6c616d36 	stclvs	13, cr6, [r1], #-216	; 0xffffff28
     d38:	6a636f6c 	bvs	18dcaf0 <__bss_end+0x18d09f8>
     d3c:	66656c00 	strbtvs	r6, [r5], -r0, lsl #24
     d40:	682f0074 	stmdavs	pc!, {r2, r4, r5, r6}	; <UNPREDICTABLE>
     d44:	2f656d6f 	svccs	0x00656d6f
     d48:	66657274 			; <UNDEFINED> instruction: 0x66657274
     d4c:	732f6c69 			; <UNDEFINED> instruction: 0x732f6c69
     d50:	732f6d65 			; <UNDEFINED> instruction: 0x732f6d65
     d54:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
     d58:	752f7365 	strvc	r7, [pc, #-869]!	; 9fb <shift+0x9fb>
     d5c:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
     d60:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
     d64:	646f4d2f 	strbtvs	r4, [pc], #-3375	; d6c <shift+0xd6c>
     d68:	532f6c65 			; <UNDEFINED> instruction: 0x532f6c65
     d6c:	2e74726f 	cdpcs	2, 7, cr7, cr4, cr15, {3}
     d70:	00707063 	rsbseq	r7, r0, r3, rrx
     d74:	34315a5f 	ldrtcc	r5, [r1], #-2655	; 0xfffff5a1
     d78:	74726f53 	ldrbtvc	r6, [r2], #-3923	; 0xfffff0ad
     d7c:	6972545f 	ldmdbvs	r2!, {r0, r1, r2, r3, r4, r6, sl, ip, lr}^
     d80:	6d736562 	cfldr64vs	mvdx6, [r3, #-392]!	; 0xfffffe78
     d84:	50506e61 	subspl	r6, r0, r1, ror #28
     d88:	69725439 	ldmdbvs	r2!, {r0, r3, r4, r5, sl, ip, lr}^
     d8c:	6d736562 	cfldr64vs	mvdx6, [r3, #-392]!	; 0xfffffe78
     d90:	00696e61 	rsbeq	r6, r9, r1, ror #28
     d94:	74726f73 	ldrbtvc	r6, [r2], #-3955	; 0xfffff08d
     d98:	67697200 	strbvs	r7, [r9, -r0, lsl #4]!
     d9c:	73007468 	movwvc	r7, #1128	; 0x468
     da0:	74696c70 	strbtvc	r6, [r9], #-3184	; 0xfffff390
     da4:	726f5300 	rsbvc	r5, pc, #0, 6
     da8:	72545f74 	subsvc	r5, r4, #116, 30	; 0x1d0
     dac:	73656269 	cmnvc	r5, #-1879048186	; 0x90000006
     db0:	006e616d 	rsbeq	r6, lr, sp, ror #2
     db4:	73345a5f 	teqvc	r4, #389120	; 0x5f000
     db8:	5074726f 	rsbspl	r7, r4, pc, ror #4
     dbc:	72543950 	subsvc	r3, r4, #80, 18	; 0x140000
     dc0:	73656269 	cmnvc	r5, #-1879048186	; 0x90000006
     dc4:	696e616d 	stmdbvs	lr!, {r0, r2, r3, r5, r6, r8, sp, lr}^
     dc8:	69700069 	ldmdbvs	r0!, {r0, r3, r5, r6}^
     dcc:	00746f76 	rsbseq	r6, r4, r6, ror pc
     dd0:	73355a5f 	teqvc	r5, #389120	; 0x5f000
     dd4:	74696c70 	strbtvc	r6, [r9], #-3184	; 0xfffff390
     dd8:	54395050 	ldrtpl	r5, [r9], #-80	; 0xffffffb0
     ddc:	65626972 	strbvs	r6, [r2, #-2418]!	; 0xfffff68e
     de0:	6e616d73 	mcrvs	13, 3, r6, cr1, cr3, {3}
     de4:	5f006969 	svcpl	0x00006969
     de8:	6174735f 	cmnvs	r4, pc, asr r3
     dec:	5f636974 	svcpl	0x00636974
     df0:	74696e69 	strbtvc	r6, [r9], #-3689	; 0xfffff197
     df4:	696c6169 	stmdbvs	ip!, {r0, r3, r5, r6, r8, sp, lr}^
     df8:	6974617a 	ldmdbvs	r4!, {r1, r3, r4, r5, r6, r8, sp, lr}^
     dfc:	615f6e6f 	cmpvs	pc, pc, ror #28
     e00:	645f646e 	ldrbvs	r6, [pc], #-1134	; e08 <shift+0xe08>
     e04:	72747365 	rsbsvc	r7, r4, #-1811939327	; 0x94000001
     e08:	69746375 	ldmdbvs	r4!, {r0, r2, r4, r5, r6, r8, r9, sp, lr}^
     e0c:	305f6e6f 	subscc	r6, pc, pc, ror #28
     e10:	4c475f00 	mcrrmi	15, 0, r5, r7, cr0
     e14:	4c41424f 	sfmmi	f4, 2, [r1], {79}	; 0x4f
     e18:	75735f5f 	ldrbvc	r5, [r3, #-3935]!	; 0xfffff0a1
     e1c:	5f495f62 	svcpl	0x00495f62
     e20:	314e5a5f 	cmpcc	lr, pc, asr sl
     e24:	61654832 	cmnvs	r5, r2, lsr r8
     e28:	614d5f70 	hvcvs	54768	; 0xd5f0
     e2c:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     e30:	45324372 	ldrmi	r4, [r2, #-882]!	; 0xfffffc8e
     e34:	682f0076 	stmdavs	pc!, {r1, r2, r4, r5, r6}	; <UNPREDICTABLE>
     e38:	2f656d6f 	svccs	0x00656d6f
     e3c:	66657274 			; <UNDEFINED> instruction: 0x66657274
     e40:	732f6c69 			; <UNDEFINED> instruction: 0x732f6c69
     e44:	732f6d65 			; <UNDEFINED> instruction: 0x732f6d65
     e48:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
     e4c:	622f7365 	eorvs	r7, pc, #-1811939327	; 0x94000001
     e50:	646c6975 	strbtvs	r6, [ip], #-2421	; 0xfffff68b
     e54:	6f682f00 	svcvs	0x00682f00
     e58:	742f656d 	strtvc	r6, [pc], #-1389	; e60 <shift+0xe60>
     e5c:	69666572 	stmdbvs	r6!, {r1, r4, r5, r6, r8, sl, sp, lr}^
     e60:	65732f6c 	ldrbvs	r2, [r3, #-3948]!	; 0xfffff094
     e64:	6f732f6d 	svcvs	0x00732f6d
     e68:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
     e6c:	74732f73 	ldrbtvc	r2, [r3], #-3955	; 0xfffff08d
     e70:	62696c64 	rsbvs	r6, r9, #100, 24	; 0x6400
     e74:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
     e78:	6165482f 	cmnvs	r5, pc, lsr #16
     e7c:	614d5f70 	hvcvs	54768	; 0xd5f0
     e80:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     e84:	70632e72 	rsbvc	r2, r3, r2, ror lr
     e88:	5f5f0070 	svcpl	0x005f0070
     e8c:	74696e69 	strbtvc	r6, [r9], #-3689	; 0xfffff197
     e90:	696c6169 	stmdbvs	ip!, {r0, r3, r5, r6, r8, sp, lr}^
     e94:	705f657a 	subsvc	r6, pc, sl, ror r5	; <UNPREDICTABLE>
     e98:	554e4700 	strbpl	r4, [lr, #-1792]	; 0xfffff900
     e9c:	2b2b4320 	blcs	ad1b24 <__bss_end+0xac5a2c>
     ea0:	31203431 			; <UNDEFINED> instruction: 0x31203431
     ea4:	2e332e30 	mrccs	14, 1, r2, cr3, cr0, {1}
     ea8:	30322031 	eorscc	r2, r2, r1, lsr r0
     eac:	36303132 			; <UNDEFINED> instruction: 0x36303132
     eb0:	28203132 	stmdacs	r0!, {r1, r4, r5, r8, ip, sp}
     eb4:	656c6572 	strbvs	r6, [ip, #-1394]!	; 0xfffffa8e
     eb8:	29657361 	stmdbcs	r5!, {r0, r5, r6, r8, r9, ip, sp, lr}^
     ebc:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
     ec0:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
     ec4:	6962612d 	stmdbvs	r2!, {r0, r2, r3, r5, r8, sp, lr}^
     ec8:	7261683d 	rsbvc	r6, r1, #3997696	; 0x3d0000
     ecc:	6d2d2064 	stcvs	0, cr2, [sp, #-400]!	; 0xfffffe70
     ed0:	3d757066 	ldclcc	0, cr7, [r5, #-408]!	; 0xfffffe68
     ed4:	20706676 	rsbscs	r6, r0, r6, ror r6
     ed8:	6c666d2d 	stclvs	13, cr6, [r6], #-180	; 0xffffff4c
     edc:	2d74616f 	ldfcse	f6, [r4, #-444]!	; 0xfffffe44
     ee0:	3d696261 	sfmcc	f6, 2, [r9, #-388]!	; 0xfffffe7c
     ee4:	64726168 	ldrbtvs	r6, [r2], #-360	; 0xfffffe98
     ee8:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
     eec:	763d7570 			; <UNDEFINED> instruction: 0x763d7570
     ef0:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
     ef4:	6e75746d 	cdpvs	4, 7, cr7, cr5, cr13, {3}
     ef8:	72613d65 	rsbvc	r3, r1, #6464	; 0x1940
     efc:	3731316d 	ldrcc	r3, [r1, -sp, ror #2]!
     f00:	667a6a36 			; <UNDEFINED> instruction: 0x667a6a36
     f04:	2d20732d 	stccs	3, cr7, [r0, #-180]!	; 0xffffff4c
     f08:	6d72616d 	ldfvse	f6, [r2, #-436]!	; 0xfffffe4c
     f0c:	616d2d20 	cmnvs	sp, r0, lsr #26
     f10:	3d686372 	stclcc	3, cr6, [r8, #-456]!	; 0xfffffe38
     f14:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
     f18:	2b6b7a36 	blcs	1adf7f8 <__bss_end+0x1ad3700>
     f1c:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
     f20:	672d2067 	strvs	r2, [sp, -r7, rrx]!
     f24:	20672d20 	rsbcs	r2, r7, r0, lsr #26
     f28:	20304f2d 	eorscs	r4, r0, sp, lsr #30
     f2c:	20304f2d 	eorscs	r4, r0, sp, lsr #30
     f30:	6f6e662d 	svcvs	0x006e662d
     f34:	6378652d 	cmnvs	r8, #188743680	; 0xb400000
     f38:	69747065 	ldmdbvs	r4!, {r0, r2, r5, r6, ip, sp, lr}^
     f3c:	20736e6f 	rsbscs	r6, r3, pc, ror #28
     f40:	6f6e662d 	svcvs	0x006e662d
     f44:	7474722d 	ldrbtvc	r7, [r4], #-557	; 0xfffffdd3
     f48:	64720069 	ldrbtvs	r0, [r2], #-105	; 0xffffff97
     f4c:	006d756e 	rsbeq	r7, sp, lr, ror #10
     f50:	72705f5f 	rsbsvc	r5, r0, #380	; 0x17c
     f54:	69726f69 	ldmdbvs	r2!, {r0, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
     f58:	6e007974 			; <UNDEFINED> instruction: 0x6e007974
     f5c:	72656d75 	rsbvc	r6, r5, #7488	; 0x1d40
     f60:	6172006f 	cmnvs	r2, pc, rrx
     f64:	665f646e 	ldrbvs	r6, [pc], -lr, ror #8
     f68:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
     f6c:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     f70:	61523631 	cmpvs	r2, r1, lsr r6
     f74:	6d6f646e 	cfstrdvs	mvd6, [pc, #-440]!	; dc4 <shift+0xdc4>
     f78:	6e65475f 	mcrvs	7, 3, r4, cr5, cr15, {2}
     f7c:	74617265 	strbtvc	r7, [r1], #-613	; 0xfffffd9b
     f80:	3243726f 	subcc	r7, r3, #-268435450	; 0xf0000006
     f84:	69696945 	stmdbvs	r9!, {r0, r2, r6, r8, fp, sp, lr}^
     f88:	72006969 	andvc	r6, r0, #1720320	; 0x1a4000
     f8c:	00646e61 	rsbeq	r6, r4, r1, ror #28
     f90:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; edc <shift+0xedc>
     f94:	72742f65 	rsbsvc	r2, r4, #404	; 0x194
     f98:	6c696665 	stclvs	6, cr6, [r9], #-404	; 0xfffffe6c
     f9c:	6d65732f 	stclvs	3, cr7, [r5, #-188]!	; 0xffffff44
     fa0:	756f732f 	strbvc	r7, [pc, #-815]!	; c79 <shift+0xc79>
     fa4:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
     fa8:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
     fac:	2f62696c 	svccs	0x0062696c
     fb0:	2f637273 	svccs	0x00637273
     fb4:	646e6152 	strbtvs	r6, [lr], #-338	; 0xfffffeae
     fb8:	632e6d6f 			; <UNDEFINED> instruction: 0x632e6d6f
     fbc:	65007070 	strvs	r7, [r0, #-112]	; 0xffffff90
     fc0:	63657078 	cmnvs	r5, #120	; 0x78
     fc4:	5f646574 	svcpl	0x00646574
     fc8:	65707974 	ldrbvs	r7, [r0, #-2420]!	; 0xfffff68c
     fcc:	6e697500 	cdpvs	5, 6, cr7, cr9, cr0, {0}
     fd0:	5f363174 	svcpl	0x00363174
     fd4:	5a5f0074 	bpl	17c11ac <__bss_end+0x17b50b4>
     fd8:	7542364e 	strbvc	r3, [r2, #-1614]	; 0xfffff9b2
     fdc:	72656666 	rsbvc	r6, r5, #106954752	; 0x6600000
     fe0:	6a453243 	bvs	114d8f4 <__bss_end+0x11417fc>
     fe4:	6e696c00 	cdpvs	12, 6, cr6, cr9, cr0, {0}
     fe8:	6f665f65 	svcvs	0x00665f65
     fec:	00646e75 	rsbeq	r6, r4, r5, ror lr
     ff0:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
     ff4:	7365645f 	cmnvc	r5, #1593835520	; 0x5f000000
     ff8:	756f0063 	strbvc	r0, [pc, #-99]!	; f9d <shift+0xf9d>
     ffc:	75625f74 	strbvc	r5, [r2, #-3956]!	; 0xfffff08c
    1000:	72656666 	rsbvc	r6, r5, #106954752	; 0x6600000
    1004:	6c75665f 	ldclvs	6, cr6, [r5], #-380	; 0xfffffe84
    1008:	682f006c 	stmdavs	pc!, {r2, r3, r5, r6}	; <UNPREDICTABLE>
    100c:	2f656d6f 	svccs	0x00656d6f
    1010:	66657274 			; <UNDEFINED> instruction: 0x66657274
    1014:	732f6c69 			; <UNDEFINED> instruction: 0x732f6c69
    1018:	732f6d65 			; <UNDEFINED> instruction: 0x732f6d65
    101c:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
    1020:	732f7365 			; <UNDEFINED> instruction: 0x732f7365
    1024:	696c6474 	stmdbvs	ip!, {r2, r4, r5, r6, sl, sp, lr}^
    1028:	72732f62 	rsbsvc	r2, r3, #392	; 0x188
    102c:	74732f63 	ldrbtvc	r2, [r3], #-3939	; 0xfffff09d
    1030:	66756264 	ldrbtvs	r6, [r5], -r4, ror #4
    1034:	2e726566 	cdpcs	5, 7, cr6, cr2, cr6, {3}
    1038:	00707063 	rsbseq	r7, r0, r3, rrx
    103c:	6b636954 	blvs	18db594 <__bss_end+0x18cf49c>
    1040:	756f435f 	strbvc	r4, [pc, #-863]!	; ce9 <shift+0xce9>
    1044:	4f00746e 	svcmi	0x0000746e
    1048:	006e6570 	rsbeq	r6, lr, r0, ror r5
    104c:	314e5a5f 	cmpcc	lr, pc, asr sl
    1050:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
    1054:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    1058:	614d5f73 	hvcvs	54771	; 0xd5f3
    105c:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
    1060:	42313272 	eorsmi	r3, r1, #536870919	; 0x20000007
    1064:	6b636f6c 	blvs	18dce1c <__bss_end+0x18d0d24>
    1068:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
    106c:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
    1070:	6f72505f 	svcvs	0x0072505f
    1074:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    1078:	63007645 	movwvs	r7, #1605	; 0x645
    107c:	65736f6c 	ldrbvs	r6, [r3, #-3948]!	; 0xfffff094
    1080:	65727000 	ldrbvs	r7, [r2, #-0]!
    1084:	65530076 	ldrbvs	r0, [r3, #-118]	; 0xffffff8a
    1088:	65525f74 	ldrbvs	r5, [r2, #-3956]	; 0xfffff08c
    108c:	6974616c 	ldmdbvs	r4!, {r2, r3, r5, r6, r8, sp, lr}^
    1090:	55006576 	strpl	r6, [r0, #-1398]	; 0xfffffa8a
    1094:	70616d6e 	rsbvc	r6, r1, lr, ror #26
    1098:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
    109c:	75435f65 	strbvc	r5, [r3, #-3941]	; 0xfffff09b
    10a0:	6e657272 	mcrvs	2, 3, r7, cr5, cr2, {3}
    10a4:	65720074 	ldrbvs	r0, [r2, #-116]!	; 0xffffff8c
    10a8:	6c617674 	stclvs	6, cr7, [r1], #-464	; 0xfffffe30
    10ac:	75636e00 	strbvc	r6, [r3, #-3584]!	; 0xfffff200
    10b0:	614d0072 	hvcvs	53250	; 0xd002
    10b4:	636f6c6c 	cmnvs	pc, #108, 24	; 0x6c00
    10b8:	72506d00 	subsvc	r6, r0, #0, 26
    10bc:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    10c0:	694c5f73 	stmdbvs	ip, {r0, r1, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    10c4:	485f7473 	ldmdami	pc, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
    10c8:	00646165 	rsbeq	r6, r4, r5, ror #2
    10cc:	65706970 	ldrbvs	r6, [r0, #-2416]!	; 0xfffff690
    10d0:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
    10d4:	4336314b 	teqmi	r6, #-1073741806	; 0xc0000012
    10d8:	636f7250 	cmnvs	pc, #80, 4
    10dc:	5f737365 	svcpl	0x00737365
    10e0:	616e614d 	cmnvs	lr, sp, asr #2
    10e4:	31726567 	cmncc	r2, r7, ror #10
    10e8:	74654739 	strbtvc	r4, [r5], #-1849	; 0xfffff8c7
    10ec:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
    10f0:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
    10f4:	6f72505f 	svcvs	0x0072505f
    10f8:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    10fc:	6e007645 	cfmadd32vs	mvax2, mvfx7, mvfx0, mvfx5
    1100:	00747865 	rsbseq	r7, r4, r5, ror #16
    1104:	5f746547 	svcpl	0x00746547
    1108:	636f7250 	cmnvs	pc, #80, 4
    110c:	5f737365 	svcpl	0x00737365
    1110:	505f7942 	subspl	r7, pc, r2, asr #18
    1114:	5f004449 	svcpl	0x00004449
    1118:	7331315a 	teqvc	r1, #-2147483626	; 0x80000016
    111c:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
    1120:	6569795f 	strbvs	r7, [r9, #-2399]!	; 0xfffff6a1
    1124:	0076646c 	rsbseq	r6, r6, ip, ror #8
    1128:	4957534e 	ldmdbmi	r7, {r1, r2, r3, r6, r8, r9, ip, lr}^
    112c:	6f72505f 	svcvs	0x0072505f
    1130:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    1134:	7265535f 	rsbvc	r5, r5, #2080374785	; 0x7c000001
    1138:	65636976 	strbvs	r6, [r3, #-2422]!	; 0xfffff68a
    113c:	61655200 	cmnvs	r5, r0, lsl #4
    1140:	63410064 	movtvs	r0, #4196	; 0x1064
    1144:	65766974 	ldrbvs	r6, [r6, #-2420]!	; 0xfffff68c
    1148:	6f72505f 	svcvs	0x0072505f
    114c:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    1150:	756f435f 	strbvc	r4, [pc, #-863]!	; df9 <shift+0xdf9>
    1154:	4300746e 	movwmi	r7, #1134	; 0x46e
    1158:	74616572 	strbtvc	r6, [r1], #-1394	; 0xfffffa8e
    115c:	72505f65 	subsvc	r5, r0, #404	; 0x194
    1160:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    1164:	5a5f0073 	bpl	17c1338 <__bss_end+0x17b5240>
    1168:	65733731 	ldrbvs	r3, [r3, #-1841]!	; 0xfffff8cf
    116c:	61745f74 	cmnvs	r4, r4, ror pc
    1170:	645f6b73 	ldrbvs	r6, [pc], #-2931	; 1178 <shift+0x1178>
    1174:	6c646165 	stfvse	f6, [r4], #-404	; 0xfffffe6c
    1178:	6a656e69 	bvs	195cb24 <__bss_end+0x1950a2c>
    117c:	69617700 	stmdbvs	r1!, {r8, r9, sl, ip, sp, lr}^
    1180:	74730074 	ldrbtvc	r0, [r3], #-116	; 0xffffff8c
    1184:	00657461 	rsbeq	r7, r5, r1, ror #8
    1188:	6e365a5f 			; <UNDEFINED> instruction: 0x6e365a5f
    118c:	6669746f 	strbtvs	r7, [r9], -pc, ror #8
    1190:	006a6a79 	rsbeq	r6, sl, r9, ror sl
    1194:	5f746547 	svcpl	0x00746547
    1198:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
    119c:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
    11a0:	6e495f72 	mcrvs	15, 2, r5, cr9, cr2, {3}
    11a4:	43006f66 	movwmi	r6, #3942	; 0xf66
    11a8:	636f7250 	cmnvs	pc, #80, 4
    11ac:	5f737365 	svcpl	0x00737365
    11b0:	616e614d 	cmnvs	lr, sp, asr #2
    11b4:	00726567 	rsbseq	r6, r2, r7, ror #10
    11b8:	314e5a5f 	cmpcc	lr, pc, asr sl
    11bc:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
    11c0:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    11c4:	614d5f73 	hvcvs	54771	; 0xd5f3
    11c8:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
    11cc:	47383172 			; <UNDEFINED> instruction: 0x47383172
    11d0:	535f7465 	cmppl	pc, #1694498816	; 0x65000000
    11d4:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
    11d8:	72656c75 	rsbvc	r6, r5, #29952	; 0x7500
    11dc:	666e495f 			; <UNDEFINED> instruction: 0x666e495f
    11e0:	3032456f 	eorscc	r4, r2, pc, ror #10
    11e4:	7465474e 	strbtvc	r4, [r5], #-1870	; 0xfffff8b2
    11e8:	6863535f 	stmdavs	r3!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
    11ec:	495f6465 	ldmdbmi	pc, {r0, r2, r5, r6, sl, sp, lr}^	; <UNPREDICTABLE>
    11f0:	5f6f666e 	svcpl	0x006f666e
    11f4:	65707954 	ldrbvs	r7, [r0, #-2388]!	; 0xfffff6ac
    11f8:	5f007650 	svcpl	0x00007650
    11fc:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
    1200:	6f725043 	svcvs	0x00725043
    1204:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    1208:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
    120c:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
    1210:	61483132 	cmpvs	r8, r2, lsr r1
    1214:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
    1218:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
    121c:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
    1220:	5f6d6574 	svcpl	0x006d6574
    1224:	45495753 	strbmi	r5, [r9, #-1875]	; 0xfffff8ad
    1228:	534e3332 	movtpl	r3, #58162	; 0xe332
    122c:	465f4957 			; <UNDEFINED> instruction: 0x465f4957
    1230:	73656c69 	cmnvc	r5, #26880	; 0x6900
    1234:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
    1238:	65535f6d 	ldrbvs	r5, [r3, #-3949]	; 0xfffff093
    123c:	63697672 	cmnvs	r9, #119537664	; 0x7200000
    1240:	6a6a6a65 	bvs	1a9bbdc <__bss_end+0x1a8fae4>
    1244:	54313152 	ldrtpl	r3, [r1], #-338	; 0xfffffeae
    1248:	5f495753 	svcpl	0x00495753
    124c:	75736552 	ldrbvc	r6, [r3, #-1362]!	; 0xfffffaae
    1250:	6f00746c 	svcvs	0x0000746c
    1254:	656e6570 	strbvs	r6, [lr, #-1392]!	; 0xfffffa90
    1258:	69665f64 	stmdbvs	r6!, {r2, r5, r6, r8, r9, sl, fp, ip, lr}^
    125c:	0073656c 	rsbseq	r6, r3, ip, ror #10
    1260:	6c696146 	stfvse	f6, [r9], #-280	; 0xfffffee8
    1264:	50435400 	subpl	r5, r3, r0, lsl #8
    1268:	6f435f55 	svcvs	0x00435f55
    126c:	7865746e 	stmdavc	r5!, {r1, r2, r3, r5, r6, sl, ip, sp, lr}^
    1270:	65440074 	strbvs	r0, [r4, #-116]	; 0xffffff8c
    1274:	696c6461 	stmdbvs	ip!, {r0, r5, r6, sl, sp, lr}^
    1278:	6500656e 	strvs	r6, [r0, #-1390]	; 0xfffffa92
    127c:	63746978 	cmnvs	r4, #120, 18	; 0x1e0000
    1280:	0065646f 	rsbeq	r6, r5, pc, ror #8
    1284:	72627474 	rsbvc	r7, r2, #116, 8	; 0x74000000
    1288:	5a5f0030 	bpl	17c1350 <__bss_end+0x17b5258>
    128c:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
    1290:	636f7250 	cmnvs	pc, #80, 4
    1294:	5f737365 	svcpl	0x00737365
    1298:	616e614d 	cmnvs	lr, sp, asr #2
    129c:	31726567 	cmncc	r2, r7, ror #10
    12a0:	746f4e34 	strbtvc	r4, [pc], #-3636	; 12a8 <shift+0x12a8>
    12a4:	5f796669 	svcpl	0x00796669
    12a8:	636f7250 	cmnvs	pc, #80, 4
    12ac:	45737365 	ldrbmi	r7, [r3, #-869]!	; 0xfffffc9b
    12b0:	6547006a 	strbvs	r0, [r7, #-106]	; 0xffffff96
    12b4:	49505f74 	ldmdbmi	r0, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    12b8:	6f6e0044 	svcvs	0x006e0044
    12bc:	69666974 	stmdbvs	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
    12c0:	645f6465 	ldrbvs	r6, [pc], #-1125	; 12c8 <shift+0x12c8>
    12c4:	6c646165 	stfvse	f6, [r4], #-404	; 0xfffffe6c
    12c8:	00656e69 	rsbeq	r6, r5, r9, ror #28
    12cc:	314e5a5f 	cmpcc	lr, pc, asr sl
    12d0:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
    12d4:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    12d8:	614d5f73 	hvcvs	54771	; 0xd5f3
    12dc:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
    12e0:	55383172 	ldrpl	r3, [r8, #-370]!	; 0xfffffe8e
    12e4:	70616d6e 	rsbvc	r6, r1, lr, ror #26
    12e8:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
    12ec:	75435f65 	strbvc	r5, [r3, #-3941]	; 0xfffff09b
    12f0:	6e657272 	mcrvs	2, 3, r7, cr5, cr2, {3}
    12f4:	006a4574 	rsbeq	r4, sl, r4, ror r5
    12f8:	314e5a5f 	cmpcc	lr, pc, asr sl
    12fc:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
    1300:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    1304:	614d5f73 	hvcvs	54771	; 0xd5f3
    1308:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
    130c:	4e343172 	mrcmi	1, 1, r3, cr4, cr2, {3}
    1310:	6669746f 	strbtvs	r7, [r9], -pc, ror #8
    1314:	72505f79 	subsvc	r5, r0, #484	; 0x1e4
    1318:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    131c:	31504573 	cmpcc	r0, r3, ror r5
    1320:	61545432 	cmpvs	r4, r2, lsr r4
    1324:	535f6b73 	cmppl	pc, #117760	; 0x1cc00
    1328:	63757274 	cmnvs	r5, #116, 4	; 0x40000007
    132c:	63730074 	cmnvs	r3, #116	; 0x74
    1330:	5f646568 	svcpl	0x00646568
    1334:	6c656979 			; <UNDEFINED> instruction: 0x6c656979
    1338:	69740064 	ldmdbvs	r4!, {r2, r5, r6}^
    133c:	635f6b63 	cmpvs	pc, #101376	; 0x18c00
    1340:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
    1344:	7165725f 	cmnvc	r5, pc, asr r2
    1348:	65726975 	ldrbvs	r6, [r2, #-2421]!	; 0xfffff68b
    134c:	5a5f0064 	bpl	17c14e4 <__bss_end+0x17b53ec>
    1350:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
    1354:	636f7250 	cmnvs	pc, #80, 4
    1358:	5f737365 	svcpl	0x00737365
    135c:	616e614d 	cmnvs	lr, sp, asr #2
    1360:	31726567 	cmncc	r2, r7, ror #10
    1364:	6e755232 	mrcvs	2, 3, r5, cr5, cr2, {1}
    1368:	73726946 	cmnvc	r2, #1146880	; 0x118000
    136c:	73615474 	cmnvc	r1, #116, 8	; 0x74000000
    1370:	0076456b 	rsbseq	r4, r6, fp, ror #10
    1374:	34325a5f 	ldrtcc	r5, [r2], #-2655	; 0xfffff5a1
    1378:	5f746567 	svcpl	0x00746567
    137c:	69746361 	ldmdbvs	r4!, {r0, r5, r6, r8, r9, sp, lr}^
    1380:	705f6576 	subsvc	r6, pc, r6, ror r5	; <UNPREDICTABLE>
    1384:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    1388:	635f7373 	cmpvs	pc, #-872415231	; 0xcc000001
    138c:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
    1390:	65470076 	strbvs	r0, [r7, #-118]	; 0xffffff8a
    1394:	75435f74 	strbvc	r5, [r3, #-3956]	; 0xfffff08c
    1398:	6e657272 	mcrvs	2, 3, r7, cr5, cr2, {3}
    139c:	72505f74 	subsvc	r5, r0, #116, 30	; 0x1d0
    13a0:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    13a4:	69500073 	ldmdbvs	r0, {r0, r1, r4, r5, r6}^
    13a8:	465f6570 			; <UNDEFINED> instruction: 0x465f6570
    13ac:	5f656c69 	svcpl	0x00656c69
    13b0:	66657250 			; <UNDEFINED> instruction: 0x66657250
    13b4:	4d007869 	stcmi	8, cr7, [r0, #-420]	; 0xfffffe5c
    13b8:	465f7061 	ldrbmi	r7, [pc], -r1, rrx
    13bc:	5f656c69 	svcpl	0x00656c69
    13c0:	435f6f54 	cmpmi	pc, #84, 30	; 0x150
    13c4:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
    13c8:	4200746e 	andmi	r7, r0, #1845493760	; 0x6e000000
    13cc:	6b636f6c 	blvs	18dd184 <__bss_end+0x18d108c>
    13d0:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
    13d4:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
    13d8:	6f72505f 	svcvs	0x0072505f
    13dc:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    13e0:	74655300 	strbtvc	r5, [r5], #-768	; 0xfffffd00
    13e4:	7261505f 	rsbvc	r5, r1, #95	; 0x5f
    13e8:	00736d61 	rsbseq	r6, r3, r1, ror #26
    13ec:	34315a5f 	ldrtcc	r5, [r1], #-2655	; 0xfffff5a1
    13f0:	5f746567 	svcpl	0x00746567
    13f4:	6b636974 	blvs	18db9cc <__bss_end+0x18cf8d4>
    13f8:	756f635f 	strbvc	r6, [pc, #-863]!	; 10a1 <shift+0x10a1>
    13fc:	0076746e 	rsbseq	r7, r6, lr, ror #8
    1400:	69676f6c 	stmdbvs	r7!, {r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
    1404:	5f6c6163 	svcpl	0x006c6163
    1408:	61657262 	cmnvs	r5, r2, ror #4
    140c:	6148006b 	cmpvs	r8, fp, rrx
    1410:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
    1414:	6f72505f 	svcvs	0x0072505f
    1418:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    141c:	4957535f 	ldmdbmi	r7, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
    1420:	656c7300 	strbvs	r7, [ip, #-768]!	; 0xfffffd00
    1424:	53007065 	movwpl	r7, #101	; 0x65
    1428:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
    142c:	5f656c75 	svcpl	0x00656c75
    1430:	00464445 	subeq	r4, r6, r5, asr #8
    1434:	74696157 	strbtvc	r6, [r9], #-343	; 0xfffffea9
    1438:	73694400 	cmnvc	r9, #0, 8
    143c:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
    1440:	6576455f 	ldrbvs	r4, [r6, #-1375]!	; 0xfffffaa1
    1444:	445f746e 	ldrbmi	r7, [pc], #-1134	; 144c <shift+0x144c>
    1448:	63657465 	cmnvs	r5, #1694498816	; 0x65000000
    144c:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
    1450:	395a5f00 	ldmdbcc	sl, {r8, r9, sl, fp, ip, lr}^
    1454:	6d726574 	cfldr64vs	mvdx6, [r2, #-464]!	; 0xfffffe30
    1458:	74616e69 	strbtvc	r6, [r1], #-3689	; 0xfffff197
    145c:	49006965 	stmdbmi	r0, {r0, r2, r5, r6, r8, fp, sp, lr}
    1460:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
    1464:	74707572 	ldrbtvc	r7, [r0], #-1394	; 0xfffffa8e
    1468:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
    146c:	656c535f 	strbvs	r5, [ip, #-863]!	; 0xfffffca1
    1470:	6f007065 	svcvs	0x00007065
    1474:	61726570 	cmnvs	r2, r0, ror r5
    1478:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
    147c:	355a5f00 	ldrbcc	r5, [sl, #-3840]	; 0xfffff100
    1480:	736f6c63 	cmnvc	pc, #25344	; 0x6300
    1484:	6d006a65 	vstrvs	s12, [r0, #-404]	; 0xfffffe6c
    1488:	7473614c 	ldrbtvc	r6, [r3], #-332	; 0xfffffeb4
    148c:	4449505f 	strbmi	r5, [r9], #-95	; 0xffffffa1
    1490:	6f6c4200 	svcvs	0x006c4200
    1494:	64656b63 	strbtvs	r6, [r5], #-2915	; 0xfffff49d
    1498:	65474e00 	strbvs	r4, [r7, #-3584]	; 0xfffff200
    149c:	63535f74 	cmpvs	r3, #116, 30	; 0x1d0
    14a0:	5f646568 	svcpl	0x00646568
    14a4:	6f666e49 	svcvs	0x00666e49
    14a8:	7079545f 	rsbsvc	r5, r9, pc, asr r4
    14ac:	5a5f0065 	bpl	17c1648 <__bss_end+0x17b5550>
    14b0:	74656736 	strbtvc	r6, [r5], #-1846	; 0xfffff8ca
    14b4:	76646970 			; <UNDEFINED> instruction: 0x76646970
    14b8:	616e6600 	cmnvs	lr, r0, lsl #12
    14bc:	5200656d 	andpl	r6, r0, #457179136	; 0x1b400000
    14c0:	616e6e75 	smcvs	59109	; 0xe6e5
    14c4:	00656c62 	rsbeq	r6, r5, r2, ror #24
    14c8:	7361544e 	cmnvc	r1, #1308622848	; 0x4e000000
    14cc:	74535f6b 	ldrbvc	r5, [r3], #-3947	; 0xfffff095
    14d0:	00657461 	rsbeq	r7, r5, r1, ror #8
    14d4:	65686373 	strbvs	r6, [r8, #-883]!	; 0xfffffc8d
    14d8:	6f635f64 	svcvs	0x00635f64
    14dc:	65746e75 	ldrbvs	r6, [r4, #-3701]!	; 0xfffff18b
    14e0:	72770072 	rsbsvc	r0, r7, #114	; 0x72
    14e4:	00657469 	rsbeq	r7, r5, r9, ror #8
    14e8:	74697865 	strbtvc	r7, [r9], #-2149	; 0xfffff79b
    14ec:	646f635f 	strbtvs	r6, [pc], #-863	; 14f4 <shift+0x14f4>
    14f0:	5a5f0065 	bpl	17c168c <__bss_end+0x17b5594>
    14f4:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
    14f8:	636f7250 	cmnvs	pc, #80, 4
    14fc:	5f737365 	svcpl	0x00737365
    1500:	616e614d 	cmnvs	lr, sp, asr #2
    1504:	34726567 	ldrbtcc	r6, [r2], #-1383	; 0xfffffa99
    1508:	6b726253 	blvs	1c99e5c <__bss_end+0x1c8dd64>
    150c:	73006a45 	movwvc	r6, #2629	; 0xa45
    1510:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
    1514:	6174735f 	cmnvs	r4, pc, asr r3
    1518:	5f636974 	svcpl	0x00636974
    151c:	6f697270 	svcvs	0x00697270
    1520:	79746972 	ldmdbvc	r4!, {r1, r4, r5, r6, r8, fp, sp, lr}^
    1524:	63697400 	cmnvs	r9, #0, 8
    1528:	6d00736b 	stcvs	3, cr7, [r0, #-428]	; 0xfffffe54
    152c:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
    1530:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
    1534:	636e465f 	cmnvs	lr, #99614720	; 0x5f00000
    1538:	65706f00 	ldrbvs	r6, [r0, #-3840]!	; 0xfffff100
    153c:	5a5f006e 	bpl	17c16fc <__bss_end+0x17b5604>
    1540:	70697034 	rsbvc	r7, r9, r4, lsr r0
    1544:	634b5065 	movtvs	r5, #45157	; 0xb065
    1548:	444e006a 	strbmi	r0, [lr], #-106	; 0xffffff96
    154c:	6c646165 	stfvse	f6, [r4], #-404	; 0xfffffe6c
    1550:	5f656e69 	svcpl	0x00656e69
    1554:	73627553 	cmnvc	r2, #348127232	; 0x14c00000
    1558:	69767265 	ldmdbvs	r6!, {r0, r2, r5, r6, r9, ip, sp, lr}^
    155c:	67006563 	strvs	r6, [r0, -r3, ror #10]
    1560:	745f7465 	ldrbvc	r7, [pc], #-1125	; 1568 <shift+0x1568>
    1564:	5f6b6369 	svcpl	0x006b6369
    1568:	6e756f63 	cdpvs	15, 7, cr6, cr5, cr3, {3}
    156c:	6f4e0074 	svcvs	0x004e0074
    1570:	79666974 	stmdbvc	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
    1574:	72617000 	rsbvc	r7, r1, #0
    1578:	5f006d61 	svcpl	0x00006d61
    157c:	7277355a 	rsbsvc	r3, r7, #377487360	; 0x16800000
    1580:	6a657469 	bvs	195e72c <__bss_end+0x1952634>
    1584:	6a634b50 	bvs	18d42cc <__bss_end+0x18c81d4>
    1588:	6e755200 	cdpvs	2, 7, cr5, cr5, cr0, {0}
    158c:	73726946 	cmnvc	r2, #1146880	; 0x118000
    1590:	73615474 	cmnvc	r1, #116, 8	; 0x74000000
    1594:	6567006b 	strbvs	r0, [r7, #-107]!	; 0xffffff95
    1598:	61745f74 	cmnvs	r4, r4, ror pc
    159c:	745f6b73 	ldrbvc	r6, [pc], #-2931	; 15a4 <shift+0x15a4>
    15a0:	736b6369 	cmnvc	fp, #-1543503871	; 0xa4000001
    15a4:	5f6f745f 	svcpl	0x006f745f
    15a8:	64616564 	strbtvs	r6, [r1], #-1380	; 0xfffffa9c
    15ac:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
    15b0:	66756200 	ldrbtvs	r6, [r5], -r0, lsl #4
    15b4:	7a69735f 	bvc	1a5e338 <__bss_end+0x1a52240>
    15b8:	68700065 	ldmdavs	r0!, {r0, r2, r5, r6}^
    15bc:	63697379 	cmnvs	r9, #-469762047	; 0xe4000001
    15c0:	625f6c61 	subsvs	r6, pc, #24832	; 0x6100
    15c4:	6b616572 	blvs	185ab94 <__bss_end+0x184ea9c>
    15c8:	6d6f5a00 	vstmdbvs	pc!, {s11-s10}
    15cc:	00656962 	rsbeq	r6, r5, r2, ror #18
    15d0:	5f746547 	svcpl	0x00746547
    15d4:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
    15d8:	6e495f64 	cdpvs	15, 4, cr5, cr9, cr4, {3}
    15dc:	73006f66 	movwvc	r6, #3942	; 0xf66
    15e0:	745f7465 	ldrbvc	r7, [pc], #-1125	; 15e8 <shift+0x15e8>
    15e4:	5f6b7361 	svcpl	0x006b7361
    15e8:	64616564 	strbtvs	r6, [r1], #-1380	; 0xfffffa9c
    15ec:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
    15f0:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
    15f4:	50433631 	subpl	r3, r3, r1, lsr r6
    15f8:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    15fc:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 1438 <shift+0x1438>
    1600:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
    1604:	53387265 	teqpl	r8, #1342177286	; 0x50000006
    1608:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
    160c:	45656c75 	strbmi	r6, [r5, #-3189]!	; 0xfffff38b
    1610:	5a5f0076 	bpl	17c17f0 <__bss_end+0x17b56f8>
    1614:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
    1618:	636f7250 	cmnvs	pc, #80, 4
    161c:	5f737365 	svcpl	0x00737365
    1620:	616e614d 	cmnvs	lr, sp, asr #2
    1624:	31726567 	cmncc	r2, r7, ror #10
    1628:	70614d39 	rsbvc	r4, r1, r9, lsr sp
    162c:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
    1630:	6f545f65 	svcvs	0x00545f65
    1634:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
    1638:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
    163c:	49355045 	ldmdbmi	r5!, {r0, r2, r6, ip, lr}
    1640:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
    1644:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
    1648:	7261505f 	rsbvc	r5, r1, #95	; 0x5f
    164c:	00736d61 	rsbseq	r6, r3, r1, ror #26
    1650:	314e5a5f 	cmpcc	lr, pc, asr sl
    1654:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
    1658:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    165c:	614d5f73 	hvcvs	54771	; 0xd5f3
    1660:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
    1664:	53323172 	teqpl	r2, #-2147483620	; 0x8000001c
    1668:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
    166c:	5f656c75 	svcpl	0x00656c75
    1670:	45464445 	strbmi	r4, [r6, #-1093]	; 0xfffffbbb
    1674:	5a5f0076 	bpl	17c1854 <__bss_end+0x17b575c>
    1678:	656c7335 	strbvs	r7, [ip, #-821]!	; 0xfffffccb
    167c:	6a6a7065 	bvs	1a9d818 <__bss_end+0x1a91720>
    1680:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
    1684:	6d65525f 	sfmvs	f5, 2, [r5, #-380]!	; 0xfffffe84
    1688:	696e6961 	stmdbvs	lr!, {r0, r5, r6, r8, fp, sp, lr}^
    168c:	4500676e 	strmi	r6, [r0, #-1902]	; 0xfffff892
    1690:	6c62616e 	stfvse	f6, [r2], #-440	; 0xfffffe48
    1694:	76455f65 	strbvc	r5, [r5], -r5, ror #30
    1698:	5f746e65 	svcpl	0x00746e65
    169c:	65746544 	ldrbvs	r6, [r4, #-1348]!	; 0xfffffabc
    16a0:	6f697463 	svcvs	0x00697463
    16a4:	5a5f006e 	bpl	17c1864 <__bss_end+0x17b576c>
    16a8:	65673632 	strbvs	r3, [r7, #-1586]!	; 0xfffff9ce
    16ac:	61745f74 	cmnvs	r4, r4, ror pc
    16b0:	745f6b73 	ldrbvc	r6, [pc], #-2931	; 16b8 <shift+0x16b8>
    16b4:	736b6369 	cmnvc	fp, #-1543503871	; 0xa4000001
    16b8:	5f6f745f 	svcpl	0x006f745f
    16bc:	64616564 	strbtvs	r6, [r1], #-1380	; 0xfffffa9c
    16c0:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
    16c4:	682f0076 	stmdavs	pc!, {r1, r2, r4, r5, r6}	; <UNPREDICTABLE>
    16c8:	2f656d6f 	svccs	0x00656d6f
    16cc:	66657274 			; <UNDEFINED> instruction: 0x66657274
    16d0:	732f6c69 			; <UNDEFINED> instruction: 0x732f6c69
    16d4:	732f6d65 			; <UNDEFINED> instruction: 0x732f6d65
    16d8:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
    16dc:	732f7365 			; <UNDEFINED> instruction: 0x732f7365
    16e0:	696c6474 	stmdbvs	ip!, {r2, r4, r5, r6, sl, sp, lr}^
    16e4:	72732f62 	rsbsvc	r2, r3, #392	; 0x188
    16e8:	74732f63 	ldrbtvc	r2, [r3], #-3939	; 0xfffff09d
    16ec:	6c696664 	stclvs	6, cr6, [r9], #-400	; 0xfffffe70
    16f0:	70632e65 	rsbvc	r2, r3, r5, ror #28
    16f4:	534e0070 	movtpl	r0, #57456	; 0xe070
    16f8:	525f4957 	subspl	r4, pc, #1425408	; 0x15c000
    16fc:	6c757365 	ldclvs	3, cr7, [r5], #-404	; 0xfffffe6c
    1700:	6f435f74 	svcvs	0x00435f74
    1704:	52006564 	andpl	r6, r0, #100, 10	; 0x19000000
    1708:	696e6e75 	stmdbvs	lr!, {r0, r2, r4, r5, r6, r9, sl, fp, sp, lr}^
    170c:	7700676e 	strvc	r6, [r0, -lr, ror #14]
    1710:	6d756e72 	ldclvs	14, cr6, [r5, #-456]!	; 0xfffffe38
    1714:	345a5f00 	ldrbcc	r5, [sl], #-3840	; 0xfffff100
    1718:	74696177 	strbtvc	r6, [r9], #-375	; 0xfffffe89
    171c:	006a6a6a 	rsbeq	r6, sl, sl, ror #20
    1720:	69355a5f 	ldmdbvs	r5!, {r0, r1, r2, r3, r4, r6, r9, fp, ip, lr}
    1724:	6c74636f 	ldclvs	3, cr6, [r4], #-444	; 0xfffffe44
    1728:	4e36316a 	rsfmisz	f3, f6, #2.0
    172c:	74434f49 	strbvc	r4, [r3], #-3913	; 0xfffff0b7
    1730:	704f5f6c 	subvc	r5, pc, ip, ror #30
    1734:	74617265 	strbtvc	r7, [r1], #-613	; 0xfffffd9b
    1738:	506e6f69 	rsbpl	r6, lr, r9, ror #30
    173c:	6f690076 	svcvs	0x00690076
    1740:	006c7463 	rsbeq	r7, ip, r3, ror #8
    1744:	63746572 	cmnvs	r4, #478150656	; 0x1c800000
    1748:	6d00746e 	cfstrsvs	mvf7, [r0, #-440]	; 0xfffffe48
    174c:	72727543 	rsbsvc	r7, r2, #281018368	; 0x10c00000
    1750:	5f746e65 	svcpl	0x00746e65
    1754:	6b736154 	blvs	1cd9cac <__bss_end+0x1ccdbb4>
    1758:	646f4e5f 	strbtvs	r4, [pc], #-3679	; 1760 <shift+0x1760>
    175c:	6f6e0065 	svcvs	0x006e0065
    1760:	79666974 	stmdbvc	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
    1764:	72657400 	rsbvc	r7, r5, #0, 8
    1768:	616e696d 	cmnvs	lr, sp, ror #18
    176c:	6d006574 	cfstr32vs	mvfx6, [r0, #-464]	; 0xfffffe30
    1770:	0065646f 	rsbeq	r6, r5, pc, ror #8
    1774:	5f757063 	svcpl	0x00757063
    1778:	746e6f63 	strbtvc	r6, [lr], #-3939	; 0xfffff09d
    177c:	00747865 	rsbseq	r7, r4, r5, ror #16
    1780:	65656c73 	strbvs	r6, [r5, #-3187]!	; 0xfffff38d
    1784:	69745f70 	ldmdbvs	r4!, {r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    1788:	0072656d 	rsbseq	r6, r2, sp, ror #10
    178c:	4b4e5a5f 	blmi	1398110 <__bss_end+0x138c018>
    1790:	50433631 	subpl	r3, r3, r1, lsr r6
    1794:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    1798:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 15d4 <shift+0x15d4>
    179c:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
    17a0:	38317265 	ldmdacc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
    17a4:	5f746547 	svcpl	0x00746547
    17a8:	636f7250 	cmnvs	pc, #80, 4
    17ac:	5f737365 	svcpl	0x00737365
    17b0:	505f7942 	subspl	r7, pc, r2, asr #18
    17b4:	6a454449 	bvs	11528e0 <__bss_end+0x11467e8>
    17b8:	6e614800 	cdpvs	8, 6, cr4, cr1, cr0, {0}
    17bc:	5f656c64 	svcpl	0x00656c64
    17c0:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
    17c4:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
    17c8:	535f6d65 	cmppl	pc, #6464	; 0x1940
    17cc:	5f004957 	svcpl	0x00004957
    17d0:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
    17d4:	6f725043 	svcvs	0x00725043
    17d8:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    17dc:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
    17e0:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
    17e4:	63533131 	cmpvs	r3, #1073741836	; 0x4000000c
    17e8:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
    17ec:	525f656c 	subspl	r6, pc, #108, 10	; 0x1b000000
    17f0:	00764552 	rsbseq	r4, r6, r2, asr r5
    17f4:	6b736174 	blvs	1cd9dcc <__bss_end+0x1ccdcd4>
    17f8:	345a5f00 	ldrbcc	r5, [sl], #-3840	; 0xfffff100
    17fc:	64616572 	strbtvs	r6, [r1], #-1394	; 0xfffffa8e
    1800:	6a63506a 	bvs	18d59b0 <__bss_end+0x18c98b8>
    1804:	746f4e00 	strbtvc	r4, [pc], #-3584	; 180c <shift+0x180c>
    1808:	5f796669 	svcpl	0x00796669
    180c:	636f7250 	cmnvs	pc, #80, 4
    1810:	00737365 	rsbseq	r7, r3, r5, ror #6
    1814:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
    1818:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
    181c:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
    1820:	50433631 	subpl	r3, r3, r1, lsr r6
    1824:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    1828:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 1664 <shift+0x1664>
    182c:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
    1830:	53397265 	teqpl	r9, #1342177286	; 0x50000006
    1834:	63746977 	cmnvs	r4, #1949696	; 0x1dc000
    1838:	6f545f68 	svcvs	0x00545f68
    183c:	38315045 	ldmdacc	r1!, {r0, r2, r6, ip, lr}
    1840:	6f725043 	svcvs	0x00725043
    1844:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    1848:	73694c5f 	cmnvc	r9, #24320	; 0x5f00
    184c:	6f4e5f74 	svcvs	0x004e5f74
    1850:	53006564 	movwpl	r6, #1380	; 0x564
    1854:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
    1858:	5f656c75 	svcpl	0x00656c75
    185c:	5f005252 	svcpl	0x00005252
    1860:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
    1864:	6f725043 	svcvs	0x00725043
    1868:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    186c:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
    1870:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
    1874:	61483831 	cmpvs	r8, r1, lsr r8
    1878:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
    187c:	6f72505f 	svcvs	0x0072505f
    1880:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    1884:	4957535f 	ldmdbmi	r7, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
    1888:	4e303245 	cdpmi	2, 3, cr3, cr0, cr5, {2}
    188c:	5f495753 	svcpl	0x00495753
    1890:	636f7250 	cmnvs	pc, #80, 4
    1894:	5f737365 	svcpl	0x00737365
    1898:	76726553 			; <UNDEFINED> instruction: 0x76726553
    189c:	6a656369 	bvs	195a648 <__bss_end+0x194e550>
    18a0:	31526a6a 	cmpcc	r2, sl, ror #20
    18a4:	57535431 	smmlarpl	r3, r1, r4, r5
    18a8:	65525f49 	ldrbvs	r5, [r2, #-3913]	; 0xfffff0b7
    18ac:	746c7573 	strbtvc	r7, [ip], #-1395	; 0xfffffa8d
    18b0:	4f494e00 	svcmi	0x00494e00
    18b4:	5f6c7443 	svcpl	0x006c7443
    18b8:	7265704f 	rsbvc	r7, r5, #79	; 0x4f
    18bc:	6f697461 	svcvs	0x00697461
    18c0:	5a5f006e 	bpl	17c1a80 <__bss_end+0x17b5988>
    18c4:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
    18c8:	636f7250 	cmnvs	pc, #80, 4
    18cc:	5f737365 	svcpl	0x00737365
    18d0:	616e614d 	cmnvs	lr, sp, asr #2
    18d4:	31726567 	cmncc	r2, r7, ror #10
    18d8:	65724334 	ldrbvs	r4, [r2, #-820]!	; 0xfffffccc
    18dc:	5f657461 	svcpl	0x00657461
    18e0:	636f7250 	cmnvs	pc, #80, 4
    18e4:	45737365 	ldrbmi	r7, [r3, #-869]!	; 0xfffffc9b
    18e8:	626a6850 	rsbvs	r6, sl, #80, 16	; 0x500000
    18ec:	69775300 	ldmdbvs	r7!, {r8, r9, ip, lr}^
    18f0:	5f686374 	svcpl	0x00686374
    18f4:	4e006f54 	mcrmi	15, 0, r6, cr0, cr4, {2}
    18f8:	5f495753 	svcpl	0x00495753
    18fc:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
    1900:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
    1904:	535f6d65 	cmppl	pc, #6464	; 0x1940
    1908:	69767265 	ldmdbvs	r6!, {r0, r2, r5, r6, r9, ip, sp, lr}^
    190c:	72006563 	andvc	r6, r0, #415236096	; 0x18c00000
    1910:	6f637465 	svcvs	0x00637465
    1914:	67006564 	strvs	r6, [r0, -r4, ror #10]
    1918:	615f7465 	cmpvs	pc, r5, ror #8
    191c:	76697463 	strbtvc	r7, [r9], -r3, ror #8
    1920:	72705f65 	rsbsvc	r5, r0, #404	; 0x194
    1924:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    1928:	6f635f73 	svcvs	0x00635f73
    192c:	00746e75 	rsbseq	r6, r4, r5, ror lr
    1930:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
    1934:	656d616e 	strbvs	r6, [sp, #-366]!	; 0xfffffe92
    1938:	65724600 	ldrbvs	r4, [r2, #-1536]!	; 0xfffffa00
    193c:	65720065 	ldrbvs	r0, [r2, #-101]!	; 0xffffff9b
    1940:	43006461 	movwmi	r6, #1121	; 0x461
    1944:	65736f6c 	ldrbvs	r6, [r3, #-3948]!	; 0xfffff094
    1948:	61656800 	cmnvs	r5, r0, lsl #16
    194c:	74735f70 	ldrbtvc	r5, [r3], #-3952	; 0xfffff090
    1950:	00747261 	rsbseq	r7, r4, r1, ror #4
    1954:	70746567 	rsbsvc	r6, r4, r7, ror #10
    1958:	5f006469 	svcpl	0x00006469
    195c:	706f345a 	rsbvc	r3, pc, sl, asr r4	; <UNPREDICTABLE>
    1960:	4b506e65 	blmi	141d2fc <__bss_end+0x1411204>
    1964:	4e353163 	rsfmisz	f3, f5, f3
    1968:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
    196c:	65704f5f 	ldrbvs	r4, [r0, #-3935]!	; 0xfffff0a1
    1970:	6f4d5f6e 	svcvs	0x004d5f6e
    1974:	59006564 	stmdbpl	r0, {r2, r5, r6, r8, sl, sp, lr}
    1978:	646c6569 	strbtvs	r6, [ip], #-1385	; 0xfffffa97
    197c:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
    1980:	50433631 	subpl	r3, r3, r1, lsr r6
    1984:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    1988:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 17c4 <shift+0x17c4>
    198c:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
    1990:	34437265 	strbcc	r7, [r3], #-613	; 0xfffffd9b
    1994:	54007645 	strpl	r7, [r0], #-1605	; 0xfffff9bb
    1998:	696d7265 	stmdbvs	sp!, {r0, r2, r5, r6, r9, ip, sp, lr}^
    199c:	6574616e 	ldrbvs	r6, [r4, #-366]!	; 0xfffffe92
    19a0:	434f4900 	movtmi	r4, #63744	; 0xf900
    19a4:	5f006c74 	svcpl	0x00006c74
    19a8:	7473375a 	ldrbtvc	r3, [r3], #-1882	; 0xfffff8a6
    19ac:	70636e72 	rsbvc	r6, r3, r2, ror lr
    19b0:	50635079 	rsbpl	r5, r3, r9, ror r0
    19b4:	0069634b 	rsbeq	r6, r9, fp, asr #6
    19b8:	6d365a5f 	vldmdbvs	r6!, {s10-s104}
    19bc:	70636d65 	rsbvc	r6, r3, r5, ror #26
    19c0:	764b5079 			; <UNDEFINED> instruction: 0x764b5079
    19c4:	00697650 	rsbeq	r7, r9, r0, asr r6
    19c8:	34315a5f 	ldrtcc	r5, [r1], #-2655	; 0xfffff5a1
    19cc:	5f746567 	svcpl	0x00746567
    19d0:	75706e69 	ldrbvc	r6, [r0, #-3689]!	; 0xfffff197
    19d4:	79745f74 	ldmdbvc	r4!, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    19d8:	4b506570 	blmi	141afa0 <__bss_end+0x140eea8>
    19dc:	5a5f0063 	bpl	17c1b70 <__bss_end+0x17b5a78>
    19e0:	745f6e34 	ldrbvc	r6, [pc], #-3636	; 19e8 <shift+0x19e8>
    19e4:	00696975 	rsbeq	r6, r9, r5, ror r9
    19e8:	666f7461 	strbtvs	r7, [pc], -r1, ror #8
    19ec:	74656700 	strbtvc	r6, [r5], #-1792	; 0xfffff900
    19f0:	706e695f 	rsbvc	r6, lr, pc, asr r9
    19f4:	745f7475 	ldrbvc	r7, [pc], #-1141	; 19fc <shift+0x19fc>
    19f8:	00657079 	rsbeq	r7, r5, r9, ror r0
    19fc:	696f7461 	stmdbvs	pc!, {r0, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
    1a00:	345a5f00 	ldrbcc	r5, [sl], #-3840	; 0xfffff100
    1a04:	666f7461 	strbtvs	r7, [pc], -r1, ror #8
    1a08:	00634b50 	rsbeq	r4, r3, r0, asr fp
    1a0c:	74736564 	ldrbtvc	r6, [r3], #-1380	; 0xfffffa9c
    1a10:	706e6900 	rsbvc	r6, lr, r0, lsl #18
    1a14:	73007475 	movwvc	r7, #1141	; 0x475
    1a18:	006e6769 	rsbeq	r6, lr, r9, ror #14
    1a1c:	63727473 	cmnvs	r2, #1929379840	; 0x73000000
    1a20:	5f007461 	svcpl	0x00007461
    1a24:	7a62355a 	bvc	188ef94 <__bss_end+0x1882e9c>
    1a28:	506f7265 	rsbpl	r7, pc, r5, ror #4
    1a2c:	73006976 	movwvc	r6, #2422	; 0x976
    1a30:	636e7274 	cmnvs	lr, #116, 4	; 0x40000007
    1a34:	5f007970 	svcpl	0x00007970
    1a38:	7473365a 	ldrbtvc	r3, [r3], #-1626	; 0xfffff9a6
    1a3c:	74616372 	strbtvc	r6, [r1], #-882	; 0xfffffc8e
    1a40:	4b506350 	blmi	141a788 <__bss_end+0x140e690>
    1a44:	682f0063 	stmdavs	pc!, {r0, r1, r5, r6}	; <UNPREDICTABLE>
    1a48:	2f656d6f 	svccs	0x00656d6f
    1a4c:	66657274 			; <UNDEFINED> instruction: 0x66657274
    1a50:	732f6c69 			; <UNDEFINED> instruction: 0x732f6c69
    1a54:	732f6d65 			; <UNDEFINED> instruction: 0x732f6d65
    1a58:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
    1a5c:	732f7365 			; <UNDEFINED> instruction: 0x732f7365
    1a60:	696c6474 	stmdbvs	ip!, {r2, r4, r5, r6, sl, sp, lr}^
    1a64:	72732f62 	rsbsvc	r2, r3, #392	; 0x188
    1a68:	74732f63 	ldrbtvc	r2, [r3], #-3939	; 0xfffff09d
    1a6c:	72747364 	rsbsvc	r7, r4, #100, 6	; 0x90000001
    1a70:	2e676e69 	cdpcs	14, 6, cr6, cr7, cr9, {3}
    1a74:	00707063 	rsbseq	r7, r0, r3, rrx
    1a78:	6e727473 	mrcvs	4, 3, r7, cr2, cr3, {3}
    1a7c:	00746163 	rsbseq	r6, r4, r3, ror #2
    1a80:	6b6c6177 	blvs	1b1a064 <__bss_end+0x1b0df6c>
    1a84:	66007265 	strvs	r7, [r0], -r5, ror #4
    1a88:	6f746361 	svcvs	0x00746361
    1a8c:	74690072 	strbtvc	r0, [r9], #-114	; 0xffffff8e
    1a90:	7000616f 	andvc	r6, r0, pc, ror #2
    1a94:	7469736f 	strbtvc	r7, [r9], #-879	; 0xfffffc91
    1a98:	006e6f69 	rsbeq	r6, lr, r9, ror #30
    1a9c:	646d656d 	strbtvs	r6, [sp], #-1389	; 0xfffffa93
    1aa0:	43007473 	movwmi	r7, #1139	; 0x473
    1aa4:	43726168 	cmnmi	r2, #104, 2
    1aa8:	41766e6f 	cmnmi	r6, pc, ror #28
    1aac:	66007272 			; <UNDEFINED> instruction: 0x66007272
    1ab0:	00616f74 	rsbeq	r6, r1, r4, ror pc
    1ab4:	626d756e 	rsbvs	r7, sp, #461373440	; 0x1b800000
    1ab8:	6d007265 	sfmvs	f7, 4, [r0, #-404]	; 0xfffffe6c
    1abc:	72736d65 	rsbsvc	r6, r3, #6464	; 0x1940
    1ac0:	756e0063 	strbvc	r0, [lr, #-99]!	; 0xffffff9d
    1ac4:	7265626d 	rsbvc	r6, r5, #-805306362	; 0xd0000006
    1ac8:	66610032 			; <UNDEFINED> instruction: 0x66610032
    1acc:	44726574 	ldrbtmi	r6, [r2], #-1396	; 0xfffffa8c
    1ad0:	6f506365 	svcvs	0x00506365
    1ad4:	00746e69 	rsbseq	r6, r4, r9, ror #28
    1ad8:	72657a62 	rsbvc	r7, r5, #401408	; 0x62000
    1adc:	656d006f 	strbvs	r0, [sp, #-111]!	; 0xffffff91
    1ae0:	7970636d 	ldmdbvc	r0!, {r0, r2, r3, r5, r6, r8, r9, sp, lr}^
    1ae4:	72747300 	rsbsvc	r7, r4, #0, 6
    1ae8:	706d636e 	rsbvc	r6, sp, lr, ror #6
    1aec:	61727400 	cmnvs	r2, r0, lsl #8
    1af0:	6e696c69 	cdpvs	12, 6, cr6, cr9, cr9, {3}
    1af4:	6f645f67 	svcvs	0x00645f67
    1af8:	756f0074 	strbvc	r0, [pc, #-116]!	; 1a8c <shift+0x1a8c>
    1afc:	74757074 	ldrbtvc	r7, [r5], #-116	; 0xffffff8c
    1b00:	6e656c00 	cdpvs	12, 6, cr6, cr5, cr0, {0}
    1b04:	32687467 	rsbcc	r7, r8, #1728053248	; 0x67000000
    1b08:	745f6e00 	ldrbvc	r6, [pc], #-3584	; 1b10 <shift+0x1b10>
    1b0c:	5a5f0075 	bpl	17c1ce8 <__bss_end+0x17b5bf0>
    1b10:	72747336 	rsbsvc	r7, r4, #-671088640	; 0xd8000000
    1b14:	506e656c 	rsbpl	r6, lr, ip, ror #10
    1b18:	5f00634b 	svcpl	0x0000634b
    1b1c:	7473375a 	ldrbtvc	r3, [r3], #-1882	; 0xfffff8a6
    1b20:	6d636e72 	stclvs	14, cr6, [r3, #-456]!	; 0xfffffe38
    1b24:	634b5070 	movtvs	r5, #45168	; 0xb070
    1b28:	695f3053 	ldmdbvs	pc, {r0, r1, r4, r6, ip, sp}^	; <UNPREDICTABLE>
    1b2c:	345a5f00 	ldrbcc	r5, [sl], #-3840	; 0xfffff100
    1b30:	696f7461 	stmdbvs	pc!, {r0, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
    1b34:	00634b50 	rsbeq	r4, r3, r0, asr fp
    1b38:	69345a5f 	ldmdbvs	r4!, {r0, r1, r2, r3, r4, r6, r9, fp, ip, lr}
    1b3c:	69616f74 	stmdbvs	r1!, {r2, r4, r5, r6, r8, r9, sl, fp, sp, lr}^
    1b40:	006a6350 	rsbeq	r6, sl, r0, asr r3
    1b44:	66345a5f 			; <UNDEFINED> instruction: 0x66345a5f
    1b48:	66616f74 	uqsub16vs	r6, r1, r4
    1b4c:	6d006350 	stcvs	3, cr6, [r0, #-320]	; 0xfffffec0
    1b50:	726f6d65 	rsbvc	r6, pc, #6464	; 0x1940
    1b54:	656c0079 	strbvs	r0, [ip, #-121]!	; 0xffffff87
    1b58:	6874676e 	ldmdavs	r4!, {r1, r2, r3, r5, r6, r8, r9, sl, sp, lr}^
    1b5c:	72747300 	rsbsvc	r7, r4, #0, 6
    1b60:	006e656c 	rsbeq	r6, lr, ip, ror #10
    1b64:	73375a5f 	teqvc	r7, #389120	; 0x5f000
    1b68:	636e7274 	cmnvs	lr, #116, 4	; 0x40000007
    1b6c:	63507461 	cmpvs	r0, #1627389952	; 0x61000000
    1b70:	69634b50 	stmdbvs	r3!, {r4, r6, r8, r9, fp, lr}^
    1b74:	2f2e2e00 	svccs	0x002e2e00
    1b78:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1b7c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1b80:	2f2e2e2f 	svccs	0x002e2e2f
    1b84:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; 1ad4 <shift+0x1ad4>
    1b88:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    1b8c:	6f632f63 	svcvs	0x00632f63
    1b90:	6769666e 	strbvs	r6, [r9, -lr, ror #12]!
    1b94:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
    1b98:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
    1b9c:	6e756631 	mrcvs	6, 3, r6, cr5, cr1, {1}
    1ba0:	532e7363 			; <UNDEFINED> instruction: 0x532e7363
    1ba4:	75622f00 	strbvc	r2, [r2, #-3840]!	; 0xfffff100
    1ba8:	2f646c69 	svccs	0x00646c69
    1bac:	2d636367 	stclcs	3, cr6, [r3, #-412]!	; 0xfffffe64
    1bb0:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
    1bb4:	656e6f6e 	strbvs	r6, [lr, #-3950]!	; 0xfffff092
    1bb8:	6261652d 	rsbvs	r6, r1, #188743680	; 0xb400000
    1bbc:	59682d69 	stmdbpl	r8!, {r0, r3, r5, r6, r8, sl, fp, sp}^
    1bc0:	344b6766 	strbcc	r6, [fp], #-1894	; 0xfffff89a
    1bc4:	6363672f 	cmnvs	r3, #12320768	; 0xbc0000
    1bc8:	6d72612d 	ldfvse	f6, [r2, #-180]!	; 0xffffff4c
    1bcc:	6e6f6e2d 	cdpvs	14, 6, cr6, cr15, cr13, {1}
    1bd0:	61652d65 	cmnvs	r5, r5, ror #26
    1bd4:	312d6962 			; <UNDEFINED> instruction: 0x312d6962
    1bd8:	2d332e30 	ldccs	14, cr2, [r3, #-192]!	; 0xffffff40
    1bdc:	31323032 	teqcc	r2, r2, lsr r0
    1be0:	2f37302e 	svccs	0x0037302e
    1be4:	6c697562 	cfstr64vs	mvdx7, [r9], #-392	; 0xfffffe78
    1be8:	72612f64 	rsbvc	r2, r1, #100, 30	; 0x190
    1bec:	6f6e2d6d 	svcvs	0x006e2d6d
    1bf0:	652d656e 	strvs	r6, [sp, #-1390]!	; 0xfffffa92
    1bf4:	2f696261 	svccs	0x00696261
    1bf8:	2f6d7261 	svccs	0x006d7261
    1bfc:	65743576 	ldrbvs	r3, [r4, #-1398]!	; 0xfffffa8a
    1c00:	7261682f 	rsbvc	r6, r1, #3080192	; 0x2f0000
    1c04:	696c2f64 	stmdbvs	ip!, {r2, r5, r6, r8, r9, sl, fp, sp}^
    1c08:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    1c0c:	554e4700 	strbpl	r4, [lr, #-1792]	; 0xfffff900
    1c10:	20534120 	subscs	r4, r3, r0, lsr #2
    1c14:	37332e32 			; <UNDEFINED> instruction: 0x37332e32
    1c18:	2f2e2e00 	svccs	0x002e2e00
    1c1c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1c20:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1c24:	2f2e2e2f 	svccs	0x002e2e2f
    1c28:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; 1b78 <shift+0x1b78>
    1c2c:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    1c30:	6f632f63 	svcvs	0x00632f63
    1c34:	6769666e 	strbvs	r6, [r9, -lr, ror #12]!
    1c38:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
    1c3c:	6565692f 	strbvs	r6, [r5, #-2351]!	; 0xfffff6d1
    1c40:	34353765 	ldrtcc	r3, [r5], #-1893	; 0xfffff89b
    1c44:	2e66732d 	cdpcs	3, 6, cr7, cr6, cr13, {1}
    1c48:	2e2e0053 	mcrcs	0, 1, r0, cr14, cr3, {2}
    1c4c:	2f2e2e2f 	svccs	0x002e2e2f
    1c50:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1c54:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1c58:	2f2e2e2f 	svccs	0x002e2e2f
    1c5c:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    1c60:	632f6363 			; <UNDEFINED> instruction: 0x632f6363
    1c64:	69666e6f 	stmdbvs	r6!, {r0, r1, r2, r3, r5, r6, r9, sl, fp, sp, lr}^
    1c68:	72612f67 	rsbvc	r2, r1, #412	; 0x19c
    1c6c:	70622f6d 	rsbvc	r2, r2, sp, ror #30
    1c70:	2e696261 	cdpcs	2, 6, cr6, cr9, cr1, {3}
    1c74:	73690053 	cmnvc	r9, #83	; 0x53
    1c78:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1c7c:	72705f74 	rsbsvc	r5, r0, #116, 30	; 0x1d0
    1c80:	65726465 	ldrbvs	r6, [r2, #-1125]!	; 0xfffffb9b
    1c84:	73690073 	cmnvc	r9, #115	; 0x73
    1c88:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1c8c:	66765f74 	uhsub16vs	r5, r6, r4
    1c90:	61625f70 	smcvs	9712	; 0x25f0
    1c94:	63006573 	movwvs	r6, #1395	; 0x573
    1c98:	6c706d6f 	ldclvs	13, cr6, [r0], #-444	; 0xfffffe44
    1c9c:	66207865 	strtvs	r7, [r0], -r5, ror #16
    1ca0:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
    1ca4:	61736900 	cmnvs	r3, r0, lsl #18
    1ca8:	626f6e5f 	rsbvs	r6, pc, #1520	; 0x5f0
    1cac:	69007469 	stmdbvs	r0, {r0, r3, r5, r6, sl, ip, sp, lr}
    1cb0:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1cb4:	6d5f7469 	cfldrdvs	mvd7, [pc, #-420]	; 1b18 <shift+0x1b18>
    1cb8:	665f6576 			; <UNDEFINED> instruction: 0x665f6576
    1cbc:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
    1cc0:	61736900 	cmnvs	r3, r0, lsl #18
    1cc4:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1cc8:	3170665f 	cmncc	r0, pc, asr r6
    1ccc:	73690036 	cmnvc	r9, #54	; 0x36
    1cd0:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1cd4:	65735f74 	ldrbvs	r5, [r3, #-3956]!	; 0xfffff08c
    1cd8:	73690063 	cmnvc	r9, #99	; 0x63
    1cdc:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1ce0:	64615f74 	strbtvs	r5, [r1], #-3956	; 0xfffff08c
    1ce4:	69007669 	stmdbvs	r0, {r0, r3, r5, r6, r9, sl, ip, sp, lr}
    1ce8:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1cec:	715f7469 	cmpvc	pc, r9, ror #8
    1cf0:	6b726975 	blvs	1c9c2cc <__bss_end+0x1c901d4>
    1cf4:	5f6f6e5f 	svcpl	0x006f6e5f
    1cf8:	616c6f76 	smcvs	50934	; 0xc6f6
    1cfc:	656c6974 	strbvs	r6, [ip, #-2420]!	; 0xfffff68c
    1d00:	0065635f 	rsbeq	r6, r5, pc, asr r3
    1d04:	5f617369 	svcpl	0x00617369
    1d08:	5f746962 	svcpl	0x00746962
    1d0c:	6900706d 	stmdbvs	r0, {r0, r2, r3, r5, r6, ip, sp, lr}
    1d10:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1d14:	615f7469 	cmpvs	pc, r9, ror #8
    1d18:	35766d72 	ldrbcc	r6, [r6, #-3442]!	; 0xfffff28e
    1d1c:	73690074 	cmnvc	r9, #116	; 0x74
    1d20:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1d24:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    1d28:	7435766d 	ldrtvc	r7, [r5], #-1645	; 0xfffff993
    1d2c:	73690065 	cmnvc	r9, #101	; 0x65
    1d30:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1d34:	656e5f74 	strbvs	r5, [lr, #-3956]!	; 0xfffff08c
    1d38:	69006e6f 	stmdbvs	r0, {r0, r1, r2, r3, r5, r6, r9, sl, fp, sp, lr}
    1d3c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1d40:	625f7469 	subsvs	r7, pc, #1761607680	; 0x69000000
    1d44:	00363166 	eorseq	r3, r6, r6, ror #2
    1d48:	43535046 	cmpmi	r3, #70	; 0x46
    1d4c:	4e455f52 	mcrmi	15, 2, r5, cr5, cr2, {2}
    1d50:	46004d55 			; <UNDEFINED> instruction: 0x46004d55
    1d54:	52435350 	subpl	r5, r3, #80, 6	; 0x40000001
    1d58:	637a6e5f 	cmnvs	sl, #1520	; 0x5f0
    1d5c:	5f637176 	svcpl	0x00637176
    1d60:	4d554e45 	ldclmi	14, cr4, [r5, #-276]	; 0xfffffeec
    1d64:	52505600 	subspl	r5, r0, #0, 12
    1d68:	554e455f 	strbpl	r4, [lr, #-1375]	; 0xfffffaa1
    1d6c:	6266004d 	rsbvs	r0, r6, #77	; 0x4d
    1d70:	695f7469 	ldmdbvs	pc, {r0, r3, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
    1d74:	696c706d 	stmdbvs	ip!, {r0, r2, r3, r5, r6, ip, sp, lr}^
    1d78:	69746163 	ldmdbvs	r4!, {r0, r1, r5, r6, r8, sp, lr}^
    1d7c:	50006e6f 	andpl	r6, r0, pc, ror #28
    1d80:	4e455f30 	mcrmi	15, 2, r5, cr5, cr0, {1}
    1d84:	69004d55 	stmdbvs	r0, {r0, r2, r4, r6, r8, sl, fp, lr}
    1d88:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1d8c:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
    1d90:	74707972 	ldrbtvc	r7, [r0], #-2418	; 0xfffff68e
    1d94:	4e47006f 	cdpmi	0, 4, cr0, cr7, cr15, {3}
    1d98:	31432055 	qdaddcc	r2, r5, r3
    1d9c:	30312037 	eorscc	r2, r1, r7, lsr r0
    1da0:	312e332e 			; <UNDEFINED> instruction: 0x312e332e
    1da4:	32303220 	eorscc	r3, r0, #32, 4
    1da8:	32363031 	eorscc	r3, r6, #49	; 0x31
    1dac:	72282031 	eorvc	r2, r8, #49	; 0x31
    1db0:	61656c65 	cmnvs	r5, r5, ror #24
    1db4:	20296573 	eorcs	r6, r9, r3, ror r5
    1db8:	72616d2d 	rsbvc	r6, r1, #2880	; 0xb40
    1dbc:	6d2d206d 	stcvs	0, cr2, [sp, #-436]!	; 0xfffffe4c
    1dc0:	616f6c66 	cmnvs	pc, r6, ror #24
    1dc4:	62612d74 	rsbvs	r2, r1, #116, 26	; 0x1d00
    1dc8:	61683d69 	cmnvs	r8, r9, ror #26
    1dcc:	2d206472 	cfstrscs	mvf6, [r0, #-456]!	; 0xfffffe38
    1dd0:	6372616d 	cmnvs	r2, #1073741851	; 0x4000001b
    1dd4:	72613d68 	rsbvc	r3, r1, #104, 26	; 0x1a00
    1dd8:	7435766d 	ldrtvc	r7, [r5], #-1645	; 0xfffff993
    1ddc:	70662b65 	rsbvc	r2, r6, r5, ror #22
    1de0:	20672d20 	rsbcs	r2, r7, r0, lsr #26
    1de4:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
    1de8:	4f2d2067 	svcmi	0x002d2067
    1dec:	4f2d2032 	svcmi	0x002d2032
    1df0:	4f2d2032 	svcmi	0x002d2032
    1df4:	662d2032 			; <UNDEFINED> instruction: 0x662d2032
    1df8:	6c697562 	cfstr64vs	mvdx7, [r9], #-392	; 0xfffffe78
    1dfc:	676e6964 	strbvs	r6, [lr, -r4, ror #18]!
    1e00:	62696c2d 	rsbvs	r6, r9, #11520	; 0x2d00
    1e04:	20636367 	rsbcs	r6, r3, r7, ror #6
    1e08:	6f6e662d 	svcvs	0x006e662d
    1e0c:	6174732d 	cmnvs	r4, sp, lsr #6
    1e10:	702d6b63 	eorvc	r6, sp, r3, ror #22
    1e14:	65746f72 	ldrbvs	r6, [r4, #-3954]!	; 0xfffff08e
    1e18:	726f7463 	rsbvc	r7, pc, #1660944384	; 0x63000000
    1e1c:	6e662d20 	cdpvs	13, 6, cr2, cr6, cr0, {1}
    1e20:	6e692d6f 	cdpvs	13, 6, cr2, cr9, cr15, {3}
    1e24:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
    1e28:	76662d20 	strbtvc	r2, [r6], -r0, lsr #26
    1e2c:	62697369 	rsbvs	r7, r9, #-1543503871	; 0xa4000001
    1e30:	74696c69 	strbtvc	r6, [r9], #-3177	; 0xfffff397
    1e34:	69683d79 	stmdbvs	r8!, {r0, r3, r4, r5, r6, r8, sl, fp, ip, sp}^
    1e38:	6e656464 	cdpvs	4, 6, cr6, cr5, cr4, {3}
    1e3c:	61736900 	cmnvs	r3, r0, lsl #18
    1e40:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1e44:	6964745f 	stmdbvs	r4!, {r0, r1, r2, r3, r4, r6, sl, ip, sp, lr}^
    1e48:	6f630076 	svcvs	0x00630076
    1e4c:	6900736e 	stmdbvs	r0, {r1, r2, r3, r5, r6, r8, r9, ip, sp, lr}
    1e50:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1e54:	695f7469 	ldmdbvs	pc, {r0, r3, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
    1e58:	786d6d77 	stmdavc	sp!, {r0, r1, r2, r4, r5, r6, r8, sl, fp, sp, lr}^
    1e5c:	50460074 	subpl	r0, r6, r4, ror r0
    1e60:	53545843 	cmppl	r4, #4390912	; 0x430000
    1e64:	554e455f 	strbpl	r4, [lr, #-1375]	; 0xfffffaa1
    1e68:	7369004d 	cmnvc	r9, #77	; 0x4d
    1e6c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1e70:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    1e74:	0036766d 	eorseq	r7, r6, sp, ror #12
    1e78:	5f617369 	svcpl	0x00617369
    1e7c:	5f746962 	svcpl	0x00746962
    1e80:	0065766d 	rsbeq	r7, r5, sp, ror #12
    1e84:	5f617369 	svcpl	0x00617369
    1e88:	5f746962 	svcpl	0x00746962
    1e8c:	6d6d7769 	stclvs	7, cr7, [sp, #-420]!	; 0xfffffe5c
    1e90:	00327478 	eorseq	r7, r2, r8, ror r4
    1e94:	5f617369 	svcpl	0x00617369
    1e98:	5f746962 	svcpl	0x00746962
    1e9c:	63656463 	cmnvs	r5, #1660944384	; 0x63000000
    1ea0:	69003070 	stmdbvs	r0, {r4, r5, r6, ip, sp}
    1ea4:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1ea8:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
    1eac:	70636564 	rsbvc	r6, r3, r4, ror #10
    1eb0:	73690031 	cmnvc	r9, #49	; 0x31
    1eb4:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1eb8:	64635f74 	strbtvs	r5, [r3], #-3956	; 0xfffff08c
    1ebc:	32706365 	rsbscc	r6, r0, #-1811939327	; 0x94000001
    1ec0:	61736900 	cmnvs	r3, r0, lsl #18
    1ec4:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1ec8:	6564635f 	strbvs	r6, [r4, #-863]!	; 0xfffffca1
    1ecc:	00337063 	eorseq	r7, r3, r3, rrx
    1ed0:	5f617369 	svcpl	0x00617369
    1ed4:	5f746962 	svcpl	0x00746962
    1ed8:	63656463 	cmnvs	r5, #1660944384	; 0x63000000
    1edc:	69003470 	stmdbvs	r0, {r4, r5, r6, sl, ip, sp}
    1ee0:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1ee4:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
    1ee8:	62645f70 	rsbvs	r5, r4, #112, 30	; 0x1c0
    1eec:	7369006c 	cmnvc	r9, #108	; 0x6c
    1ef0:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1ef4:	64635f74 	strbtvs	r5, [r3], #-3956	; 0xfffff08c
    1ef8:	36706365 	ldrbtcc	r6, [r0], -r5, ror #6
    1efc:	61736900 	cmnvs	r3, r0, lsl #18
    1f00:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1f04:	6564635f 	strbvs	r6, [r4, #-863]!	; 0xfffffca1
    1f08:	00377063 	eorseq	r7, r7, r3, rrx
    1f0c:	5f617369 	svcpl	0x00617369
    1f10:	5f746962 	svcpl	0x00746962
    1f14:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    1f18:	69006b36 	stmdbvs	r0, {r1, r2, r4, r5, r8, r9, fp, sp, lr}
    1f1c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1f20:	615f7469 	cmpvs	pc, r9, ror #8
    1f24:	38766d72 	ldmdacc	r6!, {r1, r4, r5, r6, r8, sl, fp, sp, lr}^
    1f28:	5f6d315f 	svcpl	0x006d315f
    1f2c:	6e69616d 	powvsez	f6, f1, #5.0
    1f30:	746e6100 	strbtvc	r6, [lr], #-256	; 0xffffff00
    1f34:	73690065 	cmnvc	r9, #101	; 0x65
    1f38:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1f3c:	6d635f74 	stclvs	15, cr5, [r3, #-464]!	; 0xfffffe30
    1f40:	6c006573 	cfstr32vs	mvfx6, [r0], {115}	; 0x73
    1f44:	20676e6f 	rsbcs	r6, r7, pc, ror #28
    1f48:	62756f64 	rsbsvs	r6, r5, #100, 30	; 0x190
    1f4c:	2e00656c 	cfsh32cs	mvfx6, mvfx0, #60
    1f50:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1f54:	2f2e2e2f 	svccs	0x002e2e2f
    1f58:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1f5c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1f60:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
    1f64:	2f636367 	svccs	0x00636367
    1f68:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    1f6c:	2e326363 	cdpcs	3, 3, cr6, cr2, cr3, {3}
    1f70:	73690063 	cmnvc	r9, #99	; 0x63
    1f74:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1f78:	70665f74 	rsbvc	r5, r6, r4, ror pc
    1f7c:	69003576 	stmdbvs	r0, {r1, r2, r4, r5, r6, r8, sl, ip, sp}
    1f80:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1f84:	785f7469 	ldmdavc	pc, {r0, r3, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
    1f88:	6c616373 	stclvs	3, cr6, [r1], #-460	; 0xfffffe34
    1f8c:	6f6c0065 	svcvs	0x006c0065
    1f90:	6c20676e 	stcvs	7, cr6, [r0], #-440	; 0xfffffe48
    1f94:	20676e6f 	rsbcs	r6, r7, pc, ror #28
    1f98:	69736e75 	ldmdbvs	r3!, {r0, r2, r4, r5, r6, r9, sl, fp, sp, lr}^
    1f9c:	64656e67 	strbtvs	r6, [r5], #-3687	; 0xfffff199
    1fa0:	746e6920 	strbtvc	r6, [lr], #-2336	; 0xfffff6e0
    1fa4:	61736900 	cmnvs	r3, r0, lsl #18
    1fa8:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1fac:	6975715f 	ldmdbvs	r5!, {r0, r1, r2, r3, r4, r6, r8, ip, sp, lr}^
    1fb0:	635f6b72 	cmpvs	pc, #116736	; 0x1c800
    1fb4:	6c5f336d 	mrrcvs	3, 6, r3, pc, cr13	; <UNPREDICTABLE>
    1fb8:	00647264 	rsbeq	r7, r4, r4, ror #4
    1fbc:	5f617369 	svcpl	0x00617369
    1fc0:	5f746962 	svcpl	0x00746962
    1fc4:	6d6d3869 	stclvs	8, cr3, [sp, #-420]!	; 0xfffffe5c
    1fc8:	61736900 	cmnvs	r3, r0, lsl #18
    1fcc:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1fd0:	5f70665f 	svcpl	0x0070665f
    1fd4:	00323364 	eorseq	r3, r2, r4, ror #6
    1fd8:	5f617369 	svcpl	0x00617369
    1fdc:	5f746962 	svcpl	0x00746962
    1fe0:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    1fe4:	006d6537 	rsbeq	r6, sp, r7, lsr r5
    1fe8:	5f617369 	svcpl	0x00617369
    1fec:	5f746962 	svcpl	0x00746962
    1ff0:	6561706c 	strbvs	r7, [r1, #-108]!	; 0xffffff94
    1ff4:	6c6c6100 	stfvse	f6, [ip], #-0
    1ff8:	706d695f 	rsbvc	r6, sp, pc, asr r9
    1ffc:	6465696c 	strbtvs	r6, [r5], #-2412	; 0xfffff694
    2000:	6962665f 	stmdbvs	r2!, {r0, r1, r2, r3, r4, r6, r9, sl, sp, lr}^
    2004:	69007374 	stmdbvs	r0, {r2, r4, r5, r6, r8, r9, ip, sp, lr}
    2008:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    200c:	615f7469 	cmpvs	pc, r9, ror #8
    2010:	38766d72 	ldmdacc	r6!, {r1, r4, r5, r6, r8, sl, fp, sp, lr}^
    2014:	6900315f 	stmdbvs	r0, {r0, r1, r2, r3, r4, r6, r8, ip, sp}
    2018:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    201c:	615f7469 	cmpvs	pc, r9, ror #8
    2020:	38766d72 	ldmdacc	r6!, {r1, r4, r5, r6, r8, sl, fp, sp, lr}^
    2024:	6900325f 	stmdbvs	r0, {r0, r1, r2, r3, r4, r6, r9, ip, sp}
    2028:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    202c:	615f7469 	cmpvs	pc, r9, ror #8
    2030:	38766d72 	ldmdacc	r6!, {r1, r4, r5, r6, r8, sl, fp, sp, lr}^
    2034:	6900335f 	stmdbvs	r0, {r0, r1, r2, r3, r4, r6, r8, r9, ip, sp}
    2038:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    203c:	615f7469 	cmpvs	pc, r9, ror #8
    2040:	38766d72 	ldmdacc	r6!, {r1, r4, r5, r6, r8, sl, fp, sp, lr}^
    2044:	6900345f 	stmdbvs	r0, {r0, r1, r2, r3, r4, r6, sl, ip, sp}
    2048:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    204c:	615f7469 	cmpvs	pc, r9, ror #8
    2050:	38766d72 	ldmdacc	r6!, {r1, r4, r5, r6, r8, sl, fp, sp, lr}^
    2054:	6900355f 	stmdbvs	r0, {r0, r1, r2, r3, r4, r6, r8, sl, ip, sp}
    2058:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    205c:	615f7469 	cmpvs	pc, r9, ror #8
    2060:	38766d72 	ldmdacc	r6!, {r1, r4, r5, r6, r8, sl, fp, sp, lr}^
    2064:	6900365f 	stmdbvs	r0, {r0, r1, r2, r3, r4, r6, r9, sl, ip, sp}
    2068:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    206c:	735f7469 	cmpvc	pc, #1761607680	; 0x69000000
    2070:	73690062 	cmnvc	r9, #98	; 0x62
    2074:	756e5f61 	strbvc	r5, [lr, #-3937]!	; 0xfffff09f
    2078:	69625f6d 	stmdbvs	r2!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, ip, lr}^
    207c:	69007374 	stmdbvs	r0, {r2, r4, r5, r6, r8, r9, ip, sp, lr}
    2080:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2084:	735f7469 	cmpvc	pc, #1761607680	; 0x69000000
    2088:	6c6c616d 	stfvse	f6, [ip], #-436	; 0xfffffe4c
    208c:	006c756d 	rsbeq	r7, ip, sp, ror #10
    2090:	636e7566 	cmnvs	lr, #427819008	; 0x19800000
    2094:	7274705f 	rsbsvc	r7, r4, #95	; 0x5f
    2098:	6d6f6300 	stclvs	3, cr6, [pc, #-0]	; 20a0 <shift+0x20a0>
    209c:	78656c70 	stmdavc	r5!, {r4, r5, r6, sl, fp, sp, lr}^
    20a0:	756f6420 	strbvc	r6, [pc, #-1056]!	; 1c88 <shift+0x1c88>
    20a4:	00656c62 	rsbeq	r6, r5, r2, ror #24
    20a8:	465f424e 	ldrbmi	r4, [pc], -lr, asr #4
    20ac:	59535f50 	ldmdbpl	r3, {r4, r6, r8, r9, sl, fp, ip, lr}^
    20b0:	47455253 	smlsldmi	r5, r5, r3, r2	; <UNPREDICTABLE>
    20b4:	73690053 	cmnvc	r9, #83	; 0x53
    20b8:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    20bc:	64635f74 	strbtvs	r5, [r3], #-3956	; 0xfffff08c
    20c0:	35706365 	ldrbcc	r6, [r0, #-869]!	; 0xfffffc9b
    20c4:	61736900 	cmnvs	r3, r0, lsl #18
    20c8:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    20cc:	7066765f 	rsbvc	r7, r6, pc, asr r6
    20d0:	69003276 	stmdbvs	r0, {r1, r2, r4, r5, r6, r9, ip, sp}
    20d4:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    20d8:	765f7469 	ldrbvc	r7, [pc], -r9, ror #8
    20dc:	33767066 	cmncc	r6, #102	; 0x66
    20e0:	61736900 	cmnvs	r3, r0, lsl #18
    20e4:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    20e8:	7066765f 	rsbvc	r7, r6, pc, asr r6
    20ec:	46003476 			; <UNDEFINED> instruction: 0x46003476
    20f0:	54584350 	ldrbpl	r4, [r8], #-848	; 0xfffffcb0
    20f4:	455f534e 	ldrbmi	r5, [pc, #-846]	; 1dae <shift+0x1dae>
    20f8:	004d554e 	subeq	r5, sp, lr, asr #10
    20fc:	5f617369 	svcpl	0x00617369
    2100:	5f746962 	svcpl	0x00746962
    2104:	6d756874 	ldclvs	8, cr6, [r5, #-464]!	; 0xfffffe30
    2108:	73690062 	cmnvc	r9, #98	; 0x62
    210c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2110:	70665f74 	rsbvc	r5, r6, r4, ror pc
    2114:	6f633631 	svcvs	0x00633631
    2118:	6900766e 	stmdbvs	r0, {r1, r2, r3, r5, r6, r9, sl, ip, sp, lr}
    211c:	665f6173 			; <UNDEFINED> instruction: 0x665f6173
    2120:	75746165 	ldrbvc	r6, [r4, #-357]!	; 0xfffffe9b
    2124:	69006572 	stmdbvs	r0, {r1, r4, r5, r6, r8, sl, sp, lr}
    2128:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    212c:	6e5f7469 	cdpvs	4, 5, cr7, cr15, cr9, {3}
    2130:	006d746f 	rsbeq	r7, sp, pc, ror #8
    2134:	5f617369 	svcpl	0x00617369
    2138:	5f746962 	svcpl	0x00746962
    213c:	72697571 	rsbvc	r7, r9, #473956352	; 0x1c400000
    2140:	72615f6b 	rsbvc	r5, r1, #428	; 0x1ac
    2144:	6b36766d 	blvs	d9fb00 <__bss_end+0xd93a08>
    2148:	7369007a 	cmnvc	r9, #122	; 0x7a
    214c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2150:	72635f74 	rsbvc	r5, r3, #116, 30	; 0x1d0
    2154:	00323363 	eorseq	r3, r2, r3, ror #6
    2158:	5f617369 	svcpl	0x00617369
    215c:	5f746962 	svcpl	0x00746962
    2160:	72697571 	rsbvc	r7, r9, #473956352	; 0x1c400000
    2164:	6f6e5f6b 	svcvs	0x006e5f6b
    2168:	6d73615f 	ldfvse	f6, [r3, #-380]!	; 0xfffffe84
    216c:	00757063 	rsbseq	r7, r5, r3, rrx
    2170:	5f617369 	svcpl	0x00617369
    2174:	5f746962 	svcpl	0x00746962
    2178:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    217c:	73690034 	cmnvc	r9, #52	; 0x34
    2180:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2184:	68745f74 	ldmdavs	r4!, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    2188:	32626d75 	rsbcc	r6, r2, #7488	; 0x1d40
    218c:	61736900 	cmnvs	r3, r0, lsl #18
    2190:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2194:	3865625f 	stmdacc	r5!, {r0, r1, r2, r3, r4, r6, r9, sp, lr}^
    2198:	61736900 	cmnvs	r3, r0, lsl #18
    219c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    21a0:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    21a4:	69003776 	stmdbvs	r0, {r1, r2, r4, r5, r6, r8, r9, sl, ip, sp}
    21a8:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    21ac:	615f7469 	cmpvs	pc, r9, ror #8
    21b0:	38766d72 	ldmdacc	r6!, {r1, r4, r5, r6, r8, sl, fp, sp, lr}^
    21b4:	70667600 	rsbvc	r7, r6, r0, lsl #12
    21b8:	7379735f 	cmnvc	r9, #2080374785	; 0x7c000001
    21bc:	73676572 	cmnvc	r7, #478150656	; 0x1c800000
    21c0:	636e655f 	cmnvs	lr, #398458880	; 0x17c00000
    21c4:	6e69646f 	cdpvs	4, 6, cr6, cr9, cr15, {3}
    21c8:	73690067 	cmnvc	r9, #103	; 0x67
    21cc:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    21d0:	70665f74 	rsbvc	r5, r6, r4, ror pc
    21d4:	6d663631 	stclvs	6, cr3, [r6, #-196]!	; 0xffffff3c
    21d8:	7369006c 	cmnvc	r9, #108	; 0x6c
    21dc:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    21e0:	6f645f74 	svcvs	0x00645f74
    21e4:	6f727074 	svcvs	0x00727074
    21e8:	5f5f0064 	svcpl	0x005f0064
    21ec:	75786966 	ldrbvc	r6, [r8, #-2406]!	; 0xfffff69a
    21f0:	6673736e 	ldrbtvs	r7, [r3], -lr, ror #6
    21f4:	53006964 	movwpl	r6, #2404	; 0x964
    21f8:	70797446 	rsbsvc	r7, r9, r6, asr #8
    21fc:	5f5f0065 	svcpl	0x005f0065
    2200:	62616561 	rsbvs	r6, r1, #406847488	; 0x18400000
    2204:	32665f69 	rsbcc	r5, r6, #420	; 0x1a4
    2208:	007a6c75 	rsbseq	r6, sl, r5, ror ip
    220c:	69665f5f 	stmdbvs	r6!, {r0, r1, r2, r3, r4, r6, r8, r9, sl, fp, ip, lr}^
    2210:	64667378 	strbtvs	r7, [r6], #-888	; 0xfffffc88
    2214:	46440069 	strbmi	r0, [r4], -r9, rrx
    2218:	65707974 	ldrbvs	r7, [r0, #-2420]!	; 0xfffff68c
    221c:	49535500 	ldmdbmi	r3, {r8, sl, ip, lr}^
    2220:	65707974 	ldrbvs	r7, [r0, #-2420]!	; 0xfffff68c
    2224:	49445500 	stmdbmi	r4, {r8, sl, ip, lr}^
    2228:	65707974 	ldrbvs	r7, [r0, #-2420]!	; 0xfffff68c
    222c:	554e4700 	strbpl	r4, [lr, #-1792]	; 0xfffff900
    2230:	37314320 	ldrcc	r4, [r1, -r0, lsr #6]!
    2234:	2e303120 	rsfcssp	f3, f0, f0
    2238:	20312e33 	eorscs	r2, r1, r3, lsr lr
    223c:	31323032 	teqcc	r2, r2, lsr r0
    2240:	31323630 	teqcc	r2, r0, lsr r6
    2244:	65722820 	ldrbvs	r2, [r2, #-2080]!	; 0xfffff7e0
    2248:	7361656c 	cmnvc	r1, #108, 10	; 0x1b000000
    224c:	2d202965 			; <UNDEFINED> instruction: 0x2d202965
    2250:	6d72616d 	ldfvse	f6, [r2, #-436]!	; 0xfffffe4c
    2254:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
    2258:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
    225c:	6962612d 	stmdbvs	r2!, {r0, r2, r3, r5, r8, sp, lr}^
    2260:	7261683d 	rsbvc	r6, r1, #3997696	; 0x3d0000
    2264:	6d2d2064 	stcvs	0, cr2, [sp, #-400]!	; 0xfffffe70
    2268:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    226c:	6d72613d 	ldfvse	f6, [r2, #-244]!	; 0xffffff0c
    2270:	65743576 	ldrbvs	r3, [r4, #-1398]!	; 0xfffffa8a
    2274:	2070662b 	rsbscs	r6, r0, fp, lsr #12
    2278:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
    227c:	672d2067 	strvs	r2, [sp, -r7, rrx]!
    2280:	324f2d20 	subcc	r2, pc, #32, 26	; 0x800
    2284:	324f2d20 	subcc	r2, pc, #32, 26	; 0x800
    2288:	324f2d20 	subcc	r2, pc, #32, 26	; 0x800
    228c:	62662d20 	rsbvs	r2, r6, #32, 26	; 0x800
    2290:	646c6975 	strbtvs	r6, [ip], #-2421	; 0xfffff68b
    2294:	2d676e69 	stclcs	14, cr6, [r7, #-420]!	; 0xfffffe5c
    2298:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    229c:	2d206363 	stccs	3, cr6, [r0, #-396]!	; 0xfffffe74
    22a0:	2d6f6e66 	stclcs	14, cr6, [pc, #-408]!	; 2110 <shift+0x2110>
    22a4:	63617473 	cmnvs	r1, #1929379840	; 0x73000000
    22a8:	72702d6b 	rsbsvc	r2, r0, #6848	; 0x1ac0
    22ac:	6365746f 	cmnvs	r5, #1862270976	; 0x6f000000
    22b0:	20726f74 	rsbscs	r6, r2, r4, ror pc
    22b4:	6f6e662d 	svcvs	0x006e662d
    22b8:	6c6e692d 			; <UNDEFINED> instruction: 0x6c6e692d
    22bc:	20656e69 	rsbcs	r6, r5, r9, ror #28
    22c0:	7865662d 	stmdavc	r5!, {r0, r2, r3, r5, r9, sl, sp, lr}^
    22c4:	74706563 	ldrbtvc	r6, [r0], #-1379	; 0xfffffa9d
    22c8:	736e6f69 	cmnvc	lr, #420	; 0x1a4
    22cc:	76662d20 	strbtvc	r2, [r6], -r0, lsr #26
    22d0:	62697369 	rsbvs	r7, r9, #-1543503871	; 0xa4000001
    22d4:	74696c69 	strbtvc	r6, [r9], #-3177	; 0xfffff397
    22d8:	69683d79 	stmdbvs	r8!, {r0, r3, r4, r5, r6, r8, sl, fp, ip, sp}^
    22dc:	6e656464 	cdpvs	4, 6, cr6, cr5, cr4, {3}
    22e0:	755f5f00 	ldrbvc	r5, [pc, #-3840]	; 13e8 <shift+0x13e8>
    22e4:	6d766964 			; <UNDEFINED> instruction: 0x6d766964
    22e8:	6964646f 	stmdbvs	r4!, {r0, r1, r2, r3, r5, r6, sl, sp, lr}^
    22ec:	69730034 	ldmdbvs	r3!, {r2, r4, r5}^
    22f0:	745f657a 	ldrbvc	r6, [pc], #-1402	; 22f8 <shift+0x22f8>
    22f4:	75622f00 	strbvc	r2, [r2, #-3840]!	; 0xfffff100
    22f8:	2f646c69 	svccs	0x00646c69
    22fc:	6c77656e 	cfldr64vs	mvdx6, [r7], #-440	; 0xfffffe48
    2300:	702d6269 	eorvc	r6, sp, r9, ror #4
    2304:	64303342 	ldrtvs	r3, [r0], #-834	; 0xfffffcbe
    2308:	656e2f65 	strbvs	r2, [lr, #-3941]!	; 0xfffff09b
    230c:	62696c77 	rsbvs	r6, r9, #30464	; 0x7700
    2310:	332e332d 			; <UNDEFINED> instruction: 0x332e332d
    2314:	622f302e 	eorvs	r3, pc, #46	; 0x2e
    2318:	646c6975 	strbtvs	r6, [ip], #-2421	; 0xfffff68b
    231c:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
    2320:	6e6f6e2d 	cdpvs	14, 6, cr6, cr15, cr13, {1}
    2324:	61652d65 	cmnvs	r5, r5, ror #26
    2328:	612f6962 			; <UNDEFINED> instruction: 0x612f6962
    232c:	762f6d72 			; <UNDEFINED> instruction: 0x762f6d72
    2330:	2f657435 	svccs	0x00657435
    2334:	64726168 	ldrbtvs	r6, [r2], #-360	; 0xfffffe98
    2338:	77656e2f 	strbvc	r6, [r5, -pc, lsr #28]!
    233c:	2f62696c 	svccs	0x0062696c
    2340:	6362696c 	cmnvs	r2, #108, 18	; 0x1b0000
    2344:	7274732f 	rsbsvc	r7, r4, #-1140850688	; 0xbc000000
    2348:	00676e69 	rsbeq	r6, r7, r9, ror #28
    234c:	67696c61 	strbvs	r6, [r9, -r1, ror #24]!
    2350:	5f64656e 	svcpl	0x0064656e
    2354:	72646461 	rsbvc	r6, r4, #1627389952	; 0x61000000
    2358:	2f2e2e00 	svccs	0x002e2e00
    235c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    2360:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    2364:	2f2e2e2f 	svccs	0x002e2e2f
    2368:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    236c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    2370:	77656e2f 	strbvc	r6, [r5, -pc, lsr #28]!
    2374:	2f62696c 	svccs	0x0062696c
    2378:	6362696c 	cmnvs	r2, #108, 18	; 0x1b0000
    237c:	7274732f 	rsbsvc	r7, r4, #-1140850688	; 0xbc000000
    2380:	2f676e69 	svccs	0x00676e69
    2384:	736d656d 	cmnvc	sp, #457179136	; 0x1b400000
    2388:	632e7465 			; <UNDEFINED> instruction: 0x632e7465
    238c:	554e4700 	strbpl	r4, [lr, #-1792]	; 0xfffff900
    2390:	37314320 	ldrcc	r4, [r1, -r0, lsr #6]!
    2394:	2e303120 	rsfcssp	f3, f0, f0
    2398:	20312e33 	eorscs	r2, r1, r3, lsr lr
    239c:	31323032 	teqcc	r2, r2, lsr r0
    23a0:	31323630 	teqcc	r2, r0, lsr r6
    23a4:	65722820 	ldrbvs	r2, [r2, #-2080]!	; 0xfffff7e0
    23a8:	7361656c 	cmnvc	r1, #108, 10	; 0x1b000000
    23ac:	2d202965 			; <UNDEFINED> instruction: 0x2d202965
    23b0:	6f6c666d 	svcvs	0x006c666d
    23b4:	612d7461 			; <UNDEFINED> instruction: 0x612d7461
    23b8:	683d6962 	ldmdavs	sp!, {r1, r5, r6, r8, fp, sp, lr}
    23bc:	20647261 	rsbcs	r7, r4, r1, ror #4
    23c0:	72616d2d 	rsbvc	r6, r1, #2880	; 0xb40
    23c4:	6d2d206d 	stcvs	0, cr2, [sp, #-436]!	; 0xfffffe4c
    23c8:	616f6c66 	cmnvs	pc, r6, ror #24
    23cc:	62612d74 	rsbvs	r2, r1, #116, 26	; 0x1d00
    23d0:	61683d69 	cmnvs	r8, r9, ror #26
    23d4:	2d206472 	cfstrscs	mvf6, [r0, #-456]!	; 0xfffffe38
    23d8:	6372616d 	cmnvs	r2, #1073741851	; 0x4000001b
    23dc:	72613d68 	rsbvc	r3, r1, #104, 26	; 0x1a00
    23e0:	7435766d 	ldrtvc	r7, [r5], #-1645	; 0xfffff993
    23e4:	70662b65 	rsbvc	r2, r6, r5, ror #22
    23e8:	20672d20 	rsbcs	r2, r7, r0, lsr #26
    23ec:	20324f2d 	eorscs	r4, r2, sp, lsr #30
    23f0:	6f6e662d 	svcvs	0x006e662d
    23f4:	6975622d 	ldmdbvs	r5!, {r0, r2, r3, r5, r9, sp, lr}^
    23f8:	6e69746c 	cdpvs	4, 6, cr7, cr9, cr12, {3}
    23fc:	6d656d00 	stclvs	13, cr6, [r5, #-0]
    2400:	00746573 	rsbseq	r6, r4, r3, ror r5

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
  20:	8b040e42 	blhi	103930 <__bss_end+0xf7838>
  24:	0b0d4201 	bleq	350830 <__bss_end+0x344738>
  28:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
  2c:	00000ecb 	andeq	r0, r0, fp, asr #29
  30:	0000001c 	andeq	r0, r0, ip, lsl r0
  34:	00000000 	andeq	r0, r0, r0
  38:	00008064 	andeq	r8, r0, r4, rrx
  3c:	00000040 	andeq	r0, r0, r0, asr #32
  40:	8b080e42 	blhi	203950 <__bss_end+0x1f7858>
  44:	42018e02 	andmi	r8, r1, #2, 28
  48:	5a040b0c 	bpl	102c80 <__bss_end+0xf6b88>
  4c:	00080d0c 	andeq	r0, r8, ip, lsl #26
  50:	0000000c 	andeq	r0, r0, ip
  54:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
  58:	7c020001 	stcvc	0, cr0, [r2], {1}
  5c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
  60:	0000001c 	andeq	r0, r0, ip, lsl r0
  64:	00000050 	andeq	r0, r0, r0, asr r0
  68:	000080a4 	andeq	r8, r0, r4, lsr #1
  6c:	00000038 	andeq	r0, r0, r8, lsr r0
  70:	8b040e42 	blhi	103980 <__bss_end+0xf7888>
  74:	0b0d4201 	bleq	350880 <__bss_end+0x344788>
  78:	420d0d54 	andmi	r0, sp, #84, 26	; 0x1500
  7c:	00000ecb 	andeq	r0, r0, fp, asr #29
  80:	0000001c 	andeq	r0, r0, ip, lsl r0
  84:	00000050 	andeq	r0, r0, r0, asr r0
  88:	000080dc 	ldrdeq	r8, [r0], -ip
  8c:	0000002c 	andeq	r0, r0, ip, lsr #32
  90:	8b040e42 	blhi	1039a0 <__bss_end+0xf78a8>
  94:	0b0d4201 	bleq	3508a0 <__bss_end+0x3447a8>
  98:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
  9c:	00000ecb 	andeq	r0, r0, fp, asr #29
  a0:	0000001c 	andeq	r0, r0, ip, lsl r0
  a4:	00000050 	andeq	r0, r0, r0, asr r0
  a8:	00008108 	andeq	r8, r0, r8, lsl #2
  ac:	00000020 	andeq	r0, r0, r0, lsr #32
  b0:	8b040e42 	blhi	1039c0 <__bss_end+0xf78c8>
  b4:	0b0d4201 	bleq	3508c0 <__bss_end+0x3447c8>
  b8:	420d0d48 	andmi	r0, sp, #72, 26	; 0x1200
  bc:	00000ecb 	andeq	r0, r0, fp, asr #29
  c0:	0000001c 	andeq	r0, r0, ip, lsl r0
  c4:	00000050 	andeq	r0, r0, r0, asr r0
  c8:	00008128 	andeq	r8, r0, r8, lsr #2
  cc:	00000018 	andeq	r0, r0, r8, lsl r0
  d0:	8b040e42 	blhi	1039e0 <__bss_end+0xf78e8>
  d4:	0b0d4201 	bleq	3508e0 <__bss_end+0x3447e8>
  d8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  dc:	00000ecb 	andeq	r0, r0, fp, asr #29
  e0:	0000001c 	andeq	r0, r0, ip, lsl r0
  e4:	00000050 	andeq	r0, r0, r0, asr r0
  e8:	00008140 	andeq	r8, r0, r0, asr #2
  ec:	00000018 	andeq	r0, r0, r8, lsl r0
  f0:	8b040e42 	blhi	103a00 <__bss_end+0xf7908>
  f4:	0b0d4201 	bleq	350900 <__bss_end+0x344808>
  f8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  fc:	00000ecb 	andeq	r0, r0, fp, asr #29
 100:	0000001c 	andeq	r0, r0, ip, lsl r0
 104:	00000050 	andeq	r0, r0, r0, asr r0
 108:	00008158 	andeq	r8, r0, r8, asr r1
 10c:	00000018 	andeq	r0, r0, r8, lsl r0
 110:	8b040e42 	blhi	103a20 <__bss_end+0xf7928>
 114:	0b0d4201 	bleq	350920 <__bss_end+0x344828>
 118:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
 11c:	00000ecb 	andeq	r0, r0, fp, asr #29
 120:	00000014 	andeq	r0, r0, r4, lsl r0
 124:	00000050 	andeq	r0, r0, r0, asr r0
 128:	00008170 	andeq	r8, r0, r0, ror r1
 12c:	0000000c 	andeq	r0, r0, ip
 130:	8b040e42 	blhi	103a40 <__bss_end+0xf7948>
 134:	0b0d4201 	bleq	350940 <__bss_end+0x344848>
 138:	0000001c 	andeq	r0, r0, ip, lsl r0
 13c:	00000050 	andeq	r0, r0, r0, asr r0
 140:	0000817c 	andeq	r8, r0, ip, ror r1
 144:	00000058 	andeq	r0, r0, r8, asr r0
 148:	8b080e42 	blhi	203a58 <__bss_end+0x1f7960>
 14c:	42018e02 	andmi	r8, r1, #2, 28
 150:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 154:	00080d0c 	andeq	r0, r8, ip, lsl #26
 158:	0000001c 	andeq	r0, r0, ip, lsl r0
 15c:	00000050 	andeq	r0, r0, r0, asr r0
 160:	000081d4 	ldrdeq	r8, [r0], -r4
 164:	00000058 	andeq	r0, r0, r8, asr r0
 168:	8b080e42 	blhi	203a78 <__bss_end+0x1f7980>
 16c:	42018e02 	andmi	r8, r1, #2, 28
 170:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 174:	00080d0c 	andeq	r0, r8, ip, lsl #26
 178:	0000000c 	andeq	r0, r0, ip
 17c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 180:	7c020001 	stcvc	0, cr0, [r2], {1}
 184:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 188:	0000001c 	andeq	r0, r0, ip, lsl r0
 18c:	00000178 	andeq	r0, r0, r8, ror r1
 190:	00008590 	muleq	r0, r0, r5
 194:	00000030 	andeq	r0, r0, r0, lsr r0
 198:	8b080e42 	blhi	203aa8 <__bss_end+0x1f79b0>
 19c:	42018e02 	andmi	r8, r1, #2, 28
 1a0:	50040b0c 	andpl	r0, r4, ip, lsl #22
 1a4:	00080d0c 	andeq	r0, r8, ip, lsl #26
 1a8:	0000001c 	andeq	r0, r0, ip, lsl r0
 1ac:	00000178 	andeq	r0, r0, r8, ror r1
 1b0:	0000822c 	andeq	r8, r0, ip, lsr #4
 1b4:	000001a4 	andeq	r0, r0, r4, lsr #3
 1b8:	8b040e42 	blhi	103ac8 <__bss_end+0xf79d0>
 1bc:	0b0d4201 	bleq	3509c8 <__bss_end+0x3448d0>
 1c0:	0d0da602 	stceq	6, cr10, [sp, #-8]
 1c4:	000ecb42 	andeq	ip, lr, r2, asr #22
 1c8:	0000001c 	andeq	r0, r0, ip, lsl r0
 1cc:	00000178 	andeq	r0, r0, r8, ror r1
 1d0:	000083d0 	ldrdeq	r8, [r0], -r0
 1d4:	0000007c 	andeq	r0, r0, ip, ror r0
 1d8:	8b080e42 	blhi	203ae8 <__bss_end+0x1f79f0>
 1dc:	42018e02 	andmi	r8, r1, #2, 28
 1e0:	6c040b0c 			; <UNDEFINED> instruction: 0x6c040b0c
 1e4:	00080d0c 	andeq	r0, r8, ip, lsl #26
 1e8:	00000020 	andeq	r0, r0, r0, lsr #32
 1ec:	00000178 	andeq	r0, r0, r8, ror r1
 1f0:	0000844c 	andeq	r8, r0, ip, asr #8
 1f4:	00000144 	andeq	r0, r0, r4, asr #2
 1f8:	840c0e42 	strhi	r0, [ip], #-3650	; 0xfffff1be
 1fc:	8e028b03 	vmlahi.f64	d8, d2, d3
 200:	0b0c4201 	bleq	310a0c <__bss_end+0x304914>
 204:	0c920204 	lfmeq	f0, 4, [r2], {4}
 208:	00000c0d 	andeq	r0, r0, sp, lsl #24
 20c:	0000000c 	andeq	r0, r0, ip
 210:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 214:	7c020001 	stcvc	0, cr0, [r2], {1}
 218:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 21c:	0000001c 	andeq	r0, r0, ip, lsl r0
 220:	0000020c 	andeq	r0, r0, ip, lsl #4
 224:	00008590 	muleq	r0, r0, r5
 228:	00000030 	andeq	r0, r0, r0, lsr r0
 22c:	8b080e42 	blhi	203b3c <__bss_end+0x1f7a44>
 230:	42018e02 	andmi	r8, r1, #2, 28
 234:	50040b0c 	andpl	r0, r4, ip, lsl #22
 238:	00080d0c 	andeq	r0, r8, ip, lsl #26
 23c:	0000001c 	andeq	r0, r0, ip, lsl r0
 240:	0000020c 	andeq	r0, r0, ip, lsl #4
 244:	00009924 	andeq	r9, r0, r4, lsr #18
 248:	00000030 	andeq	r0, r0, r0, lsr r0
 24c:	8b080e42 	blhi	203b5c <__bss_end+0x1f7a64>
 250:	42018e02 	andmi	r8, r1, #2, 28
 254:	50040b0c 	andpl	r0, r4, ip, lsl #22
 258:	00080d0c 	andeq	r0, r8, ip, lsl #26
 25c:	0000001c 	andeq	r0, r0, ip, lsl r0
 260:	0000020c 	andeq	r0, r0, ip, lsl #4
 264:	00009954 	andeq	r9, r0, r4, asr r9
 268:	00000030 	andeq	r0, r0, r0, lsr r0
 26c:	8b080e42 	blhi	203b7c <__bss_end+0x1f7a84>
 270:	42018e02 	andmi	r8, r1, #2, 28
 274:	50040b0c 	andpl	r0, r4, ip, lsl #22
 278:	00080d0c 	andeq	r0, r8, ip, lsl #26
 27c:	0000001c 	andeq	r0, r0, ip, lsl r0
 280:	0000020c 	andeq	r0, r0, ip, lsl #4
 284:	000085c0 	andeq	r8, r0, r0, asr #11
 288:	000000e0 	andeq	r0, r0, r0, ror #1
 28c:	8b080e42 	blhi	203b9c <__bss_end+0x1f7aa4>
 290:	42018e02 	andmi	r8, r1, #2, 28
 294:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 298:	080d0c68 	stmdaeq	sp, {r3, r5, r6, sl, fp}
 29c:	0000001c 	andeq	r0, r0, ip, lsl r0
 2a0:	0000020c 	andeq	r0, r0, ip, lsl #4
 2a4:	000086a0 	andeq	r8, r0, r0, lsr #13
 2a8:	00000074 	andeq	r0, r0, r4, ror r0
 2ac:	8b040e42 	blhi	103bbc <__bss_end+0xf7ac4>
 2b0:	0b0d4201 	bleq	350abc <__bss_end+0x3449c4>
 2b4:	420d0d6c 	andmi	r0, sp, #108, 26	; 0x1b00
 2b8:	00000ecb 	andeq	r0, r0, fp, asr #29
 2bc:	0000001c 	andeq	r0, r0, ip, lsl r0
 2c0:	0000020c 	andeq	r0, r0, ip, lsl #4
 2c4:	00008714 	andeq	r8, r0, r4, lsl r7
 2c8:	000000b8 	strheq	r0, [r0], -r8
 2cc:	8b080e42 	blhi	203bdc <__bss_end+0x1f7ae4>
 2d0:	42018e02 	andmi	r8, r1, #2, 28
 2d4:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 2d8:	080d0c56 	stmdaeq	sp, {r1, r2, r4, r6, sl, fp}
 2dc:	0000001c 	andeq	r0, r0, ip, lsl r0
 2e0:	0000020c 	andeq	r0, r0, ip, lsl #4
 2e4:	000087cc 	andeq	r8, r0, ip, asr #15
 2e8:	00000094 	muleq	r0, r4, r0
 2ec:	8b080e42 	blhi	203bfc <__bss_end+0x1f7b04>
 2f0:	42018e02 	andmi	r8, r1, #2, 28
 2f4:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 2f8:	080d0c44 	stmdaeq	sp, {r2, r6, sl, fp}
 2fc:	0000001c 	andeq	r0, r0, ip, lsl r0
 300:	0000020c 	andeq	r0, r0, ip, lsl #4
 304:	00008860 	andeq	r8, r0, r0, ror #16
 308:	00000168 	andeq	r0, r0, r8, ror #2
 30c:	8b080e42 	blhi	203c1c <__bss_end+0x1f7b24>
 310:	42018e02 	andmi	r8, r1, #2, 28
 314:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 318:	080d0cac 	stmdaeq	sp, {r2, r3, r5, r7, sl, fp}
 31c:	0000001c 	andeq	r0, r0, ip, lsl r0
 320:	0000020c 	andeq	r0, r0, ip, lsl #4
 324:	000089c8 	andeq	r8, r0, r8, asr #19
 328:	000000fc 	strdeq	r0, [r0], -ip
 32c:	8b080e42 	blhi	203c3c <__bss_end+0x1f7b44>
 330:	42018e02 	andmi	r8, r1, #2, 28
 334:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 338:	080d0c76 	stmdaeq	sp, {r1, r2, r4, r5, r6, sl, fp}
 33c:	0000001c 	andeq	r0, r0, ip, lsl r0
 340:	0000020c 	andeq	r0, r0, ip, lsl #4
 344:	00008ac4 	andeq	r8, r0, r4, asr #21
 348:	000000e8 	andeq	r0, r0, r8, ror #1
 34c:	8b040e42 	blhi	103c5c <__bss_end+0xf7b64>
 350:	0b0d4201 	bleq	350b5c <__bss_end+0x344a64>
 354:	0d0d6c02 	stceq	12, cr6, [sp, #-8]
 358:	000ecb42 	andeq	ip, lr, r2, asr #22
 35c:	0000001c 	andeq	r0, r0, ip, lsl r0
 360:	0000020c 	andeq	r0, r0, ip, lsl #4
 364:	00008bac 	andeq	r8, r0, ip, lsr #23
 368:	00000158 	andeq	r0, r0, r8, asr r1
 36c:	8b080e42 	blhi	203c7c <__bss_end+0x1f7b84>
 370:	42018e02 	andmi	r8, r1, #2, 28
 374:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 378:	080d0ca0 	stmdaeq	sp, {r5, r7, sl, fp}
 37c:	00000020 	andeq	r0, r0, r0, lsr #32
 380:	0000020c 	andeq	r0, r0, ip, lsl #4
 384:	00008d04 	andeq	r8, r0, r4, lsl #26
 388:	0000027c 	andeq	r0, r0, ip, ror r2
 38c:	840c0e42 	strhi	r0, [ip], #-3650	; 0xfffff1be
 390:	8e028b03 	vmlahi.f64	d8, d2, d3
 394:	0b0c4201 	bleq	310ba0 <__bss_end+0x304aa8>
 398:	01380304 	teqeq	r8, r4, lsl #6
 39c:	000c0d0c 	andeq	r0, ip, ip, lsl #26
 3a0:	0000001c 	andeq	r0, r0, ip, lsl r0
 3a4:	0000020c 	andeq	r0, r0, ip, lsl #4
 3a8:	00008f80 	andeq	r8, r0, r0, lsl #31
 3ac:	00000040 	andeq	r0, r0, r0, asr #32
 3b0:	8b040e42 	blhi	103cc0 <__bss_end+0xf7bc8>
 3b4:	0b0d4201 	bleq	350bc0 <__bss_end+0x344ac8>
 3b8:	420d0d58 	andmi	r0, sp, #88, 26	; 0x1600
 3bc:	00000ecb 	andeq	r0, r0, fp, asr #29
 3c0:	0000001c 	andeq	r0, r0, ip, lsl r0
 3c4:	0000020c 	andeq	r0, r0, ip, lsl #4
 3c8:	00008fc0 	andeq	r8, r0, r0, asr #31
 3cc:	00000084 	andeq	r0, r0, r4, lsl #1
 3d0:	8b080e42 	blhi	203ce0 <__bss_end+0x1f7be8>
 3d4:	42018e02 	andmi	r8, r1, #2, 28
 3d8:	7a040b0c 	bvc	103010 <__bss_end+0xf6f18>
 3dc:	00080d0c 	andeq	r0, r8, ip, lsl #26
 3e0:	0000001c 	andeq	r0, r0, ip, lsl r0
 3e4:	0000020c 	andeq	r0, r0, ip, lsl #4
 3e8:	00009044 	andeq	r9, r0, r4, asr #32
 3ec:	00000030 	andeq	r0, r0, r0, lsr r0
 3f0:	8b040e42 	blhi	103d00 <__bss_end+0xf7c08>
 3f4:	0b0d4201 	bleq	350c00 <__bss_end+0x344b08>
 3f8:	420d0d50 	andmi	r0, sp, #80, 26	; 0x1400
 3fc:	00000ecb 	andeq	r0, r0, fp, asr #29
 400:	0000001c 	andeq	r0, r0, ip, lsl r0
 404:	0000020c 	andeq	r0, r0, ip, lsl #4
 408:	00009074 	andeq	r9, r0, r4, ror r0
 40c:	00000028 	andeq	r0, r0, r8, lsr #32
 410:	8b040e42 	blhi	103d20 <__bss_end+0xf7c28>
 414:	0b0d4201 	bleq	350c20 <__bss_end+0x344b28>
 418:	420d0d4c 	andmi	r0, sp, #76, 26	; 0x1300
 41c:	00000ecb 	andeq	r0, r0, fp, asr #29
 420:	00000020 	andeq	r0, r0, r0, lsr #32
 424:	0000020c 	andeq	r0, r0, ip, lsl #4
 428:	0000909c 	muleq	r0, ip, r0
 42c:	000002b8 			; <UNDEFINED> instruction: 0x000002b8
 430:	840c0e42 	strhi	r0, [ip], #-3650	; 0xfffff1be
 434:	8e028b03 	vmlahi.f64	d8, d2, d3
 438:	0b0c4201 	bleq	310c44 <__bss_end+0x304b4c>
 43c:	014e0304 	cmpeq	lr, r4, lsl #6
 440:	000c0d0c 	andeq	r0, ip, ip, lsl #26
 444:	0000001c 	andeq	r0, r0, ip, lsl r0
 448:	0000020c 	andeq	r0, r0, ip, lsl #4
 44c:	00009354 	andeq	r9, r0, r4, asr r3
 450:	000000e8 	andeq	r0, r0, r8, ror #1
 454:	8b080e42 	blhi	203d64 <__bss_end+0x1f7c6c>
 458:	42018e02 	andmi	r8, r1, #2, 28
 45c:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 460:	080d0c66 	stmdaeq	sp, {r1, r2, r5, r6, sl, fp}
 464:	0000001c 	andeq	r0, r0, ip, lsl r0
 468:	0000020c 	andeq	r0, r0, ip, lsl #4
 46c:	0000943c 	andeq	r9, r0, ip, lsr r4
 470:	00000110 	andeq	r0, r0, r0, lsl r1
 474:	8b080e42 	blhi	203d84 <__bss_end+0x1f7c8c>
 478:	42018e02 	andmi	r8, r1, #2, 28
 47c:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 480:	080d0c82 	stmdaeq	sp, {r1, r7, sl, fp}
 484:	00000020 	andeq	r0, r0, r0, lsr #32
 488:	0000020c 	andeq	r0, r0, ip, lsl #4
 48c:	0000954c 	andeq	r9, r0, ip, asr #10
 490:	000000c4 	andeq	r0, r0, r4, asr #1
 494:	840c0e42 	strhi	r0, [ip], #-3650	; 0xfffff1be
 498:	8e028b03 	vmlahi.f64	d8, d2, d3
 49c:	0b0c4201 	bleq	310ca8 <__bss_end+0x304bb0>
 4a0:	0c5a0204 	lfmeq	f0, 2, [sl], {4}
 4a4:	00000c0d 	andeq	r0, r0, sp, lsl #24
 4a8:	0000001c 	andeq	r0, r0, ip, lsl r0
 4ac:	0000020c 	andeq	r0, r0, ip, lsl #4
 4b0:	00009610 	andeq	r9, r0, r0, lsl r6
 4b4:	00000034 	andeq	r0, r0, r4, lsr r0
 4b8:	8b080e42 	blhi	203dc8 <__bss_end+0x1f7cd0>
 4bc:	42018e02 	andmi	r8, r1, #2, 28
 4c0:	52040b0c 	andpl	r0, r4, #12, 22	; 0x3000
 4c4:	00080d0c 	andeq	r0, r8, ip, lsl #26
 4c8:	00000018 	andeq	r0, r0, r8, lsl r0
 4cc:	0000020c 	andeq	r0, r0, ip, lsl #4
 4d0:	00009644 	andeq	r9, r0, r4, asr #12
 4d4:	000002e0 	andeq	r0, r0, r0, ror #5
 4d8:	8b080e42 	blhi	203de8 <__bss_end+0x1f7cf0>
 4dc:	42018e02 	andmi	r8, r1, #2, 28
 4e0:	00040b0c 	andeq	r0, r4, ip, lsl #22
 4e4:	0000000c 	andeq	r0, r0, ip
 4e8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 4ec:	7c020001 	stcvc	0, cr0, [r2], {1}
 4f0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 4f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 4f8:	000004e4 	andeq	r0, r0, r4, ror #9
 4fc:	00009984 	andeq	r9, r0, r4, lsl #19
 500:	000001bc 			; <UNDEFINED> instruction: 0x000001bc
 504:	8b040e42 	blhi	103e14 <__bss_end+0xf7d1c>
 508:	0b0d4201 	bleq	350d14 <__bss_end+0x344c1c>
 50c:	0d0dd602 	stceq	6, cr13, [sp, #-8]
 510:	000ecb42 	andeq	ip, lr, r2, asr #22
 514:	0000001c 	andeq	r0, r0, ip, lsl r0
 518:	000004e4 	andeq	r0, r0, r4, ror #9
 51c:	00009b40 	andeq	r9, r0, r0, asr #22
 520:	0000007c 	andeq	r0, r0, ip, ror r0
 524:	8b080e42 	blhi	203e34 <__bss_end+0x1f7d3c>
 528:	42018e02 	andmi	r8, r1, #2, 28
 52c:	78040b0c 	stmdavc	r4, {r2, r3, r8, r9, fp}
 530:	00080d0c 	andeq	r0, r8, ip, lsl #26
 534:	0000001c 	andeq	r0, r0, ip, lsl r0
 538:	000004e4 	andeq	r0, r0, r4, ror #9
 53c:	00009bbc 			; <UNDEFINED> instruction: 0x00009bbc
 540:	00000038 	andeq	r0, r0, r8, lsr r0
 544:	8b080e42 	blhi	203e54 <__bss_end+0x1f7d5c>
 548:	42018e02 	andmi	r8, r1, #2, 28
 54c:	56040b0c 	strpl	r0, [r4], -ip, lsl #22
 550:	00080d0c 	andeq	r0, r8, ip, lsl #26
 554:	0000000c 	andeq	r0, r0, ip
 558:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 55c:	7c020001 	stcvc	0, cr0, [r2], {1}
 560:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 564:	0000001c 	andeq	r0, r0, ip, lsl r0
 568:	00000554 	andeq	r0, r0, r4, asr r5
 56c:	00009bf4 	strdeq	r9, [r0], -r4
 570:	00000048 	andeq	r0, r0, r8, asr #32
 574:	8b040e42 	blhi	103e84 <__bss_end+0xf7d8c>
 578:	0b0d4201 	bleq	350d84 <__bss_end+0x344c8c>
 57c:	420d0d5c 	andmi	r0, sp, #92, 26	; 0x1700
 580:	00000ecb 	andeq	r0, r0, fp, asr #29
 584:	0000001c 	andeq	r0, r0, ip, lsl r0
 588:	00000554 	andeq	r0, r0, r4, asr r5
 58c:	00009c3c 	andeq	r9, r0, ip, lsr ip
 590:	00000070 	andeq	r0, r0, r0, ror r0
 594:	8b040e42 	blhi	103ea4 <__bss_end+0xf7dac>
 598:	0b0d4201 	bleq	350da4 <__bss_end+0x344cac>
 59c:	420d0d70 	andmi	r0, sp, #112, 26	; 0x1c00
 5a0:	00000ecb 	andeq	r0, r0, fp, asr #29
 5a4:	0000001c 	andeq	r0, r0, ip, lsl r0
 5a8:	00000554 	andeq	r0, r0, r4, asr r5
 5ac:	00009cac 	andeq	r9, r0, ip, lsr #25
 5b0:	00000028 	andeq	r0, r0, r8, lsr #32
 5b4:	8b040e42 	blhi	103ec4 <__bss_end+0xf7dcc>
 5b8:	0b0d4201 	bleq	350dc4 <__bss_end+0x344ccc>
 5bc:	420d0d4c 	andmi	r0, sp, #76, 26	; 0x1300
 5c0:	00000ecb 	andeq	r0, r0, fp, asr #29
 5c4:	0000001c 	andeq	r0, r0, ip, lsl r0
 5c8:	00000554 	andeq	r0, r0, r4, asr r5
 5cc:	00009cd4 	ldrdeq	r9, [r0], -r4
 5d0:	00000080 	andeq	r0, r0, r0, lsl #1
 5d4:	8b080e42 	blhi	203ee4 <__bss_end+0x1f7dec>
 5d8:	42018e02 	andmi	r8, r1, #2, 28
 5dc:	7a040b0c 	bvc	103214 <__bss_end+0xf711c>
 5e0:	00080d0c 	andeq	r0, r8, ip, lsl #26
 5e4:	0000001c 	andeq	r0, r0, ip, lsl r0
 5e8:	00000554 	andeq	r0, r0, r4, asr r5
 5ec:	00009d54 	andeq	r9, r0, r4, asr sp
 5f0:	0000004c 	andeq	r0, r0, ip, asr #32
 5f4:	8b080e42 	blhi	203f04 <__bss_end+0x1f7e0c>
 5f8:	42018e02 	andmi	r8, r1, #2, 28
 5fc:	5c040b0c 			; <UNDEFINED> instruction: 0x5c040b0c
 600:	00080d0c 	andeq	r0, r8, ip, lsl #26
 604:	00000018 	andeq	r0, r0, r8, lsl r0
 608:	00000554 	andeq	r0, r0, r4, asr r5
 60c:	00009da0 	andeq	r9, r0, r0, lsr #27
 610:	0000001c 	andeq	r0, r0, ip, lsl r0
 614:	8b080e42 	blhi	203f24 <__bss_end+0x1f7e2c>
 618:	42018e02 	andmi	r8, r1, #2, 28
 61c:	00040b0c 	andeq	r0, r4, ip, lsl #22
 620:	0000000c 	andeq	r0, r0, ip
 624:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 628:	7c020001 	stcvc	0, cr0, [r2], {1}
 62c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 630:	0000001c 	andeq	r0, r0, ip, lsl r0
 634:	00000620 	andeq	r0, r0, r0, lsr #12
 638:	00009dc0 	andeq	r9, r0, r0, asr #27
 63c:	00000078 	andeq	r0, r0, r8, ror r0
 640:	8b040e42 	blhi	103f50 <__bss_end+0xf7e58>
 644:	0b0d4201 	bleq	350e50 <__bss_end+0x344d58>
 648:	420d0d74 	andmi	r0, sp, #116, 26	; 0x1d00
 64c:	00000ecb 	andeq	r0, r0, fp, asr #29
 650:	0000001c 	andeq	r0, r0, ip, lsl r0
 654:	00000620 	andeq	r0, r0, r0, lsr #12
 658:	00009e38 	andeq	r9, r0, r8, lsr lr
 65c:	00000090 	muleq	r0, r0, r0
 660:	8b080e42 	blhi	203f70 <__bss_end+0x1f7e78>
 664:	42018e02 	andmi	r8, r1, #2, 28
 668:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 66c:	080d0c42 	stmdaeq	sp, {r1, r6, sl, fp}
 670:	0000001c 	andeq	r0, r0, ip, lsl r0
 674:	00000620 	andeq	r0, r0, r0, lsr #12
 678:	00009ec8 	andeq	r9, r0, r8, asr #29
 67c:	00000058 	andeq	r0, r0, r8, asr r0
 680:	8b080e42 	blhi	203f90 <__bss_end+0x1f7e98>
 684:	42018e02 	andmi	r8, r1, #2, 28
 688:	60040b0c 	andvs	r0, r4, ip, lsl #22
 68c:	00080d0c 	andeq	r0, r8, ip, lsl #26
 690:	0000000c 	andeq	r0, r0, ip
 694:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 698:	7c020001 	stcvc	0, cr0, [r2], {1}
 69c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 6a0:	0000001c 	andeq	r0, r0, ip, lsl r0
 6a4:	00000690 	muleq	r0, r0, r6
 6a8:	00009924 	andeq	r9, r0, r4, lsr #18
 6ac:	00000030 	andeq	r0, r0, r0, lsr r0
 6b0:	8b080e42 	blhi	203fc0 <__bss_end+0x1f7ec8>
 6b4:	42018e02 	andmi	r8, r1, #2, 28
 6b8:	50040b0c 	andpl	r0, r4, ip, lsl #22
 6bc:	00080d0c 	andeq	r0, r8, ip, lsl #26
 6c0:	0000001c 	andeq	r0, r0, ip, lsl r0
 6c4:	00000690 	muleq	r0, r0, r6
 6c8:	00009f20 	andeq	r9, r0, r0, lsr #30
 6cc:	0000004c 	andeq	r0, r0, ip, asr #32
 6d0:	8b040e42 	blhi	103fe0 <__bss_end+0xf7ee8>
 6d4:	0b0d4201 	bleq	350ee0 <__bss_end+0x344de8>
 6d8:	420d0d5e 	andmi	r0, sp, #6016	; 0x1780
 6dc:	00000ecb 	andeq	r0, r0, fp, asr #29
 6e0:	0000001c 	andeq	r0, r0, ip, lsl r0
 6e4:	00000690 	muleq	r0, r0, r6
 6e8:	00009f6c 	andeq	r9, r0, ip, ror #30
 6ec:	00000040 	andeq	r0, r0, r0, asr #32
 6f0:	8b040e42 	blhi	104000 <__bss_end+0xf7f08>
 6f4:	0b0d4201 	bleq	350f00 <__bss_end+0x344e08>
 6f8:	420d0d58 	andmi	r0, sp, #88, 26	; 0x1600
 6fc:	00000ecb 	andeq	r0, r0, fp, asr #29
 700:	0000001c 	andeq	r0, r0, ip, lsl r0
 704:	00000690 	muleq	r0, r0, r6
 708:	00009fac 	andeq	r9, r0, ip, lsr #31
 70c:	00000038 	andeq	r0, r0, r8, lsr r0
 710:	8b040e42 	blhi	104020 <__bss_end+0xf7f28>
 714:	0b0d4201 	bleq	350f20 <__bss_end+0x344e28>
 718:	420d0d54 	andmi	r0, sp, #84, 26	; 0x1500
 71c:	00000ecb 	andeq	r0, r0, fp, asr #29
 720:	0000001c 	andeq	r0, r0, ip, lsl r0
 724:	00000690 	muleq	r0, r0, r6
 728:	00009fe4 	andeq	r9, r0, r4, ror #31
 72c:	00000054 	andeq	r0, r0, r4, asr r0
 730:	8b040e42 	blhi	104040 <__bss_end+0xf7f48>
 734:	0b0d4201 	bleq	350f40 <__bss_end+0x344e48>
 738:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 73c:	00000ecb 	andeq	r0, r0, fp, asr #29
 740:	0000001c 	andeq	r0, r0, ip, lsl r0
 744:	00000690 	muleq	r0, r0, r6
 748:	0000a038 	andeq	sl, r0, r8, lsr r0
 74c:	00000038 	andeq	r0, r0, r8, lsr r0
 750:	8b040e42 	blhi	104060 <__bss_end+0xf7f68>
 754:	0b0d4201 	bleq	350f60 <__bss_end+0x344e68>
 758:	420d0d54 	andmi	r0, sp, #84, 26	; 0x1500
 75c:	00000ecb 	andeq	r0, r0, fp, asr #29
 760:	00000020 	andeq	r0, r0, r0, lsr #32
 764:	00000690 	muleq	r0, r0, r6
 768:	0000a070 	andeq	sl, r0, r0, ror r0
 76c:	00000044 	andeq	r0, r0, r4, asr #32
 770:	840c0e42 	strhi	r0, [ip], #-3650	; 0xfffff1be
 774:	8e028b03 	vmlahi.f64	d8, d2, d3
 778:	0b0c4201 	bleq	310f84 <__bss_end+0x304e8c>
 77c:	0d0c5c04 	stceq	12, cr5, [ip, #-16]
 780:	0000000c 	andeq	r0, r0, ip
 784:	0000001c 	andeq	r0, r0, ip, lsl r0
 788:	00000690 	muleq	r0, r0, r6
 78c:	0000a0b4 	strheq	sl, [r0], -r4
 790:	00000198 	muleq	r0, r8, r1
 794:	8b080e42 	blhi	2040a4 <__bss_end+0x1f7fac>
 798:	42018e02 	andmi	r8, r1, #2, 28
 79c:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 7a0:	080d0cc6 	stmdaeq	sp, {r1, r2, r6, r7, sl, fp}
 7a4:	0000001c 	andeq	r0, r0, ip, lsl r0
 7a8:	00000690 	muleq	r0, r0, r6
 7ac:	0000a24c 	andeq	sl, r0, ip, asr #4
 7b0:	00000068 	andeq	r0, r0, r8, rrx
 7b4:	8b080e42 	blhi	2040c4 <__bss_end+0x1f7fcc>
 7b8:	42018e02 	andmi	r8, r1, #2, 28
 7bc:	6e040b0c 	vmlavs.f64	d0, d4, d12
 7c0:	00080d0c 	andeq	r0, r8, ip, lsl #26
 7c4:	0000001c 	andeq	r0, r0, ip, lsl r0
 7c8:	00000690 	muleq	r0, r0, r6
 7cc:	0000a2b4 			; <UNDEFINED> instruction: 0x0000a2b4
 7d0:	0000007c 	andeq	r0, r0, ip, ror r0
 7d4:	8b080e42 	blhi	2040e4 <__bss_end+0x1f7fec>
 7d8:	42018e02 	andmi	r8, r1, #2, 28
 7dc:	76040b0c 	strvc	r0, [r4], -ip, lsl #22
 7e0:	00080d0c 	andeq	r0, r8, ip, lsl #26
 7e4:	0000000c 	andeq	r0, r0, ip
 7e8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 7ec:	7c020001 	stcvc	0, cr0, [r2], {1}
 7f0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 7f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 7f8:	000007e4 	andeq	r0, r0, r4, ror #15
 7fc:	0000a330 	andeq	sl, r0, r0, lsr r3
 800:	0000002c 	andeq	r0, r0, ip, lsr #32
 804:	8b040e42 	blhi	104114 <__bss_end+0xf801c>
 808:	0b0d4201 	bleq	351014 <__bss_end+0x344f1c>
 80c:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 810:	00000ecb 	andeq	r0, r0, fp, asr #29
 814:	0000001c 	andeq	r0, r0, ip, lsl r0
 818:	000007e4 	andeq	r0, r0, r4, ror #15
 81c:	0000a35c 	andeq	sl, r0, ip, asr r3
 820:	0000002c 	andeq	r0, r0, ip, lsr #32
 824:	8b040e42 	blhi	104134 <__bss_end+0xf803c>
 828:	0b0d4201 	bleq	351034 <__bss_end+0x344f3c>
 82c:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 830:	00000ecb 	andeq	r0, r0, fp, asr #29
 834:	0000001c 	andeq	r0, r0, ip, lsl r0
 838:	000007e4 	andeq	r0, r0, r4, ror #15
 83c:	0000a388 	andeq	sl, r0, r8, lsl #7
 840:	0000001c 	andeq	r0, r0, ip, lsl r0
 844:	8b040e42 	blhi	104154 <__bss_end+0xf805c>
 848:	0b0d4201 	bleq	351054 <__bss_end+0x344f5c>
 84c:	420d0d46 	andmi	r0, sp, #4480	; 0x1180
 850:	00000ecb 	andeq	r0, r0, fp, asr #29
 854:	0000001c 	andeq	r0, r0, ip, lsl r0
 858:	000007e4 	andeq	r0, r0, r4, ror #15
 85c:	0000a3a4 	andeq	sl, r0, r4, lsr #7
 860:	00000044 	andeq	r0, r0, r4, asr #32
 864:	8b040e42 	blhi	104174 <__bss_end+0xf807c>
 868:	0b0d4201 	bleq	351074 <__bss_end+0x344f7c>
 86c:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 870:	00000ecb 	andeq	r0, r0, fp, asr #29
 874:	0000001c 	andeq	r0, r0, ip, lsl r0
 878:	000007e4 	andeq	r0, r0, r4, ror #15
 87c:	0000a3e8 	andeq	sl, r0, r8, ror #7
 880:	00000050 	andeq	r0, r0, r0, asr r0
 884:	8b040e42 	blhi	104194 <__bss_end+0xf809c>
 888:	0b0d4201 	bleq	351094 <__bss_end+0x344f9c>
 88c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 890:	00000ecb 	andeq	r0, r0, fp, asr #29
 894:	0000001c 	andeq	r0, r0, ip, lsl r0
 898:	000007e4 	andeq	r0, r0, r4, ror #15
 89c:	0000a438 	andeq	sl, r0, r8, lsr r4
 8a0:	00000050 	andeq	r0, r0, r0, asr r0
 8a4:	8b040e42 	blhi	1041b4 <__bss_end+0xf80bc>
 8a8:	0b0d4201 	bleq	3510b4 <__bss_end+0x344fbc>
 8ac:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 8b0:	00000ecb 	andeq	r0, r0, fp, asr #29
 8b4:	0000001c 	andeq	r0, r0, ip, lsl r0
 8b8:	000007e4 	andeq	r0, r0, r4, ror #15
 8bc:	0000a488 	andeq	sl, r0, r8, lsl #9
 8c0:	0000002c 	andeq	r0, r0, ip, lsr #32
 8c4:	8b040e42 	blhi	1041d4 <__bss_end+0xf80dc>
 8c8:	0b0d4201 	bleq	3510d4 <__bss_end+0x344fdc>
 8cc:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 8d0:	00000ecb 	andeq	r0, r0, fp, asr #29
 8d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 8d8:	000007e4 	andeq	r0, r0, r4, ror #15
 8dc:	0000a4b4 			; <UNDEFINED> instruction: 0x0000a4b4
 8e0:	00000050 	andeq	r0, r0, r0, asr r0
 8e4:	8b040e42 	blhi	1041f4 <__bss_end+0xf80fc>
 8e8:	0b0d4201 	bleq	3510f4 <__bss_end+0x344ffc>
 8ec:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 8f0:	00000ecb 	andeq	r0, r0, fp, asr #29
 8f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 8f8:	000007e4 	andeq	r0, r0, r4, ror #15
 8fc:	0000a504 	andeq	sl, r0, r4, lsl #10
 900:	00000044 	andeq	r0, r0, r4, asr #32
 904:	8b040e42 	blhi	104214 <__bss_end+0xf811c>
 908:	0b0d4201 	bleq	351114 <__bss_end+0x34501c>
 90c:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 910:	00000ecb 	andeq	r0, r0, fp, asr #29
 914:	0000001c 	andeq	r0, r0, ip, lsl r0
 918:	000007e4 	andeq	r0, r0, r4, ror #15
 91c:	0000a548 	andeq	sl, r0, r8, asr #10
 920:	00000050 	andeq	r0, r0, r0, asr r0
 924:	8b040e42 	blhi	104234 <__bss_end+0xf813c>
 928:	0b0d4201 	bleq	351134 <__bss_end+0x34503c>
 92c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 930:	00000ecb 	andeq	r0, r0, fp, asr #29
 934:	0000001c 	andeq	r0, r0, ip, lsl r0
 938:	000007e4 	andeq	r0, r0, r4, ror #15
 93c:	0000a598 	muleq	r0, r8, r5
 940:	00000054 	andeq	r0, r0, r4, asr r0
 944:	8b040e42 	blhi	104254 <__bss_end+0xf815c>
 948:	0b0d4201 	bleq	351154 <__bss_end+0x34505c>
 94c:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 950:	00000ecb 	andeq	r0, r0, fp, asr #29
 954:	0000001c 	andeq	r0, r0, ip, lsl r0
 958:	000007e4 	andeq	r0, r0, r4, ror #15
 95c:	0000a5ec 	andeq	sl, r0, ip, ror #11
 960:	0000003c 	andeq	r0, r0, ip, lsr r0
 964:	8b040e42 	blhi	104274 <__bss_end+0xf817c>
 968:	0b0d4201 	bleq	351174 <__bss_end+0x34507c>
 96c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 970:	00000ecb 	andeq	r0, r0, fp, asr #29
 974:	0000001c 	andeq	r0, r0, ip, lsl r0
 978:	000007e4 	andeq	r0, r0, r4, ror #15
 97c:	0000a628 	andeq	sl, r0, r8, lsr #12
 980:	0000003c 	andeq	r0, r0, ip, lsr r0
 984:	8b040e42 	blhi	104294 <__bss_end+0xf819c>
 988:	0b0d4201 	bleq	351194 <__bss_end+0x34509c>
 98c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 990:	00000ecb 	andeq	r0, r0, fp, asr #29
 994:	0000001c 	andeq	r0, r0, ip, lsl r0
 998:	000007e4 	andeq	r0, r0, r4, ror #15
 99c:	0000a664 	andeq	sl, r0, r4, ror #12
 9a0:	0000003c 	andeq	r0, r0, ip, lsr r0
 9a4:	8b040e42 	blhi	1042b4 <__bss_end+0xf81bc>
 9a8:	0b0d4201 	bleq	3511b4 <__bss_end+0x3450bc>
 9ac:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 9b0:	00000ecb 	andeq	r0, r0, fp, asr #29
 9b4:	0000001c 	andeq	r0, r0, ip, lsl r0
 9b8:	000007e4 	andeq	r0, r0, r4, ror #15
 9bc:	0000a6a0 	andeq	sl, r0, r0, lsr #13
 9c0:	0000003c 	andeq	r0, r0, ip, lsr r0
 9c4:	8b040e42 	blhi	1042d4 <__bss_end+0xf81dc>
 9c8:	0b0d4201 	bleq	3511d4 <__bss_end+0x3450dc>
 9cc:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 9d0:	00000ecb 	andeq	r0, r0, fp, asr #29
 9d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 9d8:	000007e4 	andeq	r0, r0, r4, ror #15
 9dc:	0000a6dc 	ldrdeq	sl, [r0], -ip
 9e0:	000000b0 	strheq	r0, [r0], -r0	; <UNPREDICTABLE>
 9e4:	8b080e42 	blhi	2042f4 <__bss_end+0x1f81fc>
 9e8:	42018e02 	andmi	r8, r1, #2, 28
 9ec:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 9f0:	080d0c50 	stmdaeq	sp, {r4, r6, sl, fp}
 9f4:	0000000c 	andeq	r0, r0, ip
 9f8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 9fc:	7c020001 	stcvc	0, cr0, [r2], {1}
 a00:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 a04:	0000001c 	andeq	r0, r0, ip, lsl r0
 a08:	000009f4 	strdeq	r0, [r0], -r4
 a0c:	0000a790 	muleq	r0, r0, r7
 a10:	00000178 	andeq	r0, r0, r8, ror r1
 a14:	8b080e42 	blhi	204324 <__bss_end+0x1f822c>
 a18:	42018e02 	andmi	r8, r1, #2, 28
 a1c:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 a20:	080d0cb4 	stmdaeq	sp, {r2, r4, r5, r7, sl, fp}
 a24:	0000001c 	andeq	r0, r0, ip, lsl r0
 a28:	000009f4 	strdeq	r0, [r0], -r4
 a2c:	0000a908 	andeq	sl, r0, r8, lsl #18
 a30:	0000009c 	muleq	r0, ip, r0
 a34:	8b040e42 	blhi	104344 <__bss_end+0xf824c>
 a38:	0b0d4201 	bleq	351244 <__bss_end+0x34514c>
 a3c:	0d0d4602 	stceq	6, cr4, [sp, #-8]
 a40:	000ecb42 	andeq	ip, lr, r2, asr #22
 a44:	0000001c 	andeq	r0, r0, ip, lsl r0
 a48:	000009f4 	strdeq	r0, [r0], -r4
 a4c:	0000a9a4 	andeq	sl, r0, r4, lsr #19
 a50:	00000100 	andeq	r0, r0, r0, lsl #2
 a54:	8b040e42 	blhi	104364 <__bss_end+0xf826c>
 a58:	0b0d4201 	bleq	351264 <__bss_end+0x34516c>
 a5c:	0d0d7802 	stceq	8, cr7, [sp, #-8]
 a60:	000ecb42 	andeq	ip, lr, r2, asr #22
 a64:	0000001c 	andeq	r0, r0, ip, lsl r0
 a68:	000009f4 	strdeq	r0, [r0], -r4
 a6c:	0000aaa4 	andeq	sl, r0, r4, lsr #21
 a70:	0000015c 	andeq	r0, r0, ip, asr r1
 a74:	8b040e42 	blhi	104384 <__bss_end+0xf828c>
 a78:	0b0d4201 	bleq	351284 <__bss_end+0x34518c>
 a7c:	0d0d9c02 	stceq	12, cr9, [sp, #-8]
 a80:	000ecb42 	andeq	ip, lr, r2, asr #22
 a84:	0000001c 	andeq	r0, r0, ip, lsl r0
 a88:	000009f4 	strdeq	r0, [r0], -r4
 a8c:	0000ac00 	andeq	sl, r0, r0, lsl #24
 a90:	000000c0 	andeq	r0, r0, r0, asr #1
 a94:	8b040e42 	blhi	1043a4 <__bss_end+0xf82ac>
 a98:	0b0d4201 	bleq	3512a4 <__bss_end+0x3451ac>
 a9c:	0d0d5802 	stceq	8, cr5, [sp, #-8]
 aa0:	000ecb42 	andeq	ip, lr, r2, asr #22
 aa4:	0000001c 	andeq	r0, r0, ip, lsl r0
 aa8:	000009f4 	strdeq	r0, [r0], -r4
 aac:	0000acc0 	andeq	sl, r0, r0, asr #25
 ab0:	000000ac 	andeq	r0, r0, ip, lsr #1
 ab4:	8b040e42 	blhi	1043c4 <__bss_end+0xf82cc>
 ab8:	0b0d4201 	bleq	3512c4 <__bss_end+0x3451cc>
 abc:	0d0d4e02 	stceq	14, cr4, [sp, #-8]
 ac0:	000ecb42 	andeq	ip, lr, r2, asr #22
 ac4:	0000001c 	andeq	r0, r0, ip, lsl r0
 ac8:	000009f4 	strdeq	r0, [r0], -r4
 acc:	0000ad6c 	andeq	sl, r0, ip, ror #26
 ad0:	00000054 	andeq	r0, r0, r4, asr r0
 ad4:	8b040e42 	blhi	1043e4 <__bss_end+0xf82ec>
 ad8:	0b0d4201 	bleq	3512e4 <__bss_end+0x3451ec>
 adc:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 ae0:	00000ecb 	andeq	r0, r0, fp, asr #29
 ae4:	0000001c 	andeq	r0, r0, ip, lsl r0
 ae8:	000009f4 	strdeq	r0, [r0], -r4
 aec:	0000adc0 	andeq	sl, r0, r0, asr #27
 af0:	000000ac 	andeq	r0, r0, ip, lsr #1
 af4:	8b080e42 	blhi	204404 <__bss_end+0x1f830c>
 af8:	42018e02 	andmi	r8, r1, #2, 28
 afc:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 b00:	080d0c50 	stmdaeq	sp, {r4, r6, sl, fp}
 b04:	0000001c 	andeq	r0, r0, ip, lsl r0
 b08:	000009f4 	strdeq	r0, [r0], -r4
 b0c:	0000ae6c 	andeq	sl, r0, ip, ror #28
 b10:	000000d8 	ldrdeq	r0, [r0], -r8
 b14:	8b080e42 	blhi	204424 <__bss_end+0x1f832c>
 b18:	42018e02 	andmi	r8, r1, #2, 28
 b1c:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 b20:	080d0c66 	stmdaeq	sp, {r1, r2, r5, r6, sl, fp}
 b24:	0000001c 	andeq	r0, r0, ip, lsl r0
 b28:	000009f4 	strdeq	r0, [r0], -r4
 b2c:	0000af44 	andeq	sl, r0, r4, asr #30
 b30:	00000068 	andeq	r0, r0, r8, rrx
 b34:	8b040e42 	blhi	104444 <__bss_end+0xf834c>
 b38:	0b0d4201 	bleq	351344 <__bss_end+0x34524c>
 b3c:	420d0d6c 	andmi	r0, sp, #108, 26	; 0x1b00
 b40:	00000ecb 	andeq	r0, r0, fp, asr #29
 b44:	0000001c 	andeq	r0, r0, ip, lsl r0
 b48:	000009f4 	strdeq	r0, [r0], -r4
 b4c:	0000afac 	andeq	sl, r0, ip, lsr #31
 b50:	00000080 	andeq	r0, r0, r0, lsl #1
 b54:	8b040e42 	blhi	104464 <__bss_end+0xf836c>
 b58:	0b0d4201 	bleq	351364 <__bss_end+0x34526c>
 b5c:	420d0d78 	andmi	r0, sp, #120, 26	; 0x1e00
 b60:	00000ecb 	andeq	r0, r0, fp, asr #29
 b64:	0000001c 	andeq	r0, r0, ip, lsl r0
 b68:	000009f4 	strdeq	r0, [r0], -r4
 b6c:	0000b02c 	andeq	fp, r0, ip, lsr #32
 b70:	00000068 	andeq	r0, r0, r8, rrx
 b74:	8b040e42 	blhi	104484 <__bss_end+0xf838c>
 b78:	0b0d4201 	bleq	351384 <__bss_end+0x34528c>
 b7c:	420d0d6c 	andmi	r0, sp, #108, 26	; 0x1b00
 b80:	00000ecb 	andeq	r0, r0, fp, asr #29
 b84:	0000002c 	andeq	r0, r0, ip, lsr #32
 b88:	000009f4 	strdeq	r0, [r0], -r4
 b8c:	0000b094 	muleq	r0, r4, r0
 b90:	00000328 	andeq	r0, r0, r8, lsr #6
 b94:	84200e42 	strthi	r0, [r0], #-3650	; 0xfffff1be
 b98:	86078508 	strhi	r8, [r7], -r8, lsl #10
 b9c:	88058706 	stmdahi	r5, {r1, r2, r8, r9, sl, pc}
 ba0:	8b038904 	blhi	e2fb8 <__bss_end+0xd6ec0>
 ba4:	42018e02 	andmi	r8, r1, #2, 28
 ba8:	03040b0c 	movweq	r0, #19212	; 0x4b0c
 bac:	0d0c018a 	stfeqs	f0, [ip, #-552]	; 0xfffffdd8
 bb0:	00000020 	andeq	r0, r0, r0, lsr #32
 bb4:	0000000c 	andeq	r0, r0, ip
 bb8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 bbc:	7c010001 	stcvc	0, cr0, [r1], {1}
 bc0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 bc4:	0000000c 	andeq	r0, r0, ip
 bc8:	00000bb4 			; <UNDEFINED> instruction: 0x00000bb4
 bcc:	0000b3bc 			; <UNDEFINED> instruction: 0x0000b3bc
 bd0:	000001ec 	andeq	r0, r0, ip, ror #3
 bd4:	0000000c 	andeq	r0, r0, ip
 bd8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 bdc:	7c010001 	stcvc	0, cr0, [r1], {1}
 be0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 be4:	0000000c 	andeq	r0, r0, ip
 be8:	00000bd4 	ldrdeq	r0, [r0], -r4
 bec:	0000b5c8 	andeq	fp, r0, r8, asr #11
 bf0:	00000220 	andeq	r0, r0, r0, lsr #4
 bf4:	0000000c 	andeq	r0, r0, ip
 bf8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 bfc:	7c020001 	stcvc	0, cr0, [r2], {1}
 c00:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 c04:	00000010 	andeq	r0, r0, r0, lsl r0
 c08:	00000bf4 	strdeq	r0, [r0], -r4
 c0c:	0000b80c 	andeq	fp, r0, ip, lsl #16
 c10:	0000019c 	muleq	r0, ip, r1
 c14:	0bce020a 	bleq	ff381444 <__bss_end+0xff37534c>
 c18:	00000010 	andeq	r0, r0, r0, lsl r0
 c1c:	00000bf4 	strdeq	r0, [r0], -r4
 c20:	0000b9a8 	andeq	fp, r0, r8, lsr #19
 c24:	00000028 	andeq	r0, r0, r8, lsr #32
 c28:	000b540a 	andeq	r5, fp, sl, lsl #8
 c2c:	00000010 	andeq	r0, r0, r0, lsl r0
 c30:	00000bf4 	strdeq	r0, [r0], -r4
 c34:	0000b9d0 	ldrdeq	fp, [r0], -r0
 c38:	0000008c 	andeq	r0, r0, ip, lsl #1
 c3c:	0b46020a 	bleq	118146c <__bss_end+0x1175374>
 c40:	0000000c 	andeq	r0, r0, ip
 c44:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 c48:	7c020001 	stcvc	0, cr0, [r2], {1}
 c4c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 c50:	00000030 	andeq	r0, r0, r0, lsr r0
 c54:	00000c40 	andeq	r0, r0, r0, asr #24
 c58:	0000ba5c 	andeq	fp, r0, ip, asr sl
 c5c:	000000d4 	ldrdeq	r0, [r0], -r4
 c60:	8e100e5a 	mrchi	14, 0, r0, cr0, cr10, {2}
 c64:	460a4a03 	strmi	r4, [sl], -r3, lsl #20
 c68:	42100ece 	andsmi	r0, r0, #3296	; 0xce0
 c6c:	460a4a0b 	strmi	r4, [sl], -fp, lsl #20
 c70:	4a100ece 	bmi	4047b0 <__bss_end+0x3f86b8>
 c74:	460a460b 	strmi	r4, [sl], -fp, lsl #12
 c78:	46100ece 	ldrmi	r0, [r0], -lr, asr #29
 c7c:	0ece4c0b 	cdpeq	12, 12, cr4, cr14, cr11, {0}
 c80:	00000010 	andeq	r0, r0, r0, lsl r0
 c84:	0000000c 	andeq	r0, r0, ip
 c88:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 c8c:	7c020001 	stcvc	0, cr0, [r2], {1}
 c90:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 c94:	00000014 	andeq	r0, r0, r4, lsl r0
 c98:	00000c84 	andeq	r0, r0, r4, lsl #25
 c9c:	0000bb30 	andeq	fp, r0, r0, lsr fp
 ca0:	00000030 	andeq	r0, r0, r0, lsr r0
 ca4:	84080e4e 	strhi	r0, [r8], #-3662	; 0xfffff1b2
 ca8:	00018e02 	andeq	r8, r1, r2, lsl #28
 cac:	0000000c 	andeq	r0, r0, ip
 cb0:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 cb4:	7c020001 	stcvc	0, cr0, [r2], {1}
 cb8:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 cbc:	0000000c 	andeq	r0, r0, ip
 cc0:	00000cac 	andeq	r0, r0, ip, lsr #25
 cc4:	0000bb60 	andeq	fp, r0, r0, ror #22
 cc8:	00000040 	andeq	r0, r0, r0, asr #32
 ccc:	0000000c 	andeq	r0, r0, ip
 cd0:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 cd4:	7c020001 	stcvc	0, cr0, [r2], {1}
 cd8:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 cdc:	00000020 	andeq	r0, r0, r0, lsr #32
 ce0:	00000ccc 	andeq	r0, r0, ip, asr #25
 ce4:	0000bba0 	andeq	fp, r0, r0, lsr #23
 ce8:	00000120 	andeq	r0, r0, r0, lsr #2
 cec:	841c0e46 	ldrhi	r0, [ip], #-3654	; 0xfffff1ba
 cf0:	86068507 	strhi	r8, [r6], -r7, lsl #10
 cf4:	88048705 	stmdahi	r4, {r0, r2, r8, r9, sl, pc}
 cf8:	8e028903 	vmlahi.f16	s16, s4, s6	; <UNPREDICTABLE>
 cfc:	00000001 	andeq	r0, r0, r1
 d00:	0000000c 	andeq	r0, r0, ip
 d04:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 d08:	7c020001 	stcvc	0, cr0, [r2], {1}
 d0c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 d10:	00000034 	andeq	r0, r0, r4, lsr r0
 d14:	00000d00 	andeq	r0, r0, r0, lsl #26
 d18:	0000bcc0 	andeq	fp, r0, r0, asr #25
 d1c:	00000118 	andeq	r0, r0, r8, lsl r1
 d20:	840c0e62 	strhi	r0, [ip], #-3682	; 0xfffff19e
 d24:	8e028503 	cfsh32hi	mvfx8, mvfx2, #3
 d28:	0e4e0201 	cdpeq	2, 4, cr0, cr14, cr1, {0}
 d2c:	cec5c400 	cdpgt	4, 12, cr12, cr5, cr0, {0}
 d30:	840c0e50 	strhi	r0, [ip], #-3664	; 0xfffff1b0
 d34:	8e028503 	cfsh32hi	mvfx8, mvfx2, #3
 d38:	000e4401 	andeq	r4, lr, r1, lsl #8
 d3c:	44cec5c4 	strbmi	ip, [lr], #1476	; 0x5c4
 d40:	03840c0e 	orreq	r0, r4, #3584	; 0xe00
 d44:	018e0285 	orreq	r0, lr, r5, lsl #5

Disassembly of section .debug_ranges:

00000000 <.debug_ranges>:
   0:	0000822c 	andeq	r8, r0, ip, lsr #4
   4:	00008590 	muleq	r0, r0, r5
   8:	00008590 	muleq	r0, r0, r5
   c:	000085c0 	andeq	r8, r0, r0, asr #11
	...
  18:	000088c4 	andeq	r8, r0, r4, asr #17
  1c:	00008954 	andeq	r8, r0, r4, asr r9
  20:	00008964 	andeq	r8, r0, r4, ror #18
  24:	00008968 	andeq	r8, r0, r8, ror #18
	...
  30:	000085c0 	andeq	r8, r0, r0, asr #11
  34:	00009924 	andeq	r9, r0, r4, lsr #18
  38:	00008590 	muleq	r0, r0, r5
  3c:	000085c0 	andeq	r8, r0, r0, asr #11
  40:	00009924 	andeq	r9, r0, r4, lsr #18
  44:	00009954 	andeq	r9, r0, r4, asr r9
  48:	00009954 	andeq	r9, r0, r4, asr r9
  4c:	00009984 	andeq	r9, r0, r4, lsl #19
	...
  58:	0000a2e0 	andeq	sl, r0, r0, ror #5
  5c:	0000a310 	andeq	sl, r0, r0, lsl r3
  60:	0000a318 	andeq	sl, r0, r8, lsl r3
  64:	0000a31c 	andeq	sl, r0, ip, lsl r3
	...
  70:	00009f20 	andeq	r9, r0, r0, lsr #30
  74:	0000a330 	andeq	sl, r0, r0, lsr r3
  78:	00009924 	andeq	r9, r0, r4, lsr #18
  7c:	00009954 	andeq	r9, r0, r4, asr r9
	...

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
	...
 348:	0000cc00 	andeq	ip, r0, r0, lsl #24
 34c:	51000100 	mrspl	r0, (UNDEF: 16)
 350:	000000cc 	andeq	r0, r0, ip, asr #1
 354:	000000e0 	andeq	r0, r0, r0, ror #1
 358:	01f30004 	mvnseq	r0, r4
 35c:	00e09f51 	rsceq	r9, r0, r1, asr pc
 360:	00ec0000 	rsceq	r0, ip, r0
 364:	00010000 	andeq	r0, r1, r0
 368:	0000ec51 	andeq	lr, r0, r1, asr ip
 36c:	00010000 	andeq	r0, r1, r0
 370:	f3000400 	vshl.u8	d0, d0, d0
 374:	009f5101 	addseq	r5, pc, r1, lsl #2
 378:	18000001 	stmdane	r0, {r0}
 37c:	01000001 	tsteq	r0, r1
 380:	00005100 	andeq	r5, r0, r0, lsl #2
	...
 390:	00010000 	andeq	r0, r1, r0
 394:	01000000 	mrseq	r0, (UNDEF: 0)
 398:	00000001 	andeq	r0, r0, r1
 39c:	00000000 	andeq	r0, r0, r0
 3a0:	00000010 	andeq	r0, r0, r0, lsl r0
 3a4:	10520001 	subsne	r0, r2, r1
 3a8:	20000000 	andcs	r0, r0, r0
 3ac:	01000000 	mrseq	r0, (UNDEF: 0)
 3b0:	00205200 	eoreq	r5, r0, r0, lsl #4
 3b4:	00240000 	eoreq	r0, r4, r0
 3b8:	00030000 	andeq	r0, r3, r0
 3bc:	249f7f72 	ldrcs	r7, [pc], #3954	; 3c4 <shift+0x3c4>
 3c0:	2c000000 	stccs	0, cr0, [r0], {-0}
 3c4:	01000000 	mrseq	r0, (UNDEF: 0)
 3c8:	002c5200 	eoreq	r5, ip, r0, lsl #4
 3cc:	00380000 	eorseq	r0, r8, r0
 3d0:	00030000 	andeq	r0, r3, r0
 3d4:	9c9f7f72 	ldcls	15, cr7, [pc], {114}	; 0x72
 3d8:	a0000000 	andge	r0, r0, r0
 3dc:	01000000 	mrseq	r0, (UNDEF: 0)
 3e0:	00c05200 	sbceq	r5, r0, r0, lsl #4
 3e4:	00c00000 	sbceq	r0, r0, r0
 3e8:	00010000 	andeq	r0, r1, r0
 3ec:	0000c052 	andeq	ip, r0, r2, asr r0
 3f0:	0000d000 	andeq	sp, r0, r0
 3f4:	72000300 	andvc	r0, r0, #0, 6
 3f8:	01009f7f 	tsteq	r0, pc, ror pc
 3fc:	01100000 	tsteq	r0, r0
 400:	00010000 	andeq	r0, r1, r0
 404:	00000052 	andeq	r0, r0, r2, asr r0
 408:	00000000 	andeq	r0, r0, r0
 40c:	00000200 	andeq	r0, r0, r0, lsl #4
 410:	00000202 	andeq	r0, r0, r2, lsl #4
 414:	01010000 	mrseq	r0, (UNDEF: 1)
 418:	01010000 	mrseq	r0, (UNDEF: 1)
	...
 424:	20000000 	andcs	r0, r0, r0
 428:	01000000 	mrseq	r0, (UNDEF: 0)
 42c:	00205000 	eoreq	r5, r0, r0
 430:	002c0000 	eoreq	r0, ip, r0
 434:	00010000 	andeq	r0, r1, r0
 438:	00002c53 	andeq	r2, r0, r3, asr ip
 43c:	00003000 	andeq	r3, r0, r0
 440:	73000300 	movwvc	r0, #768	; 0x300
 444:	00309f01 	eorseq	r9, r0, r1, lsl #30
 448:	00a40000 	adceq	r0, r4, r0
 44c:	00010000 	andeq	r0, r1, r0
 450:	0000c053 	andeq	ip, r0, r3, asr r0
 454:	0000d000 	andeq	sp, r0, r0
 458:	53000100 	movwpl	r0, #256	; 0x100
 45c:	000000d0 	ldrdeq	r0, [r0], -r0	; <UNPREDICTABLE>
 460:	000000d4 	ldrdeq	r0, [r0], -r4
 464:	01730003 	cmneq	r3, r3
 468:	0000d49f 	muleq	r0, pc, r4	; <UNPREDICTABLE>
 46c:	0000f000 	andeq	pc, r0, r0
 470:	53000100 	movwpl	r0, #256	; 0x100
 474:	000000f0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
 478:	000000f4 	strdeq	r0, [r0], -r4
 47c:	01730003 	cmneq	r3, r3
 480:	0000f49f 	muleq	r0, pc, r4	; <UNPREDICTABLE>
 484:	00010400 	andeq	r0, r1, r0, lsl #8
 488:	53000100 	movwpl	r0, #256	; 0x100
 48c:	00000108 	andeq	r0, r0, r8, lsl #2
 490:	00000110 	andeq	r0, r0, r0, lsl r1
 494:	10500001 	subsne	r0, r0, r1
 498:	18000001 	stmdane	r0, {r0}
 49c:	01000001 	tsteq	r0, r1
 4a0:	00005300 	andeq	r5, r0, r0, lsl #6
 4a4:	00000000 	andeq	r0, r0, r0
 4a8:	00010000 	andeq	r0, r1, r0
 4ac:	00000000 	andeq	r0, r0, r0
 4b0:	00000054 	andeq	r0, r0, r4, asr r0
 4b4:	000000e0 	andeq	r0, r0, r0, ror #1
 4b8:	20080003 	andcs	r0, r8, r3
 4bc:	0001009f 	muleq	r1, pc, r0	; <UNPREDICTABLE>
 4c0:	00010800 	andeq	r0, r1, r0, lsl #16
 4c4:	08000300 	stmdaeq	r0, {r8, r9}
 4c8:	01109f20 	tsteq	r0, r0, lsr #30
 4cc:	01180000 	tsteq	r8, r0
 4d0:	00030000 	andeq	r0, r3, r0
 4d4:	009f2008 	addseq	r2, pc, r8
	...
 4e4:	00004c00 	andeq	r4, r0, r0, lsl #24
 4e8:	0000e000 	andeq	lr, r0, r0
 4ec:	5e000100 	adfpls	f0, f0, f0
 4f0:	00000100 	andeq	r0, r0, r0, lsl #2
 4f4:	00000108 	andeq	r0, r0, r8, lsl #2
 4f8:	105e0001 	subsne	r0, lr, r1
 4fc:	18000001 	stmdane	r0, {r0}
 500:	01000001 	tsteq	r0, r1
 504:	00005e00 	andeq	r5, r0, r0, lsl #28
 508:	00000000 	andeq	r0, r0, r0
 50c:	00010000 	andeq	r0, r1, r0
 510:	01010101 	tsteq	r1, r1, lsl #2
 514:	00010101 	andeq	r0, r1, r1, lsl #2
 518:	00000000 	andeq	r0, r0, r0
 51c:	00010100 	andeq	r0, r1, r0, lsl #2
 520:	00000000 	andeq	r0, r0, r0
 524:	00480000 	subeq	r0, r8, r0
 528:	00700000 	rsbseq	r0, r0, r0
 52c:	00010000 	andeq	r0, r1, r0
 530:	00007053 	andeq	r7, r0, r3, asr r0
 534:	00007400 	andeq	r7, r0, r0, lsl #8
 538:	7c000300 	stcvc	3, cr0, [r0], {-0}
 53c:	00749f74 	rsbseq	r9, r4, r4, ror pc
 540:	00780000 	rsbseq	r0, r8, r0
 544:	00030000 	andeq	r0, r3, r0
 548:	789f787c 	ldmvc	pc, {r2, r3, r4, r5, r6, fp, ip, sp, lr}	; <UNPREDICTABLE>
 54c:	7c000000 	stcvc	0, cr0, [r0], {-0}
 550:	03000000 	movweq	r0, #0
 554:	9f7c7c00 	svcls	0x007c7c00
 558:	0000007c 	andeq	r0, r0, ip, ror r0
 55c:	00000084 	andeq	r0, r0, r4, lsl #1
 560:	845c0001 	ldrbhi	r0, [ip], #-1
 564:	90000000 	andls	r0, r0, r0
 568:	03000000 	movweq	r0, #0
 56c:	9f707c00 	svcls	0x00707c00
 570:	0000009c 	muleq	r0, ip, r0
 574:	000000a0 	andeq	r0, r0, r0, lsr #1
 578:	b05c0001 	subslt	r0, ip, r1
 57c:	b0000000 	andlt	r0, r0, r0
 580:	01000000 	mrseq	r0, (UNDEF: 0)
 584:	00b05c00 	adcseq	r5, r0, r0, lsl #24
 588:	00b40000 	adcseq	r0, r4, r0
 58c:	00030000 	andeq	r0, r3, r0
 590:	b49f047c 	ldrlt	r0, [pc], #1148	; 598 <shift+0x598>
 594:	e0000000 	and	r0, r0, r0
 598:	01000000 	mrseq	r0, (UNDEF: 0)
 59c:	01005c00 	tsteq	r0, r0, lsl #24
 5a0:	01080000 	mrseq	r0, (UNDEF: 8)
 5a4:	00010000 	andeq	r0, r1, r0
 5a8:	0001105c 	andeq	r1, r1, ip, asr r0
 5ac:	00011800 	andeq	r1, r1, r0, lsl #16
 5b0:	53000100 	movwpl	r0, #256	; 0x100
	...
 5c4:	00040000 	andeq	r0, r4, r0
 5c8:	00cc0000 	sbceq	r0, ip, r0
 5cc:	00060000 	andeq	r0, r6, r0
 5d0:	ff080071 			; <UNDEFINED> instruction: 0xff080071
 5d4:	00cc9f1a 	sbceq	r9, ip, sl, lsl pc
 5d8:	00e00000 	rsceq	r0, r0, r0
 5dc:	00070000 	andeq	r0, r7, r0
 5e0:	085101f3 	ldmdaeq	r1, {r0, r1, r4, r5, r6, r7, r8}^
 5e4:	e09f1aff 			; <UNDEFINED> instruction: 0xe09f1aff
 5e8:	ec000000 	stc	0, cr0, [r0], {-0}
 5ec:	06000000 	streq	r0, [r0], -r0
 5f0:	08007100 	stmdaeq	r0, {r8, ip, sp, lr}
 5f4:	ec9f1aff 	vldmia	pc, {s2-s256}
 5f8:	00000000 	andeq	r0, r0, r0
 5fc:	07000001 	streq	r0, [r0, -r1]
 600:	5101f300 	mrspl	pc, SP_irq	; <UNPREDICTABLE>
 604:	9f1aff08 	svcls	0x001aff08
 608:	00000100 	andeq	r0, r0, r0, lsl #2
 60c:	00000118 	andeq	r0, r0, r8, lsl r1
 610:	00710006 	rsbseq	r0, r1, r6
 614:	9f1aff08 	svcls	0x001aff08
	...
