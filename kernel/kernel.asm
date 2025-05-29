
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0003e117          	auipc	sp,0x3e
    80000004:	14010113          	addi	sp,sp,320 # 8003e140 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	1a1050ef          	jal	800059b6 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <refcnt_incr>:
  struct spinlock lock; // protects freelist
  int refcnt_array[PA2PPIDX(PHYSTOP) + 1]; // reference count for each physical page
} refcnt_recorder;

int refcnt_incr(uint64 pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	1000                	addi	s0,sp,32
    80000026:	84aa                	mv	s1,a0
  acquire(&refcnt_recorder.lock);
    80000028:	00009517          	auipc	a0,0x9
    8000002c:	02850513          	addi	a0,a0,40 # 80009050 <refcnt_recorder>
    80000030:	00006097          	auipc	ra,0x6
    80000034:	3d2080e7          	jalr	978(ra) # 80006402 <acquire>
  int refcnt = ++refcnt_recorder.refcnt_array[PA2PPIDX(pa)];
    80000038:	800007b7          	lui	a5,0x80000
    8000003c:	97a6                	add	a5,a5,s1
    8000003e:	83b1                	srli	a5,a5,0xc
    80000040:	00009517          	auipc	a0,0x9
    80000044:	01050513          	addi	a0,a0,16 # 80009050 <refcnt_recorder>
    80000048:	0791                	addi	a5,a5,4 # ffffffff80000004 <end+0xfffffffefffb9dc4>
    8000004a:	078a                	slli	a5,a5,0x2
    8000004c:	97aa                	add	a5,a5,a0
    8000004e:	4784                	lw	s1,8(a5)
    80000050:	2485                	addiw	s1,s1,1
    80000052:	c784                	sw	s1,8(a5)
  release(&refcnt_recorder.lock);
    80000054:	00006097          	auipc	ra,0x6
    80000058:	45e080e7          	jalr	1118(ra) # 800064b2 <release>
  return refcnt;
}
    8000005c:	8526                	mv	a0,s1
    8000005e:	60e2                	ld	ra,24(sp)
    80000060:	6442                	ld	s0,16(sp)
    80000062:	64a2                	ld	s1,8(sp)
    80000064:	6105                	addi	sp,sp,32
    80000066:	8082                	ret

0000000080000068 <refcnt_decr>:

int refcnt_decr(uint64 pa)
{
    80000068:	1101                	addi	sp,sp,-32
    8000006a:	ec06                	sd	ra,24(sp)
    8000006c:	e822                	sd	s0,16(sp)
    8000006e:	e426                	sd	s1,8(sp)
    80000070:	1000                	addi	s0,sp,32
    80000072:	84aa                	mv	s1,a0
  acquire(&refcnt_recorder.lock);
    80000074:	00009517          	auipc	a0,0x9
    80000078:	fdc50513          	addi	a0,a0,-36 # 80009050 <refcnt_recorder>
    8000007c:	00006097          	auipc	ra,0x6
    80000080:	386080e7          	jalr	902(ra) # 80006402 <acquire>
  int refcnt = --refcnt_recorder.refcnt_array[PA2PPIDX(pa)];
    80000084:	800007b7          	lui	a5,0x80000
    80000088:	97a6                	add	a5,a5,s1
    8000008a:	83b1                	srli	a5,a5,0xc
    8000008c:	00009517          	auipc	a0,0x9
    80000090:	fc450513          	addi	a0,a0,-60 # 80009050 <refcnt_recorder>
    80000094:	0791                	addi	a5,a5,4 # ffffffff80000004 <end+0xfffffffefffb9dc4>
    80000096:	078a                	slli	a5,a5,0x2
    80000098:	97aa                	add	a5,a5,a0
    8000009a:	4784                	lw	s1,8(a5)
    8000009c:	34fd                	addiw	s1,s1,-1
    8000009e:	c784                	sw	s1,8(a5)
  release(&refcnt_recorder.lock);
    800000a0:	00006097          	auipc	ra,0x6
    800000a4:	412080e7          	jalr	1042(ra) # 800064b2 <release>
  return refcnt;
}
    800000a8:	8526                	mv	a0,s1
    800000aa:	60e2                	ld	ra,24(sp)
    800000ac:	6442                	ld	s0,16(sp)
    800000ae:	64a2                	ld	s1,8(sp)
    800000b0:	6105                	addi	sp,sp,32
    800000b2:	8082                	ret

00000000800000b4 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    800000b4:	1101                	addi	sp,sp,-32
    800000b6:	ec06                	sd	ra,24(sp)
    800000b8:	e822                	sd	s0,16(sp)
    800000ba:	e426                	sd	s1,8(sp)
    800000bc:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    800000be:	03451793          	slli	a5,a0,0x34
    800000c2:	e79d                	bnez	a5,800000f0 <kfree+0x3c>
    800000c4:	84aa                	mv	s1,a0
    800000c6:	00046797          	auipc	a5,0x46
    800000ca:	17a78793          	addi	a5,a5,378 # 80046240 <end>
    800000ce:	02f56163          	bltu	a0,a5,800000f0 <kfree+0x3c>
    800000d2:	47c5                	li	a5,17
    800000d4:	07ee                	slli	a5,a5,0x1b
    800000d6:	00f57d63          	bgeu	a0,a5,800000f0 <kfree+0x3c>
    panic("kfree");

  int ref = refcnt_decr((uint64)pa);
    800000da:	00000097          	auipc	ra,0x0
    800000de:	f8e080e7          	jalr	-114(ra) # 80000068 <refcnt_decr>
  if(ref > 0)
    800000e2:	02a05063          	blez	a0,80000102 <kfree+0x4e>

  acquire(&kmem.lock);
  r->next = kmem.freelist;
  kmem.freelist = r;
  release(&kmem.lock);
}
    800000e6:	60e2                	ld	ra,24(sp)
    800000e8:	6442                	ld	s0,16(sp)
    800000ea:	64a2                	ld	s1,8(sp)
    800000ec:	6105                	addi	sp,sp,32
    800000ee:	8082                	ret
    800000f0:	e04a                	sd	s2,0(sp)
    panic("kfree");
    800000f2:	00008517          	auipc	a0,0x8
    800000f6:	f0e50513          	addi	a0,a0,-242 # 80008000 <etext>
    800000fa:	00006097          	auipc	ra,0x6
    800000fe:	d88080e7          	jalr	-632(ra) # 80005e82 <panic>
    80000102:	e04a                	sd	s2,0(sp)
  memset(pa, 1, PGSIZE);
    80000104:	6605                	lui	a2,0x1
    80000106:	4585                	li	a1,1
    80000108:	8526                	mv	a0,s1
    8000010a:	00000097          	auipc	ra,0x0
    8000010e:	17a080e7          	jalr	378(ra) # 80000284 <memset>
  acquire(&kmem.lock);
    80000112:	00009917          	auipc	s2,0x9
    80000116:	f1e90913          	addi	s2,s2,-226 # 80009030 <kmem>
    8000011a:	854a                	mv	a0,s2
    8000011c:	00006097          	auipc	ra,0x6
    80000120:	2e6080e7          	jalr	742(ra) # 80006402 <acquire>
  r->next = kmem.freelist;
    80000124:	01893783          	ld	a5,24(s2)
    80000128:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    8000012a:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000012e:	854a                	mv	a0,s2
    80000130:	00006097          	auipc	ra,0x6
    80000134:	382080e7          	jalr	898(ra) # 800064b2 <release>
    80000138:	6902                	ld	s2,0(sp)
    8000013a:	b775                	j	800000e6 <kfree+0x32>

000000008000013c <freerange>:
{
    8000013c:	715d                	addi	sp,sp,-80
    8000013e:	e486                	sd	ra,72(sp)
    80000140:	e0a2                	sd	s0,64(sp)
    80000142:	fc26                	sd	s1,56(sp)
    80000144:	0880                	addi	s0,sp,80
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000146:	6785                	lui	a5,0x1
    80000148:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    8000014c:	00e504b3          	add	s1,a0,a4
    80000150:	777d                	lui	a4,0xfffff
    80000152:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    80000154:	94be                	add	s1,s1,a5
    80000156:	0495eb63          	bltu	a1,s1,800001ac <freerange+0x70>
    8000015a:	f84a                	sd	s2,48(sp)
    8000015c:	f44e                	sd	s3,40(sp)
    8000015e:	f052                	sd	s4,32(sp)
    80000160:	ec56                	sd	s5,24(sp)
    80000162:	e85a                	sd	s6,16(sp)
    80000164:	e45e                	sd	s7,8(sp)
    80000166:	89ae                	mv	s3,a1
    refcnt_recorder.refcnt_array[PA2PPIDX(p)] = 1; // initialize reference count
    80000168:	00009b97          	auipc	s7,0x9
    8000016c:	ee8b8b93          	addi	s7,s7,-280 # 80009050 <refcnt_recorder>
    80000170:	fff80937          	lui	s2,0xfff80
    80000174:	197d                	addi	s2,s2,-1 # fffffffffff7ffff <end+0xffffffff7ff39dbf>
    80000176:	0932                	slli	s2,s2,0xc
    80000178:	4b05                	li	s6,1
    kfree(p);
    8000017a:	8aba                	mv	s5,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    8000017c:	8a3e                	mv	s4,a5
    refcnt_recorder.refcnt_array[PA2PPIDX(p)] = 1; // initialize reference count
    8000017e:	012487b3          	add	a5,s1,s2
    80000182:	83b1                	srli	a5,a5,0xc
    80000184:	0791                	addi	a5,a5,4
    80000186:	078a                	slli	a5,a5,0x2
    80000188:	97de                	add	a5,a5,s7
    8000018a:	0167a423          	sw	s6,8(a5)
    kfree(p);
    8000018e:	01548533          	add	a0,s1,s5
    80000192:	00000097          	auipc	ra,0x0
    80000196:	f22080e7          	jalr	-222(ra) # 800000b4 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    8000019a:	94d2                	add	s1,s1,s4
    8000019c:	fe99f1e3          	bgeu	s3,s1,8000017e <freerange+0x42>
    800001a0:	7942                	ld	s2,48(sp)
    800001a2:	79a2                	ld	s3,40(sp)
    800001a4:	7a02                	ld	s4,32(sp)
    800001a6:	6ae2                	ld	s5,24(sp)
    800001a8:	6b42                	ld	s6,16(sp)
    800001aa:	6ba2                	ld	s7,8(sp)
}
    800001ac:	60a6                	ld	ra,72(sp)
    800001ae:	6406                	ld	s0,64(sp)
    800001b0:	74e2                	ld	s1,56(sp)
    800001b2:	6161                	addi	sp,sp,80
    800001b4:	8082                	ret

00000000800001b6 <kinit>:
{
    800001b6:	1141                	addi	sp,sp,-16
    800001b8:	e406                	sd	ra,8(sp)
    800001ba:	e022                	sd	s0,0(sp)
    800001bc:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800001be:	00008597          	auipc	a1,0x8
    800001c2:	e5258593          	addi	a1,a1,-430 # 80008010 <etext+0x10>
    800001c6:	00009517          	auipc	a0,0x9
    800001ca:	e6a50513          	addi	a0,a0,-406 # 80009030 <kmem>
    800001ce:	00006097          	auipc	ra,0x6
    800001d2:	1a0080e7          	jalr	416(ra) # 8000636e <initlock>
  initlock(&refcnt_recorder.lock, "refcnt_recorder");
    800001d6:	00008597          	auipc	a1,0x8
    800001da:	e4258593          	addi	a1,a1,-446 # 80008018 <etext+0x18>
    800001de:	00009517          	auipc	a0,0x9
    800001e2:	e7250513          	addi	a0,a0,-398 # 80009050 <refcnt_recorder>
    800001e6:	00006097          	auipc	ra,0x6
    800001ea:	188080e7          	jalr	392(ra) # 8000636e <initlock>
  freerange(end, (void*)PHYSTOP);
    800001ee:	45c5                	li	a1,17
    800001f0:	05ee                	slli	a1,a1,0x1b
    800001f2:	00046517          	auipc	a0,0x46
    800001f6:	04e50513          	addi	a0,a0,78 # 80046240 <end>
    800001fa:	00000097          	auipc	ra,0x0
    800001fe:	f42080e7          	jalr	-190(ra) # 8000013c <freerange>
}
    80000202:	60a2                	ld	ra,8(sp)
    80000204:	6402                	ld	s0,0(sp)
    80000206:	0141                	addi	sp,sp,16
    80000208:	8082                	ret

000000008000020a <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    8000020a:	1101                	addi	sp,sp,-32
    8000020c:	ec06                	sd	ra,24(sp)
    8000020e:	e822                	sd	s0,16(sp)
    80000210:	e426                	sd	s1,8(sp)
    80000212:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000214:	00009497          	auipc	s1,0x9
    80000218:	e1c48493          	addi	s1,s1,-484 # 80009030 <kmem>
    8000021c:	8526                	mv	a0,s1
    8000021e:	00006097          	auipc	ra,0x6
    80000222:	1e4080e7          	jalr	484(ra) # 80006402 <acquire>
  r = kmem.freelist;
    80000226:	6c84                	ld	s1,24(s1)
  if(r) {
    80000228:	c4a9                	beqz	s1,80000272 <kalloc+0x68>
    kmem.freelist = r->next;
    8000022a:	609c                	ld	a5,0(s1)
    8000022c:	00009517          	auipc	a0,0x9
    80000230:	e0450513          	addi	a0,a0,-508 # 80009030 <kmem>
    80000234:	ed1c                	sd	a5,24(a0)
    // acquire(&refcnt_recorder.lock);
    refcnt_recorder.refcnt_array[PA2PPIDX(r)] = 1; // reset reference count
    80000236:	800007b7          	lui	a5,0x80000
    8000023a:	97a6                	add	a5,a5,s1
    8000023c:	83b1                	srli	a5,a5,0xc
    8000023e:	0791                	addi	a5,a5,4 # ffffffff80000004 <end+0xfffffffefffb9dc4>
    80000240:	078a                	slli	a5,a5,0x2
    80000242:	00009717          	auipc	a4,0x9
    80000246:	e0e70713          	addi	a4,a4,-498 # 80009050 <refcnt_recorder>
    8000024a:	97ba                	add	a5,a5,a4
    8000024c:	4705                	li	a4,1
    8000024e:	c798                	sw	a4,8(a5)
    // release(&refcnt_recorder.lock);
  }  
  release(&kmem.lock);
    80000250:	00006097          	auipc	ra,0x6
    80000254:	262080e7          	jalr	610(ra) # 800064b2 <release>

  if(r) {
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000258:	6605                	lui	a2,0x1
    8000025a:	4595                	li	a1,5
    8000025c:	8526                	mv	a0,s1
    8000025e:	00000097          	auipc	ra,0x0
    80000262:	026080e7          	jalr	38(ra) # 80000284 <memset>
  }
    
  return (void*)r;
}
    80000266:	8526                	mv	a0,s1
    80000268:	60e2                	ld	ra,24(sp)
    8000026a:	6442                	ld	s0,16(sp)
    8000026c:	64a2                	ld	s1,8(sp)
    8000026e:	6105                	addi	sp,sp,32
    80000270:	8082                	ret
  release(&kmem.lock);
    80000272:	00009517          	auipc	a0,0x9
    80000276:	dbe50513          	addi	a0,a0,-578 # 80009030 <kmem>
    8000027a:	00006097          	auipc	ra,0x6
    8000027e:	238080e7          	jalr	568(ra) # 800064b2 <release>
  if(r) {
    80000282:	b7d5                	j	80000266 <kalloc+0x5c>

0000000080000284 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000284:	1141                	addi	sp,sp,-16
    80000286:	e406                	sd	ra,8(sp)
    80000288:	e022                	sd	s0,0(sp)
    8000028a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    8000028c:	ca19                	beqz	a2,800002a2 <memset+0x1e>
    8000028e:	87aa                	mv	a5,a0
    80000290:	1602                	slli	a2,a2,0x20
    80000292:	9201                	srli	a2,a2,0x20
    80000294:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000298:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    8000029c:	0785                	addi	a5,a5,1
    8000029e:	fee79de3          	bne	a5,a4,80000298 <memset+0x14>
  }
  return dst;
}
    800002a2:	60a2                	ld	ra,8(sp)
    800002a4:	6402                	ld	s0,0(sp)
    800002a6:	0141                	addi	sp,sp,16
    800002a8:	8082                	ret

00000000800002aa <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    800002aa:	1141                	addi	sp,sp,-16
    800002ac:	e406                	sd	ra,8(sp)
    800002ae:	e022                	sd	s0,0(sp)
    800002b0:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800002b2:	ca0d                	beqz	a2,800002e4 <memcmp+0x3a>
    800002b4:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    800002b8:	1682                	slli	a3,a3,0x20
    800002ba:	9281                	srli	a3,a3,0x20
    800002bc:	0685                	addi	a3,a3,1
    800002be:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800002c0:	00054783          	lbu	a5,0(a0)
    800002c4:	0005c703          	lbu	a4,0(a1)
    800002c8:	00e79863          	bne	a5,a4,800002d8 <memcmp+0x2e>
      return *s1 - *s2;
    s1++, s2++;
    800002cc:	0505                	addi	a0,a0,1
    800002ce:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800002d0:	fed518e3          	bne	a0,a3,800002c0 <memcmp+0x16>
  }

  return 0;
    800002d4:	4501                	li	a0,0
    800002d6:	a019                	j	800002dc <memcmp+0x32>
      return *s1 - *s2;
    800002d8:	40e7853b          	subw	a0,a5,a4
}
    800002dc:	60a2                	ld	ra,8(sp)
    800002de:	6402                	ld	s0,0(sp)
    800002e0:	0141                	addi	sp,sp,16
    800002e2:	8082                	ret
  return 0;
    800002e4:	4501                	li	a0,0
    800002e6:	bfdd                	j	800002dc <memcmp+0x32>

00000000800002e8 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800002e8:	1141                	addi	sp,sp,-16
    800002ea:	e406                	sd	ra,8(sp)
    800002ec:	e022                	sd	s0,0(sp)
    800002ee:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800002f0:	c205                	beqz	a2,80000310 <memmove+0x28>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800002f2:	02a5e363          	bltu	a1,a0,80000318 <memmove+0x30>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800002f6:	1602                	slli	a2,a2,0x20
    800002f8:	9201                	srli	a2,a2,0x20
    800002fa:	00c587b3          	add	a5,a1,a2
{
    800002fe:	872a                	mv	a4,a0
      *d++ = *s++;
    80000300:	0585                	addi	a1,a1,1
    80000302:	0705                	addi	a4,a4,1
    80000304:	fff5c683          	lbu	a3,-1(a1)
    80000308:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    8000030c:	feb79ae3          	bne	a5,a1,80000300 <memmove+0x18>

  return dst;
}
    80000310:	60a2                	ld	ra,8(sp)
    80000312:	6402                	ld	s0,0(sp)
    80000314:	0141                	addi	sp,sp,16
    80000316:	8082                	ret
  if(s < d && s + n > d){
    80000318:	02061693          	slli	a3,a2,0x20
    8000031c:	9281                	srli	a3,a3,0x20
    8000031e:	00d58733          	add	a4,a1,a3
    80000322:	fce57ae3          	bgeu	a0,a4,800002f6 <memmove+0xe>
    d += n;
    80000326:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000328:	fff6079b          	addiw	a5,a2,-1
    8000032c:	1782                	slli	a5,a5,0x20
    8000032e:	9381                	srli	a5,a5,0x20
    80000330:	fff7c793          	not	a5,a5
    80000334:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000336:	177d                	addi	a4,a4,-1
    80000338:	16fd                	addi	a3,a3,-1
    8000033a:	00074603          	lbu	a2,0(a4)
    8000033e:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000342:	fee79ae3          	bne	a5,a4,80000336 <memmove+0x4e>
    80000346:	b7e9                	j	80000310 <memmove+0x28>

0000000080000348 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000348:	1141                	addi	sp,sp,-16
    8000034a:	e406                	sd	ra,8(sp)
    8000034c:	e022                	sd	s0,0(sp)
    8000034e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000350:	00000097          	auipc	ra,0x0
    80000354:	f98080e7          	jalr	-104(ra) # 800002e8 <memmove>
}
    80000358:	60a2                	ld	ra,8(sp)
    8000035a:	6402                	ld	s0,0(sp)
    8000035c:	0141                	addi	sp,sp,16
    8000035e:	8082                	ret

0000000080000360 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000360:	1141                	addi	sp,sp,-16
    80000362:	e406                	sd	ra,8(sp)
    80000364:	e022                	sd	s0,0(sp)
    80000366:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000368:	ce11                	beqz	a2,80000384 <strncmp+0x24>
    8000036a:	00054783          	lbu	a5,0(a0)
    8000036e:	cf89                	beqz	a5,80000388 <strncmp+0x28>
    80000370:	0005c703          	lbu	a4,0(a1)
    80000374:	00f71a63          	bne	a4,a5,80000388 <strncmp+0x28>
    n--, p++, q++;
    80000378:	367d                	addiw	a2,a2,-1
    8000037a:	0505                	addi	a0,a0,1
    8000037c:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    8000037e:	f675                	bnez	a2,8000036a <strncmp+0xa>
  if(n == 0)
    return 0;
    80000380:	4501                	li	a0,0
    80000382:	a801                	j	80000392 <strncmp+0x32>
    80000384:	4501                	li	a0,0
    80000386:	a031                	j	80000392 <strncmp+0x32>
  return (uchar)*p - (uchar)*q;
    80000388:	00054503          	lbu	a0,0(a0)
    8000038c:	0005c783          	lbu	a5,0(a1)
    80000390:	9d1d                	subw	a0,a0,a5
}
    80000392:	60a2                	ld	ra,8(sp)
    80000394:	6402                	ld	s0,0(sp)
    80000396:	0141                	addi	sp,sp,16
    80000398:	8082                	ret

000000008000039a <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    8000039a:	1141                	addi	sp,sp,-16
    8000039c:	e406                	sd	ra,8(sp)
    8000039e:	e022                	sd	s0,0(sp)
    800003a0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    800003a2:	87aa                	mv	a5,a0
    800003a4:	86b2                	mv	a3,a2
    800003a6:	367d                	addiw	a2,a2,-1
    800003a8:	02d05563          	blez	a3,800003d2 <strncpy+0x38>
    800003ac:	0785                	addi	a5,a5,1
    800003ae:	0005c703          	lbu	a4,0(a1)
    800003b2:	fee78fa3          	sb	a4,-1(a5)
    800003b6:	0585                	addi	a1,a1,1
    800003b8:	f775                	bnez	a4,800003a4 <strncpy+0xa>
    ;
  while(n-- > 0)
    800003ba:	873e                	mv	a4,a5
    800003bc:	00c05b63          	blez	a2,800003d2 <strncpy+0x38>
    800003c0:	9fb5                	addw	a5,a5,a3
    800003c2:	37fd                	addiw	a5,a5,-1
    *s++ = 0;
    800003c4:	0705                	addi	a4,a4,1
    800003c6:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    800003ca:	40e786bb          	subw	a3,a5,a4
    800003ce:	fed04be3          	bgtz	a3,800003c4 <strncpy+0x2a>
  return os;
}
    800003d2:	60a2                	ld	ra,8(sp)
    800003d4:	6402                	ld	s0,0(sp)
    800003d6:	0141                	addi	sp,sp,16
    800003d8:	8082                	ret

00000000800003da <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800003da:	1141                	addi	sp,sp,-16
    800003dc:	e406                	sd	ra,8(sp)
    800003de:	e022                	sd	s0,0(sp)
    800003e0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800003e2:	02c05363          	blez	a2,80000408 <safestrcpy+0x2e>
    800003e6:	fff6069b          	addiw	a3,a2,-1
    800003ea:	1682                	slli	a3,a3,0x20
    800003ec:	9281                	srli	a3,a3,0x20
    800003ee:	96ae                	add	a3,a3,a1
    800003f0:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800003f2:	00d58963          	beq	a1,a3,80000404 <safestrcpy+0x2a>
    800003f6:	0585                	addi	a1,a1,1
    800003f8:	0785                	addi	a5,a5,1
    800003fa:	fff5c703          	lbu	a4,-1(a1)
    800003fe:	fee78fa3          	sb	a4,-1(a5)
    80000402:	fb65                	bnez	a4,800003f2 <safestrcpy+0x18>
    ;
  *s = 0;
    80000404:	00078023          	sb	zero,0(a5)
  return os;
}
    80000408:	60a2                	ld	ra,8(sp)
    8000040a:	6402                	ld	s0,0(sp)
    8000040c:	0141                	addi	sp,sp,16
    8000040e:	8082                	ret

0000000080000410 <strlen>:

int
strlen(const char *s)
{
    80000410:	1141                	addi	sp,sp,-16
    80000412:	e406                	sd	ra,8(sp)
    80000414:	e022                	sd	s0,0(sp)
    80000416:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000418:	00054783          	lbu	a5,0(a0)
    8000041c:	cf99                	beqz	a5,8000043a <strlen+0x2a>
    8000041e:	0505                	addi	a0,a0,1
    80000420:	87aa                	mv	a5,a0
    80000422:	86be                	mv	a3,a5
    80000424:	0785                	addi	a5,a5,1
    80000426:	fff7c703          	lbu	a4,-1(a5)
    8000042a:	ff65                	bnez	a4,80000422 <strlen+0x12>
    8000042c:	40a6853b          	subw	a0,a3,a0
    80000430:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    80000432:	60a2                	ld	ra,8(sp)
    80000434:	6402                	ld	s0,0(sp)
    80000436:	0141                	addi	sp,sp,16
    80000438:	8082                	ret
  for(n = 0; s[n]; n++)
    8000043a:	4501                	li	a0,0
    8000043c:	bfdd                	j	80000432 <strlen+0x22>

000000008000043e <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    8000043e:	1141                	addi	sp,sp,-16
    80000440:	e406                	sd	ra,8(sp)
    80000442:	e022                	sd	s0,0(sp)
    80000444:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000446:	00001097          	auipc	ra,0x1
    8000044a:	b68080e7          	jalr	-1176(ra) # 80000fae <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    8000044e:	00009717          	auipc	a4,0x9
    80000452:	bb270713          	addi	a4,a4,-1102 # 80009000 <started>
  if(cpuid() == 0){
    80000456:	c139                	beqz	a0,8000049c <main+0x5e>
    while(started == 0)
    80000458:	431c                	lw	a5,0(a4)
    8000045a:	2781                	sext.w	a5,a5
    8000045c:	dff5                	beqz	a5,80000458 <main+0x1a>
      ;
    __sync_synchronize();
    8000045e:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    80000462:	00001097          	auipc	ra,0x1
    80000466:	b4c080e7          	jalr	-1204(ra) # 80000fae <cpuid>
    8000046a:	85aa                	mv	a1,a0
    8000046c:	00008517          	auipc	a0,0x8
    80000470:	bdc50513          	addi	a0,a0,-1060 # 80008048 <etext+0x48>
    80000474:	00006097          	auipc	ra,0x6
    80000478:	a58080e7          	jalr	-1448(ra) # 80005ecc <printf>
    kvminithart();    // turn on paging
    8000047c:	00000097          	auipc	ra,0x0
    80000480:	0d8080e7          	jalr	216(ra) # 80000554 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000484:	00001097          	auipc	ra,0x1
    80000488:	7b0080e7          	jalr	1968(ra) # 80001c34 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000048c:	00005097          	auipc	ra,0x5
    80000490:	ef8080e7          	jalr	-264(ra) # 80005384 <plicinithart>
  }

  scheduler();        
    80000494:	00001097          	auipc	ra,0x1
    80000498:	062080e7          	jalr	98(ra) # 800014f6 <scheduler>
    consoleinit();
    8000049c:	00006097          	auipc	ra,0x6
    800004a0:	908080e7          	jalr	-1784(ra) # 80005da4 <consoleinit>
    printfinit();
    800004a4:	00006097          	auipc	ra,0x6
    800004a8:	c32080e7          	jalr	-974(ra) # 800060d6 <printfinit>
    printf("\n");
    800004ac:	00008517          	auipc	a0,0x8
    800004b0:	b7c50513          	addi	a0,a0,-1156 # 80008028 <etext+0x28>
    800004b4:	00006097          	auipc	ra,0x6
    800004b8:	a18080e7          	jalr	-1512(ra) # 80005ecc <printf>
    printf("xv6 kernel is booting\n");
    800004bc:	00008517          	auipc	a0,0x8
    800004c0:	b7450513          	addi	a0,a0,-1164 # 80008030 <etext+0x30>
    800004c4:	00006097          	auipc	ra,0x6
    800004c8:	a08080e7          	jalr	-1528(ra) # 80005ecc <printf>
    printf("\n");
    800004cc:	00008517          	auipc	a0,0x8
    800004d0:	b5c50513          	addi	a0,a0,-1188 # 80008028 <etext+0x28>
    800004d4:	00006097          	auipc	ra,0x6
    800004d8:	9f8080e7          	jalr	-1544(ra) # 80005ecc <printf>
    kinit();         // physical page allocator
    800004dc:	00000097          	auipc	ra,0x0
    800004e0:	cda080e7          	jalr	-806(ra) # 800001b6 <kinit>
    kvminit();       // create kernel page table
    800004e4:	00000097          	auipc	ra,0x0
    800004e8:	326080e7          	jalr	806(ra) # 8000080a <kvminit>
    kvminithart();   // turn on paging
    800004ec:	00000097          	auipc	ra,0x0
    800004f0:	068080e7          	jalr	104(ra) # 80000554 <kvminithart>
    procinit();      // process table
    800004f4:	00001097          	auipc	ra,0x1
    800004f8:	a02080e7          	jalr	-1534(ra) # 80000ef6 <procinit>
    trapinit();      // trap vectors
    800004fc:	00001097          	auipc	ra,0x1
    80000500:	710080e7          	jalr	1808(ra) # 80001c0c <trapinit>
    trapinithart();  // install kernel trap vector
    80000504:	00001097          	auipc	ra,0x1
    80000508:	730080e7          	jalr	1840(ra) # 80001c34 <trapinithart>
    plicinit();      // set up interrupt controller
    8000050c:	00005097          	auipc	ra,0x5
    80000510:	e5e080e7          	jalr	-418(ra) # 8000536a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000514:	00005097          	auipc	ra,0x5
    80000518:	e70080e7          	jalr	-400(ra) # 80005384 <plicinithart>
    binit();         // buffer cache
    8000051c:	00002097          	auipc	ra,0x2
    80000520:	f46080e7          	jalr	-186(ra) # 80002462 <binit>
    iinit();         // inode table
    80000524:	00002097          	auipc	ra,0x2
    80000528:	5b4080e7          	jalr	1460(ra) # 80002ad8 <iinit>
    fileinit();      // file table
    8000052c:	00003097          	auipc	ra,0x3
    80000530:	57e080e7          	jalr	1406(ra) # 80003aaa <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000534:	00005097          	auipc	ra,0x5
    80000538:	f70080e7          	jalr	-144(ra) # 800054a4 <virtio_disk_init>
    userinit();      // first user process
    8000053c:	00001097          	auipc	ra,0x1
    80000540:	d7e080e7          	jalr	-642(ra) # 800012ba <userinit>
    __sync_synchronize();
    80000544:	0330000f          	fence	rw,rw
    started = 1;
    80000548:	4785                	li	a5,1
    8000054a:	00009717          	auipc	a4,0x9
    8000054e:	aaf72b23          	sw	a5,-1354(a4) # 80009000 <started>
    80000552:	b789                	j	80000494 <main+0x56>

0000000080000554 <kvminithart>:
}

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void kvminithart()
{
    80000554:	1141                	addi	sp,sp,-16
    80000556:	e406                	sd	ra,8(sp)
    80000558:	e022                	sd	s0,0(sp)
    8000055a:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    8000055c:	00009797          	auipc	a5,0x9
    80000560:	aac7b783          	ld	a5,-1364(a5) # 80009008 <kernel_pagetable>
    80000564:	83b1                	srli	a5,a5,0xc
    80000566:	577d                	li	a4,-1
    80000568:	177e                	slli	a4,a4,0x3f
    8000056a:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    8000056c:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000570:	12000073          	sfence.vma
  sfence_vma();
}
    80000574:	60a2                	ld	ra,8(sp)
    80000576:	6402                	ld	s0,0(sp)
    80000578:	0141                	addi	sp,sp,16
    8000057a:	8082                	ret

000000008000057c <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    8000057c:	7139                	addi	sp,sp,-64
    8000057e:	fc06                	sd	ra,56(sp)
    80000580:	f822                	sd	s0,48(sp)
    80000582:	f426                	sd	s1,40(sp)
    80000584:	f04a                	sd	s2,32(sp)
    80000586:	ec4e                	sd	s3,24(sp)
    80000588:	e852                	sd	s4,16(sp)
    8000058a:	e456                	sd	s5,8(sp)
    8000058c:	e05a                	sd	s6,0(sp)
    8000058e:	0080                	addi	s0,sp,64
    80000590:	84aa                	mv	s1,a0
    80000592:	89ae                	mv	s3,a1
    80000594:	8ab2                	mv	s5,a2
  if (va >= MAXVA)
    80000596:	57fd                	li	a5,-1
    80000598:	83e9                	srli	a5,a5,0x1a
    8000059a:	4a79                	li	s4,30
    panic("walk");

  for (int level = 2; level > 0; level--)
    8000059c:	4b31                	li	s6,12
  if (va >= MAXVA)
    8000059e:	04b7e263          	bltu	a5,a1,800005e2 <walk+0x66>
  {
    pte_t *pte = &pagetable[PX(level, va)];
    800005a2:	0149d933          	srl	s2,s3,s4
    800005a6:	1ff97913          	andi	s2,s2,511
    800005aa:	090e                	slli	s2,s2,0x3
    800005ac:	9926                	add	s2,s2,s1
    if (*pte & PTE_V)
    800005ae:	00093483          	ld	s1,0(s2)
    800005b2:	0014f793          	andi	a5,s1,1
    800005b6:	cf95                	beqz	a5,800005f2 <walk+0x76>
    {
      pagetable = (pagetable_t)PTE2PA(*pte);
    800005b8:	80a9                	srli	s1,s1,0xa
    800005ba:	04b2                	slli	s1,s1,0xc
  for (int level = 2; level > 0; level--)
    800005bc:	3a5d                	addiw	s4,s4,-9
    800005be:	ff6a12e3          	bne	s4,s6,800005a2 <walk+0x26>
        return 0;
      memset(pagetable, 0, PGSIZE);
      *pte = PA2PTE(pagetable) | PTE_V;
    }
  }
  return &pagetable[PX(0, va)];
    800005c2:	00c9d513          	srli	a0,s3,0xc
    800005c6:	1ff57513          	andi	a0,a0,511
    800005ca:	050e                	slli	a0,a0,0x3
    800005cc:	9526                	add	a0,a0,s1
}
    800005ce:	70e2                	ld	ra,56(sp)
    800005d0:	7442                	ld	s0,48(sp)
    800005d2:	74a2                	ld	s1,40(sp)
    800005d4:	7902                	ld	s2,32(sp)
    800005d6:	69e2                	ld	s3,24(sp)
    800005d8:	6a42                	ld	s4,16(sp)
    800005da:	6aa2                	ld	s5,8(sp)
    800005dc:	6b02                	ld	s6,0(sp)
    800005de:	6121                	addi	sp,sp,64
    800005e0:	8082                	ret
    panic("walk");
    800005e2:	00008517          	auipc	a0,0x8
    800005e6:	a7e50513          	addi	a0,a0,-1410 # 80008060 <etext+0x60>
    800005ea:	00006097          	auipc	ra,0x6
    800005ee:	898080e7          	jalr	-1896(ra) # 80005e82 <panic>
      if (!alloc || (pagetable = (pde_t *)kalloc()) == 0)
    800005f2:	020a8663          	beqz	s5,8000061e <walk+0xa2>
    800005f6:	00000097          	auipc	ra,0x0
    800005fa:	c14080e7          	jalr	-1004(ra) # 8000020a <kalloc>
    800005fe:	84aa                	mv	s1,a0
    80000600:	d579                	beqz	a0,800005ce <walk+0x52>
      memset(pagetable, 0, PGSIZE);
    80000602:	6605                	lui	a2,0x1
    80000604:	4581                	li	a1,0
    80000606:	00000097          	auipc	ra,0x0
    8000060a:	c7e080e7          	jalr	-898(ra) # 80000284 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    8000060e:	00c4d793          	srli	a5,s1,0xc
    80000612:	07aa                	slli	a5,a5,0xa
    80000614:	0017e793          	ori	a5,a5,1
    80000618:	00f93023          	sd	a5,0(s2)
    8000061c:	b745                	j	800005bc <walk+0x40>
        return 0;
    8000061e:	4501                	li	a0,0
    80000620:	b77d                	j	800005ce <walk+0x52>

0000000080000622 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if (va >= MAXVA)
    80000622:	57fd                	li	a5,-1
    80000624:	83e9                	srli	a5,a5,0x1a
    80000626:	00b7f463          	bgeu	a5,a1,8000062e <walkaddr+0xc>
    return 0;
    8000062a:	4501                	li	a0,0
    return 0;
  if ((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000062c:	8082                	ret
{
    8000062e:	1141                	addi	sp,sp,-16
    80000630:	e406                	sd	ra,8(sp)
    80000632:	e022                	sd	s0,0(sp)
    80000634:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000636:	4601                	li	a2,0
    80000638:	00000097          	auipc	ra,0x0
    8000063c:	f44080e7          	jalr	-188(ra) # 8000057c <walk>
  if (pte == 0)
    80000640:	c105                	beqz	a0,80000660 <walkaddr+0x3e>
  if ((*pte & PTE_V) == 0)
    80000642:	611c                	ld	a5,0(a0)
  if ((*pte & PTE_U) == 0)
    80000644:	0117f693          	andi	a3,a5,17
    80000648:	4745                	li	a4,17
    return 0;
    8000064a:	4501                	li	a0,0
  if ((*pte & PTE_U) == 0)
    8000064c:	00e68663          	beq	a3,a4,80000658 <walkaddr+0x36>
}
    80000650:	60a2                	ld	ra,8(sp)
    80000652:	6402                	ld	s0,0(sp)
    80000654:	0141                	addi	sp,sp,16
    80000656:	8082                	ret
  pa = PTE2PA(*pte);
    80000658:	83a9                	srli	a5,a5,0xa
    8000065a:	00c79513          	slli	a0,a5,0xc
  return pa;
    8000065e:	bfcd                	j	80000650 <walkaddr+0x2e>
    return 0;
    80000660:	4501                	li	a0,0
    80000662:	b7fd                	j	80000650 <walkaddr+0x2e>

0000000080000664 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000664:	715d                	addi	sp,sp,-80
    80000666:	e486                	sd	ra,72(sp)
    80000668:	e0a2                	sd	s0,64(sp)
    8000066a:	fc26                	sd	s1,56(sp)
    8000066c:	f84a                	sd	s2,48(sp)
    8000066e:	f44e                	sd	s3,40(sp)
    80000670:	f052                	sd	s4,32(sp)
    80000672:	ec56                	sd	s5,24(sp)
    80000674:	e85a                	sd	s6,16(sp)
    80000676:	e45e                	sd	s7,8(sp)
    80000678:	e062                	sd	s8,0(sp)
    8000067a:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if (size == 0)
    8000067c:	ca21                	beqz	a2,800006cc <mappages+0x68>
    8000067e:	8aaa                	mv	s5,a0
    80000680:	8b3a                	mv	s6,a4
    panic("mappages: size");

  a = PGROUNDDOWN(va);
    80000682:	777d                	lui	a4,0xfffff
    80000684:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    80000688:	fff58993          	addi	s3,a1,-1
    8000068c:	99b2                	add	s3,s3,a2
    8000068e:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    80000692:	893e                	mv	s2,a5
    80000694:	40f68a33          	sub	s4,a3,a5
  for (;;)
  {
    if ((pte = walk(pagetable, a, 1)) == 0)
    80000698:	4b85                	li	s7,1
    if (*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if (a == last)
      break;
    a += PGSIZE;
    8000069a:	6c05                	lui	s8,0x1
    8000069c:	014904b3          	add	s1,s2,s4
    if ((pte = walk(pagetable, a, 1)) == 0)
    800006a0:	865e                	mv	a2,s7
    800006a2:	85ca                	mv	a1,s2
    800006a4:	8556                	mv	a0,s5
    800006a6:	00000097          	auipc	ra,0x0
    800006aa:	ed6080e7          	jalr	-298(ra) # 8000057c <walk>
    800006ae:	cd1d                	beqz	a0,800006ec <mappages+0x88>
    if (*pte & PTE_V)
    800006b0:	611c                	ld	a5,0(a0)
    800006b2:	8b85                	andi	a5,a5,1
    800006b4:	e785                	bnez	a5,800006dc <mappages+0x78>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800006b6:	80b1                	srli	s1,s1,0xc
    800006b8:	04aa                	slli	s1,s1,0xa
    800006ba:	0164e4b3          	or	s1,s1,s6
    800006be:	0014e493          	ori	s1,s1,1
    800006c2:	e104                	sd	s1,0(a0)
    if (a == last)
    800006c4:	05390163          	beq	s2,s3,80000706 <mappages+0xa2>
    a += PGSIZE;
    800006c8:	9962                	add	s2,s2,s8
    if ((pte = walk(pagetable, a, 1)) == 0)
    800006ca:	bfc9                	j	8000069c <mappages+0x38>
    panic("mappages: size");
    800006cc:	00008517          	auipc	a0,0x8
    800006d0:	99c50513          	addi	a0,a0,-1636 # 80008068 <etext+0x68>
    800006d4:	00005097          	auipc	ra,0x5
    800006d8:	7ae080e7          	jalr	1966(ra) # 80005e82 <panic>
      panic("mappages: remap");
    800006dc:	00008517          	auipc	a0,0x8
    800006e0:	99c50513          	addi	a0,a0,-1636 # 80008078 <etext+0x78>
    800006e4:	00005097          	auipc	ra,0x5
    800006e8:	79e080e7          	jalr	1950(ra) # 80005e82 <panic>
      return -1;
    800006ec:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800006ee:	60a6                	ld	ra,72(sp)
    800006f0:	6406                	ld	s0,64(sp)
    800006f2:	74e2                	ld	s1,56(sp)
    800006f4:	7942                	ld	s2,48(sp)
    800006f6:	79a2                	ld	s3,40(sp)
    800006f8:	7a02                	ld	s4,32(sp)
    800006fa:	6ae2                	ld	s5,24(sp)
    800006fc:	6b42                	ld	s6,16(sp)
    800006fe:	6ba2                	ld	s7,8(sp)
    80000700:	6c02                	ld	s8,0(sp)
    80000702:	6161                	addi	sp,sp,80
    80000704:	8082                	ret
  return 0;
    80000706:	4501                	li	a0,0
    80000708:	b7dd                	j	800006ee <mappages+0x8a>

000000008000070a <kvmmap>:
{
    8000070a:	1141                	addi	sp,sp,-16
    8000070c:	e406                	sd	ra,8(sp)
    8000070e:	e022                	sd	s0,0(sp)
    80000710:	0800                	addi	s0,sp,16
    80000712:	87b6                	mv	a5,a3
  if (mappages(kpgtbl, va, sz, pa, perm) != 0)
    80000714:	86b2                	mv	a3,a2
    80000716:	863e                	mv	a2,a5
    80000718:	00000097          	auipc	ra,0x0
    8000071c:	f4c080e7          	jalr	-180(ra) # 80000664 <mappages>
    80000720:	e509                	bnez	a0,8000072a <kvmmap+0x20>
}
    80000722:	60a2                	ld	ra,8(sp)
    80000724:	6402                	ld	s0,0(sp)
    80000726:	0141                	addi	sp,sp,16
    80000728:	8082                	ret
    panic("kvmmap");
    8000072a:	00008517          	auipc	a0,0x8
    8000072e:	95e50513          	addi	a0,a0,-1698 # 80008088 <etext+0x88>
    80000732:	00005097          	auipc	ra,0x5
    80000736:	750080e7          	jalr	1872(ra) # 80005e82 <panic>

000000008000073a <kvmmake>:
{
    8000073a:	1101                	addi	sp,sp,-32
    8000073c:	ec06                	sd	ra,24(sp)
    8000073e:	e822                	sd	s0,16(sp)
    80000740:	e426                	sd	s1,8(sp)
    80000742:	e04a                	sd	s2,0(sp)
    80000744:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t)kalloc();
    80000746:	00000097          	auipc	ra,0x0
    8000074a:	ac4080e7          	jalr	-1340(ra) # 8000020a <kalloc>
    8000074e:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000750:	6605                	lui	a2,0x1
    80000752:	4581                	li	a1,0
    80000754:	00000097          	auipc	ra,0x0
    80000758:	b30080e7          	jalr	-1232(ra) # 80000284 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000075c:	4719                	li	a4,6
    8000075e:	6685                	lui	a3,0x1
    80000760:	10000637          	lui	a2,0x10000
    80000764:	85b2                	mv	a1,a2
    80000766:	8526                	mv	a0,s1
    80000768:	00000097          	auipc	ra,0x0
    8000076c:	fa2080e7          	jalr	-94(ra) # 8000070a <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80000770:	4719                	li	a4,6
    80000772:	6685                	lui	a3,0x1
    80000774:	10001637          	lui	a2,0x10001
    80000778:	85b2                	mv	a1,a2
    8000077a:	8526                	mv	a0,s1
    8000077c:	00000097          	auipc	ra,0x0
    80000780:	f8e080e7          	jalr	-114(ra) # 8000070a <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000784:	4719                	li	a4,6
    80000786:	004006b7          	lui	a3,0x400
    8000078a:	0c000637          	lui	a2,0xc000
    8000078e:	85b2                	mv	a1,a2
    80000790:	8526                	mv	a0,s1
    80000792:	00000097          	auipc	ra,0x0
    80000796:	f78080e7          	jalr	-136(ra) # 8000070a <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext - KERNBASE, PTE_R | PTE_X);
    8000079a:	00008917          	auipc	s2,0x8
    8000079e:	86690913          	addi	s2,s2,-1946 # 80008000 <etext>
    800007a2:	4729                	li	a4,10
    800007a4:	80008697          	auipc	a3,0x80008
    800007a8:	85c68693          	addi	a3,a3,-1956 # 8000 <_entry-0x7fff8000>
    800007ac:	4605                	li	a2,1
    800007ae:	067e                	slli	a2,a2,0x1f
    800007b0:	85b2                	mv	a1,a2
    800007b2:	8526                	mv	a0,s1
    800007b4:	00000097          	auipc	ra,0x0
    800007b8:	f56080e7          	jalr	-170(ra) # 8000070a <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP - (uint64)etext, PTE_R | PTE_W);
    800007bc:	4719                	li	a4,6
    800007be:	46c5                	li	a3,17
    800007c0:	06ee                	slli	a3,a3,0x1b
    800007c2:	412686b3          	sub	a3,a3,s2
    800007c6:	864a                	mv	a2,s2
    800007c8:	85ca                	mv	a1,s2
    800007ca:	8526                	mv	a0,s1
    800007cc:	00000097          	auipc	ra,0x0
    800007d0:	f3e080e7          	jalr	-194(ra) # 8000070a <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800007d4:	4729                	li	a4,10
    800007d6:	6685                	lui	a3,0x1
    800007d8:	00007617          	auipc	a2,0x7
    800007dc:	82860613          	addi	a2,a2,-2008 # 80007000 <_trampoline>
    800007e0:	040005b7          	lui	a1,0x4000
    800007e4:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800007e6:	05b2                	slli	a1,a1,0xc
    800007e8:	8526                	mv	a0,s1
    800007ea:	00000097          	auipc	ra,0x0
    800007ee:	f20080e7          	jalr	-224(ra) # 8000070a <kvmmap>
  proc_mapstacks(kpgtbl);
    800007f2:	8526                	mv	a0,s1
    800007f4:	00000097          	auipc	ra,0x0
    800007f8:	658080e7          	jalr	1624(ra) # 80000e4c <proc_mapstacks>
}
    800007fc:	8526                	mv	a0,s1
    800007fe:	60e2                	ld	ra,24(sp)
    80000800:	6442                	ld	s0,16(sp)
    80000802:	64a2                	ld	s1,8(sp)
    80000804:	6902                	ld	s2,0(sp)
    80000806:	6105                	addi	sp,sp,32
    80000808:	8082                	ret

000000008000080a <kvminit>:
{
    8000080a:	1141                	addi	sp,sp,-16
    8000080c:	e406                	sd	ra,8(sp)
    8000080e:	e022                	sd	s0,0(sp)
    80000810:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80000812:	00000097          	auipc	ra,0x0
    80000816:	f28080e7          	jalr	-216(ra) # 8000073a <kvmmake>
    8000081a:	00008797          	auipc	a5,0x8
    8000081e:	7ea7b723          	sd	a0,2030(a5) # 80009008 <kernel_pagetable>
}
    80000822:	60a2                	ld	ra,8(sp)
    80000824:	6402                	ld	s0,0(sp)
    80000826:	0141                	addi	sp,sp,16
    80000828:	8082                	ret

000000008000082a <uvmunmap>:

// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000082a:	715d                	addi	sp,sp,-80
    8000082c:	e486                	sd	ra,72(sp)
    8000082e:	e0a2                	sd	s0,64(sp)
    80000830:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if ((va % PGSIZE) != 0)
    80000832:	03459793          	slli	a5,a1,0x34
    80000836:	e39d                	bnez	a5,8000085c <uvmunmap+0x32>
    80000838:	f84a                	sd	s2,48(sp)
    8000083a:	f44e                	sd	s3,40(sp)
    8000083c:	f052                	sd	s4,32(sp)
    8000083e:	ec56                	sd	s5,24(sp)
    80000840:	e85a                	sd	s6,16(sp)
    80000842:	e45e                	sd	s7,8(sp)
    80000844:	8a2a                	mv	s4,a0
    80000846:	892e                	mv	s2,a1
    80000848:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for (a = va; a < va + npages * PGSIZE; a += PGSIZE)
    8000084a:	0632                	slli	a2,a2,0xc
    8000084c:	00b609b3          	add	s3,a2,a1
  {
    if ((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if ((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if (PTE_FLAGS(*pte) == PTE_V)
    80000850:	4b85                	li	s7,1
  for (a = va; a < va + npages * PGSIZE; a += PGSIZE)
    80000852:	6b05                	lui	s6,0x1
    80000854:	0935fb63          	bgeu	a1,s3,800008ea <uvmunmap+0xc0>
    80000858:	fc26                	sd	s1,56(sp)
    8000085a:	a8a9                	j	800008b4 <uvmunmap+0x8a>
    8000085c:	fc26                	sd	s1,56(sp)
    8000085e:	f84a                	sd	s2,48(sp)
    80000860:	f44e                	sd	s3,40(sp)
    80000862:	f052                	sd	s4,32(sp)
    80000864:	ec56                	sd	s5,24(sp)
    80000866:	e85a                	sd	s6,16(sp)
    80000868:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    8000086a:	00008517          	auipc	a0,0x8
    8000086e:	82650513          	addi	a0,a0,-2010 # 80008090 <etext+0x90>
    80000872:	00005097          	auipc	ra,0x5
    80000876:	610080e7          	jalr	1552(ra) # 80005e82 <panic>
      panic("uvmunmap: walk");
    8000087a:	00008517          	auipc	a0,0x8
    8000087e:	82e50513          	addi	a0,a0,-2002 # 800080a8 <etext+0xa8>
    80000882:	00005097          	auipc	ra,0x5
    80000886:	600080e7          	jalr	1536(ra) # 80005e82 <panic>
      panic("uvmunmap: not mapped");
    8000088a:	00008517          	auipc	a0,0x8
    8000088e:	82e50513          	addi	a0,a0,-2002 # 800080b8 <etext+0xb8>
    80000892:	00005097          	auipc	ra,0x5
    80000896:	5f0080e7          	jalr	1520(ra) # 80005e82 <panic>
      panic("uvmunmap: not a leaf");
    8000089a:	00008517          	auipc	a0,0x8
    8000089e:	83650513          	addi	a0,a0,-1994 # 800080d0 <etext+0xd0>
    800008a2:	00005097          	auipc	ra,0x5
    800008a6:	5e0080e7          	jalr	1504(ra) # 80005e82 <panic>
    if (do_free)
    {
      uint64 pa = PTE2PA(*pte);
      kfree((void *)pa);
    }
    *pte = 0;
    800008aa:	0004b023          	sd	zero,0(s1)
  for (a = va; a < va + npages * PGSIZE; a += PGSIZE)
    800008ae:	995a                	add	s2,s2,s6
    800008b0:	03397c63          	bgeu	s2,s3,800008e8 <uvmunmap+0xbe>
    if ((pte = walk(pagetable, a, 0)) == 0)
    800008b4:	4601                	li	a2,0
    800008b6:	85ca                	mv	a1,s2
    800008b8:	8552                	mv	a0,s4
    800008ba:	00000097          	auipc	ra,0x0
    800008be:	cc2080e7          	jalr	-830(ra) # 8000057c <walk>
    800008c2:	84aa                	mv	s1,a0
    800008c4:	d95d                	beqz	a0,8000087a <uvmunmap+0x50>
    if ((*pte & PTE_V) == 0)
    800008c6:	6108                	ld	a0,0(a0)
    800008c8:	00157793          	andi	a5,a0,1
    800008cc:	dfdd                	beqz	a5,8000088a <uvmunmap+0x60>
    if (PTE_FLAGS(*pte) == PTE_V)
    800008ce:	3ff57793          	andi	a5,a0,1023
    800008d2:	fd7784e3          	beq	a5,s7,8000089a <uvmunmap+0x70>
    if (do_free)
    800008d6:	fc0a8ae3          	beqz	s5,800008aa <uvmunmap+0x80>
      uint64 pa = PTE2PA(*pte);
    800008da:	8129                	srli	a0,a0,0xa
      kfree((void *)pa);
    800008dc:	0532                	slli	a0,a0,0xc
    800008de:	fffff097          	auipc	ra,0xfffff
    800008e2:	7d6080e7          	jalr	2006(ra) # 800000b4 <kfree>
    800008e6:	b7d1                	j	800008aa <uvmunmap+0x80>
    800008e8:	74e2                	ld	s1,56(sp)
    800008ea:	7942                	ld	s2,48(sp)
    800008ec:	79a2                	ld	s3,40(sp)
    800008ee:	7a02                	ld	s4,32(sp)
    800008f0:	6ae2                	ld	s5,24(sp)
    800008f2:	6b42                	ld	s6,16(sp)
    800008f4:	6ba2                	ld	s7,8(sp)
  }
}
    800008f6:	60a6                	ld	ra,72(sp)
    800008f8:	6406                	ld	s0,64(sp)
    800008fa:	6161                	addi	sp,sp,80
    800008fc:	8082                	ret

00000000800008fe <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800008fe:	1101                	addi	sp,sp,-32
    80000900:	ec06                	sd	ra,24(sp)
    80000902:	e822                	sd	s0,16(sp)
    80000904:	e426                	sd	s1,8(sp)
    80000906:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t)kalloc();
    80000908:	00000097          	auipc	ra,0x0
    8000090c:	902080e7          	jalr	-1790(ra) # 8000020a <kalloc>
    80000910:	84aa                	mv	s1,a0
  if (pagetable == 0)
    80000912:	c519                	beqz	a0,80000920 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000914:	6605                	lui	a2,0x1
    80000916:	4581                	li	a1,0
    80000918:	00000097          	auipc	ra,0x0
    8000091c:	96c080e7          	jalr	-1684(ra) # 80000284 <memset>
  return pagetable;
}
    80000920:	8526                	mv	a0,s1
    80000922:	60e2                	ld	ra,24(sp)
    80000924:	6442                	ld	s0,16(sp)
    80000926:	64a2                	ld	s1,8(sp)
    80000928:	6105                	addi	sp,sp,32
    8000092a:	8082                	ret

000000008000092c <uvminit>:

// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    8000092c:	7179                	addi	sp,sp,-48
    8000092e:	f406                	sd	ra,40(sp)
    80000930:	f022                	sd	s0,32(sp)
    80000932:	ec26                	sd	s1,24(sp)
    80000934:	e84a                	sd	s2,16(sp)
    80000936:	e44e                	sd	s3,8(sp)
    80000938:	e052                	sd	s4,0(sp)
    8000093a:	1800                	addi	s0,sp,48
  char *mem;

  if (sz >= PGSIZE)
    8000093c:	6785                	lui	a5,0x1
    8000093e:	04f67863          	bgeu	a2,a5,8000098e <uvminit+0x62>
    80000942:	8a2a                	mv	s4,a0
    80000944:	89ae                	mv	s3,a1
    80000946:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    80000948:	00000097          	auipc	ra,0x0
    8000094c:	8c2080e7          	jalr	-1854(ra) # 8000020a <kalloc>
    80000950:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000952:	6605                	lui	a2,0x1
    80000954:	4581                	li	a1,0
    80000956:	00000097          	auipc	ra,0x0
    8000095a:	92e080e7          	jalr	-1746(ra) # 80000284 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W | PTE_R | PTE_X | PTE_U);
    8000095e:	4779                	li	a4,30
    80000960:	86ca                	mv	a3,s2
    80000962:	6605                	lui	a2,0x1
    80000964:	4581                	li	a1,0
    80000966:	8552                	mv	a0,s4
    80000968:	00000097          	auipc	ra,0x0
    8000096c:	cfc080e7          	jalr	-772(ra) # 80000664 <mappages>
  memmove(mem, src, sz);
    80000970:	8626                	mv	a2,s1
    80000972:	85ce                	mv	a1,s3
    80000974:	854a                	mv	a0,s2
    80000976:	00000097          	auipc	ra,0x0
    8000097a:	972080e7          	jalr	-1678(ra) # 800002e8 <memmove>
}
    8000097e:	70a2                	ld	ra,40(sp)
    80000980:	7402                	ld	s0,32(sp)
    80000982:	64e2                	ld	s1,24(sp)
    80000984:	6942                	ld	s2,16(sp)
    80000986:	69a2                	ld	s3,8(sp)
    80000988:	6a02                	ld	s4,0(sp)
    8000098a:	6145                	addi	sp,sp,48
    8000098c:	8082                	ret
    panic("inituvm: more than a page");
    8000098e:	00007517          	auipc	a0,0x7
    80000992:	75a50513          	addi	a0,a0,1882 # 800080e8 <etext+0xe8>
    80000996:	00005097          	auipc	ra,0x5
    8000099a:	4ec080e7          	jalr	1260(ra) # 80005e82 <panic>

000000008000099e <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000099e:	1101                	addi	sp,sp,-32
    800009a0:	ec06                	sd	ra,24(sp)
    800009a2:	e822                	sd	s0,16(sp)
    800009a4:	e426                	sd	s1,8(sp)
    800009a6:	1000                	addi	s0,sp,32
  if (newsz >= oldsz)
    return oldsz;
    800009a8:	84ae                	mv	s1,a1
  if (newsz >= oldsz)
    800009aa:	00b67d63          	bgeu	a2,a1,800009c4 <uvmdealloc+0x26>
    800009ae:	84b2                	mv	s1,a2

  if (PGROUNDUP(newsz) < PGROUNDUP(oldsz))
    800009b0:	6785                	lui	a5,0x1
    800009b2:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800009b4:	00f60733          	add	a4,a2,a5
    800009b8:	76fd                	lui	a3,0xfffff
    800009ba:	8f75                	and	a4,a4,a3
    800009bc:	97ae                	add	a5,a5,a1
    800009be:	8ff5                	and	a5,a5,a3
    800009c0:	00f76863          	bltu	a4,a5,800009d0 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800009c4:	8526                	mv	a0,s1
    800009c6:	60e2                	ld	ra,24(sp)
    800009c8:	6442                	ld	s0,16(sp)
    800009ca:	64a2                	ld	s1,8(sp)
    800009cc:	6105                	addi	sp,sp,32
    800009ce:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800009d0:	8f99                	sub	a5,a5,a4
    800009d2:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800009d4:	4685                	li	a3,1
    800009d6:	0007861b          	sext.w	a2,a5
    800009da:	85ba                	mv	a1,a4
    800009dc:	00000097          	auipc	ra,0x0
    800009e0:	e4e080e7          	jalr	-434(ra) # 8000082a <uvmunmap>
    800009e4:	b7c5                	j	800009c4 <uvmdealloc+0x26>

00000000800009e6 <uvmalloc>:
  if (newsz < oldsz)
    800009e6:	0ab66e63          	bltu	a2,a1,80000aa2 <uvmalloc+0xbc>
{
    800009ea:	715d                	addi	sp,sp,-80
    800009ec:	e486                	sd	ra,72(sp)
    800009ee:	e0a2                	sd	s0,64(sp)
    800009f0:	f052                	sd	s4,32(sp)
    800009f2:	ec56                	sd	s5,24(sp)
    800009f4:	e85a                	sd	s6,16(sp)
    800009f6:	0880                	addi	s0,sp,80
    800009f8:	8b2a                	mv	s6,a0
    800009fa:	8ab2                	mv	s5,a2
  oldsz = PGROUNDUP(oldsz);
    800009fc:	6785                	lui	a5,0x1
    800009fe:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000a00:	95be                	add	a1,a1,a5
    80000a02:	77fd                	lui	a5,0xfffff
    80000a04:	00f5fa33          	and	s4,a1,a5
  for (a = oldsz; a < newsz; a += PGSIZE)
    80000a08:	08ca7f63          	bgeu	s4,a2,80000aa6 <uvmalloc+0xc0>
    80000a0c:	fc26                	sd	s1,56(sp)
    80000a0e:	f84a                	sd	s2,48(sp)
    80000a10:	f44e                	sd	s3,40(sp)
    80000a12:	e45e                	sd	s7,8(sp)
    80000a14:	8952                	mv	s2,s4
    memset(mem, 0, PGSIZE);
    80000a16:	6985                	lui	s3,0x1
    if (mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W | PTE_X | PTE_R | PTE_U) != 0)
    80000a18:	4bf9                	li	s7,30
    mem = kalloc();
    80000a1a:	fffff097          	auipc	ra,0xfffff
    80000a1e:	7f0080e7          	jalr	2032(ra) # 8000020a <kalloc>
    80000a22:	84aa                	mv	s1,a0
    if (mem == 0)
    80000a24:	c915                	beqz	a0,80000a58 <uvmalloc+0x72>
    memset(mem, 0, PGSIZE);
    80000a26:	864e                	mv	a2,s3
    80000a28:	4581                	li	a1,0
    80000a2a:	00000097          	auipc	ra,0x0
    80000a2e:	85a080e7          	jalr	-1958(ra) # 80000284 <memset>
    if (mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W | PTE_X | PTE_R | PTE_U) != 0)
    80000a32:	875e                	mv	a4,s7
    80000a34:	86a6                	mv	a3,s1
    80000a36:	864e                	mv	a2,s3
    80000a38:	85ca                	mv	a1,s2
    80000a3a:	855a                	mv	a0,s6
    80000a3c:	00000097          	auipc	ra,0x0
    80000a40:	c28080e7          	jalr	-984(ra) # 80000664 <mappages>
    80000a44:	ed0d                	bnez	a0,80000a7e <uvmalloc+0x98>
  for (a = oldsz; a < newsz; a += PGSIZE)
    80000a46:	994e                	add	s2,s2,s3
    80000a48:	fd5969e3          	bltu	s2,s5,80000a1a <uvmalloc+0x34>
  return newsz;
    80000a4c:	8556                	mv	a0,s5
    80000a4e:	74e2                	ld	s1,56(sp)
    80000a50:	7942                	ld	s2,48(sp)
    80000a52:	79a2                	ld	s3,40(sp)
    80000a54:	6ba2                	ld	s7,8(sp)
    80000a56:	a829                	j	80000a70 <uvmalloc+0x8a>
      uvmdealloc(pagetable, a, oldsz);
    80000a58:	8652                	mv	a2,s4
    80000a5a:	85ca                	mv	a1,s2
    80000a5c:	855a                	mv	a0,s6
    80000a5e:	00000097          	auipc	ra,0x0
    80000a62:	f40080e7          	jalr	-192(ra) # 8000099e <uvmdealloc>
      return 0;
    80000a66:	4501                	li	a0,0
    80000a68:	74e2                	ld	s1,56(sp)
    80000a6a:	7942                	ld	s2,48(sp)
    80000a6c:	79a2                	ld	s3,40(sp)
    80000a6e:	6ba2                	ld	s7,8(sp)
}
    80000a70:	60a6                	ld	ra,72(sp)
    80000a72:	6406                	ld	s0,64(sp)
    80000a74:	7a02                	ld	s4,32(sp)
    80000a76:	6ae2                	ld	s5,24(sp)
    80000a78:	6b42                	ld	s6,16(sp)
    80000a7a:	6161                	addi	sp,sp,80
    80000a7c:	8082                	ret
      kfree(mem);
    80000a7e:	8526                	mv	a0,s1
    80000a80:	fffff097          	auipc	ra,0xfffff
    80000a84:	634080e7          	jalr	1588(ra) # 800000b4 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000a88:	8652                	mv	a2,s4
    80000a8a:	85ca                	mv	a1,s2
    80000a8c:	855a                	mv	a0,s6
    80000a8e:	00000097          	auipc	ra,0x0
    80000a92:	f10080e7          	jalr	-240(ra) # 8000099e <uvmdealloc>
      return 0;
    80000a96:	4501                	li	a0,0
    80000a98:	74e2                	ld	s1,56(sp)
    80000a9a:	7942                	ld	s2,48(sp)
    80000a9c:	79a2                	ld	s3,40(sp)
    80000a9e:	6ba2                	ld	s7,8(sp)
    80000aa0:	bfc1                	j	80000a70 <uvmalloc+0x8a>
    return oldsz;
    80000aa2:	852e                	mv	a0,a1
}
    80000aa4:	8082                	ret
  return newsz;
    80000aa6:	8532                	mv	a0,a2
    80000aa8:	b7e1                	j	80000a70 <uvmalloc+0x8a>

0000000080000aaa <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void freewalk(pagetable_t pagetable)
{
    80000aaa:	7179                	addi	sp,sp,-48
    80000aac:	f406                	sd	ra,40(sp)
    80000aae:	f022                	sd	s0,32(sp)
    80000ab0:	ec26                	sd	s1,24(sp)
    80000ab2:	e84a                	sd	s2,16(sp)
    80000ab4:	e44e                	sd	s3,8(sp)
    80000ab6:	e052                	sd	s4,0(sp)
    80000ab8:	1800                	addi	s0,sp,48
    80000aba:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for (int i = 0; i < 512; i++)
    80000abc:	84aa                	mv	s1,a0
    80000abe:	6905                	lui	s2,0x1
    80000ac0:	992a                	add	s2,s2,a0
  {
    pte_t pte = pagetable[i];
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0)
    80000ac2:	4985                	li	s3,1
    80000ac4:	a829                	j	80000ade <freewalk+0x34>
    {
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000ac6:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80000ac8:	00c79513          	slli	a0,a5,0xc
    80000acc:	00000097          	auipc	ra,0x0
    80000ad0:	fde080e7          	jalr	-34(ra) # 80000aaa <freewalk>
      pagetable[i] = 0;
    80000ad4:	0004b023          	sd	zero,0(s1)
  for (int i = 0; i < 512; i++)
    80000ad8:	04a1                	addi	s1,s1,8
    80000ada:	03248163          	beq	s1,s2,80000afc <freewalk+0x52>
    pte_t pte = pagetable[i];
    80000ade:	609c                	ld	a5,0(s1)
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0)
    80000ae0:	00f7f713          	andi	a4,a5,15
    80000ae4:	ff3701e3          	beq	a4,s3,80000ac6 <freewalk+0x1c>
    }
    else if (pte & PTE_V)
    80000ae8:	8b85                	andi	a5,a5,1
    80000aea:	d7fd                	beqz	a5,80000ad8 <freewalk+0x2e>
    {
      panic("freewalk: leaf");
    80000aec:	00007517          	auipc	a0,0x7
    80000af0:	61c50513          	addi	a0,a0,1564 # 80008108 <etext+0x108>
    80000af4:	00005097          	auipc	ra,0x5
    80000af8:	38e080e7          	jalr	910(ra) # 80005e82 <panic>
    }
  }
  kfree((void *)pagetable);
    80000afc:	8552                	mv	a0,s4
    80000afe:	fffff097          	auipc	ra,0xfffff
    80000b02:	5b6080e7          	jalr	1462(ra) # 800000b4 <kfree>
}
    80000b06:	70a2                	ld	ra,40(sp)
    80000b08:	7402                	ld	s0,32(sp)
    80000b0a:	64e2                	ld	s1,24(sp)
    80000b0c:	6942                	ld	s2,16(sp)
    80000b0e:	69a2                	ld	s3,8(sp)
    80000b10:	6a02                	ld	s4,0(sp)
    80000b12:	6145                	addi	sp,sp,48
    80000b14:	8082                	ret

0000000080000b16 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000b16:	1101                	addi	sp,sp,-32
    80000b18:	ec06                	sd	ra,24(sp)
    80000b1a:	e822                	sd	s0,16(sp)
    80000b1c:	e426                	sd	s1,8(sp)
    80000b1e:	1000                	addi	s0,sp,32
    80000b20:	84aa                	mv	s1,a0
  if (sz > 0)
    80000b22:	e999                	bnez	a1,80000b38 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
  freewalk(pagetable);
    80000b24:	8526                	mv	a0,s1
    80000b26:	00000097          	auipc	ra,0x0
    80000b2a:	f84080e7          	jalr	-124(ra) # 80000aaa <freewalk>
}
    80000b2e:	60e2                	ld	ra,24(sp)
    80000b30:	6442                	ld	s0,16(sp)
    80000b32:	64a2                	ld	s1,8(sp)
    80000b34:	6105                	addi	sp,sp,32
    80000b36:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
    80000b38:	6785                	lui	a5,0x1
    80000b3a:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000b3c:	95be                	add	a1,a1,a5
    80000b3e:	4685                	li	a3,1
    80000b40:	00c5d613          	srli	a2,a1,0xc
    80000b44:	4581                	li	a1,0
    80000b46:	00000097          	auipc	ra,0x0
    80000b4a:	ce4080e7          	jalr	-796(ra) # 8000082a <uvmunmap>
    80000b4e:	bfd9                	j	80000b24 <uvmfree+0xe>

0000000080000b50 <uvmcopy>:
// Copies both the page table and the
// physical memory.
// returns 0 on success, -1 on failure.
// frees any allocated pages on failure.
int uvmcopy(pagetable_t old, pagetable_t new, uint64 sz)
{
    80000b50:	7159                	addi	sp,sp,-112
    80000b52:	f486                	sd	ra,104(sp)
    80000b54:	f0a2                	sd	s0,96(sp)
    80000b56:	f85a                	sd	s6,48(sp)
    80000b58:	1880                	addi	s0,sp,112
  pte_t *pte;
  uint64 pa, i;
  uint flags;

  for (i = 0; i < sz; i += PGSIZE)
    80000b5a:	c66d                	beqz	a2,80000c44 <uvmcopy+0xf4>
    80000b5c:	eca6                	sd	s1,88(sp)
    80000b5e:	e8ca                	sd	s2,80(sp)
    80000b60:	e4ce                	sd	s3,72(sp)
    80000b62:	e0d2                	sd	s4,64(sp)
    80000b64:	fc56                	sd	s5,56(sp)
    80000b66:	f45e                	sd	s7,40(sp)
    80000b68:	f062                	sd	s8,32(sp)
    80000b6a:	ec66                	sd	s9,24(sp)
    80000b6c:	e86a                	sd	s10,16(sp)
    80000b6e:	e46e                	sd	s11,8(sp)
    80000b70:	8d2a                	mv	s10,a0
    80000b72:	8cae                	mv	s9,a1
    80000b74:	8c32                	mv	s8,a2
    80000b76:	4a01                	li	s4,0

    flags = PTE_FLAGS(*pte);
    flags &= ~PTE_W;
    flags |= PTE_C; // mark as copy-on-write

    if (mappages(new, i, PGSIZE, pa, flags) != 0)
    80000b78:	6b85                	lui	s7,0x1
    {
      goto err;
    }
    *pte = PA2PTE(pa) | flags;
    80000b7a:	7dfd                	lui	s11,0xfffff
    80000b7c:	002ddd93          	srli	s11,s11,0x2
    if ((pte = walk(old, i, 0)) == 0)
    80000b80:	4601                	li	a2,0
    80000b82:	85d2                	mv	a1,s4
    80000b84:	856a                	mv	a0,s10
    80000b86:	00000097          	auipc	ra,0x0
    80000b8a:	9f6080e7          	jalr	-1546(ra) # 8000057c <walk>
    80000b8e:	89aa                	mv	s3,a0
    80000b90:	c125                	beqz	a0,80000bf0 <uvmcopy+0xa0>
    if ((*pte & PTE_V) == 0)
    80000b92:	6104                	ld	s1,0(a0)
    80000b94:	0014f793          	andi	a5,s1,1
    80000b98:	c7a5                	beqz	a5,80000c00 <uvmcopy+0xb0>
    pa = PTE2PA(*pte);
    80000b9a:	00a4da93          	srli	s5,s1,0xa
    80000b9e:	0ab2                	slli	s5,s5,0xc
    flags &= ~PTE_W;
    80000ba0:	3fb4f913          	andi	s2,s1,1019
    flags |= PTE_C; // mark as copy-on-write
    80000ba4:	10096913          	ori	s2,s2,256
    if (mappages(new, i, PGSIZE, pa, flags) != 0)
    80000ba8:	874a                	mv	a4,s2
    80000baa:	86d6                	mv	a3,s5
    80000bac:	865e                	mv	a2,s7
    80000bae:	85d2                	mv	a1,s4
    80000bb0:	8566                	mv	a0,s9
    80000bb2:	00000097          	auipc	ra,0x0
    80000bb6:	ab2080e7          	jalr	-1358(ra) # 80000664 <mappages>
    80000bba:	8b2a                	mv	s6,a0
    80000bbc:	e931                	bnez	a0,80000c10 <uvmcopy+0xc0>
    *pte = PA2PTE(pa) | flags;
    80000bbe:	01b4f4b3          	and	s1,s1,s11
    80000bc2:	00996933          	or	s2,s2,s1
    80000bc6:	0129b023          	sd	s2,0(s3) # 1000 <_entry-0x7ffff000>
    refcnt_incr(pa); // increment reference count for the physical page
    80000bca:	8556                	mv	a0,s5
    80000bcc:	fffff097          	auipc	ra,0xfffff
    80000bd0:	450080e7          	jalr	1104(ra) # 8000001c <refcnt_incr>
  for (i = 0; i < sz; i += PGSIZE)
    80000bd4:	9a5e                	add	s4,s4,s7
    80000bd6:	fb8a65e3          	bltu	s4,s8,80000b80 <uvmcopy+0x30>
    80000bda:	64e6                	ld	s1,88(sp)
    80000bdc:	6946                	ld	s2,80(sp)
    80000bde:	69a6                	ld	s3,72(sp)
    80000be0:	6a06                	ld	s4,64(sp)
    80000be2:	7ae2                	ld	s5,56(sp)
    80000be4:	7ba2                	ld	s7,40(sp)
    80000be6:	7c02                	ld	s8,32(sp)
    80000be8:	6ce2                	ld	s9,24(sp)
    80000bea:	6d42                	ld	s10,16(sp)
    80000bec:	6da2                	ld	s11,8(sp)
    80000bee:	a0a9                	j	80000c38 <uvmcopy+0xe8>
      panic("uvmcopy: pte should exist");
    80000bf0:	00007517          	auipc	a0,0x7
    80000bf4:	52850513          	addi	a0,a0,1320 # 80008118 <etext+0x118>
    80000bf8:	00005097          	auipc	ra,0x5
    80000bfc:	28a080e7          	jalr	650(ra) # 80005e82 <panic>
      panic("uvmcopy: page not present");
    80000c00:	00007517          	auipc	a0,0x7
    80000c04:	53850513          	addi	a0,a0,1336 # 80008138 <etext+0x138>
    80000c08:	00005097          	auipc	ra,0x5
    80000c0c:	27a080e7          	jalr	634(ra) # 80005e82 <panic>
  }
  return 0;

err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000c10:	4685                	li	a3,1
    80000c12:	00ca5613          	srli	a2,s4,0xc
    80000c16:	4581                	li	a1,0
    80000c18:	8566                	mv	a0,s9
    80000c1a:	00000097          	auipc	ra,0x0
    80000c1e:	c10080e7          	jalr	-1008(ra) # 8000082a <uvmunmap>
  return -1;
    80000c22:	5b7d                	li	s6,-1
    80000c24:	64e6                	ld	s1,88(sp)
    80000c26:	6946                	ld	s2,80(sp)
    80000c28:	69a6                	ld	s3,72(sp)
    80000c2a:	6a06                	ld	s4,64(sp)
    80000c2c:	7ae2                	ld	s5,56(sp)
    80000c2e:	7ba2                	ld	s7,40(sp)
    80000c30:	7c02                	ld	s8,32(sp)
    80000c32:	6ce2                	ld	s9,24(sp)
    80000c34:	6d42                	ld	s10,16(sp)
    80000c36:	6da2                	ld	s11,8(sp)
}
    80000c38:	855a                	mv	a0,s6
    80000c3a:	70a6                	ld	ra,104(sp)
    80000c3c:	7406                	ld	s0,96(sp)
    80000c3e:	7b42                	ld	s6,48(sp)
    80000c40:	6165                	addi	sp,sp,112
    80000c42:	8082                	ret
  return 0;
    80000c44:	4b01                	li	s6,0
    80000c46:	bfcd                	j	80000c38 <uvmcopy+0xe8>

0000000080000c48 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void uvmclear(pagetable_t pagetable, uint64 va)
{
    80000c48:	1141                	addi	sp,sp,-16
    80000c4a:	e406                	sd	ra,8(sp)
    80000c4c:	e022                	sd	s0,0(sp)
    80000c4e:	0800                	addi	s0,sp,16
  pte_t *pte;

  pte = walk(pagetable, va, 0);
    80000c50:	4601                	li	a2,0
    80000c52:	00000097          	auipc	ra,0x0
    80000c56:	92a080e7          	jalr	-1750(ra) # 8000057c <walk>
  if (pte == 0)
    80000c5a:	c901                	beqz	a0,80000c6a <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000c5c:	611c                	ld	a5,0(a0)
    80000c5e:	9bbd                	andi	a5,a5,-17
    80000c60:	e11c                	sd	a5,0(a0)
}
    80000c62:	60a2                	ld	ra,8(sp)
    80000c64:	6402                	ld	s0,0(sp)
    80000c66:	0141                	addi	sp,sp,16
    80000c68:	8082                	ret
    panic("uvmclear");
    80000c6a:	00007517          	auipc	a0,0x7
    80000c6e:	4ee50513          	addi	a0,a0,1262 # 80008158 <etext+0x158>
    80000c72:	00005097          	auipc	ra,0x5
    80000c76:	210080e7          	jalr	528(ra) # 80005e82 <panic>

0000000080000c7a <copyout>:
// Return 0 on success, -1 on error.
int copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  
  while(len > 0) {
    80000c7a:	cebd                	beqz	a3,80000cf8 <copyout+0x7e>
{
    80000c7c:	715d                	addi	sp,sp,-80
    80000c7e:	e486                	sd	ra,72(sp)
    80000c80:	e0a2                	sd	s0,64(sp)
    80000c82:	fc26                	sd	s1,56(sp)
    80000c84:	f84a                	sd	s2,48(sp)
    80000c86:	f44e                	sd	s3,40(sp)
    80000c88:	f052                	sd	s4,32(sp)
    80000c8a:	ec56                	sd	s5,24(sp)
    80000c8c:	e85a                	sd	s6,16(sp)
    80000c8e:	e45e                	sd	s7,8(sp)
    80000c90:	e062                	sd	s8,0(sp)
    80000c92:	0880                	addi	s0,sp,80
    80000c94:	8b2a                	mv	s6,a0
    80000c96:	84ae                	mv	s1,a1
    80000c98:	8ab2                	mv	s5,a2
    80000c9a:	8a36                	mv	s4,a3
    va0 = PGROUNDDOWN(dstva);
    80000c9c:	7c7d                	lui	s8,0xfffff
      return -1; // copy-on-write failed
    // If the page is not present, we need to allocate it.
    pa0 = walkaddr(pagetable, va0);
    if (pa0 == 0)
      return -1; // page not present
    n = PGSIZE - (dstva - va0);
    80000c9e:	6b85                	lui	s7,0x1
    80000ca0:	a015                	j	80000cc4 <copyout+0x4a>
    if (n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000ca2:	413484b3          	sub	s1,s1,s3
    80000ca6:	0009061b          	sext.w	a2,s2
    80000caa:	85d6                	mv	a1,s5
    80000cac:	9526                	add	a0,a0,s1
    80000cae:	fffff097          	auipc	ra,0xfffff
    80000cb2:	63a080e7          	jalr	1594(ra) # 800002e8 <memmove>

    len -= n;
    80000cb6:	412a0a33          	sub	s4,s4,s2
    src += n;
    80000cba:	9aca                	add	s5,s5,s2
    dstva = va0 + PGSIZE;
    80000cbc:	017984b3          	add	s1,s3,s7
  while(len > 0) {
    80000cc0:	020a0a63          	beqz	s4,80000cf4 <copyout+0x7a>
    va0 = PGROUNDDOWN(dstva);
    80000cc4:	0184f9b3          	and	s3,s1,s8
    if(cow(dstva, pagetable) < 0)
    80000cc8:	85da                	mv	a1,s6
    80000cca:	8526                	mv	a0,s1
    80000ccc:	00001097          	auipc	ra,0x1
    80000cd0:	f84080e7          	jalr	-124(ra) # 80001c50 <cow>
    80000cd4:	02054463          	bltz	a0,80000cfc <copyout+0x82>
    pa0 = walkaddr(pagetable, va0);
    80000cd8:	85ce                	mv	a1,s3
    80000cda:	855a                	mv	a0,s6
    80000cdc:	00000097          	auipc	ra,0x0
    80000ce0:	946080e7          	jalr	-1722(ra) # 80000622 <walkaddr>
    if (pa0 == 0)
    80000ce4:	c90d                	beqz	a0,80000d16 <copyout+0x9c>
    n = PGSIZE - (dstva - va0);
    80000ce6:	40998933          	sub	s2,s3,s1
    80000cea:	995e                	add	s2,s2,s7
    if (n > len)
    80000cec:	fb2a7be3          	bgeu	s4,s2,80000ca2 <copyout+0x28>
    80000cf0:	8952                	mv	s2,s4
    80000cf2:	bf45                	j	80000ca2 <copyout+0x28>
  }
  return 0;
    80000cf4:	4501                	li	a0,0
    80000cf6:	a021                	j	80000cfe <copyout+0x84>
    80000cf8:	4501                	li	a0,0
}
    80000cfa:	8082                	ret
      return -1; // copy-on-write failed
    80000cfc:	557d                	li	a0,-1
}
    80000cfe:	60a6                	ld	ra,72(sp)
    80000d00:	6406                	ld	s0,64(sp)
    80000d02:	74e2                	ld	s1,56(sp)
    80000d04:	7942                	ld	s2,48(sp)
    80000d06:	79a2                	ld	s3,40(sp)
    80000d08:	7a02                	ld	s4,32(sp)
    80000d0a:	6ae2                	ld	s5,24(sp)
    80000d0c:	6b42                	ld	s6,16(sp)
    80000d0e:	6ba2                	ld	s7,8(sp)
    80000d10:	6c02                	ld	s8,0(sp)
    80000d12:	6161                	addi	sp,sp,80
    80000d14:	8082                	ret
      return -1; // page not present
    80000d16:	557d                	li	a0,-1
    80000d18:	b7dd                	j	80000cfe <copyout+0x84>

0000000080000d1a <copyin>:
// Return 0 on success, -1 on error.
int copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while (len > 0)
    80000d1a:	caa5                	beqz	a3,80000d8a <copyin+0x70>
{
    80000d1c:	715d                	addi	sp,sp,-80
    80000d1e:	e486                	sd	ra,72(sp)
    80000d20:	e0a2                	sd	s0,64(sp)
    80000d22:	fc26                	sd	s1,56(sp)
    80000d24:	f84a                	sd	s2,48(sp)
    80000d26:	f44e                	sd	s3,40(sp)
    80000d28:	f052                	sd	s4,32(sp)
    80000d2a:	ec56                	sd	s5,24(sp)
    80000d2c:	e85a                	sd	s6,16(sp)
    80000d2e:	e45e                	sd	s7,8(sp)
    80000d30:	e062                	sd	s8,0(sp)
    80000d32:	0880                	addi	s0,sp,80
    80000d34:	8b2a                	mv	s6,a0
    80000d36:	8a2e                	mv	s4,a1
    80000d38:	8c32                	mv	s8,a2
    80000d3a:	89b6                	mv	s3,a3
  {
    va0 = PGROUNDDOWN(srcva);
    80000d3c:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if (pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000d3e:	6a85                	lui	s5,0x1
    80000d40:	a01d                	j	80000d66 <copyin+0x4c>
    if (n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000d42:	018505b3          	add	a1,a0,s8
    80000d46:	0004861b          	sext.w	a2,s1
    80000d4a:	412585b3          	sub	a1,a1,s2
    80000d4e:	8552                	mv	a0,s4
    80000d50:	fffff097          	auipc	ra,0xfffff
    80000d54:	598080e7          	jalr	1432(ra) # 800002e8 <memmove>

    len -= n;
    80000d58:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000d5c:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000d5e:	01590c33          	add	s8,s2,s5
  while (len > 0)
    80000d62:	02098263          	beqz	s3,80000d86 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000d66:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000d6a:	85ca                	mv	a1,s2
    80000d6c:	855a                	mv	a0,s6
    80000d6e:	00000097          	auipc	ra,0x0
    80000d72:	8b4080e7          	jalr	-1868(ra) # 80000622 <walkaddr>
    if (pa0 == 0)
    80000d76:	cd01                	beqz	a0,80000d8e <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000d78:	418904b3          	sub	s1,s2,s8
    80000d7c:	94d6                	add	s1,s1,s5
    if (n > len)
    80000d7e:	fc99f2e3          	bgeu	s3,s1,80000d42 <copyin+0x28>
    80000d82:	84ce                	mv	s1,s3
    80000d84:	bf7d                	j	80000d42 <copyin+0x28>
  }
  return 0;
    80000d86:	4501                	li	a0,0
    80000d88:	a021                	j	80000d90 <copyin+0x76>
    80000d8a:	4501                	li	a0,0
}
    80000d8c:	8082                	ret
      return -1;
    80000d8e:	557d                	li	a0,-1
}
    80000d90:	60a6                	ld	ra,72(sp)
    80000d92:	6406                	ld	s0,64(sp)
    80000d94:	74e2                	ld	s1,56(sp)
    80000d96:	7942                	ld	s2,48(sp)
    80000d98:	79a2                	ld	s3,40(sp)
    80000d9a:	7a02                	ld	s4,32(sp)
    80000d9c:	6ae2                	ld	s5,24(sp)
    80000d9e:	6b42                	ld	s6,16(sp)
    80000da0:	6ba2                	ld	s7,8(sp)
    80000da2:	6c02                	ld	s8,0(sp)
    80000da4:	6161                	addi	sp,sp,80
    80000da6:	8082                	ret

0000000080000da8 <copyinstr>:
// Copy a null-terminated string from user to kernel.
// Copy bytes to dst from virtual address srcva in a given page table,
// until a '\0', or max.
// Return 0 on success, -1 on error.
int copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
    80000da8:	715d                	addi	sp,sp,-80
    80000daa:	e486                	sd	ra,72(sp)
    80000dac:	e0a2                	sd	s0,64(sp)
    80000dae:	fc26                	sd	s1,56(sp)
    80000db0:	f84a                	sd	s2,48(sp)
    80000db2:	f44e                	sd	s3,40(sp)
    80000db4:	f052                	sd	s4,32(sp)
    80000db6:	ec56                	sd	s5,24(sp)
    80000db8:	e85a                	sd	s6,16(sp)
    80000dba:	e45e                	sd	s7,8(sp)
    80000dbc:	0880                	addi	s0,sp,80
    80000dbe:	8aaa                	mv	s5,a0
    80000dc0:	89ae                	mv	s3,a1
    80000dc2:	8bb2                	mv	s7,a2
    80000dc4:	84b6                	mv	s1,a3
  uint64 n, va0, pa0;
  int got_null = 0;

  while (got_null == 0 && max > 0)
  {
    va0 = PGROUNDDOWN(srcva);
    80000dc6:	7b7d                	lui	s6,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if (pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000dc8:	6a05                	lui	s4,0x1
    80000dca:	a02d                	j	80000df4 <copyinstr+0x4c>
    char *p = (char *)(pa0 + (srcva - va0));
    while (n > 0)
    {
      if (*p == '\0')
      {
        *dst = '\0';
    80000dcc:	00078023          	sb	zero,0(a5)
    80000dd0:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if (got_null)
    80000dd2:	0017c793          	xori	a5,a5,1
    80000dd6:	40f0053b          	negw	a0,a5
  }
  else
  {
    return -1;
  }
}
    80000dda:	60a6                	ld	ra,72(sp)
    80000ddc:	6406                	ld	s0,64(sp)
    80000dde:	74e2                	ld	s1,56(sp)
    80000de0:	7942                	ld	s2,48(sp)
    80000de2:	79a2                	ld	s3,40(sp)
    80000de4:	7a02                	ld	s4,32(sp)
    80000de6:	6ae2                	ld	s5,24(sp)
    80000de8:	6b42                	ld	s6,16(sp)
    80000dea:	6ba2                	ld	s7,8(sp)
    80000dec:	6161                	addi	sp,sp,80
    80000dee:	8082                	ret
    srcva = va0 + PGSIZE;
    80000df0:	01490bb3          	add	s7,s2,s4
  while (got_null == 0 && max > 0)
    80000df4:	c8a1                	beqz	s1,80000e44 <copyinstr+0x9c>
    va0 = PGROUNDDOWN(srcva);
    80000df6:	016bf933          	and	s2,s7,s6
    pa0 = walkaddr(pagetable, va0);
    80000dfa:	85ca                	mv	a1,s2
    80000dfc:	8556                	mv	a0,s5
    80000dfe:	00000097          	auipc	ra,0x0
    80000e02:	824080e7          	jalr	-2012(ra) # 80000622 <walkaddr>
    if (pa0 == 0)
    80000e06:	c129                	beqz	a0,80000e48 <copyinstr+0xa0>
    n = PGSIZE - (srcva - va0);
    80000e08:	41790633          	sub	a2,s2,s7
    80000e0c:	9652                	add	a2,a2,s4
    if (n > max)
    80000e0e:	00c4f363          	bgeu	s1,a2,80000e14 <copyinstr+0x6c>
    80000e12:	8626                	mv	a2,s1
    char *p = (char *)(pa0 + (srcva - va0));
    80000e14:	412b8bb3          	sub	s7,s7,s2
    80000e18:	9baa                	add	s7,s7,a0
    while (n > 0)
    80000e1a:	da79                	beqz	a2,80000df0 <copyinstr+0x48>
    80000e1c:	87ce                	mv	a5,s3
      if (*p == '\0')
    80000e1e:	413b86b3          	sub	a3,s7,s3
    while (n > 0)
    80000e22:	964e                	add	a2,a2,s3
    80000e24:	85be                	mv	a1,a5
      if (*p == '\0')
    80000e26:	00f68733          	add	a4,a3,a5
    80000e2a:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffb8dc0>
    80000e2e:	df59                	beqz	a4,80000dcc <copyinstr+0x24>
        *dst = *p;
    80000e30:	00e78023          	sb	a4,0(a5)
      dst++;
    80000e34:	0785                	addi	a5,a5,1
    while (n > 0)
    80000e36:	fec797e3          	bne	a5,a2,80000e24 <copyinstr+0x7c>
    80000e3a:	14fd                	addi	s1,s1,-1
    80000e3c:	94ce                	add	s1,s1,s3
      --max;
    80000e3e:	8c8d                	sub	s1,s1,a1
    80000e40:	89be                	mv	s3,a5
    80000e42:	b77d                	j	80000df0 <copyinstr+0x48>
    80000e44:	4781                	li	a5,0
    80000e46:	b771                	j	80000dd2 <copyinstr+0x2a>
      return -1;
    80000e48:	557d                	li	a0,-1
    80000e4a:	bf41                	j	80000dda <copyinstr+0x32>

0000000080000e4c <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000e4c:	715d                	addi	sp,sp,-80
    80000e4e:	e486                	sd	ra,72(sp)
    80000e50:	e0a2                	sd	s0,64(sp)
    80000e52:	fc26                	sd	s1,56(sp)
    80000e54:	f84a                	sd	s2,48(sp)
    80000e56:	f44e                	sd	s3,40(sp)
    80000e58:	f052                	sd	s4,32(sp)
    80000e5a:	ec56                	sd	s5,24(sp)
    80000e5c:	e85a                	sd	s6,16(sp)
    80000e5e:	e45e                	sd	s7,8(sp)
    80000e60:	e062                	sd	s8,0(sp)
    80000e62:	0880                	addi	s0,sp,80
    80000e64:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e66:	00028497          	auipc	s1,0x28
    80000e6a:	63a48493          	addi	s1,s1,1594 # 800294a0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000e6e:	8c26                	mv	s8,s1
    80000e70:	a4fa57b7          	lui	a5,0xa4fa5
    80000e74:	fa578793          	addi	a5,a5,-91 # ffffffffa4fa4fa5 <end+0xffffffff24f5ed65>
    80000e78:	4fa50937          	lui	s2,0x4fa50
    80000e7c:	a5090913          	addi	s2,s2,-1456 # 4fa4fa50 <_entry-0x305b05b0>
    80000e80:	1902                	slli	s2,s2,0x20
    80000e82:	993e                	add	s2,s2,a5
    80000e84:	040009b7          	lui	s3,0x4000
    80000e88:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000e8a:	09b2                	slli	s3,s3,0xc
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000e8c:	4b99                	li	s7,6
    80000e8e:	6b05                	lui	s6,0x1
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e90:	0002ea97          	auipc	s5,0x2e
    80000e94:	010a8a93          	addi	s5,s5,16 # 8002eea0 <tickslock>
    char *pa = kalloc();
    80000e98:	fffff097          	auipc	ra,0xfffff
    80000e9c:	372080e7          	jalr	882(ra) # 8000020a <kalloc>
    80000ea0:	862a                	mv	a2,a0
    if(pa == 0)
    80000ea2:	c131                	beqz	a0,80000ee6 <proc_mapstacks+0x9a>
    uint64 va = KSTACK((int) (p - proc));
    80000ea4:	418485b3          	sub	a1,s1,s8
    80000ea8:	858d                	srai	a1,a1,0x3
    80000eaa:	032585b3          	mul	a1,a1,s2
    80000eae:	2585                	addiw	a1,a1,1
    80000eb0:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000eb4:	875e                	mv	a4,s7
    80000eb6:	86da                	mv	a3,s6
    80000eb8:	40b985b3          	sub	a1,s3,a1
    80000ebc:	8552                	mv	a0,s4
    80000ebe:	00000097          	auipc	ra,0x0
    80000ec2:	84c080e7          	jalr	-1972(ra) # 8000070a <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ec6:	16848493          	addi	s1,s1,360
    80000eca:	fd5497e3          	bne	s1,s5,80000e98 <proc_mapstacks+0x4c>
  }
}
    80000ece:	60a6                	ld	ra,72(sp)
    80000ed0:	6406                	ld	s0,64(sp)
    80000ed2:	74e2                	ld	s1,56(sp)
    80000ed4:	7942                	ld	s2,48(sp)
    80000ed6:	79a2                	ld	s3,40(sp)
    80000ed8:	7a02                	ld	s4,32(sp)
    80000eda:	6ae2                	ld	s5,24(sp)
    80000edc:	6b42                	ld	s6,16(sp)
    80000ede:	6ba2                	ld	s7,8(sp)
    80000ee0:	6c02                	ld	s8,0(sp)
    80000ee2:	6161                	addi	sp,sp,80
    80000ee4:	8082                	ret
      panic("kalloc");
    80000ee6:	00007517          	auipc	a0,0x7
    80000eea:	28250513          	addi	a0,a0,642 # 80008168 <etext+0x168>
    80000eee:	00005097          	auipc	ra,0x5
    80000ef2:	f94080e7          	jalr	-108(ra) # 80005e82 <panic>

0000000080000ef6 <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000ef6:	7139                	addi	sp,sp,-64
    80000ef8:	fc06                	sd	ra,56(sp)
    80000efa:	f822                	sd	s0,48(sp)
    80000efc:	f426                	sd	s1,40(sp)
    80000efe:	f04a                	sd	s2,32(sp)
    80000f00:	ec4e                	sd	s3,24(sp)
    80000f02:	e852                	sd	s4,16(sp)
    80000f04:	e456                	sd	s5,8(sp)
    80000f06:	e05a                	sd	s6,0(sp)
    80000f08:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000f0a:	00007597          	auipc	a1,0x7
    80000f0e:	26658593          	addi	a1,a1,614 # 80008170 <etext+0x170>
    80000f12:	00028517          	auipc	a0,0x28
    80000f16:	15e50513          	addi	a0,a0,350 # 80029070 <pid_lock>
    80000f1a:	00005097          	auipc	ra,0x5
    80000f1e:	454080e7          	jalr	1108(ra) # 8000636e <initlock>
  initlock(&wait_lock, "wait_lock");
    80000f22:	00007597          	auipc	a1,0x7
    80000f26:	25658593          	addi	a1,a1,598 # 80008178 <etext+0x178>
    80000f2a:	00028517          	auipc	a0,0x28
    80000f2e:	15e50513          	addi	a0,a0,350 # 80029088 <wait_lock>
    80000f32:	00005097          	auipc	ra,0x5
    80000f36:	43c080e7          	jalr	1084(ra) # 8000636e <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f3a:	00028497          	auipc	s1,0x28
    80000f3e:	56648493          	addi	s1,s1,1382 # 800294a0 <proc>
      initlock(&p->lock, "proc");
    80000f42:	00007b17          	auipc	s6,0x7
    80000f46:	246b0b13          	addi	s6,s6,582 # 80008188 <etext+0x188>
      p->kstack = KSTACK((int) (p - proc));
    80000f4a:	8aa6                	mv	s5,s1
    80000f4c:	a4fa57b7          	lui	a5,0xa4fa5
    80000f50:	fa578793          	addi	a5,a5,-91 # ffffffffa4fa4fa5 <end+0xffffffff24f5ed65>
    80000f54:	4fa50937          	lui	s2,0x4fa50
    80000f58:	a5090913          	addi	s2,s2,-1456 # 4fa4fa50 <_entry-0x305b05b0>
    80000f5c:	1902                	slli	s2,s2,0x20
    80000f5e:	993e                	add	s2,s2,a5
    80000f60:	040009b7          	lui	s3,0x4000
    80000f64:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000f66:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f68:	0002ea17          	auipc	s4,0x2e
    80000f6c:	f38a0a13          	addi	s4,s4,-200 # 8002eea0 <tickslock>
      initlock(&p->lock, "proc");
    80000f70:	85da                	mv	a1,s6
    80000f72:	8526                	mv	a0,s1
    80000f74:	00005097          	auipc	ra,0x5
    80000f78:	3fa080e7          	jalr	1018(ra) # 8000636e <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000f7c:	415487b3          	sub	a5,s1,s5
    80000f80:	878d                	srai	a5,a5,0x3
    80000f82:	032787b3          	mul	a5,a5,s2
    80000f86:	2785                	addiw	a5,a5,1
    80000f88:	00d7979b          	slliw	a5,a5,0xd
    80000f8c:	40f987b3          	sub	a5,s3,a5
    80000f90:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f92:	16848493          	addi	s1,s1,360
    80000f96:	fd449de3          	bne	s1,s4,80000f70 <procinit+0x7a>
  }
}
    80000f9a:	70e2                	ld	ra,56(sp)
    80000f9c:	7442                	ld	s0,48(sp)
    80000f9e:	74a2                	ld	s1,40(sp)
    80000fa0:	7902                	ld	s2,32(sp)
    80000fa2:	69e2                	ld	s3,24(sp)
    80000fa4:	6a42                	ld	s4,16(sp)
    80000fa6:	6aa2                	ld	s5,8(sp)
    80000fa8:	6b02                	ld	s6,0(sp)
    80000faa:	6121                	addi	sp,sp,64
    80000fac:	8082                	ret

0000000080000fae <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000fae:	1141                	addi	sp,sp,-16
    80000fb0:	e406                	sd	ra,8(sp)
    80000fb2:	e022                	sd	s0,0(sp)
    80000fb4:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000fb6:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000fb8:	2501                	sext.w	a0,a0
    80000fba:	60a2                	ld	ra,8(sp)
    80000fbc:	6402                	ld	s0,0(sp)
    80000fbe:	0141                	addi	sp,sp,16
    80000fc0:	8082                	ret

0000000080000fc2 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000fc2:	1141                	addi	sp,sp,-16
    80000fc4:	e406                	sd	ra,8(sp)
    80000fc6:	e022                	sd	s0,0(sp)
    80000fc8:	0800                	addi	s0,sp,16
    80000fca:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000fcc:	2781                	sext.w	a5,a5
    80000fce:	079e                	slli	a5,a5,0x7
  return c;
}
    80000fd0:	00028517          	auipc	a0,0x28
    80000fd4:	0d050513          	addi	a0,a0,208 # 800290a0 <cpus>
    80000fd8:	953e                	add	a0,a0,a5
    80000fda:	60a2                	ld	ra,8(sp)
    80000fdc:	6402                	ld	s0,0(sp)
    80000fde:	0141                	addi	sp,sp,16
    80000fe0:	8082                	ret

0000000080000fe2 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000fe2:	1101                	addi	sp,sp,-32
    80000fe4:	ec06                	sd	ra,24(sp)
    80000fe6:	e822                	sd	s0,16(sp)
    80000fe8:	e426                	sd	s1,8(sp)
    80000fea:	1000                	addi	s0,sp,32
  push_off();
    80000fec:	00005097          	auipc	ra,0x5
    80000ff0:	3ca080e7          	jalr	970(ra) # 800063b6 <push_off>
    80000ff4:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000ff6:	2781                	sext.w	a5,a5
    80000ff8:	079e                	slli	a5,a5,0x7
    80000ffa:	00028717          	auipc	a4,0x28
    80000ffe:	07670713          	addi	a4,a4,118 # 80029070 <pid_lock>
    80001002:	97ba                	add	a5,a5,a4
    80001004:	7b84                	ld	s1,48(a5)
  pop_off();
    80001006:	00005097          	auipc	ra,0x5
    8000100a:	450080e7          	jalr	1104(ra) # 80006456 <pop_off>
  return p;
}
    8000100e:	8526                	mv	a0,s1
    80001010:	60e2                	ld	ra,24(sp)
    80001012:	6442                	ld	s0,16(sp)
    80001014:	64a2                	ld	s1,8(sp)
    80001016:	6105                	addi	sp,sp,32
    80001018:	8082                	ret

000000008000101a <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    8000101a:	1141                	addi	sp,sp,-16
    8000101c:	e406                	sd	ra,8(sp)
    8000101e:	e022                	sd	s0,0(sp)
    80001020:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80001022:	00000097          	auipc	ra,0x0
    80001026:	fc0080e7          	jalr	-64(ra) # 80000fe2 <myproc>
    8000102a:	00005097          	auipc	ra,0x5
    8000102e:	488080e7          	jalr	1160(ra) # 800064b2 <release>

  if (first) {
    80001032:	00007797          	auipc	a5,0x7
    80001036:	7ee7a783          	lw	a5,2030(a5) # 80008820 <first.1>
    8000103a:	eb89                	bnez	a5,8000104c <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    8000103c:	00001097          	auipc	ra,0x1
    80001040:	cce080e7          	jalr	-818(ra) # 80001d0a <usertrapret>
}
    80001044:	60a2                	ld	ra,8(sp)
    80001046:	6402                	ld	s0,0(sp)
    80001048:	0141                	addi	sp,sp,16
    8000104a:	8082                	ret
    first = 0;
    8000104c:	00007797          	auipc	a5,0x7
    80001050:	7c07aa23          	sw	zero,2004(a5) # 80008820 <first.1>
    fsinit(ROOTDEV);
    80001054:	4505                	li	a0,1
    80001056:	00002097          	auipc	ra,0x2
    8000105a:	a02080e7          	jalr	-1534(ra) # 80002a58 <fsinit>
    8000105e:	bff9                	j	8000103c <forkret+0x22>

0000000080001060 <allocpid>:
allocpid() {
    80001060:	1101                	addi	sp,sp,-32
    80001062:	ec06                	sd	ra,24(sp)
    80001064:	e822                	sd	s0,16(sp)
    80001066:	e426                	sd	s1,8(sp)
    80001068:	e04a                	sd	s2,0(sp)
    8000106a:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    8000106c:	00028917          	auipc	s2,0x28
    80001070:	00490913          	addi	s2,s2,4 # 80029070 <pid_lock>
    80001074:	854a                	mv	a0,s2
    80001076:	00005097          	auipc	ra,0x5
    8000107a:	38c080e7          	jalr	908(ra) # 80006402 <acquire>
  pid = nextpid;
    8000107e:	00007797          	auipc	a5,0x7
    80001082:	7a678793          	addi	a5,a5,1958 # 80008824 <nextpid>
    80001086:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001088:	0014871b          	addiw	a4,s1,1
    8000108c:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    8000108e:	854a                	mv	a0,s2
    80001090:	00005097          	auipc	ra,0x5
    80001094:	422080e7          	jalr	1058(ra) # 800064b2 <release>
}
    80001098:	8526                	mv	a0,s1
    8000109a:	60e2                	ld	ra,24(sp)
    8000109c:	6442                	ld	s0,16(sp)
    8000109e:	64a2                	ld	s1,8(sp)
    800010a0:	6902                	ld	s2,0(sp)
    800010a2:	6105                	addi	sp,sp,32
    800010a4:	8082                	ret

00000000800010a6 <proc_pagetable>:
{
    800010a6:	1101                	addi	sp,sp,-32
    800010a8:	ec06                	sd	ra,24(sp)
    800010aa:	e822                	sd	s0,16(sp)
    800010ac:	e426                	sd	s1,8(sp)
    800010ae:	e04a                	sd	s2,0(sp)
    800010b0:	1000                	addi	s0,sp,32
    800010b2:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    800010b4:	00000097          	auipc	ra,0x0
    800010b8:	84a080e7          	jalr	-1974(ra) # 800008fe <uvmcreate>
    800010bc:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800010be:	c121                	beqz	a0,800010fe <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    800010c0:	4729                	li	a4,10
    800010c2:	00006697          	auipc	a3,0x6
    800010c6:	f3e68693          	addi	a3,a3,-194 # 80007000 <_trampoline>
    800010ca:	6605                	lui	a2,0x1
    800010cc:	040005b7          	lui	a1,0x4000
    800010d0:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800010d2:	05b2                	slli	a1,a1,0xc
    800010d4:	fffff097          	auipc	ra,0xfffff
    800010d8:	590080e7          	jalr	1424(ra) # 80000664 <mappages>
    800010dc:	02054863          	bltz	a0,8000110c <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    800010e0:	4719                	li	a4,6
    800010e2:	05893683          	ld	a3,88(s2)
    800010e6:	6605                	lui	a2,0x1
    800010e8:	020005b7          	lui	a1,0x2000
    800010ec:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    800010ee:	05b6                	slli	a1,a1,0xd
    800010f0:	8526                	mv	a0,s1
    800010f2:	fffff097          	auipc	ra,0xfffff
    800010f6:	572080e7          	jalr	1394(ra) # 80000664 <mappages>
    800010fa:	02054163          	bltz	a0,8000111c <proc_pagetable+0x76>
}
    800010fe:	8526                	mv	a0,s1
    80001100:	60e2                	ld	ra,24(sp)
    80001102:	6442                	ld	s0,16(sp)
    80001104:	64a2                	ld	s1,8(sp)
    80001106:	6902                	ld	s2,0(sp)
    80001108:	6105                	addi	sp,sp,32
    8000110a:	8082                	ret
    uvmfree(pagetable, 0);
    8000110c:	4581                	li	a1,0
    8000110e:	8526                	mv	a0,s1
    80001110:	00000097          	auipc	ra,0x0
    80001114:	a06080e7          	jalr	-1530(ra) # 80000b16 <uvmfree>
    return 0;
    80001118:	4481                	li	s1,0
    8000111a:	b7d5                	j	800010fe <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    8000111c:	4681                	li	a3,0
    8000111e:	4605                	li	a2,1
    80001120:	040005b7          	lui	a1,0x4000
    80001124:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001126:	05b2                	slli	a1,a1,0xc
    80001128:	8526                	mv	a0,s1
    8000112a:	fffff097          	auipc	ra,0xfffff
    8000112e:	700080e7          	jalr	1792(ra) # 8000082a <uvmunmap>
    uvmfree(pagetable, 0);
    80001132:	4581                	li	a1,0
    80001134:	8526                	mv	a0,s1
    80001136:	00000097          	auipc	ra,0x0
    8000113a:	9e0080e7          	jalr	-1568(ra) # 80000b16 <uvmfree>
    return 0;
    8000113e:	4481                	li	s1,0
    80001140:	bf7d                	j	800010fe <proc_pagetable+0x58>

0000000080001142 <proc_freepagetable>:
{
    80001142:	1101                	addi	sp,sp,-32
    80001144:	ec06                	sd	ra,24(sp)
    80001146:	e822                	sd	s0,16(sp)
    80001148:	e426                	sd	s1,8(sp)
    8000114a:	e04a                	sd	s2,0(sp)
    8000114c:	1000                	addi	s0,sp,32
    8000114e:	84aa                	mv	s1,a0
    80001150:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001152:	4681                	li	a3,0
    80001154:	4605                	li	a2,1
    80001156:	040005b7          	lui	a1,0x4000
    8000115a:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000115c:	05b2                	slli	a1,a1,0xc
    8000115e:	fffff097          	auipc	ra,0xfffff
    80001162:	6cc080e7          	jalr	1740(ra) # 8000082a <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001166:	4681                	li	a3,0
    80001168:	4605                	li	a2,1
    8000116a:	020005b7          	lui	a1,0x2000
    8000116e:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001170:	05b6                	slli	a1,a1,0xd
    80001172:	8526                	mv	a0,s1
    80001174:	fffff097          	auipc	ra,0xfffff
    80001178:	6b6080e7          	jalr	1718(ra) # 8000082a <uvmunmap>
  uvmfree(pagetable, sz);
    8000117c:	85ca                	mv	a1,s2
    8000117e:	8526                	mv	a0,s1
    80001180:	00000097          	auipc	ra,0x0
    80001184:	996080e7          	jalr	-1642(ra) # 80000b16 <uvmfree>
}
    80001188:	60e2                	ld	ra,24(sp)
    8000118a:	6442                	ld	s0,16(sp)
    8000118c:	64a2                	ld	s1,8(sp)
    8000118e:	6902                	ld	s2,0(sp)
    80001190:	6105                	addi	sp,sp,32
    80001192:	8082                	ret

0000000080001194 <freeproc>:
{
    80001194:	1101                	addi	sp,sp,-32
    80001196:	ec06                	sd	ra,24(sp)
    80001198:	e822                	sd	s0,16(sp)
    8000119a:	e426                	sd	s1,8(sp)
    8000119c:	1000                	addi	s0,sp,32
    8000119e:	84aa                	mv	s1,a0
  if(p->trapframe)
    800011a0:	6d28                	ld	a0,88(a0)
    800011a2:	c509                	beqz	a0,800011ac <freeproc+0x18>
    kfree((void*)p->trapframe);
    800011a4:	fffff097          	auipc	ra,0xfffff
    800011a8:	f10080e7          	jalr	-240(ra) # 800000b4 <kfree>
  p->trapframe = 0;
    800011ac:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    800011b0:	68a8                	ld	a0,80(s1)
    800011b2:	c511                	beqz	a0,800011be <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    800011b4:	64ac                	ld	a1,72(s1)
    800011b6:	00000097          	auipc	ra,0x0
    800011ba:	f8c080e7          	jalr	-116(ra) # 80001142 <proc_freepagetable>
  p->pagetable = 0;
    800011be:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    800011c2:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    800011c6:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    800011ca:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    800011ce:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    800011d2:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    800011d6:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    800011da:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    800011de:	0004ac23          	sw	zero,24(s1)
}
    800011e2:	60e2                	ld	ra,24(sp)
    800011e4:	6442                	ld	s0,16(sp)
    800011e6:	64a2                	ld	s1,8(sp)
    800011e8:	6105                	addi	sp,sp,32
    800011ea:	8082                	ret

00000000800011ec <allocproc>:
{
    800011ec:	1101                	addi	sp,sp,-32
    800011ee:	ec06                	sd	ra,24(sp)
    800011f0:	e822                	sd	s0,16(sp)
    800011f2:	e426                	sd	s1,8(sp)
    800011f4:	e04a                	sd	s2,0(sp)
    800011f6:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    800011f8:	00028497          	auipc	s1,0x28
    800011fc:	2a848493          	addi	s1,s1,680 # 800294a0 <proc>
    80001200:	0002e917          	auipc	s2,0x2e
    80001204:	ca090913          	addi	s2,s2,-864 # 8002eea0 <tickslock>
    acquire(&p->lock);
    80001208:	8526                	mv	a0,s1
    8000120a:	00005097          	auipc	ra,0x5
    8000120e:	1f8080e7          	jalr	504(ra) # 80006402 <acquire>
    if(p->state == UNUSED) {
    80001212:	4c9c                	lw	a5,24(s1)
    80001214:	cf81                	beqz	a5,8000122c <allocproc+0x40>
      release(&p->lock);
    80001216:	8526                	mv	a0,s1
    80001218:	00005097          	auipc	ra,0x5
    8000121c:	29a080e7          	jalr	666(ra) # 800064b2 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001220:	16848493          	addi	s1,s1,360
    80001224:	ff2492e3          	bne	s1,s2,80001208 <allocproc+0x1c>
  return 0;
    80001228:	4481                	li	s1,0
    8000122a:	a889                	j	8000127c <allocproc+0x90>
  p->pid = allocpid();
    8000122c:	00000097          	auipc	ra,0x0
    80001230:	e34080e7          	jalr	-460(ra) # 80001060 <allocpid>
    80001234:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001236:	4785                	li	a5,1
    80001238:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    8000123a:	fffff097          	auipc	ra,0xfffff
    8000123e:	fd0080e7          	jalr	-48(ra) # 8000020a <kalloc>
    80001242:	892a                	mv	s2,a0
    80001244:	eca8                	sd	a0,88(s1)
    80001246:	c131                	beqz	a0,8000128a <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    80001248:	8526                	mv	a0,s1
    8000124a:	00000097          	auipc	ra,0x0
    8000124e:	e5c080e7          	jalr	-420(ra) # 800010a6 <proc_pagetable>
    80001252:	892a                	mv	s2,a0
    80001254:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001256:	c531                	beqz	a0,800012a2 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    80001258:	07000613          	li	a2,112
    8000125c:	4581                	li	a1,0
    8000125e:	06048513          	addi	a0,s1,96
    80001262:	fffff097          	auipc	ra,0xfffff
    80001266:	022080e7          	jalr	34(ra) # 80000284 <memset>
  p->context.ra = (uint64)forkret;
    8000126a:	00000797          	auipc	a5,0x0
    8000126e:	db078793          	addi	a5,a5,-592 # 8000101a <forkret>
    80001272:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001274:	60bc                	ld	a5,64(s1)
    80001276:	6705                	lui	a4,0x1
    80001278:	97ba                	add	a5,a5,a4
    8000127a:	f4bc                	sd	a5,104(s1)
}
    8000127c:	8526                	mv	a0,s1
    8000127e:	60e2                	ld	ra,24(sp)
    80001280:	6442                	ld	s0,16(sp)
    80001282:	64a2                	ld	s1,8(sp)
    80001284:	6902                	ld	s2,0(sp)
    80001286:	6105                	addi	sp,sp,32
    80001288:	8082                	ret
    freeproc(p);
    8000128a:	8526                	mv	a0,s1
    8000128c:	00000097          	auipc	ra,0x0
    80001290:	f08080e7          	jalr	-248(ra) # 80001194 <freeproc>
    release(&p->lock);
    80001294:	8526                	mv	a0,s1
    80001296:	00005097          	auipc	ra,0x5
    8000129a:	21c080e7          	jalr	540(ra) # 800064b2 <release>
    return 0;
    8000129e:	84ca                	mv	s1,s2
    800012a0:	bff1                	j	8000127c <allocproc+0x90>
    freeproc(p);
    800012a2:	8526                	mv	a0,s1
    800012a4:	00000097          	auipc	ra,0x0
    800012a8:	ef0080e7          	jalr	-272(ra) # 80001194 <freeproc>
    release(&p->lock);
    800012ac:	8526                	mv	a0,s1
    800012ae:	00005097          	auipc	ra,0x5
    800012b2:	204080e7          	jalr	516(ra) # 800064b2 <release>
    return 0;
    800012b6:	84ca                	mv	s1,s2
    800012b8:	b7d1                	j	8000127c <allocproc+0x90>

00000000800012ba <userinit>:
{
    800012ba:	1101                	addi	sp,sp,-32
    800012bc:	ec06                	sd	ra,24(sp)
    800012be:	e822                	sd	s0,16(sp)
    800012c0:	e426                	sd	s1,8(sp)
    800012c2:	1000                	addi	s0,sp,32
  p = allocproc();
    800012c4:	00000097          	auipc	ra,0x0
    800012c8:	f28080e7          	jalr	-216(ra) # 800011ec <allocproc>
    800012cc:	84aa                	mv	s1,a0
  initproc = p;
    800012ce:	00008797          	auipc	a5,0x8
    800012d2:	d4a7b123          	sd	a0,-702(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    800012d6:	03400613          	li	a2,52
    800012da:	00007597          	auipc	a1,0x7
    800012de:	55658593          	addi	a1,a1,1366 # 80008830 <initcode>
    800012e2:	6928                	ld	a0,80(a0)
    800012e4:	fffff097          	auipc	ra,0xfffff
    800012e8:	648080e7          	jalr	1608(ra) # 8000092c <uvminit>
  p->sz = PGSIZE;
    800012ec:	6785                	lui	a5,0x1
    800012ee:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    800012f0:	6cb8                	ld	a4,88(s1)
    800012f2:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    800012f6:	6cb8                	ld	a4,88(s1)
    800012f8:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800012fa:	4641                	li	a2,16
    800012fc:	00007597          	auipc	a1,0x7
    80001300:	e9458593          	addi	a1,a1,-364 # 80008190 <etext+0x190>
    80001304:	15848513          	addi	a0,s1,344
    80001308:	fffff097          	auipc	ra,0xfffff
    8000130c:	0d2080e7          	jalr	210(ra) # 800003da <safestrcpy>
  p->cwd = namei("/");
    80001310:	00007517          	auipc	a0,0x7
    80001314:	e9050513          	addi	a0,a0,-368 # 800081a0 <etext+0x1a0>
    80001318:	00002097          	auipc	ra,0x2
    8000131c:	1a0080e7          	jalr	416(ra) # 800034b8 <namei>
    80001320:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001324:	478d                	li	a5,3
    80001326:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001328:	8526                	mv	a0,s1
    8000132a:	00005097          	auipc	ra,0x5
    8000132e:	188080e7          	jalr	392(ra) # 800064b2 <release>
}
    80001332:	60e2                	ld	ra,24(sp)
    80001334:	6442                	ld	s0,16(sp)
    80001336:	64a2                	ld	s1,8(sp)
    80001338:	6105                	addi	sp,sp,32
    8000133a:	8082                	ret

000000008000133c <growproc>:
{
    8000133c:	1101                	addi	sp,sp,-32
    8000133e:	ec06                	sd	ra,24(sp)
    80001340:	e822                	sd	s0,16(sp)
    80001342:	e426                	sd	s1,8(sp)
    80001344:	e04a                	sd	s2,0(sp)
    80001346:	1000                	addi	s0,sp,32
    80001348:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    8000134a:	00000097          	auipc	ra,0x0
    8000134e:	c98080e7          	jalr	-872(ra) # 80000fe2 <myproc>
    80001352:	892a                	mv	s2,a0
  sz = p->sz;
    80001354:	652c                	ld	a1,72(a0)
    80001356:	0005879b          	sext.w	a5,a1
  if(n > 0){
    8000135a:	00904f63          	bgtz	s1,80001378 <growproc+0x3c>
  } else if(n < 0){
    8000135e:	0204cd63          	bltz	s1,80001398 <growproc+0x5c>
  p->sz = sz;
    80001362:	1782                	slli	a5,a5,0x20
    80001364:	9381                	srli	a5,a5,0x20
    80001366:	04f93423          	sd	a5,72(s2)
  return 0;
    8000136a:	4501                	li	a0,0
}
    8000136c:	60e2                	ld	ra,24(sp)
    8000136e:	6442                	ld	s0,16(sp)
    80001370:	64a2                	ld	s1,8(sp)
    80001372:	6902                	ld	s2,0(sp)
    80001374:	6105                	addi	sp,sp,32
    80001376:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001378:	00f4863b          	addw	a2,s1,a5
    8000137c:	1602                	slli	a2,a2,0x20
    8000137e:	9201                	srli	a2,a2,0x20
    80001380:	1582                	slli	a1,a1,0x20
    80001382:	9181                	srli	a1,a1,0x20
    80001384:	6928                	ld	a0,80(a0)
    80001386:	fffff097          	auipc	ra,0xfffff
    8000138a:	660080e7          	jalr	1632(ra) # 800009e6 <uvmalloc>
    8000138e:	0005079b          	sext.w	a5,a0
    80001392:	fbe1                	bnez	a5,80001362 <growproc+0x26>
      return -1;
    80001394:	557d                	li	a0,-1
    80001396:	bfd9                	j	8000136c <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001398:	00f4863b          	addw	a2,s1,a5
    8000139c:	1602                	slli	a2,a2,0x20
    8000139e:	9201                	srli	a2,a2,0x20
    800013a0:	1582                	slli	a1,a1,0x20
    800013a2:	9181                	srli	a1,a1,0x20
    800013a4:	6928                	ld	a0,80(a0)
    800013a6:	fffff097          	auipc	ra,0xfffff
    800013aa:	5f8080e7          	jalr	1528(ra) # 8000099e <uvmdealloc>
    800013ae:	0005079b          	sext.w	a5,a0
    800013b2:	bf45                	j	80001362 <growproc+0x26>

00000000800013b4 <fork>:
{
    800013b4:	7139                	addi	sp,sp,-64
    800013b6:	fc06                	sd	ra,56(sp)
    800013b8:	f822                	sd	s0,48(sp)
    800013ba:	f04a                	sd	s2,32(sp)
    800013bc:	e456                	sd	s5,8(sp)
    800013be:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    800013c0:	00000097          	auipc	ra,0x0
    800013c4:	c22080e7          	jalr	-990(ra) # 80000fe2 <myproc>
    800013c8:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    800013ca:	00000097          	auipc	ra,0x0
    800013ce:	e22080e7          	jalr	-478(ra) # 800011ec <allocproc>
    800013d2:	12050063          	beqz	a0,800014f2 <fork+0x13e>
    800013d6:	e852                	sd	s4,16(sp)
    800013d8:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800013da:	048ab603          	ld	a2,72(s5)
    800013de:	692c                	ld	a1,80(a0)
    800013e0:	050ab503          	ld	a0,80(s5)
    800013e4:	fffff097          	auipc	ra,0xfffff
    800013e8:	76c080e7          	jalr	1900(ra) # 80000b50 <uvmcopy>
    800013ec:	04054a63          	bltz	a0,80001440 <fork+0x8c>
    800013f0:	f426                	sd	s1,40(sp)
    800013f2:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    800013f4:	048ab783          	ld	a5,72(s5)
    800013f8:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    800013fc:	058ab683          	ld	a3,88(s5)
    80001400:	87b6                	mv	a5,a3
    80001402:	058a3703          	ld	a4,88(s4)
    80001406:	12068693          	addi	a3,a3,288
    8000140a:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    8000140e:	6788                	ld	a0,8(a5)
    80001410:	6b8c                	ld	a1,16(a5)
    80001412:	6f90                	ld	a2,24(a5)
    80001414:	01073023          	sd	a6,0(a4)
    80001418:	e708                	sd	a0,8(a4)
    8000141a:	eb0c                	sd	a1,16(a4)
    8000141c:	ef10                	sd	a2,24(a4)
    8000141e:	02078793          	addi	a5,a5,32
    80001422:	02070713          	addi	a4,a4,32
    80001426:	fed792e3          	bne	a5,a3,8000140a <fork+0x56>
  np->trapframe->a0 = 0;
    8000142a:	058a3783          	ld	a5,88(s4)
    8000142e:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001432:	0d0a8493          	addi	s1,s5,208
    80001436:	0d0a0913          	addi	s2,s4,208
    8000143a:	150a8993          	addi	s3,s5,336
    8000143e:	a015                	j	80001462 <fork+0xae>
    freeproc(np);
    80001440:	8552                	mv	a0,s4
    80001442:	00000097          	auipc	ra,0x0
    80001446:	d52080e7          	jalr	-686(ra) # 80001194 <freeproc>
    release(&np->lock);
    8000144a:	8552                	mv	a0,s4
    8000144c:	00005097          	auipc	ra,0x5
    80001450:	066080e7          	jalr	102(ra) # 800064b2 <release>
    return -1;
    80001454:	597d                	li	s2,-1
    80001456:	6a42                	ld	s4,16(sp)
    80001458:	a071                	j	800014e4 <fork+0x130>
  for(i = 0; i < NOFILE; i++)
    8000145a:	04a1                	addi	s1,s1,8
    8000145c:	0921                	addi	s2,s2,8
    8000145e:	01348b63          	beq	s1,s3,80001474 <fork+0xc0>
    if(p->ofile[i])
    80001462:	6088                	ld	a0,0(s1)
    80001464:	d97d                	beqz	a0,8000145a <fork+0xa6>
      np->ofile[i] = filedup(p->ofile[i]);
    80001466:	00002097          	auipc	ra,0x2
    8000146a:	6d6080e7          	jalr	1750(ra) # 80003b3c <filedup>
    8000146e:	00a93023          	sd	a0,0(s2)
    80001472:	b7e5                	j	8000145a <fork+0xa6>
  np->cwd = idup(p->cwd);
    80001474:	150ab503          	ld	a0,336(s5)
    80001478:	00002097          	auipc	ra,0x2
    8000147c:	816080e7          	jalr	-2026(ra) # 80002c8e <idup>
    80001480:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001484:	4641                	li	a2,16
    80001486:	158a8593          	addi	a1,s5,344
    8000148a:	158a0513          	addi	a0,s4,344
    8000148e:	fffff097          	auipc	ra,0xfffff
    80001492:	f4c080e7          	jalr	-180(ra) # 800003da <safestrcpy>
  pid = np->pid;
    80001496:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    8000149a:	8552                	mv	a0,s4
    8000149c:	00005097          	auipc	ra,0x5
    800014a0:	016080e7          	jalr	22(ra) # 800064b2 <release>
  acquire(&wait_lock);
    800014a4:	00028497          	auipc	s1,0x28
    800014a8:	be448493          	addi	s1,s1,-1052 # 80029088 <wait_lock>
    800014ac:	8526                	mv	a0,s1
    800014ae:	00005097          	auipc	ra,0x5
    800014b2:	f54080e7          	jalr	-172(ra) # 80006402 <acquire>
  np->parent = p;
    800014b6:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    800014ba:	8526                	mv	a0,s1
    800014bc:	00005097          	auipc	ra,0x5
    800014c0:	ff6080e7          	jalr	-10(ra) # 800064b2 <release>
  acquire(&np->lock);
    800014c4:	8552                	mv	a0,s4
    800014c6:	00005097          	auipc	ra,0x5
    800014ca:	f3c080e7          	jalr	-196(ra) # 80006402 <acquire>
  np->state = RUNNABLE;
    800014ce:	478d                	li	a5,3
    800014d0:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    800014d4:	8552                	mv	a0,s4
    800014d6:	00005097          	auipc	ra,0x5
    800014da:	fdc080e7          	jalr	-36(ra) # 800064b2 <release>
  return pid;
    800014de:	74a2                	ld	s1,40(sp)
    800014e0:	69e2                	ld	s3,24(sp)
    800014e2:	6a42                	ld	s4,16(sp)
}
    800014e4:	854a                	mv	a0,s2
    800014e6:	70e2                	ld	ra,56(sp)
    800014e8:	7442                	ld	s0,48(sp)
    800014ea:	7902                	ld	s2,32(sp)
    800014ec:	6aa2                	ld	s5,8(sp)
    800014ee:	6121                	addi	sp,sp,64
    800014f0:	8082                	ret
    return -1;
    800014f2:	597d                	li	s2,-1
    800014f4:	bfc5                	j	800014e4 <fork+0x130>

00000000800014f6 <scheduler>:
{
    800014f6:	7139                	addi	sp,sp,-64
    800014f8:	fc06                	sd	ra,56(sp)
    800014fa:	f822                	sd	s0,48(sp)
    800014fc:	f426                	sd	s1,40(sp)
    800014fe:	f04a                	sd	s2,32(sp)
    80001500:	ec4e                	sd	s3,24(sp)
    80001502:	e852                	sd	s4,16(sp)
    80001504:	e456                	sd	s5,8(sp)
    80001506:	e05a                	sd	s6,0(sp)
    80001508:	0080                	addi	s0,sp,64
    8000150a:	8792                	mv	a5,tp
  int id = r_tp();
    8000150c:	2781                	sext.w	a5,a5
  c->proc = 0;
    8000150e:	00779a93          	slli	s5,a5,0x7
    80001512:	00028717          	auipc	a4,0x28
    80001516:	b5e70713          	addi	a4,a4,-1186 # 80029070 <pid_lock>
    8000151a:	9756                	add	a4,a4,s5
    8000151c:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001520:	00028717          	auipc	a4,0x28
    80001524:	b8870713          	addi	a4,a4,-1144 # 800290a8 <cpus+0x8>
    80001528:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    8000152a:	498d                	li	s3,3
        p->state = RUNNING;
    8000152c:	4b11                	li	s6,4
        c->proc = p;
    8000152e:	079e                	slli	a5,a5,0x7
    80001530:	00028a17          	auipc	s4,0x28
    80001534:	b40a0a13          	addi	s4,s4,-1216 # 80029070 <pid_lock>
    80001538:	9a3e                	add	s4,s4,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000153a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000153e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001542:	10079073          	csrw	sstatus,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001546:	00028497          	auipc	s1,0x28
    8000154a:	f5a48493          	addi	s1,s1,-166 # 800294a0 <proc>
    8000154e:	0002e917          	auipc	s2,0x2e
    80001552:	95290913          	addi	s2,s2,-1710 # 8002eea0 <tickslock>
    80001556:	a811                	j	8000156a <scheduler+0x74>
      release(&p->lock);
    80001558:	8526                	mv	a0,s1
    8000155a:	00005097          	auipc	ra,0x5
    8000155e:	f58080e7          	jalr	-168(ra) # 800064b2 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001562:	16848493          	addi	s1,s1,360
    80001566:	fd248ae3          	beq	s1,s2,8000153a <scheduler+0x44>
      acquire(&p->lock);
    8000156a:	8526                	mv	a0,s1
    8000156c:	00005097          	auipc	ra,0x5
    80001570:	e96080e7          	jalr	-362(ra) # 80006402 <acquire>
      if(p->state == RUNNABLE) {
    80001574:	4c9c                	lw	a5,24(s1)
    80001576:	ff3791e3          	bne	a5,s3,80001558 <scheduler+0x62>
        p->state = RUNNING;
    8000157a:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    8000157e:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001582:	06048593          	addi	a1,s1,96
    80001586:	8556                	mv	a0,s5
    80001588:	00000097          	auipc	ra,0x0
    8000158c:	61a080e7          	jalr	1562(ra) # 80001ba2 <swtch>
        c->proc = 0;
    80001590:	020a3823          	sd	zero,48(s4)
    80001594:	b7d1                	j	80001558 <scheduler+0x62>

0000000080001596 <sched>:
{
    80001596:	7179                	addi	sp,sp,-48
    80001598:	f406                	sd	ra,40(sp)
    8000159a:	f022                	sd	s0,32(sp)
    8000159c:	ec26                	sd	s1,24(sp)
    8000159e:	e84a                	sd	s2,16(sp)
    800015a0:	e44e                	sd	s3,8(sp)
    800015a2:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800015a4:	00000097          	auipc	ra,0x0
    800015a8:	a3e080e7          	jalr	-1474(ra) # 80000fe2 <myproc>
    800015ac:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800015ae:	00005097          	auipc	ra,0x5
    800015b2:	dda080e7          	jalr	-550(ra) # 80006388 <holding>
    800015b6:	c93d                	beqz	a0,8000162c <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    800015b8:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800015ba:	2781                	sext.w	a5,a5
    800015bc:	079e                	slli	a5,a5,0x7
    800015be:	00028717          	auipc	a4,0x28
    800015c2:	ab270713          	addi	a4,a4,-1358 # 80029070 <pid_lock>
    800015c6:	97ba                	add	a5,a5,a4
    800015c8:	0a87a703          	lw	a4,168(a5)
    800015cc:	4785                	li	a5,1
    800015ce:	06f71763          	bne	a4,a5,8000163c <sched+0xa6>
  if(p->state == RUNNING)
    800015d2:	4c98                	lw	a4,24(s1)
    800015d4:	4791                	li	a5,4
    800015d6:	06f70b63          	beq	a4,a5,8000164c <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800015da:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800015de:	8b89                	andi	a5,a5,2
  if(intr_get())
    800015e0:	efb5                	bnez	a5,8000165c <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    800015e2:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800015e4:	00028917          	auipc	s2,0x28
    800015e8:	a8c90913          	addi	s2,s2,-1396 # 80029070 <pid_lock>
    800015ec:	2781                	sext.w	a5,a5
    800015ee:	079e                	slli	a5,a5,0x7
    800015f0:	97ca                	add	a5,a5,s2
    800015f2:	0ac7a983          	lw	s3,172(a5)
    800015f6:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800015f8:	2781                	sext.w	a5,a5
    800015fa:	079e                	slli	a5,a5,0x7
    800015fc:	00028597          	auipc	a1,0x28
    80001600:	aac58593          	addi	a1,a1,-1364 # 800290a8 <cpus+0x8>
    80001604:	95be                	add	a1,a1,a5
    80001606:	06048513          	addi	a0,s1,96
    8000160a:	00000097          	auipc	ra,0x0
    8000160e:	598080e7          	jalr	1432(ra) # 80001ba2 <swtch>
    80001612:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001614:	2781                	sext.w	a5,a5
    80001616:	079e                	slli	a5,a5,0x7
    80001618:	993e                	add	s2,s2,a5
    8000161a:	0b392623          	sw	s3,172(s2)
}
    8000161e:	70a2                	ld	ra,40(sp)
    80001620:	7402                	ld	s0,32(sp)
    80001622:	64e2                	ld	s1,24(sp)
    80001624:	6942                	ld	s2,16(sp)
    80001626:	69a2                	ld	s3,8(sp)
    80001628:	6145                	addi	sp,sp,48
    8000162a:	8082                	ret
    panic("sched p->lock");
    8000162c:	00007517          	auipc	a0,0x7
    80001630:	b7c50513          	addi	a0,a0,-1156 # 800081a8 <etext+0x1a8>
    80001634:	00005097          	auipc	ra,0x5
    80001638:	84e080e7          	jalr	-1970(ra) # 80005e82 <panic>
    panic("sched locks");
    8000163c:	00007517          	auipc	a0,0x7
    80001640:	b7c50513          	addi	a0,a0,-1156 # 800081b8 <etext+0x1b8>
    80001644:	00005097          	auipc	ra,0x5
    80001648:	83e080e7          	jalr	-1986(ra) # 80005e82 <panic>
    panic("sched running");
    8000164c:	00007517          	auipc	a0,0x7
    80001650:	b7c50513          	addi	a0,a0,-1156 # 800081c8 <etext+0x1c8>
    80001654:	00005097          	auipc	ra,0x5
    80001658:	82e080e7          	jalr	-2002(ra) # 80005e82 <panic>
    panic("sched interruptible");
    8000165c:	00007517          	auipc	a0,0x7
    80001660:	b7c50513          	addi	a0,a0,-1156 # 800081d8 <etext+0x1d8>
    80001664:	00005097          	auipc	ra,0x5
    80001668:	81e080e7          	jalr	-2018(ra) # 80005e82 <panic>

000000008000166c <yield>:
{
    8000166c:	1101                	addi	sp,sp,-32
    8000166e:	ec06                	sd	ra,24(sp)
    80001670:	e822                	sd	s0,16(sp)
    80001672:	e426                	sd	s1,8(sp)
    80001674:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001676:	00000097          	auipc	ra,0x0
    8000167a:	96c080e7          	jalr	-1684(ra) # 80000fe2 <myproc>
    8000167e:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001680:	00005097          	auipc	ra,0x5
    80001684:	d82080e7          	jalr	-638(ra) # 80006402 <acquire>
  p->state = RUNNABLE;
    80001688:	478d                	li	a5,3
    8000168a:	cc9c                	sw	a5,24(s1)
  sched();
    8000168c:	00000097          	auipc	ra,0x0
    80001690:	f0a080e7          	jalr	-246(ra) # 80001596 <sched>
  release(&p->lock);
    80001694:	8526                	mv	a0,s1
    80001696:	00005097          	auipc	ra,0x5
    8000169a:	e1c080e7          	jalr	-484(ra) # 800064b2 <release>
}
    8000169e:	60e2                	ld	ra,24(sp)
    800016a0:	6442                	ld	s0,16(sp)
    800016a2:	64a2                	ld	s1,8(sp)
    800016a4:	6105                	addi	sp,sp,32
    800016a6:	8082                	ret

00000000800016a8 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    800016a8:	7179                	addi	sp,sp,-48
    800016aa:	f406                	sd	ra,40(sp)
    800016ac:	f022                	sd	s0,32(sp)
    800016ae:	ec26                	sd	s1,24(sp)
    800016b0:	e84a                	sd	s2,16(sp)
    800016b2:	e44e                	sd	s3,8(sp)
    800016b4:	1800                	addi	s0,sp,48
    800016b6:	89aa                	mv	s3,a0
    800016b8:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800016ba:	00000097          	auipc	ra,0x0
    800016be:	928080e7          	jalr	-1752(ra) # 80000fe2 <myproc>
    800016c2:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800016c4:	00005097          	auipc	ra,0x5
    800016c8:	d3e080e7          	jalr	-706(ra) # 80006402 <acquire>
  release(lk);
    800016cc:	854a                	mv	a0,s2
    800016ce:	00005097          	auipc	ra,0x5
    800016d2:	de4080e7          	jalr	-540(ra) # 800064b2 <release>

  // Go to sleep.
  p->chan = chan;
    800016d6:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    800016da:	4789                	li	a5,2
    800016dc:	cc9c                	sw	a5,24(s1)

  sched();
    800016de:	00000097          	auipc	ra,0x0
    800016e2:	eb8080e7          	jalr	-328(ra) # 80001596 <sched>

  // Tidy up.
  p->chan = 0;
    800016e6:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800016ea:	8526                	mv	a0,s1
    800016ec:	00005097          	auipc	ra,0x5
    800016f0:	dc6080e7          	jalr	-570(ra) # 800064b2 <release>
  acquire(lk);
    800016f4:	854a                	mv	a0,s2
    800016f6:	00005097          	auipc	ra,0x5
    800016fa:	d0c080e7          	jalr	-756(ra) # 80006402 <acquire>
}
    800016fe:	70a2                	ld	ra,40(sp)
    80001700:	7402                	ld	s0,32(sp)
    80001702:	64e2                	ld	s1,24(sp)
    80001704:	6942                	ld	s2,16(sp)
    80001706:	69a2                	ld	s3,8(sp)
    80001708:	6145                	addi	sp,sp,48
    8000170a:	8082                	ret

000000008000170c <wait>:
{
    8000170c:	715d                	addi	sp,sp,-80
    8000170e:	e486                	sd	ra,72(sp)
    80001710:	e0a2                	sd	s0,64(sp)
    80001712:	fc26                	sd	s1,56(sp)
    80001714:	f84a                	sd	s2,48(sp)
    80001716:	f44e                	sd	s3,40(sp)
    80001718:	f052                	sd	s4,32(sp)
    8000171a:	ec56                	sd	s5,24(sp)
    8000171c:	e85a                	sd	s6,16(sp)
    8000171e:	e45e                	sd	s7,8(sp)
    80001720:	0880                	addi	s0,sp,80
    80001722:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80001724:	00000097          	auipc	ra,0x0
    80001728:	8be080e7          	jalr	-1858(ra) # 80000fe2 <myproc>
    8000172c:	892a                	mv	s2,a0
  acquire(&wait_lock);
    8000172e:	00028517          	auipc	a0,0x28
    80001732:	95a50513          	addi	a0,a0,-1702 # 80029088 <wait_lock>
    80001736:	00005097          	auipc	ra,0x5
    8000173a:	ccc080e7          	jalr	-820(ra) # 80006402 <acquire>
        if(np->state == ZOMBIE){
    8000173e:	4a15                	li	s4,5
        havekids = 1;
    80001740:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    80001742:	0002d997          	auipc	s3,0x2d
    80001746:	75e98993          	addi	s3,s3,1886 # 8002eea0 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000174a:	00028b97          	auipc	s7,0x28
    8000174e:	93eb8b93          	addi	s7,s7,-1730 # 80029088 <wait_lock>
    80001752:	a875                	j	8000180e <wait+0x102>
          pid = np->pid;
    80001754:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    80001758:	000b0e63          	beqz	s6,80001774 <wait+0x68>
    8000175c:	4691                	li	a3,4
    8000175e:	02c48613          	addi	a2,s1,44
    80001762:	85da                	mv	a1,s6
    80001764:	05093503          	ld	a0,80(s2)
    80001768:	fffff097          	auipc	ra,0xfffff
    8000176c:	512080e7          	jalr	1298(ra) # 80000c7a <copyout>
    80001770:	04054063          	bltz	a0,800017b0 <wait+0xa4>
          freeproc(np);
    80001774:	8526                	mv	a0,s1
    80001776:	00000097          	auipc	ra,0x0
    8000177a:	a1e080e7          	jalr	-1506(ra) # 80001194 <freeproc>
          release(&np->lock);
    8000177e:	8526                	mv	a0,s1
    80001780:	00005097          	auipc	ra,0x5
    80001784:	d32080e7          	jalr	-718(ra) # 800064b2 <release>
          release(&wait_lock);
    80001788:	00028517          	auipc	a0,0x28
    8000178c:	90050513          	addi	a0,a0,-1792 # 80029088 <wait_lock>
    80001790:	00005097          	auipc	ra,0x5
    80001794:	d22080e7          	jalr	-734(ra) # 800064b2 <release>
}
    80001798:	854e                	mv	a0,s3
    8000179a:	60a6                	ld	ra,72(sp)
    8000179c:	6406                	ld	s0,64(sp)
    8000179e:	74e2                	ld	s1,56(sp)
    800017a0:	7942                	ld	s2,48(sp)
    800017a2:	79a2                	ld	s3,40(sp)
    800017a4:	7a02                	ld	s4,32(sp)
    800017a6:	6ae2                	ld	s5,24(sp)
    800017a8:	6b42                	ld	s6,16(sp)
    800017aa:	6ba2                	ld	s7,8(sp)
    800017ac:	6161                	addi	sp,sp,80
    800017ae:	8082                	ret
            release(&np->lock);
    800017b0:	8526                	mv	a0,s1
    800017b2:	00005097          	auipc	ra,0x5
    800017b6:	d00080e7          	jalr	-768(ra) # 800064b2 <release>
            release(&wait_lock);
    800017ba:	00028517          	auipc	a0,0x28
    800017be:	8ce50513          	addi	a0,a0,-1842 # 80029088 <wait_lock>
    800017c2:	00005097          	auipc	ra,0x5
    800017c6:	cf0080e7          	jalr	-784(ra) # 800064b2 <release>
            return -1;
    800017ca:	59fd                	li	s3,-1
    800017cc:	b7f1                	j	80001798 <wait+0x8c>
    for(np = proc; np < &proc[NPROC]; np++){
    800017ce:	16848493          	addi	s1,s1,360
    800017d2:	03348463          	beq	s1,s3,800017fa <wait+0xee>
      if(np->parent == p){
    800017d6:	7c9c                	ld	a5,56(s1)
    800017d8:	ff279be3          	bne	a5,s2,800017ce <wait+0xc2>
        acquire(&np->lock);
    800017dc:	8526                	mv	a0,s1
    800017de:	00005097          	auipc	ra,0x5
    800017e2:	c24080e7          	jalr	-988(ra) # 80006402 <acquire>
        if(np->state == ZOMBIE){
    800017e6:	4c9c                	lw	a5,24(s1)
    800017e8:	f74786e3          	beq	a5,s4,80001754 <wait+0x48>
        release(&np->lock);
    800017ec:	8526                	mv	a0,s1
    800017ee:	00005097          	auipc	ra,0x5
    800017f2:	cc4080e7          	jalr	-828(ra) # 800064b2 <release>
        havekids = 1;
    800017f6:	8756                	mv	a4,s5
    800017f8:	bfd9                	j	800017ce <wait+0xc2>
    if(!havekids || p->killed){
    800017fa:	c305                	beqz	a4,8000181a <wait+0x10e>
    800017fc:	02892783          	lw	a5,40(s2)
    80001800:	ef89                	bnez	a5,8000181a <wait+0x10e>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001802:	85de                	mv	a1,s7
    80001804:	854a                	mv	a0,s2
    80001806:	00000097          	auipc	ra,0x0
    8000180a:	ea2080e7          	jalr	-350(ra) # 800016a8 <sleep>
    havekids = 0;
    8000180e:	4701                	li	a4,0
    for(np = proc; np < &proc[NPROC]; np++){
    80001810:	00028497          	auipc	s1,0x28
    80001814:	c9048493          	addi	s1,s1,-880 # 800294a0 <proc>
    80001818:	bf7d                	j	800017d6 <wait+0xca>
      release(&wait_lock);
    8000181a:	00028517          	auipc	a0,0x28
    8000181e:	86e50513          	addi	a0,a0,-1938 # 80029088 <wait_lock>
    80001822:	00005097          	auipc	ra,0x5
    80001826:	c90080e7          	jalr	-880(ra) # 800064b2 <release>
      return -1;
    8000182a:	59fd                	li	s3,-1
    8000182c:	b7b5                	j	80001798 <wait+0x8c>

000000008000182e <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    8000182e:	7139                	addi	sp,sp,-64
    80001830:	fc06                	sd	ra,56(sp)
    80001832:	f822                	sd	s0,48(sp)
    80001834:	f426                	sd	s1,40(sp)
    80001836:	f04a                	sd	s2,32(sp)
    80001838:	ec4e                	sd	s3,24(sp)
    8000183a:	e852                	sd	s4,16(sp)
    8000183c:	e456                	sd	s5,8(sp)
    8000183e:	0080                	addi	s0,sp,64
    80001840:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001842:	00028497          	auipc	s1,0x28
    80001846:	c5e48493          	addi	s1,s1,-930 # 800294a0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    8000184a:	4989                	li	s3,2
        p->state = RUNNABLE;
    8000184c:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    8000184e:	0002d917          	auipc	s2,0x2d
    80001852:	65290913          	addi	s2,s2,1618 # 8002eea0 <tickslock>
    80001856:	a811                	j	8000186a <wakeup+0x3c>
      }
      release(&p->lock);
    80001858:	8526                	mv	a0,s1
    8000185a:	00005097          	auipc	ra,0x5
    8000185e:	c58080e7          	jalr	-936(ra) # 800064b2 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001862:	16848493          	addi	s1,s1,360
    80001866:	03248663          	beq	s1,s2,80001892 <wakeup+0x64>
    if(p != myproc()){
    8000186a:	fffff097          	auipc	ra,0xfffff
    8000186e:	778080e7          	jalr	1912(ra) # 80000fe2 <myproc>
    80001872:	fea488e3          	beq	s1,a0,80001862 <wakeup+0x34>
      acquire(&p->lock);
    80001876:	8526                	mv	a0,s1
    80001878:	00005097          	auipc	ra,0x5
    8000187c:	b8a080e7          	jalr	-1142(ra) # 80006402 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001880:	4c9c                	lw	a5,24(s1)
    80001882:	fd379be3          	bne	a5,s3,80001858 <wakeup+0x2a>
    80001886:	709c                	ld	a5,32(s1)
    80001888:	fd4798e3          	bne	a5,s4,80001858 <wakeup+0x2a>
        p->state = RUNNABLE;
    8000188c:	0154ac23          	sw	s5,24(s1)
    80001890:	b7e1                	j	80001858 <wakeup+0x2a>
    }
  }
}
    80001892:	70e2                	ld	ra,56(sp)
    80001894:	7442                	ld	s0,48(sp)
    80001896:	74a2                	ld	s1,40(sp)
    80001898:	7902                	ld	s2,32(sp)
    8000189a:	69e2                	ld	s3,24(sp)
    8000189c:	6a42                	ld	s4,16(sp)
    8000189e:	6aa2                	ld	s5,8(sp)
    800018a0:	6121                	addi	sp,sp,64
    800018a2:	8082                	ret

00000000800018a4 <reparent>:
{
    800018a4:	7179                	addi	sp,sp,-48
    800018a6:	f406                	sd	ra,40(sp)
    800018a8:	f022                	sd	s0,32(sp)
    800018aa:	ec26                	sd	s1,24(sp)
    800018ac:	e84a                	sd	s2,16(sp)
    800018ae:	e44e                	sd	s3,8(sp)
    800018b0:	e052                	sd	s4,0(sp)
    800018b2:	1800                	addi	s0,sp,48
    800018b4:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800018b6:	00028497          	auipc	s1,0x28
    800018ba:	bea48493          	addi	s1,s1,-1046 # 800294a0 <proc>
      pp->parent = initproc;
    800018be:	00007a17          	auipc	s4,0x7
    800018c2:	752a0a13          	addi	s4,s4,1874 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800018c6:	0002d997          	auipc	s3,0x2d
    800018ca:	5da98993          	addi	s3,s3,1498 # 8002eea0 <tickslock>
    800018ce:	a029                	j	800018d8 <reparent+0x34>
    800018d0:	16848493          	addi	s1,s1,360
    800018d4:	01348d63          	beq	s1,s3,800018ee <reparent+0x4a>
    if(pp->parent == p){
    800018d8:	7c9c                	ld	a5,56(s1)
    800018da:	ff279be3          	bne	a5,s2,800018d0 <reparent+0x2c>
      pp->parent = initproc;
    800018de:	000a3503          	ld	a0,0(s4)
    800018e2:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    800018e4:	00000097          	auipc	ra,0x0
    800018e8:	f4a080e7          	jalr	-182(ra) # 8000182e <wakeup>
    800018ec:	b7d5                	j	800018d0 <reparent+0x2c>
}
    800018ee:	70a2                	ld	ra,40(sp)
    800018f0:	7402                	ld	s0,32(sp)
    800018f2:	64e2                	ld	s1,24(sp)
    800018f4:	6942                	ld	s2,16(sp)
    800018f6:	69a2                	ld	s3,8(sp)
    800018f8:	6a02                	ld	s4,0(sp)
    800018fa:	6145                	addi	sp,sp,48
    800018fc:	8082                	ret

00000000800018fe <exit>:
{
    800018fe:	7179                	addi	sp,sp,-48
    80001900:	f406                	sd	ra,40(sp)
    80001902:	f022                	sd	s0,32(sp)
    80001904:	ec26                	sd	s1,24(sp)
    80001906:	e84a                	sd	s2,16(sp)
    80001908:	e44e                	sd	s3,8(sp)
    8000190a:	e052                	sd	s4,0(sp)
    8000190c:	1800                	addi	s0,sp,48
    8000190e:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001910:	fffff097          	auipc	ra,0xfffff
    80001914:	6d2080e7          	jalr	1746(ra) # 80000fe2 <myproc>
    80001918:	89aa                	mv	s3,a0
  if(p == initproc)
    8000191a:	00007797          	auipc	a5,0x7
    8000191e:	6f67b783          	ld	a5,1782(a5) # 80009010 <initproc>
    80001922:	0d050493          	addi	s1,a0,208
    80001926:	15050913          	addi	s2,a0,336
    8000192a:	00a79d63          	bne	a5,a0,80001944 <exit+0x46>
    panic("init exiting");
    8000192e:	00007517          	auipc	a0,0x7
    80001932:	8c250513          	addi	a0,a0,-1854 # 800081f0 <etext+0x1f0>
    80001936:	00004097          	auipc	ra,0x4
    8000193a:	54c080e7          	jalr	1356(ra) # 80005e82 <panic>
  for(int fd = 0; fd < NOFILE; fd++){
    8000193e:	04a1                	addi	s1,s1,8
    80001940:	01248b63          	beq	s1,s2,80001956 <exit+0x58>
    if(p->ofile[fd]){
    80001944:	6088                	ld	a0,0(s1)
    80001946:	dd65                	beqz	a0,8000193e <exit+0x40>
      fileclose(f);
    80001948:	00002097          	auipc	ra,0x2
    8000194c:	246080e7          	jalr	582(ra) # 80003b8e <fileclose>
      p->ofile[fd] = 0;
    80001950:	0004b023          	sd	zero,0(s1)
    80001954:	b7ed                	j	8000193e <exit+0x40>
  begin_op();
    80001956:	00002097          	auipc	ra,0x2
    8000195a:	d68080e7          	jalr	-664(ra) # 800036be <begin_op>
  iput(p->cwd);
    8000195e:	1509b503          	ld	a0,336(s3)
    80001962:	00001097          	auipc	ra,0x1
    80001966:	528080e7          	jalr	1320(ra) # 80002e8a <iput>
  end_op();
    8000196a:	00002097          	auipc	ra,0x2
    8000196e:	dce080e7          	jalr	-562(ra) # 80003738 <end_op>
  p->cwd = 0;
    80001972:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001976:	00027497          	auipc	s1,0x27
    8000197a:	71248493          	addi	s1,s1,1810 # 80029088 <wait_lock>
    8000197e:	8526                	mv	a0,s1
    80001980:	00005097          	auipc	ra,0x5
    80001984:	a82080e7          	jalr	-1406(ra) # 80006402 <acquire>
  reparent(p);
    80001988:	854e                	mv	a0,s3
    8000198a:	00000097          	auipc	ra,0x0
    8000198e:	f1a080e7          	jalr	-230(ra) # 800018a4 <reparent>
  wakeup(p->parent);
    80001992:	0389b503          	ld	a0,56(s3)
    80001996:	00000097          	auipc	ra,0x0
    8000199a:	e98080e7          	jalr	-360(ra) # 8000182e <wakeup>
  acquire(&p->lock);
    8000199e:	854e                	mv	a0,s3
    800019a0:	00005097          	auipc	ra,0x5
    800019a4:	a62080e7          	jalr	-1438(ra) # 80006402 <acquire>
  p->xstate = status;
    800019a8:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800019ac:	4795                	li	a5,5
    800019ae:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800019b2:	8526                	mv	a0,s1
    800019b4:	00005097          	auipc	ra,0x5
    800019b8:	afe080e7          	jalr	-1282(ra) # 800064b2 <release>
  sched();
    800019bc:	00000097          	auipc	ra,0x0
    800019c0:	bda080e7          	jalr	-1062(ra) # 80001596 <sched>
  panic("zombie exit");
    800019c4:	00007517          	auipc	a0,0x7
    800019c8:	83c50513          	addi	a0,a0,-1988 # 80008200 <etext+0x200>
    800019cc:	00004097          	auipc	ra,0x4
    800019d0:	4b6080e7          	jalr	1206(ra) # 80005e82 <panic>

00000000800019d4 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800019d4:	7179                	addi	sp,sp,-48
    800019d6:	f406                	sd	ra,40(sp)
    800019d8:	f022                	sd	s0,32(sp)
    800019da:	ec26                	sd	s1,24(sp)
    800019dc:	e84a                	sd	s2,16(sp)
    800019de:	e44e                	sd	s3,8(sp)
    800019e0:	1800                	addi	s0,sp,48
    800019e2:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800019e4:	00028497          	auipc	s1,0x28
    800019e8:	abc48493          	addi	s1,s1,-1348 # 800294a0 <proc>
    800019ec:	0002d997          	auipc	s3,0x2d
    800019f0:	4b498993          	addi	s3,s3,1204 # 8002eea0 <tickslock>
    acquire(&p->lock);
    800019f4:	8526                	mv	a0,s1
    800019f6:	00005097          	auipc	ra,0x5
    800019fa:	a0c080e7          	jalr	-1524(ra) # 80006402 <acquire>
    if(p->pid == pid){
    800019fe:	589c                	lw	a5,48(s1)
    80001a00:	01278d63          	beq	a5,s2,80001a1a <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001a04:	8526                	mv	a0,s1
    80001a06:	00005097          	auipc	ra,0x5
    80001a0a:	aac080e7          	jalr	-1364(ra) # 800064b2 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a0e:	16848493          	addi	s1,s1,360
    80001a12:	ff3491e3          	bne	s1,s3,800019f4 <kill+0x20>
  }
  return -1;
    80001a16:	557d                	li	a0,-1
    80001a18:	a829                	j	80001a32 <kill+0x5e>
      p->killed = 1;
    80001a1a:	4785                	li	a5,1
    80001a1c:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001a1e:	4c98                	lw	a4,24(s1)
    80001a20:	4789                	li	a5,2
    80001a22:	00f70f63          	beq	a4,a5,80001a40 <kill+0x6c>
      release(&p->lock);
    80001a26:	8526                	mv	a0,s1
    80001a28:	00005097          	auipc	ra,0x5
    80001a2c:	a8a080e7          	jalr	-1398(ra) # 800064b2 <release>
      return 0;
    80001a30:	4501                	li	a0,0
}
    80001a32:	70a2                	ld	ra,40(sp)
    80001a34:	7402                	ld	s0,32(sp)
    80001a36:	64e2                	ld	s1,24(sp)
    80001a38:	6942                	ld	s2,16(sp)
    80001a3a:	69a2                	ld	s3,8(sp)
    80001a3c:	6145                	addi	sp,sp,48
    80001a3e:	8082                	ret
        p->state = RUNNABLE;
    80001a40:	478d                	li	a5,3
    80001a42:	cc9c                	sw	a5,24(s1)
    80001a44:	b7cd                	j	80001a26 <kill+0x52>

0000000080001a46 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001a46:	7179                	addi	sp,sp,-48
    80001a48:	f406                	sd	ra,40(sp)
    80001a4a:	f022                	sd	s0,32(sp)
    80001a4c:	ec26                	sd	s1,24(sp)
    80001a4e:	e84a                	sd	s2,16(sp)
    80001a50:	e44e                	sd	s3,8(sp)
    80001a52:	e052                	sd	s4,0(sp)
    80001a54:	1800                	addi	s0,sp,48
    80001a56:	84aa                	mv	s1,a0
    80001a58:	892e                	mv	s2,a1
    80001a5a:	89b2                	mv	s3,a2
    80001a5c:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001a5e:	fffff097          	auipc	ra,0xfffff
    80001a62:	584080e7          	jalr	1412(ra) # 80000fe2 <myproc>
  if(user_dst){
    80001a66:	c08d                	beqz	s1,80001a88 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001a68:	86d2                	mv	a3,s4
    80001a6a:	864e                	mv	a2,s3
    80001a6c:	85ca                	mv	a1,s2
    80001a6e:	6928                	ld	a0,80(a0)
    80001a70:	fffff097          	auipc	ra,0xfffff
    80001a74:	20a080e7          	jalr	522(ra) # 80000c7a <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001a78:	70a2                	ld	ra,40(sp)
    80001a7a:	7402                	ld	s0,32(sp)
    80001a7c:	64e2                	ld	s1,24(sp)
    80001a7e:	6942                	ld	s2,16(sp)
    80001a80:	69a2                	ld	s3,8(sp)
    80001a82:	6a02                	ld	s4,0(sp)
    80001a84:	6145                	addi	sp,sp,48
    80001a86:	8082                	ret
    memmove((char *)dst, src, len);
    80001a88:	000a061b          	sext.w	a2,s4
    80001a8c:	85ce                	mv	a1,s3
    80001a8e:	854a                	mv	a0,s2
    80001a90:	fffff097          	auipc	ra,0xfffff
    80001a94:	858080e7          	jalr	-1960(ra) # 800002e8 <memmove>
    return 0;
    80001a98:	8526                	mv	a0,s1
    80001a9a:	bff9                	j	80001a78 <either_copyout+0x32>

0000000080001a9c <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001a9c:	7179                	addi	sp,sp,-48
    80001a9e:	f406                	sd	ra,40(sp)
    80001aa0:	f022                	sd	s0,32(sp)
    80001aa2:	ec26                	sd	s1,24(sp)
    80001aa4:	e84a                	sd	s2,16(sp)
    80001aa6:	e44e                	sd	s3,8(sp)
    80001aa8:	e052                	sd	s4,0(sp)
    80001aaa:	1800                	addi	s0,sp,48
    80001aac:	892a                	mv	s2,a0
    80001aae:	84ae                	mv	s1,a1
    80001ab0:	89b2                	mv	s3,a2
    80001ab2:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001ab4:	fffff097          	auipc	ra,0xfffff
    80001ab8:	52e080e7          	jalr	1326(ra) # 80000fe2 <myproc>
  if(user_src){
    80001abc:	c08d                	beqz	s1,80001ade <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001abe:	86d2                	mv	a3,s4
    80001ac0:	864e                	mv	a2,s3
    80001ac2:	85ca                	mv	a1,s2
    80001ac4:	6928                	ld	a0,80(a0)
    80001ac6:	fffff097          	auipc	ra,0xfffff
    80001aca:	254080e7          	jalr	596(ra) # 80000d1a <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001ace:	70a2                	ld	ra,40(sp)
    80001ad0:	7402                	ld	s0,32(sp)
    80001ad2:	64e2                	ld	s1,24(sp)
    80001ad4:	6942                	ld	s2,16(sp)
    80001ad6:	69a2                	ld	s3,8(sp)
    80001ad8:	6a02                	ld	s4,0(sp)
    80001ada:	6145                	addi	sp,sp,48
    80001adc:	8082                	ret
    memmove(dst, (char*)src, len);
    80001ade:	000a061b          	sext.w	a2,s4
    80001ae2:	85ce                	mv	a1,s3
    80001ae4:	854a                	mv	a0,s2
    80001ae6:	fffff097          	auipc	ra,0xfffff
    80001aea:	802080e7          	jalr	-2046(ra) # 800002e8 <memmove>
    return 0;
    80001aee:	8526                	mv	a0,s1
    80001af0:	bff9                	j	80001ace <either_copyin+0x32>

0000000080001af2 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001af2:	715d                	addi	sp,sp,-80
    80001af4:	e486                	sd	ra,72(sp)
    80001af6:	e0a2                	sd	s0,64(sp)
    80001af8:	fc26                	sd	s1,56(sp)
    80001afa:	f84a                	sd	s2,48(sp)
    80001afc:	f44e                	sd	s3,40(sp)
    80001afe:	f052                	sd	s4,32(sp)
    80001b00:	ec56                	sd	s5,24(sp)
    80001b02:	e85a                	sd	s6,16(sp)
    80001b04:	e45e                	sd	s7,8(sp)
    80001b06:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001b08:	00006517          	auipc	a0,0x6
    80001b0c:	52050513          	addi	a0,a0,1312 # 80008028 <etext+0x28>
    80001b10:	00004097          	auipc	ra,0x4
    80001b14:	3bc080e7          	jalr	956(ra) # 80005ecc <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001b18:	00028497          	auipc	s1,0x28
    80001b1c:	ae048493          	addi	s1,s1,-1312 # 800295f8 <proc+0x158>
    80001b20:	0002d917          	auipc	s2,0x2d
    80001b24:	4d890913          	addi	s2,s2,1240 # 8002eff8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b28:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001b2a:	00006997          	auipc	s3,0x6
    80001b2e:	6e698993          	addi	s3,s3,1766 # 80008210 <etext+0x210>
    printf("%d %s %s", p->pid, state, p->name);
    80001b32:	00006a97          	auipc	s5,0x6
    80001b36:	6e6a8a93          	addi	s5,s5,1766 # 80008218 <etext+0x218>
    printf("\n");
    80001b3a:	00006a17          	auipc	s4,0x6
    80001b3e:	4eea0a13          	addi	s4,s4,1262 # 80008028 <etext+0x28>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b42:	00007b97          	auipc	s7,0x7
    80001b46:	bceb8b93          	addi	s7,s7,-1074 # 80008710 <states.0>
    80001b4a:	a00d                	j	80001b6c <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001b4c:	ed86a583          	lw	a1,-296(a3)
    80001b50:	8556                	mv	a0,s5
    80001b52:	00004097          	auipc	ra,0x4
    80001b56:	37a080e7          	jalr	890(ra) # 80005ecc <printf>
    printf("\n");
    80001b5a:	8552                	mv	a0,s4
    80001b5c:	00004097          	auipc	ra,0x4
    80001b60:	370080e7          	jalr	880(ra) # 80005ecc <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001b64:	16848493          	addi	s1,s1,360
    80001b68:	03248263          	beq	s1,s2,80001b8c <procdump+0x9a>
    if(p->state == UNUSED)
    80001b6c:	86a6                	mv	a3,s1
    80001b6e:	ec04a783          	lw	a5,-320(s1)
    80001b72:	dbed                	beqz	a5,80001b64 <procdump+0x72>
      state = "???";
    80001b74:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b76:	fcfb6be3          	bltu	s6,a5,80001b4c <procdump+0x5a>
    80001b7a:	02079713          	slli	a4,a5,0x20
    80001b7e:	01d75793          	srli	a5,a4,0x1d
    80001b82:	97de                	add	a5,a5,s7
    80001b84:	6390                	ld	a2,0(a5)
    80001b86:	f279                	bnez	a2,80001b4c <procdump+0x5a>
      state = "???";
    80001b88:	864e                	mv	a2,s3
    80001b8a:	b7c9                	j	80001b4c <procdump+0x5a>
  }
}
    80001b8c:	60a6                	ld	ra,72(sp)
    80001b8e:	6406                	ld	s0,64(sp)
    80001b90:	74e2                	ld	s1,56(sp)
    80001b92:	7942                	ld	s2,48(sp)
    80001b94:	79a2                	ld	s3,40(sp)
    80001b96:	7a02                	ld	s4,32(sp)
    80001b98:	6ae2                	ld	s5,24(sp)
    80001b9a:	6b42                	ld	s6,16(sp)
    80001b9c:	6ba2                	ld	s7,8(sp)
    80001b9e:	6161                	addi	sp,sp,80
    80001ba0:	8082                	ret

0000000080001ba2 <swtch>:
    80001ba2:	00153023          	sd	ra,0(a0)
    80001ba6:	00253423          	sd	sp,8(a0)
    80001baa:	e900                	sd	s0,16(a0)
    80001bac:	ed04                	sd	s1,24(a0)
    80001bae:	03253023          	sd	s2,32(a0)
    80001bb2:	03353423          	sd	s3,40(a0)
    80001bb6:	03453823          	sd	s4,48(a0)
    80001bba:	03553c23          	sd	s5,56(a0)
    80001bbe:	05653023          	sd	s6,64(a0)
    80001bc2:	05753423          	sd	s7,72(a0)
    80001bc6:	05853823          	sd	s8,80(a0)
    80001bca:	05953c23          	sd	s9,88(a0)
    80001bce:	07a53023          	sd	s10,96(a0)
    80001bd2:	07b53423          	sd	s11,104(a0)
    80001bd6:	0005b083          	ld	ra,0(a1)
    80001bda:	0085b103          	ld	sp,8(a1)
    80001bde:	6980                	ld	s0,16(a1)
    80001be0:	6d84                	ld	s1,24(a1)
    80001be2:	0205b903          	ld	s2,32(a1)
    80001be6:	0285b983          	ld	s3,40(a1)
    80001bea:	0305ba03          	ld	s4,48(a1)
    80001bee:	0385ba83          	ld	s5,56(a1)
    80001bf2:	0405bb03          	ld	s6,64(a1)
    80001bf6:	0485bb83          	ld	s7,72(a1)
    80001bfa:	0505bc03          	ld	s8,80(a1)
    80001bfe:	0585bc83          	ld	s9,88(a1)
    80001c02:	0605bd03          	ld	s10,96(a1)
    80001c06:	0685bd83          	ld	s11,104(a1)
    80001c0a:	8082                	ret

0000000080001c0c <trapinit>:
int cow(uint64 va, pagetable_t pagetable);

extern int devintr();

void trapinit(void)
{
    80001c0c:	1141                	addi	sp,sp,-16
    80001c0e:	e406                	sd	ra,8(sp)
    80001c10:	e022                	sd	s0,0(sp)
    80001c12:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001c14:	00006597          	auipc	a1,0x6
    80001c18:	63c58593          	addi	a1,a1,1596 # 80008250 <etext+0x250>
    80001c1c:	0002d517          	auipc	a0,0x2d
    80001c20:	28450513          	addi	a0,a0,644 # 8002eea0 <tickslock>
    80001c24:	00004097          	auipc	ra,0x4
    80001c28:	74a080e7          	jalr	1866(ra) # 8000636e <initlock>
}
    80001c2c:	60a2                	ld	ra,8(sp)
    80001c2e:	6402                	ld	s0,0(sp)
    80001c30:	0141                	addi	sp,sp,16
    80001c32:	8082                	ret

0000000080001c34 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void trapinithart(void)
{
    80001c34:	1141                	addi	sp,sp,-16
    80001c36:	e406                	sd	ra,8(sp)
    80001c38:	e022                	sd	s0,0(sp)
    80001c3a:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c3c:	00003797          	auipc	a5,0x3
    80001c40:	67478793          	addi	a5,a5,1652 # 800052b0 <kernelvec>
    80001c44:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001c48:	60a2                	ld	ra,8(sp)
    80001c4a:	6402                	ld	s0,0(sp)
    80001c4c:	0141                	addi	sp,sp,16
    80001c4e:	8082                	ret

0000000080001c50 <cow>:

  usertrapret();
}

int cow(uint64 va, pagetable_t pagetable)
{
    80001c50:	87aa                	mv	a5,a0
  if (va >= MAXVA)
    80001c52:	577d                	li	a4,-1
    80001c54:	8369                	srli	a4,a4,0x1a
    80001c56:	08a76963          	bltu	a4,a0,80001ce8 <cow+0x98>
{
    80001c5a:	7179                	addi	sp,sp,-48
    80001c5c:	f406                	sd	ra,40(sp)
    80001c5e:	f022                	sd	s0,32(sp)
    80001c60:	e052                	sd	s4,0(sp)
    80001c62:	1800                	addi	s0,sp,48
    80001c64:	852e                	mv	a0,a1
    return -1;

  pte_t *pte = walk(pagetable, va, 0);
    80001c66:	4601                	li	a2,0
    80001c68:	85be                	mv	a1,a5
    80001c6a:	fffff097          	auipc	ra,0xfffff
    80001c6e:	912080e7          	jalr	-1774(ra) # 8000057c <walk>
    80001c72:	8a2a                	mv	s4,a0
  if (pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0)
    80001c74:	cd25                	beqz	a0,80001cec <cow+0x9c>
    80001c76:	ec26                	sd	s1,24(sp)
    80001c78:	6104                	ld	s1,0(a0)
    80001c7a:	0114f713          	andi	a4,s1,17
    80001c7e:	47c5                	li	a5,17
    80001c80:	06f71863          	bne	a4,a5,80001cf0 <cow+0xa0>
    return -1; // page not present or not user-accessible

  uint64 pa = PTE2PA(*pte);
  uint flags = PTE_FLAGS(*pte);
    80001c84:	0004879b          	sext.w	a5,s1

  if(flags & PTE_W) return 0;
    80001c88:	0044f713          	andi	a4,s1,4
    80001c8c:	4501                	li	a0,0
    80001c8e:	ef25                	bnez	a4,80001d06 <cow+0xb6>
  if (!(flags & PTE_C)) return -1; // not a COW page
    80001c90:	1007f713          	andi	a4,a5,256
    80001c94:	c32d                	beqz	a4,80001cf6 <cow+0xa6>
    80001c96:	e84a                	sd	s2,16(sp)
    80001c98:	e44e                	sd	s3,8(sp)

  flags |= PTE_W; // set writable flag
  flags &= ~PTE_C; // clear COW flag
    80001c9a:	2ff7f793          	andi	a5,a5,767
    80001c9e:	0047e993          	ori	s3,a5,4

  char *mem;
  if ((mem = kalloc()) == 0)
    80001ca2:	ffffe097          	auipc	ra,0xffffe
    80001ca6:	568080e7          	jalr	1384(ra) # 8000020a <kalloc>
    80001caa:	892a                	mv	s2,a0
    80001cac:	c921                	beqz	a0,80001cfc <cow+0xac>
  uint64 pa = PTE2PA(*pte);
    80001cae:	80a9                	srli	s1,s1,0xa
    80001cb0:	04b2                	slli	s1,s1,0xc
    return -1; // out of memory

  memmove(mem, (char *)pa, PGSIZE); // copy the page content
    80001cb2:	6605                	lui	a2,0x1
    80001cb4:	85a6                	mv	a1,s1
    80001cb6:	ffffe097          	auipc	ra,0xffffe
    80001cba:	632080e7          	jalr	1586(ra) # 800002e8 <memmove>
  *pte = PA2PTE((uint64)mem) | flags; // update the page table entry
    80001cbe:	00c95913          	srli	s2,s2,0xc
    80001cc2:	092a                	slli	s2,s2,0xa
    80001cc4:	0129e7b3          	or	a5,s3,s2
    80001cc8:	00fa3023          	sd	a5,0(s4)
  kfree((void *)pa); // free the old page
    80001ccc:	8526                	mv	a0,s1
    80001cce:	ffffe097          	auipc	ra,0xffffe
    80001cd2:	3e6080e7          	jalr	998(ra) # 800000b4 <kfree>
  return 0;
    80001cd6:	4501                	li	a0,0
    80001cd8:	64e2                	ld	s1,24(sp)
    80001cda:	6942                	ld	s2,16(sp)
    80001cdc:	69a2                	ld	s3,8(sp)
}
    80001cde:	70a2                	ld	ra,40(sp)
    80001ce0:	7402                	ld	s0,32(sp)
    80001ce2:	6a02                	ld	s4,0(sp)
    80001ce4:	6145                	addi	sp,sp,48
    80001ce6:	8082                	ret
    return -1;
    80001ce8:	557d                	li	a0,-1
}
    80001cea:	8082                	ret
    return -1; // page not present or not user-accessible
    80001cec:	557d                	li	a0,-1
    80001cee:	bfc5                	j	80001cde <cow+0x8e>
    80001cf0:	557d                	li	a0,-1
    80001cf2:	64e2                	ld	s1,24(sp)
    80001cf4:	b7ed                	j	80001cde <cow+0x8e>
  if (!(flags & PTE_C)) return -1; // not a COW page
    80001cf6:	557d                	li	a0,-1
    80001cf8:	64e2                	ld	s1,24(sp)
    80001cfa:	b7d5                	j	80001cde <cow+0x8e>
    return -1; // out of memory
    80001cfc:	557d                	li	a0,-1
    80001cfe:	64e2                	ld	s1,24(sp)
    80001d00:	6942                	ld	s2,16(sp)
    80001d02:	69a2                	ld	s3,8(sp)
    80001d04:	bfe9                	j	80001cde <cow+0x8e>
    80001d06:	64e2                	ld	s1,24(sp)
    80001d08:	bfd9                	j	80001cde <cow+0x8e>

0000000080001d0a <usertrapret>:

//
// return to user space
//
void usertrapret(void)
{
    80001d0a:	1141                	addi	sp,sp,-16
    80001d0c:	e406                	sd	ra,8(sp)
    80001d0e:	e022                	sd	s0,0(sp)
    80001d10:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001d12:	fffff097          	auipc	ra,0xfffff
    80001d16:	2d0080e7          	jalr	720(ra) # 80000fe2 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d1a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001d1e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d20:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001d24:	00005697          	auipc	a3,0x5
    80001d28:	2dc68693          	addi	a3,a3,732 # 80007000 <_trampoline>
    80001d2c:	00005717          	auipc	a4,0x5
    80001d30:	2d470713          	addi	a4,a4,724 # 80007000 <_trampoline>
    80001d34:	8f15                	sub	a4,a4,a3
    80001d36:	040007b7          	lui	a5,0x4000
    80001d3a:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001d3c:	07b2                	slli	a5,a5,0xc
    80001d3e:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001d40:	10571073          	csrw	stvec,a4

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001d44:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001d46:	18002673          	csrr	a2,satp
    80001d4a:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001d4c:	6d30                	ld	a2,88(a0)
    80001d4e:	6138                	ld	a4,64(a0)
    80001d50:	6585                	lui	a1,0x1
    80001d52:	972e                	add	a4,a4,a1
    80001d54:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001d56:	6d38                	ld	a4,88(a0)
    80001d58:	00000617          	auipc	a2,0x0
    80001d5c:	14060613          	addi	a2,a2,320 # 80001e98 <usertrap>
    80001d60:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp(); // hartid for cpuid()
    80001d62:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001d64:	8612                	mv	a2,tp
    80001d66:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d68:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.

  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001d6c:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001d70:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d74:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001d78:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001d7a:	6f18                	ld	a4,24(a4)
    80001d7c:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001d80:	692c                	ld	a1,80(a0)
    80001d82:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001d84:	00005717          	auipc	a4,0x5
    80001d88:	30c70713          	addi	a4,a4,780 # 80007090 <userret>
    80001d8c:	8f15                	sub	a4,a4,a3
    80001d8e:	97ba                	add	a5,a5,a4
  ((void (*)(uint64, uint64))fn)(TRAPFRAME, satp);
    80001d90:	577d                	li	a4,-1
    80001d92:	177e                	slli	a4,a4,0x3f
    80001d94:	8dd9                	or	a1,a1,a4
    80001d96:	02000537          	lui	a0,0x2000
    80001d9a:	157d                	addi	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    80001d9c:	0536                	slli	a0,a0,0xd
    80001d9e:	9782                	jalr	a5
}
    80001da0:	60a2                	ld	ra,8(sp)
    80001da2:	6402                	ld	s0,0(sp)
    80001da4:	0141                	addi	sp,sp,16
    80001da6:	8082                	ret

0000000080001da8 <clockintr>:
  w_sepc(sepc);
  w_sstatus(sstatus);
}

void clockintr()
{
    80001da8:	1101                	addi	sp,sp,-32
    80001daa:	ec06                	sd	ra,24(sp)
    80001dac:	e822                	sd	s0,16(sp)
    80001dae:	e426                	sd	s1,8(sp)
    80001db0:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001db2:	0002d497          	auipc	s1,0x2d
    80001db6:	0ee48493          	addi	s1,s1,238 # 8002eea0 <tickslock>
    80001dba:	8526                	mv	a0,s1
    80001dbc:	00004097          	auipc	ra,0x4
    80001dc0:	646080e7          	jalr	1606(ra) # 80006402 <acquire>
  ticks++;
    80001dc4:	00007517          	auipc	a0,0x7
    80001dc8:	25450513          	addi	a0,a0,596 # 80009018 <ticks>
    80001dcc:	411c                	lw	a5,0(a0)
    80001dce:	2785                	addiw	a5,a5,1
    80001dd0:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001dd2:	00000097          	auipc	ra,0x0
    80001dd6:	a5c080e7          	jalr	-1444(ra) # 8000182e <wakeup>
  release(&tickslock);
    80001dda:	8526                	mv	a0,s1
    80001ddc:	00004097          	auipc	ra,0x4
    80001de0:	6d6080e7          	jalr	1750(ra) # 800064b2 <release>
}
    80001de4:	60e2                	ld	ra,24(sp)
    80001de6:	6442                	ld	s0,16(sp)
    80001de8:	64a2                	ld	s1,8(sp)
    80001dea:	6105                	addi	sp,sp,32
    80001dec:	8082                	ret

0000000080001dee <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001dee:	142027f3          	csrr	a5,scause

    return 2;
  }
  else
  {
    return 0;
    80001df2:	4501                	li	a0,0
  if ((scause & 0x8000000000000000L) &&
    80001df4:	0a07d163          	bgez	a5,80001e96 <devintr+0xa8>
{
    80001df8:	1101                	addi	sp,sp,-32
    80001dfa:	ec06                	sd	ra,24(sp)
    80001dfc:	e822                	sd	s0,16(sp)
    80001dfe:	1000                	addi	s0,sp,32
      (scause & 0xff) == 9)
    80001e00:	0ff7f713          	zext.b	a4,a5
  if ((scause & 0x8000000000000000L) &&
    80001e04:	46a5                	li	a3,9
    80001e06:	00d70c63          	beq	a4,a3,80001e1e <devintr+0x30>
  else if (scause == 0x8000000000000001L)
    80001e0a:	577d                	li	a4,-1
    80001e0c:	177e                	slli	a4,a4,0x3f
    80001e0e:	0705                	addi	a4,a4,1
    return 0;
    80001e10:	4501                	li	a0,0
  else if (scause == 0x8000000000000001L)
    80001e12:	06e78163          	beq	a5,a4,80001e74 <devintr+0x86>
  }
}
    80001e16:	60e2                	ld	ra,24(sp)
    80001e18:	6442                	ld	s0,16(sp)
    80001e1a:	6105                	addi	sp,sp,32
    80001e1c:	8082                	ret
    80001e1e:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80001e20:	00003097          	auipc	ra,0x3
    80001e24:	59c080e7          	jalr	1436(ra) # 800053bc <plic_claim>
    80001e28:	84aa                	mv	s1,a0
    if (irq == UART0_IRQ)
    80001e2a:	47a9                	li	a5,10
    80001e2c:	00f50963          	beq	a0,a5,80001e3e <devintr+0x50>
    else if (irq == VIRTIO0_IRQ)
    80001e30:	4785                	li	a5,1
    80001e32:	00f50b63          	beq	a0,a5,80001e48 <devintr+0x5a>
    return 1;
    80001e36:	4505                	li	a0,1
    else if (irq)
    80001e38:	ec89                	bnez	s1,80001e52 <devintr+0x64>
    80001e3a:	64a2                	ld	s1,8(sp)
    80001e3c:	bfe9                	j	80001e16 <devintr+0x28>
      uartintr();
    80001e3e:	00004097          	auipc	ra,0x4
    80001e42:	4e0080e7          	jalr	1248(ra) # 8000631e <uartintr>
    if (irq)
    80001e46:	a839                	j	80001e64 <devintr+0x76>
      virtio_disk_intr();
    80001e48:	00004097          	auipc	ra,0x4
    80001e4c:	a2e080e7          	jalr	-1490(ra) # 80005876 <virtio_disk_intr>
    if (irq)
    80001e50:	a811                	j	80001e64 <devintr+0x76>
      printf("unexpected interrupt irq=%d\n", irq);
    80001e52:	85a6                	mv	a1,s1
    80001e54:	00006517          	auipc	a0,0x6
    80001e58:	40450513          	addi	a0,a0,1028 # 80008258 <etext+0x258>
    80001e5c:	00004097          	auipc	ra,0x4
    80001e60:	070080e7          	jalr	112(ra) # 80005ecc <printf>
      plic_complete(irq);
    80001e64:	8526                	mv	a0,s1
    80001e66:	00003097          	auipc	ra,0x3
    80001e6a:	57a080e7          	jalr	1402(ra) # 800053e0 <plic_complete>
    return 1;
    80001e6e:	4505                	li	a0,1
    80001e70:	64a2                	ld	s1,8(sp)
    80001e72:	b755                	j	80001e16 <devintr+0x28>
    if (cpuid() == 0)
    80001e74:	fffff097          	auipc	ra,0xfffff
    80001e78:	13a080e7          	jalr	314(ra) # 80000fae <cpuid>
    80001e7c:	c901                	beqz	a0,80001e8c <devintr+0x9e>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001e7e:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001e82:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001e84:	14479073          	csrw	sip,a5
    return 2;
    80001e88:	4509                	li	a0,2
    80001e8a:	b771                	j	80001e16 <devintr+0x28>
      clockintr();
    80001e8c:	00000097          	auipc	ra,0x0
    80001e90:	f1c080e7          	jalr	-228(ra) # 80001da8 <clockintr>
    80001e94:	b7ed                	j	80001e7e <devintr+0x90>
}
    80001e96:	8082                	ret

0000000080001e98 <usertrap>:
{
    80001e98:	1101                	addi	sp,sp,-32
    80001e9a:	ec06                	sd	ra,24(sp)
    80001e9c:	e822                	sd	s0,16(sp)
    80001e9e:	e426                	sd	s1,8(sp)
    80001ea0:	e04a                	sd	s2,0(sp)
    80001ea2:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ea4:	100027f3          	csrr	a5,sstatus
  if ((r_sstatus() & SSTATUS_SPP) != 0)
    80001ea8:	1007f793          	andi	a5,a5,256
    80001eac:	e3ad                	bnez	a5,80001f0e <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001eae:	00003797          	auipc	a5,0x3
    80001eb2:	40278793          	addi	a5,a5,1026 # 800052b0 <kernelvec>
    80001eb6:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001eba:	fffff097          	auipc	ra,0xfffff
    80001ebe:	128080e7          	jalr	296(ra) # 80000fe2 <myproc>
    80001ec2:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001ec4:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ec6:	14102773          	csrr	a4,sepc
    80001eca:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ecc:	14202773          	csrr	a4,scause
  if (r_scause() == 8)
    80001ed0:	47a1                	li	a5,8
    80001ed2:	04f71c63          	bne	a4,a5,80001f2a <usertrap+0x92>
    if (p->killed)
    80001ed6:	551c                	lw	a5,40(a0)
    80001ed8:	e3b9                	bnez	a5,80001f1e <usertrap+0x86>
    p->trapframe->epc += 4;
    80001eda:	6cb8                	ld	a4,88(s1)
    80001edc:	6f1c                	ld	a5,24(a4)
    80001ede:	0791                	addi	a5,a5,4
    80001ee0:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ee2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001ee6:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001eea:	10079073          	csrw	sstatus,a5
    syscall();
    80001eee:	00000097          	auipc	ra,0x0
    80001ef2:	2fe080e7          	jalr	766(ra) # 800021ec <syscall>
  if (p->killed)
    80001ef6:	549c                	lw	a5,40(s1)
    80001ef8:	e7dd                	bnez	a5,80001fa6 <usertrap+0x10e>
  usertrapret();
    80001efa:	00000097          	auipc	ra,0x0
    80001efe:	e10080e7          	jalr	-496(ra) # 80001d0a <usertrapret>
}
    80001f02:	60e2                	ld	ra,24(sp)
    80001f04:	6442                	ld	s0,16(sp)
    80001f06:	64a2                	ld	s1,8(sp)
    80001f08:	6902                	ld	s2,0(sp)
    80001f0a:	6105                	addi	sp,sp,32
    80001f0c:	8082                	ret
    panic("usertrap: not from user mode");
    80001f0e:	00006517          	auipc	a0,0x6
    80001f12:	36a50513          	addi	a0,a0,874 # 80008278 <etext+0x278>
    80001f16:	00004097          	auipc	ra,0x4
    80001f1a:	f6c080e7          	jalr	-148(ra) # 80005e82 <panic>
      exit(-1);
    80001f1e:	557d                	li	a0,-1
    80001f20:	00000097          	auipc	ra,0x0
    80001f24:	9de080e7          	jalr	-1570(ra) # 800018fe <exit>
    80001f28:	bf4d                	j	80001eda <usertrap+0x42>
  else if ((which_dev = devintr()) != 0)
    80001f2a:	00000097          	auipc	ra,0x0
    80001f2e:	ec4080e7          	jalr	-316(ra) # 80001dee <devintr>
    80001f32:	892a                	mv	s2,a0
    80001f34:	e535                	bnez	a0,80001fa0 <usertrap+0x108>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001f36:	14202773          	csrr	a4,scause
  else if (r_scause() == 15)
    80001f3a:	47bd                	li	a5,15
    80001f3c:	04f70863          	beq	a4,a5,80001f8c <usertrap+0xf4>
    80001f40:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001f44:	5890                	lw	a2,48(s1)
    80001f46:	00006517          	auipc	a0,0x6
    80001f4a:	35250513          	addi	a0,a0,850 # 80008298 <etext+0x298>
    80001f4e:	00004097          	auipc	ra,0x4
    80001f52:	f7e080e7          	jalr	-130(ra) # 80005ecc <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f56:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001f5a:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001f5e:	00006517          	auipc	a0,0x6
    80001f62:	36a50513          	addi	a0,a0,874 # 800082c8 <etext+0x2c8>
    80001f66:	00004097          	auipc	ra,0x4
    80001f6a:	f66080e7          	jalr	-154(ra) # 80005ecc <printf>
    p->killed = 1;
    80001f6e:	4785                	li	a5,1
    80001f70:	d49c                	sw	a5,40(s1)
    exit(-1);
    80001f72:	557d                	li	a0,-1
    80001f74:	00000097          	auipc	ra,0x0
    80001f78:	98a080e7          	jalr	-1654(ra) # 800018fe <exit>
  if (which_dev == 2)
    80001f7c:	4789                	li	a5,2
    80001f7e:	f6f91ee3          	bne	s2,a5,80001efa <usertrap+0x62>
    yield();
    80001f82:	fffff097          	auipc	ra,0xfffff
    80001f86:	6ea080e7          	jalr	1770(ra) # 8000166c <yield>
    80001f8a:	bf85                	j	80001efa <usertrap+0x62>
    80001f8c:	14302573          	csrr	a0,stval
    if(cow(r_stval(), p->pagetable) < 0)
    80001f90:	68ac                	ld	a1,80(s1)
    80001f92:	00000097          	auipc	ra,0x0
    80001f96:	cbe080e7          	jalr	-834(ra) # 80001c50 <cow>
    80001f9a:	f4055ee3          	bgez	a0,80001ef6 <usertrap+0x5e>
    80001f9e:	bfc1                	j	80001f6e <usertrap+0xd6>
  if (p->killed)
    80001fa0:	549c                	lw	a5,40(s1)
    80001fa2:	dfe9                	beqz	a5,80001f7c <usertrap+0xe4>
    80001fa4:	b7f9                	j	80001f72 <usertrap+0xda>
    80001fa6:	4901                	li	s2,0
    80001fa8:	b7e9                	j	80001f72 <usertrap+0xda>

0000000080001faa <kerneltrap>:
{
    80001faa:	7179                	addi	sp,sp,-48
    80001fac:	f406                	sd	ra,40(sp)
    80001fae:	f022                	sd	s0,32(sp)
    80001fb0:	ec26                	sd	s1,24(sp)
    80001fb2:	e84a                	sd	s2,16(sp)
    80001fb4:	e44e                	sd	s3,8(sp)
    80001fb6:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001fb8:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001fbc:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001fc0:	142029f3          	csrr	s3,scause
  if ((sstatus & SSTATUS_SPP) == 0)
    80001fc4:	1004f793          	andi	a5,s1,256
    80001fc8:	cb85                	beqz	a5,80001ff8 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001fca:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001fce:	8b89                	andi	a5,a5,2
  if (intr_get() != 0)
    80001fd0:	ef85                	bnez	a5,80002008 <kerneltrap+0x5e>
  if ((which_dev = devintr()) == 0)
    80001fd2:	00000097          	auipc	ra,0x0
    80001fd6:	e1c080e7          	jalr	-484(ra) # 80001dee <devintr>
    80001fda:	cd1d                	beqz	a0,80002018 <kerneltrap+0x6e>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001fdc:	4789                	li	a5,2
    80001fde:	06f50a63          	beq	a0,a5,80002052 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001fe2:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001fe6:	10049073          	csrw	sstatus,s1
}
    80001fea:	70a2                	ld	ra,40(sp)
    80001fec:	7402                	ld	s0,32(sp)
    80001fee:	64e2                	ld	s1,24(sp)
    80001ff0:	6942                	ld	s2,16(sp)
    80001ff2:	69a2                	ld	s3,8(sp)
    80001ff4:	6145                	addi	sp,sp,48
    80001ff6:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001ff8:	00006517          	auipc	a0,0x6
    80001ffc:	2f050513          	addi	a0,a0,752 # 800082e8 <etext+0x2e8>
    80002000:	00004097          	auipc	ra,0x4
    80002004:	e82080e7          	jalr	-382(ra) # 80005e82 <panic>
    panic("kerneltrap: interrupts enabled");
    80002008:	00006517          	auipc	a0,0x6
    8000200c:	30850513          	addi	a0,a0,776 # 80008310 <etext+0x310>
    80002010:	00004097          	auipc	ra,0x4
    80002014:	e72080e7          	jalr	-398(ra) # 80005e82 <panic>
    printf("scause %p\n", scause);
    80002018:	85ce                	mv	a1,s3
    8000201a:	00006517          	auipc	a0,0x6
    8000201e:	31650513          	addi	a0,a0,790 # 80008330 <etext+0x330>
    80002022:	00004097          	auipc	ra,0x4
    80002026:	eaa080e7          	jalr	-342(ra) # 80005ecc <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000202a:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    8000202e:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002032:	00006517          	auipc	a0,0x6
    80002036:	30e50513          	addi	a0,a0,782 # 80008340 <etext+0x340>
    8000203a:	00004097          	auipc	ra,0x4
    8000203e:	e92080e7          	jalr	-366(ra) # 80005ecc <printf>
    panic("kerneltrap");
    80002042:	00006517          	auipc	a0,0x6
    80002046:	31650513          	addi	a0,a0,790 # 80008358 <etext+0x358>
    8000204a:	00004097          	auipc	ra,0x4
    8000204e:	e38080e7          	jalr	-456(ra) # 80005e82 <panic>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002052:	fffff097          	auipc	ra,0xfffff
    80002056:	f90080e7          	jalr	-112(ra) # 80000fe2 <myproc>
    8000205a:	d541                	beqz	a0,80001fe2 <kerneltrap+0x38>
    8000205c:	fffff097          	auipc	ra,0xfffff
    80002060:	f86080e7          	jalr	-122(ra) # 80000fe2 <myproc>
    80002064:	4d18                	lw	a4,24(a0)
    80002066:	4791                	li	a5,4
    80002068:	f6f71de3          	bne	a4,a5,80001fe2 <kerneltrap+0x38>
    yield();
    8000206c:	fffff097          	auipc	ra,0xfffff
    80002070:	600080e7          	jalr	1536(ra) # 8000166c <yield>
    80002074:	b7bd                	j	80001fe2 <kerneltrap+0x38>

0000000080002076 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002076:	1101                	addi	sp,sp,-32
    80002078:	ec06                	sd	ra,24(sp)
    8000207a:	e822                	sd	s0,16(sp)
    8000207c:	e426                	sd	s1,8(sp)
    8000207e:	1000                	addi	s0,sp,32
    80002080:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002082:	fffff097          	auipc	ra,0xfffff
    80002086:	f60080e7          	jalr	-160(ra) # 80000fe2 <myproc>
  switch (n) {
    8000208a:	4795                	li	a5,5
    8000208c:	0497e163          	bltu	a5,s1,800020ce <argraw+0x58>
    80002090:	048a                	slli	s1,s1,0x2
    80002092:	00006717          	auipc	a4,0x6
    80002096:	6ae70713          	addi	a4,a4,1710 # 80008740 <states.0+0x30>
    8000209a:	94ba                	add	s1,s1,a4
    8000209c:	409c                	lw	a5,0(s1)
    8000209e:	97ba                	add	a5,a5,a4
    800020a0:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    800020a2:	6d3c                	ld	a5,88(a0)
    800020a4:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    800020a6:	60e2                	ld	ra,24(sp)
    800020a8:	6442                	ld	s0,16(sp)
    800020aa:	64a2                	ld	s1,8(sp)
    800020ac:	6105                	addi	sp,sp,32
    800020ae:	8082                	ret
    return p->trapframe->a1;
    800020b0:	6d3c                	ld	a5,88(a0)
    800020b2:	7fa8                	ld	a0,120(a5)
    800020b4:	bfcd                	j	800020a6 <argraw+0x30>
    return p->trapframe->a2;
    800020b6:	6d3c                	ld	a5,88(a0)
    800020b8:	63c8                	ld	a0,128(a5)
    800020ba:	b7f5                	j	800020a6 <argraw+0x30>
    return p->trapframe->a3;
    800020bc:	6d3c                	ld	a5,88(a0)
    800020be:	67c8                	ld	a0,136(a5)
    800020c0:	b7dd                	j	800020a6 <argraw+0x30>
    return p->trapframe->a4;
    800020c2:	6d3c                	ld	a5,88(a0)
    800020c4:	6bc8                	ld	a0,144(a5)
    800020c6:	b7c5                	j	800020a6 <argraw+0x30>
    return p->trapframe->a5;
    800020c8:	6d3c                	ld	a5,88(a0)
    800020ca:	6fc8                	ld	a0,152(a5)
    800020cc:	bfe9                	j	800020a6 <argraw+0x30>
  panic("argraw");
    800020ce:	00006517          	auipc	a0,0x6
    800020d2:	29a50513          	addi	a0,a0,666 # 80008368 <etext+0x368>
    800020d6:	00004097          	auipc	ra,0x4
    800020da:	dac080e7          	jalr	-596(ra) # 80005e82 <panic>

00000000800020de <fetchaddr>:
{
    800020de:	1101                	addi	sp,sp,-32
    800020e0:	ec06                	sd	ra,24(sp)
    800020e2:	e822                	sd	s0,16(sp)
    800020e4:	e426                	sd	s1,8(sp)
    800020e6:	e04a                	sd	s2,0(sp)
    800020e8:	1000                	addi	s0,sp,32
    800020ea:	84aa                	mv	s1,a0
    800020ec:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800020ee:	fffff097          	auipc	ra,0xfffff
    800020f2:	ef4080e7          	jalr	-268(ra) # 80000fe2 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    800020f6:	653c                	ld	a5,72(a0)
    800020f8:	02f4f863          	bgeu	s1,a5,80002128 <fetchaddr+0x4a>
    800020fc:	00848713          	addi	a4,s1,8
    80002100:	02e7e663          	bltu	a5,a4,8000212c <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002104:	46a1                	li	a3,8
    80002106:	8626                	mv	a2,s1
    80002108:	85ca                	mv	a1,s2
    8000210a:	6928                	ld	a0,80(a0)
    8000210c:	fffff097          	auipc	ra,0xfffff
    80002110:	c0e080e7          	jalr	-1010(ra) # 80000d1a <copyin>
    80002114:	00a03533          	snez	a0,a0
    80002118:	40a0053b          	negw	a0,a0
}
    8000211c:	60e2                	ld	ra,24(sp)
    8000211e:	6442                	ld	s0,16(sp)
    80002120:	64a2                	ld	s1,8(sp)
    80002122:	6902                	ld	s2,0(sp)
    80002124:	6105                	addi	sp,sp,32
    80002126:	8082                	ret
    return -1;
    80002128:	557d                	li	a0,-1
    8000212a:	bfcd                	j	8000211c <fetchaddr+0x3e>
    8000212c:	557d                	li	a0,-1
    8000212e:	b7fd                	j	8000211c <fetchaddr+0x3e>

0000000080002130 <fetchstr>:
{
    80002130:	7179                	addi	sp,sp,-48
    80002132:	f406                	sd	ra,40(sp)
    80002134:	f022                	sd	s0,32(sp)
    80002136:	ec26                	sd	s1,24(sp)
    80002138:	e84a                	sd	s2,16(sp)
    8000213a:	e44e                	sd	s3,8(sp)
    8000213c:	1800                	addi	s0,sp,48
    8000213e:	892a                	mv	s2,a0
    80002140:	84ae                	mv	s1,a1
    80002142:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002144:	fffff097          	auipc	ra,0xfffff
    80002148:	e9e080e7          	jalr	-354(ra) # 80000fe2 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    8000214c:	86ce                	mv	a3,s3
    8000214e:	864a                	mv	a2,s2
    80002150:	85a6                	mv	a1,s1
    80002152:	6928                	ld	a0,80(a0)
    80002154:	fffff097          	auipc	ra,0xfffff
    80002158:	c54080e7          	jalr	-940(ra) # 80000da8 <copyinstr>
  if(err < 0)
    8000215c:	00054763          	bltz	a0,8000216a <fetchstr+0x3a>
  return strlen(buf);
    80002160:	8526                	mv	a0,s1
    80002162:	ffffe097          	auipc	ra,0xffffe
    80002166:	2ae080e7          	jalr	686(ra) # 80000410 <strlen>
}
    8000216a:	70a2                	ld	ra,40(sp)
    8000216c:	7402                	ld	s0,32(sp)
    8000216e:	64e2                	ld	s1,24(sp)
    80002170:	6942                	ld	s2,16(sp)
    80002172:	69a2                	ld	s3,8(sp)
    80002174:	6145                	addi	sp,sp,48
    80002176:	8082                	ret

0000000080002178 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80002178:	1101                	addi	sp,sp,-32
    8000217a:	ec06                	sd	ra,24(sp)
    8000217c:	e822                	sd	s0,16(sp)
    8000217e:	e426                	sd	s1,8(sp)
    80002180:	1000                	addi	s0,sp,32
    80002182:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002184:	00000097          	auipc	ra,0x0
    80002188:	ef2080e7          	jalr	-270(ra) # 80002076 <argraw>
    8000218c:	c088                	sw	a0,0(s1)
  return 0;
}
    8000218e:	4501                	li	a0,0
    80002190:	60e2                	ld	ra,24(sp)
    80002192:	6442                	ld	s0,16(sp)
    80002194:	64a2                	ld	s1,8(sp)
    80002196:	6105                	addi	sp,sp,32
    80002198:	8082                	ret

000000008000219a <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    8000219a:	1101                	addi	sp,sp,-32
    8000219c:	ec06                	sd	ra,24(sp)
    8000219e:	e822                	sd	s0,16(sp)
    800021a0:	e426                	sd	s1,8(sp)
    800021a2:	1000                	addi	s0,sp,32
    800021a4:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800021a6:	00000097          	auipc	ra,0x0
    800021aa:	ed0080e7          	jalr	-304(ra) # 80002076 <argraw>
    800021ae:	e088                	sd	a0,0(s1)
  return 0;
}
    800021b0:	4501                	li	a0,0
    800021b2:	60e2                	ld	ra,24(sp)
    800021b4:	6442                	ld	s0,16(sp)
    800021b6:	64a2                	ld	s1,8(sp)
    800021b8:	6105                	addi	sp,sp,32
    800021ba:	8082                	ret

00000000800021bc <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800021bc:	1101                	addi	sp,sp,-32
    800021be:	ec06                	sd	ra,24(sp)
    800021c0:	e822                	sd	s0,16(sp)
    800021c2:	e426                	sd	s1,8(sp)
    800021c4:	e04a                	sd	s2,0(sp)
    800021c6:	1000                	addi	s0,sp,32
    800021c8:	84ae                	mv	s1,a1
    800021ca:	8932                	mv	s2,a2
  *ip = argraw(n);
    800021cc:	00000097          	auipc	ra,0x0
    800021d0:	eaa080e7          	jalr	-342(ra) # 80002076 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    800021d4:	864a                	mv	a2,s2
    800021d6:	85a6                	mv	a1,s1
    800021d8:	00000097          	auipc	ra,0x0
    800021dc:	f58080e7          	jalr	-168(ra) # 80002130 <fetchstr>
}
    800021e0:	60e2                	ld	ra,24(sp)
    800021e2:	6442                	ld	s0,16(sp)
    800021e4:	64a2                	ld	s1,8(sp)
    800021e6:	6902                	ld	s2,0(sp)
    800021e8:	6105                	addi	sp,sp,32
    800021ea:	8082                	ret

00000000800021ec <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    800021ec:	1101                	addi	sp,sp,-32
    800021ee:	ec06                	sd	ra,24(sp)
    800021f0:	e822                	sd	s0,16(sp)
    800021f2:	e426                	sd	s1,8(sp)
    800021f4:	e04a                	sd	s2,0(sp)
    800021f6:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    800021f8:	fffff097          	auipc	ra,0xfffff
    800021fc:	dea080e7          	jalr	-534(ra) # 80000fe2 <myproc>
    80002200:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002202:	05853903          	ld	s2,88(a0)
    80002206:	0a893783          	ld	a5,168(s2)
    8000220a:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    8000220e:	37fd                	addiw	a5,a5,-1
    80002210:	4751                	li	a4,20
    80002212:	00f76f63          	bltu	a4,a5,80002230 <syscall+0x44>
    80002216:	00369713          	slli	a4,a3,0x3
    8000221a:	00006797          	auipc	a5,0x6
    8000221e:	53e78793          	addi	a5,a5,1342 # 80008758 <syscalls>
    80002222:	97ba                	add	a5,a5,a4
    80002224:	639c                	ld	a5,0(a5)
    80002226:	c789                	beqz	a5,80002230 <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    80002228:	9782                	jalr	a5
    8000222a:	06a93823          	sd	a0,112(s2)
    8000222e:	a839                	j	8000224c <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002230:	15848613          	addi	a2,s1,344
    80002234:	588c                	lw	a1,48(s1)
    80002236:	00006517          	auipc	a0,0x6
    8000223a:	13a50513          	addi	a0,a0,314 # 80008370 <etext+0x370>
    8000223e:	00004097          	auipc	ra,0x4
    80002242:	c8e080e7          	jalr	-882(ra) # 80005ecc <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002246:	6cbc                	ld	a5,88(s1)
    80002248:	577d                	li	a4,-1
    8000224a:	fbb8                	sd	a4,112(a5)
  }
}
    8000224c:	60e2                	ld	ra,24(sp)
    8000224e:	6442                	ld	s0,16(sp)
    80002250:	64a2                	ld	s1,8(sp)
    80002252:	6902                	ld	s2,0(sp)
    80002254:	6105                	addi	sp,sp,32
    80002256:	8082                	ret

0000000080002258 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002258:	1101                	addi	sp,sp,-32
    8000225a:	ec06                	sd	ra,24(sp)
    8000225c:	e822                	sd	s0,16(sp)
    8000225e:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80002260:	fec40593          	addi	a1,s0,-20
    80002264:	4501                	li	a0,0
    80002266:	00000097          	auipc	ra,0x0
    8000226a:	f12080e7          	jalr	-238(ra) # 80002178 <argint>
    return -1;
    8000226e:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002270:	00054963          	bltz	a0,80002282 <sys_exit+0x2a>
  exit(n);
    80002274:	fec42503          	lw	a0,-20(s0)
    80002278:	fffff097          	auipc	ra,0xfffff
    8000227c:	686080e7          	jalr	1670(ra) # 800018fe <exit>
  return 0;  // not reached
    80002280:	4781                	li	a5,0
}
    80002282:	853e                	mv	a0,a5
    80002284:	60e2                	ld	ra,24(sp)
    80002286:	6442                	ld	s0,16(sp)
    80002288:	6105                	addi	sp,sp,32
    8000228a:	8082                	ret

000000008000228c <sys_getpid>:

uint64
sys_getpid(void)
{
    8000228c:	1141                	addi	sp,sp,-16
    8000228e:	e406                	sd	ra,8(sp)
    80002290:	e022                	sd	s0,0(sp)
    80002292:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002294:	fffff097          	auipc	ra,0xfffff
    80002298:	d4e080e7          	jalr	-690(ra) # 80000fe2 <myproc>
}
    8000229c:	5908                	lw	a0,48(a0)
    8000229e:	60a2                	ld	ra,8(sp)
    800022a0:	6402                	ld	s0,0(sp)
    800022a2:	0141                	addi	sp,sp,16
    800022a4:	8082                	ret

00000000800022a6 <sys_fork>:

uint64
sys_fork(void)
{
    800022a6:	1141                	addi	sp,sp,-16
    800022a8:	e406                	sd	ra,8(sp)
    800022aa:	e022                	sd	s0,0(sp)
    800022ac:	0800                	addi	s0,sp,16
  return fork();
    800022ae:	fffff097          	auipc	ra,0xfffff
    800022b2:	106080e7          	jalr	262(ra) # 800013b4 <fork>
}
    800022b6:	60a2                	ld	ra,8(sp)
    800022b8:	6402                	ld	s0,0(sp)
    800022ba:	0141                	addi	sp,sp,16
    800022bc:	8082                	ret

00000000800022be <sys_wait>:

uint64
sys_wait(void)
{
    800022be:	1101                	addi	sp,sp,-32
    800022c0:	ec06                	sd	ra,24(sp)
    800022c2:	e822                	sd	s0,16(sp)
    800022c4:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    800022c6:	fe840593          	addi	a1,s0,-24
    800022ca:	4501                	li	a0,0
    800022cc:	00000097          	auipc	ra,0x0
    800022d0:	ece080e7          	jalr	-306(ra) # 8000219a <argaddr>
    800022d4:	87aa                	mv	a5,a0
    return -1;
    800022d6:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    800022d8:	0007c863          	bltz	a5,800022e8 <sys_wait+0x2a>
  return wait(p);
    800022dc:	fe843503          	ld	a0,-24(s0)
    800022e0:	fffff097          	auipc	ra,0xfffff
    800022e4:	42c080e7          	jalr	1068(ra) # 8000170c <wait>
}
    800022e8:	60e2                	ld	ra,24(sp)
    800022ea:	6442                	ld	s0,16(sp)
    800022ec:	6105                	addi	sp,sp,32
    800022ee:	8082                	ret

00000000800022f0 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800022f0:	7179                	addi	sp,sp,-48
    800022f2:	f406                	sd	ra,40(sp)
    800022f4:	f022                	sd	s0,32(sp)
    800022f6:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    800022f8:	fdc40593          	addi	a1,s0,-36
    800022fc:	4501                	li	a0,0
    800022fe:	00000097          	auipc	ra,0x0
    80002302:	e7a080e7          	jalr	-390(ra) # 80002178 <argint>
    80002306:	87aa                	mv	a5,a0
    return -1;
    80002308:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    8000230a:	0207c263          	bltz	a5,8000232e <sys_sbrk+0x3e>
    8000230e:	ec26                	sd	s1,24(sp)
  addr = myproc()->sz;
    80002310:	fffff097          	auipc	ra,0xfffff
    80002314:	cd2080e7          	jalr	-814(ra) # 80000fe2 <myproc>
    80002318:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    8000231a:	fdc42503          	lw	a0,-36(s0)
    8000231e:	fffff097          	auipc	ra,0xfffff
    80002322:	01e080e7          	jalr	30(ra) # 8000133c <growproc>
    80002326:	00054863          	bltz	a0,80002336 <sys_sbrk+0x46>
    return -1;
  return addr;
    8000232a:	8526                	mv	a0,s1
    8000232c:	64e2                	ld	s1,24(sp)
}
    8000232e:	70a2                	ld	ra,40(sp)
    80002330:	7402                	ld	s0,32(sp)
    80002332:	6145                	addi	sp,sp,48
    80002334:	8082                	ret
    return -1;
    80002336:	557d                	li	a0,-1
    80002338:	64e2                	ld	s1,24(sp)
    8000233a:	bfd5                	j	8000232e <sys_sbrk+0x3e>

000000008000233c <sys_sleep>:

uint64
sys_sleep(void)
{
    8000233c:	7139                	addi	sp,sp,-64
    8000233e:	fc06                	sd	ra,56(sp)
    80002340:	f822                	sd	s0,48(sp)
    80002342:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    80002344:	fcc40593          	addi	a1,s0,-52
    80002348:	4501                	li	a0,0
    8000234a:	00000097          	auipc	ra,0x0
    8000234e:	e2e080e7          	jalr	-466(ra) # 80002178 <argint>
    return -1;
    80002352:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002354:	06054b63          	bltz	a0,800023ca <sys_sleep+0x8e>
    80002358:	f04a                	sd	s2,32(sp)
  acquire(&tickslock);
    8000235a:	0002d517          	auipc	a0,0x2d
    8000235e:	b4650513          	addi	a0,a0,-1210 # 8002eea0 <tickslock>
    80002362:	00004097          	auipc	ra,0x4
    80002366:	0a0080e7          	jalr	160(ra) # 80006402 <acquire>
  ticks0 = ticks;
    8000236a:	00007917          	auipc	s2,0x7
    8000236e:	cae92903          	lw	s2,-850(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    80002372:	fcc42783          	lw	a5,-52(s0)
    80002376:	c3a1                	beqz	a5,800023b6 <sys_sleep+0x7a>
    80002378:	f426                	sd	s1,40(sp)
    8000237a:	ec4e                	sd	s3,24(sp)
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    8000237c:	0002d997          	auipc	s3,0x2d
    80002380:	b2498993          	addi	s3,s3,-1244 # 8002eea0 <tickslock>
    80002384:	00007497          	auipc	s1,0x7
    80002388:	c9448493          	addi	s1,s1,-876 # 80009018 <ticks>
    if(myproc()->killed){
    8000238c:	fffff097          	auipc	ra,0xfffff
    80002390:	c56080e7          	jalr	-938(ra) # 80000fe2 <myproc>
    80002394:	551c                	lw	a5,40(a0)
    80002396:	ef9d                	bnez	a5,800023d4 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    80002398:	85ce                	mv	a1,s3
    8000239a:	8526                	mv	a0,s1
    8000239c:	fffff097          	auipc	ra,0xfffff
    800023a0:	30c080e7          	jalr	780(ra) # 800016a8 <sleep>
  while(ticks - ticks0 < n){
    800023a4:	409c                	lw	a5,0(s1)
    800023a6:	412787bb          	subw	a5,a5,s2
    800023aa:	fcc42703          	lw	a4,-52(s0)
    800023ae:	fce7efe3          	bltu	a5,a4,8000238c <sys_sleep+0x50>
    800023b2:	74a2                	ld	s1,40(sp)
    800023b4:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    800023b6:	0002d517          	auipc	a0,0x2d
    800023ba:	aea50513          	addi	a0,a0,-1302 # 8002eea0 <tickslock>
    800023be:	00004097          	auipc	ra,0x4
    800023c2:	0f4080e7          	jalr	244(ra) # 800064b2 <release>
  return 0;
    800023c6:	4781                	li	a5,0
    800023c8:	7902                	ld	s2,32(sp)
}
    800023ca:	853e                	mv	a0,a5
    800023cc:	70e2                	ld	ra,56(sp)
    800023ce:	7442                	ld	s0,48(sp)
    800023d0:	6121                	addi	sp,sp,64
    800023d2:	8082                	ret
      release(&tickslock);
    800023d4:	0002d517          	auipc	a0,0x2d
    800023d8:	acc50513          	addi	a0,a0,-1332 # 8002eea0 <tickslock>
    800023dc:	00004097          	auipc	ra,0x4
    800023e0:	0d6080e7          	jalr	214(ra) # 800064b2 <release>
      return -1;
    800023e4:	57fd                	li	a5,-1
    800023e6:	74a2                	ld	s1,40(sp)
    800023e8:	7902                	ld	s2,32(sp)
    800023ea:	69e2                	ld	s3,24(sp)
    800023ec:	bff9                	j	800023ca <sys_sleep+0x8e>

00000000800023ee <sys_kill>:

uint64
sys_kill(void)
{
    800023ee:	1101                	addi	sp,sp,-32
    800023f0:	ec06                	sd	ra,24(sp)
    800023f2:	e822                	sd	s0,16(sp)
    800023f4:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    800023f6:	fec40593          	addi	a1,s0,-20
    800023fa:	4501                	li	a0,0
    800023fc:	00000097          	auipc	ra,0x0
    80002400:	d7c080e7          	jalr	-644(ra) # 80002178 <argint>
    80002404:	87aa                	mv	a5,a0
    return -1;
    80002406:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80002408:	0007c863          	bltz	a5,80002418 <sys_kill+0x2a>
  return kill(pid);
    8000240c:	fec42503          	lw	a0,-20(s0)
    80002410:	fffff097          	auipc	ra,0xfffff
    80002414:	5c4080e7          	jalr	1476(ra) # 800019d4 <kill>
}
    80002418:	60e2                	ld	ra,24(sp)
    8000241a:	6442                	ld	s0,16(sp)
    8000241c:	6105                	addi	sp,sp,32
    8000241e:	8082                	ret

0000000080002420 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002420:	1101                	addi	sp,sp,-32
    80002422:	ec06                	sd	ra,24(sp)
    80002424:	e822                	sd	s0,16(sp)
    80002426:	e426                	sd	s1,8(sp)
    80002428:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    8000242a:	0002d517          	auipc	a0,0x2d
    8000242e:	a7650513          	addi	a0,a0,-1418 # 8002eea0 <tickslock>
    80002432:	00004097          	auipc	ra,0x4
    80002436:	fd0080e7          	jalr	-48(ra) # 80006402 <acquire>
  xticks = ticks;
    8000243a:	00007497          	auipc	s1,0x7
    8000243e:	bde4a483          	lw	s1,-1058(s1) # 80009018 <ticks>
  release(&tickslock);
    80002442:	0002d517          	auipc	a0,0x2d
    80002446:	a5e50513          	addi	a0,a0,-1442 # 8002eea0 <tickslock>
    8000244a:	00004097          	auipc	ra,0x4
    8000244e:	068080e7          	jalr	104(ra) # 800064b2 <release>
  return xticks;
}
    80002452:	02049513          	slli	a0,s1,0x20
    80002456:	9101                	srli	a0,a0,0x20
    80002458:	60e2                	ld	ra,24(sp)
    8000245a:	6442                	ld	s0,16(sp)
    8000245c:	64a2                	ld	s1,8(sp)
    8000245e:	6105                	addi	sp,sp,32
    80002460:	8082                	ret

0000000080002462 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002462:	7179                	addi	sp,sp,-48
    80002464:	f406                	sd	ra,40(sp)
    80002466:	f022                	sd	s0,32(sp)
    80002468:	ec26                	sd	s1,24(sp)
    8000246a:	e84a                	sd	s2,16(sp)
    8000246c:	e44e                	sd	s3,8(sp)
    8000246e:	e052                	sd	s4,0(sp)
    80002470:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002472:	00006597          	auipc	a1,0x6
    80002476:	f1e58593          	addi	a1,a1,-226 # 80008390 <etext+0x390>
    8000247a:	0002d517          	auipc	a0,0x2d
    8000247e:	a3e50513          	addi	a0,a0,-1474 # 8002eeb8 <bcache>
    80002482:	00004097          	auipc	ra,0x4
    80002486:	eec080e7          	jalr	-276(ra) # 8000636e <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    8000248a:	00035797          	auipc	a5,0x35
    8000248e:	a2e78793          	addi	a5,a5,-1490 # 80036eb8 <bcache+0x8000>
    80002492:	00035717          	auipc	a4,0x35
    80002496:	c8e70713          	addi	a4,a4,-882 # 80037120 <bcache+0x8268>
    8000249a:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000249e:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800024a2:	0002d497          	auipc	s1,0x2d
    800024a6:	a2e48493          	addi	s1,s1,-1490 # 8002eed0 <bcache+0x18>
    b->next = bcache.head.next;
    800024aa:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800024ac:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800024ae:	00006a17          	auipc	s4,0x6
    800024b2:	eeaa0a13          	addi	s4,s4,-278 # 80008398 <etext+0x398>
    b->next = bcache.head.next;
    800024b6:	2b893783          	ld	a5,696(s2)
    800024ba:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800024bc:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800024c0:	85d2                	mv	a1,s4
    800024c2:	01048513          	addi	a0,s1,16
    800024c6:	00001097          	auipc	ra,0x1
    800024ca:	4ba080e7          	jalr	1210(ra) # 80003980 <initsleeplock>
    bcache.head.next->prev = b;
    800024ce:	2b893783          	ld	a5,696(s2)
    800024d2:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800024d4:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800024d8:	45848493          	addi	s1,s1,1112
    800024dc:	fd349de3          	bne	s1,s3,800024b6 <binit+0x54>
  }
}
    800024e0:	70a2                	ld	ra,40(sp)
    800024e2:	7402                	ld	s0,32(sp)
    800024e4:	64e2                	ld	s1,24(sp)
    800024e6:	6942                	ld	s2,16(sp)
    800024e8:	69a2                	ld	s3,8(sp)
    800024ea:	6a02                	ld	s4,0(sp)
    800024ec:	6145                	addi	sp,sp,48
    800024ee:	8082                	ret

00000000800024f0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800024f0:	7179                	addi	sp,sp,-48
    800024f2:	f406                	sd	ra,40(sp)
    800024f4:	f022                	sd	s0,32(sp)
    800024f6:	ec26                	sd	s1,24(sp)
    800024f8:	e84a                	sd	s2,16(sp)
    800024fa:	e44e                	sd	s3,8(sp)
    800024fc:	1800                	addi	s0,sp,48
    800024fe:	892a                	mv	s2,a0
    80002500:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002502:	0002d517          	auipc	a0,0x2d
    80002506:	9b650513          	addi	a0,a0,-1610 # 8002eeb8 <bcache>
    8000250a:	00004097          	auipc	ra,0x4
    8000250e:	ef8080e7          	jalr	-264(ra) # 80006402 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002512:	00035497          	auipc	s1,0x35
    80002516:	c5e4b483          	ld	s1,-930(s1) # 80037170 <bcache+0x82b8>
    8000251a:	00035797          	auipc	a5,0x35
    8000251e:	c0678793          	addi	a5,a5,-1018 # 80037120 <bcache+0x8268>
    80002522:	02f48f63          	beq	s1,a5,80002560 <bread+0x70>
    80002526:	873e                	mv	a4,a5
    80002528:	a021                	j	80002530 <bread+0x40>
    8000252a:	68a4                	ld	s1,80(s1)
    8000252c:	02e48a63          	beq	s1,a4,80002560 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002530:	449c                	lw	a5,8(s1)
    80002532:	ff279ce3          	bne	a5,s2,8000252a <bread+0x3a>
    80002536:	44dc                	lw	a5,12(s1)
    80002538:	ff3799e3          	bne	a5,s3,8000252a <bread+0x3a>
      b->refcnt++;
    8000253c:	40bc                	lw	a5,64(s1)
    8000253e:	2785                	addiw	a5,a5,1
    80002540:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002542:	0002d517          	auipc	a0,0x2d
    80002546:	97650513          	addi	a0,a0,-1674 # 8002eeb8 <bcache>
    8000254a:	00004097          	auipc	ra,0x4
    8000254e:	f68080e7          	jalr	-152(ra) # 800064b2 <release>
      acquiresleep(&b->lock);
    80002552:	01048513          	addi	a0,s1,16
    80002556:	00001097          	auipc	ra,0x1
    8000255a:	464080e7          	jalr	1124(ra) # 800039ba <acquiresleep>
      return b;
    8000255e:	a8b9                	j	800025bc <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002560:	00035497          	auipc	s1,0x35
    80002564:	c084b483          	ld	s1,-1016(s1) # 80037168 <bcache+0x82b0>
    80002568:	00035797          	auipc	a5,0x35
    8000256c:	bb878793          	addi	a5,a5,-1096 # 80037120 <bcache+0x8268>
    80002570:	00f48863          	beq	s1,a5,80002580 <bread+0x90>
    80002574:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002576:	40bc                	lw	a5,64(s1)
    80002578:	cf81                	beqz	a5,80002590 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000257a:	64a4                	ld	s1,72(s1)
    8000257c:	fee49de3          	bne	s1,a4,80002576 <bread+0x86>
  panic("bget: no buffers");
    80002580:	00006517          	auipc	a0,0x6
    80002584:	e2050513          	addi	a0,a0,-480 # 800083a0 <etext+0x3a0>
    80002588:	00004097          	auipc	ra,0x4
    8000258c:	8fa080e7          	jalr	-1798(ra) # 80005e82 <panic>
      b->dev = dev;
    80002590:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002594:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002598:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000259c:	4785                	li	a5,1
    8000259e:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800025a0:	0002d517          	auipc	a0,0x2d
    800025a4:	91850513          	addi	a0,a0,-1768 # 8002eeb8 <bcache>
    800025a8:	00004097          	auipc	ra,0x4
    800025ac:	f0a080e7          	jalr	-246(ra) # 800064b2 <release>
      acquiresleep(&b->lock);
    800025b0:	01048513          	addi	a0,s1,16
    800025b4:	00001097          	auipc	ra,0x1
    800025b8:	406080e7          	jalr	1030(ra) # 800039ba <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800025bc:	409c                	lw	a5,0(s1)
    800025be:	cb89                	beqz	a5,800025d0 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800025c0:	8526                	mv	a0,s1
    800025c2:	70a2                	ld	ra,40(sp)
    800025c4:	7402                	ld	s0,32(sp)
    800025c6:	64e2                	ld	s1,24(sp)
    800025c8:	6942                	ld	s2,16(sp)
    800025ca:	69a2                	ld	s3,8(sp)
    800025cc:	6145                	addi	sp,sp,48
    800025ce:	8082                	ret
    virtio_disk_rw(b, 0);
    800025d0:	4581                	li	a1,0
    800025d2:	8526                	mv	a0,s1
    800025d4:	00003097          	auipc	ra,0x3
    800025d8:	01a080e7          	jalr	26(ra) # 800055ee <virtio_disk_rw>
    b->valid = 1;
    800025dc:	4785                	li	a5,1
    800025de:	c09c                	sw	a5,0(s1)
  return b;
    800025e0:	b7c5                	j	800025c0 <bread+0xd0>

00000000800025e2 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800025e2:	1101                	addi	sp,sp,-32
    800025e4:	ec06                	sd	ra,24(sp)
    800025e6:	e822                	sd	s0,16(sp)
    800025e8:	e426                	sd	s1,8(sp)
    800025ea:	1000                	addi	s0,sp,32
    800025ec:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800025ee:	0541                	addi	a0,a0,16
    800025f0:	00001097          	auipc	ra,0x1
    800025f4:	464080e7          	jalr	1124(ra) # 80003a54 <holdingsleep>
    800025f8:	cd01                	beqz	a0,80002610 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800025fa:	4585                	li	a1,1
    800025fc:	8526                	mv	a0,s1
    800025fe:	00003097          	auipc	ra,0x3
    80002602:	ff0080e7          	jalr	-16(ra) # 800055ee <virtio_disk_rw>
}
    80002606:	60e2                	ld	ra,24(sp)
    80002608:	6442                	ld	s0,16(sp)
    8000260a:	64a2                	ld	s1,8(sp)
    8000260c:	6105                	addi	sp,sp,32
    8000260e:	8082                	ret
    panic("bwrite");
    80002610:	00006517          	auipc	a0,0x6
    80002614:	da850513          	addi	a0,a0,-600 # 800083b8 <etext+0x3b8>
    80002618:	00004097          	auipc	ra,0x4
    8000261c:	86a080e7          	jalr	-1942(ra) # 80005e82 <panic>

0000000080002620 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002620:	1101                	addi	sp,sp,-32
    80002622:	ec06                	sd	ra,24(sp)
    80002624:	e822                	sd	s0,16(sp)
    80002626:	e426                	sd	s1,8(sp)
    80002628:	e04a                	sd	s2,0(sp)
    8000262a:	1000                	addi	s0,sp,32
    8000262c:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000262e:	01050913          	addi	s2,a0,16
    80002632:	854a                	mv	a0,s2
    80002634:	00001097          	auipc	ra,0x1
    80002638:	420080e7          	jalr	1056(ra) # 80003a54 <holdingsleep>
    8000263c:	c535                	beqz	a0,800026a8 <brelse+0x88>
    panic("brelse");

  releasesleep(&b->lock);
    8000263e:	854a                	mv	a0,s2
    80002640:	00001097          	auipc	ra,0x1
    80002644:	3d0080e7          	jalr	976(ra) # 80003a10 <releasesleep>

  acquire(&bcache.lock);
    80002648:	0002d517          	auipc	a0,0x2d
    8000264c:	87050513          	addi	a0,a0,-1936 # 8002eeb8 <bcache>
    80002650:	00004097          	auipc	ra,0x4
    80002654:	db2080e7          	jalr	-590(ra) # 80006402 <acquire>
  b->refcnt--;
    80002658:	40bc                	lw	a5,64(s1)
    8000265a:	37fd                	addiw	a5,a5,-1
    8000265c:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000265e:	e79d                	bnez	a5,8000268c <brelse+0x6c>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002660:	68b8                	ld	a4,80(s1)
    80002662:	64bc                	ld	a5,72(s1)
    80002664:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002666:	68b8                	ld	a4,80(s1)
    80002668:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000266a:	00035797          	auipc	a5,0x35
    8000266e:	84e78793          	addi	a5,a5,-1970 # 80036eb8 <bcache+0x8000>
    80002672:	2b87b703          	ld	a4,696(a5)
    80002676:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002678:	00035717          	auipc	a4,0x35
    8000267c:	aa870713          	addi	a4,a4,-1368 # 80037120 <bcache+0x8268>
    80002680:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002682:	2b87b703          	ld	a4,696(a5)
    80002686:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002688:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000268c:	0002d517          	auipc	a0,0x2d
    80002690:	82c50513          	addi	a0,a0,-2004 # 8002eeb8 <bcache>
    80002694:	00004097          	auipc	ra,0x4
    80002698:	e1e080e7          	jalr	-482(ra) # 800064b2 <release>
}
    8000269c:	60e2                	ld	ra,24(sp)
    8000269e:	6442                	ld	s0,16(sp)
    800026a0:	64a2                	ld	s1,8(sp)
    800026a2:	6902                	ld	s2,0(sp)
    800026a4:	6105                	addi	sp,sp,32
    800026a6:	8082                	ret
    panic("brelse");
    800026a8:	00006517          	auipc	a0,0x6
    800026ac:	d1850513          	addi	a0,a0,-744 # 800083c0 <etext+0x3c0>
    800026b0:	00003097          	auipc	ra,0x3
    800026b4:	7d2080e7          	jalr	2002(ra) # 80005e82 <panic>

00000000800026b8 <bpin>:

void
bpin(struct buf *b) {
    800026b8:	1101                	addi	sp,sp,-32
    800026ba:	ec06                	sd	ra,24(sp)
    800026bc:	e822                	sd	s0,16(sp)
    800026be:	e426                	sd	s1,8(sp)
    800026c0:	1000                	addi	s0,sp,32
    800026c2:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800026c4:	0002c517          	auipc	a0,0x2c
    800026c8:	7f450513          	addi	a0,a0,2036 # 8002eeb8 <bcache>
    800026cc:	00004097          	auipc	ra,0x4
    800026d0:	d36080e7          	jalr	-714(ra) # 80006402 <acquire>
  b->refcnt++;
    800026d4:	40bc                	lw	a5,64(s1)
    800026d6:	2785                	addiw	a5,a5,1
    800026d8:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800026da:	0002c517          	auipc	a0,0x2c
    800026de:	7de50513          	addi	a0,a0,2014 # 8002eeb8 <bcache>
    800026e2:	00004097          	auipc	ra,0x4
    800026e6:	dd0080e7          	jalr	-560(ra) # 800064b2 <release>
}
    800026ea:	60e2                	ld	ra,24(sp)
    800026ec:	6442                	ld	s0,16(sp)
    800026ee:	64a2                	ld	s1,8(sp)
    800026f0:	6105                	addi	sp,sp,32
    800026f2:	8082                	ret

00000000800026f4 <bunpin>:

void
bunpin(struct buf *b) {
    800026f4:	1101                	addi	sp,sp,-32
    800026f6:	ec06                	sd	ra,24(sp)
    800026f8:	e822                	sd	s0,16(sp)
    800026fa:	e426                	sd	s1,8(sp)
    800026fc:	1000                	addi	s0,sp,32
    800026fe:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002700:	0002c517          	auipc	a0,0x2c
    80002704:	7b850513          	addi	a0,a0,1976 # 8002eeb8 <bcache>
    80002708:	00004097          	auipc	ra,0x4
    8000270c:	cfa080e7          	jalr	-774(ra) # 80006402 <acquire>
  b->refcnt--;
    80002710:	40bc                	lw	a5,64(s1)
    80002712:	37fd                	addiw	a5,a5,-1
    80002714:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002716:	0002c517          	auipc	a0,0x2c
    8000271a:	7a250513          	addi	a0,a0,1954 # 8002eeb8 <bcache>
    8000271e:	00004097          	auipc	ra,0x4
    80002722:	d94080e7          	jalr	-620(ra) # 800064b2 <release>
}
    80002726:	60e2                	ld	ra,24(sp)
    80002728:	6442                	ld	s0,16(sp)
    8000272a:	64a2                	ld	s1,8(sp)
    8000272c:	6105                	addi	sp,sp,32
    8000272e:	8082                	ret

0000000080002730 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002730:	1101                	addi	sp,sp,-32
    80002732:	ec06                	sd	ra,24(sp)
    80002734:	e822                	sd	s0,16(sp)
    80002736:	e426                	sd	s1,8(sp)
    80002738:	e04a                	sd	s2,0(sp)
    8000273a:	1000                	addi	s0,sp,32
    8000273c:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000273e:	00d5d79b          	srliw	a5,a1,0xd
    80002742:	00035597          	auipc	a1,0x35
    80002746:	e525a583          	lw	a1,-430(a1) # 80037594 <sb+0x1c>
    8000274a:	9dbd                	addw	a1,a1,a5
    8000274c:	00000097          	auipc	ra,0x0
    80002750:	da4080e7          	jalr	-604(ra) # 800024f0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002754:	0074f713          	andi	a4,s1,7
    80002758:	4785                	li	a5,1
    8000275a:	00e797bb          	sllw	a5,a5,a4
  bi = b % BPB;
    8000275e:	14ce                	slli	s1,s1,0x33
  if((bp->data[bi/8] & m) == 0)
    80002760:	90d9                	srli	s1,s1,0x36
    80002762:	00950733          	add	a4,a0,s1
    80002766:	05874703          	lbu	a4,88(a4)
    8000276a:	00e7f6b3          	and	a3,a5,a4
    8000276e:	c69d                	beqz	a3,8000279c <bfree+0x6c>
    80002770:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002772:	94aa                	add	s1,s1,a0
    80002774:	fff7c793          	not	a5,a5
    80002778:	8f7d                	and	a4,a4,a5
    8000277a:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    8000277e:	00001097          	auipc	ra,0x1
    80002782:	11e080e7          	jalr	286(ra) # 8000389c <log_write>
  brelse(bp);
    80002786:	854a                	mv	a0,s2
    80002788:	00000097          	auipc	ra,0x0
    8000278c:	e98080e7          	jalr	-360(ra) # 80002620 <brelse>
}
    80002790:	60e2                	ld	ra,24(sp)
    80002792:	6442                	ld	s0,16(sp)
    80002794:	64a2                	ld	s1,8(sp)
    80002796:	6902                	ld	s2,0(sp)
    80002798:	6105                	addi	sp,sp,32
    8000279a:	8082                	ret
    panic("freeing free block");
    8000279c:	00006517          	auipc	a0,0x6
    800027a0:	c2c50513          	addi	a0,a0,-980 # 800083c8 <etext+0x3c8>
    800027a4:	00003097          	auipc	ra,0x3
    800027a8:	6de080e7          	jalr	1758(ra) # 80005e82 <panic>

00000000800027ac <balloc>:
{
    800027ac:	715d                	addi	sp,sp,-80
    800027ae:	e486                	sd	ra,72(sp)
    800027b0:	e0a2                	sd	s0,64(sp)
    800027b2:	fc26                	sd	s1,56(sp)
    800027b4:	f84a                	sd	s2,48(sp)
    800027b6:	f44e                	sd	s3,40(sp)
    800027b8:	f052                	sd	s4,32(sp)
    800027ba:	ec56                	sd	s5,24(sp)
    800027bc:	e85a                	sd	s6,16(sp)
    800027be:	e45e                	sd	s7,8(sp)
    800027c0:	e062                	sd	s8,0(sp)
    800027c2:	0880                	addi	s0,sp,80
  for(b = 0; b < sb.size; b += BPB){
    800027c4:	00035797          	auipc	a5,0x35
    800027c8:	db87a783          	lw	a5,-584(a5) # 8003757c <sb+0x4>
    800027cc:	c7c1                	beqz	a5,80002854 <balloc+0xa8>
    800027ce:	8baa                	mv	s7,a0
    800027d0:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800027d2:	00035b17          	auipc	s6,0x35
    800027d6:	da6b0b13          	addi	s6,s6,-602 # 80037578 <sb>
      m = 1 << (bi % 8);
    800027da:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800027dc:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800027de:	6c09                	lui	s8,0x2
    800027e0:	a821                	j	800027f8 <balloc+0x4c>
    brelse(bp);
    800027e2:	854a                	mv	a0,s2
    800027e4:	00000097          	auipc	ra,0x0
    800027e8:	e3c080e7          	jalr	-452(ra) # 80002620 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800027ec:	015c0abb          	addw	s5,s8,s5
    800027f0:	004b2783          	lw	a5,4(s6)
    800027f4:	06faf063          	bgeu	s5,a5,80002854 <balloc+0xa8>
    bp = bread(dev, BBLOCK(b, sb));
    800027f8:	41fad79b          	sraiw	a5,s5,0x1f
    800027fc:	0137d79b          	srliw	a5,a5,0x13
    80002800:	015787bb          	addw	a5,a5,s5
    80002804:	40d7d79b          	sraiw	a5,a5,0xd
    80002808:	01cb2583          	lw	a1,28(s6)
    8000280c:	9dbd                	addw	a1,a1,a5
    8000280e:	855e                	mv	a0,s7
    80002810:	00000097          	auipc	ra,0x0
    80002814:	ce0080e7          	jalr	-800(ra) # 800024f0 <bread>
    80002818:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000281a:	004b2503          	lw	a0,4(s6)
    8000281e:	84d6                	mv	s1,s5
    80002820:	4701                	li	a4,0
    80002822:	fca4f0e3          	bgeu	s1,a0,800027e2 <balloc+0x36>
      m = 1 << (bi % 8);
    80002826:	00777693          	andi	a3,a4,7
    8000282a:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000282e:	41f7579b          	sraiw	a5,a4,0x1f
    80002832:	01d7d79b          	srliw	a5,a5,0x1d
    80002836:	9fb9                	addw	a5,a5,a4
    80002838:	4037d79b          	sraiw	a5,a5,0x3
    8000283c:	00f90633          	add	a2,s2,a5
    80002840:	05864603          	lbu	a2,88(a2)
    80002844:	00c6f5b3          	and	a1,a3,a2
    80002848:	cd91                	beqz	a1,80002864 <balloc+0xb8>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000284a:	2705                	addiw	a4,a4,1
    8000284c:	2485                	addiw	s1,s1,1
    8000284e:	fd471ae3          	bne	a4,s4,80002822 <balloc+0x76>
    80002852:	bf41                	j	800027e2 <balloc+0x36>
  panic("balloc: out of blocks");
    80002854:	00006517          	auipc	a0,0x6
    80002858:	b8c50513          	addi	a0,a0,-1140 # 800083e0 <etext+0x3e0>
    8000285c:	00003097          	auipc	ra,0x3
    80002860:	626080e7          	jalr	1574(ra) # 80005e82 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002864:	97ca                	add	a5,a5,s2
    80002866:	8e55                	or	a2,a2,a3
    80002868:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    8000286c:	854a                	mv	a0,s2
    8000286e:	00001097          	auipc	ra,0x1
    80002872:	02e080e7          	jalr	46(ra) # 8000389c <log_write>
        brelse(bp);
    80002876:	854a                	mv	a0,s2
    80002878:	00000097          	auipc	ra,0x0
    8000287c:	da8080e7          	jalr	-600(ra) # 80002620 <brelse>
  bp = bread(dev, bno);
    80002880:	85a6                	mv	a1,s1
    80002882:	855e                	mv	a0,s7
    80002884:	00000097          	auipc	ra,0x0
    80002888:	c6c080e7          	jalr	-916(ra) # 800024f0 <bread>
    8000288c:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000288e:	40000613          	li	a2,1024
    80002892:	4581                	li	a1,0
    80002894:	05850513          	addi	a0,a0,88
    80002898:	ffffe097          	auipc	ra,0xffffe
    8000289c:	9ec080e7          	jalr	-1556(ra) # 80000284 <memset>
  log_write(bp);
    800028a0:	854a                	mv	a0,s2
    800028a2:	00001097          	auipc	ra,0x1
    800028a6:	ffa080e7          	jalr	-6(ra) # 8000389c <log_write>
  brelse(bp);
    800028aa:	854a                	mv	a0,s2
    800028ac:	00000097          	auipc	ra,0x0
    800028b0:	d74080e7          	jalr	-652(ra) # 80002620 <brelse>
}
    800028b4:	8526                	mv	a0,s1
    800028b6:	60a6                	ld	ra,72(sp)
    800028b8:	6406                	ld	s0,64(sp)
    800028ba:	74e2                	ld	s1,56(sp)
    800028bc:	7942                	ld	s2,48(sp)
    800028be:	79a2                	ld	s3,40(sp)
    800028c0:	7a02                	ld	s4,32(sp)
    800028c2:	6ae2                	ld	s5,24(sp)
    800028c4:	6b42                	ld	s6,16(sp)
    800028c6:	6ba2                	ld	s7,8(sp)
    800028c8:	6c02                	ld	s8,0(sp)
    800028ca:	6161                	addi	sp,sp,80
    800028cc:	8082                	ret

00000000800028ce <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    800028ce:	7179                	addi	sp,sp,-48
    800028d0:	f406                	sd	ra,40(sp)
    800028d2:	f022                	sd	s0,32(sp)
    800028d4:	ec26                	sd	s1,24(sp)
    800028d6:	e84a                	sd	s2,16(sp)
    800028d8:	e44e                	sd	s3,8(sp)
    800028da:	1800                	addi	s0,sp,48
    800028dc:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800028de:	47ad                	li	a5,11
    800028e0:	04b7fd63          	bgeu	a5,a1,8000293a <bmap+0x6c>
    800028e4:	e052                	sd	s4,0(sp)
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    800028e6:	ff45849b          	addiw	s1,a1,-12

  if(bn < NINDIRECT){
    800028ea:	0ff00793          	li	a5,255
    800028ee:	0897ef63          	bltu	a5,s1,8000298c <bmap+0xbe>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    800028f2:	08052583          	lw	a1,128(a0)
    800028f6:	c5a5                	beqz	a1,8000295e <bmap+0x90>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    800028f8:	00092503          	lw	a0,0(s2)
    800028fc:	00000097          	auipc	ra,0x0
    80002900:	bf4080e7          	jalr	-1036(ra) # 800024f0 <bread>
    80002904:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002906:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    8000290a:	02049713          	slli	a4,s1,0x20
    8000290e:	01e75593          	srli	a1,a4,0x1e
    80002912:	00b784b3          	add	s1,a5,a1
    80002916:	0004a983          	lw	s3,0(s1)
    8000291a:	04098b63          	beqz	s3,80002970 <bmap+0xa2>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    8000291e:	8552                	mv	a0,s4
    80002920:	00000097          	auipc	ra,0x0
    80002924:	d00080e7          	jalr	-768(ra) # 80002620 <brelse>
    return addr;
    80002928:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    8000292a:	854e                	mv	a0,s3
    8000292c:	70a2                	ld	ra,40(sp)
    8000292e:	7402                	ld	s0,32(sp)
    80002930:	64e2                	ld	s1,24(sp)
    80002932:	6942                	ld	s2,16(sp)
    80002934:	69a2                	ld	s3,8(sp)
    80002936:	6145                	addi	sp,sp,48
    80002938:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    8000293a:	02059793          	slli	a5,a1,0x20
    8000293e:	01e7d593          	srli	a1,a5,0x1e
    80002942:	00b504b3          	add	s1,a0,a1
    80002946:	0504a983          	lw	s3,80(s1)
    8000294a:	fe0990e3          	bnez	s3,8000292a <bmap+0x5c>
      ip->addrs[bn] = addr = balloc(ip->dev);
    8000294e:	4108                	lw	a0,0(a0)
    80002950:	00000097          	auipc	ra,0x0
    80002954:	e5c080e7          	jalr	-420(ra) # 800027ac <balloc>
    80002958:	89aa                	mv	s3,a0
    8000295a:	c8a8                	sw	a0,80(s1)
    8000295c:	b7f9                	j	8000292a <bmap+0x5c>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    8000295e:	4108                	lw	a0,0(a0)
    80002960:	00000097          	auipc	ra,0x0
    80002964:	e4c080e7          	jalr	-436(ra) # 800027ac <balloc>
    80002968:	85aa                	mv	a1,a0
    8000296a:	08a92023          	sw	a0,128(s2)
    8000296e:	b769                	j	800028f8 <bmap+0x2a>
      a[bn] = addr = balloc(ip->dev);
    80002970:	00092503          	lw	a0,0(s2)
    80002974:	00000097          	auipc	ra,0x0
    80002978:	e38080e7          	jalr	-456(ra) # 800027ac <balloc>
    8000297c:	89aa                	mv	s3,a0
    8000297e:	c088                	sw	a0,0(s1)
      log_write(bp);
    80002980:	8552                	mv	a0,s4
    80002982:	00001097          	auipc	ra,0x1
    80002986:	f1a080e7          	jalr	-230(ra) # 8000389c <log_write>
    8000298a:	bf51                	j	8000291e <bmap+0x50>
  panic("bmap: out of range");
    8000298c:	00006517          	auipc	a0,0x6
    80002990:	a6c50513          	addi	a0,a0,-1428 # 800083f8 <etext+0x3f8>
    80002994:	00003097          	auipc	ra,0x3
    80002998:	4ee080e7          	jalr	1262(ra) # 80005e82 <panic>

000000008000299c <iget>:
{
    8000299c:	7179                	addi	sp,sp,-48
    8000299e:	f406                	sd	ra,40(sp)
    800029a0:	f022                	sd	s0,32(sp)
    800029a2:	ec26                	sd	s1,24(sp)
    800029a4:	e84a                	sd	s2,16(sp)
    800029a6:	e44e                	sd	s3,8(sp)
    800029a8:	e052                	sd	s4,0(sp)
    800029aa:	1800                	addi	s0,sp,48
    800029ac:	89aa                	mv	s3,a0
    800029ae:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800029b0:	00035517          	auipc	a0,0x35
    800029b4:	be850513          	addi	a0,a0,-1048 # 80037598 <itable>
    800029b8:	00004097          	auipc	ra,0x4
    800029bc:	a4a080e7          	jalr	-1462(ra) # 80006402 <acquire>
  empty = 0;
    800029c0:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800029c2:	00035497          	auipc	s1,0x35
    800029c6:	bee48493          	addi	s1,s1,-1042 # 800375b0 <itable+0x18>
    800029ca:	00036697          	auipc	a3,0x36
    800029ce:	67668693          	addi	a3,a3,1654 # 80039040 <log>
    800029d2:	a039                	j	800029e0 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800029d4:	02090b63          	beqz	s2,80002a0a <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800029d8:	08848493          	addi	s1,s1,136
    800029dc:	02d48a63          	beq	s1,a3,80002a10 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800029e0:	449c                	lw	a5,8(s1)
    800029e2:	fef059e3          	blez	a5,800029d4 <iget+0x38>
    800029e6:	4098                	lw	a4,0(s1)
    800029e8:	ff3716e3          	bne	a4,s3,800029d4 <iget+0x38>
    800029ec:	40d8                	lw	a4,4(s1)
    800029ee:	ff4713e3          	bne	a4,s4,800029d4 <iget+0x38>
      ip->ref++;
    800029f2:	2785                	addiw	a5,a5,1
    800029f4:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800029f6:	00035517          	auipc	a0,0x35
    800029fa:	ba250513          	addi	a0,a0,-1118 # 80037598 <itable>
    800029fe:	00004097          	auipc	ra,0x4
    80002a02:	ab4080e7          	jalr	-1356(ra) # 800064b2 <release>
      return ip;
    80002a06:	8926                	mv	s2,s1
    80002a08:	a03d                	j	80002a36 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002a0a:	f7f9                	bnez	a5,800029d8 <iget+0x3c>
      empty = ip;
    80002a0c:	8926                	mv	s2,s1
    80002a0e:	b7e9                	j	800029d8 <iget+0x3c>
  if(empty == 0)
    80002a10:	02090c63          	beqz	s2,80002a48 <iget+0xac>
  ip->dev = dev;
    80002a14:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002a18:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002a1c:	4785                	li	a5,1
    80002a1e:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002a22:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002a26:	00035517          	auipc	a0,0x35
    80002a2a:	b7250513          	addi	a0,a0,-1166 # 80037598 <itable>
    80002a2e:	00004097          	auipc	ra,0x4
    80002a32:	a84080e7          	jalr	-1404(ra) # 800064b2 <release>
}
    80002a36:	854a                	mv	a0,s2
    80002a38:	70a2                	ld	ra,40(sp)
    80002a3a:	7402                	ld	s0,32(sp)
    80002a3c:	64e2                	ld	s1,24(sp)
    80002a3e:	6942                	ld	s2,16(sp)
    80002a40:	69a2                	ld	s3,8(sp)
    80002a42:	6a02                	ld	s4,0(sp)
    80002a44:	6145                	addi	sp,sp,48
    80002a46:	8082                	ret
    panic("iget: no inodes");
    80002a48:	00006517          	auipc	a0,0x6
    80002a4c:	9c850513          	addi	a0,a0,-1592 # 80008410 <etext+0x410>
    80002a50:	00003097          	auipc	ra,0x3
    80002a54:	432080e7          	jalr	1074(ra) # 80005e82 <panic>

0000000080002a58 <fsinit>:
fsinit(int dev) {
    80002a58:	7179                	addi	sp,sp,-48
    80002a5a:	f406                	sd	ra,40(sp)
    80002a5c:	f022                	sd	s0,32(sp)
    80002a5e:	ec26                	sd	s1,24(sp)
    80002a60:	e84a                	sd	s2,16(sp)
    80002a62:	e44e                	sd	s3,8(sp)
    80002a64:	1800                	addi	s0,sp,48
    80002a66:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002a68:	4585                	li	a1,1
    80002a6a:	00000097          	auipc	ra,0x0
    80002a6e:	a86080e7          	jalr	-1402(ra) # 800024f0 <bread>
    80002a72:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002a74:	00035997          	auipc	s3,0x35
    80002a78:	b0498993          	addi	s3,s3,-1276 # 80037578 <sb>
    80002a7c:	02000613          	li	a2,32
    80002a80:	05850593          	addi	a1,a0,88
    80002a84:	854e                	mv	a0,s3
    80002a86:	ffffe097          	auipc	ra,0xffffe
    80002a8a:	862080e7          	jalr	-1950(ra) # 800002e8 <memmove>
  brelse(bp);
    80002a8e:	8526                	mv	a0,s1
    80002a90:	00000097          	auipc	ra,0x0
    80002a94:	b90080e7          	jalr	-1136(ra) # 80002620 <brelse>
  if(sb.magic != FSMAGIC)
    80002a98:	0009a703          	lw	a4,0(s3)
    80002a9c:	102037b7          	lui	a5,0x10203
    80002aa0:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002aa4:	02f71263          	bne	a4,a5,80002ac8 <fsinit+0x70>
  initlog(dev, &sb);
    80002aa8:	00035597          	auipc	a1,0x35
    80002aac:	ad058593          	addi	a1,a1,-1328 # 80037578 <sb>
    80002ab0:	854a                	mv	a0,s2
    80002ab2:	00001097          	auipc	ra,0x1
    80002ab6:	b74080e7          	jalr	-1164(ra) # 80003626 <initlog>
}
    80002aba:	70a2                	ld	ra,40(sp)
    80002abc:	7402                	ld	s0,32(sp)
    80002abe:	64e2                	ld	s1,24(sp)
    80002ac0:	6942                	ld	s2,16(sp)
    80002ac2:	69a2                	ld	s3,8(sp)
    80002ac4:	6145                	addi	sp,sp,48
    80002ac6:	8082                	ret
    panic("invalid file system");
    80002ac8:	00006517          	auipc	a0,0x6
    80002acc:	95850513          	addi	a0,a0,-1704 # 80008420 <etext+0x420>
    80002ad0:	00003097          	auipc	ra,0x3
    80002ad4:	3b2080e7          	jalr	946(ra) # 80005e82 <panic>

0000000080002ad8 <iinit>:
{
    80002ad8:	7179                	addi	sp,sp,-48
    80002ada:	f406                	sd	ra,40(sp)
    80002adc:	f022                	sd	s0,32(sp)
    80002ade:	ec26                	sd	s1,24(sp)
    80002ae0:	e84a                	sd	s2,16(sp)
    80002ae2:	e44e                	sd	s3,8(sp)
    80002ae4:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002ae6:	00006597          	auipc	a1,0x6
    80002aea:	95258593          	addi	a1,a1,-1710 # 80008438 <etext+0x438>
    80002aee:	00035517          	auipc	a0,0x35
    80002af2:	aaa50513          	addi	a0,a0,-1366 # 80037598 <itable>
    80002af6:	00004097          	auipc	ra,0x4
    80002afa:	878080e7          	jalr	-1928(ra) # 8000636e <initlock>
  for(i = 0; i < NINODE; i++) {
    80002afe:	00035497          	auipc	s1,0x35
    80002b02:	ac248493          	addi	s1,s1,-1342 # 800375c0 <itable+0x28>
    80002b06:	00036997          	auipc	s3,0x36
    80002b0a:	54a98993          	addi	s3,s3,1354 # 80039050 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002b0e:	00006917          	auipc	s2,0x6
    80002b12:	93290913          	addi	s2,s2,-1742 # 80008440 <etext+0x440>
    80002b16:	85ca                	mv	a1,s2
    80002b18:	8526                	mv	a0,s1
    80002b1a:	00001097          	auipc	ra,0x1
    80002b1e:	e66080e7          	jalr	-410(ra) # 80003980 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002b22:	08848493          	addi	s1,s1,136
    80002b26:	ff3498e3          	bne	s1,s3,80002b16 <iinit+0x3e>
}
    80002b2a:	70a2                	ld	ra,40(sp)
    80002b2c:	7402                	ld	s0,32(sp)
    80002b2e:	64e2                	ld	s1,24(sp)
    80002b30:	6942                	ld	s2,16(sp)
    80002b32:	69a2                	ld	s3,8(sp)
    80002b34:	6145                	addi	sp,sp,48
    80002b36:	8082                	ret

0000000080002b38 <ialloc>:
{
    80002b38:	7139                	addi	sp,sp,-64
    80002b3a:	fc06                	sd	ra,56(sp)
    80002b3c:	f822                	sd	s0,48(sp)
    80002b3e:	f426                	sd	s1,40(sp)
    80002b40:	f04a                	sd	s2,32(sp)
    80002b42:	ec4e                	sd	s3,24(sp)
    80002b44:	e852                	sd	s4,16(sp)
    80002b46:	e456                	sd	s5,8(sp)
    80002b48:	e05a                	sd	s6,0(sp)
    80002b4a:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002b4c:	00035717          	auipc	a4,0x35
    80002b50:	a3872703          	lw	a4,-1480(a4) # 80037584 <sb+0xc>
    80002b54:	4785                	li	a5,1
    80002b56:	04e7f863          	bgeu	a5,a4,80002ba6 <ialloc+0x6e>
    80002b5a:	8aaa                	mv	s5,a0
    80002b5c:	8b2e                	mv	s6,a1
    80002b5e:	893e                	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
    80002b60:	00035a17          	auipc	s4,0x35
    80002b64:	a18a0a13          	addi	s4,s4,-1512 # 80037578 <sb>
    80002b68:	00495593          	srli	a1,s2,0x4
    80002b6c:	018a2783          	lw	a5,24(s4)
    80002b70:	9dbd                	addw	a1,a1,a5
    80002b72:	8556                	mv	a0,s5
    80002b74:	00000097          	auipc	ra,0x0
    80002b78:	97c080e7          	jalr	-1668(ra) # 800024f0 <bread>
    80002b7c:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002b7e:	05850993          	addi	s3,a0,88
    80002b82:	00f97793          	andi	a5,s2,15
    80002b86:	079a                	slli	a5,a5,0x6
    80002b88:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002b8a:	00099783          	lh	a5,0(s3)
    80002b8e:	c785                	beqz	a5,80002bb6 <ialloc+0x7e>
    brelse(bp);
    80002b90:	00000097          	auipc	ra,0x0
    80002b94:	a90080e7          	jalr	-1392(ra) # 80002620 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002b98:	0905                	addi	s2,s2,1
    80002b9a:	00ca2703          	lw	a4,12(s4)
    80002b9e:	0009079b          	sext.w	a5,s2
    80002ba2:	fce7e3e3          	bltu	a5,a4,80002b68 <ialloc+0x30>
  panic("ialloc: no inodes");
    80002ba6:	00006517          	auipc	a0,0x6
    80002baa:	8a250513          	addi	a0,a0,-1886 # 80008448 <etext+0x448>
    80002bae:	00003097          	auipc	ra,0x3
    80002bb2:	2d4080e7          	jalr	724(ra) # 80005e82 <panic>
      memset(dip, 0, sizeof(*dip));
    80002bb6:	04000613          	li	a2,64
    80002bba:	4581                	li	a1,0
    80002bbc:	854e                	mv	a0,s3
    80002bbe:	ffffd097          	auipc	ra,0xffffd
    80002bc2:	6c6080e7          	jalr	1734(ra) # 80000284 <memset>
      dip->type = type;
    80002bc6:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002bca:	8526                	mv	a0,s1
    80002bcc:	00001097          	auipc	ra,0x1
    80002bd0:	cd0080e7          	jalr	-816(ra) # 8000389c <log_write>
      brelse(bp);
    80002bd4:	8526                	mv	a0,s1
    80002bd6:	00000097          	auipc	ra,0x0
    80002bda:	a4a080e7          	jalr	-1462(ra) # 80002620 <brelse>
      return iget(dev, inum);
    80002bde:	0009059b          	sext.w	a1,s2
    80002be2:	8556                	mv	a0,s5
    80002be4:	00000097          	auipc	ra,0x0
    80002be8:	db8080e7          	jalr	-584(ra) # 8000299c <iget>
}
    80002bec:	70e2                	ld	ra,56(sp)
    80002bee:	7442                	ld	s0,48(sp)
    80002bf0:	74a2                	ld	s1,40(sp)
    80002bf2:	7902                	ld	s2,32(sp)
    80002bf4:	69e2                	ld	s3,24(sp)
    80002bf6:	6a42                	ld	s4,16(sp)
    80002bf8:	6aa2                	ld	s5,8(sp)
    80002bfa:	6b02                	ld	s6,0(sp)
    80002bfc:	6121                	addi	sp,sp,64
    80002bfe:	8082                	ret

0000000080002c00 <iupdate>:
{
    80002c00:	1101                	addi	sp,sp,-32
    80002c02:	ec06                	sd	ra,24(sp)
    80002c04:	e822                	sd	s0,16(sp)
    80002c06:	e426                	sd	s1,8(sp)
    80002c08:	e04a                	sd	s2,0(sp)
    80002c0a:	1000                	addi	s0,sp,32
    80002c0c:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c0e:	415c                	lw	a5,4(a0)
    80002c10:	0047d79b          	srliw	a5,a5,0x4
    80002c14:	00035597          	auipc	a1,0x35
    80002c18:	97c5a583          	lw	a1,-1668(a1) # 80037590 <sb+0x18>
    80002c1c:	9dbd                	addw	a1,a1,a5
    80002c1e:	4108                	lw	a0,0(a0)
    80002c20:	00000097          	auipc	ra,0x0
    80002c24:	8d0080e7          	jalr	-1840(ra) # 800024f0 <bread>
    80002c28:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c2a:	05850793          	addi	a5,a0,88
    80002c2e:	40d8                	lw	a4,4(s1)
    80002c30:	8b3d                	andi	a4,a4,15
    80002c32:	071a                	slli	a4,a4,0x6
    80002c34:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002c36:	04449703          	lh	a4,68(s1)
    80002c3a:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002c3e:	04649703          	lh	a4,70(s1)
    80002c42:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002c46:	04849703          	lh	a4,72(s1)
    80002c4a:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002c4e:	04a49703          	lh	a4,74(s1)
    80002c52:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002c56:	44f8                	lw	a4,76(s1)
    80002c58:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002c5a:	03400613          	li	a2,52
    80002c5e:	05048593          	addi	a1,s1,80
    80002c62:	00c78513          	addi	a0,a5,12
    80002c66:	ffffd097          	auipc	ra,0xffffd
    80002c6a:	682080e7          	jalr	1666(ra) # 800002e8 <memmove>
  log_write(bp);
    80002c6e:	854a                	mv	a0,s2
    80002c70:	00001097          	auipc	ra,0x1
    80002c74:	c2c080e7          	jalr	-980(ra) # 8000389c <log_write>
  brelse(bp);
    80002c78:	854a                	mv	a0,s2
    80002c7a:	00000097          	auipc	ra,0x0
    80002c7e:	9a6080e7          	jalr	-1626(ra) # 80002620 <brelse>
}
    80002c82:	60e2                	ld	ra,24(sp)
    80002c84:	6442                	ld	s0,16(sp)
    80002c86:	64a2                	ld	s1,8(sp)
    80002c88:	6902                	ld	s2,0(sp)
    80002c8a:	6105                	addi	sp,sp,32
    80002c8c:	8082                	ret

0000000080002c8e <idup>:
{
    80002c8e:	1101                	addi	sp,sp,-32
    80002c90:	ec06                	sd	ra,24(sp)
    80002c92:	e822                	sd	s0,16(sp)
    80002c94:	e426                	sd	s1,8(sp)
    80002c96:	1000                	addi	s0,sp,32
    80002c98:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002c9a:	00035517          	auipc	a0,0x35
    80002c9e:	8fe50513          	addi	a0,a0,-1794 # 80037598 <itable>
    80002ca2:	00003097          	auipc	ra,0x3
    80002ca6:	760080e7          	jalr	1888(ra) # 80006402 <acquire>
  ip->ref++;
    80002caa:	449c                	lw	a5,8(s1)
    80002cac:	2785                	addiw	a5,a5,1
    80002cae:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002cb0:	00035517          	auipc	a0,0x35
    80002cb4:	8e850513          	addi	a0,a0,-1816 # 80037598 <itable>
    80002cb8:	00003097          	auipc	ra,0x3
    80002cbc:	7fa080e7          	jalr	2042(ra) # 800064b2 <release>
}
    80002cc0:	8526                	mv	a0,s1
    80002cc2:	60e2                	ld	ra,24(sp)
    80002cc4:	6442                	ld	s0,16(sp)
    80002cc6:	64a2                	ld	s1,8(sp)
    80002cc8:	6105                	addi	sp,sp,32
    80002cca:	8082                	ret

0000000080002ccc <ilock>:
{
    80002ccc:	1101                	addi	sp,sp,-32
    80002cce:	ec06                	sd	ra,24(sp)
    80002cd0:	e822                	sd	s0,16(sp)
    80002cd2:	e426                	sd	s1,8(sp)
    80002cd4:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002cd6:	c10d                	beqz	a0,80002cf8 <ilock+0x2c>
    80002cd8:	84aa                	mv	s1,a0
    80002cda:	451c                	lw	a5,8(a0)
    80002cdc:	00f05e63          	blez	a5,80002cf8 <ilock+0x2c>
  acquiresleep(&ip->lock);
    80002ce0:	0541                	addi	a0,a0,16
    80002ce2:	00001097          	auipc	ra,0x1
    80002ce6:	cd8080e7          	jalr	-808(ra) # 800039ba <acquiresleep>
  if(ip->valid == 0){
    80002cea:	40bc                	lw	a5,64(s1)
    80002cec:	cf99                	beqz	a5,80002d0a <ilock+0x3e>
}
    80002cee:	60e2                	ld	ra,24(sp)
    80002cf0:	6442                	ld	s0,16(sp)
    80002cf2:	64a2                	ld	s1,8(sp)
    80002cf4:	6105                	addi	sp,sp,32
    80002cf6:	8082                	ret
    80002cf8:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80002cfa:	00005517          	auipc	a0,0x5
    80002cfe:	76650513          	addi	a0,a0,1894 # 80008460 <etext+0x460>
    80002d02:	00003097          	auipc	ra,0x3
    80002d06:	180080e7          	jalr	384(ra) # 80005e82 <panic>
    80002d0a:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002d0c:	40dc                	lw	a5,4(s1)
    80002d0e:	0047d79b          	srliw	a5,a5,0x4
    80002d12:	00035597          	auipc	a1,0x35
    80002d16:	87e5a583          	lw	a1,-1922(a1) # 80037590 <sb+0x18>
    80002d1a:	9dbd                	addw	a1,a1,a5
    80002d1c:	4088                	lw	a0,0(s1)
    80002d1e:	fffff097          	auipc	ra,0xfffff
    80002d22:	7d2080e7          	jalr	2002(ra) # 800024f0 <bread>
    80002d26:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002d28:	05850593          	addi	a1,a0,88
    80002d2c:	40dc                	lw	a5,4(s1)
    80002d2e:	8bbd                	andi	a5,a5,15
    80002d30:	079a                	slli	a5,a5,0x6
    80002d32:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002d34:	00059783          	lh	a5,0(a1)
    80002d38:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002d3c:	00259783          	lh	a5,2(a1)
    80002d40:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002d44:	00459783          	lh	a5,4(a1)
    80002d48:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002d4c:	00659783          	lh	a5,6(a1)
    80002d50:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002d54:	459c                	lw	a5,8(a1)
    80002d56:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002d58:	03400613          	li	a2,52
    80002d5c:	05b1                	addi	a1,a1,12
    80002d5e:	05048513          	addi	a0,s1,80
    80002d62:	ffffd097          	auipc	ra,0xffffd
    80002d66:	586080e7          	jalr	1414(ra) # 800002e8 <memmove>
    brelse(bp);
    80002d6a:	854a                	mv	a0,s2
    80002d6c:	00000097          	auipc	ra,0x0
    80002d70:	8b4080e7          	jalr	-1868(ra) # 80002620 <brelse>
    ip->valid = 1;
    80002d74:	4785                	li	a5,1
    80002d76:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002d78:	04449783          	lh	a5,68(s1)
    80002d7c:	c399                	beqz	a5,80002d82 <ilock+0xb6>
    80002d7e:	6902                	ld	s2,0(sp)
    80002d80:	b7bd                	j	80002cee <ilock+0x22>
      panic("ilock: no type");
    80002d82:	00005517          	auipc	a0,0x5
    80002d86:	6e650513          	addi	a0,a0,1766 # 80008468 <etext+0x468>
    80002d8a:	00003097          	auipc	ra,0x3
    80002d8e:	0f8080e7          	jalr	248(ra) # 80005e82 <panic>

0000000080002d92 <iunlock>:
{
    80002d92:	1101                	addi	sp,sp,-32
    80002d94:	ec06                	sd	ra,24(sp)
    80002d96:	e822                	sd	s0,16(sp)
    80002d98:	e426                	sd	s1,8(sp)
    80002d9a:	e04a                	sd	s2,0(sp)
    80002d9c:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002d9e:	c905                	beqz	a0,80002dce <iunlock+0x3c>
    80002da0:	84aa                	mv	s1,a0
    80002da2:	01050913          	addi	s2,a0,16
    80002da6:	854a                	mv	a0,s2
    80002da8:	00001097          	auipc	ra,0x1
    80002dac:	cac080e7          	jalr	-852(ra) # 80003a54 <holdingsleep>
    80002db0:	cd19                	beqz	a0,80002dce <iunlock+0x3c>
    80002db2:	449c                	lw	a5,8(s1)
    80002db4:	00f05d63          	blez	a5,80002dce <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002db8:	854a                	mv	a0,s2
    80002dba:	00001097          	auipc	ra,0x1
    80002dbe:	c56080e7          	jalr	-938(ra) # 80003a10 <releasesleep>
}
    80002dc2:	60e2                	ld	ra,24(sp)
    80002dc4:	6442                	ld	s0,16(sp)
    80002dc6:	64a2                	ld	s1,8(sp)
    80002dc8:	6902                	ld	s2,0(sp)
    80002dca:	6105                	addi	sp,sp,32
    80002dcc:	8082                	ret
    panic("iunlock");
    80002dce:	00005517          	auipc	a0,0x5
    80002dd2:	6aa50513          	addi	a0,a0,1706 # 80008478 <etext+0x478>
    80002dd6:	00003097          	auipc	ra,0x3
    80002dda:	0ac080e7          	jalr	172(ra) # 80005e82 <panic>

0000000080002dde <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002dde:	7179                	addi	sp,sp,-48
    80002de0:	f406                	sd	ra,40(sp)
    80002de2:	f022                	sd	s0,32(sp)
    80002de4:	ec26                	sd	s1,24(sp)
    80002de6:	e84a                	sd	s2,16(sp)
    80002de8:	e44e                	sd	s3,8(sp)
    80002dea:	1800                	addi	s0,sp,48
    80002dec:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002dee:	05050493          	addi	s1,a0,80
    80002df2:	08050913          	addi	s2,a0,128
    80002df6:	a021                	j	80002dfe <itrunc+0x20>
    80002df8:	0491                	addi	s1,s1,4
    80002dfa:	01248d63          	beq	s1,s2,80002e14 <itrunc+0x36>
    if(ip->addrs[i]){
    80002dfe:	408c                	lw	a1,0(s1)
    80002e00:	dde5                	beqz	a1,80002df8 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80002e02:	0009a503          	lw	a0,0(s3)
    80002e06:	00000097          	auipc	ra,0x0
    80002e0a:	92a080e7          	jalr	-1750(ra) # 80002730 <bfree>
      ip->addrs[i] = 0;
    80002e0e:	0004a023          	sw	zero,0(s1)
    80002e12:	b7dd                	j	80002df8 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002e14:	0809a583          	lw	a1,128(s3)
    80002e18:	ed99                	bnez	a1,80002e36 <itrunc+0x58>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002e1a:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002e1e:	854e                	mv	a0,s3
    80002e20:	00000097          	auipc	ra,0x0
    80002e24:	de0080e7          	jalr	-544(ra) # 80002c00 <iupdate>
}
    80002e28:	70a2                	ld	ra,40(sp)
    80002e2a:	7402                	ld	s0,32(sp)
    80002e2c:	64e2                	ld	s1,24(sp)
    80002e2e:	6942                	ld	s2,16(sp)
    80002e30:	69a2                	ld	s3,8(sp)
    80002e32:	6145                	addi	sp,sp,48
    80002e34:	8082                	ret
    80002e36:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002e38:	0009a503          	lw	a0,0(s3)
    80002e3c:	fffff097          	auipc	ra,0xfffff
    80002e40:	6b4080e7          	jalr	1716(ra) # 800024f0 <bread>
    80002e44:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002e46:	05850493          	addi	s1,a0,88
    80002e4a:	45850913          	addi	s2,a0,1112
    80002e4e:	a021                	j	80002e56 <itrunc+0x78>
    80002e50:	0491                	addi	s1,s1,4
    80002e52:	01248b63          	beq	s1,s2,80002e68 <itrunc+0x8a>
      if(a[j])
    80002e56:	408c                	lw	a1,0(s1)
    80002e58:	dde5                	beqz	a1,80002e50 <itrunc+0x72>
        bfree(ip->dev, a[j]);
    80002e5a:	0009a503          	lw	a0,0(s3)
    80002e5e:	00000097          	auipc	ra,0x0
    80002e62:	8d2080e7          	jalr	-1838(ra) # 80002730 <bfree>
    80002e66:	b7ed                	j	80002e50 <itrunc+0x72>
    brelse(bp);
    80002e68:	8552                	mv	a0,s4
    80002e6a:	fffff097          	auipc	ra,0xfffff
    80002e6e:	7b6080e7          	jalr	1974(ra) # 80002620 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002e72:	0809a583          	lw	a1,128(s3)
    80002e76:	0009a503          	lw	a0,0(s3)
    80002e7a:	00000097          	auipc	ra,0x0
    80002e7e:	8b6080e7          	jalr	-1866(ra) # 80002730 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002e82:	0809a023          	sw	zero,128(s3)
    80002e86:	6a02                	ld	s4,0(sp)
    80002e88:	bf49                	j	80002e1a <itrunc+0x3c>

0000000080002e8a <iput>:
{
    80002e8a:	1101                	addi	sp,sp,-32
    80002e8c:	ec06                	sd	ra,24(sp)
    80002e8e:	e822                	sd	s0,16(sp)
    80002e90:	e426                	sd	s1,8(sp)
    80002e92:	1000                	addi	s0,sp,32
    80002e94:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002e96:	00034517          	auipc	a0,0x34
    80002e9a:	70250513          	addi	a0,a0,1794 # 80037598 <itable>
    80002e9e:	00003097          	auipc	ra,0x3
    80002ea2:	564080e7          	jalr	1380(ra) # 80006402 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002ea6:	4498                	lw	a4,8(s1)
    80002ea8:	4785                	li	a5,1
    80002eaa:	02f70263          	beq	a4,a5,80002ece <iput+0x44>
  ip->ref--;
    80002eae:	449c                	lw	a5,8(s1)
    80002eb0:	37fd                	addiw	a5,a5,-1
    80002eb2:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002eb4:	00034517          	auipc	a0,0x34
    80002eb8:	6e450513          	addi	a0,a0,1764 # 80037598 <itable>
    80002ebc:	00003097          	auipc	ra,0x3
    80002ec0:	5f6080e7          	jalr	1526(ra) # 800064b2 <release>
}
    80002ec4:	60e2                	ld	ra,24(sp)
    80002ec6:	6442                	ld	s0,16(sp)
    80002ec8:	64a2                	ld	s1,8(sp)
    80002eca:	6105                	addi	sp,sp,32
    80002ecc:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002ece:	40bc                	lw	a5,64(s1)
    80002ed0:	dff9                	beqz	a5,80002eae <iput+0x24>
    80002ed2:	04a49783          	lh	a5,74(s1)
    80002ed6:	ffe1                	bnez	a5,80002eae <iput+0x24>
    80002ed8:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80002eda:	01048913          	addi	s2,s1,16
    80002ede:	854a                	mv	a0,s2
    80002ee0:	00001097          	auipc	ra,0x1
    80002ee4:	ada080e7          	jalr	-1318(ra) # 800039ba <acquiresleep>
    release(&itable.lock);
    80002ee8:	00034517          	auipc	a0,0x34
    80002eec:	6b050513          	addi	a0,a0,1712 # 80037598 <itable>
    80002ef0:	00003097          	auipc	ra,0x3
    80002ef4:	5c2080e7          	jalr	1474(ra) # 800064b2 <release>
    itrunc(ip);
    80002ef8:	8526                	mv	a0,s1
    80002efa:	00000097          	auipc	ra,0x0
    80002efe:	ee4080e7          	jalr	-284(ra) # 80002dde <itrunc>
    ip->type = 0;
    80002f02:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002f06:	8526                	mv	a0,s1
    80002f08:	00000097          	auipc	ra,0x0
    80002f0c:	cf8080e7          	jalr	-776(ra) # 80002c00 <iupdate>
    ip->valid = 0;
    80002f10:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002f14:	854a                	mv	a0,s2
    80002f16:	00001097          	auipc	ra,0x1
    80002f1a:	afa080e7          	jalr	-1286(ra) # 80003a10 <releasesleep>
    acquire(&itable.lock);
    80002f1e:	00034517          	auipc	a0,0x34
    80002f22:	67a50513          	addi	a0,a0,1658 # 80037598 <itable>
    80002f26:	00003097          	auipc	ra,0x3
    80002f2a:	4dc080e7          	jalr	1244(ra) # 80006402 <acquire>
    80002f2e:	6902                	ld	s2,0(sp)
    80002f30:	bfbd                	j	80002eae <iput+0x24>

0000000080002f32 <iunlockput>:
{
    80002f32:	1101                	addi	sp,sp,-32
    80002f34:	ec06                	sd	ra,24(sp)
    80002f36:	e822                	sd	s0,16(sp)
    80002f38:	e426                	sd	s1,8(sp)
    80002f3a:	1000                	addi	s0,sp,32
    80002f3c:	84aa                	mv	s1,a0
  iunlock(ip);
    80002f3e:	00000097          	auipc	ra,0x0
    80002f42:	e54080e7          	jalr	-428(ra) # 80002d92 <iunlock>
  iput(ip);
    80002f46:	8526                	mv	a0,s1
    80002f48:	00000097          	auipc	ra,0x0
    80002f4c:	f42080e7          	jalr	-190(ra) # 80002e8a <iput>
}
    80002f50:	60e2                	ld	ra,24(sp)
    80002f52:	6442                	ld	s0,16(sp)
    80002f54:	64a2                	ld	s1,8(sp)
    80002f56:	6105                	addi	sp,sp,32
    80002f58:	8082                	ret

0000000080002f5a <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002f5a:	1141                	addi	sp,sp,-16
    80002f5c:	e406                	sd	ra,8(sp)
    80002f5e:	e022                	sd	s0,0(sp)
    80002f60:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002f62:	411c                	lw	a5,0(a0)
    80002f64:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002f66:	415c                	lw	a5,4(a0)
    80002f68:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002f6a:	04451783          	lh	a5,68(a0)
    80002f6e:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002f72:	04a51783          	lh	a5,74(a0)
    80002f76:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002f7a:	04c56783          	lwu	a5,76(a0)
    80002f7e:	e99c                	sd	a5,16(a1)
}
    80002f80:	60a2                	ld	ra,8(sp)
    80002f82:	6402                	ld	s0,0(sp)
    80002f84:	0141                	addi	sp,sp,16
    80002f86:	8082                	ret

0000000080002f88 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002f88:	457c                	lw	a5,76(a0)
    80002f8a:	0ed7ea63          	bltu	a5,a3,8000307e <readi+0xf6>
{
    80002f8e:	7159                	addi	sp,sp,-112
    80002f90:	f486                	sd	ra,104(sp)
    80002f92:	f0a2                	sd	s0,96(sp)
    80002f94:	eca6                	sd	s1,88(sp)
    80002f96:	fc56                	sd	s5,56(sp)
    80002f98:	f85a                	sd	s6,48(sp)
    80002f9a:	f45e                	sd	s7,40(sp)
    80002f9c:	ec66                	sd	s9,24(sp)
    80002f9e:	1880                	addi	s0,sp,112
    80002fa0:	8baa                	mv	s7,a0
    80002fa2:	8cae                	mv	s9,a1
    80002fa4:	8ab2                	mv	s5,a2
    80002fa6:	84b6                	mv	s1,a3
    80002fa8:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002faa:	9f35                	addw	a4,a4,a3
    return 0;
    80002fac:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002fae:	0ad76763          	bltu	a4,a3,8000305c <readi+0xd4>
    80002fb2:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80002fb4:	00e7f463          	bgeu	a5,a4,80002fbc <readi+0x34>
    n = ip->size - off;
    80002fb8:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002fbc:	0a0b0f63          	beqz	s6,8000307a <readi+0xf2>
    80002fc0:	e8ca                	sd	s2,80(sp)
    80002fc2:	e0d2                	sd	s4,64(sp)
    80002fc4:	f062                	sd	s8,32(sp)
    80002fc6:	e86a                	sd	s10,16(sp)
    80002fc8:	e46e                	sd	s11,8(sp)
    80002fca:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002fcc:	40000d93          	li	s11,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002fd0:	5d7d                	li	s10,-1
    80002fd2:	a82d                	j	8000300c <readi+0x84>
    80002fd4:	020a1c13          	slli	s8,s4,0x20
    80002fd8:	020c5c13          	srli	s8,s8,0x20
    80002fdc:	05890613          	addi	a2,s2,88
    80002fe0:	86e2                	mv	a3,s8
    80002fe2:	963e                	add	a2,a2,a5
    80002fe4:	85d6                	mv	a1,s5
    80002fe6:	8566                	mv	a0,s9
    80002fe8:	fffff097          	auipc	ra,0xfffff
    80002fec:	a5e080e7          	jalr	-1442(ra) # 80001a46 <either_copyout>
    80002ff0:	05a50963          	beq	a0,s10,80003042 <readi+0xba>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002ff4:	854a                	mv	a0,s2
    80002ff6:	fffff097          	auipc	ra,0xfffff
    80002ffa:	62a080e7          	jalr	1578(ra) # 80002620 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002ffe:	013a09bb          	addw	s3,s4,s3
    80003002:	009a04bb          	addw	s1,s4,s1
    80003006:	9ae2                	add	s5,s5,s8
    80003008:	0769f363          	bgeu	s3,s6,8000306e <readi+0xe6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    8000300c:	000ba903          	lw	s2,0(s7)
    80003010:	00a4d59b          	srliw	a1,s1,0xa
    80003014:	855e                	mv	a0,s7
    80003016:	00000097          	auipc	ra,0x0
    8000301a:	8b8080e7          	jalr	-1864(ra) # 800028ce <bmap>
    8000301e:	85aa                	mv	a1,a0
    80003020:	854a                	mv	a0,s2
    80003022:	fffff097          	auipc	ra,0xfffff
    80003026:	4ce080e7          	jalr	1230(ra) # 800024f0 <bread>
    8000302a:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000302c:	3ff4f793          	andi	a5,s1,1023
    80003030:	40fd873b          	subw	a4,s11,a5
    80003034:	413b06bb          	subw	a3,s6,s3
    80003038:	8a3a                	mv	s4,a4
    8000303a:	f8e6fde3          	bgeu	a3,a4,80002fd4 <readi+0x4c>
    8000303e:	8a36                	mv	s4,a3
    80003040:	bf51                	j	80002fd4 <readi+0x4c>
      brelse(bp);
    80003042:	854a                	mv	a0,s2
    80003044:	fffff097          	auipc	ra,0xfffff
    80003048:	5dc080e7          	jalr	1500(ra) # 80002620 <brelse>
      tot = -1;
    8000304c:	59fd                	li	s3,-1
      break;
    8000304e:	6946                	ld	s2,80(sp)
    80003050:	6a06                	ld	s4,64(sp)
    80003052:	7c02                	ld	s8,32(sp)
    80003054:	6d42                	ld	s10,16(sp)
    80003056:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80003058:	854e                	mv	a0,s3
    8000305a:	69a6                	ld	s3,72(sp)
}
    8000305c:	70a6                	ld	ra,104(sp)
    8000305e:	7406                	ld	s0,96(sp)
    80003060:	64e6                	ld	s1,88(sp)
    80003062:	7ae2                	ld	s5,56(sp)
    80003064:	7b42                	ld	s6,48(sp)
    80003066:	7ba2                	ld	s7,40(sp)
    80003068:	6ce2                	ld	s9,24(sp)
    8000306a:	6165                	addi	sp,sp,112
    8000306c:	8082                	ret
    8000306e:	6946                	ld	s2,80(sp)
    80003070:	6a06                	ld	s4,64(sp)
    80003072:	7c02                	ld	s8,32(sp)
    80003074:	6d42                	ld	s10,16(sp)
    80003076:	6da2                	ld	s11,8(sp)
    80003078:	b7c5                	j	80003058 <readi+0xd0>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000307a:	89da                	mv	s3,s6
    8000307c:	bff1                	j	80003058 <readi+0xd0>
    return 0;
    8000307e:	4501                	li	a0,0
}
    80003080:	8082                	ret

0000000080003082 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003082:	457c                	lw	a5,76(a0)
    80003084:	10d7e963          	bltu	a5,a3,80003196 <writei+0x114>
{
    80003088:	7159                	addi	sp,sp,-112
    8000308a:	f486                	sd	ra,104(sp)
    8000308c:	f0a2                	sd	s0,96(sp)
    8000308e:	e8ca                	sd	s2,80(sp)
    80003090:	fc56                	sd	s5,56(sp)
    80003092:	f45e                	sd	s7,40(sp)
    80003094:	f062                	sd	s8,32(sp)
    80003096:	ec66                	sd	s9,24(sp)
    80003098:	1880                	addi	s0,sp,112
    8000309a:	8baa                	mv	s7,a0
    8000309c:	8cae                	mv	s9,a1
    8000309e:	8ab2                	mv	s5,a2
    800030a0:	8936                	mv	s2,a3
    800030a2:	8c3a                	mv	s8,a4
  if(off > ip->size || off + n < off)
    800030a4:	00e687bb          	addw	a5,a3,a4
    800030a8:	0ed7e963          	bltu	a5,a3,8000319a <writei+0x118>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800030ac:	00043737          	lui	a4,0x43
    800030b0:	0ef76763          	bltu	a4,a5,8000319e <writei+0x11c>
    800030b4:	e0d2                	sd	s4,64(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800030b6:	0c0c0863          	beqz	s8,80003186 <writei+0x104>
    800030ba:	eca6                	sd	s1,88(sp)
    800030bc:	e4ce                	sd	s3,72(sp)
    800030be:	f85a                	sd	s6,48(sp)
    800030c0:	e86a                	sd	s10,16(sp)
    800030c2:	e46e                	sd	s11,8(sp)
    800030c4:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    800030c6:	40000d93          	li	s11,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800030ca:	5d7d                	li	s10,-1
    800030cc:	a091                	j	80003110 <writei+0x8e>
    800030ce:	02099b13          	slli	s6,s3,0x20
    800030d2:	020b5b13          	srli	s6,s6,0x20
    800030d6:	05848513          	addi	a0,s1,88
    800030da:	86da                	mv	a3,s6
    800030dc:	8656                	mv	a2,s5
    800030de:	85e6                	mv	a1,s9
    800030e0:	953e                	add	a0,a0,a5
    800030e2:	fffff097          	auipc	ra,0xfffff
    800030e6:	9ba080e7          	jalr	-1606(ra) # 80001a9c <either_copyin>
    800030ea:	05a50e63          	beq	a0,s10,80003146 <writei+0xc4>
      brelse(bp);
      break;
    }
    log_write(bp);
    800030ee:	8526                	mv	a0,s1
    800030f0:	00000097          	auipc	ra,0x0
    800030f4:	7ac080e7          	jalr	1964(ra) # 8000389c <log_write>
    brelse(bp);
    800030f8:	8526                	mv	a0,s1
    800030fa:	fffff097          	auipc	ra,0xfffff
    800030fe:	526080e7          	jalr	1318(ra) # 80002620 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003102:	01498a3b          	addw	s4,s3,s4
    80003106:	0129893b          	addw	s2,s3,s2
    8000310a:	9ada                	add	s5,s5,s6
    8000310c:	058a7263          	bgeu	s4,s8,80003150 <writei+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003110:	000ba483          	lw	s1,0(s7)
    80003114:	00a9559b          	srliw	a1,s2,0xa
    80003118:	855e                	mv	a0,s7
    8000311a:	fffff097          	auipc	ra,0xfffff
    8000311e:	7b4080e7          	jalr	1972(ra) # 800028ce <bmap>
    80003122:	85aa                	mv	a1,a0
    80003124:	8526                	mv	a0,s1
    80003126:	fffff097          	auipc	ra,0xfffff
    8000312a:	3ca080e7          	jalr	970(ra) # 800024f0 <bread>
    8000312e:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003130:	3ff97793          	andi	a5,s2,1023
    80003134:	40fd873b          	subw	a4,s11,a5
    80003138:	414c06bb          	subw	a3,s8,s4
    8000313c:	89ba                	mv	s3,a4
    8000313e:	f8e6f8e3          	bgeu	a3,a4,800030ce <writei+0x4c>
    80003142:	89b6                	mv	s3,a3
    80003144:	b769                	j	800030ce <writei+0x4c>
      brelse(bp);
    80003146:	8526                	mv	a0,s1
    80003148:	fffff097          	auipc	ra,0xfffff
    8000314c:	4d8080e7          	jalr	1240(ra) # 80002620 <brelse>
  }

  if(off > ip->size)
    80003150:	04cba783          	lw	a5,76(s7)
    80003154:	0327fb63          	bgeu	a5,s2,8000318a <writei+0x108>
    ip->size = off;
    80003158:	052ba623          	sw	s2,76(s7)
    8000315c:	64e6                	ld	s1,88(sp)
    8000315e:	69a6                	ld	s3,72(sp)
    80003160:	7b42                	ld	s6,48(sp)
    80003162:	6d42                	ld	s10,16(sp)
    80003164:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003166:	855e                	mv	a0,s7
    80003168:	00000097          	auipc	ra,0x0
    8000316c:	a98080e7          	jalr	-1384(ra) # 80002c00 <iupdate>

  return tot;
    80003170:	8552                	mv	a0,s4
    80003172:	6a06                	ld	s4,64(sp)
}
    80003174:	70a6                	ld	ra,104(sp)
    80003176:	7406                	ld	s0,96(sp)
    80003178:	6946                	ld	s2,80(sp)
    8000317a:	7ae2                	ld	s5,56(sp)
    8000317c:	7ba2                	ld	s7,40(sp)
    8000317e:	7c02                	ld	s8,32(sp)
    80003180:	6ce2                	ld	s9,24(sp)
    80003182:	6165                	addi	sp,sp,112
    80003184:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003186:	8a62                	mv	s4,s8
    80003188:	bff9                	j	80003166 <writei+0xe4>
    8000318a:	64e6                	ld	s1,88(sp)
    8000318c:	69a6                	ld	s3,72(sp)
    8000318e:	7b42                	ld	s6,48(sp)
    80003190:	6d42                	ld	s10,16(sp)
    80003192:	6da2                	ld	s11,8(sp)
    80003194:	bfc9                	j	80003166 <writei+0xe4>
    return -1;
    80003196:	557d                	li	a0,-1
}
    80003198:	8082                	ret
    return -1;
    8000319a:	557d                	li	a0,-1
    8000319c:	bfe1                	j	80003174 <writei+0xf2>
    return -1;
    8000319e:	557d                	li	a0,-1
    800031a0:	bfd1                	j	80003174 <writei+0xf2>

00000000800031a2 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800031a2:	1141                	addi	sp,sp,-16
    800031a4:	e406                	sd	ra,8(sp)
    800031a6:	e022                	sd	s0,0(sp)
    800031a8:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800031aa:	4639                	li	a2,14
    800031ac:	ffffd097          	auipc	ra,0xffffd
    800031b0:	1b4080e7          	jalr	436(ra) # 80000360 <strncmp>
}
    800031b4:	60a2                	ld	ra,8(sp)
    800031b6:	6402                	ld	s0,0(sp)
    800031b8:	0141                	addi	sp,sp,16
    800031ba:	8082                	ret

00000000800031bc <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800031bc:	711d                	addi	sp,sp,-96
    800031be:	ec86                	sd	ra,88(sp)
    800031c0:	e8a2                	sd	s0,80(sp)
    800031c2:	e4a6                	sd	s1,72(sp)
    800031c4:	e0ca                	sd	s2,64(sp)
    800031c6:	fc4e                	sd	s3,56(sp)
    800031c8:	f852                	sd	s4,48(sp)
    800031ca:	f456                	sd	s5,40(sp)
    800031cc:	f05a                	sd	s6,32(sp)
    800031ce:	ec5e                	sd	s7,24(sp)
    800031d0:	1080                	addi	s0,sp,96
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800031d2:	04451703          	lh	a4,68(a0)
    800031d6:	4785                	li	a5,1
    800031d8:	00f71f63          	bne	a4,a5,800031f6 <dirlookup+0x3a>
    800031dc:	892a                	mv	s2,a0
    800031de:	8aae                	mv	s5,a1
    800031e0:	8bb2                	mv	s7,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800031e2:	457c                	lw	a5,76(a0)
    800031e4:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800031e6:	fa040a13          	addi	s4,s0,-96
    800031ea:	49c1                	li	s3,16
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
    800031ec:	fa240b13          	addi	s6,s0,-94
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800031f0:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800031f2:	e79d                	bnez	a5,80003220 <dirlookup+0x64>
    800031f4:	a88d                	j	80003266 <dirlookup+0xaa>
    panic("dirlookup not DIR");
    800031f6:	00005517          	auipc	a0,0x5
    800031fa:	28a50513          	addi	a0,a0,650 # 80008480 <etext+0x480>
    800031fe:	00003097          	auipc	ra,0x3
    80003202:	c84080e7          	jalr	-892(ra) # 80005e82 <panic>
      panic("dirlookup read");
    80003206:	00005517          	auipc	a0,0x5
    8000320a:	29250513          	addi	a0,a0,658 # 80008498 <etext+0x498>
    8000320e:	00003097          	auipc	ra,0x3
    80003212:	c74080e7          	jalr	-908(ra) # 80005e82 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003216:	24c1                	addiw	s1,s1,16
    80003218:	04c92783          	lw	a5,76(s2)
    8000321c:	04f4f463          	bgeu	s1,a5,80003264 <dirlookup+0xa8>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003220:	874e                	mv	a4,s3
    80003222:	86a6                	mv	a3,s1
    80003224:	8652                	mv	a2,s4
    80003226:	4581                	li	a1,0
    80003228:	854a                	mv	a0,s2
    8000322a:	00000097          	auipc	ra,0x0
    8000322e:	d5e080e7          	jalr	-674(ra) # 80002f88 <readi>
    80003232:	fd351ae3          	bne	a0,s3,80003206 <dirlookup+0x4a>
    if(de.inum == 0)
    80003236:	fa045783          	lhu	a5,-96(s0)
    8000323a:	dff1                	beqz	a5,80003216 <dirlookup+0x5a>
    if(namecmp(name, de.name) == 0){
    8000323c:	85da                	mv	a1,s6
    8000323e:	8556                	mv	a0,s5
    80003240:	00000097          	auipc	ra,0x0
    80003244:	f62080e7          	jalr	-158(ra) # 800031a2 <namecmp>
    80003248:	f579                	bnez	a0,80003216 <dirlookup+0x5a>
      if(poff)
    8000324a:	000b8463          	beqz	s7,80003252 <dirlookup+0x96>
        *poff = off;
    8000324e:	009ba023          	sw	s1,0(s7)
      return iget(dp->dev, inum);
    80003252:	fa045583          	lhu	a1,-96(s0)
    80003256:	00092503          	lw	a0,0(s2)
    8000325a:	fffff097          	auipc	ra,0xfffff
    8000325e:	742080e7          	jalr	1858(ra) # 8000299c <iget>
    80003262:	a011                	j	80003266 <dirlookup+0xaa>
  return 0;
    80003264:	4501                	li	a0,0
}
    80003266:	60e6                	ld	ra,88(sp)
    80003268:	6446                	ld	s0,80(sp)
    8000326a:	64a6                	ld	s1,72(sp)
    8000326c:	6906                	ld	s2,64(sp)
    8000326e:	79e2                	ld	s3,56(sp)
    80003270:	7a42                	ld	s4,48(sp)
    80003272:	7aa2                	ld	s5,40(sp)
    80003274:	7b02                	ld	s6,32(sp)
    80003276:	6be2                	ld	s7,24(sp)
    80003278:	6125                	addi	sp,sp,96
    8000327a:	8082                	ret

000000008000327c <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    8000327c:	711d                	addi	sp,sp,-96
    8000327e:	ec86                	sd	ra,88(sp)
    80003280:	e8a2                	sd	s0,80(sp)
    80003282:	e4a6                	sd	s1,72(sp)
    80003284:	e0ca                	sd	s2,64(sp)
    80003286:	fc4e                	sd	s3,56(sp)
    80003288:	f852                	sd	s4,48(sp)
    8000328a:	f456                	sd	s5,40(sp)
    8000328c:	f05a                	sd	s6,32(sp)
    8000328e:	ec5e                	sd	s7,24(sp)
    80003290:	e862                	sd	s8,16(sp)
    80003292:	e466                	sd	s9,8(sp)
    80003294:	e06a                	sd	s10,0(sp)
    80003296:	1080                	addi	s0,sp,96
    80003298:	84aa                	mv	s1,a0
    8000329a:	8b2e                	mv	s6,a1
    8000329c:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    8000329e:	00054703          	lbu	a4,0(a0)
    800032a2:	02f00793          	li	a5,47
    800032a6:	02f70363          	beq	a4,a5,800032cc <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800032aa:	ffffe097          	auipc	ra,0xffffe
    800032ae:	d38080e7          	jalr	-712(ra) # 80000fe2 <myproc>
    800032b2:	15053503          	ld	a0,336(a0)
    800032b6:	00000097          	auipc	ra,0x0
    800032ba:	9d8080e7          	jalr	-1576(ra) # 80002c8e <idup>
    800032be:	8a2a                	mv	s4,a0
  while(*path == '/')
    800032c0:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    800032c4:	4c35                	li	s8,13
    memmove(name, s, DIRSIZ);
    800032c6:	4cb9                	li	s9,14

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800032c8:	4b85                	li	s7,1
    800032ca:	a87d                	j	80003388 <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    800032cc:	4585                	li	a1,1
    800032ce:	852e                	mv	a0,a1
    800032d0:	fffff097          	auipc	ra,0xfffff
    800032d4:	6cc080e7          	jalr	1740(ra) # 8000299c <iget>
    800032d8:	8a2a                	mv	s4,a0
    800032da:	b7dd                	j	800032c0 <namex+0x44>
      iunlockput(ip);
    800032dc:	8552                	mv	a0,s4
    800032de:	00000097          	auipc	ra,0x0
    800032e2:	c54080e7          	jalr	-940(ra) # 80002f32 <iunlockput>
      return 0;
    800032e6:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800032e8:	8552                	mv	a0,s4
    800032ea:	60e6                	ld	ra,88(sp)
    800032ec:	6446                	ld	s0,80(sp)
    800032ee:	64a6                	ld	s1,72(sp)
    800032f0:	6906                	ld	s2,64(sp)
    800032f2:	79e2                	ld	s3,56(sp)
    800032f4:	7a42                	ld	s4,48(sp)
    800032f6:	7aa2                	ld	s5,40(sp)
    800032f8:	7b02                	ld	s6,32(sp)
    800032fa:	6be2                	ld	s7,24(sp)
    800032fc:	6c42                	ld	s8,16(sp)
    800032fe:	6ca2                	ld	s9,8(sp)
    80003300:	6d02                	ld	s10,0(sp)
    80003302:	6125                	addi	sp,sp,96
    80003304:	8082                	ret
      iunlock(ip);
    80003306:	8552                	mv	a0,s4
    80003308:	00000097          	auipc	ra,0x0
    8000330c:	a8a080e7          	jalr	-1398(ra) # 80002d92 <iunlock>
      return ip;
    80003310:	bfe1                	j	800032e8 <namex+0x6c>
      iunlockput(ip);
    80003312:	8552                	mv	a0,s4
    80003314:	00000097          	auipc	ra,0x0
    80003318:	c1e080e7          	jalr	-994(ra) # 80002f32 <iunlockput>
      return 0;
    8000331c:	8a4e                	mv	s4,s3
    8000331e:	b7e9                	j	800032e8 <namex+0x6c>
  len = path - s;
    80003320:	40998633          	sub	a2,s3,s1
    80003324:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    80003328:	09ac5863          	bge	s8,s10,800033b8 <namex+0x13c>
    memmove(name, s, DIRSIZ);
    8000332c:	8666                	mv	a2,s9
    8000332e:	85a6                	mv	a1,s1
    80003330:	8556                	mv	a0,s5
    80003332:	ffffd097          	auipc	ra,0xffffd
    80003336:	fb6080e7          	jalr	-74(ra) # 800002e8 <memmove>
    8000333a:	84ce                	mv	s1,s3
  while(*path == '/')
    8000333c:	0004c783          	lbu	a5,0(s1)
    80003340:	01279763          	bne	a5,s2,8000334e <namex+0xd2>
    path++;
    80003344:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003346:	0004c783          	lbu	a5,0(s1)
    8000334a:	ff278de3          	beq	a5,s2,80003344 <namex+0xc8>
    ilock(ip);
    8000334e:	8552                	mv	a0,s4
    80003350:	00000097          	auipc	ra,0x0
    80003354:	97c080e7          	jalr	-1668(ra) # 80002ccc <ilock>
    if(ip->type != T_DIR){
    80003358:	044a1783          	lh	a5,68(s4)
    8000335c:	f97790e3          	bne	a5,s7,800032dc <namex+0x60>
    if(nameiparent && *path == '\0'){
    80003360:	000b0563          	beqz	s6,8000336a <namex+0xee>
    80003364:	0004c783          	lbu	a5,0(s1)
    80003368:	dfd9                	beqz	a5,80003306 <namex+0x8a>
    if((next = dirlookup(ip, name, 0)) == 0){
    8000336a:	4601                	li	a2,0
    8000336c:	85d6                	mv	a1,s5
    8000336e:	8552                	mv	a0,s4
    80003370:	00000097          	auipc	ra,0x0
    80003374:	e4c080e7          	jalr	-436(ra) # 800031bc <dirlookup>
    80003378:	89aa                	mv	s3,a0
    8000337a:	dd41                	beqz	a0,80003312 <namex+0x96>
    iunlockput(ip);
    8000337c:	8552                	mv	a0,s4
    8000337e:	00000097          	auipc	ra,0x0
    80003382:	bb4080e7          	jalr	-1100(ra) # 80002f32 <iunlockput>
    ip = next;
    80003386:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003388:	0004c783          	lbu	a5,0(s1)
    8000338c:	01279763          	bne	a5,s2,8000339a <namex+0x11e>
    path++;
    80003390:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003392:	0004c783          	lbu	a5,0(s1)
    80003396:	ff278de3          	beq	a5,s2,80003390 <namex+0x114>
  if(*path == 0)
    8000339a:	cb9d                	beqz	a5,800033d0 <namex+0x154>
  while(*path != '/' && *path != 0)
    8000339c:	0004c783          	lbu	a5,0(s1)
    800033a0:	89a6                	mv	s3,s1
  len = path - s;
    800033a2:	4d01                	li	s10,0
    800033a4:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    800033a6:	01278963          	beq	a5,s2,800033b8 <namex+0x13c>
    800033aa:	dbbd                	beqz	a5,80003320 <namex+0xa4>
    path++;
    800033ac:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    800033ae:	0009c783          	lbu	a5,0(s3)
    800033b2:	ff279ce3          	bne	a5,s2,800033aa <namex+0x12e>
    800033b6:	b7ad                	j	80003320 <namex+0xa4>
    memmove(name, s, len);
    800033b8:	2601                	sext.w	a2,a2
    800033ba:	85a6                	mv	a1,s1
    800033bc:	8556                	mv	a0,s5
    800033be:	ffffd097          	auipc	ra,0xffffd
    800033c2:	f2a080e7          	jalr	-214(ra) # 800002e8 <memmove>
    name[len] = 0;
    800033c6:	9d56                	add	s10,s10,s5
    800033c8:	000d0023          	sb	zero,0(s10)
    800033cc:	84ce                	mv	s1,s3
    800033ce:	b7bd                	j	8000333c <namex+0xc0>
  if(nameiparent){
    800033d0:	f00b0ce3          	beqz	s6,800032e8 <namex+0x6c>
    iput(ip);
    800033d4:	8552                	mv	a0,s4
    800033d6:	00000097          	auipc	ra,0x0
    800033da:	ab4080e7          	jalr	-1356(ra) # 80002e8a <iput>
    return 0;
    800033de:	4a01                	li	s4,0
    800033e0:	b721                	j	800032e8 <namex+0x6c>

00000000800033e2 <dirlink>:
{
    800033e2:	715d                	addi	sp,sp,-80
    800033e4:	e486                	sd	ra,72(sp)
    800033e6:	e0a2                	sd	s0,64(sp)
    800033e8:	f84a                	sd	s2,48(sp)
    800033ea:	ec56                	sd	s5,24(sp)
    800033ec:	e85a                	sd	s6,16(sp)
    800033ee:	0880                	addi	s0,sp,80
    800033f0:	892a                	mv	s2,a0
    800033f2:	8aae                	mv	s5,a1
    800033f4:	8b32                	mv	s6,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800033f6:	4601                	li	a2,0
    800033f8:	00000097          	auipc	ra,0x0
    800033fc:	dc4080e7          	jalr	-572(ra) # 800031bc <dirlookup>
    80003400:	e129                	bnez	a0,80003442 <dirlink+0x60>
    80003402:	fc26                	sd	s1,56(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003404:	04c92483          	lw	s1,76(s2)
    80003408:	cca9                	beqz	s1,80003462 <dirlink+0x80>
    8000340a:	f44e                	sd	s3,40(sp)
    8000340c:	f052                	sd	s4,32(sp)
    8000340e:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003410:	fb040a13          	addi	s4,s0,-80
    80003414:	49c1                	li	s3,16
    80003416:	874e                	mv	a4,s3
    80003418:	86a6                	mv	a3,s1
    8000341a:	8652                	mv	a2,s4
    8000341c:	4581                	li	a1,0
    8000341e:	854a                	mv	a0,s2
    80003420:	00000097          	auipc	ra,0x0
    80003424:	b68080e7          	jalr	-1176(ra) # 80002f88 <readi>
    80003428:	03351363          	bne	a0,s3,8000344e <dirlink+0x6c>
    if(de.inum == 0)
    8000342c:	fb045783          	lhu	a5,-80(s0)
    80003430:	c79d                	beqz	a5,8000345e <dirlink+0x7c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003432:	24c1                	addiw	s1,s1,16
    80003434:	04c92783          	lw	a5,76(s2)
    80003438:	fcf4efe3          	bltu	s1,a5,80003416 <dirlink+0x34>
    8000343c:	79a2                	ld	s3,40(sp)
    8000343e:	7a02                	ld	s4,32(sp)
    80003440:	a00d                	j	80003462 <dirlink+0x80>
    iput(ip);
    80003442:	00000097          	auipc	ra,0x0
    80003446:	a48080e7          	jalr	-1464(ra) # 80002e8a <iput>
    return -1;
    8000344a:	557d                	li	a0,-1
    8000344c:	a0a9                	j	80003496 <dirlink+0xb4>
      panic("dirlink read");
    8000344e:	00005517          	auipc	a0,0x5
    80003452:	05a50513          	addi	a0,a0,90 # 800084a8 <etext+0x4a8>
    80003456:	00003097          	auipc	ra,0x3
    8000345a:	a2c080e7          	jalr	-1492(ra) # 80005e82 <panic>
    8000345e:	79a2                	ld	s3,40(sp)
    80003460:	7a02                	ld	s4,32(sp)
  strncpy(de.name, name, DIRSIZ);
    80003462:	4639                	li	a2,14
    80003464:	85d6                	mv	a1,s5
    80003466:	fb240513          	addi	a0,s0,-78
    8000346a:	ffffd097          	auipc	ra,0xffffd
    8000346e:	f30080e7          	jalr	-208(ra) # 8000039a <strncpy>
  de.inum = inum;
    80003472:	fb641823          	sh	s6,-80(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003476:	4741                	li	a4,16
    80003478:	86a6                	mv	a3,s1
    8000347a:	fb040613          	addi	a2,s0,-80
    8000347e:	4581                	li	a1,0
    80003480:	854a                	mv	a0,s2
    80003482:	00000097          	auipc	ra,0x0
    80003486:	c00080e7          	jalr	-1024(ra) # 80003082 <writei>
    8000348a:	872a                	mv	a4,a0
    8000348c:	47c1                	li	a5,16
  return 0;
    8000348e:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003490:	00f71a63          	bne	a4,a5,800034a4 <dirlink+0xc2>
    80003494:	74e2                	ld	s1,56(sp)
}
    80003496:	60a6                	ld	ra,72(sp)
    80003498:	6406                	ld	s0,64(sp)
    8000349a:	7942                	ld	s2,48(sp)
    8000349c:	6ae2                	ld	s5,24(sp)
    8000349e:	6b42                	ld	s6,16(sp)
    800034a0:	6161                	addi	sp,sp,80
    800034a2:	8082                	ret
    800034a4:	f44e                	sd	s3,40(sp)
    800034a6:	f052                	sd	s4,32(sp)
    panic("dirlink");
    800034a8:	00005517          	auipc	a0,0x5
    800034ac:	11050513          	addi	a0,a0,272 # 800085b8 <etext+0x5b8>
    800034b0:	00003097          	auipc	ra,0x3
    800034b4:	9d2080e7          	jalr	-1582(ra) # 80005e82 <panic>

00000000800034b8 <namei>:

struct inode*
namei(char *path)
{
    800034b8:	1101                	addi	sp,sp,-32
    800034ba:	ec06                	sd	ra,24(sp)
    800034bc:	e822                	sd	s0,16(sp)
    800034be:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800034c0:	fe040613          	addi	a2,s0,-32
    800034c4:	4581                	li	a1,0
    800034c6:	00000097          	auipc	ra,0x0
    800034ca:	db6080e7          	jalr	-586(ra) # 8000327c <namex>
}
    800034ce:	60e2                	ld	ra,24(sp)
    800034d0:	6442                	ld	s0,16(sp)
    800034d2:	6105                	addi	sp,sp,32
    800034d4:	8082                	ret

00000000800034d6 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800034d6:	1141                	addi	sp,sp,-16
    800034d8:	e406                	sd	ra,8(sp)
    800034da:	e022                	sd	s0,0(sp)
    800034dc:	0800                	addi	s0,sp,16
    800034de:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800034e0:	4585                	li	a1,1
    800034e2:	00000097          	auipc	ra,0x0
    800034e6:	d9a080e7          	jalr	-614(ra) # 8000327c <namex>
}
    800034ea:	60a2                	ld	ra,8(sp)
    800034ec:	6402                	ld	s0,0(sp)
    800034ee:	0141                	addi	sp,sp,16
    800034f0:	8082                	ret

00000000800034f2 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800034f2:	1101                	addi	sp,sp,-32
    800034f4:	ec06                	sd	ra,24(sp)
    800034f6:	e822                	sd	s0,16(sp)
    800034f8:	e426                	sd	s1,8(sp)
    800034fa:	e04a                	sd	s2,0(sp)
    800034fc:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800034fe:	00036917          	auipc	s2,0x36
    80003502:	b4290913          	addi	s2,s2,-1214 # 80039040 <log>
    80003506:	01892583          	lw	a1,24(s2)
    8000350a:	02892503          	lw	a0,40(s2)
    8000350e:	fffff097          	auipc	ra,0xfffff
    80003512:	fe2080e7          	jalr	-30(ra) # 800024f0 <bread>
    80003516:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003518:	02c92603          	lw	a2,44(s2)
    8000351c:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000351e:	00c05f63          	blez	a2,8000353c <write_head+0x4a>
    80003522:	00036717          	auipc	a4,0x36
    80003526:	b4e70713          	addi	a4,a4,-1202 # 80039070 <log+0x30>
    8000352a:	87aa                	mv	a5,a0
    8000352c:	060a                	slli	a2,a2,0x2
    8000352e:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003530:	4314                	lw	a3,0(a4)
    80003532:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003534:	0711                	addi	a4,a4,4
    80003536:	0791                	addi	a5,a5,4
    80003538:	fec79ce3          	bne	a5,a2,80003530 <write_head+0x3e>
  }
  bwrite(buf);
    8000353c:	8526                	mv	a0,s1
    8000353e:	fffff097          	auipc	ra,0xfffff
    80003542:	0a4080e7          	jalr	164(ra) # 800025e2 <bwrite>
  brelse(buf);
    80003546:	8526                	mv	a0,s1
    80003548:	fffff097          	auipc	ra,0xfffff
    8000354c:	0d8080e7          	jalr	216(ra) # 80002620 <brelse>
}
    80003550:	60e2                	ld	ra,24(sp)
    80003552:	6442                	ld	s0,16(sp)
    80003554:	64a2                	ld	s1,8(sp)
    80003556:	6902                	ld	s2,0(sp)
    80003558:	6105                	addi	sp,sp,32
    8000355a:	8082                	ret

000000008000355c <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000355c:	00036797          	auipc	a5,0x36
    80003560:	b107a783          	lw	a5,-1264(a5) # 8003906c <log+0x2c>
    80003564:	0cf05063          	blez	a5,80003624 <install_trans+0xc8>
{
    80003568:	715d                	addi	sp,sp,-80
    8000356a:	e486                	sd	ra,72(sp)
    8000356c:	e0a2                	sd	s0,64(sp)
    8000356e:	fc26                	sd	s1,56(sp)
    80003570:	f84a                	sd	s2,48(sp)
    80003572:	f44e                	sd	s3,40(sp)
    80003574:	f052                	sd	s4,32(sp)
    80003576:	ec56                	sd	s5,24(sp)
    80003578:	e85a                	sd	s6,16(sp)
    8000357a:	e45e                	sd	s7,8(sp)
    8000357c:	0880                	addi	s0,sp,80
    8000357e:	8b2a                	mv	s6,a0
    80003580:	00036a97          	auipc	s5,0x36
    80003584:	af0a8a93          	addi	s5,s5,-1296 # 80039070 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003588:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000358a:	00036997          	auipc	s3,0x36
    8000358e:	ab698993          	addi	s3,s3,-1354 # 80039040 <log>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003592:	40000b93          	li	s7,1024
    80003596:	a00d                	j	800035b8 <install_trans+0x5c>
    brelse(lbuf);
    80003598:	854a                	mv	a0,s2
    8000359a:	fffff097          	auipc	ra,0xfffff
    8000359e:	086080e7          	jalr	134(ra) # 80002620 <brelse>
    brelse(dbuf);
    800035a2:	8526                	mv	a0,s1
    800035a4:	fffff097          	auipc	ra,0xfffff
    800035a8:	07c080e7          	jalr	124(ra) # 80002620 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800035ac:	2a05                	addiw	s4,s4,1
    800035ae:	0a91                	addi	s5,s5,4
    800035b0:	02c9a783          	lw	a5,44(s3)
    800035b4:	04fa5d63          	bge	s4,a5,8000360e <install_trans+0xb2>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800035b8:	0189a583          	lw	a1,24(s3)
    800035bc:	014585bb          	addw	a1,a1,s4
    800035c0:	2585                	addiw	a1,a1,1
    800035c2:	0289a503          	lw	a0,40(s3)
    800035c6:	fffff097          	auipc	ra,0xfffff
    800035ca:	f2a080e7          	jalr	-214(ra) # 800024f0 <bread>
    800035ce:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800035d0:	000aa583          	lw	a1,0(s5)
    800035d4:	0289a503          	lw	a0,40(s3)
    800035d8:	fffff097          	auipc	ra,0xfffff
    800035dc:	f18080e7          	jalr	-232(ra) # 800024f0 <bread>
    800035e0:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800035e2:	865e                	mv	a2,s7
    800035e4:	05890593          	addi	a1,s2,88
    800035e8:	05850513          	addi	a0,a0,88
    800035ec:	ffffd097          	auipc	ra,0xffffd
    800035f0:	cfc080e7          	jalr	-772(ra) # 800002e8 <memmove>
    bwrite(dbuf);  // write dst to disk
    800035f4:	8526                	mv	a0,s1
    800035f6:	fffff097          	auipc	ra,0xfffff
    800035fa:	fec080e7          	jalr	-20(ra) # 800025e2 <bwrite>
    if(recovering == 0)
    800035fe:	f80b1de3          	bnez	s6,80003598 <install_trans+0x3c>
      bunpin(dbuf);
    80003602:	8526                	mv	a0,s1
    80003604:	fffff097          	auipc	ra,0xfffff
    80003608:	0f0080e7          	jalr	240(ra) # 800026f4 <bunpin>
    8000360c:	b771                	j	80003598 <install_trans+0x3c>
}
    8000360e:	60a6                	ld	ra,72(sp)
    80003610:	6406                	ld	s0,64(sp)
    80003612:	74e2                	ld	s1,56(sp)
    80003614:	7942                	ld	s2,48(sp)
    80003616:	79a2                	ld	s3,40(sp)
    80003618:	7a02                	ld	s4,32(sp)
    8000361a:	6ae2                	ld	s5,24(sp)
    8000361c:	6b42                	ld	s6,16(sp)
    8000361e:	6ba2                	ld	s7,8(sp)
    80003620:	6161                	addi	sp,sp,80
    80003622:	8082                	ret
    80003624:	8082                	ret

0000000080003626 <initlog>:
{
    80003626:	7179                	addi	sp,sp,-48
    80003628:	f406                	sd	ra,40(sp)
    8000362a:	f022                	sd	s0,32(sp)
    8000362c:	ec26                	sd	s1,24(sp)
    8000362e:	e84a                	sd	s2,16(sp)
    80003630:	e44e                	sd	s3,8(sp)
    80003632:	1800                	addi	s0,sp,48
    80003634:	892a                	mv	s2,a0
    80003636:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003638:	00036497          	auipc	s1,0x36
    8000363c:	a0848493          	addi	s1,s1,-1528 # 80039040 <log>
    80003640:	00005597          	auipc	a1,0x5
    80003644:	e7858593          	addi	a1,a1,-392 # 800084b8 <etext+0x4b8>
    80003648:	8526                	mv	a0,s1
    8000364a:	00003097          	auipc	ra,0x3
    8000364e:	d24080e7          	jalr	-732(ra) # 8000636e <initlock>
  log.start = sb->logstart;
    80003652:	0149a583          	lw	a1,20(s3)
    80003656:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003658:	0109a783          	lw	a5,16(s3)
    8000365c:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    8000365e:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003662:	854a                	mv	a0,s2
    80003664:	fffff097          	auipc	ra,0xfffff
    80003668:	e8c080e7          	jalr	-372(ra) # 800024f0 <bread>
  log.lh.n = lh->n;
    8000366c:	4d30                	lw	a2,88(a0)
    8000366e:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003670:	00c05f63          	blez	a2,8000368e <initlog+0x68>
    80003674:	87aa                	mv	a5,a0
    80003676:	00036717          	auipc	a4,0x36
    8000367a:	9fa70713          	addi	a4,a4,-1542 # 80039070 <log+0x30>
    8000367e:	060a                	slli	a2,a2,0x2
    80003680:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003682:	4ff4                	lw	a3,92(a5)
    80003684:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003686:	0791                	addi	a5,a5,4
    80003688:	0711                	addi	a4,a4,4
    8000368a:	fec79ce3          	bne	a5,a2,80003682 <initlog+0x5c>
  brelse(buf);
    8000368e:	fffff097          	auipc	ra,0xfffff
    80003692:	f92080e7          	jalr	-110(ra) # 80002620 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003696:	4505                	li	a0,1
    80003698:	00000097          	auipc	ra,0x0
    8000369c:	ec4080e7          	jalr	-316(ra) # 8000355c <install_trans>
  log.lh.n = 0;
    800036a0:	00036797          	auipc	a5,0x36
    800036a4:	9c07a623          	sw	zero,-1588(a5) # 8003906c <log+0x2c>
  write_head(); // clear the log
    800036a8:	00000097          	auipc	ra,0x0
    800036ac:	e4a080e7          	jalr	-438(ra) # 800034f2 <write_head>
}
    800036b0:	70a2                	ld	ra,40(sp)
    800036b2:	7402                	ld	s0,32(sp)
    800036b4:	64e2                	ld	s1,24(sp)
    800036b6:	6942                	ld	s2,16(sp)
    800036b8:	69a2                	ld	s3,8(sp)
    800036ba:	6145                	addi	sp,sp,48
    800036bc:	8082                	ret

00000000800036be <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800036be:	1101                	addi	sp,sp,-32
    800036c0:	ec06                	sd	ra,24(sp)
    800036c2:	e822                	sd	s0,16(sp)
    800036c4:	e426                	sd	s1,8(sp)
    800036c6:	e04a                	sd	s2,0(sp)
    800036c8:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800036ca:	00036517          	auipc	a0,0x36
    800036ce:	97650513          	addi	a0,a0,-1674 # 80039040 <log>
    800036d2:	00003097          	auipc	ra,0x3
    800036d6:	d30080e7          	jalr	-720(ra) # 80006402 <acquire>
  while(1){
    if(log.committing){
    800036da:	00036497          	auipc	s1,0x36
    800036de:	96648493          	addi	s1,s1,-1690 # 80039040 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800036e2:	4979                	li	s2,30
    800036e4:	a039                	j	800036f2 <begin_op+0x34>
      sleep(&log, &log.lock);
    800036e6:	85a6                	mv	a1,s1
    800036e8:	8526                	mv	a0,s1
    800036ea:	ffffe097          	auipc	ra,0xffffe
    800036ee:	fbe080e7          	jalr	-66(ra) # 800016a8 <sleep>
    if(log.committing){
    800036f2:	50dc                	lw	a5,36(s1)
    800036f4:	fbed                	bnez	a5,800036e6 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800036f6:	5098                	lw	a4,32(s1)
    800036f8:	2705                	addiw	a4,a4,1
    800036fa:	0027179b          	slliw	a5,a4,0x2
    800036fe:	9fb9                	addw	a5,a5,a4
    80003700:	0017979b          	slliw	a5,a5,0x1
    80003704:	54d4                	lw	a3,44(s1)
    80003706:	9fb5                	addw	a5,a5,a3
    80003708:	00f95963          	bge	s2,a5,8000371a <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000370c:	85a6                	mv	a1,s1
    8000370e:	8526                	mv	a0,s1
    80003710:	ffffe097          	auipc	ra,0xffffe
    80003714:	f98080e7          	jalr	-104(ra) # 800016a8 <sleep>
    80003718:	bfe9                	j	800036f2 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    8000371a:	00036517          	auipc	a0,0x36
    8000371e:	92650513          	addi	a0,a0,-1754 # 80039040 <log>
    80003722:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80003724:	00003097          	auipc	ra,0x3
    80003728:	d8e080e7          	jalr	-626(ra) # 800064b2 <release>
      break;
    }
  }
}
    8000372c:	60e2                	ld	ra,24(sp)
    8000372e:	6442                	ld	s0,16(sp)
    80003730:	64a2                	ld	s1,8(sp)
    80003732:	6902                	ld	s2,0(sp)
    80003734:	6105                	addi	sp,sp,32
    80003736:	8082                	ret

0000000080003738 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003738:	7139                	addi	sp,sp,-64
    8000373a:	fc06                	sd	ra,56(sp)
    8000373c:	f822                	sd	s0,48(sp)
    8000373e:	f426                	sd	s1,40(sp)
    80003740:	f04a                	sd	s2,32(sp)
    80003742:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003744:	00036497          	auipc	s1,0x36
    80003748:	8fc48493          	addi	s1,s1,-1796 # 80039040 <log>
    8000374c:	8526                	mv	a0,s1
    8000374e:	00003097          	auipc	ra,0x3
    80003752:	cb4080e7          	jalr	-844(ra) # 80006402 <acquire>
  log.outstanding -= 1;
    80003756:	509c                	lw	a5,32(s1)
    80003758:	37fd                	addiw	a5,a5,-1
    8000375a:	893e                	mv	s2,a5
    8000375c:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000375e:	50dc                	lw	a5,36(s1)
    80003760:	e7b9                	bnez	a5,800037ae <end_op+0x76>
    panic("log.committing");
  if(log.outstanding == 0){
    80003762:	06091263          	bnez	s2,800037c6 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80003766:	00036497          	auipc	s1,0x36
    8000376a:	8da48493          	addi	s1,s1,-1830 # 80039040 <log>
    8000376e:	4785                	li	a5,1
    80003770:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003772:	8526                	mv	a0,s1
    80003774:	00003097          	auipc	ra,0x3
    80003778:	d3e080e7          	jalr	-706(ra) # 800064b2 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000377c:	54dc                	lw	a5,44(s1)
    8000377e:	06f04863          	bgtz	a5,800037ee <end_op+0xb6>
    acquire(&log.lock);
    80003782:	00036497          	auipc	s1,0x36
    80003786:	8be48493          	addi	s1,s1,-1858 # 80039040 <log>
    8000378a:	8526                	mv	a0,s1
    8000378c:	00003097          	auipc	ra,0x3
    80003790:	c76080e7          	jalr	-906(ra) # 80006402 <acquire>
    log.committing = 0;
    80003794:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003798:	8526                	mv	a0,s1
    8000379a:	ffffe097          	auipc	ra,0xffffe
    8000379e:	094080e7          	jalr	148(ra) # 8000182e <wakeup>
    release(&log.lock);
    800037a2:	8526                	mv	a0,s1
    800037a4:	00003097          	auipc	ra,0x3
    800037a8:	d0e080e7          	jalr	-754(ra) # 800064b2 <release>
}
    800037ac:	a81d                	j	800037e2 <end_op+0xaa>
    800037ae:	ec4e                	sd	s3,24(sp)
    800037b0:	e852                	sd	s4,16(sp)
    800037b2:	e456                	sd	s5,8(sp)
    800037b4:	e05a                	sd	s6,0(sp)
    panic("log.committing");
    800037b6:	00005517          	auipc	a0,0x5
    800037ba:	d0a50513          	addi	a0,a0,-758 # 800084c0 <etext+0x4c0>
    800037be:	00002097          	auipc	ra,0x2
    800037c2:	6c4080e7          	jalr	1732(ra) # 80005e82 <panic>
    wakeup(&log);
    800037c6:	00036497          	auipc	s1,0x36
    800037ca:	87a48493          	addi	s1,s1,-1926 # 80039040 <log>
    800037ce:	8526                	mv	a0,s1
    800037d0:	ffffe097          	auipc	ra,0xffffe
    800037d4:	05e080e7          	jalr	94(ra) # 8000182e <wakeup>
  release(&log.lock);
    800037d8:	8526                	mv	a0,s1
    800037da:	00003097          	auipc	ra,0x3
    800037de:	cd8080e7          	jalr	-808(ra) # 800064b2 <release>
}
    800037e2:	70e2                	ld	ra,56(sp)
    800037e4:	7442                	ld	s0,48(sp)
    800037e6:	74a2                	ld	s1,40(sp)
    800037e8:	7902                	ld	s2,32(sp)
    800037ea:	6121                	addi	sp,sp,64
    800037ec:	8082                	ret
    800037ee:	ec4e                	sd	s3,24(sp)
    800037f0:	e852                	sd	s4,16(sp)
    800037f2:	e456                	sd	s5,8(sp)
    800037f4:	e05a                	sd	s6,0(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    800037f6:	00036a97          	auipc	s5,0x36
    800037fa:	87aa8a93          	addi	s5,s5,-1926 # 80039070 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800037fe:	00036a17          	auipc	s4,0x36
    80003802:	842a0a13          	addi	s4,s4,-1982 # 80039040 <log>
    memmove(to->data, from->data, BSIZE);
    80003806:	40000b13          	li	s6,1024
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    8000380a:	018a2583          	lw	a1,24(s4)
    8000380e:	012585bb          	addw	a1,a1,s2
    80003812:	2585                	addiw	a1,a1,1
    80003814:	028a2503          	lw	a0,40(s4)
    80003818:	fffff097          	auipc	ra,0xfffff
    8000381c:	cd8080e7          	jalr	-808(ra) # 800024f0 <bread>
    80003820:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003822:	000aa583          	lw	a1,0(s5)
    80003826:	028a2503          	lw	a0,40(s4)
    8000382a:	fffff097          	auipc	ra,0xfffff
    8000382e:	cc6080e7          	jalr	-826(ra) # 800024f0 <bread>
    80003832:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003834:	865a                	mv	a2,s6
    80003836:	05850593          	addi	a1,a0,88
    8000383a:	05848513          	addi	a0,s1,88
    8000383e:	ffffd097          	auipc	ra,0xffffd
    80003842:	aaa080e7          	jalr	-1366(ra) # 800002e8 <memmove>
    bwrite(to);  // write the log
    80003846:	8526                	mv	a0,s1
    80003848:	fffff097          	auipc	ra,0xfffff
    8000384c:	d9a080e7          	jalr	-614(ra) # 800025e2 <bwrite>
    brelse(from);
    80003850:	854e                	mv	a0,s3
    80003852:	fffff097          	auipc	ra,0xfffff
    80003856:	dce080e7          	jalr	-562(ra) # 80002620 <brelse>
    brelse(to);
    8000385a:	8526                	mv	a0,s1
    8000385c:	fffff097          	auipc	ra,0xfffff
    80003860:	dc4080e7          	jalr	-572(ra) # 80002620 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003864:	2905                	addiw	s2,s2,1
    80003866:	0a91                	addi	s5,s5,4
    80003868:	02ca2783          	lw	a5,44(s4)
    8000386c:	f8f94fe3          	blt	s2,a5,8000380a <end_op+0xd2>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003870:	00000097          	auipc	ra,0x0
    80003874:	c82080e7          	jalr	-894(ra) # 800034f2 <write_head>
    install_trans(0); // Now install writes to home locations
    80003878:	4501                	li	a0,0
    8000387a:	00000097          	auipc	ra,0x0
    8000387e:	ce2080e7          	jalr	-798(ra) # 8000355c <install_trans>
    log.lh.n = 0;
    80003882:	00035797          	auipc	a5,0x35
    80003886:	7e07a523          	sw	zero,2026(a5) # 8003906c <log+0x2c>
    write_head();    // Erase the transaction from the log
    8000388a:	00000097          	auipc	ra,0x0
    8000388e:	c68080e7          	jalr	-920(ra) # 800034f2 <write_head>
    80003892:	69e2                	ld	s3,24(sp)
    80003894:	6a42                	ld	s4,16(sp)
    80003896:	6aa2                	ld	s5,8(sp)
    80003898:	6b02                	ld	s6,0(sp)
    8000389a:	b5e5                	j	80003782 <end_op+0x4a>

000000008000389c <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000389c:	1101                	addi	sp,sp,-32
    8000389e:	ec06                	sd	ra,24(sp)
    800038a0:	e822                	sd	s0,16(sp)
    800038a2:	e426                	sd	s1,8(sp)
    800038a4:	e04a                	sd	s2,0(sp)
    800038a6:	1000                	addi	s0,sp,32
    800038a8:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800038aa:	00035917          	auipc	s2,0x35
    800038ae:	79690913          	addi	s2,s2,1942 # 80039040 <log>
    800038b2:	854a                	mv	a0,s2
    800038b4:	00003097          	auipc	ra,0x3
    800038b8:	b4e080e7          	jalr	-1202(ra) # 80006402 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800038bc:	02c92603          	lw	a2,44(s2)
    800038c0:	47f5                	li	a5,29
    800038c2:	06c7c563          	blt	a5,a2,8000392c <log_write+0x90>
    800038c6:	00035797          	auipc	a5,0x35
    800038ca:	7967a783          	lw	a5,1942(a5) # 8003905c <log+0x1c>
    800038ce:	37fd                	addiw	a5,a5,-1
    800038d0:	04f65e63          	bge	a2,a5,8000392c <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800038d4:	00035797          	auipc	a5,0x35
    800038d8:	78c7a783          	lw	a5,1932(a5) # 80039060 <log+0x20>
    800038dc:	06f05063          	blez	a5,8000393c <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800038e0:	4781                	li	a5,0
    800038e2:	06c05563          	blez	a2,8000394c <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800038e6:	44cc                	lw	a1,12(s1)
    800038e8:	00035717          	auipc	a4,0x35
    800038ec:	78870713          	addi	a4,a4,1928 # 80039070 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800038f0:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800038f2:	4314                	lw	a3,0(a4)
    800038f4:	04b68c63          	beq	a3,a1,8000394c <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800038f8:	2785                	addiw	a5,a5,1
    800038fa:	0711                	addi	a4,a4,4
    800038fc:	fef61be3          	bne	a2,a5,800038f2 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003900:	0621                	addi	a2,a2,8
    80003902:	060a                	slli	a2,a2,0x2
    80003904:	00035797          	auipc	a5,0x35
    80003908:	73c78793          	addi	a5,a5,1852 # 80039040 <log>
    8000390c:	97b2                	add	a5,a5,a2
    8000390e:	44d8                	lw	a4,12(s1)
    80003910:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003912:	8526                	mv	a0,s1
    80003914:	fffff097          	auipc	ra,0xfffff
    80003918:	da4080e7          	jalr	-604(ra) # 800026b8 <bpin>
    log.lh.n++;
    8000391c:	00035717          	auipc	a4,0x35
    80003920:	72470713          	addi	a4,a4,1828 # 80039040 <log>
    80003924:	575c                	lw	a5,44(a4)
    80003926:	2785                	addiw	a5,a5,1
    80003928:	d75c                	sw	a5,44(a4)
    8000392a:	a82d                	j	80003964 <log_write+0xc8>
    panic("too big a transaction");
    8000392c:	00005517          	auipc	a0,0x5
    80003930:	ba450513          	addi	a0,a0,-1116 # 800084d0 <etext+0x4d0>
    80003934:	00002097          	auipc	ra,0x2
    80003938:	54e080e7          	jalr	1358(ra) # 80005e82 <panic>
    panic("log_write outside of trans");
    8000393c:	00005517          	auipc	a0,0x5
    80003940:	bac50513          	addi	a0,a0,-1108 # 800084e8 <etext+0x4e8>
    80003944:	00002097          	auipc	ra,0x2
    80003948:	53e080e7          	jalr	1342(ra) # 80005e82 <panic>
  log.lh.block[i] = b->blockno;
    8000394c:	00878693          	addi	a3,a5,8
    80003950:	068a                	slli	a3,a3,0x2
    80003952:	00035717          	auipc	a4,0x35
    80003956:	6ee70713          	addi	a4,a4,1774 # 80039040 <log>
    8000395a:	9736                	add	a4,a4,a3
    8000395c:	44d4                	lw	a3,12(s1)
    8000395e:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003960:	faf609e3          	beq	a2,a5,80003912 <log_write+0x76>
  }
  release(&log.lock);
    80003964:	00035517          	auipc	a0,0x35
    80003968:	6dc50513          	addi	a0,a0,1756 # 80039040 <log>
    8000396c:	00003097          	auipc	ra,0x3
    80003970:	b46080e7          	jalr	-1210(ra) # 800064b2 <release>
}
    80003974:	60e2                	ld	ra,24(sp)
    80003976:	6442                	ld	s0,16(sp)
    80003978:	64a2                	ld	s1,8(sp)
    8000397a:	6902                	ld	s2,0(sp)
    8000397c:	6105                	addi	sp,sp,32
    8000397e:	8082                	ret

0000000080003980 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003980:	1101                	addi	sp,sp,-32
    80003982:	ec06                	sd	ra,24(sp)
    80003984:	e822                	sd	s0,16(sp)
    80003986:	e426                	sd	s1,8(sp)
    80003988:	e04a                	sd	s2,0(sp)
    8000398a:	1000                	addi	s0,sp,32
    8000398c:	84aa                	mv	s1,a0
    8000398e:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003990:	00005597          	auipc	a1,0x5
    80003994:	b7858593          	addi	a1,a1,-1160 # 80008508 <etext+0x508>
    80003998:	0521                	addi	a0,a0,8
    8000399a:	00003097          	auipc	ra,0x3
    8000399e:	9d4080e7          	jalr	-1580(ra) # 8000636e <initlock>
  lk->name = name;
    800039a2:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800039a6:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800039aa:	0204a423          	sw	zero,40(s1)
}
    800039ae:	60e2                	ld	ra,24(sp)
    800039b0:	6442                	ld	s0,16(sp)
    800039b2:	64a2                	ld	s1,8(sp)
    800039b4:	6902                	ld	s2,0(sp)
    800039b6:	6105                	addi	sp,sp,32
    800039b8:	8082                	ret

00000000800039ba <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800039ba:	1101                	addi	sp,sp,-32
    800039bc:	ec06                	sd	ra,24(sp)
    800039be:	e822                	sd	s0,16(sp)
    800039c0:	e426                	sd	s1,8(sp)
    800039c2:	e04a                	sd	s2,0(sp)
    800039c4:	1000                	addi	s0,sp,32
    800039c6:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800039c8:	00850913          	addi	s2,a0,8
    800039cc:	854a                	mv	a0,s2
    800039ce:	00003097          	auipc	ra,0x3
    800039d2:	a34080e7          	jalr	-1484(ra) # 80006402 <acquire>
  while (lk->locked) {
    800039d6:	409c                	lw	a5,0(s1)
    800039d8:	cb89                	beqz	a5,800039ea <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800039da:	85ca                	mv	a1,s2
    800039dc:	8526                	mv	a0,s1
    800039de:	ffffe097          	auipc	ra,0xffffe
    800039e2:	cca080e7          	jalr	-822(ra) # 800016a8 <sleep>
  while (lk->locked) {
    800039e6:	409c                	lw	a5,0(s1)
    800039e8:	fbed                	bnez	a5,800039da <acquiresleep+0x20>
  }
  lk->locked = 1;
    800039ea:	4785                	li	a5,1
    800039ec:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800039ee:	ffffd097          	auipc	ra,0xffffd
    800039f2:	5f4080e7          	jalr	1524(ra) # 80000fe2 <myproc>
    800039f6:	591c                	lw	a5,48(a0)
    800039f8:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800039fa:	854a                	mv	a0,s2
    800039fc:	00003097          	auipc	ra,0x3
    80003a00:	ab6080e7          	jalr	-1354(ra) # 800064b2 <release>
}
    80003a04:	60e2                	ld	ra,24(sp)
    80003a06:	6442                	ld	s0,16(sp)
    80003a08:	64a2                	ld	s1,8(sp)
    80003a0a:	6902                	ld	s2,0(sp)
    80003a0c:	6105                	addi	sp,sp,32
    80003a0e:	8082                	ret

0000000080003a10 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003a10:	1101                	addi	sp,sp,-32
    80003a12:	ec06                	sd	ra,24(sp)
    80003a14:	e822                	sd	s0,16(sp)
    80003a16:	e426                	sd	s1,8(sp)
    80003a18:	e04a                	sd	s2,0(sp)
    80003a1a:	1000                	addi	s0,sp,32
    80003a1c:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003a1e:	00850913          	addi	s2,a0,8
    80003a22:	854a                	mv	a0,s2
    80003a24:	00003097          	auipc	ra,0x3
    80003a28:	9de080e7          	jalr	-1570(ra) # 80006402 <acquire>
  lk->locked = 0;
    80003a2c:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003a30:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003a34:	8526                	mv	a0,s1
    80003a36:	ffffe097          	auipc	ra,0xffffe
    80003a3a:	df8080e7          	jalr	-520(ra) # 8000182e <wakeup>
  release(&lk->lk);
    80003a3e:	854a                	mv	a0,s2
    80003a40:	00003097          	auipc	ra,0x3
    80003a44:	a72080e7          	jalr	-1422(ra) # 800064b2 <release>
}
    80003a48:	60e2                	ld	ra,24(sp)
    80003a4a:	6442                	ld	s0,16(sp)
    80003a4c:	64a2                	ld	s1,8(sp)
    80003a4e:	6902                	ld	s2,0(sp)
    80003a50:	6105                	addi	sp,sp,32
    80003a52:	8082                	ret

0000000080003a54 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003a54:	7179                	addi	sp,sp,-48
    80003a56:	f406                	sd	ra,40(sp)
    80003a58:	f022                	sd	s0,32(sp)
    80003a5a:	ec26                	sd	s1,24(sp)
    80003a5c:	e84a                	sd	s2,16(sp)
    80003a5e:	1800                	addi	s0,sp,48
    80003a60:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003a62:	00850913          	addi	s2,a0,8
    80003a66:	854a                	mv	a0,s2
    80003a68:	00003097          	auipc	ra,0x3
    80003a6c:	99a080e7          	jalr	-1638(ra) # 80006402 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003a70:	409c                	lw	a5,0(s1)
    80003a72:	ef91                	bnez	a5,80003a8e <holdingsleep+0x3a>
    80003a74:	4481                	li	s1,0
  release(&lk->lk);
    80003a76:	854a                	mv	a0,s2
    80003a78:	00003097          	auipc	ra,0x3
    80003a7c:	a3a080e7          	jalr	-1478(ra) # 800064b2 <release>
  return r;
}
    80003a80:	8526                	mv	a0,s1
    80003a82:	70a2                	ld	ra,40(sp)
    80003a84:	7402                	ld	s0,32(sp)
    80003a86:	64e2                	ld	s1,24(sp)
    80003a88:	6942                	ld	s2,16(sp)
    80003a8a:	6145                	addi	sp,sp,48
    80003a8c:	8082                	ret
    80003a8e:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80003a90:	0284a983          	lw	s3,40(s1)
    80003a94:	ffffd097          	auipc	ra,0xffffd
    80003a98:	54e080e7          	jalr	1358(ra) # 80000fe2 <myproc>
    80003a9c:	5904                	lw	s1,48(a0)
    80003a9e:	413484b3          	sub	s1,s1,s3
    80003aa2:	0014b493          	seqz	s1,s1
    80003aa6:	69a2                	ld	s3,8(sp)
    80003aa8:	b7f9                	j	80003a76 <holdingsleep+0x22>

0000000080003aaa <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003aaa:	1141                	addi	sp,sp,-16
    80003aac:	e406                	sd	ra,8(sp)
    80003aae:	e022                	sd	s0,0(sp)
    80003ab0:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003ab2:	00005597          	auipc	a1,0x5
    80003ab6:	a6658593          	addi	a1,a1,-1434 # 80008518 <etext+0x518>
    80003aba:	00035517          	auipc	a0,0x35
    80003abe:	6ce50513          	addi	a0,a0,1742 # 80039188 <ftable>
    80003ac2:	00003097          	auipc	ra,0x3
    80003ac6:	8ac080e7          	jalr	-1876(ra) # 8000636e <initlock>
}
    80003aca:	60a2                	ld	ra,8(sp)
    80003acc:	6402                	ld	s0,0(sp)
    80003ace:	0141                	addi	sp,sp,16
    80003ad0:	8082                	ret

0000000080003ad2 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003ad2:	1101                	addi	sp,sp,-32
    80003ad4:	ec06                	sd	ra,24(sp)
    80003ad6:	e822                	sd	s0,16(sp)
    80003ad8:	e426                	sd	s1,8(sp)
    80003ada:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003adc:	00035517          	auipc	a0,0x35
    80003ae0:	6ac50513          	addi	a0,a0,1708 # 80039188 <ftable>
    80003ae4:	00003097          	auipc	ra,0x3
    80003ae8:	91e080e7          	jalr	-1762(ra) # 80006402 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003aec:	00035497          	auipc	s1,0x35
    80003af0:	6b448493          	addi	s1,s1,1716 # 800391a0 <ftable+0x18>
    80003af4:	00036717          	auipc	a4,0x36
    80003af8:	64c70713          	addi	a4,a4,1612 # 8003a140 <ftable+0xfb8>
    if(f->ref == 0){
    80003afc:	40dc                	lw	a5,4(s1)
    80003afe:	cf99                	beqz	a5,80003b1c <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003b00:	02848493          	addi	s1,s1,40
    80003b04:	fee49ce3          	bne	s1,a4,80003afc <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003b08:	00035517          	auipc	a0,0x35
    80003b0c:	68050513          	addi	a0,a0,1664 # 80039188 <ftable>
    80003b10:	00003097          	auipc	ra,0x3
    80003b14:	9a2080e7          	jalr	-1630(ra) # 800064b2 <release>
  return 0;
    80003b18:	4481                	li	s1,0
    80003b1a:	a819                	j	80003b30 <filealloc+0x5e>
      f->ref = 1;
    80003b1c:	4785                	li	a5,1
    80003b1e:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003b20:	00035517          	auipc	a0,0x35
    80003b24:	66850513          	addi	a0,a0,1640 # 80039188 <ftable>
    80003b28:	00003097          	auipc	ra,0x3
    80003b2c:	98a080e7          	jalr	-1654(ra) # 800064b2 <release>
}
    80003b30:	8526                	mv	a0,s1
    80003b32:	60e2                	ld	ra,24(sp)
    80003b34:	6442                	ld	s0,16(sp)
    80003b36:	64a2                	ld	s1,8(sp)
    80003b38:	6105                	addi	sp,sp,32
    80003b3a:	8082                	ret

0000000080003b3c <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003b3c:	1101                	addi	sp,sp,-32
    80003b3e:	ec06                	sd	ra,24(sp)
    80003b40:	e822                	sd	s0,16(sp)
    80003b42:	e426                	sd	s1,8(sp)
    80003b44:	1000                	addi	s0,sp,32
    80003b46:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003b48:	00035517          	auipc	a0,0x35
    80003b4c:	64050513          	addi	a0,a0,1600 # 80039188 <ftable>
    80003b50:	00003097          	auipc	ra,0x3
    80003b54:	8b2080e7          	jalr	-1870(ra) # 80006402 <acquire>
  if(f->ref < 1)
    80003b58:	40dc                	lw	a5,4(s1)
    80003b5a:	02f05263          	blez	a5,80003b7e <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003b5e:	2785                	addiw	a5,a5,1
    80003b60:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003b62:	00035517          	auipc	a0,0x35
    80003b66:	62650513          	addi	a0,a0,1574 # 80039188 <ftable>
    80003b6a:	00003097          	auipc	ra,0x3
    80003b6e:	948080e7          	jalr	-1720(ra) # 800064b2 <release>
  return f;
}
    80003b72:	8526                	mv	a0,s1
    80003b74:	60e2                	ld	ra,24(sp)
    80003b76:	6442                	ld	s0,16(sp)
    80003b78:	64a2                	ld	s1,8(sp)
    80003b7a:	6105                	addi	sp,sp,32
    80003b7c:	8082                	ret
    panic("filedup");
    80003b7e:	00005517          	auipc	a0,0x5
    80003b82:	9a250513          	addi	a0,a0,-1630 # 80008520 <etext+0x520>
    80003b86:	00002097          	auipc	ra,0x2
    80003b8a:	2fc080e7          	jalr	764(ra) # 80005e82 <panic>

0000000080003b8e <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003b8e:	7139                	addi	sp,sp,-64
    80003b90:	fc06                	sd	ra,56(sp)
    80003b92:	f822                	sd	s0,48(sp)
    80003b94:	f426                	sd	s1,40(sp)
    80003b96:	0080                	addi	s0,sp,64
    80003b98:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003b9a:	00035517          	auipc	a0,0x35
    80003b9e:	5ee50513          	addi	a0,a0,1518 # 80039188 <ftable>
    80003ba2:	00003097          	auipc	ra,0x3
    80003ba6:	860080e7          	jalr	-1952(ra) # 80006402 <acquire>
  if(f->ref < 1)
    80003baa:	40dc                	lw	a5,4(s1)
    80003bac:	04f05a63          	blez	a5,80003c00 <fileclose+0x72>
    panic("fileclose");
  if(--f->ref > 0){
    80003bb0:	37fd                	addiw	a5,a5,-1
    80003bb2:	c0dc                	sw	a5,4(s1)
    80003bb4:	06f04263          	bgtz	a5,80003c18 <fileclose+0x8a>
    80003bb8:	f04a                	sd	s2,32(sp)
    80003bba:	ec4e                	sd	s3,24(sp)
    80003bbc:	e852                	sd	s4,16(sp)
    80003bbe:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003bc0:	0004a903          	lw	s2,0(s1)
    80003bc4:	0094ca83          	lbu	s5,9(s1)
    80003bc8:	0104ba03          	ld	s4,16(s1)
    80003bcc:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003bd0:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003bd4:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003bd8:	00035517          	auipc	a0,0x35
    80003bdc:	5b050513          	addi	a0,a0,1456 # 80039188 <ftable>
    80003be0:	00003097          	auipc	ra,0x3
    80003be4:	8d2080e7          	jalr	-1838(ra) # 800064b2 <release>

  if(ff.type == FD_PIPE){
    80003be8:	4785                	li	a5,1
    80003bea:	04f90463          	beq	s2,a5,80003c32 <fileclose+0xa4>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003bee:	3979                	addiw	s2,s2,-2
    80003bf0:	4785                	li	a5,1
    80003bf2:	0527fb63          	bgeu	a5,s2,80003c48 <fileclose+0xba>
    80003bf6:	7902                	ld	s2,32(sp)
    80003bf8:	69e2                	ld	s3,24(sp)
    80003bfa:	6a42                	ld	s4,16(sp)
    80003bfc:	6aa2                	ld	s5,8(sp)
    80003bfe:	a02d                	j	80003c28 <fileclose+0x9a>
    80003c00:	f04a                	sd	s2,32(sp)
    80003c02:	ec4e                	sd	s3,24(sp)
    80003c04:	e852                	sd	s4,16(sp)
    80003c06:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80003c08:	00005517          	auipc	a0,0x5
    80003c0c:	92050513          	addi	a0,a0,-1760 # 80008528 <etext+0x528>
    80003c10:	00002097          	auipc	ra,0x2
    80003c14:	272080e7          	jalr	626(ra) # 80005e82 <panic>
    release(&ftable.lock);
    80003c18:	00035517          	auipc	a0,0x35
    80003c1c:	57050513          	addi	a0,a0,1392 # 80039188 <ftable>
    80003c20:	00003097          	auipc	ra,0x3
    80003c24:	892080e7          	jalr	-1902(ra) # 800064b2 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80003c28:	70e2                	ld	ra,56(sp)
    80003c2a:	7442                	ld	s0,48(sp)
    80003c2c:	74a2                	ld	s1,40(sp)
    80003c2e:	6121                	addi	sp,sp,64
    80003c30:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003c32:	85d6                	mv	a1,s5
    80003c34:	8552                	mv	a0,s4
    80003c36:	00000097          	auipc	ra,0x0
    80003c3a:	3ac080e7          	jalr	940(ra) # 80003fe2 <pipeclose>
    80003c3e:	7902                	ld	s2,32(sp)
    80003c40:	69e2                	ld	s3,24(sp)
    80003c42:	6a42                	ld	s4,16(sp)
    80003c44:	6aa2                	ld	s5,8(sp)
    80003c46:	b7cd                	j	80003c28 <fileclose+0x9a>
    begin_op();
    80003c48:	00000097          	auipc	ra,0x0
    80003c4c:	a76080e7          	jalr	-1418(ra) # 800036be <begin_op>
    iput(ff.ip);
    80003c50:	854e                	mv	a0,s3
    80003c52:	fffff097          	auipc	ra,0xfffff
    80003c56:	238080e7          	jalr	568(ra) # 80002e8a <iput>
    end_op();
    80003c5a:	00000097          	auipc	ra,0x0
    80003c5e:	ade080e7          	jalr	-1314(ra) # 80003738 <end_op>
    80003c62:	7902                	ld	s2,32(sp)
    80003c64:	69e2                	ld	s3,24(sp)
    80003c66:	6a42                	ld	s4,16(sp)
    80003c68:	6aa2                	ld	s5,8(sp)
    80003c6a:	bf7d                	j	80003c28 <fileclose+0x9a>

0000000080003c6c <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003c6c:	715d                	addi	sp,sp,-80
    80003c6e:	e486                	sd	ra,72(sp)
    80003c70:	e0a2                	sd	s0,64(sp)
    80003c72:	fc26                	sd	s1,56(sp)
    80003c74:	f44e                	sd	s3,40(sp)
    80003c76:	0880                	addi	s0,sp,80
    80003c78:	84aa                	mv	s1,a0
    80003c7a:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003c7c:	ffffd097          	auipc	ra,0xffffd
    80003c80:	366080e7          	jalr	870(ra) # 80000fe2 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003c84:	409c                	lw	a5,0(s1)
    80003c86:	37f9                	addiw	a5,a5,-2
    80003c88:	4705                	li	a4,1
    80003c8a:	04f76a63          	bltu	a4,a5,80003cde <filestat+0x72>
    80003c8e:	f84a                	sd	s2,48(sp)
    80003c90:	f052                	sd	s4,32(sp)
    80003c92:	892a                	mv	s2,a0
    ilock(f->ip);
    80003c94:	6c88                	ld	a0,24(s1)
    80003c96:	fffff097          	auipc	ra,0xfffff
    80003c9a:	036080e7          	jalr	54(ra) # 80002ccc <ilock>
    stati(f->ip, &st);
    80003c9e:	fb840a13          	addi	s4,s0,-72
    80003ca2:	85d2                	mv	a1,s4
    80003ca4:	6c88                	ld	a0,24(s1)
    80003ca6:	fffff097          	auipc	ra,0xfffff
    80003caa:	2b4080e7          	jalr	692(ra) # 80002f5a <stati>
    iunlock(f->ip);
    80003cae:	6c88                	ld	a0,24(s1)
    80003cb0:	fffff097          	auipc	ra,0xfffff
    80003cb4:	0e2080e7          	jalr	226(ra) # 80002d92 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003cb8:	46e1                	li	a3,24
    80003cba:	8652                	mv	a2,s4
    80003cbc:	85ce                	mv	a1,s3
    80003cbe:	05093503          	ld	a0,80(s2)
    80003cc2:	ffffd097          	auipc	ra,0xffffd
    80003cc6:	fb8080e7          	jalr	-72(ra) # 80000c7a <copyout>
    80003cca:	41f5551b          	sraiw	a0,a0,0x1f
    80003cce:	7942                	ld	s2,48(sp)
    80003cd0:	7a02                	ld	s4,32(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80003cd2:	60a6                	ld	ra,72(sp)
    80003cd4:	6406                	ld	s0,64(sp)
    80003cd6:	74e2                	ld	s1,56(sp)
    80003cd8:	79a2                	ld	s3,40(sp)
    80003cda:	6161                	addi	sp,sp,80
    80003cdc:	8082                	ret
  return -1;
    80003cde:	557d                	li	a0,-1
    80003ce0:	bfcd                	j	80003cd2 <filestat+0x66>

0000000080003ce2 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003ce2:	7179                	addi	sp,sp,-48
    80003ce4:	f406                	sd	ra,40(sp)
    80003ce6:	f022                	sd	s0,32(sp)
    80003ce8:	e84a                	sd	s2,16(sp)
    80003cea:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003cec:	00854783          	lbu	a5,8(a0)
    80003cf0:	cbc5                	beqz	a5,80003da0 <fileread+0xbe>
    80003cf2:	ec26                	sd	s1,24(sp)
    80003cf4:	e44e                	sd	s3,8(sp)
    80003cf6:	84aa                	mv	s1,a0
    80003cf8:	89ae                	mv	s3,a1
    80003cfa:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003cfc:	411c                	lw	a5,0(a0)
    80003cfe:	4705                	li	a4,1
    80003d00:	04e78963          	beq	a5,a4,80003d52 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003d04:	470d                	li	a4,3
    80003d06:	04e78f63          	beq	a5,a4,80003d64 <fileread+0x82>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003d0a:	4709                	li	a4,2
    80003d0c:	08e79263          	bne	a5,a4,80003d90 <fileread+0xae>
    ilock(f->ip);
    80003d10:	6d08                	ld	a0,24(a0)
    80003d12:	fffff097          	auipc	ra,0xfffff
    80003d16:	fba080e7          	jalr	-70(ra) # 80002ccc <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003d1a:	874a                	mv	a4,s2
    80003d1c:	5094                	lw	a3,32(s1)
    80003d1e:	864e                	mv	a2,s3
    80003d20:	4585                	li	a1,1
    80003d22:	6c88                	ld	a0,24(s1)
    80003d24:	fffff097          	auipc	ra,0xfffff
    80003d28:	264080e7          	jalr	612(ra) # 80002f88 <readi>
    80003d2c:	892a                	mv	s2,a0
    80003d2e:	00a05563          	blez	a0,80003d38 <fileread+0x56>
      f->off += r;
    80003d32:	509c                	lw	a5,32(s1)
    80003d34:	9fa9                	addw	a5,a5,a0
    80003d36:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003d38:	6c88                	ld	a0,24(s1)
    80003d3a:	fffff097          	auipc	ra,0xfffff
    80003d3e:	058080e7          	jalr	88(ra) # 80002d92 <iunlock>
    80003d42:	64e2                	ld	s1,24(sp)
    80003d44:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80003d46:	854a                	mv	a0,s2
    80003d48:	70a2                	ld	ra,40(sp)
    80003d4a:	7402                	ld	s0,32(sp)
    80003d4c:	6942                	ld	s2,16(sp)
    80003d4e:	6145                	addi	sp,sp,48
    80003d50:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003d52:	6908                	ld	a0,16(a0)
    80003d54:	00000097          	auipc	ra,0x0
    80003d58:	414080e7          	jalr	1044(ra) # 80004168 <piperead>
    80003d5c:	892a                	mv	s2,a0
    80003d5e:	64e2                	ld	s1,24(sp)
    80003d60:	69a2                	ld	s3,8(sp)
    80003d62:	b7d5                	j	80003d46 <fileread+0x64>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003d64:	02451783          	lh	a5,36(a0)
    80003d68:	03079693          	slli	a3,a5,0x30
    80003d6c:	92c1                	srli	a3,a3,0x30
    80003d6e:	4725                	li	a4,9
    80003d70:	02d76a63          	bltu	a4,a3,80003da4 <fileread+0xc2>
    80003d74:	0792                	slli	a5,a5,0x4
    80003d76:	00035717          	auipc	a4,0x35
    80003d7a:	37270713          	addi	a4,a4,882 # 800390e8 <devsw>
    80003d7e:	97ba                	add	a5,a5,a4
    80003d80:	639c                	ld	a5,0(a5)
    80003d82:	c78d                	beqz	a5,80003dac <fileread+0xca>
    r = devsw[f->major].read(1, addr, n);
    80003d84:	4505                	li	a0,1
    80003d86:	9782                	jalr	a5
    80003d88:	892a                	mv	s2,a0
    80003d8a:	64e2                	ld	s1,24(sp)
    80003d8c:	69a2                	ld	s3,8(sp)
    80003d8e:	bf65                	j	80003d46 <fileread+0x64>
    panic("fileread");
    80003d90:	00004517          	auipc	a0,0x4
    80003d94:	7a850513          	addi	a0,a0,1960 # 80008538 <etext+0x538>
    80003d98:	00002097          	auipc	ra,0x2
    80003d9c:	0ea080e7          	jalr	234(ra) # 80005e82 <panic>
    return -1;
    80003da0:	597d                	li	s2,-1
    80003da2:	b755                	j	80003d46 <fileread+0x64>
      return -1;
    80003da4:	597d                	li	s2,-1
    80003da6:	64e2                	ld	s1,24(sp)
    80003da8:	69a2                	ld	s3,8(sp)
    80003daa:	bf71                	j	80003d46 <fileread+0x64>
    80003dac:	597d                	li	s2,-1
    80003dae:	64e2                	ld	s1,24(sp)
    80003db0:	69a2                	ld	s3,8(sp)
    80003db2:	bf51                	j	80003d46 <fileread+0x64>

0000000080003db4 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003db4:	00954783          	lbu	a5,9(a0)
    80003db8:	12078c63          	beqz	a5,80003ef0 <filewrite+0x13c>
{
    80003dbc:	711d                	addi	sp,sp,-96
    80003dbe:	ec86                	sd	ra,88(sp)
    80003dc0:	e8a2                	sd	s0,80(sp)
    80003dc2:	e0ca                	sd	s2,64(sp)
    80003dc4:	f456                	sd	s5,40(sp)
    80003dc6:	f05a                	sd	s6,32(sp)
    80003dc8:	1080                	addi	s0,sp,96
    80003dca:	892a                	mv	s2,a0
    80003dcc:	8b2e                	mv	s6,a1
    80003dce:	8ab2                	mv	s5,a2
    return -1;

  if(f->type == FD_PIPE){
    80003dd0:	411c                	lw	a5,0(a0)
    80003dd2:	4705                	li	a4,1
    80003dd4:	02e78963          	beq	a5,a4,80003e06 <filewrite+0x52>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003dd8:	470d                	li	a4,3
    80003dda:	02e78c63          	beq	a5,a4,80003e12 <filewrite+0x5e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003dde:	4709                	li	a4,2
    80003de0:	0ee79a63          	bne	a5,a4,80003ed4 <filewrite+0x120>
    80003de4:	f852                	sd	s4,48(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003de6:	0cc05563          	blez	a2,80003eb0 <filewrite+0xfc>
    80003dea:	e4a6                	sd	s1,72(sp)
    80003dec:	fc4e                	sd	s3,56(sp)
    80003dee:	ec5e                	sd	s7,24(sp)
    80003df0:	e862                	sd	s8,16(sp)
    80003df2:	e466                	sd	s9,8(sp)
    int i = 0;
    80003df4:	4a01                	li	s4,0
      int n1 = n - i;
      if(n1 > max)
    80003df6:	6b85                	lui	s7,0x1
    80003df8:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003dfc:	6c85                	lui	s9,0x1
    80003dfe:	c00c8c9b          	addiw	s9,s9,-1024 # c00 <_entry-0x7ffff400>
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003e02:	4c05                	li	s8,1
    80003e04:	a849                	j	80003e96 <filewrite+0xe2>
    ret = pipewrite(f->pipe, addr, n);
    80003e06:	6908                	ld	a0,16(a0)
    80003e08:	00000097          	auipc	ra,0x0
    80003e0c:	24a080e7          	jalr	586(ra) # 80004052 <pipewrite>
    80003e10:	a85d                	j	80003ec6 <filewrite+0x112>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003e12:	02451783          	lh	a5,36(a0)
    80003e16:	03079693          	slli	a3,a5,0x30
    80003e1a:	92c1                	srli	a3,a3,0x30
    80003e1c:	4725                	li	a4,9
    80003e1e:	0cd76b63          	bltu	a4,a3,80003ef4 <filewrite+0x140>
    80003e22:	0792                	slli	a5,a5,0x4
    80003e24:	00035717          	auipc	a4,0x35
    80003e28:	2c470713          	addi	a4,a4,708 # 800390e8 <devsw>
    80003e2c:	97ba                	add	a5,a5,a4
    80003e2e:	679c                	ld	a5,8(a5)
    80003e30:	c7e1                	beqz	a5,80003ef8 <filewrite+0x144>
    ret = devsw[f->major].write(1, addr, n);
    80003e32:	4505                	li	a0,1
    80003e34:	9782                	jalr	a5
    80003e36:	a841                	j	80003ec6 <filewrite+0x112>
      if(n1 > max)
    80003e38:	2981                	sext.w	s3,s3
      begin_op();
    80003e3a:	00000097          	auipc	ra,0x0
    80003e3e:	884080e7          	jalr	-1916(ra) # 800036be <begin_op>
      ilock(f->ip);
    80003e42:	01893503          	ld	a0,24(s2)
    80003e46:	fffff097          	auipc	ra,0xfffff
    80003e4a:	e86080e7          	jalr	-378(ra) # 80002ccc <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003e4e:	874e                	mv	a4,s3
    80003e50:	02092683          	lw	a3,32(s2)
    80003e54:	016a0633          	add	a2,s4,s6
    80003e58:	85e2                	mv	a1,s8
    80003e5a:	01893503          	ld	a0,24(s2)
    80003e5e:	fffff097          	auipc	ra,0xfffff
    80003e62:	224080e7          	jalr	548(ra) # 80003082 <writei>
    80003e66:	84aa                	mv	s1,a0
    80003e68:	00a05763          	blez	a0,80003e76 <filewrite+0xc2>
        f->off += r;
    80003e6c:	02092783          	lw	a5,32(s2)
    80003e70:	9fa9                	addw	a5,a5,a0
    80003e72:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003e76:	01893503          	ld	a0,24(s2)
    80003e7a:	fffff097          	auipc	ra,0xfffff
    80003e7e:	f18080e7          	jalr	-232(ra) # 80002d92 <iunlock>
      end_op();
    80003e82:	00000097          	auipc	ra,0x0
    80003e86:	8b6080e7          	jalr	-1866(ra) # 80003738 <end_op>

      if(r != n1){
    80003e8a:	02999563          	bne	s3,s1,80003eb4 <filewrite+0x100>
        // error from writei
        break;
      }
      i += r;
    80003e8e:	01448a3b          	addw	s4,s1,s4
    while(i < n){
    80003e92:	015a5963          	bge	s4,s5,80003ea4 <filewrite+0xf0>
      int n1 = n - i;
    80003e96:	414a87bb          	subw	a5,s5,s4
    80003e9a:	89be                	mv	s3,a5
      if(n1 > max)
    80003e9c:	f8fbdee3          	bge	s7,a5,80003e38 <filewrite+0x84>
    80003ea0:	89e6                	mv	s3,s9
    80003ea2:	bf59                	j	80003e38 <filewrite+0x84>
    80003ea4:	64a6                	ld	s1,72(sp)
    80003ea6:	79e2                	ld	s3,56(sp)
    80003ea8:	6be2                	ld	s7,24(sp)
    80003eaa:	6c42                	ld	s8,16(sp)
    80003eac:	6ca2                	ld	s9,8(sp)
    80003eae:	a801                	j	80003ebe <filewrite+0x10a>
    int i = 0;
    80003eb0:	4a01                	li	s4,0
    80003eb2:	a031                	j	80003ebe <filewrite+0x10a>
    80003eb4:	64a6                	ld	s1,72(sp)
    80003eb6:	79e2                	ld	s3,56(sp)
    80003eb8:	6be2                	ld	s7,24(sp)
    80003eba:	6c42                	ld	s8,16(sp)
    80003ebc:	6ca2                	ld	s9,8(sp)
    }
    ret = (i == n ? n : -1);
    80003ebe:	034a9f63          	bne	s5,s4,80003efc <filewrite+0x148>
    80003ec2:	8556                	mv	a0,s5
    80003ec4:	7a42                	ld	s4,48(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003ec6:	60e6                	ld	ra,88(sp)
    80003ec8:	6446                	ld	s0,80(sp)
    80003eca:	6906                	ld	s2,64(sp)
    80003ecc:	7aa2                	ld	s5,40(sp)
    80003ece:	7b02                	ld	s6,32(sp)
    80003ed0:	6125                	addi	sp,sp,96
    80003ed2:	8082                	ret
    80003ed4:	e4a6                	sd	s1,72(sp)
    80003ed6:	fc4e                	sd	s3,56(sp)
    80003ed8:	f852                	sd	s4,48(sp)
    80003eda:	ec5e                	sd	s7,24(sp)
    80003edc:	e862                	sd	s8,16(sp)
    80003ede:	e466                	sd	s9,8(sp)
    panic("filewrite");
    80003ee0:	00004517          	auipc	a0,0x4
    80003ee4:	66850513          	addi	a0,a0,1640 # 80008548 <etext+0x548>
    80003ee8:	00002097          	auipc	ra,0x2
    80003eec:	f9a080e7          	jalr	-102(ra) # 80005e82 <panic>
    return -1;
    80003ef0:	557d                	li	a0,-1
}
    80003ef2:	8082                	ret
      return -1;
    80003ef4:	557d                	li	a0,-1
    80003ef6:	bfc1                	j	80003ec6 <filewrite+0x112>
    80003ef8:	557d                	li	a0,-1
    80003efa:	b7f1                	j	80003ec6 <filewrite+0x112>
    ret = (i == n ? n : -1);
    80003efc:	557d                	li	a0,-1
    80003efe:	7a42                	ld	s4,48(sp)
    80003f00:	b7d9                	j	80003ec6 <filewrite+0x112>

0000000080003f02 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003f02:	7179                	addi	sp,sp,-48
    80003f04:	f406                	sd	ra,40(sp)
    80003f06:	f022                	sd	s0,32(sp)
    80003f08:	ec26                	sd	s1,24(sp)
    80003f0a:	e052                	sd	s4,0(sp)
    80003f0c:	1800                	addi	s0,sp,48
    80003f0e:	84aa                	mv	s1,a0
    80003f10:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003f12:	0005b023          	sd	zero,0(a1)
    80003f16:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003f1a:	00000097          	auipc	ra,0x0
    80003f1e:	bb8080e7          	jalr	-1096(ra) # 80003ad2 <filealloc>
    80003f22:	e088                	sd	a0,0(s1)
    80003f24:	cd49                	beqz	a0,80003fbe <pipealloc+0xbc>
    80003f26:	00000097          	auipc	ra,0x0
    80003f2a:	bac080e7          	jalr	-1108(ra) # 80003ad2 <filealloc>
    80003f2e:	00aa3023          	sd	a0,0(s4)
    80003f32:	c141                	beqz	a0,80003fb2 <pipealloc+0xb0>
    80003f34:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003f36:	ffffc097          	auipc	ra,0xffffc
    80003f3a:	2d4080e7          	jalr	724(ra) # 8000020a <kalloc>
    80003f3e:	892a                	mv	s2,a0
    80003f40:	c13d                	beqz	a0,80003fa6 <pipealloc+0xa4>
    80003f42:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80003f44:	4985                	li	s3,1
    80003f46:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003f4a:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003f4e:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003f52:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003f56:	00004597          	auipc	a1,0x4
    80003f5a:	60258593          	addi	a1,a1,1538 # 80008558 <etext+0x558>
    80003f5e:	00002097          	auipc	ra,0x2
    80003f62:	410080e7          	jalr	1040(ra) # 8000636e <initlock>
  (*f0)->type = FD_PIPE;
    80003f66:	609c                	ld	a5,0(s1)
    80003f68:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003f6c:	609c                	ld	a5,0(s1)
    80003f6e:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003f72:	609c                	ld	a5,0(s1)
    80003f74:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003f78:	609c                	ld	a5,0(s1)
    80003f7a:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003f7e:	000a3783          	ld	a5,0(s4)
    80003f82:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003f86:	000a3783          	ld	a5,0(s4)
    80003f8a:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003f8e:	000a3783          	ld	a5,0(s4)
    80003f92:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003f96:	000a3783          	ld	a5,0(s4)
    80003f9a:	0127b823          	sd	s2,16(a5)
  return 0;
    80003f9e:	4501                	li	a0,0
    80003fa0:	6942                	ld	s2,16(sp)
    80003fa2:	69a2                	ld	s3,8(sp)
    80003fa4:	a03d                	j	80003fd2 <pipealloc+0xd0>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003fa6:	6088                	ld	a0,0(s1)
    80003fa8:	c119                	beqz	a0,80003fae <pipealloc+0xac>
    80003faa:	6942                	ld	s2,16(sp)
    80003fac:	a029                	j	80003fb6 <pipealloc+0xb4>
    80003fae:	6942                	ld	s2,16(sp)
    80003fb0:	a039                	j	80003fbe <pipealloc+0xbc>
    80003fb2:	6088                	ld	a0,0(s1)
    80003fb4:	c50d                	beqz	a0,80003fde <pipealloc+0xdc>
    fileclose(*f0);
    80003fb6:	00000097          	auipc	ra,0x0
    80003fba:	bd8080e7          	jalr	-1064(ra) # 80003b8e <fileclose>
  if(*f1)
    80003fbe:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003fc2:	557d                	li	a0,-1
  if(*f1)
    80003fc4:	c799                	beqz	a5,80003fd2 <pipealloc+0xd0>
    fileclose(*f1);
    80003fc6:	853e                	mv	a0,a5
    80003fc8:	00000097          	auipc	ra,0x0
    80003fcc:	bc6080e7          	jalr	-1082(ra) # 80003b8e <fileclose>
  return -1;
    80003fd0:	557d                	li	a0,-1
}
    80003fd2:	70a2                	ld	ra,40(sp)
    80003fd4:	7402                	ld	s0,32(sp)
    80003fd6:	64e2                	ld	s1,24(sp)
    80003fd8:	6a02                	ld	s4,0(sp)
    80003fda:	6145                	addi	sp,sp,48
    80003fdc:	8082                	ret
  return -1;
    80003fde:	557d                	li	a0,-1
    80003fe0:	bfcd                	j	80003fd2 <pipealloc+0xd0>

0000000080003fe2 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003fe2:	1101                	addi	sp,sp,-32
    80003fe4:	ec06                	sd	ra,24(sp)
    80003fe6:	e822                	sd	s0,16(sp)
    80003fe8:	e426                	sd	s1,8(sp)
    80003fea:	e04a                	sd	s2,0(sp)
    80003fec:	1000                	addi	s0,sp,32
    80003fee:	84aa                	mv	s1,a0
    80003ff0:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003ff2:	00002097          	auipc	ra,0x2
    80003ff6:	410080e7          	jalr	1040(ra) # 80006402 <acquire>
  if(writable){
    80003ffa:	02090d63          	beqz	s2,80004034 <pipeclose+0x52>
    pi->writeopen = 0;
    80003ffe:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004002:	21848513          	addi	a0,s1,536
    80004006:	ffffe097          	auipc	ra,0xffffe
    8000400a:	828080e7          	jalr	-2008(ra) # 8000182e <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    8000400e:	2204b783          	ld	a5,544(s1)
    80004012:	eb95                	bnez	a5,80004046 <pipeclose+0x64>
    release(&pi->lock);
    80004014:	8526                	mv	a0,s1
    80004016:	00002097          	auipc	ra,0x2
    8000401a:	49c080e7          	jalr	1180(ra) # 800064b2 <release>
    kfree((char*)pi);
    8000401e:	8526                	mv	a0,s1
    80004020:	ffffc097          	auipc	ra,0xffffc
    80004024:	094080e7          	jalr	148(ra) # 800000b4 <kfree>
  } else
    release(&pi->lock);
}
    80004028:	60e2                	ld	ra,24(sp)
    8000402a:	6442                	ld	s0,16(sp)
    8000402c:	64a2                	ld	s1,8(sp)
    8000402e:	6902                	ld	s2,0(sp)
    80004030:	6105                	addi	sp,sp,32
    80004032:	8082                	ret
    pi->readopen = 0;
    80004034:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004038:	21c48513          	addi	a0,s1,540
    8000403c:	ffffd097          	auipc	ra,0xffffd
    80004040:	7f2080e7          	jalr	2034(ra) # 8000182e <wakeup>
    80004044:	b7e9                	j	8000400e <pipeclose+0x2c>
    release(&pi->lock);
    80004046:	8526                	mv	a0,s1
    80004048:	00002097          	auipc	ra,0x2
    8000404c:	46a080e7          	jalr	1130(ra) # 800064b2 <release>
}
    80004050:	bfe1                	j	80004028 <pipeclose+0x46>

0000000080004052 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004052:	7159                	addi	sp,sp,-112
    80004054:	f486                	sd	ra,104(sp)
    80004056:	f0a2                	sd	s0,96(sp)
    80004058:	eca6                	sd	s1,88(sp)
    8000405a:	e8ca                	sd	s2,80(sp)
    8000405c:	e4ce                	sd	s3,72(sp)
    8000405e:	e0d2                	sd	s4,64(sp)
    80004060:	fc56                	sd	s5,56(sp)
    80004062:	1880                	addi	s0,sp,112
    80004064:	84aa                	mv	s1,a0
    80004066:	8aae                	mv	s5,a1
    80004068:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    8000406a:	ffffd097          	auipc	ra,0xffffd
    8000406e:	f78080e7          	jalr	-136(ra) # 80000fe2 <myproc>
    80004072:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004074:	8526                	mv	a0,s1
    80004076:	00002097          	auipc	ra,0x2
    8000407a:	38c080e7          	jalr	908(ra) # 80006402 <acquire>
  while(i < n){
    8000407e:	0d405d63          	blez	s4,80004158 <pipewrite+0x106>
    80004082:	f85a                	sd	s6,48(sp)
    80004084:	f45e                	sd	s7,40(sp)
    80004086:	f062                	sd	s8,32(sp)
    80004088:	ec66                	sd	s9,24(sp)
    8000408a:	e86a                	sd	s10,16(sp)
  int i = 0;
    8000408c:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000408e:	f9f40c13          	addi	s8,s0,-97
    80004092:	4b85                	li	s7,1
    80004094:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004096:	21848d13          	addi	s10,s1,536
      sleep(&pi->nwrite, &pi->lock);
    8000409a:	21c48c93          	addi	s9,s1,540
    8000409e:	a099                	j	800040e4 <pipewrite+0x92>
      release(&pi->lock);
    800040a0:	8526                	mv	a0,s1
    800040a2:	00002097          	auipc	ra,0x2
    800040a6:	410080e7          	jalr	1040(ra) # 800064b2 <release>
      return -1;
    800040aa:	597d                	li	s2,-1
    800040ac:	7b42                	ld	s6,48(sp)
    800040ae:	7ba2                	ld	s7,40(sp)
    800040b0:	7c02                	ld	s8,32(sp)
    800040b2:	6ce2                	ld	s9,24(sp)
    800040b4:	6d42                	ld	s10,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800040b6:	854a                	mv	a0,s2
    800040b8:	70a6                	ld	ra,104(sp)
    800040ba:	7406                	ld	s0,96(sp)
    800040bc:	64e6                	ld	s1,88(sp)
    800040be:	6946                	ld	s2,80(sp)
    800040c0:	69a6                	ld	s3,72(sp)
    800040c2:	6a06                	ld	s4,64(sp)
    800040c4:	7ae2                	ld	s5,56(sp)
    800040c6:	6165                	addi	sp,sp,112
    800040c8:	8082                	ret
      wakeup(&pi->nread);
    800040ca:	856a                	mv	a0,s10
    800040cc:	ffffd097          	auipc	ra,0xffffd
    800040d0:	762080e7          	jalr	1890(ra) # 8000182e <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800040d4:	85a6                	mv	a1,s1
    800040d6:	8566                	mv	a0,s9
    800040d8:	ffffd097          	auipc	ra,0xffffd
    800040dc:	5d0080e7          	jalr	1488(ra) # 800016a8 <sleep>
  while(i < n){
    800040e0:	05495b63          	bge	s2,s4,80004136 <pipewrite+0xe4>
    if(pi->readopen == 0 || pr->killed){
    800040e4:	2204a783          	lw	a5,544(s1)
    800040e8:	dfc5                	beqz	a5,800040a0 <pipewrite+0x4e>
    800040ea:	0289a783          	lw	a5,40(s3)
    800040ee:	fbcd                	bnez	a5,800040a0 <pipewrite+0x4e>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    800040f0:	2184a783          	lw	a5,536(s1)
    800040f4:	21c4a703          	lw	a4,540(s1)
    800040f8:	2007879b          	addiw	a5,a5,512
    800040fc:	fcf707e3          	beq	a4,a5,800040ca <pipewrite+0x78>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004100:	86de                	mv	a3,s7
    80004102:	01590633          	add	a2,s2,s5
    80004106:	85e2                	mv	a1,s8
    80004108:	0509b503          	ld	a0,80(s3)
    8000410c:	ffffd097          	auipc	ra,0xffffd
    80004110:	c0e080e7          	jalr	-1010(ra) # 80000d1a <copyin>
    80004114:	05650463          	beq	a0,s6,8000415c <pipewrite+0x10a>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004118:	21c4a783          	lw	a5,540(s1)
    8000411c:	0017871b          	addiw	a4,a5,1
    80004120:	20e4ae23          	sw	a4,540(s1)
    80004124:	1ff7f793          	andi	a5,a5,511
    80004128:	97a6                	add	a5,a5,s1
    8000412a:	f9f44703          	lbu	a4,-97(s0)
    8000412e:	00e78c23          	sb	a4,24(a5)
      i++;
    80004132:	2905                	addiw	s2,s2,1
    80004134:	b775                	j	800040e0 <pipewrite+0x8e>
    80004136:	7b42                	ld	s6,48(sp)
    80004138:	7ba2                	ld	s7,40(sp)
    8000413a:	7c02                	ld	s8,32(sp)
    8000413c:	6ce2                	ld	s9,24(sp)
    8000413e:	6d42                	ld	s10,16(sp)
  wakeup(&pi->nread);
    80004140:	21848513          	addi	a0,s1,536
    80004144:	ffffd097          	auipc	ra,0xffffd
    80004148:	6ea080e7          	jalr	1770(ra) # 8000182e <wakeup>
  release(&pi->lock);
    8000414c:	8526                	mv	a0,s1
    8000414e:	00002097          	auipc	ra,0x2
    80004152:	364080e7          	jalr	868(ra) # 800064b2 <release>
  return i;
    80004156:	b785                	j	800040b6 <pipewrite+0x64>
  int i = 0;
    80004158:	4901                	li	s2,0
    8000415a:	b7dd                	j	80004140 <pipewrite+0xee>
    8000415c:	7b42                	ld	s6,48(sp)
    8000415e:	7ba2                	ld	s7,40(sp)
    80004160:	7c02                	ld	s8,32(sp)
    80004162:	6ce2                	ld	s9,24(sp)
    80004164:	6d42                	ld	s10,16(sp)
    80004166:	bfe9                	j	80004140 <pipewrite+0xee>

0000000080004168 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004168:	711d                	addi	sp,sp,-96
    8000416a:	ec86                	sd	ra,88(sp)
    8000416c:	e8a2                	sd	s0,80(sp)
    8000416e:	e4a6                	sd	s1,72(sp)
    80004170:	e0ca                	sd	s2,64(sp)
    80004172:	fc4e                	sd	s3,56(sp)
    80004174:	f852                	sd	s4,48(sp)
    80004176:	f456                	sd	s5,40(sp)
    80004178:	1080                	addi	s0,sp,96
    8000417a:	84aa                	mv	s1,a0
    8000417c:	892e                	mv	s2,a1
    8000417e:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004180:	ffffd097          	auipc	ra,0xffffd
    80004184:	e62080e7          	jalr	-414(ra) # 80000fe2 <myproc>
    80004188:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    8000418a:	8526                	mv	a0,s1
    8000418c:	00002097          	auipc	ra,0x2
    80004190:	276080e7          	jalr	630(ra) # 80006402 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004194:	2184a703          	lw	a4,536(s1)
    80004198:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000419c:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800041a0:	02f71863          	bne	a4,a5,800041d0 <piperead+0x68>
    800041a4:	2244a783          	lw	a5,548(s1)
    800041a8:	cf9d                	beqz	a5,800041e6 <piperead+0x7e>
    if(pr->killed){
    800041aa:	028a2783          	lw	a5,40(s4)
    800041ae:	e78d                	bnez	a5,800041d8 <piperead+0x70>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800041b0:	85a6                	mv	a1,s1
    800041b2:	854e                	mv	a0,s3
    800041b4:	ffffd097          	auipc	ra,0xffffd
    800041b8:	4f4080e7          	jalr	1268(ra) # 800016a8 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800041bc:	2184a703          	lw	a4,536(s1)
    800041c0:	21c4a783          	lw	a5,540(s1)
    800041c4:	fef700e3          	beq	a4,a5,800041a4 <piperead+0x3c>
    800041c8:	f05a                	sd	s6,32(sp)
    800041ca:	ec5e                	sd	s7,24(sp)
    800041cc:	e862                	sd	s8,16(sp)
    800041ce:	a839                	j	800041ec <piperead+0x84>
    800041d0:	f05a                	sd	s6,32(sp)
    800041d2:	ec5e                	sd	s7,24(sp)
    800041d4:	e862                	sd	s8,16(sp)
    800041d6:	a819                	j	800041ec <piperead+0x84>
      release(&pi->lock);
    800041d8:	8526                	mv	a0,s1
    800041da:	00002097          	auipc	ra,0x2
    800041de:	2d8080e7          	jalr	728(ra) # 800064b2 <release>
      return -1;
    800041e2:	59fd                	li	s3,-1
    800041e4:	a895                	j	80004258 <piperead+0xf0>
    800041e6:	f05a                	sd	s6,32(sp)
    800041e8:	ec5e                	sd	s7,24(sp)
    800041ea:	e862                	sd	s8,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800041ec:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800041ee:	faf40c13          	addi	s8,s0,-81
    800041f2:	4b85                	li	s7,1
    800041f4:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800041f6:	05505363          	blez	s5,8000423c <piperead+0xd4>
    if(pi->nread == pi->nwrite)
    800041fa:	2184a783          	lw	a5,536(s1)
    800041fe:	21c4a703          	lw	a4,540(s1)
    80004202:	02f70d63          	beq	a4,a5,8000423c <piperead+0xd4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004206:	0017871b          	addiw	a4,a5,1
    8000420a:	20e4ac23          	sw	a4,536(s1)
    8000420e:	1ff7f793          	andi	a5,a5,511
    80004212:	97a6                	add	a5,a5,s1
    80004214:	0187c783          	lbu	a5,24(a5)
    80004218:	faf407a3          	sb	a5,-81(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000421c:	86de                	mv	a3,s7
    8000421e:	8662                	mv	a2,s8
    80004220:	85ca                	mv	a1,s2
    80004222:	050a3503          	ld	a0,80(s4)
    80004226:	ffffd097          	auipc	ra,0xffffd
    8000422a:	a54080e7          	jalr	-1452(ra) # 80000c7a <copyout>
    8000422e:	01650763          	beq	a0,s6,8000423c <piperead+0xd4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004232:	2985                	addiw	s3,s3,1
    80004234:	0905                	addi	s2,s2,1
    80004236:	fd3a92e3          	bne	s5,s3,800041fa <piperead+0x92>
    8000423a:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8000423c:	21c48513          	addi	a0,s1,540
    80004240:	ffffd097          	auipc	ra,0xffffd
    80004244:	5ee080e7          	jalr	1518(ra) # 8000182e <wakeup>
  release(&pi->lock);
    80004248:	8526                	mv	a0,s1
    8000424a:	00002097          	auipc	ra,0x2
    8000424e:	268080e7          	jalr	616(ra) # 800064b2 <release>
    80004252:	7b02                	ld	s6,32(sp)
    80004254:	6be2                	ld	s7,24(sp)
    80004256:	6c42                	ld	s8,16(sp)
  return i;
}
    80004258:	854e                	mv	a0,s3
    8000425a:	60e6                	ld	ra,88(sp)
    8000425c:	6446                	ld	s0,80(sp)
    8000425e:	64a6                	ld	s1,72(sp)
    80004260:	6906                	ld	s2,64(sp)
    80004262:	79e2                	ld	s3,56(sp)
    80004264:	7a42                	ld	s4,48(sp)
    80004266:	7aa2                	ld	s5,40(sp)
    80004268:	6125                	addi	sp,sp,96
    8000426a:	8082                	ret

000000008000426c <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    8000426c:	de010113          	addi	sp,sp,-544
    80004270:	20113c23          	sd	ra,536(sp)
    80004274:	20813823          	sd	s0,528(sp)
    80004278:	20913423          	sd	s1,520(sp)
    8000427c:	21213023          	sd	s2,512(sp)
    80004280:	1400                	addi	s0,sp,544
    80004282:	892a                	mv	s2,a0
    80004284:	dea43823          	sd	a0,-528(s0)
    80004288:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000428c:	ffffd097          	auipc	ra,0xffffd
    80004290:	d56080e7          	jalr	-682(ra) # 80000fe2 <myproc>
    80004294:	84aa                	mv	s1,a0

  begin_op();
    80004296:	fffff097          	auipc	ra,0xfffff
    8000429a:	428080e7          	jalr	1064(ra) # 800036be <begin_op>

  if((ip = namei(path)) == 0){
    8000429e:	854a                	mv	a0,s2
    800042a0:	fffff097          	auipc	ra,0xfffff
    800042a4:	218080e7          	jalr	536(ra) # 800034b8 <namei>
    800042a8:	c525                	beqz	a0,80004310 <exec+0xa4>
    800042aa:	fbd2                	sd	s4,496(sp)
    800042ac:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800042ae:	fffff097          	auipc	ra,0xfffff
    800042b2:	a1e080e7          	jalr	-1506(ra) # 80002ccc <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800042b6:	04000713          	li	a4,64
    800042ba:	4681                	li	a3,0
    800042bc:	e5040613          	addi	a2,s0,-432
    800042c0:	4581                	li	a1,0
    800042c2:	8552                	mv	a0,s4
    800042c4:	fffff097          	auipc	ra,0xfffff
    800042c8:	cc4080e7          	jalr	-828(ra) # 80002f88 <readi>
    800042cc:	04000793          	li	a5,64
    800042d0:	00f51a63          	bne	a0,a5,800042e4 <exec+0x78>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    800042d4:	e5042703          	lw	a4,-432(s0)
    800042d8:	464c47b7          	lui	a5,0x464c4
    800042dc:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800042e0:	02f70e63          	beq	a4,a5,8000431c <exec+0xb0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800042e4:	8552                	mv	a0,s4
    800042e6:	fffff097          	auipc	ra,0xfffff
    800042ea:	c4c080e7          	jalr	-948(ra) # 80002f32 <iunlockput>
    end_op();
    800042ee:	fffff097          	auipc	ra,0xfffff
    800042f2:	44a080e7          	jalr	1098(ra) # 80003738 <end_op>
  }
  return -1;
    800042f6:	557d                	li	a0,-1
    800042f8:	7a5e                	ld	s4,496(sp)
}
    800042fa:	21813083          	ld	ra,536(sp)
    800042fe:	21013403          	ld	s0,528(sp)
    80004302:	20813483          	ld	s1,520(sp)
    80004306:	20013903          	ld	s2,512(sp)
    8000430a:	22010113          	addi	sp,sp,544
    8000430e:	8082                	ret
    end_op();
    80004310:	fffff097          	auipc	ra,0xfffff
    80004314:	428080e7          	jalr	1064(ra) # 80003738 <end_op>
    return -1;
    80004318:	557d                	li	a0,-1
    8000431a:	b7c5                	j	800042fa <exec+0x8e>
    8000431c:	f3da                	sd	s6,480(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    8000431e:	8526                	mv	a0,s1
    80004320:	ffffd097          	auipc	ra,0xffffd
    80004324:	d86080e7          	jalr	-634(ra) # 800010a6 <proc_pagetable>
    80004328:	8b2a                	mv	s6,a0
    8000432a:	2a050863          	beqz	a0,800045da <exec+0x36e>
    8000432e:	ffce                	sd	s3,504(sp)
    80004330:	f7d6                	sd	s5,488(sp)
    80004332:	efde                	sd	s7,472(sp)
    80004334:	ebe2                	sd	s8,464(sp)
    80004336:	e7e6                	sd	s9,456(sp)
    80004338:	e3ea                	sd	s10,448(sp)
    8000433a:	ff6e                	sd	s11,440(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000433c:	e7042683          	lw	a3,-400(s0)
    80004340:	e8845783          	lhu	a5,-376(s0)
    80004344:	cbfd                	beqz	a5,8000443a <exec+0x1ce>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004346:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004348:	4d01                	li	s10,0
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000434a:	03800d93          	li	s11,56
    if((ph.vaddr % PGSIZE) != 0)
    8000434e:	6c85                	lui	s9,0x1
    80004350:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004354:	def43423          	sd	a5,-536(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80004358:	6a85                	lui	s5,0x1
    8000435a:	a0b5                	j	800043c6 <exec+0x15a>
      panic("loadseg: address should exist");
    8000435c:	00004517          	auipc	a0,0x4
    80004360:	20450513          	addi	a0,a0,516 # 80008560 <etext+0x560>
    80004364:	00002097          	auipc	ra,0x2
    80004368:	b1e080e7          	jalr	-1250(ra) # 80005e82 <panic>
    if(sz - i < PGSIZE)
    8000436c:	2901                	sext.w	s2,s2
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    8000436e:	874a                	mv	a4,s2
    80004370:	009c06bb          	addw	a3,s8,s1
    80004374:	4581                	li	a1,0
    80004376:	8552                	mv	a0,s4
    80004378:	fffff097          	auipc	ra,0xfffff
    8000437c:	c10080e7          	jalr	-1008(ra) # 80002f88 <readi>
    80004380:	26a91163          	bne	s2,a0,800045e2 <exec+0x376>
  for(i = 0; i < sz; i += PGSIZE){
    80004384:	009a84bb          	addw	s1,s5,s1
    80004388:	0334f463          	bgeu	s1,s3,800043b0 <exec+0x144>
    pa = walkaddr(pagetable, va + i);
    8000438c:	02049593          	slli	a1,s1,0x20
    80004390:	9181                	srli	a1,a1,0x20
    80004392:	95de                	add	a1,a1,s7
    80004394:	855a                	mv	a0,s6
    80004396:	ffffc097          	auipc	ra,0xffffc
    8000439a:	28c080e7          	jalr	652(ra) # 80000622 <walkaddr>
    8000439e:	862a                	mv	a2,a0
    if(pa == 0)
    800043a0:	dd55                	beqz	a0,8000435c <exec+0xf0>
    if(sz - i < PGSIZE)
    800043a2:	409987bb          	subw	a5,s3,s1
    800043a6:	893e                	mv	s2,a5
    800043a8:	fcfcf2e3          	bgeu	s9,a5,8000436c <exec+0x100>
    800043ac:	8956                	mv	s2,s5
    800043ae:	bf7d                	j	8000436c <exec+0x100>
    sz = sz1;
    800043b0:	df843483          	ld	s1,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800043b4:	2d05                	addiw	s10,s10,1
    800043b6:	e0843783          	ld	a5,-504(s0)
    800043ba:	0387869b          	addiw	a3,a5,56
    800043be:	e8845783          	lhu	a5,-376(s0)
    800043c2:	06fd5d63          	bge	s10,a5,8000443c <exec+0x1d0>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800043c6:	e0d43423          	sd	a3,-504(s0)
    800043ca:	876e                	mv	a4,s11
    800043cc:	e1840613          	addi	a2,s0,-488
    800043d0:	4581                	li	a1,0
    800043d2:	8552                	mv	a0,s4
    800043d4:	fffff097          	auipc	ra,0xfffff
    800043d8:	bb4080e7          	jalr	-1100(ra) # 80002f88 <readi>
    800043dc:	21b51163          	bne	a0,s11,800045de <exec+0x372>
    if(ph.type != ELF_PROG_LOAD)
    800043e0:	e1842783          	lw	a5,-488(s0)
    800043e4:	4705                	li	a4,1
    800043e6:	fce797e3          	bne	a5,a4,800043b4 <exec+0x148>
    if(ph.memsz < ph.filesz)
    800043ea:	e4043603          	ld	a2,-448(s0)
    800043ee:	e3843783          	ld	a5,-456(s0)
    800043f2:	20f66863          	bltu	a2,a5,80004602 <exec+0x396>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800043f6:	e2843783          	ld	a5,-472(s0)
    800043fa:	963e                	add	a2,a2,a5
    800043fc:	20f66663          	bltu	a2,a5,80004608 <exec+0x39c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004400:	85a6                	mv	a1,s1
    80004402:	855a                	mv	a0,s6
    80004404:	ffffc097          	auipc	ra,0xffffc
    80004408:	5e2080e7          	jalr	1506(ra) # 800009e6 <uvmalloc>
    8000440c:	dea43c23          	sd	a0,-520(s0)
    80004410:	1e050f63          	beqz	a0,8000460e <exec+0x3a2>
    if((ph.vaddr % PGSIZE) != 0)
    80004414:	e2843b83          	ld	s7,-472(s0)
    80004418:	de843783          	ld	a5,-536(s0)
    8000441c:	00fbf7b3          	and	a5,s7,a5
    80004420:	1c079163          	bnez	a5,800045e2 <exec+0x376>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004424:	e2042c03          	lw	s8,-480(s0)
    80004428:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    8000442c:	00098463          	beqz	s3,80004434 <exec+0x1c8>
    80004430:	4481                	li	s1,0
    80004432:	bfa9                	j	8000438c <exec+0x120>
    sz = sz1;
    80004434:	df843483          	ld	s1,-520(s0)
    80004438:	bfb5                	j	800043b4 <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000443a:	4481                	li	s1,0
  iunlockput(ip);
    8000443c:	8552                	mv	a0,s4
    8000443e:	fffff097          	auipc	ra,0xfffff
    80004442:	af4080e7          	jalr	-1292(ra) # 80002f32 <iunlockput>
  end_op();
    80004446:	fffff097          	auipc	ra,0xfffff
    8000444a:	2f2080e7          	jalr	754(ra) # 80003738 <end_op>
  p = myproc();
    8000444e:	ffffd097          	auipc	ra,0xffffd
    80004452:	b94080e7          	jalr	-1132(ra) # 80000fe2 <myproc>
    80004456:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004458:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    8000445c:	6985                	lui	s3,0x1
    8000445e:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80004460:	99a6                	add	s3,s3,s1
    80004462:	77fd                	lui	a5,0xfffff
    80004464:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004468:	6609                	lui	a2,0x2
    8000446a:	964e                	add	a2,a2,s3
    8000446c:	85ce                	mv	a1,s3
    8000446e:	855a                	mv	a0,s6
    80004470:	ffffc097          	auipc	ra,0xffffc
    80004474:	576080e7          	jalr	1398(ra) # 800009e6 <uvmalloc>
    80004478:	8a2a                	mv	s4,a0
    8000447a:	e115                	bnez	a0,8000449e <exec+0x232>
    proc_freepagetable(pagetable, sz);
    8000447c:	85ce                	mv	a1,s3
    8000447e:	855a                	mv	a0,s6
    80004480:	ffffd097          	auipc	ra,0xffffd
    80004484:	cc2080e7          	jalr	-830(ra) # 80001142 <proc_freepagetable>
  return -1;
    80004488:	557d                	li	a0,-1
    8000448a:	79fe                	ld	s3,504(sp)
    8000448c:	7a5e                	ld	s4,496(sp)
    8000448e:	7abe                	ld	s5,488(sp)
    80004490:	7b1e                	ld	s6,480(sp)
    80004492:	6bfe                	ld	s7,472(sp)
    80004494:	6c5e                	ld	s8,464(sp)
    80004496:	6cbe                	ld	s9,456(sp)
    80004498:	6d1e                	ld	s10,448(sp)
    8000449a:	7dfa                	ld	s11,440(sp)
    8000449c:	bdb9                	j	800042fa <exec+0x8e>
  uvmclear(pagetable, sz-2*PGSIZE);
    8000449e:	75f9                	lui	a1,0xffffe
    800044a0:	95aa                	add	a1,a1,a0
    800044a2:	855a                	mv	a0,s6
    800044a4:	ffffc097          	auipc	ra,0xffffc
    800044a8:	7a4080e7          	jalr	1956(ra) # 80000c48 <uvmclear>
  stackbase = sp - PGSIZE;
    800044ac:	7bfd                	lui	s7,0xfffff
    800044ae:	9bd2                	add	s7,s7,s4
  for(argc = 0; argv[argc]; argc++) {
    800044b0:	e0043783          	ld	a5,-512(s0)
    800044b4:	6388                	ld	a0,0(a5)
  sp = sz;
    800044b6:	8952                	mv	s2,s4
  for(argc = 0; argv[argc]; argc++) {
    800044b8:	4481                	li	s1,0
    ustack[argc] = sp;
    800044ba:	e9040c93          	addi	s9,s0,-368
    if(argc >= MAXARG)
    800044be:	02000c13          	li	s8,32
  for(argc = 0; argv[argc]; argc++) {
    800044c2:	c135                	beqz	a0,80004526 <exec+0x2ba>
    sp -= strlen(argv[argc]) + 1;
    800044c4:	ffffc097          	auipc	ra,0xffffc
    800044c8:	f4c080e7          	jalr	-180(ra) # 80000410 <strlen>
    800044cc:	0015079b          	addiw	a5,a0,1
    800044d0:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800044d4:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    800044d8:	13796e63          	bltu	s2,s7,80004614 <exec+0x3a8>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800044dc:	e0043d83          	ld	s11,-512(s0)
    800044e0:	000db983          	ld	s3,0(s11) # fffffffffffff000 <end+0xffffffff7ffb8dc0>
    800044e4:	854e                	mv	a0,s3
    800044e6:	ffffc097          	auipc	ra,0xffffc
    800044ea:	f2a080e7          	jalr	-214(ra) # 80000410 <strlen>
    800044ee:	0015069b          	addiw	a3,a0,1
    800044f2:	864e                	mv	a2,s3
    800044f4:	85ca                	mv	a1,s2
    800044f6:	855a                	mv	a0,s6
    800044f8:	ffffc097          	auipc	ra,0xffffc
    800044fc:	782080e7          	jalr	1922(ra) # 80000c7a <copyout>
    80004500:	10054c63          	bltz	a0,80004618 <exec+0x3ac>
    ustack[argc] = sp;
    80004504:	00349793          	slli	a5,s1,0x3
    80004508:	97e6                	add	a5,a5,s9
    8000450a:	0127b023          	sd	s2,0(a5) # fffffffffffff000 <end+0xffffffff7ffb8dc0>
  for(argc = 0; argv[argc]; argc++) {
    8000450e:	0485                	addi	s1,s1,1
    80004510:	008d8793          	addi	a5,s11,8
    80004514:	e0f43023          	sd	a5,-512(s0)
    80004518:	008db503          	ld	a0,8(s11)
    8000451c:	c509                	beqz	a0,80004526 <exec+0x2ba>
    if(argc >= MAXARG)
    8000451e:	fb8493e3          	bne	s1,s8,800044c4 <exec+0x258>
  sz = sz1;
    80004522:	89d2                	mv	s3,s4
    80004524:	bfa1                	j	8000447c <exec+0x210>
  ustack[argc] = 0;
    80004526:	00349793          	slli	a5,s1,0x3
    8000452a:	f9078793          	addi	a5,a5,-112
    8000452e:	97a2                	add	a5,a5,s0
    80004530:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004534:	00148693          	addi	a3,s1,1
    80004538:	068e                	slli	a3,a3,0x3
    8000453a:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    8000453e:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80004542:	89d2                	mv	s3,s4
  if(sp < stackbase)
    80004544:	f3796ce3          	bltu	s2,s7,8000447c <exec+0x210>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004548:	e9040613          	addi	a2,s0,-368
    8000454c:	85ca                	mv	a1,s2
    8000454e:	855a                	mv	a0,s6
    80004550:	ffffc097          	auipc	ra,0xffffc
    80004554:	72a080e7          	jalr	1834(ra) # 80000c7a <copyout>
    80004558:	f20542e3          	bltz	a0,8000447c <exec+0x210>
  p->trapframe->a1 = sp;
    8000455c:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80004560:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004564:	df043783          	ld	a5,-528(s0)
    80004568:	0007c703          	lbu	a4,0(a5)
    8000456c:	cf11                	beqz	a4,80004588 <exec+0x31c>
    8000456e:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004570:	02f00693          	li	a3,47
    80004574:	a029                	j	8000457e <exec+0x312>
  for(last=s=path; *s; s++)
    80004576:	0785                	addi	a5,a5,1
    80004578:	fff7c703          	lbu	a4,-1(a5)
    8000457c:	c711                	beqz	a4,80004588 <exec+0x31c>
    if(*s == '/')
    8000457e:	fed71ce3          	bne	a4,a3,80004576 <exec+0x30a>
      last = s+1;
    80004582:	def43823          	sd	a5,-528(s0)
    80004586:	bfc5                	j	80004576 <exec+0x30a>
  safestrcpy(p->name, last, sizeof(p->name));
    80004588:	4641                	li	a2,16
    8000458a:	df043583          	ld	a1,-528(s0)
    8000458e:	158a8513          	addi	a0,s5,344
    80004592:	ffffc097          	auipc	ra,0xffffc
    80004596:	e48080e7          	jalr	-440(ra) # 800003da <safestrcpy>
  oldpagetable = p->pagetable;
    8000459a:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    8000459e:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    800045a2:	054ab423          	sd	s4,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800045a6:	058ab783          	ld	a5,88(s5)
    800045aa:	e6843703          	ld	a4,-408(s0)
    800045ae:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800045b0:	058ab783          	ld	a5,88(s5)
    800045b4:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800045b8:	85ea                	mv	a1,s10
    800045ba:	ffffd097          	auipc	ra,0xffffd
    800045be:	b88080e7          	jalr	-1144(ra) # 80001142 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800045c2:	0004851b          	sext.w	a0,s1
    800045c6:	79fe                	ld	s3,504(sp)
    800045c8:	7a5e                	ld	s4,496(sp)
    800045ca:	7abe                	ld	s5,488(sp)
    800045cc:	7b1e                	ld	s6,480(sp)
    800045ce:	6bfe                	ld	s7,472(sp)
    800045d0:	6c5e                	ld	s8,464(sp)
    800045d2:	6cbe                	ld	s9,456(sp)
    800045d4:	6d1e                	ld	s10,448(sp)
    800045d6:	7dfa                	ld	s11,440(sp)
    800045d8:	b30d                	j	800042fa <exec+0x8e>
    800045da:	7b1e                	ld	s6,480(sp)
    800045dc:	b321                	j	800042e4 <exec+0x78>
    800045de:	de943c23          	sd	s1,-520(s0)
    proc_freepagetable(pagetable, sz);
    800045e2:	df843583          	ld	a1,-520(s0)
    800045e6:	855a                	mv	a0,s6
    800045e8:	ffffd097          	auipc	ra,0xffffd
    800045ec:	b5a080e7          	jalr	-1190(ra) # 80001142 <proc_freepagetable>
  if(ip){
    800045f0:	79fe                	ld	s3,504(sp)
    800045f2:	7abe                	ld	s5,488(sp)
    800045f4:	7b1e                	ld	s6,480(sp)
    800045f6:	6bfe                	ld	s7,472(sp)
    800045f8:	6c5e                	ld	s8,464(sp)
    800045fa:	6cbe                	ld	s9,456(sp)
    800045fc:	6d1e                	ld	s10,448(sp)
    800045fe:	7dfa                	ld	s11,440(sp)
    80004600:	b1d5                	j	800042e4 <exec+0x78>
    80004602:	de943c23          	sd	s1,-520(s0)
    80004606:	bff1                	j	800045e2 <exec+0x376>
    80004608:	de943c23          	sd	s1,-520(s0)
    8000460c:	bfd9                	j	800045e2 <exec+0x376>
    8000460e:	de943c23          	sd	s1,-520(s0)
    80004612:	bfc1                	j	800045e2 <exec+0x376>
  sz = sz1;
    80004614:	89d2                	mv	s3,s4
    80004616:	b59d                	j	8000447c <exec+0x210>
    80004618:	89d2                	mv	s3,s4
    8000461a:	b58d                	j	8000447c <exec+0x210>

000000008000461c <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000461c:	7179                	addi	sp,sp,-48
    8000461e:	f406                	sd	ra,40(sp)
    80004620:	f022                	sd	s0,32(sp)
    80004622:	ec26                	sd	s1,24(sp)
    80004624:	e84a                	sd	s2,16(sp)
    80004626:	1800                	addi	s0,sp,48
    80004628:	892e                	mv	s2,a1
    8000462a:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    8000462c:	fdc40593          	addi	a1,s0,-36
    80004630:	ffffe097          	auipc	ra,0xffffe
    80004634:	b48080e7          	jalr	-1208(ra) # 80002178 <argint>
    80004638:	04054063          	bltz	a0,80004678 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000463c:	fdc42703          	lw	a4,-36(s0)
    80004640:	47bd                	li	a5,15
    80004642:	02e7ed63          	bltu	a5,a4,8000467c <argfd+0x60>
    80004646:	ffffd097          	auipc	ra,0xffffd
    8000464a:	99c080e7          	jalr	-1636(ra) # 80000fe2 <myproc>
    8000464e:	fdc42703          	lw	a4,-36(s0)
    80004652:	01a70793          	addi	a5,a4,26
    80004656:	078e                	slli	a5,a5,0x3
    80004658:	953e                	add	a0,a0,a5
    8000465a:	611c                	ld	a5,0(a0)
    8000465c:	c395                	beqz	a5,80004680 <argfd+0x64>
    return -1;
  if(pfd)
    8000465e:	00090463          	beqz	s2,80004666 <argfd+0x4a>
    *pfd = fd;
    80004662:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004666:	4501                	li	a0,0
  if(pf)
    80004668:	c091                	beqz	s1,8000466c <argfd+0x50>
    *pf = f;
    8000466a:	e09c                	sd	a5,0(s1)
}
    8000466c:	70a2                	ld	ra,40(sp)
    8000466e:	7402                	ld	s0,32(sp)
    80004670:	64e2                	ld	s1,24(sp)
    80004672:	6942                	ld	s2,16(sp)
    80004674:	6145                	addi	sp,sp,48
    80004676:	8082                	ret
    return -1;
    80004678:	557d                	li	a0,-1
    8000467a:	bfcd                	j	8000466c <argfd+0x50>
    return -1;
    8000467c:	557d                	li	a0,-1
    8000467e:	b7fd                	j	8000466c <argfd+0x50>
    80004680:	557d                	li	a0,-1
    80004682:	b7ed                	j	8000466c <argfd+0x50>

0000000080004684 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004684:	1101                	addi	sp,sp,-32
    80004686:	ec06                	sd	ra,24(sp)
    80004688:	e822                	sd	s0,16(sp)
    8000468a:	e426                	sd	s1,8(sp)
    8000468c:	1000                	addi	s0,sp,32
    8000468e:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004690:	ffffd097          	auipc	ra,0xffffd
    80004694:	952080e7          	jalr	-1710(ra) # 80000fe2 <myproc>
    80004698:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    8000469a:	0d050793          	addi	a5,a0,208
    8000469e:	4501                	li	a0,0
    800046a0:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800046a2:	6398                	ld	a4,0(a5)
    800046a4:	cb19                	beqz	a4,800046ba <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800046a6:	2505                	addiw	a0,a0,1
    800046a8:	07a1                	addi	a5,a5,8
    800046aa:	fed51ce3          	bne	a0,a3,800046a2 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800046ae:	557d                	li	a0,-1
}
    800046b0:	60e2                	ld	ra,24(sp)
    800046b2:	6442                	ld	s0,16(sp)
    800046b4:	64a2                	ld	s1,8(sp)
    800046b6:	6105                	addi	sp,sp,32
    800046b8:	8082                	ret
      p->ofile[fd] = f;
    800046ba:	01a50793          	addi	a5,a0,26
    800046be:	078e                	slli	a5,a5,0x3
    800046c0:	963e                	add	a2,a2,a5
    800046c2:	e204                	sd	s1,0(a2)
      return fd;
    800046c4:	b7f5                	j	800046b0 <fdalloc+0x2c>

00000000800046c6 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800046c6:	715d                	addi	sp,sp,-80
    800046c8:	e486                	sd	ra,72(sp)
    800046ca:	e0a2                	sd	s0,64(sp)
    800046cc:	fc26                	sd	s1,56(sp)
    800046ce:	f84a                	sd	s2,48(sp)
    800046d0:	f44e                	sd	s3,40(sp)
    800046d2:	f052                	sd	s4,32(sp)
    800046d4:	ec56                	sd	s5,24(sp)
    800046d6:	0880                	addi	s0,sp,80
    800046d8:	8aae                	mv	s5,a1
    800046da:	8a32                	mv	s4,a2
    800046dc:	89b6                	mv	s3,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800046de:	fb040593          	addi	a1,s0,-80
    800046e2:	fffff097          	auipc	ra,0xfffff
    800046e6:	df4080e7          	jalr	-524(ra) # 800034d6 <nameiparent>
    800046ea:	892a                	mv	s2,a0
    800046ec:	12050c63          	beqz	a0,80004824 <create+0x15e>
    return 0;

  ilock(dp);
    800046f0:	ffffe097          	auipc	ra,0xffffe
    800046f4:	5dc080e7          	jalr	1500(ra) # 80002ccc <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800046f8:	4601                	li	a2,0
    800046fa:	fb040593          	addi	a1,s0,-80
    800046fe:	854a                	mv	a0,s2
    80004700:	fffff097          	auipc	ra,0xfffff
    80004704:	abc080e7          	jalr	-1348(ra) # 800031bc <dirlookup>
    80004708:	84aa                	mv	s1,a0
    8000470a:	c539                	beqz	a0,80004758 <create+0x92>
    iunlockput(dp);
    8000470c:	854a                	mv	a0,s2
    8000470e:	fffff097          	auipc	ra,0xfffff
    80004712:	824080e7          	jalr	-2012(ra) # 80002f32 <iunlockput>
    ilock(ip);
    80004716:	8526                	mv	a0,s1
    80004718:	ffffe097          	auipc	ra,0xffffe
    8000471c:	5b4080e7          	jalr	1460(ra) # 80002ccc <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004720:	4789                	li	a5,2
    80004722:	02fa9463          	bne	s5,a5,8000474a <create+0x84>
    80004726:	0444d783          	lhu	a5,68(s1)
    8000472a:	37f9                	addiw	a5,a5,-2
    8000472c:	17c2                	slli	a5,a5,0x30
    8000472e:	93c1                	srli	a5,a5,0x30
    80004730:	4705                	li	a4,1
    80004732:	00f76c63          	bltu	a4,a5,8000474a <create+0x84>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80004736:	8526                	mv	a0,s1
    80004738:	60a6                	ld	ra,72(sp)
    8000473a:	6406                	ld	s0,64(sp)
    8000473c:	74e2                	ld	s1,56(sp)
    8000473e:	7942                	ld	s2,48(sp)
    80004740:	79a2                	ld	s3,40(sp)
    80004742:	7a02                	ld	s4,32(sp)
    80004744:	6ae2                	ld	s5,24(sp)
    80004746:	6161                	addi	sp,sp,80
    80004748:	8082                	ret
    iunlockput(ip);
    8000474a:	8526                	mv	a0,s1
    8000474c:	ffffe097          	auipc	ra,0xffffe
    80004750:	7e6080e7          	jalr	2022(ra) # 80002f32 <iunlockput>
    return 0;
    80004754:	4481                	li	s1,0
    80004756:	b7c5                	j	80004736 <create+0x70>
  if((ip = ialloc(dp->dev, type)) == 0)
    80004758:	85d6                	mv	a1,s5
    8000475a:	00092503          	lw	a0,0(s2)
    8000475e:	ffffe097          	auipc	ra,0xffffe
    80004762:	3da080e7          	jalr	986(ra) # 80002b38 <ialloc>
    80004766:	84aa                	mv	s1,a0
    80004768:	c139                	beqz	a0,800047ae <create+0xe8>
  ilock(ip);
    8000476a:	ffffe097          	auipc	ra,0xffffe
    8000476e:	562080e7          	jalr	1378(ra) # 80002ccc <ilock>
  ip->major = major;
    80004772:	05449323          	sh	s4,70(s1)
  ip->minor = minor;
    80004776:	05349423          	sh	s3,72(s1)
  ip->nlink = 1;
    8000477a:	4985                	li	s3,1
    8000477c:	05349523          	sh	s3,74(s1)
  iupdate(ip);
    80004780:	8526                	mv	a0,s1
    80004782:	ffffe097          	auipc	ra,0xffffe
    80004786:	47e080e7          	jalr	1150(ra) # 80002c00 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    8000478a:	033a8a63          	beq	s5,s3,800047be <create+0xf8>
  if(dirlink(dp, name, ip->inum) < 0)
    8000478e:	40d0                	lw	a2,4(s1)
    80004790:	fb040593          	addi	a1,s0,-80
    80004794:	854a                	mv	a0,s2
    80004796:	fffff097          	auipc	ra,0xfffff
    8000479a:	c4c080e7          	jalr	-948(ra) # 800033e2 <dirlink>
    8000479e:	06054b63          	bltz	a0,80004814 <create+0x14e>
  iunlockput(dp);
    800047a2:	854a                	mv	a0,s2
    800047a4:	ffffe097          	auipc	ra,0xffffe
    800047a8:	78e080e7          	jalr	1934(ra) # 80002f32 <iunlockput>
  return ip;
    800047ac:	b769                	j	80004736 <create+0x70>
    panic("create: ialloc");
    800047ae:	00004517          	auipc	a0,0x4
    800047b2:	dd250513          	addi	a0,a0,-558 # 80008580 <etext+0x580>
    800047b6:	00001097          	auipc	ra,0x1
    800047ba:	6cc080e7          	jalr	1740(ra) # 80005e82 <panic>
    dp->nlink++;  // for ".."
    800047be:	04a95783          	lhu	a5,74(s2)
    800047c2:	2785                	addiw	a5,a5,1
    800047c4:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    800047c8:	854a                	mv	a0,s2
    800047ca:	ffffe097          	auipc	ra,0xffffe
    800047ce:	436080e7          	jalr	1078(ra) # 80002c00 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800047d2:	40d0                	lw	a2,4(s1)
    800047d4:	00004597          	auipc	a1,0x4
    800047d8:	dbc58593          	addi	a1,a1,-580 # 80008590 <etext+0x590>
    800047dc:	8526                	mv	a0,s1
    800047de:	fffff097          	auipc	ra,0xfffff
    800047e2:	c04080e7          	jalr	-1020(ra) # 800033e2 <dirlink>
    800047e6:	00054f63          	bltz	a0,80004804 <create+0x13e>
    800047ea:	00492603          	lw	a2,4(s2)
    800047ee:	00004597          	auipc	a1,0x4
    800047f2:	daa58593          	addi	a1,a1,-598 # 80008598 <etext+0x598>
    800047f6:	8526                	mv	a0,s1
    800047f8:	fffff097          	auipc	ra,0xfffff
    800047fc:	bea080e7          	jalr	-1046(ra) # 800033e2 <dirlink>
    80004800:	f80557e3          	bgez	a0,8000478e <create+0xc8>
      panic("create dots");
    80004804:	00004517          	auipc	a0,0x4
    80004808:	d9c50513          	addi	a0,a0,-612 # 800085a0 <etext+0x5a0>
    8000480c:	00001097          	auipc	ra,0x1
    80004810:	676080e7          	jalr	1654(ra) # 80005e82 <panic>
    panic("create: dirlink");
    80004814:	00004517          	auipc	a0,0x4
    80004818:	d9c50513          	addi	a0,a0,-612 # 800085b0 <etext+0x5b0>
    8000481c:	00001097          	auipc	ra,0x1
    80004820:	666080e7          	jalr	1638(ra) # 80005e82 <panic>
    return 0;
    80004824:	84aa                	mv	s1,a0
    80004826:	bf01                	j	80004736 <create+0x70>

0000000080004828 <sys_dup>:
{
    80004828:	7179                	addi	sp,sp,-48
    8000482a:	f406                	sd	ra,40(sp)
    8000482c:	f022                	sd	s0,32(sp)
    8000482e:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004830:	fd840613          	addi	a2,s0,-40
    80004834:	4581                	li	a1,0
    80004836:	4501                	li	a0,0
    80004838:	00000097          	auipc	ra,0x0
    8000483c:	de4080e7          	jalr	-540(ra) # 8000461c <argfd>
    return -1;
    80004840:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004842:	02054763          	bltz	a0,80004870 <sys_dup+0x48>
    80004846:	ec26                	sd	s1,24(sp)
    80004848:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    8000484a:	fd843903          	ld	s2,-40(s0)
    8000484e:	854a                	mv	a0,s2
    80004850:	00000097          	auipc	ra,0x0
    80004854:	e34080e7          	jalr	-460(ra) # 80004684 <fdalloc>
    80004858:	84aa                	mv	s1,a0
    return -1;
    8000485a:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    8000485c:	00054f63          	bltz	a0,8000487a <sys_dup+0x52>
  filedup(f);
    80004860:	854a                	mv	a0,s2
    80004862:	fffff097          	auipc	ra,0xfffff
    80004866:	2da080e7          	jalr	730(ra) # 80003b3c <filedup>
  return fd;
    8000486a:	87a6                	mv	a5,s1
    8000486c:	64e2                	ld	s1,24(sp)
    8000486e:	6942                	ld	s2,16(sp)
}
    80004870:	853e                	mv	a0,a5
    80004872:	70a2                	ld	ra,40(sp)
    80004874:	7402                	ld	s0,32(sp)
    80004876:	6145                	addi	sp,sp,48
    80004878:	8082                	ret
    8000487a:	64e2                	ld	s1,24(sp)
    8000487c:	6942                	ld	s2,16(sp)
    8000487e:	bfcd                	j	80004870 <sys_dup+0x48>

0000000080004880 <sys_read>:
{
    80004880:	7179                	addi	sp,sp,-48
    80004882:	f406                	sd	ra,40(sp)
    80004884:	f022                	sd	s0,32(sp)
    80004886:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004888:	fe840613          	addi	a2,s0,-24
    8000488c:	4581                	li	a1,0
    8000488e:	4501                	li	a0,0
    80004890:	00000097          	auipc	ra,0x0
    80004894:	d8c080e7          	jalr	-628(ra) # 8000461c <argfd>
    return -1;
    80004898:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000489a:	04054163          	bltz	a0,800048dc <sys_read+0x5c>
    8000489e:	fe440593          	addi	a1,s0,-28
    800048a2:	4509                	li	a0,2
    800048a4:	ffffe097          	auipc	ra,0xffffe
    800048a8:	8d4080e7          	jalr	-1836(ra) # 80002178 <argint>
    return -1;
    800048ac:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048ae:	02054763          	bltz	a0,800048dc <sys_read+0x5c>
    800048b2:	fd840593          	addi	a1,s0,-40
    800048b6:	4505                	li	a0,1
    800048b8:	ffffe097          	auipc	ra,0xffffe
    800048bc:	8e2080e7          	jalr	-1822(ra) # 8000219a <argaddr>
    return -1;
    800048c0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048c2:	00054d63          	bltz	a0,800048dc <sys_read+0x5c>
  return fileread(f, p, n);
    800048c6:	fe442603          	lw	a2,-28(s0)
    800048ca:	fd843583          	ld	a1,-40(s0)
    800048ce:	fe843503          	ld	a0,-24(s0)
    800048d2:	fffff097          	auipc	ra,0xfffff
    800048d6:	410080e7          	jalr	1040(ra) # 80003ce2 <fileread>
    800048da:	87aa                	mv	a5,a0
}
    800048dc:	853e                	mv	a0,a5
    800048de:	70a2                	ld	ra,40(sp)
    800048e0:	7402                	ld	s0,32(sp)
    800048e2:	6145                	addi	sp,sp,48
    800048e4:	8082                	ret

00000000800048e6 <sys_write>:
{
    800048e6:	7179                	addi	sp,sp,-48
    800048e8:	f406                	sd	ra,40(sp)
    800048ea:	f022                	sd	s0,32(sp)
    800048ec:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048ee:	fe840613          	addi	a2,s0,-24
    800048f2:	4581                	li	a1,0
    800048f4:	4501                	li	a0,0
    800048f6:	00000097          	auipc	ra,0x0
    800048fa:	d26080e7          	jalr	-730(ra) # 8000461c <argfd>
    return -1;
    800048fe:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004900:	04054163          	bltz	a0,80004942 <sys_write+0x5c>
    80004904:	fe440593          	addi	a1,s0,-28
    80004908:	4509                	li	a0,2
    8000490a:	ffffe097          	auipc	ra,0xffffe
    8000490e:	86e080e7          	jalr	-1938(ra) # 80002178 <argint>
    return -1;
    80004912:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004914:	02054763          	bltz	a0,80004942 <sys_write+0x5c>
    80004918:	fd840593          	addi	a1,s0,-40
    8000491c:	4505                	li	a0,1
    8000491e:	ffffe097          	auipc	ra,0xffffe
    80004922:	87c080e7          	jalr	-1924(ra) # 8000219a <argaddr>
    return -1;
    80004926:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004928:	00054d63          	bltz	a0,80004942 <sys_write+0x5c>
  return filewrite(f, p, n);
    8000492c:	fe442603          	lw	a2,-28(s0)
    80004930:	fd843583          	ld	a1,-40(s0)
    80004934:	fe843503          	ld	a0,-24(s0)
    80004938:	fffff097          	auipc	ra,0xfffff
    8000493c:	47c080e7          	jalr	1148(ra) # 80003db4 <filewrite>
    80004940:	87aa                	mv	a5,a0
}
    80004942:	853e                	mv	a0,a5
    80004944:	70a2                	ld	ra,40(sp)
    80004946:	7402                	ld	s0,32(sp)
    80004948:	6145                	addi	sp,sp,48
    8000494a:	8082                	ret

000000008000494c <sys_close>:
{
    8000494c:	1101                	addi	sp,sp,-32
    8000494e:	ec06                	sd	ra,24(sp)
    80004950:	e822                	sd	s0,16(sp)
    80004952:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004954:	fe040613          	addi	a2,s0,-32
    80004958:	fec40593          	addi	a1,s0,-20
    8000495c:	4501                	li	a0,0
    8000495e:	00000097          	auipc	ra,0x0
    80004962:	cbe080e7          	jalr	-834(ra) # 8000461c <argfd>
    return -1;
    80004966:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004968:	02054463          	bltz	a0,80004990 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    8000496c:	ffffc097          	auipc	ra,0xffffc
    80004970:	676080e7          	jalr	1654(ra) # 80000fe2 <myproc>
    80004974:	fec42783          	lw	a5,-20(s0)
    80004978:	07e9                	addi	a5,a5,26
    8000497a:	078e                	slli	a5,a5,0x3
    8000497c:	953e                	add	a0,a0,a5
    8000497e:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004982:	fe043503          	ld	a0,-32(s0)
    80004986:	fffff097          	auipc	ra,0xfffff
    8000498a:	208080e7          	jalr	520(ra) # 80003b8e <fileclose>
  return 0;
    8000498e:	4781                	li	a5,0
}
    80004990:	853e                	mv	a0,a5
    80004992:	60e2                	ld	ra,24(sp)
    80004994:	6442                	ld	s0,16(sp)
    80004996:	6105                	addi	sp,sp,32
    80004998:	8082                	ret

000000008000499a <sys_fstat>:
{
    8000499a:	1101                	addi	sp,sp,-32
    8000499c:	ec06                	sd	ra,24(sp)
    8000499e:	e822                	sd	s0,16(sp)
    800049a0:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800049a2:	fe840613          	addi	a2,s0,-24
    800049a6:	4581                	li	a1,0
    800049a8:	4501                	li	a0,0
    800049aa:	00000097          	auipc	ra,0x0
    800049ae:	c72080e7          	jalr	-910(ra) # 8000461c <argfd>
    return -1;
    800049b2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800049b4:	02054563          	bltz	a0,800049de <sys_fstat+0x44>
    800049b8:	fe040593          	addi	a1,s0,-32
    800049bc:	4505                	li	a0,1
    800049be:	ffffd097          	auipc	ra,0xffffd
    800049c2:	7dc080e7          	jalr	2012(ra) # 8000219a <argaddr>
    return -1;
    800049c6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800049c8:	00054b63          	bltz	a0,800049de <sys_fstat+0x44>
  return filestat(f, st);
    800049cc:	fe043583          	ld	a1,-32(s0)
    800049d0:	fe843503          	ld	a0,-24(s0)
    800049d4:	fffff097          	auipc	ra,0xfffff
    800049d8:	298080e7          	jalr	664(ra) # 80003c6c <filestat>
    800049dc:	87aa                	mv	a5,a0
}
    800049de:	853e                	mv	a0,a5
    800049e0:	60e2                	ld	ra,24(sp)
    800049e2:	6442                	ld	s0,16(sp)
    800049e4:	6105                	addi	sp,sp,32
    800049e6:	8082                	ret

00000000800049e8 <sys_link>:
{
    800049e8:	7169                	addi	sp,sp,-304
    800049ea:	f606                	sd	ra,296(sp)
    800049ec:	f222                	sd	s0,288(sp)
    800049ee:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800049f0:	08000613          	li	a2,128
    800049f4:	ed040593          	addi	a1,s0,-304
    800049f8:	4501                	li	a0,0
    800049fa:	ffffd097          	auipc	ra,0xffffd
    800049fe:	7c2080e7          	jalr	1986(ra) # 800021bc <argstr>
    return -1;
    80004a02:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a04:	12054663          	bltz	a0,80004b30 <sys_link+0x148>
    80004a08:	08000613          	li	a2,128
    80004a0c:	f5040593          	addi	a1,s0,-176
    80004a10:	4505                	li	a0,1
    80004a12:	ffffd097          	auipc	ra,0xffffd
    80004a16:	7aa080e7          	jalr	1962(ra) # 800021bc <argstr>
    return -1;
    80004a1a:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a1c:	10054a63          	bltz	a0,80004b30 <sys_link+0x148>
    80004a20:	ee26                	sd	s1,280(sp)
  begin_op();
    80004a22:	fffff097          	auipc	ra,0xfffff
    80004a26:	c9c080e7          	jalr	-868(ra) # 800036be <begin_op>
  if((ip = namei(old)) == 0){
    80004a2a:	ed040513          	addi	a0,s0,-304
    80004a2e:	fffff097          	auipc	ra,0xfffff
    80004a32:	a8a080e7          	jalr	-1398(ra) # 800034b8 <namei>
    80004a36:	84aa                	mv	s1,a0
    80004a38:	c949                	beqz	a0,80004aca <sys_link+0xe2>
  ilock(ip);
    80004a3a:	ffffe097          	auipc	ra,0xffffe
    80004a3e:	292080e7          	jalr	658(ra) # 80002ccc <ilock>
  if(ip->type == T_DIR){
    80004a42:	04449703          	lh	a4,68(s1)
    80004a46:	4785                	li	a5,1
    80004a48:	08f70863          	beq	a4,a5,80004ad8 <sys_link+0xf0>
    80004a4c:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004a4e:	04a4d783          	lhu	a5,74(s1)
    80004a52:	2785                	addiw	a5,a5,1
    80004a54:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004a58:	8526                	mv	a0,s1
    80004a5a:	ffffe097          	auipc	ra,0xffffe
    80004a5e:	1a6080e7          	jalr	422(ra) # 80002c00 <iupdate>
  iunlock(ip);
    80004a62:	8526                	mv	a0,s1
    80004a64:	ffffe097          	auipc	ra,0xffffe
    80004a68:	32e080e7          	jalr	814(ra) # 80002d92 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004a6c:	fd040593          	addi	a1,s0,-48
    80004a70:	f5040513          	addi	a0,s0,-176
    80004a74:	fffff097          	auipc	ra,0xfffff
    80004a78:	a62080e7          	jalr	-1438(ra) # 800034d6 <nameiparent>
    80004a7c:	892a                	mv	s2,a0
    80004a7e:	cd35                	beqz	a0,80004afa <sys_link+0x112>
  ilock(dp);
    80004a80:	ffffe097          	auipc	ra,0xffffe
    80004a84:	24c080e7          	jalr	588(ra) # 80002ccc <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004a88:	00092703          	lw	a4,0(s2)
    80004a8c:	409c                	lw	a5,0(s1)
    80004a8e:	06f71163          	bne	a4,a5,80004af0 <sys_link+0x108>
    80004a92:	40d0                	lw	a2,4(s1)
    80004a94:	fd040593          	addi	a1,s0,-48
    80004a98:	854a                	mv	a0,s2
    80004a9a:	fffff097          	auipc	ra,0xfffff
    80004a9e:	948080e7          	jalr	-1720(ra) # 800033e2 <dirlink>
    80004aa2:	04054763          	bltz	a0,80004af0 <sys_link+0x108>
  iunlockput(dp);
    80004aa6:	854a                	mv	a0,s2
    80004aa8:	ffffe097          	auipc	ra,0xffffe
    80004aac:	48a080e7          	jalr	1162(ra) # 80002f32 <iunlockput>
  iput(ip);
    80004ab0:	8526                	mv	a0,s1
    80004ab2:	ffffe097          	auipc	ra,0xffffe
    80004ab6:	3d8080e7          	jalr	984(ra) # 80002e8a <iput>
  end_op();
    80004aba:	fffff097          	auipc	ra,0xfffff
    80004abe:	c7e080e7          	jalr	-898(ra) # 80003738 <end_op>
  return 0;
    80004ac2:	4781                	li	a5,0
    80004ac4:	64f2                	ld	s1,280(sp)
    80004ac6:	6952                	ld	s2,272(sp)
    80004ac8:	a0a5                	j	80004b30 <sys_link+0x148>
    end_op();
    80004aca:	fffff097          	auipc	ra,0xfffff
    80004ace:	c6e080e7          	jalr	-914(ra) # 80003738 <end_op>
    return -1;
    80004ad2:	57fd                	li	a5,-1
    80004ad4:	64f2                	ld	s1,280(sp)
    80004ad6:	a8a9                	j	80004b30 <sys_link+0x148>
    iunlockput(ip);
    80004ad8:	8526                	mv	a0,s1
    80004ada:	ffffe097          	auipc	ra,0xffffe
    80004ade:	458080e7          	jalr	1112(ra) # 80002f32 <iunlockput>
    end_op();
    80004ae2:	fffff097          	auipc	ra,0xfffff
    80004ae6:	c56080e7          	jalr	-938(ra) # 80003738 <end_op>
    return -1;
    80004aea:	57fd                	li	a5,-1
    80004aec:	64f2                	ld	s1,280(sp)
    80004aee:	a089                	j	80004b30 <sys_link+0x148>
    iunlockput(dp);
    80004af0:	854a                	mv	a0,s2
    80004af2:	ffffe097          	auipc	ra,0xffffe
    80004af6:	440080e7          	jalr	1088(ra) # 80002f32 <iunlockput>
  ilock(ip);
    80004afa:	8526                	mv	a0,s1
    80004afc:	ffffe097          	auipc	ra,0xffffe
    80004b00:	1d0080e7          	jalr	464(ra) # 80002ccc <ilock>
  ip->nlink--;
    80004b04:	04a4d783          	lhu	a5,74(s1)
    80004b08:	37fd                	addiw	a5,a5,-1
    80004b0a:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004b0e:	8526                	mv	a0,s1
    80004b10:	ffffe097          	auipc	ra,0xffffe
    80004b14:	0f0080e7          	jalr	240(ra) # 80002c00 <iupdate>
  iunlockput(ip);
    80004b18:	8526                	mv	a0,s1
    80004b1a:	ffffe097          	auipc	ra,0xffffe
    80004b1e:	418080e7          	jalr	1048(ra) # 80002f32 <iunlockput>
  end_op();
    80004b22:	fffff097          	auipc	ra,0xfffff
    80004b26:	c16080e7          	jalr	-1002(ra) # 80003738 <end_op>
  return -1;
    80004b2a:	57fd                	li	a5,-1
    80004b2c:	64f2                	ld	s1,280(sp)
    80004b2e:	6952                	ld	s2,272(sp)
}
    80004b30:	853e                	mv	a0,a5
    80004b32:	70b2                	ld	ra,296(sp)
    80004b34:	7412                	ld	s0,288(sp)
    80004b36:	6155                	addi	sp,sp,304
    80004b38:	8082                	ret

0000000080004b3a <sys_unlink>:
{
    80004b3a:	7111                	addi	sp,sp,-256
    80004b3c:	fd86                	sd	ra,248(sp)
    80004b3e:	f9a2                	sd	s0,240(sp)
    80004b40:	0200                	addi	s0,sp,256
  if(argstr(0, path, MAXPATH) < 0)
    80004b42:	08000613          	li	a2,128
    80004b46:	f2040593          	addi	a1,s0,-224
    80004b4a:	4501                	li	a0,0
    80004b4c:	ffffd097          	auipc	ra,0xffffd
    80004b50:	670080e7          	jalr	1648(ra) # 800021bc <argstr>
    80004b54:	1c054063          	bltz	a0,80004d14 <sys_unlink+0x1da>
    80004b58:	f5a6                	sd	s1,232(sp)
  begin_op();
    80004b5a:	fffff097          	auipc	ra,0xfffff
    80004b5e:	b64080e7          	jalr	-1180(ra) # 800036be <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004b62:	fa040593          	addi	a1,s0,-96
    80004b66:	f2040513          	addi	a0,s0,-224
    80004b6a:	fffff097          	auipc	ra,0xfffff
    80004b6e:	96c080e7          	jalr	-1684(ra) # 800034d6 <nameiparent>
    80004b72:	84aa                	mv	s1,a0
    80004b74:	c165                	beqz	a0,80004c54 <sys_unlink+0x11a>
  ilock(dp);
    80004b76:	ffffe097          	auipc	ra,0xffffe
    80004b7a:	156080e7          	jalr	342(ra) # 80002ccc <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004b7e:	00004597          	auipc	a1,0x4
    80004b82:	a1258593          	addi	a1,a1,-1518 # 80008590 <etext+0x590>
    80004b86:	fa040513          	addi	a0,s0,-96
    80004b8a:	ffffe097          	auipc	ra,0xffffe
    80004b8e:	618080e7          	jalr	1560(ra) # 800031a2 <namecmp>
    80004b92:	16050263          	beqz	a0,80004cf6 <sys_unlink+0x1bc>
    80004b96:	00004597          	auipc	a1,0x4
    80004b9a:	a0258593          	addi	a1,a1,-1534 # 80008598 <etext+0x598>
    80004b9e:	fa040513          	addi	a0,s0,-96
    80004ba2:	ffffe097          	auipc	ra,0xffffe
    80004ba6:	600080e7          	jalr	1536(ra) # 800031a2 <namecmp>
    80004baa:	14050663          	beqz	a0,80004cf6 <sys_unlink+0x1bc>
    80004bae:	f1ca                	sd	s2,224(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004bb0:	f1c40613          	addi	a2,s0,-228
    80004bb4:	fa040593          	addi	a1,s0,-96
    80004bb8:	8526                	mv	a0,s1
    80004bba:	ffffe097          	auipc	ra,0xffffe
    80004bbe:	602080e7          	jalr	1538(ra) # 800031bc <dirlookup>
    80004bc2:	892a                	mv	s2,a0
    80004bc4:	12050863          	beqz	a0,80004cf4 <sys_unlink+0x1ba>
    80004bc8:	edce                	sd	s3,216(sp)
  ilock(ip);
    80004bca:	ffffe097          	auipc	ra,0xffffe
    80004bce:	102080e7          	jalr	258(ra) # 80002ccc <ilock>
  if(ip->nlink < 1)
    80004bd2:	04a91783          	lh	a5,74(s2)
    80004bd6:	08f05663          	blez	a5,80004c62 <sys_unlink+0x128>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004bda:	04491703          	lh	a4,68(s2)
    80004bde:	4785                	li	a5,1
    80004be0:	08f70b63          	beq	a4,a5,80004c76 <sys_unlink+0x13c>
  memset(&de, 0, sizeof(de));
    80004be4:	fb040993          	addi	s3,s0,-80
    80004be8:	4641                	li	a2,16
    80004bea:	4581                	li	a1,0
    80004bec:	854e                	mv	a0,s3
    80004bee:	ffffb097          	auipc	ra,0xffffb
    80004bf2:	696080e7          	jalr	1686(ra) # 80000284 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004bf6:	4741                	li	a4,16
    80004bf8:	f1c42683          	lw	a3,-228(s0)
    80004bfc:	864e                	mv	a2,s3
    80004bfe:	4581                	li	a1,0
    80004c00:	8526                	mv	a0,s1
    80004c02:	ffffe097          	auipc	ra,0xffffe
    80004c06:	480080e7          	jalr	1152(ra) # 80003082 <writei>
    80004c0a:	47c1                	li	a5,16
    80004c0c:	0af51f63          	bne	a0,a5,80004cca <sys_unlink+0x190>
  if(ip->type == T_DIR){
    80004c10:	04491703          	lh	a4,68(s2)
    80004c14:	4785                	li	a5,1
    80004c16:	0cf70463          	beq	a4,a5,80004cde <sys_unlink+0x1a4>
  iunlockput(dp);
    80004c1a:	8526                	mv	a0,s1
    80004c1c:	ffffe097          	auipc	ra,0xffffe
    80004c20:	316080e7          	jalr	790(ra) # 80002f32 <iunlockput>
  ip->nlink--;
    80004c24:	04a95783          	lhu	a5,74(s2)
    80004c28:	37fd                	addiw	a5,a5,-1
    80004c2a:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004c2e:	854a                	mv	a0,s2
    80004c30:	ffffe097          	auipc	ra,0xffffe
    80004c34:	fd0080e7          	jalr	-48(ra) # 80002c00 <iupdate>
  iunlockput(ip);
    80004c38:	854a                	mv	a0,s2
    80004c3a:	ffffe097          	auipc	ra,0xffffe
    80004c3e:	2f8080e7          	jalr	760(ra) # 80002f32 <iunlockput>
  end_op();
    80004c42:	fffff097          	auipc	ra,0xfffff
    80004c46:	af6080e7          	jalr	-1290(ra) # 80003738 <end_op>
  return 0;
    80004c4a:	4501                	li	a0,0
    80004c4c:	74ae                	ld	s1,232(sp)
    80004c4e:	790e                	ld	s2,224(sp)
    80004c50:	69ee                	ld	s3,216(sp)
    80004c52:	a86d                	j	80004d0c <sys_unlink+0x1d2>
    end_op();
    80004c54:	fffff097          	auipc	ra,0xfffff
    80004c58:	ae4080e7          	jalr	-1308(ra) # 80003738 <end_op>
    return -1;
    80004c5c:	557d                	li	a0,-1
    80004c5e:	74ae                	ld	s1,232(sp)
    80004c60:	a075                	j	80004d0c <sys_unlink+0x1d2>
    80004c62:	e9d2                	sd	s4,208(sp)
    80004c64:	e5d6                	sd	s5,200(sp)
    panic("unlink: nlink < 1");
    80004c66:	00004517          	auipc	a0,0x4
    80004c6a:	95a50513          	addi	a0,a0,-1702 # 800085c0 <etext+0x5c0>
    80004c6e:	00001097          	auipc	ra,0x1
    80004c72:	214080e7          	jalr	532(ra) # 80005e82 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004c76:	04c92703          	lw	a4,76(s2)
    80004c7a:	02000793          	li	a5,32
    80004c7e:	f6e7f3e3          	bgeu	a5,a4,80004be4 <sys_unlink+0xaa>
    80004c82:	e9d2                	sd	s4,208(sp)
    80004c84:	e5d6                	sd	s5,200(sp)
    80004c86:	89be                	mv	s3,a5
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004c88:	f0840a93          	addi	s5,s0,-248
    80004c8c:	4a41                	li	s4,16
    80004c8e:	8752                	mv	a4,s4
    80004c90:	86ce                	mv	a3,s3
    80004c92:	8656                	mv	a2,s5
    80004c94:	4581                	li	a1,0
    80004c96:	854a                	mv	a0,s2
    80004c98:	ffffe097          	auipc	ra,0xffffe
    80004c9c:	2f0080e7          	jalr	752(ra) # 80002f88 <readi>
    80004ca0:	01451d63          	bne	a0,s4,80004cba <sys_unlink+0x180>
    if(de.inum != 0)
    80004ca4:	f0845783          	lhu	a5,-248(s0)
    80004ca8:	eba5                	bnez	a5,80004d18 <sys_unlink+0x1de>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004caa:	29c1                	addiw	s3,s3,16
    80004cac:	04c92783          	lw	a5,76(s2)
    80004cb0:	fcf9efe3          	bltu	s3,a5,80004c8e <sys_unlink+0x154>
    80004cb4:	6a4e                	ld	s4,208(sp)
    80004cb6:	6aae                	ld	s5,200(sp)
    80004cb8:	b735                	j	80004be4 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004cba:	00004517          	auipc	a0,0x4
    80004cbe:	91e50513          	addi	a0,a0,-1762 # 800085d8 <etext+0x5d8>
    80004cc2:	00001097          	auipc	ra,0x1
    80004cc6:	1c0080e7          	jalr	448(ra) # 80005e82 <panic>
    80004cca:	e9d2                	sd	s4,208(sp)
    80004ccc:	e5d6                	sd	s5,200(sp)
    panic("unlink: writei");
    80004cce:	00004517          	auipc	a0,0x4
    80004cd2:	92250513          	addi	a0,a0,-1758 # 800085f0 <etext+0x5f0>
    80004cd6:	00001097          	auipc	ra,0x1
    80004cda:	1ac080e7          	jalr	428(ra) # 80005e82 <panic>
    dp->nlink--;
    80004cde:	04a4d783          	lhu	a5,74(s1)
    80004ce2:	37fd                	addiw	a5,a5,-1
    80004ce4:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004ce8:	8526                	mv	a0,s1
    80004cea:	ffffe097          	auipc	ra,0xffffe
    80004cee:	f16080e7          	jalr	-234(ra) # 80002c00 <iupdate>
    80004cf2:	b725                	j	80004c1a <sys_unlink+0xe0>
    80004cf4:	790e                	ld	s2,224(sp)
  iunlockput(dp);
    80004cf6:	8526                	mv	a0,s1
    80004cf8:	ffffe097          	auipc	ra,0xffffe
    80004cfc:	23a080e7          	jalr	570(ra) # 80002f32 <iunlockput>
  end_op();
    80004d00:	fffff097          	auipc	ra,0xfffff
    80004d04:	a38080e7          	jalr	-1480(ra) # 80003738 <end_op>
  return -1;
    80004d08:	557d                	li	a0,-1
    80004d0a:	74ae                	ld	s1,232(sp)
}
    80004d0c:	70ee                	ld	ra,248(sp)
    80004d0e:	744e                	ld	s0,240(sp)
    80004d10:	6111                	addi	sp,sp,256
    80004d12:	8082                	ret
    return -1;
    80004d14:	557d                	li	a0,-1
    80004d16:	bfdd                	j	80004d0c <sys_unlink+0x1d2>
    iunlockput(ip);
    80004d18:	854a                	mv	a0,s2
    80004d1a:	ffffe097          	auipc	ra,0xffffe
    80004d1e:	218080e7          	jalr	536(ra) # 80002f32 <iunlockput>
    goto bad;
    80004d22:	790e                	ld	s2,224(sp)
    80004d24:	69ee                	ld	s3,216(sp)
    80004d26:	6a4e                	ld	s4,208(sp)
    80004d28:	6aae                	ld	s5,200(sp)
    80004d2a:	b7f1                	j	80004cf6 <sys_unlink+0x1bc>

0000000080004d2c <sys_open>:

uint64
sys_open(void)
{
    80004d2c:	7131                	addi	sp,sp,-192
    80004d2e:	fd06                	sd	ra,184(sp)
    80004d30:	f922                	sd	s0,176(sp)
    80004d32:	f526                	sd	s1,168(sp)
    80004d34:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004d36:	08000613          	li	a2,128
    80004d3a:	f5040593          	addi	a1,s0,-176
    80004d3e:	4501                	li	a0,0
    80004d40:	ffffd097          	auipc	ra,0xffffd
    80004d44:	47c080e7          	jalr	1148(ra) # 800021bc <argstr>
    return -1;
    80004d48:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004d4a:	0c054563          	bltz	a0,80004e14 <sys_open+0xe8>
    80004d4e:	f4c40593          	addi	a1,s0,-180
    80004d52:	4505                	li	a0,1
    80004d54:	ffffd097          	auipc	ra,0xffffd
    80004d58:	424080e7          	jalr	1060(ra) # 80002178 <argint>
    80004d5c:	0a054c63          	bltz	a0,80004e14 <sys_open+0xe8>
    80004d60:	f14a                	sd	s2,160(sp)

  begin_op();
    80004d62:	fffff097          	auipc	ra,0xfffff
    80004d66:	95c080e7          	jalr	-1700(ra) # 800036be <begin_op>

  if(omode & O_CREATE){
    80004d6a:	f4c42783          	lw	a5,-180(s0)
    80004d6e:	2007f793          	andi	a5,a5,512
    80004d72:	cfcd                	beqz	a5,80004e2c <sys_open+0x100>
    ip = create(path, T_FILE, 0, 0);
    80004d74:	4681                	li	a3,0
    80004d76:	4601                	li	a2,0
    80004d78:	4589                	li	a1,2
    80004d7a:	f5040513          	addi	a0,s0,-176
    80004d7e:	00000097          	auipc	ra,0x0
    80004d82:	948080e7          	jalr	-1720(ra) # 800046c6 <create>
    80004d86:	892a                	mv	s2,a0
    if(ip == 0){
    80004d88:	cd41                	beqz	a0,80004e20 <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004d8a:	04491703          	lh	a4,68(s2)
    80004d8e:	478d                	li	a5,3
    80004d90:	00f71763          	bne	a4,a5,80004d9e <sys_open+0x72>
    80004d94:	04695703          	lhu	a4,70(s2)
    80004d98:	47a5                	li	a5,9
    80004d9a:	0ee7e063          	bltu	a5,a4,80004e7a <sys_open+0x14e>
    80004d9e:	ed4e                	sd	s3,152(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004da0:	fffff097          	auipc	ra,0xfffff
    80004da4:	d32080e7          	jalr	-718(ra) # 80003ad2 <filealloc>
    80004da8:	89aa                	mv	s3,a0
    80004daa:	c96d                	beqz	a0,80004e9c <sys_open+0x170>
    80004dac:	00000097          	auipc	ra,0x0
    80004db0:	8d8080e7          	jalr	-1832(ra) # 80004684 <fdalloc>
    80004db4:	84aa                	mv	s1,a0
    80004db6:	0c054e63          	bltz	a0,80004e92 <sys_open+0x166>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004dba:	04491703          	lh	a4,68(s2)
    80004dbe:	478d                	li	a5,3
    80004dc0:	0ef70b63          	beq	a4,a5,80004eb6 <sys_open+0x18a>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004dc4:	4789                	li	a5,2
    80004dc6:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004dca:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004dce:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004dd2:	f4c42783          	lw	a5,-180(s0)
    80004dd6:	0017f713          	andi	a4,a5,1
    80004dda:	00174713          	xori	a4,a4,1
    80004dde:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004de2:	0037f713          	andi	a4,a5,3
    80004de6:	00e03733          	snez	a4,a4
    80004dea:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004dee:	4007f793          	andi	a5,a5,1024
    80004df2:	c791                	beqz	a5,80004dfe <sys_open+0xd2>
    80004df4:	04491703          	lh	a4,68(s2)
    80004df8:	4789                	li	a5,2
    80004dfa:	0cf70563          	beq	a4,a5,80004ec4 <sys_open+0x198>
    itrunc(ip);
  }

  iunlock(ip);
    80004dfe:	854a                	mv	a0,s2
    80004e00:	ffffe097          	auipc	ra,0xffffe
    80004e04:	f92080e7          	jalr	-110(ra) # 80002d92 <iunlock>
  end_op();
    80004e08:	fffff097          	auipc	ra,0xfffff
    80004e0c:	930080e7          	jalr	-1744(ra) # 80003738 <end_op>
    80004e10:	790a                	ld	s2,160(sp)
    80004e12:	69ea                	ld	s3,152(sp)

  return fd;
}
    80004e14:	8526                	mv	a0,s1
    80004e16:	70ea                	ld	ra,184(sp)
    80004e18:	744a                	ld	s0,176(sp)
    80004e1a:	74aa                	ld	s1,168(sp)
    80004e1c:	6129                	addi	sp,sp,192
    80004e1e:	8082                	ret
      end_op();
    80004e20:	fffff097          	auipc	ra,0xfffff
    80004e24:	918080e7          	jalr	-1768(ra) # 80003738 <end_op>
      return -1;
    80004e28:	790a                	ld	s2,160(sp)
    80004e2a:	b7ed                	j	80004e14 <sys_open+0xe8>
    if((ip = namei(path)) == 0){
    80004e2c:	f5040513          	addi	a0,s0,-176
    80004e30:	ffffe097          	auipc	ra,0xffffe
    80004e34:	688080e7          	jalr	1672(ra) # 800034b8 <namei>
    80004e38:	892a                	mv	s2,a0
    80004e3a:	c90d                	beqz	a0,80004e6c <sys_open+0x140>
    ilock(ip);
    80004e3c:	ffffe097          	auipc	ra,0xffffe
    80004e40:	e90080e7          	jalr	-368(ra) # 80002ccc <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004e44:	04491703          	lh	a4,68(s2)
    80004e48:	4785                	li	a5,1
    80004e4a:	f4f710e3          	bne	a4,a5,80004d8a <sys_open+0x5e>
    80004e4e:	f4c42783          	lw	a5,-180(s0)
    80004e52:	d7b1                	beqz	a5,80004d9e <sys_open+0x72>
      iunlockput(ip);
    80004e54:	854a                	mv	a0,s2
    80004e56:	ffffe097          	auipc	ra,0xffffe
    80004e5a:	0dc080e7          	jalr	220(ra) # 80002f32 <iunlockput>
      end_op();
    80004e5e:	fffff097          	auipc	ra,0xfffff
    80004e62:	8da080e7          	jalr	-1830(ra) # 80003738 <end_op>
      return -1;
    80004e66:	54fd                	li	s1,-1
    80004e68:	790a                	ld	s2,160(sp)
    80004e6a:	b76d                	j	80004e14 <sys_open+0xe8>
      end_op();
    80004e6c:	fffff097          	auipc	ra,0xfffff
    80004e70:	8cc080e7          	jalr	-1844(ra) # 80003738 <end_op>
      return -1;
    80004e74:	54fd                	li	s1,-1
    80004e76:	790a                	ld	s2,160(sp)
    80004e78:	bf71                	j	80004e14 <sys_open+0xe8>
    iunlockput(ip);
    80004e7a:	854a                	mv	a0,s2
    80004e7c:	ffffe097          	auipc	ra,0xffffe
    80004e80:	0b6080e7          	jalr	182(ra) # 80002f32 <iunlockput>
    end_op();
    80004e84:	fffff097          	auipc	ra,0xfffff
    80004e88:	8b4080e7          	jalr	-1868(ra) # 80003738 <end_op>
    return -1;
    80004e8c:	54fd                	li	s1,-1
    80004e8e:	790a                	ld	s2,160(sp)
    80004e90:	b751                	j	80004e14 <sys_open+0xe8>
      fileclose(f);
    80004e92:	854e                	mv	a0,s3
    80004e94:	fffff097          	auipc	ra,0xfffff
    80004e98:	cfa080e7          	jalr	-774(ra) # 80003b8e <fileclose>
    iunlockput(ip);
    80004e9c:	854a                	mv	a0,s2
    80004e9e:	ffffe097          	auipc	ra,0xffffe
    80004ea2:	094080e7          	jalr	148(ra) # 80002f32 <iunlockput>
    end_op();
    80004ea6:	fffff097          	auipc	ra,0xfffff
    80004eaa:	892080e7          	jalr	-1902(ra) # 80003738 <end_op>
    return -1;
    80004eae:	54fd                	li	s1,-1
    80004eb0:	790a                	ld	s2,160(sp)
    80004eb2:	69ea                	ld	s3,152(sp)
    80004eb4:	b785                	j	80004e14 <sys_open+0xe8>
    f->type = FD_DEVICE;
    80004eb6:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004eba:	04691783          	lh	a5,70(s2)
    80004ebe:	02f99223          	sh	a5,36(s3)
    80004ec2:	b731                	j	80004dce <sys_open+0xa2>
    itrunc(ip);
    80004ec4:	854a                	mv	a0,s2
    80004ec6:	ffffe097          	auipc	ra,0xffffe
    80004eca:	f18080e7          	jalr	-232(ra) # 80002dde <itrunc>
    80004ece:	bf05                	j	80004dfe <sys_open+0xd2>

0000000080004ed0 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004ed0:	7175                	addi	sp,sp,-144
    80004ed2:	e506                	sd	ra,136(sp)
    80004ed4:	e122                	sd	s0,128(sp)
    80004ed6:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004ed8:	ffffe097          	auipc	ra,0xffffe
    80004edc:	7e6080e7          	jalr	2022(ra) # 800036be <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004ee0:	08000613          	li	a2,128
    80004ee4:	f7040593          	addi	a1,s0,-144
    80004ee8:	4501                	li	a0,0
    80004eea:	ffffd097          	auipc	ra,0xffffd
    80004eee:	2d2080e7          	jalr	722(ra) # 800021bc <argstr>
    80004ef2:	02054963          	bltz	a0,80004f24 <sys_mkdir+0x54>
    80004ef6:	4681                	li	a3,0
    80004ef8:	4601                	li	a2,0
    80004efa:	4585                	li	a1,1
    80004efc:	f7040513          	addi	a0,s0,-144
    80004f00:	fffff097          	auipc	ra,0xfffff
    80004f04:	7c6080e7          	jalr	1990(ra) # 800046c6 <create>
    80004f08:	cd11                	beqz	a0,80004f24 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004f0a:	ffffe097          	auipc	ra,0xffffe
    80004f0e:	028080e7          	jalr	40(ra) # 80002f32 <iunlockput>
  end_op();
    80004f12:	fffff097          	auipc	ra,0xfffff
    80004f16:	826080e7          	jalr	-2010(ra) # 80003738 <end_op>
  return 0;
    80004f1a:	4501                	li	a0,0
}
    80004f1c:	60aa                	ld	ra,136(sp)
    80004f1e:	640a                	ld	s0,128(sp)
    80004f20:	6149                	addi	sp,sp,144
    80004f22:	8082                	ret
    end_op();
    80004f24:	fffff097          	auipc	ra,0xfffff
    80004f28:	814080e7          	jalr	-2028(ra) # 80003738 <end_op>
    return -1;
    80004f2c:	557d                	li	a0,-1
    80004f2e:	b7fd                	j	80004f1c <sys_mkdir+0x4c>

0000000080004f30 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004f30:	7135                	addi	sp,sp,-160
    80004f32:	ed06                	sd	ra,152(sp)
    80004f34:	e922                	sd	s0,144(sp)
    80004f36:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004f38:	ffffe097          	auipc	ra,0xffffe
    80004f3c:	786080e7          	jalr	1926(ra) # 800036be <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004f40:	08000613          	li	a2,128
    80004f44:	f7040593          	addi	a1,s0,-144
    80004f48:	4501                	li	a0,0
    80004f4a:	ffffd097          	auipc	ra,0xffffd
    80004f4e:	272080e7          	jalr	626(ra) # 800021bc <argstr>
    80004f52:	04054a63          	bltz	a0,80004fa6 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004f56:	f6c40593          	addi	a1,s0,-148
    80004f5a:	4505                	li	a0,1
    80004f5c:	ffffd097          	auipc	ra,0xffffd
    80004f60:	21c080e7          	jalr	540(ra) # 80002178 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004f64:	04054163          	bltz	a0,80004fa6 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004f68:	f6840593          	addi	a1,s0,-152
    80004f6c:	4509                	li	a0,2
    80004f6e:	ffffd097          	auipc	ra,0xffffd
    80004f72:	20a080e7          	jalr	522(ra) # 80002178 <argint>
     argint(1, &major) < 0 ||
    80004f76:	02054863          	bltz	a0,80004fa6 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004f7a:	f6841683          	lh	a3,-152(s0)
    80004f7e:	f6c41603          	lh	a2,-148(s0)
    80004f82:	458d                	li	a1,3
    80004f84:	f7040513          	addi	a0,s0,-144
    80004f88:	fffff097          	auipc	ra,0xfffff
    80004f8c:	73e080e7          	jalr	1854(ra) # 800046c6 <create>
     argint(2, &minor) < 0 ||
    80004f90:	c919                	beqz	a0,80004fa6 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004f92:	ffffe097          	auipc	ra,0xffffe
    80004f96:	fa0080e7          	jalr	-96(ra) # 80002f32 <iunlockput>
  end_op();
    80004f9a:	ffffe097          	auipc	ra,0xffffe
    80004f9e:	79e080e7          	jalr	1950(ra) # 80003738 <end_op>
  return 0;
    80004fa2:	4501                	li	a0,0
    80004fa4:	a031                	j	80004fb0 <sys_mknod+0x80>
    end_op();
    80004fa6:	ffffe097          	auipc	ra,0xffffe
    80004faa:	792080e7          	jalr	1938(ra) # 80003738 <end_op>
    return -1;
    80004fae:	557d                	li	a0,-1
}
    80004fb0:	60ea                	ld	ra,152(sp)
    80004fb2:	644a                	ld	s0,144(sp)
    80004fb4:	610d                	addi	sp,sp,160
    80004fb6:	8082                	ret

0000000080004fb8 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004fb8:	7135                	addi	sp,sp,-160
    80004fba:	ed06                	sd	ra,152(sp)
    80004fbc:	e922                	sd	s0,144(sp)
    80004fbe:	e14a                	sd	s2,128(sp)
    80004fc0:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004fc2:	ffffc097          	auipc	ra,0xffffc
    80004fc6:	020080e7          	jalr	32(ra) # 80000fe2 <myproc>
    80004fca:	892a                	mv	s2,a0
  
  begin_op();
    80004fcc:	ffffe097          	auipc	ra,0xffffe
    80004fd0:	6f2080e7          	jalr	1778(ra) # 800036be <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004fd4:	08000613          	li	a2,128
    80004fd8:	f6040593          	addi	a1,s0,-160
    80004fdc:	4501                	li	a0,0
    80004fde:	ffffd097          	auipc	ra,0xffffd
    80004fe2:	1de080e7          	jalr	478(ra) # 800021bc <argstr>
    80004fe6:	04054d63          	bltz	a0,80005040 <sys_chdir+0x88>
    80004fea:	e526                	sd	s1,136(sp)
    80004fec:	f6040513          	addi	a0,s0,-160
    80004ff0:	ffffe097          	auipc	ra,0xffffe
    80004ff4:	4c8080e7          	jalr	1224(ra) # 800034b8 <namei>
    80004ff8:	84aa                	mv	s1,a0
    80004ffa:	c131                	beqz	a0,8000503e <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004ffc:	ffffe097          	auipc	ra,0xffffe
    80005000:	cd0080e7          	jalr	-816(ra) # 80002ccc <ilock>
  if(ip->type != T_DIR){
    80005004:	04449703          	lh	a4,68(s1)
    80005008:	4785                	li	a5,1
    8000500a:	04f71163          	bne	a4,a5,8000504c <sys_chdir+0x94>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    8000500e:	8526                	mv	a0,s1
    80005010:	ffffe097          	auipc	ra,0xffffe
    80005014:	d82080e7          	jalr	-638(ra) # 80002d92 <iunlock>
  iput(p->cwd);
    80005018:	15093503          	ld	a0,336(s2)
    8000501c:	ffffe097          	auipc	ra,0xffffe
    80005020:	e6e080e7          	jalr	-402(ra) # 80002e8a <iput>
  end_op();
    80005024:	ffffe097          	auipc	ra,0xffffe
    80005028:	714080e7          	jalr	1812(ra) # 80003738 <end_op>
  p->cwd = ip;
    8000502c:	14993823          	sd	s1,336(s2)
  return 0;
    80005030:	4501                	li	a0,0
    80005032:	64aa                	ld	s1,136(sp)
}
    80005034:	60ea                	ld	ra,152(sp)
    80005036:	644a                	ld	s0,144(sp)
    80005038:	690a                	ld	s2,128(sp)
    8000503a:	610d                	addi	sp,sp,160
    8000503c:	8082                	ret
    8000503e:	64aa                	ld	s1,136(sp)
    end_op();
    80005040:	ffffe097          	auipc	ra,0xffffe
    80005044:	6f8080e7          	jalr	1784(ra) # 80003738 <end_op>
    return -1;
    80005048:	557d                	li	a0,-1
    8000504a:	b7ed                	j	80005034 <sys_chdir+0x7c>
    iunlockput(ip);
    8000504c:	8526                	mv	a0,s1
    8000504e:	ffffe097          	auipc	ra,0xffffe
    80005052:	ee4080e7          	jalr	-284(ra) # 80002f32 <iunlockput>
    end_op();
    80005056:	ffffe097          	auipc	ra,0xffffe
    8000505a:	6e2080e7          	jalr	1762(ra) # 80003738 <end_op>
    return -1;
    8000505e:	557d                	li	a0,-1
    80005060:	64aa                	ld	s1,136(sp)
    80005062:	bfc9                	j	80005034 <sys_chdir+0x7c>

0000000080005064 <sys_exec>:

uint64
sys_exec(void)
{
    80005064:	7105                	addi	sp,sp,-480
    80005066:	ef86                	sd	ra,472(sp)
    80005068:	eba2                	sd	s0,464(sp)
    8000506a:	e3ca                	sd	s2,448(sp)
    8000506c:	1380                	addi	s0,sp,480
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    8000506e:	08000613          	li	a2,128
    80005072:	f3040593          	addi	a1,s0,-208
    80005076:	4501                	li	a0,0
    80005078:	ffffd097          	auipc	ra,0xffffd
    8000507c:	144080e7          	jalr	324(ra) # 800021bc <argstr>
    return -1;
    80005080:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005082:	10054963          	bltz	a0,80005194 <sys_exec+0x130>
    80005086:	e2840593          	addi	a1,s0,-472
    8000508a:	4505                	li	a0,1
    8000508c:	ffffd097          	auipc	ra,0xffffd
    80005090:	10e080e7          	jalr	270(ra) # 8000219a <argaddr>
    80005094:	10054063          	bltz	a0,80005194 <sys_exec+0x130>
    80005098:	e7a6                	sd	s1,456(sp)
    8000509a:	ff4e                	sd	s3,440(sp)
    8000509c:	fb52                	sd	s4,432(sp)
    8000509e:	f756                	sd	s5,424(sp)
    800050a0:	f35a                	sd	s6,416(sp)
    800050a2:	ef5e                	sd	s7,408(sp)
  }
  memset(argv, 0, sizeof(argv));
    800050a4:	e3040a13          	addi	s4,s0,-464
    800050a8:	10000613          	li	a2,256
    800050ac:	4581                	li	a1,0
    800050ae:	8552                	mv	a0,s4
    800050b0:	ffffb097          	auipc	ra,0xffffb
    800050b4:	1d4080e7          	jalr	468(ra) # 80000284 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800050b8:	84d2                	mv	s1,s4
  memset(argv, 0, sizeof(argv));
    800050ba:	89d2                	mv	s3,s4
    800050bc:	4901                	li	s2,0
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800050be:	e2040a93          	addi	s5,s0,-480
      break;
    }
    argv[i] = kalloc();
    if(argv[i] == 0)
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800050c2:	6b05                	lui	s6,0x1
    if(i >= NELEM(argv)){
    800050c4:	02000b93          	li	s7,32
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800050c8:	00391513          	slli	a0,s2,0x3
    800050cc:	85d6                	mv	a1,s5
    800050ce:	e2843783          	ld	a5,-472(s0)
    800050d2:	953e                	add	a0,a0,a5
    800050d4:	ffffd097          	auipc	ra,0xffffd
    800050d8:	00a080e7          	jalr	10(ra) # 800020de <fetchaddr>
    800050dc:	02054a63          	bltz	a0,80005110 <sys_exec+0xac>
    if(uarg == 0){
    800050e0:	e2043783          	ld	a5,-480(s0)
    800050e4:	cba9                	beqz	a5,80005136 <sys_exec+0xd2>
    argv[i] = kalloc();
    800050e6:	ffffb097          	auipc	ra,0xffffb
    800050ea:	124080e7          	jalr	292(ra) # 8000020a <kalloc>
    800050ee:	85aa                	mv	a1,a0
    800050f0:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800050f4:	cd11                	beqz	a0,80005110 <sys_exec+0xac>
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800050f6:	865a                	mv	a2,s6
    800050f8:	e2043503          	ld	a0,-480(s0)
    800050fc:	ffffd097          	auipc	ra,0xffffd
    80005100:	034080e7          	jalr	52(ra) # 80002130 <fetchstr>
    80005104:	00054663          	bltz	a0,80005110 <sys_exec+0xac>
    if(i >= NELEM(argv)){
    80005108:	0905                	addi	s2,s2,1
    8000510a:	09a1                	addi	s3,s3,8
    8000510c:	fb791ee3          	bne	s2,s7,800050c8 <sys_exec+0x64>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005110:	100a0a13          	addi	s4,s4,256
    80005114:	6088                	ld	a0,0(s1)
    80005116:	c925                	beqz	a0,80005186 <sys_exec+0x122>
    kfree(argv[i]);
    80005118:	ffffb097          	auipc	ra,0xffffb
    8000511c:	f9c080e7          	jalr	-100(ra) # 800000b4 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005120:	04a1                	addi	s1,s1,8
    80005122:	ff4499e3          	bne	s1,s4,80005114 <sys_exec+0xb0>
  return -1;
    80005126:	597d                	li	s2,-1
    80005128:	64be                	ld	s1,456(sp)
    8000512a:	79fa                	ld	s3,440(sp)
    8000512c:	7a5a                	ld	s4,432(sp)
    8000512e:	7aba                	ld	s5,424(sp)
    80005130:	7b1a                	ld	s6,416(sp)
    80005132:	6bfa                	ld	s7,408(sp)
    80005134:	a085                	j	80005194 <sys_exec+0x130>
      argv[i] = 0;
    80005136:	0009079b          	sext.w	a5,s2
    8000513a:	e3040593          	addi	a1,s0,-464
    8000513e:	078e                	slli	a5,a5,0x3
    80005140:	97ae                	add	a5,a5,a1
    80005142:	0007b023          	sd	zero,0(a5)
  int ret = exec(path, argv);
    80005146:	f3040513          	addi	a0,s0,-208
    8000514a:	fffff097          	auipc	ra,0xfffff
    8000514e:	122080e7          	jalr	290(ra) # 8000426c <exec>
    80005152:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005154:	100a0a13          	addi	s4,s4,256
    80005158:	6088                	ld	a0,0(s1)
    8000515a:	cd19                	beqz	a0,80005178 <sys_exec+0x114>
    kfree(argv[i]);
    8000515c:	ffffb097          	auipc	ra,0xffffb
    80005160:	f58080e7          	jalr	-168(ra) # 800000b4 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005164:	04a1                	addi	s1,s1,8
    80005166:	ff4499e3          	bne	s1,s4,80005158 <sys_exec+0xf4>
    8000516a:	64be                	ld	s1,456(sp)
    8000516c:	79fa                	ld	s3,440(sp)
    8000516e:	7a5a                	ld	s4,432(sp)
    80005170:	7aba                	ld	s5,424(sp)
    80005172:	7b1a                	ld	s6,416(sp)
    80005174:	6bfa                	ld	s7,408(sp)
    80005176:	a839                	j	80005194 <sys_exec+0x130>
  return ret;
    80005178:	64be                	ld	s1,456(sp)
    8000517a:	79fa                	ld	s3,440(sp)
    8000517c:	7a5a                	ld	s4,432(sp)
    8000517e:	7aba                	ld	s5,424(sp)
    80005180:	7b1a                	ld	s6,416(sp)
    80005182:	6bfa                	ld	s7,408(sp)
    80005184:	a801                	j	80005194 <sys_exec+0x130>
  return -1;
    80005186:	597d                	li	s2,-1
    80005188:	64be                	ld	s1,456(sp)
    8000518a:	79fa                	ld	s3,440(sp)
    8000518c:	7a5a                	ld	s4,432(sp)
    8000518e:	7aba                	ld	s5,424(sp)
    80005190:	7b1a                	ld	s6,416(sp)
    80005192:	6bfa                	ld	s7,408(sp)
}
    80005194:	854a                	mv	a0,s2
    80005196:	60fe                	ld	ra,472(sp)
    80005198:	645e                	ld	s0,464(sp)
    8000519a:	691e                	ld	s2,448(sp)
    8000519c:	613d                	addi	sp,sp,480
    8000519e:	8082                	ret

00000000800051a0 <sys_pipe>:

uint64
sys_pipe(void)
{
    800051a0:	7139                	addi	sp,sp,-64
    800051a2:	fc06                	sd	ra,56(sp)
    800051a4:	f822                	sd	s0,48(sp)
    800051a6:	f426                	sd	s1,40(sp)
    800051a8:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800051aa:	ffffc097          	auipc	ra,0xffffc
    800051ae:	e38080e7          	jalr	-456(ra) # 80000fe2 <myproc>
    800051b2:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    800051b4:	fd840593          	addi	a1,s0,-40
    800051b8:	4501                	li	a0,0
    800051ba:	ffffd097          	auipc	ra,0xffffd
    800051be:	fe0080e7          	jalr	-32(ra) # 8000219a <argaddr>
    return -1;
    800051c2:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    800051c4:	0e054063          	bltz	a0,800052a4 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    800051c8:	fc840593          	addi	a1,s0,-56
    800051cc:	fd040513          	addi	a0,s0,-48
    800051d0:	fffff097          	auipc	ra,0xfffff
    800051d4:	d32080e7          	jalr	-718(ra) # 80003f02 <pipealloc>
    return -1;
    800051d8:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800051da:	0c054563          	bltz	a0,800052a4 <sys_pipe+0x104>
  fd0 = -1;
    800051de:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800051e2:	fd043503          	ld	a0,-48(s0)
    800051e6:	fffff097          	auipc	ra,0xfffff
    800051ea:	49e080e7          	jalr	1182(ra) # 80004684 <fdalloc>
    800051ee:	fca42223          	sw	a0,-60(s0)
    800051f2:	08054c63          	bltz	a0,8000528a <sys_pipe+0xea>
    800051f6:	fc843503          	ld	a0,-56(s0)
    800051fa:	fffff097          	auipc	ra,0xfffff
    800051fe:	48a080e7          	jalr	1162(ra) # 80004684 <fdalloc>
    80005202:	fca42023          	sw	a0,-64(s0)
    80005206:	06054963          	bltz	a0,80005278 <sys_pipe+0xd8>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000520a:	4691                	li	a3,4
    8000520c:	fc440613          	addi	a2,s0,-60
    80005210:	fd843583          	ld	a1,-40(s0)
    80005214:	68a8                	ld	a0,80(s1)
    80005216:	ffffc097          	auipc	ra,0xffffc
    8000521a:	a64080e7          	jalr	-1436(ra) # 80000c7a <copyout>
    8000521e:	02054063          	bltz	a0,8000523e <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005222:	4691                	li	a3,4
    80005224:	fc040613          	addi	a2,s0,-64
    80005228:	fd843583          	ld	a1,-40(s0)
    8000522c:	95b6                	add	a1,a1,a3
    8000522e:	68a8                	ld	a0,80(s1)
    80005230:	ffffc097          	auipc	ra,0xffffc
    80005234:	a4a080e7          	jalr	-1462(ra) # 80000c7a <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005238:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000523a:	06055563          	bgez	a0,800052a4 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    8000523e:	fc442783          	lw	a5,-60(s0)
    80005242:	07e9                	addi	a5,a5,26
    80005244:	078e                	slli	a5,a5,0x3
    80005246:	97a6                	add	a5,a5,s1
    80005248:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    8000524c:	fc042783          	lw	a5,-64(s0)
    80005250:	07e9                	addi	a5,a5,26
    80005252:	078e                	slli	a5,a5,0x3
    80005254:	00f48533          	add	a0,s1,a5
    80005258:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    8000525c:	fd043503          	ld	a0,-48(s0)
    80005260:	fffff097          	auipc	ra,0xfffff
    80005264:	92e080e7          	jalr	-1746(ra) # 80003b8e <fileclose>
    fileclose(wf);
    80005268:	fc843503          	ld	a0,-56(s0)
    8000526c:	fffff097          	auipc	ra,0xfffff
    80005270:	922080e7          	jalr	-1758(ra) # 80003b8e <fileclose>
    return -1;
    80005274:	57fd                	li	a5,-1
    80005276:	a03d                	j	800052a4 <sys_pipe+0x104>
    if(fd0 >= 0)
    80005278:	fc442783          	lw	a5,-60(s0)
    8000527c:	0007c763          	bltz	a5,8000528a <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005280:	07e9                	addi	a5,a5,26
    80005282:	078e                	slli	a5,a5,0x3
    80005284:	97a6                	add	a5,a5,s1
    80005286:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    8000528a:	fd043503          	ld	a0,-48(s0)
    8000528e:	fffff097          	auipc	ra,0xfffff
    80005292:	900080e7          	jalr	-1792(ra) # 80003b8e <fileclose>
    fileclose(wf);
    80005296:	fc843503          	ld	a0,-56(s0)
    8000529a:	fffff097          	auipc	ra,0xfffff
    8000529e:	8f4080e7          	jalr	-1804(ra) # 80003b8e <fileclose>
    return -1;
    800052a2:	57fd                	li	a5,-1
}
    800052a4:	853e                	mv	a0,a5
    800052a6:	70e2                	ld	ra,56(sp)
    800052a8:	7442                	ld	s0,48(sp)
    800052aa:	74a2                	ld	s1,40(sp)
    800052ac:	6121                	addi	sp,sp,64
    800052ae:	8082                	ret

00000000800052b0 <kernelvec>:
    800052b0:	7111                	addi	sp,sp,-256
    800052b2:	e006                	sd	ra,0(sp)
    800052b4:	e40a                	sd	sp,8(sp)
    800052b6:	e80e                	sd	gp,16(sp)
    800052b8:	ec12                	sd	tp,24(sp)
    800052ba:	f016                	sd	t0,32(sp)
    800052bc:	f41a                	sd	t1,40(sp)
    800052be:	f81e                	sd	t2,48(sp)
    800052c0:	fc22                	sd	s0,56(sp)
    800052c2:	e0a6                	sd	s1,64(sp)
    800052c4:	e4aa                	sd	a0,72(sp)
    800052c6:	e8ae                	sd	a1,80(sp)
    800052c8:	ecb2                	sd	a2,88(sp)
    800052ca:	f0b6                	sd	a3,96(sp)
    800052cc:	f4ba                	sd	a4,104(sp)
    800052ce:	f8be                	sd	a5,112(sp)
    800052d0:	fcc2                	sd	a6,120(sp)
    800052d2:	e146                	sd	a7,128(sp)
    800052d4:	e54a                	sd	s2,136(sp)
    800052d6:	e94e                	sd	s3,144(sp)
    800052d8:	ed52                	sd	s4,152(sp)
    800052da:	f156                	sd	s5,160(sp)
    800052dc:	f55a                	sd	s6,168(sp)
    800052de:	f95e                	sd	s7,176(sp)
    800052e0:	fd62                	sd	s8,184(sp)
    800052e2:	e1e6                	sd	s9,192(sp)
    800052e4:	e5ea                	sd	s10,200(sp)
    800052e6:	e9ee                	sd	s11,208(sp)
    800052e8:	edf2                	sd	t3,216(sp)
    800052ea:	f1f6                	sd	t4,224(sp)
    800052ec:	f5fa                	sd	t5,232(sp)
    800052ee:	f9fe                	sd	t6,240(sp)
    800052f0:	cbbfc0ef          	jal	80001faa <kerneltrap>
    800052f4:	6082                	ld	ra,0(sp)
    800052f6:	6122                	ld	sp,8(sp)
    800052f8:	61c2                	ld	gp,16(sp)
    800052fa:	7282                	ld	t0,32(sp)
    800052fc:	7322                	ld	t1,40(sp)
    800052fe:	73c2                	ld	t2,48(sp)
    80005300:	7462                	ld	s0,56(sp)
    80005302:	6486                	ld	s1,64(sp)
    80005304:	6526                	ld	a0,72(sp)
    80005306:	65c6                	ld	a1,80(sp)
    80005308:	6666                	ld	a2,88(sp)
    8000530a:	7686                	ld	a3,96(sp)
    8000530c:	7726                	ld	a4,104(sp)
    8000530e:	77c6                	ld	a5,112(sp)
    80005310:	7866                	ld	a6,120(sp)
    80005312:	688a                	ld	a7,128(sp)
    80005314:	692a                	ld	s2,136(sp)
    80005316:	69ca                	ld	s3,144(sp)
    80005318:	6a6a                	ld	s4,152(sp)
    8000531a:	7a8a                	ld	s5,160(sp)
    8000531c:	7b2a                	ld	s6,168(sp)
    8000531e:	7bca                	ld	s7,176(sp)
    80005320:	7c6a                	ld	s8,184(sp)
    80005322:	6c8e                	ld	s9,192(sp)
    80005324:	6d2e                	ld	s10,200(sp)
    80005326:	6dce                	ld	s11,208(sp)
    80005328:	6e6e                	ld	t3,216(sp)
    8000532a:	7e8e                	ld	t4,224(sp)
    8000532c:	7f2e                	ld	t5,232(sp)
    8000532e:	7fce                	ld	t6,240(sp)
    80005330:	6111                	addi	sp,sp,256
    80005332:	10200073          	sret
    80005336:	00000013          	nop
    8000533a:	00000013          	nop
    8000533e:	0001                	nop

0000000080005340 <timervec>:
    80005340:	34051573          	csrrw	a0,mscratch,a0
    80005344:	e10c                	sd	a1,0(a0)
    80005346:	e510                	sd	a2,8(a0)
    80005348:	e914                	sd	a3,16(a0)
    8000534a:	6d0c                	ld	a1,24(a0)
    8000534c:	7110                	ld	a2,32(a0)
    8000534e:	6194                	ld	a3,0(a1)
    80005350:	96b2                	add	a3,a3,a2
    80005352:	e194                	sd	a3,0(a1)
    80005354:	4589                	li	a1,2
    80005356:	14459073          	csrw	sip,a1
    8000535a:	6914                	ld	a3,16(a0)
    8000535c:	6510                	ld	a2,8(a0)
    8000535e:	610c                	ld	a1,0(a0)
    80005360:	34051573          	csrrw	a0,mscratch,a0
    80005364:	30200073          	mret
	...

000000008000536a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000536a:	1141                	addi	sp,sp,-16
    8000536c:	e406                	sd	ra,8(sp)
    8000536e:	e022                	sd	s0,0(sp)
    80005370:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005372:	0c000737          	lui	a4,0xc000
    80005376:	4785                	li	a5,1
    80005378:	d71c                	sw	a5,40(a4)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    8000537a:	c35c                	sw	a5,4(a4)
}
    8000537c:	60a2                	ld	ra,8(sp)
    8000537e:	6402                	ld	s0,0(sp)
    80005380:	0141                	addi	sp,sp,16
    80005382:	8082                	ret

0000000080005384 <plicinithart>:

void
plicinithart(void)
{
    80005384:	1141                	addi	sp,sp,-16
    80005386:	e406                	sd	ra,8(sp)
    80005388:	e022                	sd	s0,0(sp)
    8000538a:	0800                	addi	s0,sp,16
  int hart = cpuid();
    8000538c:	ffffc097          	auipc	ra,0xffffc
    80005390:	c22080e7          	jalr	-990(ra) # 80000fae <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005394:	0085171b          	slliw	a4,a0,0x8
    80005398:	0c0027b7          	lui	a5,0xc002
    8000539c:	97ba                	add	a5,a5,a4
    8000539e:	40200713          	li	a4,1026
    800053a2:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800053a6:	00d5151b          	slliw	a0,a0,0xd
    800053aa:	0c2017b7          	lui	a5,0xc201
    800053ae:	97aa                	add	a5,a5,a0
    800053b0:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800053b4:	60a2                	ld	ra,8(sp)
    800053b6:	6402                	ld	s0,0(sp)
    800053b8:	0141                	addi	sp,sp,16
    800053ba:	8082                	ret

00000000800053bc <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800053bc:	1141                	addi	sp,sp,-16
    800053be:	e406                	sd	ra,8(sp)
    800053c0:	e022                	sd	s0,0(sp)
    800053c2:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800053c4:	ffffc097          	auipc	ra,0xffffc
    800053c8:	bea080e7          	jalr	-1046(ra) # 80000fae <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800053cc:	00d5151b          	slliw	a0,a0,0xd
    800053d0:	0c2017b7          	lui	a5,0xc201
    800053d4:	97aa                	add	a5,a5,a0
  return irq;
}
    800053d6:	43c8                	lw	a0,4(a5)
    800053d8:	60a2                	ld	ra,8(sp)
    800053da:	6402                	ld	s0,0(sp)
    800053dc:	0141                	addi	sp,sp,16
    800053de:	8082                	ret

00000000800053e0 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800053e0:	1101                	addi	sp,sp,-32
    800053e2:	ec06                	sd	ra,24(sp)
    800053e4:	e822                	sd	s0,16(sp)
    800053e6:	e426                	sd	s1,8(sp)
    800053e8:	1000                	addi	s0,sp,32
    800053ea:	84aa                	mv	s1,a0
  int hart = cpuid();
    800053ec:	ffffc097          	auipc	ra,0xffffc
    800053f0:	bc2080e7          	jalr	-1086(ra) # 80000fae <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800053f4:	00d5179b          	slliw	a5,a0,0xd
    800053f8:	0c201737          	lui	a4,0xc201
    800053fc:	97ba                	add	a5,a5,a4
    800053fe:	c3c4                	sw	s1,4(a5)
}
    80005400:	60e2                	ld	ra,24(sp)
    80005402:	6442                	ld	s0,16(sp)
    80005404:	64a2                	ld	s1,8(sp)
    80005406:	6105                	addi	sp,sp,32
    80005408:	8082                	ret

000000008000540a <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    8000540a:	1141                	addi	sp,sp,-16
    8000540c:	e406                	sd	ra,8(sp)
    8000540e:	e022                	sd	s0,0(sp)
    80005410:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80005412:	479d                	li	a5,7
    80005414:	06a7c863          	blt	a5,a0,80005484 <free_desc+0x7a>
    panic("free_desc 1");
  if(disk.free[i])
    80005418:	00036717          	auipc	a4,0x36
    8000541c:	be870713          	addi	a4,a4,-1048 # 8003b000 <disk>
    80005420:	972a                	add	a4,a4,a0
    80005422:	6789                	lui	a5,0x2
    80005424:	97ba                	add	a5,a5,a4
    80005426:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    8000542a:	e7ad                	bnez	a5,80005494 <free_desc+0x8a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000542c:	00451793          	slli	a5,a0,0x4
    80005430:	00038717          	auipc	a4,0x38
    80005434:	bd070713          	addi	a4,a4,-1072 # 8003d000 <disk+0x2000>
    80005438:	6314                	ld	a3,0(a4)
    8000543a:	96be                	add	a3,a3,a5
    8000543c:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    80005440:	6314                	ld	a3,0(a4)
    80005442:	96be                	add	a3,a3,a5
    80005444:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005448:	6314                	ld	a3,0(a4)
    8000544a:	96be                	add	a3,a3,a5
    8000544c:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    80005450:	6318                	ld	a4,0(a4)
    80005452:	97ba                	add	a5,a5,a4
    80005454:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005458:	00036717          	auipc	a4,0x36
    8000545c:	ba870713          	addi	a4,a4,-1112 # 8003b000 <disk>
    80005460:	972a                	add	a4,a4,a0
    80005462:	6789                	lui	a5,0x2
    80005464:	97ba                	add	a5,a5,a4
    80005466:	4705                	li	a4,1
    80005468:	00e78c23          	sb	a4,24(a5) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    8000546c:	00038517          	auipc	a0,0x38
    80005470:	bac50513          	addi	a0,a0,-1108 # 8003d018 <disk+0x2018>
    80005474:	ffffc097          	auipc	ra,0xffffc
    80005478:	3ba080e7          	jalr	954(ra) # 8000182e <wakeup>
}
    8000547c:	60a2                	ld	ra,8(sp)
    8000547e:	6402                	ld	s0,0(sp)
    80005480:	0141                	addi	sp,sp,16
    80005482:	8082                	ret
    panic("free_desc 1");
    80005484:	00003517          	auipc	a0,0x3
    80005488:	17c50513          	addi	a0,a0,380 # 80008600 <etext+0x600>
    8000548c:	00001097          	auipc	ra,0x1
    80005490:	9f6080e7          	jalr	-1546(ra) # 80005e82 <panic>
    panic("free_desc 2");
    80005494:	00003517          	auipc	a0,0x3
    80005498:	17c50513          	addi	a0,a0,380 # 80008610 <etext+0x610>
    8000549c:	00001097          	auipc	ra,0x1
    800054a0:	9e6080e7          	jalr	-1562(ra) # 80005e82 <panic>

00000000800054a4 <virtio_disk_init>:
{
    800054a4:	1141                	addi	sp,sp,-16
    800054a6:	e406                	sd	ra,8(sp)
    800054a8:	e022                	sd	s0,0(sp)
    800054aa:	0800                	addi	s0,sp,16
  initlock(&disk.vdisk_lock, "virtio_disk");
    800054ac:	00003597          	auipc	a1,0x3
    800054b0:	17458593          	addi	a1,a1,372 # 80008620 <etext+0x620>
    800054b4:	00038517          	auipc	a0,0x38
    800054b8:	c7450513          	addi	a0,a0,-908 # 8003d128 <disk+0x2128>
    800054bc:	00001097          	auipc	ra,0x1
    800054c0:	eb2080e7          	jalr	-334(ra) # 8000636e <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800054c4:	100017b7          	lui	a5,0x10001
    800054c8:	4398                	lw	a4,0(a5)
    800054ca:	2701                	sext.w	a4,a4
    800054cc:	747277b7          	lui	a5,0x74727
    800054d0:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800054d4:	0ef71563          	bne	a4,a5,800055be <virtio_disk_init+0x11a>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800054d8:	100017b7          	lui	a5,0x10001
    800054dc:	43dc                	lw	a5,4(a5)
    800054de:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800054e0:	4705                	li	a4,1
    800054e2:	0ce79e63          	bne	a5,a4,800055be <virtio_disk_init+0x11a>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800054e6:	100017b7          	lui	a5,0x10001
    800054ea:	479c                	lw	a5,8(a5)
    800054ec:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800054ee:	4709                	li	a4,2
    800054f0:	0ce79763          	bne	a5,a4,800055be <virtio_disk_init+0x11a>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800054f4:	100017b7          	lui	a5,0x10001
    800054f8:	47d8                	lw	a4,12(a5)
    800054fa:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800054fc:	554d47b7          	lui	a5,0x554d4
    80005500:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005504:	0af71d63          	bne	a4,a5,800055be <virtio_disk_init+0x11a>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005508:	100017b7          	lui	a5,0x10001
    8000550c:	4705                	li	a4,1
    8000550e:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005510:	470d                	li	a4,3
    80005512:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005514:	10001737          	lui	a4,0x10001
    80005518:	4b18                	lw	a4,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    8000551a:	c7ffe6b7          	lui	a3,0xc7ffe
    8000551e:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fb851f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005522:	8f75                	and	a4,a4,a3
    80005524:	100016b7          	lui	a3,0x10001
    80005528:	d298                	sw	a4,32(a3)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000552a:	472d                	li	a4,11
    8000552c:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000552e:	473d                	li	a4,15
    80005530:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80005532:	6705                	lui	a4,0x1
    80005534:	d698                	sw	a4,40(a3)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005536:	0206a823          	sw	zero,48(a3) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    8000553a:	5adc                	lw	a5,52(a3)
    8000553c:	2781                	sext.w	a5,a5
  if(max == 0)
    8000553e:	cbc1                	beqz	a5,800055ce <virtio_disk_init+0x12a>
  if(max < NUM)
    80005540:	471d                	li	a4,7
    80005542:	08f77e63          	bgeu	a4,a5,800055de <virtio_disk_init+0x13a>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005546:	100017b7          	lui	a5,0x10001
    8000554a:	4721                	li	a4,8
    8000554c:	df98                	sw	a4,56(a5)
  memset(disk.pages, 0, sizeof(disk.pages));
    8000554e:	6609                	lui	a2,0x2
    80005550:	4581                	li	a1,0
    80005552:	00036517          	auipc	a0,0x36
    80005556:	aae50513          	addi	a0,a0,-1362 # 8003b000 <disk>
    8000555a:	ffffb097          	auipc	ra,0xffffb
    8000555e:	d2a080e7          	jalr	-726(ra) # 80000284 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    80005562:	00036717          	auipc	a4,0x36
    80005566:	a9e70713          	addi	a4,a4,-1378 # 8003b000 <disk>
    8000556a:	00c75793          	srli	a5,a4,0xc
    8000556e:	2781                	sext.w	a5,a5
    80005570:	100016b7          	lui	a3,0x10001
    80005574:	c2bc                	sw	a5,64(a3)
  disk.desc = (struct virtq_desc *) disk.pages;
    80005576:	00038797          	auipc	a5,0x38
    8000557a:	a8a78793          	addi	a5,a5,-1398 # 8003d000 <disk+0x2000>
    8000557e:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005580:	00036717          	auipc	a4,0x36
    80005584:	b0070713          	addi	a4,a4,-1280 # 8003b080 <disk+0x80>
    80005588:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    8000558a:	00037717          	auipc	a4,0x37
    8000558e:	a7670713          	addi	a4,a4,-1418 # 8003c000 <disk+0x1000>
    80005592:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    80005594:	4705                	li	a4,1
    80005596:	00e78c23          	sb	a4,24(a5)
    8000559a:	00e78ca3          	sb	a4,25(a5)
    8000559e:	00e78d23          	sb	a4,26(a5)
    800055a2:	00e78da3          	sb	a4,27(a5)
    800055a6:	00e78e23          	sb	a4,28(a5)
    800055aa:	00e78ea3          	sb	a4,29(a5)
    800055ae:	00e78f23          	sb	a4,30(a5)
    800055b2:	00e78fa3          	sb	a4,31(a5)
}
    800055b6:	60a2                	ld	ra,8(sp)
    800055b8:	6402                	ld	s0,0(sp)
    800055ba:	0141                	addi	sp,sp,16
    800055bc:	8082                	ret
    panic("could not find virtio disk");
    800055be:	00003517          	auipc	a0,0x3
    800055c2:	07250513          	addi	a0,a0,114 # 80008630 <etext+0x630>
    800055c6:	00001097          	auipc	ra,0x1
    800055ca:	8bc080e7          	jalr	-1860(ra) # 80005e82 <panic>
    panic("virtio disk has no queue 0");
    800055ce:	00003517          	auipc	a0,0x3
    800055d2:	08250513          	addi	a0,a0,130 # 80008650 <etext+0x650>
    800055d6:	00001097          	auipc	ra,0x1
    800055da:	8ac080e7          	jalr	-1876(ra) # 80005e82 <panic>
    panic("virtio disk max queue too short");
    800055de:	00003517          	auipc	a0,0x3
    800055e2:	09250513          	addi	a0,a0,146 # 80008670 <etext+0x670>
    800055e6:	00001097          	auipc	ra,0x1
    800055ea:	89c080e7          	jalr	-1892(ra) # 80005e82 <panic>

00000000800055ee <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800055ee:	711d                	addi	sp,sp,-96
    800055f0:	ec86                	sd	ra,88(sp)
    800055f2:	e8a2                	sd	s0,80(sp)
    800055f4:	e4a6                	sd	s1,72(sp)
    800055f6:	e0ca                	sd	s2,64(sp)
    800055f8:	fc4e                	sd	s3,56(sp)
    800055fa:	f852                	sd	s4,48(sp)
    800055fc:	f456                	sd	s5,40(sp)
    800055fe:	f05a                	sd	s6,32(sp)
    80005600:	ec5e                	sd	s7,24(sp)
    80005602:	e862                	sd	s8,16(sp)
    80005604:	1080                	addi	s0,sp,96
    80005606:	89aa                	mv	s3,a0
    80005608:	8c2e                	mv	s8,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    8000560a:	00c52b83          	lw	s7,12(a0)
    8000560e:	001b9b9b          	slliw	s7,s7,0x1
    80005612:	1b82                	slli	s7,s7,0x20
    80005614:	020bdb93          	srli	s7,s7,0x20

  acquire(&disk.vdisk_lock);
    80005618:	00038517          	auipc	a0,0x38
    8000561c:	b1050513          	addi	a0,a0,-1264 # 8003d128 <disk+0x2128>
    80005620:	00001097          	auipc	ra,0x1
    80005624:	de2080e7          	jalr	-542(ra) # 80006402 <acquire>
  for(int i = 0; i < NUM; i++){
    80005628:	44a1                	li	s1,8
      disk.free[i] = 0;
    8000562a:	00036b17          	auipc	s6,0x36
    8000562e:	9d6b0b13          	addi	s6,s6,-1578 # 8003b000 <disk>
    80005632:	6a89                	lui	s5,0x2
  for(int i = 0; i < 3; i++){
    80005634:	4a0d                	li	s4,3
    80005636:	a88d                	j	800056a8 <virtio_disk_rw+0xba>
      disk.free[i] = 0;
    80005638:	00fb0733          	add	a4,s6,a5
    8000563c:	9756                	add	a4,a4,s5
    8000563e:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80005642:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80005644:	0207c563          	bltz	a5,8000566e <virtio_disk_rw+0x80>
  for(int i = 0; i < 3; i++){
    80005648:	2905                	addiw	s2,s2,1
    8000564a:	0611                	addi	a2,a2,4 # 2004 <_entry-0x7fffdffc>
    8000564c:	1b490063          	beq	s2,s4,800057ec <virtio_disk_rw+0x1fe>
    idx[i] = alloc_desc();
    80005650:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80005652:	00038717          	auipc	a4,0x38
    80005656:	9c670713          	addi	a4,a4,-1594 # 8003d018 <disk+0x2018>
    8000565a:	4781                	li	a5,0
    if(disk.free[i]){
    8000565c:	00074683          	lbu	a3,0(a4)
    80005660:	fee1                	bnez	a3,80005638 <virtio_disk_rw+0x4a>
  for(int i = 0; i < NUM; i++){
    80005662:	2785                	addiw	a5,a5,1
    80005664:	0705                	addi	a4,a4,1
    80005666:	fe979be3          	bne	a5,s1,8000565c <virtio_disk_rw+0x6e>
    idx[i] = alloc_desc();
    8000566a:	57fd                	li	a5,-1
    8000566c:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    8000566e:	03205163          	blez	s2,80005690 <virtio_disk_rw+0xa2>
        free_desc(idx[j]);
    80005672:	fa042503          	lw	a0,-96(s0)
    80005676:	00000097          	auipc	ra,0x0
    8000567a:	d94080e7          	jalr	-620(ra) # 8000540a <free_desc>
      for(int j = 0; j < i; j++)
    8000567e:	4785                	li	a5,1
    80005680:	0127d863          	bge	a5,s2,80005690 <virtio_disk_rw+0xa2>
        free_desc(idx[j]);
    80005684:	fa442503          	lw	a0,-92(s0)
    80005688:	00000097          	auipc	ra,0x0
    8000568c:	d82080e7          	jalr	-638(ra) # 8000540a <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005690:	00038597          	auipc	a1,0x38
    80005694:	a9858593          	addi	a1,a1,-1384 # 8003d128 <disk+0x2128>
    80005698:	00038517          	auipc	a0,0x38
    8000569c:	98050513          	addi	a0,a0,-1664 # 8003d018 <disk+0x2018>
    800056a0:	ffffc097          	auipc	ra,0xffffc
    800056a4:	008080e7          	jalr	8(ra) # 800016a8 <sleep>
  for(int i = 0; i < 3; i++){
    800056a8:	fa040613          	addi	a2,s0,-96
    800056ac:	4901                	li	s2,0
    800056ae:	b74d                	j	80005650 <virtio_disk_rw+0x62>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    800056b0:	00038717          	auipc	a4,0x38
    800056b4:	95073703          	ld	a4,-1712(a4) # 8003d000 <disk+0x2000>
    800056b8:	973e                	add	a4,a4,a5
    800056ba:	00071623          	sh	zero,12(a4)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800056be:	00036897          	auipc	a7,0x36
    800056c2:	94288893          	addi	a7,a7,-1726 # 8003b000 <disk>
    800056c6:	00038717          	auipc	a4,0x38
    800056ca:	93a70713          	addi	a4,a4,-1734 # 8003d000 <disk+0x2000>
    800056ce:	6314                	ld	a3,0(a4)
    800056d0:	96be                	add	a3,a3,a5
    800056d2:	00c6d583          	lhu	a1,12(a3) # 1000100c <_entry-0x6fffeff4>
    800056d6:	0015e593          	ori	a1,a1,1
    800056da:	00b69623          	sh	a1,12(a3)
  disk.desc[idx[1]].next = idx[2];
    800056de:	fa842683          	lw	a3,-88(s0)
    800056e2:	630c                	ld	a1,0(a4)
    800056e4:	97ae                	add	a5,a5,a1
    800056e6:	00d79723          	sh	a3,14(a5)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800056ea:	20050593          	addi	a1,a0,512
    800056ee:	0592                	slli	a1,a1,0x4
    800056f0:	95c6                	add	a1,a1,a7
    800056f2:	57fd                	li	a5,-1
    800056f4:	02f58823          	sb	a5,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800056f8:	00469793          	slli	a5,a3,0x4
    800056fc:	00073803          	ld	a6,0(a4)
    80005700:	983e                	add	a6,a6,a5
    80005702:	6689                	lui	a3,0x2
    80005704:	03068693          	addi	a3,a3,48 # 2030 <_entry-0x7fffdfd0>
    80005708:	96b2                	add	a3,a3,a2
    8000570a:	96c6                	add	a3,a3,a7
    8000570c:	00d83023          	sd	a3,0(a6)
  disk.desc[idx[2]].len = 1;
    80005710:	6314                	ld	a3,0(a4)
    80005712:	96be                	add	a3,a3,a5
    80005714:	4605                	li	a2,1
    80005716:	c690                	sw	a2,8(a3)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005718:	6314                	ld	a3,0(a4)
    8000571a:	96be                	add	a3,a3,a5
    8000571c:	4809                	li	a6,2
    8000571e:	01069623          	sh	a6,12(a3)
  disk.desc[idx[2]].next = 0;
    80005722:	6314                	ld	a3,0(a4)
    80005724:	97b6                	add	a5,a5,a3
    80005726:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000572a:	00c9a223          	sw	a2,4(s3)
  disk.info[idx[0]].b = b;
    8000572e:	0335b423          	sd	s3,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005732:	6714                	ld	a3,8(a4)
    80005734:	0026d783          	lhu	a5,2(a3)
    80005738:	8b9d                	andi	a5,a5,7
    8000573a:	0786                	slli	a5,a5,0x1
    8000573c:	96be                	add	a3,a3,a5
    8000573e:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80005742:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005746:	6718                	ld	a4,8(a4)
    80005748:	00275783          	lhu	a5,2(a4)
    8000574c:	2785                	addiw	a5,a5,1
    8000574e:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005752:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005756:	100017b7          	lui	a5,0x10001
    8000575a:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    8000575e:	0049a783          	lw	a5,4(s3)
    80005762:	02c79163          	bne	a5,a2,80005784 <virtio_disk_rw+0x196>
    sleep(b, &disk.vdisk_lock);
    80005766:	00038917          	auipc	s2,0x38
    8000576a:	9c290913          	addi	s2,s2,-1598 # 8003d128 <disk+0x2128>
  while(b->disk == 1) {
    8000576e:	84b2                	mv	s1,a2
    sleep(b, &disk.vdisk_lock);
    80005770:	85ca                	mv	a1,s2
    80005772:	854e                	mv	a0,s3
    80005774:	ffffc097          	auipc	ra,0xffffc
    80005778:	f34080e7          	jalr	-204(ra) # 800016a8 <sleep>
  while(b->disk == 1) {
    8000577c:	0049a783          	lw	a5,4(s3)
    80005780:	fe9788e3          	beq	a5,s1,80005770 <virtio_disk_rw+0x182>
  }

  disk.info[idx[0]].b = 0;
    80005784:	fa042903          	lw	s2,-96(s0)
    80005788:	20090713          	addi	a4,s2,512
    8000578c:	0712                	slli	a4,a4,0x4
    8000578e:	00036797          	auipc	a5,0x36
    80005792:	87278793          	addi	a5,a5,-1934 # 8003b000 <disk>
    80005796:	97ba                	add	a5,a5,a4
    80005798:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    8000579c:	00038997          	auipc	s3,0x38
    800057a0:	86498993          	addi	s3,s3,-1948 # 8003d000 <disk+0x2000>
    800057a4:	00491713          	slli	a4,s2,0x4
    800057a8:	0009b783          	ld	a5,0(s3)
    800057ac:	97ba                	add	a5,a5,a4
    800057ae:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800057b2:	854a                	mv	a0,s2
    800057b4:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800057b8:	00000097          	auipc	ra,0x0
    800057bc:	c52080e7          	jalr	-942(ra) # 8000540a <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800057c0:	8885                	andi	s1,s1,1
    800057c2:	f0ed                	bnez	s1,800057a4 <virtio_disk_rw+0x1b6>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800057c4:	00038517          	auipc	a0,0x38
    800057c8:	96450513          	addi	a0,a0,-1692 # 8003d128 <disk+0x2128>
    800057cc:	00001097          	auipc	ra,0x1
    800057d0:	ce6080e7          	jalr	-794(ra) # 800064b2 <release>
}
    800057d4:	60e6                	ld	ra,88(sp)
    800057d6:	6446                	ld	s0,80(sp)
    800057d8:	64a6                	ld	s1,72(sp)
    800057da:	6906                	ld	s2,64(sp)
    800057dc:	79e2                	ld	s3,56(sp)
    800057de:	7a42                	ld	s4,48(sp)
    800057e0:	7aa2                	ld	s5,40(sp)
    800057e2:	7b02                	ld	s6,32(sp)
    800057e4:	6be2                	ld	s7,24(sp)
    800057e6:	6c42                	ld	s8,16(sp)
    800057e8:	6125                	addi	sp,sp,96
    800057ea:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800057ec:	fa042503          	lw	a0,-96(s0)
    800057f0:	00451613          	slli	a2,a0,0x4
  if(write)
    800057f4:	00036597          	auipc	a1,0x36
    800057f8:	80c58593          	addi	a1,a1,-2036 # 8003b000 <disk>
    800057fc:	20050793          	addi	a5,a0,512
    80005800:	0792                	slli	a5,a5,0x4
    80005802:	97ae                	add	a5,a5,a1
    80005804:	01803733          	snez	a4,s8
    80005808:	0ae7a423          	sw	a4,168(a5)
  buf0->reserved = 0;
    8000580c:	0a07a623          	sw	zero,172(a5)
  buf0->sector = sector;
    80005810:	0b77b823          	sd	s7,176(a5)
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005814:	00037717          	auipc	a4,0x37
    80005818:	7ec70713          	addi	a4,a4,2028 # 8003d000 <disk+0x2000>
    8000581c:	6314                	ld	a3,0(a4)
    8000581e:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005820:	6789                	lui	a5,0x2
    80005822:	0a878793          	addi	a5,a5,168 # 20a8 <_entry-0x7fffdf58>
    80005826:	97b2                	add	a5,a5,a2
    80005828:	97ae                	add	a5,a5,a1
  disk.desc[idx[0]].addr = (uint64) buf0;
    8000582a:	e29c                	sd	a5,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000582c:	631c                	ld	a5,0(a4)
    8000582e:	97b2                	add	a5,a5,a2
    80005830:	46c1                	li	a3,16
    80005832:	c794                	sw	a3,8(a5)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005834:	631c                	ld	a5,0(a4)
    80005836:	97b2                	add	a5,a5,a2
    80005838:	4685                	li	a3,1
    8000583a:	00d79623          	sh	a3,12(a5)
  disk.desc[idx[0]].next = idx[1];
    8000583e:	fa442783          	lw	a5,-92(s0)
    80005842:	6314                	ld	a3,0(a4)
    80005844:	96b2                	add	a3,a3,a2
    80005846:	00f69723          	sh	a5,14(a3)
  disk.desc[idx[1]].addr = (uint64) b->data;
    8000584a:	0792                	slli	a5,a5,0x4
    8000584c:	6314                	ld	a3,0(a4)
    8000584e:	96be                	add	a3,a3,a5
    80005850:	05898593          	addi	a1,s3,88
    80005854:	e28c                	sd	a1,0(a3)
  disk.desc[idx[1]].len = BSIZE;
    80005856:	6318                	ld	a4,0(a4)
    80005858:	973e                	add	a4,a4,a5
    8000585a:	40000693          	li	a3,1024
    8000585e:	c714                	sw	a3,8(a4)
  if(write)
    80005860:	e40c18e3          	bnez	s8,800056b0 <virtio_disk_rw+0xc2>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80005864:	00037717          	auipc	a4,0x37
    80005868:	79c73703          	ld	a4,1948(a4) # 8003d000 <disk+0x2000>
    8000586c:	973e                	add	a4,a4,a5
    8000586e:	4689                	li	a3,2
    80005870:	00d71623          	sh	a3,12(a4)
    80005874:	b5a9                	j	800056be <virtio_disk_rw+0xd0>

0000000080005876 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005876:	1101                	addi	sp,sp,-32
    80005878:	ec06                	sd	ra,24(sp)
    8000587a:	e822                	sd	s0,16(sp)
    8000587c:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000587e:	00038517          	auipc	a0,0x38
    80005882:	8aa50513          	addi	a0,a0,-1878 # 8003d128 <disk+0x2128>
    80005886:	00001097          	auipc	ra,0x1
    8000588a:	b7c080e7          	jalr	-1156(ra) # 80006402 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    8000588e:	100017b7          	lui	a5,0x10001
    80005892:	53bc                	lw	a5,96(a5)
    80005894:	8b8d                	andi	a5,a5,3
    80005896:	10001737          	lui	a4,0x10001
    8000589a:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    8000589c:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800058a0:	00037797          	auipc	a5,0x37
    800058a4:	76078793          	addi	a5,a5,1888 # 8003d000 <disk+0x2000>
    800058a8:	6b94                	ld	a3,16(a5)
    800058aa:	0207d703          	lhu	a4,32(a5)
    800058ae:	0026d783          	lhu	a5,2(a3)
    800058b2:	06f70563          	beq	a4,a5,8000591c <virtio_disk_intr+0xa6>
    800058b6:	e426                	sd	s1,8(sp)
    800058b8:	e04a                	sd	s2,0(sp)
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800058ba:	00035917          	auipc	s2,0x35
    800058be:	74690913          	addi	s2,s2,1862 # 8003b000 <disk>
    800058c2:	00037497          	auipc	s1,0x37
    800058c6:	73e48493          	addi	s1,s1,1854 # 8003d000 <disk+0x2000>
    __sync_synchronize();
    800058ca:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800058ce:	6898                	ld	a4,16(s1)
    800058d0:	0204d783          	lhu	a5,32(s1)
    800058d4:	8b9d                	andi	a5,a5,7
    800058d6:	078e                	slli	a5,a5,0x3
    800058d8:	97ba                	add	a5,a5,a4
    800058da:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800058dc:	20078713          	addi	a4,a5,512
    800058e0:	0712                	slli	a4,a4,0x4
    800058e2:	974a                	add	a4,a4,s2
    800058e4:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    800058e8:	e731                	bnez	a4,80005934 <virtio_disk_intr+0xbe>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800058ea:	20078793          	addi	a5,a5,512
    800058ee:	0792                	slli	a5,a5,0x4
    800058f0:	97ca                	add	a5,a5,s2
    800058f2:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    800058f4:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800058f8:	ffffc097          	auipc	ra,0xffffc
    800058fc:	f36080e7          	jalr	-202(ra) # 8000182e <wakeup>

    disk.used_idx += 1;
    80005900:	0204d783          	lhu	a5,32(s1)
    80005904:	2785                	addiw	a5,a5,1
    80005906:	17c2                	slli	a5,a5,0x30
    80005908:	93c1                	srli	a5,a5,0x30
    8000590a:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    8000590e:	6898                	ld	a4,16(s1)
    80005910:	00275703          	lhu	a4,2(a4)
    80005914:	faf71be3          	bne	a4,a5,800058ca <virtio_disk_intr+0x54>
    80005918:	64a2                	ld	s1,8(sp)
    8000591a:	6902                	ld	s2,0(sp)
  }

  release(&disk.vdisk_lock);
    8000591c:	00038517          	auipc	a0,0x38
    80005920:	80c50513          	addi	a0,a0,-2036 # 8003d128 <disk+0x2128>
    80005924:	00001097          	auipc	ra,0x1
    80005928:	b8e080e7          	jalr	-1138(ra) # 800064b2 <release>
}
    8000592c:	60e2                	ld	ra,24(sp)
    8000592e:	6442                	ld	s0,16(sp)
    80005930:	6105                	addi	sp,sp,32
    80005932:	8082                	ret
      panic("virtio_disk_intr status");
    80005934:	00003517          	auipc	a0,0x3
    80005938:	d5c50513          	addi	a0,a0,-676 # 80008690 <etext+0x690>
    8000593c:	00000097          	auipc	ra,0x0
    80005940:	546080e7          	jalr	1350(ra) # 80005e82 <panic>

0000000080005944 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005944:	1141                	addi	sp,sp,-16
    80005946:	e406                	sd	ra,8(sp)
    80005948:	e022                	sd	s0,0(sp)
    8000594a:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000594c:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005950:	2781                	sext.w	a5,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005952:	0037961b          	slliw	a2,a5,0x3
    80005956:	02004737          	lui	a4,0x2004
    8000595a:	963a                	add	a2,a2,a4
    8000595c:	0200c737          	lui	a4,0x200c
    80005960:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005964:	000f46b7          	lui	a3,0xf4
    80005968:	24068693          	addi	a3,a3,576 # f4240 <_entry-0x7ff0bdc0>
    8000596c:	9736                	add	a4,a4,a3
    8000596e:	e218                	sd	a4,0(a2)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005970:	00279713          	slli	a4,a5,0x2
    80005974:	973e                	add	a4,a4,a5
    80005976:	070e                	slli	a4,a4,0x3
    80005978:	00038797          	auipc	a5,0x38
    8000597c:	68878793          	addi	a5,a5,1672 # 8003e000 <timer_scratch>
    80005980:	97ba                	add	a5,a5,a4
  scratch[3] = CLINT_MTIMECMP(id);
    80005982:	ef90                	sd	a2,24(a5)
  scratch[4] = interval;
    80005984:	f394                	sd	a3,32(a5)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005986:	34079073          	csrw	mscratch,a5
  asm volatile("csrw mtvec, %0" : : "r" (x));
    8000598a:	00000797          	auipc	a5,0x0
    8000598e:	9b678793          	addi	a5,a5,-1610 # 80005340 <timervec>
    80005992:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005996:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    8000599a:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    8000599e:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    800059a2:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    800059a6:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    800059aa:	30479073          	csrw	mie,a5
}
    800059ae:	60a2                	ld	ra,8(sp)
    800059b0:	6402                	ld	s0,0(sp)
    800059b2:	0141                	addi	sp,sp,16
    800059b4:	8082                	ret

00000000800059b6 <start>:
{
    800059b6:	1141                	addi	sp,sp,-16
    800059b8:	e406                	sd	ra,8(sp)
    800059ba:	e022                	sd	s0,0(sp)
    800059bc:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800059be:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800059c2:	7779                	lui	a4,0xffffe
    800059c4:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffb85bf>
    800059c8:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800059ca:	6705                	lui	a4,0x1
    800059cc:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800059d0:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800059d2:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800059d6:	ffffb797          	auipc	a5,0xffffb
    800059da:	a6878793          	addi	a5,a5,-1432 # 8000043e <main>
    800059de:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800059e2:	4781                	li	a5,0
    800059e4:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800059e8:	67c1                	lui	a5,0x10
    800059ea:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    800059ec:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800059f0:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800059f4:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800059f8:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800059fc:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005a00:	57fd                	li	a5,-1
    80005a02:	83a9                	srli	a5,a5,0xa
    80005a04:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005a08:	47bd                	li	a5,15
    80005a0a:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005a0e:	00000097          	auipc	ra,0x0
    80005a12:	f36080e7          	jalr	-202(ra) # 80005944 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005a16:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005a1a:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005a1c:	823e                	mv	tp,a5
  asm volatile("mret");
    80005a1e:	30200073          	mret
}
    80005a22:	60a2                	ld	ra,8(sp)
    80005a24:	6402                	ld	s0,0(sp)
    80005a26:	0141                	addi	sp,sp,16
    80005a28:	8082                	ret

0000000080005a2a <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005a2a:	711d                	addi	sp,sp,-96
    80005a2c:	ec86                	sd	ra,88(sp)
    80005a2e:	e8a2                	sd	s0,80(sp)
    80005a30:	e0ca                	sd	s2,64(sp)
    80005a32:	1080                	addi	s0,sp,96
  int i;

  for(i = 0; i < n; i++){
    80005a34:	04c05c63          	blez	a2,80005a8c <consolewrite+0x62>
    80005a38:	e4a6                	sd	s1,72(sp)
    80005a3a:	fc4e                	sd	s3,56(sp)
    80005a3c:	f852                	sd	s4,48(sp)
    80005a3e:	f456                	sd	s5,40(sp)
    80005a40:	f05a                	sd	s6,32(sp)
    80005a42:	ec5e                	sd	s7,24(sp)
    80005a44:	8a2a                	mv	s4,a0
    80005a46:	84ae                	mv	s1,a1
    80005a48:	89b2                	mv	s3,a2
    80005a4a:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005a4c:	faf40b93          	addi	s7,s0,-81
    80005a50:	4b05                	li	s6,1
    80005a52:	5afd                	li	s5,-1
    80005a54:	86da                	mv	a3,s6
    80005a56:	8626                	mv	a2,s1
    80005a58:	85d2                	mv	a1,s4
    80005a5a:	855e                	mv	a0,s7
    80005a5c:	ffffc097          	auipc	ra,0xffffc
    80005a60:	040080e7          	jalr	64(ra) # 80001a9c <either_copyin>
    80005a64:	03550663          	beq	a0,s5,80005a90 <consolewrite+0x66>
      break;
    uartputc(c);
    80005a68:	faf44503          	lbu	a0,-81(s0)
    80005a6c:	00000097          	auipc	ra,0x0
    80005a70:	7d4080e7          	jalr	2004(ra) # 80006240 <uartputc>
  for(i = 0; i < n; i++){
    80005a74:	2905                	addiw	s2,s2,1
    80005a76:	0485                	addi	s1,s1,1
    80005a78:	fd299ee3          	bne	s3,s2,80005a54 <consolewrite+0x2a>
    80005a7c:	894e                	mv	s2,s3
    80005a7e:	64a6                	ld	s1,72(sp)
    80005a80:	79e2                	ld	s3,56(sp)
    80005a82:	7a42                	ld	s4,48(sp)
    80005a84:	7aa2                	ld	s5,40(sp)
    80005a86:	7b02                	ld	s6,32(sp)
    80005a88:	6be2                	ld	s7,24(sp)
    80005a8a:	a809                	j	80005a9c <consolewrite+0x72>
    80005a8c:	4901                	li	s2,0
    80005a8e:	a039                	j	80005a9c <consolewrite+0x72>
    80005a90:	64a6                	ld	s1,72(sp)
    80005a92:	79e2                	ld	s3,56(sp)
    80005a94:	7a42                	ld	s4,48(sp)
    80005a96:	7aa2                	ld	s5,40(sp)
    80005a98:	7b02                	ld	s6,32(sp)
    80005a9a:	6be2                	ld	s7,24(sp)
  }

  return i;
}
    80005a9c:	854a                	mv	a0,s2
    80005a9e:	60e6                	ld	ra,88(sp)
    80005aa0:	6446                	ld	s0,80(sp)
    80005aa2:	6906                	ld	s2,64(sp)
    80005aa4:	6125                	addi	sp,sp,96
    80005aa6:	8082                	ret

0000000080005aa8 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005aa8:	711d                	addi	sp,sp,-96
    80005aaa:	ec86                	sd	ra,88(sp)
    80005aac:	e8a2                	sd	s0,80(sp)
    80005aae:	e4a6                	sd	s1,72(sp)
    80005ab0:	e0ca                	sd	s2,64(sp)
    80005ab2:	fc4e                	sd	s3,56(sp)
    80005ab4:	f852                	sd	s4,48(sp)
    80005ab6:	f456                	sd	s5,40(sp)
    80005ab8:	f05a                	sd	s6,32(sp)
    80005aba:	1080                	addi	s0,sp,96
    80005abc:	8aaa                	mv	s5,a0
    80005abe:	8a2e                	mv	s4,a1
    80005ac0:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005ac2:	8b32                	mv	s6,a2
  acquire(&cons.lock);
    80005ac4:	00040517          	auipc	a0,0x40
    80005ac8:	67c50513          	addi	a0,a0,1660 # 80046140 <cons>
    80005acc:	00001097          	auipc	ra,0x1
    80005ad0:	936080e7          	jalr	-1738(ra) # 80006402 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005ad4:	00040497          	auipc	s1,0x40
    80005ad8:	66c48493          	addi	s1,s1,1644 # 80046140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005adc:	00040917          	auipc	s2,0x40
    80005ae0:	6fc90913          	addi	s2,s2,1788 # 800461d8 <cons+0x98>
  while(n > 0){
    80005ae4:	0d305263          	blez	s3,80005ba8 <consoleread+0x100>
    while(cons.r == cons.w){
    80005ae8:	0984a783          	lw	a5,152(s1)
    80005aec:	09c4a703          	lw	a4,156(s1)
    80005af0:	0af71763          	bne	a4,a5,80005b9e <consoleread+0xf6>
      if(myproc()->killed){
    80005af4:	ffffb097          	auipc	ra,0xffffb
    80005af8:	4ee080e7          	jalr	1262(ra) # 80000fe2 <myproc>
    80005afc:	551c                	lw	a5,40(a0)
    80005afe:	e7ad                	bnez	a5,80005b68 <consoleread+0xc0>
      sleep(&cons.r, &cons.lock);
    80005b00:	85a6                	mv	a1,s1
    80005b02:	854a                	mv	a0,s2
    80005b04:	ffffc097          	auipc	ra,0xffffc
    80005b08:	ba4080e7          	jalr	-1116(ra) # 800016a8 <sleep>
    while(cons.r == cons.w){
    80005b0c:	0984a783          	lw	a5,152(s1)
    80005b10:	09c4a703          	lw	a4,156(s1)
    80005b14:	fef700e3          	beq	a4,a5,80005af4 <consoleread+0x4c>
    80005b18:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF];
    80005b1a:	00040717          	auipc	a4,0x40
    80005b1e:	62670713          	addi	a4,a4,1574 # 80046140 <cons>
    80005b22:	0017869b          	addiw	a3,a5,1
    80005b26:	08d72c23          	sw	a3,152(a4)
    80005b2a:	07f7f693          	andi	a3,a5,127
    80005b2e:	9736                	add	a4,a4,a3
    80005b30:	01874703          	lbu	a4,24(a4)
    80005b34:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80005b38:	4691                	li	a3,4
    80005b3a:	04db8a63          	beq	s7,a3,80005b8e <consoleread+0xe6>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80005b3e:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005b42:	4685                	li	a3,1
    80005b44:	faf40613          	addi	a2,s0,-81
    80005b48:	85d2                	mv	a1,s4
    80005b4a:	8556                	mv	a0,s5
    80005b4c:	ffffc097          	auipc	ra,0xffffc
    80005b50:	efa080e7          	jalr	-262(ra) # 80001a46 <either_copyout>
    80005b54:	57fd                	li	a5,-1
    80005b56:	04f50863          	beq	a0,a5,80005ba6 <consoleread+0xfe>
      break;

    dst++;
    80005b5a:	0a05                	addi	s4,s4,1
    --n;
    80005b5c:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    80005b5e:	47a9                	li	a5,10
    80005b60:	04fb8f63          	beq	s7,a5,80005bbe <consoleread+0x116>
    80005b64:	6be2                	ld	s7,24(sp)
    80005b66:	bfbd                	j	80005ae4 <consoleread+0x3c>
        release(&cons.lock);
    80005b68:	00040517          	auipc	a0,0x40
    80005b6c:	5d850513          	addi	a0,a0,1496 # 80046140 <cons>
    80005b70:	00001097          	auipc	ra,0x1
    80005b74:	942080e7          	jalr	-1726(ra) # 800064b2 <release>
        return -1;
    80005b78:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80005b7a:	60e6                	ld	ra,88(sp)
    80005b7c:	6446                	ld	s0,80(sp)
    80005b7e:	64a6                	ld	s1,72(sp)
    80005b80:	6906                	ld	s2,64(sp)
    80005b82:	79e2                	ld	s3,56(sp)
    80005b84:	7a42                	ld	s4,48(sp)
    80005b86:	7aa2                	ld	s5,40(sp)
    80005b88:	7b02                	ld	s6,32(sp)
    80005b8a:	6125                	addi	sp,sp,96
    80005b8c:	8082                	ret
      if(n < target){
    80005b8e:	0169fa63          	bgeu	s3,s6,80005ba2 <consoleread+0xfa>
        cons.r--;
    80005b92:	00040717          	auipc	a4,0x40
    80005b96:	64f72323          	sw	a5,1606(a4) # 800461d8 <cons+0x98>
    80005b9a:	6be2                	ld	s7,24(sp)
    80005b9c:	a031                	j	80005ba8 <consoleread+0x100>
    80005b9e:	ec5e                	sd	s7,24(sp)
    80005ba0:	bfad                	j	80005b1a <consoleread+0x72>
    80005ba2:	6be2                	ld	s7,24(sp)
    80005ba4:	a011                	j	80005ba8 <consoleread+0x100>
    80005ba6:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80005ba8:	00040517          	auipc	a0,0x40
    80005bac:	59850513          	addi	a0,a0,1432 # 80046140 <cons>
    80005bb0:	00001097          	auipc	ra,0x1
    80005bb4:	902080e7          	jalr	-1790(ra) # 800064b2 <release>
  return target - n;
    80005bb8:	413b053b          	subw	a0,s6,s3
    80005bbc:	bf7d                	j	80005b7a <consoleread+0xd2>
    80005bbe:	6be2                	ld	s7,24(sp)
    80005bc0:	b7e5                	j	80005ba8 <consoleread+0x100>

0000000080005bc2 <consputc>:
{
    80005bc2:	1141                	addi	sp,sp,-16
    80005bc4:	e406                	sd	ra,8(sp)
    80005bc6:	e022                	sd	s0,0(sp)
    80005bc8:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005bca:	10000793          	li	a5,256
    80005bce:	00f50a63          	beq	a0,a5,80005be2 <consputc+0x20>
    uartputc_sync(c);
    80005bd2:	00000097          	auipc	ra,0x0
    80005bd6:	590080e7          	jalr	1424(ra) # 80006162 <uartputc_sync>
}
    80005bda:	60a2                	ld	ra,8(sp)
    80005bdc:	6402                	ld	s0,0(sp)
    80005bde:	0141                	addi	sp,sp,16
    80005be0:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005be2:	4521                	li	a0,8
    80005be4:	00000097          	auipc	ra,0x0
    80005be8:	57e080e7          	jalr	1406(ra) # 80006162 <uartputc_sync>
    80005bec:	02000513          	li	a0,32
    80005bf0:	00000097          	auipc	ra,0x0
    80005bf4:	572080e7          	jalr	1394(ra) # 80006162 <uartputc_sync>
    80005bf8:	4521                	li	a0,8
    80005bfa:	00000097          	auipc	ra,0x0
    80005bfe:	568080e7          	jalr	1384(ra) # 80006162 <uartputc_sync>
    80005c02:	bfe1                	j	80005bda <consputc+0x18>

0000000080005c04 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005c04:	7179                	addi	sp,sp,-48
    80005c06:	f406                	sd	ra,40(sp)
    80005c08:	f022                	sd	s0,32(sp)
    80005c0a:	ec26                	sd	s1,24(sp)
    80005c0c:	1800                	addi	s0,sp,48
    80005c0e:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005c10:	00040517          	auipc	a0,0x40
    80005c14:	53050513          	addi	a0,a0,1328 # 80046140 <cons>
    80005c18:	00000097          	auipc	ra,0x0
    80005c1c:	7ea080e7          	jalr	2026(ra) # 80006402 <acquire>

  switch(c){
    80005c20:	47d5                	li	a5,21
    80005c22:	0af48463          	beq	s1,a5,80005cca <consoleintr+0xc6>
    80005c26:	0297c963          	blt	a5,s1,80005c58 <consoleintr+0x54>
    80005c2a:	47a1                	li	a5,8
    80005c2c:	10f48063          	beq	s1,a5,80005d2c <consoleintr+0x128>
    80005c30:	47c1                	li	a5,16
    80005c32:	12f49363          	bne	s1,a5,80005d58 <consoleintr+0x154>
  case C('P'):  // Print process list.
    procdump();
    80005c36:	ffffc097          	auipc	ra,0xffffc
    80005c3a:	ebc080e7          	jalr	-324(ra) # 80001af2 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005c3e:	00040517          	auipc	a0,0x40
    80005c42:	50250513          	addi	a0,a0,1282 # 80046140 <cons>
    80005c46:	00001097          	auipc	ra,0x1
    80005c4a:	86c080e7          	jalr	-1940(ra) # 800064b2 <release>
}
    80005c4e:	70a2                	ld	ra,40(sp)
    80005c50:	7402                	ld	s0,32(sp)
    80005c52:	64e2                	ld	s1,24(sp)
    80005c54:	6145                	addi	sp,sp,48
    80005c56:	8082                	ret
  switch(c){
    80005c58:	07f00793          	li	a5,127
    80005c5c:	0cf48863          	beq	s1,a5,80005d2c <consoleintr+0x128>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005c60:	00040717          	auipc	a4,0x40
    80005c64:	4e070713          	addi	a4,a4,1248 # 80046140 <cons>
    80005c68:	0a072783          	lw	a5,160(a4)
    80005c6c:	09872703          	lw	a4,152(a4)
    80005c70:	9f99                	subw	a5,a5,a4
    80005c72:	07f00713          	li	a4,127
    80005c76:	fcf764e3          	bltu	a4,a5,80005c3e <consoleintr+0x3a>
      c = (c == '\r') ? '\n' : c;
    80005c7a:	47b5                	li	a5,13
    80005c7c:	0ef48163          	beq	s1,a5,80005d5e <consoleintr+0x15a>
      consputc(c);
    80005c80:	8526                	mv	a0,s1
    80005c82:	00000097          	auipc	ra,0x0
    80005c86:	f40080e7          	jalr	-192(ra) # 80005bc2 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005c8a:	00040797          	auipc	a5,0x40
    80005c8e:	4b678793          	addi	a5,a5,1206 # 80046140 <cons>
    80005c92:	0a07a703          	lw	a4,160(a5)
    80005c96:	0017069b          	addiw	a3,a4,1
    80005c9a:	8636                	mv	a2,a3
    80005c9c:	0ad7a023          	sw	a3,160(a5)
    80005ca0:	07f77713          	andi	a4,a4,127
    80005ca4:	97ba                	add	a5,a5,a4
    80005ca6:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005caa:	47a9                	li	a5,10
    80005cac:	0cf48f63          	beq	s1,a5,80005d8a <consoleintr+0x186>
    80005cb0:	4791                	li	a5,4
    80005cb2:	0cf48c63          	beq	s1,a5,80005d8a <consoleintr+0x186>
    80005cb6:	00040797          	auipc	a5,0x40
    80005cba:	5227a783          	lw	a5,1314(a5) # 800461d8 <cons+0x98>
    80005cbe:	0807879b          	addiw	a5,a5,128
    80005cc2:	f6f69ee3          	bne	a3,a5,80005c3e <consoleintr+0x3a>
    80005cc6:	863e                	mv	a2,a5
    80005cc8:	a0c9                	j	80005d8a <consoleintr+0x186>
    80005cca:	e84a                	sd	s2,16(sp)
    80005ccc:	e44e                	sd	s3,8(sp)
    while(cons.e != cons.w &&
    80005cce:	00040717          	auipc	a4,0x40
    80005cd2:	47270713          	addi	a4,a4,1138 # 80046140 <cons>
    80005cd6:	0a072783          	lw	a5,160(a4)
    80005cda:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005cde:	00040497          	auipc	s1,0x40
    80005ce2:	46248493          	addi	s1,s1,1122 # 80046140 <cons>
    while(cons.e != cons.w &&
    80005ce6:	4929                	li	s2,10
      consputc(BACKSPACE);
    80005ce8:	10000993          	li	s3,256
    while(cons.e != cons.w &&
    80005cec:	02f70a63          	beq	a4,a5,80005d20 <consoleintr+0x11c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005cf0:	37fd                	addiw	a5,a5,-1
    80005cf2:	07f7f713          	andi	a4,a5,127
    80005cf6:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005cf8:	01874703          	lbu	a4,24(a4)
    80005cfc:	03270563          	beq	a4,s2,80005d26 <consoleintr+0x122>
      cons.e--;
    80005d00:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005d04:	854e                	mv	a0,s3
    80005d06:	00000097          	auipc	ra,0x0
    80005d0a:	ebc080e7          	jalr	-324(ra) # 80005bc2 <consputc>
    while(cons.e != cons.w &&
    80005d0e:	0a04a783          	lw	a5,160(s1)
    80005d12:	09c4a703          	lw	a4,156(s1)
    80005d16:	fcf71de3          	bne	a4,a5,80005cf0 <consoleintr+0xec>
    80005d1a:	6942                	ld	s2,16(sp)
    80005d1c:	69a2                	ld	s3,8(sp)
    80005d1e:	b705                	j	80005c3e <consoleintr+0x3a>
    80005d20:	6942                	ld	s2,16(sp)
    80005d22:	69a2                	ld	s3,8(sp)
    80005d24:	bf29                	j	80005c3e <consoleintr+0x3a>
    80005d26:	6942                	ld	s2,16(sp)
    80005d28:	69a2                	ld	s3,8(sp)
    80005d2a:	bf11                	j	80005c3e <consoleintr+0x3a>
    if(cons.e != cons.w){
    80005d2c:	00040717          	auipc	a4,0x40
    80005d30:	41470713          	addi	a4,a4,1044 # 80046140 <cons>
    80005d34:	0a072783          	lw	a5,160(a4)
    80005d38:	09c72703          	lw	a4,156(a4)
    80005d3c:	f0f701e3          	beq	a4,a5,80005c3e <consoleintr+0x3a>
      cons.e--;
    80005d40:	37fd                	addiw	a5,a5,-1
    80005d42:	00040717          	auipc	a4,0x40
    80005d46:	48f72f23          	sw	a5,1182(a4) # 800461e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005d4a:	10000513          	li	a0,256
    80005d4e:	00000097          	auipc	ra,0x0
    80005d52:	e74080e7          	jalr	-396(ra) # 80005bc2 <consputc>
    80005d56:	b5e5                	j	80005c3e <consoleintr+0x3a>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005d58:	ee0483e3          	beqz	s1,80005c3e <consoleintr+0x3a>
    80005d5c:	b711                	j	80005c60 <consoleintr+0x5c>
      consputc(c);
    80005d5e:	4529                	li	a0,10
    80005d60:	00000097          	auipc	ra,0x0
    80005d64:	e62080e7          	jalr	-414(ra) # 80005bc2 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005d68:	00040797          	auipc	a5,0x40
    80005d6c:	3d878793          	addi	a5,a5,984 # 80046140 <cons>
    80005d70:	0a07a703          	lw	a4,160(a5)
    80005d74:	0017069b          	addiw	a3,a4,1
    80005d78:	8636                	mv	a2,a3
    80005d7a:	0ad7a023          	sw	a3,160(a5)
    80005d7e:	07f77713          	andi	a4,a4,127
    80005d82:	97ba                	add	a5,a5,a4
    80005d84:	4729                	li	a4,10
    80005d86:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005d8a:	00040797          	auipc	a5,0x40
    80005d8e:	44c7a923          	sw	a2,1106(a5) # 800461dc <cons+0x9c>
        wakeup(&cons.r);
    80005d92:	00040517          	auipc	a0,0x40
    80005d96:	44650513          	addi	a0,a0,1094 # 800461d8 <cons+0x98>
    80005d9a:	ffffc097          	auipc	ra,0xffffc
    80005d9e:	a94080e7          	jalr	-1388(ra) # 8000182e <wakeup>
    80005da2:	bd71                	j	80005c3e <consoleintr+0x3a>

0000000080005da4 <consoleinit>:

void
consoleinit(void)
{
    80005da4:	1141                	addi	sp,sp,-16
    80005da6:	e406                	sd	ra,8(sp)
    80005da8:	e022                	sd	s0,0(sp)
    80005daa:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005dac:	00003597          	auipc	a1,0x3
    80005db0:	8fc58593          	addi	a1,a1,-1796 # 800086a8 <etext+0x6a8>
    80005db4:	00040517          	auipc	a0,0x40
    80005db8:	38c50513          	addi	a0,a0,908 # 80046140 <cons>
    80005dbc:	00000097          	auipc	ra,0x0
    80005dc0:	5b2080e7          	jalr	1458(ra) # 8000636e <initlock>

  uartinit();
    80005dc4:	00000097          	auipc	ra,0x0
    80005dc8:	344080e7          	jalr	836(ra) # 80006108 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005dcc:	00033797          	auipc	a5,0x33
    80005dd0:	31c78793          	addi	a5,a5,796 # 800390e8 <devsw>
    80005dd4:	00000717          	auipc	a4,0x0
    80005dd8:	cd470713          	addi	a4,a4,-812 # 80005aa8 <consoleread>
    80005ddc:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005dde:	00000717          	auipc	a4,0x0
    80005de2:	c4c70713          	addi	a4,a4,-948 # 80005a2a <consolewrite>
    80005de6:	ef98                	sd	a4,24(a5)
}
    80005de8:	60a2                	ld	ra,8(sp)
    80005dea:	6402                	ld	s0,0(sp)
    80005dec:	0141                	addi	sp,sp,16
    80005dee:	8082                	ret

0000000080005df0 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005df0:	7179                	addi	sp,sp,-48
    80005df2:	f406                	sd	ra,40(sp)
    80005df4:	f022                	sd	s0,32(sp)
    80005df6:	ec26                	sd	s1,24(sp)
    80005df8:	e84a                	sd	s2,16(sp)
    80005dfa:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005dfc:	c219                	beqz	a2,80005e02 <printint+0x12>
    80005dfe:	06054e63          	bltz	a0,80005e7a <printint+0x8a>
    x = -xx;
  else
    x = xx;
    80005e02:	4e01                	li	t3,0

  i = 0;
    80005e04:	fd040313          	addi	t1,s0,-48
    x = xx;
    80005e08:	869a                	mv	a3,t1
  i = 0;
    80005e0a:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    80005e0c:	00003817          	auipc	a6,0x3
    80005e10:	9fc80813          	addi	a6,a6,-1540 # 80008808 <digits>
    80005e14:	88be                	mv	a7,a5
    80005e16:	0017861b          	addiw	a2,a5,1
    80005e1a:	87b2                	mv	a5,a2
    80005e1c:	02b5773b          	remuw	a4,a0,a1
    80005e20:	1702                	slli	a4,a4,0x20
    80005e22:	9301                	srli	a4,a4,0x20
    80005e24:	9742                	add	a4,a4,a6
    80005e26:	00074703          	lbu	a4,0(a4)
    80005e2a:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    80005e2e:	872a                	mv	a4,a0
    80005e30:	02b5553b          	divuw	a0,a0,a1
    80005e34:	0685                	addi	a3,a3,1
    80005e36:	fcb77fe3          	bgeu	a4,a1,80005e14 <printint+0x24>

  if(sign)
    80005e3a:	000e0c63          	beqz	t3,80005e52 <printint+0x62>
    buf[i++] = '-';
    80005e3e:	fe060793          	addi	a5,a2,-32
    80005e42:	00878633          	add	a2,a5,s0
    80005e46:	02d00793          	li	a5,45
    80005e4a:	fef60823          	sb	a5,-16(a2)
    80005e4e:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
    80005e52:	fff7891b          	addiw	s2,a5,-1
    80005e56:	006784b3          	add	s1,a5,t1
    consputc(buf[i]);
    80005e5a:	fff4c503          	lbu	a0,-1(s1)
    80005e5e:	00000097          	auipc	ra,0x0
    80005e62:	d64080e7          	jalr	-668(ra) # 80005bc2 <consputc>
  while(--i >= 0)
    80005e66:	397d                	addiw	s2,s2,-1
    80005e68:	14fd                	addi	s1,s1,-1
    80005e6a:	fe0958e3          	bgez	s2,80005e5a <printint+0x6a>
}
    80005e6e:	70a2                	ld	ra,40(sp)
    80005e70:	7402                	ld	s0,32(sp)
    80005e72:	64e2                	ld	s1,24(sp)
    80005e74:	6942                	ld	s2,16(sp)
    80005e76:	6145                	addi	sp,sp,48
    80005e78:	8082                	ret
    x = -xx;
    80005e7a:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005e7e:	4e05                	li	t3,1
    x = -xx;
    80005e80:	b751                	j	80005e04 <printint+0x14>

0000000080005e82 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005e82:	1101                	addi	sp,sp,-32
    80005e84:	ec06                	sd	ra,24(sp)
    80005e86:	e822                	sd	s0,16(sp)
    80005e88:	e426                	sd	s1,8(sp)
    80005e8a:	1000                	addi	s0,sp,32
    80005e8c:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005e8e:	00040797          	auipc	a5,0x40
    80005e92:	3607a923          	sw	zero,882(a5) # 80046200 <pr+0x18>
  printf("panic: ");
    80005e96:	00003517          	auipc	a0,0x3
    80005e9a:	81a50513          	addi	a0,a0,-2022 # 800086b0 <etext+0x6b0>
    80005e9e:	00000097          	auipc	ra,0x0
    80005ea2:	02e080e7          	jalr	46(ra) # 80005ecc <printf>
  printf(s);
    80005ea6:	8526                	mv	a0,s1
    80005ea8:	00000097          	auipc	ra,0x0
    80005eac:	024080e7          	jalr	36(ra) # 80005ecc <printf>
  printf("\n");
    80005eb0:	00002517          	auipc	a0,0x2
    80005eb4:	17850513          	addi	a0,a0,376 # 80008028 <etext+0x28>
    80005eb8:	00000097          	auipc	ra,0x0
    80005ebc:	014080e7          	jalr	20(ra) # 80005ecc <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005ec0:	4785                	li	a5,1
    80005ec2:	00003717          	auipc	a4,0x3
    80005ec6:	14f72d23          	sw	a5,346(a4) # 8000901c <panicked>
  for(;;)
    80005eca:	a001                	j	80005eca <panic+0x48>

0000000080005ecc <printf>:
{
    80005ecc:	7131                	addi	sp,sp,-192
    80005ece:	fc86                	sd	ra,120(sp)
    80005ed0:	f8a2                	sd	s0,112(sp)
    80005ed2:	e8d2                	sd	s4,80(sp)
    80005ed4:	ec6e                	sd	s11,24(sp)
    80005ed6:	0100                	addi	s0,sp,128
    80005ed8:	8a2a                	mv	s4,a0
    80005eda:	e40c                	sd	a1,8(s0)
    80005edc:	e810                	sd	a2,16(s0)
    80005ede:	ec14                	sd	a3,24(s0)
    80005ee0:	f018                	sd	a4,32(s0)
    80005ee2:	f41c                	sd	a5,40(s0)
    80005ee4:	03043823          	sd	a6,48(s0)
    80005ee8:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005eec:	00040d97          	auipc	s11,0x40
    80005ef0:	314dad83          	lw	s11,788(s11) # 80046200 <pr+0x18>
  if(locking)
    80005ef4:	040d9463          	bnez	s11,80005f3c <printf+0x70>
  if (fmt == 0)
    80005ef8:	040a0b63          	beqz	s4,80005f4e <printf+0x82>
  va_start(ap, fmt);
    80005efc:	00840793          	addi	a5,s0,8
    80005f00:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005f04:	000a4503          	lbu	a0,0(s4)
    80005f08:	18050c63          	beqz	a0,800060a0 <printf+0x1d4>
    80005f0c:	f4a6                	sd	s1,104(sp)
    80005f0e:	f0ca                	sd	s2,96(sp)
    80005f10:	ecce                	sd	s3,88(sp)
    80005f12:	e4d6                	sd	s5,72(sp)
    80005f14:	e0da                	sd	s6,64(sp)
    80005f16:	fc5e                	sd	s7,56(sp)
    80005f18:	f862                	sd	s8,48(sp)
    80005f1a:	f466                	sd	s9,40(sp)
    80005f1c:	f06a                	sd	s10,32(sp)
    80005f1e:	4981                	li	s3,0
    if(c != '%'){
    80005f20:	02500b13          	li	s6,37
    switch(c){
    80005f24:	07000b93          	li	s7,112
  consputc('x');
    80005f28:	07800c93          	li	s9,120
    80005f2c:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005f2e:	00003a97          	auipc	s5,0x3
    80005f32:	8daa8a93          	addi	s5,s5,-1830 # 80008808 <digits>
    switch(c){
    80005f36:	07300c13          	li	s8,115
    80005f3a:	a0b9                	j	80005f88 <printf+0xbc>
    acquire(&pr.lock);
    80005f3c:	00040517          	auipc	a0,0x40
    80005f40:	2ac50513          	addi	a0,a0,684 # 800461e8 <pr>
    80005f44:	00000097          	auipc	ra,0x0
    80005f48:	4be080e7          	jalr	1214(ra) # 80006402 <acquire>
    80005f4c:	b775                	j	80005ef8 <printf+0x2c>
    80005f4e:	f4a6                	sd	s1,104(sp)
    80005f50:	f0ca                	sd	s2,96(sp)
    80005f52:	ecce                	sd	s3,88(sp)
    80005f54:	e4d6                	sd	s5,72(sp)
    80005f56:	e0da                	sd	s6,64(sp)
    80005f58:	fc5e                	sd	s7,56(sp)
    80005f5a:	f862                	sd	s8,48(sp)
    80005f5c:	f466                	sd	s9,40(sp)
    80005f5e:	f06a                	sd	s10,32(sp)
    panic("null fmt");
    80005f60:	00002517          	auipc	a0,0x2
    80005f64:	76050513          	addi	a0,a0,1888 # 800086c0 <etext+0x6c0>
    80005f68:	00000097          	auipc	ra,0x0
    80005f6c:	f1a080e7          	jalr	-230(ra) # 80005e82 <panic>
      consputc(c);
    80005f70:	00000097          	auipc	ra,0x0
    80005f74:	c52080e7          	jalr	-942(ra) # 80005bc2 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005f78:	0019879b          	addiw	a5,s3,1
    80005f7c:	89be                	mv	s3,a5
    80005f7e:	97d2                	add	a5,a5,s4
    80005f80:	0007c503          	lbu	a0,0(a5)
    80005f84:	10050563          	beqz	a0,8000608e <printf+0x1c2>
    if(c != '%'){
    80005f88:	ff6514e3          	bne	a0,s6,80005f70 <printf+0xa4>
    c = fmt[++i] & 0xff;
    80005f8c:	0019879b          	addiw	a5,s3,1
    80005f90:	89be                	mv	s3,a5
    80005f92:	97d2                	add	a5,a5,s4
    80005f94:	0007c783          	lbu	a5,0(a5)
    80005f98:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005f9c:	10078a63          	beqz	a5,800060b0 <printf+0x1e4>
    switch(c){
    80005fa0:	05778a63          	beq	a5,s7,80005ff4 <printf+0x128>
    80005fa4:	02fbf463          	bgeu	s7,a5,80005fcc <printf+0x100>
    80005fa8:	09878763          	beq	a5,s8,80006036 <printf+0x16a>
    80005fac:	0d979663          	bne	a5,s9,80006078 <printf+0x1ac>
      printint(va_arg(ap, int), 16, 1);
    80005fb0:	f8843783          	ld	a5,-120(s0)
    80005fb4:	00878713          	addi	a4,a5,8
    80005fb8:	f8e43423          	sd	a4,-120(s0)
    80005fbc:	4605                	li	a2,1
    80005fbe:	85ea                	mv	a1,s10
    80005fc0:	4388                	lw	a0,0(a5)
    80005fc2:	00000097          	auipc	ra,0x0
    80005fc6:	e2e080e7          	jalr	-466(ra) # 80005df0 <printint>
      break;
    80005fca:	b77d                	j	80005f78 <printf+0xac>
    switch(c){
    80005fcc:	0b678063          	beq	a5,s6,8000606c <printf+0x1a0>
    80005fd0:	06400713          	li	a4,100
    80005fd4:	0ae79263          	bne	a5,a4,80006078 <printf+0x1ac>
      printint(va_arg(ap, int), 10, 1);
    80005fd8:	f8843783          	ld	a5,-120(s0)
    80005fdc:	00878713          	addi	a4,a5,8
    80005fe0:	f8e43423          	sd	a4,-120(s0)
    80005fe4:	4605                	li	a2,1
    80005fe6:	45a9                	li	a1,10
    80005fe8:	4388                	lw	a0,0(a5)
    80005fea:	00000097          	auipc	ra,0x0
    80005fee:	e06080e7          	jalr	-506(ra) # 80005df0 <printint>
      break;
    80005ff2:	b759                	j	80005f78 <printf+0xac>
      printptr(va_arg(ap, uint64));
    80005ff4:	f8843783          	ld	a5,-120(s0)
    80005ff8:	00878713          	addi	a4,a5,8
    80005ffc:	f8e43423          	sd	a4,-120(s0)
    80006000:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80006004:	03000513          	li	a0,48
    80006008:	00000097          	auipc	ra,0x0
    8000600c:	bba080e7          	jalr	-1094(ra) # 80005bc2 <consputc>
  consputc('x');
    80006010:	8566                	mv	a0,s9
    80006012:	00000097          	auipc	ra,0x0
    80006016:	bb0080e7          	jalr	-1104(ra) # 80005bc2 <consputc>
    8000601a:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000601c:	03c95793          	srli	a5,s2,0x3c
    80006020:	97d6                	add	a5,a5,s5
    80006022:	0007c503          	lbu	a0,0(a5)
    80006026:	00000097          	auipc	ra,0x0
    8000602a:	b9c080e7          	jalr	-1124(ra) # 80005bc2 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    8000602e:	0912                	slli	s2,s2,0x4
    80006030:	34fd                	addiw	s1,s1,-1
    80006032:	f4ed                	bnez	s1,8000601c <printf+0x150>
    80006034:	b791                	j	80005f78 <printf+0xac>
      if((s = va_arg(ap, char*)) == 0)
    80006036:	f8843783          	ld	a5,-120(s0)
    8000603a:	00878713          	addi	a4,a5,8
    8000603e:	f8e43423          	sd	a4,-120(s0)
    80006042:	6384                	ld	s1,0(a5)
    80006044:	cc89                	beqz	s1,8000605e <printf+0x192>
      for(; *s; s++)
    80006046:	0004c503          	lbu	a0,0(s1)
    8000604a:	d51d                	beqz	a0,80005f78 <printf+0xac>
        consputc(*s);
    8000604c:	00000097          	auipc	ra,0x0
    80006050:	b76080e7          	jalr	-1162(ra) # 80005bc2 <consputc>
      for(; *s; s++)
    80006054:	0485                	addi	s1,s1,1
    80006056:	0004c503          	lbu	a0,0(s1)
    8000605a:	f96d                	bnez	a0,8000604c <printf+0x180>
    8000605c:	bf31                	j	80005f78 <printf+0xac>
        s = "(null)";
    8000605e:	00002497          	auipc	s1,0x2
    80006062:	65a48493          	addi	s1,s1,1626 # 800086b8 <etext+0x6b8>
      for(; *s; s++)
    80006066:	02800513          	li	a0,40
    8000606a:	b7cd                	j	8000604c <printf+0x180>
      consputc('%');
    8000606c:	855a                	mv	a0,s6
    8000606e:	00000097          	auipc	ra,0x0
    80006072:	b54080e7          	jalr	-1196(ra) # 80005bc2 <consputc>
      break;
    80006076:	b709                	j	80005f78 <printf+0xac>
      consputc('%');
    80006078:	855a                	mv	a0,s6
    8000607a:	00000097          	auipc	ra,0x0
    8000607e:	b48080e7          	jalr	-1208(ra) # 80005bc2 <consputc>
      consputc(c);
    80006082:	8526                	mv	a0,s1
    80006084:	00000097          	auipc	ra,0x0
    80006088:	b3e080e7          	jalr	-1218(ra) # 80005bc2 <consputc>
      break;
    8000608c:	b5f5                	j	80005f78 <printf+0xac>
    8000608e:	74a6                	ld	s1,104(sp)
    80006090:	7906                	ld	s2,96(sp)
    80006092:	69e6                	ld	s3,88(sp)
    80006094:	6aa6                	ld	s5,72(sp)
    80006096:	6b06                	ld	s6,64(sp)
    80006098:	7be2                	ld	s7,56(sp)
    8000609a:	7c42                	ld	s8,48(sp)
    8000609c:	7ca2                	ld	s9,40(sp)
    8000609e:	7d02                	ld	s10,32(sp)
  if(locking)
    800060a0:	020d9263          	bnez	s11,800060c4 <printf+0x1f8>
}
    800060a4:	70e6                	ld	ra,120(sp)
    800060a6:	7446                	ld	s0,112(sp)
    800060a8:	6a46                	ld	s4,80(sp)
    800060aa:	6de2                	ld	s11,24(sp)
    800060ac:	6129                	addi	sp,sp,192
    800060ae:	8082                	ret
    800060b0:	74a6                	ld	s1,104(sp)
    800060b2:	7906                	ld	s2,96(sp)
    800060b4:	69e6                	ld	s3,88(sp)
    800060b6:	6aa6                	ld	s5,72(sp)
    800060b8:	6b06                	ld	s6,64(sp)
    800060ba:	7be2                	ld	s7,56(sp)
    800060bc:	7c42                	ld	s8,48(sp)
    800060be:	7ca2                	ld	s9,40(sp)
    800060c0:	7d02                	ld	s10,32(sp)
    800060c2:	bff9                	j	800060a0 <printf+0x1d4>
    release(&pr.lock);
    800060c4:	00040517          	auipc	a0,0x40
    800060c8:	12450513          	addi	a0,a0,292 # 800461e8 <pr>
    800060cc:	00000097          	auipc	ra,0x0
    800060d0:	3e6080e7          	jalr	998(ra) # 800064b2 <release>
}
    800060d4:	bfc1                	j	800060a4 <printf+0x1d8>

00000000800060d6 <printfinit>:
    ;
}

void
printfinit(void)
{
    800060d6:	1101                	addi	sp,sp,-32
    800060d8:	ec06                	sd	ra,24(sp)
    800060da:	e822                	sd	s0,16(sp)
    800060dc:	e426                	sd	s1,8(sp)
    800060de:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    800060e0:	00040497          	auipc	s1,0x40
    800060e4:	10848493          	addi	s1,s1,264 # 800461e8 <pr>
    800060e8:	00002597          	auipc	a1,0x2
    800060ec:	5e858593          	addi	a1,a1,1512 # 800086d0 <etext+0x6d0>
    800060f0:	8526                	mv	a0,s1
    800060f2:	00000097          	auipc	ra,0x0
    800060f6:	27c080e7          	jalr	636(ra) # 8000636e <initlock>
  pr.locking = 1;
    800060fa:	4785                	li	a5,1
    800060fc:	cc9c                	sw	a5,24(s1)
}
    800060fe:	60e2                	ld	ra,24(sp)
    80006100:	6442                	ld	s0,16(sp)
    80006102:	64a2                	ld	s1,8(sp)
    80006104:	6105                	addi	sp,sp,32
    80006106:	8082                	ret

0000000080006108 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80006108:	1141                	addi	sp,sp,-16
    8000610a:	e406                	sd	ra,8(sp)
    8000610c:	e022                	sd	s0,0(sp)
    8000610e:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80006110:	100007b7          	lui	a5,0x10000
    80006114:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80006118:	10000737          	lui	a4,0x10000
    8000611c:	f8000693          	li	a3,-128
    80006120:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80006124:	468d                	li	a3,3
    80006126:	10000637          	lui	a2,0x10000
    8000612a:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    8000612e:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80006132:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80006136:	8732                	mv	a4,a2
    80006138:	461d                	li	a2,7
    8000613a:	00c70123          	sb	a2,2(a4)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    8000613e:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    80006142:	00002597          	auipc	a1,0x2
    80006146:	59658593          	addi	a1,a1,1430 # 800086d8 <etext+0x6d8>
    8000614a:	00040517          	auipc	a0,0x40
    8000614e:	0be50513          	addi	a0,a0,190 # 80046208 <uart_tx_lock>
    80006152:	00000097          	auipc	ra,0x0
    80006156:	21c080e7          	jalr	540(ra) # 8000636e <initlock>
}
    8000615a:	60a2                	ld	ra,8(sp)
    8000615c:	6402                	ld	s0,0(sp)
    8000615e:	0141                	addi	sp,sp,16
    80006160:	8082                	ret

0000000080006162 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80006162:	1101                	addi	sp,sp,-32
    80006164:	ec06                	sd	ra,24(sp)
    80006166:	e822                	sd	s0,16(sp)
    80006168:	e426                	sd	s1,8(sp)
    8000616a:	1000                	addi	s0,sp,32
    8000616c:	84aa                	mv	s1,a0
  push_off();
    8000616e:	00000097          	auipc	ra,0x0
    80006172:	248080e7          	jalr	584(ra) # 800063b6 <push_off>

  if(panicked){
    80006176:	00003797          	auipc	a5,0x3
    8000617a:	ea67a783          	lw	a5,-346(a5) # 8000901c <panicked>
    8000617e:	eb85                	bnez	a5,800061ae <uartputc_sync+0x4c>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006180:	10000737          	lui	a4,0x10000
    80006184:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80006186:	00074783          	lbu	a5,0(a4)
    8000618a:	0207f793          	andi	a5,a5,32
    8000618e:	dfe5                	beqz	a5,80006186 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80006190:	0ff4f513          	zext.b	a0,s1
    80006194:	100007b7          	lui	a5,0x10000
    80006198:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    8000619c:	00000097          	auipc	ra,0x0
    800061a0:	2ba080e7          	jalr	698(ra) # 80006456 <pop_off>
}
    800061a4:	60e2                	ld	ra,24(sp)
    800061a6:	6442                	ld	s0,16(sp)
    800061a8:	64a2                	ld	s1,8(sp)
    800061aa:	6105                	addi	sp,sp,32
    800061ac:	8082                	ret
    for(;;)
    800061ae:	a001                	j	800061ae <uartputc_sync+0x4c>

00000000800061b0 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    800061b0:	00003797          	auipc	a5,0x3
    800061b4:	e707b783          	ld	a5,-400(a5) # 80009020 <uart_tx_r>
    800061b8:	00003717          	auipc	a4,0x3
    800061bc:	e7073703          	ld	a4,-400(a4) # 80009028 <uart_tx_w>
    800061c0:	06f70f63          	beq	a4,a5,8000623e <uartstart+0x8e>
{
    800061c4:	7139                	addi	sp,sp,-64
    800061c6:	fc06                	sd	ra,56(sp)
    800061c8:	f822                	sd	s0,48(sp)
    800061ca:	f426                	sd	s1,40(sp)
    800061cc:	f04a                	sd	s2,32(sp)
    800061ce:	ec4e                	sd	s3,24(sp)
    800061d0:	e852                	sd	s4,16(sp)
    800061d2:	e456                	sd	s5,8(sp)
    800061d4:	e05a                	sd	s6,0(sp)
    800061d6:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800061d8:	10000937          	lui	s2,0x10000
    800061dc:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800061de:	00040a97          	auipc	s5,0x40
    800061e2:	02aa8a93          	addi	s5,s5,42 # 80046208 <uart_tx_lock>
    uart_tx_r += 1;
    800061e6:	00003497          	auipc	s1,0x3
    800061ea:	e3a48493          	addi	s1,s1,-454 # 80009020 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    800061ee:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    800061f2:	00003997          	auipc	s3,0x3
    800061f6:	e3698993          	addi	s3,s3,-458 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800061fa:	00094703          	lbu	a4,0(s2)
    800061fe:	02077713          	andi	a4,a4,32
    80006202:	c705                	beqz	a4,8000622a <uartstart+0x7a>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006204:	01f7f713          	andi	a4,a5,31
    80006208:	9756                	add	a4,a4,s5
    8000620a:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    8000620e:	0785                	addi	a5,a5,1
    80006210:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    80006212:	8526                	mv	a0,s1
    80006214:	ffffb097          	auipc	ra,0xffffb
    80006218:	61a080e7          	jalr	1562(ra) # 8000182e <wakeup>
    WriteReg(THR, c);
    8000621c:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    80006220:	609c                	ld	a5,0(s1)
    80006222:	0009b703          	ld	a4,0(s3)
    80006226:	fcf71ae3          	bne	a4,a5,800061fa <uartstart+0x4a>
  }
}
    8000622a:	70e2                	ld	ra,56(sp)
    8000622c:	7442                	ld	s0,48(sp)
    8000622e:	74a2                	ld	s1,40(sp)
    80006230:	7902                	ld	s2,32(sp)
    80006232:	69e2                	ld	s3,24(sp)
    80006234:	6a42                	ld	s4,16(sp)
    80006236:	6aa2                	ld	s5,8(sp)
    80006238:	6b02                	ld	s6,0(sp)
    8000623a:	6121                	addi	sp,sp,64
    8000623c:	8082                	ret
    8000623e:	8082                	ret

0000000080006240 <uartputc>:
{
    80006240:	7179                	addi	sp,sp,-48
    80006242:	f406                	sd	ra,40(sp)
    80006244:	f022                	sd	s0,32(sp)
    80006246:	e052                	sd	s4,0(sp)
    80006248:	1800                	addi	s0,sp,48
    8000624a:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    8000624c:	00040517          	auipc	a0,0x40
    80006250:	fbc50513          	addi	a0,a0,-68 # 80046208 <uart_tx_lock>
    80006254:	00000097          	auipc	ra,0x0
    80006258:	1ae080e7          	jalr	430(ra) # 80006402 <acquire>
  if(panicked){
    8000625c:	00003797          	auipc	a5,0x3
    80006260:	dc07a783          	lw	a5,-576(a5) # 8000901c <panicked>
    80006264:	c391                	beqz	a5,80006268 <uartputc+0x28>
    for(;;)
    80006266:	a001                	j	80006266 <uartputc+0x26>
    80006268:	ec26                	sd	s1,24(sp)
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000626a:	00003717          	auipc	a4,0x3
    8000626e:	dbe73703          	ld	a4,-578(a4) # 80009028 <uart_tx_w>
    80006272:	00003797          	auipc	a5,0x3
    80006276:	dae7b783          	ld	a5,-594(a5) # 80009020 <uart_tx_r>
    8000627a:	02078793          	addi	a5,a5,32
    8000627e:	02e79f63          	bne	a5,a4,800062bc <uartputc+0x7c>
    80006282:	e84a                	sd	s2,16(sp)
    80006284:	e44e                	sd	s3,8(sp)
      sleep(&uart_tx_r, &uart_tx_lock);
    80006286:	00040997          	auipc	s3,0x40
    8000628a:	f8298993          	addi	s3,s3,-126 # 80046208 <uart_tx_lock>
    8000628e:	00003497          	auipc	s1,0x3
    80006292:	d9248493          	addi	s1,s1,-622 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006296:	00003917          	auipc	s2,0x3
    8000629a:	d9290913          	addi	s2,s2,-622 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    8000629e:	85ce                	mv	a1,s3
    800062a0:	8526                	mv	a0,s1
    800062a2:	ffffb097          	auipc	ra,0xffffb
    800062a6:	406080e7          	jalr	1030(ra) # 800016a8 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800062aa:	00093703          	ld	a4,0(s2)
    800062ae:	609c                	ld	a5,0(s1)
    800062b0:	02078793          	addi	a5,a5,32
    800062b4:	fee785e3          	beq	a5,a4,8000629e <uartputc+0x5e>
    800062b8:	6942                	ld	s2,16(sp)
    800062ba:	69a2                	ld	s3,8(sp)
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800062bc:	00040497          	auipc	s1,0x40
    800062c0:	f4c48493          	addi	s1,s1,-180 # 80046208 <uart_tx_lock>
    800062c4:	01f77793          	andi	a5,a4,31
    800062c8:	97a6                	add	a5,a5,s1
    800062ca:	01478c23          	sb	s4,24(a5)
      uart_tx_w += 1;
    800062ce:	0705                	addi	a4,a4,1
    800062d0:	00003797          	auipc	a5,0x3
    800062d4:	d4e7bc23          	sd	a4,-680(a5) # 80009028 <uart_tx_w>
      uartstart();
    800062d8:	00000097          	auipc	ra,0x0
    800062dc:	ed8080e7          	jalr	-296(ra) # 800061b0 <uartstart>
      release(&uart_tx_lock);
    800062e0:	8526                	mv	a0,s1
    800062e2:	00000097          	auipc	ra,0x0
    800062e6:	1d0080e7          	jalr	464(ra) # 800064b2 <release>
    800062ea:	64e2                	ld	s1,24(sp)
}
    800062ec:	70a2                	ld	ra,40(sp)
    800062ee:	7402                	ld	s0,32(sp)
    800062f0:	6a02                	ld	s4,0(sp)
    800062f2:	6145                	addi	sp,sp,48
    800062f4:	8082                	ret

00000000800062f6 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800062f6:	1141                	addi	sp,sp,-16
    800062f8:	e406                	sd	ra,8(sp)
    800062fa:	e022                	sd	s0,0(sp)
    800062fc:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800062fe:	100007b7          	lui	a5,0x10000
    80006302:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80006306:	8b85                	andi	a5,a5,1
    80006308:	cb89                	beqz	a5,8000631a <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    8000630a:	100007b7          	lui	a5,0x10000
    8000630e:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80006312:	60a2                	ld	ra,8(sp)
    80006314:	6402                	ld	s0,0(sp)
    80006316:	0141                	addi	sp,sp,16
    80006318:	8082                	ret
    return -1;
    8000631a:	557d                	li	a0,-1
    8000631c:	bfdd                	j	80006312 <uartgetc+0x1c>

000000008000631e <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    8000631e:	1101                	addi	sp,sp,-32
    80006320:	ec06                	sd	ra,24(sp)
    80006322:	e822                	sd	s0,16(sp)
    80006324:	e426                	sd	s1,8(sp)
    80006326:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80006328:	54fd                	li	s1,-1
    int c = uartgetc();
    8000632a:	00000097          	auipc	ra,0x0
    8000632e:	fcc080e7          	jalr	-52(ra) # 800062f6 <uartgetc>
    if(c == -1)
    80006332:	00950763          	beq	a0,s1,80006340 <uartintr+0x22>
      break;
    consoleintr(c);
    80006336:	00000097          	auipc	ra,0x0
    8000633a:	8ce080e7          	jalr	-1842(ra) # 80005c04 <consoleintr>
  while(1){
    8000633e:	b7f5                	j	8000632a <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006340:	00040497          	auipc	s1,0x40
    80006344:	ec848493          	addi	s1,s1,-312 # 80046208 <uart_tx_lock>
    80006348:	8526                	mv	a0,s1
    8000634a:	00000097          	auipc	ra,0x0
    8000634e:	0b8080e7          	jalr	184(ra) # 80006402 <acquire>
  uartstart();
    80006352:	00000097          	auipc	ra,0x0
    80006356:	e5e080e7          	jalr	-418(ra) # 800061b0 <uartstart>
  release(&uart_tx_lock);
    8000635a:	8526                	mv	a0,s1
    8000635c:	00000097          	auipc	ra,0x0
    80006360:	156080e7          	jalr	342(ra) # 800064b2 <release>
}
    80006364:	60e2                	ld	ra,24(sp)
    80006366:	6442                	ld	s0,16(sp)
    80006368:	64a2                	ld	s1,8(sp)
    8000636a:	6105                	addi	sp,sp,32
    8000636c:	8082                	ret

000000008000636e <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    8000636e:	1141                	addi	sp,sp,-16
    80006370:	e406                	sd	ra,8(sp)
    80006372:	e022                	sd	s0,0(sp)
    80006374:	0800                	addi	s0,sp,16
  lk->name = name;
    80006376:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80006378:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    8000637c:	00053823          	sd	zero,16(a0)
}
    80006380:	60a2                	ld	ra,8(sp)
    80006382:	6402                	ld	s0,0(sp)
    80006384:	0141                	addi	sp,sp,16
    80006386:	8082                	ret

0000000080006388 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006388:	411c                	lw	a5,0(a0)
    8000638a:	e399                	bnez	a5,80006390 <holding+0x8>
    8000638c:	4501                	li	a0,0
  return r;
}
    8000638e:	8082                	ret
{
    80006390:	1101                	addi	sp,sp,-32
    80006392:	ec06                	sd	ra,24(sp)
    80006394:	e822                	sd	s0,16(sp)
    80006396:	e426                	sd	s1,8(sp)
    80006398:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    8000639a:	6904                	ld	s1,16(a0)
    8000639c:	ffffb097          	auipc	ra,0xffffb
    800063a0:	c26080e7          	jalr	-986(ra) # 80000fc2 <mycpu>
    800063a4:	40a48533          	sub	a0,s1,a0
    800063a8:	00153513          	seqz	a0,a0
}
    800063ac:	60e2                	ld	ra,24(sp)
    800063ae:	6442                	ld	s0,16(sp)
    800063b0:	64a2                	ld	s1,8(sp)
    800063b2:	6105                	addi	sp,sp,32
    800063b4:	8082                	ret

00000000800063b6 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800063b6:	1101                	addi	sp,sp,-32
    800063b8:	ec06                	sd	ra,24(sp)
    800063ba:	e822                	sd	s0,16(sp)
    800063bc:	e426                	sd	s1,8(sp)
    800063be:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800063c0:	100024f3          	csrr	s1,sstatus
    800063c4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800063c8:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800063ca:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800063ce:	ffffb097          	auipc	ra,0xffffb
    800063d2:	bf4080e7          	jalr	-1036(ra) # 80000fc2 <mycpu>
    800063d6:	5d3c                	lw	a5,120(a0)
    800063d8:	cf89                	beqz	a5,800063f2 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800063da:	ffffb097          	auipc	ra,0xffffb
    800063de:	be8080e7          	jalr	-1048(ra) # 80000fc2 <mycpu>
    800063e2:	5d3c                	lw	a5,120(a0)
    800063e4:	2785                	addiw	a5,a5,1
    800063e6:	dd3c                	sw	a5,120(a0)
}
    800063e8:	60e2                	ld	ra,24(sp)
    800063ea:	6442                	ld	s0,16(sp)
    800063ec:	64a2                	ld	s1,8(sp)
    800063ee:	6105                	addi	sp,sp,32
    800063f0:	8082                	ret
    mycpu()->intena = old;
    800063f2:	ffffb097          	auipc	ra,0xffffb
    800063f6:	bd0080e7          	jalr	-1072(ra) # 80000fc2 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800063fa:	8085                	srli	s1,s1,0x1
    800063fc:	8885                	andi	s1,s1,1
    800063fe:	dd64                	sw	s1,124(a0)
    80006400:	bfe9                	j	800063da <push_off+0x24>

0000000080006402 <acquire>:
{
    80006402:	1101                	addi	sp,sp,-32
    80006404:	ec06                	sd	ra,24(sp)
    80006406:	e822                	sd	s0,16(sp)
    80006408:	e426                	sd	s1,8(sp)
    8000640a:	1000                	addi	s0,sp,32
    8000640c:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    8000640e:	00000097          	auipc	ra,0x0
    80006412:	fa8080e7          	jalr	-88(ra) # 800063b6 <push_off>
  if(holding(lk))
    80006416:	8526                	mv	a0,s1
    80006418:	00000097          	auipc	ra,0x0
    8000641c:	f70080e7          	jalr	-144(ra) # 80006388 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006420:	4705                	li	a4,1
  if(holding(lk))
    80006422:	e115                	bnez	a0,80006446 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006424:	87ba                	mv	a5,a4
    80006426:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    8000642a:	2781                	sext.w	a5,a5
    8000642c:	ffe5                	bnez	a5,80006424 <acquire+0x22>
  __sync_synchronize();
    8000642e:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80006432:	ffffb097          	auipc	ra,0xffffb
    80006436:	b90080e7          	jalr	-1136(ra) # 80000fc2 <mycpu>
    8000643a:	e888                	sd	a0,16(s1)
}
    8000643c:	60e2                	ld	ra,24(sp)
    8000643e:	6442                	ld	s0,16(sp)
    80006440:	64a2                	ld	s1,8(sp)
    80006442:	6105                	addi	sp,sp,32
    80006444:	8082                	ret
    panic("acquire");
    80006446:	00002517          	auipc	a0,0x2
    8000644a:	29a50513          	addi	a0,a0,666 # 800086e0 <etext+0x6e0>
    8000644e:	00000097          	auipc	ra,0x0
    80006452:	a34080e7          	jalr	-1484(ra) # 80005e82 <panic>

0000000080006456 <pop_off>:

void
pop_off(void)
{
    80006456:	1141                	addi	sp,sp,-16
    80006458:	e406                	sd	ra,8(sp)
    8000645a:	e022                	sd	s0,0(sp)
    8000645c:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    8000645e:	ffffb097          	auipc	ra,0xffffb
    80006462:	b64080e7          	jalr	-1180(ra) # 80000fc2 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006466:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000646a:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000646c:	e39d                	bnez	a5,80006492 <pop_off+0x3c>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    8000646e:	5d3c                	lw	a5,120(a0)
    80006470:	02f05963          	blez	a5,800064a2 <pop_off+0x4c>
    panic("pop_off");
  c->noff -= 1;
    80006474:	37fd                	addiw	a5,a5,-1
    80006476:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006478:	eb89                	bnez	a5,8000648a <pop_off+0x34>
    8000647a:	5d7c                	lw	a5,124(a0)
    8000647c:	c799                	beqz	a5,8000648a <pop_off+0x34>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000647e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006482:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006486:	10079073          	csrw	sstatus,a5
    intr_on();
}
    8000648a:	60a2                	ld	ra,8(sp)
    8000648c:	6402                	ld	s0,0(sp)
    8000648e:	0141                	addi	sp,sp,16
    80006490:	8082                	ret
    panic("pop_off - interruptible");
    80006492:	00002517          	auipc	a0,0x2
    80006496:	25650513          	addi	a0,a0,598 # 800086e8 <etext+0x6e8>
    8000649a:	00000097          	auipc	ra,0x0
    8000649e:	9e8080e7          	jalr	-1560(ra) # 80005e82 <panic>
    panic("pop_off");
    800064a2:	00002517          	auipc	a0,0x2
    800064a6:	25e50513          	addi	a0,a0,606 # 80008700 <etext+0x700>
    800064aa:	00000097          	auipc	ra,0x0
    800064ae:	9d8080e7          	jalr	-1576(ra) # 80005e82 <panic>

00000000800064b2 <release>:
{
    800064b2:	1101                	addi	sp,sp,-32
    800064b4:	ec06                	sd	ra,24(sp)
    800064b6:	e822                	sd	s0,16(sp)
    800064b8:	e426                	sd	s1,8(sp)
    800064ba:	1000                	addi	s0,sp,32
    800064bc:	84aa                	mv	s1,a0
  if(!holding(lk))
    800064be:	00000097          	auipc	ra,0x0
    800064c2:	eca080e7          	jalr	-310(ra) # 80006388 <holding>
    800064c6:	c115                	beqz	a0,800064ea <release+0x38>
  lk->cpu = 0;
    800064c8:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800064cc:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    800064d0:	0310000f          	fence	rw,w
    800064d4:	0004a023          	sw	zero,0(s1)
  pop_off();
    800064d8:	00000097          	auipc	ra,0x0
    800064dc:	f7e080e7          	jalr	-130(ra) # 80006456 <pop_off>
}
    800064e0:	60e2                	ld	ra,24(sp)
    800064e2:	6442                	ld	s0,16(sp)
    800064e4:	64a2                	ld	s1,8(sp)
    800064e6:	6105                	addi	sp,sp,32
    800064e8:	8082                	ret
    panic("release");
    800064ea:	00002517          	auipc	a0,0x2
    800064ee:	21e50513          	addi	a0,a0,542 # 80008708 <etext+0x708>
    800064f2:	00000097          	auipc	ra,0x0
    800064f6:	990080e7          	jalr	-1648(ra) # 80005e82 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051573          	csrrw	a0,sscratch,a0
    80007004:	02153423          	sd	ra,40(a0)
    80007008:	02253823          	sd	sp,48(a0)
    8000700c:	02353c23          	sd	gp,56(a0)
    80007010:	04453023          	sd	tp,64(a0)
    80007014:	04553423          	sd	t0,72(a0)
    80007018:	04653823          	sd	t1,80(a0)
    8000701c:	04753c23          	sd	t2,88(a0)
    80007020:	f120                	sd	s0,96(a0)
    80007022:	f524                	sd	s1,104(a0)
    80007024:	fd2c                	sd	a1,120(a0)
    80007026:	e150                	sd	a2,128(a0)
    80007028:	e554                	sd	a3,136(a0)
    8000702a:	e958                	sd	a4,144(a0)
    8000702c:	ed5c                	sd	a5,152(a0)
    8000702e:	0b053023          	sd	a6,160(a0)
    80007032:	0b153423          	sd	a7,168(a0)
    80007036:	0b253823          	sd	s2,176(a0)
    8000703a:	0b353c23          	sd	s3,184(a0)
    8000703e:	0d453023          	sd	s4,192(a0)
    80007042:	0d553423          	sd	s5,200(a0)
    80007046:	0d653823          	sd	s6,208(a0)
    8000704a:	0d753c23          	sd	s7,216(a0)
    8000704e:	0f853023          	sd	s8,224(a0)
    80007052:	0f953423          	sd	s9,232(a0)
    80007056:	0fa53823          	sd	s10,240(a0)
    8000705a:	0fb53c23          	sd	s11,248(a0)
    8000705e:	11c53023          	sd	t3,256(a0)
    80007062:	11d53423          	sd	t4,264(a0)
    80007066:	11e53823          	sd	t5,272(a0)
    8000706a:	11f53c23          	sd	t6,280(a0)
    8000706e:	140022f3          	csrr	t0,sscratch
    80007072:	06553823          	sd	t0,112(a0)
    80007076:	00853103          	ld	sp,8(a0)
    8000707a:	02053203          	ld	tp,32(a0)
    8000707e:	01053283          	ld	t0,16(a0)
    80007082:	00053303          	ld	t1,0(a0)
    80007086:	18031073          	csrw	satp,t1
    8000708a:	12000073          	sfence.vma
    8000708e:	8282                	jr	t0

0000000080007090 <userret>:
    80007090:	18059073          	csrw	satp,a1
    80007094:	12000073          	sfence.vma
    80007098:	07053283          	ld	t0,112(a0)
    8000709c:	14029073          	csrw	sscratch,t0
    800070a0:	02853083          	ld	ra,40(a0)
    800070a4:	03053103          	ld	sp,48(a0)
    800070a8:	03853183          	ld	gp,56(a0)
    800070ac:	04053203          	ld	tp,64(a0)
    800070b0:	04853283          	ld	t0,72(a0)
    800070b4:	05053303          	ld	t1,80(a0)
    800070b8:	05853383          	ld	t2,88(a0)
    800070bc:	7120                	ld	s0,96(a0)
    800070be:	7524                	ld	s1,104(a0)
    800070c0:	7d2c                	ld	a1,120(a0)
    800070c2:	6150                	ld	a2,128(a0)
    800070c4:	6554                	ld	a3,136(a0)
    800070c6:	6958                	ld	a4,144(a0)
    800070c8:	6d5c                	ld	a5,152(a0)
    800070ca:	0a053803          	ld	a6,160(a0)
    800070ce:	0a853883          	ld	a7,168(a0)
    800070d2:	0b053903          	ld	s2,176(a0)
    800070d6:	0b853983          	ld	s3,184(a0)
    800070da:	0c053a03          	ld	s4,192(a0)
    800070de:	0c853a83          	ld	s5,200(a0)
    800070e2:	0d053b03          	ld	s6,208(a0)
    800070e6:	0d853b83          	ld	s7,216(a0)
    800070ea:	0e053c03          	ld	s8,224(a0)
    800070ee:	0e853c83          	ld	s9,232(a0)
    800070f2:	0f053d03          	ld	s10,240(a0)
    800070f6:	0f853d83          	ld	s11,248(a0)
    800070fa:	10053e03          	ld	t3,256(a0)
    800070fe:	10853e83          	ld	t4,264(a0)
    80007102:	11053f03          	ld	t5,272(a0)
    80007106:	11853f83          	ld	t6,280(a0)
    8000710a:	14051573          	csrrw	a0,sscratch,a0
    8000710e:	10200073          	sret
	...
