
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
    805c:	0000c324 	andeq	ip, r0, r4, lsr #6
    8060:	0000c340 	andeq	ip, r0, r0, asr #6

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
    81cc:	0000c320 	andeq	ip, r0, r0, lsr #6
    81d0:	0000c324 	andeq	ip, r0, r4, lsr #6

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
    8224:	0000c324 	andeq	ip, r0, r4, lsr #6
    8228:	0000c324 	andeq	ip, r0, r4, lsr #6

0000822c <_Z10dummy_dataPf>:
_Z10dummy_dataPf():
/home/trefil/sem/sources/userspace/model_task/main.cpp:16
const int POPULATION_COUNT = 1000;
const int EPOCH_COUNT = 50;
const int DATA_WINDOW_SIZE = 20;

//vytvor sample data pro model
void dummy_data(float* data){
    822c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8230:	e28db000 	add	fp, sp, #0
    8234:	e24dd00c 	sub	sp, sp, #12
    8238:	e50b0008 	str	r0, [fp, #-8]
/home/trefil/sem/sources/userspace/model_task/main.cpp:18
    //sample data
    data[0] = 3.487;
    823c:	e51b3008 	ldr	r3, [fp, #-8]
    8240:	e59f2140 	ldr	r2, [pc, #320]	; 8388 <_Z10dummy_dataPf+0x15c>
    8244:	e5832000 	str	r2, [r3]
/home/trefil/sem/sources/userspace/model_task/main.cpp:19
    data[1] = 4.486;
    8248:	e51b3008 	ldr	r3, [fp, #-8]
    824c:	e2833004 	add	r3, r3, #4
    8250:	e59f2134 	ldr	r2, [pc, #308]	; 838c <_Z10dummy_dataPf+0x160>
    8254:	e5832000 	str	r2, [r3]
/home/trefil/sem/sources/userspace/model_task/main.cpp:20
    data[2] = 5.876;
    8258:	e51b3008 	ldr	r3, [fp, #-8]
    825c:	e2833008 	add	r3, r3, #8
    8260:	e59f2128 	ldr	r2, [pc, #296]	; 8390 <_Z10dummy_dataPf+0x164>
    8264:	e5832000 	str	r2, [r3]
/home/trefil/sem/sources/userspace/model_task/main.cpp:21
    data[3] = 6.4876;
    8268:	e51b3008 	ldr	r3, [fp, #-8]
    826c:	e283300c 	add	r3, r3, #12
    8270:	e59f211c 	ldr	r2, [pc, #284]	; 8394 <_Z10dummy_dataPf+0x168>
    8274:	e5832000 	str	r2, [r3]
/home/trefil/sem/sources/userspace/model_task/main.cpp:23

    data[4] = 7.486;
    8278:	e51b3008 	ldr	r3, [fp, #-8]
    827c:	e2833010 	add	r3, r3, #16
    8280:	e59f2110 	ldr	r2, [pc, #272]	; 8398 <_Z10dummy_dataPf+0x16c>
    8284:	e5832000 	str	r2, [r3]
/home/trefil/sem/sources/userspace/model_task/main.cpp:24
    data[5] = 8.4876;
    8288:	e51b3008 	ldr	r3, [fp, #-8]
    828c:	e2833014 	add	r3, r3, #20
    8290:	e59f2104 	ldr	r2, [pc, #260]	; 839c <_Z10dummy_dataPf+0x170>
    8294:	e5832000 	str	r2, [r3]
/home/trefil/sem/sources/userspace/model_task/main.cpp:25
    data[6] = 9.476;
    8298:	e51b3008 	ldr	r3, [fp, #-8]
    829c:	e2833018 	add	r3, r3, #24
    82a0:	e59f20f8 	ldr	r2, [pc, #248]	; 83a0 <_Z10dummy_dataPf+0x174>
    82a4:	e5832000 	str	r2, [r3]
/home/trefil/sem/sources/userspace/model_task/main.cpp:26
    data[7] = 11.76;
    82a8:	e51b3008 	ldr	r3, [fp, #-8]
    82ac:	e283301c 	add	r3, r3, #28
    82b0:	e59f20ec 	ldr	r2, [pc, #236]	; 83a4 <_Z10dummy_dataPf+0x178>
    82b4:	e5832000 	str	r2, [r3]
/home/trefil/sem/sources/userspace/model_task/main.cpp:27
    data[8] = 13.76;
    82b8:	e51b3008 	ldr	r3, [fp, #-8]
    82bc:	e2833020 	add	r3, r3, #32
    82c0:	e59f20e0 	ldr	r2, [pc, #224]	; 83a8 <_Z10dummy_dataPf+0x17c>
    82c4:	e5832000 	str	r2, [r3]
/home/trefil/sem/sources/userspace/model_task/main.cpp:28
    data[9] = 16.4876;
    82c8:	e51b3008 	ldr	r3, [fp, #-8]
    82cc:	e2833024 	add	r3, r3, #36	; 0x24
    82d0:	e59f20d4 	ldr	r2, [pc, #212]	; 83ac <_Z10dummy_dataPf+0x180>
    82d4:	e5832000 	str	r2, [r3]
/home/trefil/sem/sources/userspace/model_task/main.cpp:29
    data[10] = 16.4876;
    82d8:	e51b3008 	ldr	r3, [fp, #-8]
    82dc:	e2833028 	add	r3, r3, #40	; 0x28
    82e0:	e59f20c4 	ldr	r2, [pc, #196]	; 83ac <_Z10dummy_dataPf+0x180>
    82e4:	e5832000 	str	r2, [r3]
/home/trefil/sem/sources/userspace/model_task/main.cpp:30
    data[11] = 16.876;
    82e8:	e51b3008 	ldr	r3, [fp, #-8]
    82ec:	e283302c 	add	r3, r3, #44	; 0x2c
    82f0:	e59f20b8 	ldr	r2, [pc, #184]	; 83b0 <_Z10dummy_dataPf+0x184>
    82f4:	e5832000 	str	r2, [r3]
/home/trefil/sem/sources/userspace/model_task/main.cpp:31
    data[12] = 16.9876;
    82f8:	e51b3008 	ldr	r3, [fp, #-8]
    82fc:	e2833030 	add	r3, r3, #48	; 0x30
    8300:	e59f20ac 	ldr	r2, [pc, #172]	; 83b4 <_Z10dummy_dataPf+0x188>
    8304:	e5832000 	str	r2, [r3]
/home/trefil/sem/sources/userspace/model_task/main.cpp:32
    data[13] = 17.4876;
    8308:	e51b3008 	ldr	r3, [fp, #-8]
    830c:	e2833034 	add	r3, r3, #52	; 0x34
    8310:	e59f20a0 	ldr	r2, [pc, #160]	; 83b8 <_Z10dummy_dataPf+0x18c>
    8314:	e5832000 	str	r2, [r3]
/home/trefil/sem/sources/userspace/model_task/main.cpp:33
    data[14] = 17.9876;
    8318:	e51b3008 	ldr	r3, [fp, #-8]
    831c:	e2833038 	add	r3, r3, #56	; 0x38
    8320:	e59f2094 	ldr	r2, [pc, #148]	; 83bc <_Z10dummy_dataPf+0x190>
    8324:	e5832000 	str	r2, [r3]
/home/trefil/sem/sources/userspace/model_task/main.cpp:34
    data[15] = 18.4876;
    8328:	e51b3008 	ldr	r3, [fp, #-8]
    832c:	e283303c 	add	r3, r3, #60	; 0x3c
    8330:	e59f2088 	ldr	r2, [pc, #136]	; 83c0 <_Z10dummy_dataPf+0x194>
    8334:	e5832000 	str	r2, [r3]
/home/trefil/sem/sources/userspace/model_task/main.cpp:35
    data[16] = 18.9876;
    8338:	e51b3008 	ldr	r3, [fp, #-8]
    833c:	e2833040 	add	r3, r3, #64	; 0x40
    8340:	e59f207c 	ldr	r2, [pc, #124]	; 83c4 <_Z10dummy_dataPf+0x198>
    8344:	e5832000 	str	r2, [r3]
/home/trefil/sem/sources/userspace/model_task/main.cpp:36
    data[17] = 19.4576;
    8348:	e51b3008 	ldr	r3, [fp, #-8]
    834c:	e2833044 	add	r3, r3, #68	; 0x44
    8350:	e59f2070 	ldr	r2, [pc, #112]	; 83c8 <_Z10dummy_dataPf+0x19c>
    8354:	e5832000 	str	r2, [r3]
/home/trefil/sem/sources/userspace/model_task/main.cpp:37
    data[18] = 19.4576;
    8358:	e51b3008 	ldr	r3, [fp, #-8]
    835c:	e2833048 	add	r3, r3, #72	; 0x48
    8360:	e59f2060 	ldr	r2, [pc, #96]	; 83c8 <_Z10dummy_dataPf+0x19c>
    8364:	e5832000 	str	r2, [r3]
/home/trefil/sem/sources/userspace/model_task/main.cpp:38
    data[19] = 19.9876;
    8368:	e51b3008 	ldr	r3, [fp, #-8]
    836c:	e283304c 	add	r3, r3, #76	; 0x4c
    8370:	e59f2054 	ldr	r2, [pc, #84]	; 83cc <_Z10dummy_dataPf+0x1a0>
    8374:	e5832000 	str	r2, [r3]
/home/trefil/sem/sources/userspace/model_task/main.cpp:41


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
/home/trefil/sem/sources/userspace/model_task/main.cpp:43
//vypis na uart uvodni srandicky
void hello_uart_world(Buffer* bfr){
    83d0:	e92d4800 	push	{fp, lr}
    83d4:	e28db004 	add	fp, sp, #4
    83d8:	e24dd008 	sub	sp, sp, #8
    83dc:	e50b0008 	str	r0, [fp, #-8]
/home/trefil/sem/sources/userspace/model_task/main.cpp:44
    bfr->Write_Line("CalcOS v1.1\n");
    83e0:	e59f104c 	ldr	r1, [pc, #76]	; 8434 <_Z16hello_uart_worldP6Buffer+0x64>
    83e4:	e51b0008 	ldr	r0, [fp, #-8]
    83e8:	eb0007a0 	bl	a270 <_ZN6Buffer10Write_LineEPKc>
/home/trefil/sem/sources/userspace/model_task/main.cpp:45
    bfr->Write_Line("Autor: Jiri Trefil (A22N0060P)\n");
    83ec:	e59f1044 	ldr	r1, [pc, #68]	; 8438 <_Z16hello_uart_worldP6Buffer+0x68>
    83f0:	e51b0008 	ldr	r0, [fp, #-8]
    83f4:	eb00079d 	bl	a270 <_ZN6Buffer10Write_LineEPKc>
/home/trefil/sem/sources/userspace/model_task/main.cpp:46
    bfr->Write_Line("Zadejte nejprve casovy rozestup a predikcni okenko v minutach\n");
    83f8:	e59f103c 	ldr	r1, [pc, #60]	; 843c <_Z16hello_uart_worldP6Buffer+0x6c>
    83fc:	e51b0008 	ldr	r0, [fp, #-8]
    8400:	eb00079a 	bl	a270 <_ZN6Buffer10Write_LineEPKc>
/home/trefil/sem/sources/userspace/model_task/main.cpp:47
    bfr->Write_Line("Dale podporovany prikazy: stop, parameters\n");
    8404:	e59f1034 	ldr	r1, [pc, #52]	; 8440 <_Z16hello_uart_worldP6Buffer+0x70>
    8408:	e51b0008 	ldr	r0, [fp, #-8]
    840c:	eb000797 	bl	a270 <_ZN6Buffer10Write_LineEPKc>
/home/trefil/sem/sources/userspace/model_task/main.cpp:48
    bfr->Write_Line("stop - zastavi fitting modelu\n");
    8410:	e59f102c 	ldr	r1, [pc, #44]	; 8444 <_Z16hello_uart_worldP6Buffer+0x74>
    8414:	e51b0008 	ldr	r0, [fp, #-8]
    8418:	eb000794 	bl	a270 <_ZN6Buffer10Write_LineEPKc>
/home/trefil/sem/sources/userspace/model_task/main.cpp:49
    bfr->Write_Line("parameters - vypise parametry modelu\n");
    841c:	e59f1024 	ldr	r1, [pc, #36]	; 8448 <_Z16hello_uart_worldP6Buffer+0x78>
    8420:	e51b0008 	ldr	r0, [fp, #-8]
    8424:	eb000791 	bl	a270 <_ZN6Buffer10Write_LineEPKc>
/home/trefil/sem/sources/userspace/model_task/main.cpp:50
}
    8428:	e320f000 	nop	{0}
    842c:	e24bd004 	sub	sp, fp, #4
    8430:	e8bd8800 	pop	{fp, pc}
    8434:	0000c050 	andeq	ip, r0, r0, asr r0
    8438:	0000c060 	andeq	ip, r0, r0, rrx
    843c:	0000c080 	andeq	ip, r0, r0, lsl #1
    8440:	0000c0c0 	andeq	ip, r0, r0, asr #1
    8444:	0000c0ec 	andeq	ip, r0, ip, ror #1
    8448:	0000c10c 	andeq	ip, r0, ip, lsl #2

0000844c <main>:
main():
/home/trefil/sem/sources/userspace/model_task/main.cpp:53


int main(){
    844c:	e92d4810 	push	{r4, fp, lr}
    8450:	e28db008 	add	fp, sp, #8
    8454:	e24dd0dc 	sub	sp, sp, #220	; 0xdc
/home/trefil/sem/sources/userspace/model_task/main.cpp:55
    //otevri uart na read/write
    uint32_t uart_file = open("DEV:uart/0", NFile_Open_Mode::Read_Write);
    8458:	e3a01002 	mov	r1, #2
    845c:	e59f0230 	ldr	r0, [pc, #560]	; 8694 <main+0x248>
    8460:	eb000853 	bl	a5b4 <_Z4openPKc15NFile_Open_Mode>
    8464:	e50b0010 	str	r0, [fp, #-16]
/home/trefil/sem/sources/userspace/model_task/main.cpp:65
    //"okenko" dat - sem strkame data od uzivatele a predavame je modelu
    //float* data;
    /*uint32_t address = reinterpret_cast<uint32_t>(malloc(4));
    char baff[20];
    itoa(address,baff,16);*/
    char* x = new char[4];//reinterpret_cast<char*>(address);
    8468:	e3a00004 	mov	r0, #4
    846c:	eb00009b 	bl	86e0 <_Znaj>
    8470:	e1a03000 	mov	r3, r0
    8474:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/userspace/model_task/main.cpp:68

    //pomocne stringy pro strcat funkci, abych nejak rozumne odpovdel uzivateli, neni to uplne hezke
    char tmp1[] = "OK, predpoved ";
    8478:	e59f3218 	ldr	r3, [pc, #536]	; 8698 <main+0x24c>
    847c:	e24bc03c 	sub	ip, fp, #60	; 0x3c
    8480:	e893000f 	ldm	r3, {r0, r1, r2, r3}
    8484:	e8ac0007 	stmia	ip!, {r0, r1, r2}
    8488:	e1cc30b0 	strh	r3, [ip]
    848c:	e28cc002 	add	ip, ip, #2
    8490:	e1a03823 	lsr	r3, r3, #16
    8494:	e5cc3000 	strb	r3, [ip]
/home/trefil/sem/sources/userspace/model_task/main.cpp:69
    char tmp2[] = "OK, krokovani ";
    8498:	e59f31fc 	ldr	r3, [pc, #508]	; 869c <main+0x250>
    849c:	e24bc04c 	sub	ip, fp, #76	; 0x4c
    84a0:	e893000f 	ldm	r3, {r0, r1, r2, r3}
    84a4:	e8ac0007 	stmia	ip!, {r0, r1, r2}
    84a8:	e1cc30b0 	strh	r3, [ip]
    84ac:	e28cc002 	add	ip, ip, #2
    84b0:	e1a03823 	lsr	r3, r3, #16
    84b4:	e5cc3000 	strb	r3, [ip]
/home/trefil/sem/sources/userspace/model_task/main.cpp:70
    char tmp3[] = " minut\n";
    84b8:	e59f21e0 	ldr	r2, [pc, #480]	; 86a0 <main+0x254>
    84bc:	e24b3054 	sub	r3, fp, #84	; 0x54
    84c0:	e8920003 	ldm	r2, {r0, r1}
    84c4:	e8830003 	stm	r3, {r0, r1}
/home/trefil/sem/sources/userspace/model_task/main.cpp:73

    //buffer pro vyhazovani outputu uzivateli
    char tmp_str[128] = {0};
    84c8:	e3a03000 	mov	r3, #0
    84cc:	e50b30d4 	str	r3, [fp, #-212]	; 0xffffff2c
    84d0:	e24b30d0 	sub	r3, fp, #208	; 0xd0
    84d4:	e3a0207c 	mov	r2, #124	; 0x7c
    84d8:	e3a01000 	mov	r1, #0
    84dc:	e1a00003 	mov	r0, r3
    84e0:	eb000e86 	bl	bf00 <memset>
/home/trefil/sem/sources/userspace/model_task/main.cpp:76


    bfr = new Buffer(uart_file);
    84e4:	e3a00f43 	mov	r0, #268	; 0x10c
    84e8:	eb000070 	bl	86b0 <_Znwj>
    84ec:	e1a03000 	mov	r3, r0
    84f0:	e1a04003 	mov	r4, r3
    84f4:	e51b1010 	ldr	r1, [fp, #-16]
    84f8:	e1a00004 	mov	r0, r4
    84fc:	eb000707 	bl	a120 <_ZN6BufferC1Ej>
    8500:	e50b4018 	str	r4, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/userspace/model_task/main.cpp:78

    bfr->Write_Line(x);
    8504:	e51b1014 	ldr	r1, [fp, #-20]	; 0xffffffec
    8508:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    850c:	eb000757 	bl	a270 <_ZN6Buffer10Write_LineEPKc>
/home/trefil/sem/sources/userspace/model_task/main.cpp:80

    bfr->Write_Line("\n");
    8510:	e59f118c 	ldr	r1, [pc, #396]	; 86a4 <main+0x258>
    8514:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    8518:	eb000754 	bl	a270 <_ZN6Buffer10Write_LineEPKc>
/home/trefil/sem/sources/userspace/model_task/main.cpp:82
    //vypis uzivateli uvodni povidani
    hello_uart_world(bfr);
    851c:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    8520:	ebffffaa 	bl	83d0 <_Z16hello_uart_worldP6Buffer>
/home/trefil/sem/sources/userspace/model_task/main.cpp:84
    //zablokuj se dokud neprectes int
    bfr->Write_Line(">");
    8524:	e59f117c 	ldr	r1, [pc, #380]	; 86a8 <main+0x25c>
    8528:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    852c:	eb00074f 	bl	a270 <_ZN6Buffer10Write_LineEPKc>
/home/trefil/sem/sources/userspace/model_task/main.cpp:85
    char* t_delta = bfr->Read_Uart_Line_Blocking(INT_INPUT);
    8530:	e3a01001 	mov	r1, #1
    8534:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    8538:	eb0007e1 	bl	a4c4 <_ZN6Buffer23Read_Uart_Line_BlockingEi>
    853c:	e50b001c 	str	r0, [fp, #-28]	; 0xffffffe4
/home/trefil/sem/sources/userspace/model_task/main.cpp:86
    strncat(tmp_str,tmp1,128);
    8540:	e24b103c 	sub	r1, fp, #60	; 0x3c
    8544:	e24b30d4 	sub	r3, fp, #212	; 0xd4
    8548:	e3a02080 	mov	r2, #128	; 0x80
    854c:	e1a00003 	mov	r0, r3
    8550:	eb000ad5 	bl	b0ac <_Z7strncatPcPKci>
/home/trefil/sem/sources/userspace/model_task/main.cpp:87
    strncat(tmp_str,t_delta,128);
    8554:	e24b30d4 	sub	r3, fp, #212	; 0xd4
    8558:	e3a02080 	mov	r2, #128	; 0x80
    855c:	e51b101c 	ldr	r1, [fp, #-28]	; 0xffffffe4
    8560:	e1a00003 	mov	r0, r3
    8564:	eb000ad0 	bl	b0ac <_Z7strncatPcPKci>
/home/trefil/sem/sources/userspace/model_task/main.cpp:88
    strncat(tmp_str,tmp3,128);
    8568:	e24b1054 	sub	r1, fp, #84	; 0x54
    856c:	e24b30d4 	sub	r3, fp, #212	; 0xd4
    8570:	e3a02080 	mov	r2, #128	; 0x80
    8574:	e1a00003 	mov	r0, r3
    8578:	eb000acb 	bl	b0ac <_Z7strncatPcPKci>
/home/trefil/sem/sources/userspace/model_task/main.cpp:89
    bfr->Write_Line(tmp_str);
    857c:	e24b30d4 	sub	r3, fp, #212	; 0xd4
    8580:	e1a01003 	mov	r1, r3
    8584:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    8588:	eb000738 	bl	a270 <_ZN6Buffer10Write_LineEPKc>
/home/trefil/sem/sources/userspace/model_task/main.cpp:90
    tmp_str[0] = '\0';
    858c:	e3a03000 	mov	r3, #0
    8590:	e54b30d4 	strb	r3, [fp, #-212]	; 0xffffff2c
/home/trefil/sem/sources/userspace/model_task/main.cpp:93

    //zablokuj se dokud neprectes int
    bfr->Write_Line(">");
    8594:	e59f110c 	ldr	r1, [pc, #268]	; 86a8 <main+0x25c>
    8598:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    859c:	eb000733 	bl	a270 <_ZN6Buffer10Write_LineEPKc>
/home/trefil/sem/sources/userspace/model_task/main.cpp:94
    char* t_pred = bfr->Read_Uart_Line_Blocking(INT_INPUT);
    85a0:	e3a01001 	mov	r1, #1
    85a4:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    85a8:	eb0007c5 	bl	a4c4 <_ZN6Buffer23Read_Uart_Line_BlockingEi>
    85ac:	e50b0020 	str	r0, [fp, #-32]	; 0xffffffe0
/home/trefil/sem/sources/userspace/model_task/main.cpp:96

    strncat(tmp_str, tmp2,128);
    85b0:	e24b104c 	sub	r1, fp, #76	; 0x4c
    85b4:	e24b30d4 	sub	r3, fp, #212	; 0xd4
    85b8:	e3a02080 	mov	r2, #128	; 0x80
    85bc:	e1a00003 	mov	r0, r3
    85c0:	eb000ab9 	bl	b0ac <_Z7strncatPcPKci>
/home/trefil/sem/sources/userspace/model_task/main.cpp:97
    strncat(tmp_str,t_pred,128);
    85c4:	e24b30d4 	sub	r3, fp, #212	; 0xd4
    85c8:	e3a02080 	mov	r2, #128	; 0x80
    85cc:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    85d0:	e1a00003 	mov	r0, r3
    85d4:	eb000ab4 	bl	b0ac <_Z7strncatPcPKci>
/home/trefil/sem/sources/userspace/model_task/main.cpp:98
    strncat(tmp_str, tmp3,128);
    85d8:	e24b1054 	sub	r1, fp, #84	; 0x54
    85dc:	e24b30d4 	sub	r3, fp, #212	; 0xd4
    85e0:	e3a02080 	mov	r2, #128	; 0x80
    85e4:	e1a00003 	mov	r0, r3
    85e8:	eb000aaf 	bl	b0ac <_Z7strncatPcPKci>
/home/trefil/sem/sources/userspace/model_task/main.cpp:99
    bfr->Write_Line(tmp_str);
    85ec:	e24b30d4 	sub	r3, fp, #212	; 0xd4
    85f0:	e1a01003 	mov	r1, r3
    85f4:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    85f8:	eb00071c 	bl	a270 <_ZN6Buffer10Write_LineEPKc>
/home/trefil/sem/sources/userspace/model_task/main.cpp:100
    tmp_str[0] = '\0';
    85fc:	e3a03000 	mov	r3, #0
    8600:	e54b30d4 	strb	r3, [fp, #-212]	; 0xffffff2c
/home/trefil/sem/sources/userspace/model_task/main.cpp:104


    //vyparsuj hodnoty od uzivatele na inty
    const int T_PRED_NUM = atoi(t_delta);
    8604:	e51b001c 	ldr	r0, [fp, #-28]	; 0xffffffe4
    8608:	eb000942 	bl	ab18 <_Z4atoiPKc>
    860c:	e50b0024 	str	r0, [fp, #-36]	; 0xffffffdc
/home/trefil/sem/sources/userspace/model_task/main.cpp:105
    const int T_DELTA_NUM = atoi(t_pred);
    8610:	e51b0020 	ldr	r0, [fp, #-32]	; 0xffffffe0
    8614:	eb00093f 	bl	ab18 <_Z4atoiPKc>
    8618:	e50b0028 	str	r0, [fp, #-40]	; 0xffffffd8
/home/trefil/sem/sources/userspace/model_task/main.cpp:108

    //trida ktera v podstate obaluje hlavni vypocet a interakci s uzivatelem
    m = new Model(T_PRED_NUM,T_DELTA_NUM,POPULATION_COUNT,EPOCH_COUNT,DATA_WINDOW_SIZE,bfr);
    861c:	e3a0003c 	mov	r0, #60	; 0x3c
    8620:	eb000022 	bl	86b0 <_Znwj>
    8624:	e1a03000 	mov	r3, r0
    8628:	e1a04003 	mov	r4, r3
    862c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8630:	e58d3008 	str	r3, [sp, #8]
    8634:	e3a03014 	mov	r3, #20
    8638:	e58d3004 	str	r3, [sp, #4]
    863c:	e3a03032 	mov	r3, #50	; 0x32
    8640:	e58d3000 	str	r3, [sp]
    8644:	e3a03ffa 	mov	r3, #1000	; 0x3e8
    8648:	e51b2028 	ldr	r2, [fp, #-40]	; 0xffffffd8
    864c:	e51b1024 	ldr	r1, [fp, #-36]	; 0xffffffdc
    8650:	e1a00004 	mov	r0, r4
    8654:	eb00002d 	bl	8710 <_ZN5ModelC1EiiiiiP6Buffer>
    8658:	e50b402c 	str	r4, [fp, #-44]	; 0xffffffd4
/home/trefil/sem/sources/userspace/model_task/main.cpp:110

    m->Set_Buffer(bfr);
    865c:	e51b1018 	ldr	r1, [fp, #-24]	; 0xffffffe8
    8660:	e51b002c 	ldr	r0, [fp, #-44]	; 0xffffffd4
    8664:	eb0002c8 	bl	918c <_ZN5Model10Set_BufferEP6Buffer>
/home/trefil/sem/sources/userspace/model_task/main.cpp:121
        bfr->Write_Line(tmp_str);
        bfr->Write_Line("\n");
    }
        */
//hlavni smycka programu
    m->Run();
    8668:	e51b002c 	ldr	r0, [fp, #-44]	; 0xffffffd4
    866c:	eb00047d 	bl	9868 <_ZN5Model3RunEv>
/home/trefil/sem/sources/userspace/model_task/main.cpp:124

    //sem bych nikdy nemel spadnout
    bfr->Write_Line("Single task konec, cauky mnauky\n");
    8670:	e59f1034 	ldr	r1, [pc, #52]	; 86ac <main+0x260>
    8674:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    8678:	eb0006fc 	bl	a270 <_ZN6Buffer10Write_LineEPKc>
/home/trefil/sem/sources/userspace/model_task/main.cpp:125
    close(uart_file);
    867c:	e51b0010 	ldr	r0, [fp, #-16]
    8680:	eb000804 	bl	a698 <_Z5closej>
/home/trefil/sem/sources/userspace/model_task/main.cpp:130

    /**
     * todo free pameti neumim
     */
    return 0;
    8684:	e3a03000 	mov	r3, #0
/home/trefil/sem/sources/userspace/model_task/main.cpp:132

}
    8688:	e1a00003 	mov	r0, r3
    868c:	e24bd008 	sub	sp, fp, #8
    8690:	e8bd8810 	pop	{r4, fp, pc}
    8694:	0000c134 	andeq	ip, r0, r4, lsr r1
    8698:	0000c16c 	andeq	ip, r0, ip, ror #2
    869c:	0000c17c 	andeq	ip, r0, ip, ror r1
    86a0:	0000c18c 	andeq	ip, r0, ip, lsl #3
    86a4:	0000c140 	andeq	ip, r0, r0, asr #2
    86a8:	0000c144 	andeq	ip, r0, r4, asr #2
    86ac:	0000c148 	andeq	ip, r0, r8, asr #2

000086b0 <_Znwj>:
_Znwj():
/home/trefil/sem/sources/userspace/../stdlib/include/memory.h:5
#pragma once
#include <hal/intdef.h>
#include <Heap_Manager.h>

inline void* operator new(uint32_t size){
    86b0:	e92d4800 	push	{fp, lr}
    86b4:	e28db004 	add	fp, sp, #4
    86b8:	e24dd008 	sub	sp, sp, #8
    86bc:	e50b0008 	str	r0, [fp, #-8]
/home/trefil/sem/sources/userspace/../stdlib/include/memory.h:6
    return h.Alloc(size);
    86c0:	e51b1008 	ldr	r1, [fp, #-8]
    86c4:	e59f0010 	ldr	r0, [pc, #16]	; 86dc <_Znwj+0x2c>
    86c8:	eb000604 	bl	9ee0 <_ZN12Heap_Manager5AllocEj>
    86cc:	e1a03000 	mov	r3, r0
/home/trefil/sem/sources/userspace/../stdlib/include/memory.h:7
}
    86d0:	e1a00003 	mov	r0, r3
    86d4:	e24bd004 	sub	sp, fp, #4
    86d8:	e8bd8800 	pop	{fp, pc}
    86dc:	0000c324 	andeq	ip, r0, r4, lsr #6

000086e0 <_Znaj>:
_Znaj():
/home/trefil/sem/sources/userspace/../stdlib/include/memory.h:14
inline void *operator new(uint32_t, void *p)
{
    return p;
}
inline void *operator new[](uint32_t size)
{
    86e0:	e92d4800 	push	{fp, lr}
    86e4:	e28db004 	add	fp, sp, #4
    86e8:	e24dd008 	sub	sp, sp, #8
    86ec:	e50b0008 	str	r0, [fp, #-8]
/home/trefil/sem/sources/userspace/../stdlib/include/memory.h:15
    return h.Alloc(size);
    86f0:	e51b1008 	ldr	r1, [fp, #-8]
    86f4:	e59f0010 	ldr	r0, [pc, #16]	; 870c <_Znaj+0x2c>
    86f8:	eb0005f8 	bl	9ee0 <_ZN12Heap_Manager5AllocEj>
    86fc:	e1a03000 	mov	r3, r0
/home/trefil/sem/sources/userspace/../stdlib/include/memory.h:16
}
    8700:	e1a00003 	mov	r0, r3
    8704:	e24bd004 	sub	sp, fp, #4
    8708:	e8bd8800 	pop	{fp, pc}
    870c:	0000c324 	andeq	ip, r0, r4, lsr #6

00008710 <_ZN5ModelC1EiiiiiP6Buffer>:
_ZN5ModelC2EiiiiiP6Buffer():
/home/trefil/sem/sources/userspace/Model/Model.cpp:3
#include <Model.h>

Model::Model(int t_delta, int t_pred,int population_count, int epoch_count, int window_size,Buffer* bfr):
    8710:	e92d4800 	push	{fp, lr}
    8714:	e28db004 	add	fp, sp, #4
    8718:	e24dd010 	sub	sp, sp, #16
    871c:	e50b0008 	str	r0, [fp, #-8]
    8720:	e50b100c 	str	r1, [fp, #-12]
    8724:	e50b2010 	str	r2, [fp, #-16]
    8728:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/userspace/Model/Model.cpp:9
t_delta(t_delta),
t_pred(t_pred),
population_count(population_count),
epoch_count(epoch_count),
window_size(window_size),
bfr(bfr)
    872c:	e51b3008 	ldr	r3, [fp, #-8]
    8730:	e51b200c 	ldr	r2, [fp, #-12]
    8734:	e5832000 	str	r2, [r3]
    8738:	e51b3008 	ldr	r3, [fp, #-8]
    873c:	e51b2010 	ldr	r2, [fp, #-16]
    8740:	e5832004 	str	r2, [r3, #4]
    8744:	e51b3008 	ldr	r3, [fp, #-8]
    8748:	e3e02004 	mvn	r2, #4
    874c:	e5832008 	str	r2, [r3, #8]
    8750:	e51b3008 	ldr	r3, [fp, #-8]
    8754:	e3a02005 	mov	r2, #5
    8758:	e583200c 	str	r2, [r3, #12]
    875c:	e51b3008 	ldr	r3, [fp, #-8]
    8760:	e59b2008 	ldr	r2, [fp, #8]
    8764:	e5832010 	str	r2, [r3, #16]
    8768:	e51b3008 	ldr	r3, [fp, #-8]
    876c:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    8770:	e5832014 	str	r2, [r3, #20]
    8774:	e51b3008 	ldr	r3, [fp, #-8]
    8778:	e3a02000 	mov	r2, #0
    877c:	e5c32018 	strb	r2, [r3, #24]
    8780:	e51b3008 	ldr	r3, [fp, #-8]
    8784:	e59b2004 	ldr	r2, [fp, #4]
    8788:	e5832020 	str	r2, [r3, #32]
    878c:	e51b3008 	ldr	r3, [fp, #-8]
    8790:	e3a02000 	mov	r2, #0
    8794:	e5832024 	str	r2, [r3, #36]	; 0x24
    8798:	e51b3008 	ldr	r3, [fp, #-8]
    879c:	e3a02000 	mov	r2, #0
    87a0:	e5832028 	str	r2, [r3, #40]	; 0x28
    87a4:	e51b3008 	ldr	r3, [fp, #-8]
    87a8:	e3a02000 	mov	r2, #0
    87ac:	e583202c 	str	r2, [r3, #44]	; 0x2c
    87b0:	e51b3008 	ldr	r3, [fp, #-8]
    87b4:	e59b200c 	ldr	r2, [fp, #12]
    87b8:	e5832030 	str	r2, [r3, #48]	; 0x30
    87bc:	e51b3008 	ldr	r3, [fp, #-8]
    87c0:	e59f2030 	ldr	r2, [pc, #48]	; 87f8 <_ZN5ModelC1EiiiiiP6Buffer+0xe8>
    87c4:	e5832034 	str	r2, [r3, #52]	; 0x34
    87c8:	e51b3008 	ldr	r3, [fp, #-8]
    87cc:	e3a02000 	mov	r2, #0
    87d0:	e5832038 	str	r2, [r3, #56]	; 0x38
/home/trefil/sem/sources/userspace/Model/Model.cpp:12
{
    //alokuj pamet na halde po struktury, ktere potrebuji
    Init();
    87d4:	e51b0008 	ldr	r0, [fp, #-8]
    87d8:	eb0001a1 	bl	8e64 <_ZN5Model4InitEv>
/home/trefil/sem/sources/userspace/Model/Model.cpp:13
    data_pointer = 0;
    87dc:	e51b3008 	ldr	r3, [fp, #-8]
    87e0:	e3a02000 	mov	r2, #0
    87e4:	e583201c 	str	r2, [r3, #28]
/home/trefil/sem/sources/userspace/Model/Model.cpp:14
};
    87e8:	e51b3008 	ldr	r3, [fp, #-8]
    87ec:	e1a00003 	mov	r0, r3
    87f0:	e24bd004 	sub	sp, fp, #4
    87f4:	e8bd8800 	pop	{fp, pc}
    87f8:	3e4ccccd 	cdpcc	12, 4, cr12, cr12, cr13, {6}

000087fc <_ZN5Model6Calc_BEfff>:
_ZN5Model6Calc_BEfff():
/home/trefil/sem/sources/userspace/Model/Model.cpp:16

float Model::Calc_B(float D, float E, float y){
    87fc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8800:	e28db000 	add	fp, sp, #0
    8804:	e24dd014 	sub	sp, sp, #20
    8808:	e50b0008 	str	r0, [fp, #-8]
    880c:	ed0b0a03 	vstr	s0, [fp, #-12]
    8810:	ed4b0a04 	vstr	s1, [fp, #-16]
    8814:	ed0b1a05 	vstr	s2, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/userspace/Model/Model.cpp:17
    return ((D / E) * derivative_value) + ((1.0/E) * y);
    8818:	ed5b6a03 	vldr	s13, [fp, #-12]
    881c:	ed1b7a04 	vldr	s14, [fp, #-16]
    8820:	eec67a87 	vdiv.f32	s15, s13, s14
    8824:	ed9f7a11 	vldr	s14, [pc, #68]	; 8870 <_ZN5Model6Calc_BEfff+0x74>
    8828:	ee677a87 	vmul.f32	s15, s15, s14
    882c:	eeb76ae7 	vcvt.f64.f32	d6, s15
    8830:	ed5b7a04 	vldr	s15, [fp, #-16]
    8834:	eeb77ae7 	vcvt.f64.f32	d7, s15
    8838:	ed9f4b0a 	vldr	d4, [pc, #40]	; 8868 <_ZN5Model6Calc_BEfff+0x6c>
    883c:	ee845b07 	vdiv.f64	d5, d4, d7
    8840:	ed5b7a05 	vldr	s15, [fp, #-20]	; 0xffffffec
    8844:	eeb77ae7 	vcvt.f64.f32	d7, s15
    8848:	ee257b07 	vmul.f64	d7, d5, d7
    884c:	ee367b07 	vadd.f64	d7, d6, d7
    8850:	eef77bc7 	vcvt.f32.f64	s15, d7
/home/trefil/sem/sources/userspace/Model/Model.cpp:18
}
    8854:	eeb00a67 	vmov.f32	s0, s15
    8858:	e28bd000 	add	sp, fp, #0
    885c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8860:	e12fff1e 	bx	lr
    8864:	e320f000 	nop	{0}
    8868:	00000000 	andeq	r0, r0, r0
    886c:	3ff00000 	svccc	0x00f00000	; IMB
    8870:	37422e45 	strbcc	r2, [r2, -r5, asr #28]

00008874 <_ZN5Model20Calculate_PredictionEPff>:
_ZN5Model20Calculate_PredictionEPff():
/home/trefil/sem/sources/userspace/Model/Model.cpp:23


//parameters - parametry clena populace, y - hodnota v case t
//vysledek je hodnota v case t+t_pred
float Model::Calculate_Prediction(float* parameters, float y){
    8874:	e92d4800 	push	{fp, lr}
    8878:	e28db004 	add	fp, sp, #4
    887c:	e24dd030 	sub	sp, sp, #48	; 0x30
    8880:	e50b0028 	str	r0, [fp, #-40]	; 0xffffffd8
    8884:	e50b102c 	str	r1, [fp, #-44]	; 0xffffffd4
    8888:	ed0b0a0c 	vstr	s0, [fp, #-48]	; 0xffffffd0
/home/trefil/sem/sources/userspace/Model/Model.cpp:24
    float A = parameters[0];
    888c:	e51b302c 	ldr	r3, [fp, #-44]	; 0xffffffd4
    8890:	e5933000 	ldr	r3, [r3]
    8894:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/userspace/Model/Model.cpp:25
    float B = parameters[1];
    8898:	e51b302c 	ldr	r3, [fp, #-44]	; 0xffffffd4
    889c:	e5933004 	ldr	r3, [r3, #4]
    88a0:	e50b300c 	str	r3, [fp, #-12]
/home/trefil/sem/sources/userspace/Model/Model.cpp:26
    float C = parameters[2];
    88a4:	e51b302c 	ldr	r3, [fp, #-44]	; 0xffffffd4
    88a8:	e5933008 	ldr	r3, [r3, #8]
    88ac:	e50b3010 	str	r3, [fp, #-16]
/home/trefil/sem/sources/userspace/Model/Model.cpp:27
    float D = parameters[3];
    88b0:	e51b302c 	ldr	r3, [fp, #-44]	; 0xffffffd4
    88b4:	e593300c 	ldr	r3, [r3, #12]
    88b8:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/userspace/Model/Model.cpp:28
    float E = parameters[4];
    88bc:	e51b302c 	ldr	r3, [fp, #-44]	; 0xffffffd4
    88c0:	e5933010 	ldr	r3, [r3, #16]
    88c4:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/userspace/Model/Model.cpp:30

    float b_t = Calc_B(D,E,y);
    88c8:	ed1b1a0c 	vldr	s2, [fp, #-48]	; 0xffffffd0
    88cc:	ed5b0a06 	vldr	s1, [fp, #-24]	; 0xffffffe8
    88d0:	ed1b0a05 	vldr	s0, [fp, #-20]	; 0xffffffec
    88d4:	e51b0028 	ldr	r0, [fp, #-40]	; 0xffffffd8
    88d8:	ebffffc7 	bl	87fc <_ZN5Model6Calc_BEfff>
    88dc:	ed0b0a07 	vstr	s0, [fp, #-28]	; 0xffffffe4
/home/trefil/sem/sources/userspace/Model/Model.cpp:31
    float y_predicted = (A * b_t) + ((B * b_t) * (b_t - y)) + C;
    88e0:	ed1b7a02 	vldr	s14, [fp, #-8]
    88e4:	ed5b7a07 	vldr	s15, [fp, #-28]	; 0xffffffe4
    88e8:	ee277a27 	vmul.f32	s14, s14, s15
    88ec:	ed5b6a03 	vldr	s13, [fp, #-12]
    88f0:	ed5b7a07 	vldr	s15, [fp, #-28]	; 0xffffffe4
    88f4:	ee666aa7 	vmul.f32	s13, s13, s15
    88f8:	ed1b6a07 	vldr	s12, [fp, #-28]	; 0xffffffe4
    88fc:	ed5b7a0c 	vldr	s15, [fp, #-48]	; 0xffffffd0
    8900:	ee767a67 	vsub.f32	s15, s12, s15
    8904:	ee667aa7 	vmul.f32	s15, s13, s15
    8908:	ee777a27 	vadd.f32	s15, s14, s15
    890c:	ed1b7a04 	vldr	s14, [fp, #-16]
    8910:	ee777a27 	vadd.f32	s15, s14, s15
    8914:	ed4b7a08 	vstr	s15, [fp, #-32]	; 0xffffffe0
/home/trefil/sem/sources/userspace/Model/Model.cpp:32
    return y_predicted;
    8918:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    891c:	ee073a90 	vmov	s15, r3
/home/trefil/sem/sources/userspace/Model/Model.cpp:33
}
    8920:	eeb00a67 	vmov.f32	s0, s15
    8924:	e24bd004 	sub	sp, fp, #4
    8928:	e8bd8800 	pop	{fp, pc}

0000892c <_ZN5Model7PredictEP9Tribesman>:
_ZN5Model7PredictEP9Tribesman():
/home/trefil/sem/sources/userspace/Model/Model.cpp:37


//predikce od borce
void Model::Predict(Tribesman* tribesman){
    892c:	e92d4800 	push	{fp, lr}
    8930:	e28db004 	add	fp, sp, #4
    8934:	e24dd010 	sub	sp, sp, #16
    8938:	e50b0010 	str	r0, [fp, #-16]
    893c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/userspace/Model/Model.cpp:40
    //pro vsechna data, ktera mam udelej predikci
    //tedy pro vsechna y(t) vypocti y(t+t_pred)
    for(int i = 0; i < data_pointer; i++){
    8940:	e3a03000 	mov	r3, #0
    8944:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/userspace/Model/Model.cpp:40 (discriminator 3)
    8948:	e51b3010 	ldr	r3, [fp, #-16]
    894c:	e593301c 	ldr	r3, [r3, #28]
    8950:	e51b2008 	ldr	r2, [fp, #-8]
    8954:	e1520003 	cmp	r2, r3
    8958:	aa000015 	bge	89b4 <_ZN5Model7PredictEP9Tribesman+0x88>
/home/trefil/sem/sources/userspace/Model/Model.cpp:41 (discriminator 2)
        float prediction = Calculate_Prediction(tribesman->parameters,this->data[i]);
    895c:	e51b1014 	ldr	r1, [fp, #-20]	; 0xffffffec
    8960:	e51b3010 	ldr	r3, [fp, #-16]
    8964:	e5932038 	ldr	r2, [r3, #56]	; 0x38
    8968:	e51b3008 	ldr	r3, [fp, #-8]
    896c:	e1a03103 	lsl	r3, r3, #2
    8970:	e0823003 	add	r3, r2, r3
    8974:	edd37a00 	vldr	s15, [r3]
    8978:	eeb00a67 	vmov.f32	s0, s15
    897c:	e51b0010 	ldr	r0, [fp, #-16]
    8980:	ebffffbb 	bl	8874 <_ZN5Model20Calculate_PredictionEPff>
    8984:	ed0b0a03 	vstr	s0, [fp, #-12]
/home/trefil/sem/sources/userspace/Model/Model.cpp:42 (discriminator 2)
        tribesman->predicted_values[i] = prediction;
    8988:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    898c:	e5932018 	ldr	r2, [r3, #24]
    8990:	e51b3008 	ldr	r3, [fp, #-8]
    8994:	e1a03103 	lsl	r3, r3, #2
    8998:	e0823003 	add	r3, r2, r3
    899c:	e51b200c 	ldr	r2, [fp, #-12]
    89a0:	e5832000 	str	r2, [r3]
/home/trefil/sem/sources/userspace/Model/Model.cpp:40 (discriminator 2)
    for(int i = 0; i < data_pointer; i++){
    89a4:	e51b3008 	ldr	r3, [fp, #-8]
    89a8:	e2833001 	add	r3, r3, #1
    89ac:	e50b3008 	str	r3, [fp, #-8]
    89b0:	eaffffe4 	b	8948 <_ZN5Model7PredictEP9Tribesman+0x1c>
/home/trefil/sem/sources/userspace/Model/Model.cpp:44
    }
}
    89b4:	e320f000 	nop	{0}
    89b8:	e24bd004 	sub	sp, fp, #4
    89bc:	e8bd8800 	pop	{fp, pc}

000089c0 <_ZN5Model17Calculate_FitnessEP9Tribesman>:
_ZN5Model17Calculate_FitnessEP9Tribesman():
/home/trefil/sem/sources/userspace/Model/Model.cpp:48
//vypocitnej fitness clena populace
//cim vyssi fitness, tim hur na tom
//fitness funkce je prumerna vzdalenost predikce od spravne hodnoty
float Model::Calculate_Fitness(Tribesman* tribesman){
    89c0:	e92d4800 	push	{fp, lr}
    89c4:	e28db004 	add	fp, sp, #4
    89c8:	e24dd028 	sub	sp, sp, #40	; 0x28
    89cc:	e50b0028 	str	r0, [fp, #-40]	; 0xffffffd8
    89d0:	e50b102c 	str	r1, [fp, #-44]	; 0xffffffd4
/home/trefil/sem/sources/userspace/Model/Model.cpp:50
    //predikovana hodnota na indexu i ve skutecnych datech lezi na indexu i + time_shift
    int time_shift = t_pred / t_delta;
    89d4:	e51b3028 	ldr	r3, [fp, #-40]	; 0xffffffd8
    89d8:	e5932004 	ldr	r2, [r3, #4]
    89dc:	e51b3028 	ldr	r3, [fp, #-40]	; 0xffffffd8
    89e0:	e5933000 	ldr	r3, [r3]
    89e4:	e1a01003 	mov	r1, r3
    89e8:	e1a00002 	mov	r0, r2
    89ec:	eb000b85 	bl	b808 <__divsi3>
    89f0:	e1a03000 	mov	r3, r0
    89f4:	e50b3010 	str	r3, [fp, #-16]
/home/trefil/sem/sources/userspace/Model/Model.cpp:51
    float fitness = 0;
    89f8:	e3a03000 	mov	r3, #0
    89fc:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/userspace/Model/Model.cpp:52
    float diff = 0;
    8a00:	e3a03000 	mov	r3, #0
    8a04:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/userspace/Model/Model.cpp:55
    int i;

    for(i = 0; i < window_size; i++){
    8a08:	e3a03000 	mov	r3, #0
    8a0c:	e50b300c 	str	r3, [fp, #-12]
/home/trefil/sem/sources/userspace/Model/Model.cpp:55 (discriminator 1)
    8a10:	e51b3028 	ldr	r3, [fp, #-40]	; 0xffffffd8
    8a14:	e5933010 	ldr	r3, [r3, #16]
    8a18:	e51b200c 	ldr	r2, [fp, #-12]
    8a1c:	e1520003 	cmp	r2, r3
    8a20:	aa000028 	bge	8ac8 <_ZN5Model17Calculate_FitnessEP9Tribesman+0x108>
/home/trefil/sem/sources/userspace/Model/Model.cpp:56
        float y_predicted = tribesman->predicted_values[i];
    8a24:	e51b302c 	ldr	r3, [fp, #-44]	; 0xffffffd4
    8a28:	e5932018 	ldr	r2, [r3, #24]
    8a2c:	e51b300c 	ldr	r3, [fp, #-12]
    8a30:	e1a03103 	lsl	r3, r3, #2
    8a34:	e0823003 	add	r3, r2, r3
    8a38:	e5933000 	ldr	r3, [r3]
    8a3c:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/userspace/Model/Model.cpp:57
        int index = i + time_shift;
    8a40:	e51b200c 	ldr	r2, [fp, #-12]
    8a44:	e51b3010 	ldr	r3, [fp, #-16]
    8a48:	e0823003 	add	r3, r2, r3
    8a4c:	e50b301c 	str	r3, [fp, #-28]	; 0xffffffe4
/home/trefil/sem/sources/userspace/Model/Model.cpp:60
        //data od tohoto bodu jeste nemame k dispozici -> nemuzeme je pouzit pro fitness funkci
        //nebo nemame nic napocitano
        if(index >= data_pointer)break;
    8a50:	e51b3028 	ldr	r3, [fp, #-40]	; 0xffffffd8
    8a54:	e593301c 	ldr	r3, [r3, #28]
    8a58:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8a5c:	e1520003 	cmp	r2, r3
    8a60:	aa000017 	bge	8ac4 <_ZN5Model17Calculate_FitnessEP9Tribesman+0x104>
/home/trefil/sem/sources/userspace/Model/Model.cpp:61 (discriminator 2)
        float y = this->data[index];
    8a64:	e51b3028 	ldr	r3, [fp, #-40]	; 0xffffffd8
    8a68:	e5932038 	ldr	r2, [r3, #56]	; 0x38
    8a6c:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8a70:	e1a03103 	lsl	r3, r3, #2
    8a74:	e0823003 	add	r3, r2, r3
    8a78:	e5933000 	ldr	r3, [r3]
    8a7c:	e50b3020 	str	r3, [fp, #-32]	; 0xffffffe0
/home/trefil/sem/sources/userspace/Model/Model.cpp:64 (discriminator 2)
        //pricti rozdil ctvercu
        //diff += y_predicted - y;
        diff += (y_predicted*y_predicted) - 2 * (y_predicted*y) + (y*y);
    8a80:	ed5b7a06 	vldr	s15, [fp, #-24]	; 0xffffffe8
    8a84:	ee277aa7 	vmul.f32	s14, s15, s15
    8a88:	ed5b6a06 	vldr	s13, [fp, #-24]	; 0xffffffe8
    8a8c:	ed5b7a08 	vldr	s15, [fp, #-32]	; 0xffffffe0
    8a90:	ee667aa7 	vmul.f32	s15, s13, s15
    8a94:	ee777aa7 	vadd.f32	s15, s15, s15
    8a98:	ee377a67 	vsub.f32	s14, s14, s15
    8a9c:	ed5b7a08 	vldr	s15, [fp, #-32]	; 0xffffffe0
    8aa0:	ee677aa7 	vmul.f32	s15, s15, s15
    8aa4:	ee777a27 	vadd.f32	s15, s14, s15
    8aa8:	ed1b7a02 	vldr	s14, [fp, #-8]
    8aac:	ee777a27 	vadd.f32	s15, s14, s15
    8ab0:	ed4b7a02 	vstr	s15, [fp, #-8]
/home/trefil/sem/sources/userspace/Model/Model.cpp:55 (discriminator 2)
    for(i = 0; i < window_size; i++){
    8ab4:	e51b300c 	ldr	r3, [fp, #-12]
    8ab8:	e2833001 	add	r3, r3, #1
    8abc:	e50b300c 	str	r3, [fp, #-12]
    8ac0:	eaffffd2 	b	8a10 <_ZN5Model17Calculate_FitnessEP9Tribesman+0x50>
/home/trefil/sem/sources/userspace/Model/Model.cpp:60
        if(index >= data_pointer)break;
    8ac4:	e320f000 	nop	{0}
/home/trefil/sem/sources/userspace/Model/Model.cpp:67
    }
    //zajima nas absolutni chyba
    if(diff < 0)
    8ac8:	ed5b7a02 	vldr	s15, [fp, #-8]
    8acc:	eef57ac0 	vcmpe.f32	s15, #0.0
    8ad0:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    8ad4:	5a000002 	bpl	8ae4 <_ZN5Model17Calculate_FitnessEP9Tribesman+0x124>
/home/trefil/sem/sources/userspace/Model/Model.cpp:68
        diff = -diff;
    8ad8:	ed5b7a02 	vldr	s15, [fp, #-8]
    8adc:	eef17a67 	vneg.f32	s15, s15
    8ae0:	ed4b7a02 	vstr	s15, [fp, #-8]
/home/trefil/sem/sources/userspace/Model/Model.cpp:72
    //aritmeticky prumer
    //pokud jej mame z ceho vypocitat
    //pokud nemame, vrat empty -> nemam dost dat na to, abych vyhodnotil spravnost clena populace
    if(i == 0 ) return EMPTY;
    8ae4:	e51b300c 	ldr	r3, [fp, #-12]
    8ae8:	e3530000 	cmp	r3, #0
    8aec:	1a000001 	bne	8af8 <_ZN5Model17Calculate_FitnessEP9Tribesman+0x138>
/home/trefil/sem/sources/userspace/Model/Model.cpp:72 (discriminator 1)
    8af0:	e59f302c 	ldr	r3, [pc, #44]	; 8b24 <_ZN5Model17Calculate_FitnessEP9Tribesman+0x164>
    8af4:	ea000006 	b	8b14 <_ZN5Model17Calculate_FitnessEP9Tribesman+0x154>
/home/trefil/sem/sources/userspace/Model/Model.cpp:74
    //aritmeticky prumer sumy rozdilu actual_y - predicted_y
    fitness = (float)diff / i;
    8af8:	e51b300c 	ldr	r3, [fp, #-12]
    8afc:	ee073a90 	vmov	s15, r3
    8b00:	eeb87ae7 	vcvt.f32.s32	s14, s15
    8b04:	ed5b6a02 	vldr	s13, [fp, #-8]
    8b08:	eec67a87 	vdiv.f32	s15, s13, s14
    8b0c:	ed4b7a05 	vstr	s15, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/userspace/Model/Model.cpp:75
    return fitness;
    8b10:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/userspace/Model/Model.cpp:76
}
    8b14:	ee073a90 	vmov	s15, r3
    8b18:	eeb00a67 	vmov.f32	s0, s15
    8b1c:	e24bd004 	sub	sp, fp, #4
    8b20:	e8bd8800 	pop	{fp, pc}
    8b24:	c2280000 	eorgt	r0, r8, #0

00008b28 <_ZN5Model16First_GenerationEv>:
_ZN5Model16First_GenerationEv():
/home/trefil/sem/sources/userspace/Model/Model.cpp:81


//inicializace hodnot tribesmanu
//tedy randomizace parametru A,B,C,D,E
void Model::First_Generation(){
    8b28:	e92d4800 	push	{fp, lr}
    8b2c:	e28db004 	add	fp, sp, #4
    8b30:	e24dd018 	sub	sp, sp, #24
    8b34:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/userspace/Model/Model.cpp:82
    for(int i = 0; i < population_count; i++){
    8b38:	e3a03000 	mov	r3, #0
    8b3c:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/userspace/Model/Model.cpp:82 (discriminator 1)
    8b40:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8b44:	e5933014 	ldr	r3, [r3, #20]
    8b48:	e51b2008 	ldr	r2, [fp, #-8]
    8b4c:	e1520003 	cmp	r2, r3
    8b50:	aa00002f 	bge	8c14 <_ZN5Model16First_GenerationEv+0xec>
/home/trefil/sem/sources/userspace/Model/Model.cpp:83
        Tribesman* tribesman = this->population[i];
    8b54:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8b58:	e5932024 	ldr	r2, [r3, #36]	; 0x24
    8b5c:	e51b3008 	ldr	r3, [fp, #-8]
    8b60:	e1a03103 	lsl	r3, r3, #2
    8b64:	e0823003 	add	r3, r2, r3
    8b68:	e5933000 	ldr	r3, [r3]
    8b6c:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/userspace/Model/Model.cpp:85
        //randomizuj parametry
        for(int j = 0; j < PARAMETER_COUNT; j++){
    8b70:	e3a03000 	mov	r3, #0
    8b74:	e50b300c 	str	r3, [fp, #-12]
/home/trefil/sem/sources/userspace/Model/Model.cpp:85 (discriminator 3)
    8b78:	e51b300c 	ldr	r3, [fp, #-12]
    8b7c:	e3530004 	cmp	r3, #4
    8b80:	ca00000d 	bgt	8bbc <_ZN5Model16First_GenerationEv+0x94>
/home/trefil/sem/sources/userspace/Model/Model.cpp:86 (discriminator 2)
            tribesman->parameters[j] = this->random->Get_Float();
    8b84:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8b88:	e593302c 	ldr	r3, [r3, #44]	; 0x2c
    8b8c:	e1a00003 	mov	r0, r3
    8b90:	eb00054c 	bl	a0c8 <_ZN16Random_Generator9Get_FloatEv>
    8b94:	eef07a40 	vmov.f32	s15, s0
    8b98:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    8b9c:	e51b300c 	ldr	r3, [fp, #-12]
    8ba0:	e1a03103 	lsl	r3, r3, #2
    8ba4:	e0823003 	add	r3, r2, r3
    8ba8:	edc37a00 	vstr	s15, [r3]
/home/trefil/sem/sources/userspace/Model/Model.cpp:85 (discriminator 2)
        for(int j = 0; j < PARAMETER_COUNT; j++){
    8bac:	e51b300c 	ldr	r3, [fp, #-12]
    8bb0:	e2833001 	add	r3, r3, #1
    8bb4:	e50b300c 	str	r3, [fp, #-12]
    8bb8:	eaffffee 	b	8b78 <_ZN5Model16First_GenerationEv+0x50>
/home/trefil/sem/sources/userspace/Model/Model.cpp:90

        }
        //nic jeste neni predikovano
        for(int j = 0; j < window_size; j++)
    8bbc:	e3a03000 	mov	r3, #0
    8bc0:	e50b3010 	str	r3, [fp, #-16]
/home/trefil/sem/sources/userspace/Model/Model.cpp:90 (discriminator 3)
    8bc4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8bc8:	e5933010 	ldr	r3, [r3, #16]
    8bcc:	e51b2010 	ldr	r2, [fp, #-16]
    8bd0:	e1520003 	cmp	r2, r3
    8bd4:	aa00000a 	bge	8c04 <_ZN5Model16First_GenerationEv+0xdc>
/home/trefil/sem/sources/userspace/Model/Model.cpp:91 (discriminator 2)
            tribesman->predicted_values[j] = EMPTY;
    8bd8:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8bdc:	e5932018 	ldr	r2, [r3, #24]
    8be0:	e51b3010 	ldr	r3, [fp, #-16]
    8be4:	e1a03103 	lsl	r3, r3, #2
    8be8:	e0823003 	add	r3, r2, r3
    8bec:	e59f202c 	ldr	r2, [pc, #44]	; 8c20 <_ZN5Model16First_GenerationEv+0xf8>
    8bf0:	e5832000 	str	r2, [r3]
/home/trefil/sem/sources/userspace/Model/Model.cpp:90 (discriminator 2)
        for(int j = 0; j < window_size; j++)
    8bf4:	e51b3010 	ldr	r3, [fp, #-16]
    8bf8:	e2833001 	add	r3, r3, #1
    8bfc:	e50b3010 	str	r3, [fp, #-16]
    8c00:	eaffffef 	b	8bc4 <_ZN5Model16First_GenerationEv+0x9c>
/home/trefil/sem/sources/userspace/Model/Model.cpp:82 (discriminator 2)
    for(int i = 0; i < population_count; i++){
    8c04:	e51b3008 	ldr	r3, [fp, #-8]
    8c08:	e2833001 	add	r3, r3, #1
    8c0c:	e50b3008 	str	r3, [fp, #-8]
    8c10:	eaffffca 	b	8b40 <_ZN5Model16First_GenerationEv+0x18>
/home/trefil/sem/sources/userspace/Model/Model.cpp:93
    }
}
    8c14:	e320f000 	nop	{0}
    8c18:	e24bd004 	sub	sp, fp, #4
    8c1c:	e8bd8800 	pop	{fp, pc}
    8c20:	c2280000 	eorgt	r0, r8, #0

00008c24 <_ZN5Model9Set_AlphaEP9Tribesman>:
_ZN5Model9Set_AlphaEP9Tribesman():
/home/trefil/sem/sources/userspace/Model/Model.cpp:96
//prekopiruj @param t do @param this->alpha
//na konci epochy ulozime nejlepsiho z generace
void Model::Set_Alpha(Tribesman* t){
    8c24:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8c28:	e28db000 	add	fp, sp, #0
    8c2c:	e24dd014 	sub	sp, sp, #20
    8c30:	e50b0010 	str	r0, [fp, #-16]
    8c34:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/userspace/Model/Model.cpp:97
    for(int i = 0; i < PARAMETER_COUNT; i++)
    8c38:	e3a03000 	mov	r3, #0
    8c3c:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/userspace/Model/Model.cpp:97 (discriminator 3)
    8c40:	e51b3008 	ldr	r3, [fp, #-8]
    8c44:	e3530004 	cmp	r3, #4
    8c48:	ca00000e 	bgt	8c88 <_ZN5Model9Set_AlphaEP9Tribesman+0x64>
/home/trefil/sem/sources/userspace/Model/Model.cpp:98 (discriminator 2)
        this->alpha->parameters[i] = t->parameters[i];
    8c4c:	e51b3010 	ldr	r3, [fp, #-16]
    8c50:	e5931028 	ldr	r1, [r3, #40]	; 0x28
    8c54:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    8c58:	e51b3008 	ldr	r3, [fp, #-8]
    8c5c:	e1a03103 	lsl	r3, r3, #2
    8c60:	e0823003 	add	r3, r2, r3
    8c64:	e5932000 	ldr	r2, [r3]
    8c68:	e51b3008 	ldr	r3, [fp, #-8]
    8c6c:	e1a03103 	lsl	r3, r3, #2
    8c70:	e0813003 	add	r3, r1, r3
    8c74:	e5832000 	str	r2, [r3]
/home/trefil/sem/sources/userspace/Model/Model.cpp:97 (discriminator 2)
    for(int i = 0; i < PARAMETER_COUNT; i++)
    8c78:	e51b3008 	ldr	r3, [fp, #-8]
    8c7c:	e2833001 	add	r3, r3, #1
    8c80:	e50b3008 	str	r3, [fp, #-8]
    8c84:	eaffffed 	b	8c40 <_ZN5Model9Set_AlphaEP9Tribesman+0x1c>
/home/trefil/sem/sources/userspace/Model/Model.cpp:99
    for(int i = 0; i < window_size; i++)
    8c88:	e3a03000 	mov	r3, #0
    8c8c:	e50b300c 	str	r3, [fp, #-12]
/home/trefil/sem/sources/userspace/Model/Model.cpp:99 (discriminator 3)
    8c90:	e51b3010 	ldr	r3, [fp, #-16]
    8c94:	e5933010 	ldr	r3, [r3, #16]
    8c98:	e51b200c 	ldr	r2, [fp, #-12]
    8c9c:	e1520003 	cmp	r2, r3
    8ca0:	aa000010 	bge	8ce8 <_ZN5Model9Set_AlphaEP9Tribesman+0xc4>
/home/trefil/sem/sources/userspace/Model/Model.cpp:100 (discriminator 2)
        this->alpha->predicted_values[i] = t->predicted_values[i];
    8ca4:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8ca8:	e5932018 	ldr	r2, [r3, #24]
    8cac:	e51b300c 	ldr	r3, [fp, #-12]
    8cb0:	e1a03103 	lsl	r3, r3, #2
    8cb4:	e0822003 	add	r2, r2, r3
    8cb8:	e51b3010 	ldr	r3, [fp, #-16]
    8cbc:	e5933028 	ldr	r3, [r3, #40]	; 0x28
    8cc0:	e5931018 	ldr	r1, [r3, #24]
    8cc4:	e51b300c 	ldr	r3, [fp, #-12]
    8cc8:	e1a03103 	lsl	r3, r3, #2
    8ccc:	e0813003 	add	r3, r1, r3
    8cd0:	e5922000 	ldr	r2, [r2]
    8cd4:	e5832000 	str	r2, [r3]
/home/trefil/sem/sources/userspace/Model/Model.cpp:99 (discriminator 2)
    for(int i = 0; i < window_size; i++)
    8cd8:	e51b300c 	ldr	r3, [fp, #-12]
    8cdc:	e2833001 	add	r3, r3, #1
    8ce0:	e50b300c 	str	r3, [fp, #-12]
    8ce4:	eaffffe9 	b	8c90 <_ZN5Model9Set_AlphaEP9Tribesman+0x6c>
/home/trefil/sem/sources/userspace/Model/Model.cpp:101
    this->alpha->fitness = t->fitness;
    8ce8:	e51b3010 	ldr	r3, [fp, #-16]
    8cec:	e5933028 	ldr	r3, [r3, #40]	; 0x28
    8cf0:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    8cf4:	e5922014 	ldr	r2, [r2, #20]
    8cf8:	e5832014 	str	r2, [r3, #20]
/home/trefil/sem/sources/userspace/Model/Model.cpp:102
}
    8cfc:	e320f000 	nop	{0}
    8d00:	e28bd000 	add	sp, fp, #0
    8d04:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8d08:	e12fff1e 	bx	lr

00008d0c <_ZN5Model16Print_ParametersEv>:
_ZN5Model16Print_ParametersEv():
/home/trefil/sem/sources/userspace/Model/Model.cpp:105
//vypise parametry nejlepsiho
//tedy @attribute Alpha clena populace
void Model::Print_Parameters(){
    8d0c:	e92d4800 	push	{fp, lr}
    8d10:	e28db004 	add	fp, sp, #4
    8d14:	e24dd0c0 	sub	sp, sp, #192	; 0xc0
    8d18:	e50b00c0 	str	r0, [fp, #-192]	; 0xffffff40
/home/trefil/sem/sources/userspace/Model/Model.cpp:107
    //nejaky dostatecny velky buffer pro nase potreby
    char temp_buffer[128] = {0};
    8d1c:	e3a03000 	mov	r3, #0
    8d20:	e50b3090 	str	r3, [fp, #-144]	; 0xffffff70
    8d24:	e24b308c 	sub	r3, fp, #140	; 0x8c
    8d28:	e3a0207c 	mov	r2, #124	; 0x7c
    8d2c:	e3a01000 	mov	r1, #0
    8d30:	e1a00003 	mov	r0, r3
    8d34:	eb000c71 	bl	bf00 <memset>
/home/trefil/sem/sources/userspace/Model/Model.cpp:108
    char params[PARAMETER_COUNT][PARAMETER_COUNT] = {"A = ","B = ","C = ","D = ", "E = "};
    8d38:	e59f3118 	ldr	r3, [pc, #280]	; 8e58 <_ZN5Model16Print_ParametersEv+0x14c>
    8d3c:	e24bc0ac 	sub	ip, fp, #172	; 0xac
    8d40:	e1a0e003 	mov	lr, r3
    8d44:	e8be000f 	ldm	lr!, {r0, r1, r2, r3}
    8d48:	e8ac000f 	stmia	ip!, {r0, r1, r2, r3}
    8d4c:	e89e0007 	ldm	lr, {r0, r1, r2}
    8d50:	e8ac0003 	stmia	ip!, {r0, r1}
    8d54:	e5cc2000 	strb	r2, [ip]
/home/trefil/sem/sources/userspace/Model/Model.cpp:109
    char temp_float_buffer[10] = {0};
    8d58:	e3a03000 	mov	r3, #0
    8d5c:	e50b30b8 	str	r3, [fp, #-184]	; 0xffffff48
    8d60:	e24b30b4 	sub	r3, fp, #180	; 0xb4
    8d64:	e3a02000 	mov	r2, #0
    8d68:	e5832000 	str	r2, [r3]
    8d6c:	e1c320b4 	strh	r2, [r3, #4]
/home/trefil/sem/sources/userspace/Model/Model.cpp:110
    Tribesman* tmp = this->alpha;
    8d70:	e51b30c0 	ldr	r3, [fp, #-192]	; 0xffffff40
    8d74:	e5933028 	ldr	r3, [r3, #40]	; 0x28
    8d78:	e50b300c 	str	r3, [fp, #-12]
/home/trefil/sem/sources/userspace/Model/Model.cpp:112

    for(int i = 0; i < PARAMETER_COUNT; i++){
    8d7c:	e3a03000 	mov	r3, #0
    8d80:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/userspace/Model/Model.cpp:112 (discriminator 1)
    8d84:	e51b3008 	ldr	r3, [fp, #-8]
    8d88:	e3530004 	cmp	r3, #4
    8d8c:	ca000023 	bgt	8e20 <_ZN5Model16Print_ParametersEv+0x114>
/home/trefil/sem/sources/userspace/Model/Model.cpp:113
        float f = tmp->parameters[i];
    8d90:	e51b200c 	ldr	r2, [fp, #-12]
    8d94:	e51b3008 	ldr	r3, [fp, #-8]
    8d98:	e1a03103 	lsl	r3, r3, #2
    8d9c:	e0823003 	add	r3, r2, r3
    8da0:	e5933000 	ldr	r3, [r3]
    8da4:	e50b3010 	str	r3, [fp, #-16]
/home/trefil/sem/sources/userspace/Model/Model.cpp:114
        ftoa(f,temp_float_buffer);
    8da8:	e24b30b8 	sub	r3, fp, #184	; 0xb8
    8dac:	e1a00003 	mov	r0, r3
    8db0:	ed1b0a04 	vldr	s0, [fp, #-16]
    8db4:	eb000946 	bl	b2d4 <_Z4ftoafPc>
/home/trefil/sem/sources/userspace/Model/Model.cpp:115
        strncat(temp_buffer,params[i],128);
    8db8:	e24b10ac 	sub	r1, fp, #172	; 0xac
    8dbc:	e51b2008 	ldr	r2, [fp, #-8]
    8dc0:	e1a03002 	mov	r3, r2
    8dc4:	e1a03103 	lsl	r3, r3, #2
    8dc8:	e0833002 	add	r3, r3, r2
    8dcc:	e0811003 	add	r1, r1, r3
    8dd0:	e24b3090 	sub	r3, fp, #144	; 0x90
    8dd4:	e3a02080 	mov	r2, #128	; 0x80
    8dd8:	e1a00003 	mov	r0, r3
    8ddc:	eb0008b2 	bl	b0ac <_Z7strncatPcPKci>
/home/trefil/sem/sources/userspace/Model/Model.cpp:116
        strncat(temp_buffer,temp_float_buffer,128);
    8de0:	e24b10b8 	sub	r1, fp, #184	; 0xb8
    8de4:	e24b3090 	sub	r3, fp, #144	; 0x90
    8de8:	e3a02080 	mov	r2, #128	; 0x80
    8dec:	e1a00003 	mov	r0, r3
    8df0:	eb0008ad 	bl	b0ac <_Z7strncatPcPKci>
/home/trefil/sem/sources/userspace/Model/Model.cpp:117
        if(i != PARAMETER_COUNT - 1)
    8df4:	e51b3008 	ldr	r3, [fp, #-8]
    8df8:	e3530004 	cmp	r3, #4
    8dfc:	0a000003 	beq	8e10 <_ZN5Model16Print_ParametersEv+0x104>
/home/trefil/sem/sources/userspace/Model/Model.cpp:118
            strcat(temp_buffer,", ");
    8e00:	e24b3090 	sub	r3, fp, #144	; 0x90
    8e04:	e59f1050 	ldr	r1, [pc, #80]	; 8e5c <_ZN5Model16Print_ParametersEv+0x150>
    8e08:	e1a00003 	mov	r0, r3
    8e0c:	eb00087b 	bl	b000 <_Z6strcatPcPKc>
/home/trefil/sem/sources/userspace/Model/Model.cpp:112 (discriminator 2)
    for(int i = 0; i < PARAMETER_COUNT; i++){
    8e10:	e51b3008 	ldr	r3, [fp, #-8]
    8e14:	e2833001 	add	r3, r3, #1
    8e18:	e50b3008 	str	r3, [fp, #-8]
    8e1c:	eaffffd8 	b	8d84 <_ZN5Model16Print_ParametersEv+0x78>
/home/trefil/sem/sources/userspace/Model/Model.cpp:120
    }
    this->bfr->Write_Line(temp_buffer);
    8e20:	e51b30c0 	ldr	r3, [fp, #-192]	; 0xffffff40
    8e24:	e5933030 	ldr	r3, [r3, #48]	; 0x30
    8e28:	e24b2090 	sub	r2, fp, #144	; 0x90
    8e2c:	e1a01002 	mov	r1, r2
    8e30:	e1a00003 	mov	r0, r3
    8e34:	eb00050d 	bl	a270 <_ZN6Buffer10Write_LineEPKc>
/home/trefil/sem/sources/userspace/Model/Model.cpp:121
    this->bfr->Write_Line("\n");
    8e38:	e51b30c0 	ldr	r3, [fp, #-192]	; 0xffffff40
    8e3c:	e5933030 	ldr	r3, [r3, #48]	; 0x30
    8e40:	e59f1018 	ldr	r1, [pc, #24]	; 8e60 <_ZN5Model16Print_ParametersEv+0x154>
    8e44:	e1a00003 	mov	r0, r3
    8e48:	eb000508 	bl	a270 <_ZN6Buffer10Write_LineEPKc>
/home/trefil/sem/sources/userspace/Model/Model.cpp:124


}
    8e4c:	e320f000 	nop	{0}
    8e50:	e24bd004 	sub	sp, fp, #4
    8e54:	e8bd8800 	pop	{fp, pc}
    8e58:	0000c1c8 	andeq	ip, r0, r8, asr #3
    8e5c:	0000c1c0 	andeq	ip, r0, r0, asr #3
    8e60:	0000c1c4 	andeq	ip, r0, r4, asr #3

00008e64 <_ZN5Model4InitEv>:
_ZN5Model4InitEv():
/home/trefil/sem/sources/userspace/Model/Model.cpp:126
// inicializuj populaci
void Model::Init() {
    8e64:	e92d4810 	push	{r4, fp, lr}
    8e68:	e28db008 	add	fp, sp, #8
    8e6c:	e24dd024 	sub	sp, sp, #36	; 0x24
    8e70:	e50b0020 	str	r0, [fp, #-32]	; 0xffffffe0
/home/trefil/sem/sources/userspace/Model/Model.cpp:128

    this->population = reinterpret_cast<Tribesman**>(malloc(sizeof(Tribesman*) * population_count));
    8e74:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8e78:	e5933014 	ldr	r3, [r3, #20]
    8e7c:	e1a03103 	lsl	r3, r3, #2
    8e80:	e1a00003 	mov	r0, r3
    8e84:	eb00032f 	bl	9b48 <_Z6mallocj>
    8e88:	e1a02000 	mov	r2, r0
    8e8c:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8e90:	e5832024 	str	r2, [r3, #36]	; 0x24
/home/trefil/sem/sources/userspace/Model/Model.cpp:130

    for(int i = 0; i < population_count;i++){
    8e94:	e3a03000 	mov	r3, #0
    8e98:	e50b3010 	str	r3, [fp, #-16]
/home/trefil/sem/sources/userspace/Model/Model.cpp:130 (discriminator 1)
    8e9c:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8ea0:	e5933014 	ldr	r3, [r3, #20]
    8ea4:	e51b2010 	ldr	r2, [fp, #-16]
    8ea8:	e1520003 	cmp	r2, r3
    8eac:	aa000034 	bge	8f84 <_ZN5Model4InitEv+0x120>
/home/trefil/sem/sources/userspace/Model/Model.cpp:131
        this->population[i] = new Tribesman;//reinterpret_cast<Tribesman*>(malloc(sizeof(Tribesman)));
    8eb0:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8eb4:	e5932024 	ldr	r2, [r3, #36]	; 0x24
    8eb8:	e51b3010 	ldr	r3, [fp, #-16]
    8ebc:	e1a03103 	lsl	r3, r3, #2
    8ec0:	e0824003 	add	r4, r2, r3
    8ec4:	e3a0001c 	mov	r0, #28
    8ec8:	ebfffdf8 	bl	86b0 <_Znwj>
    8ecc:	e1a03000 	mov	r3, r0
    8ed0:	e5843000 	str	r3, [r4]
/home/trefil/sem/sources/userspace/Model/Model.cpp:133
        //struktura pro predikovane hodnoty
        this->population[i]->predicted_values = new float[window_size];
    8ed4:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8ed8:	e5933010 	ldr	r3, [r3, #16]
    8edc:	e373022e 	cmn	r3, #-536870910	; 0xe0000002
    8ee0:	8a000001 	bhi	8eec <_ZN5Model4InitEv+0x88>
/home/trefil/sem/sources/userspace/Model/Model.cpp:133 (discriminator 1)
    8ee4:	e1a03103 	lsl	r3, r3, #2
    8ee8:	ea000000 	b	8ef0 <_ZN5Model4InitEv+0x8c>
/home/trefil/sem/sources/userspace/Model/Model.cpp:133 (discriminator 2)
    8eec:	e3e03000 	mvn	r3, #0
/home/trefil/sem/sources/userspace/Model/Model.cpp:133 (discriminator 4)
    8ef0:	e51b2020 	ldr	r2, [fp, #-32]	; 0xffffffe0
    8ef4:	e5921024 	ldr	r1, [r2, #36]	; 0x24
    8ef8:	e51b2010 	ldr	r2, [fp, #-16]
    8efc:	e1a02102 	lsl	r2, r2, #2
    8f00:	e0812002 	add	r2, r1, r2
    8f04:	e5924000 	ldr	r4, [r2]
    8f08:	e1a00003 	mov	r0, r3
    8f0c:	ebfffdf3 	bl	86e0 <_Znaj>
    8f10:	e1a03000 	mov	r3, r0
    8f14:	e5843018 	str	r3, [r4, #24]
/home/trefil/sem/sources/userspace/Model/Model.cpp:137 (discriminator 4)
        //vynuluj hodnoty - aby tam nebyl pripadne nejaky bordylek
        //bss sekce je vynulovana, takze by tam nemel byt nejaky svinec
        //ale pro pripad, ze tam svinec je, tak nechceme, aby umrel task na neco hloupeho
        for(int j = 0; j < window_size; j++)
    8f18:	e3a03000 	mov	r3, #0
    8f1c:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/userspace/Model/Model.cpp:137 (discriminator 3)
    8f20:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8f24:	e5933010 	ldr	r3, [r3, #16]
    8f28:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    8f2c:	e1520003 	cmp	r2, r3
    8f30:	aa00000f 	bge	8f74 <_ZN5Model4InitEv+0x110>
/home/trefil/sem/sources/userspace/Model/Model.cpp:138 (discriminator 2)
            this->population[i]->predicted_values[j] =  0;
    8f34:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8f38:	e5932024 	ldr	r2, [r3, #36]	; 0x24
    8f3c:	e51b3010 	ldr	r3, [fp, #-16]
    8f40:	e1a03103 	lsl	r3, r3, #2
    8f44:	e0823003 	add	r3, r2, r3
    8f48:	e5933000 	ldr	r3, [r3]
    8f4c:	e5932018 	ldr	r2, [r3, #24]
    8f50:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8f54:	e1a03103 	lsl	r3, r3, #2
    8f58:	e0823003 	add	r3, r2, r3
    8f5c:	e3a02000 	mov	r2, #0
    8f60:	e5832000 	str	r2, [r3]
/home/trefil/sem/sources/userspace/Model/Model.cpp:137 (discriminator 2)
        for(int j = 0; j < window_size; j++)
    8f64:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8f68:	e2833001 	add	r3, r3, #1
    8f6c:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
    8f70:	eaffffea 	b	8f20 <_ZN5Model4InitEv+0xbc>
/home/trefil/sem/sources/userspace/Model/Model.cpp:130 (discriminator 2)
    for(int i = 0; i < population_count;i++){
    8f74:	e51b3010 	ldr	r3, [fp, #-16]
    8f78:	e2833001 	add	r3, r3, #1
    8f7c:	e50b3010 	str	r3, [fp, #-16]
    8f80:	eaffffc5 	b	8e9c <_ZN5Model4InitEv+0x38>
/home/trefil/sem/sources/userspace/Model/Model.cpp:142

    }

    this->data = new float[window_size];
    8f84:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8f88:	e5933010 	ldr	r3, [r3, #16]
    8f8c:	e373022e 	cmn	r3, #-536870910	; 0xe0000002
    8f90:	8a000001 	bhi	8f9c <_ZN5Model4InitEv+0x138>
/home/trefil/sem/sources/userspace/Model/Model.cpp:142 (discriminator 1)
    8f94:	e1a03103 	lsl	r3, r3, #2
    8f98:	ea000000 	b	8fa0 <_ZN5Model4InitEv+0x13c>
/home/trefil/sem/sources/userspace/Model/Model.cpp:142 (discriminator 2)
    8f9c:	e3e03000 	mvn	r3, #0
/home/trefil/sem/sources/userspace/Model/Model.cpp:142 (discriminator 4)
    8fa0:	e1a00003 	mov	r0, r3
    8fa4:	ebfffdcd 	bl	86e0 <_Znaj>
    8fa8:	e1a03000 	mov	r3, r0
    8fac:	e1a02003 	mov	r2, r3
    8fb0:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8fb4:	e5832038 	str	r2, [r3, #56]	; 0x38
/home/trefil/sem/sources/userspace/Model/Model.cpp:145 (discriminator 4)
    //*1000 abych to mohl rozumne prevadet na floaty

    this->random = new Random_Generator(min_parameter_value * 1000, max_parameter_value * 1000, 4, 1, 42);
    8fb8:	e3a0001c 	mov	r0, #28
    8fbc:	ebfffdbb 	bl	86b0 <_Znwj>
    8fc0:	e1a03000 	mov	r3, r0
    8fc4:	e1a04003 	mov	r4, r3
    8fc8:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8fcc:	e5932008 	ldr	r2, [r3, #8]
    8fd0:	e1a03002 	mov	r3, r2
    8fd4:	e1a03283 	lsl	r3, r3, #5
    8fd8:	e0433002 	sub	r3, r3, r2
    8fdc:	e1a03103 	lsl	r3, r3, #2
    8fe0:	e0833002 	add	r3, r3, r2
    8fe4:	e1a03183 	lsl	r3, r3, #3
    8fe8:	e1a01003 	mov	r1, r3
    8fec:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8ff0:	e593200c 	ldr	r2, [r3, #12]
    8ff4:	e1a03002 	mov	r3, r2
    8ff8:	e1a03283 	lsl	r3, r3, #5
    8ffc:	e0433002 	sub	r3, r3, r2
    9000:	e1a03103 	lsl	r3, r3, #2
    9004:	e0833002 	add	r3, r3, r2
    9008:	e1a03183 	lsl	r3, r3, #3
    900c:	e1a02003 	mov	r2, r3
    9010:	e3a0302a 	mov	r3, #42	; 0x2a
    9014:	e58d3004 	str	r3, [sp, #4]
    9018:	e3a03001 	mov	r3, #1
    901c:	e58d3000 	str	r3, [sp]
    9020:	e3a03004 	mov	r3, #4
    9024:	e1a00004 	mov	r0, r4
    9028:	eb0003e4 	bl	9fc0 <_ZN16Random_GeneratorC1Eiiiii>
    902c:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    9030:	e583402c 	str	r4, [r3, #44]	; 0x2c
/home/trefil/sem/sources/userspace/Model/Model.cpp:148 (discriminator 4)

    //init nejlepsiho z generace
    this->alpha = new Tribesman;
    9034:	e3a0001c 	mov	r0, #28
    9038:	ebfffd9c 	bl	86b0 <_Znwj>
    903c:	e1a03000 	mov	r3, r0
    9040:	e1a02003 	mov	r2, r3
    9044:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    9048:	e5832028 	str	r2, [r3, #40]	; 0x28
/home/trefil/sem/sources/userspace/Model/Model.cpp:149 (discriminator 4)
    this->alpha->predicted_values = new float[window_size];
    904c:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    9050:	e5933010 	ldr	r3, [r3, #16]
    9054:	e373022e 	cmn	r3, #-536870910	; 0xe0000002
    9058:	8a000001 	bhi	9064 <_ZN5Model4InitEv+0x200>
/home/trefil/sem/sources/userspace/Model/Model.cpp:149 (discriminator 1)
    905c:	e1a03103 	lsl	r3, r3, #2
    9060:	ea000000 	b	9068 <_ZN5Model4InitEv+0x204>
/home/trefil/sem/sources/userspace/Model/Model.cpp:149 (discriminator 2)
    9064:	e3e03000 	mvn	r3, #0
/home/trefil/sem/sources/userspace/Model/Model.cpp:149 (discriminator 4)
    9068:	e51b2020 	ldr	r2, [fp, #-32]	; 0xffffffe0
    906c:	e5924028 	ldr	r4, [r2, #40]	; 0x28
    9070:	e1a00003 	mov	r0, r3
    9074:	ebfffd99 	bl	86e0 <_Znaj>
    9078:	e1a03000 	mov	r3, r0
    907c:	e5843018 	str	r3, [r4, #24]
/home/trefil/sem/sources/userspace/Model/Model.cpp:150 (discriminator 4)
    for(int j = 0; j < window_size; j++)
    9080:	e3a03000 	mov	r3, #0
    9084:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/userspace/Model/Model.cpp:150 (discriminator 3)
    9088:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    908c:	e5933010 	ldr	r3, [r3, #16]
    9090:	e51b2018 	ldr	r2, [fp, #-24]	; 0xffffffe8
    9094:	e1520003 	cmp	r2, r3
    9098:	aa00000b 	bge	90cc <_ZN5Model4InitEv+0x268>
/home/trefil/sem/sources/userspace/Model/Model.cpp:151 (discriminator 2)
        this->alpha->predicted_values[j] = 0;
    909c:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    90a0:	e5933028 	ldr	r3, [r3, #40]	; 0x28
    90a4:	e5932018 	ldr	r2, [r3, #24]
    90a8:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    90ac:	e1a03103 	lsl	r3, r3, #2
    90b0:	e0823003 	add	r3, r2, r3
    90b4:	e3a02000 	mov	r2, #0
    90b8:	e5832000 	str	r2, [r3]
/home/trefil/sem/sources/userspace/Model/Model.cpp:150 (discriminator 2)
    for(int j = 0; j < window_size; j++)
    90bc:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    90c0:	e2833001 	add	r3, r3, #1
    90c4:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
    90c8:	eaffffee 	b	9088 <_ZN5Model4InitEv+0x224>
/home/trefil/sem/sources/userspace/Model/Model.cpp:153

    First_Generation();
    90cc:	e51b0020 	ldr	r0, [fp, #-32]	; 0xffffffe0
    90d0:	ebfffe94 	bl	8b28 <_ZN5Model16First_GenerationEv>
/home/trefil/sem/sources/userspace/Model/Model.cpp:155

}
    90d4:	e320f000 	nop	{0}
    90d8:	e24bd008 	sub	sp, fp, #8
    90dc:	e8bd8810 	pop	{r4, fp, pc}

000090e0 <_ZN5Model19Is_Data_Window_FullEv>:
_ZN5Model19Is_Data_Window_FullEv():
/home/trefil/sem/sources/userspace/Model/Model.cpp:156
bool Model::Is_Data_Window_Full(){
    90e0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    90e4:	e28db000 	add	fp, sp, #0
    90e8:	e24dd00c 	sub	sp, sp, #12
    90ec:	e50b0008 	str	r0, [fp, #-8]
/home/trefil/sem/sources/userspace/Model/Model.cpp:157
    return data_pointer == window_size;
    90f0:	e51b3008 	ldr	r3, [fp, #-8]
    90f4:	e593201c 	ldr	r2, [r3, #28]
    90f8:	e51b3008 	ldr	r3, [fp, #-8]
    90fc:	e5933010 	ldr	r3, [r3, #16]
    9100:	e1520003 	cmp	r2, r3
    9104:	03a03001 	moveq	r3, #1
    9108:	13a03000 	movne	r3, #0
    910c:	e6ef3073 	uxtb	r3, r3
/home/trefil/sem/sources/userspace/Model/Model.cpp:158
}
    9110:	e1a00003 	mov	r0, r3
    9114:	e28bd000 	add	sp, fp, #0
    9118:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    911c:	e12fff1e 	bx	lr

00009120 <_ZN5Model15Add_Data_SampleEf>:
_ZN5Model15Add_Data_SampleEf():
/home/trefil/sem/sources/userspace/Model/Model.cpp:160

bool Model::Add_Data_Sample(float y){
    9120:	e92d4800 	push	{fp, lr}
    9124:	e28db004 	add	fp, sp, #4
    9128:	e24dd008 	sub	sp, sp, #8
    912c:	e50b0008 	str	r0, [fp, #-8]
    9130:	ed0b0a03 	vstr	s0, [fp, #-12]
/home/trefil/sem/sources/userspace/Model/Model.cpp:161
    if(Is_Data_Window_Full()){
    9134:	e51b0008 	ldr	r0, [fp, #-8]
    9138:	ebffffe8 	bl	90e0 <_ZN5Model19Is_Data_Window_FullEv>
    913c:	e1a03000 	mov	r3, r0
    9140:	e3530000 	cmp	r3, #0
    9144:	0a000001 	beq	9150 <_ZN5Model15Add_Data_SampleEf+0x30>
/home/trefil/sem/sources/userspace/Model/Model.cpp:162
        return false;
    9148:	e3a03000 	mov	r3, #0
    914c:	ea00000b 	b	9180 <_ZN5Model15Add_Data_SampleEf+0x60>
/home/trefil/sem/sources/userspace/Model/Model.cpp:164
    }
    this->data[data_pointer++] = y;
    9150:	e51b3008 	ldr	r3, [fp, #-8]
    9154:	e5932038 	ldr	r2, [r3, #56]	; 0x38
    9158:	e51b3008 	ldr	r3, [fp, #-8]
    915c:	e593301c 	ldr	r3, [r3, #28]
    9160:	e2830001 	add	r0, r3, #1
    9164:	e51b1008 	ldr	r1, [fp, #-8]
    9168:	e581001c 	str	r0, [r1, #28]
    916c:	e1a03103 	lsl	r3, r3, #2
    9170:	e0823003 	add	r3, r2, r3
    9174:	e51b200c 	ldr	r2, [fp, #-12]
    9178:	e5832000 	str	r2, [r3]
/home/trefil/sem/sources/userspace/Model/Model.cpp:165
    return true;
    917c:	e3a03001 	mov	r3, #1
/home/trefil/sem/sources/userspace/Model/Model.cpp:166
}
    9180:	e1a00003 	mov	r0, r3
    9184:	e24bd004 	sub	sp, fp, #4
    9188:	e8bd8800 	pop	{fp, pc}

0000918c <_ZN5Model10Set_BufferEP6Buffer>:
_ZN5Model10Set_BufferEP6Buffer():
/home/trefil/sem/sources/userspace/Model/Model.cpp:168

void Model::Set_Buffer(Buffer* bfr){
    918c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9190:	e28db000 	add	fp, sp, #0
    9194:	e24dd00c 	sub	sp, sp, #12
    9198:	e50b0008 	str	r0, [fp, #-8]
    919c:	e50b100c 	str	r1, [fp, #-12]
/home/trefil/sem/sources/userspace/Model/Model.cpp:169
    this->bfr = bfr;
    91a0:	e51b3008 	ldr	r3, [fp, #-8]
    91a4:	e51b200c 	ldr	r2, [fp, #-12]
    91a8:	e5832030 	str	r2, [r3, #48]	; 0x30
/home/trefil/sem/sources/userspace/Model/Model.cpp:170
}
    91ac:	e320f000 	nop	{0}
    91b0:	e28bd000 	add	sp, fp, #0
    91b4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    91b8:	e12fff1e 	bx	lr

000091bc <_ZN5Model16Get_Data_SamplesEv>:
_ZN5Model16Get_Data_SamplesEv():
/home/trefil/sem/sources/userspace/Model/Model.cpp:172

float* Model::Get_Data_Samples(){
    91bc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    91c0:	e28db000 	add	fp, sp, #0
    91c4:	e24dd00c 	sub	sp, sp, #12
    91c8:	e50b0008 	str	r0, [fp, #-8]
/home/trefil/sem/sources/userspace/Model/Model.cpp:173
    return this->data;
    91cc:	e51b3008 	ldr	r3, [fp, #-8]
    91d0:	e5933038 	ldr	r3, [r3, #56]	; 0x38
/home/trefil/sem/sources/userspace/Model/Model.cpp:174
}
    91d4:	e1a00003 	mov	r0, r3
    91d8:	e28bd000 	add	sp, fp, #0
    91dc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    91e0:	e12fff1e 	bx	lr

000091e4 <_ZN5Model15Gene_Pool_PartyEPP9Tribesman>:
_ZN5Model15Gene_Pool_PartyEPP9Tribesman():
/home/trefil/sem/sources/userspace/Model/Model.cpp:176
//20% smetanky populace prezije, zbytek je nahrazen krizenim, tedy ppst krizeni = 0.2
void Model::Gene_Pool_Party(Tribesman** population){
    91e4:	e92d4810 	push	{r4, fp, lr}
    91e8:	e28db008 	add	fp, sp, #8
    91ec:	e24dd03c 	sub	sp, sp, #60	; 0x3c
    91f0:	e50b0040 	str	r0, [fp, #-64]	; 0xffffffc0
    91f4:	e50b1044 	str	r1, [fp, #-68]	; 0xffffffbc
/home/trefil/sem/sources/userspace/Model/Model.cpp:178
    // stanovime hranici krizeni
    int cross_boundary = this->random->Get_Int() % PARAMETER_COUNT;
    91f8:	e51b3040 	ldr	r3, [fp, #-64]	; 0xffffffc0
    91fc:	e593302c 	ldr	r3, [r3, #44]	; 0x2c
    9200:	e1a00003 	mov	r0, r3
    9204:	eb00038b 	bl	a038 <_ZN16Random_Generator7Get_IntEv>
    9208:	e1a02000 	mov	r2, r0
    920c:	e59f3284 	ldr	r3, [pc, #644]	; 9498 <_ZN5Model15Gene_Pool_PartyEPP9Tribesman+0x2b4>
    9210:	e0c31293 	smull	r1, r3, r3, r2
    9214:	e1a010c3 	asr	r1, r3, #1
    9218:	e1a03fc2 	asr	r3, r2, #31
    921c:	e0411003 	sub	r1, r1, r3
    9220:	e1a03001 	mov	r3, r1
    9224:	e1a03103 	lsl	r3, r3, #2
    9228:	e0833001 	add	r3, r3, r1
    922c:	e0423003 	sub	r3, r2, r3
    9230:	e50b3024 	str	r3, [fp, #-36]	; 0xffffffdc
/home/trefil/sem/sources/userspace/Model/Model.cpp:180
    //dedime z leveho rodice nebo praveho
    bool left_parent = this->random->Get_Int() % 2 == 0;
    9234:	e51b3040 	ldr	r3, [fp, #-64]	; 0xffffffc0
    9238:	e593302c 	ldr	r3, [r3, #44]	; 0x2c
    923c:	e1a00003 	mov	r0, r3
    9240:	eb00037c 	bl	a038 <_ZN16Random_Generator7Get_IntEv>
    9244:	e1a03000 	mov	r3, r0
    9248:	e2033001 	and	r3, r3, #1
    924c:	e3530000 	cmp	r3, #0
    9250:	03a03001 	moveq	r3, #1
    9254:	13a03000 	movne	r3, #0
    9258:	e54b3025 	strb	r3, [fp, #-37]	; 0xffffffdb
/home/trefil/sem/sources/userspace/Model/Model.cpp:184
    //odtud zacinam nahrazovat
    //tedy <start> clenu populace zustane
    //z nich vznikne start / 2 novych clenu krizenim
    int start = this->population_count * 0.2;
    925c:	e51b3040 	ldr	r3, [fp, #-64]	; 0xffffffc0
    9260:	e5933014 	ldr	r3, [r3, #20]
    9264:	ee073a90 	vmov	s15, r3
    9268:	eeb87be7 	vcvt.f64.s32	d7, s15
    926c:	ed9f6b87 	vldr	d6, [pc, #540]	; 9490 <_ZN5Model15Gene_Pool_PartyEPP9Tribesman+0x2ac>
    9270:	ee277b06 	vmul.f64	d7, d7, d6
    9274:	eefd7bc7 	vcvt.s32.f64	s15, d7
    9278:	ee173a90 	vmov	r3, s15
    927c:	e50b3010 	str	r3, [fp, #-16]
/home/trefil/sem/sources/userspace/Model/Model.cpp:186
    //tolik potrebujeme vytvorit novych clenu populace
    int new_pop_count = population_count - start;
    9280:	e51b3040 	ldr	r3, [fp, #-64]	; 0xffffffc0
    9284:	e5932014 	ldr	r2, [r3, #20]
    9288:	e51b3010 	ldr	r3, [fp, #-16]
    928c:	e0423003 	sub	r3, r2, r3
    9290:	e50b302c 	str	r3, [fp, #-44]	; 0xffffffd4
/home/trefil/sem/sources/userspace/Model/Model.cpp:188
    //vytvor deti z top 20 % clenu populace
    int pointer = 0;
    9294:	e3a03000 	mov	r3, #0
    9298:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/userspace/Model/Model.cpp:191

    //od start po party_stop se budou vznikat potomci krizenim
    int party_stop = start + start / 2;
    929c:	e51b3010 	ldr	r3, [fp, #-16]
    92a0:	e1a02fa3 	lsr	r2, r3, #31
    92a4:	e0823003 	add	r3, r2, r3
    92a8:	e1a030c3 	asr	r3, r3, #1
    92ac:	e1a02003 	mov	r2, r3
    92b0:	e51b3010 	ldr	r3, [fp, #-16]
    92b4:	e0833002 	add	r3, r3, r2
    92b8:	e50b3030 	str	r3, [fp, #-48]	; 0xffffffd0
/home/trefil/sem/sources/userspace/Model/Model.cpp:193 (discriminator 1)
    //cleny populace do indexu start ponecham
    for(start; start < party_stop ;start++){
    92bc:	e51b2010 	ldr	r2, [fp, #-16]
    92c0:	e51b3030 	ldr	r3, [fp, #-48]	; 0xffffffd0
    92c4:	e1520003 	cmp	r2, r3
    92c8:	aa00004b 	bge	93fc <_ZN5Model15Gene_Pool_PartyEPP9Tribesman+0x218>
/home/trefil/sem/sources/userspace/Model/Model.cpp:194
        Tribesman* l_parent = population[pointer];
    92cc:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    92d0:	e1a03103 	lsl	r3, r3, #2
    92d4:	e51b2044 	ldr	r2, [fp, #-68]	; 0xffffffbc
    92d8:	e0823003 	add	r3, r2, r3
    92dc:	e5933000 	ldr	r3, [r3]
    92e0:	e50b3034 	str	r3, [fp, #-52]	; 0xffffffcc
/home/trefil/sem/sources/userspace/Model/Model.cpp:195
        Tribesman* r_parent = population[pointer + 1];
    92e4:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    92e8:	e2833001 	add	r3, r3, #1
    92ec:	e1a03103 	lsl	r3, r3, #2
    92f0:	e51b2044 	ldr	r2, [fp, #-68]	; 0xffffffbc
    92f4:	e0823003 	add	r3, r2, r3
    92f8:	e5933000 	ldr	r3, [r3]
    92fc:	e50b3038 	str	r3, [fp, #-56]	; 0xffffffc8
/home/trefil/sem/sources/userspace/Model/Model.cpp:197

        for(int i = 0; i < cross_boundary; i++)
    9300:	e3a03000 	mov	r3, #0
    9304:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/userspace/Model/Model.cpp:197 (discriminator 2)
    9308:	e51b2018 	ldr	r2, [fp, #-24]	; 0xffffffe8
    930c:	e51b3024 	ldr	r3, [fp, #-36]	; 0xffffffdc
    9310:	e1520003 	cmp	r2, r3
    9314:	aa00001a 	bge	9384 <_ZN5Model15Gene_Pool_PartyEPP9Tribesman+0x1a0>
/home/trefil/sem/sources/userspace/Model/Model.cpp:198
            population[start]->parameters[i] = left_parent? l_parent->parameters[i] : r_parent->parameters[i];
    9318:	e55b3025 	ldrb	r3, [fp, #-37]	; 0xffffffdb
    931c:	e3530000 	cmp	r3, #0
    9320:	0a000005 	beq	933c <_ZN5Model15Gene_Pool_PartyEPP9Tribesman+0x158>
/home/trefil/sem/sources/userspace/Model/Model.cpp:198 (discriminator 1)
    9324:	e51b2034 	ldr	r2, [fp, #-52]	; 0xffffffcc
    9328:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    932c:	e1a03103 	lsl	r3, r3, #2
    9330:	e0823003 	add	r3, r2, r3
    9334:	e5933000 	ldr	r3, [r3]
    9338:	ea000004 	b	9350 <_ZN5Model15Gene_Pool_PartyEPP9Tribesman+0x16c>
/home/trefil/sem/sources/userspace/Model/Model.cpp:198 (discriminator 2)
    933c:	e51b2038 	ldr	r2, [fp, #-56]	; 0xffffffc8
    9340:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9344:	e1a03103 	lsl	r3, r3, #2
    9348:	e0823003 	add	r3, r2, r3
    934c:	e5933000 	ldr	r3, [r3]
/home/trefil/sem/sources/userspace/Model/Model.cpp:198 (discriminator 4)
    9350:	e51b2010 	ldr	r2, [fp, #-16]
    9354:	e1a02102 	lsl	r2, r2, #2
    9358:	e51b1044 	ldr	r1, [fp, #-68]	; 0xffffffbc
    935c:	e0812002 	add	r2, r1, r2
    9360:	e5921000 	ldr	r1, [r2]
    9364:	e51b2018 	ldr	r2, [fp, #-24]	; 0xffffffe8
    9368:	e1a02102 	lsl	r2, r2, #2
    936c:	e0812002 	add	r2, r1, r2
    9370:	e5823000 	str	r3, [r2]
/home/trefil/sem/sources/userspace/Model/Model.cpp:197 (discriminator 4)
        for(int i = 0; i < cross_boundary; i++)
    9374:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9378:	e2833001 	add	r3, r3, #1
    937c:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
    9380:	eaffffe0 	b	9308 <_ZN5Model15Gene_Pool_PartyEPP9Tribesman+0x124>
/home/trefil/sem/sources/userspace/Model/Model.cpp:199
        for(int j = cross_boundary; j < PARAMETER_COUNT; j++)
    9384:	e51b3024 	ldr	r3, [fp, #-36]	; 0xffffffdc
    9388:	e50b301c 	str	r3, [fp, #-28]	; 0xffffffe4
/home/trefil/sem/sources/userspace/Model/Model.cpp:199 (discriminator 3)
    938c:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    9390:	e3530004 	cmp	r3, #4
    9394:	ca000011 	bgt	93e0 <_ZN5Model15Gene_Pool_PartyEPP9Tribesman+0x1fc>
/home/trefil/sem/sources/userspace/Model/Model.cpp:200 (discriminator 2)
            population[start]->parameters[j] = this->random->Get_Float();
    9398:	e51b3040 	ldr	r3, [fp, #-64]	; 0xffffffc0
    939c:	e593102c 	ldr	r1, [r3, #44]	; 0x2c
    93a0:	e51b3010 	ldr	r3, [fp, #-16]
    93a4:	e1a03103 	lsl	r3, r3, #2
    93a8:	e51b2044 	ldr	r2, [fp, #-68]	; 0xffffffbc
    93ac:	e0823003 	add	r3, r2, r3
    93b0:	e5934000 	ldr	r4, [r3]
    93b4:	e1a00001 	mov	r0, r1
    93b8:	eb000342 	bl	a0c8 <_ZN16Random_Generator9Get_FloatEv>
    93bc:	eef07a40 	vmov.f32	s15, s0
    93c0:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    93c4:	e1a03103 	lsl	r3, r3, #2
    93c8:	e0843003 	add	r3, r4, r3
    93cc:	edc37a00 	vstr	s15, [r3]
/home/trefil/sem/sources/userspace/Model/Model.cpp:199 (discriminator 2)
        for(int j = cross_boundary; j < PARAMETER_COUNT; j++)
    93d0:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    93d4:	e2833001 	add	r3, r3, #1
    93d8:	e50b301c 	str	r3, [fp, #-28]	; 0xffffffe4
    93dc:	eaffffea 	b	938c <_ZN5Model15Gene_Pool_PartyEPP9Tribesman+0x1a8>
/home/trefil/sem/sources/userspace/Model/Model.cpp:201
        pointer += 2;
    93e0:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    93e4:	e2833002 	add	r3, r3, #2
    93e8:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/userspace/Model/Model.cpp:193
    for(start; start < party_stop ;start++){
    93ec:	e51b3010 	ldr	r3, [fp, #-16]
    93f0:	e2833001 	add	r3, r3, #1
    93f4:	e50b3010 	str	r3, [fp, #-16]
    93f8:	eaffffaf 	b	92bc <_ZN5Model15Gene_Pool_PartyEPP9Tribesman+0xd8>
/home/trefil/sem/sources/userspace/Model/Model.cpp:204 (discriminator 1)
    }
    //vytvor random nove cleny populace
    for(start; start < new_pop_count; start++){
    93fc:	e51b2010 	ldr	r2, [fp, #-16]
    9400:	e51b302c 	ldr	r3, [fp, #-44]	; 0xffffffd4
    9404:	e1520003 	cmp	r2, r3
    9408:	aa00001c 	bge	9480 <_ZN5Model15Gene_Pool_PartyEPP9Tribesman+0x29c>
/home/trefil/sem/sources/userspace/Model/Model.cpp:205
        Tribesman* new_tribesman = population[start];
    940c:	e51b3010 	ldr	r3, [fp, #-16]
    9410:	e1a03103 	lsl	r3, r3, #2
    9414:	e51b2044 	ldr	r2, [fp, #-68]	; 0xffffffbc
    9418:	e0823003 	add	r3, r2, r3
    941c:	e5933000 	ldr	r3, [r3]
    9420:	e50b303c 	str	r3, [fp, #-60]	; 0xffffffc4
/home/trefil/sem/sources/userspace/Model/Model.cpp:207
        //vytvor "nove" cleny populace
        for(int i = 0; i < PARAMETER_COUNT; i++)
    9424:	e3a03000 	mov	r3, #0
    9428:	e50b3020 	str	r3, [fp, #-32]	; 0xffffffe0
/home/trefil/sem/sources/userspace/Model/Model.cpp:207 (discriminator 3)
    942c:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    9430:	e3530004 	cmp	r3, #4
    9434:	ca00000d 	bgt	9470 <_ZN5Model15Gene_Pool_PartyEPP9Tribesman+0x28c>
/home/trefil/sem/sources/userspace/Model/Model.cpp:208 (discriminator 2)
            new_tribesman->parameters[i] = random->Get_Float();
    9438:	e51b3040 	ldr	r3, [fp, #-64]	; 0xffffffc0
    943c:	e593302c 	ldr	r3, [r3, #44]	; 0x2c
    9440:	e1a00003 	mov	r0, r3
    9444:	eb00031f 	bl	a0c8 <_ZN16Random_Generator9Get_FloatEv>
    9448:	eef07a40 	vmov.f32	s15, s0
    944c:	e51b203c 	ldr	r2, [fp, #-60]	; 0xffffffc4
    9450:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    9454:	e1a03103 	lsl	r3, r3, #2
    9458:	e0823003 	add	r3, r2, r3
    945c:	edc37a00 	vstr	s15, [r3]
/home/trefil/sem/sources/userspace/Model/Model.cpp:207 (discriminator 2)
        for(int i = 0; i < PARAMETER_COUNT; i++)
    9460:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    9464:	e2833001 	add	r3, r3, #1
    9468:	e50b3020 	str	r3, [fp, #-32]	; 0xffffffe0
    946c:	eaffffee 	b	942c <_ZN5Model15Gene_Pool_PartyEPP9Tribesman+0x248>
/home/trefil/sem/sources/userspace/Model/Model.cpp:204
    for(start; start < new_pop_count; start++){
    9470:	e51b3010 	ldr	r3, [fp, #-16]
    9474:	e2833001 	add	r3, r3, #1
    9478:	e50b3010 	str	r3, [fp, #-16]
    947c:	eaffffde 	b	93fc <_ZN5Model15Gene_Pool_PartyEPP9Tribesman+0x218>
/home/trefil/sem/sources/userspace/Model/Model.cpp:213

    }


}
    9480:	e320f000 	nop	{0}
    9484:	e24bd008 	sub	sp, fp, #8
    9488:	e8bd8810 	pop	{r4, fp, pc}
    948c:	e320f000 	nop	{0}
    9490:	9999999a 	ldmibls	r9, {r1, r3, r4, r7, r8, fp, ip, pc}
    9494:	3fc99999 	svccc	0x00c99999
    9498:	66666667 	strbtvs	r6, [r6], -r7, ror #12

0000949c <_ZN5Model19Eval_String_CommandEPKc>:
_ZN5Model19Eval_String_CommandEPKc():
/home/trefil/sem/sources/userspace/Model/Model.cpp:214
void Model::Eval_String_Command(const char *str){
    949c:	e92d4800 	push	{fp, lr}
    94a0:	e28db004 	add	fp, sp, #4
    94a4:	e24dd008 	sub	sp, sp, #8
    94a8:	e50b0008 	str	r0, [fp, #-8]
    94ac:	e50b100c 	str	r1, [fp, #-12]
/home/trefil/sem/sources/userspace/Model/Model.cpp:215
    if(!strncmp("parameters",str,strlen("parameters"))){
    94b0:	e59f00c4 	ldr	r0, [pc, #196]	; 957c <_ZN5Model19Eval_String_CommandEPKc+0xe0>
    94b4:	eb0006bc 	bl	afac <_Z6strlenPKc>
    94b8:	e1a03000 	mov	r3, r0
    94bc:	e1a02003 	mov	r2, r3
    94c0:	e51b100c 	ldr	r1, [fp, #-12]
    94c4:	e59f00b0 	ldr	r0, [pc, #176]	; 957c <_ZN5Model19Eval_String_CommandEPKc+0xe0>
    94c8:	eb00068c 	bl	af00 <_Z7strncmpPKcS0_i>
    94cc:	e1a03000 	mov	r3, r0
    94d0:	e3530000 	cmp	r3, #0
    94d4:	03a03001 	moveq	r3, #1
    94d8:	13a03000 	movne	r3, #0
    94dc:	e6ef3073 	uxtb	r3, r3
    94e0:	e3530000 	cmp	r3, #0
    94e4:	0a000004 	beq	94fc <_ZN5Model19Eval_String_CommandEPKc+0x60>
/home/trefil/sem/sources/userspace/Model/Model.cpp:216
        Print_Parameters();
    94e8:	e51b0008 	ldr	r0, [fp, #-8]
    94ec:	ebfffe06 	bl	8d0c <_ZN5Model16Print_ParametersEv>
/home/trefil/sem/sources/userspace/Model/Model.cpp:217
        Prompt_User();
    94f0:	e51b0008 	ldr	r0, [fp, #-8]
    94f4:	eb0000ce 	bl	9834 <_ZN5Model11Prompt_UserEv>
/home/trefil/sem/sources/userspace/Model/Model.cpp:218
        return;
    94f8:	ea00001d 	b	9574 <_ZN5Model19Eval_String_CommandEPKc+0xd8>
/home/trefil/sem/sources/userspace/Model/Model.cpp:220
    }
    else if(!strncmp("stop",str,strlen("stop"))){
    94fc:	e59f007c 	ldr	r0, [pc, #124]	; 9580 <_ZN5Model19Eval_String_CommandEPKc+0xe4>
    9500:	eb0006a9 	bl	afac <_Z6strlenPKc>
    9504:	e1a03000 	mov	r3, r0
    9508:	e1a02003 	mov	r2, r3
    950c:	e51b100c 	ldr	r1, [fp, #-12]
    9510:	e59f0068 	ldr	r0, [pc, #104]	; 9580 <_ZN5Model19Eval_String_CommandEPKc+0xe4>
    9514:	eb000679 	bl	af00 <_Z7strncmpPKcS0_i>
    9518:	e1a03000 	mov	r3, r0
    951c:	e3530000 	cmp	r3, #0
    9520:	03a03001 	moveq	r3, #1
    9524:	13a03000 	movne	r3, #0
    9528:	e6ef3073 	uxtb	r3, r3
    952c:	e3530000 	cmp	r3, #0
    9530:	0a000008 	beq	9558 <_ZN5Model19Eval_String_CommandEPKc+0xbc>
/home/trefil/sem/sources/userspace/Model/Model.cpp:221
        this->bfr->Write_Line("Zastavuji vypocet\n");
    9534:	e51b3008 	ldr	r3, [fp, #-8]
    9538:	e5933030 	ldr	r3, [r3, #48]	; 0x30
    953c:	e59f1040 	ldr	r1, [pc, #64]	; 9584 <_ZN5Model19Eval_String_CommandEPKc+0xe8>
    9540:	e1a00003 	mov	r0, r3
    9544:	eb000349 	bl	a270 <_ZN6Buffer10Write_LineEPKc>
/home/trefil/sem/sources/userspace/Model/Model.cpp:222
        is_fitting = false;
    9548:	e51b3008 	ldr	r3, [fp, #-8]
    954c:	e3a02000 	mov	r2, #0
    9550:	e5c32018 	strb	r2, [r3, #24]
/home/trefil/sem/sources/userspace/Model/Model.cpp:223
        return;
    9554:	ea000006 	b	9574 <_ZN5Model19Eval_String_CommandEPKc+0xd8>
/home/trefil/sem/sources/userspace/Model/Model.cpp:226
    }
    else
        this->bfr->Write_Line("Neznamy prikaz\n");
    9558:	e51b3008 	ldr	r3, [fp, #-8]
    955c:	e5933030 	ldr	r3, [r3, #48]	; 0x30
    9560:	e59f1020 	ldr	r1, [pc, #32]	; 9588 <_ZN5Model19Eval_String_CommandEPKc+0xec>
    9564:	e1a00003 	mov	r0, r3
    9568:	eb000340 	bl	a270 <_ZN6Buffer10Write_LineEPKc>
/home/trefil/sem/sources/userspace/Model/Model.cpp:227
    Prompt_User();
    956c:	e51b0008 	ldr	r0, [fp, #-8]
    9570:	eb0000af 	bl	9834 <_ZN5Model11Prompt_UserEv>
/home/trefil/sem/sources/userspace/Model/Model.cpp:230


}
    9574:	e24bd004 	sub	sp, fp, #4
    9578:	e8bd8800 	pop	{fp, pc}
    957c:	0000c1e4 	andeq	ip, r0, r4, ror #3
    9580:	0000c1f0 	strdeq	ip, [r0], -r0
    9584:	0000c1f8 	strdeq	ip, [r0], -r8
    9588:	0000c20c 	andeq	ip, r0, ip, lsl #4

0000958c <_ZN5Model23Print_Alpha_PredictionsEv>:
_ZN5Model23Print_Alpha_PredictionsEv():
/home/trefil/sem/sources/userspace/Model/Model.cpp:231
void Model::Print_Alpha_Predictions(){
    958c:	e92d4800 	push	{fp, lr}
    9590:	e28db004 	add	fp, sp, #4
    9594:	e24dd028 	sub	sp, sp, #40	; 0x28
    9598:	e50b0028 	str	r0, [fp, #-40]	; 0xffffffd8
/home/trefil/sem/sources/userspace/Model/Model.cpp:232
    Tribesman* t = alpha;
    959c:	e51b3028 	ldr	r3, [fp, #-40]	; 0xffffffd8
    95a0:	e5933028 	ldr	r3, [r3, #40]	; 0x28
    95a4:	e50b300c 	str	r3, [fp, #-12]
/home/trefil/sem/sources/userspace/Model/Model.cpp:234
    char bfr2[20];
    for(int i = 0; i < data_pointer; i++){
    95a8:	e3a03000 	mov	r3, #0
    95ac:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/userspace/Model/Model.cpp:234 (discriminator 3)
    95b0:	e51b3028 	ldr	r3, [fp, #-40]	; 0xffffffd8
    95b4:	e593301c 	ldr	r3, [r3, #28]
    95b8:	e51b2008 	ldr	r2, [fp, #-8]
    95bc:	e1520003 	cmp	r2, r3
    95c0:	aa000019 	bge	962c <_ZN5Model23Print_Alpha_PredictionsEv+0xa0>
/home/trefil/sem/sources/userspace/Model/Model.cpp:235 (discriminator 2)
        float f = t->predicted_values[i];
    95c4:	e51b300c 	ldr	r3, [fp, #-12]
    95c8:	e5932018 	ldr	r2, [r3, #24]
    95cc:	e51b3008 	ldr	r3, [fp, #-8]
    95d0:	e1a03103 	lsl	r3, r3, #2
    95d4:	e0823003 	add	r3, r2, r3
    95d8:	e5933000 	ldr	r3, [r3]
    95dc:	e50b3010 	str	r3, [fp, #-16]
/home/trefil/sem/sources/userspace/Model/Model.cpp:236 (discriminator 2)
        ftoa(f,bfr2);
    95e0:	e24b3024 	sub	r3, fp, #36	; 0x24
    95e4:	e1a00003 	mov	r0, r3
    95e8:	ed1b0a04 	vldr	s0, [fp, #-16]
    95ec:	eb000738 	bl	b2d4 <_Z4ftoafPc>
/home/trefil/sem/sources/userspace/Model/Model.cpp:237 (discriminator 2)
        this->bfr->Write_Line(bfr2);
    95f0:	e51b3028 	ldr	r3, [fp, #-40]	; 0xffffffd8
    95f4:	e5933030 	ldr	r3, [r3, #48]	; 0x30
    95f8:	e24b2024 	sub	r2, fp, #36	; 0x24
    95fc:	e1a01002 	mov	r1, r2
    9600:	e1a00003 	mov	r0, r3
    9604:	eb000319 	bl	a270 <_ZN6Buffer10Write_LineEPKc>
/home/trefil/sem/sources/userspace/Model/Model.cpp:238 (discriminator 2)
        this->bfr->Write_Line("\n");
    9608:	e51b3028 	ldr	r3, [fp, #-40]	; 0xffffffd8
    960c:	e5933030 	ldr	r3, [r3, #48]	; 0x30
    9610:	e59f1020 	ldr	r1, [pc, #32]	; 9638 <_ZN5Model23Print_Alpha_PredictionsEv+0xac>
    9614:	e1a00003 	mov	r0, r3
    9618:	eb000314 	bl	a270 <_ZN6Buffer10Write_LineEPKc>
/home/trefil/sem/sources/userspace/Model/Model.cpp:234 (discriminator 2)
    for(int i = 0; i < data_pointer; i++){
    961c:	e51b3008 	ldr	r3, [fp, #-8]
    9620:	e2833001 	add	r3, r3, #1
    9624:	e50b3008 	str	r3, [fp, #-8]
    9628:	eaffffe0 	b	95b0 <_ZN5Model23Print_Alpha_PredictionsEv+0x24>
/home/trefil/sem/sources/userspace/Model/Model.cpp:241

    }
};
    962c:	e320f000 	nop	{0}
    9630:	e24bd004 	sub	sp, fp, #4
    9634:	e8bd8800 	pop	{fp, pc}
    9638:	0000c1c4 	andeq	ip, r0, r4, asr #3

0000963c <_ZN5Model10CheckpointEv>:
_ZN5Model10CheckpointEv():
/home/trefil/sem/sources/userspace/Model/Model.cpp:243

void Model::Checkpoint(){
    963c:	e92d4800 	push	{fp, lr}
    9640:	e28db004 	add	fp, sp, #4
    9644:	e24dd018 	sub	sp, sp, #24
    9648:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/userspace/Model/Model.cpp:244
    char* line = this->bfr->Read_Uart_Line();
    964c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9650:	e5933030 	ldr	r3, [r3, #48]	; 0x30
    9654:	e1a00003 	mov	r0, r3
    9658:	eb000315 	bl	a2b4 <_ZN6Buffer14Read_Uart_LineEv>
    965c:	e50b0008 	str	r0, [fp, #-8]
/home/trefil/sem/sources/userspace/Model/Model.cpp:246
    //nic jsem neprecetl
    if(line == nullptr)return;
    9660:	e51b3008 	ldr	r3, [fp, #-8]
    9664:	e3530000 	cmp	r3, #0
    9668:	0a000038 	beq	9750 <_ZN5Model10CheckpointEv+0x114>
/home/trefil/sem/sources/userspace/Model/Model.cpp:248
    //kouknu se, co jsem precetl
    int type = get_input_type(line);
    966c:	e51b0008 	ldr	r0, [fp, #-8]
    9670:	eb00055b 	bl	abe4 <_Z14get_input_typePKc>
    9674:	e50b000c 	str	r0, [fp, #-12]
/home/trefil/sem/sources/userspace/Model/Model.cpp:251
    float f;
    int i;
    switch (type) {
    9678:	e51b300c 	ldr	r3, [fp, #-12]
    967c:	e3530002 	cmp	r3, #2
    9680:	0a00000d 	beq	96bc <_ZN5Model10CheckpointEv+0x80>
    9684:	e51b300c 	ldr	r3, [fp, #-12]
    9688:	e3530002 	cmp	r3, #2
    968c:	ca000027 	bgt	9730 <_ZN5Model10CheckpointEv+0xf4>
    9690:	e51b300c 	ldr	r3, [fp, #-12]
    9694:	e3530000 	cmp	r3, #0
    9698:	0a000003 	beq	96ac <_ZN5Model10CheckpointEv+0x70>
    969c:	e51b300c 	ldr	r3, [fp, #-12]
    96a0:	e3530001 	cmp	r3, #1
    96a4:	0a000011 	beq	96f0 <_ZN5Model10CheckpointEv+0xb4>
    96a8:	ea000020 	b	9730 <_ZN5Model10CheckpointEv+0xf4>
/home/trefil/sem/sources/userspace/Model/Model.cpp:254
        //nejaky prikaz od uzivatele
        case STRING_INPUT:
            Eval_String_Command(line);
    96ac:	e51b1008 	ldr	r1, [fp, #-8]
    96b0:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    96b4:	ebffff78 	bl	949c <_ZN5Model19Eval_String_CommandEPKc>
/home/trefil/sem/sources/userspace/Model/Model.cpp:255
            break;
    96b8:	ea000029 	b	9764 <_ZN5Model10CheckpointEv+0x128>
/home/trefil/sem/sources/userspace/Model/Model.cpp:258
        //data na vstupu
        case FLOAT_INPUT:
            f = atof(line);
    96bc:	e51b0008 	ldr	r0, [fp, #-8]
    96c0:	eb000587 	bl	ace4 <_Z4atofPKc>
    96c4:	ed0b0a04 	vstr	s0, [fp, #-16]
/home/trefil/sem/sources/userspace/Model/Model.cpp:259
            if(Add_Data_Sample(f))
    96c8:	ed1b0a04 	vldr	s0, [fp, #-16]
    96cc:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    96d0:	ebfffe92 	bl	9120 <_ZN5Model15Add_Data_SampleEf>
    96d4:	e1a03000 	mov	r3, r0
    96d8:	e3530000 	cmp	r3, #0
    96dc:	0a00001d 	beq	9758 <_ZN5Model10CheckpointEv+0x11c>
/home/trefil/sem/sources/userspace/Model/Model.cpp:260
               is_fitting = true;
    96e0:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    96e4:	e3a02001 	mov	r2, #1
    96e8:	e5c32018 	strb	r2, [r3, #24]
/home/trefil/sem/sources/userspace/Model/Model.cpp:261
            return;
    96ec:	ea000019 	b	9758 <_ZN5Model10CheckpointEv+0x11c>
/home/trefil/sem/sources/userspace/Model/Model.cpp:263
        case INT_INPUT:
            i  = atoi(line);
    96f0:	e51b0008 	ldr	r0, [fp, #-8]
    96f4:	eb000507 	bl	ab18 <_Z4atoiPKc>
    96f8:	e50b0014 	str	r0, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/userspace/Model/Model.cpp:264
            if(Add_Data_Sample(static_cast<float>(i)))
    96fc:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9700:	ee073a90 	vmov	s15, r3
    9704:	eef87ae7 	vcvt.f32.s32	s15, s15
    9708:	eeb00a67 	vmov.f32	s0, s15
    970c:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    9710:	ebfffe82 	bl	9120 <_ZN5Model15Add_Data_SampleEf>
    9714:	e1a03000 	mov	r3, r0
    9718:	e3530000 	cmp	r3, #0
    971c:	0a00000f 	beq	9760 <_ZN5Model10CheckpointEv+0x124>
/home/trefil/sem/sources/userspace/Model/Model.cpp:265
                is_fitting = true;
    9720:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9724:	e3a02001 	mov	r2, #1
    9728:	e5c32018 	strb	r2, [r3, #24]
/home/trefil/sem/sources/userspace/Model/Model.cpp:266
            return;
    972c:	ea00000b 	b	9760 <_ZN5Model10CheckpointEv+0x124>
/home/trefil/sem/sources/userspace/Model/Model.cpp:268
        default:
            bfr->Write_Line("Ocekavam kladne cislo \n");
    9730:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9734:	e5933030 	ldr	r3, [r3, #48]	; 0x30
    9738:	e59f102c 	ldr	r1, [pc, #44]	; 976c <_ZN5Model10CheckpointEv+0x130>
    973c:	e1a00003 	mov	r0, r3
    9740:	eb0002ca 	bl	a270 <_ZN6Buffer10Write_LineEPKc>
/home/trefil/sem/sources/userspace/Model/Model.cpp:269
            Prompt_User();
    9744:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    9748:	eb000039 	bl	9834 <_ZN5Model11Prompt_UserEv>
/home/trefil/sem/sources/userspace/Model/Model.cpp:270
            break;
    974c:	ea000004 	b	9764 <_ZN5Model10CheckpointEv+0x128>
/home/trefil/sem/sources/userspace/Model/Model.cpp:246
    if(line == nullptr)return;
    9750:	e320f000 	nop	{0}
    9754:	ea000002 	b	9764 <_ZN5Model10CheckpointEv+0x128>
/home/trefil/sem/sources/userspace/Model/Model.cpp:261
            return;
    9758:	e320f000 	nop	{0}
    975c:	ea000000 	b	9764 <_ZN5Model10CheckpointEv+0x128>
/home/trefil/sem/sources/userspace/Model/Model.cpp:266
            return;
    9760:	e320f000 	nop	{0}
/home/trefil/sem/sources/userspace/Model/Model.cpp:272
    }
}
    9764:	e24bd004 	sub	sp, fp, #4
    9768:	e8bd8800 	pop	{fp, pc}
    976c:	0000c21c 	andeq	ip, r0, ip, lsl r2

00009770 <_ZN5Model8MutationEPP9Tribesman>:
_ZN5Model8MutationEPP9Tribesman():
/home/trefil/sem/sources/userspace/Model/Model.cpp:274

void Model::Mutation(Tribesman** population){
    9770:	e92d4810 	push	{r4, fp, lr}
    9774:	e28db008 	add	fp, sp, #8
    9778:	e24dd014 	sub	sp, sp, #20
    977c:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    9780:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
/home/trefil/sem/sources/userspace/Model/Model.cpp:275
    int parameter_to_mutate = random->Get_Int() % PARAMETER_COUNT;
    9784:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9788:	e593302c 	ldr	r3, [r3, #44]	; 0x2c
    978c:	e1a00003 	mov	r0, r3
    9790:	eb000228 	bl	a038 <_ZN16Random_Generator7Get_IntEv>
    9794:	e1a02000 	mov	r2, r0
    9798:	e59f3090 	ldr	r3, [pc, #144]	; 9830 <_ZN5Model8MutationEPP9Tribesman+0xc0>
    979c:	e0c31293 	smull	r1, r3, r3, r2
    97a0:	e1a010c3 	asr	r1, r3, #1
    97a4:	e1a03fc2 	asr	r3, r2, #31
    97a8:	e0411003 	sub	r1, r1, r3
    97ac:	e1a03001 	mov	r3, r1
    97b0:	e1a03103 	lsl	r3, r3, #2
    97b4:	e0833001 	add	r3, r3, r1
    97b8:	e0423003 	sub	r3, r2, r3
    97bc:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/userspace/Model/Model.cpp:276
    for(int i = 0; i < population_count; i++)
    97c0:	e3a03000 	mov	r3, #0
    97c4:	e50b3010 	str	r3, [fp, #-16]
/home/trefil/sem/sources/userspace/Model/Model.cpp:276 (discriminator 3)
    97c8:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    97cc:	e5933014 	ldr	r3, [r3, #20]
    97d0:	e51b2010 	ldr	r2, [fp, #-16]
    97d4:	e1520003 	cmp	r2, r3
    97d8:	aa000011 	bge	9824 <_ZN5Model8MutationEPP9Tribesman+0xb4>
/home/trefil/sem/sources/userspace/Model/Model.cpp:277 (discriminator 2)
        population[i]->parameters[parameter_to_mutate] = random->Get_Float();
    97dc:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    97e0:	e593102c 	ldr	r1, [r3, #44]	; 0x2c
    97e4:	e51b3010 	ldr	r3, [fp, #-16]
    97e8:	e1a03103 	lsl	r3, r3, #2
    97ec:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    97f0:	e0823003 	add	r3, r2, r3
    97f4:	e5934000 	ldr	r4, [r3]
    97f8:	e1a00001 	mov	r0, r1
    97fc:	eb000231 	bl	a0c8 <_ZN16Random_Generator9Get_FloatEv>
    9800:	eef07a40 	vmov.f32	s15, s0
    9804:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9808:	e1a03103 	lsl	r3, r3, #2
    980c:	e0843003 	add	r3, r4, r3
    9810:	edc37a00 	vstr	s15, [r3]
/home/trefil/sem/sources/userspace/Model/Model.cpp:276 (discriminator 2)
    for(int i = 0; i < population_count; i++)
    9814:	e51b3010 	ldr	r3, [fp, #-16]
    9818:	e2833001 	add	r3, r3, #1
    981c:	e50b3010 	str	r3, [fp, #-16]
    9820:	eaffffe8 	b	97c8 <_ZN5Model8MutationEPP9Tribesman+0x58>
/home/trefil/sem/sources/userspace/Model/Model.cpp:279

}
    9824:	e320f000 	nop	{0}
    9828:	e24bd008 	sub	sp, fp, #8
    982c:	e8bd8810 	pop	{r4, fp, pc}
    9830:	66666667 	strbtvs	r6, [r6], -r7, ror #12

00009834 <_ZN5Model11Prompt_UserEv>:
_ZN5Model11Prompt_UserEv():
/home/trefil/sem/sources/userspace/Model/Model.cpp:281
//vizualni pobidnuti uzivatele k zadani vstupu
void Model::Prompt_User(){
    9834:	e92d4800 	push	{fp, lr}
    9838:	e28db004 	add	fp, sp, #4
    983c:	e24dd008 	sub	sp, sp, #8
    9840:	e50b0008 	str	r0, [fp, #-8]
/home/trefil/sem/sources/userspace/Model/Model.cpp:282
    this->bfr->Write_Line(">");
    9844:	e51b3008 	ldr	r3, [fp, #-8]
    9848:	e5933030 	ldr	r3, [r3, #48]	; 0x30
    984c:	e59f1010 	ldr	r1, [pc, #16]	; 9864 <_ZN5Model11Prompt_UserEv+0x30>
    9850:	e1a00003 	mov	r0, r3
    9854:	eb000285 	bl	a270 <_ZN6Buffer10Write_LineEPKc>
/home/trefil/sem/sources/userspace/Model/Model.cpp:283
}
    9858:	e320f000 	nop	{0}
    985c:	e24bd004 	sub	sp, fp, #4
    9860:	e8bd8800 	pop	{fp, pc}
    9864:	0000c234 	andeq	ip, r0, r4, lsr r2

00009868 <_ZN5Model3RunEv>:
_ZN5Model3RunEv():
/home/trefil/sem/sources/userspace/Model/Model.cpp:286

//main loop of the task
void Model::Run(){
    9868:	e92d4800 	push	{fp, lr}
    986c:	e28db004 	add	fp, sp, #4
    9870:	e24dd038 	sub	sp, sp, #56	; 0x38
    9874:	e50b0038 	str	r0, [fp, #-56]	; 0xffffffc8
/home/trefil/sem/sources/userspace/Model/Model.cpp:290
    char float_buffer[20];
    //main loop of the program
    while(1){
        Prompt_User();
    9878:	e51b0038 	ldr	r0, [fp, #-56]	; 0xffffffc8
    987c:	ebffffec 	bl	9834 <_ZN5Model11Prompt_UserEv>
/home/trefil/sem/sources/userspace/Model/Model.cpp:292
        //pokud nefitim, tak spim a dotazuju se, jestli neco neni na uartu
        while(!is_fitting){
    9880:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    9884:	e5d33018 	ldrb	r3, [r3, #24]
    9888:	e3530000 	cmp	r3, #0
    988c:	1a000003 	bne	98a0 <_ZN5Model3RunEv+0x38>
/home/trefil/sem/sources/userspace/Model/Model.cpp:293
            asm volatile("wfi");
    9890:	e320f003 	wfi
/home/trefil/sem/sources/userspace/Model/Model.cpp:294
            Checkpoint();
    9894:	e51b0038 	ldr	r0, [fp, #-56]	; 0xffffffc8
    9898:	ebffff67 	bl	963c <_ZN5Model10CheckpointEv>
/home/trefil/sem/sources/userspace/Model/Model.cpp:292
        while(!is_fitting){
    989c:	eafffff7 	b	9880 <_ZN5Model3RunEv+0x18>
/home/trefil/sem/sources/userspace/Model/Model.cpp:296
        }
        bool not_enough_data = false;
    98a0:	e3a03000 	mov	r3, #0
    98a4:	e54b3005 	strb	r3, [fp, #-5]
/home/trefil/sem/sources/userspace/Model/Model.cpp:297
        bfr->Write_Line("Pocitam...\n");
    98a8:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    98ac:	e5933030 	ldr	r3, [r3, #48]	; 0x30
    98b0:	e59f1280 	ldr	r1, [pc, #640]	; 9b38 <_ZN5Model3RunEv+0x2d0>
    98b4:	e1a00003 	mov	r0, r3
    98b8:	eb00026c 	bl	a270 <_ZN6Buffer10Write_LineEPKc>
/home/trefil/sem/sources/userspace/Model/Model.cpp:299
        //let pres vsechny epochy
        for(int i = 0; i < epoch_count; i++){
    98bc:	e3a03000 	mov	r3, #0
    98c0:	e50b300c 	str	r3, [fp, #-12]
/home/trefil/sem/sources/userspace/Model/Model.cpp:299 (discriminator 1)
    98c4:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    98c8:	e5933020 	ldr	r3, [r3, #32]
    98cc:	e51b200c 	ldr	r2, [fp, #-12]
    98d0:	e1520003 	cmp	r2, r3
    98d4:	aa00006c 	bge	9a8c <_ZN5Model3RunEv+0x224>
/home/trefil/sem/sources/userspace/Model/Model.cpp:301
            //kontroluji, jestli neprisel stop prikaz, pokud jo, zastavuji vypocet
            if(!is_fitting)break;
    98d8:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    98dc:	e5d33018 	ldrb	r3, [r3, #24]
    98e0:	e2233001 	eor	r3, r3, #1
    98e4:	e6ef3073 	uxtb	r3, r3
    98e8:	e3530000 	cmp	r3, #0
    98ec:	1a000063 	bne	9a80 <_ZN5Model3RunEv+0x218>
/home/trefil/sem/sources/userspace/Model/Model.cpp:302
            for(int i = 0; i < population_count; i++){
    98f0:	e3a03000 	mov	r3, #0
    98f4:	e50b3010 	str	r3, [fp, #-16]
/home/trefil/sem/sources/userspace/Model/Model.cpp:302 (discriminator 1)
    98f8:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    98fc:	e5933014 	ldr	r3, [r3, #20]
    9900:	e51b2010 	ldr	r2, [fp, #-16]
    9904:	e1520003 	cmp	r2, r3
    9908:	aa000030 	bge	99d0 <_ZN5Model3RunEv+0x168>
/home/trefil/sem/sources/userspace/Model/Model.cpp:304
                //predikuj
                Predict(population[i]);
    990c:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    9910:	e5932024 	ldr	r2, [r3, #36]	; 0x24
    9914:	e51b3010 	ldr	r3, [fp, #-16]
    9918:	e1a03103 	lsl	r3, r3, #2
    991c:	e0823003 	add	r3, r2, r3
    9920:	e5933000 	ldr	r3, [r3]
    9924:	e1a01003 	mov	r1, r3
    9928:	e51b0038 	ldr	r0, [fp, #-56]	; 0xffffffc8
    992c:	ebfffbfe 	bl	892c <_ZN5Model7PredictEP9Tribesman>
/home/trefil/sem/sources/userspace/Model/Model.cpp:306
                //ohodnot spravnost reseni
                float f = Calculate_Fitness(population[i]);
    9930:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    9934:	e5932024 	ldr	r2, [r3, #36]	; 0x24
    9938:	e51b3010 	ldr	r3, [fp, #-16]
    993c:	e1a03103 	lsl	r3, r3, #2
    9940:	e0823003 	add	r3, r2, r3
    9944:	e5933000 	ldr	r3, [r3]
    9948:	e1a01003 	mov	r1, r3
    994c:	e51b0038 	ldr	r0, [fp, #-56]	; 0xffffffc8
    9950:	ebfffc1a 	bl	89c0 <_ZN5Model17Calculate_FitnessEP9Tribesman>
    9954:	ed0b0a06 	vstr	s0, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/userspace/Model/Model.cpp:307
                if(f == EMPTY){
    9958:	ed5b7a06 	vldr	s15, [fp, #-24]	; 0xffffffe8
    995c:	ed9f7a74 	vldr	s14, [pc, #464]	; 9b34 <_ZN5Model3RunEv+0x2cc>
    9960:	eef47a47 	vcmp.f32	s15, s14
    9964:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    9968:	1a00000a 	bne	9998 <_ZN5Model3RunEv+0x130>
/home/trefil/sem/sources/userspace/Model/Model.cpp:309
                    //jeste nemam dost dat pro ohodnoceni, utecu
                    bfr->Write_Line("NaN\n");
    996c:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    9970:	e5933030 	ldr	r3, [r3, #48]	; 0x30
    9974:	e59f11c0 	ldr	r1, [pc, #448]	; 9b3c <_ZN5Model3RunEv+0x2d4>
    9978:	e1a00003 	mov	r0, r3
    997c:	eb00023b 	bl	a270 <_ZN6Buffer10Write_LineEPKc>
/home/trefil/sem/sources/userspace/Model/Model.cpp:311
                    //nastavim priznak, ze nemam dost dat -> nema smysl cokoliv jineho delat
                    not_enough_data = true;
    9980:	e3a03001 	mov	r3, #1
    9984:	e54b3005 	strb	r3, [fp, #-5]
/home/trefil/sem/sources/userspace/Model/Model.cpp:312
                    is_fitting = false;
    9988:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    998c:	e3a02000 	mov	r2, #0
    9990:	e5c32018 	strb	r2, [r3, #24]
/home/trefil/sem/sources/userspace/Model/Model.cpp:313
                    break;
    9994:	ea00000d 	b	99d0 <_ZN5Model3RunEv+0x168>
/home/trefil/sem/sources/userspace/Model/Model.cpp:315 (discriminator 2)
                }
                population[i]->fitness = f;
    9998:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    999c:	e5932024 	ldr	r2, [r3, #36]	; 0x24
    99a0:	e51b3010 	ldr	r3, [fp, #-16]
    99a4:	e1a03103 	lsl	r3, r3, #2
    99a8:	e0823003 	add	r3, r2, r3
    99ac:	e5933000 	ldr	r3, [r3]
    99b0:	e51b2018 	ldr	r2, [fp, #-24]	; 0xffffffe8
    99b4:	e5832014 	str	r2, [r3, #20]
/home/trefil/sem/sources/userspace/Model/Model.cpp:316 (discriminator 2)
                Checkpoint();
    99b8:	e51b0038 	ldr	r0, [fp, #-56]	; 0xffffffc8
    99bc:	ebffff1e 	bl	963c <_ZN5Model10CheckpointEv>
/home/trefil/sem/sources/userspace/Model/Model.cpp:302 (discriminator 2)
            for(int i = 0; i < population_count; i++){
    99c0:	e51b3010 	ldr	r3, [fp, #-16]
    99c4:	e2833001 	add	r3, r3, #1
    99c8:	e50b3010 	str	r3, [fp, #-16]
    99cc:	eaffffc9 	b	98f8 <_ZN5Model3RunEv+0x90>
/home/trefil/sem/sources/userspace/Model/Model.cpp:318
            }
            if(not_enough_data)break;
    99d0:	e55b3005 	ldrb	r3, [fp, #-5]
    99d4:	e3530000 	cmp	r3, #0
    99d8:	1a00002a 	bne	9a88 <_ZN5Model3RunEv+0x220>
/home/trefil/sem/sources/userspace/Model/Model.cpp:321

        //serad od nejlepsich po nejhorsi
            Sort_Tribesman(population,population_count);
    99dc:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    99e0:	e5932024 	ldr	r2, [r3, #36]	; 0x24
    99e4:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    99e8:	e5933014 	ldr	r3, [r3, #20]
    99ec:	e1a01003 	mov	r1, r3
    99f0:	e1a00002 	mov	r0, r2
    99f4:	eb0000ed 	bl	9db0 <_Z14Sort_TribesmanPP9Tribesmani>
/home/trefil/sem/sources/userspace/Model/Model.cpp:324
            //nejlepsiho aktualni populace nastav jako alpha samce

        Set_Alpha(population[0]);
    99f8:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    99fc:	e5933024 	ldr	r3, [r3, #36]	; 0x24
    9a00:	e5933000 	ldr	r3, [r3]
    9a04:	e1a01003 	mov	r1, r3
    9a08:	e51b0038 	ldr	r0, [fp, #-56]	; 0xffffffc8
    9a0c:	ebfffc84 	bl	8c24 <_ZN5Model9Set_AlphaEP9Tribesman>
/home/trefil/sem/sources/userspace/Model/Model.cpp:329
            //minimalni chyba -- perfektne si to sedne
            //nebo je to dostatecne dobra aproximace
            //if(this->alpha->fitness == 0 || this->alpha->fitness < min_error)
              //  break;
            Checkpoint();
    9a10:	e51b0038 	ldr	r0, [fp, #-56]	; 0xffffffc8
    9a14:	ebffff08 	bl	963c <_ZN5Model10CheckpointEv>
/home/trefil/sem/sources/userspace/Model/Model.cpp:332
            //prekrizi nejsilnejsi

        Gene_Pool_Party(population);
    9a18:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    9a1c:	e5933024 	ldr	r3, [r3, #36]	; 0x24
    9a20:	e1a01003 	mov	r1, r3
    9a24:	e51b0038 	ldr	r0, [fp, #-56]	; 0xffffffc8
    9a28:	ebfffded 	bl	91e4 <_ZN5Model15Gene_Pool_PartyEPP9Tribesman>
/home/trefil/sem/sources/userspace/Model/Model.cpp:334
            //mutace
        Mutation(population);
    9a2c:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    9a30:	e5933024 	ldr	r3, [r3, #36]	; 0x24
    9a34:	e1a01003 	mov	r1, r3
    9a38:	e51b0038 	ldr	r0, [fp, #-56]	; 0xffffffc8
    9a3c:	ebffff4b 	bl	9770 <_ZN5Model8MutationEPP9Tribesman>
/home/trefil/sem/sources/userspace/Model/Model.cpp:335
        Checkpoint();
    9a40:	e51b0038 	ldr	r0, [fp, #-56]	; 0xffffffc8
    9a44:	ebfffefc 	bl	963c <_ZN5Model10CheckpointEv>
/home/trefil/sem/sources/userspace/Model/Model.cpp:337
        //spal nejake CPU cykly -> umyslne zpomaleni vypoctu pro test responzivity uart kanalu
        for(int i = 0; i < 0x88888 * 10;i++)
    9a48:	e3a03000 	mov	r3, #0
    9a4c:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/userspace/Model/Model.cpp:337 (discriminator 3)
    9a50:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9a54:	e59f20e4 	ldr	r2, [pc, #228]	; 9b40 <_ZN5Model3RunEv+0x2d8>
    9a58:	e1530002 	cmp	r3, r2
    9a5c:	ca000003 	bgt	9a70 <_ZN5Model3RunEv+0x208>
/home/trefil/sem/sources/userspace/Model/Model.cpp:337 (discriminator 2)
    9a60:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9a64:	e2833001 	add	r3, r3, #1
    9a68:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
    9a6c:	eafffff7 	b	9a50 <_ZN5Model3RunEv+0x1e8>
/home/trefil/sem/sources/userspace/Model/Model.cpp:299 (discriminator 2)
        for(int i = 0; i < epoch_count; i++){
    9a70:	e51b300c 	ldr	r3, [fp, #-12]
    9a74:	e2833001 	add	r3, r3, #1
    9a78:	e50b300c 	str	r3, [fp, #-12]
    9a7c:	eaffff90 	b	98c4 <_ZN5Model3RunEv+0x5c>
/home/trefil/sem/sources/userspace/Model/Model.cpp:301
            if(!is_fitting)break;
    9a80:	e320f000 	nop	{0}
    9a84:	ea000000 	b	9a8c <_ZN5Model3RunEv+0x224>
/home/trefil/sem/sources/userspace/Model/Model.cpp:318
            if(not_enough_data)break;
    9a88:	e320f000 	nop	{0}
/home/trefil/sem/sources/userspace/Model/Model.cpp:342
            ;
        }
        //pokud nemam data, neni co vypsat
        //pokud uzivatel zastavil vypocet, taky utec
        if(not_enough_data || !is_fitting)continue;
    9a8c:	e55b3005 	ldrb	r3, [fp, #-5]
    9a90:	e3530000 	cmp	r3, #0
    9a94:	1a000024 	bne	9b2c <_ZN5Model3RunEv+0x2c4>
/home/trefil/sem/sources/userspace/Model/Model.cpp:342 (discriminator 2)
    9a98:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    9a9c:	e5d33018 	ldrb	r3, [r3, #24]
    9aa0:	e2233001 	eor	r3, r3, #1
    9aa4:	e6ef3073 	uxtb	r3, r3
    9aa8:	e3530000 	cmp	r3, #0
    9aac:	1a00001e 	bne	9b2c <_ZN5Model3RunEv+0x2c4>
/home/trefil/sem/sources/userspace/Model/Model.cpp:345
        //posledni predicted hodnota je odpoved na vstup od uzivatele
        //Print_Alpha_Predictions();
        float predicted_value = this->alpha->predicted_values[data_pointer - 1];
    9ab0:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    9ab4:	e5933028 	ldr	r3, [r3, #40]	; 0x28
    9ab8:	e5932018 	ldr	r2, [r3, #24]
    9abc:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    9ac0:	e593301c 	ldr	r3, [r3, #28]
    9ac4:	e2433107 	sub	r3, r3, #-1073741823	; 0xc0000001
    9ac8:	e1a03103 	lsl	r3, r3, #2
    9acc:	e0823003 	add	r3, r2, r3
    9ad0:	e5933000 	ldr	r3, [r3]
    9ad4:	e50b301c 	str	r3, [fp, #-28]	; 0xffffffe4
/home/trefil/sem/sources/userspace/Model/Model.cpp:346
        ftoa(predicted_value,float_buffer);
    9ad8:	e24b3030 	sub	r3, fp, #48	; 0x30
    9adc:	e1a00003 	mov	r0, r3
    9ae0:	ed1b0a07 	vldr	s0, [fp, #-28]	; 0xffffffe4
    9ae4:	eb0005fa 	bl	b2d4 <_Z4ftoafPc>
/home/trefil/sem/sources/userspace/Model/Model.cpp:347
        this->bfr->Write_Line(float_buffer);
    9ae8:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    9aec:	e5933030 	ldr	r3, [r3, #48]	; 0x30
    9af0:	e24b2030 	sub	r2, fp, #48	; 0x30
    9af4:	e1a01002 	mov	r1, r2
    9af8:	e1a00003 	mov	r0, r3
    9afc:	eb0001db 	bl	a270 <_ZN6Buffer10Write_LineEPKc>
/home/trefil/sem/sources/userspace/Model/Model.cpp:348
        this->bfr->Write_Line("\n");
    9b00:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    9b04:	e5933030 	ldr	r3, [r3, #48]	; 0x30
    9b08:	e59f1034 	ldr	r1, [pc, #52]	; 9b44 <_ZN5Model3RunEv+0x2dc>
    9b0c:	e1a00003 	mov	r0, r3
    9b10:	eb0001d6 	bl	a270 <_ZN6Buffer10Write_LineEPKc>
/home/trefil/sem/sources/userspace/Model/Model.cpp:349
        float_buffer[0] = '\0';
    9b14:	e3a03000 	mov	r3, #0
    9b18:	e54b3030 	strb	r3, [fp, #-48]	; 0xffffffd0
/home/trefil/sem/sources/userspace/Model/Model.cpp:351
        //dopocital jsem, nastavim vlajecku
        is_fitting = false;
    9b1c:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    9b20:	e3a02000 	mov	r2, #0
    9b24:	e5c32018 	strb	r2, [r3, #24]
    9b28:	eaffff52 	b	9878 <_ZN5Model3RunEv+0x10>
/home/trefil/sem/sources/userspace/Model/Model.cpp:342
        if(not_enough_data || !is_fitting)continue;
    9b2c:	e320f000 	nop	{0}
/home/trefil/sem/sources/userspace/Model/Model.cpp:352
    }
    9b30:	eaffff50 	b	9878 <_ZN5Model3RunEv+0x10>
    9b34:	c2280000 	eorgt	r0, r8, #0
    9b38:	0000c238 	andeq	ip, r0, r8, lsr r2
    9b3c:	0000c244 	andeq	ip, r0, r4, asr #4
    9b40:	0055554f 	subseq	r5, r5, pc, asr #10
    9b44:	0000c1c4 	andeq	ip, r0, r4, asr #3

00009b48 <_Z6mallocj>:
_Z6mallocj():
/home/trefil/sem/sources/userspace/../stdlib/include/memory.h:18

inline void* malloc(uint32_t size){
    9b48:	e92d4800 	push	{fp, lr}
    9b4c:	e28db004 	add	fp, sp, #4
    9b50:	e24dd008 	sub	sp, sp, #8
    9b54:	e50b0008 	str	r0, [fp, #-8]
/home/trefil/sem/sources/userspace/../stdlib/include/memory.h:19
    return h.Alloc(size);
    9b58:	e51b1008 	ldr	r1, [fp, #-8]
    9b5c:	e59f0010 	ldr	r0, [pc, #16]	; 9b74 <_Z6mallocj+0x2c>
    9b60:	eb0000de 	bl	9ee0 <_ZN12Heap_Manager5AllocEj>
    9b64:	e1a03000 	mov	r3, r0
/home/trefil/sem/sources/userspace/../stdlib/include/memory.h:20
    9b68:	e1a00003 	mov	r0, r3
    9b6c:	e24bd004 	sub	sp, fp, #4
    9b70:	e8bd8800 	pop	{fp, pc}
    9b74:	0000c324 	andeq	ip, r0, r4, lsr #6

00009b78 <_Z5splitPP9Tribesmanii>:
_Z5splitPP9Tribesmanii():
/home/trefil/sem/sources/userspace/Model/Sort.cpp:4
#include <Sort.h>


int split(Tribesman** tribesman,  int left,  int right){
    9b78:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9b7c:	e28db000 	add	fp, sp, #0
    9b80:	e24dd01c 	sub	sp, sp, #28
    9b84:	e50b0010 	str	r0, [fp, #-16]
    9b88:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    9b8c:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/userspace/Model/Sort.cpp:5
    Tribesman* pivot = tribesman[right];
    9b90:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9b94:	e1a03103 	lsl	r3, r3, #2
    9b98:	e51b2010 	ldr	r2, [fp, #-16]
    9b9c:	e0823003 	add	r3, r2, r3
    9ba0:	e5933000 	ldr	r3, [r3]
    9ba4:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/userspace/Model/Sort.cpp:8
    while(1){
        //dokud je left pointer mensi jak right a prvky jsou mensi jak pivot, tak se hybej
        while((left < right) && (tribesman[left]->fitness < pivot->fitness))
    9ba8:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    9bac:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9bb0:	e1520003 	cmp	r2, r3
    9bb4:	aa000014 	bge	9c0c <_Z5splitPP9Tribesmanii+0x94>
/home/trefil/sem/sources/userspace/Model/Sort.cpp:8 (discriminator 1)
    9bb8:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9bbc:	e1a03103 	lsl	r3, r3, #2
    9bc0:	e51b2010 	ldr	r2, [fp, #-16]
    9bc4:	e0823003 	add	r3, r2, r3
    9bc8:	e5933000 	ldr	r3, [r3]
    9bcc:	ed937a05 	vldr	s14, [r3, #20]
    9bd0:	e51b3008 	ldr	r3, [fp, #-8]
    9bd4:	edd37a05 	vldr	s15, [r3, #20]
    9bd8:	eeb47ae7 	vcmpe.f32	s14, s15
    9bdc:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    9be0:	43a03001 	movmi	r3, #1
    9be4:	53a03000 	movpl	r3, #0
    9be8:	e6ef3073 	uxtb	r3, r3
    9bec:	e2233001 	eor	r3, r3, #1
    9bf0:	e6ef3073 	uxtb	r3, r3
    9bf4:	e3530000 	cmp	r3, #0
    9bf8:	1a000003 	bne	9c0c <_Z5splitPP9Tribesmanii+0x94>
/home/trefil/sem/sources/userspace/Model/Sort.cpp:9
                left++;
    9bfc:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9c00:	e2833001 	add	r3, r3, #1
    9c04:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/userspace/Model/Sort.cpp:8
        while((left < right) && (tribesman[left]->fitness < pivot->fitness))
    9c08:	eaffffe6 	b	9ba8 <_Z5splitPP9Tribesmanii+0x30>
/home/trefil/sem/sources/userspace/Model/Sort.cpp:11
        //nasel jsem misto na swap, hod left na right
        if(left<right){
    9c0c:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    9c10:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9c14:	e1520003 	cmp	r2, r3
    9c18:	aa000037 	bge	9cfc <_Z5splitPP9Tribesmanii+0x184>
/home/trefil/sem/sources/userspace/Model/Sort.cpp:12
            tribesman[right] = tribesman[left];
    9c1c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9c20:	e1a03103 	lsl	r3, r3, #2
    9c24:	e51b2010 	ldr	r2, [fp, #-16]
    9c28:	e0822003 	add	r2, r2, r3
    9c2c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9c30:	e1a03103 	lsl	r3, r3, #2
    9c34:	e51b1010 	ldr	r1, [fp, #-16]
    9c38:	e0813003 	add	r3, r1, r3
    9c3c:	e5922000 	ldr	r2, [r2]
    9c40:	e5832000 	str	r2, [r3]
/home/trefil/sem/sources/userspace/Model/Sort.cpp:13
            right--;
    9c44:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9c48:	e2433001 	sub	r3, r3, #1
    9c4c:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/userspace/Model/Sort.cpp:17
        }else //v teto casti pole uz nemuzu nic vymenit
            break;
        //logika stejna, jenom hybu right pointerem, ne left pointerem
        while((left < right) && (tribesman[right]->fitness > pivot->fitness))
    9c50:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    9c54:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9c58:	e1520003 	cmp	r2, r3
    9c5c:	aa000014 	bge	9cb4 <_Z5splitPP9Tribesmanii+0x13c>
/home/trefil/sem/sources/userspace/Model/Sort.cpp:17 (discriminator 1)
    9c60:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9c64:	e1a03103 	lsl	r3, r3, #2
    9c68:	e51b2010 	ldr	r2, [fp, #-16]
    9c6c:	e0823003 	add	r3, r2, r3
    9c70:	e5933000 	ldr	r3, [r3]
    9c74:	ed937a05 	vldr	s14, [r3, #20]
    9c78:	e51b3008 	ldr	r3, [fp, #-8]
    9c7c:	edd37a05 	vldr	s15, [r3, #20]
    9c80:	eeb47ae7 	vcmpe.f32	s14, s15
    9c84:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    9c88:	c3a03001 	movgt	r3, #1
    9c8c:	d3a03000 	movle	r3, #0
    9c90:	e6ef3073 	uxtb	r3, r3
    9c94:	e2233001 	eor	r3, r3, #1
    9c98:	e6ef3073 	uxtb	r3, r3
    9c9c:	e3530000 	cmp	r3, #0
    9ca0:	1a000003 	bne	9cb4 <_Z5splitPP9Tribesmanii+0x13c>
/home/trefil/sem/sources/userspace/Model/Sort.cpp:18
            right--;
    9ca4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9ca8:	e2433001 	sub	r3, r3, #1
    9cac:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/userspace/Model/Sort.cpp:17
        while((left < right) && (tribesman[right]->fitness > pivot->fitness))
    9cb0:	eaffffe6 	b	9c50 <_Z5splitPP9Tribesmanii+0xd8>
/home/trefil/sem/sources/userspace/Model/Sort.cpp:19
        if(left<right){
    9cb4:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    9cb8:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9cbc:	e1520003 	cmp	r2, r3
    9cc0:	aa00000f 	bge	9d04 <_Z5splitPP9Tribesmanii+0x18c>
/home/trefil/sem/sources/userspace/Model/Sort.cpp:20
            tribesman[left] = tribesman[right];
    9cc4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9cc8:	e1a03103 	lsl	r3, r3, #2
    9ccc:	e51b2010 	ldr	r2, [fp, #-16]
    9cd0:	e0822003 	add	r2, r2, r3
    9cd4:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9cd8:	e1a03103 	lsl	r3, r3, #2
    9cdc:	e51b1010 	ldr	r1, [fp, #-16]
    9ce0:	e0813003 	add	r3, r1, r3
    9ce4:	e5922000 	ldr	r2, [r2]
    9ce8:	e5832000 	str	r2, [r3]
/home/trefil/sem/sources/userspace/Model/Sort.cpp:21
            left++;
    9cec:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9cf0:	e2833001 	add	r3, r3, #1
    9cf4:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/userspace/Model/Sort.cpp:8
        while((left < right) && (tribesman[left]->fitness < pivot->fitness))
    9cf8:	eaffffaa 	b	9ba8 <_Z5splitPP9Tribesmanii+0x30>
/home/trefil/sem/sources/userspace/Model/Sort.cpp:15
            break;
    9cfc:	e320f000 	nop	{0}
    9d00:	ea000000 	b	9d08 <_Z5splitPP9Tribesmanii+0x190>
/home/trefil/sem/sources/userspace/Model/Sort.cpp:22
        }else break;
    9d04:	e320f000 	nop	{0}
/home/trefil/sem/sources/userspace/Model/Sort.cpp:25
    }
    //na left bude dira pro pivotni prvek
    tribesman[left] = pivot;
    9d08:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9d0c:	e1a03103 	lsl	r3, r3, #2
    9d10:	e51b2010 	ldr	r2, [fp, #-16]
    9d14:	e0823003 	add	r3, r2, r3
    9d18:	e51b2008 	ldr	r2, [fp, #-8]
    9d1c:	e5832000 	str	r2, [r3]
/home/trefil/sem/sources/userspace/Model/Sort.cpp:27
    //vrat split index
    return left;
    9d20:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/userspace/Model/Sort.cpp:29

}
    9d24:	e1a00003 	mov	r0, r3
    9d28:	e28bd000 	add	sp, fp, #0
    9d2c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9d30:	e12fff1e 	bx	lr

00009d34 <_Z4sortPP9Tribesmanii>:
_Z4sortPP9Tribesmanii():
/home/trefil/sem/sources/userspace/Model/Sort.cpp:32

//serad borce podle jejich fitness
void sort(Tribesman** tribesman,  int start,  int end){
    9d34:	e92d4800 	push	{fp, lr}
    9d38:	e28db004 	add	fp, sp, #4
    9d3c:	e24dd018 	sub	sp, sp, #24
    9d40:	e50b0010 	str	r0, [fp, #-16]
    9d44:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    9d48:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/userspace/Model/Sort.cpp:33
    if(start >= end)return;
    9d4c:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    9d50:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9d54:	e1520003 	cmp	r2, r3
    9d58:	aa000011 	bge	9da4 <_Z4sortPP9Tribesmanii+0x70>
/home/trefil/sem/sources/userspace/Model/Sort.cpp:35
    //misto, kde se nam pole rozpadne na dve "podpole", ktere se budou radit
    int index = split(tribesman,start,end);
    9d5c:	e51b2018 	ldr	r2, [fp, #-24]	; 0xffffffe8
    9d60:	e51b1014 	ldr	r1, [fp, #-20]	; 0xffffffec
    9d64:	e51b0010 	ldr	r0, [fp, #-16]
    9d68:	ebffff82 	bl	9b78 <_Z5splitPP9Tribesmanii>
    9d6c:	e50b0008 	str	r0, [fp, #-8]
/home/trefil/sem/sources/userspace/Model/Sort.cpp:38
    //vime, ze pivotni prvek uz je na spravnem miste, tedy vsechny prvky index-1 jsou mensi a index+1 jsou vetsi
    //nebudu jej proto uz kontrolovat
    sort(tribesman,start,index - 1);
    9d70:	e51b3008 	ldr	r3, [fp, #-8]
    9d74:	e2433001 	sub	r3, r3, #1
    9d78:	e1a02003 	mov	r2, r3
    9d7c:	e51b1014 	ldr	r1, [fp, #-20]	; 0xffffffec
    9d80:	e51b0010 	ldr	r0, [fp, #-16]
    9d84:	ebffffea 	bl	9d34 <_Z4sortPP9Tribesmanii>
/home/trefil/sem/sources/userspace/Model/Sort.cpp:39
    sort(tribesman,index+1,end);
    9d88:	e51b3008 	ldr	r3, [fp, #-8]
    9d8c:	e2833001 	add	r3, r3, #1
    9d90:	e51b2018 	ldr	r2, [fp, #-24]	; 0xffffffe8
    9d94:	e1a01003 	mov	r1, r3
    9d98:	e51b0010 	ldr	r0, [fp, #-16]
    9d9c:	ebffffe4 	bl	9d34 <_Z4sortPP9Tribesmanii>
    9da0:	ea000000 	b	9da8 <_Z4sortPP9Tribesmanii+0x74>
/home/trefil/sem/sources/userspace/Model/Sort.cpp:33
    if(start >= end)return;
    9da4:	e320f000 	nop	{0}
/home/trefil/sem/sources/userspace/Model/Sort.cpp:40
}
    9da8:	e24bd004 	sub	sp, fp, #4
    9dac:	e8bd8800 	pop	{fp, pc}

00009db0 <_Z14Sort_TribesmanPP9Tribesmani>:
_Z14Sort_TribesmanPP9Tribesmani():
/home/trefil/sem/sources/userspace/Model/Sort.cpp:44

//jakysi qsort pro serazeni
//prepis do nerekurzivni verze vhodny pro RTOS
void Sort_Tribesman(Tribesman** tribesman,  int len){
    9db0:	e92d4800 	push	{fp, lr}
    9db4:	e28db004 	add	fp, sp, #4
    9db8:	e24dd008 	sub	sp, sp, #8
    9dbc:	e50b0008 	str	r0, [fp, #-8]
    9dc0:	e50b100c 	str	r1, [fp, #-12]
/home/trefil/sem/sources/userspace/Model/Sort.cpp:45
    sort(tribesman,0,len-1);
    9dc4:	e51b300c 	ldr	r3, [fp, #-12]
    9dc8:	e2433001 	sub	r3, r3, #1
    9dcc:	e1a02003 	mov	r2, r3
    9dd0:	e3a01000 	mov	r1, #0
    9dd4:	e51b0008 	ldr	r0, [fp, #-8]
    9dd8:	ebffffd5 	bl	9d34 <_Z4sortPP9Tribesmanii>
/home/trefil/sem/sources/userspace/Model/Sort.cpp:46
    9ddc:	e320f000 	nop	{0}
    9de0:	e24bd004 	sub	sp, fp, #4
    9de4:	e8bd8800 	pop	{fp, pc}

00009de8 <_ZN12Heap_ManagerC1Ev>:
_ZN12Heap_ManagerC2Ev():
/home/trefil/sem/sources/stdlib/src/Heap_Manager.cpp:7

Heap_Manager h;
//spravce pameti na halde uzivatelskeho procesu
//inkrementalni alokace a neumi free
//aby umel free nejak rozumne, nutne implementovat napriklad seznamem der/procesu nebo buddy systemem
Heap_Manager::Heap_Manager(){};
    9de8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9dec:	e28db000 	add	fp, sp, #0
    9df0:	e24dd00c 	sub	sp, sp, #12
    9df4:	e50b0008 	str	r0, [fp, #-8]
    9df8:	e51b3008 	ldr	r3, [fp, #-8]
    9dfc:	e3a02000 	mov	r2, #0
    9e00:	e5832000 	str	r2, [r3]
    9e04:	e51b3008 	ldr	r3, [fp, #-8]
    9e08:	e3a02000 	mov	r2, #0
    9e0c:	e5832004 	str	r2, [r3, #4]
    9e10:	e51b3008 	ldr	r3, [fp, #-8]
    9e14:	e3a02a01 	mov	r2, #4096	; 0x1000
    9e18:	e5832008 	str	r2, [r3, #8]
    9e1c:	e51b3008 	ldr	r3, [fp, #-8]
    9e20:	e1a00003 	mov	r0, r3
    9e24:	e28bd000 	add	sp, fp, #0
    9e28:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9e2c:	e12fff1e 	bx	lr

00009e30 <_ZN12Heap_Manager4SbrkEv>:
_ZN12Heap_Manager4SbrkEv():
/home/trefil/sem/sources/stdlib/src/Heap_Manager.cpp:9
//syscall pro prideleni pameti na halde od kernelu
void Heap_Manager::Sbrk(){
    9e30:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9e34:	e28db000 	add	fp, sp, #0
    9e38:	e24dd014 	sub	sp, sp, #20
    9e3c:	e50b0010 	str	r0, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/Heap_Manager.cpp:13

    uint32_t rdnum;
    //uint32_t increment_count = Get_Increment_Count();
    asm volatile("mov r0, %0" : : "r" (increment_size));
    9e40:	e51b3010 	ldr	r3, [fp, #-16]
    9e44:	e5933008 	ldr	r3, [r3, #8]
    9e48:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/Heap_Manager.cpp:14
    asm volatile("swi 6");
    9e4c:	ef000006 	svc	0x00000006
/home/trefil/sem/sources/stdlib/src/Heap_Manager.cpp:15
    asm volatile("mov %0, r0" : "=r" (rdnum));
    9e50:	e1a03000 	mov	r3, r0
    9e54:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/Heap_Manager.cpp:18
    //pokud je to muj prvni kus haldy, vrat pointer na zacatek haldy
    //dal si tohle ukazovatko spravuje stdlib sam
    if(mem_address == 0){
    9e58:	e51b3010 	ldr	r3, [fp, #-16]
    9e5c:	e5933000 	ldr	r3, [r3]
    9e60:	e3530000 	cmp	r3, #0
    9e64:	1a000009 	bne	9e90 <_ZN12Heap_Manager4SbrkEv+0x60>
/home/trefil/sem/sources/stdlib/src/Heap_Manager.cpp:19
        mem_address = rdnum;
    9e68:	e51b3010 	ldr	r3, [fp, #-16]
    9e6c:	e51b2008 	ldr	r2, [fp, #-8]
    9e70:	e5832000 	str	r2, [r3]
/home/trefil/sem/sources/stdlib/src/Heap_Manager.cpp:20
        remainder = rdnum + increment_size;
    9e74:	e51b3010 	ldr	r3, [fp, #-16]
    9e78:	e5932008 	ldr	r2, [r3, #8]
    9e7c:	e51b3008 	ldr	r3, [fp, #-8]
    9e80:	e0822003 	add	r2, r2, r3
    9e84:	e51b3010 	ldr	r3, [fp, #-16]
    9e88:	e5832004 	str	r2, [r3, #4]
/home/trefil/sem/sources/stdlib/src/Heap_Manager.cpp:21
        return;
    9e8c:	ea000006 	b	9eac <_ZN12Heap_Manager4SbrkEv+0x7c>
/home/trefil/sem/sources/stdlib/src/Heap_Manager.cpp:23
    }
    remainder += increment_size;
    9e90:	e51b3010 	ldr	r3, [fp, #-16]
    9e94:	e5932004 	ldr	r2, [r3, #4]
    9e98:	e51b3010 	ldr	r3, [fp, #-16]
    9e9c:	e5933008 	ldr	r3, [r3, #8]
    9ea0:	e0822003 	add	r2, r2, r3
    9ea4:	e51b3010 	ldr	r3, [fp, #-16]
    9ea8:	e5832004 	str	r2, [r3, #4]
/home/trefil/sem/sources/stdlib/src/Heap_Manager.cpp:24
}
    9eac:	e28bd000 	add	sp, fp, #0
    9eb0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9eb4:	e12fff1e 	bx	lr

00009eb8 <_ZN12Heap_Manager15Get_Mem_AddressEv>:
_ZN12Heap_Manager15Get_Mem_AddressEv():
/home/trefil/sem/sources/stdlib/src/Heap_Manager.cpp:27
//dej mi aktualni adresu, kam chces zapisovat na halde
//pouzito pro pripadny debugging
uint32_t Heap_Manager::Get_Mem_Address(){
    9eb8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9ebc:	e28db000 	add	fp, sp, #0
    9ec0:	e24dd00c 	sub	sp, sp, #12
    9ec4:	e50b0008 	str	r0, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/Heap_Manager.cpp:28
    return mem_address;
    9ec8:	e51b3008 	ldr	r3, [fp, #-8]
    9ecc:	e5933000 	ldr	r3, [r3]
/home/trefil/sem/sources/stdlib/src/Heap_Manager.cpp:29
}
    9ed0:	e1a00003 	mov	r0, r3
    9ed4:	e28bd000 	add	sp, fp, #0
    9ed8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9edc:	e12fff1e 	bx	lr

00009ee0 <_ZN12Heap_Manager5AllocEj>:
_ZN12Heap_Manager5AllocEj():
/home/trefil/sem/sources/stdlib/src/Heap_Manager.cpp:31
//alokuj mi na halde velikost @param size
void* Heap_Manager::Alloc(uint32_t size){
    9ee0:	e92d4800 	push	{fp, lr}
    9ee4:	e28db004 	add	fp, sp, #4
    9ee8:	e24dd010 	sub	sp, sp, #16
    9eec:	e50b0010 	str	r0, [fp, #-16]
    9ef0:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/stdlib/src/Heap_Manager.cpp:33
    //uz se mi vic nevejde, musim syscallnout, dokud se vejdu
    while(mem_address + size > remainder)
    9ef4:	e51b3010 	ldr	r3, [fp, #-16]
    9ef8:	e5932000 	ldr	r2, [r3]
    9efc:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9f00:	e0822003 	add	r2, r2, r3
    9f04:	e51b3010 	ldr	r3, [fp, #-16]
    9f08:	e5933004 	ldr	r3, [r3, #4]
    9f0c:	e1520003 	cmp	r2, r3
    9f10:	9a000002 	bls	9f20 <_ZN12Heap_Manager5AllocEj+0x40>
/home/trefil/sem/sources/stdlib/src/Heap_Manager.cpp:34
        Sbrk();
    9f14:	e51b0010 	ldr	r0, [fp, #-16]
    9f18:	ebffffc4 	bl	9e30 <_ZN12Heap_Manager4SbrkEv>
/home/trefil/sem/sources/stdlib/src/Heap_Manager.cpp:33
    while(mem_address + size > remainder)
    9f1c:	eafffff4 	b	9ef4 <_ZN12Heap_Manager5AllocEj+0x14>
/home/trefil/sem/sources/stdlib/src/Heap_Manager.cpp:35
    uint32_t address = mem_address;
    9f20:	e51b3010 	ldr	r3, [fp, #-16]
    9f24:	e5933000 	ldr	r3, [r3]
    9f28:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/Heap_Manager.cpp:36
    mem_address += size;
    9f2c:	e51b3010 	ldr	r3, [fp, #-16]
    9f30:	e5932000 	ldr	r2, [r3]
    9f34:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9f38:	e0822003 	add	r2, r2, r3
    9f3c:	e51b3010 	ldr	r3, [fp, #-16]
    9f40:	e5832000 	str	r2, [r3]
/home/trefil/sem/sources/stdlib/src/Heap_Manager.cpp:37
    return reinterpret_cast<void*>(address);
    9f44:	e51b3008 	ldr	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/Heap_Manager.cpp:38
}
    9f48:	e1a00003 	mov	r0, r3
    9f4c:	e24bd004 	sub	sp, fp, #4
    9f50:	e8bd8800 	pop	{fp, pc}

00009f54 <_Z41__static_initialization_and_destruction_0ii>:
_Z41__static_initialization_and_destruction_0ii():
/home/trefil/sem/sources/stdlib/src/Heap_Manager.cpp:38
    9f54:	e92d4800 	push	{fp, lr}
    9f58:	e28db004 	add	fp, sp, #4
    9f5c:	e24dd008 	sub	sp, sp, #8
    9f60:	e50b0008 	str	r0, [fp, #-8]
    9f64:	e50b100c 	str	r1, [fp, #-12]
    9f68:	e51b3008 	ldr	r3, [fp, #-8]
    9f6c:	e3530001 	cmp	r3, #1
    9f70:	1a000005 	bne	9f8c <_Z41__static_initialization_and_destruction_0ii+0x38>
/home/trefil/sem/sources/stdlib/src/Heap_Manager.cpp:38 (discriminator 1)
    9f74:	e51b300c 	ldr	r3, [fp, #-12]
    9f78:	e59f2018 	ldr	r2, [pc, #24]	; 9f98 <_Z41__static_initialization_and_destruction_0ii+0x44>
    9f7c:	e1530002 	cmp	r3, r2
    9f80:	1a000001 	bne	9f8c <_Z41__static_initialization_and_destruction_0ii+0x38>
/home/trefil/sem/sources/stdlib/src/Heap_Manager.cpp:3
Heap_Manager h;
    9f84:	e59f0010 	ldr	r0, [pc, #16]	; 9f9c <_Z41__static_initialization_and_destruction_0ii+0x48>
    9f88:	ebffff96 	bl	9de8 <_ZN12Heap_ManagerC1Ev>
/home/trefil/sem/sources/stdlib/src/Heap_Manager.cpp:38
}
    9f8c:	e320f000 	nop	{0}
    9f90:	e24bd004 	sub	sp, fp, #4
    9f94:	e8bd8800 	pop	{fp, pc}
    9f98:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>
    9f9c:	0000c324 	andeq	ip, r0, r4, lsr #6

00009fa0 <_GLOBAL__sub_I_h>:
_GLOBAL__sub_I_h():
/home/trefil/sem/sources/stdlib/src/Heap_Manager.cpp:38
    9fa0:	e92d4800 	push	{fp, lr}
    9fa4:	e28db004 	add	fp, sp, #4
    9fa8:	e59f1008 	ldr	r1, [pc, #8]	; 9fb8 <_GLOBAL__sub_I_h+0x18>
    9fac:	e3a00001 	mov	r0, #1
    9fb0:	ebffffe7 	bl	9f54 <_Z41__static_initialization_and_destruction_0ii>
    9fb4:	e8bd8800 	pop	{fp, pc}
    9fb8:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>
    9fbc:	00000000 	andeq	r0, r0, r0

00009fc0 <_ZN16Random_GeneratorC1Eiiiii>:
_ZN16Random_GeneratorC2Eiiiii():
/home/trefil/sem/sources/stdlib/src/Random.cpp:5
#include <Random.h>

//pseudorandom generator cisel pro nahodnodnost parametru populace
//neni uplne optimalni nebo idealni, ale pro demonstracni ucely snad ok
Random_Generator::Random_Generator(int min, int max, int a,int c, int seed):
    9fc0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9fc4:	e28db000 	add	fp, sp, #0
    9fc8:	e24dd014 	sub	sp, sp, #20
    9fcc:	e50b0008 	str	r0, [fp, #-8]
    9fd0:	e50b100c 	str	r1, [fp, #-12]
    9fd4:	e50b2010 	str	r2, [fp, #-16]
    9fd8:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/stdlib/src/Random.cpp:6
        a(a),max(max),seed(seed), min(min), c(c)
    9fdc:	e51b3008 	ldr	r3, [fp, #-8]
    9fe0:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    9fe4:	e5832000 	str	r2, [r3]
    9fe8:	e51b3008 	ldr	r3, [fp, #-8]
    9fec:	e59b2004 	ldr	r2, [fp, #4]
    9ff0:	e5832004 	str	r2, [r3, #4]
    9ff4:	e51b3008 	ldr	r3, [fp, #-8]
    9ff8:	e51b200c 	ldr	r2, [fp, #-12]
    9ffc:	e5832008 	str	r2, [r3, #8]
    a000:	e51b3008 	ldr	r3, [fp, #-8]
    a004:	e51b2010 	ldr	r2, [fp, #-16]
    a008:	e583200c 	str	r2, [r3, #12]
    a00c:	e51b3008 	ldr	r3, [fp, #-8]
    a010:	e59b2008 	ldr	r2, [fp, #8]
    a014:	e5832010 	str	r2, [r3, #16]
    a018:	e51b3008 	ldr	r3, [fp, #-8]
    a01c:	e3a02000 	mov	r2, #0
    a020:	e5832018 	str	r2, [r3, #24]
/home/trefil/sem/sources/stdlib/src/Random.cpp:7
{}
    a024:	e51b3008 	ldr	r3, [fp, #-8]
    a028:	e1a00003 	mov	r0, r3
    a02c:	e28bd000 	add	sp, fp, #0
    a030:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    a034:	e12fff1e 	bx	lr

0000a038 <_ZN16Random_Generator7Get_IntEv>:
_ZN16Random_Generator7Get_IntEv():
/home/trefil/sem/sources/stdlib/src/Random.cpp:10

//TODO lepsi random engine
int Random_Generator::Get_Int(){
    a038:	e92d4800 	push	{fp, lr}
    a03c:	e28db004 	add	fp, sp, #4
    a040:	e24dd010 	sub	sp, sp, #16
    a044:	e50b0010 	str	r0, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/Random.cpp:11
    if(previously_generated == 0)
    a048:	e51b3010 	ldr	r3, [fp, #-16]
    a04c:	e5933018 	ldr	r3, [r3, #24]
    a050:	e3530000 	cmp	r3, #0
    a054:	1a000003 	bne	a068 <_ZN16Random_Generator7Get_IntEv+0x30>
/home/trefil/sem/sources/stdlib/src/Random.cpp:12
        previously_generated = seed;
    a058:	e51b3010 	ldr	r3, [fp, #-16]
    a05c:	e5932010 	ldr	r2, [r3, #16]
    a060:	e51b3010 	ldr	r3, [fp, #-16]
    a064:	e5832018 	str	r2, [r3, #24]
/home/trefil/sem/sources/stdlib/src/Random.cpp:13
    int tmp = (a*previously_generated + c );
    a068:	e51b3010 	ldr	r3, [fp, #-16]
    a06c:	e5933000 	ldr	r3, [r3]
    a070:	e51b2010 	ldr	r2, [fp, #-16]
    a074:	e5922018 	ldr	r2, [r2, #24]
    a078:	e0020392 	mul	r2, r2, r3
    a07c:	e51b3010 	ldr	r3, [fp, #-16]
    a080:	e5933004 	ldr	r3, [r3, #4]
    a084:	e0823003 	add	r3, r2, r3
    a088:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/Random.cpp:14
    int numero = tmp % max;
    a08c:	e51b3010 	ldr	r3, [fp, #-16]
    a090:	e593200c 	ldr	r2, [r3, #12]
    a094:	e51b3008 	ldr	r3, [fp, #-8]
    a098:	e1a01002 	mov	r1, r2
    a09c:	e1a00003 	mov	r0, r3
    a0a0:	eb000660 	bl	ba28 <__aeabi_idivmod>
    a0a4:	e1a03001 	mov	r3, r1
    a0a8:	e50b300c 	str	r3, [fp, #-12]
/home/trefil/sem/sources/stdlib/src/Random.cpp:17


    previously_generated = numero;
    a0ac:	e51b3010 	ldr	r3, [fp, #-16]
    a0b0:	e51b200c 	ldr	r2, [fp, #-12]
    a0b4:	e5832018 	str	r2, [r3, #24]
/home/trefil/sem/sources/stdlib/src/Random.cpp:18
    return numero;
    a0b8:	e51b300c 	ldr	r3, [fp, #-12]
/home/trefil/sem/sources/stdlib/src/Random.cpp:19
}
    a0bc:	e1a00003 	mov	r0, r3
    a0c0:	e24bd004 	sub	sp, fp, #4
    a0c4:	e8bd8800 	pop	{fp, pc}

0000a0c8 <_ZN16Random_Generator9Get_FloatEv>:
_ZN16Random_Generator9Get_FloatEv():
/home/trefil/sem/sources/stdlib/src/Random.cpp:23


//vrat float v intervalu <min,max>
float Random_Generator::Get_Float() {
    a0c8:	e92d4800 	push	{fp, lr}
    a0cc:	e28db004 	add	fp, sp, #4
    a0d0:	e24dd010 	sub	sp, sp, #16
    a0d4:	e50b0010 	str	r0, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/Random.cpp:24
    int rand = Get_Int();
    a0d8:	e51b0010 	ldr	r0, [fp, #-16]
    a0dc:	ebffffd5 	bl	a038 <_ZN16Random_Generator7Get_IntEv>
    a0e0:	e50b0008 	str	r0, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/Random.cpp:25
    float rand_float = rand / 1000.0;
    a0e4:	e51b3008 	ldr	r3, [fp, #-8]
    a0e8:	ee073a90 	vmov	s15, r3
    a0ec:	eeb86be7 	vcvt.f64.s32	d6, s15
    a0f0:	ed9f5b08 	vldr	d5, [pc, #32]	; a118 <_ZN16Random_Generator9Get_FloatEv+0x50>
    a0f4:	ee867b05 	vdiv.f64	d7, d6, d5
    a0f8:	eef77bc7 	vcvt.f32.f64	s15, d7
    a0fc:	ed4b7a03 	vstr	s15, [fp, #-12]
/home/trefil/sem/sources/stdlib/src/Random.cpp:26
    return rand_float;
    a100:	e51b300c 	ldr	r3, [fp, #-12]
    a104:	ee073a90 	vmov	s15, r3
/home/trefil/sem/sources/stdlib/src/Random.cpp:27
    a108:	eeb00a67 	vmov.f32	s0, s15
    a10c:	e24bd004 	sub	sp, fp, #4
    a110:	e8bd8800 	pop	{fp, pc}
    a114:	e320f000 	nop	{0}
    a118:	00000000 	andeq	r0, r0, r0
    a11c:	408f4000 	addmi	r4, pc, r0

0000a120 <_ZN6BufferC1Ej>:
_ZN6BufferC2Ej():
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:6
#include <stdbuffer.h>




Buffer::Buffer(uint32_t file_desc):file(file_desc){};
    a120:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    a124:	e28db000 	add	fp, sp, #0
    a128:	e24dd00c 	sub	sp, sp, #12
    a12c:	e50b0008 	str	r0, [fp, #-8]
    a130:	e50b100c 	str	r1, [fp, #-12]
    a134:	e51b3008 	ldr	r3, [fp, #-8]
    a138:	e3a02000 	mov	r2, #0
    a13c:	e5832000 	str	r2, [r3]
    a140:	e51b3008 	ldr	r3, [fp, #-8]
    a144:	e3a02000 	mov	r2, #0
    a148:	e5832004 	str	r2, [r3, #4]
    a14c:	e51b3008 	ldr	r3, [fp, #-8]
    a150:	e51b200c 	ldr	r2, [fp, #-12]
    a154:	e5832088 	str	r2, [r3, #136]	; 0x88
    a158:	e51b3008 	ldr	r3, [fp, #-8]
    a15c:	e1a00003 	mov	r0, r3
    a160:	e28bd000 	add	sp, fp, #0
    a164:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    a168:	e12fff1e 	bx	lr

0000a16c <_ZN6Buffer8Is_EmptyEv>:
_ZN6Buffer8Is_EmptyEv():
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:9

//jsem prazdny?
bool Buffer::Is_Empty(){
    a16c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    a170:	e28db000 	add	fp, sp, #0
    a174:	e24dd00c 	sub	sp, sp, #12
    a178:	e50b0008 	str	r0, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:10
    return read_pointer == write_pointer;
    a17c:	e51b3008 	ldr	r3, [fp, #-8]
    a180:	e5932000 	ldr	r2, [r3]
    a184:	e51b3008 	ldr	r3, [fp, #-8]
    a188:	e5933004 	ldr	r3, [r3, #4]
    a18c:	e1520003 	cmp	r2, r3
    a190:	03a03001 	moveq	r3, #1
    a194:	13a03000 	movne	r3, #0
    a198:	e6ef3073 	uxtb	r3, r3
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:11
}
    a19c:	e1a00003 	mov	r0, r3
    a1a0:	e28bd000 	add	sp, fp, #0
    a1a4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    a1a8:	e12fff1e 	bx	lr

0000a1ac <_ZN6Buffer7Is_FullEv>:
_ZN6Buffer7Is_FullEv():
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:13
//jsem plny?
bool Buffer::Is_Full(){
    a1ac:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    a1b0:	e28db000 	add	fp, sp, #0
    a1b4:	e24dd00c 	sub	sp, sp, #12
    a1b8:	e50b0008 	str	r0, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:14
    return write_pointer == buffer_size;
    a1bc:	e51b3008 	ldr	r3, [fp, #-8]
    a1c0:	e5933004 	ldr	r3, [r3, #4]
    a1c4:	e3530080 	cmp	r3, #128	; 0x80
    a1c8:	03a03001 	moveq	r3, #1
    a1cc:	13a03000 	movne	r3, #0
    a1d0:	e6ef3073 	uxtb	r3, r3
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:15
}
    a1d4:	e1a00003 	mov	r0, r3
    a1d8:	e28bd000 	add	sp, fp, #0
    a1dc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    a1e0:	e12fff1e 	bx	lr

0000a1e4 <_ZN6Buffer8Add_ByteEc>:
_ZN6Buffer8Add_ByteEc():
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:17
//pridej byte do bufferu
void Buffer::Add_Byte(char c){
    a1e4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    a1e8:	e28db000 	add	fp, sp, #0
    a1ec:	e24dd00c 	sub	sp, sp, #12
    a1f0:	e50b0008 	str	r0, [fp, #-8]
    a1f4:	e1a03001 	mov	r3, r1
    a1f8:	e54b3009 	strb	r3, [fp, #-9]
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:18
    out_buffer[write_pointer] = c;
    a1fc:	e51b3008 	ldr	r3, [fp, #-8]
    a200:	e5933004 	ldr	r3, [r3, #4]
    a204:	e51b2008 	ldr	r2, [fp, #-8]
    a208:	e0823003 	add	r3, r2, r3
    a20c:	e55b2009 	ldrb	r2, [fp, #-9]
    a210:	e5c3208c 	strb	r2, [r3, #140]	; 0x8c
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:19
    write_pointer++;
    a214:	e51b3008 	ldr	r3, [fp, #-8]
    a218:	e5933004 	ldr	r3, [r3, #4]
    a21c:	e2832001 	add	r2, r3, #1
    a220:	e51b3008 	ldr	r3, [fp, #-8]
    a224:	e5832004 	str	r2, [r3, #4]
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:20
}
    a228:	e320f000 	nop	{0}
    a22c:	e28bd000 	add	sp, fp, #0
    a230:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    a234:	e12fff1e 	bx	lr

0000a238 <_ZN6Buffer5ClearEv>:
_ZN6Buffer5ClearEv():
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:22
//vycisti buffer
void Buffer::Clear(){
    a238:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    a23c:	e28db000 	add	fp, sp, #0
    a240:	e24dd00c 	sub	sp, sp, #12
    a244:	e50b0008 	str	r0, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:23
    read_pointer = 0;
    a248:	e51b3008 	ldr	r3, [fp, #-8]
    a24c:	e3a02000 	mov	r2, #0
    a250:	e5832000 	str	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:24
    write_pointer = 0;
    a254:	e51b3008 	ldr	r3, [fp, #-8]
    a258:	e3a02000 	mov	r2, #0
    a25c:	e5832004 	str	r2, [r3, #4]
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:25
}
    a260:	e320f000 	nop	{0}
    a264:	e28bd000 	add	sp, fp, #0
    a268:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    a26c:	e12fff1e 	bx	lr

0000a270 <_ZN6Buffer10Write_LineEPKc>:
_ZN6Buffer10Write_LineEPKc():
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:28
//vypis na uart
//vlastne neni write line, ale write, endline znak to neposila, pokud neni obsazen v retezci
void Buffer::Write_Line(const char* str){
    a270:	e92d4810 	push	{r4, fp, lr}
    a274:	e28db008 	add	fp, sp, #8
    a278:	e24dd00c 	sub	sp, sp, #12
    a27c:	e50b0010 	str	r0, [fp, #-16]
    a280:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:29
    write(file, str, strlen(str));
    a284:	e51b3010 	ldr	r3, [fp, #-16]
    a288:	e5934088 	ldr	r4, [r3, #136]	; 0x88
    a28c:	e51b0014 	ldr	r0, [fp, #-20]	; 0xffffffec
    a290:	eb000345 	bl	afac <_Z6strlenPKc>
    a294:	e1a03000 	mov	r3, r0
    a298:	e1a02003 	mov	r2, r3
    a29c:	e51b1014 	ldr	r1, [fp, #-20]	; 0xffffffec
    a2a0:	e1a00004 	mov	r0, r4
    a2a4:	eb0000e7 	bl	a648 <_Z5writejPKcj>
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:30
}
    a2a8:	e320f000 	nop	{0}
    a2ac:	e24bd008 	sub	sp, fp, #8
    a2b0:	e8bd8810 	pop	{r4, fp, pc}

0000a2b4 <_ZN6Buffer14Read_Uart_LineEv>:
_ZN6Buffer14Read_Uart_LineEv():
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:38
//potom vsechny prectete z kernel bufferu nakopiruje do interniho bufferu
//nasledne v tomto bufferu hleda uceleny user input, tedy <neco>\r pro qemu
//pri detekci ucelenho inputu vrati tento input
//jinak vraci nullptr -> uzivatel nic nezadal
//neni blokujici
char* Buffer::Read_Uart_Line(){
    a2b4:	e92d4800 	push	{fp, lr}
    a2b8:	e28db004 	add	fp, sp, #4
    a2bc:	e24dd020 	sub	sp, sp, #32
    a2c0:	e50b0020 	str	r0, [fp, #-32]	; 0xffffffe0
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:40
    //precti user input na uartu, pokud ho mam kam ulozit
    bool out_buffer_full = Is_Full();
    a2c4:	e51b0020 	ldr	r0, [fp, #-32]	; 0xffffffe0
    a2c8:	ebffffb7 	bl	a1ac <_ZN6Buffer7Is_FullEv>
    a2cc:	e1a03000 	mov	r3, r0
    a2d0:	e54b300e 	strb	r3, [fp, #-14]
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:42
    //pokud neni muj output buffer plny - zeptej se jadra, jestli neni neco na uartu
    if(!out_buffer_full){
    a2d4:	e55b300e 	ldrb	r3, [fp, #-14]
    a2d8:	e2233001 	eor	r3, r3, #1
    a2dc:	e6ef3073 	uxtb	r3, r3
    a2e0:	e3530000 	cmp	r3, #0
    a2e4:	0a00000d 	beq	a320 <_ZN6Buffer14Read_Uart_LineEv+0x6c>
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:43
        uint32_t count = read(file,buffer,buffer_size);
    a2e8:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    a2ec:	e5930088 	ldr	r0, [r3, #136]	; 0x88
    a2f0:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    a2f4:	e2833008 	add	r3, r3, #8
    a2f8:	e3a02080 	mov	r2, #128	; 0x80
    a2fc:	e1a01003 	mov	r1, r3
    a300:	eb0000bc 	bl	a5f8 <_Z4readjPcj>
    a304:	e50b0014 	str	r0, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:45
        //neco jsem precetl - vloz do bufferu
        if(count > 0)
    a308:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    a30c:	e3530000 	cmp	r3, #0
    a310:	0a000002 	beq	a320 <_ZN6Buffer14Read_Uart_LineEv+0x6c>
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:46
            Add_Bytes(count);
    a314:	e51b1014 	ldr	r1, [fp, #-20]	; 0xffffffec
    a318:	e51b0020 	ldr	r0, [fp, #-32]	; 0xffffffe0
    a31c:	eb00004e 	bl	a45c <_ZN6Buffer9Add_BytesEj>
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:49
        }
    //nic nemam - utec
    if(write_pointer == 0)return nullptr;
    a320:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    a324:	e5933004 	ldr	r3, [r3, #4]
    a328:	e3530000 	cmp	r3, #0
    a32c:	1a000001 	bne	a338 <_ZN6Buffer14Read_Uart_LineEv+0x84>
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:49 (discriminator 1)
    a330:	e3a03000 	mov	r3, #0
    a334:	ea000045 	b	a450 <_ZN6Buffer14Read_Uart_LineEv+0x19c>
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:51
    int i,j;
    bool line_found = false;
    a338:	e3a03000 	mov	r3, #0
    a33c:	e54b300d 	strb	r3, [fp, #-13]
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:52
    for(i = 0; i < write_pointer; i++){
    a340:	e3a03000 	mov	r3, #0
    a344:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:52 (discriminator 1)
    a348:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    a34c:	e5932004 	ldr	r2, [r3, #4]
    a350:	e51b3008 	ldr	r3, [fp, #-8]
    a354:	e1520003 	cmp	r2, r3
    a358:	9a000010 	bls	a3a0 <_ZN6Buffer14Read_Uart_LineEv+0xec>
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:53
        if(out_buffer[i] == '\r' && i>0){
    a35c:	e51b2020 	ldr	r2, [fp, #-32]	; 0xffffffe0
    a360:	e51b3008 	ldr	r3, [fp, #-8]
    a364:	e0823003 	add	r3, r2, r3
    a368:	e283308c 	add	r3, r3, #140	; 0x8c
    a36c:	e5d33000 	ldrb	r3, [r3]
    a370:	e353000d 	cmp	r3, #13
    a374:	1a000005 	bne	a390 <_ZN6Buffer14Read_Uart_LineEv+0xdc>
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:53 (discriminator 1)
    a378:	e51b3008 	ldr	r3, [fp, #-8]
    a37c:	e3530000 	cmp	r3, #0
    a380:	da000002 	ble	a390 <_ZN6Buffer14Read_Uart_LineEv+0xdc>
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:54
            line_found = true;
    a384:	e3a03001 	mov	r3, #1
    a388:	e54b300d 	strb	r3, [fp, #-13]
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:55
            break;
    a38c:	ea000003 	b	a3a0 <_ZN6Buffer14Read_Uart_LineEv+0xec>
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:52 (discriminator 2)
    for(i = 0; i < write_pointer; i++){
    a390:	e51b3008 	ldr	r3, [fp, #-8]
    a394:	e2833001 	add	r3, r3, #1
    a398:	e50b3008 	str	r3, [fp, #-8]
    a39c:	eaffffe9 	b	a348 <_ZN6Buffer14Read_Uart_LineEv+0x94>
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:61
        }
    }

    //buffer je plny a zaroven jsem nenasel newline, zacni prepisovat data v bufferu
    //nemelo by nastat pri beznem pouzivani single-task vypoctu
    if(!line_found){
    a3a0:	e55b300d 	ldrb	r3, [fp, #-13]
    a3a4:	e2233001 	eor	r3, r3, #1
    a3a8:	e6ef3073 	uxtb	r3, r3
    a3ac:	e3530000 	cmp	r3, #0
    a3b0:	0a000006 	beq	a3d0 <_ZN6Buffer14Read_Uart_LineEv+0x11c>
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:62
        if(out_buffer_full)
    a3b4:	e55b300e 	ldrb	r3, [fp, #-14]
    a3b8:	e3530000 	cmp	r3, #0
    a3bc:	0a000001 	beq	a3c8 <_ZN6Buffer14Read_Uart_LineEv+0x114>
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:63
            Clear();
    a3c0:	e51b0020 	ldr	r0, [fp, #-32]	; 0xffffffe0
    a3c4:	ebffff9b 	bl	a238 <_ZN6Buffer5ClearEv>
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:64
        return nullptr;
    a3c8:	e3a03000 	mov	r3, #0
    a3cc:	ea00001f 	b	a450 <_ZN6Buffer14Read_Uart_LineEv+0x19c>
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:68
    }
    //asi trochu memory hog
    //mozna nevhodne pro RTOS, protoze nemuze garantovat cas alokace na halde / samotnou alokaci
    char* bfr = new char[20];
    a3d0:	e3a00014 	mov	r0, #20
    a3d4:	ebfff8c1 	bl	86e0 <_Znaj>
    a3d8:	e1a03000 	mov	r3, r0
    a3dc:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:70
    // prekopiruj string a posli ho ven
    for(j = 0; j < i; j++){
    a3e0:	e3a03000 	mov	r3, #0
    a3e4:	e50b300c 	str	r3, [fp, #-12]
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:70 (discriminator 3)
    a3e8:	e51b200c 	ldr	r2, [fp, #-12]
    a3ec:	e51b3008 	ldr	r3, [fp, #-8]
    a3f0:	e1520003 	cmp	r2, r3
    a3f4:	aa00000c 	bge	a42c <_ZN6Buffer14Read_Uart_LineEv+0x178>
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:71 (discriminator 2)
        bfr[j] = out_buffer[j];
    a3f8:	e51b300c 	ldr	r3, [fp, #-12]
    a3fc:	e51b2018 	ldr	r2, [fp, #-24]	; 0xffffffe8
    a400:	e0823003 	add	r3, r2, r3
    a404:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    a408:	e51b200c 	ldr	r2, [fp, #-12]
    a40c:	e0812002 	add	r2, r1, r2
    a410:	e282208c 	add	r2, r2, #140	; 0x8c
    a414:	e5d22000 	ldrb	r2, [r2]
    a418:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:70 (discriminator 2)
    for(j = 0; j < i; j++){
    a41c:	e51b300c 	ldr	r3, [fp, #-12]
    a420:	e2833001 	add	r3, r3, #1
    a424:	e50b300c 	str	r3, [fp, #-12]
    a428:	eaffffee 	b	a3e8 <_ZN6Buffer14Read_Uart_LineEv+0x134>
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:73
    }
    bfr[j] = '\0';
    a42c:	e51b300c 	ldr	r3, [fp, #-12]
    a430:	e51b2018 	ldr	r2, [fp, #-24]	; 0xffffffe8
    a434:	e0823003 	add	r3, r2, r3
    a438:	e3a02000 	mov	r2, #0
    a43c:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:75
    //precetl jsem radek vstupu, "flush" buffer
    write_pointer = 0;
    a440:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    a444:	e3a02000 	mov	r2, #0
    a448:	e5832004 	str	r2, [r3, #4]
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:76
    return bfr;
    a44c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:77
    }
    a450:	e1a00003 	mov	r0, r3
    a454:	e24bd004 	sub	sp, fp, #4
    a458:	e8bd8800 	pop	{fp, pc}

0000a45c <_ZN6Buffer9Add_BytesEj>:
_ZN6Buffer9Add_BytesEj():
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:79
//pridej @param len byteu do bufferu
void Buffer::Add_Bytes(uint32_t len){
    a45c:	e92d4800 	push	{fp, lr}
    a460:	e28db004 	add	fp, sp, #4
    a464:	e24dd010 	sub	sp, sp, #16
    a468:	e50b0010 	str	r0, [fp, #-16]
    a46c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:80
    for(uint32_t i = 0; i < len; i++){
    a470:	e3a03000 	mov	r3, #0
    a474:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:80 (discriminator 3)
    a478:	e51b2008 	ldr	r2, [fp, #-8]
    a47c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    a480:	e1520003 	cmp	r2, r3
    a484:	2a00000b 	bcs	a4b8 <_ZN6Buffer9Add_BytesEj+0x5c>
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:81 (discriminator 2)
        Add_Byte(buffer[i]);
    a488:	e51b2010 	ldr	r2, [fp, #-16]
    a48c:	e51b3008 	ldr	r3, [fp, #-8]
    a490:	e0823003 	add	r3, r2, r3
    a494:	e2833008 	add	r3, r3, #8
    a498:	e5d33000 	ldrb	r3, [r3]
    a49c:	e1a01003 	mov	r1, r3
    a4a0:	e51b0010 	ldr	r0, [fp, #-16]
    a4a4:	ebffff4e 	bl	a1e4 <_ZN6Buffer8Add_ByteEc>
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:80 (discriminator 2)
    for(uint32_t i = 0; i < len; i++){
    a4a8:	e51b3008 	ldr	r3, [fp, #-8]
    a4ac:	e2833001 	add	r3, r3, #1
    a4b0:	e50b3008 	str	r3, [fp, #-8]
    a4b4:	eaffffef 	b	a478 <_ZN6Buffer9Add_BytesEj+0x1c>
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:83
    }
}
    a4b8:	e320f000 	nop	{0}
    a4bc:	e24bd004 	sub	sp, fp, #4
    a4c0:	e8bd8800 	pop	{fp, pc}

0000a4c4 <_ZN6Buffer23Read_Uart_Line_BlockingEi>:
_ZN6Buffer23Read_Uart_Line_BlockingEi():
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:85
//zablokuj se nad ctenim uartu dokud nedostanes user input
char* Buffer::Read_Uart_Line_Blocking(int expected_type){
    a4c4:	e92d4800 	push	{fp, lr}
    a4c8:	e28db004 	add	fp, sp, #4
    a4cc:	e24dd010 	sub	sp, sp, #16
    a4d0:	e50b0010 	str	r0, [fp, #-16]
    a4d4:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:89
    char* line;
    while(1){
        //samotne cteni neni blokuji -> tocime se dokolecka dokola
        line = Read_Uart_Line();
    a4d8:	e51b0010 	ldr	r0, [fp, #-16]
    a4dc:	ebffff74 	bl	a2b4 <_ZN6Buffer14Read_Uart_LineEv>
    a4e0:	e50b0008 	str	r0, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:91
        //prisel mi vstup od uzivatele
        if(line != nullptr){
    a4e4:	e51b3008 	ldr	r3, [fp, #-8]
    a4e8:	e3530000 	cmp	r3, #0
    a4ec:	0a00000b 	beq	a520 <_ZN6Buffer23Read_Uart_Line_BlockingEi+0x5c>
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:93
            //mrkneme se, co je za datovy typ precteny radek od uzivatele
            int type = get_input_type(line);
    a4f0:	e51b0008 	ldr	r0, [fp, #-8]
    a4f4:	eb0001ba 	bl	abe4 <_Z14get_input_typePKc>
    a4f8:	e50b000c 	str	r0, [fp, #-12]
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:94
            if(type == expected_type)
    a4fc:	e51b200c 	ldr	r2, [fp, #-12]
    a500:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    a504:	e1520003 	cmp	r2, r3
    a508:	0a000006 	beq	a528 <_ZN6Buffer23Read_Uart_Line_BlockingEi+0x64>
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:97
                break;
            //todo lepsi by byla nejaka obecna fce, ktera se vola pri chybe a vypise chybovou hlasku
            Write_Line("Neplatny vstup. Ocekavam cele cislo.\n");
    a50c:	e59f1028 	ldr	r1, [pc, #40]	; a53c <_ZN6Buffer23Read_Uart_Line_BlockingEi+0x78>
    a510:	e51b0010 	ldr	r0, [fp, #-16]
    a514:	ebffff55 	bl	a270 <_ZN6Buffer10Write_LineEPKc>
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:98
            line = nullptr;
    a518:	e3a03000 	mov	r3, #0
    a51c:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:101
        }
        //nic tam nebylo - spi, dokud neprijde IRQ, v pripade semestralky IRQ chodi pouze z UARTU
        asm volatile("wfi");
    a520:	e320f003 	wfi
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:102
    }
    a524:	eaffffeb 	b	a4d8 <_ZN6Buffer23Read_Uart_Line_BlockingEi+0x14>
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:95
                break;
    a528:	e320f000 	nop	{0}
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:103
    return line;
    a52c:	e51b3008 	ldr	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdbuffer.cpp:104
    a530:	e1a00003 	mov	r0, r3
    a534:	e24bd004 	sub	sp, fp, #4
    a538:	e8bd8800 	pop	{fp, pc}
    a53c:	0000c2a4 	andeq	ip, r0, r4, lsr #5

0000a540 <_Z6getpidv>:
_Z6getpidv():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:5
#include <stdfile.h>
#include <stdstring.h>

uint32_t getpid()
{
    a540:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    a544:	e28db000 	add	fp, sp, #0
    a548:	e24dd00c 	sub	sp, sp, #12
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:8
    uint32_t pid;

    asm volatile("swi 0");
    a54c:	ef000000 	svc	0x00000000
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:9
    asm volatile("mov %0, r0" : "=r" (pid));
    a550:	e1a03000 	mov	r3, r0
    a554:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:11

    return pid;
    a558:	e51b3008 	ldr	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:12
}
    a55c:	e1a00003 	mov	r0, r3
    a560:	e28bd000 	add	sp, fp, #0
    a564:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    a568:	e12fff1e 	bx	lr

0000a56c <_Z9terminatei>:
_Z9terminatei():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:15

void terminate(int exitcode)
{
    a56c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    a570:	e28db000 	add	fp, sp, #0
    a574:	e24dd00c 	sub	sp, sp, #12
    a578:	e50b0008 	str	r0, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:16
    asm volatile("mov r0, %0" : : "r" (exitcode));
    a57c:	e51b3008 	ldr	r3, [fp, #-8]
    a580:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:17
    asm volatile("swi 1");
    a584:	ef000001 	svc	0x00000001
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:18
}
    a588:	e320f000 	nop	{0}
    a58c:	e28bd000 	add	sp, fp, #0
    a590:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    a594:	e12fff1e 	bx	lr

0000a598 <_Z11sched_yieldv>:
_Z11sched_yieldv():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:21

void sched_yield()
{
    a598:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    a59c:	e28db000 	add	fp, sp, #0
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:22
    asm volatile("swi 2");
    a5a0:	ef000002 	svc	0x00000002
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:23
}
    a5a4:	e320f000 	nop	{0}
    a5a8:	e28bd000 	add	sp, fp, #0
    a5ac:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    a5b0:	e12fff1e 	bx	lr

0000a5b4 <_Z4openPKc15NFile_Open_Mode>:
_Z4openPKc15NFile_Open_Mode():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:26

uint32_t open(const char* filename, NFile_Open_Mode mode)
{
    a5b4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    a5b8:	e28db000 	add	fp, sp, #0
    a5bc:	e24dd014 	sub	sp, sp, #20
    a5c0:	e50b0010 	str	r0, [fp, #-16]
    a5c4:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:29
    uint32_t file;

    asm volatile("mov r0, %0" : : "r" (filename));
    a5c8:	e51b3010 	ldr	r3, [fp, #-16]
    a5cc:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:30
    asm volatile("mov r1, %0" : : "r" (mode));
    a5d0:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    a5d4:	e1a01003 	mov	r1, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:31
    asm volatile("swi 64");
    a5d8:	ef000040 	svc	0x00000040
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:32
    asm volatile("mov %0, r0" : "=r" (file));
    a5dc:	e1a03000 	mov	r3, r0
    a5e0:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:34

    return file;
    a5e4:	e51b3008 	ldr	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:35
}
    a5e8:	e1a00003 	mov	r0, r3
    a5ec:	e28bd000 	add	sp, fp, #0
    a5f0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    a5f4:	e12fff1e 	bx	lr

0000a5f8 <_Z4readjPcj>:
_Z4readjPcj():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:38

uint32_t read(uint32_t file, char* const buffer, uint32_t size)
{
    a5f8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    a5fc:	e28db000 	add	fp, sp, #0
    a600:	e24dd01c 	sub	sp, sp, #28
    a604:	e50b0010 	str	r0, [fp, #-16]
    a608:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    a60c:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:41
    uint32_t rdnum;

    asm volatile("mov r0, %0" : : "r" (file));
    a610:	e51b3010 	ldr	r3, [fp, #-16]
    a614:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:42
    asm volatile("mov r1, %0" : : "r" (buffer));
    a618:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    a61c:	e1a01003 	mov	r1, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:43
    asm volatile("mov r2, %0" : : "r" (size));
    a620:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    a624:	e1a02003 	mov	r2, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:44
    asm volatile("swi 65");
    a628:	ef000041 	svc	0x00000041
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:45
    asm volatile("mov %0, r0" : "=r" (rdnum));
    a62c:	e1a03000 	mov	r3, r0
    a630:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:47

    return rdnum;
    a634:	e51b3008 	ldr	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:48
}
    a638:	e1a00003 	mov	r0, r3
    a63c:	e28bd000 	add	sp, fp, #0
    a640:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    a644:	e12fff1e 	bx	lr

0000a648 <_Z5writejPKcj>:
_Z5writejPKcj():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:52


uint32_t write(uint32_t file, const char* buffer, uint32_t size)
{
    a648:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    a64c:	e28db000 	add	fp, sp, #0
    a650:	e24dd01c 	sub	sp, sp, #28
    a654:	e50b0010 	str	r0, [fp, #-16]
    a658:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    a65c:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:55
    uint32_t wrnum;

    asm volatile("mov r0, %0" : : "r" (file));
    a660:	e51b3010 	ldr	r3, [fp, #-16]
    a664:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:56
    asm volatile("mov r1, %0" : : "r" (buffer));
    a668:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    a66c:	e1a01003 	mov	r1, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:57
    asm volatile("mov r2, %0" : : "r" (size));
    a670:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    a674:	e1a02003 	mov	r2, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:58
    asm volatile("swi 66");
    a678:	ef000042 	svc	0x00000042
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:59
    asm volatile("mov %0, r0" : "=r" (wrnum));
    a67c:	e1a03000 	mov	r3, r0
    a680:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:61

    return wrnum;
    a684:	e51b3008 	ldr	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:62
}
    a688:	e1a00003 	mov	r0, r3
    a68c:	e28bd000 	add	sp, fp, #0
    a690:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    a694:	e12fff1e 	bx	lr

0000a698 <_Z5closej>:
_Z5closej():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:65

void close(uint32_t file)
{
    a698:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    a69c:	e28db000 	add	fp, sp, #0
    a6a0:	e24dd00c 	sub	sp, sp, #12
    a6a4:	e50b0008 	str	r0, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:66
    asm volatile("mov r0, %0" : : "r" (file));
    a6a8:	e51b3008 	ldr	r3, [fp, #-8]
    a6ac:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:67
    asm volatile("swi 67");
    a6b0:	ef000043 	svc	0x00000043
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:68
}
    a6b4:	e320f000 	nop	{0}
    a6b8:	e28bd000 	add	sp, fp, #0
    a6bc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    a6c0:	e12fff1e 	bx	lr

0000a6c4 <_Z5ioctlj16NIOCtl_OperationPv>:
_Z5ioctlj16NIOCtl_OperationPv():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:71

uint32_t ioctl(uint32_t file, NIOCtl_Operation operation, void* param)
{
    a6c4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    a6c8:	e28db000 	add	fp, sp, #0
    a6cc:	e24dd01c 	sub	sp, sp, #28
    a6d0:	e50b0010 	str	r0, [fp, #-16]
    a6d4:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    a6d8:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:74
    uint32_t retcode;

    asm volatile("mov r0, %0" : : "r" (file));
    a6dc:	e51b3010 	ldr	r3, [fp, #-16]
    a6e0:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:75
    asm volatile("mov r1, %0" : : "r" (operation));
    a6e4:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    a6e8:	e1a01003 	mov	r1, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:76
    asm volatile("mov r2, %0" : : "r" (param));
    a6ec:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    a6f0:	e1a02003 	mov	r2, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:77
    asm volatile("swi 68");
    a6f4:	ef000044 	svc	0x00000044
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:78
    asm volatile("mov %0, r0" : "=r" (retcode));
    a6f8:	e1a03000 	mov	r3, r0
    a6fc:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:80

    return retcode;
    a700:	e51b3008 	ldr	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:81
}
    a704:	e1a00003 	mov	r0, r3
    a708:	e28bd000 	add	sp, fp, #0
    a70c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    a710:	e12fff1e 	bx	lr

0000a714 <_Z6notifyjj>:
_Z6notifyjj():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:84

uint32_t notify(uint32_t file, uint32_t count)
{
    a714:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    a718:	e28db000 	add	fp, sp, #0
    a71c:	e24dd014 	sub	sp, sp, #20
    a720:	e50b0010 	str	r0, [fp, #-16]
    a724:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:87
    uint32_t retcnt;

    asm volatile("mov r0, %0" : : "r" (file));
    a728:	e51b3010 	ldr	r3, [fp, #-16]
    a72c:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:88
    asm volatile("mov r1, %0" : : "r" (count));
    a730:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    a734:	e1a01003 	mov	r1, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:89
    asm volatile("swi 69");
    a738:	ef000045 	svc	0x00000045
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:90
    asm volatile("mov %0, r0" : "=r" (retcnt));
    a73c:	e1a03000 	mov	r3, r0
    a740:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:92

    return retcnt;
    a744:	e51b3008 	ldr	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:93
}
    a748:	e1a00003 	mov	r0, r3
    a74c:	e28bd000 	add	sp, fp, #0
    a750:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    a754:	e12fff1e 	bx	lr

0000a758 <_Z4waitjjj>:
_Z4waitjjj():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:96

NSWI_Result_Code wait(uint32_t file, uint32_t count, uint32_t notified_deadline)
{
    a758:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    a75c:	e28db000 	add	fp, sp, #0
    a760:	e24dd01c 	sub	sp, sp, #28
    a764:	e50b0010 	str	r0, [fp, #-16]
    a768:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    a76c:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:99
    NSWI_Result_Code retcode;

    asm volatile("mov r0, %0" : : "r" (file));
    a770:	e51b3010 	ldr	r3, [fp, #-16]
    a774:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:100
    asm volatile("mov r1, %0" : : "r" (count));
    a778:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    a77c:	e1a01003 	mov	r1, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:101
    asm volatile("mov r2, %0" : : "r" (notified_deadline));
    a780:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    a784:	e1a02003 	mov	r2, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:102
    asm volatile("swi 70");
    a788:	ef000046 	svc	0x00000046
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:103
    asm volatile("mov %0, r0" : "=r" (retcode));
    a78c:	e1a03000 	mov	r3, r0
    a790:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:105

    return retcode;
    a794:	e51b3008 	ldr	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:106
}
    a798:	e1a00003 	mov	r0, r3
    a79c:	e28bd000 	add	sp, fp, #0
    a7a0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    a7a4:	e12fff1e 	bx	lr

0000a7a8 <_Z5sleepjj>:
_Z5sleepjj():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:109

bool sleep(uint32_t ticks, uint32_t notified_deadline)
{
    a7a8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    a7ac:	e28db000 	add	fp, sp, #0
    a7b0:	e24dd014 	sub	sp, sp, #20
    a7b4:	e50b0010 	str	r0, [fp, #-16]
    a7b8:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:112
    uint32_t retcode;

    asm volatile("mov r0, %0" : : "r" (ticks));
    a7bc:	e51b3010 	ldr	r3, [fp, #-16]
    a7c0:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:113
    asm volatile("mov r1, %0" : : "r" (notified_deadline));
    a7c4:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    a7c8:	e1a01003 	mov	r1, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:114
    asm volatile("swi 3");
    a7cc:	ef000003 	svc	0x00000003
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:115
    asm volatile("mov %0, r0" : "=r" (retcode));
    a7d0:	e1a03000 	mov	r3, r0
    a7d4:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:117

    return retcode;
    a7d8:	e51b3008 	ldr	r3, [fp, #-8]
    a7dc:	e3530000 	cmp	r3, #0
    a7e0:	13a03001 	movne	r3, #1
    a7e4:	03a03000 	moveq	r3, #0
    a7e8:	e6ef3073 	uxtb	r3, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:118
}
    a7ec:	e1a00003 	mov	r0, r3
    a7f0:	e28bd000 	add	sp, fp, #0
    a7f4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    a7f8:	e12fff1e 	bx	lr

0000a7fc <_Z24get_active_process_countv>:
_Z24get_active_process_countv():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:121

uint32_t get_active_process_count()
{
    a7fc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    a800:	e28db000 	add	fp, sp, #0
    a804:	e24dd00c 	sub	sp, sp, #12
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:122
    const NGet_Sched_Info_Type req = NGet_Sched_Info_Type::Active_Process_Count;
    a808:	e3a03000 	mov	r3, #0
    a80c:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:125
    uint32_t retval;

    asm volatile("mov r0, %0" : : "r" (req));
    a810:	e3a03000 	mov	r3, #0
    a814:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:126
    asm volatile("mov r1, %0" : : "r" (&retval));
    a818:	e24b300c 	sub	r3, fp, #12
    a81c:	e1a01003 	mov	r1, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:127
    asm volatile("swi 4");
    a820:	ef000004 	svc	0x00000004
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:129

    return retval;
    a824:	e51b300c 	ldr	r3, [fp, #-12]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:130
}
    a828:	e1a00003 	mov	r0, r3
    a82c:	e28bd000 	add	sp, fp, #0
    a830:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    a834:	e12fff1e 	bx	lr

0000a838 <_Z14get_tick_countv>:
_Z14get_tick_countv():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:133

uint32_t get_tick_count()
{
    a838:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    a83c:	e28db000 	add	fp, sp, #0
    a840:	e24dd00c 	sub	sp, sp, #12
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:134
    const NGet_Sched_Info_Type req = NGet_Sched_Info_Type::Tick_Count;
    a844:	e3a03001 	mov	r3, #1
    a848:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:137
    uint32_t retval;

    asm volatile("mov r0, %0" : : "r" (req));
    a84c:	e3a03001 	mov	r3, #1
    a850:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:138
    asm volatile("mov r1, %0" : : "r" (&retval));
    a854:	e24b300c 	sub	r3, fp, #12
    a858:	e1a01003 	mov	r1, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:139
    asm volatile("swi 4");
    a85c:	ef000004 	svc	0x00000004
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:141

    return retval;
    a860:	e51b300c 	ldr	r3, [fp, #-12]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:142
}
    a864:	e1a00003 	mov	r0, r3
    a868:	e28bd000 	add	sp, fp, #0
    a86c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    a870:	e12fff1e 	bx	lr

0000a874 <_Z17set_task_deadlinej>:
_Z17set_task_deadlinej():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:145

void set_task_deadline(uint32_t tick_count_required)
{
    a874:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    a878:	e28db000 	add	fp, sp, #0
    a87c:	e24dd014 	sub	sp, sp, #20
    a880:	e50b0010 	str	r0, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:146
    const NDeadline_Subservice req = NDeadline_Subservice::Set_Relative;
    a884:	e3a03000 	mov	r3, #0
    a888:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:148

    asm volatile("mov r0, %0" : : "r" (req));
    a88c:	e3a03000 	mov	r3, #0
    a890:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:149
    asm volatile("mov r1, %0" : : "r" (&tick_count_required));
    a894:	e24b3010 	sub	r3, fp, #16
    a898:	e1a01003 	mov	r1, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:150
    asm volatile("swi 5");
    a89c:	ef000005 	svc	0x00000005
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:151
}
    a8a0:	e320f000 	nop	{0}
    a8a4:	e28bd000 	add	sp, fp, #0
    a8a8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    a8ac:	e12fff1e 	bx	lr

0000a8b0 <_Z26get_task_ticks_to_deadlinev>:
_Z26get_task_ticks_to_deadlinev():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:154

uint32_t get_task_ticks_to_deadline()
{
    a8b0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    a8b4:	e28db000 	add	fp, sp, #0
    a8b8:	e24dd00c 	sub	sp, sp, #12
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:155
    const NDeadline_Subservice req = NDeadline_Subservice::Get_Remaining;
    a8bc:	e3a03001 	mov	r3, #1
    a8c0:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:158
    uint32_t ticks;

    asm volatile("mov r0, %0" : : "r" (req));
    a8c4:	e3a03001 	mov	r3, #1
    a8c8:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:159
    asm volatile("mov r1, %0" : : "r" (&ticks));
    a8cc:	e24b300c 	sub	r3, fp, #12
    a8d0:	e1a01003 	mov	r1, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:160
    asm volatile("swi 5");
    a8d4:	ef000005 	svc	0x00000005
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:162

    return ticks;
    a8d8:	e51b300c 	ldr	r3, [fp, #-12]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:163
}
    a8dc:	e1a00003 	mov	r0, r3
    a8e0:	e28bd000 	add	sp, fp, #0
    a8e4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    a8e8:	e12fff1e 	bx	lr

0000a8ec <_Z4pipePKcj>:
_Z4pipePKcj():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:168

const char Pipe_File_Prefix[] = "SYS:pipe/";

uint32_t pipe(const char* name, uint32_t buf_size)
{
    a8ec:	e92d4800 	push	{fp, lr}
    a8f0:	e28db004 	add	fp, sp, #4
    a8f4:	e24dd050 	sub	sp, sp, #80	; 0x50
    a8f8:	e50b0050 	str	r0, [fp, #-80]	; 0xffffffb0
    a8fc:	e50b1054 	str	r1, [fp, #-84]	; 0xffffffac
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:170
    char fname[64];
    strncpy(fname, Pipe_File_Prefix, sizeof(Pipe_File_Prefix));
    a900:	e24b3048 	sub	r3, fp, #72	; 0x48
    a904:	e3a0200a 	mov	r2, #10
    a908:	e59f1088 	ldr	r1, [pc, #136]	; a998 <_Z4pipePKcj+0xac>
    a90c:	e1a00003 	mov	r0, r3
    a910:	eb00014a 	bl	ae40 <_Z7strncpyPcPKci>
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:171
    strncpy(fname + sizeof(Pipe_File_Prefix), name, sizeof(fname) - sizeof(Pipe_File_Prefix) - 1);
    a914:	e24b3048 	sub	r3, fp, #72	; 0x48
    a918:	e283300a 	add	r3, r3, #10
    a91c:	e3a02035 	mov	r2, #53	; 0x35
    a920:	e51b1050 	ldr	r1, [fp, #-80]	; 0xffffffb0
    a924:	e1a00003 	mov	r0, r3
    a928:	eb000144 	bl	ae40 <_Z7strncpyPcPKci>
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:173

    int ncur = sizeof(Pipe_File_Prefix) + strlen(name);
    a92c:	e51b0050 	ldr	r0, [fp, #-80]	; 0xffffffb0
    a930:	eb00019d 	bl	afac <_Z6strlenPKc>
    a934:	e1a03000 	mov	r3, r0
    a938:	e283300a 	add	r3, r3, #10
    a93c:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:175

    fname[ncur++] = '#';
    a940:	e51b3008 	ldr	r3, [fp, #-8]
    a944:	e2832001 	add	r2, r3, #1
    a948:	e50b2008 	str	r2, [fp, #-8]
    a94c:	e2433004 	sub	r3, r3, #4
    a950:	e083300b 	add	r3, r3, fp
    a954:	e3a02023 	mov	r2, #35	; 0x23
    a958:	e5432044 	strb	r2, [r3, #-68]	; 0xffffffbc
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:177

    itoa(buf_size, &fname[ncur], 10);
    a95c:	e51b0054 	ldr	r0, [fp, #-84]	; 0xffffffac
    a960:	e24b2048 	sub	r2, fp, #72	; 0x48
    a964:	e51b3008 	ldr	r3, [fp, #-8]
    a968:	e0823003 	add	r3, r2, r3
    a96c:	e3a0200a 	mov	r2, #10
    a970:	e1a01003 	mov	r1, r3
    a974:	eb000009 	bl	a9a0 <_Z4itoaiPcj>
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:179

    return open(fname, NFile_Open_Mode::Read_Write);
    a978:	e24b3048 	sub	r3, fp, #72	; 0x48
    a97c:	e3a01002 	mov	r1, #2
    a980:	e1a00003 	mov	r0, r3
    a984:	ebffff0a 	bl	a5b4 <_Z4openPKc15NFile_Open_Mode>
    a988:	e1a03000 	mov	r3, r0
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:180
}
    a98c:	e1a00003 	mov	r0, r3
    a990:	e24bd004 	sub	sp, fp, #4
    a994:	e8bd8800 	pop	{fp, pc}
    a998:	0000c2f8 	strdeq	ip, [r0], -r8
    a99c:	00000000 	andeq	r0, r0, r0

0000a9a0 <_Z4itoaiPcj>:
_Z4itoaiPcj():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:9
{
    const char CharConvArr[] = "0123456789ABCDEF";
}

void itoa(int input, char* output, unsigned int base)
{
    a9a0:	e92d4800 	push	{fp, lr}
    a9a4:	e28db004 	add	fp, sp, #4
    a9a8:	e24dd020 	sub	sp, sp, #32
    a9ac:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    a9b0:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    a9b4:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:10
    int i = 0;
    a9b8:	e3a03000 	mov	r3, #0
    a9bc:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:11
    int j = 0;
    a9c0:	e3a03000 	mov	r3, #0
    a9c4:	e50b300c 	str	r3, [fp, #-12]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:13

	while (input > 0)
    a9c8:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    a9cc:	e3530000 	cmp	r3, #0
    a9d0:	da000015 	ble	aa2c <_Z4itoaiPcj+0x8c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:15
	{
		output[i] = CharConvArr[input % base];
    a9d4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    a9d8:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    a9dc:	e1a00003 	mov	r0, r3
    a9e0:	eb000380 	bl	b7e8 <__aeabi_uidivmod>
    a9e4:	e1a03001 	mov	r3, r1
    a9e8:	e1a01003 	mov	r1, r3
    a9ec:	e51b3008 	ldr	r3, [fp, #-8]
    a9f0:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    a9f4:	e0823003 	add	r3, r2, r3
    a9f8:	e59f2114 	ldr	r2, [pc, #276]	; ab14 <_Z4itoaiPcj+0x174>
    a9fc:	e7d22001 	ldrb	r2, [r2, r1]
    aa00:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:16
		input /= base;
    aa04:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    aa08:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    aa0c:	e1a00003 	mov	r0, r3
    aa10:	eb0002f9 	bl	b5fc <__udivsi3>
    aa14:	e1a03000 	mov	r3, r0
    aa18:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:17
		i++;
    aa1c:	e51b3008 	ldr	r3, [fp, #-8]
    aa20:	e2833001 	add	r3, r3, #1
    aa24:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:13
	while (input > 0)
    aa28:	eaffffe6 	b	a9c8 <_Z4itoaiPcj+0x28>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:20
	}

    if (i == 0)
    aa2c:	e51b3008 	ldr	r3, [fp, #-8]
    aa30:	e3530000 	cmp	r3, #0
    aa34:	1a000007 	bne	aa58 <_Z4itoaiPcj+0xb8>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:22
    {
        output[i] = CharConvArr[0];
    aa38:	e51b3008 	ldr	r3, [fp, #-8]
    aa3c:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    aa40:	e0823003 	add	r3, r2, r3
    aa44:	e3a02030 	mov	r2, #48	; 0x30
    aa48:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:23
        i++;
    aa4c:	e51b3008 	ldr	r3, [fp, #-8]
    aa50:	e2833001 	add	r3, r3, #1
    aa54:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:26
    }

	output[i] = '\0';
    aa58:	e51b3008 	ldr	r3, [fp, #-8]
    aa5c:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    aa60:	e0823003 	add	r3, r2, r3
    aa64:	e3a02000 	mov	r2, #0
    aa68:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:27
	i--;
    aa6c:	e51b3008 	ldr	r3, [fp, #-8]
    aa70:	e2433001 	sub	r3, r3, #1
    aa74:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:29 (discriminator 2)

	for (j; j <= i/2; j++)
    aa78:	e51b3008 	ldr	r3, [fp, #-8]
    aa7c:	e1a02fa3 	lsr	r2, r3, #31
    aa80:	e0823003 	add	r3, r2, r3
    aa84:	e1a030c3 	asr	r3, r3, #1
    aa88:	e1a02003 	mov	r2, r3
    aa8c:	e51b300c 	ldr	r3, [fp, #-12]
    aa90:	e1530002 	cmp	r3, r2
    aa94:	ca00001b 	bgt	ab08 <_Z4itoaiPcj+0x168>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:31 (discriminator 1)
	{
		char c = output[i - j];
    aa98:	e51b2008 	ldr	r2, [fp, #-8]
    aa9c:	e51b300c 	ldr	r3, [fp, #-12]
    aaa0:	e0423003 	sub	r3, r2, r3
    aaa4:	e1a02003 	mov	r2, r3
    aaa8:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    aaac:	e0833002 	add	r3, r3, r2
    aab0:	e5d33000 	ldrb	r3, [r3]
    aab4:	e54b300d 	strb	r3, [fp, #-13]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:32 (discriminator 1)
		output[i - j] = output[j];
    aab8:	e51b300c 	ldr	r3, [fp, #-12]
    aabc:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    aac0:	e0822003 	add	r2, r2, r3
    aac4:	e51b1008 	ldr	r1, [fp, #-8]
    aac8:	e51b300c 	ldr	r3, [fp, #-12]
    aacc:	e0413003 	sub	r3, r1, r3
    aad0:	e1a01003 	mov	r1, r3
    aad4:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    aad8:	e0833001 	add	r3, r3, r1
    aadc:	e5d22000 	ldrb	r2, [r2]
    aae0:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:33 (discriminator 1)
		output[j] = c;
    aae4:	e51b300c 	ldr	r3, [fp, #-12]
    aae8:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    aaec:	e0823003 	add	r3, r2, r3
    aaf0:	e55b200d 	ldrb	r2, [fp, #-13]
    aaf4:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:29 (discriminator 1)
	for (j; j <= i/2; j++)
    aaf8:	e51b300c 	ldr	r3, [fp, #-12]
    aafc:	e2833001 	add	r3, r3, #1
    ab00:	e50b300c 	str	r3, [fp, #-12]
    ab04:	eaffffdb 	b	aa78 <_Z4itoaiPcj+0xd8>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:36
	}

}
    ab08:	e320f000 	nop	{0}
    ab0c:	e24bd004 	sub	sp, fp, #4
    ab10:	e8bd8800 	pop	{fp, pc}
    ab14:	0000c304 	andeq	ip, r0, r4, lsl #6

0000ab18 <_Z4atoiPKc>:
_Z4atoiPKc():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:39

int atoi(const char* input)
{
    ab18:	e92d4800 	push	{fp, lr}
    ab1c:	e28db004 	add	fp, sp, #4
    ab20:	e24dd010 	sub	sp, sp, #16
    ab24:	e50b0010 	str	r0, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:40
    if(strlen(input) == 1)
    ab28:	e51b0010 	ldr	r0, [fp, #-16]
    ab2c:	eb00011e 	bl	afac <_Z6strlenPKc>
    ab30:	e1a03000 	mov	r3, r0
    ab34:	e3530001 	cmp	r3, #1
    ab38:	03a03001 	moveq	r3, #1
    ab3c:	13a03000 	movne	r3, #0
    ab40:	e6ef3073 	uxtb	r3, r3
    ab44:	e3530000 	cmp	r3, #0
    ab48:	0a000003 	beq	ab5c <_Z4atoiPKc+0x44>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:41
        return *input - '0';
    ab4c:	e51b3010 	ldr	r3, [fp, #-16]
    ab50:	e5d33000 	ldrb	r3, [r3]
    ab54:	e2433030 	sub	r3, r3, #48	; 0x30
    ab58:	ea00001e 	b	abd8 <_Z4atoiPKc+0xc0>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:42
	int output = 0;
    ab5c:	e3a03000 	mov	r3, #0
    ab60:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:44

	while (*input != '\0')
    ab64:	e51b3010 	ldr	r3, [fp, #-16]
    ab68:	e5d33000 	ldrb	r3, [r3]
    ab6c:	e3530000 	cmp	r3, #0
    ab70:	0a000017 	beq	abd4 <_Z4atoiPKc+0xbc>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:46
	{
		output *= 10;
    ab74:	e51b2008 	ldr	r2, [fp, #-8]
    ab78:	e1a03002 	mov	r3, r2
    ab7c:	e1a03103 	lsl	r3, r3, #2
    ab80:	e0833002 	add	r3, r3, r2
    ab84:	e1a03083 	lsl	r3, r3, #1
    ab88:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:47
		if (*input > '9' || *input < '0')
    ab8c:	e51b3010 	ldr	r3, [fp, #-16]
    ab90:	e5d33000 	ldrb	r3, [r3]
    ab94:	e3530039 	cmp	r3, #57	; 0x39
    ab98:	8a00000d 	bhi	abd4 <_Z4atoiPKc+0xbc>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:47 (discriminator 1)
    ab9c:	e51b3010 	ldr	r3, [fp, #-16]
    aba0:	e5d33000 	ldrb	r3, [r3]
    aba4:	e353002f 	cmp	r3, #47	; 0x2f
    aba8:	9a000009 	bls	abd4 <_Z4atoiPKc+0xbc>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:50
			break;

		output += *input - '0';
    abac:	e51b3010 	ldr	r3, [fp, #-16]
    abb0:	e5d33000 	ldrb	r3, [r3]
    abb4:	e2433030 	sub	r3, r3, #48	; 0x30
    abb8:	e51b2008 	ldr	r2, [fp, #-8]
    abbc:	e0823003 	add	r3, r2, r3
    abc0:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:52

		input++;
    abc4:	e51b3010 	ldr	r3, [fp, #-16]
    abc8:	e2833001 	add	r3, r3, #1
    abcc:	e50b3010 	str	r3, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:44
	while (*input != '\0')
    abd0:	eaffffe3 	b	ab64 <_Z4atoiPKc+0x4c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:55
	}

	return output;
    abd4:	e51b3008 	ldr	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:56
}
    abd8:	e1a00003 	mov	r0, r3
    abdc:	e24bd004 	sub	sp, fp, #4
    abe0:	e8bd8800 	pop	{fp, pc}

0000abe4 <_Z14get_input_typePKc>:
_Z14get_input_typePKc():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:60
//return 1 pokud int
//return 2 pokud float
//return 0 pokud neni cislo
int get_input_type(const char * input){
    abe4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    abe8:	e28db000 	add	fp, sp, #0
    abec:	e24dd014 	sub	sp, sp, #20
    abf0:	e50b0010 	str	r0, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:62
    //existence tecky
    bool dot = false;
    abf4:	e3a03000 	mov	r3, #0
    abf8:	e54b3005 	strb	r3, [fp, #-5]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:63
    bool trailing_dot = false;
    abfc:	e3a03000 	mov	r3, #0
    ac00:	e54b3006 	strb	r3, [fp, #-6]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:64
    while(*input != '\0'){
    ac04:	e51b3010 	ldr	r3, [fp, #-16]
    ac08:	e5d33000 	ldrb	r3, [r3]
    ac0c:	e3530000 	cmp	r3, #0
    ac10:	0a000023 	beq	aca4 <_Z14get_input_typePKc+0xc0>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:65
        char c = *input;
    ac14:	e51b3010 	ldr	r3, [fp, #-16]
    ac18:	e5d33000 	ldrb	r3, [r3]
    ac1c:	e54b3007 	strb	r3, [fp, #-7]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:66
        if(c == '.' && !dot){
    ac20:	e55b3007 	ldrb	r3, [fp, #-7]
    ac24:	e353002e 	cmp	r3, #46	; 0x2e
    ac28:	1a00000c 	bne	ac60 <_Z14get_input_typePKc+0x7c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:66 (discriminator 1)
    ac2c:	e55b3005 	ldrb	r3, [fp, #-5]
    ac30:	e2233001 	eor	r3, r3, #1
    ac34:	e6ef3073 	uxtb	r3, r3
    ac38:	e3530000 	cmp	r3, #0
    ac3c:	0a000007 	beq	ac60 <_Z14get_input_typePKc+0x7c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:67 (discriminator 2)
            dot = true;
    ac40:	e3a03001 	mov	r3, #1
    ac44:	e54b3005 	strb	r3, [fp, #-5]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:68 (discriminator 2)
            trailing_dot = true;
    ac48:	e3a03001 	mov	r3, #1
    ac4c:	e54b3006 	strb	r3, [fp, #-6]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:69 (discriminator 2)
            input++;
    ac50:	e51b3010 	ldr	r3, [fp, #-16]
    ac54:	e2833001 	add	r3, r3, #1
    ac58:	e50b3010 	str	r3, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:70 (discriminator 2)
            continue;
    ac5c:	ea00000f 	b	aca0 <_Z14get_input_typePKc+0xbc>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:73
        }
        //nenumericky znak
        if(c < '0' || c > '9')return 0;
    ac60:	e55b3007 	ldrb	r3, [fp, #-7]
    ac64:	e353002f 	cmp	r3, #47	; 0x2f
    ac68:	9a000002 	bls	ac78 <_Z14get_input_typePKc+0x94>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:73 (discriminator 2)
    ac6c:	e55b3007 	ldrb	r3, [fp, #-7]
    ac70:	e3530039 	cmp	r3, #57	; 0x39
    ac74:	9a000001 	bls	ac80 <_Z14get_input_typePKc+0x9c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:73 (discriminator 3)
    ac78:	e3a03000 	mov	r3, #0
    ac7c:	ea000014 	b	acd4 <_Z14get_input_typePKc+0xf0>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:75
        //retezec obsahuje tecku a numericke znaky -> tecka je "validni", tedy neni to tecka na konci intu napriklad
        if(dot)
    ac80:	e55b3005 	ldrb	r3, [fp, #-5]
    ac84:	e3530000 	cmp	r3, #0
    ac88:	0a000001 	beq	ac94 <_Z14get_input_typePKc+0xb0>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:76
            trailing_dot = false;
    ac8c:	e3a03000 	mov	r3, #0
    ac90:	e54b3006 	strb	r3, [fp, #-6]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:77
    input++;
    ac94:	e51b3010 	ldr	r3, [fp, #-16]
    ac98:	e2833001 	add	r3, r3, #1
    ac9c:	e50b3010 	str	r3, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:64
    while(*input != '\0'){
    aca0:	eaffffd7 	b	ac04 <_Z14get_input_typePKc+0x20>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:79
    }
    if(trailing_dot)return 0;
    aca4:	e55b3006 	ldrb	r3, [fp, #-6]
    aca8:	e3530000 	cmp	r3, #0
    acac:	0a000001 	beq	acb8 <_Z14get_input_typePKc+0xd4>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:79 (discriminator 1)
    acb0:	e3a03000 	mov	r3, #0
    acb4:	ea000006 	b	acd4 <_Z14get_input_typePKc+0xf0>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:81
    //float pokud retezec obsahuje non-trailing tecku, 1 pokud je to int
    return dot? 2:1;
    acb8:	e55b3005 	ldrb	r3, [fp, #-5]
    acbc:	e3530000 	cmp	r3, #0
    acc0:	0a000001 	beq	accc <_Z14get_input_typePKc+0xe8>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:81 (discriminator 1)
    acc4:	e3a03002 	mov	r3, #2
    acc8:	ea000000 	b	acd0 <_Z14get_input_typePKc+0xec>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:81 (discriminator 2)
    accc:	e3a03001 	mov	r3, #1
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:81
    acd0:	e320f000 	nop	{0}
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:83

}
    acd4:	e1a00003 	mov	r0, r3
    acd8:	e28bd000 	add	sp, fp, #0
    acdc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    ace0:	e12fff1e 	bx	lr

0000ace4 <_Z4atofPKc>:
_Z4atofPKc():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:87


//string to float
float atof(const char* input){
    ace4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    ace8:	e28db000 	add	fp, sp, #0
    acec:	e24dd03c 	sub	sp, sp, #60	; 0x3c
    acf0:	e50b0038 	str	r0, [fp, #-56]	; 0xffffffc8
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:88
    double output = 0.0;
    acf4:	e3a02000 	mov	r2, #0
    acf8:	e3a03000 	mov	r3, #0
    acfc:	e14b20fc 	strd	r2, [fp, #-12]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:89
    double factor = 10;
    ad00:	e3a02000 	mov	r2, #0
    ad04:	e59f312c 	ldr	r3, [pc, #300]	; ae38 <_Z4atofPKc+0x154>
    ad08:	e14b21fc 	strd	r2, [fp, #-28]	; 0xffffffe4
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:91
    //cast za desetinnou carkou
    double tmp = 0.0;
    ad0c:	e3a02000 	mov	r2, #0
    ad10:	e3a03000 	mov	r3, #0
    ad14:	e14b22f4 	strd	r2, [fp, #-36]	; 0xffffffdc
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:92
    int counter = 0;
    ad18:	e3a03000 	mov	r3, #0
    ad1c:	e50b3028 	str	r3, [fp, #-40]	; 0xffffffd8
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:93
    int scale = 1;
    ad20:	e3a03001 	mov	r3, #1
    ad24:	e50b3010 	str	r3, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:94
    bool afterDecPoint = false;
    ad28:	e3a03000 	mov	r3, #0
    ad2c:	e54b3011 	strb	r3, [fp, #-17]	; 0xffffffef
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:96

    while(*input != '\0'){
    ad30:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    ad34:	e5d33000 	ldrb	r3, [r3]
    ad38:	e3530000 	cmp	r3, #0
    ad3c:	0a000034 	beq	ae14 <_Z4atofPKc+0x130>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:97
        if (*input == '.'){
    ad40:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    ad44:	e5d33000 	ldrb	r3, [r3]
    ad48:	e353002e 	cmp	r3, #46	; 0x2e
    ad4c:	1a000005 	bne	ad68 <_Z4atofPKc+0x84>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:98 (discriminator 1)
            afterDecPoint = true;
    ad50:	e3a03001 	mov	r3, #1
    ad54:	e54b3011 	strb	r3, [fp, #-17]	; 0xffffffef
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:99 (discriminator 1)
            input++;
    ad58:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    ad5c:	e2833001 	add	r3, r3, #1
    ad60:	e50b3038 	str	r3, [fp, #-56]	; 0xffffffc8
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:100 (discriminator 1)
            continue;
    ad64:	ea000029 	b	ae10 <_Z4atofPKc+0x12c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:102
        }
        else if (*input > '9' || *input < '0')break;
    ad68:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    ad6c:	e5d33000 	ldrb	r3, [r3]
    ad70:	e3530039 	cmp	r3, #57	; 0x39
    ad74:	8a000026 	bhi	ae14 <_Z4atofPKc+0x130>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:102 (discriminator 1)
    ad78:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    ad7c:	e5d33000 	ldrb	r3, [r3]
    ad80:	e353002f 	cmp	r3, #47	; 0x2f
    ad84:	9a000022 	bls	ae14 <_Z4atofPKc+0x130>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:103
        double val = *input - '0';
    ad88:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    ad8c:	e5d33000 	ldrb	r3, [r3]
    ad90:	e2433030 	sub	r3, r3, #48	; 0x30
    ad94:	ee073a90 	vmov	s15, r3
    ad98:	eeb87be7 	vcvt.f64.s32	d7, s15
    ad9c:	ed0b7b0d 	vstr	d7, [fp, #-52]	; 0xffffffcc
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:104
        if(afterDecPoint){
    ada0:	e55b3011 	ldrb	r3, [fp, #-17]	; 0xffffffef
    ada4:	e3530000 	cmp	r3, #0
    ada8:	0a00000f 	beq	adec <_Z4atofPKc+0x108>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:105
            scale /= 10;
    adac:	e51b3010 	ldr	r3, [fp, #-16]
    adb0:	e59f2084 	ldr	r2, [pc, #132]	; ae3c <_Z4atofPKc+0x158>
    adb4:	e0c21392 	smull	r1, r2, r2, r3
    adb8:	e1a02142 	asr	r2, r2, #2
    adbc:	e1a03fc3 	asr	r3, r3, #31
    adc0:	e0423003 	sub	r3, r2, r3
    adc4:	e50b3010 	str	r3, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:106
            output = output + val * scale;
    adc8:	e51b3010 	ldr	r3, [fp, #-16]
    adcc:	ee073a90 	vmov	s15, r3
    add0:	eeb86be7 	vcvt.f64.s32	d6, s15
    add4:	ed1b7b0d 	vldr	d7, [fp, #-52]	; 0xffffffcc
    add8:	ee267b07 	vmul.f64	d7, d6, d7
    addc:	ed1b6b03 	vldr	d6, [fp, #-12]
    ade0:	ee367b07 	vadd.f64	d7, d6, d7
    ade4:	ed0b7b03 	vstr	d7, [fp, #-12]
    ade8:	ea000005 	b	ae04 <_Z4atofPKc+0x120>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:109
        }
        else
            output = output * 10 + val;
    adec:	ed1b7b03 	vldr	d7, [fp, #-12]
    adf0:	ed9f6b0e 	vldr	d6, [pc, #56]	; ae30 <_Z4atofPKc+0x14c>
    adf4:	ee277b06 	vmul.f64	d7, d7, d6
    adf8:	ed1b6b0d 	vldr	d6, [fp, #-52]	; 0xffffffcc
    adfc:	ee367b07 	vadd.f64	d7, d6, d7
    ae00:	ed0b7b03 	vstr	d7, [fp, #-12]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:111

        input++;
    ae04:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    ae08:	e2833001 	add	r3, r3, #1
    ae0c:	e50b3038 	str	r3, [fp, #-56]	; 0xffffffc8
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:96
    while(*input != '\0'){
    ae10:	eaffffc6 	b	ad30 <_Z4atofPKc+0x4c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:113
    }
    return output;
    ae14:	ed1b7b03 	vldr	d7, [fp, #-12]
    ae18:	eef77bc7 	vcvt.f32.f64	s15, d7
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:114
}
    ae1c:	eeb00a67 	vmov.f32	s0, s15
    ae20:	e28bd000 	add	sp, fp, #0
    ae24:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    ae28:	e12fff1e 	bx	lr
    ae2c:	e320f000 	nop	{0}
    ae30:	00000000 	andeq	r0, r0, r0
    ae34:	40240000 	eormi	r0, r4, r0
    ae38:	40240000 	eormi	r0, r4, r0
    ae3c:	66666667 	strbtvs	r6, [r6], -r7, ror #12

0000ae40 <_Z7strncpyPcPKci>:
_Z7strncpyPcPKci():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:116
char* strncpy(char* dest, const char *src, int num)
{
    ae40:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    ae44:	e28db000 	add	fp, sp, #0
    ae48:	e24dd01c 	sub	sp, sp, #28
    ae4c:	e50b0010 	str	r0, [fp, #-16]
    ae50:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    ae54:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:119
	int i;

	for (i = 0; i < num && src[i] != '\0'; i++)
    ae58:	e3a03000 	mov	r3, #0
    ae5c:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:119 (discriminator 4)
    ae60:	e51b2008 	ldr	r2, [fp, #-8]
    ae64:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    ae68:	e1520003 	cmp	r2, r3
    ae6c:	aa000011 	bge	aeb8 <_Z7strncpyPcPKci+0x78>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:119 (discriminator 2)
    ae70:	e51b3008 	ldr	r3, [fp, #-8]
    ae74:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    ae78:	e0823003 	add	r3, r2, r3
    ae7c:	e5d33000 	ldrb	r3, [r3]
    ae80:	e3530000 	cmp	r3, #0
    ae84:	0a00000b 	beq	aeb8 <_Z7strncpyPcPKci+0x78>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:120 (discriminator 3)
		dest[i] = src[i];
    ae88:	e51b3008 	ldr	r3, [fp, #-8]
    ae8c:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    ae90:	e0822003 	add	r2, r2, r3
    ae94:	e51b3008 	ldr	r3, [fp, #-8]
    ae98:	e51b1010 	ldr	r1, [fp, #-16]
    ae9c:	e0813003 	add	r3, r1, r3
    aea0:	e5d22000 	ldrb	r2, [r2]
    aea4:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:119 (discriminator 3)
	for (i = 0; i < num && src[i] != '\0'; i++)
    aea8:	e51b3008 	ldr	r3, [fp, #-8]
    aeac:	e2833001 	add	r3, r3, #1
    aeb0:	e50b3008 	str	r3, [fp, #-8]
    aeb4:	eaffffe9 	b	ae60 <_Z7strncpyPcPKci+0x20>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:121 (discriminator 2)
	for (; i < num; i++)
    aeb8:	e51b2008 	ldr	r2, [fp, #-8]
    aebc:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    aec0:	e1520003 	cmp	r2, r3
    aec4:	aa000008 	bge	aeec <_Z7strncpyPcPKci+0xac>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:122 (discriminator 1)
		dest[i] = '\0';
    aec8:	e51b3008 	ldr	r3, [fp, #-8]
    aecc:	e51b2010 	ldr	r2, [fp, #-16]
    aed0:	e0823003 	add	r3, r2, r3
    aed4:	e3a02000 	mov	r2, #0
    aed8:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:121 (discriminator 1)
	for (; i < num; i++)
    aedc:	e51b3008 	ldr	r3, [fp, #-8]
    aee0:	e2833001 	add	r3, r3, #1
    aee4:	e50b3008 	str	r3, [fp, #-8]
    aee8:	eafffff2 	b	aeb8 <_Z7strncpyPcPKci+0x78>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:124

   return dest;
    aeec:	e51b3010 	ldr	r3, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:125
}
    aef0:	e1a00003 	mov	r0, r3
    aef4:	e28bd000 	add	sp, fp, #0
    aef8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    aefc:	e12fff1e 	bx	lr

0000af00 <_Z7strncmpPKcS0_i>:
_Z7strncmpPKcS0_i():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:128

int strncmp(const char *s1, const char *s2, int num)
{
    af00:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    af04:	e28db000 	add	fp, sp, #0
    af08:	e24dd01c 	sub	sp, sp, #28
    af0c:	e50b0010 	str	r0, [fp, #-16]
    af10:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    af14:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:130
	unsigned char u1, u2;
  	while (num-- > 0)
    af18:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    af1c:	e2432001 	sub	r2, r3, #1
    af20:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
    af24:	e3530000 	cmp	r3, #0
    af28:	c3a03001 	movgt	r3, #1
    af2c:	d3a03000 	movle	r3, #0
    af30:	e6ef3073 	uxtb	r3, r3
    af34:	e3530000 	cmp	r3, #0
    af38:	0a000016 	beq	af98 <_Z7strncmpPKcS0_i+0x98>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:132
    {
      	u1 = (unsigned char) *s1++;
    af3c:	e51b3010 	ldr	r3, [fp, #-16]
    af40:	e2832001 	add	r2, r3, #1
    af44:	e50b2010 	str	r2, [fp, #-16]
    af48:	e5d33000 	ldrb	r3, [r3]
    af4c:	e54b3005 	strb	r3, [fp, #-5]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:133
     	u2 = (unsigned char) *s2++;
    af50:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    af54:	e2832001 	add	r2, r3, #1
    af58:	e50b2014 	str	r2, [fp, #-20]	; 0xffffffec
    af5c:	e5d33000 	ldrb	r3, [r3]
    af60:	e54b3006 	strb	r3, [fp, #-6]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:134
      	if (u1 != u2)
    af64:	e55b2005 	ldrb	r2, [fp, #-5]
    af68:	e55b3006 	ldrb	r3, [fp, #-6]
    af6c:	e1520003 	cmp	r2, r3
    af70:	0a000003 	beq	af84 <_Z7strncmpPKcS0_i+0x84>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:135
        	return u1 - u2;
    af74:	e55b2005 	ldrb	r2, [fp, #-5]
    af78:	e55b3006 	ldrb	r3, [fp, #-6]
    af7c:	e0423003 	sub	r3, r2, r3
    af80:	ea000005 	b	af9c <_Z7strncmpPKcS0_i+0x9c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:136
      	if (u1 == '\0')
    af84:	e55b3005 	ldrb	r3, [fp, #-5]
    af88:	e3530000 	cmp	r3, #0
    af8c:	1affffe1 	bne	af18 <_Z7strncmpPKcS0_i+0x18>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:137
        	return 0;
    af90:	e3a03000 	mov	r3, #0
    af94:	ea000000 	b	af9c <_Z7strncmpPKcS0_i+0x9c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:140
    }

  	return 0;
    af98:	e3a03000 	mov	r3, #0
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:141
}
    af9c:	e1a00003 	mov	r0, r3
    afa0:	e28bd000 	add	sp, fp, #0
    afa4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    afa8:	e12fff1e 	bx	lr

0000afac <_Z6strlenPKc>:
_Z6strlenPKc():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:144

int strlen(const char* s)
{
    afac:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    afb0:	e28db000 	add	fp, sp, #0
    afb4:	e24dd014 	sub	sp, sp, #20
    afb8:	e50b0010 	str	r0, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:145
	int i = 0;
    afbc:	e3a03000 	mov	r3, #0
    afc0:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:147

	while (s[i] != '\0')
    afc4:	e51b3008 	ldr	r3, [fp, #-8]
    afc8:	e51b2010 	ldr	r2, [fp, #-16]
    afcc:	e0823003 	add	r3, r2, r3
    afd0:	e5d33000 	ldrb	r3, [r3]
    afd4:	e3530000 	cmp	r3, #0
    afd8:	0a000003 	beq	afec <_Z6strlenPKc+0x40>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:148
		i++;
    afdc:	e51b3008 	ldr	r3, [fp, #-8]
    afe0:	e2833001 	add	r3, r3, #1
    afe4:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:147
	while (s[i] != '\0')
    afe8:	eafffff5 	b	afc4 <_Z6strlenPKc+0x18>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:150

	return i;
    afec:	e51b3008 	ldr	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:151
}
    aff0:	e1a00003 	mov	r0, r3
    aff4:	e28bd000 	add	sp, fp, #0
    aff8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    affc:	e12fff1e 	bx	lr

0000b000 <_Z6strcatPcPKc>:
_Z6strcatPcPKc():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:154
//unsafe varianta
//muze nastat buffer overflow attack
char* strcat(char* dest, const char* src){
    b000:	e92d4800 	push	{fp, lr}
    b004:	e28db004 	add	fp, sp, #4
    b008:	e24dd018 	sub	sp, sp, #24
    b00c:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    b010:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:155
    int n = strlen(src);
    b014:	e51b001c 	ldr	r0, [fp, #-28]	; 0xffffffe4
    b018:	ebffffe3 	bl	afac <_Z6strlenPKc>
    b01c:	e50b0010 	str	r0, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:156
    int m = strlen(dest);
    b020:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    b024:	ebffffe0 	bl	afac <_Z6strlenPKc>
    b028:	e50b0008 	str	r0, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:157
    int walker = 0;
    b02c:	e3a03000 	mov	r3, #0
    b030:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:158
    for(int i = 0;i < n; i++)
    b034:	e3a03000 	mov	r3, #0
    b038:	e50b300c 	str	r3, [fp, #-12]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:158 (discriminator 3)
    b03c:	e51b200c 	ldr	r2, [fp, #-12]
    b040:	e51b3010 	ldr	r3, [fp, #-16]
    b044:	e1520003 	cmp	r2, r3
    b048:	aa00000e 	bge	b088 <_Z6strcatPcPKc+0x88>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:159 (discriminator 2)
        dest[m++] = src[i];
    b04c:	e51b300c 	ldr	r3, [fp, #-12]
    b050:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    b054:	e0822003 	add	r2, r2, r3
    b058:	e51b3008 	ldr	r3, [fp, #-8]
    b05c:	e2831001 	add	r1, r3, #1
    b060:	e50b1008 	str	r1, [fp, #-8]
    b064:	e1a01003 	mov	r1, r3
    b068:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    b06c:	e0833001 	add	r3, r3, r1
    b070:	e5d22000 	ldrb	r2, [r2]
    b074:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:158 (discriminator 2)
    for(int i = 0;i < n; i++)
    b078:	e51b300c 	ldr	r3, [fp, #-12]
    b07c:	e2833001 	add	r3, r3, #1
    b080:	e50b300c 	str	r3, [fp, #-12]
    b084:	eaffffec 	b	b03c <_Z6strcatPcPKc+0x3c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:160
    dest[m] = '\0';
    b088:	e51b3008 	ldr	r3, [fp, #-8]
    b08c:	e51b2018 	ldr	r2, [fp, #-24]	; 0xffffffe8
    b090:	e0823003 	add	r3, r2, r3
    b094:	e3a02000 	mov	r2, #0
    b098:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:161
    return dest;
    b09c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:163

}
    b0a0:	e1a00003 	mov	r0, r3
    b0a4:	e24bd004 	sub	sp, fp, #4
    b0a8:	e8bd8800 	pop	{fp, pc}

0000b0ac <_Z7strncatPcPKci>:
_Z7strncatPcPKci():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:164
char* strncat(char* dest, const char* src,int size){
    b0ac:	e92d4800 	push	{fp, lr}
    b0b0:	e28db004 	add	fp, sp, #4
    b0b4:	e24dd020 	sub	sp, sp, #32
    b0b8:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    b0bc:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    b0c0:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:165
    int walker = 0;
    b0c4:	e3a03000 	mov	r3, #0
    b0c8:	e50b3010 	str	r3, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:167
    //najdi odkud muzeme kopirovat, tedy konec retezce
    int m = strlen(dest);
    b0cc:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    b0d0:	ebffffb5 	bl	afac <_Z6strlenPKc>
    b0d4:	e50b0008 	str	r0, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:169
    //nevejdu se
    if(m >= size)return dest;
    b0d8:	e51b2008 	ldr	r2, [fp, #-8]
    b0dc:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    b0e0:	e1520003 	cmp	r2, r3
    b0e4:	ba000001 	blt	b0f0 <_Z7strncatPcPKci+0x44>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:169 (discriminator 1)
    b0e8:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    b0ec:	ea000021 	b	b178 <_Z7strncatPcPKci+0xcc>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:171

    for(int i = 0;i < size; i++){
    b0f0:	e3a03000 	mov	r3, #0
    b0f4:	e50b300c 	str	r3, [fp, #-12]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:171 (discriminator 1)
    b0f8:	e51b200c 	ldr	r2, [fp, #-12]
    b0fc:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    b100:	e1520003 	cmp	r2, r3
    b104:	aa000015 	bge	b160 <_Z7strncatPcPKci+0xb4>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:172
        if(src[i] == '\0')break;
    b108:	e51b300c 	ldr	r3, [fp, #-12]
    b10c:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    b110:	e0823003 	add	r3, r2, r3
    b114:	e5d33000 	ldrb	r3, [r3]
    b118:	e3530000 	cmp	r3, #0
    b11c:	0a00000e 	beq	b15c <_Z7strncatPcPKci+0xb0>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:173 (discriminator 2)
        dest[m++] = src[i];
    b120:	e51b300c 	ldr	r3, [fp, #-12]
    b124:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    b128:	e0822003 	add	r2, r2, r3
    b12c:	e51b3008 	ldr	r3, [fp, #-8]
    b130:	e2831001 	add	r1, r3, #1
    b134:	e50b1008 	str	r1, [fp, #-8]
    b138:	e1a01003 	mov	r1, r3
    b13c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    b140:	e0833001 	add	r3, r3, r1
    b144:	e5d22000 	ldrb	r2, [r2]
    b148:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:171 (discriminator 2)
    for(int i = 0;i < size; i++){
    b14c:	e51b300c 	ldr	r3, [fp, #-12]
    b150:	e2833001 	add	r3, r3, #1
    b154:	e50b300c 	str	r3, [fp, #-12]
    b158:	eaffffe6 	b	b0f8 <_Z7strncatPcPKci+0x4c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:172
        if(src[i] == '\0')break;
    b15c:	e320f000 	nop	{0}
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:175
    }
    dest[m] = '\0';
    b160:	e51b3008 	ldr	r3, [fp, #-8]
    b164:	e51b2018 	ldr	r2, [fp, #-24]	; 0xffffffe8
    b168:	e0823003 	add	r3, r2, r3
    b16c:	e3a02000 	mov	r2, #0
    b170:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:176
    return dest;
    b174:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:178

}
    b178:	e1a00003 	mov	r0, r3
    b17c:	e24bd004 	sub	sp, fp, #4
    b180:	e8bd8800 	pop	{fp, pc}

0000b184 <_Z5bzeroPvi>:
_Z5bzeroPvi():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:182


void bzero(void* memory, int length)
{
    b184:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    b188:	e28db000 	add	fp, sp, #0
    b18c:	e24dd014 	sub	sp, sp, #20
    b190:	e50b0010 	str	r0, [fp, #-16]
    b194:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:183
	char* mem = reinterpret_cast<char*>(memory);
    b198:	e51b3010 	ldr	r3, [fp, #-16]
    b19c:	e50b300c 	str	r3, [fp, #-12]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:185

	for (int i = 0; i < length; i++)
    b1a0:	e3a03000 	mov	r3, #0
    b1a4:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:185 (discriminator 3)
    b1a8:	e51b2008 	ldr	r2, [fp, #-8]
    b1ac:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    b1b0:	e1520003 	cmp	r2, r3
    b1b4:	aa000008 	bge	b1dc <_Z5bzeroPvi+0x58>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:186 (discriminator 2)
		mem[i] = 0;
    b1b8:	e51b3008 	ldr	r3, [fp, #-8]
    b1bc:	e51b200c 	ldr	r2, [fp, #-12]
    b1c0:	e0823003 	add	r3, r2, r3
    b1c4:	e3a02000 	mov	r2, #0
    b1c8:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:185 (discriminator 2)
	for (int i = 0; i < length; i++)
    b1cc:	e51b3008 	ldr	r3, [fp, #-8]
    b1d0:	e2833001 	add	r3, r3, #1
    b1d4:	e50b3008 	str	r3, [fp, #-8]
    b1d8:	eafffff2 	b	b1a8 <_Z5bzeroPvi+0x24>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:187
}
    b1dc:	e320f000 	nop	{0}
    b1e0:	e28bd000 	add	sp, fp, #0
    b1e4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    b1e8:	e12fff1e 	bx	lr

0000b1ec <_Z6memcpyPKvPvi>:
_Z6memcpyPKvPvi():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:190

void memcpy(const void* src, void* dst, int num)
{
    b1ec:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    b1f0:	e28db000 	add	fp, sp, #0
    b1f4:	e24dd024 	sub	sp, sp, #36	; 0x24
    b1f8:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    b1fc:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    b200:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:191
	const char* memsrc = reinterpret_cast<const char*>(src);
    b204:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    b208:	e50b300c 	str	r3, [fp, #-12]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:192
	char* memdst = reinterpret_cast<char*>(dst);
    b20c:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    b210:	e50b3010 	str	r3, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:194

	for (int i = 0; i < num; i++)
    b214:	e3a03000 	mov	r3, #0
    b218:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:194 (discriminator 3)
    b21c:	e51b2008 	ldr	r2, [fp, #-8]
    b220:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    b224:	e1520003 	cmp	r2, r3
    b228:	aa00000b 	bge	b25c <_Z6memcpyPKvPvi+0x70>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:195 (discriminator 2)
		memdst[i] = memsrc[i];
    b22c:	e51b3008 	ldr	r3, [fp, #-8]
    b230:	e51b200c 	ldr	r2, [fp, #-12]
    b234:	e0822003 	add	r2, r2, r3
    b238:	e51b3008 	ldr	r3, [fp, #-8]
    b23c:	e51b1010 	ldr	r1, [fp, #-16]
    b240:	e0813003 	add	r3, r1, r3
    b244:	e5d22000 	ldrb	r2, [r2]
    b248:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:194 (discriminator 2)
	for (int i = 0; i < num; i++)
    b24c:	e51b3008 	ldr	r3, [fp, #-8]
    b250:	e2833001 	add	r3, r3, #1
    b254:	e50b3008 	str	r3, [fp, #-8]
    b258:	eaffffef 	b	b21c <_Z6memcpyPKvPvi+0x30>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:196
}
    b25c:	e320f000 	nop	{0}
    b260:	e28bd000 	add	sp, fp, #0
    b264:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    b268:	e12fff1e 	bx	lr

0000b26c <_Z4n_tuii>:
_Z4n_tuii():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:201



int n_tu(int number, int count)
{
    b26c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    b270:	e28db000 	add	fp, sp, #0
    b274:	e24dd014 	sub	sp, sp, #20
    b278:	e50b0010 	str	r0, [fp, #-16]
    b27c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:202
    int result = 1;
    b280:	e3a03001 	mov	r3, #1
    b284:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:203
    while(count-- > 0)
    b288:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    b28c:	e2432001 	sub	r2, r3, #1
    b290:	e50b2014 	str	r2, [fp, #-20]	; 0xffffffec
    b294:	e3530000 	cmp	r3, #0
    b298:	c3a03001 	movgt	r3, #1
    b29c:	d3a03000 	movle	r3, #0
    b2a0:	e6ef3073 	uxtb	r3, r3
    b2a4:	e3530000 	cmp	r3, #0
    b2a8:	0a000004 	beq	b2c0 <_Z4n_tuii+0x54>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:204
        result *= number;
    b2ac:	e51b3008 	ldr	r3, [fp, #-8]
    b2b0:	e51b2010 	ldr	r2, [fp, #-16]
    b2b4:	e0030392 	mul	r3, r2, r3
    b2b8:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:203
    while(count-- > 0)
    b2bc:	eafffff1 	b	b288 <_Z4n_tuii+0x1c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:206

    return result;
    b2c0:	e51b3008 	ldr	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:207
}
    b2c4:	e1a00003 	mov	r0, r3
    b2c8:	e28bd000 	add	sp, fp, #0
    b2cc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    b2d0:	e12fff1e 	bx	lr

0000b2d4 <_Z4ftoafPc>:
_Z4ftoafPc():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:211

/*** Convert float to string ***/
void ftoa(float f, char r[])
{
    b2d4:	e92d4bf0 	push	{r4, r5, r6, r7, r8, r9, fp, lr}
    b2d8:	e28db01c 	add	fp, sp, #28
    b2dc:	e24dd068 	sub	sp, sp, #104	; 0x68
    b2e0:	ed0b0a16 	vstr	s0, [fp, #-88]	; 0xffffffa8
    b2e4:	e50b005c 	str	r0, [fp, #-92]	; 0xffffffa4
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:215
    long long int length, length2, i, number, position, sign;
    float number2;

    sign = -1;   // -1 == positive number
    b2e8:	e3e02000 	mvn	r2, #0
    b2ec:	e3e03000 	mvn	r3, #0
    b2f0:	e14b24fc 	strd	r2, [fp, #-76]	; 0xffffffb4
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:216
    if (f < 0)
    b2f4:	ed5b7a16 	vldr	s15, [fp, #-88]	; 0xffffffa8
    b2f8:	eef57ac0 	vcmpe.f32	s15, #0.0
    b2fc:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    b300:	5a000005 	bpl	b31c <_Z4ftoafPc+0x48>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:218
    {
        sign = '-';
    b304:	e3a0202d 	mov	r2, #45	; 0x2d
    b308:	e3a03000 	mov	r3, #0
    b30c:	e14b24fc 	strd	r2, [fp, #-76]	; 0xffffffb4
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:219
        f *= -1;
    b310:	ed5b7a16 	vldr	s15, [fp, #-88]	; 0xffffffa8
    b314:	eef17a67 	vneg.f32	s15, s15
    b318:	ed4b7a16 	vstr	s15, [fp, #-88]	; 0xffffffa8
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:222
    }

    number2 = f;
    b31c:	e51b3058 	ldr	r3, [fp, #-88]	; 0xffffffa8
    b320:	e50b3050 	str	r3, [fp, #-80]	; 0xffffffb0
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:223
    number = f;
    b324:	e51b0058 	ldr	r0, [fp, #-88]	; 0xffffffa8
    b328:	eb000290 	bl	bd70 <__aeabi_f2lz>
    b32c:	e1a02000 	mov	r2, r0
    b330:	e1a03001 	mov	r3, r1
    b334:	e14b23fc 	strd	r2, [fp, #-60]	; 0xffffffc4
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:224
    length = 0;  // Size of decimal part
    b338:	e3a02000 	mov	r2, #0
    b33c:	e3a03000 	mov	r3, #0
    b340:	e14b22f4 	strd	r2, [fp, #-36]	; 0xffffffdc
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:225
    length2 = 0; // Size of tenth
    b344:	e3a02000 	mov	r2, #0
    b348:	e3a03000 	mov	r3, #0
    b34c:	e14b22fc 	strd	r2, [fp, #-44]	; 0xffffffd4
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:228

    /* Calculate length2 tenth part */
    while( (number2 - (float)number) != 0.0 && !((number2 - (float)number) < 0.0) )
    b350:	e14b03dc 	ldrd	r0, [fp, #-60]	; 0xffffffc4
    b354:	eb000231 	bl	bc20 <__aeabi_l2f>
    b358:	ee070a10 	vmov	s14, r0
    b35c:	ed5b7a14 	vldr	s15, [fp, #-80]	; 0xffffffb0
    b360:	ee777ac7 	vsub.f32	s15, s15, s14
    b364:	eef57a40 	vcmp.f32	s15, #0.0
    b368:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    b36c:	0a00001b 	beq	b3e0 <_Z4ftoafPc+0x10c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:228 (discriminator 1)
    b370:	e14b03dc 	ldrd	r0, [fp, #-60]	; 0xffffffc4
    b374:	eb000229 	bl	bc20 <__aeabi_l2f>
    b378:	ee070a10 	vmov	s14, r0
    b37c:	ed5b7a14 	vldr	s15, [fp, #-80]	; 0xffffffb0
    b380:	ee777ac7 	vsub.f32	s15, s15, s14
    b384:	eef57ac0 	vcmpe.f32	s15, #0.0
    b388:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    b38c:	4a000013 	bmi	b3e0 <_Z4ftoafPc+0x10c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:230
    {
        number2 = f * (n_tu(10.0, length2 + 1));
    b390:	e51b302c 	ldr	r3, [fp, #-44]	; 0xffffffd4
    b394:	e2833001 	add	r3, r3, #1
    b398:	e1a01003 	mov	r1, r3
    b39c:	e3a0000a 	mov	r0, #10
    b3a0:	ebffffb1 	bl	b26c <_Z4n_tuii>
    b3a4:	ee070a90 	vmov	s15, r0
    b3a8:	eef87ae7 	vcvt.f32.s32	s15, s15
    b3ac:	ed1b7a16 	vldr	s14, [fp, #-88]	; 0xffffffa8
    b3b0:	ee677a27 	vmul.f32	s15, s14, s15
    b3b4:	ed4b7a14 	vstr	s15, [fp, #-80]	; 0xffffffb0
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:231
        number = number2;
    b3b8:	e51b0050 	ldr	r0, [fp, #-80]	; 0xffffffb0
    b3bc:	eb00026b 	bl	bd70 <__aeabi_f2lz>
    b3c0:	e1a02000 	mov	r2, r0
    b3c4:	e1a03001 	mov	r3, r1
    b3c8:	e14b23fc 	strd	r2, [fp, #-60]	; 0xffffffc4
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:233

        length2++;
    b3cc:	e14b22dc 	ldrd	r2, [fp, #-44]	; 0xffffffd4
    b3d0:	e2926001 	adds	r6, r2, #1
    b3d4:	e2a37000 	adc	r7, r3, #0
    b3d8:	e14b62fc 	strd	r6, [fp, #-44]	; 0xffffffd4
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:228
    while( (number2 - (float)number) != 0.0 && !((number2 - (float)number) < 0.0) )
    b3dc:	eaffffdb 	b	b350 <_Z4ftoafPc+0x7c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:237
    }

    /* Calculate length decimal part */
    for (length = (f > 1) ? 0 : 1; f > 1; length++)
    b3e0:	ed5b7a16 	vldr	s15, [fp, #-88]	; 0xffffffa8
    b3e4:	ed9f7a82 	vldr	s14, [pc, #520]	; b5f4 <_Z4ftoafPc+0x320>
    b3e8:	eef47ac7 	vcmpe.f32	s15, s14
    b3ec:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    b3f0:	c3a03001 	movgt	r3, #1
    b3f4:	d3a03000 	movle	r3, #0
    b3f8:	e6ef3073 	uxtb	r3, r3
    b3fc:	e2233001 	eor	r3, r3, #1
    b400:	e6ef3073 	uxtb	r3, r3
    b404:	e6ef3073 	uxtb	r3, r3
    b408:	e3a02000 	mov	r2, #0
    b40c:	e50b3064 	str	r3, [fp, #-100]	; 0xffffff9c
    b410:	e50b2060 	str	r2, [fp, #-96]	; 0xffffffa0
    b414:	e14b26d4 	ldrd	r2, [fp, #-100]	; 0xffffff9c
    b418:	e14b22f4 	strd	r2, [fp, #-36]	; 0xffffffdc
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:237 (discriminator 3)
    b41c:	ed5b7a16 	vldr	s15, [fp, #-88]	; 0xffffffa8
    b420:	ed9f7a73 	vldr	s14, [pc, #460]	; b5f4 <_Z4ftoafPc+0x320>
    b424:	eef47ac7 	vcmpe.f32	s15, s14
    b428:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    b42c:	da00000b 	ble	b460 <_Z4ftoafPc+0x18c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:238 (discriminator 2)
        f /= 10;
    b430:	ed1b7a16 	vldr	s14, [fp, #-88]	; 0xffffffa8
    b434:	eddf6a6f 	vldr	s13, [pc, #444]	; b5f8 <_Z4ftoafPc+0x324>
    b438:	eec77a26 	vdiv.f32	s15, s14, s13
    b43c:	ed4b7a16 	vstr	s15, [fp, #-88]	; 0xffffffa8
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:237 (discriminator 2)
    for (length = (f > 1) ? 0 : 1; f > 1; length++)
    b440:	e14b22d4 	ldrd	r2, [fp, #-36]	; 0xffffffdc
    b444:	e2921001 	adds	r1, r2, #1
    b448:	e50b106c 	str	r1, [fp, #-108]	; 0xffffff94
    b44c:	e2a33000 	adc	r3, r3, #0
    b450:	e50b3068 	str	r3, [fp, #-104]	; 0xffffff98
    b454:	e14b26dc 	ldrd	r2, [fp, #-108]	; 0xffffff94
    b458:	e14b22f4 	strd	r2, [fp, #-36]	; 0xffffffdc
    b45c:	eaffffee 	b	b41c <_Z4ftoafPc+0x148>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:240

    position = length;
    b460:	e14b22d4 	ldrd	r2, [fp, #-36]	; 0xffffffdc
    b464:	e14b24f4 	strd	r2, [fp, #-68]	; 0xffffffbc
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:241
    length = length + 1 + length2;
    b468:	e14b22d4 	ldrd	r2, [fp, #-36]	; 0xffffffdc
    b46c:	e2924001 	adds	r4, r2, #1
    b470:	e2a35000 	adc	r5, r3, #0
    b474:	e14b22dc 	ldrd	r2, [fp, #-44]	; 0xffffffd4
    b478:	e0921004 	adds	r1, r2, r4
    b47c:	e50b1074 	str	r1, [fp, #-116]	; 0xffffff8c
    b480:	e0a33005 	adc	r3, r3, r5
    b484:	e50b3070 	str	r3, [fp, #-112]	; 0xffffff90
    b488:	e14b27d4 	ldrd	r2, [fp, #-116]	; 0xffffff8c
    b48c:	e14b22f4 	strd	r2, [fp, #-36]	; 0xffffffdc
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:242
    number = number2;
    b490:	e51b0050 	ldr	r0, [fp, #-80]	; 0xffffffb0
    b494:	eb000235 	bl	bd70 <__aeabi_f2lz>
    b498:	e1a02000 	mov	r2, r0
    b49c:	e1a03001 	mov	r3, r1
    b4a0:	e14b23fc 	strd	r2, [fp, #-60]	; 0xffffffc4
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:243
    if (sign == '-')
    b4a4:	e14b24dc 	ldrd	r2, [fp, #-76]	; 0xffffffb4
    b4a8:	e242102d 	sub	r1, r2, #45	; 0x2d
    b4ac:	e1913003 	orrs	r3, r1, r3
    b4b0:	1a00000d 	bne	b4ec <_Z4ftoafPc+0x218>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:245
    {
        length++;
    b4b4:	e14b22d4 	ldrd	r2, [fp, #-36]	; 0xffffffdc
    b4b8:	e2921001 	adds	r1, r2, #1
    b4bc:	e50b107c 	str	r1, [fp, #-124]	; 0xffffff84
    b4c0:	e2a33000 	adc	r3, r3, #0
    b4c4:	e50b3078 	str	r3, [fp, #-120]	; 0xffffff88
    b4c8:	e14b27dc 	ldrd	r2, [fp, #-124]	; 0xffffff84
    b4cc:	e14b22f4 	strd	r2, [fp, #-36]	; 0xffffffdc
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:246
        position++;
    b4d0:	e14b24d4 	ldrd	r2, [fp, #-68]	; 0xffffffbc
    b4d4:	e2921001 	adds	r1, r2, #1
    b4d8:	e50b1084 	str	r1, [fp, #-132]	; 0xffffff7c
    b4dc:	e2a33000 	adc	r3, r3, #0
    b4e0:	e50b3080 	str	r3, [fp, #-128]	; 0xffffff80
    b4e4:	e14b28d4 	ldrd	r2, [fp, #-132]	; 0xffffff7c
    b4e8:	e14b24f4 	strd	r2, [fp, #-68]	; 0xffffffbc
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:249
    }

    for (i = length; i >= 0 ; i--)
    b4ec:	e14b22d4 	ldrd	r2, [fp, #-36]	; 0xffffffdc
    b4f0:	e14b23f4 	strd	r2, [fp, #-52]	; 0xffffffcc
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:249 (discriminator 1)
    b4f4:	e14b23d4 	ldrd	r2, [fp, #-52]	; 0xffffffcc
    b4f8:	e3530000 	cmp	r3, #0
    b4fc:	ba000039 	blt	b5e8 <_Z4ftoafPc+0x314>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:251
    {
        if (i == (length))
    b500:	e14b03d4 	ldrd	r0, [fp, #-52]	; 0xffffffcc
    b504:	e14b22d4 	ldrd	r2, [fp, #-36]	; 0xffffffdc
    b508:	e1510003 	cmp	r1, r3
    b50c:	01500002 	cmpeq	r0, r2
    b510:	1a000005 	bne	b52c <_Z4ftoafPc+0x258>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:252
            r[i] = '\0';
    b514:	e51b3034 	ldr	r3, [fp, #-52]	; 0xffffffcc
    b518:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    b51c:	e0823003 	add	r3, r2, r3
    b520:	e3a02000 	mov	r2, #0
    b524:	e5c32000 	strb	r2, [r3]
    b528:	ea000029 	b	b5d4 <_Z4ftoafPc+0x300>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:253
        else if(i == (position))
    b52c:	e14b03d4 	ldrd	r0, [fp, #-52]	; 0xffffffcc
    b530:	e14b24d4 	ldrd	r2, [fp, #-68]	; 0xffffffbc
    b534:	e1510003 	cmp	r1, r3
    b538:	01500002 	cmpeq	r0, r2
    b53c:	1a000005 	bne	b558 <_Z4ftoafPc+0x284>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:254
            r[i] = '.';
    b540:	e51b3034 	ldr	r3, [fp, #-52]	; 0xffffffcc
    b544:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    b548:	e0823003 	add	r3, r2, r3
    b54c:	e3a0202e 	mov	r2, #46	; 0x2e
    b550:	e5c32000 	strb	r2, [r3]
    b554:	ea00001e 	b	b5d4 <_Z4ftoafPc+0x300>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:255
        else if(sign == '-' && i == 0)
    b558:	e14b24dc 	ldrd	r2, [fp, #-76]	; 0xffffffb4
    b55c:	e242102d 	sub	r1, r2, #45	; 0x2d
    b560:	e1913003 	orrs	r3, r1, r3
    b564:	1a000008 	bne	b58c <_Z4ftoafPc+0x2b8>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:255 (discriminator 1)
    b568:	e14b23d4 	ldrd	r2, [fp, #-52]	; 0xffffffcc
    b56c:	e1923003 	orrs	r3, r2, r3
    b570:	1a000005 	bne	b58c <_Z4ftoafPc+0x2b8>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:256
            r[i] = '-';
    b574:	e51b3034 	ldr	r3, [fp, #-52]	; 0xffffffcc
    b578:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    b57c:	e0823003 	add	r3, r2, r3
    b580:	e3a0202d 	mov	r2, #45	; 0x2d
    b584:	e5c32000 	strb	r2, [r3]
    b588:	ea000011 	b	b5d4 <_Z4ftoafPc+0x300>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:259
        else
        {
            r[i] = (number % 10) + '0';
    b58c:	e14b03dc 	ldrd	r0, [fp, #-60]	; 0xffffffc4
    b590:	e3a0200a 	mov	r2, #10
    b594:	e3a03000 	mov	r3, #0
    b598:	eb0001bf 	bl	bc9c <__aeabi_ldivmod>
    b59c:	e6ef2072 	uxtb	r2, r2
    b5a0:	e51b3034 	ldr	r3, [fp, #-52]	; 0xffffffcc
    b5a4:	e51b105c 	ldr	r1, [fp, #-92]	; 0xffffffa4
    b5a8:	e0813003 	add	r3, r1, r3
    b5ac:	e2822030 	add	r2, r2, #48	; 0x30
    b5b0:	e6ef2072 	uxtb	r2, r2
    b5b4:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:260
            number /=10;
    b5b8:	e14b03dc 	ldrd	r0, [fp, #-60]	; 0xffffffc4
    b5bc:	e3a0200a 	mov	r2, #10
    b5c0:	e3a03000 	mov	r3, #0
    b5c4:	eb0001b4 	bl	bc9c <__aeabi_ldivmod>
    b5c8:	e1a02000 	mov	r2, r0
    b5cc:	e1a03001 	mov	r3, r1
    b5d0:	e14b23fc 	strd	r2, [fp, #-60]	; 0xffffffc4
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:249 (discriminator 2)
    for (i = length; i >= 0 ; i--)
    b5d4:	e14b23d4 	ldrd	r2, [fp, #-52]	; 0xffffffcc
    b5d8:	e2528001 	subs	r8, r2, #1
    b5dc:	e2c39000 	sbc	r9, r3, #0
    b5e0:	e14b83f4 	strd	r8, [fp, #-52]	; 0xffffffcc
    b5e4:	eaffffc2 	b	b4f4 <_Z4ftoafPc+0x220>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:263
        }
    }
}
    b5e8:	e320f000 	nop	{0}
    b5ec:	e24bd01c 	sub	sp, fp, #28
    b5f0:	e8bd8bf0 	pop	{r4, r5, r6, r7, r8, r9, fp, pc}
    b5f4:	3f800000 	svccc	0x00800000
    b5f8:	41200000 			; <UNDEFINED> instruction: 0x41200000

0000b5fc <__udivsi3>:
__udivsi3():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1104
    b5fc:	e2512001 	subs	r2, r1, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1106
    b600:	012fff1e 	bxeq	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1107
    b604:	3a000074 	bcc	b7dc <__udivsi3+0x1e0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1108
    b608:	e1500001 	cmp	r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1109
    b60c:	9a00006b 	bls	b7c0 <__udivsi3+0x1c4>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1110
    b610:	e1110002 	tst	r1, r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1111
    b614:	0a00006c 	beq	b7cc <__udivsi3+0x1d0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1113
    b618:	e16f3f10 	clz	r3, r0
    b61c:	e16f2f11 	clz	r2, r1
    b620:	e0423003 	sub	r3, r2, r3
    b624:	e273301f 	rsbs	r3, r3, #31
    b628:	10833083 	addne	r3, r3, r3, lsl #1
    b62c:	e3a02000 	mov	r2, #0
    b630:	108ff103 	addne	pc, pc, r3, lsl #2
    b634:	e1a00000 	nop			; (mov r0, r0)
    b638:	e1500f81 	cmp	r0, r1, lsl #31
    b63c:	e0a22002 	adc	r2, r2, r2
    b640:	20400f81 	subcs	r0, r0, r1, lsl #31
    b644:	e1500f01 	cmp	r0, r1, lsl #30
    b648:	e0a22002 	adc	r2, r2, r2
    b64c:	20400f01 	subcs	r0, r0, r1, lsl #30
    b650:	e1500e81 	cmp	r0, r1, lsl #29
    b654:	e0a22002 	adc	r2, r2, r2
    b658:	20400e81 	subcs	r0, r0, r1, lsl #29
    b65c:	e1500e01 	cmp	r0, r1, lsl #28
    b660:	e0a22002 	adc	r2, r2, r2
    b664:	20400e01 	subcs	r0, r0, r1, lsl #28
    b668:	e1500d81 	cmp	r0, r1, lsl #27
    b66c:	e0a22002 	adc	r2, r2, r2
    b670:	20400d81 	subcs	r0, r0, r1, lsl #27
    b674:	e1500d01 	cmp	r0, r1, lsl #26
    b678:	e0a22002 	adc	r2, r2, r2
    b67c:	20400d01 	subcs	r0, r0, r1, lsl #26
    b680:	e1500c81 	cmp	r0, r1, lsl #25
    b684:	e0a22002 	adc	r2, r2, r2
    b688:	20400c81 	subcs	r0, r0, r1, lsl #25
    b68c:	e1500c01 	cmp	r0, r1, lsl #24
    b690:	e0a22002 	adc	r2, r2, r2
    b694:	20400c01 	subcs	r0, r0, r1, lsl #24
    b698:	e1500b81 	cmp	r0, r1, lsl #23
    b69c:	e0a22002 	adc	r2, r2, r2
    b6a0:	20400b81 	subcs	r0, r0, r1, lsl #23
    b6a4:	e1500b01 	cmp	r0, r1, lsl #22
    b6a8:	e0a22002 	adc	r2, r2, r2
    b6ac:	20400b01 	subcs	r0, r0, r1, lsl #22
    b6b0:	e1500a81 	cmp	r0, r1, lsl #21
    b6b4:	e0a22002 	adc	r2, r2, r2
    b6b8:	20400a81 	subcs	r0, r0, r1, lsl #21
    b6bc:	e1500a01 	cmp	r0, r1, lsl #20
    b6c0:	e0a22002 	adc	r2, r2, r2
    b6c4:	20400a01 	subcs	r0, r0, r1, lsl #20
    b6c8:	e1500981 	cmp	r0, r1, lsl #19
    b6cc:	e0a22002 	adc	r2, r2, r2
    b6d0:	20400981 	subcs	r0, r0, r1, lsl #19
    b6d4:	e1500901 	cmp	r0, r1, lsl #18
    b6d8:	e0a22002 	adc	r2, r2, r2
    b6dc:	20400901 	subcs	r0, r0, r1, lsl #18
    b6e0:	e1500881 	cmp	r0, r1, lsl #17
    b6e4:	e0a22002 	adc	r2, r2, r2
    b6e8:	20400881 	subcs	r0, r0, r1, lsl #17
    b6ec:	e1500801 	cmp	r0, r1, lsl #16
    b6f0:	e0a22002 	adc	r2, r2, r2
    b6f4:	20400801 	subcs	r0, r0, r1, lsl #16
    b6f8:	e1500781 	cmp	r0, r1, lsl #15
    b6fc:	e0a22002 	adc	r2, r2, r2
    b700:	20400781 	subcs	r0, r0, r1, lsl #15
    b704:	e1500701 	cmp	r0, r1, lsl #14
    b708:	e0a22002 	adc	r2, r2, r2
    b70c:	20400701 	subcs	r0, r0, r1, lsl #14
    b710:	e1500681 	cmp	r0, r1, lsl #13
    b714:	e0a22002 	adc	r2, r2, r2
    b718:	20400681 	subcs	r0, r0, r1, lsl #13
    b71c:	e1500601 	cmp	r0, r1, lsl #12
    b720:	e0a22002 	adc	r2, r2, r2
    b724:	20400601 	subcs	r0, r0, r1, lsl #12
    b728:	e1500581 	cmp	r0, r1, lsl #11
    b72c:	e0a22002 	adc	r2, r2, r2
    b730:	20400581 	subcs	r0, r0, r1, lsl #11
    b734:	e1500501 	cmp	r0, r1, lsl #10
    b738:	e0a22002 	adc	r2, r2, r2
    b73c:	20400501 	subcs	r0, r0, r1, lsl #10
    b740:	e1500481 	cmp	r0, r1, lsl #9
    b744:	e0a22002 	adc	r2, r2, r2
    b748:	20400481 	subcs	r0, r0, r1, lsl #9
    b74c:	e1500401 	cmp	r0, r1, lsl #8
    b750:	e0a22002 	adc	r2, r2, r2
    b754:	20400401 	subcs	r0, r0, r1, lsl #8
    b758:	e1500381 	cmp	r0, r1, lsl #7
    b75c:	e0a22002 	adc	r2, r2, r2
    b760:	20400381 	subcs	r0, r0, r1, lsl #7
    b764:	e1500301 	cmp	r0, r1, lsl #6
    b768:	e0a22002 	adc	r2, r2, r2
    b76c:	20400301 	subcs	r0, r0, r1, lsl #6
    b770:	e1500281 	cmp	r0, r1, lsl #5
    b774:	e0a22002 	adc	r2, r2, r2
    b778:	20400281 	subcs	r0, r0, r1, lsl #5
    b77c:	e1500201 	cmp	r0, r1, lsl #4
    b780:	e0a22002 	adc	r2, r2, r2
    b784:	20400201 	subcs	r0, r0, r1, lsl #4
    b788:	e1500181 	cmp	r0, r1, lsl #3
    b78c:	e0a22002 	adc	r2, r2, r2
    b790:	20400181 	subcs	r0, r0, r1, lsl #3
    b794:	e1500101 	cmp	r0, r1, lsl #2
    b798:	e0a22002 	adc	r2, r2, r2
    b79c:	20400101 	subcs	r0, r0, r1, lsl #2
    b7a0:	e1500081 	cmp	r0, r1, lsl #1
    b7a4:	e0a22002 	adc	r2, r2, r2
    b7a8:	20400081 	subcs	r0, r0, r1, lsl #1
    b7ac:	e1500001 	cmp	r0, r1
    b7b0:	e0a22002 	adc	r2, r2, r2
    b7b4:	20400001 	subcs	r0, r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1115
    b7b8:	e1a00002 	mov	r0, r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1116
    b7bc:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1119
    b7c0:	03a00001 	moveq	r0, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1120
    b7c4:	13a00000 	movne	r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1121
    b7c8:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1123
    b7cc:	e16f2f11 	clz	r2, r1
    b7d0:	e262201f 	rsb	r2, r2, #31
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1125
    b7d4:	e1a00230 	lsr	r0, r0, r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1126
    b7d8:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1130
    b7dc:	e3500000 	cmp	r0, #0
    b7e0:	13e00000 	mvnne	r0, #0
    b7e4:	ea000097 	b	ba48 <__aeabi_idiv0>

0000b7e8 <__aeabi_uidivmod>:
__aeabi_uidivmod():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1161
    b7e8:	e3510000 	cmp	r1, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1162
    b7ec:	0afffffa 	beq	b7dc <__udivsi3+0x1e0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1163
    b7f0:	e92d4003 	push	{r0, r1, lr}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1164
    b7f4:	ebffff80 	bl	b5fc <__udivsi3>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1165
    b7f8:	e8bd4006 	pop	{r1, r2, lr}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1166
    b7fc:	e0030092 	mul	r3, r2, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1167
    b800:	e0411003 	sub	r1, r1, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1168
    b804:	e12fff1e 	bx	lr

0000b808 <__divsi3>:
__divsi3():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1297
    b808:	e3510000 	cmp	r1, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1298
    b80c:	0a000081 	beq	ba18 <.divsi3_skip_div0_test+0x208>

0000b810 <.divsi3_skip_div0_test>:
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1300
    b810:	e020c001 	eor	ip, r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1302
    b814:	42611000 	rsbmi	r1, r1, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1303
    b818:	e2512001 	subs	r2, r1, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1304
    b81c:	0a000070 	beq	b9e4 <.divsi3_skip_div0_test+0x1d4>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1305
    b820:	e1b03000 	movs	r3, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1307
    b824:	42603000 	rsbmi	r3, r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1308
    b828:	e1530001 	cmp	r3, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1309
    b82c:	9a00006f 	bls	b9f0 <.divsi3_skip_div0_test+0x1e0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1310
    b830:	e1110002 	tst	r1, r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1311
    b834:	0a000071 	beq	ba00 <.divsi3_skip_div0_test+0x1f0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1313
    b838:	e16f2f13 	clz	r2, r3
    b83c:	e16f0f11 	clz	r0, r1
    b840:	e0402002 	sub	r2, r0, r2
    b844:	e272201f 	rsbs	r2, r2, #31
    b848:	10822082 	addne	r2, r2, r2, lsl #1
    b84c:	e3a00000 	mov	r0, #0
    b850:	108ff102 	addne	pc, pc, r2, lsl #2
    b854:	e1a00000 	nop			; (mov r0, r0)
    b858:	e1530f81 	cmp	r3, r1, lsl #31
    b85c:	e0a00000 	adc	r0, r0, r0
    b860:	20433f81 	subcs	r3, r3, r1, lsl #31
    b864:	e1530f01 	cmp	r3, r1, lsl #30
    b868:	e0a00000 	adc	r0, r0, r0
    b86c:	20433f01 	subcs	r3, r3, r1, lsl #30
    b870:	e1530e81 	cmp	r3, r1, lsl #29
    b874:	e0a00000 	adc	r0, r0, r0
    b878:	20433e81 	subcs	r3, r3, r1, lsl #29
    b87c:	e1530e01 	cmp	r3, r1, lsl #28
    b880:	e0a00000 	adc	r0, r0, r0
    b884:	20433e01 	subcs	r3, r3, r1, lsl #28
    b888:	e1530d81 	cmp	r3, r1, lsl #27
    b88c:	e0a00000 	adc	r0, r0, r0
    b890:	20433d81 	subcs	r3, r3, r1, lsl #27
    b894:	e1530d01 	cmp	r3, r1, lsl #26
    b898:	e0a00000 	adc	r0, r0, r0
    b89c:	20433d01 	subcs	r3, r3, r1, lsl #26
    b8a0:	e1530c81 	cmp	r3, r1, lsl #25
    b8a4:	e0a00000 	adc	r0, r0, r0
    b8a8:	20433c81 	subcs	r3, r3, r1, lsl #25
    b8ac:	e1530c01 	cmp	r3, r1, lsl #24
    b8b0:	e0a00000 	adc	r0, r0, r0
    b8b4:	20433c01 	subcs	r3, r3, r1, lsl #24
    b8b8:	e1530b81 	cmp	r3, r1, lsl #23
    b8bc:	e0a00000 	adc	r0, r0, r0
    b8c0:	20433b81 	subcs	r3, r3, r1, lsl #23
    b8c4:	e1530b01 	cmp	r3, r1, lsl #22
    b8c8:	e0a00000 	adc	r0, r0, r0
    b8cc:	20433b01 	subcs	r3, r3, r1, lsl #22
    b8d0:	e1530a81 	cmp	r3, r1, lsl #21
    b8d4:	e0a00000 	adc	r0, r0, r0
    b8d8:	20433a81 	subcs	r3, r3, r1, lsl #21
    b8dc:	e1530a01 	cmp	r3, r1, lsl #20
    b8e0:	e0a00000 	adc	r0, r0, r0
    b8e4:	20433a01 	subcs	r3, r3, r1, lsl #20
    b8e8:	e1530981 	cmp	r3, r1, lsl #19
    b8ec:	e0a00000 	adc	r0, r0, r0
    b8f0:	20433981 	subcs	r3, r3, r1, lsl #19
    b8f4:	e1530901 	cmp	r3, r1, lsl #18
    b8f8:	e0a00000 	adc	r0, r0, r0
    b8fc:	20433901 	subcs	r3, r3, r1, lsl #18
    b900:	e1530881 	cmp	r3, r1, lsl #17
    b904:	e0a00000 	adc	r0, r0, r0
    b908:	20433881 	subcs	r3, r3, r1, lsl #17
    b90c:	e1530801 	cmp	r3, r1, lsl #16
    b910:	e0a00000 	adc	r0, r0, r0
    b914:	20433801 	subcs	r3, r3, r1, lsl #16
    b918:	e1530781 	cmp	r3, r1, lsl #15
    b91c:	e0a00000 	adc	r0, r0, r0
    b920:	20433781 	subcs	r3, r3, r1, lsl #15
    b924:	e1530701 	cmp	r3, r1, lsl #14
    b928:	e0a00000 	adc	r0, r0, r0
    b92c:	20433701 	subcs	r3, r3, r1, lsl #14
    b930:	e1530681 	cmp	r3, r1, lsl #13
    b934:	e0a00000 	adc	r0, r0, r0
    b938:	20433681 	subcs	r3, r3, r1, lsl #13
    b93c:	e1530601 	cmp	r3, r1, lsl #12
    b940:	e0a00000 	adc	r0, r0, r0
    b944:	20433601 	subcs	r3, r3, r1, lsl #12
    b948:	e1530581 	cmp	r3, r1, lsl #11
    b94c:	e0a00000 	adc	r0, r0, r0
    b950:	20433581 	subcs	r3, r3, r1, lsl #11
    b954:	e1530501 	cmp	r3, r1, lsl #10
    b958:	e0a00000 	adc	r0, r0, r0
    b95c:	20433501 	subcs	r3, r3, r1, lsl #10
    b960:	e1530481 	cmp	r3, r1, lsl #9
    b964:	e0a00000 	adc	r0, r0, r0
    b968:	20433481 	subcs	r3, r3, r1, lsl #9
    b96c:	e1530401 	cmp	r3, r1, lsl #8
    b970:	e0a00000 	adc	r0, r0, r0
    b974:	20433401 	subcs	r3, r3, r1, lsl #8
    b978:	e1530381 	cmp	r3, r1, lsl #7
    b97c:	e0a00000 	adc	r0, r0, r0
    b980:	20433381 	subcs	r3, r3, r1, lsl #7
    b984:	e1530301 	cmp	r3, r1, lsl #6
    b988:	e0a00000 	adc	r0, r0, r0
    b98c:	20433301 	subcs	r3, r3, r1, lsl #6
    b990:	e1530281 	cmp	r3, r1, lsl #5
    b994:	e0a00000 	adc	r0, r0, r0
    b998:	20433281 	subcs	r3, r3, r1, lsl #5
    b99c:	e1530201 	cmp	r3, r1, lsl #4
    b9a0:	e0a00000 	adc	r0, r0, r0
    b9a4:	20433201 	subcs	r3, r3, r1, lsl #4
    b9a8:	e1530181 	cmp	r3, r1, lsl #3
    b9ac:	e0a00000 	adc	r0, r0, r0
    b9b0:	20433181 	subcs	r3, r3, r1, lsl #3
    b9b4:	e1530101 	cmp	r3, r1, lsl #2
    b9b8:	e0a00000 	adc	r0, r0, r0
    b9bc:	20433101 	subcs	r3, r3, r1, lsl #2
    b9c0:	e1530081 	cmp	r3, r1, lsl #1
    b9c4:	e0a00000 	adc	r0, r0, r0
    b9c8:	20433081 	subcs	r3, r3, r1, lsl #1
    b9cc:	e1530001 	cmp	r3, r1
    b9d0:	e0a00000 	adc	r0, r0, r0
    b9d4:	20433001 	subcs	r3, r3, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1315
    b9d8:	e35c0000 	cmp	ip, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1317
    b9dc:	42600000 	rsbmi	r0, r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1318
    b9e0:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1320
    b9e4:	e13c0000 	teq	ip, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1322
    b9e8:	42600000 	rsbmi	r0, r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1323
    b9ec:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1326
    b9f0:	33a00000 	movcc	r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1328
    b9f4:	01a00fcc 	asreq	r0, ip, #31
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1329
    b9f8:	03800001 	orreq	r0, r0, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1330
    b9fc:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1332
    ba00:	e16f2f11 	clz	r2, r1
    ba04:	e262201f 	rsb	r2, r2, #31
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1334
    ba08:	e35c0000 	cmp	ip, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1335
    ba0c:	e1a00233 	lsr	r0, r3, r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1337
    ba10:	42600000 	rsbmi	r0, r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1338
    ba14:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1342
    ba18:	e3500000 	cmp	r0, #0
    ba1c:	c3e00102 	mvngt	r0, #-2147483648	; 0x80000000
    ba20:	b3a00102 	movlt	r0, #-2147483648	; 0x80000000
    ba24:	ea000007 	b	ba48 <__aeabi_idiv0>

0000ba28 <__aeabi_idivmod>:
__aeabi_idivmod():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1373
    ba28:	e3510000 	cmp	r1, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1374
    ba2c:	0afffff9 	beq	ba18 <.divsi3_skip_div0_test+0x208>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1375
    ba30:	e92d4003 	push	{r0, r1, lr}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1376
    ba34:	ebffff75 	bl	b810 <.divsi3_skip_div0_test>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1377
    ba38:	e8bd4006 	pop	{r1, r2, lr}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1378
    ba3c:	e0030092 	mul	r3, r2, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1379
    ba40:	e0411003 	sub	r1, r1, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1380
    ba44:	e12fff1e 	bx	lr

0000ba48 <__aeabi_idiv0>:
__aeabi_ldiv0():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1466
    ba48:	e12fff1e 	bx	lr

0000ba4c <__aeabi_frsub>:
__aeabi_frsub():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:59
    ba4c:	e2200102 	eor	r0, r0, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:60
    ba50:	ea000000 	b	ba58 <__addsf3>

0000ba54 <__aeabi_fsub>:
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:65
    ba54:	e2211102 	eor	r1, r1, #-2147483648	; 0x80000000

0000ba58 <__addsf3>:
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:74
    ba58:	e1b02080 	lsls	r2, r0, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:76
    ba5c:	11b03081 	lslsne	r3, r1, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:77
    ba60:	11320003 	teqne	r2, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:78
    ba64:	11f0cc42 	mvnsne	ip, r2, asr #24
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:79
    ba68:	11f0cc43 	mvnsne	ip, r3, asr #24
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:80
    ba6c:	0a00003c 	beq	bb64 <__addsf3+0x10c>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:84
    ba70:	e1a02c22 	lsr	r2, r2, #24
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:85
    ba74:	e0723c23 	rsbs	r3, r2, r3, lsr #24
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:87
    ba78:	c0822003 	addgt	r2, r2, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:88
    ba7c:	c0201001 	eorgt	r1, r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:89
    ba80:	c0210000 	eorgt	r0, r1, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:90
    ba84:	c0201001 	eorgt	r1, r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:92
    ba88:	b2633000 	rsblt	r3, r3, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:97
    ba8c:	e3530019 	cmp	r3, #25
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:99
    ba90:	812fff1e 	bxhi	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:102
    ba94:	e3100102 	tst	r0, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:103
    ba98:	e3800502 	orr	r0, r0, #8388608	; 0x800000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:104
    ba9c:	e3c004ff 	bic	r0, r0, #-16777216	; 0xff000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:106
    baa0:	12600000 	rsbne	r0, r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:107
    baa4:	e3110102 	tst	r1, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:108
    baa8:	e3811502 	orr	r1, r1, #8388608	; 0x800000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:109
    baac:	e3c114ff 	bic	r1, r1, #-16777216	; 0xff000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:111
    bab0:	12611000 	rsbne	r1, r1, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:115
    bab4:	e1320003 	teq	r2, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:116
    bab8:	0a000023 	beq	bb4c <__addsf3+0xf4>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:120
    babc:	e2422001 	sub	r2, r2, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:124
    bac0:	e0900351 	adds	r0, r0, r1, asr r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:125
    bac4:	e2633020 	rsb	r3, r3, #32
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:126
    bac8:	e1a01311 	lsl	r1, r1, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:129
    bacc:	e2003102 	and	r3, r0, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:130
    bad0:	5a000001 	bpl	badc <__addsf3+0x84>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:135
    bad4:	e2711000 	rsbs	r1, r1, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:136
    bad8:	e2e00000 	rsc	r0, r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:141
    badc:	e3500502 	cmp	r0, #8388608	; 0x800000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:142
    bae0:	3a00000b 	bcc	bb14 <__addsf3+0xbc>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:143
    bae4:	e3500401 	cmp	r0, #16777216	; 0x1000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:144
    bae8:	3a000004 	bcc	bb00 <__addsf3+0xa8>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:147
    baec:	e1b000a0 	lsrs	r0, r0, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:148
    baf0:	e1a01061 	rrx	r1, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:149
    baf4:	e2822001 	add	r2, r2, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:152
    baf8:	e35200fe 	cmp	r2, #254	; 0xfe
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:153
    bafc:	2a00002d 	bcs	bbb8 <__addsf3+0x160>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:160
    bb00:	e3510102 	cmp	r1, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:161
    bb04:	e0a00b82 	adc	r0, r0, r2, lsl #23
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:163
    bb08:	03c00001 	biceq	r0, r0, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:164
    bb0c:	e1800003 	orr	r0, r0, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:165
    bb10:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:169
    bb14:	e1b01081 	lsls	r1, r1, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:170
    bb18:	e0a00000 	adc	r0, r0, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:171
    bb1c:	e2522001 	subs	r2, r2, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:173
    bb20:	23500502 	cmpcs	r0, #8388608	; 0x800000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:174
    bb24:	2afffff5 	bcs	bb00 <__addsf3+0xa8>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:199
    bb28:	e16fcf10 	clz	ip, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:200
    bb2c:	e24cc008 	sub	ip, ip, #8
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:201
    bb30:	e052200c 	subs	r2, r2, ip
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:202
    bb34:	e1a00c10 	lsl	r0, r0, ip
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:209
    bb38:	a0800b82 	addge	r0, r0, r2, lsl #23
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:210
    bb3c:	b2622000 	rsblt	r2, r2, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:211
    bb40:	a1800003 	orrge	r0, r0, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:217
    bb44:	b1830230 	orrlt	r0, r3, r0, lsr r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:219
    bb48:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:224
    bb4c:	e3320000 	teq	r2, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:225
    bb50:	e2211502 	eor	r1, r1, #8388608	; 0x800000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:227
    bb54:	02200502 	eoreq	r0, r0, #8388608	; 0x800000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:228
    bb58:	02822001 	addeq	r2, r2, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:229
    bb5c:	12433001 	subne	r3, r3, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:230
    bb60:	eaffffd5 	b	babc <__addsf3+0x64>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:233
    bb64:	e1a03081 	lsl	r3, r1, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:235
    bb68:	e1f0cc42 	mvns	ip, r2, asr #24
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:237
    bb6c:	11f0cc43 	mvnsne	ip, r3, asr #24
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:238
    bb70:	0a000013 	beq	bbc4 <__addsf3+0x16c>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:240
    bb74:	e1320003 	teq	r2, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:241
    bb78:	0a000002 	beq	bb88 <__addsf3+0x130>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:244
    bb7c:	e3320000 	teq	r2, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:246
    bb80:	01a00001 	moveq	r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:247
    bb84:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:249
    bb88:	e1300001 	teq	r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:253
    bb8c:	13a00000 	movne	r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:254
    bb90:	112fff1e 	bxne	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:257
    bb94:	e31204ff 	tst	r2, #-16777216	; 0xff000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:258
    bb98:	1a000002 	bne	bba8 <__addsf3+0x150>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:259
    bb9c:	e1b00080 	lsls	r0, r0, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:261
    bba0:	23800102 	orrcs	r0, r0, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:262
    bba4:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:263
    bba8:	e2922402 	adds	r2, r2, #33554432	; 0x2000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:265
    bbac:	32800502 	addcc	r0, r0, #8388608	; 0x800000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:266
    bbb0:	312fff1e 	bxcc	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:267
    bbb4:	e2003102 	and	r3, r0, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:271
    bbb8:	e383047f 	orr	r0, r3, #2130706432	; 0x7f000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:272
    bbbc:	e3800502 	orr	r0, r0, #8388608	; 0x800000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:273
    bbc0:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:282
    bbc4:	e1f02c42 	mvns	r2, r2, asr #24
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:284
    bbc8:	11a00001 	movne	r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:285
    bbcc:	01f03c43 	mvnseq	r3, r3, asr #24
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:286
    bbd0:	11a01000 	movne	r1, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:287
    bbd4:	e1b02480 	lsls	r2, r0, #9
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:289
    bbd8:	01b03481 	lslseq	r3, r1, #9
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:290
    bbdc:	01300001 	teqeq	r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:291
    bbe0:	13800501 	orrne	r0, r0, #4194304	; 0x400000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:292
    bbe4:	e12fff1e 	bx	lr

0000bbe8 <__aeabi_ui2f>:
__aeabi_ui2f():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:305
    bbe8:	e3a03000 	mov	r3, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:306
    bbec:	ea000001 	b	bbf8 <__aeabi_i2f+0x8>

0000bbf0 <__aeabi_i2f>:
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:311
    bbf0:	e2103102 	ands	r3, r0, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:313
    bbf4:	42600000 	rsbmi	r0, r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:315
    bbf8:	e1b0c000 	movs	ip, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:317
    bbfc:	012fff1e 	bxeq	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:320
    bc00:	e383344b 	orr	r3, r3, #1258291200	; 0x4b000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:323
    bc04:	e1a01000 	mov	r1, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:325
    bc08:	e3a00000 	mov	r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:326
    bc0c:	ea00000f 	b	bc50 <__aeabi_l2f+0x30>

0000bc10 <__aeabi_ul2f>:
__floatundisf():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:338
    bc10:	e1902001 	orrs	r2, r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:340
    bc14:	012fff1e 	bxeq	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:342
    bc18:	e3a03000 	mov	r3, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:343
    bc1c:	ea000005 	b	bc38 <__aeabi_l2f+0x18>

0000bc20 <__aeabi_l2f>:
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:348
    bc20:	e1902001 	orrs	r2, r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:350
    bc24:	012fff1e 	bxeq	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:352
    bc28:	e2113102 	ands	r3, r1, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:353
    bc2c:	5a000001 	bpl	bc38 <__aeabi_l2f+0x18>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:358
    bc30:	e2700000 	rsbs	r0, r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:359
    bc34:	e2e11000 	rsc	r1, r1, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:362
    bc38:	e1b0c001 	movs	ip, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:364
    bc3c:	01a0c000 	moveq	ip, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:365
    bc40:	01a01000 	moveq	r1, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:366
    bc44:	03a00000 	moveq	r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:369
    bc48:	e383345b 	orr	r3, r3, #1526726656	; 0x5b000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:371
    bc4c:	02433201 	subeq	r3, r3, #268435456	; 0x10000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:372
    bc50:	e2433502 	sub	r3, r3, #8388608	; 0x800000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:397
    bc54:	e16f2f1c 	clz	r2, ip
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:398
    bc58:	e2522008 	subs	r2, r2, #8
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:402
    bc5c:	e0433b82 	sub	r3, r3, r2, lsl #23
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:403
    bc60:	ba000006 	blt	bc80 <__aeabi_l2f+0x60>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:405
    bc64:	e0833211 	add	r3, r3, r1, lsl r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:406
    bc68:	e1a0c210 	lsl	ip, r0, r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:407
    bc6c:	e2622020 	rsb	r2, r2, #32
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:408
    bc70:	e35c0102 	cmp	ip, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:409
    bc74:	e0a30230 	adc	r0, r3, r0, lsr r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:411
    bc78:	03c00001 	biceq	r0, r0, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:412
    bc7c:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:414
    bc80:	e2822020 	add	r2, r2, #32
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:415
    bc84:	e1a0c211 	lsl	ip, r1, r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:416
    bc88:	e2622020 	rsb	r2, r2, #32
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:417
    bc8c:	e190008c 	orrs	r0, r0, ip, lsl #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:418
    bc90:	e0a30231 	adc	r0, r3, r1, lsr r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:420
    bc94:	01c00fac 	biceq	r0, r0, ip, lsr #31
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:421
    bc98:	e12fff1e 	bx	lr

0000bc9c <__aeabi_ldivmod>:
__aeabi_ldivmod():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:186
    bc9c:	e3530000 	cmp	r3, #0
    bca0:	03520000 	cmpeq	r2, #0
    bca4:	1a000007 	bne	bcc8 <__aeabi_ldivmod+0x2c>
    bca8:	e3510000 	cmp	r1, #0
    bcac:	b3a01102 	movlt	r1, #-2147483648	; 0x80000000
    bcb0:	b3a00000 	movlt	r0, #0
    bcb4:	ba000002 	blt	bcc4 <__aeabi_ldivmod+0x28>
    bcb8:	03500000 	cmpeq	r0, #0
    bcbc:	13e01102 	mvnne	r1, #-2147483648	; 0x80000000
    bcc0:	13e00000 	mvnne	r0, #0
    bcc4:	eaffff5f 	b	ba48 <__aeabi_idiv0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:188
    bcc8:	e24dd008 	sub	sp, sp, #8
    bccc:	e92d6000 	push	{sp, lr}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:189
    bcd0:	e3510000 	cmp	r1, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:190
    bcd4:	ba000006 	blt	bcf4 <__aeabi_ldivmod+0x58>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:191
    bcd8:	e3530000 	cmp	r3, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:192
    bcdc:	ba000011 	blt	bd28 <__aeabi_ldivmod+0x8c>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:194
    bce0:	eb00003e 	bl	bde0 <__udivmoddi4>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:196
    bce4:	e59de004 	ldr	lr, [sp, #4]
    bce8:	e28dd008 	add	sp, sp, #8
    bcec:	e8bd000c 	pop	{r2, r3}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:197
    bcf0:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:201
    bcf4:	e2700000 	rsbs	r0, r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:202
    bcf8:	e0c11081 	sbc	r1, r1, r1, lsl #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:203
    bcfc:	e3530000 	cmp	r3, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:204
    bd00:	ba000011 	blt	bd4c <__aeabi_ldivmod+0xb0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:206
    bd04:	eb000035 	bl	bde0 <__udivmoddi4>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:208
    bd08:	e59de004 	ldr	lr, [sp, #4]
    bd0c:	e28dd008 	add	sp, sp, #8
    bd10:	e8bd000c 	pop	{r2, r3}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:209
    bd14:	e2700000 	rsbs	r0, r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:210
    bd18:	e0c11081 	sbc	r1, r1, r1, lsl #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:211
    bd1c:	e2722000 	rsbs	r2, r2, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:212
    bd20:	e0c33083 	sbc	r3, r3, r3, lsl #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:213
    bd24:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:217
    bd28:	e2722000 	rsbs	r2, r2, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:218
    bd2c:	e0c33083 	sbc	r3, r3, r3, lsl #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:220
    bd30:	eb00002a 	bl	bde0 <__udivmoddi4>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:222
    bd34:	e59de004 	ldr	lr, [sp, #4]
    bd38:	e28dd008 	add	sp, sp, #8
    bd3c:	e8bd000c 	pop	{r2, r3}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:223
    bd40:	e2700000 	rsbs	r0, r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:224
    bd44:	e0c11081 	sbc	r1, r1, r1, lsl #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:225
    bd48:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:229
    bd4c:	e2722000 	rsbs	r2, r2, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:230
    bd50:	e0c33083 	sbc	r3, r3, r3, lsl #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:232
    bd54:	eb000021 	bl	bde0 <__udivmoddi4>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:233
    bd58:	e59de004 	ldr	lr, [sp, #4]
    bd5c:	e28dd008 	add	sp, sp, #8
    bd60:	e8bd000c 	pop	{r2, r3}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:234
    bd64:	e2722000 	rsbs	r2, r2, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:235
    bd68:	e0c33083 	sbc	r3, r3, r3, lsl #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:236
    bd6c:	e12fff1e 	bx	lr

0000bd70 <__aeabi_f2lz>:
__fixsfdi():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1530
    bd70:	ee070a90 	vmov	s15, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1531
    bd74:	eef57ac0 	vcmpe.f32	s15, #0.0
    bd78:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    bd7c:	4a000000 	bmi	bd84 <__aeabi_f2lz+0x14>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1533
    bd80:	ea000006 	b	bda0 <__aeabi_f2ulz>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1532
    bd84:	eef17a67 	vneg.f32	s15, s15
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1530
    bd88:	e92d4010 	push	{r4, lr}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1532
    bd8c:	ee170a90 	vmov	r0, s15
    bd90:	eb000002 	bl	bda0 <__aeabi_f2ulz>
    bd94:	e2700000 	rsbs	r0, r0, #0
    bd98:	e2e11000 	rsc	r1, r1, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1534
    bd9c:	e8bd8010 	pop	{r4, pc}

0000bda0 <__aeabi_f2ulz>:
__fixunssfdi():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1471
    bda0:	ee070a90 	vmov	s15, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1476
    bda4:	ed9f6b09 	vldr	d6, [pc, #36]	; bdd0 <__aeabi_f2ulz+0x30>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1481
    bda8:	ed9f5b0a 	vldr	d5, [pc, #40]	; bdd8 <__aeabi_f2ulz+0x38>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1471
    bdac:	eeb77ae7 	vcvt.f64.f32	d7, s15
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1476
    bdb0:	ee276b06 	vmul.f64	d6, d7, d6
    bdb4:	eebc6bc6 	vcvt.u32.f64	s12, d6
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1481
    bdb8:	eeb84b46 	vcvt.f64.u32	d4, s12
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1524
    bdbc:	ee161a10 	vmov	r1, s12
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1481
    bdc0:	ee047b45 	vmls.f64	d7, d4, d5
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1524
    bdc4:	eefc7bc7 	vcvt.u32.f64	s15, d7
    bdc8:	ee170a90 	vmov	r0, s15
    bdcc:	e12fff1e 	bx	lr
    bdd0:	00000000 	andeq	r0, r0, r0
    bdd4:	3df00000 	ldclcc	0, cr0, [r0]
    bdd8:	00000000 	andeq	r0, r0, r0
    bddc:	41f00000 	mvnsmi	r0, r0

0000bde0 <__udivmoddi4>:
__udivmoddi4():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:960
    bde0:	e1500002 	cmp	r0, r2
    bde4:	e0d1c003 	sbcs	ip, r1, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:948
    bde8:	e92d43f0 	push	{r4, r5, r6, r7, r8, r9, lr}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:949
    bdec:	33a05000 	movcc	r5, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:948
    bdf0:	e59d701c 	ldr	r7, [sp, #28]
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:949
    bdf4:	31a06005 	movcc	r6, r5
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:960
    bdf8:	3a00003b 	bcc	beec <__udivmoddi4+0x10c>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:962
    bdfc:	e3530000 	cmp	r3, #0
    be00:	016fcf12 	clzeq	ip, r2
    be04:	116fef13 	clzne	lr, r3
    be08:	028ce020 	addeq	lr, ip, #32
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:963
    be0c:	e3510000 	cmp	r1, #0
    be10:	016fcf10 	clzeq	ip, r0
    be14:	028cc020 	addeq	ip, ip, #32
    be18:	116fcf11 	clzne	ip, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:965
    be1c:	e04ec00c 	sub	ip, lr, ip
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:966
    be20:	e1a03c13 	lsl	r3, r3, ip
    be24:	e24c9020 	sub	r9, ip, #32
    be28:	e1833912 	orr	r3, r3, r2, lsl r9
    be2c:	e1a04c12 	lsl	r4, r2, ip
    be30:	e26c8020 	rsb	r8, ip, #32
    be34:	e1833832 	orr	r3, r3, r2, lsr r8
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:973
    be38:	e1500004 	cmp	r0, r4
    be3c:	e0d12003 	sbcs	r2, r1, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:949
    be40:	33a05000 	movcc	r5, #0
    be44:	31a06005 	movcc	r6, r5
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:973
    be48:	3a000005 	bcc	be64 <__udivmoddi4+0x84>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:976
    be4c:	e3a05001 	mov	r5, #1
    be50:	e1a06915 	lsl	r6, r5, r9
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:975
    be54:	e0500004 	subs	r0, r0, r4
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:976
    be58:	e1866835 	orr	r6, r6, r5, lsr r8
    be5c:	e1a05c15 	lsl	r5, r5, ip
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:975
    be60:	e0c11003 	sbc	r1, r1, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:979
    be64:	e35c0000 	cmp	ip, #0
    be68:	0a00001f 	beq	beec <__udivmoddi4+0x10c>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:981
    be6c:	e1a040a4 	lsr	r4, r4, #1
    be70:	e1844f83 	orr	r4, r4, r3, lsl #31
    be74:	e1a020a3 	lsr	r2, r3, #1
    be78:	e1a0e00c 	mov	lr, ip
    be7c:	ea000007 	b	bea0 <__udivmoddi4+0xc0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:989
    be80:	e0503004 	subs	r3, r0, r4
    be84:	e0c11002 	sbc	r1, r1, r2
    be88:	e0933003 	adds	r3, r3, r3
    be8c:	e0a11001 	adc	r1, r1, r1
    be90:	e2930001 	adds	r0, r3, #1
    be94:	e2a11000 	adc	r1, r1, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:993
    be98:	e25ee001 	subs	lr, lr, #1
    be9c:	0a000006 	beq	bebc <__udivmoddi4+0xdc>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:988
    bea0:	e1500004 	cmp	r0, r4
    bea4:	e0d13002 	sbcs	r3, r1, r2
    bea8:	2afffff4 	bcs	be80 <__udivmoddi4+0xa0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:991
    beac:	e0900000 	adds	r0, r0, r0
    beb0:	e0a11001 	adc	r1, r1, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:993
    beb4:	e25ee001 	subs	lr, lr, #1
    beb8:	1afffff8 	bne	bea0 <__udivmoddi4+0xc0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:997
    bebc:	e0955000 	adds	r5, r5, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:998
    bec0:	e1a00c30 	lsr	r0, r0, ip
    bec4:	e1800811 	orr	r0, r0, r1, lsl r8
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:997
    bec8:	e0a66001 	adc	r6, r6, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:998
    becc:	e1800931 	orr	r0, r0, r1, lsr r9
    bed0:	e1a01c31 	lsr	r1, r1, ip
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:999
    bed4:	e1a03c10 	lsl	r3, r0, ip
    bed8:	e1a0cc11 	lsl	ip, r1, ip
    bedc:	e18cc910 	orr	ip, ip, r0, lsl r9
    bee0:	e18cc830 	orr	ip, ip, r0, lsr r8
    bee4:	e0555003 	subs	r5, r5, r3
    bee8:	e0c6600c 	sbc	r6, r6, ip
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1003
    beec:	e3570000 	cmp	r7, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1004
    bef0:	11c700f0 	strdne	r0, [r7]
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1006
    bef4:	e1a00005 	mov	r0, r5
    bef8:	e1a01006 	mov	r1, r6
    befc:	e8bd83f0 	pop	{r4, r5, r6, r7, r8, r9, pc}

0000bf00 <memset>:
memset():
/build/newlib-pB30de/newlib-3.3.0/build/arm-none-eabi/arm/v5te/hard/newlib/libc/string/../../../../../../../../newlib/libc/string/memset.c:51
    bf00:	e3100003 	tst	r0, #3
    bf04:	0a00003f 	beq	c008 <memset+0x108>
/build/newlib-pB30de/newlib-3.3.0/build/arm-none-eabi/arm/v5te/hard/newlib/libc/string/../../../../../../../../newlib/libc/string/memset.c:53
    bf08:	e3520000 	cmp	r2, #0
    bf0c:	e2422001 	sub	r2, r2, #1
    bf10:	012fff1e 	bxeq	lr
/build/newlib-pB30de/newlib-3.3.0/build/arm-none-eabi/arm/v5te/hard/newlib/libc/string/../../../../../../../../newlib/libc/string/memset.c:54
    bf14:	e201c0ff 	and	ip, r1, #255	; 0xff
/build/newlib-pB30de/newlib-3.3.0/build/arm-none-eabi/arm/v5te/hard/newlib/libc/string/../../../../../../../../newlib/libc/string/memset.c:42
    bf18:	e1a03000 	mov	r3, r0
    bf1c:	ea000002 	b	bf2c <memset+0x2c>
/build/newlib-pB30de/newlib-3.3.0/build/arm-none-eabi/arm/v5te/hard/newlib/libc/string/../../../../../../../../newlib/libc/string/memset.c:53
    bf20:	e2422001 	sub	r2, r2, #1
    bf24:	e3720001 	cmn	r2, #1
    bf28:	012fff1e 	bxeq	lr
/build/newlib-pB30de/newlib-3.3.0/build/arm-none-eabi/arm/v5te/hard/newlib/libc/string/../../../../../../../../newlib/libc/string/memset.c:54
    bf2c:	e4c3c001 	strb	ip, [r3], #1
/build/newlib-pB30de/newlib-3.3.0/build/arm-none-eabi/arm/v5te/hard/newlib/libc/string/../../../../../../../../newlib/libc/string/memset.c:51
    bf30:	e3130003 	tst	r3, #3
    bf34:	1afffff9 	bne	bf20 <memset+0x20>
/build/newlib-pB30de/newlib-3.3.0/build/arm-none-eabi/arm/v5te/hard/newlib/libc/string/../../../../../../../../newlib/libc/string/memset.c:59
    bf38:	e3520003 	cmp	r2, #3
    bf3c:	9a000027 	bls	bfe0 <memset+0xe0>
/build/newlib-pB30de/newlib-3.3.0/build/arm-none-eabi/arm/v5te/hard/newlib/libc/string/../../../../../../../../newlib/libc/string/memset.c:41
    bf40:	e92d4030 	push	{r4, r5, lr}
/build/newlib-pB30de/newlib-3.3.0/build/arm-none-eabi/arm/v5te/hard/newlib/libc/string/../../../../../../../../newlib/libc/string/memset.c:48
    bf44:	e201e0ff 	and	lr, r1, #255	; 0xff
/build/newlib-pB30de/newlib-3.3.0/build/arm-none-eabi/arm/v5te/hard/newlib/libc/string/../../../../../../../../newlib/libc/string/memset.c:66
    bf48:	e18ee40e 	orr	lr, lr, lr, lsl #8
/build/newlib-pB30de/newlib-3.3.0/build/arm-none-eabi/arm/v5te/hard/newlib/libc/string/../../../../../../../../newlib/libc/string/memset.c:72
    bf4c:	e352000f 	cmp	r2, #15
/build/newlib-pB30de/newlib-3.3.0/build/arm-none-eabi/arm/v5te/hard/newlib/libc/string/../../../../../../../../newlib/libc/string/memset.c:67
    bf50:	e18ee80e 	orr	lr, lr, lr, lsl #16
/build/newlib-pB30de/newlib-3.3.0/build/arm-none-eabi/arm/v5te/hard/newlib/libc/string/../../../../../../../../newlib/libc/string/memset.c:72
    bf54:	9a00002d 	bls	c010 <memset+0x110>
    bf58:	e242c010 	sub	ip, r2, #16
    bf5c:	e3cc400f 	bic	r4, ip, #15
    bf60:	e2835020 	add	r5, r3, #32
    bf64:	e0855004 	add	r5, r5, r4
    bf68:	e1a0422c 	lsr	r4, ip, #4
    bf6c:	e283c010 	add	ip, r3, #16
/build/newlib-pB30de/newlib-3.3.0/build/arm-none-eabi/arm/v5te/hard/newlib/libc/string/../../../../../../../../newlib/libc/string/memset.c:74
    bf70:	e50ce010 	str	lr, [ip, #-16]
/build/newlib-pB30de/newlib-3.3.0/build/arm-none-eabi/arm/v5te/hard/newlib/libc/string/../../../../../../../../newlib/libc/string/memset.c:75
    bf74:	e50ce00c 	str	lr, [ip, #-12]
/build/newlib-pB30de/newlib-3.3.0/build/arm-none-eabi/arm/v5te/hard/newlib/libc/string/../../../../../../../../newlib/libc/string/memset.c:76
    bf78:	e50ce008 	str	lr, [ip, #-8]
/build/newlib-pB30de/newlib-3.3.0/build/arm-none-eabi/arm/v5te/hard/newlib/libc/string/../../../../../../../../newlib/libc/string/memset.c:77
    bf7c:	e50ce004 	str	lr, [ip, #-4]
/build/newlib-pB30de/newlib-3.3.0/build/arm-none-eabi/arm/v5te/hard/newlib/libc/string/../../../../../../../../newlib/libc/string/memset.c:72
    bf80:	e28cc010 	add	ip, ip, #16
    bf84:	e15c0005 	cmp	ip, r5
    bf88:	1afffff8 	bne	bf70 <memset+0x70>
/build/newlib-pB30de/newlib-3.3.0/build/arm-none-eabi/arm/v5te/hard/newlib/libc/string/../../../../../../../../newlib/libc/string/memset.c:77
    bf8c:	e284c001 	add	ip, r4, #1
/build/newlib-pB30de/newlib-3.3.0/build/arm-none-eabi/arm/v5te/hard/newlib/libc/string/../../../../../../../../newlib/libc/string/memset.c:81
    bf90:	e312000c 	tst	r2, #12
/build/newlib-pB30de/newlib-3.3.0/build/arm-none-eabi/arm/v5te/hard/newlib/libc/string/../../../../../../../../newlib/libc/string/memset.c:77
    bf94:	e083c20c 	add	ip, r3, ip, lsl #4
/build/newlib-pB30de/newlib-3.3.0/build/arm-none-eabi/arm/v5te/hard/newlib/libc/string/../../../../../../../../newlib/libc/string/memset.c:78
    bf98:	e202200f 	and	r2, r2, #15
/build/newlib-pB30de/newlib-3.3.0/build/arm-none-eabi/arm/v5te/hard/newlib/libc/string/../../../../../../../../newlib/libc/string/memset.c:81
    bf9c:	0a000017 	beq	c000 <memset+0x100>
    bfa0:	e2423004 	sub	r3, r2, #4
    bfa4:	e3c33003 	bic	r3, r3, #3
    bfa8:	e2833004 	add	r3, r3, #4
    bfac:	e08c3003 	add	r3, ip, r3
/build/newlib-pB30de/newlib-3.3.0/build/arm-none-eabi/arm/v5te/hard/newlib/libc/string/../../../../../../../../newlib/libc/string/memset.c:83
    bfb0:	e48ce004 	str	lr, [ip], #4
/build/newlib-pB30de/newlib-3.3.0/build/arm-none-eabi/arm/v5te/hard/newlib/libc/string/../../../../../../../../newlib/libc/string/memset.c:81
    bfb4:	e153000c 	cmp	r3, ip
    bfb8:	1afffffc 	bne	bfb0 <memset+0xb0>
/build/newlib-pB30de/newlib-3.3.0/build/arm-none-eabi/arm/v5te/hard/newlib/libc/string/../../../../../../../../newlib/libc/string/memset.c:84
    bfbc:	e2022003 	and	r2, r2, #3
/build/newlib-pB30de/newlib-3.3.0/build/arm-none-eabi/arm/v5te/hard/newlib/libc/string/../../../../../../../../newlib/libc/string/memset.c:92
    bfc0:	e3520000 	cmp	r2, #0
    bfc4:	08bd8030 	popeq	{r4, r5, pc}
/build/newlib-pB30de/newlib-3.3.0/build/arm-none-eabi/arm/v5te/hard/newlib/libc/string/../../../../../../../../newlib/libc/string/memset.c:54
    bfc8:	e20110ff 	and	r1, r1, #255	; 0xff
    bfcc:	e0832002 	add	r2, r3, r2
/build/newlib-pB30de/newlib-3.3.0/build/arm-none-eabi/arm/v5te/hard/newlib/libc/string/../../../../../../../../newlib/libc/string/memset.c:93
    bfd0:	e4c31001 	strb	r1, [r3], #1
/build/newlib-pB30de/newlib-3.3.0/build/arm-none-eabi/arm/v5te/hard/newlib/libc/string/../../../../../../../../newlib/libc/string/memset.c:92
    bfd4:	e1520003 	cmp	r2, r3
    bfd8:	1afffffc 	bne	bfd0 <memset+0xd0>
    bfdc:	e8bd8030 	pop	{r4, r5, pc}
    bfe0:	e3520000 	cmp	r2, #0
    bfe4:	012fff1e 	bxeq	lr
/build/newlib-pB30de/newlib-3.3.0/build/arm-none-eabi/arm/v5te/hard/newlib/libc/string/../../../../../../../../newlib/libc/string/memset.c:54
    bfe8:	e20110ff 	and	r1, r1, #255	; 0xff
    bfec:	e0832002 	add	r2, r3, r2
/build/newlib-pB30de/newlib-3.3.0/build/arm-none-eabi/arm/v5te/hard/newlib/libc/string/../../../../../../../../newlib/libc/string/memset.c:93
    bff0:	e4c31001 	strb	r1, [r3], #1
/build/newlib-pB30de/newlib-3.3.0/build/arm-none-eabi/arm/v5te/hard/newlib/libc/string/../../../../../../../../newlib/libc/string/memset.c:92
    bff4:	e1520003 	cmp	r2, r3
    bff8:	1afffffc 	bne	bff0 <memset+0xf0>
    bffc:	e12fff1e 	bx	lr
/build/newlib-pB30de/newlib-3.3.0/build/arm-none-eabi/arm/v5te/hard/newlib/libc/string/../../../../../../../../newlib/libc/string/memset.c:77
    c000:	e1a0300c 	mov	r3, ip
    c004:	eaffffed 	b	bfc0 <memset+0xc0>
/build/newlib-pB30de/newlib-3.3.0/build/arm-none-eabi/arm/v5te/hard/newlib/libc/string/../../../../../../../../newlib/libc/string/memset.c:42
    c008:	e1a03000 	mov	r3, r0
    c00c:	eaffffc9 	b	bf38 <memset+0x38>
/build/newlib-pB30de/newlib-3.3.0/build/arm-none-eabi/arm/v5te/hard/newlib/libc/string/../../../../../../../../newlib/libc/string/memset.c:72
    c010:	e1a0c003 	mov	ip, r3
    c014:	eaffffe1 	b	bfa0 <memset+0xa0>

Disassembly of section .rodata:

0000c018 <_ZL13Lock_Unlocked>:
    c018:	00000000 	andeq	r0, r0, r0

0000c01c <_ZL11Lock_Locked>:
    c01c:	00000001 	andeq	r0, r0, r1

0000c020 <_ZL21MaxFSDriverNameLength>:
    c020:	00000010 	andeq	r0, r0, r0, lsl r0

0000c024 <_ZL17MaxFilenameLength>:
    c024:	00000010 	andeq	r0, r0, r0, lsl r0

0000c028 <_ZL13MaxPathLength>:
    c028:	00000080 	andeq	r0, r0, r0, lsl #1

0000c02c <_ZL18NoFilesystemDriver>:
    c02c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000c030 <_ZL9NotifyAll>:
    c030:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000c034 <_ZL24Max_Process_Opened_Files>:
    c034:	00000010 	andeq	r0, r0, r0, lsl r0

0000c038 <_ZL10Indefinite>:
    c038:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000c03c <_ZL18Deadline_Unchanged>:
    c03c:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

0000c040 <_ZL14Invalid_Handle>:
    c040:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000c044 <_ZL16POPULATION_COUNT>:
    c044:	000003e8 	andeq	r0, r0, r8, ror #7

0000c048 <_ZL11EPOCH_COUNT>:
    c048:	00000032 	andeq	r0, r0, r2, lsr r0

0000c04c <_ZL16DATA_WINDOW_SIZE>:
    c04c:	00000014 	andeq	r0, r0, r4, lsl r0
    c050:	636c6143 	cmnvs	ip, #-1073741808	; 0xc0000010
    c054:	7620534f 	strtvc	r5, [r0], -pc, asr #6
    c058:	0a312e31 	beq	c57924 <__bss_end+0xc4b5e4>
    c05c:	00000000 	andeq	r0, r0, r0
    c060:	6f747541 	svcvs	0x00747541
    c064:	4a203a72 	bmi	81aa34 <__bss_end+0x80e6f4>
    c068:	20697269 	rsbcs	r7, r9, r9, ror #4
    c06c:	66657254 			; <UNDEFINED> instruction: 0x66657254
    c070:	28206c69 	stmdacs	r0!, {r0, r3, r5, r6, sl, fp, sp, lr}
    c074:	4e323241 	cdpmi	2, 3, cr3, cr2, cr1, {2}
    c078:	30363030 	eorscc	r3, r6, r0, lsr r0
    c07c:	000a2950 	andeq	r2, sl, r0, asr r9
    c080:	6564615a 	strbvs	r6, [r4, #-346]!	; 0xfffffea6
    c084:	2065746a 	rsbcs	r7, r5, sl, ror #8
    c088:	706a656e 	rsbvc	r6, sl, lr, ror #10
    c08c:	20657672 	rsbcs	r7, r5, r2, ror r6
    c090:	6f736163 	svcvs	0x00736163
    c094:	72207976 	eorvc	r7, r0, #1933312	; 0x1d8000
    c098:	73657a6f 	cmnvc	r5, #454656	; 0x6f000
    c09c:	20707574 	rsbscs	r7, r0, r4, ror r5
    c0a0:	72702061 	rsbsvc	r2, r0, #97	; 0x61
    c0a4:	6b696465 	blvs	1a65240 <__bss_end+0x1a58f00>
    c0a8:	20696e63 	rsbcs	r6, r9, r3, ror #28
    c0ac:	6e656b6f 	vnmulvs.f64	d22, d5, d31
    c0b0:	76206f6b 	strtvc	r6, [r0], -fp, ror #30
    c0b4:	6e696d20 	cdpvs	13, 6, cr6, cr9, cr0, {1}
    c0b8:	63617475 	cmnvs	r1, #1962934272	; 0x75000000
    c0bc:	00000a68 	andeq	r0, r0, r8, ror #20
    c0c0:	656c6144 	strbvs	r6, [ip, #-324]!	; 0xfffffebc
    c0c4:	646f7020 	strbtvs	r7, [pc], #-32	; c0cc <_ZL16DATA_WINDOW_SIZE+0x80>
    c0c8:	6f726f70 	svcvs	0x00726f70
    c0cc:	796e6176 	stmdbvc	lr!, {r1, r2, r4, r5, r6, r8, sp, lr}^
    c0d0:	69727020 	ldmdbvs	r2!, {r5, ip, sp, lr}^
    c0d4:	797a616b 	ldmdbvc	sl!, {r0, r1, r3, r5, r6, r8, sp, lr}^
    c0d8:	7473203a 	ldrbtvc	r2, [r3], #-58	; 0xffffffc6
    c0dc:	202c706f 	eorcs	r7, ip, pc, rrx
    c0e0:	61726170 	cmnvs	r2, r0, ror r1
    c0e4:	6574656d 	ldrbvs	r6, [r4, #-1389]!	; 0xfffffa93
    c0e8:	000a7372 	andeq	r7, sl, r2, ror r3
    c0ec:	706f7473 	rsbvc	r7, pc, r3, ror r4	; <UNPREDICTABLE>
    c0f0:	7a202d20 	bvc	817578 <__bss_end+0x80b238>
    c0f4:	61747361 	cmnvs	r4, r1, ror #6
    c0f8:	66206976 			; <UNDEFINED> instruction: 0x66206976
    c0fc:	69747469 	ldmdbvs	r4!, {r0, r3, r5, r6, sl, ip, sp, lr}^
    c100:	6d20676e 	stcvs	7, cr6, [r0, #-440]!	; 0xfffffe48
    c104:	6c65646f 	cfstrdvs	mvd6, [r5], #-444	; 0xfffffe44
    c108:	00000a75 	andeq	r0, r0, r5, ror sl
    c10c:	61726170 	cmnvs	r2, r0, ror r1
    c110:	6574656d 	ldrbvs	r6, [r4, #-1389]!	; 0xfffffa93
    c114:	2d207372 	stccs	3, cr7, [r0, #-456]!	; 0xfffffe38
    c118:	70797620 	rsbsvc	r7, r9, r0, lsr #12
    c11c:	20657369 	rsbcs	r7, r5, r9, ror #6
    c120:	61726170 	cmnvs	r2, r0, ror r1
    c124:	7274656d 	rsbsvc	r6, r4, #457179136	; 0x1b400000
    c128:	6f6d2079 	svcvs	0x006d2079
    c12c:	756c6564 	strbvc	r6, [ip, #-1380]!	; 0xfffffa9c
    c130:	0000000a 	andeq	r0, r0, sl
    c134:	3a564544 	bcc	159d64c <__bss_end+0x159130c>
    c138:	74726175 	ldrbtvc	r6, [r2], #-373	; 0xfffffe8b
    c13c:	0000302f 	andeq	r3, r0, pc, lsr #32
    c140:	0000000a 	andeq	r0, r0, sl
    c144:	0000003e 	andeq	r0, r0, lr, lsr r0
    c148:	676e6953 			; <UNDEFINED> instruction: 0x676e6953
    c14c:	7420656c 	strtvc	r6, [r0], #-1388	; 0xfffffa94
    c150:	206b7361 	rsbcs	r7, fp, r1, ror #6
    c154:	656e6f6b 	strbvs	r6, [lr, #-3947]!	; 0xfffff095
    c158:	63202c63 			; <UNDEFINED> instruction: 0x63202c63
    c15c:	796b7561 	stmdbvc	fp!, {r0, r5, r6, r8, sl, ip, sp, lr}^
    c160:	616e6d20 	cmnvs	lr, r0, lsr #26
    c164:	0a796b75 	beq	1e66f40 <__bss_end+0x1e5ac00>
    c168:	00000000 	andeq	r0, r0, r0
    c16c:	202c4b4f 	eorcs	r4, ip, pc, asr #22
    c170:	64657270 	strbtvs	r7, [r5], #-624	; 0xfffffd90
    c174:	65766f70 	ldrbvs	r6, [r6, #-3952]!	; 0xfffff090
    c178:	00002064 	andeq	r2, r0, r4, rrx
    c17c:	202c4b4f 	eorcs	r4, ip, pc, asr #22
    c180:	6b6f726b 	blvs	1be8b34 <__bss_end+0x1bdc7f4>
    c184:	6e61766f 	cdpvs	6, 6, cr7, cr1, cr15, {3}
    c188:	00002069 	andeq	r2, r0, r9, rrx
    c18c:	6e696d20 	cdpvs	13, 6, cr6, cr9, cr0, {1}
    c190:	000a7475 	andeq	r7, sl, r5, ror r4

0000c194 <_ZL13Lock_Unlocked>:
    c194:	00000000 	andeq	r0, r0, r0

0000c198 <_ZL11Lock_Locked>:
    c198:	00000001 	andeq	r0, r0, r1

0000c19c <_ZL21MaxFSDriverNameLength>:
    c19c:	00000010 	andeq	r0, r0, r0, lsl r0

0000c1a0 <_ZL17MaxFilenameLength>:
    c1a0:	00000010 	andeq	r0, r0, r0, lsl r0

0000c1a4 <_ZL13MaxPathLength>:
    c1a4:	00000080 	andeq	r0, r0, r0, lsl #1

0000c1a8 <_ZL18NoFilesystemDriver>:
    c1a8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000c1ac <_ZL9NotifyAll>:
    c1ac:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000c1b0 <_ZL24Max_Process_Opened_Files>:
    c1b0:	00000010 	andeq	r0, r0, r0, lsl r0

0000c1b4 <_ZL10Indefinite>:
    c1b4:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000c1b8 <_ZL18Deadline_Unchanged>:
    c1b8:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

0000c1bc <_ZL14Invalid_Handle>:
    c1bc:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
    c1c0:	0000202c 	andeq	r2, r0, ip, lsr #32
    c1c4:	0000000a 	andeq	r0, r0, sl
    c1c8:	203d2041 	eorscs	r2, sp, r1, asr #32
    c1cc:	3d204200 	sfmcc	f4, 4, [r0, #-0]
    c1d0:	20430020 	subcs	r0, r3, r0, lsr #32
    c1d4:	4400203d 	strmi	r2, [r0], #-61	; 0xffffffc3
    c1d8:	00203d20 	eoreq	r3, r0, r0, lsr #26
    c1dc:	203d2045 	eorscs	r2, sp, r5, asr #32
    c1e0:	00000000 	andeq	r0, r0, r0
    c1e4:	61726170 	cmnvs	r2, r0, ror r1
    c1e8:	6574656d 	ldrbvs	r6, [r4, #-1389]!	; 0xfffffa93
    c1ec:	00007372 	andeq	r7, r0, r2, ror r3
    c1f0:	706f7473 	rsbvc	r7, pc, r3, ror r4	; <UNPREDICTABLE>
    c1f4:	00000000 	andeq	r0, r0, r0
    c1f8:	7473615a 	ldrbtvc	r6, [r3], #-346	; 0xfffffea6
    c1fc:	6a757661 	bvs	1d69b88 <__bss_end+0x1d5d848>
    c200:	79762069 	ldmdbvc	r6!, {r0, r3, r5, r6, sp}^
    c204:	65636f70 	strbvs	r6, [r3, #-3952]!	; 0xfffff090
    c208:	00000a74 	andeq	r0, r0, r4, ror sl
    c20c:	6e7a654e 	cdpvs	5, 7, cr6, cr10, cr14, {2}
    c210:	20796d61 	rsbscs	r6, r9, r1, ror #26
    c214:	6b697270 	blvs	1a68bdc <__bss_end+0x1a5c89c>
    c218:	000a7a61 	andeq	r7, sl, r1, ror #20
    c21c:	6b65634f 	blvs	1964f60 <__bss_end+0x1958c20>
    c220:	6d617661 	stclvs	6, cr7, [r1, #-388]!	; 0xfffffe7c
    c224:	616c6b20 	cmnvs	ip, r0, lsr #22
    c228:	20656e64 	rsbcs	r6, r5, r4, ror #28
    c22c:	6c736963 			; <UNDEFINED> instruction: 0x6c736963
    c230:	000a206f 	andeq	r2, sl, pc, rrx
    c234:	0000003e 	andeq	r0, r0, lr, lsr r0
    c238:	69636f50 	stmdbvs	r3!, {r4, r6, r8, r9, sl, fp, sp, lr}^
    c23c:	2e6d6174 	mcrcs	1, 3, r6, cr13, cr4, {3}
    c240:	000a2e2e 	andeq	r2, sl, lr, lsr #28
    c244:	0a4e614e 	beq	13a4784 <__bss_end+0x1398444>
    c248:	00000000 	andeq	r0, r0, r0

0000c24c <_ZL13Lock_Unlocked>:
    c24c:	00000000 	andeq	r0, r0, r0

0000c250 <_ZL11Lock_Locked>:
    c250:	00000001 	andeq	r0, r0, r1

0000c254 <_ZL21MaxFSDriverNameLength>:
    c254:	00000010 	andeq	r0, r0, r0, lsl r0

0000c258 <_ZL17MaxFilenameLength>:
    c258:	00000010 	andeq	r0, r0, r0, lsl r0

0000c25c <_ZL13MaxPathLength>:
    c25c:	00000080 	andeq	r0, r0, r0, lsl #1

0000c260 <_ZL18NoFilesystemDriver>:
    c260:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000c264 <_ZL9NotifyAll>:
    c264:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000c268 <_ZL24Max_Process_Opened_Files>:
    c268:	00000010 	andeq	r0, r0, r0, lsl r0

0000c26c <_ZL10Indefinite>:
    c26c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000c270 <_ZL18Deadline_Unchanged>:
    c270:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

0000c274 <_ZL14Invalid_Handle>:
    c274:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000c278 <_ZL13Lock_Unlocked>:
    c278:	00000000 	andeq	r0, r0, r0

0000c27c <_ZL11Lock_Locked>:
    c27c:	00000001 	andeq	r0, r0, r1

0000c280 <_ZL21MaxFSDriverNameLength>:
    c280:	00000010 	andeq	r0, r0, r0, lsl r0

0000c284 <_ZL17MaxFilenameLength>:
    c284:	00000010 	andeq	r0, r0, r0, lsl r0

0000c288 <_ZL13MaxPathLength>:
    c288:	00000080 	andeq	r0, r0, r0, lsl #1

0000c28c <_ZL18NoFilesystemDriver>:
    c28c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000c290 <_ZL9NotifyAll>:
    c290:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000c294 <_ZL24Max_Process_Opened_Files>:
    c294:	00000010 	andeq	r0, r0, r0, lsl r0

0000c298 <_ZL10Indefinite>:
    c298:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000c29c <_ZL18Deadline_Unchanged>:
    c29c:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

0000c2a0 <_ZL14Invalid_Handle>:
    c2a0:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
    c2a4:	6c70654e 	cfldr64vs	mvdx6, [r0], #-312	; 0xfffffec8
    c2a8:	796e7461 	stmdbvc	lr!, {r0, r5, r6, sl, ip, sp, lr}^
    c2ac:	74737620 	ldrbtvc	r7, [r3], #-1568	; 0xfffff9e0
    c2b0:	202e7075 	eorcs	r7, lr, r5, ror r0
    c2b4:	6b65634f 	blvs	1964ff8 <__bss_end+0x1958cb8>
    c2b8:	6d617661 	stclvs	6, cr7, [r1, #-388]!	; 0xfffffe7c
    c2bc:	6c656320 	stclvs	3, cr6, [r5], #-128	; 0xffffff80
    c2c0:	69632065 	stmdbvs	r3!, {r0, r2, r5, r6, sp}^
    c2c4:	2e6f6c73 	mcrcs	12, 3, r6, cr15, cr3, {3}
    c2c8:	0000000a 	andeq	r0, r0, sl

0000c2cc <_ZL13Lock_Unlocked>:
    c2cc:	00000000 	andeq	r0, r0, r0

0000c2d0 <_ZL11Lock_Locked>:
    c2d0:	00000001 	andeq	r0, r0, r1

0000c2d4 <_ZL21MaxFSDriverNameLength>:
    c2d4:	00000010 	andeq	r0, r0, r0, lsl r0

0000c2d8 <_ZL17MaxFilenameLength>:
    c2d8:	00000010 	andeq	r0, r0, r0, lsl r0

0000c2dc <_ZL13MaxPathLength>:
    c2dc:	00000080 	andeq	r0, r0, r0, lsl #1

0000c2e0 <_ZL18NoFilesystemDriver>:
    c2e0:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000c2e4 <_ZL9NotifyAll>:
    c2e4:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000c2e8 <_ZL24Max_Process_Opened_Files>:
    c2e8:	00000010 	andeq	r0, r0, r0, lsl r0

0000c2ec <_ZL10Indefinite>:
    c2ec:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000c2f0 <_ZL18Deadline_Unchanged>:
    c2f0:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

0000c2f4 <_ZL14Invalid_Handle>:
    c2f4:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000c2f8 <_ZL16Pipe_File_Prefix>:
    c2f8:	3a535953 	bcc	14e284c <__bss_end+0x14d650c>
    c2fc:	65706970 	ldrbvs	r6, [r0, #-2416]!	; 0xfffff690
    c300:	0000002f 	andeq	r0, r0, pc, lsr #32

0000c304 <_ZN12_GLOBAL__N_1L11CharConvArrE>:
    c304:	33323130 	teqcc	r2, #48, 2
    c308:	37363534 			; <UNDEFINED> instruction: 0x37363534
    c30c:	42413938 	submi	r3, r1, #56, 18	; 0xe0000
    c310:	46454443 	strbmi	r4, [r5], -r3, asr #8
	...

Disassembly of section .ARM.exidx:

0000c318 <.ARM.exidx>:
    c318:	7ffffac8 	svcvc	0x00fffac8
    c31c:	00000001 	andeq	r0, r0, r1

Disassembly of section .data:

0000c320 <__CTOR_LIST__>:
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:2355
    c320:	00009fa0 	andeq	r9, r0, r0, lsr #31

Disassembly of section .bss:

0000c324 <h>:
	...

Disassembly of section .ARM.attributes:

00000000 <.ARM.attributes>:
   0:	00002e41 	andeq	r2, r0, r1, asr #28
   4:	61656100 	cmnvs	r5, r0, lsl #2
   8:	01006962 	tsteq	r0, r2, ror #18
   c:	00000024 	andeq	r0, r0, r4, lsr #32
  10:	4b5a3605 	blmi	168d82c <__bss_end+0x16814ec>
  14:	08070600 	stmdaeq	r7, {r9, sl}
  18:	0a010901 	beq	42424 <__bss_end+0x360e4>
  1c:	14041202 	strne	r1, [r4], #-514	; 0xfffffdfe
  20:	17011501 	strne	r1, [r1, -r1, lsl #10]
  24:	1a011803 	bne	46038 <__bss_end+0x39cf8>
  28:	22011c01 	andcs	r1, r1, #256	; 0x100
  2c:	Address 0x000000000000002c is out of bounds.


Disassembly of section .comment:

00000000 <.comment>:
   0:	3a434347 	bcc	10d0d24 <__bss_end+0x10c49e4>
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
      e0:	db010100 	blle	404e8 <__bss_end+0x341a8>
      e4:	03000000 	movweq	r0, #0
      e8:	00005200 	andeq	r5, r0, r0, lsl #4
      ec:	fb010200 	blx	408f6 <__bss_end+0x345b6>
      f0:	01000d0e 	tsteq	r0, lr, lsl #26
      f4:	00010101 	andeq	r0, r1, r1, lsl #2
      f8:	00010000 	andeq	r0, r1, r0
      fc:	682f0100 	stmdavs	pc!, {r8}	; <UNPREDICTABLE>
     100:	2f656d6f 	svccs	0x00656d6f
     104:	66657274 			; <UNDEFINED> instruction: 0x66657274
     108:	732f6c69 			; <UNDEFINED> instruction: 0x732f6c69
     10c:	732f6d65 			; <UNDEFINED> instruction: 0x732f6d65
     110:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
     114:	752f7365 	strvc	r7, [pc, #-869]!	; fffffdb7 <__bss_end+0xffff3a77>
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
     14c:	0a05830b 	beq	160d80 <__bss_end+0x154a40>
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
     178:	4a030402 	bmi	c1188 <__bss_end+0xb4e48>
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
     1ac:	4a020402 	bmi	811bc <__bss_end+0x74e7c>
     1b0:	02000205 	andeq	r0, r0, #1342177280	; 0x50000000
     1b4:	052d0204 	streq	r0, [sp, #-516]!	; 0xfffffdfc
     1b8:	01058509 	tsteq	r5, r9, lsl #10
     1bc:	000a022f 	andeq	r0, sl, pc, lsr #4
     1c0:	03230101 			; <UNDEFINED> instruction: 0x03230101
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
     228:	752f7365 	strvc	r7, [pc, #-869]!	; fffffecb <__bss_end+0xffff3b8b>
     22c:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
     230:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
     234:	646f6d2f 	strbtvs	r6, [pc], #-3375	; 23c <shift+0x23c>
     238:	745f6c65 	ldrbvc	r6, [pc], #-3173	; 240 <shift+0x240>
     23c:	006b7361 	rsbeq	r7, fp, r1, ror #6
     240:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 18c <shift+0x18c>
     244:	72742f65 	rsbsvc	r2, r4, #404	; 0x194
     248:	6c696665 	stclvs	6, cr6, [r9], #-404	; 0xfffffe6c
     24c:	6d65732f 	stclvs	3, cr7, [r5, #-188]!	; 0xffffff44
     250:	756f732f 	strbvc	r7, [pc, #-815]!	; ffffff29 <__bss_end+0xffff3be9>
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
     2a0:	6b2f2e2e 	blvs	bcbb60 <__bss_end+0xbbf820>
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
     2f4:	752f7365 	strvc	r7, [pc, #-869]!	; ffffff97 <__bss_end+0xffff3c57>
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
     3c4:	0086b002 	addeq	fp, r6, r2
     3c8:	13051600 	movwne	r1, #22016	; 0x5600
     3cc:	83010583 	movwhi	r0, #5507	; 0x1583
     3d0:	01000802 	tsteq	r0, r2, lsl #16
     3d4:	00010501 	andeq	r0, r1, r1, lsl #10
     3d8:	86e00205 	strbthi	r0, [r0], r5, lsl #4
     3dc:	0d030000 	stceq	0, cr0, [r3, #-0]
     3e0:	83130501 	tsthi	r3, #4194304	; 0x400000
     3e4:	02830105 	addeq	r0, r3, #1073741825	; 0x40000001
     3e8:	01010008 	tsteq	r1, r8
     3ec:	1d050204 	sfmne	f0, 4, [r5, #-16]
     3f0:	2c020500 	cfstr32cs	mvfx0, [r2], {-0}
     3f4:	03000082 	movweq	r0, #130	; 0x82
     3f8:	0d05010f 	stfeqs	f0, [r5, #-60]	; 0xffffffc4
     3fc:	670b0584 	strvs	r0, [fp, -r4, lsl #11]
     400:	054a0d05 	strbeq	r0, [sl, #-3333]	; 0xfffff2fb
     404:	0d054b0b 	vstreq	d4, [r5, #-44]	; 0xffffffd4
     408:	4b0b054a 	blmi	2c1938 <__bss_end+0x2b55f8>
     40c:	054a0d05 	strbeq	r0, [sl, #-3333]	; 0xfffff2fb
     410:	0d054c0b 	stceq	12, cr4, [r5, #-44]	; 0xffffffd4
     414:	4b0b054a 	blmi	2c1944 <__bss_end+0x2b5604>
     418:	054a0d05 	strbeq	r0, [sl, #-3333]	; 0xfffff2fb
     41c:	0d054b0b 	vstreq	d4, [r5, #-44]	; 0xffffffd4
     420:	4b0b054a 	blmi	2c1950 <__bss_end+0x2b5610>
     424:	054a0d05 	strbeq	r0, [sl, #-3333]	; 0xfffff2fb
     428:	0d054b0b 	vstreq	d4, [r5, #-44]	; 0xffffffd4
     42c:	4b0b054a 	blmi	2c195c <__bss_end+0x2b561c>
     430:	054a0d05 	strbeq	r0, [sl, #-3333]	; 0xfffff2fb
     434:	0e054b0c 	vmlaeq.f64	d4, d5, d12
     438:	4b0c054a 	blmi	301968 <__bss_end+0x2f5628>
     43c:	054a0e05 	strbeq	r0, [sl, #-3589]	; 0xfffff1fb
     440:	0e054b0c 	vmlaeq.f64	d4, d5, d12
     444:	4b0c054a 	blmi	301974 <__bss_end+0x2f5634>
     448:	054a0e05 	strbeq	r0, [sl, #-3589]	; 0xfffff1fb
     44c:	0e054b0c 	vmlaeq.f64	d4, d5, d12
     450:	4b0c054a 	blmi	301980 <__bss_end+0x2f5640>
     454:	054a0e05 	strbeq	r0, [sl, #-3589]	; 0xfffff1fb
     458:	0e054b0c 	vmlaeq.f64	d4, d5, d12
     45c:	4b0c054a 	blmi	30198c <__bss_end+0x2f564c>
     460:	054a0e05 	strbeq	r0, [sl, #-3589]	; 0xfffff1fb
     464:	0e054b0c 	vmlaeq.f64	d4, d5, d12
     468:	4b0c054a 	blmi	301998 <__bss_end+0x2f5658>
     46c:	054a0e05 	strbeq	r0, [sl, #-3589]	; 0xfffff1fb
     470:	23054d01 	movwcs	r4, #23809	; 0x5d01
     474:	05142c02 	ldreq	r2, [r4, #-3074]	; 0xfffff3fe
     478:	67678314 			; <UNDEFINED> instruction: 0x67678314
     47c:	05676767 	strbeq	r6, [r7, #-1895]!	; 0xfffff899
     480:	0b056701 	bleq	15a08c <__bss_end+0x14dd4c>
     484:	1e052308 	cdpne	3, 0, cr2, cr5, cr8, {0}
     488:	03190568 	tsteq	r9, #104, 10	; 0x1a000000
     48c:	0a05820a 	beq	160cbc <__bss_end+0x15497c>
     490:	85f3f385 	ldrbhi	pc, [r3, #901]!	; 0x385	; <UNPREDICTABLE>
     494:	05d91f05 	ldrbeq	r1, [r9, #3845]	; 0xf05
     498:	1405d609 	strne	sp, [r5], #-1545	; 0xfffff9f7
     49c:	15056830 	strne	r6, [r5, #-2096]	; 0xfffff7d0
     4a0:	4c140568 	cfldr32mi	mvfx0, [r4], {104}	; 0x68
     4a4:	05673105 	strbeq	r3, [r7, #-261]!	; 0xfffffefb
     4a8:	9f9f830c 	svcls	0x009f830c
     4ac:	059f1405 	ldreq	r1, [pc, #1029]	; 8b9 <shift+0x8b9>
     4b0:	14058310 	strne	r8, [r5], #-784	; 0xfffffcf0
     4b4:	6730054d 	ldrvs	r0, [r0, -sp, asr #10]!
     4b8:	9f840c05 	svcls	0x00840c05
     4bc:	9f14059f 	svcls	0x0014059f
     4c0:	05831005 	streq	r1, [r3, #5]
     4c4:	21054e20 	tstcs	r5, r0, lsr #28
     4c8:	695b0567 	ldmdbvs	fp, {r0, r1, r2, r5, r6, r8, sl}^
     4cc:	c8080705 	stmdagt	r8, {r0, r2, r8, r9, sl}
     4d0:	05301205 	ldreq	r1, [r0, #-517]!	; 0xfffffdfb
     4d4:	660b030b 	strvs	r0, [fp], -fp, lsl #6
     4d8:	054d1405 	strbeq	r1, [sp, #-1029]	; 0xfffffbfb
     4dc:	0c05670a 	stceq	7, cr6, [r5], {10}
     4e0:	3001054f 	andcc	r0, r1, pc, asr #10
     4e4:	01001402 	tsteq	r0, r2, lsl #8
     4e8:	0009de01 	andeq	sp, r9, r1, lsl #28
     4ec:	c7000300 	strgt	r0, [r0, -r0, lsl #6]
     4f0:	02000001 	andeq	r0, r0, #1
     4f4:	0d0efb01 	vstreq	d15, [lr, #-4]
     4f8:	01010100 	mrseq	r0, (UNDEF: 17)
     4fc:	00000001 	andeq	r0, r0, r1
     500:	01000001 	tsteq	r0, r1
     504:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 450 <shift+0x450>
     508:	72742f65 	rsbsvc	r2, r4, #404	; 0x194
     50c:	6c696665 	stclvs	6, cr6, [r9], #-404	; 0xfffffe6c
     510:	6d65732f 	stclvs	3, cr7, [r5, #-188]!	; 0xffffff44
     514:	756f732f 	strbvc	r7, [pc, #-815]!	; 1ed <shift+0x1ed>
     518:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
     51c:	6573752f 	ldrbvs	r7, [r3, #-1327]!	; 0xfffffad1
     520:	61707372 	cmnvs	r0, r2, ror r3
     524:	2e2f6563 	cfsh64cs	mvdx6, mvdx15, #51
     528:	74732f2e 	ldrbtvc	r2, [r3], #-3886	; 0xfffff0d2
     52c:	62696c64 	rsbvs	r6, r9, #100, 24	; 0x6400
     530:	636e692f 	cmnvs	lr, #770048	; 0xbc000
     534:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
     538:	6f682f00 	svcvs	0x00682f00
     53c:	742f656d 	strtvc	r6, [pc], #-1389	; 544 <shift+0x544>
     540:	69666572 	stmdbvs	r6!, {r1, r4, r5, r6, r8, sl, sp, lr}^
     544:	65732f6c 	ldrbvs	r2, [r3, #-3948]!	; 0xfffff094
     548:	6f732f6d 	svcvs	0x00732f6d
     54c:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
     550:	73752f73 	cmnvc	r5, #460	; 0x1cc
     554:	70737265 	rsbsvc	r7, r3, r5, ror #4
     558:	2f656361 	svccs	0x00656361
     55c:	65646f4d 	strbvs	r6, [r4, #-3917]!	; 0xfffff0b3
     560:	682f006c 	stmdavs	pc!, {r2, r3, r5, r6}	; <UNPREDICTABLE>
     564:	2f656d6f 	svccs	0x00656d6f
     568:	66657274 			; <UNDEFINED> instruction: 0x66657274
     56c:	732f6c69 			; <UNDEFINED> instruction: 0x732f6c69
     570:	732f6d65 			; <UNDEFINED> instruction: 0x732f6d65
     574:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
     578:	752f7365 	strvc	r7, [pc, #-869]!	; 21b <shift+0x21b>
     57c:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
     580:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
     584:	2f2e2e2f 	svccs	0x002e2e2f
     588:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
     58c:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
     590:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
     594:	702f6564 	eorvc	r6, pc, r4, ror #10
     598:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     59c:	2f007373 	svccs	0x00007373
     5a0:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
     5a4:	6572742f 	ldrbvs	r7, [r2, #-1071]!	; 0xfffffbd1
     5a8:	2f6c6966 	svccs	0x006c6966
     5ac:	2f6d6573 	svccs	0x006d6573
     5b0:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
     5b4:	2f736563 	svccs	0x00736563
     5b8:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
     5bc:	63617073 	cmnvs	r1, #115	; 0x73
     5c0:	2e2e2f65 	cdpcs	15, 2, cr2, cr14, cr5, {3}
     5c4:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
     5c8:	2f6c656e 	svccs	0x006c656e
     5cc:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
     5d0:	2f656475 	svccs	0x00656475
     5d4:	2f007366 	svccs	0x00007366
     5d8:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
     5dc:	6572742f 	ldrbvs	r7, [r2, #-1071]!	; 0xfffffbd1
     5e0:	2f6c6966 	svccs	0x006c6966
     5e4:	2f6d6573 	svccs	0x006d6573
     5e8:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
     5ec:	2f736563 	svccs	0x00736563
     5f0:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
     5f4:	63617073 	cmnvs	r1, #115	; 0x73
     5f8:	2e2e2f65 	cdpcs	15, 2, cr2, cr14, cr5, {3}
     5fc:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
     600:	2f6c656e 	svccs	0x006c656e
     604:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
     608:	2f656475 	svccs	0x00656475
     60c:	72616f62 	rsbvc	r6, r1, #392	; 0x188
     610:	70722f64 	rsbsvc	r2, r2, r4, ror #30
     614:	682f3069 	stmdavs	pc!, {r0, r3, r5, r6, ip, sp}	; <UNPREDICTABLE>
     618:	00006c61 	andeq	r6, r0, r1, ror #24
     61c:	6f6d656d 	svcvs	0x006d656d
     620:	682e7972 	stmdavs	lr!, {r1, r4, r5, r6, r8, fp, ip, sp, lr}
     624:	00000100 	andeq	r0, r0, r0, lsl #2
     628:	65646f4d 	strbvs	r6, [r4, #-3917]!	; 0xfffff0b3
     62c:	70632e6c 	rsbvc	r2, r3, ip, ror #28
     630:	00020070 	andeq	r0, r2, r0, ror r0
     634:	6e615200 	cdpvs	2, 6, cr5, cr1, cr0, {0}
     638:	2e6d6f64 	cdpcs	15, 6, cr6, cr13, cr4, {3}
     63c:	00010068 	andeq	r0, r1, r8, rrx
     640:	61654800 	cmnvs	r5, r0, lsl #16
     644:	614d5f70 	hvcvs	54768	; 0xd5f0
     648:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     64c:	00682e72 	rsbeq	r2, r8, r2, ror lr
     650:	73000001 	movwvc	r0, #1
     654:	6c6e6970 			; <UNDEFINED> instruction: 0x6c6e6970
     658:	2e6b636f 	cdpcs	3, 6, cr6, cr11, cr15, {3}
     65c:	00030068 	andeq	r0, r3, r8, rrx
     660:	6c696600 	stclvs	6, cr6, [r9], #-0
     664:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     668:	2e6d6574 	mcrcs	5, 3, r6, cr13, cr4, {3}
     66c:	00040068 	andeq	r0, r4, r8, rrx
     670:	6f727000 	svcvs	0x00727000
     674:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     678:	0300682e 	movweq	r6, #2094	; 0x82e
     67c:	72700000 	rsbsvc	r0, r0, #0
     680:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     684:	616d5f73 	smcvs	54771	; 0xd5f3
     688:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     68c:	00682e72 	rsbeq	r2, r8, r2, ror lr
     690:	73000003 	movwvc	r0, #3
     694:	75626474 	strbvc	r6, [r2, #-1140]!	; 0xfffffb8c
     698:	72656666 	rsbvc	r6, r5, #106954752	; 0x6600000
     69c:	0100682e 	tsteq	r0, lr, lsr #16
     6a0:	6f4d0000 	svcvs	0x004d0000
     6a4:	2e6c6564 	cdpcs	5, 6, cr6, cr12, cr4, {3}
     6a8:	00020068 	andeq	r0, r2, r8, rrx
     6ac:	746e6900 	strbtvc	r6, [lr], #-2304	; 0xfffff700
     6b0:	2e666564 	cdpcs	5, 6, cr6, cr6, cr4, {3}
     6b4:	00050068 	andeq	r0, r5, r8, rrx
     6b8:	29050000 	stmdbcs	r5, {}	; <UNPREDICTABLE>
     6bc:	b0020500 	andlt	r0, r2, r0, lsl #10
     6c0:	16000086 	strne	r0, [r0], -r6, lsl #1
     6c4:	05831305 	streq	r1, [r3, #773]	; 0x305
     6c8:	08028301 	stmdaeq	r2, {r0, r8, r9, pc}
     6cc:	05010100 	streq	r0, [r1, #-256]	; 0xffffff00
     6d0:	02050001 	andeq	r0, r5, #1
     6d4:	000086e0 	andeq	r8, r0, r0, ror #13
     6d8:	05010d03 	streq	r0, [r1, #-3331]	; 0xfffff2fd
     6dc:	01058313 	tsteq	r5, r3, lsl r3
     6e0:	00080283 	andeq	r0, r8, r3, lsl #5
     6e4:	23050101 	movwcs	r0, #20737	; 0x5101
     6e8:	48020500 	stmdami	r2, {r8, sl}
     6ec:	0300009b 	movweq	r0, #155	; 0x9b
     6f0:	13050111 	movwne	r0, #20753	; 0x5111
     6f4:	83010583 	movwhi	r0, #5507	; 0x1583
     6f8:	01000802 	tsteq	r0, r2, lsl #16
     6fc:	05020401 	streq	r0, [r2, #-1025]	; 0xfffffbff
     700:	02050001 	andeq	r0, r5, #1
     704:	00008710 	andeq	r8, r0, r0, lsl r7
     708:	dc080514 	cfstr32le	mvfx0, [r8], {20}
     70c:	54020905 	strpl	r0, [r2], #-2309	; 0xfffff6fb
     710:	4b120515 	blmi	481b6c <__bss_end+0x47582c>
     714:	05670105 	strbeq	r0, [r7, #-261]!	; 0xfffffefb
     718:	1005a02f 	andne	sl, r5, pc, lsr #32
     71c:	661505d7 			; <UNDEFINED> instruction: 0x661505d7
     720:	05663105 	strbeq	r3, [r6, #-261]!	; 0xfffffefb
     724:	36054a30 			; <UNDEFINED> instruction: 0x36054a30
     728:	4a34054a 	bmi	d01c58 <__bss_end+0xcf5918>
     72c:	052e2905 	streq	r2, [lr, #-2309]!	; 0xfffff6fb
     730:	01052e37 	tsteq	r5, r7, lsr lr
     734:	f73e052f 			; <UNDEFINED> instruction: 0xf73e052f
     738:	67bb0b05 	ldrvs	r0, [fp, r5, lsl #22]!
     73c:	05676767 	strbeq	r6, [r7, #-1895]!	; 0xfffff899
     740:	1c056817 	stcne	8, cr6, [r5], {23}
     744:	662905bb 			; <UNDEFINED> instruction: 0x662905bb
     748:	05663705 	strbeq	r3, [r6, #-1797]!	; 0xfffff8fb
     74c:	23056630 	movwcs	r6, #22064	; 0x5630
     750:	2e0b052e 	cfsh32cs	mvfx0, mvfx11, #30
     754:	05670c05 	strbeq	r0, [r7, #-3077]!	; 0xfffff3fb
     758:	2a054b01 	bcs	153364 <__bss_end+0x147024>
     75c:	a10d056a 	tstge	sp, sl, ror #10
     760:	02001805 	andeq	r1, r0, #327680	; 0x50000
     764:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
     768:	04020016 	streq	r0, [r2], #-22	; 0xffffffea
     76c:	3c054a03 			; <UNDEFINED> instruction: 0x3c054a03
     770:	02040200 	andeq	r0, r4, #0, 4
     774:	004d0567 	subeq	r0, sp, r7, ror #10
     778:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
     77c:	02005205 	andeq	r5, r0, #1342177280	; 0x50000000
     780:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
     784:	04020053 	streq	r0, [r2], #-83	; 0xffffffad
     788:	30052e02 	andcc	r2, r5, r2, lsl #28
     78c:	02040200 	andeq	r0, r4, #0, 4
     790:	0014054a 	andseq	r0, r4, sl, asr #10
     794:	9f020402 	svcls	0x00020402
     798:	02002505 	andeq	r2, r0, #20971520	; 0x1400000
     79c:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
     7a0:	04020026 	streq	r0, [r2], #-38	; 0xffffffda
     7a4:	28052e02 	stmdacs	r5, {r1, r9, sl, fp, sp}
     7a8:	02040200 	andeq	r0, r4, #0, 4
     7ac:	0005054a 	andeq	r0, r5, sl, asr #10
     7b0:	48020402 	stmdami	r2, {r1, sl}
     7b4:	05860105 	streq	r0, [r6, #261]	; 0x105
     7b8:	16056a35 			; <UNDEFINED> instruction: 0x16056a35
     7bc:	4a1f05a0 	bmi	7c1e44 <__bss_end+0x7b5b04>
     7c0:	054a0905 	strbeq	r0, [sl, #-2309]	; 0xfffff6fb
     7c4:	4d4b9f0b 	stclmi	15, cr9, [fp, #-44]	; 0xffffffd4
     7c8:	02001405 	andeq	r1, r0, #83886080	; 0x5000000
     7cc:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
     7d0:	04020012 	streq	r0, [r2], #-18	; 0xffffffee
     7d4:	28054a01 	stmdacs	r5, {r0, r9, fp, lr}
     7d8:	4a390567 	bmi	e41d7c <__bss_end+0xe35a3c>
     7dc:	052e3a05 	streq	r3, [lr, #-2565]!	; 0xfffff5fb
     7e0:	0d054a0f 	vstreq	s8, [r5, #-60]	; 0xffffffc4
     7e4:	8515054b 	ldrhi	r0, [r5, #-1355]	; 0xfffffab5
     7e8:	054a0905 	strbeq	r0, [sl, #-2309]	; 0xfffff6fb
     7ec:	04020019 	streq	r0, [r2], #-25	; 0xffffffe7
     7f0:	1e056702 	cdpne	7, 0, cr6, cr5, cr2, {0}
     7f4:	02040200 	andeq	r0, r4, #0, 4
     7f8:	0023054a 	eoreq	r0, r3, sl, asr #10
     7fc:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
     800:	02000f05 	andeq	r0, r0, #5, 30
     804:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
     808:	0402001d 	streq	r0, [r2], #-29	; 0xffffffe3
     80c:	3d054d02 	stccc	13, cr4, [r5, #-8]
     810:	02040200 	andeq	r0, r4, #0, 4
     814:	002f054a 	eoreq	r0, pc, sl, asr #10
     818:	66020402 	strvs	r0, [r2], -r2, lsl #8
     81c:	02002b05 	andeq	r2, r0, #5120	; 0x1400
     820:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
     824:	04020045 	streq	r0, [r2], #-69	; 0xffffffbb
     828:	41052e02 	tstmi	r5, r2, lsl #28
     82c:	02040200 	andeq	r0, r4, #0, 4
     830:	000e054a 	andeq	r0, lr, sl, asr #10
     834:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
     838:	02000505 	andeq	r0, r0, #20971520	; 0x1400000
     83c:	77030204 	strvc	r0, [r3, -r4, lsl #4]
     840:	87220566 	strhi	r0, [r2, -r6, ror #10]!
     844:	05350505 	ldreq	r0, [r5, #-1285]!	; 0xfffffafb
     848:	0505830e 	streq	r8, [r5, #-782]	; 0xfffffcf2
     84c:	0018056a 	andseq	r0, r8, sl, ror #10
     850:	66010402 	strvs	r0, [r1], -r2, lsl #8
     854:	054c1b05 	strbeq	r1, [ip, #-2821]	; 0xfffff4fb
     858:	0c05660d 	stceq	6, cr6, [r5], {13}
     85c:	2f010567 	svccs	0x00010567
     860:	05a31f05 	streq	r1, [r3, #3845]!	; 0xf05
     864:	1805830d 	stmdane	r5, {r0, r2, r3, r8, r9, pc}
     868:	01040200 	mrseq	r0, R12_usr
     86c:	0016054a 	andseq	r0, r6, sl, asr #10
     870:	4a010402 	bmi	41880 <__bss_end+0x35540>
     874:	05672605 	strbeq	r2, [r7, #-1541]!	; 0xfffff9fb
     878:	32054a31 	andcc	r4, r5, #200704	; 0x31000
     87c:	4a14052e 	bmi	501d3c <__bss_end+0x4f59fc>
     880:	054c1105 	strbeq	r1, [ip, #-261]	; 0xfffffefb
     884:	0402001a 	streq	r0, [r2], #-26	; 0xffffffe6
     888:	2e054a03 	vmlacs.f32	s8, s10, s6
     88c:	02040200 	andeq	r0, r4, #0, 4
     890:	003f0567 	eorseq	r0, pc, r7, ror #10
     894:	4a020402 	bmi	818a4 <__bss_end+0x75564>
     898:	02002605 	andeq	r2, r0, #5242880	; 0x500000
     89c:	05660204 	strbeq	r0, [r6, #-516]!	; 0xfffffdfc
     8a0:	04020009 	streq	r0, [r2], #-9
     8a4:	11059d02 	tstne	r5, r2, lsl #26
     8a8:	001c0587 	andseq	r0, ip, r7, lsl #11
     8ac:	4a030402 	bmi	c18bc <__bss_end+0xb557c>
     8b0:	02001a05 	andeq	r1, r0, #20480	; 0x5000
     8b4:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
     8b8:	04020018 	streq	r0, [r2], #-24	; 0xffffffe8
     8bc:	29056702 	stmdbcs	r5, {r1, r8, r9, sl, sp, lr}
     8c0:	02040200 	andeq	r0, r4, #0, 4
     8c4:	002a054a 	eoreq	r0, sl, sl, asr #10
     8c8:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
     8cc:	02002c05 	andeq	r2, r0, #1280	; 0x500
     8d0:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
     8d4:	04020009 	streq	r0, [r2], #-9
     8d8:	05054902 	streq	r4, [r5, #-2306]	; 0xfffff6fe
     8dc:	02040200 	andeq	r0, r4, #0, 4
     8e0:	05827803 	streq	r7, [r2, #2051]	; 0x803
     8e4:	820b0301 	andhi	r0, fp, #67108864	; 0x4000000
     8e8:	05852405 	streq	r2, [r5, #1029]	; 0x405
     8ec:	16059f0d 	strne	r9, [r5], -sp, lsl #30
     8f0:	03040200 	movweq	r0, #16896	; 0x4200
     8f4:	000f054a 	andeq	r0, pc, sl, asr #10
     8f8:	67020402 	strvs	r0, [r2, -r2, lsl #8]
     8fc:	02003505 	andeq	r3, r0, #20971520	; 0x1400000
     900:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
     904:	04020024 	streq	r0, [r2], #-36	; 0xffffffdc
     908:	05059e02 	streq	r9, [r5, #-3586]	; 0xfffff1fe
     90c:	02040200 	andeq	r0, r4, #0, 4
     910:	840d0581 	strhi	r0, [sp], #-1409	; 0xfffffa7f
     914:	02001805 	andeq	r1, r0, #327680	; 0x50000
     918:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
     91c:	04020016 	streq	r0, [r2], #-22	; 0xffffffea
     920:	2f054a03 	svccs	0x00054a03
     924:	02040200 	andeq	r0, r4, #0, 4
     928:	00400567 	subeq	r0, r0, r7, ror #10
     92c:	4a020402 	bmi	8193c <__bss_end+0x755fc>
     930:	02004105 	andeq	r4, r0, #1073741825	; 0x40000001
     934:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
     938:	0402000f 	streq	r0, [r2], #-15
     93c:	16054a02 	strne	r4, [r5], -r2, lsl #20
     940:	02040200 	andeq	r0, r4, #0, 4
     944:	0027054a 	eoreq	r0, r7, sl, asr #10
     948:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
     94c:	02002805 	andeq	r2, r0, #327680	; 0x50000
     950:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
     954:	04020041 	streq	r0, [r2], #-65	; 0xffffffbf
     958:	2a054a02 	bcs	153168 <__bss_end+0x146e28>
     95c:	02040200 	andeq	r0, r4, #0, 4
     960:	0005052e 	andeq	r0, r5, lr, lsr #10
     964:	2d020402 	cfstrscs	mvf0, [r2, #-8]
     968:	05840b05 	streq	r0, [r4, #2821]	; 0xb05
     96c:	1a054a1f 	bne	1531f0 <__bss_end+0x146eb0>
     970:	2f01054a 	svccs	0x0001054a
     974:	05851f05 	streq	r1, [r5, #3845]	; 0xf05
     978:	f3d7840a 	vraddhn.i32	d24, <illegal reg q3.5>, q5
     97c:	05bb1005 	ldreq	r1, [fp, #5]!
     980:	1605680d 	strne	r6, [r5], -sp, lsl #16
     984:	01040200 	mrseq	r0, R12_usr
     988:	670f054a 	strvs	r0, [pc, -sl, asr #10]
     98c:	05bb0d05 	ldreq	r0, [fp, #3333]!	; 0xd05
     990:	10058325 	andne	r8, r5, r5, lsr #6
     994:	090583ba 	stmdbeq	r5, {r1, r3, r4, r5, r7, r8, r9, pc}
     998:	6713059f 			; <UNDEFINED> instruction: 0x6713059f
     99c:	02000505 	andeq	r0, r0, #20971520	; 0x1400000
     9a0:	7a030204 	bvc	c11b8 <__bss_end+0xb4e78>
     9a4:	8a0b0582 	bhi	2c1fb4 <__bss_end+0x2b5c74>
     9a8:	054a1a05 	strbeq	r1, [sl, #-2565]	; 0xfffff5fb
     9ac:	1a05830b 	bne	1615e0 <__bss_end+0x1552a0>
     9b0:	6901054a 	stmdbvs	r1, {r1, r3, r6, r8, sl}
     9b4:	05bc1405 	ldreq	r1, [ip, #1029]!	; 0x405
     9b8:	3c058452 	cfstrscc	mvf8, [r5], {82}	; 0x52
     9bc:	8216054a 	andshi	r0, r6, #310378496	; 0x12800000
     9c0:	054c0d05 	strbeq	r0, [ip, #-3333]	; 0xfffff2fb
     9c4:	04020018 	streq	r0, [r2], #-24	; 0xffffffe8
     9c8:	16054a01 	strne	r4, [r5], -r1, lsl #20
     9cc:	01040200 	mrseq	r0, R12_usr
     9d0:	670f054a 	strvs	r0, [pc, -sl, asr #10]
     9d4:	054a1a05 	strbeq	r1, [sl, #-2565]	; 0xfffff5fb
     9d8:	23052e1b 	movwcs	r2, #24091	; 0x5e1b
     9dc:	661d054a 	ldrvs	r0, [sp], -sl, asr #10
     9e0:	05303b05 	ldreq	r3, [r0, #-2821]!	; 0xfffff4fb
     9e4:	02004a46 	andeq	r4, r0, #286720	; 0x46000
     9e8:	4a060104 	bmi	180e00 <__bss_end+0x174ac0>
     9ec:	02040200 	andeq	r0, r4, #0, 4
     9f0:	000f054a 	andeq	r0, pc, sl, asr #10
     9f4:	06040402 	streq	r0, [r4], -r2, lsl #8
     9f8:	001a052e 	andseq	r0, sl, lr, lsr #10
     9fc:	4a040402 	bmi	101a0c <__bss_end+0xf56cc>
     a00:	02001b05 	andeq	r1, r0, #5120	; 0x1400
     a04:	052e0404 	streq	r0, [lr, #-1028]!	; 0xfffffbfc
     a08:	04020046 	streq	r0, [r2], #-70	; 0xffffffba
     a0c:	2f056604 	svccs	0x00056604
     a10:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
     a14:	00110566 	andseq	r0, r1, r6, ror #10
     a18:	32040402 	andcc	r0, r4, #33554432	; 0x2000000
     a1c:	02001c05 	andeq	r1, r0, #1280	; 0x500
     a20:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
     a24:	0402001a 	streq	r0, [r2], #-26	; 0xffffffe6
     a28:	13054a03 	movwne	r4, #23043	; 0x5a03
     a2c:	02040200 	andeq	r0, r4, #0, 4
     a30:	001e0567 	andseq	r0, lr, r7, ror #10
     a34:	4a020402 	bmi	81a44 <__bss_end+0x75704>
     a38:	02001f05 	andeq	r1, r0, #5, 30
     a3c:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
     a40:	04020022 	streq	r0, [r2], #-34	; 0xffffffde
     a44:	33056602 	movwcc	r6, #22018	; 0x5602
     a48:	02040200 	andeq	r0, r4, #0, 4
     a4c:	0034052e 	eorseq	r0, r4, lr, lsr #10
     a50:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
     a54:	02003605 	andeq	r3, r0, #5242880	; 0x500000
     a58:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
     a5c:	04020009 	streq	r0, [r2], #-9
     a60:	05054902 	streq	r4, [r5, #-2306]	; 0xfffff6fe
     a64:	02040200 	andeq	r0, r4, #0, 4
     a68:	05827903 	streq	r7, [r2, #2307]	; 0x903
     a6c:	820c031c 	andhi	r0, ip, #28, 6	; 0x70000000
     a70:	004a2705 	subeq	r2, sl, r5, lsl #14
     a74:	06010402 	streq	r0, [r1], -r2, lsl #8
     a78:	0402004a 	streq	r0, [r2], #-74	; 0xffffffb6
     a7c:	02004a02 	andeq	r4, r0, #8192	; 0x2000
     a80:	052e0404 	streq	r0, [lr, #-1028]!	; 0xfffffbfc
     a84:	04020010 	streq	r0, [r2], #-16
     a88:	05820604 	streq	r0, [r2, #1540]	; 0x604
     a8c:	04020069 	streq	r0, [r2], #-105	; 0xffffff97
     a90:	29054d04 	stmdbcs	r5, {r2, r8, sl, fp, lr}
     a94:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
     a98:	00690582 	rsbeq	r0, r9, r2, lsl #11
     a9c:	4a040402 	bmi	101aac <__bss_end+0xf576c>
     aa0:	02004505 	andeq	r4, r0, #20971520	; 0x1400000
     aa4:	05d60404 	ldrbeq	r0, [r6, #1028]	; 0x404
     aa8:	04020069 	streq	r0, [r2], #-105	; 0xffffff97
     aac:	12054a04 	andne	r4, r5, #4, 20	; 0x4000
     ab0:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
     ab4:	1705ac08 	strne	sl, [r5, -r8, lsl #24]
     ab8:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
     abc:	0011054d 	andseq	r0, r1, sp, asr #10
     ac0:	82040402 	andhi	r0, r4, #33554432	; 0x2000000
     ac4:	02002f05 	andeq	r2, r0, #5, 30
     ac8:	054b0404 	strbeq	r0, [fp, #-1028]	; 0xfffffbfc
     acc:	0402003a 	streq	r0, [r2], #-58	; 0xffffffc6
     ad0:	02004a04 	andeq	r4, r0, #4, 20	; 0x4000
     ad4:	4a060104 	bmi	180eec <__bss_end+0x174bac>
     ad8:	02040200 	andeq	r0, r4, #0, 4
     adc:	000b054a 	andeq	r0, fp, sl, asr #10
     ae0:	06040402 	streq	r0, [r4], -r2, lsl #8
     ae4:	003a052e 	eorseq	r0, sl, lr, lsr #10
     ae8:	4a040402 	bmi	101af8 <__bss_end+0xf57b8>
     aec:	02002305 	andeq	r2, r0, #335544320	; 0x14000000
     af0:	05660404 	strbeq	r0, [r6, #-1028]!	; 0xfffffbfc
     af4:	0402000d 	streq	r0, [r2], #-13
     af8:	18052f04 	stmdane	r5, {r2, r8, r9, sl, fp, sp}
     afc:	03040200 	movweq	r0, #16896	; 0x4200
     b00:	0016054a 	andseq	r0, r6, sl, asr #10
     b04:	4a030402 	bmi	c1b14 <__bss_end+0xb57d4>
     b08:	02000f05 	andeq	r0, r0, #5, 30
     b0c:	05670204 	strbeq	r0, [r7, #-516]!	; 0xfffffdfc
     b10:	04020016 	streq	r0, [r2], #-22	; 0xffffffea
     b14:	27054a02 	strcs	r4, [r5, -r2, lsl #20]
     b18:	02040200 	andeq	r0, r4, #0, 4
     b1c:	0028052e 	eoreq	r0, r8, lr, lsr #10
     b20:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
     b24:	02002a05 	andeq	r2, r0, #20480	; 0x5000
     b28:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
     b2c:	04020005 	streq	r0, [r2], #-5
     b30:	15054902 	strne	r4, [r5, #-2306]	; 0xfffff6fe
     b34:	4c010585 	cfstr32mi	mvfx0, [r1], {133}	; 0x85
     b38:	05672205 	strbeq	r2, [r7, #-517]!	; 0xfffffdfb
     b3c:	1c05830c 	stcne	3, cr8, [r5], {12}
     b40:	bb01054a 	bllt	42070 <__bss_end+0x35d30>
     b44:	05842505 	streq	r2, [r4, #1285]	; 0x505
     b48:	05059f1b 	streq	r9, [r5, #-3867]	; 0xfffff0e5
     b4c:	4b100566 	blmi	4020ec <__bss_end+0x3f5dac>
     b50:	054c0b05 	strbeq	r0, [ip, #-2821]	; 0xfffff4fb
     b54:	1c054a10 			; <UNDEFINED> instruction: 0x1c054a10
     b58:	661e054a 	ldrvs	r0, [lr], -sl, asr #10
     b5c:	054a2005 	strbeq	r2, [sl, #-5]
     b60:	01054b0c 	tsteq	r5, ip, lsl #22
     b64:	6824052f 	stmdavs	r4!, {r0, r1, r2, r3, r5, r8, sl}
     b68:	059f0f05 	ldreq	r0, [pc, #3845]	; 1a75 <shift+0x1a75>
     b6c:	21056701 	tstcs	r5, r1, lsl #14
     b70:	83120584 	tsthi	r2, #132, 10	; 0x21000000
     b74:	054b0105 	strbeq	r0, [fp, #-261]	; 0xfffffefb
     b78:	20058434 	andcs	r8, r5, r4, lsr r4
     b7c:	4a2f05a0 	bmi	bc2204 <__bss_end+0xbb5ec4>
     b80:	05663405 	strbeq	r3, [r6, #-1029]!	; 0xfffffbfb
     b84:	053e081e 	ldreq	r0, [lr, #-2078]!	; 0xfffff7e2
     b88:	34054a2d 	strcc	r4, [r5], #-2605	; 0xfffff5d3
     b8c:	2e370566 	cdpcs	5, 3, cr0, cr7, cr6, {3}
     b90:	05861705 	streq	r1, [r6, #1797]	; 0x705
     b94:	09054a28 	stmdbeq	r5, {r3, r5, r9, fp, lr}
     b98:	68190582 	ldmdavs	r9, {r1, r7, r8, sl}
     b9c:	684a0905 	stmdavs	sl, {r0, r2, r8, fp}^
     ba0:	054d2405 	strbeq	r2, [sp, #-1029]	; 0xfffffbfb
     ba4:	16059e09 	strne	r9, [r5], -r9, lsl #28
     ba8:	01040200 	mrseq	r0, R12_usr
     bac:	832a0568 			; <UNDEFINED> instruction: 0x832a0568
     bb0:	052e3105 	streq	r3, [lr, #-261]!	; 0xfffffefb
     bb4:	35056614 	strcc	r6, [r5, #-1556]	; 0xfffff9ec
     bb8:	9e14054b 	cfmac32ls	mvfx0, mvfx4, mvfx11
     bbc:	054c1105 	strbeq	r1, [ip, #-261]	; 0xfffffefb
     bc0:	0402001a 	streq	r0, [r2], #-26	; 0xffffffe6
     bc4:	3b054a02 	blcc	1533d4 <__bss_end+0x147094>
     bc8:	04020083 	streq	r0, [r2], #-131	; 0xffffff7d
     bcc:	00660601 	rsbeq	r0, r6, r1, lsl #12
     bd0:	ba020402 	blt	81be0 <__bss_end+0x758a0>
     bd4:	02001805 	andeq	r1, r0, #327680	; 0x50000
     bd8:	9e060404 	cdpls	4, 0, cr0, cr6, cr4, {0}
     bdc:	02001d05 	andeq	r1, r0, #320	; 0x140
     be0:	052e0404 	streq	r0, [lr, #-1028]!	; 0xfffffbfc
     be4:	0402002e 	streq	r0, [r2], #-46	; 0xffffffd2
     be8:	09058204 	stmdbeq	r5, {r2, r9, pc}
     bec:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
     bf0:	84110581 	ldrhi	r0, [r1], #-1409	; 0xfffffa7f
     bf4:	02002705 	andeq	r2, r0, #1310720	; 0x140000
     bf8:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
     bfc:	04020036 	streq	r0, [r2], #-54	; 0xffffffca
     c00:	18056702 	stmdane	r5, {r1, r8, r9, sl, sp, lr}
     c04:	02040200 	andeq	r0, r4, #0, 4
     c08:	001d054a 	andseq	r0, sp, sl, asr #10
     c0c:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
     c10:	02004705 	andeq	r4, r0, #1310720	; 0x140000
     c14:	05820204 	streq	r0, [r2, #516]	; 0x204
     c18:	0402002e 	streq	r0, [r2], #-46	; 0xffffffd2
     c1c:	09056602 	stmdbeq	r5, {r1, r9, sl, sp, lr}
     c20:	02040200 	andeq	r0, r4, #0, 4
     c24:	84110581 	ldrhi	r0, [r1], #-1409	; 0xfffffa7f
     c28:	78030505 	stmdavc	r3, {r0, r2, r8, sl}
     c2c:	00160566 	andseq	r0, r6, r6, ror #10
     c30:	03010402 	movweq	r0, #5122	; 0x1402
     c34:	2f05820b 	svccs	0x0005820b
     c38:	2e340583 	cfadd32cs	mvfx0, mvfx4, mvfx3
     c3c:	05661405 	strbeq	r1, [r6, #-1029]!	; 0xfffffbfb
     c40:	1a054c11 	bne	153c8c <__bss_end+0x14794c>
     c44:	03040200 	movweq	r0, #16896	; 0x4200
     c48:	002c054a 	eoreq	r0, ip, sl, asr #10
     c4c:	67020402 	strvs	r0, [r2, -r2, lsl #8]
     c50:	02003d05 	andeq	r3, r0, #320	; 0x140
     c54:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
     c58:	0402002a 	streq	r0, [r2], #-42	; 0xffffffd6
     c5c:	09056602 	stmdbeq	r5, {r1, r9, sl, sp, lr}
     c60:	02040200 	andeq	r0, r4, #0, 4
     c64:	7f05059d 	svcvc	0x0005059d
     c68:	09030105 	stmdbeq	r3, {r0, r2, r8}
     c6c:	d7310582 	ldrle	r0, [r1, -r2, lsl #11]!
     c70:	059f1005 	ldreq	r1, [pc, #5]	; c7d <shift+0xc7d>
     c74:	0505f208 	streq	pc, [r5, #-520]	; 0xfffffdf8
     c78:	4b190582 	blmi	642288 <__bss_end+0x635f48>
     c7c:	054b1405 	strbeq	r1, [fp, #-1029]	; 0xfffffbfb
     c80:	15054b09 	strne	r4, [r5, #-2825]	; 0xfffff4f7
     c84:	f20d0530 	vqrshl.s8	d0, d16, d13
     c88:	05820a05 	streq	r0, [r2, #2565]	; 0xa05
     c8c:	1e054b0f 	vmlane.f64	d4, d5, d15
     c90:	6714054a 	ldrvs	r0, [r4, -sl, asr #10]
     c94:	05670905 	strbeq	r0, [r7, #-2309]!	; 0xfffff6fb
     c98:	1e05310f 	adfnes	f3, f5, #10.0
     c9c:	6710054a 	ldrvs	r0, [r0, -sl, asr #10]
     ca0:	054d0105 	strbeq	r0, [sp, #-261]	; 0xfffffefb
     ca4:	1005bb26 	andne	fp, r5, r6, lsr #22
     ca8:	680d0583 	stmdavs	sp, {r0, r1, r7, r8, sl}
     cac:	02001805 	andeq	r1, r0, #327680	; 0x50000
     cb0:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
     cb4:	04020016 	streq	r0, [r2], #-22	; 0xffffffea
     cb8:	02004a03 	andeq	r4, r0, #12288	; 0x3000
     cbc:	05670204 	strbeq	r0, [r7, #-516]!	; 0xfffffdfc
     cc0:	04020027 	streq	r0, [r2], #-39	; 0xffffffd9
     cc4:	28054a02 	stmdacs	r5, {r1, r9, fp, lr}
     cc8:	02040200 	andeq	r0, r4, #0, 4
     ccc:	000f052e 	andeq	r0, pc, lr, lsr #10
     cd0:	4a020402 	bmi	81ce0 <__bss_end+0x759a0>
     cd4:	02000d05 	andeq	r0, r0, #320	; 0x140
     cd8:	054b0204 	strbeq	r0, [fp, #-516]	; 0xfffffdfc
     cdc:	0402000f 	streq	r0, [r2], #-15
     ce0:	1e058302 	cdpne	3, 0, cr8, cr5, cr2, {0}
     ce4:	02040200 	andeq	r0, r4, #0, 4
     ce8:	000f054a 	andeq	r0, pc, sl, asr #10
     cec:	83020402 	movwhi	r0, #9218	; 0x2402
     cf0:	02001e05 	andeq	r1, r0, #5, 28	; 0x50
     cf4:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
     cf8:	04020005 	streq	r0, [r2], #-5
     cfc:	01056202 	tsteq	r5, r2, lsl #4
     d00:	84190589 	ldrhi	r0, [r9], #-1417	; 0xfffffa77
     d04:	05831805 	streq	r1, [r3, #2053]	; 0x805
     d08:	05054a2b 	streq	r4, [r5, #-2603]	; 0xfffff5d5
     d0c:	681e0568 	ldmdavs	lr, {r3, r5, r6, r8, sl}
     d10:	05690505 	strbeq	r0, [r9, #-1285]!	; 0xfffffafb
     d14:	05930820 	ldreq	r0, [r3, #2080]	; 0x820
     d18:	1505670d 	strne	r6, [r5, #-1805]	; 0xfffff8f3
     d1c:	671f0531 			; <UNDEFINED> instruction: 0x671f0531
     d20:	05820d05 	streq	r0, [r2, #3333]	; 0xd05
     d24:	0d054b1b 	vstreq	d4, [r5, #-108]	; 0xffffff94
     d28:	30160567 	andscc	r0, r6, r7, ror #10
     d2c:	05671f05 	strbeq	r1, [r7, #-3845]!	; 0xfffff0fb
     d30:	1c05d60d 	stcne	6, cr13, [r5], {13}
     d34:	670d054b 	strvs	r0, [sp, -fp, asr #10]
     d38:	4a1c0530 	bmi	702200 <__bss_end+0x6f5ec0>
     d3c:	05671805 	strbeq	r1, [r7, #-2053]!	; 0xfffff7fb
     d40:	18054b0d 	stmdane	r5, {r0, r2, r3, r8, r9, fp, lr}
     d44:	052e6803 	streq	r6, [lr, #-2051]!	; 0xfffff7fd
     d48:	4a0f030d 	bmi	3c1984 <__bss_end+0x3b5644>
     d4c:	3401054f 	strcc	r0, [r1], #-1359	; 0xfffffab1
     d50:	05682d05 	strbeq	r2, [r8, #-3333]!	; 0xfffff2fb
     d54:	2e059f1f 	mcrcs	15, 0, r9, cr5, cr15, {0}
     d58:	6633054a 	ldrtvs	r0, [r3], -sl, asr #10
     d5c:	3d080d05 	stccc	13, cr0, [r8, #-20]	; 0xffffffec
     d60:	02001805 	andeq	r1, r0, #327680	; 0x50000
     d64:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
     d68:	04020016 	streq	r0, [r2], #-22	; 0xffffffea
     d6c:	3a054a03 	bcc	153580 <__bss_end+0x147240>
     d70:	02040200 	andeq	r0, r4, #0, 4
     d74:	00140567 	andseq	r0, r4, r7, ror #10
     d78:	4a020402 	bmi	81d88 <__bss_end+0x75a48>
     d7c:	02001505 	andeq	r1, r0, #20971520	; 0x1400000
     d80:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
     d84:	0402004b 	streq	r0, [r2], #-75	; 0xffffffb5
     d88:	38058202 	stmdacc	r5, {r1, r9, pc}
     d8c:	02040200 	andeq	r0, r4, #0, 4
     d90:	00050566 	andeq	r0, r5, r6, ror #10
     d94:	81020402 	tsthi	r2, r2, lsl #8
     d98:	05850105 	streq	r0, [r5, #261]	; 0x105
     d9c:	0b05841a 	bleq	161e0c <__bss_end+0x155acc>
     da0:	4a1a0583 	bmi	6823b4 <__bss_end+0x676074>
     da4:	05670105 	strbeq	r0, [r7, #-261]!	; 0xfffffefb
     da8:	14058512 	strne	r8, [r5], #-1298	; 0xfffffaee
     dac:	4c100586 	cfldr32mi	mvfx0, [r0], {134}	; 0x86
     db0:	054a0f05 	strbeq	r0, [sl, #-3845]	; 0xfffff0fb
     db4:	17054b0d 	strne	r4, [r5, -sp, lsl #22]
     db8:	4809052f 	stmdami	r9, {r0, r1, r2, r3, r5, r8, sl}
     dbc:	05320e05 	ldreq	r0, [r2, #-3589]!	; 0xfffff1fb
     dc0:	18054b09 	stmdane	r5, {r0, r3, r8, r9, fp, lr}
     dc4:	6811054a 	ldmdavs	r1, {r1, r3, r6, r8, sl}
     dc8:	02001c05 	andeq	r1, r0, #1280	; 0x500
     dcc:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
     dd0:	0402001a 	streq	r0, [r2], #-26	; 0xffffffe6
     dd4:	11054a01 	tstne	r5, r1, lsl #20
     dd8:	4a100568 	bmi	402380 <__bss_end+0x3f6040>
     ddc:	054a0d05 	strbeq	r0, [sl, #-3333]	; 0xfffff2fb
     de0:	20054b15 	andcs	r4, r5, r5, lsl fp
     de4:	01040200 	mrseq	r0, R12_usr
     de8:	001e054a 	andseq	r0, lr, sl, asr #10
     dec:	4a010402 	bmi	41dfc <__bss_end+0x35abc>
     df0:	05681905 	strbeq	r1, [r8, #-2309]!	; 0xfffff6fb
     df4:	25054a24 	strcs	r4, [r5, #-2596]	; 0xfffff5dc
     df8:	4a18052e 	bmi	6022b8 <__bss_end+0x5f5f78>
     dfc:	05842d05 	streq	r2, [r4, #3333]	; 0xd05
     e00:	39054a38 	stmdbcc	r5, {r3, r4, r5, r9, fp, lr}
     e04:	4a2c052e 	bmi	b022c4 <__bss_end+0xaf5f84>
     e08:	059f1105 	ldreq	r1, [pc, #261]	; f15 <shift+0xf15>
     e0c:	2405a015 	strcs	sl, [r5], #-21	; 0xffffffeb
     e10:	6825054a 	stmdavs	r5!, {r1, r3, r6, r8, sl}
     e14:	054b2005 	strbeq	r2, [fp, #-5]
     e18:	11056715 	tstne	r5, r5, lsl r7
     e1c:	02040200 	andeq	r0, r4, #0, 4
     e20:	001c0530 	andseq	r0, ip, r0, lsr r5
     e24:	4a020402 	bmi	81e34 <__bss_end+0x75af4>
     e28:	02001d05 	andeq	r1, r0, #320	; 0x140
     e2c:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
     e30:	04020028 	streq	r0, [r2], #-40	; 0xffffffd8
     e34:	1b056602 	blne	15a644 <__bss_end+0x14e304>
     e38:	02040200 	andeq	r0, r4, #0, 4
     e3c:	000d054b 	andeq	r0, sp, fp, asr #10
     e40:	03020402 	movweq	r0, #9218	; 0x2402
     e44:	10034a72 	andne	r4, r3, r2, ror sl
     e48:	691b0582 	ldmdbvs	fp, {r1, r7, r8, sl}
     e4c:	05d91305 	ldrbeq	r1, [r9, #773]	; 0x305
     e50:	17054a12 	smladne	r5, r2, sl, r4
     e54:	4d180587 	cfldr32mi	mvfx0, [r8, #-540]	; 0xfffffde4
     e58:	05a01105 	streq	r1, [r0, #261]!	; 0x105
     e5c:	11059f13 	tstne	r5, r3, lsl pc
     e60:	001a054c 	andseq	r0, sl, ip, asr #10
     e64:	4a030402 	bmi	c1e74 <__bss_end+0xb5b34>
     e68:	02000905 	andeq	r0, r0, #81920	; 0x14000
     e6c:	00820204 	addeq	r0, r2, r4, lsl #4
     e70:	03020402 	movweq	r0, #9218	; 0x2402
     e74:	1c05825a 	sfmne	f0, 1, [r5], {90}	; 0x5a
     e78:	03200584 			; <UNDEFINED> instruction: 0x03200584
     e7c:	09054a11 	stmdbeq	r5, {r0, r4, r9, fp, lr}
     e80:	052e1803 	streq	r1, [lr, #-2051]!	; 0xfffff7fd
     e84:	04020020 	streq	r0, [r2], #-32	; 0xffffffe0
     e88:	1f056602 	svcne	0x00056602
     e8c:	02040200 	andeq	r0, r4, #0, 4
     e90:	001c054a 	andseq	r0, ip, sl, asr #10
     e94:	4a020402 	bmi	81ea4 <__bss_end+0x75b64>
     e98:	054d2705 	strbeq	r2, [sp, #-1797]	; 0xfffff8fb
     e9c:	3f054a2e 	svccc	0x00054a2e
     ea0:	4a4f052e 	bmi	13c2360 <__bss_end+0x13b6020>
     ea4:	05660f05 	strbeq	r0, [r6, #-3845]!	; 0xfffff0fb
     ea8:	0f054b0d 	svceq	0x00054b0d
     eac:	4a1e0583 	bmi	7824c0 <__bss_end+0x776180>
     eb0:	05830f05 	streq	r0, [r3, #3845]	; 0xf05
     eb4:	19054a1e 	stmdbne	r5, {r1, r2, r3, r4, r9, fp, lr}
     eb8:	4c140567 	cfldr32mi	mvfx0, [r4], {103}	; 0x67
     ebc:	77032b05 	strvc	r2, [r3, -r5, lsl #22]
     ec0:	03050582 	movweq	r0, #21890	; 0x5582
     ec4:	0c022e0a 	stceq	14, cr2, [r2], {10}
     ec8:	3e010100 	adfccs	f0, f1, f0
     ecc:	03000002 	movweq	r0, #2
     ed0:	00015800 	andeq	r5, r1, r0, lsl #16
     ed4:	fb010200 	blx	416de <__bss_end+0x3539e>
     ed8:	01000d0e 	tsteq	r0, lr, lsl #26
     edc:	00010101 	andeq	r0, r1, r1, lsl #2
     ee0:	00010000 	andeq	r0, r1, r0
     ee4:	682f0100 	stmdavs	pc!, {r8}	; <UNPREDICTABLE>
     ee8:	2f656d6f 	svccs	0x00656d6f
     eec:	66657274 			; <UNDEFINED> instruction: 0x66657274
     ef0:	732f6c69 			; <UNDEFINED> instruction: 0x732f6c69
     ef4:	732f6d65 			; <UNDEFINED> instruction: 0x732f6d65
     ef8:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
     efc:	752f7365 	strvc	r7, [pc, #-869]!	; b9f <shift+0xb9f>
     f00:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
     f04:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
     f08:	646f4d2f 	strbtvs	r4, [pc], #-3375	; f10 <shift+0xf10>
     f0c:	2f006c65 	svccs	0x00006c65
     f10:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
     f14:	6572742f 	ldrbvs	r7, [r2, #-1071]!	; 0xfffffbd1
     f18:	2f6c6966 	svccs	0x006c6966
     f1c:	2f6d6573 	svccs	0x006d6573
     f20:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
     f24:	2f736563 	svccs	0x00736563
     f28:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
     f2c:	63617073 	cmnvs	r1, #115	; 0x73
     f30:	2e2e2f65 	cdpcs	15, 2, cr2, cr14, cr5, {3}
     f34:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
     f38:	2f6c656e 	svccs	0x006c656e
     f3c:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
     f40:	2f656475 	svccs	0x00656475
     f44:	636f7270 	cmnvs	pc, #112, 4
     f48:	00737365 	rsbseq	r7, r3, r5, ror #6
     f4c:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; e98 <shift+0xe98>
     f50:	72742f65 	rsbsvc	r2, r4, #404	; 0x194
     f54:	6c696665 	stclvs	6, cr6, [r9], #-404	; 0xfffffe6c
     f58:	6d65732f 	stclvs	3, cr7, [r5, #-188]!	; 0xffffff44
     f5c:	756f732f 	strbvc	r7, [pc, #-815]!	; c35 <shift+0xc35>
     f60:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
     f64:	6573752f 	ldrbvs	r7, [r3, #-1327]!	; 0xfffffad1
     f68:	61707372 	cmnvs	r0, r2, ror r3
     f6c:	2e2f6563 	cfsh64cs	mvdx6, mvdx15, #51
     f70:	656b2f2e 	strbvs	r2, [fp, #-3886]!	; 0xfffff0d2
     f74:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
     f78:	636e692f 	cmnvs	lr, #770048	; 0xbc000
     f7c:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
     f80:	0073662f 	rsbseq	r6, r3, pc, lsr #12
     f84:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; ed0 <shift+0xed0>
     f88:	72742f65 	rsbsvc	r2, r4, #404	; 0x194
     f8c:	6c696665 	stclvs	6, cr6, [r9], #-404	; 0xfffffe6c
     f90:	6d65732f 	stclvs	3, cr7, [r5, #-188]!	; 0xffffff44
     f94:	756f732f 	strbvc	r7, [pc, #-815]!	; c6d <shift+0xc6d>
     f98:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
     f9c:	6573752f 	ldrbvs	r7, [r3, #-1327]!	; 0xfffffad1
     fa0:	61707372 	cmnvs	r0, r2, ror r3
     fa4:	2e2f6563 	cfsh64cs	mvdx6, mvdx15, #51
     fa8:	656b2f2e 	strbvs	r2, [fp, #-3886]!	; 0xfffff0d2
     fac:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
     fb0:	636e692f 	cmnvs	lr, #770048	; 0xbc000
     fb4:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
     fb8:	616f622f 	cmnvs	pc, pc, lsr #4
     fbc:	722f6472 	eorvc	r6, pc, #1912602624	; 0x72000000
     fc0:	2f306970 	svccs	0x00306970
     fc4:	006c6168 	rsbeq	r6, ip, r8, ror #2
     fc8:	726f5300 	rsbvc	r5, pc, #0, 6
     fcc:	70632e74 	rsbvc	r2, r3, r4, ror lr
     fd0:	00010070 	andeq	r0, r1, r0, ror r0
     fd4:	69707300 	ldmdbvs	r0!, {r8, r9, ip, sp, lr}^
     fd8:	636f6c6e 	cmnvs	pc, #28160	; 0x6e00
     fdc:	00682e6b 	rsbeq	r2, r8, fp, ror #28
     fe0:	66000002 	strvs	r0, [r0], -r2
     fe4:	73656c69 	cmnvc	r5, #26880	; 0x6900
     fe8:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     fec:	00682e6d 	rsbeq	r2, r8, sp, ror #28
     ff0:	70000003 	andvc	r0, r0, r3
     ff4:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     ff8:	682e7373 	stmdavs	lr!, {r0, r1, r4, r5, r6, r8, r9, ip, sp, lr}
     ffc:	00000200 	andeq	r0, r0, r0, lsl #4
    1000:	636f7270 	cmnvs	pc, #112, 4
    1004:	5f737365 	svcpl	0x00737365
    1008:	616e616d 	cmnvs	lr, sp, ror #2
    100c:	2e726567 	cdpcs	5, 7, cr6, cr2, cr7, {3}
    1010:	00020068 	andeq	r0, r2, r8, rrx
    1014:	646f4d00 	strbtvs	r4, [pc], #-3328	; 101c <shift+0x101c>
    1018:	682e6c65 	stmdavs	lr!, {r0, r2, r5, r6, sl, fp, sp, lr}
    101c:	00000100 	andeq	r0, r0, r0, lsl #2
    1020:	64746e69 	ldrbtvs	r6, [r4], #-3689	; 0xfffff197
    1024:	682e6665 	stmdavs	lr!, {r0, r2, r5, r6, r9, sl, sp, lr}
    1028:	00000400 	andeq	r0, r0, r0, lsl #8
    102c:	00380500 	eorseq	r0, r8, r0, lsl #10
    1030:	9b780205 	blls	1e0184c <__bss_end+0x1df550c>
    1034:	05150000 	ldreq	r0, [r5, #-0]
    1038:	2705bb22 	strcs	fp, [r5, -r2, lsr #22]
    103c:	6610052e 	ldrvs	r0, [r0], -lr, lsr #10
    1040:	054d1e05 	strbeq	r1, [sp, #-3589]	; 0xfffff1fb
    1044:	0402002c 	streq	r0, [r2], #-44	; 0xffffffd4
    1048:	30058201 	andcc	r8, r5, r1, lsl #4
    104c:	01040200 	mrseq	r0, R12_usr
    1050:	0033052e 	eorseq	r0, r3, lr, lsr #10
    1054:	82010402 	andhi	r0, r1, #33554432	; 0x2000000
    1058:	02004405 	andeq	r4, r0, #83886080	; 0x5000000
    105c:	052e0104 	streq	r0, [lr, #-260]!	; 0xfffffefc
    1060:	0402003b 	streq	r0, [r2], #-59	; 0xffffffc5
    1064:	1e054a01 	vmlane.f32	s8, s10, s2
    1068:	01040200 	mrseq	r0, R12_usr
    106c:	4b1505d6 	blmi	5427cc <__bss_end+0x53648c>
    1070:	31650905 	cmncc	r5, r5, lsl #18
    1074:	05832a05 	streq	r2, [r3, #2565]	; 0xa05
    1078:	17052e2e 	strne	r2, [r5, -lr, lsr #28]
    107c:	2e1c0566 	cfmsc32cs	mvfx0, mvfx12, mvfx6
    1080:	05662e05 	strbeq	r2, [r6, #-3589]!	; 0xfffff1fb
    1084:	12052e1e 	andne	r2, r5, #480	; 0x1e0
    1088:	6a1e052f 	bvs	78254c <__bss_end+0x77620c>
    108c:	02002c05 	andeq	r2, r0, #1280	; 0x500
    1090:	05820104 	streq	r0, [r2, #260]	; 0x104
    1094:	04020031 	streq	r0, [r2], #-49	; 0xffffffcf
    1098:	34052e01 	strcc	r2, [r5], #-3585	; 0xfffff1ff
    109c:	01040200 	mrseq	r0, R12_usr
    10a0:	00450582 	subeq	r0, r5, r2, lsl #11
    10a4:	2e010402 	cdpcs	4, 0, cr0, cr1, cr2, {0}
    10a8:	02003c05 	andeq	r3, r0, #1280	; 0x500
    10ac:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
    10b0:	0402001e 	streq	r0, [r2], #-30	; 0xffffffe2
    10b4:	1205d601 	andne	sp, r5, #1048576	; 0x100000
    10b8:	6509054b 	strvs	r0, [r9, #-1355]	; 0xfffffab5
    10bc:	83290530 			; <UNDEFINED> instruction: 0x83290530
    10c0:	052e2e05 	streq	r2, [lr, #-3589]!	; 0xfffff1fb
    10c4:	1b056617 	blne	15a928 <__bss_end+0x14e5e8>
    10c8:	662e052e 	strtvs	r0, [lr], -lr, lsr #10
    10cc:	052e1d05 	streq	r1, [lr, #-3333]!	; 0xfffff2fb
    10d0:	09052f11 	stmdbeq	r5, {r0, r4, r8, r9, sl, fp, sp}
    10d4:	05667303 	strbeq	r7, [r6, #-771]!	; 0xfffffcfd
    10d8:	0f05350d 	svceq	0x0005350d
    10dc:	13053151 	movwne	r3, #20817	; 0x5151
    10e0:	6615052e 	ldrvs	r0, [r5], -lr, lsr #10
    10e4:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
    10e8:	37053001 	strcc	r3, [r5, -r1]
    10ec:	bb050585 	bllt	142708 <__bss_end+0x1363c8>
    10f0:	05841605 	streq	r1, [r4, #1541]	; 0x605
    10f4:	05bba109 	ldreq	sl, [fp, #265]!	; 0x109
    10f8:	d67a0315 			; <UNDEFINED> instruction: 0xd67a0315
    10fc:	05350105 	ldreq	r0, [r5, #-261]!	; 0xfffffefb
    1100:	09054e35 	stmdbeq	r5, {r0, r2, r4, r5, r9, sl, fp, lr}
    1104:	bb01059f 	bllt	42788 <__bss_end+0x36448>
    1108:	01000602 	tsteq	r0, r2, lsl #12
    110c:	00014f01 	andeq	r4, r1, r1, lsl #30
    1110:	c8000300 	stmdagt	r0, {r8, r9}
    1114:	02000000 	andeq	r0, r0, #0
    1118:	0d0efb01 	vstreq	d15, [lr, #-4]
    111c:	01010100 	mrseq	r0, (UNDEF: 17)
    1120:	00000001 	andeq	r0, r0, r1
    1124:	01000001 	tsteq	r0, r1
    1128:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 1074 <shift+0x1074>
    112c:	72742f65 	rsbsvc	r2, r4, #404	; 0x194
    1130:	6c696665 	stclvs	6, cr6, [r9], #-404	; 0xfffffe6c
    1134:	6d65732f 	stclvs	3, cr7, [r5, #-188]!	; 0xffffff44
    1138:	756f732f 	strbvc	r7, [pc, #-815]!	; e11 <shift+0xe11>
    113c:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
    1140:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
    1144:	2f62696c 	svccs	0x0062696c
    1148:	00637273 	rsbeq	r7, r3, r3, ror r2
    114c:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 1098 <shift+0x1098>
    1150:	72742f65 	rsbsvc	r2, r4, #404	; 0x194
    1154:	6c696665 	stclvs	6, cr6, [r9], #-404	; 0xfffffe6c
    1158:	6d65732f 	stclvs	3, cr7, [r5, #-188]!	; 0xffffff44
    115c:	756f732f 	strbvc	r7, [pc, #-815]!	; e35 <shift+0xe35>
    1160:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
    1164:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
    1168:	2f62696c 	svccs	0x0062696c
    116c:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
    1170:	00656475 	rsbeq	r6, r5, r5, ror r4
    1174:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 10c0 <shift+0x10c0>
    1178:	72742f65 	rsbsvc	r2, r4, #404	; 0x194
    117c:	6c696665 	stclvs	6, cr6, [r9], #-404	; 0xfffffe6c
    1180:	6d65732f 	stclvs	3, cr7, [r5, #-188]!	; 0xffffff44
    1184:	756f732f 	strbvc	r7, [pc, #-815]!	; e5d <shift+0xe5d>
    1188:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
    118c:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
    1190:	2f6c656e 	svccs	0x006c656e
    1194:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
    1198:	2f656475 	svccs	0x00656475
    119c:	72616f62 	rsbvc	r6, r1, #392	; 0x188
    11a0:	70722f64 	rsbsvc	r2, r2, r4, ror #30
    11a4:	682f3069 	stmdavs	pc!, {r0, r3, r5, r6, ip, sp}	; <UNPREDICTABLE>
    11a8:	00006c61 	andeq	r6, r0, r1, ror #24
    11ac:	70616548 	rsbvc	r6, r1, r8, asr #10
    11b0:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
    11b4:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
    11b8:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
    11bc:	00000100 	andeq	r0, r0, r0, lsl #2
    11c0:	70616548 	rsbvc	r6, r1, r8, asr #10
    11c4:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
    11c8:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
    11cc:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
    11d0:	6e690000 	cdpvs	0, 6, cr0, cr9, cr0, {0}
    11d4:	66656474 			; <UNDEFINED> instruction: 0x66656474
    11d8:	0300682e 	movweq	r6, #2094	; 0x82e
    11dc:	05000000 	streq	r0, [r0, #-0]
    11e0:	02050001 	andeq	r0, r5, #1
    11e4:	00009de8 	andeq	r9, r0, r8, ror #27
    11e8:	821c0518 	andshi	r0, ip, #24, 10	; 0x6000000
    11ec:	20081e05 	andcs	r1, r8, r5, lsl #28
    11f0:	05a01a05 	streq	r1, [r0, #2565]!	; 0xa05
    11f4:	05058628 	streq	r8, [r5, #-1576]	; 0xfffff9d8
    11f8:	052f2f4a 	streq	r2, [pc, #-3914]!	; 2b6 <shift+0x2b6>
    11fc:	05054d08 	streq	r4, [r5, #-3336]	; 0xfffff2f8
    1200:	4b15054a 	blmi	542730 <__bss_end+0x5363f0>
    1204:	05671d05 	strbeq	r1, [r7, #-3333]!	; 0xfffff2fb
    1208:	13054a1b 	movwne	r4, #23067	; 0x5a1b
    120c:	4b09054a 	blmi	24273c <__bss_end+0x2363fc>
    1210:	05300f05 	ldreq	r0, [r0, #-3845]!	; 0xfffff0fb
    1214:	0f054a12 	svceq	0x00054a12
    1218:	6701054a 	strvs	r0, [r1, -sl, asr #10]
    121c:	05692905 	strbeq	r2, [r9, #-2309]!	; 0xfffff6fb
    1220:	0105830c 	tsteq	r5, ip, lsl #6
    1224:	8429054b 	strthi	r0, [r9], #-1355	; 0xfffffab5
    1228:	05a00b05 	streq	r0, [r0, #2821]!	; 0xb05
    122c:	20054a17 	andcs	r4, r5, r7, lsl sl
    1230:	4a1e054a 	bmi	782760 <__bss_end+0x776420>
    1234:	054b0d05 	strbeq	r0, [fp, #-3333]	; 0xfffff2fb
    1238:	0e054905 	vmlaeq.f16	s8, s10, s10	; <UNPREDICTABLE>
    123c:	67110530 			; <UNDEFINED> instruction: 0x67110530
    1240:	05bb2b05 	ldreq	r2, [fp, #2821]!	; 0xb05
    1244:	9e662f01 	cdpls	15, 6, cr2, cr6, cr1, {0}
    1248:	01040200 	mrseq	r0, R12_usr
    124c:	0e056606 	cfmadd32eq	mvax0, mvfx6, mvfx5, mvfx6
    1250:	825d0306 	subshi	r0, sp, #402653184	; 0x18000000
    1254:	23030105 	movwcs	r0, #12549	; 0x3105
    1258:	024a9e4a 	subeq	r9, sl, #1184	; 0x4a0
    125c:	0101000a 	tsteq	r1, sl
    1260:	000000d5 	ldrdeq	r0, [r0], -r5
    1264:	00790003 	rsbseq	r0, r9, r3
    1268:	01020000 	mrseq	r0, (UNDEF: 2)
    126c:	000d0efb 	strdeq	r0, [sp], -fp
    1270:	01010101 	tsteq	r1, r1, lsl #2
    1274:	01000000 	mrseq	r0, (UNDEF: 0)
    1278:	2f010000 	svccs	0x00010000
    127c:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
    1280:	6572742f 	ldrbvs	r7, [r2, #-1071]!	; 0xfffffbd1
    1284:	2f6c6966 	svccs	0x006c6966
    1288:	2f6d6573 	svccs	0x006d6573
    128c:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
    1290:	2f736563 	svccs	0x00736563
    1294:	6c647473 	cfstrdvs	mvd7, [r4], #-460	; 0xfffffe34
    1298:	732f6269 			; <UNDEFINED> instruction: 0x732f6269
    129c:	2f006372 	svccs	0x00006372
    12a0:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
    12a4:	6572742f 	ldrbvs	r7, [r2, #-1071]!	; 0xfffffbd1
    12a8:	2f6c6966 	svccs	0x006c6966
    12ac:	2f6d6573 	svccs	0x006d6573
    12b0:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
    12b4:	2f736563 	svccs	0x00736563
    12b8:	6c647473 	cfstrdvs	mvd7, [r4], #-460	; 0xfffffe34
    12bc:	692f6269 	stmdbvs	pc!, {r0, r3, r5, r6, r9, sp, lr}	; <UNPREDICTABLE>
    12c0:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
    12c4:	00006564 	andeq	r6, r0, r4, ror #10
    12c8:	646e6152 	strbtvs	r6, [lr], #-338	; 0xfffffeae
    12cc:	632e6d6f 			; <UNDEFINED> instruction: 0x632e6d6f
    12d0:	01007070 	tsteq	r0, r0, ror r0
    12d4:	61520000 	cmpvs	r2, r0
    12d8:	6d6f646e 	cfstrdvs	mvd6, [pc, #-440]!	; 1128 <shift+0x1128>
    12dc:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
    12e0:	05000000 	streq	r0, [r0, #-0]
    12e4:	02050001 	andeq	r0, r5, #1
    12e8:	00009fc0 	andeq	r9, r0, r0, asr #31
    12ec:	d7300516 			; <UNDEFINED> instruction: 0xd7300516
    12f0:	24020205 	strcs	r0, [r2], #-517	; 0xfffffdfb
    12f4:	a1200513 			; <UNDEFINED> instruction: 0xa1200513
    12f8:	05830805 	streq	r0, [r3, #2053]	; 0x805
    12fc:	20054a05 	andcs	r4, r5, r5, lsl #20
    1300:	4a1e054b 	bmi	782834 <__bss_end+0x7764f4>
    1304:	054b1005 	strbeq	r1, [fp, #-5]
    1308:	11054a12 	tstne	r5, r2, lsl sl
    130c:	2e29054a 	cfsh64cs	mvdx0, mvdx9, #42
    1310:	054a0905 	strbeq	r0, [sl, #-2309]	; 0xfffff6fb
    1314:	09054b18 	stmdbeq	r5, {r3, r4, r8, r9, fp, lr}
    1318:	bd1a054a 	cfldr32lt	mvfx0, [sl, #-296]	; 0xfffffed8
    131c:	05670c05 	strbeq	r0, [r7, #-3077]!	; 0xfffff3fb
    1320:	25052f01 	strcs	r2, [r5, #-3841]	; 0xfffff0ff
    1324:	8317056a 	tsthi	r7, #444596224	; 0x1a800000
    1328:	05671d05 	strbeq	r1, [r7, #-3333]!	; 0xfffff2fb
    132c:	0c059e0b 	stceq	14, cr9, [r5], {11}
    1330:	4b01054b 	blmi	42864 <__bss_end+0x36524>
    1334:	01000c02 	tsteq	r0, r2, lsl #24
    1338:	0002e901 	andeq	lr, r2, r1, lsl #18
    133c:	7b000300 	blvc	1f44 <shift+0x1f44>
    1340:	02000001 	andeq	r0, r0, #1
    1344:	0d0efb01 	vstreq	d15, [lr, #-4]
    1348:	01010100 	mrseq	r0, (UNDEF: 17)
    134c:	00000001 	andeq	r0, r0, r1
    1350:	01000001 	tsteq	r0, r1
    1354:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 12a0 <shift+0x12a0>
    1358:	72742f65 	rsbsvc	r2, r4, #404	; 0x194
    135c:	6c696665 	stclvs	6, cr6, [r9], #-404	; 0xfffffe6c
    1360:	6d65732f 	stclvs	3, cr7, [r5, #-188]!	; 0xffffff44
    1364:	756f732f 	strbvc	r7, [pc, #-815]!	; 103d <shift+0x103d>
    1368:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
    136c:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
    1370:	2f62696c 	svccs	0x0062696c
    1374:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
    1378:	00656475 	rsbeq	r6, r5, r5, ror r4
    137c:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 12c8 <shift+0x12c8>
    1380:	72742f65 	rsbsvc	r2, r4, #404	; 0x194
    1384:	6c696665 	stclvs	6, cr6, [r9], #-404	; 0xfffffe6c
    1388:	6d65732f 	stclvs	3, cr7, [r5, #-188]!	; 0xffffff44
    138c:	756f732f 	strbvc	r7, [pc, #-815]!	; 1065 <shift+0x1065>
    1390:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
    1394:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
    1398:	2f62696c 	svccs	0x0062696c
    139c:	00637273 	rsbeq	r7, r3, r3, ror r2
    13a0:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 12ec <shift+0x12ec>
    13a4:	72742f65 	rsbsvc	r2, r4, #404	; 0x194
    13a8:	6c696665 	stclvs	6, cr6, [r9], #-404	; 0xfffffe6c
    13ac:	6d65732f 	stclvs	3, cr7, [r5, #-188]!	; 0xffffff44
    13b0:	756f732f 	strbvc	r7, [pc, #-815]!	; 1089 <shift+0x1089>
    13b4:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
    13b8:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
    13bc:	2f6c656e 	svccs	0x006c656e
    13c0:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
    13c4:	2f656475 	svccs	0x00656475
    13c8:	636f7270 	cmnvs	pc, #112, 4
    13cc:	00737365 	rsbseq	r7, r3, r5, ror #6
    13d0:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 131c <shift+0x131c>
    13d4:	72742f65 	rsbsvc	r2, r4, #404	; 0x194
    13d8:	6c696665 	stclvs	6, cr6, [r9], #-404	; 0xfffffe6c
    13dc:	6d65732f 	stclvs	3, cr7, [r5, #-188]!	; 0xffffff44
    13e0:	756f732f 	strbvc	r7, [pc, #-815]!	; 10b9 <shift+0x10b9>
    13e4:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
    13e8:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
    13ec:	2f6c656e 	svccs	0x006c656e
    13f0:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
    13f4:	2f656475 	svccs	0x00656475
    13f8:	2f007366 	svccs	0x00007366
    13fc:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
    1400:	6572742f 	ldrbvs	r7, [r2, #-1071]!	; 0xfffffbd1
    1404:	2f6c6966 	svccs	0x006c6966
    1408:	2f6d6573 	svccs	0x006d6573
    140c:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
    1410:	2f736563 	svccs	0x00736563
    1414:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
    1418:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
    141c:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
    1420:	622f6564 	eorvs	r6, pc, #100, 10	; 0x19000000
    1424:	6472616f 	ldrbtvs	r6, [r2], #-367	; 0xfffffe91
    1428:	6970722f 	ldmdbvs	r0!, {r0, r1, r2, r3, r5, r9, ip, sp, lr}^
    142c:	61682f30 	cmnvs	r8, r0, lsr pc
    1430:	6d00006c 	stcvs	0, cr0, [r0, #-432]	; 0xfffffe50
    1434:	726f6d65 	rsbvc	r6, pc, #6464	; 0x1940
    1438:	00682e79 	rsbeq	r2, r8, r9, ror lr
    143c:	73000001 	movwvc	r0, #1
    1440:	75626474 	strbvc	r6, [r2, #-1140]!	; 0xfffffb8c
    1444:	72656666 	rsbvc	r6, r5, #106954752	; 0x6600000
    1448:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
    144c:	00000200 	andeq	r0, r0, r0, lsl #4
    1450:	6e697073 	mcrvs	0, 3, r7, cr9, cr3, {3}
    1454:	6b636f6c 	blvs	18dd20c <__bss_end+0x18d0ecc>
    1458:	0300682e 	movweq	r6, #2094	; 0x82e
    145c:	69660000 	stmdbvs	r6!, {}^	; <UNPREDICTABLE>
    1460:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
    1464:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
    1468:	0400682e 	streq	r6, [r0], #-2094	; 0xfffff7d2
    146c:	72700000 	rsbsvc	r0, r0, #0
    1470:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    1474:	00682e73 	rsbeq	r2, r8, r3, ror lr
    1478:	70000003 	andvc	r0, r0, r3
    147c:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    1480:	6d5f7373 	ldclvs	3, cr7, [pc, #-460]	; 12bc <shift+0x12bc>
    1484:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
    1488:	682e7265 	stmdavs	lr!, {r0, r2, r5, r6, r9, ip, sp, lr}
    148c:	00000300 	andeq	r0, r0, r0, lsl #6
    1490:	70616548 	rsbvc	r6, r1, r8, asr #10
    1494:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
    1498:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
    149c:	0100682e 	tsteq	r0, lr, lsr #16
    14a0:	74730000 	ldrbtvc	r0, [r3], #-0
    14a4:	66756264 	ldrbtvs	r6, [r5], -r4, ror #4
    14a8:	2e726566 	cdpcs	5, 7, cr6, cr2, cr6, {3}
    14ac:	00010068 	andeq	r0, r1, r8, rrx
    14b0:	746e6900 	strbtvc	r6, [lr], #-2304	; 0xfffff700
    14b4:	2e666564 	cdpcs	5, 6, cr6, cr6, cr4, {3}
    14b8:	00050068 	andeq	r0, r5, r8, rrx
    14bc:	01050000 	mrseq	r0, (UNDEF: 5)
    14c0:	e0020500 	and	r0, r2, r0, lsl #10
    14c4:	03000086 	movweq	r0, #134	; 0x86
    14c8:	1305010d 	movwne	r0, #20749	; 0x510d
    14cc:	83010583 	movwhi	r0, #5507	; 0x1583
    14d0:	01000802 	tsteq	r0, r2, lsl #16
    14d4:	05020401 	streq	r0, [r2, #-1025]	; 0xfffffbff
    14d8:	02050001 	andeq	r0, r5, #1
    14dc:	0000a120 	andeq	sl, r0, r0, lsr #2
    14e0:	9e320517 	mrcls	5, 1, r0, cr2, cr7, {0}
    14e4:	20083405 	andcs	r3, r8, r5, lsl #8
    14e8:	05a11805 	streq	r1, [r1, #2053]!	; 0x805
    14ec:	1c05830c 	stcne	3, cr8, [r5], {12}
    14f0:	bb01054a 	bllt	42a20 <__bss_end+0x366e0>
    14f4:	05841705 	streq	r1, [r4, #1797]	; 0x705
    14f8:	1d05830c 	stcne	3, cr8, [r5, #-48]	; 0xffffffd0
    14fc:	8301054a 	movwhi	r0, #5450	; 0x154a
    1500:	05841e05 	streq	r1, [r4, #3589]	; 0xe05
    1504:	1f05bb10 	svcne	0x0005bb10
    1508:	8305054a 	movwhi	r0, #21834	; 0x554a
    150c:	054a1205 	strbeq	r1, [sl, #-517]	; 0xfffffdfb
    1510:	15056701 	strne	r6, [r5, #-1793]	; 0xfffff8ff
    1514:	83120584 	tsthi	r2, #132, 10	; 0x21000000
    1518:	05671305 	strbeq	r1, [r7, #-773]!	; 0xfffffcfb
    151c:	29056701 	stmdbcs	r5, {r0, r8, r9, sl, sp, lr}
    1520:	9f0a0585 	svcls	0x000a0585
    1524:	054a1c05 	strbeq	r1, [sl, #-3077]	; 0xfffff3fb
    1528:	0105660a 	tsteq	r5, sl, lsl #12
    152c:	6e1f0583 	cdpvs	5, 1, cr0, cr15, cr3, {4}
    1530:	05842305 	streq	r2, [r4, #773]	; 0x305
    1534:	05058408 	streq	r8, [r5, #-1032]	; 0xfffffbf8
    1538:	4b1e0566 	blmi	782ad8 <__bss_end+0x776798>
    153c:	054a2405 	strbeq	r2, [sl, #-1029]	; 0xfffffbfb
    1540:	09054a1e 	stmdbeq	r5, {r1, r2, r3, r4, r9, fp, lr}
    1544:	67160584 	ldrvs	r0, [r6, -r4, lsl #11]
    1548:	05690805 	strbeq	r0, [r9, #-2053]!	; 0xfffff7fb
    154c:	22054a05 	andcs	r4, r5, #20480	; 0x5000
    1550:	01040200 	mrseq	r0, R12_usr
    1554:	4c0a054a 	cfstr32mi	mvfx0, [sl], {74}	; 0x4a
    1558:	054b0b05 	strbeq	r0, [fp, #-2821]	; 0xfffff4fb
    155c:	04020014 	streq	r0, [r2], #-20	; 0xffffffec
    1560:	10054a01 	andne	r4, r5, r1, lsl #20
    1564:	01040200 	mrseq	r0, R12_usr
    1568:	0012054a 	andseq	r0, r2, sl, asr #10
    156c:	2e010402 	cdpcs	4, 0, cr0, cr1, cr2, {0}
    1570:	054b1805 	strbeq	r1, [fp, #-2053]	; 0xfffff7fb
    1574:	22059e09 	andcs	r9, r5, #9, 28	; 0x90
    1578:	01040200 	mrseq	r0, R12_usr
    157c:	6718054a 	ldrvs	r0, [r8, -sl, asr #10]
    1580:	054b0d05 	strbeq	r0, [fp, #-3333]	; 0xfffff2fb
    1584:	04020005 	streq	r0, [r2], #-5
    1588:	08052b02 	stmdaeq	r5, {r1, r8, r9, fp, sp}
    158c:	05820903 	streq	r0, [r2, #2307]	; 0x903
    1590:	09056605 	stmdbeq	r5, {r0, r2, r9, sl, sp, lr}
    1594:	6712054b 	ldrvs	r0, [r2, -fp, asr #10]
    1598:	054b1005 	strbeq	r1, [fp, #-5]
    159c:	0b054e1c 	bleq	154e14 <__bss_end+0x148ad4>
    15a0:	00120584 	andseq	r0, r2, r4, lsl #11
    15a4:	4a030402 	bmi	c25b4 <__bss_end+0xb6274>
    15a8:	02000d05 	andeq	r0, r0, #320	; 0x140
    15ac:	05830204 	streq	r0, [r3, #516]	; 0x204
    15b0:	0402000e 	streq	r0, [r2], #-14
    15b4:	1e052e02 	cdpne	14, 0, cr2, cr5, cr2, {0}
    15b8:	02040200 	andeq	r0, r4, #0, 4
    15bc:	0010054a 	andseq	r0, r0, sl, asr #10
    15c0:	9e020402 	cdpls	4, 0, cr0, cr2, cr2, {0}
    15c4:	02000505 	andeq	r0, r0, #20971520	; 0x1400000
    15c8:	052d0204 	streq	r0, [sp, #-516]!	; 0xfffffdfc
    15cc:	0a058509 	beq	1629f8 <__bss_end+0x1566b8>
    15d0:	4a0c052e 	bmi	302a90 <__bss_end+0x2f6750>
    15d4:	054c1305 	strbeq	r1, [ip, #-773]	; 0xfffffcfb
    15d8:	0505670c 	streq	r6, [r5, #-1804]	; 0xfffff8f4
    15dc:	6825052f 	stmdavs	r5!, {r0, r1, r2, r3, r5, r8, sl}
    15e0:	059f1205 	ldreq	r1, [pc, #517]	; 17ed <shift+0x17ed>
    15e4:	0402001b 	streq	r0, [r2], #-27	; 0xffffffe5
    15e8:	11054a03 	tstne	r5, r3, lsl #20
    15ec:	02040200 	andeq	r0, r4, #0, 4
    15f0:	00050583 	andeq	r0, r5, r3, lsl #11
    15f4:	f1020402 			; <UNDEFINED> instruction: 0xf1020402
    15f8:	05850105 	streq	r0, [r5, #261]	; 0x105
    15fc:	1e056839 	mcrne	8, 0, r6, cr5, cr9, {1}
    1600:	680905a2 	stmdavs	r9, {r1, r5, r7, r8, sl}
    1604:	05682605 	strbeq	r2, [r8, #-1541]!	; 0xfffff9fb
    1608:	1705670d 	strne	r6, [r5, -sp, lsl #14]
    160c:	67120585 	ldrvs	r0, [r2, -r5, lsl #11]
    1610:	054d0905 	strbeq	r0, [sp, #-2309]	; 0xfffff6fb
    1614:	11052f05 	tstne	r5, r5, lsl #30
    1618:	052e7903 	streq	r7, [lr, #-2307]!	; 0xfffff6fd
    161c:	0105360c 	tsteq	r5, ip, lsl #12
    1620:	0008022f 	andeq	r0, r8, pc, lsr #4
    1624:	02180101 	andseq	r0, r8, #1073741824	; 0x40000000
    1628:	00030000 	andeq	r0, r3, r0
    162c:	0000012d 	andeq	r0, r0, sp, lsr #2
    1630:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
    1634:	0101000d 	tsteq	r1, sp
    1638:	00000101 	andeq	r0, r0, r1, lsl #2
    163c:	00000100 	andeq	r0, r0, r0, lsl #2
    1640:	6f682f01 	svcvs	0x00682f01
    1644:	742f656d 	strtvc	r6, [pc], #-1389	; 164c <shift+0x164c>
    1648:	69666572 	stmdbvs	r6!, {r1, r4, r5, r6, r8, sl, sp, lr}^
    164c:	65732f6c 	ldrbvs	r2, [r3, #-3948]!	; 0xfffff094
    1650:	6f732f6d 	svcvs	0x00732f6d
    1654:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
    1658:	74732f73 	ldrbtvc	r2, [r3], #-3955	; 0xfffff08d
    165c:	62696c64 	rsbvs	r6, r9, #100, 24	; 0x6400
    1660:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
    1664:	6f682f00 	svcvs	0x00682f00
    1668:	742f656d 	strtvc	r6, [pc], #-1389	; 1670 <shift+0x1670>
    166c:	69666572 	stmdbvs	r6!, {r1, r4, r5, r6, r8, sl, sp, lr}^
    1670:	65732f6c 	ldrbvs	r2, [r3, #-3948]!	; 0xfffff094
    1674:	6f732f6d 	svcvs	0x00732f6d
    1678:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
    167c:	656b2f73 	strbvs	r2, [fp, #-3955]!	; 0xfffff08d
    1680:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
    1684:	636e692f 	cmnvs	lr, #770048	; 0xbc000
    1688:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
    168c:	6f72702f 	svcvs	0x0072702f
    1690:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    1694:	6f682f00 	svcvs	0x00682f00
    1698:	742f656d 	strtvc	r6, [pc], #-1389	; 16a0 <shift+0x16a0>
    169c:	69666572 	stmdbvs	r6!, {r1, r4, r5, r6, r8, sl, sp, lr}^
    16a0:	65732f6c 	ldrbvs	r2, [r3, #-3948]!	; 0xfffff094
    16a4:	6f732f6d 	svcvs	0x00732f6d
    16a8:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
    16ac:	656b2f73 	strbvs	r2, [fp, #-3955]!	; 0xfffff08d
    16b0:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
    16b4:	636e692f 	cmnvs	lr, #770048	; 0xbc000
    16b8:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
    16bc:	0073662f 	rsbseq	r6, r3, pc, lsr #12
    16c0:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 160c <shift+0x160c>
    16c4:	72742f65 	rsbsvc	r2, r4, #404	; 0x194
    16c8:	6c696665 	stclvs	6, cr6, [r9], #-404	; 0xfffffe6c
    16cc:	6d65732f 	stclvs	3, cr7, [r5, #-188]!	; 0xffffff44
    16d0:	756f732f 	strbvc	r7, [pc, #-815]!	; 13a9 <shift+0x13a9>
    16d4:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
    16d8:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
    16dc:	2f6c656e 	svccs	0x006c656e
    16e0:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
    16e4:	2f656475 	svccs	0x00656475
    16e8:	72616f62 	rsbvc	r6, r1, #392	; 0x188
    16ec:	70722f64 	rsbsvc	r2, r2, r4, ror #30
    16f0:	682f3069 	stmdavs	pc!, {r0, r3, r5, r6, ip, sp}	; <UNPREDICTABLE>
    16f4:	00006c61 	andeq	r6, r0, r1, ror #24
    16f8:	66647473 			; <UNDEFINED> instruction: 0x66647473
    16fc:	2e656c69 	cdpcs	12, 6, cr6, cr5, cr9, {3}
    1700:	00707063 	rsbseq	r7, r0, r3, rrx
    1704:	73000001 	movwvc	r0, #1
    1708:	682e6977 	stmdavs	lr!, {r0, r1, r2, r4, r5, r6, r8, fp, sp, lr}
    170c:	00000200 	andeq	r0, r0, r0, lsl #4
    1710:	6e697073 	mcrvs	0, 3, r7, cr9, cr3, {3}
    1714:	6b636f6c 	blvs	18dd4cc <__bss_end+0x18d118c>
    1718:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
    171c:	69660000 	stmdbvs	r6!, {}^	; <UNPREDICTABLE>
    1720:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
    1724:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
    1728:	0300682e 	movweq	r6, #2094	; 0x82e
    172c:	72700000 	rsbsvc	r0, r0, #0
    1730:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    1734:	00682e73 	rsbeq	r2, r8, r3, ror lr
    1738:	70000002 	andvc	r0, r0, r2
    173c:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    1740:	6d5f7373 	ldclvs	3, cr7, [pc, #-460]	; 157c <shift+0x157c>
    1744:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
    1748:	682e7265 	stmdavs	lr!, {r0, r2, r5, r6, r9, ip, sp, lr}
    174c:	00000200 	andeq	r0, r0, r0, lsl #4
    1750:	64746e69 	ldrbtvs	r6, [r4], #-3689	; 0xfffff197
    1754:	682e6665 	stmdavs	lr!, {r0, r2, r5, r6, r9, sl, sp, lr}
    1758:	00000400 	andeq	r0, r0, r0, lsl #8
    175c:	00010500 	andeq	r0, r1, r0, lsl #10
    1760:	a5400205 	strbge	r0, [r0, #-517]	; 0xfffffdfb
    1764:	05160000 	ldreq	r0, [r6, #-0]
    1768:	052f6905 	streq	r6, [pc, #-2309]!	; e6b <shift+0xe6b>
    176c:	01054c0c 	tsteq	r5, ip, lsl #24
    1770:	0505852f 	streq	r8, [r5, #-1327]	; 0xfffffad1
    1774:	01054b83 	smlabbeq	r5, r3, fp, r4
    1778:	0505852f 	streq	r8, [r5, #-1327]	; 0xfffffad1
    177c:	2f01054b 	svccs	0x0001054b
    1780:	a1050585 	smlabbge	r5, r5, r5, r0
    1784:	052f4b4b 	streq	r4, [pc, #-2891]!	; c41 <shift+0xc41>
    1788:	01054c0c 	tsteq	r5, ip, lsl #24
    178c:	0505852f 	streq	r8, [r5, #-1327]	; 0xfffffad1
    1790:	4b4b4bbd 	blmi	12d468c <__bss_end+0x12c834c>
    1794:	4c0c052f 	cfstr32mi	mvfx0, [ip], {47}	; 0x2f
    1798:	862f0105 	strthi	r0, [pc], -r5, lsl #2
    179c:	4bbd0505 	blmi	fef42bb8 <__bss_end+0xfef36878>
    17a0:	052f4b4b 	streq	r4, [pc, #-2891]!	; c5d <shift+0xc5d>
    17a4:	01054c0c 	tsteq	r5, ip, lsl #24
    17a8:	0505852f 	streq	r8, [r5, #-1327]	; 0xfffffad1
    17ac:	01054b83 	smlabbeq	r5, r3, fp, r4
    17b0:	0505852f 	streq	r8, [r5, #-1327]	; 0xfffffad1
    17b4:	4b4b4bbd 	blmi	12d46b0 <__bss_end+0x12c8370>
    17b8:	4c0c052f 	cfstr32mi	mvfx0, [ip], {47}	; 0x2f
    17bc:	852f0105 	strhi	r0, [pc, #-261]!	; 16bf <shift+0x16bf>
    17c0:	4ba10505 	blmi	fe842bdc <__bss_end+0xfe83689c>
    17c4:	0c052f4b 	stceq	15, cr2, [r5], {75}	; 0x4b
    17c8:	2f01054c 	svccs	0x0001054c
    17cc:	bd050585 	cfstr32lt	mvfx0, [r5, #-532]	; 0xfffffdec
    17d0:	2f4b4b4b 	svccs	0x004b4b4b
    17d4:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
    17d8:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
    17dc:	4b4ba105 	blmi	12e9bf8 <__bss_end+0x12dd8b8>
    17e0:	4c0c052f 	cfstr32mi	mvfx0, [ip], {47}	; 0x2f
    17e4:	859f0105 	ldrhi	r0, [pc, #261]	; 18f1 <shift+0x18f1>
    17e8:	05672005 	strbeq	r2, [r7, #-5]!
    17ec:	4b4b4d05 	blmi	12d4c08 <__bss_end+0x12c88c8>
    17f0:	05300c05 	ldreq	r0, [r0, #-3077]!	; 0xfffff3fb
    17f4:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
    17f8:	05056720 	streq	r6, [r5, #-1824]	; 0xfffff8e0
    17fc:	054b4b4d 	strbeq	r4, [fp, #-2893]	; 0xfffff4b3
    1800:	0105300c 	tsteq	r5, ip
    1804:	2005852f 	andcs	r8, r5, pc, lsr #10
    1808:	4c050583 	cfstr32mi	mvfx0, [r5], {131}	; 0x83
    180c:	01054b4b 	tsteq	r5, fp, asr #22
    1810:	2005852f 	andcs	r8, r5, pc, lsr #10
    1814:	4d050567 	cfstr32mi	mvfx0, [r5, #-412]	; 0xfffffe64
    1818:	0c054b4b 			; <UNDEFINED> instruction: 0x0c054b4b
    181c:	2f010530 	svccs	0x00010530
    1820:	a00c0587 	andge	r0, ip, r7, lsl #11
    1824:	bc31059f 	cfldr32lt	mvfx0, [r1], #-636	; 0xfffffd84
    1828:	05662905 	strbeq	r2, [r6, #-2309]!	; 0xfffff6fb
    182c:	0f052e36 	svceq	0x00052e36
    1830:	66130530 			; <UNDEFINED> instruction: 0x66130530
    1834:	05840905 	streq	r0, [r4, #2309]	; 0x905
    1838:	0105d810 	tsteq	r5, r0, lsl r8
    183c:	0008029f 	muleq	r8, pc, r2	; <UNPREDICTABLE>
    1840:	050d0101 	streq	r0, [sp, #-257]	; 0xfffffeff
    1844:	00030000 	andeq	r0, r3, r0
    1848:	00000048 	andeq	r0, r0, r8, asr #32
    184c:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
    1850:	0101000d 	tsteq	r1, sp
    1854:	00000101 	andeq	r0, r0, r1, lsl #2
    1858:	00000100 	andeq	r0, r0, r0, lsl #2
    185c:	6f682f01 	svcvs	0x00682f01
    1860:	742f656d 	strtvc	r6, [pc], #-1389	; 1868 <shift+0x1868>
    1864:	69666572 	stmdbvs	r6!, {r1, r4, r5, r6, r8, sl, sp, lr}^
    1868:	65732f6c 	ldrbvs	r2, [r3, #-3948]!	; 0xfffff094
    186c:	6f732f6d 	svcvs	0x00732f6d
    1870:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
    1874:	74732f73 	ldrbtvc	r2, [r3], #-3955	; 0xfffff08d
    1878:	62696c64 	rsbvs	r6, r9, #100, 24	; 0x6400
    187c:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
    1880:	74730000 	ldrbtvc	r0, [r3], #-0
    1884:	72747364 	rsbsvc	r7, r4, #100, 6	; 0x90000001
    1888:	2e676e69 	cdpcs	14, 6, cr6, cr7, cr9, {3}
    188c:	00707063 	rsbseq	r7, r0, r3, rrx
    1890:	00000001 	andeq	r0, r0, r1
    1894:	05000105 	streq	r0, [r0, #-261]	; 0xfffffefb
    1898:	00a9a002 	adceq	sl, r9, r2
    189c:	09051a00 	stmdbeq	r5, {r9, fp, ip}
    18a0:	0f054bbb 	svceq	0x00054bbb
    18a4:	681b054c 	ldmdavs	fp, {r2, r3, r6, r8, sl}
    18a8:	052e2105 	streq	r2, [lr, #-261]!	; 0xfffffefb
    18ac:	0b059e0a 	bleq	1690dc <__bss_end+0x15cd9c>
    18b0:	4a27052e 	bmi	9c2d70 <__bss_end+0x9b6a30>
    18b4:	054a0d05 	strbeq	r0, [sl, #-3333]	; 0xfffff2fb
    18b8:	04052f09 	streq	r2, [r5], #-3849	; 0xfffff0f7
    18bc:	620205bb 	andvs	r0, r2, #784334848	; 0x2ec00000
    18c0:	05350505 	ldreq	r0, [r5, #-1285]!	; 0xfffffafb
    18c4:	11056810 	tstne	r5, r0, lsl r8
    18c8:	4a22052e 	bmi	882d88 <__bss_end+0x876a48>
    18cc:	052e1305 	streq	r1, [lr, #-773]!	; 0xfffffcfb
    18d0:	09052f0a 	stmdbeq	r5, {r1, r3, r8, r9, sl, fp, sp}
    18d4:	2e0a0569 	cfsh32cs	mvfx0, mvfx10, #57
    18d8:	054a0c05 	strbeq	r0, [sl, #-3077]	; 0xfffff3fb
    18dc:	10054b03 	andne	r4, r5, r3, lsl #22
    18e0:	02040200 	andeq	r0, r4, #0, 4
    18e4:	000c0568 	andeq	r0, ip, r8, ror #10
    18e8:	9e020402 	cdpls	4, 0, cr0, cr2, cr2, {0}
    18ec:	02001505 	andeq	r1, r0, #20971520	; 0x1400000
    18f0:	05680104 	strbeq	r0, [r8, #-260]!	; 0xfffffefc
    18f4:	04020018 	streq	r0, [r2], #-24	; 0xffffffe8
    18f8:	08058201 	stmdaeq	r5, {r0, r9, pc}
    18fc:	01040200 	mrseq	r0, R12_usr
    1900:	001a054a 	andseq	r0, sl, sl, asr #10
    1904:	4b010402 	blmi	42914 <__bss_end+0x365d4>
    1908:	02001b05 	andeq	r1, r0, #5120	; 0x1400
    190c:	052e0104 	streq	r0, [lr, #-260]!	; 0xfffffefc
    1910:	0402000c 	streq	r0, [r2], #-12
    1914:	0f054a01 	svceq	0x00054a01
    1918:	01040200 	mrseq	r0, R12_usr
    191c:	001b0582 	andseq	r0, fp, r2, lsl #11
    1920:	4a010402 	bmi	42930 <__bss_end+0x365f0>
    1924:	02001105 	andeq	r1, r0, #1073741825	; 0x40000001
    1928:	052e0104 	streq	r0, [lr, #-260]!	; 0xfffffefc
    192c:	0402000a 	streq	r0, [r2], #-10
    1930:	0b052f01 	bleq	14d53c <__bss_end+0x1411fc>
    1934:	01040200 	mrseq	r0, R12_usr
    1938:	000d052e 	andeq	r0, sp, lr, lsr #10
    193c:	4a010402 	bmi	4294c <__bss_end+0x3660c>
    1940:	02000205 	andeq	r0, r0, #1342177280	; 0x50000000
    1944:	05460104 	strbeq	r0, [r6, #-260]	; 0xfffffefc
    1948:	05858901 	streq	r8, [r5, #2305]	; 0x901
    194c:	1605830e 	strne	r8, [r5], -lr, lsl #6
    1950:	82050566 	andhi	r0, r5, #427819008	; 0x19800000
    1954:	054b1005 	strbeq	r1, [fp, #-5]
    1958:	06054a19 			; <UNDEFINED> instruction: 0x06054a19
    195c:	4c09054b 	cfstr32mi	mvfx0, [r9], {75}	; 0x4b
    1960:	054a1005 	strbeq	r1, [sl, #-5]
    1964:	07054c0a 	streq	r4, [r5, -sl, lsl #24]
    1968:	4a0305bb 	bmi	c305c <__bss_end+0xb6d1c>
    196c:	02001705 	andeq	r1, r0, #1310720	; 0x140000
    1970:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
    1974:	04020014 	streq	r0, [r2], #-20	; 0xffffffec
    1978:	0d054a01 	vstreq	s8, [r5, #-4]
    197c:	4a14054d 	bmi	502eb8 <__bss_end+0x4f6b78>
    1980:	052e0a05 	streq	r0, [lr, #-2565]!	; 0xfffff5fb
    1984:	02056808 	andeq	r6, r5, #8, 16	; 0x80000
    1988:	05667803 	strbeq	r7, [r6, #-2051]!	; 0xfffff7fd
    198c:	2e0b0309 	cdpcs	3, 0, cr0, cr11, cr9, {0}
    1990:	052f0105 	streq	r0, [pc, #-261]!	; 1893 <shift+0x1893>
    1994:	0a056a27 	beq	15c238 <__bss_end+0x14fef8>
    1998:	0b054b84 	bleq	1547b0 <__bss_end+0x148470>
    199c:	4a12054b 	bmi	482ed0 <__bss_end+0x476b90>
    19a0:	054b0e05 	strbeq	r0, [fp, #-3589]	; 0xfffff1fb
    19a4:	18056709 	stmdane	r5, {r0, r3, r8, r9, sl, sp, lr}
    19a8:	01040200 	mrseq	r0, R12_usr
    19ac:	00150566 	andseq	r0, r5, r6, ror #10
    19b0:	66010402 	strvs	r0, [r1], -r2, lsl #8
    19b4:	02001105 	andeq	r1, r0, #1073741825	; 0x40000001
    19b8:	054b0204 	strbeq	r0, [fp, #-516]	; 0xfffffdfc
    19bc:	0402001a 	streq	r0, [r2], #-26	; 0xffffffe6
    19c0:	12054b02 	andne	r4, r5, #2048	; 0x800
    19c4:	02040200 	andeq	r0, r4, #0, 4
    19c8:	000d054b 	andeq	r0, sp, fp, asr #10
    19cc:	67020402 	strvs	r0, [r2, -r2, lsl #8]
    19d0:	05310905 	ldreq	r0, [r1, #-2309]!	; 0xfffff6fb
    19d4:	04020014 	streq	r0, [r2], #-20	; 0xffffffec
    19d8:	26056602 	strcs	r6, [r5], -r2, lsl #12
    19dc:	03040200 	movweq	r0, #16896	; 0x4200
    19e0:	4c090566 	cfstr32mi	mvfx0, [r9], {102}	; 0x66
    19e4:	05671a05 	strbeq	r1, [r7, #-2565]!	; 0xfffff5fb
    19e8:	05054b0a 	streq	r4, [r5, #-2826]	; 0xfffff4f6
    19ec:	03667303 	cmneq	r6, #201326592	; 0xc000000
    19f0:	1c052e0f 	stcne	14, cr2, [r5], {15}
    19f4:	01040200 	mrseq	r0, R12_usr
    19f8:	4c0f0566 	cfstr32mi	mvfx0, [pc], {102}	; 0x66
    19fc:	01040200 	mrseq	r0, R12_usr
    1a00:	13056606 	movwne	r6, #22022	; 0x5606
    1a04:	01040200 	mrseq	r0, R12_usr
    1a08:	0f052e06 	svceq	0x00052e06
    1a0c:	02040200 	andeq	r0, r4, #0, 4
    1a10:	2e13052e 	cfmul64cs	mvdx0, mvdx3, mvdx14
    1a14:	05300105 	ldreq	r0, [r0, #-261]!	; 0xfffffefb
    1a18:	0c05861e 	stceq	6, cr8, [r5], {30}
    1a1c:	05686783 	strbeq	r6, [r8, #-1923]!	; 0xfffff87d
    1a20:	054b6709 	strbeq	r6, [fp, #-1801]	; 0xfffff8f7
    1a24:	0b054b0a 	bleq	154654 <__bss_end+0x148314>
    1a28:	4a12054c 	bmi	482f60 <__bss_end+0x476c20>
    1a2c:	054b0d05 	strbeq	r0, [fp, #-3333]	; 0xfffff2fb
    1a30:	1b054a09 	blne	15425c <__bss_end+0x147f1c>
    1a34:	01040200 	mrseq	r0, R12_usr
    1a38:	0012054b 	andseq	r0, r2, fp, asr #10
    1a3c:	4b010402 	blmi	42a4c <__bss_end+0x3670c>
    1a40:	02000d05 	andeq	r0, r0, #320	; 0x140
    1a44:	05670104 	strbeq	r0, [r7, #-260]!	; 0xfffffefc
    1a48:	0e053012 	mcreq	0, 0, r3, cr5, cr2, {0}
    1a4c:	0022054a 	eoreq	r0, r2, sl, asr #10
    1a50:	4a010402 	bmi	42a60 <__bss_end+0x36720>
    1a54:	02001f05 	andeq	r1, r0, #5, 30
    1a58:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
    1a5c:	1d054b16 	vstrne	d4, [r5, #-88]	; 0xffffffa8
    1a60:	2e10054a 	cfmac32cs	mvfx0, mvfx0, mvfx10
    1a64:	05670905 	strbeq	r0, [r7, #-2309]!	; 0xfffff6fb
    1a68:	23056713 	movwcs	r6, #22291	; 0x5713
    1a6c:	9e1405d7 	mrcls	5, 0, r0, cr4, cr7, {6}
    1a70:	05851d05 	streq	r1, [r5, #3333]	; 0xd05
    1a74:	0e056614 	mcreq	6, 0, r6, cr5, cr4, {0}
    1a78:	03050568 	movweq	r0, #21864	; 0x5568
    1a7c:	0c056671 	stceq	6, cr6, [r5], {113}	; 0x71
    1a80:	052e1103 	streq	r1, [lr, #-259]!	; 0xfffffefd
    1a84:	22084b01 	andcs	r4, r8, #1024	; 0x400
    1a88:	05bd0905 	ldreq	r0, [sp, #2309]!	; 0x905
    1a8c:	04020016 	streq	r0, [r2], #-22	; 0xffffffea
    1a90:	1d054a04 	vstrne	s8, [r5, #-16]
    1a94:	02040200 	andeq	r0, r4, #0, 4
    1a98:	001e0582 	andseq	r0, lr, r2, lsl #11
    1a9c:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
    1aa0:	02001605 	andeq	r1, r0, #5242880	; 0x500000
    1aa4:	05660204 	strbeq	r0, [r6, #-516]!	; 0xfffffdfc
    1aa8:	04020011 	streq	r0, [r2], #-17	; 0xffffffef
    1aac:	12054b03 	andne	r4, r5, #3072	; 0xc00
    1ab0:	03040200 	movweq	r0, #16896	; 0x4200
    1ab4:	0008052e 	andeq	r0, r8, lr, lsr #10
    1ab8:	4a030402 	bmi	c2ac8 <__bss_end+0xb6788>
    1abc:	02000905 	andeq	r0, r0, #81920	; 0x14000
    1ac0:	052e0304 	streq	r0, [lr, #-772]!	; 0xfffffcfc
    1ac4:	04020012 	streq	r0, [r2], #-18	; 0xffffffee
    1ac8:	0b054a03 	bleq	1542dc <__bss_end+0x147f9c>
    1acc:	03040200 	movweq	r0, #16896	; 0x4200
    1ad0:	0002052e 	andeq	r0, r2, lr, lsr #10
    1ad4:	2d030402 	cfstrscs	mvf0, [r3, #-8]
    1ad8:	02000b05 	andeq	r0, r0, #5120	; 0x1400
    1adc:	05840204 	streq	r0, [r4, #516]	; 0x204
    1ae0:	04020008 	streq	r0, [r2], #-8
    1ae4:	09058301 	stmdbeq	r5, {r0, r8, r9, pc}
    1ae8:	01040200 	mrseq	r0, R12_usr
    1aec:	000b052e 	andeq	r0, fp, lr, lsr #10
    1af0:	4a010402 	bmi	42b00 <__bss_end+0x367c0>
    1af4:	02000205 	andeq	r0, r0, #1342177280	; 0x50000000
    1af8:	05490104 	strbeq	r0, [r9, #-260]	; 0xfffffefc
    1afc:	0105850b 	tsteq	r5, fp, lsl #10
    1b00:	0e05852f 	cfsh32eq	mvfx8, mvfx5, #31
    1b04:	661105bc 			; <UNDEFINED> instruction: 0x661105bc
    1b08:	05bc2005 	ldreq	r2, [ip, #5]!
    1b0c:	1f05660b 	svcne	0x0005660b
    1b10:	660a054b 	strvs	r0, [sl], -fp, asr #10
    1b14:	054b0805 	strbeq	r0, [fp, #-2053]	; 0xfffff7fb
    1b18:	16058311 			; <UNDEFINED> instruction: 0x16058311
    1b1c:	6708052e 	strvs	r0, [r8, -lr, lsr #10]
    1b20:	05671105 	strbeq	r1, [r7, #-261]!	; 0xfffffefb
    1b24:	01054d0b 	tsteq	r5, fp, lsl #26
    1b28:	0605852f 	streq	r8, [r5], -pc, lsr #10
    1b2c:	4c0b0583 	cfstr32mi	mvfx0, [fp], {131}	; 0x83
    1b30:	052e0c05 	streq	r0, [lr, #-3077]!	; 0xfffff3fb
    1b34:	0405660e 	streq	r6, [r5], #-1550	; 0xfffff9f2
    1b38:	6502054b 	strvs	r0, [r2, #-1355]	; 0xfffffab5
    1b3c:	05310905 	ldreq	r0, [r1, #-2309]!	; 0xfffff6fb
    1b40:	2a052f01 	bcs	14d74c <__bss_end+0x14140c>
    1b44:	9f130585 	svcls	0x00130585
    1b48:	67090567 	strvs	r0, [r9, -r7, ror #10]
    1b4c:	054b0d05 	strbeq	r0, [fp, #-3333]	; 0xfffff2fb
    1b50:	04020015 	streq	r0, [r2], #-21	; 0xffffffeb
    1b54:	19054a03 	stmdbne	r5, {r0, r1, r9, fp, lr}
    1b58:	02040200 	andeq	r0, r4, #0, 4
    1b5c:	001a0583 	andseq	r0, sl, r3, lsl #11
    1b60:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
    1b64:	02000f05 	andeq	r0, r0, #5, 30
    1b68:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
    1b6c:	04020011 	streq	r0, [r2], #-17	; 0xffffffef
    1b70:	1a058202 	bne	162380 <__bss_end+0x156040>
    1b74:	02040200 	andeq	r0, r4, #0, 4
    1b78:	0013054a 	andseq	r0, r3, sl, asr #10
    1b7c:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
    1b80:	02000505 	andeq	r0, r0, #20971520	; 0x1400000
    1b84:	052d0204 	streq	r0, [sp, #-516]!	; 0xfffffdfc
    1b88:	0b05840a 	bleq	162bb8 <__bss_end+0x156878>
    1b8c:	4a0d052e 	bmi	34304c <__bss_end+0x336d0c>
    1b90:	054b0c05 	strbeq	r0, [fp, #-3077]	; 0xfffff3fb
    1b94:	34053001 	strcc	r3, [r5], #-1
    1b98:	bb090567 	bllt	24313c <__bss_end+0x236dfc>
    1b9c:	054c1305 	strbeq	r1, [ip, #-773]	; 0xfffffcfb
    1ba0:	19056805 	stmdbne	r5, {r0, r2, fp, sp, lr}
    1ba4:	01040200 	mrseq	r0, R12_usr
    1ba8:	4c0d0582 	cfstr32mi	mvfx0, [sp], {130}	; 0x82
    1bac:	02001505 	andeq	r1, r0, #20971520	; 0x1400000
    1bb0:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
    1bb4:	11058310 	tstne	r5, r0, lsl r3
    1bb8:	6609052e 	strvs	r0, [r9], -lr, lsr #10
    1bbc:	02001905 	andeq	r1, r0, #81920	; 0x14000
    1bc0:	054b0204 	strbeq	r0, [fp, #-516]	; 0xfffffdfc
    1bc4:	0402001a 	streq	r0, [r2], #-26	; 0xffffffe6
    1bc8:	0f052e02 	svceq	0x00052e02
    1bcc:	02040200 	andeq	r0, r4, #0, 4
    1bd0:	0011054a 	andseq	r0, r1, sl, asr #10
    1bd4:	82020402 	andhi	r0, r2, #33554432	; 0x2000000
    1bd8:	02001a05 	andeq	r1, r0, #20480	; 0x5000
    1bdc:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
    1be0:	04020013 	streq	r0, [r2], #-19	; 0xffffffed
    1be4:	05052e02 	streq	r2, [r5, #-3586]	; 0xfffff1fe
    1be8:	02040200 	andeq	r0, r4, #0, 4
    1bec:	831b052c 	tsthi	fp, #44, 10	; 0xb000000
    1bf0:	05310a05 	ldreq	r0, [r1, #-2565]!	; 0xfffff5fb
    1bf4:	0d052e0b 	stceq	14, cr2, [r5, #-44]	; 0xffffffd4
    1bf8:	4b0c054a 	blmi	303128 <__bss_end+0x2f6de8>
    1bfc:	6a300105 	bvs	c02018 <__bss_end+0xbf5cd8>
    1c00:	059f0805 	ldreq	r0, [pc, #2053]	; 240d <shift+0x240d>
    1c04:	14054c0b 	strne	r4, [r5], #-3083	; 0xfffff3f5
    1c08:	03040200 	movweq	r0, #16896	; 0x4200
    1c0c:	0007054a 	andeq	r0, r7, sl, asr #10
    1c10:	83020402 	movwhi	r0, #9218	; 0x2402
    1c14:	02000805 	andeq	r0, r0, #327680	; 0x50000
    1c18:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
    1c1c:	0402000a 	streq	r0, [r2], #-10
    1c20:	02054a02 	andeq	r4, r5, #8192	; 0x2000
    1c24:	02040200 	andeq	r0, r4, #0, 4
    1c28:	84010549 	strhi	r0, [r1], #-1353	; 0xfffffab7
    1c2c:	bb0e0585 	bllt	383248 <__bss_end+0x376f08>
    1c30:	054b0805 	strbeq	r0, [fp, #-2053]	; 0xfffff7fb
    1c34:	14054c0b 	strne	r4, [r5], #-3083	; 0xfffff3f5
    1c38:	03040200 	movweq	r0, #16896	; 0x4200
    1c3c:	0016054a 	andseq	r0, r6, sl, asr #10
    1c40:	83020402 	movwhi	r0, #9218	; 0x2402
    1c44:	02001705 	andeq	r1, r0, #1310720	; 0x140000
    1c48:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
    1c4c:	0402000a 	streq	r0, [r2], #-10
    1c50:	0b054a02 	bleq	154460 <__bss_end+0x148120>
    1c54:	02040200 	andeq	r0, r4, #0, 4
    1c58:	0017052e 	andseq	r0, r7, lr, lsr #10
    1c5c:	4a020402 	bmi	82c6c <__bss_end+0x7692c>
    1c60:	02000d05 	andeq	r0, r0, #320	; 0x140
    1c64:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
    1c68:	04020002 	streq	r0, [r2], #-2
    1c6c:	01052d02 	tsteq	r5, r2, lsl #26
    1c70:	09058784 	stmdbeq	r5, {r2, r7, r8, r9, sl, pc}
    1c74:	4b10059f 	blmi	4032f8 <__bss_end+0x3f6fb8>
    1c78:	05661305 	strbeq	r1, [r6, #-773]!	; 0xfffffcfb
    1c7c:	0505bb10 	streq	fp, [r5, #-2832]	; 0xfffff4f0
    1c80:	310c0581 	smlabbcc	ip, r1, r5, r0
    1c84:	862f0105 	strthi	r0, [pc], -r5, lsl #2
    1c88:	05a20a05 	streq	r0, [r2, #2565]!	; 0xa05
    1c8c:	0e056705 	cdpeq	7, 0, cr6, cr5, cr5, {0}
    1c90:	670b0584 	strvs	r0, [fp, -r4, lsl #11]
    1c94:	05690d05 	strbeq	r0, [r9, #-3333]!	; 0xfffff2fb
    1c98:	059f4b0c 	ldreq	r4, [pc, #2828]	; 27ac <shift+0x27ac>
    1c9c:	1705670d 	strne	r6, [r5, -sp, lsl #14]
    1ca0:	66150569 	ldrvs	r0, [r5], -r9, ror #10
    1ca4:	054a2d05 	strbeq	r2, [sl, #-3333]	; 0xfffff2fb
    1ca8:	0402003d 	streq	r0, [r2], #-61	; 0xffffffc3
    1cac:	3b056601 	blcc	15b4b8 <__bss_end+0x14f178>
    1cb0:	01040200 	mrseq	r0, R12_usr
    1cb4:	002d0566 	eoreq	r0, sp, r6, ror #10
    1cb8:	4a010402 	bmi	42cc8 <__bss_end+0x36988>
    1cbc:	05682b05 	strbeq	r2, [r8, #-2821]!	; 0xfffff4fb
    1cc0:	15054a1c 	strne	r4, [r5, #-2588]	; 0xfffff5e4
    1cc4:	2e110582 	cdpcs	5, 1, cr0, cr1, cr2, {4}
    1cc8:	a0671005 	rsbge	r1, r7, r5
    1ccc:	057d0505 	ldrbeq	r0, [sp, #-1285]!	; 0xfffffafb
    1cd0:	2e090316 	mcrcs	3, 0, r0, cr9, cr6, {0}
    1cd4:	05d61b05 	ldrbeq	r1, [r6, #2821]	; 0xb05
    1cd8:	26054a11 			; <UNDEFINED> instruction: 0x26054a11
    1cdc:	03040200 	movweq	r0, #16896	; 0x4200
    1ce0:	000b05ba 			; <UNDEFINED> instruction: 0x000b05ba
    1ce4:	9f020402 	svcls	0x00020402
    1ce8:	02000505 	andeq	r0, r0, #20971520	; 0x1400000
    1cec:	05810204 	streq	r0, [r1, #516]	; 0x204
    1cf0:	1505f50e 	strne	pc, [r5, #-1294]	; 0xfffffaf2
    1cf4:	660c054b 	strvs	r0, [ip], -fp, asr #10
    1cf8:	9f0505d7 	svcls	0x000505d7
    1cfc:	05840f05 	streq	r0, [r4, #3845]	; 0xf05
    1d00:	0c05d711 	stceq	7, cr13, [r5], {17}
    1d04:	001805d9 			; <UNDEFINED> instruction: 0x001805d9
    1d08:	4a010402 	bmi	42d18 <__bss_end+0x369d8>
    1d0c:	05680905 	strbeq	r0, [r8, #-2309]!	; 0xfffff6fb
    1d10:	12059f10 	andne	r9, r5, #16, 30	; 0x40
    1d14:	670e0566 	strvs	r0, [lr, -r6, ror #10]
    1d18:	059f1005 	ldreq	r1, [pc, #5]	; 1d25 <shift+0x1d25>
    1d1c:	0e056612 	mcreq	6, 0, r6, cr5, cr2, {0}
    1d20:	001d0567 	andseq	r0, sp, r7, ror #10
    1d24:	82010402 	andhi	r0, r1, #33554432	; 0x2000000
    1d28:	05671005 	strbeq	r1, [r7, #-5]!
    1d2c:	1c056612 	stcne	6, cr6, [r5], {18}
    1d30:	82220569 	eorhi	r0, r2, #440401920	; 0x1a400000
    1d34:	052e1005 	streq	r1, [lr, #-5]!
    1d38:	12056622 	andne	r6, r5, #35651584	; 0x2200000
    1d3c:	2f14054a 	svccs	0x0014054a
    1d40:	02000505 	andeq	r0, r0, #20971520	; 0x1400000
    1d44:	75030204 	strvc	r0, [r3, #-516]	; 0xfffffdfc
    1d48:	030105d6 	movweq	r0, #5590	; 0x15d6
    1d4c:	0a029e0e 	beq	a958c <__bss_end+0x9d24c>
    1d50:	79010100 	stmdbvc	r1, {r8}
    1d54:	03000000 	movweq	r0, #0
    1d58:	00004600 	andeq	r4, r0, r0, lsl #12
    1d5c:	fb010200 	blx	42566 <__bss_end+0x36226>
    1d60:	01000d0e 	tsteq	r0, lr, lsl #26
    1d64:	00010101 	andeq	r0, r1, r1, lsl #2
    1d68:	00010000 	andeq	r0, r1, r0
    1d6c:	2e2e0100 	sufcse	f0, f6, f0
    1d70:	2f2e2e2f 	svccs	0x002e2e2f
    1d74:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1d78:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1d7c:	2f2e2e2f 	svccs	0x002e2e2f
    1d80:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    1d84:	632f6363 			; <UNDEFINED> instruction: 0x632f6363
    1d88:	69666e6f 	stmdbvs	r6!, {r0, r1, r2, r3, r5, r6, r9, sl, fp, sp, lr}^
    1d8c:	72612f67 	rsbvc	r2, r1, #412	; 0x19c
    1d90:	6c00006d 	stcvs	0, cr0, [r0], {109}	; 0x6d
    1d94:	66316269 	ldrtvs	r6, [r1], -r9, ror #4
    1d98:	73636e75 	cmnvc	r3, #1872	; 0x750
    1d9c:	0100532e 	tsteq	r0, lr, lsr #6
    1da0:	00000000 	andeq	r0, r0, r0
    1da4:	b5fc0205 	ldrblt	r0, [ip, #517]!	; 0x205
    1da8:	cf030000 	svcgt	0x00030000
    1dac:	2f300108 	svccs	0x00300108
    1db0:	2f2f2f2f 	svccs	0x002f2f2f
    1db4:	01d00230 	bicseq	r0, r0, r0, lsr r2
    1db8:	2f312f14 	svccs	0x00312f14
    1dbc:	2f4c302f 	svccs	0x004c302f
    1dc0:	661f0332 			; <UNDEFINED> instruction: 0x661f0332
    1dc4:	2f2f2f2f 	svccs	0x002f2f2f
    1dc8:	022f2f2f 	eoreq	r2, pc, #47, 30	; 0xbc
    1dcc:	01010002 	tsteq	r1, r2
    1dd0:	00000085 	andeq	r0, r0, r5, lsl #1
    1dd4:	00460003 	subeq	r0, r6, r3
    1dd8:	01020000 	mrseq	r0, (UNDEF: 2)
    1ddc:	000d0efb 	strdeq	r0, [sp], -fp
    1de0:	01010101 	tsteq	r1, r1, lsl #2
    1de4:	01000000 	mrseq	r0, (UNDEF: 0)
    1de8:	2e010000 	cdpcs	0, 0, cr0, cr1, cr0, {0}
    1dec:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1df0:	2f2e2e2f 	svccs	0x002e2e2f
    1df4:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1df8:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1dfc:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
    1e00:	2f636367 	svccs	0x00636367
    1e04:	666e6f63 	strbtvs	r6, [lr], -r3, ror #30
    1e08:	612f6769 			; <UNDEFINED> instruction: 0x612f6769
    1e0c:	00006d72 	andeq	r6, r0, r2, ror sp
    1e10:	3162696c 	cmncc	r2, ip, ror #18
    1e14:	636e7566 	cmnvs	lr, #427819008	; 0x19800000
    1e18:	00532e73 	subseq	r2, r3, r3, ror lr
    1e1c:	00000001 	andeq	r0, r0, r1
    1e20:	08020500 	stmdaeq	r2, {r8, sl}
    1e24:	030000b8 	movweq	r0, #184	; 0xb8
    1e28:	2f010a90 	svccs	0x00010a90
    1e2c:	2f2f3030 	svccs	0x002f3030
    1e30:	2f2f302f 	svccs	0x002f302f
    1e34:	02302f2f 	eorseq	r2, r0, #47, 30	; 0xbc
    1e38:	301401d0 			; <UNDEFINED> instruction: 0x301401d0
    1e3c:	2f30302f 	svccs	0x0030302f
    1e40:	2f2f3031 	svccs	0x002f3031
    1e44:	302f4c30 	eorcc	r4, pc, r0, lsr ip	; <UNPREDICTABLE>
    1e48:	1f03322f 	svcne	0x0003322f
    1e4c:	2f2f2f82 	svccs	0x002f2f82
    1e50:	2f2f2f2f 	svccs	0x002f2f2f
    1e54:	01000202 	tsteq	r0, r2, lsl #4
    1e58:	00005c01 	andeq	r5, r0, r1, lsl #24
    1e5c:	46000300 	strmi	r0, [r0], -r0, lsl #6
    1e60:	02000000 	andeq	r0, r0, #0
    1e64:	0d0efb01 	vstreq	d15, [lr, #-4]
    1e68:	01010100 	mrseq	r0, (UNDEF: 17)
    1e6c:	00000001 	andeq	r0, r0, r1
    1e70:	01000001 	tsteq	r0, r1
    1e74:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1e78:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1e7c:	2f2e2e2f 	svccs	0x002e2e2f
    1e80:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1e84:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
    1e88:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    1e8c:	6e6f632f 	cdpvs	3, 6, cr6, cr15, cr15, {1}
    1e90:	2f676966 	svccs	0x00676966
    1e94:	006d7261 	rsbeq	r7, sp, r1, ror #4
    1e98:	62696c00 	rsbvs	r6, r9, #0, 24
    1e9c:	6e756631 	mrcvs	6, 3, r6, cr5, cr1, {1}
    1ea0:	532e7363 			; <UNDEFINED> instruction: 0x532e7363
    1ea4:	00000100 	andeq	r0, r0, r0, lsl #2
    1ea8:	02050000 	andeq	r0, r5, #0
    1eac:	0000ba48 	andeq	fp, r0, r8, asr #20
    1eb0:	010bb903 	tsteq	fp, r3, lsl #18
    1eb4:	01000202 	tsteq	r0, r2, lsl #4
    1eb8:	0000fb01 	andeq	pc, r0, r1, lsl #22
    1ebc:	47000300 	strmi	r0, [r0, -r0, lsl #6]
    1ec0:	02000000 	andeq	r0, r0, #0
    1ec4:	0d0efb01 	vstreq	d15, [lr, #-4]
    1ec8:	01010100 	mrseq	r0, (UNDEF: 17)
    1ecc:	00000001 	andeq	r0, r0, r1
    1ed0:	01000001 	tsteq	r0, r1
    1ed4:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1ed8:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1edc:	2f2e2e2f 	svccs	0x002e2e2f
    1ee0:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1ee4:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
    1ee8:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    1eec:	6e6f632f 	cdpvs	3, 6, cr6, cr15, cr15, {1}
    1ef0:	2f676966 	svccs	0x00676966
    1ef4:	006d7261 	rsbeq	r7, sp, r1, ror #4
    1ef8:	65656900 	strbvs	r6, [r5, #-2304]!	; 0xfffff700
    1efc:	34353765 	ldrtcc	r3, [r5], #-1893	; 0xfffff89b
    1f00:	2e66732d 	cdpcs	3, 6, cr7, cr6, cr13, {1}
    1f04:	00010053 	andeq	r0, r1, r3, asr r0
    1f08:	05000000 	streq	r0, [r0, #-0]
    1f0c:	00ba4c02 	adcseq	r4, sl, r2, lsl #24
    1f10:	013a0300 	teqeq	sl, r0, lsl #6
    1f14:	0903332f 	stmdbeq	r3, {r0, r1, r2, r3, r5, r8, r9, ip, sp}
    1f18:	2f2f302e 	svccs	0x002f302e
    1f1c:	2f322f2f 	svccs	0x00322f2f
    1f20:	2f2f2f30 	svccs	0x002f2f30
    1f24:	31303330 	teqcc	r0, r0, lsr r3
    1f28:	2f302f2f 	svccs	0x00302f2f
    1f2c:	32302f2f 	eorscc	r2, r0, #47, 30	; 0xbc
    1f30:	2f32322f 	svccs	0x0032322f
    1f34:	332f312f 			; <UNDEFINED> instruction: 0x332f312f
    1f38:	2f2f332f 	svccs	0x002f332f
    1f3c:	2f2f312f 	svccs	0x002f312f
    1f40:	2f352f31 	svccs	0x00352f31
    1f44:	322f2f30 	eorcc	r2, pc, #48, 30	; 0xc0
    1f48:	2f302f2f 	svccs	0x00302f2f
    1f4c:	2f2e1903 	svccs	0x002e1903
    1f50:	2f352f2f 	svccs	0x00352f2f
    1f54:	3330342f 	teqcc	r0, #788529152	; 0x2f000000
    1f58:	2f2f302f 	svccs	0x002f302f
    1f5c:	3030312f 	eorscc	r3, r0, pc, lsr #2
    1f60:	312f302f 			; <UNDEFINED> instruction: 0x312f302f
    1f64:	32302f30 	eorscc	r2, r0, #48, 30	; 0xc0
    1f68:	2f2f312f 	svccs	0x002f312f
    1f6c:	302f2f30 	eorcc	r2, pc, r0, lsr pc	; <UNPREDICTABLE>
    1f70:	2f322f2f 	svccs	0x00322f2f
    1f74:	2e09032f 	cdpcs	3, 0, cr0, cr9, cr15, {1}
    1f78:	2f2f2f30 	svccs	0x002f2f30
    1f7c:	2f2f2f30 	svccs	0x002f2f30
    1f80:	2f2e0d03 	svccs	0x002e0d03
    1f84:	30303033 	eorscc	r3, r0, r3, lsr r0
    1f88:	2f303131 	svccs	0x00303131
    1f8c:	302e0c03 	eorcc	r0, lr, r3, lsl #24
    1f90:	30332f30 	eorscc	r2, r3, r0, lsr pc
    1f94:	2f332f30 	svccs	0x00332f30
    1f98:	2f2f3031 	svccs	0x002f3031
    1f9c:	032f3031 			; <UNDEFINED> instruction: 0x032f3031
    1fa0:	322f2e19 	eorcc	r2, pc, #400	; 0x190
    1fa4:	2f2f302f 	svccs	0x002f302f
    1fa8:	2f302f2f 	svccs	0x00302f2f
    1fac:	2f2f2f30 	svccs	0x002f2f30
    1fb0:	022f302f 	eoreq	r3, pc, #47	; 0x2f
    1fb4:	01010002 	tsteq	r1, r2
    1fb8:	0000007a 	andeq	r0, r0, sl, ror r0
    1fbc:	00420003 	subeq	r0, r2, r3
    1fc0:	01020000 	mrseq	r0, (UNDEF: 2)
    1fc4:	000d0efb 	strdeq	r0, [sp], -fp
    1fc8:	01010101 	tsteq	r1, r1, lsl #2
    1fcc:	01000000 	mrseq	r0, (UNDEF: 0)
    1fd0:	2e010000 	cdpcs	0, 0, cr0, cr1, cr0, {0}
    1fd4:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1fd8:	2f2e2e2f 	svccs	0x002e2e2f
    1fdc:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1fe0:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1fe4:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
    1fe8:	2f636367 	svccs	0x00636367
    1fec:	666e6f63 	strbtvs	r6, [lr], -r3, ror #30
    1ff0:	612f6769 			; <UNDEFINED> instruction: 0x612f6769
    1ff4:	00006d72 	andeq	r6, r0, r2, ror sp
    1ff8:	62617062 	rsbvs	r7, r1, #98	; 0x62
    1ffc:	00532e69 	subseq	r2, r3, r9, ror #28
    2000:	00000001 	andeq	r0, r0, r1
    2004:	9c020500 	cfstr32ls	mvfx0, [r2], {-0}
    2008:	030000bc 	movweq	r0, #188	; 0xbc
    200c:	080101b9 	stmdaeq	r1, {r0, r3, r4, r5, r7, r8}
    2010:	2f2f4b5a 	svccs	0x002f4b5a
    2014:	6730302f 	ldrvs	r3, [r0, -pc, lsr #32]!
    2018:	2f2f2f32 	svccs	0x002f2f32
    201c:	2f673030 	svccs	0x00673030
    2020:	322f2f2f 	eorcc	r2, pc, #47, 30	; 0xbc
    2024:	6730302f 	ldrvs	r3, [r0, -pc, lsr #32]!
    2028:	2f322f2f 	svccs	0x00322f2f
    202c:	2f672f30 	svccs	0x00672f30
    2030:	0002022f 	andeq	r0, r2, pc, lsr #4
    2034:	00a40101 	adceq	r0, r4, r1, lsl #2
    2038:	00030000 	andeq	r0, r3, r0
    203c:	0000009e 	muleq	r0, lr, r0
    2040:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
    2044:	0101000d 	tsteq	r1, sp
    2048:	00000101 	andeq	r0, r0, r1, lsl #2
    204c:	00000100 	andeq	r0, r0, r0, lsl #2
    2050:	2f2e2e01 	svccs	0x002e2e01
    2054:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    2058:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    205c:	2f2e2e2f 	svccs	0x002e2e2f
    2060:	63672f2e 	cmnvs	r7, #46, 30	; 0xb8
    2064:	2e2e0063 	cdpcs	0, 2, cr0, cr14, cr3, {3}
    2068:	2f2e2e2f 	svccs	0x002e2e2f
    206c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    2070:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    2074:	2f2e2e2f 	svccs	0x002e2e2f
    2078:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    207c:	2e2f6363 	cdpcs	3, 2, cr6, cr15, cr3, {3}
    2080:	63672f2e 	cmnvs	r7, #46, 30	; 0xb8
    2084:	6f632f63 	svcvs	0x00632f63
    2088:	6769666e 	strbvs	r6, [r9, -lr, ror #12]!
    208c:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
    2090:	2f2e2e00 	svccs	0x002e2e00
    2094:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    2098:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    209c:	2f2e2e2f 	svccs	0x002e2e2f
    20a0:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; 1ff0 <shift+0x1ff0>
    20a4:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    20a8:	61000063 	tstvs	r0, r3, rrx
    20ac:	692d6d72 	pushvs	{r1, r4, r5, r6, r8, sl, fp, sp, lr}
    20b0:	682e6173 	stmdavs	lr!, {r0, r1, r4, r5, r6, r8, sp, lr}
    20b4:	00000100 	andeq	r0, r0, r0, lsl #2
    20b8:	2e6d7261 	cdpcs	2, 6, cr7, cr13, cr1, {3}
    20bc:	00020068 	andeq	r0, r2, r8, rrx
    20c0:	6c626700 	stclvs	7, cr6, [r2], #-0
    20c4:	6f74632d 	svcvs	0x0074632d
    20c8:	682e7372 	stmdavs	lr!, {r1, r4, r5, r6, r8, r9, ip, sp, lr}
    20cc:	00000300 	andeq	r0, r0, r0, lsl #6
    20d0:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    20d4:	2e326363 	cdpcs	3, 3, cr6, cr2, cr3, {3}
    20d8:	00030063 	andeq	r0, r3, r3, rrx
    20dc:	00a70000 	adceq	r0, r7, r0
    20e0:	00030000 	andeq	r0, r3, r0
    20e4:	00000068 	andeq	r0, r0, r8, rrx
    20e8:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
    20ec:	0101000d 	tsteq	r1, sp
    20f0:	00000101 	andeq	r0, r0, r1, lsl #2
    20f4:	00000100 	andeq	r0, r0, r0, lsl #2
    20f8:	2f2e2e01 	svccs	0x002e2e01
    20fc:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    2100:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    2104:	2f2e2e2f 	svccs	0x002e2e2f
    2108:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; 2058 <shift+0x2058>
    210c:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    2110:	2e2e0063 	cdpcs	0, 2, cr0, cr14, cr3, {3}
    2114:	2f2e2e2f 	svccs	0x002e2e2f
    2118:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    211c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    2120:	672f2e2f 	strvs	r2, [pc, -pc, lsr #28]!
    2124:	00006363 	andeq	r6, r0, r3, ror #6
    2128:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    212c:	2e326363 	cdpcs	3, 3, cr6, cr2, cr3, {3}
    2130:	00010063 	andeq	r0, r1, r3, rrx
    2134:	6d726100 	ldfvse	f6, [r2, #-0]
    2138:	6173692d 	cmnvs	r3, sp, lsr #18
    213c:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
    2140:	696c0000 	stmdbvs	ip!, {}^	; <UNPREDICTABLE>
    2144:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    2148:	00682e32 	rsbeq	r2, r8, r2, lsr lr
    214c:	00000001 	andeq	r0, r0, r1
    2150:	05000105 	streq	r0, [r0, #-261]	; 0xfffffefb
    2154:	00bd7002 	adcseq	r7, sp, r2
    2158:	0bf90300 	bleq	ffe42d60 <__bss_end+0xffe36a20>
    215c:	13030501 	movwne	r0, #13569	; 0x3501
    2160:	11060105 	tstne	r6, r5, lsl #2
    2164:	052f0605 	streq	r0, [pc, #-1541]!	; 1b67 <shift+0x1b67>
    2168:	05680603 	strbeq	r0, [r8, #-1539]!	; 0xfffff9fd
    216c:	0501060a 	streq	r0, [r1, #-1546]	; 0xfffff9f6
    2170:	052d0605 	streq	r0, [sp, #-1541]!	; 0xfffff9fb
    2174:	0501060e 	streq	r0, [r1, #-1550]	; 0xfffff9f2
    2178:	0e052c01 	cdpeq	12, 0, cr2, cr5, cr1, {0}
    217c:	0c052e30 	stceq	14, cr2, [r5], {48}	; 0x30
    2180:	4c01052e 	cfstr32mi	mvfx0, [r1], {46}	; 0x2e
    2184:	01000202 	tsteq	r0, r2, lsl #4
    2188:	0000b601 	andeq	fp, r0, r1, lsl #12
    218c:	68000300 	stmdavs	r0, {r8, r9}
    2190:	02000000 	andeq	r0, r0, #0
    2194:	0d0efb01 	vstreq	d15, [lr, #-4]
    2198:	01010100 	mrseq	r0, (UNDEF: 17)
    219c:	00000001 	andeq	r0, r0, r1
    21a0:	01000001 	tsteq	r0, r1
    21a4:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    21a8:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    21ac:	2f2e2e2f 	svccs	0x002e2e2f
    21b0:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    21b4:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
    21b8:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    21bc:	2f2e2e00 	svccs	0x002e2e00
    21c0:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    21c4:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    21c8:	2f2e2e2f 	svccs	0x002e2e2f
    21cc:	63672f2e 	cmnvs	r7, #46, 30	; 0xb8
    21d0:	6c000063 	stcvs	0, cr0, [r0], {99}	; 0x63
    21d4:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    21d8:	632e3263 			; <UNDEFINED> instruction: 0x632e3263
    21dc:	00000100 	andeq	r0, r0, r0, lsl #2
    21e0:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
    21e4:	2e617369 	cdpcs	3, 6, cr7, cr1, cr9, {3}
    21e8:	00020068 	andeq	r0, r2, r8, rrx
    21ec:	62696c00 	rsbvs	r6, r9, #0, 24
    21f0:	32636367 	rsbcc	r6, r3, #-1677721599	; 0x9c000001
    21f4:	0100682e 	tsteq	r0, lr, lsr #16
    21f8:	05000000 	streq	r0, [r0, #-0]
    21fc:	02050001 	andeq	r0, r5, #1
    2200:	0000bda0 	andeq	fp, r0, r0, lsr #27
    2204:	010bb903 	tsteq	fp, r3, lsl #18
    2208:	05170305 	ldreq	r0, [r7, #-773]	; 0xfffffcfb
    220c:	05010610 	streq	r0, [r1, #-1552]	; 0xfffff9f0
    2210:	27053319 	smladcs	r5, r9, r3, r3
    2214:	03100533 	tsteq	r0, #213909504	; 0xcc00000
    2218:	03052e76 	movweq	r2, #24182	; 0x5e76
    221c:	19053306 	stmdbne	r5, {r1, r2, r8, r9, ip, sp}
    2220:	10050106 	andne	r0, r5, r6, lsl #2
    2224:	0603052e 	streq	r0, [r3], -lr, lsr #10
    2228:	1b051533 	blne	1476fc <__bss_end+0x13b3bc>
    222c:	01050f06 	tsteq	r5, r6, lsl #30
    2230:	052e2b03 	streq	r2, [lr, #-2819]!	; 0xfffff4fd
    2234:	2e550319 	mrccs	3, 2, r0, cr5, cr9, {0}
    2238:	2b030105 	blcs	c2654 <__bss_end+0xb6314>
    223c:	0a024a2e 	beq	94afc <__bss_end+0x887bc>
    2240:	69010100 	stmdbvs	r1, {r8}
    2244:	03000001 	movweq	r0, #1
    2248:	00006800 	andeq	r6, r0, r0, lsl #16
    224c:	fb010200 	blx	42a56 <__bss_end+0x36716>
    2250:	01000d0e 	tsteq	r0, lr, lsl #26
    2254:	00010101 	andeq	r0, r1, r1, lsl #2
    2258:	00010000 	andeq	r0, r1, r0
    225c:	2e2e0100 	sufcse	f0, f6, f0
    2260:	2f2e2e2f 	svccs	0x002e2e2f
    2264:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    2268:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    226c:	2f2e2e2f 	svccs	0x002e2e2f
    2270:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    2274:	2e006363 	cdpcs	3, 0, cr6, cr0, cr3, {3}
    2278:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    227c:	2f2e2e2f 	svccs	0x002e2e2f
    2280:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    2284:	2f2e2f2e 	svccs	0x002e2f2e
    2288:	00636367 	rsbeq	r6, r3, r7, ror #6
    228c:	62696c00 	rsbvs	r6, r9, #0, 24
    2290:	32636367 	rsbcc	r6, r3, #-1677721599	; 0x9c000001
    2294:	0100632e 	tsteq	r0, lr, lsr #6
    2298:	72610000 	rsbvc	r0, r1, #0
    229c:	73692d6d 	cmnvc	r9, #6976	; 0x1b40
    22a0:	00682e61 	rsbeq	r2, r8, r1, ror #28
    22a4:	6c000002 	stcvs	0, cr0, [r0], {2}
    22a8:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    22ac:	682e3263 	stmdavs	lr!, {r0, r1, r5, r6, r9, ip, sp}
    22b0:	00000100 	andeq	r0, r0, r0, lsl #2
    22b4:	00010500 	andeq	r0, r1, r0, lsl #10
    22b8:	bde00205 	sfmlt	f0, 2, [r0, #20]!
    22bc:	b3030000 	movwlt	r0, #12288	; 0x3000
    22c0:	03050107 	movweq	r0, #20743	; 0x5107
    22c4:	0a031313 	beq	c6f18 <__bss_end+0xbabd8>
    22c8:	06060501 	streq	r0, [r6], -r1, lsl #10
    22cc:	03010501 	movweq	r0, #5377	; 0x1501
    22d0:	0b054a74 	bleq	154ca8 <__bss_end+0x148968>
    22d4:	2d01052f 	cfstr32cs	mvfx0, [r1, #-188]	; 0xffffff44
    22d8:	052f0b05 	streq	r0, [pc, #-2821]!	; 17db <shift+0x17db>
    22dc:	2e0b0306 	cdpcs	3, 0, cr0, cr11, cr6, {0}
    22e0:	30060705 	andcc	r0, r6, r5, lsl #14
    22e4:	01060d05 	tsteq	r6, r5, lsl #26
    22e8:	83060705 	movwhi	r0, #26373	; 0x6705
    22ec:	01060d05 	tsteq	r6, r5, lsl #26
    22f0:	0607054a 	streq	r0, [r7], -sl, asr #10
    22f4:	0609054c 	streq	r0, [r9], -ip, asr #10
    22f8:	06070501 	streq	r0, [r7], -r1, lsl #10
    22fc:	0609052f 	streq	r0, [r9], -pc, lsr #10
    2300:	07052e01 	streq	r2, [r5, -r1, lsl #28]
    2304:	0a05a506 	beq	16b724 <__bss_end+0x15f3e4>
    2308:	052e0106 	streq	r0, [lr, #-262]!	; 0xfffffefa
    230c:	2e68030b 	cdpcs	3, 6, cr0, cr8, cr11, {0}
    2310:	18030a05 	stmdane	r3, {r0, r2, r9, fp}
    2314:	0604054a 	streq	r0, [r4], -sl, asr #10
    2318:	06060530 			; <UNDEFINED> instruction: 0x06060530
    231c:	492f4913 	stmdbmi	pc!, {r0, r1, r4, r8, fp, lr}	; <UNPREDICTABLE>
    2320:	2f060405 	svccs	0x00060405
    2324:	05150705 	ldreq	r0, [r5, #-1797]	; 0xfffff8fb
    2328:	0501060a 	streq	r0, [r1, #-1546]	; 0xfffff9f6
    232c:	054c0604 	strbeq	r0, [ip, #-1540]	; 0xfffff9fc
    2330:	2e010606 	cfmadd32cs	mvax0, mvfx0, mvfx1, mvfx6
    2334:	4e060405 	cdpmi	4, 0, cr0, cr6, cr5, {0}
    2338:	0e060605 	cfmadd32eq	mvax0, mvfx0, mvfx6, mvfx5
    233c:	05520b05 	ldrbeq	r0, [r2, #-2821]	; 0xfffff4fb
    2340:	05054a10 	streq	r4, [r5, #-2576]	; 0xfffff5f0
    2344:	08052e4a 	stmdaeq	r5, {r1, r3, r6, r9, sl, fp, sp}
    2348:	0e053106 	adfeqs	f3, f5, f6
    234c:	06060513 			; <UNDEFINED> instruction: 0x06060513
    2350:	04052e01 	streq	r2, [r5], #-3585	; 0xfffff1ff
    2354:	2e790306 	cdpcs	3, 7, cr0, cr9, cr6, {0}
    2358:	05140805 	ldreq	r0, [r4, #-2053]	; 0xfffff7fb
    235c:	05141303 	ldreq	r1, [r4, #-771]	; 0xfffffcfd
    2360:	050f060b 	streq	r0, [pc, #-1547]	; 1d5d <shift+0x1d5d>
    2364:	052e6905 	streq	r6, [lr, #-2309]!	; 0xfffff6fb
    2368:	052f0608 	streq	r0, [pc, #-1544]!	; 1d68 <shift+0x1d68>
    236c:	0605130e 	streq	r1, [r5], -lr, lsl #6
    2370:	052e0106 	streq	r0, [lr, #-262]!	; 0xfffffefa
    2374:	05320604 	ldreq	r0, [r2, #-1540]!	; 0xfffff9fc
    2378:	2f010606 	svccs	0x00010606
    237c:	06040549 	streq	r0, [r4], -r9, asr #10
    2380:	0606052f 	streq	r0, [r6], -pc, lsr #10
    2384:	06040501 	streq	r0, [r4], -r1, lsl #10
    2388:	060f054b 	streq	r0, [pc], -fp, asr #10
    238c:	06054a01 	streq	r4, [r5], -r1, lsl #20
    2390:	03052e4a 	movweq	r2, #24138	; 0x5e4a
    2394:	06053206 	streq	r3, [r5], -r6, lsl #4
    2398:	05050106 	streq	r0, [r5, #-262]	; 0xfffffefa
    239c:	09052f06 	stmdbeq	r5, {r1, r2, r8, r9, sl, fp, sp}
    23a0:	03050106 	movweq	r0, #20742	; 0x5106
    23a4:	01052f06 	tsteq	r5, r6, lsl #30
    23a8:	022e1306 	eoreq	r1, lr, #402653184	; 0x18000000
    23ac:	01010004 	tsteq	r1, r4
    23b0:	000001db 	ldrdeq	r0, [r0], -fp
    23b4:	00c20003 	sbceq	r0, r2, r3
    23b8:	01020000 	mrseq	r0, (UNDEF: 2)
    23bc:	000d0efb 	strdeq	r0, [sp], -fp
    23c0:	01010101 	tsteq	r1, r1, lsl #2
    23c4:	01000000 	mrseq	r0, (UNDEF: 0)
    23c8:	2e010000 	cdpcs	0, 0, cr0, cr1, cr0, {0}
    23cc:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    23d0:	2f2e2e2f 	svccs	0x002e2e2f
    23d4:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    23d8:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    23dc:	2f2e2e2f 	svccs	0x002e2e2f
    23e0:	6e2f2e2e 	cdpvs	14, 2, cr2, cr15, cr14, {1}
    23e4:	696c7765 	stmdbvs	ip!, {r0, r2, r5, r6, r8, r9, sl, ip, sp, lr}^
    23e8:	696c2f62 	stmdbvs	ip!, {r1, r5, r6, r8, r9, sl, fp, sp}^
    23ec:	732f6362 			; <UNDEFINED> instruction: 0x732f6362
    23f0:	6e697274 	mcrvs	2, 3, r7, cr9, cr4, {3}
    23f4:	752f0067 	strvc	r0, [pc, #-103]!	; 2395 <shift+0x2395>
    23f8:	6c2f7273 	sfmvs	f7, 4, [pc], #-460	; 2234 <shift+0x2234>
    23fc:	672f6269 	strvs	r6, [pc, -r9, ror #4]!
    2400:	612f6363 			; <UNDEFINED> instruction: 0x612f6363
    2404:	6e2d6d72 	mcrvs	13, 1, r6, cr13, cr2, {3}
    2408:	2d656e6f 	stclcs	14, cr6, [r5, #-444]!	; 0xfffffe44
    240c:	69626165 	stmdbvs	r2!, {r0, r2, r5, r6, r8, sp, lr}^
    2410:	2e30312f 	rsfcssp	f3, f0, #10.0
    2414:	2f312e33 	svccs	0x00312e33
    2418:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
    241c:	00656475 	rsbeq	r6, r5, r5, ror r4
    2420:	6975622f 	ldmdbvs	r5!, {r0, r1, r2, r3, r5, r9, sp, lr}^
    2424:	6e2f646c 	cdpvs	4, 2, cr6, cr15, cr12, {3}
    2428:	696c7765 	stmdbvs	ip!, {r0, r2, r5, r6, r8, r9, sl, ip, sp, lr}^
    242c:	42702d62 	rsbsmi	r2, r0, #6272	; 0x1880
    2430:	65643033 	strbvs	r3, [r4, #-51]!	; 0xffffffcd
    2434:	77656e2f 	strbvc	r6, [r5, -pc, lsr #28]!
    2438:	2d62696c 			; <UNDEFINED> instruction: 0x2d62696c
    243c:	2e332e33 	mrccs	14, 1, r2, cr3, cr3, {1}
    2440:	656e2f30 	strbvs	r2, [lr, #-3888]!	; 0xfffff0d0
    2444:	62696c77 	rsbvs	r6, r9, #30464	; 0x7700
    2448:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
    244c:	6e692f63 	cdpvs	15, 6, cr2, cr9, cr3, {3}
    2450:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
    2454:	6d000065 	stcvs	0, cr0, [r0, #-404]	; 0xfffffe6c
    2458:	65736d65 	ldrbvs	r6, [r3, #-3429]!	; 0xfffff29b
    245c:	00632e74 	rsbeq	r2, r3, r4, ror lr
    2460:	73000001 	movwvc	r0, #1
    2464:	65646474 	strbvs	r6, [r4, #-1140]!	; 0xfffffb8c
    2468:	00682e66 	rsbeq	r2, r8, r6, ror #28
    246c:	73000002 	movwvc	r0, #2
    2470:	6e697274 	mcrvs	2, 3, r7, cr9, cr4, {3}
    2474:	00682e67 	rsbeq	r2, r8, r7, ror #28
    2478:	00000003 	andeq	r0, r0, r3
    247c:	05000105 	streq	r0, [r0, #-261]	; 0xfffffefb
    2480:	00bf0002 	adcseq	r0, pc, r2
    2484:	01280300 			; <UNDEFINED> instruction: 0x01280300
    2488:	15130305 	ldrne	r0, [r3, #-773]	; 0xfffffcfb
    248c:	05131313 	ldreq	r1, [r3, #-787]	; 0xfffffced
    2490:	05150609 	ldreq	r0, [r5, #-1545]	; 0xfffff9f7
    2494:	052e0603 	streq	r0, [lr, #-1539]!	; 0xfffff9fd
    2498:	07050109 	streq	r0, [r5, -r9, lsl #2]
    249c:	060a0530 			; <UNDEFINED> instruction: 0x060a0530
    24a0:	2e0c0501 	cfsh32cs	mvfx0, mvfx12, #1
    24a4:	052e0a05 	streq	r0, [lr, #-2565]!	; 0xfffff5fb
    24a8:	09052f10 	stmdbeq	r5, {r4, r8, r9, sl, fp, sp}
    24ac:	052e7403 	streq	r7, [lr, #-1027]!	; 0xfffffbfd
    24b0:	4a0b030c 	bmi	2c30e8 <__bss_end+0x2b6da8>
    24b4:	052e0a05 	streq	r0, [lr, #-2565]!	; 0xfffff5fb
    24b8:	054a0607 	strbeq	r0, [sl, #-1543]	; 0xfffff9f9
    24bc:	0e051309 	cdpeq	3, 0, cr1, cr5, cr9, {0}
    24c0:	09050106 	stmdbeq	r5, {r1, r2, r8}
    24c4:	03052b06 	movweq	r2, #23302	; 0x5b06
    24c8:	06060552 			; <UNDEFINED> instruction: 0x06060552
    24cc:	03010501 	movweq	r0, #5377	; 0x1501
    24d0:	10054a6e 	andne	r4, r5, lr, ror #20
    24d4:	06070535 			; <UNDEFINED> instruction: 0x06070535
    24d8:	162e0e03 	strtne	r0, [lr], -r3, lsl #28
    24dc:	01060e05 	tsteq	r6, r5, lsl #28
    24e0:	2f060705 	svccs	0x00060705
    24e4:	17060d05 	strne	r0, [r6, -r5, lsl #26]
    24e8:	05290e05 	streq	r0, [r9, #-3589]!	; 0xfffff1fb
    24ec:	052f0607 	streq	r0, [pc, #-1543]!	; 1eed <shift+0x1eed>
    24f0:	0d050114 	stfeqs	f0, [r5, #-80]	; 0xffffffb0
    24f4:	052e0616 	streq	r0, [lr, #-1558]!	; 0xfffff9ea
    24f8:	05bc060b 	ldreq	r0, [ip, #1547]!	; 0x60b
    24fc:	0501061b 	streq	r0, [r1, #-1563]	; 0xfffff9e5
    2500:	052f060b 	streq	r0, [pc, #-1547]!	; 1efd <shift+0x1efd>
    2504:	0501061b 	streq	r0, [r1, #-1563]	; 0xfffff9e5
    2508:	052f060b 	streq	r0, [pc, #-1547]!	; 1f05 <shift+0x1f05>
    250c:	0501061b 	streq	r0, [r1, #-1563]	; 0xfffff9e5
    2510:	052f060b 	streq	r0, [pc, #-1547]!	; 1f0d <shift+0x1f0d>
    2514:	0501061b 	streq	r0, [r1, #-1563]	; 0xfffff9e5
    2518:	052f060b 	streq	r0, [pc, #-1547]!	; 1f15 <shift+0x1f15>
    251c:	017a030d 	cmneq	sl, sp, lsl #6
    2520:	18052e06 	stmdane	r5, {r1, r2, r9, sl, fp, sp}
    2524:	320d054f 	andcc	r0, sp, #331350016	; 0x13c00000
    2528:	052a1805 	streq	r1, [sl, #-2053]!	; 0xfffff7fb
    252c:	31062f0d 	tstcc	r6, sp, lsl #30
    2530:	052e2e06 	streq	r2, [lr, #-3590]!	; 0xfffff1fa
    2534:	0568060b 	strbeq	r0, [r8, #-1547]!	; 0xfffff9f5
    2538:	0501061b 	streq	r0, [r1, #-1563]	; 0xfffff9e5
    253c:	052f060b 	streq	r0, [pc, #-1547]!	; 1f39 <shift+0x1f39>
    2540:	4d060f0d 	stcmi	15, cr0, [r6, #-52]	; 0xffffffcc
    2544:	36060905 	strcc	r0, [r6], -r5, lsl #18
    2548:	10050106 	andne	r0, r5, r6, lsl #2
    254c:	2e4a5a03 	vmlacs.f32	s11, s20, s6
    2550:	03060505 	movweq	r0, #25861	; 0x6505
    2554:	0a052e27 	beq	14ddf8 <__bss_end+0x141ab8>
    2558:	09050106 	stmdbeq	r5, {r1, r2, r8}
    255c:	01062d06 	tsteq	r6, r6, lsl #26
    2560:	01066606 	tsteq	r6, r6, lsl #12
    2564:	5a031005 	bpl	c6580 <__bss_end+0xba240>
    2568:	05052e4a 	streq	r2, [r5, #-3658]	; 0xfffff1b6
    256c:	2e270306 	cdpcs	3, 2, cr0, cr7, cr6, {0}
    2570:	01060a05 	tsteq	r6, r5, lsl #20
    2574:	2d060905 	vstrcs.16	s0, [r6, #-10]	; <UNPREDICTABLE>
    2578:	18050106 	stmdane	r5, {r1, r2, r8}
    257c:	2e667103 	powcss	f7, f6, f3
    2580:	5d030905 	vstrpl.16	s0, [r3, #-10]	; <UNPREDICTABLE>
    2584:	030d052e 	movweq	r0, #54574	; 0xd52e
    2588:	04024a1e 	streq	r4, [r2], #-2590	; 0xfffff5e2
    258c:	Address 0x000000000000258c is out of bounds.


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
      34:	fb0c0000 	blx	30003e <__bss_end+0x2f3cfe>
      38:	2a000000 	bcs	40 <shift+0x40>
      3c:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
      40:	9c000080 	stcls	0, cr0, [r0], {128}	; 0x80
      44:	5a000000 	bpl	4c <shift+0x4c>
      48:	02000000 	andeq	r0, r0, #0
      4c:	0000012c 	andeq	r0, r0, ip, lsr #2
      50:	31150601 	tstcc	r5, r1, lsl #12
      54:	03000000 	movweq	r0, #0
      58:	1fe30704 	svcne	0x00e30704
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
     128:	00001fe3 	andeq	r1, r0, r3, ror #31
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
     174:	cb104801 	blgt	412180 <__bss_end+0x405e40>
     178:	d4000000 	strle	r0, [r0], #-0
     17c:	58000081 	stmdapl	r0, {r0, r7}
     180:	01000000 	mrseq	r0, (UNDEF: 0)
     184:	0000cb9c 	muleq	r0, ip, fp
     188:	01800a00 	orreq	r0, r0, r0, lsl #20
     18c:	4a010000 	bmi	40194 <__bss_end+0x33e54>
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
     1d4:	5b0c0000 	blpl	3001dc <__bss_end+0x2f3e9c>
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
     24c:	8b120f01 	blhi	483e58 <__bss_end+0x477b18>
     250:	0f000001 	svceq	0x00000001
     254:	0000019e 	muleq	r0, lr, r1
     258:	03231000 			; <UNDEFINED> instruction: 0x03231000
     25c:	0a010000 	beq	40264 <__bss_end+0x33f24>
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
     2b4:	8b140074 	blhi	50048c <__bss_end+0x4f414c>
     2b8:	a4000001 	strge	r0, [r0], #-1
     2bc:	38000080 	stmdacc	r0, {r7}
     2c0:	01000000 	mrseq	r0, (UNDEF: 0)
     2c4:	0067139c 	mlseq	r7, ip, r3, r1
     2c8:	9e2f0a01 	vmulls.f32	s0, s30, s2
     2cc:	02000001 	andeq	r0, r0, #1
     2d0:	00007491 	muleq	r0, r1, r4
     2d4:	00000a32 	andeq	r0, r0, r2, lsr sl
     2d8:	01e00004 	mvneq	r0, r4
     2dc:	01040000 	mrseq	r0, (UNDEF: 4)
     2e0:	0000025e 	andeq	r0, r0, lr, asr r2
     2e4:	000bc704 	andeq	ip, fp, r4, lsl #14
     2e8:	00002a00 	andeq	r2, r0, r0, lsl #20
	...
     2f4:	0001c200 	andeq	ip, r1, r0, lsl #4
     2f8:	08010200 	stmdaeq	r1, {r9}
     2fc:	000008a8 	andeq	r0, r0, r8, lsr #17
     300:	00002503 	andeq	r2, r0, r3, lsl #10
     304:	05020200 	streq	r0, [r2, #-512]	; 0xfffffe00
     308:	00000921 	andeq	r0, r0, r1, lsr #18
     30c:	69050404 	stmdbvs	r5, {r2, sl}
     310:	0300746e 	movweq	r7, #1134	; 0x46e
     314:	00000038 	andeq	r0, r0, r8, lsr r0
     318:	9f080102 	svcls	0x00080102
     31c:	02000008 	andeq	r0, r0, #8
     320:	06980702 	ldreq	r0, [r8], r2, lsl #14
     324:	c7050000 	strgt	r0, [r5, -r0]
     328:	0b000009 	bleq	354 <shift+0x354>
     32c:	00630709 	rsbeq	r0, r3, r9, lsl #14
     330:	52030000 	andpl	r0, r3, #0
     334:	02000000 	andeq	r0, r0, #0
     338:	1fe30704 	svcne	0x00e30704
     33c:	83060000 	movwhi	r0, #24576	; 0x6000
     340:	03000007 	movweq	r0, #7
     344:	005e1405 	subseq	r1, lr, r5, lsl #8
     348:	03050000 	movweq	r0, #20480	; 0x5000
     34c:	0000c018 	andeq	ip, r0, r8, lsl r0
     350:	00081006 	andeq	r1, r8, r6
     354:	14060300 	strne	r0, [r6], #-768	; 0xfffffd00
     358:	0000005e 	andeq	r0, r0, lr, asr r0
     35c:	c01c0305 	andsgt	r0, ip, r5, lsl #6
     360:	4c060000 	stcmi	0, cr0, [r6], {-0}
     364:	04000007 	streq	r0, [r0], #-7
     368:	005e1a07 	subseq	r1, lr, r7, lsl #20
     36c:	03050000 	movweq	r0, #20480	; 0x5000
     370:	0000c020 	andeq	ip, r0, r0, lsr #32
     374:	0004cf06 	andeq	ip, r4, r6, lsl #30
     378:	1a090400 	bne	241380 <__bss_end+0x235040>
     37c:	0000005e 	andeq	r0, r0, lr, asr r0
     380:	c0240305 	eorgt	r0, r4, r5, lsl #6
     384:	74060000 	strvc	r0, [r6], #-0
     388:	04000008 	streq	r0, [r0], #-8
     38c:	005e1a0b 	subseq	r1, lr, fp, lsl #20
     390:	03050000 	movweq	r0, #20480	; 0x5000
     394:	0000c028 	andeq	ip, r0, r8, lsr #32
     398:	00068506 	andeq	r8, r6, r6, lsl #10
     39c:	1a0d0400 	bne	3413a4 <__bss_end+0x335064>
     3a0:	0000005e 	andeq	r0, r0, lr, asr r0
     3a4:	c02c0305 	eorgt	r0, ip, r5, lsl #6
     3a8:	52060000 	andpl	r0, r6, #0
     3ac:	04000005 	streq	r0, [r0], #-5
     3b0:	005e1a0f 	subseq	r1, lr, pc, lsl #20
     3b4:	03050000 	movweq	r0, #20480	; 0x5000
     3b8:	0000c030 	andeq	ip, r0, r0, lsr r0
     3bc:	0019b207 	andseq	fp, r9, r7, lsl #4
     3c0:	38040500 	stmdacc	r4, {r8, sl}
     3c4:	04000000 	streq	r0, [r0], #-0
     3c8:	010d0c1b 	tsteq	sp, fp, lsl ip
     3cc:	10080000 	andne	r0, r8, r0
     3d0:	0000000a 	andeq	r0, r0, sl
     3d4:	000c0608 	andeq	r0, ip, r8, lsl #12
     3d8:	34080100 	strcc	r0, [r8], #-256	; 0xffffff00
     3dc:	02000008 	andeq	r0, r0, #8
     3e0:	02010200 	andeq	r0, r1, #0, 4
     3e4:	000006e4 	andeq	r0, r0, r4, ror #13
     3e8:	002c0409 	eoreq	r0, ip, r9, lsl #8
     3ec:	ce060000 	cdpgt	0, 0, cr0, cr6, cr0, {0}
     3f0:	05000005 	streq	r0, [r0, #-5]
     3f4:	005e1404 	subseq	r1, lr, r4, lsl #8
     3f8:	03050000 	movweq	r0, #20480	; 0x5000
     3fc:	0000c034 	andeq	ip, r0, r4, lsr r0
     400:	00033706 	andeq	r3, r3, r6, lsl #14
     404:	14070500 	strne	r0, [r7], #-1280	; 0xfffffb00
     408:	0000005e 	andeq	r0, r0, lr, asr r0
     40c:	c0380305 	eorsgt	r0, r8, r5, lsl #6
     410:	24060000 	strcs	r0, [r6], #-0
     414:	05000005 	streq	r0, [r0, #-5]
     418:	005e140a 	subseq	r1, lr, sl, lsl #8
     41c:	03050000 	movweq	r0, #20480	; 0x5000
     420:	0000c03c 	andeq	ip, r0, ip, lsr r0
     424:	de070402 	cdple	4, 0, cr0, cr7, cr2, {0}
     428:	0600001f 			; <UNDEFINED> instruction: 0x0600001f
     42c:	00000b33 	andeq	r0, r0, r3, lsr fp
     430:	5e140a06 	vnmlspl.f32	s0, s8, s12
     434:	05000000 	streq	r0, [r0, #-0]
     438:	00c04003 	sbceq	r4, r0, r3
     43c:	0b040a00 	bleq	102c44 <__bss_end+0xf6904>
     440:	000005c1 	andeq	r0, r0, r1, asr #11
     444:	0703070c 	streq	r0, [r3, -ip, lsl #14]
     448:	00000219 	andeq	r0, r0, r9, lsl r2
     44c:	000b610c 	andeq	r6, fp, ip, lsl #2
     450:	0e060700 	cdpeq	7, 0, cr0, cr6, cr0, {0}
     454:	00000052 	andeq	r0, r0, r2, asr r0
     458:	09bd0c00 	ldmibeq	sp!, {sl, fp}
     45c:	08070000 	stmdaeq	r7, {}	; <UNPREDICTABLE>
     460:	0000520e 	andeq	r5, r0, lr, lsl #4
     464:	3f0c0400 	svccc	0x000c0400
     468:	07000008 	streq	r0, [r0, -r8]
     46c:	00520e0b 	subseq	r0, r2, fp, lsl #28
     470:	0d080000 	stceq	0, cr0, [r8, #-0]
     474:	000005c1 	andeq	r0, r0, r1, asr #11
     478:	67050d07 	strvs	r0, [r5, -r7, lsl #26]
     47c:	19000009 	stmdbne	r0, {r0, r3}
     480:	01000002 	tsteq	r0, r2
     484:	000001b8 			; <UNDEFINED> instruction: 0x000001b8
     488:	000001be 			; <UNDEFINED> instruction: 0x000001be
     48c:	0002190e 	andeq	r1, r2, lr, lsl #18
     490:	930f0000 	movwls	r0, #61440	; 0xf000
     494:	0700000a 	streq	r0, [r0, -sl]
     498:	06e90a0e 	strbteq	r0, [r9], lr, lsl #20
     49c:	d3010000 	movwle	r0, #4096	; 0x1000
     4a0:	d9000001 	stmdble	r0, {r0}
     4a4:	0e000001 	cdpeq	0, 0, cr0, cr0, cr1, {0}
     4a8:	00000219 	andeq	r0, r0, r9, lsl r2
     4ac:	09580d00 	ldmdbeq	r8, {r8, sl, fp}^
     4b0:	0f070000 	svceq	0x00070000
     4b4:	00055c0b 	andeq	r5, r5, fp, lsl #24
     4b8:	00016900 	andeq	r6, r1, r0, lsl #18
     4bc:	01f20100 	mvnseq	r0, r0, lsl #2
     4c0:	01fd0000 	mvnseq	r0, r0
     4c4:	190e0000 	stmdbne	lr, {}	; <UNPREDICTABLE>
     4c8:	10000002 	andne	r0, r0, r2
     4cc:	00000052 	andeq	r0, r0, r2, asr r0
     4d0:	0a831100 	beq	fe0c48d8 <__bss_end+0xfe0b8598>
     4d4:	10070000 	andne	r0, r7, r0
     4d8:	0008ed0e 	andeq	lr, r8, lr, lsl #26
     4dc:	00005200 	andeq	r5, r0, r0, lsl #4
     4e0:	02120100 	andseq	r0, r2, #0, 2
     4e4:	190e0000 	stmdbne	lr, {}	; <UNPREDICTABLE>
     4e8:	00000002 	andeq	r0, r0, r2
     4ec:	6b040900 	blvs	1028f4 <__bss_end+0xf65b4>
     4f0:	12000001 	andne	r0, r0, #1
     4f4:	12070068 	andne	r0, r7, #104	; 0x68
     4f8:	00016b15 	andeq	r6, r1, r5, lsl fp
     4fc:	0b851300 	bleq	fe145104 <__bss_end+0xfe138dc4>
     500:	010c0000 	mrseq	r0, (UNDEF: 12)
     504:	9e070708 	cdpls	7, 0, cr0, cr7, cr8, {0}
     508:	14000003 	strne	r0, [r0], #-3
     50c:	00000b13 	andeq	r0, r0, r3, lsl fp
     510:	5e1b0908 	vnmlspl.f16	s0, s22, s16	; <UNPREDICTABLE>
     514:	80000000 	andhi	r0, r0, r0
     518:	0003660c 	andeq	r6, r3, ip, lsl #12
     51c:	0e0b0800 	cdpeq	8, 0, cr0, cr11, cr0, {0}
     520:	00000052 	andeq	r0, r0, r2, asr r0
     524:	04820c00 	streq	r0, [r2], #3072	; 0xc00
     528:	0c080000 	stceq	0, cr0, [r8], {-0}
     52c:	0000520e 	andeq	r5, r0, lr, lsl #4
     530:	6d0c0400 	cfstrsvs	mvf0, [ip, #-0]
     534:	0800000d 	stmdaeq	r0, {r0, r2, r3}
     538:	039e0a0f 	orrseq	r0, lr, #61440	; 0xf000
     53c:	0c080000 	stceq	0, cr0, [r8], {-0}
     540:	00000930 	andeq	r0, r0, r0, lsr r9
     544:	520e1008 	andpl	r1, lr, #8
     548:	88000000 	stmdahi	r0, {}	; <UNPREDICTABLE>
     54c:	000b420c 	andeq	r4, fp, ip, lsl #4
     550:	0a120800 	beq	482558 <__bss_end+0x476218>
     554:	0000039e 	muleq	r0, lr, r3
     558:	095e158c 	ldmdbeq	lr, {r2, r3, r7, r8, sl, ip}^
     55c:	13080000 	movwne	r0, #32768	; 0x8000
     560:	0004b90a 	andeq	fp, r4, sl, lsl #18
     564:	00029900 	andeq	r9, r2, r0, lsl #18
     568:	0002a400 	andeq	sl, r2, r0, lsl #8
     56c:	03ae0e00 			; <UNDEFINED> instruction: 0x03ae0e00
     570:	25100000 	ldrcs	r0, [r0, #-0]
     574:	00000000 	andeq	r0, r0, r0
     578:	00084e15 	andeq	r4, r8, r5, lsl lr
     57c:	0a140800 	beq	502584 <__bss_end+0x4f6244>
     580:	00000599 	muleq	r0, r9, r5
     584:	000002b8 			; <UNDEFINED> instruction: 0x000002b8
     588:	000002c3 	andeq	r0, r0, r3, asr #5
     58c:	0003ae0e 	andeq	sl, r3, lr, lsl #28
     590:	00521000 	subseq	r1, r2, r0
     594:	16000000 	strne	r0, [r0], -r0
     598:	00000c2f 	andeq	r0, r0, pc, lsr #24
     59c:	a00a1508 	andge	r1, sl, r8, lsl #10
     5a0:	0d00000a 	stceq	0, cr0, [r0, #-40]	; 0xffffffd8
     5a4:	db000001 	blle	5b0 <shift+0x5b0>
     5a8:	e1000002 	tst	r0, r2
     5ac:	0e000002 	cdpeq	0, 0, cr0, cr0, cr2, {0}
     5b0:	000003ae 	andeq	r0, r0, lr, lsr #7
     5b4:	040a1600 	streq	r1, [sl], #-1536	; 0xfffffa00
     5b8:	16080000 	strne	r0, [r8], -r0
     5bc:	000a5d0a 	andeq	r5, sl, sl, lsl #26
     5c0:	00010d00 	andeq	r0, r1, r0, lsl #26
     5c4:	0002f900 	andeq	pc, r2, r0, lsl #18
     5c8:	0002ff00 	andeq	pc, r2, r0, lsl #30
     5cc:	03ae0e00 			; <UNDEFINED> instruction: 0x03ae0e00
     5d0:	0d000000 	stceq	0, cr0, [r0, #-0]
     5d4:	00000b85 	andeq	r0, r0, r5, lsl #23
     5d8:	8c051808 	stchi	8, cr1, [r5], {8}
     5dc:	ae00000b 	cdpge	0, 0, cr0, cr0, cr11, {0}
     5e0:	01000003 	tsteq	r0, r3
     5e4:	00000318 	andeq	r0, r0, r8, lsl r3
     5e8:	00000323 	andeq	r0, r0, r3, lsr #6
     5ec:	0003ae0e 	andeq	sl, r3, lr, lsl #28
     5f0:	00521000 	subseq	r1, r2, r0
     5f4:	0d000000 	stceq	0, cr0, [r0, #-0]
     5f8:	00000912 	andeq	r0, r0, r2, lsl r9
     5fc:	820b1908 	andhi	r1, fp, #8, 18	; 0x20000
     600:	b4000008 	strlt	r0, [r0], #-8
     604:	01000003 	tsteq	r0, r3
     608:	0000033c 	andeq	r0, r0, ip, lsr r3
     60c:	00000342 	andeq	r0, r0, r2, asr #6
     610:	0003ae0e 	andeq	sl, r3, lr, lsl #28
     614:	1c0d0000 	stcne	0, cr0, [sp], {-0}
     618:	08000008 	stmdaeq	r0, {r3}
     61c:	0a1a0b1a 	beq	68328c <__bss_end+0x676f4c>
     620:	03b40000 			; <UNDEFINED> instruction: 0x03b40000
     624:	5b010000 	blpl	4062c <__bss_end+0x342ec>
     628:	66000003 	strvs	r0, [r0], -r3
     62c:	0e000003 	cdpeq	0, 0, cr0, cr0, cr3, {0}
     630:	000003ae 	andeq	r0, r0, lr, lsr #7
     634:	00003810 	andeq	r3, r0, r0, lsl r8
     638:	ab0f0000 	blge	3c0640 <__bss_end+0x3b4300>
     63c:	08000006 	stmdaeq	r0, {r1, r2}
     640:	09e40a1b 	stmibeq	r4!, {r0, r1, r3, r4, r9, fp}^
     644:	7b010000 	blvc	4064c <__bss_end+0x3430c>
     648:	81000003 	tsthi	r0, r3
     64c:	0e000003 	cdpeq	0, 0, cr0, cr0, cr3, {0}
     650:	000003ae 	andeq	r0, r0, lr, lsr #7
     654:	06d91700 	ldrbeq	r1, [r9], r0, lsl #14
     658:	1c080000 	stcne	0, cr0, [r8], {-0}
     65c:	0003c50a 	andeq	ip, r3, sl, lsl #10
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
     68c:	b60b0000 	strlt	r0, [fp], -r0
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
     6cc:	00000646 	andeq	r0, r0, r6, asr #12
     6d0:	38090909 	stmdacc	r9, {r0, r3, r8, fp}
     6d4:	10000000 	andne	r0, r0, r0
     6d8:	0007250c 	andeq	r2, r7, ip, lsl #10
     6dc:	090b0900 	stmdbeq	fp, {r8, fp}
     6e0:	00000038 	andeq	r0, r0, r8, lsr r0
     6e4:	0a400c14 	beq	100373c <__bss_end+0xff73fc>
     6e8:	0c090000 	stceq	0, cr0, [r9], {-0}
     6ec:	00003809 	andeq	r3, r0, r9, lsl #16
     6f0:	b60d1800 	strlt	r1, [sp], -r0, lsl #16
     6f4:	0900000b 	stmdbeq	r0, {r0, r1, r3}
     6f8:	07ab0510 			; <UNDEFINED> instruction: 0x07ab0510
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
     728:	f20d0000 	vhadd.s8	d0, d13, d0
     72c:	09000004 	stmdbeq	r0, {r2}
     730:	03ea0911 	mvneq	r0, #278528	; 0x44000
     734:	00380000 	eorseq	r0, r8, r0
     738:	6f010000 	svcvs	0x00010000
     73c:	75000004 	strvc	r0, [r0, #-4]
     740:	0e000004 	cdpeq	0, 0, cr0, cr0, cr4, {0}
     744:	00000491 	muleq	r0, r1, r4
     748:	03e01100 	mvneq	r1, #0, 2
     74c:	13090000 	movwne	r0, #36864	; 0x9000
     750:	00099b0b 	andeq	r9, r9, fp, lsl #22
     754:	00049700 	andeq	r9, r4, r0, lsl #14
     758:	048a0100 	streq	r0, [sl], #256	; 0x100
     75c:	910e0000 	mrsls	r0, (UNDEF: 14)
     760:	00000004 	andeq	r0, r0, r4
     764:	ba040900 	blt	102b6c <__bss_end+0xf682c>
     768:	02000003 	andeq	r0, r0, #3
     76c:	1cea0404 	cfstrdne	mvd0, [sl], #16
     770:	97030000 	strls	r0, [r3, -r0]
     774:	1b000004 	blne	78c <shift+0x78c>
     778:	0000063c 	andeq	r0, r0, ip, lsr r6
     77c:	080f0a1c 	stmdaeq	pc, {r2, r3, r4, r9, fp}	; <UNPREDICTABLE>
     780:	000004d8 	ldrdeq	r0, [r0], -r8
     784:	0004220c 	andeq	r2, r4, ip, lsl #4
     788:	0b110a00 	bleq	442f90 <__bss_end+0x436c50>
     78c:	000004d8 	ldrdeq	r0, [r0], -r8
     790:	0a550c00 	beq	1543798 <__bss_end+0x1537458>
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
     7c0:	730b0000 	movwvc	r0, #45056	; 0xb000
     7c4:	3c000003 	stccc	0, cr0, [r0], {3}
     7c8:	53071b0a 	movwpl	r1, #31498	; 0x7b0a
     7cc:	0c000008 	stceq	0, cr0, [r0], {8}
     7d0:	00000bfe 	strdeq	r0, [r0], -lr
     7d4:	38091f0a 	stmdacc	r9, {r1, r3, r8, r9, sl, fp, ip}
     7d8:	00000000 	andeq	r0, r0, r0
     7dc:	000baf0c 	andeq	sl, fp, ip, lsl #30
     7e0:	09210a00 	stmdbeq	r1!, {r9, fp}
     7e4:	00000038 	andeq	r0, r0, r8, lsr r0
     7e8:	0b4d0c04 	bleq	1343800 <__bss_end+0x13374c0>
     7ec:	230a0000 	movwcs	r0, #40960	; 0xa000
     7f0:	00003809 	andeq	r3, r0, r9, lsl #16
     7f4:	9b0c0800 	blls	3027fc <__bss_end+0x2f64bc>
     7f8:	0a00000b 	beq	82c <shift+0x82c>
     7fc:	00380924 	eorseq	r0, r8, r4, lsr #18
     800:	1c0c0000 	stcne	0, cr0, [ip], {-0}
     804:	00000a72 	andeq	r0, r0, r2, ror sl
     808:	9e1c260a 	cfmsub32ls	mvax0, mvfx2, mvfx12, mvfx10
     80c:	04000004 	streq	r0, [r0], #-4
     810:	37422e45 	strbcc	r2, [r2, -r5, asr #28]
     814:	0007400c 	andeq	r4, r7, ip
     818:	09280a00 	stmdbeq	r8!, {r9, fp}
     81c:	00000038 	andeq	r0, r0, r8, lsr r0
     820:	08dc0c10 	ldmeq	ip, {r4, sl, fp}^
     824:	2a0a0000 	bcs	28082c <__bss_end+0x2744ec>
     828:	00003809 	andeq	r3, r0, r9, lsl #16
     82c:	900c1400 	andls	r1, ip, r0, lsl #8
     830:	0a000004 	beq	848 <shift+0x848>
     834:	010d0a2c 	tsteq	sp, ip, lsr #20
     838:	0c180000 	ldceq	0, cr0, [r8], {-0}
     83c:	000009f7 	strdeq	r0, [r0], -r7
     840:	38092e0a 	stmdacc	r9, {r1, r3, r9, sl, fp, sp}
     844:	1c000000 	stcne	0, cr0, [r0], {-0}
     848:	0006bc0c 	andeq	fp, r6, ip, lsl #24
     84c:	09300a00 	ldmdbeq	r0!, {r9, fp}
     850:	00000038 	andeq	r0, r0, r8, lsr r0
     854:	08690c20 	stmdaeq	r9!, {r5, sl, fp}^
     858:	320a0000 	andcc	r0, sl, #0
     85c:	00085311 	andeq	r5, r8, r1, lsl r3
     860:	9b0c2400 	blls	309868 <__bss_end+0x2fd528>
     864:	0a000004 	beq	87c <shift+0x87c>
     868:	08591034 	ldmdaeq	r9, {r2, r4, r5, ip}^
     86c:	0c280000 	stceq	0, cr0, [r8], #-0
     870:	00000712 	andeq	r0, r0, r2, lsl r7
     874:	9117360a 	tstls	r7, sl, lsl #12
     878:	2c000004 	stccs	0, cr0, [r0], {4}
     87c:	7266621a 	rsbvc	r6, r6, #-1610612735	; 0xa0000001
     880:	0d380a00 	vldmdbeq	r8!, {s0-s-1}
     884:	000003ae 	andeq	r0, r0, lr, lsr #7
     888:	04fa0c30 	ldrbteq	r0, [sl], #3120	; 0xc30
     88c:	3b0a0000 	blcc	280894 <__bss_end+0x274554>
     890:	0004970b 	andeq	r9, r4, fp, lsl #14
     894:	960c3400 	strls	r3, [ip], -r0, lsl #8
     898:	0a00000c 	beq	8d0 <shift+0x8d0>
     89c:	04e80c3e 	strbteq	r0, [r8], #3134	; 0xc3e
     8a0:	16380000 	ldrtne	r0, [r8], -r0
     8a4:	00000c38 	andeq	r0, r0, r8, lsr ip
     8a8:	620a400a 	andvs	r4, sl, #10
     8ac:	0d000007 	stceq	0, cr0, [r0, #-28]	; 0xffffffe4
     8b0:	e7000001 	str	r0, [r0, -r1]
     8b4:	ed000005 	stc	0, cr0, [r0, #-20]	; 0xffffffec
     8b8:	0e000005 	cdpeq	0, 0, cr0, cr0, cr5, {0}
     8bc:	0000085f 	andeq	r0, r0, pc, asr r8
     8c0:	09351600 	ldmdbeq	r5!, {r9, sl, ip}
     8c4:	420a0000 	andmi	r0, sl, #0
     8c8:	0007e70b 	andeq	lr, r7, fp, lsl #14
     8cc:	00049700 	andeq	r9, r4, r0, lsl #14
     8d0:	00060500 	andeq	r0, r6, r0, lsl #10
     8d4:	00061000 	andeq	r1, r6, r0
     8d8:	085f0e00 	ldmdaeq	pc, {r9, sl, fp}^	; <UNPREDICTABLE>
     8dc:	59100000 	ldmdbpl	r0, {}	; <UNPREDICTABLE>
     8e0:	00000008 	andeq	r0, r0, r8
     8e4:	00035b15 	andeq	r5, r3, r5, lsl fp
     8e8:	0a440a00 	beq	11030f0 <__bss_end+0x10f6db0>
     8ec:	000004e1 	andeq	r0, r0, r1, ror #9
     8f0:	00000624 	andeq	r0, r0, r4, lsr #12
     8f4:	0000062a 	andeq	r0, r0, sl, lsr #12
     8f8:	00085f0e 	andeq	r5, r8, lr, lsl #30
     8fc:	47150000 	ldrmi	r0, [r5, -r0]
     900:	0a000009 	beq	92c <shift+0x92c>
     904:	06670a46 	strbteq	r0, [r7], -r6, asr #20
     908:	063e0000 	ldrteq	r0, [lr], -r0
     90c:	06440000 	strbeq	r0, [r4], -r0
     910:	5f0e0000 	svcpl	0x000e0000
     914:	00000008 	andeq	r0, r0, r8
     918:	00073515 	andeq	r3, r7, r5, lsl r5
     91c:	0a480a00 	beq	1203124 <__bss_end+0x11f6de4>
     920:	0000045b 	andeq	r0, r0, fp, asr r4
     924:	00000658 	andeq	r0, r0, r8, asr r6
     928:	0000065e 	andeq	r0, r0, lr, asr r6
     92c:	00085f0e 	andeq	r5, r8, lr, lsl #30
     930:	f8160000 			; <UNDEFINED> instruction: 0xf8160000
     934:	0a000005 	beq	950 <shift+0x950>
     938:	08b80b4a 	ldmeq	r8!, {r1, r3, r6, r8, r9, fp}
     93c:	04970000 	ldreq	r0, [r7], #0
     940:	06760000 	ldrbteq	r0, [r6], -r0
     944:	06860000 	streq	r0, [r6], r0
     948:	5f0e0000 	svcpl	0x000e0000
     94c:	10000008 	andne	r0, r0, r8
     950:	000004e8 	andeq	r0, r0, r8, ror #9
     954:	00049710 	andeq	r9, r4, r0, lsl r7
     958:	c8160000 	ldmdagt	r6, {}	; <UNPREDICTABLE>
     95c:	0a000006 	beq	97c <shift+0x97c>
     960:	053d0b4c 	ldreq	r0, [sp, #-2892]!	; 0xfffff4b4
     964:	04970000 	ldreq	r0, [r7], #0
     968:	069e0000 	ldreq	r0, [lr], r0
     96c:	06b30000 	ldrteq	r0, [r3], r0
     970:	5f0e0000 	svcpl	0x000e0000
     974:	10000008 	andne	r0, r0, r8
     978:	00000497 	muleq	r0, r7, r4
     97c:	00049710 	andeq	r9, r4, r0, lsl r7
     980:	04971000 	ldreq	r1, [r7], #0
     984:	15000000 	strne	r0, [r0, #-0]
     988:	000006cf 	andeq	r0, r0, pc, asr #13
     98c:	260a4e0a 	strcs	r4, [sl], -sl, lsl #28
     990:	c7000006 	strgt	r0, [r0, -r6]
     994:	d2000006 	andle	r0, r0, #6
     998:	0e000006 	cdpeq	0, 0, cr0, cr0, cr6, {0}
     99c:	0000085f 	andeq	r0, r0, pc, asr r8
     9a0:	00085910 	andeq	r5, r8, r0, lsl r9
     9a4:	53150000 	tstpl	r5, #0
     9a8:	0a000003 	beq	9bc <shift+0x9bc>
     9ac:	038a0a50 	orreq	r0, sl, #80, 20	; 0x50000
     9b0:	06e60000 	strbteq	r0, [r6], r0
     9b4:	06f10000 	ldrbteq	r0, [r1], r0
     9b8:	5f0e0000 	svcpl	0x000e0000
     9bc:	10000008 	andne	r0, r0, r8
     9c0:	00000859 	andeq	r0, r0, r9, asr r8
     9c4:	07021500 	streq	r1, [r2, -r0, lsl #10]
     9c8:	520a0000 	andpl	r0, sl, #0
     9cc:	000aeb0a 	andeq	lr, sl, sl, lsl #22
     9d0:	00070500 	andeq	r0, r7, r0, lsl #10
     9d4:	00071000 	andeq	r1, r7, r0
     9d8:	085f0e00 	ldmdaeq	pc, {r9, sl, fp}^	; <UNPREDICTABLE>
     9dc:	53100000 	tstpl	r0, #0
     9e0:	00000008 	andeq	r0, r0, r8
     9e4:	000b1f15 	andeq	r1, fp, r5, lsl pc
     9e8:	0a540a00 	beq	15031f0 <__bss_end+0x14f6eb0>
     9ec:	00000504 	andeq	r0, r0, r4, lsl #10
     9f0:	00000724 	andeq	r0, r0, r4, lsr #14
     9f4:	0000072f 	andeq	r0, r0, pc, lsr #14
     9f8:	00085f0e 	andeq	r5, r8, lr, lsl #30
     9fc:	08531000 	ldmdaeq	r3, {ip}^
     a00:	15000000 	strne	r0, [r0, #-0]
     a04:	00000719 	andeq	r0, r0, r9, lsl r7
     a08:	0d0a560a 	stceq	6, cr5, [sl, #-40]	; 0xffffffd8
     a0c:	43000006 	movwmi	r0, #6
     a10:	49000007 	stmdbmi	r0, {r0, r1, r2}
     a14:	0e000007 	cdpeq	0, 0, cr0, cr0, cr7, {0}
     a18:	0000085f 	andeq	r0, r0, pc, asr r8
     a1c:	09d01500 	ldmibeq	r0, {r8, sl, ip}^
     a20:	580a0000 	stmdapl	sl, {}	; <UNPREDICTABLE>
     a24:	0005760a 	andeq	r7, r5, sl, lsl #12
     a28:	00075d00 	andeq	r5, r7, r0, lsl #26
     a2c:	00076800 	andeq	r6, r7, r0, lsl #16
     a30:	085f0e00 	ldmdaeq	pc, {r9, sl, fp}^	; <UNPREDICTABLE>
     a34:	14100000 	ldrne	r0, [r0], #-0
     a38:	00000001 	andeq	r0, r0, r1
     a3c:	000adb16 	andeq	sp, sl, r6, lsl fp
     a40:	0a5a0a00 	beq	1683248 <__bss_end+0x1676f08>
     a44:	000003a8 	andeq	r0, r0, r8, lsr #7
     a48:	0000010d 	andeq	r0, r0, sp, lsl #2
     a4c:	00000780 	andeq	r0, r0, r0, lsl #15
     a50:	0000078b 	andeq	r0, r0, fp, lsl #15
     a54:	00085f0e 	andeq	r5, r8, lr, lsl #30
     a58:	04971000 	ldreq	r1, [r7], #0
     a5c:	15000000 	strne	r0, [r0, #-0]
     a60:	000005b0 			; <UNDEFINED> instruction: 0x000005b0
     a64:	c90a5c0a 	stmdbgt	sl, {r1, r3, sl, fp, ip, lr}
     a68:	9f000007 	svcls	0x00000007
     a6c:	a5000007 	strge	r0, [r0, #-7]
     a70:	0e000007 	cdpeq	0, 0, cr0, cr0, cr7, {0}
     a74:	0000085f 	andeq	r0, r0, pc, asr r8
     a78:	04a11500 	strteq	r1, [r1], #1280	; 0x500
     a7c:	5e0a0000 	cdppl	0, 0, cr0, cr10, cr0, {0}
     a80:	000ab60a 	andeq	fp, sl, sl, lsl #12
     a84:	0007b900 	andeq	fp, r7, r0, lsl #18
     a88:	0007bf00 	andeq	fp, r7, r0, lsl #30
     a8c:	085f0e00 	ldmdaeq	pc, {r9, sl, fp}^	; <UNPREDICTABLE>
     a90:	0d000000 	stceq	0, cr0, [r0, #-0]
     a94:	00000373 	andeq	r0, r0, r3, ror r3
     a98:	9105620a 	tstls	r5, sl, lsl #4
     a9c:	5f000007 	svcpl	0x00000007
     aa0:	01000008 	tsteq	r0, r8
     aa4:	000007d8 	ldrdeq	r0, [r0], -r8
     aa8:	000007fc 	strdeq	r0, [r0], -ip
     aac:	00085f0e 	andeq	r5, r8, lr, lsl #30
     ab0:	00381000 	eorseq	r1, r8, r0
     ab4:	38100000 	ldmdacc	r0, {}	; <UNPREDICTABLE>
     ab8:	10000000 	andne	r0, r0, r0
     abc:	00000038 	andeq	r0, r0, r8, lsr r0
     ac0:	00003810 	andeq	r3, r0, r0, lsl r8
     ac4:	00381000 	eorseq	r1, r8, r0
     ac8:	ae100000 	cdpge	0, 1, cr0, cr0, cr0, {0}
     acc:	00000003 	andeq	r0, r0, r3
     ad0:	0006b10f 	andeq	fp, r6, pc, lsl #2
     ad4:	0a650a00 	beq	19432dc <__bss_end+0x1936f9c>
     ad8:	00000b6d 	andeq	r0, r0, sp, ror #22
     adc:	00081101 	andeq	r1, r8, r1, lsl #2
     ae0:	00081c00 	andeq	r1, r8, r0, lsl #24
     ae4:	085f0e00 	ldmdaeq	pc, {r9, sl, fp}^	; <UNPREDICTABLE>
     ae8:	ae100000 	cdpge	0, 1, cr0, cr0, cr0, {0}
     aec:	00000003 	andeq	r0, r0, r3
     af0:	00044a0d 	andeq	r4, r4, sp, lsl #20
     af4:	0c670a00 			; <UNDEFINED> instruction: 0x0c670a00
     af8:	0000097d 	andeq	r0, r0, sp, ror r9
     afc:	000004e8 	andeq	r0, r0, r8, ror #9
     b00:	00083501 	andeq	r3, r8, r1, lsl #10
     b04:	00083b00 	andeq	r3, r8, r0, lsl #22
     b08:	085f0e00 	ldmdaeq	pc, {r9, sl, fp}^	; <UNPREDICTABLE>
     b0c:	1d000000 	stcne	0, cr0, [r0, #-0]
     b10:	006e7552 	rsbeq	r7, lr, r2, asr r5
     b14:	4b0a690a 	blmi	29af44 <__bss_end+0x28ec04>
     b18:	01000006 	tsteq	r0, r6
     b1c:	0000084c 	andeq	r0, r0, ip, asr #16
     b20:	00085f0e 	andeq	r5, r8, lr, lsl #30
     b24:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
     b28:	00085904 	andeq	r5, r8, r4, lsl #18
     b2c:	a3040900 	movwge	r0, #18688	; 0x4900
     b30:	09000004 	stmdbeq	r0, {r2}
     b34:	0004ee04 	andeq	lr, r4, r4, lsl #28
     b38:	05e71e00 	strbeq	r1, [r7, #3584]!	; 0xe00
     b3c:	0b020000 	bleq	80b44 <__bss_end+0x74804>
     b40:	00003f0b 	andeq	r3, r0, fp, lsl #30
     b44:	44030500 	strmi	r0, [r3], #-1280	; 0xfffffb00
     b48:	1e0000c0 	cdpne	0, 0, cr0, cr0, cr0, {6}
     b4c:	0000065b 	andeq	r0, r0, fp, asr r6
     b50:	3f0b0c02 	svccc	0x000b0c02
     b54:	05000000 	streq	r0, [r0, #-0]
     b58:	00c04803 	sbceq	r4, r0, r3, lsl #16
     b5c:	03791e00 	cmneq	r9, #0, 28
     b60:	0d020000 	stceq	0, cr0, [r2, #-0]
     b64:	00003f0b 	andeq	r3, r0, fp, lsl #30
     b68:	4c030500 	cfstr32mi	mvfx0, [r3], {-0}
     b6c:	1f0000c0 	svcne	0x000000c0
     b70:	00001f77 	andeq	r1, r0, r7, ror pc
     b74:	38053502 	stmdacc	r5, {r1, r8, sl, ip, sp}
     b78:	4c000000 	stcmi	0, cr0, [r0], {-0}
     b7c:	64000084 	strvs	r0, [r0], #-132	; 0xffffff7c
     b80:	01000002 	tsteq	r0, r2
     b84:	0009699c 	muleq	r9, ip, r9
     b88:	092b1e00 	stmdbeq	fp!, {r9, sl, fp, ip}
     b8c:	37020000 	strcc	r0, [r2, -r0]
     b90:	0000520e 	andeq	r5, r0, lr, lsl #4
     b94:	6c910200 	lfmvs	f0, 4, [r1], {0}
     b98:	02006d20 	andeq	r6, r0, #32, 26	; 0x800
     b9c:	085f0c39 	ldmdaeq	pc, {r0, r3, r4, r5, sl, fp}^	; <UNPREDICTABLE>
     ba0:	91020000 	mrsls	r0, (UNDEF: 2)
     ba4:	66622050 			; <UNDEFINED> instruction: 0x66622050
     ba8:	3b020072 	blcc	80d78 <__bss_end+0x74a38>
     bac:	0003ae0d 	andeq	sl, r3, sp, lsl #28
     bb0:	64910200 	ldrvs	r0, [r1], #512	; 0x200
     bb4:	02007820 	andeq	r7, r0, #32, 16	; 0x200000
     bb8:	03b40b41 			; <UNDEFINED> instruction: 0x03b40b41
     bbc:	91020000 	mrsls	r0, (UNDEF: 2)
     bc0:	04781e68 	ldrbteq	r1, [r8], #-3688	; 0xfffff198
     bc4:	44020000 	strmi	r0, [r2], #-0
     bc8:	0009690a 	andeq	r6, r9, sl, lsl #18
     bcc:	40910200 	addsmi	r0, r1, r0, lsl #4
     bd0:	00047d1e 	andeq	r7, r4, lr, lsl sp
     bd4:	0a450200 	beq	11413dc <__bss_end+0x113509c>
     bd8:	00000969 	andeq	r0, r0, r9, ror #18
     bdc:	7fb09103 	svcvc	0x00b09103
     be0:	0004731e 	andeq	r7, r4, lr, lsl r3
     be4:	0a460200 	beq	11813ec <__bss_end+0x11750ac>
     be8:	00000979 	andeq	r0, r0, r9, ror r9
     bec:	7fa89103 	svcvc	0x00a89103
     bf0:	000a981e 	andeq	r9, sl, lr, lsl r8
     bf4:	0a490200 	beq	12413fc <__bss_end+0x12350bc>
     bf8:	0000039e 	muleq	r0, lr, r3
     bfc:	7ea89103 	tanvce	f1, f3
     c00:	000bfe1e 	andeq	pc, fp, lr, lsl lr	; <UNPREDICTABLE>
     c04:	0b550200 	bleq	154140c <__bss_end+0x15350cc>
     c08:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
     c0c:	1e609102 	lgnnes	f1, f2
     c10:	00000baf 	andeq	r0, r0, pc, lsr #23
     c14:	b40b5e02 	strlt	r5, [fp], #-3586	; 0xfffff1fe
     c18:	02000003 	andeq	r0, r0, #3
     c1c:	281e5c91 	ldmdacs	lr, {r0, r4, r7, sl, fp, ip, lr}
     c20:	0200000b 	andeq	r0, r0, #11
     c24:	003f0f68 	eorseq	r0, pc, r8, ror #30
     c28:	91020000 	mrsls	r0, (UNDEF: 2)
     c2c:	0a041e58 	beq	108594 <__bss_end+0xfc254>
     c30:	69020000 	stmdbvs	r2, {}	; <UNPREDICTABLE>
     c34:	00003f0f 	andeq	r3, r0, pc, lsl #30
     c38:	54910200 	ldrpl	r0, [r1], #512	; 0x200
     c3c:	00251800 	eoreq	r1, r5, r0, lsl #16
     c40:	09790000 	ldmdbeq	r9!, {}^	; <UNPREDICTABLE>
     c44:	63190000 	tstvs	r9, #0
     c48:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
     c4c:	00251800 	eoreq	r1, r5, r0, lsl #16
     c50:	09890000 	stmibeq	r9, {}	; <UNPREDICTABLE>
     c54:	63190000 	tstvs	r9, #0
     c58:	07000000 	streq	r0, [r0, -r0]
     c5c:	0c1e2100 	ldfeqs	f2, [lr], {-0}
     c60:	2b020000 	blcs	80c68 <__bss_end+0x74928>
     c64:	00042d06 	andeq	r2, r4, r6, lsl #26
     c68:	0083d000 	addeq	sp, r3, r0
     c6c:	00007c00 	andeq	r7, r0, r0, lsl #24
     c70:	b39c0100 	orrslt	r0, ip, #0, 2
     c74:	22000009 	andcs	r0, r0, #9
     c78:	00726662 	rsbseq	r6, r2, r2, ror #12
     c7c:	ae1f2b02 	vnmlsge.f64	d2, d15, d2
     c80:	02000003 	andeq	r0, r0, #3
     c84:	23007491 	movwcs	r7, #1169	; 0x491
     c88:	000008ad 	andeq	r0, r0, sp, lsr #17
     c8c:	58061002 	stmdapl	r6, {r1, ip}
     c90:	2c000008 	stccs	0, cr0, [r0], {8}
     c94:	a4000082 	strge	r0, [r0], #-130	; 0xffffff7e
     c98:	01000001 	tsteq	r0, r1
     c9c:	0009dd9c 	muleq	r9, ip, sp
     ca0:	0c962400 	cfldrseq	mvf2, [r6], {0}
     ca4:	10020000 	andne	r0, r2, r0
     ca8:	0004e818 	andeq	lr, r4, r8, lsl r8
     cac:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     cb0:	04122500 	ldreq	r2, [r2], #-1280	; 0xfffffb00
     cb4:	0d010000 	stceq	0, cr0, [r1, #-0]
     cb8:	0003600e 	andeq	r6, r3, lr
     cbc:	00016900 	andeq	r6, r1, r0, lsl #18
     cc0:	0086e000 	addeq	lr, r6, r0
     cc4:	00003000 	andeq	r3, r0, r0
     cc8:	0b9c0100 	bleq	fe7010d0 <__bss_end+0xfe6f4d90>
     ccc:	2400000a 	strcs	r0, [r0], #-10
     cd0:	00001600 	andeq	r1, r0, r0, lsl #12
     cd4:	52260d01 	eorpl	r0, r6, #1, 26	; 0x40
     cd8:	02000000 	andeq	r0, r0, #0
     cdc:	26007491 			; <UNDEFINED> instruction: 0x26007491
     ce0:	00000c11 	andeq	r0, r0, r1, lsl ip
     ce4:	370e0501 	strcc	r0, [lr, -r1, lsl #10]
     ce8:	69000005 	stmdbvs	r0, {r0, r2}
     cec:	b0000001 	andlt	r0, r0, r1
     cf0:	30000086 	andcc	r0, r0, r6, lsl #1
     cf4:	01000000 	mrseq	r0, (UNDEF: 0)
     cf8:	1600249c 			; <UNDEFINED> instruction: 0x1600249c
     cfc:	05010000 	streq	r0, [r1, #-0]
     d00:	00005224 	andeq	r5, r0, r4, lsr #4
     d04:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     d08:	11c70000 	bicne	r0, r7, r0
     d0c:	00040000 	andeq	r0, r4, r0
     d10:	00000496 	muleq	r0, r6, r4
     d14:	025e0104 	subseq	r0, lr, #4, 2
     d18:	a4040000 	strge	r0, [r4], #-0
     d1c:	2a00000c 	bcs	d54 <shift+0xd54>
     d20:	38000000 	stmdacc	r0, {}	; <UNPREDICTABLE>
     d24:	00000000 	andeq	r0, r0, r0
     d28:	e9000000 	stmdb	r0, {}	; <UNPREDICTABLE>
     d2c:	02000004 	andeq	r0, r0, #4
     d30:	00000bb6 			; <UNDEFINED> instruction: 0x00000bb6
     d34:	0703031c 	smladeq	r3, ip, r3, r0
     d38:	000000fc 	strdeq	r0, [r0], -ip
     d3c:	03006103 	movweq	r6, #259	; 0x103
     d40:	00fc0905 	rscseq	r0, ip, r5, lsl #18
     d44:	03000000 	movweq	r0, #0
     d48:	06030063 	streq	r0, [r3], -r3, rrx
     d4c:	0000fc09 	andeq	pc, r0, r9, lsl #24
     d50:	6d030400 	cfstrsvs	mvf0, [r3, #-0]
     d54:	03006e69 	movweq	r6, #3689	; 0xe69
     d58:	00fc0907 	rscseq	r0, ip, r7, lsl #18
     d5c:	03080000 	movweq	r0, #32768	; 0x8000
     d60:	0078616d 	rsbseq	r6, r8, sp, ror #2
     d64:	fc090803 	stc2	8, cr0, [r9], {3}
     d68:	0c000000 	stceq	0, cr0, [r0], {-0}
     d6c:	00064604 	andeq	r4, r6, r4, lsl #12
     d70:	09090300 	stmdbeq	r9, {r8, r9}
     d74:	000000fc 	strdeq	r0, [r0], -ip
     d78:	07250410 			; <UNDEFINED> instruction: 0x07250410
     d7c:	0b030000 	bleq	c0d84 <__bss_end+0xb4a44>
     d80:	0000fc09 	andeq	pc, r0, r9, lsl #24
     d84:	40041400 	andmi	r1, r4, r0, lsl #8
     d88:	0300000a 	movweq	r0, #10
     d8c:	00fc090c 	rscseq	r0, ip, ip, lsl #18
     d90:	05180000 	ldreq	r0, [r8, #-0]
     d94:	00000bb6 			; <UNDEFINED> instruction: 0x00000bb6
     d98:	ab051003 	blge	144dac <__bss_end+0x138a6c>
     d9c:	03000007 	movweq	r0, #7
     da0:	01000001 	tsteq	r0, r1
     da4:	000000a2 	andeq	r0, r0, r2, lsr #1
     da8:	000000c1 	andeq	r0, r0, r1, asr #1
     dac:	00010306 	andeq	r0, r1, r6, lsl #6
     db0:	00fc0700 	rscseq	r0, ip, r0, lsl #14
     db4:	fc070000 	stc2	0, cr0, [r7], {-0}
     db8:	07000000 	streq	r0, [r0, -r0]
     dbc:	000000fc 	strdeq	r0, [r0], -ip
     dc0:	0000fc07 	andeq	pc, r0, r7, lsl #24
     dc4:	00fc0700 	rscseq	r0, ip, r0, lsl #14
     dc8:	05000000 	streq	r0, [r0, #-0]
     dcc:	000004f2 	strdeq	r0, [r0], -r2
     dd0:	ea091103 	b	2451e4 <__bss_end+0x238ea4>
     dd4:	fc000003 	stc2	0, cr0, [r0], {3}
     dd8:	01000000 	mrseq	r0, (UNDEF: 0)
     ddc:	000000da 	ldrdeq	r0, [r0], -sl
     de0:	000000e0 	andeq	r0, r0, r0, ror #1
     de4:	00010306 	andeq	r0, r1, r6, lsl #6
     de8:	e0080000 	and	r0, r8, r0
     dec:	03000003 	movweq	r0, #3
     df0:	099b0b13 	ldmibeq	fp, {r0, r1, r4, r8, r9, fp}
     df4:	01090000 	mrseq	r0, (UNDEF: 9)
     df8:	f5010000 			; <UNDEFINED> instruction: 0xf5010000
     dfc:	06000000 	streq	r0, [r0], -r0
     e00:	00000103 	andeq	r0, r0, r3, lsl #2
     e04:	04090000 	streq	r0, [r9], #-0
     e08:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
     e0c:	25040a00 	strcs	r0, [r4, #-2560]	; 0xfffff600
     e10:	0b000000 	bleq	e18 <shift+0xe18>
     e14:	1cea0404 	cfstrdne	mvd0, [sl], #16
     e18:	090c0000 	stmdbeq	ip, {}	; <UNPREDICTABLE>
     e1c:	0b000001 	bleq	e28 <shift+0xe28>
     e20:	08a80801 	stmiaeq	r8!, {r0, fp}
     e24:	150c0000 	strne	r0, [ip, #-0]
     e28:	0b000001 	bleq	e34 <shift+0xe34>
     e2c:	09210502 	stmdbeq	r1!, {r1, r8, sl}
     e30:	010b0000 	mrseq	r0, (UNDEF: 11)
     e34:	00089f08 	andeq	r9, r8, r8, lsl #30
     e38:	07020b00 	streq	r0, [r2, -r0, lsl #22]
     e3c:	00000698 	muleq	r0, r8, r6
     e40:	0009c70d 	andeq	ip, r9, sp, lsl #14
     e44:	07090b00 	streq	r0, [r9, -r0, lsl #22]
     e48:	00000147 	andeq	r0, r0, r7, asr #2
     e4c:	0001360c 	andeq	r3, r1, ip, lsl #12
     e50:	07040b00 	streq	r0, [r4, -r0, lsl #22]
     e54:	00001fe3 	andeq	r1, r0, r3, ror #31
     e58:	0005c102 	andeq	ip, r5, r2, lsl #2
     e5c:	03040c00 	movweq	r0, #19456	; 0x4c00
     e60:	0001fc07 	andeq	pc, r1, r7, lsl #24
     e64:	0b610400 	bleq	1841e6c <__bss_end+0x1835b2c>
     e68:	06040000 	streq	r0, [r4], -r0
     e6c:	0001360e 	andeq	r3, r1, lr, lsl #12
     e70:	bd040000 	stclt	0, cr0, [r4, #-0]
     e74:	04000009 	streq	r0, [r0], #-9
     e78:	01360e08 	teqeq	r6, r8, lsl #28
     e7c:	04040000 	streq	r0, [r4], #-0
     e80:	0000083f 	andeq	r0, r0, pc, lsr r8
     e84:	360e0b04 	strcc	r0, [lr], -r4, lsl #22
     e88:	08000001 	stmdaeq	r0, {r0}
     e8c:	0005c105 	andeq	ip, r5, r5, lsl #2
     e90:	050d0400 	streq	r0, [sp, #-1024]	; 0xfffffc00
     e94:	00000967 	andeq	r0, r0, r7, ror #18
     e98:	000001fc 	strdeq	r0, [r0], -ip
     e9c:	00019b01 	andeq	r9, r1, r1, lsl #22
     ea0:	0001a100 	andeq	sl, r1, r0, lsl #2
     ea4:	01fc0600 	mvnseq	r0, r0, lsl #12
     ea8:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
     eac:	00000a93 	muleq	r0, r3, sl
     eb0:	e90a0e04 	stmdb	sl, {r2, r9, sl, fp}
     eb4:	01000006 	tsteq	r0, r6
     eb8:	000001b6 			; <UNDEFINED> instruction: 0x000001b6
     ebc:	000001bc 			; <UNDEFINED> instruction: 0x000001bc
     ec0:	0001fc06 	andeq	pc, r1, r6, lsl #24
     ec4:	58050000 	stmdapl	r5, {}	; <UNPREDICTABLE>
     ec8:	04000009 	streq	r0, [r0], #-9
     ecc:	055c0b0f 	ldrbeq	r0, [ip, #-2831]	; 0xfffff4f1
     ed0:	02020000 	andeq	r0, r2, #0
     ed4:	d5010000 	strle	r0, [r1, #-0]
     ed8:	e0000001 	and	r0, r0, r1
     edc:	06000001 	streq	r0, [r0], -r1
     ee0:	000001fc 	strdeq	r0, [r0], -ip
     ee4:	00013607 	andeq	r3, r1, r7, lsl #12
     ee8:	83080000 	movwhi	r0, #32768	; 0x8000
     eec:	0400000a 	streq	r0, [r0], #-10
     ef0:	08ed0e10 	stmiaeq	sp!, {r4, r9, sl, fp}^
     ef4:	01360000 	teqeq	r6, r0
     ef8:	f5010000 			; <UNDEFINED> instruction: 0xf5010000
     efc:	06000001 	streq	r0, [r0], -r1
     f00:	000001fc 	strdeq	r0, [r0], -ip
     f04:	040a0000 	streq	r0, [sl], #-0
     f08:	0000014e 	andeq	r0, r0, lr, asr #2
     f0c:	6810040f 	ldmdavs	r0, {r0, r1, r2, r3, sl}
     f10:	15120400 	ldrne	r0, [r2, #-1024]	; 0xfffffc00
     f14:	0000014e 	andeq	r0, r0, lr, asr #2
     f18:	00078311 	andeq	r8, r7, r1, lsl r3
     f1c:	14050500 	strne	r0, [r5], #-1280	; 0xfffffb00
     f20:	00000142 	andeq	r0, r0, r2, asr #2
     f24:	c1940305 	orrsgt	r0, r4, r5, lsl #6
     f28:	10110000 	andsne	r0, r1, r0
     f2c:	05000008 	streq	r0, [r0, #-8]
     f30:	01421406 	cmpeq	r2, r6, lsl #8
     f34:	03050000 	movweq	r0, #20480	; 0x5000
     f38:	0000c198 	muleq	r0, r8, r1
     f3c:	00074c11 	andeq	r4, r7, r1, lsl ip
     f40:	1a070600 	bne	1c2748 <__bss_end+0x1b6408>
     f44:	00000142 	andeq	r0, r0, r2, asr #2
     f48:	c19c0305 	orrsgt	r0, ip, r5, lsl #6
     f4c:	cf110000 	svcgt	0x00110000
     f50:	06000004 	streq	r0, [r0], -r4
     f54:	01421a09 	cmpeq	r2, r9, lsl #20
     f58:	03050000 	movweq	r0, #20480	; 0x5000
     f5c:	0000c1a0 	andeq	ip, r0, r0, lsr #3
     f60:	00087411 	andeq	r7, r8, r1, lsl r4
     f64:	1a0b0600 	bne	2c276c <__bss_end+0x2b642c>
     f68:	00000142 	andeq	r0, r0, r2, asr #2
     f6c:	c1a40305 			; <UNDEFINED> instruction: 0xc1a40305
     f70:	85110000 	ldrhi	r0, [r1, #-0]
     f74:	06000006 	streq	r0, [r0], -r6
     f78:	01421a0d 	cmpeq	r2, sp, lsl #20
     f7c:	03050000 	movweq	r0, #20480	; 0x5000
     f80:	0000c1a8 	andeq	ip, r0, r8, lsr #3
     f84:	00055211 	andeq	r5, r5, r1, lsl r2
     f88:	1a0f0600 	bne	3c2790 <__bss_end+0x3b6450>
     f8c:	00000142 	andeq	r0, r0, r2, asr #2
     f90:	c1ac0305 			; <UNDEFINED> instruction: 0xc1ac0305
     f94:	010b0000 	mrseq	r0, (UNDEF: 11)
     f98:	0006e402 	andeq	lr, r6, r2, lsl #8
     f9c:	1c040a00 			; <UNDEFINED> instruction: 0x1c040a00
     fa0:	11000001 	tstne	r0, r1
     fa4:	000005ce 	andeq	r0, r0, lr, asr #11
     fa8:	42140407 	andsmi	r0, r4, #117440512	; 0x7000000
     fac:	05000001 	streq	r0, [r0, #-1]
     fb0:	00c1b003 	sbceq	fp, r1, r3
     fb4:	03371100 	teqeq	r7, #0, 2
     fb8:	07070000 	streq	r0, [r7, -r0]
     fbc:	00014214 	andeq	r4, r1, r4, lsl r2
     fc0:	b4030500 	strlt	r0, [r3], #-1280	; 0xfffffb00
     fc4:	110000c1 	smlabtne	r0, r1, r0, r0
     fc8:	00000524 	andeq	r0, r0, r4, lsr #10
     fcc:	42140a07 	andsmi	r0, r4, #28672	; 0x7000
     fd0:	05000001 	streq	r0, [r0, #-1]
     fd4:	00c1b803 	sbceq	fp, r1, r3, lsl #16
     fd8:	07040b00 	streq	r0, [r4, -r0, lsl #22]
     fdc:	00001fde 	ldrdeq	r1, [r0], -lr
     fe0:	000b3311 	andeq	r3, fp, r1, lsl r3
     fe4:	140a0800 	strne	r0, [sl], #-2048	; 0xfffff800
     fe8:	00000142 	andeq	r0, r0, r2, asr #2
     fec:	c1bc0305 			; <UNDEFINED> instruction: 0xc1bc0305
     ff0:	85120000 	ldrhi	r0, [r2, #-0]
     ff4:	0c00000b 	stceq	0, cr0, [r0], {11}
     ff8:	07070901 	streq	r0, [r7, -r1, lsl #18]
     ffc:	0000045d 	andeq	r0, r0, sp, asr r4
    1000:	000b1313 	andeq	r1, fp, r3, lsl r3
    1004:	1b090900 	blne	24340c <__bss_end+0x2370cc>
    1008:	00000142 	andeq	r0, r0, r2, asr #2
    100c:	03660480 	cmneq	r6, #128, 8	; 0x80000000
    1010:	0b090000 	bleq	241018 <__bss_end+0x234cd8>
    1014:	0001360e 	andeq	r3, r1, lr, lsl #12
    1018:	82040000 	andhi	r0, r4, #0
    101c:	09000004 	stmdbeq	r0, {r2}
    1020:	01360e0c 	teqeq	r6, ip, lsl #28
    1024:	04040000 	streq	r0, [r4], #-0
    1028:	00000d6d 	andeq	r0, r0, sp, ror #26
    102c:	5d0a0f09 	stcpl	15, cr0, [sl, #-36]	; 0xffffffdc
    1030:	08000004 	stmdaeq	r0, {r2}
    1034:	00093004 	andeq	r3, r9, r4
    1038:	0e100900 	vnmlseq.f16	s0, s0, s0	; <UNPREDICTABLE>
    103c:	00000136 	andeq	r0, r0, r6, lsr r1
    1040:	0b420488 	bleq	1082268 <__bss_end+0x1075f28>
    1044:	12090000 	andne	r0, r9, #0
    1048:	00045d0a 	andeq	r5, r4, sl, lsl #26
    104c:	5e148c00 	cdppl	12, 1, cr8, cr4, cr0, {0}
    1050:	09000009 	stmdbeq	r0, {r0, r3}
    1054:	04b90a13 	ldrteq	r0, [r9], #2579	; 0xa13
    1058:	03580000 	cmpeq	r8, #0
    105c:	03630000 	cmneq	r3, #0
    1060:	6d060000 	stcvs	0, cr0, [r6, #-0]
    1064:	07000004 	streq	r0, [r0, -r4]
    1068:	00000115 	andeq	r0, r0, r5, lsl r1
    106c:	084e1400 	stmdaeq	lr, {sl, ip}^
    1070:	14090000 	strne	r0, [r9], #-0
    1074:	0005990a 	andeq	r9, r5, sl, lsl #18
    1078:	00037700 	andeq	r7, r3, r0, lsl #14
    107c:	00038200 	andeq	r8, r3, r0, lsl #4
    1080:	046d0600 	strbteq	r0, [sp], #-1536	; 0xfffffa00
    1084:	36070000 	strcc	r0, [r7], -r0
    1088:	00000001 	andeq	r0, r0, r1
    108c:	000c2f15 	andeq	r2, ip, r5, lsl pc
    1090:	0a150900 	beq	543498 <__bss_end+0x537158>
    1094:	00000aa0 	andeq	r0, r0, r0, lsr #21
    1098:	0000028c 	andeq	r0, r0, ip, lsl #5
    109c:	0000039a 	muleq	r0, sl, r3
    10a0:	000003a0 	andeq	r0, r0, r0, lsr #7
    10a4:	00046d06 	andeq	r6, r4, r6, lsl #26
    10a8:	0a150000 	beq	5410b0 <__bss_end+0x534d70>
    10ac:	09000004 	stmdbeq	r0, {r2}
    10b0:	0a5d0a16 	beq	1743910 <__bss_end+0x17375d0>
    10b4:	028c0000 	addeq	r0, ip, #0
    10b8:	03b80000 			; <UNDEFINED> instruction: 0x03b80000
    10bc:	03be0000 			; <UNDEFINED> instruction: 0x03be0000
    10c0:	6d060000 	stcvs	0, cr0, [r6, #-0]
    10c4:	00000004 	andeq	r0, r0, r4
    10c8:	000b8505 	andeq	r8, fp, r5, lsl #10
    10cc:	05180900 	ldreq	r0, [r8, #-2304]	; 0xfffff700
    10d0:	00000b8c 	andeq	r0, r0, ip, lsl #23
    10d4:	0000046d 	andeq	r0, r0, sp, ror #8
    10d8:	0003d701 	andeq	sp, r3, r1, lsl #14
    10dc:	0003e200 	andeq	lr, r3, r0, lsl #4
    10e0:	046d0600 	strbteq	r0, [sp], #-1536	; 0xfffffa00
    10e4:	36070000 	strcc	r0, [r7], -r0
    10e8:	00000001 	andeq	r0, r0, r1
    10ec:	00091205 	andeq	r1, r9, r5, lsl #4
    10f0:	0b190900 	bleq	6434f8 <__bss_end+0x6371b8>
    10f4:	00000882 	andeq	r0, r0, r2, lsl #17
    10f8:	00000473 	andeq	r0, r0, r3, ror r4
    10fc:	0003fb01 	andeq	pc, r3, r1, lsl #22
    1100:	00040100 	andeq	r0, r4, r0, lsl #2
    1104:	046d0600 	strbteq	r0, [sp], #-1536	; 0xfffffa00
    1108:	05000000 	streq	r0, [r0, #-0]
    110c:	0000081c 	andeq	r0, r0, ip, lsl r8
    1110:	1a0b1a09 	bne	2c793c <__bss_end+0x2bb5fc>
    1114:	7300000a 	movwvc	r0, #10
    1118:	01000004 	tsteq	r0, r4
    111c:	0000041a 	andeq	r0, r0, sl, lsl r4
    1120:	00000425 	andeq	r0, r0, r5, lsr #8
    1124:	00046d06 	andeq	r6, r4, r6, lsl #26
    1128:	00fc0700 	rscseq	r0, ip, r0, lsl #14
    112c:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    1130:	000006ab 	andeq	r0, r0, fp, lsr #13
    1134:	e40a1b09 	str	r1, [sl], #-2825	; 0xfffff4f7
    1138:	01000009 	tsteq	r0, r9
    113c:	0000043a 	andeq	r0, r0, sl, lsr r4
    1140:	00000440 	andeq	r0, r0, r0, asr #8
    1144:	00046d06 	andeq	r6, r4, r6, lsl #26
    1148:	d9160000 	ldmdble	r6, {}	; <UNPREDICTABLE>
    114c:	09000006 	stmdbeq	r0, {r1, r2}
    1150:	03c50a1c 	biceq	r0, r5, #28, 20	; 0x1c000
    1154:	51010000 	mrspl	r0, (UNDEF: 1)
    1158:	06000004 	streq	r0, [r0], -r4
    115c:	0000046d 	andeq	r0, r0, sp, ror #8
    1160:	00029307 	andeq	r9, r2, r7, lsl #6
    1164:	17000000 	strne	r0, [r0, -r0]
    1168:	00000115 	andeq	r0, r0, r5, lsl r1
    116c:	0000046d 	andeq	r0, r0, sp, ror #8
    1170:	00014718 	andeq	r4, r1, r8, lsl r7
    1174:	0a007f00 	beq	20d7c <__bss_end+0x14a3c>
    1178:	0002e804 	andeq	lr, r2, r4, lsl #16
    117c:	15040a00 	strne	r0, [r4, #-2560]	; 0xfffff600
    1180:	19000001 	stmdbne	r0, {r0}
    1184:	0000063c 	andeq	r0, r0, ip, lsr r6
    1188:	080f0a1c 	stmdaeq	pc, {r2, r3, r4, r9, fp}	; <UNPREDICTABLE>
    118c:	000004ae 	andeq	r0, r0, lr, lsr #9
    1190:	00042204 	andeq	r2, r4, r4, lsl #4
    1194:	0b110a00 	bleq	44399c <__bss_end+0x43765c>
    1198:	000004ae 	andeq	r0, r0, lr, lsr #9
    119c:	0a550400 	beq	15421a4 <__bss_end+0x1535e64>
    11a0:	130a0000 	movwne	r0, #40960	; 0xa000
    11a4:	0001090b 	andeq	r0, r1, fp, lsl #18
    11a8:	42041400 	andmi	r1, r4, #0, 8
    11ac:	0a000003 	beq	11c0 <shift+0x11c0>
    11b0:	04be0c15 	ldrteq	r0, [lr], #3093	; 0xc15
    11b4:	00180000 	andseq	r0, r8, r0
    11b8:	00010917 	andeq	r0, r1, r7, lsl r9
    11bc:	0004be00 	andeq	fp, r4, r0, lsl #28
    11c0:	01471800 	cmpeq	r7, r0, lsl #16
    11c4:	00040000 	andeq	r0, r4, r0
    11c8:	0109040a 	tsteq	r9, sl, lsl #8
    11cc:	73020000 	movwvc	r0, #8192	; 0x2000
    11d0:	3c000003 	stccc	0, cr0, [r0], {3}
    11d4:	29071b0a 	stmdbcs	r7, {r1, r3, r8, r9, fp, ip}
    11d8:	04000008 	streq	r0, [r0], #-8
    11dc:	00000bfe 	strdeq	r0, [r0], -lr
    11e0:	fc091f0a 	stc2	15, cr1, [r9], {10}
    11e4:	00000000 	andeq	r0, r0, r0
    11e8:	000baf04 	andeq	sl, fp, r4, lsl #30
    11ec:	09210a00 	stmdbeq	r1!, {r9, fp}
    11f0:	000000fc 	strdeq	r0, [r0], -ip
    11f4:	0b4d0404 	bleq	134220c <__bss_end+0x1335ecc>
    11f8:	230a0000 	movwcs	r0, #40960	; 0xa000
    11fc:	0000fc09 	andeq	pc, r0, r9, lsl #24
    1200:	9b040800 	blls	103208 <__bss_end+0xf6ec8>
    1204:	0a00000b 	beq	1238 <shift+0x1238>
    1208:	00fc0924 	rscseq	r0, ip, r4, lsr #18
    120c:	1a0c0000 	bne	301214 <__bss_end+0x2f4ed4>
    1210:	00000a72 	andeq	r0, r0, r2, ror sl
    1214:	101c260a 	andsne	r2, ip, sl, lsl #12
    1218:	04000001 	streq	r0, [r0], #-1
    121c:	37422e45 	strbcc	r2, [r2, -r5, asr #28]
    1220:	00074004 	andeq	r4, r7, r4
    1224:	09280a00 	stmdbeq	r8!, {r9, fp}
    1228:	000000fc 	strdeq	r0, [r0], -ip
    122c:	08dc0410 	ldmeq	ip, {r4, sl}^
    1230:	2a0a0000 	bcs	281238 <__bss_end+0x274ef8>
    1234:	0000fc09 	andeq	pc, r0, r9, lsl #24
    1238:	90041400 	andls	r1, r4, r0, lsl #8
    123c:	0a000004 	beq	1254 <shift+0x1254>
    1240:	028c0a2c 	addeq	r0, ip, #44, 20	; 0x2c000
    1244:	04180000 	ldreq	r0, [r8], #-0
    1248:	000009f7 	strdeq	r0, [r0], -r7
    124c:	fc092e0a 	stc2	14, cr2, [r9], {10}
    1250:	1c000000 	stcne	0, cr0, [r0], {-0}
    1254:	0006bc04 	andeq	fp, r6, r4, lsl #24
    1258:	09300a00 	ldmdbeq	r0!, {r9, fp}
    125c:	000000fc 	strdeq	r0, [r0], -ip
    1260:	08690420 	stmdaeq	r9!, {r5, sl}^
    1264:	320a0000 	andcc	r0, sl, #0
    1268:	00082911 	andeq	r2, r8, r1, lsl r9
    126c:	9b042400 	blls	10a274 <__bss_end+0xfdf34>
    1270:	0a000004 	beq	1288 <shift+0x1288>
    1274:	082f1034 	stmdaeq	pc!, {r2, r4, r5, ip}	; <UNPREDICTABLE>
    1278:	04280000 	strteq	r0, [r8], #-0
    127c:	00000712 	andeq	r0, r0, r2, lsl r7
    1280:	0317360a 	tsteq	r7, #10485760	; 0xa00000
    1284:	2c000001 	stccs	0, cr0, [r0], {1}
    1288:	72666203 	rsbvc	r6, r6, #805306368	; 0x30000000
    128c:	0d380a00 	vldmdbeq	r8!, {s0-s-1}
    1290:	0000046d 	andeq	r0, r0, sp, ror #8
    1294:	04fa0430 	ldrbteq	r0, [sl], #1072	; 0x430
    1298:	3b0a0000 	blcc	2812a0 <__bss_end+0x274f60>
    129c:	0001090b 	andeq	r0, r1, fp, lsl #18
    12a0:	96043400 	strls	r3, [r4], -r0, lsl #8
    12a4:	0a00000c 	beq	12dc <shift+0x12dc>
    12a8:	04be0c3e 	ldrteq	r0, [lr], #3134	; 0xc3e
    12ac:	15380000 	ldrne	r0, [r8, #-0]!
    12b0:	00000c38 	andeq	r0, r0, r8, lsr ip
    12b4:	620a400a 	andvs	r4, sl, #10
    12b8:	8c000007 	stchi	0, cr0, [r0], {7}
    12bc:	bd000002 	stclt	0, cr0, [r0, #-8]
    12c0:	c3000005 	movwgt	r0, #5
    12c4:	06000005 	streq	r0, [r0], -r5
    12c8:	00000835 	andeq	r0, r0, r5, lsr r8
    12cc:	09351500 	ldmdbeq	r5!, {r8, sl, ip}
    12d0:	420a0000 	andmi	r0, sl, #0
    12d4:	0007e70b 	andeq	lr, r7, fp, lsl #14
    12d8:	00010900 	andeq	r0, r1, r0, lsl #18
    12dc:	0005db00 	andeq	sp, r5, r0, lsl #22
    12e0:	0005e600 	andeq	lr, r5, r0, lsl #12
    12e4:	08350600 	ldmdaeq	r5!, {r9, sl}
    12e8:	2f070000 	svccs	0x00070000
    12ec:	00000008 	andeq	r0, r0, r8
    12f0:	00035b14 	andeq	r5, r3, r4, lsl fp
    12f4:	0a440a00 	beq	1103afc <__bss_end+0x10f77bc>
    12f8:	000004e1 	andeq	r0, r0, r1, ror #9
    12fc:	000005fa 	strdeq	r0, [r0], -sl
    1300:	00000600 	andeq	r0, r0, r0, lsl #12
    1304:	00083506 	andeq	r3, r8, r6, lsl #10
    1308:	47140000 	ldrmi	r0, [r4, -r0]
    130c:	0a000009 	beq	1338 <shift+0x1338>
    1310:	06670a46 	strbteq	r0, [r7], -r6, asr #20
    1314:	06140000 	ldreq	r0, [r4], -r0
    1318:	061a0000 	ldreq	r0, [sl], -r0
    131c:	35060000 	strcc	r0, [r6, #-0]
    1320:	00000008 	andeq	r0, r0, r8
    1324:	00073514 	andeq	r3, r7, r4, lsl r5
    1328:	0a480a00 	beq	1203b30 <__bss_end+0x11f77f0>
    132c:	0000045b 	andeq	r0, r0, fp, asr r4
    1330:	0000062e 	andeq	r0, r0, lr, lsr #12
    1334:	00000634 	andeq	r0, r0, r4, lsr r6
    1338:	00083506 	andeq	r3, r8, r6, lsl #10
    133c:	f8150000 			; <UNDEFINED> instruction: 0xf8150000
    1340:	0a000005 	beq	135c <shift+0x135c>
    1344:	08b80b4a 	ldmeq	r8!, {r1, r3, r6, r8, r9, fp}
    1348:	01090000 	mrseq	r0, (UNDEF: 9)
    134c:	064c0000 	strbeq	r0, [ip], -r0
    1350:	065c0000 	ldrbeq	r0, [ip], -r0
    1354:	35060000 	strcc	r0, [r6, #-0]
    1358:	07000008 	streq	r0, [r0, -r8]
    135c:	000004be 			; <UNDEFINED> instruction: 0x000004be
    1360:	00010907 	andeq	r0, r1, r7, lsl #18
    1364:	c8150000 	ldmdagt	r5, {}	; <UNPREDICTABLE>
    1368:	0a000006 	beq	1388 <shift+0x1388>
    136c:	053d0b4c 	ldreq	r0, [sp, #-2892]!	; 0xfffff4b4
    1370:	01090000 	mrseq	r0, (UNDEF: 9)
    1374:	06740000 	ldrbteq	r0, [r4], -r0
    1378:	06890000 	streq	r0, [r9], r0
    137c:	35060000 	strcc	r0, [r6, #-0]
    1380:	07000008 	streq	r0, [r0, -r8]
    1384:	00000109 	andeq	r0, r0, r9, lsl #2
    1388:	00010907 	andeq	r0, r1, r7, lsl #18
    138c:	01090700 	tsteq	r9, r0, lsl #14
    1390:	14000000 	strne	r0, [r0], #-0
    1394:	000006cf 	andeq	r0, r0, pc, asr #13
    1398:	260a4e0a 	strcs	r4, [sl], -sl, lsl #28
    139c:	9d000006 	stcls	0, cr0, [r0, #-24]	; 0xffffffe8
    13a0:	a8000006 	stmdage	r0, {r1, r2}
    13a4:	06000006 	streq	r0, [r0], -r6
    13a8:	00000835 	andeq	r0, r0, r5, lsr r8
    13ac:	00082f07 	andeq	r2, r8, r7, lsl #30
    13b0:	53140000 	tstpl	r4, #0
    13b4:	0a000003 	beq	13c8 <shift+0x13c8>
    13b8:	038a0a50 	orreq	r0, sl, #80, 20	; 0x50000
    13bc:	06bc0000 	ldrteq	r0, [ip], r0
    13c0:	06c70000 	strbeq	r0, [r7], r0
    13c4:	35060000 	strcc	r0, [r6, #-0]
    13c8:	07000008 	streq	r0, [r0, -r8]
    13cc:	0000082f 	andeq	r0, r0, pc, lsr #16
    13d0:	07021400 	streq	r1, [r2, -r0, lsl #8]
    13d4:	520a0000 	andpl	r0, sl, #0
    13d8:	000aeb0a 	andeq	lr, sl, sl, lsl #22
    13dc:	0006db00 	andeq	sp, r6, r0, lsl #22
    13e0:	0006e600 	andeq	lr, r6, r0, lsl #12
    13e4:	08350600 	ldmdaeq	r5!, {r9, sl}
    13e8:	29070000 	stmdbcs	r7, {}	; <UNPREDICTABLE>
    13ec:	00000008 	andeq	r0, r0, r8
    13f0:	000b1f14 	andeq	r1, fp, r4, lsl pc
    13f4:	0a540a00 	beq	1503bfc <__bss_end+0x14f78bc>
    13f8:	00000504 	andeq	r0, r0, r4, lsl #10
    13fc:	000006fa 	strdeq	r0, [r0], -sl
    1400:	00000705 	andeq	r0, r0, r5, lsl #14
    1404:	00083506 	andeq	r3, r8, r6, lsl #10
    1408:	08290700 	stmdaeq	r9!, {r8, r9, sl}
    140c:	14000000 	strne	r0, [r0], #-0
    1410:	00000719 	andeq	r0, r0, r9, lsl r7
    1414:	0d0a560a 	stceq	6, cr5, [sl, #-40]	; 0xffffffd8
    1418:	19000006 	stmdbne	r0, {r1, r2}
    141c:	1f000007 	svcne	0x00000007
    1420:	06000007 	streq	r0, [r0], -r7
    1424:	00000835 	andeq	r0, r0, r5, lsr r8
    1428:	09d01400 	ldmibeq	r0, {sl, ip}^
    142c:	580a0000 	stmdapl	sl, {}	; <UNPREDICTABLE>
    1430:	0005760a 	andeq	r7, r5, sl, lsl #12
    1434:	00073300 	andeq	r3, r7, r0, lsl #6
    1438:	00073e00 	andeq	r3, r7, r0, lsl #28
    143c:	08350600 	ldmdaeq	r5!, {r9, sl}
    1440:	93070000 	movwls	r0, #28672	; 0x7000
    1444:	00000002 	andeq	r0, r0, r2
    1448:	000adb15 	andeq	sp, sl, r5, lsl fp
    144c:	0a5a0a00 	beq	1683c54 <__bss_end+0x1677914>
    1450:	000003a8 	andeq	r0, r0, r8, lsr #7
    1454:	0000028c 	andeq	r0, r0, ip, lsl #5
    1458:	00000756 	andeq	r0, r0, r6, asr r7
    145c:	00000761 	andeq	r0, r0, r1, ror #14
    1460:	00083506 	andeq	r3, r8, r6, lsl #10
    1464:	01090700 	tsteq	r9, r0, lsl #14
    1468:	14000000 	strne	r0, [r0], #-0
    146c:	000005b0 			; <UNDEFINED> instruction: 0x000005b0
    1470:	c90a5c0a 	stmdbgt	sl, {r1, r3, sl, fp, ip, lr}
    1474:	75000007 	strvc	r0, [r0, #-7]
    1478:	7b000007 	blvc	149c <shift+0x149c>
    147c:	06000007 	streq	r0, [r0], -r7
    1480:	00000835 	andeq	r0, r0, r5, lsr r8
    1484:	04a11400 	strteq	r1, [r1], #1024	; 0x400
    1488:	5e0a0000 	cdppl	0, 0, cr0, cr10, cr0, {0}
    148c:	000ab60a 	andeq	fp, sl, sl, lsl #12
    1490:	00078f00 	andeq	r8, r7, r0, lsl #30
    1494:	00079500 	andeq	r9, r7, r0, lsl #10
    1498:	08350600 	ldmdaeq	r5!, {r9, sl}
    149c:	05000000 	streq	r0, [r0, #-0]
    14a0:	00000373 	andeq	r0, r0, r3, ror r3
    14a4:	9105620a 	tstls	r5, sl, lsl #4
    14a8:	35000007 	strcc	r0, [r0, #-7]
    14ac:	01000008 	tsteq	r0, r8
    14b0:	000007ae 	andeq	r0, r0, lr, lsr #15
    14b4:	000007d2 	ldrdeq	r0, [r0], -r2
    14b8:	00083506 	andeq	r3, r8, r6, lsl #10
    14bc:	00fc0700 	rscseq	r0, ip, r0, lsl #14
    14c0:	fc070000 	stc2	0, cr0, [r7], {-0}
    14c4:	07000000 	streq	r0, [r0, -r0]
    14c8:	000000fc 	strdeq	r0, [r0], -ip
    14cc:	0000fc07 	andeq	pc, r0, r7, lsl #24
    14d0:	00fc0700 	rscseq	r0, ip, r0, lsl #14
    14d4:	6d070000 	stcvs	0, cr0, [r7, #-0]
    14d8:	00000004 	andeq	r0, r0, r4
    14dc:	0006b10e 	andeq	fp, r6, lr, lsl #2
    14e0:	0a650a00 	beq	1943ce8 <__bss_end+0x19379a8>
    14e4:	00000b6d 	andeq	r0, r0, sp, ror #22
    14e8:	0007e701 	andeq	lr, r7, r1, lsl #14
    14ec:	0007f200 	andeq	pc, r7, r0, lsl #4
    14f0:	08350600 	ldmdaeq	r5!, {r9, sl}
    14f4:	6d070000 	stcvs	0, cr0, [r7, #-0]
    14f8:	00000004 	andeq	r0, r0, r4
    14fc:	00044a05 	andeq	r4, r4, r5, lsl #20
    1500:	0c670a00 			; <UNDEFINED> instruction: 0x0c670a00
    1504:	0000097d 	andeq	r0, r0, sp, ror r9
    1508:	000004be 			; <UNDEFINED> instruction: 0x000004be
    150c:	00080b01 	andeq	r0, r8, r1, lsl #22
    1510:	00081100 	andeq	r1, r8, r0, lsl #2
    1514:	08350600 	ldmdaeq	r5!, {r9, sl}
    1518:	1b000000 	blne	1520 <shift+0x1520>
    151c:	006e7552 	rsbeq	r7, lr, r2, asr r5
    1520:	4b0a690a 	blmi	29b950 <__bss_end+0x28f610>
    1524:	01000006 	tsteq	r0, r6
    1528:	00000822 	andeq	r0, r0, r2, lsr #16
    152c:	00083506 	andeq	r3, r8, r6, lsl #10
    1530:	0a000000 	beq	1538 <shift+0x1538>
    1534:	00082f04 	andeq	r2, r8, r4, lsl #30
    1538:	79040a00 	stmdbvc	r4, {r9, fp}
    153c:	0a000004 	beq	1554 <shift+0x1554>
    1540:	0004c404 	andeq	ip, r4, r4, lsl #8
    1544:	08350c00 	ldmdaeq	r5!, {sl, fp}
    1548:	111c0000 	tstne	ip, r0
    154c:	02000008 	andeq	r0, r0, #8
    1550:	5b06011e 	blpl	1819d0 <__bss_end+0x175690>
    1554:	68000008 	stmdavs	r0, {r3}
    1558:	e0000098 	mul	r0, r8, r0
    155c:	01000002 	tsteq	r0, r2
    1560:	0009069c 	muleq	r9, ip, r6
    1564:	0c861d00 	stceq	13, cr1, [r6], {0}
    1568:	083b0000 	ldmdaeq	fp!, {}	; <UNPREDICTABLE>
    156c:	91020000 	mrsls	r0, (UNDEF: 2)
    1570:	0ceb1e44 	stcleq	14, cr1, [fp], #272	; 0x110
    1574:	1f020000 	svcne	0x00020000
    1578:	09060a01 	stmdbeq	r6, {r0, r9, fp}
    157c:	91020000 	mrsls	r0, (UNDEF: 2)
    1580:	98781f4c 	ldmdals	r8!, {r2, r3, r6, r8, r9, sl, fp, ip}^
    1584:	02b80000 	adcseq	r0, r8, #0
    1588:	8b1e0000 	blhi	781590 <__bss_end+0x775250>
    158c:	0200000c 	andeq	r0, r0, #12
    1590:	8c0e0128 	stfhis	f0, [lr], {40}	; 0x28
    1594:	02000002 	andeq	r0, r0, #2
    1598:	741e7791 	ldrvc	r7, [lr], #-1937	; 0xfffff86f
    159c:	0200000d 	andeq	r0, r0, #13
    15a0:	090f0159 	stmdbeq	pc, {r0, r3, r4, r6, r8}	; <UNPREDICTABLE>
    15a4:	02000001 	andeq	r0, r0, #1
    15a8:	bc1f6091 	ldclt	0, cr6, [pc], {145}	; 0x91
    15ac:	d0000098 	mulle	r0, r8, r0
    15b0:	20000001 	andcs	r0, r0, r1
    15b4:	2b020069 	blcs	81760 <__bss_end+0x75420>
    15b8:	00fc1101 	rscseq	r1, ip, r1, lsl #2
    15bc:	91020000 	mrsls	r0, (UNDEF: 2)
    15c0:	98f02170 	ldmls	r0!, {r4, r5, r6, r8, sp}^
    15c4:	00e00000 	rsceq	r0, r0, r0
    15c8:	08eb0000 	stmiaeq	fp!, {}^	; <UNPREDICTABLE>
    15cc:	69200000 	stmdbvs	r0!, {}	; <UNPREDICTABLE>
    15d0:	012e0200 			; <UNDEFINED> instruction: 0x012e0200
    15d4:	0000fc15 	andeq	pc, r0, r5, lsl ip	; <UNPREDICTABLE>
    15d8:	6c910200 	lfmvs	f0, 4, [r1], {0}
    15dc:	00990c1f 	addseq	r0, r9, pc, lsl ip
    15e0:	0000b400 	andeq	fp, r0, r0, lsl #8
    15e4:	00662000 	rsbeq	r2, r6, r0
    15e8:	17013202 	strne	r3, [r1, -r2, lsl #4]
    15ec:	00000109 	andeq	r0, r0, r9, lsl #2
    15f0:	00649102 	rsbeq	r9, r4, r2, lsl #2
    15f4:	9a481f00 	bls	12091fc <__bss_end+0x11fcebc>
    15f8:	00280000 	eoreq	r0, r8, r0
    15fc:	69200000 	stmdbvs	r0!, {}	; <UNPREDICTABLE>
    1600:	01510200 	cmpeq	r1, r0, lsl #4
    1604:	0000fc11 	andeq	pc, r0, r1, lsl ip	; <UNPREDICTABLE>
    1608:	68910200 	ldmvs	r1, {r9}
    160c:	00000000 	andeq	r0, r0, r0
    1610:	00011517 	andeq	r1, r1, r7, lsl r5
    1614:	00091600 	andeq	r1, r9, r0, lsl #12
    1618:	01471800 	cmpeq	r7, r0, lsl #16
    161c:	00130000 	andseq	r0, r3, r0
    1620:	0007051c 	andeq	r0, r7, ip, lsl r5
    1624:	01190200 	tsteq	r9, r0, lsl #4
    1628:	00093106 	andeq	r3, r9, r6, lsl #2
    162c:	00983400 	addseq	r3, r8, r0, lsl #8
    1630:	00003400 	andeq	r3, r0, r0, lsl #8
    1634:	3e9c0100 	fmlcce	f0, f4, f0
    1638:	1d000009 	stcne	0, cr0, [r0, #-36]	; 0xffffffdc
    163c:	00000c86 	andeq	r0, r0, r6, lsl #25
    1640:	0000083b 	andeq	r0, r0, fp, lsr r8
    1644:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1648:	0006e61c 	andeq	lr, r6, ip, lsl r6
    164c:	01120200 	tsteq	r2, r0, lsl #4
    1650:	00095906 	andeq	r5, r9, r6, lsl #18
    1654:	00977000 	addseq	r7, r7, r0
    1658:	0000c400 	andeq	ip, r0, r0, lsl #8
    165c:	9e9c0100 	fmllse	f0, f4, f0
    1660:	1d000009 	stcne	0, cr0, [r0, #-36]	; 0xffffffdc
    1664:	00000c86 	andeq	r0, r0, r6, lsl #25
    1668:	0000083b 	andeq	r0, r0, fp, lsr r8
    166c:	22649102 	rsbcs	r9, r4, #-2147483648	; 0x80000000
    1670:	00000869 	andeq	r0, r0, r9, ror #16
    1674:	22011202 	andcs	r1, r1, #536870912	; 0x20000000
    1678:	00000829 	andeq	r0, r0, r9, lsr #16
    167c:	1e609102 	lgnnes	f1, f2
    1680:	00000c53 	andeq	r0, r0, r3, asr ip
    1684:	09011302 	stmdbeq	r1, {r1, r8, r9, ip}
    1688:	000000fc 	strdeq	r0, [r0], -ip
    168c:	1f689102 	svcne	0x00689102
    1690:	000097c0 	andeq	r9, r0, r0, asr #15
    1694:	00000064 	andeq	r0, r0, r4, rrx
    1698:	02006920 	andeq	r6, r0, #32, 18	; 0x80000
    169c:	fc0d0114 	stc2	1, cr0, [sp], {20}
    16a0:	02000000 	andeq	r0, r0, #0
    16a4:	00006c91 	muleq	r0, r1, ip
    16a8:	00061a23 	andeq	r1, r6, r3, lsr #20
    16ac:	06f30200 	ldrbteq	r0, [r3], r0, lsl #4
    16b0:	000009b8 			; <UNDEFINED> instruction: 0x000009b8
    16b4:	0000963c 	andeq	r9, r0, ip, lsr r6
    16b8:	00000134 	andeq	r0, r0, r4, lsr r1
    16bc:	09fd9c01 	ldmibeq	sp!, {r0, sl, fp, ip, pc}^
    16c0:	861d0000 	ldrhi	r0, [sp], -r0
    16c4:	3b00000c 	blcc	16fc <shift+0x16fc>
    16c8:	02000008 	andeq	r0, r0, #8
    16cc:	c1246491 			; <UNDEFINED> instruction: 0xc1246491
    16d0:	02000012 	andeq	r0, r0, #18
    16d4:	04730bf4 	ldrbteq	r0, [r3], #-3060	; 0xfffff40c
    16d8:	91020000 	mrsls	r0, (UNDEF: 2)
    16dc:	22632474 	rsbcs	r2, r3, #116, 8	; 0x74000000
    16e0:	f8020000 			; <UNDEFINED> instruction: 0xf8020000
    16e4:	0000fc09 	andeq	pc, r0, r9, lsl #24
    16e8:	70910200 	addsvc	r0, r1, r0, lsl #4
    16ec:	02006625 	andeq	r6, r0, #38797312	; 0x2500000
    16f0:	01090bf9 	strdeq	r0, [r9, -r9]
    16f4:	91020000 	mrsls	r0, (UNDEF: 2)
    16f8:	0069256c 	rsbeq	r2, r9, ip, ror #10
    16fc:	fc09fa02 	stc2	10, cr15, [r9], {2}	; <UNPREDICTABLE>
    1700:	02000000 	andeq	r0, r0, #0
    1704:	23006891 	movwcs	r6, #2193	; 0x891
    1708:	0000077b 	andeq	r0, r0, fp, ror r7
    170c:	1706e702 	strne	lr, [r6, -r2, lsl #14]
    1710:	8c00000a 	stchi	0, cr0, [r0], {10}
    1714:	b0000095 	mullt	r0, r5, r0
    1718:	01000000 	mrseq	r0, (UNDEF: 0)
    171c:	000a6e9c 	muleq	sl, ip, lr
    1720:	0c861d00 	stceq	13, cr1, [r6], {0}
    1724:	083b0000 	ldmdaeq	fp!, {}	; <UNPREDICTABLE>
    1728:	91020000 	mrsls	r0, (UNDEF: 2)
    172c:	00742554 	rsbseq	r2, r4, r4, asr r5
    1730:	2f10e802 	svccs	0x0010e802
    1734:	02000008 	andeq	r0, r0, #8
    1738:	03247091 			; <UNDEFINED> instruction: 0x03247091
    173c:	0200000d 	andeq	r0, r0, #13
    1740:	09060ae9 	stmdbeq	r6, {r0, r3, r5, r6, r7, r9, fp}
    1744:	91020000 	mrsls	r0, (UNDEF: 2)
    1748:	95a81f58 	strls	r1, [r8, #3928]!	; 0xf58
    174c:	00840000 	addeq	r0, r4, r0
    1750:	69250000 	stmdbvs	r5!, {}	; <UNPREDICTABLE>
    1754:	0dea0200 	sfmeq	f0, 2, [sl]
    1758:	000000fc 	strdeq	r0, [r0], -ip
    175c:	1f749102 	svcne	0x00749102
    1760:	000095c4 	andeq	r9, r0, r4, asr #11
    1764:	00000058 	andeq	r0, r0, r8, asr r0
    1768:	02006625 	andeq	r6, r0, #38797312	; 0x2500000
    176c:	01090feb 	smlatteq	r9, fp, pc, r0	; <UNPREDICTABLE>
    1770:	91020000 	mrsls	r0, (UNDEF: 2)
    1774:	0000006c 	andeq	r0, r0, ip, rrx
    1778:	00071f23 	andeq	r1, r7, r3, lsr #30
    177c:	06d60200 	ldrbeq	r0, [r6], r0, lsl #4
    1780:	00000a88 	andeq	r0, r0, r8, lsl #21
    1784:	0000949c 	muleq	r0, ip, r4
    1788:	000000f0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
    178c:	0aa49c01 	beq	fe928798 <__bss_end+0xfe91c458>
    1790:	861d0000 	ldrhi	r0, [sp], -r0
    1794:	3b00000c 	blcc	17cc <shift+0x17cc>
    1798:	02000008 	andeq	r0, r0, #8
    179c:	73267491 			; <UNDEFINED> instruction: 0x73267491
    17a0:	02007274 	andeq	r7, r0, #116, 4	; 0x40000007
    17a4:	02932dd6 	addseq	r2, r3, #13696	; 0x3580
    17a8:	91020000 	mrsls	r0, (UNDEF: 2)
    17ac:	c7230070 			; <UNDEFINED> instruction: 0xc7230070
    17b0:	02000006 	andeq	r0, r0, #6
    17b4:	0abe06b0 	beq	fef8327c <__bss_end+0xfef76f3c>
    17b8:	91e40000 	mvnls	r0, r0
    17bc:	02b80000 	adcseq	r0, r8, #0
    17c0:	9c010000 	stcls	0, cr0, [r1], {-0}
    17c4:	00000bc4 	andeq	r0, r0, r4, asr #23
    17c8:	000c861d 	andeq	r8, ip, sp, lsl r6
    17cc:	00083b00 	andeq	r3, r8, r0, lsl #22
    17d0:	bc910300 	ldclt	3, cr0, [r1], {0}
    17d4:	0869277f 	stmdaeq	r9!, {r0, r1, r2, r3, r4, r5, r6, r8, r9, sl, sp}^
    17d8:	b0020000 	andlt	r0, r2, r0
    17dc:	00082929 	andeq	r2, r8, r9, lsr #18
    17e0:	b8910300 	ldmlt	r1, {r8, r9}
    17e4:	0cd7247f 	cfldrdeq	mvd2, [r7], {127}	; 0x7f
    17e8:	b2020000 	andlt	r0, r2, #0
    17ec:	0000fc09 	andeq	pc, r0, r9, lsl #24
    17f0:	58910200 	ldmpl	r1, {r9}
    17f4:	000d4e24 	andeq	r4, sp, r4, lsr #28
    17f8:	0ab40200 	beq	fed02000 <__bss_end+0xfecf5cc0>
    17fc:	0000028c 	andeq	r0, r0, ip, lsl #5
    1800:	24579102 	ldrbcs	r9, [r7], #-258	; 0xfffffefe
    1804:	00001999 	muleq	r0, r9, r9
    1808:	fc09b802 	stc2	8, cr11, [r9], {2}
    180c:	02000000 	andeq	r0, r0, #0
    1810:	1f246c91 	svcne	0x00246c91
    1814:	0200000d 	andeq	r0, r0, #13
    1818:	00fc09ba 	ldrhteq	r0, [ip], #154	; 0x9a
    181c:	91020000 	mrsls	r0, (UNDEF: 2)
    1820:	09fc2450 	ldmibeq	ip!, {r4, r6, sl, sp}^
    1824:	bc020000 	stclt	0, cr0, [r2], {-0}
    1828:	0000fc09 	andeq	pc, r0, r9, lsl #24
    182c:	68910200 	ldmvs	r1, {r9}
    1830:	000c6d24 	andeq	r6, ip, r4, lsr #26
    1834:	09bf0200 	ldmibeq	pc!, {r9}	; <UNPREDICTABLE>
    1838:	000000fc 	strdeq	r0, [r0], -ip
    183c:	214c9102 	cmpcs	ip, r2, lsl #2
    1840:	000092cc 	andeq	r9, r0, ip, asr #5
    1844:	00000120 	andeq	r0, r0, r0, lsr #2
    1848:	00000b93 	muleq	r0, r3, fp
    184c:	000d5f24 	andeq	r5, sp, r4, lsr #30
    1850:	14c20200 	strbne	r0, [r2], #512	; 0x200
    1854:	0000082f 	andeq	r0, r0, pc, lsr #16
    1858:	24489102 	strbcs	r9, [r8], #-258	; 0xfffffefe
    185c:	00000c9b 	muleq	r0, fp, ip
    1860:	2f14c302 	svccs	0x0014c302
    1864:	02000008 	andeq	r0, r0, #8
    1868:	00214491 	mlaeq	r1, r1, r4, r4
    186c:	84000093 	strhi	r0, [r0], #-147	; 0xffffff6d
    1870:	7b000000 	blvc	1878 <shift+0x1878>
    1874:	2500000b 	strcs	r0, [r0, #-11]
    1878:	c5020069 	strgt	r0, [r2, #-105]	; 0xffffff97
    187c:	0000fc11 	andeq	pc, r0, r1, lsl ip	; <UNPREDICTABLE>
    1880:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    1884:	93841f00 	orrls	r1, r4, #0, 30
    1888:	005c0000 	subseq	r0, ip, r0
    188c:	6a250000 	bvs	941894 <__bss_end+0x935554>
    1890:	11c70200 	bicne	r0, r7, r0, lsl #4
    1894:	000000fc 	strdeq	r0, [r0], -ip
    1898:	00609102 	rsbeq	r9, r0, r2, lsl #2
    189c:	940c1f00 	strls	r1, [ip], #-3840	; 0xfffff100
    18a0:	00640000 	rsbeq	r0, r4, r0
    18a4:	78240000 	stmdavc	r4!, {}	; <UNPREDICTABLE>
    18a8:	0200000c 	andeq	r0, r0, #12
    18ac:	082f14cd 	stmdaeq	pc!, {r0, r2, r3, r6, r7, sl, ip}	; <UNPREDICTABLE>
    18b0:	91020000 	mrsls	r0, (UNDEF: 2)
    18b4:	94241f40 	strtls	r1, [r4], #-3904	; 0xfffff0c0
    18b8:	004c0000 	subeq	r0, ip, r0
    18bc:	69250000 	stmdbvs	r5!, {}	; <UNPREDICTABLE>
    18c0:	11cf0200 	bicne	r0, pc, r0, lsl #4
    18c4:	000000fc 	strdeq	r0, [r0], -ip
    18c8:	005c9102 	subseq	r9, ip, r2, lsl #2
    18cc:	f2280000 	vhadd.s32	d0, d8, d0
    18d0:	02000007 	andeq	r0, r0, #7
    18d4:	0bde08ac 	bleq	ff783b8c <__bss_end+0xff77784c>
    18d8:	91bc0000 			; <UNDEFINED> instruction: 0x91bc0000
    18dc:	00280000 	eoreq	r0, r8, r0
    18e0:	9c010000 	stcls	0, cr0, [r1], {-0}
    18e4:	00000beb 	andeq	r0, r0, fp, ror #23
    18e8:	000c861d 	andeq	r8, ip, sp, lsl r6
    18ec:	00083b00 	andeq	r3, r8, r0, lsl #22
    18f0:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    18f4:	07d22800 	ldrbeq	r2, [r2, r0, lsl #16]
    18f8:	a8020000 	stmdage	r2, {}	; <UNPREDICTABLE>
    18fc:	000c0506 	andeq	r0, ip, r6, lsl #10
    1900:	00918c00 	addseq	r8, r1, r0, lsl #24
    1904:	00003000 	andeq	r3, r0, r0
    1908:	219c0100 	orrscs	r0, ip, r0, lsl #2
    190c:	1d00000c 	stcne	0, cr0, [r0, #-48]	; 0xffffffd0
    1910:	00000c86 	andeq	r0, r0, r6, lsl #25
    1914:	0000083b 	andeq	r0, r0, fp, lsr r8
    1918:	26749102 	ldrbtcs	r9, [r4], -r2, lsl #2
    191c:	00726662 	rsbseq	r6, r2, r2, ror #12
    1920:	6d20a802 	stcvs	8, cr10, [r0, #-8]!
    1924:	02000004 	andeq	r0, r0, #4
    1928:	23007091 	movwcs	r7, #145	; 0x91
    192c:	0000073e 	andeq	r0, r0, lr, lsr r7
    1930:	3b06a002 	blcc	1a9940 <__bss_end+0x19d600>
    1934:	2000000c 	andcs	r0, r0, ip
    1938:	6c000091 	stcvs	0, cr0, [r0], {145}	; 0x91
    193c:	01000000 	mrseq	r0, (UNDEF: 0)
    1940:	000c559c 	muleq	ip, ip, r5
    1944:	0c861d00 	stceq	13, cr1, [r6], {0}
    1948:	083b0000 	ldmdaeq	fp!, {}	; <UNPREDICTABLE>
    194c:	91020000 	mrsls	r0, (UNDEF: 2)
    1950:	00792674 	rsbseq	r2, r9, r4, ror r6
    1954:	0923a002 	stmdbeq	r3!, {r1, sp, pc}
    1958:	02000001 	andeq	r0, r0, #1
    195c:	28007091 	stmdacs	r0, {r0, r4, r7, ip, sp, lr}
    1960:	000005a5 	andeq	r0, r0, r5, lsr #11
    1964:	6f069c02 	svcvs	0x00069c02
    1968:	e000000c 	and	r0, r0, ip
    196c:	40000090 	mulmi	r0, r0, r0
    1970:	01000000 	mrseq	r0, (UNDEF: 0)
    1974:	000c7c9c 	muleq	ip, ip, ip
    1978:	0c861d00 	stceq	13, cr1, [r6], {0}
    197c:	083b0000 	ldmdaeq	fp!, {}	; <UNPREDICTABLE>
    1980:	91020000 	mrsls	r0, (UNDEF: 2)
    1984:	e6230074 			; <UNDEFINED> instruction: 0xe6230074
    1988:	02000005 	andeq	r0, r0, #5
    198c:	0c96067e 	ldceq	6, cr0, [r6], {126}	; 0x7e
    1990:	8e640000 	cdphi	0, 6, cr0, cr4, cr0, {0}
    1994:	027c0000 	rsbseq	r0, ip, #0
    1998:	9c010000 	stcls	0, cr0, [r1], {-0}
    199c:	00000cec 	andeq	r0, r0, ip, ror #25
    19a0:	000c861d 	andeq	r8, ip, sp, lsl r6
    19a4:	00083b00 	andeq	r3, r8, r0, lsl #22
    19a8:	5c910200 	lfmpl	f0, 4, [r1], {0}
    19ac:	008e9421 	addeq	r9, lr, r1, lsr #8
    19b0:	0000f000 	andeq	pc, r0, r0
    19b4:	000cd400 	andeq	sp, ip, r0, lsl #8
    19b8:	00692500 	rsbeq	r2, r9, r0, lsl #10
    19bc:	fc0d8202 	stc2	2, cr8, [sp], {2}
    19c0:	02000000 	andeq	r0, r0, #0
    19c4:	181f6c91 	ldmdane	pc, {r0, r4, r7, sl, fp, sp, lr}	; <UNPREDICTABLE>
    19c8:	5c00008f 	stcpl	0, cr0, [r0], {143}	; 0x8f
    19cc:	25000000 	strcs	r0, [r0, #-0]
    19d0:	8902006a 	stmdbhi	r2, {r1, r3, r5, r6}
    19d4:	0000fc11 	andeq	pc, r0, r1, lsl ip	; <UNPREDICTABLE>
    19d8:	68910200 	ldmvs	r1, {r9}
    19dc:	801f0000 	andshi	r0, pc, r0
    19e0:	4c000090 	stcmi	0, cr0, [r0], {144}	; 0x90
    19e4:	25000000 	strcs	r0, [r0, #-0]
    19e8:	9602006a 	strls	r0, [r2], -sl, rrx
    19ec:	0000fc0d 	andeq	pc, r0, sp, lsl #24
    19f0:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    19f4:	61230000 			; <UNDEFINED> instruction: 0x61230000
    19f8:	02000007 	andeq	r0, r0, #7
    19fc:	0d060669 	stceq	6, cr0, [r6, #-420]	; 0xfffffe5c
    1a00:	8d0c0000 	stchi	0, cr0, [ip, #-0]
    1a04:	01580000 	cmpeq	r8, r0
    1a08:	9c010000 	stcls	0, cr0, [r1], {-0}
    1a0c:	00000d81 	andeq	r0, r0, r1, lsl #27
    1a10:	000c861d 	andeq	r8, ip, sp, lsl r6
    1a14:	00083b00 	andeq	r3, r8, r0, lsl #22
    1a18:	bc910300 	ldclt	3, cr0, [r1], {0}
    1a1c:	0d68247e 	cfstrdeq	mvd2, [r8, #-504]!	; 0xfffffe08
    1a20:	6b020000 	blvs	81a28 <__bss_end+0x756e8>
    1a24:	00045d0a 	andeq	r5, r4, sl, lsl #26
    1a28:	ec910300 	ldc	3, cr0, [r1], {0}
    1a2c:	0d47247e 	cfstrdeq	mvd2, [r7, #-504]	; 0xfffffe08
    1a30:	6c020000 	stcvs	0, cr0, [r2], {-0}
    1a34:	000d810a 	andeq	r8, sp, sl, lsl #2
    1a38:	d0910300 	addsle	r0, r1, r0, lsl #6
    1a3c:	0ce6247e 	cfstrdeq	mvd2, [r6], #504	; 0x1f8
    1a40:	6d020000 	stcvs	0, cr0, [r2, #-0]
    1a44:	000d970a 	andeq	r9, sp, sl, lsl #14
    1a48:	c4910300 	ldrgt	r0, [r1], #768	; 0x300
    1a4c:	6d74257e 	cfldr64vs	mvdx2, [r4, #-504]!	; 0xfffffe08
    1a50:	6e020070 	mcrvs	0, 0, r0, cr2, cr0, {3}
    1a54:	00082f10 	andeq	r2, r8, r0, lsl pc
    1a58:	70910200 	addsvc	r0, r1, r0, lsl #4
    1a5c:	008d7c1f 	addeq	r7, sp, pc, lsl ip
    1a60:	0000a400 	andeq	sl, r0, r0, lsl #8
    1a64:	00692500 	rsbeq	r2, r9, r0, lsl #10
    1a68:	fc0d7002 	stc2	0, cr7, [sp], {2}
    1a6c:	02000000 	andeq	r0, r0, #0
    1a70:	901f7491 	mulsls	pc, r1, r4	; <UNPREDICTABLE>
    1a74:	8000008d 	andhi	r0, r0, sp, lsl #1
    1a78:	25000000 	strcs	r0, [r0, #-0]
    1a7c:	71020066 	tstvc	r2, r6, rrx
    1a80:	0001090f 	andeq	r0, r1, pc, lsl #18
    1a84:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1a88:	17000000 	strne	r0, [r0, -r0]
    1a8c:	00000115 	andeq	r0, r0, r5, lsl r1
    1a90:	00000d97 	muleq	r0, r7, sp
    1a94:	00014718 	andeq	r4, r1, r8, lsl r7
    1a98:	47180400 	ldrmi	r0, [r8, -r0, lsl #8]
    1a9c:	04000001 	streq	r0, [r0], #-1
    1aa0:	01151700 	tsteq	r5, r0, lsl #14
    1aa4:	0da70000 	stceq	0, cr0, [r7]
    1aa8:	47180000 	ldrmi	r0, [r8, -r0]
    1aac:	09000001 	stmdbeq	r0, {r0}
    1ab0:	06892800 	streq	r2, [r9], r0, lsl #16
    1ab4:	60020000 	andvs	r0, r2, r0
    1ab8:	000dc106 	andeq	ip, sp, r6, lsl #2
    1abc:	008c2400 	addeq	r2, ip, r0, lsl #8
    1ac0:	0000e800 	andeq	lr, r0, r0, lsl #16
    1ac4:	0d9c0100 	ldfeqs	f0, [ip]
    1ac8:	1d00000e 	stcne	0, cr0, [r0, #-56]	; 0xffffffc8
    1acc:	00000c86 	andeq	r0, r0, r6, lsl #25
    1ad0:	0000083b 	andeq	r0, r0, fp, lsr r8
    1ad4:	266c9102 	strbtcs	r9, [ip], -r2, lsl #2
    1ad8:	60020074 	andvs	r0, r2, r4, ror r0
    1adc:	00082f22 	andeq	r2, r8, r2, lsr #30
    1ae0:	68910200 	ldmvs	r1, {r9}
    1ae4:	008c3821 	addeq	r3, ip, r1, lsr #16
    1ae8:	00005000 	andeq	r5, r0, r0
    1aec:	000df500 	andeq	pc, sp, r0, lsl #10
    1af0:	00692500 	rsbeq	r2, r9, r0, lsl #10
    1af4:	fc0d6102 	stc2	1, cr6, [sp], {2}
    1af8:	02000000 	andeq	r0, r0, #0
    1afc:	1f007491 	svcne	0x00007491
    1b00:	00008c88 	andeq	r8, r0, r8, lsl #25
    1b04:	00000060 	andeq	r0, r0, r0, rrx
    1b08:	02006925 	andeq	r6, r0, #606208	; 0x94000
    1b0c:	00fc0d63 	rscseq	r0, ip, r3, ror #26
    1b10:	91020000 	mrsls	r0, (UNDEF: 2)
    1b14:	23000070 	movwcs	r0, #112	; 0x70
    1b18:	00000600 	andeq	r0, r0, r0, lsl #12
    1b1c:	27065102 	strcs	r5, [r6, -r2, lsl #2]
    1b20:	2800000e 	stmdacs	r0, {r1, r2, r3}
    1b24:	fc00008b 	stc2	0, cr0, [r0], {139}	; 0x8b
    1b28:	01000000 	mrseq	r0, (UNDEF: 0)
    1b2c:	000e969c 	muleq	lr, ip, r6
    1b30:	0c861d00 	stceq	13, cr1, [r6], {0}
    1b34:	083b0000 	ldmdaeq	fp!, {}	; <UNPREDICTABLE>
    1b38:	91020000 	mrsls	r0, (UNDEF: 2)
    1b3c:	8b381f64 	blhi	e098d4 <__bss_end+0xdfd594>
    1b40:	00dc0000 	sbcseq	r0, ip, r0
    1b44:	69250000 	stmdbvs	r5!, {}	; <UNPREDICTABLE>
    1b48:	0d520200 	lfmeq	f0, 2, [r2, #-0]
    1b4c:	000000fc 	strdeq	r0, [r0], -ip
    1b50:	1f749102 	svcne	0x00749102
    1b54:	00008b54 	andeq	r8, r0, r4, asr fp
    1b58:	000000b0 	strheq	r0, [r0], -r0	; <UNPREDICTABLE>
    1b5c:	000c7c24 	andeq	r7, ip, r4, lsr #24
    1b60:	14530200 	ldrbne	r0, [r3], #-512	; 0xfffffe00
    1b64:	0000082f 	andeq	r0, r0, pc, lsr #16
    1b68:	21689102 	cmncs	r8, r2, lsl #2
    1b6c:	00008b70 	andeq	r8, r0, r0, ror fp
    1b70:	0000004c 	andeq	r0, r0, ip, asr #32
    1b74:	00000e7c 	andeq	r0, r0, ip, ror lr
    1b78:	02006a25 	andeq	r6, r0, #151552	; 0x25000
    1b7c:	00fc1155 	rscseq	r1, ip, r5, asr r1
    1b80:	91020000 	mrsls	r0, (UNDEF: 2)
    1b84:	bc1f0070 	ldclt	0, cr0, [pc], {112}	; 0x70
    1b88:	4800008b 	stmdami	r0, {r0, r1, r3, r7}
    1b8c:	25000000 	strcs	r0, [r0, #-0]
    1b90:	5a02006a 	bpl	81d40 <__bss_end+0x75a00>
    1b94:	0000fc11 	andeq	pc, r0, r1, lsl ip	; <UNPREDICTABLE>
    1b98:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1b9c:	00000000 	andeq	r0, r0, r0
    1ba0:	0005c323 	andeq	ip, r5, r3, lsr #6
    1ba4:	07300200 	ldreq	r0, [r0, -r0, lsl #4]!
    1ba8:	00000eb0 			; <UNDEFINED> instruction: 0x00000eb0
    1bac:	000089c0 	andeq	r8, r0, r0, asr #19
    1bb0:	00000168 	andeq	r0, r0, r8, ror #2
    1bb4:	0f379c01 	svceq	0x00379c01
    1bb8:	861d0000 	ldrhi	r0, [sp], -r0
    1bbc:	3b00000c 	blcc	1bf4 <shift+0x1bf4>
    1bc0:	02000008 	andeq	r0, r0, #8
    1bc4:	7c275491 	cfstrsvc	mvf5, [r7], #-580	; 0xfffffdbc
    1bc8:	0200000c 	andeq	r0, r0, #12
    1bcc:	082f2b30 	stmdaeq	pc!, {r4, r5, r8, r9, fp, sp}	; <UNPREDICTABLE>
    1bd0:	91020000 	mrsls	r0, (UNDEF: 2)
    1bd4:	0cf82450 	cfldrdeq	mvd2, [r8], #320	; 0x140
    1bd8:	32020000 	andcc	r0, r2, #0
    1bdc:	0000fc09 	andeq	pc, r0, r9, lsl #24
    1be0:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1be4:	000a5524 	andeq	r5, sl, r4, lsr #10
    1be8:	0b330200 	bleq	cc23f0 <__bss_end+0xcb60b0>
    1bec:	00000109 	andeq	r0, r0, r9, lsl #2
    1bf0:	24689102 	strbtcs	r9, [r8], #-258	; 0xfffffefe
    1bf4:	00000d5a 	andeq	r0, r0, sl, asr sp
    1bf8:	090b3402 	stmdbeq	fp, {r1, sl, ip, sp}
    1bfc:	02000001 	andeq	r0, r0, #1
    1c00:	69257491 	stmdbvs	r5!, {r0, r4, r7, sl, ip, sp, lr}
    1c04:	09350200 	ldmdbeq	r5!, {r9}
    1c08:	000000fc 	strdeq	r0, [r0], -ip
    1c0c:	29709102 	ldmdbcs	r0!, {r1, r8, ip, pc}^
    1c10:	00000020 	andeq	r0, r0, r0, lsr #32
    1c14:	000d1324 	andeq	r1, sp, r4, lsr #6
    1c18:	0f380200 	svceq	0x00380200
    1c1c:	00000109 	andeq	r0, r0, r9, lsl #2
    1c20:	24649102 	strbtcs	r9, [r4], #-258	; 0xfffffefe
    1c24:	00000c67 	andeq	r0, r0, r7, ror #24
    1c28:	fc0d3902 	stc2	9, cr3, [sp], {2}	; <UNPREDICTABLE>
    1c2c:	02000000 	andeq	r0, r0, #0
    1c30:	79256091 	stmdbvc	r5!, {r0, r4, r7, sp, lr}
    1c34:	0f3d0200 	svceq	0x003d0200
    1c38:	00000109 	andeq	r0, r0, r9, lsl #2
    1c3c:	005c9102 	subseq	r9, ip, r2, lsl #2
    1c40:	06a82300 	strteq	r2, [r8], r0, lsl #6
    1c44:	25020000 	strcs	r0, [r2, #-0]
    1c48:	000f5106 	andeq	r5, pc, r6, lsl #2
    1c4c:	00892c00 	addeq	r2, r9, r0, lsl #24
    1c50:	00009400 	andeq	r9, r0, r0, lsl #8
    1c54:	9d9c0100 	ldflss	f0, [ip]
    1c58:	1d00000f 	stcne	0, cr0, [r0, #-60]	; 0xffffffc4
    1c5c:	00000c86 	andeq	r0, r0, r6, lsl #25
    1c60:	0000083b 	andeq	r0, r0, fp, lsr r8
    1c64:	276c9102 	strbcs	r9, [ip, -r2, lsl #2]!
    1c68:	00000c7c 	andeq	r0, r0, ip, ror ip
    1c6c:	2f202502 	svccs	0x00202502
    1c70:	02000008 	andeq	r0, r0, #8
    1c74:	401f6891 	mulsmi	pc, r1, r8	; <UNPREDICTABLE>
    1c78:	74000089 	strvc	r0, [r0], #-137	; 0xffffff77
    1c7c:	25000000 	strcs	r0, [r0, #-0]
    1c80:	28020069 	stmdacs	r2, {r0, r3, r5, r6}
    1c84:	0000fc0d 	andeq	pc, r0, sp, lsl #24
    1c88:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1c8c:	00895c1f 	addeq	r5, r9, pc, lsl ip
    1c90:	00004800 	andeq	r4, r0, r0, lsl #16
    1c94:	0d082400 	cfstrseq	mvf2, [r8, #-0]
    1c98:	29020000 	stmdbcs	r2, {}	; <UNPREDICTABLE>
    1c9c:	0001090f 	andeq	r0, r1, pc, lsl #18
    1ca0:	70910200 	addsvc	r0, r1, r0, lsl #4
    1ca4:	23000000 	movwcs	r0, #0
    1ca8:	00000634 	andeq	r0, r0, r4, lsr r6
    1cac:	b7071702 	strlt	r1, [r7, -r2, lsl #14]
    1cb0:	7400000f 	strvc	r0, [r0], #-15
    1cb4:	b8000088 	stmdalt	r0, {r3, r7}
    1cb8:	01000000 	mrseq	r0, (UNDEF: 0)
    1cbc:	00103f9c 	mulseq	r0, ip, pc	; <UNPREDICTABLE>
    1cc0:	0c861d00 	stceq	13, cr1, [r6], {0}
    1cc4:	083b0000 	ldmdaeq	fp!, {}	; <UNPREDICTABLE>
    1cc8:	91020000 	mrsls	r0, (UNDEF: 2)
    1ccc:	04222754 	strteq	r2, [r2], #-1876	; 0xfffff8ac
    1cd0:	17020000 	strne	r0, [r2, -r0]
    1cd4:	0004be2a 	andeq	fp, r4, sl, lsr #28
    1cd8:	50910200 	addspl	r0, r1, r0, lsl #4
    1cdc:	02007926 	andeq	r7, r0, #622592	; 0x98000
    1ce0:	01093c17 	tsteq	r9, r7, lsl ip
    1ce4:	91020000 	mrsls	r0, (UNDEF: 2)
    1ce8:	0041254c 	subeq	r2, r1, ip, asr #10
    1cec:	090b1802 	stmdbeq	fp, {r1, fp, ip}
    1cf0:	02000001 	andeq	r0, r0, #1
    1cf4:	42257491 	eormi	r7, r5, #-1862270976	; 0x91000000
    1cf8:	0b190200 	bleq	642500 <__bss_end+0x6361c0>
    1cfc:	00000109 	andeq	r0, r0, r9, lsl #2
    1d00:	25709102 	ldrbcs	r9, [r0, #-258]!	; 0xfffffefe
    1d04:	1a020043 	bne	81e18 <__bss_end+0x75ad8>
    1d08:	0001090b 	andeq	r0, r1, fp, lsl #18
    1d0c:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1d10:	02004425 	andeq	r4, r0, #620756992	; 0x25000000
    1d14:	01090b1b 	tsteq	r9, fp, lsl fp
    1d18:	91020000 	mrsls	r0, (UNDEF: 2)
    1d1c:	00452568 	subeq	r2, r5, r8, ror #10
    1d20:	090b1c02 	stmdbeq	fp, {r1, sl, fp, ip}
    1d24:	02000001 	andeq	r0, r0, #1
    1d28:	62256491 	eorvs	r6, r5, #-1862270976	; 0x91000000
    1d2c:	0200745f 	andeq	r7, r0, #1593835520	; 0x5f000000
    1d30:	01090b1e 	tsteq	r9, lr, lsl fp
    1d34:	91020000 	mrsls	r0, (UNDEF: 2)
    1d38:	0d132460 	cfldrseq	mvf2, [r3, #-384]	; 0xfffffe80
    1d3c:	1f020000 	svcne	0x00020000
    1d40:	0001090b 	andeq	r0, r1, fp, lsl #18
    1d44:	5c910200 	lfmpl	f0, 4, [r1], {0}
    1d48:	065c2800 	ldrbeq	r2, [ip], -r0, lsl #16
    1d4c:	10020000 	andne	r0, r2, r0
    1d50:	00105907 	andseq	r5, r0, r7, lsl #18
    1d54:	0087fc00 	addeq	pc, r7, r0, lsl #24
    1d58:	00007800 	andeq	r7, r0, r0, lsl #16
    1d5c:	8d9c0100 	ldfhis	f0, [ip]
    1d60:	1d000010 	stcne	0, cr0, [r0, #-64]	; 0xffffffc0
    1d64:	00000c86 	andeq	r0, r0, r6, lsl #25
    1d68:	0000083b 	andeq	r0, r0, fp, lsr r8
    1d6c:	26749102 	ldrbtcs	r9, [r4], -r2, lsl #2
    1d70:	10020044 	andne	r0, r2, r4, asr #32
    1d74:	0001091b 	andeq	r0, r1, fp, lsl r9
    1d78:	70910200 	addsvc	r0, r1, r0, lsl #4
    1d7c:	02004526 	andeq	r4, r0, #159383552	; 0x9800000
    1d80:	01092410 	tsteq	r9, r0, lsl r4
    1d84:	91020000 	mrsls	r0, (UNDEF: 2)
    1d88:	0079266c 	rsbseq	r2, r9, ip, ror #12
    1d8c:	092d1002 	pusheq	{r1, ip}
    1d90:	02000001 	andeq	r0, r0, #1
    1d94:	2a006891 	bcs	1bfe0 <__bss_end+0xfca0>
    1d98:	00000795 	muleq	r0, r5, r7
    1d9c:	9e010302 	cdpls	3, 0, cr0, cr1, cr2, {0}
    1da0:	00000010 	andeq	r0, r0, r0, lsl r0
    1da4:	000010f0 	strdeq	r1, [r0], -r0
    1da8:	000c862b 	andeq	r8, ip, fp, lsr #12
    1dac:	00083b00 	andeq	r3, r8, r0, lsl #22
    1db0:	0bfe2c00 	bleq	fff8cdb8 <__bss_end+0xfff80a78>
    1db4:	03020000 	movweq	r0, #8192	; 0x2000
    1db8:	0000fc12 	andeq	pc, r0, r2, lsl ip	; <UNPREDICTABLE>
    1dbc:	0baf2c00 	bleq	febccdc4 <__bss_end+0xfebc0a84>
    1dc0:	03020000 	movweq	r0, #8192	; 0x2000
    1dc4:	0000fc1f 	andeq	pc, r0, pc, lsl ip	; <UNPREDICTABLE>
    1dc8:	08dc2c00 	ldmeq	ip, {sl, fp, sp}^
    1dcc:	03020000 	movweq	r0, #8192	; 0x2000
    1dd0:	0000fc2a 	andeq	pc, r0, sl, lsr #24
    1dd4:	06bc2c00 	ldrteq	r2, [ip], r0, lsl #24
    1dd8:	03020000 	movweq	r0, #8192	; 0x2000
    1ddc:	0000fc40 	andeq	pc, r0, r0, asr #24
    1de0:	07402c00 	strbeq	r2, [r0, -r0, lsl #24]
    1de4:	03020000 	movweq	r0, #8192	; 0x2000
    1de8:	0000fc51 	andeq	pc, r0, r1, asr ip	; <UNPREDICTABLE>
    1dec:	66622d00 	strbtvs	r2, [r2], -r0, lsl #26
    1df0:	03020072 	movweq	r0, #8306	; 0x2072
    1df4:	00046d65 	andeq	r6, r4, r5, ror #26
    1df8:	8d2e0000 	stchi	0, cr0, [lr, #-0]
    1dfc:	2d000010 	stccs	0, cr0, [r0, #-64]	; 0xffffffc0
    1e00:	0b00000d 	bleq	1e3c <shift+0x1e3c>
    1e04:	10000011 	andne	r0, r0, r1, lsl r0
    1e08:	ec000087 	stc	0, cr0, [r0], {135}	; 0x87
    1e0c:	01000000 	mrseq	r0, (UNDEF: 0)
    1e10:	0011449c 	mulseq	r1, ip, r4
    1e14:	109e2f00 	addsne	r2, lr, r0, lsl #30
    1e18:	91020000 	mrsls	r0, (UNDEF: 2)
    1e1c:	10a72f74 	adcne	r2, r7, r4, ror pc
    1e20:	91020000 	mrsls	r0, (UNDEF: 2)
    1e24:	10b32f70 	adcsne	r2, r3, r0, ror pc
    1e28:	91020000 	mrsls	r0, (UNDEF: 2)
    1e2c:	10bf2f6c 	adcsne	r2, pc, ip, ror #30
    1e30:	91020000 	mrsls	r0, (UNDEF: 2)
    1e34:	10cb2f68 	sbcne	r2, fp, r8, ror #30
    1e38:	91020000 	mrsls	r0, (UNDEF: 2)
    1e3c:	10d72f00 	sbcsne	r2, r7, r0, lsl #30
    1e40:	91020000 	mrsls	r0, (UNDEF: 2)
    1e44:	10e32f04 	rscne	r2, r3, r4, lsl #30
    1e48:	91020000 	mrsls	r0, (UNDEF: 2)
    1e4c:	4c300008 	ldcmi	0, cr0, [r0], #-32	; 0xffffffe0
    1e50:	0100000c 	tsteq	r0, ip
    1e54:	0d840e12 	stceq	14, cr0, [r4, #72]	; 0x48
    1e58:	02020000 	andeq	r0, r2, #0
    1e5c:	9b480000 	blls	1201e64 <__bss_end+0x11f5b24>
    1e60:	00300000 	eorseq	r0, r0, r0
    1e64:	9c010000 	stcls	0, cr0, [r1], {-0}
    1e68:	00001172 	andeq	r1, r0, r2, ror r1
    1e6c:	00160027 	andseq	r0, r6, r7, lsr #32
    1e70:	1e120100 	mufnes	f0, f2, f0
    1e74:	00000136 	andeq	r0, r0, r6, lsr r1
    1e78:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1e7c:	00041230 	andeq	r1, r4, r0, lsr r2
    1e80:	0e0d0100 	adfeqe	f0, f5, f0
    1e84:	00000360 	andeq	r0, r0, r0, ror #6
    1e88:	00000202 	andeq	r0, r0, r2, lsl #4
    1e8c:	000086e0 	andeq	r8, r0, r0, ror #13
    1e90:	00000030 	andeq	r0, r0, r0, lsr r0
    1e94:	11a09c01 	lslne	r9, r1, #24
    1e98:	00270000 	eoreq	r0, r7, r0
    1e9c:	01000016 	tsteq	r0, r6, lsl r0
    1ea0:	0136260d 	teqeq	r6, sp, lsl #12
    1ea4:	91020000 	mrsls	r0, (UNDEF: 2)
    1ea8:	11310074 	teqne	r1, r4, ror r0
    1eac:	0100000c 	tsteq	r0, ip
    1eb0:	05370e05 	ldreq	r0, [r7, #-3589]!	; 0xfffff1fb
    1eb4:	02020000 	andeq	r0, r2, #0
    1eb8:	86b00000 	ldrthi	r0, [r0], r0
    1ebc:	00300000 	eorseq	r0, r0, r0
    1ec0:	9c010000 	stcls	0, cr0, [r1], {-0}
    1ec4:	00160027 	andseq	r0, r6, r7, lsr #32
    1ec8:	24050100 	strcs	r0, [r5], #-256	; 0xffffff00
    1ecc:	00000136 	andeq	r0, r0, r6, lsr r1
    1ed0:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1ed4:	00027600 	andeq	r7, r2, r0, lsl #12
    1ed8:	dc000400 	cfstrsle	mvf0, [r0], {-0}
    1edc:	04000007 	streq	r0, [r0], #-7
    1ee0:	00025e01 	andeq	r5, r2, r1, lsl #28
    1ee4:	0d940400 	cfldrseq	mvf0, [r4]
    1ee8:	002a0000 	eoreq	r0, sl, r0
    1eec:	9b780000 	blls	1e01ef4 <__bss_end+0x1df5bb4>
    1ef0:	02700000 	rsbseq	r0, r0, #0
    1ef4:	0ecb0000 	cdpeq	0, 12, cr0, cr11, cr0, {0}
    1ef8:	04020000 	streq	r0, [r2], #-0
    1efc:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
    1f00:	04040300 	streq	r0, [r4], #-768	; 0xfffffd00
    1f04:	00001cea 	andeq	r1, r0, sl, ror #25
    1f08:	a8080103 	stmdage	r8, {r0, r1, r8}
    1f0c:	03000008 	movweq	r0, #8
    1f10:	09210502 	stmdbeq	r1!, {r1, r8, sl}
    1f14:	01030000 	mrseq	r0, (UNDEF: 3)
    1f18:	00089f08 	andeq	r9, r8, r8, lsl #30
    1f1c:	07020300 	streq	r0, [r2, -r0, lsl #6]
    1f20:	00000698 	muleq	r0, r8, r6
    1f24:	0009c704 	andeq	ip, r9, r4, lsl #14
    1f28:	07090700 	streq	r0, [r9, -r0, lsl #14]
    1f2c:	00000060 	andeq	r0, r0, r0, rrx
    1f30:	00004f05 	andeq	r4, r0, r5, lsl #30
    1f34:	07040300 	streq	r0, [r4, -r0, lsl #6]
    1f38:	00001fe3 	andeq	r1, r0, r3, ror #31
    1f3c:	00078306 	andeq	r8, r7, r6, lsl #6
    1f40:	14050200 	strne	r0, [r5], #-512	; 0xfffffe00
    1f44:	0000005b 	andeq	r0, r0, fp, asr r0
    1f48:	c24c0305 	subgt	r0, ip, #335544320	; 0x14000000
    1f4c:	10060000 	andne	r0, r6, r0
    1f50:	02000008 	andeq	r0, r0, #8
    1f54:	005b1406 	subseq	r1, fp, r6, lsl #8
    1f58:	03050000 	movweq	r0, #20480	; 0x5000
    1f5c:	0000c250 	andeq	ip, r0, r0, asr r2
    1f60:	00074c06 	andeq	r4, r7, r6, lsl #24
    1f64:	1a070300 	bne	1c2b6c <__bss_end+0x1b682c>
    1f68:	0000005b 	andeq	r0, r0, fp, asr r0
    1f6c:	c2540305 	subsgt	r0, r4, #335544320	; 0x14000000
    1f70:	cf060000 	svcgt	0x00060000
    1f74:	03000004 	movweq	r0, #4
    1f78:	005b1a09 	subseq	r1, fp, r9, lsl #20
    1f7c:	03050000 	movweq	r0, #20480	; 0x5000
    1f80:	0000c258 	andeq	ip, r0, r8, asr r2
    1f84:	00087406 	andeq	r7, r8, r6, lsl #8
    1f88:	1a0b0300 	bne	2c2b90 <__bss_end+0x2b6850>
    1f8c:	0000005b 	andeq	r0, r0, fp, asr r0
    1f90:	c25c0305 	subsgt	r0, ip, #335544320	; 0x14000000
    1f94:	85060000 	strhi	r0, [r6, #-0]
    1f98:	03000006 	movweq	r0, #6
    1f9c:	005b1a0d 	subseq	r1, fp, sp, lsl #20
    1fa0:	03050000 	movweq	r0, #20480	; 0x5000
    1fa4:	0000c260 	andeq	ip, r0, r0, ror #4
    1fa8:	00055206 	andeq	r5, r5, r6, lsl #4
    1fac:	1a0f0300 	bne	3c2bb4 <__bss_end+0x3b6874>
    1fb0:	0000005b 	andeq	r0, r0, fp, asr r0
    1fb4:	c2640305 	rsbgt	r0, r4, #335544320	; 0x14000000
    1fb8:	01030000 	mrseq	r0, (UNDEF: 3)
    1fbc:	0006e402 	andeq	lr, r6, r2, lsl #8
    1fc0:	05ce0600 	strbeq	r0, [lr, #1536]	; 0x600
    1fc4:	04040000 	streq	r0, [r4], #-0
    1fc8:	00005b14 	andeq	r5, r0, r4, lsl fp
    1fcc:	68030500 	stmdavs	r3, {r8, sl}
    1fd0:	060000c2 	streq	r0, [r0], -r2, asr #1
    1fd4:	00000337 	andeq	r0, r0, r7, lsr r3
    1fd8:	5b140704 	blpl	503bf0 <__bss_end+0x4f78b0>
    1fdc:	05000000 	streq	r0, [r0, #-0]
    1fe0:	00c26c03 	sbceq	r6, r2, r3, lsl #24
    1fe4:	05240600 	streq	r0, [r4, #-1536]!	; 0xfffffa00
    1fe8:	0a040000 	beq	101ff0 <__bss_end+0xf5cb0>
    1fec:	00005b14 	andeq	r5, r0, r4, lsl fp
    1ff0:	70030500 	andvc	r0, r3, r0, lsl #10
    1ff4:	030000c2 	movweq	r0, #194	; 0xc2
    1ff8:	1fde0704 	svcne	0x00de0704
    1ffc:	33060000 	movwcc	r0, #24576	; 0x6000
    2000:	0500000b 	streq	r0, [r0, #-11]
    2004:	005b140a 	subseq	r1, fp, sl, lsl #8
    2008:	03050000 	movweq	r0, #20480	; 0x5000
    200c:	0000c274 	andeq	ip, r0, r4, ror r2
    2010:	00063c07 	andeq	r3, r6, r7, lsl #24
    2014:	0f061c00 	svceq	0x00061c00
    2018:	00017008 	andeq	r7, r1, r8
    201c:	04220800 	strteq	r0, [r2], #-2048	; 0xfffff800
    2020:	11060000 	mrsne	r0, (UNDEF: 6)
    2024:	0001700b 	andeq	r7, r1, fp
    2028:	55080000 	strpl	r0, [r8, #-0]
    202c:	0600000a 	streq	r0, [r0], -sl
    2030:	002c0b13 	eoreq	r0, ip, r3, lsl fp
    2034:	08140000 	ldmdaeq	r4, {}	; <UNPREDICTABLE>
    2038:	00000342 	andeq	r0, r0, r2, asr #6
    203c:	800c1506 	andhi	r1, ip, r6, lsl #10
    2040:	18000001 	stmdane	r0, {r0}
    2044:	002c0900 	eoreq	r0, ip, r0, lsl #18
    2048:	01800000 	orreq	r0, r0, r0
    204c:	600a0000 	andvs	r0, sl, r0
    2050:	04000000 	streq	r0, [r0], #-0
    2054:	2c040b00 			; <UNDEFINED> instruction: 0x2c040b00
    2058:	0b000000 	bleq	2060 <shift+0x2060>
    205c:	00018c04 	andeq	r8, r1, r4, lsl #24
    2060:	3b040b00 	blcc	104c68 <__bss_end+0xf8928>
    2064:	0c000001 	stceq	0, cr0, [r0], {1}
    2068:	00000df7 	strdeq	r0, [r0], -r7
    206c:	c6062c01 	strgt	r2, [r6], -r1, lsl #24
    2070:	b000000d 	andlt	r0, r0, sp
    2074:	3800009d 	stmdacc	r0, {r0, r2, r3, r4, r7}
    2078:	01000000 	mrseq	r0, (UNDEF: 0)
    207c:	0001cb9c 	muleq	r1, ip, fp
    2080:	0c7c0d00 	ldcleq	13, cr0, [ip], #-0
    2084:	2c010000 	stccs	0, cr0, [r1], {-0}
    2088:	00018621 	andeq	r8, r1, r1, lsr #12
    208c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    2090:	6e656c0e 	cdpvs	12, 6, cr6, cr5, cr14, {0}
    2094:	312c0100 			; <UNDEFINED> instruction: 0x312c0100
    2098:	00000025 	andeq	r0, r0, r5, lsr #32
    209c:	00709102 	rsbseq	r9, r0, r2, lsl #2
    20a0:	000de60c 	andeq	lr, sp, ip, lsl #12
    20a4:	06200100 	strteq	r0, [r0], -r0, lsl #2
    20a8:	00000e06 	andeq	r0, r0, r6, lsl #28
    20ac:	00009d34 	andeq	r9, r0, r4, lsr sp
    20b0:	0000007c 	andeq	r0, r0, ip, ror r0
    20b4:	02229c01 	eoreq	r9, r2, #256	; 0x100
    20b8:	7c0d0000 	stcvc	0, cr0, [sp], {-0}
    20bc:	0100000c 	tsteq	r0, ip
    20c0:	01861720 	orreq	r1, r6, r0, lsr #14
    20c4:	91020000 	mrsls	r0, (UNDEF: 2)
    20c8:	19990d6c 	ldmibne	r9, {r2, r3, r5, r6, r8, sl, fp}
    20cc:	20010000 	andcs	r0, r1, r0
    20d0:	00002527 	andeq	r2, r0, r7, lsr #10
    20d4:	68910200 	ldmvs	r1, {r9}
    20d8:	646e650e 	strbtvs	r6, [lr], #-1294	; 0xfffffaf2
    20dc:	33200100 	nopcc	{0}	; <UNPREDICTABLE>
    20e0:	00000025 	andeq	r0, r0, r5, lsr #32
    20e4:	0f649102 	svceq	0x00649102
    20e8:	00000c67 	andeq	r0, r0, r7, ror #24
    20ec:	25092301 	strcs	r2, [r9, #-769]	; 0xfffffcff
    20f0:	02000000 	andeq	r0, r0, #0
    20f4:	10007491 	mulne	r0, r1, r4
    20f8:	00000df1 	strdeq	r0, [r0], -r1
    20fc:	22050401 	andcs	r0, r5, #16777216	; 0x1000000
    2100:	2500000e 	strcs	r0, [r0, #-14]
    2104:	78000000 	stmdavc	r0, {}	; <UNPREDICTABLE>
    2108:	bc00009b 	stclt	0, cr0, [r0], {155}	; 0x9b
    210c:	01000001 	tsteq	r0, r1
    2110:	0c7c0d9c 	ldcleq	13, cr0, [ip], #-624	; 0xfffffd90
    2114:	04010000 	streq	r0, [r1], #-0
    2118:	00018617 	andeq	r8, r1, r7, lsl r6
    211c:	6c910200 	lfmvs	f0, 4, [r1], {0}
    2120:	000d8f0d 	andeq	r8, sp, sp, lsl #30
    2124:	27040100 	strcs	r0, [r4, -r0, lsl #2]
    2128:	00000025 	andeq	r0, r0, r5, lsr #32
    212c:	0d689102 	stfeqp	f1, [r8, #-8]!
    2130:	00000deb 	andeq	r0, r0, fp, ror #27
    2134:	25320401 	ldrcs	r0, [r2, #-1025]!	; 0xfffffbff
    2138:	02000000 	andeq	r0, r0, #0
    213c:	1c0f6491 	cfstrsne	mvf6, [pc], {145}	; 0x91
    2140:	0100000e 	tsteq	r0, lr
    2144:	018c1005 	orreq	r1, ip, r5
    2148:	91020000 	mrsls	r0, (UNDEF: 2)
    214c:	4d000074 	stcmi	0, cr0, [r0, #-464]	; 0xfffffe30
    2150:	04000002 	streq	r0, [r0], #-2
    2154:	0008d700 	andeq	sp, r8, r0, lsl #14
    2158:	dc010400 	cfstrsle	mvf0, [r1], {-0}
    215c:	0400000e 	streq	r0, [r0], #-14
    2160:	00000e98 	muleq	r0, r8, lr
    2164:	00000e79 	andeq	r0, r0, r9, ror lr
    2168:	00009de8 	andeq	r9, r0, r8, ror #27
    216c:	000001d4 	ldrdeq	r0, [r0], -r4
    2170:	0000110d 	andeq	r1, r0, sp, lsl #2
    2174:	a8080102 	stmdage	r8, {r1, r8}
    2178:	02000008 	andeq	r0, r0, #8
    217c:	09210502 	stmdbeq	r1!, {r1, r8, sl}
    2180:	04030000 	streq	r0, [r3], #-0
    2184:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
    2188:	08010200 	stmdaeq	r1, {r9}
    218c:	0000089f 	muleq	r0, pc, r8	; <UNPREDICTABLE>
    2190:	98070202 	stmdals	r7, {r1, r9}
    2194:	04000006 	streq	r0, [r0], #-6
    2198:	000009c7 	andeq	r0, r0, r7, asr #19
    219c:	54070903 	strpl	r0, [r7], #-2307	; 0xfffff6fd
    21a0:	02000000 	andeq	r0, r0, #0
    21a4:	1fe30704 	svcne	0x00e30704
    21a8:	c1050000 	mrsgt	r0, (UNDEF: 5)
    21ac:	0c000005 	stceq	0, cr0, [r0], {5}
    21b0:	09070302 	stmdbeq	r7, {r1, r8, r9}
    21b4:	06000001 	streq	r0, [r0], -r1
    21b8:	00000b61 	andeq	r0, r0, r1, ror #22
    21bc:	480e0602 	stmdami	lr, {r1, r9, sl}
    21c0:	00000000 	andeq	r0, r0, r0
    21c4:	0009bd06 	andeq	fp, r9, r6, lsl #26
    21c8:	0e080200 	cdpeq	2, 0, cr0, cr8, cr0, {0}
    21cc:	00000048 	andeq	r0, r0, r8, asr #32
    21d0:	083f0604 	ldmdaeq	pc!, {r2, r9, sl}	; <UNPREDICTABLE>
    21d4:	0b020000 	bleq	821dc <__bss_end+0x75e9c>
    21d8:	0000480e 	andeq	r4, r0, lr, lsl #16
    21dc:	c1070800 	tstgt	r7, r0, lsl #16
    21e0:	02000005 	andeq	r0, r0, #5
    21e4:	0967050d 	stmdbeq	r7!, {r0, r2, r3, r8, sl}^
    21e8:	01090000 	mrseq	r0, (UNDEF: 9)
    21ec:	a8010000 	stmdage	r1, {}	; <UNPREDICTABLE>
    21f0:	ae000000 	cdpge	0, 0, cr0, cr0, cr0, {0}
    21f4:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    21f8:	00000109 	andeq	r0, r0, r9, lsl #2
    21fc:	0a930900 	beq	fe4c4604 <__bss_end+0xfe4b82c4>
    2200:	0e020000 	cdpeq	0, 0, cr0, cr2, cr0, {0}
    2204:	0006e90a 	andeq	lr, r6, sl, lsl #18
    2208:	00c30100 	sbceq	r0, r3, r0, lsl #2
    220c:	00c90000 	sbceq	r0, r9, r0
    2210:	09080000 	stmdbeq	r8, {}	; <UNPREDICTABLE>
    2214:	00000001 	andeq	r0, r0, r1
    2218:	00095807 	andeq	r5, r9, r7, lsl #16
    221c:	0b0f0200 	bleq	3c2a24 <__bss_end+0x3b66e4>
    2220:	0000055c 	andeq	r0, r0, ip, asr r5
    2224:	00000114 	andeq	r0, r0, r4, lsl r1
    2228:	0000e201 	andeq	lr, r0, r1, lsl #4
    222c:	0000ed00 	andeq	lr, r0, r0, lsl #26
    2230:	01090800 	tsteq	r9, r0, lsl #16
    2234:	480a0000 	stmdami	sl, {}	; <UNPREDICTABLE>
    2238:	00000000 	andeq	r0, r0, r0
    223c:	000a830b 	andeq	r8, sl, fp, lsl #6
    2240:	0e100200 	cdpeq	2, 1, cr0, cr0, cr0, {0}
    2244:	000008ed 	andeq	r0, r0, sp, ror #17
    2248:	00000048 	andeq	r0, r0, r8, asr #32
    224c:	00010201 	andeq	r0, r1, r1, lsl #4
    2250:	01090800 	tsteq	r9, r0, lsl #16
    2254:	00000000 	andeq	r0, r0, r0
    2258:	005b040c 	subseq	r0, fp, ip, lsl #8
    225c:	090d0000 	stmdbeq	sp, {}	; <UNPREDICTABLE>
    2260:	0e000001 	cdpeq	0, 0, cr0, cr0, cr1, {0}
    2264:	00680f04 	rsbeq	r0, r8, r4, lsl #30
    2268:	5b151202 	blpl	546a78 <__bss_end+0x53a738>
    226c:	10000000 	andne	r0, r0, r0
    2270:	00000116 	andeq	r0, r0, r6, lsl r1
    2274:	050e0301 	streq	r0, [lr, #-769]	; 0xfffffcff
    2278:	00c32403 	sbceq	r2, r3, r3, lsl #8
    227c:	0f9e1100 	svceq	0x009e1100
    2280:	9fa00000 	svcls	0x00a00000
    2284:	001c0000 	andseq	r0, ip, r0
    2288:	9c010000 	stcls	0, cr0, [r1], {-0}
    228c:	000e3912 	andeq	r3, lr, r2, lsl r9
    2290:	009f5400 	addseq	r5, pc, r0, lsl #8
    2294:	00004c00 	andeq	r4, r0, r0, lsl #24
    2298:	6f9c0100 	svcvs	0x009c0100
    229c:	13000001 	movwne	r0, #1
    22a0:	00000ecd 	andeq	r0, r0, sp, asr #29
    22a4:	33012601 	movwcc	r2, #5633	; 0x1601
    22a8:	02000000 	andeq	r0, r0, #0
    22ac:	93137491 	tstls	r3, #-1862270976	; 0x91000000
    22b0:	0100000f 	tsteq	r0, pc
    22b4:	00330126 	eorseq	r0, r3, r6, lsr #2
    22b8:	91020000 	mrsls	r0, (UNDEF: 2)
    22bc:	c9140070 	ldmdbgt	r4, {r4, r5, r6}
    22c0:	01000000 	mrseq	r0, (UNDEF: 0)
    22c4:	0114071f 	tsteq	r4, pc, lsl r7
    22c8:	018d0000 	orreq	r0, sp, r0
    22cc:	9ee00000 	cdpls	0, 14, cr0, cr0, cr0, {0}
    22d0:	00740000 	rsbseq	r0, r4, r0
    22d4:	9c010000 	stcls	0, cr0, [r1], {-0}
    22d8:	000001b8 			; <UNDEFINED> instruction: 0x000001b8
    22dc:	000c8615 	andeq	r8, ip, r5, lsl r6
    22e0:	00010f00 	andeq	r0, r1, r0, lsl #30
    22e4:	6c910200 	lfmvs	f0, 4, [r1], {0}
    22e8:	00160013 	andseq	r0, r6, r3, lsl r0
    22ec:	241f0100 	ldrcs	r0, [pc], #-256	; 22f4 <shift+0x22f4>
    22f0:	00000048 	andeq	r0, r0, r8, asr #32
    22f4:	16689102 	strbtne	r9, [r8], -r2, lsl #2
    22f8:	00000b65 	andeq	r0, r0, r5, ror #22
    22fc:	480e2301 	stmdami	lr, {r0, r8, r9, sp}
    2300:	02000000 	andeq	r0, r0, #0
    2304:	17007491 			; <UNDEFINED> instruction: 0x17007491
    2308:	000000ed 	andeq	r0, r0, sp, ror #1
    230c:	d20a1b01 	andle	r1, sl, #1024	; 0x400
    2310:	b8000001 	stmdalt	r0, {r0}
    2314:	2800009e 	stmdacs	r0, {r1, r2, r3, r4, r7}
    2318:	01000000 	mrseq	r0, (UNDEF: 0)
    231c:	0001df9c 	muleq	r1, ip, pc	; <UNPREDICTABLE>
    2320:	0c861500 	cfstr32eq	mvfx1, [r6], {0}
    2324:	010f0000 	mrseq	r0, CPSR
    2328:	91020000 	mrsls	r0, (UNDEF: 2)
    232c:	ae170074 	mrcge	0, 0, r0, cr7, cr4, {3}
    2330:	01000000 	mrseq	r0, (UNDEF: 0)
    2334:	01f90609 	mvnseq	r0, r9, lsl #12
    2338:	9e300000 	cdpls	0, 3, cr0, cr0, cr0, {0}
    233c:	00880000 	addeq	r0, r8, r0
    2340:	9c010000 	stcls	0, cr0, [r1], {-0}
    2344:	00000215 	andeq	r0, r0, r5, lsl r2
    2348:	000c8615 	andeq	r8, ip, r5, lsl r6
    234c:	00010f00 	andeq	r0, r1, r0, lsl #30
    2350:	6c910200 	lfmvs	f0, 4, [r1], {0}
    2354:	000f8d16 	andeq	r8, pc, r6, lsl sp	; <UNPREDICTABLE>
    2358:	0e0b0100 	adfeqe	f0, f3, f0
    235c:	00000048 	andeq	r0, r0, r8, asr #32
    2360:	00749102 	rsbseq	r9, r4, r2, lsl #2
    2364:	00008f18 	andeq	r8, r0, r8, lsl pc
    2368:	01070100 	mrseq	r0, (UNDEF: 23)
    236c:	00000226 	andeq	r0, r0, r6, lsr #4
    2370:	00023000 	andeq	r3, r2, r0
    2374:	0c861900 			; <UNDEFINED> instruction: 0x0c861900
    2378:	010f0000 	mrseq	r0, CPSR
    237c:	1a000000 	bne	2384 <shift+0x2384>
    2380:	00000215 	andeq	r0, r0, r5, lsl r2
    2384:	00000e63 	andeq	r0, r0, r3, ror #28
    2388:	00000247 	andeq	r0, r0, r7, asr #4
    238c:	00009de8 	andeq	r9, r0, r8, ror #27
    2390:	00000048 	andeq	r0, r0, r8, asr #32
    2394:	261b9c01 	ldrcs	r9, [fp], -r1, lsl #24
    2398:	02000002 	andeq	r0, r0, #2
    239c:	00007491 	muleq	r0, r1, r4
    23a0:	00000237 	andeq	r0, r0, r7, lsr r2
    23a4:	0a8e0004 	beq	fe3823bc <__bss_end+0xfe37607c>
    23a8:	01040000 	mrseq	r0, (UNDEF: 4)
    23ac:	00000edc 	ldrdeq	r0, [r0], -ip
    23b0:	000fe404 	andeq	lr, pc, r4, lsl #8
    23b4:	000e7900 	andeq	r7, lr, r0, lsl #18
    23b8:	009fc000 	addseq	ip, pc, r0
    23bc:	00016000 	andeq	r6, r1, r0
    23c0:	00126000 	andseq	r6, r2, r0
    23c4:	0bb60200 	bleq	fed82bcc <__bss_end+0xfed7688c>
    23c8:	021c0000 	andseq	r0, ip, #0
    23cc:	00fc0703 	rscseq	r0, ip, r3, lsl #14
    23d0:	61030000 	mrsvs	r0, (UNDEF: 3)
    23d4:	09050200 	stmdbeq	r5, {r9}
    23d8:	000000fc 	strdeq	r0, [r0], -ip
    23dc:	00630300 	rsbeq	r0, r3, r0, lsl #6
    23e0:	fc090602 	stc2	6, cr0, [r9], {2}
    23e4:	04000000 	streq	r0, [r0], #-0
    23e8:	6e696d03 	cdpvs	13, 6, cr6, cr9, cr3, {0}
    23ec:	09070200 	stmdbeq	r7, {r9}
    23f0:	000000fc 	strdeq	r0, [r0], -ip
    23f4:	616d0308 	cmnvs	sp, r8, lsl #6
    23f8:	08020078 	stmdaeq	r2, {r3, r4, r5, r6}
    23fc:	0000fc09 	andeq	pc, r0, r9, lsl #24
    2400:	46040c00 	strmi	r0, [r4], -r0, lsl #24
    2404:	02000006 	andeq	r0, r0, #6
    2408:	00fc0909 	rscseq	r0, ip, r9, lsl #18
    240c:	04100000 	ldreq	r0, [r0], #-0
    2410:	00000725 	andeq	r0, r0, r5, lsr #14
    2414:	fc090b02 	stc2	11, cr0, [r9], {2}	; <UNPREDICTABLE>
    2418:	14000000 	strne	r0, [r0], #-0
    241c:	000a4004 	andeq	r4, sl, r4
    2420:	090c0200 	stmdbeq	ip, {r9}
    2424:	000000fc 	strdeq	r0, [r0], -ip
    2428:	0bb60518 	bleq	fed83890 <__bss_end+0xfed77550>
    242c:	10020000 	andne	r0, r2, r0
    2430:	0007ab05 	andeq	sl, r7, r5, lsl #22
    2434:	00010300 	andeq	r0, r1, r0, lsl #6
    2438:	00a20100 	adceq	r0, r2, r0, lsl #2
    243c:	00c10000 	sbceq	r0, r1, r0
    2440:	03060000 	movweq	r0, #24576	; 0x6000
    2444:	07000001 	streq	r0, [r0, -r1]
    2448:	000000fc 	strdeq	r0, [r0], -ip
    244c:	0000fc07 	andeq	pc, r0, r7, lsl #24
    2450:	00fc0700 	rscseq	r0, ip, r0, lsl #14
    2454:	fc070000 	stc2	0, cr0, [r7], {-0}
    2458:	07000000 	streq	r0, [r0, -r0]
    245c:	000000fc 	strdeq	r0, [r0], -ip
    2460:	04f20500 	ldrbteq	r0, [r2], #1280	; 0x500
    2464:	11020000 	mrsne	r0, (UNDEF: 2)
    2468:	0003ea09 	andeq	lr, r3, r9, lsl #20
    246c:	0000fc00 	andeq	pc, r0, r0, lsl #24
    2470:	00da0100 	sbcseq	r0, sl, r0, lsl #2
    2474:	00e00000 	rsceq	r0, r0, r0
    2478:	03060000 	movweq	r0, #24576	; 0x6000
    247c:	00000001 	andeq	r0, r0, r1
    2480:	0003e008 	andeq	lr, r3, r8
    2484:	0b130200 	bleq	4c2c8c <__bss_end+0x4b694c>
    2488:	0000099b 	muleq	r0, fp, r9
    248c:	0000010e 	andeq	r0, r0, lr, lsl #2
    2490:	0000f501 	andeq	pc, r0, r1, lsl #10
    2494:	01030600 	tsteq	r3, r0, lsl #12
    2498:	00000000 	andeq	r0, r0, r0
    249c:	69050409 	stmdbvs	r5, {r0, r3, sl}
    24a0:	0a00746e 	beq	1f660 <__bss_end+0x13320>
    24a4:	00002504 	andeq	r2, r0, r4, lsl #10
    24a8:	01030b00 	tsteq	r3, r0, lsl #22
    24ac:	040c0000 	streq	r0, [ip], #-0
    24b0:	001cea04 	andseq	lr, ip, r4, lsl #20
    24b4:	00e00d00 	rsceq	r0, r0, r0, lsl #26
    24b8:	17010000 	strne	r0, [r1, -r0]
    24bc:	00012f07 	andeq	r2, r1, r7, lsl #30
    24c0:	00a0c800 	adceq	ip, r0, r0, lsl #16
    24c4:	00005800 	andeq	r5, r0, r0, lsl #16
    24c8:	5a9c0100 	bpl	fe7028d0 <__bss_end+0xfe6f6590>
    24cc:	0e000001 	cdpeq	0, 0, cr0, cr0, cr1, {0}
    24d0:	00000c86 	andeq	r0, r0, r6, lsl #25
    24d4:	00000109 	andeq	r0, r0, r9, lsl #2
    24d8:	0f6c9102 	svceq	0x006c9102
    24dc:	00000fdf 	ldrdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    24e0:	fc091801 	stc2	8, cr1, [r9], {1}
    24e4:	02000000 	andeq	r0, r0, #0
    24e8:	b60f7491 			; <UNDEFINED> instruction: 0xb60f7491
    24ec:	0100000f 	tsteq	r0, pc
    24f0:	010e0b19 	tsteq	lr, r9, lsl fp
    24f4:	91020000 	mrsls	r0, (UNDEF: 2)
    24f8:	c10d0070 	tstgt	sp, r0, ror r0
    24fc:	01000000 	mrseq	r0, (UNDEF: 0)
    2500:	0174050a 	cmneq	r4, sl, lsl #10
    2504:	a0380000 	eorsge	r0, r8, r0
    2508:	00900000 	addseq	r0, r0, r0
    250c:	9c010000 	stcls	0, cr0, [r1], {-0}
    2510:	0000019f 	muleq	r0, pc, r1	; <UNPREDICTABLE>
    2514:	000c860e 	andeq	r8, ip, lr, lsl #12
    2518:	00010900 	andeq	r0, r1, r0, lsl #18
    251c:	6c910200 	lfmvs	f0, 4, [r1], {0}
    2520:	706d7410 	rsbvc	r7, sp, r0, lsl r4
    2524:	090d0100 	stmdbeq	sp, {r8}
    2528:	000000fc 	strdeq	r0, [r0], -ip
    252c:	0f749102 	svceq	0x00749102
    2530:	00000faf 	andeq	r0, r0, pc, lsr #31
    2534:	fc090e01 	stc2	14, cr0, [r9], {1}
    2538:	02000000 	andeq	r0, r0, #0
    253c:	11007091 	swpne	r7, r1, [r0]
    2540:	00000089 	andeq	r0, r0, r9, lsl #1
    2544:	b0010501 	andlt	r0, r1, r1, lsl #10
    2548:	00000001 	andeq	r0, r0, r1
    254c:	000001f2 	strdeq	r0, [r0], -r2
    2550:	000c8612 	andeq	r8, ip, r2, lsl r6
    2554:	00010900 	andeq	r0, r1, r0, lsl #18
    2558:	696d1300 	stmdbvs	sp!, {r8, r9, ip}^
    255c:	0501006e 	streq	r0, [r1, #-110]	; 0xffffff92
    2560:	0000fc28 	andeq	pc, r0, r8, lsr #24
    2564:	616d1300 	cmnvs	sp, r0, lsl #6
    2568:	05010078 	streq	r0, [r1, #-120]	; 0xffffff88
    256c:	0000fc31 	andeq	pc, r0, r1, lsr ip	; <UNPREDICTABLE>
    2570:	00611300 	rsbeq	r1, r1, r0, lsl #6
    2574:	fc3a0501 	ldc2	5, cr0, [sl], #-4
    2578:	13000000 	movwne	r0, #0
    257c:	05010063 	streq	r0, [r1, #-99]	; 0xffffff9d
    2580:	0000fc40 	andeq	pc, r0, r0, asr #24
    2584:	06461400 	strbeq	r1, [r6], -r0, lsl #8
    2588:	05010000 	streq	r0, [r1, #-0]
    258c:	0000fc47 	andeq	pc, r0, r7, asr #24
    2590:	9f150000 	svcls	0x00150000
    2594:	c1000001 	tstgt	r0, r1
    2598:	0900000f 	stmdbeq	r0, {r0, r1, r2, r3}
    259c:	c0000002 	andgt	r0, r0, r2
    25a0:	7800009f 	stmdavc	r0, {r0, r1, r2, r3, r4, r7}
    25a4:	01000000 	mrseq	r0, (UNDEF: 0)
    25a8:	01b0169c 	lslseq	r1, ip	; <illegal shifter operand>
    25ac:	91020000 	mrsls	r0, (UNDEF: 2)
    25b0:	01b91674 			; <UNDEFINED> instruction: 0x01b91674
    25b4:	91020000 	mrsls	r0, (UNDEF: 2)
    25b8:	01c51670 	biceq	r1, r5, r0, ror r6
    25bc:	91020000 	mrsls	r0, (UNDEF: 2)
    25c0:	01d1166c 	bicseq	r1, r1, ip, ror #12
    25c4:	91020000 	mrsls	r0, (UNDEF: 2)
    25c8:	01db1668 	bicseq	r1, fp, r8, ror #12
    25cc:	91020000 	mrsls	r0, (UNDEF: 2)
    25d0:	01e51600 	mvneq	r1, r0, lsl #12
    25d4:	91020000 	mrsls	r0, (UNDEF: 2)
    25d8:	1b000004 	blne	25f0 <shift+0x25f0>
    25dc:	04000006 	streq	r0, [r0], #-6
    25e0:	000be100 	andeq	lr, fp, r0, lsl #2
    25e4:	dc010400 	cfstrsle	mvf0, [r1], {-0}
    25e8:	0400000e 	streq	r0, [r0], #-14
    25ec:	00001055 	andeq	r1, r0, r5, asr r0
    25f0:	00000e79 	andeq	r0, r0, r9, ror lr
    25f4:	00000078 	andeq	r0, r0, r8, ror r0
    25f8:	00000000 	andeq	r0, r0, r0
    25fc:	00001339 	andeq	r1, r0, r9, lsr r3
    2600:	a8080102 	stmdage	r8, {r1, r8}
    2604:	03000008 	movweq	r0, #8
    2608:	00000025 	andeq	r0, r0, r5, lsr #32
    260c:	21050202 	tstcs	r5, r2, lsl #4
    2610:	04000009 	streq	r0, [r0], #-9
    2614:	6e690504 	cdpvs	5, 6, cr0, cr9, cr4, {0}
    2618:	01020074 	tsteq	r2, r4, ror r0
    261c:	00089f08 	andeq	r9, r8, r8, lsl #30
    2620:	07020200 	streq	r0, [r2, -r0, lsl #4]
    2624:	00000698 	muleq	r0, r8, r6
    2628:	0009c705 	andeq	ip, r9, r5, lsl #14
    262c:	07090900 	streq	r0, [r9, -r0, lsl #18]
    2630:	0000005e 	andeq	r0, r0, lr, asr r0
    2634:	00004d03 	andeq	r4, r0, r3, lsl #26
    2638:	07040200 	streq	r0, [r4, -r0, lsl #4]
    263c:	00001fe3 	andeq	r1, r0, r3, ror #31
    2640:	00078306 	andeq	r8, r7, r6, lsl #6
    2644:	14050300 	strne	r0, [r5], #-768	; 0xfffffd00
    2648:	00000059 	andeq	r0, r0, r9, asr r0
    264c:	c2780305 	rsbsgt	r0, r8, #335544320	; 0x14000000
    2650:	10060000 	andne	r0, r6, r0
    2654:	03000008 	movweq	r0, #8
    2658:	00591406 	subseq	r1, r9, r6, lsl #8
    265c:	03050000 	movweq	r0, #20480	; 0x5000
    2660:	0000c27c 	andeq	ip, r0, ip, ror r2
    2664:	00074c06 	andeq	r4, r7, r6, lsl #24
    2668:	1a070400 	bne	1c3670 <__bss_end+0x1b7330>
    266c:	00000059 	andeq	r0, r0, r9, asr r0
    2670:	c2800305 	addgt	r0, r0, #335544320	; 0x14000000
    2674:	cf060000 	svcgt	0x00060000
    2678:	04000004 	streq	r0, [r0], #-4
    267c:	00591a09 	subseq	r1, r9, r9, lsl #20
    2680:	03050000 	movweq	r0, #20480	; 0x5000
    2684:	0000c284 	andeq	ip, r0, r4, lsl #5
    2688:	00087406 	andeq	r7, r8, r6, lsl #8
    268c:	1a0b0400 	bne	2c3694 <__bss_end+0x2b7354>
    2690:	00000059 	andeq	r0, r0, r9, asr r0
    2694:	c2880305 	addgt	r0, r8, #335544320	; 0x14000000
    2698:	85060000 	strhi	r0, [r6, #-0]
    269c:	04000006 	streq	r0, [r0], #-6
    26a0:	00591a0d 	subseq	r1, r9, sp, lsl #20
    26a4:	03050000 	movweq	r0, #20480	; 0x5000
    26a8:	0000c28c 	andeq	ip, r0, ip, lsl #5
    26ac:	00055206 	andeq	r5, r5, r6, lsl #4
    26b0:	1a0f0400 	bne	3c36b8 <__bss_end+0x3b7378>
    26b4:	00000059 	andeq	r0, r0, r9, asr r0
    26b8:	c2900305 	addsgt	r0, r0, #335544320	; 0x14000000
    26bc:	01020000 	mrseq	r0, (UNDEF: 2)
    26c0:	0006e402 	andeq	lr, r6, r2, lsl #8
    26c4:	2c040700 	stccs	7, cr0, [r4], {-0}
    26c8:	06000000 	streq	r0, [r0], -r0
    26cc:	000005ce 	andeq	r0, r0, lr, asr #11
    26d0:	59140405 	ldmdbpl	r4, {r0, r2, sl}
    26d4:	05000000 	streq	r0, [r0, #-0]
    26d8:	00c29403 	sbceq	r9, r2, r3, lsl #8
    26dc:	03370600 	teqeq	r7, #0, 12
    26e0:	07050000 	streq	r0, [r5, -r0]
    26e4:	00005914 	andeq	r5, r0, r4, lsl r9
    26e8:	98030500 	stmdals	r3, {r8, sl}
    26ec:	060000c2 	streq	r0, [r0], -r2, asr #1
    26f0:	00000524 	andeq	r0, r0, r4, lsr #10
    26f4:	59140a05 	ldmdbpl	r4, {r0, r2, r9, fp}
    26f8:	05000000 	streq	r0, [r0, #-0]
    26fc:	00c29c03 	sbceq	r9, r2, r3, lsl #24
    2700:	07040200 	streq	r0, [r4, -r0, lsl #4]
    2704:	00001fde 	ldrdeq	r1, [r0], -lr
    2708:	000b3306 	andeq	r3, fp, r6, lsl #6
    270c:	140a0600 	strne	r0, [sl], #-1536	; 0xfffffa00
    2710:	00000059 	andeq	r0, r0, r9, asr r0
    2714:	c2a00305 	adcgt	r0, r0, #335544320	; 0x14000000
    2718:	04080000 	streq	r0, [r8], #-0
    271c:	0005c109 	andeq	ip, r5, r9, lsl #2
    2720:	03070c00 	movweq	r0, #31744	; 0x7c00
    2724:	0001ef07 	andeq	lr, r1, r7, lsl #30
    2728:	0b610a00 	bleq	1844f30 <__bss_end+0x1838bf0>
    272c:	06070000 	streq	r0, [r7], -r0
    2730:	00004d0e 	andeq	r4, r0, lr, lsl #26
    2734:	bd0a0000 	stclt	0, cr0, [sl, #-0]
    2738:	07000009 	streq	r0, [r0, -r9]
    273c:	004d0e08 	subeq	r0, sp, r8, lsl #28
    2740:	0a040000 	beq	102748 <__bss_end+0xf6408>
    2744:	0000083f 	andeq	r0, r0, pc, lsr r8
    2748:	4d0e0b07 	vstrmi	d0, [lr, #-28]	; 0xffffffe4
    274c:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    2750:	0005c10b 	andeq	ip, r5, fp, lsl #2
    2754:	050d0700 	streq	r0, [sp, #-1792]	; 0xfffff900
    2758:	00000967 	andeq	r0, r0, r7, ror #18
    275c:	000001ef 	andeq	r0, r0, pc, ror #3
    2760:	00018e01 	andeq	r8, r1, r1, lsl #28
    2764:	00019400 	andeq	r9, r1, r0, lsl #8
    2768:	01ef0c00 	mvneq	r0, r0, lsl #24
    276c:	0d000000 	stceq	0, cr0, [r0, #-0]
    2770:	00000a93 	muleq	r0, r3, sl
    2774:	e90a0e07 	stmdb	sl, {r0, r1, r2, r9, sl, fp}
    2778:	01000006 	tsteq	r0, r6
    277c:	000001a9 	andeq	r0, r0, r9, lsr #3
    2780:	000001af 	andeq	r0, r0, pc, lsr #3
    2784:	0001ef0c 	andeq	lr, r1, ip, lsl #30
    2788:	580b0000 	stmdapl	fp, {}	; <UNPREDICTABLE>
    278c:	07000009 	streq	r0, [r0, -r9]
    2790:	055c0b0f 	ldrbeq	r0, [ip, #-2831]	; 0xfffff4f1
    2794:	013f0000 	teqeq	pc, r0
    2798:	c8010000 	stmdagt	r1, {}	; <UNPREDICTABLE>
    279c:	d3000001 	movwle	r0, #1
    27a0:	0c000001 	stceq	0, cr0, [r0], {1}
    27a4:	000001ef 	andeq	r0, r0, pc, ror #3
    27a8:	00004d0e 	andeq	r4, r0, lr, lsl #26
    27ac:	830f0000 	movwhi	r0, #61440	; 0xf000
    27b0:	0700000a 	streq	r0, [r0, -sl]
    27b4:	08ed0e10 	stmiaeq	sp!, {r4, r9, sl, fp}^
    27b8:	004d0000 	subeq	r0, sp, r0
    27bc:	e8010000 	stmda	r1, {}	; <UNPREDICTABLE>
    27c0:	0c000001 	stceq	0, cr0, [r0], {1}
    27c4:	000001ef 	andeq	r0, r0, pc, ror #3
    27c8:	04070000 	streq	r0, [r7], #-0
    27cc:	00000141 	andeq	r0, r0, r1, asr #2
    27d0:	07006810 	smladeq	r0, r0, r8, r6
    27d4:	01411512 	cmpeq	r1, r2, lsl r5
    27d8:	85110000 	ldrhi	r0, [r1, #-0]
    27dc:	0c00000b 	stceq	0, cr0, [r0], {11}
    27e0:	07070801 	streq	r0, [r7, -r1, lsl #16]
    27e4:	00000374 	andeq	r0, r0, r4, ror r3
    27e8:	000b1312 	andeq	r1, fp, r2, lsl r3
    27ec:	1b090800 	blne	2447f4 <__bss_end+0x2384b4>
    27f0:	00000059 	andeq	r0, r0, r9, asr r0
    27f4:	03660a80 	cmneq	r6, #128, 20	; 0x80000
    27f8:	0b080000 	bleq	202800 <__bss_end+0x1f64c0>
    27fc:	00004d0e 	andeq	r4, r0, lr, lsl #26
    2800:	820a0000 	andhi	r0, sl, #0
    2804:	08000004 	stmdaeq	r0, {r2}
    2808:	004d0e0c 	subeq	r0, sp, ip, lsl #28
    280c:	0a040000 	beq	102814 <__bss_end+0xf64d4>
    2810:	00000d6d 	andeq	r0, r0, sp, ror #26
    2814:	740a0f08 	strvc	r0, [sl], #-3848	; 0xfffff0f8
    2818:	08000003 	stmdaeq	r0, {r0, r1}
    281c:	0009300a 	andeq	r3, r9, sl
    2820:	0e100800 	cdpeq	8, 1, cr0, cr0, cr0, {0}
    2824:	0000004d 	andeq	r0, r0, sp, asr #32
    2828:	0b420a88 	bleq	1085250 <__bss_end+0x1078f10>
    282c:	12080000 	andne	r0, r8, #0
    2830:	0003740a 	andeq	r7, r3, sl, lsl #8
    2834:	5e138c00 	cdppl	12, 1, cr8, cr3, cr0, {0}
    2838:	08000009 	stmdaeq	r0, {r0, r3}
    283c:	04b90a13 	ldrteq	r0, [r9], #2579	; 0xa13
    2840:	026f0000 	rsbeq	r0, pc, #0
    2844:	027a0000 	rsbseq	r0, sl, #0
    2848:	840c0000 	strhi	r0, [ip], #-0
    284c:	0e000003 	cdpeq	0, 0, cr0, cr0, cr3, {0}
    2850:	00000025 	andeq	r0, r0, r5, lsr #32
    2854:	084e1300 	stmdaeq	lr, {r8, r9, ip}^
    2858:	14080000 	strne	r0, [r8], #-0
    285c:	0005990a 	andeq	r9, r5, sl, lsl #18
    2860:	00028e00 	andeq	r8, r2, r0, lsl #28
    2864:	00029900 	andeq	r9, r2, r0, lsl #18
    2868:	03840c00 	orreq	r0, r4, #0, 24
    286c:	4d0e0000 	stcmi	0, cr0, [lr, #-0]
    2870:	00000000 	andeq	r0, r0, r0
    2874:	000c2f14 	andeq	r2, ip, r4, lsl pc
    2878:	0a150800 	beq	544880 <__bss_end+0x538540>
    287c:	00000aa0 	andeq	r0, r0, r0, lsr #21
    2880:	000000e3 	andeq	r0, r0, r3, ror #1
    2884:	000002b1 			; <UNDEFINED> instruction: 0x000002b1
    2888:	000002b7 			; <UNDEFINED> instruction: 0x000002b7
    288c:	0003840c 	andeq	r8, r3, ip, lsl #8
    2890:	0a140000 	beq	502898 <__bss_end+0x4f6558>
    2894:	08000004 	stmdaeq	r0, {r2}
    2898:	0a5d0a16 	beq	17450f8 <__bss_end+0x1738db8>
    289c:	00e30000 	rsceq	r0, r3, r0
    28a0:	02cf0000 	sbceq	r0, pc, #0
    28a4:	02d50000 	sbcseq	r0, r5, #0
    28a8:	840c0000 	strhi	r0, [ip], #-0
    28ac:	00000003 	andeq	r0, r0, r3
    28b0:	000b850b 	andeq	r8, fp, fp, lsl #10
    28b4:	05180800 	ldreq	r0, [r8, #-2048]	; 0xfffff800
    28b8:	00000b8c 	andeq	r0, r0, ip, lsl #23
    28bc:	00000384 	andeq	r0, r0, r4, lsl #7
    28c0:	0002ee01 	andeq	lr, r2, r1, lsl #28
    28c4:	0002f900 	andeq	pc, r2, r0, lsl #18
    28c8:	03840c00 	orreq	r0, r4, #0, 24
    28cc:	4d0e0000 	stcmi	0, cr0, [lr, #-0]
    28d0:	00000000 	andeq	r0, r0, r0
    28d4:	0009120b 	andeq	r1, r9, fp, lsl #4
    28d8:	0b190800 	bleq	6448e0 <__bss_end+0x6385a0>
    28dc:	00000882 	andeq	r0, r0, r2, lsl #17
    28e0:	0000038f 	andeq	r0, r0, pc, lsl #7
    28e4:	00031201 	andeq	r1, r3, r1, lsl #4
    28e8:	00031800 	andeq	r1, r3, r0, lsl #16
    28ec:	03840c00 	orreq	r0, r4, #0, 24
    28f0:	0b000000 	bleq	28f8 <shift+0x28f8>
    28f4:	0000081c 	andeq	r0, r0, ip, lsl r8
    28f8:	1a0b1a08 	bne	2c9120 <__bss_end+0x2bcde0>
    28fc:	8f00000a 	svchi	0x0000000a
    2900:	01000003 	tsteq	r0, r3
    2904:	00000331 	andeq	r0, r0, r1, lsr r3
    2908:	0000033c 	andeq	r0, r0, ip, lsr r3
    290c:	0003840c 	andeq	r8, r3, ip, lsl #8
    2910:	00380e00 	eorseq	r0, r8, r0, lsl #28
    2914:	0d000000 	stceq	0, cr0, [r0, #-0]
    2918:	000006ab 	andeq	r0, r0, fp, lsr #13
    291c:	e40a1b08 	str	r1, [sl], #-2824	; 0xfffff4f8
    2920:	01000009 	tsteq	r0, r9
    2924:	00000351 	andeq	r0, r0, r1, asr r3
    2928:	00000357 	andeq	r0, r0, r7, asr r3
    292c:	0003840c 	andeq	r8, r3, ip, lsl #8
    2930:	d9150000 	ldmdble	r5, {}	; <UNPREDICTABLE>
    2934:	08000006 	stmdaeq	r0, {r1, r2}
    2938:	03c50a1c 	biceq	r0, r5, #28, 20	; 0x1c000
    293c:	68010000 	stmdavs	r1, {}	; <UNPREDICTABLE>
    2940:	0c000003 	stceq	0, cr0, [r0], {3}
    2944:	00000384 	andeq	r0, r0, r4, lsl #7
    2948:	0000ea0e 	andeq	lr, r0, lr, lsl #20
    294c:	16000000 	strne	r0, [r0], -r0
    2950:	00000025 	andeq	r0, r0, r5, lsr #32
    2954:	00000384 	andeq	r0, r0, r4, lsl #7
    2958:	00005e17 	andeq	r5, r0, r7, lsl lr
    295c:	07007f00 	streq	r7, [r0, -r0, lsl #30]
    2960:	0001ff04 	andeq	pc, r1, r4, lsl #30
    2964:	03840300 	orreq	r0, r4, #0, 6
    2968:	04070000 	streq	r0, [r7], #-0
    296c:	00000025 	andeq	r0, r0, r5, lsr #32
    2970:	00031818 	andeq	r1, r3, r8, lsl r8
    2974:	07550200 	ldrbeq	r0, [r5, -r0, lsl #4]
    2978:	000003af 	andeq	r0, r0, pc, lsr #7
    297c:	0000a4c4 	andeq	sl, r0, r4, asr #9
    2980:	0000007c 	andeq	r0, r0, ip, ror r0
    2984:	03ef9c01 	mvneq	r9, #256	; 0x100
    2988:	86190000 	ldrhi	r0, [r9], -r0
    298c:	8a00000c 	bhi	29c4 <shift+0x29c4>
    2990:	02000003 	andeq	r0, r0, #3
    2994:	131a6c91 	tstne	sl, #37120	; 0x9100
    2998:	02000010 	andeq	r0, r0, #16
    299c:	00382b55 	eorseq	r2, r8, r5, asr fp
    29a0:	91020000 	mrsls	r0, (UNDEF: 2)
    29a4:	12c11b68 	sbcne	r1, r1, #104, 22	; 0x1a000
    29a8:	56020000 	strpl	r0, [r2], -r0
    29ac:	00038f0b 	andeq	r8, r3, fp, lsl #30
    29b0:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    29b4:	0000601c 	andeq	r6, r0, ip, lsl r0
    29b8:	22631b00 	rsbcs	r1, r3, #0, 22
    29bc:	5d020000 	stcpl	0, cr0, [r2, #-0]
    29c0:	00003811 	andeq	r3, r0, r1, lsl r8
    29c4:	70910200 	addsvc	r0, r1, r0, lsl #4
    29c8:	7a180000 	bvc	6029d0 <__bss_end+0x5f6690>
    29cc:	02000002 	andeq	r0, r0, #2
    29d0:	0409064f 	streq	r0, [r9], #-1615	; 0xfffff9b1
    29d4:	a45c0000 	ldrbge	r0, [ip], #-0
    29d8:	00680000 	rsbeq	r0, r8, r0
    29dc:	9c010000 	stcls	0, cr0, [r1], {-0}
    29e0:	0000043c 	andeq	r0, r0, ip, lsr r4
    29e4:	000c8619 	andeq	r8, ip, r9, lsl r6
    29e8:	00038a00 	andeq	r8, r3, r0, lsl #20
    29ec:	6c910200 	lfmvs	f0, 4, [r1], {0}
    29f0:	6e656c1d 	mcrvs	12, 3, r6, cr5, cr13, {0}
    29f4:	214f0200 	mrscs	r0, (UNDEF: 111)
    29f8:	0000004d 	andeq	r0, r0, sp, asr #32
    29fc:	1e689102 	lgnnee	f1, f2
    2a00:	0000a470 	andeq	sl, r0, r0, ror r4
    2a04:	00000048 	andeq	r0, r0, r8, asr #32
    2a08:	0200691f 	andeq	r6, r0, #507904	; 0x7c000
    2a0c:	004d1250 	subeq	r1, sp, r0, asr r2
    2a10:	91020000 	mrsls	r0, (UNDEF: 2)
    2a14:	18000074 	stmdane	r0, {r2, r4, r5, r6}
    2a18:	000002f9 	strdeq	r0, [r0], -r9
    2a1c:	56072602 	strpl	r2, [r7], -r2, lsl #12
    2a20:	b4000004 	strlt	r0, [r0], #-4
    2a24:	a80000a2 	stmdage	r0, {r1, r5, r7}
    2a28:	01000001 	tsteq	r0, r1
    2a2c:	0004c39c 	muleq	r4, ip, r3
    2a30:	0c861900 			; <UNDEFINED> instruction: 0x0c861900
    2a34:	038a0000 	orreq	r0, sl, #0
    2a38:	91020000 	mrsls	r0, (UNDEF: 2)
    2a3c:	10451b5c 	subne	r1, r5, ip, asr fp
    2a40:	28020000 	stmdacs	r2, {}	; <UNPREDICTABLE>
    2a44:	0000e30a 	andeq	lr, r0, sl, lsl #6
    2a48:	6e910200 	cdpvs	2, 9, cr0, cr1, cr0, {0}
    2a4c:	0200691f 	andeq	r6, r0, #507904	; 0x7c000
    2a50:	00380932 	eorseq	r0, r8, r2, lsr r9
    2a54:	91020000 	mrsls	r0, (UNDEF: 2)
    2a58:	006a1f74 	rsbeq	r1, sl, r4, ror pc
    2a5c:	380b3202 	stmdacc	fp, {r1, r9, ip, sp}
    2a60:	02000000 	andeq	r0, r0, #0
    2a64:	301b7091 	mulscc	fp, r1, r0
    2a68:	02000010 	andeq	r0, r0, #16
    2a6c:	00e30a33 	rsceq	r0, r3, r3, lsr sl
    2a70:	91020000 	mrsls	r0, (UNDEF: 2)
    2a74:	66621f6f 	strbtvs	r1, [r2], -pc, ror #30
    2a78:	44020072 	strmi	r0, [r2], #-114	; 0xffffff8e
    2a7c:	00038f0b 	andeq	r8, r3, fp, lsl #30
    2a80:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    2a84:	00a2e81e 	adceq	lr, r2, lr, lsl r8
    2a88:	00003800 	andeq	r3, r0, r0, lsl #16
    2a8c:	072f1b00 	streq	r1, [pc, -r0, lsl #22]!
    2a90:	2b020000 	blcs	82a98 <__bss_end+0x76758>
    2a94:	00004d12 	andeq	r4, r0, r2, lsl sp
    2a98:	68910200 	ldmvs	r1, {r9}
    2a9c:	57200000 	strpl	r0, [r0, -r0]!
    2aa0:	02000003 	andeq	r0, r0, #3
    2aa4:	0004dc06 	andeq	sp, r4, r6, lsl #24
    2aa8:	00a27000 	adceq	r7, r2, r0
    2aac:	00004400 	andeq	r4, r0, r0, lsl #8
    2ab0:	f89c0100 			; <UNDEFINED> instruction: 0xf89c0100
    2ab4:	19000004 	stmdbne	r0, {r2}
    2ab8:	00000c86 	andeq	r0, r0, r6, lsl #25
    2abc:	0000038a 	andeq	r0, r0, sl, lsl #7
    2ac0:	1d6c9102 	stfnep	f1, [ip, #-8]!
    2ac4:	00727473 	rsbseq	r7, r2, r3, ror r4
    2ac8:	ea251c02 	b	949ad8 <__bss_end+0x93d798>
    2acc:	02000000 	andeq	r0, r0, #0
    2ad0:	21006891 			; <UNDEFINED> instruction: 0x21006891
    2ad4:	0000033c 	andeq	r0, r0, ip, lsr r3
    2ad8:	12061602 	andne	r1, r6, #2097152	; 0x200000
    2adc:	38000005 	stmdacc	r0, {r0, r2}
    2ae0:	380000a2 	stmdacc	r0, {r1, r5, r7}
    2ae4:	01000000 	mrseq	r0, (UNDEF: 0)
    2ae8:	00051f9c 	muleq	r5, ip, pc	; <UNPREDICTABLE>
    2aec:	0c861900 			; <UNDEFINED> instruction: 0x0c861900
    2af0:	038a0000 	orreq	r0, sl, #0
    2af4:	91020000 	mrsls	r0, (UNDEF: 2)
    2af8:	5b210074 	blpl	842cd0 <__bss_end+0x836990>
    2afc:	02000002 	andeq	r0, r0, #2
    2b00:	05390611 	ldreq	r0, [r9, #-1553]!	; 0xfffff9ef
    2b04:	a1e40000 	mvnge	r0, r0
    2b08:	00540000 	subseq	r0, r4, r0
    2b0c:	9c010000 	stcls	0, cr0, [r1], {-0}
    2b10:	00000553 	andeq	r0, r0, r3, asr r5
    2b14:	000c8619 	andeq	r8, ip, r9, lsl r6
    2b18:	00038a00 	andeq	r8, r3, r0, lsl #20
    2b1c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    2b20:	0200631d 	andeq	r6, r0, #1946157056	; 0x74000000
    2b24:	00251c11 	eoreq	r1, r5, r1, lsl ip
    2b28:	91020000 	mrsls	r0, (UNDEF: 2)
    2b2c:	b7210073 			; <UNDEFINED> instruction: 0xb7210073
    2b30:	02000002 	andeq	r0, r0, #2
    2b34:	056d060d 	strbeq	r0, [sp, #-1549]!	; 0xfffff9f3
    2b38:	a1ac0000 			; <UNDEFINED> instruction: 0xa1ac0000
    2b3c:	00380000 	eorseq	r0, r8, r0
    2b40:	9c010000 	stcls	0, cr0, [r1], {-0}
    2b44:	0000057a 	andeq	r0, r0, sl, ror r5
    2b48:	000c8619 	andeq	r8, ip, r9, lsl r6
    2b4c:	00038a00 	andeq	r8, r3, r0, lsl #20
    2b50:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    2b54:	02992100 	addseq	r2, r9, #0, 2
    2b58:	09020000 	stmdbeq	r2, {}	; <UNPREDICTABLE>
    2b5c:	00059406 	andeq	r9, r5, r6, lsl #8
    2b60:	00a16c00 	adceq	r6, r1, r0, lsl #24
    2b64:	00004000 	andeq	r4, r0, r0
    2b68:	a19c0100 	orrsge	r0, ip, r0, lsl #2
    2b6c:	19000005 	stmdbne	r0, {r0, r2}
    2b70:	00000c86 	andeq	r0, r0, r6, lsl #25
    2b74:	0000038a 	andeq	r0, r0, sl, lsl #7
    2b78:	00749102 	rsbseq	r9, r4, r2, lsl #2
    2b7c:	0002d522 	andeq	sp, r2, r2, lsr #10
    2b80:	01060200 	mrseq	r0, LR_usr
    2b84:	000005b2 			; <UNDEFINED> instruction: 0x000005b2
    2b88:	0005c800 	andeq	ip, r5, r0, lsl #16
    2b8c:	0c862300 	stceq	3, cr2, [r6], {0}
    2b90:	038a0000 	orreq	r0, sl, #0
    2b94:	3b240000 	blcc	902b9c <__bss_end+0x8f685c>
    2b98:	02000010 	andeq	r0, r0, #16
    2b9c:	004d1906 	subeq	r1, sp, r6, lsl #18
    2ba0:	25000000 	strcs	r0, [r0, #-0]
    2ba4:	000005a1 	andeq	r0, r0, r1, lsr #11
    2ba8:	00001021 	andeq	r1, r0, r1, lsr #32
    2bac:	000005e3 	andeq	r0, r0, r3, ror #11
    2bb0:	0000a120 	andeq	sl, r0, r0, lsr #2
    2bb4:	0000004c 	andeq	r0, r0, ip, asr #32
    2bb8:	05f49c01 	ldrbeq	r9, [r4, #3073]!	; 0xc01
    2bbc:	b2260000 	eorlt	r0, r6, #0
    2bc0:	02000005 	andeq	r0, r0, #5
    2bc4:	bb267491 	bllt	99fe10 <__bss_end+0x993ad0>
    2bc8:	02000005 	andeq	r0, r0, #5
    2bcc:	27007091 			; <UNDEFINED> instruction: 0x27007091
    2bd0:	00000412 	andeq	r0, r0, r2, lsl r4
    2bd4:	600e0d01 	andvs	r0, lr, r1, lsl #26
    2bd8:	3f000003 	svccc	0x00000003
    2bdc:	e0000001 	and	r0, r0, r1
    2be0:	30000086 	andcc	r0, r0, r6, lsl #1
    2be4:	01000000 	mrseq	r0, (UNDEF: 0)
    2be8:	16001a9c 			; <UNDEFINED> instruction: 0x16001a9c
    2bec:	0d010000 	stceq	0, cr0, [r1, #-0]
    2bf0:	00004d26 	andeq	r4, r0, r6, lsr #26
    2bf4:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    2bf8:	0b910000 	bleq	fe442c00 <__bss_end+0xfe4368c0>
    2bfc:	00040000 	andeq	r0, r4, r0
    2c00:	00000e6a 	andeq	r0, r0, sl, ror #28
    2c04:	0edc0104 	cdpeq	1, 13, cr0, cr12, cr4, {0}
    2c08:	11040000 	mrsne	r0, (UNDEF: 4)
    2c0c:	79000017 	stmdbvc	r0, {r0, r1, r2, r4}
    2c10:	4000000e 	andmi	r0, r0, lr
    2c14:	5c0000a5 	stcpl	0, cr0, [r0], {165}	; 0xa5
    2c18:	26000004 	strcs	r0, [r0], -r4
    2c1c:	02000016 	andeq	r0, r0, #22
    2c20:	08a80801 	stmiaeq	r8!, {r0, fp}
    2c24:	25030000 	strcs	r0, [r3, #-0]
    2c28:	02000000 	andeq	r0, r0, #0
    2c2c:	09210502 	stmdbeq	r1!, {r1, r8, sl}
    2c30:	04040000 	streq	r0, [r4], #-0
    2c34:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
    2c38:	08010200 	stmdaeq	r1, {r9}
    2c3c:	0000089f 	muleq	r0, pc, r8	; <UNPREDICTABLE>
    2c40:	98070202 	stmdals	r7, {r1, r9}
    2c44:	05000006 	streq	r0, [r0, #-6]
    2c48:	000009c7 	andeq	r0, r0, r7, asr #19
    2c4c:	5e070907 	vmlapl.f16	s0, s14, s14	; <UNPREDICTABLE>
    2c50:	03000000 	movweq	r0, #0
    2c54:	0000004d 	andeq	r0, r0, sp, asr #32
    2c58:	e3070402 	movw	r0, #29698	; 0x7402
    2c5c:	0600001f 			; <UNDEFINED> instruction: 0x0600001f
    2c60:	00001292 	muleq	r0, r2, r2
    2c64:	08060208 	stmdaeq	r6, {r3, r9}
    2c68:	0000008b 	andeq	r0, r0, fp, lsl #1
    2c6c:	00307207 	eorseq	r7, r0, r7, lsl #4
    2c70:	4d0e0802 	stcmi	8, cr0, [lr, #-8]
    2c74:	00000000 	andeq	r0, r0, r0
    2c78:	00317207 	eorseq	r7, r1, r7, lsl #4
    2c7c:	4d0e0902 	vstrmi.16	s0, [lr, #-4]	; <UNPREDICTABLE>
    2c80:	04000000 	streq	r0, [r0], #-0
    2c84:	17410800 	strbne	r0, [r1, -r0, lsl #16]
    2c88:	04050000 	streq	r0, [r5], #-0
    2c8c:	00000038 	andeq	r0, r0, r8, lsr r0
    2c90:	a90c0d02 	stmdbge	ip, {r1, r8, sl, fp}
    2c94:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
    2c98:	00004b4f 	andeq	r4, r0, pc, asr #22
    2c9c:	0012ab0a 	andseq	sl, r2, sl, lsl #22
    2ca0:	08000100 	stmdaeq	r0, {r8}
    2ca4:	00001173 	andeq	r1, r0, r3, ror r1
    2ca8:	00380405 	eorseq	r0, r8, r5, lsl #8
    2cac:	1e020000 	cdpne	0, 0, cr0, cr2, cr0, {0}
    2cb0:	0000ec0c 	andeq	lr, r0, ip, lsl #24
    2cb4:	12fd0a00 	rscsne	r0, sp, #0, 20
    2cb8:	0a000000 	beq	2cc0 <shift+0x2cc0>
    2cbc:	000019e2 	andeq	r1, r0, r2, ror #19
    2cc0:	19c20a01 	stmibne	r2, {r0, r9, fp}^
    2cc4:	0a020000 	beq	82ccc <__bss_end+0x7698c>
    2cc8:	000014b8 			; <UNDEFINED> instruction: 0x000014b8
    2ccc:	161b0a03 	ldrne	r0, [fp], -r3, lsl #20
    2cd0:	0a040000 	beq	102cd8 <__bss_end+0xf6998>
    2cd4:	000012bd 			; <UNDEFINED> instruction: 0x000012bd
    2cd8:	10fd0a05 	rscsne	r0, sp, r5, lsl #20
    2cdc:	0a060000 	beq	182ce4 <__bss_end+0x1769a4>
    2ce0:	00001984 	andeq	r1, r0, r4, lsl #19
    2ce4:	42080007 	andmi	r0, r8, #7
    2ce8:	05000019 	streq	r0, [r0, #-25]	; 0xffffffe7
    2cec:	00003804 	andeq	r3, r0, r4, lsl #16
    2cf0:	0c490200 	sfmeq	f0, 2, [r9], {-0}
    2cf4:	00000129 	andeq	r0, r0, r9, lsr #2
    2cf8:	0010920a 	andseq	r9, r0, sl, lsl #4
    2cfc:	880a0000 	stmdahi	sl, {}	; <UNPREDICTABLE>
    2d00:	01000011 	tsteq	r0, r1, lsl r0
    2d04:	0008390a 	andeq	r3, r8, sl, lsl #18
    2d08:	8e0a0200 	cdphi	2, 0, cr0, cr10, cr0, {0}
    2d0c:	03000019 	movweq	r0, #25
    2d10:	0019ec0a 	andseq	lr, r9, sl, lsl #24
    2d14:	b90a0400 	stmdblt	sl, {sl}
    2d18:	05000015 	streq	r0, [r0, #-21]	; 0xffffffeb
    2d1c:	00147f0a 	andseq	r7, r4, sl, lsl #30
    2d20:	08000600 	stmdaeq	r0, {r9, sl}
    2d24:	000018fc 	strdeq	r1, [r0], -ip
    2d28:	00380405 	eorseq	r0, r8, r5, lsl #8
    2d2c:	70020000 	andvc	r0, r2, r0
    2d30:	0001540c 	andeq	r5, r1, ip, lsl #8
    2d34:	16900a00 	ldrne	r0, [r0], r0, lsl #20
    2d38:	0a000000 	beq	2d40 <shift+0x2d40>
    2d3c:	0000142c 	andeq	r1, r0, ip, lsr #8
    2d40:	16da0a01 	ldrbne	r0, [sl], r1, lsl #20
    2d44:	0a020000 	beq	82d4c <__bss_end+0x76a0c>
    2d48:	00001484 	andeq	r1, r0, r4, lsl #9
    2d4c:	830b0003 	movwhi	r0, #45059	; 0xb003
    2d50:	03000007 	movweq	r0, #7
    2d54:	00591405 	subseq	r1, r9, r5, lsl #8
    2d58:	03050000 	movweq	r0, #20480	; 0x5000
    2d5c:	0000c2cc 	andeq	ip, r0, ip, asr #5
    2d60:	0008100b 	andeq	r1, r8, fp
    2d64:	14060300 	strne	r0, [r6], #-768	; 0xfffffd00
    2d68:	00000059 	andeq	r0, r0, r9, asr r0
    2d6c:	c2d00305 	sbcsgt	r0, r0, #335544320	; 0x14000000
    2d70:	4c0b0000 	stcmi	0, cr0, [fp], {-0}
    2d74:	04000007 	streq	r0, [r0], #-7
    2d78:	00591a07 	subseq	r1, r9, r7, lsl #20
    2d7c:	03050000 	movweq	r0, #20480	; 0x5000
    2d80:	0000c2d4 	ldrdeq	ip, [r0], -r4
    2d84:	0004cf0b 	andeq	ip, r4, fp, lsl #30
    2d88:	1a090400 	bne	243d90 <__bss_end+0x237a50>
    2d8c:	00000059 	andeq	r0, r0, r9, asr r0
    2d90:	c2d80305 	sbcsgt	r0, r8, #335544320	; 0x14000000
    2d94:	740b0000 	strvc	r0, [fp], #-0
    2d98:	04000008 	streq	r0, [r0], #-8
    2d9c:	00591a0b 	subseq	r1, r9, fp, lsl #20
    2da0:	03050000 	movweq	r0, #20480	; 0x5000
    2da4:	0000c2dc 	ldrdeq	ip, [r0], -ip	; <UNPREDICTABLE>
    2da8:	0006850b 	andeq	r8, r6, fp, lsl #10
    2dac:	1a0d0400 	bne	343db4 <__bss_end+0x337a74>
    2db0:	00000059 	andeq	r0, r0, r9, asr r0
    2db4:	c2e00305 	rscgt	r0, r0, #335544320	; 0x14000000
    2db8:	520b0000 	andpl	r0, fp, #0
    2dbc:	04000005 	streq	r0, [r0], #-5
    2dc0:	00591a0f 	subseq	r1, r9, pc, lsl #20
    2dc4:	03050000 	movweq	r0, #20480	; 0x5000
    2dc8:	0000c2e4 	andeq	ip, r0, r4, ror #5
    2dcc:	0019b208 	andseq	fp, r9, r8, lsl #4
    2dd0:	38040500 	stmdacc	r4, {r8, sl}
    2dd4:	04000000 	streq	r0, [r0], #-0
    2dd8:	01f70c1b 	mvnseq	r0, fp, lsl ip
    2ddc:	100a0000 	andne	r0, sl, r0
    2de0:	0000000a 	andeq	r0, r0, sl
    2de4:	000c060a 	andeq	r0, ip, sl, lsl #12
    2de8:	340a0100 	strcc	r0, [sl], #-256	; 0xffffff00
    2dec:	02000008 	andeq	r0, r0, #8
    2df0:	168a0c00 	strne	r0, [sl], r0, lsl #24
    2df4:	01020000 	mrseq	r0, (UNDEF: 2)
    2df8:	0006e402 	andeq	lr, r6, r2, lsl #8
    2dfc:	2c040d00 	stccs	13, cr0, [r4], {-0}
    2e00:	0d000000 	stceq	0, cr0, [r0, #-0]
    2e04:	0001f704 	andeq	pc, r1, r4, lsl #14
    2e08:	05ce0b00 	strbeq	r0, [lr, #2816]	; 0xb00
    2e0c:	04050000 	streq	r0, [r5], #-0
    2e10:	00005914 	andeq	r5, r0, r4, lsl r9
    2e14:	e8030500 	stmda	r3, {r8, sl}
    2e18:	0b0000c2 	bleq	3128 <shift+0x3128>
    2e1c:	00000337 	andeq	r0, r0, r7, lsr r3
    2e20:	59140705 	ldmdbpl	r4, {r0, r2, r8, r9, sl}
    2e24:	05000000 	streq	r0, [r0, #-0]
    2e28:	00c2ec03 	sbceq	lr, r2, r3, lsl #24
    2e2c:	05240b00 	streq	r0, [r4, #-2816]!	; 0xfffff500
    2e30:	0a050000 	beq	142e38 <__bss_end+0x136af8>
    2e34:	00005914 	andeq	r5, r0, r4, lsl r9
    2e38:	f0030500 			; <UNDEFINED> instruction: 0xf0030500
    2e3c:	080000c2 	stmdaeq	r0, {r1, r6, r7}
    2e40:	00001513 	andeq	r1, r0, r3, lsl r5
    2e44:	00380405 	eorseq	r0, r8, r5, lsl #8
    2e48:	0d050000 	stceq	0, cr0, [r5, #-0]
    2e4c:	00027c0c 	andeq	r7, r2, ip, lsl #24
    2e50:	654e0900 	strbvs	r0, [lr, #-2304]	; 0xfffff700
    2e54:	0a000077 	beq	3038 <shift+0x3038>
    2e58:	0000150a 	andeq	r1, r0, sl, lsl #10
    2e5c:	17520a01 	ldrbne	r0, [r2, -r1, lsl #20]
    2e60:	0a020000 	beq	82e68 <__bss_end+0x76b28>
    2e64:	000014dc 	ldrdeq	r1, [r0], -ip
    2e68:	14aa0a03 	strtne	r0, [sl], #2563	; 0xa03
    2e6c:	0a040000 	beq	102e74 <__bss_end+0xf6b34>
    2e70:	00001614 	andeq	r1, r0, r4, lsl r6
    2e74:	b0060005 	andlt	r0, r6, r5
    2e78:	10000012 	andne	r0, r0, r2, lsl r0
    2e7c:	bb081b05 	bllt	209a98 <__bss_end+0x1fd758>
    2e80:	07000002 	streq	r0, [r0, -r2]
    2e84:	0500726c 	streq	r7, [r0, #-620]	; 0xfffffd94
    2e88:	02bb131d 	adcseq	r1, fp, #1946157056	; 0x74000000
    2e8c:	07000000 	streq	r0, [r0, -r0]
    2e90:	05007073 	streq	r7, [r0, #-115]	; 0xffffff8d
    2e94:	02bb131e 	adcseq	r1, fp, #2013265920	; 0x78000000
    2e98:	07040000 	streq	r0, [r4, -r0]
    2e9c:	05006370 	streq	r6, [r0, #-880]	; 0xfffffc90
    2ea0:	02bb131f 	adcseq	r1, fp, #2080374784	; 0x7c000000
    2ea4:	0e080000 	cdpeq	0, 0, cr0, cr8, cr0, {0}
    2ea8:	000012cf 	andeq	r1, r0, pc, asr #5
    2eac:	bb132005 	bllt	4caec8 <__bss_end+0x4beb88>
    2eb0:	0c000002 	stceq	0, cr0, [r0], {2}
    2eb4:	07040200 	streq	r0, [r4, -r0, lsl #4]
    2eb8:	00001fde 	ldrdeq	r1, [r0], -lr
    2ebc:	00136c06 	andseq	r6, r3, r6, lsl #24
    2ec0:	28057c00 	stmdacs	r5, {sl, fp, ip, sp, lr}
    2ec4:	00037908 	andeq	r7, r3, r8, lsl #18
    2ec8:	17bf0e00 	ldrne	r0, [pc, r0, lsl #28]!
    2ecc:	2a050000 	bcs	142ed4 <__bss_end+0x136b94>
    2ed0:	00027c12 	andeq	r7, r2, r2, lsl ip
    2ed4:	70070000 	andvc	r0, r7, r0
    2ed8:	05006469 	streq	r6, [r0, #-1129]	; 0xfffffb97
    2edc:	005e122b 	subseq	r1, lr, fp, lsr #4
    2ee0:	0e100000 	cdpeq	0, 1, cr0, cr0, cr0, {0}
    2ee4:	000011cd 	andeq	r1, r0, sp, asr #3
    2ee8:	45112c05 	ldrmi	r2, [r1, #-3077]	; 0xfffff3fb
    2eec:	14000002 	strne	r0, [r0], #-2
    2ef0:	00151f0e 	andseq	r1, r5, lr, lsl #30
    2ef4:	122d0500 	eorne	r0, sp, #0, 10
    2ef8:	0000005e 	andeq	r0, r0, lr, asr r0
    2efc:	155a0e18 	ldrbne	r0, [sl, #-3608]	; 0xfffff1e8
    2f00:	2e050000 	cdpcs	0, 0, cr0, cr5, cr0, {0}
    2f04:	00005e12 	andeq	r5, r0, r2, lsl lr
    2f08:	9e0e1c00 	cdpls	12, 0, cr1, cr14, cr0, {0}
    2f0c:	05000012 	streq	r0, [r0, #-18]	; 0xffffffee
    2f10:	03790c2f 	cmneq	r9, #12032	; 0x2f00
    2f14:	0e200000 	cdpeq	0, 2, cr0, cr0, cr0, {0}
    2f18:	00001533 	andeq	r1, r0, r3, lsr r5
    2f1c:	38093005 	stmdacc	r9, {r0, r2, ip, sp}
    2f20:	60000000 	andvs	r0, r0, r0
    2f24:	0017cb0e 	andseq	ip, r7, lr, lsl #22
    2f28:	0e310500 	cfabs32eq	mvfx0, mvfx1
    2f2c:	0000004d 	andeq	r0, r0, sp, asr #32
    2f30:	130e0e64 	movwne	r0, #61028	; 0xee64
    2f34:	33050000 	movwcc	r0, #20480	; 0x5000
    2f38:	00004d0e 	andeq	r4, r0, lr, lsl #26
    2f3c:	050e6800 	streq	r6, [lr, #-2048]	; 0xfffff800
    2f40:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
    2f44:	004d0e34 	subeq	r0, sp, r4, lsr lr
    2f48:	0e6c0000 	cdpeq	0, 6, cr0, cr12, cr0, {0}
    2f4c:	0000144b 	andeq	r1, r0, fp, asr #8
    2f50:	4d0e3505 	cfstr32mi	mvfx3, [lr, #-20]	; 0xffffffec
    2f54:	70000000 	andvc	r0, r0, r0
    2f58:	0016050e 	andseq	r0, r6, lr, lsl #10
    2f5c:	0e360500 	cfabs32eq	mvfx0, mvfx6
    2f60:	0000004d 	andeq	r0, r0, sp, asr #32
    2f64:	19940e74 	ldmibne	r4, {r2, r4, r5, r6, r9, sl, fp}
    2f68:	37050000 	strcc	r0, [r5, -r0]
    2f6c:	00004d0e 	andeq	r4, r0, lr, lsl #26
    2f70:	0f007800 	svceq	0x00007800
    2f74:	00000209 	andeq	r0, r0, r9, lsl #4
    2f78:	00000389 	andeq	r0, r0, r9, lsl #7
    2f7c:	00005e10 	andeq	r5, r0, r0, lsl lr
    2f80:	0b000f00 	bleq	6b88 <shift+0x6b88>
    2f84:	00000b33 	andeq	r0, r0, r3, lsr fp
    2f88:	59140a06 	ldmdbpl	r4, {r1, r2, r9, fp}
    2f8c:	05000000 	streq	r0, [r0, #-0]
    2f90:	00c2f403 	sbceq	pc, r2, r3, lsl #8
    2f94:	14e40800 	strbtne	r0, [r4], #2048	; 0x800
    2f98:	04050000 	streq	r0, [r5], #-0
    2f9c:	00000038 	andeq	r0, r0, r8, lsr r0
    2fa0:	ba0c0d06 	blt	3063c0 <__bss_end+0x2fa080>
    2fa4:	0a000003 	beq	2fb8 <shift+0x2fb8>
    2fa8:	0000118d 	andeq	r1, r0, sp, lsl #3
    2fac:	10870a00 	addne	r0, r7, r0, lsl #20
    2fb0:	00010000 	andeq	r0, r1, r0
    2fb4:	00039b03 	andeq	r9, r3, r3, lsl #22
    2fb8:	15950800 	ldrne	r0, [r5, #2048]	; 0x800
    2fbc:	04050000 	streq	r0, [r5], #-0
    2fc0:	00000038 	andeq	r0, r0, r8, lsr r0
    2fc4:	de0c1406 	cdple	4, 0, cr1, cr12, cr6, {0}
    2fc8:	0a000003 	beq	2fdc <shift+0x2fdc>
    2fcc:	000010d1 	ldrdeq	r1, [r0], -r1	; <UNPREDICTABLE>
    2fd0:	16cc0a00 	strbne	r0, [ip], r0, lsl #20
    2fd4:	00010000 	andeq	r0, r1, r0
    2fd8:	0003bf03 	andeq	fp, r3, r3, lsl #30
    2fdc:	188b0600 	stmne	fp, {r9, sl}
    2fe0:	060c0000 	streq	r0, [ip], -r0
    2fe4:	0418081b 	ldreq	r0, [r8], #-2075	; 0xfffff7e5
    2fe8:	cc0e0000 	stcgt	0, cr0, [lr], {-0}
    2fec:	06000010 			; <UNDEFINED> instruction: 0x06000010
    2ff0:	0418191d 	ldreq	r1, [r8], #-2333	; 0xfffff6e3
    2ff4:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    2ff8:	0000114a 	andeq	r1, r0, sl, asr #2
    2ffc:	18191e06 	ldmdane	r9, {r1, r2, r9, sl, fp, ip}
    3000:	04000004 	streq	r0, [r0], #-4
    3004:	00183f0e 	andseq	r3, r8, lr, lsl #30
    3008:	131f0600 	tstne	pc, #0, 12
    300c:	0000041e 	andeq	r0, r0, lr, lsl r4
    3010:	040d0008 	streq	r0, [sp], #-8
    3014:	000003e3 	andeq	r0, r0, r3, ror #7
    3018:	02c2040d 	sbceq	r0, r2, #218103808	; 0xd000000
    301c:	f2110000 	vhadd.s16	d0, d1, d0
    3020:	14000011 	strne	r0, [r0], #-17	; 0xffffffef
    3024:	e5072206 	str	r2, [r7, #-518]	; 0xfffffdfa
    3028:	0e000006 	cdpeq	0, 0, cr0, cr0, cr6, {0}
    302c:	000014d2 	ldrdeq	r1, [r0], -r2
    3030:	4d122606 	ldcmi	6, cr2, [r2, #-24]	; 0xffffffe8
    3034:	00000000 	andeq	r0, r0, r0
    3038:	0011040e 	andseq	r0, r1, lr, lsl #8
    303c:	1d290600 	stcne	6, cr0, [r9, #-0]
    3040:	00000418 	andeq	r0, r0, r8, lsl r4
    3044:	17960e04 	ldrne	r0, [r6, r4, lsl #28]
    3048:	2c060000 	stccs	0, cr0, [r6], {-0}
    304c:	0004181d 	andeq	r1, r4, sp, lsl r8
    3050:	38120800 	ldmdacc	r2, {fp}
    3054:	06000019 			; <UNDEFINED> instruction: 0x06000019
    3058:	18680e2f 	stmdane	r8!, {r0, r1, r2, r3, r5, r9, sl, fp}^
    305c:	046c0000 	strbteq	r0, [ip], #-0
    3060:	04770000 	ldrbteq	r0, [r7], #-0
    3064:	ea130000 	b	4c306c <__bss_end+0x4b6d2c>
    3068:	14000006 	strne	r0, [r0], #-6
    306c:	00000418 	andeq	r0, r0, r8, lsl r4
    3070:	18501500 	ldmdane	r0, {r8, sl, ip}^
    3074:	31060000 	mrscc	r0, (UNDEF: 6)
    3078:	0013430e 	andseq	r4, r3, lr, lsl #6
    307c:	0001fc00 	andeq	pc, r1, r0, lsl #24
    3080:	00048f00 	andeq	r8, r4, r0, lsl #30
    3084:	00049a00 	andeq	r9, r4, r0, lsl #20
    3088:	06ea1300 	strbteq	r1, [sl], r0, lsl #6
    308c:	1e140000 	cdpne	0, 1, cr0, cr4, cr0, {0}
    3090:	00000004 	andeq	r0, r0, r4
    3094:	00189e16 	andseq	r9, r8, r6, lsl lr
    3098:	1d350600 	ldcne	6, cr0, [r5, #-0]
    309c:	0000181a 	andeq	r1, r0, sl, lsl r8
    30a0:	00000418 	andeq	r0, r0, r8, lsl r4
    30a4:	0004b302 	andeq	fp, r4, r2, lsl #6
    30a8:	0004b900 	andeq	fp, r4, r0, lsl #18
    30ac:	06ea1300 	strbteq	r1, [sl], r0, lsl #6
    30b0:	16000000 	strne	r0, [r0], -r0
    30b4:	00001472 	andeq	r1, r0, r2, ror r4
    30b8:	9b1d3706 	blls	750cd8 <__bss_end+0x744998>
    30bc:	18000016 	stmdane	r0, {r1, r2, r4}
    30c0:	02000004 	andeq	r0, r0, #4
    30c4:	000004d2 	ldrdeq	r0, [r0], -r2
    30c8:	000004d8 	ldrdeq	r0, [r0], -r8
    30cc:	0006ea13 	andeq	lr, r6, r3, lsl sl
    30d0:	76170000 	ldrvc	r0, [r7], -r0
    30d4:	06000015 			; <UNDEFINED> instruction: 0x06000015
    30d8:	07033139 	smladxeq	r3, r9, r1, r3
    30dc:	020c0000 	andeq	r0, ip, #0
    30e0:	0011f216 	andseq	pc, r1, r6, lsl r2	; <UNPREDICTABLE>
    30e4:	093c0600 	ldmdbeq	ip!, {r9, sl}
    30e8:	000019c8 	andeq	r1, r0, r8, asr #19
    30ec:	000006ea 	andeq	r0, r0, sl, ror #13
    30f0:	0004ff01 	andeq	pc, r4, r1, lsl #30
    30f4:	00050500 	andeq	r0, r5, r0, lsl #10
    30f8:	06ea1300 	strbteq	r1, [sl], r0, lsl #6
    30fc:	16000000 	strne	r0, [r0], -r0
    3100:	00000a93 	muleq	r0, r3, sl
    3104:	3d123d06 	ldccc	13, cr3, [r2, #-24]	; 0xffffffe8
    3108:	4d000015 	stcmi	0, cr0, [r0, #-84]	; 0xffffffac
    310c:	01000000 	mrseq	r0, (UNDEF: 0)
    3110:	0000051e 	andeq	r0, r0, lr, lsl r5
    3114:	00000529 	andeq	r0, r0, r9, lsr #10
    3118:	0006ea13 	andeq	lr, r6, r3, lsl sl
    311c:	004d1400 	subeq	r1, sp, r0, lsl #8
    3120:	16000000 	strne	r0, [r0], -r0
    3124:	000011a2 	andeq	r1, r0, r2, lsr #3
    3128:	0d123f06 	ldceq	15, cr3, [r2, #-24]	; 0xffffffe8
    312c:	4d000019 	stcmi	0, cr0, [r0, #-100]	; 0xffffff9c
    3130:	01000000 	mrseq	r0, (UNDEF: 0)
    3134:	00000542 	andeq	r0, r0, r2, asr #10
    3138:	00000557 	andeq	r0, r0, r7, asr r5
    313c:	0006ea13 	andeq	lr, r6, r3, lsl sl
    3140:	070c1400 	streq	r1, [ip, -r0, lsl #8]
    3144:	5e140000 	cdppl	0, 1, cr0, cr4, cr0, {0}
    3148:	14000000 	strne	r0, [r0], #-0
    314c:	000001fc 	strdeq	r0, [r0], -ip
    3150:	15d41800 	ldrbne	r1, [r4, #2048]	; 0x800
    3154:	41060000 	mrsmi	r0, (UNDEF: 6)
    3158:	0013990e 	andseq	r9, r3, lr, lsl #18
    315c:	056c0100 	strbeq	r0, [ip, #-256]!	; 0xffffff00
    3160:	05720000 	ldrbeq	r0, [r2, #-0]!
    3164:	ea130000 	b	4c316c <__bss_end+0x4b6e2c>
    3168:	00000006 	andeq	r0, r0, r6
    316c:	00185f18 	andseq	r5, r8, r8, lsl pc
    3170:	0e430600 	cdpeq	6, 4, cr0, cr3, cr0, {0}
    3174:	0000163c 	andeq	r1, r0, ip, lsr r6
    3178:	00058701 	andeq	r8, r5, r1, lsl #14
    317c:	00058d00 	andeq	r8, r5, r0, lsl #26
    3180:	06ea1300 	strbteq	r1, [sl], r0, lsl #6
    3184:	16000000 	strne	r0, [r0], -r0
    3188:	000013dd 	ldrdeq	r1, [r0], -sp
    318c:	1c174606 	ldcne	6, cr4, [r7], {6}
    3190:	1e000011 	mcrne	0, 0, r0, cr0, cr1, {0}
    3194:	01000004 	tsteq	r0, r4
    3198:	000005a6 	andeq	r0, r0, r6, lsr #11
    319c:	000005ac 	andeq	r0, r0, ip, lsr #11
    31a0:	00071213 	andeq	r1, r7, r3, lsl r2
    31a4:	4f160000 	svcmi	0x00160000
    31a8:	06000011 			; <UNDEFINED> instruction: 0x06000011
    31ac:	17d71749 	ldrbne	r1, [r7, r9, asr #14]
    31b0:	041e0000 	ldreq	r0, [lr], #-0
    31b4:	c5010000 	strgt	r0, [r1, #-0]
    31b8:	d0000005 	andle	r0, r0, r5
    31bc:	13000005 	movwne	r0, #5
    31c0:	00000712 	andeq	r0, r0, r2, lsl r7
    31c4:	00004d14 	andeq	r4, r0, r4, lsl sp
    31c8:	16180000 	ldrne	r0, [r8], -r0
    31cc:	06000014 			; <UNDEFINED> instruction: 0x06000014
    31d0:	10970e4c 	addsne	r0, r7, ip, asr #28
    31d4:	e5010000 	str	r0, [r1, #-0]
    31d8:	eb000005 	bl	31f4 <shift+0x31f4>
    31dc:	13000005 	movwne	r0, #5
    31e0:	000006ea 	andeq	r0, r0, sl, ror #13
    31e4:	18501600 	ldmdane	r0, {r9, sl, ip}^
    31e8:	4e060000 	cdpmi	0, 0, cr0, cr6, cr0, {0}
    31ec:	0012d50e 	andseq	sp, r2, lr, lsl #10
    31f0:	0001fc00 	andeq	pc, r1, r0, lsl #24
    31f4:	06040100 	streq	r0, [r4], -r0, lsl #2
    31f8:	060f0000 	streq	r0, [pc], -r0
    31fc:	ea130000 	b	4c3204 <__bss_end+0x4b6ec4>
    3200:	14000006 	strne	r0, [r0], #-6
    3204:	0000004d 	andeq	r0, r0, sp, asr #32
    3208:	14021600 	strne	r1, [r2], #-1536	; 0xfffffa00
    320c:	51060000 	mrspl	r0, (UNDEF: 6)
    3210:	00165d12 	andseq	r5, r6, r2, lsl sp
    3214:	00004d00 	andeq	r4, r0, r0, lsl #26
    3218:	06280100 	strteq	r0, [r8], -r0, lsl #2
    321c:	06330000 	ldrteq	r0, [r3], -r0
    3220:	ea130000 	b	4c3228 <__bss_end+0x4b6ee8>
    3224:	14000006 	strne	r0, [r0], #-6
    3228:	00000209 	andeq	r0, r0, r9, lsl #4
    322c:	10de1600 	sbcsne	r1, lr, r0, lsl #12
    3230:	54060000 	strpl	r0, [r6], #-0
    3234:	0013170e 	andseq	r1, r3, lr, lsl #14
    3238:	0001fc00 	andeq	pc, r1, r0, lsl #24
    323c:	064c0100 	strbeq	r0, [ip], -r0, lsl #2
    3240:	06570000 	ldrbeq	r0, [r7], -r0
    3244:	ea130000 	b	4c324c <__bss_end+0x4b6f0c>
    3248:	14000006 	strne	r0, [r0], #-6
    324c:	0000004d 	andeq	r0, r0, sp, asr #32
    3250:	14591800 	ldrbne	r1, [r9], #-2048	; 0xfffff800
    3254:	57060000 	strpl	r0, [r6, -r0]
    3258:	0018aa0e 	andseq	sl, r8, lr, lsl #20
    325c:	066c0100 	strbteq	r0, [ip], -r0, lsl #2
    3260:	068b0000 	streq	r0, [fp], r0
    3264:	ea130000 	b	4c326c <__bss_end+0x4b6f2c>
    3268:	14000006 	strne	r0, [r0], #-6
    326c:	000000a9 	andeq	r0, r0, r9, lsr #1
    3270:	00004d14 	andeq	r4, r0, r4, lsl sp
    3274:	004d1400 	subeq	r1, sp, r0, lsl #8
    3278:	4d140000 	ldcmi	0, cr0, [r4, #-0]
    327c:	14000000 	strne	r0, [r0], #-0
    3280:	00000718 	andeq	r0, r0, r8, lsl r7
    3284:	18041800 	stmdane	r4, {fp, ip}
    3288:	59060000 	stmdbpl	r6, {}	; <UNPREDICTABLE>
    328c:	0012460e 	andseq	r4, r2, lr, lsl #12
    3290:	06a00100 	strteq	r0, [r0], r0, lsl #2
    3294:	06bf0000 	ldrteq	r0, [pc], r0
    3298:	ea130000 	b	4c32a0 <__bss_end+0x4b6f60>
    329c:	14000006 	strne	r0, [r0], #-6
    32a0:	000000ec 	andeq	r0, r0, ip, ror #1
    32a4:	00004d14 	andeq	r4, r0, r4, lsl sp
    32a8:	004d1400 	subeq	r1, sp, r0, lsl #8
    32ac:	4d140000 	ldcmi	0, cr0, [r4, #-0]
    32b0:	14000000 	strne	r0, [r0], #-0
    32b4:	00000718 	andeq	r0, r0, r8, lsl r7
    32b8:	11df1900 	bicsne	r1, pc, r0, lsl #18
    32bc:	5c060000 	stcpl	0, cr0, [r6], {-0}
    32c0:	0012030e 	andseq	r0, r2, lr, lsl #6
    32c4:	0001fc00 	andeq	pc, r1, r0, lsl #24
    32c8:	06d40100 	ldrbeq	r0, [r4], r0, lsl #2
    32cc:	ea130000 	b	4c32d4 <__bss_end+0x4b6f94>
    32d0:	14000006 	strne	r0, [r0], #-6
    32d4:	0000039b 	muleq	r0, fp, r3
    32d8:	00071e14 	andeq	r1, r7, r4, lsl lr
    32dc:	03000000 	movweq	r0, #0
    32e0:	00000424 	andeq	r0, r0, r4, lsr #8
    32e4:	0424040d 	strteq	r0, [r4], #-1037	; 0xfffffbf3
    32e8:	181a0000 	ldmdane	sl, {}	; <UNPREDICTABLE>
    32ec:	fd000004 	stc2	0, cr0, [r0, #-16]
    32f0:	03000006 	movweq	r0, #6
    32f4:	13000007 	movwne	r0, #7
    32f8:	000006ea 	andeq	r0, r0, sl, ror #13
    32fc:	04241b00 	strteq	r1, [r4], #-2816	; 0xfffff500
    3300:	06f00000 	ldrbteq	r0, [r0], r0
    3304:	040d0000 	streq	r0, [sp], #-0
    3308:	0000003f 	andeq	r0, r0, pc, lsr r0
    330c:	06e5040d 	strbteq	r0, [r5], sp, lsl #8
    3310:	041c0000 	ldreq	r0, [ip], #-0
    3314:	00000065 	andeq	r0, r0, r5, rrx
    3318:	2c0f041d 	cfstrscs	mvf0, [pc], {29}
    331c:	30000000 	andcc	r0, r0, r0
    3320:	10000007 	andne	r0, r0, r7
    3324:	0000005e 	andeq	r0, r0, lr, asr r0
    3328:	20030009 	andcs	r0, r3, r9
    332c:	1e000007 	cdpne	0, 0, cr0, cr0, cr7, {0}
    3330:	000013f1 	strdeq	r1, [r0], -r1	; <UNPREDICTABLE>
    3334:	300ca501 	andcc	sl, ip, r1, lsl #10
    3338:	05000007 	streq	r0, [r0, #-7]
    333c:	00c2f803 	sbceq	pc, r2, r3, lsl #16
    3340:	11171f00 	tstne	r7, r0, lsl #30
    3344:	a7010000 	strge	r0, [r1, -r0]
    3348:	0015890a 	andseq	r8, r5, sl, lsl #18
    334c:	00004d00 	andeq	r4, r0, r0, lsl #26
    3350:	00a8ec00 	adceq	lr, r8, r0, lsl #24
    3354:	0000b000 	andeq	fp, r0, r0
    3358:	a59c0100 	ldrge	r0, [ip, #256]	; 0x100
    335c:	20000007 	andcs	r0, r0, r7
    3360:	0000197f 	andeq	r1, r0, pc, ror r9
    3364:	031ba701 	tsteq	fp, #262144	; 0x40000
    3368:	03000002 	movweq	r0, #2
    336c:	207fac91 			; <UNDEFINED> instruction: 0x207fac91
    3370:	000015fc 	strdeq	r1, [r0], -ip
    3374:	4d2aa701 	stcmi	7, cr10, [sl, #-4]!
    3378:	03000000 	movweq	r0, #0
    337c:	1e7fa891 	mrcne	8, 3, sl, cr15, cr1, {4}
    3380:	00001504 	andeq	r1, r0, r4, lsl #10
    3384:	a50aa901 	strge	sl, [sl, #-2305]	; 0xfffff6ff
    3388:	03000007 	movweq	r0, #7
    338c:	1e7fb491 	mrcne	4, 3, fp, cr15, cr1, {4}
    3390:	000010f8 	strdeq	r1, [r0], -r8
    3394:	3809ad01 	stmdacc	r9, {r0, r8, sl, fp, sp, pc}
    3398:	02000000 	andeq	r0, r0, #0
    339c:	0f007491 	svceq	0x00007491
    33a0:	00000025 	andeq	r0, r0, r5, lsr #32
    33a4:	000007b5 			; <UNDEFINED> instruction: 0x000007b5
    33a8:	00005e10 	andeq	r5, r0, r0, lsl lr
    33ac:	21003f00 	tstcs	r0, r0, lsl #30
    33b0:	000015e1 	andeq	r1, r0, r1, ror #11
    33b4:	f10a9901 			; <UNDEFINED> instruction: 0xf10a9901
    33b8:	4d000016 	stcmi	0, cr0, [r0, #-88]	; 0xffffffa8
    33bc:	b0000000 	andlt	r0, r0, r0
    33c0:	3c0000a8 	stccc	0, cr0, [r0], {168}	; 0xa8
    33c4:	01000000 	mrseq	r0, (UNDEF: 0)
    33c8:	0007f29c 	muleq	r7, ip, r2
    33cc:	65722200 	ldrbvs	r2, [r2, #-512]!	; 0xfffffe00
    33d0:	9b010071 	blls	4359c <__bss_end+0x3725c>
    33d4:	0003de20 	andeq	sp, r3, r0, lsr #28
    33d8:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    33dc:	0015701e 	andseq	r7, r5, lr, lsl r0
    33e0:	0e9c0100 	fmleqe	f0, f4, f0
    33e4:	0000004d 	andeq	r0, r0, sp, asr #32
    33e8:	00709102 	rsbseq	r9, r0, r2, lsl #2
    33ec:	00162a23 	andseq	r2, r6, r3, lsr #20
    33f0:	06900100 	ldreq	r0, [r0], r0, lsl #2
    33f4:	000011b1 			; <UNDEFINED> instruction: 0x000011b1
    33f8:	0000a874 	andeq	sl, r0, r4, ror r8
    33fc:	0000003c 	andeq	r0, r0, ip, lsr r0
    3400:	082b9c01 	stmdaeq	fp!, {r0, sl, fp, ip, pc}
    3404:	85200000 	strhi	r0, [r0, #-0]!
    3408:	01000013 	tsteq	r0, r3, lsl r0
    340c:	004d2190 	umaaleq	r2, sp, r0, r1
    3410:	91020000 	mrsls	r0, (UNDEF: 2)
    3414:	6572226c 	ldrbvs	r2, [r2, #-620]!	; 0xfffffd94
    3418:	92010071 	andls	r0, r1, #113	; 0x71
    341c:	0003de20 	andeq	sp, r3, r0, lsr #28
    3420:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    3424:	15aa2100 	strne	r2, [sl, #256]!	; 0x100
    3428:	84010000 	strhi	r0, [r1], #-0
    342c:	0014370a 	andseq	r3, r4, sl, lsl #14
    3430:	00004d00 	andeq	r4, r0, r0, lsl #26
    3434:	00a83800 	adceq	r3, r8, r0, lsl #16
    3438:	00003c00 	andeq	r3, r0, r0, lsl #24
    343c:	689c0100 	ldmvs	ip, {r8}
    3440:	22000008 	andcs	r0, r0, #8
    3444:	00716572 	rsbseq	r6, r1, r2, ror r5
    3448:	ba208601 	blt	824c54 <__bss_end+0x818914>
    344c:	02000003 	andeq	r0, r0, #3
    3450:	f11e7491 			; <UNDEFINED> instruction: 0xf11e7491
    3454:	01000010 	tsteq	r0, r0, lsl r0
    3458:	004d0e87 	subeq	r0, sp, r7, lsl #29
    345c:	91020000 	mrsls	r0, (UNDEF: 2)
    3460:	62210070 	eorvs	r0, r1, #112	; 0x70
    3464:	01000019 	tsteq	r0, r9, lsl r0
    3468:	13bf0a78 			; <UNDEFINED> instruction: 0x13bf0a78
    346c:	004d0000 	subeq	r0, sp, r0
    3470:	a7fc0000 	ldrbge	r0, [ip, r0]!
    3474:	003c0000 	eorseq	r0, ip, r0
    3478:	9c010000 	stcls	0, cr0, [r1], {-0}
    347c:	000008a5 	andeq	r0, r0, r5, lsr #17
    3480:	71657222 	cmnvc	r5, r2, lsr #4
    3484:	207a0100 	rsbscs	r0, sl, r0, lsl #2
    3488:	000003ba 			; <UNDEFINED> instruction: 0x000003ba
    348c:	1e749102 	expnes	f1, f2
    3490:	000010f1 	strdeq	r1, [r0], -r1	; <UNPREDICTABLE>
    3494:	4d0e7b01 	vstrmi	d7, [lr, #-4]
    3498:	02000000 	andeq	r0, r0, #0
    349c:	21007091 	swpcs	r7, r1, [r0]
    34a0:	0000146c 	andeq	r1, r0, ip, ror #8
    34a4:	c1066c01 	tstgt	r6, r1, lsl #24
    34a8:	fc000016 	stc2	0, cr0, [r0], {22}
    34ac:	a8000001 	stmdage	r0, {r0}
    34b0:	540000a7 	strpl	r0, [r0], #-167	; 0xffffff59
    34b4:	01000000 	mrseq	r0, (UNDEF: 0)
    34b8:	0008f19c 	muleq	r8, ip, r1
    34bc:	15702000 	ldrbne	r2, [r0, #-0]!
    34c0:	6c010000 	stcvs	0, cr0, [r1], {-0}
    34c4:	00004d15 	andeq	r4, r0, r5, lsl sp
    34c8:	6c910200 	lfmvs	f0, 4, [r1], {0}
    34cc:	00130520 	andseq	r0, r3, r0, lsr #10
    34d0:	256c0100 	strbcs	r0, [ip, #-256]!	; 0xffffff00
    34d4:	0000004d 	andeq	r0, r0, sp, asr #32
    34d8:	1e689102 	lgnnee	f1, f2
    34dc:	0000195a 	andeq	r1, r0, sl, asr r9
    34e0:	4d0e6e01 	stcmi	14, cr6, [lr, #-4]
    34e4:	02000000 	andeq	r0, r0, #0
    34e8:	21007491 			; <UNDEFINED> instruction: 0x21007491
    34ec:	000011c8 	andeq	r1, r0, r8, asr #3
    34f0:	60125f01 	andsvs	r5, r2, r1, lsl #30
    34f4:	8b000017 	blhi	3558 <shift+0x3558>
    34f8:	58000000 	stmdapl	r0, {}	; <UNPREDICTABLE>
    34fc:	500000a7 	andpl	r0, r0, r7, lsr #1
    3500:	01000000 	mrseq	r0, (UNDEF: 0)
    3504:	00094c9c 	muleq	r9, ip, ip
    3508:	09302000 	ldmdbeq	r0!, {sp}
    350c:	5f010000 	svcpl	0x00010000
    3510:	00004d20 	andeq	r4, r0, r0, lsr #26
    3514:	6c910200 	lfmvs	f0, 4, [r1], {0}
    3518:	00072f20 	andeq	r2, r7, r0, lsr #30
    351c:	2f5f0100 	svccs	0x005f0100
    3520:	0000004d 	andeq	r0, r0, sp, asr #32
    3524:	20689102 	rsbcs	r9, r8, r2, lsl #2
    3528:	00001305 	andeq	r1, r0, r5, lsl #6
    352c:	4d3f5f01 	ldcmi	15, cr5, [pc, #-4]!	; 3530 <shift+0x3530>
    3530:	02000000 	andeq	r0, r0, #0
    3534:	5a1e6491 	bpl	79c780 <__bss_end+0x790440>
    3538:	01000019 	tsteq	r0, r9, lsl r0
    353c:	008b1661 	addeq	r1, fp, r1, ror #12
    3540:	91020000 	mrsls	r0, (UNDEF: 2)
    3544:	a9210074 	stmdbge	r1!, {r2, r4, r5, r6}
    3548:	01000017 	tsteq	r0, r7, lsl r0
    354c:	11d30a53 	bicsne	r0, r3, r3, asr sl
    3550:	004d0000 	subeq	r0, sp, r0
    3554:	a7140000 	ldrge	r0, [r4, -r0]
    3558:	00440000 	subeq	r0, r4, r0
    355c:	9c010000 	stcls	0, cr0, [r1], {-0}
    3560:	00000998 	muleq	r0, r8, r9
    3564:	00093020 	andeq	r3, r9, r0, lsr #32
    3568:	1a530100 	bne	14c3970 <__bss_end+0x14b7630>
    356c:	0000004d 	andeq	r0, r0, sp, asr #32
    3570:	206c9102 	rsbcs	r9, ip, r2, lsl #2
    3574:	0000072f 	andeq	r0, r0, pc, lsr #14
    3578:	4d295301 	stcmi	3, cr5, [r9, #-4]!
    357c:	02000000 	andeq	r0, r0, #0
    3580:	8f1e6891 	svchi	0x001e6891
    3584:	01000017 	tsteq	r0, r7, lsl r0
    3588:	004d0e55 	subeq	r0, sp, r5, asr lr
    358c:	91020000 	mrsls	r0, (UNDEF: 2)
    3590:	89210074 	stmdbhi	r1!, {r2, r4, r5, r6}
    3594:	01000017 	tsteq	r0, r7, lsl r0
    3598:	176b0a46 	strbne	r0, [fp, -r6, asr #20]!
    359c:	004d0000 	subeq	r0, sp, r0
    35a0:	a6c40000 	strbge	r0, [r4], r0
    35a4:	00500000 	subseq	r0, r0, r0
    35a8:	9c010000 	stcls	0, cr0, [r1], {-0}
    35ac:	000009f3 	strdeq	r0, [r0], -r3
    35b0:	00093020 	andeq	r3, r9, r0, lsr #32
    35b4:	19460100 	stmdbne	r6, {r8}^
    35b8:	0000004d 	andeq	r0, r0, sp, asr #32
    35bc:	206c9102 	rsbcs	r9, ip, r2, lsl #2
    35c0:	000014be 			; <UNDEFINED> instruction: 0x000014be
    35c4:	29304601 	ldmdbcs	r0!, {r0, r9, sl, lr}
    35c8:	02000001 	andeq	r0, r0, #1
    35cc:	c0206891 	mlagt	r0, r1, r8, r6
    35d0:	01000015 	tsteq	r0, r5, lsl r0
    35d4:	071e4146 	ldreq	r4, [lr, -r6, asr #2]
    35d8:	91020000 	mrsls	r0, (UNDEF: 2)
    35dc:	195a1e64 	ldmdbne	sl, {r2, r5, r6, r9, sl, fp, ip}^
    35e0:	48010000 	stmdami	r1, {}	; <UNPREDICTABLE>
    35e4:	00004d0e 	andeq	r4, r0, lr, lsl #26
    35e8:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    35ec:	10c62300 	sbcne	r2, r6, r0, lsl #6
    35f0:	40010000 	andmi	r0, r1, r0
    35f4:	0014c806 	andseq	ip, r4, r6, lsl #16
    35f8:	00a69800 	adceq	r9, r6, r0, lsl #16
    35fc:	00002c00 	andeq	r2, r0, r0, lsl #24
    3600:	1d9c0100 	ldfnes	f0, [ip]
    3604:	2000000a 	andcs	r0, r0, sl
    3608:	00000930 	andeq	r0, r0, r0, lsr r9
    360c:	4d154001 	ldcmi	0, cr4, [r5, #-4]
    3610:	02000000 	andeq	r0, r0, #0
    3614:	21007491 			; <UNDEFINED> instruction: 0x21007491
    3618:	0000152d 	andeq	r1, r0, sp, lsr #10
    361c:	c60a3301 	strgt	r3, [sl], -r1, lsl #6
    3620:	4d000015 	stcmi	0, cr0, [r0, #-84]	; 0xffffffac
    3624:	48000000 	stmdami	r0, {}	; <UNPREDICTABLE>
    3628:	500000a6 	andpl	r0, r0, r6, lsr #1
    362c:	01000000 	mrseq	r0, (UNDEF: 0)
    3630:	000a789c 	muleq	sl, ip, r8
    3634:	09302000 	ldmdbeq	r0!, {sp}
    3638:	33010000 	movwcc	r0, #4096	; 0x1000
    363c:	00004d19 	andeq	r4, r0, r9, lsl sp
    3640:	6c910200 	lfmvs	f0, 4, [r1], {0}
    3644:	000d6d20 	andeq	r6, sp, r0, lsr #26
    3648:	2b330100 	blcs	cc3a50 <__bss_end+0xcb7710>
    364c:	00000203 	andeq	r0, r0, r3, lsl #4
    3650:	20689102 	rsbcs	r9, r8, r2, lsl #2
    3654:	00001600 	andeq	r1, r0, r0, lsl #12
    3658:	4d3c3301 	ldcmi	3, cr3, [ip, #-4]!
    365c:	02000000 	andeq	r0, r0, #0
    3660:	5a1e6491 	bpl	79c8ac <__bss_end+0x79056c>
    3664:	01000017 	tsteq	r0, r7, lsl r0
    3668:	004d0e35 	subeq	r0, sp, r5, lsr lr
    366c:	91020000 	mrsls	r0, (UNDEF: 2)
    3670:	89210074 	stmdbhi	r1!, {r2, r4, r5, r6}
    3674:	01000019 	tsteq	r0, r9, lsl r0
    3678:	18440a25 	stmdane	r4, {r0, r2, r5, r9, fp}^
    367c:	004d0000 	subeq	r0, sp, r0
    3680:	a5f80000 	ldrbge	r0, [r8, #0]!
    3684:	00500000 	subseq	r0, r0, r0
    3688:	9c010000 	stcls	0, cr0, [r1], {-0}
    368c:	00000ad3 	ldrdeq	r0, [r0], -r3
    3690:	00093020 	andeq	r3, r9, r0, lsr #32
    3694:	18250100 	stmdane	r5!, {r8}
    3698:	0000004d 	andeq	r0, r0, sp, asr #32
    369c:	206c9102 	rsbcs	r9, ip, r2, lsl #2
    36a0:	00000d6d 	andeq	r0, r0, sp, ror #26
    36a4:	d92a2501 	stmdble	sl!, {r0, r8, sl, sp}
    36a8:	0200000a 	andeq	r0, r0, #10
    36ac:	00206891 	mlaeq	r0, r1, r8, r6
    36b0:	01000016 	tsteq	r0, r6, lsl r0
    36b4:	004d3b25 	subeq	r3, sp, r5, lsr #22
    36b8:	91020000 	mrsls	r0, (UNDEF: 2)
    36bc:	0f8d1e64 	svceq	0x008d1e64
    36c0:	27010000 	strcs	r0, [r1, -r0]
    36c4:	00004d0e 	andeq	r4, r0, lr, lsl #26
    36c8:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    36cc:	25040d00 	strcs	r0, [r4, #-3328]	; 0xfffff300
    36d0:	03000000 	movweq	r0, #0
    36d4:	00000ad3 	ldrdeq	r0, [r0], -r3
    36d8:	00158421 	andseq	r8, r5, r1, lsr #8
    36dc:	0a190100 	beq	643ae4 <__bss_end+0x6377a4>
    36e0:	000019a6 	andeq	r1, r0, r6, lsr #19
    36e4:	0000004d 	andeq	r0, r0, sp, asr #32
    36e8:	0000a5b4 			; <UNDEFINED> instruction: 0x0000a5b4
    36ec:	00000044 	andeq	r0, r0, r4, asr #32
    36f0:	0b2a9c01 	bleq	aaa6fc <__bss_end+0xa9e3bc>
    36f4:	7b200000 	blvc	8036fc <__bss_end+0x7f73bc>
    36f8:	01000019 	tsteq	r0, r9, lsl r0
    36fc:	02031b19 	andeq	r1, r3, #25600	; 0x6400
    3700:	91020000 	mrsls	r0, (UNDEF: 2)
    3704:	17ba206c 	ldrne	r2, [sl, ip, rrx]!
    3708:	19010000 	stmdbne	r1, {}	; <UNPREDICTABLE>
    370c:	0001d235 	andeq	sp, r1, r5, lsr r2
    3710:	68910200 	ldmvs	r1, {r9}
    3714:	0009301e 	andeq	r3, r9, lr, lsl r0
    3718:	0e1b0100 	mufeqe	f0, f3, f0
    371c:	0000004d 	andeq	r0, r0, sp, asr #32
    3720:	00749102 	rsbseq	r9, r4, r2, lsl #2
    3724:	00137924 	andseq	r7, r3, r4, lsr #18
    3728:	06140100 	ldreq	r0, [r4], -r0, lsl #2
    372c:	00001162 	andeq	r1, r0, r2, ror #2
    3730:	0000a598 	muleq	r0, r8, r5
    3734:	0000001c 	andeq	r0, r0, ip, lsl r0
    3738:	b0239c01 	eorlt	r9, r3, r1, lsl #24
    373c:	01000017 	tsteq	r0, r7, lsl r0
    3740:	149c060e 	ldrne	r0, [ip], #1550	; 0x60e
    3744:	a56c0000 	strbge	r0, [ip, #-0]!
    3748:	002c0000 	eoreq	r0, ip, r0
    374c:	9c010000 	stcls	0, cr0, [r1], {-0}
    3750:	00000b6a 	andeq	r0, r0, sl, ror #22
    3754:	0012c620 	andseq	ip, r2, r0, lsr #12
    3758:	140e0100 	strne	r0, [lr], #-256	; 0xffffff00
    375c:	00000038 	andeq	r0, r0, r8, lsr r0
    3760:	00749102 	rsbseq	r9, r4, r2, lsl #2
    3764:	00199f25 	andseq	r9, r9, r5, lsr #30
    3768:	0a040100 	beq	103b70 <__bss_end+0xf7830>
    376c:	000014f9 	strdeq	r1, [r0], -r9
    3770:	0000004d 	andeq	r0, r0, sp, asr #32
    3774:	0000a540 	andeq	sl, r0, r0, asr #10
    3778:	0000002c 	andeq	r0, r0, ip, lsr #32
    377c:	70229c01 	eorvc	r9, r2, r1, lsl #24
    3780:	01006469 	tsteq	r0, r9, ror #8
    3784:	004d0e06 	subeq	r0, sp, r6, lsl #28
    3788:	91020000 	mrsls	r0, (UNDEF: 2)
    378c:	2d000074 	stccs	0, cr0, [r0, #-464]	; 0xfffffe30
    3790:	04000006 	streq	r0, [r0], #-6
    3794:	0010d300 	andseq	sp, r0, r0, lsl #6
    3798:	dc010400 	cfstrsle	mvf0, [r1], {-0}
    379c:	0400000e 	streq	r0, [r0], #-14
    37a0:	00001a91 	muleq	r0, r1, sl
    37a4:	00000e79 	andeq	r0, r0, r9, ror lr
    37a8:	0000a9a0 	andeq	sl, r0, r0, lsr #19
    37ac:	00000c5c 	andeq	r0, r0, ip, asr ip
    37b0:	00001842 	andeq	r1, r0, r2, asr #16
    37b4:	00004902 	andeq	r4, r0, r2, lsl #18
    37b8:	1aee0300 	bne	ffb843c0 <__bss_end+0xffb78080>
    37bc:	05010000 	streq	r0, [r1, #-0]
    37c0:	00006110 	andeq	r6, r0, r0, lsl r1
    37c4:	31301100 	teqcc	r0, r0, lsl #2
    37c8:	35343332 	ldrcc	r3, [r4, #-818]!	; 0xfffffcce
    37cc:	39383736 	ldmdbcc	r8!, {r1, r2, r4, r5, r8, r9, sl, ip, sp}
    37d0:	44434241 	strbmi	r4, [r3], #-577	; 0xfffffdbf
    37d4:	00004645 	andeq	r4, r0, r5, asr #12
    37d8:	01030104 	tsteq	r3, r4, lsl #2
    37dc:	00000025 	andeq	r0, r0, r5, lsr #32
    37e0:	00007405 	andeq	r7, r0, r5, lsl #8
    37e4:	00006100 	andeq	r6, r0, r0, lsl #2
    37e8:	00660600 	rsbeq	r0, r6, r0, lsl #12
    37ec:	00100000 	andseq	r0, r0, r0
    37f0:	00005107 	andeq	r5, r0, r7, lsl #2
    37f4:	07040800 	streq	r0, [r4, -r0, lsl #16]
    37f8:	00001fe3 	andeq	r1, r0, r3, ror #31
    37fc:	a8080108 	stmdage	r8, {r3, r8}
    3800:	07000008 	streq	r0, [r0, -r8]
    3804:	0000006d 	andeq	r0, r0, sp, rrx
    3808:	00002a09 	andeq	r2, r0, r9, lsl #20
    380c:	1afa0a00 	bne	ffe86014 <__bss_end+0xffe79cd4>
    3810:	d2010000 	andle	r0, r1, #0
    3814:	001b8f06 	andseq	r8, fp, r6, lsl #30
    3818:	00b2d400 	adcseq	sp, r2, r0, lsl #8
    381c:	00032800 	andeq	r2, r3, r0, lsl #16
    3820:	1f9c0100 	svcne	0x009c0100
    3824:	0b000001 	bleq	3830 <shift+0x3830>
    3828:	d2010066 	andle	r0, r1, #102	; 0x66
    382c:	00011f11 	andeq	r1, r1, r1, lsl pc
    3830:	a4910300 	ldrge	r0, [r1], #768	; 0x300
    3834:	00720b7f 	rsbseq	r0, r2, pc, ror fp
    3838:	2619d201 	ldrcs	sp, [r9], -r1, lsl #4
    383c:	03000001 	movweq	r0, #1
    3840:	0c7fa091 	ldcleq	0, cr10, [pc], #-580	; 3604 <shift+0x3604>
    3844:	00001ba1 	andeq	r1, r0, r1, lsr #23
    3848:	2c13d401 	cfldrscs	mvf13, [r3], {1}
    384c:	02000001 	andeq	r0, r0, #1
    3850:	4c0c5891 	stcmi	8, cr5, [ip], {145}	; 0x91
    3854:	0100001b 	tsteq	r0, fp, lsl r0
    3858:	012c1bd4 	ldrdeq	r1, [ip, -r4]!
    385c:	91020000 	mrsls	r0, (UNDEF: 2)
    3860:	00690d50 	rsbeq	r0, r9, r0, asr sp
    3864:	2c24d401 	cfstrscs	mvf13, [r4], #-4
    3868:	02000001 	andeq	r0, r0, #1
    386c:	ff0c4891 			; <UNDEFINED> instruction: 0xff0c4891
    3870:	0100001a 	tsteq	r0, sl, lsl r0
    3874:	012c27d4 	ldrdeq	r2, [ip, -r4]!
    3878:	91020000 	mrsls	r0, (UNDEF: 2)
    387c:	1ade0c40 	bne	ff786984 <__bss_end+0xff77a644>
    3880:	d4010000 	strle	r0, [r1], #-0
    3884:	00012c2f 	andeq	r2, r1, pc, lsr #24
    3888:	b8910300 	ldmlt	r1, {r8, r9}
    388c:	1a620c7f 	bne	1886a90 <__bss_end+0x187a750>
    3890:	d4010000 	strle	r0, [r1], #-0
    3894:	00012c39 	andeq	r2, r1, r9, lsr ip
    3898:	b0910300 	addslt	r0, r1, r0, lsl #6
    389c:	1b0d0c7f 	blne	346aa0 <__bss_end+0x33a760>
    38a0:	d5010000 	strle	r0, [r1, #-0]
    38a4:	00011f0b 	andeq	r1, r1, fp, lsl #30
    38a8:	ac910300 	ldcge	3, cr0, [r1], {0}
    38ac:	0408007f 	streq	r0, [r8], #-127	; 0xffffff81
    38b0:	001cea04 	andseq	lr, ip, r4, lsl #20
    38b4:	6d040e00 	stcvs	14, cr0, [r4, #-0]
    38b8:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    38bc:	02430508 	subeq	r0, r3, #8, 10	; 0x2000000
    38c0:	540f0000 	strpl	r0, [pc], #-0	; 38c8 <shift+0x38c8>
    38c4:	0100001b 	tsteq	r0, fp, lsl r0
    38c8:	1a2905c8 	bne	a44ff0 <__bss_end+0xa38cb0>
    38cc:	017f0000 	cmneq	pc, r0
    38d0:	b26c0000 	rsblt	r0, ip, #0
    38d4:	00680000 	rsbeq	r0, r8, r0
    38d8:	9c010000 	stcls	0, cr0, [r1], {-0}
    38dc:	0000017f 	andeq	r0, r0, pc, ror r1
    38e0:	001aff10 	andseq	pc, sl, r0, lsl pc	; <UNPREDICTABLE>
    38e4:	0ec80100 	poleqe	f0, f0, f0
    38e8:	0000017f 	andeq	r0, r0, pc, ror r1
    38ec:	106c9102 	rsbne	r9, ip, r2, lsl #2
    38f0:	0000072f 	andeq	r0, r0, pc, lsr #14
    38f4:	7f1ac801 	svcvc	0x001ac801
    38f8:	02000001 	andeq	r0, r0, #1
    38fc:	250c6891 	strcs	r6, [ip, #-2193]	; 0xfffff76f
    3900:	01000001 	tsteq	r0, r1
    3904:	017f09ca 	cmneq	pc, sl, asr #19
    3908:	91020000 	mrsls	r0, (UNDEF: 2)
    390c:	04110074 	ldreq	r0, [r1], #-116	; 0xffffff8c
    3910:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
    3914:	1b291200 	blne	a4811c <__bss_end+0xa3bddc>
    3918:	bd010000 	stclt	0, cr0, [r1, #-0]
    391c:	001a0306 	andseq	r0, sl, r6, lsl #6
    3920:	00b1ec00 	adcseq	lr, r1, r0, lsl #24
    3924:	00008000 	andeq	r8, r0, r0
    3928:	039c0100 	orrseq	r0, ip, #0, 2
    392c:	0b000002 	bleq	393c <shift+0x393c>
    3930:	00637273 	rsbeq	r7, r3, r3, ror r2
    3934:	0319bd01 	tsteq	r9, #1, 26	; 0x40
    3938:	02000002 	andeq	r0, r0, #2
    393c:	640b6491 	strvs	r6, [fp], #-1169	; 0xfffffb6f
    3940:	01007473 	tsteq	r0, r3, ror r4
    3944:	020a24bd 	andeq	r2, sl, #-1124073472	; 0xbd000000
    3948:	91020000 	mrsls	r0, (UNDEF: 2)
    394c:	756e0b60 	strbvc	r0, [lr, #-2912]!	; 0xfffff4a0
    3950:	bd01006d 	stclt	0, cr0, [r1, #-436]	; 0xfffffe4c
    3954:	00017f2d 	andeq	r7, r1, sp, lsr #30
    3958:	5c910200 	lfmpl	f0, 4, [r1], {0}
    395c:	001b060c 	andseq	r0, fp, ip, lsl #12
    3960:	0ebf0100 	frdeqe	f0, f7, f0
    3964:	0000020c 	andeq	r0, r0, ip, lsl #4
    3968:	0c709102 	ldfeqp	f1, [r0], #-8
    396c:	00001ae7 	andeq	r1, r0, r7, ror #21
    3970:	2608c001 	strcs	ip, [r8], -r1
    3974:	02000001 	andeq	r0, r0, #1
    3978:	14136c91 	ldrne	r6, [r3], #-3217	; 0xfffff36f
    397c:	480000b2 	stmdami	r0, {r1, r4, r5, r7}
    3980:	0d000000 	stceq	0, cr0, [r0, #-0]
    3984:	c2010069 	andgt	r0, r1, #105	; 0x69
    3988:	00017f0b 	andeq	r7, r1, fp, lsl #30
    398c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    3990:	040e0000 	streq	r0, [lr], #-0
    3994:	00000209 	andeq	r0, r0, r9, lsl #4
    3998:	0e041514 	mcreq	5, 0, r1, cr4, cr4, {0}
    399c:	00007404 	andeq	r7, r0, r4, lsl #8
    39a0:	1b231200 	blne	8c81a8 <__bss_end+0x8bbe68>
    39a4:	b5010000 	strlt	r0, [r1, #-0]
    39a8:	001a6e06 	andseq	r6, sl, r6, lsl #28
    39ac:	00b18400 	adcseq	r8, r1, r0, lsl #8
    39b0:	00006800 	andeq	r6, r0, r0, lsl #16
    39b4:	719c0100 	orrsvc	r0, ip, r0, lsl #2
    39b8:	10000002 	andne	r0, r0, r2
    39bc:	00001b9a 	muleq	r0, sl, fp
    39c0:	0a12b501 	beq	4b0dcc <__bss_end+0x4a4a8c>
    39c4:	02000002 	andeq	r0, r0, #2
    39c8:	a1106c91 			; <UNDEFINED> instruction: 0xa1106c91
    39cc:	0100001b 	tsteq	r0, fp, lsl r0
    39d0:	017f1eb5 	ldrheq	r1, [pc, #-229]	; 38f3 <shift+0x38f3>
    39d4:	91020000 	mrsls	r0, (UNDEF: 2)
    39d8:	656d0d68 	strbvs	r0, [sp, #-3432]!	; 0xfffff298
    39dc:	b701006d 	strlt	r0, [r1, -sp, rrx]
    39e0:	00012608 	andeq	r2, r1, r8, lsl #12
    39e4:	70910200 	addsvc	r0, r1, r0, lsl #4
    39e8:	00b1a013 	adcseq	sl, r1, r3, lsl r0
    39ec:	00003c00 	andeq	r3, r0, r0, lsl #24
    39f0:	00690d00 	rsbeq	r0, r9, r0, lsl #26
    39f4:	7f0bb901 	svcvc	0x000bb901
    39f8:	02000001 	andeq	r0, r0, #1
    39fc:	00007491 	muleq	r0, r1, r4
    3a00:	001ac316 	andseq	ip, sl, r6, lsl r3
    3a04:	07a40100 	streq	r0, [r4, r0, lsl #2]!
    3a08:	00001baf 	andeq	r1, r0, pc, lsr #23
    3a0c:	00000126 	andeq	r0, r0, r6, lsr #2
    3a10:	0000b0ac 	andeq	fp, r0, ip, lsr #1
    3a14:	000000d8 	ldrdeq	r0, [r0], -r8
    3a18:	02f09c01 	rscseq	r9, r0, #256	; 0x100
    3a1c:	57100000 	ldrpl	r0, [r0, -r0]
    3a20:	0100001a 	tsteq	r0, sl, lsl r0
    3a24:	012615a4 			; <UNDEFINED> instruction: 0x012615a4
    3a28:	91020000 	mrsls	r0, (UNDEF: 2)
    3a2c:	72730b64 	rsbsvc	r0, r3, #100, 22	; 0x19000
    3a30:	a4010063 	strge	r0, [r1], #-99	; 0xffffff9d
    3a34:	00020c27 	andeq	r0, r2, r7, lsr #24
    3a38:	60910200 	addsvs	r0, r1, r0, lsl #4
    3a3c:	00160010 	andseq	r0, r6, r0, lsl r0
    3a40:	2fa40100 	svccs	0x00a40100
    3a44:	0000017f 	andeq	r0, r0, pc, ror r1
    3a48:	0c5c9102 	ldfeqp	f1, [ip], {2}
    3a4c:	00001acb 	andeq	r1, r0, fp, asr #21
    3a50:	7f09a501 	svcvc	0x0009a501
    3a54:	02000001 	andeq	r0, r0, #1
    3a58:	6d0d6c91 	stcvs	12, cr6, [sp, #-580]	; 0xfffffdbc
    3a5c:	09a70100 	stmibeq	r7!, {r8}
    3a60:	0000017f 	andeq	r0, r0, pc, ror r1
    3a64:	13749102 	cmnne	r4, #-2147483648	; 0x80000000
    3a68:	0000b0f0 	strdeq	fp, [r0], -r0
    3a6c:	00000070 	andeq	r0, r0, r0, ror r0
    3a70:	0100690d 	tsteq	r0, sp, lsl #18
    3a74:	017f0dab 	cmneq	pc, fp, lsr #27
    3a78:	91020000 	mrsls	r0, (UNDEF: 2)
    3a7c:	16000070 			; <UNDEFINED> instruction: 0x16000070
    3a80:	00001a67 	andeq	r1, r0, r7, ror #20
    3a84:	82079a01 	andhi	r9, r7, #4096	; 0x1000
    3a88:	2600001a 			; <UNDEFINED> instruction: 0x2600001a
    3a8c:	00000001 	andeq	r0, r0, r1
    3a90:	ac0000b0 	stcge	0, cr0, [r0], {176}	; 0xb0
    3a94:	01000000 	mrseq	r0, (UNDEF: 0)
    3a98:	00036d9c 	muleq	r3, ip, sp
    3a9c:	1a571000 	bne	15c7aa4 <__bss_end+0x15bb764>
    3aa0:	9a010000 	bls	43aa8 <__bss_end+0x37768>
    3aa4:	00012614 	andeq	r2, r1, r4, lsl r6
    3aa8:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    3aac:	6372730b 	cmnvs	r2, #738197504	; 0x2c000000
    3ab0:	269a0100 	ldrcs	r0, [sl], r0, lsl #2
    3ab4:	0000020c 	andeq	r0, r0, ip, lsl #4
    3ab8:	0d609102 	stfeqp	f1, [r0, #-8]!
    3abc:	9b01006e 	blls	43c7c <__bss_end+0x3793c>
    3ac0:	00017f09 	andeq	r7, r1, r9, lsl #30
    3ac4:	6c910200 	lfmvs	f0, 4, [r1], {0}
    3ac8:	01006d0d 	tsteq	r0, sp, lsl #26
    3acc:	017f099c 			; <UNDEFINED> instruction: 0x017f099c
    3ad0:	91020000 	mrsls	r0, (UNDEF: 2)
    3ad4:	1acb0c74 	bne	ff2c6cac <__bss_end+0xff2ba96c>
    3ad8:	9d010000 	stcls	0, cr0, [r1, #-0]
    3adc:	00017f09 	andeq	r7, r1, r9, lsl #30
    3ae0:	68910200 	ldmvs	r1, {r9}
    3ae4:	00b03413 	adcseq	r3, r0, r3, lsl r4
    3ae8:	00005400 	andeq	r5, r0, r0, lsl #8
    3aec:	00690d00 	rsbeq	r0, r9, r0, lsl #26
    3af0:	7f0d9e01 	svcvc	0x000d9e01
    3af4:	02000001 	andeq	r0, r0, #1
    3af8:	00007091 	muleq	r0, r1, r0
    3afc:	001ba80f 	andseq	sl, fp, pc, lsl #16
    3b00:	058f0100 	streq	r0, [pc, #256]	; 3c08 <shift+0x3c08>
    3b04:	00001b59 	andeq	r1, r0, r9, asr fp
    3b08:	0000017f 	andeq	r0, r0, pc, ror r1
    3b0c:	0000afac 	andeq	sl, r0, ip, lsr #31
    3b10:	00000054 	andeq	r0, r0, r4, asr r0
    3b14:	03a69c01 			; <UNDEFINED> instruction: 0x03a69c01
    3b18:	730b0000 	movwvc	r0, #45056	; 0xb000
    3b1c:	188f0100 	stmne	pc, {r8}	; <UNPREDICTABLE>
    3b20:	0000020c 	andeq	r0, r0, ip, lsl #4
    3b24:	0d6c9102 	stfeqp	f1, [ip, #-8]!
    3b28:	91010069 	tstls	r1, r9, rrx
    3b2c:	00017f06 	andeq	r7, r1, r6, lsl #30
    3b30:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    3b34:	1b300f00 	blne	c0773c <__bss_end+0xbfb3fc>
    3b38:	7f010000 	svcvc	0x00010000
    3b3c:	001b6605 	andseq	r6, fp, r5, lsl #12
    3b40:	00017f00 	andeq	r7, r1, r0, lsl #30
    3b44:	00af0000 	adceq	r0, pc, r0
    3b48:	0000ac00 	andeq	sl, r0, r0, lsl #24
    3b4c:	0c9c0100 	ldfeqs	f0, [ip], {0}
    3b50:	0b000004 	bleq	3b68 <shift+0x3b68>
    3b54:	01003173 	tsteq	r0, r3, ror r1
    3b58:	020c197f 	andeq	r1, ip, #2080768	; 0x1fc000
    3b5c:	91020000 	mrsls	r0, (UNDEF: 2)
    3b60:	32730b6c 	rsbscc	r0, r3, #108, 22	; 0x1b000
    3b64:	297f0100 	ldmdbcs	pc!, {r8}^	; <UNPREDICTABLE>
    3b68:	0000020c 	andeq	r0, r0, ip, lsl #4
    3b6c:	0b689102 	bleq	1a27f7c <__bss_end+0x1a1bc3c>
    3b70:	006d756e 	rsbeq	r7, sp, lr, ror #10
    3b74:	7f317f01 	svcvc	0x00317f01
    3b78:	02000001 	andeq	r0, r0, #1
    3b7c:	750d6491 	strvc	r6, [sp, #-1169]	; 0xfffffb6f
    3b80:	81010031 	tsthi	r1, r1, lsr r0
    3b84:	00040c10 	andeq	r0, r4, r0, lsl ip
    3b88:	77910200 	ldrvc	r0, [r1, r0, lsl #4]
    3b8c:	0032750d 	eorseq	r7, r2, sp, lsl #10
    3b90:	0c148101 	ldfeqd	f0, [r4], {1}
    3b94:	02000004 	andeq	r0, r0, #4
    3b98:	08007691 	stmdaeq	r0, {r0, r4, r7, r9, sl, ip, sp, lr}
    3b9c:	089f0801 	ldmeq	pc, {r0, fp}	; <UNPREDICTABLE>
    3ba0:	7a0f0000 	bvc	3c3ba8 <__bss_end+0x3b7868>
    3ba4:	0100001a 	tsteq	r0, sl, lsl r0
    3ba8:	19f20773 	ldmibne	r2!, {r0, r1, r4, r5, r6, r8, r9, sl}^
    3bac:	01260000 			; <UNDEFINED> instruction: 0x01260000
    3bb0:	ae400000 	cdpge	0, 4, cr0, cr0, cr0, {0}
    3bb4:	00c00000 	sbceq	r0, r0, r0
    3bb8:	9c010000 	stcls	0, cr0, [r1], {-0}
    3bbc:	0000046c 	andeq	r0, r0, ip, ror #8
    3bc0:	001a5710 	andseq	r5, sl, r0, lsl r7
    3bc4:	15730100 	ldrbne	r0, [r3, #-256]!	; 0xffffff00
    3bc8:	00000126 	andeq	r0, r0, r6, lsr #2
    3bcc:	0b6c9102 	bleq	1b27fdc <__bss_end+0x1b1bc9c>
    3bd0:	00637273 	rsbeq	r7, r3, r3, ror r2
    3bd4:	0c277301 	stceq	3, cr7, [r7], #-4
    3bd8:	02000002 	andeq	r0, r0, #2
    3bdc:	6e0b6891 	mcrvs	8, 0, r6, cr11, cr1, {4}
    3be0:	01006d75 	tsteq	r0, r5, ror sp
    3be4:	017f3073 	cmneq	pc, r3, ror r0	; <UNPREDICTABLE>
    3be8:	91020000 	mrsls	r0, (UNDEF: 2)
    3bec:	00690d64 	rsbeq	r0, r9, r4, ror #26
    3bf0:	7f067501 	svcvc	0x00067501
    3bf4:	02000001 	andeq	r0, r0, #1
    3bf8:	0f007491 	svceq	0x00007491
    3bfc:	00001a33 	andeq	r1, r0, r3, lsr sl
    3c00:	4c075701 	stcmi	7, cr5, [r7], {1}
    3c04:	1f00001a 	svcne	0x0000001a
    3c08:	e4000001 	str	r0, [r0], #-1
    3c0c:	5c0000ac 	stcpl	0, cr0, [r0], {172}	; 0xac
    3c10:	01000001 	tsteq	r0, r1
    3c14:	00050d9c 	muleq	r5, ip, sp
    3c18:	1a5c1000 	bne	1707c20 <__bss_end+0x16fb8e0>
    3c1c:	57010000 	strpl	r0, [r1, -r0]
    3c20:	00020c18 	andeq	r0, r2, r8, lsl ip
    3c24:	44910200 	ldrmi	r0, [r1], #512	; 0x200
    3c28:	001b450c 	andseq	r4, fp, ip, lsl #10
    3c2c:	0c580100 	ldfeqe	f0, [r8], {-0}
    3c30:	0000050d 	andeq	r0, r0, sp, lsl #10
    3c34:	0c709102 	ldfeqp	f1, [r0], #-8
    3c38:	00001ad2 	ldrdeq	r1, [r0], -r2
    3c3c:	0d0c5901 	vstreq.16	s10, [ip, #-2]	; <UNPREDICTABLE>
    3c40:	02000005 	andeq	r0, r0, #5
    3c44:	740d6091 	strvc	r6, [sp], #-145	; 0xffffff6f
    3c48:	0100706d 	tsteq	r0, sp, rrx
    3c4c:	050d0c5b 	streq	r0, [sp, #-3163]	; 0xfffff3a5
    3c50:	91020000 	mrsls	r0, (UNDEF: 2)
    3c54:	15250c58 	strne	r0, [r5, #-3160]!	; 0xfffff3a8
    3c58:	5c010000 	stcpl	0, cr0, [r1], {-0}
    3c5c:	00017f09 	andeq	r7, r1, r9, lsl #30
    3c60:	54910200 	ldrpl	r0, [r1], #512	; 0x200
    3c64:	001fd30c 	andseq	sp, pc, ip, lsl #6
    3c68:	095d0100 	ldmdbeq	sp, {r8}^
    3c6c:	0000017f 	andeq	r0, r0, pc, ror r1
    3c70:	0c6c9102 	stfeqp	f1, [ip], #-8
    3c74:	00001b15 	andeq	r1, r0, r5, lsl fp
    3c78:	140a5e01 	strne	r5, [sl], #-3585	; 0xfffff1ff
    3c7c:	02000005 	andeq	r0, r0, #5
    3c80:	40136b91 	mulsmi	r3, r1, fp
    3c84:	d00000ad 	andle	r0, r0, sp, lsr #1
    3c88:	0d000000 	stceq	0, cr0, [r0, #-0]
    3c8c:	006c6176 	rsbeq	r6, ip, r6, ror r1
    3c90:	0d106701 	ldceq	7, cr6, [r0, #-4]
    3c94:	02000005 	andeq	r0, r0, #5
    3c98:	00004891 	muleq	r0, r1, r8
    3c9c:	93040808 	movwls	r0, #18440	; 0x4808
    3ca0:	0800001f 	stmdaeq	r0, {r0, r1, r2, r3, r4}
    3ca4:	06e40201 	strbteq	r0, [r4], r1, lsl #4
    3ca8:	380f0000 	stmdacc	pc, {}	; <UNPREDICTABLE>
    3cac:	0100001a 	tsteq	r0, sl, lsl r0
    3cb0:	1a13053c 	bne	4c51a8 <__bss_end+0x4b8e68>
    3cb4:	017f0000 	cmneq	pc, r0
    3cb8:	abe40000 	blge	ff903cc0 <__bss_end+0xff8f7980>
    3cbc:	01000000 	mrseq	r0, (UNDEF: 0)
    3cc0:	9c010000 	stcls	0, cr0, [r1], {-0}
    3cc4:	0000057e 	andeq	r0, r0, lr, ror r5
    3cc8:	001a5c10 	andseq	r5, sl, r0, lsl ip
    3ccc:	213c0100 	teqcs	ip, r0, lsl #2
    3cd0:	0000020c 	andeq	r0, r0, ip, lsl #4
    3cd4:	0d6c9102 	stfeqp	f1, [ip, #-8]!
    3cd8:	00746f64 	rsbseq	r6, r4, r4, ror #30
    3cdc:	140a3e01 	strne	r3, [sl], #-3585	; 0xfffff1ff
    3ce0:	02000005 	andeq	r0, r0, #5
    3ce4:	380c7791 	stmdacc	ip, {r0, r4, r7, r8, r9, sl, ip, sp, lr}
    3ce8:	0100001b 	tsteq	r0, fp, lsl r0
    3cec:	05140a3f 	ldreq	r0, [r4, #-2623]	; 0xfffff5c1
    3cf0:	91020000 	mrsls	r0, (UNDEF: 2)
    3cf4:	ac141376 	ldcge	3, cr1, [r4], {118}	; 0x76
    3cf8:	008c0000 	addeq	r0, ip, r0
    3cfc:	630d0000 	movwvs	r0, #53248	; 0xd000
    3d00:	0e410100 	dvfeqs	f0, f1, f0
    3d04:	0000006d 	andeq	r0, r0, sp, rrx
    3d08:	00759102 	rsbseq	r9, r5, r2, lsl #2
    3d0c:	1a471600 	bne	11c9514 <__bss_end+0x11bd1d4>
    3d10:	26010000 	strcs	r0, [r1], -r0
    3d14:	001b7805 	andseq	r7, fp, r5, lsl #16
    3d18:	00017f00 	andeq	r7, r1, r0, lsl #30
    3d1c:	00ab1800 	adceq	r1, fp, r0, lsl #16
    3d20:	0000cc00 	andeq	ip, r0, r0, lsl #24
    3d24:	bb9c0100 	bllt	fe70412c <__bss_end+0xfe6f7dec>
    3d28:	10000005 	andne	r0, r0, r5
    3d2c:	00001a5c 	andeq	r1, r0, ip, asr sl
    3d30:	0c162601 	ldceq	6, cr2, [r6], {1}
    3d34:	02000002 	andeq	r0, r0, #2
    3d38:	450c6c91 	strmi	r6, [ip, #-3217]	; 0xfffff36f
    3d3c:	0100001b 	tsteq	r0, fp, lsl r0
    3d40:	017f062a 	cmneq	pc, sl, lsr #12
    3d44:	91020000 	mrsls	r0, (UNDEF: 2)
    3d48:	d9170074 	ldmdble	r7, {r2, r4, r5, r6}
    3d4c:	0100001a 	tsteq	r0, sl, lsl r0
    3d50:	1b830608 	blne	fe0c5578 <__bss_end+0xfe0b9238>
    3d54:	a9a00000 	stmibge	r0!, {}	; <UNPREDICTABLE>
    3d58:	01780000 	cmneq	r8, r0
    3d5c:	9c010000 	stcls	0, cr0, [r1], {-0}
    3d60:	001a5c10 	andseq	r5, sl, r0, lsl ip
    3d64:	0f080100 	svceq	0x00080100
    3d68:	0000017f 	andeq	r0, r0, pc, ror r1
    3d6c:	10649102 	rsbne	r9, r4, r2, lsl #2
    3d70:	00001b45 	andeq	r1, r0, r5, asr #22
    3d74:	261c0801 	ldrcs	r0, [ip], -r1, lsl #16
    3d78:	02000001 	andeq	r0, r0, #1
    3d7c:	dd106091 	ldcle	0, cr6, [r0, #-580]	; 0xfffffdbc
    3d80:	0100001c 	tsteq	r0, ip, lsl r0
    3d84:	00663108 	rsbeq	r3, r6, r8, lsl #2
    3d88:	91020000 	mrsls	r0, (UNDEF: 2)
    3d8c:	00690d5c 	rsbeq	r0, r9, ip, asr sp
    3d90:	7f090a01 	svcvc	0x00090a01
    3d94:	02000001 	andeq	r0, r0, #1
    3d98:	6a0d7491 	bvs	360fe4 <__bss_end+0x354ca4>
    3d9c:	090b0100 	stmdbeq	fp, {r8}
    3da0:	0000017f 	andeq	r0, r0, pc, ror r1
    3da4:	13709102 	cmnne	r0, #-2147483648	; 0x80000000
    3da8:	0000aa98 	muleq	r0, r8, sl
    3dac:	00000060 	andeq	r0, r0, r0, rrx
    3db0:	0100630d 	tsteq	r0, sp, lsl #6
    3db4:	006d081f 	rsbeq	r0, sp, pc, lsl r8
    3db8:	91020000 	mrsls	r0, (UNDEF: 2)
    3dbc:	0000006f 	andeq	r0, r0, pc, rrx
    3dc0:	00000022 	andeq	r0, r0, r2, lsr #32
    3dc4:	12340002 	eorsne	r0, r4, #2
    3dc8:	01040000 	mrseq	r0, (UNDEF: 4)
    3dcc:	00001d53 	andeq	r1, r0, r3, asr sp
    3dd0:	0000b5fc 	strdeq	fp, [r0], -ip
    3dd4:	0000b808 	andeq	fp, r0, r8, lsl #16
    3dd8:	00001bc0 	andeq	r1, r0, r0, asr #23
    3ddc:	00001bf0 	strdeq	r1, [r0], -r0
    3de0:	00001c58 	andeq	r1, r0, r8, asr ip
    3de4:	00228001 	eoreq	r8, r2, r1
    3de8:	00020000 	andeq	r0, r2, r0
    3dec:	00001248 	andeq	r1, r0, r8, asr #4
    3df0:	1dd00104 	ldfnee	f0, [r0, #16]
    3df4:	b8080000 	stmdalt	r8, {}	; <UNPREDICTABLE>
    3df8:	ba480000 	blt	1203e00 <__bss_end+0x11f7ac0>
    3dfc:	1bc00000 	blne	ff003e04 <__bss_end+0xfeff7ac4>
    3e00:	1bf00000 	blne	ffc03e08 <__bss_end+0xffbf7ac8>
    3e04:	1c580000 	mrane	r0, r8, acc0
    3e08:	80010000 	andhi	r0, r1, r0
    3e0c:	00000022 	andeq	r0, r0, r2, lsr #32
    3e10:	125c0002 	subsne	r0, ip, #2
    3e14:	01040000 	mrseq	r0, (UNDEF: 4)
    3e18:	00001e59 	andeq	r1, r0, r9, asr lr
    3e1c:	0000ba48 	andeq	fp, r0, r8, asr #20
    3e20:	0000ba4c 	andeq	fp, r0, ip, asr #20
    3e24:	00001bc0 	andeq	r1, r0, r0, asr #23
    3e28:	00001bf0 	strdeq	r1, [r0], -r0
    3e2c:	00001c58 	andeq	r1, r0, r8, asr ip
    3e30:	00228001 	eoreq	r8, r2, r1
    3e34:	00020000 	andeq	r0, r2, r0
    3e38:	00001270 	andeq	r1, r0, r0, ror r2
    3e3c:	1eb90104 	frdnee	f0, f1, f4
    3e40:	ba4c0000 	blt	1303e48 <__bss_end+0x12f7b08>
    3e44:	bc9c0000 	ldclt	0, cr0, [ip], {0}
    3e48:	1c640000 	stclne	0, cr0, [r4], #-0
    3e4c:	1bf00000 	blne	ffc03e54 <__bss_end+0xffbf7b14>
    3e50:	1c580000 	mrane	r0, r8, acc0
    3e54:	80010000 	andhi	r0, r1, r0
    3e58:	00000022 	andeq	r0, r0, r2, lsr #32
    3e5c:	12840002 	addne	r0, r4, #2
    3e60:	01040000 	mrseq	r0, (UNDEF: 4)
    3e64:	00001fb8 			; <UNDEFINED> instruction: 0x00001fb8
    3e68:	0000bc9c 	muleq	r0, ip, ip
    3e6c:	0000bd70 	andeq	fp, r0, r0, ror sp
    3e70:	00001c95 	muleq	r0, r5, ip
    3e74:	00001bf0 	strdeq	r1, [r0], -r0
    3e78:	00001c58 	andeq	r1, r0, r8, asr ip
    3e7c:	032a8001 			; <UNDEFINED> instruction: 0x032a8001
    3e80:	00040000 	andeq	r0, r4, r0
    3e84:	00001298 	muleq	r0, r8, r2
    3e88:	1de10104 	stfnee	f0, [r1, #16]!
    3e8c:	9a0c0000 	bls	303e94 <__bss_end+0x2f7b54>
    3e90:	f000001f 			; <UNDEFINED> instruction: 0xf000001f
    3e94:	3600001b 			; <UNDEFINED> instruction: 0x3600001b
    3e98:	02000020 	andeq	r0, r0, #32
    3e9c:	6e690504 	cdpvs	5, 6, cr0, cr9, cr4, {0}
    3ea0:	04030074 	streq	r0, [r3], #-116	; 0xffffff8c
    3ea4:	001fe307 	andseq	lr, pc, r7, lsl #6
    3ea8:	05080300 	streq	r0, [r8, #-768]	; 0xfffffd00
    3eac:	00000243 	andeq	r0, r0, r3, asr #4
    3eb0:	8e040803 	cdphi	8, 0, cr0, cr4, cr3, {0}
    3eb4:	0300001f 	movweq	r0, #31
    3eb8:	089f0801 	ldmeq	pc, {r0, fp}	; <UNPREDICTABLE>
    3ebc:	01030000 	mrseq	r0, (UNDEF: 3)
    3ec0:	0008a106 	andeq	sl, r8, r6, lsl #2
    3ec4:	21660400 	cmncs	r6, r0, lsl #8
    3ec8:	01070000 	mrseq	r0, (UNDEF: 7)
    3ecc:	00000039 	andeq	r0, r0, r9, lsr r0
    3ed0:	d4061701 	strle	r1, [r6], #-1793	; 0xfffff8ff
    3ed4:	05000001 	streq	r0, [r0, #-1]
    3ed8:	00001cf0 	strdeq	r1, [r0], -r0
    3edc:	22150500 	andscs	r0, r5, #0, 10
    3ee0:	05010000 	streq	r0, [r1, #-0]
    3ee4:	00001ec3 	andeq	r1, r0, r3, asr #29
    3ee8:	1f810502 	svcne	0x00810502
    3eec:	05030000 	streq	r0, [r3, #-0]
    3ef0:	0000217f 	andeq	r2, r0, pc, ror r1
    3ef4:	22250504 	eorcs	r0, r5, #4, 10	; 0x1000000
    3ef8:	05050000 	streq	r0, [r5, #-0]
    3efc:	00002195 	muleq	r0, r5, r1
    3f00:	1fca0506 	svcne	0x00ca0506
    3f04:	05070000 	streq	r0, [r7, #-0]
    3f08:	00002110 	andeq	r2, r0, r0, lsl r1
    3f0c:	211e0508 	tstcs	lr, r8, lsl #10
    3f10:	05090000 	streq	r0, [r9, #-0]
    3f14:	0000212c 	andeq	r2, r0, ip, lsr #2
    3f18:	2033050a 	eorscs	r0, r3, sl, lsl #10
    3f1c:	050b0000 	streq	r0, [fp, #-0]
    3f20:	00002023 	andeq	r2, r0, r3, lsr #32
    3f24:	1d0c050c 	cfstr32ne	mvfx0, [ip, #-48]	; 0xffffffd0
    3f28:	050d0000 	streq	r0, [sp, #-0]
    3f2c:	00001d25 	andeq	r1, r0, r5, lsr #26
    3f30:	2014050e 	andscs	r0, r4, lr, lsl #10
    3f34:	050f0000 	streq	r0, [pc, #-0]	; 3f3c <shift+0x3f3c>
    3f38:	000021d8 	ldrdeq	r2, [r0], -r8
    3f3c:	21550510 	cmpcs	r5, r0, lsl r5
    3f40:	05110000 	ldreq	r0, [r1, #-0]
    3f44:	000021c9 	andeq	r2, r0, r9, asr #3
    3f48:	1dd20512 	cfldr64ne	mvdx0, [r2, #72]	; 0x48
    3f4c:	05130000 	ldreq	r0, [r3, #-0]
    3f50:	00001d4f 	andeq	r1, r0, pc, asr #26
    3f54:	1d190514 	cfldr32ne	mvfx0, [r9, #-80]	; 0xffffffb0
    3f58:	05150000 	ldreq	r0, [r5, #-0]
    3f5c:	000020b2 	strheq	r2, [r0], -r2	; <UNPREDICTABLE>
    3f60:	1d860516 	cfstr32ne	mvfx0, [r6, #88]	; 0x58
    3f64:	05170000 	ldreq	r0, [r7, #-0]
    3f68:	00001cc1 	andeq	r1, r0, r1, asr #25
    3f6c:	21bb0518 			; <UNDEFINED> instruction: 0x21bb0518
    3f70:	05190000 	ldreq	r0, [r9, #-0]
    3f74:	00001ff0 	strdeq	r1, [r0], -r0
    3f78:	20ca051a 	sbccs	r0, sl, sl, lsl r5
    3f7c:	051b0000 	ldreq	r0, [fp, #-0]
    3f80:	00001d5a 	andeq	r1, r0, sl, asr sp
    3f84:	1f66051c 	svcne	0x0066051c
    3f88:	051d0000 	ldreq	r0, [sp, #-0]
    3f8c:	00001eb5 			; <UNDEFINED> instruction: 0x00001eb5
    3f90:	2147051e 	cmpcs	r7, lr, lsl r5
    3f94:	051f0000 	ldreq	r0, [pc, #-0]	; 3f9c <shift+0x3f9c>
    3f98:	000021a3 	andeq	r2, r0, r3, lsr #3
    3f9c:	21e40520 	mvncs	r0, r0, lsr #10
    3fa0:	05210000 	streq	r0, [r1, #-0]!
    3fa4:	000021f2 	strdeq	r2, [r0], -r2	; <UNPREDICTABLE>
    3fa8:	20070522 	andcs	r0, r7, r2, lsr #10
    3fac:	05230000 	streq	r0, [r3, #-0]!
    3fb0:	00001f2a 	andeq	r1, r0, sl, lsr #30
    3fb4:	1d690524 	cfstr64ne	mvdx0, [r9, #-144]!	; 0xffffff70
    3fb8:	05250000 	streq	r0, [r5, #-0]!
    3fbc:	00001fbd 			; <UNDEFINED> instruction: 0x00001fbd
    3fc0:	1ecf0526 	cdpne	5, 12, cr0, cr15, cr6, {1}
    3fc4:	05270000 	streq	r0, [r7, #-0]!
    3fc8:	00002172 	andeq	r2, r0, r2, ror r1
    3fcc:	1edf0528 	cdpne	5, 13, cr0, cr15, cr8, {1}
    3fd0:	05290000 	streq	r0, [r9, #-0]!
    3fd4:	00001eee 	andeq	r1, r0, lr, ror #29
    3fd8:	1efd052a 	cdpne	5, 15, cr0, cr13, cr10, {1}
    3fdc:	052b0000 	streq	r0, [fp, #-0]!
    3fe0:	00001f0c 	andeq	r1, r0, ip, lsl #30
    3fe4:	1e9a052c 	cdpne	5, 9, cr0, cr10, cr12, {1}
    3fe8:	052d0000 	streq	r0, [sp, #-0]!
    3fec:	00001f1b 	andeq	r1, r0, fp, lsl pc
    3ff0:	2101052e 	tstcs	r1, lr, lsr #10
    3ff4:	052f0000 	streq	r0, [pc, #-0]!	; 3ffc <shift+0x3ffc>
    3ff8:	00001f39 	andeq	r1, r0, r9, lsr pc
    3ffc:	1f480530 	svcne	0x00480530
    4000:	05310000 	ldreq	r0, [r1, #-0]!
    4004:	00001cfa 	strdeq	r1, [r0], -sl
    4008:	20520532 	subscs	r0, r2, r2, lsr r5
    400c:	05330000 	ldreq	r0, [r3, #-0]!
    4010:	00002062 	andeq	r2, r0, r2, rrx
    4014:	20720534 	rsbscs	r0, r2, r4, lsr r5
    4018:	05350000 	ldreq	r0, [r5, #-0]!
    401c:	00001e88 	andeq	r1, r0, r8, lsl #29
    4020:	20820536 	addcs	r0, r2, r6, lsr r5
    4024:	05370000 	ldreq	r0, [r7, #-0]!
    4028:	00002092 	muleq	r0, r2, r0
    402c:	20a20538 	adccs	r0, r2, r8, lsr r5
    4030:	05390000 	ldreq	r0, [r9, #-0]!
    4034:	00001d79 	andeq	r1, r0, r9, ror sp
    4038:	1d32053a 	cfldr32ne	mvfx0, [r2, #-232]!	; 0xffffff18
    403c:	053b0000 	ldreq	r0, [fp, #-0]!
    4040:	00001f57 	andeq	r1, r0, r7, asr pc
    4044:	1cd1053c 	cfldr64ne	mvdx0, [r1], {60}	; 0x3c
    4048:	053d0000 	ldreq	r0, [sp, #-0]!
    404c:	000020bd 	strheq	r2, [r0], -sp
    4050:	b906003e 	stmdblt	r6, {r1, r2, r3, r4, r5}
    4054:	0200001d 	andeq	r0, r0, #29
    4058:	08026b01 	stmdaeq	r2, {r0, r8, r9, fp, sp, lr}
    405c:	000001ff 	strdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    4060:	001f7c07 	andseq	r7, pc, r7, lsl #24
    4064:	02700100 	rsbseq	r0, r0, #0, 2
    4068:	00004714 	andeq	r4, r0, r4, lsl r7
    406c:	95070000 	strls	r0, [r7, #-0]
    4070:	0100001e 	tsteq	r0, lr, lsl r0
    4074:	47140271 			; <UNDEFINED> instruction: 0x47140271
    4078:	01000000 	mrseq	r0, (UNDEF: 0)
    407c:	01d40800 	bicseq	r0, r4, r0, lsl #16
    4080:	ff090000 			; <UNDEFINED> instruction: 0xff090000
    4084:	14000001 	strne	r0, [r0], #-1
    4088:	0a000002 	beq	4098 <shift+0x4098>
    408c:	00000024 	andeq	r0, r0, r4, lsr #32
    4090:	04080011 	streq	r0, [r8], #-17	; 0xffffffef
    4094:	0b000002 	bleq	40a4 <shift+0x40a4>
    4098:	00002040 	andeq	r2, r0, r0, asr #32
    409c:	26027401 	strcs	r7, [r2], -r1, lsl #8
    40a0:	00000214 	andeq	r0, r0, r4, lsl r2
    40a4:	0a3d3a24 	beq	f5293c <__bss_end+0xf465fc>
    40a8:	243d0f3d 	ldrtcs	r0, [sp], #-3901	; 0xfffff0c3
    40ac:	023d323d 	eorseq	r3, sp, #-805306365	; 0xd0000003
    40b0:	133d053d 	teqne	sp, #255852544	; 0xf400000
    40b4:	0c3d0d3d 	ldceq	13, cr0, [sp], #-244	; 0xffffff0c
    40b8:	113d233d 	teqne	sp, sp, lsr r3
    40bc:	013d263d 	teqeq	sp, sp, lsr r6
    40c0:	083d173d 	ldmdaeq	sp!, {r0, r2, r3, r4, r5, r8, r9, sl, ip}
    40c4:	003d093d 	eorseq	r0, sp, sp, lsr r9
    40c8:	07020300 	streq	r0, [r2, -r0, lsl #6]
    40cc:	00000698 	muleq	r0, r8, r6
    40d0:	a8080103 	stmdage	r8, {r0, r1, r8}
    40d4:	0c000008 	stceq	0, cr0, [r0], {8}
    40d8:	0259040d 	subseq	r0, r9, #218103808	; 0xd000000
    40dc:	000e0000 	andeq	r0, lr, r0
    40e0:	07000022 	streq	r0, [r0, -r2, lsr #32]
    40e4:	00003901 	andeq	r3, r0, r1, lsl #18
    40e8:	04f70200 	ldrbteq	r0, [r7], #512	; 0x200
    40ec:	00029e06 	andeq	r9, r2, r6, lsl #28
    40f0:	1d930500 	cfldr32ne	mvfx0, [r3]
    40f4:	05000000 	streq	r0, [r0, #-0]
    40f8:	00001d9e 	muleq	r0, lr, sp
    40fc:	1db00501 	cfldr32ne	mvfx0, [r0, #4]!
    4100:	05020000 	streq	r0, [r2, #-0]
    4104:	00001dca 	andeq	r1, r0, sl, asr #27
    4108:	213a0503 	teqcs	sl, r3, lsl #10
    410c:	05040000 	streq	r0, [r4, #-0]
    4110:	00001ea9 	andeq	r1, r0, r9, lsr #29
    4114:	20f30505 	rscscs	r0, r3, r5, lsl #10
    4118:	00060000 	andeq	r0, r6, r0
    411c:	21050203 	tstcs	r5, r3, lsl #4
    4120:	03000009 	movweq	r0, #9
    4124:	1fd90708 	svcne	0x00d90708
    4128:	04030000 	streq	r0, [r3], #-0
    412c:	001cea04 	andseq	lr, ip, r4, lsl #20
    4130:	03080300 	movweq	r0, #33536	; 0x8300
    4134:	00001ce2 	andeq	r1, r0, r2, ror #25
    4138:	93040803 	movwls	r0, #18435	; 0x4803
    413c:	0300001f 	movweq	r0, #31
    4140:	20e40310 	rsccs	r0, r4, r0, lsl r3
    4144:	db0f0000 	blle	3c414c <__bss_end+0x3b7e0c>
    4148:	03000020 	movweq	r0, #32
    414c:	025a102a 	subseq	r1, sl, #42	; 0x2a
    4150:	c8090000 	stmdagt	r9, {}	; <UNPREDICTABLE>
    4154:	df000002 	svcle	0x00000002
    4158:	10000002 	andne	r0, r0, r2
    415c:	030c1100 	movweq	r1, #49408	; 0xc100
    4160:	2f030000 	svccs	0x00030000
    4164:	0002d411 	andeq	sp, r2, r1, lsl r4
    4168:	02001100 	andeq	r1, r0, #0, 2
    416c:	30030000 	andcc	r0, r3, r0
    4170:	0002d411 	andeq	sp, r2, r1, lsl r4
    4174:	02c80900 	sbceq	r0, r8, #0, 18
    4178:	03070000 	movweq	r0, #28672	; 0x7000
    417c:	240a0000 	strcs	r0, [sl], #-0
    4180:	01000000 	mrseq	r0, (UNDEF: 0)
    4184:	02df1200 	sbcseq	r1, pc, #0, 4
    4188:	33040000 	movwcc	r0, #16384	; 0x4000
    418c:	02f70a09 	rscseq	r0, r7, #36864	; 0x9000
    4190:	03050000 	movweq	r0, #20480	; 0x5000
    4194:	0000c320 	andeq	ip, r0, r0, lsr #6
    4198:	0002eb12 	andeq	lr, r2, r2, lsl fp
    419c:	09340400 	ldmdbeq	r4!, {sl}
    41a0:	0002f70a 	andeq	pc, r2, sl, lsl #14
    41a4:	24030500 	strcs	r0, [r3], #-1280	; 0xfffffb00
    41a8:	000000c3 	andeq	r0, r0, r3, asr #1
    41ac:	00000306 	andeq	r0, r0, r6, lsl #6
    41b0:	13850004 	orrne	r0, r5, #4
    41b4:	01040000 	mrseq	r0, (UNDEF: 4)
    41b8:	00001de1 	andeq	r1, r0, r1, ror #27
    41bc:	001f9a0c 	andseq	r9, pc, ip, lsl #20
    41c0:	001bf000 	andseq	pc, fp, r0
    41c4:	00bd7000 	adcseq	r7, sp, r0
    41c8:	00003000 	andeq	r3, r0, r0
    41cc:	0020de00 	eoreq	sp, r0, r0, lsl #28
    41d0:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
    41d4:	00001cea 	andeq	r1, r0, sl, ror #25
    41d8:	69050403 	stmdbvs	r5, {r0, r1, sl}
    41dc:	0200746e 	andeq	r7, r0, #1845493760	; 0x6e000000
    41e0:	1fe30704 	svcne	0x00e30704
    41e4:	08020000 	stmdaeq	r2, {}	; <UNPREDICTABLE>
    41e8:	00024305 	andeq	r4, r2, r5, lsl #6
    41ec:	04080200 	streq	r0, [r8], #-512	; 0xfffffe00
    41f0:	00001f8e 	andeq	r1, r0, lr, lsl #31
    41f4:	9f080102 	svcls	0x00080102
    41f8:	02000008 	andeq	r0, r0, #8
    41fc:	08a10601 	stmiaeq	r1!, {r0, r9, sl}
    4200:	66040000 	strvs	r0, [r4], -r0
    4204:	07000021 	streq	r0, [r0, -r1, lsr #32]
    4208:	00004801 	andeq	r4, r0, r1, lsl #16
    420c:	06170200 	ldreq	r0, [r7], -r0, lsl #4
    4210:	000001e3 	andeq	r0, r0, r3, ror #3
    4214:	001cf005 	andseq	pc, ip, r5
    4218:	15050000 	strne	r0, [r5, #-0]
    421c:	01000022 	tsteq	r0, r2, lsr #32
    4220:	001ec305 	andseq	ip, lr, r5, lsl #6
    4224:	81050200 	mrshi	r0, SP_usr
    4228:	0300001f 	movweq	r0, #31
    422c:	00217f05 	eoreq	r7, r1, r5, lsl #30
    4230:	25050400 	strcs	r0, [r5, #-1024]	; 0xfffffc00
    4234:	05000022 	streq	r0, [r0, #-34]	; 0xffffffde
    4238:	00219505 	eoreq	r9, r1, r5, lsl #10
    423c:	ca050600 	bgt	145a44 <__bss_end+0x139704>
    4240:	0700001f 	smladeq	r0, pc, r0, r0	; <UNPREDICTABLE>
    4244:	00211005 	eoreq	r1, r1, r5
    4248:	1e050800 	cdpne	8, 0, cr0, cr5, cr0, {0}
    424c:	09000021 	stmdbeq	r0, {r0, r5}
    4250:	00212c05 	eoreq	r2, r1, r5, lsl #24
    4254:	33050a00 	movwcc	r0, #23040	; 0x5a00
    4258:	0b000020 	bleq	42e0 <shift+0x42e0>
    425c:	00202305 	eoreq	r2, r0, r5, lsl #6
    4260:	0c050c00 	stceq	12, cr0, [r5], {-0}
    4264:	0d00001d 	stceq	0, cr0, [r0, #-116]	; 0xffffff8c
    4268:	001d2505 	andseq	r2, sp, r5, lsl #10
    426c:	14050e00 	strne	r0, [r5], #-3584	; 0xfffff200
    4270:	0f000020 	svceq	0x00000020
    4274:	0021d805 	eoreq	sp, r1, r5, lsl #16
    4278:	55051000 	strpl	r1, [r5, #-0]
    427c:	11000021 	tstne	r0, r1, lsr #32
    4280:	0021c905 	eoreq	ip, r1, r5, lsl #18
    4284:	d2051200 	andle	r1, r5, #0, 4
    4288:	1300001d 	movwne	r0, #29
    428c:	001d4f05 	andseq	r4, sp, r5, lsl #30
    4290:	19051400 	stmdbne	r5, {sl, ip}
    4294:	1500001d 	strne	r0, [r0, #-29]	; 0xffffffe3
    4298:	0020b205 	eoreq	fp, r0, r5, lsl #4
    429c:	86051600 	strhi	r1, [r5], -r0, lsl #12
    42a0:	1700001d 	smladne	r0, sp, r0, r0
    42a4:	001cc105 	andseq	ip, ip, r5, lsl #2
    42a8:	bb051800 	bllt	14a2b0 <__bss_end+0x13df70>
    42ac:	19000021 	stmdbne	r0, {r0, r5}
    42b0:	001ff005 	andseq	pc, pc, r5
    42b4:	ca051a00 	bgt	14aabc <__bss_end+0x13e77c>
    42b8:	1b000020 	blne	4340 <shift+0x4340>
    42bc:	001d5a05 	andseq	r5, sp, r5, lsl #20
    42c0:	66051c00 	strvs	r1, [r5], -r0, lsl #24
    42c4:	1d00001f 	stcne	0, cr0, [r0, #-124]	; 0xffffff84
    42c8:	001eb505 	andseq	fp, lr, r5, lsl #10
    42cc:	47051e00 	strmi	r1, [r5, -r0, lsl #28]
    42d0:	1f000021 	svcne	0x00000021
    42d4:	0021a305 	eoreq	sl, r1, r5, lsl #6
    42d8:	e4052000 	str	r2, [r5], #-0
    42dc:	21000021 	tstcs	r0, r1, lsr #32
    42e0:	0021f205 	eoreq	pc, r1, r5, lsl #4
    42e4:	07052200 	streq	r2, [r5, -r0, lsl #4]
    42e8:	23000020 	movwcs	r0, #32
    42ec:	001f2a05 	andseq	r2, pc, r5, lsl #20
    42f0:	69052400 	stmdbvs	r5, {sl, sp}
    42f4:	2500001d 	strcs	r0, [r0, #-29]	; 0xffffffe3
    42f8:	001fbd05 	andseq	fp, pc, r5, lsl #26
    42fc:	cf052600 	svcgt	0x00052600
    4300:	2700001e 	smladcs	r0, lr, r0, r0
    4304:	00217205 	eoreq	r7, r1, r5, lsl #4
    4308:	df052800 	svcle	0x00052800
    430c:	2900001e 	stmdbcs	r0, {r1, r2, r3, r4}
    4310:	001eee05 	andseq	lr, lr, r5, lsl #28
    4314:	fd052a00 	stc2	10, cr2, [r5, #-0]	; <UNPREDICTABLE>
    4318:	2b00001e 	blcs	4398 <shift+0x4398>
    431c:	001f0c05 	andseq	r0, pc, r5, lsl #24
    4320:	9a052c00 	bls	14f328 <__bss_end+0x142fe8>
    4324:	2d00001e 	stccs	0, cr0, [r0, #-120]	; 0xffffff88
    4328:	001f1b05 	andseq	r1, pc, r5, lsl #22
    432c:	01052e00 	tsteq	r5, r0, lsl #28
    4330:	2f000021 	svccs	0x00000021
    4334:	001f3905 	andseq	r3, pc, r5, lsl #18
    4338:	48053000 	stmdami	r5, {ip, sp}
    433c:	3100001f 	tstcc	r0, pc, lsl r0
    4340:	001cfa05 	andseq	pc, ip, r5, lsl #20
    4344:	52053200 	andpl	r3, r5, #0, 4
    4348:	33000020 	movwcc	r0, #32
    434c:	00206205 	eoreq	r6, r0, r5, lsl #4
    4350:	72053400 	andvc	r3, r5, #0, 8
    4354:	35000020 	strcc	r0, [r0, #-32]	; 0xffffffe0
    4358:	001e8805 	andseq	r8, lr, r5, lsl #16
    435c:	82053600 	andhi	r3, r5, #0, 12
    4360:	37000020 	strcc	r0, [r0, -r0, lsr #32]
    4364:	00209205 	eoreq	r9, r0, r5, lsl #4
    4368:	a2053800 	andge	r3, r5, #0, 16
    436c:	39000020 	stmdbcc	r0, {r5}
    4370:	001d7905 	andseq	r7, sp, r5, lsl #18
    4374:	32053a00 	andcc	r3, r5, #0, 20
    4378:	3b00001d 	blcc	43f4 <shift+0x43f4>
    437c:	001f5705 	andseq	r5, pc, r5, lsl #14
    4380:	d1053c00 	tstle	r5, r0, lsl #24
    4384:	3d00001c 	stccc	0, cr0, [r0, #-112]	; 0xffffff90
    4388:	0020bd05 	eoreq	fp, r0, r5, lsl #26
    438c:	06003e00 	streq	r3, [r0], -r0, lsl #28
    4390:	00001db9 			; <UNDEFINED> instruction: 0x00001db9
    4394:	026b0202 	rsbeq	r0, fp, #536870912	; 0x20000000
    4398:	00020e08 	andeq	r0, r2, r8, lsl #28
    439c:	1f7c0700 	svcne	0x007c0700
    43a0:	70020000 	andvc	r0, r2, r0
    43a4:	00561402 	subseq	r1, r6, r2, lsl #8
    43a8:	07000000 	streq	r0, [r0, -r0]
    43ac:	00001e95 	muleq	r0, r5, lr
    43b0:	14027102 	strne	r7, [r2], #-258	; 0xfffffefe
    43b4:	00000056 	andeq	r0, r0, r6, asr r0
    43b8:	e3080001 	movw	r0, #32769	; 0x8001
    43bc:	09000001 	stmdbeq	r0, {r0}
    43c0:	0000020e 	andeq	r0, r0, lr, lsl #4
    43c4:	00000223 	andeq	r0, r0, r3, lsr #4
    43c8:	0000330a 	andeq	r3, r0, sl, lsl #6
    43cc:	08001100 	stmdaeq	r0, {r8, ip}
    43d0:	00000213 	andeq	r0, r0, r3, lsl r2
    43d4:	0020400b 	eoreq	r4, r0, fp
    43d8:	02740200 	rsbseq	r0, r4, #0, 4
    43dc:	00022326 	andeq	r2, r2, r6, lsr #6
    43e0:	3d3a2400 	cfldrscc	mvf2, [sl, #-0]
    43e4:	3d0f3d0a 	stccc	13, cr3, [pc, #-40]	; 43c4 <shift+0x43c4>
    43e8:	3d323d24 	ldccc	13, cr3, [r2, #-144]!	; 0xffffff70
    43ec:	3d053d02 	stccc	13, cr3, [r5, #-8]
    43f0:	3d0d3d13 	stccc	13, cr3, [sp, #-76]	; 0xffffffb4
    43f4:	3d233d0c 	stccc	13, cr3, [r3, #-48]!	; 0xffffffd0
    43f8:	3d263d11 	stccc	13, cr3, [r6, #-68]!	; 0xffffffbc
    43fc:	3d173d01 	ldccc	13, cr3, [r7, #-4]
    4400:	3d093d08 	stccc	13, cr3, [r9, #-32]	; 0xffffffe0
    4404:	02020000 	andeq	r0, r2, #0
    4408:	00069807 	andeq	r9, r6, r7, lsl #16
    440c:	08010200 	stmdaeq	r1, {r9}
    4410:	000008a8 	andeq	r0, r0, r8, lsr #17
    4414:	21050202 	tstcs	r5, r2, lsl #4
    4418:	0c000009 	stceq	0, cr0, [r0], {9}
    441c:	00002271 	andeq	r2, r0, r1, ror r2
    4420:	3a0f8403 	bcc	3e5434 <__bss_end+0x3d90f4>
    4424:	02000000 	andeq	r0, r0, #0
    4428:	1fd90708 	svcne	0x00d90708
    442c:	420c0000 	andmi	r0, ip, #0
    4430:	03000022 	movweq	r0, #34	; 0x22
    4434:	00251093 	mlaeq	r5, r3, r0, r1
    4438:	08020000 	stmdaeq	r2, {}	; <UNPREDICTABLE>
    443c:	001ce203 	andseq	lr, ip, r3, lsl #4
    4440:	04080200 	streq	r0, [r8], #-512	; 0xfffffe00
    4444:	00001f93 	muleq	r0, r3, pc	; <UNPREDICTABLE>
    4448:	e4031002 	str	r1, [r3], #-2
    444c:	0d000020 	stceq	0, cr0, [r0, #-128]	; 0xffffff80
    4450:	00002257 	andeq	r2, r0, r7, asr r2
    4454:	0105f901 	tsteq	r5, r1, lsl #18	; <UNPREDICTABLE>
    4458:	0000026f 	andeq	r0, r0, pc, ror #4
    445c:	0000bd70 	andeq	fp, r0, r0, ror sp
    4460:	00000030 	andeq	r0, r0, r0, lsr r0
    4464:	02fd9c01 	rscseq	r9, sp, #256	; 0x100
    4468:	610e0000 	mrsvs	r0, (UNDEF: 14)
    446c:	05f90100 	ldrbeq	r0, [r9, #256]!	; 0x100
    4470:	00028213 	andeq	r8, r2, r3, lsl r2
    4474:	00000800 	andeq	r0, r0, r0, lsl #16
    4478:	00000000 	andeq	r0, r0, r0
    447c:	bd840f00 	stclt	15, cr0, [r4]
    4480:	02fd0000 	rscseq	r0, sp, #0
    4484:	02e80000 	rsceq	r0, r8, #0
    4488:	01100000 	tsteq	r0, r0
    448c:	03f30550 	mvnseq	r0, #80, 10	; 0x14000000
    4490:	002500f5 	strdeq	r0, [r5], -r5	; <UNPREDICTABLE>
    4494:	00bd9411 	adcseq	r9, sp, r1, lsl r4
    4498:	0002fd00 	andeq	pc, r2, r0, lsl #26
    449c:	50011000 	andpl	r1, r1, r0
    44a0:	f503f306 			; <UNDEFINED> instruction: 0xf503f306
    44a4:	001f2500 	andseq	r2, pc, r0, lsl #10
    44a8:	22491200 	subcs	r1, r9, #0, 4
    44ac:	22350000 	eorscs	r0, r5, #0
    44b0:	3b010000 	blcc	444b8 <__bss_end+0x38178>
    44b4:	032a0003 			; <UNDEFINED> instruction: 0x032a0003
    44b8:	00040000 	andeq	r0, r4, r0
    44bc:	00001494 	muleq	r0, r4, r4
    44c0:	1de10104 	stfnee	f0, [r1, #16]!
    44c4:	9a0c0000 	bls	3044cc <__bss_end+0x2f818c>
    44c8:	f000001f 			; <UNDEFINED> instruction: 0xf000001f
    44cc:	a000001b 	andge	r0, r0, fp, lsl r0
    44d0:	400000bd 	strhmi	r0, [r0], -sp
    44d4:	89000000 	stmdbhi	r0, {}	; <UNPREDICTABLE>
    44d8:	02000021 	andeq	r0, r0, #33	; 0x21
    44dc:	1f930408 	svcne	0x00930408
    44e0:	04020000 	streq	r0, [r2], #-0
    44e4:	001fe307 	andseq	lr, pc, r7, lsl #6
    44e8:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
    44ec:	00001cea 	andeq	r1, r0, sl, ror #25
    44f0:	69050403 	stmdbvs	r5, {r0, r1, sl}
    44f4:	0200746e 	andeq	r7, r0, #1845493760	; 0x6e000000
    44f8:	02430508 	subeq	r0, r3, #8, 10	; 0x2000000
    44fc:	08020000 	stmdaeq	r2, {}	; <UNPREDICTABLE>
    4500:	001f8e04 	andseq	r8, pc, r4, lsl #28
    4504:	08010200 	stmdaeq	r1, {r9}
    4508:	0000089f 	muleq	r0, pc, r8	; <UNPREDICTABLE>
    450c:	a1060102 	tstge	r6, r2, lsl #2
    4510:	04000008 	streq	r0, [r0], #-8
    4514:	00002166 	andeq	r2, r0, r6, ror #2
    4518:	004f0107 	subeq	r0, pc, r7, lsl #2
    451c:	17020000 	strne	r0, [r2, -r0]
    4520:	0001ea06 	andeq	lr, r1, r6, lsl #20
    4524:	1cf00500 	cfldr64ne	mvdx0, [r0]
    4528:	05000000 	streq	r0, [r0, #-0]
    452c:	00002215 	andeq	r2, r0, r5, lsl r2
    4530:	1ec30501 	cdpne	5, 12, cr0, cr3, cr1, {0}
    4534:	05020000 	streq	r0, [r2, #-0]
    4538:	00001f81 	andeq	r1, r0, r1, lsl #31
    453c:	217f0503 	cmncs	pc, r3, lsl #10
    4540:	05040000 	streq	r0, [r4, #-0]
    4544:	00002225 	andeq	r2, r0, r5, lsr #4
    4548:	21950505 	orrscs	r0, r5, r5, lsl #10
    454c:	05060000 	streq	r0, [r6, #-0]
    4550:	00001fca 	andeq	r1, r0, sl, asr #31
    4554:	21100507 	tstcs	r0, r7, lsl #10
    4558:	05080000 	streq	r0, [r8, #-0]
    455c:	0000211e 	andeq	r2, r0, lr, lsl r1
    4560:	212c0509 			; <UNDEFINED> instruction: 0x212c0509
    4564:	050a0000 	streq	r0, [sl, #-0]
    4568:	00002033 	andeq	r2, r0, r3, lsr r0
    456c:	2023050b 	eorcs	r0, r3, fp, lsl #10
    4570:	050c0000 	streq	r0, [ip, #-0]
    4574:	00001d0c 	andeq	r1, r0, ip, lsl #26
    4578:	1d25050d 	cfstr32ne	mvfx0, [r5, #-52]!	; 0xffffffcc
    457c:	050e0000 	streq	r0, [lr, #-0]
    4580:	00002014 	andeq	r2, r0, r4, lsl r0
    4584:	21d8050f 	bicscs	r0, r8, pc, lsl #10
    4588:	05100000 	ldreq	r0, [r0, #-0]
    458c:	00002155 	andeq	r2, r0, r5, asr r1
    4590:	21c90511 	biccs	r0, r9, r1, lsl r5
    4594:	05120000 	ldreq	r0, [r2, #-0]
    4598:	00001dd2 	ldrdeq	r1, [r0], -r2
    459c:	1d4f0513 	cfstr64ne	mvdx0, [pc, #-76]	; 4558 <shift+0x4558>
    45a0:	05140000 	ldreq	r0, [r4, #-0]
    45a4:	00001d19 	andeq	r1, r0, r9, lsl sp
    45a8:	20b20515 	adcscs	r0, r2, r5, lsl r5
    45ac:	05160000 	ldreq	r0, [r6, #-0]
    45b0:	00001d86 	andeq	r1, r0, r6, lsl #27
    45b4:	1cc10517 	cfstr64ne	mvdx0, [r1], {23}
    45b8:	05180000 	ldreq	r0, [r8, #-0]
    45bc:	000021bb 			; <UNDEFINED> instruction: 0x000021bb
    45c0:	1ff00519 	svcne	0x00f00519
    45c4:	051a0000 	ldreq	r0, [sl, #-0]
    45c8:	000020ca 	andeq	r2, r0, sl, asr #1
    45cc:	1d5a051b 	cfldr64ne	mvdx0, [sl, #-108]	; 0xffffff94
    45d0:	051c0000 	ldreq	r0, [ip, #-0]
    45d4:	00001f66 	andeq	r1, r0, r6, ror #30
    45d8:	1eb5051d 	mrcne	5, 5, r0, cr5, cr13, {0}
    45dc:	051e0000 	ldreq	r0, [lr, #-0]
    45e0:	00002147 	andeq	r2, r0, r7, asr #2
    45e4:	21a3051f 			; <UNDEFINED> instruction: 0x21a3051f
    45e8:	05200000 	streq	r0, [r0, #-0]!
    45ec:	000021e4 	andeq	r2, r0, r4, ror #3
    45f0:	21f20521 	mvnscs	r0, r1, lsr #10
    45f4:	05220000 	streq	r0, [r2, #-0]!
    45f8:	00002007 	andeq	r2, r0, r7
    45fc:	1f2a0523 	svcne	0x002a0523
    4600:	05240000 	streq	r0, [r4, #-0]!
    4604:	00001d69 	andeq	r1, r0, r9, ror #26
    4608:	1fbd0525 	svcne	0x00bd0525
    460c:	05260000 	streq	r0, [r6, #-0]!
    4610:	00001ecf 	andeq	r1, r0, pc, asr #29
    4614:	21720527 	cmncs	r2, r7, lsr #10
    4618:	05280000 	streq	r0, [r8, #-0]!
    461c:	00001edf 	ldrdeq	r1, [r0], -pc	; <UNPREDICTABLE>
    4620:	1eee0529 	cdpne	5, 14, cr0, cr14, cr9, {1}
    4624:	052a0000 	streq	r0, [sl, #-0]!
    4628:	00001efd 	strdeq	r1, [r0], -sp
    462c:	1f0c052b 	svcne	0x000c052b
    4630:	052c0000 	streq	r0, [ip, #-0]!
    4634:	00001e9a 	muleq	r0, sl, lr
    4638:	1f1b052d 	svcne	0x001b052d
    463c:	052e0000 	streq	r0, [lr, #-0]!
    4640:	00002101 	andeq	r2, r0, r1, lsl #2
    4644:	1f39052f 	svcne	0x0039052f
    4648:	05300000 	ldreq	r0, [r0, #-0]!
    464c:	00001f48 	andeq	r1, r0, r8, asr #30
    4650:	1cfa0531 	cfldr64ne	mvdx0, [sl], #196	; 0xc4
    4654:	05320000 	ldreq	r0, [r2, #-0]!
    4658:	00002052 	andeq	r2, r0, r2, asr r0
    465c:	20620533 	rsbcs	r0, r2, r3, lsr r5
    4660:	05340000 	ldreq	r0, [r4, #-0]!
    4664:	00002072 	andeq	r2, r0, r2, ror r0
    4668:	1e880535 	mcrne	5, 4, r0, cr8, cr5, {1}
    466c:	05360000 	ldreq	r0, [r6, #-0]!
    4670:	00002082 	andeq	r2, r0, r2, lsl #1
    4674:	20920537 	addscs	r0, r2, r7, lsr r5
    4678:	05380000 	ldreq	r0, [r8, #-0]!
    467c:	000020a2 	andeq	r2, r0, r2, lsr #1
    4680:	1d790539 	cfldr64ne	mvdx0, [r9, #-228]!	; 0xffffff1c
    4684:	053a0000 	ldreq	r0, [sl, #-0]!
    4688:	00001d32 	andeq	r1, r0, r2, lsr sp
    468c:	1f57053b 	svcne	0x0057053b
    4690:	053c0000 	ldreq	r0, [ip, #-0]!
    4694:	00001cd1 	ldrdeq	r1, [r0], -r1	; <UNPREDICTABLE>
    4698:	20bd053d 	adcscs	r0, sp, sp, lsr r5
    469c:	003e0000 	eorseq	r0, lr, r0
    46a0:	001db906 	andseq	fp, sp, r6, lsl #18
    46a4:	6b020200 	blvs	84eac <__bss_end+0x78b6c>
    46a8:	02150802 	andseq	r0, r5, #131072	; 0x20000
    46ac:	7c070000 	stcvc	0, cr0, [r7], {-0}
    46b0:	0200001f 	andeq	r0, r0, #31
    46b4:	5d140270 	lfmpl	f0, 4, [r4, #-448]	; 0xfffffe40
    46b8:	00000000 	andeq	r0, r0, r0
    46bc:	001e9507 	andseq	r9, lr, r7, lsl #10
    46c0:	02710200 	rsbseq	r0, r1, #0, 4
    46c4:	00005d14 	andeq	r5, r0, r4, lsl sp
    46c8:	08000100 	stmdaeq	r0, {r8}
    46cc:	000001ea 	andeq	r0, r0, sl, ror #3
    46d0:	00021509 	andeq	r1, r2, r9, lsl #10
    46d4:	00022a00 	andeq	r2, r2, r0, lsl #20
    46d8:	002c0a00 	eoreq	r0, ip, r0, lsl #20
    46dc:	00110000 	andseq	r0, r1, r0
    46e0:	00021a08 	andeq	r1, r2, r8, lsl #20
    46e4:	20400b00 	subcs	r0, r0, r0, lsl #22
    46e8:	74020000 	strvc	r0, [r2], #-0
    46ec:	022a2602 	eoreq	r2, sl, #2097152	; 0x200000
    46f0:	3a240000 	bcc	9046f8 <__bss_end+0x8f83b8>
    46f4:	0f3d0a3d 	svceq	0x003d0a3d
    46f8:	323d243d 	eorscc	r2, sp, #1023410176	; 0x3d000000
    46fc:	053d023d 	ldreq	r0, [sp, #-573]!	; 0xfffffdc3
    4700:	0d3d133d 	ldceq	3, cr1, [sp, #-244]!	; 0xffffff0c
    4704:	233d0c3d 	teqcs	sp, #15616	; 0x3d00
    4708:	263d113d 			; <UNDEFINED> instruction: 0x263d113d
    470c:	173d013d 			; <UNDEFINED> instruction: 0x173d013d
    4710:	093d083d 	ldmdbeq	sp!, {r0, r2, r3, r4, r5, fp}
    4714:	0200003d 	andeq	r0, r0, #61	; 0x3d
    4718:	06980702 	ldreq	r0, [r8], r2, lsl #14
    471c:	01020000 	mrseq	r0, (UNDEF: 2)
    4720:	0008a808 	andeq	sl, r8, r8, lsl #16
    4724:	05020200 	streq	r0, [r2, #-512]	; 0xfffffe00
    4728:	00000921 	andeq	r0, r0, r1, lsr #18
    472c:	0022680c 	eoreq	r6, r2, ip, lsl #16
    4730:	16810300 	strne	r0, [r1], r0, lsl #6
    4734:	0000002c 	andeq	r0, r0, ip, lsr #32
    4738:	00027608 	andeq	r7, r2, r8, lsl #12
    473c:	22700c00 	rsbscs	r0, r0, #0, 24
    4740:	85030000 	strhi	r0, [r3, #-0]
    4744:	00029316 	andeq	r9, r2, r6, lsl r3
    4748:	07080200 	streq	r0, [r8, -r0, lsl #4]
    474c:	00001fd9 	ldrdeq	r1, [r0], -r9
    4750:	0022420c 	eoreq	r4, r2, ip, lsl #4
    4754:	10930300 	addsne	r0, r3, r0, lsl #6
    4758:	00000033 	andeq	r0, r0, r3, lsr r0
    475c:	e2030802 	and	r0, r3, #131072	; 0x20000
    4760:	0c00001c 	stceq	0, cr0, [r0], {28}
    4764:	00002261 	andeq	r2, r0, r1, ror #4
    4768:	25109703 	ldrcs	r9, [r0, #-1795]	; 0xfffff8fd
    476c:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    4770:	000002ad 	andeq	r0, r0, sp, lsr #5
    4774:	e4031002 	str	r1, [r3], #-2
    4778:	0d000020 	stceq	0, cr0, [r0, #-128]	; 0xffffff80
    477c:	00002235 	andeq	r2, r0, r5, lsr r2
    4780:	0105b901 	tsteq	r5, r1, lsl #18
    4784:	00000287 	andeq	r0, r0, r7, lsl #5
    4788:	0000bda0 	andeq	fp, r0, r0, lsr #27
    478c:	00000040 	andeq	r0, r0, r0, asr #32
    4790:	610e9c01 	tstvs	lr, r1, lsl #24
    4794:	05b90100 	ldreq	r0, [r9, #256]!	; 0x100
    4798:	00029a16 	andeq	r9, r2, r6, lsl sl
    479c:	00004a00 	andeq	r4, r0, r0, lsl #20
    47a0:	00004600 	andeq	r4, r0, r0, lsl #12
    47a4:	66640f00 	strbtvs	r0, [r4], -r0, lsl #30
    47a8:	bf010061 	svclt	0x00010061
    47ac:	02b91005 	adcseq	r1, r9, #5
    47b0:	00730000 	rsbseq	r0, r3, r0
    47b4:	006d0000 	rsbeq	r0, sp, r0
    47b8:	680f0000 	stmdavs	pc, {}	; <UNPREDICTABLE>
    47bc:	c4010069 	strgt	r0, [r1], #-105	; 0xffffff97
    47c0:	02821005 	addeq	r1, r2, #5
    47c4:	00b10000 	adcseq	r0, r1, r0
    47c8:	00af0000 	adceq	r0, pc, r0
    47cc:	6c0f0000 	stcvs	0, cr0, [pc], {-0}
    47d0:	c901006f 	stmdbgt	r1, {r0, r1, r2, r3, r5, r6}
    47d4:	02821005 	addeq	r1, r2, #5
    47d8:	00cb0000 	sbceq	r0, fp, r0
    47dc:	00c50000 	sbceq	r0, r5, r0
    47e0:	00000000 	andeq	r0, r0, r0
    47e4:	00000380 	andeq	r0, r0, r0, lsl #7
    47e8:	157b0004 	ldrbne	r0, [fp, #-4]!
    47ec:	01040000 	mrseq	r0, (UNDEF: 4)
    47f0:	00002278 	andeq	r2, r0, r8, ror r2
    47f4:	001f9a0c 	andseq	r9, pc, ip, lsl #20
    47f8:	001bf000 	andseq	pc, fp, r0
    47fc:	00bde000 	adcseq	lr, sp, r0
    4800:	00012000 	andeq	r2, r1, r0
    4804:	00224300 	eoreq	r4, r2, r0, lsl #6
    4808:	07080200 	streq	r0, [r8, -r0, lsl #4]
    480c:	00001fd9 	ldrdeq	r1, [r0], -r9
    4810:	69050403 	stmdbvs	r5, {r0, r1, sl}
    4814:	0200746e 	andeq	r7, r0, #1845493760	; 0x6e000000
    4818:	1fe30704 	svcne	0x00e30704
    481c:	08020000 	stmdaeq	r2, {}	; <UNPREDICTABLE>
    4820:	00024305 	andeq	r4, r2, r5, lsl #6
    4824:	04080200 	streq	r0, [r8], #-512	; 0xfffffe00
    4828:	00001f8e 	andeq	r1, r0, lr, lsl #31
    482c:	9f080102 	svcls	0x00080102
    4830:	02000008 	andeq	r0, r0, #8
    4834:	08a10601 	stmiaeq	r1!, {r0, r9, sl}
    4838:	66040000 	strvs	r0, [r4], -r0
    483c:	07000021 	streq	r0, [r0, -r1, lsr #32]
    4840:	00004801 	andeq	r4, r0, r1, lsl #16
    4844:	06170200 	ldreq	r0, [r7], -r0, lsl #4
    4848:	000001e3 	andeq	r0, r0, r3, ror #3
    484c:	001cf005 	andseq	pc, ip, r5
    4850:	15050000 	strne	r0, [r5, #-0]
    4854:	01000022 	tsteq	r0, r2, lsr #32
    4858:	001ec305 	andseq	ip, lr, r5, lsl #6
    485c:	81050200 	mrshi	r0, SP_usr
    4860:	0300001f 	movweq	r0, #31
    4864:	00217f05 	eoreq	r7, r1, r5, lsl #30
    4868:	25050400 	strcs	r0, [r5, #-1024]	; 0xfffffc00
    486c:	05000022 	streq	r0, [r0, #-34]	; 0xffffffde
    4870:	00219505 	eoreq	r9, r1, r5, lsl #10
    4874:	ca050600 	bgt	14607c <__bss_end+0x139d3c>
    4878:	0700001f 	smladeq	r0, pc, r0, r0	; <UNPREDICTABLE>
    487c:	00211005 	eoreq	r1, r1, r5
    4880:	1e050800 	cdpne	8, 0, cr0, cr5, cr0, {0}
    4884:	09000021 	stmdbeq	r0, {r0, r5}
    4888:	00212c05 	eoreq	r2, r1, r5, lsl #24
    488c:	33050a00 	movwcc	r0, #23040	; 0x5a00
    4890:	0b000020 	bleq	4918 <shift+0x4918>
    4894:	00202305 	eoreq	r2, r0, r5, lsl #6
    4898:	0c050c00 	stceq	12, cr0, [r5], {-0}
    489c:	0d00001d 	stceq	0, cr0, [r0, #-116]	; 0xffffff8c
    48a0:	001d2505 	andseq	r2, sp, r5, lsl #10
    48a4:	14050e00 	strne	r0, [r5], #-3584	; 0xfffff200
    48a8:	0f000020 	svceq	0x00000020
    48ac:	0021d805 	eoreq	sp, r1, r5, lsl #16
    48b0:	55051000 	strpl	r1, [r5, #-0]
    48b4:	11000021 	tstne	r0, r1, lsr #32
    48b8:	0021c905 	eoreq	ip, r1, r5, lsl #18
    48bc:	d2051200 	andle	r1, r5, #0, 4
    48c0:	1300001d 	movwne	r0, #29
    48c4:	001d4f05 	andseq	r4, sp, r5, lsl #30
    48c8:	19051400 	stmdbne	r5, {sl, ip}
    48cc:	1500001d 	strne	r0, [r0, #-29]	; 0xffffffe3
    48d0:	0020b205 	eoreq	fp, r0, r5, lsl #4
    48d4:	86051600 	strhi	r1, [r5], -r0, lsl #12
    48d8:	1700001d 	smladne	r0, sp, r0, r0
    48dc:	001cc105 	andseq	ip, ip, r5, lsl #2
    48e0:	bb051800 	bllt	14a8e8 <__bss_end+0x13e5a8>
    48e4:	19000021 	stmdbne	r0, {r0, r5}
    48e8:	001ff005 	andseq	pc, pc, r5
    48ec:	ca051a00 	bgt	14b0f4 <__bss_end+0x13edb4>
    48f0:	1b000020 	blne	4978 <shift+0x4978>
    48f4:	001d5a05 	andseq	r5, sp, r5, lsl #20
    48f8:	66051c00 	strvs	r1, [r5], -r0, lsl #24
    48fc:	1d00001f 	stcne	0, cr0, [r0, #-124]	; 0xffffff84
    4900:	001eb505 	andseq	fp, lr, r5, lsl #10
    4904:	47051e00 	strmi	r1, [r5, -r0, lsl #28]
    4908:	1f000021 	svcne	0x00000021
    490c:	0021a305 	eoreq	sl, r1, r5, lsl #6
    4910:	e4052000 	str	r2, [r5], #-0
    4914:	21000021 	tstcs	r0, r1, lsr #32
    4918:	0021f205 	eoreq	pc, r1, r5, lsl #4
    491c:	07052200 	streq	r2, [r5, -r0, lsl #4]
    4920:	23000020 	movwcs	r0, #32
    4924:	001f2a05 	andseq	r2, pc, r5, lsl #20
    4928:	69052400 	stmdbvs	r5, {sl, sp}
    492c:	2500001d 	strcs	r0, [r0, #-29]	; 0xffffffe3
    4930:	001fbd05 	andseq	fp, pc, r5, lsl #26
    4934:	cf052600 	svcgt	0x00052600
    4938:	2700001e 	smladcs	r0, lr, r0, r0
    493c:	00217205 	eoreq	r7, r1, r5, lsl #4
    4940:	df052800 	svcle	0x00052800
    4944:	2900001e 	stmdbcs	r0, {r1, r2, r3, r4}
    4948:	001eee05 	andseq	lr, lr, r5, lsl #28
    494c:	fd052a00 	stc2	10, cr2, [r5, #-0]	; <UNPREDICTABLE>
    4950:	2b00001e 	blcs	49d0 <shift+0x49d0>
    4954:	001f0c05 	andseq	r0, pc, r5, lsl #24
    4958:	9a052c00 	bls	14f960 <__bss_end+0x143620>
    495c:	2d00001e 	stccs	0, cr0, [r0, #-120]	; 0xffffff88
    4960:	001f1b05 	andseq	r1, pc, r5, lsl #22
    4964:	01052e00 	tsteq	r5, r0, lsl #28
    4968:	2f000021 	svccs	0x00000021
    496c:	001f3905 	andseq	r3, pc, r5, lsl #18
    4970:	48053000 	stmdami	r5, {ip, sp}
    4974:	3100001f 	tstcc	r0, pc, lsl r0
    4978:	001cfa05 	andseq	pc, ip, r5, lsl #20
    497c:	52053200 	andpl	r3, r5, #0, 4
    4980:	33000020 	movwcc	r0, #32
    4984:	00206205 	eoreq	r6, r0, r5, lsl #4
    4988:	72053400 	andvc	r3, r5, #0, 8
    498c:	35000020 	strcc	r0, [r0, #-32]	; 0xffffffe0
    4990:	001e8805 	andseq	r8, lr, r5, lsl #16
    4994:	82053600 	andhi	r3, r5, #0, 12
    4998:	37000020 	strcc	r0, [r0, -r0, lsr #32]
    499c:	00209205 	eoreq	r9, r0, r5, lsl #4
    49a0:	a2053800 	andge	r3, r5, #0, 16
    49a4:	39000020 	stmdbcc	r0, {r5}
    49a8:	001d7905 	andseq	r7, sp, r5, lsl #18
    49ac:	32053a00 	andcc	r3, r5, #0, 20
    49b0:	3b00001d 	blcc	4a2c <shift+0x4a2c>
    49b4:	001f5705 	andseq	r5, pc, r5, lsl #14
    49b8:	d1053c00 	tstle	r5, r0, lsl #24
    49bc:	3d00001c 	stccc	0, cr0, [r0, #-112]	; 0xffffff90
    49c0:	0020bd05 	eoreq	fp, r0, r5, lsl #26
    49c4:	06003e00 	streq	r3, [r0], -r0, lsl #28
    49c8:	00001db9 			; <UNDEFINED> instruction: 0x00001db9
    49cc:	026b0202 	rsbeq	r0, fp, #536870912	; 0x20000000
    49d0:	00020e08 	andeq	r0, r2, r8, lsl #28
    49d4:	1f7c0700 	svcne	0x007c0700
    49d8:	70020000 	andvc	r0, r2, r0
    49dc:	00561402 	subseq	r1, r6, r2, lsl #8
    49e0:	07000000 	streq	r0, [r0, -r0]
    49e4:	00001e95 	muleq	r0, r5, lr
    49e8:	14027102 	strne	r7, [r2], #-258	; 0xfffffefe
    49ec:	00000056 	andeq	r0, r0, r6, asr r0
    49f0:	e3080001 	movw	r0, #32769	; 0x8001
    49f4:	09000001 	stmdbeq	r0, {r0}
    49f8:	0000020e 	andeq	r0, r0, lr, lsl #4
    49fc:	00000223 	andeq	r0, r0, r3, lsr #4
    4a00:	0000330a 	andeq	r3, r0, sl, lsl #6
    4a04:	08001100 	stmdaeq	r0, {r8, ip}
    4a08:	00000213 	andeq	r0, r0, r3, lsl r2
    4a0c:	0020400b 	eoreq	r4, r0, fp
    4a10:	02740200 	rsbseq	r0, r4, #0, 4
    4a14:	00022326 	andeq	r2, r2, r6, lsr #6
    4a18:	3d3a2400 	cfldrscc	mvf2, [sl, #-0]
    4a1c:	3d0f3d0a 	stccc	13, cr3, [pc, #-40]	; 49fc <shift+0x49fc>
    4a20:	3d323d24 	ldccc	13, cr3, [r2, #-144]!	; 0xffffff70
    4a24:	3d053d02 	stccc	13, cr3, [r5, #-8]
    4a28:	3d0d3d13 	stccc	13, cr3, [sp, #-76]	; 0xffffffb4
    4a2c:	3d233d0c 	stccc	13, cr3, [r3, #-48]!	; 0xffffffd0
    4a30:	3d263d11 	stccc	13, cr3, [r6, #-68]!	; 0xffffffbc
    4a34:	3d173d01 	ldccc	13, cr3, [r7, #-4]
    4a38:	3d093d08 	stccc	13, cr3, [r9, #-32]	; 0xffffffe0
    4a3c:	02020000 	andeq	r0, r2, #0
    4a40:	00069807 	andeq	r9, r6, r7, lsl #16
    4a44:	08010200 	stmdaeq	r1, {r9}
    4a48:	000008a8 	andeq	r0, r0, r8, lsr #17
    4a4c:	21050202 	tstcs	r5, r2, lsl #4
    4a50:	0c000009 	stceq	0, cr0, [r0], {9}
    4a54:	00002268 	andeq	r2, r0, r8, ror #4
    4a58:	33168103 	tstcc	r6, #-1073741824	; 0xc0000000
    4a5c:	0c000000 	stceq	0, cr0, [r0], {-0}
    4a60:	00002270 	andeq	r2, r0, r0, ror r2
    4a64:	25168503 	ldrcs	r8, [r6, #-1283]	; 0xfffffafd
    4a68:	02000000 	andeq	r0, r0, #0
    4a6c:	1cea0404 	cfstrdne	mvd0, [sl], #16
    4a70:	08020000 	stmdaeq	r2, {}	; <UNPREDICTABLE>
    4a74:	001ce203 	andseq	lr, ip, r3, lsl #4
    4a78:	04080200 	streq	r0, [r8], #-512	; 0xfffffe00
    4a7c:	00001f93 	muleq	r0, r3, pc	; <UNPREDICTABLE>
    4a80:	e4031002 	str	r1, [r3], #-2
    4a84:	0d000020 	stceq	0, cr0, [r0, #-128]	; 0xffffff80
    4a88:	0000232c 	andeq	r2, r0, ip, lsr #6
    4a8c:	0103b301 	tsteq	r3, r1, lsl #6
    4a90:	0000027b 	andeq	r0, r0, fp, ror r2
    4a94:	0000bde0 	andeq	fp, r0, r0, ror #27
    4a98:	00000120 	andeq	r0, r0, r0, lsr #2
    4a9c:	037d9c01 	cmneq	sp, #256	; 0x100
    4aa0:	6e0e0000 	cdpvs	0, 0, cr0, cr14, cr0, {0}
    4aa4:	03b30100 			; <UNDEFINED> instruction: 0x03b30100
    4aa8:	00027b17 	andeq	r7, r2, r7, lsl fp
    4aac:	00014900 	andeq	r4, r1, r0, lsl #18
    4ab0:	00014500 	andeq	r4, r1, r0, lsl #10
    4ab4:	00640e00 	rsbeq	r0, r4, r0, lsl #28
    4ab8:	2203b301 	andcs	fp, r3, #67108864	; 0x4000000
    4abc:	0000027b 	andeq	r0, r0, fp, ror r2
    4ac0:	00000175 	andeq	r0, r0, r5, ror r1
    4ac4:	00000171 	andeq	r0, r0, r1, ror r1
    4ac8:	0070720f 	rsbseq	r7, r0, pc, lsl #4
    4acc:	2e03b301 	cdpcs	3, 0, cr11, cr3, cr1, {0}
    4ad0:	0000037d 	andeq	r0, r0, sp, ror r3
    4ad4:	10009102 	andne	r9, r0, r2, lsl #2
    4ad8:	b5010071 	strlt	r0, [r1, #-113]	; 0xffffff8f
    4adc:	027b0b03 	rsbseq	r0, fp, #3072	; 0xc00
    4ae0:	01a50000 			; <UNDEFINED> instruction: 0x01a50000
    4ae4:	019d0000 	orrseq	r0, sp, r0
    4ae8:	72100000 	andsvc	r0, r0, #0
    4aec:	03b50100 			; <UNDEFINED> instruction: 0x03b50100
    4af0:	00027b12 	andeq	r7, r2, r2, lsl fp
    4af4:	0001fb00 	andeq	pc, r1, r0, lsl #22
    4af8:	0001f100 	andeq	pc, r1, r0, lsl #2
    4afc:	00791000 	rsbseq	r1, r9, r0
    4b00:	1903b501 	stmdbne	r3, {r0, r8, sl, ip, sp, pc}
    4b04:	0000027b 	andeq	r0, r0, fp, ror r2
    4b08:	00000259 	andeq	r0, r0, r9, asr r2
    4b0c:	00000253 	andeq	r0, r0, r3, asr r2
    4b10:	317a6c10 	cmncc	sl, r0, lsl ip
    4b14:	03b60100 			; <UNDEFINED> instruction: 0x03b60100
    4b18:	00026f0a 	andeq	r6, r2, sl, lsl #30
    4b1c:	00029300 	andeq	r9, r2, r0, lsl #6
    4b20:	00029100 	andeq	r9, r2, r0, lsl #2
    4b24:	7a6c1000 	bvc	1b08b2c <__bss_end+0x1afc7ec>
    4b28:	b6010032 			; <UNDEFINED> instruction: 0xb6010032
    4b2c:	026f0f03 	rsbeq	r0, pc, #3, 30
    4b30:	02aa0000 	adceq	r0, sl, #0
    4b34:	02a80000 	adceq	r0, r8, #0
    4b38:	69100000 	ldmdbvs	r0, {}	; <UNPREDICTABLE>
    4b3c:	03b60100 			; <UNDEFINED> instruction: 0x03b60100
    4b40:	00026f14 	andeq	r6, r2, r4, lsl pc
    4b44:	0002c900 	andeq	ip, r2, r0, lsl #18
    4b48:	0002bd00 	andeq	fp, r2, r0, lsl #26
    4b4c:	006b1000 	rsbeq	r1, fp, r0
    4b50:	1703b601 	strne	fp, [r3, -r1, lsl #12]
    4b54:	0000026f 	andeq	r0, r0, pc, ror #4
    4b58:	0000031b 	andeq	r0, r0, fp, lsl r3
    4b5c:	00000317 	andeq	r0, r0, r7, lsl r3
    4b60:	7b041100 	blvc	108f68 <__bss_end+0xfcc28>
    4b64:	00000002 	andeq	r0, r0, r2
    4b68:	00000139 	andeq	r0, r0, r9, lsr r1
    4b6c:	167e0004 	ldrbtne	r0, [lr], -r4
    4b70:	01040000 	mrseq	r0, (UNDEF: 4)
    4b74:	000023d8 	ldrdeq	r2, [r0], -r8
    4b78:	0023a40c 	eoreq	sl, r3, ip, lsl #8
    4b7c:	00234000 	eoreq	r4, r3, r0
    4b80:	00bf0000 	adcseq	r0, pc, r0
    4b84:	00011800 	andeq	r1, r1, r0, lsl #16
    4b88:	0023b000 	eoreq	fp, r3, r0
    4b8c:	05040200 	streq	r0, [r4, #-512]	; 0xfffffe00
    4b90:	00746e69 	rsbseq	r6, r4, r9, ror #28
    4b94:	00233903 	eoreq	r3, r3, r3, lsl #18
    4b98:	17d10200 	ldrbne	r0, [r1, r0, lsl #4]
    4b9c:	00000038 	andeq	r0, r0, r8, lsr r0
    4ba0:	e3070404 	movw	r0, #29700	; 0x7404
    4ba4:	0400001f 	streq	r0, [r0], #-31	; 0xffffffe1
    4ba8:	02430508 	subeq	r0, r3, #8, 10	; 0x2000000
    4bac:	08040000 	stmdaeq	r4, {}	; <UNPREDICTABLE>
    4bb0:	001f8e04 	andseq	r8, pc, r4, lsl #28
    4bb4:	06010400 	streq	r0, [r1], -r0, lsl #8
    4bb8:	000008a1 	andeq	r0, r0, r1, lsr #17
    4bbc:	9f080104 	svcls	0x00080104
    4bc0:	04000008 	streq	r0, [r0], #-8
    4bc4:	09210502 	stmdbeq	r1!, {r1, r8, sl}
    4bc8:	02040000 	andeq	r0, r4, #0
    4bcc:	00069807 	andeq	r9, r6, r7, lsl #16
    4bd0:	05040400 	streq	r0, [r4, #-1024]	; 0xfffffc00
    4bd4:	00000248 	andeq	r0, r0, r8, asr #4
    4bd8:	de070404 	cdple	4, 0, cr0, cr7, cr4, {0}
    4bdc:	0400001f 	streq	r0, [r0], #-31	; 0xffffffe1
    4be0:	1fd90708 	svcne	0x00d90708
    4be4:	04050000 	streq	r0, [r5], #-0
    4be8:	00860406 	addeq	r0, r6, r6, lsl #8
    4bec:	01040000 	mrseq	r0, (UNDEF: 4)
    4bf0:	0008a808 	andeq	sl, r8, r8, lsl #16
    4bf4:	24480700 	strbcs	r0, [r8], #-1792	; 0xfffff900
    4bf8:	21030000 	mrscs	r0, (UNDEF: 3)
    4bfc:	00007e09 	andeq	r7, r0, r9, lsl #28
    4c00:	00bf0000 	adcseq	r0, pc, r0
    4c04:	00011800 	andeq	r1, r1, r0, lsl #16
    4c08:	369c0100 	ldrcc	r0, [ip], r0, lsl #2
    4c0c:	08000001 	stmdaeq	r0, {r0}
    4c10:	2601006d 	strcs	r0, [r1], -sp, rrx
    4c14:	00007e0f 	andeq	r7, r0, pc, lsl #28
    4c18:	09500100 	ldmdbeq	r0, {r8}^
    4c1c:	27010063 	strcs	r0, [r1, -r3, rrx]
    4c20:	00002506 	andeq	r2, r0, r6, lsl #10
    4c24:	00034500 	andeq	r4, r3, r0, lsl #10
    4c28:	00033b00 	andeq	r3, r3, r0, lsl #22
    4c2c:	006e0900 	rsbeq	r0, lr, r0, lsl #18
    4c30:	2c092801 	stccs	8, cr2, [r9], {1}
    4c34:	9c000000 	stcls	0, cr0, [r0], {-0}
    4c38:	8a000003 	bhi	4c4c <shift+0x4c4c>
    4c3c:	0a000003 	beq	4c50 <shift+0x4c50>
    4c40:	2a010073 	bcs	44e14 <__bss_end+0x38ad4>
    4c44:	00008009 	andeq	r8, r0, r9
    4c48:	00042300 	andeq	r2, r4, r0, lsl #6
    4c4c:	00040d00 	andeq	r0, r4, r0, lsl #26
    4c50:	00690a00 	rsbeq	r0, r9, r0, lsl #20
    4c54:	38102d01 	ldmdacc	r0, {r0, r8, sl, fp, sp}
    4c58:	b0000000 	andlt	r0, r0, r0
    4c5c:	aa000004 	bge	4c74 <shift+0x4c74>
    4c60:	0b000004 	bleq	4c78 <shift+0x4c78>
    4c64:	00000d6d 	andeq	r0, r0, sp, ror #26
    4c68:	70112e01 	andsvc	r2, r1, r1, lsl #28
    4c6c:	e5000000 	str	r0, [r0, #-0]
    4c70:	df000004 	svcle	0x00000004
    4c74:	0b000004 	bleq	4c8c <shift+0x4c8c>
    4c78:	00002397 	muleq	r0, r7, r3
    4c7c:	36122f01 	ldrcc	r2, [r2], -r1, lsl #30
    4c80:	26000001 	strcs	r0, [r0], -r1
    4c84:	0e000005 	cdpeq	0, 0, cr0, cr0, cr5, {0}
    4c88:	0a000005 	beq	4ca4 <shift+0x4ca4>
    4c8c:	30010064 	andcc	r0, r1, r4, rrx
    4c90:	00003810 	andeq	r3, r0, r0, lsl r8
    4c94:	0005c600 	andeq	ip, r5, r0, lsl #12
    4c98:	0005bc00 	andeq	fp, r5, r0, lsl #24
    4c9c:	04060000 	streq	r0, [r6], #-0
    4ca0:	00000070 	andeq	r0, r0, r0, ror r0
	...

Disassembly of section .debug_abbrev:

00000000 <.debug_abbrev>:
       0:	10001101 	andne	r1, r0, r1, lsl #2
       4:	12011106 	andne	r1, r1, #-2147483647	; 0x80000001
       8:	1b0e0301 	blne	380c14 <__bss_end+0x3748d4>
       c:	130e250e 	movwne	r2, #58638	; 0xe50e
      10:	00000005 	andeq	r0, r0, r5
      14:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
      18:	030b130e 	movweq	r1, #45838	; 0xb30e
      1c:	110e1b0e 	tstne	lr, lr, lsl #22
      20:	10061201 	andne	r1, r6, r1, lsl #4
      24:	02000017 	andeq	r0, r0, #23
      28:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
      2c:	0b3b0b3a 	bleq	ec2d1c <__bss_end+0xeb69dc>
      30:	13490b39 	movtne	r0, #39737	; 0x9b39
      34:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
      38:	24030000 	strcs	r0, [r3], #-0
      3c:	3e0b0b00 	vmlacc.f64	d0, d11, d0
      40:	000e030b 	andeq	r0, lr, fp, lsl #6
      44:	012e0400 			; <UNDEFINED> instruction: 0x012e0400
      48:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
      4c:	0b3b0b3a 	bleq	ec2d3c <__bss_end+0xeb69fc>
      50:	01110b39 	tsteq	r1, r9, lsr fp
      54:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
      58:	01194296 			; <UNDEFINED> instruction: 0x01194296
      5c:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
      60:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
      64:	0b3b0b3a 	bleq	ec2d54 <__bss_end+0xeb6a14>
      68:	13490b39 	movtne	r0, #39737	; 0x9b39
      6c:	00001802 	andeq	r1, r0, r2, lsl #16
      70:	0b002406 	bleq	9090 <_ZN5Model4InitEv+0x22c>
      74:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
      78:	07000008 	streq	r0, [r0, -r8]
      7c:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
      80:	0b3a0e03 	bleq	e83894 <__bss_end+0xe77554>
      84:	0b390b3b 	bleq	e42d78 <__bss_end+0xe36a38>
      88:	06120111 			; <UNDEFINED> instruction: 0x06120111
      8c:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
      90:	00130119 	andseq	r0, r3, r9, lsl r1
      94:	010b0800 	tsteq	fp, r0, lsl #16
      98:	06120111 			; <UNDEFINED> instruction: 0x06120111
      9c:	34090000 	strcc	r0, [r9], #-0
      a0:	3a080300 	bcc	200ca8 <__bss_end+0x1f4968>
      a4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
      a8:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
      ac:	0a000018 	beq	114 <shift+0x114>
      b0:	0b0b000f 	bleq	2c00f4 <__bss_end+0x2b3db4>
      b4:	00001349 	andeq	r1, r0, r9, asr #6
      b8:	01110100 	tsteq	r1, r0, lsl #2
      bc:	0b130e25 	bleq	4c3958 <__bss_end+0x4b7618>
      c0:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
      c4:	06120111 			; <UNDEFINED> instruction: 0x06120111
      c8:	00001710 	andeq	r1, r0, r0, lsl r7
      cc:	03001602 	movweq	r1, #1538	; 0x602
      d0:	3b0b3a0e 	blcc	2ce910 <__bss_end+0x2c25d0>
      d4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
      d8:	03000013 	movweq	r0, #19
      dc:	0b0b000f 	bleq	2c0120 <__bss_end+0x2b3de0>
      e0:	00001349 	andeq	r1, r0, r9, asr #6
      e4:	00001504 	andeq	r1, r0, r4, lsl #10
      e8:	01010500 	tsteq	r1, r0, lsl #10
      ec:	13011349 	movwne	r1, #4937	; 0x1349
      f0:	21060000 	mrscs	r0, (UNDEF: 6)
      f4:	2f134900 	svccs	0x00134900
      f8:	07000006 	streq	r0, [r0, -r6]
      fc:	0b0b0024 	bleq	2c0194 <__bss_end+0x2b3e54>
     100:	0e030b3e 	vmoveq.16	d3[0], r0
     104:	34080000 	strcc	r0, [r8], #-0
     108:	3a0e0300 	bcc	380d10 <__bss_end+0x3749d0>
     10c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     110:	3f13490b 	svccc	0x0013490b
     114:	00193c19 	andseq	r3, r9, r9, lsl ip
     118:	012e0900 			; <UNDEFINED> instruction: 0x012e0900
     11c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
     120:	0b3b0b3a 	bleq	ec2e10 <__bss_end+0xeb6ad0>
     124:	13490b39 	movtne	r0, #39737	; 0x9b39
     128:	06120111 			; <UNDEFINED> instruction: 0x06120111
     12c:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
     130:	00130119 	andseq	r0, r3, r9, lsl r1
     134:	00340a00 	eorseq	r0, r4, r0, lsl #20
     138:	0b3a0e03 	bleq	e8394c <__bss_end+0xe7760c>
     13c:	0b390b3b 	bleq	e42e30 <__bss_end+0xe36af0>
     140:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
     144:	240b0000 	strcs	r0, [fp], #-0
     148:	3e0b0b00 	vmlacc.f64	d0, d11, d0
     14c:	0008030b 	andeq	r0, r8, fp, lsl #6
     150:	002e0c00 	eoreq	r0, lr, r0, lsl #24
     154:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
     158:	0b3b0b3a 	bleq	ec2e48 <__bss_end+0xeb6b08>
     15c:	01110b39 	tsteq	r1, r9, lsr fp
     160:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
     164:	00194297 	mulseq	r9, r7, r2
     168:	01390d00 	teqeq	r9, r0, lsl #26
     16c:	0b3a0e03 	bleq	e83980 <__bss_end+0xe77640>
     170:	13010b3b 	movwne	r0, #6971	; 0x1b3b
     174:	2e0e0000 	cdpcs	0, 0, cr0, cr14, cr0, {0}
     178:	03193f01 	tsteq	r9, #1, 30
     17c:	3b0b3a0e 	blcc	2ce9bc <__bss_end+0x2c267c>
     180:	3c0b390b 			; <UNDEFINED> instruction: 0x3c0b390b
     184:	00130119 	andseq	r0, r3, r9, lsl r1
     188:	00050f00 	andeq	r0, r5, r0, lsl #30
     18c:	00001349 	andeq	r1, r0, r9, asr #6
     190:	3f012e10 	svccc	0x00012e10
     194:	3a0e0319 	bcc	380e00 <__bss_end+0x374ac0>
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
     1c0:	3a080300 	bcc	200dc8 <__bss_end+0x1f4a88>
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
     1f4:	0b0b0024 	bleq	2c028c <__bss_end+0x2b3f4c>
     1f8:	0e030b3e 	vmoveq.16	d3[0], r0
     1fc:	26030000 	strcs	r0, [r3], -r0
     200:	00134900 	andseq	r4, r3, r0, lsl #18
     204:	00240400 	eoreq	r0, r4, r0, lsl #8
     208:	0b3e0b0b 	bleq	f82e3c <__bss_end+0xf76afc>
     20c:	00000803 	andeq	r0, r0, r3, lsl #16
     210:	03001605 	movweq	r1, #1541	; 0x605
     214:	3b0b3a0e 	blcc	2cea54 <__bss_end+0x2c2714>
     218:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     21c:	06000013 			; <UNDEFINED> instruction: 0x06000013
     220:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
     224:	0b3b0b3a 	bleq	ec2f14 <__bss_end+0xeb6bd4>
     228:	13490b39 	movtne	r0, #39737	; 0x9b39
     22c:	1802196c 	stmdane	r2, {r2, r3, r5, r6, r8, fp, ip}
     230:	04070000 	streq	r0, [r7], #-0
     234:	6d0e0301 	stcvs	3, cr0, [lr, #-4]
     238:	0b0b3e19 	bleq	2cfaa4 <__bss_end+0x2c3764>
     23c:	3a13490b 	bcc	4d2670 <__bss_end+0x4c6330>
     240:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     244:	0013010b 	andseq	r0, r3, fp, lsl #2
     248:	00280800 	eoreq	r0, r8, r0, lsl #16
     24c:	0b1c0e03 	bleq	703a60 <__bss_end+0x6f7720>
     250:	0f090000 	svceq	0x00090000
     254:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
     258:	0a000013 	beq	2ac <shift+0x2ac>
     25c:	0b0b000f 	bleq	2c02a0 <__bss_end+0x2b3f60>
     260:	020b0000 	andeq	r0, fp, #0
     264:	0b0e0301 	bleq	380e70 <__bss_end+0x374b30>
     268:	3b0b3a0b 	blcc	2cea9c <__bss_end+0x2c275c>
     26c:	010b390b 	tsteq	fp, fp, lsl #18
     270:	0c000013 	stceq	0, cr0, [r0], {19}
     274:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
     278:	0b3b0b3a 	bleq	ec2f68 <__bss_end+0xeb6c28>
     27c:	13490b39 	movtne	r0, #39737	; 0x9b39
     280:	00000b38 	andeq	r0, r0, r8, lsr fp
     284:	3f012e0d 	svccc	0x00012e0d
     288:	3a0e0319 	bcc	380ef4 <__bss_end+0x374bb4>
     28c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     290:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
     294:	3c0b3213 	sfmcc	f3, 4, [fp], {19}
     298:	01136419 	tsteq	r3, r9, lsl r4
     29c:	0e000013 	mcreq	0, 0, r0, cr0, cr3, {0}
     2a0:	13490005 	movtne	r0, #36869	; 0x9005
     2a4:	00001934 	andeq	r1, r0, r4, lsr r9
     2a8:	3f012e0f 	svccc	0x00012e0f
     2ac:	3a0e0319 	bcc	380f18 <__bss_end+0x374bd8>
     2b0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     2b4:	320e6e0b 	andcc	r6, lr, #11, 28	; 0xb0
     2b8:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
     2bc:	00130113 	andseq	r0, r3, r3, lsl r1
     2c0:	00051000 	andeq	r1, r5, r0
     2c4:	00001349 	andeq	r1, r0, r9, asr #6
     2c8:	3f012e11 	svccc	0x00012e11
     2cc:	3a0e0319 	bcc	380f38 <__bss_end+0x374bf8>
     2d0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     2d4:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
     2d8:	3c0b3213 	sfmcc	f3, 4, [fp], {19}
     2dc:	00136419 	andseq	r6, r3, r9, lsl r4
     2e0:	00341200 	eorseq	r1, r4, r0, lsl #4
     2e4:	0b3a0803 	bleq	e822f8 <__bss_end+0xe75fb8>
     2e8:	0b390b3b 	bleq	e42fdc <__bss_end+0xe36c9c>
     2ec:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
     2f0:	0000193c 	andeq	r1, r0, ip, lsr r9
     2f4:	03010213 	movweq	r0, #4627	; 0x1213
     2f8:	3a050b0e 	bcc	142f38 <__bss_end+0x136bf8>
     2fc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     300:	0013010b 	andseq	r0, r3, fp, lsl #2
     304:	000d1400 	andeq	r1, sp, r0, lsl #8
     308:	0b3a0e03 	bleq	e83b1c <__bss_end+0xe777dc>
     30c:	0b390b3b 	bleq	e43000 <__bss_end+0xe36cc0>
     310:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
     314:	0b1c193c 	bleq	70680c <__bss_end+0x6fa4cc>
     318:	2e150000 	cdpcs	0, 1, cr0, cr5, cr0, {0}
     31c:	03193f01 	tsteq	r9, #1, 30
     320:	3b0b3a0e 	blcc	2ceb60 <__bss_end+0x2c2820>
     324:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
     328:	64193c0e 	ldrvs	r3, [r9], #-3086	; 0xfffff3f2
     32c:	00130113 	andseq	r0, r3, r3, lsl r1
     330:	012e1600 			; <UNDEFINED> instruction: 0x012e1600
     334:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
     338:	0b3b0b3a 	bleq	ec3028 <__bss_end+0xeb6ce8>
     33c:	0e6e0b39 	vmoveq.8	d14[5], r0
     340:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
     344:	13011364 	movwne	r1, #4964	; 0x1364
     348:	2e170000 	cdpcs	0, 1, cr0, cr7, cr0, {0}
     34c:	03193f01 	tsteq	r9, #1, 30
     350:	3b0b3a0e 	blcc	2ceb90 <__bss_end+0x2c2850>
     354:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
     358:	3c0b320e 	sfmcc	f3, 4, [fp], {14}
     35c:	00136419 	andseq	r6, r3, r9, lsl r4
     360:	01011800 	tsteq	r1, r0, lsl #16
     364:	13011349 	movwne	r1, #4937	; 0x1349
     368:	21190000 	tstcs	r9, r0
     36c:	2f134900 	svccs	0x00134900
     370:	1a00000b 	bne	3a4 <shift+0x3a4>
     374:	0803000d 	stmdaeq	r3, {r0, r2, r3}
     378:	0b3b0b3a 	bleq	ec3068 <__bss_end+0xeb6d28>
     37c:	13490b39 	movtne	r0, #39737	; 0x9b39
     380:	00000b38 	andeq	r0, r0, r8, lsr fp
     384:	0301131b 	movweq	r1, #4891	; 0x131b
     388:	3a0b0b0e 	bcc	2c2fc8 <__bss_end+0x2b6c88>
     38c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     390:	0013010b 	andseq	r0, r3, fp, lsl #2
     394:	000d1c00 	andeq	r1, sp, r0, lsl #24
     398:	0b3a0e03 	bleq	e83bac <__bss_end+0xe7786c>
     39c:	0b390b3b 	bleq	e43090 <__bss_end+0xe36d50>
     3a0:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
     3a4:	0a1c193c 	beq	70689c <__bss_end+0x6fa55c>
     3a8:	0000196c 	andeq	r1, r0, ip, ror #18
     3ac:	3f012e1d 	svccc	0x00012e1d
     3b0:	3a080319 	bcc	20101c <__bss_end+0x1f4cdc>
     3b4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     3b8:	320e6e0b 	andcc	r6, lr, #11, 28	; 0xb0
     3bc:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
     3c0:	1e000013 	mcrne	0, 0, r0, cr0, cr3, {0}
     3c4:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
     3c8:	0b3b0b3a 	bleq	ec30b8 <__bss_end+0xeb6d78>
     3cc:	13490b39 	movtne	r0, #39737	; 0x9b39
     3d0:	00001802 	andeq	r1, r0, r2, lsl #16
     3d4:	3f012e1f 	svccc	0x00012e1f
     3d8:	3a0e0319 	bcc	381044 <__bss_end+0x374d04>
     3dc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     3e0:	1113490b 	tstne	r3, fp, lsl #18
     3e4:	40061201 	andmi	r1, r6, r1, lsl #4
     3e8:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
     3ec:	00001301 	andeq	r1, r0, r1, lsl #6
     3f0:	03003420 	movweq	r3, #1056	; 0x420
     3f4:	3b0b3a08 	blcc	2cec1c <__bss_end+0x2c28dc>
     3f8:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     3fc:	00180213 	andseq	r0, r8, r3, lsl r2
     400:	012e2100 			; <UNDEFINED> instruction: 0x012e2100
     404:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
     408:	0b3b0b3a 	bleq	ec30f8 <__bss_end+0xeb6db8>
     40c:	0e6e0b39 	vmoveq.8	d14[5], r0
     410:	06120111 			; <UNDEFINED> instruction: 0x06120111
     414:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
     418:	00130119 	andseq	r0, r3, r9, lsl r1
     41c:	00052200 	andeq	r2, r5, r0, lsl #4
     420:	0b3a0803 	bleq	e82434 <__bss_end+0xe760f4>
     424:	0b390b3b 	bleq	e43118 <__bss_end+0xe36dd8>
     428:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
     42c:	2e230000 	cdpcs	0, 2, cr0, cr3, cr0, {0}
     430:	03193f01 	tsteq	r9, #1, 30
     434:	3b0b3a0e 	blcc	2cec74 <__bss_end+0x2c2934>
     438:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
     43c:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
     440:	97184006 	ldrls	r4, [r8, -r6]
     444:	13011942 	movwne	r1, #6466	; 0x1942
     448:	05240000 	streq	r0, [r4, #-0]!
     44c:	3a0e0300 	bcc	381054 <__bss_end+0x374d14>
     450:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     454:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
     458:	25000018 	strcs	r0, [r0, #-24]	; 0xffffffe8
     45c:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
     460:	0b3a0e03 	bleq	e83c74 <__bss_end+0xe77934>
     464:	0b390b3b 	bleq	e43158 <__bss_end+0xe36e18>
     468:	13490e6e 	movtne	r0, #40558	; 0x9e6e
     46c:	06120111 			; <UNDEFINED> instruction: 0x06120111
     470:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
     474:	00130119 	andseq	r0, r3, r9, lsl r1
     478:	012e2600 			; <UNDEFINED> instruction: 0x012e2600
     47c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
     480:	0b3b0b3a 	bleq	ec3170 <__bss_end+0xeb6e30>
     484:	0e6e0b39 	vmoveq.8	d14[5], r0
     488:	01111349 	tsteq	r1, r9, asr #6
     48c:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
     490:	00194296 	mulseq	r9, r6, r2
     494:	11010000 	mrsne	r0, (UNDEF: 1)
     498:	130e2501 	movwne	r2, #58625	; 0xe501
     49c:	1b0e030b 	blne	3810d0 <__bss_end+0x374d90>
     4a0:	1117550e 	tstne	r7, lr, lsl #10
     4a4:	00171001 	andseq	r1, r7, r1
     4a8:	01020200 	mrseq	r0, R10_usr
     4ac:	0b0b0e03 	bleq	2c3cc0 <__bss_end+0x2b7980>
     4b0:	0b3b0b3a 	bleq	ec31a0 <__bss_end+0xeb6e60>
     4b4:	13010b39 	movwne	r0, #6969	; 0x1b39
     4b8:	0d030000 	stceq	0, cr0, [r3, #-0]
     4bc:	3a080300 	bcc	2010c4 <__bss_end+0x1f4d84>
     4c0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     4c4:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
     4c8:	0400000b 	streq	r0, [r0], #-11
     4cc:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
     4d0:	0b3b0b3a 	bleq	ec31c0 <__bss_end+0xeb6e80>
     4d4:	13490b39 	movtne	r0, #39737	; 0x9b39
     4d8:	00000b38 	andeq	r0, r0, r8, lsr fp
     4dc:	3f012e05 	svccc	0x00012e05
     4e0:	3a0e0319 	bcc	38114c <__bss_end+0x374e0c>
     4e4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     4e8:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
     4ec:	3c0b3213 	sfmcc	f3, 4, [fp], {19}
     4f0:	01136419 	tsteq	r3, r9, lsl r4
     4f4:	06000013 			; <UNDEFINED> instruction: 0x06000013
     4f8:	13490005 	movtne	r0, #36869	; 0x9005
     4fc:	00001934 	andeq	r1, r0, r4, lsr r9
     500:	49000507 	stmdbmi	r0, {r0, r1, r2, r8, sl}
     504:	08000013 	stmdaeq	r0, {r0, r1, r4}
     508:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
     50c:	0b3a0e03 	bleq	e83d20 <__bss_end+0xe779e0>
     510:	0b390b3b 	bleq	e43204 <__bss_end+0xe36ec4>
     514:	13490e6e 	movtne	r0, #40558	; 0x9e6e
     518:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
     51c:	00001364 	andeq	r1, r0, r4, ror #6
     520:	0b002409 	bleq	954c <_ZN5Model19Eval_String_CommandEPKc+0xb0>
     524:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
     528:	0a000008 	beq	550 <shift+0x550>
     52c:	0b0b000f 	bleq	2c0570 <__bss_end+0x2b4230>
     530:	00001349 	andeq	r1, r0, r9, asr #6
     534:	0b00240b 	bleq	9568 <_ZN5Model19Eval_String_CommandEPKc+0xcc>
     538:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
     53c:	0c00000e 	stceq	0, cr0, [r0], {14}
     540:	13490026 	movtne	r0, #36902	; 0x9026
     544:	160d0000 	strne	r0, [sp], -r0
     548:	3a0e0300 	bcc	381150 <__bss_end+0x374e10>
     54c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     550:	0013490b 	andseq	r4, r3, fp, lsl #18
     554:	012e0e00 			; <UNDEFINED> instruction: 0x012e0e00
     558:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
     55c:	0b3b0b3a 	bleq	ec324c <__bss_end+0xeb6f0c>
     560:	0e6e0b39 	vmoveq.8	d14[5], r0
     564:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
     568:	13011364 	movwne	r1, #4964	; 0x1364
     56c:	0f0f0000 	svceq	0x000f0000
     570:	000b0b00 	andeq	r0, fp, r0, lsl #22
     574:	00341000 	eorseq	r1, r4, r0
     578:	0b3a0803 	bleq	e8258c <__bss_end+0xe7624c>
     57c:	0b390b3b 	bleq	e43270 <__bss_end+0xe36f30>
     580:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
     584:	0000193c 	andeq	r1, r0, ip, lsr r9
     588:	03003411 	movweq	r3, #1041	; 0x411
     58c:	3b0b3a0e 	blcc	2cedcc <__bss_end+0x2c2a8c>
     590:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     594:	02196c13 	andseq	r6, r9, #4864	; 0x1300
     598:	12000018 	andne	r0, r0, #24
     59c:	0e030102 	adfeqs	f0, f3, f2
     5a0:	0b3a050b 	bleq	e819d4 <__bss_end+0xe75694>
     5a4:	0b390b3b 	bleq	e43298 <__bss_end+0xe36f58>
     5a8:	00001301 	andeq	r1, r0, r1, lsl #6
     5ac:	03000d13 	movweq	r0, #3347	; 0xd13
     5b0:	3b0b3a0e 	blcc	2cedf0 <__bss_end+0x2c2ab0>
     5b4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     5b8:	3c193f13 	ldccc	15, cr3, [r9], {19}
     5bc:	000b1c19 	andeq	r1, fp, r9, lsl ip
     5c0:	012e1400 			; <UNDEFINED> instruction: 0x012e1400
     5c4:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
     5c8:	0b3b0b3a 	bleq	ec32b8 <__bss_end+0xeb6f78>
     5cc:	0e6e0b39 	vmoveq.8	d14[5], r0
     5d0:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
     5d4:	00001301 	andeq	r1, r0, r1, lsl #6
     5d8:	3f012e15 	svccc	0x00012e15
     5dc:	3a0e0319 	bcc	381248 <__bss_end+0x374f08>
     5e0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     5e4:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
     5e8:	64193c13 	ldrvs	r3, [r9], #-3091	; 0xfffff3ed
     5ec:	00130113 	andseq	r0, r3, r3, lsl r1
     5f0:	012e1600 			; <UNDEFINED> instruction: 0x012e1600
     5f4:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
     5f8:	0b3b0b3a 	bleq	ec32e8 <__bss_end+0xeb6fa8>
     5fc:	0e6e0b39 	vmoveq.8	d14[5], r0
     600:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
     604:	00001364 	andeq	r1, r0, r4, ror #6
     608:	49010117 	stmdbmi	r1, {r0, r1, r2, r4, r8}
     60c:	00130113 	andseq	r0, r3, r3, lsl r1
     610:	00211800 	eoreq	r1, r1, r0, lsl #16
     614:	0b2f1349 	bleq	bc5340 <__bss_end+0xbb9000>
     618:	13190000 	tstne	r9, #0
     61c:	0b0e0301 	bleq	381228 <__bss_end+0x374ee8>
     620:	3b0b3a0b 	blcc	2cee54 <__bss_end+0x2c2b14>
     624:	010b390b 	tsteq	fp, fp, lsl #18
     628:	1a000013 	bne	67c <shift+0x67c>
     62c:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
     630:	0b3b0b3a 	bleq	ec3320 <__bss_end+0xeb6fe0>
     634:	13490b39 	movtne	r0, #39737	; 0x9b39
     638:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
     63c:	196c0a1c 	stmdbne	ip!, {r2, r3, r4, r9, fp}^
     640:	2e1b0000 	cdpcs	0, 1, cr0, cr11, cr0, {0}
     644:	03193f01 	tsteq	r9, #1, 30
     648:	3b0b3a08 	blcc	2cee70 <__bss_end+0x2c2b30>
     64c:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
     650:	3c0b320e 	sfmcc	f3, 4, [fp], {14}
     654:	00136419 	andseq	r6, r3, r9, lsl r4
     658:	012e1c00 			; <UNDEFINED> instruction: 0x012e1c00
     65c:	0b3a1347 	bleq	e85380 <__bss_end+0xe79040>
     660:	0b39053b 	bleq	e41b54 <__bss_end+0xe35814>
     664:	01111364 	tsteq	r1, r4, ror #6
     668:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
     66c:	01194296 			; <UNDEFINED> instruction: 0x01194296
     670:	1d000013 	stcne	0, cr0, [r0, #-76]	; 0xffffffb4
     674:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
     678:	19341349 	ldmdbne	r4!, {r0, r3, r6, r8, r9, ip}
     67c:	00001802 	andeq	r1, r0, r2, lsl #16
     680:	0300341e 	movweq	r3, #1054	; 0x41e
     684:	3b0b3a0e 	blcc	2ceec4 <__bss_end+0x2c2b84>
     688:	490b3905 	stmdbmi	fp, {r0, r2, r8, fp, ip, sp}
     68c:	00180213 	andseq	r0, r8, r3, lsl r2
     690:	010b1f00 	tsteq	fp, r0, lsl #30
     694:	06120111 			; <UNDEFINED> instruction: 0x06120111
     698:	34200000 	strtcc	r0, [r0], #-0
     69c:	3a080300 	bcc	2012a4 <__bss_end+0x1f4f64>
     6a0:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
     6a4:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
     6a8:	21000018 	tstcs	r0, r8, lsl r0
     6ac:	0111010b 	tsteq	r1, fp, lsl #2
     6b0:	13010612 	movwne	r0, #5650	; 0x1612
     6b4:	05220000 	streq	r0, [r2, #-0]!
     6b8:	3a0e0300 	bcc	3812c0 <__bss_end+0x374f80>
     6bc:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
     6c0:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
     6c4:	23000018 	movwcs	r0, #24
     6c8:	1347012e 	movtne	r0, #28974	; 0x712e
     6cc:	0b3b0b3a 	bleq	ec33bc <__bss_end+0xeb707c>
     6d0:	13640b39 	cmnne	r4, #58368	; 0xe400
     6d4:	06120111 			; <UNDEFINED> instruction: 0x06120111
     6d8:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
     6dc:	00130119 	andseq	r0, r3, r9, lsl r1
     6e0:	00342400 	eorseq	r2, r4, r0, lsl #8
     6e4:	0b3a0e03 	bleq	e83ef8 <__bss_end+0xe77bb8>
     6e8:	0b390b3b 	bleq	e433dc <__bss_end+0xe3709c>
     6ec:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
     6f0:	34250000 	strtcc	r0, [r5], #-0
     6f4:	3a080300 	bcc	2012fc <__bss_end+0x1f4fbc>
     6f8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     6fc:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
     700:	26000018 			; <UNDEFINED> instruction: 0x26000018
     704:	08030005 	stmdaeq	r3, {r0, r2}
     708:	0b3b0b3a 	bleq	ec33f8 <__bss_end+0xeb70b8>
     70c:	13490b39 	movtne	r0, #39737	; 0x9b39
     710:	00001802 	andeq	r1, r0, r2, lsl #16
     714:	03000527 	movweq	r0, #1319	; 0x527
     718:	3b0b3a0e 	blcc	2cef58 <__bss_end+0x2c2c18>
     71c:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     720:	00180213 	andseq	r0, r8, r3, lsl r2
     724:	012e2800 			; <UNDEFINED> instruction: 0x012e2800
     728:	0b3a1347 	bleq	e8544c <__bss_end+0xe7910c>
     72c:	0b390b3b 	bleq	e43420 <__bss_end+0xe370e0>
     730:	01111364 	tsteq	r1, r4, ror #6
     734:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
     738:	01194297 			; <UNDEFINED> instruction: 0x01194297
     73c:	29000013 	stmdbcs	r0, {r0, r1, r4}
     740:	1755010b 	ldrbne	r0, [r5, -fp, lsl #2]
     744:	2e2a0000 	cdpcs	0, 2, cr0, cr10, cr0, {0}
     748:	3a134701 	bcc	4d2354 <__bss_end+0x4c6014>
     74c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     750:	2013640b 	andscs	r6, r3, fp, lsl #8
     754:	0013010b 	andseq	r0, r3, fp, lsl #2
     758:	00052b00 	andeq	r2, r5, r0, lsl #22
     75c:	13490e03 	movtne	r0, #40451	; 0x9e03
     760:	00001934 	andeq	r1, r0, r4, lsr r9
     764:	0300052c 	movweq	r0, #1324	; 0x52c
     768:	3b0b3a0e 	blcc	2cefa8 <__bss_end+0x2c2c68>
     76c:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     770:	2d000013 	stccs	0, cr0, [r0, #-76]	; 0xffffffb4
     774:	08030005 	stmdaeq	r3, {r0, r2}
     778:	0b3b0b3a 	bleq	ec3468 <__bss_end+0xeb7128>
     77c:	13490b39 	movtne	r0, #39737	; 0x9b39
     780:	2e2e0000 	cdpcs	0, 2, cr0, cr14, cr0, {0}
     784:	6e133101 	mufvss	f3, f3, f1
     788:	1113640e 	tstne	r3, lr, lsl #8
     78c:	40061201 	andmi	r1, r6, r1, lsl #4
     790:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
     794:	00001301 	andeq	r1, r0, r1, lsl #6
     798:	3100052f 	tstcc	r0, pc, lsr #10
     79c:	00180213 	andseq	r0, r8, r3, lsl r2
     7a0:	012e3000 			; <UNDEFINED> instruction: 0x012e3000
     7a4:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
     7a8:	0b3b0b3a 	bleq	ec3498 <__bss_end+0xeb7158>
     7ac:	0e6e0b39 	vmoveq.8	d14[5], r0
     7b0:	01111349 	tsteq	r1, r9, asr #6
     7b4:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
     7b8:	01194296 			; <UNDEFINED> instruction: 0x01194296
     7bc:	31000013 	tstcc	r0, r3, lsl r0
     7c0:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
     7c4:	0b3a0e03 	bleq	e83fd8 <__bss_end+0xe77c98>
     7c8:	0b390b3b 	bleq	e434bc <__bss_end+0xe3717c>
     7cc:	13490e6e 	movtne	r0, #40558	; 0x9e6e
     7d0:	06120111 			; <UNDEFINED> instruction: 0x06120111
     7d4:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
     7d8:	00000019 	andeq	r0, r0, r9, lsl r0
     7dc:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
     7e0:	030b130e 	movweq	r1, #45838	; 0xb30e
     7e4:	110e1b0e 	tstne	lr, lr, lsl #22
     7e8:	10061201 	andne	r1, r6, r1, lsl #4
     7ec:	02000017 	andeq	r0, r0, #23
     7f0:	0b0b0024 	bleq	2c0888 <__bss_end+0x2b4548>
     7f4:	08030b3e 	stmdaeq	r3, {r1, r2, r3, r4, r5, r8, r9, fp}
     7f8:	24030000 	strcs	r0, [r3], #-0
     7fc:	3e0b0b00 	vmlacc.f64	d0, d11, d0
     800:	000e030b 	andeq	r0, lr, fp, lsl #6
     804:	00160400 	andseq	r0, r6, r0, lsl #8
     808:	0b3a0e03 	bleq	e8401c <__bss_end+0xe77cdc>
     80c:	0b390b3b 	bleq	e43500 <__bss_end+0xe371c0>
     810:	00001349 	andeq	r1, r0, r9, asr #6
     814:	49002605 	stmdbmi	r0, {r0, r2, r9, sl, sp}
     818:	06000013 			; <UNDEFINED> instruction: 0x06000013
     81c:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
     820:	0b3b0b3a 	bleq	ec3510 <__bss_end+0xeb71d0>
     824:	13490b39 	movtne	r0, #39737	; 0x9b39
     828:	1802196c 	stmdane	r2, {r2, r3, r5, r6, r8, fp, ip}
     82c:	13070000 	movwne	r0, #28672	; 0x7000
     830:	0b0e0301 	bleq	38143c <__bss_end+0x3750fc>
     834:	3b0b3a0b 	blcc	2cf068 <__bss_end+0x2c2d28>
     838:	010b390b 	tsteq	fp, fp, lsl #18
     83c:	08000013 	stmdaeq	r0, {r0, r1, r4}
     840:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
     844:	0b3b0b3a 	bleq	ec3534 <__bss_end+0xeb71f4>
     848:	13490b39 	movtne	r0, #39737	; 0x9b39
     84c:	00000b38 	andeq	r0, r0, r8, lsr fp
     850:	49010109 	stmdbmi	r1, {r0, r3, r8}
     854:	00130113 	andseq	r0, r3, r3, lsl r1
     858:	00210a00 	eoreq	r0, r1, r0, lsl #20
     85c:	0b2f1349 	bleq	bc5588 <__bss_end+0xbb9248>
     860:	0f0b0000 	svceq	0x000b0000
     864:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
     868:	0c000013 	stceq	0, cr0, [r0], {19}
     86c:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
     870:	0b3a0e03 	bleq	e84084 <__bss_end+0xe77d44>
     874:	0b390b3b 	bleq	e43568 <__bss_end+0xe37228>
     878:	01110e6e 	tsteq	r1, lr, ror #28
     87c:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
     880:	01194296 			; <UNDEFINED> instruction: 0x01194296
     884:	0d000013 	stceq	0, cr0, [r0, #-76]	; 0xffffffb4
     888:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
     88c:	0b3b0b3a 	bleq	ec357c <__bss_end+0xeb723c>
     890:	13490b39 	movtne	r0, #39737	; 0x9b39
     894:	00001802 	andeq	r1, r0, r2, lsl #16
     898:	0300050e 	movweq	r0, #1294	; 0x50e
     89c:	3b0b3a08 	blcc	2cf0c4 <__bss_end+0x2c2d84>
     8a0:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     8a4:	00180213 	andseq	r0, r8, r3, lsl r2
     8a8:	00340f00 	eorseq	r0, r4, r0, lsl #30
     8ac:	0b3a0e03 	bleq	e840c0 <__bss_end+0xe77d80>
     8b0:	0b390b3b 	bleq	e435a4 <__bss_end+0xe37264>
     8b4:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
     8b8:	2e100000 	cdpcs	0, 1, cr0, cr0, cr0, {0}
     8bc:	03193f01 	tsteq	r9, #1, 30
     8c0:	3b0b3a0e 	blcc	2cf100 <__bss_end+0x2c2dc0>
     8c4:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
     8c8:	1113490e 	tstne	r3, lr, lsl #18
     8cc:	40061201 	andmi	r1, r6, r1, lsl #4
     8d0:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
     8d4:	01000000 	mrseq	r0, (UNDEF: 0)
     8d8:	0e250111 	mcreq	1, 1, r0, cr5, cr1, {0}
     8dc:	0e030b13 	vmoveq.32	d3[0], r0
     8e0:	01110e1b 	tsteq	r1, fp, lsl lr
     8e4:	17100612 			; <UNDEFINED> instruction: 0x17100612
     8e8:	24020000 	strcs	r0, [r2], #-0
     8ec:	3e0b0b00 	vmlacc.f64	d0, d11, d0
     8f0:	000e030b 	andeq	r0, lr, fp, lsl #6
     8f4:	00240300 	eoreq	r0, r4, r0, lsl #6
     8f8:	0b3e0b0b 	bleq	f8352c <__bss_end+0xf771ec>
     8fc:	00000803 	andeq	r0, r0, r3, lsl #16
     900:	03001604 	movweq	r1, #1540	; 0x604
     904:	3b0b3a0e 	blcc	2cf144 <__bss_end+0x2c2e04>
     908:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     90c:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
     910:	0e030102 	adfeqs	f0, f3, f2
     914:	0b3a0b0b 	bleq	e83548 <__bss_end+0xe77208>
     918:	0b390b3b 	bleq	e4360c <__bss_end+0xe372cc>
     91c:	00001301 	andeq	r1, r0, r1, lsl #6
     920:	03000d06 	movweq	r0, #3334	; 0xd06
     924:	3b0b3a0e 	blcc	2cf164 <__bss_end+0x2c2e24>
     928:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     92c:	000b3813 	andeq	r3, fp, r3, lsl r8
     930:	012e0700 			; <UNDEFINED> instruction: 0x012e0700
     934:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
     938:	0b3b0b3a 	bleq	ec3628 <__bss_end+0xeb72e8>
     93c:	0e6e0b39 	vmoveq.8	d14[5], r0
     940:	0b321349 	bleq	c8566c <__bss_end+0xc7932c>
     944:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
     948:	00001301 	andeq	r1, r0, r1, lsl #6
     94c:	49000508 	stmdbmi	r0, {r3, r8, sl}
     950:	00193413 	andseq	r3, r9, r3, lsl r4
     954:	012e0900 			; <UNDEFINED> instruction: 0x012e0900
     958:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
     95c:	0b3b0b3a 	bleq	ec364c <__bss_end+0xeb730c>
     960:	0e6e0b39 	vmoveq.8	d14[5], r0
     964:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
     968:	13011364 	movwne	r1, #4964	; 0x1364
     96c:	050a0000 	streq	r0, [sl, #-0]
     970:	00134900 	andseq	r4, r3, r0, lsl #18
     974:	012e0b00 			; <UNDEFINED> instruction: 0x012e0b00
     978:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
     97c:	0b3b0b3a 	bleq	ec366c <__bss_end+0xeb732c>
     980:	0e6e0b39 	vmoveq.8	d14[5], r0
     984:	0b321349 	bleq	c856b0 <__bss_end+0xc79370>
     988:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
     98c:	0f0c0000 	svceq	0x000c0000
     990:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
     994:	0d000013 	stceq	0, cr0, [r0, #-76]	; 0xffffffb4
     998:	13490026 	movtne	r0, #36902	; 0x9026
     99c:	0f0e0000 	svceq	0x000e0000
     9a0:	000b0b00 	andeq	r0, fp, r0, lsl #22
     9a4:	00340f00 	eorseq	r0, r4, r0, lsl #30
     9a8:	0b3a0803 	bleq	e829bc <__bss_end+0xe7667c>
     9ac:	0b390b3b 	bleq	e436a0 <__bss_end+0xe37360>
     9b0:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
     9b4:	0000193c 	andeq	r1, r0, ip, lsr r9
     9b8:	47003410 	smladmi	r0, r0, r4, r3
     9bc:	3b0b3a13 	blcc	2cf210 <__bss_end+0x2c2ed0>
     9c0:	020b390b 	andeq	r3, fp, #180224	; 0x2c000
     9c4:	11000018 	tstne	r0, r8, lsl r0
     9c8:	0e03002e 	cdpeq	0, 0, cr0, cr3, cr14, {1}
     9cc:	01111934 	tsteq	r1, r4, lsr r9
     9d0:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
     9d4:	00194296 	mulseq	r9, r6, r2
     9d8:	012e1200 			; <UNDEFINED> instruction: 0x012e1200
     9dc:	19340e03 	ldmdbne	r4!, {r0, r1, r9, sl, fp}
     9e0:	06120111 			; <UNDEFINED> instruction: 0x06120111
     9e4:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
     9e8:	00130119 	andseq	r0, r3, r9, lsl r1
     9ec:	00051300 	andeq	r1, r5, r0, lsl #6
     9f0:	0b3a0e03 	bleq	e84204 <__bss_end+0xe77ec4>
     9f4:	0b390b3b 	bleq	e436e8 <__bss_end+0xe373a8>
     9f8:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
     9fc:	2e140000 	cdpcs	0, 1, cr0, cr4, cr0, {0}
     a00:	3a134701 	bcc	4d260c <__bss_end+0x4c62cc>
     a04:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     a08:	6413490b 	ldrvs	r4, [r3], #-2315	; 0xfffff6f5
     a0c:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
     a10:	96184006 	ldrls	r4, [r8], -r6
     a14:	13011942 	movwne	r1, #6466	; 0x1942
     a18:	05150000 	ldreq	r0, [r5, #-0]
     a1c:	490e0300 	stmdbmi	lr, {r8, r9}
     a20:	02193413 	andseq	r3, r9, #318767104	; 0x13000000
     a24:	16000018 			; <UNDEFINED> instruction: 0x16000018
     a28:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
     a2c:	0b3b0b3a 	bleq	ec371c <__bss_end+0xeb73dc>
     a30:	13490b39 	movtne	r0, #39737	; 0x9b39
     a34:	00001802 	andeq	r1, r0, r2, lsl #16
     a38:	47012e17 	smladmi	r1, r7, lr, r2
     a3c:	3b0b3a13 	blcc	2cf290 <__bss_end+0x2c2f50>
     a40:	640b390b 	strvs	r3, [fp], #-2315	; 0xfffff6f5
     a44:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
     a48:	97184006 	ldrls	r4, [r8, -r6]
     a4c:	13011942 	movwne	r1, #6466	; 0x1942
     a50:	2e180000 	cdpcs	0, 1, cr0, cr8, cr0, {0}
     a54:	3a134701 	bcc	4d2660 <__bss_end+0x4c6320>
     a58:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     a5c:	2013640b 	andscs	r6, r3, fp, lsl #8
     a60:	0013010b 	andseq	r0, r3, fp, lsl #2
     a64:	00051900 	andeq	r1, r5, r0, lsl #18
     a68:	13490e03 	movtne	r0, #40451	; 0x9e03
     a6c:	00001934 	andeq	r1, r0, r4, lsr r9
     a70:	31012e1a 	tstcc	r1, sl, lsl lr
     a74:	640e6e13 	strvs	r6, [lr], #-3603	; 0xfffff1ed
     a78:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
     a7c:	97184006 	ldrls	r4, [r8, -r6]
     a80:	00001942 	andeq	r1, r0, r2, asr #18
     a84:	3100051b 	tstcc	r0, fp, lsl r5
     a88:	00180213 	andseq	r0, r8, r3, lsl r2
     a8c:	11010000 	mrsne	r0, (UNDEF: 1)
     a90:	130e2501 	movwne	r2, #58625	; 0xe501
     a94:	1b0e030b 	blne	3816c8 <__bss_end+0x375388>
     a98:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
     a9c:	00171006 	andseq	r1, r7, r6
     aa0:	01020200 	mrseq	r0, R10_usr
     aa4:	0b0b0e03 	bleq	2c42b8 <__bss_end+0x2b7f78>
     aa8:	0b3b0b3a 	bleq	ec3798 <__bss_end+0xeb7458>
     aac:	13010b39 	movwne	r0, #6969	; 0x1b39
     ab0:	0d030000 	stceq	0, cr0, [r3, #-0]
     ab4:	3a080300 	bcc	2016bc <__bss_end+0x1f537c>
     ab8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     abc:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
     ac0:	0400000b 	streq	r0, [r0], #-11
     ac4:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
     ac8:	0b3b0b3a 	bleq	ec37b8 <__bss_end+0xeb7478>
     acc:	13490b39 	movtne	r0, #39737	; 0x9b39
     ad0:	00000b38 	andeq	r0, r0, r8, lsr fp
     ad4:	3f012e05 	svccc	0x00012e05
     ad8:	3a0e0319 	bcc	381744 <__bss_end+0x375404>
     adc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     ae0:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
     ae4:	3c0b3213 	sfmcc	f3, 4, [fp], {19}
     ae8:	01136419 	tsteq	r3, r9, lsl r4
     aec:	06000013 			; <UNDEFINED> instruction: 0x06000013
     af0:	13490005 	movtne	r0, #36869	; 0x9005
     af4:	00001934 	andeq	r1, r0, r4, lsr r9
     af8:	49000507 	stmdbmi	r0, {r0, r1, r2, r8, sl}
     afc:	08000013 	stmdaeq	r0, {r0, r1, r4}
     b00:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
     b04:	0b3a0e03 	bleq	e84318 <__bss_end+0xe77fd8>
     b08:	0b390b3b 	bleq	e437fc <__bss_end+0xe374bc>
     b0c:	13490e6e 	movtne	r0, #40558	; 0x9e6e
     b10:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
     b14:	00001364 	andeq	r1, r0, r4, ror #6
     b18:	0b002409 	bleq	9b44 <_ZN5Model3RunEv+0x2dc>
     b1c:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
     b20:	0a000008 	beq	b48 <shift+0xb48>
     b24:	0b0b000f 	bleq	2c0b68 <__bss_end+0x2b4828>
     b28:	00001349 	andeq	r1, r0, r9, asr #6
     b2c:	4900260b 	stmdbmi	r0, {r0, r1, r3, r9, sl, sp}
     b30:	0c000013 	stceq	0, cr0, [r0], {19}
     b34:	0b0b0024 	bleq	2c0bcc <__bss_end+0x2b488c>
     b38:	0e030b3e 	vmoveq.16	d3[0], r0
     b3c:	2e0d0000 	cdpcs	0, 0, cr0, cr13, cr0, {0}
     b40:	3a134701 	bcc	4d274c <__bss_end+0x4c640c>
     b44:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     b48:	1113640b 	tstne	r3, fp, lsl #8
     b4c:	40061201 	andmi	r1, r6, r1, lsl #4
     b50:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
     b54:	00001301 	andeq	r1, r0, r1, lsl #6
     b58:	0300050e 	movweq	r0, #1294	; 0x50e
     b5c:	3413490e 	ldrcc	r4, [r3], #-2318	; 0xfffff6f2
     b60:	00180219 	andseq	r0, r8, r9, lsl r2
     b64:	00340f00 	eorseq	r0, r4, r0, lsl #30
     b68:	0b3a0e03 	bleq	e8437c <__bss_end+0xe7803c>
     b6c:	0b390b3b 	bleq	e43860 <__bss_end+0xe37520>
     b70:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
     b74:	34100000 	ldrcc	r0, [r0], #-0
     b78:	3a080300 	bcc	201780 <__bss_end+0x1f5440>
     b7c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     b80:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
     b84:	11000018 	tstne	r0, r8, lsl r0
     b88:	1347012e 	movtne	r0, #28974	; 0x712e
     b8c:	0b3b0b3a 	bleq	ec387c <__bss_end+0xeb753c>
     b90:	13640b39 	cmnne	r4, #58368	; 0xe400
     b94:	13010b20 	movwne	r0, #6944	; 0x1b20
     b98:	05120000 	ldreq	r0, [r2, #-0]
     b9c:	490e0300 	stmdbmi	lr, {r8, r9}
     ba0:	00193413 	andseq	r3, r9, r3, lsl r4
     ba4:	00051300 	andeq	r1, r5, r0, lsl #6
     ba8:	0b3a0803 	bleq	e82bbc <__bss_end+0xe7687c>
     bac:	0b390b3b 	bleq	e438a0 <__bss_end+0xe37560>
     bb0:	00001349 	andeq	r1, r0, r9, asr #6
     bb4:	03000514 	movweq	r0, #1300	; 0x514
     bb8:	3b0b3a0e 	blcc	2cf3f8 <__bss_end+0x2c30b8>
     bbc:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     bc0:	15000013 	strne	r0, [r0, #-19]	; 0xffffffed
     bc4:	1331012e 	teqne	r1, #-2147483637	; 0x8000000b
     bc8:	13640e6e 	cmnne	r4, #1760	; 0x6e0
     bcc:	06120111 			; <UNDEFINED> instruction: 0x06120111
     bd0:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
     bd4:	16000019 			; <UNDEFINED> instruction: 0x16000019
     bd8:	13310005 	teqne	r1, #5
     bdc:	00001802 	andeq	r1, r0, r2, lsl #16
     be0:	01110100 	tsteq	r1, r0, lsl #2
     be4:	0b130e25 	bleq	4c4480 <__bss_end+0x4b8140>
     be8:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
     bec:	01111755 	tsteq	r1, r5, asr r7
     bf0:	00001710 	andeq	r1, r0, r0, lsl r7
     bf4:	0b002402 	bleq	9c04 <_Z5splitPP9Tribesmanii+0x8c>
     bf8:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
     bfc:	0300000e 	movweq	r0, #14
     c00:	13490026 	movtne	r0, #36902	; 0x9026
     c04:	24040000 	strcs	r0, [r4], #-0
     c08:	3e0b0b00 	vmlacc.f64	d0, d11, d0
     c0c:	0008030b 	andeq	r0, r8, fp, lsl #6
     c10:	00160500 	andseq	r0, r6, r0, lsl #10
     c14:	0b3a0e03 	bleq	e84428 <__bss_end+0xe780e8>
     c18:	0b390b3b 	bleq	e4390c <__bss_end+0xe375cc>
     c1c:	00001349 	andeq	r1, r0, r9, asr #6
     c20:	03003406 	movweq	r3, #1030	; 0x406
     c24:	3b0b3a0e 	blcc	2cf464 <__bss_end+0x2c3124>
     c28:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     c2c:	02196c13 	andseq	r6, r9, #4864	; 0x1300
     c30:	07000018 	smladeq	r0, r8, r0, r0
     c34:	0b0b000f 	bleq	2c0c78 <__bss_end+0x2b4938>
     c38:	00001349 	andeq	r1, r0, r9, asr #6
     c3c:	0b000f08 	bleq	4864 <shift+0x4864>
     c40:	0900000b 	stmdbeq	r0, {r0, r1, r3}
     c44:	0e030102 	adfeqs	f0, f3, f2
     c48:	0b3a0b0b 	bleq	e8387c <__bss_end+0xe7753c>
     c4c:	0b390b3b 	bleq	e43940 <__bss_end+0xe37600>
     c50:	00001301 	andeq	r1, r0, r1, lsl #6
     c54:	03000d0a 	movweq	r0, #3338	; 0xd0a
     c58:	3b0b3a0e 	blcc	2cf498 <__bss_end+0x2c3158>
     c5c:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     c60:	000b3813 	andeq	r3, fp, r3, lsl r8
     c64:	012e0b00 			; <UNDEFINED> instruction: 0x012e0b00
     c68:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
     c6c:	0b3b0b3a 	bleq	ec395c <__bss_end+0xeb761c>
     c70:	0e6e0b39 	vmoveq.8	d14[5], r0
     c74:	0b321349 	bleq	c859a0 <__bss_end+0xc79660>
     c78:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
     c7c:	00001301 	andeq	r1, r0, r1, lsl #6
     c80:	4900050c 	stmdbmi	r0, {r2, r3, r8, sl}
     c84:	00193413 	andseq	r3, r9, r3, lsl r4
     c88:	012e0d00 			; <UNDEFINED> instruction: 0x012e0d00
     c8c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
     c90:	0b3b0b3a 	bleq	ec3980 <__bss_end+0xeb7640>
     c94:	0e6e0b39 	vmoveq.8	d14[5], r0
     c98:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
     c9c:	13011364 	movwne	r1, #4964	; 0x1364
     ca0:	050e0000 	streq	r0, [lr, #-0]
     ca4:	00134900 	andseq	r4, r3, r0, lsl #18
     ca8:	012e0f00 			; <UNDEFINED> instruction: 0x012e0f00
     cac:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
     cb0:	0b3b0b3a 	bleq	ec39a0 <__bss_end+0xeb7660>
     cb4:	0e6e0b39 	vmoveq.8	d14[5], r0
     cb8:	0b321349 	bleq	c859e4 <__bss_end+0xc796a4>
     cbc:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
     cc0:	34100000 	ldrcc	r0, [r0], #-0
     cc4:	3a080300 	bcc	2018cc <__bss_end+0x1f558c>
     cc8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     ccc:	3f13490b 	svccc	0x0013490b
     cd0:	00193c19 	andseq	r3, r9, r9, lsl ip
     cd4:	01021100 	mrseq	r1, (UNDEF: 18)
     cd8:	050b0e03 	streq	r0, [fp, #-3587]	; 0xfffff1fd
     cdc:	0b3b0b3a 	bleq	ec39cc <__bss_end+0xeb768c>
     ce0:	13010b39 	movwne	r0, #6969	; 0x1b39
     ce4:	0d120000 	ldceq	0, cr0, [r2, #-0]
     ce8:	3a0e0300 	bcc	3818f0 <__bss_end+0x3755b0>
     cec:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     cf0:	3f13490b 	svccc	0x0013490b
     cf4:	1c193c19 	ldcne	12, cr3, [r9], {25}
     cf8:	1300000b 	movwne	r0, #11
     cfc:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
     d00:	0b3a0e03 	bleq	e84514 <__bss_end+0xe781d4>
     d04:	0b390b3b 	bleq	e439f8 <__bss_end+0xe376b8>
     d08:	193c0e6e 	ldmdbne	ip!, {r1, r2, r3, r5, r6, r9, sl, fp}
     d0c:	13011364 	movwne	r1, #4964	; 0x1364
     d10:	2e140000 	cdpcs	0, 1, cr0, cr4, cr0, {0}
     d14:	03193f01 	tsteq	r9, #1, 30
     d18:	3b0b3a0e 	blcc	2cf558 <__bss_end+0x2c3218>
     d1c:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
     d20:	3c13490e 			; <UNDEFINED> instruction: 0x3c13490e
     d24:	01136419 	tsteq	r3, r9, lsl r4
     d28:	15000013 	strne	r0, [r0, #-19]	; 0xffffffed
     d2c:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
     d30:	0b3a0e03 	bleq	e84544 <__bss_end+0xe78204>
     d34:	0b390b3b 	bleq	e43a28 <__bss_end+0xe376e8>
     d38:	0b320e6e 	bleq	c846f8 <__bss_end+0xc783b8>
     d3c:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
     d40:	01160000 	tsteq	r6, r0
     d44:	01134901 	tsteq	r3, r1, lsl #18
     d48:	17000013 	smladne	r0, r3, r0, r0
     d4c:	13490021 	movtne	r0, #36897	; 0x9021
     d50:	00000b2f 	andeq	r0, r0, pc, lsr #22
     d54:	47012e18 	smladmi	r1, r8, lr, r2
     d58:	3b0b3a13 	blcc	2cf5ac <__bss_end+0x2c326c>
     d5c:	640b390b 	strvs	r3, [fp], #-2315	; 0xfffff6f5
     d60:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
     d64:	96184006 	ldrls	r4, [r8], -r6
     d68:	13011942 	movwne	r1, #6466	; 0x1942
     d6c:	05190000 	ldreq	r0, [r9, #-0]
     d70:	490e0300 	stmdbmi	lr, {r8, r9}
     d74:	02193413 	andseq	r3, r9, #318767104	; 0x13000000
     d78:	1a000018 	bne	de0 <shift+0xde0>
     d7c:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
     d80:	0b3b0b3a 	bleq	ec3a70 <__bss_end+0xeb7730>
     d84:	13490b39 	movtne	r0, #39737	; 0x9b39
     d88:	00001802 	andeq	r1, r0, r2, lsl #16
     d8c:	0300341b 	movweq	r3, #1051	; 0x41b
     d90:	3b0b3a0e 	blcc	2cf5d0 <__bss_end+0x2c3290>
     d94:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     d98:	00180213 	andseq	r0, r8, r3, lsl r2
     d9c:	010b1c00 	tsteq	fp, r0, lsl #24
     da0:	00001755 	andeq	r1, r0, r5, asr r7
     da4:	0300051d 	movweq	r0, #1309	; 0x51d
     da8:	3b0b3a08 	blcc	2cf5d0 <__bss_end+0x2c3290>
     dac:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     db0:	00180213 	andseq	r0, r8, r3, lsl r2
     db4:	010b1e00 	tsteq	fp, r0, lsl #28
     db8:	06120111 			; <UNDEFINED> instruction: 0x06120111
     dbc:	341f0000 	ldrcc	r0, [pc], #-0	; dc4 <shift+0xdc4>
     dc0:	3a080300 	bcc	2019c8 <__bss_end+0x1f5688>
     dc4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     dc8:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
     dcc:	20000018 	andcs	r0, r0, r8, lsl r0
     dd0:	1347012e 	movtne	r0, #28974	; 0x712e
     dd4:	0b390b3a 	bleq	e43ac4 <__bss_end+0xe37784>
     dd8:	01111364 	tsteq	r1, r4, ror #6
     ddc:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
     de0:	01194296 			; <UNDEFINED> instruction: 0x01194296
     de4:	21000013 	tstcs	r0, r3, lsl r0
     de8:	1347012e 	movtne	r0, #28974	; 0x712e
     dec:	0b3b0b3a 	bleq	ec3adc <__bss_end+0xeb779c>
     df0:	13640b39 	cmnne	r4, #58368	; 0xe400
     df4:	06120111 			; <UNDEFINED> instruction: 0x06120111
     df8:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
     dfc:	00130119 	andseq	r0, r3, r9, lsl r1
     e00:	012e2200 			; <UNDEFINED> instruction: 0x012e2200
     e04:	0b3a1347 	bleq	e85b28 <__bss_end+0xe797e8>
     e08:	0b390b3b 	bleq	e43afc <__bss_end+0xe377bc>
     e0c:	0b201364 	bleq	805ba4 <__bss_end+0x7f9864>
     e10:	00001301 	andeq	r1, r0, r1, lsl #6
     e14:	03000523 	movweq	r0, #1315	; 0x523
     e18:	3413490e 	ldrcc	r4, [r3], #-2318	; 0xfffff6f2
     e1c:	24000019 	strcs	r0, [r0], #-25	; 0xffffffe7
     e20:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
     e24:	0b3b0b3a 	bleq	ec3b14 <__bss_end+0xeb77d4>
     e28:	13490b39 	movtne	r0, #39737	; 0x9b39
     e2c:	2e250000 	cdpcs	0, 2, cr0, cr5, cr0, {0}
     e30:	6e133101 	mufvss	f3, f3, f1
     e34:	1113640e 	tstne	r3, lr, lsl #8
     e38:	40061201 	andmi	r1, r6, r1, lsl #4
     e3c:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
     e40:	00001301 	andeq	r1, r0, r1, lsl #6
     e44:	31000526 	tstcc	r0, r6, lsr #10
     e48:	00180213 	andseq	r0, r8, r3, lsl r2
     e4c:	012e2700 			; <UNDEFINED> instruction: 0x012e2700
     e50:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
     e54:	0b3b0b3a 	bleq	ec3b44 <__bss_end+0xeb7804>
     e58:	0e6e0b39 	vmoveq.8	d14[5], r0
     e5c:	01111349 	tsteq	r1, r9, asr #6
     e60:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
     e64:	00194296 	mulseq	r9, r6, r2
     e68:	11010000 	mrsne	r0, (UNDEF: 1)
     e6c:	130e2501 	movwne	r2, #58625	; 0xe501
     e70:	1b0e030b 	blne	381aa4 <__bss_end+0x375764>
     e74:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
     e78:	00171006 	andseq	r1, r7, r6
     e7c:	00240200 	eoreq	r0, r4, r0, lsl #4
     e80:	0b3e0b0b 	bleq	f83ab4 <__bss_end+0xf77774>
     e84:	00000e03 	andeq	r0, r0, r3, lsl #28
     e88:	49002603 	stmdbmi	r0, {r0, r1, r9, sl, sp}
     e8c:	04000013 	streq	r0, [r0], #-19	; 0xffffffed
     e90:	0b0b0024 	bleq	2c0f28 <__bss_end+0x2b4be8>
     e94:	08030b3e 	stmdaeq	r3, {r1, r2, r3, r4, r5, r8, r9, fp}
     e98:	16050000 	strne	r0, [r5], -r0
     e9c:	3a0e0300 	bcc	381aa4 <__bss_end+0x375764>
     ea0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     ea4:	0013490b 	andseq	r4, r3, fp, lsl #18
     ea8:	01130600 	tsteq	r3, r0, lsl #12
     eac:	0b0b0e03 	bleq	2c46c0 <__bss_end+0x2b8380>
     eb0:	0b3b0b3a 	bleq	ec3ba0 <__bss_end+0xeb7860>
     eb4:	13010b39 	movwne	r0, #6969	; 0x1b39
     eb8:	0d070000 	stceq	0, cr0, [r7, #-0]
     ebc:	3a080300 	bcc	201ac4 <__bss_end+0x1f5784>
     ec0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     ec4:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
     ec8:	0800000b 	stmdaeq	r0, {r0, r1, r3}
     ecc:	0e030104 	adfeqs	f0, f3, f4
     ed0:	0b3e196d 	bleq	f8748c <__bss_end+0xf7b14c>
     ed4:	13490b0b 	movtne	r0, #39691	; 0x9b0b
     ed8:	0b3b0b3a 	bleq	ec3bc8 <__bss_end+0xeb7888>
     edc:	13010b39 	movwne	r0, #6969	; 0x1b39
     ee0:	28090000 	stmdacs	r9, {}	; <UNPREDICTABLE>
     ee4:	1c080300 	stcne	3, cr0, [r8], {-0}
     ee8:	0a00000b 	beq	f1c <shift+0xf1c>
     eec:	0e030028 	cdpeq	0, 0, cr0, cr3, cr8, {1}
     ef0:	00000b1c 	andeq	r0, r0, ip, lsl fp
     ef4:	0300340b 	movweq	r3, #1035	; 0x40b
     ef8:	3b0b3a0e 	blcc	2cf738 <__bss_end+0x2c33f8>
     efc:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     f00:	02196c13 	andseq	r6, r9, #4864	; 0x1300
     f04:	0c000018 	stceq	0, cr0, [r0], {24}
     f08:	0e030002 	cdpeq	0, 0, cr0, cr3, cr2, {0}
     f0c:	0000193c 	andeq	r1, r0, ip, lsr r9
     f10:	0b000f0d 	bleq	4b4c <shift+0x4b4c>
     f14:	0013490b 	andseq	r4, r3, fp, lsl #18
     f18:	000d0e00 	andeq	r0, sp, r0, lsl #28
     f1c:	0b3a0e03 	bleq	e84730 <__bss_end+0xe783f0>
     f20:	0b390b3b 	bleq	e43c14 <__bss_end+0xe378d4>
     f24:	0b381349 	bleq	e05c50 <__bss_end+0xdf9910>
     f28:	010f0000 	mrseq	r0, CPSR
     f2c:	01134901 	tsteq	r3, r1, lsl #18
     f30:	10000013 	andne	r0, r0, r3, lsl r0
     f34:	13490021 	movtne	r0, #36897	; 0x9021
     f38:	00000b2f 	andeq	r0, r0, pc, lsr #22
     f3c:	03010211 	movweq	r0, #4625	; 0x1211
     f40:	3a0b0b0e 	bcc	2c3b80 <__bss_end+0x2b7840>
     f44:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     f48:	0013010b 	andseq	r0, r3, fp, lsl #2
     f4c:	012e1200 			; <UNDEFINED> instruction: 0x012e1200
     f50:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
     f54:	0b3b0b3a 	bleq	ec3c44 <__bss_end+0xeb7904>
     f58:	0e6e0b39 	vmoveq.8	d14[5], r0
     f5c:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
     f60:	00001301 	andeq	r1, r0, r1, lsl #6
     f64:	49000513 	stmdbmi	r0, {r0, r1, r4, r8, sl}
     f68:	00193413 	andseq	r3, r9, r3, lsl r4
     f6c:	00051400 	andeq	r1, r5, r0, lsl #8
     f70:	00001349 	andeq	r1, r0, r9, asr #6
     f74:	3f012e15 	svccc	0x00012e15
     f78:	3a0e0319 	bcc	381be4 <__bss_end+0x3758a4>
     f7c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     f80:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
     f84:	64193c13 	ldrvs	r3, [r9], #-3091	; 0xfffff3ed
     f88:	00130113 	andseq	r0, r3, r3, lsl r1
     f8c:	012e1600 			; <UNDEFINED> instruction: 0x012e1600
     f90:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
     f94:	0b3b0b3a 	bleq	ec3c84 <__bss_end+0xeb7944>
     f98:	0e6e0b39 	vmoveq.8	d14[5], r0
     f9c:	0b321349 	bleq	c85cc8 <__bss_end+0xc79988>
     fa0:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
     fa4:	00001301 	andeq	r1, r0, r1, lsl #6
     fa8:	03000d17 	movweq	r0, #3351	; 0xd17
     fac:	3b0b3a0e 	blcc	2cf7ec <__bss_end+0x2c34ac>
     fb0:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     fb4:	320b3813 	andcc	r3, fp, #1245184	; 0x130000
     fb8:	1800000b 	stmdane	r0, {r0, r1, r3}
     fbc:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
     fc0:	0b3a0e03 	bleq	e847d4 <__bss_end+0xe78494>
     fc4:	0b390b3b 	bleq	e43cb8 <__bss_end+0xe37978>
     fc8:	0b320e6e 	bleq	c84988 <__bss_end+0xc78648>
     fcc:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
     fd0:	00001301 	andeq	r1, r0, r1, lsl #6
     fd4:	3f012e19 	svccc	0x00012e19
     fd8:	3a0e0319 	bcc	381c44 <__bss_end+0x375904>
     fdc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     fe0:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
     fe4:	3c0b3213 	sfmcc	f3, 4, [fp], {19}
     fe8:	00136419 	andseq	r6, r3, r9, lsl r4
     fec:	01151a00 	tsteq	r5, r0, lsl #20
     ff0:	13641349 	cmnne	r4, #603979777	; 0x24000001
     ff4:	00001301 	andeq	r1, r0, r1, lsl #6
     ff8:	1d001f1b 	stcne	15, cr1, [r0, #-108]	; 0xffffff94
     ffc:	00134913 	andseq	r4, r3, r3, lsl r9
    1000:	00101c00 	andseq	r1, r0, r0, lsl #24
    1004:	13490b0b 	movtne	r0, #39691	; 0x9b0b
    1008:	0f1d0000 	svceq	0x001d0000
    100c:	000b0b00 	andeq	r0, fp, r0, lsl #22
    1010:	00341e00 	eorseq	r1, r4, r0, lsl #28
    1014:	0b3a0e03 	bleq	e84828 <__bss_end+0xe784e8>
    1018:	0b390b3b 	bleq	e43d0c <__bss_end+0xe379cc>
    101c:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
    1020:	2e1f0000 	cdpcs	0, 1, cr0, cr15, cr0, {0}
    1024:	03193f01 	tsteq	r9, #1, 30
    1028:	3b0b3a0e 	blcc	2cf868 <__bss_end+0x2c3528>
    102c:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
    1030:	1113490e 	tstne	r3, lr, lsl #18
    1034:	40061201 	andmi	r1, r6, r1, lsl #4
    1038:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
    103c:	00001301 	andeq	r1, r0, r1, lsl #6
    1040:	03000520 	movweq	r0, #1312	; 0x520
    1044:	3b0b3a0e 	blcc	2cf884 <__bss_end+0x2c3544>
    1048:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
    104c:	00180213 	andseq	r0, r8, r3, lsl r2
    1050:	012e2100 			; <UNDEFINED> instruction: 0x012e2100
    1054:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
    1058:	0b3b0b3a 	bleq	ec3d48 <__bss_end+0xeb7a08>
    105c:	0e6e0b39 	vmoveq.8	d14[5], r0
    1060:	01111349 	tsteq	r1, r9, asr #6
    1064:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
    1068:	01194297 			; <UNDEFINED> instruction: 0x01194297
    106c:	22000013 	andcs	r0, r0, #19
    1070:	08030034 	stmdaeq	r3, {r2, r4, r5}
    1074:	0b3b0b3a 	bleq	ec3d64 <__bss_end+0xeb7a24>
    1078:	13490b39 	movtne	r0, #39737	; 0x9b39
    107c:	00001802 	andeq	r1, r0, r2, lsl #16
    1080:	3f012e23 	svccc	0x00012e23
    1084:	3a0e0319 	bcc	381cf0 <__bss_end+0x3759b0>
    1088:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    108c:	110e6e0b 	tstne	lr, fp, lsl #28
    1090:	40061201 	andmi	r1, r6, r1, lsl #4
    1094:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
    1098:	00001301 	andeq	r1, r0, r1, lsl #6
    109c:	3f002e24 	svccc	0x00002e24
    10a0:	3a0e0319 	bcc	381d0c <__bss_end+0x3759cc>
    10a4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    10a8:	110e6e0b 	tstne	lr, fp, lsl #28
    10ac:	40061201 	andmi	r1, r6, r1, lsl #4
    10b0:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
    10b4:	2e250000 	cdpcs	0, 2, cr0, cr5, cr0, {0}
    10b8:	03193f01 	tsteq	r9, #1, 30
    10bc:	3b0b3a0e 	blcc	2cf8fc <__bss_end+0x2c35bc>
    10c0:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
    10c4:	1113490e 	tstne	r3, lr, lsl #18
    10c8:	40061201 	andmi	r1, r6, r1, lsl #4
    10cc:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
    10d0:	01000000 	mrseq	r0, (UNDEF: 0)
    10d4:	0e250111 	mcreq	1, 1, r0, cr5, cr1, {0}
    10d8:	0e030b13 	vmoveq.32	d3[0], r0
    10dc:	01110e1b 	tsteq	r1, fp, lsl lr
    10e0:	17100612 			; <UNDEFINED> instruction: 0x17100612
    10e4:	39020000 	stmdbcc	r2, {}	; <UNPREDICTABLE>
    10e8:	00130101 	andseq	r0, r3, r1, lsl #2
    10ec:	00340300 	eorseq	r0, r4, r0, lsl #6
    10f0:	0b3a0e03 	bleq	e84904 <__bss_end+0xe785c4>
    10f4:	0b390b3b 	bleq	e43de8 <__bss_end+0xe37aa8>
    10f8:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
    10fc:	00000a1c 	andeq	r0, r0, ip, lsl sl
    1100:	3a003a04 	bcc	f918 <__bss_end+0x35d8>
    1104:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    1108:	0013180b 	andseq	r1, r3, fp, lsl #16
    110c:	01010500 	tsteq	r1, r0, lsl #10
    1110:	13011349 	movwne	r1, #4937	; 0x1349
    1114:	21060000 	mrscs	r0, (UNDEF: 6)
    1118:	2f134900 	svccs	0x00134900
    111c:	0700000b 	streq	r0, [r0, -fp]
    1120:	13490026 	movtne	r0, #36902	; 0x9026
    1124:	24080000 	strcs	r0, [r8], #-0
    1128:	3e0b0b00 	vmlacc.f64	d0, d11, d0
    112c:	000e030b 	andeq	r0, lr, fp, lsl #6
    1130:	00340900 	eorseq	r0, r4, r0, lsl #18
    1134:	00001347 	andeq	r1, r0, r7, asr #6
    1138:	3f012e0a 	svccc	0x00012e0a
    113c:	3a0e0319 	bcc	381da8 <__bss_end+0x375a68>
    1140:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    1144:	110e6e0b 	tstne	lr, fp, lsl #28
    1148:	40061201 	andmi	r1, r6, r1, lsl #4
    114c:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
    1150:	00001301 	andeq	r1, r0, r1, lsl #6
    1154:	0300050b 	movweq	r0, #1291	; 0x50b
    1158:	3b0b3a08 	blcc	2cf980 <__bss_end+0x2c3640>
    115c:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
    1160:	00180213 	andseq	r0, r8, r3, lsl r2
    1164:	00340c00 	eorseq	r0, r4, r0, lsl #24
    1168:	0b3a0e03 	bleq	e8497c <__bss_end+0xe7863c>
    116c:	0b390b3b 	bleq	e43e60 <__bss_end+0xe37b20>
    1170:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
    1174:	340d0000 	strcc	r0, [sp], #-0
    1178:	3a080300 	bcc	201d80 <__bss_end+0x1f5a40>
    117c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    1180:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
    1184:	0e000018 	mcreq	0, 0, r0, cr0, cr8, {0}
    1188:	0b0b000f 	bleq	2c11cc <__bss_end+0x2b4e8c>
    118c:	00001349 	andeq	r1, r0, r9, asr #6
    1190:	3f012e0f 	svccc	0x00012e0f
    1194:	3a0e0319 	bcc	381e00 <__bss_end+0x375ac0>
    1198:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    119c:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
    11a0:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
    11a4:	97184006 	ldrls	r4, [r8, -r6]
    11a8:	13011942 	movwne	r1, #6466	; 0x1942
    11ac:	05100000 	ldreq	r0, [r0, #-0]
    11b0:	3a0e0300 	bcc	381db8 <__bss_end+0x375a78>
    11b4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    11b8:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
    11bc:	11000018 	tstne	r0, r8, lsl r0
    11c0:	0b0b0024 	bleq	2c1258 <__bss_end+0x2b4f18>
    11c4:	08030b3e 	stmdaeq	r3, {r1, r2, r3, r4, r5, r8, r9, fp}
    11c8:	2e120000 	cdpcs	0, 1, cr0, cr2, cr0, {0}
    11cc:	03193f01 	tsteq	r9, #1, 30
    11d0:	3b0b3a0e 	blcc	2cfa10 <__bss_end+0x2c36d0>
    11d4:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
    11d8:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
    11dc:	97184006 	ldrls	r4, [r8, -r6]
    11e0:	13011942 	movwne	r1, #6466	; 0x1942
    11e4:	0b130000 	bleq	4c11ec <__bss_end+0x4b4eac>
    11e8:	12011101 	andne	r1, r1, #1073741824	; 0x40000000
    11ec:	14000006 	strne	r0, [r0], #-6
    11f0:	00000026 	andeq	r0, r0, r6, lsr #32
    11f4:	0b000f15 	bleq	4e50 <shift+0x4e50>
    11f8:	1600000b 	strne	r0, [r0], -fp
    11fc:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
    1200:	0b3a0e03 	bleq	e84a14 <__bss_end+0xe786d4>
    1204:	0b390b3b 	bleq	e43ef8 <__bss_end+0xe37bb8>
    1208:	13490e6e 	movtne	r0, #40558	; 0x9e6e
    120c:	06120111 			; <UNDEFINED> instruction: 0x06120111
    1210:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
    1214:	00130119 	andseq	r0, r3, r9, lsl r1
    1218:	012e1700 			; <UNDEFINED> instruction: 0x012e1700
    121c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
    1220:	0b3b0b3a 	bleq	ec3f10 <__bss_end+0xeb7bd0>
    1224:	0e6e0b39 	vmoveq.8	d14[5], r0
    1228:	06120111 			; <UNDEFINED> instruction: 0x06120111
    122c:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
    1230:	00000019 	andeq	r0, r0, r9, lsl r0
    1234:	10001101 	andne	r1, r0, r1, lsl #2
    1238:	12011106 	andne	r1, r1, #-2147483647	; 0x80000001
    123c:	1b0e0301 	blne	381e48 <__bss_end+0x375b08>
    1240:	130e250e 	movwne	r2, #58638	; 0xe50e
    1244:	00000005 	andeq	r0, r0, r5
    1248:	10001101 	andne	r1, r0, r1, lsl #2
    124c:	12011106 	andne	r1, r1, #-2147483647	; 0x80000001
    1250:	1b0e0301 	blne	381e5c <__bss_end+0x375b1c>
    1254:	130e250e 	movwne	r2, #58638	; 0xe50e
    1258:	00000005 	andeq	r0, r0, r5
    125c:	10001101 	andne	r1, r0, r1, lsl #2
    1260:	12011106 	andne	r1, r1, #-2147483647	; 0x80000001
    1264:	1b0e0301 	blne	381e70 <__bss_end+0x375b30>
    1268:	130e250e 	movwne	r2, #58638	; 0xe50e
    126c:	00000005 	andeq	r0, r0, r5
    1270:	10001101 	andne	r1, r0, r1, lsl #2
    1274:	12011106 	andne	r1, r1, #-2147483647	; 0x80000001
    1278:	1b0e0301 	blne	381e84 <__bss_end+0x375b44>
    127c:	130e250e 	movwne	r2, #58638	; 0xe50e
    1280:	00000005 	andeq	r0, r0, r5
    1284:	10001101 	andne	r1, r0, r1, lsl #2
    1288:	12011106 	andne	r1, r1, #-2147483647	; 0x80000001
    128c:	1b0e0301 	blne	381e98 <__bss_end+0x375b58>
    1290:	130e250e 	movwne	r2, #58638	; 0xe50e
    1294:	00000005 	andeq	r0, r0, r5
    1298:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
    129c:	030b130e 	movweq	r1, #45838	; 0xb30e
    12a0:	100e1b0e 	andne	r1, lr, lr, lsl #22
    12a4:	02000017 	andeq	r0, r0, #23
    12a8:	0b0b0024 	bleq	2c1340 <__bss_end+0x2b5000>
    12ac:	08030b3e 	stmdaeq	r3, {r1, r2, r3, r4, r5, r8, r9, fp}
    12b0:	24030000 	strcs	r0, [r3], #-0
    12b4:	3e0b0b00 	vmlacc.f64	d0, d11, d0
    12b8:	000e030b 	andeq	r0, lr, fp, lsl #6
    12bc:	01040400 	tsteq	r4, r0, lsl #8
    12c0:	0b3e0e03 	bleq	f84ad4 <__bss_end+0xf78794>
    12c4:	13490b0b 	movtne	r0, #39691	; 0x9b0b
    12c8:	0b3b0b3a 	bleq	ec3fb8 <__bss_end+0xeb7c78>
    12cc:	13010b39 	movwne	r0, #6969	; 0x1b39
    12d0:	28050000 	stmdacs	r5, {}	; <UNPREDICTABLE>
    12d4:	1c0e0300 	stcne	3, cr0, [lr], {-0}
    12d8:	0600000b 	streq	r0, [r0], -fp
    12dc:	0e030113 	mcreq	1, 0, r0, cr3, cr3, {0}
    12e0:	0b3a0b0b 	bleq	e83f14 <__bss_end+0xe77bd4>
    12e4:	0b39053b 	bleq	e427d8 <__bss_end+0xe36498>
    12e8:	00001301 	andeq	r1, r0, r1, lsl #6
    12ec:	03000d07 	movweq	r0, #3335	; 0xd07
    12f0:	3b0b3a0e 	blcc	2cfb30 <__bss_end+0x2c37f0>
    12f4:	490b3905 	stmdbmi	fp, {r0, r2, r8, fp, ip, sp}
    12f8:	000b3813 	andeq	r3, fp, r3, lsl r8
    12fc:	00260800 	eoreq	r0, r6, r0, lsl #16
    1300:	00001349 	andeq	r1, r0, r9, asr #6
    1304:	49010109 	stmdbmi	r1, {r0, r3, r8}
    1308:	00130113 	andseq	r0, r3, r3, lsl r1
    130c:	00210a00 	eoreq	r0, r1, r0, lsl #20
    1310:	0b2f1349 	bleq	bc603c <__bss_end+0xbb9cfc>
    1314:	340b0000 	strcc	r0, [fp], #-0
    1318:	3a0e0300 	bcc	381f20 <__bss_end+0x375be0>
    131c:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
    1320:	1c13490b 			; <UNDEFINED> instruction: 0x1c13490b
    1324:	0c00000a 	stceq	0, cr0, [r0], {10}
    1328:	19270015 	stmdbne	r7!, {r0, r2, r4}
    132c:	0f0d0000 	svceq	0x000d0000
    1330:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
    1334:	0e000013 	mcreq	0, 0, r0, cr0, cr3, {0}
    1338:	0e030104 	adfeqs	f0, f3, f4
    133c:	0b0b0b3e 	bleq	2c403c <__bss_end+0x2b7cfc>
    1340:	0b3a1349 	bleq	e8606c <__bss_end+0xe79d2c>
    1344:	0b39053b 	bleq	e42838 <__bss_end+0xe364f8>
    1348:	00001301 	andeq	r1, r0, r1, lsl #6
    134c:	0300160f 	movweq	r1, #1551	; 0x60f
    1350:	3b0b3a0e 	blcc	2cfb90 <__bss_end+0x2c3850>
    1354:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
    1358:	10000013 	andne	r0, r0, r3, lsl r0
    135c:	00000021 	andeq	r0, r0, r1, lsr #32
    1360:	03003411 	movweq	r3, #1041	; 0x411
    1364:	3b0b3a0e 	blcc	2cfba4 <__bss_end+0x2c3864>
    1368:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
    136c:	3c193f13 	ldccc	15, cr3, [r9], {19}
    1370:	12000019 	andne	r0, r0, #25
    1374:	13470034 	movtne	r0, #28724	; 0x7034
    1378:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
    137c:	13490b39 	movtne	r0, #39737	; 0x9b39
    1380:	00001802 	andeq	r1, r0, r2, lsl #16
    1384:	01110100 	tsteq	r1, r0, lsl #2
    1388:	0b130e25 	bleq	4c4c24 <__bss_end+0x4b88e4>
    138c:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
    1390:	06120111 			; <UNDEFINED> instruction: 0x06120111
    1394:	00001710 	andeq	r1, r0, r0, lsl r7
    1398:	0b002402 	bleq	a3a8 <_ZN6Buffer14Read_Uart_LineEv+0xf4>
    139c:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
    13a0:	0300000e 	movweq	r0, #14
    13a4:	0b0b0024 	bleq	2c143c <__bss_end+0x2b50fc>
    13a8:	08030b3e 	stmdaeq	r3, {r1, r2, r3, r4, r5, r8, r9, fp}
    13ac:	04040000 	streq	r0, [r4], #-0
    13b0:	3e0e0301 	cdpcc	3, 0, cr0, cr14, cr1, {0}
    13b4:	490b0b0b 	stmdbmi	fp, {r0, r1, r3, r8, r9, fp}
    13b8:	3b0b3a13 	blcc	2cfc0c <__bss_end+0x2c38cc>
    13bc:	010b390b 	tsteq	fp, fp, lsl #18
    13c0:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
    13c4:	0e030028 	cdpeq	0, 0, cr0, cr3, cr8, {1}
    13c8:	00000b1c 	andeq	r0, r0, ip, lsl fp
    13cc:	03011306 	movweq	r1, #4870	; 0x1306
    13d0:	3a0b0b0e 	bcc	2c4010 <__bss_end+0x2b7cd0>
    13d4:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
    13d8:	0013010b 	andseq	r0, r3, fp, lsl #2
    13dc:	000d0700 	andeq	r0, sp, r0, lsl #14
    13e0:	0b3a0e03 	bleq	e84bf4 <__bss_end+0xe788b4>
    13e4:	0b39053b 	bleq	e428d8 <__bss_end+0xe36598>
    13e8:	0b381349 	bleq	e06114 <__bss_end+0xdf9dd4>
    13ec:	26080000 	strcs	r0, [r8], -r0
    13f0:	00134900 	andseq	r4, r3, r0, lsl #18
    13f4:	01010900 	tsteq	r1, r0, lsl #18
    13f8:	13011349 	movwne	r1, #4937	; 0x1349
    13fc:	210a0000 	mrscs	r0, (UNDEF: 10)
    1400:	2f134900 	svccs	0x00134900
    1404:	0b00000b 	bleq	1438 <shift+0x1438>
    1408:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
    140c:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
    1410:	13490b39 	movtne	r0, #39737	; 0x9b39
    1414:	00000a1c 	andeq	r0, r0, ip, lsl sl
    1418:	0300160c 	movweq	r1, #1548	; 0x60c
    141c:	3b0b3a0e 	blcc	2cfc5c <__bss_end+0x2c391c>
    1420:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
    1424:	0d000013 	stceq	0, cr0, [r0, #-76]	; 0xffffffb4
    1428:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
    142c:	0b3a0e03 	bleq	e84c40 <__bss_end+0xe78900>
    1430:	0b39053b 	bleq	e42924 <__bss_end+0xe365e4>
    1434:	13491927 	movtne	r1, #39207	; 0x9927
    1438:	06120111 			; <UNDEFINED> instruction: 0x06120111
    143c:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
    1440:	00130119 	andseq	r0, r3, r9, lsl r1
    1444:	00050e00 	andeq	r0, r5, r0, lsl #28
    1448:	0b3a0803 	bleq	e8345c <__bss_end+0xe7711c>
    144c:	0b39053b 	bleq	e42940 <__bss_end+0xe36600>
    1450:	17021349 	strne	r1, [r2, -r9, asr #6]
    1454:	001742b7 			; <UNDEFINED> instruction: 0x001742b7
    1458:	82890f00 	addhi	r0, r9, #0, 30
    145c:	01110101 	tsteq	r1, r1, lsl #2
    1460:	31194295 			; <UNDEFINED> instruction: 0x31194295
    1464:	00130113 	andseq	r0, r3, r3, lsl r1
    1468:	828a1000 	addhi	r1, sl, #0
    146c:	18020001 	stmdane	r2, {r0}
    1470:	00184291 	mulseq	r8, r1, r2
    1474:	82891100 	addhi	r1, r9, #0, 2
    1478:	01110101 	tsteq	r1, r1, lsl #2
    147c:	00001331 	andeq	r1, r0, r1, lsr r3
    1480:	3f002e12 	svccc	0x00002e12
    1484:	6e193c19 	mrcvs	12, 0, r3, cr9, cr9, {0}
    1488:	3a0e030e 	bcc	3820c8 <__bss_end+0x375d88>
    148c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    1490:	0000000b 	andeq	r0, r0, fp
    1494:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
    1498:	030b130e 	movweq	r1, #45838	; 0xb30e
    149c:	110e1b0e 	tstne	lr, lr, lsl #22
    14a0:	10061201 	andne	r1, r6, r1, lsl #4
    14a4:	02000017 	andeq	r0, r0, #23
    14a8:	0b0b0024 	bleq	2c1540 <__bss_end+0x2b5200>
    14ac:	0e030b3e 	vmoveq.16	d3[0], r0
    14b0:	24030000 	strcs	r0, [r3], #-0
    14b4:	3e0b0b00 	vmlacc.f64	d0, d11, d0
    14b8:	0008030b 	andeq	r0, r8, fp, lsl #6
    14bc:	01040400 	tsteq	r4, r0, lsl #8
    14c0:	0b3e0e03 	bleq	f84cd4 <__bss_end+0xf78994>
    14c4:	13490b0b 	movtne	r0, #39691	; 0x9b0b
    14c8:	0b3b0b3a 	bleq	ec41b8 <__bss_end+0xeb7e78>
    14cc:	13010b39 	movwne	r0, #6969	; 0x1b39
    14d0:	28050000 	stmdacs	r5, {}	; <UNPREDICTABLE>
    14d4:	1c0e0300 	stcne	3, cr0, [lr], {-0}
    14d8:	0600000b 	streq	r0, [r0], -fp
    14dc:	0e030113 	mcreq	1, 0, r0, cr3, cr3, {0}
    14e0:	0b3a0b0b 	bleq	e84114 <__bss_end+0xe77dd4>
    14e4:	0b39053b 	bleq	e429d8 <__bss_end+0xe36698>
    14e8:	00001301 	andeq	r1, r0, r1, lsl #6
    14ec:	03000d07 	movweq	r0, #3335	; 0xd07
    14f0:	3b0b3a0e 	blcc	2cfd30 <__bss_end+0x2c39f0>
    14f4:	490b3905 	stmdbmi	fp, {r0, r2, r8, fp, ip, sp}
    14f8:	000b3813 	andeq	r3, fp, r3, lsl r8
    14fc:	00260800 	eoreq	r0, r6, r0, lsl #16
    1500:	00001349 	andeq	r1, r0, r9, asr #6
    1504:	49010109 	stmdbmi	r1, {r0, r3, r8}
    1508:	00130113 	andseq	r0, r3, r3, lsl r1
    150c:	00210a00 	eoreq	r0, r1, r0, lsl #20
    1510:	0b2f1349 	bleq	bc623c <__bss_end+0xbb9efc>
    1514:	340b0000 	strcc	r0, [fp], #-0
    1518:	3a0e0300 	bcc	382120 <__bss_end+0x375de0>
    151c:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
    1520:	1c13490b 			; <UNDEFINED> instruction: 0x1c13490b
    1524:	0c00000a 	stceq	0, cr0, [r0], {10}
    1528:	0e030016 	mcreq	0, 0, r0, cr3, cr6, {0}
    152c:	0b3b0b3a 	bleq	ec421c <__bss_end+0xeb7edc>
    1530:	13490b39 	movtne	r0, #39737	; 0x9b39
    1534:	2e0d0000 	cdpcs	0, 0, cr0, cr13, cr0, {0}
    1538:	03193f01 	tsteq	r9, #1, 30
    153c:	3b0b3a0e 	blcc	2cfd7c <__bss_end+0x2c3a3c>
    1540:	270b3905 	strcs	r3, [fp, -r5, lsl #18]
    1544:	11134919 	tstne	r3, r9, lsl r9
    1548:	40061201 	andmi	r1, r6, r1, lsl #4
    154c:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
    1550:	050e0000 	streq	r0, [lr, #-0]
    1554:	3a080300 	bcc	20215c <__bss_end+0x1f5e1c>
    1558:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
    155c:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
    1560:	1742b717 	smlaldne	fp, r2, r7, r7
    1564:	340f0000 	strcc	r0, [pc], #-0	; 156c <shift+0x156c>
    1568:	3a080300 	bcc	202170 <__bss_end+0x1f5e30>
    156c:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
    1570:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
    1574:	1742b717 	smlaldne	fp, r2, r7, r7
    1578:	01000000 	mrseq	r0, (UNDEF: 0)
    157c:	0e250111 	mcreq	1, 1, r0, cr5, cr1, {0}
    1580:	0e030b13 	vmoveq.32	d3[0], r0
    1584:	01110e1b 	tsteq	r1, fp, lsl lr
    1588:	17100612 			; <UNDEFINED> instruction: 0x17100612
    158c:	24020000 	strcs	r0, [r2], #-0
    1590:	3e0b0b00 	vmlacc.f64	d0, d11, d0
    1594:	000e030b 	andeq	r0, lr, fp, lsl #6
    1598:	00240300 	eoreq	r0, r4, r0, lsl #6
    159c:	0b3e0b0b 	bleq	f841d0 <__bss_end+0xf77e90>
    15a0:	00000803 	andeq	r0, r0, r3, lsl #16
    15a4:	03010404 	movweq	r0, #5124	; 0x1404
    15a8:	0b0b3e0e 	bleq	2d0de8 <__bss_end+0x2c4aa8>
    15ac:	3a13490b 	bcc	4d39e0 <__bss_end+0x4c76a0>
    15b0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    15b4:	0013010b 	andseq	r0, r3, fp, lsl #2
    15b8:	00280500 	eoreq	r0, r8, r0, lsl #10
    15bc:	0b1c0e03 	bleq	704dd0 <__bss_end+0x6f8a90>
    15c0:	13060000 	movwne	r0, #24576	; 0x6000
    15c4:	0b0e0301 	bleq	3821d0 <__bss_end+0x375e90>
    15c8:	3b0b3a0b 	blcc	2cfdfc <__bss_end+0x2c3abc>
    15cc:	010b3905 	tsteq	fp, r5, lsl #18
    15d0:	07000013 	smladeq	r0, r3, r0, r0
    15d4:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
    15d8:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
    15dc:	13490b39 	movtne	r0, #39737	; 0x9b39
    15e0:	00000b38 	andeq	r0, r0, r8, lsr fp
    15e4:	49002608 	stmdbmi	r0, {r3, r9, sl, sp}
    15e8:	09000013 	stmdbeq	r0, {r0, r1, r4}
    15ec:	13490101 	movtne	r0, #37121	; 0x9101
    15f0:	00001301 	andeq	r1, r0, r1, lsl #6
    15f4:	4900210a 	stmdbmi	r0, {r1, r3, r8, sp}
    15f8:	000b2f13 	andeq	r2, fp, r3, lsl pc
    15fc:	00340b00 	eorseq	r0, r4, r0, lsl #22
    1600:	0b3a0e03 	bleq	e84e14 <__bss_end+0xe78ad4>
    1604:	0b39053b 	bleq	e42af8 <__bss_end+0xe367b8>
    1608:	0a1c1349 	beq	706334 <__bss_end+0x6f9ff4>
    160c:	160c0000 	strne	r0, [ip], -r0
    1610:	3a0e0300 	bcc	382218 <__bss_end+0x375ed8>
    1614:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    1618:	0013490b 	andseq	r4, r3, fp, lsl #18
    161c:	012e0d00 			; <UNDEFINED> instruction: 0x012e0d00
    1620:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
    1624:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
    1628:	19270b39 	stmdbne	r7!, {r0, r3, r4, r5, r8, r9, fp}
    162c:	01111349 	tsteq	r1, r9, asr #6
    1630:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
    1634:	01194297 			; <UNDEFINED> instruction: 0x01194297
    1638:	0e000013 	mcreq	0, 0, r0, cr0, cr3, {0}
    163c:	08030005 	stmdaeq	r3, {r0, r2}
    1640:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
    1644:	13490b39 	movtne	r0, #39737	; 0x9b39
    1648:	42b71702 	adcsmi	r1, r7, #524288	; 0x80000
    164c:	0f000017 	svceq	0x00000017
    1650:	08030005 	stmdaeq	r3, {r0, r2}
    1654:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
    1658:	13490b39 	movtne	r0, #39737	; 0x9b39
    165c:	00001802 	andeq	r1, r0, r2, lsl #16
    1660:	03003410 	movweq	r3, #1040	; 0x410
    1664:	3b0b3a08 	blcc	2cfe8c <__bss_end+0x2c3b4c>
    1668:	490b3905 	stmdbmi	fp, {r0, r2, r8, fp, ip, sp}
    166c:	b7170213 			; <UNDEFINED> instruction: 0xb7170213
    1670:	00001742 	andeq	r1, r0, r2, asr #14
    1674:	0b000f11 	bleq	52c0 <shift+0x52c0>
    1678:	0013490b 	andseq	r4, r3, fp, lsl #18
    167c:	11010000 	mrsne	r0, (UNDEF: 1)
    1680:	130e2501 	movwne	r2, #58625	; 0xe501
    1684:	1b0e030b 	blne	3822b8 <__bss_end+0x375f78>
    1688:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
    168c:	00171006 	andseq	r1, r7, r6
    1690:	00240200 	eoreq	r0, r4, r0, lsl #4
    1694:	0b3e0b0b 	bleq	f842c8 <__bss_end+0xf77f88>
    1698:	00000803 	andeq	r0, r0, r3, lsl #16
    169c:	03001603 	movweq	r1, #1539	; 0x603
    16a0:	3b0b3a0e 	blcc	2cfee0 <__bss_end+0x2c3ba0>
    16a4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
    16a8:	04000013 	streq	r0, [r0], #-19	; 0xffffffed
    16ac:	0b0b0024 	bleq	2c1744 <__bss_end+0x2b5404>
    16b0:	0e030b3e 	vmoveq.16	d3[0], r0
    16b4:	0f050000 	svceq	0x00050000
    16b8:	000b0b00 	andeq	r0, fp, r0, lsl #22
    16bc:	000f0600 	andeq	r0, pc, r0, lsl #12
    16c0:	13490b0b 	movtne	r0, #39691	; 0x9b0b
    16c4:	2e070000 	cdpcs	0, 0, cr0, cr7, cr0, {0}
    16c8:	03193f01 	tsteq	r9, #1, 30
    16cc:	3b0b3a0e 	blcc	2cff0c <__bss_end+0x2c3bcc>
    16d0:	270b390b 	strcs	r3, [fp, -fp, lsl #18]
    16d4:	11134919 	tstne	r3, r9, lsl r9
    16d8:	40061201 	andmi	r1, r6, r1, lsl #4
    16dc:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
    16e0:	00001301 	andeq	r1, r0, r1, lsl #6
    16e4:	03000508 	movweq	r0, #1288	; 0x508
    16e8:	3b0b3a08 	blcc	2cff10 <__bss_end+0x2c3bd0>
    16ec:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
    16f0:	00180213 	andseq	r0, r8, r3, lsl r2
    16f4:	00050900 	andeq	r0, r5, r0, lsl #18
    16f8:	0b3a0803 	bleq	e8370c <__bss_end+0xe773cc>
    16fc:	0b390b3b 	bleq	e443f0 <__bss_end+0xe380b0>
    1700:	17021349 	strne	r1, [r2, -r9, asr #6]
    1704:	001742b7 			; <UNDEFINED> instruction: 0x001742b7
    1708:	00340a00 	eorseq	r0, r4, r0, lsl #20
    170c:	0b3a0803 	bleq	e83720 <__bss_end+0xe773e0>
    1710:	0b390b3b 	bleq	e44404 <__bss_end+0xe380c4>
    1714:	17021349 	strne	r1, [r2, -r9, asr #6]
    1718:	001742b7 			; <UNDEFINED> instruction: 0x001742b7
    171c:	00340b00 	eorseq	r0, r4, r0, lsl #22
    1720:	0b3a0e03 	bleq	e84f34 <__bss_end+0xe78bf4>
    1724:	0b390b3b 	bleq	e44418 <__bss_end+0xe380d8>
    1728:	17021349 	strne	r1, [r2, -r9, asr #6]
    172c:	001742b7 			; <UNDEFINED> instruction: 0x001742b7
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
  60:	0000002c 	andeq	r0, r0, ip, lsr #32
  64:	02d40002 	sbcseq	r0, r4, #2
  68:	00040000 	andeq	r0, r4, r0
  6c:	00000000 	andeq	r0, r0, r0
  70:	0000822c 	andeq	r8, r0, ip, lsr #4
  74:	00000484 	andeq	r0, r0, r4, lsl #9
  78:	000086b0 			; <UNDEFINED> instruction: 0x000086b0
  7c:	00000030 	andeq	r0, r0, r0, lsr r0
  80:	000086e0 	andeq	r8, r0, r0, ror #13
  84:	00000030 	andeq	r0, r0, r0, lsr r0
	...
  90:	00000034 	andeq	r0, r0, r4, lsr r0
  94:	0d0a0002 	stceq	0, cr0, [sl, #-8]
  98:	00040000 	andeq	r0, r4, r0
  9c:	00000000 	andeq	r0, r0, r0
  a0:	00008710 	andeq	r8, r0, r0, lsl r7
  a4:	00001438 	andeq	r1, r0, r8, lsr r4
  a8:	000086b0 			; <UNDEFINED> instruction: 0x000086b0
  ac:	00000030 	andeq	r0, r0, r0, lsr r0
  b0:	000086e0 	andeq	r8, r0, r0, ror #13
  b4:	00000030 	andeq	r0, r0, r0, lsr r0
  b8:	00009b48 	andeq	r9, r0, r8, asr #22
  bc:	00000030 	andeq	r0, r0, r0, lsr r0
	...
  c8:	0000001c 	andeq	r0, r0, ip, lsl r0
  cc:	1ed50002 	cdpne	0, 13, cr0, cr5, cr2, {0}
  d0:	00040000 	andeq	r0, r4, r0
  d4:	00000000 	andeq	r0, r0, r0
  d8:	00009b78 	andeq	r9, r0, r8, ror fp
  dc:	00000270 	andeq	r0, r0, r0, ror r2
	...
  e8:	0000001c 	andeq	r0, r0, ip, lsl r0
  ec:	214f0002 	cmpcs	pc, r2
  f0:	00040000 	andeq	r0, r4, r0
  f4:	00000000 	andeq	r0, r0, r0
  f8:	00009de8 	andeq	r9, r0, r8, ror #27
  fc:	000001d4 	ldrdeq	r0, [r0], -r4
	...
 108:	0000001c 	andeq	r0, r0, ip, lsl r0
 10c:	23a00002 	movcs	r0, #2
 110:	00040000 	andeq	r0, r4, r0
 114:	00000000 	andeq	r0, r0, r0
 118:	00009fc0 	andeq	r9, r0, r0, asr #31
 11c:	00000160 	andeq	r0, r0, r0, ror #2
	...
 128:	00000024 	andeq	r0, r0, r4, lsr #32
 12c:	25db0002 	ldrbcs	r0, [fp, #2]
 130:	00040000 	andeq	r0, r4, r0
 134:	00000000 	andeq	r0, r0, r0
 138:	0000a120 	andeq	sl, r0, r0, lsr #2
 13c:	00000420 	andeq	r0, r0, r0, lsr #8
 140:	000086e0 	andeq	r8, r0, r0, ror #13
 144:	00000030 	andeq	r0, r0, r0, lsr r0
	...
 150:	0000001c 	andeq	r0, r0, ip, lsl r0
 154:	2bfa0002 	blcs	ffe80164 <__bss_end+0xffe73e24>
 158:	00040000 	andeq	r0, r4, r0
 15c:	00000000 	andeq	r0, r0, r0
 160:	0000a540 	andeq	sl, r0, r0, asr #10
 164:	0000045c 	andeq	r0, r0, ip, asr r4
	...
 170:	0000001c 	andeq	r0, r0, ip, lsl r0
 174:	378f0002 	strcc	r0, [pc, r2]
 178:	00040000 	andeq	r0, r4, r0
 17c:	00000000 	andeq	r0, r0, r0
 180:	0000a9a0 	andeq	sl, r0, r0, lsr #19
 184:	00000c5c 	andeq	r0, r0, ip, asr ip
	...
 190:	0000001c 	andeq	r0, r0, ip, lsl r0
 194:	3dc00002 	stclcc	0, cr0, [r0, #8]
 198:	00040000 	andeq	r0, r4, r0
 19c:	00000000 	andeq	r0, r0, r0
 1a0:	0000b5fc 	strdeq	fp, [r0], -ip
 1a4:	0000020c 	andeq	r0, r0, ip, lsl #4
	...
 1b0:	0000001c 	andeq	r0, r0, ip, lsl r0
 1b4:	3de60002 	stclcc	0, cr0, [r6, #8]!
 1b8:	00040000 	andeq	r0, r4, r0
 1bc:	00000000 	andeq	r0, r0, r0
 1c0:	0000b808 	andeq	fp, r0, r8, lsl #16
 1c4:	00000240 	andeq	r0, r0, r0, asr #4
	...
 1d0:	0000001c 	andeq	r0, r0, ip, lsl r0
 1d4:	3e0c0002 	cdpcc	0, 0, cr0, cr12, cr2, {0}
 1d8:	00040000 	andeq	r0, r4, r0
 1dc:	00000000 	andeq	r0, r0, r0
 1e0:	0000ba48 	andeq	fp, r0, r8, asr #20
 1e4:	00000004 	andeq	r0, r0, r4
	...
 1f0:	0000001c 	andeq	r0, r0, ip, lsl r0
 1f4:	3e320002 	cdpcc	0, 3, cr0, cr2, cr2, {0}
 1f8:	00040000 	andeq	r0, r4, r0
 1fc:	00000000 	andeq	r0, r0, r0
 200:	0000ba4c 	andeq	fp, r0, ip, asr #20
 204:	00000250 	andeq	r0, r0, r0, asr r2
	...
 210:	0000001c 	andeq	r0, r0, ip, lsl r0
 214:	3e580002 	cdpcc	0, 5, cr0, cr8, cr2, {0}
 218:	00040000 	andeq	r0, r4, r0
 21c:	00000000 	andeq	r0, r0, r0
 220:	0000bc9c 	muleq	r0, ip, ip
 224:	000000d4 	ldrdeq	r0, [r0], -r4
	...
 230:	00000014 	andeq	r0, r0, r4, lsl r0
 234:	3e7e0002 	cdpcc	0, 7, cr0, cr14, cr2, {0}
 238:	00040000 	andeq	r0, r4, r0
	...
 248:	0000001c 	andeq	r0, r0, ip, lsl r0
 24c:	41ac0002 			; <UNDEFINED> instruction: 0x41ac0002
 250:	00040000 	andeq	r0, r4, r0
 254:	00000000 	andeq	r0, r0, r0
 258:	0000bd70 	andeq	fp, r0, r0, ror sp
 25c:	00000030 	andeq	r0, r0, r0, lsr r0
	...
 268:	0000001c 	andeq	r0, r0, ip, lsl r0
 26c:	44b60002 	ldrtmi	r0, [r6], #2
 270:	00040000 	andeq	r0, r4, r0
 274:	00000000 	andeq	r0, r0, r0
 278:	0000bda0 	andeq	fp, r0, r0, lsr #27
 27c:	00000040 	andeq	r0, r0, r0, asr #32
	...
 288:	0000001c 	andeq	r0, r0, ip, lsl r0
 28c:	47e40002 	strbmi	r0, [r4, r2]!
 290:	00040000 	andeq	r0, r4, r0
 294:	00000000 	andeq	r0, r0, r0
 298:	0000bde0 	andeq	fp, r0, r0, ror #27
 29c:	00000120 	andeq	r0, r0, r0, lsr #2
	...
 2a8:	0000001c 	andeq	r0, r0, ip, lsl r0
 2ac:	4b680002 	blmi	1a002bc <__bss_end+0x19f3f7c>
 2b0:	00040000 	andeq	r0, r4, r0
 2b4:	00000000 	andeq	r0, r0, r0
 2b8:	0000bf00 	andeq	fp, r0, r0, lsl #30
 2bc:	00000118 	andeq	r0, r0, r8, lsl r1
	...

Disassembly of section .debug_str:

00000000 <.debug_str>:
       0:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; ffffff4c <__bss_end+0xffff3c0c>
       4:	72742f65 	rsbsvc	r2, r4, #404	; 0x194
       8:	6c696665 	stclvs	6, cr6, [r9], #-404	; 0xfffffe6c
       c:	6d65732f 	stclvs	3, cr7, [r5, #-188]!	; 0xffffff44
      10:	756f732f 	strbvc	r7, [pc, #-815]!	; fffffce9 <__bss_end+0xffff39a9>
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
      40:	752f7365 	strvc	r7, [pc, #-869]!	; fffffce3 <__bss_end+0xffff39a3>
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
      dc:	2b6b7a36 	blcs	1ade9bc <__bss_end+0x1ad267c>
      e0:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
      e4:	672d2067 	strvs	r2, [sp, -r7, rrx]!
      e8:	304f2d20 	subcc	r2, pc, r0, lsr #26
      ec:	304f2d20 	subcc	r2, pc, r0, lsr #26
      f0:	625f5f00 	subsvs	r5, pc, #0, 30
      f4:	655f7373 	ldrbvs	r7, [pc, #-883]	; fffffd89 <__bss_end+0xffff3a49>
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
     160:	755f6962 	ldrbvc	r6, [pc, #-2402]	; fffff806 <__bss_end+0xffff34c6>
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
     260:	2b432055 	blcs	10c83bc <__bss_end+0x10bc07c>
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
     2c4:	7a6a3637 	bvc	1a8dba8 <__bss_end+0x1a81868>
     2c8:	20732d66 	rsbscs	r2, r3, r6, ror #26
     2cc:	72616d2d 	rsbvc	r6, r1, #2880	; 0xb40
     2d0:	6d2d206d 	stcvs	0, cr2, [sp, #-436]!	; 0xfffffe4c
     2d4:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
     2d8:	6d72613d 	ldfvse	f6, [r2, #-244]!	; 0xffffff0c
     2dc:	6b7a3676 	blvs	1e8dcbc <__bss_end+0x1e8197c>
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
     360:	616e5a5f 	cmnvs	lr, pc, asr sl
     364:	6572006a 	ldrbvs	r0, [r2, #-106]!	; 0xffffff96
     368:	705f6461 	subsvc	r6, pc, r1, ror #8
     36c:	746e696f 	strbtvc	r6, [lr], #-2415	; 0xfffff691
     370:	4d007265 	sfmmi	f7, 4, [r0, #-404]	; 0xfffffe6c
     374:	6c65646f 	cfstrdvs	mvd6, [r5], #-444	; 0xfffffe44
     378:	54414400 	strbpl	r4, [r1], #-1024	; 0xfffffc00
     37c:	49575f41 	ldmdbmi	r7, {r0, r6, r8, r9, sl, fp, ip, lr}^
     380:	574f444e 	strbpl	r4, [pc, -lr, asr #8]
     384:	5a49535f 	bpl	1255108 <__bss_end+0x1248dc8>
     388:	5a5f0045 	bpl	17c04a4 <__bss_end+0x17b4164>
     38c:	6f4d354e 	svcvs	0x004d354e
     390:	376c6564 	strbcc	r6, [ip, -r4, ror #10]!
     394:	64657250 	strbtvs	r7, [r5], #-592	; 0xfffffdb0
     398:	45746369 	ldrbmi	r6, [r4, #-873]!	; 0xfffffc97
     39c:	72543950 	subsvc	r3, r4, #80, 18	; 0x140000
     3a0:	73656269 	cmnvc	r5, #-1879048186	; 0x90000006
     3a4:	006e616d 	rsbeq	r6, lr, sp, ror #2
     3a8:	354e5a5f 	strbcc	r5, [lr, #-2655]	; 0xfffff5a1
     3ac:	65646f4d 	strbvs	r6, [r4, #-3917]!	; 0xfffff0b3
     3b0:	4135316c 	teqmi	r5, ip, ror #2
     3b4:	445f6464 	ldrbmi	r6, [pc], #-1124	; 3bc <shift+0x3bc>
     3b8:	5f617461 	svcpl	0x00617461
     3bc:	706d6153 	rsbvc	r6, sp, r3, asr r1
     3c0:	6645656c 	strbvs	r6, [r5], -ip, ror #10
     3c4:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     3c8:	66754236 			; <UNDEFINED> instruction: 0x66754236
     3cc:	31726566 	cmncc	r2, r6, ror #10
     3d0:	69725730 	ldmdbvs	r2!, {r4, r5, r8, r9, sl, ip, lr}^
     3d4:	4c5f6574 	cfldr64mi	mvdx6, [pc], {116}	; 0x74
     3d8:	45656e69 	strbmi	r6, [r5, #-3689]!	; 0xfffff197
     3dc:	00634b50 	rsbeq	r4, r3, r0, asr fp
     3e0:	5f746547 	svcpl	0x00746547
     3e4:	616f6c46 	cmnvs	pc, r6, asr #24
     3e8:	5a5f0074 	bpl	17c05c0 <__bss_end+0x17b4280>
     3ec:	5236314e 	eorspl	r3, r6, #-2147483629	; 0x80000013
     3f0:	6f646e61 	svcvs	0x00646e61
     3f4:	65475f6d 	strbvs	r5, [r7, #-3949]	; 0xfffff093
     3f8:	6172656e 	cmnvs	r2, lr, ror #10
     3fc:	37726f74 			; <UNDEFINED> instruction: 0x37726f74
     400:	5f746547 	svcpl	0x00746547
     404:	45746e49 	ldrbmi	r6, [r4, #-3657]!	; 0xfffff1b7
     408:	73490076 	movtvc	r0, #36982	; 0x9076
     40c:	6c75465f 	ldclvs	6, cr4, [r5], #-380	; 0xfffffe84
     410:	706f006c 	rsbvc	r0, pc, ip, rrx
     414:	74617265 	strbtvc	r7, [r1], #-613	; 0xfffffd9b
     418:	6e20726f 	cdpvs	2, 2, cr7, cr0, cr15, {3}
     41c:	5b207765 	blpl	81e1b8 <__bss_end+0x811e78>
     420:	6170005d 	cmnvs	r0, sp, asr r0
     424:	656d6172 	strbvs	r6, [sp, #-370]!	; 0xfffffe8e
     428:	73726574 	cmnvc	r2, #116, 10	; 0x1d000000
     42c:	315a5f00 	cmpcc	sl, r0, lsl #30
     430:	6c656836 	stclvs	8, cr6, [r5], #-216	; 0xffffff28
     434:	755f6f6c 	ldrbvc	r6, [pc, #-3948]	; fffff4d0 <__bss_end+0xffff3190>
     438:	5f747261 	svcpl	0x00747261
     43c:	6c726f77 	ldclvs	15, cr6, [r2], #-476	; 0xfffffe24
     440:	42365064 	eorsmi	r5, r6, #100	; 0x64
     444:	65666675 	strbvs	r6, [r6, #-1653]!	; 0xfffff98b
     448:	65470072 	strbvs	r0, [r7, #-114]	; 0xffffff8e
     44c:	61445f74 	hvcvs	17908	; 0x45f4
     450:	535f6174 	cmppl	pc, #116, 2
     454:	6c706d61 	ldclvs	13, cr6, [r0], #-388	; 0xfffffe7c
     458:	5f007365 	svcpl	0x00007365
     45c:	4d354e5a 	ldcmi	14, cr4, [r5, #-360]!	; 0xfffffe98
     460:	6c65646f 	cfstrdvs	mvd6, [r5], #-444	; 0xfffffe44
     464:	68433031 	stmdavs	r3, {r0, r4, r5, ip, sp}^
     468:	706b6365 	rsbvc	r6, fp, r5, ror #6
     46c:	746e696f 	strbtvc	r6, [lr], #-2415	; 0xfffff691
     470:	74007645 	strvc	r7, [r0], #-1605	; 0xfffff9bb
     474:	0033706d 	eorseq	r7, r3, sp, rrx
     478:	31706d74 	cmncc	r0, r4, ror sp
     47c:	706d7400 	rsbvc	r7, sp, r0, lsl #8
     480:	72770032 	rsbsvc	r0, r7, #50	; 0x32
     484:	5f657469 	svcpl	0x00657469
     488:	6e696f70 	mcrvs	15, 3, r6, cr9, cr0, {3}
     48c:	00726574 	rsbseq	r6, r2, r4, ror r5
     490:	665f7369 	ldrbvs	r7, [pc], -r9, ror #6
     494:	69747469 	ldmdbvs	r4!, {r0, r3, r5, r6, sl, ip, sp, lr}^
     498:	6100676e 	tstvs	r0, lr, ror #14
     49c:	6168706c 	cmnvs	r8, ip, rrx
     4a0:	69725000 	ldmdbvs	r2!, {ip, lr}^
     4a4:	415f746e 	cmpmi	pc, lr, ror #8
     4a8:	6168706c 	cmnvs	r8, ip, rrx
     4ac:	6572505f 	ldrbvs	r5, [r2, #-95]!	; 0xffffffa1
     4b0:	74636964 	strbtvc	r6, [r3], #-2404	; 0xfffff69c
     4b4:	736e6f69 	cmnvc	lr, #420	; 0x1a4
     4b8:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     4bc:	66754236 			; <UNDEFINED> instruction: 0x66754236
     4c0:	38726566 	ldmdacc	r2!, {r1, r2, r5, r6, r8, sl, sp, lr}^
     4c4:	5f646441 	svcpl	0x00646441
     4c8:	65747942 	ldrbvs	r7, [r4, #-2370]!	; 0xfffff6be
     4cc:	4d006345 	stcmi	3, cr6, [r0, #-276]	; 0xfffffeec
     4d0:	69467861 	stmdbvs	r6, {r0, r5, r6, fp, ip, sp, lr}^
     4d4:	616e656c 	cmnvs	lr, ip, ror #10
     4d8:	654c656d 	strbvs	r6, [ip, #-1389]	; 0xfffffa93
     4dc:	6874676e 	ldmdavs	r4!, {r1, r2, r3, r5, r6, r8, r9, sl, sp, lr}^
     4e0:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     4e4:	646f4d35 	strbtvs	r4, [pc], #-3381	; 4ec <shift+0x4ec>
     4e8:	49346c65 	ldmdbmi	r4!, {r0, r2, r5, r6, sl, fp, sp, lr}
     4ec:	4574696e 	ldrbmi	r6, [r4, #-2414]!	; 0xfffff692
     4f0:	65470076 	strbvs	r0, [r7, #-118]	; 0xffffff8a
     4f4:	6e495f74 	mcrvs	15, 2, r5, cr9, cr4, {3}
     4f8:	696d0074 	stmdbvs	sp!, {r2, r4, r5, r6}^
     4fc:	72655f6e 	rsbvc	r5, r5, #440	; 0x1b8
     500:	00726f72 	rsbseq	r6, r2, r2, ror pc
     504:	354e5a5f 	strbcc	r5, [lr, #-2655]	; 0xfffff5a1
     508:	65646f4d 	strbvs	r6, [r4, #-3917]!	; 0xfffff0b3
     50c:	754d386c 	strbvc	r3, [sp, #-2156]	; 0xfffff794
     510:	69746174 	ldmdbvs	r4!, {r2, r4, r5, r6, r8, sp, lr}^
     514:	50456e6f 	subpl	r6, r5, pc, ror #28
     518:	72543950 	subsvc	r3, r4, #80, 18	; 0x140000
     51c:	73656269 	cmnvc	r5, #-1879048186	; 0x90000006
     520:	006e616d 	rsbeq	r6, lr, sp, ror #2
     524:	64616544 	strbtvs	r6, [r1], #-1348	; 0xfffffabc
     528:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
     52c:	636e555f 	cmnvs	lr, #398458880	; 0x17c00000
     530:	676e6168 	strbvs	r6, [lr, -r8, ror #2]!
     534:	5f006465 	svcpl	0x00006465
     538:	6a776e5a 	bvs	1ddbea8 <__bss_end+0x1dcfb68>
     53c:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     540:	646f4d35 	strbtvs	r4, [pc], #-3381	; 548 <shift+0x548>
     544:	43366c65 	teqmi	r6, #25856	; 0x6500
     548:	5f636c61 	svcpl	0x00636c61
     54c:	66664542 	strbtvs	r4, [r6], -r2, asr #10
     550:	6f4e0066 	svcvs	0x004e0066
     554:	79666974 	stmdbvc	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
     558:	006c6c41 	rsbeq	r6, ip, r1, asr #24
     55c:	314e5a5f 	cmpcc	lr, pc, asr sl
     560:	61654832 	cmnvs	r5, r2, lsr r8
     564:	614d5f70 	hvcvs	54768	; 0xd5f0
     568:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     56c:	6c413572 	cfstr64vs	mvdx3, [r1], {114}	; 0x72
     570:	45636f6c 	strbmi	r6, [r3, #-3948]!	; 0xfffff094
     574:	5a5f006a 	bpl	17c0724 <__bss_end+0x17b43e4>
     578:	6f4d354e 	svcvs	0x004d354e
     57c:	316c6564 	cmncc	ip, r4, ror #10
     580:	61764539 	cmnvs	r6, r9, lsr r5
     584:	74535f6c 	ldrbvc	r5, [r3], #-3948	; 0xfffff094
     588:	676e6972 			; <UNDEFINED> instruction: 0x676e6972
     58c:	6d6f435f 	stclvs	3, cr4, [pc, #-380]!	; 418 <shift+0x418>
     590:	646e616d 	strbtvs	r6, [lr], #-365	; 0xfffffe93
     594:	634b5045 	movtvs	r5, #45125	; 0xb045
     598:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     59c:	66754236 			; <UNDEFINED> instruction: 0x66754236
     5a0:	39726566 	ldmdbcc	r2!, {r1, r2, r5, r6, r8, sl, sp, lr}^
     5a4:	5f646441 	svcpl	0x00646441
     5a8:	65747942 	ldrbvs	r7, [r4, #-2370]!	; 0xfffff6be
     5ac:	006a4573 	rsbeq	r4, sl, r3, ror r5
     5b0:	6e697250 	mcrvs	2, 3, r7, cr9, cr0, {2}
     5b4:	61505f74 	cmpvs	r0, r4, ror pc
     5b8:	656d6172 	strbvs	r6, [sp, #-370]!	; 0xfffffe8e
     5bc:	73726574 	cmnvc	r2, #116, 10	; 0x1d000000
     5c0:	61654800 	cmnvs	r5, r0, lsl #16
     5c4:	614d5f70 	hvcvs	54768	; 0xd5f0
     5c8:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     5cc:	614d0072 	hvcvs	53250	; 0xd002
     5d0:	72505f78 	subsvc	r5, r0, #120, 30	; 0x1e0
     5d4:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     5d8:	704f5f73 	subvc	r5, pc, r3, ror pc	; <UNPREDICTABLE>
     5dc:	64656e65 	strbtvs	r6, [r5], #-3685	; 0xfffff19b
     5e0:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     5e4:	50007365 	andpl	r7, r0, r5, ror #6
     5e8:	4c55504f 	mrrcmi	0, 4, r5, r5, cr15	; <UNPREDICTABLE>
     5ec:	4f495441 	svcmi	0x00495441
     5f0:	4f435f4e 	svcmi	0x00435f4e
     5f4:	00544e55 	subseq	r4, r4, r5, asr lr
     5f8:	636c6143 	cmnvs	ip, #-1073741808	; 0xc0000010
     5fc:	74616c75 	strbtvc	r6, [r1], #-3189	; 0xfffff38b
     600:	72505f65 	subsvc	r5, r0, #404	; 0x194
     604:	63696465 	cmnvs	r9, #1694498816	; 0x65000000
     608:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     60c:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     610:	646f4d35 	strbtvs	r4, [pc], #-3381	; 618 <shift+0x618>
     614:	31316c65 	teqcc	r1, r5, ror #24
     618:	6d6f7250 	sfmvs	f7, 2, [pc, #-320]!	; 4e0 <shift+0x4e0>
     61c:	555f7470 	ldrbpl	r7, [pc, #-1136]	; 1b4 <shift+0x1b4>
     620:	45726573 	ldrbmi	r6, [r2, #-1395]!	; 0xfffffa8d
     624:	5a5f0076 	bpl	17c0804 <__bss_end+0x17b44c4>
     628:	6f4d354e 	svcvs	0x004d354e
     62c:	396c6564 	stmdbcc	ip!, {r2, r5, r6, r8, sl, sp, lr}^
     630:	5f746553 	svcpl	0x00746553
     634:	68706c41 	ldmdavs	r0!, {r0, r6, sl, fp, sp, lr}^
     638:	39504561 	ldmdbcc	r0, {r0, r5, r6, r8, sl, lr}^
     63c:	62697254 	rsbvs	r7, r9, #84, 4	; 0x40000005
     640:	616d7365 	cmnvs	sp, r5, ror #6
     644:	6573006e 	ldrbvs	r0, [r3, #-110]!	; 0xffffff92
     648:	5f006465 	svcpl	0x00006465
     64c:	4d354e5a 	ldcmi	14, cr4, [r5, #-360]!	; 0xfffffe98
     650:	6c65646f 	cfstrdvs	mvd6, [r5], #-444	; 0xfffffe44
     654:	6e755233 	mrcvs	2, 3, r5, cr5, cr3, {1}
     658:	45007645 	strmi	r7, [r0, #-1605]	; 0xfffff9bb
     65c:	48434f50 	stmdami	r3, {r4, r6, r8, r9, sl, fp, lr}^
     660:	554f435f 	strbpl	r4, [pc, #-863]	; 309 <shift+0x309>
     664:	5f00544e 	svcpl	0x0000544e
     668:	4d354e5a 	ldcmi	14, cr4, [r5, #-360]!	; 0xfffffe98
     66c:	6c65646f 	cfstrdvs	mvd6, [r5], #-444	; 0xfffffe44
     670:	69463631 	stmdbvs	r6, {r0, r4, r5, r9, sl, ip, sp}^
     674:	5f747372 	svcpl	0x00747372
     678:	656e6547 	strbvs	r6, [lr, #-1351]!	; 0xfffffab9
     67c:	69746172 	ldmdbvs	r4!, {r1, r4, r5, r6, r8, sp, lr}^
     680:	76456e6f 	strbvc	r6, [r5], -pc, ror #28
     684:	466f4e00 	strbtmi	r4, [pc], -r0, lsl #28
     688:	73656c69 	cmnvc	r5, #26880	; 0x6900
     68c:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     690:	6972446d 	ldmdbvs	r2!, {r0, r2, r3, r5, r6, sl, lr}^
     694:	00726576 	rsbseq	r6, r2, r6, ror r5
     698:	726f6873 	rsbvc	r6, pc, #7536640	; 0x730000
     69c:	6e752074 	mrcvs	0, 3, r2, cr5, cr4, {3}
     6a0:	6e676973 			; <UNDEFINED> instruction: 0x6e676973
     6a4:	69206465 	stmdbvs	r0!, {r0, r2, r5, r6, sl, sp, lr}
     6a8:	4300746e 	movwmi	r7, #1134	; 0x46e
     6ac:	7261656c 	rsbvc	r6, r1, #108, 10	; 0x1b000000
     6b0:	74655300 	strbtvc	r5, [r5], #-768	; 0xfffffd00
     6b4:	6675425f 			; <UNDEFINED> instruction: 0x6675425f
     6b8:	00726566 	rsbseq	r6, r2, r6, ror #10
     6bc:	636f7065 	cmnvs	pc, #101	; 0x65
     6c0:	6f635f68 	svcvs	0x00635f68
     6c4:	00746e75 	rsbseq	r6, r4, r5, ror lr
     6c8:	636c6143 	cmnvs	ip, #-1073741808	; 0xc0000010
     6cc:	5300425f 	movwpl	r4, #607	; 0x25f
     6d0:	415f7465 	cmpmi	pc, r5, ror #8
     6d4:	6168706c 	cmnvs	r8, ip, rrx
     6d8:	69725700 	ldmdbvs	r2!, {r8, r9, sl, ip, lr}^
     6dc:	4c5f6574 	cfldr64mi	mvdx6, [pc], {116}	; 0x74
     6e0:	00656e69 	rsbeq	r6, r5, r9, ror #28
     6e4:	6c6f6f62 	stclvs	15, cr6, [pc], #-392	; 564 <shift+0x564>
     6e8:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     6ec:	65483231 	strbvs	r3, [r8, #-561]	; 0xfffffdcf
     6f0:	4d5f7061 	ldclmi	0, cr7, [pc, #-388]	; 574 <shift+0x574>
     6f4:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     6f8:	53347265 	teqpl	r4, #1342177286	; 0x50000006
     6fc:	456b7262 	strbmi	r7, [fp, #-610]!	; 0xfffffd9e
     700:	65470076 	strbvs	r0, [r7, #-118]	; 0xffffff8a
     704:	505f656e 	subspl	r6, pc, lr, ror #10
     708:	5f6c6f6f 	svcpl	0x006c6f6f
     70c:	74726150 	ldrbtvc	r6, [r2], #-336	; 0xfffffeb0
     710:	61720079 	cmnvs	r2, r9, ror r0
     714:	6d6f646e 	cfstrdvs	mvd6, [pc, #-440]!	; 564 <shift+0x564>
     718:	6f725000 	svcvs	0x00725000
     71c:	5f74706d 	svcpl	0x0074706d
     720:	72657355 	rsbvc	r7, r5, #1409286145	; 0x54000001
     724:	6e656700 	cdpvs	7, 6, cr6, cr5, cr0, {0}
     728:	74617265 	strbtvc	r7, [r1], #-613	; 0xfffffd9b
     72c:	635f6465 	cmpvs	pc, #1694498816	; 0x65000000
     730:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
     734:	65684300 	strbvs	r4, [r8, #-768]!	; 0xfffffd00
     738:	6f706b63 	svcvs	0x00706b63
     73c:	00746e69 	rsbseq	r6, r4, r9, ror #28
     740:	646e6977 	strbtvs	r6, [lr], #-2423	; 0xfffff689
     744:	735f776f 	cmpvc	pc, #29097984	; 0x1bc0000
     748:	00657a69 	rsbeq	r7, r5, r9, ror #20
     74c:	4678614d 	ldrbtmi	r6, [r8], -sp, asr #2
     750:	69724453 	ldmdbvs	r2!, {r0, r1, r4, r6, sl, lr}^
     754:	4e726576 	mrcmi	5, 3, r6, cr2, cr6, {3}
     758:	4c656d61 	stclmi	13, cr6, [r5], #-388	; 0xfffffe7c
     75c:	74676e65 	strbtvc	r6, [r7], #-3685	; 0xfffff19b
     760:	5a5f0068 	bpl	17c0908 <__bss_end+0x17b45c8>
     764:	6f4d354e 	svcvs	0x004d354e
     768:	316c6564 	cmncc	ip, r4, ror #10
     76c:	5f734939 	svcpl	0x00734939
     770:	61746144 	cmnvs	r4, r4, asr #2
     774:	6e69575f 	mcrvs	7, 3, r5, cr9, cr15, {2}
     778:	5f776f64 	svcpl	0x00776f64
     77c:	6c6c7546 	cfstr64vs	mvdx7, [ip], #-280	; 0xfffffee8
     780:	4c007645 	stcmi	6, cr7, [r0], {69}	; 0x45
     784:	5f6b636f 	svcpl	0x006b636f
     788:	6f6c6e55 	svcvs	0x006c6e55
     78c:	64656b63 	strbtvs	r6, [r5], #-2915	; 0xfffff49d
     790:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     794:	646f4d35 	strbtvs	r4, [pc], #-3381	; 79c <shift+0x79c>
     798:	34436c65 	strbcc	r6, [r3], #-3173	; 0xfffff39b
     79c:	69696945 	stmdbvs	r9!, {r0, r2, r6, r8, fp, sp, lr}^
     7a0:	36506969 	ldrbcc	r6, [r0], -r9, ror #18
     7a4:	66667542 	strbtvs	r7, [r6], -r2, asr #10
     7a8:	5f007265 	svcpl	0x00007265
     7ac:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     7b0:	646e6152 	strbtvs	r6, [lr], #-338	; 0xfffffeae
     7b4:	475f6d6f 	ldrbmi	r6, [pc, -pc, ror #26]
     7b8:	72656e65 	rsbvc	r6, r5, #1616	; 0x650
     7bc:	726f7461 	rsbvc	r7, pc, #1627389952	; 0x61000000
     7c0:	69453443 	stmdbvs	r5, {r0, r1, r6, sl, ip, sp}^
     7c4:	69696969 	stmdbvs	r9!, {r0, r3, r5, r6, r8, fp, sp, lr}^
     7c8:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     7cc:	646f4d35 	strbtvs	r4, [pc], #-3381	; 7d4 <shift+0x7d4>
     7d0:	36316c65 	ldrtcc	r6, [r1], -r5, ror #24
     7d4:	6e697250 	mcrvs	2, 3, r7, cr9, cr0, {2}
     7d8:	61505f74 	cmpvs	r0, r4, ror pc
     7dc:	656d6172 	strbvs	r6, [sp, #-370]!	; 0xfffffe8e
     7e0:	73726574 	cmnvc	r2, #116, 10	; 0x1d000000
     7e4:	5f007645 	svcpl	0x00007645
     7e8:	4d354e5a 	ldcmi	14, cr4, [r5, #-360]!	; 0xfffffe98
     7ec:	6c65646f 	cfstrdvs	mvd6, [r5], #-444	; 0xfffffe44
     7f0:	61433731 	cmpvs	r3, r1, lsr r7
     7f4:	6c75636c 	ldclvs	3, cr6, [r5], #-432	; 0xfffffe50
     7f8:	5f657461 	svcpl	0x00657461
     7fc:	6e746946 	vsubvs.f16	s13, s8, s12	; <UNPREDICTABLE>
     800:	45737365 	ldrbmi	r7, [r3, #-869]!	; 0xfffffc9b
     804:	72543950 	subsvc	r3, r4, #80, 18	; 0x140000
     808:	73656269 	cmnvc	r5, #-1879048186	; 0x90000006
     80c:	006e616d 	rsbeq	r6, lr, sp, ror #2
     810:	6b636f4c 	blvs	18dc548 <__bss_end+0x18d0208>
     814:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
     818:	0064656b 	rsbeq	r6, r4, fp, ror #10
     81c:	64616552 	strbtvs	r6, [r1], #-1362	; 0xfffffaae
     820:	7261555f 	rsbvc	r5, r1, #398458880	; 0x17c00000
     824:	694c5f74 	stmdbvs	ip, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     828:	425f656e 	subsmi	r6, pc, #461373440	; 0x1b800000
     82c:	6b636f6c 	blvs	18dc5e4 <__bss_end+0x18d02a4>
     830:	00676e69 	rsbeq	r6, r7, r9, ror #28
     834:	64616552 	strbtvs	r6, [r1], #-1362	; 0xfffffaae
     838:	6972575f 	ldmdbvs	r2!, {r0, r1, r2, r3, r4, r6, r8, r9, sl, ip, lr}^
     83c:	69006574 	stmdbvs	r0, {r2, r4, r5, r6, r8, sl, sp, lr}
     840:	6572636e 	ldrbvs	r6, [r2, #-878]!	; 0xfffffc92
     844:	746e656d 	strbtvc	r6, [lr], #-1389	; 0xfffffa93
     848:	7a69735f 	bvc	1a5d5cc <__bss_end+0x1a5128c>
     84c:	64410065 	strbvs	r0, [r1], #-101	; 0xffffff9b
     850:	79425f64 	stmdbvc	r2, {r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     854:	00736574 	rsbseq	r6, r3, r4, ror r5
     858:	30315a5f 	eorscc	r5, r1, pc, asr sl
     85c:	6d6d7564 	cfstr64vs	mvdx7, [sp, #-400]!	; 0xfffffe70
     860:	61645f79 	smcvs	17913	; 0x45f9
     864:	66506174 			; <UNDEFINED> instruction: 0x66506174
     868:	706f7000 	rsbvc	r7, pc, r0
     86c:	74616c75 	strbtvc	r6, [r1], #-3189	; 0xfffff38b
     870:	006e6f69 	rsbeq	r6, lr, r9, ror #30
     874:	5078614d 	rsbspl	r6, r8, sp, asr #2
     878:	4c687461 	cfstrdmi	mvd7, [r8], #-388	; 0xfffffe7c
     87c:	74676e65 	strbtvc	r6, [r7], #-3685	; 0xfffff19b
     880:	5a5f0068 	bpl	17c0a28 <__bss_end+0x17b46e8>
     884:	7542364e 	strbvc	r3, [r2, #-1614]	; 0xfffff9b2
     888:	72656666 	rsbvc	r6, r5, #106954752	; 0x6600000
     88c:	65523431 	ldrbvs	r3, [r2, #-1073]	; 0xfffffbcf
     890:	555f6461 	ldrbpl	r6, [pc, #-1121]	; 437 <shift+0x437>
     894:	5f747261 	svcpl	0x00747261
     898:	656e694c 	strbvs	r6, [lr, #-2380]!	; 0xfffff6b4
     89c:	75007645 	strvc	r7, [r0, #-1605]	; 0xfffff9bb
     8a0:	6769736e 	strbvs	r7, [r9, -lr, ror #6]!
     8a4:	2064656e 	rsbcs	r6, r4, lr, ror #10
     8a8:	72616863 	rsbvc	r6, r1, #6488064	; 0x630000
     8ac:	6d756400 	cfldrdvs	mvd6, [r5, #-0]
     8b0:	645f796d 	ldrbvs	r7, [pc], #-2413	; 8b8 <shift+0x8b8>
     8b4:	00617461 	rsbeq	r7, r1, r1, ror #8
     8b8:	354e5a5f 	strbcc	r5, [lr, #-2655]	; 0xfffff5a1
     8bc:	65646f4d 	strbvs	r6, [r4, #-3917]!	; 0xfffff0b3
     8c0:	4330326c 	teqmi	r0, #108, 4	; 0xc0000006
     8c4:	75636c61 	strbvc	r6, [r3, #-3169]!	; 0xfffff39f
     8c8:	6574616c 	ldrbvs	r6, [r4, #-364]!	; 0xfffffe94
     8cc:	6572505f 	ldrbvs	r5, [r2, #-95]!	; 0xffffffa1
     8d0:	74636964 	strbtvc	r6, [r3], #-2404	; 0xfffff69c
     8d4:	456e6f69 	strbmi	r6, [lr, #-3945]!	; 0xfffff097
     8d8:	00666650 	rsbeq	r6, r6, r0, asr r6
     8dc:	75706f70 	ldrbvc	r6, [r0, #-3952]!	; 0xfffff090
     8e0:	6974616c 	ldmdbvs	r4!, {r2, r3, r5, r6, r8, sp, lr}^
     8e4:	635f6e6f 	cmpvs	pc, #1776	; 0x6f0
     8e8:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
     8ec:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     8f0:	65483231 	strbvs	r3, [r8, #-561]	; 0xfffffdcf
     8f4:	4d5f7061 	ldclmi	0, cr7, [pc, #-388]	; 778 <shift+0x778>
     8f8:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     8fc:	35317265 	ldrcc	r7, [r1, #-613]!	; 0xfffffd9b
     900:	5f746547 	svcpl	0x00746547
     904:	5f6d654d 	svcpl	0x006d654d
     908:	72646441 	rsbvc	r6, r4, #1090519040	; 0x41000000
     90c:	45737365 	ldrbmi	r7, [r3, #-869]!	; 0xfffffc9b
     910:	65520076 	ldrbvs	r0, [r2, #-118]	; 0xffffff8a
     914:	555f6461 	ldrbpl	r6, [pc, #-1121]	; 4bb <shift+0x4bb>
     918:	5f747261 	svcpl	0x00747261
     91c:	656e694c 	strbvs	r6, [lr, #-2380]!	; 0xfffff6b4
     920:	6f687300 	svcvs	0x00687300
     924:	69207472 	stmdbvs	r0!, {r1, r4, r5, r6, sl, ip, sp, lr}
     928:	7500746e 	strvc	r7, [r0, #-1134]	; 0xfffffb92
     92c:	5f747261 	svcpl	0x00747261
     930:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
     934:	6c614300 	stclvs	3, cr4, [r1], #-0
     938:	616c7563 	cmnvs	ip, r3, ror #10
     93c:	465f6574 			; <UNDEFINED> instruction: 0x465f6574
     940:	656e7469 	strbvs	r7, [lr, #-1129]!	; 0xfffffb97
     944:	46007373 			; <UNDEFINED> instruction: 0x46007373
     948:	74737269 	ldrbtvc	r7, [r3], #-617	; 0xfffffd97
     94c:	6e65475f 	mcrvs	7, 3, r4, cr5, cr15, {2}
     950:	74617265 	strbtvc	r7, [r1], #-613	; 0xfffffd9b
     954:	006e6f69 	rsbeq	r6, lr, r9, ror #30
     958:	6f6c6c41 	svcvs	0x006c6c41
     95c:	64410063 	strbvs	r0, [r1], #-99	; 0xffffff9d
     960:	79425f64 	stmdbvc	r2, {r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     964:	5f006574 	svcpl	0x00006574
     968:	32314e5a 	eorscc	r4, r1, #1440	; 0x5a0
     96c:	70616548 	rsbvc	r6, r1, r8, asr #10
     970:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     974:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     978:	76453443 	strbvc	r3, [r5], -r3, asr #8
     97c:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     980:	646f4d35 	strbtvs	r4, [pc], #-3381	; 988 <shift+0x988>
     984:	36316c65 	ldrtcc	r6, [r1], -r5, ror #24
     988:	5f746547 	svcpl	0x00746547
     98c:	61746144 	cmnvs	r4, r4, asr #2
     990:	6d61535f 	stclvs	3, cr5, [r1, #-380]!	; 0xfffffe84
     994:	73656c70 	cmnvc	r5, #112, 24	; 0x7000
     998:	5f007645 	svcpl	0x00007645
     99c:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     9a0:	646e6152 	strbtvs	r6, [lr], #-338	; 0xfffffeae
     9a4:	475f6d6f 	ldrbmi	r6, [pc, -pc, ror #26]
     9a8:	72656e65 	rsbvc	r6, r5, #1616	; 0x650
     9ac:	726f7461 	rsbvc	r7, pc, #1627389952	; 0x61000000
     9b0:	74654739 	strbtvc	r4, [r5], #-1849	; 0xfffff8c7
     9b4:	6f6c465f 	svcvs	0x006c465f
     9b8:	76457461 	strbvc	r7, [r5], -r1, ror #8
     9bc:	6d657200 	sfmvs	f7, 2, [r5, #-0]
     9c0:	646e6961 	strbtvs	r6, [lr], #-2401	; 0xfffff69f
     9c4:	75007265 	strvc	r7, [r0, #-613]	; 0xfffffd9b
     9c8:	33746e69 	cmncc	r4, #1680	; 0x690
     9cc:	00745f32 	rsbseq	r5, r4, r2, lsr pc
     9d0:	6c617645 	stclvs	6, cr7, [r1], #-276	; 0xfffffeec
     9d4:	7274535f 	rsbsvc	r5, r4, #2080374785	; 0x7c000001
     9d8:	5f676e69 	svcpl	0x00676e69
     9dc:	6d6d6f43 	stclvs	15, cr6, [sp, #-268]!	; 0xfffffef4
     9e0:	00646e61 	rsbeq	r6, r4, r1, ror #28
     9e4:	364e5a5f 			; <UNDEFINED> instruction: 0x364e5a5f
     9e8:	66667542 	strbtvs	r7, [r6], -r2, asr #10
     9ec:	43357265 	teqmi	r5, #1342177286	; 0x50000006
     9f0:	7261656c 	rsbvc	r6, r1, #108, 10	; 0x1b000000
     9f4:	64007645 	strvs	r7, [r0], #-1605	; 0xfffff9bb
     9f8:	5f617461 	svcpl	0x00617461
     9fc:	6e696f70 	mcrvs	15, 3, r6, cr9, cr0, {3}
     a00:	00726574 	rsbseq	r6, r2, r4, ror r5
     a04:	45445f54 	strbmi	r5, [r4, #-3924]	; 0xfffff0ac
     a08:	5f41544c 	svcpl	0x0041544c
     a0c:	004d554e 	subeq	r5, sp, lr, asr #10
     a10:	64616552 	strbtvs	r6, [r1], #-1362	; 0xfffffaae
     a14:	6c6e4f5f 	stclvs	15, cr4, [lr], #-380	; 0xfffffe84
     a18:	5a5f0079 	bpl	17c0c04 <__bss_end+0x17b48c4>
     a1c:	7542364e 	strbvc	r3, [r2, #-1614]	; 0xfffff9b2
     a20:	72656666 	rsbvc	r6, r5, #106954752	; 0x6600000
     a24:	65523332 	ldrbvs	r3, [r2, #-818]	; 0xfffffcce
     a28:	555f6461 	ldrbpl	r6, [pc, #-1121]	; 5cf <shift+0x5cf>
     a2c:	5f747261 	svcpl	0x00747261
     a30:	656e694c 	strbvs	r6, [lr, #-2380]!	; 0xfffff6b4
     a34:	6f6c425f 	svcvs	0x006c425f
     a38:	6e696b63 	vnmulvs.f64	d22, d9, d19
     a3c:	00694567 	rsbeq	r4, r9, r7, ror #10
     a40:	76657270 			; <UNDEFINED> instruction: 0x76657270
     a44:	73756f69 	cmnvc	r5, #420	; 0x1a4
     a48:	675f796c 	ldrbvs	r7, [pc, -ip, ror #18]
     a4c:	72656e65 	rsbvc	r6, r5, #1616	; 0x650
     a50:	64657461 	strbtvs	r7, [r5], #-1121	; 0xfffffb9f
     a54:	74696600 	strbtvc	r6, [r9], #-1536	; 0xfffffa00
     a58:	7373656e 	cmnvc	r3, #461373440	; 0x1b800000
     a5c:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     a60:	66754236 			; <UNDEFINED> instruction: 0x66754236
     a64:	37726566 	ldrbcc	r6, [r2, -r6, ror #10]!
     a68:	465f7349 	ldrbmi	r7, [pc], -r9, asr #6
     a6c:	456c6c75 	strbmi	r6, [ip, #-3189]!	; 0xfffff38b
     a70:	65640076 	strbvs	r0, [r4, #-118]!	; 0xffffff8a
     a74:	61766972 	cmnvs	r6, r2, ror r9
     a78:	65766974 	ldrbvs	r6, [r6, #-2420]!	; 0xfffff68c
     a7c:	6c61765f 	stclvs	6, cr7, [r1], #-380	; 0xfffffe84
     a80:	47006575 	smlsdxmi	r0, r5, r5, r6
     a84:	4d5f7465 	cfldrdmi	mvd7, [pc, #-404]	; 8f8 <shift+0x8f8>
     a88:	415f6d65 	cmpmi	pc, r5, ror #26
     a8c:	65726464 	ldrbvs	r6, [r2, #-1124]!	; 0xfffffb9c
     a90:	53007373 	movwpl	r7, #883	; 0x373
     a94:	006b7262 	rsbeq	r7, fp, r2, ror #4
     a98:	5f706d74 	svcpl	0x00706d74
     a9c:	00727473 	rsbseq	r7, r2, r3, ror r4
     aa0:	364e5a5f 			; <UNDEFINED> instruction: 0x364e5a5f
     aa4:	66667542 	strbtvs	r7, [r6], -r2, asr #10
     aa8:	49387265 	ldmdbmi	r8!, {r0, r2, r5, r6, r9, ip, sp, lr}
     aac:	6d455f73 	stclvs	15, cr5, [r5, #-460]	; 0xfffffe34
     ab0:	45797470 	ldrbmi	r7, [r9, #-1136]!	; 0xfffffb90
     ab4:	5a5f0076 	bpl	17c0c94 <__bss_end+0x17b4954>
     ab8:	6f4d354e 	svcvs	0x004d354e
     abc:	326c6564 	rsbcc	r6, ip, #100, 10	; 0x19000000
     ac0:	69725033 	ldmdbvs	r2!, {r0, r1, r4, r5, ip, lr}^
     ac4:	415f746e 	cmpmi	pc, lr, ror #8
     ac8:	6168706c 	cmnvs	r8, ip, rrx
     acc:	6572505f 	ldrbvs	r5, [r2, #-95]!	; 0xffffffa1
     ad0:	74636964 	strbtvc	r6, [r3], #-2404	; 0xfffff69c
     ad4:	736e6f69 	cmnvc	lr, #420	; 0x1a4
     ad8:	41007645 	tstmi	r0, r5, asr #12
     adc:	445f6464 	ldrbmi	r6, [pc], #-1124	; ae4 <shift+0xae4>
     ae0:	5f617461 	svcpl	0x00617461
     ae4:	706d6153 	rsbvc	r6, sp, r3, asr r1
     ae8:	5f00656c 	svcpl	0x0000656c
     aec:	4d354e5a 	ldcmi	14, cr4, [r5, #-360]!	; 0xfffffe98
     af0:	6c65646f 	cfstrdvs	mvd6, [r5], #-444	; 0xfffffe44
     af4:	65473531 	strbvs	r3, [r7, #-1329]	; 0xfffffacf
     af8:	505f656e 	subspl	r6, pc, lr, ror #10
     afc:	5f6c6f6f 	svcpl	0x006c6f6f
     b00:	74726150 	ldrbtvc	r6, [r2], #-336	; 0xfffffeb0
     b04:	50504579 	subspl	r4, r0, r9, ror r5
     b08:	69725439 	ldmdbvs	r2!, {r0, r3, r4, r5, sl, ip, lr}^
     b0c:	6d736562 	cfldr64vs	mvdx6, [r3, #-392]!	; 0xfffffe78
     b10:	62006e61 	andvs	r6, r0, #1552	; 0x610
     b14:	65666675 	strbvs	r6, [r6, #-1653]!	; 0xfffff98b
     b18:	69735f72 	ldmdbvs	r3!, {r1, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     b1c:	4d00657a 	cfstr32mi	mvfx6, [r0, #-488]	; 0xfffffe18
     b20:	74617475 	strbtvc	r7, [r1], #-1141	; 0xfffffb8b
     b24:	006e6f69 	rsbeq	r6, lr, r9, ror #30
     b28:	52505f54 	subspl	r5, r0, #84, 30	; 0x150
     b2c:	4e5f4445 	cdpmi	4, 5, cr4, cr15, cr5, {2}
     b30:	49004d55 	stmdbmi	r0, {r0, r2, r4, r6, r8, sl, fp, lr}
     b34:	6c61766e 	stclvs	6, cr7, [r1], #-440	; 0xfffffe48
     b38:	485f6469 	ldmdami	pc, {r0, r3, r5, r6, sl, sp, lr}^	; <UNPREDICTABLE>
     b3c:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     b40:	756f0065 	strbvc	r0, [pc, #-101]!	; ae3 <shift+0xae3>
     b44:	75625f74 	strbvc	r5, [r2, #-3956]!	; 0xfffff08c
     b48:	72656666 	rsbvc	r6, r5, #106954752	; 0x6600000
     b4c:	6e696d00 	cdpvs	13, 6, cr6, cr9, cr0, {0}
     b50:	7261705f 	rsbvc	r7, r1, #95	; 0x5f
     b54:	74656d61 	strbtvc	r6, [r5], #-3425	; 0xfffff29f
     b58:	765f7265 	ldrbvc	r7, [pc], -r5, ror #4
     b5c:	65756c61 	ldrbvs	r6, [r5, #-3169]!	; 0xfffff39f
     b60:	6d656d00 	stclvs	13, cr6, [r5, #-0]
     b64:	6464615f 	strbtvs	r6, [r4], #-351	; 0xfffffea1
     b68:	73736572 	cmnvc	r3, #478150656	; 0x1c800000
     b6c:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     b70:	646f4d35 	strbtvs	r4, [pc], #-3381	; b78 <shift+0xb78>
     b74:	30316c65 	eorscc	r6, r1, r5, ror #24
     b78:	5f746553 	svcpl	0x00746553
     b7c:	66667542 	strbtvs	r7, [r6], -r2, asr #10
     b80:	50457265 	subpl	r7, r5, r5, ror #4
     b84:	66754236 			; <UNDEFINED> instruction: 0x66754236
     b88:	00726566 	rsbseq	r6, r2, r6, ror #10
     b8c:	364e5a5f 			; <UNDEFINED> instruction: 0x364e5a5f
     b90:	66667542 	strbtvs	r7, [r6], -r2, asr #10
     b94:	34437265 	strbcc	r7, [r3], #-613	; 0xfffffd9b
     b98:	6d006a45 	vstrvs	s12, [r0, #-276]	; 0xfffffeec
     b9c:	705f7861 	subsvc	r7, pc, r1, ror #16
     ba0:	6d617261 	sfmvs	f7, 2, [r1, #-388]!	; 0xfffffe7c
     ba4:	72657465 	rsbvc	r7, r5, #1694498816	; 0x65000000
     ba8:	6c61765f 	stclvs	6, cr7, [r1], #-380	; 0xfffffe84
     bac:	74006575 	strvc	r6, [r0], #-1397	; 0xfffffa8b
     bb0:	6572705f 	ldrbvs	r7, [r2, #-95]!	; 0xffffffa1
     bb4:	61520064 	cmpvs	r2, r4, rrx
     bb8:	6d6f646e 	cfstrdvs	mvd6, [pc, #-440]!	; a08 <shift+0xa08>
     bbc:	6e65475f 	mcrvs	7, 3, r4, cr5, cr15, {2}
     bc0:	74617265 	strbtvc	r7, [r1], #-613	; 0xfffffd9b
     bc4:	2f00726f 	svccs	0x0000726f
     bc8:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
     bcc:	6572742f 	ldrbvs	r7, [r2, #-1071]!	; 0xfffffbd1
     bd0:	2f6c6966 	svccs	0x006c6966
     bd4:	2f6d6573 	svccs	0x006d6573
     bd8:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
     bdc:	2f736563 	svccs	0x00736563
     be0:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
     be4:	63617073 	cmnvs	r1, #115	; 0x73
     be8:	6f6d2f65 	svcvs	0x006d2f65
     bec:	5f6c6564 	svcpl	0x006c6564
     bf0:	6b736174 	blvs	1cd91c8 <__bss_end+0x1ccce88>
     bf4:	69616d2f 	stmdbvs	r1!, {r0, r1, r2, r3, r5, r8, sl, fp, sp, lr}^
     bf8:	70632e6e 	rsbvc	r2, r3, lr, ror #28
     bfc:	5f740070 	svcpl	0x00740070
     c00:	746c6564 	strbtvc	r6, [ip], #-1380	; 0xfffffa9c
     c04:	72570061 	subsvc	r0, r7, #97	; 0x61
     c08:	5f657469 	svcpl	0x00657469
     c0c:	796c6e4f 	stmdbvc	ip!, {r0, r1, r2, r3, r6, r9, sl, fp, sp, lr}^
     c10:	65706f00 	ldrbvs	r6, [r0, #-3840]!	; 0xfffff100
     c14:	6f746172 	svcvs	0x00746172
     c18:	656e2072 	strbvs	r2, [lr, #-114]!	; 0xffffff8e
     c1c:	65680077 	strbvs	r0, [r8, #-119]!	; 0xffffff89
     c20:	5f6f6c6c 	svcpl	0x006f6c6c
     c24:	74726175 	ldrbtvc	r6, [r2], #-373	; 0xfffffe8b
     c28:	726f775f 	rsbvc	r7, pc, #24903680	; 0x17c0000
     c2c:	4900646c 	stmdbmi	r0, {r2, r3, r5, r6, sl, sp, lr}
     c30:	6d455f73 	stclvs	15, cr5, [r5, #-460]	; 0xfffffe34
     c34:	00797470 	rsbseq	r7, r9, r0, ror r4
     c38:	445f7349 	ldrbmi	r7, [pc], #-841	; c40 <shift+0xc40>
     c3c:	5f617461 	svcpl	0x00617461
     c40:	646e6957 	strbtvs	r6, [lr], #-2391	; 0xfffff6a9
     c44:	465f776f 	ldrbmi	r7, [pc], -pc, ror #14
     c48:	006c6c75 	rsbeq	r6, ip, r5, ror ip
     c4c:	6c6c616d 	stfvse	f6, [ip], #-436	; 0xfffffe4c
     c50:	7000636f 	andvc	r6, r0, pc, ror #6
     c54:	6d617261 	sfmvs	f7, 2, [r1, #-388]!	; 0xfffffe7c
     c58:	72657465 	rsbvc	r7, r5, #1694498816	; 0x65000000
     c5c:	5f6f745f 	svcpl	0x006f745f
     c60:	6174756d 	cmnvs	r4, sp, ror #10
     c64:	69006574 	stmdbvs	r0, {r2, r4, r5, r6, r8, sl, sp, lr}
     c68:	7865646e 	stmdavc	r5!, {r1, r2, r3, r5, r6, sl, sp, lr}^
     c6c:	72617000 	rsbvc	r7, r1, #0
     c70:	735f7974 	cmpvc	pc, #116, 18	; 0x1d0000
     c74:	00706f74 	rsbseq	r6, r0, r4, ror pc
     c78:	5f77656e 	svcpl	0x0077656e
     c7c:	62697274 	rsbvs	r7, r9, #116, 4	; 0x40000007
     c80:	616d7365 	cmnvs	sp, r5, ror #6
     c84:	6874006e 	ldmdavs	r4!, {r1, r2, r3, r5, r6}^
     c88:	6e007369 	cdpvs	3, 0, cr7, cr0, cr9, {3}
     c8c:	655f746f 	ldrbvs	r7, [pc, #-1135]	; 825 <shift+0x825>
     c90:	67756f6e 	ldrbvs	r6, [r5, -lr, ror #30]!
     c94:	61645f68 	cmnvs	r4, r8, ror #30
     c98:	72006174 	andvc	r6, r0, #116, 2
     c9c:	7261705f 	rsbvc	r7, r1, #95	; 0x5f
     ca0:	00746e65 	rsbseq	r6, r4, r5, ror #28
     ca4:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; bf0 <shift+0xbf0>
     ca8:	72742f65 	rsbsvc	r2, r4, #404	; 0x194
     cac:	6c696665 	stclvs	6, cr6, [r9], #-404	; 0xfffffe6c
     cb0:	6d65732f 	stclvs	3, cr7, [r5, #-188]!	; 0xffffff44
     cb4:	756f732f 	strbvc	r7, [pc, #-815]!	; 98d <shift+0x98d>
     cb8:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
     cbc:	6573752f 	ldrbvs	r7, [r3, #-1327]!	; 0xfffffad1
     cc0:	61707372 	cmnvs	r0, r2, ror r3
     cc4:	4d2f6563 	cfstr32mi	mvfx6, [pc, #-396]!	; b40 <shift+0xb40>
     cc8:	6c65646f 	cfstrdvs	mvd6, [r5], #-444	; 0xfffffe44
     ccc:	646f4d2f 	strbtvs	r4, [pc], #-3375	; cd4 <shift+0xcd4>
     cd0:	632e6c65 			; <UNDEFINED> instruction: 0x632e6c65
     cd4:	63007070 	movwvs	r7, #112	; 0x70
     cd8:	73736f72 	cmnvc	r3, #456	; 0x1c8
     cdc:	756f625f 	strbvc	r6, [pc, #-607]!	; a85 <shift+0xa85>
     ce0:	7261646e 	rsbvc	r6, r1, #1845493760	; 0x6e000000
     ce4:	65740079 	ldrbvs	r0, [r4, #-121]!	; 0xffffff87
     ce8:	665f706d 	ldrbvs	r7, [pc], -sp, rrx
     cec:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
     cf0:	6675625f 			; <UNDEFINED> instruction: 0x6675625f
     cf4:	00726566 	rsbseq	r6, r2, r6, ror #10
     cf8:	656d6974 	strbvs	r6, [sp, #-2420]!	; 0xfffff68c
     cfc:	6968735f 	stmdbvs	r8!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, sp, lr}^
     d00:	62007466 	andvs	r7, r0, #1711276032	; 0x66000000
     d04:	00327266 	eorseq	r7, r2, r6, ror #4
     d08:	64657270 	strbtvs	r7, [r5], #-624	; 0xfffffd90
     d0c:	69746369 	ldmdbvs	r4!, {r0, r3, r5, r6, r8, r9, sp, lr}^
     d10:	79006e6f 	stmdbvc	r0, {r0, r1, r2, r3, r5, r6, r9, sl, fp, sp, lr}
     d14:	6572705f 	ldrbvs	r7, [r2, #-95]!	; 0xffffffa1
     d18:	74636964 	strbtvc	r6, [r3], #-2404	; 0xfffff69c
     d1c:	6e006465 	cdpvs	4, 0, cr6, cr0, cr5, {3}
     d20:	705f7765 	subsvc	r7, pc, r5, ror #14
     d24:	635f706f 	cmpvs	pc, #111	; 0x6f
     d28:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
     d2c:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     d30:	646f4d35 	strbtvs	r4, [pc], #-3381	; d38 <shift+0xd38>
     d34:	32436c65 	subcc	r6, r3, #25856	; 0x6500
     d38:	69696945 	stmdbvs	r9!, {r0, r2, r6, r8, fp, sp, lr}^
     d3c:	36506969 	ldrbcc	r6, [r0], -r9, ror #18
     d40:	66667542 	strbtvs	r7, [r6], -r2, asr #10
     d44:	70007265 	andvc	r7, r0, r5, ror #4
     d48:	6d617261 	sfmvs	f7, 2, [r1, #-388]!	; 0xfffffe7c
     d4c:	656c0073 	strbvs	r0, [ip, #-115]!	; 0xffffff8d
     d50:	705f7466 	subsvc	r7, pc, r6, ror #8
     d54:	6e657261 	cdpvs	2, 6, cr7, cr5, cr1, {3}
     d58:	69640074 	stmdbvs	r4!, {r2, r4, r5, r6}^
     d5c:	6c006666 	stcvs	6, cr6, [r0], {102}	; 0x66
     d60:	7261705f 	rsbvc	r7, r1, #95	; 0x5f
     d64:	00746e65 	rsbseq	r6, r4, r5, ror #28
     d68:	706d6574 	rsbvc	r6, sp, r4, ror r5
     d6c:	6675625f 			; <UNDEFINED> instruction: 0x6675625f
     d70:	00726566 	rsbseq	r6, r2, r6, ror #10
     d74:	64657270 	strbtvs	r7, [r5], #-624	; 0xfffffd90
     d78:	65746369 	ldrbvs	r6, [r4, #-873]!	; 0xfffffc97
     d7c:	61765f64 	cmnvs	r6, r4, ror #30
     d80:	0065756c 	rsbeq	r7, r5, ip, ror #10
     d84:	6d365a5f 	vldmdbvs	r6!, {s10-s104}
     d88:	6f6c6c61 	svcvs	0x006c6c61
     d8c:	6c006a63 			; <UNDEFINED> instruction: 0x6c006a63
     d90:	00746665 	rsbseq	r6, r4, r5, ror #12
     d94:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; ce0 <shift+0xce0>
     d98:	72742f65 	rsbsvc	r2, r4, #404	; 0x194
     d9c:	6c696665 	stclvs	6, cr6, [r9], #-404	; 0xfffffe6c
     da0:	6d65732f 	stclvs	3, cr7, [r5, #-188]!	; 0xffffff44
     da4:	756f732f 	strbvc	r7, [pc, #-815]!	; a7d <shift+0xa7d>
     da8:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
     dac:	6573752f 	ldrbvs	r7, [r3, #-1327]!	; 0xfffffad1
     db0:	61707372 	cmnvs	r0, r2, ror r3
     db4:	4d2f6563 	cfstr32mi	mvfx6, [pc, #-396]!	; c30 <shift+0xc30>
     db8:	6c65646f 	cfstrdvs	mvd6, [r5], #-444	; 0xfffffe44
     dbc:	726f532f 	rsbvc	r5, pc, #-1140850688	; 0xbc000000
     dc0:	70632e74 	rsbvc	r2, r3, r4, ror lr
     dc4:	5a5f0070 	bpl	17c0f8c <__bss_end+0x17b4c4c>
     dc8:	6f533431 	svcvs	0x00533431
     dcc:	545f7472 	ldrbpl	r7, [pc], #-1138	; dd4 <shift+0xdd4>
     dd0:	65626972 	strbvs	r6, [r2, #-2418]!	; 0xfffff68e
     dd4:	6e616d73 	mcrvs	13, 3, r6, cr1, cr3, {3}
     dd8:	54395050 	ldrtpl	r5, [r9], #-80	; 0xffffffb0
     ddc:	65626972 	strbvs	r6, [r2, #-2418]!	; 0xfffff68e
     de0:	6e616d73 	mcrvs	13, 3, r6, cr1, cr3, {3}
     de4:	6f730069 	svcvs	0x00730069
     de8:	72007472 	andvc	r7, r0, #1912602624	; 0x72000000
     dec:	74686769 	strbtvc	r6, [r8], #-1897	; 0xfffff897
     df0:	6c707300 	ldclvs	3, cr7, [r0], #-0
     df4:	53007469 	movwpl	r7, #1129	; 0x469
     df8:	5f74726f 	svcpl	0x0074726f
     dfc:	62697254 	rsbvs	r7, r9, #84, 4	; 0x40000005
     e00:	616d7365 	cmnvs	sp, r5, ror #6
     e04:	5a5f006e 	bpl	17c0fc4 <__bss_end+0x17b4c84>
     e08:	726f7334 	rsbvc	r7, pc, #52, 6	; 0xd0000000
     e0c:	39505074 	ldmdbcc	r0, {r2, r4, r5, r6, ip, lr}^
     e10:	62697254 	rsbvs	r7, r9, #84, 4	; 0x40000005
     e14:	616d7365 	cmnvs	sp, r5, ror #6
     e18:	0069696e 	rsbeq	r6, r9, lr, ror #18
     e1c:	6f766970 	svcvs	0x00766970
     e20:	5a5f0074 	bpl	17c0ff8 <__bss_end+0x17b4cb8>
     e24:	6c707335 	ldclvs	3, cr7, [r0], #-212	; 0xffffff2c
     e28:	50507469 	subspl	r7, r0, r9, ror #8
     e2c:	69725439 	ldmdbvs	r2!, {r0, r3, r4, r5, sl, ip, lr}^
     e30:	6d736562 	cfldr64vs	mvdx6, [r3, #-392]!	; 0xfffffe78
     e34:	69696e61 	stmdbvs	r9!, {r0, r5, r6, r9, sl, fp, sp, lr}^
     e38:	735f5f00 	cmpvc	pc, #0, 30
     e3c:	69746174 	ldmdbvs	r4!, {r2, r4, r5, r6, r8, sp, lr}^
     e40:	6e695f63 	cdpvs	15, 6, cr5, cr9, cr3, {3}
     e44:	61697469 	cmnvs	r9, r9, ror #8
     e48:	617a696c 	cmnvs	sl, ip, ror #18
     e4c:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     e50:	646e615f 	strbtvs	r6, [lr], #-351	; 0xfffffea1
     e54:	7365645f 	cmnvc	r5, #1593835520	; 0x5f000000
     e58:	63757274 	cmnvs	r5, #116, 4	; 0x40000007
     e5c:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     e60:	5f00305f 	svcpl	0x0000305f
     e64:	32314e5a 	eorscc	r4, r1, #1440	; 0x5a0
     e68:	70616548 	rsbvc	r6, r1, r8, asr #10
     e6c:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     e70:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     e74:	76453243 	strbvc	r3, [r5], -r3, asr #4
     e78:	6f682f00 	svcvs	0x00682f00
     e7c:	742f656d 	strtvc	r6, [pc], #-1389	; e84 <shift+0xe84>
     e80:	69666572 	stmdbvs	r6!, {r1, r4, r5, r6, r8, sl, sp, lr}^
     e84:	65732f6c 	ldrbvs	r2, [r3, #-3948]!	; 0xfffff094
     e88:	6f732f6d 	svcvs	0x00732f6d
     e8c:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
     e90:	75622f73 	strbvc	r2, [r2, #-3955]!	; 0xfffff08d
     e94:	00646c69 	rsbeq	r6, r4, r9, ror #24
     e98:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; de4 <shift+0xde4>
     e9c:	72742f65 	rsbsvc	r2, r4, #404	; 0x194
     ea0:	6c696665 	stclvs	6, cr6, [r9], #-404	; 0xfffffe6c
     ea4:	6d65732f 	stclvs	3, cr7, [r5, #-188]!	; 0xffffff44
     ea8:	756f732f 	strbvc	r7, [pc, #-815]!	; b81 <shift+0xb81>
     eac:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
     eb0:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
     eb4:	2f62696c 	svccs	0x0062696c
     eb8:	2f637273 	svccs	0x00637273
     ebc:	70616548 	rsbvc	r6, r1, r8, asr #10
     ec0:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     ec4:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     ec8:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
     ecc:	695f5f00 	ldmdbvs	pc, {r8, r9, sl, fp, ip, lr}^	; <UNPREDICTABLE>
     ed0:	6974696e 	ldmdbvs	r4!, {r1, r2, r3, r5, r6, r8, fp, sp, lr}^
     ed4:	7a696c61 	bvc	1a5c060 <__bss_end+0x1a4fd20>
     ed8:	00705f65 	rsbseq	r5, r0, r5, ror #30
     edc:	20554e47 	subscs	r4, r5, r7, asr #28
     ee0:	312b2b43 			; <UNDEFINED> instruction: 0x312b2b43
     ee4:	30312034 	eorscc	r2, r1, r4, lsr r0
     ee8:	312e332e 			; <UNDEFINED> instruction: 0x312e332e
     eec:	32303220 	eorscc	r3, r0, #32, 4
     ef0:	32363031 	eorscc	r3, r6, #49	; 0x31
     ef4:	72282031 	eorvc	r2, r8, #49	; 0x31
     ef8:	61656c65 	cmnvs	r5, r5, ror #24
     efc:	20296573 	eorcs	r6, r9, r3, ror r5
     f00:	6c666d2d 	stclvs	13, cr6, [r6], #-180	; 0xffffff4c
     f04:	2d74616f 	ldfcse	f6, [r4, #-444]!	; 0xfffffe44
     f08:	3d696261 	sfmcc	f6, 2, [r9, #-388]!	; 0xfffffe7c
     f0c:	64726168 	ldrbtvs	r6, [r2], #-360	; 0xfffffe98
     f10:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
     f14:	763d7570 			; <UNDEFINED> instruction: 0x763d7570
     f18:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
     f1c:	6f6c666d 	svcvs	0x006c666d
     f20:	612d7461 			; <UNDEFINED> instruction: 0x612d7461
     f24:	683d6962 	ldmdavs	sp!, {r1, r5, r6, r8, fp, sp, lr}
     f28:	20647261 	rsbcs	r7, r4, r1, ror #4
     f2c:	70666d2d 	rsbvc	r6, r6, sp, lsr #26
     f30:	66763d75 			; <UNDEFINED> instruction: 0x66763d75
     f34:	6d2d2070 	stcvs	0, cr2, [sp, #-448]!	; 0xfffffe40
     f38:	656e7574 	strbvs	r7, [lr, #-1396]!	; 0xfffffa8c
     f3c:	6d72613d 	ldfvse	f6, [r2, #-244]!	; 0xffffff0c
     f40:	36373131 			; <UNDEFINED> instruction: 0x36373131
     f44:	2d667a6a 	vstmdbcs	r6!, {s15-s120}
     f48:	6d2d2073 	stcvs	0, cr2, [sp, #-460]!	; 0xfffffe34
     f4c:	206d7261 	rsbcs	r7, sp, r1, ror #4
     f50:	72616d2d 	rsbvc	r6, r1, #2880	; 0xb40
     f54:	613d6863 	teqvs	sp, r3, ror #16
     f58:	36766d72 			; <UNDEFINED> instruction: 0x36766d72
     f5c:	662b6b7a 			; <UNDEFINED> instruction: 0x662b6b7a
     f60:	672d2070 			; <UNDEFINED> instruction: 0x672d2070
     f64:	20672d20 	rsbcs	r2, r7, r0, lsr #26
     f68:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
     f6c:	2d20304f 	stccs	0, cr3, [r0, #-316]!	; 0xfffffec4
     f70:	2d20304f 	stccs	0, cr3, [r0, #-316]!	; 0xfffffec4
     f74:	2d6f6e66 	stclcs	14, cr6, [pc, #-408]!	; de4 <shift+0xde4>
     f78:	65637865 	strbvs	r7, [r3, #-2149]!	; 0xfffff79b
     f7c:	6f697470 	svcvs	0x00697470
     f80:	2d20736e 	stccs	3, cr7, [r0, #-440]!	; 0xfffffe48
     f84:	2d6f6e66 	stclcs	14, cr6, [pc, #-408]!	; df4 <shift+0xdf4>
     f88:	69747472 	ldmdbvs	r4!, {r1, r4, r5, r6, sl, ip, sp, lr}^
     f8c:	6e647200 	cdpvs	2, 6, cr7, cr4, cr0, {0}
     f90:	5f006d75 	svcpl	0x00006d75
     f94:	6972705f 	ldmdbvs	r2!, {r0, r1, r2, r3, r4, r6, ip, sp, lr}^
     f98:	7469726f 	strbtvc	r7, [r9], #-623	; 0xfffffd91
     f9c:	475f0079 			; <UNDEFINED> instruction: 0x475f0079
     fa0:	41424f4c 	cmpmi	r2, ip, asr #30
     fa4:	735f5f4c 	cmpvc	pc, #76, 30	; 0x130
     fa8:	495f6275 	ldmdbmi	pc, {r0, r2, r4, r5, r6, r9, sp, lr}^	; <UNPREDICTABLE>
     fac:	6e00685f 	mcrvs	8, 0, r6, cr0, cr15, {2}
     fb0:	72656d75 	rsbvc	r6, r5, #7488	; 0x1d40
     fb4:	6172006f 	cmnvs	r2, pc, rrx
     fb8:	665f646e 	ldrbvs	r6, [pc], -lr, ror #8
     fbc:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
     fc0:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     fc4:	61523631 	cmpvs	r2, r1, lsr r6
     fc8:	6d6f646e 	cfstrdvs	mvd6, [pc, #-440]!	; e18 <shift+0xe18>
     fcc:	6e65475f 	mcrvs	7, 3, r4, cr5, cr15, {2}
     fd0:	74617265 	strbtvc	r7, [r1], #-613	; 0xfffffd9b
     fd4:	3243726f 	subcc	r7, r3, #-268435450	; 0xf0000006
     fd8:	69696945 	stmdbvs	r9!, {r0, r2, r6, r8, fp, sp, lr}^
     fdc:	72006969 	andvc	r6, r0, #1720320	; 0x1a4000
     fe0:	00646e61 	rsbeq	r6, r4, r1, ror #28
     fe4:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; f30 <shift+0xf30>
     fe8:	72742f65 	rsbsvc	r2, r4, #404	; 0x194
     fec:	6c696665 	stclvs	6, cr6, [r9], #-404	; 0xfffffe6c
     ff0:	6d65732f 	stclvs	3, cr7, [r5, #-188]!	; 0xffffff44
     ff4:	756f732f 	strbvc	r7, [pc, #-815]!	; ccd <shift+0xccd>
     ff8:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
     ffc:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
    1000:	2f62696c 	svccs	0x0062696c
    1004:	2f637273 	svccs	0x00637273
    1008:	646e6152 	strbtvs	r6, [lr], #-338	; 0xfffffeae
    100c:	632e6d6f 			; <UNDEFINED> instruction: 0x632e6d6f
    1010:	65007070 	strvs	r7, [r0, #-112]	; 0xffffff90
    1014:	63657078 	cmnvs	r5, #120	; 0x78
    1018:	5f646574 	svcpl	0x00646574
    101c:	65707974 	ldrbvs	r7, [r0, #-2420]!	; 0xfffff68c
    1020:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
    1024:	66754236 			; <UNDEFINED> instruction: 0x66754236
    1028:	43726566 	cmnmi	r2, #427819008	; 0x19800000
    102c:	006a4532 	rsbeq	r4, sl, r2, lsr r5
    1030:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
    1034:	756f665f 	strbvc	r6, [pc, #-1631]!	; 9dd <shift+0x9dd>
    1038:	6600646e 	strvs	r6, [r0], -lr, ror #8
    103c:	5f656c69 	svcpl	0x00656c69
    1040:	63736564 	cmnvs	r3, #100, 10	; 0x19000000
    1044:	74756f00 	ldrbtvc	r6, [r5], #-3840	; 0xfffff100
    1048:	6675625f 			; <UNDEFINED> instruction: 0x6675625f
    104c:	5f726566 	svcpl	0x00726566
    1050:	6c6c7566 	cfstr64vs	mvdx7, [ip], #-408	; 0xfffffe68
    1054:	6f682f00 	svcvs	0x00682f00
    1058:	742f656d 	strtvc	r6, [pc], #-1389	; 1060 <shift+0x1060>
    105c:	69666572 	stmdbvs	r6!, {r1, r4, r5, r6, r8, sl, sp, lr}^
    1060:	65732f6c 	ldrbvs	r2, [r3, #-3948]!	; 0xfffff094
    1064:	6f732f6d 	svcvs	0x00732f6d
    1068:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
    106c:	74732f73 	ldrbtvc	r2, [r3], #-3955	; 0xfffff08d
    1070:	62696c64 	rsbvs	r6, r9, #100, 24	; 0x6400
    1074:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
    1078:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
    107c:	66667562 	strbtvs	r7, [r6], -r2, ror #10
    1080:	632e7265 			; <UNDEFINED> instruction: 0x632e7265
    1084:	54007070 	strpl	r7, [r0], #-112	; 0xffffff90
    1088:	5f6b6369 	svcpl	0x006b6369
    108c:	6e756f43 	cdpvs	15, 7, cr6, cr5, cr3, {2}
    1090:	704f0074 	subvc	r0, pc, r4, ror r0	; <UNPREDICTABLE>
    1094:	5f006e65 	svcpl	0x00006e65
    1098:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
    109c:	6f725043 	svcvs	0x00725043
    10a0:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    10a4:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
    10a8:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
    10ac:	6c423132 	stfvse	f3, [r2], {50}	; 0x32
    10b0:	5f6b636f 	svcpl	0x006b636f
    10b4:	72727543 	rsbsvc	r7, r2, #281018368	; 0x10c00000
    10b8:	5f746e65 	svcpl	0x00746e65
    10bc:	636f7250 	cmnvs	pc, #80, 4
    10c0:	45737365 	ldrbmi	r7, [r3, #-869]!	; 0xfffffc9b
    10c4:	6c630076 	stclvs	0, cr0, [r3], #-472	; 0xfffffe28
    10c8:	0065736f 	rsbeq	r7, r5, pc, ror #6
    10cc:	76657270 			; <UNDEFINED> instruction: 0x76657270
    10d0:	74655300 	strbtvc	r5, [r5], #-768	; 0xfffffd00
    10d4:	6c65525f 	sfmvs	f5, 2, [r5], #-380	; 0xfffffe84
    10d8:	76697461 	strbtvc	r7, [r9], -r1, ror #8
    10dc:	6e550065 	cdpvs	0, 5, cr0, cr5, cr5, {3}
    10e0:	5f70616d 	svcpl	0x0070616d
    10e4:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
    10e8:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
    10ec:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
    10f0:	74657200 	strbtvc	r7, [r5], #-512	; 0xfffffe00
    10f4:	006c6176 	rsbeq	r6, ip, r6, ror r1
    10f8:	7275636e 	rsbsvc	r6, r5, #-1207959551	; 0xb8000001
    10fc:	6c614d00 	stclvs	13, cr4, [r1], #-0
    1100:	00636f6c 	rsbeq	r6, r3, ip, ror #30
    1104:	6f72506d 	svcvs	0x0072506d
    1108:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    110c:	73694c5f 	cmnvc	r9, #24320	; 0x5f00
    1110:	65485f74 	strbvs	r5, [r8, #-3956]	; 0xfffff08c
    1114:	70006461 	andvc	r6, r0, r1, ror #8
    1118:	00657069 	rsbeq	r7, r5, r9, rrx
    111c:	4b4e5a5f 	blmi	1397aa0 <__bss_end+0x138b760>
    1120:	50433631 	subpl	r3, r3, r1, lsr r6
    1124:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    1128:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; f64 <shift+0xf64>
    112c:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
    1130:	39317265 	ldmdbcc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
    1134:	5f746547 	svcpl	0x00746547
    1138:	72727543 	rsbsvc	r7, r2, #281018368	; 0x10c00000
    113c:	5f746e65 	svcpl	0x00746e65
    1140:	636f7250 	cmnvs	pc, #80, 4
    1144:	45737365 	ldrbmi	r7, [r3, #-869]!	; 0xfffffc9b
    1148:	656e0076 	strbvs	r0, [lr, #-118]!	; 0xffffff8a
    114c:	47007478 	smlsdxmi	r0, r8, r4, r7
    1150:	505f7465 	subspl	r7, pc, r5, ror #8
    1154:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    1158:	425f7373 	subsmi	r7, pc, #-872415231	; 0xcc000001
    115c:	49505f79 	ldmdbmi	r0, {r0, r3, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    1160:	5a5f0044 	bpl	17c1278 <__bss_end+0x17b4f38>
    1164:	63733131 	cmnvs	r3, #1073741836	; 0x4000000c
    1168:	5f646568 	svcpl	0x00646568
    116c:	6c656979 			; <UNDEFINED> instruction: 0x6c656979
    1170:	4e007664 	cfmadd32mi	mvax3, mvfx7, mvfx0, mvfx4
    1174:	5f495753 	svcpl	0x00495753
    1178:	636f7250 	cmnvs	pc, #80, 4
    117c:	5f737365 	svcpl	0x00737365
    1180:	76726553 			; <UNDEFINED> instruction: 0x76726553
    1184:	00656369 	rsbeq	r6, r5, r9, ror #6
    1188:	64616552 	strbtvs	r6, [r1], #-1362	; 0xfffffaae
    118c:	74634100 	strbtvc	r4, [r3], #-256	; 0xffffff00
    1190:	5f657669 	svcpl	0x00657669
    1194:	636f7250 	cmnvs	pc, #80, 4
    1198:	5f737365 	svcpl	0x00737365
    119c:	6e756f43 	cdpvs	15, 7, cr6, cr5, cr3, {2}
    11a0:	72430074 	subvc	r0, r3, #116	; 0x74
    11a4:	65746165 	ldrbvs	r6, [r4, #-357]!	; 0xfffffe9b
    11a8:	6f72505f 	svcvs	0x0072505f
    11ac:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    11b0:	315a5f00 	cmpcc	sl, r0, lsl #30
    11b4:	74657337 	strbtvc	r7, [r5], #-823	; 0xfffffcc9
    11b8:	7361745f 	cmnvc	r1, #1593835520	; 0x5f000000
    11bc:	65645f6b 	strbvs	r5, [r4, #-3947]!	; 0xfffff095
    11c0:	696c6461 	stmdbvs	ip!, {r0, r5, r6, sl, sp, lr}^
    11c4:	006a656e 	rsbeq	r6, sl, lr, ror #10
    11c8:	74696177 	strbtvc	r6, [r9], #-375	; 0xfffffe89
    11cc:	61747300 	cmnvs	r4, r0, lsl #6
    11d0:	5f006574 	svcpl	0x00006574
    11d4:	6f6e365a 	svcvs	0x006e365a
    11d8:	79666974 	stmdbvc	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
    11dc:	47006a6a 	strmi	r6, [r0, -sl, ror #20]
    11e0:	535f7465 	cmppl	pc, #1694498816	; 0x65000000
    11e4:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
    11e8:	72656c75 	rsbvc	r6, r5, #29952	; 0x7500
    11ec:	666e495f 			; <UNDEFINED> instruction: 0x666e495f
    11f0:	5043006f 	subpl	r0, r3, pc, rrx
    11f4:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    11f8:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 1034 <shift+0x1034>
    11fc:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
    1200:	5f007265 	svcpl	0x00007265
    1204:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
    1208:	6f725043 	svcvs	0x00725043
    120c:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    1210:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
    1214:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
    1218:	65473831 	strbvs	r3, [r7, #-2097]	; 0xfffff7cf
    121c:	63535f74 	cmpvs	r3, #116, 30	; 0x1d0
    1220:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
    1224:	5f72656c 	svcpl	0x0072656c
    1228:	6f666e49 	svcvs	0x00666e49
    122c:	4e303245 	cdpmi	2, 3, cr3, cr0, cr5, {2}
    1230:	5f746547 	svcpl	0x00746547
    1234:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
    1238:	6e495f64 	cdpvs	15, 4, cr5, cr9, cr4, {3}
    123c:	545f6f66 	ldrbpl	r6, [pc], #-3942	; 1244 <shift+0x1244>
    1240:	50657079 	rsbpl	r7, r5, r9, ror r0
    1244:	5a5f0076 	bpl	17c1424 <__bss_end+0x17b50e4>
    1248:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
    124c:	636f7250 	cmnvs	pc, #80, 4
    1250:	5f737365 	svcpl	0x00737365
    1254:	616e614d 	cmnvs	lr, sp, asr #2
    1258:	32726567 	rsbscc	r6, r2, #432013312	; 0x19c00000
    125c:	6e614831 	mcrvs	8, 3, r4, cr1, cr1, {1}
    1260:	5f656c64 	svcpl	0x00656c64
    1264:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
    1268:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
    126c:	535f6d65 	cmppl	pc, #6464	; 0x1940
    1270:	32454957 	subcc	r4, r5, #1425408	; 0x15c000
    1274:	57534e33 	smmlarpl	r3, r3, lr, r4
    1278:	69465f49 	stmdbvs	r6, {r0, r3, r6, r8, r9, sl, fp, ip, lr}^
    127c:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
    1280:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
    1284:	7265535f 	rsbvc	r5, r5, #2080374785	; 0x7c000001
    1288:	65636976 	strbvs	r6, [r3, #-2422]!	; 0xfffff68a
    128c:	526a6a6a 	rsbpl	r6, sl, #434176	; 0x6a000
    1290:	53543131 	cmppl	r4, #1073741836	; 0x4000000c
    1294:	525f4957 	subspl	r4, pc, #1425408	; 0x15c000
    1298:	6c757365 	ldclvs	3, cr7, [r5], #-404	; 0xfffffe6c
    129c:	706f0074 	rsbvc	r0, pc, r4, ror r0	; <UNPREDICTABLE>
    12a0:	64656e65 	strbtvs	r6, [r5], #-3685	; 0xfffff19b
    12a4:	6c69665f 	stclvs	6, cr6, [r9], #-380	; 0xfffffe84
    12a8:	46007365 	strmi	r7, [r0], -r5, ror #6
    12ac:	006c6961 	rsbeq	r6, ip, r1, ror #18
    12b0:	55504354 	ldrbpl	r4, [r0, #-852]	; 0xfffffcac
    12b4:	6e6f435f 	mcrvs	3, 3, r4, cr15, cr15, {2}
    12b8:	74786574 	ldrbtvc	r6, [r8], #-1396	; 0xfffffa8c
    12bc:	61654400 	cmnvs	r5, r0, lsl #8
    12c0:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
    12c4:	78650065 	stmdavc	r5!, {r0, r2, r5, r6}^
    12c8:	6f637469 	svcvs	0x00637469
    12cc:	74006564 	strvc	r6, [r0], #-1380	; 0xfffffa9c
    12d0:	30726274 	rsbscc	r6, r2, r4, ror r2
    12d4:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
    12d8:	50433631 	subpl	r3, r3, r1, lsr r6
    12dc:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    12e0:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 111c <shift+0x111c>
    12e4:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
    12e8:	34317265 	ldrtcc	r7, [r1], #-613	; 0xfffffd9b
    12ec:	69746f4e 	ldmdbvs	r4!, {r1, r2, r3, r6, r8, r9, sl, fp, sp, lr}^
    12f0:	505f7966 	subspl	r7, pc, r6, ror #18
    12f4:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    12f8:	6a457373 	bvs	115e0cc <__bss_end+0x1151d8c>
    12fc:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
    1300:	4449505f 	strbmi	r5, [r9], #-95	; 0xffffffa1
    1304:	746f6e00 	strbtvc	r6, [pc], #-3584	; 130c <shift+0x130c>
    1308:	65696669 	strbvs	r6, [r9, #-1641]!	; 0xfffff997
    130c:	65645f64 	strbvs	r5, [r4, #-3940]!	; 0xfffff09c
    1310:	696c6461 	stmdbvs	ip!, {r0, r5, r6, sl, sp, lr}^
    1314:	5f00656e 	svcpl	0x0000656e
    1318:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
    131c:	6f725043 	svcvs	0x00725043
    1320:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    1324:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
    1328:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
    132c:	6e553831 	mrcvs	8, 2, r3, cr5, cr1, {1}
    1330:	5f70616d 	svcpl	0x0070616d
    1334:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
    1338:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
    133c:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
    1340:	5f006a45 	svcpl	0x00006a45
    1344:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
    1348:	6f725043 	svcvs	0x00725043
    134c:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    1350:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
    1354:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
    1358:	6f4e3431 	svcvs	0x004e3431
    135c:	79666974 	stmdbvc	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
    1360:	6f72505f 	svcvs	0x0072505f
    1364:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    1368:	32315045 	eorscc	r5, r1, #69	; 0x45
    136c:	73615454 	cmnvc	r1, #84, 8	; 0x54000000
    1370:	74535f6b 	ldrbvc	r5, [r3], #-3947	; 0xfffff095
    1374:	74637572 	strbtvc	r7, [r3], #-1394	; 0xfffffa8e
    1378:	68637300 	stmdavs	r3!, {r8, r9, ip, sp, lr}^
    137c:	795f6465 	ldmdbvc	pc, {r0, r2, r5, r6, sl, sp, lr}^	; <UNPREDICTABLE>
    1380:	646c6569 	strbtvs	r6, [ip], #-1385	; 0xfffffa97
    1384:	63697400 	cmnvs	r9, #0, 8
    1388:	6f635f6b 	svcvs	0x00635f6b
    138c:	5f746e75 	svcpl	0x00746e75
    1390:	75716572 	ldrbvc	r6, [r1, #-1394]!	; 0xfffffa8e
    1394:	64657269 	strbtvs	r7, [r5], #-617	; 0xfffffd97
    1398:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
    139c:	50433631 	subpl	r3, r3, r1, lsr r6
    13a0:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    13a4:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 11e0 <shift+0x11e0>
    13a8:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
    13ac:	32317265 	eorscc	r7, r1, #1342177286	; 0x50000006
    13b0:	466e7552 			; <UNDEFINED> instruction: 0x466e7552
    13b4:	74737269 	ldrbtvc	r7, [r3], #-617	; 0xfffffd97
    13b8:	6b736154 	blvs	1cd9910 <__bss_end+0x1ccd5d0>
    13bc:	5f007645 	svcpl	0x00007645
    13c0:	6734325a 			; <UNDEFINED> instruction: 0x6734325a
    13c4:	615f7465 	cmpvs	pc, r5, ror #8
    13c8:	76697463 	strbtvc	r7, [r9], -r3, ror #8
    13cc:	72705f65 	rsbsvc	r5, r0, #404	; 0x194
    13d0:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    13d4:	6f635f73 	svcvs	0x00635f73
    13d8:	76746e75 			; <UNDEFINED> instruction: 0x76746e75
    13dc:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
    13e0:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
    13e4:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
    13e8:	6f72505f 	svcvs	0x0072505f
    13ec:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    13f0:	70695000 	rsbvc	r5, r9, r0
    13f4:	69465f65 	stmdbvs	r6, {r0, r2, r5, r6, r8, r9, sl, fp, ip, lr}^
    13f8:	505f656c 	subspl	r6, pc, ip, ror #10
    13fc:	69666572 	stmdbvs	r6!, {r1, r4, r5, r6, r8, sl, sp, lr}^
    1400:	614d0078 	hvcvs	53256	; 0xd008
    1404:	69465f70 	stmdbvs	r6, {r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    1408:	545f656c 	ldrbpl	r6, [pc], #-1388	; 1410 <shift+0x1410>
    140c:	75435f6f 	strbvc	r5, [r3, #-3951]	; 0xfffff091
    1410:	6e657272 	mcrvs	2, 3, r7, cr5, cr2, {3}
    1414:	6c420074 	mcrrvs	0, 7, r0, r2, cr4
    1418:	5f6b636f 	svcpl	0x006b636f
    141c:	72727543 	rsbsvc	r7, r2, #281018368	; 0x10c00000
    1420:	5f746e65 	svcpl	0x00746e65
    1424:	636f7250 	cmnvs	pc, #80, 4
    1428:	00737365 	rsbseq	r7, r3, r5, ror #6
    142c:	5f746553 	svcpl	0x00746553
    1430:	61726150 	cmnvs	r2, r0, asr r1
    1434:	5f00736d 	svcpl	0x0000736d
    1438:	6734315a 			; <UNDEFINED> instruction: 0x6734315a
    143c:	745f7465 	ldrbvc	r7, [pc], #-1125	; 1444 <shift+0x1444>
    1440:	5f6b6369 	svcpl	0x006b6369
    1444:	6e756f63 	cdpvs	15, 7, cr6, cr5, cr3, {3}
    1448:	6c007674 	stcvs	6, cr7, [r0], {116}	; 0x74
    144c:	6369676f 	cmnvs	r9, #29097984	; 0x1bc0000
    1450:	625f6c61 	subsvs	r6, pc, #24832	; 0x6100
    1454:	6b616572 	blvs	185aa24 <__bss_end+0x184e6e4>
    1458:	6e614800 	cdpvs	8, 6, cr4, cr1, cr0, {0}
    145c:	5f656c64 	svcpl	0x00656c64
    1460:	636f7250 	cmnvs	pc, #80, 4
    1464:	5f737365 	svcpl	0x00737365
    1468:	00495753 	subeq	r5, r9, r3, asr r7
    146c:	65656c73 	strbvs	r6, [r5, #-3187]!	; 0xfffff38d
    1470:	63530070 	cmpvs	r3, #112	; 0x70
    1474:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
    1478:	455f656c 	ldrbmi	r6, [pc, #-1388]	; f14 <shift+0xf14>
    147c:	57004644 	strpl	r4, [r0, -r4, asr #12]
    1480:	00746961 	rsbseq	r6, r4, r1, ror #18
    1484:	61736944 	cmnvs	r3, r4, asr #18
    1488:	5f656c62 	svcpl	0x00656c62
    148c:	6e657645 	cdpvs	6, 6, cr7, cr5, cr5, {2}
    1490:	65445f74 	strbvs	r5, [r4, #-3956]	; 0xfffff08c
    1494:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
    1498:	006e6f69 	rsbeq	r6, lr, r9, ror #30
    149c:	74395a5f 	ldrtvc	r5, [r9], #-2655	; 0xfffff5a1
    14a0:	696d7265 	stmdbvs	sp!, {r0, r2, r5, r6, r9, ip, sp, lr}^
    14a4:	6574616e 	ldrbvs	r6, [r4, #-366]!	; 0xfffffe92
    14a8:	6e490069 	cdpvs	0, 4, cr0, cr9, cr9, {3}
    14ac:	72726574 	rsbsvc	r6, r2, #116, 10	; 0x1d000000
    14b0:	61747075 	cmnvs	r4, r5, ror r0
    14b4:	5f656c62 	svcpl	0x00656c62
    14b8:	65656c53 	strbvs	r6, [r5, #-3155]!	; 0xfffff3ad
    14bc:	706f0070 	rsbvc	r0, pc, r0, ror r0	; <UNPREDICTABLE>
    14c0:	74617265 	strbtvc	r7, [r1], #-613	; 0xfffffd9b
    14c4:	006e6f69 	rsbeq	r6, lr, r9, ror #30
    14c8:	63355a5f 	teqvs	r5, #389120	; 0x5f000
    14cc:	65736f6c 	ldrbvs	r6, [r3, #-3948]!	; 0xfffff094
    14d0:	4c6d006a 	stclmi	0, cr0, [sp], #-424	; 0xfffffe58
    14d4:	5f747361 	svcpl	0x00747361
    14d8:	00444950 	subeq	r4, r4, r0, asr r9
    14dc:	636f6c42 	cmnvs	pc, #16896	; 0x4200
    14e0:	0064656b 	rsbeq	r6, r4, fp, ror #10
    14e4:	7465474e 	strbtvc	r4, [r5], #-1870	; 0xfffff8b2
    14e8:	6863535f 	stmdavs	r3!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
    14ec:	495f6465 	ldmdbmi	pc, {r0, r2, r5, r6, sl, sp, lr}^	; <UNPREDICTABLE>
    14f0:	5f6f666e 	svcpl	0x006f666e
    14f4:	65707954 	ldrbvs	r7, [r0, #-2388]!	; 0xfffff6ac
    14f8:	365a5f00 	ldrbcc	r5, [sl], -r0, lsl #30
    14fc:	70746567 	rsbsvc	r6, r4, r7, ror #10
    1500:	00766469 	rsbseq	r6, r6, r9, ror #8
    1504:	6d616e66 	stclvs	14, cr6, [r1, #-408]!	; 0xfffffe68
    1508:	75520065 	ldrbvc	r0, [r2, #-101]	; 0xffffff9b
    150c:	62616e6e 	rsbvs	r6, r1, #1760	; 0x6e0
    1510:	4e00656c 	cfsh32mi	mvfx6, mvfx0, #60
    1514:	6b736154 	blvs	1cd9a6c <__bss_end+0x1ccd72c>
    1518:	6174535f 	cmnvs	r4, pc, asr r3
    151c:	73006574 	movwvc	r6, #1396	; 0x574
    1520:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
    1524:	756f635f 	strbvc	r6, [pc, #-863]!	; 11cd <shift+0x11cd>
    1528:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
    152c:	69727700 	ldmdbvs	r2!, {r8, r9, sl, ip, sp, lr}^
    1530:	65006574 	strvs	r6, [r0, #-1396]	; 0xfffffa8c
    1534:	5f746978 	svcpl	0x00746978
    1538:	65646f63 	strbvs	r6, [r4, #-3939]!	; 0xfffff09d
    153c:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
    1540:	50433631 	subpl	r3, r3, r1, lsr r6
    1544:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    1548:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 1384 <shift+0x1384>
    154c:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
    1550:	53347265 	teqpl	r4, #1342177286	; 0x50000006
    1554:	456b7262 	strbmi	r7, [fp, #-610]!	; 0xfffffd9e
    1558:	6373006a 	cmnvs	r3, #106	; 0x6a
    155c:	5f646568 	svcpl	0x00646568
    1560:	74617473 	strbtvc	r7, [r1], #-1139	; 0xfffffb8d
    1564:	705f6369 	subsvc	r6, pc, r9, ror #6
    1568:	726f6972 	rsbvc	r6, pc, #1867776	; 0x1c8000
    156c:	00797469 	rsbseq	r7, r9, r9, ror #8
    1570:	6b636974 	blvs	18dbb48 <__bss_end+0x18cf808>
    1574:	536d0073 	cmnpl	sp, #115	; 0x73
    1578:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
    157c:	5f656c75 	svcpl	0x00656c75
    1580:	00636e46 	rsbeq	r6, r3, r6, asr #28
    1584:	6e65706f 	cdpvs	0, 6, cr7, cr5, cr15, {3}
    1588:	345a5f00 	ldrbcc	r5, [sl], #-3840	; 0xfffff100
    158c:	65706970 	ldrbvs	r6, [r0, #-2416]!	; 0xfffff690
    1590:	6a634b50 	bvs	18d42d8 <__bss_end+0x18c7f98>
    1594:	65444e00 	strbvs	r4, [r4, #-3584]	; 0xfffff200
    1598:	696c6461 	stmdbvs	ip!, {r0, r5, r6, sl, sp, lr}^
    159c:	535f656e 	cmppl	pc, #461373440	; 0x1b800000
    15a0:	65736275 	ldrbvs	r6, [r3, #-629]!	; 0xfffffd8b
    15a4:	63697672 	cmnvs	r9, #119537664	; 0x7200000
    15a8:	65670065 	strbvs	r0, [r7, #-101]!	; 0xffffff9b
    15ac:	69745f74 	ldmdbvs	r4!, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    15b0:	635f6b63 	cmpvs	pc, #101376	; 0x18c00
    15b4:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
    15b8:	746f4e00 	strbtvc	r4, [pc], #-3584	; 15c0 <shift+0x15c0>
    15bc:	00796669 	rsbseq	r6, r9, r9, ror #12
    15c0:	61726170 	cmnvs	r2, r0, ror r1
    15c4:	5a5f006d 	bpl	17c1780 <__bss_end+0x17b5440>
    15c8:	69727735 	ldmdbvs	r2!, {r0, r2, r4, r5, r8, r9, sl, ip, sp, lr}^
    15cc:	506a6574 	rsbpl	r6, sl, r4, ror r5
    15d0:	006a634b 	rsbeq	r6, sl, fp, asr #6
    15d4:	466e7552 			; <UNDEFINED> instruction: 0x466e7552
    15d8:	74737269 	ldrbtvc	r7, [r3], #-617	; 0xfffffd97
    15dc:	6b736154 	blvs	1cd9b34 <__bss_end+0x1ccd7f4>
    15e0:	74656700 	strbtvc	r6, [r5], #-1792	; 0xfffff900
    15e4:	7361745f 	cmnvc	r1, #1593835520	; 0x5f000000
    15e8:	69745f6b 	ldmdbvs	r4!, {r0, r1, r3, r5, r6, r8, r9, sl, fp, ip, lr}^
    15ec:	5f736b63 	svcpl	0x00736b63
    15f0:	645f6f74 	ldrbvs	r6, [pc], #-3956	; 15f8 <shift+0x15f8>
    15f4:	6c646165 	stfvse	f6, [r4], #-404	; 0xfffffe6c
    15f8:	00656e69 	rsbeq	r6, r5, r9, ror #28
    15fc:	5f667562 	svcpl	0x00667562
    1600:	657a6973 	ldrbvs	r6, [sl, #-2419]!	; 0xfffff68d
    1604:	79687000 	stmdbvc	r8!, {ip, sp, lr}^
    1608:	61636973 	smcvs	13971	; 0x3693
    160c:	72625f6c 	rsbvc	r5, r2, #108, 30	; 0x1b0
    1610:	006b6165 	rsbeq	r6, fp, r5, ror #2
    1614:	626d6f5a 	rsbvs	r6, sp, #360	; 0x168
    1618:	47006569 	strmi	r6, [r0, -r9, ror #10]
    161c:	535f7465 	cmppl	pc, #1694498816	; 0x65000000
    1620:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
    1624:	666e495f 			; <UNDEFINED> instruction: 0x666e495f
    1628:	6573006f 	ldrbvs	r0, [r3, #-111]!	; 0xffffff91
    162c:	61745f74 	cmnvs	r4, r4, ror pc
    1630:	645f6b73 	ldrbvs	r6, [pc], #-2931	; 1638 <shift+0x1638>
    1634:	6c646165 	stfvse	f6, [r4], #-404	; 0xfffffe6c
    1638:	00656e69 	rsbeq	r6, r5, r9, ror #28
    163c:	314e5a5f 	cmpcc	lr, pc, asr sl
    1640:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
    1644:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    1648:	614d5f73 	hvcvs	54771	; 0xd5f3
    164c:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
    1650:	63533872 	cmpvs	r3, #7471104	; 0x720000
    1654:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
    1658:	7645656c 	strbvc	r6, [r5], -ip, ror #10
    165c:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
    1660:	50433631 	subpl	r3, r3, r1, lsr r6
    1664:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    1668:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 14a4 <shift+0x14a4>
    166c:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
    1670:	39317265 	ldmdbcc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
    1674:	5f70614d 	svcpl	0x0070614d
    1678:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
    167c:	5f6f545f 	svcpl	0x006f545f
    1680:	72727543 	rsbsvc	r7, r2, #281018368	; 0x10c00000
    1684:	45746e65 	ldrbmi	r6, [r4, #-3685]!	; 0xfffff19b
    1688:	46493550 			; <UNDEFINED> instruction: 0x46493550
    168c:	00656c69 	rsbeq	r6, r5, r9, ror #24
    1690:	5f746547 	svcpl	0x00746547
    1694:	61726150 	cmnvs	r2, r0, asr r1
    1698:	5f00736d 	svcpl	0x0000736d
    169c:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
    16a0:	6f725043 	svcvs	0x00725043
    16a4:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    16a8:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
    16ac:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
    16b0:	63533231 	cmpvs	r3, #268435459	; 0x10000003
    16b4:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
    16b8:	455f656c 	ldrbmi	r6, [pc, #-1388]	; 1154 <shift+0x1154>
    16bc:	76454644 	strbvc	r4, [r5], -r4, asr #12
    16c0:	355a5f00 	ldrbcc	r5, [sl, #-3840]	; 0xfffff100
    16c4:	65656c73 	strbvs	r6, [r5, #-3187]!	; 0xfffff38d
    16c8:	006a6a70 	rsbeq	r6, sl, r0, ror sl
    16cc:	5f746547 	svcpl	0x00746547
    16d0:	616d6552 	cmnvs	sp, r2, asr r5
    16d4:	6e696e69 	cdpvs	14, 6, cr6, cr9, cr9, {3}
    16d8:	6e450067 	cdpvs	0, 4, cr0, cr5, cr7, {3}
    16dc:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
    16e0:	6576455f 	ldrbvs	r4, [r6, #-1375]!	; 0xfffffaa1
    16e4:	445f746e 	ldrbmi	r7, [pc], #-1134	; 16ec <shift+0x16ec>
    16e8:	63657465 	cmnvs	r5, #1694498816	; 0x65000000
    16ec:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
    16f0:	325a5f00 	subscc	r5, sl, #0, 30
    16f4:	74656736 	strbtvc	r6, [r5], #-1846	; 0xfffff8ca
    16f8:	7361745f 	cmnvc	r1, #1593835520	; 0x5f000000
    16fc:	69745f6b 	ldmdbvs	r4!, {r0, r1, r3, r5, r6, r8, r9, sl, fp, ip, lr}^
    1700:	5f736b63 	svcpl	0x00736b63
    1704:	645f6f74 	ldrbvs	r6, [pc], #-3956	; 170c <shift+0x170c>
    1708:	6c646165 	stfvse	f6, [r4], #-404	; 0xfffffe6c
    170c:	76656e69 	strbtvc	r6, [r5], -r9, ror #28
    1710:	6f682f00 	svcvs	0x00682f00
    1714:	742f656d 	strtvc	r6, [pc], #-1389	; 171c <shift+0x171c>
    1718:	69666572 	stmdbvs	r6!, {r1, r4, r5, r6, r8, sl, sp, lr}^
    171c:	65732f6c 	ldrbvs	r2, [r3, #-3948]!	; 0xfffff094
    1720:	6f732f6d 	svcvs	0x00732f6d
    1724:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
    1728:	74732f73 	ldrbtvc	r2, [r3], #-3955	; 0xfffff08d
    172c:	62696c64 	rsbvs	r6, r9, #100, 24	; 0x6400
    1730:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
    1734:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
    1738:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
    173c:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
    1740:	57534e00 	ldrbpl	r4, [r3, -r0, lsl #28]
    1744:	65525f49 	ldrbvs	r5, [r2, #-3913]	; 0xfffff0b7
    1748:	746c7573 	strbtvc	r7, [ip], #-1395	; 0xfffffa8d
    174c:	646f435f 	strbtvs	r4, [pc], #-863	; 1754 <shift+0x1754>
    1750:	75520065 	ldrbvc	r0, [r2, #-101]	; 0xffffff9b
    1754:	6e696e6e 	cdpvs	14, 6, cr6, cr9, cr14, {3}
    1758:	72770067 	rsbsvc	r0, r7, #103	; 0x67
    175c:	006d756e 	rsbeq	r7, sp, lr, ror #10
    1760:	77345a5f 			; <UNDEFINED> instruction: 0x77345a5f
    1764:	6a746961 	bvs	1d1bcf0 <__bss_end+0x1d0f9b0>
    1768:	5f006a6a 	svcpl	0x00006a6a
    176c:	6f69355a 	svcvs	0x0069355a
    1770:	6a6c7463 	bvs	1b1e904 <__bss_end+0x1b125c4>
    1774:	494e3631 	stmdbmi	lr, {r0, r4, r5, r9, sl, ip, sp}^
    1778:	6c74434f 	ldclvs	3, cr4, [r4], #-316	; 0xfffffec4
    177c:	65704f5f 	ldrbvs	r4, [r0, #-3935]!	; 0xfffff0a1
    1780:	69746172 	ldmdbvs	r4!, {r1, r4, r5, r6, r8, sp, lr}^
    1784:	76506e6f 	ldrbvc	r6, [r0], -pc, ror #28
    1788:	636f6900 	cmnvs	pc, #0, 18
    178c:	72006c74 	andvc	r6, r0, #116, 24	; 0x7400
    1790:	6e637465 	cdpvs	4, 6, cr7, cr3, cr5, {3}
    1794:	436d0074 	cmnmi	sp, #116	; 0x74
    1798:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
    179c:	545f746e 	ldrbpl	r7, [pc], #-1134	; 17a4 <shift+0x17a4>
    17a0:	5f6b7361 	svcpl	0x006b7361
    17a4:	65646f4e 	strbvs	r6, [r4, #-3918]!	; 0xfffff0b2
    17a8:	746f6e00 	strbtvc	r6, [pc], #-3584	; 17b0 <shift+0x17b0>
    17ac:	00796669 	rsbseq	r6, r9, r9, ror #12
    17b0:	6d726574 	cfldr64vs	mvdx6, [r2, #-464]!	; 0xfffffe30
    17b4:	74616e69 	strbtvc	r6, [r1], #-3689	; 0xfffff197
    17b8:	6f6d0065 	svcvs	0x006d0065
    17bc:	63006564 	movwvs	r6, #1380	; 0x564
    17c0:	635f7570 	cmpvs	pc, #112, 10	; 0x1c000000
    17c4:	65746e6f 	ldrbvs	r6, [r4, #-3695]!	; 0xfffff191
    17c8:	73007478 	movwvc	r7, #1144	; 0x478
    17cc:	7065656c 	rsbvc	r6, r5, ip, ror #10
    17d0:	6d69745f 	cfstrdvs	mvd7, [r9, #-380]!	; 0xfffffe84
    17d4:	5f007265 	svcpl	0x00007265
    17d8:	314b4e5a 	cmpcc	fp, sl, asr lr
    17dc:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
    17e0:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    17e4:	614d5f73 	hvcvs	54771	; 0xd5f3
    17e8:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
    17ec:	47383172 			; <UNDEFINED> instruction: 0x47383172
    17f0:	505f7465 	subspl	r7, pc, r5, ror #8
    17f4:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    17f8:	425f7373 	subsmi	r7, pc, #-872415231	; 0xcc000001
    17fc:	49505f79 	ldmdbmi	r0, {r0, r3, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    1800:	006a4544 	rsbeq	r4, sl, r4, asr #10
    1804:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
    1808:	465f656c 	ldrbmi	r6, [pc], -ip, ror #10
    180c:	73656c69 	cmnvc	r5, #26880	; 0x6900
    1810:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
    1814:	57535f6d 	ldrbpl	r5, [r3, -sp, ror #30]
    1818:	5a5f0049 	bpl	17c1944 <__bss_end+0x17b5604>
    181c:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
    1820:	636f7250 	cmnvs	pc, #80, 4
    1824:	5f737365 	svcpl	0x00737365
    1828:	616e614d 	cmnvs	lr, sp, asr #2
    182c:	31726567 	cmncc	r2, r7, ror #10
    1830:	68635331 	stmdavs	r3!, {r0, r4, r5, r8, r9, ip, lr}^
    1834:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
    1838:	52525f65 	subspl	r5, r2, #404	; 0x194
    183c:	74007645 	strvc	r7, [r0], #-1605	; 0xfffff9bb
    1840:	006b7361 	rsbeq	r7, fp, r1, ror #6
    1844:	72345a5f 	eorsvc	r5, r4, #389120	; 0x5f000
    1848:	6a646165 	bvs	1919de4 <__bss_end+0x190daa4>
    184c:	006a6350 	rsbeq	r6, sl, r0, asr r3
    1850:	69746f4e 	ldmdbvs	r4!, {r1, r2, r3, r6, r8, r9, sl, fp, sp, lr}^
    1854:	505f7966 	subspl	r7, pc, r6, ror #18
    1858:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    185c:	53007373 	movwpl	r7, #883	; 0x373
    1860:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
    1864:	00656c75 	rsbeq	r6, r5, r5, ror ip
    1868:	314e5a5f 	cmpcc	lr, pc, asr sl
    186c:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
    1870:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    1874:	614d5f73 	hvcvs	54771	; 0xd5f3
    1878:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
    187c:	77533972 			; <UNDEFINED> instruction: 0x77533972
    1880:	68637469 	stmdavs	r3!, {r0, r3, r5, r6, sl, ip, sp, lr}^
    1884:	456f545f 	strbmi	r5, [pc, #-1119]!	; 142d <shift+0x142d>
    1888:	43383150 	teqmi	r8, #80, 2
    188c:	636f7250 	cmnvs	pc, #80, 4
    1890:	5f737365 	svcpl	0x00737365
    1894:	7473694c 	ldrbtvc	r6, [r3], #-2380	; 0xfffff6b4
    1898:	646f4e5f 	strbtvs	r4, [pc], #-3679	; 18a0 <shift+0x18a0>
    189c:	63530065 	cmpvs	r3, #101	; 0x65
    18a0:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
    18a4:	525f656c 	subspl	r6, pc, #108, 10	; 0x1b000000
    18a8:	5a5f0052 	bpl	17c19f8 <__bss_end+0x17b56b8>
    18ac:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
    18b0:	636f7250 	cmnvs	pc, #80, 4
    18b4:	5f737365 	svcpl	0x00737365
    18b8:	616e614d 	cmnvs	lr, sp, asr #2
    18bc:	31726567 	cmncc	r2, r7, ror #10
    18c0:	6e614838 	mcrvs	8, 3, r4, cr1, cr8, {1}
    18c4:	5f656c64 	svcpl	0x00656c64
    18c8:	636f7250 	cmnvs	pc, #80, 4
    18cc:	5f737365 	svcpl	0x00737365
    18d0:	45495753 	strbmi	r5, [r9, #-1875]	; 0xfffff8ad
    18d4:	534e3032 	movtpl	r3, #57394	; 0xe032
    18d8:	505f4957 	subspl	r4, pc, r7, asr r9	; <UNPREDICTABLE>
    18dc:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    18e0:	535f7373 	cmppl	pc, #-872415231	; 0xcc000001
    18e4:	69767265 	ldmdbvs	r6!, {r0, r2, r5, r6, r9, ip, sp, lr}^
    18e8:	6a6a6563 	bvs	1a9ae7c <__bss_end+0x1a8eb3c>
    18ec:	3131526a 	teqcc	r1, sl, ror #4
    18f0:	49575354 	ldmdbmi	r7, {r2, r4, r6, r8, r9, ip, lr}^
    18f4:	7365525f 	cmnvc	r5, #-268435451	; 0xf0000005
    18f8:	00746c75 	rsbseq	r6, r4, r5, ror ip
    18fc:	434f494e 	movtmi	r4, #63822	; 0xf94e
    1900:	4f5f6c74 	svcmi	0x005f6c74
    1904:	61726570 	cmnvs	r2, r0, ror r5
    1908:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
    190c:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
    1910:	50433631 	subpl	r3, r3, r1, lsr r6
    1914:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    1918:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 1754 <shift+0x1754>
    191c:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
    1920:	34317265 	ldrtcc	r7, [r1], #-613	; 0xfffffd9b
    1924:	61657243 	cmnvs	r5, r3, asr #4
    1928:	505f6574 	subspl	r6, pc, r4, ror r5	; <UNPREDICTABLE>
    192c:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    1930:	50457373 	subpl	r7, r5, r3, ror r3
    1934:	00626a68 	rsbeq	r6, r2, r8, ror #20
    1938:	74697753 	strbtvc	r7, [r9], #-1875	; 0xfffff8ad
    193c:	545f6863 	ldrbpl	r6, [pc], #-2147	; 1944 <shift+0x1944>
    1940:	534e006f 	movtpl	r0, #57455	; 0xe06f
    1944:	465f4957 			; <UNDEFINED> instruction: 0x465f4957
    1948:	73656c69 	cmnvc	r5, #26880	; 0x6900
    194c:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
    1950:	65535f6d 	ldrbvs	r5, [r3, #-3949]	; 0xfffff093
    1954:	63697672 	cmnvs	r9, #119537664	; 0x7200000
    1958:	65720065 	ldrbvs	r0, [r2, #-101]!	; 0xffffff9b
    195c:	646f6374 	strbtvs	r6, [pc], #-884	; 1964 <shift+0x1964>
    1960:	65670065 	strbvs	r0, [r7, #-101]!	; 0xffffff9b
    1964:	63615f74 	cmnvs	r1, #116, 30	; 0x1d0
    1968:	65766974 	ldrbvs	r6, [r6, #-2420]!	; 0xfffff68c
    196c:	6f72705f 	svcvs	0x0072705f
    1970:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    1974:	756f635f 	strbvc	r6, [pc, #-863]!	; 161d <shift+0x161d>
    1978:	6600746e 	strvs	r7, [r0], -lr, ror #8
    197c:	6e656c69 	cdpvs	12, 6, cr6, cr5, cr9, {3}
    1980:	00656d61 	rsbeq	r6, r5, r1, ror #26
    1984:	65657246 	strbvs	r7, [r5, #-582]!	; 0xfffffdba
    1988:	61657200 	cmnvs	r5, r0, lsl #4
    198c:	6c430064 	mcrrvs	0, 6, r0, r3, cr4
    1990:	0065736f 	rsbeq	r7, r5, pc, ror #6
    1994:	70616568 	rsbvc	r6, r1, r8, ror #10
    1998:	6174735f 	cmnvs	r4, pc, asr r3
    199c:	67007472 	smlsdxvs	r0, r2, r4, r7
    19a0:	69707465 	ldmdbvs	r0!, {r0, r2, r5, r6, sl, ip, sp, lr}^
    19a4:	5a5f0064 	bpl	17c1b3c <__bss_end+0x17b57fc>
    19a8:	65706f34 	ldrbvs	r6, [r0, #-3892]!	; 0xfffff0cc
    19ac:	634b506e 	movtvs	r5, #45166	; 0xb06e
    19b0:	464e3531 			; <UNDEFINED> instruction: 0x464e3531
    19b4:	5f656c69 	svcpl	0x00656c69
    19b8:	6e65704f 	cdpvs	0, 6, cr7, cr5, cr15, {2}
    19bc:	646f4d5f 	strbtvs	r4, [pc], #-3423	; 19c4 <shift+0x19c4>
    19c0:	69590065 	ldmdbvs	r9, {r0, r2, r5, r6}^
    19c4:	00646c65 	rsbeq	r6, r4, r5, ror #24
    19c8:	314e5a5f 	cmpcc	lr, pc, asr sl
    19cc:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
    19d0:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    19d4:	614d5f73 	hvcvs	54771	; 0xd5f3
    19d8:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
    19dc:	45344372 	ldrmi	r4, [r4, #-882]!	; 0xfffffc8e
    19e0:	65540076 	ldrbvs	r0, [r4, #-118]	; 0xffffff8a
    19e4:	6e696d72 	mcrvs	13, 3, r6, cr9, cr2, {3}
    19e8:	00657461 	rsbeq	r7, r5, r1, ror #8
    19ec:	74434f49 	strbvc	r4, [r3], #-3913	; 0xfffff0b7
    19f0:	5a5f006c 	bpl	17c1ba8 <__bss_end+0x17b5868>
    19f4:	72747337 	rsbsvc	r7, r4, #-603979776	; 0xdc000000
    19f8:	7970636e 	ldmdbvc	r0!, {r1, r2, r3, r5, r6, r8, r9, sp, lr}^
    19fc:	4b506350 	blmi	141a744 <__bss_end+0x140e404>
    1a00:	5f006963 	svcpl	0x00006963
    1a04:	656d365a 	strbvs	r3, [sp, #-1626]!	; 0xfffff9a6
    1a08:	7970636d 	ldmdbvc	r0!, {r0, r2, r3, r5, r6, r8, r9, sp, lr}^
    1a0c:	50764b50 	rsbspl	r4, r6, r0, asr fp
    1a10:	5f006976 	svcpl	0x00006976
    1a14:	6734315a 			; <UNDEFINED> instruction: 0x6734315a
    1a18:	695f7465 	ldmdbvs	pc, {r0, r2, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
    1a1c:	7475706e 	ldrbtvc	r7, [r5], #-110	; 0xffffff92
    1a20:	7079745f 	rsbsvc	r7, r9, pc, asr r4
    1a24:	634b5065 	movtvs	r5, #45157	; 0xb065
    1a28:	345a5f00 	ldrbcc	r5, [sl], #-3840	; 0xfffff100
    1a2c:	75745f6e 	ldrbvc	r5, [r4, #-3950]!	; 0xfffff092
    1a30:	61006969 	tstvs	r0, r9, ror #18
    1a34:	00666f74 	rsbeq	r6, r6, r4, ror pc
    1a38:	5f746567 	svcpl	0x00746567
    1a3c:	75706e69 	ldrbvc	r6, [r0, #-3689]!	; 0xfffff197
    1a40:	79745f74 	ldmdbvc	r4!, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    1a44:	61006570 	tstvs	r0, r0, ror r5
    1a48:	00696f74 	rsbeq	r6, r9, r4, ror pc
    1a4c:	61345a5f 	teqvs	r4, pc, asr sl
    1a50:	50666f74 	rsbpl	r6, r6, r4, ror pc
    1a54:	6400634b 	strvs	r6, [r0], #-843	; 0xfffffcb5
    1a58:	00747365 	rsbseq	r7, r4, r5, ror #6
    1a5c:	75706e69 	ldrbvc	r6, [r0, #-3689]!	; 0xfffff197
    1a60:	69730074 	ldmdbvs	r3!, {r2, r4, r5, r6}^
    1a64:	73006e67 	movwvc	r6, #3687	; 0xe67
    1a68:	61637274 	smcvs	14116	; 0x3724
    1a6c:	5a5f0074 	bpl	17c1c44 <__bss_end+0x17b5904>
    1a70:	657a6235 	ldrbvs	r6, [sl, #-565]!	; 0xfffffdcb
    1a74:	76506f72 	usub16vc	r6, r0, r2
    1a78:	74730069 	ldrbtvc	r0, [r3], #-105	; 0xffffff97
    1a7c:	70636e72 	rsbvc	r6, r3, r2, ror lr
    1a80:	5a5f0079 	bpl	17c1c6c <__bss_end+0x17b592c>
    1a84:	72747336 	rsbsvc	r7, r4, #-671088640	; 0xd8000000
    1a88:	50746163 	rsbspl	r6, r4, r3, ror #2
    1a8c:	634b5063 	movtvs	r5, #45155	; 0xb063
    1a90:	6f682f00 	svcvs	0x00682f00
    1a94:	742f656d 	strtvc	r6, [pc], #-1389	; 1a9c <shift+0x1a9c>
    1a98:	69666572 	stmdbvs	r6!, {r1, r4, r5, r6, r8, sl, sp, lr}^
    1a9c:	65732f6c 	ldrbvs	r2, [r3, #-3948]!	; 0xfffff094
    1aa0:	6f732f6d 	svcvs	0x00732f6d
    1aa4:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
    1aa8:	74732f73 	ldrbtvc	r2, [r3], #-3955	; 0xfffff08d
    1aac:	62696c64 	rsbvs	r6, r9, #100, 24	; 0x6400
    1ab0:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
    1ab4:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
    1ab8:	69727473 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
    1abc:	632e676e 			; <UNDEFINED> instruction: 0x632e676e
    1ac0:	73007070 	movwvc	r7, #112	; 0x70
    1ac4:	636e7274 	cmnvs	lr, #116, 4	; 0x40000007
    1ac8:	77007461 	strvc	r7, [r0, -r1, ror #8]
    1acc:	656b6c61 	strbvs	r6, [fp, #-3169]!	; 0xfffff39f
    1ad0:	61660072 	smcvs	24578	; 0x6002
    1ad4:	726f7463 	rsbvc	r7, pc, #1660944384	; 0x63000000
    1ad8:	6f746900 	svcvs	0x00746900
    1adc:	6f700061 	svcvs	0x00700061
    1ae0:	69746973 	ldmdbvs	r4!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
    1ae4:	6d006e6f 	stcvs	14, cr6, [r0, #-444]	; 0xfffffe44
    1ae8:	73646d65 	cmnvc	r4, #6464	; 0x1940
    1aec:	68430074 	stmdavs	r3, {r2, r4, r5, r6}^
    1af0:	6f437261 	svcvs	0x00437261
    1af4:	7241766e 	subvc	r7, r1, #115343360	; 0x6e00000
    1af8:	74660072 	strbtvc	r0, [r6], #-114	; 0xffffff8e
    1afc:	6e00616f 	adfvssz	f6, f0, #10.0
    1b00:	65626d75 	strbvs	r6, [r2, #-3445]!	; 0xfffff28b
    1b04:	656d0072 	strbvs	r0, [sp, #-114]!	; 0xffffff8e
    1b08:	6372736d 	cmnvs	r2, #-1275068415	; 0xb4000001
    1b0c:	6d756e00 	ldclvs	14, cr6, [r5, #-0]
    1b10:	32726562 	rsbscc	r6, r2, #411041792	; 0x18800000
    1b14:	74666100 	strbtvc	r6, [r6], #-256	; 0xffffff00
    1b18:	65447265 	strbvs	r7, [r4, #-613]	; 0xfffffd9b
    1b1c:	696f5063 	stmdbvs	pc!, {r0, r1, r5, r6, ip, lr}^	; <UNPREDICTABLE>
    1b20:	6200746e 	andvs	r7, r0, #1845493760	; 0x6e000000
    1b24:	6f72657a 	svcvs	0x0072657a
    1b28:	6d656d00 	stclvs	13, cr6, [r5, #-0]
    1b2c:	00797063 	rsbseq	r7, r9, r3, rrx
    1b30:	6e727473 	mrcvs	4, 3, r7, cr2, cr3, {3}
    1b34:	00706d63 	rsbseq	r6, r0, r3, ror #26
    1b38:	69617274 	stmdbvs	r1!, {r2, r4, r5, r6, r9, ip, sp, lr}^
    1b3c:	676e696c 	strbvs	r6, [lr, -ip, ror #18]!
    1b40:	746f645f 	strbtvc	r6, [pc], #-1119	; 1b48 <shift+0x1b48>
    1b44:	74756f00 	ldrbtvc	r6, [r5], #-3840	; 0xfffff100
    1b48:	00747570 	rsbseq	r7, r4, r0, ror r5
    1b4c:	676e656c 	strbvs	r6, [lr, -ip, ror #10]!
    1b50:	00326874 	eorseq	r6, r2, r4, ror r8
    1b54:	75745f6e 	ldrbvc	r5, [r4, #-3950]!	; 0xfffff092
    1b58:	365a5f00 	ldrbcc	r5, [sl], -r0, lsl #30
    1b5c:	6c727473 	cfldrdvs	mvd7, [r2], #-460	; 0xfffffe34
    1b60:	4b506e65 	blmi	141d4fc <__bss_end+0x14111bc>
    1b64:	5a5f0063 	bpl	17c1cf8 <__bss_end+0x17b59b8>
    1b68:	72747337 	rsbsvc	r7, r4, #-603979776	; 0xdc000000
    1b6c:	706d636e 	rsbvc	r6, sp, lr, ror #6
    1b70:	53634b50 	cmnpl	r3, #80, 22	; 0x14000
    1b74:	00695f30 	rsbeq	r5, r9, r0, lsr pc
    1b78:	61345a5f 	teqvs	r4, pc, asr sl
    1b7c:	50696f74 	rsbpl	r6, r9, r4, ror pc
    1b80:	5f00634b 	svcpl	0x0000634b
    1b84:	7469345a 	strbtvc	r3, [r9], #-1114	; 0xfffffba6
    1b88:	5069616f 	rsbpl	r6, r9, pc, ror #2
    1b8c:	5f006a63 	svcpl	0x00006a63
    1b90:	7466345a 	strbtvc	r3, [r6], #-1114	; 0xfffffba6
    1b94:	5066616f 	rsbpl	r6, r6, pc, ror #2
    1b98:	656d0063 	strbvs	r0, [sp, #-99]!	; 0xffffff9d
    1b9c:	79726f6d 	ldmdbvc	r2!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
    1ba0:	6e656c00 	cdpvs	12, 6, cr6, cr5, cr0, {0}
    1ba4:	00687467 	rsbeq	r7, r8, r7, ror #8
    1ba8:	6c727473 	cfldrdvs	mvd7, [r2], #-460	; 0xfffffe34
    1bac:	5f006e65 	svcpl	0x00006e65
    1bb0:	7473375a 	ldrbtvc	r3, [r3], #-1882	; 0xfffff8a6
    1bb4:	61636e72 	smcvs	14050	; 0x36e2
    1bb8:	50635074 	rsbpl	r5, r3, r4, ror r0
    1bbc:	0069634b 	rsbeq	r6, r9, fp, asr #6
    1bc0:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1bc4:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1bc8:	2f2e2e2f 	svccs	0x002e2e2f
    1bcc:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1bd0:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
    1bd4:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    1bd8:	6e6f632f 	cdpvs	3, 6, cr6, cr15, cr15, {1}
    1bdc:	2f676966 	svccs	0x00676966
    1be0:	2f6d7261 	svccs	0x006d7261
    1be4:	3162696c 	cmncc	r2, ip, ror #18
    1be8:	636e7566 	cmnvs	lr, #427819008	; 0x19800000
    1bec:	00532e73 	subseq	r2, r3, r3, ror lr
    1bf0:	6975622f 	ldmdbvs	r5!, {r0, r1, r2, r3, r5, r9, sp, lr}^
    1bf4:	672f646c 	strvs	r6, [pc, -ip, ror #8]!
    1bf8:	612d6363 			; <UNDEFINED> instruction: 0x612d6363
    1bfc:	6e2d6d72 	mcrvs	13, 1, r6, cr13, cr2, {3}
    1c00:	2d656e6f 	stclcs	14, cr6, [r5, #-444]!	; 0xfffffe44
    1c04:	69626165 	stmdbvs	r2!, {r0, r2, r5, r6, r8, sp, lr}^
    1c08:	6659682d 	ldrbvs	r6, [r9], -sp, lsr #16
    1c0c:	2f344b67 	svccs	0x00344b67
    1c10:	2d636367 	stclcs	3, cr6, [r3, #-412]!	; 0xfffffe64
    1c14:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
    1c18:	656e6f6e 	strbvs	r6, [lr, #-3950]!	; 0xfffff092
    1c1c:	6261652d 	rsbvs	r6, r1, #188743680	; 0xb400000
    1c20:	30312d69 	eorscc	r2, r1, r9, ror #26
    1c24:	322d332e 	eorcc	r3, sp, #-1207959552	; 0xb8000000
    1c28:	2e313230 	mrccs	2, 1, r3, cr1, cr0, {1}
    1c2c:	622f3730 	eorvs	r3, pc, #48, 14	; 0xc00000
    1c30:	646c6975 	strbtvs	r6, [ip], #-2421	; 0xfffff68b
    1c34:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
    1c38:	6e6f6e2d 	cdpvs	14, 6, cr6, cr15, cr13, {1}
    1c3c:	61652d65 	cmnvs	r5, r5, ror #26
    1c40:	612f6962 			; <UNDEFINED> instruction: 0x612f6962
    1c44:	762f6d72 			; <UNDEFINED> instruction: 0x762f6d72
    1c48:	2f657435 	svccs	0x00657435
    1c4c:	64726168 	ldrbtvs	r6, [r2], #-360	; 0xfffffe98
    1c50:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
    1c54:	00636367 	rsbeq	r6, r3, r7, ror #6
    1c58:	20554e47 	subscs	r4, r5, r7, asr #28
    1c5c:	32205341 	eorcc	r5, r0, #67108865	; 0x4000001
    1c60:	0037332e 	eorseq	r3, r7, lr, lsr #6
    1c64:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1c68:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1c6c:	2f2e2e2f 	svccs	0x002e2e2f
    1c70:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1c74:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
    1c78:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    1c7c:	6e6f632f 	cdpvs	3, 6, cr6, cr15, cr15, {1}
    1c80:	2f676966 	svccs	0x00676966
    1c84:	2f6d7261 	svccs	0x006d7261
    1c88:	65656569 	strbvs	r6, [r5, #-1385]!	; 0xfffffa97
    1c8c:	2d343537 	cfldr32cs	mvfx3, [r4, #-220]!	; 0xffffff24
    1c90:	532e6673 			; <UNDEFINED> instruction: 0x532e6673
    1c94:	2f2e2e00 	svccs	0x002e2e00
    1c98:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1c9c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1ca0:	2f2e2e2f 	svccs	0x002e2e2f
    1ca4:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; 1bf4 <shift+0x1bf4>
    1ca8:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    1cac:	6f632f63 	svcvs	0x00632f63
    1cb0:	6769666e 	strbvs	r6, [r9, -lr, ror #12]!
    1cb4:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
    1cb8:	6170622f 	cmnvs	r0, pc, lsr #4
    1cbc:	532e6962 			; <UNDEFINED> instruction: 0x532e6962
    1cc0:	61736900 	cmnvs	r3, r0, lsl #18
    1cc4:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1cc8:	6572705f 	ldrbvs	r7, [r2, #-95]!	; 0xffffffa1
    1ccc:	73657264 	cmnvc	r5, #100, 4	; 0x40000006
    1cd0:	61736900 	cmnvs	r3, r0, lsl #18
    1cd4:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1cd8:	7066765f 	rsbvc	r7, r6, pc, asr r6
    1cdc:	7361625f 	cmnvc	r1, #-268435451	; 0xf0000005
    1ce0:	6f630065 	svcvs	0x00630065
    1ce4:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
    1ce8:	6c662078 	stclvs	0, cr2, [r6], #-480	; 0xfffffe20
    1cec:	0074616f 	rsbseq	r6, r4, pc, ror #2
    1cf0:	5f617369 	svcpl	0x00617369
    1cf4:	69626f6e 	stmdbvs	r2!, {r1, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
    1cf8:	73690074 	cmnvc	r9, #116	; 0x74
    1cfc:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1d00:	766d5f74 	uqsub16vc	r5, sp, r4
    1d04:	6c665f65 	stclvs	15, cr5, [r6], #-404	; 0xfffffe6c
    1d08:	0074616f 	rsbseq	r6, r4, pc, ror #2
    1d0c:	5f617369 	svcpl	0x00617369
    1d10:	5f746962 	svcpl	0x00746962
    1d14:	36317066 	ldrtcc	r7, [r1], -r6, rrx
    1d18:	61736900 	cmnvs	r3, r0, lsl #18
    1d1c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1d20:	6365735f 	cmnvs	r5, #2080374785	; 0x7c000001
    1d24:	61736900 	cmnvs	r3, r0, lsl #18
    1d28:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1d2c:	6964615f 	stmdbvs	r4!, {r0, r1, r2, r3, r4, r6, r8, sp, lr}^
    1d30:	73690076 	cmnvc	r9, #118	; 0x76
    1d34:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1d38:	75715f74 	ldrbvc	r5, [r1, #-3956]!	; 0xfffff08c
    1d3c:	5f6b7269 	svcpl	0x006b7269
    1d40:	765f6f6e 	ldrbvc	r6, [pc], -lr, ror #30
    1d44:	74616c6f 	strbtvc	r6, [r1], #-3183	; 0xfffff391
    1d48:	5f656c69 	svcpl	0x00656c69
    1d4c:	69006563 	stmdbvs	r0, {r0, r1, r5, r6, r8, sl, sp, lr}
    1d50:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1d54:	6d5f7469 	cfldrdvs	mvd7, [pc, #-420]	; 1bb8 <shift+0x1bb8>
    1d58:	73690070 	cmnvc	r9, #112	; 0x70
    1d5c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1d60:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    1d64:	7435766d 	ldrtvc	r7, [r5], #-1645	; 0xfffff993
    1d68:	61736900 	cmnvs	r3, r0, lsl #18
    1d6c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1d70:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1d74:	65743576 	ldrbvs	r3, [r4, #-1398]!	; 0xfffffa8a
    1d78:	61736900 	cmnvs	r3, r0, lsl #18
    1d7c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1d80:	6f656e5f 	svcvs	0x00656e5f
    1d84:	7369006e 	cmnvc	r9, #110	; 0x6e
    1d88:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1d8c:	66625f74 	uqsub16vs	r5, r2, r4
    1d90:	46003631 			; <UNDEFINED> instruction: 0x46003631
    1d94:	52435350 	subpl	r5, r3, #80, 6	; 0x40000001
    1d98:	554e455f 	strbpl	r4, [lr, #-1375]	; 0xfffffaa1
    1d9c:	5046004d 	subpl	r0, r6, sp, asr #32
    1da0:	5f524353 	svcpl	0x00524353
    1da4:	76637a6e 	strbtvc	r7, [r3], -lr, ror #20
    1da8:	455f6371 	ldrbmi	r6, [pc, #-881]	; 1a3f <shift+0x1a3f>
    1dac:	004d554e 	subeq	r5, sp, lr, asr #10
    1db0:	5f525056 	svcpl	0x00525056
    1db4:	4d554e45 	ldclmi	14, cr4, [r5, #-276]	; 0xfffffeec
    1db8:	69626600 	stmdbvs	r2!, {r9, sl, sp, lr}^
    1dbc:	6d695f74 	stclvs	15, cr5, [r9, #-464]!	; 0xfffffe30
    1dc0:	63696c70 	cmnvs	r9, #112, 24	; 0x7000
    1dc4:	6f697461 	svcvs	0x00697461
    1dc8:	3050006e 	subscc	r0, r0, lr, rrx
    1dcc:	554e455f 	strbpl	r4, [lr, #-1375]	; 0xfffffaa1
    1dd0:	7369004d 	cmnvc	r9, #77	; 0x4d
    1dd4:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1dd8:	72635f74 	rsbvc	r5, r3, #116, 30	; 0x1d0
    1ddc:	6f747079 	svcvs	0x00747079
    1de0:	554e4700 	strbpl	r4, [lr, #-1792]	; 0xfffff900
    1de4:	37314320 	ldrcc	r4, [r1, -r0, lsr #6]!
    1de8:	2e303120 	rsfcssp	f3, f0, f0
    1dec:	20312e33 	eorscs	r2, r1, r3, lsr lr
    1df0:	31323032 	teqcc	r2, r2, lsr r0
    1df4:	31323630 	teqcc	r2, r0, lsr r6
    1df8:	65722820 	ldrbvs	r2, [r2, #-2080]!	; 0xfffff7e0
    1dfc:	7361656c 	cmnvc	r1, #108, 10	; 0x1b000000
    1e00:	2d202965 			; <UNDEFINED> instruction: 0x2d202965
    1e04:	6d72616d 	ldfvse	f6, [r2, #-436]!	; 0xfffffe4c
    1e08:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
    1e0c:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
    1e10:	6962612d 	stmdbvs	r2!, {r0, r2, r3, r5, r8, sp, lr}^
    1e14:	7261683d 	rsbvc	r6, r1, #3997696	; 0x3d0000
    1e18:	6d2d2064 	stcvs	0, cr2, [sp, #-400]!	; 0xfffffe70
    1e1c:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1e20:	6d72613d 	ldfvse	f6, [r2, #-244]!	; 0xffffff0c
    1e24:	65743576 	ldrbvs	r3, [r4, #-1398]!	; 0xfffffa8a
    1e28:	2070662b 	rsbscs	r6, r0, fp, lsr #12
    1e2c:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
    1e30:	672d2067 	strvs	r2, [sp, -r7, rrx]!
    1e34:	324f2d20 	subcc	r2, pc, #32, 26	; 0x800
    1e38:	324f2d20 	subcc	r2, pc, #32, 26	; 0x800
    1e3c:	324f2d20 	subcc	r2, pc, #32, 26	; 0x800
    1e40:	62662d20 	rsbvs	r2, r6, #32, 26	; 0x800
    1e44:	646c6975 	strbtvs	r6, [ip], #-2421	; 0xfffff68b
    1e48:	2d676e69 	stclcs	14, cr6, [r7, #-420]!	; 0xfffffe5c
    1e4c:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    1e50:	2d206363 	stccs	3, cr6, [r0, #-396]!	; 0xfffffe74
    1e54:	2d6f6e66 	stclcs	14, cr6, [pc, #-408]!	; 1cc4 <shift+0x1cc4>
    1e58:	63617473 	cmnvs	r1, #1929379840	; 0x73000000
    1e5c:	72702d6b 	rsbsvc	r2, r0, #6848	; 0x1ac0
    1e60:	6365746f 	cmnvs	r5, #1862270976	; 0x6f000000
    1e64:	20726f74 	rsbscs	r6, r2, r4, ror pc
    1e68:	6f6e662d 	svcvs	0x006e662d
    1e6c:	6c6e692d 			; <UNDEFINED> instruction: 0x6c6e692d
    1e70:	20656e69 	rsbcs	r6, r5, r9, ror #28
    1e74:	6976662d 	ldmdbvs	r6!, {r0, r2, r3, r5, r9, sl, sp, lr}^
    1e78:	69626973 	stmdbvs	r2!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
    1e7c:	7974696c 	ldmdbvc	r4!, {r2, r3, r5, r6, r8, fp, sp, lr}^
    1e80:	6469683d 	strbtvs	r6, [r9], #-2109	; 0xfffff7c3
    1e84:	006e6564 	rsbeq	r6, lr, r4, ror #10
    1e88:	5f617369 	svcpl	0x00617369
    1e8c:	5f746962 	svcpl	0x00746962
    1e90:	76696474 			; <UNDEFINED> instruction: 0x76696474
    1e94:	6e6f6300 	cdpvs	3, 6, cr6, cr15, cr0, {0}
    1e98:	73690073 	cmnvc	r9, #115	; 0x73
    1e9c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1ea0:	77695f74 			; <UNDEFINED> instruction: 0x77695f74
    1ea4:	74786d6d 	ldrbtvc	r6, [r8], #-3437	; 0xfffff293
    1ea8:	43504600 	cmpmi	r0, #0, 12
    1eac:	5f535458 	svcpl	0x00535458
    1eb0:	4d554e45 	ldclmi	14, cr4, [r5, #-276]	; 0xfffffeec
    1eb4:	61736900 	cmnvs	r3, r0, lsl #18
    1eb8:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1ebc:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1ec0:	69003676 	stmdbvs	r0, {r1, r2, r4, r5, r6, r9, sl, ip, sp}
    1ec4:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1ec8:	6d5f7469 	cfldrdvs	mvd7, [pc, #-420]	; 1d2c <shift+0x1d2c>
    1ecc:	69006576 	stmdbvs	r0, {r1, r2, r4, r5, r6, r8, sl, sp, lr}
    1ed0:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1ed4:	695f7469 	ldmdbvs	pc, {r0, r3, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
    1ed8:	786d6d77 	stmdavc	sp!, {r0, r1, r2, r4, r5, r6, r8, sl, fp, sp, lr}^
    1edc:	69003274 	stmdbvs	r0, {r2, r4, r5, r6, r9, ip, sp}
    1ee0:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1ee4:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
    1ee8:	70636564 	rsbvc	r6, r3, r4, ror #10
    1eec:	73690030 	cmnvc	r9, #48	; 0x30
    1ef0:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1ef4:	64635f74 	strbtvs	r5, [r3], #-3956	; 0xfffff08c
    1ef8:	31706365 	cmncc	r0, r5, ror #6
    1efc:	61736900 	cmnvs	r3, r0, lsl #18
    1f00:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1f04:	6564635f 	strbvs	r6, [r4, #-863]!	; 0xfffffca1
    1f08:	00327063 	eorseq	r7, r2, r3, rrx
    1f0c:	5f617369 	svcpl	0x00617369
    1f10:	5f746962 	svcpl	0x00746962
    1f14:	63656463 	cmnvs	r5, #1660944384	; 0x63000000
    1f18:	69003370 	stmdbvs	r0, {r4, r5, r6, r8, r9, ip, sp}
    1f1c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1f20:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
    1f24:	70636564 	rsbvc	r6, r3, r4, ror #10
    1f28:	73690034 	cmnvc	r9, #52	; 0x34
    1f2c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1f30:	70665f74 	rsbvc	r5, r6, r4, ror pc
    1f34:	6c62645f 	cfstrdvs	mvd6, [r2], #-380	; 0xfffffe84
    1f38:	61736900 	cmnvs	r3, r0, lsl #18
    1f3c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1f40:	6564635f 	strbvs	r6, [r4, #-863]!	; 0xfffffca1
    1f44:	00367063 	eorseq	r7, r6, r3, rrx
    1f48:	5f617369 	svcpl	0x00617369
    1f4c:	5f746962 	svcpl	0x00746962
    1f50:	63656463 	cmnvs	r5, #1660944384	; 0x63000000
    1f54:	69003770 	stmdbvs	r0, {r4, r5, r6, r8, r9, sl, ip, sp}
    1f58:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1f5c:	615f7469 	cmpvs	pc, r9, ror #8
    1f60:	36766d72 			; <UNDEFINED> instruction: 0x36766d72
    1f64:	7369006b 	cmnvc	r9, #107	; 0x6b
    1f68:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1f6c:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    1f70:	5f38766d 	svcpl	0x0038766d
    1f74:	6d5f6d31 	ldclvs	13, cr6, [pc, #-196]	; 1eb8 <shift+0x1eb8>
    1f78:	006e6961 	rsbeq	r6, lr, r1, ror #18
    1f7c:	65746e61 	ldrbvs	r6, [r4, #-3681]!	; 0xfffff19f
    1f80:	61736900 	cmnvs	r3, r0, lsl #18
    1f84:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1f88:	736d635f 	cmnvc	sp, #2080374785	; 0x7c000001
    1f8c:	6f6c0065 	svcvs	0x006c0065
    1f90:	6420676e 	strtvs	r6, [r0], #-1902	; 0xfffff892
    1f94:	6c62756f 	cfstr64vs	mvdx7, [r2], #-444	; 0xfffffe44
    1f98:	2e2e0065 	cdpcs	0, 2, cr0, cr14, cr5, {3}
    1f9c:	2f2e2e2f 	svccs	0x002e2e2f
    1fa0:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1fa4:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1fa8:	2f2e2e2f 	svccs	0x002e2e2f
    1fac:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    1fb0:	6c2f6363 	stcvs	3, cr6, [pc], #-396	; 1e2c <shift+0x1e2c>
    1fb4:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    1fb8:	632e3263 			; <UNDEFINED> instruction: 0x632e3263
    1fbc:	61736900 	cmnvs	r3, r0, lsl #18
    1fc0:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1fc4:	7670665f 			; <UNDEFINED> instruction: 0x7670665f
    1fc8:	73690035 	cmnvc	r9, #53	; 0x35
    1fcc:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1fd0:	73785f74 	cmnvc	r8, #116, 30	; 0x1d0
    1fd4:	656c6163 	strbvs	r6, [ip, #-355]!	; 0xfffffe9d
    1fd8:	6e6f6c00 	cdpvs	12, 6, cr6, cr15, cr0, {0}
    1fdc:	6f6c2067 	svcvs	0x006c2067
    1fe0:	7520676e 	strvc	r6, [r0, #-1902]!	; 0xfffff892
    1fe4:	6769736e 	strbvs	r7, [r9, -lr, ror #6]!
    1fe8:	2064656e 	rsbcs	r6, r4, lr, ror #10
    1fec:	00746e69 	rsbseq	r6, r4, r9, ror #28
    1ff0:	5f617369 	svcpl	0x00617369
    1ff4:	5f746962 	svcpl	0x00746962
    1ff8:	72697571 	rsbvc	r7, r9, #473956352	; 0x1c400000
    1ffc:	6d635f6b 	stclvs	15, cr5, [r3, #-428]!	; 0xfffffe54
    2000:	646c5f33 	strbtvs	r5, [ip], #-3891	; 0xfffff0cd
    2004:	69006472 	stmdbvs	r0, {r1, r4, r5, r6, sl, sp, lr}
    2008:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    200c:	695f7469 	ldmdbvs	pc, {r0, r3, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
    2010:	006d6d38 	rsbeq	r6, sp, r8, lsr sp
    2014:	5f617369 	svcpl	0x00617369
    2018:	5f746962 	svcpl	0x00746962
    201c:	645f7066 	ldrbvs	r7, [pc], #-102	; 2024 <shift+0x2024>
    2020:	69003233 	stmdbvs	r0, {r0, r1, r4, r5, r9, ip, sp}
    2024:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2028:	615f7469 	cmpvs	pc, r9, ror #8
    202c:	37766d72 			; <UNDEFINED> instruction: 0x37766d72
    2030:	69006d65 	stmdbvs	r0, {r0, r2, r5, r6, r8, sl, fp, sp, lr}
    2034:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2038:	6c5f7469 	cfldrdvs	mvd7, [pc], {105}	; 0x69
    203c:	00656170 	rsbeq	r6, r5, r0, ror r1
    2040:	5f6c6c61 	svcpl	0x006c6c61
    2044:	6c706d69 	ldclvs	13, cr6, [r0], #-420	; 0xfffffe5c
    2048:	5f646569 	svcpl	0x00646569
    204c:	74696266 	strbtvc	r6, [r9], #-614	; 0xfffffd9a
    2050:	73690073 	cmnvc	r9, #115	; 0x73
    2054:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2058:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    205c:	5f38766d 	svcpl	0x0038766d
    2060:	73690031 	cmnvc	r9, #49	; 0x31
    2064:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2068:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    206c:	5f38766d 	svcpl	0x0038766d
    2070:	73690032 	cmnvc	r9, #50	; 0x32
    2074:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2078:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    207c:	5f38766d 	svcpl	0x0038766d
    2080:	73690033 	cmnvc	r9, #51	; 0x33
    2084:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2088:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    208c:	5f38766d 	svcpl	0x0038766d
    2090:	73690034 	cmnvc	r9, #52	; 0x34
    2094:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2098:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    209c:	5f38766d 	svcpl	0x0038766d
    20a0:	73690035 	cmnvc	r9, #53	; 0x35
    20a4:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    20a8:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    20ac:	5f38766d 	svcpl	0x0038766d
    20b0:	73690036 	cmnvc	r9, #54	; 0x36
    20b4:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    20b8:	62735f74 	rsbsvs	r5, r3, #116, 30	; 0x1d0
    20bc:	61736900 	cmnvs	r3, r0, lsl #18
    20c0:	6d756e5f 	ldclvs	14, cr6, [r5, #-380]!	; 0xfffffe84
    20c4:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    20c8:	73690073 	cmnvc	r9, #115	; 0x73
    20cc:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    20d0:	6d735f74 	ldclvs	15, cr5, [r3, #-464]!	; 0xfffffe30
    20d4:	6d6c6c61 	stclvs	12, cr6, [ip, #-388]!	; 0xfffffe7c
    20d8:	66006c75 			; <UNDEFINED> instruction: 0x66006c75
    20dc:	5f636e75 	svcpl	0x00636e75
    20e0:	00727470 	rsbseq	r7, r2, r0, ror r4
    20e4:	706d6f63 	rsbvc	r6, sp, r3, ror #30
    20e8:	2078656c 	rsbscs	r6, r8, ip, ror #10
    20ec:	62756f64 	rsbsvs	r6, r5, #100, 30	; 0x190
    20f0:	4e00656c 	cfsh32mi	mvfx6, mvfx0, #60
    20f4:	50465f42 	subpl	r5, r6, r2, asr #30
    20f8:	5359535f 	cmppl	r9, #2080374785	; 0x7c000001
    20fc:	53474552 	movtpl	r4, #30034	; 0x7552
    2100:	61736900 	cmnvs	r3, r0, lsl #18
    2104:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2108:	6564635f 	strbvs	r6, [r4, #-863]!	; 0xfffffca1
    210c:	00357063 	eorseq	r7, r5, r3, rrx
    2110:	5f617369 	svcpl	0x00617369
    2114:	5f746962 	svcpl	0x00746962
    2118:	76706676 			; <UNDEFINED> instruction: 0x76706676
    211c:	73690032 	cmnvc	r9, #50	; 0x32
    2120:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2124:	66765f74 	uhsub16vs	r5, r6, r4
    2128:	00337670 	eorseq	r7, r3, r0, ror r6
    212c:	5f617369 	svcpl	0x00617369
    2130:	5f746962 	svcpl	0x00746962
    2134:	76706676 			; <UNDEFINED> instruction: 0x76706676
    2138:	50460034 	subpl	r0, r6, r4, lsr r0
    213c:	4e545843 	cdpmi	8, 5, cr5, cr4, cr3, {2}
    2140:	4e455f53 	mcrmi	15, 2, r5, cr5, cr3, {2}
    2144:	69004d55 	stmdbvs	r0, {r0, r2, r4, r6, r8, sl, fp, lr}
    2148:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    214c:	745f7469 	ldrbvc	r7, [pc], #-1129	; 2154 <shift+0x2154>
    2150:	626d7568 	rsbvs	r7, sp, #104, 10	; 0x1a000000
    2154:	61736900 	cmnvs	r3, r0, lsl #18
    2158:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    215c:	3170665f 	cmncc	r0, pc, asr r6
    2160:	6e6f6336 	mcrvs	3, 3, r6, cr15, cr6, {1}
    2164:	73690076 	cmnvc	r9, #118	; 0x76
    2168:	65665f61 	strbvs	r5, [r6, #-3937]!	; 0xfffff09f
    216c:	72757461 	rsbsvc	r7, r5, #1627389952	; 0x61000000
    2170:	73690065 	cmnvc	r9, #101	; 0x65
    2174:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2178:	6f6e5f74 	svcvs	0x006e5f74
    217c:	69006d74 	stmdbvs	r0, {r2, r4, r5, r6, r8, sl, fp, sp, lr}
    2180:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2184:	715f7469 	cmpvc	pc, r9, ror #8
    2188:	6b726975 	blvs	1c9c764 <__bss_end+0x1c90424>
    218c:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    2190:	7a6b3676 	bvc	1acfb70 <__bss_end+0x1ac3830>
    2194:	61736900 	cmnvs	r3, r0, lsl #18
    2198:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    219c:	6372635f 	cmnvs	r2, #2080374785	; 0x7c000001
    21a0:	69003233 	stmdbvs	r0, {r0, r1, r4, r5, r9, ip, sp}
    21a4:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    21a8:	715f7469 	cmpvc	pc, r9, ror #8
    21ac:	6b726975 	blvs	1c9c788 <__bss_end+0x1c90448>
    21b0:	5f6f6e5f 	svcpl	0x006f6e5f
    21b4:	636d7361 	cmnvs	sp, #-2080374783	; 0x84000001
    21b8:	69007570 	stmdbvs	r0, {r4, r5, r6, r8, sl, ip, sp, lr}
    21bc:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    21c0:	615f7469 	cmpvs	pc, r9, ror #8
    21c4:	34766d72 	ldrbtcc	r6, [r6], #-3442	; 0xfffff28e
    21c8:	61736900 	cmnvs	r3, r0, lsl #18
    21cc:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    21d0:	7568745f 	strbvc	r7, [r8, #-1119]!	; 0xfffffba1
    21d4:	0032626d 	eorseq	r6, r2, sp, ror #4
    21d8:	5f617369 	svcpl	0x00617369
    21dc:	5f746962 	svcpl	0x00746962
    21e0:	00386562 	eorseq	r6, r8, r2, ror #10
    21e4:	5f617369 	svcpl	0x00617369
    21e8:	5f746962 	svcpl	0x00746962
    21ec:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    21f0:	73690037 	cmnvc	r9, #55	; 0x37
    21f4:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    21f8:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    21fc:	0038766d 	eorseq	r7, r8, sp, ror #12
    2200:	5f706676 	svcpl	0x00706676
    2204:	72737973 	rsbsvc	r7, r3, #1884160	; 0x1cc000
    2208:	5f736765 	svcpl	0x00736765
    220c:	6f636e65 	svcvs	0x00636e65
    2210:	676e6964 	strbvs	r6, [lr, -r4, ror #18]!
    2214:	61736900 	cmnvs	r3, r0, lsl #18
    2218:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    221c:	3170665f 	cmncc	r0, pc, asr r6
    2220:	6c6d6636 	stclvs	6, cr6, [sp], #-216	; 0xffffff28
    2224:	61736900 	cmnvs	r3, r0, lsl #18
    2228:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    222c:	746f645f 	strbtvc	r6, [pc], #-1119	; 2234 <shift+0x2234>
    2230:	646f7270 	strbtvs	r7, [pc], #-624	; 2238 <shift+0x2238>
    2234:	665f5f00 	ldrbvs	r5, [pc], -r0, lsl #30
    2238:	6e757869 	cdpvs	8, 7, cr7, cr5, cr9, {3}
    223c:	64667373 	strbtvs	r7, [r6], #-883	; 0xfffffc8d
    2240:	46530069 	ldrbmi	r0, [r3], -r9, rrx
    2244:	65707974 	ldrbvs	r7, [r0, #-2420]!	; 0xfffff68c
    2248:	615f5f00 	cmpvs	pc, r0, lsl #30
    224c:	69626165 	stmdbvs	r2!, {r0, r2, r5, r6, r8, sp, lr}^
    2250:	7532665f 	ldrvc	r6, [r2, #-1631]!	; 0xfffff9a1
    2254:	5f007a6c 	svcpl	0x00007a6c
    2258:	7869665f 	stmdavc	r9!, {r0, r1, r2, r3, r4, r6, r9, sl, sp, lr}^
    225c:	69646673 	stmdbvs	r4!, {r0, r1, r4, r5, r6, r9, sl, sp, lr}^
    2260:	74464400 	strbvc	r4, [r6], #-1024	; 0xfffffc00
    2264:	00657079 	rsbeq	r7, r5, r9, ror r0
    2268:	74495355 	strbvc	r5, [r9], #-853	; 0xfffffcab
    226c:	00657079 	rsbeq	r7, r5, r9, ror r0
    2270:	74494455 	strbvc	r4, [r9], #-1109	; 0xfffffbab
    2274:	00657079 	rsbeq	r7, r5, r9, ror r0
    2278:	20554e47 	subscs	r4, r5, r7, asr #28
    227c:	20373143 	eorscs	r3, r7, r3, asr #2
    2280:	332e3031 			; <UNDEFINED> instruction: 0x332e3031
    2284:	3220312e 	eorcc	r3, r0, #-2147483637	; 0x8000000b
    2288:	30313230 	eorscc	r3, r1, r0, lsr r2
    228c:	20313236 	eorscs	r3, r1, r6, lsr r2
    2290:	6c657228 	sfmvs	f7, 2, [r5], #-160	; 0xffffff60
    2294:	65736165 	ldrbvs	r6, [r3, #-357]!	; 0xfffffe9b
    2298:	6d2d2029 	stcvs	0, cr2, [sp, #-164]!	; 0xffffff5c
    229c:	206d7261 	rsbcs	r7, sp, r1, ror #4
    22a0:	6c666d2d 	stclvs	13, cr6, [r6], #-180	; 0xffffff4c
    22a4:	2d74616f 	ldfcse	f6, [r4, #-444]!	; 0xfffffe44
    22a8:	3d696261 	sfmcc	f6, 2, [r9, #-388]!	; 0xfffffe7c
    22ac:	64726168 	ldrbtvs	r6, [r2], #-360	; 0xfffffe98
    22b0:	616d2d20 	cmnvs	sp, r0, lsr #26
    22b4:	3d686372 	stclcc	3, cr6, [r8, #-456]!	; 0xfffffe38
    22b8:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    22bc:	2b657435 	blcs	195f398 <__bss_end+0x1953058>
    22c0:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
    22c4:	672d2067 	strvs	r2, [sp, -r7, rrx]!
    22c8:	20672d20 	rsbcs	r2, r7, r0, lsr #26
    22cc:	20324f2d 	eorscs	r4, r2, sp, lsr #30
    22d0:	20324f2d 	eorscs	r4, r2, sp, lsr #30
    22d4:	20324f2d 	eorscs	r4, r2, sp, lsr #30
    22d8:	7562662d 	strbvc	r6, [r2, #-1581]!	; 0xfffff9d3
    22dc:	69646c69 	stmdbvs	r4!, {r0, r3, r5, r6, sl, fp, sp, lr}^
    22e0:	6c2d676e 	stcvs	7, cr6, [sp], #-440	; 0xfffffe48
    22e4:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    22e8:	662d2063 	strtvs	r2, [sp], -r3, rrx
    22ec:	732d6f6e 			; <UNDEFINED> instruction: 0x732d6f6e
    22f0:	6b636174 	blvs	18da8c8 <__bss_end+0x18ce588>
    22f4:	6f72702d 	svcvs	0x0072702d
    22f8:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
    22fc:	2d20726f 	sfmcs	f7, 4, [r0, #-444]!	; 0xfffffe44
    2300:	2d6f6e66 	stclcs	14, cr6, [pc, #-408]!	; 2170 <shift+0x2170>
    2304:	696c6e69 	stmdbvs	ip!, {r0, r3, r5, r6, r9, sl, fp, sp, lr}^
    2308:	2d20656e 	cfstr32cs	mvfx6, [r0, #-440]!	; 0xfffffe48
    230c:	63786566 	cmnvs	r8, #427819008	; 0x19800000
    2310:	69747065 	ldmdbvs	r4!, {r0, r2, r5, r6, ip, sp, lr}^
    2314:	20736e6f 	rsbscs	r6, r3, pc, ror #28
    2318:	6976662d 	ldmdbvs	r6!, {r0, r2, r3, r5, r9, sl, sp, lr}^
    231c:	69626973 	stmdbvs	r2!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
    2320:	7974696c 	ldmdbvc	r4!, {r2, r3, r5, r6, r8, fp, sp, lr}^
    2324:	6469683d 	strbtvs	r6, [r9], #-2109	; 0xfffff7c3
    2328:	006e6564 	rsbeq	r6, lr, r4, ror #10
    232c:	64755f5f 	ldrbtvs	r5, [r5], #-3935	; 0xfffff0a1
    2330:	6f6d7669 	svcvs	0x006d7669
    2334:	34696464 	strbtcc	r6, [r9], #-1124	; 0xfffffb9c
    2338:	7a697300 	bvc	1a5ef40 <__bss_end+0x1a52c00>
    233c:	00745f65 	rsbseq	r5, r4, r5, ror #30
    2340:	6975622f 	ldmdbvs	r5!, {r0, r1, r2, r3, r5, r9, sp, lr}^
    2344:	6e2f646c 	cdpvs	4, 2, cr6, cr15, cr12, {3}
    2348:	696c7765 	stmdbvs	ip!, {r0, r2, r5, r6, r8, r9, sl, ip, sp, lr}^
    234c:	42702d62 	rsbsmi	r2, r0, #6272	; 0x1880
    2350:	65643033 	strbvs	r3, [r4, #-51]!	; 0xffffffcd
    2354:	77656e2f 	strbvc	r6, [r5, -pc, lsr #28]!
    2358:	2d62696c 			; <UNDEFINED> instruction: 0x2d62696c
    235c:	2e332e33 	mrccs	14, 1, r2, cr3, cr3, {1}
    2360:	75622f30 	strbvc	r2, [r2, #-3888]!	; 0xfffff0d0
    2364:	2f646c69 	svccs	0x00646c69
    2368:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
    236c:	656e6f6e 	strbvs	r6, [lr, #-3950]!	; 0xfffff092
    2370:	6261652d 	rsbvs	r6, r1, #188743680	; 0xb400000
    2374:	72612f69 	rsbvc	r2, r1, #420	; 0x1a4
    2378:	35762f6d 	ldrbcc	r2, [r6, #-3949]!	; 0xfffff093
    237c:	682f6574 	stmdavs	pc!, {r2, r4, r5, r6, r8, sl, sp, lr}	; <UNPREDICTABLE>
    2380:	2f647261 	svccs	0x00647261
    2384:	6c77656e 	cfldr64vs	mvdx6, [r7], #-440	; 0xfffffe48
    2388:	6c2f6269 	sfmvs	f6, 4, [pc], #-420	; 21ec <shift+0x21ec>
    238c:	2f636269 	svccs	0x00636269
    2390:	69727473 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
    2394:	6100676e 	tstvs	r0, lr, ror #14
    2398:	6e67696c 	vnmulvs.f16	s13, s14, s25	; <UNPREDICTABLE>
    239c:	615f6465 	cmpvs	pc, r5, ror #8
    23a0:	00726464 	rsbseq	r6, r2, r4, ror #8
    23a4:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    23a8:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    23ac:	2f2e2e2f 	svccs	0x002e2e2f
    23b0:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    23b4:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    23b8:	2f2e2e2f 	svccs	0x002e2e2f
    23bc:	6c77656e 	cfldr64vs	mvdx6, [r7], #-440	; 0xfffffe48
    23c0:	6c2f6269 	sfmvs	f6, 4, [pc], #-420	; 2224 <shift+0x2224>
    23c4:	2f636269 	svccs	0x00636269
    23c8:	69727473 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
    23cc:	6d2f676e 	stcvs	7, cr6, [pc, #-440]!	; 221c <shift+0x221c>
    23d0:	65736d65 	ldrbvs	r6, [r3, #-3429]!	; 0xfffff29b
    23d4:	00632e74 	rsbeq	r2, r3, r4, ror lr
    23d8:	20554e47 	subscs	r4, r5, r7, asr #28
    23dc:	20373143 	eorscs	r3, r7, r3, asr #2
    23e0:	332e3031 			; <UNDEFINED> instruction: 0x332e3031
    23e4:	3220312e 	eorcc	r3, r0, #-2147483637	; 0x8000000b
    23e8:	30313230 	eorscc	r3, r1, r0, lsr r2
    23ec:	20313236 	eorscs	r3, r1, r6, lsr r2
    23f0:	6c657228 	sfmvs	f7, 2, [r5], #-160	; 0xffffff60
    23f4:	65736165 	ldrbvs	r6, [r3, #-357]!	; 0xfffffe9b
    23f8:	6d2d2029 	stcvs	0, cr2, [sp, #-164]!	; 0xffffff5c
    23fc:	616f6c66 	cmnvs	pc, r6, ror #24
    2400:	62612d74 	rsbvs	r2, r1, #116, 26	; 0x1d00
    2404:	61683d69 	cmnvs	r8, r9, ror #26
    2408:	2d206472 	cfstrscs	mvf6, [r0, #-456]!	; 0xfffffe38
    240c:	6d72616d 	ldfvse	f6, [r2, #-436]!	; 0xfffffe4c
    2410:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
    2414:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
    2418:	6962612d 	stmdbvs	r2!, {r0, r2, r3, r5, r8, sp, lr}^
    241c:	7261683d 	rsbvc	r6, r1, #3997696	; 0x3d0000
    2420:	6d2d2064 	stcvs	0, cr2, [sp, #-400]!	; 0xfffffe70
    2424:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    2428:	6d72613d 	ldfvse	f6, [r2, #-244]!	; 0xffffff0c
    242c:	65743576 	ldrbvs	r3, [r4, #-1398]!	; 0xfffffa8a
    2430:	2070662b 	rsbscs	r6, r0, fp, lsr #12
    2434:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
    2438:	2d20324f 	sfmcs	f3, 4, [r0, #-316]!	; 0xfffffec4
    243c:	2d6f6e66 	stclcs	14, cr6, [pc, #-408]!	; 22ac <shift+0x22ac>
    2440:	6c697562 	cfstr64vs	mvdx7, [r9], #-392	; 0xfffffe78
    2444:	006e6974 	rsbeq	r6, lr, r4, ror r9
    2448:	736d656d 	cmnvc	sp, #457179136	; 0x1b400000
    244c:	Address 0x000000000000244c is out of bounds.


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
  20:	8b040e42 	blhi	103930 <__bss_end+0xf75f0>
  24:	0b0d4201 	bleq	350830 <__bss_end+0x3444f0>
  28:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
  2c:	00000ecb 	andeq	r0, r0, fp, asr #29
  30:	0000001c 	andeq	r0, r0, ip, lsl r0
  34:	00000000 	andeq	r0, r0, r0
  38:	00008064 	andeq	r8, r0, r4, rrx
  3c:	00000040 	andeq	r0, r0, r0, asr #32
  40:	8b080e42 	blhi	203950 <__bss_end+0x1f7610>
  44:	42018e02 	andmi	r8, r1, #2, 28
  48:	5a040b0c 	bpl	102c80 <__bss_end+0xf6940>
  4c:	00080d0c 	andeq	r0, r8, ip, lsl #26
  50:	0000000c 	andeq	r0, r0, ip
  54:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
  58:	7c020001 	stcvc	0, cr0, [r2], {1}
  5c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
  60:	0000001c 	andeq	r0, r0, ip, lsl r0
  64:	00000050 	andeq	r0, r0, r0, asr r0
  68:	000080a4 	andeq	r8, r0, r4, lsr #1
  6c:	00000038 	andeq	r0, r0, r8, lsr r0
  70:	8b040e42 	blhi	103980 <__bss_end+0xf7640>
  74:	0b0d4201 	bleq	350880 <__bss_end+0x344540>
  78:	420d0d54 	andmi	r0, sp, #84, 26	; 0x1500
  7c:	00000ecb 	andeq	r0, r0, fp, asr #29
  80:	0000001c 	andeq	r0, r0, ip, lsl r0
  84:	00000050 	andeq	r0, r0, r0, asr r0
  88:	000080dc 	ldrdeq	r8, [r0], -ip
  8c:	0000002c 	andeq	r0, r0, ip, lsr #32
  90:	8b040e42 	blhi	1039a0 <__bss_end+0xf7660>
  94:	0b0d4201 	bleq	3508a0 <__bss_end+0x344560>
  98:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
  9c:	00000ecb 	andeq	r0, r0, fp, asr #29
  a0:	0000001c 	andeq	r0, r0, ip, lsl r0
  a4:	00000050 	andeq	r0, r0, r0, asr r0
  a8:	00008108 	andeq	r8, r0, r8, lsl #2
  ac:	00000020 	andeq	r0, r0, r0, lsr #32
  b0:	8b040e42 	blhi	1039c0 <__bss_end+0xf7680>
  b4:	0b0d4201 	bleq	3508c0 <__bss_end+0x344580>
  b8:	420d0d48 	andmi	r0, sp, #72, 26	; 0x1200
  bc:	00000ecb 	andeq	r0, r0, fp, asr #29
  c0:	0000001c 	andeq	r0, r0, ip, lsl r0
  c4:	00000050 	andeq	r0, r0, r0, asr r0
  c8:	00008128 	andeq	r8, r0, r8, lsr #2
  cc:	00000018 	andeq	r0, r0, r8, lsl r0
  d0:	8b040e42 	blhi	1039e0 <__bss_end+0xf76a0>
  d4:	0b0d4201 	bleq	3508e0 <__bss_end+0x3445a0>
  d8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  dc:	00000ecb 	andeq	r0, r0, fp, asr #29
  e0:	0000001c 	andeq	r0, r0, ip, lsl r0
  e4:	00000050 	andeq	r0, r0, r0, asr r0
  e8:	00008140 	andeq	r8, r0, r0, asr #2
  ec:	00000018 	andeq	r0, r0, r8, lsl r0
  f0:	8b040e42 	blhi	103a00 <__bss_end+0xf76c0>
  f4:	0b0d4201 	bleq	350900 <__bss_end+0x3445c0>
  f8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  fc:	00000ecb 	andeq	r0, r0, fp, asr #29
 100:	0000001c 	andeq	r0, r0, ip, lsl r0
 104:	00000050 	andeq	r0, r0, r0, asr r0
 108:	00008158 	andeq	r8, r0, r8, asr r1
 10c:	00000018 	andeq	r0, r0, r8, lsl r0
 110:	8b040e42 	blhi	103a20 <__bss_end+0xf76e0>
 114:	0b0d4201 	bleq	350920 <__bss_end+0x3445e0>
 118:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
 11c:	00000ecb 	andeq	r0, r0, fp, asr #29
 120:	00000014 	andeq	r0, r0, r4, lsl r0
 124:	00000050 	andeq	r0, r0, r0, asr r0
 128:	00008170 	andeq	r8, r0, r0, ror r1
 12c:	0000000c 	andeq	r0, r0, ip
 130:	8b040e42 	blhi	103a40 <__bss_end+0xf7700>
 134:	0b0d4201 	bleq	350940 <__bss_end+0x344600>
 138:	0000001c 	andeq	r0, r0, ip, lsl r0
 13c:	00000050 	andeq	r0, r0, r0, asr r0
 140:	0000817c 	andeq	r8, r0, ip, ror r1
 144:	00000058 	andeq	r0, r0, r8, asr r0
 148:	8b080e42 	blhi	203a58 <__bss_end+0x1f7718>
 14c:	42018e02 	andmi	r8, r1, #2, 28
 150:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 154:	00080d0c 	andeq	r0, r8, ip, lsl #26
 158:	0000001c 	andeq	r0, r0, ip, lsl r0
 15c:	00000050 	andeq	r0, r0, r0, asr r0
 160:	000081d4 	ldrdeq	r8, [r0], -r4
 164:	00000058 	andeq	r0, r0, r8, asr r0
 168:	8b080e42 	blhi	203a78 <__bss_end+0x1f7738>
 16c:	42018e02 	andmi	r8, r1, #2, 28
 170:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 174:	00080d0c 	andeq	r0, r8, ip, lsl #26
 178:	0000000c 	andeq	r0, r0, ip
 17c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 180:	7c020001 	stcvc	0, cr0, [r2], {1}
 184:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 188:	0000001c 	andeq	r0, r0, ip, lsl r0
 18c:	00000178 	andeq	r0, r0, r8, ror r1
 190:	000086b0 			; <UNDEFINED> instruction: 0x000086b0
 194:	00000030 	andeq	r0, r0, r0, lsr r0
 198:	8b080e42 	blhi	203aa8 <__bss_end+0x1f7768>
 19c:	42018e02 	andmi	r8, r1, #2, 28
 1a0:	50040b0c 	andpl	r0, r4, ip, lsl #22
 1a4:	00080d0c 	andeq	r0, r8, ip, lsl #26
 1a8:	0000001c 	andeq	r0, r0, ip, lsl r0
 1ac:	00000178 	andeq	r0, r0, r8, ror r1
 1b0:	000086e0 	andeq	r8, r0, r0, ror #13
 1b4:	00000030 	andeq	r0, r0, r0, lsr r0
 1b8:	8b080e42 	blhi	203ac8 <__bss_end+0x1f7788>
 1bc:	42018e02 	andmi	r8, r1, #2, 28
 1c0:	50040b0c 	andpl	r0, r4, ip, lsl #22
 1c4:	00080d0c 	andeq	r0, r8, ip, lsl #26
 1c8:	0000001c 	andeq	r0, r0, ip, lsl r0
 1cc:	00000178 	andeq	r0, r0, r8, ror r1
 1d0:	0000822c 	andeq	r8, r0, ip, lsr #4
 1d4:	000001a4 	andeq	r0, r0, r4, lsr #3
 1d8:	8b040e42 	blhi	103ae8 <__bss_end+0xf77a8>
 1dc:	0b0d4201 	bleq	3509e8 <__bss_end+0x3446a8>
 1e0:	0d0da602 	stceq	6, cr10, [sp, #-8]
 1e4:	000ecb42 	andeq	ip, lr, r2, asr #22
 1e8:	0000001c 	andeq	r0, r0, ip, lsl r0
 1ec:	00000178 	andeq	r0, r0, r8, ror r1
 1f0:	000083d0 	ldrdeq	r8, [r0], -r0
 1f4:	0000007c 	andeq	r0, r0, ip, ror r0
 1f8:	8b080e42 	blhi	203b08 <__bss_end+0x1f77c8>
 1fc:	42018e02 	andmi	r8, r1, #2, 28
 200:	6c040b0c 			; <UNDEFINED> instruction: 0x6c040b0c
 204:	00080d0c 	andeq	r0, r8, ip, lsl #26
 208:	00000020 	andeq	r0, r0, r0, lsr #32
 20c:	00000178 	andeq	r0, r0, r8, ror r1
 210:	0000844c 	andeq	r8, r0, ip, asr #8
 214:	00000264 	andeq	r0, r0, r4, ror #4
 218:	840c0e42 	strhi	r0, [ip], #-3650	; 0xfffff1be
 21c:	8e028b03 	vmlahi.f64	d8, d2, d3
 220:	0b0c4201 	bleq	310a2c <__bss_end+0x3046ec>
 224:	011e0304 	tsteq	lr, r4, lsl #6
 228:	000c0d0c 	andeq	r0, ip, ip, lsl #26
 22c:	0000000c 	andeq	r0, r0, ip
 230:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 234:	7c020001 	stcvc	0, cr0, [r2], {1}
 238:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 23c:	0000001c 	andeq	r0, r0, ip, lsl r0
 240:	0000022c 	andeq	r0, r0, ip, lsr #4
 244:	000086b0 			; <UNDEFINED> instruction: 0x000086b0
 248:	00000030 	andeq	r0, r0, r0, lsr r0
 24c:	8b080e42 	blhi	203b5c <__bss_end+0x1f781c>
 250:	42018e02 	andmi	r8, r1, #2, 28
 254:	50040b0c 	andpl	r0, r4, ip, lsl #22
 258:	00080d0c 	andeq	r0, r8, ip, lsl #26
 25c:	0000001c 	andeq	r0, r0, ip, lsl r0
 260:	0000022c 	andeq	r0, r0, ip, lsr #4
 264:	000086e0 	andeq	r8, r0, r0, ror #13
 268:	00000030 	andeq	r0, r0, r0, lsr r0
 26c:	8b080e42 	blhi	203b7c <__bss_end+0x1f783c>
 270:	42018e02 	andmi	r8, r1, #2, 28
 274:	50040b0c 	andpl	r0, r4, ip, lsl #22
 278:	00080d0c 	andeq	r0, r8, ip, lsl #26
 27c:	0000001c 	andeq	r0, r0, ip, lsl r0
 280:	0000022c 	andeq	r0, r0, ip, lsr #4
 284:	00009b48 	andeq	r9, r0, r8, asr #22
 288:	00000030 	andeq	r0, r0, r0, lsr r0
 28c:	8b080e42 	blhi	203b9c <__bss_end+0x1f785c>
 290:	42018e02 	andmi	r8, r1, #2, 28
 294:	50040b0c 	andpl	r0, r4, ip, lsl #22
 298:	00080d0c 	andeq	r0, r8, ip, lsl #26
 29c:	0000001c 	andeq	r0, r0, ip, lsl r0
 2a0:	0000022c 	andeq	r0, r0, ip, lsr #4
 2a4:	00008710 	andeq	r8, r0, r0, lsl r7
 2a8:	000000ec 	andeq	r0, r0, ip, ror #1
 2ac:	8b080e42 	blhi	203bbc <__bss_end+0x1f787c>
 2b0:	42018e02 	andmi	r8, r1, #2, 28
 2b4:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 2b8:	080d0c6e 	stmdaeq	sp, {r1, r2, r3, r5, r6, sl, fp}
 2bc:	0000001c 	andeq	r0, r0, ip, lsl r0
 2c0:	0000022c 	andeq	r0, r0, ip, lsr #4
 2c4:	000087fc 	strdeq	r8, [r0], -ip
 2c8:	00000078 	andeq	r0, r0, r8, ror r0
 2cc:	8b040e42 	blhi	103bdc <__bss_end+0xf789c>
 2d0:	0b0d4201 	bleq	350adc <__bss_end+0x34479c>
 2d4:	420d0d6c 	andmi	r0, sp, #108, 26	; 0x1b00
 2d8:	00000ecb 	andeq	r0, r0, fp, asr #29
 2dc:	0000001c 	andeq	r0, r0, ip, lsl r0
 2e0:	0000022c 	andeq	r0, r0, ip, lsr #4
 2e4:	00008874 	andeq	r8, r0, r4, ror r8
 2e8:	000000b8 	strheq	r0, [r0], -r8
 2ec:	8b080e42 	blhi	203bfc <__bss_end+0x1f78bc>
 2f0:	42018e02 	andmi	r8, r1, #2, 28
 2f4:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 2f8:	080d0c56 	stmdaeq	sp, {r1, r2, r4, r6, sl, fp}
 2fc:	0000001c 	andeq	r0, r0, ip, lsl r0
 300:	0000022c 	andeq	r0, r0, ip, lsr #4
 304:	0000892c 	andeq	r8, r0, ip, lsr #18
 308:	00000094 	muleq	r0, r4, r0
 30c:	8b080e42 	blhi	203c1c <__bss_end+0x1f78dc>
 310:	42018e02 	andmi	r8, r1, #2, 28
 314:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 318:	080d0c44 	stmdaeq	sp, {r2, r6, sl, fp}
 31c:	0000001c 	andeq	r0, r0, ip, lsl r0
 320:	0000022c 	andeq	r0, r0, ip, lsr #4
 324:	000089c0 	andeq	r8, r0, r0, asr #19
 328:	00000168 	andeq	r0, r0, r8, ror #2
 32c:	8b080e42 	blhi	203c3c <__bss_end+0x1f78fc>
 330:	42018e02 	andmi	r8, r1, #2, 28
 334:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 338:	080d0cac 	stmdaeq	sp, {r2, r3, r5, r7, sl, fp}
 33c:	0000001c 	andeq	r0, r0, ip, lsl r0
 340:	0000022c 	andeq	r0, r0, ip, lsr #4
 344:	00008b28 	andeq	r8, r0, r8, lsr #22
 348:	000000fc 	strdeq	r0, [r0], -ip
 34c:	8b080e42 	blhi	203c5c <__bss_end+0x1f791c>
 350:	42018e02 	andmi	r8, r1, #2, 28
 354:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 358:	080d0c76 	stmdaeq	sp, {r1, r2, r4, r5, r6, sl, fp}
 35c:	0000001c 	andeq	r0, r0, ip, lsl r0
 360:	0000022c 	andeq	r0, r0, ip, lsr #4
 364:	00008c24 	andeq	r8, r0, r4, lsr #24
 368:	000000e8 	andeq	r0, r0, r8, ror #1
 36c:	8b040e42 	blhi	103c7c <__bss_end+0xf793c>
 370:	0b0d4201 	bleq	350b7c <__bss_end+0x34483c>
 374:	0d0d6c02 	stceq	12, cr6, [sp, #-8]
 378:	000ecb42 	andeq	ip, lr, r2, asr #22
 37c:	0000001c 	andeq	r0, r0, ip, lsl r0
 380:	0000022c 	andeq	r0, r0, ip, lsr #4
 384:	00008d0c 	andeq	r8, r0, ip, lsl #26
 388:	00000158 	andeq	r0, r0, r8, asr r1
 38c:	8b080e42 	blhi	203c9c <__bss_end+0x1f795c>
 390:	42018e02 	andmi	r8, r1, #2, 28
 394:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 398:	080d0ca0 	stmdaeq	sp, {r5, r7, sl, fp}
 39c:	00000020 	andeq	r0, r0, r0, lsr #32
 3a0:	0000022c 	andeq	r0, r0, ip, lsr #4
 3a4:	00008e64 	andeq	r8, r0, r4, ror #28
 3a8:	0000027c 	andeq	r0, r0, ip, ror r2
 3ac:	840c0e42 	strhi	r0, [ip], #-3650	; 0xfffff1be
 3b0:	8e028b03 	vmlahi.f64	d8, d2, d3
 3b4:	0b0c4201 	bleq	310bc0 <__bss_end+0x304880>
 3b8:	01380304 	teqeq	r8, r4, lsl #6
 3bc:	000c0d0c 	andeq	r0, ip, ip, lsl #26
 3c0:	0000001c 	andeq	r0, r0, ip, lsl r0
 3c4:	0000022c 	andeq	r0, r0, ip, lsr #4
 3c8:	000090e0 	andeq	r9, r0, r0, ror #1
 3cc:	00000040 	andeq	r0, r0, r0, asr #32
 3d0:	8b040e42 	blhi	103ce0 <__bss_end+0xf79a0>
 3d4:	0b0d4201 	bleq	350be0 <__bss_end+0x3448a0>
 3d8:	420d0d58 	andmi	r0, sp, #88, 26	; 0x1600
 3dc:	00000ecb 	andeq	r0, r0, fp, asr #29
 3e0:	0000001c 	andeq	r0, r0, ip, lsl r0
 3e4:	0000022c 	andeq	r0, r0, ip, lsr #4
 3e8:	00009120 	andeq	r9, r0, r0, lsr #2
 3ec:	0000006c 	andeq	r0, r0, ip, rrx
 3f0:	8b080e42 	blhi	203d00 <__bss_end+0x1f79c0>
 3f4:	42018e02 	andmi	r8, r1, #2, 28
 3f8:	70040b0c 	andvc	r0, r4, ip, lsl #22
 3fc:	00080d0c 	andeq	r0, r8, ip, lsl #26
 400:	0000001c 	andeq	r0, r0, ip, lsl r0
 404:	0000022c 	andeq	r0, r0, ip, lsr #4
 408:	0000918c 	andeq	r9, r0, ip, lsl #3
 40c:	00000030 	andeq	r0, r0, r0, lsr r0
 410:	8b040e42 	blhi	103d20 <__bss_end+0xf79e0>
 414:	0b0d4201 	bleq	350c20 <__bss_end+0x3448e0>
 418:	420d0d50 	andmi	r0, sp, #80, 26	; 0x1400
 41c:	00000ecb 	andeq	r0, r0, fp, asr #29
 420:	0000001c 	andeq	r0, r0, ip, lsl r0
 424:	0000022c 	andeq	r0, r0, ip, lsr #4
 428:	000091bc 			; <UNDEFINED> instruction: 0x000091bc
 42c:	00000028 	andeq	r0, r0, r8, lsr #32
 430:	8b040e42 	blhi	103d40 <__bss_end+0xf7a00>
 434:	0b0d4201 	bleq	350c40 <__bss_end+0x344900>
 438:	420d0d4c 	andmi	r0, sp, #76, 26	; 0x1300
 43c:	00000ecb 	andeq	r0, r0, fp, asr #29
 440:	00000020 	andeq	r0, r0, r0, lsr #32
 444:	0000022c 	andeq	r0, r0, ip, lsr #4
 448:	000091e4 	andeq	r9, r0, r4, ror #3
 44c:	000002b8 			; <UNDEFINED> instruction: 0x000002b8
 450:	840c0e42 	strhi	r0, [ip], #-3650	; 0xfffff1be
 454:	8e028b03 	vmlahi.f64	d8, d2, d3
 458:	0b0c4201 	bleq	310c64 <__bss_end+0x304924>
 45c:	014e0304 	cmpeq	lr, r4, lsl #6
 460:	000c0d0c 	andeq	r0, ip, ip, lsl #26
 464:	0000001c 	andeq	r0, r0, ip, lsl r0
 468:	0000022c 	andeq	r0, r0, ip, lsr #4
 46c:	0000949c 	muleq	r0, ip, r4
 470:	000000f0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
 474:	8b080e42 	blhi	203d84 <__bss_end+0x1f7a44>
 478:	42018e02 	andmi	r8, r1, #2, 28
 47c:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 480:	080d0c6a 	stmdaeq	sp, {r1, r3, r5, r6, sl, fp}
 484:	0000001c 	andeq	r0, r0, ip, lsl r0
 488:	0000022c 	andeq	r0, r0, ip, lsr #4
 48c:	0000958c 	andeq	r9, r0, ip, lsl #11
 490:	000000b0 	strheq	r0, [r0], -r0	; <UNPREDICTABLE>
 494:	8b080e42 	blhi	203da4 <__bss_end+0x1f7a64>
 498:	42018e02 	andmi	r8, r1, #2, 28
 49c:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 4a0:	080d0c50 	stmdaeq	sp, {r4, r6, sl, fp}
 4a4:	0000001c 	andeq	r0, r0, ip, lsl r0
 4a8:	0000022c 	andeq	r0, r0, ip, lsr #4
 4ac:	0000963c 	andeq	r9, r0, ip, lsr r6
 4b0:	00000134 	andeq	r0, r0, r4, lsr r1
 4b4:	8b080e42 	blhi	203dc4 <__bss_end+0x1f7a84>
 4b8:	42018e02 	andmi	r8, r1, #2, 28
 4bc:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 4c0:	080d0c92 	stmdaeq	sp, {r1, r4, r7, sl, fp}
 4c4:	00000020 	andeq	r0, r0, r0, lsr #32
 4c8:	0000022c 	andeq	r0, r0, ip, lsr #4
 4cc:	00009770 	andeq	r9, r0, r0, ror r7
 4d0:	000000c4 	andeq	r0, r0, r4, asr #1
 4d4:	840c0e42 	strhi	r0, [ip], #-3650	; 0xfffff1be
 4d8:	8e028b03 	vmlahi.f64	d8, d2, d3
 4dc:	0b0c4201 	bleq	310ce8 <__bss_end+0x3049a8>
 4e0:	0c5a0204 	lfmeq	f0, 2, [sl], {4}
 4e4:	00000c0d 	andeq	r0, r0, sp, lsl #24
 4e8:	0000001c 	andeq	r0, r0, ip, lsl r0
 4ec:	0000022c 	andeq	r0, r0, ip, lsr #4
 4f0:	00009834 	andeq	r9, r0, r4, lsr r8
 4f4:	00000034 	andeq	r0, r0, r4, lsr r0
 4f8:	8b080e42 	blhi	203e08 <__bss_end+0x1f7ac8>
 4fc:	42018e02 	andmi	r8, r1, #2, 28
 500:	52040b0c 	andpl	r0, r4, #12, 22	; 0x3000
 504:	00080d0c 	andeq	r0, r8, ip, lsl #26
 508:	00000018 	andeq	r0, r0, r8, lsl r0
 50c:	0000022c 	andeq	r0, r0, ip, lsr #4
 510:	00009868 	andeq	r9, r0, r8, ror #16
 514:	000002e0 	andeq	r0, r0, r0, ror #5
 518:	8b080e42 	blhi	203e28 <__bss_end+0x1f7ae8>
 51c:	42018e02 	andmi	r8, r1, #2, 28
 520:	00040b0c 	andeq	r0, r4, ip, lsl #22
 524:	0000000c 	andeq	r0, r0, ip
 528:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 52c:	7c020001 	stcvc	0, cr0, [r2], {1}
 530:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 534:	0000001c 	andeq	r0, r0, ip, lsl r0
 538:	00000524 	andeq	r0, r0, r4, lsr #10
 53c:	00009b78 	andeq	r9, r0, r8, ror fp
 540:	000001bc 			; <UNDEFINED> instruction: 0x000001bc
 544:	8b040e42 	blhi	103e54 <__bss_end+0xf7b14>
 548:	0b0d4201 	bleq	350d54 <__bss_end+0x344a14>
 54c:	0d0dd602 	stceq	6, cr13, [sp, #-8]
 550:	000ecb42 	andeq	ip, lr, r2, asr #22
 554:	0000001c 	andeq	r0, r0, ip, lsl r0
 558:	00000524 	andeq	r0, r0, r4, lsr #10
 55c:	00009d34 	andeq	r9, r0, r4, lsr sp
 560:	0000007c 	andeq	r0, r0, ip, ror r0
 564:	8b080e42 	blhi	203e74 <__bss_end+0x1f7b34>
 568:	42018e02 	andmi	r8, r1, #2, 28
 56c:	78040b0c 	stmdavc	r4, {r2, r3, r8, r9, fp}
 570:	00080d0c 	andeq	r0, r8, ip, lsl #26
 574:	0000001c 	andeq	r0, r0, ip, lsl r0
 578:	00000524 	andeq	r0, r0, r4, lsr #10
 57c:	00009db0 			; <UNDEFINED> instruction: 0x00009db0
 580:	00000038 	andeq	r0, r0, r8, lsr r0
 584:	8b080e42 	blhi	203e94 <__bss_end+0x1f7b54>
 588:	42018e02 	andmi	r8, r1, #2, 28
 58c:	56040b0c 	strpl	r0, [r4], -ip, lsl #22
 590:	00080d0c 	andeq	r0, r8, ip, lsl #26
 594:	0000000c 	andeq	r0, r0, ip
 598:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 59c:	7c020001 	stcvc	0, cr0, [r2], {1}
 5a0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 5a4:	0000001c 	andeq	r0, r0, ip, lsl r0
 5a8:	00000594 	muleq	r0, r4, r5
 5ac:	00009de8 	andeq	r9, r0, r8, ror #27
 5b0:	00000048 	andeq	r0, r0, r8, asr #32
 5b4:	8b040e42 	blhi	103ec4 <__bss_end+0xf7b84>
 5b8:	0b0d4201 	bleq	350dc4 <__bss_end+0x344a84>
 5bc:	420d0d5c 	andmi	r0, sp, #92, 26	; 0x1700
 5c0:	00000ecb 	andeq	r0, r0, fp, asr #29
 5c4:	0000001c 	andeq	r0, r0, ip, lsl r0
 5c8:	00000594 	muleq	r0, r4, r5
 5cc:	00009e30 	andeq	r9, r0, r0, lsr lr
 5d0:	00000088 	andeq	r0, r0, r8, lsl #1
 5d4:	8b040e42 	blhi	103ee4 <__bss_end+0xf7ba4>
 5d8:	0b0d4201 	bleq	350de4 <__bss_end+0x344aa4>
 5dc:	420d0d7c 	andmi	r0, sp, #124, 26	; 0x1f00
 5e0:	00000ecb 	andeq	r0, r0, fp, asr #29
 5e4:	0000001c 	andeq	r0, r0, ip, lsl r0
 5e8:	00000594 	muleq	r0, r4, r5
 5ec:	00009eb8 			; <UNDEFINED> instruction: 0x00009eb8
 5f0:	00000028 	andeq	r0, r0, r8, lsr #32
 5f4:	8b040e42 	blhi	103f04 <__bss_end+0xf7bc4>
 5f8:	0b0d4201 	bleq	350e04 <__bss_end+0x344ac4>
 5fc:	420d0d4c 	andmi	r0, sp, #76, 26	; 0x1300
 600:	00000ecb 	andeq	r0, r0, fp, asr #29
 604:	0000001c 	andeq	r0, r0, ip, lsl r0
 608:	00000594 	muleq	r0, r4, r5
 60c:	00009ee0 	andeq	r9, r0, r0, ror #29
 610:	00000074 	andeq	r0, r0, r4, ror r0
 614:	8b080e42 	blhi	203f24 <__bss_end+0x1f7be4>
 618:	42018e02 	andmi	r8, r1, #2, 28
 61c:	74040b0c 	strvc	r0, [r4], #-2828	; 0xfffff4f4
 620:	00080d0c 	andeq	r0, r8, ip, lsl #26
 624:	0000001c 	andeq	r0, r0, ip, lsl r0
 628:	00000594 	muleq	r0, r4, r5
 62c:	00009f54 	andeq	r9, r0, r4, asr pc
 630:	0000004c 	andeq	r0, r0, ip, asr #32
 634:	8b080e42 	blhi	203f44 <__bss_end+0x1f7c04>
 638:	42018e02 	andmi	r8, r1, #2, 28
 63c:	5c040b0c 			; <UNDEFINED> instruction: 0x5c040b0c
 640:	00080d0c 	andeq	r0, r8, ip, lsl #26
 644:	00000018 	andeq	r0, r0, r8, lsl r0
 648:	00000594 	muleq	r0, r4, r5
 64c:	00009fa0 	andeq	r9, r0, r0, lsr #31
 650:	0000001c 	andeq	r0, r0, ip, lsl r0
 654:	8b080e42 	blhi	203f64 <__bss_end+0x1f7c24>
 658:	42018e02 	andmi	r8, r1, #2, 28
 65c:	00040b0c 	andeq	r0, r4, ip, lsl #22
 660:	0000000c 	andeq	r0, r0, ip
 664:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 668:	7c020001 	stcvc	0, cr0, [r2], {1}
 66c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 670:	0000001c 	andeq	r0, r0, ip, lsl r0
 674:	00000660 	andeq	r0, r0, r0, ror #12
 678:	00009fc0 	andeq	r9, r0, r0, asr #31
 67c:	00000078 	andeq	r0, r0, r8, ror r0
 680:	8b040e42 	blhi	103f90 <__bss_end+0xf7c50>
 684:	0b0d4201 	bleq	350e90 <__bss_end+0x344b50>
 688:	420d0d74 	andmi	r0, sp, #116, 26	; 0x1d00
 68c:	00000ecb 	andeq	r0, r0, fp, asr #29
 690:	0000001c 	andeq	r0, r0, ip, lsl r0
 694:	00000660 	andeq	r0, r0, r0, ror #12
 698:	0000a038 	andeq	sl, r0, r8, lsr r0
 69c:	00000090 	muleq	r0, r0, r0
 6a0:	8b080e42 	blhi	203fb0 <__bss_end+0x1f7c70>
 6a4:	42018e02 	andmi	r8, r1, #2, 28
 6a8:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 6ac:	080d0c42 	stmdaeq	sp, {r1, r6, sl, fp}
 6b0:	0000001c 	andeq	r0, r0, ip, lsl r0
 6b4:	00000660 	andeq	r0, r0, r0, ror #12
 6b8:	0000a0c8 	andeq	sl, r0, r8, asr #1
 6bc:	00000058 	andeq	r0, r0, r8, asr r0
 6c0:	8b080e42 	blhi	203fd0 <__bss_end+0x1f7c90>
 6c4:	42018e02 	andmi	r8, r1, #2, 28
 6c8:	60040b0c 	andvs	r0, r4, ip, lsl #22
 6cc:	00080d0c 	andeq	r0, r8, ip, lsl #26
 6d0:	0000000c 	andeq	r0, r0, ip
 6d4:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 6d8:	7c020001 	stcvc	0, cr0, [r2], {1}
 6dc:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 6e0:	0000001c 	andeq	r0, r0, ip, lsl r0
 6e4:	000006d0 	ldrdeq	r0, [r0], -r0	; <UNPREDICTABLE>
 6e8:	000086e0 	andeq	r8, r0, r0, ror #13
 6ec:	00000030 	andeq	r0, r0, r0, lsr r0
 6f0:	8b080e42 	blhi	204000 <__bss_end+0x1f7cc0>
 6f4:	42018e02 	andmi	r8, r1, #2, 28
 6f8:	50040b0c 	andpl	r0, r4, ip, lsl #22
 6fc:	00080d0c 	andeq	r0, r8, ip, lsl #26
 700:	0000001c 	andeq	r0, r0, ip, lsl r0
 704:	000006d0 	ldrdeq	r0, [r0], -r0	; <UNPREDICTABLE>
 708:	0000a120 	andeq	sl, r0, r0, lsr #2
 70c:	0000004c 	andeq	r0, r0, ip, asr #32
 710:	8b040e42 	blhi	104020 <__bss_end+0xf7ce0>
 714:	0b0d4201 	bleq	350f20 <__bss_end+0x344be0>
 718:	420d0d5e 	andmi	r0, sp, #6016	; 0x1780
 71c:	00000ecb 	andeq	r0, r0, fp, asr #29
 720:	0000001c 	andeq	r0, r0, ip, lsl r0
 724:	000006d0 	ldrdeq	r0, [r0], -r0	; <UNPREDICTABLE>
 728:	0000a16c 	andeq	sl, r0, ip, ror #2
 72c:	00000040 	andeq	r0, r0, r0, asr #32
 730:	8b040e42 	blhi	104040 <__bss_end+0xf7d00>
 734:	0b0d4201 	bleq	350f40 <__bss_end+0x344c00>
 738:	420d0d58 	andmi	r0, sp, #88, 26	; 0x1600
 73c:	00000ecb 	andeq	r0, r0, fp, asr #29
 740:	0000001c 	andeq	r0, r0, ip, lsl r0
 744:	000006d0 	ldrdeq	r0, [r0], -r0	; <UNPREDICTABLE>
 748:	0000a1ac 	andeq	sl, r0, ip, lsr #3
 74c:	00000038 	andeq	r0, r0, r8, lsr r0
 750:	8b040e42 	blhi	104060 <__bss_end+0xf7d20>
 754:	0b0d4201 	bleq	350f60 <__bss_end+0x344c20>
 758:	420d0d54 	andmi	r0, sp, #84, 26	; 0x1500
 75c:	00000ecb 	andeq	r0, r0, fp, asr #29
 760:	0000001c 	andeq	r0, r0, ip, lsl r0
 764:	000006d0 	ldrdeq	r0, [r0], -r0	; <UNPREDICTABLE>
 768:	0000a1e4 	andeq	sl, r0, r4, ror #3
 76c:	00000054 	andeq	r0, r0, r4, asr r0
 770:	8b040e42 	blhi	104080 <__bss_end+0xf7d40>
 774:	0b0d4201 	bleq	350f80 <__bss_end+0x344c40>
 778:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 77c:	00000ecb 	andeq	r0, r0, fp, asr #29
 780:	0000001c 	andeq	r0, r0, ip, lsl r0
 784:	000006d0 	ldrdeq	r0, [r0], -r0	; <UNPREDICTABLE>
 788:	0000a238 	andeq	sl, r0, r8, lsr r2
 78c:	00000038 	andeq	r0, r0, r8, lsr r0
 790:	8b040e42 	blhi	1040a0 <__bss_end+0xf7d60>
 794:	0b0d4201 	bleq	350fa0 <__bss_end+0x344c60>
 798:	420d0d54 	andmi	r0, sp, #84, 26	; 0x1500
 79c:	00000ecb 	andeq	r0, r0, fp, asr #29
 7a0:	00000020 	andeq	r0, r0, r0, lsr #32
 7a4:	000006d0 	ldrdeq	r0, [r0], -r0	; <UNPREDICTABLE>
 7a8:	0000a270 	andeq	sl, r0, r0, ror r2
 7ac:	00000044 	andeq	r0, r0, r4, asr #32
 7b0:	840c0e42 	strhi	r0, [ip], #-3650	; 0xfffff1be
 7b4:	8e028b03 	vmlahi.f64	d8, d2, d3
 7b8:	0b0c4201 	bleq	310fc4 <__bss_end+0x304c84>
 7bc:	0d0c5c04 	stceq	12, cr5, [ip, #-16]
 7c0:	0000000c 	andeq	r0, r0, ip
 7c4:	0000001c 	andeq	r0, r0, ip, lsl r0
 7c8:	000006d0 	ldrdeq	r0, [r0], -r0	; <UNPREDICTABLE>
 7cc:	0000a2b4 			; <UNDEFINED> instruction: 0x0000a2b4
 7d0:	000001a8 	andeq	r0, r0, r8, lsr #3
 7d4:	8b080e42 	blhi	2040e4 <__bss_end+0x1f7da4>
 7d8:	42018e02 	andmi	r8, r1, #2, 28
 7dc:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 7e0:	080d0cce 	stmdaeq	sp, {r1, r2, r3, r6, r7, sl, fp}
 7e4:	0000001c 	andeq	r0, r0, ip, lsl r0
 7e8:	000006d0 	ldrdeq	r0, [r0], -r0	; <UNPREDICTABLE>
 7ec:	0000a45c 	andeq	sl, r0, ip, asr r4
 7f0:	00000068 	andeq	r0, r0, r8, rrx
 7f4:	8b080e42 	blhi	204104 <__bss_end+0x1f7dc4>
 7f8:	42018e02 	andmi	r8, r1, #2, 28
 7fc:	6e040b0c 	vmlavs.f64	d0, d4, d12
 800:	00080d0c 	andeq	r0, r8, ip, lsl #26
 804:	0000001c 	andeq	r0, r0, ip, lsl r0
 808:	000006d0 	ldrdeq	r0, [r0], -r0	; <UNPREDICTABLE>
 80c:	0000a4c4 	andeq	sl, r0, r4, asr #9
 810:	0000007c 	andeq	r0, r0, ip, ror r0
 814:	8b080e42 	blhi	204124 <__bss_end+0x1f7de4>
 818:	42018e02 	andmi	r8, r1, #2, 28
 81c:	76040b0c 	strvc	r0, [r4], -ip, lsl #22
 820:	00080d0c 	andeq	r0, r8, ip, lsl #26
 824:	0000000c 	andeq	r0, r0, ip
 828:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 82c:	7c020001 	stcvc	0, cr0, [r2], {1}
 830:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 834:	0000001c 	andeq	r0, r0, ip, lsl r0
 838:	00000824 	andeq	r0, r0, r4, lsr #16
 83c:	0000a540 	andeq	sl, r0, r0, asr #10
 840:	0000002c 	andeq	r0, r0, ip, lsr #32
 844:	8b040e42 	blhi	104154 <__bss_end+0xf7e14>
 848:	0b0d4201 	bleq	351054 <__bss_end+0x344d14>
 84c:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 850:	00000ecb 	andeq	r0, r0, fp, asr #29
 854:	0000001c 	andeq	r0, r0, ip, lsl r0
 858:	00000824 	andeq	r0, r0, r4, lsr #16
 85c:	0000a56c 	andeq	sl, r0, ip, ror #10
 860:	0000002c 	andeq	r0, r0, ip, lsr #32
 864:	8b040e42 	blhi	104174 <__bss_end+0xf7e34>
 868:	0b0d4201 	bleq	351074 <__bss_end+0x344d34>
 86c:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 870:	00000ecb 	andeq	r0, r0, fp, asr #29
 874:	0000001c 	andeq	r0, r0, ip, lsl r0
 878:	00000824 	andeq	r0, r0, r4, lsr #16
 87c:	0000a598 	muleq	r0, r8, r5
 880:	0000001c 	andeq	r0, r0, ip, lsl r0
 884:	8b040e42 	blhi	104194 <__bss_end+0xf7e54>
 888:	0b0d4201 	bleq	351094 <__bss_end+0x344d54>
 88c:	420d0d46 	andmi	r0, sp, #4480	; 0x1180
 890:	00000ecb 	andeq	r0, r0, fp, asr #29
 894:	0000001c 	andeq	r0, r0, ip, lsl r0
 898:	00000824 	andeq	r0, r0, r4, lsr #16
 89c:	0000a5b4 			; <UNDEFINED> instruction: 0x0000a5b4
 8a0:	00000044 	andeq	r0, r0, r4, asr #32
 8a4:	8b040e42 	blhi	1041b4 <__bss_end+0xf7e74>
 8a8:	0b0d4201 	bleq	3510b4 <__bss_end+0x344d74>
 8ac:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 8b0:	00000ecb 	andeq	r0, r0, fp, asr #29
 8b4:	0000001c 	andeq	r0, r0, ip, lsl r0
 8b8:	00000824 	andeq	r0, r0, r4, lsr #16
 8bc:	0000a5f8 	strdeq	sl, [r0], -r8
 8c0:	00000050 	andeq	r0, r0, r0, asr r0
 8c4:	8b040e42 	blhi	1041d4 <__bss_end+0xf7e94>
 8c8:	0b0d4201 	bleq	3510d4 <__bss_end+0x344d94>
 8cc:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 8d0:	00000ecb 	andeq	r0, r0, fp, asr #29
 8d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 8d8:	00000824 	andeq	r0, r0, r4, lsr #16
 8dc:	0000a648 	andeq	sl, r0, r8, asr #12
 8e0:	00000050 	andeq	r0, r0, r0, asr r0
 8e4:	8b040e42 	blhi	1041f4 <__bss_end+0xf7eb4>
 8e8:	0b0d4201 	bleq	3510f4 <__bss_end+0x344db4>
 8ec:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 8f0:	00000ecb 	andeq	r0, r0, fp, asr #29
 8f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 8f8:	00000824 	andeq	r0, r0, r4, lsr #16
 8fc:	0000a698 	muleq	r0, r8, r6
 900:	0000002c 	andeq	r0, r0, ip, lsr #32
 904:	8b040e42 	blhi	104214 <__bss_end+0xf7ed4>
 908:	0b0d4201 	bleq	351114 <__bss_end+0x344dd4>
 90c:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 910:	00000ecb 	andeq	r0, r0, fp, asr #29
 914:	0000001c 	andeq	r0, r0, ip, lsl r0
 918:	00000824 	andeq	r0, r0, r4, lsr #16
 91c:	0000a6c4 	andeq	sl, r0, r4, asr #13
 920:	00000050 	andeq	r0, r0, r0, asr r0
 924:	8b040e42 	blhi	104234 <__bss_end+0xf7ef4>
 928:	0b0d4201 	bleq	351134 <__bss_end+0x344df4>
 92c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 930:	00000ecb 	andeq	r0, r0, fp, asr #29
 934:	0000001c 	andeq	r0, r0, ip, lsl r0
 938:	00000824 	andeq	r0, r0, r4, lsr #16
 93c:	0000a714 	andeq	sl, r0, r4, lsl r7
 940:	00000044 	andeq	r0, r0, r4, asr #32
 944:	8b040e42 	blhi	104254 <__bss_end+0xf7f14>
 948:	0b0d4201 	bleq	351154 <__bss_end+0x344e14>
 94c:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 950:	00000ecb 	andeq	r0, r0, fp, asr #29
 954:	0000001c 	andeq	r0, r0, ip, lsl r0
 958:	00000824 	andeq	r0, r0, r4, lsr #16
 95c:	0000a758 	andeq	sl, r0, r8, asr r7
 960:	00000050 	andeq	r0, r0, r0, asr r0
 964:	8b040e42 	blhi	104274 <__bss_end+0xf7f34>
 968:	0b0d4201 	bleq	351174 <__bss_end+0x344e34>
 96c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 970:	00000ecb 	andeq	r0, r0, fp, asr #29
 974:	0000001c 	andeq	r0, r0, ip, lsl r0
 978:	00000824 	andeq	r0, r0, r4, lsr #16
 97c:	0000a7a8 	andeq	sl, r0, r8, lsr #15
 980:	00000054 	andeq	r0, r0, r4, asr r0
 984:	8b040e42 	blhi	104294 <__bss_end+0xf7f54>
 988:	0b0d4201 	bleq	351194 <__bss_end+0x344e54>
 98c:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 990:	00000ecb 	andeq	r0, r0, fp, asr #29
 994:	0000001c 	andeq	r0, r0, ip, lsl r0
 998:	00000824 	andeq	r0, r0, r4, lsr #16
 99c:	0000a7fc 	strdeq	sl, [r0], -ip
 9a0:	0000003c 	andeq	r0, r0, ip, lsr r0
 9a4:	8b040e42 	blhi	1042b4 <__bss_end+0xf7f74>
 9a8:	0b0d4201 	bleq	3511b4 <__bss_end+0x344e74>
 9ac:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 9b0:	00000ecb 	andeq	r0, r0, fp, asr #29
 9b4:	0000001c 	andeq	r0, r0, ip, lsl r0
 9b8:	00000824 	andeq	r0, r0, r4, lsr #16
 9bc:	0000a838 	andeq	sl, r0, r8, lsr r8
 9c0:	0000003c 	andeq	r0, r0, ip, lsr r0
 9c4:	8b040e42 	blhi	1042d4 <__bss_end+0xf7f94>
 9c8:	0b0d4201 	bleq	3511d4 <__bss_end+0x344e94>
 9cc:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 9d0:	00000ecb 	andeq	r0, r0, fp, asr #29
 9d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 9d8:	00000824 	andeq	r0, r0, r4, lsr #16
 9dc:	0000a874 	andeq	sl, r0, r4, ror r8
 9e0:	0000003c 	andeq	r0, r0, ip, lsr r0
 9e4:	8b040e42 	blhi	1042f4 <__bss_end+0xf7fb4>
 9e8:	0b0d4201 	bleq	3511f4 <__bss_end+0x344eb4>
 9ec:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 9f0:	00000ecb 	andeq	r0, r0, fp, asr #29
 9f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 9f8:	00000824 	andeq	r0, r0, r4, lsr #16
 9fc:	0000a8b0 			; <UNDEFINED> instruction: 0x0000a8b0
 a00:	0000003c 	andeq	r0, r0, ip, lsr r0
 a04:	8b040e42 	blhi	104314 <__bss_end+0xf7fd4>
 a08:	0b0d4201 	bleq	351214 <__bss_end+0x344ed4>
 a0c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 a10:	00000ecb 	andeq	r0, r0, fp, asr #29
 a14:	0000001c 	andeq	r0, r0, ip, lsl r0
 a18:	00000824 	andeq	r0, r0, r4, lsr #16
 a1c:	0000a8ec 	andeq	sl, r0, ip, ror #17
 a20:	000000b0 	strheq	r0, [r0], -r0	; <UNPREDICTABLE>
 a24:	8b080e42 	blhi	204334 <__bss_end+0x1f7ff4>
 a28:	42018e02 	andmi	r8, r1, #2, 28
 a2c:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 a30:	080d0c50 	stmdaeq	sp, {r4, r6, sl, fp}
 a34:	0000000c 	andeq	r0, r0, ip
 a38:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 a3c:	7c020001 	stcvc	0, cr0, [r2], {1}
 a40:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 a44:	0000001c 	andeq	r0, r0, ip, lsl r0
 a48:	00000a34 	andeq	r0, r0, r4, lsr sl
 a4c:	0000a9a0 	andeq	sl, r0, r0, lsr #19
 a50:	00000178 	andeq	r0, r0, r8, ror r1
 a54:	8b080e42 	blhi	204364 <__bss_end+0x1f8024>
 a58:	42018e02 	andmi	r8, r1, #2, 28
 a5c:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 a60:	080d0cb4 	stmdaeq	sp, {r2, r4, r5, r7, sl, fp}
 a64:	0000001c 	andeq	r0, r0, ip, lsl r0
 a68:	00000a34 	andeq	r0, r0, r4, lsr sl
 a6c:	0000ab18 	andeq	sl, r0, r8, lsl fp
 a70:	000000cc 	andeq	r0, r0, ip, asr #1
 a74:	8b080e42 	blhi	204384 <__bss_end+0x1f8044>
 a78:	42018e02 	andmi	r8, r1, #2, 28
 a7c:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 a80:	080d0c60 	stmdaeq	sp, {r5, r6, sl, fp}
 a84:	0000001c 	andeq	r0, r0, ip, lsl r0
 a88:	00000a34 	andeq	r0, r0, r4, lsr sl
 a8c:	0000abe4 	andeq	sl, r0, r4, ror #23
 a90:	00000100 	andeq	r0, r0, r0, lsl #2
 a94:	8b040e42 	blhi	1043a4 <__bss_end+0xf8064>
 a98:	0b0d4201 	bleq	3512a4 <__bss_end+0x344f64>
 a9c:	0d0d7802 	stceq	8, cr7, [sp, #-8]
 aa0:	000ecb42 	andeq	ip, lr, r2, asr #22
 aa4:	0000001c 	andeq	r0, r0, ip, lsl r0
 aa8:	00000a34 	andeq	r0, r0, r4, lsr sl
 aac:	0000ace4 	andeq	sl, r0, r4, ror #25
 ab0:	0000015c 	andeq	r0, r0, ip, asr r1
 ab4:	8b040e42 	blhi	1043c4 <__bss_end+0xf8084>
 ab8:	0b0d4201 	bleq	3512c4 <__bss_end+0x344f84>
 abc:	0d0d9c02 	stceq	12, cr9, [sp, #-8]
 ac0:	000ecb42 	andeq	ip, lr, r2, asr #22
 ac4:	0000001c 	andeq	r0, r0, ip, lsl r0
 ac8:	00000a34 	andeq	r0, r0, r4, lsr sl
 acc:	0000ae40 	andeq	sl, r0, r0, asr #28
 ad0:	000000c0 	andeq	r0, r0, r0, asr #1
 ad4:	8b040e42 	blhi	1043e4 <__bss_end+0xf80a4>
 ad8:	0b0d4201 	bleq	3512e4 <__bss_end+0x344fa4>
 adc:	0d0d5802 	stceq	8, cr5, [sp, #-8]
 ae0:	000ecb42 	andeq	ip, lr, r2, asr #22
 ae4:	0000001c 	andeq	r0, r0, ip, lsl r0
 ae8:	00000a34 	andeq	r0, r0, r4, lsr sl
 aec:	0000af00 	andeq	sl, r0, r0, lsl #30
 af0:	000000ac 	andeq	r0, r0, ip, lsr #1
 af4:	8b040e42 	blhi	104404 <__bss_end+0xf80c4>
 af8:	0b0d4201 	bleq	351304 <__bss_end+0x344fc4>
 afc:	0d0d4e02 	stceq	14, cr4, [sp, #-8]
 b00:	000ecb42 	andeq	ip, lr, r2, asr #22
 b04:	0000001c 	andeq	r0, r0, ip, lsl r0
 b08:	00000a34 	andeq	r0, r0, r4, lsr sl
 b0c:	0000afac 	andeq	sl, r0, ip, lsr #31
 b10:	00000054 	andeq	r0, r0, r4, asr r0
 b14:	8b040e42 	blhi	104424 <__bss_end+0xf80e4>
 b18:	0b0d4201 	bleq	351324 <__bss_end+0x344fe4>
 b1c:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 b20:	00000ecb 	andeq	r0, r0, fp, asr #29
 b24:	0000001c 	andeq	r0, r0, ip, lsl r0
 b28:	00000a34 	andeq	r0, r0, r4, lsr sl
 b2c:	0000b000 	andeq	fp, r0, r0
 b30:	000000ac 	andeq	r0, r0, ip, lsr #1
 b34:	8b080e42 	blhi	204444 <__bss_end+0x1f8104>
 b38:	42018e02 	andmi	r8, r1, #2, 28
 b3c:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 b40:	080d0c50 	stmdaeq	sp, {r4, r6, sl, fp}
 b44:	0000001c 	andeq	r0, r0, ip, lsl r0
 b48:	00000a34 	andeq	r0, r0, r4, lsr sl
 b4c:	0000b0ac 	andeq	fp, r0, ip, lsr #1
 b50:	000000d8 	ldrdeq	r0, [r0], -r8
 b54:	8b080e42 	blhi	204464 <__bss_end+0x1f8124>
 b58:	42018e02 	andmi	r8, r1, #2, 28
 b5c:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 b60:	080d0c66 	stmdaeq	sp, {r1, r2, r5, r6, sl, fp}
 b64:	0000001c 	andeq	r0, r0, ip, lsl r0
 b68:	00000a34 	andeq	r0, r0, r4, lsr sl
 b6c:	0000b184 	andeq	fp, r0, r4, lsl #3
 b70:	00000068 	andeq	r0, r0, r8, rrx
 b74:	8b040e42 	blhi	104484 <__bss_end+0xf8144>
 b78:	0b0d4201 	bleq	351384 <__bss_end+0x345044>
 b7c:	420d0d6c 	andmi	r0, sp, #108, 26	; 0x1b00
 b80:	00000ecb 	andeq	r0, r0, fp, asr #29
 b84:	0000001c 	andeq	r0, r0, ip, lsl r0
 b88:	00000a34 	andeq	r0, r0, r4, lsr sl
 b8c:	0000b1ec 	andeq	fp, r0, ip, ror #3
 b90:	00000080 	andeq	r0, r0, r0, lsl #1
 b94:	8b040e42 	blhi	1044a4 <__bss_end+0xf8164>
 b98:	0b0d4201 	bleq	3513a4 <__bss_end+0x345064>
 b9c:	420d0d78 	andmi	r0, sp, #120, 26	; 0x1e00
 ba0:	00000ecb 	andeq	r0, r0, fp, asr #29
 ba4:	0000001c 	andeq	r0, r0, ip, lsl r0
 ba8:	00000a34 	andeq	r0, r0, r4, lsr sl
 bac:	0000b26c 	andeq	fp, r0, ip, ror #4
 bb0:	00000068 	andeq	r0, r0, r8, rrx
 bb4:	8b040e42 	blhi	1044c4 <__bss_end+0xf8184>
 bb8:	0b0d4201 	bleq	3513c4 <__bss_end+0x345084>
 bbc:	420d0d6c 	andmi	r0, sp, #108, 26	; 0x1b00
 bc0:	00000ecb 	andeq	r0, r0, fp, asr #29
 bc4:	0000002c 	andeq	r0, r0, ip, lsr #32
 bc8:	00000a34 	andeq	r0, r0, r4, lsr sl
 bcc:	0000b2d4 	ldrdeq	fp, [r0], -r4
 bd0:	00000328 	andeq	r0, r0, r8, lsr #6
 bd4:	84200e42 	strthi	r0, [r0], #-3650	; 0xfffff1be
 bd8:	86078508 	strhi	r8, [r7], -r8, lsl #10
 bdc:	88058706 	stmdahi	r5, {r1, r2, r8, r9, sl, pc}
 be0:	8b038904 	blhi	e2ff8 <__bss_end+0xd6cb8>
 be4:	42018e02 	andmi	r8, r1, #2, 28
 be8:	03040b0c 	movweq	r0, #19212	; 0x4b0c
 bec:	0d0c018a 	stfeqs	f0, [ip, #-552]	; 0xfffffdd8
 bf0:	00000020 	andeq	r0, r0, r0, lsr #32
 bf4:	0000000c 	andeq	r0, r0, ip
 bf8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 bfc:	7c010001 	stcvc	0, cr0, [r1], {1}
 c00:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 c04:	0000000c 	andeq	r0, r0, ip
 c08:	00000bf4 	strdeq	r0, [r0], -r4
 c0c:	0000b5fc 	strdeq	fp, [r0], -ip
 c10:	000001ec 	andeq	r0, r0, ip, ror #3
 c14:	0000000c 	andeq	r0, r0, ip
 c18:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 c1c:	7c010001 	stcvc	0, cr0, [r1], {1}
 c20:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 c24:	0000000c 	andeq	r0, r0, ip
 c28:	00000c14 	andeq	r0, r0, r4, lsl ip
 c2c:	0000b808 	andeq	fp, r0, r8, lsl #16
 c30:	00000220 	andeq	r0, r0, r0, lsr #4
 c34:	0000000c 	andeq	r0, r0, ip
 c38:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 c3c:	7c020001 	stcvc	0, cr0, [r2], {1}
 c40:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 c44:	00000010 	andeq	r0, r0, r0, lsl r0
 c48:	00000c34 	andeq	r0, r0, r4, lsr ip
 c4c:	0000ba4c 	andeq	fp, r0, ip, asr #20
 c50:	0000019c 	muleq	r0, ip, r1
 c54:	0bce020a 	bleq	ff381484 <__bss_end+0xff375144>
 c58:	00000010 	andeq	r0, r0, r0, lsl r0
 c5c:	00000c34 	andeq	r0, r0, r4, lsr ip
 c60:	0000bbe8 	andeq	fp, r0, r8, ror #23
 c64:	00000028 	andeq	r0, r0, r8, lsr #32
 c68:	000b540a 	andeq	r5, fp, sl, lsl #8
 c6c:	00000010 	andeq	r0, r0, r0, lsl r0
 c70:	00000c34 	andeq	r0, r0, r4, lsr ip
 c74:	0000bc10 	andeq	fp, r0, r0, lsl ip
 c78:	0000008c 	andeq	r0, r0, ip, lsl #1
 c7c:	0b46020a 	bleq	11814ac <__bss_end+0x117516c>
 c80:	0000000c 	andeq	r0, r0, ip
 c84:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 c88:	7c020001 	stcvc	0, cr0, [r2], {1}
 c8c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 c90:	00000030 	andeq	r0, r0, r0, lsr r0
 c94:	00000c80 	andeq	r0, r0, r0, lsl #25
 c98:	0000bc9c 	muleq	r0, ip, ip
 c9c:	000000d4 	ldrdeq	r0, [r0], -r4
 ca0:	8e100e5a 	mrchi	14, 0, r0, cr0, cr10, {2}
 ca4:	460a4a03 	strmi	r4, [sl], -r3, lsl #20
 ca8:	42100ece 	andsmi	r0, r0, #3296	; 0xce0
 cac:	460a4a0b 	strmi	r4, [sl], -fp, lsl #20
 cb0:	4a100ece 	bmi	4047f0 <__bss_end+0x3f84b0>
 cb4:	460a460b 	strmi	r4, [sl], -fp, lsl #12
 cb8:	46100ece 	ldrmi	r0, [r0], -lr, asr #29
 cbc:	0ece4c0b 	cdpeq	12, 12, cr4, cr14, cr11, {0}
 cc0:	00000010 	andeq	r0, r0, r0, lsl r0
 cc4:	0000000c 	andeq	r0, r0, ip
 cc8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 ccc:	7c020001 	stcvc	0, cr0, [r2], {1}
 cd0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 cd4:	00000014 	andeq	r0, r0, r4, lsl r0
 cd8:	00000cc4 	andeq	r0, r0, r4, asr #25
 cdc:	0000bd70 	andeq	fp, r0, r0, ror sp
 ce0:	00000030 	andeq	r0, r0, r0, lsr r0
 ce4:	84080e4e 	strhi	r0, [r8], #-3662	; 0xfffff1b2
 ce8:	00018e02 	andeq	r8, r1, r2, lsl #28
 cec:	0000000c 	andeq	r0, r0, ip
 cf0:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 cf4:	7c020001 	stcvc	0, cr0, [r2], {1}
 cf8:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 cfc:	0000000c 	andeq	r0, r0, ip
 d00:	00000cec 	andeq	r0, r0, ip, ror #25
 d04:	0000bda0 	andeq	fp, r0, r0, lsr #27
 d08:	00000040 	andeq	r0, r0, r0, asr #32
 d0c:	0000000c 	andeq	r0, r0, ip
 d10:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 d14:	7c020001 	stcvc	0, cr0, [r2], {1}
 d18:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 d1c:	00000020 	andeq	r0, r0, r0, lsr #32
 d20:	00000d0c 	andeq	r0, r0, ip, lsl #26
 d24:	0000bde0 	andeq	fp, r0, r0, ror #27
 d28:	00000120 	andeq	r0, r0, r0, lsr #2
 d2c:	841c0e46 	ldrhi	r0, [ip], #-3654	; 0xfffff1ba
 d30:	86068507 	strhi	r8, [r6], -r7, lsl #10
 d34:	88048705 	stmdahi	r4, {r0, r2, r8, r9, sl, pc}
 d38:	8e028903 	vmlahi.f16	s16, s4, s6	; <UNPREDICTABLE>
 d3c:	00000001 	andeq	r0, r0, r1
 d40:	0000000c 	andeq	r0, r0, ip
 d44:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 d48:	7c020001 	stcvc	0, cr0, [r2], {1}
 d4c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 d50:	00000034 	andeq	r0, r0, r4, lsr r0
 d54:	00000d40 	andeq	r0, r0, r0, asr #26
 d58:	0000bf00 	andeq	fp, r0, r0, lsl #30
 d5c:	00000118 	andeq	r0, r0, r8, lsl r1
 d60:	840c0e62 	strhi	r0, [ip], #-3682	; 0xfffff19e
 d64:	8e028503 	cfsh32hi	mvfx8, mvfx2, #3
 d68:	0e4e0201 	cdpeq	2, 4, cr0, cr14, cr1, {0}
 d6c:	cec5c400 	cdpgt	4, 12, cr12, cr5, cr0, {0}
 d70:	840c0e50 	strhi	r0, [ip], #-3664	; 0xfffff1b0
 d74:	8e028503 	cfsh32hi	mvfx8, mvfx2, #3
 d78:	000e4401 	andeq	r4, lr, r1, lsl #8
 d7c:	44cec5c4 	strbmi	ip, [lr], #1476	; 0x5c4
 d80:	03840c0e 	orreq	r0, r4, #3584	; 0xe00
 d84:	018e0285 	orreq	r0, lr, r5, lsl #5

Disassembly of section .debug_ranges:

00000000 <.debug_ranges>:
   0:	0000822c 	andeq	r8, r0, ip, lsr #4
   4:	000086b0 			; <UNDEFINED> instruction: 0x000086b0
   8:	000086b0 			; <UNDEFINED> instruction: 0x000086b0
   c:	000086e0 	andeq	r8, r0, r0, ror #13
  10:	000086e0 	andeq	r8, r0, r0, ror #13
  14:	00008710 	andeq	r8, r0, r0, lsl r7
	...
  20:	00008a24 	andeq	r8, r0, r4, lsr #20
  24:	00008ab4 			; <UNDEFINED> instruction: 0x00008ab4
  28:	00008ac4 	andeq	r8, r0, r4, asr #21
  2c:	00008ac8 	andeq	r8, r0, r8, asr #21
	...
  38:	00008710 	andeq	r8, r0, r0, lsl r7
  3c:	00009b48 	andeq	r9, r0, r8, asr #22
  40:	000086b0 			; <UNDEFINED> instruction: 0x000086b0
  44:	000086e0 	andeq	r8, r0, r0, ror #13
  48:	000086e0 	andeq	r8, r0, r0, ror #13
  4c:	00008710 	andeq	r8, r0, r0, lsl r7
  50:	00009b48 	andeq	r9, r0, r8, asr #22
  54:	00009b78 	andeq	r9, r0, r8, ror fp
	...
  60:	0000a4f0 	strdeq	sl, [r0], -r0
  64:	0000a520 	andeq	sl, r0, r0, lsr #10
  68:	0000a528 	andeq	sl, r0, r8, lsr #10
  6c:	0000a52c 	andeq	sl, r0, ip, lsr #10
	...
  78:	0000a120 	andeq	sl, r0, r0, lsr #2
  7c:	0000a540 	andeq	sl, r0, r0, asr #10
  80:	000086e0 	andeq	r8, r0, r0, ror #13
  84:	00008710 	andeq	r8, r0, r0, lsl r7
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
