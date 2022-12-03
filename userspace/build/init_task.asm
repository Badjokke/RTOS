
./init_task:     file format elf32-littlearm


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
    805c:	00009a70 	andeq	r9, r0, r0, ror sl
    8060:	00009a80 	andeq	r9, r0, r0, lsl #21

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
    81cc:	00009a70 	andeq	r9, r0, r0, ror sl
    81d0:	00009a70 	andeq	r9, r0, r0, ror sl

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
    8224:	00009a70 	andeq	r9, r0, r0, ror sl
    8228:	00009a70 	andeq	r9, r0, r0, ror sl

0000822c <main>:
main():
/home/trefil/sem/sources/userspace/init_task/main.cpp:6
#include <stdfile.h>

#include <process/process_manager.h>

int main(int argc, char** argv)
{
    822c:	e92d4800 	push	{fp, lr}
    8230:	e28db004 	add	fp, sp, #4
    8234:	e24dd008 	sub	sp, sp, #8
    8238:	e50b0008 	str	r0, [fp, #-8]
    823c:	e50b100c 	str	r1, [fp, #-12]
/home/trefil/sem/sources/userspace/init_task/main.cpp:11
	// systemovy init task startuje jako prvni, a ma nejnizsi prioritu ze vsech - bude se tedy planovat v podstate jen tehdy,
	// kdy nic jineho nikdo nema na praci

	// nastavime deadline na "nekonecno" = vlastne snizime dynamickou prioritu na nejnizsi moznou
	set_task_deadline(Indefinite);
    8240:	e3e00000 	mvn	r0, #0
    8244:	eb0000d7 	bl	85a8 <_Z17set_task_deadlinej>
/home/trefil/sem/sources/userspace/init_task/main.cpp:18
	// TODO: tady budeme chtit nechat spoustet zbytek procesu, az budeme umet nacitat treba z eMMC a SD karty
	
	while (true)
	{
		// kdyz je planovany jen tento proces, pockame na udalost (preruseni, ...)
		if (get_active_process_count() == 1)
    8248:	eb0000b8 	bl	8530 <_Z24get_active_process_countv>
    824c:	e1a03000 	mov	r3, r0
    8250:	e3530001 	cmp	r3, #1
    8254:	03a03001 	moveq	r3, #1
    8258:	13a03000 	movne	r3, #0
    825c:	e6ef3073 	uxtb	r3, r3
    8260:	e3530000 	cmp	r3, #0
    8264:	0a000000 	beq	826c <main+0x40>
/home/trefil/sem/sources/userspace/init_task/main.cpp:19
			asm volatile("wfe");
    8268:	e320f002 	wfe
/home/trefil/sem/sources/userspace/init_task/main.cpp:22

		// predame zbytek casoveho kvanta dalsimu procesu
		sched_yield();
    826c:	eb000016 	bl	82cc <_Z11sched_yieldv>
/home/trefil/sem/sources/userspace/init_task/main.cpp:18
		if (get_active_process_count() == 1)
    8270:	eafffff4 	b	8248 <main+0x1c>

00008274 <_Z6getpidv>:
_Z6getpidv():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:5
#include <stdfile.h>
#include <stdstring.h>

uint32_t getpid()
{
    8274:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8278:	e28db000 	add	fp, sp, #0
    827c:	e24dd00c 	sub	sp, sp, #12
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:8
    uint32_t pid;

    asm volatile("swi 0");
    8280:	ef000000 	svc	0x00000000
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:9
    asm volatile("mov %0, r0" : "=r" (pid));
    8284:	e1a03000 	mov	r3, r0
    8288:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:11

    return pid;
    828c:	e51b3008 	ldr	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:12
}
    8290:	e1a00003 	mov	r0, r3
    8294:	e28bd000 	add	sp, fp, #0
    8298:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    829c:	e12fff1e 	bx	lr

000082a0 <_Z9terminatei>:
_Z9terminatei():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:15

void terminate(int exitcode)
{
    82a0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    82a4:	e28db000 	add	fp, sp, #0
    82a8:	e24dd00c 	sub	sp, sp, #12
    82ac:	e50b0008 	str	r0, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:16
    asm volatile("mov r0, %0" : : "r" (exitcode));
    82b0:	e51b3008 	ldr	r3, [fp, #-8]
    82b4:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:17
    asm volatile("swi 1");
    82b8:	ef000001 	svc	0x00000001
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:18
}
    82bc:	e320f000 	nop	{0}
    82c0:	e28bd000 	add	sp, fp, #0
    82c4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    82c8:	e12fff1e 	bx	lr

000082cc <_Z11sched_yieldv>:
_Z11sched_yieldv():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:21

void sched_yield()
{
    82cc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    82d0:	e28db000 	add	fp, sp, #0
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:22
    asm volatile("swi 2");
    82d4:	ef000002 	svc	0x00000002
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:23
}
    82d8:	e320f000 	nop	{0}
    82dc:	e28bd000 	add	sp, fp, #0
    82e0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    82e4:	e12fff1e 	bx	lr

000082e8 <_Z4openPKc15NFile_Open_Mode>:
_Z4openPKc15NFile_Open_Mode():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:26

uint32_t open(const char* filename, NFile_Open_Mode mode)
{
    82e8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    82ec:	e28db000 	add	fp, sp, #0
    82f0:	e24dd014 	sub	sp, sp, #20
    82f4:	e50b0010 	str	r0, [fp, #-16]
    82f8:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:29
    uint32_t file;

    asm volatile("mov r0, %0" : : "r" (filename));
    82fc:	e51b3010 	ldr	r3, [fp, #-16]
    8300:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:30
    asm volatile("mov r1, %0" : : "r" (mode));
    8304:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8308:	e1a01003 	mov	r1, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:31
    asm volatile("swi 64");
    830c:	ef000040 	svc	0x00000040
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:32
    asm volatile("mov %0, r0" : "=r" (file));
    8310:	e1a03000 	mov	r3, r0
    8314:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:34

    return file;
    8318:	e51b3008 	ldr	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:35
}
    831c:	e1a00003 	mov	r0, r3
    8320:	e28bd000 	add	sp, fp, #0
    8324:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8328:	e12fff1e 	bx	lr

0000832c <_Z4readjPcj>:
_Z4readjPcj():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:38

uint32_t read(uint32_t file, char* const buffer, uint32_t size)
{
    832c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8330:	e28db000 	add	fp, sp, #0
    8334:	e24dd01c 	sub	sp, sp, #28
    8338:	e50b0010 	str	r0, [fp, #-16]
    833c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8340:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:41
    uint32_t rdnum;

    asm volatile("mov r0, %0" : : "r" (file));
    8344:	e51b3010 	ldr	r3, [fp, #-16]
    8348:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:42
    asm volatile("mov r1, %0" : : "r" (buffer));
    834c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8350:	e1a01003 	mov	r1, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:43
    asm volatile("mov r2, %0" : : "r" (size));
    8354:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8358:	e1a02003 	mov	r2, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:44
    asm volatile("swi 65");
    835c:	ef000041 	svc	0x00000041
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:45
    asm volatile("mov %0, r0" : "=r" (rdnum));
    8360:	e1a03000 	mov	r3, r0
    8364:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:47

    return rdnum;
    8368:	e51b3008 	ldr	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:48
}
    836c:	e1a00003 	mov	r0, r3
    8370:	e28bd000 	add	sp, fp, #0
    8374:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8378:	e12fff1e 	bx	lr

0000837c <_Z5writejPKcj>:
_Z5writejPKcj():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:52


uint32_t write(uint32_t file, const char* buffer, uint32_t size)
{
    837c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8380:	e28db000 	add	fp, sp, #0
    8384:	e24dd01c 	sub	sp, sp, #28
    8388:	e50b0010 	str	r0, [fp, #-16]
    838c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8390:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:55
    uint32_t wrnum;

    asm volatile("mov r0, %0" : : "r" (file));
    8394:	e51b3010 	ldr	r3, [fp, #-16]
    8398:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:56
    asm volatile("mov r1, %0" : : "r" (buffer));
    839c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    83a0:	e1a01003 	mov	r1, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:57
    asm volatile("mov r2, %0" : : "r" (size));
    83a4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    83a8:	e1a02003 	mov	r2, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:58
    asm volatile("swi 66");
    83ac:	ef000042 	svc	0x00000042
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:59
    asm volatile("mov %0, r0" : "=r" (wrnum));
    83b0:	e1a03000 	mov	r3, r0
    83b4:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:61

    return wrnum;
    83b8:	e51b3008 	ldr	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:62
}
    83bc:	e1a00003 	mov	r0, r3
    83c0:	e28bd000 	add	sp, fp, #0
    83c4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    83c8:	e12fff1e 	bx	lr

000083cc <_Z5closej>:
_Z5closej():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:65

void close(uint32_t file)
{
    83cc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    83d0:	e28db000 	add	fp, sp, #0
    83d4:	e24dd00c 	sub	sp, sp, #12
    83d8:	e50b0008 	str	r0, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:66
    asm volatile("mov r0, %0" : : "r" (file));
    83dc:	e51b3008 	ldr	r3, [fp, #-8]
    83e0:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:67
    asm volatile("swi 67");
    83e4:	ef000043 	svc	0x00000043
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:68
}
    83e8:	e320f000 	nop	{0}
    83ec:	e28bd000 	add	sp, fp, #0
    83f0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    83f4:	e12fff1e 	bx	lr

000083f8 <_Z5ioctlj16NIOCtl_OperationPv>:
_Z5ioctlj16NIOCtl_OperationPv():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:71

uint32_t ioctl(uint32_t file, NIOCtl_Operation operation, void* param)
{
    83f8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    83fc:	e28db000 	add	fp, sp, #0
    8400:	e24dd01c 	sub	sp, sp, #28
    8404:	e50b0010 	str	r0, [fp, #-16]
    8408:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    840c:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:74
    uint32_t retcode;

    asm volatile("mov r0, %0" : : "r" (file));
    8410:	e51b3010 	ldr	r3, [fp, #-16]
    8414:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:75
    asm volatile("mov r1, %0" : : "r" (operation));
    8418:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    841c:	e1a01003 	mov	r1, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:76
    asm volatile("mov r2, %0" : : "r" (param));
    8420:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8424:	e1a02003 	mov	r2, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:77
    asm volatile("swi 68");
    8428:	ef000044 	svc	0x00000044
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:78
    asm volatile("mov %0, r0" : "=r" (retcode));
    842c:	e1a03000 	mov	r3, r0
    8430:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:80

    return retcode;
    8434:	e51b3008 	ldr	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:81
}
    8438:	e1a00003 	mov	r0, r3
    843c:	e28bd000 	add	sp, fp, #0
    8440:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8444:	e12fff1e 	bx	lr

00008448 <_Z6notifyjj>:
_Z6notifyjj():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:84

uint32_t notify(uint32_t file, uint32_t count)
{
    8448:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    844c:	e28db000 	add	fp, sp, #0
    8450:	e24dd014 	sub	sp, sp, #20
    8454:	e50b0010 	str	r0, [fp, #-16]
    8458:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:87
    uint32_t retcnt;

    asm volatile("mov r0, %0" : : "r" (file));
    845c:	e51b3010 	ldr	r3, [fp, #-16]
    8460:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:88
    asm volatile("mov r1, %0" : : "r" (count));
    8464:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8468:	e1a01003 	mov	r1, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:89
    asm volatile("swi 69");
    846c:	ef000045 	svc	0x00000045
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:90
    asm volatile("mov %0, r0" : "=r" (retcnt));
    8470:	e1a03000 	mov	r3, r0
    8474:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:92

    return retcnt;
    8478:	e51b3008 	ldr	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:93
}
    847c:	e1a00003 	mov	r0, r3
    8480:	e28bd000 	add	sp, fp, #0
    8484:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8488:	e12fff1e 	bx	lr

0000848c <_Z4waitjjj>:
_Z4waitjjj():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:96

NSWI_Result_Code wait(uint32_t file, uint32_t count, uint32_t notified_deadline)
{
    848c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8490:	e28db000 	add	fp, sp, #0
    8494:	e24dd01c 	sub	sp, sp, #28
    8498:	e50b0010 	str	r0, [fp, #-16]
    849c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    84a0:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:99
    NSWI_Result_Code retcode;

    asm volatile("mov r0, %0" : : "r" (file));
    84a4:	e51b3010 	ldr	r3, [fp, #-16]
    84a8:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:100
    asm volatile("mov r1, %0" : : "r" (count));
    84ac:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    84b0:	e1a01003 	mov	r1, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:101
    asm volatile("mov r2, %0" : : "r" (notified_deadline));
    84b4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    84b8:	e1a02003 	mov	r2, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:102
    asm volatile("swi 70");
    84bc:	ef000046 	svc	0x00000046
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:103
    asm volatile("mov %0, r0" : "=r" (retcode));
    84c0:	e1a03000 	mov	r3, r0
    84c4:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:105

    return retcode;
    84c8:	e51b3008 	ldr	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:106
}
    84cc:	e1a00003 	mov	r0, r3
    84d0:	e28bd000 	add	sp, fp, #0
    84d4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    84d8:	e12fff1e 	bx	lr

000084dc <_Z5sleepjj>:
_Z5sleepjj():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:109

bool sleep(uint32_t ticks, uint32_t notified_deadline)
{
    84dc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    84e0:	e28db000 	add	fp, sp, #0
    84e4:	e24dd014 	sub	sp, sp, #20
    84e8:	e50b0010 	str	r0, [fp, #-16]
    84ec:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:112
    uint32_t retcode;

    asm volatile("mov r0, %0" : : "r" (ticks));
    84f0:	e51b3010 	ldr	r3, [fp, #-16]
    84f4:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:113
    asm volatile("mov r1, %0" : : "r" (notified_deadline));
    84f8:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    84fc:	e1a01003 	mov	r1, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:114
    asm volatile("swi 3");
    8500:	ef000003 	svc	0x00000003
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:115
    asm volatile("mov %0, r0" : "=r" (retcode));
    8504:	e1a03000 	mov	r3, r0
    8508:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:117

    return retcode;
    850c:	e51b3008 	ldr	r3, [fp, #-8]
    8510:	e3530000 	cmp	r3, #0
    8514:	13a03001 	movne	r3, #1
    8518:	03a03000 	moveq	r3, #0
    851c:	e6ef3073 	uxtb	r3, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:118
}
    8520:	e1a00003 	mov	r0, r3
    8524:	e28bd000 	add	sp, fp, #0
    8528:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    852c:	e12fff1e 	bx	lr

00008530 <_Z24get_active_process_countv>:
_Z24get_active_process_countv():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:121

uint32_t get_active_process_count()
{
    8530:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8534:	e28db000 	add	fp, sp, #0
    8538:	e24dd00c 	sub	sp, sp, #12
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:122
    const NGet_Sched_Info_Type req = NGet_Sched_Info_Type::Active_Process_Count;
    853c:	e3a03000 	mov	r3, #0
    8540:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:125
    uint32_t retval;

    asm volatile("mov r0, %0" : : "r" (req));
    8544:	e3a03000 	mov	r3, #0
    8548:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:126
    asm volatile("mov r1, %0" : : "r" (&retval));
    854c:	e24b300c 	sub	r3, fp, #12
    8550:	e1a01003 	mov	r1, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:127
    asm volatile("swi 4");
    8554:	ef000004 	svc	0x00000004
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:129

    return retval;
    8558:	e51b300c 	ldr	r3, [fp, #-12]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:130
}
    855c:	e1a00003 	mov	r0, r3
    8560:	e28bd000 	add	sp, fp, #0
    8564:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8568:	e12fff1e 	bx	lr

0000856c <_Z14get_tick_countv>:
_Z14get_tick_countv():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:133

uint32_t get_tick_count()
{
    856c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8570:	e28db000 	add	fp, sp, #0
    8574:	e24dd00c 	sub	sp, sp, #12
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:134
    const NGet_Sched_Info_Type req = NGet_Sched_Info_Type::Tick_Count;
    8578:	e3a03001 	mov	r3, #1
    857c:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:137
    uint32_t retval;

    asm volatile("mov r0, %0" : : "r" (req));
    8580:	e3a03001 	mov	r3, #1
    8584:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:138
    asm volatile("mov r1, %0" : : "r" (&retval));
    8588:	e24b300c 	sub	r3, fp, #12
    858c:	e1a01003 	mov	r1, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:139
    asm volatile("swi 4");
    8590:	ef000004 	svc	0x00000004
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:141

    return retval;
    8594:	e51b300c 	ldr	r3, [fp, #-12]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:142
}
    8598:	e1a00003 	mov	r0, r3
    859c:	e28bd000 	add	sp, fp, #0
    85a0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    85a4:	e12fff1e 	bx	lr

000085a8 <_Z17set_task_deadlinej>:
_Z17set_task_deadlinej():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:145

void set_task_deadline(uint32_t tick_count_required)
{
    85a8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    85ac:	e28db000 	add	fp, sp, #0
    85b0:	e24dd014 	sub	sp, sp, #20
    85b4:	e50b0010 	str	r0, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:146
    const NDeadline_Subservice req = NDeadline_Subservice::Set_Relative;
    85b8:	e3a03000 	mov	r3, #0
    85bc:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:148

    asm volatile("mov r0, %0" : : "r" (req));
    85c0:	e3a03000 	mov	r3, #0
    85c4:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:149
    asm volatile("mov r1, %0" : : "r" (&tick_count_required));
    85c8:	e24b3010 	sub	r3, fp, #16
    85cc:	e1a01003 	mov	r1, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:150
    asm volatile("swi 5");
    85d0:	ef000005 	svc	0x00000005
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:151
}
    85d4:	e320f000 	nop	{0}
    85d8:	e28bd000 	add	sp, fp, #0
    85dc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    85e0:	e12fff1e 	bx	lr

000085e4 <_Z26get_task_ticks_to_deadlinev>:
_Z26get_task_ticks_to_deadlinev():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:154

uint32_t get_task_ticks_to_deadline()
{
    85e4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    85e8:	e28db000 	add	fp, sp, #0
    85ec:	e24dd00c 	sub	sp, sp, #12
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:155
    const NDeadline_Subservice req = NDeadline_Subservice::Get_Remaining;
    85f0:	e3a03001 	mov	r3, #1
    85f4:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:158
    uint32_t ticks;

    asm volatile("mov r0, %0" : : "r" (req));
    85f8:	e3a03001 	mov	r3, #1
    85fc:	e1a00003 	mov	r0, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:159
    asm volatile("mov r1, %0" : : "r" (&ticks));
    8600:	e24b300c 	sub	r3, fp, #12
    8604:	e1a01003 	mov	r1, r3
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:160
    asm volatile("swi 5");
    8608:	ef000005 	svc	0x00000005
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:162

    return ticks;
    860c:	e51b300c 	ldr	r3, [fp, #-12]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:163
}
    8610:	e1a00003 	mov	r0, r3
    8614:	e28bd000 	add	sp, fp, #0
    8618:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    861c:	e12fff1e 	bx	lr

00008620 <_Z4pipePKcj>:
_Z4pipePKcj():
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:168

const char Pipe_File_Prefix[] = "SYS:pipe/";

uint32_t pipe(const char* name, uint32_t buf_size)
{
    8620:	e92d4800 	push	{fp, lr}
    8624:	e28db004 	add	fp, sp, #4
    8628:	e24dd050 	sub	sp, sp, #80	; 0x50
    862c:	e50b0050 	str	r0, [fp, #-80]	; 0xffffffb0
    8630:	e50b1054 	str	r1, [fp, #-84]	; 0xffffffac
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:170
    char fname[64];
    strncpy(fname, Pipe_File_Prefix, sizeof(Pipe_File_Prefix));
    8634:	e24b3048 	sub	r3, fp, #72	; 0x48
    8638:	e3a0200a 	mov	r2, #10
    863c:	e59f1088 	ldr	r1, [pc, #136]	; 86cc <_Z4pipePKcj+0xac>
    8640:	e1a00003 	mov	r0, r3
    8644:	eb000149 	bl	8b70 <_Z7strncpyPcPKci>
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:171
    strncpy(fname + sizeof(Pipe_File_Prefix), name, sizeof(fname) - sizeof(Pipe_File_Prefix) - 1);
    8648:	e24b3048 	sub	r3, fp, #72	; 0x48
    864c:	e283300a 	add	r3, r3, #10
    8650:	e3a02035 	mov	r2, #53	; 0x35
    8654:	e51b1050 	ldr	r1, [fp, #-80]	; 0xffffffb0
    8658:	e1a00003 	mov	r0, r3
    865c:	eb000143 	bl	8b70 <_Z7strncpyPcPKci>
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:173

    int ncur = sizeof(Pipe_File_Prefix) + strlen(name);
    8660:	e51b0050 	ldr	r0, [fp, #-80]	; 0xffffffb0
    8664:	eb00019c 	bl	8cdc <_Z6strlenPKc>
    8668:	e1a03000 	mov	r3, r0
    866c:	e283300a 	add	r3, r3, #10
    8670:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:175

    fname[ncur++] = '#';
    8674:	e51b3008 	ldr	r3, [fp, #-8]
    8678:	e2832001 	add	r2, r3, #1
    867c:	e50b2008 	str	r2, [fp, #-8]
    8680:	e2433004 	sub	r3, r3, #4
    8684:	e083300b 	add	r3, r3, fp
    8688:	e3a02023 	mov	r2, #35	; 0x23
    868c:	e5432044 	strb	r2, [r3, #-68]	; 0xffffffbc
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:177

    itoa(buf_size, &fname[ncur], 10);
    8690:	e51b0054 	ldr	r0, [fp, #-84]	; 0xffffffac
    8694:	e24b2048 	sub	r2, fp, #72	; 0x48
    8698:	e51b3008 	ldr	r3, [fp, #-8]
    869c:	e0823003 	add	r3, r2, r3
    86a0:	e3a0200a 	mov	r2, #10
    86a4:	e1a01003 	mov	r1, r3
    86a8:	eb000008 	bl	86d0 <_Z4itoaiPcj>
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:179

    return open(fname, NFile_Open_Mode::Read_Write);
    86ac:	e24b3048 	sub	r3, fp, #72	; 0x48
    86b0:	e3a01002 	mov	r1, #2
    86b4:	e1a00003 	mov	r0, r3
    86b8:	ebffff0a 	bl	82e8 <_Z4openPKc15NFile_Open_Mode>
    86bc:	e1a03000 	mov	r3, r0
/home/trefil/sem/sources/stdlib/src/stdfile.cpp:180
}
    86c0:	e1a00003 	mov	r0, r3
    86c4:	e24bd004 	sub	sp, fp, #4
    86c8:	e8bd8800 	pop	{fp, pc}
    86cc:	00009a48 	andeq	r9, r0, r8, asr #20

000086d0 <_Z4itoaiPcj>:
_Z4itoaiPcj():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:9
{
    const char CharConvArr[] = "0123456789ABCDEF";
}

void itoa(int input, char* output, unsigned int base)
{
    86d0:	e92d4800 	push	{fp, lr}
    86d4:	e28db004 	add	fp, sp, #4
    86d8:	e24dd020 	sub	sp, sp, #32
    86dc:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    86e0:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    86e4:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:10
    int i = 0;
    86e8:	e3a03000 	mov	r3, #0
    86ec:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:11
    int j = 0;
    86f0:	e3a03000 	mov	r3, #0
    86f4:	e50b300c 	str	r3, [fp, #-12]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:13

	while (input > 0)
    86f8:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    86fc:	e3530000 	cmp	r3, #0
    8700:	da000015 	ble	875c <_Z4itoaiPcj+0x8c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:15
	{
		output[i] = CharConvArr[input % base];
    8704:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8708:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    870c:	e1a00003 	mov	r0, r3
    8710:	eb000380 	bl	9518 <__aeabi_uidivmod>
    8714:	e1a03001 	mov	r3, r1
    8718:	e1a01003 	mov	r1, r3
    871c:	e51b3008 	ldr	r3, [fp, #-8]
    8720:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8724:	e0823003 	add	r3, r2, r3
    8728:	e59f2114 	ldr	r2, [pc, #276]	; 8844 <_Z4itoaiPcj+0x174>
    872c:	e7d22001 	ldrb	r2, [r2, r1]
    8730:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:16
		input /= base;
    8734:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8738:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    873c:	e1a00003 	mov	r0, r3
    8740:	eb0002f9 	bl	932c <__udivsi3>
    8744:	e1a03000 	mov	r3, r0
    8748:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:17
		i++;
    874c:	e51b3008 	ldr	r3, [fp, #-8]
    8750:	e2833001 	add	r3, r3, #1
    8754:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:13
	while (input > 0)
    8758:	eaffffe6 	b	86f8 <_Z4itoaiPcj+0x28>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:20
	}

    if (i == 0)
    875c:	e51b3008 	ldr	r3, [fp, #-8]
    8760:	e3530000 	cmp	r3, #0
    8764:	1a000007 	bne	8788 <_Z4itoaiPcj+0xb8>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:22
    {
        output[i] = CharConvArr[0];
    8768:	e51b3008 	ldr	r3, [fp, #-8]
    876c:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8770:	e0823003 	add	r3, r2, r3
    8774:	e3a02030 	mov	r2, #48	; 0x30
    8778:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:23
        i++;
    877c:	e51b3008 	ldr	r3, [fp, #-8]
    8780:	e2833001 	add	r3, r3, #1
    8784:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:26
    }

	output[i] = '\0';
    8788:	e51b3008 	ldr	r3, [fp, #-8]
    878c:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8790:	e0823003 	add	r3, r2, r3
    8794:	e3a02000 	mov	r2, #0
    8798:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:27
	i--;
    879c:	e51b3008 	ldr	r3, [fp, #-8]
    87a0:	e2433001 	sub	r3, r3, #1
    87a4:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:29 (discriminator 2)

	for (j; j <= i/2; j++)
    87a8:	e51b3008 	ldr	r3, [fp, #-8]
    87ac:	e1a02fa3 	lsr	r2, r3, #31
    87b0:	e0823003 	add	r3, r2, r3
    87b4:	e1a030c3 	asr	r3, r3, #1
    87b8:	e1a02003 	mov	r2, r3
    87bc:	e51b300c 	ldr	r3, [fp, #-12]
    87c0:	e1530002 	cmp	r3, r2
    87c4:	ca00001b 	bgt	8838 <_Z4itoaiPcj+0x168>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:31 (discriminator 1)
	{
		char c = output[i - j];
    87c8:	e51b2008 	ldr	r2, [fp, #-8]
    87cc:	e51b300c 	ldr	r3, [fp, #-12]
    87d0:	e0423003 	sub	r3, r2, r3
    87d4:	e1a02003 	mov	r2, r3
    87d8:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    87dc:	e0833002 	add	r3, r3, r2
    87e0:	e5d33000 	ldrb	r3, [r3]
    87e4:	e54b300d 	strb	r3, [fp, #-13]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:32 (discriminator 1)
		output[i - j] = output[j];
    87e8:	e51b300c 	ldr	r3, [fp, #-12]
    87ec:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    87f0:	e0822003 	add	r2, r2, r3
    87f4:	e51b1008 	ldr	r1, [fp, #-8]
    87f8:	e51b300c 	ldr	r3, [fp, #-12]
    87fc:	e0413003 	sub	r3, r1, r3
    8800:	e1a01003 	mov	r1, r3
    8804:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8808:	e0833001 	add	r3, r3, r1
    880c:	e5d22000 	ldrb	r2, [r2]
    8810:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:33 (discriminator 1)
		output[j] = c;
    8814:	e51b300c 	ldr	r3, [fp, #-12]
    8818:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    881c:	e0823003 	add	r3, r2, r3
    8820:	e55b200d 	ldrb	r2, [fp, #-13]
    8824:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:29 (discriminator 1)
	for (j; j <= i/2; j++)
    8828:	e51b300c 	ldr	r3, [fp, #-12]
    882c:	e2833001 	add	r3, r3, #1
    8830:	e50b300c 	str	r3, [fp, #-12]
    8834:	eaffffdb 	b	87a8 <_Z4itoaiPcj+0xd8>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:36
	}

}
    8838:	e320f000 	nop	{0}
    883c:	e24bd004 	sub	sp, fp, #4
    8840:	e8bd8800 	pop	{fp, pc}
    8844:	00009a54 	andeq	r9, r0, r4, asr sl

00008848 <_Z4atoiPKc>:
_Z4atoiPKc():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:39

int atoi(const char* input)
{
    8848:	e92d4800 	push	{fp, lr}
    884c:	e28db004 	add	fp, sp, #4
    8850:	e24dd010 	sub	sp, sp, #16
    8854:	e50b0010 	str	r0, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:40
    if(strlen(input) == 1)
    8858:	e51b0010 	ldr	r0, [fp, #-16]
    885c:	eb00011e 	bl	8cdc <_Z6strlenPKc>
    8860:	e1a03000 	mov	r3, r0
    8864:	e3530001 	cmp	r3, #1
    8868:	03a03001 	moveq	r3, #1
    886c:	13a03000 	movne	r3, #0
    8870:	e6ef3073 	uxtb	r3, r3
    8874:	e3530000 	cmp	r3, #0
    8878:	0a000003 	beq	888c <_Z4atoiPKc+0x44>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:41
        return *input - '0';
    887c:	e51b3010 	ldr	r3, [fp, #-16]
    8880:	e5d33000 	ldrb	r3, [r3]
    8884:	e2433030 	sub	r3, r3, #48	; 0x30
    8888:	ea00001e 	b	8908 <_Z4atoiPKc+0xc0>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:42
	int output = 0;
    888c:	e3a03000 	mov	r3, #0
    8890:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:44

	while (*input != '\0')
    8894:	e51b3010 	ldr	r3, [fp, #-16]
    8898:	e5d33000 	ldrb	r3, [r3]
    889c:	e3530000 	cmp	r3, #0
    88a0:	0a000017 	beq	8904 <_Z4atoiPKc+0xbc>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:46
	{
		output *= 10;
    88a4:	e51b2008 	ldr	r2, [fp, #-8]
    88a8:	e1a03002 	mov	r3, r2
    88ac:	e1a03103 	lsl	r3, r3, #2
    88b0:	e0833002 	add	r3, r3, r2
    88b4:	e1a03083 	lsl	r3, r3, #1
    88b8:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:47
		if (*input > '9' || *input < '0')
    88bc:	e51b3010 	ldr	r3, [fp, #-16]
    88c0:	e5d33000 	ldrb	r3, [r3]
    88c4:	e3530039 	cmp	r3, #57	; 0x39
    88c8:	8a00000d 	bhi	8904 <_Z4atoiPKc+0xbc>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:47 (discriminator 1)
    88cc:	e51b3010 	ldr	r3, [fp, #-16]
    88d0:	e5d33000 	ldrb	r3, [r3]
    88d4:	e353002f 	cmp	r3, #47	; 0x2f
    88d8:	9a000009 	bls	8904 <_Z4atoiPKc+0xbc>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:50
			break;

		output += *input - '0';
    88dc:	e51b3010 	ldr	r3, [fp, #-16]
    88e0:	e5d33000 	ldrb	r3, [r3]
    88e4:	e2433030 	sub	r3, r3, #48	; 0x30
    88e8:	e51b2008 	ldr	r2, [fp, #-8]
    88ec:	e0823003 	add	r3, r2, r3
    88f0:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:52

		input++;
    88f4:	e51b3010 	ldr	r3, [fp, #-16]
    88f8:	e2833001 	add	r3, r3, #1
    88fc:	e50b3010 	str	r3, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:44
	while (*input != '\0')
    8900:	eaffffe3 	b	8894 <_Z4atoiPKc+0x4c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:55
	}

	return output;
    8904:	e51b3008 	ldr	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:56
}
    8908:	e1a00003 	mov	r0, r3
    890c:	e24bd004 	sub	sp, fp, #4
    8910:	e8bd8800 	pop	{fp, pc}

00008914 <_Z14get_input_typePKc>:
_Z14get_input_typePKc():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:60
//return 1 pokud int
//return 2 pokud float
//return 0 pokud neni cislo
int get_input_type(const char * input){
    8914:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8918:	e28db000 	add	fp, sp, #0
    891c:	e24dd014 	sub	sp, sp, #20
    8920:	e50b0010 	str	r0, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:62
    //existence tecky
    bool dot = false;
    8924:	e3a03000 	mov	r3, #0
    8928:	e54b3005 	strb	r3, [fp, #-5]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:63
    bool trailing_dot = false;
    892c:	e3a03000 	mov	r3, #0
    8930:	e54b3006 	strb	r3, [fp, #-6]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:64
    while(*input != '\0'){
    8934:	e51b3010 	ldr	r3, [fp, #-16]
    8938:	e5d33000 	ldrb	r3, [r3]
    893c:	e3530000 	cmp	r3, #0
    8940:	0a000023 	beq	89d4 <_Z14get_input_typePKc+0xc0>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:65
        char c = *input;
    8944:	e51b3010 	ldr	r3, [fp, #-16]
    8948:	e5d33000 	ldrb	r3, [r3]
    894c:	e54b3007 	strb	r3, [fp, #-7]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:66
        if(c == '.' && !dot){
    8950:	e55b3007 	ldrb	r3, [fp, #-7]
    8954:	e353002e 	cmp	r3, #46	; 0x2e
    8958:	1a00000c 	bne	8990 <_Z14get_input_typePKc+0x7c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:66 (discriminator 1)
    895c:	e55b3005 	ldrb	r3, [fp, #-5]
    8960:	e2233001 	eor	r3, r3, #1
    8964:	e6ef3073 	uxtb	r3, r3
    8968:	e3530000 	cmp	r3, #0
    896c:	0a000007 	beq	8990 <_Z14get_input_typePKc+0x7c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:67 (discriminator 2)
            dot = true;
    8970:	e3a03001 	mov	r3, #1
    8974:	e54b3005 	strb	r3, [fp, #-5]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:68 (discriminator 2)
            trailing_dot = true;
    8978:	e3a03001 	mov	r3, #1
    897c:	e54b3006 	strb	r3, [fp, #-6]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:69 (discriminator 2)
            input++;
    8980:	e51b3010 	ldr	r3, [fp, #-16]
    8984:	e2833001 	add	r3, r3, #1
    8988:	e50b3010 	str	r3, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:70 (discriminator 2)
            continue;
    898c:	ea00000f 	b	89d0 <_Z14get_input_typePKc+0xbc>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:73
        }
        //nenumericky znak
        if(c < '0' || c > '9')return 0;
    8990:	e55b3007 	ldrb	r3, [fp, #-7]
    8994:	e353002f 	cmp	r3, #47	; 0x2f
    8998:	9a000002 	bls	89a8 <_Z14get_input_typePKc+0x94>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:73 (discriminator 2)
    899c:	e55b3007 	ldrb	r3, [fp, #-7]
    89a0:	e3530039 	cmp	r3, #57	; 0x39
    89a4:	9a000001 	bls	89b0 <_Z14get_input_typePKc+0x9c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:73 (discriminator 3)
    89a8:	e3a03000 	mov	r3, #0
    89ac:	ea000014 	b	8a04 <_Z14get_input_typePKc+0xf0>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:75
        //retezec obsahuje tecku a numericke znaky -> tecka je "validni", tedy neni to tecka na konci intu napriklad
        if(dot)
    89b0:	e55b3005 	ldrb	r3, [fp, #-5]
    89b4:	e3530000 	cmp	r3, #0
    89b8:	0a000001 	beq	89c4 <_Z14get_input_typePKc+0xb0>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:76
            trailing_dot = false;
    89bc:	e3a03000 	mov	r3, #0
    89c0:	e54b3006 	strb	r3, [fp, #-6]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:77
    input++;
    89c4:	e51b3010 	ldr	r3, [fp, #-16]
    89c8:	e2833001 	add	r3, r3, #1
    89cc:	e50b3010 	str	r3, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:64
    while(*input != '\0'){
    89d0:	eaffffd7 	b	8934 <_Z14get_input_typePKc+0x20>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:79
    }
    if(trailing_dot)return 0;
    89d4:	e55b3006 	ldrb	r3, [fp, #-6]
    89d8:	e3530000 	cmp	r3, #0
    89dc:	0a000001 	beq	89e8 <_Z14get_input_typePKc+0xd4>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:79 (discriminator 1)
    89e0:	e3a03000 	mov	r3, #0
    89e4:	ea000006 	b	8a04 <_Z14get_input_typePKc+0xf0>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:81
    //float pokud retezec obsahuje non-trailing tecku, 1 pokud je to int
    return dot? 2:1;
    89e8:	e55b3005 	ldrb	r3, [fp, #-5]
    89ec:	e3530000 	cmp	r3, #0
    89f0:	0a000001 	beq	89fc <_Z14get_input_typePKc+0xe8>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:81 (discriminator 1)
    89f4:	e3a03002 	mov	r3, #2
    89f8:	ea000000 	b	8a00 <_Z14get_input_typePKc+0xec>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:81 (discriminator 2)
    89fc:	e3a03001 	mov	r3, #1
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:81
    8a00:	e320f000 	nop	{0}
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:83

}
    8a04:	e1a00003 	mov	r0, r3
    8a08:	e28bd000 	add	sp, fp, #0
    8a0c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8a10:	e12fff1e 	bx	lr

00008a14 <_Z4atofPKc>:
_Z4atofPKc():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:87


//string to float
float atof(const char* input){
    8a14:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8a18:	e28db000 	add	fp, sp, #0
    8a1c:	e24dd03c 	sub	sp, sp, #60	; 0x3c
    8a20:	e50b0038 	str	r0, [fp, #-56]	; 0xffffffc8
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:88
    double output = 0.0;
    8a24:	e3a02000 	mov	r2, #0
    8a28:	e3a03000 	mov	r3, #0
    8a2c:	e14b20fc 	strd	r2, [fp, #-12]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:89
    double factor = 10;
    8a30:	e3a02000 	mov	r2, #0
    8a34:	e59f312c 	ldr	r3, [pc, #300]	; 8b68 <_Z4atofPKc+0x154>
    8a38:	e14b21fc 	strd	r2, [fp, #-28]	; 0xffffffe4
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:91
    //cast za desetinnou carkou
    double tmp = 0.0;
    8a3c:	e3a02000 	mov	r2, #0
    8a40:	e3a03000 	mov	r3, #0
    8a44:	e14b22f4 	strd	r2, [fp, #-36]	; 0xffffffdc
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:92
    int counter = 0;
    8a48:	e3a03000 	mov	r3, #0
    8a4c:	e50b3028 	str	r3, [fp, #-40]	; 0xffffffd8
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:93
    int scale = 1;
    8a50:	e3a03001 	mov	r3, #1
    8a54:	e50b3010 	str	r3, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:94
    bool afterDecPoint = false;
    8a58:	e3a03000 	mov	r3, #0
    8a5c:	e54b3011 	strb	r3, [fp, #-17]	; 0xffffffef
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:96

    while(*input != '\0'){
    8a60:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    8a64:	e5d33000 	ldrb	r3, [r3]
    8a68:	e3530000 	cmp	r3, #0
    8a6c:	0a000034 	beq	8b44 <_Z4atofPKc+0x130>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:97
        if (*input == '.'){
    8a70:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    8a74:	e5d33000 	ldrb	r3, [r3]
    8a78:	e353002e 	cmp	r3, #46	; 0x2e
    8a7c:	1a000005 	bne	8a98 <_Z4atofPKc+0x84>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:98 (discriminator 1)
            afterDecPoint = true;
    8a80:	e3a03001 	mov	r3, #1
    8a84:	e54b3011 	strb	r3, [fp, #-17]	; 0xffffffef
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:99 (discriminator 1)
            input++;
    8a88:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    8a8c:	e2833001 	add	r3, r3, #1
    8a90:	e50b3038 	str	r3, [fp, #-56]	; 0xffffffc8
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:100 (discriminator 1)
            continue;
    8a94:	ea000029 	b	8b40 <_Z4atofPKc+0x12c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:102
        }
        else if (*input > '9' || *input < '0')break;
    8a98:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    8a9c:	e5d33000 	ldrb	r3, [r3]
    8aa0:	e3530039 	cmp	r3, #57	; 0x39
    8aa4:	8a000026 	bhi	8b44 <_Z4atofPKc+0x130>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:102 (discriminator 1)
    8aa8:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    8aac:	e5d33000 	ldrb	r3, [r3]
    8ab0:	e353002f 	cmp	r3, #47	; 0x2f
    8ab4:	9a000022 	bls	8b44 <_Z4atofPKc+0x130>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:103
        double val = *input - '0';
    8ab8:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    8abc:	e5d33000 	ldrb	r3, [r3]
    8ac0:	e2433030 	sub	r3, r3, #48	; 0x30
    8ac4:	ee073a90 	vmov	s15, r3
    8ac8:	eeb87be7 	vcvt.f64.s32	d7, s15
    8acc:	ed0b7b0d 	vstr	d7, [fp, #-52]	; 0xffffffcc
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:104
        if(afterDecPoint){
    8ad0:	e55b3011 	ldrb	r3, [fp, #-17]	; 0xffffffef
    8ad4:	e3530000 	cmp	r3, #0
    8ad8:	0a00000f 	beq	8b1c <_Z4atofPKc+0x108>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:105
            scale /= 10;
    8adc:	e51b3010 	ldr	r3, [fp, #-16]
    8ae0:	e59f2084 	ldr	r2, [pc, #132]	; 8b6c <_Z4atofPKc+0x158>
    8ae4:	e0c21392 	smull	r1, r2, r2, r3
    8ae8:	e1a02142 	asr	r2, r2, #2
    8aec:	e1a03fc3 	asr	r3, r3, #31
    8af0:	e0423003 	sub	r3, r2, r3
    8af4:	e50b3010 	str	r3, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:106
            output = output + val * scale;
    8af8:	e51b3010 	ldr	r3, [fp, #-16]
    8afc:	ee073a90 	vmov	s15, r3
    8b00:	eeb86be7 	vcvt.f64.s32	d6, s15
    8b04:	ed1b7b0d 	vldr	d7, [fp, #-52]	; 0xffffffcc
    8b08:	ee267b07 	vmul.f64	d7, d6, d7
    8b0c:	ed1b6b03 	vldr	d6, [fp, #-12]
    8b10:	ee367b07 	vadd.f64	d7, d6, d7
    8b14:	ed0b7b03 	vstr	d7, [fp, #-12]
    8b18:	ea000005 	b	8b34 <_Z4atofPKc+0x120>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:109
        }
        else
            output = output * 10 + val;
    8b1c:	ed1b7b03 	vldr	d7, [fp, #-12]
    8b20:	ed9f6b0e 	vldr	d6, [pc, #56]	; 8b60 <_Z4atofPKc+0x14c>
    8b24:	ee277b06 	vmul.f64	d7, d7, d6
    8b28:	ed1b6b0d 	vldr	d6, [fp, #-52]	; 0xffffffcc
    8b2c:	ee367b07 	vadd.f64	d7, d6, d7
    8b30:	ed0b7b03 	vstr	d7, [fp, #-12]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:111

        input++;
    8b34:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    8b38:	e2833001 	add	r3, r3, #1
    8b3c:	e50b3038 	str	r3, [fp, #-56]	; 0xffffffc8
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:96
    while(*input != '\0'){
    8b40:	eaffffc6 	b	8a60 <_Z4atofPKc+0x4c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:113
    }
    return output;
    8b44:	ed1b7b03 	vldr	d7, [fp, #-12]
    8b48:	eef77bc7 	vcvt.f32.f64	s15, d7
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:114
}
    8b4c:	eeb00a67 	vmov.f32	s0, s15
    8b50:	e28bd000 	add	sp, fp, #0
    8b54:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8b58:	e12fff1e 	bx	lr
    8b5c:	e320f000 	nop	{0}
    8b60:	00000000 	andeq	r0, r0, r0
    8b64:	40240000 	eormi	r0, r4, r0
    8b68:	40240000 	eormi	r0, r4, r0
    8b6c:	66666667 	strbtvs	r6, [r6], -r7, ror #12

00008b70 <_Z7strncpyPcPKci>:
_Z7strncpyPcPKci():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:116
char* strncpy(char* dest, const char *src, int num)
{
    8b70:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8b74:	e28db000 	add	fp, sp, #0
    8b78:	e24dd01c 	sub	sp, sp, #28
    8b7c:	e50b0010 	str	r0, [fp, #-16]
    8b80:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8b84:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:119
	int i;

	for (i = 0; i < num && src[i] != '\0'; i++)
    8b88:	e3a03000 	mov	r3, #0
    8b8c:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:119 (discriminator 4)
    8b90:	e51b2008 	ldr	r2, [fp, #-8]
    8b94:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8b98:	e1520003 	cmp	r2, r3
    8b9c:	aa000011 	bge	8be8 <_Z7strncpyPcPKci+0x78>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:119 (discriminator 2)
    8ba0:	e51b3008 	ldr	r3, [fp, #-8]
    8ba4:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    8ba8:	e0823003 	add	r3, r2, r3
    8bac:	e5d33000 	ldrb	r3, [r3]
    8bb0:	e3530000 	cmp	r3, #0
    8bb4:	0a00000b 	beq	8be8 <_Z7strncpyPcPKci+0x78>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:120 (discriminator 3)
		dest[i] = src[i];
    8bb8:	e51b3008 	ldr	r3, [fp, #-8]
    8bbc:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    8bc0:	e0822003 	add	r2, r2, r3
    8bc4:	e51b3008 	ldr	r3, [fp, #-8]
    8bc8:	e51b1010 	ldr	r1, [fp, #-16]
    8bcc:	e0813003 	add	r3, r1, r3
    8bd0:	e5d22000 	ldrb	r2, [r2]
    8bd4:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:119 (discriminator 3)
	for (i = 0; i < num && src[i] != '\0'; i++)
    8bd8:	e51b3008 	ldr	r3, [fp, #-8]
    8bdc:	e2833001 	add	r3, r3, #1
    8be0:	e50b3008 	str	r3, [fp, #-8]
    8be4:	eaffffe9 	b	8b90 <_Z7strncpyPcPKci+0x20>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:121 (discriminator 2)
	for (; i < num; i++)
    8be8:	e51b2008 	ldr	r2, [fp, #-8]
    8bec:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8bf0:	e1520003 	cmp	r2, r3
    8bf4:	aa000008 	bge	8c1c <_Z7strncpyPcPKci+0xac>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:122 (discriminator 1)
		dest[i] = '\0';
    8bf8:	e51b3008 	ldr	r3, [fp, #-8]
    8bfc:	e51b2010 	ldr	r2, [fp, #-16]
    8c00:	e0823003 	add	r3, r2, r3
    8c04:	e3a02000 	mov	r2, #0
    8c08:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:121 (discriminator 1)
	for (; i < num; i++)
    8c0c:	e51b3008 	ldr	r3, [fp, #-8]
    8c10:	e2833001 	add	r3, r3, #1
    8c14:	e50b3008 	str	r3, [fp, #-8]
    8c18:	eafffff2 	b	8be8 <_Z7strncpyPcPKci+0x78>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:124

   return dest;
    8c1c:	e51b3010 	ldr	r3, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:125
}
    8c20:	e1a00003 	mov	r0, r3
    8c24:	e28bd000 	add	sp, fp, #0
    8c28:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8c2c:	e12fff1e 	bx	lr

00008c30 <_Z7strncmpPKcS0_i>:
_Z7strncmpPKcS0_i():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:128

int strncmp(const char *s1, const char *s2, int num)
{
    8c30:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8c34:	e28db000 	add	fp, sp, #0
    8c38:	e24dd01c 	sub	sp, sp, #28
    8c3c:	e50b0010 	str	r0, [fp, #-16]
    8c40:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8c44:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:130
	unsigned char u1, u2;
  	while (num-- > 0)
    8c48:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8c4c:	e2432001 	sub	r2, r3, #1
    8c50:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
    8c54:	e3530000 	cmp	r3, #0
    8c58:	c3a03001 	movgt	r3, #1
    8c5c:	d3a03000 	movle	r3, #0
    8c60:	e6ef3073 	uxtb	r3, r3
    8c64:	e3530000 	cmp	r3, #0
    8c68:	0a000016 	beq	8cc8 <_Z7strncmpPKcS0_i+0x98>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:132
    {
      	u1 = (unsigned char) *s1++;
    8c6c:	e51b3010 	ldr	r3, [fp, #-16]
    8c70:	e2832001 	add	r2, r3, #1
    8c74:	e50b2010 	str	r2, [fp, #-16]
    8c78:	e5d33000 	ldrb	r3, [r3]
    8c7c:	e54b3005 	strb	r3, [fp, #-5]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:133
     	u2 = (unsigned char) *s2++;
    8c80:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8c84:	e2832001 	add	r2, r3, #1
    8c88:	e50b2014 	str	r2, [fp, #-20]	; 0xffffffec
    8c8c:	e5d33000 	ldrb	r3, [r3]
    8c90:	e54b3006 	strb	r3, [fp, #-6]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:134
      	if (u1 != u2)
    8c94:	e55b2005 	ldrb	r2, [fp, #-5]
    8c98:	e55b3006 	ldrb	r3, [fp, #-6]
    8c9c:	e1520003 	cmp	r2, r3
    8ca0:	0a000003 	beq	8cb4 <_Z7strncmpPKcS0_i+0x84>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:135
        	return u1 - u2;
    8ca4:	e55b2005 	ldrb	r2, [fp, #-5]
    8ca8:	e55b3006 	ldrb	r3, [fp, #-6]
    8cac:	e0423003 	sub	r3, r2, r3
    8cb0:	ea000005 	b	8ccc <_Z7strncmpPKcS0_i+0x9c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:136
      	if (u1 == '\0')
    8cb4:	e55b3005 	ldrb	r3, [fp, #-5]
    8cb8:	e3530000 	cmp	r3, #0
    8cbc:	1affffe1 	bne	8c48 <_Z7strncmpPKcS0_i+0x18>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:137
        	return 0;
    8cc0:	e3a03000 	mov	r3, #0
    8cc4:	ea000000 	b	8ccc <_Z7strncmpPKcS0_i+0x9c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:140
    }

  	return 0;
    8cc8:	e3a03000 	mov	r3, #0
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:141
}
    8ccc:	e1a00003 	mov	r0, r3
    8cd0:	e28bd000 	add	sp, fp, #0
    8cd4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8cd8:	e12fff1e 	bx	lr

00008cdc <_Z6strlenPKc>:
_Z6strlenPKc():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:144

int strlen(const char* s)
{
    8cdc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8ce0:	e28db000 	add	fp, sp, #0
    8ce4:	e24dd014 	sub	sp, sp, #20
    8ce8:	e50b0010 	str	r0, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:145
	int i = 0;
    8cec:	e3a03000 	mov	r3, #0
    8cf0:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:147

	while (s[i] != '\0')
    8cf4:	e51b3008 	ldr	r3, [fp, #-8]
    8cf8:	e51b2010 	ldr	r2, [fp, #-16]
    8cfc:	e0823003 	add	r3, r2, r3
    8d00:	e5d33000 	ldrb	r3, [r3]
    8d04:	e3530000 	cmp	r3, #0
    8d08:	0a000003 	beq	8d1c <_Z6strlenPKc+0x40>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:148
		i++;
    8d0c:	e51b3008 	ldr	r3, [fp, #-8]
    8d10:	e2833001 	add	r3, r3, #1
    8d14:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:147
	while (s[i] != '\0')
    8d18:	eafffff5 	b	8cf4 <_Z6strlenPKc+0x18>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:150

	return i;
    8d1c:	e51b3008 	ldr	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:151
}
    8d20:	e1a00003 	mov	r0, r3
    8d24:	e28bd000 	add	sp, fp, #0
    8d28:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8d2c:	e12fff1e 	bx	lr

00008d30 <_Z6strcatPcPKc>:
_Z6strcatPcPKc():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:154
//unsafe varianta
//muze nastat buffer overflow attack
char* strcat(char* dest, const char* src){
    8d30:	e92d4800 	push	{fp, lr}
    8d34:	e28db004 	add	fp, sp, #4
    8d38:	e24dd018 	sub	sp, sp, #24
    8d3c:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    8d40:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:155
    int n = strlen(src);
    8d44:	e51b001c 	ldr	r0, [fp, #-28]	; 0xffffffe4
    8d48:	ebffffe3 	bl	8cdc <_Z6strlenPKc>
    8d4c:	e50b0010 	str	r0, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:156
    int m = strlen(dest);
    8d50:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    8d54:	ebffffe0 	bl	8cdc <_Z6strlenPKc>
    8d58:	e50b0008 	str	r0, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:157
    int walker = 0;
    8d5c:	e3a03000 	mov	r3, #0
    8d60:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:158
    for(int i = 0;i < n; i++)
    8d64:	e3a03000 	mov	r3, #0
    8d68:	e50b300c 	str	r3, [fp, #-12]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:158 (discriminator 3)
    8d6c:	e51b200c 	ldr	r2, [fp, #-12]
    8d70:	e51b3010 	ldr	r3, [fp, #-16]
    8d74:	e1520003 	cmp	r2, r3
    8d78:	aa00000e 	bge	8db8 <_Z6strcatPcPKc+0x88>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:159 (discriminator 2)
        dest[m++] = src[i];
    8d7c:	e51b300c 	ldr	r3, [fp, #-12]
    8d80:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8d84:	e0822003 	add	r2, r2, r3
    8d88:	e51b3008 	ldr	r3, [fp, #-8]
    8d8c:	e2831001 	add	r1, r3, #1
    8d90:	e50b1008 	str	r1, [fp, #-8]
    8d94:	e1a01003 	mov	r1, r3
    8d98:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8d9c:	e0833001 	add	r3, r3, r1
    8da0:	e5d22000 	ldrb	r2, [r2]
    8da4:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:158 (discriminator 2)
    for(int i = 0;i < n; i++)
    8da8:	e51b300c 	ldr	r3, [fp, #-12]
    8dac:	e2833001 	add	r3, r3, #1
    8db0:	e50b300c 	str	r3, [fp, #-12]
    8db4:	eaffffec 	b	8d6c <_Z6strcatPcPKc+0x3c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:160
    dest[m] = '\0';
    8db8:	e51b3008 	ldr	r3, [fp, #-8]
    8dbc:	e51b2018 	ldr	r2, [fp, #-24]	; 0xffffffe8
    8dc0:	e0823003 	add	r3, r2, r3
    8dc4:	e3a02000 	mov	r2, #0
    8dc8:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:161
    return dest;
    8dcc:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:163

}
    8dd0:	e1a00003 	mov	r0, r3
    8dd4:	e24bd004 	sub	sp, fp, #4
    8dd8:	e8bd8800 	pop	{fp, pc}

00008ddc <_Z7strncatPcPKci>:
_Z7strncatPcPKci():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:164
char* strncat(char* dest, const char* src,int size){
    8ddc:	e92d4800 	push	{fp, lr}
    8de0:	e28db004 	add	fp, sp, #4
    8de4:	e24dd020 	sub	sp, sp, #32
    8de8:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    8dec:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    8df0:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:165
    int walker = 0;
    8df4:	e3a03000 	mov	r3, #0
    8df8:	e50b3010 	str	r3, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:167
    //najdi odkud muzeme kopirovat, tedy konec retezce
    int m = strlen(dest);
    8dfc:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    8e00:	ebffffb5 	bl	8cdc <_Z6strlenPKc>
    8e04:	e50b0008 	str	r0, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:169
    //nevejdu se
    if(m >= size)return dest;
    8e08:	e51b2008 	ldr	r2, [fp, #-8]
    8e0c:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8e10:	e1520003 	cmp	r2, r3
    8e14:	ba000001 	blt	8e20 <_Z7strncatPcPKci+0x44>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:169 (discriminator 1)
    8e18:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8e1c:	ea000021 	b	8ea8 <_Z7strncatPcPKci+0xcc>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:171

    for(int i = 0;i < size; i++){
    8e20:	e3a03000 	mov	r3, #0
    8e24:	e50b300c 	str	r3, [fp, #-12]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:171 (discriminator 1)
    8e28:	e51b200c 	ldr	r2, [fp, #-12]
    8e2c:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8e30:	e1520003 	cmp	r2, r3
    8e34:	aa000015 	bge	8e90 <_Z7strncatPcPKci+0xb4>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:172
        if(src[i] == '\0')break;
    8e38:	e51b300c 	ldr	r3, [fp, #-12]
    8e3c:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8e40:	e0823003 	add	r3, r2, r3
    8e44:	e5d33000 	ldrb	r3, [r3]
    8e48:	e3530000 	cmp	r3, #0
    8e4c:	0a00000e 	beq	8e8c <_Z7strncatPcPKci+0xb0>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:173 (discriminator 2)
        dest[m++] = src[i];
    8e50:	e51b300c 	ldr	r3, [fp, #-12]
    8e54:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8e58:	e0822003 	add	r2, r2, r3
    8e5c:	e51b3008 	ldr	r3, [fp, #-8]
    8e60:	e2831001 	add	r1, r3, #1
    8e64:	e50b1008 	str	r1, [fp, #-8]
    8e68:	e1a01003 	mov	r1, r3
    8e6c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8e70:	e0833001 	add	r3, r3, r1
    8e74:	e5d22000 	ldrb	r2, [r2]
    8e78:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:171 (discriminator 2)
    for(int i = 0;i < size; i++){
    8e7c:	e51b300c 	ldr	r3, [fp, #-12]
    8e80:	e2833001 	add	r3, r3, #1
    8e84:	e50b300c 	str	r3, [fp, #-12]
    8e88:	eaffffe6 	b	8e28 <_Z7strncatPcPKci+0x4c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:172
        if(src[i] == '\0')break;
    8e8c:	e320f000 	nop	{0}
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:175
    }
    dest[m] = '\0';
    8e90:	e51b3008 	ldr	r3, [fp, #-8]
    8e94:	e51b2018 	ldr	r2, [fp, #-24]	; 0xffffffe8
    8e98:	e0823003 	add	r3, r2, r3
    8e9c:	e3a02000 	mov	r2, #0
    8ea0:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:176
    return dest;
    8ea4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:178

}
    8ea8:	e1a00003 	mov	r0, r3
    8eac:	e24bd004 	sub	sp, fp, #4
    8eb0:	e8bd8800 	pop	{fp, pc}

00008eb4 <_Z5bzeroPvi>:
_Z5bzeroPvi():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:182


void bzero(void* memory, int length)
{
    8eb4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8eb8:	e28db000 	add	fp, sp, #0
    8ebc:	e24dd014 	sub	sp, sp, #20
    8ec0:	e50b0010 	str	r0, [fp, #-16]
    8ec4:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:183
	char* mem = reinterpret_cast<char*>(memory);
    8ec8:	e51b3010 	ldr	r3, [fp, #-16]
    8ecc:	e50b300c 	str	r3, [fp, #-12]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:185

	for (int i = 0; i < length; i++)
    8ed0:	e3a03000 	mov	r3, #0
    8ed4:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:185 (discriminator 3)
    8ed8:	e51b2008 	ldr	r2, [fp, #-8]
    8edc:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8ee0:	e1520003 	cmp	r2, r3
    8ee4:	aa000008 	bge	8f0c <_Z5bzeroPvi+0x58>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:186 (discriminator 2)
		mem[i] = 0;
    8ee8:	e51b3008 	ldr	r3, [fp, #-8]
    8eec:	e51b200c 	ldr	r2, [fp, #-12]
    8ef0:	e0823003 	add	r3, r2, r3
    8ef4:	e3a02000 	mov	r2, #0
    8ef8:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:185 (discriminator 2)
	for (int i = 0; i < length; i++)
    8efc:	e51b3008 	ldr	r3, [fp, #-8]
    8f00:	e2833001 	add	r3, r3, #1
    8f04:	e50b3008 	str	r3, [fp, #-8]
    8f08:	eafffff2 	b	8ed8 <_Z5bzeroPvi+0x24>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:187
}
    8f0c:	e320f000 	nop	{0}
    8f10:	e28bd000 	add	sp, fp, #0
    8f14:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8f18:	e12fff1e 	bx	lr

00008f1c <_Z6memcpyPKvPvi>:
_Z6memcpyPKvPvi():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:190

void memcpy(const void* src, void* dst, int num)
{
    8f1c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8f20:	e28db000 	add	fp, sp, #0
    8f24:	e24dd024 	sub	sp, sp, #36	; 0x24
    8f28:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    8f2c:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    8f30:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:191
	const char* memsrc = reinterpret_cast<const char*>(src);
    8f34:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8f38:	e50b300c 	str	r3, [fp, #-12]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:192
	char* memdst = reinterpret_cast<char*>(dst);
    8f3c:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8f40:	e50b3010 	str	r3, [fp, #-16]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:194

	for (int i = 0; i < num; i++)
    8f44:	e3a03000 	mov	r3, #0
    8f48:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:194 (discriminator 3)
    8f4c:	e51b2008 	ldr	r2, [fp, #-8]
    8f50:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8f54:	e1520003 	cmp	r2, r3
    8f58:	aa00000b 	bge	8f8c <_Z6memcpyPKvPvi+0x70>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:195 (discriminator 2)
		memdst[i] = memsrc[i];
    8f5c:	e51b3008 	ldr	r3, [fp, #-8]
    8f60:	e51b200c 	ldr	r2, [fp, #-12]
    8f64:	e0822003 	add	r2, r2, r3
    8f68:	e51b3008 	ldr	r3, [fp, #-8]
    8f6c:	e51b1010 	ldr	r1, [fp, #-16]
    8f70:	e0813003 	add	r3, r1, r3
    8f74:	e5d22000 	ldrb	r2, [r2]
    8f78:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:194 (discriminator 2)
	for (int i = 0; i < num; i++)
    8f7c:	e51b3008 	ldr	r3, [fp, #-8]
    8f80:	e2833001 	add	r3, r3, #1
    8f84:	e50b3008 	str	r3, [fp, #-8]
    8f88:	eaffffef 	b	8f4c <_Z6memcpyPKvPvi+0x30>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:196
}
    8f8c:	e320f000 	nop	{0}
    8f90:	e28bd000 	add	sp, fp, #0
    8f94:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8f98:	e12fff1e 	bx	lr

00008f9c <_Z4n_tuii>:
_Z4n_tuii():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:201



int n_tu(int number, int count)
{
    8f9c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8fa0:	e28db000 	add	fp, sp, #0
    8fa4:	e24dd014 	sub	sp, sp, #20
    8fa8:	e50b0010 	str	r0, [fp, #-16]
    8fac:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:202
    int result = 1;
    8fb0:	e3a03001 	mov	r3, #1
    8fb4:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:203
    while(count-- > 0)
    8fb8:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8fbc:	e2432001 	sub	r2, r3, #1
    8fc0:	e50b2014 	str	r2, [fp, #-20]	; 0xffffffec
    8fc4:	e3530000 	cmp	r3, #0
    8fc8:	c3a03001 	movgt	r3, #1
    8fcc:	d3a03000 	movle	r3, #0
    8fd0:	e6ef3073 	uxtb	r3, r3
    8fd4:	e3530000 	cmp	r3, #0
    8fd8:	0a000004 	beq	8ff0 <_Z4n_tuii+0x54>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:204
        result *= number;
    8fdc:	e51b3008 	ldr	r3, [fp, #-8]
    8fe0:	e51b2010 	ldr	r2, [fp, #-16]
    8fe4:	e0030392 	mul	r3, r2, r3
    8fe8:	e50b3008 	str	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:203
    while(count-- > 0)
    8fec:	eafffff1 	b	8fb8 <_Z4n_tuii+0x1c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:206

    return result;
    8ff0:	e51b3008 	ldr	r3, [fp, #-8]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:207
}
    8ff4:	e1a00003 	mov	r0, r3
    8ff8:	e28bd000 	add	sp, fp, #0
    8ffc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9000:	e12fff1e 	bx	lr

00009004 <_Z4ftoafPc>:
_Z4ftoafPc():
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:211

/*** Convert float to string ***/
void ftoa(float f, char r[])
{
    9004:	e92d4bf0 	push	{r4, r5, r6, r7, r8, r9, fp, lr}
    9008:	e28db01c 	add	fp, sp, #28
    900c:	e24dd068 	sub	sp, sp, #104	; 0x68
    9010:	ed0b0a16 	vstr	s0, [fp, #-88]	; 0xffffffa8
    9014:	e50b005c 	str	r0, [fp, #-92]	; 0xffffffa4
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:215
    long long int length, length2, i, number, position, sign;
    float number2;

    sign = -1;   // -1 == positive number
    9018:	e3e02000 	mvn	r2, #0
    901c:	e3e03000 	mvn	r3, #0
    9020:	e14b24fc 	strd	r2, [fp, #-76]	; 0xffffffb4
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:216
    if (f < 0)
    9024:	ed5b7a16 	vldr	s15, [fp, #-88]	; 0xffffffa8
    9028:	eef57ac0 	vcmpe.f32	s15, #0.0
    902c:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    9030:	5a000005 	bpl	904c <_Z4ftoafPc+0x48>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:218
    {
        sign = '-';
    9034:	e3a0202d 	mov	r2, #45	; 0x2d
    9038:	e3a03000 	mov	r3, #0
    903c:	e14b24fc 	strd	r2, [fp, #-76]	; 0xffffffb4
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:219
        f *= -1;
    9040:	ed5b7a16 	vldr	s15, [fp, #-88]	; 0xffffffa8
    9044:	eef17a67 	vneg.f32	s15, s15
    9048:	ed4b7a16 	vstr	s15, [fp, #-88]	; 0xffffffa8
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:222
    }

    number2 = f;
    904c:	e51b3058 	ldr	r3, [fp, #-88]	; 0xffffffa8
    9050:	e50b3050 	str	r3, [fp, #-80]	; 0xffffffb0
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:223
    number = f;
    9054:	e51b0058 	ldr	r0, [fp, #-88]	; 0xffffffa8
    9058:	eb000200 	bl	9860 <__aeabi_f2lz>
    905c:	e1a02000 	mov	r2, r0
    9060:	e1a03001 	mov	r3, r1
    9064:	e14b23fc 	strd	r2, [fp, #-60]	; 0xffffffc4
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:224
    length = 0;  // Size of decimal part
    9068:	e3a02000 	mov	r2, #0
    906c:	e3a03000 	mov	r3, #0
    9070:	e14b22f4 	strd	r2, [fp, #-36]	; 0xffffffdc
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:225
    length2 = 0; // Size of tenth
    9074:	e3a02000 	mov	r2, #0
    9078:	e3a03000 	mov	r3, #0
    907c:	e14b22fc 	strd	r2, [fp, #-44]	; 0xffffffd4
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:228

    /* Calculate length2 tenth part */
    while( (number2 - (float)number) != 0.0 && !((number2 - (float)number) < 0.0) )
    9080:	e14b03dc 	ldrd	r0, [fp, #-60]	; 0xffffffc4
    9084:	eb0001a1 	bl	9710 <__aeabi_l2f>
    9088:	ee070a10 	vmov	s14, r0
    908c:	ed5b7a14 	vldr	s15, [fp, #-80]	; 0xffffffb0
    9090:	ee777ac7 	vsub.f32	s15, s15, s14
    9094:	eef57a40 	vcmp.f32	s15, #0.0
    9098:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    909c:	0a00001b 	beq	9110 <_Z4ftoafPc+0x10c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:228 (discriminator 1)
    90a0:	e14b03dc 	ldrd	r0, [fp, #-60]	; 0xffffffc4
    90a4:	eb000199 	bl	9710 <__aeabi_l2f>
    90a8:	ee070a10 	vmov	s14, r0
    90ac:	ed5b7a14 	vldr	s15, [fp, #-80]	; 0xffffffb0
    90b0:	ee777ac7 	vsub.f32	s15, s15, s14
    90b4:	eef57ac0 	vcmpe.f32	s15, #0.0
    90b8:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    90bc:	4a000013 	bmi	9110 <_Z4ftoafPc+0x10c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:230
    {
        number2 = f * (n_tu(10.0, length2 + 1));
    90c0:	e51b302c 	ldr	r3, [fp, #-44]	; 0xffffffd4
    90c4:	e2833001 	add	r3, r3, #1
    90c8:	e1a01003 	mov	r1, r3
    90cc:	e3a0000a 	mov	r0, #10
    90d0:	ebffffb1 	bl	8f9c <_Z4n_tuii>
    90d4:	ee070a90 	vmov	s15, r0
    90d8:	eef87ae7 	vcvt.f32.s32	s15, s15
    90dc:	ed1b7a16 	vldr	s14, [fp, #-88]	; 0xffffffa8
    90e0:	ee677a27 	vmul.f32	s15, s14, s15
    90e4:	ed4b7a14 	vstr	s15, [fp, #-80]	; 0xffffffb0
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:231
        number = number2;
    90e8:	e51b0050 	ldr	r0, [fp, #-80]	; 0xffffffb0
    90ec:	eb0001db 	bl	9860 <__aeabi_f2lz>
    90f0:	e1a02000 	mov	r2, r0
    90f4:	e1a03001 	mov	r3, r1
    90f8:	e14b23fc 	strd	r2, [fp, #-60]	; 0xffffffc4
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:233

        length2++;
    90fc:	e14b22dc 	ldrd	r2, [fp, #-44]	; 0xffffffd4
    9100:	e2926001 	adds	r6, r2, #1
    9104:	e2a37000 	adc	r7, r3, #0
    9108:	e14b62fc 	strd	r6, [fp, #-44]	; 0xffffffd4
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:228
    while( (number2 - (float)number) != 0.0 && !((number2 - (float)number) < 0.0) )
    910c:	eaffffdb 	b	9080 <_Z4ftoafPc+0x7c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:237
    }

    /* Calculate length decimal part */
    for (length = (f > 1) ? 0 : 1; f > 1; length++)
    9110:	ed5b7a16 	vldr	s15, [fp, #-88]	; 0xffffffa8
    9114:	ed9f7a82 	vldr	s14, [pc, #520]	; 9324 <_Z4ftoafPc+0x320>
    9118:	eef47ac7 	vcmpe.f32	s15, s14
    911c:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    9120:	c3a03001 	movgt	r3, #1
    9124:	d3a03000 	movle	r3, #0
    9128:	e6ef3073 	uxtb	r3, r3
    912c:	e2233001 	eor	r3, r3, #1
    9130:	e6ef3073 	uxtb	r3, r3
    9134:	e6ef3073 	uxtb	r3, r3
    9138:	e3a02000 	mov	r2, #0
    913c:	e50b3064 	str	r3, [fp, #-100]	; 0xffffff9c
    9140:	e50b2060 	str	r2, [fp, #-96]	; 0xffffffa0
    9144:	e14b26d4 	ldrd	r2, [fp, #-100]	; 0xffffff9c
    9148:	e14b22f4 	strd	r2, [fp, #-36]	; 0xffffffdc
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:237 (discriminator 3)
    914c:	ed5b7a16 	vldr	s15, [fp, #-88]	; 0xffffffa8
    9150:	ed9f7a73 	vldr	s14, [pc, #460]	; 9324 <_Z4ftoafPc+0x320>
    9154:	eef47ac7 	vcmpe.f32	s15, s14
    9158:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    915c:	da00000b 	ble	9190 <_Z4ftoafPc+0x18c>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:238 (discriminator 2)
        f /= 10;
    9160:	ed1b7a16 	vldr	s14, [fp, #-88]	; 0xffffffa8
    9164:	eddf6a6f 	vldr	s13, [pc, #444]	; 9328 <_Z4ftoafPc+0x324>
    9168:	eec77a26 	vdiv.f32	s15, s14, s13
    916c:	ed4b7a16 	vstr	s15, [fp, #-88]	; 0xffffffa8
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:237 (discriminator 2)
    for (length = (f > 1) ? 0 : 1; f > 1; length++)
    9170:	e14b22d4 	ldrd	r2, [fp, #-36]	; 0xffffffdc
    9174:	e2921001 	adds	r1, r2, #1
    9178:	e50b106c 	str	r1, [fp, #-108]	; 0xffffff94
    917c:	e2a33000 	adc	r3, r3, #0
    9180:	e50b3068 	str	r3, [fp, #-104]	; 0xffffff98
    9184:	e14b26dc 	ldrd	r2, [fp, #-108]	; 0xffffff94
    9188:	e14b22f4 	strd	r2, [fp, #-36]	; 0xffffffdc
    918c:	eaffffee 	b	914c <_Z4ftoafPc+0x148>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:240

    position = length;
    9190:	e14b22d4 	ldrd	r2, [fp, #-36]	; 0xffffffdc
    9194:	e14b24f4 	strd	r2, [fp, #-68]	; 0xffffffbc
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:241
    length = length + 1 + length2;
    9198:	e14b22d4 	ldrd	r2, [fp, #-36]	; 0xffffffdc
    919c:	e2924001 	adds	r4, r2, #1
    91a0:	e2a35000 	adc	r5, r3, #0
    91a4:	e14b22dc 	ldrd	r2, [fp, #-44]	; 0xffffffd4
    91a8:	e0921004 	adds	r1, r2, r4
    91ac:	e50b1074 	str	r1, [fp, #-116]	; 0xffffff8c
    91b0:	e0a33005 	adc	r3, r3, r5
    91b4:	e50b3070 	str	r3, [fp, #-112]	; 0xffffff90
    91b8:	e14b27d4 	ldrd	r2, [fp, #-116]	; 0xffffff8c
    91bc:	e14b22f4 	strd	r2, [fp, #-36]	; 0xffffffdc
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:242
    number = number2;
    91c0:	e51b0050 	ldr	r0, [fp, #-80]	; 0xffffffb0
    91c4:	eb0001a5 	bl	9860 <__aeabi_f2lz>
    91c8:	e1a02000 	mov	r2, r0
    91cc:	e1a03001 	mov	r3, r1
    91d0:	e14b23fc 	strd	r2, [fp, #-60]	; 0xffffffc4
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:243
    if (sign == '-')
    91d4:	e14b24dc 	ldrd	r2, [fp, #-76]	; 0xffffffb4
    91d8:	e242102d 	sub	r1, r2, #45	; 0x2d
    91dc:	e1913003 	orrs	r3, r1, r3
    91e0:	1a00000d 	bne	921c <_Z4ftoafPc+0x218>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:245
    {
        length++;
    91e4:	e14b22d4 	ldrd	r2, [fp, #-36]	; 0xffffffdc
    91e8:	e2921001 	adds	r1, r2, #1
    91ec:	e50b107c 	str	r1, [fp, #-124]	; 0xffffff84
    91f0:	e2a33000 	adc	r3, r3, #0
    91f4:	e50b3078 	str	r3, [fp, #-120]	; 0xffffff88
    91f8:	e14b27dc 	ldrd	r2, [fp, #-124]	; 0xffffff84
    91fc:	e14b22f4 	strd	r2, [fp, #-36]	; 0xffffffdc
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:246
        position++;
    9200:	e14b24d4 	ldrd	r2, [fp, #-68]	; 0xffffffbc
    9204:	e2921001 	adds	r1, r2, #1
    9208:	e50b1084 	str	r1, [fp, #-132]	; 0xffffff7c
    920c:	e2a33000 	adc	r3, r3, #0
    9210:	e50b3080 	str	r3, [fp, #-128]	; 0xffffff80
    9214:	e14b28d4 	ldrd	r2, [fp, #-132]	; 0xffffff7c
    9218:	e14b24f4 	strd	r2, [fp, #-68]	; 0xffffffbc
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:249
    }

    for (i = length; i >= 0 ; i--)
    921c:	e14b22d4 	ldrd	r2, [fp, #-36]	; 0xffffffdc
    9220:	e14b23f4 	strd	r2, [fp, #-52]	; 0xffffffcc
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:249 (discriminator 1)
    9224:	e14b23d4 	ldrd	r2, [fp, #-52]	; 0xffffffcc
    9228:	e3530000 	cmp	r3, #0
    922c:	ba000039 	blt	9318 <_Z4ftoafPc+0x314>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:251
    {
        if (i == (length))
    9230:	e14b03d4 	ldrd	r0, [fp, #-52]	; 0xffffffcc
    9234:	e14b22d4 	ldrd	r2, [fp, #-36]	; 0xffffffdc
    9238:	e1510003 	cmp	r1, r3
    923c:	01500002 	cmpeq	r0, r2
    9240:	1a000005 	bne	925c <_Z4ftoafPc+0x258>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:252
            r[i] = '\0';
    9244:	e51b3034 	ldr	r3, [fp, #-52]	; 0xffffffcc
    9248:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    924c:	e0823003 	add	r3, r2, r3
    9250:	e3a02000 	mov	r2, #0
    9254:	e5c32000 	strb	r2, [r3]
    9258:	ea000029 	b	9304 <_Z4ftoafPc+0x300>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:253
        else if(i == (position))
    925c:	e14b03d4 	ldrd	r0, [fp, #-52]	; 0xffffffcc
    9260:	e14b24d4 	ldrd	r2, [fp, #-68]	; 0xffffffbc
    9264:	e1510003 	cmp	r1, r3
    9268:	01500002 	cmpeq	r0, r2
    926c:	1a000005 	bne	9288 <_Z4ftoafPc+0x284>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:254
            r[i] = '.';
    9270:	e51b3034 	ldr	r3, [fp, #-52]	; 0xffffffcc
    9274:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    9278:	e0823003 	add	r3, r2, r3
    927c:	e3a0202e 	mov	r2, #46	; 0x2e
    9280:	e5c32000 	strb	r2, [r3]
    9284:	ea00001e 	b	9304 <_Z4ftoafPc+0x300>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:255
        else if(sign == '-' && i == 0)
    9288:	e14b24dc 	ldrd	r2, [fp, #-76]	; 0xffffffb4
    928c:	e242102d 	sub	r1, r2, #45	; 0x2d
    9290:	e1913003 	orrs	r3, r1, r3
    9294:	1a000008 	bne	92bc <_Z4ftoafPc+0x2b8>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:255 (discriminator 1)
    9298:	e14b23d4 	ldrd	r2, [fp, #-52]	; 0xffffffcc
    929c:	e1923003 	orrs	r3, r2, r3
    92a0:	1a000005 	bne	92bc <_Z4ftoafPc+0x2b8>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:256
            r[i] = '-';
    92a4:	e51b3034 	ldr	r3, [fp, #-52]	; 0xffffffcc
    92a8:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    92ac:	e0823003 	add	r3, r2, r3
    92b0:	e3a0202d 	mov	r2, #45	; 0x2d
    92b4:	e5c32000 	strb	r2, [r3]
    92b8:	ea000011 	b	9304 <_Z4ftoafPc+0x300>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:259
        else
        {
            r[i] = (number % 10) + '0';
    92bc:	e14b03dc 	ldrd	r0, [fp, #-60]	; 0xffffffc4
    92c0:	e3a0200a 	mov	r2, #10
    92c4:	e3a03000 	mov	r3, #0
    92c8:	eb00012f 	bl	978c <__aeabi_ldivmod>
    92cc:	e6ef2072 	uxtb	r2, r2
    92d0:	e51b3034 	ldr	r3, [fp, #-52]	; 0xffffffcc
    92d4:	e51b105c 	ldr	r1, [fp, #-92]	; 0xffffffa4
    92d8:	e0813003 	add	r3, r1, r3
    92dc:	e2822030 	add	r2, r2, #48	; 0x30
    92e0:	e6ef2072 	uxtb	r2, r2
    92e4:	e5c32000 	strb	r2, [r3]
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:260
            number /=10;
    92e8:	e14b03dc 	ldrd	r0, [fp, #-60]	; 0xffffffc4
    92ec:	e3a0200a 	mov	r2, #10
    92f0:	e3a03000 	mov	r3, #0
    92f4:	eb000124 	bl	978c <__aeabi_ldivmod>
    92f8:	e1a02000 	mov	r2, r0
    92fc:	e1a03001 	mov	r3, r1
    9300:	e14b23fc 	strd	r2, [fp, #-60]	; 0xffffffc4
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:249 (discriminator 2)
    for (i = length; i >= 0 ; i--)
    9304:	e14b23d4 	ldrd	r2, [fp, #-52]	; 0xffffffcc
    9308:	e2528001 	subs	r8, r2, #1
    930c:	e2c39000 	sbc	r9, r3, #0
    9310:	e14b83f4 	strd	r8, [fp, #-52]	; 0xffffffcc
    9314:	eaffffc2 	b	9224 <_Z4ftoafPc+0x220>
/home/trefil/sem/sources/stdlib/src/stdstring.cpp:263
        }
    }
}
    9318:	e320f000 	nop	{0}
    931c:	e24bd01c 	sub	sp, fp, #28
    9320:	e8bd8bf0 	pop	{r4, r5, r6, r7, r8, r9, fp, pc}
    9324:	3f800000 	svccc	0x00800000
    9328:	41200000 			; <UNDEFINED> instruction: 0x41200000

0000932c <__udivsi3>:
__udivsi3():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1104
    932c:	e2512001 	subs	r2, r1, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1106
    9330:	012fff1e 	bxeq	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1107
    9334:	3a000074 	bcc	950c <__udivsi3+0x1e0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1108
    9338:	e1500001 	cmp	r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1109
    933c:	9a00006b 	bls	94f0 <__udivsi3+0x1c4>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1110
    9340:	e1110002 	tst	r1, r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1111
    9344:	0a00006c 	beq	94fc <__udivsi3+0x1d0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1113
    9348:	e16f3f10 	clz	r3, r0
    934c:	e16f2f11 	clz	r2, r1
    9350:	e0423003 	sub	r3, r2, r3
    9354:	e273301f 	rsbs	r3, r3, #31
    9358:	10833083 	addne	r3, r3, r3, lsl #1
    935c:	e3a02000 	mov	r2, #0
    9360:	108ff103 	addne	pc, pc, r3, lsl #2
    9364:	e1a00000 	nop			; (mov r0, r0)
    9368:	e1500f81 	cmp	r0, r1, lsl #31
    936c:	e0a22002 	adc	r2, r2, r2
    9370:	20400f81 	subcs	r0, r0, r1, lsl #31
    9374:	e1500f01 	cmp	r0, r1, lsl #30
    9378:	e0a22002 	adc	r2, r2, r2
    937c:	20400f01 	subcs	r0, r0, r1, lsl #30
    9380:	e1500e81 	cmp	r0, r1, lsl #29
    9384:	e0a22002 	adc	r2, r2, r2
    9388:	20400e81 	subcs	r0, r0, r1, lsl #29
    938c:	e1500e01 	cmp	r0, r1, lsl #28
    9390:	e0a22002 	adc	r2, r2, r2
    9394:	20400e01 	subcs	r0, r0, r1, lsl #28
    9398:	e1500d81 	cmp	r0, r1, lsl #27
    939c:	e0a22002 	adc	r2, r2, r2
    93a0:	20400d81 	subcs	r0, r0, r1, lsl #27
    93a4:	e1500d01 	cmp	r0, r1, lsl #26
    93a8:	e0a22002 	adc	r2, r2, r2
    93ac:	20400d01 	subcs	r0, r0, r1, lsl #26
    93b0:	e1500c81 	cmp	r0, r1, lsl #25
    93b4:	e0a22002 	adc	r2, r2, r2
    93b8:	20400c81 	subcs	r0, r0, r1, lsl #25
    93bc:	e1500c01 	cmp	r0, r1, lsl #24
    93c0:	e0a22002 	adc	r2, r2, r2
    93c4:	20400c01 	subcs	r0, r0, r1, lsl #24
    93c8:	e1500b81 	cmp	r0, r1, lsl #23
    93cc:	e0a22002 	adc	r2, r2, r2
    93d0:	20400b81 	subcs	r0, r0, r1, lsl #23
    93d4:	e1500b01 	cmp	r0, r1, lsl #22
    93d8:	e0a22002 	adc	r2, r2, r2
    93dc:	20400b01 	subcs	r0, r0, r1, lsl #22
    93e0:	e1500a81 	cmp	r0, r1, lsl #21
    93e4:	e0a22002 	adc	r2, r2, r2
    93e8:	20400a81 	subcs	r0, r0, r1, lsl #21
    93ec:	e1500a01 	cmp	r0, r1, lsl #20
    93f0:	e0a22002 	adc	r2, r2, r2
    93f4:	20400a01 	subcs	r0, r0, r1, lsl #20
    93f8:	e1500981 	cmp	r0, r1, lsl #19
    93fc:	e0a22002 	adc	r2, r2, r2
    9400:	20400981 	subcs	r0, r0, r1, lsl #19
    9404:	e1500901 	cmp	r0, r1, lsl #18
    9408:	e0a22002 	adc	r2, r2, r2
    940c:	20400901 	subcs	r0, r0, r1, lsl #18
    9410:	e1500881 	cmp	r0, r1, lsl #17
    9414:	e0a22002 	adc	r2, r2, r2
    9418:	20400881 	subcs	r0, r0, r1, lsl #17
    941c:	e1500801 	cmp	r0, r1, lsl #16
    9420:	e0a22002 	adc	r2, r2, r2
    9424:	20400801 	subcs	r0, r0, r1, lsl #16
    9428:	e1500781 	cmp	r0, r1, lsl #15
    942c:	e0a22002 	adc	r2, r2, r2
    9430:	20400781 	subcs	r0, r0, r1, lsl #15
    9434:	e1500701 	cmp	r0, r1, lsl #14
    9438:	e0a22002 	adc	r2, r2, r2
    943c:	20400701 	subcs	r0, r0, r1, lsl #14
    9440:	e1500681 	cmp	r0, r1, lsl #13
    9444:	e0a22002 	adc	r2, r2, r2
    9448:	20400681 	subcs	r0, r0, r1, lsl #13
    944c:	e1500601 	cmp	r0, r1, lsl #12
    9450:	e0a22002 	adc	r2, r2, r2
    9454:	20400601 	subcs	r0, r0, r1, lsl #12
    9458:	e1500581 	cmp	r0, r1, lsl #11
    945c:	e0a22002 	adc	r2, r2, r2
    9460:	20400581 	subcs	r0, r0, r1, lsl #11
    9464:	e1500501 	cmp	r0, r1, lsl #10
    9468:	e0a22002 	adc	r2, r2, r2
    946c:	20400501 	subcs	r0, r0, r1, lsl #10
    9470:	e1500481 	cmp	r0, r1, lsl #9
    9474:	e0a22002 	adc	r2, r2, r2
    9478:	20400481 	subcs	r0, r0, r1, lsl #9
    947c:	e1500401 	cmp	r0, r1, lsl #8
    9480:	e0a22002 	adc	r2, r2, r2
    9484:	20400401 	subcs	r0, r0, r1, lsl #8
    9488:	e1500381 	cmp	r0, r1, lsl #7
    948c:	e0a22002 	adc	r2, r2, r2
    9490:	20400381 	subcs	r0, r0, r1, lsl #7
    9494:	e1500301 	cmp	r0, r1, lsl #6
    9498:	e0a22002 	adc	r2, r2, r2
    949c:	20400301 	subcs	r0, r0, r1, lsl #6
    94a0:	e1500281 	cmp	r0, r1, lsl #5
    94a4:	e0a22002 	adc	r2, r2, r2
    94a8:	20400281 	subcs	r0, r0, r1, lsl #5
    94ac:	e1500201 	cmp	r0, r1, lsl #4
    94b0:	e0a22002 	adc	r2, r2, r2
    94b4:	20400201 	subcs	r0, r0, r1, lsl #4
    94b8:	e1500181 	cmp	r0, r1, lsl #3
    94bc:	e0a22002 	adc	r2, r2, r2
    94c0:	20400181 	subcs	r0, r0, r1, lsl #3
    94c4:	e1500101 	cmp	r0, r1, lsl #2
    94c8:	e0a22002 	adc	r2, r2, r2
    94cc:	20400101 	subcs	r0, r0, r1, lsl #2
    94d0:	e1500081 	cmp	r0, r1, lsl #1
    94d4:	e0a22002 	adc	r2, r2, r2
    94d8:	20400081 	subcs	r0, r0, r1, lsl #1
    94dc:	e1500001 	cmp	r0, r1
    94e0:	e0a22002 	adc	r2, r2, r2
    94e4:	20400001 	subcs	r0, r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1115
    94e8:	e1a00002 	mov	r0, r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1116
    94ec:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1119
    94f0:	03a00001 	moveq	r0, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1120
    94f4:	13a00000 	movne	r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1121
    94f8:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1123
    94fc:	e16f2f11 	clz	r2, r1
    9500:	e262201f 	rsb	r2, r2, #31
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1125
    9504:	e1a00230 	lsr	r0, r0, r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1126
    9508:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1130
    950c:	e3500000 	cmp	r0, #0
    9510:	13e00000 	mvnne	r0, #0
    9514:	ea000007 	b	9538 <__aeabi_idiv0>

00009518 <__aeabi_uidivmod>:
__aeabi_uidivmod():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1161
    9518:	e3510000 	cmp	r1, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1162
    951c:	0afffffa 	beq	950c <__udivsi3+0x1e0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1163
    9520:	e92d4003 	push	{r0, r1, lr}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1164
    9524:	ebffff80 	bl	932c <__udivsi3>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1165
    9528:	e8bd4006 	pop	{r1, r2, lr}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1166
    952c:	e0030092 	mul	r3, r2, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1167
    9530:	e0411003 	sub	r1, r1, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1168
    9534:	e12fff1e 	bx	lr

00009538 <__aeabi_idiv0>:
__aeabi_ldiv0():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1466
    9538:	e12fff1e 	bx	lr

0000953c <__aeabi_frsub>:
__aeabi_frsub():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:59
    953c:	e2200102 	eor	r0, r0, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:60
    9540:	ea000000 	b	9548 <__addsf3>

00009544 <__aeabi_fsub>:
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:65
    9544:	e2211102 	eor	r1, r1, #-2147483648	; 0x80000000

00009548 <__addsf3>:
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:74
    9548:	e1b02080 	lsls	r2, r0, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:76
    954c:	11b03081 	lslsne	r3, r1, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:77
    9550:	11320003 	teqne	r2, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:78
    9554:	11f0cc42 	mvnsne	ip, r2, asr #24
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:79
    9558:	11f0cc43 	mvnsne	ip, r3, asr #24
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:80
    955c:	0a00003c 	beq	9654 <__addsf3+0x10c>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:84
    9560:	e1a02c22 	lsr	r2, r2, #24
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:85
    9564:	e0723c23 	rsbs	r3, r2, r3, lsr #24
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:87
    9568:	c0822003 	addgt	r2, r2, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:88
    956c:	c0201001 	eorgt	r1, r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:89
    9570:	c0210000 	eorgt	r0, r1, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:90
    9574:	c0201001 	eorgt	r1, r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:92
    9578:	b2633000 	rsblt	r3, r3, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:97
    957c:	e3530019 	cmp	r3, #25
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:99
    9580:	812fff1e 	bxhi	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:102
    9584:	e3100102 	tst	r0, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:103
    9588:	e3800502 	orr	r0, r0, #8388608	; 0x800000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:104
    958c:	e3c004ff 	bic	r0, r0, #-16777216	; 0xff000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:106
    9590:	12600000 	rsbne	r0, r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:107
    9594:	e3110102 	tst	r1, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:108
    9598:	e3811502 	orr	r1, r1, #8388608	; 0x800000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:109
    959c:	e3c114ff 	bic	r1, r1, #-16777216	; 0xff000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:111
    95a0:	12611000 	rsbne	r1, r1, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:115
    95a4:	e1320003 	teq	r2, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:116
    95a8:	0a000023 	beq	963c <__addsf3+0xf4>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:120
    95ac:	e2422001 	sub	r2, r2, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:124
    95b0:	e0900351 	adds	r0, r0, r1, asr r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:125
    95b4:	e2633020 	rsb	r3, r3, #32
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:126
    95b8:	e1a01311 	lsl	r1, r1, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:129
    95bc:	e2003102 	and	r3, r0, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:130
    95c0:	5a000001 	bpl	95cc <__addsf3+0x84>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:135
    95c4:	e2711000 	rsbs	r1, r1, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:136
    95c8:	e2e00000 	rsc	r0, r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:141
    95cc:	e3500502 	cmp	r0, #8388608	; 0x800000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:142
    95d0:	3a00000b 	bcc	9604 <__addsf3+0xbc>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:143
    95d4:	e3500401 	cmp	r0, #16777216	; 0x1000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:144
    95d8:	3a000004 	bcc	95f0 <__addsf3+0xa8>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:147
    95dc:	e1b000a0 	lsrs	r0, r0, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:148
    95e0:	e1a01061 	rrx	r1, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:149
    95e4:	e2822001 	add	r2, r2, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:152
    95e8:	e35200fe 	cmp	r2, #254	; 0xfe
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:153
    95ec:	2a00002d 	bcs	96a8 <__addsf3+0x160>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:160
    95f0:	e3510102 	cmp	r1, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:161
    95f4:	e0a00b82 	adc	r0, r0, r2, lsl #23
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:163
    95f8:	03c00001 	biceq	r0, r0, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:164
    95fc:	e1800003 	orr	r0, r0, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:165
    9600:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:169
    9604:	e1b01081 	lsls	r1, r1, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:170
    9608:	e0a00000 	adc	r0, r0, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:171
    960c:	e2522001 	subs	r2, r2, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:173
    9610:	23500502 	cmpcs	r0, #8388608	; 0x800000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:174
    9614:	2afffff5 	bcs	95f0 <__addsf3+0xa8>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:199
    9618:	e16fcf10 	clz	ip, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:200
    961c:	e24cc008 	sub	ip, ip, #8
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:201
    9620:	e052200c 	subs	r2, r2, ip
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:202
    9624:	e1a00c10 	lsl	r0, r0, ip
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:209
    9628:	a0800b82 	addge	r0, r0, r2, lsl #23
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:210
    962c:	b2622000 	rsblt	r2, r2, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:211
    9630:	a1800003 	orrge	r0, r0, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:217
    9634:	b1830230 	orrlt	r0, r3, r0, lsr r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:219
    9638:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:224
    963c:	e3320000 	teq	r2, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:225
    9640:	e2211502 	eor	r1, r1, #8388608	; 0x800000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:227
    9644:	02200502 	eoreq	r0, r0, #8388608	; 0x800000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:228
    9648:	02822001 	addeq	r2, r2, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:229
    964c:	12433001 	subne	r3, r3, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:230
    9650:	eaffffd5 	b	95ac <__addsf3+0x64>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:233
    9654:	e1a03081 	lsl	r3, r1, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:235
    9658:	e1f0cc42 	mvns	ip, r2, asr #24
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:237
    965c:	11f0cc43 	mvnsne	ip, r3, asr #24
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:238
    9660:	0a000013 	beq	96b4 <__addsf3+0x16c>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:240
    9664:	e1320003 	teq	r2, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:241
    9668:	0a000002 	beq	9678 <__addsf3+0x130>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:244
    966c:	e3320000 	teq	r2, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:246
    9670:	01a00001 	moveq	r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:247
    9674:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:249
    9678:	e1300001 	teq	r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:253
    967c:	13a00000 	movne	r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:254
    9680:	112fff1e 	bxne	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:257
    9684:	e31204ff 	tst	r2, #-16777216	; 0xff000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:258
    9688:	1a000002 	bne	9698 <__addsf3+0x150>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:259
    968c:	e1b00080 	lsls	r0, r0, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:261
    9690:	23800102 	orrcs	r0, r0, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:262
    9694:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:263
    9698:	e2922402 	adds	r2, r2, #33554432	; 0x2000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:265
    969c:	32800502 	addcc	r0, r0, #8388608	; 0x800000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:266
    96a0:	312fff1e 	bxcc	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:267
    96a4:	e2003102 	and	r3, r0, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:271
    96a8:	e383047f 	orr	r0, r3, #2130706432	; 0x7f000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:272
    96ac:	e3800502 	orr	r0, r0, #8388608	; 0x800000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:273
    96b0:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:282
    96b4:	e1f02c42 	mvns	r2, r2, asr #24
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:284
    96b8:	11a00001 	movne	r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:285
    96bc:	01f03c43 	mvnseq	r3, r3, asr #24
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:286
    96c0:	11a01000 	movne	r1, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:287
    96c4:	e1b02480 	lsls	r2, r0, #9
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:289
    96c8:	01b03481 	lslseq	r3, r1, #9
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:290
    96cc:	01300001 	teqeq	r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:291
    96d0:	13800501 	orrne	r0, r0, #4194304	; 0x400000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:292
    96d4:	e12fff1e 	bx	lr

000096d8 <__aeabi_ui2f>:
__aeabi_ui2f():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:305
    96d8:	e3a03000 	mov	r3, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:306
    96dc:	ea000001 	b	96e8 <__aeabi_i2f+0x8>

000096e0 <__aeabi_i2f>:
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:311
    96e0:	e2103102 	ands	r3, r0, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:313
    96e4:	42600000 	rsbmi	r0, r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:315
    96e8:	e1b0c000 	movs	ip, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:317
    96ec:	012fff1e 	bxeq	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:320
    96f0:	e383344b 	orr	r3, r3, #1258291200	; 0x4b000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:323
    96f4:	e1a01000 	mov	r1, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:325
    96f8:	e3a00000 	mov	r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:326
    96fc:	ea00000f 	b	9740 <__aeabi_l2f+0x30>

00009700 <__aeabi_ul2f>:
__floatundisf():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:338
    9700:	e1902001 	orrs	r2, r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:340
    9704:	012fff1e 	bxeq	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:342
    9708:	e3a03000 	mov	r3, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:343
    970c:	ea000005 	b	9728 <__aeabi_l2f+0x18>

00009710 <__aeabi_l2f>:
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:348
    9710:	e1902001 	orrs	r2, r0, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:350
    9714:	012fff1e 	bxeq	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:352
    9718:	e2113102 	ands	r3, r1, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:353
    971c:	5a000001 	bpl	9728 <__aeabi_l2f+0x18>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:358
    9720:	e2700000 	rsbs	r0, r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:359
    9724:	e2e11000 	rsc	r1, r1, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:362
    9728:	e1b0c001 	movs	ip, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:364
    972c:	01a0c000 	moveq	ip, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:365
    9730:	01a01000 	moveq	r1, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:366
    9734:	03a00000 	moveq	r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:369
    9738:	e383345b 	orr	r3, r3, #1526726656	; 0x5b000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:371
    973c:	02433201 	subeq	r3, r3, #268435456	; 0x10000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:372
    9740:	e2433502 	sub	r3, r3, #8388608	; 0x800000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:397
    9744:	e16f2f1c 	clz	r2, ip
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:398
    9748:	e2522008 	subs	r2, r2, #8
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:402
    974c:	e0433b82 	sub	r3, r3, r2, lsl #23
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:403
    9750:	ba000006 	blt	9770 <__aeabi_l2f+0x60>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:405
    9754:	e0833211 	add	r3, r3, r1, lsl r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:406
    9758:	e1a0c210 	lsl	ip, r0, r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:407
    975c:	e2622020 	rsb	r2, r2, #32
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:408
    9760:	e35c0102 	cmp	ip, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:409
    9764:	e0a30230 	adc	r0, r3, r0, lsr r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:411
    9768:	03c00001 	biceq	r0, r0, #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:412
    976c:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:414
    9770:	e2822020 	add	r2, r2, #32
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:415
    9774:	e1a0c211 	lsl	ip, r1, r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:416
    9778:	e2622020 	rsb	r2, r2, #32
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:417
    977c:	e190008c 	orrs	r0, r0, ip, lsl #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:418
    9780:	e0a30231 	adc	r0, r3, r1, lsr r2
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:420
    9784:	01c00fac 	biceq	r0, r0, ip, lsr #31
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:421
    9788:	e12fff1e 	bx	lr

0000978c <__aeabi_ldivmod>:
__aeabi_ldivmod():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:186
    978c:	e3530000 	cmp	r3, #0
    9790:	03520000 	cmpeq	r2, #0
    9794:	1a000007 	bne	97b8 <__aeabi_ldivmod+0x2c>
    9798:	e3510000 	cmp	r1, #0
    979c:	b3a01102 	movlt	r1, #-2147483648	; 0x80000000
    97a0:	b3a00000 	movlt	r0, #0
    97a4:	ba000002 	blt	97b4 <__aeabi_ldivmod+0x28>
    97a8:	03500000 	cmpeq	r0, #0
    97ac:	13e01102 	mvnne	r1, #-2147483648	; 0x80000000
    97b0:	13e00000 	mvnne	r0, #0
    97b4:	eaffff5f 	b	9538 <__aeabi_idiv0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:188
    97b8:	e24dd008 	sub	sp, sp, #8
    97bc:	e92d6000 	push	{sp, lr}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:189
    97c0:	e3510000 	cmp	r1, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:190
    97c4:	ba000006 	blt	97e4 <__aeabi_ldivmod+0x58>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:191
    97c8:	e3530000 	cmp	r3, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:192
    97cc:	ba000011 	blt	9818 <__aeabi_ldivmod+0x8c>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:194
    97d0:	eb00003e 	bl	98d0 <__udivmoddi4>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:196
    97d4:	e59de004 	ldr	lr, [sp, #4]
    97d8:	e28dd008 	add	sp, sp, #8
    97dc:	e8bd000c 	pop	{r2, r3}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:197
    97e0:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:201
    97e4:	e2700000 	rsbs	r0, r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:202
    97e8:	e0c11081 	sbc	r1, r1, r1, lsl #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:203
    97ec:	e3530000 	cmp	r3, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:204
    97f0:	ba000011 	blt	983c <__aeabi_ldivmod+0xb0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:206
    97f4:	eb000035 	bl	98d0 <__udivmoddi4>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:208
    97f8:	e59de004 	ldr	lr, [sp, #4]
    97fc:	e28dd008 	add	sp, sp, #8
    9800:	e8bd000c 	pop	{r2, r3}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:209
    9804:	e2700000 	rsbs	r0, r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:210
    9808:	e0c11081 	sbc	r1, r1, r1, lsl #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:211
    980c:	e2722000 	rsbs	r2, r2, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:212
    9810:	e0c33083 	sbc	r3, r3, r3, lsl #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:213
    9814:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:217
    9818:	e2722000 	rsbs	r2, r2, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:218
    981c:	e0c33083 	sbc	r3, r3, r3, lsl #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:220
    9820:	eb00002a 	bl	98d0 <__udivmoddi4>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:222
    9824:	e59de004 	ldr	lr, [sp, #4]
    9828:	e28dd008 	add	sp, sp, #8
    982c:	e8bd000c 	pop	{r2, r3}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:223
    9830:	e2700000 	rsbs	r0, r0, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:224
    9834:	e0c11081 	sbc	r1, r1, r1, lsl #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:225
    9838:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:229
    983c:	e2722000 	rsbs	r2, r2, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:230
    9840:	e0c33083 	sbc	r3, r3, r3, lsl #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:232
    9844:	eb000021 	bl	98d0 <__udivmoddi4>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:233
    9848:	e59de004 	ldr	lr, [sp, #4]
    984c:	e28dd008 	add	sp, sp, #8
    9850:	e8bd000c 	pop	{r2, r3}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:234
    9854:	e2722000 	rsbs	r2, r2, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:235
    9858:	e0c33083 	sbc	r3, r3, r3, lsl #1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:236
    985c:	e12fff1e 	bx	lr

00009860 <__aeabi_f2lz>:
__fixsfdi():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1530
    9860:	ee070a90 	vmov	s15, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1531
    9864:	eef57ac0 	vcmpe.f32	s15, #0.0
    9868:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    986c:	4a000000 	bmi	9874 <__aeabi_f2lz+0x14>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1533
    9870:	ea000006 	b	9890 <__aeabi_f2ulz>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1532
    9874:	eef17a67 	vneg.f32	s15, s15
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1530
    9878:	e92d4010 	push	{r4, lr}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1532
    987c:	ee170a90 	vmov	r0, s15
    9880:	eb000002 	bl	9890 <__aeabi_f2ulz>
    9884:	e2700000 	rsbs	r0, r0, #0
    9888:	e2e11000 	rsc	r1, r1, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1534
    988c:	e8bd8010 	pop	{r4, pc}

00009890 <__aeabi_f2ulz>:
__fixunssfdi():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1471
    9890:	ee070a90 	vmov	s15, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1476
    9894:	ed9f6b09 	vldr	d6, [pc, #36]	; 98c0 <__aeabi_f2ulz+0x30>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1481
    9898:	ed9f5b0a 	vldr	d5, [pc, #40]	; 98c8 <__aeabi_f2ulz+0x38>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1471
    989c:	eeb77ae7 	vcvt.f64.f32	d7, s15
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1476
    98a0:	ee276b06 	vmul.f64	d6, d7, d6
    98a4:	eebc6bc6 	vcvt.u32.f64	s12, d6
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1481
    98a8:	eeb84b46 	vcvt.f64.u32	d4, s12
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1524
    98ac:	ee161a10 	vmov	r1, s12
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1481
    98b0:	ee047b45 	vmls.f64	d7, d4, d5
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1524
    98b4:	eefc7bc7 	vcvt.u32.f64	s15, d7
    98b8:	ee170a90 	vmov	r0, s15
    98bc:	e12fff1e 	bx	lr
    98c0:	00000000 	andeq	r0, r0, r0
    98c4:	3df00000 	ldclcc	0, cr0, [r0]
    98c8:	00000000 	andeq	r0, r0, r0
    98cc:	41f00000 	mvnsmi	r0, r0

000098d0 <__udivmoddi4>:
__udivmoddi4():
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:960
    98d0:	e1500002 	cmp	r0, r2
    98d4:	e0d1c003 	sbcs	ip, r1, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:948
    98d8:	e92d43f0 	push	{r4, r5, r6, r7, r8, r9, lr}
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:949
    98dc:	33a05000 	movcc	r5, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:948
    98e0:	e59d701c 	ldr	r7, [sp, #28]
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:949
    98e4:	31a06005 	movcc	r6, r5
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:960
    98e8:	3a00003b 	bcc	99dc <__udivmoddi4+0x10c>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:962
    98ec:	e3530000 	cmp	r3, #0
    98f0:	016fcf12 	clzeq	ip, r2
    98f4:	116fef13 	clzne	lr, r3
    98f8:	028ce020 	addeq	lr, ip, #32
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:963
    98fc:	e3510000 	cmp	r1, #0
    9900:	016fcf10 	clzeq	ip, r0
    9904:	028cc020 	addeq	ip, ip, #32
    9908:	116fcf11 	clzne	ip, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:965
    990c:	e04ec00c 	sub	ip, lr, ip
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:966
    9910:	e1a03c13 	lsl	r3, r3, ip
    9914:	e24c9020 	sub	r9, ip, #32
    9918:	e1833912 	orr	r3, r3, r2, lsl r9
    991c:	e1a04c12 	lsl	r4, r2, ip
    9920:	e26c8020 	rsb	r8, ip, #32
    9924:	e1833832 	orr	r3, r3, r2, lsr r8
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:973
    9928:	e1500004 	cmp	r0, r4
    992c:	e0d12003 	sbcs	r2, r1, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:949
    9930:	33a05000 	movcc	r5, #0
    9934:	31a06005 	movcc	r6, r5
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:973
    9938:	3a000005 	bcc	9954 <__udivmoddi4+0x84>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:976
    993c:	e3a05001 	mov	r5, #1
    9940:	e1a06915 	lsl	r6, r5, r9
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:975
    9944:	e0500004 	subs	r0, r0, r4
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:976
    9948:	e1866835 	orr	r6, r6, r5, lsr r8
    994c:	e1a05c15 	lsl	r5, r5, ip
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:975
    9950:	e0c11003 	sbc	r1, r1, r3
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:979
    9954:	e35c0000 	cmp	ip, #0
    9958:	0a00001f 	beq	99dc <__udivmoddi4+0x10c>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:981
    995c:	e1a040a4 	lsr	r4, r4, #1
    9960:	e1844f83 	orr	r4, r4, r3, lsl #31
    9964:	e1a020a3 	lsr	r2, r3, #1
    9968:	e1a0e00c 	mov	lr, ip
    996c:	ea000007 	b	9990 <__udivmoddi4+0xc0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:989
    9970:	e0503004 	subs	r3, r0, r4
    9974:	e0c11002 	sbc	r1, r1, r2
    9978:	e0933003 	adds	r3, r3, r3
    997c:	e0a11001 	adc	r1, r1, r1
    9980:	e2930001 	adds	r0, r3, #1
    9984:	e2a11000 	adc	r1, r1, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:993
    9988:	e25ee001 	subs	lr, lr, #1
    998c:	0a000006 	beq	99ac <__udivmoddi4+0xdc>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:988
    9990:	e1500004 	cmp	r0, r4
    9994:	e0d13002 	sbcs	r3, r1, r2
    9998:	2afffff4 	bcs	9970 <__udivmoddi4+0xa0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:991
    999c:	e0900000 	adds	r0, r0, r0
    99a0:	e0a11001 	adc	r1, r1, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:993
    99a4:	e25ee001 	subs	lr, lr, #1
    99a8:	1afffff8 	bne	9990 <__udivmoddi4+0xc0>
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:997
    99ac:	e0955000 	adds	r5, r5, r0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:998
    99b0:	e1a00c30 	lsr	r0, r0, ip
    99b4:	e1800811 	orr	r0, r0, r1, lsl r8
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:997
    99b8:	e0a66001 	adc	r6, r6, r1
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:998
    99bc:	e1800931 	orr	r0, r0, r1, lsr r9
    99c0:	e1a01c31 	lsr	r1, r1, ip
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:999
    99c4:	e1a03c10 	lsl	r3, r0, ip
    99c8:	e1a0cc11 	lsl	ip, r1, ip
    99cc:	e18cc910 	orr	ip, ip, r0, lsl r9
    99d0:	e18cc830 	orr	ip, ip, r0, lsr r8
    99d4:	e0555003 	subs	r5, r5, r3
    99d8:	e0c6600c 	sbc	r6, r6, ip
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1003
    99dc:	e3570000 	cmp	r7, #0
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1004
    99e0:	11c700f0 	strdne	r0, [r7]
/build/gcc-arm-none-eabi-hYfgK4/gcc-arm-none-eabi-10.3-2021.07/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1006
    99e4:	e1a00005 	mov	r0, r5
    99e8:	e1a01006 	mov	r1, r6
    99ec:	e8bd83f0 	pop	{r4, r5, r6, r7, r8, r9, pc}

Disassembly of section .rodata:

000099f0 <_ZL13Lock_Unlocked>:
    99f0:	00000000 	andeq	r0, r0, r0

000099f4 <_ZL11Lock_Locked>:
    99f4:	00000001 	andeq	r0, r0, r1

000099f8 <_ZL21MaxFSDriverNameLength>:
    99f8:	00000010 	andeq	r0, r0, r0, lsl r0

000099fc <_ZL17MaxFilenameLength>:
    99fc:	00000010 	andeq	r0, r0, r0, lsl r0

00009a00 <_ZL13MaxPathLength>:
    9a00:	00000080 	andeq	r0, r0, r0, lsl #1

00009a04 <_ZL18NoFilesystemDriver>:
    9a04:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009a08 <_ZL9NotifyAll>:
    9a08:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009a0c <_ZL24Max_Process_Opened_Files>:
    9a0c:	00000010 	andeq	r0, r0, r0, lsl r0

00009a10 <_ZL10Indefinite>:
    9a10:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009a14 <_ZL18Deadline_Unchanged>:
    9a14:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

00009a18 <_ZL14Invalid_Handle>:
    9a18:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009a1c <_ZL13Lock_Unlocked>:
    9a1c:	00000000 	andeq	r0, r0, r0

00009a20 <_ZL11Lock_Locked>:
    9a20:	00000001 	andeq	r0, r0, r1

00009a24 <_ZL21MaxFSDriverNameLength>:
    9a24:	00000010 	andeq	r0, r0, r0, lsl r0

00009a28 <_ZL17MaxFilenameLength>:
    9a28:	00000010 	andeq	r0, r0, r0, lsl r0

00009a2c <_ZL13MaxPathLength>:
    9a2c:	00000080 	andeq	r0, r0, r0, lsl #1

00009a30 <_ZL18NoFilesystemDriver>:
    9a30:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009a34 <_ZL9NotifyAll>:
    9a34:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009a38 <_ZL24Max_Process_Opened_Files>:
    9a38:	00000010 	andeq	r0, r0, r0, lsl r0

00009a3c <_ZL10Indefinite>:
    9a3c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009a40 <_ZL18Deadline_Unchanged>:
    9a40:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

00009a44 <_ZL14Invalid_Handle>:
    9a44:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009a48 <_ZL16Pipe_File_Prefix>:
    9a48:	3a535953 	bcc	14dff9c <__bss_end+0x14d651c>
    9a4c:	65706970 	ldrbvs	r6, [r0, #-2416]!	; 0xfffff690
    9a50:	0000002f 	andeq	r0, r0, pc, lsr #32

00009a54 <_ZN12_GLOBAL__N_1L11CharConvArrE>:
    9a54:	33323130 	teqcc	r2, #48, 2
    9a58:	37363534 			; <UNDEFINED> instruction: 0x37363534
    9a5c:	42413938 	submi	r3, r1, #56, 18	; 0xe0000
    9a60:	46454443 	strbmi	r4, [r5], -r3, asr #8
	...

Disassembly of section .ARM.exidx:

00009a68 <__CTOR_LIST__-0x8>:
    9a68:	7ffffe68 	svcvc	0x00fffe68
    9a6c:	00000001 	andeq	r0, r0, r1

Disassembly of section .bss:

00009a70 <__bss_start>:
	...

Disassembly of section .ARM.attributes:

00000000 <.ARM.attributes>:
   0:	00002e41 	andeq	r2, r0, r1, asr #28
   4:	61656100 	cmnvs	r5, r0, lsl #2
   8:	01006962 	tsteq	r0, r2, ror #18
   c:	00000024 	andeq	r0, r0, r4, lsr #32
  10:	4b5a3605 	blmi	168d82c <__bss_end+0x1683dac>
  14:	08070600 	stmdaeq	r7, {r9, sl}
  18:	0a010901 	beq	42424 <__bss_end+0x389a4>
  1c:	14041202 	strne	r1, [r4], #-514	; 0xfffffdfe
  20:	17011501 	strne	r1, [r1, -r1, lsl #10]
  24:	1a011803 	bne	46038 <__bss_end+0x3c5b8>
  28:	22011c01 	andcs	r1, r1, #256	; 0x100
  2c:	Address 0x000000000000002c is out of bounds.


Disassembly of section .comment:

00000000 <.comment>:
   0:	3a434347 	bcc	10d0d24 <__bss_end+0x10c72a4>
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
      e0:	db010100 	blle	404e8 <__bss_end+0x36a68>
      e4:	03000000 	movweq	r0, #0
      e8:	00005200 	andeq	r5, r0, r0, lsl #4
      ec:	fb010200 	blx	408f6 <__bss_end+0x36e76>
      f0:	01000d0e 	tsteq	r0, lr, lsl #26
      f4:	00010101 	andeq	r0, r1, r1, lsl #2
      f8:	00010000 	andeq	r0, r1, r0
      fc:	682f0100 	stmdavs	pc!, {r8}	; <UNPREDICTABLE>
     100:	2f656d6f 	svccs	0x00656d6f
     104:	66657274 			; <UNDEFINED> instruction: 0x66657274
     108:	732f6c69 			; <UNDEFINED> instruction: 0x732f6c69
     10c:	732f6d65 			; <UNDEFINED> instruction: 0x732f6d65
     110:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
     114:	752f7365 	strvc	r7, [pc, #-869]!	; fffffdb7 <__bss_end+0xffff6337>
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
     14c:	0a05830b 	beq	160d80 <__bss_end+0x157300>
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
     178:	4a030402 	bmi	c1188 <__bss_end+0xb7708>
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
     1ac:	4a020402 	bmi	811bc <__bss_end+0x7773c>
     1b0:	02000205 	andeq	r0, r0, #1342177280	; 0x50000000
     1b4:	052d0204 	streq	r0, [sp, #-516]!	; 0xfffffdfc
     1b8:	01058509 	tsteq	r5, r9, lsl #10
     1bc:	000a022f 	andeq	r0, sl, pc, lsr #4
     1c0:	017b0101 	cmneq	fp, r1, lsl #2
     1c4:	00030000 	andeq	r0, r3, r0
     1c8:	00000151 	andeq	r0, r0, r1, asr r1
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
     200:	74696e69 	strbtvc	r6, [r9], #-3689	; 0xfffff197
     204:	7361745f 	cmnvc	r1, #1593835520	; 0x5f000000
     208:	682f006b 	stmdavs	pc!, {r0, r1, r3, r5, r6}	; <UNPREDICTABLE>
     20c:	2f656d6f 	svccs	0x00656d6f
     210:	66657274 			; <UNDEFINED> instruction: 0x66657274
     214:	732f6c69 			; <UNDEFINED> instruction: 0x732f6c69
     218:	732f6d65 			; <UNDEFINED> instruction: 0x732f6d65
     21c:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
     220:	752f7365 	strvc	r7, [pc, #-869]!	; fffffec3 <__bss_end+0xffff6443>
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
     2c0:	00006c61 	andeq	r6, r0, r1, ror #24
     2c4:	6e69616d 	powvsez	f6, f1, #5.0
     2c8:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
     2cc:	00000100 	andeq	r0, r0, r0, lsl #2
     2d0:	6e697073 	mcrvs	0, 3, r7, cr9, cr3, {3}
     2d4:	6b636f6c 	blvs	18dc08c <__bss_end+0x18d260c>
     2d8:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
     2dc:	69660000 	stmdbvs	r6!, {}^	; <UNPREDICTABLE>
     2e0:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
     2e4:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
     2e8:	0300682e 	movweq	r6, #2094	; 0x82e
     2ec:	72700000 	rsbsvc	r0, r0, #0
     2f0:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     2f4:	00682e73 	rsbeq	r2, r8, r3, ror lr
     2f8:	70000002 	andvc	r0, r0, r2
     2fc:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     300:	6d5f7373 	ldclvs	3, cr7, [pc, #-460]	; 13c <shift+0x13c>
     304:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     308:	682e7265 	stmdavs	lr!, {r0, r2, r5, r6, r9, ip, sp, lr}
     30c:	00000200 	andeq	r0, r0, r0, lsl #4
     310:	64746e69 	ldrbtvs	r6, [r4], #-3689	; 0xfffff197
     314:	682e6665 	stmdavs	lr!, {r0, r2, r5, r6, r9, sl, sp, lr}
     318:	00000400 	andeq	r0, r0, r0, lsl #8
     31c:	00010500 	andeq	r0, r1, r0, lsl #10
     320:	822c0205 	eorhi	r0, ip, #1342177280	; 0x50000000
     324:	05170000 	ldreq	r0, [r7, #-0]
     328:	1f05a313 	svcne	0x0005a313
     32c:	4a220551 	bmi	881878 <__bss_end+0x877df8>
     330:	05820305 	streq	r0, [r2, #773]	; 0x305
     334:	0e054b04 	vmlaeq.f64	d4, d5, d4
     338:	2a030531 	bcs	c1804 <__bss_end+0xb7d84>
     33c:	01000202 	tsteq	r0, r2, lsl #4
     340:	00021801 	andeq	r1, r2, r1, lsl #16
     344:	2d000300 	stccs	3, cr0, [r0, #-0]
     348:	02000001 	andeq	r0, r0, #1
     34c:	0d0efb01 	vstreq	d15, [lr, #-4]
     350:	01010100 	mrseq	r0, (UNDEF: 17)
     354:	00000001 	andeq	r0, r0, r1
     358:	01000001 	tsteq	r0, r1
     35c:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 2a8 <shift+0x2a8>
     360:	72742f65 	rsbsvc	r2, r4, #404	; 0x194
     364:	6c696665 	stclvs	6, cr6, [r9], #-404	; 0xfffffe6c
     368:	6d65732f 	stclvs	3, cr7, [r5, #-188]!	; 0xffffff44
     36c:	756f732f 	strbvc	r7, [pc, #-815]!	; 45 <shift+0x45>
     370:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
     374:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
     378:	2f62696c 	svccs	0x0062696c
     37c:	00637273 	rsbeq	r7, r3, r3, ror r2
     380:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 2cc <shift+0x2cc>
     384:	72742f65 	rsbsvc	r2, r4, #404	; 0x194
     388:	6c696665 	stclvs	6, cr6, [r9], #-404	; 0xfffffe6c
     38c:	6d65732f 	stclvs	3, cr7, [r5, #-188]!	; 0xffffff44
     390:	756f732f 	strbvc	r7, [pc, #-815]!	; 69 <shift+0x69>
     394:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
     398:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
     39c:	2f6c656e 	svccs	0x006c656e
     3a0:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
     3a4:	2f656475 	svccs	0x00656475
     3a8:	636f7270 	cmnvs	pc, #112, 4
     3ac:	00737365 	rsbseq	r7, r3, r5, ror #6
     3b0:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 2fc <shift+0x2fc>
     3b4:	72742f65 	rsbsvc	r2, r4, #404	; 0x194
     3b8:	6c696665 	stclvs	6, cr6, [r9], #-404	; 0xfffffe6c
     3bc:	6d65732f 	stclvs	3, cr7, [r5, #-188]!	; 0xffffff44
     3c0:	756f732f 	strbvc	r7, [pc, #-815]!	; 99 <shift+0x99>
     3c4:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
     3c8:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
     3cc:	2f6c656e 	svccs	0x006c656e
     3d0:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
     3d4:	2f656475 	svccs	0x00656475
     3d8:	2f007366 	svccs	0x00007366
     3dc:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
     3e0:	6572742f 	ldrbvs	r7, [r2, #-1071]!	; 0xfffffbd1
     3e4:	2f6c6966 	svccs	0x006c6966
     3e8:	2f6d6573 	svccs	0x006d6573
     3ec:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
     3f0:	2f736563 	svccs	0x00736563
     3f4:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
     3f8:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
     3fc:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
     400:	622f6564 	eorvs	r6, pc, #100, 10	; 0x19000000
     404:	6472616f 	ldrbtvs	r6, [r2], #-367	; 0xfffffe91
     408:	6970722f 	ldmdbvs	r0!, {r0, r1, r2, r3, r5, r9, ip, sp, lr}^
     40c:	61682f30 	cmnvs	r8, r0, lsr pc
     410:	7300006c 	movwvc	r0, #108	; 0x6c
     414:	69666474 	stmdbvs	r6!, {r2, r4, r5, r6, sl, sp, lr}^
     418:	632e656c 			; <UNDEFINED> instruction: 0x632e656c
     41c:	01007070 	tsteq	r0, r0, ror r0
     420:	77730000 	ldrbvc	r0, [r3, -r0]!
     424:	00682e69 	rsbeq	r2, r8, r9, ror #28
     428:	73000002 	movwvc	r0, #2
     42c:	6c6e6970 			; <UNDEFINED> instruction: 0x6c6e6970
     430:	2e6b636f 	cdpcs	3, 6, cr6, cr11, cr15, {3}
     434:	00020068 	andeq	r0, r2, r8, rrx
     438:	6c696600 	stclvs	6, cr6, [r9], #-0
     43c:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     440:	2e6d6574 	mcrcs	5, 3, r6, cr13, cr4, {3}
     444:	00030068 	andeq	r0, r3, r8, rrx
     448:	6f727000 	svcvs	0x00727000
     44c:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     450:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
     454:	72700000 	rsbsvc	r0, r0, #0
     458:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     45c:	616d5f73 	smcvs	54771	; 0xd5f3
     460:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     464:	00682e72 	rsbeq	r2, r8, r2, ror lr
     468:	69000002 	stmdbvs	r0, {r1}
     46c:	6564746e 	strbvs	r7, [r4, #-1134]!	; 0xfffffb92
     470:	00682e66 	rsbeq	r2, r8, r6, ror #28
     474:	00000004 	andeq	r0, r0, r4
     478:	05000105 	streq	r0, [r0, #-261]	; 0xfffffefb
     47c:	00827402 	addeq	r7, r2, r2, lsl #8
     480:	05051600 	streq	r1, [r5, #-1536]	; 0xfffffa00
     484:	0c052f69 	stceq	15, cr2, [r5], {105}	; 0x69
     488:	2f01054c 	svccs	0x0001054c
     48c:	83050585 	movwhi	r0, #21893	; 0x5585
     490:	2f01054b 	svccs	0x0001054b
     494:	4b050585 	blmi	141ab0 <__bss_end+0x138030>
     498:	852f0105 	strhi	r0, [pc, #-261]!	; 39b <shift+0x39b>
     49c:	4ba10505 	blmi	fe8418b8 <__bss_end+0xfe837e38>
     4a0:	0c052f4b 	stceq	15, cr2, [r5], {75}	; 0x4b
     4a4:	2f01054c 	svccs	0x0001054c
     4a8:	bd050585 	cfstr32lt	mvfx0, [r5, #-532]	; 0xfffffdec
     4ac:	2f4b4b4b 	svccs	0x004b4b4b
     4b0:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
     4b4:	05862f01 	streq	r2, [r6, #3841]	; 0xf01
     4b8:	4b4bbd05 	blmi	12ef8d4 <__bss_end+0x12e5e54>
     4bc:	0c052f4b 	stceq	15, cr2, [r5], {75}	; 0x4b
     4c0:	2f01054c 	svccs	0x0001054c
     4c4:	83050585 	movwhi	r0, #21893	; 0x5585
     4c8:	2f01054b 	svccs	0x0001054b
     4cc:	bd050585 	cfstr32lt	mvfx0, [r5, #-532]	; 0xfffffdec
     4d0:	2f4b4b4b 	svccs	0x004b4b4b
     4d4:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
     4d8:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
     4dc:	4b4ba105 	blmi	12e88f8 <__bss_end+0x12dee78>
     4e0:	4c0c052f 	cfstr32mi	mvfx0, [ip], {47}	; 0x2f
     4e4:	852f0105 	strhi	r0, [pc, #-261]!	; 3e7 <shift+0x3e7>
     4e8:	4bbd0505 	blmi	fef41904 <__bss_end+0xfef37e84>
     4ec:	052f4b4b 	streq	r4, [pc, #-2891]!	; fffff9a9 <__bss_end+0xffff5f29>
     4f0:	01054c0c 	tsteq	r5, ip, lsl #24
     4f4:	0505852f 	streq	r8, [r5, #-1327]	; 0xfffffad1
     4f8:	2f4b4ba1 	svccs	0x004b4ba1
     4fc:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
     500:	05859f01 	streq	r9, [r5, #3841]	; 0xf01
     504:	05056720 	streq	r6, [r5, #-1824]	; 0xfffff8e0
     508:	054b4b4d 	strbeq	r4, [fp, #-2893]	; 0xfffff4b3
     50c:	0105300c 	tsteq	r5, ip
     510:	2005852f 	andcs	r8, r5, pc, lsr #10
     514:	4d050567 	cfstr32mi	mvfx0, [r5, #-412]	; 0xfffffe64
     518:	0c054b4b 			; <UNDEFINED> instruction: 0x0c054b4b
     51c:	2f010530 	svccs	0x00010530
     520:	83200585 			; <UNDEFINED> instruction: 0x83200585
     524:	4b4c0505 	blmi	1301940 <__bss_end+0x12f7ec0>
     528:	2f01054b 	svccs	0x0001054b
     52c:	67200585 	strvs	r0, [r0, -r5, lsl #11]!
     530:	4b4d0505 	blmi	134194c <__bss_end+0x1337ecc>
     534:	300c054b 	andcc	r0, ip, fp, asr #10
     538:	872f0105 	strhi	r0, [pc, -r5, lsl #2]!
     53c:	9fa00c05 	svcls	0x00a00c05
     540:	05bc3105 	ldreq	r3, [ip, #261]!	; 0x105
     544:	36056629 	strcc	r6, [r5], -r9, lsr #12
     548:	300f052e 	andcc	r0, pc, lr, lsr #10
     54c:	05661305 	strbeq	r1, [r6, #-773]!	; 0xfffffcfb
     550:	10058409 	andne	r8, r5, r9, lsl #8
     554:	9f0105d8 	svcls	0x000105d8
     558:	01000802 	tsteq	r0, r2, lsl #16
     55c:	00050d01 	andeq	r0, r5, r1, lsl #26
     560:	48000300 	stmdami	r0, {r8, r9}
     564:	02000000 	andeq	r0, r0, #0
     568:	0d0efb01 	vstreq	d15, [lr, #-4]
     56c:	01010100 	mrseq	r0, (UNDEF: 17)
     570:	00000001 	andeq	r0, r0, r1
     574:	01000001 	tsteq	r0, r1
     578:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 4c4 <shift+0x4c4>
     57c:	72742f65 	rsbsvc	r2, r4, #404	; 0x194
     580:	6c696665 	stclvs	6, cr6, [r9], #-404	; 0xfffffe6c
     584:	6d65732f 	stclvs	3, cr7, [r5, #-188]!	; 0xffffff44
     588:	756f732f 	strbvc	r7, [pc, #-815]!	; 261 <shift+0x261>
     58c:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
     590:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
     594:	2f62696c 	svccs	0x0062696c
     598:	00637273 	rsbeq	r7, r3, r3, ror r2
     59c:	64747300 	ldrbtvs	r7, [r4], #-768	; 0xfffffd00
     5a0:	69727473 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
     5a4:	632e676e 			; <UNDEFINED> instruction: 0x632e676e
     5a8:	01007070 	tsteq	r0, r0, ror r0
     5ac:	05000000 	streq	r0, [r0, #-0]
     5b0:	02050001 	andeq	r0, r5, #1
     5b4:	000086d0 	ldrdeq	r8, [r0], -r0
     5b8:	bb09051a 	bllt	241a28 <__bss_end+0x237fa8>
     5bc:	4c0f054b 	cfstr32mi	mvfx0, [pc], {75}	; 0x4b
     5c0:	05681b05 	strbeq	r1, [r8, #-2821]!	; 0xfffff4fb
     5c4:	0a052e21 	beq	14be50 <__bss_end+0x1423d0>
     5c8:	2e0b059e 	mcrcs	5, 0, r0, cr11, cr14, {4}
     5cc:	054a2705 	strbeq	r2, [sl, #-1797]	; 0xfffff8fb
     5d0:	09054a0d 	stmdbeq	r5, {r0, r2, r3, r9, fp, lr}
     5d4:	bb04052f 	bllt	101a98 <__bss_end+0xf8018>
     5d8:	05620205 	strbeq	r0, [r2, #-517]!	; 0xfffffdfb
     5dc:	10053505 	andne	r3, r5, r5, lsl #10
     5e0:	2e110568 	cfmsc32cs	mvfx0, mvfx1, mvfx8
     5e4:	054a2205 	strbeq	r2, [sl, #-517]	; 0xfffffdfb
     5e8:	0a052e13 	beq	14be3c <__bss_end+0x1423bc>
     5ec:	6909052f 	stmdbvs	r9, {r0, r1, r2, r3, r5, r8, sl}
     5f0:	052e0a05 	streq	r0, [lr, #-2565]!	; 0xfffff5fb
     5f4:	03054a0c 	movweq	r4, #23052	; 0x5a0c
     5f8:	0010054b 	andseq	r0, r0, fp, asr #10
     5fc:	68020402 	stmdavs	r2, {r1, sl}
     600:	02000c05 	andeq	r0, r0, #1280	; 0x500
     604:	059e0204 	ldreq	r0, [lr, #516]	; 0x204
     608:	04020015 	streq	r0, [r2], #-21	; 0xffffffeb
     60c:	18056801 	stmdane	r5, {r0, fp, sp, lr}
     610:	01040200 	mrseq	r0, R12_usr
     614:	00080582 	andeq	r0, r8, r2, lsl #11
     618:	4a010402 	bmi	41628 <__bss_end+0x37ba8>
     61c:	02001a05 	andeq	r1, r0, #20480	; 0x5000
     620:	054b0104 	strbeq	r0, [fp, #-260]	; 0xfffffefc
     624:	0402001b 	streq	r0, [r2], #-27	; 0xffffffe5
     628:	0c052e01 	stceq	14, cr2, [r5], {1}
     62c:	01040200 	mrseq	r0, R12_usr
     630:	000f054a 	andeq	r0, pc, sl, asr #10
     634:	82010402 	andhi	r0, r1, #33554432	; 0x2000000
     638:	02001b05 	andeq	r1, r0, #5120	; 0x1400
     63c:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
     640:	04020011 	streq	r0, [r2], #-17	; 0xffffffef
     644:	0a052e01 	beq	14be50 <__bss_end+0x1423d0>
     648:	01040200 	mrseq	r0, R12_usr
     64c:	000b052f 	andeq	r0, fp, pc, lsr #10
     650:	2e010402 	cdpcs	4, 0, cr0, cr1, cr2, {0}
     654:	02000d05 	andeq	r0, r0, #320	; 0x140
     658:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
     65c:	04020002 	streq	r0, [r2], #-2
     660:	01054601 	tsteq	r5, r1, lsl #12
     664:	0e058589 	cfsh32eq	mvfx8, mvfx5, #-55
     668:	66160583 	ldrvs	r0, [r6], -r3, lsl #11
     66c:	05820505 	streq	r0, [r2, #1285]	; 0x505
     670:	19054b10 	stmdbne	r5, {r4, r8, r9, fp, lr}
     674:	4b06054a 	blmi	181ba4 <__bss_end+0x178124>
     678:	054c0905 	strbeq	r0, [ip, #-2309]	; 0xfffff6fb
     67c:	0a054a10 	beq	152ec4 <__bss_end+0x149444>
     680:	bb07054c 	bllt	1c1bb8 <__bss_end+0x1b8138>
     684:	054a0305 	strbeq	r0, [sl, #-773]	; 0xfffffcfb
     688:	04020017 	streq	r0, [r2], #-23	; 0xffffffe9
     68c:	14054a01 	strne	r4, [r5], #-2561	; 0xfffff5ff
     690:	01040200 	mrseq	r0, R12_usr
     694:	4d0d054a 	cfstr32mi	mvfx0, [sp, #-296]	; 0xfffffed8
     698:	054a1405 	strbeq	r1, [sl, #-1029]	; 0xfffffbfb
     69c:	08052e0a 	stmdaeq	r5, {r1, r3, r9, sl, fp, sp}
     6a0:	03020568 	movweq	r0, #9576	; 0x2568
     6a4:	09056678 	stmdbeq	r5, {r3, r4, r5, r6, r9, sl, sp, lr}
     6a8:	052e0b03 	streq	r0, [lr, #-2819]!	; 0xfffff4fd
     6ac:	27052f01 	strcs	r2, [r5, -r1, lsl #30]
     6b0:	840a056a 	strhi	r0, [sl], #-1386	; 0xfffffa96
     6b4:	4b0b054b 	blmi	2c1be8 <__bss_end+0x2b8168>
     6b8:	054a1205 	strbeq	r1, [sl, #-517]	; 0xfffffdfb
     6bc:	09054b0e 	stmdbeq	r5, {r1, r2, r3, r8, r9, fp, lr}
     6c0:	00180567 	andseq	r0, r8, r7, ror #10
     6c4:	66010402 	strvs	r0, [r1], -r2, lsl #8
     6c8:	02001505 	andeq	r1, r0, #20971520	; 0x1400000
     6cc:	05660104 	strbeq	r0, [r6, #-260]!	; 0xfffffefc
     6d0:	04020011 	streq	r0, [r2], #-17	; 0xffffffef
     6d4:	1a054b02 	bne	1532e4 <__bss_end+0x149864>
     6d8:	02040200 	andeq	r0, r4, #0, 4
     6dc:	0012054b 	andseq	r0, r2, fp, asr #10
     6e0:	4b020402 	blmi	816f0 <__bss_end+0x77c70>
     6e4:	02000d05 	andeq	r0, r0, #320	; 0x140
     6e8:	05670204 	strbeq	r0, [r7, #-516]!	; 0xfffffdfc
     6ec:	14053109 	strne	r3, [r5], #-265	; 0xfffffef7
     6f0:	02040200 	andeq	r0, r4, #0, 4
     6f4:	00260566 	eoreq	r0, r6, r6, ror #10
     6f8:	66030402 	strvs	r0, [r3], -r2, lsl #8
     6fc:	054c0905 	strbeq	r0, [ip, #-2309]	; 0xfffff6fb
     700:	0a05671a 	beq	15a370 <__bss_end+0x1508f0>
     704:	0305054b 	movweq	r0, #21835	; 0x554b
     708:	0f036673 	svceq	0x00036673
     70c:	001c052e 	andseq	r0, ip, lr, lsr #10
     710:	66010402 	strvs	r0, [r1], -r2, lsl #8
     714:	004c0f05 	subeq	r0, ip, r5, lsl #30
     718:	06010402 	streq	r0, [r1], -r2, lsl #8
     71c:	00130566 	andseq	r0, r3, r6, ror #10
     720:	06010402 	streq	r0, [r1], -r2, lsl #8
     724:	000f052e 	andeq	r0, pc, lr, lsr #10
     728:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
     72c:	052e1305 	streq	r1, [lr, #-773]!	; 0xfffffcfb
     730:	1e053001 	cdpne	0, 0, cr3, cr5, cr1, {0}
     734:	830c0586 	movwhi	r0, #50566	; 0xc586
     738:	09056867 	stmdbeq	r5, {r0, r1, r2, r5, r6, fp, sp, lr}
     73c:	0a054b67 	beq	1534e0 <__bss_end+0x149a60>
     740:	4c0b054b 	cfstr32mi	mvfx0, [fp], {75}	; 0x4b
     744:	054a1205 	strbeq	r1, [sl, #-517]	; 0xfffffdfb
     748:	09054b0d 	stmdbeq	r5, {r0, r2, r3, r8, r9, fp, lr}
     74c:	001b054a 	andseq	r0, fp, sl, asr #10
     750:	4b010402 	blmi	41760 <__bss_end+0x37ce0>
     754:	02001205 	andeq	r1, r0, #1342177280	; 0x50000000
     758:	054b0104 	strbeq	r0, [fp, #-260]	; 0xfffffefc
     75c:	0402000d 	streq	r0, [r2], #-13
     760:	12056701 	andne	r6, r5, #262144	; 0x40000
     764:	4a0e0530 	bmi	381c2c <__bss_end+0x3781ac>
     768:	02002205 	andeq	r2, r0, #1342177280	; 0x50000000
     76c:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
     770:	0402001f 	streq	r0, [r2], #-31	; 0xffffffe1
     774:	16054a01 	strne	r4, [r5], -r1, lsl #20
     778:	4a1d054b 	bmi	741cac <__bss_end+0x73822c>
     77c:	052e1005 	streq	r1, [lr, #-5]!
     780:	13056709 	movwne	r6, #22281	; 0x5709
     784:	d7230567 	strle	r0, [r3, -r7, ror #10]!
     788:	059e1405 	ldreq	r1, [lr, #1029]	; 0x405
     78c:	1405851d 	strne	r8, [r5], #-1309	; 0xfffffae3
     790:	680e0566 	stmdavs	lr, {r1, r2, r5, r6, r8, sl}
     794:	71030505 	tstvc	r3, r5, lsl #10
     798:	030c0566 	movweq	r0, #50534	; 0xc566
     79c:	01052e11 	tsteq	r5, r1, lsl lr
     7a0:	0522084b 	streq	r0, [r2, #-2123]!	; 0xfffff7b5
     7a4:	1605bd09 	strne	fp, [r5], -r9, lsl #26
     7a8:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
     7ac:	001d054a 	andseq	r0, sp, sl, asr #10
     7b0:	82020402 	andhi	r0, r2, #33554432	; 0x2000000
     7b4:	02001e05 	andeq	r1, r0, #5, 28	; 0x50
     7b8:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
     7bc:	04020016 	streq	r0, [r2], #-22	; 0xffffffea
     7c0:	11056602 	tstne	r5, r2, lsl #12
     7c4:	03040200 	movweq	r0, #16896	; 0x4200
     7c8:	0012054b 	andseq	r0, r2, fp, asr #10
     7cc:	2e030402 	cdpcs	4, 0, cr0, cr3, cr2, {0}
     7d0:	02000805 	andeq	r0, r0, #327680	; 0x50000
     7d4:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
     7d8:	04020009 	streq	r0, [r2], #-9
     7dc:	12052e03 	andne	r2, r5, #3, 28	; 0x30
     7e0:	03040200 	movweq	r0, #16896	; 0x4200
     7e4:	000b054a 	andeq	r0, fp, sl, asr #10
     7e8:	2e030402 	cdpcs	4, 0, cr0, cr3, cr2, {0}
     7ec:	02000205 	andeq	r0, r0, #1342177280	; 0x50000000
     7f0:	052d0304 	streq	r0, [sp, #-772]!	; 0xfffffcfc
     7f4:	0402000b 	streq	r0, [r2], #-11
     7f8:	08058402 	stmdaeq	r5, {r1, sl, pc}
     7fc:	01040200 	mrseq	r0, R12_usr
     800:	00090583 	andeq	r0, r9, r3, lsl #11
     804:	2e010402 	cdpcs	4, 0, cr0, cr1, cr2, {0}
     808:	02000b05 	andeq	r0, r0, #5120	; 0x1400
     80c:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
     810:	04020002 	streq	r0, [r2], #-2
     814:	0b054901 	bleq	152c20 <__bss_end+0x1491a0>
     818:	2f010585 	svccs	0x00010585
     81c:	bc0e0585 	cfstr32lt	mvfx0, [lr], {133}	; 0x85
     820:	05661105 	strbeq	r1, [r6, #-261]!	; 0xfffffefb
     824:	0b05bc20 	bleq	16f8ac <__bss_end+0x165e2c>
     828:	4b1f0566 	blmi	7c1dc8 <__bss_end+0x7b8348>
     82c:	05660a05 	strbeq	r0, [r6, #-2565]!	; 0xfffff5fb
     830:	11054b08 	tstne	r5, r8, lsl #22
     834:	2e160583 	cdpcs	5, 1, cr0, cr6, cr3, {4}
     838:	05670805 	strbeq	r0, [r7, #-2053]!	; 0xfffff7fb
     83c:	0b056711 	bleq	15a488 <__bss_end+0x150a08>
     840:	2f01054d 	svccs	0x0001054d
     844:	83060585 	movwhi	r0, #25989	; 0x6585
     848:	054c0b05 	strbeq	r0, [ip, #-2821]	; 0xfffff4fb
     84c:	0e052e0c 	cdpeq	14, 0, cr2, cr5, cr12, {0}
     850:	4b040566 	blmi	101df0 <__bss_end+0xf8370>
     854:	05650205 	strbeq	r0, [r5, #-517]!	; 0xfffffdfb
     858:	01053109 	tsteq	r5, r9, lsl #2
     85c:	852a052f 	strhi	r0, [sl, #-1327]!	; 0xfffffad1
     860:	679f1305 	ldrvs	r1, [pc, r5, lsl #6]
     864:	05670905 	strbeq	r0, [r7, #-2309]!	; 0xfffff6fb
     868:	15054b0d 	strne	r4, [r5, #-2829]	; 0xfffff4f3
     86c:	03040200 	movweq	r0, #16896	; 0x4200
     870:	0019054a 	andseq	r0, r9, sl, asr #10
     874:	83020402 	movwhi	r0, #9218	; 0x2402
     878:	02001a05 	andeq	r1, r0, #20480	; 0x5000
     87c:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
     880:	0402000f 	streq	r0, [r2], #-15
     884:	11054a02 	tstne	r5, r2, lsl #20
     888:	02040200 	andeq	r0, r4, #0, 4
     88c:	001a0582 	andseq	r0, sl, r2, lsl #11
     890:	4a020402 	bmi	818a0 <__bss_end+0x77e20>
     894:	02001305 	andeq	r1, r0, #335544320	; 0x14000000
     898:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
     89c:	04020005 	streq	r0, [r2], #-5
     8a0:	0a052d02 	beq	14bcb0 <__bss_end+0x142230>
     8a4:	2e0b0584 	cfsh32cs	mvfx0, mvfx11, #-60
     8a8:	054a0d05 	strbeq	r0, [sl, #-3333]	; 0xfffff2fb
     8ac:	01054b0c 	tsteq	r5, ip, lsl #22
     8b0:	67340530 			; <UNDEFINED> instruction: 0x67340530
     8b4:	05bb0905 	ldreq	r0, [fp, #2309]!	; 0x905
     8b8:	05054c13 	streq	r4, [r5, #-3091]	; 0xfffff3ed
     8bc:	00190568 	andseq	r0, r9, r8, ror #10
     8c0:	82010402 	andhi	r0, r1, #33554432	; 0x2000000
     8c4:	054c0d05 	strbeq	r0, [ip, #-3333]	; 0xfffff2fb
     8c8:	04020015 	streq	r0, [r2], #-21	; 0xffffffeb
     8cc:	10054a01 	andne	r4, r5, r1, lsl #20
     8d0:	2e110583 	cdpcs	5, 1, cr0, cr1, cr3, {4}
     8d4:	05660905 	strbeq	r0, [r6, #-2309]!	; 0xfffff6fb
     8d8:	04020019 	streq	r0, [r2], #-25	; 0xffffffe7
     8dc:	1a054b02 	bne	1534ec <__bss_end+0x149a6c>
     8e0:	02040200 	andeq	r0, r4, #0, 4
     8e4:	000f052e 	andeq	r0, pc, lr, lsr #10
     8e8:	4a020402 	bmi	818f8 <__bss_end+0x77e78>
     8ec:	02001105 	andeq	r1, r0, #1073741825	; 0x40000001
     8f0:	05820204 	streq	r0, [r2, #516]	; 0x204
     8f4:	0402001a 	streq	r0, [r2], #-26	; 0xffffffe6
     8f8:	13054a02 	movwne	r4, #23042	; 0x5a02
     8fc:	02040200 	andeq	r0, r4, #0, 4
     900:	0005052e 	andeq	r0, r5, lr, lsr #10
     904:	2c020402 	cfstrscs	mvf0, [r2], {2}
     908:	05831b05 	streq	r1, [r3, #2821]	; 0xb05
     90c:	0b05310a 	bleq	14cd3c <__bss_end+0x1432bc>
     910:	4a0d052e 	bmi	341dd0 <__bss_end+0x338350>
     914:	054b0c05 	strbeq	r0, [fp, #-3077]	; 0xfffff3fb
     918:	056a3001 	strbeq	r3, [sl, #-1]!
     91c:	0b059f08 	bleq	168544 <__bss_end+0x15eac4>
     920:	0014054c 	andseq	r0, r4, ip, asr #10
     924:	4a030402 	bmi	c1934 <__bss_end+0xb7eb4>
     928:	02000705 	andeq	r0, r0, #1310720	; 0x140000
     92c:	05830204 	streq	r0, [r3, #516]	; 0x204
     930:	04020008 	streq	r0, [r2], #-8
     934:	0a052e02 	beq	14c144 <__bss_end+0x1426c4>
     938:	02040200 	andeq	r0, r4, #0, 4
     93c:	0002054a 	andeq	r0, r2, sl, asr #10
     940:	49020402 	stmdbmi	r2, {r1, sl}
     944:	85840105 	strhi	r0, [r4, #261]	; 0x105
     948:	05bb0e05 	ldreq	r0, [fp, #3589]!	; 0xe05
     94c:	0b054b08 	bleq	153574 <__bss_end+0x149af4>
     950:	0014054c 	andseq	r0, r4, ip, asr #10
     954:	4a030402 	bmi	c1964 <__bss_end+0xb7ee4>
     958:	02001605 	andeq	r1, r0, #5242880	; 0x500000
     95c:	05830204 	streq	r0, [r3, #516]	; 0x204
     960:	04020017 	streq	r0, [r2], #-23	; 0xffffffe9
     964:	0a052e02 	beq	14c174 <__bss_end+0x1426f4>
     968:	02040200 	andeq	r0, r4, #0, 4
     96c:	000b054a 	andeq	r0, fp, sl, asr #10
     970:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
     974:	02001705 	andeq	r1, r0, #1310720	; 0x140000
     978:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
     97c:	0402000d 	streq	r0, [r2], #-13
     980:	02052e02 	andeq	r2, r5, #2, 28
     984:	02040200 	andeq	r0, r4, #0, 4
     988:	8401052d 	strhi	r0, [r1], #-1325	; 0xfffffad3
     98c:	9f090587 	svcls	0x00090587
     990:	054b1005 	strbeq	r1, [fp, #-5]
     994:	10056613 	andne	r6, r5, r3, lsl r6
     998:	810505bb 			; <UNDEFINED> instruction: 0x810505bb
     99c:	05310c05 	ldreq	r0, [r1, #-3077]!	; 0xfffff3fb
     9a0:	05862f01 	streq	r2, [r6, #3841]	; 0xf01
     9a4:	0505a20a 	streq	sl, [r5, #-522]	; 0xfffffdf6
     9a8:	840e0567 	strhi	r0, [lr], #-1383	; 0xfffffa99
     9ac:	05670b05 	strbeq	r0, [r7, #-2821]!	; 0xfffff4fb
     9b0:	0c05690d 			; <UNDEFINED> instruction: 0x0c05690d
     9b4:	0d059f4b 	stceq	15, cr9, [r5, #-300]	; 0xfffffed4
     9b8:	69170567 	ldmdbvs	r7, {r0, r1, r2, r5, r6, r8, sl}
     9bc:	05661505 	strbeq	r1, [r6, #-1285]!	; 0xfffffafb
     9c0:	3d054a2d 	vstrcc	s8, [r5, #-180]	; 0xffffff4c
     9c4:	01040200 	mrseq	r0, R12_usr
     9c8:	003b0566 	eorseq	r0, fp, r6, ror #10
     9cc:	66010402 	strvs	r0, [r1], -r2, lsl #8
     9d0:	02002d05 	andeq	r2, r0, #320	; 0x140
     9d4:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
     9d8:	1c05682b 	stcne	8, cr6, [r5], {43}	; 0x2b
     9dc:	8215054a 	andshi	r0, r5, #310378496	; 0x12800000
     9e0:	052e1105 	streq	r1, [lr, #-261]!	; 0xfffffefb
     9e4:	05a06710 	streq	r6, [r0, #1808]!	; 0x710
     9e8:	16057d05 	strne	r7, [r5], -r5, lsl #26
     9ec:	052e0903 	streq	r0, [lr, #-2307]!	; 0xfffff6fd
     9f0:	1105d61b 	tstne	r5, fp, lsl r6
     9f4:	0026054a 	eoreq	r0, r6, sl, asr #10
     9f8:	ba030402 	blt	c1a08 <__bss_end+0xb7f88>
     9fc:	02000b05 	andeq	r0, r0, #5120	; 0x1400
     a00:	059f0204 	ldreq	r0, [pc, #516]	; c0c <shift+0xc0c>
     a04:	04020005 	streq	r0, [r2], #-5
     a08:	0e058102 	mvfeqs	f0, f2
     a0c:	4b1505f5 	blmi	5421e8 <__bss_end+0x538768>
     a10:	d7660c05 	strble	r0, [r6, -r5, lsl #24]!
     a14:	059f0505 	ldreq	r0, [pc, #1285]	; f21 <shift+0xf21>
     a18:	1105840f 	tstne	r5, pc, lsl #8
     a1c:	d90c05d7 	stmdble	ip, {r0, r1, r2, r4, r6, r7, r8, sl}
     a20:	02001805 	andeq	r1, r0, #327680	; 0x50000
     a24:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
     a28:	10056809 	andne	r6, r5, r9, lsl #16
     a2c:	6612059f 			; <UNDEFINED> instruction: 0x6612059f
     a30:	05670e05 	strbeq	r0, [r7, #-3589]!	; 0xfffff1fb
     a34:	12059f10 	andne	r9, r5, #16, 30	; 0x40
     a38:	670e0566 	strvs	r0, [lr, -r6, ror #10]
     a3c:	02001d05 	andeq	r1, r0, #320	; 0x140
     a40:	05820104 	streq	r0, [r2, #260]	; 0x104
     a44:	12056710 	andne	r6, r5, #16, 14	; 0x400000
     a48:	691c0566 	ldmdbvs	ip, {r1, r2, r5, r6, r8, sl}
     a4c:	05822205 	streq	r2, [r2, #517]	; 0x205
     a50:	22052e10 	andcs	r2, r5, #16, 28	; 0x100
     a54:	4a120566 	bmi	481ff4 <__bss_end+0x478574>
     a58:	052f1405 	streq	r1, [pc, #-1029]!	; 65b <shift+0x65b>
     a5c:	04020005 	streq	r0, [r2], #-5
     a60:	d6750302 	ldrbtle	r0, [r5], -r2, lsl #6
     a64:	0e030105 	adfeqs	f0, f3, f5
     a68:	000a029e 	muleq	sl, lr, r2
     a6c:	00790101 	rsbseq	r0, r9, r1, lsl #2
     a70:	00030000 	andeq	r0, r3, r0
     a74:	00000046 	andeq	r0, r0, r6, asr #32
     a78:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
     a7c:	0101000d 	tsteq	r1, sp
     a80:	00000101 	andeq	r0, r0, r1, lsl #2
     a84:	00000100 	andeq	r0, r0, r0, lsl #2
     a88:	2f2e2e01 	svccs	0x002e2e01
     a8c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     a90:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     a94:	2f2e2e2f 	svccs	0x002e2e2f
     a98:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; 9e8 <shift+0x9e8>
     a9c:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
     aa0:	6f632f63 	svcvs	0x00632f63
     aa4:	6769666e 	strbvs	r6, [r9, -lr, ror #12]!
     aa8:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
     aac:	696c0000 	stmdbvs	ip!, {}^	; <UNPREDICTABLE>
     ab0:	75663162 	strbvc	r3, [r6, #-354]!	; 0xfffffe9e
     ab4:	2e73636e 	cdpcs	3, 7, cr6, cr3, cr14, {3}
     ab8:	00010053 	andeq	r0, r1, r3, asr r0
     abc:	05000000 	streq	r0, [r0, #-0]
     ac0:	00932c02 	addseq	r2, r3, r2, lsl #24
     ac4:	08cf0300 	stmiaeq	pc, {r8, r9}^	; <UNPREDICTABLE>
     ac8:	2f2f3001 	svccs	0x002f3001
     acc:	302f2f2f 	eorcc	r2, pc, pc, lsr #30
     ad0:	1401d002 	strne	sp, [r1], #-2
     ad4:	2f2f312f 	svccs	0x002f312f
     ad8:	322f4c30 	eorcc	r4, pc, #48, 24	; 0x3000
     adc:	2f661f03 	svccs	0x00661f03
     ae0:	2f2f2f2f 	svccs	0x002f2f2f
     ae4:	02022f2f 	andeq	r2, r2, #47, 30	; 0xbc
     ae8:	5c010100 	stfpls	f0, [r1], {-0}
     aec:	03000000 	movweq	r0, #0
     af0:	00004600 	andeq	r4, r0, r0, lsl #12
     af4:	fb010200 	blx	412fe <__bss_end+0x3787e>
     af8:	01000d0e 	tsteq	r0, lr, lsl #26
     afc:	00010101 	andeq	r0, r1, r1, lsl #2
     b00:	00010000 	andeq	r0, r1, r0
     b04:	2e2e0100 	sufcse	f0, f6, f0
     b08:	2f2e2e2f 	svccs	0x002e2e2f
     b0c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     b10:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     b14:	2f2e2e2f 	svccs	0x002e2e2f
     b18:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
     b1c:	632f6363 			; <UNDEFINED> instruction: 0x632f6363
     b20:	69666e6f 	stmdbvs	r6!, {r0, r1, r2, r3, r5, r6, r9, sl, fp, sp, lr}^
     b24:	72612f67 	rsbvc	r2, r1, #412	; 0x19c
     b28:	6c00006d 	stcvs	0, cr0, [r0], {109}	; 0x6d
     b2c:	66316269 	ldrtvs	r6, [r1], -r9, ror #4
     b30:	73636e75 	cmnvc	r3, #1872	; 0x750
     b34:	0100532e 	tsteq	r0, lr, lsr #6
     b38:	00000000 	andeq	r0, r0, r0
     b3c:	95380205 	ldrls	r0, [r8, #-517]!	; 0xfffffdfb
     b40:	b9030000 	stmdblt	r3, {}	; <UNPREDICTABLE>
     b44:	0202010b 	andeq	r0, r2, #-1073741822	; 0xc0000002
     b48:	fb010100 	blx	40f52 <__bss_end+0x374d2>
     b4c:	03000000 	movweq	r0, #0
     b50:	00004700 	andeq	r4, r0, r0, lsl #14
     b54:	fb010200 	blx	4135e <__bss_end+0x378de>
     b58:	01000d0e 	tsteq	r0, lr, lsl #26
     b5c:	00010101 	andeq	r0, r1, r1, lsl #2
     b60:	00010000 	andeq	r0, r1, r0
     b64:	2e2e0100 	sufcse	f0, f6, f0
     b68:	2f2e2e2f 	svccs	0x002e2e2f
     b6c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     b70:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     b74:	2f2e2e2f 	svccs	0x002e2e2f
     b78:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
     b7c:	632f6363 			; <UNDEFINED> instruction: 0x632f6363
     b80:	69666e6f 	stmdbvs	r6!, {r0, r1, r2, r3, r5, r6, r9, sl, fp, sp, lr}^
     b84:	72612f67 	rsbvc	r2, r1, #412	; 0x19c
     b88:	6900006d 	stmdbvs	r0, {r0, r2, r3, r5, r6}
     b8c:	37656565 	strbcc	r6, [r5, -r5, ror #10]!
     b90:	732d3435 			; <UNDEFINED> instruction: 0x732d3435
     b94:	00532e66 	subseq	r2, r3, r6, ror #28
     b98:	00000001 	andeq	r0, r0, r1
     b9c:	3c020500 	cfstr32cc	mvfx0, [r2], {-0}
     ba0:	03000095 	movweq	r0, #149	; 0x95
     ba4:	332f013a 			; <UNDEFINED> instruction: 0x332f013a
     ba8:	302e0903 	eorcc	r0, lr, r3, lsl #18
     bac:	2f2f2f2f 	svccs	0x002f2f2f
     bb0:	2f302f32 	svccs	0x00302f32
     bb4:	33302f2f 	teqcc	r0, #47, 30	; 0xbc
     bb8:	2f2f3130 	svccs	0x002f3130
     bbc:	2f2f2f30 	svccs	0x002f2f30
     bc0:	322f3230 	eorcc	r3, pc, #48, 4
     bc4:	312f2f32 			; <UNDEFINED> instruction: 0x312f2f32
     bc8:	332f332f 			; <UNDEFINED> instruction: 0x332f332f
     bcc:	312f2f2f 			; <UNDEFINED> instruction: 0x312f2f2f
     bd0:	2f312f2f 	svccs	0x00312f2f
     bd4:	2f302f35 	svccs	0x00302f35
     bd8:	2f2f322f 	svccs	0x002f322f
     bdc:	19032f30 	stmdbne	r3, {r4, r5, r8, r9, sl, fp, sp}
     be0:	2f2f2f2e 	svccs	0x002f2f2e
     be4:	342f2f35 	strtcc	r2, [pc], #-3893	; bec <shift+0xbec>
     be8:	302f3330 	eorcc	r3, pc, r0, lsr r3	; <UNPREDICTABLE>
     bec:	312f2f2f 			; <UNDEFINED> instruction: 0x312f2f2f
     bf0:	302f3030 	eorcc	r3, pc, r0, lsr r0	; <UNPREDICTABLE>
     bf4:	2f30312f 	svccs	0x0030312f
     bf8:	312f3230 			; <UNDEFINED> instruction: 0x312f3230
     bfc:	2f302f2f 	svccs	0x00302f2f
     c00:	2f2f302f 	svccs	0x002f302f
     c04:	032f2f32 			; <UNDEFINED> instruction: 0x032f2f32
     c08:	2f302e09 	svccs	0x00302e09
     c0c:	2f302f2f 	svccs	0x00302f2f
     c10:	0d032f2f 	stceq	15, cr2, [r3, #-188]	; 0xffffff44
     c14:	30332f2e 	eorscc	r2, r3, lr, lsr #30
     c18:	31313030 	teqcc	r1, r0, lsr r0
     c1c:	0c032f30 	stceq	15, cr2, [r3], {48}	; 0x30
     c20:	2f30302e 	svccs	0x0030302e
     c24:	2f303033 	svccs	0x00303033
     c28:	30312f33 	eorscc	r2, r1, r3, lsr pc
     c2c:	30312f2f 	eorscc	r2, r1, pc, lsr #30
     c30:	2e19032f 	cdpcs	3, 1, cr0, cr9, cr15, {1}
     c34:	302f322f 	eorcc	r3, pc, pc, lsr #4
     c38:	2f2f2f2f 	svccs	0x002f2f2f
     c3c:	2f302f30 	svccs	0x00302f30
     c40:	302f2f2f 	eorcc	r2, pc, pc, lsr #30
     c44:	0002022f 	andeq	r0, r2, pc, lsr #4
     c48:	007a0101 	rsbseq	r0, sl, r1, lsl #2
     c4c:	00030000 	andeq	r0, r3, r0
     c50:	00000042 	andeq	r0, r0, r2, asr #32
     c54:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
     c58:	0101000d 	tsteq	r1, sp
     c5c:	00000101 	andeq	r0, r0, r1, lsl #2
     c60:	00000100 	andeq	r0, r0, r0, lsl #2
     c64:	2f2e2e01 	svccs	0x002e2e01
     c68:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     c6c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     c70:	2f2e2e2f 	svccs	0x002e2e2f
     c74:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; bc4 <shift+0xbc4>
     c78:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
     c7c:	6f632f63 	svcvs	0x00632f63
     c80:	6769666e 	strbvs	r6, [r9, -lr, ror #12]!
     c84:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
     c88:	70620000 	rsbvc	r0, r2, r0
     c8c:	2e696261 	cdpcs	2, 6, cr6, cr9, cr1, {3}
     c90:	00010053 	andeq	r0, r1, r3, asr r0
     c94:	05000000 	streq	r0, [r0, #-0]
     c98:	00978c02 	addseq	r8, r7, r2, lsl #24
     c9c:	01b90300 			; <UNDEFINED> instruction: 0x01b90300
     ca0:	4b5a0801 	blmi	1682cac <__bss_end+0x167922c>
     ca4:	302f2f2f 	eorcc	r2, pc, pc, lsr #30
     ca8:	2f326730 	svccs	0x00326730
     cac:	30302f2f 	eorscc	r2, r0, pc, lsr #30
     cb0:	2f2f2f67 	svccs	0x002f2f67
     cb4:	302f322f 	eorcc	r3, pc, pc, lsr #4
     cb8:	2f2f6730 	svccs	0x002f6730
     cbc:	2f302f32 	svccs	0x00302f32
     cc0:	022f2f67 	eoreq	r2, pc, #412	; 0x19c
     cc4:	01010002 	tsteq	r1, r2
     cc8:	000000a4 	andeq	r0, r0, r4, lsr #1
     ccc:	009e0003 	addseq	r0, lr, r3
     cd0:	01020000 	mrseq	r0, (UNDEF: 2)
     cd4:	000d0efb 	strdeq	r0, [sp], -fp
     cd8:	01010101 	tsteq	r1, r1, lsl #2
     cdc:	01000000 	mrseq	r0, (UNDEF: 0)
     ce0:	2e010000 	cdpcs	0, 0, cr0, cr1, cr0, {0}
     ce4:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     ce8:	2f2e2e2f 	svccs	0x002e2e2f
     cec:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     cf0:	2f2e2f2e 	svccs	0x002e2f2e
     cf4:	00636367 	rsbeq	r6, r3, r7, ror #6
     cf8:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     cfc:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     d00:	2f2e2e2f 	svccs	0x002e2e2f
     d04:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     d08:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
     d0c:	63636762 	cmnvs	r3, #25690112	; 0x1880000
     d10:	2f2e2e2f 	svccs	0x002e2e2f
     d14:	2f636367 	svccs	0x00636367
     d18:	666e6f63 	strbtvs	r6, [lr], -r3, ror #30
     d1c:	612f6769 			; <UNDEFINED> instruction: 0x612f6769
     d20:	2e006d72 	mcrcs	13, 0, r6, cr0, cr2, {3}
     d24:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     d28:	2f2e2e2f 	svccs	0x002e2e2f
     d2c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     d30:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     d34:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
     d38:	00636367 	rsbeq	r6, r3, r7, ror #6
     d3c:	6d726100 	ldfvse	f6, [r2, #-0]
     d40:	6173692d 	cmnvs	r3, sp, lsr #18
     d44:	0100682e 	tsteq	r0, lr, lsr #16
     d48:	72610000 	rsbvc	r0, r1, #0
     d4c:	00682e6d 	rsbeq	r2, r8, sp, ror #28
     d50:	67000002 	strvs	r0, [r0, -r2]
     d54:	632d6c62 			; <UNDEFINED> instruction: 0x632d6c62
     d58:	73726f74 	cmnvc	r2, #116, 30	; 0x1d0
     d5c:	0300682e 	movweq	r6, #2094	; 0x82e
     d60:	696c0000 	stmdbvs	ip!, {}^	; <UNPREDICTABLE>
     d64:	63636762 	cmnvs	r3, #25690112	; 0x1880000
     d68:	00632e32 	rsbeq	r2, r3, r2, lsr lr
     d6c:	00000003 	andeq	r0, r0, r3
     d70:	000000a7 	andeq	r0, r0, r7, lsr #1
     d74:	00680003 	rsbeq	r0, r8, r3
     d78:	01020000 	mrseq	r0, (UNDEF: 2)
     d7c:	000d0efb 	strdeq	r0, [sp], -fp
     d80:	01010101 	tsteq	r1, r1, lsl #2
     d84:	01000000 	mrseq	r0, (UNDEF: 0)
     d88:	2e010000 	cdpcs	0, 0, cr0, cr1, cr0, {0}
     d8c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     d90:	2f2e2e2f 	svccs	0x002e2e2f
     d94:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     d98:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     d9c:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
     da0:	00636367 	rsbeq	r6, r3, r7, ror #6
     da4:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     da8:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     dac:	2f2e2e2f 	svccs	0x002e2e2f
     db0:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     db4:	6363672f 	cmnvs	r3, #12320768	; 0xbc0000
     db8:	696c0000 	stmdbvs	ip!, {}^	; <UNPREDICTABLE>
     dbc:	63636762 	cmnvs	r3, #25690112	; 0x1880000
     dc0:	00632e32 	rsbeq	r2, r3, r2, lsr lr
     dc4:	61000001 	tstvs	r0, r1
     dc8:	692d6d72 	pushvs	{r1, r4, r5, r6, r8, sl, fp, sp, lr}
     dcc:	682e6173 	stmdavs	lr!, {r0, r1, r4, r5, r6, r8, sp, lr}
     dd0:	00000200 	andeq	r0, r0, r0, lsl #4
     dd4:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
     dd8:	2e326363 	cdpcs	3, 3, cr6, cr2, cr3, {3}
     ddc:	00010068 	andeq	r0, r1, r8, rrx
     de0:	01050000 	mrseq	r0, (UNDEF: 5)
     de4:	60020500 	andvs	r0, r2, r0, lsl #10
     de8:	03000098 	movweq	r0, #152	; 0x98
     dec:	05010bf9 	streq	r0, [r1, #-3065]	; 0xfffff407
     df0:	01051303 	tsteq	r5, r3, lsl #6
     df4:	06051106 	streq	r1, [r5], -r6, lsl #2
     df8:	0603052f 	streq	r0, [r3], -pc, lsr #10
     dfc:	060a0568 	streq	r0, [sl], -r8, ror #10
     e00:	06050501 	streq	r0, [r5], -r1, lsl #10
     e04:	060e052d 	streq	r0, [lr], -sp, lsr #10
     e08:	2c010501 	cfstr32cs	mvfx0, [r1], {1}
     e0c:	2e300e05 	cdpcs	14, 3, cr0, cr0, cr5, {0}
     e10:	052e0c05 	streq	r0, [lr, #-3077]!	; 0xfffff3fb
     e14:	02024c01 	andeq	r4, r2, #256	; 0x100
     e18:	b6010100 	strlt	r0, [r1], -r0, lsl #2
     e1c:	03000000 	movweq	r0, #0
     e20:	00006800 	andeq	r6, r0, r0, lsl #16
     e24:	fb010200 	blx	4162e <__bss_end+0x37bae>
     e28:	01000d0e 	tsteq	r0, lr, lsl #26
     e2c:	00010101 	andeq	r0, r1, r1, lsl #2
     e30:	00010000 	andeq	r0, r1, r0
     e34:	2e2e0100 	sufcse	f0, f6, f0
     e38:	2f2e2e2f 	svccs	0x002e2e2f
     e3c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     e40:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     e44:	2f2e2e2f 	svccs	0x002e2e2f
     e48:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
     e4c:	2e006363 	cdpcs	3, 0, cr6, cr0, cr3, {3}
     e50:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     e54:	2f2e2e2f 	svccs	0x002e2e2f
     e58:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     e5c:	2f2e2f2e 	svccs	0x002e2f2e
     e60:	00636367 	rsbeq	r6, r3, r7, ror #6
     e64:	62696c00 	rsbvs	r6, r9, #0, 24
     e68:	32636367 	rsbcc	r6, r3, #-1677721599	; 0x9c000001
     e6c:	0100632e 	tsteq	r0, lr, lsr #6
     e70:	72610000 	rsbvc	r0, r1, #0
     e74:	73692d6d 	cmnvc	r9, #6976	; 0x1b40
     e78:	00682e61 	rsbeq	r2, r8, r1, ror #28
     e7c:	6c000002 	stcvs	0, cr0, [r0], {2}
     e80:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
     e84:	682e3263 	stmdavs	lr!, {r0, r1, r5, r6, r9, ip, sp}
     e88:	00000100 	andeq	r0, r0, r0, lsl #2
     e8c:	00010500 	andeq	r0, r1, r0, lsl #10
     e90:	98900205 	ldmls	r0, {r0, r2, r9}
     e94:	b9030000 	stmdblt	r3, {}	; <UNPREDICTABLE>
     e98:	0305010b 	movweq	r0, #20747	; 0x510b
     e9c:	06100517 			; <UNDEFINED> instruction: 0x06100517
     ea0:	33190501 	tstcc	r9, #4194304	; 0x400000
     ea4:	05332705 	ldreq	r2, [r3, #-1797]!	; 0xfffff8fb
     ea8:	2e760310 	mrccs	3, 3, r0, cr6, cr0, {0}
     eac:	33060305 	movwcc	r0, #25349	; 0x6305
     eb0:	01061905 	tsteq	r6, r5, lsl #18
     eb4:	052e1005 	streq	r1, [lr, #-5]!
     eb8:	15330603 	ldrne	r0, [r3, #-1539]!	; 0xfffff9fd
     ebc:	0f061b05 	svceq	0x00061b05
     ec0:	2b030105 	blcs	c12dc <__bss_end+0xb785c>
     ec4:	0319052e 	tsteq	r9, #192937984	; 0xb800000
     ec8:	01052e55 	tsteq	r5, r5, asr lr
     ecc:	4a2e2b03 	bmi	b8bae0 <__bss_end+0xb82060>
     ed0:	01000a02 	tsteq	r0, r2, lsl #20
     ed4:	00016901 	andeq	r6, r1, r1, lsl #18
     ed8:	68000300 	stmdavs	r0, {r8, r9}
     edc:	02000000 	andeq	r0, r0, #0
     ee0:	0d0efb01 	vstreq	d15, [lr, #-4]
     ee4:	01010100 	mrseq	r0, (UNDEF: 17)
     ee8:	00000001 	andeq	r0, r0, r1
     eec:	01000001 	tsteq	r0, r1
     ef0:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     ef4:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     ef8:	2f2e2e2f 	svccs	0x002e2e2f
     efc:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     f00:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
     f04:	63636762 	cmnvs	r3, #25690112	; 0x1880000
     f08:	2f2e2e00 	svccs	0x002e2e00
     f0c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     f10:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     f14:	2f2e2e2f 	svccs	0x002e2e2f
     f18:	63672f2e 	cmnvs	r7, #46, 30	; 0xb8
     f1c:	6c000063 	stcvs	0, cr0, [r0], {99}	; 0x63
     f20:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
     f24:	632e3263 			; <UNDEFINED> instruction: 0x632e3263
     f28:	00000100 	andeq	r0, r0, r0, lsl #2
     f2c:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
     f30:	2e617369 	cdpcs	3, 6, cr7, cr1, cr9, {3}
     f34:	00020068 	andeq	r0, r2, r8, rrx
     f38:	62696c00 	rsbvs	r6, r9, #0, 24
     f3c:	32636367 	rsbcc	r6, r3, #-1677721599	; 0x9c000001
     f40:	0100682e 	tsteq	r0, lr, lsr #16
     f44:	05000000 	streq	r0, [r0, #-0]
     f48:	02050001 	andeq	r0, r5, #1
     f4c:	000098d0 	ldrdeq	r9, [r0], -r0
     f50:	0107b303 	tsteq	r7, r3, lsl #6
     f54:	13130305 	tstne	r3, #335544320	; 0x14000000
     f58:	05010a03 	streq	r0, [r1, #-2563]	; 0xfffff5fd
     f5c:	05010606 	streq	r0, [r1, #-1542]	; 0xfffff9fa
     f60:	4a740301 	bmi	1d01b6c <__bss_end+0x1cf80ec>
     f64:	052f0b05 	streq	r0, [pc, #-2821]!	; 467 <shift+0x467>
     f68:	0b052d01 	bleq	14c374 <__bss_end+0x1428f4>
     f6c:	0306052f 	movweq	r0, #25903	; 0x652f
     f70:	07052e0b 	streq	r2, [r5, -fp, lsl #28]
     f74:	0d053006 	stceq	0, cr3, [r5, #-24]	; 0xffffffe8
     f78:	07050106 	streq	r0, [r5, -r6, lsl #2]
     f7c:	0d058306 	stceq	3, cr8, [r5, #-24]	; 0xffffffe8
     f80:	054a0106 	strbeq	r0, [sl, #-262]	; 0xfffffefa
     f84:	054c0607 	strbeq	r0, [ip, #-1543]	; 0xfffff9f9
     f88:	05010609 	streq	r0, [r1, #-1545]	; 0xfffff9f7
     f8c:	052f0607 	streq	r0, [pc, #-1543]!	; 98d <shift+0x98d>
     f90:	2e010609 	cfmadd32cs	mvax0, mvfx0, mvfx1, mvfx9
     f94:	a5060705 	strge	r0, [r6, #-1797]	; 0xfffff8fb
     f98:	01060a05 	tsteq	r6, r5, lsl #20
     f9c:	030b052e 	movweq	r0, #46382	; 0xb52e
     fa0:	0a052e68 	beq	14c948 <__bss_end+0x142ec8>
     fa4:	054a1803 	strbeq	r1, [sl, #-2051]	; 0xfffff7fd
     fa8:	05300604 	ldreq	r0, [r0, #-1540]!	; 0xfffff9fc
     fac:	49130606 	ldmdbmi	r3, {r1, r2, r9, sl}
     fb0:	0405492f 	streq	r4, [r5], #-2351	; 0xfffff6d1
     fb4:	07052f06 	streq	r2, [r5, -r6, lsl #30]
     fb8:	060a0515 			; <UNDEFINED> instruction: 0x060a0515
     fbc:	06040501 	streq	r0, [r4], -r1, lsl #10
     fc0:	0606054c 	streq	r0, [r6], -ip, asr #10
     fc4:	04052e01 	streq	r2, [r5], #-3585	; 0xfffff1ff
     fc8:	06054e06 	streq	r4, [r5], -r6, lsl #28
     fcc:	0b050e06 	bleq	1447ec <__bss_end+0x13ad6c>
     fd0:	4a100552 	bmi	402520 <__bss_end+0x3f8aa0>
     fd4:	2e4a0505 	cdpcs	5, 4, cr0, cr10, cr5, {0}
     fd8:	31060805 	tstcc	r6, r5, lsl #16
     fdc:	05130e05 	ldreq	r0, [r3, #-3589]	; 0xfffff1fb
     fe0:	2e010606 	cfmadd32cs	mvax0, mvfx0, mvfx1, mvfx6
     fe4:	03060405 	movweq	r0, #25605	; 0x6405
     fe8:	08052e79 	stmdaeq	r5, {r0, r3, r4, r5, r6, r9, sl, fp, sp}
     fec:	13030514 	movwne	r0, #13588	; 0x3514
     ff0:	060b0514 			; <UNDEFINED> instruction: 0x060b0514
     ff4:	6905050f 	stmdbvs	r5, {r0, r1, r2, r3, r8, sl}
     ff8:	0608052e 	streq	r0, [r8], -lr, lsr #10
     ffc:	130e052f 	movwne	r0, #58671	; 0xe52f
    1000:	01060605 	tsteq	r6, r5, lsl #12
    1004:	0604052e 	streq	r0, [r4], -lr, lsr #10
    1008:	06060532 			; <UNDEFINED> instruction: 0x06060532
    100c:	05492f01 	strbeq	r2, [r9, #-3841]	; 0xfffff0ff
    1010:	052f0604 	streq	r0, [pc, #-1540]!	; a14 <shift+0xa14>
    1014:	05010606 	streq	r0, [r1, #-1542]	; 0xfffff9fa
    1018:	054b0604 	strbeq	r0, [fp, #-1540]	; 0xfffff9fc
    101c:	4a01060f 	bmi	42860 <__bss_end+0x38de0>
    1020:	2e4a0605 	cdpcs	6, 4, cr0, cr10, cr5, {0}
    1024:	32060305 	andcc	r0, r6, #335544320	; 0x14000000
    1028:	01060605 	tsteq	r6, r5, lsl #12
    102c:	2f060505 	svccs	0x00060505
    1030:	01060905 	tsteq	r6, r5, lsl #18
    1034:	2f060305 	svccs	0x00060305
    1038:	13060105 	movwne	r0, #24837	; 0x6105
    103c:	0004022e 	andeq	r0, r4, lr, lsr #4
    1040:	Address 0x0000000000001040 is out of bounds.


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
      34:	fb0c0000 	blx	30003e <__bss_end+0x2f65be>
      38:	2a000000 	bcs	40 <shift+0x40>
      3c:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
      40:	9c000080 	stcls	0, cr0, [r0], {128}	; 0x80
      44:	5a000000 	bpl	4c <shift+0x4c>
      48:	02000000 	andeq	r0, r0, #0
      4c:	0000012c 	andeq	r0, r0, ip, lsr #2
      50:	31150601 	tstcc	r5, r1, lsl #12
      54:	03000000 	movweq	r0, #0
      58:	14c60704 	strbne	r0, [r6], #1796	; 0x704
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
     128:	000014c6 	andeq	r1, r0, r6, asr #9
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
     174:	cb104801 	blgt	412180 <__bss_end+0x408700>
     178:	d4000000 	strle	r0, [r0], #-0
     17c:	58000081 	stmdapl	r0, {r0, r7}
     180:	01000000 	mrseq	r0, (UNDEF: 0)
     184:	0000cb9c 	muleq	r0, ip, fp
     188:	01800a00 	orreq	r0, r0, r0, lsl #20
     18c:	4a010000 	bmi	40194 <__bss_end+0x36714>
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
     1d4:	5b0c0000 	blpl	3001dc <__bss_end+0x2f675c>
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
     24c:	8b120f01 	blhi	483e58 <__bss_end+0x47a3d8>
     250:	0f000001 	svceq	0x00000001
     254:	0000019e 	muleq	r0, lr, r1
     258:	03231000 			; <UNDEFINED> instruction: 0x03231000
     25c:	0a010000 	beq	40264 <__bss_end+0x367e4>
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
     2b4:	8b140074 	blhi	50048c <__bss_end+0x4f6a0c>
     2b8:	a4000001 	strge	r0, [r0], #-1
     2bc:	38000080 	stmdacc	r0, {r7}
     2c0:	01000000 	mrseq	r0, (UNDEF: 0)
     2c4:	0067139c 	mlseq	r7, ip, r3, r1
     2c8:	9e2f0a01 	vmulls.f32	s0, s30, s2
     2cc:	02000001 	andeq	r0, r0, #1
     2d0:	00007491 	muleq	r0, r1, r4
     2d4:	00000176 	andeq	r0, r0, r6, ror r1
     2d8:	01e00004 	mvneq	r0, r4
     2dc:	01040000 	mrseq	r0, (UNDEF: 4)
     2e0:	0000025e 	andeq	r0, r0, lr, asr r2
     2e4:	00035c04 	andeq	r5, r3, r4, lsl #24
     2e8:	00002a00 	andeq	r2, r0, r0, lsl #20
     2ec:	00822c00 	addeq	r2, r2, r0, lsl #24
     2f0:	00004800 	andeq	r4, r0, r0, lsl #16
     2f4:	0001c200 	andeq	ip, r1, r0, lsl #4
     2f8:	08010200 	stmdaeq	r1, {r9}
     2fc:	000003e8 	andeq	r0, r0, r8, ror #7
     300:	3e050202 	cdpcc	2, 0, cr0, cr5, cr2, {0}
     304:	03000004 	movweq	r0, #4
     308:	6e690504 	cdpvs	5, 6, cr0, cr9, cr4, {0}
     30c:	01020074 	tsteq	r2, r4, ror r0
     310:	0003df08 	andeq	sp, r3, r8, lsl #30
     314:	07020200 	streq	r0, [r2, -r0, lsl #4]
     318:	00000337 	andeq	r0, r0, r7, lsr r3
     31c:	0003f704 	andeq	pc, r3, r4, lsl #14
     320:	07090600 	streq	r0, [r9, -r0, lsl #12]
     324:	00000059 	andeq	r0, r0, r9, asr r0
     328:	00004805 	andeq	r4, r0, r5, lsl #16
     32c:	07040200 	streq	r0, [r4, -r0, lsl #4]
     330:	000014c6 	andeq	r1, r0, r6, asr #9
     334:	00039706 	andeq	r9, r3, r6, lsl #14
     338:	14050200 	strne	r0, [r5], #-512	; 0xfffffe00
     33c:	00000054 	andeq	r0, r0, r4, asr r0
     340:	99f00305 	ldmibls	r0!, {r0, r2, r8, r9}^
     344:	00060000 	andeq	r0, r6, r0
     348:	02000004 	andeq	r0, r0, #4
     34c:	00541406 	subseq	r1, r4, r6, lsl #8
     350:	03050000 	movweq	r0, #20480	; 0x5000
     354:	000099f4 	strdeq	r9, [r0], -r4
     358:	00044806 	andeq	r4, r4, r6, lsl #16
     35c:	1a070300 	bne	1c0f64 <__bss_end+0x1b74e4>
     360:	00000054 	andeq	r0, r0, r4, asr r0
     364:	99f80305 	ldmibls	r8!, {r0, r2, r8, r9}^
     368:	4a060000 	bmi	180370 <__bss_end+0x1768f0>
     36c:	03000003 	movweq	r0, #3
     370:	00541a09 	subseq	r1, r4, r9, lsl #20
     374:	03050000 	movweq	r0, #20480	; 0x5000
     378:	000099fc 	strdeq	r9, [r0], -ip
     37c:	00043006 	andeq	r3, r4, r6
     380:	1a0b0300 	bne	2c0f88 <__bss_end+0x2b7508>
     384:	00000054 	andeq	r0, r0, r4, asr r0
     388:	9a000305 	bls	fa4 <shift+0xfa4>
     38c:	cc060000 	stcgt	0, cr0, [r6], {-0}
     390:	03000003 	movweq	r0, #3
     394:	00541a0d 	subseq	r1, r4, sp, lsl #20
     398:	03050000 	movweq	r0, #20480	; 0x5000
     39c:	00009a04 	andeq	r9, r0, r4, lsl #20
     3a0:	0003ed06 	andeq	lr, r3, r6, lsl #26
     3a4:	1a0f0300 	bne	3c0fac <__bss_end+0x3b752c>
     3a8:	00000054 	andeq	r0, r0, r4, asr r0
     3ac:	9a080305 	bls	200fc8 <__bss_end+0x1f7548>
     3b0:	01020000 	mrseq	r0, (UNDEF: 2)
     3b4:	0003b402 	andeq	fp, r3, r2, lsl #8
     3b8:	04170600 	ldreq	r0, [r7], #-1536	; 0xfffffa00
     3bc:	04040000 	streq	r0, [r4], #-0
     3c0:	00005414 	andeq	r5, r0, r4, lsl r4
     3c4:	0c030500 	cfstr32eq	mvfx0, [r3], {-0}
     3c8:	0600009a 			; <UNDEFINED> instruction: 0x0600009a
     3cc:	0000040c 	andeq	r0, r0, ip, lsl #8
     3d0:	54140704 	ldrpl	r0, [r4], #-1796	; 0xfffff8fc
     3d4:	05000000 	streq	r0, [r0, #-0]
     3d8:	009a1003 	addseq	r1, sl, r3
     3dc:	03b90600 			; <UNDEFINED> instruction: 0x03b90600
     3e0:	0a040000 	beq	1003e8 <__bss_end+0xf6968>
     3e4:	00005414 	andeq	r5, r0, r4, lsl r4
     3e8:	14030500 	strne	r0, [r3], #-1280	; 0xfffffb00
     3ec:	0200009a 	andeq	r0, r0, #154	; 0x9a
     3f0:	14c10704 	strbne	r0, [r1], #1796	; 0x704
     3f4:	a5060000 	strge	r0, [r6, #-0]
     3f8:	05000003 	streq	r0, [r0, #-3]
     3fc:	0054140a 	subseq	r1, r4, sl, lsl #8
     400:	03050000 	movweq	r0, #20480	; 0x5000
     404:	00009a18 	andeq	r9, r0, r8, lsl sl
     408:	00145a07 	andseq	r5, r4, r7, lsl #20
     40c:	05050100 	streq	r0, [r5, #-256]	; 0xffffff00
     410:	00000033 	andeq	r0, r0, r3, lsr r0
     414:	0000822c 	andeq	r8, r0, ip, lsr #4
     418:	00000048 	andeq	r0, r0, r8, asr #32
     41c:	016d9c01 	cmneq	sp, r1, lsl #24
     420:	92080000 	andls	r0, r8, #0
     424:	01000003 	tsteq	r0, r3
     428:	00330e05 	eorseq	r0, r3, r5, lsl #28
     42c:	91020000 	mrsls	r0, (UNDEF: 2)
     430:	045e0874 	ldrbeq	r0, [lr], #-2164	; 0xfffff78c
     434:	05010000 	streq	r0, [r1, #-0]
     438:	00016d1b 	andeq	r6, r1, fp, lsl sp
     43c:	70910200 	addsvc	r0, r1, r0, lsl #4
     440:	73040900 	movwvc	r0, #18688	; 0x4900
     444:	09000001 	stmdbeq	r0, {r0}
     448:	00002504 	andeq	r2, r0, r4, lsl #10
     44c:	0b910000 	bleq	fe440454 <__bss_end+0xfe4369d4>
     450:	00040000 	andeq	r0, r4, r0
     454:	00000269 	andeq	r0, r0, r9, ror #4
     458:	090f0104 	stmdbeq	pc, {r2, r8}	; <UNPREDICTABLE>
     45c:	d3040000 	movwle	r0, #16384	; 0x4000
     460:	b900000b 	stmdblt	r0, {r0, r1, r3}
     464:	7400000a 	strvc	r0, [r0], #-10
     468:	5c000082 	stcpl	0, cr0, [r0], {130}	; 0x82
     46c:	41000004 	tstmi	r0, r4
     470:	02000003 	andeq	r0, r0, #3
     474:	03e80801 	mvneq	r0, #65536	; 0x10000
     478:	25030000 	strcs	r0, [r3, #-0]
     47c:	02000000 	andeq	r0, r0, #0
     480:	043e0502 	ldrteq	r0, [lr], #-1282	; 0xfffffafe
     484:	04040000 	streq	r0, [r4], #-0
     488:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
     48c:	08010200 	stmdaeq	r1, {r9}
     490:	000003df 	ldrdeq	r0, [r0], -pc	; <UNPREDICTABLE>
     494:	37070202 	strcc	r0, [r7, -r2, lsl #4]
     498:	05000003 	streq	r0, [r0, #-3]
     49c:	000003f7 	strdeq	r0, [r0], -r7
     4a0:	5e070907 	vmlapl.f16	s0, s14, s14	; <UNPREDICTABLE>
     4a4:	03000000 	movweq	r0, #0
     4a8:	0000004d 	andeq	r0, r0, sp, asr #32
     4ac:	c6070402 	strgt	r0, [r7], -r2, lsl #8
     4b0:	06000014 			; <UNDEFINED> instruction: 0x06000014
     4b4:	00000674 	andeq	r0, r0, r4, ror r6
     4b8:	08060208 	stmdaeq	r6, {r3, r9}
     4bc:	0000008b 	andeq	r0, r0, fp, lsl #1
     4c0:	00307207 	eorseq	r7, r0, r7, lsl #4
     4c4:	4d0e0802 	stcmi	8, cr0, [lr, #-8]
     4c8:	00000000 	andeq	r0, r0, r0
     4cc:	00317207 	eorseq	r7, r1, r7, lsl #4
     4d0:	4d0e0902 	vstrmi.16	s0, [lr, #-4]	; <UNPREDICTABLE>
     4d4:	04000000 	streq	r0, [r0], #-0
     4d8:	0c030800 	stceq	8, cr0, [r3], {-0}
     4dc:	04050000 	streq	r0, [r5], #-0
     4e0:	00000038 	andeq	r0, r0, r8, lsr r0
     4e4:	a90c0d02 	stmdbge	ip, {r1, r8, sl, fp}
     4e8:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
     4ec:	00004b4f 	andeq	r4, r0, pc, asr #22
     4f0:	00068d0a 	andeq	r8, r6, sl, lsl #26
     4f4:	08000100 	stmdaeq	r0, {r8}
     4f8:	00000555 	andeq	r0, r0, r5, asr r5
     4fc:	00380405 	eorseq	r0, r8, r5, lsl #8
     500:	1e020000 	cdpne	0, 0, cr0, cr2, cr0, {0}
     504:	0000ec0c 	andeq	lr, r0, ip, lsl #24
     508:	06df0a00 	ldrbeq	r0, [pc], r0, lsl #20
     50c:	0a000000 	beq	514 <shift+0x514>
     510:	00000ec5 	andeq	r0, r0, r5, asr #29
     514:	0ea50a01 	vfmaeq.f32	s0, s10, s2
     518:	0a020000 	beq	80520 <__bss_end+0x76aa0>
     51c:	0000089a 	muleq	r0, sl, r8
     520:	0ad80a03 	beq	ff602d34 <__bss_end+0xff5f92b4>
     524:	0a040000 	beq	10052c <__bss_end+0xf6aac>
     528:	0000069f 	muleq	r0, pc, r6	; <UNPREDICTABLE>
     52c:	04d90a05 	ldrbeq	r0, [r9], #2565	; 0xa05
     530:	0a060000 	beq	180538 <__bss_end+0x176ab8>
     534:	00000e5c 	andeq	r0, r0, ip, asr lr
     538:	1a080007 	bne	20055c <__bss_end+0x1f6adc>
     53c:	0500000e 	streq	r0, [r0, #-14]
     540:	00003804 	andeq	r3, r0, r4, lsl #16
     544:	0c490200 	sfmeq	f0, 2, [r9], {-0}
     548:	00000129 	andeq	r0, r0, r9, lsr #2
     54c:	00046e0a 	andeq	r6, r4, sl, lsl #28
     550:	6a0a0000 	bvs	280558 <__bss_end+0x276ad8>
     554:	01000005 	tsteq	r0, r5
     558:	000aac0a 	andeq	sl, sl, sl, lsl #24
     55c:	660a0200 	strvs	r0, [sl], -r0, lsl #4
     560:	0300000e 	movweq	r0, #14
     564:	000ecf0a 	andeq	ip, lr, sl, lsl #30
     568:	4c0a0400 	cfstrsmi	mvf0, [sl], {-0}
     56c:	0500000a 	streq	r0, [r0, #-10]
     570:	0008610a 	andeq	r6, r8, sl, lsl #2
     574:	08000600 	stmdaeq	r0, {r9, sl}
     578:	00000dd4 	ldrdeq	r0, [r0], -r4
     57c:	00380405 	eorseq	r0, r8, r5, lsl #8
     580:	70020000 	andvc	r0, r2, r0
     584:	0001540c 	andeq	r5, r1, ip, lsl #8
     588:	0b4d0a00 	bleq	1342d90 <__bss_end+0x1339310>
     58c:	0a000000 	beq	594 <shift+0x594>
     590:	0000080e 	andeq	r0, r0, lr, lsl #16
     594:	0b9c0a01 	bleq	fe702da0 <__bss_end+0xfe6f9320>
     598:	0a020000 	beq	805a0 <__bss_end+0x76b20>
     59c:	00000866 	andeq	r0, r0, r6, ror #16
     5a0:	970b0003 	strls	r0, [fp, -r3]
     5a4:	03000003 	movweq	r0, #3
     5a8:	00591405 	subseq	r1, r9, r5, lsl #8
     5ac:	03050000 	movweq	r0, #20480	; 0x5000
     5b0:	00009a1c 	andeq	r9, r0, ip, lsl sl
     5b4:	0004000b 	andeq	r0, r4, fp
     5b8:	14060300 	strne	r0, [r6], #-768	; 0xfffffd00
     5bc:	00000059 	andeq	r0, r0, r9, asr r0
     5c0:	9a200305 	bls	8011dc <__bss_end+0x7f775c>
     5c4:	480b0000 	stmdami	fp, {}	; <UNPREDICTABLE>
     5c8:	04000004 	streq	r0, [r0], #-4
     5cc:	00591a07 	subseq	r1, r9, r7, lsl #20
     5d0:	03050000 	movweq	r0, #20480	; 0x5000
     5d4:	00009a24 	andeq	r9, r0, r4, lsr #20
     5d8:	00034a0b 	andeq	r4, r3, fp, lsl #20
     5dc:	1a090400 	bne	2415e4 <__bss_end+0x237b64>
     5e0:	00000059 	andeq	r0, r0, r9, asr r0
     5e4:	9a280305 	bls	a01200 <__bss_end+0x9f7780>
     5e8:	300b0000 	andcc	r0, fp, r0
     5ec:	04000004 	streq	r0, [r0], #-4
     5f0:	00591a0b 	subseq	r1, r9, fp, lsl #20
     5f4:	03050000 	movweq	r0, #20480	; 0x5000
     5f8:	00009a2c 	andeq	r9, r0, ip, lsr #20
     5fc:	0003cc0b 	andeq	ip, r3, fp, lsl #24
     600:	1a0d0400 	bne	341608 <__bss_end+0x337b88>
     604:	00000059 	andeq	r0, r0, r9, asr r0
     608:	9a300305 	bls	c01224 <__bss_end+0xbf77a4>
     60c:	ed0b0000 	stc	0, cr0, [fp, #-0]
     610:	04000003 	streq	r0, [r0], #-3
     614:	00591a0f 	subseq	r1, r9, pc, lsl #20
     618:	03050000 	movweq	r0, #20480	; 0x5000
     61c:	00009a34 	andeq	r9, r0, r4, lsr sl
     620:	000e8a08 	andeq	r8, lr, r8, lsl #20
     624:	38040500 	stmdacc	r4, {r8, sl}
     628:	04000000 	streq	r0, [r0], #-0
     62c:	01f70c1b 	mvnseq	r0, fp, lsl ip
     630:	8d0a0000 	stchi	0, cr0, [sl, #-0]
     634:	0000000c 	andeq	r0, r0, ip
     638:	000e9a0a 	andeq	r9, lr, sl, lsl #20
     63c:	a70a0100 	strge	r0, [sl, -r0, lsl #2]
     640:	0200000a 	andeq	r0, r0, #10
     644:	0b470c00 	bleq	11c364c <__bss_end+0x11b9bcc>
     648:	01020000 	mrseq	r0, (UNDEF: 2)
     64c:	0003b402 	andeq	fp, r3, r2, lsl #8
     650:	2c040d00 	stccs	13, cr0, [r4], {-0}
     654:	0d000000 	stceq	0, cr0, [r0, #-0]
     658:	0001f704 	andeq	pc, r1, r4, lsl #14
     65c:	04170b00 	ldreq	r0, [r7], #-2816	; 0xfffff500
     660:	04050000 	streq	r0, [r5], #-0
     664:	00005914 	andeq	r5, r0, r4, lsl r9
     668:	38030500 	stmdacc	r3, {r8, sl}
     66c:	0b00009a 	bleq	8dc <shift+0x8dc>
     670:	0000040c 	andeq	r0, r0, ip, lsl #8
     674:	59140705 	ldmdbpl	r4, {r0, r2, r8, r9, sl}
     678:	05000000 	streq	r0, [r0, #-0]
     67c:	009a3c03 	addseq	r3, sl, r3, lsl #24
     680:	03b90b00 			; <UNDEFINED> instruction: 0x03b90b00
     684:	0a050000 	beq	14068c <__bss_end+0x136c0c>
     688:	00005914 	andeq	r5, r0, r4, lsl r9
     68c:	40030500 	andmi	r0, r3, r0, lsl #10
     690:	0800009a 	stmdaeq	r0, {r1, r3, r4, r7}
     694:	000008f5 	strdeq	r0, [r0], -r5
     698:	00380405 	eorseq	r0, r8, r5, lsl #8
     69c:	0d050000 	stceq	0, cr0, [r5, #-0]
     6a0:	00027c0c 	andeq	r7, r2, ip, lsl #24
     6a4:	654e0900 	strbvs	r0, [lr, #-2304]	; 0xfffff700
     6a8:	0a000077 	beq	88c <shift+0x88c>
     6ac:	000008ec 	andeq	r0, r0, ip, ror #17
     6b0:	0c140a01 			; <UNDEFINED> instruction: 0x0c140a01
     6b4:	0a020000 	beq	806bc <__bss_end+0x76c3c>
     6b8:	000008be 			; <UNDEFINED> instruction: 0x000008be
     6bc:	088c0a03 	stmeq	ip, {r0, r1, r9, fp}
     6c0:	0a040000 	beq	1006c8 <__bss_end+0xf6c48>
     6c4:	00000ab2 			; <UNDEFINED> instruction: 0x00000ab2
     6c8:	92060005 	andls	r0, r6, #5
     6cc:	10000006 	andne	r0, r0, r6
     6d0:	bb081b05 	bllt	2072ec <__bss_end+0x1fd86c>
     6d4:	07000002 	streq	r0, [r0, -r2]
     6d8:	0500726c 	streq	r7, [r0, #-620]	; 0xfffffd94
     6dc:	02bb131d 	adcseq	r1, fp, #1946157056	; 0x74000000
     6e0:	07000000 	streq	r0, [r0, -r0]
     6e4:	05007073 	streq	r7, [r0, #-115]	; 0xffffff8d
     6e8:	02bb131e 	adcseq	r1, fp, #2013265920	; 0x78000000
     6ec:	07040000 	streq	r0, [r4, -r0]
     6f0:	05006370 	streq	r6, [r0, #-880]	; 0xfffffc90
     6f4:	02bb131f 	adcseq	r1, fp, #2080374784	; 0x7c000000
     6f8:	0e080000 	cdpeq	0, 0, cr0, cr8, cr0, {0}
     6fc:	000006b1 			; <UNDEFINED> instruction: 0x000006b1
     700:	bb132005 	bllt	4c871c <__bss_end+0x4bec9c>
     704:	0c000002 	stceq	0, cr0, [r0], {2}
     708:	07040200 	streq	r0, [r4, -r0, lsl #4]
     70c:	000014c1 	andeq	r1, r0, r1, asr #9
     710:	00074e06 	andeq	r4, r7, r6, lsl #28
     714:	28057c00 	stmdacs	r5, {sl, fp, ip, sp, lr}
     718:	00037908 	andeq	r7, r3, r8, lsl #18
     71c:	0c810e00 	stceq	14, cr0, [r1], {0}
     720:	2a050000 	bcs	140728 <__bss_end+0x136ca8>
     724:	00027c12 	andeq	r7, r2, r2, lsl ip
     728:	70070000 	andvc	r0, r7, r0
     72c:	05006469 	streq	r6, [r0, #-1129]	; 0xfffffb97
     730:	005e122b 	subseq	r1, lr, fp, lsr #4
     734:	0e100000 	cdpeq	0, 1, cr0, cr0, cr0, {0}
     738:	000005af 	andeq	r0, r0, pc, lsr #11
     73c:	45112c05 	ldrmi	r2, [r1, #-3077]	; 0xfffff3fb
     740:	14000002 	strne	r0, [r0], #-2
     744:	0009010e 	andeq	r0, r9, lr, lsl #2
     748:	122d0500 	eorne	r0, sp, #0, 10
     74c:	0000005e 	andeq	r0, r0, lr, asr r0
     750:	09ed0e18 	stmibeq	sp!, {r3, r4, r9, sl, fp}^
     754:	2e050000 	cdpcs	0, 0, cr0, cr5, cr0, {0}
     758:	00005e12 	andeq	r5, r0, r2, lsl lr
     75c:	800e1c00 	andhi	r1, lr, r0, lsl #24
     760:	05000006 	streq	r0, [r0, #-6]
     764:	03790c2f 	cmneq	r9, #12032	; 0x2f00
     768:	0e200000 	cdpeq	0, 2, cr0, cr0, cr0, {0}
     76c:	000009c6 	andeq	r0, r0, r6, asr #19
     770:	38093005 	stmdacc	r9, {r0, r2, ip, sp}
     774:	60000000 	andvs	r0, r0, r0
     778:	000c9e0e 	andeq	r9, ip, lr, lsl #28
     77c:	0e310500 	cfabs32eq	mvfx0, mvfx1
     780:	0000004d 	andeq	r0, r0, sp, asr #32
     784:	06f00e64 	ldrbteq	r0, [r0], r4, ror #28
     788:	33050000 	movwcc	r0, #20480	; 0x5000
     78c:	00004d0e 	andeq	r4, r0, lr, lsl #26
     790:	e70e6800 	str	r6, [lr, -r0, lsl #16]
     794:	05000006 	streq	r0, [r0, #-6]
     798:	004d0e34 	subeq	r0, sp, r4, lsr lr
     79c:	0e6c0000 	cdpeq	0, 6, cr0, cr12, cr0, {0}
     7a0:	0000082d 	andeq	r0, r0, sp, lsr #16
     7a4:	4d0e3505 	cfstr32mi	mvfx3, [lr, #-20]	; 0xffffffec
     7a8:	70000000 	andvc	r0, r0, r0
     7ac:	000a980e 	andeq	r9, sl, lr, lsl #16
     7b0:	0e360500 	cfabs32eq	mvfx0, mvfx6
     7b4:	0000004d 	andeq	r0, r0, sp, asr #32
     7b8:	0e6c0e74 	mcreq	14, 3, r0, cr12, cr4, {3}
     7bc:	37050000 	strcc	r0, [r5, -r0]
     7c0:	00004d0e 	andeq	r4, r0, lr, lsl #26
     7c4:	0f007800 	svceq	0x00007800
     7c8:	00000209 	andeq	r0, r0, r9, lsl #4
     7cc:	00000389 	andeq	r0, r0, r9, lsl #7
     7d0:	00005e10 	andeq	r5, r0, r0, lsl lr
     7d4:	0b000f00 	bleq	43dc <shift+0x43dc>
     7d8:	000003a5 	andeq	r0, r0, r5, lsr #7
     7dc:	59140a06 	ldmdbpl	r4, {r1, r2, r9, fp}
     7e0:	05000000 	streq	r0, [r0, #-0]
     7e4:	009a4403 	addseq	r4, sl, r3, lsl #8
     7e8:	08c60800 	stmiaeq	r6, {fp}^
     7ec:	04050000 	streq	r0, [r5], #-0
     7f0:	00000038 	andeq	r0, r0, r8, lsr r0
     7f4:	ba0c0d06 	blt	303c14 <__bss_end+0x2fa194>
     7f8:	0a000003 	beq	80c <shift+0x80c>
     7fc:	0000056f 	andeq	r0, r0, pc, ror #10
     800:	04630a00 	strbteq	r0, [r3], #-2560	; 0xfffff600
     804:	00010000 	andeq	r0, r1, r0
     808:	00039b03 	andeq	r9, r3, r3, lsl #22
     80c:	0a280800 	beq	a02814 <__bss_end+0x9f8d94>
     810:	04050000 	streq	r0, [r5], #-0
     814:	00000038 	andeq	r0, r0, r8, lsr r0
     818:	de0c1406 	cdple	4, 0, cr1, cr12, cr6, {0}
     81c:	0a000003 	beq	830 <shift+0x830>
     820:	000004ad 	andeq	r0, r0, sp, lsr #9
     824:	0b8e0a00 	bleq	fe38302c <__bss_end+0xfe3795ac>
     828:	00010000 	andeq	r0, r1, r0
     82c:	0003bf03 	andeq	fp, r3, r3, lsl #30
     830:	0d630600 	stcleq	6, cr0, [r3, #-0]
     834:	060c0000 	streq	r0, [ip], -r0
     838:	0418081b 	ldreq	r0, [r8], #-2075	; 0xfffff7e5
     83c:	a80e0000 	stmdage	lr, {}	; <UNPREDICTABLE>
     840:	06000004 	streq	r0, [r0], -r4
     844:	0418191d 	ldreq	r1, [r8], #-2333	; 0xfffff6e3
     848:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
     84c:	0000052c 	andeq	r0, r0, ip, lsr #10
     850:	18191e06 	ldmdane	r9, {r1, r2, r9, sl, fp, ip}
     854:	04000004 	streq	r0, [r0], #-4
     858:	000d120e 	andeq	r1, sp, lr, lsl #4
     85c:	131f0600 	tstne	pc, #0, 12
     860:	0000041e 	andeq	r0, r0, lr, lsl r4
     864:	040d0008 	streq	r0, [sp], #-8
     868:	000003e3 	andeq	r0, r0, r3, ror #7
     86c:	02c2040d 	sbceq	r0, r2, #218103808	; 0xd000000
     870:	d4110000 	ldrle	r0, [r1], #-0
     874:	14000005 	strne	r0, [r0], #-5
     878:	e5072206 	str	r2, [r7, #-518]	; 0xfffffdfa
     87c:	0e000006 	cdpeq	0, 0, cr0, cr0, cr6, {0}
     880:	000008b4 			; <UNDEFINED> instruction: 0x000008b4
     884:	4d122606 	ldcmi	6, cr2, [r2, #-24]	; 0xffffffe8
     888:	00000000 	andeq	r0, r0, r0
     88c:	0004e00e 	andeq	lr, r4, lr
     890:	1d290600 	stcne	6, cr0, [r9, #-0]
     894:	00000418 	andeq	r0, r0, r8, lsl r4
     898:	0c580e04 	mrrceq	14, 0, r0, r8, cr4
     89c:	2c060000 	stccs	0, cr0, [r6], {-0}
     8a0:	0004181d 	andeq	r1, r4, sp, lsl r8
     8a4:	10120800 	andsne	r0, r2, r0, lsl #16
     8a8:	0600000e 	streq	r0, [r0], -lr
     8ac:	0d400e2f 	stcleq	14, cr0, [r0, #-188]	; 0xffffff44
     8b0:	046c0000 	strbteq	r0, [ip], #-0
     8b4:	04770000 	ldrbteq	r0, [r7], #-0
     8b8:	ea130000 	b	4c08c0 <__bss_end+0x4b6e40>
     8bc:	14000006 	strne	r0, [r0], #-6
     8c0:	00000418 	andeq	r0, r0, r8, lsl r4
     8c4:	0d281500 	cfstr32eq	mvfx1, [r8, #-0]
     8c8:	31060000 	mrscc	r0, (UNDEF: 6)
     8cc:	0007250e 	andeq	r2, r7, lr, lsl #10
     8d0:	0001fc00 	andeq	pc, r1, r0, lsl #24
     8d4:	00048f00 	andeq	r8, r4, r0, lsl #30
     8d8:	00049a00 	andeq	r9, r4, r0, lsl #20
     8dc:	06ea1300 	strbteq	r1, [sl], r0, lsl #6
     8e0:	1e140000 	cdpne	0, 1, cr0, cr4, cr0, {0}
     8e4:	00000004 	andeq	r0, r0, r4
     8e8:	000d7616 	andeq	r7, sp, r6, lsl r6
     8ec:	1d350600 	ldcne	6, cr0, [r5, #-0]
     8f0:	00000ced 	andeq	r0, r0, sp, ror #25
     8f4:	00000418 	andeq	r0, r0, r8, lsl r4
     8f8:	0004b302 	andeq	fp, r4, r2, lsl #6
     8fc:	0004b900 	andeq	fp, r4, r0, lsl #18
     900:	06ea1300 	strbteq	r1, [sl], r0, lsl #6
     904:	16000000 	strne	r0, [r0], -r0
     908:	00000854 	andeq	r0, r0, r4, asr r8
     90c:	581d3706 	ldmdapl	sp, {r1, r2, r8, r9, sl, ip, sp}
     910:	1800000b 	stmdane	r0, {r0, r1, r3}
     914:	02000004 	andeq	r0, r0, #4
     918:	000004d2 	ldrdeq	r0, [r0], -r2
     91c:	000004d8 	ldrdeq	r0, [r0], -r8
     920:	0006ea13 	andeq	lr, r6, r3, lsl sl
     924:	09170000 	ldmdbeq	r7, {}	; <UNPREDICTABLE>
     928:	0600000a 	streq	r0, [r0], -sl
     92c:	07033139 	smladxeq	r3, r9, r1, r3
     930:	020c0000 	andeq	r0, ip, #0
     934:	0005d416 	andeq	sp, r5, r6, lsl r4
     938:	093c0600 	ldmdbeq	ip!, {r9, sl}
     93c:	00000eab 	andeq	r0, r0, fp, lsr #29
     940:	000006ea 	andeq	r0, r0, sl, ror #13
     944:	0004ff01 	andeq	pc, r4, r1, lsl #30
     948:	00050500 	andeq	r0, r5, r0, lsl #10
     94c:	06ea1300 	strbteq	r1, [sl], r0, lsl #6
     950:	16000000 	strne	r0, [r0], -r0
     954:	00000d23 	andeq	r0, r0, r3, lsr #26
     958:	d0123d06 	andsle	r3, r2, r6, lsl #26
     95c:	4d000009 	stcmi	0, cr0, [r0, #-36]	; 0xffffffdc
     960:	01000000 	mrseq	r0, (UNDEF: 0)
     964:	0000051e 	andeq	r0, r0, lr, lsl r5
     968:	00000529 	andeq	r0, r0, r9, lsr #10
     96c:	0006ea13 	andeq	lr, r6, r3, lsl sl
     970:	004d1400 	subeq	r1, sp, r0, lsl #8
     974:	16000000 	strne	r0, [r0], -r0
     978:	00000584 	andeq	r0, r0, r4, lsl #11
     97c:	e5123f06 	ldr	r3, [r2, #-3846]	; 0xfffff0fa
     980:	4d00000d 	stcmi	0, cr0, [r0, #-52]	; 0xffffffcc
     984:	01000000 	mrseq	r0, (UNDEF: 0)
     988:	00000542 	andeq	r0, r0, r2, asr #10
     98c:	00000557 	andeq	r0, r0, r7, asr r5
     990:	0006ea13 	andeq	lr, r6, r3, lsl sl
     994:	070c1400 	streq	r1, [ip, -r0, lsl #8]
     998:	5e140000 	cdppl	0, 1, cr0, cr4, cr0, {0}
     99c:	14000000 	strne	r0, [r0], #-0
     9a0:	000001fc 	strdeq	r0, [r0], -ip
     9a4:	0a671800 	beq	19c69ac <__bss_end+0x19bcf2c>
     9a8:	41060000 	mrsmi	r0, (UNDEF: 6)
     9ac:	00077b0e 	andeq	r7, r7, lr, lsl #22
     9b0:	056c0100 	strbeq	r0, [ip, #-256]!	; 0xffffff00
     9b4:	05720000 	ldrbeq	r0, [r2, #-0]!
     9b8:	ea130000 	b	4c09c0 <__bss_end+0x4b6f40>
     9bc:	00000006 	andeq	r0, r0, r6
     9c0:	000d3718 	andeq	r3, sp, r8, lsl r7
     9c4:	0e430600 	cdpeq	6, 4, cr0, cr3, cr0, {0}
     9c8:	00000af9 	strdeq	r0, [r0], -r9
     9cc:	00058701 	andeq	r8, r5, r1, lsl #14
     9d0:	00058d00 	andeq	r8, r5, r0, lsl #26
     9d4:	06ea1300 	strbteq	r1, [sl], r0, lsl #6
     9d8:	16000000 	strne	r0, [r0], -r0
     9dc:	000007bf 			; <UNDEFINED> instruction: 0x000007bf
     9e0:	f8174606 			; <UNDEFINED> instruction: 0xf8174606
     9e4:	1e000004 	cdpne	0, 0, cr0, cr0, cr4, {0}
     9e8:	01000004 	tsteq	r0, r4
     9ec:	000005a6 	andeq	r0, r0, r6, lsr #11
     9f0:	000005ac 	andeq	r0, r0, ip, lsr #11
     9f4:	00071213 	andeq	r1, r7, r3, lsl r2
     9f8:	31160000 	tstcc	r6, r0
     9fc:	06000005 	streq	r0, [r0], -r5
     a00:	0caa1749 	stceq	7, cr1, [sl], #292	; 0x124
     a04:	041e0000 	ldreq	r0, [lr], #-0
     a08:	c5010000 	strgt	r0, [r1, #-0]
     a0c:	d0000005 	andle	r0, r0, r5
     a10:	13000005 	movwne	r0, #5
     a14:	00000712 	andeq	r0, r0, r2, lsl r7
     a18:	00004d14 	andeq	r4, r0, r4, lsl sp
     a1c:	f8180000 			; <UNDEFINED> instruction: 0xf8180000
     a20:	06000007 	streq	r0, [r0], -r7
     a24:	04730e4c 	ldrbteq	r0, [r3], #-3660	; 0xfffff1b4
     a28:	e5010000 	str	r0, [r1, #-0]
     a2c:	eb000005 	bl	a48 <shift+0xa48>
     a30:	13000005 	movwne	r0, #5
     a34:	000006ea 	andeq	r0, r0, sl, ror #13
     a38:	0d281600 	stceq	6, cr1, [r8, #-0]
     a3c:	4e060000 	cdpmi	0, 0, cr0, cr6, cr0, {0}
     a40:	0006b70e 	andeq	fp, r6, lr, lsl #14
     a44:	0001fc00 	andeq	pc, r1, r0, lsl #24
     a48:	06040100 	streq	r0, [r4], -r0, lsl #2
     a4c:	060f0000 	streq	r0, [pc], -r0
     a50:	ea130000 	b	4c0a58 <__bss_end+0x4b6fd8>
     a54:	14000006 	strne	r0, [r0], #-6
     a58:	0000004d 	andeq	r0, r0, sp, asr #32
     a5c:	07e41600 	strbeq	r1, [r4, r0, lsl #12]!
     a60:	51060000 	mrspl	r0, (UNDEF: 6)
     a64:	000b1a12 	andeq	r1, fp, r2, lsl sl
     a68:	00004d00 	andeq	r4, r0, r0, lsl #26
     a6c:	06280100 	strteq	r0, [r8], -r0, lsl #2
     a70:	06330000 	ldrteq	r0, [r3], -r0
     a74:	ea130000 	b	4c0a7c <__bss_end+0x4b6ffc>
     a78:	14000006 	strne	r0, [r0], #-6
     a7c:	00000209 	andeq	r0, r0, r9, lsl #4
     a80:	04ba1600 	ldrteq	r1, [sl], #1536	; 0x600
     a84:	54060000 	strpl	r0, [r6], #-0
     a88:	0006f90e 	andeq	pc, r6, lr, lsl #18
     a8c:	0001fc00 	andeq	pc, r1, r0, lsl #24
     a90:	064c0100 	strbeq	r0, [ip], -r0, lsl #2
     a94:	06570000 	ldrbeq	r0, [r7], -r0
     a98:	ea130000 	b	4c0aa0 <__bss_end+0x4b7020>
     a9c:	14000006 	strne	r0, [r0], #-6
     aa0:	0000004d 	andeq	r0, r0, sp, asr #32
     aa4:	083b1800 	ldmdaeq	fp!, {fp, ip}
     aa8:	57060000 	strpl	r0, [r6, -r0]
     aac:	000d820e 	andeq	r8, sp, lr, lsl #4
     ab0:	066c0100 	strbteq	r0, [ip], -r0, lsl #2
     ab4:	068b0000 	streq	r0, [fp], r0
     ab8:	ea130000 	b	4c0ac0 <__bss_end+0x4b7040>
     abc:	14000006 	strne	r0, [r0], #-6
     ac0:	000000a9 	andeq	r0, r0, r9, lsr #1
     ac4:	00004d14 	andeq	r4, r0, r4, lsl sp
     ac8:	004d1400 	subeq	r1, sp, r0, lsl #8
     acc:	4d140000 	ldcmi	0, cr0, [r4, #-0]
     ad0:	14000000 	strne	r0, [r0], #-0
     ad4:	00000718 	andeq	r0, r0, r8, lsl r7
     ad8:	0cd71800 	ldcleq	8, cr1, [r7], {0}
     adc:	59060000 	stmdbpl	r6, {}	; <UNPREDICTABLE>
     ae0:	0006280e 	andeq	r2, r6, lr, lsl #16
     ae4:	06a00100 	strteq	r0, [r0], r0, lsl #2
     ae8:	06bf0000 	ldrteq	r0, [pc], r0
     aec:	ea130000 	b	4c0af4 <__bss_end+0x4b7074>
     af0:	14000006 	strne	r0, [r0], #-6
     af4:	000000ec 	andeq	r0, r0, ip, ror #1
     af8:	00004d14 	andeq	r4, r0, r4, lsl sp
     afc:	004d1400 	subeq	r1, sp, r0, lsl #8
     b00:	4d140000 	ldcmi	0, cr0, [r4, #-0]
     b04:	14000000 	strne	r0, [r0], #-0
     b08:	00000718 	andeq	r0, r0, r8, lsl r7
     b0c:	05c11900 	strbeq	r1, [r1, #2304]	; 0x900
     b10:	5c060000 	stcpl	0, cr0, [r6], {-0}
     b14:	0005e50e 	andeq	lr, r5, lr, lsl #10
     b18:	0001fc00 	andeq	pc, r1, r0, lsl #24
     b1c:	06d40100 	ldrbeq	r0, [r4], r0, lsl #2
     b20:	ea130000 	b	4c0b28 <__bss_end+0x4b70a8>
     b24:	14000006 	strne	r0, [r0], #-6
     b28:	0000039b 	muleq	r0, fp, r3
     b2c:	00071e14 	andeq	r1, r7, r4, lsl lr
     b30:	03000000 	movweq	r0, #0
     b34:	00000424 	andeq	r0, r0, r4, lsr #8
     b38:	0424040d 	strteq	r0, [r4], #-1037	; 0xfffffbf3
     b3c:	181a0000 	ldmdane	sl, {}	; <UNPREDICTABLE>
     b40:	fd000004 	stc2	0, cr0, [r0, #-16]
     b44:	03000006 	movweq	r0, #6
     b48:	13000007 	movwne	r0, #7
     b4c:	000006ea 	andeq	r0, r0, sl, ror #13
     b50:	04241b00 	strteq	r1, [r4], #-2816	; 0xfffff500
     b54:	06f00000 	ldrbteq	r0, [r0], r0
     b58:	040d0000 	streq	r0, [sp], #-0
     b5c:	0000003f 	andeq	r0, r0, pc, lsr r0
     b60:	06e5040d 	strbteq	r0, [r5], sp, lsl #8
     b64:	041c0000 	ldreq	r0, [ip], #-0
     b68:	00000065 	andeq	r0, r0, r5, rrx
     b6c:	2c0f041d 	cfstrscs	mvf0, [pc], {29}
     b70:	30000000 	andcc	r0, r0, r0
     b74:	10000007 	andne	r0, r0, r7
     b78:	0000005e 	andeq	r0, r0, lr, asr r0
     b7c:	20030009 	andcs	r0, r3, r9
     b80:	1e000007 	cdpne	0, 0, cr0, cr0, cr7, {0}
     b84:	000007d3 	ldrdeq	r0, [r0], -r3
     b88:	300ca501 	andcc	sl, ip, r1, lsl #10
     b8c:	05000007 	streq	r0, [r0, #-7]
     b90:	009a4803 	addseq	r4, sl, r3, lsl #16
     b94:	04f31f00 	ldrbteq	r1, [r3], #3840	; 0xf00
     b98:	a7010000 	strge	r0, [r1, -r0]
     b9c:	000a1c0a 	andeq	r1, sl, sl, lsl #24
     ba0:	00004d00 	andeq	r4, r0, r0, lsl #26
     ba4:	00862000 	addeq	r2, r6, r0
     ba8:	0000b000 	andeq	fp, r0, r0
     bac:	a59c0100 	ldrge	r0, [ip, #256]	; 0x100
     bb0:	20000007 	andcs	r0, r0, r7
     bb4:	00000e57 	andeq	r0, r0, r7, asr lr
     bb8:	031ba701 	tsteq	fp, #262144	; 0x40000
     bbc:	03000002 	movweq	r0, #2
     bc0:	207fac91 			; <UNDEFINED> instruction: 0x207fac91
     bc4:	00000a8f 	andeq	r0, r0, pc, lsl #21
     bc8:	4d2aa701 	stcmi	7, cr10, [sl, #-4]!
     bcc:	03000000 	movweq	r0, #0
     bd0:	1e7fa891 	mrcne	8, 3, sl, cr15, cr1, {4}
     bd4:	000008e6 	andeq	r0, r0, r6, ror #17
     bd8:	a50aa901 	strge	sl, [sl, #-2305]	; 0xfffff6ff
     bdc:	03000007 	movweq	r0, #7
     be0:	1e7fb491 	mrcne	4, 3, fp, cr15, cr1, {4}
     be4:	000004d4 	ldrdeq	r0, [r0], -r4
     be8:	3809ad01 	stmdacc	r9, {r0, r8, sl, fp, sp, pc}
     bec:	02000000 	andeq	r0, r0, #0
     bf0:	0f007491 	svceq	0x00007491
     bf4:	00000025 	andeq	r0, r0, r5, lsr #32
     bf8:	000007b5 			; <UNDEFINED> instruction: 0x000007b5
     bfc:	00005e10 	andeq	r5, r0, r0, lsl lr
     c00:	21003f00 	tstcs	r0, r0, lsl #30
     c04:	00000a74 	andeq	r0, r0, r4, ror sl
     c08:	b30a9901 	movwlt	r9, #43265	; 0xa901
     c0c:	4d00000b 	stcmi	0, cr0, [r0, #-44]	; 0xffffffd4
     c10:	e4000000 	str	r0, [r0], #-0
     c14:	3c000085 	stccc	0, cr0, [r0], {133}	; 0x85
     c18:	01000000 	mrseq	r0, (UNDEF: 0)
     c1c:	0007f29c 	muleq	r7, ip, r2
     c20:	65722200 	ldrbvs	r2, [r2, #-512]!	; 0xfffffe00
     c24:	9b010071 	blls	40df0 <__bss_end+0x37370>
     c28:	0003de20 	andeq	sp, r3, r0, lsr #28
     c2c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     c30:	000a031e 	andeq	r0, sl, lr, lsl r3
     c34:	0e9c0100 	fmleqe	f0, f4, f0
     c38:	0000004d 	andeq	r0, r0, sp, asr #32
     c3c:	00709102 	rsbseq	r9, r0, r2, lsl #2
     c40:	000ae723 	andeq	lr, sl, r3, lsr #14
     c44:	06900100 	ldreq	r0, [r0], r0, lsl #2
     c48:	00000593 	muleq	r0, r3, r5
     c4c:	000085a8 	andeq	r8, r0, r8, lsr #11
     c50:	0000003c 	andeq	r0, r0, ip, lsr r0
     c54:	082b9c01 	stmdaeq	fp!, {r0, sl, fp, ip, pc}
     c58:	67200000 	strvs	r0, [r0, -r0]!
     c5c:	01000007 	tsteq	r0, r7
     c60:	004d2190 	umaaleq	r2, sp, r0, r1
     c64:	91020000 	mrsls	r0, (UNDEF: 2)
     c68:	6572226c 	ldrbvs	r2, [r2, #-620]!	; 0xfffffd94
     c6c:	92010071 	andls	r0, r1, #113	; 0x71
     c70:	0003de20 	andeq	sp, r3, r0, lsr #28
     c74:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     c78:	0a3d2100 	beq	f49080 <__bss_end+0xf3f600>
     c7c:	84010000 	strhi	r0, [r1], #-0
     c80:	0008190a 	andeq	r1, r8, sl, lsl #18
     c84:	00004d00 	andeq	r4, r0, r0, lsl #26
     c88:	00856c00 	addeq	r6, r5, r0, lsl #24
     c8c:	00003c00 	andeq	r3, r0, r0, lsl #24
     c90:	689c0100 	ldmvs	ip, {r8}
     c94:	22000008 	andcs	r0, r0, #8
     c98:	00716572 	rsbseq	r6, r1, r2, ror r5
     c9c:	ba208601 	blt	8224a8 <__bss_end+0x818a28>
     ca0:	02000003 	andeq	r0, r0, #3
     ca4:	cd1e7491 	cfldrsgt	mvf7, [lr, #-580]	; 0xfffffdbc
     ca8:	01000004 	tsteq	r0, r4
     cac:	004d0e87 	subeq	r0, sp, r7, lsl #29
     cb0:	91020000 	mrsls	r0, (UNDEF: 2)
     cb4:	3a210070 	bcc	840e7c <__bss_end+0x8373fc>
     cb8:	0100000e 	tsteq	r0, lr
     cbc:	07a10a78 			; <UNDEFINED> instruction: 0x07a10a78
     cc0:	004d0000 	subeq	r0, sp, r0
     cc4:	85300000 	ldrhi	r0, [r0, #-0]!
     cc8:	003c0000 	eorseq	r0, ip, r0
     ccc:	9c010000 	stcls	0, cr0, [r1], {-0}
     cd0:	000008a5 	andeq	r0, r0, r5, lsr #17
     cd4:	71657222 	cmnvc	r5, r2, lsr #4
     cd8:	207a0100 	rsbscs	r0, sl, r0, lsl #2
     cdc:	000003ba 			; <UNDEFINED> instruction: 0x000003ba
     ce0:	1e749102 	expnes	f1, f2
     ce4:	000004cd 	andeq	r0, r0, sp, asr #9
     ce8:	4d0e7b01 	vstrmi	d7, [lr, #-4]
     cec:	02000000 	andeq	r0, r0, #0
     cf0:	21007091 	swpcs	r7, r1, [r0]
     cf4:	0000084e 	andeq	r0, r0, lr, asr #16
     cf8:	7e066c01 	cdpvc	12, 0, cr6, cr6, cr1, {0}
     cfc:	fc00000b 	stc2	0, cr0, [r0], {11}
     d00:	dc000001 	stcle	0, cr0, [r0], {1}
     d04:	54000084 	strpl	r0, [r0], #-132	; 0xffffff7c
     d08:	01000000 	mrseq	r0, (UNDEF: 0)
     d0c:	0008f19c 	muleq	r8, ip, r1
     d10:	0a032000 	beq	c8d18 <__bss_end+0xbf298>
     d14:	6c010000 	stcvs	0, cr0, [r1], {-0}
     d18:	00004d15 	andeq	r4, r0, r5, lsl sp
     d1c:	6c910200 	lfmvs	f0, 4, [r1], {0}
     d20:	0006e720 	andeq	lr, r6, r0, lsr #14
     d24:	256c0100 	strbcs	r0, [ip, #-256]!	; 0xffffff00
     d28:	0000004d 	andeq	r0, r0, sp, asr #32
     d2c:	1e689102 	lgnnee	f1, f2
     d30:	00000e32 	andeq	r0, r0, r2, lsr lr
     d34:	4d0e6e01 	stcmi	14, cr6, [lr, #-4]
     d38:	02000000 	andeq	r0, r0, #0
     d3c:	21007491 			; <UNDEFINED> instruction: 0x21007491
     d40:	000005aa 	andeq	r0, r0, sl, lsr #11
     d44:	22125f01 	andscs	r5, r2, #1, 30
     d48:	8b00000c 	blhi	d80 <shift+0xd80>
     d4c:	8c000000 	stchi	0, cr0, [r0], {-0}
     d50:	50000084 	andpl	r0, r0, r4, lsl #1
     d54:	01000000 	mrseq	r0, (UNDEF: 0)
     d58:	00094c9c 	muleq	r9, ip, ip
     d5c:	0b892000 	bleq	fe248d64 <__bss_end+0xfe23f2e4>
     d60:	5f010000 	svcpl	0x00010000
     d64:	00004d20 	andeq	r4, r0, r0, lsr #26
     d68:	6c910200 	lfmvs	f0, 4, [r1], {0}
     d6c:	000a4620 	andeq	r4, sl, r0, lsr #12
     d70:	2f5f0100 	svccs	0x005f0100
     d74:	0000004d 	andeq	r0, r0, sp, asr #32
     d78:	20689102 	rsbcs	r9, r8, r2, lsl #2
     d7c:	000006e7 	andeq	r0, r0, r7, ror #13
     d80:	4d3f5f01 	ldcmi	15, cr5, [pc, #-4]!	; d84 <shift+0xd84>
     d84:	02000000 	andeq	r0, r0, #0
     d88:	321e6491 	andscc	r6, lr, #-1862270976	; 0x91000000
     d8c:	0100000e 	tsteq	r0, lr
     d90:	008b1661 	addeq	r1, fp, r1, ror #12
     d94:	91020000 	mrsls	r0, (UNDEF: 2)
     d98:	6b210074 	blvs	840f70 <__bss_end+0x8374f0>
     d9c:	0100000c 	tsteq	r0, ip
     da0:	05b50a53 	ldreq	r0, [r5, #2643]!	; 0xa53
     da4:	004d0000 	subeq	r0, sp, r0
     da8:	84480000 	strbhi	r0, [r8], #-0
     dac:	00440000 	subeq	r0, r4, r0
     db0:	9c010000 	stcls	0, cr0, [r1], {-0}
     db4:	00000998 	muleq	r0, r8, r9
     db8:	000b8920 	andeq	r8, fp, r0, lsr #18
     dbc:	1a530100 	bne	14c11c4 <__bss_end+0x14b7744>
     dc0:	0000004d 	andeq	r0, r0, sp, asr #32
     dc4:	206c9102 	rsbcs	r9, ip, r2, lsl #2
     dc8:	00000a46 	andeq	r0, r0, r6, asr #20
     dcc:	4d295301 	stcmi	3, cr5, [r9, #-4]!
     dd0:	02000000 	andeq	r0, r0, #0
     dd4:	511e6891 			; <UNDEFINED> instruction: 0x511e6891
     dd8:	0100000c 	tsteq	r0, ip
     ddc:	004d0e55 	subeq	r0, sp, r5, asr lr
     de0:	91020000 	mrsls	r0, (UNDEF: 2)
     de4:	4b210074 	blmi	840fbc <__bss_end+0x83753c>
     de8:	0100000c 	tsteq	r0, ip
     dec:	0c2d0a46 			; <UNDEFINED> instruction: 0x0c2d0a46
     df0:	004d0000 	subeq	r0, sp, r0
     df4:	83f80000 	mvnshi	r0, #0
     df8:	00500000 	subseq	r0, r0, r0
     dfc:	9c010000 	stcls	0, cr0, [r1], {-0}
     e00:	000009f3 	strdeq	r0, [r0], -r3
     e04:	000b8920 	andeq	r8, fp, r0, lsr #18
     e08:	19460100 	stmdbne	r6, {r8}^
     e0c:	0000004d 	andeq	r0, r0, sp, asr #32
     e10:	206c9102 	rsbcs	r9, ip, r2, lsl #2
     e14:	000008a0 	andeq	r0, r0, r0, lsr #17
     e18:	29304601 	ldmdbcs	r0!, {r0, r9, sl, lr}
     e1c:	02000001 	andeq	r0, r0, #1
     e20:	53206891 			; <UNDEFINED> instruction: 0x53206891
     e24:	0100000a 	tsteq	r0, sl
     e28:	071e4146 	ldreq	r4, [lr, -r6, asr #2]
     e2c:	91020000 	mrsls	r0, (UNDEF: 2)
     e30:	0e321e64 	cdpeq	14, 3, cr1, cr2, cr4, {3}
     e34:	48010000 	stmdami	r1, {}	; <UNPREDICTABLE>
     e38:	00004d0e 	andeq	r4, r0, lr, lsl #26
     e3c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     e40:	04a22300 	strteq	r2, [r2], #768	; 0x300
     e44:	40010000 	andmi	r0, r1, r0
     e48:	0008aa06 	andeq	sl, r8, r6, lsl #20
     e4c:	0083cc00 	addeq	ip, r3, r0, lsl #24
     e50:	00002c00 	andeq	r2, r0, r0, lsl #24
     e54:	1d9c0100 	ldfnes	f0, [ip]
     e58:	2000000a 	andcs	r0, r0, sl
     e5c:	00000b89 	andeq	r0, r0, r9, lsl #23
     e60:	4d154001 	ldcmi	0, cr4, [r5, #-4]
     e64:	02000000 	andeq	r0, r0, #0
     e68:	21007491 			; <UNDEFINED> instruction: 0x21007491
     e6c:	000009c0 	andeq	r0, r0, r0, asr #19
     e70:	590a3301 	stmdbpl	sl, {r0, r8, r9, ip, sp}
     e74:	4d00000a 	stcmi	0, cr0, [r0, #-40]	; 0xffffffd8
     e78:	7c000000 	stcvc	0, cr0, [r0], {-0}
     e7c:	50000083 	andpl	r0, r0, r3, lsl #1
     e80:	01000000 	mrseq	r0, (UNDEF: 0)
     e84:	000a789c 	muleq	sl, ip, r8
     e88:	0b892000 	bleq	fe248e90 <__bss_end+0xfe23f410>
     e8c:	33010000 	movwcc	r0, #4096	; 0x1000
     e90:	00004d19 	andeq	r4, r0, r9, lsl sp
     e94:	6c910200 	lfmvs	f0, 4, [r1], {0}
     e98:	000c9720 	andeq	r9, ip, r0, lsr #14
     e9c:	2b330100 	blcs	cc12a4 <__bss_end+0xcb7824>
     ea0:	00000203 	andeq	r0, r0, r3, lsl #4
     ea4:	20689102 	rsbcs	r9, r8, r2, lsl #2
     ea8:	00000a93 	muleq	r0, r3, sl
     eac:	4d3c3301 	ldcmi	3, cr3, [ip, #-4]!
     eb0:	02000000 	andeq	r0, r0, #0
     eb4:	1c1e6491 	cfldrsne	mvf6, [lr], {145}	; 0x91
     eb8:	0100000c 	tsteq	r0, ip
     ebc:	004d0e35 	subeq	r0, sp, r5, lsr lr
     ec0:	91020000 	mrsls	r0, (UNDEF: 2)
     ec4:	61210074 			; <UNDEFINED> instruction: 0x61210074
     ec8:	0100000e 	tsteq	r0, lr
     ecc:	0d170a25 	vldreq	s0, [r7, #-148]	; 0xffffff6c
     ed0:	004d0000 	subeq	r0, sp, r0
     ed4:	832c0000 			; <UNDEFINED> instruction: 0x832c0000
     ed8:	00500000 	subseq	r0, r0, r0
     edc:	9c010000 	stcls	0, cr0, [r1], {-0}
     ee0:	00000ad3 	ldrdeq	r0, [r0], -r3
     ee4:	000b8920 	andeq	r8, fp, r0, lsr #18
     ee8:	18250100 	stmdane	r5!, {r8}
     eec:	0000004d 	andeq	r0, r0, sp, asr #32
     ef0:	206c9102 	rsbcs	r9, ip, r2, lsl #2
     ef4:	00000c97 	muleq	r0, r7, ip
     ef8:	d92a2501 	stmdble	sl!, {r0, r8, sl, sp}
     efc:	0200000a 	andeq	r0, r0, #10
     f00:	93206891 			; <UNDEFINED> instruction: 0x93206891
     f04:	0100000a 	tsteq	r0, sl
     f08:	004d3b25 	subeq	r3, sp, r5, lsr #22
     f0c:	91020000 	mrsls	r0, (UNDEF: 2)
     f10:	05261e64 	streq	r1, [r6, #-3684]!	; 0xfffff19c
     f14:	27010000 	strcs	r0, [r1, -r0]
     f18:	00004d0e 	andeq	r4, r0, lr, lsl #26
     f1c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     f20:	25040d00 	strcs	r0, [r4, #-3328]	; 0xfffff300
     f24:	03000000 	movweq	r0, #0
     f28:	00000ad3 	ldrdeq	r0, [r0], -r3
     f2c:	000a1721 	andeq	r1, sl, r1, lsr #14
     f30:	0a190100 	beq	641338 <__bss_end+0x6378b8>
     f34:	00000e7e 	andeq	r0, r0, lr, ror lr
     f38:	0000004d 	andeq	r0, r0, sp, asr #32
     f3c:	000082e8 	andeq	r8, r0, r8, ror #5
     f40:	00000044 	andeq	r0, r0, r4, asr #32
     f44:	0b2a9c01 	bleq	aa7f50 <__bss_end+0xa9e4d0>
     f48:	53200000 	noppl	{0}	; <UNPREDICTABLE>
     f4c:	0100000e 	tsteq	r0, lr
     f50:	02031b19 	andeq	r1, r3, #25600	; 0x6400
     f54:	91020000 	mrsls	r0, (UNDEF: 2)
     f58:	0c7c206c 	ldcleq	0, cr2, [ip], #-432	; 0xfffffe50
     f5c:	19010000 	stmdbne	r1, {}	; <UNPREDICTABLE>
     f60:	0001d235 	andeq	sp, r1, r5, lsr r2
     f64:	68910200 	ldmvs	r1, {r9}
     f68:	000b891e 	andeq	r8, fp, lr, lsl r9
     f6c:	0e1b0100 	mufeqe	f0, f3, f0
     f70:	0000004d 	andeq	r0, r0, sp, asr #32
     f74:	00749102 	rsbseq	r9, r4, r2, lsl #2
     f78:	00075b24 	andeq	r5, r7, r4, lsr #22
     f7c:	06140100 	ldreq	r0, [r4], -r0, lsl #2
     f80:	00000544 	andeq	r0, r0, r4, asr #10
     f84:	000082cc 	andeq	r8, r0, ip, asr #5
     f88:	0000001c 	andeq	r0, r0, ip, lsl r0
     f8c:	72239c01 	eorvc	r9, r3, #256	; 0x100
     f90:	0100000c 	tsteq	r0, ip
     f94:	087e060e 	ldmdaeq	lr!, {r1, r2, r3, r9, sl}^
     f98:	82a00000 	adchi	r0, r0, #0
     f9c:	002c0000 	eoreq	r0, ip, r0
     fa0:	9c010000 	stcls	0, cr0, [r1], {-0}
     fa4:	00000b6a 	andeq	r0, r0, sl, ror #22
     fa8:	0006a820 	andeq	sl, r6, r0, lsr #16
     fac:	140e0100 	strne	r0, [lr], #-256	; 0xffffff00
     fb0:	00000038 	andeq	r0, r0, r8, lsr r0
     fb4:	00749102 	rsbseq	r9, r4, r2, lsl #2
     fb8:	000e7725 	andeq	r7, lr, r5, lsr #14
     fbc:	0a040100 	beq	1013c4 <__bss_end+0xf7944>
     fc0:	000008db 	ldrdeq	r0, [r0], -fp
     fc4:	0000004d 	andeq	r0, r0, sp, asr #32
     fc8:	00008274 	andeq	r8, r0, r4, ror r2
     fcc:	0000002c 	andeq	r0, r0, ip, lsr #32
     fd0:	70229c01 	eorvc	r9, r2, r1, lsl #24
     fd4:	01006469 	tsteq	r0, r9, ror #8
     fd8:	004d0e06 	subeq	r0, sp, r6, lsl #28
     fdc:	91020000 	mrsls	r0, (UNDEF: 2)
     fe0:	2d000074 	stccs	0, cr0, [r0, #-464]	; 0xfffffe30
     fe4:	04000006 	streq	r0, [r0], #-6
     fe8:	0004d200 	andeq	sp, r4, r0, lsl #4
     fec:	0f010400 	svceq	0x00010400
     ff0:	04000009 	streq	r0, [r0], #-9
     ff4:	00000f74 	andeq	r0, r0, r4, ror pc
     ff8:	00000ab9 			; <UNDEFINED> instruction: 0x00000ab9
     ffc:	000086d0 	ldrdeq	r8, [r0], -r0
    1000:	00000c5c 	andeq	r0, r0, ip, asr ip
    1004:	0000055d 	andeq	r0, r0, sp, asr r5
    1008:	00004902 	andeq	r4, r0, r2, lsl #18
    100c:	0fd10300 	svceq	0x00d10300
    1010:	05010000 	streq	r0, [r1, #-0]
    1014:	00006110 	andeq	r6, r0, r0, lsl r1
    1018:	31301100 	teqcc	r0, r0, lsl #2
    101c:	35343332 	ldrcc	r3, [r4, #-818]!	; 0xfffffcce
    1020:	39383736 	ldmdbcc	r8!, {r1, r2, r4, r5, r8, r9, sl, ip, sp}
    1024:	44434241 	strbmi	r4, [r3], #-577	; 0xfffffdbf
    1028:	00004645 	andeq	r4, r0, r5, asr #12
    102c:	01030104 	tsteq	r3, r4, lsl #2
    1030:	00000025 	andeq	r0, r0, r5, lsr #32
    1034:	00007405 	andeq	r7, r0, r5, lsl #8
    1038:	00006100 	andeq	r6, r0, r0, lsl #2
    103c:	00660600 	rsbeq	r0, r6, r0, lsl #12
    1040:	00100000 	andseq	r0, r0, r0
    1044:	00005107 	andeq	r5, r0, r7, lsl #2
    1048:	07040800 	streq	r0, [r4, -r0, lsl #16]
    104c:	000014c6 	andeq	r1, r0, r6, asr #9
    1050:	e8080108 	stmda	r8, {r3, r8}
    1054:	07000003 	streq	r0, [r0, -r3]
    1058:	0000006d 	andeq	r0, r0, sp, rrx
    105c:	00002a09 	andeq	r2, r0, r9, lsl #20
    1060:	0fdd0a00 	svceq	0x00dd0a00
    1064:	d2010000 	andle	r0, r1, #0
    1068:	00107206 	andseq	r7, r0, r6, lsl #4
    106c:	00900400 	addseq	r0, r0, r0, lsl #8
    1070:	00032800 	andeq	r2, r3, r0, lsl #16
    1074:	1f9c0100 	svcne	0x009c0100
    1078:	0b000001 	bleq	1084 <shift+0x1084>
    107c:	d2010066 	andle	r0, r1, #102	; 0x66
    1080:	00011f11 	andeq	r1, r1, r1, lsl pc
    1084:	a4910300 	ldrge	r0, [r1], #768	; 0x300
    1088:	00720b7f 	rsbseq	r0, r2, pc, ror fp
    108c:	2619d201 	ldrcs	sp, [r9], -r1, lsl #4
    1090:	03000001 	movweq	r0, #1
    1094:	0c7fa091 	ldcleq	0, cr10, [pc], #-580	; e58 <shift+0xe58>
    1098:	00001084 	andeq	r1, r0, r4, lsl #1
    109c:	2c13d401 	cfldrscs	mvf13, [r3], {1}
    10a0:	02000001 	andeq	r0, r0, #1
    10a4:	2f0c5891 	svccs	0x000c5891
    10a8:	01000010 	tsteq	r0, r0, lsl r0
    10ac:	012c1bd4 	ldrdeq	r1, [ip, -r4]!
    10b0:	91020000 	mrsls	r0, (UNDEF: 2)
    10b4:	00690d50 	rsbeq	r0, r9, r0, asr sp
    10b8:	2c24d401 	cfstrscs	mvf13, [r4], #-4
    10bc:	02000001 	andeq	r0, r0, #1
    10c0:	e20c4891 	and	r4, ip, #9502720	; 0x910000
    10c4:	0100000f 	tsteq	r0, pc
    10c8:	012c27d4 	ldrdeq	r2, [ip, -r4]!
    10cc:	91020000 	mrsls	r0, (UNDEF: 2)
    10d0:	0fc10c40 	svceq	0x00c10c40
    10d4:	d4010000 	strle	r0, [r1], #-0
    10d8:	00012c2f 	andeq	r2, r1, pc, lsr #24
    10dc:	b8910300 	ldmlt	r1, {r8, r9}
    10e0:	0f450c7f 	svceq	0x00450c7f
    10e4:	d4010000 	strle	r0, [r1], #-0
    10e8:	00012c39 	andeq	r2, r1, r9, lsr ip
    10ec:	b0910300 	addslt	r0, r1, r0, lsl #6
    10f0:	0ff00c7f 	svceq	0x00f00c7f
    10f4:	d5010000 	strle	r0, [r1, #-0]
    10f8:	00011f0b 	andeq	r1, r1, fp, lsl #30
    10fc:	ac910300 	ldcge	3, cr0, [r1], {0}
    1100:	0408007f 	streq	r0, [r8], #-127	; 0xffffff81
    1104:	0011cd04 	andseq	ip, r1, r4, lsl #26
    1108:	6d040e00 	stcvs	14, cr0, [r4, #-0]
    110c:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    1110:	02430508 	subeq	r0, r3, #8, 10	; 0x2000000
    1114:	370f0000 	strcc	r0, [pc, -r0]
    1118:	01000010 	tsteq	r0, r0, lsl r0
    111c:	0f0c05c8 	svceq	0x000c05c8
    1120:	017f0000 	cmneq	pc, r0
    1124:	8f9c0000 	svchi	0x009c0000
    1128:	00680000 	rsbeq	r0, r8, r0
    112c:	9c010000 	stcls	0, cr0, [r1], {-0}
    1130:	0000017f 	andeq	r0, r0, pc, ror r1
    1134:	000fe210 	andeq	lr, pc, r0, lsl r2	; <UNPREDICTABLE>
    1138:	0ec80100 	poleqe	f0, f0, f0
    113c:	0000017f 	andeq	r0, r0, pc, ror r1
    1140:	106c9102 	rsbne	r9, ip, r2, lsl #2
    1144:	00000a46 	andeq	r0, r0, r6, asr #20
    1148:	7f1ac801 	svcvc	0x001ac801
    114c:	02000001 	andeq	r0, r0, #1
    1150:	250c6891 	strcs	r6, [ip, #-2193]	; 0xfffff76f
    1154:	01000001 	tsteq	r0, r1
    1158:	017f09ca 	cmneq	pc, sl, asr #19
    115c:	91020000 	mrsls	r0, (UNDEF: 2)
    1160:	04110074 	ldreq	r0, [r1], #-116	; 0xffffff8c
    1164:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
    1168:	100c1200 	andne	r1, ip, r0, lsl #4
    116c:	bd010000 	stclt	0, cr0, [r1, #-0]
    1170:	000ee606 	andeq	lr, lr, r6, lsl #12
    1174:	008f1c00 	addeq	r1, pc, r0, lsl #24
    1178:	00008000 	andeq	r8, r0, r0
    117c:	039c0100 	orrseq	r0, ip, #0, 2
    1180:	0b000002 	bleq	1190 <shift+0x1190>
    1184:	00637273 	rsbeq	r7, r3, r3, ror r2
    1188:	0319bd01 	tsteq	r9, #1, 26	; 0x40
    118c:	02000002 	andeq	r0, r0, #2
    1190:	640b6491 	strvs	r6, [fp], #-1169	; 0xfffffb6f
    1194:	01007473 	tsteq	r0, r3, ror r4
    1198:	020a24bd 	andeq	r2, sl, #-1124073472	; 0xbd000000
    119c:	91020000 	mrsls	r0, (UNDEF: 2)
    11a0:	756e0b60 	strbvc	r0, [lr, #-2912]!	; 0xfffff4a0
    11a4:	bd01006d 	stclt	0, cr0, [r1, #-436]	; 0xfffffe4c
    11a8:	00017f2d 	andeq	r7, r1, sp, lsr #30
    11ac:	5c910200 	lfmpl	f0, 4, [r1], {0}
    11b0:	000fe90c 	andeq	lr, pc, ip, lsl #18
    11b4:	0ebf0100 	frdeqe	f0, f7, f0
    11b8:	0000020c 	andeq	r0, r0, ip, lsl #4
    11bc:	0c709102 	ldfeqp	f1, [r0], #-8
    11c0:	00000fca 	andeq	r0, r0, sl, asr #31
    11c4:	2608c001 	strcs	ip, [r8], -r1
    11c8:	02000001 	andeq	r0, r0, #1
    11cc:	44136c91 	ldrmi	r6, [r3], #-3217	; 0xfffff36f
    11d0:	4800008f 	stmdami	r0, {r0, r1, r2, r3, r7}
    11d4:	0d000000 	stceq	0, cr0, [r0, #-0]
    11d8:	c2010069 	andgt	r0, r1, #105	; 0x69
    11dc:	00017f0b 	andeq	r7, r1, fp, lsl #30
    11e0:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    11e4:	040e0000 	streq	r0, [lr], #-0
    11e8:	00000209 	andeq	r0, r0, r9, lsl #4
    11ec:	0e041514 	mcreq	5, 0, r1, cr4, cr4, {0}
    11f0:	00007404 	andeq	r7, r0, r4, lsl #8
    11f4:	10061200 	andne	r1, r6, r0, lsl #4
    11f8:	b5010000 	strlt	r0, [r1, #-0]
    11fc:	000f5106 	andeq	r5, pc, r6, lsl #2
    1200:	008eb400 	addeq	fp, lr, r0, lsl #8
    1204:	00006800 	andeq	r6, r0, r0, lsl #16
    1208:	719c0100 	orrsvc	r0, ip, r0, lsl #2
    120c:	10000002 	andne	r0, r0, r2
    1210:	0000107d 	andeq	r1, r0, sp, ror r0
    1214:	0a12b501 	beq	4ae620 <__bss_end+0x4a4ba0>
    1218:	02000002 	andeq	r0, r0, #2
    121c:	84106c91 	ldrhi	r6, [r0], #-3217	; 0xfffff36f
    1220:	01000010 	tsteq	r0, r0, lsl r0
    1224:	017f1eb5 	ldrheq	r1, [pc, #-229]	; 1147 <shift+0x1147>
    1228:	91020000 	mrsls	r0, (UNDEF: 2)
    122c:	656d0d68 	strbvs	r0, [sp, #-3432]!	; 0xfffff298
    1230:	b701006d 	strlt	r0, [r1, -sp, rrx]
    1234:	00012608 	andeq	r2, r1, r8, lsl #12
    1238:	70910200 	addsvc	r0, r1, r0, lsl #4
    123c:	008ed013 	addeq	sp, lr, r3, lsl r0
    1240:	00003c00 	andeq	r3, r0, r0, lsl #24
    1244:	00690d00 	rsbeq	r0, r9, r0, lsl #26
    1248:	7f0bb901 	svcvc	0x000bb901
    124c:	02000001 	andeq	r0, r0, #1
    1250:	00007491 	muleq	r0, r1, r4
    1254:	000fa616 	andeq	sl, pc, r6, lsl r6	; <UNPREDICTABLE>
    1258:	07a40100 	streq	r0, [r4, r0, lsl #2]!
    125c:	00001092 	muleq	r0, r2, r0
    1260:	00000126 	andeq	r0, r0, r6, lsr #2
    1264:	00008ddc 	ldrdeq	r8, [r0], -ip
    1268:	000000d8 	ldrdeq	r0, [r0], -r8
    126c:	02f09c01 	rscseq	r9, r0, #256	; 0x100
    1270:	3a100000 	bcc	401278 <__bss_end+0x3f77f8>
    1274:	0100000f 	tsteq	r0, pc
    1278:	012615a4 			; <UNDEFINED> instruction: 0x012615a4
    127c:	91020000 	mrsls	r0, (UNDEF: 2)
    1280:	72730b64 	rsbsvc	r0, r3, #100, 22	; 0x19000
    1284:	a4010063 	strge	r0, [r1], #-99	; 0xffffff9d
    1288:	00020c27 	andeq	r0, r2, r7, lsr #24
    128c:	60910200 	addsvs	r0, r1, r0, lsl #4
    1290:	000a9310 	andeq	r9, sl, r0, lsl r3
    1294:	2fa40100 	svccs	0x00a40100
    1298:	0000017f 	andeq	r0, r0, pc, ror r1
    129c:	0c5c9102 	ldfeqp	f1, [ip], {2}
    12a0:	00000fae 	andeq	r0, r0, lr, lsr #31
    12a4:	7f09a501 	svcvc	0x0009a501
    12a8:	02000001 	andeq	r0, r0, #1
    12ac:	6d0d6c91 	stcvs	12, cr6, [sp, #-580]	; 0xfffffdbc
    12b0:	09a70100 	stmibeq	r7!, {r8}
    12b4:	0000017f 	andeq	r0, r0, pc, ror r1
    12b8:	13749102 	cmnne	r4, #-2147483648	; 0x80000000
    12bc:	00008e20 	andeq	r8, r0, r0, lsr #28
    12c0:	00000070 	andeq	r0, r0, r0, ror r0
    12c4:	0100690d 	tsteq	r0, sp, lsl #18
    12c8:	017f0dab 	cmneq	pc, fp, lsr #27
    12cc:	91020000 	mrsls	r0, (UNDEF: 2)
    12d0:	16000070 			; <UNDEFINED> instruction: 0x16000070
    12d4:	00000f4a 	andeq	r0, r0, sl, asr #30
    12d8:	65079a01 	strvs	r9, [r7, #-2561]	; 0xfffff5ff
    12dc:	2600000f 	strcs	r0, [r0], -pc
    12e0:	30000001 	andcc	r0, r0, r1
    12e4:	ac00008d 	stcge	0, cr0, [r0], {141}	; 0x8d
    12e8:	01000000 	mrseq	r0, (UNDEF: 0)
    12ec:	00036d9c 	muleq	r3, ip, sp
    12f0:	0f3a1000 	svceq	0x003a1000
    12f4:	9a010000 	bls	412fc <__bss_end+0x3787c>
    12f8:	00012614 	andeq	r2, r1, r4, lsl r6
    12fc:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    1300:	6372730b 	cmnvs	r2, #738197504	; 0x2c000000
    1304:	269a0100 	ldrcs	r0, [sl], r0, lsl #2
    1308:	0000020c 	andeq	r0, r0, ip, lsl #4
    130c:	0d609102 	stfeqp	f1, [r0, #-8]!
    1310:	9b01006e 	blls	414d0 <__bss_end+0x37a50>
    1314:	00017f09 	andeq	r7, r1, r9, lsl #30
    1318:	6c910200 	lfmvs	f0, 4, [r1], {0}
    131c:	01006d0d 	tsteq	r0, sp, lsl #26
    1320:	017f099c 			; <UNDEFINED> instruction: 0x017f099c
    1324:	91020000 	mrsls	r0, (UNDEF: 2)
    1328:	0fae0c74 	svceq	0x00ae0c74
    132c:	9d010000 	stcls	0, cr0, [r1, #-0]
    1330:	00017f09 	andeq	r7, r1, r9, lsl #30
    1334:	68910200 	ldmvs	r1, {r9}
    1338:	008d6413 	addeq	r6, sp, r3, lsl r4
    133c:	00005400 	andeq	r5, r0, r0, lsl #8
    1340:	00690d00 	rsbeq	r0, r9, r0, lsl #26
    1344:	7f0d9e01 	svcvc	0x000d9e01
    1348:	02000001 	andeq	r0, r0, #1
    134c:	00007091 	muleq	r0, r1, r0
    1350:	00108b0f 	andseq	r8, r0, pc, lsl #22
    1354:	058f0100 	streq	r0, [pc, #256]	; 145c <shift+0x145c>
    1358:	0000103c 	andeq	r1, r0, ip, lsr r0
    135c:	0000017f 	andeq	r0, r0, pc, ror r1
    1360:	00008cdc 	ldrdeq	r8, [r0], -ip
    1364:	00000054 	andeq	r0, r0, r4, asr r0
    1368:	03a69c01 			; <UNDEFINED> instruction: 0x03a69c01
    136c:	730b0000 	movwvc	r0, #45056	; 0xb000
    1370:	188f0100 	stmne	pc, {r8}	; <UNPREDICTABLE>
    1374:	0000020c 	andeq	r0, r0, ip, lsl #4
    1378:	0d6c9102 	stfeqp	f1, [ip, #-8]!
    137c:	91010069 	tstls	r1, r9, rrx
    1380:	00017f06 	andeq	r7, r1, r6, lsl #30
    1384:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1388:	10130f00 	andsne	r0, r3, r0, lsl #30
    138c:	7f010000 	svcvc	0x00010000
    1390:	00104905 	andseq	r4, r0, r5, lsl #18
    1394:	00017f00 	andeq	r7, r1, r0, lsl #30
    1398:	008c3000 	addeq	r3, ip, r0
    139c:	0000ac00 	andeq	sl, r0, r0, lsl #24
    13a0:	0c9c0100 	ldfeqs	f0, [ip], {0}
    13a4:	0b000004 	bleq	13bc <shift+0x13bc>
    13a8:	01003173 	tsteq	r0, r3, ror r1
    13ac:	020c197f 	andeq	r1, ip, #2080768	; 0x1fc000
    13b0:	91020000 	mrsls	r0, (UNDEF: 2)
    13b4:	32730b6c 	rsbscc	r0, r3, #108, 22	; 0x1b000
    13b8:	297f0100 	ldmdbcs	pc!, {r8}^	; <UNPREDICTABLE>
    13bc:	0000020c 	andeq	r0, r0, ip, lsl #4
    13c0:	0b689102 	bleq	1a257d0 <__bss_end+0x1a1bd50>
    13c4:	006d756e 	rsbeq	r7, sp, lr, ror #10
    13c8:	7f317f01 	svcvc	0x00317f01
    13cc:	02000001 	andeq	r0, r0, #1
    13d0:	750d6491 	strvc	r6, [sp, #-1169]	; 0xfffffb6f
    13d4:	81010031 	tsthi	r1, r1, lsr r0
    13d8:	00040c10 	andeq	r0, r4, r0, lsl ip
    13dc:	77910200 	ldrvc	r0, [r1, r0, lsl #4]
    13e0:	0032750d 	eorseq	r7, r2, sp, lsl #10
    13e4:	0c148101 	ldfeqd	f0, [r4], {1}
    13e8:	02000004 	andeq	r0, r0, #4
    13ec:	08007691 	stmdaeq	r0, {r0, r4, r7, r9, sl, ip, sp, lr}
    13f0:	03df0801 	bicseq	r0, pc, #65536	; 0x10000
    13f4:	5d0f0000 	stcpl	0, cr0, [pc, #-0]	; 13fc <shift+0x13fc>
    13f8:	0100000f 	tsteq	r0, pc
    13fc:	0ed50773 	mrceq	7, 6, r0, cr5, cr3, {3}
    1400:	01260000 			; <UNDEFINED> instruction: 0x01260000
    1404:	8b700000 	blhi	1c0140c <__bss_end+0x1bf798c>
    1408:	00c00000 	sbceq	r0, r0, r0
    140c:	9c010000 	stcls	0, cr0, [r1], {-0}
    1410:	0000046c 	andeq	r0, r0, ip, ror #8
    1414:	000f3a10 	andeq	r3, pc, r0, lsl sl	; <UNPREDICTABLE>
    1418:	15730100 	ldrbne	r0, [r3, #-256]!	; 0xffffff00
    141c:	00000126 	andeq	r0, r0, r6, lsr #2
    1420:	0b6c9102 	bleq	1b25830 <__bss_end+0x1b1bdb0>
    1424:	00637273 	rsbeq	r7, r3, r3, ror r2
    1428:	0c277301 	stceq	3, cr7, [r7], #-4
    142c:	02000002 	andeq	r0, r0, #2
    1430:	6e0b6891 	mcrvs	8, 0, r6, cr11, cr1, {4}
    1434:	01006d75 	tsteq	r0, r5, ror sp
    1438:	017f3073 	cmneq	pc, r3, ror r0	; <UNPREDICTABLE>
    143c:	91020000 	mrsls	r0, (UNDEF: 2)
    1440:	00690d64 	rsbeq	r0, r9, r4, ror #26
    1444:	7f067501 	svcvc	0x00067501
    1448:	02000001 	andeq	r0, r0, #1
    144c:	0f007491 	svceq	0x00007491
    1450:	00000f16 	andeq	r0, r0, r6, lsl pc
    1454:	2f075701 	svccs	0x00075701
    1458:	1f00000f 	svcne	0x0000000f
    145c:	14000001 	strne	r0, [r0], #-1
    1460:	5c00008a 	stcpl	0, cr0, [r0], {138}	; 0x8a
    1464:	01000001 	tsteq	r0, r1
    1468:	00050d9c 	muleq	r5, ip, sp
    146c:	0f3f1000 	svceq	0x003f1000
    1470:	57010000 	strpl	r0, [r1, -r0]
    1474:	00020c18 	andeq	r0, r2, r8, lsl ip
    1478:	44910200 	ldrmi	r0, [r1], #512	; 0x200
    147c:	0010280c 	andseq	r2, r0, ip, lsl #16
    1480:	0c580100 	ldfeqe	f0, [r8], {-0}
    1484:	0000050d 	andeq	r0, r0, sp, lsl #10
    1488:	0c709102 	ldfeqp	f1, [r0], #-8
    148c:	00000fb5 			; <UNDEFINED> instruction: 0x00000fb5
    1490:	0d0c5901 	vstreq.16	s10, [ip, #-2]	; <UNPREDICTABLE>
    1494:	02000005 	andeq	r0, r0, #5
    1498:	740d6091 	strvc	r6, [sp], #-145	; 0xffffff6f
    149c:	0100706d 	tsteq	r0, sp, rrx
    14a0:	050d0c5b 	streq	r0, [sp, #-3163]	; 0xfffff3a5
    14a4:	91020000 	mrsls	r0, (UNDEF: 2)
    14a8:	09070c58 	stmdbeq	r7, {r3, r4, r6, sl, fp}
    14ac:	5c010000 	stcpl	0, cr0, [r1], {-0}
    14b0:	00017f09 	andeq	r7, r1, r9, lsl #30
    14b4:	54910200 	ldrpl	r0, [r1], #512	; 0x200
    14b8:	0014b60c 	andseq	fp, r4, ip, lsl #12
    14bc:	095d0100 	ldmdbeq	sp, {r8}^
    14c0:	0000017f 	andeq	r0, r0, pc, ror r1
    14c4:	0c6c9102 	stfeqp	f1, [ip], #-8
    14c8:	00000ff8 	strdeq	r0, [r0], -r8
    14cc:	140a5e01 	strne	r5, [sl], #-3585	; 0xfffff1ff
    14d0:	02000005 	andeq	r0, r0, #5
    14d4:	70136b91 	mulsvc	r3, r1, fp
    14d8:	d000008a 	andle	r0, r0, sl, lsl #1
    14dc:	0d000000 	stceq	0, cr0, [r0, #-0]
    14e0:	006c6176 	rsbeq	r6, ip, r6, ror r1
    14e4:	0d106701 	ldceq	7, cr6, [r0, #-4]
    14e8:	02000005 	andeq	r0, r0, #5
    14ec:	00004891 	muleq	r0, r1, r8
    14f0:	76040808 	strvc	r0, [r4], -r8, lsl #16
    14f4:	08000014 	stmdaeq	r0, {r2, r4}
    14f8:	03b40201 			; <UNDEFINED> instruction: 0x03b40201
    14fc:	1b0f0000 	blne	3c1504 <__bss_end+0x3b7a84>
    1500:	0100000f 	tsteq	r0, pc
    1504:	0ef6053c 	mrceq	5, 7, r0, cr6, cr12, {1}
    1508:	017f0000 	cmneq	pc, r0
    150c:	89140000 	ldmdbhi	r4, {}	; <UNPREDICTABLE>
    1510:	01000000 	mrseq	r0, (UNDEF: 0)
    1514:	9c010000 	stcls	0, cr0, [r1], {-0}
    1518:	0000057e 	andeq	r0, r0, lr, ror r5
    151c:	000f3f10 	andeq	r3, pc, r0, lsl pc	; <UNPREDICTABLE>
    1520:	213c0100 	teqcs	ip, r0, lsl #2
    1524:	0000020c 	andeq	r0, r0, ip, lsl #4
    1528:	0d6c9102 	stfeqp	f1, [ip, #-8]!
    152c:	00746f64 	rsbseq	r6, r4, r4, ror #30
    1530:	140a3e01 	strne	r3, [sl], #-3585	; 0xfffff1ff
    1534:	02000005 	andeq	r0, r0, #5
    1538:	1b0c7791 	blne	31f384 <__bss_end+0x315904>
    153c:	01000010 	tsteq	r0, r0, lsl r0
    1540:	05140a3f 	ldreq	r0, [r4, #-2623]	; 0xfffff5c1
    1544:	91020000 	mrsls	r0, (UNDEF: 2)
    1548:	89441376 	stmdbhi	r4, {r1, r2, r4, r5, r6, r8, r9, ip}^
    154c:	008c0000 	addeq	r0, ip, r0
    1550:	630d0000 	movwvs	r0, #53248	; 0xd000
    1554:	0e410100 	dvfeqs	f0, f1, f0
    1558:	0000006d 	andeq	r0, r0, sp, rrx
    155c:	00759102 	rsbseq	r9, r5, r2, lsl #2
    1560:	0f2a1600 	svceq	0x002a1600
    1564:	26010000 	strcs	r0, [r1], -r0
    1568:	00105b05 	andseq	r5, r0, r5, lsl #22
    156c:	00017f00 	andeq	r7, r1, r0, lsl #30
    1570:	00884800 	addeq	r4, r8, r0, lsl #16
    1574:	0000cc00 	andeq	ip, r0, r0, lsl #24
    1578:	bb9c0100 	bllt	fe701980 <__bss_end+0xfe6f7f00>
    157c:	10000005 	andne	r0, r0, r5
    1580:	00000f3f 	andeq	r0, r0, pc, lsr pc
    1584:	0c162601 	ldceq	6, cr2, [r6], {1}
    1588:	02000002 	andeq	r0, r0, #2
    158c:	280c6c91 	stmdacs	ip, {r0, r4, r7, sl, fp, sp, lr}
    1590:	01000010 	tsteq	r0, r0, lsl r0
    1594:	017f062a 	cmneq	pc, sl, lsr #12
    1598:	91020000 	mrsls	r0, (UNDEF: 2)
    159c:	bc170074 	ldclt	0, cr0, [r7], {116}	; 0x74
    15a0:	0100000f 	tsteq	r0, pc
    15a4:	10660608 	rsbne	r0, r6, r8, lsl #12
    15a8:	86d00000 	ldrbhi	r0, [r0], r0
    15ac:	01780000 	cmneq	r8, r0
    15b0:	9c010000 	stcls	0, cr0, [r1], {-0}
    15b4:	000f3f10 	andeq	r3, pc, r0, lsl pc	; <UNPREDICTABLE>
    15b8:	0f080100 	svceq	0x00080100
    15bc:	0000017f 	andeq	r0, r0, pc, ror r1
    15c0:	10649102 	rsbne	r9, r4, r2, lsl #2
    15c4:	00001028 	andeq	r1, r0, r8, lsr #32
    15c8:	261c0801 	ldrcs	r0, [ip], -r1, lsl #16
    15cc:	02000001 	andeq	r0, r0, #1
    15d0:	c0106091 	mulsgt	r0, r1, r0
    15d4:	01000011 	tsteq	r0, r1, lsl r0
    15d8:	00663108 	rsbeq	r3, r6, r8, lsl #2
    15dc:	91020000 	mrsls	r0, (UNDEF: 2)
    15e0:	00690d5c 	rsbeq	r0, r9, ip, asr sp
    15e4:	7f090a01 	svcvc	0x00090a01
    15e8:	02000001 	andeq	r0, r0, #1
    15ec:	6a0d7491 	bvs	35e838 <__bss_end+0x354db8>
    15f0:	090b0100 	stmdbeq	fp, {r8}
    15f4:	0000017f 	andeq	r0, r0, pc, ror r1
    15f8:	13709102 	cmnne	r0, #-2147483648	; 0x80000000
    15fc:	000087c8 	andeq	r8, r0, r8, asr #15
    1600:	00000060 	andeq	r0, r0, r0, rrx
    1604:	0100630d 	tsteq	r0, sp, lsl #6
    1608:	006d081f 	rsbeq	r0, sp, pc, lsl r8
    160c:	91020000 	mrsls	r0, (UNDEF: 2)
    1610:	0000006f 	andeq	r0, r0, pc, rrx
    1614:	00000022 	andeq	r0, r0, r2, lsr #32
    1618:	06330002 	ldrteq	r0, [r3], -r2
    161c:	01040000 	mrseq	r0, (UNDEF: 4)
    1620:	00000a6e 	andeq	r0, r0, lr, ror #20
    1624:	0000932c 	andeq	r9, r0, ip, lsr #6
    1628:	00009538 	andeq	r9, r0, r8, lsr r5
    162c:	000010a3 	andeq	r1, r0, r3, lsr #1
    1630:	000010d3 	ldrdeq	r1, [r0], -r3
    1634:	0000113b 	andeq	r1, r0, fp, lsr r1
    1638:	00228001 	eoreq	r8, r2, r1
    163c:	00020000 	andeq	r0, r2, r0
    1640:	00000647 	andeq	r0, r0, r7, asr #12
    1644:	0aeb0104 	beq	ffac1a5c <__bss_end+0xffab7fdc>
    1648:	95380000 	ldrls	r0, [r8, #-0]!
    164c:	953c0000 	ldrls	r0, [ip, #-0]!
    1650:	10a30000 	adcne	r0, r3, r0
    1654:	10d30000 	sbcsne	r0, r3, r0
    1658:	113b0000 	teqne	fp, r0
    165c:	80010000 	andhi	r0, r1, r0
    1660:	00000022 	andeq	r0, r0, r2, lsr #32
    1664:	065b0002 	ldrbeq	r0, [fp], -r2
    1668:	01040000 	mrseq	r0, (UNDEF: 4)
    166c:	00000b4b 	andeq	r0, r0, fp, asr #22
    1670:	0000953c 	andeq	r9, r0, ip, lsr r5
    1674:	0000978c 	andeq	r9, r0, ip, lsl #15
    1678:	00001147 	andeq	r1, r0, r7, asr #2
    167c:	000010d3 	ldrdeq	r1, [r0], -r3
    1680:	0000113b 	andeq	r1, r0, fp, lsr r1
    1684:	00228001 	eoreq	r8, r2, r1
    1688:	00020000 	andeq	r0, r2, r0
    168c:	0000066f 	andeq	r0, r0, pc, ror #12
    1690:	0c4a0104 	stfeqe	f0, [sl], {4}
    1694:	978c0000 	strls	r0, [ip, r0]
    1698:	98600000 	stmdals	r0!, {}^	; <UNPREDICTABLE>
    169c:	11780000 	cmnne	r8, r0
    16a0:	10d30000 	sbcsne	r0, r3, r0
    16a4:	113b0000 	teqne	fp, r0
    16a8:	80010000 	andhi	r0, r1, r0
    16ac:	0000032a 	andeq	r0, r0, sl, lsr #6
    16b0:	06830004 	streq	r0, [r3], r4
    16b4:	01040000 	mrseq	r0, (UNDEF: 4)
    16b8:	000012c4 	andeq	r1, r0, r4, asr #5
    16bc:	00147d0c 	andseq	r7, r4, ip, lsl #26
    16c0:	0010d300 	andseq	sp, r0, r0, lsl #6
    16c4:	000cc800 	andeq	ip, ip, r0, lsl #16
    16c8:	05040200 	streq	r0, [r4, #-512]	; 0xfffffe00
    16cc:	00746e69 	rsbseq	r6, r4, r9, ror #28
    16d0:	c6070403 	strgt	r0, [r7], -r3, lsl #8
    16d4:	03000014 	movweq	r0, #20
    16d8:	02430508 	subeq	r0, r3, #8, 10	; 0x2000000
    16dc:	08030000 	stmdaeq	r3, {}	; <UNPREDICTABLE>
    16e0:	00147104 	andseq	r7, r4, r4, lsl #2
    16e4:	08010300 	stmdaeq	r1, {r8, r9}
    16e8:	000003df 	ldrdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    16ec:	e1060103 	tst	r6, r3, lsl #2
    16f0:	04000003 	streq	r0, [r0], #-3
    16f4:	00001649 	andeq	r1, r0, r9, asr #12
    16f8:	00390107 	eorseq	r0, r9, r7, lsl #2
    16fc:	17010000 	strne	r0, [r1, -r0]
    1700:	0001d406 	andeq	sp, r1, r6, lsl #8
    1704:	11d30500 	bicsne	r0, r3, r0, lsl #10
    1708:	05000000 	streq	r0, [r0, #-0]
    170c:	000016f8 	strdeq	r1, [r0], -r8
    1710:	13a60501 			; <UNDEFINED> instruction: 0x13a60501
    1714:	05020000 	streq	r0, [r2, #-0]
    1718:	00001464 	andeq	r1, r0, r4, ror #8
    171c:	16620503 	strbtne	r0, [r2], -r3, lsl #10
    1720:	05040000 	streq	r0, [r4, #-0]
    1724:	00001708 	andeq	r1, r0, r8, lsl #14
    1728:	16780505 	ldrbtne	r0, [r8], -r5, lsl #10
    172c:	05060000 	streq	r0, [r6, #-0]
    1730:	000014ad 	andeq	r1, r0, sp, lsr #9
    1734:	15f30507 	ldrbne	r0, [r3, #1287]!	; 0x507
    1738:	05080000 	streq	r0, [r8, #-0]
    173c:	00001601 	andeq	r1, r0, r1, lsl #12
    1740:	160f0509 	strne	r0, [pc], -r9, lsl #10
    1744:	050a0000 	streq	r0, [sl, #-0]
    1748:	00001516 	andeq	r1, r0, r6, lsl r5
    174c:	1506050b 	strne	r0, [r6, #-1291]	; 0xfffffaf5
    1750:	050c0000 	streq	r0, [ip, #-0]
    1754:	000011ef 	andeq	r1, r0, pc, ror #3
    1758:	1208050d 	andne	r0, r8, #54525952	; 0x3400000
    175c:	050e0000 	streq	r0, [lr, #-0]
    1760:	000014f7 	strdeq	r1, [r0], -r7
    1764:	16bb050f 	ldrtne	r0, [fp], pc, lsl #10
    1768:	05100000 	ldreq	r0, [r0, #-0]
    176c:	00001638 	andeq	r1, r0, r8, lsr r6
    1770:	16ac0511 	ssatne	r0, #13, r1, lsl #10
    1774:	05120000 	ldreq	r0, [r2, #-0]
    1778:	000012b5 			; <UNDEFINED> instruction: 0x000012b5
    177c:	12320513 	eorsne	r0, r2, #79691776	; 0x4c00000
    1780:	05140000 	ldreq	r0, [r4, #-0]
    1784:	000011fc 	strdeq	r1, [r0], -ip
    1788:	15950515 	ldrne	r0, [r5, #1301]	; 0x515
    178c:	05160000 	ldreq	r0, [r6, #-0]
    1790:	00001269 	andeq	r1, r0, r9, ror #4
    1794:	11a40517 			; <UNDEFINED> instruction: 0x11a40517
    1798:	05180000 	ldreq	r0, [r8, #-0]
    179c:	0000169e 	muleq	r0, lr, r6
    17a0:	14d30519 	ldrbne	r0, [r3], #1305	; 0x519
    17a4:	051a0000 	ldreq	r0, [sl, #-0]
    17a8:	000015ad 	andeq	r1, r0, sp, lsr #11
    17ac:	123d051b 	eorsne	r0, sp, #113246208	; 0x6c00000
    17b0:	051c0000 	ldreq	r0, [ip, #-0]
    17b4:	00001449 	andeq	r1, r0, r9, asr #8
    17b8:	1398051d 	orrsne	r0, r8, #121634816	; 0x7400000
    17bc:	051e0000 	ldreq	r0, [lr, #-0]
    17c0:	0000162a 	andeq	r1, r0, sl, lsr #12
    17c4:	1686051f 	pkhbtne	r0, r6, pc, lsl #10	; <UNPREDICTABLE>
    17c8:	05200000 	streq	r0, [r0, #-0]!
    17cc:	000016c7 	andeq	r1, r0, r7, asr #13
    17d0:	16d50521 	ldrbne	r0, [r5], r1, lsr #10
    17d4:	05220000 	streq	r0, [r2, #-0]!
    17d8:	000014ea 	andeq	r1, r0, sl, ror #9
    17dc:	140d0523 	strne	r0, [sp], #-1315	; 0xfffffadd
    17e0:	05240000 	streq	r0, [r4, #-0]!
    17e4:	0000124c 	andeq	r1, r0, ip, asr #4
    17e8:	14a00525 	strtne	r0, [r0], #1317	; 0x525
    17ec:	05260000 	streq	r0, [r6, #-0]!
    17f0:	000013b2 			; <UNDEFINED> instruction: 0x000013b2
    17f4:	16550527 	ldrbne	r0, [r5], -r7, lsr #10
    17f8:	05280000 	streq	r0, [r8, #-0]!
    17fc:	000013c2 	andeq	r1, r0, r2, asr #7
    1800:	13d10529 	bicsne	r0, r1, #171966464	; 0xa400000
    1804:	052a0000 	streq	r0, [sl, #-0]!
    1808:	000013e0 	andeq	r1, r0, r0, ror #7
    180c:	13ef052b 	mvnne	r0, #180355072	; 0xac00000
    1810:	052c0000 	streq	r0, [ip, #-0]!
    1814:	0000137d 	andeq	r1, r0, sp, ror r3
    1818:	13fe052d 	mvnsne	r0, #188743680	; 0xb400000
    181c:	052e0000 	streq	r0, [lr, #-0]!
    1820:	000015e4 	andeq	r1, r0, r4, ror #11
    1824:	141c052f 	ldrne	r0, [ip], #-1327	; 0xfffffad1
    1828:	05300000 	ldreq	r0, [r0, #-0]!
    182c:	0000142b 	andeq	r1, r0, fp, lsr #8
    1830:	11dd0531 	bicsne	r0, sp, r1, lsr r5
    1834:	05320000 	ldreq	r0, [r2, #-0]!
    1838:	00001535 	andeq	r1, r0, r5, lsr r5
    183c:	15450533 	strbne	r0, [r5, #-1331]	; 0xfffffacd
    1840:	05340000 	ldreq	r0, [r4, #-0]!
    1844:	00001555 	andeq	r1, r0, r5, asr r5
    1848:	136b0535 	cmnne	fp, #222298112	; 0xd400000
    184c:	05360000 	ldreq	r0, [r6, #-0]!
    1850:	00001565 	andeq	r1, r0, r5, ror #10
    1854:	15750537 	ldrbne	r0, [r5, #-1335]!	; 0xfffffac9
    1858:	05380000 	ldreq	r0, [r8, #-0]!
    185c:	00001585 	andeq	r1, r0, r5, lsl #11
    1860:	125c0539 	subsne	r0, ip, #239075328	; 0xe400000
    1864:	053a0000 	ldreq	r0, [sl, #-0]!
    1868:	00001215 	andeq	r1, r0, r5, lsl r2
    186c:	143a053b 	ldrtne	r0, [sl], #-1339	; 0xfffffac5
    1870:	053c0000 	ldreq	r0, [ip, #-0]!
    1874:	000011b4 			; <UNDEFINED> instruction: 0x000011b4
    1878:	15a0053d 	strne	r0, [r0, #1341]!	; 0x53d
    187c:	003e0000 	eorseq	r0, lr, r0
    1880:	00129c06 	andseq	r9, r2, r6, lsl #24
    1884:	6b010200 	blvs	4208c <__bss_end+0x3860c>
    1888:	01ff0802 	mvnseq	r0, r2, lsl #16
    188c:	5f070000 	svcpl	0x00070000
    1890:	01000014 	tsteq	r0, r4, lsl r0
    1894:	47140270 			; <UNDEFINED> instruction: 0x47140270
    1898:	00000000 	andeq	r0, r0, r0
    189c:	00137807 	andseq	r7, r3, r7, lsl #16
    18a0:	02710100 	rsbseq	r0, r1, #0, 2
    18a4:	00004714 	andeq	r4, r0, r4, lsl r7
    18a8:	08000100 	stmdaeq	r0, {r8}
    18ac:	000001d4 	ldrdeq	r0, [r0], -r4
    18b0:	0001ff09 	andeq	pc, r1, r9, lsl #30
    18b4:	00021400 	andeq	r1, r2, r0, lsl #8
    18b8:	00240a00 	eoreq	r0, r4, r0, lsl #20
    18bc:	00110000 	andseq	r0, r1, r0
    18c0:	00020408 	andeq	r0, r2, r8, lsl #8
    18c4:	15230b00 	strne	r0, [r3, #-2816]!	; 0xfffff500
    18c8:	74010000 	strvc	r0, [r1], #-0
    18cc:	02142602 	andseq	r2, r4, #2097152	; 0x200000
    18d0:	3a240000 	bcc	9018d8 <__bss_end+0x8f7e58>
    18d4:	0f3d0a3d 	svceq	0x003d0a3d
    18d8:	323d243d 	eorscc	r2, sp, #1023410176	; 0x3d000000
    18dc:	053d023d 	ldreq	r0, [sp, #-573]!	; 0xfffffdc3
    18e0:	0d3d133d 	ldceq	3, cr1, [sp, #-244]!	; 0xffffff0c
    18e4:	233d0c3d 	teqcs	sp, #15616	; 0x3d00
    18e8:	263d113d 			; <UNDEFINED> instruction: 0x263d113d
    18ec:	173d013d 			; <UNDEFINED> instruction: 0x173d013d
    18f0:	093d083d 	ldmdbeq	sp!, {r0, r2, r3, r4, r5, fp}
    18f4:	0300003d 	movweq	r0, #61	; 0x3d
    18f8:	03370702 	teqeq	r7, #524288	; 0x80000
    18fc:	01030000 	mrseq	r0, (UNDEF: 3)
    1900:	0003e808 	andeq	lr, r3, r8, lsl #16
    1904:	040d0c00 	streq	r0, [sp], #-3072	; 0xfffff400
    1908:	00000259 	andeq	r0, r0, r9, asr r2
    190c:	0016e30e 	andseq	lr, r6, lr, lsl #6
    1910:	39010700 	stmdbcc	r1, {r8, r9, sl}
    1914:	02000000 	andeq	r0, r0, #0
    1918:	9e0604f7 	mcrls	4, 0, r0, cr6, cr7, {7}
    191c:	05000002 	streq	r0, [r0, #-2]
    1920:	00001276 	andeq	r1, r0, r6, ror r2
    1924:	12810500 	addne	r0, r1, #0, 10
    1928:	05010000 	streq	r0, [r1, #-0]
    192c:	00001293 	muleq	r0, r3, r2
    1930:	12ad0502 	adcne	r0, sp, #8388608	; 0x800000
    1934:	05030000 	streq	r0, [r3, #-0]
    1938:	0000161d 	andeq	r1, r0, sp, lsl r6
    193c:	138c0504 	orrne	r0, ip, #4, 10	; 0x1000000
    1940:	05050000 	streq	r0, [r5, #-0]
    1944:	000015d6 	ldrdeq	r1, [r0], -r6
    1948:	02030006 	andeq	r0, r3, #6
    194c:	00043e05 	andeq	r3, r4, r5, lsl #28
    1950:	07080300 	streq	r0, [r8, -r0, lsl #6]
    1954:	000014bc 			; <UNDEFINED> instruction: 0x000014bc
    1958:	cd040403 	cfstrsgt	mvf0, [r4, #-12]
    195c:	03000011 	movweq	r0, #17
    1960:	11c50308 	bicne	r0, r5, r8, lsl #6
    1964:	08030000 	stmdaeq	r3, {}	; <UNPREDICTABLE>
    1968:	00147604 	andseq	r7, r4, r4, lsl #12
    196c:	03100300 	tsteq	r0, #0, 6
    1970:	000015c7 	andeq	r1, r0, r7, asr #11
    1974:	0015be0f 	andseq	fp, r5, pc, lsl #28
    1978:	102a0300 	eorne	r0, sl, r0, lsl #6
    197c:	0000025a 	andeq	r0, r0, sl, asr r2
    1980:	0002c809 	andeq	ip, r2, r9, lsl #16
    1984:	0002df00 	andeq	sp, r2, r0, lsl #30
    1988:	11001000 	mrsne	r1, (UNDEF: 0)
    198c:	0000030c 	andeq	r0, r0, ip, lsl #6
    1990:	d4112f03 	ldrle	r2, [r1], #-3843	; 0xfffff0fd
    1994:	11000002 	tstne	r0, r2
    1998:	00000200 	andeq	r0, r0, r0, lsl #4
    199c:	d4113003 	ldrle	r3, [r1], #-3
    19a0:	09000002 	stmdbeq	r0, {r1}
    19a4:	000002c8 	andeq	r0, r0, r8, asr #5
    19a8:	00000307 	andeq	r0, r0, r7, lsl #6
    19ac:	0000240a 	andeq	r2, r0, sl, lsl #8
    19b0:	12000100 	andne	r0, r0, #0, 2
    19b4:	000002df 	ldrdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    19b8:	0a093304 	beq	24e5d0 <__bss_end+0x244b50>
    19bc:	000002f7 	strdeq	r0, [r0], -r7
    19c0:	9a700305 	bls	1c025dc <__bss_end+0x1bf8b5c>
    19c4:	eb120000 	bl	4819cc <__bss_end+0x477f4c>
    19c8:	04000002 	streq	r0, [r0], #-2
    19cc:	f70a0934 			; <UNDEFINED> instruction: 0xf70a0934
    19d0:	05000002 	streq	r0, [r0, #-2]
    19d4:	009a7003 	addseq	r7, sl, r3
    19d8:	03060000 	movweq	r0, #24576	; 0x6000
    19dc:	00040000 	andeq	r0, r4, r0
    19e0:	00000770 	andeq	r0, r0, r0, ror r7
    19e4:	12c40104 	sbcne	r0, r4, #4, 2
    19e8:	7d0c0000 	stcvc	0, cr0, [ip, #-0]
    19ec:	d3000014 	movwle	r0, #20
    19f0:	60000010 	andvs	r0, r0, r0, lsl r0
    19f4:	30000098 	mulcc	r0, r8, r0
    19f8:	70000000 	andvc	r0, r0, r0
    19fc:	0200000d 	andeq	r0, r0, #13
    1a00:	11cd0404 	bicne	r0, sp, r4, lsl #8
    1a04:	04030000 	streq	r0, [r3], #-0
    1a08:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
    1a0c:	07040200 	streq	r0, [r4, -r0, lsl #4]
    1a10:	000014c6 	andeq	r1, r0, r6, asr #9
    1a14:	43050802 	movwmi	r0, #22530	; 0x5802
    1a18:	02000002 	andeq	r0, r0, #2
    1a1c:	14710408 	ldrbtne	r0, [r1], #-1032	; 0xfffffbf8
    1a20:	01020000 	mrseq	r0, (UNDEF: 2)
    1a24:	0003df08 	andeq	sp, r3, r8, lsl #30
    1a28:	06010200 	streq	r0, [r1], -r0, lsl #4
    1a2c:	000003e1 	andeq	r0, r0, r1, ror #7
    1a30:	00164904 	andseq	r4, r6, r4, lsl #18
    1a34:	48010700 	stmdami	r1, {r8, r9, sl}
    1a38:	02000000 	andeq	r0, r0, #0
    1a3c:	01e30617 	mvneq	r0, r7, lsl r6
    1a40:	d3050000 	movwle	r0, #20480	; 0x5000
    1a44:	00000011 	andeq	r0, r0, r1, lsl r0
    1a48:	0016f805 	andseq	pc, r6, r5, lsl #16
    1a4c:	a6050100 	strge	r0, [r5], -r0, lsl #2
    1a50:	02000013 	andeq	r0, r0, #19
    1a54:	00146405 	andseq	r6, r4, r5, lsl #8
    1a58:	62050300 	andvs	r0, r5, #0, 6
    1a5c:	04000016 	streq	r0, [r0], #-22	; 0xffffffea
    1a60:	00170805 	andseq	r0, r7, r5, lsl #16
    1a64:	78050500 	stmdavc	r5, {r8, sl}
    1a68:	06000016 			; <UNDEFINED> instruction: 0x06000016
    1a6c:	0014ad05 	andseq	sl, r4, r5, lsl #26
    1a70:	f3050700 	vabd.u8	d0, d5, d0
    1a74:	08000015 	stmdaeq	r0, {r0, r2, r4}
    1a78:	00160105 	andseq	r0, r6, r5, lsl #2
    1a7c:	0f050900 	svceq	0x00050900
    1a80:	0a000016 	beq	1ae0 <shift+0x1ae0>
    1a84:	00151605 	andseq	r1, r5, r5, lsl #12
    1a88:	06050b00 	streq	r0, [r5], -r0, lsl #22
    1a8c:	0c000015 	stceq	0, cr0, [r0], {21}
    1a90:	0011ef05 	andseq	lr, r1, r5, lsl #30
    1a94:	08050d00 	stmdaeq	r5, {r8, sl, fp}
    1a98:	0e000012 	mcreq	0, 0, r0, cr0, cr2, {0}
    1a9c:	0014f705 	andseq	pc, r4, r5, lsl #14
    1aa0:	bb050f00 	bllt	1456a8 <__bss_end+0x13bc28>
    1aa4:	10000016 	andne	r0, r0, r6, lsl r0
    1aa8:	00163805 	andseq	r3, r6, r5, lsl #16
    1aac:	ac051100 	stfges	f1, [r5], {-0}
    1ab0:	12000016 	andne	r0, r0, #22
    1ab4:	0012b505 	andseq	fp, r2, r5, lsl #10
    1ab8:	32051300 	andcc	r1, r5, #0, 6
    1abc:	14000012 	strne	r0, [r0], #-18	; 0xffffffee
    1ac0:	0011fc05 	andseq	pc, r1, r5, lsl #24
    1ac4:	95051500 	strls	r1, [r5, #-1280]	; 0xfffffb00
    1ac8:	16000015 			; <UNDEFINED> instruction: 0x16000015
    1acc:	00126905 	andseq	r6, r2, r5, lsl #18
    1ad0:	a4051700 	strge	r1, [r5], #-1792	; 0xfffff900
    1ad4:	18000011 	stmdane	r0, {r0, r4}
    1ad8:	00169e05 	andseq	r9, r6, r5, lsl #28
    1adc:	d3051900 	movwle	r1, #22784	; 0x5900
    1ae0:	1a000014 	bne	1b38 <shift+0x1b38>
    1ae4:	0015ad05 	andseq	sl, r5, r5, lsl #26
    1ae8:	3d051b00 	vstrcc	d1, [r5, #-0]
    1aec:	1c000012 	stcne	0, cr0, [r0], {18}
    1af0:	00144905 	andseq	r4, r4, r5, lsl #18
    1af4:	98051d00 	stmdals	r5, {r8, sl, fp, ip}
    1af8:	1e000013 	mcrne	0, 0, r0, cr0, cr3, {0}
    1afc:	00162a05 	andseq	r2, r6, r5, lsl #20
    1b00:	86051f00 	strhi	r1, [r5], -r0, lsl #30
    1b04:	20000016 	andcs	r0, r0, r6, lsl r0
    1b08:	0016c705 	andseq	ip, r6, r5, lsl #14
    1b0c:	d5052100 	strle	r2, [r5, #-256]	; 0xffffff00
    1b10:	22000016 	andcs	r0, r0, #22
    1b14:	0014ea05 	andseq	lr, r4, r5, lsl #20
    1b18:	0d052300 	stceq	3, cr2, [r5, #-0]
    1b1c:	24000014 	strcs	r0, [r0], #-20	; 0xffffffec
    1b20:	00124c05 	andseq	r4, r2, r5, lsl #24
    1b24:	a0052500 	andge	r2, r5, r0, lsl #10
    1b28:	26000014 			; <UNDEFINED> instruction: 0x26000014
    1b2c:	0013b205 	andseq	fp, r3, r5, lsl #4
    1b30:	55052700 	strpl	r2, [r5, #-1792]	; 0xfffff900
    1b34:	28000016 	stmdacs	r0, {r1, r2, r4}
    1b38:	0013c205 	andseq	ip, r3, r5, lsl #4
    1b3c:	d1052900 	tstle	r5, r0, lsl #18
    1b40:	2a000013 	bcs	1b94 <shift+0x1b94>
    1b44:	0013e005 	andseq	lr, r3, r5
    1b48:	ef052b00 	svc	0x00052b00
    1b4c:	2c000013 	stccs	0, cr0, [r0], {19}
    1b50:	00137d05 	andseq	r7, r3, r5, lsl #26
    1b54:	fe052d00 	vdot.bf16	d2, d5, d0[0]
    1b58:	2e000013 	mcrcs	0, 0, r0, cr0, cr3, {0}
    1b5c:	0015e405 	andseq	lr, r5, r5, lsl #8
    1b60:	1c052f00 	stcne	15, cr2, [r5], {-0}
    1b64:	30000014 	andcc	r0, r0, r4, lsl r0
    1b68:	00142b05 	andseq	r2, r4, r5, lsl #22
    1b6c:	dd053100 	stfles	f3, [r5, #-0]
    1b70:	32000011 	andcc	r0, r0, #17
    1b74:	00153505 	andseq	r3, r5, r5, lsl #10
    1b78:	45053300 	strmi	r3, [r5, #-768]	; 0xfffffd00
    1b7c:	34000015 	strcc	r0, [r0], #-21	; 0xffffffeb
    1b80:	00155505 	andseq	r5, r5, r5, lsl #10
    1b84:	6b053500 	blvs	14ef8c <__bss_end+0x14550c>
    1b88:	36000013 			; <UNDEFINED> instruction: 0x36000013
    1b8c:	00156505 	andseq	r6, r5, r5, lsl #10
    1b90:	75053700 	strvc	r3, [r5, #-1792]	; 0xfffff900
    1b94:	38000015 	stmdacc	r0, {r0, r2, r4}
    1b98:	00158505 	andseq	r8, r5, r5, lsl #10
    1b9c:	5c053900 			; <UNDEFINED> instruction: 0x5c053900
    1ba0:	3a000012 	bcc	1bf0 <shift+0x1bf0>
    1ba4:	00121505 	andseq	r1, r2, r5, lsl #10
    1ba8:	3a053b00 	bcc	1507b0 <__bss_end+0x146d30>
    1bac:	3c000014 	stccc	0, cr0, [r0], {20}
    1bb0:	0011b405 	andseq	fp, r1, r5, lsl #8
    1bb4:	a0053d00 	andge	r3, r5, r0, lsl #26
    1bb8:	3e000015 	mcrcc	0, 0, r0, cr0, cr5, {0}
    1bbc:	129c0600 	addsne	r0, ip, #0, 12
    1bc0:	02020000 	andeq	r0, r2, #0
    1bc4:	0e08026b 	cdpeq	2, 0, cr0, cr8, cr11, {3}
    1bc8:	07000002 	streq	r0, [r0, -r2]
    1bcc:	0000145f 	andeq	r1, r0, pc, asr r4
    1bd0:	14027002 	strne	r7, [r2], #-2
    1bd4:	00000056 	andeq	r0, r0, r6, asr r0
    1bd8:	13780700 	cmnne	r8, #0, 14
    1bdc:	71020000 	mrsvc	r0, (UNDEF: 2)
    1be0:	00561402 	subseq	r1, r6, r2, lsl #8
    1be4:	00010000 	andeq	r0, r1, r0
    1be8:	0001e308 	andeq	lr, r1, r8, lsl #6
    1bec:	020e0900 	andeq	r0, lr, #0, 18
    1bf0:	02230000 	eoreq	r0, r3, #0
    1bf4:	330a0000 	movwcc	r0, #40960	; 0xa000
    1bf8:	11000000 	mrsne	r0, (UNDEF: 0)
    1bfc:	02130800 	andseq	r0, r3, #0, 16
    1c00:	230b0000 	movwcs	r0, #45056	; 0xb000
    1c04:	02000015 	andeq	r0, r0, #21
    1c08:	23260274 			; <UNDEFINED> instruction: 0x23260274
    1c0c:	24000002 	strcs	r0, [r0], #-2
    1c10:	3d0a3d3a 	stccc	13, cr3, [sl, #-232]	; 0xffffff18
    1c14:	3d243d0f 	stccc	13, cr3, [r4, #-60]!	; 0xffffffc4
    1c18:	3d023d32 	stccc	13, cr3, [r2, #-200]	; 0xffffff38
    1c1c:	3d133d05 	ldccc	13, cr3, [r3, #-20]	; 0xffffffec
    1c20:	3d0c3d0d 	stccc	13, cr3, [ip, #-52]	; 0xffffffcc
    1c24:	3d113d23 	ldccc	13, cr3, [r1, #-140]	; 0xffffff74
    1c28:	3d013d26 	stccc	13, cr3, [r1, #-152]	; 0xffffff68
    1c2c:	3d083d17 	stccc	13, cr3, [r8, #-92]	; 0xffffffa4
    1c30:	00003d09 	andeq	r3, r0, r9, lsl #26
    1c34:	37070202 	strcc	r0, [r7, -r2, lsl #4]
    1c38:	02000003 	andeq	r0, r0, #3
    1c3c:	03e80801 	mvneq	r0, #65536	; 0x10000
    1c40:	02020000 	andeq	r0, r2, #0
    1c44:	00043e05 	andeq	r3, r4, r5, lsl #28
    1c48:	17540c00 	ldrbne	r0, [r4, -r0, lsl #24]
    1c4c:	84030000 	strhi	r0, [r3], #-0
    1c50:	00003a0f 	andeq	r3, r0, pc, lsl #20
    1c54:	07080200 	streq	r0, [r8, -r0, lsl #4]
    1c58:	000014bc 			; <UNDEFINED> instruction: 0x000014bc
    1c5c:	0017250c 	andseq	r2, r7, ip, lsl #10
    1c60:	10930300 	addsne	r0, r3, r0, lsl #6
    1c64:	00000025 	andeq	r0, r0, r5, lsr #32
    1c68:	c5030802 	strgt	r0, [r3, #-2050]	; 0xfffff7fe
    1c6c:	02000011 	andeq	r0, r0, #17
    1c70:	14760408 	ldrbtne	r0, [r6], #-1032	; 0xfffffbf8
    1c74:	10020000 	andne	r0, r2, r0
    1c78:	0015c703 	andseq	ip, r5, r3, lsl #14
    1c7c:	173a0d00 	ldrne	r0, [sl, -r0, lsl #26]!
    1c80:	f9010000 			; <UNDEFINED> instruction: 0xf9010000
    1c84:	026f0105 	rsbeq	r0, pc, #1073741825	; 0x40000001
    1c88:	98600000 	stmdals	r0!, {}^	; <UNPREDICTABLE>
    1c8c:	00300000 	eorseq	r0, r0, r0
    1c90:	9c010000 	stcls	0, cr0, [r1], {-0}
    1c94:	000002fd 	strdeq	r0, [r0], -sp
    1c98:	0100610e 	tsteq	r0, lr, lsl #2
    1c9c:	821305f9 	andshi	r0, r3, #1044381696	; 0x3e400000
    1ca0:	08000002 	stmdaeq	r0, {r1}
    1ca4:	00000000 	andeq	r0, r0, r0
    1ca8:	0f000000 	svceq	0x00000000
    1cac:	00009874 	andeq	r9, r0, r4, ror r8
    1cb0:	000002fd 	strdeq	r0, [r0], -sp
    1cb4:	000002e8 	andeq	r0, r0, r8, ror #5
    1cb8:	05500110 	ldrbeq	r0, [r0, #-272]	; 0xfffffef0
    1cbc:	00f503f3 	ldrshteq	r0, [r5], #51	; 0x33
    1cc0:	84110025 	ldrhi	r0, [r1], #-37	; 0xffffffdb
    1cc4:	fd000098 	stc2	0, cr0, [r0, #-608]	; 0xfffffda0
    1cc8:	10000002 	andne	r0, r0, r2
    1ccc:	f3065001 	vhadd.u8	d5, d6, d1
    1cd0:	2500f503 	strcs	pc, [r0, #-1283]	; 0xfffffafd
    1cd4:	1200001f 	andne	r0, r0, #31
    1cd8:	0000172c 	andeq	r1, r0, ip, lsr #14
    1cdc:	00001718 	andeq	r1, r0, r8, lsl r7
    1ce0:	00033b01 	andeq	r3, r3, r1, lsl #22
    1ce4:	0000032a 	andeq	r0, r0, sl, lsr #6
    1ce8:	087f0004 	ldmdaeq	pc!, {r2}^	; <UNPREDICTABLE>
    1cec:	01040000 	mrseq	r0, (UNDEF: 4)
    1cf0:	000012c4 	andeq	r1, r0, r4, asr #5
    1cf4:	00147d0c 	andseq	r7, r4, ip, lsl #26
    1cf8:	0010d300 	andseq	sp, r0, r0, lsl #6
    1cfc:	00989000 	addseq	r9, r8, r0
    1d00:	00004000 	andeq	r4, r0, r0
    1d04:	000e1b00 	andeq	r1, lr, r0, lsl #22
    1d08:	04080200 	streq	r0, [r8], #-512	; 0xfffffe00
    1d0c:	00001476 	andeq	r1, r0, r6, ror r4
    1d10:	c6070402 	strgt	r0, [r7], -r2, lsl #8
    1d14:	02000014 	andeq	r0, r0, #20
    1d18:	11cd0404 	bicne	r0, sp, r4, lsl #8
    1d1c:	04030000 	streq	r0, [r3], #-0
    1d20:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
    1d24:	05080200 	streq	r0, [r8, #-512]	; 0xfffffe00
    1d28:	00000243 	andeq	r0, r0, r3, asr #4
    1d2c:	71040802 	tstvc	r4, r2, lsl #16
    1d30:	02000014 	andeq	r0, r0, #20
    1d34:	03df0801 	bicseq	r0, pc, #65536	; 0x10000
    1d38:	01020000 	mrseq	r0, (UNDEF: 2)
    1d3c:	0003e106 	andeq	lr, r3, r6, lsl #2
    1d40:	16490400 	strbne	r0, [r9], -r0, lsl #8
    1d44:	01070000 	mrseq	r0, (UNDEF: 7)
    1d48:	0000004f 	andeq	r0, r0, pc, asr #32
    1d4c:	ea061702 	b	18795c <__bss_end+0x17dedc>
    1d50:	05000001 	streq	r0, [r0, #-1]
    1d54:	000011d3 	ldrdeq	r1, [r0], -r3
    1d58:	16f80500 	ldrbtne	r0, [r8], r0, lsl #10
    1d5c:	05010000 	streq	r0, [r1, #-0]
    1d60:	000013a6 	andeq	r1, r0, r6, lsr #7
    1d64:	14640502 	strbtne	r0, [r4], #-1282	; 0xfffffafe
    1d68:	05030000 	streq	r0, [r3, #-0]
    1d6c:	00001662 	andeq	r1, r0, r2, ror #12
    1d70:	17080504 	strne	r0, [r8, -r4, lsl #10]
    1d74:	05050000 	streq	r0, [r5, #-0]
    1d78:	00001678 	andeq	r1, r0, r8, ror r6
    1d7c:	14ad0506 	strtne	r0, [sp], #1286	; 0x506
    1d80:	05070000 	streq	r0, [r7, #-0]
    1d84:	000015f3 	strdeq	r1, [r0], -r3
    1d88:	16010508 	strne	r0, [r1], -r8, lsl #10
    1d8c:	05090000 	streq	r0, [r9, #-0]
    1d90:	0000160f 	andeq	r1, r0, pc, lsl #12
    1d94:	1516050a 	ldrne	r0, [r6, #-1290]	; 0xfffffaf6
    1d98:	050b0000 	streq	r0, [fp, #-0]
    1d9c:	00001506 	andeq	r1, r0, r6, lsl #10
    1da0:	11ef050c 	mvnne	r0, ip, lsl #10
    1da4:	050d0000 	streq	r0, [sp, #-0]
    1da8:	00001208 	andeq	r1, r0, r8, lsl #4
    1dac:	14f7050e 	ldrbtne	r0, [r7], #1294	; 0x50e
    1db0:	050f0000 	streq	r0, [pc, #-0]	; 1db8 <shift+0x1db8>
    1db4:	000016bb 			; <UNDEFINED> instruction: 0x000016bb
    1db8:	16380510 			; <UNDEFINED> instruction: 0x16380510
    1dbc:	05110000 	ldreq	r0, [r1, #-0]
    1dc0:	000016ac 	andeq	r1, r0, ip, lsr #13
    1dc4:	12b50512 	adcsne	r0, r5, #75497472	; 0x4800000
    1dc8:	05130000 	ldreq	r0, [r3, #-0]
    1dcc:	00001232 	andeq	r1, r0, r2, lsr r2
    1dd0:	11fc0514 	mvnsne	r0, r4, lsl r5
    1dd4:	05150000 	ldreq	r0, [r5, #-0]
    1dd8:	00001595 	muleq	r0, r5, r5
    1ddc:	12690516 	rsbne	r0, r9, #92274688	; 0x5800000
    1de0:	05170000 	ldreq	r0, [r7, #-0]
    1de4:	000011a4 	andeq	r1, r0, r4, lsr #3
    1de8:	169e0518 			; <UNDEFINED> instruction: 0x169e0518
    1dec:	05190000 	ldreq	r0, [r9, #-0]
    1df0:	000014d3 	ldrdeq	r1, [r0], -r3
    1df4:	15ad051a 	strne	r0, [sp, #1306]!	; 0x51a
    1df8:	051b0000 	ldreq	r0, [fp, #-0]
    1dfc:	0000123d 	andeq	r1, r0, sp, lsr r2
    1e00:	1449051c 	strbne	r0, [r9], #-1308	; 0xfffffae4
    1e04:	051d0000 	ldreq	r0, [sp, #-0]
    1e08:	00001398 	muleq	r0, r8, r3
    1e0c:	162a051e 			; <UNDEFINED> instruction: 0x162a051e
    1e10:	051f0000 	ldreq	r0, [pc, #-0]	; 1e18 <shift+0x1e18>
    1e14:	00001686 	andeq	r1, r0, r6, lsl #13
    1e18:	16c70520 	strbne	r0, [r7], r0, lsr #10
    1e1c:	05210000 	streq	r0, [r1, #-0]!
    1e20:	000016d5 	ldrdeq	r1, [r0], -r5
    1e24:	14ea0522 	strbtne	r0, [sl], #1314	; 0x522
    1e28:	05230000 	streq	r0, [r3, #-0]!
    1e2c:	0000140d 	andeq	r1, r0, sp, lsl #8
    1e30:	124c0524 	subne	r0, ip, #36, 10	; 0x9000000
    1e34:	05250000 	streq	r0, [r5, #-0]!
    1e38:	000014a0 	andeq	r1, r0, r0, lsr #9
    1e3c:	13b20526 			; <UNDEFINED> instruction: 0x13b20526
    1e40:	05270000 	streq	r0, [r7, #-0]!
    1e44:	00001655 	andeq	r1, r0, r5, asr r6
    1e48:	13c20528 	bicne	r0, r2, #40, 10	; 0xa000000
    1e4c:	05290000 	streq	r0, [r9, #-0]!
    1e50:	000013d1 	ldrdeq	r1, [r0], -r1	; <UNPREDICTABLE>
    1e54:	13e0052a 	mvnne	r0, #176160768	; 0xa800000
    1e58:	052b0000 	streq	r0, [fp, #-0]!
    1e5c:	000013ef 	andeq	r1, r0, pc, ror #7
    1e60:	137d052c 	cmnne	sp, #44, 10	; 0xb000000
    1e64:	052d0000 	streq	r0, [sp, #-0]!
    1e68:	000013fe 	strdeq	r1, [r0], -lr
    1e6c:	15e4052e 	strbne	r0, [r4, #1326]!	; 0x52e
    1e70:	052f0000 	streq	r0, [pc, #-0]!	; 1e78 <shift+0x1e78>
    1e74:	0000141c 	andeq	r1, r0, ip, lsl r4
    1e78:	142b0530 	strtne	r0, [fp], #-1328	; 0xfffffad0
    1e7c:	05310000 	ldreq	r0, [r1, #-0]!
    1e80:	000011dd 	ldrdeq	r1, [r0], -sp
    1e84:	15350532 	ldrne	r0, [r5, #-1330]!	; 0xffffface
    1e88:	05330000 	ldreq	r0, [r3, #-0]!
    1e8c:	00001545 	andeq	r1, r0, r5, asr #10
    1e90:	15550534 	ldrbne	r0, [r5, #-1332]	; 0xfffffacc
    1e94:	05350000 	ldreq	r0, [r5, #-0]!
    1e98:	0000136b 	andeq	r1, r0, fp, ror #6
    1e9c:	15650536 	strbne	r0, [r5, #-1334]!	; 0xfffffaca
    1ea0:	05370000 	ldreq	r0, [r7, #-0]!
    1ea4:	00001575 	andeq	r1, r0, r5, ror r5
    1ea8:	15850538 	strne	r0, [r5, #1336]	; 0x538
    1eac:	05390000 	ldreq	r0, [r9, #-0]!
    1eb0:	0000125c 	andeq	r1, r0, ip, asr r2
    1eb4:	1215053a 	andsne	r0, r5, #243269632	; 0xe800000
    1eb8:	053b0000 	ldreq	r0, [fp, #-0]!
    1ebc:	0000143a 	andeq	r1, r0, sl, lsr r4
    1ec0:	11b4053c 			; <UNDEFINED> instruction: 0x11b4053c
    1ec4:	053d0000 	ldreq	r0, [sp, #-0]!
    1ec8:	000015a0 	andeq	r1, r0, r0, lsr #11
    1ecc:	9c06003e 	stcls	0, cr0, [r6], {62}	; 0x3e
    1ed0:	02000012 	andeq	r0, r0, #18
    1ed4:	08026b02 	stmdaeq	r2, {r1, r8, r9, fp, sp, lr}
    1ed8:	00000215 	andeq	r0, r0, r5, lsl r2
    1edc:	00145f07 	andseq	r5, r4, r7, lsl #30
    1ee0:	02700200 	rsbseq	r0, r0, #0, 4
    1ee4:	00005d14 	andeq	r5, r0, r4, lsl sp
    1ee8:	78070000 	stmdavc	r7, {}	; <UNPREDICTABLE>
    1eec:	02000013 	andeq	r0, r0, #19
    1ef0:	5d140271 	lfmpl	f0, 4, [r4, #-452]	; 0xfffffe3c
    1ef4:	01000000 	mrseq	r0, (UNDEF: 0)
    1ef8:	01ea0800 	mvneq	r0, r0, lsl #16
    1efc:	15090000 	strne	r0, [r9, #-0]
    1f00:	2a000002 	bcs	1f10 <shift+0x1f10>
    1f04:	0a000002 	beq	1f14 <shift+0x1f14>
    1f08:	0000002c 	andeq	r0, r0, ip, lsr #32
    1f0c:	1a080011 	bne	201f58 <__bss_end+0x1f84d8>
    1f10:	0b000002 	bleq	1f20 <shift+0x1f20>
    1f14:	00001523 	andeq	r1, r0, r3, lsr #10
    1f18:	26027402 	strcs	r7, [r2], -r2, lsl #8
    1f1c:	0000022a 	andeq	r0, r0, sl, lsr #4
    1f20:	0a3d3a24 	beq	f507b8 <__bss_end+0xf46d38>
    1f24:	243d0f3d 	ldrtcs	r0, [sp], #-3901	; 0xfffff0c3
    1f28:	023d323d 	eorseq	r3, sp, #-805306365	; 0xd0000003
    1f2c:	133d053d 	teqne	sp, #255852544	; 0xf400000
    1f30:	0c3d0d3d 	ldceq	13, cr0, [sp], #-244	; 0xffffff0c
    1f34:	113d233d 	teqne	sp, sp, lsr r3
    1f38:	013d263d 	teqeq	sp, sp, lsr r6
    1f3c:	083d173d 	ldmdaeq	sp!, {r0, r2, r3, r4, r5, r8, r9, sl, ip}
    1f40:	003d093d 	eorseq	r0, sp, sp, lsr r9
    1f44:	07020200 	streq	r0, [r2, -r0, lsl #4]
    1f48:	00000337 	andeq	r0, r0, r7, lsr r3
    1f4c:	e8080102 	stmda	r8, {r1, r8}
    1f50:	02000003 	andeq	r0, r0, #3
    1f54:	043e0502 	ldrteq	r0, [lr], #-1282	; 0xfffffafe
    1f58:	4b0c0000 	blmi	301f60 <__bss_end+0x2f84e0>
    1f5c:	03000017 	movweq	r0, #23
    1f60:	002c1681 	eoreq	r1, ip, r1, lsl #13
    1f64:	76080000 	strvc	r0, [r8], -r0
    1f68:	0c000002 	stceq	0, cr0, [r0], {2}
    1f6c:	00001753 	andeq	r1, r0, r3, asr r7
    1f70:	93168503 	tstls	r6, #12582912	; 0xc00000
    1f74:	02000002 	andeq	r0, r0, #2
    1f78:	14bc0708 	ldrtne	r0, [ip], #1800	; 0x708
    1f7c:	250c0000 	strcs	r0, [ip, #-0]
    1f80:	03000017 	movweq	r0, #23
    1f84:	00331093 	mlaseq	r3, r3, r0, r1
    1f88:	08020000 	stmdaeq	r2, {}	; <UNPREDICTABLE>
    1f8c:	0011c503 	andseq	ip, r1, r3, lsl #10
    1f90:	17440c00 	strbne	r0, [r4, -r0, lsl #24]
    1f94:	97030000 	strls	r0, [r3, -r0]
    1f98:	00002510 	andeq	r2, r0, r0, lsl r5
    1f9c:	02ad0800 	adceq	r0, sp, #0, 16
    1fa0:	10020000 	andne	r0, r2, r0
    1fa4:	0015c703 	andseq	ip, r5, r3, lsl #14
    1fa8:	17180d00 	ldrne	r0, [r8, -r0, lsl #26]
    1fac:	b9010000 	stmdblt	r1, {}	; <UNPREDICTABLE>
    1fb0:	02870105 	addeq	r0, r7, #1073741825	; 0x40000001
    1fb4:	98900000 	ldmls	r0, {}	; <UNPREDICTABLE>
    1fb8:	00400000 	subeq	r0, r0, r0
    1fbc:	9c010000 	stcls	0, cr0, [r1], {-0}
    1fc0:	0100610e 	tsteq	r0, lr, lsl #2
    1fc4:	9a1605b9 	bls	5836b0 <__bss_end+0x579c30>
    1fc8:	4a000002 	bmi	1fd8 <shift+0x1fd8>
    1fcc:	46000000 	strmi	r0, [r0], -r0
    1fd0:	0f000000 	svceq	0x00000000
    1fd4:	00616664 	rsbeq	r6, r1, r4, ror #12
    1fd8:	1005bf01 	andne	fp, r5, r1, lsl #30
    1fdc:	000002b9 			; <UNDEFINED> instruction: 0x000002b9
    1fe0:	00000073 	andeq	r0, r0, r3, ror r0
    1fe4:	0000006d 	andeq	r0, r0, sp, rrx
    1fe8:	0069680f 	rsbeq	r6, r9, pc, lsl #16
    1fec:	1005c401 	andne	ip, r5, r1, lsl #8
    1ff0:	00000282 	andeq	r0, r0, r2, lsl #5
    1ff4:	000000b1 	strheq	r0, [r0], -r1
    1ff8:	000000af 	andeq	r0, r0, pc, lsr #1
    1ffc:	006f6c0f 	rsbeq	r6, pc, pc, lsl #24
    2000:	1005c901 	andne	ip, r5, r1, lsl #18
    2004:	00000282 	andeq	r0, r0, r2, lsl #5
    2008:	000000cb 	andeq	r0, r0, fp, asr #1
    200c:	000000c5 	andeq	r0, r0, r5, asr #1
    2010:	03800000 	orreq	r0, r0, #0
    2014:	00040000 	andeq	r0, r4, r0
    2018:	00000966 	andeq	r0, r0, r6, ror #18
    201c:	175b0104 	ldrbne	r0, [fp, -r4, lsl #2]
    2020:	7d0c0000 	stcvc	0, cr0, [ip, #-0]
    2024:	d3000014 	movwle	r0, #20
    2028:	d0000010 	andle	r0, r0, r0, lsl r0
    202c:	20000098 	mulcs	r0, r8, r0
    2030:	d5000001 	strle	r0, [r0, #-1]
    2034:	0200000e 	andeq	r0, r0, #14
    2038:	14bc0708 	ldrtne	r0, [ip], #1800	; 0x708
    203c:	04030000 	streq	r0, [r3], #-0
    2040:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
    2044:	07040200 	streq	r0, [r4, -r0, lsl #4]
    2048:	000014c6 	andeq	r1, r0, r6, asr #9
    204c:	43050802 	movwmi	r0, #22530	; 0x5802
    2050:	02000002 	andeq	r0, r0, #2
    2054:	14710408 	ldrbtne	r0, [r1], #-1032	; 0xfffffbf8
    2058:	01020000 	mrseq	r0, (UNDEF: 2)
    205c:	0003df08 	andeq	sp, r3, r8, lsl #30
    2060:	06010200 	streq	r0, [r1], -r0, lsl #4
    2064:	000003e1 	andeq	r0, r0, r1, ror #7
    2068:	00164904 	andseq	r4, r6, r4, lsl #18
    206c:	48010700 	stmdami	r1, {r8, r9, sl}
    2070:	02000000 	andeq	r0, r0, #0
    2074:	01e30617 	mvneq	r0, r7, lsl r6
    2078:	d3050000 	movwle	r0, #20480	; 0x5000
    207c:	00000011 	andeq	r0, r0, r1, lsl r0
    2080:	0016f805 	andseq	pc, r6, r5, lsl #16
    2084:	a6050100 	strge	r0, [r5], -r0, lsl #2
    2088:	02000013 	andeq	r0, r0, #19
    208c:	00146405 	andseq	r6, r4, r5, lsl #8
    2090:	62050300 	andvs	r0, r5, #0, 6
    2094:	04000016 	streq	r0, [r0], #-22	; 0xffffffea
    2098:	00170805 	andseq	r0, r7, r5, lsl #16
    209c:	78050500 	stmdavc	r5, {r8, sl}
    20a0:	06000016 			; <UNDEFINED> instruction: 0x06000016
    20a4:	0014ad05 	andseq	sl, r4, r5, lsl #26
    20a8:	f3050700 	vabd.u8	d0, d5, d0
    20ac:	08000015 	stmdaeq	r0, {r0, r2, r4}
    20b0:	00160105 	andseq	r0, r6, r5, lsl #2
    20b4:	0f050900 	svceq	0x00050900
    20b8:	0a000016 	beq	2118 <shift+0x2118>
    20bc:	00151605 	andseq	r1, r5, r5, lsl #12
    20c0:	06050b00 	streq	r0, [r5], -r0, lsl #22
    20c4:	0c000015 	stceq	0, cr0, [r0], {21}
    20c8:	0011ef05 	andseq	lr, r1, r5, lsl #30
    20cc:	08050d00 	stmdaeq	r5, {r8, sl, fp}
    20d0:	0e000012 	mcreq	0, 0, r0, cr0, cr2, {0}
    20d4:	0014f705 	andseq	pc, r4, r5, lsl #14
    20d8:	bb050f00 	bllt	145ce0 <__bss_end+0x13c260>
    20dc:	10000016 	andne	r0, r0, r6, lsl r0
    20e0:	00163805 	andseq	r3, r6, r5, lsl #16
    20e4:	ac051100 	stfges	f1, [r5], {-0}
    20e8:	12000016 	andne	r0, r0, #22
    20ec:	0012b505 	andseq	fp, r2, r5, lsl #10
    20f0:	32051300 	andcc	r1, r5, #0, 6
    20f4:	14000012 	strne	r0, [r0], #-18	; 0xffffffee
    20f8:	0011fc05 	andseq	pc, r1, r5, lsl #24
    20fc:	95051500 	strls	r1, [r5, #-1280]	; 0xfffffb00
    2100:	16000015 			; <UNDEFINED> instruction: 0x16000015
    2104:	00126905 	andseq	r6, r2, r5, lsl #18
    2108:	a4051700 	strge	r1, [r5], #-1792	; 0xfffff900
    210c:	18000011 	stmdane	r0, {r0, r4}
    2110:	00169e05 	andseq	r9, r6, r5, lsl #28
    2114:	d3051900 	movwle	r1, #22784	; 0x5900
    2118:	1a000014 	bne	2170 <shift+0x2170>
    211c:	0015ad05 	andseq	sl, r5, r5, lsl #26
    2120:	3d051b00 	vstrcc	d1, [r5, #-0]
    2124:	1c000012 	stcne	0, cr0, [r0], {18}
    2128:	00144905 	andseq	r4, r4, r5, lsl #18
    212c:	98051d00 	stmdals	r5, {r8, sl, fp, ip}
    2130:	1e000013 	mcrne	0, 0, r0, cr0, cr3, {0}
    2134:	00162a05 	andseq	r2, r6, r5, lsl #20
    2138:	86051f00 	strhi	r1, [r5], -r0, lsl #30
    213c:	20000016 	andcs	r0, r0, r6, lsl r0
    2140:	0016c705 	andseq	ip, r6, r5, lsl #14
    2144:	d5052100 	strle	r2, [r5, #-256]	; 0xffffff00
    2148:	22000016 	andcs	r0, r0, #22
    214c:	0014ea05 	andseq	lr, r4, r5, lsl #20
    2150:	0d052300 	stceq	3, cr2, [r5, #-0]
    2154:	24000014 	strcs	r0, [r0], #-20	; 0xffffffec
    2158:	00124c05 	andseq	r4, r2, r5, lsl #24
    215c:	a0052500 	andge	r2, r5, r0, lsl #10
    2160:	26000014 			; <UNDEFINED> instruction: 0x26000014
    2164:	0013b205 	andseq	fp, r3, r5, lsl #4
    2168:	55052700 	strpl	r2, [r5, #-1792]	; 0xfffff900
    216c:	28000016 	stmdacs	r0, {r1, r2, r4}
    2170:	0013c205 	andseq	ip, r3, r5, lsl #4
    2174:	d1052900 	tstle	r5, r0, lsl #18
    2178:	2a000013 	bcs	21cc <shift+0x21cc>
    217c:	0013e005 	andseq	lr, r3, r5
    2180:	ef052b00 	svc	0x00052b00
    2184:	2c000013 	stccs	0, cr0, [r0], {19}
    2188:	00137d05 	andseq	r7, r3, r5, lsl #26
    218c:	fe052d00 	vdot.bf16	d2, d5, d0[0]
    2190:	2e000013 	mcrcs	0, 0, r0, cr0, cr3, {0}
    2194:	0015e405 	andseq	lr, r5, r5, lsl #8
    2198:	1c052f00 	stcne	15, cr2, [r5], {-0}
    219c:	30000014 	andcc	r0, r0, r4, lsl r0
    21a0:	00142b05 	andseq	r2, r4, r5, lsl #22
    21a4:	dd053100 	stfles	f3, [r5, #-0]
    21a8:	32000011 	andcc	r0, r0, #17
    21ac:	00153505 	andseq	r3, r5, r5, lsl #10
    21b0:	45053300 	strmi	r3, [r5, #-768]	; 0xfffffd00
    21b4:	34000015 	strcc	r0, [r0], #-21	; 0xffffffeb
    21b8:	00155505 	andseq	r5, r5, r5, lsl #10
    21bc:	6b053500 	blvs	14f5c4 <__bss_end+0x145b44>
    21c0:	36000013 			; <UNDEFINED> instruction: 0x36000013
    21c4:	00156505 	andseq	r6, r5, r5, lsl #10
    21c8:	75053700 	strvc	r3, [r5, #-1792]	; 0xfffff900
    21cc:	38000015 	stmdacc	r0, {r0, r2, r4}
    21d0:	00158505 	andseq	r8, r5, r5, lsl #10
    21d4:	5c053900 			; <UNDEFINED> instruction: 0x5c053900
    21d8:	3a000012 	bcc	2228 <shift+0x2228>
    21dc:	00121505 	andseq	r1, r2, r5, lsl #10
    21e0:	3a053b00 	bcc	150de8 <__bss_end+0x147368>
    21e4:	3c000014 	stccc	0, cr0, [r0], {20}
    21e8:	0011b405 	andseq	fp, r1, r5, lsl #8
    21ec:	a0053d00 	andge	r3, r5, r0, lsl #26
    21f0:	3e000015 	mcrcc	0, 0, r0, cr0, cr5, {0}
    21f4:	129c0600 	addsne	r0, ip, #0, 12
    21f8:	02020000 	andeq	r0, r2, #0
    21fc:	0e08026b 	cdpeq	2, 0, cr0, cr8, cr11, {3}
    2200:	07000002 	streq	r0, [r0, -r2]
    2204:	0000145f 	andeq	r1, r0, pc, asr r4
    2208:	14027002 	strne	r7, [r2], #-2
    220c:	00000056 	andeq	r0, r0, r6, asr r0
    2210:	13780700 	cmnne	r8, #0, 14
    2214:	71020000 	mrsvc	r0, (UNDEF: 2)
    2218:	00561402 	subseq	r1, r6, r2, lsl #8
    221c:	00010000 	andeq	r0, r1, r0
    2220:	0001e308 	andeq	lr, r1, r8, lsl #6
    2224:	020e0900 	andeq	r0, lr, #0, 18
    2228:	02230000 	eoreq	r0, r3, #0
    222c:	330a0000 	movwcc	r0, #40960	; 0xa000
    2230:	11000000 	mrsne	r0, (UNDEF: 0)
    2234:	02130800 	andseq	r0, r3, #0, 16
    2238:	230b0000 	movwcs	r0, #45056	; 0xb000
    223c:	02000015 	andeq	r0, r0, #21
    2240:	23260274 			; <UNDEFINED> instruction: 0x23260274
    2244:	24000002 	strcs	r0, [r0], #-2
    2248:	3d0a3d3a 	stccc	13, cr3, [sl, #-232]	; 0xffffff18
    224c:	3d243d0f 	stccc	13, cr3, [r4, #-60]!	; 0xffffffc4
    2250:	3d023d32 	stccc	13, cr3, [r2, #-200]	; 0xffffff38
    2254:	3d133d05 	ldccc	13, cr3, [r3, #-20]	; 0xffffffec
    2258:	3d0c3d0d 	stccc	13, cr3, [ip, #-52]	; 0xffffffcc
    225c:	3d113d23 	ldccc	13, cr3, [r1, #-140]	; 0xffffff74
    2260:	3d013d26 	stccc	13, cr3, [r1, #-152]	; 0xffffff68
    2264:	3d083d17 	stccc	13, cr3, [r8, #-92]	; 0xffffffa4
    2268:	00003d09 	andeq	r3, r0, r9, lsl #26
    226c:	37070202 	strcc	r0, [r7, -r2, lsl #4]
    2270:	02000003 	andeq	r0, r0, #3
    2274:	03e80801 	mvneq	r0, #65536	; 0x10000
    2278:	02020000 	andeq	r0, r2, #0
    227c:	00043e05 	andeq	r3, r4, r5, lsl #28
    2280:	174b0c00 	strbne	r0, [fp, -r0, lsl #24]
    2284:	81030000 	mrshi	r0, (UNDEF: 3)
    2288:	00003316 	andeq	r3, r0, r6, lsl r3
    228c:	17530c00 	ldrbne	r0, [r3, -r0, lsl #24]
    2290:	85030000 	strhi	r0, [r3, #-0]
    2294:	00002516 	andeq	r2, r0, r6, lsl r5
    2298:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
    229c:	000011cd 	andeq	r1, r0, sp, asr #3
    22a0:	c5030802 	strgt	r0, [r3, #-2050]	; 0xfffff7fe
    22a4:	02000011 	andeq	r0, r0, #17
    22a8:	14760408 	ldrbtne	r0, [r6], #-1032	; 0xfffffbf8
    22ac:	10020000 	andne	r0, r2, r0
    22b0:	0015c703 	andseq	ip, r5, r3, lsl #14
    22b4:	180f0d00 	stmdane	pc, {r8, sl, fp}	; <UNPREDICTABLE>
    22b8:	b3010000 	movwlt	r0, #4096	; 0x1000
    22bc:	027b0103 	rsbseq	r0, fp, #-1073741824	; 0xc0000000
    22c0:	98d00000 	ldmls	r0, {}^	; <UNPREDICTABLE>
    22c4:	01200000 			; <UNDEFINED> instruction: 0x01200000
    22c8:	9c010000 	stcls	0, cr0, [r1], {-0}
    22cc:	0000037d 	andeq	r0, r0, sp, ror r3
    22d0:	01006e0e 	tsteq	r0, lr, lsl #28
    22d4:	7b1703b3 	blvc	5c31a8 <__bss_end+0x5b9728>
    22d8:	49000002 	stmdbmi	r0, {r1}
    22dc:	45000001 	strmi	r0, [r0, #-1]
    22e0:	0e000001 	cdpeq	0, 0, cr0, cr0, cr1, {0}
    22e4:	b3010064 	movwlt	r0, #4196	; 0x1064
    22e8:	027b2203 	rsbseq	r2, fp, #805306368	; 0x30000000
    22ec:	01750000 	cmneq	r5, r0
    22f0:	01710000 	cmneq	r1, r0
    22f4:	720f0000 	andvc	r0, pc, #0
    22f8:	b3010070 	movwlt	r0, #4208	; 0x1070
    22fc:	037d2e03 	cmneq	sp, #3, 28	; 0x30
    2300:	91020000 	mrsls	r0, (UNDEF: 2)
    2304:	00711000 	rsbseq	r1, r1, r0
    2308:	0b03b501 	bleq	ef714 <__bss_end+0xe5c94>
    230c:	0000027b 	andeq	r0, r0, fp, ror r2
    2310:	000001a5 	andeq	r0, r0, r5, lsr #3
    2314:	0000019d 	muleq	r0, sp, r1
    2318:	01007210 	tsteq	r0, r0, lsl r2
    231c:	7b1203b5 	blvc	4831f8 <__bss_end+0x479778>
    2320:	fb000002 	blx	2332 <shift+0x2332>
    2324:	f1000001 	cps	#1
    2328:	10000001 	andne	r0, r0, r1
    232c:	b5010079 	strlt	r0, [r1, #-121]	; 0xffffff87
    2330:	027b1903 	rsbseq	r1, fp, #49152	; 0xc000
    2334:	02590000 	subseq	r0, r9, #0
    2338:	02530000 	subseq	r0, r3, #0
    233c:	6c100000 	ldcvs	0, cr0, [r0], {-0}
    2340:	0100317a 	tsteq	r0, sl, ror r1
    2344:	6f0a03b6 	svcvs	0x000a03b6
    2348:	93000002 	movwls	r0, #2
    234c:	91000002 	tstls	r0, r2
    2350:	10000002 	andne	r0, r0, r2
    2354:	00327a6c 	eorseq	r7, r2, ip, ror #20
    2358:	0f03b601 	svceq	0x0003b601
    235c:	0000026f 	andeq	r0, r0, pc, ror #4
    2360:	000002aa 	andeq	r0, r0, sl, lsr #5
    2364:	000002a8 	andeq	r0, r0, r8, lsr #5
    2368:	01006910 	tsteq	r0, r0, lsl r9
    236c:	6f1403b6 	svcvs	0x001403b6
    2370:	c9000002 	stmdbgt	r0, {r1}
    2374:	bd000002 	stclt	0, cr0, [r0, #-8]
    2378:	10000002 	andne	r0, r0, r2
    237c:	b601006b 	strlt	r0, [r1], -fp, rrx
    2380:	026f1703 	rsbeq	r1, pc, #786432	; 0xc0000
    2384:	031b0000 	tsteq	fp, #0
    2388:	03170000 	tsteq	r7, #0
    238c:	11000000 	mrsne	r0, (UNDEF: 0)
    2390:	00027b04 	andeq	r7, r2, r4, lsl #22
	...

Disassembly of section .debug_abbrev:

00000000 <.debug_abbrev>:
   0:	10001101 	andne	r1, r0, r1, lsl #2
   4:	12011106 	andne	r1, r1, #-2147483647	; 0x80000001
   8:	1b0e0301 	blne	380c14 <__bss_end+0x377194>
   c:	130e250e 	movwne	r2, #58638	; 0xe50e
  10:	00000005 	andeq	r0, r0, r5
  14:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
  18:	030b130e 	movweq	r1, #45838	; 0xb30e
  1c:	110e1b0e 	tstne	lr, lr, lsl #22
  20:	10061201 	andne	r1, r6, r1, lsl #4
  24:	02000017 	andeq	r0, r0, #23
  28:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
  2c:	0b3b0b3a 	bleq	ec2d1c <__bss_end+0xeb929c>
  30:	13490b39 	movtne	r0, #39737	; 0x9b39
  34:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
  38:	24030000 	strcs	r0, [r3], #-0
  3c:	3e0b0b00 	vmlacc.f64	d0, d11, d0
  40:	000e030b 	andeq	r0, lr, fp, lsl #6
  44:	012e0400 			; <UNDEFINED> instruction: 0x012e0400
  48:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
  4c:	0b3b0b3a 	bleq	ec2d3c <__bss_end+0xeb92bc>
  50:	01110b39 	tsteq	r1, r9, lsr fp
  54:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
  58:	01194296 			; <UNDEFINED> instruction: 0x01194296
  5c:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
  60:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
  64:	0b3b0b3a 	bleq	ec2d54 <__bss_end+0xeb92d4>
  68:	13490b39 	movtne	r0, #39737	; 0x9b39
  6c:	00001802 	andeq	r1, r0, r2, lsl #16
  70:	0b002406 	bleq	9090 <_Z4ftoafPc+0x8c>
  74:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
  78:	07000008 	streq	r0, [r0, -r8]
  7c:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
  80:	0b3a0e03 	bleq	e83894 <__bss_end+0xe79e14>
  84:	0b390b3b 	bleq	e42d78 <__bss_end+0xe392f8>
  88:	06120111 			; <UNDEFINED> instruction: 0x06120111
  8c:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
  90:	00130119 	andseq	r0, r3, r9, lsl r1
  94:	010b0800 	tsteq	fp, r0, lsl #16
  98:	06120111 			; <UNDEFINED> instruction: 0x06120111
  9c:	34090000 	strcc	r0, [r9], #-0
  a0:	3a080300 	bcc	200ca8 <__bss_end+0x1f7228>
  a4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
  a8:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
  ac:	0a000018 	beq	114 <shift+0x114>
  b0:	0b0b000f 	bleq	2c00f4 <__bss_end+0x2b6674>
  b4:	00001349 	andeq	r1, r0, r9, asr #6
  b8:	01110100 	tsteq	r1, r0, lsl #2
  bc:	0b130e25 	bleq	4c3958 <__bss_end+0x4b9ed8>
  c0:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
  c4:	06120111 			; <UNDEFINED> instruction: 0x06120111
  c8:	00001710 	andeq	r1, r0, r0, lsl r7
  cc:	03001602 	movweq	r1, #1538	; 0x602
  d0:	3b0b3a0e 	blcc	2ce910 <__bss_end+0x2c4e90>
  d4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
  d8:	03000013 	movweq	r0, #19
  dc:	0b0b000f 	bleq	2c0120 <__bss_end+0x2b66a0>
  e0:	00001349 	andeq	r1, r0, r9, asr #6
  e4:	00001504 	andeq	r1, r0, r4, lsl #10
  e8:	01010500 	tsteq	r1, r0, lsl #10
  ec:	13011349 	movwne	r1, #4937	; 0x1349
  f0:	21060000 	mrscs	r0, (UNDEF: 6)
  f4:	2f134900 	svccs	0x00134900
  f8:	07000006 	streq	r0, [r0, -r6]
  fc:	0b0b0024 	bleq	2c0194 <__bss_end+0x2b6714>
 100:	0e030b3e 	vmoveq.16	d3[0], r0
 104:	34080000 	strcc	r0, [r8], #-0
 108:	3a0e0300 	bcc	380d10 <__bss_end+0x377290>
 10c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 110:	3f13490b 	svccc	0x0013490b
 114:	00193c19 	andseq	r3, r9, r9, lsl ip
 118:	012e0900 			; <UNDEFINED> instruction: 0x012e0900
 11c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 120:	0b3b0b3a 	bleq	ec2e10 <__bss_end+0xeb9390>
 124:	13490b39 	movtne	r0, #39737	; 0x9b39
 128:	06120111 			; <UNDEFINED> instruction: 0x06120111
 12c:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 130:	00130119 	andseq	r0, r3, r9, lsl r1
 134:	00340a00 	eorseq	r0, r4, r0, lsl #20
 138:	0b3a0e03 	bleq	e8394c <__bss_end+0xe79ecc>
 13c:	0b390b3b 	bleq	e42e30 <__bss_end+0xe393b0>
 140:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 144:	240b0000 	strcs	r0, [fp], #-0
 148:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 14c:	0008030b 	andeq	r0, r8, fp, lsl #6
 150:	002e0c00 	eoreq	r0, lr, r0, lsl #24
 154:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 158:	0b3b0b3a 	bleq	ec2e48 <__bss_end+0xeb93c8>
 15c:	01110b39 	tsteq	r1, r9, lsr fp
 160:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 164:	00194297 	mulseq	r9, r7, r2
 168:	01390d00 	teqeq	r9, r0, lsl #26
 16c:	0b3a0e03 	bleq	e83980 <__bss_end+0xe79f00>
 170:	13010b3b 	movwne	r0, #6971	; 0x1b3b
 174:	2e0e0000 	cdpcs	0, 0, cr0, cr14, cr0, {0}
 178:	03193f01 	tsteq	r9, #1, 30
 17c:	3b0b3a0e 	blcc	2ce9bc <__bss_end+0x2c4f3c>
 180:	3c0b390b 			; <UNDEFINED> instruction: 0x3c0b390b
 184:	00130119 	andseq	r0, r3, r9, lsl r1
 188:	00050f00 	andeq	r0, r5, r0, lsl #30
 18c:	00001349 	andeq	r1, r0, r9, asr #6
 190:	3f012e10 	svccc	0x00012e10
 194:	3a0e0319 	bcc	380e00 <__bss_end+0x377380>
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
 1c0:	3a080300 	bcc	200dc8 <__bss_end+0x1f7348>
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
 1f4:	0b0b0024 	bleq	2c028c <__bss_end+0x2b680c>
 1f8:	0e030b3e 	vmoveq.16	d3[0], r0
 1fc:	24030000 	strcs	r0, [r3], #-0
 200:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 204:	0008030b 	andeq	r0, r8, fp, lsl #6
 208:	00160400 	andseq	r0, r6, r0, lsl #8
 20c:	0b3a0e03 	bleq	e83a20 <__bss_end+0xe79fa0>
 210:	0b390b3b 	bleq	e42f04 <__bss_end+0xe39484>
 214:	00001349 	andeq	r1, r0, r9, asr #6
 218:	49002605 	stmdbmi	r0, {r0, r2, r9, sl, sp}
 21c:	06000013 			; <UNDEFINED> instruction: 0x06000013
 220:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 224:	0b3b0b3a 	bleq	ec2f14 <__bss_end+0xeb9494>
 228:	13490b39 	movtne	r0, #39737	; 0x9b39
 22c:	1802196c 	stmdane	r2, {r2, r3, r5, r6, r8, fp, ip}
 230:	2e070000 	cdpcs	0, 0, cr0, cr7, cr0, {0}
 234:	03193f01 	tsteq	r9, #1, 30
 238:	3b0b3a0e 	blcc	2cea78 <__bss_end+0x2c4ff8>
 23c:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 240:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
 244:	96184006 	ldrls	r4, [r8], -r6
 248:	13011942 	movwne	r1, #6466	; 0x1942
 24c:	05080000 	streq	r0, [r8, #-0]
 250:	3a0e0300 	bcc	380e58 <__bss_end+0x3773d8>
 254:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 258:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 25c:	09000018 	stmdbeq	r0, {r3, r4}
 260:	0b0b000f 	bleq	2c02a4 <__bss_end+0x2b6824>
 264:	00001349 	andeq	r1, r0, r9, asr #6
 268:	01110100 	tsteq	r1, r0, lsl #2
 26c:	0b130e25 	bleq	4c3b08 <__bss_end+0x4ba088>
 270:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
 274:	06120111 			; <UNDEFINED> instruction: 0x06120111
 278:	00001710 	andeq	r1, r0, r0, lsl r7
 27c:	0b002402 	bleq	928c <_Z4ftoafPc+0x288>
 280:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 284:	0300000e 	movweq	r0, #14
 288:	13490026 	movtne	r0, #36902	; 0x9026
 28c:	24040000 	strcs	r0, [r4], #-0
 290:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 294:	0008030b 	andeq	r0, r8, fp, lsl #6
 298:	00160500 	andseq	r0, r6, r0, lsl #10
 29c:	0b3a0e03 	bleq	e83ab0 <__bss_end+0xe7a030>
 2a0:	0b390b3b 	bleq	e42f94 <__bss_end+0xe39514>
 2a4:	00001349 	andeq	r1, r0, r9, asr #6
 2a8:	03011306 	movweq	r1, #4870	; 0x1306
 2ac:	3a0b0b0e 	bcc	2c2eec <__bss_end+0x2b946c>
 2b0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 2b4:	0013010b 	andseq	r0, r3, fp, lsl #2
 2b8:	000d0700 	andeq	r0, sp, r0, lsl #14
 2bc:	0b3a0803 	bleq	e822d0 <__bss_end+0xe78850>
 2c0:	0b390b3b 	bleq	e42fb4 <__bss_end+0xe39534>
 2c4:	0b381349 	bleq	e04ff0 <__bss_end+0xdfb570>
 2c8:	04080000 	streq	r0, [r8], #-0
 2cc:	6d0e0301 	stcvs	3, cr0, [lr, #-4]
 2d0:	0b0b3e19 	bleq	2cfb3c <__bss_end+0x2c60bc>
 2d4:	3a13490b 	bcc	4d2708 <__bss_end+0x4c8c88>
 2d8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 2dc:	0013010b 	andseq	r0, r3, fp, lsl #2
 2e0:	00280900 	eoreq	r0, r8, r0, lsl #18
 2e4:	0b1c0803 	bleq	7022f8 <__bss_end+0x6f8878>
 2e8:	280a0000 	stmdacs	sl, {}	; <UNPREDICTABLE>
 2ec:	1c0e0300 	stcne	3, cr0, [lr], {-0}
 2f0:	0b00000b 	bleq	324 <shift+0x324>
 2f4:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 2f8:	0b3b0b3a 	bleq	ec2fe8 <__bss_end+0xeb9568>
 2fc:	13490b39 	movtne	r0, #39737	; 0x9b39
 300:	1802196c 	stmdane	r2, {r2, r3, r5, r6, r8, fp, ip}
 304:	020c0000 	andeq	r0, ip, #0
 308:	3c0e0300 	stccc	3, cr0, [lr], {-0}
 30c:	0d000019 	stceq	0, cr0, [r0, #-100]	; 0xffffff9c
 310:	0b0b000f 	bleq	2c0354 <__bss_end+0x2b68d4>
 314:	00001349 	andeq	r1, r0, r9, asr #6
 318:	03000d0e 	movweq	r0, #3342	; 0xd0e
 31c:	3b0b3a0e 	blcc	2ceb5c <__bss_end+0x2c50dc>
 320:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 324:	000b3813 	andeq	r3, fp, r3, lsl r8
 328:	01010f00 	tsteq	r1, r0, lsl #30
 32c:	13011349 	movwne	r1, #4937	; 0x1349
 330:	21100000 	tstcs	r0, r0
 334:	2f134900 	svccs	0x00134900
 338:	1100000b 	tstne	r0, fp
 33c:	0e030102 	adfeqs	f0, f3, f2
 340:	0b3a0b0b 	bleq	e82f74 <__bss_end+0xe794f4>
 344:	0b390b3b 	bleq	e43038 <__bss_end+0xe395b8>
 348:	00001301 	andeq	r1, r0, r1, lsl #6
 34c:	3f012e12 	svccc	0x00012e12
 350:	3a0e0319 	bcc	380fbc <__bss_end+0x37753c>
 354:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 358:	3c0e6e0b 	stccc	14, cr6, [lr], {11}
 35c:	01136419 	tsteq	r3, r9, lsl r4
 360:	13000013 	movwne	r0, #19
 364:	13490005 	movtne	r0, #36869	; 0x9005
 368:	00001934 	andeq	r1, r0, r4, lsr r9
 36c:	49000514 	stmdbmi	r0, {r2, r4, r8, sl}
 370:	15000013 	strne	r0, [r0, #-19]	; 0xffffffed
 374:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 378:	0b3a0e03 	bleq	e83b8c <__bss_end+0xe7a10c>
 37c:	0b390b3b 	bleq	e43070 <__bss_end+0xe395f0>
 380:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 384:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 388:	00001301 	andeq	r1, r0, r1, lsl #6
 38c:	3f012e16 	svccc	0x00012e16
 390:	3a0e0319 	bcc	380ffc <__bss_end+0x37757c>
 394:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 398:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 39c:	3c0b3213 	sfmcc	f3, 4, [fp], {19}
 3a0:	01136419 	tsteq	r3, r9, lsl r4
 3a4:	17000013 	smladne	r0, r3, r0, r0
 3a8:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
 3ac:	0b3b0b3a 	bleq	ec309c <__bss_end+0xeb961c>
 3b0:	13490b39 	movtne	r0, #39737	; 0x9b39
 3b4:	0b320b38 	bleq	c8309c <__bss_end+0xc7961c>
 3b8:	2e180000 	cdpcs	0, 1, cr0, cr8, cr0, {0}
 3bc:	03193f01 	tsteq	r9, #1, 30
 3c0:	3b0b3a0e 	blcc	2cec00 <__bss_end+0x2c5180>
 3c4:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 3c8:	3c0b320e 	sfmcc	f3, 4, [fp], {14}
 3cc:	01136419 	tsteq	r3, r9, lsl r4
 3d0:	19000013 	stmdbne	r0, {r0, r1, r4}
 3d4:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 3d8:	0b3a0e03 	bleq	e83bec <__bss_end+0xe7a16c>
 3dc:	0b390b3b 	bleq	e430d0 <__bss_end+0xe39650>
 3e0:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 3e4:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 3e8:	00001364 	andeq	r1, r0, r4, ror #6
 3ec:	4901151a 	stmdbmi	r1, {r1, r3, r4, r8, sl, ip}
 3f0:	01136413 	tsteq	r3, r3, lsl r4
 3f4:	1b000013 	blne	448 <shift+0x448>
 3f8:	131d001f 	tstne	sp, #31
 3fc:	00001349 	andeq	r1, r0, r9, asr #6
 400:	0b00101c 	bleq	4478 <shift+0x4478>
 404:	0013490b 	andseq	r4, r3, fp, lsl #18
 408:	000f1d00 	andeq	r1, pc, r0, lsl #26
 40c:	00000b0b 	andeq	r0, r0, fp, lsl #22
 410:	0300341e 	movweq	r3, #1054	; 0x41e
 414:	3b0b3a0e 	blcc	2cec54 <__bss_end+0x2c51d4>
 418:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 41c:	00180213 	andseq	r0, r8, r3, lsl r2
 420:	012e1f00 			; <UNDEFINED> instruction: 0x012e1f00
 424:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 428:	0b3b0b3a 	bleq	ec3118 <__bss_end+0xeb9698>
 42c:	0e6e0b39 	vmoveq.8	d14[5], r0
 430:	01111349 	tsteq	r1, r9, asr #6
 434:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 438:	01194296 			; <UNDEFINED> instruction: 0x01194296
 43c:	20000013 	andcs	r0, r0, r3, lsl r0
 440:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
 444:	0b3b0b3a 	bleq	ec3134 <__bss_end+0xeb96b4>
 448:	13490b39 	movtne	r0, #39737	; 0x9b39
 44c:	00001802 	andeq	r1, r0, r2, lsl #16
 450:	3f012e21 	svccc	0x00012e21
 454:	3a0e0319 	bcc	3810c0 <__bss_end+0x377640>
 458:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 45c:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 460:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
 464:	97184006 	ldrls	r4, [r8, -r6]
 468:	13011942 	movwne	r1, #6466	; 0x1942
 46c:	34220000 	strtcc	r0, [r2], #-0
 470:	3a080300 	bcc	201078 <__bss_end+0x1f75f8>
 474:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 478:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 47c:	23000018 	movwcs	r0, #24
 480:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 484:	0b3a0e03 	bleq	e83c98 <__bss_end+0xe7a218>
 488:	0b390b3b 	bleq	e4317c <__bss_end+0xe396fc>
 48c:	01110e6e 	tsteq	r1, lr, ror #28
 490:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 494:	01194297 			; <UNDEFINED> instruction: 0x01194297
 498:	24000013 	strcs	r0, [r0], #-19	; 0xffffffed
 49c:	193f002e 	ldmdbne	pc!, {r1, r2, r3, r5}	; <UNPREDICTABLE>
 4a0:	0b3a0e03 	bleq	e83cb4 <__bss_end+0xe7a234>
 4a4:	0b390b3b 	bleq	e43198 <__bss_end+0xe39718>
 4a8:	01110e6e 	tsteq	r1, lr, ror #28
 4ac:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 4b0:	00194297 	mulseq	r9, r7, r2
 4b4:	012e2500 			; <UNDEFINED> instruction: 0x012e2500
 4b8:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 4bc:	0b3b0b3a 	bleq	ec31ac <__bss_end+0xeb972c>
 4c0:	0e6e0b39 	vmoveq.8	d14[5], r0
 4c4:	01111349 	tsteq	r1, r9, asr #6
 4c8:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 4cc:	00194297 	mulseq	r9, r7, r2
 4d0:	11010000 	mrsne	r0, (UNDEF: 1)
 4d4:	130e2501 	movwne	r2, #58625	; 0xe501
 4d8:	1b0e030b 	blne	38110c <__bss_end+0x37768c>
 4dc:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 4e0:	00171006 	andseq	r1, r7, r6
 4e4:	01390200 	teqeq	r9, r0, lsl #4
 4e8:	00001301 	andeq	r1, r0, r1, lsl #6
 4ec:	03003403 	movweq	r3, #1027	; 0x403
 4f0:	3b0b3a0e 	blcc	2ced30 <__bss_end+0x2c52b0>
 4f4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 4f8:	1c193c13 	ldcne	12, cr3, [r9], {19}
 4fc:	0400000a 	streq	r0, [r0], #-10
 500:	0b3a003a 	bleq	e805f0 <__bss_end+0xe76b70>
 504:	0b390b3b 	bleq	e431f8 <__bss_end+0xe39778>
 508:	00001318 	andeq	r1, r0, r8, lsl r3
 50c:	49010105 	stmdbmi	r1, {r0, r2, r8}
 510:	00130113 	andseq	r0, r3, r3, lsl r1
 514:	00210600 	eoreq	r0, r1, r0, lsl #12
 518:	0b2f1349 	bleq	bc5244 <__bss_end+0xbbb7c4>
 51c:	26070000 	strcs	r0, [r7], -r0
 520:	00134900 	andseq	r4, r3, r0, lsl #18
 524:	00240800 	eoreq	r0, r4, r0, lsl #16
 528:	0b3e0b0b 	bleq	f8315c <__bss_end+0xf796dc>
 52c:	00000e03 	andeq	r0, r0, r3, lsl #28
 530:	47003409 	strmi	r3, [r0, -r9, lsl #8]
 534:	0a000013 	beq	588 <shift+0x588>
 538:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 53c:	0b3a0e03 	bleq	e83d50 <__bss_end+0xe7a2d0>
 540:	0b390b3b 	bleq	e43234 <__bss_end+0xe397b4>
 544:	01110e6e 	tsteq	r1, lr, ror #28
 548:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 54c:	01194296 			; <UNDEFINED> instruction: 0x01194296
 550:	0b000013 	bleq	5a4 <shift+0x5a4>
 554:	08030005 	stmdaeq	r3, {r0, r2}
 558:	0b3b0b3a 	bleq	ec3248 <__bss_end+0xeb97c8>
 55c:	13490b39 	movtne	r0, #39737	; 0x9b39
 560:	00001802 	andeq	r1, r0, r2, lsl #16
 564:	0300340c 	movweq	r3, #1036	; 0x40c
 568:	3b0b3a0e 	blcc	2ceda8 <__bss_end+0x2c5328>
 56c:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 570:	00180213 	andseq	r0, r8, r3, lsl r2
 574:	00340d00 	eorseq	r0, r4, r0, lsl #26
 578:	0b3a0803 	bleq	e8258c <__bss_end+0xe78b0c>
 57c:	0b390b3b 	bleq	e43270 <__bss_end+0xe397f0>
 580:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 584:	0f0e0000 	svceq	0x000e0000
 588:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
 58c:	0f000013 	svceq	0x00000013
 590:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 594:	0b3a0e03 	bleq	e83da8 <__bss_end+0xe7a328>
 598:	0b390b3b 	bleq	e4328c <__bss_end+0xe3980c>
 59c:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 5a0:	06120111 			; <UNDEFINED> instruction: 0x06120111
 5a4:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 5a8:	00130119 	andseq	r0, r3, r9, lsl r1
 5ac:	00051000 	andeq	r1, r5, r0
 5b0:	0b3a0e03 	bleq	e83dc4 <__bss_end+0xe7a344>
 5b4:	0b390b3b 	bleq	e432a8 <__bss_end+0xe39828>
 5b8:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 5bc:	24110000 	ldrcs	r0, [r1], #-0
 5c0:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 5c4:	0008030b 	andeq	r0, r8, fp, lsl #6
 5c8:	012e1200 			; <UNDEFINED> instruction: 0x012e1200
 5cc:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 5d0:	0b3b0b3a 	bleq	ec32c0 <__bss_end+0xeb9840>
 5d4:	0e6e0b39 	vmoveq.8	d14[5], r0
 5d8:	06120111 			; <UNDEFINED> instruction: 0x06120111
 5dc:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 5e0:	00130119 	andseq	r0, r3, r9, lsl r1
 5e4:	010b1300 	mrseq	r1, (UNDEF: 59)
 5e8:	06120111 			; <UNDEFINED> instruction: 0x06120111
 5ec:	26140000 	ldrcs	r0, [r4], -r0
 5f0:	15000000 	strne	r0, [r0, #-0]
 5f4:	0b0b000f 	bleq	2c0638 <__bss_end+0x2b6bb8>
 5f8:	2e160000 	cdpcs	0, 1, cr0, cr6, cr0, {0}
 5fc:	03193f01 	tsteq	r9, #1, 30
 600:	3b0b3a0e 	blcc	2cee40 <__bss_end+0x2c53c0>
 604:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 608:	1113490e 	tstne	r3, lr, lsl #18
 60c:	40061201 	andmi	r1, r6, r1, lsl #4
 610:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
 614:	00001301 	andeq	r1, r0, r1, lsl #6
 618:	3f012e17 	svccc	0x00012e17
 61c:	3a0e0319 	bcc	381288 <__bss_end+0x377808>
 620:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 624:	110e6e0b 	tstne	lr, fp, lsl #28
 628:	40061201 	andmi	r1, r6, r1, lsl #4
 62c:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
 630:	01000000 	mrseq	r0, (UNDEF: 0)
 634:	06100011 			; <UNDEFINED> instruction: 0x06100011
 638:	01120111 	tsteq	r2, r1, lsl r1
 63c:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
 640:	05130e25 	ldreq	r0, [r3, #-3621]	; 0xfffff1db
 644:	01000000 	mrseq	r0, (UNDEF: 0)
 648:	06100011 			; <UNDEFINED> instruction: 0x06100011
 64c:	01120111 	tsteq	r2, r1, lsl r1
 650:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
 654:	05130e25 	ldreq	r0, [r3, #-3621]	; 0xfffff1db
 658:	01000000 	mrseq	r0, (UNDEF: 0)
 65c:	06100011 			; <UNDEFINED> instruction: 0x06100011
 660:	01120111 	tsteq	r2, r1, lsl r1
 664:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
 668:	05130e25 	ldreq	r0, [r3, #-3621]	; 0xfffff1db
 66c:	01000000 	mrseq	r0, (UNDEF: 0)
 670:	06100011 			; <UNDEFINED> instruction: 0x06100011
 674:	01120111 	tsteq	r2, r1, lsl r1
 678:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
 67c:	05130e25 	ldreq	r0, [r3, #-3621]	; 0xfffff1db
 680:	01000000 	mrseq	r0, (UNDEF: 0)
 684:	0e250111 	mcreq	1, 1, r0, cr5, cr1, {0}
 688:	0e030b13 	vmoveq.32	d3[0], r0
 68c:	17100e1b 			; <UNDEFINED> instruction: 0x17100e1b
 690:	24020000 	strcs	r0, [r2], #-0
 694:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 698:	0008030b 	andeq	r0, r8, fp, lsl #6
 69c:	00240300 	eoreq	r0, r4, r0, lsl #6
 6a0:	0b3e0b0b 	bleq	f832d4 <__bss_end+0xf79854>
 6a4:	00000e03 	andeq	r0, r0, r3, lsl #28
 6a8:	03010404 	movweq	r0, #5124	; 0x1404
 6ac:	0b0b3e0e 	bleq	2cfeec <__bss_end+0x2c646c>
 6b0:	3a13490b 	bcc	4d2ae4 <__bss_end+0x4c9064>
 6b4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 6b8:	0013010b 	andseq	r0, r3, fp, lsl #2
 6bc:	00280500 	eoreq	r0, r8, r0, lsl #10
 6c0:	0b1c0e03 	bleq	703ed4 <__bss_end+0x6fa454>
 6c4:	13060000 	movwne	r0, #24576	; 0x6000
 6c8:	0b0e0301 	bleq	3812d4 <__bss_end+0x377854>
 6cc:	3b0b3a0b 	blcc	2cef00 <__bss_end+0x2c5480>
 6d0:	010b3905 	tsteq	fp, r5, lsl #18
 6d4:	07000013 	smladeq	r0, r3, r0, r0
 6d8:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
 6dc:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 6e0:	13490b39 	movtne	r0, #39737	; 0x9b39
 6e4:	00000b38 	andeq	r0, r0, r8, lsr fp
 6e8:	49002608 	stmdbmi	r0, {r3, r9, sl, sp}
 6ec:	09000013 	stmdbeq	r0, {r0, r1, r4}
 6f0:	13490101 	movtne	r0, #37121	; 0x9101
 6f4:	00001301 	andeq	r1, r0, r1, lsl #6
 6f8:	4900210a 	stmdbmi	r0, {r1, r3, r8, sp}
 6fc:	000b2f13 	andeq	r2, fp, r3, lsl pc
 700:	00340b00 	eorseq	r0, r4, r0, lsl #22
 704:	0b3a0e03 	bleq	e83f18 <__bss_end+0xe7a498>
 708:	0b39053b 	bleq	e41bfc <__bss_end+0xe3817c>
 70c:	0a1c1349 	beq	705438 <__bss_end+0x6fb9b8>
 710:	150c0000 	strne	r0, [ip, #-0]
 714:	00192700 	andseq	r2, r9, r0, lsl #14
 718:	000f0d00 	andeq	r0, pc, r0, lsl #26
 71c:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 720:	040e0000 	streq	r0, [lr], #-0
 724:	3e0e0301 	cdpcc	3, 0, cr0, cr14, cr1, {0}
 728:	490b0b0b 	stmdbmi	fp, {r0, r1, r3, r8, r9, fp}
 72c:	3b0b3a13 	blcc	2cef80 <__bss_end+0x2c5500>
 730:	010b3905 	tsteq	fp, r5, lsl #18
 734:	0f000013 	svceq	0x00000013
 738:	0e030016 	mcreq	0, 0, r0, cr3, cr6, {0}
 73c:	0b3b0b3a 	bleq	ec342c <__bss_end+0xeb99ac>
 740:	13490b39 	movtne	r0, #39737	; 0x9b39
 744:	21100000 	tstcs	r0, r0
 748:	11000000 	mrsne	r0, (UNDEF: 0)
 74c:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 750:	0b3b0b3a 	bleq	ec3440 <__bss_end+0xeb99c0>
 754:	13490b39 	movtne	r0, #39737	; 0x9b39
 758:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
 75c:	34120000 	ldrcc	r0, [r2], #-0
 760:	3a134700 	bcc	4d2368 <__bss_end+0x4c88e8>
 764:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 768:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 76c:	00000018 	andeq	r0, r0, r8, lsl r0
 770:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
 774:	030b130e 	movweq	r1, #45838	; 0xb30e
 778:	110e1b0e 	tstne	lr, lr, lsl #22
 77c:	10061201 	andne	r1, r6, r1, lsl #4
 780:	02000017 	andeq	r0, r0, #23
 784:	0b0b0024 	bleq	2c081c <__bss_end+0x2b6d9c>
 788:	0e030b3e 	vmoveq.16	d3[0], r0
 78c:	24030000 	strcs	r0, [r3], #-0
 790:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 794:	0008030b 	andeq	r0, r8, fp, lsl #6
 798:	01040400 	tsteq	r4, r0, lsl #8
 79c:	0b3e0e03 	bleq	f83fb0 <__bss_end+0xf7a530>
 7a0:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 7a4:	0b3b0b3a 	bleq	ec3494 <__bss_end+0xeb9a14>
 7a8:	13010b39 	movwne	r0, #6969	; 0x1b39
 7ac:	28050000 	stmdacs	r5, {}	; <UNPREDICTABLE>
 7b0:	1c0e0300 	stcne	3, cr0, [lr], {-0}
 7b4:	0600000b 	streq	r0, [r0], -fp
 7b8:	0e030113 	mcreq	1, 0, r0, cr3, cr3, {0}
 7bc:	0b3a0b0b 	bleq	e833f0 <__bss_end+0xe79970>
 7c0:	0b39053b 	bleq	e41cb4 <__bss_end+0xe38234>
 7c4:	00001301 	andeq	r1, r0, r1, lsl #6
 7c8:	03000d07 	movweq	r0, #3335	; 0xd07
 7cc:	3b0b3a0e 	blcc	2cf00c <__bss_end+0x2c558c>
 7d0:	490b3905 	stmdbmi	fp, {r0, r2, r8, fp, ip, sp}
 7d4:	000b3813 	andeq	r3, fp, r3, lsl r8
 7d8:	00260800 	eoreq	r0, r6, r0, lsl #16
 7dc:	00001349 	andeq	r1, r0, r9, asr #6
 7e0:	49010109 	stmdbmi	r1, {r0, r3, r8}
 7e4:	00130113 	andseq	r0, r3, r3, lsl r1
 7e8:	00210a00 	eoreq	r0, r1, r0, lsl #20
 7ec:	0b2f1349 	bleq	bc5518 <__bss_end+0xbbba98>
 7f0:	340b0000 	strcc	r0, [fp], #-0
 7f4:	3a0e0300 	bcc	3813fc <__bss_end+0x37797c>
 7f8:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 7fc:	1c13490b 			; <UNDEFINED> instruction: 0x1c13490b
 800:	0c00000a 	stceq	0, cr0, [r0], {10}
 804:	0e030016 	mcreq	0, 0, r0, cr3, cr6, {0}
 808:	0b3b0b3a 	bleq	ec34f8 <__bss_end+0xeb9a78>
 80c:	13490b39 	movtne	r0, #39737	; 0x9b39
 810:	2e0d0000 	cdpcs	0, 0, cr0, cr13, cr0, {0}
 814:	03193f01 	tsteq	r9, #1, 30
 818:	3b0b3a0e 	blcc	2cf058 <__bss_end+0x2c55d8>
 81c:	270b3905 	strcs	r3, [fp, -r5, lsl #18]
 820:	11134919 	tstne	r3, r9, lsl r9
 824:	40061201 	andmi	r1, r6, r1, lsl #4
 828:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
 82c:	00001301 	andeq	r1, r0, r1, lsl #6
 830:	0300050e 	movweq	r0, #1294	; 0x50e
 834:	3b0b3a08 	blcc	2cf05c <__bss_end+0x2c55dc>
 838:	490b3905 	stmdbmi	fp, {r0, r2, r8, fp, ip, sp}
 83c:	b7170213 			; <UNDEFINED> instruction: 0xb7170213
 840:	00001742 	andeq	r1, r0, r2, asr #14
 844:	0182890f 	orreq	r8, r2, pc, lsl #18
 848:	95011101 	strls	r1, [r1, #-257]	; 0xfffffeff
 84c:	13311942 	teqne	r1, #1081344	; 0x108000
 850:	00001301 	andeq	r1, r0, r1, lsl #6
 854:	01828a10 	orreq	r8, r2, r0, lsl sl
 858:	91180200 	tstls	r8, r0, lsl #4
 85c:	00001842 	andeq	r1, r0, r2, asr #16
 860:	01828911 	orreq	r8, r2, r1, lsl r9
 864:	31011101 	tstcc	r1, r1, lsl #2
 868:	12000013 	andne	r0, r0, #19
 86c:	193f002e 	ldmdbne	pc!, {r1, r2, r3, r5}	; <UNPREDICTABLE>
 870:	0e6e193c 			; <UNDEFINED> instruction: 0x0e6e193c
 874:	0b3a0e03 	bleq	e84088 <__bss_end+0xe7a608>
 878:	0b390b3b 	bleq	e4356c <__bss_end+0xe39aec>
 87c:	01000000 	mrseq	r0, (UNDEF: 0)
 880:	0e250111 	mcreq	1, 1, r0, cr5, cr1, {0}
 884:	0e030b13 	vmoveq.32	d3[0], r0
 888:	01110e1b 	tsteq	r1, fp, lsl lr
 88c:	17100612 			; <UNDEFINED> instruction: 0x17100612
 890:	24020000 	strcs	r0, [r2], #-0
 894:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 898:	000e030b 	andeq	r0, lr, fp, lsl #6
 89c:	00240300 	eoreq	r0, r4, r0, lsl #6
 8a0:	0b3e0b0b 	bleq	f834d4 <__bss_end+0xf79a54>
 8a4:	00000803 	andeq	r0, r0, r3, lsl #16
 8a8:	03010404 	movweq	r0, #5124	; 0x1404
 8ac:	0b0b3e0e 	bleq	2d00ec <__bss_end+0x2c666c>
 8b0:	3a13490b 	bcc	4d2ce4 <__bss_end+0x4c9264>
 8b4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 8b8:	0013010b 	andseq	r0, r3, fp, lsl #2
 8bc:	00280500 	eoreq	r0, r8, r0, lsl #10
 8c0:	0b1c0e03 	bleq	7040d4 <__bss_end+0x6fa654>
 8c4:	13060000 	movwne	r0, #24576	; 0x6000
 8c8:	0b0e0301 	bleq	3814d4 <__bss_end+0x377a54>
 8cc:	3b0b3a0b 	blcc	2cf100 <__bss_end+0x2c5680>
 8d0:	010b3905 	tsteq	fp, r5, lsl #18
 8d4:	07000013 	smladeq	r0, r3, r0, r0
 8d8:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
 8dc:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 8e0:	13490b39 	movtne	r0, #39737	; 0x9b39
 8e4:	00000b38 	andeq	r0, r0, r8, lsr fp
 8e8:	49002608 	stmdbmi	r0, {r3, r9, sl, sp}
 8ec:	09000013 	stmdbeq	r0, {r0, r1, r4}
 8f0:	13490101 	movtne	r0, #37121	; 0x9101
 8f4:	00001301 	andeq	r1, r0, r1, lsl #6
 8f8:	4900210a 	stmdbmi	r0, {r1, r3, r8, sp}
 8fc:	000b2f13 	andeq	r2, fp, r3, lsl pc
 900:	00340b00 	eorseq	r0, r4, r0, lsl #22
 904:	0b3a0e03 	bleq	e84118 <__bss_end+0xe7a698>
 908:	0b39053b 	bleq	e41dfc <__bss_end+0xe3837c>
 90c:	0a1c1349 	beq	705638 <__bss_end+0x6fbbb8>
 910:	160c0000 	strne	r0, [ip], -r0
 914:	3a0e0300 	bcc	38151c <__bss_end+0x377a9c>
 918:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 91c:	0013490b 	andseq	r4, r3, fp, lsl #18
 920:	012e0d00 			; <UNDEFINED> instruction: 0x012e0d00
 924:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 928:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 92c:	19270b39 	stmdbne	r7!, {r0, r3, r4, r5, r8, r9, fp}
 930:	01111349 	tsteq	r1, r9, asr #6
 934:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 938:	00194297 	mulseq	r9, r7, r2
 93c:	00050e00 	andeq	r0, r5, r0, lsl #28
 940:	0b3a0803 	bleq	e82954 <__bss_end+0xe78ed4>
 944:	0b39053b 	bleq	e41e38 <__bss_end+0xe383b8>
 948:	17021349 	strne	r1, [r2, -r9, asr #6]
 94c:	001742b7 			; <UNDEFINED> instruction: 0x001742b7
 950:	00340f00 	eorseq	r0, r4, r0, lsl #30
 954:	0b3a0803 	bleq	e82968 <__bss_end+0xe78ee8>
 958:	0b39053b 	bleq	e41e4c <__bss_end+0xe383cc>
 95c:	17021349 	strne	r1, [r2, -r9, asr #6]
 960:	001742b7 			; <UNDEFINED> instruction: 0x001742b7
 964:	11010000 	mrsne	r0, (UNDEF: 1)
 968:	130e2501 	movwne	r2, #58625	; 0xe501
 96c:	1b0e030b 	blne	3815a0 <__bss_end+0x377b20>
 970:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 974:	00171006 	andseq	r1, r7, r6
 978:	00240200 	eoreq	r0, r4, r0, lsl #4
 97c:	0b3e0b0b 	bleq	f835b0 <__bss_end+0xf79b30>
 980:	00000e03 	andeq	r0, r0, r3, lsl #28
 984:	0b002403 	bleq	9998 <__udivmoddi4+0xc8>
 988:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 98c:	04000008 	streq	r0, [r0], #-8
 990:	0e030104 	adfeqs	f0, f3, f4
 994:	0b0b0b3e 	bleq	2c3694 <__bss_end+0x2b9c14>
 998:	0b3a1349 	bleq	e856c4 <__bss_end+0xe7bc44>
 99c:	0b390b3b 	bleq	e43690 <__bss_end+0xe39c10>
 9a0:	00001301 	andeq	r1, r0, r1, lsl #6
 9a4:	03002805 	movweq	r2, #2053	; 0x805
 9a8:	000b1c0e 	andeq	r1, fp, lr, lsl #24
 9ac:	01130600 	tsteq	r3, r0, lsl #12
 9b0:	0b0b0e03 	bleq	2c41c4 <__bss_end+0x2ba744>
 9b4:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 9b8:	13010b39 	movwne	r0, #6969	; 0x1b39
 9bc:	0d070000 	stceq	0, cr0, [r7, #-0]
 9c0:	3a0e0300 	bcc	3815c8 <__bss_end+0x377b48>
 9c4:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 9c8:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 9cc:	0800000b 	stmdaeq	r0, {r0, r1, r3}
 9d0:	13490026 	movtne	r0, #36902	; 0x9026
 9d4:	01090000 	mrseq	r0, (UNDEF: 9)
 9d8:	01134901 	tsteq	r3, r1, lsl #18
 9dc:	0a000013 	beq	a30 <shift+0xa30>
 9e0:	13490021 	movtne	r0, #36897	; 0x9021
 9e4:	00000b2f 	andeq	r0, r0, pc, lsr #22
 9e8:	0300340b 	movweq	r3, #1035	; 0x40b
 9ec:	3b0b3a0e 	blcc	2cf22c <__bss_end+0x2c57ac>
 9f0:	490b3905 	stmdbmi	fp, {r0, r2, r8, fp, ip, sp}
 9f4:	000a1c13 	andeq	r1, sl, r3, lsl ip
 9f8:	00160c00 	andseq	r0, r6, r0, lsl #24
 9fc:	0b3a0e03 	bleq	e84210 <__bss_end+0xe7a790>
 a00:	0b390b3b 	bleq	e436f4 <__bss_end+0xe39c74>
 a04:	00001349 	andeq	r1, r0, r9, asr #6
 a08:	3f012e0d 	svccc	0x00012e0d
 a0c:	3a0e0319 	bcc	381678 <__bss_end+0x377bf8>
 a10:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 a14:	4919270b 	ldmdbmi	r9, {r0, r1, r3, r8, r9, sl, sp}
 a18:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
 a1c:	97184006 	ldrls	r4, [r8, -r6]
 a20:	13011942 	movwne	r1, #6466	; 0x1942
 a24:	050e0000 	streq	r0, [lr, #-0]
 a28:	3a080300 	bcc	201630 <__bss_end+0x1f7bb0>
 a2c:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 a30:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 a34:	1742b717 	smlaldne	fp, r2, r7, r7
 a38:	050f0000 	streq	r0, [pc, #-0]	; a40 <shift+0xa40>
 a3c:	3a080300 	bcc	201644 <__bss_end+0x1f7bc4>
 a40:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 a44:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 a48:	10000018 	andne	r0, r0, r8, lsl r0
 a4c:	08030034 	stmdaeq	r3, {r2, r4, r5}
 a50:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 a54:	13490b39 	movtne	r0, #39737	; 0x9b39
 a58:	42b71702 	adcsmi	r1, r7, #524288	; 0x80000
 a5c:	11000017 	tstne	r0, r7, lsl r0
 a60:	0b0b000f 	bleq	2c0aa4 <__bss_end+0x2b7024>
 a64:	00001349 	andeq	r1, r0, r9, asr #6
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
  74:	00000048 	andeq	r0, r0, r8, asr #32
	...
  80:	0000001c 	andeq	r0, r0, ip, lsl r0
  84:	044e0002 	strbeq	r0, [lr], #-2
  88:	00040000 	andeq	r0, r4, r0
  8c:	00000000 	andeq	r0, r0, r0
  90:	00008274 	andeq	r8, r0, r4, ror r2
  94:	0000045c 	andeq	r0, r0, ip, asr r4
	...
  a0:	0000001c 	andeq	r0, r0, ip, lsl r0
  a4:	0fe30002 	svceq	0x00e30002
  a8:	00040000 	andeq	r0, r4, r0
  ac:	00000000 	andeq	r0, r0, r0
  b0:	000086d0 	ldrdeq	r8, [r0], -r0
  b4:	00000c5c 	andeq	r0, r0, ip, asr ip
	...
  c0:	0000001c 	andeq	r0, r0, ip, lsl r0
  c4:	16140002 	ldrne	r0, [r4], -r2
  c8:	00040000 	andeq	r0, r4, r0
  cc:	00000000 	andeq	r0, r0, r0
  d0:	0000932c 	andeq	r9, r0, ip, lsr #6
  d4:	0000020c 	andeq	r0, r0, ip, lsl #4
	...
  e0:	0000001c 	andeq	r0, r0, ip, lsl r0
  e4:	163a0002 	ldrtne	r0, [sl], -r2
  e8:	00040000 	andeq	r0, r4, r0
  ec:	00000000 	andeq	r0, r0, r0
  f0:	00009538 	andeq	r9, r0, r8, lsr r5
  f4:	00000004 	andeq	r0, r0, r4
	...
 100:	0000001c 	andeq	r0, r0, ip, lsl r0
 104:	16600002 	strbtne	r0, [r0], -r2
 108:	00040000 	andeq	r0, r4, r0
 10c:	00000000 	andeq	r0, r0, r0
 110:	0000953c 	andeq	r9, r0, ip, lsr r5
 114:	00000250 	andeq	r0, r0, r0, asr r2
	...
 120:	0000001c 	andeq	r0, r0, ip, lsl r0
 124:	16860002 	strne	r0, [r6], r2
 128:	00040000 	andeq	r0, r4, r0
 12c:	00000000 	andeq	r0, r0, r0
 130:	0000978c 	andeq	r9, r0, ip, lsl #15
 134:	000000d4 	ldrdeq	r0, [r0], -r4
	...
 140:	00000014 	andeq	r0, r0, r4, lsl r0
 144:	16ac0002 	strtne	r0, [ip], r2
 148:	00040000 	andeq	r0, r4, r0
	...
 158:	0000001c 	andeq	r0, r0, ip, lsl r0
 15c:	19da0002 	ldmibne	sl, {r1}^
 160:	00040000 	andeq	r0, r4, r0
 164:	00000000 	andeq	r0, r0, r0
 168:	00009860 	andeq	r9, r0, r0, ror #16
 16c:	00000030 	andeq	r0, r0, r0, lsr r0
	...
 178:	0000001c 	andeq	r0, r0, ip, lsl r0
 17c:	1ce40002 	stclne	0, cr0, [r4], #8
 180:	00040000 	andeq	r0, r4, r0
 184:	00000000 	andeq	r0, r0, r0
 188:	00009890 	muleq	r0, r0, r8
 18c:	00000040 	andeq	r0, r0, r0, asr #32
	...
 198:	0000001c 	andeq	r0, r0, ip, lsl r0
 19c:	20120002 	andscs	r0, r2, r2
 1a0:	00040000 	andeq	r0, r4, r0
 1a4:	00000000 	andeq	r0, r0, r0
 1a8:	000098d0 	ldrdeq	r9, [r0], -r0
 1ac:	00000120 	andeq	r0, r0, r0, lsr #2
	...

Disassembly of section .debug_str:

00000000 <.debug_str>:
       0:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; ffffff4c <__bss_end+0xffff64cc>
       4:	72742f65 	rsbsvc	r2, r4, #404	; 0x194
       8:	6c696665 	stclvs	6, cr6, [r9], #-404	; 0xfffffe6c
       c:	6d65732f 	stclvs	3, cr7, [r5, #-188]!	; 0xffffff44
      10:	756f732f 	strbvc	r7, [pc, #-815]!	; fffffce9 <__bss_end+0xffff6269>
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
      40:	752f7365 	strvc	r7, [pc, #-869]!	; fffffce3 <__bss_end+0xffff6263>
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
      dc:	2b6b7a36 	blcs	1ade9bc <__bss_end+0x1ad4f3c>
      e0:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
      e4:	672d2067 	strvs	r2, [sp, -r7, rrx]!
      e8:	304f2d20 	subcc	r2, pc, r0, lsr #26
      ec:	304f2d20 	subcc	r2, pc, r0, lsr #26
      f0:	625f5f00 	subsvs	r5, pc, #0, 30
      f4:	655f7373 	ldrbvs	r7, [pc, #-883]	; fffffd89 <__bss_end+0xffff6309>
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
     160:	755f6962 	ldrbvc	r6, [pc, #-2402]	; fffff806 <__bss_end+0xffff5d86>
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
     260:	2b432055 	blcs	10c83bc <__bss_end+0x10be93c>
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
     2c4:	7a6a3637 	bvc	1a8dba8 <__bss_end+0x1a84128>
     2c8:	20732d66 	rsbscs	r2, r3, r6, ror #26
     2cc:	72616d2d 	rsbvc	r6, r1, #2880	; 0xb40
     2d0:	6d2d206d 	stcvs	0, cr2, [sp, #-436]!	; 0xfffffe4c
     2d4:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
     2d8:	6d72613d 	ldfvse	f6, [r2, #-244]!	; 0xffffff0c
     2dc:	6b7a3676 	blvs	1e8dcbc <__bss_end+0x1e8423c>
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
     338:	74726f68 	ldrbtvc	r6, [r2], #-3944	; 0xfffff098
     33c:	736e7520 	cmnvc	lr, #32, 10	; 0x8000000
     340:	656e6769 	strbvs	r6, [lr, #-1897]!	; 0xfffff897
     344:	6e692064 	cdpvs	0, 6, cr2, cr9, cr4, {3}
     348:	614d0074 	hvcvs	53252	; 0xd004
     34c:	6c694678 	stclvs	6, cr4, [r9], #-480	; 0xfffffe20
     350:	6d616e65 	stclvs	14, cr6, [r1, #-404]!	; 0xfffffe6c
     354:	6e654c65 	cdpvs	12, 6, cr4, cr5, cr5, {3}
     358:	00687467 	rsbeq	r7, r8, r7, ror #8
     35c:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 2a8 <shift+0x2a8>
     360:	72742f65 	rsbsvc	r2, r4, #404	; 0x194
     364:	6c696665 	stclvs	6, cr6, [r9], #-404	; 0xfffffe6c
     368:	6d65732f 	stclvs	3, cr7, [r5, #-188]!	; 0xffffff44
     36c:	756f732f 	strbvc	r7, [pc, #-815]!	; 45 <shift+0x45>
     370:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
     374:	6573752f 	ldrbvs	r7, [r3, #-1327]!	; 0xfffffad1
     378:	61707372 	cmnvs	r0, r2, ror r3
     37c:	692f6563 	stmdbvs	pc!, {r0, r1, r5, r6, r8, sl, sp, lr}	; <UNPREDICTABLE>
     380:	5f74696e 	svcpl	0x0074696e
     384:	6b736174 	blvs	1cd895c <__bss_end+0x1cceedc>
     388:	69616d2f 	stmdbvs	r1!, {r0, r1, r2, r3, r5, r8, sl, fp, sp, lr}^
     38c:	70632e6e 	rsbvc	r2, r3, lr, ror #28
     390:	72610070 	rsbvc	r0, r1, #112	; 0x70
     394:	4c006367 	stcmi	3, cr6, [r0], {103}	; 0x67
     398:	5f6b636f 	svcpl	0x006b636f
     39c:	6f6c6e55 	svcvs	0x006c6e55
     3a0:	64656b63 	strbtvs	r6, [r5], #-2915	; 0xfffff49d
     3a4:	766e4900 	strbtvc	r4, [lr], -r0, lsl #18
     3a8:	64696c61 	strbtvs	r6, [r9], #-3169	; 0xfffff39f
     3ac:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
     3b0:	00656c64 	rsbeq	r6, r5, r4, ror #24
     3b4:	6c6f6f62 	stclvs	15, cr6, [pc], #-392	; 234 <shift+0x234>
     3b8:	61654400 	cmnvs	r5, r0, lsl #8
     3bc:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
     3c0:	6e555f65 	cdpvs	15, 5, cr5, cr5, cr5, {3}
     3c4:	6e616863 	cdpvs	8, 6, cr6, cr1, cr3, {3}
     3c8:	00646567 	rsbeq	r6, r4, r7, ror #10
     3cc:	69466f4e 	stmdbvs	r6, {r1, r2, r3, r6, r8, r9, sl, fp, sp, lr}^
     3d0:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
     3d4:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
     3d8:	76697244 	strbtvc	r7, [r9], -r4, asr #4
     3dc:	75007265 	strvc	r7, [r0, #-613]	; 0xfffffd9b
     3e0:	6769736e 	strbvs	r7, [r9, -lr, ror #6]!
     3e4:	2064656e 	rsbcs	r6, r4, lr, ror #10
     3e8:	72616863 	rsbvc	r6, r1, #6488064	; 0x630000
     3ec:	746f4e00 	strbtvc	r4, [pc], #-3584	; 3f4 <shift+0x3f4>
     3f0:	41796669 	cmnmi	r9, r9, ror #12
     3f4:	75006c6c 	strvc	r6, [r0, #-3180]	; 0xfffff394
     3f8:	33746e69 	cmncc	r4, #1680	; 0x690
     3fc:	00745f32 	rsbseq	r5, r4, r2, lsr pc
     400:	6b636f4c 	blvs	18dc138 <__bss_end+0x18d26b8>
     404:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
     408:	0064656b 	rsbeq	r6, r4, fp, ror #10
     40c:	65646e49 	strbvs	r6, [r4, #-3657]!	; 0xfffff1b7
     410:	696e6966 	stmdbvs	lr!, {r1, r2, r5, r6, r8, fp, sp, lr}^
     414:	4d006574 	cfstr32mi	mvfx6, [r0, #-464]	; 0xfffffe30
     418:	505f7861 	subspl	r7, pc, r1, ror #16
     41c:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     420:	4f5f7373 	svcmi	0x005f7373
     424:	656e6570 	strbvs	r6, [lr, #-1392]!	; 0xfffffa90
     428:	69465f64 	stmdbvs	r6, {r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     42c:	0073656c 	rsbseq	r6, r3, ip, ror #10
     430:	5078614d 	rsbspl	r6, r8, sp, asr #2
     434:	4c687461 	cfstrdmi	mvd7, [r8], #-388	; 0xfffffe7c
     438:	74676e65 	strbtvc	r6, [r7], #-3685	; 0xfffff19b
     43c:	68730068 	ldmdavs	r3!, {r3, r5, r6}^
     440:	2074726f 	rsbscs	r7, r4, pc, ror #4
     444:	00746e69 	rsbseq	r6, r4, r9, ror #28
     448:	4678614d 	ldrbtmi	r6, [r8], -sp, asr #2
     44c:	69724453 	ldmdbvs	r2!, {r0, r1, r4, r6, sl, lr}^
     450:	4e726576 	mrcmi	5, 3, r6, cr2, cr6, {3}
     454:	4c656d61 	stclmi	13, cr6, [r5], #-388	; 0xfffffe7c
     458:	74676e65 	strbtvc	r6, [r7], #-3685	; 0xfffff19b
     45c:	72610068 	rsbvc	r0, r1, #104	; 0x68
     460:	54007667 	strpl	r7, [r0], #-1639	; 0xfffff999
     464:	5f6b6369 	svcpl	0x006b6369
     468:	6e756f43 	cdpvs	15, 7, cr6, cr5, cr3, {2}
     46c:	704f0074 	subvc	r0, pc, r4, ror r0	; <UNPREDICTABLE>
     470:	5f006e65 	svcpl	0x00006e65
     474:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     478:	6f725043 	svcvs	0x00725043
     47c:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     480:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     484:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     488:	6c423132 	stfvse	f3, [r2], {50}	; 0x32
     48c:	5f6b636f 	svcpl	0x006b636f
     490:	72727543 	rsbsvc	r7, r2, #281018368	; 0x10c00000
     494:	5f746e65 	svcpl	0x00746e65
     498:	636f7250 	cmnvs	pc, #80, 4
     49c:	45737365 	ldrbmi	r7, [r3, #-869]!	; 0xfffffc9b
     4a0:	6c630076 	stclvs	0, cr0, [r3], #-472	; 0xfffffe28
     4a4:	0065736f 	rsbeq	r7, r5, pc, ror #6
     4a8:	76657270 			; <UNDEFINED> instruction: 0x76657270
     4ac:	74655300 	strbtvc	r5, [r5], #-768	; 0xfffffd00
     4b0:	6c65525f 	sfmvs	f5, 2, [r5], #-380	; 0xfffffe84
     4b4:	76697461 	strbtvc	r7, [r9], -r1, ror #8
     4b8:	6e550065 	cdpvs	0, 5, cr0, cr5, cr5, {3}
     4bc:	5f70616d 	svcpl	0x0070616d
     4c0:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     4c4:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
     4c8:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     4cc:	74657200 	strbtvc	r7, [r5], #-512	; 0xfffffe00
     4d0:	006c6176 	rsbeq	r6, ip, r6, ror r1
     4d4:	7275636e 	rsbsvc	r6, r5, #-1207959551	; 0xb8000001
     4d8:	6c614d00 	stclvs	13, cr4, [r1], #-0
     4dc:	00636f6c 	rsbeq	r6, r3, ip, ror #30
     4e0:	6f72506d 	svcvs	0x0072506d
     4e4:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     4e8:	73694c5f 	cmnvc	r9, #24320	; 0x5f00
     4ec:	65485f74 	strbvs	r5, [r8, #-3956]	; 0xfffff08c
     4f0:	70006461 	andvc	r6, r0, r1, ror #8
     4f4:	00657069 	rsbeq	r7, r5, r9, rrx
     4f8:	4b4e5a5f 	blmi	1396e7c <__bss_end+0x138d3fc>
     4fc:	50433631 	subpl	r3, r3, r1, lsr r6
     500:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     504:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 340 <shift+0x340>
     508:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     50c:	39317265 	ldmdbcc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
     510:	5f746547 	svcpl	0x00746547
     514:	72727543 	rsbsvc	r7, r2, #281018368	; 0x10c00000
     518:	5f746e65 	svcpl	0x00746e65
     51c:	636f7250 	cmnvs	pc, #80, 4
     520:	45737365 	ldrbmi	r7, [r3, #-869]!	; 0xfffffc9b
     524:	64720076 	ldrbtvs	r0, [r2], #-118	; 0xffffff8a
     528:	006d756e 	rsbeq	r7, sp, lr, ror #10
     52c:	7478656e 	ldrbtvc	r6, [r8], #-1390	; 0xfffffa92
     530:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     534:	6f72505f 	svcvs	0x0072505f
     538:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     53c:	5f79425f 	svcpl	0x0079425f
     540:	00444950 	subeq	r4, r4, r0, asr r9
     544:	31315a5f 	teqcc	r1, pc, asr sl
     548:	65686373 	strbvs	r6, [r8, #-883]!	; 0xfffffc8d
     54c:	69795f64 	ldmdbvs	r9!, {r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     550:	76646c65 	strbtvc	r6, [r4], -r5, ror #24
     554:	57534e00 	ldrbpl	r4, [r3, -r0, lsl #28]
     558:	72505f49 	subsvc	r5, r0, #292	; 0x124
     55c:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     560:	65535f73 	ldrbvs	r5, [r3, #-3955]	; 0xfffff08d
     564:	63697672 	cmnvs	r9, #119537664	; 0x7200000
     568:	65520065 	ldrbvs	r0, [r2, #-101]	; 0xffffff9b
     56c:	41006461 	tstmi	r0, r1, ror #8
     570:	76697463 	strbtvc	r7, [r9], -r3, ror #8
     574:	72505f65 	subsvc	r5, r0, #404	; 0x194
     578:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     57c:	6f435f73 	svcvs	0x00435f73
     580:	00746e75 	rsbseq	r6, r4, r5, ror lr
     584:	61657243 	cmnvs	r5, r3, asr #4
     588:	505f6574 	subspl	r6, pc, r4, ror r5	; <UNPREDICTABLE>
     58c:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     590:	5f007373 	svcpl	0x00007373
     594:	7337315a 	teqvc	r7, #-2147483626	; 0x80000016
     598:	745f7465 	ldrbvc	r7, [pc], #-1125	; 5a0 <shift+0x5a0>
     59c:	5f6b7361 	svcpl	0x006b7361
     5a0:	64616564 	strbtvs	r6, [r1], #-1380	; 0xfffffa9c
     5a4:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
     5a8:	6177006a 	cmnvs	r7, sl, rrx
     5ac:	73007469 	movwvc	r7, #1129	; 0x469
     5b0:	65746174 	ldrbvs	r6, [r4, #-372]!	; 0xfffffe8c
     5b4:	365a5f00 	ldrbcc	r5, [sl], -r0, lsl #30
     5b8:	69746f6e 	ldmdbvs	r4!, {r1, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
     5bc:	6a6a7966 	bvs	1a9eb5c <__bss_end+0x1a950dc>
     5c0:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     5c4:	6863535f 	stmdavs	r3!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     5c8:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
     5cc:	495f7265 	ldmdbmi	pc, {r0, r2, r5, r6, r9, ip, sp, lr}^	; <UNPREDICTABLE>
     5d0:	006f666e 	rsbeq	r6, pc, lr, ror #12
     5d4:	6f725043 	svcvs	0x00725043
     5d8:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     5dc:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     5e0:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     5e4:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     5e8:	50433631 	subpl	r3, r3, r1, lsr r6
     5ec:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     5f0:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 42c <shift+0x42c>
     5f4:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     5f8:	38317265 	ldmdacc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
     5fc:	5f746547 	svcpl	0x00746547
     600:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     604:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
     608:	6e495f72 	mcrvs	15, 2, r5, cr9, cr2, {3}
     60c:	32456f66 	subcc	r6, r5, #408	; 0x198
     610:	65474e30 	strbvs	r4, [r7, #-3632]	; 0xfffff1d0
     614:	63535f74 	cmpvs	r3, #116, 30	; 0x1d0
     618:	5f646568 	svcpl	0x00646568
     61c:	6f666e49 	svcvs	0x00666e49
     620:	7079545f 	rsbsvc	r5, r9, pc, asr r4
     624:	00765065 	rsbseq	r5, r6, r5, rrx
     628:	314e5a5f 	cmpcc	lr, pc, asr sl
     62c:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     630:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     634:	614d5f73 	hvcvs	54771	; 0xd5f3
     638:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     63c:	48313272 	ldmdami	r1!, {r1, r4, r5, r6, r9, ip, sp}
     640:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     644:	69465f65 	stmdbvs	r6, {r0, r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     648:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
     64c:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
     650:	4957535f 	ldmdbmi	r7, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     654:	4e333245 	cdpmi	2, 3, cr3, cr3, cr5, {2}
     658:	5f495753 	svcpl	0x00495753
     65c:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     660:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
     664:	535f6d65 	cmppl	pc, #6464	; 0x1940
     668:	69767265 	ldmdbvs	r6!, {r0, r2, r5, r6, r9, ip, sp, lr}^
     66c:	6a6a6563 	bvs	1a99c00 <__bss_end+0x1a90180>
     670:	3131526a 	teqcc	r1, sl, ror #4
     674:	49575354 	ldmdbmi	r7, {r2, r4, r6, r8, r9, ip, lr}^
     678:	7365525f 	cmnvc	r5, #-268435451	; 0xf0000005
     67c:	00746c75 	rsbseq	r6, r4, r5, ror ip
     680:	6e65706f 	cdpvs	0, 6, cr7, cr5, cr15, {3}
     684:	665f6465 	ldrbvs	r6, [pc], -r5, ror #8
     688:	73656c69 	cmnvc	r5, #26880	; 0x6900
     68c:	69614600 	stmdbvs	r1!, {r9, sl, lr}^
     690:	4354006c 	cmpmi	r4, #108	; 0x6c
     694:	435f5550 	cmpmi	pc, #80, 10	; 0x14000000
     698:	65746e6f 	ldrbvs	r6, [r4, #-3695]!	; 0xfffff191
     69c:	44007478 	strmi	r7, [r0], #-1144	; 0xfffffb88
     6a0:	6c646165 	stfvse	f6, [r4], #-404	; 0xfffffe6c
     6a4:	00656e69 	rsbeq	r6, r5, r9, ror #28
     6a8:	74697865 	strbtvc	r7, [r9], #-2149	; 0xfffff79b
     6ac:	65646f63 	strbvs	r6, [r4, #-3939]!	; 0xfffff09d
     6b0:	62747400 	rsbsvs	r7, r4, #0, 8
     6b4:	5f003072 	svcpl	0x00003072
     6b8:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     6bc:	6f725043 	svcvs	0x00725043
     6c0:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     6c4:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     6c8:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     6cc:	6f4e3431 	svcvs	0x004e3431
     6d0:	79666974 	stmdbvc	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
     6d4:	6f72505f 	svcvs	0x0072505f
     6d8:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     6dc:	47006a45 	strmi	r6, [r0, -r5, asr #20]
     6e0:	505f7465 	subspl	r7, pc, r5, ror #8
     6e4:	6e004449 	cdpvs	4, 0, cr4, cr0, cr9, {2}
     6e8:	6669746f 	strbtvs	r7, [r9], -pc, ror #8
     6ec:	5f646569 	svcpl	0x00646569
     6f0:	64616564 	strbtvs	r6, [r1], #-1380	; 0xfffffa9c
     6f4:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
     6f8:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     6fc:	50433631 	subpl	r3, r3, r1, lsr r6
     700:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     704:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 540 <shift+0x540>
     708:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     70c:	38317265 	ldmdacc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
     710:	616d6e55 	cmnvs	sp, r5, asr lr
     714:	69465f70 	stmdbvs	r6, {r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     718:	435f656c 	cmpmi	pc, #108, 10	; 0x1b000000
     71c:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
     720:	6a45746e 	bvs	115d8e0 <__bss_end+0x1153e60>
     724:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     728:	50433631 	subpl	r3, r3, r1, lsr r6
     72c:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     730:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 56c <shift+0x56c>
     734:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     738:	34317265 	ldrtcc	r7, [r1], #-613	; 0xfffffd9b
     73c:	69746f4e 	ldmdbvs	r4!, {r1, r2, r3, r6, r8, r9, sl, fp, sp, lr}^
     740:	505f7966 	subspl	r7, pc, r6, ror #18
     744:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     748:	50457373 	subpl	r7, r5, r3, ror r3
     74c:	54543231 	ldrbpl	r3, [r4], #-561	; 0xfffffdcf
     750:	5f6b7361 	svcpl	0x006b7361
     754:	75727453 	ldrbvc	r7, [r2, #-1107]!	; 0xfffffbad
     758:	73007463 	movwvc	r7, #1123	; 0x463
     75c:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     760:	6569795f 	strbvs	r7, [r9, #-2399]!	; 0xfffff6a1
     764:	7400646c 	strvc	r6, [r0], #-1132	; 0xfffffb94
     768:	5f6b6369 	svcpl	0x006b6369
     76c:	6e756f63 	cdpvs	15, 7, cr6, cr5, cr3, {3}
     770:	65725f74 	ldrbvs	r5, [r2, #-3956]!	; 0xfffff08c
     774:	72697571 	rsbvc	r7, r9, #473956352	; 0x1c400000
     778:	5f006465 	svcpl	0x00006465
     77c:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     780:	6f725043 	svcvs	0x00725043
     784:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     788:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     78c:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     790:	75523231 	ldrbvc	r3, [r2, #-561]	; 0xfffffdcf
     794:	7269466e 	rsbvc	r4, r9, #115343360	; 0x6e00000
     798:	61547473 	cmpvs	r4, r3, ror r4
     79c:	76456b73 			; <UNDEFINED> instruction: 0x76456b73
     7a0:	325a5f00 	subscc	r5, sl, #0, 30
     7a4:	74656734 	strbtvc	r6, [r5], #-1844	; 0xfffff8cc
     7a8:	7463615f 	strbtvc	r6, [r3], #-351	; 0xfffffea1
     7ac:	5f657669 	svcpl	0x00657669
     7b0:	636f7270 	cmnvs	pc, #112, 4
     7b4:	5f737365 	svcpl	0x00737365
     7b8:	6e756f63 	cdpvs	15, 7, cr6, cr5, cr3, {3}
     7bc:	47007674 	smlsdxmi	r0, r4, r6, r7
     7c0:	435f7465 	cmpmi	pc, #1694498816	; 0x65000000
     7c4:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
     7c8:	505f746e 	subspl	r7, pc, lr, ror #8
     7cc:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     7d0:	50007373 	andpl	r7, r0, r3, ror r3
     7d4:	5f657069 	svcpl	0x00657069
     7d8:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     7dc:	6572505f 	ldrbvs	r5, [r2, #-95]!	; 0xffffffa1
     7e0:	00786966 	rsbseq	r6, r8, r6, ror #18
     7e4:	5f70614d 	svcpl	0x0070614d
     7e8:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     7ec:	5f6f545f 	svcpl	0x006f545f
     7f0:	72727543 	rsbsvc	r7, r2, #281018368	; 0x10c00000
     7f4:	00746e65 	rsbseq	r6, r4, r5, ror #28
     7f8:	636f6c42 	cmnvs	pc, #16896	; 0x4200
     7fc:	75435f6b 	strbvc	r5, [r3, #-3947]	; 0xfffff095
     800:	6e657272 	mcrvs	2, 3, r7, cr5, cr2, {3}
     804:	72505f74 	subsvc	r5, r0, #116, 30	; 0x1d0
     808:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     80c:	65530073 	ldrbvs	r0, [r3, #-115]	; 0xffffff8d
     810:	61505f74 	cmpvs	r0, r4, ror pc
     814:	736d6172 	cmnvc	sp, #-2147483620	; 0x8000001c
     818:	315a5f00 	cmpcc	sl, r0, lsl #30
     81c:	74656734 	strbtvc	r6, [r5], #-1844	; 0xfffff8cc
     820:	6369745f 	cmnvs	r9, #1593835520	; 0x5f000000
     824:	6f635f6b 	svcvs	0x00635f6b
     828:	76746e75 			; <UNDEFINED> instruction: 0x76746e75
     82c:	676f6c00 	strbvs	r6, [pc, -r0, lsl #24]!
     830:	6c616369 	stclvs	3, cr6, [r1], #-420	; 0xfffffe5c
     834:	6572625f 	ldrbvs	r6, [r2, #-607]!	; 0xfffffda1
     838:	48006b61 	stmdami	r0, {r0, r5, r6, r8, r9, fp, sp, lr}
     83c:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     840:	72505f65 	subsvc	r5, r0, #404	; 0x194
     844:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     848:	57535f73 			; <UNDEFINED> instruction: 0x57535f73
     84c:	6c730049 	ldclvs	0, cr0, [r3], #-292	; 0xfffffedc
     850:	00706565 	rsbseq	r6, r0, r5, ror #10
     854:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     858:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
     85c:	4644455f 			; <UNDEFINED> instruction: 0x4644455f
     860:	69615700 	stmdbvs	r1!, {r8, r9, sl, ip, lr}^
     864:	69440074 	stmdbvs	r4, {r2, r4, r5, r6}^
     868:	6c626173 	stfvse	f6, [r2], #-460	; 0xfffffe34
     86c:	76455f65 	strbvc	r5, [r5], -r5, ror #30
     870:	5f746e65 	svcpl	0x00746e65
     874:	65746544 	ldrbvs	r6, [r4, #-1348]!	; 0xfffffabc
     878:	6f697463 	svcvs	0x00697463
     87c:	5a5f006e 	bpl	17c0a3c <__bss_end+0x17b6fbc>
     880:	72657439 	rsbvc	r7, r5, #956301312	; 0x39000000
     884:	616e696d 	cmnvs	lr, sp, ror #18
     888:	00696574 	rsbeq	r6, r9, r4, ror r5
     88c:	65746e49 	ldrbvs	r6, [r4, #-3657]!	; 0xfffff1b7
     890:	70757272 	rsbsvc	r7, r5, r2, ror r2
     894:	6c626174 	stfvse	f6, [r2], #-464	; 0xfffffe30
     898:	6c535f65 	mrrcvs	15, 6, r5, r3, cr5
     89c:	00706565 	rsbseq	r6, r0, r5, ror #10
     8a0:	7265706f 	rsbvc	r7, r5, #111	; 0x6f
     8a4:	6f697461 	svcvs	0x00697461
     8a8:	5a5f006e 	bpl	17c0a68 <__bss_end+0x17b6fe8>
     8ac:	6f6c6335 	svcvs	0x006c6335
     8b0:	006a6573 	rsbeq	r6, sl, r3, ror r5
     8b4:	73614c6d 	cmnvc	r1, #27904	; 0x6d00
     8b8:	49505f74 	ldmdbmi	r0, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     8bc:	6c420044 	mcrrvs	0, 4, r0, r2, cr4
     8c0:	656b636f 	strbvs	r6, [fp, #-879]!	; 0xfffffc91
     8c4:	474e0064 	strbmi	r0, [lr, -r4, rrx]
     8c8:	535f7465 	cmppl	pc, #1694498816	; 0x65000000
     8cc:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     8d0:	666e495f 			; <UNDEFINED> instruction: 0x666e495f
     8d4:	79545f6f 	ldmdbvc	r4, {r0, r1, r2, r3, r5, r6, r8, r9, sl, fp, ip, lr}^
     8d8:	5f006570 	svcpl	0x00006570
     8dc:	6567365a 	strbvs	r3, [r7, #-1626]!	; 0xfffff9a6
     8e0:	64697074 	strbtvs	r7, [r9], #-116	; 0xffffff8c
     8e4:	6e660076 	mcrvs	0, 3, r0, cr6, cr6, {3}
     8e8:	00656d61 	rsbeq	r6, r5, r1, ror #26
     8ec:	6e6e7552 	mcrvs	5, 3, r7, cr14, cr2, {2}
     8f0:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
     8f4:	61544e00 	cmpvs	r4, r0, lsl #28
     8f8:	535f6b73 	cmppl	pc, #117760	; 0x1cc00
     8fc:	65746174 	ldrbvs	r6, [r4, #-372]!	; 0xfffffe8c
     900:	68637300 	stmdavs	r3!, {r8, r9, ip, sp, lr}^
     904:	635f6465 	cmpvs	pc, #1694498816	; 0x65000000
     908:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
     90c:	47007265 	strmi	r7, [r0, -r5, ror #4]
     910:	4320554e 			; <UNDEFINED> instruction: 0x4320554e
     914:	34312b2b 	ldrtcc	r2, [r1], #-2859	; 0xfffff4d5
     918:	2e303120 	rsfcssp	f3, f0, f0
     91c:	20312e33 	eorscs	r2, r1, r3, lsr lr
     920:	31323032 	teqcc	r2, r2, lsr r0
     924:	31323630 	teqcc	r2, r0, lsr r6
     928:	65722820 	ldrbvs	r2, [r2, #-2080]!	; 0xfffff7e0
     92c:	7361656c 	cmnvc	r1, #108, 10	; 0x1b000000
     930:	2d202965 			; <UNDEFINED> instruction: 0x2d202965
     934:	6f6c666d 	svcvs	0x006c666d
     938:	612d7461 			; <UNDEFINED> instruction: 0x612d7461
     93c:	683d6962 	ldmdavs	sp!, {r1, r5, r6, r8, fp, sp, lr}
     940:	20647261 	rsbcs	r7, r4, r1, ror #4
     944:	70666d2d 	rsbvc	r6, r6, sp, lsr #26
     948:	66763d75 			; <UNDEFINED> instruction: 0x66763d75
     94c:	6d2d2070 	stcvs	0, cr2, [sp, #-448]!	; 0xfffffe40
     950:	616f6c66 	cmnvs	pc, r6, ror #24
     954:	62612d74 	rsbvs	r2, r1, #116, 26	; 0x1d00
     958:	61683d69 	cmnvs	r8, r9, ror #26
     95c:	2d206472 	cfstrscs	mvf6, [r0, #-456]!	; 0xfffffe38
     960:	7570666d 	ldrbvc	r6, [r0, #-1645]!	; 0xfffff993
     964:	7066763d 	rsbvc	r7, r6, sp, lsr r6
     968:	746d2d20 	strbtvc	r2, [sp], #-3360	; 0xfffff2e0
     96c:	3d656e75 	stclcc	14, cr6, [r5, #-468]!	; 0xfffffe2c
     970:	316d7261 	cmncc	sp, r1, ror #4
     974:	6a363731 	bvs	d8e640 <__bss_end+0xd84bc0>
     978:	732d667a 			; <UNDEFINED> instruction: 0x732d667a
     97c:	616d2d20 	cmnvs	sp, r0, lsr #26
     980:	2d206d72 	stccs	13, cr6, [r0, #-456]!	; 0xfffffe38
     984:	6372616d 	cmnvs	r2, #1073741851	; 0x4000001b
     988:	72613d68 	rsbvc	r3, r1, #104, 26	; 0x1a00
     98c:	7a36766d 	bvc	d9e348 <__bss_end+0xd948c8>
     990:	70662b6b 	rsbvc	r2, r6, fp, ror #22
     994:	20672d20 	rsbcs	r2, r7, r0, lsr #26
     998:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
     99c:	4f2d2067 	svcmi	0x002d2067
     9a0:	4f2d2030 	svcmi	0x002d2030
     9a4:	662d2030 			; <UNDEFINED> instruction: 0x662d2030
     9a8:	652d6f6e 	strvs	r6, [sp, #-3950]!	; 0xfffff092
     9ac:	70656378 	rsbvc	r6, r5, r8, ror r3
     9b0:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     9b4:	662d2073 			; <UNDEFINED> instruction: 0x662d2073
     9b8:	722d6f6e 	eorvc	r6, sp, #440	; 0x1b8
     9bc:	00697474 	rsbeq	r7, r9, r4, ror r4
     9c0:	74697277 	strbtvc	r7, [r9], #-631	; 0xfffffd89
     9c4:	78650065 	stmdavc	r5!, {r0, r2, r5, r6}^
     9c8:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
     9cc:	0065646f 	rsbeq	r6, r5, pc, ror #8
     9d0:	314e5a5f 	cmpcc	lr, pc, asr sl
     9d4:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     9d8:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     9dc:	614d5f73 	hvcvs	54771	; 0xd5f3
     9e0:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     9e4:	62533472 	subsvs	r3, r3, #1912602624	; 0x72000000
     9e8:	6a456b72 	bvs	115b7b8 <__bss_end+0x1151d38>
     9ec:	68637300 	stmdavs	r3!, {r8, r9, ip, sp, lr}^
     9f0:	735f6465 	cmpvc	pc, #1694498816	; 0x65000000
     9f4:	69746174 	ldmdbvs	r4!, {r2, r4, r5, r6, r8, sp, lr}^
     9f8:	72705f63 	rsbsvc	r5, r0, #396	; 0x18c
     9fc:	69726f69 	ldmdbvs	r2!, {r0, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
     a00:	74007974 	strvc	r7, [r0], #-2420	; 0xfffff68c
     a04:	736b6369 	cmnvc	fp, #-1543503871	; 0xa4000001
     a08:	63536d00 	cmpvs	r3, #0, 26
     a0c:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
     a10:	465f656c 	ldrbmi	r6, [pc], -ip, ror #10
     a14:	6f00636e 	svcvs	0x0000636e
     a18:	006e6570 	rsbeq	r6, lr, r0, ror r5
     a1c:	70345a5f 	eorsvc	r5, r4, pc, asr sl
     a20:	50657069 	rsbpl	r7, r5, r9, rrx
     a24:	006a634b 	rsbeq	r6, sl, fp, asr #6
     a28:	6165444e 	cmnvs	r5, lr, asr #8
     a2c:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
     a30:	75535f65 	ldrbvc	r5, [r3, #-3941]	; 0xfffff09b
     a34:	72657362 	rsbvc	r7, r5, #-2013265919	; 0x88000001
     a38:	65636976 	strbvs	r6, [r3, #-2422]!	; 0xfffff68a
     a3c:	74656700 	strbtvc	r6, [r5], #-1792	; 0xfffff900
     a40:	6369745f 	cmnvs	r9, #1593835520	; 0x5f000000
     a44:	6f635f6b 	svcvs	0x00635f6b
     a48:	00746e75 	rsbseq	r6, r4, r5, ror lr
     a4c:	69746f4e 	ldmdbvs	r4!, {r1, r2, r3, r6, r8, r9, sl, fp, sp, lr}^
     a50:	70007966 	andvc	r7, r0, r6, ror #18
     a54:	6d617261 	sfmvs	f7, 2, [r1, #-388]!	; 0xfffffe7c
     a58:	355a5f00 	ldrbcc	r5, [sl, #-3840]	; 0xfffff100
     a5c:	74697277 	strbtvc	r7, [r9], #-631	; 0xfffffd89
     a60:	4b506a65 	blmi	141b3fc <__bss_end+0x141197c>
     a64:	52006a63 	andpl	r6, r0, #405504	; 0x63000
     a68:	69466e75 	stmdbvs	r6, {r0, r2, r4, r5, r6, r9, sl, fp, sp, lr}^
     a6c:	54747372 	ldrbtpl	r7, [r4], #-882	; 0xfffffc8e
     a70:	006b7361 	rsbeq	r7, fp, r1, ror #6
     a74:	5f746567 	svcpl	0x00746567
     a78:	6b736174 	blvs	1cd9050 <__bss_end+0x1ccf5d0>
     a7c:	6369745f 	cmnvs	r9, #1593835520	; 0x5f000000
     a80:	745f736b 	ldrbvc	r7, [pc], #-875	; a88 <shift+0xa88>
     a84:	65645f6f 	strbvs	r5, [r4, #-3951]!	; 0xfffff091
     a88:	696c6461 	stmdbvs	ip!, {r0, r5, r6, sl, sp, lr}^
     a8c:	6200656e 	andvs	r6, r0, #461373440	; 0x1b800000
     a90:	735f6675 	cmpvc	pc, #122683392	; 0x7500000
     a94:	00657a69 	rsbeq	r7, r5, r9, ror #20
     a98:	73796870 	cmnvc	r9, #112, 16	; 0x700000
     a9c:	6c616369 	stclvs	3, cr6, [r1], #-420	; 0xfffffe5c
     aa0:	6572625f 	ldrbvs	r6, [r2, #-607]!	; 0xfffffda1
     aa4:	52006b61 	andpl	r6, r0, #99328	; 0x18400
     aa8:	5f646165 	svcpl	0x00646165
     aac:	74697257 	strbtvc	r7, [r9], #-599	; 0xfffffda9
     ab0:	6f5a0065 	svcvs	0x005a0065
     ab4:	6569626d 	strbvs	r6, [r9, #-621]!	; 0xfffffd93
     ab8:	6f682f00 	svcvs	0x00682f00
     abc:	742f656d 	strtvc	r6, [pc], #-1389	; ac4 <shift+0xac4>
     ac0:	69666572 	stmdbvs	r6!, {r1, r4, r5, r6, r8, sl, sp, lr}^
     ac4:	65732f6c 	ldrbvs	r2, [r3, #-3948]!	; 0xfffff094
     ac8:	6f732f6d 	svcvs	0x00732f6d
     acc:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
     ad0:	75622f73 	strbvc	r2, [r2, #-3955]!	; 0xfffff08d
     ad4:	00646c69 	rsbeq	r6, r4, r9, ror #24
     ad8:	5f746547 	svcpl	0x00746547
     adc:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     ae0:	6e495f64 	cdpvs	15, 4, cr5, cr9, cr4, {3}
     ae4:	73006f66 	movwvc	r6, #3942	; 0xf66
     ae8:	745f7465 	ldrbvc	r7, [pc], #-1125	; af0 <shift+0xaf0>
     aec:	5f6b7361 	svcpl	0x006b7361
     af0:	64616564 	strbtvs	r6, [r1], #-1380	; 0xfffffa9c
     af4:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
     af8:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     afc:	50433631 	subpl	r3, r3, r1, lsr r6
     b00:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     b04:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 940 <shift+0x940>
     b08:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     b0c:	53387265 	teqpl	r8, #1342177286	; 0x50000006
     b10:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     b14:	45656c75 	strbmi	r6, [r5, #-3189]!	; 0xfffff38b
     b18:	5a5f0076 	bpl	17c0cf8 <__bss_end+0x17b7278>
     b1c:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     b20:	636f7250 	cmnvs	pc, #80, 4
     b24:	5f737365 	svcpl	0x00737365
     b28:	616e614d 	cmnvs	lr, sp, asr #2
     b2c:	31726567 	cmncc	r2, r7, ror #10
     b30:	70614d39 	rsbvc	r4, r1, r9, lsr sp
     b34:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     b38:	6f545f65 	svcvs	0x00545f65
     b3c:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
     b40:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     b44:	49355045 	ldmdbmi	r5!, {r0, r2, r6, ip, lr}
     b48:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     b4c:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     b50:	7261505f 	rsbvc	r5, r1, #95	; 0x5f
     b54:	00736d61 	rsbseq	r6, r3, r1, ror #26
     b58:	314e5a5f 	cmpcc	lr, pc, asr sl
     b5c:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     b60:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     b64:	614d5f73 	hvcvs	54771	; 0xd5f3
     b68:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     b6c:	53323172 	teqpl	r2, #-2147483620	; 0x8000001c
     b70:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     b74:	5f656c75 	svcpl	0x00656c75
     b78:	45464445 	strbmi	r4, [r6, #-1093]	; 0xfffffbbb
     b7c:	5a5f0076 	bpl	17c0d5c <__bss_end+0x17b72dc>
     b80:	656c7335 	strbvs	r7, [ip, #-821]!	; 0xfffffccb
     b84:	6a6a7065 	bvs	1a9cd20 <__bss_end+0x1a932a0>
     b88:	6c696600 	stclvs	6, cr6, [r9], #-0
     b8c:	65470065 	strbvs	r0, [r7, #-101]	; 0xffffff9b
     b90:	65525f74 	ldrbvs	r5, [r2, #-3956]	; 0xfffff08c
     b94:	6e69616d 	powvsez	f6, f1, #5.0
     b98:	00676e69 	rsbeq	r6, r7, r9, ror #28
     b9c:	62616e45 	rsbvs	r6, r1, #1104	; 0x450
     ba0:	455f656c 	ldrbmi	r6, [pc, #-1388]	; 63c <shift+0x63c>
     ba4:	746e6576 	strbtvc	r6, [lr], #-1398	; 0xfffffa8a
     ba8:	7465445f 	strbtvc	r4, [r5], #-1119	; 0xfffffba1
     bac:	69746365 	ldmdbvs	r4!, {r0, r2, r5, r6, r8, r9, sp, lr}^
     bb0:	5f006e6f 	svcpl	0x00006e6f
     bb4:	6736325a 			; <UNDEFINED> instruction: 0x6736325a
     bb8:	745f7465 	ldrbvc	r7, [pc], #-1125	; bc0 <shift+0xbc0>
     bbc:	5f6b7361 	svcpl	0x006b7361
     bc0:	6b636974 	blvs	18db198 <__bss_end+0x18d1718>
     bc4:	6f745f73 	svcvs	0x00745f73
     bc8:	6165645f 	cmnvs	r5, pc, asr r4
     bcc:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
     bd0:	2f007665 	svccs	0x00007665
     bd4:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
     bd8:	6572742f 	ldrbvs	r7, [r2, #-1071]!	; 0xfffffbd1
     bdc:	2f6c6966 	svccs	0x006c6966
     be0:	2f6d6573 	svccs	0x006d6573
     be4:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
     be8:	2f736563 	svccs	0x00736563
     bec:	6c647473 	cfstrdvs	mvd7, [r4], #-460	; 0xfffffe34
     bf0:	732f6269 			; <UNDEFINED> instruction: 0x732f6269
     bf4:	732f6372 			; <UNDEFINED> instruction: 0x732f6372
     bf8:	69666474 	stmdbvs	r6!, {r2, r4, r5, r6, sl, sp, lr}^
     bfc:	632e656c 			; <UNDEFINED> instruction: 0x632e656c
     c00:	4e007070 	mcrmi	0, 0, r7, cr0, cr0, {3}
     c04:	5f495753 	svcpl	0x00495753
     c08:	75736552 	ldrbvc	r6, [r3, #-1362]!	; 0xfffffaae
     c0c:	435f746c 	cmpmi	pc, #108, 8	; 0x6c000000
     c10:	0065646f 	rsbeq	r6, r5, pc, ror #8
     c14:	6e6e7552 	mcrvs	5, 3, r7, cr14, cr2, {2}
     c18:	00676e69 	rsbeq	r6, r7, r9, ror #28
     c1c:	756e7277 	strbvc	r7, [lr, #-631]!	; 0xfffffd89
     c20:	5a5f006d 	bpl	17c0ddc <__bss_end+0x17b735c>
     c24:	69617734 	stmdbvs	r1!, {r2, r4, r5, r8, r9, sl, ip, sp, lr}^
     c28:	6a6a6a74 	bvs	1a9b600 <__bss_end+0x1a91b80>
     c2c:	355a5f00 	ldrbcc	r5, [sl, #-3840]	; 0xfffff100
     c30:	74636f69 	strbtvc	r6, [r3], #-3945	; 0xfffff097
     c34:	36316a6c 	ldrtcc	r6, [r1], -ip, ror #20
     c38:	434f494e 	movtmi	r4, #63822	; 0xf94e
     c3c:	4f5f6c74 	svcmi	0x005f6c74
     c40:	61726570 	cmnvs	r2, r0, ror r5
     c44:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     c48:	69007650 	stmdbvs	r0, {r4, r6, r9, sl, ip, sp, lr}
     c4c:	6c74636f 	ldclvs	3, cr6, [r4], #-444	; 0xfffffe44
     c50:	74657200 	strbtvc	r7, [r5], #-512	; 0xfffffe00
     c54:	00746e63 	rsbseq	r6, r4, r3, ror #28
     c58:	7275436d 	rsbsvc	r4, r5, #-1275068415	; 0xb4000001
     c5c:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     c60:	7361545f 	cmnvc	r1, #1593835520	; 0x5f000000
     c64:	6f4e5f6b 	svcvs	0x004e5f6b
     c68:	6e006564 	cfsh32vs	mvfx6, mvfx0, #52
     c6c:	6669746f 	strbtvs	r7, [r9], -pc, ror #8
     c70:	65740079 	ldrbvs	r0, [r4, #-121]!	; 0xffffff87
     c74:	6e696d72 	mcrvs	13, 3, r6, cr9, cr2, {3}
     c78:	00657461 	rsbeq	r7, r5, r1, ror #8
     c7c:	65646f6d 	strbvs	r6, [r4, #-3949]!	; 0xfffff093
     c80:	75706300 	ldrbvc	r6, [r0, #-768]!	; 0xfffffd00
     c84:	6e6f635f 	mcrvs	3, 3, r6, cr15, cr15, {2}
     c88:	74786574 	ldrbtvc	r6, [r8], #-1396	; 0xfffffa8c
     c8c:	61655200 	cmnvs	r5, r0, lsl #4
     c90:	6e4f5f64 	cdpvs	15, 4, cr5, cr15, cr4, {3}
     c94:	6200796c 	andvs	r7, r0, #108, 18	; 0x1b0000
     c98:	65666675 	strbvs	r6, [r6, #-1653]!	; 0xfffff98b
     c9c:	6c730072 	ldclvs	0, cr0, [r3], #-456	; 0xfffffe38
     ca0:	5f706565 	svcpl	0x00706565
     ca4:	656d6974 	strbvs	r6, [sp, #-2420]!	; 0xfffff68c
     ca8:	5a5f0072 	bpl	17c0e78 <__bss_end+0x17b73f8>
     cac:	36314b4e 	ldrtcc	r4, [r1], -lr, asr #22
     cb0:	6f725043 	svcvs	0x00725043
     cb4:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     cb8:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     cbc:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     cc0:	65473831 	strbvs	r3, [r7, #-2097]	; 0xfffff7cf
     cc4:	72505f74 	subsvc	r5, r0, #116, 30	; 0x1d0
     cc8:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     ccc:	79425f73 	stmdbvc	r2, {r0, r1, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     cd0:	4449505f 	strbmi	r5, [r9], #-95	; 0xffffffa1
     cd4:	48006a45 	stmdami	r0, {r0, r2, r6, r9, fp, sp, lr}
     cd8:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     cdc:	69465f65 	stmdbvs	r6, {r0, r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     ce0:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
     ce4:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
     ce8:	4957535f 	ldmdbmi	r7, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     cec:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     cf0:	50433631 	subpl	r3, r3, r1, lsr r6
     cf4:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     cf8:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; b34 <shift+0xb34>
     cfc:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     d00:	31317265 	teqcc	r1, r5, ror #4
     d04:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     d08:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
     d0c:	4552525f 	ldrbmi	r5, [r2, #-607]	; 0xfffffda1
     d10:	61740076 	cmnvs	r4, r6, ror r0
     d14:	5f006b73 	svcpl	0x00006b73
     d18:	6572345a 	ldrbvs	r3, [r2, #-1114]!	; 0xfffffba6
     d1c:	506a6461 	rsbpl	r6, sl, r1, ror #8
     d20:	53006a63 	movwpl	r6, #2659	; 0xa63
     d24:	006b7262 	rsbeq	r7, fp, r2, ror #4
     d28:	69746f4e 	ldmdbvs	r4!, {r1, r2, r3, r6, r8, r9, sl, fp, sp, lr}^
     d2c:	505f7966 	subspl	r7, pc, r6, ror #18
     d30:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     d34:	53007373 	movwpl	r7, #883	; 0x373
     d38:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     d3c:	00656c75 	rsbeq	r6, r5, r5, ror ip
     d40:	314e5a5f 	cmpcc	lr, pc, asr sl
     d44:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     d48:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     d4c:	614d5f73 	hvcvs	54771	; 0xd5f3
     d50:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     d54:	77533972 			; <UNDEFINED> instruction: 0x77533972
     d58:	68637469 	stmdavs	r3!, {r0, r3, r5, r6, sl, ip, sp, lr}^
     d5c:	456f545f 	strbmi	r5, [pc, #-1119]!	; 905 <shift+0x905>
     d60:	43383150 	teqmi	r8, #80, 2
     d64:	636f7250 	cmnvs	pc, #80, 4
     d68:	5f737365 	svcpl	0x00737365
     d6c:	7473694c 	ldrbtvc	r6, [r3], #-2380	; 0xfffff6b4
     d70:	646f4e5f 	strbtvs	r4, [pc], #-3679	; d78 <shift+0xd78>
     d74:	63530065 	cmpvs	r3, #101	; 0x65
     d78:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
     d7c:	525f656c 	subspl	r6, pc, #108, 10	; 0x1b000000
     d80:	5a5f0052 	bpl	17c0ed0 <__bss_end+0x17b7450>
     d84:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     d88:	636f7250 	cmnvs	pc, #80, 4
     d8c:	5f737365 	svcpl	0x00737365
     d90:	616e614d 	cmnvs	lr, sp, asr #2
     d94:	31726567 	cmncc	r2, r7, ror #10
     d98:	6e614838 	mcrvs	8, 3, r4, cr1, cr8, {1}
     d9c:	5f656c64 	svcpl	0x00656c64
     da0:	636f7250 	cmnvs	pc, #80, 4
     da4:	5f737365 	svcpl	0x00737365
     da8:	45495753 	strbmi	r5, [r9, #-1875]	; 0xfffff8ad
     dac:	534e3032 	movtpl	r3, #57394	; 0xe032
     db0:	505f4957 	subspl	r4, pc, r7, asr r9	; <UNPREDICTABLE>
     db4:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     db8:	535f7373 	cmppl	pc, #-872415231	; 0xcc000001
     dbc:	69767265 	ldmdbvs	r6!, {r0, r2, r5, r6, r9, ip, sp, lr}^
     dc0:	6a6a6563 	bvs	1a9a354 <__bss_end+0x1a908d4>
     dc4:	3131526a 	teqcc	r1, sl, ror #4
     dc8:	49575354 	ldmdbmi	r7, {r2, r4, r6, r8, r9, ip, lr}^
     dcc:	7365525f 	cmnvc	r5, #-268435451	; 0xf0000005
     dd0:	00746c75 	rsbseq	r6, r4, r5, ror ip
     dd4:	434f494e 	movtmi	r4, #63822	; 0xf94e
     dd8:	4f5f6c74 	svcmi	0x005f6c74
     ddc:	61726570 	cmnvs	r2, r0, ror r5
     de0:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     de4:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     de8:	50433631 	subpl	r3, r3, r1, lsr r6
     dec:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     df0:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; c2c <shift+0xc2c>
     df4:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     df8:	34317265 	ldrtcc	r7, [r1], #-613	; 0xfffffd9b
     dfc:	61657243 	cmnvs	r5, r3, asr #4
     e00:	505f6574 	subspl	r6, pc, r4, ror r5	; <UNPREDICTABLE>
     e04:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     e08:	50457373 	subpl	r7, r5, r3, ror r3
     e0c:	00626a68 	rsbeq	r6, r2, r8, ror #20
     e10:	74697753 	strbtvc	r7, [r9], #-1875	; 0xfffff8ad
     e14:	545f6863 	ldrbpl	r6, [pc], #-2147	; e1c <shift+0xe1c>
     e18:	534e006f 	movtpl	r0, #57455	; 0xe06f
     e1c:	465f4957 			; <UNDEFINED> instruction: 0x465f4957
     e20:	73656c69 	cmnvc	r5, #26880	; 0x6900
     e24:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     e28:	65535f6d 	ldrbvs	r5, [r3, #-3949]	; 0xfffff093
     e2c:	63697672 	cmnvs	r9, #119537664	; 0x7200000
     e30:	65720065 	ldrbvs	r0, [r2, #-101]!	; 0xffffff9b
     e34:	646f6374 	strbtvs	r6, [pc], #-884	; e3c <shift+0xe3c>
     e38:	65670065 	strbvs	r0, [r7, #-101]!	; 0xffffff9b
     e3c:	63615f74 	cmnvs	r1, #116, 30	; 0x1d0
     e40:	65766974 	ldrbvs	r6, [r6, #-2420]!	; 0xfffff68c
     e44:	6f72705f 	svcvs	0x0072705f
     e48:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     e4c:	756f635f 	strbvc	r6, [pc, #-863]!	; af5 <shift+0xaf5>
     e50:	6600746e 	strvs	r7, [r0], -lr, ror #8
     e54:	6e656c69 	cdpvs	12, 6, cr6, cr5, cr9, {3}
     e58:	00656d61 	rsbeq	r6, r5, r1, ror #26
     e5c:	65657246 	strbvs	r7, [r5, #-582]!	; 0xfffffdba
     e60:	61657200 	cmnvs	r5, r0, lsl #4
     e64:	6c430064 	mcrrvs	0, 6, r0, r3, cr4
     e68:	0065736f 	rsbeq	r7, r5, pc, ror #6
     e6c:	70616568 	rsbvc	r6, r1, r8, ror #10
     e70:	6174735f 	cmnvs	r4, pc, asr r3
     e74:	67007472 	smlsdxvs	r0, r2, r4, r7
     e78:	69707465 	ldmdbvs	r0!, {r0, r2, r5, r6, sl, ip, sp, lr}^
     e7c:	5a5f0064 	bpl	17c1014 <__bss_end+0x17b7594>
     e80:	65706f34 	ldrbvs	r6, [r0, #-3892]!	; 0xfffff0cc
     e84:	634b506e 	movtvs	r5, #45166	; 0xb06e
     e88:	464e3531 			; <UNDEFINED> instruction: 0x464e3531
     e8c:	5f656c69 	svcpl	0x00656c69
     e90:	6e65704f 	cdpvs	0, 6, cr7, cr5, cr15, {2}
     e94:	646f4d5f 	strbtvs	r4, [pc], #-3423	; e9c <shift+0xe9c>
     e98:	72570065 	subsvc	r0, r7, #101	; 0x65
     e9c:	5f657469 	svcpl	0x00657469
     ea0:	796c6e4f 	stmdbvc	ip!, {r0, r1, r2, r3, r6, r9, sl, fp, sp, lr}^
     ea4:	65695900 	strbvs	r5, [r9, #-2304]!	; 0xfffff700
     ea8:	5f00646c 	svcpl	0x0000646c
     eac:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     eb0:	6f725043 	svcvs	0x00725043
     eb4:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     eb8:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     ebc:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     ec0:	76453443 	strbvc	r3, [r5], -r3, asr #8
     ec4:	72655400 	rsbvc	r5, r5, #0, 8
     ec8:	616e696d 	cmnvs	lr, sp, ror #18
     ecc:	49006574 	stmdbmi	r0, {r2, r4, r5, r6, r8, sl, sp, lr}
     ed0:	6c74434f 	ldclvs	3, cr4, [r4], #-316	; 0xfffffec4
     ed4:	375a5f00 	ldrbcc	r5, [sl, -r0, lsl #30]
     ed8:	6e727473 	mrcvs	4, 3, r7, cr2, cr3, {3}
     edc:	50797063 	rsbspl	r7, r9, r3, rrx
     ee0:	634b5063 	movtvs	r5, #45155	; 0xb063
     ee4:	5a5f0069 	bpl	17c1090 <__bss_end+0x17b7610>
     ee8:	6d656d36 	stclvs	13, cr6, [r5, #-216]!	; 0xffffff28
     eec:	50797063 	rsbspl	r7, r9, r3, rrx
     ef0:	7650764b 	ldrbvc	r7, [r0], -fp, asr #12
     ef4:	5a5f0069 	bpl	17c10a0 <__bss_end+0x17b7620>
     ef8:	65673431 	strbvs	r3, [r7, #-1073]!	; 0xfffffbcf
     efc:	6e695f74 	mcrvs	15, 3, r5, cr9, cr4, {3}
     f00:	5f747570 	svcpl	0x00747570
     f04:	65707974 	ldrbvs	r7, [r0, #-2420]!	; 0xfffff68c
     f08:	00634b50 	rsbeq	r4, r3, r0, asr fp
     f0c:	6e345a5f 			; <UNDEFINED> instruction: 0x6e345a5f
     f10:	6975745f 	ldmdbvs	r5!, {r0, r1, r2, r3, r4, r6, sl, ip, sp, lr}^
     f14:	74610069 	strbtvc	r0, [r1], #-105	; 0xffffff97
     f18:	6700666f 	strvs	r6, [r0, -pc, ror #12]
     f1c:	695f7465 	ldmdbvs	pc, {r0, r2, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
     f20:	7475706e 	ldrbtvc	r7, [r5], #-110	; 0xffffff92
     f24:	7079745f 	rsbsvc	r7, r9, pc, asr r4
     f28:	74610065 	strbtvc	r0, [r1], #-101	; 0xffffff9b
     f2c:	5f00696f 	svcpl	0x0000696f
     f30:	7461345a 	strbtvc	r3, [r1], #-1114	; 0xfffffba6
     f34:	4b50666f 	blmi	141a8f8 <__bss_end+0x1410e78>
     f38:	65640063 	strbvs	r0, [r4, #-99]!	; 0xffffff9d
     f3c:	69007473 	stmdbvs	r0, {r0, r1, r4, r5, r6, sl, ip, sp, lr}
     f40:	7475706e 	ldrbtvc	r7, [r5], #-110	; 0xffffff92
     f44:	67697300 	strbvs	r7, [r9, -r0, lsl #6]!
     f48:	7473006e 	ldrbtvc	r0, [r3], #-110	; 0xffffff92
     f4c:	74616372 	strbtvc	r6, [r1], #-882	; 0xfffffc8e
     f50:	355a5f00 	ldrbcc	r5, [sl, #-3840]	; 0xfffff100
     f54:	72657a62 	rsbvc	r7, r5, #401408	; 0x62000
     f58:	6976506f 	ldmdbvs	r6!, {r0, r1, r2, r3, r5, r6, ip, lr}^
     f5c:	72747300 	rsbsvc	r7, r4, #0, 6
     f60:	7970636e 	ldmdbvc	r0!, {r1, r2, r3, r5, r6, r8, r9, sp, lr}^
     f64:	365a5f00 	ldrbcc	r5, [sl], -r0, lsl #30
     f68:	63727473 	cmnvs	r2, #1929379840	; 0x73000000
     f6c:	63507461 	cmpvs	r0, #1627389952	; 0x61000000
     f70:	00634b50 	rsbeq	r4, r3, r0, asr fp
     f74:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; ec0 <shift+0xec0>
     f78:	72742f65 	rsbsvc	r2, r4, #404	; 0x194
     f7c:	6c696665 	stclvs	6, cr6, [r9], #-404	; 0xfffffe6c
     f80:	6d65732f 	stclvs	3, cr7, [r5, #-188]!	; 0xffffff44
     f84:	756f732f 	strbvc	r7, [pc, #-815]!	; c5d <shift+0xc5d>
     f88:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
     f8c:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
     f90:	2f62696c 	svccs	0x0062696c
     f94:	2f637273 	svccs	0x00637273
     f98:	73647473 	cmnvc	r4, #1929379840	; 0x73000000
     f9c:	6e697274 	mcrvs	2, 3, r7, cr9, cr4, {3}
     fa0:	70632e67 	rsbvc	r2, r3, r7, ror #28
     fa4:	74730070 	ldrbtvc	r0, [r3], #-112	; 0xffffff90
     fa8:	61636e72 	smcvs	14050	; 0x36e2
     fac:	61770074 	cmnvs	r7, r4, ror r0
     fb0:	72656b6c 	rsbvc	r6, r5, #108, 22	; 0x1b000
     fb4:	63616600 	cmnvs	r1, #0, 12
     fb8:	00726f74 	rsbseq	r6, r2, r4, ror pc
     fbc:	616f7469 	cmnvs	pc, r9, ror #8
     fc0:	736f7000 	cmnvc	pc, #0
     fc4:	6f697469 	svcvs	0x00697469
     fc8:	656d006e 	strbvs	r0, [sp, #-110]!	; 0xffffff92
     fcc:	7473646d 	ldrbtvc	r6, [r3], #-1133	; 0xfffffb93
     fd0:	61684300 	cmnvs	r8, r0, lsl #6
     fd4:	6e6f4372 	mcrvs	3, 3, r4, cr15, cr2, {3}
     fd8:	72724176 	rsbsvc	r4, r2, #-2147483619	; 0x8000001d
     fdc:	6f746600 	svcvs	0x00746600
     fe0:	756e0061 	strbvc	r0, [lr, #-97]!	; 0xffffff9f
     fe4:	7265626d 	rsbvc	r6, r5, #-805306362	; 0xd0000006
     fe8:	6d656d00 	stclvs	13, cr6, [r5, #-0]
     fec:	00637273 	rsbeq	r7, r3, r3, ror r2
     ff0:	626d756e 	rsbvs	r7, sp, #461373440	; 0x1b800000
     ff4:	00327265 	eorseq	r7, r2, r5, ror #4
     ff8:	65746661 	ldrbvs	r6, [r4, #-1633]!	; 0xfffff99f
     ffc:	63654472 	cmnvs	r5, #1912602624	; 0x72000000
    1000:	6e696f50 	mcrvs	15, 3, r6, cr9, cr0, {2}
    1004:	7a620074 	bvc	18811dc <__bss_end+0x187775c>
    1008:	006f7265 	rsbeq	r7, pc, r5, ror #4
    100c:	636d656d 	cmnvs	sp, #457179136	; 0x1b400000
    1010:	73007970 	movwvc	r7, #2416	; 0x970
    1014:	636e7274 	cmnvs	lr, #116, 4	; 0x40000007
    1018:	7400706d 	strvc	r7, [r0], #-109	; 0xffffff93
    101c:	6c696172 	stfvse	f6, [r9], #-456	; 0xfffffe38
    1020:	5f676e69 	svcpl	0x00676e69
    1024:	00746f64 	rsbseq	r6, r4, r4, ror #30
    1028:	7074756f 	rsbsvc	r7, r4, pc, ror #10
    102c:	6c007475 	cfstrsvs	mvf7, [r0], {117}	; 0x75
    1030:	74676e65 	strbtvc	r6, [r7], #-3685	; 0xfffff19b
    1034:	6e003268 	cdpvs	2, 0, cr3, cr0, cr8, {3}
    1038:	0075745f 	rsbseq	r7, r5, pc, asr r4
    103c:	73365a5f 	teqvc	r6, #389120	; 0x5f000
    1040:	656c7274 	strbvs	r7, [ip, #-628]!	; 0xfffffd8c
    1044:	634b506e 	movtvs	r5, #45166	; 0xb06e
    1048:	375a5f00 	ldrbcc	r5, [sl, -r0, lsl #30]
    104c:	6e727473 	mrcvs	4, 3, r7, cr2, cr3, {3}
    1050:	50706d63 	rsbspl	r6, r0, r3, ror #26
    1054:	3053634b 	subscc	r6, r3, fp, asr #6
    1058:	5f00695f 	svcpl	0x0000695f
    105c:	7461345a 	strbtvc	r3, [r1], #-1114	; 0xfffffba6
    1060:	4b50696f 	blmi	141b624 <__bss_end+0x1411ba4>
    1064:	5a5f0063 	bpl	17c11f8 <__bss_end+0x17b7778>
    1068:	6f746934 	svcvs	0x00746934
    106c:	63506961 	cmpvs	r0, #1589248	; 0x184000
    1070:	5a5f006a 	bpl	17c1220 <__bss_end+0x17b77a0>
    1074:	6f746634 	svcvs	0x00746634
    1078:	63506661 	cmpvs	r0, #101711872	; 0x6100000
    107c:	6d656d00 	stclvs	13, cr6, [r5, #-0]
    1080:	0079726f 	rsbseq	r7, r9, pc, ror #4
    1084:	676e656c 	strbvs	r6, [lr, -ip, ror #10]!
    1088:	73006874 	movwvc	r6, #2164	; 0x874
    108c:	656c7274 	strbvs	r7, [ip, #-628]!	; 0xfffffd8c
    1090:	5a5f006e 	bpl	17c1250 <__bss_end+0x17b77d0>
    1094:	72747337 	rsbsvc	r7, r4, #-603979776	; 0xdc000000
    1098:	7461636e 	strbtvc	r6, [r1], #-878	; 0xfffffc92
    109c:	4b506350 	blmi	1419de4 <__bss_end+0x1410364>
    10a0:	2e006963 	vmlscs.f16	s12, s0, s7	; <UNPREDICTABLE>
    10a4:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    10a8:	2f2e2e2f 	svccs	0x002e2e2f
    10ac:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    10b0:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    10b4:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
    10b8:	2f636367 	svccs	0x00636367
    10bc:	666e6f63 	strbtvs	r6, [lr], -r3, ror #30
    10c0:	612f6769 			; <UNDEFINED> instruction: 0x612f6769
    10c4:	6c2f6d72 	stcvs	13, cr6, [pc], #-456	; f04 <shift+0xf04>
    10c8:	66316269 	ldrtvs	r6, [r1], -r9, ror #4
    10cc:	73636e75 	cmnvc	r3, #1872	; 0x750
    10d0:	2f00532e 	svccs	0x0000532e
    10d4:	6c697562 	cfstr64vs	mvdx7, [r9], #-392	; 0xfffffe78
    10d8:	63672f64 	cmnvs	r7, #100, 30	; 0x190
    10dc:	72612d63 	rsbvc	r2, r1, #6336	; 0x18c0
    10e0:	6f6e2d6d 	svcvs	0x006e2d6d
    10e4:	652d656e 	strvs	r6, [sp, #-1390]!	; 0xfffffa92
    10e8:	2d696261 	sfmcs	f6, 2, [r9, #-388]!	; 0xfffffe7c
    10ec:	67665968 	strbvs	r5, [r6, -r8, ror #18]!
    10f0:	672f344b 	strvs	r3, [pc, -fp, asr #8]!
    10f4:	612d6363 			; <UNDEFINED> instruction: 0x612d6363
    10f8:	6e2d6d72 	mcrvs	13, 1, r6, cr13, cr2, {3}
    10fc:	2d656e6f 	stclcs	14, cr6, [r5, #-444]!	; 0xfffffe44
    1100:	69626165 	stmdbvs	r2!, {r0, r2, r5, r6, r8, sp, lr}^
    1104:	2e30312d 	rsfcssp	f3, f0, #5.0
    1108:	30322d33 	eorscc	r2, r2, r3, lsr sp
    110c:	302e3132 	eorcc	r3, lr, r2, lsr r1
    1110:	75622f37 	strbvc	r2, [r2, #-3895]!	; 0xfffff0c9
    1114:	2f646c69 	svccs	0x00646c69
    1118:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
    111c:	656e6f6e 	strbvs	r6, [lr, #-3950]!	; 0xfffff092
    1120:	6261652d 	rsbvs	r6, r1, #188743680	; 0xb400000
    1124:	72612f69 	rsbvc	r2, r1, #420	; 0x1a4
    1128:	35762f6d 	ldrbcc	r2, [r6, #-3949]!	; 0xfffff093
    112c:	682f6574 	stmdavs	pc!, {r2, r4, r5, r6, r8, sl, sp, lr}	; <UNPREDICTABLE>
    1130:	2f647261 	svccs	0x00647261
    1134:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    1138:	47006363 	strmi	r6, [r0, -r3, ror #6]
    113c:	4120554e 			; <UNDEFINED> instruction: 0x4120554e
    1140:	2e322053 	mrccs	0, 1, r2, cr2, cr3, {2}
    1144:	2e003733 	mcrcs	7, 0, r3, cr0, cr3, {1}
    1148:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    114c:	2f2e2e2f 	svccs	0x002e2e2f
    1150:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1154:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1158:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
    115c:	2f636367 	svccs	0x00636367
    1160:	666e6f63 	strbtvs	r6, [lr], -r3, ror #30
    1164:	612f6769 			; <UNDEFINED> instruction: 0x612f6769
    1168:	692f6d72 	stmdbvs	pc!, {r1, r4, r5, r6, r8, sl, fp, sp, lr}	; <UNPREDICTABLE>
    116c:	37656565 	strbcc	r6, [r5, -r5, ror #10]!
    1170:	732d3435 			; <UNDEFINED> instruction: 0x732d3435
    1174:	00532e66 	subseq	r2, r3, r6, ror #28
    1178:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    117c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1180:	2f2e2e2f 	svccs	0x002e2e2f
    1184:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1188:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
    118c:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    1190:	6e6f632f 	cdpvs	3, 6, cr6, cr15, cr15, {1}
    1194:	2f676966 	svccs	0x00676966
    1198:	2f6d7261 	svccs	0x006d7261
    119c:	62617062 	rsbvs	r7, r1, #98	; 0x62
    11a0:	00532e69 	subseq	r2, r3, r9, ror #28
    11a4:	5f617369 	svcpl	0x00617369
    11a8:	5f746962 	svcpl	0x00746962
    11ac:	64657270 	strbtvs	r7, [r5], #-624	; 0xfffffd90
    11b0:	00736572 	rsbseq	r6, r3, r2, ror r5
    11b4:	5f617369 	svcpl	0x00617369
    11b8:	5f746962 	svcpl	0x00746962
    11bc:	5f706676 	svcpl	0x00706676
    11c0:	65736162 	ldrbvs	r6, [r3, #-354]!	; 0xfffffe9e
    11c4:	6d6f6300 	stclvs	3, cr6, [pc, #-0]	; 11cc <shift+0x11cc>
    11c8:	78656c70 	stmdavc	r5!, {r4, r5, r6, sl, fp, sp, lr}^
    11cc:	6f6c6620 	svcvs	0x006c6620
    11d0:	69007461 	stmdbvs	r0, {r0, r5, r6, sl, ip, sp, lr}
    11d4:	6e5f6173 	mrcvs	1, 2, r6, cr15, cr3, {3}
    11d8:	7469626f 	strbtvc	r6, [r9], #-623	; 0xfffffd91
    11dc:	61736900 	cmnvs	r3, r0, lsl #18
    11e0:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    11e4:	65766d5f 	ldrbvs	r6, [r6, #-3423]!	; 0xfffff2a1
    11e8:	6f6c665f 	svcvs	0x006c665f
    11ec:	69007461 	stmdbvs	r0, {r0, r5, r6, sl, ip, sp, lr}
    11f0:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    11f4:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
    11f8:	00363170 	eorseq	r3, r6, r0, ror r1
    11fc:	5f617369 	svcpl	0x00617369
    1200:	5f746962 	svcpl	0x00746962
    1204:	00636573 	rsbeq	r6, r3, r3, ror r5
    1208:	5f617369 	svcpl	0x00617369
    120c:	5f746962 	svcpl	0x00746962
    1210:	76696461 	strbtvc	r6, [r9], -r1, ror #8
    1214:	61736900 	cmnvs	r3, r0, lsl #18
    1218:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    121c:	6975715f 	ldmdbvs	r5!, {r0, r1, r2, r3, r4, r6, r8, ip, sp, lr}^
    1220:	6e5f6b72 	vmovvs.s8	r6, d15[3]
    1224:	6f765f6f 	svcvs	0x00765f6f
    1228:	6974616c 	ldmdbvs	r4!, {r2, r3, r5, r6, r8, sp, lr}^
    122c:	635f656c 	cmpvs	pc, #108, 10	; 0x1b000000
    1230:	73690065 	cmnvc	r9, #101	; 0x65
    1234:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1238:	706d5f74 	rsbvc	r5, sp, r4, ror pc
    123c:	61736900 	cmnvs	r3, r0, lsl #18
    1240:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1244:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1248:	00743576 	rsbseq	r3, r4, r6, ror r5
    124c:	5f617369 	svcpl	0x00617369
    1250:	5f746962 	svcpl	0x00746962
    1254:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    1258:	00657435 	rsbeq	r7, r5, r5, lsr r4
    125c:	5f617369 	svcpl	0x00617369
    1260:	5f746962 	svcpl	0x00746962
    1264:	6e6f656e 	cdpvs	5, 6, cr6, cr15, cr14, {3}
    1268:	61736900 	cmnvs	r3, r0, lsl #18
    126c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1270:	3166625f 	cmncc	r6, pc, asr r2
    1274:	50460036 	subpl	r0, r6, r6, lsr r0
    1278:	5f524353 	svcpl	0x00524353
    127c:	4d554e45 	ldclmi	14, cr4, [r5, #-276]	; 0xfffffeec
    1280:	53504600 	cmppl	r0, #0, 12
    1284:	6e5f5243 	cdpvs	2, 5, cr5, cr15, cr3, {2}
    1288:	7176637a 	cmnvc	r6, sl, ror r3
    128c:	4e455f63 	cdpmi	15, 4, cr5, cr5, cr3, {3}
    1290:	56004d55 			; <UNDEFINED> instruction: 0x56004d55
    1294:	455f5250 	ldrbmi	r5, [pc, #-592]	; 104c <shift+0x104c>
    1298:	004d554e 	subeq	r5, sp, lr, asr #10
    129c:	74696266 	strbtvc	r6, [r9], #-614	; 0xfffffd9a
    12a0:	706d695f 	rsbvc	r6, sp, pc, asr r9
    12a4:	6163696c 	cmnvs	r3, ip, ror #18
    12a8:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
    12ac:	5f305000 	svcpl	0x00305000
    12b0:	4d554e45 	ldclmi	14, cr4, [r5, #-276]	; 0xfffffeec
    12b4:	61736900 	cmnvs	r3, r0, lsl #18
    12b8:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    12bc:	7972635f 	ldmdbvc	r2!, {r0, r1, r2, r3, r4, r6, r8, r9, sp, lr}^
    12c0:	006f7470 	rsbeq	r7, pc, r0, ror r4	; <UNPREDICTABLE>
    12c4:	20554e47 	subscs	r4, r5, r7, asr #28
    12c8:	20373143 	eorscs	r3, r7, r3, asr #2
    12cc:	332e3031 			; <UNDEFINED> instruction: 0x332e3031
    12d0:	3220312e 	eorcc	r3, r0, #-2147483637	; 0x8000000b
    12d4:	30313230 	eorscc	r3, r1, r0, lsr r2
    12d8:	20313236 	eorscs	r3, r1, r6, lsr r2
    12dc:	6c657228 	sfmvs	f7, 2, [r5], #-160	; 0xffffff60
    12e0:	65736165 	ldrbvs	r6, [r3, #-357]!	; 0xfffffe9b
    12e4:	6d2d2029 	stcvs	0, cr2, [sp, #-164]!	; 0xffffff5c
    12e8:	206d7261 	rsbcs	r7, sp, r1, ror #4
    12ec:	6c666d2d 	stclvs	13, cr6, [r6], #-180	; 0xffffff4c
    12f0:	2d74616f 	ldfcse	f6, [r4, #-444]!	; 0xfffffe44
    12f4:	3d696261 	sfmcc	f6, 2, [r9, #-388]!	; 0xfffffe7c
    12f8:	64726168 	ldrbtvs	r6, [r2], #-360	; 0xfffffe98
    12fc:	616d2d20 	cmnvs	sp, r0, lsr #26
    1300:	3d686372 	stclcc	3, cr6, [r8, #-456]!	; 0xfffffe38
    1304:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    1308:	2b657435 	blcs	195e3e4 <__bss_end+0x1954964>
    130c:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
    1310:	672d2067 	strvs	r2, [sp, -r7, rrx]!
    1314:	20672d20 	rsbcs	r2, r7, r0, lsr #26
    1318:	20324f2d 	eorscs	r4, r2, sp, lsr #30
    131c:	20324f2d 	eorscs	r4, r2, sp, lsr #30
    1320:	20324f2d 	eorscs	r4, r2, sp, lsr #30
    1324:	7562662d 	strbvc	r6, [r2, #-1581]!	; 0xfffff9d3
    1328:	69646c69 	stmdbvs	r4!, {r0, r3, r5, r6, sl, fp, sp, lr}^
    132c:	6c2d676e 	stcvs	7, cr6, [sp], #-440	; 0xfffffe48
    1330:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    1334:	662d2063 	strtvs	r2, [sp], -r3, rrx
    1338:	732d6f6e 			; <UNDEFINED> instruction: 0x732d6f6e
    133c:	6b636174 	blvs	18d9914 <__bss_end+0x18cfe94>
    1340:	6f72702d 	svcvs	0x0072702d
    1344:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
    1348:	2d20726f 	sfmcs	f7, 4, [r0, #-444]!	; 0xfffffe44
    134c:	2d6f6e66 	stclcs	14, cr6, [pc, #-408]!	; 11bc <shift+0x11bc>
    1350:	696c6e69 	stmdbvs	ip!, {r0, r3, r5, r6, r9, sl, fp, sp, lr}^
    1354:	2d20656e 	cfstr32cs	mvfx6, [r0, #-440]!	; 0xfffffe48
    1358:	73697666 	cmnvc	r9, #106954752	; 0x6600000
    135c:	6c696269 	sfmvs	f6, 2, [r9], #-420	; 0xfffffe5c
    1360:	3d797469 	cfldrdcc	mvd7, [r9, #-420]!	; 0xfffffe5c
    1364:	64646968 	strbtvs	r6, [r4], #-2408	; 0xfffff698
    1368:	69006e65 	stmdbvs	r0, {r0, r2, r5, r6, r9, sl, fp, sp, lr}
    136c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1370:	745f7469 	ldrbvc	r7, [pc], #-1129	; 1378 <shift+0x1378>
    1374:	00766964 	rsbseq	r6, r6, r4, ror #18
    1378:	736e6f63 	cmnvc	lr, #396	; 0x18c
    137c:	61736900 	cmnvs	r3, r0, lsl #18
    1380:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1384:	6d77695f 			; <UNDEFINED> instruction: 0x6d77695f
    1388:	0074786d 	rsbseq	r7, r4, sp, ror #16
    138c:	58435046 	stmdapl	r3, {r1, r2, r6, ip, lr}^
    1390:	455f5354 	ldrbmi	r5, [pc, #-852]	; 1044 <shift+0x1044>
    1394:	004d554e 	subeq	r5, sp, lr, asr #10
    1398:	5f617369 	svcpl	0x00617369
    139c:	5f746962 	svcpl	0x00746962
    13a0:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    13a4:	73690036 	cmnvc	r9, #54	; 0x36
    13a8:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    13ac:	766d5f74 	uqsub16vc	r5, sp, r4
    13b0:	73690065 	cmnvc	r9, #101	; 0x65
    13b4:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    13b8:	77695f74 			; <UNDEFINED> instruction: 0x77695f74
    13bc:	74786d6d 	ldrbtvc	r6, [r8], #-3437	; 0xfffff293
    13c0:	73690032 	cmnvc	r9, #50	; 0x32
    13c4:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    13c8:	64635f74 	strbtvs	r5, [r3], #-3956	; 0xfffff08c
    13cc:	30706365 	rsbscc	r6, r0, r5, ror #6
    13d0:	61736900 	cmnvs	r3, r0, lsl #18
    13d4:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    13d8:	6564635f 	strbvs	r6, [r4, #-863]!	; 0xfffffca1
    13dc:	00317063 	eorseq	r7, r1, r3, rrx
    13e0:	5f617369 	svcpl	0x00617369
    13e4:	5f746962 	svcpl	0x00746962
    13e8:	63656463 	cmnvs	r5, #1660944384	; 0x63000000
    13ec:	69003270 	stmdbvs	r0, {r4, r5, r6, r9, ip, sp}
    13f0:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    13f4:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
    13f8:	70636564 	rsbvc	r6, r3, r4, ror #10
    13fc:	73690033 	cmnvc	r9, #51	; 0x33
    1400:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1404:	64635f74 	strbtvs	r5, [r3], #-3956	; 0xfffff08c
    1408:	34706365 	ldrbtcc	r6, [r0], #-869	; 0xfffffc9b
    140c:	61736900 	cmnvs	r3, r0, lsl #18
    1410:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1414:	5f70665f 	svcpl	0x0070665f
    1418:	006c6264 	rsbeq	r6, ip, r4, ror #4
    141c:	5f617369 	svcpl	0x00617369
    1420:	5f746962 	svcpl	0x00746962
    1424:	63656463 	cmnvs	r5, #1660944384	; 0x63000000
    1428:	69003670 	stmdbvs	r0, {r4, r5, r6, r9, sl, ip, sp}
    142c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1430:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
    1434:	70636564 	rsbvc	r6, r3, r4, ror #10
    1438:	73690037 	cmnvc	r9, #55	; 0x37
    143c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1440:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    1444:	6b36766d 	blvs	d9ee00 <__bss_end+0xd95380>
    1448:	61736900 	cmnvs	r3, r0, lsl #18
    144c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1450:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1454:	315f3876 	cmpcc	pc, r6, ror r8	; <UNPREDICTABLE>
    1458:	616d5f6d 	cmnvs	sp, sp, ror #30
    145c:	61006e69 	tstvs	r0, r9, ror #28
    1460:	0065746e 	rsbeq	r7, r5, lr, ror #8
    1464:	5f617369 	svcpl	0x00617369
    1468:	5f746962 	svcpl	0x00746962
    146c:	65736d63 	ldrbvs	r6, [r3, #-3427]!	; 0xfffff29d
    1470:	6e6f6c00 	cdpvs	12, 6, cr6, cr15, cr0, {0}
    1474:	6f642067 	svcvs	0x00642067
    1478:	656c6275 	strbvs	r6, [ip, #-629]!	; 0xfffffd8b
    147c:	2f2e2e00 	svccs	0x002e2e00
    1480:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1484:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1488:	2f2e2e2f 	svccs	0x002e2e2f
    148c:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; 13dc <shift+0x13dc>
    1490:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    1494:	696c2f63 	stmdbvs	ip!, {r0, r1, r5, r6, r8, r9, sl, fp, sp}^
    1498:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    149c:	00632e32 	rsbeq	r2, r3, r2, lsr lr
    14a0:	5f617369 	svcpl	0x00617369
    14a4:	5f746962 	svcpl	0x00746962
    14a8:	35767066 	ldrbcc	r7, [r6, #-102]!	; 0xffffff9a
    14ac:	61736900 	cmnvs	r3, r0, lsl #18
    14b0:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    14b4:	6373785f 	cmnvs	r3, #6225920	; 0x5f0000
    14b8:	00656c61 	rsbeq	r6, r5, r1, ror #24
    14bc:	676e6f6c 	strbvs	r6, [lr, -ip, ror #30]!
    14c0:	6e6f6c20 	cdpvs	12, 6, cr6, cr15, cr0, {1}
    14c4:	6e752067 	cdpvs	0, 7, cr2, cr5, cr7, {3}
    14c8:	6e676973 			; <UNDEFINED> instruction: 0x6e676973
    14cc:	69206465 	stmdbvs	r0!, {r0, r2, r5, r6, sl, sp, lr}
    14d0:	6900746e 	stmdbvs	r0, {r1, r2, r3, r5, r6, sl, ip, sp, lr}
    14d4:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    14d8:	715f7469 	cmpvc	pc, r9, ror #8
    14dc:	6b726975 	blvs	1c9bab8 <__bss_end+0x1c92038>
    14e0:	336d635f 	cmncc	sp, #2080374785	; 0x7c000001
    14e4:	72646c5f 	rsbvc	r6, r4, #24320	; 0x5f00
    14e8:	73690064 	cmnvc	r9, #100	; 0x64
    14ec:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    14f0:	38695f74 	stmdacc	r9!, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    14f4:	69006d6d 	stmdbvs	r0, {r0, r2, r3, r5, r6, r8, sl, fp, sp, lr}
    14f8:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    14fc:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
    1500:	33645f70 	cmncc	r4, #112, 30	; 0x1c0
    1504:	73690032 	cmnvc	r9, #50	; 0x32
    1508:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    150c:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    1510:	6537766d 	ldrvs	r7, [r7, #-1645]!	; 0xfffff993
    1514:	7369006d 	cmnvc	r9, #109	; 0x6d
    1518:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    151c:	706c5f74 	rsbvc	r5, ip, r4, ror pc
    1520:	61006561 	tstvs	r0, r1, ror #10
    1524:	695f6c6c 	ldmdbvs	pc, {r2, r3, r5, r6, sl, fp, sp, lr}^	; <UNPREDICTABLE>
    1528:	696c706d 	stmdbvs	ip!, {r0, r2, r3, r5, r6, ip, sp, lr}^
    152c:	665f6465 	ldrbvs	r6, [pc], -r5, ror #8
    1530:	73746962 	cmnvc	r4, #1605632	; 0x188000
    1534:	61736900 	cmnvs	r3, r0, lsl #18
    1538:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    153c:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1540:	315f3876 	cmpcc	pc, r6, ror r8	; <UNPREDICTABLE>
    1544:	61736900 	cmnvs	r3, r0, lsl #18
    1548:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    154c:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1550:	325f3876 	subscc	r3, pc, #7733248	; 0x760000
    1554:	61736900 	cmnvs	r3, r0, lsl #18
    1558:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    155c:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1560:	335f3876 	cmpcc	pc, #7733248	; 0x760000
    1564:	61736900 	cmnvs	r3, r0, lsl #18
    1568:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    156c:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1570:	345f3876 	ldrbcc	r3, [pc], #-2166	; 1578 <shift+0x1578>
    1574:	61736900 	cmnvs	r3, r0, lsl #18
    1578:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    157c:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1580:	355f3876 	ldrbcc	r3, [pc, #-2166]	; d12 <shift+0xd12>
    1584:	61736900 	cmnvs	r3, r0, lsl #18
    1588:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    158c:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1590:	365f3876 			; <UNDEFINED> instruction: 0x365f3876
    1594:	61736900 	cmnvs	r3, r0, lsl #18
    1598:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    159c:	0062735f 	rsbeq	r7, r2, pc, asr r3
    15a0:	5f617369 	svcpl	0x00617369
    15a4:	5f6d756e 	svcpl	0x006d756e
    15a8:	73746962 	cmnvc	r4, #1605632	; 0x188000
    15ac:	61736900 	cmnvs	r3, r0, lsl #18
    15b0:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    15b4:	616d735f 	cmnvs	sp, pc, asr r3
    15b8:	756d6c6c 	strbvc	r6, [sp, #-3180]!	; 0xfffff394
    15bc:	7566006c 	strbvc	r0, [r6, #-108]!	; 0xffffff94
    15c0:	705f636e 	subsvc	r6, pc, lr, ror #6
    15c4:	63007274 	movwvs	r7, #628	; 0x274
    15c8:	6c706d6f 	ldclvs	13, cr6, [r0], #-444	; 0xfffffe44
    15cc:	64207865 	strtvs	r7, [r0], #-2149	; 0xfffff79b
    15d0:	6c62756f 	cfstr64vs	mvdx7, [r2], #-444	; 0xfffffe44
    15d4:	424e0065 	submi	r0, lr, #101	; 0x65
    15d8:	5f50465f 	svcpl	0x0050465f
    15dc:	52535953 	subspl	r5, r3, #1359872	; 0x14c000
    15e0:	00534745 	subseq	r4, r3, r5, asr #14
    15e4:	5f617369 	svcpl	0x00617369
    15e8:	5f746962 	svcpl	0x00746962
    15ec:	63656463 	cmnvs	r5, #1660944384	; 0x63000000
    15f0:	69003570 	stmdbvs	r0, {r4, r5, r6, r8, sl, ip, sp}
    15f4:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    15f8:	765f7469 	ldrbvc	r7, [pc], -r9, ror #8
    15fc:	32767066 	rsbscc	r7, r6, #102	; 0x66
    1600:	61736900 	cmnvs	r3, r0, lsl #18
    1604:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1608:	7066765f 	rsbvc	r7, r6, pc, asr r6
    160c:	69003376 	stmdbvs	r0, {r1, r2, r4, r5, r6, r8, r9, ip, sp}
    1610:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1614:	765f7469 	ldrbvc	r7, [pc], -r9, ror #8
    1618:	34767066 	ldrbtcc	r7, [r6], #-102	; 0xffffff9a
    161c:	43504600 	cmpmi	r0, #0, 12
    1620:	534e5458 	movtpl	r5, #58456	; 0xe458
    1624:	554e455f 	strbpl	r4, [lr, #-1375]	; 0xfffffaa1
    1628:	7369004d 	cmnvc	r9, #77	; 0x4d
    162c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1630:	68745f74 	ldmdavs	r4!, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    1634:	00626d75 	rsbeq	r6, r2, r5, ror sp
    1638:	5f617369 	svcpl	0x00617369
    163c:	5f746962 	svcpl	0x00746962
    1640:	36317066 	ldrtcc	r7, [r1], -r6, rrx
    1644:	766e6f63 	strbtvc	r6, [lr], -r3, ror #30
    1648:	61736900 	cmnvs	r3, r0, lsl #18
    164c:	6165665f 	cmnvs	r5, pc, asr r6
    1650:	65727574 	ldrbvs	r7, [r2, #-1396]!	; 0xfffffa8c
    1654:	61736900 	cmnvs	r3, r0, lsl #18
    1658:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    165c:	746f6e5f 	strbtvc	r6, [pc], #-3679	; 1664 <shift+0x1664>
    1660:	7369006d 	cmnvc	r9, #109	; 0x6d
    1664:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1668:	75715f74 	ldrbvc	r5, [r1, #-3956]!	; 0xfffff08c
    166c:	5f6b7269 	svcpl	0x006b7269
    1670:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    1674:	007a6b36 	rsbseq	r6, sl, r6, lsr fp
    1678:	5f617369 	svcpl	0x00617369
    167c:	5f746962 	svcpl	0x00746962
    1680:	33637263 	cmncc	r3, #805306374	; 0x30000006
    1684:	73690032 	cmnvc	r9, #50	; 0x32
    1688:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    168c:	75715f74 	ldrbvc	r5, [r1, #-3956]!	; 0xfffff08c
    1690:	5f6b7269 	svcpl	0x006b7269
    1694:	615f6f6e 	cmpvs	pc, lr, ror #30
    1698:	70636d73 	rsbvc	r6, r3, r3, ror sp
    169c:	73690075 	cmnvc	r9, #117	; 0x75
    16a0:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    16a4:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    16a8:	0034766d 	eorseq	r7, r4, sp, ror #12
    16ac:	5f617369 	svcpl	0x00617369
    16b0:	5f746962 	svcpl	0x00746962
    16b4:	6d756874 	ldclvs	8, cr6, [r5, #-464]!	; 0xfffffe30
    16b8:	69003262 	stmdbvs	r0, {r1, r5, r6, r9, ip, sp}
    16bc:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    16c0:	625f7469 	subsvs	r7, pc, #1761607680	; 0x69000000
    16c4:	69003865 	stmdbvs	r0, {r0, r2, r5, r6, fp, ip, sp}
    16c8:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    16cc:	615f7469 	cmpvs	pc, r9, ror #8
    16d0:	37766d72 			; <UNDEFINED> instruction: 0x37766d72
    16d4:	61736900 	cmnvs	r3, r0, lsl #18
    16d8:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    16dc:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    16e0:	76003876 			; <UNDEFINED> instruction: 0x76003876
    16e4:	735f7066 	cmpvc	pc, #102	; 0x66
    16e8:	65727379 	ldrbvs	r7, [r2, #-889]!	; 0xfffffc87
    16ec:	655f7367 	ldrbvs	r7, [pc, #-871]	; 138d <shift+0x138d>
    16f0:	646f636e 	strbtvs	r6, [pc], #-878	; 16f8 <shift+0x16f8>
    16f4:	00676e69 	rsbeq	r6, r7, r9, ror #28
    16f8:	5f617369 	svcpl	0x00617369
    16fc:	5f746962 	svcpl	0x00746962
    1700:	36317066 	ldrtcc	r7, [r1], -r6, rrx
    1704:	006c6d66 	rsbeq	r6, ip, r6, ror #26
    1708:	5f617369 	svcpl	0x00617369
    170c:	5f746962 	svcpl	0x00746962
    1710:	70746f64 	rsbsvc	r6, r4, r4, ror #30
    1714:	00646f72 	rsbeq	r6, r4, r2, ror pc
    1718:	69665f5f 	stmdbvs	r6!, {r0, r1, r2, r3, r4, r6, r8, r9, sl, fp, ip, lr}^
    171c:	736e7578 	cmnvc	lr, #120, 10	; 0x1e000000
    1720:	69646673 	stmdbvs	r4!, {r0, r1, r4, r5, r6, r9, sl, sp, lr}^
    1724:	74465300 	strbvc	r5, [r6], #-768	; 0xfffffd00
    1728:	00657079 	rsbeq	r7, r5, r9, ror r0
    172c:	65615f5f 	strbvs	r5, [r1, #-3935]!	; 0xfffff0a1
    1730:	5f696261 	svcpl	0x00696261
    1734:	6c753266 	lfmvs	f3, 2, [r5], #-408	; 0xfffffe68
    1738:	5f5f007a 	svcpl	0x005f007a
    173c:	73786966 	cmnvc	r8, #1671168	; 0x198000
    1740:	00696466 	rsbeq	r6, r9, r6, ror #8
    1744:	79744644 	ldmdbvc	r4!, {r2, r6, r9, sl, lr}^
    1748:	55006570 	strpl	r6, [r0, #-1392]	; 0xfffffa90
    174c:	79744953 	ldmdbvc	r4!, {r0, r1, r4, r6, r8, fp, lr}^
    1750:	55006570 	strpl	r6, [r0, #-1392]	; 0xfffffa90
    1754:	79744944 	ldmdbvc	r4!, {r2, r6, r8, fp, lr}^
    1758:	47006570 	smlsdxmi	r0, r0, r5, r6
    175c:	4320554e 			; <UNDEFINED> instruction: 0x4320554e
    1760:	31203731 			; <UNDEFINED> instruction: 0x31203731
    1764:	2e332e30 	mrccs	14, 1, r2, cr3, cr0, {1}
    1768:	30322031 	eorscc	r2, r2, r1, lsr r0
    176c:	36303132 			; <UNDEFINED> instruction: 0x36303132
    1770:	28203132 	stmdacs	r0!, {r1, r4, r5, r8, ip, sp}
    1774:	656c6572 	strbvs	r6, [ip, #-1394]!	; 0xfffffa8e
    1778:	29657361 	stmdbcs	r5!, {r0, r5, r6, r8, r9, ip, sp, lr}^
    177c:	616d2d20 	cmnvs	sp, r0, lsr #26
    1780:	2d206d72 	stccs	13, cr6, [r0, #-456]!	; 0xfffffe38
    1784:	6f6c666d 	svcvs	0x006c666d
    1788:	612d7461 			; <UNDEFINED> instruction: 0x612d7461
    178c:	683d6962 	ldmdavs	sp!, {r1, r5, r6, r8, fp, sp, lr}
    1790:	20647261 	rsbcs	r7, r4, r1, ror #4
    1794:	72616d2d 	rsbvc	r6, r1, #2880	; 0xb40
    1798:	613d6863 	teqvs	sp, r3, ror #16
    179c:	35766d72 	ldrbcc	r6, [r6, #-3442]!	; 0xfffff28e
    17a0:	662b6574 			; <UNDEFINED> instruction: 0x662b6574
    17a4:	672d2070 			; <UNDEFINED> instruction: 0x672d2070
    17a8:	20672d20 	rsbcs	r2, r7, r0, lsr #26
    17ac:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
    17b0:	2d20324f 	sfmcs	f3, 4, [r0, #-316]!	; 0xfffffec4
    17b4:	2d20324f 	sfmcs	f3, 4, [r0, #-316]!	; 0xfffffec4
    17b8:	2d20324f 	sfmcs	f3, 4, [r0, #-316]!	; 0xfffffec4
    17bc:	69756266 	ldmdbvs	r5!, {r1, r2, r5, r6, r9, sp, lr}^
    17c0:	6e69646c 	cdpvs	4, 6, cr6, cr9, cr12, {3}
    17c4:	696c2d67 	stmdbvs	ip!, {r0, r1, r2, r5, r6, r8, sl, fp, sp}^
    17c8:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    17cc:	6e662d20 	cdpvs	13, 6, cr2, cr6, cr0, {1}
    17d0:	74732d6f 	ldrbtvc	r2, [r3], #-3439	; 0xfffff291
    17d4:	2d6b6361 	stclcs	3, cr6, [fp, #-388]!	; 0xfffffe7c
    17d8:	746f7270 	strbtvc	r7, [pc], #-624	; 17e0 <shift+0x17e0>
    17dc:	6f746365 	svcvs	0x00746365
    17e0:	662d2072 			; <UNDEFINED> instruction: 0x662d2072
    17e4:	692d6f6e 	pushvs	{r1, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}
    17e8:	6e696c6e 	cdpvs	12, 6, cr6, cr9, cr14, {3}
    17ec:	662d2065 	strtvs	r2, [sp], -r5, rrx
    17f0:	65637865 	strbvs	r7, [r3, #-2149]!	; 0xfffff79b
    17f4:	6f697470 	svcvs	0x00697470
    17f8:	2d20736e 	stccs	3, cr7, [r0, #-440]!	; 0xfffffe48
    17fc:	73697666 	cmnvc	r9, #106954752	; 0x6600000
    1800:	6c696269 	sfmvs	f6, 2, [r9], #-420	; 0xfffffe5c
    1804:	3d797469 	cfldrdcc	mvd7, [r9, #-420]!	; 0xfffffe5c
    1808:	64646968 	strbtvs	r6, [r4], #-2408	; 0xfffff698
    180c:	5f006e65 	svcpl	0x00006e65
    1810:	6964755f 	stmdbvs	r4!, {r0, r1, r2, r3, r4, r6, r8, sl, ip, sp, lr}^
    1814:	646f6d76 	strbtvs	r6, [pc], #-3446	; 181c <shift+0x181c>
    1818:	00346964 	eorseq	r6, r4, r4, ror #18

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
  20:	8b040e42 	blhi	103930 <__bss_end+0xf9eb0>
  24:	0b0d4201 	bleq	350830 <__bss_end+0x346db0>
  28:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
  2c:	00000ecb 	andeq	r0, r0, fp, asr #29
  30:	0000001c 	andeq	r0, r0, ip, lsl r0
  34:	00000000 	andeq	r0, r0, r0
  38:	00008064 	andeq	r8, r0, r4, rrx
  3c:	00000040 	andeq	r0, r0, r0, asr #32
  40:	8b080e42 	blhi	203950 <__bss_end+0x1f9ed0>
  44:	42018e02 	andmi	r8, r1, #2, 28
  48:	5a040b0c 	bpl	102c80 <__bss_end+0xf9200>
  4c:	00080d0c 	andeq	r0, r8, ip, lsl #26
  50:	0000000c 	andeq	r0, r0, ip
  54:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
  58:	7c020001 	stcvc	0, cr0, [r2], {1}
  5c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
  60:	0000001c 	andeq	r0, r0, ip, lsl r0
  64:	00000050 	andeq	r0, r0, r0, asr r0
  68:	000080a4 	andeq	r8, r0, r4, lsr #1
  6c:	00000038 	andeq	r0, r0, r8, lsr r0
  70:	8b040e42 	blhi	103980 <__bss_end+0xf9f00>
  74:	0b0d4201 	bleq	350880 <__bss_end+0x346e00>
  78:	420d0d54 	andmi	r0, sp, #84, 26	; 0x1500
  7c:	00000ecb 	andeq	r0, r0, fp, asr #29
  80:	0000001c 	andeq	r0, r0, ip, lsl r0
  84:	00000050 	andeq	r0, r0, r0, asr r0
  88:	000080dc 	ldrdeq	r8, [r0], -ip
  8c:	0000002c 	andeq	r0, r0, ip, lsr #32
  90:	8b040e42 	blhi	1039a0 <__bss_end+0xf9f20>
  94:	0b0d4201 	bleq	3508a0 <__bss_end+0x346e20>
  98:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
  9c:	00000ecb 	andeq	r0, r0, fp, asr #29
  a0:	0000001c 	andeq	r0, r0, ip, lsl r0
  a4:	00000050 	andeq	r0, r0, r0, asr r0
  a8:	00008108 	andeq	r8, r0, r8, lsl #2
  ac:	00000020 	andeq	r0, r0, r0, lsr #32
  b0:	8b040e42 	blhi	1039c0 <__bss_end+0xf9f40>
  b4:	0b0d4201 	bleq	3508c0 <__bss_end+0x346e40>
  b8:	420d0d48 	andmi	r0, sp, #72, 26	; 0x1200
  bc:	00000ecb 	andeq	r0, r0, fp, asr #29
  c0:	0000001c 	andeq	r0, r0, ip, lsl r0
  c4:	00000050 	andeq	r0, r0, r0, asr r0
  c8:	00008128 	andeq	r8, r0, r8, lsr #2
  cc:	00000018 	andeq	r0, r0, r8, lsl r0
  d0:	8b040e42 	blhi	1039e0 <__bss_end+0xf9f60>
  d4:	0b0d4201 	bleq	3508e0 <__bss_end+0x346e60>
  d8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  dc:	00000ecb 	andeq	r0, r0, fp, asr #29
  e0:	0000001c 	andeq	r0, r0, ip, lsl r0
  e4:	00000050 	andeq	r0, r0, r0, asr r0
  e8:	00008140 	andeq	r8, r0, r0, asr #2
  ec:	00000018 	andeq	r0, r0, r8, lsl r0
  f0:	8b040e42 	blhi	103a00 <__bss_end+0xf9f80>
  f4:	0b0d4201 	bleq	350900 <__bss_end+0x346e80>
  f8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  fc:	00000ecb 	andeq	r0, r0, fp, asr #29
 100:	0000001c 	andeq	r0, r0, ip, lsl r0
 104:	00000050 	andeq	r0, r0, r0, asr r0
 108:	00008158 	andeq	r8, r0, r8, asr r1
 10c:	00000018 	andeq	r0, r0, r8, lsl r0
 110:	8b040e42 	blhi	103a20 <__bss_end+0xf9fa0>
 114:	0b0d4201 	bleq	350920 <__bss_end+0x346ea0>
 118:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
 11c:	00000ecb 	andeq	r0, r0, fp, asr #29
 120:	00000014 	andeq	r0, r0, r4, lsl r0
 124:	00000050 	andeq	r0, r0, r0, asr r0
 128:	00008170 	andeq	r8, r0, r0, ror r1
 12c:	0000000c 	andeq	r0, r0, ip
 130:	8b040e42 	blhi	103a40 <__bss_end+0xf9fc0>
 134:	0b0d4201 	bleq	350940 <__bss_end+0x346ec0>
 138:	0000001c 	andeq	r0, r0, ip, lsl r0
 13c:	00000050 	andeq	r0, r0, r0, asr r0
 140:	0000817c 	andeq	r8, r0, ip, ror r1
 144:	00000058 	andeq	r0, r0, r8, asr r0
 148:	8b080e42 	blhi	203a58 <__bss_end+0x1f9fd8>
 14c:	42018e02 	andmi	r8, r1, #2, 28
 150:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 154:	00080d0c 	andeq	r0, r8, ip, lsl #26
 158:	0000001c 	andeq	r0, r0, ip, lsl r0
 15c:	00000050 	andeq	r0, r0, r0, asr r0
 160:	000081d4 	ldrdeq	r8, [r0], -r4
 164:	00000058 	andeq	r0, r0, r8, asr r0
 168:	8b080e42 	blhi	203a78 <__bss_end+0x1f9ff8>
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
 194:	00000048 	andeq	r0, r0, r8, asr #32
 198:	8b080e42 	blhi	203aa8 <__bss_end+0x1fa028>
 19c:	42018e02 	andmi	r8, r1, #2, 28
 1a0:	00040b0c 	andeq	r0, r4, ip, lsl #22
 1a4:	0000000c 	andeq	r0, r0, ip
 1a8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 1ac:	7c020001 	stcvc	0, cr0, [r2], {1}
 1b0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 1b4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1b8:	000001a4 	andeq	r0, r0, r4, lsr #3
 1bc:	00008274 	andeq	r8, r0, r4, ror r2
 1c0:	0000002c 	andeq	r0, r0, ip, lsr #32
 1c4:	8b040e42 	blhi	103ad4 <__bss_end+0xfa054>
 1c8:	0b0d4201 	bleq	3509d4 <__bss_end+0x346f54>
 1cc:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 1d0:	00000ecb 	andeq	r0, r0, fp, asr #29
 1d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1d8:	000001a4 	andeq	r0, r0, r4, lsr #3
 1dc:	000082a0 	andeq	r8, r0, r0, lsr #5
 1e0:	0000002c 	andeq	r0, r0, ip, lsr #32
 1e4:	8b040e42 	blhi	103af4 <__bss_end+0xfa074>
 1e8:	0b0d4201 	bleq	3509f4 <__bss_end+0x346f74>
 1ec:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 1f0:	00000ecb 	andeq	r0, r0, fp, asr #29
 1f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1f8:	000001a4 	andeq	r0, r0, r4, lsr #3
 1fc:	000082cc 	andeq	r8, r0, ip, asr #5
 200:	0000001c 	andeq	r0, r0, ip, lsl r0
 204:	8b040e42 	blhi	103b14 <__bss_end+0xfa094>
 208:	0b0d4201 	bleq	350a14 <__bss_end+0x346f94>
 20c:	420d0d46 	andmi	r0, sp, #4480	; 0x1180
 210:	00000ecb 	andeq	r0, r0, fp, asr #29
 214:	0000001c 	andeq	r0, r0, ip, lsl r0
 218:	000001a4 	andeq	r0, r0, r4, lsr #3
 21c:	000082e8 	andeq	r8, r0, r8, ror #5
 220:	00000044 	andeq	r0, r0, r4, asr #32
 224:	8b040e42 	blhi	103b34 <__bss_end+0xfa0b4>
 228:	0b0d4201 	bleq	350a34 <__bss_end+0x346fb4>
 22c:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 230:	00000ecb 	andeq	r0, r0, fp, asr #29
 234:	0000001c 	andeq	r0, r0, ip, lsl r0
 238:	000001a4 	andeq	r0, r0, r4, lsr #3
 23c:	0000832c 	andeq	r8, r0, ip, lsr #6
 240:	00000050 	andeq	r0, r0, r0, asr r0
 244:	8b040e42 	blhi	103b54 <__bss_end+0xfa0d4>
 248:	0b0d4201 	bleq	350a54 <__bss_end+0x346fd4>
 24c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 250:	00000ecb 	andeq	r0, r0, fp, asr #29
 254:	0000001c 	andeq	r0, r0, ip, lsl r0
 258:	000001a4 	andeq	r0, r0, r4, lsr #3
 25c:	0000837c 	andeq	r8, r0, ip, ror r3
 260:	00000050 	andeq	r0, r0, r0, asr r0
 264:	8b040e42 	blhi	103b74 <__bss_end+0xfa0f4>
 268:	0b0d4201 	bleq	350a74 <__bss_end+0x346ff4>
 26c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 270:	00000ecb 	andeq	r0, r0, fp, asr #29
 274:	0000001c 	andeq	r0, r0, ip, lsl r0
 278:	000001a4 	andeq	r0, r0, r4, lsr #3
 27c:	000083cc 	andeq	r8, r0, ip, asr #7
 280:	0000002c 	andeq	r0, r0, ip, lsr #32
 284:	8b040e42 	blhi	103b94 <__bss_end+0xfa114>
 288:	0b0d4201 	bleq	350a94 <__bss_end+0x347014>
 28c:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 290:	00000ecb 	andeq	r0, r0, fp, asr #29
 294:	0000001c 	andeq	r0, r0, ip, lsl r0
 298:	000001a4 	andeq	r0, r0, r4, lsr #3
 29c:	000083f8 	strdeq	r8, [r0], -r8	; <UNPREDICTABLE>
 2a0:	00000050 	andeq	r0, r0, r0, asr r0
 2a4:	8b040e42 	blhi	103bb4 <__bss_end+0xfa134>
 2a8:	0b0d4201 	bleq	350ab4 <__bss_end+0x347034>
 2ac:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 2b0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2b4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2b8:	000001a4 	andeq	r0, r0, r4, lsr #3
 2bc:	00008448 	andeq	r8, r0, r8, asr #8
 2c0:	00000044 	andeq	r0, r0, r4, asr #32
 2c4:	8b040e42 	blhi	103bd4 <__bss_end+0xfa154>
 2c8:	0b0d4201 	bleq	350ad4 <__bss_end+0x347054>
 2cc:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 2d0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2d8:	000001a4 	andeq	r0, r0, r4, lsr #3
 2dc:	0000848c 	andeq	r8, r0, ip, lsl #9
 2e0:	00000050 	andeq	r0, r0, r0, asr r0
 2e4:	8b040e42 	blhi	103bf4 <__bss_end+0xfa174>
 2e8:	0b0d4201 	bleq	350af4 <__bss_end+0x347074>
 2ec:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 2f0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2f8:	000001a4 	andeq	r0, r0, r4, lsr #3
 2fc:	000084dc 	ldrdeq	r8, [r0], -ip
 300:	00000054 	andeq	r0, r0, r4, asr r0
 304:	8b040e42 	blhi	103c14 <__bss_end+0xfa194>
 308:	0b0d4201 	bleq	350b14 <__bss_end+0x347094>
 30c:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 310:	00000ecb 	andeq	r0, r0, fp, asr #29
 314:	0000001c 	andeq	r0, r0, ip, lsl r0
 318:	000001a4 	andeq	r0, r0, r4, lsr #3
 31c:	00008530 	andeq	r8, r0, r0, lsr r5
 320:	0000003c 	andeq	r0, r0, ip, lsr r0
 324:	8b040e42 	blhi	103c34 <__bss_end+0xfa1b4>
 328:	0b0d4201 	bleq	350b34 <__bss_end+0x3470b4>
 32c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 330:	00000ecb 	andeq	r0, r0, fp, asr #29
 334:	0000001c 	andeq	r0, r0, ip, lsl r0
 338:	000001a4 	andeq	r0, r0, r4, lsr #3
 33c:	0000856c 	andeq	r8, r0, ip, ror #10
 340:	0000003c 	andeq	r0, r0, ip, lsr r0
 344:	8b040e42 	blhi	103c54 <__bss_end+0xfa1d4>
 348:	0b0d4201 	bleq	350b54 <__bss_end+0x3470d4>
 34c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 350:	00000ecb 	andeq	r0, r0, fp, asr #29
 354:	0000001c 	andeq	r0, r0, ip, lsl r0
 358:	000001a4 	andeq	r0, r0, r4, lsr #3
 35c:	000085a8 	andeq	r8, r0, r8, lsr #11
 360:	0000003c 	andeq	r0, r0, ip, lsr r0
 364:	8b040e42 	blhi	103c74 <__bss_end+0xfa1f4>
 368:	0b0d4201 	bleq	350b74 <__bss_end+0x3470f4>
 36c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 370:	00000ecb 	andeq	r0, r0, fp, asr #29
 374:	0000001c 	andeq	r0, r0, ip, lsl r0
 378:	000001a4 	andeq	r0, r0, r4, lsr #3
 37c:	000085e4 	andeq	r8, r0, r4, ror #11
 380:	0000003c 	andeq	r0, r0, ip, lsr r0
 384:	8b040e42 	blhi	103c94 <__bss_end+0xfa214>
 388:	0b0d4201 	bleq	350b94 <__bss_end+0x347114>
 38c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 390:	00000ecb 	andeq	r0, r0, fp, asr #29
 394:	0000001c 	andeq	r0, r0, ip, lsl r0
 398:	000001a4 	andeq	r0, r0, r4, lsr #3
 39c:	00008620 	andeq	r8, r0, r0, lsr #12
 3a0:	000000b0 	strheq	r0, [r0], -r0	; <UNPREDICTABLE>
 3a4:	8b080e42 	blhi	203cb4 <__bss_end+0x1fa234>
 3a8:	42018e02 	andmi	r8, r1, #2, 28
 3ac:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 3b0:	080d0c50 	stmdaeq	sp, {r4, r6, sl, fp}
 3b4:	0000000c 	andeq	r0, r0, ip
 3b8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 3bc:	7c020001 	stcvc	0, cr0, [r2], {1}
 3c0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 3c4:	0000001c 	andeq	r0, r0, ip, lsl r0
 3c8:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 3cc:	000086d0 	ldrdeq	r8, [r0], -r0
 3d0:	00000178 	andeq	r0, r0, r8, ror r1
 3d4:	8b080e42 	blhi	203ce4 <__bss_end+0x1fa264>
 3d8:	42018e02 	andmi	r8, r1, #2, 28
 3dc:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 3e0:	080d0cb4 	stmdaeq	sp, {r2, r4, r5, r7, sl, fp}
 3e4:	0000001c 	andeq	r0, r0, ip, lsl r0
 3e8:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 3ec:	00008848 	andeq	r8, r0, r8, asr #16
 3f0:	000000cc 	andeq	r0, r0, ip, asr #1
 3f4:	8b080e42 	blhi	203d04 <__bss_end+0x1fa284>
 3f8:	42018e02 	andmi	r8, r1, #2, 28
 3fc:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 400:	080d0c60 	stmdaeq	sp, {r5, r6, sl, fp}
 404:	0000001c 	andeq	r0, r0, ip, lsl r0
 408:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 40c:	00008914 	andeq	r8, r0, r4, lsl r9
 410:	00000100 	andeq	r0, r0, r0, lsl #2
 414:	8b040e42 	blhi	103d24 <__bss_end+0xfa2a4>
 418:	0b0d4201 	bleq	350c24 <__bss_end+0x3471a4>
 41c:	0d0d7802 	stceq	8, cr7, [sp, #-8]
 420:	000ecb42 	andeq	ip, lr, r2, asr #22
 424:	0000001c 	andeq	r0, r0, ip, lsl r0
 428:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 42c:	00008a14 	andeq	r8, r0, r4, lsl sl
 430:	0000015c 	andeq	r0, r0, ip, asr r1
 434:	8b040e42 	blhi	103d44 <__bss_end+0xfa2c4>
 438:	0b0d4201 	bleq	350c44 <__bss_end+0x3471c4>
 43c:	0d0d9c02 	stceq	12, cr9, [sp, #-8]
 440:	000ecb42 	andeq	ip, lr, r2, asr #22
 444:	0000001c 	andeq	r0, r0, ip, lsl r0
 448:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 44c:	00008b70 	andeq	r8, r0, r0, ror fp
 450:	000000c0 	andeq	r0, r0, r0, asr #1
 454:	8b040e42 	blhi	103d64 <__bss_end+0xfa2e4>
 458:	0b0d4201 	bleq	350c64 <__bss_end+0x3471e4>
 45c:	0d0d5802 	stceq	8, cr5, [sp, #-8]
 460:	000ecb42 	andeq	ip, lr, r2, asr #22
 464:	0000001c 	andeq	r0, r0, ip, lsl r0
 468:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 46c:	00008c30 	andeq	r8, r0, r0, lsr ip
 470:	000000ac 	andeq	r0, r0, ip, lsr #1
 474:	8b040e42 	blhi	103d84 <__bss_end+0xfa304>
 478:	0b0d4201 	bleq	350c84 <__bss_end+0x347204>
 47c:	0d0d4e02 	stceq	14, cr4, [sp, #-8]
 480:	000ecb42 	andeq	ip, lr, r2, asr #22
 484:	0000001c 	andeq	r0, r0, ip, lsl r0
 488:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 48c:	00008cdc 	ldrdeq	r8, [r0], -ip
 490:	00000054 	andeq	r0, r0, r4, asr r0
 494:	8b040e42 	blhi	103da4 <__bss_end+0xfa324>
 498:	0b0d4201 	bleq	350ca4 <__bss_end+0x347224>
 49c:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 4a0:	00000ecb 	andeq	r0, r0, fp, asr #29
 4a4:	0000001c 	andeq	r0, r0, ip, lsl r0
 4a8:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 4ac:	00008d30 	andeq	r8, r0, r0, lsr sp
 4b0:	000000ac 	andeq	r0, r0, ip, lsr #1
 4b4:	8b080e42 	blhi	203dc4 <__bss_end+0x1fa344>
 4b8:	42018e02 	andmi	r8, r1, #2, 28
 4bc:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 4c0:	080d0c50 	stmdaeq	sp, {r4, r6, sl, fp}
 4c4:	0000001c 	andeq	r0, r0, ip, lsl r0
 4c8:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 4cc:	00008ddc 	ldrdeq	r8, [r0], -ip
 4d0:	000000d8 	ldrdeq	r0, [r0], -r8
 4d4:	8b080e42 	blhi	203de4 <__bss_end+0x1fa364>
 4d8:	42018e02 	andmi	r8, r1, #2, 28
 4dc:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 4e0:	080d0c66 	stmdaeq	sp, {r1, r2, r5, r6, sl, fp}
 4e4:	0000001c 	andeq	r0, r0, ip, lsl r0
 4e8:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 4ec:	00008eb4 			; <UNDEFINED> instruction: 0x00008eb4
 4f0:	00000068 	andeq	r0, r0, r8, rrx
 4f4:	8b040e42 	blhi	103e04 <__bss_end+0xfa384>
 4f8:	0b0d4201 	bleq	350d04 <__bss_end+0x347284>
 4fc:	420d0d6c 	andmi	r0, sp, #108, 26	; 0x1b00
 500:	00000ecb 	andeq	r0, r0, fp, asr #29
 504:	0000001c 	andeq	r0, r0, ip, lsl r0
 508:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 50c:	00008f1c 	andeq	r8, r0, ip, lsl pc
 510:	00000080 	andeq	r0, r0, r0, lsl #1
 514:	8b040e42 	blhi	103e24 <__bss_end+0xfa3a4>
 518:	0b0d4201 	bleq	350d24 <__bss_end+0x3472a4>
 51c:	420d0d78 	andmi	r0, sp, #120, 26	; 0x1e00
 520:	00000ecb 	andeq	r0, r0, fp, asr #29
 524:	0000001c 	andeq	r0, r0, ip, lsl r0
 528:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 52c:	00008f9c 	muleq	r0, ip, pc	; <UNPREDICTABLE>
 530:	00000068 	andeq	r0, r0, r8, rrx
 534:	8b040e42 	blhi	103e44 <__bss_end+0xfa3c4>
 538:	0b0d4201 	bleq	350d44 <__bss_end+0x3472c4>
 53c:	420d0d6c 	andmi	r0, sp, #108, 26	; 0x1b00
 540:	00000ecb 	andeq	r0, r0, fp, asr #29
 544:	0000002c 	andeq	r0, r0, ip, lsr #32
 548:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 54c:	00009004 	andeq	r9, r0, r4
 550:	00000328 	andeq	r0, r0, r8, lsr #6
 554:	84200e42 	strthi	r0, [r0], #-3650	; 0xfffff1be
 558:	86078508 	strhi	r8, [r7], -r8, lsl #10
 55c:	88058706 	stmdahi	r5, {r1, r2, r8, r9, sl, pc}
 560:	8b038904 	blhi	e2978 <__bss_end+0xd8ef8>
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
 58c:	0000932c 	andeq	r9, r0, ip, lsr #6
 590:	000001ec 	andeq	r0, r0, ip, ror #3
 594:	0000000c 	andeq	r0, r0, ip
 598:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 59c:	7c020001 	stcvc	0, cr0, [r2], {1}
 5a0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 5a4:	00000010 	andeq	r0, r0, r0, lsl r0
 5a8:	00000594 	muleq	r0, r4, r5
 5ac:	0000953c 	andeq	r9, r0, ip, lsr r5
 5b0:	0000019c 	muleq	r0, ip, r1
 5b4:	0bce020a 	bleq	ff380de4 <__bss_end+0xff377364>
 5b8:	00000010 	andeq	r0, r0, r0, lsl r0
 5bc:	00000594 	muleq	r0, r4, r5
 5c0:	000096d8 	ldrdeq	r9, [r0], -r8
 5c4:	00000028 	andeq	r0, r0, r8, lsr #32
 5c8:	000b540a 	andeq	r5, fp, sl, lsl #8
 5cc:	00000010 	andeq	r0, r0, r0, lsl r0
 5d0:	00000594 	muleq	r0, r4, r5
 5d4:	00009700 	andeq	r9, r0, r0, lsl #14
 5d8:	0000008c 	andeq	r0, r0, ip, lsl #1
 5dc:	0b46020a 	bleq	1180e0c <__bss_end+0x117738c>
 5e0:	0000000c 	andeq	r0, r0, ip
 5e4:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 5e8:	7c020001 	stcvc	0, cr0, [r2], {1}
 5ec:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 5f0:	00000030 	andeq	r0, r0, r0, lsr r0
 5f4:	000005e0 	andeq	r0, r0, r0, ror #11
 5f8:	0000978c 	andeq	r9, r0, ip, lsl #15
 5fc:	000000d4 	ldrdeq	r0, [r0], -r4
 600:	8e100e5a 	mrchi	14, 0, r0, cr0, cr10, {2}
 604:	460a4a03 	strmi	r4, [sl], -r3, lsl #20
 608:	42100ece 	andsmi	r0, r0, #3296	; 0xce0
 60c:	460a4a0b 	strmi	r4, [sl], -fp, lsl #20
 610:	4a100ece 	bmi	404150 <__bss_end+0x3fa6d0>
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
 63c:	00009860 	andeq	r9, r0, r0, ror #16
 640:	00000030 	andeq	r0, r0, r0, lsr r0
 644:	84080e4e 	strhi	r0, [r8], #-3662	; 0xfffff1b2
 648:	00018e02 	andeq	r8, r1, r2, lsl #28
 64c:	0000000c 	andeq	r0, r0, ip
 650:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 654:	7c020001 	stcvc	0, cr0, [r2], {1}
 658:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 65c:	0000000c 	andeq	r0, r0, ip
 660:	0000064c 	andeq	r0, r0, ip, asr #12
 664:	00009890 	muleq	r0, r0, r8
 668:	00000040 	andeq	r0, r0, r0, asr #32
 66c:	0000000c 	andeq	r0, r0, ip
 670:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 674:	7c020001 	stcvc	0, cr0, [r2], {1}
 678:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 67c:	00000020 	andeq	r0, r0, r0, lsr #32
 680:	0000066c 	andeq	r0, r0, ip, ror #12
 684:	000098d0 	ldrdeq	r9, [r0], -r0
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

