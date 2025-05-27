
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0023e117          	auipc	sp,0x23e
    80000004:	14010113          	addi	sp,sp,320 # 8023e140 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	251050ef          	jal	80005a66 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	7179                	addi	sp,sp,-48
    8000001e:	f406                	sd	ra,40(sp)
    80000020:	f022                	sd	s0,32(sp)
    80000022:	ec26                	sd	s1,24(sp)
    80000024:	e84a                	sd	s2,16(sp)
    80000026:	e44e                	sd	s3,8(sp)
    80000028:	1800                	addi	s0,sp,48
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    8000002a:	03451793          	slli	a5,a0,0x34
    8000002e:	e7ad                	bnez	a5,80000098 <kfree+0x7c>
    80000030:	84aa                	mv	s1,a0
    80000032:	00246797          	auipc	a5,0x246
    80000036:	20e78793          	addi	a5,a5,526 # 80246240 <end>
    8000003a:	04f56f63          	bltu	a0,a5,80000098 <kfree+0x7c>
    8000003e:	47c5                	li	a5,17
    80000040:	07ee                	slli	a5,a5,0x1b
    80000042:	04f57b63          	bgeu	a0,a5,80000098 <kfree+0x7c>
    panic("kfree");

  acquire(&refcnt_lock);
    80000046:	00009917          	auipc	s2,0x9
    8000004a:	fea90913          	addi	s2,s2,-22 # 80009030 <refcnt_lock>
    8000004e:	854a                	mv	a0,s2
    80000050:	00006097          	auipc	ra,0x6
    80000054:	462080e7          	jalr	1122(ra) # 800064b2 <acquire>
  int index = ((uint64)pa - (uint64)end) / PGSIZE;
    80000058:	00246797          	auipc	a5,0x246
    8000005c:	1e878793          	addi	a5,a5,488 # 80246240 <end>
    80000060:	40f487b3          	sub	a5,s1,a5
    80000064:	83b1                	srli	a5,a5,0xc
    80000066:	2781                	sext.w	a5,a5
  refcnt[index]--;
    80000068:	078a                	slli	a5,a5,0x2
    8000006a:	00009717          	auipc	a4,0x9
    8000006e:	ffe70713          	addi	a4,a4,-2 # 80009068 <refcnt>
    80000072:	97ba                	add	a5,a5,a4
    80000074:	4398                	lw	a4,0(a5)
    80000076:	377d                	addiw	a4,a4,-1
    80000078:	89ba                	mv	s3,a4
    8000007a:	c398                	sw	a4,0(a5)
  int ref = refcnt[index];
  release(&refcnt_lock);
    8000007c:	854a                	mv	a0,s2
    8000007e:	00006097          	auipc	ra,0x6
    80000082:	4e4080e7          	jalr	1252(ra) # 80006562 <release>
  if(ref > 0)
    80000086:	03305163          	blez	s3,800000a8 <kfree+0x8c>

  acquire(&kmem.lock);
  r->next = kmem.freelist;
  kmem.freelist = r;
  release(&kmem.lock);
}
    8000008a:	70a2                	ld	ra,40(sp)
    8000008c:	7402                	ld	s0,32(sp)
    8000008e:	64e2                	ld	s1,24(sp)
    80000090:	6942                	ld	s2,16(sp)
    80000092:	69a2                	ld	s3,8(sp)
    80000094:	6145                	addi	sp,sp,48
    80000096:	8082                	ret
    panic("kfree");
    80000098:	00008517          	auipc	a0,0x8
    8000009c:	f6850513          	addi	a0,a0,-152 # 80008000 <etext>
    800000a0:	00006097          	auipc	ra,0x6
    800000a4:	e92080e7          	jalr	-366(ra) # 80005f32 <panic>
  memset(pa, 1, PGSIZE);
    800000a8:	6605                	lui	a2,0x1
    800000aa:	4585                	li	a1,1
    800000ac:	8526                	mv	a0,s1
    800000ae:	00000097          	auipc	ra,0x0
    800000b2:	192080e7          	jalr	402(ra) # 80000240 <memset>
  acquire(&kmem.lock);
    800000b6:	89ca                	mv	s3,s2
    800000b8:	00009917          	auipc	s2,0x9
    800000bc:	f9090913          	addi	s2,s2,-112 # 80009048 <kmem>
    800000c0:	854a                	mv	a0,s2
    800000c2:	00006097          	auipc	ra,0x6
    800000c6:	3f0080e7          	jalr	1008(ra) # 800064b2 <acquire>
  r->next = kmem.freelist;
    800000ca:	0309b783          	ld	a5,48(s3)
    800000ce:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    800000d0:	0299b823          	sd	s1,48(s3)
  release(&kmem.lock);
    800000d4:	854a                	mv	a0,s2
    800000d6:	00006097          	auipc	ra,0x6
    800000da:	48c080e7          	jalr	1164(ra) # 80006562 <release>
    800000de:	b775                	j	8000008a <kfree+0x6e>

00000000800000e0 <freerange>:
{
    800000e0:	7179                	addi	sp,sp,-48
    800000e2:	f406                	sd	ra,40(sp)
    800000e4:	f022                	sd	s0,32(sp)
    800000e6:	ec26                	sd	s1,24(sp)
    800000e8:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000ea:	6785                	lui	a5,0x1
    800000ec:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    800000f0:	00e504b3          	add	s1,a0,a4
    800000f4:	777d                	lui	a4,0xfffff
    800000f6:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000f8:	94be                	add	s1,s1,a5
    800000fa:	0295e463          	bltu	a1,s1,80000122 <freerange+0x42>
    800000fe:	e84a                	sd	s2,16(sp)
    80000100:	e44e                	sd	s3,8(sp)
    80000102:	e052                	sd	s4,0(sp)
    80000104:	892e                	mv	s2,a1
    kfree(p);
    80000106:	8a3a                	mv	s4,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000108:	89be                	mv	s3,a5
    kfree(p);
    8000010a:	01448533          	add	a0,s1,s4
    8000010e:	00000097          	auipc	ra,0x0
    80000112:	f0e080e7          	jalr	-242(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000116:	94ce                	add	s1,s1,s3
    80000118:	fe9979e3          	bgeu	s2,s1,8000010a <freerange+0x2a>
    8000011c:	6942                	ld	s2,16(sp)
    8000011e:	69a2                	ld	s3,8(sp)
    80000120:	6a02                	ld	s4,0(sp)
}
    80000122:	70a2                	ld	ra,40(sp)
    80000124:	7402                	ld	s0,32(sp)
    80000126:	64e2                	ld	s1,24(sp)
    80000128:	6145                	addi	sp,sp,48
    8000012a:	8082                	ret

000000008000012c <kinit>:
{
    8000012c:	1141                	addi	sp,sp,-16
    8000012e:	e406                	sd	ra,8(sp)
    80000130:	e022                	sd	s0,0(sp)
    80000132:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000134:	00008597          	auipc	a1,0x8
    80000138:	edc58593          	addi	a1,a1,-292 # 80008010 <etext+0x10>
    8000013c:	00009517          	auipc	a0,0x9
    80000140:	f0c50513          	addi	a0,a0,-244 # 80009048 <kmem>
    80000144:	00006097          	auipc	ra,0x6
    80000148:	2da080e7          	jalr	730(ra) # 8000641e <initlock>
  freerange(end, (void*)PHYSTOP);
    8000014c:	45c5                	li	a1,17
    8000014e:	05ee                	slli	a1,a1,0x1b
    80000150:	00246517          	auipc	a0,0x246
    80000154:	0f050513          	addi	a0,a0,240 # 80246240 <end>
    80000158:	00000097          	auipc	ra,0x0
    8000015c:	f88080e7          	jalr	-120(ra) # 800000e0 <freerange>
  initlock(&refcnt_lock, "refcnt");
    80000160:	00008597          	auipc	a1,0x8
    80000164:	eb858593          	addi	a1,a1,-328 # 80008018 <etext+0x18>
    80000168:	00009517          	auipc	a0,0x9
    8000016c:	ec850513          	addi	a0,a0,-312 # 80009030 <refcnt_lock>
    80000170:	00006097          	auipc	ra,0x6
    80000174:	2ae080e7          	jalr	686(ra) # 8000641e <initlock>
  for(int i = 0; i < PHYPAGES; i++) {
    80000178:	00009797          	auipc	a5,0x9
    8000017c:	ef078793          	addi	a5,a5,-272 # 80009068 <refcnt>
    80000180:	00229717          	auipc	a4,0x229
    80000184:	ee870713          	addi	a4,a4,-280 # 80229068 <pid_lock>
    refcnt[i] = 0;
    80000188:	0007a023          	sw	zero,0(a5)
  for(int i = 0; i < PHYPAGES; i++) {
    8000018c:	0791                	addi	a5,a5,4
    8000018e:	fee79de3          	bne	a5,a4,80000188 <kinit+0x5c>
}
    80000192:	60a2                	ld	ra,8(sp)
    80000194:	6402                	ld	s0,0(sp)
    80000196:	0141                	addi	sp,sp,16
    80000198:	8082                	ret

000000008000019a <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    8000019a:	1101                	addi	sp,sp,-32
    8000019c:	ec06                	sd	ra,24(sp)
    8000019e:	e822                	sd	s0,16(sp)
    800001a0:	e426                	sd	s1,8(sp)
    800001a2:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    800001a4:	00009517          	auipc	a0,0x9
    800001a8:	ea450513          	addi	a0,a0,-348 # 80009048 <kmem>
    800001ac:	00006097          	auipc	ra,0x6
    800001b0:	306080e7          	jalr	774(ra) # 800064b2 <acquire>
  r = kmem.freelist;
    800001b4:	00009497          	auipc	s1,0x9
    800001b8:	eac4b483          	ld	s1,-340(s1) # 80009060 <kmem+0x18>
  if(r)
    800001bc:	c8ad                	beqz	s1,8000022e <kalloc+0x94>
    800001be:	e04a                	sd	s2,0(sp)
    kmem.freelist = r->next;
    800001c0:	609c                	ld	a5,0(s1)
    800001c2:	00009917          	auipc	s2,0x9
    800001c6:	e6e90913          	addi	s2,s2,-402 # 80009030 <refcnt_lock>
    800001ca:	02f93823          	sd	a5,48(s2)
  release(&kmem.lock);
    800001ce:	00009517          	auipc	a0,0x9
    800001d2:	e7a50513          	addi	a0,a0,-390 # 80009048 <kmem>
    800001d6:	00006097          	auipc	ra,0x6
    800001da:	38c080e7          	jalr	908(ra) # 80006562 <release>

  if(r) {
    memset((char*)r, 5, PGSIZE); // fill with junk
    800001de:	6605                	lui	a2,0x1
    800001e0:	4595                	li	a1,5
    800001e2:	8526                	mv	a0,s1
    800001e4:	00000097          	auipc	ra,0x0
    800001e8:	05c080e7          	jalr	92(ra) # 80000240 <memset>
    acquire(&refcnt_lock);
    800001ec:	854a                	mv	a0,s2
    800001ee:	00006097          	auipc	ra,0x6
    800001f2:	2c4080e7          	jalr	708(ra) # 800064b2 <acquire>
    int index = ((uint64)r - (uint64)end) / PGSIZE;
    800001f6:	00246797          	auipc	a5,0x246
    800001fa:	04a78793          	addi	a5,a5,74 # 80246240 <end>
    800001fe:	40f487b3          	sub	a5,s1,a5
    80000202:	83b1                	srli	a5,a5,0xc
    refcnt[index] = 1;
    80000204:	2781                	sext.w	a5,a5
    80000206:	078a                	slli	a5,a5,0x2
    80000208:	00009717          	auipc	a4,0x9
    8000020c:	e6070713          	addi	a4,a4,-416 # 80009068 <refcnt>
    80000210:	97ba                	add	a5,a5,a4
    80000212:	4705                	li	a4,1
    80000214:	c398                	sw	a4,0(a5)
    release(&refcnt_lock);
    80000216:	854a                	mv	a0,s2
    80000218:	00006097          	auipc	ra,0x6
    8000021c:	34a080e7          	jalr	842(ra) # 80006562 <release>
  }
    
  return (void*)r;
    80000220:	6902                	ld	s2,0(sp)
}
    80000222:	8526                	mv	a0,s1
    80000224:	60e2                	ld	ra,24(sp)
    80000226:	6442                	ld	s0,16(sp)
    80000228:	64a2                	ld	s1,8(sp)
    8000022a:	6105                	addi	sp,sp,32
    8000022c:	8082                	ret
  release(&kmem.lock);
    8000022e:	00009517          	auipc	a0,0x9
    80000232:	e1a50513          	addi	a0,a0,-486 # 80009048 <kmem>
    80000236:	00006097          	auipc	ra,0x6
    8000023a:	32c080e7          	jalr	812(ra) # 80006562 <release>
  if(r) {
    8000023e:	b7d5                	j	80000222 <kalloc+0x88>

0000000080000240 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000240:	1141                	addi	sp,sp,-16
    80000242:	e406                	sd	ra,8(sp)
    80000244:	e022                	sd	s0,0(sp)
    80000246:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000248:	ca19                	beqz	a2,8000025e <memset+0x1e>
    8000024a:	87aa                	mv	a5,a0
    8000024c:	1602                	slli	a2,a2,0x20
    8000024e:	9201                	srli	a2,a2,0x20
    80000250:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000254:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000258:	0785                	addi	a5,a5,1
    8000025a:	fee79de3          	bne	a5,a4,80000254 <memset+0x14>
  }
  return dst;
}
    8000025e:	60a2                	ld	ra,8(sp)
    80000260:	6402                	ld	s0,0(sp)
    80000262:	0141                	addi	sp,sp,16
    80000264:	8082                	ret

0000000080000266 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000266:	1141                	addi	sp,sp,-16
    80000268:	e406                	sd	ra,8(sp)
    8000026a:	e022                	sd	s0,0(sp)
    8000026c:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    8000026e:	ca0d                	beqz	a2,800002a0 <memcmp+0x3a>
    80000270:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    80000274:	1682                	slli	a3,a3,0x20
    80000276:	9281                	srli	a3,a3,0x20
    80000278:	0685                	addi	a3,a3,1
    8000027a:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    8000027c:	00054783          	lbu	a5,0(a0)
    80000280:	0005c703          	lbu	a4,0(a1)
    80000284:	00e79863          	bne	a5,a4,80000294 <memcmp+0x2e>
      return *s1 - *s2;
    s1++, s2++;
    80000288:	0505                	addi	a0,a0,1
    8000028a:	0585                	addi	a1,a1,1
  while(n-- > 0){
    8000028c:	fed518e3          	bne	a0,a3,8000027c <memcmp+0x16>
  }

  return 0;
    80000290:	4501                	li	a0,0
    80000292:	a019                	j	80000298 <memcmp+0x32>
      return *s1 - *s2;
    80000294:	40e7853b          	subw	a0,a5,a4
}
    80000298:	60a2                	ld	ra,8(sp)
    8000029a:	6402                	ld	s0,0(sp)
    8000029c:	0141                	addi	sp,sp,16
    8000029e:	8082                	ret
  return 0;
    800002a0:	4501                	li	a0,0
    800002a2:	bfdd                	j	80000298 <memcmp+0x32>

00000000800002a4 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800002a4:	1141                	addi	sp,sp,-16
    800002a6:	e406                	sd	ra,8(sp)
    800002a8:	e022                	sd	s0,0(sp)
    800002aa:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800002ac:	c205                	beqz	a2,800002cc <memmove+0x28>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800002ae:	02a5e363          	bltu	a1,a0,800002d4 <memmove+0x30>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800002b2:	1602                	slli	a2,a2,0x20
    800002b4:	9201                	srli	a2,a2,0x20
    800002b6:	00c587b3          	add	a5,a1,a2
{
    800002ba:	872a                	mv	a4,a0
      *d++ = *s++;
    800002bc:	0585                	addi	a1,a1,1
    800002be:	0705                	addi	a4,a4,1
    800002c0:	fff5c683          	lbu	a3,-1(a1)
    800002c4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800002c8:	feb79ae3          	bne	a5,a1,800002bc <memmove+0x18>

  return dst;
}
    800002cc:	60a2                	ld	ra,8(sp)
    800002ce:	6402                	ld	s0,0(sp)
    800002d0:	0141                	addi	sp,sp,16
    800002d2:	8082                	ret
  if(s < d && s + n > d){
    800002d4:	02061693          	slli	a3,a2,0x20
    800002d8:	9281                	srli	a3,a3,0x20
    800002da:	00d58733          	add	a4,a1,a3
    800002de:	fce57ae3          	bgeu	a0,a4,800002b2 <memmove+0xe>
    d += n;
    800002e2:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    800002e4:	fff6079b          	addiw	a5,a2,-1
    800002e8:	1782                	slli	a5,a5,0x20
    800002ea:	9381                	srli	a5,a5,0x20
    800002ec:	fff7c793          	not	a5,a5
    800002f0:	97ba                	add	a5,a5,a4
      *--d = *--s;
    800002f2:	177d                	addi	a4,a4,-1
    800002f4:	16fd                	addi	a3,a3,-1
    800002f6:	00074603          	lbu	a2,0(a4)
    800002fa:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    800002fe:	fee79ae3          	bne	a5,a4,800002f2 <memmove+0x4e>
    80000302:	b7e9                	j	800002cc <memmove+0x28>

0000000080000304 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000304:	1141                	addi	sp,sp,-16
    80000306:	e406                	sd	ra,8(sp)
    80000308:	e022                	sd	s0,0(sp)
    8000030a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    8000030c:	00000097          	auipc	ra,0x0
    80000310:	f98080e7          	jalr	-104(ra) # 800002a4 <memmove>
}
    80000314:	60a2                	ld	ra,8(sp)
    80000316:	6402                	ld	s0,0(sp)
    80000318:	0141                	addi	sp,sp,16
    8000031a:	8082                	ret

000000008000031c <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    8000031c:	1141                	addi	sp,sp,-16
    8000031e:	e406                	sd	ra,8(sp)
    80000320:	e022                	sd	s0,0(sp)
    80000322:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000324:	ce11                	beqz	a2,80000340 <strncmp+0x24>
    80000326:	00054783          	lbu	a5,0(a0)
    8000032a:	cf89                	beqz	a5,80000344 <strncmp+0x28>
    8000032c:	0005c703          	lbu	a4,0(a1)
    80000330:	00f71a63          	bne	a4,a5,80000344 <strncmp+0x28>
    n--, p++, q++;
    80000334:	367d                	addiw	a2,a2,-1
    80000336:	0505                	addi	a0,a0,1
    80000338:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    8000033a:	f675                	bnez	a2,80000326 <strncmp+0xa>
  if(n == 0)
    return 0;
    8000033c:	4501                	li	a0,0
    8000033e:	a801                	j	8000034e <strncmp+0x32>
    80000340:	4501                	li	a0,0
    80000342:	a031                	j	8000034e <strncmp+0x32>
  return (uchar)*p - (uchar)*q;
    80000344:	00054503          	lbu	a0,0(a0)
    80000348:	0005c783          	lbu	a5,0(a1)
    8000034c:	9d1d                	subw	a0,a0,a5
}
    8000034e:	60a2                	ld	ra,8(sp)
    80000350:	6402                	ld	s0,0(sp)
    80000352:	0141                	addi	sp,sp,16
    80000354:	8082                	ret

0000000080000356 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000356:	1141                	addi	sp,sp,-16
    80000358:	e406                	sd	ra,8(sp)
    8000035a:	e022                	sd	s0,0(sp)
    8000035c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    8000035e:	87aa                	mv	a5,a0
    80000360:	86b2                	mv	a3,a2
    80000362:	367d                	addiw	a2,a2,-1
    80000364:	02d05563          	blez	a3,8000038e <strncpy+0x38>
    80000368:	0785                	addi	a5,a5,1
    8000036a:	0005c703          	lbu	a4,0(a1)
    8000036e:	fee78fa3          	sb	a4,-1(a5)
    80000372:	0585                	addi	a1,a1,1
    80000374:	f775                	bnez	a4,80000360 <strncpy+0xa>
    ;
  while(n-- > 0)
    80000376:	873e                	mv	a4,a5
    80000378:	00c05b63          	blez	a2,8000038e <strncpy+0x38>
    8000037c:	9fb5                	addw	a5,a5,a3
    8000037e:	37fd                	addiw	a5,a5,-1
    *s++ = 0;
    80000380:	0705                	addi	a4,a4,1
    80000382:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    80000386:	40e786bb          	subw	a3,a5,a4
    8000038a:	fed04be3          	bgtz	a3,80000380 <strncpy+0x2a>
  return os;
}
    8000038e:	60a2                	ld	ra,8(sp)
    80000390:	6402                	ld	s0,0(sp)
    80000392:	0141                	addi	sp,sp,16
    80000394:	8082                	ret

0000000080000396 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000396:	1141                	addi	sp,sp,-16
    80000398:	e406                	sd	ra,8(sp)
    8000039a:	e022                	sd	s0,0(sp)
    8000039c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    8000039e:	02c05363          	blez	a2,800003c4 <safestrcpy+0x2e>
    800003a2:	fff6069b          	addiw	a3,a2,-1
    800003a6:	1682                	slli	a3,a3,0x20
    800003a8:	9281                	srli	a3,a3,0x20
    800003aa:	96ae                	add	a3,a3,a1
    800003ac:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800003ae:	00d58963          	beq	a1,a3,800003c0 <safestrcpy+0x2a>
    800003b2:	0585                	addi	a1,a1,1
    800003b4:	0785                	addi	a5,a5,1
    800003b6:	fff5c703          	lbu	a4,-1(a1)
    800003ba:	fee78fa3          	sb	a4,-1(a5)
    800003be:	fb65                	bnez	a4,800003ae <safestrcpy+0x18>
    ;
  *s = 0;
    800003c0:	00078023          	sb	zero,0(a5)
  return os;
}
    800003c4:	60a2                	ld	ra,8(sp)
    800003c6:	6402                	ld	s0,0(sp)
    800003c8:	0141                	addi	sp,sp,16
    800003ca:	8082                	ret

00000000800003cc <strlen>:

int
strlen(const char *s)
{
    800003cc:	1141                	addi	sp,sp,-16
    800003ce:	e406                	sd	ra,8(sp)
    800003d0:	e022                	sd	s0,0(sp)
    800003d2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800003d4:	00054783          	lbu	a5,0(a0)
    800003d8:	cf99                	beqz	a5,800003f6 <strlen+0x2a>
    800003da:	0505                	addi	a0,a0,1
    800003dc:	87aa                	mv	a5,a0
    800003de:	86be                	mv	a3,a5
    800003e0:	0785                	addi	a5,a5,1
    800003e2:	fff7c703          	lbu	a4,-1(a5)
    800003e6:	ff65                	bnez	a4,800003de <strlen+0x12>
    800003e8:	40a6853b          	subw	a0,a3,a0
    800003ec:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    800003ee:	60a2                	ld	ra,8(sp)
    800003f0:	6402                	ld	s0,0(sp)
    800003f2:	0141                	addi	sp,sp,16
    800003f4:	8082                	ret
  for(n = 0; s[n]; n++)
    800003f6:	4501                	li	a0,0
    800003f8:	bfdd                	j	800003ee <strlen+0x22>

00000000800003fa <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    800003fa:	1141                	addi	sp,sp,-16
    800003fc:	e406                	sd	ra,8(sp)
    800003fe:	e022                	sd	s0,0(sp)
    80000400:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000402:	00001097          	auipc	ra,0x1
    80000406:	c34080e7          	jalr	-972(ra) # 80001036 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    8000040a:	00009717          	auipc	a4,0x9
    8000040e:	bf670713          	addi	a4,a4,-1034 # 80009000 <started>
  if(cpuid() == 0){
    80000412:	c139                	beqz	a0,80000458 <main+0x5e>
    while(started == 0)
    80000414:	431c                	lw	a5,0(a4)
    80000416:	2781                	sext.w	a5,a5
    80000418:	dff5                	beqz	a5,80000414 <main+0x1a>
      ;
    __sync_synchronize();
    8000041a:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    8000041e:	00001097          	auipc	ra,0x1
    80000422:	c18080e7          	jalr	-1000(ra) # 80001036 <cpuid>
    80000426:	85aa                	mv	a1,a0
    80000428:	00008517          	auipc	a0,0x8
    8000042c:	c1850513          	addi	a0,a0,-1000 # 80008040 <etext+0x40>
    80000430:	00006097          	auipc	ra,0x6
    80000434:	b4c080e7          	jalr	-1204(ra) # 80005f7c <printf>
    kvminithart();    // turn on paging
    80000438:	00000097          	auipc	ra,0x0
    8000043c:	0d8080e7          	jalr	216(ra) # 80000510 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000440:	00002097          	auipc	ra,0x2
    80000444:	87c080e7          	jalr	-1924(ra) # 80001cbc <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000448:	00005097          	auipc	ra,0x5
    8000044c:	fec080e7          	jalr	-20(ra) # 80005434 <plicinithart>
  }

  scheduler();        
    80000450:	00001097          	auipc	ra,0x1
    80000454:	12e080e7          	jalr	302(ra) # 8000157e <scheduler>
    consoleinit();
    80000458:	00006097          	auipc	ra,0x6
    8000045c:	9fc080e7          	jalr	-1540(ra) # 80005e54 <consoleinit>
    printfinit();
    80000460:	00006097          	auipc	ra,0x6
    80000464:	d26080e7          	jalr	-730(ra) # 80006186 <printfinit>
    printf("\n");
    80000468:	00008517          	auipc	a0,0x8
    8000046c:	bb850513          	addi	a0,a0,-1096 # 80008020 <etext+0x20>
    80000470:	00006097          	auipc	ra,0x6
    80000474:	b0c080e7          	jalr	-1268(ra) # 80005f7c <printf>
    printf("xv6 kernel is booting\n");
    80000478:	00008517          	auipc	a0,0x8
    8000047c:	bb050513          	addi	a0,a0,-1104 # 80008028 <etext+0x28>
    80000480:	00006097          	auipc	ra,0x6
    80000484:	afc080e7          	jalr	-1284(ra) # 80005f7c <printf>
    printf("\n");
    80000488:	00008517          	auipc	a0,0x8
    8000048c:	b9850513          	addi	a0,a0,-1128 # 80008020 <etext+0x20>
    80000490:	00006097          	auipc	ra,0x6
    80000494:	aec080e7          	jalr	-1300(ra) # 80005f7c <printf>
    kinit();         // physical page allocator
    80000498:	00000097          	auipc	ra,0x0
    8000049c:	c94080e7          	jalr	-876(ra) # 8000012c <kinit>
    kvminit();       // create kernel page table
    800004a0:	00000097          	auipc	ra,0x0
    800004a4:	326080e7          	jalr	806(ra) # 800007c6 <kvminit>
    kvminithart();   // turn on paging
    800004a8:	00000097          	auipc	ra,0x0
    800004ac:	068080e7          	jalr	104(ra) # 80000510 <kvminithart>
    procinit();      // process table
    800004b0:	00001097          	auipc	ra,0x1
    800004b4:	ace080e7          	jalr	-1330(ra) # 80000f7e <procinit>
    trapinit();      // trap vectors
    800004b8:	00001097          	auipc	ra,0x1
    800004bc:	7dc080e7          	jalr	2012(ra) # 80001c94 <trapinit>
    trapinithart();  // install kernel trap vector
    800004c0:	00001097          	auipc	ra,0x1
    800004c4:	7fc080e7          	jalr	2044(ra) # 80001cbc <trapinithart>
    plicinit();      // set up interrupt controller
    800004c8:	00005097          	auipc	ra,0x5
    800004cc:	f52080e7          	jalr	-174(ra) # 8000541a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800004d0:	00005097          	auipc	ra,0x5
    800004d4:	f64080e7          	jalr	-156(ra) # 80005434 <plicinithart>
    binit();         // buffer cache
    800004d8:	00002097          	auipc	ra,0x2
    800004dc:	03a080e7          	jalr	58(ra) # 80002512 <binit>
    iinit();         // inode table
    800004e0:	00002097          	auipc	ra,0x2
    800004e4:	6a8080e7          	jalr	1704(ra) # 80002b88 <iinit>
    fileinit();      // file table
    800004e8:	00003097          	auipc	ra,0x3
    800004ec:	672080e7          	jalr	1650(ra) # 80003b5a <fileinit>
    virtio_disk_init(); // emulated hard disk
    800004f0:	00005097          	auipc	ra,0x5
    800004f4:	064080e7          	jalr	100(ra) # 80005554 <virtio_disk_init>
    userinit();      // first user process
    800004f8:	00001097          	auipc	ra,0x1
    800004fc:	e4a080e7          	jalr	-438(ra) # 80001342 <userinit>
    __sync_synchronize();
    80000500:	0330000f          	fence	rw,rw
    started = 1;
    80000504:	4785                	li	a5,1
    80000506:	00009717          	auipc	a4,0x9
    8000050a:	aef72d23          	sw	a5,-1286(a4) # 80009000 <started>
    8000050e:	b789                	j	80000450 <main+0x56>

0000000080000510 <kvminithart>:
}

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void kvminithart()
{
    80000510:	1141                	addi	sp,sp,-16
    80000512:	e406                	sd	ra,8(sp)
    80000514:	e022                	sd	s0,0(sp)
    80000516:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    80000518:	00009797          	auipc	a5,0x9
    8000051c:	af07b783          	ld	a5,-1296(a5) # 80009008 <kernel_pagetable>
    80000520:	83b1                	srli	a5,a5,0xc
    80000522:	577d                	li	a4,-1
    80000524:	177e                	slli	a4,a4,0x3f
    80000526:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    80000528:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    8000052c:	12000073          	sfence.vma
  sfence_vma();
}
    80000530:	60a2                	ld	ra,8(sp)
    80000532:	6402                	ld	s0,0(sp)
    80000534:	0141                	addi	sp,sp,16
    80000536:	8082                	ret

0000000080000538 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000538:	7139                	addi	sp,sp,-64
    8000053a:	fc06                	sd	ra,56(sp)
    8000053c:	f822                	sd	s0,48(sp)
    8000053e:	f426                	sd	s1,40(sp)
    80000540:	f04a                	sd	s2,32(sp)
    80000542:	ec4e                	sd	s3,24(sp)
    80000544:	e852                	sd	s4,16(sp)
    80000546:	e456                	sd	s5,8(sp)
    80000548:	e05a                	sd	s6,0(sp)
    8000054a:	0080                	addi	s0,sp,64
    8000054c:	84aa                	mv	s1,a0
    8000054e:	89ae                	mv	s3,a1
    80000550:	8ab2                	mv	s5,a2
  if (va >= MAXVA)
    80000552:	57fd                	li	a5,-1
    80000554:	83e9                	srli	a5,a5,0x1a
    80000556:	4a79                	li	s4,30
    panic("walk");

  for (int level = 2; level > 0; level--)
    80000558:	4b31                	li	s6,12
  if (va >= MAXVA)
    8000055a:	04b7e263          	bltu	a5,a1,8000059e <walk+0x66>
  {
    pte_t *pte = &pagetable[PX(level, va)];
    8000055e:	0149d933          	srl	s2,s3,s4
    80000562:	1ff97913          	andi	s2,s2,511
    80000566:	090e                	slli	s2,s2,0x3
    80000568:	9926                	add	s2,s2,s1
    if (*pte & PTE_V)
    8000056a:	00093483          	ld	s1,0(s2)
    8000056e:	0014f793          	andi	a5,s1,1
    80000572:	cf95                	beqz	a5,800005ae <walk+0x76>
    {
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000574:	80a9                	srli	s1,s1,0xa
    80000576:	04b2                	slli	s1,s1,0xc
  for (int level = 2; level > 0; level--)
    80000578:	3a5d                	addiw	s4,s4,-9
    8000057a:	ff6a12e3          	bne	s4,s6,8000055e <walk+0x26>
        return 0;
      memset(pagetable, 0, PGSIZE);
      *pte = PA2PTE(pagetable) | PTE_V;
    }
  }
  return &pagetable[PX(0, va)];
    8000057e:	00c9d513          	srli	a0,s3,0xc
    80000582:	1ff57513          	andi	a0,a0,511
    80000586:	050e                	slli	a0,a0,0x3
    80000588:	9526                	add	a0,a0,s1
}
    8000058a:	70e2                	ld	ra,56(sp)
    8000058c:	7442                	ld	s0,48(sp)
    8000058e:	74a2                	ld	s1,40(sp)
    80000590:	7902                	ld	s2,32(sp)
    80000592:	69e2                	ld	s3,24(sp)
    80000594:	6a42                	ld	s4,16(sp)
    80000596:	6aa2                	ld	s5,8(sp)
    80000598:	6b02                	ld	s6,0(sp)
    8000059a:	6121                	addi	sp,sp,64
    8000059c:	8082                	ret
    panic("walk");
    8000059e:	00008517          	auipc	a0,0x8
    800005a2:	aba50513          	addi	a0,a0,-1350 # 80008058 <etext+0x58>
    800005a6:	00006097          	auipc	ra,0x6
    800005aa:	98c080e7          	jalr	-1652(ra) # 80005f32 <panic>
      if (!alloc || (pagetable = (pde_t *)kalloc()) == 0)
    800005ae:	020a8663          	beqz	s5,800005da <walk+0xa2>
    800005b2:	00000097          	auipc	ra,0x0
    800005b6:	be8080e7          	jalr	-1048(ra) # 8000019a <kalloc>
    800005ba:	84aa                	mv	s1,a0
    800005bc:	d579                	beqz	a0,8000058a <walk+0x52>
      memset(pagetable, 0, PGSIZE);
    800005be:	6605                	lui	a2,0x1
    800005c0:	4581                	li	a1,0
    800005c2:	00000097          	auipc	ra,0x0
    800005c6:	c7e080e7          	jalr	-898(ra) # 80000240 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800005ca:	00c4d793          	srli	a5,s1,0xc
    800005ce:	07aa                	slli	a5,a5,0xa
    800005d0:	0017e793          	ori	a5,a5,1
    800005d4:	00f93023          	sd	a5,0(s2)
    800005d8:	b745                	j	80000578 <walk+0x40>
        return 0;
    800005da:	4501                	li	a0,0
    800005dc:	b77d                	j	8000058a <walk+0x52>

00000000800005de <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if (va >= MAXVA)
    800005de:	57fd                	li	a5,-1
    800005e0:	83e9                	srli	a5,a5,0x1a
    800005e2:	00b7f463          	bgeu	a5,a1,800005ea <walkaddr+0xc>
    return 0;
    800005e6:	4501                	li	a0,0
    return 0;
  if ((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    800005e8:	8082                	ret
{
    800005ea:	1141                	addi	sp,sp,-16
    800005ec:	e406                	sd	ra,8(sp)
    800005ee:	e022                	sd	s0,0(sp)
    800005f0:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    800005f2:	4601                	li	a2,0
    800005f4:	00000097          	auipc	ra,0x0
    800005f8:	f44080e7          	jalr	-188(ra) # 80000538 <walk>
  if (pte == 0)
    800005fc:	c105                	beqz	a0,8000061c <walkaddr+0x3e>
  if ((*pte & PTE_V) == 0)
    800005fe:	611c                	ld	a5,0(a0)
  if ((*pte & PTE_U) == 0)
    80000600:	0117f693          	andi	a3,a5,17
    80000604:	4745                	li	a4,17
    return 0;
    80000606:	4501                	li	a0,0
  if ((*pte & PTE_U) == 0)
    80000608:	00e68663          	beq	a3,a4,80000614 <walkaddr+0x36>
}
    8000060c:	60a2                	ld	ra,8(sp)
    8000060e:	6402                	ld	s0,0(sp)
    80000610:	0141                	addi	sp,sp,16
    80000612:	8082                	ret
  pa = PTE2PA(*pte);
    80000614:	83a9                	srli	a5,a5,0xa
    80000616:	00c79513          	slli	a0,a5,0xc
  return pa;
    8000061a:	bfcd                	j	8000060c <walkaddr+0x2e>
    return 0;
    8000061c:	4501                	li	a0,0
    8000061e:	b7fd                	j	8000060c <walkaddr+0x2e>

0000000080000620 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000620:	715d                	addi	sp,sp,-80
    80000622:	e486                	sd	ra,72(sp)
    80000624:	e0a2                	sd	s0,64(sp)
    80000626:	fc26                	sd	s1,56(sp)
    80000628:	f84a                	sd	s2,48(sp)
    8000062a:	f44e                	sd	s3,40(sp)
    8000062c:	f052                	sd	s4,32(sp)
    8000062e:	ec56                	sd	s5,24(sp)
    80000630:	e85a                	sd	s6,16(sp)
    80000632:	e45e                	sd	s7,8(sp)
    80000634:	e062                	sd	s8,0(sp)
    80000636:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if (size == 0)
    80000638:	ca21                	beqz	a2,80000688 <mappages+0x68>
    8000063a:	8aaa                	mv	s5,a0
    8000063c:	8b3a                	mv	s6,a4
    panic("mappages: size");

  a = PGROUNDDOWN(va);
    8000063e:	777d                	lui	a4,0xfffff
    80000640:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    80000644:	fff58993          	addi	s3,a1,-1
    80000648:	99b2                	add	s3,s3,a2
    8000064a:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    8000064e:	893e                	mv	s2,a5
    80000650:	40f68a33          	sub	s4,a3,a5
  for (;;)
  {
    if ((pte = walk(pagetable, a, 1)) == 0)
    80000654:	4b85                	li	s7,1
    if (*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if (a == last)
      break;
    a += PGSIZE;
    80000656:	6c05                	lui	s8,0x1
    80000658:	014904b3          	add	s1,s2,s4
    if ((pte = walk(pagetable, a, 1)) == 0)
    8000065c:	865e                	mv	a2,s7
    8000065e:	85ca                	mv	a1,s2
    80000660:	8556                	mv	a0,s5
    80000662:	00000097          	auipc	ra,0x0
    80000666:	ed6080e7          	jalr	-298(ra) # 80000538 <walk>
    8000066a:	cd1d                	beqz	a0,800006a8 <mappages+0x88>
    if (*pte & PTE_V)
    8000066c:	611c                	ld	a5,0(a0)
    8000066e:	8b85                	andi	a5,a5,1
    80000670:	e785                	bnez	a5,80000698 <mappages+0x78>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80000672:	80b1                	srli	s1,s1,0xc
    80000674:	04aa                	slli	s1,s1,0xa
    80000676:	0164e4b3          	or	s1,s1,s6
    8000067a:	0014e493          	ori	s1,s1,1
    8000067e:	e104                	sd	s1,0(a0)
    if (a == last)
    80000680:	05390163          	beq	s2,s3,800006c2 <mappages+0xa2>
    a += PGSIZE;
    80000684:	9962                	add	s2,s2,s8
    if ((pte = walk(pagetable, a, 1)) == 0)
    80000686:	bfc9                	j	80000658 <mappages+0x38>
    panic("mappages: size");
    80000688:	00008517          	auipc	a0,0x8
    8000068c:	9d850513          	addi	a0,a0,-1576 # 80008060 <etext+0x60>
    80000690:	00006097          	auipc	ra,0x6
    80000694:	8a2080e7          	jalr	-1886(ra) # 80005f32 <panic>
      panic("mappages: remap");
    80000698:	00008517          	auipc	a0,0x8
    8000069c:	9d850513          	addi	a0,a0,-1576 # 80008070 <etext+0x70>
    800006a0:	00006097          	auipc	ra,0x6
    800006a4:	892080e7          	jalr	-1902(ra) # 80005f32 <panic>
      return -1;
    800006a8:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800006aa:	60a6                	ld	ra,72(sp)
    800006ac:	6406                	ld	s0,64(sp)
    800006ae:	74e2                	ld	s1,56(sp)
    800006b0:	7942                	ld	s2,48(sp)
    800006b2:	79a2                	ld	s3,40(sp)
    800006b4:	7a02                	ld	s4,32(sp)
    800006b6:	6ae2                	ld	s5,24(sp)
    800006b8:	6b42                	ld	s6,16(sp)
    800006ba:	6ba2                	ld	s7,8(sp)
    800006bc:	6c02                	ld	s8,0(sp)
    800006be:	6161                	addi	sp,sp,80
    800006c0:	8082                	ret
  return 0;
    800006c2:	4501                	li	a0,0
    800006c4:	b7dd                	j	800006aa <mappages+0x8a>

00000000800006c6 <kvmmap>:
{
    800006c6:	1141                	addi	sp,sp,-16
    800006c8:	e406                	sd	ra,8(sp)
    800006ca:	e022                	sd	s0,0(sp)
    800006cc:	0800                	addi	s0,sp,16
    800006ce:	87b6                	mv	a5,a3
  if (mappages(kpgtbl, va, sz, pa, perm) != 0)
    800006d0:	86b2                	mv	a3,a2
    800006d2:	863e                	mv	a2,a5
    800006d4:	00000097          	auipc	ra,0x0
    800006d8:	f4c080e7          	jalr	-180(ra) # 80000620 <mappages>
    800006dc:	e509                	bnez	a0,800006e6 <kvmmap+0x20>
}
    800006de:	60a2                	ld	ra,8(sp)
    800006e0:	6402                	ld	s0,0(sp)
    800006e2:	0141                	addi	sp,sp,16
    800006e4:	8082                	ret
    panic("kvmmap");
    800006e6:	00008517          	auipc	a0,0x8
    800006ea:	99a50513          	addi	a0,a0,-1638 # 80008080 <etext+0x80>
    800006ee:	00006097          	auipc	ra,0x6
    800006f2:	844080e7          	jalr	-1980(ra) # 80005f32 <panic>

00000000800006f6 <kvmmake>:
{
    800006f6:	1101                	addi	sp,sp,-32
    800006f8:	ec06                	sd	ra,24(sp)
    800006fa:	e822                	sd	s0,16(sp)
    800006fc:	e426                	sd	s1,8(sp)
    800006fe:	e04a                	sd	s2,0(sp)
    80000700:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t)kalloc();
    80000702:	00000097          	auipc	ra,0x0
    80000706:	a98080e7          	jalr	-1384(ra) # 8000019a <kalloc>
    8000070a:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000070c:	6605                	lui	a2,0x1
    8000070e:	4581                	li	a1,0
    80000710:	00000097          	auipc	ra,0x0
    80000714:	b30080e7          	jalr	-1232(ra) # 80000240 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000718:	4719                	li	a4,6
    8000071a:	6685                	lui	a3,0x1
    8000071c:	10000637          	lui	a2,0x10000
    80000720:	85b2                	mv	a1,a2
    80000722:	8526                	mv	a0,s1
    80000724:	00000097          	auipc	ra,0x0
    80000728:	fa2080e7          	jalr	-94(ra) # 800006c6 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000072c:	4719                	li	a4,6
    8000072e:	6685                	lui	a3,0x1
    80000730:	10001637          	lui	a2,0x10001
    80000734:	85b2                	mv	a1,a2
    80000736:	8526                	mv	a0,s1
    80000738:	00000097          	auipc	ra,0x0
    8000073c:	f8e080e7          	jalr	-114(ra) # 800006c6 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000740:	4719                	li	a4,6
    80000742:	004006b7          	lui	a3,0x400
    80000746:	0c000637          	lui	a2,0xc000
    8000074a:	85b2                	mv	a1,a2
    8000074c:	8526                	mv	a0,s1
    8000074e:	00000097          	auipc	ra,0x0
    80000752:	f78080e7          	jalr	-136(ra) # 800006c6 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext - KERNBASE, PTE_R | PTE_X);
    80000756:	00008917          	auipc	s2,0x8
    8000075a:	8aa90913          	addi	s2,s2,-1878 # 80008000 <etext>
    8000075e:	4729                	li	a4,10
    80000760:	80008697          	auipc	a3,0x80008
    80000764:	8a068693          	addi	a3,a3,-1888 # 8000 <_entry-0x7fff8000>
    80000768:	4605                	li	a2,1
    8000076a:	067e                	slli	a2,a2,0x1f
    8000076c:	85b2                	mv	a1,a2
    8000076e:	8526                	mv	a0,s1
    80000770:	00000097          	auipc	ra,0x0
    80000774:	f56080e7          	jalr	-170(ra) # 800006c6 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP - (uint64)etext, PTE_R | PTE_W);
    80000778:	4719                	li	a4,6
    8000077a:	46c5                	li	a3,17
    8000077c:	06ee                	slli	a3,a3,0x1b
    8000077e:	412686b3          	sub	a3,a3,s2
    80000782:	864a                	mv	a2,s2
    80000784:	85ca                	mv	a1,s2
    80000786:	8526                	mv	a0,s1
    80000788:	00000097          	auipc	ra,0x0
    8000078c:	f3e080e7          	jalr	-194(ra) # 800006c6 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80000790:	4729                	li	a4,10
    80000792:	6685                	lui	a3,0x1
    80000794:	00007617          	auipc	a2,0x7
    80000798:	86c60613          	addi	a2,a2,-1940 # 80007000 <_trampoline>
    8000079c:	040005b7          	lui	a1,0x4000
    800007a0:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800007a2:	05b2                	slli	a1,a1,0xc
    800007a4:	8526                	mv	a0,s1
    800007a6:	00000097          	auipc	ra,0x0
    800007aa:	f20080e7          	jalr	-224(ra) # 800006c6 <kvmmap>
  proc_mapstacks(kpgtbl);
    800007ae:	8526                	mv	a0,s1
    800007b0:	00000097          	auipc	ra,0x0
    800007b4:	724080e7          	jalr	1828(ra) # 80000ed4 <proc_mapstacks>
}
    800007b8:	8526                	mv	a0,s1
    800007ba:	60e2                	ld	ra,24(sp)
    800007bc:	6442                	ld	s0,16(sp)
    800007be:	64a2                	ld	s1,8(sp)
    800007c0:	6902                	ld	s2,0(sp)
    800007c2:	6105                	addi	sp,sp,32
    800007c4:	8082                	ret

00000000800007c6 <kvminit>:
{
    800007c6:	1141                	addi	sp,sp,-16
    800007c8:	e406                	sd	ra,8(sp)
    800007ca:	e022                	sd	s0,0(sp)
    800007cc:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800007ce:	00000097          	auipc	ra,0x0
    800007d2:	f28080e7          	jalr	-216(ra) # 800006f6 <kvmmake>
    800007d6:	00009797          	auipc	a5,0x9
    800007da:	82a7b923          	sd	a0,-1998(a5) # 80009008 <kernel_pagetable>
}
    800007de:	60a2                	ld	ra,8(sp)
    800007e0:	6402                	ld	s0,0(sp)
    800007e2:	0141                	addi	sp,sp,16
    800007e4:	8082                	ret

00000000800007e6 <uvmunmap>:

// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    800007e6:	715d                	addi	sp,sp,-80
    800007e8:	e486                	sd	ra,72(sp)
    800007ea:	e0a2                	sd	s0,64(sp)
    800007ec:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if ((va % PGSIZE) != 0)
    800007ee:	03459793          	slli	a5,a1,0x34
    800007f2:	e39d                	bnez	a5,80000818 <uvmunmap+0x32>
    800007f4:	f84a                	sd	s2,48(sp)
    800007f6:	f44e                	sd	s3,40(sp)
    800007f8:	f052                	sd	s4,32(sp)
    800007fa:	ec56                	sd	s5,24(sp)
    800007fc:	e85a                	sd	s6,16(sp)
    800007fe:	e45e                	sd	s7,8(sp)
    80000800:	8a2a                	mv	s4,a0
    80000802:	892e                	mv	s2,a1
    80000804:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for (a = va; a < va + npages * PGSIZE; a += PGSIZE)
    80000806:	0632                	slli	a2,a2,0xc
    80000808:	00b609b3          	add	s3,a2,a1
  {
    if ((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if ((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if (PTE_FLAGS(*pte) == PTE_V)
    8000080c:	4b85                	li	s7,1
  for (a = va; a < va + npages * PGSIZE; a += PGSIZE)
    8000080e:	6b05                	lui	s6,0x1
    80000810:	0935fb63          	bgeu	a1,s3,800008a6 <uvmunmap+0xc0>
    80000814:	fc26                	sd	s1,56(sp)
    80000816:	a8a9                	j	80000870 <uvmunmap+0x8a>
    80000818:	fc26                	sd	s1,56(sp)
    8000081a:	f84a                	sd	s2,48(sp)
    8000081c:	f44e                	sd	s3,40(sp)
    8000081e:	f052                	sd	s4,32(sp)
    80000820:	ec56                	sd	s5,24(sp)
    80000822:	e85a                	sd	s6,16(sp)
    80000824:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    80000826:	00008517          	auipc	a0,0x8
    8000082a:	86250513          	addi	a0,a0,-1950 # 80008088 <etext+0x88>
    8000082e:	00005097          	auipc	ra,0x5
    80000832:	704080e7          	jalr	1796(ra) # 80005f32 <panic>
      panic("uvmunmap: walk");
    80000836:	00008517          	auipc	a0,0x8
    8000083a:	86a50513          	addi	a0,a0,-1942 # 800080a0 <etext+0xa0>
    8000083e:	00005097          	auipc	ra,0x5
    80000842:	6f4080e7          	jalr	1780(ra) # 80005f32 <panic>
      panic("uvmunmap: not mapped");
    80000846:	00008517          	auipc	a0,0x8
    8000084a:	86a50513          	addi	a0,a0,-1942 # 800080b0 <etext+0xb0>
    8000084e:	00005097          	auipc	ra,0x5
    80000852:	6e4080e7          	jalr	1764(ra) # 80005f32 <panic>
      panic("uvmunmap: not a leaf");
    80000856:	00008517          	auipc	a0,0x8
    8000085a:	87250513          	addi	a0,a0,-1934 # 800080c8 <etext+0xc8>
    8000085e:	00005097          	auipc	ra,0x5
    80000862:	6d4080e7          	jalr	1748(ra) # 80005f32 <panic>
    if (do_free)
    {
      uint64 pa = PTE2PA(*pte);
      kfree((void *)pa);
    }
    *pte = 0;
    80000866:	0004b023          	sd	zero,0(s1)
  for (a = va; a < va + npages * PGSIZE; a += PGSIZE)
    8000086a:	995a                	add	s2,s2,s6
    8000086c:	03397c63          	bgeu	s2,s3,800008a4 <uvmunmap+0xbe>
    if ((pte = walk(pagetable, a, 0)) == 0)
    80000870:	4601                	li	a2,0
    80000872:	85ca                	mv	a1,s2
    80000874:	8552                	mv	a0,s4
    80000876:	00000097          	auipc	ra,0x0
    8000087a:	cc2080e7          	jalr	-830(ra) # 80000538 <walk>
    8000087e:	84aa                	mv	s1,a0
    80000880:	d95d                	beqz	a0,80000836 <uvmunmap+0x50>
    if ((*pte & PTE_V) == 0)
    80000882:	6108                	ld	a0,0(a0)
    80000884:	00157793          	andi	a5,a0,1
    80000888:	dfdd                	beqz	a5,80000846 <uvmunmap+0x60>
    if (PTE_FLAGS(*pte) == PTE_V)
    8000088a:	3ff57793          	andi	a5,a0,1023
    8000088e:	fd7784e3          	beq	a5,s7,80000856 <uvmunmap+0x70>
    if (do_free)
    80000892:	fc0a8ae3          	beqz	s5,80000866 <uvmunmap+0x80>
      uint64 pa = PTE2PA(*pte);
    80000896:	8129                	srli	a0,a0,0xa
      kfree((void *)pa);
    80000898:	0532                	slli	a0,a0,0xc
    8000089a:	fffff097          	auipc	ra,0xfffff
    8000089e:	782080e7          	jalr	1922(ra) # 8000001c <kfree>
    800008a2:	b7d1                	j	80000866 <uvmunmap+0x80>
    800008a4:	74e2                	ld	s1,56(sp)
    800008a6:	7942                	ld	s2,48(sp)
    800008a8:	79a2                	ld	s3,40(sp)
    800008aa:	7a02                	ld	s4,32(sp)
    800008ac:	6ae2                	ld	s5,24(sp)
    800008ae:	6b42                	ld	s6,16(sp)
    800008b0:	6ba2                	ld	s7,8(sp)
  }
}
    800008b2:	60a6                	ld	ra,72(sp)
    800008b4:	6406                	ld	s0,64(sp)
    800008b6:	6161                	addi	sp,sp,80
    800008b8:	8082                	ret

00000000800008ba <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800008ba:	1101                	addi	sp,sp,-32
    800008bc:	ec06                	sd	ra,24(sp)
    800008be:	e822                	sd	s0,16(sp)
    800008c0:	e426                	sd	s1,8(sp)
    800008c2:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t)kalloc();
    800008c4:	00000097          	auipc	ra,0x0
    800008c8:	8d6080e7          	jalr	-1834(ra) # 8000019a <kalloc>
    800008cc:	84aa                	mv	s1,a0
  if (pagetable == 0)
    800008ce:	c519                	beqz	a0,800008dc <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800008d0:	6605                	lui	a2,0x1
    800008d2:	4581                	li	a1,0
    800008d4:	00000097          	auipc	ra,0x0
    800008d8:	96c080e7          	jalr	-1684(ra) # 80000240 <memset>
  return pagetable;
}
    800008dc:	8526                	mv	a0,s1
    800008de:	60e2                	ld	ra,24(sp)
    800008e0:	6442                	ld	s0,16(sp)
    800008e2:	64a2                	ld	s1,8(sp)
    800008e4:	6105                	addi	sp,sp,32
    800008e6:	8082                	ret

00000000800008e8 <uvminit>:

// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    800008e8:	7179                	addi	sp,sp,-48
    800008ea:	f406                	sd	ra,40(sp)
    800008ec:	f022                	sd	s0,32(sp)
    800008ee:	ec26                	sd	s1,24(sp)
    800008f0:	e84a                	sd	s2,16(sp)
    800008f2:	e44e                	sd	s3,8(sp)
    800008f4:	e052                	sd	s4,0(sp)
    800008f6:	1800                	addi	s0,sp,48
  char *mem;

  if (sz >= PGSIZE)
    800008f8:	6785                	lui	a5,0x1
    800008fa:	04f67863          	bgeu	a2,a5,8000094a <uvminit+0x62>
    800008fe:	8a2a                	mv	s4,a0
    80000900:	89ae                	mv	s3,a1
    80000902:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    80000904:	00000097          	auipc	ra,0x0
    80000908:	896080e7          	jalr	-1898(ra) # 8000019a <kalloc>
    8000090c:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    8000090e:	6605                	lui	a2,0x1
    80000910:	4581                	li	a1,0
    80000912:	00000097          	auipc	ra,0x0
    80000916:	92e080e7          	jalr	-1746(ra) # 80000240 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W | PTE_R | PTE_X | PTE_U);
    8000091a:	4779                	li	a4,30
    8000091c:	86ca                	mv	a3,s2
    8000091e:	6605                	lui	a2,0x1
    80000920:	4581                	li	a1,0
    80000922:	8552                	mv	a0,s4
    80000924:	00000097          	auipc	ra,0x0
    80000928:	cfc080e7          	jalr	-772(ra) # 80000620 <mappages>
  memmove(mem, src, sz);
    8000092c:	8626                	mv	a2,s1
    8000092e:	85ce                	mv	a1,s3
    80000930:	854a                	mv	a0,s2
    80000932:	00000097          	auipc	ra,0x0
    80000936:	972080e7          	jalr	-1678(ra) # 800002a4 <memmove>
}
    8000093a:	70a2                	ld	ra,40(sp)
    8000093c:	7402                	ld	s0,32(sp)
    8000093e:	64e2                	ld	s1,24(sp)
    80000940:	6942                	ld	s2,16(sp)
    80000942:	69a2                	ld	s3,8(sp)
    80000944:	6a02                	ld	s4,0(sp)
    80000946:	6145                	addi	sp,sp,48
    80000948:	8082                	ret
    panic("inituvm: more than a page");
    8000094a:	00007517          	auipc	a0,0x7
    8000094e:	79650513          	addi	a0,a0,1942 # 800080e0 <etext+0xe0>
    80000952:	00005097          	auipc	ra,0x5
    80000956:	5e0080e7          	jalr	1504(ra) # 80005f32 <panic>

000000008000095a <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000095a:	1101                	addi	sp,sp,-32
    8000095c:	ec06                	sd	ra,24(sp)
    8000095e:	e822                	sd	s0,16(sp)
    80000960:	e426                	sd	s1,8(sp)
    80000962:	1000                	addi	s0,sp,32
  if (newsz >= oldsz)
    return oldsz;
    80000964:	84ae                	mv	s1,a1
  if (newsz >= oldsz)
    80000966:	00b67d63          	bgeu	a2,a1,80000980 <uvmdealloc+0x26>
    8000096a:	84b2                	mv	s1,a2

  if (PGROUNDUP(newsz) < PGROUNDUP(oldsz))
    8000096c:	6785                	lui	a5,0x1
    8000096e:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000970:	00f60733          	add	a4,a2,a5
    80000974:	76fd                	lui	a3,0xfffff
    80000976:	8f75                	and	a4,a4,a3
    80000978:	97ae                	add	a5,a5,a1
    8000097a:	8ff5                	and	a5,a5,a3
    8000097c:	00f76863          	bltu	a4,a5,8000098c <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000980:	8526                	mv	a0,s1
    80000982:	60e2                	ld	ra,24(sp)
    80000984:	6442                	ld	s0,16(sp)
    80000986:	64a2                	ld	s1,8(sp)
    80000988:	6105                	addi	sp,sp,32
    8000098a:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    8000098c:	8f99                	sub	a5,a5,a4
    8000098e:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80000990:	4685                	li	a3,1
    80000992:	0007861b          	sext.w	a2,a5
    80000996:	85ba                	mv	a1,a4
    80000998:	00000097          	auipc	ra,0x0
    8000099c:	e4e080e7          	jalr	-434(ra) # 800007e6 <uvmunmap>
    800009a0:	b7c5                	j	80000980 <uvmdealloc+0x26>

00000000800009a2 <uvmalloc>:
  if (newsz < oldsz)
    800009a2:	0ab66e63          	bltu	a2,a1,80000a5e <uvmalloc+0xbc>
{
    800009a6:	715d                	addi	sp,sp,-80
    800009a8:	e486                	sd	ra,72(sp)
    800009aa:	e0a2                	sd	s0,64(sp)
    800009ac:	f052                	sd	s4,32(sp)
    800009ae:	ec56                	sd	s5,24(sp)
    800009b0:	e85a                	sd	s6,16(sp)
    800009b2:	0880                	addi	s0,sp,80
    800009b4:	8b2a                	mv	s6,a0
    800009b6:	8ab2                	mv	s5,a2
  oldsz = PGROUNDUP(oldsz);
    800009b8:	6785                	lui	a5,0x1
    800009ba:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800009bc:	95be                	add	a1,a1,a5
    800009be:	77fd                	lui	a5,0xfffff
    800009c0:	00f5fa33          	and	s4,a1,a5
  for (a = oldsz; a < newsz; a += PGSIZE)
    800009c4:	08ca7f63          	bgeu	s4,a2,80000a62 <uvmalloc+0xc0>
    800009c8:	fc26                	sd	s1,56(sp)
    800009ca:	f84a                	sd	s2,48(sp)
    800009cc:	f44e                	sd	s3,40(sp)
    800009ce:	e45e                	sd	s7,8(sp)
    800009d0:	8952                	mv	s2,s4
    memset(mem, 0, PGSIZE);
    800009d2:	6985                	lui	s3,0x1
    if (mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W | PTE_X | PTE_R | PTE_U) != 0)
    800009d4:	4bf9                	li	s7,30
    mem = kalloc();
    800009d6:	fffff097          	auipc	ra,0xfffff
    800009da:	7c4080e7          	jalr	1988(ra) # 8000019a <kalloc>
    800009de:	84aa                	mv	s1,a0
    if (mem == 0)
    800009e0:	c915                	beqz	a0,80000a14 <uvmalloc+0x72>
    memset(mem, 0, PGSIZE);
    800009e2:	864e                	mv	a2,s3
    800009e4:	4581                	li	a1,0
    800009e6:	00000097          	auipc	ra,0x0
    800009ea:	85a080e7          	jalr	-1958(ra) # 80000240 <memset>
    if (mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W | PTE_X | PTE_R | PTE_U) != 0)
    800009ee:	875e                	mv	a4,s7
    800009f0:	86a6                	mv	a3,s1
    800009f2:	864e                	mv	a2,s3
    800009f4:	85ca                	mv	a1,s2
    800009f6:	855a                	mv	a0,s6
    800009f8:	00000097          	auipc	ra,0x0
    800009fc:	c28080e7          	jalr	-984(ra) # 80000620 <mappages>
    80000a00:	ed0d                	bnez	a0,80000a3a <uvmalloc+0x98>
  for (a = oldsz; a < newsz; a += PGSIZE)
    80000a02:	994e                	add	s2,s2,s3
    80000a04:	fd5969e3          	bltu	s2,s5,800009d6 <uvmalloc+0x34>
  return newsz;
    80000a08:	8556                	mv	a0,s5
    80000a0a:	74e2                	ld	s1,56(sp)
    80000a0c:	7942                	ld	s2,48(sp)
    80000a0e:	79a2                	ld	s3,40(sp)
    80000a10:	6ba2                	ld	s7,8(sp)
    80000a12:	a829                	j	80000a2c <uvmalloc+0x8a>
      uvmdealloc(pagetable, a, oldsz);
    80000a14:	8652                	mv	a2,s4
    80000a16:	85ca                	mv	a1,s2
    80000a18:	855a                	mv	a0,s6
    80000a1a:	00000097          	auipc	ra,0x0
    80000a1e:	f40080e7          	jalr	-192(ra) # 8000095a <uvmdealloc>
      return 0;
    80000a22:	4501                	li	a0,0
    80000a24:	74e2                	ld	s1,56(sp)
    80000a26:	7942                	ld	s2,48(sp)
    80000a28:	79a2                	ld	s3,40(sp)
    80000a2a:	6ba2                	ld	s7,8(sp)
}
    80000a2c:	60a6                	ld	ra,72(sp)
    80000a2e:	6406                	ld	s0,64(sp)
    80000a30:	7a02                	ld	s4,32(sp)
    80000a32:	6ae2                	ld	s5,24(sp)
    80000a34:	6b42                	ld	s6,16(sp)
    80000a36:	6161                	addi	sp,sp,80
    80000a38:	8082                	ret
      kfree(mem);
    80000a3a:	8526                	mv	a0,s1
    80000a3c:	fffff097          	auipc	ra,0xfffff
    80000a40:	5e0080e7          	jalr	1504(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000a44:	8652                	mv	a2,s4
    80000a46:	85ca                	mv	a1,s2
    80000a48:	855a                	mv	a0,s6
    80000a4a:	00000097          	auipc	ra,0x0
    80000a4e:	f10080e7          	jalr	-240(ra) # 8000095a <uvmdealloc>
      return 0;
    80000a52:	4501                	li	a0,0
    80000a54:	74e2                	ld	s1,56(sp)
    80000a56:	7942                	ld	s2,48(sp)
    80000a58:	79a2                	ld	s3,40(sp)
    80000a5a:	6ba2                	ld	s7,8(sp)
    80000a5c:	bfc1                	j	80000a2c <uvmalloc+0x8a>
    return oldsz;
    80000a5e:	852e                	mv	a0,a1
}
    80000a60:	8082                	ret
  return newsz;
    80000a62:	8532                	mv	a0,a2
    80000a64:	b7e1                	j	80000a2c <uvmalloc+0x8a>

0000000080000a66 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void freewalk(pagetable_t pagetable)
{
    80000a66:	7179                	addi	sp,sp,-48
    80000a68:	f406                	sd	ra,40(sp)
    80000a6a:	f022                	sd	s0,32(sp)
    80000a6c:	ec26                	sd	s1,24(sp)
    80000a6e:	e84a                	sd	s2,16(sp)
    80000a70:	e44e                	sd	s3,8(sp)
    80000a72:	e052                	sd	s4,0(sp)
    80000a74:	1800                	addi	s0,sp,48
    80000a76:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for (int i = 0; i < 512; i++)
    80000a78:	84aa                	mv	s1,a0
    80000a7a:	6905                	lui	s2,0x1
    80000a7c:	992a                	add	s2,s2,a0
  {
    pte_t pte = pagetable[i];
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0)
    80000a7e:	4985                	li	s3,1
    80000a80:	a829                	j	80000a9a <freewalk+0x34>
    {
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000a82:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80000a84:	00c79513          	slli	a0,a5,0xc
    80000a88:	00000097          	auipc	ra,0x0
    80000a8c:	fde080e7          	jalr	-34(ra) # 80000a66 <freewalk>
      pagetable[i] = 0;
    80000a90:	0004b023          	sd	zero,0(s1)
  for (int i = 0; i < 512; i++)
    80000a94:	04a1                	addi	s1,s1,8
    80000a96:	03248163          	beq	s1,s2,80000ab8 <freewalk+0x52>
    pte_t pte = pagetable[i];
    80000a9a:	609c                	ld	a5,0(s1)
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0)
    80000a9c:	00f7f713          	andi	a4,a5,15
    80000aa0:	ff3701e3          	beq	a4,s3,80000a82 <freewalk+0x1c>
    }
    else if (pte & PTE_V)
    80000aa4:	8b85                	andi	a5,a5,1
    80000aa6:	d7fd                	beqz	a5,80000a94 <freewalk+0x2e>
    {
      panic("freewalk: leaf");
    80000aa8:	00007517          	auipc	a0,0x7
    80000aac:	65850513          	addi	a0,a0,1624 # 80008100 <etext+0x100>
    80000ab0:	00005097          	auipc	ra,0x5
    80000ab4:	482080e7          	jalr	1154(ra) # 80005f32 <panic>
    }
  }
  kfree((void *)pagetable);
    80000ab8:	8552                	mv	a0,s4
    80000aba:	fffff097          	auipc	ra,0xfffff
    80000abe:	562080e7          	jalr	1378(ra) # 8000001c <kfree>
}
    80000ac2:	70a2                	ld	ra,40(sp)
    80000ac4:	7402                	ld	s0,32(sp)
    80000ac6:	64e2                	ld	s1,24(sp)
    80000ac8:	6942                	ld	s2,16(sp)
    80000aca:	69a2                	ld	s3,8(sp)
    80000acc:	6a02                	ld	s4,0(sp)
    80000ace:	6145                	addi	sp,sp,48
    80000ad0:	8082                	ret

0000000080000ad2 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000ad2:	1101                	addi	sp,sp,-32
    80000ad4:	ec06                	sd	ra,24(sp)
    80000ad6:	e822                	sd	s0,16(sp)
    80000ad8:	e426                	sd	s1,8(sp)
    80000ada:	1000                	addi	s0,sp,32
    80000adc:	84aa                	mv	s1,a0
  if (sz > 0)
    80000ade:	e999                	bnez	a1,80000af4 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
  freewalk(pagetable);
    80000ae0:	8526                	mv	a0,s1
    80000ae2:	00000097          	auipc	ra,0x0
    80000ae6:	f84080e7          	jalr	-124(ra) # 80000a66 <freewalk>
}
    80000aea:	60e2                	ld	ra,24(sp)
    80000aec:	6442                	ld	s0,16(sp)
    80000aee:	64a2                	ld	s1,8(sp)
    80000af0:	6105                	addi	sp,sp,32
    80000af2:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
    80000af4:	6785                	lui	a5,0x1
    80000af6:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000af8:	95be                	add	a1,a1,a5
    80000afa:	4685                	li	a3,1
    80000afc:	00c5d613          	srli	a2,a1,0xc
    80000b00:	4581                	li	a1,0
    80000b02:	00000097          	auipc	ra,0x0
    80000b06:	ce4080e7          	jalr	-796(ra) # 800007e6 <uvmunmap>
    80000b0a:	bfd9                	j	80000ae0 <uvmfree+0xe>

0000000080000b0c <uvmcopy>:
{
  pte_t *pte;
  uint64 pa, i;
  uint flags;

  for (i = 0; i < sz; i += PGSIZE)
    80000b0c:	ce6d                	beqz	a2,80000c06 <uvmcopy+0xfa>
{
    80000b0e:	711d                	addi	sp,sp,-96
    80000b10:	ec86                	sd	ra,88(sp)
    80000b12:	e8a2                	sd	s0,80(sp)
    80000b14:	e4a6                	sd	s1,72(sp)
    80000b16:	e0ca                	sd	s2,64(sp)
    80000b18:	fc4e                	sd	s3,56(sp)
    80000b1a:	f852                	sd	s4,48(sp)
    80000b1c:	f456                	sd	s5,40(sp)
    80000b1e:	f05a                	sd	s6,32(sp)
    80000b20:	ec5e                	sd	s7,24(sp)
    80000b22:	e862                	sd	s8,16(sp)
    80000b24:	e466                	sd	s9,8(sp)
    80000b26:	e06a                	sd	s10,0(sp)
    80000b28:	1080                	addi	s0,sp,96
    80000b2a:	8c2a                	mv	s8,a0
    80000b2c:	8bae                	mv	s7,a1
    80000b2e:	8b32                	mv	s6,a2
  for (i = 0; i < sz; i += PGSIZE)
    80000b30:	4481                	li	s1,0
    flags = PTE_FLAGS(*pte);
    flags &= ~PTE_W;
    *pte = (*pte & ~PTE_W);

    // increment the reference count for the physical page
    acquire(&refcnt_lock);
    80000b32:	00008a17          	auipc	s4,0x8
    80000b36:	4fea0a13          	addi	s4,s4,1278 # 80009030 <refcnt_lock>
    int index = ((uint64)pa - (uint64)end) / PGSIZE;
    80000b3a:	00245d17          	auipc	s10,0x245
    80000b3e:	706d0d13          	addi	s10,s10,1798 # 80246240 <end>
    refcnt[index]++;
    80000b42:	00008c97          	auipc	s9,0x8
    80000b46:	526c8c93          	addi	s9,s9,1318 # 80009068 <refcnt>
    release(&refcnt_lock);

    if (mappages(new, i, PGSIZE, pa, flags) != 0)
    80000b4a:	6a85                	lui	s5,0x1
    if ((pte = walk(old, i, 0)) == 0)
    80000b4c:	4601                	li	a2,0
    80000b4e:	85a6                	mv	a1,s1
    80000b50:	8562                	mv	a0,s8
    80000b52:	00000097          	auipc	ra,0x0
    80000b56:	9e6080e7          	jalr	-1562(ra) # 80000538 <walk>
    80000b5a:	cd31                	beqz	a0,80000bb6 <uvmcopy+0xaa>
    if ((*pte & PTE_V) == 0)
    80000b5c:	00053903          	ld	s2,0(a0)
    80000b60:	00197793          	andi	a5,s2,1
    80000b64:	c3ad                	beqz	a5,80000bc6 <uvmcopy+0xba>
    pa = PTE2PA(*pte);
    80000b66:	00a95993          	srli	s3,s2,0xa
    80000b6a:	09b2                	slli	s3,s3,0xc
    *pte = (*pte & ~PTE_W);
    80000b6c:	ffb97793          	andi	a5,s2,-5
    80000b70:	e11c                	sd	a5,0(a0)
    acquire(&refcnt_lock);
    80000b72:	8552                	mv	a0,s4
    80000b74:	00006097          	auipc	ra,0x6
    80000b78:	93e080e7          	jalr	-1730(ra) # 800064b2 <acquire>
    int index = ((uint64)pa - (uint64)end) / PGSIZE;
    80000b7c:	41a987b3          	sub	a5,s3,s10
    80000b80:	83b1                	srli	a5,a5,0xc
    80000b82:	2781                	sext.w	a5,a5
    refcnt[index]++;
    80000b84:	078a                	slli	a5,a5,0x2
    80000b86:	97e6                	add	a5,a5,s9
    80000b88:	4398                	lw	a4,0(a5)
    80000b8a:	2705                	addiw	a4,a4,1 # fffffffffffff001 <end+0xffffffff7fdb8dc1>
    80000b8c:	c398                	sw	a4,0(a5)
    release(&refcnt_lock);
    80000b8e:	8552                	mv	a0,s4
    80000b90:	00006097          	auipc	ra,0x6
    80000b94:	9d2080e7          	jalr	-1582(ra) # 80006562 <release>
    if (mappages(new, i, PGSIZE, pa, flags) != 0)
    80000b98:	3fb97713          	andi	a4,s2,1019
    80000b9c:	86ce                	mv	a3,s3
    80000b9e:	8656                	mv	a2,s5
    80000ba0:	85a6                	mv	a1,s1
    80000ba2:	855e                	mv	a0,s7
    80000ba4:	00000097          	auipc	ra,0x0
    80000ba8:	a7c080e7          	jalr	-1412(ra) # 80000620 <mappages>
    80000bac:	e50d                	bnez	a0,80000bd6 <uvmcopy+0xca>
  for (i = 0; i < sz; i += PGSIZE)
    80000bae:	94d6                	add	s1,s1,s5
    80000bb0:	f964eee3          	bltu	s1,s6,80000b4c <uvmcopy+0x40>
    80000bb4:	a81d                	j	80000bea <uvmcopy+0xde>
      panic("uvmcopy: pte should exist");
    80000bb6:	00007517          	auipc	a0,0x7
    80000bba:	55a50513          	addi	a0,a0,1370 # 80008110 <etext+0x110>
    80000bbe:	00005097          	auipc	ra,0x5
    80000bc2:	374080e7          	jalr	884(ra) # 80005f32 <panic>
      panic("uvmcopy: page not present");
    80000bc6:	00007517          	auipc	a0,0x7
    80000bca:	56a50513          	addi	a0,a0,1386 # 80008130 <etext+0x130>
    80000bce:	00005097          	auipc	ra,0x5
    80000bd2:	364080e7          	jalr	868(ra) # 80005f32 <panic>
    }
  }
  return 0;

err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000bd6:	4685                	li	a3,1
    80000bd8:	00c4d613          	srli	a2,s1,0xc
    80000bdc:	4581                	li	a1,0
    80000bde:	855e                	mv	a0,s7
    80000be0:	00000097          	auipc	ra,0x0
    80000be4:	c06080e7          	jalr	-1018(ra) # 800007e6 <uvmunmap>
  return -1;
    80000be8:	557d                	li	a0,-1
}
    80000bea:	60e6                	ld	ra,88(sp)
    80000bec:	6446                	ld	s0,80(sp)
    80000bee:	64a6                	ld	s1,72(sp)
    80000bf0:	6906                	ld	s2,64(sp)
    80000bf2:	79e2                	ld	s3,56(sp)
    80000bf4:	7a42                	ld	s4,48(sp)
    80000bf6:	7aa2                	ld	s5,40(sp)
    80000bf8:	7b02                	ld	s6,32(sp)
    80000bfa:	6be2                	ld	s7,24(sp)
    80000bfc:	6c42                	ld	s8,16(sp)
    80000bfe:	6ca2                	ld	s9,8(sp)
    80000c00:	6d02                	ld	s10,0(sp)
    80000c02:	6125                	addi	sp,sp,96
    80000c04:	8082                	ret
  return 0;
    80000c06:	4501                	li	a0,0
}
    80000c08:	8082                	ret

0000000080000c0a <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void uvmclear(pagetable_t pagetable, uint64 va)
{
    80000c0a:	1141                	addi	sp,sp,-16
    80000c0c:	e406                	sd	ra,8(sp)
    80000c0e:	e022                	sd	s0,0(sp)
    80000c10:	0800                	addi	s0,sp,16
  pte_t *pte;

  pte = walk(pagetable, va, 0);
    80000c12:	4601                	li	a2,0
    80000c14:	00000097          	auipc	ra,0x0
    80000c18:	924080e7          	jalr	-1756(ra) # 80000538 <walk>
  if (pte == 0)
    80000c1c:	c901                	beqz	a0,80000c2c <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000c1e:	611c                	ld	a5,0(a0)
    80000c20:	9bbd                	andi	a5,a5,-17
    80000c22:	e11c                	sd	a5,0(a0)
}
    80000c24:	60a2                	ld	ra,8(sp)
    80000c26:	6402                	ld	s0,0(sp)
    80000c28:	0141                	addi	sp,sp,16
    80000c2a:	8082                	ret
    panic("uvmclear");
    80000c2c:	00007517          	auipc	a0,0x7
    80000c30:	52450513          	addi	a0,a0,1316 # 80008150 <etext+0x150>
    80000c34:	00005097          	auipc	ra,0x5
    80000c38:	2fe080e7          	jalr	766(ra) # 80005f32 <panic>

0000000080000c3c <copyout>:
{
  uint64 n, va0, pa0;
  pte_t *pte;
  char *mem;

  while (len > 0)
    80000c3c:	12068d63          	beqz	a3,80000d76 <copyout+0x13a>
{
    80000c40:	7159                	addi	sp,sp,-112
    80000c42:	f486                	sd	ra,104(sp)
    80000c44:	f0a2                	sd	s0,96(sp)
    80000c46:	eca6                	sd	s1,88(sp)
    80000c48:	e8ca                	sd	s2,80(sp)
    80000c4a:	e4ce                	sd	s3,72(sp)
    80000c4c:	e0d2                	sd	s4,64(sp)
    80000c4e:	fc56                	sd	s5,56(sp)
    80000c50:	f85a                	sd	s6,48(sp)
    80000c52:	f45e                	sd	s7,40(sp)
    80000c54:	f062                	sd	s8,32(sp)
    80000c56:	ec66                	sd	s9,24(sp)
    80000c58:	e86a                	sd	s10,16(sp)
    80000c5a:	e46e                	sd	s11,8(sp)
    80000c5c:	1880                	addi	s0,sp,112
    80000c5e:	8caa                	mv	s9,a0
    80000c60:	8aae                	mv	s5,a1
    80000c62:	8bb2                	mv	s7,a2
    80000c64:	8b36                	mv	s6,a3
  {
    va0 = PGROUNDDOWN(dstva);
    80000c66:	7d7d                	lui	s10,0xfffff
    {
      // COW: 分配新页，复制内容，更新PTE
      pa0 = PTE2PA(*pte);
      if ((mem = kalloc()) == 0)
        return -1;
      memmove(mem, (char *)pa0, PGSIZE);
    80000c68:	6c05                	lui	s8,0x1
      uint flags = PTE_FLAGS(*pte);
      flags |= PTE_W;
      *pte = PA2PTE((uint64)mem) | flags;

      // 递减原物理页引用计数并可能释放
      acquire(&refcnt_lock);
    80000c6a:	00008d97          	auipc	s11,0x8
    80000c6e:	3c6d8d93          	addi	s11,s11,966 # 80009030 <refcnt_lock>
    80000c72:	a83d                	j	80000cb0 <copyout+0x74>
      {
        refcnt[index]--;
        int ref = refcnt[index];
        release(&refcnt_lock);
        if (ref == 0)
          kfree((void *)pa0);
    80000c74:	854a                	mv	a0,s2
    80000c76:	fffff097          	auipc	ra,0xfffff
    80000c7a:	3a6080e7          	jalr	934(ra) # 8000001c <kfree>
        release(&refcnt_lock);
        panic("copyout: invalid refcnt index");
      }
    }
    pa0 = PTE2PA(*pte);
    n = PGSIZE - (dstva - va0);
    80000c7e:	41598933          	sub	s2,s3,s5
    80000c82:	9962                	add	s2,s2,s8
    if (n > len)
    80000c84:	012b7363          	bgeu	s6,s2,80000c8a <copyout+0x4e>
    80000c88:	895a                	mv	s2,s6
    pa0 = PTE2PA(*pte);
    80000c8a:	6088                	ld	a0,0(s1)
    80000c8c:	8129                	srli	a0,a0,0xa
    80000c8e:	0532                	slli	a0,a0,0xc
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000c90:	413a89b3          	sub	s3,s5,s3
    80000c94:	0009061b          	sext.w	a2,s2
    80000c98:	85de                	mv	a1,s7
    80000c9a:	954e                	add	a0,a0,s3
    80000c9c:	fffff097          	auipc	ra,0xfffff
    80000ca0:	608080e7          	jalr	1544(ra) # 800002a4 <memmove>

    len -= n;
    80000ca4:	412b0b33          	sub	s6,s6,s2
    src += n;
    80000ca8:	9bca                	add	s7,s7,s2
    dstva += n;
    80000caa:	9aca                	add	s5,s5,s2
  while (len > 0)
    80000cac:	0c0b0363          	beqz	s6,80000d72 <copyout+0x136>
    va0 = PGROUNDDOWN(dstva);
    80000cb0:	01aaf9b3          	and	s3,s5,s10
    pte = walk(pagetable, va0, 0);
    80000cb4:	4601                	li	a2,0
    80000cb6:	85ce                	mv	a1,s3
    80000cb8:	8566                	mv	a0,s9
    80000cba:	00000097          	auipc	ra,0x0
    80000cbe:	87e080e7          	jalr	-1922(ra) # 80000538 <walk>
    80000cc2:	84aa                	mv	s1,a0
    if (pte == 0 || (*pte & PTE_V) == 0)
    80000cc4:	c95d                	beqz	a0,80000d7a <copyout+0x13e>
    80000cc6:	00053903          	ld	s2,0(a0)
    80000cca:	00197793          	andi	a5,s2,1
    80000cce:	c7f1                	beqz	a5,80000d9a <copyout+0x15e>
    if ((*pte & PTE_W) == 0)
    80000cd0:	00497793          	andi	a5,s2,4
    80000cd4:	f7cd                	bnez	a5,80000c7e <copyout+0x42>
      pa0 = PTE2PA(*pte);
    80000cd6:	00a95913          	srli	s2,s2,0xa
    80000cda:	0932                	slli	s2,s2,0xc
      if ((mem = kalloc()) == 0)
    80000cdc:	fffff097          	auipc	ra,0xfffff
    80000ce0:	4be080e7          	jalr	1214(ra) # 8000019a <kalloc>
    80000ce4:	8a2a                	mv	s4,a0
    80000ce6:	cd45                	beqz	a0,80000d9e <copyout+0x162>
      memmove(mem, (char *)pa0, PGSIZE);
    80000ce8:	8662                	mv	a2,s8
    80000cea:	85ca                	mv	a1,s2
    80000cec:	fffff097          	auipc	ra,0xfffff
    80000cf0:	5b8080e7          	jalr	1464(ra) # 800002a4 <memmove>
      uint flags = PTE_FLAGS(*pte);
    80000cf4:	609c                	ld	a5,0(s1)
    80000cf6:	3ff7f793          	andi	a5,a5,1023
      *pte = PA2PTE((uint64)mem) | flags;
    80000cfa:	00ca5a13          	srli	s4,s4,0xc
    80000cfe:	0a2a                	slli	s4,s4,0xa
    80000d00:	0047e793          	ori	a5,a5,4
    80000d04:	00fa6a33          	or	s4,s4,a5
    80000d08:	0144b023          	sd	s4,0(s1)
      acquire(&refcnt_lock);
    80000d0c:	856e                	mv	a0,s11
    80000d0e:	00005097          	auipc	ra,0x5
    80000d12:	7a4080e7          	jalr	1956(ra) # 800064b2 <acquire>
      int index = ((uint64)pa0 - (uint64)end) / PGSIZE;
    80000d16:	00245797          	auipc	a5,0x245
    80000d1a:	52a78793          	addi	a5,a5,1322 # 80246240 <end>
    80000d1e:	40f907b3          	sub	a5,s2,a5
    80000d22:	83b1                	srli	a5,a5,0xc
    80000d24:	2781                	sext.w	a5,a5
      if (index >= 0 && index < PHYPAGES)
    80000d26:	00088737          	lui	a4,0x88
    80000d2a:	02e7f463          	bgeu	a5,a4,80000d52 <copyout+0x116>
        refcnt[index]--;
    80000d2e:	078a                	slli	a5,a5,0x2
    80000d30:	00008717          	auipc	a4,0x8
    80000d34:	33870713          	addi	a4,a4,824 # 80009068 <refcnt>
    80000d38:	97ba                	add	a5,a5,a4
    80000d3a:	4398                	lw	a4,0(a5)
    80000d3c:	377d                	addiw	a4,a4,-1
    80000d3e:	8a3a                	mv	s4,a4
    80000d40:	c398                	sw	a4,0(a5)
        release(&refcnt_lock);
    80000d42:	856e                	mv	a0,s11
    80000d44:	00006097          	auipc	ra,0x6
    80000d48:	81e080e7          	jalr	-2018(ra) # 80006562 <release>
        if (ref == 0)
    80000d4c:	f20a19e3          	bnez	s4,80000c7e <copyout+0x42>
    80000d50:	b715                	j	80000c74 <copyout+0x38>
        release(&refcnt_lock);
    80000d52:	00008517          	auipc	a0,0x8
    80000d56:	2de50513          	addi	a0,a0,734 # 80009030 <refcnt_lock>
    80000d5a:	00006097          	auipc	ra,0x6
    80000d5e:	808080e7          	jalr	-2040(ra) # 80006562 <release>
        panic("copyout: invalid refcnt index");
    80000d62:	00007517          	auipc	a0,0x7
    80000d66:	3fe50513          	addi	a0,a0,1022 # 80008160 <etext+0x160>
    80000d6a:	00005097          	auipc	ra,0x5
    80000d6e:	1c8080e7          	jalr	456(ra) # 80005f32 <panic>
  }
  return 0;
    80000d72:	4501                	li	a0,0
    80000d74:	a021                	j	80000d7c <copyout+0x140>
    80000d76:	4501                	li	a0,0
}
    80000d78:	8082                	ret
      return -1;
    80000d7a:	557d                	li	a0,-1
}
    80000d7c:	70a6                	ld	ra,104(sp)
    80000d7e:	7406                	ld	s0,96(sp)
    80000d80:	64e6                	ld	s1,88(sp)
    80000d82:	6946                	ld	s2,80(sp)
    80000d84:	69a6                	ld	s3,72(sp)
    80000d86:	6a06                	ld	s4,64(sp)
    80000d88:	7ae2                	ld	s5,56(sp)
    80000d8a:	7b42                	ld	s6,48(sp)
    80000d8c:	7ba2                	ld	s7,40(sp)
    80000d8e:	7c02                	ld	s8,32(sp)
    80000d90:	6ce2                	ld	s9,24(sp)
    80000d92:	6d42                	ld	s10,16(sp)
    80000d94:	6da2                	ld	s11,8(sp)
    80000d96:	6165                	addi	sp,sp,112
    80000d98:	8082                	ret
      return -1;
    80000d9a:	557d                	li	a0,-1
    80000d9c:	b7c5                	j	80000d7c <copyout+0x140>
        return -1;
    80000d9e:	557d                	li	a0,-1
    80000da0:	bff1                	j	80000d7c <copyout+0x140>

0000000080000da2 <copyin>:
// Return 0 on success, -1 on error.
int copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while (len > 0)
    80000da2:	caa5                	beqz	a3,80000e12 <copyin+0x70>
{
    80000da4:	715d                	addi	sp,sp,-80
    80000da6:	e486                	sd	ra,72(sp)
    80000da8:	e0a2                	sd	s0,64(sp)
    80000daa:	fc26                	sd	s1,56(sp)
    80000dac:	f84a                	sd	s2,48(sp)
    80000dae:	f44e                	sd	s3,40(sp)
    80000db0:	f052                	sd	s4,32(sp)
    80000db2:	ec56                	sd	s5,24(sp)
    80000db4:	e85a                	sd	s6,16(sp)
    80000db6:	e45e                	sd	s7,8(sp)
    80000db8:	e062                	sd	s8,0(sp)
    80000dba:	0880                	addi	s0,sp,80
    80000dbc:	8b2a                	mv	s6,a0
    80000dbe:	8a2e                	mv	s4,a1
    80000dc0:	8c32                	mv	s8,a2
    80000dc2:	89b6                	mv	s3,a3
  {
    va0 = PGROUNDDOWN(srcva);
    80000dc4:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if (pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000dc6:	6a85                	lui	s5,0x1
    80000dc8:	a01d                	j	80000dee <copyin+0x4c>
    if (n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000dca:	018505b3          	add	a1,a0,s8
    80000dce:	0004861b          	sext.w	a2,s1
    80000dd2:	412585b3          	sub	a1,a1,s2
    80000dd6:	8552                	mv	a0,s4
    80000dd8:	fffff097          	auipc	ra,0xfffff
    80000ddc:	4cc080e7          	jalr	1228(ra) # 800002a4 <memmove>

    len -= n;
    80000de0:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000de4:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000de6:	01590c33          	add	s8,s2,s5
  while (len > 0)
    80000dea:	02098263          	beqz	s3,80000e0e <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000dee:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000df2:	85ca                	mv	a1,s2
    80000df4:	855a                	mv	a0,s6
    80000df6:	fffff097          	auipc	ra,0xfffff
    80000dfa:	7e8080e7          	jalr	2024(ra) # 800005de <walkaddr>
    if (pa0 == 0)
    80000dfe:	cd01                	beqz	a0,80000e16 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000e00:	418904b3          	sub	s1,s2,s8
    80000e04:	94d6                	add	s1,s1,s5
    if (n > len)
    80000e06:	fc99f2e3          	bgeu	s3,s1,80000dca <copyin+0x28>
    80000e0a:	84ce                	mv	s1,s3
    80000e0c:	bf7d                	j	80000dca <copyin+0x28>
  }
  return 0;
    80000e0e:	4501                	li	a0,0
    80000e10:	a021                	j	80000e18 <copyin+0x76>
    80000e12:	4501                	li	a0,0
}
    80000e14:	8082                	ret
      return -1;
    80000e16:	557d                	li	a0,-1
}
    80000e18:	60a6                	ld	ra,72(sp)
    80000e1a:	6406                	ld	s0,64(sp)
    80000e1c:	74e2                	ld	s1,56(sp)
    80000e1e:	7942                	ld	s2,48(sp)
    80000e20:	79a2                	ld	s3,40(sp)
    80000e22:	7a02                	ld	s4,32(sp)
    80000e24:	6ae2                	ld	s5,24(sp)
    80000e26:	6b42                	ld	s6,16(sp)
    80000e28:	6ba2                	ld	s7,8(sp)
    80000e2a:	6c02                	ld	s8,0(sp)
    80000e2c:	6161                	addi	sp,sp,80
    80000e2e:	8082                	ret

0000000080000e30 <copyinstr>:
// Copy a null-terminated string from user to kernel.
// Copy bytes to dst from virtual address srcva in a given page table,
// until a '\0', or max.
// Return 0 on success, -1 on error.
int copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
    80000e30:	715d                	addi	sp,sp,-80
    80000e32:	e486                	sd	ra,72(sp)
    80000e34:	e0a2                	sd	s0,64(sp)
    80000e36:	fc26                	sd	s1,56(sp)
    80000e38:	f84a                	sd	s2,48(sp)
    80000e3a:	f44e                	sd	s3,40(sp)
    80000e3c:	f052                	sd	s4,32(sp)
    80000e3e:	ec56                	sd	s5,24(sp)
    80000e40:	e85a                	sd	s6,16(sp)
    80000e42:	e45e                	sd	s7,8(sp)
    80000e44:	0880                	addi	s0,sp,80
    80000e46:	8aaa                	mv	s5,a0
    80000e48:	89ae                	mv	s3,a1
    80000e4a:	8bb2                	mv	s7,a2
    80000e4c:	84b6                	mv	s1,a3
  uint64 n, va0, pa0;
  int got_null = 0;

  while (got_null == 0 && max > 0)
  {
    va0 = PGROUNDDOWN(srcva);
    80000e4e:	7b7d                	lui	s6,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if (pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000e50:	6a05                	lui	s4,0x1
    80000e52:	a02d                	j	80000e7c <copyinstr+0x4c>
    char *p = (char *)(pa0 + (srcva - va0));
    while (n > 0)
    {
      if (*p == '\0')
      {
        *dst = '\0';
    80000e54:	00078023          	sb	zero,0(a5)
    80000e58:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if (got_null)
    80000e5a:	0017c793          	xori	a5,a5,1
    80000e5e:	40f0053b          	negw	a0,a5
  }
  else
  {
    return -1;
  }
}
    80000e62:	60a6                	ld	ra,72(sp)
    80000e64:	6406                	ld	s0,64(sp)
    80000e66:	74e2                	ld	s1,56(sp)
    80000e68:	7942                	ld	s2,48(sp)
    80000e6a:	79a2                	ld	s3,40(sp)
    80000e6c:	7a02                	ld	s4,32(sp)
    80000e6e:	6ae2                	ld	s5,24(sp)
    80000e70:	6b42                	ld	s6,16(sp)
    80000e72:	6ba2                	ld	s7,8(sp)
    80000e74:	6161                	addi	sp,sp,80
    80000e76:	8082                	ret
    srcva = va0 + PGSIZE;
    80000e78:	01490bb3          	add	s7,s2,s4
  while (got_null == 0 && max > 0)
    80000e7c:	c8a1                	beqz	s1,80000ecc <copyinstr+0x9c>
    va0 = PGROUNDDOWN(srcva);
    80000e7e:	016bf933          	and	s2,s7,s6
    pa0 = walkaddr(pagetable, va0);
    80000e82:	85ca                	mv	a1,s2
    80000e84:	8556                	mv	a0,s5
    80000e86:	fffff097          	auipc	ra,0xfffff
    80000e8a:	758080e7          	jalr	1880(ra) # 800005de <walkaddr>
    if (pa0 == 0)
    80000e8e:	c129                	beqz	a0,80000ed0 <copyinstr+0xa0>
    n = PGSIZE - (srcva - va0);
    80000e90:	41790633          	sub	a2,s2,s7
    80000e94:	9652                	add	a2,a2,s4
    if (n > max)
    80000e96:	00c4f363          	bgeu	s1,a2,80000e9c <copyinstr+0x6c>
    80000e9a:	8626                	mv	a2,s1
    char *p = (char *)(pa0 + (srcva - va0));
    80000e9c:	412b8bb3          	sub	s7,s7,s2
    80000ea0:	9baa                	add	s7,s7,a0
    while (n > 0)
    80000ea2:	da79                	beqz	a2,80000e78 <copyinstr+0x48>
    80000ea4:	87ce                	mv	a5,s3
      if (*p == '\0')
    80000ea6:	413b86b3          	sub	a3,s7,s3
    while (n > 0)
    80000eaa:	964e                	add	a2,a2,s3
    80000eac:	85be                	mv	a1,a5
      if (*p == '\0')
    80000eae:	00f68733          	add	a4,a3,a5
    80000eb2:	00074703          	lbu	a4,0(a4)
    80000eb6:	df59                	beqz	a4,80000e54 <copyinstr+0x24>
        *dst = *p;
    80000eb8:	00e78023          	sb	a4,0(a5)
      dst++;
    80000ebc:	0785                	addi	a5,a5,1
    while (n > 0)
    80000ebe:	fec797e3          	bne	a5,a2,80000eac <copyinstr+0x7c>
    80000ec2:	14fd                	addi	s1,s1,-1
    80000ec4:	94ce                	add	s1,s1,s3
      --max;
    80000ec6:	8c8d                	sub	s1,s1,a1
    80000ec8:	89be                	mv	s3,a5
    80000eca:	b77d                	j	80000e78 <copyinstr+0x48>
    80000ecc:	4781                	li	a5,0
    80000ece:	b771                	j	80000e5a <copyinstr+0x2a>
      return -1;
    80000ed0:	557d                	li	a0,-1
    80000ed2:	bf41                	j	80000e62 <copyinstr+0x32>

0000000080000ed4 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000ed4:	715d                	addi	sp,sp,-80
    80000ed6:	e486                	sd	ra,72(sp)
    80000ed8:	e0a2                	sd	s0,64(sp)
    80000eda:	fc26                	sd	s1,56(sp)
    80000edc:	f84a                	sd	s2,48(sp)
    80000ede:	f44e                	sd	s3,40(sp)
    80000ee0:	f052                	sd	s4,32(sp)
    80000ee2:	ec56                	sd	s5,24(sp)
    80000ee4:	e85a                	sd	s6,16(sp)
    80000ee6:	e45e                	sd	s7,8(sp)
    80000ee8:	e062                	sd	s8,0(sp)
    80000eea:	0880                	addi	s0,sp,80
    80000eec:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000eee:	00228497          	auipc	s1,0x228
    80000ef2:	5aa48493          	addi	s1,s1,1450 # 80229498 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000ef6:	8c26                	mv	s8,s1
    80000ef8:	a4fa57b7          	lui	a5,0xa4fa5
    80000efc:	fa578793          	addi	a5,a5,-91 # ffffffffa4fa4fa5 <end+0xffffffff24d5ed65>
    80000f00:	4fa50937          	lui	s2,0x4fa50
    80000f04:	a5090913          	addi	s2,s2,-1456 # 4fa4fa50 <_entry-0x305b05b0>
    80000f08:	1902                	slli	s2,s2,0x20
    80000f0a:	993e                	add	s2,s2,a5
    80000f0c:	040009b7          	lui	s3,0x4000
    80000f10:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000f12:	09b2                	slli	s3,s3,0xc
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000f14:	4b99                	li	s7,6
    80000f16:	6b05                	lui	s6,0x1
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f18:	0022ea97          	auipc	s5,0x22e
    80000f1c:	f80a8a93          	addi	s5,s5,-128 # 8022ee98 <tickslock>
    char *pa = kalloc();
    80000f20:	fffff097          	auipc	ra,0xfffff
    80000f24:	27a080e7          	jalr	634(ra) # 8000019a <kalloc>
    80000f28:	862a                	mv	a2,a0
    if(pa == 0)
    80000f2a:	c131                	beqz	a0,80000f6e <proc_mapstacks+0x9a>
    uint64 va = KSTACK((int) (p - proc));
    80000f2c:	418485b3          	sub	a1,s1,s8
    80000f30:	858d                	srai	a1,a1,0x3
    80000f32:	032585b3          	mul	a1,a1,s2
    80000f36:	2585                	addiw	a1,a1,1
    80000f38:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000f3c:	875e                	mv	a4,s7
    80000f3e:	86da                	mv	a3,s6
    80000f40:	40b985b3          	sub	a1,s3,a1
    80000f44:	8552                	mv	a0,s4
    80000f46:	fffff097          	auipc	ra,0xfffff
    80000f4a:	780080e7          	jalr	1920(ra) # 800006c6 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f4e:	16848493          	addi	s1,s1,360
    80000f52:	fd5497e3          	bne	s1,s5,80000f20 <proc_mapstacks+0x4c>
  }
}
    80000f56:	60a6                	ld	ra,72(sp)
    80000f58:	6406                	ld	s0,64(sp)
    80000f5a:	74e2                	ld	s1,56(sp)
    80000f5c:	7942                	ld	s2,48(sp)
    80000f5e:	79a2                	ld	s3,40(sp)
    80000f60:	7a02                	ld	s4,32(sp)
    80000f62:	6ae2                	ld	s5,24(sp)
    80000f64:	6b42                	ld	s6,16(sp)
    80000f66:	6ba2                	ld	s7,8(sp)
    80000f68:	6c02                	ld	s8,0(sp)
    80000f6a:	6161                	addi	sp,sp,80
    80000f6c:	8082                	ret
      panic("kalloc");
    80000f6e:	00007517          	auipc	a0,0x7
    80000f72:	21250513          	addi	a0,a0,530 # 80008180 <etext+0x180>
    80000f76:	00005097          	auipc	ra,0x5
    80000f7a:	fbc080e7          	jalr	-68(ra) # 80005f32 <panic>

0000000080000f7e <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000f7e:	7139                	addi	sp,sp,-64
    80000f80:	fc06                	sd	ra,56(sp)
    80000f82:	f822                	sd	s0,48(sp)
    80000f84:	f426                	sd	s1,40(sp)
    80000f86:	f04a                	sd	s2,32(sp)
    80000f88:	ec4e                	sd	s3,24(sp)
    80000f8a:	e852                	sd	s4,16(sp)
    80000f8c:	e456                	sd	s5,8(sp)
    80000f8e:	e05a                	sd	s6,0(sp)
    80000f90:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000f92:	00007597          	auipc	a1,0x7
    80000f96:	1f658593          	addi	a1,a1,502 # 80008188 <etext+0x188>
    80000f9a:	00228517          	auipc	a0,0x228
    80000f9e:	0ce50513          	addi	a0,a0,206 # 80229068 <pid_lock>
    80000fa2:	00005097          	auipc	ra,0x5
    80000fa6:	47c080e7          	jalr	1148(ra) # 8000641e <initlock>
  initlock(&wait_lock, "wait_lock");
    80000faa:	00007597          	auipc	a1,0x7
    80000fae:	1e658593          	addi	a1,a1,486 # 80008190 <etext+0x190>
    80000fb2:	00228517          	auipc	a0,0x228
    80000fb6:	0ce50513          	addi	a0,a0,206 # 80229080 <wait_lock>
    80000fba:	00005097          	auipc	ra,0x5
    80000fbe:	464080e7          	jalr	1124(ra) # 8000641e <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000fc2:	00228497          	auipc	s1,0x228
    80000fc6:	4d648493          	addi	s1,s1,1238 # 80229498 <proc>
      initlock(&p->lock, "proc");
    80000fca:	00007b17          	auipc	s6,0x7
    80000fce:	1d6b0b13          	addi	s6,s6,470 # 800081a0 <etext+0x1a0>
      p->kstack = KSTACK((int) (p - proc));
    80000fd2:	8aa6                	mv	s5,s1
    80000fd4:	a4fa57b7          	lui	a5,0xa4fa5
    80000fd8:	fa578793          	addi	a5,a5,-91 # ffffffffa4fa4fa5 <end+0xffffffff24d5ed65>
    80000fdc:	4fa50937          	lui	s2,0x4fa50
    80000fe0:	a5090913          	addi	s2,s2,-1456 # 4fa4fa50 <_entry-0x305b05b0>
    80000fe4:	1902                	slli	s2,s2,0x20
    80000fe6:	993e                	add	s2,s2,a5
    80000fe8:	040009b7          	lui	s3,0x4000
    80000fec:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000fee:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ff0:	0022ea17          	auipc	s4,0x22e
    80000ff4:	ea8a0a13          	addi	s4,s4,-344 # 8022ee98 <tickslock>
      initlock(&p->lock, "proc");
    80000ff8:	85da                	mv	a1,s6
    80000ffa:	8526                	mv	a0,s1
    80000ffc:	00005097          	auipc	ra,0x5
    80001000:	422080e7          	jalr	1058(ra) # 8000641e <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80001004:	415487b3          	sub	a5,s1,s5
    80001008:	878d                	srai	a5,a5,0x3
    8000100a:	032787b3          	mul	a5,a5,s2
    8000100e:	2785                	addiw	a5,a5,1
    80001010:	00d7979b          	slliw	a5,a5,0xd
    80001014:	40f987b3          	sub	a5,s3,a5
    80001018:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    8000101a:	16848493          	addi	s1,s1,360
    8000101e:	fd449de3          	bne	s1,s4,80000ff8 <procinit+0x7a>
  }
}
    80001022:	70e2                	ld	ra,56(sp)
    80001024:	7442                	ld	s0,48(sp)
    80001026:	74a2                	ld	s1,40(sp)
    80001028:	7902                	ld	s2,32(sp)
    8000102a:	69e2                	ld	s3,24(sp)
    8000102c:	6a42                	ld	s4,16(sp)
    8000102e:	6aa2                	ld	s5,8(sp)
    80001030:	6b02                	ld	s6,0(sp)
    80001032:	6121                	addi	sp,sp,64
    80001034:	8082                	ret

0000000080001036 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80001036:	1141                	addi	sp,sp,-16
    80001038:	e406                	sd	ra,8(sp)
    8000103a:	e022                	sd	s0,0(sp)
    8000103c:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    8000103e:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80001040:	2501                	sext.w	a0,a0
    80001042:	60a2                	ld	ra,8(sp)
    80001044:	6402                	ld	s0,0(sp)
    80001046:	0141                	addi	sp,sp,16
    80001048:	8082                	ret

000000008000104a <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    8000104a:	1141                	addi	sp,sp,-16
    8000104c:	e406                	sd	ra,8(sp)
    8000104e:	e022                	sd	s0,0(sp)
    80001050:	0800                	addi	s0,sp,16
    80001052:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80001054:	2781                	sext.w	a5,a5
    80001056:	079e                	slli	a5,a5,0x7
  return c;
}
    80001058:	00228517          	auipc	a0,0x228
    8000105c:	04050513          	addi	a0,a0,64 # 80229098 <cpus>
    80001060:	953e                	add	a0,a0,a5
    80001062:	60a2                	ld	ra,8(sp)
    80001064:	6402                	ld	s0,0(sp)
    80001066:	0141                	addi	sp,sp,16
    80001068:	8082                	ret

000000008000106a <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    8000106a:	1101                	addi	sp,sp,-32
    8000106c:	ec06                	sd	ra,24(sp)
    8000106e:	e822                	sd	s0,16(sp)
    80001070:	e426                	sd	s1,8(sp)
    80001072:	1000                	addi	s0,sp,32
  push_off();
    80001074:	00005097          	auipc	ra,0x5
    80001078:	3f2080e7          	jalr	1010(ra) # 80006466 <push_off>
    8000107c:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    8000107e:	2781                	sext.w	a5,a5
    80001080:	079e                	slli	a5,a5,0x7
    80001082:	00228717          	auipc	a4,0x228
    80001086:	fe670713          	addi	a4,a4,-26 # 80229068 <pid_lock>
    8000108a:	97ba                	add	a5,a5,a4
    8000108c:	7b84                	ld	s1,48(a5)
  pop_off();
    8000108e:	00005097          	auipc	ra,0x5
    80001092:	478080e7          	jalr	1144(ra) # 80006506 <pop_off>
  return p;
}
    80001096:	8526                	mv	a0,s1
    80001098:	60e2                	ld	ra,24(sp)
    8000109a:	6442                	ld	s0,16(sp)
    8000109c:	64a2                	ld	s1,8(sp)
    8000109e:	6105                	addi	sp,sp,32
    800010a0:	8082                	ret

00000000800010a2 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    800010a2:	1141                	addi	sp,sp,-16
    800010a4:	e406                	sd	ra,8(sp)
    800010a6:	e022                	sd	s0,0(sp)
    800010a8:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    800010aa:	00000097          	auipc	ra,0x0
    800010ae:	fc0080e7          	jalr	-64(ra) # 8000106a <myproc>
    800010b2:	00005097          	auipc	ra,0x5
    800010b6:	4b0080e7          	jalr	1200(ra) # 80006562 <release>

  if (first) {
    800010ba:	00007797          	auipc	a5,0x7
    800010be:	7867a783          	lw	a5,1926(a5) # 80008840 <first.1>
    800010c2:	eb89                	bnez	a5,800010d4 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    800010c4:	00001097          	auipc	ra,0x1
    800010c8:	c14080e7          	jalr	-1004(ra) # 80001cd8 <usertrapret>
}
    800010cc:	60a2                	ld	ra,8(sp)
    800010ce:	6402                	ld	s0,0(sp)
    800010d0:	0141                	addi	sp,sp,16
    800010d2:	8082                	ret
    first = 0;
    800010d4:	00007797          	auipc	a5,0x7
    800010d8:	7607a623          	sw	zero,1900(a5) # 80008840 <first.1>
    fsinit(ROOTDEV);
    800010dc:	4505                	li	a0,1
    800010de:	00002097          	auipc	ra,0x2
    800010e2:	a2a080e7          	jalr	-1494(ra) # 80002b08 <fsinit>
    800010e6:	bff9                	j	800010c4 <forkret+0x22>

00000000800010e8 <allocpid>:
allocpid() {
    800010e8:	1101                	addi	sp,sp,-32
    800010ea:	ec06                	sd	ra,24(sp)
    800010ec:	e822                	sd	s0,16(sp)
    800010ee:	e426                	sd	s1,8(sp)
    800010f0:	e04a                	sd	s2,0(sp)
    800010f2:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    800010f4:	00228917          	auipc	s2,0x228
    800010f8:	f7490913          	addi	s2,s2,-140 # 80229068 <pid_lock>
    800010fc:	854a                	mv	a0,s2
    800010fe:	00005097          	auipc	ra,0x5
    80001102:	3b4080e7          	jalr	948(ra) # 800064b2 <acquire>
  pid = nextpid;
    80001106:	00007797          	auipc	a5,0x7
    8000110a:	73e78793          	addi	a5,a5,1854 # 80008844 <nextpid>
    8000110e:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001110:	0014871b          	addiw	a4,s1,1
    80001114:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001116:	854a                	mv	a0,s2
    80001118:	00005097          	auipc	ra,0x5
    8000111c:	44a080e7          	jalr	1098(ra) # 80006562 <release>
}
    80001120:	8526                	mv	a0,s1
    80001122:	60e2                	ld	ra,24(sp)
    80001124:	6442                	ld	s0,16(sp)
    80001126:	64a2                	ld	s1,8(sp)
    80001128:	6902                	ld	s2,0(sp)
    8000112a:	6105                	addi	sp,sp,32
    8000112c:	8082                	ret

000000008000112e <proc_pagetable>:
{
    8000112e:	1101                	addi	sp,sp,-32
    80001130:	ec06                	sd	ra,24(sp)
    80001132:	e822                	sd	s0,16(sp)
    80001134:	e426                	sd	s1,8(sp)
    80001136:	e04a                	sd	s2,0(sp)
    80001138:	1000                	addi	s0,sp,32
    8000113a:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    8000113c:	fffff097          	auipc	ra,0xfffff
    80001140:	77e080e7          	jalr	1918(ra) # 800008ba <uvmcreate>
    80001144:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001146:	c121                	beqz	a0,80001186 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001148:	4729                	li	a4,10
    8000114a:	00006697          	auipc	a3,0x6
    8000114e:	eb668693          	addi	a3,a3,-330 # 80007000 <_trampoline>
    80001152:	6605                	lui	a2,0x1
    80001154:	040005b7          	lui	a1,0x4000
    80001158:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000115a:	05b2                	slli	a1,a1,0xc
    8000115c:	fffff097          	auipc	ra,0xfffff
    80001160:	4c4080e7          	jalr	1220(ra) # 80000620 <mappages>
    80001164:	02054863          	bltz	a0,80001194 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001168:	4719                	li	a4,6
    8000116a:	05893683          	ld	a3,88(s2)
    8000116e:	6605                	lui	a2,0x1
    80001170:	020005b7          	lui	a1,0x2000
    80001174:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001176:	05b6                	slli	a1,a1,0xd
    80001178:	8526                	mv	a0,s1
    8000117a:	fffff097          	auipc	ra,0xfffff
    8000117e:	4a6080e7          	jalr	1190(ra) # 80000620 <mappages>
    80001182:	02054163          	bltz	a0,800011a4 <proc_pagetable+0x76>
}
    80001186:	8526                	mv	a0,s1
    80001188:	60e2                	ld	ra,24(sp)
    8000118a:	6442                	ld	s0,16(sp)
    8000118c:	64a2                	ld	s1,8(sp)
    8000118e:	6902                	ld	s2,0(sp)
    80001190:	6105                	addi	sp,sp,32
    80001192:	8082                	ret
    uvmfree(pagetable, 0);
    80001194:	4581                	li	a1,0
    80001196:	8526                	mv	a0,s1
    80001198:	00000097          	auipc	ra,0x0
    8000119c:	93a080e7          	jalr	-1734(ra) # 80000ad2 <uvmfree>
    return 0;
    800011a0:	4481                	li	s1,0
    800011a2:	b7d5                	j	80001186 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800011a4:	4681                	li	a3,0
    800011a6:	4605                	li	a2,1
    800011a8:	040005b7          	lui	a1,0x4000
    800011ac:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800011ae:	05b2                	slli	a1,a1,0xc
    800011b0:	8526                	mv	a0,s1
    800011b2:	fffff097          	auipc	ra,0xfffff
    800011b6:	634080e7          	jalr	1588(ra) # 800007e6 <uvmunmap>
    uvmfree(pagetable, 0);
    800011ba:	4581                	li	a1,0
    800011bc:	8526                	mv	a0,s1
    800011be:	00000097          	auipc	ra,0x0
    800011c2:	914080e7          	jalr	-1772(ra) # 80000ad2 <uvmfree>
    return 0;
    800011c6:	4481                	li	s1,0
    800011c8:	bf7d                	j	80001186 <proc_pagetable+0x58>

00000000800011ca <proc_freepagetable>:
{
    800011ca:	1101                	addi	sp,sp,-32
    800011cc:	ec06                	sd	ra,24(sp)
    800011ce:	e822                	sd	s0,16(sp)
    800011d0:	e426                	sd	s1,8(sp)
    800011d2:	e04a                	sd	s2,0(sp)
    800011d4:	1000                	addi	s0,sp,32
    800011d6:	84aa                	mv	s1,a0
    800011d8:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800011da:	4681                	li	a3,0
    800011dc:	4605                	li	a2,1
    800011de:	040005b7          	lui	a1,0x4000
    800011e2:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800011e4:	05b2                	slli	a1,a1,0xc
    800011e6:	fffff097          	auipc	ra,0xfffff
    800011ea:	600080e7          	jalr	1536(ra) # 800007e6 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    800011ee:	4681                	li	a3,0
    800011f0:	4605                	li	a2,1
    800011f2:	020005b7          	lui	a1,0x2000
    800011f6:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    800011f8:	05b6                	slli	a1,a1,0xd
    800011fa:	8526                	mv	a0,s1
    800011fc:	fffff097          	auipc	ra,0xfffff
    80001200:	5ea080e7          	jalr	1514(ra) # 800007e6 <uvmunmap>
  uvmfree(pagetable, sz);
    80001204:	85ca                	mv	a1,s2
    80001206:	8526                	mv	a0,s1
    80001208:	00000097          	auipc	ra,0x0
    8000120c:	8ca080e7          	jalr	-1846(ra) # 80000ad2 <uvmfree>
}
    80001210:	60e2                	ld	ra,24(sp)
    80001212:	6442                	ld	s0,16(sp)
    80001214:	64a2                	ld	s1,8(sp)
    80001216:	6902                	ld	s2,0(sp)
    80001218:	6105                	addi	sp,sp,32
    8000121a:	8082                	ret

000000008000121c <freeproc>:
{
    8000121c:	1101                	addi	sp,sp,-32
    8000121e:	ec06                	sd	ra,24(sp)
    80001220:	e822                	sd	s0,16(sp)
    80001222:	e426                	sd	s1,8(sp)
    80001224:	1000                	addi	s0,sp,32
    80001226:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001228:	6d28                	ld	a0,88(a0)
    8000122a:	c509                	beqz	a0,80001234 <freeproc+0x18>
    kfree((void*)p->trapframe);
    8000122c:	fffff097          	auipc	ra,0xfffff
    80001230:	df0080e7          	jalr	-528(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001234:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001238:	68a8                	ld	a0,80(s1)
    8000123a:	c511                	beqz	a0,80001246 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    8000123c:	64ac                	ld	a1,72(s1)
    8000123e:	00000097          	auipc	ra,0x0
    80001242:	f8c080e7          	jalr	-116(ra) # 800011ca <proc_freepagetable>
  p->pagetable = 0;
    80001246:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    8000124a:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    8000124e:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001252:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001256:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    8000125a:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    8000125e:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001262:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001266:	0004ac23          	sw	zero,24(s1)
}
    8000126a:	60e2                	ld	ra,24(sp)
    8000126c:	6442                	ld	s0,16(sp)
    8000126e:	64a2                	ld	s1,8(sp)
    80001270:	6105                	addi	sp,sp,32
    80001272:	8082                	ret

0000000080001274 <allocproc>:
{
    80001274:	1101                	addi	sp,sp,-32
    80001276:	ec06                	sd	ra,24(sp)
    80001278:	e822                	sd	s0,16(sp)
    8000127a:	e426                	sd	s1,8(sp)
    8000127c:	e04a                	sd	s2,0(sp)
    8000127e:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001280:	00228497          	auipc	s1,0x228
    80001284:	21848493          	addi	s1,s1,536 # 80229498 <proc>
    80001288:	0022e917          	auipc	s2,0x22e
    8000128c:	c1090913          	addi	s2,s2,-1008 # 8022ee98 <tickslock>
    acquire(&p->lock);
    80001290:	8526                	mv	a0,s1
    80001292:	00005097          	auipc	ra,0x5
    80001296:	220080e7          	jalr	544(ra) # 800064b2 <acquire>
    if(p->state == UNUSED) {
    8000129a:	4c9c                	lw	a5,24(s1)
    8000129c:	cf81                	beqz	a5,800012b4 <allocproc+0x40>
      release(&p->lock);
    8000129e:	8526                	mv	a0,s1
    800012a0:	00005097          	auipc	ra,0x5
    800012a4:	2c2080e7          	jalr	706(ra) # 80006562 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800012a8:	16848493          	addi	s1,s1,360
    800012ac:	ff2492e3          	bne	s1,s2,80001290 <allocproc+0x1c>
  return 0;
    800012b0:	4481                	li	s1,0
    800012b2:	a889                	j	80001304 <allocproc+0x90>
  p->pid = allocpid();
    800012b4:	00000097          	auipc	ra,0x0
    800012b8:	e34080e7          	jalr	-460(ra) # 800010e8 <allocpid>
    800012bc:	d888                	sw	a0,48(s1)
  p->state = USED;
    800012be:	4785                	li	a5,1
    800012c0:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800012c2:	fffff097          	auipc	ra,0xfffff
    800012c6:	ed8080e7          	jalr	-296(ra) # 8000019a <kalloc>
    800012ca:	892a                	mv	s2,a0
    800012cc:	eca8                	sd	a0,88(s1)
    800012ce:	c131                	beqz	a0,80001312 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800012d0:	8526                	mv	a0,s1
    800012d2:	00000097          	auipc	ra,0x0
    800012d6:	e5c080e7          	jalr	-420(ra) # 8000112e <proc_pagetable>
    800012da:	892a                	mv	s2,a0
    800012dc:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800012de:	c531                	beqz	a0,8000132a <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    800012e0:	07000613          	li	a2,112
    800012e4:	4581                	li	a1,0
    800012e6:	06048513          	addi	a0,s1,96
    800012ea:	fffff097          	auipc	ra,0xfffff
    800012ee:	f56080e7          	jalr	-170(ra) # 80000240 <memset>
  p->context.ra = (uint64)forkret;
    800012f2:	00000797          	auipc	a5,0x0
    800012f6:	db078793          	addi	a5,a5,-592 # 800010a2 <forkret>
    800012fa:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800012fc:	60bc                	ld	a5,64(s1)
    800012fe:	6705                	lui	a4,0x1
    80001300:	97ba                	add	a5,a5,a4
    80001302:	f4bc                	sd	a5,104(s1)
}
    80001304:	8526                	mv	a0,s1
    80001306:	60e2                	ld	ra,24(sp)
    80001308:	6442                	ld	s0,16(sp)
    8000130a:	64a2                	ld	s1,8(sp)
    8000130c:	6902                	ld	s2,0(sp)
    8000130e:	6105                	addi	sp,sp,32
    80001310:	8082                	ret
    freeproc(p);
    80001312:	8526                	mv	a0,s1
    80001314:	00000097          	auipc	ra,0x0
    80001318:	f08080e7          	jalr	-248(ra) # 8000121c <freeproc>
    release(&p->lock);
    8000131c:	8526                	mv	a0,s1
    8000131e:	00005097          	auipc	ra,0x5
    80001322:	244080e7          	jalr	580(ra) # 80006562 <release>
    return 0;
    80001326:	84ca                	mv	s1,s2
    80001328:	bff1                	j	80001304 <allocproc+0x90>
    freeproc(p);
    8000132a:	8526                	mv	a0,s1
    8000132c:	00000097          	auipc	ra,0x0
    80001330:	ef0080e7          	jalr	-272(ra) # 8000121c <freeproc>
    release(&p->lock);
    80001334:	8526                	mv	a0,s1
    80001336:	00005097          	auipc	ra,0x5
    8000133a:	22c080e7          	jalr	556(ra) # 80006562 <release>
    return 0;
    8000133e:	84ca                	mv	s1,s2
    80001340:	b7d1                	j	80001304 <allocproc+0x90>

0000000080001342 <userinit>:
{
    80001342:	1101                	addi	sp,sp,-32
    80001344:	ec06                	sd	ra,24(sp)
    80001346:	e822                	sd	s0,16(sp)
    80001348:	e426                	sd	s1,8(sp)
    8000134a:	1000                	addi	s0,sp,32
  p = allocproc();
    8000134c:	00000097          	auipc	ra,0x0
    80001350:	f28080e7          	jalr	-216(ra) # 80001274 <allocproc>
    80001354:	84aa                	mv	s1,a0
  initproc = p;
    80001356:	00008797          	auipc	a5,0x8
    8000135a:	caa7bd23          	sd	a0,-838(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    8000135e:	03400613          	li	a2,52
    80001362:	00007597          	auipc	a1,0x7
    80001366:	4ee58593          	addi	a1,a1,1262 # 80008850 <initcode>
    8000136a:	6928                	ld	a0,80(a0)
    8000136c:	fffff097          	auipc	ra,0xfffff
    80001370:	57c080e7          	jalr	1404(ra) # 800008e8 <uvminit>
  p->sz = PGSIZE;
    80001374:	6785                	lui	a5,0x1
    80001376:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001378:	6cb8                	ld	a4,88(s1)
    8000137a:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    8000137e:	6cb8                	ld	a4,88(s1)
    80001380:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001382:	4641                	li	a2,16
    80001384:	00007597          	auipc	a1,0x7
    80001388:	e2458593          	addi	a1,a1,-476 # 800081a8 <etext+0x1a8>
    8000138c:	15848513          	addi	a0,s1,344
    80001390:	fffff097          	auipc	ra,0xfffff
    80001394:	006080e7          	jalr	6(ra) # 80000396 <safestrcpy>
  p->cwd = namei("/");
    80001398:	00007517          	auipc	a0,0x7
    8000139c:	e2050513          	addi	a0,a0,-480 # 800081b8 <etext+0x1b8>
    800013a0:	00002097          	auipc	ra,0x2
    800013a4:	1c8080e7          	jalr	456(ra) # 80003568 <namei>
    800013a8:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800013ac:	478d                	li	a5,3
    800013ae:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800013b0:	8526                	mv	a0,s1
    800013b2:	00005097          	auipc	ra,0x5
    800013b6:	1b0080e7          	jalr	432(ra) # 80006562 <release>
}
    800013ba:	60e2                	ld	ra,24(sp)
    800013bc:	6442                	ld	s0,16(sp)
    800013be:	64a2                	ld	s1,8(sp)
    800013c0:	6105                	addi	sp,sp,32
    800013c2:	8082                	ret

00000000800013c4 <growproc>:
{
    800013c4:	1101                	addi	sp,sp,-32
    800013c6:	ec06                	sd	ra,24(sp)
    800013c8:	e822                	sd	s0,16(sp)
    800013ca:	e426                	sd	s1,8(sp)
    800013cc:	e04a                	sd	s2,0(sp)
    800013ce:	1000                	addi	s0,sp,32
    800013d0:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800013d2:	00000097          	auipc	ra,0x0
    800013d6:	c98080e7          	jalr	-872(ra) # 8000106a <myproc>
    800013da:	892a                	mv	s2,a0
  sz = p->sz;
    800013dc:	652c                	ld	a1,72(a0)
    800013de:	0005879b          	sext.w	a5,a1
  if(n > 0){
    800013e2:	00904f63          	bgtz	s1,80001400 <growproc+0x3c>
  } else if(n < 0){
    800013e6:	0204cd63          	bltz	s1,80001420 <growproc+0x5c>
  p->sz = sz;
    800013ea:	1782                	slli	a5,a5,0x20
    800013ec:	9381                	srli	a5,a5,0x20
    800013ee:	04f93423          	sd	a5,72(s2)
  return 0;
    800013f2:	4501                	li	a0,0
}
    800013f4:	60e2                	ld	ra,24(sp)
    800013f6:	6442                	ld	s0,16(sp)
    800013f8:	64a2                	ld	s1,8(sp)
    800013fa:	6902                	ld	s2,0(sp)
    800013fc:	6105                	addi	sp,sp,32
    800013fe:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001400:	00f4863b          	addw	a2,s1,a5
    80001404:	1602                	slli	a2,a2,0x20
    80001406:	9201                	srli	a2,a2,0x20
    80001408:	1582                	slli	a1,a1,0x20
    8000140a:	9181                	srli	a1,a1,0x20
    8000140c:	6928                	ld	a0,80(a0)
    8000140e:	fffff097          	auipc	ra,0xfffff
    80001412:	594080e7          	jalr	1428(ra) # 800009a2 <uvmalloc>
    80001416:	0005079b          	sext.w	a5,a0
    8000141a:	fbe1                	bnez	a5,800013ea <growproc+0x26>
      return -1;
    8000141c:	557d                	li	a0,-1
    8000141e:	bfd9                	j	800013f4 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001420:	00f4863b          	addw	a2,s1,a5
    80001424:	1602                	slli	a2,a2,0x20
    80001426:	9201                	srli	a2,a2,0x20
    80001428:	1582                	slli	a1,a1,0x20
    8000142a:	9181                	srli	a1,a1,0x20
    8000142c:	6928                	ld	a0,80(a0)
    8000142e:	fffff097          	auipc	ra,0xfffff
    80001432:	52c080e7          	jalr	1324(ra) # 8000095a <uvmdealloc>
    80001436:	0005079b          	sext.w	a5,a0
    8000143a:	bf45                	j	800013ea <growproc+0x26>

000000008000143c <fork>:
{
    8000143c:	7139                	addi	sp,sp,-64
    8000143e:	fc06                	sd	ra,56(sp)
    80001440:	f822                	sd	s0,48(sp)
    80001442:	f04a                	sd	s2,32(sp)
    80001444:	e456                	sd	s5,8(sp)
    80001446:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001448:	00000097          	auipc	ra,0x0
    8000144c:	c22080e7          	jalr	-990(ra) # 8000106a <myproc>
    80001450:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001452:	00000097          	auipc	ra,0x0
    80001456:	e22080e7          	jalr	-478(ra) # 80001274 <allocproc>
    8000145a:	12050063          	beqz	a0,8000157a <fork+0x13e>
    8000145e:	e852                	sd	s4,16(sp)
    80001460:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001462:	048ab603          	ld	a2,72(s5)
    80001466:	692c                	ld	a1,80(a0)
    80001468:	050ab503          	ld	a0,80(s5)
    8000146c:	fffff097          	auipc	ra,0xfffff
    80001470:	6a0080e7          	jalr	1696(ra) # 80000b0c <uvmcopy>
    80001474:	04054a63          	bltz	a0,800014c8 <fork+0x8c>
    80001478:	f426                	sd	s1,40(sp)
    8000147a:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    8000147c:	048ab783          	ld	a5,72(s5)
    80001480:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001484:	058ab683          	ld	a3,88(s5)
    80001488:	87b6                	mv	a5,a3
    8000148a:	058a3703          	ld	a4,88(s4)
    8000148e:	12068693          	addi	a3,a3,288
    80001492:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001496:	6788                	ld	a0,8(a5)
    80001498:	6b8c                	ld	a1,16(a5)
    8000149a:	6f90                	ld	a2,24(a5)
    8000149c:	01073023          	sd	a6,0(a4)
    800014a0:	e708                	sd	a0,8(a4)
    800014a2:	eb0c                	sd	a1,16(a4)
    800014a4:	ef10                	sd	a2,24(a4)
    800014a6:	02078793          	addi	a5,a5,32
    800014aa:	02070713          	addi	a4,a4,32
    800014ae:	fed792e3          	bne	a5,a3,80001492 <fork+0x56>
  np->trapframe->a0 = 0;
    800014b2:	058a3783          	ld	a5,88(s4)
    800014b6:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800014ba:	0d0a8493          	addi	s1,s5,208
    800014be:	0d0a0913          	addi	s2,s4,208
    800014c2:	150a8993          	addi	s3,s5,336
    800014c6:	a015                	j	800014ea <fork+0xae>
    freeproc(np);
    800014c8:	8552                	mv	a0,s4
    800014ca:	00000097          	auipc	ra,0x0
    800014ce:	d52080e7          	jalr	-686(ra) # 8000121c <freeproc>
    release(&np->lock);
    800014d2:	8552                	mv	a0,s4
    800014d4:	00005097          	auipc	ra,0x5
    800014d8:	08e080e7          	jalr	142(ra) # 80006562 <release>
    return -1;
    800014dc:	597d                	li	s2,-1
    800014de:	6a42                	ld	s4,16(sp)
    800014e0:	a071                	j	8000156c <fork+0x130>
  for(i = 0; i < NOFILE; i++)
    800014e2:	04a1                	addi	s1,s1,8
    800014e4:	0921                	addi	s2,s2,8
    800014e6:	01348b63          	beq	s1,s3,800014fc <fork+0xc0>
    if(p->ofile[i])
    800014ea:	6088                	ld	a0,0(s1)
    800014ec:	d97d                	beqz	a0,800014e2 <fork+0xa6>
      np->ofile[i] = filedup(p->ofile[i]);
    800014ee:	00002097          	auipc	ra,0x2
    800014f2:	6fe080e7          	jalr	1790(ra) # 80003bec <filedup>
    800014f6:	00a93023          	sd	a0,0(s2)
    800014fa:	b7e5                	j	800014e2 <fork+0xa6>
  np->cwd = idup(p->cwd);
    800014fc:	150ab503          	ld	a0,336(s5)
    80001500:	00002097          	auipc	ra,0x2
    80001504:	83e080e7          	jalr	-1986(ra) # 80002d3e <idup>
    80001508:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    8000150c:	4641                	li	a2,16
    8000150e:	158a8593          	addi	a1,s5,344
    80001512:	158a0513          	addi	a0,s4,344
    80001516:	fffff097          	auipc	ra,0xfffff
    8000151a:	e80080e7          	jalr	-384(ra) # 80000396 <safestrcpy>
  pid = np->pid;
    8000151e:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001522:	8552                	mv	a0,s4
    80001524:	00005097          	auipc	ra,0x5
    80001528:	03e080e7          	jalr	62(ra) # 80006562 <release>
  acquire(&wait_lock);
    8000152c:	00228497          	auipc	s1,0x228
    80001530:	b5448493          	addi	s1,s1,-1196 # 80229080 <wait_lock>
    80001534:	8526                	mv	a0,s1
    80001536:	00005097          	auipc	ra,0x5
    8000153a:	f7c080e7          	jalr	-132(ra) # 800064b2 <acquire>
  np->parent = p;
    8000153e:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001542:	8526                	mv	a0,s1
    80001544:	00005097          	auipc	ra,0x5
    80001548:	01e080e7          	jalr	30(ra) # 80006562 <release>
  acquire(&np->lock);
    8000154c:	8552                	mv	a0,s4
    8000154e:	00005097          	auipc	ra,0x5
    80001552:	f64080e7          	jalr	-156(ra) # 800064b2 <acquire>
  np->state = RUNNABLE;
    80001556:	478d                	li	a5,3
    80001558:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    8000155c:	8552                	mv	a0,s4
    8000155e:	00005097          	auipc	ra,0x5
    80001562:	004080e7          	jalr	4(ra) # 80006562 <release>
  return pid;
    80001566:	74a2                	ld	s1,40(sp)
    80001568:	69e2                	ld	s3,24(sp)
    8000156a:	6a42                	ld	s4,16(sp)
}
    8000156c:	854a                	mv	a0,s2
    8000156e:	70e2                	ld	ra,56(sp)
    80001570:	7442                	ld	s0,48(sp)
    80001572:	7902                	ld	s2,32(sp)
    80001574:	6aa2                	ld	s5,8(sp)
    80001576:	6121                	addi	sp,sp,64
    80001578:	8082                	ret
    return -1;
    8000157a:	597d                	li	s2,-1
    8000157c:	bfc5                	j	8000156c <fork+0x130>

000000008000157e <scheduler>:
{
    8000157e:	7139                	addi	sp,sp,-64
    80001580:	fc06                	sd	ra,56(sp)
    80001582:	f822                	sd	s0,48(sp)
    80001584:	f426                	sd	s1,40(sp)
    80001586:	f04a                	sd	s2,32(sp)
    80001588:	ec4e                	sd	s3,24(sp)
    8000158a:	e852                	sd	s4,16(sp)
    8000158c:	e456                	sd	s5,8(sp)
    8000158e:	e05a                	sd	s6,0(sp)
    80001590:	0080                	addi	s0,sp,64
    80001592:	8792                	mv	a5,tp
  int id = r_tp();
    80001594:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001596:	00779a93          	slli	s5,a5,0x7
    8000159a:	00228717          	auipc	a4,0x228
    8000159e:	ace70713          	addi	a4,a4,-1330 # 80229068 <pid_lock>
    800015a2:	9756                	add	a4,a4,s5
    800015a4:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800015a8:	00228717          	auipc	a4,0x228
    800015ac:	af870713          	addi	a4,a4,-1288 # 802290a0 <cpus+0x8>
    800015b0:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800015b2:	498d                	li	s3,3
        p->state = RUNNING;
    800015b4:	4b11                	li	s6,4
        c->proc = p;
    800015b6:	079e                	slli	a5,a5,0x7
    800015b8:	00228a17          	auipc	s4,0x228
    800015bc:	ab0a0a13          	addi	s4,s4,-1360 # 80229068 <pid_lock>
    800015c0:	9a3e                	add	s4,s4,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800015c2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800015c6:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800015ca:	10079073          	csrw	sstatus,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800015ce:	00228497          	auipc	s1,0x228
    800015d2:	eca48493          	addi	s1,s1,-310 # 80229498 <proc>
    800015d6:	0022e917          	auipc	s2,0x22e
    800015da:	8c290913          	addi	s2,s2,-1854 # 8022ee98 <tickslock>
    800015de:	a811                	j	800015f2 <scheduler+0x74>
      release(&p->lock);
    800015e0:	8526                	mv	a0,s1
    800015e2:	00005097          	auipc	ra,0x5
    800015e6:	f80080e7          	jalr	-128(ra) # 80006562 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800015ea:	16848493          	addi	s1,s1,360
    800015ee:	fd248ae3          	beq	s1,s2,800015c2 <scheduler+0x44>
      acquire(&p->lock);
    800015f2:	8526                	mv	a0,s1
    800015f4:	00005097          	auipc	ra,0x5
    800015f8:	ebe080e7          	jalr	-322(ra) # 800064b2 <acquire>
      if(p->state == RUNNABLE) {
    800015fc:	4c9c                	lw	a5,24(s1)
    800015fe:	ff3791e3          	bne	a5,s3,800015e0 <scheduler+0x62>
        p->state = RUNNING;
    80001602:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001606:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    8000160a:	06048593          	addi	a1,s1,96
    8000160e:	8556                	mv	a0,s5
    80001610:	00000097          	auipc	ra,0x0
    80001614:	61a080e7          	jalr	1562(ra) # 80001c2a <swtch>
        c->proc = 0;
    80001618:	020a3823          	sd	zero,48(s4)
    8000161c:	b7d1                	j	800015e0 <scheduler+0x62>

000000008000161e <sched>:
{
    8000161e:	7179                	addi	sp,sp,-48
    80001620:	f406                	sd	ra,40(sp)
    80001622:	f022                	sd	s0,32(sp)
    80001624:	ec26                	sd	s1,24(sp)
    80001626:	e84a                	sd	s2,16(sp)
    80001628:	e44e                	sd	s3,8(sp)
    8000162a:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000162c:	00000097          	auipc	ra,0x0
    80001630:	a3e080e7          	jalr	-1474(ra) # 8000106a <myproc>
    80001634:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001636:	00005097          	auipc	ra,0x5
    8000163a:	e02080e7          	jalr	-510(ra) # 80006438 <holding>
    8000163e:	c93d                	beqz	a0,800016b4 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001640:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001642:	2781                	sext.w	a5,a5
    80001644:	079e                	slli	a5,a5,0x7
    80001646:	00228717          	auipc	a4,0x228
    8000164a:	a2270713          	addi	a4,a4,-1502 # 80229068 <pid_lock>
    8000164e:	97ba                	add	a5,a5,a4
    80001650:	0a87a703          	lw	a4,168(a5)
    80001654:	4785                	li	a5,1
    80001656:	06f71763          	bne	a4,a5,800016c4 <sched+0xa6>
  if(p->state == RUNNING)
    8000165a:	4c98                	lw	a4,24(s1)
    8000165c:	4791                	li	a5,4
    8000165e:	06f70b63          	beq	a4,a5,800016d4 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001662:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001666:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001668:	efb5                	bnez	a5,800016e4 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000166a:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000166c:	00228917          	auipc	s2,0x228
    80001670:	9fc90913          	addi	s2,s2,-1540 # 80229068 <pid_lock>
    80001674:	2781                	sext.w	a5,a5
    80001676:	079e                	slli	a5,a5,0x7
    80001678:	97ca                	add	a5,a5,s2
    8000167a:	0ac7a983          	lw	s3,172(a5)
    8000167e:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001680:	2781                	sext.w	a5,a5
    80001682:	079e                	slli	a5,a5,0x7
    80001684:	00228597          	auipc	a1,0x228
    80001688:	a1c58593          	addi	a1,a1,-1508 # 802290a0 <cpus+0x8>
    8000168c:	95be                	add	a1,a1,a5
    8000168e:	06048513          	addi	a0,s1,96
    80001692:	00000097          	auipc	ra,0x0
    80001696:	598080e7          	jalr	1432(ra) # 80001c2a <swtch>
    8000169a:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    8000169c:	2781                	sext.w	a5,a5
    8000169e:	079e                	slli	a5,a5,0x7
    800016a0:	993e                	add	s2,s2,a5
    800016a2:	0b392623          	sw	s3,172(s2)
}
    800016a6:	70a2                	ld	ra,40(sp)
    800016a8:	7402                	ld	s0,32(sp)
    800016aa:	64e2                	ld	s1,24(sp)
    800016ac:	6942                	ld	s2,16(sp)
    800016ae:	69a2                	ld	s3,8(sp)
    800016b0:	6145                	addi	sp,sp,48
    800016b2:	8082                	ret
    panic("sched p->lock");
    800016b4:	00007517          	auipc	a0,0x7
    800016b8:	b0c50513          	addi	a0,a0,-1268 # 800081c0 <etext+0x1c0>
    800016bc:	00005097          	auipc	ra,0x5
    800016c0:	876080e7          	jalr	-1930(ra) # 80005f32 <panic>
    panic("sched locks");
    800016c4:	00007517          	auipc	a0,0x7
    800016c8:	b0c50513          	addi	a0,a0,-1268 # 800081d0 <etext+0x1d0>
    800016cc:	00005097          	auipc	ra,0x5
    800016d0:	866080e7          	jalr	-1946(ra) # 80005f32 <panic>
    panic("sched running");
    800016d4:	00007517          	auipc	a0,0x7
    800016d8:	b0c50513          	addi	a0,a0,-1268 # 800081e0 <etext+0x1e0>
    800016dc:	00005097          	auipc	ra,0x5
    800016e0:	856080e7          	jalr	-1962(ra) # 80005f32 <panic>
    panic("sched interruptible");
    800016e4:	00007517          	auipc	a0,0x7
    800016e8:	b0c50513          	addi	a0,a0,-1268 # 800081f0 <etext+0x1f0>
    800016ec:	00005097          	auipc	ra,0x5
    800016f0:	846080e7          	jalr	-1978(ra) # 80005f32 <panic>

00000000800016f4 <yield>:
{
    800016f4:	1101                	addi	sp,sp,-32
    800016f6:	ec06                	sd	ra,24(sp)
    800016f8:	e822                	sd	s0,16(sp)
    800016fa:	e426                	sd	s1,8(sp)
    800016fc:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800016fe:	00000097          	auipc	ra,0x0
    80001702:	96c080e7          	jalr	-1684(ra) # 8000106a <myproc>
    80001706:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001708:	00005097          	auipc	ra,0x5
    8000170c:	daa080e7          	jalr	-598(ra) # 800064b2 <acquire>
  p->state = RUNNABLE;
    80001710:	478d                	li	a5,3
    80001712:	cc9c                	sw	a5,24(s1)
  sched();
    80001714:	00000097          	auipc	ra,0x0
    80001718:	f0a080e7          	jalr	-246(ra) # 8000161e <sched>
  release(&p->lock);
    8000171c:	8526                	mv	a0,s1
    8000171e:	00005097          	auipc	ra,0x5
    80001722:	e44080e7          	jalr	-444(ra) # 80006562 <release>
}
    80001726:	60e2                	ld	ra,24(sp)
    80001728:	6442                	ld	s0,16(sp)
    8000172a:	64a2                	ld	s1,8(sp)
    8000172c:	6105                	addi	sp,sp,32
    8000172e:	8082                	ret

0000000080001730 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001730:	7179                	addi	sp,sp,-48
    80001732:	f406                	sd	ra,40(sp)
    80001734:	f022                	sd	s0,32(sp)
    80001736:	ec26                	sd	s1,24(sp)
    80001738:	e84a                	sd	s2,16(sp)
    8000173a:	e44e                	sd	s3,8(sp)
    8000173c:	1800                	addi	s0,sp,48
    8000173e:	89aa                	mv	s3,a0
    80001740:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001742:	00000097          	auipc	ra,0x0
    80001746:	928080e7          	jalr	-1752(ra) # 8000106a <myproc>
    8000174a:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    8000174c:	00005097          	auipc	ra,0x5
    80001750:	d66080e7          	jalr	-666(ra) # 800064b2 <acquire>
  release(lk);
    80001754:	854a                	mv	a0,s2
    80001756:	00005097          	auipc	ra,0x5
    8000175a:	e0c080e7          	jalr	-500(ra) # 80006562 <release>

  // Go to sleep.
  p->chan = chan;
    8000175e:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001762:	4789                	li	a5,2
    80001764:	cc9c                	sw	a5,24(s1)

  sched();
    80001766:	00000097          	auipc	ra,0x0
    8000176a:	eb8080e7          	jalr	-328(ra) # 8000161e <sched>

  // Tidy up.
  p->chan = 0;
    8000176e:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001772:	8526                	mv	a0,s1
    80001774:	00005097          	auipc	ra,0x5
    80001778:	dee080e7          	jalr	-530(ra) # 80006562 <release>
  acquire(lk);
    8000177c:	854a                	mv	a0,s2
    8000177e:	00005097          	auipc	ra,0x5
    80001782:	d34080e7          	jalr	-716(ra) # 800064b2 <acquire>
}
    80001786:	70a2                	ld	ra,40(sp)
    80001788:	7402                	ld	s0,32(sp)
    8000178a:	64e2                	ld	s1,24(sp)
    8000178c:	6942                	ld	s2,16(sp)
    8000178e:	69a2                	ld	s3,8(sp)
    80001790:	6145                	addi	sp,sp,48
    80001792:	8082                	ret

0000000080001794 <wait>:
{
    80001794:	715d                	addi	sp,sp,-80
    80001796:	e486                	sd	ra,72(sp)
    80001798:	e0a2                	sd	s0,64(sp)
    8000179a:	fc26                	sd	s1,56(sp)
    8000179c:	f84a                	sd	s2,48(sp)
    8000179e:	f44e                	sd	s3,40(sp)
    800017a0:	f052                	sd	s4,32(sp)
    800017a2:	ec56                	sd	s5,24(sp)
    800017a4:	e85a                	sd	s6,16(sp)
    800017a6:	e45e                	sd	s7,8(sp)
    800017a8:	0880                	addi	s0,sp,80
    800017aa:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800017ac:	00000097          	auipc	ra,0x0
    800017b0:	8be080e7          	jalr	-1858(ra) # 8000106a <myproc>
    800017b4:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800017b6:	00228517          	auipc	a0,0x228
    800017ba:	8ca50513          	addi	a0,a0,-1846 # 80229080 <wait_lock>
    800017be:	00005097          	auipc	ra,0x5
    800017c2:	cf4080e7          	jalr	-780(ra) # 800064b2 <acquire>
        if(np->state == ZOMBIE){
    800017c6:	4a15                	li	s4,5
        havekids = 1;
    800017c8:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    800017ca:	0022d997          	auipc	s3,0x22d
    800017ce:	6ce98993          	addi	s3,s3,1742 # 8022ee98 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800017d2:	00228b97          	auipc	s7,0x228
    800017d6:	8aeb8b93          	addi	s7,s7,-1874 # 80229080 <wait_lock>
    800017da:	a875                	j	80001896 <wait+0x102>
          pid = np->pid;
    800017dc:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    800017e0:	000b0e63          	beqz	s6,800017fc <wait+0x68>
    800017e4:	4691                	li	a3,4
    800017e6:	02c48613          	addi	a2,s1,44
    800017ea:	85da                	mv	a1,s6
    800017ec:	05093503          	ld	a0,80(s2)
    800017f0:	fffff097          	auipc	ra,0xfffff
    800017f4:	44c080e7          	jalr	1100(ra) # 80000c3c <copyout>
    800017f8:	04054063          	bltz	a0,80001838 <wait+0xa4>
          freeproc(np);
    800017fc:	8526                	mv	a0,s1
    800017fe:	00000097          	auipc	ra,0x0
    80001802:	a1e080e7          	jalr	-1506(ra) # 8000121c <freeproc>
          release(&np->lock);
    80001806:	8526                	mv	a0,s1
    80001808:	00005097          	auipc	ra,0x5
    8000180c:	d5a080e7          	jalr	-678(ra) # 80006562 <release>
          release(&wait_lock);
    80001810:	00228517          	auipc	a0,0x228
    80001814:	87050513          	addi	a0,a0,-1936 # 80229080 <wait_lock>
    80001818:	00005097          	auipc	ra,0x5
    8000181c:	d4a080e7          	jalr	-694(ra) # 80006562 <release>
}
    80001820:	854e                	mv	a0,s3
    80001822:	60a6                	ld	ra,72(sp)
    80001824:	6406                	ld	s0,64(sp)
    80001826:	74e2                	ld	s1,56(sp)
    80001828:	7942                	ld	s2,48(sp)
    8000182a:	79a2                	ld	s3,40(sp)
    8000182c:	7a02                	ld	s4,32(sp)
    8000182e:	6ae2                	ld	s5,24(sp)
    80001830:	6b42                	ld	s6,16(sp)
    80001832:	6ba2                	ld	s7,8(sp)
    80001834:	6161                	addi	sp,sp,80
    80001836:	8082                	ret
            release(&np->lock);
    80001838:	8526                	mv	a0,s1
    8000183a:	00005097          	auipc	ra,0x5
    8000183e:	d28080e7          	jalr	-728(ra) # 80006562 <release>
            release(&wait_lock);
    80001842:	00228517          	auipc	a0,0x228
    80001846:	83e50513          	addi	a0,a0,-1986 # 80229080 <wait_lock>
    8000184a:	00005097          	auipc	ra,0x5
    8000184e:	d18080e7          	jalr	-744(ra) # 80006562 <release>
            return -1;
    80001852:	59fd                	li	s3,-1
    80001854:	b7f1                	j	80001820 <wait+0x8c>
    for(np = proc; np < &proc[NPROC]; np++){
    80001856:	16848493          	addi	s1,s1,360
    8000185a:	03348463          	beq	s1,s3,80001882 <wait+0xee>
      if(np->parent == p){
    8000185e:	7c9c                	ld	a5,56(s1)
    80001860:	ff279be3          	bne	a5,s2,80001856 <wait+0xc2>
        acquire(&np->lock);
    80001864:	8526                	mv	a0,s1
    80001866:	00005097          	auipc	ra,0x5
    8000186a:	c4c080e7          	jalr	-948(ra) # 800064b2 <acquire>
        if(np->state == ZOMBIE){
    8000186e:	4c9c                	lw	a5,24(s1)
    80001870:	f74786e3          	beq	a5,s4,800017dc <wait+0x48>
        release(&np->lock);
    80001874:	8526                	mv	a0,s1
    80001876:	00005097          	auipc	ra,0x5
    8000187a:	cec080e7          	jalr	-788(ra) # 80006562 <release>
        havekids = 1;
    8000187e:	8756                	mv	a4,s5
    80001880:	bfd9                	j	80001856 <wait+0xc2>
    if(!havekids || p->killed){
    80001882:	c305                	beqz	a4,800018a2 <wait+0x10e>
    80001884:	02892783          	lw	a5,40(s2)
    80001888:	ef89                	bnez	a5,800018a2 <wait+0x10e>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000188a:	85de                	mv	a1,s7
    8000188c:	854a                	mv	a0,s2
    8000188e:	00000097          	auipc	ra,0x0
    80001892:	ea2080e7          	jalr	-350(ra) # 80001730 <sleep>
    havekids = 0;
    80001896:	4701                	li	a4,0
    for(np = proc; np < &proc[NPROC]; np++){
    80001898:	00228497          	auipc	s1,0x228
    8000189c:	c0048493          	addi	s1,s1,-1024 # 80229498 <proc>
    800018a0:	bf7d                	j	8000185e <wait+0xca>
      release(&wait_lock);
    800018a2:	00227517          	auipc	a0,0x227
    800018a6:	7de50513          	addi	a0,a0,2014 # 80229080 <wait_lock>
    800018aa:	00005097          	auipc	ra,0x5
    800018ae:	cb8080e7          	jalr	-840(ra) # 80006562 <release>
      return -1;
    800018b2:	59fd                	li	s3,-1
    800018b4:	b7b5                	j	80001820 <wait+0x8c>

00000000800018b6 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800018b6:	7139                	addi	sp,sp,-64
    800018b8:	fc06                	sd	ra,56(sp)
    800018ba:	f822                	sd	s0,48(sp)
    800018bc:	f426                	sd	s1,40(sp)
    800018be:	f04a                	sd	s2,32(sp)
    800018c0:	ec4e                	sd	s3,24(sp)
    800018c2:	e852                	sd	s4,16(sp)
    800018c4:	e456                	sd	s5,8(sp)
    800018c6:	0080                	addi	s0,sp,64
    800018c8:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800018ca:	00228497          	auipc	s1,0x228
    800018ce:	bce48493          	addi	s1,s1,-1074 # 80229498 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800018d2:	4989                	li	s3,2
        p->state = RUNNABLE;
    800018d4:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800018d6:	0022d917          	auipc	s2,0x22d
    800018da:	5c290913          	addi	s2,s2,1474 # 8022ee98 <tickslock>
    800018de:	a811                	j	800018f2 <wakeup+0x3c>
      }
      release(&p->lock);
    800018e0:	8526                	mv	a0,s1
    800018e2:	00005097          	auipc	ra,0x5
    800018e6:	c80080e7          	jalr	-896(ra) # 80006562 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800018ea:	16848493          	addi	s1,s1,360
    800018ee:	03248663          	beq	s1,s2,8000191a <wakeup+0x64>
    if(p != myproc()){
    800018f2:	fffff097          	auipc	ra,0xfffff
    800018f6:	778080e7          	jalr	1912(ra) # 8000106a <myproc>
    800018fa:	fea488e3          	beq	s1,a0,800018ea <wakeup+0x34>
      acquire(&p->lock);
    800018fe:	8526                	mv	a0,s1
    80001900:	00005097          	auipc	ra,0x5
    80001904:	bb2080e7          	jalr	-1102(ra) # 800064b2 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001908:	4c9c                	lw	a5,24(s1)
    8000190a:	fd379be3          	bne	a5,s3,800018e0 <wakeup+0x2a>
    8000190e:	709c                	ld	a5,32(s1)
    80001910:	fd4798e3          	bne	a5,s4,800018e0 <wakeup+0x2a>
        p->state = RUNNABLE;
    80001914:	0154ac23          	sw	s5,24(s1)
    80001918:	b7e1                	j	800018e0 <wakeup+0x2a>
    }
  }
}
    8000191a:	70e2                	ld	ra,56(sp)
    8000191c:	7442                	ld	s0,48(sp)
    8000191e:	74a2                	ld	s1,40(sp)
    80001920:	7902                	ld	s2,32(sp)
    80001922:	69e2                	ld	s3,24(sp)
    80001924:	6a42                	ld	s4,16(sp)
    80001926:	6aa2                	ld	s5,8(sp)
    80001928:	6121                	addi	sp,sp,64
    8000192a:	8082                	ret

000000008000192c <reparent>:
{
    8000192c:	7179                	addi	sp,sp,-48
    8000192e:	f406                	sd	ra,40(sp)
    80001930:	f022                	sd	s0,32(sp)
    80001932:	ec26                	sd	s1,24(sp)
    80001934:	e84a                	sd	s2,16(sp)
    80001936:	e44e                	sd	s3,8(sp)
    80001938:	e052                	sd	s4,0(sp)
    8000193a:	1800                	addi	s0,sp,48
    8000193c:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000193e:	00228497          	auipc	s1,0x228
    80001942:	b5a48493          	addi	s1,s1,-1190 # 80229498 <proc>
      pp->parent = initproc;
    80001946:	00007a17          	auipc	s4,0x7
    8000194a:	6caa0a13          	addi	s4,s4,1738 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000194e:	0022d997          	auipc	s3,0x22d
    80001952:	54a98993          	addi	s3,s3,1354 # 8022ee98 <tickslock>
    80001956:	a029                	j	80001960 <reparent+0x34>
    80001958:	16848493          	addi	s1,s1,360
    8000195c:	01348d63          	beq	s1,s3,80001976 <reparent+0x4a>
    if(pp->parent == p){
    80001960:	7c9c                	ld	a5,56(s1)
    80001962:	ff279be3          	bne	a5,s2,80001958 <reparent+0x2c>
      pp->parent = initproc;
    80001966:	000a3503          	ld	a0,0(s4)
    8000196a:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000196c:	00000097          	auipc	ra,0x0
    80001970:	f4a080e7          	jalr	-182(ra) # 800018b6 <wakeup>
    80001974:	b7d5                	j	80001958 <reparent+0x2c>
}
    80001976:	70a2                	ld	ra,40(sp)
    80001978:	7402                	ld	s0,32(sp)
    8000197a:	64e2                	ld	s1,24(sp)
    8000197c:	6942                	ld	s2,16(sp)
    8000197e:	69a2                	ld	s3,8(sp)
    80001980:	6a02                	ld	s4,0(sp)
    80001982:	6145                	addi	sp,sp,48
    80001984:	8082                	ret

0000000080001986 <exit>:
{
    80001986:	7179                	addi	sp,sp,-48
    80001988:	f406                	sd	ra,40(sp)
    8000198a:	f022                	sd	s0,32(sp)
    8000198c:	ec26                	sd	s1,24(sp)
    8000198e:	e84a                	sd	s2,16(sp)
    80001990:	e44e                	sd	s3,8(sp)
    80001992:	e052                	sd	s4,0(sp)
    80001994:	1800                	addi	s0,sp,48
    80001996:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001998:	fffff097          	auipc	ra,0xfffff
    8000199c:	6d2080e7          	jalr	1746(ra) # 8000106a <myproc>
    800019a0:	89aa                	mv	s3,a0
  if(p == initproc)
    800019a2:	00007797          	auipc	a5,0x7
    800019a6:	66e7b783          	ld	a5,1646(a5) # 80009010 <initproc>
    800019aa:	0d050493          	addi	s1,a0,208
    800019ae:	15050913          	addi	s2,a0,336
    800019b2:	00a79d63          	bne	a5,a0,800019cc <exit+0x46>
    panic("init exiting");
    800019b6:	00007517          	auipc	a0,0x7
    800019ba:	85250513          	addi	a0,a0,-1966 # 80008208 <etext+0x208>
    800019be:	00004097          	auipc	ra,0x4
    800019c2:	574080e7          	jalr	1396(ra) # 80005f32 <panic>
  for(int fd = 0; fd < NOFILE; fd++){
    800019c6:	04a1                	addi	s1,s1,8
    800019c8:	01248b63          	beq	s1,s2,800019de <exit+0x58>
    if(p->ofile[fd]){
    800019cc:	6088                	ld	a0,0(s1)
    800019ce:	dd65                	beqz	a0,800019c6 <exit+0x40>
      fileclose(f);
    800019d0:	00002097          	auipc	ra,0x2
    800019d4:	26e080e7          	jalr	622(ra) # 80003c3e <fileclose>
      p->ofile[fd] = 0;
    800019d8:	0004b023          	sd	zero,0(s1)
    800019dc:	b7ed                	j	800019c6 <exit+0x40>
  begin_op();
    800019de:	00002097          	auipc	ra,0x2
    800019e2:	d90080e7          	jalr	-624(ra) # 8000376e <begin_op>
  iput(p->cwd);
    800019e6:	1509b503          	ld	a0,336(s3)
    800019ea:	00001097          	auipc	ra,0x1
    800019ee:	550080e7          	jalr	1360(ra) # 80002f3a <iput>
  end_op();
    800019f2:	00002097          	auipc	ra,0x2
    800019f6:	df6080e7          	jalr	-522(ra) # 800037e8 <end_op>
  p->cwd = 0;
    800019fa:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800019fe:	00227497          	auipc	s1,0x227
    80001a02:	68248493          	addi	s1,s1,1666 # 80229080 <wait_lock>
    80001a06:	8526                	mv	a0,s1
    80001a08:	00005097          	auipc	ra,0x5
    80001a0c:	aaa080e7          	jalr	-1366(ra) # 800064b2 <acquire>
  reparent(p);
    80001a10:	854e                	mv	a0,s3
    80001a12:	00000097          	auipc	ra,0x0
    80001a16:	f1a080e7          	jalr	-230(ra) # 8000192c <reparent>
  wakeup(p->parent);
    80001a1a:	0389b503          	ld	a0,56(s3)
    80001a1e:	00000097          	auipc	ra,0x0
    80001a22:	e98080e7          	jalr	-360(ra) # 800018b6 <wakeup>
  acquire(&p->lock);
    80001a26:	854e                	mv	a0,s3
    80001a28:	00005097          	auipc	ra,0x5
    80001a2c:	a8a080e7          	jalr	-1398(ra) # 800064b2 <acquire>
  p->xstate = status;
    80001a30:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001a34:	4795                	li	a5,5
    80001a36:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001a3a:	8526                	mv	a0,s1
    80001a3c:	00005097          	auipc	ra,0x5
    80001a40:	b26080e7          	jalr	-1242(ra) # 80006562 <release>
  sched();
    80001a44:	00000097          	auipc	ra,0x0
    80001a48:	bda080e7          	jalr	-1062(ra) # 8000161e <sched>
  panic("zombie exit");
    80001a4c:	00006517          	auipc	a0,0x6
    80001a50:	7cc50513          	addi	a0,a0,1996 # 80008218 <etext+0x218>
    80001a54:	00004097          	auipc	ra,0x4
    80001a58:	4de080e7          	jalr	1246(ra) # 80005f32 <panic>

0000000080001a5c <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001a5c:	7179                	addi	sp,sp,-48
    80001a5e:	f406                	sd	ra,40(sp)
    80001a60:	f022                	sd	s0,32(sp)
    80001a62:	ec26                	sd	s1,24(sp)
    80001a64:	e84a                	sd	s2,16(sp)
    80001a66:	e44e                	sd	s3,8(sp)
    80001a68:	1800                	addi	s0,sp,48
    80001a6a:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001a6c:	00228497          	auipc	s1,0x228
    80001a70:	a2c48493          	addi	s1,s1,-1492 # 80229498 <proc>
    80001a74:	0022d997          	auipc	s3,0x22d
    80001a78:	42498993          	addi	s3,s3,1060 # 8022ee98 <tickslock>
    acquire(&p->lock);
    80001a7c:	8526                	mv	a0,s1
    80001a7e:	00005097          	auipc	ra,0x5
    80001a82:	a34080e7          	jalr	-1484(ra) # 800064b2 <acquire>
    if(p->pid == pid){
    80001a86:	589c                	lw	a5,48(s1)
    80001a88:	01278d63          	beq	a5,s2,80001aa2 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001a8c:	8526                	mv	a0,s1
    80001a8e:	00005097          	auipc	ra,0x5
    80001a92:	ad4080e7          	jalr	-1324(ra) # 80006562 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a96:	16848493          	addi	s1,s1,360
    80001a9a:	ff3491e3          	bne	s1,s3,80001a7c <kill+0x20>
  }
  return -1;
    80001a9e:	557d                	li	a0,-1
    80001aa0:	a829                	j	80001aba <kill+0x5e>
      p->killed = 1;
    80001aa2:	4785                	li	a5,1
    80001aa4:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001aa6:	4c98                	lw	a4,24(s1)
    80001aa8:	4789                	li	a5,2
    80001aaa:	00f70f63          	beq	a4,a5,80001ac8 <kill+0x6c>
      release(&p->lock);
    80001aae:	8526                	mv	a0,s1
    80001ab0:	00005097          	auipc	ra,0x5
    80001ab4:	ab2080e7          	jalr	-1358(ra) # 80006562 <release>
      return 0;
    80001ab8:	4501                	li	a0,0
}
    80001aba:	70a2                	ld	ra,40(sp)
    80001abc:	7402                	ld	s0,32(sp)
    80001abe:	64e2                	ld	s1,24(sp)
    80001ac0:	6942                	ld	s2,16(sp)
    80001ac2:	69a2                	ld	s3,8(sp)
    80001ac4:	6145                	addi	sp,sp,48
    80001ac6:	8082                	ret
        p->state = RUNNABLE;
    80001ac8:	478d                	li	a5,3
    80001aca:	cc9c                	sw	a5,24(s1)
    80001acc:	b7cd                	j	80001aae <kill+0x52>

0000000080001ace <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001ace:	7179                	addi	sp,sp,-48
    80001ad0:	f406                	sd	ra,40(sp)
    80001ad2:	f022                	sd	s0,32(sp)
    80001ad4:	ec26                	sd	s1,24(sp)
    80001ad6:	e84a                	sd	s2,16(sp)
    80001ad8:	e44e                	sd	s3,8(sp)
    80001ada:	e052                	sd	s4,0(sp)
    80001adc:	1800                	addi	s0,sp,48
    80001ade:	84aa                	mv	s1,a0
    80001ae0:	892e                	mv	s2,a1
    80001ae2:	89b2                	mv	s3,a2
    80001ae4:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001ae6:	fffff097          	auipc	ra,0xfffff
    80001aea:	584080e7          	jalr	1412(ra) # 8000106a <myproc>
  if(user_dst){
    80001aee:	c08d                	beqz	s1,80001b10 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001af0:	86d2                	mv	a3,s4
    80001af2:	864e                	mv	a2,s3
    80001af4:	85ca                	mv	a1,s2
    80001af6:	6928                	ld	a0,80(a0)
    80001af8:	fffff097          	auipc	ra,0xfffff
    80001afc:	144080e7          	jalr	324(ra) # 80000c3c <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001b00:	70a2                	ld	ra,40(sp)
    80001b02:	7402                	ld	s0,32(sp)
    80001b04:	64e2                	ld	s1,24(sp)
    80001b06:	6942                	ld	s2,16(sp)
    80001b08:	69a2                	ld	s3,8(sp)
    80001b0a:	6a02                	ld	s4,0(sp)
    80001b0c:	6145                	addi	sp,sp,48
    80001b0e:	8082                	ret
    memmove((char *)dst, src, len);
    80001b10:	000a061b          	sext.w	a2,s4
    80001b14:	85ce                	mv	a1,s3
    80001b16:	854a                	mv	a0,s2
    80001b18:	ffffe097          	auipc	ra,0xffffe
    80001b1c:	78c080e7          	jalr	1932(ra) # 800002a4 <memmove>
    return 0;
    80001b20:	8526                	mv	a0,s1
    80001b22:	bff9                	j	80001b00 <either_copyout+0x32>

0000000080001b24 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001b24:	7179                	addi	sp,sp,-48
    80001b26:	f406                	sd	ra,40(sp)
    80001b28:	f022                	sd	s0,32(sp)
    80001b2a:	ec26                	sd	s1,24(sp)
    80001b2c:	e84a                	sd	s2,16(sp)
    80001b2e:	e44e                	sd	s3,8(sp)
    80001b30:	e052                	sd	s4,0(sp)
    80001b32:	1800                	addi	s0,sp,48
    80001b34:	892a                	mv	s2,a0
    80001b36:	84ae                	mv	s1,a1
    80001b38:	89b2                	mv	s3,a2
    80001b3a:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001b3c:	fffff097          	auipc	ra,0xfffff
    80001b40:	52e080e7          	jalr	1326(ra) # 8000106a <myproc>
  if(user_src){
    80001b44:	c08d                	beqz	s1,80001b66 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001b46:	86d2                	mv	a3,s4
    80001b48:	864e                	mv	a2,s3
    80001b4a:	85ca                	mv	a1,s2
    80001b4c:	6928                	ld	a0,80(a0)
    80001b4e:	fffff097          	auipc	ra,0xfffff
    80001b52:	254080e7          	jalr	596(ra) # 80000da2 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001b56:	70a2                	ld	ra,40(sp)
    80001b58:	7402                	ld	s0,32(sp)
    80001b5a:	64e2                	ld	s1,24(sp)
    80001b5c:	6942                	ld	s2,16(sp)
    80001b5e:	69a2                	ld	s3,8(sp)
    80001b60:	6a02                	ld	s4,0(sp)
    80001b62:	6145                	addi	sp,sp,48
    80001b64:	8082                	ret
    memmove(dst, (char*)src, len);
    80001b66:	000a061b          	sext.w	a2,s4
    80001b6a:	85ce                	mv	a1,s3
    80001b6c:	854a                	mv	a0,s2
    80001b6e:	ffffe097          	auipc	ra,0xffffe
    80001b72:	736080e7          	jalr	1846(ra) # 800002a4 <memmove>
    return 0;
    80001b76:	8526                	mv	a0,s1
    80001b78:	bff9                	j	80001b56 <either_copyin+0x32>

0000000080001b7a <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001b7a:	715d                	addi	sp,sp,-80
    80001b7c:	e486                	sd	ra,72(sp)
    80001b7e:	e0a2                	sd	s0,64(sp)
    80001b80:	fc26                	sd	s1,56(sp)
    80001b82:	f84a                	sd	s2,48(sp)
    80001b84:	f44e                	sd	s3,40(sp)
    80001b86:	f052                	sd	s4,32(sp)
    80001b88:	ec56                	sd	s5,24(sp)
    80001b8a:	e85a                	sd	s6,16(sp)
    80001b8c:	e45e                	sd	s7,8(sp)
    80001b8e:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001b90:	00006517          	auipc	a0,0x6
    80001b94:	49050513          	addi	a0,a0,1168 # 80008020 <etext+0x20>
    80001b98:	00004097          	auipc	ra,0x4
    80001b9c:	3e4080e7          	jalr	996(ra) # 80005f7c <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001ba0:	00228497          	auipc	s1,0x228
    80001ba4:	a5048493          	addi	s1,s1,-1456 # 802295f0 <proc+0x158>
    80001ba8:	0022d917          	auipc	s2,0x22d
    80001bac:	44890913          	addi	s2,s2,1096 # 8022eff0 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001bb0:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001bb2:	00006997          	auipc	s3,0x6
    80001bb6:	67698993          	addi	s3,s3,1654 # 80008228 <etext+0x228>
    printf("%d %s %s", p->pid, state, p->name);
    80001bba:	00006a97          	auipc	s5,0x6
    80001bbe:	676a8a93          	addi	s5,s5,1654 # 80008230 <etext+0x230>
    printf("\n");
    80001bc2:	00006a17          	auipc	s4,0x6
    80001bc6:	45ea0a13          	addi	s4,s4,1118 # 80008020 <etext+0x20>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001bca:	00007b97          	auipc	s7,0x7
    80001bce:	b5eb8b93          	addi	s7,s7,-1186 # 80008728 <states.0>
    80001bd2:	a00d                	j	80001bf4 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001bd4:	ed86a583          	lw	a1,-296(a3)
    80001bd8:	8556                	mv	a0,s5
    80001bda:	00004097          	auipc	ra,0x4
    80001bde:	3a2080e7          	jalr	930(ra) # 80005f7c <printf>
    printf("\n");
    80001be2:	8552                	mv	a0,s4
    80001be4:	00004097          	auipc	ra,0x4
    80001be8:	398080e7          	jalr	920(ra) # 80005f7c <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001bec:	16848493          	addi	s1,s1,360
    80001bf0:	03248263          	beq	s1,s2,80001c14 <procdump+0x9a>
    if(p->state == UNUSED)
    80001bf4:	86a6                	mv	a3,s1
    80001bf6:	ec04a783          	lw	a5,-320(s1)
    80001bfa:	dbed                	beqz	a5,80001bec <procdump+0x72>
      state = "???";
    80001bfc:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001bfe:	fcfb6be3          	bltu	s6,a5,80001bd4 <procdump+0x5a>
    80001c02:	02079713          	slli	a4,a5,0x20
    80001c06:	01d75793          	srli	a5,a4,0x1d
    80001c0a:	97de                	add	a5,a5,s7
    80001c0c:	6390                	ld	a2,0(a5)
    80001c0e:	f279                	bnez	a2,80001bd4 <procdump+0x5a>
      state = "???";
    80001c10:	864e                	mv	a2,s3
    80001c12:	b7c9                	j	80001bd4 <procdump+0x5a>
  }
}
    80001c14:	60a6                	ld	ra,72(sp)
    80001c16:	6406                	ld	s0,64(sp)
    80001c18:	74e2                	ld	s1,56(sp)
    80001c1a:	7942                	ld	s2,48(sp)
    80001c1c:	79a2                	ld	s3,40(sp)
    80001c1e:	7a02                	ld	s4,32(sp)
    80001c20:	6ae2                	ld	s5,24(sp)
    80001c22:	6b42                	ld	s6,16(sp)
    80001c24:	6ba2                	ld	s7,8(sp)
    80001c26:	6161                	addi	sp,sp,80
    80001c28:	8082                	ret

0000000080001c2a <swtch>:
    80001c2a:	00153023          	sd	ra,0(a0)
    80001c2e:	00253423          	sd	sp,8(a0)
    80001c32:	e900                	sd	s0,16(a0)
    80001c34:	ed04                	sd	s1,24(a0)
    80001c36:	03253023          	sd	s2,32(a0)
    80001c3a:	03353423          	sd	s3,40(a0)
    80001c3e:	03453823          	sd	s4,48(a0)
    80001c42:	03553c23          	sd	s5,56(a0)
    80001c46:	05653023          	sd	s6,64(a0)
    80001c4a:	05753423          	sd	s7,72(a0)
    80001c4e:	05853823          	sd	s8,80(a0)
    80001c52:	05953c23          	sd	s9,88(a0)
    80001c56:	07a53023          	sd	s10,96(a0)
    80001c5a:	07b53423          	sd	s11,104(a0)
    80001c5e:	0005b083          	ld	ra,0(a1)
    80001c62:	0085b103          	ld	sp,8(a1)
    80001c66:	6980                	ld	s0,16(a1)
    80001c68:	6d84                	ld	s1,24(a1)
    80001c6a:	0205b903          	ld	s2,32(a1)
    80001c6e:	0285b983          	ld	s3,40(a1)
    80001c72:	0305ba03          	ld	s4,48(a1)
    80001c76:	0385ba83          	ld	s5,56(a1)
    80001c7a:	0405bb03          	ld	s6,64(a1)
    80001c7e:	0485bb83          	ld	s7,72(a1)
    80001c82:	0505bc03          	ld	s8,80(a1)
    80001c86:	0585bc83          	ld	s9,88(a1)
    80001c8a:	0605bd03          	ld	s10,96(a1)
    80001c8e:	0685bd83          	ld	s11,104(a1)
    80001c92:	8082                	ret

0000000080001c94 <trapinit>:
void kernelvec();

extern int devintr();

void trapinit(void)
{
    80001c94:	1141                	addi	sp,sp,-16
    80001c96:	e406                	sd	ra,8(sp)
    80001c98:	e022                	sd	s0,0(sp)
    80001c9a:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001c9c:	00006597          	auipc	a1,0x6
    80001ca0:	5cc58593          	addi	a1,a1,1484 # 80008268 <etext+0x268>
    80001ca4:	0022d517          	auipc	a0,0x22d
    80001ca8:	1f450513          	addi	a0,a0,500 # 8022ee98 <tickslock>
    80001cac:	00004097          	auipc	ra,0x4
    80001cb0:	772080e7          	jalr	1906(ra) # 8000641e <initlock>
}
    80001cb4:	60a2                	ld	ra,8(sp)
    80001cb6:	6402                	ld	s0,0(sp)
    80001cb8:	0141                	addi	sp,sp,16
    80001cba:	8082                	ret

0000000080001cbc <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void trapinithart(void)
{
    80001cbc:	1141                	addi	sp,sp,-16
    80001cbe:	e406                	sd	ra,8(sp)
    80001cc0:	e022                	sd	s0,0(sp)
    80001cc2:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001cc4:	00003797          	auipc	a5,0x3
    80001cc8:	69c78793          	addi	a5,a5,1692 # 80005360 <kernelvec>
    80001ccc:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001cd0:	60a2                	ld	ra,8(sp)
    80001cd2:	6402                	ld	s0,0(sp)
    80001cd4:	0141                	addi	sp,sp,16
    80001cd6:	8082                	ret

0000000080001cd8 <usertrapret>:

//
// return to user space
//
void usertrapret(void)
{
    80001cd8:	1141                	addi	sp,sp,-16
    80001cda:	e406                	sd	ra,8(sp)
    80001cdc:	e022                	sd	s0,0(sp)
    80001cde:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001ce0:	fffff097          	auipc	ra,0xfffff
    80001ce4:	38a080e7          	jalr	906(ra) # 8000106a <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ce8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001cec:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001cee:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001cf2:	00005697          	auipc	a3,0x5
    80001cf6:	30e68693          	addi	a3,a3,782 # 80007000 <_trampoline>
    80001cfa:	00005717          	auipc	a4,0x5
    80001cfe:	30670713          	addi	a4,a4,774 # 80007000 <_trampoline>
    80001d02:	8f15                	sub	a4,a4,a3
    80001d04:	040007b7          	lui	a5,0x4000
    80001d08:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001d0a:	07b2                	slli	a5,a5,0xc
    80001d0c:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001d0e:	10571073          	csrw	stvec,a4

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001d12:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001d14:	18002673          	csrr	a2,satp
    80001d18:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001d1a:	6d30                	ld	a2,88(a0)
    80001d1c:	6138                	ld	a4,64(a0)
    80001d1e:	6585                	lui	a1,0x1
    80001d20:	972e                	add	a4,a4,a1
    80001d22:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001d24:	6d38                	ld	a4,88(a0)
    80001d26:	00000617          	auipc	a2,0x0
    80001d2a:	14060613          	addi	a2,a2,320 # 80001e66 <usertrap>
    80001d2e:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp(); // hartid for cpuid()
    80001d30:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001d32:	8612                	mv	a2,tp
    80001d34:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d36:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.

  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001d3a:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001d3e:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d42:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001d46:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001d48:	6f18                	ld	a4,24(a4)
    80001d4a:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001d4e:	692c                	ld	a1,80(a0)
    80001d50:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001d52:	00005717          	auipc	a4,0x5
    80001d56:	33e70713          	addi	a4,a4,830 # 80007090 <userret>
    80001d5a:	8f15                	sub	a4,a4,a3
    80001d5c:	97ba                	add	a5,a5,a4
  ((void (*)(uint64, uint64))fn)(TRAPFRAME, satp);
    80001d5e:	577d                	li	a4,-1
    80001d60:	177e                	slli	a4,a4,0x3f
    80001d62:	8dd9                	or	a1,a1,a4
    80001d64:	02000537          	lui	a0,0x2000
    80001d68:	157d                	addi	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    80001d6a:	0536                	slli	a0,a0,0xd
    80001d6c:	9782                	jalr	a5
}
    80001d6e:	60a2                	ld	ra,8(sp)
    80001d70:	6402                	ld	s0,0(sp)
    80001d72:	0141                	addi	sp,sp,16
    80001d74:	8082                	ret

0000000080001d76 <clockintr>:
  w_sepc(sepc);
  w_sstatus(sstatus);
}

void clockintr()
{
    80001d76:	1101                	addi	sp,sp,-32
    80001d78:	ec06                	sd	ra,24(sp)
    80001d7a:	e822                	sd	s0,16(sp)
    80001d7c:	e426                	sd	s1,8(sp)
    80001d7e:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001d80:	0022d497          	auipc	s1,0x22d
    80001d84:	11848493          	addi	s1,s1,280 # 8022ee98 <tickslock>
    80001d88:	8526                	mv	a0,s1
    80001d8a:	00004097          	auipc	ra,0x4
    80001d8e:	728080e7          	jalr	1832(ra) # 800064b2 <acquire>
  ticks++;
    80001d92:	00007517          	auipc	a0,0x7
    80001d96:	28650513          	addi	a0,a0,646 # 80009018 <ticks>
    80001d9a:	411c                	lw	a5,0(a0)
    80001d9c:	2785                	addiw	a5,a5,1
    80001d9e:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001da0:	00000097          	auipc	ra,0x0
    80001da4:	b16080e7          	jalr	-1258(ra) # 800018b6 <wakeup>
  release(&tickslock);
    80001da8:	8526                	mv	a0,s1
    80001daa:	00004097          	auipc	ra,0x4
    80001dae:	7b8080e7          	jalr	1976(ra) # 80006562 <release>
}
    80001db2:	60e2                	ld	ra,24(sp)
    80001db4:	6442                	ld	s0,16(sp)
    80001db6:	64a2                	ld	s1,8(sp)
    80001db8:	6105                	addi	sp,sp,32
    80001dba:	8082                	ret

0000000080001dbc <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001dbc:	142027f3          	csrr	a5,scause

    return 2;
  }
  else
  {
    return 0;
    80001dc0:	4501                	li	a0,0
  if ((scause & 0x8000000000000000L) &&
    80001dc2:	0a07d163          	bgez	a5,80001e64 <devintr+0xa8>
{
    80001dc6:	1101                	addi	sp,sp,-32
    80001dc8:	ec06                	sd	ra,24(sp)
    80001dca:	e822                	sd	s0,16(sp)
    80001dcc:	1000                	addi	s0,sp,32
      (scause & 0xff) == 9)
    80001dce:	0ff7f713          	zext.b	a4,a5
  if ((scause & 0x8000000000000000L) &&
    80001dd2:	46a5                	li	a3,9
    80001dd4:	00d70c63          	beq	a4,a3,80001dec <devintr+0x30>
  else if (scause == 0x8000000000000001L)
    80001dd8:	577d                	li	a4,-1
    80001dda:	177e                	slli	a4,a4,0x3f
    80001ddc:	0705                	addi	a4,a4,1
    return 0;
    80001dde:	4501                	li	a0,0
  else if (scause == 0x8000000000000001L)
    80001de0:	06e78163          	beq	a5,a4,80001e42 <devintr+0x86>
  }
}
    80001de4:	60e2                	ld	ra,24(sp)
    80001de6:	6442                	ld	s0,16(sp)
    80001de8:	6105                	addi	sp,sp,32
    80001dea:	8082                	ret
    80001dec:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80001dee:	00003097          	auipc	ra,0x3
    80001df2:	67e080e7          	jalr	1662(ra) # 8000546c <plic_claim>
    80001df6:	84aa                	mv	s1,a0
    if (irq == UART0_IRQ)
    80001df8:	47a9                	li	a5,10
    80001dfa:	00f50963          	beq	a0,a5,80001e0c <devintr+0x50>
    else if (irq == VIRTIO0_IRQ)
    80001dfe:	4785                	li	a5,1
    80001e00:	00f50b63          	beq	a0,a5,80001e16 <devintr+0x5a>
    return 1;
    80001e04:	4505                	li	a0,1
    else if (irq)
    80001e06:	ec89                	bnez	s1,80001e20 <devintr+0x64>
    80001e08:	64a2                	ld	s1,8(sp)
    80001e0a:	bfe9                	j	80001de4 <devintr+0x28>
      uartintr();
    80001e0c:	00004097          	auipc	ra,0x4
    80001e10:	5c2080e7          	jalr	1474(ra) # 800063ce <uartintr>
    if (irq)
    80001e14:	a839                	j	80001e32 <devintr+0x76>
      virtio_disk_intr();
    80001e16:	00004097          	auipc	ra,0x4
    80001e1a:	b10080e7          	jalr	-1264(ra) # 80005926 <virtio_disk_intr>
    if (irq)
    80001e1e:	a811                	j	80001e32 <devintr+0x76>
      printf("unexpected interrupt irq=%d\n", irq);
    80001e20:	85a6                	mv	a1,s1
    80001e22:	00006517          	auipc	a0,0x6
    80001e26:	44e50513          	addi	a0,a0,1102 # 80008270 <etext+0x270>
    80001e2a:	00004097          	auipc	ra,0x4
    80001e2e:	152080e7          	jalr	338(ra) # 80005f7c <printf>
      plic_complete(irq);
    80001e32:	8526                	mv	a0,s1
    80001e34:	00003097          	auipc	ra,0x3
    80001e38:	65c080e7          	jalr	1628(ra) # 80005490 <plic_complete>
    return 1;
    80001e3c:	4505                	li	a0,1
    80001e3e:	64a2                	ld	s1,8(sp)
    80001e40:	b755                	j	80001de4 <devintr+0x28>
    if (cpuid() == 0)
    80001e42:	fffff097          	auipc	ra,0xfffff
    80001e46:	1f4080e7          	jalr	500(ra) # 80001036 <cpuid>
    80001e4a:	c901                	beqz	a0,80001e5a <devintr+0x9e>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001e4c:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001e50:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001e52:	14479073          	csrw	sip,a5
    return 2;
    80001e56:	4509                	li	a0,2
    80001e58:	b771                	j	80001de4 <devintr+0x28>
      clockintr();
    80001e5a:	00000097          	auipc	ra,0x0
    80001e5e:	f1c080e7          	jalr	-228(ra) # 80001d76 <clockintr>
    80001e62:	b7ed                	j	80001e4c <devintr+0x90>
}
    80001e64:	8082                	ret

0000000080001e66 <usertrap>:
{
    80001e66:	7139                	addi	sp,sp,-64
    80001e68:	fc06                	sd	ra,56(sp)
    80001e6a:	f822                	sd	s0,48(sp)
    80001e6c:	0080                	addi	s0,sp,64
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e6e:	100027f3          	csrr	a5,sstatus
  if ((r_sstatus() & SSTATUS_SPP) != 0)
    80001e72:	1007f793          	andi	a5,a5,256
    80001e76:	e7a5                	bnez	a5,80001ede <usertrap+0x78>
    80001e78:	f426                	sd	s1,40(sp)
    80001e7a:	f04a                	sd	s2,32(sp)
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001e7c:	00003797          	auipc	a5,0x3
    80001e80:	4e478793          	addi	a5,a5,1252 # 80005360 <kernelvec>
    80001e84:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001e88:	fffff097          	auipc	ra,0xfffff
    80001e8c:	1e2080e7          	jalr	482(ra) # 8000106a <myproc>
    80001e90:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001e92:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e94:	14102773          	csrr	a4,sepc
    80001e98:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e9a:	14202773          	csrr	a4,scause
  if (r_scause() == 8)
    80001e9e:	47a1                	li	a5,8
    80001ea0:	06f71263          	bne	a4,a5,80001f04 <usertrap+0x9e>
    if (p->killed)
    80001ea4:	551c                	lw	a5,40(a0)
    80001ea6:	eba9                	bnez	a5,80001ef8 <usertrap+0x92>
    p->trapframe->epc += 4;
    80001ea8:	6cb8                	ld	a4,88(s1)
    80001eaa:	6f1c                	ld	a5,24(a4)
    80001eac:	0791                	addi	a5,a5,4
    80001eae:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001eb0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001eb4:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001eb8:	10079073          	csrw	sstatus,a5
    syscall();
    80001ebc:	00000097          	auipc	ra,0x0
    80001ec0:	3e0080e7          	jalr	992(ra) # 8000229c <syscall>
  if (p->killed)
    80001ec4:	549c                	lw	a5,40(s1)
    80001ec6:	18079263          	bnez	a5,8000204a <usertrap+0x1e4>
  usertrapret();
    80001eca:	00000097          	auipc	ra,0x0
    80001ece:	e0e080e7          	jalr	-498(ra) # 80001cd8 <usertrapret>
    80001ed2:	74a2                	ld	s1,40(sp)
    80001ed4:	7902                	ld	s2,32(sp)
}
    80001ed6:	70e2                	ld	ra,56(sp)
    80001ed8:	7442                	ld	s0,48(sp)
    80001eda:	6121                	addi	sp,sp,64
    80001edc:	8082                	ret
    80001ede:	f426                	sd	s1,40(sp)
    80001ee0:	f04a                	sd	s2,32(sp)
    80001ee2:	ec4e                	sd	s3,24(sp)
    80001ee4:	e852                	sd	s4,16(sp)
    80001ee6:	e456                	sd	s5,8(sp)
    panic("usertrap: not from user mode");
    80001ee8:	00006517          	auipc	a0,0x6
    80001eec:	3a850513          	addi	a0,a0,936 # 80008290 <etext+0x290>
    80001ef0:	00004097          	auipc	ra,0x4
    80001ef4:	042080e7          	jalr	66(ra) # 80005f32 <panic>
      exit(-1);
    80001ef8:	557d                	li	a0,-1
    80001efa:	00000097          	auipc	ra,0x0
    80001efe:	a8c080e7          	jalr	-1396(ra) # 80001986 <exit>
    80001f02:	b75d                	j	80001ea8 <usertrap+0x42>
  else if ((which_dev = devintr()) != 0)
    80001f04:	00000097          	auipc	ra,0x0
    80001f08:	eb8080e7          	jalr	-328(ra) # 80001dbc <devintr>
    80001f0c:	892a                	mv	s2,a0
    80001f0e:	12051a63          	bnez	a0,80002042 <usertrap+0x1dc>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001f12:	14202773          	csrr	a4,scause
  else if (r_scause() == 13 || r_scause() == 15)
    80001f16:	47b5                	li	a5,13
    80001f18:	00f70763          	beq	a4,a5,80001f26 <usertrap+0xc0>
    80001f1c:	14202773          	csrr	a4,scause
    80001f20:	47bd                	li	a5,15
    80001f22:	0ef71863          	bne	a4,a5,80002012 <usertrap+0x1ac>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001f26:	143025f3          	csrr	a1,stval
    if (va >= MAXVA)
    80001f2a:	57fd                	li	a5,-1
    80001f2c:	83e9                	srli	a5,a5,0x1a
    80001f2e:	02b7f163          	bgeu	a5,a1,80001f50 <usertrap+0xea>
        p->killed = 1;
    80001f32:	4785                	li	a5,1
    80001f34:	d49c                	sw	a5,40(s1)
    exit(-1);
    80001f36:	557d                	li	a0,-1
    80001f38:	00000097          	auipc	ra,0x0
    80001f3c:	a4e080e7          	jalr	-1458(ra) # 80001986 <exit>
  if (which_dev == 2)
    80001f40:	4789                	li	a5,2
    80001f42:	f8f914e3          	bne	s2,a5,80001eca <usertrap+0x64>
    yield();
    80001f46:	fffff097          	auipc	ra,0xfffff
    80001f4a:	7ae080e7          	jalr	1966(ra) # 800016f4 <yield>
    80001f4e:	bfb5                	j	80001eca <usertrap+0x64>
    80001f50:	ec4e                	sd	s3,24(sp)
      pte_t *pte = walk(p->pagetable, va, 0);
    80001f52:	4601                	li	a2,0
    80001f54:	68a8                	ld	a0,80(s1)
    80001f56:	ffffe097          	auipc	ra,0xffffe
    80001f5a:	5e2080e7          	jalr	1506(ra) # 80000538 <walk>
    80001f5e:	89aa                	mv	s3,a0
      if (pte && (*pte & PTE_V) && (*pte & PTE_U) && !(*pte & PTE_W))
    80001f60:	c57d                	beqz	a0,8000204e <usertrap+0x1e8>
    80001f62:	e852                	sd	s4,16(sp)
    80001f64:	00053a03          	ld	s4,0(a0)
    80001f68:	015a7713          	andi	a4,s4,21
    80001f6c:	47c5                	li	a5,17
    80001f6e:	00f70563          	beq	a4,a5,80001f78 <usertrap+0x112>
    80001f72:	69e2                	ld	s3,24(sp)
    80001f74:	6a42                	ld	s4,16(sp)
    80001f76:	bf75                	j	80001f32 <usertrap+0xcc>
    80001f78:	e456                	sd	s5,8(sp)
        if ((mem = kalloc()) == 0)
    80001f7a:	ffffe097          	auipc	ra,0xffffe
    80001f7e:	220080e7          	jalr	544(ra) # 8000019a <kalloc>
    80001f82:	8aaa                	mv	s5,a0
    80001f84:	c579                	beqz	a0,80002052 <usertrap+0x1ec>
        uint64 pa = PTE2PA(*pte);
    80001f86:	00aa5913          	srli	s2,s4,0xa
    80001f8a:	0932                	slli	s2,s2,0xc
          memmove(mem, (char *)pa, PGSIZE);
    80001f8c:	6605                	lui	a2,0x1
    80001f8e:	85ca                	mv	a1,s2
    80001f90:	ffffe097          	auipc	ra,0xffffe
    80001f94:	314080e7          	jalr	788(ra) # 800002a4 <memmove>
          uint flags = PTE_FLAGS(*pte);
    80001f98:	0009b703          	ld	a4,0(s3)
    80001f9c:	3ff77713          	andi	a4,a4,1023
          *pte = PA2PTE((uint64)mem) | flags;
    80001fa0:	00cad793          	srli	a5,s5,0xc
    80001fa4:	07aa                	slli	a5,a5,0xa
    80001fa6:	00476713          	ori	a4,a4,4
    80001faa:	8fd9                	or	a5,a5,a4
    80001fac:	00f9b023          	sd	a5,0(s3)
          acquire(&refcnt_lock);
    80001fb0:	00007517          	auipc	a0,0x7
    80001fb4:	08050513          	addi	a0,a0,128 # 80009030 <refcnt_lock>
    80001fb8:	00004097          	auipc	ra,0x4
    80001fbc:	4fa080e7          	jalr	1274(ra) # 800064b2 <acquire>
          int index = ((uint64)pa - (uint64)end) / PGSIZE;
    80001fc0:	00244797          	auipc	a5,0x244
    80001fc4:	28078793          	addi	a5,a5,640 # 80246240 <end>
    80001fc8:	40f907b3          	sub	a5,s2,a5
    80001fcc:	83b1                	srli	a5,a5,0xc
    80001fce:	2781                	sext.w	a5,a5
          refcnt[index]--;
    80001fd0:	078a                	slli	a5,a5,0x2
    80001fd2:	00007717          	auipc	a4,0x7
    80001fd6:	09670713          	addi	a4,a4,150 # 80009068 <refcnt>
    80001fda:	97ba                	add	a5,a5,a4
    80001fdc:	4398                	lw	a4,0(a5)
    80001fde:	377d                	addiw	a4,a4,-1
    80001fe0:	89ba                	mv	s3,a4
    80001fe2:	c398                	sw	a4,0(a5)
          release(&refcnt_lock);
    80001fe4:	00007517          	auipc	a0,0x7
    80001fe8:	04c50513          	addi	a0,a0,76 # 80009030 <refcnt_lock>
    80001fec:	00004097          	auipc	ra,0x4
    80001ff0:	576080e7          	jalr	1398(ra) # 80006562 <release>
          if (ref == 0)
    80001ff4:	00098663          	beqz	s3,80002000 <usertrap+0x19a>
    80001ff8:	69e2                	ld	s3,24(sp)
    80001ffa:	6a42                	ld	s4,16(sp)
    80001ffc:	6aa2                	ld	s5,8(sp)
    80001ffe:	b5d9                	j	80001ec4 <usertrap+0x5e>
            kfree((void *)pa);
    80002000:	854a                	mv	a0,s2
    80002002:	ffffe097          	auipc	ra,0xffffe
    80002006:	01a080e7          	jalr	26(ra) # 8000001c <kfree>
    8000200a:	69e2                	ld	s3,24(sp)
    8000200c:	6a42                	ld	s4,16(sp)
    8000200e:	6aa2                	ld	s5,8(sp)
    80002010:	bd55                	j	80001ec4 <usertrap+0x5e>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002012:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80002016:	5890                	lw	a2,48(s1)
    80002018:	00006517          	auipc	a0,0x6
    8000201c:	29850513          	addi	a0,a0,664 # 800082b0 <etext+0x2b0>
    80002020:	00004097          	auipc	ra,0x4
    80002024:	f5c080e7          	jalr	-164(ra) # 80005f7c <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002028:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    8000202c:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002030:	00006517          	auipc	a0,0x6
    80002034:	2b050513          	addi	a0,a0,688 # 800082e0 <etext+0x2e0>
    80002038:	00004097          	auipc	ra,0x4
    8000203c:	f44080e7          	jalr	-188(ra) # 80005f7c <printf>
    p->killed = 1;
    80002040:	bdcd                	j	80001f32 <usertrap+0xcc>
  if (p->killed)
    80002042:	549c                	lw	a5,40(s1)
    80002044:	ee078ee3          	beqz	a5,80001f40 <usertrap+0xda>
    80002048:	b5fd                	j	80001f36 <usertrap+0xd0>
    8000204a:	4901                	li	s2,0
    8000204c:	b5ed                	j	80001f36 <usertrap+0xd0>
    8000204e:	69e2                	ld	s3,24(sp)
    80002050:	b5cd                	j	80001f32 <usertrap+0xcc>
    80002052:	69e2                	ld	s3,24(sp)
    80002054:	6a42                	ld	s4,16(sp)
    80002056:	6aa2                	ld	s5,8(sp)
    80002058:	bde9                	j	80001f32 <usertrap+0xcc>

000000008000205a <kerneltrap>:
{
    8000205a:	7179                	addi	sp,sp,-48
    8000205c:	f406                	sd	ra,40(sp)
    8000205e:	f022                	sd	s0,32(sp)
    80002060:	ec26                	sd	s1,24(sp)
    80002062:	e84a                	sd	s2,16(sp)
    80002064:	e44e                	sd	s3,8(sp)
    80002066:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002068:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000206c:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002070:	142029f3          	csrr	s3,scause
  if ((sstatus & SSTATUS_SPP) == 0)
    80002074:	1004f793          	andi	a5,s1,256
    80002078:	cb85                	beqz	a5,800020a8 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000207a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000207e:	8b89                	andi	a5,a5,2
  if (intr_get() != 0)
    80002080:	ef85                	bnez	a5,800020b8 <kerneltrap+0x5e>
  if ((which_dev = devintr()) == 0)
    80002082:	00000097          	auipc	ra,0x0
    80002086:	d3a080e7          	jalr	-710(ra) # 80001dbc <devintr>
    8000208a:	cd1d                	beqz	a0,800020c8 <kerneltrap+0x6e>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    8000208c:	4789                	li	a5,2
    8000208e:	06f50a63          	beq	a0,a5,80002102 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002092:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002096:	10049073          	csrw	sstatus,s1
}
    8000209a:	70a2                	ld	ra,40(sp)
    8000209c:	7402                	ld	s0,32(sp)
    8000209e:	64e2                	ld	s1,24(sp)
    800020a0:	6942                	ld	s2,16(sp)
    800020a2:	69a2                	ld	s3,8(sp)
    800020a4:	6145                	addi	sp,sp,48
    800020a6:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    800020a8:	00006517          	auipc	a0,0x6
    800020ac:	25850513          	addi	a0,a0,600 # 80008300 <etext+0x300>
    800020b0:	00004097          	auipc	ra,0x4
    800020b4:	e82080e7          	jalr	-382(ra) # 80005f32 <panic>
    panic("kerneltrap: interrupts enabled");
    800020b8:	00006517          	auipc	a0,0x6
    800020bc:	27050513          	addi	a0,a0,624 # 80008328 <etext+0x328>
    800020c0:	00004097          	auipc	ra,0x4
    800020c4:	e72080e7          	jalr	-398(ra) # 80005f32 <panic>
    printf("scause %p\n", scause);
    800020c8:	85ce                	mv	a1,s3
    800020ca:	00006517          	auipc	a0,0x6
    800020ce:	27e50513          	addi	a0,a0,638 # 80008348 <etext+0x348>
    800020d2:	00004097          	auipc	ra,0x4
    800020d6:	eaa080e7          	jalr	-342(ra) # 80005f7c <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800020da:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800020de:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    800020e2:	00006517          	auipc	a0,0x6
    800020e6:	27650513          	addi	a0,a0,630 # 80008358 <etext+0x358>
    800020ea:	00004097          	auipc	ra,0x4
    800020ee:	e92080e7          	jalr	-366(ra) # 80005f7c <printf>
    panic("kerneltrap");
    800020f2:	00006517          	auipc	a0,0x6
    800020f6:	27e50513          	addi	a0,a0,638 # 80008370 <etext+0x370>
    800020fa:	00004097          	auipc	ra,0x4
    800020fe:	e38080e7          	jalr	-456(ra) # 80005f32 <panic>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002102:	fffff097          	auipc	ra,0xfffff
    80002106:	f68080e7          	jalr	-152(ra) # 8000106a <myproc>
    8000210a:	d541                	beqz	a0,80002092 <kerneltrap+0x38>
    8000210c:	fffff097          	auipc	ra,0xfffff
    80002110:	f5e080e7          	jalr	-162(ra) # 8000106a <myproc>
    80002114:	4d18                	lw	a4,24(a0)
    80002116:	4791                	li	a5,4
    80002118:	f6f71de3          	bne	a4,a5,80002092 <kerneltrap+0x38>
    yield();
    8000211c:	fffff097          	auipc	ra,0xfffff
    80002120:	5d8080e7          	jalr	1496(ra) # 800016f4 <yield>
    80002124:	b7bd                	j	80002092 <kerneltrap+0x38>

0000000080002126 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002126:	1101                	addi	sp,sp,-32
    80002128:	ec06                	sd	ra,24(sp)
    8000212a:	e822                	sd	s0,16(sp)
    8000212c:	e426                	sd	s1,8(sp)
    8000212e:	1000                	addi	s0,sp,32
    80002130:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002132:	fffff097          	auipc	ra,0xfffff
    80002136:	f38080e7          	jalr	-200(ra) # 8000106a <myproc>
  switch (n) {
    8000213a:	4795                	li	a5,5
    8000213c:	0497e163          	bltu	a5,s1,8000217e <argraw+0x58>
    80002140:	048a                	slli	s1,s1,0x2
    80002142:	00006717          	auipc	a4,0x6
    80002146:	61670713          	addi	a4,a4,1558 # 80008758 <states.0+0x30>
    8000214a:	94ba                	add	s1,s1,a4
    8000214c:	409c                	lw	a5,0(s1)
    8000214e:	97ba                	add	a5,a5,a4
    80002150:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002152:	6d3c                	ld	a5,88(a0)
    80002154:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002156:	60e2                	ld	ra,24(sp)
    80002158:	6442                	ld	s0,16(sp)
    8000215a:	64a2                	ld	s1,8(sp)
    8000215c:	6105                	addi	sp,sp,32
    8000215e:	8082                	ret
    return p->trapframe->a1;
    80002160:	6d3c                	ld	a5,88(a0)
    80002162:	7fa8                	ld	a0,120(a5)
    80002164:	bfcd                	j	80002156 <argraw+0x30>
    return p->trapframe->a2;
    80002166:	6d3c                	ld	a5,88(a0)
    80002168:	63c8                	ld	a0,128(a5)
    8000216a:	b7f5                	j	80002156 <argraw+0x30>
    return p->trapframe->a3;
    8000216c:	6d3c                	ld	a5,88(a0)
    8000216e:	67c8                	ld	a0,136(a5)
    80002170:	b7dd                	j	80002156 <argraw+0x30>
    return p->trapframe->a4;
    80002172:	6d3c                	ld	a5,88(a0)
    80002174:	6bc8                	ld	a0,144(a5)
    80002176:	b7c5                	j	80002156 <argraw+0x30>
    return p->trapframe->a5;
    80002178:	6d3c                	ld	a5,88(a0)
    8000217a:	6fc8                	ld	a0,152(a5)
    8000217c:	bfe9                	j	80002156 <argraw+0x30>
  panic("argraw");
    8000217e:	00006517          	auipc	a0,0x6
    80002182:	20250513          	addi	a0,a0,514 # 80008380 <etext+0x380>
    80002186:	00004097          	auipc	ra,0x4
    8000218a:	dac080e7          	jalr	-596(ra) # 80005f32 <panic>

000000008000218e <fetchaddr>:
{
    8000218e:	1101                	addi	sp,sp,-32
    80002190:	ec06                	sd	ra,24(sp)
    80002192:	e822                	sd	s0,16(sp)
    80002194:	e426                	sd	s1,8(sp)
    80002196:	e04a                	sd	s2,0(sp)
    80002198:	1000                	addi	s0,sp,32
    8000219a:	84aa                	mv	s1,a0
    8000219c:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000219e:	fffff097          	auipc	ra,0xfffff
    800021a2:	ecc080e7          	jalr	-308(ra) # 8000106a <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    800021a6:	653c                	ld	a5,72(a0)
    800021a8:	02f4f863          	bgeu	s1,a5,800021d8 <fetchaddr+0x4a>
    800021ac:	00848713          	addi	a4,s1,8
    800021b0:	02e7e663          	bltu	a5,a4,800021dc <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    800021b4:	46a1                	li	a3,8
    800021b6:	8626                	mv	a2,s1
    800021b8:	85ca                	mv	a1,s2
    800021ba:	6928                	ld	a0,80(a0)
    800021bc:	fffff097          	auipc	ra,0xfffff
    800021c0:	be6080e7          	jalr	-1050(ra) # 80000da2 <copyin>
    800021c4:	00a03533          	snez	a0,a0
    800021c8:	40a0053b          	negw	a0,a0
}
    800021cc:	60e2                	ld	ra,24(sp)
    800021ce:	6442                	ld	s0,16(sp)
    800021d0:	64a2                	ld	s1,8(sp)
    800021d2:	6902                	ld	s2,0(sp)
    800021d4:	6105                	addi	sp,sp,32
    800021d6:	8082                	ret
    return -1;
    800021d8:	557d                	li	a0,-1
    800021da:	bfcd                	j	800021cc <fetchaddr+0x3e>
    800021dc:	557d                	li	a0,-1
    800021de:	b7fd                	j	800021cc <fetchaddr+0x3e>

00000000800021e0 <fetchstr>:
{
    800021e0:	7179                	addi	sp,sp,-48
    800021e2:	f406                	sd	ra,40(sp)
    800021e4:	f022                	sd	s0,32(sp)
    800021e6:	ec26                	sd	s1,24(sp)
    800021e8:	e84a                	sd	s2,16(sp)
    800021ea:	e44e                	sd	s3,8(sp)
    800021ec:	1800                	addi	s0,sp,48
    800021ee:	892a                	mv	s2,a0
    800021f0:	84ae                	mv	s1,a1
    800021f2:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    800021f4:	fffff097          	auipc	ra,0xfffff
    800021f8:	e76080e7          	jalr	-394(ra) # 8000106a <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    800021fc:	86ce                	mv	a3,s3
    800021fe:	864a                	mv	a2,s2
    80002200:	85a6                	mv	a1,s1
    80002202:	6928                	ld	a0,80(a0)
    80002204:	fffff097          	auipc	ra,0xfffff
    80002208:	c2c080e7          	jalr	-980(ra) # 80000e30 <copyinstr>
  if(err < 0)
    8000220c:	00054763          	bltz	a0,8000221a <fetchstr+0x3a>
  return strlen(buf);
    80002210:	8526                	mv	a0,s1
    80002212:	ffffe097          	auipc	ra,0xffffe
    80002216:	1ba080e7          	jalr	442(ra) # 800003cc <strlen>
}
    8000221a:	70a2                	ld	ra,40(sp)
    8000221c:	7402                	ld	s0,32(sp)
    8000221e:	64e2                	ld	s1,24(sp)
    80002220:	6942                	ld	s2,16(sp)
    80002222:	69a2                	ld	s3,8(sp)
    80002224:	6145                	addi	sp,sp,48
    80002226:	8082                	ret

0000000080002228 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80002228:	1101                	addi	sp,sp,-32
    8000222a:	ec06                	sd	ra,24(sp)
    8000222c:	e822                	sd	s0,16(sp)
    8000222e:	e426                	sd	s1,8(sp)
    80002230:	1000                	addi	s0,sp,32
    80002232:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002234:	00000097          	auipc	ra,0x0
    80002238:	ef2080e7          	jalr	-270(ra) # 80002126 <argraw>
    8000223c:	c088                	sw	a0,0(s1)
  return 0;
}
    8000223e:	4501                	li	a0,0
    80002240:	60e2                	ld	ra,24(sp)
    80002242:	6442                	ld	s0,16(sp)
    80002244:	64a2                	ld	s1,8(sp)
    80002246:	6105                	addi	sp,sp,32
    80002248:	8082                	ret

000000008000224a <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    8000224a:	1101                	addi	sp,sp,-32
    8000224c:	ec06                	sd	ra,24(sp)
    8000224e:	e822                	sd	s0,16(sp)
    80002250:	e426                	sd	s1,8(sp)
    80002252:	1000                	addi	s0,sp,32
    80002254:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002256:	00000097          	auipc	ra,0x0
    8000225a:	ed0080e7          	jalr	-304(ra) # 80002126 <argraw>
    8000225e:	e088                	sd	a0,0(s1)
  return 0;
}
    80002260:	4501                	li	a0,0
    80002262:	60e2                	ld	ra,24(sp)
    80002264:	6442                	ld	s0,16(sp)
    80002266:	64a2                	ld	s1,8(sp)
    80002268:	6105                	addi	sp,sp,32
    8000226a:	8082                	ret

000000008000226c <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    8000226c:	1101                	addi	sp,sp,-32
    8000226e:	ec06                	sd	ra,24(sp)
    80002270:	e822                	sd	s0,16(sp)
    80002272:	e426                	sd	s1,8(sp)
    80002274:	e04a                	sd	s2,0(sp)
    80002276:	1000                	addi	s0,sp,32
    80002278:	84ae                	mv	s1,a1
    8000227a:	8932                	mv	s2,a2
  *ip = argraw(n);
    8000227c:	00000097          	auipc	ra,0x0
    80002280:	eaa080e7          	jalr	-342(ra) # 80002126 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80002284:	864a                	mv	a2,s2
    80002286:	85a6                	mv	a1,s1
    80002288:	00000097          	auipc	ra,0x0
    8000228c:	f58080e7          	jalr	-168(ra) # 800021e0 <fetchstr>
}
    80002290:	60e2                	ld	ra,24(sp)
    80002292:	6442                	ld	s0,16(sp)
    80002294:	64a2                	ld	s1,8(sp)
    80002296:	6902                	ld	s2,0(sp)
    80002298:	6105                	addi	sp,sp,32
    8000229a:	8082                	ret

000000008000229c <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    8000229c:	1101                	addi	sp,sp,-32
    8000229e:	ec06                	sd	ra,24(sp)
    800022a0:	e822                	sd	s0,16(sp)
    800022a2:	e426                	sd	s1,8(sp)
    800022a4:	e04a                	sd	s2,0(sp)
    800022a6:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    800022a8:	fffff097          	auipc	ra,0xfffff
    800022ac:	dc2080e7          	jalr	-574(ra) # 8000106a <myproc>
    800022b0:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    800022b2:	05853903          	ld	s2,88(a0)
    800022b6:	0a893783          	ld	a5,168(s2)
    800022ba:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800022be:	37fd                	addiw	a5,a5,-1
    800022c0:	4751                	li	a4,20
    800022c2:	00f76f63          	bltu	a4,a5,800022e0 <syscall+0x44>
    800022c6:	00369713          	slli	a4,a3,0x3
    800022ca:	00006797          	auipc	a5,0x6
    800022ce:	4a678793          	addi	a5,a5,1190 # 80008770 <syscalls>
    800022d2:	97ba                	add	a5,a5,a4
    800022d4:	639c                	ld	a5,0(a5)
    800022d6:	c789                	beqz	a5,800022e0 <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    800022d8:	9782                	jalr	a5
    800022da:	06a93823          	sd	a0,112(s2)
    800022de:	a839                	j	800022fc <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    800022e0:	15848613          	addi	a2,s1,344
    800022e4:	588c                	lw	a1,48(s1)
    800022e6:	00006517          	auipc	a0,0x6
    800022ea:	0a250513          	addi	a0,a0,162 # 80008388 <etext+0x388>
    800022ee:	00004097          	auipc	ra,0x4
    800022f2:	c8e080e7          	jalr	-882(ra) # 80005f7c <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800022f6:	6cbc                	ld	a5,88(s1)
    800022f8:	577d                	li	a4,-1
    800022fa:	fbb8                	sd	a4,112(a5)
  }
}
    800022fc:	60e2                	ld	ra,24(sp)
    800022fe:	6442                	ld	s0,16(sp)
    80002300:	64a2                	ld	s1,8(sp)
    80002302:	6902                	ld	s2,0(sp)
    80002304:	6105                	addi	sp,sp,32
    80002306:	8082                	ret

0000000080002308 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002308:	1101                	addi	sp,sp,-32
    8000230a:	ec06                	sd	ra,24(sp)
    8000230c:	e822                	sd	s0,16(sp)
    8000230e:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80002310:	fec40593          	addi	a1,s0,-20
    80002314:	4501                	li	a0,0
    80002316:	00000097          	auipc	ra,0x0
    8000231a:	f12080e7          	jalr	-238(ra) # 80002228 <argint>
    return -1;
    8000231e:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002320:	00054963          	bltz	a0,80002332 <sys_exit+0x2a>
  exit(n);
    80002324:	fec42503          	lw	a0,-20(s0)
    80002328:	fffff097          	auipc	ra,0xfffff
    8000232c:	65e080e7          	jalr	1630(ra) # 80001986 <exit>
  return 0;  // not reached
    80002330:	4781                	li	a5,0
}
    80002332:	853e                	mv	a0,a5
    80002334:	60e2                	ld	ra,24(sp)
    80002336:	6442                	ld	s0,16(sp)
    80002338:	6105                	addi	sp,sp,32
    8000233a:	8082                	ret

000000008000233c <sys_getpid>:

uint64
sys_getpid(void)
{
    8000233c:	1141                	addi	sp,sp,-16
    8000233e:	e406                	sd	ra,8(sp)
    80002340:	e022                	sd	s0,0(sp)
    80002342:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002344:	fffff097          	auipc	ra,0xfffff
    80002348:	d26080e7          	jalr	-730(ra) # 8000106a <myproc>
}
    8000234c:	5908                	lw	a0,48(a0)
    8000234e:	60a2                	ld	ra,8(sp)
    80002350:	6402                	ld	s0,0(sp)
    80002352:	0141                	addi	sp,sp,16
    80002354:	8082                	ret

0000000080002356 <sys_fork>:

uint64
sys_fork(void)
{
    80002356:	1141                	addi	sp,sp,-16
    80002358:	e406                	sd	ra,8(sp)
    8000235a:	e022                	sd	s0,0(sp)
    8000235c:	0800                	addi	s0,sp,16
  return fork();
    8000235e:	fffff097          	auipc	ra,0xfffff
    80002362:	0de080e7          	jalr	222(ra) # 8000143c <fork>
}
    80002366:	60a2                	ld	ra,8(sp)
    80002368:	6402                	ld	s0,0(sp)
    8000236a:	0141                	addi	sp,sp,16
    8000236c:	8082                	ret

000000008000236e <sys_wait>:

uint64
sys_wait(void)
{
    8000236e:	1101                	addi	sp,sp,-32
    80002370:	ec06                	sd	ra,24(sp)
    80002372:	e822                	sd	s0,16(sp)
    80002374:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002376:	fe840593          	addi	a1,s0,-24
    8000237a:	4501                	li	a0,0
    8000237c:	00000097          	auipc	ra,0x0
    80002380:	ece080e7          	jalr	-306(ra) # 8000224a <argaddr>
    80002384:	87aa                	mv	a5,a0
    return -1;
    80002386:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002388:	0007c863          	bltz	a5,80002398 <sys_wait+0x2a>
  return wait(p);
    8000238c:	fe843503          	ld	a0,-24(s0)
    80002390:	fffff097          	auipc	ra,0xfffff
    80002394:	404080e7          	jalr	1028(ra) # 80001794 <wait>
}
    80002398:	60e2                	ld	ra,24(sp)
    8000239a:	6442                	ld	s0,16(sp)
    8000239c:	6105                	addi	sp,sp,32
    8000239e:	8082                	ret

00000000800023a0 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800023a0:	7179                	addi	sp,sp,-48
    800023a2:	f406                	sd	ra,40(sp)
    800023a4:	f022                	sd	s0,32(sp)
    800023a6:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    800023a8:	fdc40593          	addi	a1,s0,-36
    800023ac:	4501                	li	a0,0
    800023ae:	00000097          	auipc	ra,0x0
    800023b2:	e7a080e7          	jalr	-390(ra) # 80002228 <argint>
    800023b6:	87aa                	mv	a5,a0
    return -1;
    800023b8:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    800023ba:	0207c263          	bltz	a5,800023de <sys_sbrk+0x3e>
    800023be:	ec26                	sd	s1,24(sp)
  addr = myproc()->sz;
    800023c0:	fffff097          	auipc	ra,0xfffff
    800023c4:	caa080e7          	jalr	-854(ra) # 8000106a <myproc>
    800023c8:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    800023ca:	fdc42503          	lw	a0,-36(s0)
    800023ce:	fffff097          	auipc	ra,0xfffff
    800023d2:	ff6080e7          	jalr	-10(ra) # 800013c4 <growproc>
    800023d6:	00054863          	bltz	a0,800023e6 <sys_sbrk+0x46>
    return -1;
  return addr;
    800023da:	8526                	mv	a0,s1
    800023dc:	64e2                	ld	s1,24(sp)
}
    800023de:	70a2                	ld	ra,40(sp)
    800023e0:	7402                	ld	s0,32(sp)
    800023e2:	6145                	addi	sp,sp,48
    800023e4:	8082                	ret
    return -1;
    800023e6:	557d                	li	a0,-1
    800023e8:	64e2                	ld	s1,24(sp)
    800023ea:	bfd5                	j	800023de <sys_sbrk+0x3e>

00000000800023ec <sys_sleep>:

uint64
sys_sleep(void)
{
    800023ec:	7139                	addi	sp,sp,-64
    800023ee:	fc06                	sd	ra,56(sp)
    800023f0:	f822                	sd	s0,48(sp)
    800023f2:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    800023f4:	fcc40593          	addi	a1,s0,-52
    800023f8:	4501                	li	a0,0
    800023fa:	00000097          	auipc	ra,0x0
    800023fe:	e2e080e7          	jalr	-466(ra) # 80002228 <argint>
    return -1;
    80002402:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002404:	06054b63          	bltz	a0,8000247a <sys_sleep+0x8e>
    80002408:	f04a                	sd	s2,32(sp)
  acquire(&tickslock);
    8000240a:	0022d517          	auipc	a0,0x22d
    8000240e:	a8e50513          	addi	a0,a0,-1394 # 8022ee98 <tickslock>
    80002412:	00004097          	auipc	ra,0x4
    80002416:	0a0080e7          	jalr	160(ra) # 800064b2 <acquire>
  ticks0 = ticks;
    8000241a:	00007917          	auipc	s2,0x7
    8000241e:	bfe92903          	lw	s2,-1026(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    80002422:	fcc42783          	lw	a5,-52(s0)
    80002426:	c3a1                	beqz	a5,80002466 <sys_sleep+0x7a>
    80002428:	f426                	sd	s1,40(sp)
    8000242a:	ec4e                	sd	s3,24(sp)
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    8000242c:	0022d997          	auipc	s3,0x22d
    80002430:	a6c98993          	addi	s3,s3,-1428 # 8022ee98 <tickslock>
    80002434:	00007497          	auipc	s1,0x7
    80002438:	be448493          	addi	s1,s1,-1052 # 80009018 <ticks>
    if(myproc()->killed){
    8000243c:	fffff097          	auipc	ra,0xfffff
    80002440:	c2e080e7          	jalr	-978(ra) # 8000106a <myproc>
    80002444:	551c                	lw	a5,40(a0)
    80002446:	ef9d                	bnez	a5,80002484 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    80002448:	85ce                	mv	a1,s3
    8000244a:	8526                	mv	a0,s1
    8000244c:	fffff097          	auipc	ra,0xfffff
    80002450:	2e4080e7          	jalr	740(ra) # 80001730 <sleep>
  while(ticks - ticks0 < n){
    80002454:	409c                	lw	a5,0(s1)
    80002456:	412787bb          	subw	a5,a5,s2
    8000245a:	fcc42703          	lw	a4,-52(s0)
    8000245e:	fce7efe3          	bltu	a5,a4,8000243c <sys_sleep+0x50>
    80002462:	74a2                	ld	s1,40(sp)
    80002464:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80002466:	0022d517          	auipc	a0,0x22d
    8000246a:	a3250513          	addi	a0,a0,-1486 # 8022ee98 <tickslock>
    8000246e:	00004097          	auipc	ra,0x4
    80002472:	0f4080e7          	jalr	244(ra) # 80006562 <release>
  return 0;
    80002476:	4781                	li	a5,0
    80002478:	7902                	ld	s2,32(sp)
}
    8000247a:	853e                	mv	a0,a5
    8000247c:	70e2                	ld	ra,56(sp)
    8000247e:	7442                	ld	s0,48(sp)
    80002480:	6121                	addi	sp,sp,64
    80002482:	8082                	ret
      release(&tickslock);
    80002484:	0022d517          	auipc	a0,0x22d
    80002488:	a1450513          	addi	a0,a0,-1516 # 8022ee98 <tickslock>
    8000248c:	00004097          	auipc	ra,0x4
    80002490:	0d6080e7          	jalr	214(ra) # 80006562 <release>
      return -1;
    80002494:	57fd                	li	a5,-1
    80002496:	74a2                	ld	s1,40(sp)
    80002498:	7902                	ld	s2,32(sp)
    8000249a:	69e2                	ld	s3,24(sp)
    8000249c:	bff9                	j	8000247a <sys_sleep+0x8e>

000000008000249e <sys_kill>:

uint64
sys_kill(void)
{
    8000249e:	1101                	addi	sp,sp,-32
    800024a0:	ec06                	sd	ra,24(sp)
    800024a2:	e822                	sd	s0,16(sp)
    800024a4:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    800024a6:	fec40593          	addi	a1,s0,-20
    800024aa:	4501                	li	a0,0
    800024ac:	00000097          	auipc	ra,0x0
    800024b0:	d7c080e7          	jalr	-644(ra) # 80002228 <argint>
    800024b4:	87aa                	mv	a5,a0
    return -1;
    800024b6:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    800024b8:	0007c863          	bltz	a5,800024c8 <sys_kill+0x2a>
  return kill(pid);
    800024bc:	fec42503          	lw	a0,-20(s0)
    800024c0:	fffff097          	auipc	ra,0xfffff
    800024c4:	59c080e7          	jalr	1436(ra) # 80001a5c <kill>
}
    800024c8:	60e2                	ld	ra,24(sp)
    800024ca:	6442                	ld	s0,16(sp)
    800024cc:	6105                	addi	sp,sp,32
    800024ce:	8082                	ret

00000000800024d0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800024d0:	1101                	addi	sp,sp,-32
    800024d2:	ec06                	sd	ra,24(sp)
    800024d4:	e822                	sd	s0,16(sp)
    800024d6:	e426                	sd	s1,8(sp)
    800024d8:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800024da:	0022d517          	auipc	a0,0x22d
    800024de:	9be50513          	addi	a0,a0,-1602 # 8022ee98 <tickslock>
    800024e2:	00004097          	auipc	ra,0x4
    800024e6:	fd0080e7          	jalr	-48(ra) # 800064b2 <acquire>
  xticks = ticks;
    800024ea:	00007497          	auipc	s1,0x7
    800024ee:	b2e4a483          	lw	s1,-1234(s1) # 80009018 <ticks>
  release(&tickslock);
    800024f2:	0022d517          	auipc	a0,0x22d
    800024f6:	9a650513          	addi	a0,a0,-1626 # 8022ee98 <tickslock>
    800024fa:	00004097          	auipc	ra,0x4
    800024fe:	068080e7          	jalr	104(ra) # 80006562 <release>
  return xticks;
}
    80002502:	02049513          	slli	a0,s1,0x20
    80002506:	9101                	srli	a0,a0,0x20
    80002508:	60e2                	ld	ra,24(sp)
    8000250a:	6442                	ld	s0,16(sp)
    8000250c:	64a2                	ld	s1,8(sp)
    8000250e:	6105                	addi	sp,sp,32
    80002510:	8082                	ret

0000000080002512 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002512:	7179                	addi	sp,sp,-48
    80002514:	f406                	sd	ra,40(sp)
    80002516:	f022                	sd	s0,32(sp)
    80002518:	ec26                	sd	s1,24(sp)
    8000251a:	e84a                	sd	s2,16(sp)
    8000251c:	e44e                	sd	s3,8(sp)
    8000251e:	e052                	sd	s4,0(sp)
    80002520:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002522:	00006597          	auipc	a1,0x6
    80002526:	e8658593          	addi	a1,a1,-378 # 800083a8 <etext+0x3a8>
    8000252a:	0022d517          	auipc	a0,0x22d
    8000252e:	98650513          	addi	a0,a0,-1658 # 8022eeb0 <bcache>
    80002532:	00004097          	auipc	ra,0x4
    80002536:	eec080e7          	jalr	-276(ra) # 8000641e <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    8000253a:	00235797          	auipc	a5,0x235
    8000253e:	97678793          	addi	a5,a5,-1674 # 80236eb0 <bcache+0x8000>
    80002542:	00235717          	auipc	a4,0x235
    80002546:	bd670713          	addi	a4,a4,-1066 # 80237118 <bcache+0x8268>
    8000254a:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000254e:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002552:	0022d497          	auipc	s1,0x22d
    80002556:	97648493          	addi	s1,s1,-1674 # 8022eec8 <bcache+0x18>
    b->next = bcache.head.next;
    8000255a:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000255c:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000255e:	00006a17          	auipc	s4,0x6
    80002562:	e52a0a13          	addi	s4,s4,-430 # 800083b0 <etext+0x3b0>
    b->next = bcache.head.next;
    80002566:	2b893783          	ld	a5,696(s2)
    8000256a:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000256c:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002570:	85d2                	mv	a1,s4
    80002572:	01048513          	addi	a0,s1,16
    80002576:	00001097          	auipc	ra,0x1
    8000257a:	4ba080e7          	jalr	1210(ra) # 80003a30 <initsleeplock>
    bcache.head.next->prev = b;
    8000257e:	2b893783          	ld	a5,696(s2)
    80002582:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002584:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002588:	45848493          	addi	s1,s1,1112
    8000258c:	fd349de3          	bne	s1,s3,80002566 <binit+0x54>
  }
}
    80002590:	70a2                	ld	ra,40(sp)
    80002592:	7402                	ld	s0,32(sp)
    80002594:	64e2                	ld	s1,24(sp)
    80002596:	6942                	ld	s2,16(sp)
    80002598:	69a2                	ld	s3,8(sp)
    8000259a:	6a02                	ld	s4,0(sp)
    8000259c:	6145                	addi	sp,sp,48
    8000259e:	8082                	ret

00000000800025a0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800025a0:	7179                	addi	sp,sp,-48
    800025a2:	f406                	sd	ra,40(sp)
    800025a4:	f022                	sd	s0,32(sp)
    800025a6:	ec26                	sd	s1,24(sp)
    800025a8:	e84a                	sd	s2,16(sp)
    800025aa:	e44e                	sd	s3,8(sp)
    800025ac:	1800                	addi	s0,sp,48
    800025ae:	892a                	mv	s2,a0
    800025b0:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800025b2:	0022d517          	auipc	a0,0x22d
    800025b6:	8fe50513          	addi	a0,a0,-1794 # 8022eeb0 <bcache>
    800025ba:	00004097          	auipc	ra,0x4
    800025be:	ef8080e7          	jalr	-264(ra) # 800064b2 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800025c2:	00235497          	auipc	s1,0x235
    800025c6:	ba64b483          	ld	s1,-1114(s1) # 80237168 <bcache+0x82b8>
    800025ca:	00235797          	auipc	a5,0x235
    800025ce:	b4e78793          	addi	a5,a5,-1202 # 80237118 <bcache+0x8268>
    800025d2:	02f48f63          	beq	s1,a5,80002610 <bread+0x70>
    800025d6:	873e                	mv	a4,a5
    800025d8:	a021                	j	800025e0 <bread+0x40>
    800025da:	68a4                	ld	s1,80(s1)
    800025dc:	02e48a63          	beq	s1,a4,80002610 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800025e0:	449c                	lw	a5,8(s1)
    800025e2:	ff279ce3          	bne	a5,s2,800025da <bread+0x3a>
    800025e6:	44dc                	lw	a5,12(s1)
    800025e8:	ff3799e3          	bne	a5,s3,800025da <bread+0x3a>
      b->refcnt++;
    800025ec:	40bc                	lw	a5,64(s1)
    800025ee:	2785                	addiw	a5,a5,1
    800025f0:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800025f2:	0022d517          	auipc	a0,0x22d
    800025f6:	8be50513          	addi	a0,a0,-1858 # 8022eeb0 <bcache>
    800025fa:	00004097          	auipc	ra,0x4
    800025fe:	f68080e7          	jalr	-152(ra) # 80006562 <release>
      acquiresleep(&b->lock);
    80002602:	01048513          	addi	a0,s1,16
    80002606:	00001097          	auipc	ra,0x1
    8000260a:	464080e7          	jalr	1124(ra) # 80003a6a <acquiresleep>
      return b;
    8000260e:	a8b9                	j	8000266c <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002610:	00235497          	auipc	s1,0x235
    80002614:	b504b483          	ld	s1,-1200(s1) # 80237160 <bcache+0x82b0>
    80002618:	00235797          	auipc	a5,0x235
    8000261c:	b0078793          	addi	a5,a5,-1280 # 80237118 <bcache+0x8268>
    80002620:	00f48863          	beq	s1,a5,80002630 <bread+0x90>
    80002624:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002626:	40bc                	lw	a5,64(s1)
    80002628:	cf81                	beqz	a5,80002640 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000262a:	64a4                	ld	s1,72(s1)
    8000262c:	fee49de3          	bne	s1,a4,80002626 <bread+0x86>
  panic("bget: no buffers");
    80002630:	00006517          	auipc	a0,0x6
    80002634:	d8850513          	addi	a0,a0,-632 # 800083b8 <etext+0x3b8>
    80002638:	00004097          	auipc	ra,0x4
    8000263c:	8fa080e7          	jalr	-1798(ra) # 80005f32 <panic>
      b->dev = dev;
    80002640:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002644:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002648:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000264c:	4785                	li	a5,1
    8000264e:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002650:	0022d517          	auipc	a0,0x22d
    80002654:	86050513          	addi	a0,a0,-1952 # 8022eeb0 <bcache>
    80002658:	00004097          	auipc	ra,0x4
    8000265c:	f0a080e7          	jalr	-246(ra) # 80006562 <release>
      acquiresleep(&b->lock);
    80002660:	01048513          	addi	a0,s1,16
    80002664:	00001097          	auipc	ra,0x1
    80002668:	406080e7          	jalr	1030(ra) # 80003a6a <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000266c:	409c                	lw	a5,0(s1)
    8000266e:	cb89                	beqz	a5,80002680 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002670:	8526                	mv	a0,s1
    80002672:	70a2                	ld	ra,40(sp)
    80002674:	7402                	ld	s0,32(sp)
    80002676:	64e2                	ld	s1,24(sp)
    80002678:	6942                	ld	s2,16(sp)
    8000267a:	69a2                	ld	s3,8(sp)
    8000267c:	6145                	addi	sp,sp,48
    8000267e:	8082                	ret
    virtio_disk_rw(b, 0);
    80002680:	4581                	li	a1,0
    80002682:	8526                	mv	a0,s1
    80002684:	00003097          	auipc	ra,0x3
    80002688:	01a080e7          	jalr	26(ra) # 8000569e <virtio_disk_rw>
    b->valid = 1;
    8000268c:	4785                	li	a5,1
    8000268e:	c09c                	sw	a5,0(s1)
  return b;
    80002690:	b7c5                	j	80002670 <bread+0xd0>

0000000080002692 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002692:	1101                	addi	sp,sp,-32
    80002694:	ec06                	sd	ra,24(sp)
    80002696:	e822                	sd	s0,16(sp)
    80002698:	e426                	sd	s1,8(sp)
    8000269a:	1000                	addi	s0,sp,32
    8000269c:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000269e:	0541                	addi	a0,a0,16
    800026a0:	00001097          	auipc	ra,0x1
    800026a4:	464080e7          	jalr	1124(ra) # 80003b04 <holdingsleep>
    800026a8:	cd01                	beqz	a0,800026c0 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800026aa:	4585                	li	a1,1
    800026ac:	8526                	mv	a0,s1
    800026ae:	00003097          	auipc	ra,0x3
    800026b2:	ff0080e7          	jalr	-16(ra) # 8000569e <virtio_disk_rw>
}
    800026b6:	60e2                	ld	ra,24(sp)
    800026b8:	6442                	ld	s0,16(sp)
    800026ba:	64a2                	ld	s1,8(sp)
    800026bc:	6105                	addi	sp,sp,32
    800026be:	8082                	ret
    panic("bwrite");
    800026c0:	00006517          	auipc	a0,0x6
    800026c4:	d1050513          	addi	a0,a0,-752 # 800083d0 <etext+0x3d0>
    800026c8:	00004097          	auipc	ra,0x4
    800026cc:	86a080e7          	jalr	-1942(ra) # 80005f32 <panic>

00000000800026d0 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800026d0:	1101                	addi	sp,sp,-32
    800026d2:	ec06                	sd	ra,24(sp)
    800026d4:	e822                	sd	s0,16(sp)
    800026d6:	e426                	sd	s1,8(sp)
    800026d8:	e04a                	sd	s2,0(sp)
    800026da:	1000                	addi	s0,sp,32
    800026dc:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800026de:	01050913          	addi	s2,a0,16
    800026e2:	854a                	mv	a0,s2
    800026e4:	00001097          	auipc	ra,0x1
    800026e8:	420080e7          	jalr	1056(ra) # 80003b04 <holdingsleep>
    800026ec:	c535                	beqz	a0,80002758 <brelse+0x88>
    panic("brelse");

  releasesleep(&b->lock);
    800026ee:	854a                	mv	a0,s2
    800026f0:	00001097          	auipc	ra,0x1
    800026f4:	3d0080e7          	jalr	976(ra) # 80003ac0 <releasesleep>

  acquire(&bcache.lock);
    800026f8:	0022c517          	auipc	a0,0x22c
    800026fc:	7b850513          	addi	a0,a0,1976 # 8022eeb0 <bcache>
    80002700:	00004097          	auipc	ra,0x4
    80002704:	db2080e7          	jalr	-590(ra) # 800064b2 <acquire>
  b->refcnt--;
    80002708:	40bc                	lw	a5,64(s1)
    8000270a:	37fd                	addiw	a5,a5,-1
    8000270c:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000270e:	e79d                	bnez	a5,8000273c <brelse+0x6c>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002710:	68b8                	ld	a4,80(s1)
    80002712:	64bc                	ld	a5,72(s1)
    80002714:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002716:	68b8                	ld	a4,80(s1)
    80002718:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000271a:	00234797          	auipc	a5,0x234
    8000271e:	79678793          	addi	a5,a5,1942 # 80236eb0 <bcache+0x8000>
    80002722:	2b87b703          	ld	a4,696(a5)
    80002726:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002728:	00235717          	auipc	a4,0x235
    8000272c:	9f070713          	addi	a4,a4,-1552 # 80237118 <bcache+0x8268>
    80002730:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002732:	2b87b703          	ld	a4,696(a5)
    80002736:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002738:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000273c:	0022c517          	auipc	a0,0x22c
    80002740:	77450513          	addi	a0,a0,1908 # 8022eeb0 <bcache>
    80002744:	00004097          	auipc	ra,0x4
    80002748:	e1e080e7          	jalr	-482(ra) # 80006562 <release>
}
    8000274c:	60e2                	ld	ra,24(sp)
    8000274e:	6442                	ld	s0,16(sp)
    80002750:	64a2                	ld	s1,8(sp)
    80002752:	6902                	ld	s2,0(sp)
    80002754:	6105                	addi	sp,sp,32
    80002756:	8082                	ret
    panic("brelse");
    80002758:	00006517          	auipc	a0,0x6
    8000275c:	c8050513          	addi	a0,a0,-896 # 800083d8 <etext+0x3d8>
    80002760:	00003097          	auipc	ra,0x3
    80002764:	7d2080e7          	jalr	2002(ra) # 80005f32 <panic>

0000000080002768 <bpin>:

void
bpin(struct buf *b) {
    80002768:	1101                	addi	sp,sp,-32
    8000276a:	ec06                	sd	ra,24(sp)
    8000276c:	e822                	sd	s0,16(sp)
    8000276e:	e426                	sd	s1,8(sp)
    80002770:	1000                	addi	s0,sp,32
    80002772:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002774:	0022c517          	auipc	a0,0x22c
    80002778:	73c50513          	addi	a0,a0,1852 # 8022eeb0 <bcache>
    8000277c:	00004097          	auipc	ra,0x4
    80002780:	d36080e7          	jalr	-714(ra) # 800064b2 <acquire>
  b->refcnt++;
    80002784:	40bc                	lw	a5,64(s1)
    80002786:	2785                	addiw	a5,a5,1
    80002788:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000278a:	0022c517          	auipc	a0,0x22c
    8000278e:	72650513          	addi	a0,a0,1830 # 8022eeb0 <bcache>
    80002792:	00004097          	auipc	ra,0x4
    80002796:	dd0080e7          	jalr	-560(ra) # 80006562 <release>
}
    8000279a:	60e2                	ld	ra,24(sp)
    8000279c:	6442                	ld	s0,16(sp)
    8000279e:	64a2                	ld	s1,8(sp)
    800027a0:	6105                	addi	sp,sp,32
    800027a2:	8082                	ret

00000000800027a4 <bunpin>:

void
bunpin(struct buf *b) {
    800027a4:	1101                	addi	sp,sp,-32
    800027a6:	ec06                	sd	ra,24(sp)
    800027a8:	e822                	sd	s0,16(sp)
    800027aa:	e426                	sd	s1,8(sp)
    800027ac:	1000                	addi	s0,sp,32
    800027ae:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800027b0:	0022c517          	auipc	a0,0x22c
    800027b4:	70050513          	addi	a0,a0,1792 # 8022eeb0 <bcache>
    800027b8:	00004097          	auipc	ra,0x4
    800027bc:	cfa080e7          	jalr	-774(ra) # 800064b2 <acquire>
  b->refcnt--;
    800027c0:	40bc                	lw	a5,64(s1)
    800027c2:	37fd                	addiw	a5,a5,-1
    800027c4:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800027c6:	0022c517          	auipc	a0,0x22c
    800027ca:	6ea50513          	addi	a0,a0,1770 # 8022eeb0 <bcache>
    800027ce:	00004097          	auipc	ra,0x4
    800027d2:	d94080e7          	jalr	-620(ra) # 80006562 <release>
}
    800027d6:	60e2                	ld	ra,24(sp)
    800027d8:	6442                	ld	s0,16(sp)
    800027da:	64a2                	ld	s1,8(sp)
    800027dc:	6105                	addi	sp,sp,32
    800027de:	8082                	ret

00000000800027e0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800027e0:	1101                	addi	sp,sp,-32
    800027e2:	ec06                	sd	ra,24(sp)
    800027e4:	e822                	sd	s0,16(sp)
    800027e6:	e426                	sd	s1,8(sp)
    800027e8:	e04a                	sd	s2,0(sp)
    800027ea:	1000                	addi	s0,sp,32
    800027ec:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800027ee:	00d5d79b          	srliw	a5,a1,0xd
    800027f2:	00235597          	auipc	a1,0x235
    800027f6:	d9a5a583          	lw	a1,-614(a1) # 8023758c <sb+0x1c>
    800027fa:	9dbd                	addw	a1,a1,a5
    800027fc:	00000097          	auipc	ra,0x0
    80002800:	da4080e7          	jalr	-604(ra) # 800025a0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002804:	0074f713          	andi	a4,s1,7
    80002808:	4785                	li	a5,1
    8000280a:	00e797bb          	sllw	a5,a5,a4
  bi = b % BPB;
    8000280e:	14ce                	slli	s1,s1,0x33
  if((bp->data[bi/8] & m) == 0)
    80002810:	90d9                	srli	s1,s1,0x36
    80002812:	00950733          	add	a4,a0,s1
    80002816:	05874703          	lbu	a4,88(a4)
    8000281a:	00e7f6b3          	and	a3,a5,a4
    8000281e:	c69d                	beqz	a3,8000284c <bfree+0x6c>
    80002820:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002822:	94aa                	add	s1,s1,a0
    80002824:	fff7c793          	not	a5,a5
    80002828:	8f7d                	and	a4,a4,a5
    8000282a:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    8000282e:	00001097          	auipc	ra,0x1
    80002832:	11e080e7          	jalr	286(ra) # 8000394c <log_write>
  brelse(bp);
    80002836:	854a                	mv	a0,s2
    80002838:	00000097          	auipc	ra,0x0
    8000283c:	e98080e7          	jalr	-360(ra) # 800026d0 <brelse>
}
    80002840:	60e2                	ld	ra,24(sp)
    80002842:	6442                	ld	s0,16(sp)
    80002844:	64a2                	ld	s1,8(sp)
    80002846:	6902                	ld	s2,0(sp)
    80002848:	6105                	addi	sp,sp,32
    8000284a:	8082                	ret
    panic("freeing free block");
    8000284c:	00006517          	auipc	a0,0x6
    80002850:	b9450513          	addi	a0,a0,-1132 # 800083e0 <etext+0x3e0>
    80002854:	00003097          	auipc	ra,0x3
    80002858:	6de080e7          	jalr	1758(ra) # 80005f32 <panic>

000000008000285c <balloc>:
{
    8000285c:	715d                	addi	sp,sp,-80
    8000285e:	e486                	sd	ra,72(sp)
    80002860:	e0a2                	sd	s0,64(sp)
    80002862:	fc26                	sd	s1,56(sp)
    80002864:	f84a                	sd	s2,48(sp)
    80002866:	f44e                	sd	s3,40(sp)
    80002868:	f052                	sd	s4,32(sp)
    8000286a:	ec56                	sd	s5,24(sp)
    8000286c:	e85a                	sd	s6,16(sp)
    8000286e:	e45e                	sd	s7,8(sp)
    80002870:	e062                	sd	s8,0(sp)
    80002872:	0880                	addi	s0,sp,80
  for(b = 0; b < sb.size; b += BPB){
    80002874:	00235797          	auipc	a5,0x235
    80002878:	d007a783          	lw	a5,-768(a5) # 80237574 <sb+0x4>
    8000287c:	c7c1                	beqz	a5,80002904 <balloc+0xa8>
    8000287e:	8baa                	mv	s7,a0
    80002880:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002882:	00235b17          	auipc	s6,0x235
    80002886:	ceeb0b13          	addi	s6,s6,-786 # 80237570 <sb>
      m = 1 << (bi % 8);
    8000288a:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000288c:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000288e:	6c09                	lui	s8,0x2
    80002890:	a821                	j	800028a8 <balloc+0x4c>
    brelse(bp);
    80002892:	854a                	mv	a0,s2
    80002894:	00000097          	auipc	ra,0x0
    80002898:	e3c080e7          	jalr	-452(ra) # 800026d0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    8000289c:	015c0abb          	addw	s5,s8,s5
    800028a0:	004b2783          	lw	a5,4(s6)
    800028a4:	06faf063          	bgeu	s5,a5,80002904 <balloc+0xa8>
    bp = bread(dev, BBLOCK(b, sb));
    800028a8:	41fad79b          	sraiw	a5,s5,0x1f
    800028ac:	0137d79b          	srliw	a5,a5,0x13
    800028b0:	015787bb          	addw	a5,a5,s5
    800028b4:	40d7d79b          	sraiw	a5,a5,0xd
    800028b8:	01cb2583          	lw	a1,28(s6)
    800028bc:	9dbd                	addw	a1,a1,a5
    800028be:	855e                	mv	a0,s7
    800028c0:	00000097          	auipc	ra,0x0
    800028c4:	ce0080e7          	jalr	-800(ra) # 800025a0 <bread>
    800028c8:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800028ca:	004b2503          	lw	a0,4(s6)
    800028ce:	84d6                	mv	s1,s5
    800028d0:	4701                	li	a4,0
    800028d2:	fca4f0e3          	bgeu	s1,a0,80002892 <balloc+0x36>
      m = 1 << (bi % 8);
    800028d6:	00777693          	andi	a3,a4,7
    800028da:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800028de:	41f7579b          	sraiw	a5,a4,0x1f
    800028e2:	01d7d79b          	srliw	a5,a5,0x1d
    800028e6:	9fb9                	addw	a5,a5,a4
    800028e8:	4037d79b          	sraiw	a5,a5,0x3
    800028ec:	00f90633          	add	a2,s2,a5
    800028f0:	05864603          	lbu	a2,88(a2) # 1058 <_entry-0x7fffefa8>
    800028f4:	00c6f5b3          	and	a1,a3,a2
    800028f8:	cd91                	beqz	a1,80002914 <balloc+0xb8>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800028fa:	2705                	addiw	a4,a4,1
    800028fc:	2485                	addiw	s1,s1,1
    800028fe:	fd471ae3          	bne	a4,s4,800028d2 <balloc+0x76>
    80002902:	bf41                	j	80002892 <balloc+0x36>
  panic("balloc: out of blocks");
    80002904:	00006517          	auipc	a0,0x6
    80002908:	af450513          	addi	a0,a0,-1292 # 800083f8 <etext+0x3f8>
    8000290c:	00003097          	auipc	ra,0x3
    80002910:	626080e7          	jalr	1574(ra) # 80005f32 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002914:	97ca                	add	a5,a5,s2
    80002916:	8e55                	or	a2,a2,a3
    80002918:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    8000291c:	854a                	mv	a0,s2
    8000291e:	00001097          	auipc	ra,0x1
    80002922:	02e080e7          	jalr	46(ra) # 8000394c <log_write>
        brelse(bp);
    80002926:	854a                	mv	a0,s2
    80002928:	00000097          	auipc	ra,0x0
    8000292c:	da8080e7          	jalr	-600(ra) # 800026d0 <brelse>
  bp = bread(dev, bno);
    80002930:	85a6                	mv	a1,s1
    80002932:	855e                	mv	a0,s7
    80002934:	00000097          	auipc	ra,0x0
    80002938:	c6c080e7          	jalr	-916(ra) # 800025a0 <bread>
    8000293c:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000293e:	40000613          	li	a2,1024
    80002942:	4581                	li	a1,0
    80002944:	05850513          	addi	a0,a0,88
    80002948:	ffffe097          	auipc	ra,0xffffe
    8000294c:	8f8080e7          	jalr	-1800(ra) # 80000240 <memset>
  log_write(bp);
    80002950:	854a                	mv	a0,s2
    80002952:	00001097          	auipc	ra,0x1
    80002956:	ffa080e7          	jalr	-6(ra) # 8000394c <log_write>
  brelse(bp);
    8000295a:	854a                	mv	a0,s2
    8000295c:	00000097          	auipc	ra,0x0
    80002960:	d74080e7          	jalr	-652(ra) # 800026d0 <brelse>
}
    80002964:	8526                	mv	a0,s1
    80002966:	60a6                	ld	ra,72(sp)
    80002968:	6406                	ld	s0,64(sp)
    8000296a:	74e2                	ld	s1,56(sp)
    8000296c:	7942                	ld	s2,48(sp)
    8000296e:	79a2                	ld	s3,40(sp)
    80002970:	7a02                	ld	s4,32(sp)
    80002972:	6ae2                	ld	s5,24(sp)
    80002974:	6b42                	ld	s6,16(sp)
    80002976:	6ba2                	ld	s7,8(sp)
    80002978:	6c02                	ld	s8,0(sp)
    8000297a:	6161                	addi	sp,sp,80
    8000297c:	8082                	ret

000000008000297e <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    8000297e:	7179                	addi	sp,sp,-48
    80002980:	f406                	sd	ra,40(sp)
    80002982:	f022                	sd	s0,32(sp)
    80002984:	ec26                	sd	s1,24(sp)
    80002986:	e84a                	sd	s2,16(sp)
    80002988:	e44e                	sd	s3,8(sp)
    8000298a:	1800                	addi	s0,sp,48
    8000298c:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000298e:	47ad                	li	a5,11
    80002990:	04b7fd63          	bgeu	a5,a1,800029ea <bmap+0x6c>
    80002994:	e052                	sd	s4,0(sp)
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80002996:	ff45849b          	addiw	s1,a1,-12

  if(bn < NINDIRECT){
    8000299a:	0ff00793          	li	a5,255
    8000299e:	0897ef63          	bltu	a5,s1,80002a3c <bmap+0xbe>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    800029a2:	08052583          	lw	a1,128(a0)
    800029a6:	c5a5                	beqz	a1,80002a0e <bmap+0x90>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    800029a8:	00092503          	lw	a0,0(s2)
    800029ac:	00000097          	auipc	ra,0x0
    800029b0:	bf4080e7          	jalr	-1036(ra) # 800025a0 <bread>
    800029b4:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800029b6:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800029ba:	02049713          	slli	a4,s1,0x20
    800029be:	01e75593          	srli	a1,a4,0x1e
    800029c2:	00b784b3          	add	s1,a5,a1
    800029c6:	0004a983          	lw	s3,0(s1)
    800029ca:	04098b63          	beqz	s3,80002a20 <bmap+0xa2>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    800029ce:	8552                	mv	a0,s4
    800029d0:	00000097          	auipc	ra,0x0
    800029d4:	d00080e7          	jalr	-768(ra) # 800026d0 <brelse>
    return addr;
    800029d8:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    800029da:	854e                	mv	a0,s3
    800029dc:	70a2                	ld	ra,40(sp)
    800029de:	7402                	ld	s0,32(sp)
    800029e0:	64e2                	ld	s1,24(sp)
    800029e2:	6942                	ld	s2,16(sp)
    800029e4:	69a2                	ld	s3,8(sp)
    800029e6:	6145                	addi	sp,sp,48
    800029e8:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    800029ea:	02059793          	slli	a5,a1,0x20
    800029ee:	01e7d593          	srli	a1,a5,0x1e
    800029f2:	00b504b3          	add	s1,a0,a1
    800029f6:	0504a983          	lw	s3,80(s1)
    800029fa:	fe0990e3          	bnez	s3,800029da <bmap+0x5c>
      ip->addrs[bn] = addr = balloc(ip->dev);
    800029fe:	4108                	lw	a0,0(a0)
    80002a00:	00000097          	auipc	ra,0x0
    80002a04:	e5c080e7          	jalr	-420(ra) # 8000285c <balloc>
    80002a08:	89aa                	mv	s3,a0
    80002a0a:	c8a8                	sw	a0,80(s1)
    80002a0c:	b7f9                	j	800029da <bmap+0x5c>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80002a0e:	4108                	lw	a0,0(a0)
    80002a10:	00000097          	auipc	ra,0x0
    80002a14:	e4c080e7          	jalr	-436(ra) # 8000285c <balloc>
    80002a18:	85aa                	mv	a1,a0
    80002a1a:	08a92023          	sw	a0,128(s2)
    80002a1e:	b769                	j	800029a8 <bmap+0x2a>
      a[bn] = addr = balloc(ip->dev);
    80002a20:	00092503          	lw	a0,0(s2)
    80002a24:	00000097          	auipc	ra,0x0
    80002a28:	e38080e7          	jalr	-456(ra) # 8000285c <balloc>
    80002a2c:	89aa                	mv	s3,a0
    80002a2e:	c088                	sw	a0,0(s1)
      log_write(bp);
    80002a30:	8552                	mv	a0,s4
    80002a32:	00001097          	auipc	ra,0x1
    80002a36:	f1a080e7          	jalr	-230(ra) # 8000394c <log_write>
    80002a3a:	bf51                	j	800029ce <bmap+0x50>
  panic("bmap: out of range");
    80002a3c:	00006517          	auipc	a0,0x6
    80002a40:	9d450513          	addi	a0,a0,-1580 # 80008410 <etext+0x410>
    80002a44:	00003097          	auipc	ra,0x3
    80002a48:	4ee080e7          	jalr	1262(ra) # 80005f32 <panic>

0000000080002a4c <iget>:
{
    80002a4c:	7179                	addi	sp,sp,-48
    80002a4e:	f406                	sd	ra,40(sp)
    80002a50:	f022                	sd	s0,32(sp)
    80002a52:	ec26                	sd	s1,24(sp)
    80002a54:	e84a                	sd	s2,16(sp)
    80002a56:	e44e                	sd	s3,8(sp)
    80002a58:	e052                	sd	s4,0(sp)
    80002a5a:	1800                	addi	s0,sp,48
    80002a5c:	89aa                	mv	s3,a0
    80002a5e:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002a60:	00235517          	auipc	a0,0x235
    80002a64:	b3050513          	addi	a0,a0,-1232 # 80237590 <itable>
    80002a68:	00004097          	auipc	ra,0x4
    80002a6c:	a4a080e7          	jalr	-1462(ra) # 800064b2 <acquire>
  empty = 0;
    80002a70:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002a72:	00235497          	auipc	s1,0x235
    80002a76:	b3648493          	addi	s1,s1,-1226 # 802375a8 <itable+0x18>
    80002a7a:	00236697          	auipc	a3,0x236
    80002a7e:	5be68693          	addi	a3,a3,1470 # 80239038 <log>
    80002a82:	a039                	j	80002a90 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002a84:	02090b63          	beqz	s2,80002aba <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002a88:	08848493          	addi	s1,s1,136
    80002a8c:	02d48a63          	beq	s1,a3,80002ac0 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002a90:	449c                	lw	a5,8(s1)
    80002a92:	fef059e3          	blez	a5,80002a84 <iget+0x38>
    80002a96:	4098                	lw	a4,0(s1)
    80002a98:	ff3716e3          	bne	a4,s3,80002a84 <iget+0x38>
    80002a9c:	40d8                	lw	a4,4(s1)
    80002a9e:	ff4713e3          	bne	a4,s4,80002a84 <iget+0x38>
      ip->ref++;
    80002aa2:	2785                	addiw	a5,a5,1
    80002aa4:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002aa6:	00235517          	auipc	a0,0x235
    80002aaa:	aea50513          	addi	a0,a0,-1302 # 80237590 <itable>
    80002aae:	00004097          	auipc	ra,0x4
    80002ab2:	ab4080e7          	jalr	-1356(ra) # 80006562 <release>
      return ip;
    80002ab6:	8926                	mv	s2,s1
    80002ab8:	a03d                	j	80002ae6 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002aba:	f7f9                	bnez	a5,80002a88 <iget+0x3c>
      empty = ip;
    80002abc:	8926                	mv	s2,s1
    80002abe:	b7e9                	j	80002a88 <iget+0x3c>
  if(empty == 0)
    80002ac0:	02090c63          	beqz	s2,80002af8 <iget+0xac>
  ip->dev = dev;
    80002ac4:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002ac8:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002acc:	4785                	li	a5,1
    80002ace:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002ad2:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002ad6:	00235517          	auipc	a0,0x235
    80002ada:	aba50513          	addi	a0,a0,-1350 # 80237590 <itable>
    80002ade:	00004097          	auipc	ra,0x4
    80002ae2:	a84080e7          	jalr	-1404(ra) # 80006562 <release>
}
    80002ae6:	854a                	mv	a0,s2
    80002ae8:	70a2                	ld	ra,40(sp)
    80002aea:	7402                	ld	s0,32(sp)
    80002aec:	64e2                	ld	s1,24(sp)
    80002aee:	6942                	ld	s2,16(sp)
    80002af0:	69a2                	ld	s3,8(sp)
    80002af2:	6a02                	ld	s4,0(sp)
    80002af4:	6145                	addi	sp,sp,48
    80002af6:	8082                	ret
    panic("iget: no inodes");
    80002af8:	00006517          	auipc	a0,0x6
    80002afc:	93050513          	addi	a0,a0,-1744 # 80008428 <etext+0x428>
    80002b00:	00003097          	auipc	ra,0x3
    80002b04:	432080e7          	jalr	1074(ra) # 80005f32 <panic>

0000000080002b08 <fsinit>:
fsinit(int dev) {
    80002b08:	7179                	addi	sp,sp,-48
    80002b0a:	f406                	sd	ra,40(sp)
    80002b0c:	f022                	sd	s0,32(sp)
    80002b0e:	ec26                	sd	s1,24(sp)
    80002b10:	e84a                	sd	s2,16(sp)
    80002b12:	e44e                	sd	s3,8(sp)
    80002b14:	1800                	addi	s0,sp,48
    80002b16:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002b18:	4585                	li	a1,1
    80002b1a:	00000097          	auipc	ra,0x0
    80002b1e:	a86080e7          	jalr	-1402(ra) # 800025a0 <bread>
    80002b22:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002b24:	00235997          	auipc	s3,0x235
    80002b28:	a4c98993          	addi	s3,s3,-1460 # 80237570 <sb>
    80002b2c:	02000613          	li	a2,32
    80002b30:	05850593          	addi	a1,a0,88
    80002b34:	854e                	mv	a0,s3
    80002b36:	ffffd097          	auipc	ra,0xffffd
    80002b3a:	76e080e7          	jalr	1902(ra) # 800002a4 <memmove>
  brelse(bp);
    80002b3e:	8526                	mv	a0,s1
    80002b40:	00000097          	auipc	ra,0x0
    80002b44:	b90080e7          	jalr	-1136(ra) # 800026d0 <brelse>
  if(sb.magic != FSMAGIC)
    80002b48:	0009a703          	lw	a4,0(s3)
    80002b4c:	102037b7          	lui	a5,0x10203
    80002b50:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002b54:	02f71263          	bne	a4,a5,80002b78 <fsinit+0x70>
  initlog(dev, &sb);
    80002b58:	00235597          	auipc	a1,0x235
    80002b5c:	a1858593          	addi	a1,a1,-1512 # 80237570 <sb>
    80002b60:	854a                	mv	a0,s2
    80002b62:	00001097          	auipc	ra,0x1
    80002b66:	b74080e7          	jalr	-1164(ra) # 800036d6 <initlog>
}
    80002b6a:	70a2                	ld	ra,40(sp)
    80002b6c:	7402                	ld	s0,32(sp)
    80002b6e:	64e2                	ld	s1,24(sp)
    80002b70:	6942                	ld	s2,16(sp)
    80002b72:	69a2                	ld	s3,8(sp)
    80002b74:	6145                	addi	sp,sp,48
    80002b76:	8082                	ret
    panic("invalid file system");
    80002b78:	00006517          	auipc	a0,0x6
    80002b7c:	8c050513          	addi	a0,a0,-1856 # 80008438 <etext+0x438>
    80002b80:	00003097          	auipc	ra,0x3
    80002b84:	3b2080e7          	jalr	946(ra) # 80005f32 <panic>

0000000080002b88 <iinit>:
{
    80002b88:	7179                	addi	sp,sp,-48
    80002b8a:	f406                	sd	ra,40(sp)
    80002b8c:	f022                	sd	s0,32(sp)
    80002b8e:	ec26                	sd	s1,24(sp)
    80002b90:	e84a                	sd	s2,16(sp)
    80002b92:	e44e                	sd	s3,8(sp)
    80002b94:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002b96:	00006597          	auipc	a1,0x6
    80002b9a:	8ba58593          	addi	a1,a1,-1862 # 80008450 <etext+0x450>
    80002b9e:	00235517          	auipc	a0,0x235
    80002ba2:	9f250513          	addi	a0,a0,-1550 # 80237590 <itable>
    80002ba6:	00004097          	auipc	ra,0x4
    80002baa:	878080e7          	jalr	-1928(ra) # 8000641e <initlock>
  for(i = 0; i < NINODE; i++) {
    80002bae:	00235497          	auipc	s1,0x235
    80002bb2:	a0a48493          	addi	s1,s1,-1526 # 802375b8 <itable+0x28>
    80002bb6:	00236997          	auipc	s3,0x236
    80002bba:	49298993          	addi	s3,s3,1170 # 80239048 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002bbe:	00006917          	auipc	s2,0x6
    80002bc2:	89a90913          	addi	s2,s2,-1894 # 80008458 <etext+0x458>
    80002bc6:	85ca                	mv	a1,s2
    80002bc8:	8526                	mv	a0,s1
    80002bca:	00001097          	auipc	ra,0x1
    80002bce:	e66080e7          	jalr	-410(ra) # 80003a30 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002bd2:	08848493          	addi	s1,s1,136
    80002bd6:	ff3498e3          	bne	s1,s3,80002bc6 <iinit+0x3e>
}
    80002bda:	70a2                	ld	ra,40(sp)
    80002bdc:	7402                	ld	s0,32(sp)
    80002bde:	64e2                	ld	s1,24(sp)
    80002be0:	6942                	ld	s2,16(sp)
    80002be2:	69a2                	ld	s3,8(sp)
    80002be4:	6145                	addi	sp,sp,48
    80002be6:	8082                	ret

0000000080002be8 <ialloc>:
{
    80002be8:	7139                	addi	sp,sp,-64
    80002bea:	fc06                	sd	ra,56(sp)
    80002bec:	f822                	sd	s0,48(sp)
    80002bee:	f426                	sd	s1,40(sp)
    80002bf0:	f04a                	sd	s2,32(sp)
    80002bf2:	ec4e                	sd	s3,24(sp)
    80002bf4:	e852                	sd	s4,16(sp)
    80002bf6:	e456                	sd	s5,8(sp)
    80002bf8:	e05a                	sd	s6,0(sp)
    80002bfa:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002bfc:	00235717          	auipc	a4,0x235
    80002c00:	98072703          	lw	a4,-1664(a4) # 8023757c <sb+0xc>
    80002c04:	4785                	li	a5,1
    80002c06:	04e7f863          	bgeu	a5,a4,80002c56 <ialloc+0x6e>
    80002c0a:	8aaa                	mv	s5,a0
    80002c0c:	8b2e                	mv	s6,a1
    80002c0e:	893e                	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
    80002c10:	00235a17          	auipc	s4,0x235
    80002c14:	960a0a13          	addi	s4,s4,-1696 # 80237570 <sb>
    80002c18:	00495593          	srli	a1,s2,0x4
    80002c1c:	018a2783          	lw	a5,24(s4)
    80002c20:	9dbd                	addw	a1,a1,a5
    80002c22:	8556                	mv	a0,s5
    80002c24:	00000097          	auipc	ra,0x0
    80002c28:	97c080e7          	jalr	-1668(ra) # 800025a0 <bread>
    80002c2c:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002c2e:	05850993          	addi	s3,a0,88
    80002c32:	00f97793          	andi	a5,s2,15
    80002c36:	079a                	slli	a5,a5,0x6
    80002c38:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002c3a:	00099783          	lh	a5,0(s3)
    80002c3e:	c785                	beqz	a5,80002c66 <ialloc+0x7e>
    brelse(bp);
    80002c40:	00000097          	auipc	ra,0x0
    80002c44:	a90080e7          	jalr	-1392(ra) # 800026d0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002c48:	0905                	addi	s2,s2,1
    80002c4a:	00ca2703          	lw	a4,12(s4)
    80002c4e:	0009079b          	sext.w	a5,s2
    80002c52:	fce7e3e3          	bltu	a5,a4,80002c18 <ialloc+0x30>
  panic("ialloc: no inodes");
    80002c56:	00006517          	auipc	a0,0x6
    80002c5a:	80a50513          	addi	a0,a0,-2038 # 80008460 <etext+0x460>
    80002c5e:	00003097          	auipc	ra,0x3
    80002c62:	2d4080e7          	jalr	724(ra) # 80005f32 <panic>
      memset(dip, 0, sizeof(*dip));
    80002c66:	04000613          	li	a2,64
    80002c6a:	4581                	li	a1,0
    80002c6c:	854e                	mv	a0,s3
    80002c6e:	ffffd097          	auipc	ra,0xffffd
    80002c72:	5d2080e7          	jalr	1490(ra) # 80000240 <memset>
      dip->type = type;
    80002c76:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002c7a:	8526                	mv	a0,s1
    80002c7c:	00001097          	auipc	ra,0x1
    80002c80:	cd0080e7          	jalr	-816(ra) # 8000394c <log_write>
      brelse(bp);
    80002c84:	8526                	mv	a0,s1
    80002c86:	00000097          	auipc	ra,0x0
    80002c8a:	a4a080e7          	jalr	-1462(ra) # 800026d0 <brelse>
      return iget(dev, inum);
    80002c8e:	0009059b          	sext.w	a1,s2
    80002c92:	8556                	mv	a0,s5
    80002c94:	00000097          	auipc	ra,0x0
    80002c98:	db8080e7          	jalr	-584(ra) # 80002a4c <iget>
}
    80002c9c:	70e2                	ld	ra,56(sp)
    80002c9e:	7442                	ld	s0,48(sp)
    80002ca0:	74a2                	ld	s1,40(sp)
    80002ca2:	7902                	ld	s2,32(sp)
    80002ca4:	69e2                	ld	s3,24(sp)
    80002ca6:	6a42                	ld	s4,16(sp)
    80002ca8:	6aa2                	ld	s5,8(sp)
    80002caa:	6b02                	ld	s6,0(sp)
    80002cac:	6121                	addi	sp,sp,64
    80002cae:	8082                	ret

0000000080002cb0 <iupdate>:
{
    80002cb0:	1101                	addi	sp,sp,-32
    80002cb2:	ec06                	sd	ra,24(sp)
    80002cb4:	e822                	sd	s0,16(sp)
    80002cb6:	e426                	sd	s1,8(sp)
    80002cb8:	e04a                	sd	s2,0(sp)
    80002cba:	1000                	addi	s0,sp,32
    80002cbc:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002cbe:	415c                	lw	a5,4(a0)
    80002cc0:	0047d79b          	srliw	a5,a5,0x4
    80002cc4:	00235597          	auipc	a1,0x235
    80002cc8:	8c45a583          	lw	a1,-1852(a1) # 80237588 <sb+0x18>
    80002ccc:	9dbd                	addw	a1,a1,a5
    80002cce:	4108                	lw	a0,0(a0)
    80002cd0:	00000097          	auipc	ra,0x0
    80002cd4:	8d0080e7          	jalr	-1840(ra) # 800025a0 <bread>
    80002cd8:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002cda:	05850793          	addi	a5,a0,88
    80002cde:	40d8                	lw	a4,4(s1)
    80002ce0:	8b3d                	andi	a4,a4,15
    80002ce2:	071a                	slli	a4,a4,0x6
    80002ce4:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002ce6:	04449703          	lh	a4,68(s1)
    80002cea:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002cee:	04649703          	lh	a4,70(s1)
    80002cf2:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002cf6:	04849703          	lh	a4,72(s1)
    80002cfa:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002cfe:	04a49703          	lh	a4,74(s1)
    80002d02:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002d06:	44f8                	lw	a4,76(s1)
    80002d08:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002d0a:	03400613          	li	a2,52
    80002d0e:	05048593          	addi	a1,s1,80
    80002d12:	00c78513          	addi	a0,a5,12
    80002d16:	ffffd097          	auipc	ra,0xffffd
    80002d1a:	58e080e7          	jalr	1422(ra) # 800002a4 <memmove>
  log_write(bp);
    80002d1e:	854a                	mv	a0,s2
    80002d20:	00001097          	auipc	ra,0x1
    80002d24:	c2c080e7          	jalr	-980(ra) # 8000394c <log_write>
  brelse(bp);
    80002d28:	854a                	mv	a0,s2
    80002d2a:	00000097          	auipc	ra,0x0
    80002d2e:	9a6080e7          	jalr	-1626(ra) # 800026d0 <brelse>
}
    80002d32:	60e2                	ld	ra,24(sp)
    80002d34:	6442                	ld	s0,16(sp)
    80002d36:	64a2                	ld	s1,8(sp)
    80002d38:	6902                	ld	s2,0(sp)
    80002d3a:	6105                	addi	sp,sp,32
    80002d3c:	8082                	ret

0000000080002d3e <idup>:
{
    80002d3e:	1101                	addi	sp,sp,-32
    80002d40:	ec06                	sd	ra,24(sp)
    80002d42:	e822                	sd	s0,16(sp)
    80002d44:	e426                	sd	s1,8(sp)
    80002d46:	1000                	addi	s0,sp,32
    80002d48:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002d4a:	00235517          	auipc	a0,0x235
    80002d4e:	84650513          	addi	a0,a0,-1978 # 80237590 <itable>
    80002d52:	00003097          	auipc	ra,0x3
    80002d56:	760080e7          	jalr	1888(ra) # 800064b2 <acquire>
  ip->ref++;
    80002d5a:	449c                	lw	a5,8(s1)
    80002d5c:	2785                	addiw	a5,a5,1
    80002d5e:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002d60:	00235517          	auipc	a0,0x235
    80002d64:	83050513          	addi	a0,a0,-2000 # 80237590 <itable>
    80002d68:	00003097          	auipc	ra,0x3
    80002d6c:	7fa080e7          	jalr	2042(ra) # 80006562 <release>
}
    80002d70:	8526                	mv	a0,s1
    80002d72:	60e2                	ld	ra,24(sp)
    80002d74:	6442                	ld	s0,16(sp)
    80002d76:	64a2                	ld	s1,8(sp)
    80002d78:	6105                	addi	sp,sp,32
    80002d7a:	8082                	ret

0000000080002d7c <ilock>:
{
    80002d7c:	1101                	addi	sp,sp,-32
    80002d7e:	ec06                	sd	ra,24(sp)
    80002d80:	e822                	sd	s0,16(sp)
    80002d82:	e426                	sd	s1,8(sp)
    80002d84:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002d86:	c10d                	beqz	a0,80002da8 <ilock+0x2c>
    80002d88:	84aa                	mv	s1,a0
    80002d8a:	451c                	lw	a5,8(a0)
    80002d8c:	00f05e63          	blez	a5,80002da8 <ilock+0x2c>
  acquiresleep(&ip->lock);
    80002d90:	0541                	addi	a0,a0,16
    80002d92:	00001097          	auipc	ra,0x1
    80002d96:	cd8080e7          	jalr	-808(ra) # 80003a6a <acquiresleep>
  if(ip->valid == 0){
    80002d9a:	40bc                	lw	a5,64(s1)
    80002d9c:	cf99                	beqz	a5,80002dba <ilock+0x3e>
}
    80002d9e:	60e2                	ld	ra,24(sp)
    80002da0:	6442                	ld	s0,16(sp)
    80002da2:	64a2                	ld	s1,8(sp)
    80002da4:	6105                	addi	sp,sp,32
    80002da6:	8082                	ret
    80002da8:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80002daa:	00005517          	auipc	a0,0x5
    80002dae:	6ce50513          	addi	a0,a0,1742 # 80008478 <etext+0x478>
    80002db2:	00003097          	auipc	ra,0x3
    80002db6:	180080e7          	jalr	384(ra) # 80005f32 <panic>
    80002dba:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002dbc:	40dc                	lw	a5,4(s1)
    80002dbe:	0047d79b          	srliw	a5,a5,0x4
    80002dc2:	00234597          	auipc	a1,0x234
    80002dc6:	7c65a583          	lw	a1,1990(a1) # 80237588 <sb+0x18>
    80002dca:	9dbd                	addw	a1,a1,a5
    80002dcc:	4088                	lw	a0,0(s1)
    80002dce:	fffff097          	auipc	ra,0xfffff
    80002dd2:	7d2080e7          	jalr	2002(ra) # 800025a0 <bread>
    80002dd6:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002dd8:	05850593          	addi	a1,a0,88
    80002ddc:	40dc                	lw	a5,4(s1)
    80002dde:	8bbd                	andi	a5,a5,15
    80002de0:	079a                	slli	a5,a5,0x6
    80002de2:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002de4:	00059783          	lh	a5,0(a1)
    80002de8:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002dec:	00259783          	lh	a5,2(a1)
    80002df0:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002df4:	00459783          	lh	a5,4(a1)
    80002df8:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002dfc:	00659783          	lh	a5,6(a1)
    80002e00:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002e04:	459c                	lw	a5,8(a1)
    80002e06:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002e08:	03400613          	li	a2,52
    80002e0c:	05b1                	addi	a1,a1,12
    80002e0e:	05048513          	addi	a0,s1,80
    80002e12:	ffffd097          	auipc	ra,0xffffd
    80002e16:	492080e7          	jalr	1170(ra) # 800002a4 <memmove>
    brelse(bp);
    80002e1a:	854a                	mv	a0,s2
    80002e1c:	00000097          	auipc	ra,0x0
    80002e20:	8b4080e7          	jalr	-1868(ra) # 800026d0 <brelse>
    ip->valid = 1;
    80002e24:	4785                	li	a5,1
    80002e26:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002e28:	04449783          	lh	a5,68(s1)
    80002e2c:	c399                	beqz	a5,80002e32 <ilock+0xb6>
    80002e2e:	6902                	ld	s2,0(sp)
    80002e30:	b7bd                	j	80002d9e <ilock+0x22>
      panic("ilock: no type");
    80002e32:	00005517          	auipc	a0,0x5
    80002e36:	64e50513          	addi	a0,a0,1614 # 80008480 <etext+0x480>
    80002e3a:	00003097          	auipc	ra,0x3
    80002e3e:	0f8080e7          	jalr	248(ra) # 80005f32 <panic>

0000000080002e42 <iunlock>:
{
    80002e42:	1101                	addi	sp,sp,-32
    80002e44:	ec06                	sd	ra,24(sp)
    80002e46:	e822                	sd	s0,16(sp)
    80002e48:	e426                	sd	s1,8(sp)
    80002e4a:	e04a                	sd	s2,0(sp)
    80002e4c:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002e4e:	c905                	beqz	a0,80002e7e <iunlock+0x3c>
    80002e50:	84aa                	mv	s1,a0
    80002e52:	01050913          	addi	s2,a0,16
    80002e56:	854a                	mv	a0,s2
    80002e58:	00001097          	auipc	ra,0x1
    80002e5c:	cac080e7          	jalr	-852(ra) # 80003b04 <holdingsleep>
    80002e60:	cd19                	beqz	a0,80002e7e <iunlock+0x3c>
    80002e62:	449c                	lw	a5,8(s1)
    80002e64:	00f05d63          	blez	a5,80002e7e <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002e68:	854a                	mv	a0,s2
    80002e6a:	00001097          	auipc	ra,0x1
    80002e6e:	c56080e7          	jalr	-938(ra) # 80003ac0 <releasesleep>
}
    80002e72:	60e2                	ld	ra,24(sp)
    80002e74:	6442                	ld	s0,16(sp)
    80002e76:	64a2                	ld	s1,8(sp)
    80002e78:	6902                	ld	s2,0(sp)
    80002e7a:	6105                	addi	sp,sp,32
    80002e7c:	8082                	ret
    panic("iunlock");
    80002e7e:	00005517          	auipc	a0,0x5
    80002e82:	61250513          	addi	a0,a0,1554 # 80008490 <etext+0x490>
    80002e86:	00003097          	auipc	ra,0x3
    80002e8a:	0ac080e7          	jalr	172(ra) # 80005f32 <panic>

0000000080002e8e <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002e8e:	7179                	addi	sp,sp,-48
    80002e90:	f406                	sd	ra,40(sp)
    80002e92:	f022                	sd	s0,32(sp)
    80002e94:	ec26                	sd	s1,24(sp)
    80002e96:	e84a                	sd	s2,16(sp)
    80002e98:	e44e                	sd	s3,8(sp)
    80002e9a:	1800                	addi	s0,sp,48
    80002e9c:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002e9e:	05050493          	addi	s1,a0,80
    80002ea2:	08050913          	addi	s2,a0,128
    80002ea6:	a021                	j	80002eae <itrunc+0x20>
    80002ea8:	0491                	addi	s1,s1,4
    80002eaa:	01248d63          	beq	s1,s2,80002ec4 <itrunc+0x36>
    if(ip->addrs[i]){
    80002eae:	408c                	lw	a1,0(s1)
    80002eb0:	dde5                	beqz	a1,80002ea8 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80002eb2:	0009a503          	lw	a0,0(s3)
    80002eb6:	00000097          	auipc	ra,0x0
    80002eba:	92a080e7          	jalr	-1750(ra) # 800027e0 <bfree>
      ip->addrs[i] = 0;
    80002ebe:	0004a023          	sw	zero,0(s1)
    80002ec2:	b7dd                	j	80002ea8 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002ec4:	0809a583          	lw	a1,128(s3)
    80002ec8:	ed99                	bnez	a1,80002ee6 <itrunc+0x58>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002eca:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002ece:	854e                	mv	a0,s3
    80002ed0:	00000097          	auipc	ra,0x0
    80002ed4:	de0080e7          	jalr	-544(ra) # 80002cb0 <iupdate>
}
    80002ed8:	70a2                	ld	ra,40(sp)
    80002eda:	7402                	ld	s0,32(sp)
    80002edc:	64e2                	ld	s1,24(sp)
    80002ede:	6942                	ld	s2,16(sp)
    80002ee0:	69a2                	ld	s3,8(sp)
    80002ee2:	6145                	addi	sp,sp,48
    80002ee4:	8082                	ret
    80002ee6:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002ee8:	0009a503          	lw	a0,0(s3)
    80002eec:	fffff097          	auipc	ra,0xfffff
    80002ef0:	6b4080e7          	jalr	1716(ra) # 800025a0 <bread>
    80002ef4:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002ef6:	05850493          	addi	s1,a0,88
    80002efa:	45850913          	addi	s2,a0,1112
    80002efe:	a021                	j	80002f06 <itrunc+0x78>
    80002f00:	0491                	addi	s1,s1,4
    80002f02:	01248b63          	beq	s1,s2,80002f18 <itrunc+0x8a>
      if(a[j])
    80002f06:	408c                	lw	a1,0(s1)
    80002f08:	dde5                	beqz	a1,80002f00 <itrunc+0x72>
        bfree(ip->dev, a[j]);
    80002f0a:	0009a503          	lw	a0,0(s3)
    80002f0e:	00000097          	auipc	ra,0x0
    80002f12:	8d2080e7          	jalr	-1838(ra) # 800027e0 <bfree>
    80002f16:	b7ed                	j	80002f00 <itrunc+0x72>
    brelse(bp);
    80002f18:	8552                	mv	a0,s4
    80002f1a:	fffff097          	auipc	ra,0xfffff
    80002f1e:	7b6080e7          	jalr	1974(ra) # 800026d0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002f22:	0809a583          	lw	a1,128(s3)
    80002f26:	0009a503          	lw	a0,0(s3)
    80002f2a:	00000097          	auipc	ra,0x0
    80002f2e:	8b6080e7          	jalr	-1866(ra) # 800027e0 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002f32:	0809a023          	sw	zero,128(s3)
    80002f36:	6a02                	ld	s4,0(sp)
    80002f38:	bf49                	j	80002eca <itrunc+0x3c>

0000000080002f3a <iput>:
{
    80002f3a:	1101                	addi	sp,sp,-32
    80002f3c:	ec06                	sd	ra,24(sp)
    80002f3e:	e822                	sd	s0,16(sp)
    80002f40:	e426                	sd	s1,8(sp)
    80002f42:	1000                	addi	s0,sp,32
    80002f44:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002f46:	00234517          	auipc	a0,0x234
    80002f4a:	64a50513          	addi	a0,a0,1610 # 80237590 <itable>
    80002f4e:	00003097          	auipc	ra,0x3
    80002f52:	564080e7          	jalr	1380(ra) # 800064b2 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002f56:	4498                	lw	a4,8(s1)
    80002f58:	4785                	li	a5,1
    80002f5a:	02f70263          	beq	a4,a5,80002f7e <iput+0x44>
  ip->ref--;
    80002f5e:	449c                	lw	a5,8(s1)
    80002f60:	37fd                	addiw	a5,a5,-1
    80002f62:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002f64:	00234517          	auipc	a0,0x234
    80002f68:	62c50513          	addi	a0,a0,1580 # 80237590 <itable>
    80002f6c:	00003097          	auipc	ra,0x3
    80002f70:	5f6080e7          	jalr	1526(ra) # 80006562 <release>
}
    80002f74:	60e2                	ld	ra,24(sp)
    80002f76:	6442                	ld	s0,16(sp)
    80002f78:	64a2                	ld	s1,8(sp)
    80002f7a:	6105                	addi	sp,sp,32
    80002f7c:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002f7e:	40bc                	lw	a5,64(s1)
    80002f80:	dff9                	beqz	a5,80002f5e <iput+0x24>
    80002f82:	04a49783          	lh	a5,74(s1)
    80002f86:	ffe1                	bnez	a5,80002f5e <iput+0x24>
    80002f88:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80002f8a:	01048913          	addi	s2,s1,16
    80002f8e:	854a                	mv	a0,s2
    80002f90:	00001097          	auipc	ra,0x1
    80002f94:	ada080e7          	jalr	-1318(ra) # 80003a6a <acquiresleep>
    release(&itable.lock);
    80002f98:	00234517          	auipc	a0,0x234
    80002f9c:	5f850513          	addi	a0,a0,1528 # 80237590 <itable>
    80002fa0:	00003097          	auipc	ra,0x3
    80002fa4:	5c2080e7          	jalr	1474(ra) # 80006562 <release>
    itrunc(ip);
    80002fa8:	8526                	mv	a0,s1
    80002faa:	00000097          	auipc	ra,0x0
    80002fae:	ee4080e7          	jalr	-284(ra) # 80002e8e <itrunc>
    ip->type = 0;
    80002fb2:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002fb6:	8526                	mv	a0,s1
    80002fb8:	00000097          	auipc	ra,0x0
    80002fbc:	cf8080e7          	jalr	-776(ra) # 80002cb0 <iupdate>
    ip->valid = 0;
    80002fc0:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002fc4:	854a                	mv	a0,s2
    80002fc6:	00001097          	auipc	ra,0x1
    80002fca:	afa080e7          	jalr	-1286(ra) # 80003ac0 <releasesleep>
    acquire(&itable.lock);
    80002fce:	00234517          	auipc	a0,0x234
    80002fd2:	5c250513          	addi	a0,a0,1474 # 80237590 <itable>
    80002fd6:	00003097          	auipc	ra,0x3
    80002fda:	4dc080e7          	jalr	1244(ra) # 800064b2 <acquire>
    80002fde:	6902                	ld	s2,0(sp)
    80002fe0:	bfbd                	j	80002f5e <iput+0x24>

0000000080002fe2 <iunlockput>:
{
    80002fe2:	1101                	addi	sp,sp,-32
    80002fe4:	ec06                	sd	ra,24(sp)
    80002fe6:	e822                	sd	s0,16(sp)
    80002fe8:	e426                	sd	s1,8(sp)
    80002fea:	1000                	addi	s0,sp,32
    80002fec:	84aa                	mv	s1,a0
  iunlock(ip);
    80002fee:	00000097          	auipc	ra,0x0
    80002ff2:	e54080e7          	jalr	-428(ra) # 80002e42 <iunlock>
  iput(ip);
    80002ff6:	8526                	mv	a0,s1
    80002ff8:	00000097          	auipc	ra,0x0
    80002ffc:	f42080e7          	jalr	-190(ra) # 80002f3a <iput>
}
    80003000:	60e2                	ld	ra,24(sp)
    80003002:	6442                	ld	s0,16(sp)
    80003004:	64a2                	ld	s1,8(sp)
    80003006:	6105                	addi	sp,sp,32
    80003008:	8082                	ret

000000008000300a <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    8000300a:	1141                	addi	sp,sp,-16
    8000300c:	e406                	sd	ra,8(sp)
    8000300e:	e022                	sd	s0,0(sp)
    80003010:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003012:	411c                	lw	a5,0(a0)
    80003014:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003016:	415c                	lw	a5,4(a0)
    80003018:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    8000301a:	04451783          	lh	a5,68(a0)
    8000301e:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003022:	04a51783          	lh	a5,74(a0)
    80003026:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    8000302a:	04c56783          	lwu	a5,76(a0)
    8000302e:	e99c                	sd	a5,16(a1)
}
    80003030:	60a2                	ld	ra,8(sp)
    80003032:	6402                	ld	s0,0(sp)
    80003034:	0141                	addi	sp,sp,16
    80003036:	8082                	ret

0000000080003038 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003038:	457c                	lw	a5,76(a0)
    8000303a:	0ed7ea63          	bltu	a5,a3,8000312e <readi+0xf6>
{
    8000303e:	7159                	addi	sp,sp,-112
    80003040:	f486                	sd	ra,104(sp)
    80003042:	f0a2                	sd	s0,96(sp)
    80003044:	eca6                	sd	s1,88(sp)
    80003046:	fc56                	sd	s5,56(sp)
    80003048:	f85a                	sd	s6,48(sp)
    8000304a:	f45e                	sd	s7,40(sp)
    8000304c:	ec66                	sd	s9,24(sp)
    8000304e:	1880                	addi	s0,sp,112
    80003050:	8baa                	mv	s7,a0
    80003052:	8cae                	mv	s9,a1
    80003054:	8ab2                	mv	s5,a2
    80003056:	84b6                	mv	s1,a3
    80003058:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    8000305a:	9f35                	addw	a4,a4,a3
    return 0;
    8000305c:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    8000305e:	0ad76763          	bltu	a4,a3,8000310c <readi+0xd4>
    80003062:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80003064:	00e7f463          	bgeu	a5,a4,8000306c <readi+0x34>
    n = ip->size - off;
    80003068:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000306c:	0a0b0f63          	beqz	s6,8000312a <readi+0xf2>
    80003070:	e8ca                	sd	s2,80(sp)
    80003072:	e0d2                	sd	s4,64(sp)
    80003074:	f062                	sd	s8,32(sp)
    80003076:	e86a                	sd	s10,16(sp)
    80003078:	e46e                	sd	s11,8(sp)
    8000307a:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    8000307c:	40000d93          	li	s11,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003080:	5d7d                	li	s10,-1
    80003082:	a82d                	j	800030bc <readi+0x84>
    80003084:	020a1c13          	slli	s8,s4,0x20
    80003088:	020c5c13          	srli	s8,s8,0x20
    8000308c:	05890613          	addi	a2,s2,88
    80003090:	86e2                	mv	a3,s8
    80003092:	963e                	add	a2,a2,a5
    80003094:	85d6                	mv	a1,s5
    80003096:	8566                	mv	a0,s9
    80003098:	fffff097          	auipc	ra,0xfffff
    8000309c:	a36080e7          	jalr	-1482(ra) # 80001ace <either_copyout>
    800030a0:	05a50963          	beq	a0,s10,800030f2 <readi+0xba>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    800030a4:	854a                	mv	a0,s2
    800030a6:	fffff097          	auipc	ra,0xfffff
    800030aa:	62a080e7          	jalr	1578(ra) # 800026d0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800030ae:	013a09bb          	addw	s3,s4,s3
    800030b2:	009a04bb          	addw	s1,s4,s1
    800030b6:	9ae2                	add	s5,s5,s8
    800030b8:	0769f363          	bgeu	s3,s6,8000311e <readi+0xe6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    800030bc:	000ba903          	lw	s2,0(s7)
    800030c0:	00a4d59b          	srliw	a1,s1,0xa
    800030c4:	855e                	mv	a0,s7
    800030c6:	00000097          	auipc	ra,0x0
    800030ca:	8b8080e7          	jalr	-1864(ra) # 8000297e <bmap>
    800030ce:	85aa                	mv	a1,a0
    800030d0:	854a                	mv	a0,s2
    800030d2:	fffff097          	auipc	ra,0xfffff
    800030d6:	4ce080e7          	jalr	1230(ra) # 800025a0 <bread>
    800030da:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800030dc:	3ff4f793          	andi	a5,s1,1023
    800030e0:	40fd873b          	subw	a4,s11,a5
    800030e4:	413b06bb          	subw	a3,s6,s3
    800030e8:	8a3a                	mv	s4,a4
    800030ea:	f8e6fde3          	bgeu	a3,a4,80003084 <readi+0x4c>
    800030ee:	8a36                	mv	s4,a3
    800030f0:	bf51                	j	80003084 <readi+0x4c>
      brelse(bp);
    800030f2:	854a                	mv	a0,s2
    800030f4:	fffff097          	auipc	ra,0xfffff
    800030f8:	5dc080e7          	jalr	1500(ra) # 800026d0 <brelse>
      tot = -1;
    800030fc:	59fd                	li	s3,-1
      break;
    800030fe:	6946                	ld	s2,80(sp)
    80003100:	6a06                	ld	s4,64(sp)
    80003102:	7c02                	ld	s8,32(sp)
    80003104:	6d42                	ld	s10,16(sp)
    80003106:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80003108:	854e                	mv	a0,s3
    8000310a:	69a6                	ld	s3,72(sp)
}
    8000310c:	70a6                	ld	ra,104(sp)
    8000310e:	7406                	ld	s0,96(sp)
    80003110:	64e6                	ld	s1,88(sp)
    80003112:	7ae2                	ld	s5,56(sp)
    80003114:	7b42                	ld	s6,48(sp)
    80003116:	7ba2                	ld	s7,40(sp)
    80003118:	6ce2                	ld	s9,24(sp)
    8000311a:	6165                	addi	sp,sp,112
    8000311c:	8082                	ret
    8000311e:	6946                	ld	s2,80(sp)
    80003120:	6a06                	ld	s4,64(sp)
    80003122:	7c02                	ld	s8,32(sp)
    80003124:	6d42                	ld	s10,16(sp)
    80003126:	6da2                	ld	s11,8(sp)
    80003128:	b7c5                	j	80003108 <readi+0xd0>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000312a:	89da                	mv	s3,s6
    8000312c:	bff1                	j	80003108 <readi+0xd0>
    return 0;
    8000312e:	4501                	li	a0,0
}
    80003130:	8082                	ret

0000000080003132 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003132:	457c                	lw	a5,76(a0)
    80003134:	10d7e963          	bltu	a5,a3,80003246 <writei+0x114>
{
    80003138:	7159                	addi	sp,sp,-112
    8000313a:	f486                	sd	ra,104(sp)
    8000313c:	f0a2                	sd	s0,96(sp)
    8000313e:	e8ca                	sd	s2,80(sp)
    80003140:	fc56                	sd	s5,56(sp)
    80003142:	f45e                	sd	s7,40(sp)
    80003144:	f062                	sd	s8,32(sp)
    80003146:	ec66                	sd	s9,24(sp)
    80003148:	1880                	addi	s0,sp,112
    8000314a:	8baa                	mv	s7,a0
    8000314c:	8cae                	mv	s9,a1
    8000314e:	8ab2                	mv	s5,a2
    80003150:	8936                	mv	s2,a3
    80003152:	8c3a                	mv	s8,a4
  if(off > ip->size || off + n < off)
    80003154:	00e687bb          	addw	a5,a3,a4
    80003158:	0ed7e963          	bltu	a5,a3,8000324a <writei+0x118>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    8000315c:	00043737          	lui	a4,0x43
    80003160:	0ef76763          	bltu	a4,a5,8000324e <writei+0x11c>
    80003164:	e0d2                	sd	s4,64(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003166:	0c0c0863          	beqz	s8,80003236 <writei+0x104>
    8000316a:	eca6                	sd	s1,88(sp)
    8000316c:	e4ce                	sd	s3,72(sp)
    8000316e:	f85a                	sd	s6,48(sp)
    80003170:	e86a                	sd	s10,16(sp)
    80003172:	e46e                	sd	s11,8(sp)
    80003174:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003176:	40000d93          	li	s11,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    8000317a:	5d7d                	li	s10,-1
    8000317c:	a091                	j	800031c0 <writei+0x8e>
    8000317e:	02099b13          	slli	s6,s3,0x20
    80003182:	020b5b13          	srli	s6,s6,0x20
    80003186:	05848513          	addi	a0,s1,88
    8000318a:	86da                	mv	a3,s6
    8000318c:	8656                	mv	a2,s5
    8000318e:	85e6                	mv	a1,s9
    80003190:	953e                	add	a0,a0,a5
    80003192:	fffff097          	auipc	ra,0xfffff
    80003196:	992080e7          	jalr	-1646(ra) # 80001b24 <either_copyin>
    8000319a:	05a50e63          	beq	a0,s10,800031f6 <writei+0xc4>
      brelse(bp);
      break;
    }
    log_write(bp);
    8000319e:	8526                	mv	a0,s1
    800031a0:	00000097          	auipc	ra,0x0
    800031a4:	7ac080e7          	jalr	1964(ra) # 8000394c <log_write>
    brelse(bp);
    800031a8:	8526                	mv	a0,s1
    800031aa:	fffff097          	auipc	ra,0xfffff
    800031ae:	526080e7          	jalr	1318(ra) # 800026d0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800031b2:	01498a3b          	addw	s4,s3,s4
    800031b6:	0129893b          	addw	s2,s3,s2
    800031ba:	9ada                	add	s5,s5,s6
    800031bc:	058a7263          	bgeu	s4,s8,80003200 <writei+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    800031c0:	000ba483          	lw	s1,0(s7)
    800031c4:	00a9559b          	srliw	a1,s2,0xa
    800031c8:	855e                	mv	a0,s7
    800031ca:	fffff097          	auipc	ra,0xfffff
    800031ce:	7b4080e7          	jalr	1972(ra) # 8000297e <bmap>
    800031d2:	85aa                	mv	a1,a0
    800031d4:	8526                	mv	a0,s1
    800031d6:	fffff097          	auipc	ra,0xfffff
    800031da:	3ca080e7          	jalr	970(ra) # 800025a0 <bread>
    800031de:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800031e0:	3ff97793          	andi	a5,s2,1023
    800031e4:	40fd873b          	subw	a4,s11,a5
    800031e8:	414c06bb          	subw	a3,s8,s4
    800031ec:	89ba                	mv	s3,a4
    800031ee:	f8e6f8e3          	bgeu	a3,a4,8000317e <writei+0x4c>
    800031f2:	89b6                	mv	s3,a3
    800031f4:	b769                	j	8000317e <writei+0x4c>
      brelse(bp);
    800031f6:	8526                	mv	a0,s1
    800031f8:	fffff097          	auipc	ra,0xfffff
    800031fc:	4d8080e7          	jalr	1240(ra) # 800026d0 <brelse>
  }

  if(off > ip->size)
    80003200:	04cba783          	lw	a5,76(s7)
    80003204:	0327fb63          	bgeu	a5,s2,8000323a <writei+0x108>
    ip->size = off;
    80003208:	052ba623          	sw	s2,76(s7)
    8000320c:	64e6                	ld	s1,88(sp)
    8000320e:	69a6                	ld	s3,72(sp)
    80003210:	7b42                	ld	s6,48(sp)
    80003212:	6d42                	ld	s10,16(sp)
    80003214:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003216:	855e                	mv	a0,s7
    80003218:	00000097          	auipc	ra,0x0
    8000321c:	a98080e7          	jalr	-1384(ra) # 80002cb0 <iupdate>

  return tot;
    80003220:	8552                	mv	a0,s4
    80003222:	6a06                	ld	s4,64(sp)
}
    80003224:	70a6                	ld	ra,104(sp)
    80003226:	7406                	ld	s0,96(sp)
    80003228:	6946                	ld	s2,80(sp)
    8000322a:	7ae2                	ld	s5,56(sp)
    8000322c:	7ba2                	ld	s7,40(sp)
    8000322e:	7c02                	ld	s8,32(sp)
    80003230:	6ce2                	ld	s9,24(sp)
    80003232:	6165                	addi	sp,sp,112
    80003234:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003236:	8a62                	mv	s4,s8
    80003238:	bff9                	j	80003216 <writei+0xe4>
    8000323a:	64e6                	ld	s1,88(sp)
    8000323c:	69a6                	ld	s3,72(sp)
    8000323e:	7b42                	ld	s6,48(sp)
    80003240:	6d42                	ld	s10,16(sp)
    80003242:	6da2                	ld	s11,8(sp)
    80003244:	bfc9                	j	80003216 <writei+0xe4>
    return -1;
    80003246:	557d                	li	a0,-1
}
    80003248:	8082                	ret
    return -1;
    8000324a:	557d                	li	a0,-1
    8000324c:	bfe1                	j	80003224 <writei+0xf2>
    return -1;
    8000324e:	557d                	li	a0,-1
    80003250:	bfd1                	j	80003224 <writei+0xf2>

0000000080003252 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003252:	1141                	addi	sp,sp,-16
    80003254:	e406                	sd	ra,8(sp)
    80003256:	e022                	sd	s0,0(sp)
    80003258:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    8000325a:	4639                	li	a2,14
    8000325c:	ffffd097          	auipc	ra,0xffffd
    80003260:	0c0080e7          	jalr	192(ra) # 8000031c <strncmp>
}
    80003264:	60a2                	ld	ra,8(sp)
    80003266:	6402                	ld	s0,0(sp)
    80003268:	0141                	addi	sp,sp,16
    8000326a:	8082                	ret

000000008000326c <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    8000326c:	711d                	addi	sp,sp,-96
    8000326e:	ec86                	sd	ra,88(sp)
    80003270:	e8a2                	sd	s0,80(sp)
    80003272:	e4a6                	sd	s1,72(sp)
    80003274:	e0ca                	sd	s2,64(sp)
    80003276:	fc4e                	sd	s3,56(sp)
    80003278:	f852                	sd	s4,48(sp)
    8000327a:	f456                	sd	s5,40(sp)
    8000327c:	f05a                	sd	s6,32(sp)
    8000327e:	ec5e                	sd	s7,24(sp)
    80003280:	1080                	addi	s0,sp,96
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003282:	04451703          	lh	a4,68(a0)
    80003286:	4785                	li	a5,1
    80003288:	00f71f63          	bne	a4,a5,800032a6 <dirlookup+0x3a>
    8000328c:	892a                	mv	s2,a0
    8000328e:	8aae                	mv	s5,a1
    80003290:	8bb2                	mv	s7,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003292:	457c                	lw	a5,76(a0)
    80003294:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003296:	fa040a13          	addi	s4,s0,-96
    8000329a:	49c1                	li	s3,16
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
    8000329c:	fa240b13          	addi	s6,s0,-94
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800032a0:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032a2:	e79d                	bnez	a5,800032d0 <dirlookup+0x64>
    800032a4:	a88d                	j	80003316 <dirlookup+0xaa>
    panic("dirlookup not DIR");
    800032a6:	00005517          	auipc	a0,0x5
    800032aa:	1f250513          	addi	a0,a0,498 # 80008498 <etext+0x498>
    800032ae:	00003097          	auipc	ra,0x3
    800032b2:	c84080e7          	jalr	-892(ra) # 80005f32 <panic>
      panic("dirlookup read");
    800032b6:	00005517          	auipc	a0,0x5
    800032ba:	1fa50513          	addi	a0,a0,506 # 800084b0 <etext+0x4b0>
    800032be:	00003097          	auipc	ra,0x3
    800032c2:	c74080e7          	jalr	-908(ra) # 80005f32 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032c6:	24c1                	addiw	s1,s1,16
    800032c8:	04c92783          	lw	a5,76(s2)
    800032cc:	04f4f463          	bgeu	s1,a5,80003314 <dirlookup+0xa8>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800032d0:	874e                	mv	a4,s3
    800032d2:	86a6                	mv	a3,s1
    800032d4:	8652                	mv	a2,s4
    800032d6:	4581                	li	a1,0
    800032d8:	854a                	mv	a0,s2
    800032da:	00000097          	auipc	ra,0x0
    800032de:	d5e080e7          	jalr	-674(ra) # 80003038 <readi>
    800032e2:	fd351ae3          	bne	a0,s3,800032b6 <dirlookup+0x4a>
    if(de.inum == 0)
    800032e6:	fa045783          	lhu	a5,-96(s0)
    800032ea:	dff1                	beqz	a5,800032c6 <dirlookup+0x5a>
    if(namecmp(name, de.name) == 0){
    800032ec:	85da                	mv	a1,s6
    800032ee:	8556                	mv	a0,s5
    800032f0:	00000097          	auipc	ra,0x0
    800032f4:	f62080e7          	jalr	-158(ra) # 80003252 <namecmp>
    800032f8:	f579                	bnez	a0,800032c6 <dirlookup+0x5a>
      if(poff)
    800032fa:	000b8463          	beqz	s7,80003302 <dirlookup+0x96>
        *poff = off;
    800032fe:	009ba023          	sw	s1,0(s7)
      return iget(dp->dev, inum);
    80003302:	fa045583          	lhu	a1,-96(s0)
    80003306:	00092503          	lw	a0,0(s2)
    8000330a:	fffff097          	auipc	ra,0xfffff
    8000330e:	742080e7          	jalr	1858(ra) # 80002a4c <iget>
    80003312:	a011                	j	80003316 <dirlookup+0xaa>
  return 0;
    80003314:	4501                	li	a0,0
}
    80003316:	60e6                	ld	ra,88(sp)
    80003318:	6446                	ld	s0,80(sp)
    8000331a:	64a6                	ld	s1,72(sp)
    8000331c:	6906                	ld	s2,64(sp)
    8000331e:	79e2                	ld	s3,56(sp)
    80003320:	7a42                	ld	s4,48(sp)
    80003322:	7aa2                	ld	s5,40(sp)
    80003324:	7b02                	ld	s6,32(sp)
    80003326:	6be2                	ld	s7,24(sp)
    80003328:	6125                	addi	sp,sp,96
    8000332a:	8082                	ret

000000008000332c <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    8000332c:	711d                	addi	sp,sp,-96
    8000332e:	ec86                	sd	ra,88(sp)
    80003330:	e8a2                	sd	s0,80(sp)
    80003332:	e4a6                	sd	s1,72(sp)
    80003334:	e0ca                	sd	s2,64(sp)
    80003336:	fc4e                	sd	s3,56(sp)
    80003338:	f852                	sd	s4,48(sp)
    8000333a:	f456                	sd	s5,40(sp)
    8000333c:	f05a                	sd	s6,32(sp)
    8000333e:	ec5e                	sd	s7,24(sp)
    80003340:	e862                	sd	s8,16(sp)
    80003342:	e466                	sd	s9,8(sp)
    80003344:	e06a                	sd	s10,0(sp)
    80003346:	1080                	addi	s0,sp,96
    80003348:	84aa                	mv	s1,a0
    8000334a:	8b2e                	mv	s6,a1
    8000334c:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    8000334e:	00054703          	lbu	a4,0(a0)
    80003352:	02f00793          	li	a5,47
    80003356:	02f70363          	beq	a4,a5,8000337c <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    8000335a:	ffffe097          	auipc	ra,0xffffe
    8000335e:	d10080e7          	jalr	-752(ra) # 8000106a <myproc>
    80003362:	15053503          	ld	a0,336(a0)
    80003366:	00000097          	auipc	ra,0x0
    8000336a:	9d8080e7          	jalr	-1576(ra) # 80002d3e <idup>
    8000336e:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003370:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003374:	4c35                	li	s8,13
    memmove(name, s, DIRSIZ);
    80003376:	4cb9                	li	s9,14

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003378:	4b85                	li	s7,1
    8000337a:	a87d                	j	80003438 <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    8000337c:	4585                	li	a1,1
    8000337e:	852e                	mv	a0,a1
    80003380:	fffff097          	auipc	ra,0xfffff
    80003384:	6cc080e7          	jalr	1740(ra) # 80002a4c <iget>
    80003388:	8a2a                	mv	s4,a0
    8000338a:	b7dd                	j	80003370 <namex+0x44>
      iunlockput(ip);
    8000338c:	8552                	mv	a0,s4
    8000338e:	00000097          	auipc	ra,0x0
    80003392:	c54080e7          	jalr	-940(ra) # 80002fe2 <iunlockput>
      return 0;
    80003396:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003398:	8552                	mv	a0,s4
    8000339a:	60e6                	ld	ra,88(sp)
    8000339c:	6446                	ld	s0,80(sp)
    8000339e:	64a6                	ld	s1,72(sp)
    800033a0:	6906                	ld	s2,64(sp)
    800033a2:	79e2                	ld	s3,56(sp)
    800033a4:	7a42                	ld	s4,48(sp)
    800033a6:	7aa2                	ld	s5,40(sp)
    800033a8:	7b02                	ld	s6,32(sp)
    800033aa:	6be2                	ld	s7,24(sp)
    800033ac:	6c42                	ld	s8,16(sp)
    800033ae:	6ca2                	ld	s9,8(sp)
    800033b0:	6d02                	ld	s10,0(sp)
    800033b2:	6125                	addi	sp,sp,96
    800033b4:	8082                	ret
      iunlock(ip);
    800033b6:	8552                	mv	a0,s4
    800033b8:	00000097          	auipc	ra,0x0
    800033bc:	a8a080e7          	jalr	-1398(ra) # 80002e42 <iunlock>
      return ip;
    800033c0:	bfe1                	j	80003398 <namex+0x6c>
      iunlockput(ip);
    800033c2:	8552                	mv	a0,s4
    800033c4:	00000097          	auipc	ra,0x0
    800033c8:	c1e080e7          	jalr	-994(ra) # 80002fe2 <iunlockput>
      return 0;
    800033cc:	8a4e                	mv	s4,s3
    800033ce:	b7e9                	j	80003398 <namex+0x6c>
  len = path - s;
    800033d0:	40998633          	sub	a2,s3,s1
    800033d4:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    800033d8:	09ac5863          	bge	s8,s10,80003468 <namex+0x13c>
    memmove(name, s, DIRSIZ);
    800033dc:	8666                	mv	a2,s9
    800033de:	85a6                	mv	a1,s1
    800033e0:	8556                	mv	a0,s5
    800033e2:	ffffd097          	auipc	ra,0xffffd
    800033e6:	ec2080e7          	jalr	-318(ra) # 800002a4 <memmove>
    800033ea:	84ce                	mv	s1,s3
  while(*path == '/')
    800033ec:	0004c783          	lbu	a5,0(s1)
    800033f0:	01279763          	bne	a5,s2,800033fe <namex+0xd2>
    path++;
    800033f4:	0485                	addi	s1,s1,1
  while(*path == '/')
    800033f6:	0004c783          	lbu	a5,0(s1)
    800033fa:	ff278de3          	beq	a5,s2,800033f4 <namex+0xc8>
    ilock(ip);
    800033fe:	8552                	mv	a0,s4
    80003400:	00000097          	auipc	ra,0x0
    80003404:	97c080e7          	jalr	-1668(ra) # 80002d7c <ilock>
    if(ip->type != T_DIR){
    80003408:	044a1783          	lh	a5,68(s4)
    8000340c:	f97790e3          	bne	a5,s7,8000338c <namex+0x60>
    if(nameiparent && *path == '\0'){
    80003410:	000b0563          	beqz	s6,8000341a <namex+0xee>
    80003414:	0004c783          	lbu	a5,0(s1)
    80003418:	dfd9                	beqz	a5,800033b6 <namex+0x8a>
    if((next = dirlookup(ip, name, 0)) == 0){
    8000341a:	4601                	li	a2,0
    8000341c:	85d6                	mv	a1,s5
    8000341e:	8552                	mv	a0,s4
    80003420:	00000097          	auipc	ra,0x0
    80003424:	e4c080e7          	jalr	-436(ra) # 8000326c <dirlookup>
    80003428:	89aa                	mv	s3,a0
    8000342a:	dd41                	beqz	a0,800033c2 <namex+0x96>
    iunlockput(ip);
    8000342c:	8552                	mv	a0,s4
    8000342e:	00000097          	auipc	ra,0x0
    80003432:	bb4080e7          	jalr	-1100(ra) # 80002fe2 <iunlockput>
    ip = next;
    80003436:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003438:	0004c783          	lbu	a5,0(s1)
    8000343c:	01279763          	bne	a5,s2,8000344a <namex+0x11e>
    path++;
    80003440:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003442:	0004c783          	lbu	a5,0(s1)
    80003446:	ff278de3          	beq	a5,s2,80003440 <namex+0x114>
  if(*path == 0)
    8000344a:	cb9d                	beqz	a5,80003480 <namex+0x154>
  while(*path != '/' && *path != 0)
    8000344c:	0004c783          	lbu	a5,0(s1)
    80003450:	89a6                	mv	s3,s1
  len = path - s;
    80003452:	4d01                	li	s10,0
    80003454:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80003456:	01278963          	beq	a5,s2,80003468 <namex+0x13c>
    8000345a:	dbbd                	beqz	a5,800033d0 <namex+0xa4>
    path++;
    8000345c:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    8000345e:	0009c783          	lbu	a5,0(s3)
    80003462:	ff279ce3          	bne	a5,s2,8000345a <namex+0x12e>
    80003466:	b7ad                	j	800033d0 <namex+0xa4>
    memmove(name, s, len);
    80003468:	2601                	sext.w	a2,a2
    8000346a:	85a6                	mv	a1,s1
    8000346c:	8556                	mv	a0,s5
    8000346e:	ffffd097          	auipc	ra,0xffffd
    80003472:	e36080e7          	jalr	-458(ra) # 800002a4 <memmove>
    name[len] = 0;
    80003476:	9d56                	add	s10,s10,s5
    80003478:	000d0023          	sb	zero,0(s10) # fffffffffffff000 <end+0xffffffff7fdb8dc0>
    8000347c:	84ce                	mv	s1,s3
    8000347e:	b7bd                	j	800033ec <namex+0xc0>
  if(nameiparent){
    80003480:	f00b0ce3          	beqz	s6,80003398 <namex+0x6c>
    iput(ip);
    80003484:	8552                	mv	a0,s4
    80003486:	00000097          	auipc	ra,0x0
    8000348a:	ab4080e7          	jalr	-1356(ra) # 80002f3a <iput>
    return 0;
    8000348e:	4a01                	li	s4,0
    80003490:	b721                	j	80003398 <namex+0x6c>

0000000080003492 <dirlink>:
{
    80003492:	715d                	addi	sp,sp,-80
    80003494:	e486                	sd	ra,72(sp)
    80003496:	e0a2                	sd	s0,64(sp)
    80003498:	f84a                	sd	s2,48(sp)
    8000349a:	ec56                	sd	s5,24(sp)
    8000349c:	e85a                	sd	s6,16(sp)
    8000349e:	0880                	addi	s0,sp,80
    800034a0:	892a                	mv	s2,a0
    800034a2:	8aae                	mv	s5,a1
    800034a4:	8b32                	mv	s6,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800034a6:	4601                	li	a2,0
    800034a8:	00000097          	auipc	ra,0x0
    800034ac:	dc4080e7          	jalr	-572(ra) # 8000326c <dirlookup>
    800034b0:	e129                	bnez	a0,800034f2 <dirlink+0x60>
    800034b2:	fc26                	sd	s1,56(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    800034b4:	04c92483          	lw	s1,76(s2)
    800034b8:	cca9                	beqz	s1,80003512 <dirlink+0x80>
    800034ba:	f44e                	sd	s3,40(sp)
    800034bc:	f052                	sd	s4,32(sp)
    800034be:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800034c0:	fb040a13          	addi	s4,s0,-80
    800034c4:	49c1                	li	s3,16
    800034c6:	874e                	mv	a4,s3
    800034c8:	86a6                	mv	a3,s1
    800034ca:	8652                	mv	a2,s4
    800034cc:	4581                	li	a1,0
    800034ce:	854a                	mv	a0,s2
    800034d0:	00000097          	auipc	ra,0x0
    800034d4:	b68080e7          	jalr	-1176(ra) # 80003038 <readi>
    800034d8:	03351363          	bne	a0,s3,800034fe <dirlink+0x6c>
    if(de.inum == 0)
    800034dc:	fb045783          	lhu	a5,-80(s0)
    800034e0:	c79d                	beqz	a5,8000350e <dirlink+0x7c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800034e2:	24c1                	addiw	s1,s1,16
    800034e4:	04c92783          	lw	a5,76(s2)
    800034e8:	fcf4efe3          	bltu	s1,a5,800034c6 <dirlink+0x34>
    800034ec:	79a2                	ld	s3,40(sp)
    800034ee:	7a02                	ld	s4,32(sp)
    800034f0:	a00d                	j	80003512 <dirlink+0x80>
    iput(ip);
    800034f2:	00000097          	auipc	ra,0x0
    800034f6:	a48080e7          	jalr	-1464(ra) # 80002f3a <iput>
    return -1;
    800034fa:	557d                	li	a0,-1
    800034fc:	a0a9                	j	80003546 <dirlink+0xb4>
      panic("dirlink read");
    800034fe:	00005517          	auipc	a0,0x5
    80003502:	fc250513          	addi	a0,a0,-62 # 800084c0 <etext+0x4c0>
    80003506:	00003097          	auipc	ra,0x3
    8000350a:	a2c080e7          	jalr	-1492(ra) # 80005f32 <panic>
    8000350e:	79a2                	ld	s3,40(sp)
    80003510:	7a02                	ld	s4,32(sp)
  strncpy(de.name, name, DIRSIZ);
    80003512:	4639                	li	a2,14
    80003514:	85d6                	mv	a1,s5
    80003516:	fb240513          	addi	a0,s0,-78
    8000351a:	ffffd097          	auipc	ra,0xffffd
    8000351e:	e3c080e7          	jalr	-452(ra) # 80000356 <strncpy>
  de.inum = inum;
    80003522:	fb641823          	sh	s6,-80(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003526:	4741                	li	a4,16
    80003528:	86a6                	mv	a3,s1
    8000352a:	fb040613          	addi	a2,s0,-80
    8000352e:	4581                	li	a1,0
    80003530:	854a                	mv	a0,s2
    80003532:	00000097          	auipc	ra,0x0
    80003536:	c00080e7          	jalr	-1024(ra) # 80003132 <writei>
    8000353a:	872a                	mv	a4,a0
    8000353c:	47c1                	li	a5,16
  return 0;
    8000353e:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003540:	00f71a63          	bne	a4,a5,80003554 <dirlink+0xc2>
    80003544:	74e2                	ld	s1,56(sp)
}
    80003546:	60a6                	ld	ra,72(sp)
    80003548:	6406                	ld	s0,64(sp)
    8000354a:	7942                	ld	s2,48(sp)
    8000354c:	6ae2                	ld	s5,24(sp)
    8000354e:	6b42                	ld	s6,16(sp)
    80003550:	6161                	addi	sp,sp,80
    80003552:	8082                	ret
    80003554:	f44e                	sd	s3,40(sp)
    80003556:	f052                	sd	s4,32(sp)
    panic("dirlink");
    80003558:	00005517          	auipc	a0,0x5
    8000355c:	07850513          	addi	a0,a0,120 # 800085d0 <etext+0x5d0>
    80003560:	00003097          	auipc	ra,0x3
    80003564:	9d2080e7          	jalr	-1582(ra) # 80005f32 <panic>

0000000080003568 <namei>:

struct inode*
namei(char *path)
{
    80003568:	1101                	addi	sp,sp,-32
    8000356a:	ec06                	sd	ra,24(sp)
    8000356c:	e822                	sd	s0,16(sp)
    8000356e:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003570:	fe040613          	addi	a2,s0,-32
    80003574:	4581                	li	a1,0
    80003576:	00000097          	auipc	ra,0x0
    8000357a:	db6080e7          	jalr	-586(ra) # 8000332c <namex>
}
    8000357e:	60e2                	ld	ra,24(sp)
    80003580:	6442                	ld	s0,16(sp)
    80003582:	6105                	addi	sp,sp,32
    80003584:	8082                	ret

0000000080003586 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003586:	1141                	addi	sp,sp,-16
    80003588:	e406                	sd	ra,8(sp)
    8000358a:	e022                	sd	s0,0(sp)
    8000358c:	0800                	addi	s0,sp,16
    8000358e:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003590:	4585                	li	a1,1
    80003592:	00000097          	auipc	ra,0x0
    80003596:	d9a080e7          	jalr	-614(ra) # 8000332c <namex>
}
    8000359a:	60a2                	ld	ra,8(sp)
    8000359c:	6402                	ld	s0,0(sp)
    8000359e:	0141                	addi	sp,sp,16
    800035a0:	8082                	ret

00000000800035a2 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800035a2:	1101                	addi	sp,sp,-32
    800035a4:	ec06                	sd	ra,24(sp)
    800035a6:	e822                	sd	s0,16(sp)
    800035a8:	e426                	sd	s1,8(sp)
    800035aa:	e04a                	sd	s2,0(sp)
    800035ac:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800035ae:	00236917          	auipc	s2,0x236
    800035b2:	a8a90913          	addi	s2,s2,-1398 # 80239038 <log>
    800035b6:	01892583          	lw	a1,24(s2)
    800035ba:	02892503          	lw	a0,40(s2)
    800035be:	fffff097          	auipc	ra,0xfffff
    800035c2:	fe2080e7          	jalr	-30(ra) # 800025a0 <bread>
    800035c6:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800035c8:	02c92603          	lw	a2,44(s2)
    800035cc:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800035ce:	00c05f63          	blez	a2,800035ec <write_head+0x4a>
    800035d2:	00236717          	auipc	a4,0x236
    800035d6:	a9670713          	addi	a4,a4,-1386 # 80239068 <log+0x30>
    800035da:	87aa                	mv	a5,a0
    800035dc:	060a                	slli	a2,a2,0x2
    800035de:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    800035e0:	4314                	lw	a3,0(a4)
    800035e2:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    800035e4:	0711                	addi	a4,a4,4
    800035e6:	0791                	addi	a5,a5,4
    800035e8:	fec79ce3          	bne	a5,a2,800035e0 <write_head+0x3e>
  }
  bwrite(buf);
    800035ec:	8526                	mv	a0,s1
    800035ee:	fffff097          	auipc	ra,0xfffff
    800035f2:	0a4080e7          	jalr	164(ra) # 80002692 <bwrite>
  brelse(buf);
    800035f6:	8526                	mv	a0,s1
    800035f8:	fffff097          	auipc	ra,0xfffff
    800035fc:	0d8080e7          	jalr	216(ra) # 800026d0 <brelse>
}
    80003600:	60e2                	ld	ra,24(sp)
    80003602:	6442                	ld	s0,16(sp)
    80003604:	64a2                	ld	s1,8(sp)
    80003606:	6902                	ld	s2,0(sp)
    80003608:	6105                	addi	sp,sp,32
    8000360a:	8082                	ret

000000008000360c <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000360c:	00236797          	auipc	a5,0x236
    80003610:	a587a783          	lw	a5,-1448(a5) # 80239064 <log+0x2c>
    80003614:	0cf05063          	blez	a5,800036d4 <install_trans+0xc8>
{
    80003618:	715d                	addi	sp,sp,-80
    8000361a:	e486                	sd	ra,72(sp)
    8000361c:	e0a2                	sd	s0,64(sp)
    8000361e:	fc26                	sd	s1,56(sp)
    80003620:	f84a                	sd	s2,48(sp)
    80003622:	f44e                	sd	s3,40(sp)
    80003624:	f052                	sd	s4,32(sp)
    80003626:	ec56                	sd	s5,24(sp)
    80003628:	e85a                	sd	s6,16(sp)
    8000362a:	e45e                	sd	s7,8(sp)
    8000362c:	0880                	addi	s0,sp,80
    8000362e:	8b2a                	mv	s6,a0
    80003630:	00236a97          	auipc	s5,0x236
    80003634:	a38a8a93          	addi	s5,s5,-1480 # 80239068 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003638:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000363a:	00236997          	auipc	s3,0x236
    8000363e:	9fe98993          	addi	s3,s3,-1538 # 80239038 <log>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003642:	40000b93          	li	s7,1024
    80003646:	a00d                	j	80003668 <install_trans+0x5c>
    brelse(lbuf);
    80003648:	854a                	mv	a0,s2
    8000364a:	fffff097          	auipc	ra,0xfffff
    8000364e:	086080e7          	jalr	134(ra) # 800026d0 <brelse>
    brelse(dbuf);
    80003652:	8526                	mv	a0,s1
    80003654:	fffff097          	auipc	ra,0xfffff
    80003658:	07c080e7          	jalr	124(ra) # 800026d0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000365c:	2a05                	addiw	s4,s4,1
    8000365e:	0a91                	addi	s5,s5,4
    80003660:	02c9a783          	lw	a5,44(s3)
    80003664:	04fa5d63          	bge	s4,a5,800036be <install_trans+0xb2>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003668:	0189a583          	lw	a1,24(s3)
    8000366c:	014585bb          	addw	a1,a1,s4
    80003670:	2585                	addiw	a1,a1,1
    80003672:	0289a503          	lw	a0,40(s3)
    80003676:	fffff097          	auipc	ra,0xfffff
    8000367a:	f2a080e7          	jalr	-214(ra) # 800025a0 <bread>
    8000367e:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003680:	000aa583          	lw	a1,0(s5)
    80003684:	0289a503          	lw	a0,40(s3)
    80003688:	fffff097          	auipc	ra,0xfffff
    8000368c:	f18080e7          	jalr	-232(ra) # 800025a0 <bread>
    80003690:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003692:	865e                	mv	a2,s7
    80003694:	05890593          	addi	a1,s2,88
    80003698:	05850513          	addi	a0,a0,88
    8000369c:	ffffd097          	auipc	ra,0xffffd
    800036a0:	c08080e7          	jalr	-1016(ra) # 800002a4 <memmove>
    bwrite(dbuf);  // write dst to disk
    800036a4:	8526                	mv	a0,s1
    800036a6:	fffff097          	auipc	ra,0xfffff
    800036aa:	fec080e7          	jalr	-20(ra) # 80002692 <bwrite>
    if(recovering == 0)
    800036ae:	f80b1de3          	bnez	s6,80003648 <install_trans+0x3c>
      bunpin(dbuf);
    800036b2:	8526                	mv	a0,s1
    800036b4:	fffff097          	auipc	ra,0xfffff
    800036b8:	0f0080e7          	jalr	240(ra) # 800027a4 <bunpin>
    800036bc:	b771                	j	80003648 <install_trans+0x3c>
}
    800036be:	60a6                	ld	ra,72(sp)
    800036c0:	6406                	ld	s0,64(sp)
    800036c2:	74e2                	ld	s1,56(sp)
    800036c4:	7942                	ld	s2,48(sp)
    800036c6:	79a2                	ld	s3,40(sp)
    800036c8:	7a02                	ld	s4,32(sp)
    800036ca:	6ae2                	ld	s5,24(sp)
    800036cc:	6b42                	ld	s6,16(sp)
    800036ce:	6ba2                	ld	s7,8(sp)
    800036d0:	6161                	addi	sp,sp,80
    800036d2:	8082                	ret
    800036d4:	8082                	ret

00000000800036d6 <initlog>:
{
    800036d6:	7179                	addi	sp,sp,-48
    800036d8:	f406                	sd	ra,40(sp)
    800036da:	f022                	sd	s0,32(sp)
    800036dc:	ec26                	sd	s1,24(sp)
    800036de:	e84a                	sd	s2,16(sp)
    800036e0:	e44e                	sd	s3,8(sp)
    800036e2:	1800                	addi	s0,sp,48
    800036e4:	892a                	mv	s2,a0
    800036e6:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800036e8:	00236497          	auipc	s1,0x236
    800036ec:	95048493          	addi	s1,s1,-1712 # 80239038 <log>
    800036f0:	00005597          	auipc	a1,0x5
    800036f4:	de058593          	addi	a1,a1,-544 # 800084d0 <etext+0x4d0>
    800036f8:	8526                	mv	a0,s1
    800036fa:	00003097          	auipc	ra,0x3
    800036fe:	d24080e7          	jalr	-732(ra) # 8000641e <initlock>
  log.start = sb->logstart;
    80003702:	0149a583          	lw	a1,20(s3)
    80003706:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003708:	0109a783          	lw	a5,16(s3)
    8000370c:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    8000370e:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003712:	854a                	mv	a0,s2
    80003714:	fffff097          	auipc	ra,0xfffff
    80003718:	e8c080e7          	jalr	-372(ra) # 800025a0 <bread>
  log.lh.n = lh->n;
    8000371c:	4d30                	lw	a2,88(a0)
    8000371e:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003720:	00c05f63          	blez	a2,8000373e <initlog+0x68>
    80003724:	87aa                	mv	a5,a0
    80003726:	00236717          	auipc	a4,0x236
    8000372a:	94270713          	addi	a4,a4,-1726 # 80239068 <log+0x30>
    8000372e:	060a                	slli	a2,a2,0x2
    80003730:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003732:	4ff4                	lw	a3,92(a5)
    80003734:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003736:	0791                	addi	a5,a5,4
    80003738:	0711                	addi	a4,a4,4
    8000373a:	fec79ce3          	bne	a5,a2,80003732 <initlog+0x5c>
  brelse(buf);
    8000373e:	fffff097          	auipc	ra,0xfffff
    80003742:	f92080e7          	jalr	-110(ra) # 800026d0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003746:	4505                	li	a0,1
    80003748:	00000097          	auipc	ra,0x0
    8000374c:	ec4080e7          	jalr	-316(ra) # 8000360c <install_trans>
  log.lh.n = 0;
    80003750:	00236797          	auipc	a5,0x236
    80003754:	9007aa23          	sw	zero,-1772(a5) # 80239064 <log+0x2c>
  write_head(); // clear the log
    80003758:	00000097          	auipc	ra,0x0
    8000375c:	e4a080e7          	jalr	-438(ra) # 800035a2 <write_head>
}
    80003760:	70a2                	ld	ra,40(sp)
    80003762:	7402                	ld	s0,32(sp)
    80003764:	64e2                	ld	s1,24(sp)
    80003766:	6942                	ld	s2,16(sp)
    80003768:	69a2                	ld	s3,8(sp)
    8000376a:	6145                	addi	sp,sp,48
    8000376c:	8082                	ret

000000008000376e <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    8000376e:	1101                	addi	sp,sp,-32
    80003770:	ec06                	sd	ra,24(sp)
    80003772:	e822                	sd	s0,16(sp)
    80003774:	e426                	sd	s1,8(sp)
    80003776:	e04a                	sd	s2,0(sp)
    80003778:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    8000377a:	00236517          	auipc	a0,0x236
    8000377e:	8be50513          	addi	a0,a0,-1858 # 80239038 <log>
    80003782:	00003097          	auipc	ra,0x3
    80003786:	d30080e7          	jalr	-720(ra) # 800064b2 <acquire>
  while(1){
    if(log.committing){
    8000378a:	00236497          	auipc	s1,0x236
    8000378e:	8ae48493          	addi	s1,s1,-1874 # 80239038 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003792:	4979                	li	s2,30
    80003794:	a039                	j	800037a2 <begin_op+0x34>
      sleep(&log, &log.lock);
    80003796:	85a6                	mv	a1,s1
    80003798:	8526                	mv	a0,s1
    8000379a:	ffffe097          	auipc	ra,0xffffe
    8000379e:	f96080e7          	jalr	-106(ra) # 80001730 <sleep>
    if(log.committing){
    800037a2:	50dc                	lw	a5,36(s1)
    800037a4:	fbed                	bnez	a5,80003796 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800037a6:	5098                	lw	a4,32(s1)
    800037a8:	2705                	addiw	a4,a4,1
    800037aa:	0027179b          	slliw	a5,a4,0x2
    800037ae:	9fb9                	addw	a5,a5,a4
    800037b0:	0017979b          	slliw	a5,a5,0x1
    800037b4:	54d4                	lw	a3,44(s1)
    800037b6:	9fb5                	addw	a5,a5,a3
    800037b8:	00f95963          	bge	s2,a5,800037ca <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800037bc:	85a6                	mv	a1,s1
    800037be:	8526                	mv	a0,s1
    800037c0:	ffffe097          	auipc	ra,0xffffe
    800037c4:	f70080e7          	jalr	-144(ra) # 80001730 <sleep>
    800037c8:	bfe9                	j	800037a2 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800037ca:	00236517          	auipc	a0,0x236
    800037ce:	86e50513          	addi	a0,a0,-1938 # 80239038 <log>
    800037d2:	d118                	sw	a4,32(a0)
      release(&log.lock);
    800037d4:	00003097          	auipc	ra,0x3
    800037d8:	d8e080e7          	jalr	-626(ra) # 80006562 <release>
      break;
    }
  }
}
    800037dc:	60e2                	ld	ra,24(sp)
    800037de:	6442                	ld	s0,16(sp)
    800037e0:	64a2                	ld	s1,8(sp)
    800037e2:	6902                	ld	s2,0(sp)
    800037e4:	6105                	addi	sp,sp,32
    800037e6:	8082                	ret

00000000800037e8 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800037e8:	7139                	addi	sp,sp,-64
    800037ea:	fc06                	sd	ra,56(sp)
    800037ec:	f822                	sd	s0,48(sp)
    800037ee:	f426                	sd	s1,40(sp)
    800037f0:	f04a                	sd	s2,32(sp)
    800037f2:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800037f4:	00236497          	auipc	s1,0x236
    800037f8:	84448493          	addi	s1,s1,-1980 # 80239038 <log>
    800037fc:	8526                	mv	a0,s1
    800037fe:	00003097          	auipc	ra,0x3
    80003802:	cb4080e7          	jalr	-844(ra) # 800064b2 <acquire>
  log.outstanding -= 1;
    80003806:	509c                	lw	a5,32(s1)
    80003808:	37fd                	addiw	a5,a5,-1
    8000380a:	893e                	mv	s2,a5
    8000380c:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000380e:	50dc                	lw	a5,36(s1)
    80003810:	e7b9                	bnez	a5,8000385e <end_op+0x76>
    panic("log.committing");
  if(log.outstanding == 0){
    80003812:	06091263          	bnez	s2,80003876 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80003816:	00236497          	auipc	s1,0x236
    8000381a:	82248493          	addi	s1,s1,-2014 # 80239038 <log>
    8000381e:	4785                	li	a5,1
    80003820:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003822:	8526                	mv	a0,s1
    80003824:	00003097          	auipc	ra,0x3
    80003828:	d3e080e7          	jalr	-706(ra) # 80006562 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000382c:	54dc                	lw	a5,44(s1)
    8000382e:	06f04863          	bgtz	a5,8000389e <end_op+0xb6>
    acquire(&log.lock);
    80003832:	00236497          	auipc	s1,0x236
    80003836:	80648493          	addi	s1,s1,-2042 # 80239038 <log>
    8000383a:	8526                	mv	a0,s1
    8000383c:	00003097          	auipc	ra,0x3
    80003840:	c76080e7          	jalr	-906(ra) # 800064b2 <acquire>
    log.committing = 0;
    80003844:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003848:	8526                	mv	a0,s1
    8000384a:	ffffe097          	auipc	ra,0xffffe
    8000384e:	06c080e7          	jalr	108(ra) # 800018b6 <wakeup>
    release(&log.lock);
    80003852:	8526                	mv	a0,s1
    80003854:	00003097          	auipc	ra,0x3
    80003858:	d0e080e7          	jalr	-754(ra) # 80006562 <release>
}
    8000385c:	a81d                	j	80003892 <end_op+0xaa>
    8000385e:	ec4e                	sd	s3,24(sp)
    80003860:	e852                	sd	s4,16(sp)
    80003862:	e456                	sd	s5,8(sp)
    80003864:	e05a                	sd	s6,0(sp)
    panic("log.committing");
    80003866:	00005517          	auipc	a0,0x5
    8000386a:	c7250513          	addi	a0,a0,-910 # 800084d8 <etext+0x4d8>
    8000386e:	00002097          	auipc	ra,0x2
    80003872:	6c4080e7          	jalr	1732(ra) # 80005f32 <panic>
    wakeup(&log);
    80003876:	00235497          	auipc	s1,0x235
    8000387a:	7c248493          	addi	s1,s1,1986 # 80239038 <log>
    8000387e:	8526                	mv	a0,s1
    80003880:	ffffe097          	auipc	ra,0xffffe
    80003884:	036080e7          	jalr	54(ra) # 800018b6 <wakeup>
  release(&log.lock);
    80003888:	8526                	mv	a0,s1
    8000388a:	00003097          	auipc	ra,0x3
    8000388e:	cd8080e7          	jalr	-808(ra) # 80006562 <release>
}
    80003892:	70e2                	ld	ra,56(sp)
    80003894:	7442                	ld	s0,48(sp)
    80003896:	74a2                	ld	s1,40(sp)
    80003898:	7902                	ld	s2,32(sp)
    8000389a:	6121                	addi	sp,sp,64
    8000389c:	8082                	ret
    8000389e:	ec4e                	sd	s3,24(sp)
    800038a0:	e852                	sd	s4,16(sp)
    800038a2:	e456                	sd	s5,8(sp)
    800038a4:	e05a                	sd	s6,0(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    800038a6:	00235a97          	auipc	s5,0x235
    800038aa:	7c2a8a93          	addi	s5,s5,1986 # 80239068 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800038ae:	00235a17          	auipc	s4,0x235
    800038b2:	78aa0a13          	addi	s4,s4,1930 # 80239038 <log>
    memmove(to->data, from->data, BSIZE);
    800038b6:	40000b13          	li	s6,1024
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800038ba:	018a2583          	lw	a1,24(s4)
    800038be:	012585bb          	addw	a1,a1,s2
    800038c2:	2585                	addiw	a1,a1,1
    800038c4:	028a2503          	lw	a0,40(s4)
    800038c8:	fffff097          	auipc	ra,0xfffff
    800038cc:	cd8080e7          	jalr	-808(ra) # 800025a0 <bread>
    800038d0:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800038d2:	000aa583          	lw	a1,0(s5)
    800038d6:	028a2503          	lw	a0,40(s4)
    800038da:	fffff097          	auipc	ra,0xfffff
    800038de:	cc6080e7          	jalr	-826(ra) # 800025a0 <bread>
    800038e2:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800038e4:	865a                	mv	a2,s6
    800038e6:	05850593          	addi	a1,a0,88
    800038ea:	05848513          	addi	a0,s1,88
    800038ee:	ffffd097          	auipc	ra,0xffffd
    800038f2:	9b6080e7          	jalr	-1610(ra) # 800002a4 <memmove>
    bwrite(to);  // write the log
    800038f6:	8526                	mv	a0,s1
    800038f8:	fffff097          	auipc	ra,0xfffff
    800038fc:	d9a080e7          	jalr	-614(ra) # 80002692 <bwrite>
    brelse(from);
    80003900:	854e                	mv	a0,s3
    80003902:	fffff097          	auipc	ra,0xfffff
    80003906:	dce080e7          	jalr	-562(ra) # 800026d0 <brelse>
    brelse(to);
    8000390a:	8526                	mv	a0,s1
    8000390c:	fffff097          	auipc	ra,0xfffff
    80003910:	dc4080e7          	jalr	-572(ra) # 800026d0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003914:	2905                	addiw	s2,s2,1
    80003916:	0a91                	addi	s5,s5,4
    80003918:	02ca2783          	lw	a5,44(s4)
    8000391c:	f8f94fe3          	blt	s2,a5,800038ba <end_op+0xd2>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003920:	00000097          	auipc	ra,0x0
    80003924:	c82080e7          	jalr	-894(ra) # 800035a2 <write_head>
    install_trans(0); // Now install writes to home locations
    80003928:	4501                	li	a0,0
    8000392a:	00000097          	auipc	ra,0x0
    8000392e:	ce2080e7          	jalr	-798(ra) # 8000360c <install_trans>
    log.lh.n = 0;
    80003932:	00235797          	auipc	a5,0x235
    80003936:	7207a923          	sw	zero,1842(a5) # 80239064 <log+0x2c>
    write_head();    // Erase the transaction from the log
    8000393a:	00000097          	auipc	ra,0x0
    8000393e:	c68080e7          	jalr	-920(ra) # 800035a2 <write_head>
    80003942:	69e2                	ld	s3,24(sp)
    80003944:	6a42                	ld	s4,16(sp)
    80003946:	6aa2                	ld	s5,8(sp)
    80003948:	6b02                	ld	s6,0(sp)
    8000394a:	b5e5                	j	80003832 <end_op+0x4a>

000000008000394c <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000394c:	1101                	addi	sp,sp,-32
    8000394e:	ec06                	sd	ra,24(sp)
    80003950:	e822                	sd	s0,16(sp)
    80003952:	e426                	sd	s1,8(sp)
    80003954:	e04a                	sd	s2,0(sp)
    80003956:	1000                	addi	s0,sp,32
    80003958:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000395a:	00235917          	auipc	s2,0x235
    8000395e:	6de90913          	addi	s2,s2,1758 # 80239038 <log>
    80003962:	854a                	mv	a0,s2
    80003964:	00003097          	auipc	ra,0x3
    80003968:	b4e080e7          	jalr	-1202(ra) # 800064b2 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    8000396c:	02c92603          	lw	a2,44(s2)
    80003970:	47f5                	li	a5,29
    80003972:	06c7c563          	blt	a5,a2,800039dc <log_write+0x90>
    80003976:	00235797          	auipc	a5,0x235
    8000397a:	6de7a783          	lw	a5,1758(a5) # 80239054 <log+0x1c>
    8000397e:	37fd                	addiw	a5,a5,-1
    80003980:	04f65e63          	bge	a2,a5,800039dc <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003984:	00235797          	auipc	a5,0x235
    80003988:	6d47a783          	lw	a5,1748(a5) # 80239058 <log+0x20>
    8000398c:	06f05063          	blez	a5,800039ec <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003990:	4781                	li	a5,0
    80003992:	06c05563          	blez	a2,800039fc <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003996:	44cc                	lw	a1,12(s1)
    80003998:	00235717          	auipc	a4,0x235
    8000399c:	6d070713          	addi	a4,a4,1744 # 80239068 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800039a0:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800039a2:	4314                	lw	a3,0(a4)
    800039a4:	04b68c63          	beq	a3,a1,800039fc <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800039a8:	2785                	addiw	a5,a5,1
    800039aa:	0711                	addi	a4,a4,4
    800039ac:	fef61be3          	bne	a2,a5,800039a2 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800039b0:	0621                	addi	a2,a2,8
    800039b2:	060a                	slli	a2,a2,0x2
    800039b4:	00235797          	auipc	a5,0x235
    800039b8:	68478793          	addi	a5,a5,1668 # 80239038 <log>
    800039bc:	97b2                	add	a5,a5,a2
    800039be:	44d8                	lw	a4,12(s1)
    800039c0:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800039c2:	8526                	mv	a0,s1
    800039c4:	fffff097          	auipc	ra,0xfffff
    800039c8:	da4080e7          	jalr	-604(ra) # 80002768 <bpin>
    log.lh.n++;
    800039cc:	00235717          	auipc	a4,0x235
    800039d0:	66c70713          	addi	a4,a4,1644 # 80239038 <log>
    800039d4:	575c                	lw	a5,44(a4)
    800039d6:	2785                	addiw	a5,a5,1
    800039d8:	d75c                	sw	a5,44(a4)
    800039da:	a82d                	j	80003a14 <log_write+0xc8>
    panic("too big a transaction");
    800039dc:	00005517          	auipc	a0,0x5
    800039e0:	b0c50513          	addi	a0,a0,-1268 # 800084e8 <etext+0x4e8>
    800039e4:	00002097          	auipc	ra,0x2
    800039e8:	54e080e7          	jalr	1358(ra) # 80005f32 <panic>
    panic("log_write outside of trans");
    800039ec:	00005517          	auipc	a0,0x5
    800039f0:	b1450513          	addi	a0,a0,-1260 # 80008500 <etext+0x500>
    800039f4:	00002097          	auipc	ra,0x2
    800039f8:	53e080e7          	jalr	1342(ra) # 80005f32 <panic>
  log.lh.block[i] = b->blockno;
    800039fc:	00878693          	addi	a3,a5,8
    80003a00:	068a                	slli	a3,a3,0x2
    80003a02:	00235717          	auipc	a4,0x235
    80003a06:	63670713          	addi	a4,a4,1590 # 80239038 <log>
    80003a0a:	9736                	add	a4,a4,a3
    80003a0c:	44d4                	lw	a3,12(s1)
    80003a0e:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003a10:	faf609e3          	beq	a2,a5,800039c2 <log_write+0x76>
  }
  release(&log.lock);
    80003a14:	00235517          	auipc	a0,0x235
    80003a18:	62450513          	addi	a0,a0,1572 # 80239038 <log>
    80003a1c:	00003097          	auipc	ra,0x3
    80003a20:	b46080e7          	jalr	-1210(ra) # 80006562 <release>
}
    80003a24:	60e2                	ld	ra,24(sp)
    80003a26:	6442                	ld	s0,16(sp)
    80003a28:	64a2                	ld	s1,8(sp)
    80003a2a:	6902                	ld	s2,0(sp)
    80003a2c:	6105                	addi	sp,sp,32
    80003a2e:	8082                	ret

0000000080003a30 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003a30:	1101                	addi	sp,sp,-32
    80003a32:	ec06                	sd	ra,24(sp)
    80003a34:	e822                	sd	s0,16(sp)
    80003a36:	e426                	sd	s1,8(sp)
    80003a38:	e04a                	sd	s2,0(sp)
    80003a3a:	1000                	addi	s0,sp,32
    80003a3c:	84aa                	mv	s1,a0
    80003a3e:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003a40:	00005597          	auipc	a1,0x5
    80003a44:	ae058593          	addi	a1,a1,-1312 # 80008520 <etext+0x520>
    80003a48:	0521                	addi	a0,a0,8
    80003a4a:	00003097          	auipc	ra,0x3
    80003a4e:	9d4080e7          	jalr	-1580(ra) # 8000641e <initlock>
  lk->name = name;
    80003a52:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003a56:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003a5a:	0204a423          	sw	zero,40(s1)
}
    80003a5e:	60e2                	ld	ra,24(sp)
    80003a60:	6442                	ld	s0,16(sp)
    80003a62:	64a2                	ld	s1,8(sp)
    80003a64:	6902                	ld	s2,0(sp)
    80003a66:	6105                	addi	sp,sp,32
    80003a68:	8082                	ret

0000000080003a6a <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003a6a:	1101                	addi	sp,sp,-32
    80003a6c:	ec06                	sd	ra,24(sp)
    80003a6e:	e822                	sd	s0,16(sp)
    80003a70:	e426                	sd	s1,8(sp)
    80003a72:	e04a                	sd	s2,0(sp)
    80003a74:	1000                	addi	s0,sp,32
    80003a76:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003a78:	00850913          	addi	s2,a0,8
    80003a7c:	854a                	mv	a0,s2
    80003a7e:	00003097          	auipc	ra,0x3
    80003a82:	a34080e7          	jalr	-1484(ra) # 800064b2 <acquire>
  while (lk->locked) {
    80003a86:	409c                	lw	a5,0(s1)
    80003a88:	cb89                	beqz	a5,80003a9a <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003a8a:	85ca                	mv	a1,s2
    80003a8c:	8526                	mv	a0,s1
    80003a8e:	ffffe097          	auipc	ra,0xffffe
    80003a92:	ca2080e7          	jalr	-862(ra) # 80001730 <sleep>
  while (lk->locked) {
    80003a96:	409c                	lw	a5,0(s1)
    80003a98:	fbed                	bnez	a5,80003a8a <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003a9a:	4785                	li	a5,1
    80003a9c:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003a9e:	ffffd097          	auipc	ra,0xffffd
    80003aa2:	5cc080e7          	jalr	1484(ra) # 8000106a <myproc>
    80003aa6:	591c                	lw	a5,48(a0)
    80003aa8:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003aaa:	854a                	mv	a0,s2
    80003aac:	00003097          	auipc	ra,0x3
    80003ab0:	ab6080e7          	jalr	-1354(ra) # 80006562 <release>
}
    80003ab4:	60e2                	ld	ra,24(sp)
    80003ab6:	6442                	ld	s0,16(sp)
    80003ab8:	64a2                	ld	s1,8(sp)
    80003aba:	6902                	ld	s2,0(sp)
    80003abc:	6105                	addi	sp,sp,32
    80003abe:	8082                	ret

0000000080003ac0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003ac0:	1101                	addi	sp,sp,-32
    80003ac2:	ec06                	sd	ra,24(sp)
    80003ac4:	e822                	sd	s0,16(sp)
    80003ac6:	e426                	sd	s1,8(sp)
    80003ac8:	e04a                	sd	s2,0(sp)
    80003aca:	1000                	addi	s0,sp,32
    80003acc:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003ace:	00850913          	addi	s2,a0,8
    80003ad2:	854a                	mv	a0,s2
    80003ad4:	00003097          	auipc	ra,0x3
    80003ad8:	9de080e7          	jalr	-1570(ra) # 800064b2 <acquire>
  lk->locked = 0;
    80003adc:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003ae0:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003ae4:	8526                	mv	a0,s1
    80003ae6:	ffffe097          	auipc	ra,0xffffe
    80003aea:	dd0080e7          	jalr	-560(ra) # 800018b6 <wakeup>
  release(&lk->lk);
    80003aee:	854a                	mv	a0,s2
    80003af0:	00003097          	auipc	ra,0x3
    80003af4:	a72080e7          	jalr	-1422(ra) # 80006562 <release>
}
    80003af8:	60e2                	ld	ra,24(sp)
    80003afa:	6442                	ld	s0,16(sp)
    80003afc:	64a2                	ld	s1,8(sp)
    80003afe:	6902                	ld	s2,0(sp)
    80003b00:	6105                	addi	sp,sp,32
    80003b02:	8082                	ret

0000000080003b04 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003b04:	7179                	addi	sp,sp,-48
    80003b06:	f406                	sd	ra,40(sp)
    80003b08:	f022                	sd	s0,32(sp)
    80003b0a:	ec26                	sd	s1,24(sp)
    80003b0c:	e84a                	sd	s2,16(sp)
    80003b0e:	1800                	addi	s0,sp,48
    80003b10:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003b12:	00850913          	addi	s2,a0,8
    80003b16:	854a                	mv	a0,s2
    80003b18:	00003097          	auipc	ra,0x3
    80003b1c:	99a080e7          	jalr	-1638(ra) # 800064b2 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003b20:	409c                	lw	a5,0(s1)
    80003b22:	ef91                	bnez	a5,80003b3e <holdingsleep+0x3a>
    80003b24:	4481                	li	s1,0
  release(&lk->lk);
    80003b26:	854a                	mv	a0,s2
    80003b28:	00003097          	auipc	ra,0x3
    80003b2c:	a3a080e7          	jalr	-1478(ra) # 80006562 <release>
  return r;
}
    80003b30:	8526                	mv	a0,s1
    80003b32:	70a2                	ld	ra,40(sp)
    80003b34:	7402                	ld	s0,32(sp)
    80003b36:	64e2                	ld	s1,24(sp)
    80003b38:	6942                	ld	s2,16(sp)
    80003b3a:	6145                	addi	sp,sp,48
    80003b3c:	8082                	ret
    80003b3e:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80003b40:	0284a983          	lw	s3,40(s1)
    80003b44:	ffffd097          	auipc	ra,0xffffd
    80003b48:	526080e7          	jalr	1318(ra) # 8000106a <myproc>
    80003b4c:	5904                	lw	s1,48(a0)
    80003b4e:	413484b3          	sub	s1,s1,s3
    80003b52:	0014b493          	seqz	s1,s1
    80003b56:	69a2                	ld	s3,8(sp)
    80003b58:	b7f9                	j	80003b26 <holdingsleep+0x22>

0000000080003b5a <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003b5a:	1141                	addi	sp,sp,-16
    80003b5c:	e406                	sd	ra,8(sp)
    80003b5e:	e022                	sd	s0,0(sp)
    80003b60:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003b62:	00005597          	auipc	a1,0x5
    80003b66:	9ce58593          	addi	a1,a1,-1586 # 80008530 <etext+0x530>
    80003b6a:	00235517          	auipc	a0,0x235
    80003b6e:	61650513          	addi	a0,a0,1558 # 80239180 <ftable>
    80003b72:	00003097          	auipc	ra,0x3
    80003b76:	8ac080e7          	jalr	-1876(ra) # 8000641e <initlock>
}
    80003b7a:	60a2                	ld	ra,8(sp)
    80003b7c:	6402                	ld	s0,0(sp)
    80003b7e:	0141                	addi	sp,sp,16
    80003b80:	8082                	ret

0000000080003b82 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003b82:	1101                	addi	sp,sp,-32
    80003b84:	ec06                	sd	ra,24(sp)
    80003b86:	e822                	sd	s0,16(sp)
    80003b88:	e426                	sd	s1,8(sp)
    80003b8a:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003b8c:	00235517          	auipc	a0,0x235
    80003b90:	5f450513          	addi	a0,a0,1524 # 80239180 <ftable>
    80003b94:	00003097          	auipc	ra,0x3
    80003b98:	91e080e7          	jalr	-1762(ra) # 800064b2 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003b9c:	00235497          	auipc	s1,0x235
    80003ba0:	5fc48493          	addi	s1,s1,1532 # 80239198 <ftable+0x18>
    80003ba4:	00236717          	auipc	a4,0x236
    80003ba8:	59470713          	addi	a4,a4,1428 # 8023a138 <ftable+0xfb8>
    if(f->ref == 0){
    80003bac:	40dc                	lw	a5,4(s1)
    80003bae:	cf99                	beqz	a5,80003bcc <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003bb0:	02848493          	addi	s1,s1,40
    80003bb4:	fee49ce3          	bne	s1,a4,80003bac <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003bb8:	00235517          	auipc	a0,0x235
    80003bbc:	5c850513          	addi	a0,a0,1480 # 80239180 <ftable>
    80003bc0:	00003097          	auipc	ra,0x3
    80003bc4:	9a2080e7          	jalr	-1630(ra) # 80006562 <release>
  return 0;
    80003bc8:	4481                	li	s1,0
    80003bca:	a819                	j	80003be0 <filealloc+0x5e>
      f->ref = 1;
    80003bcc:	4785                	li	a5,1
    80003bce:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003bd0:	00235517          	auipc	a0,0x235
    80003bd4:	5b050513          	addi	a0,a0,1456 # 80239180 <ftable>
    80003bd8:	00003097          	auipc	ra,0x3
    80003bdc:	98a080e7          	jalr	-1654(ra) # 80006562 <release>
}
    80003be0:	8526                	mv	a0,s1
    80003be2:	60e2                	ld	ra,24(sp)
    80003be4:	6442                	ld	s0,16(sp)
    80003be6:	64a2                	ld	s1,8(sp)
    80003be8:	6105                	addi	sp,sp,32
    80003bea:	8082                	ret

0000000080003bec <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003bec:	1101                	addi	sp,sp,-32
    80003bee:	ec06                	sd	ra,24(sp)
    80003bf0:	e822                	sd	s0,16(sp)
    80003bf2:	e426                	sd	s1,8(sp)
    80003bf4:	1000                	addi	s0,sp,32
    80003bf6:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003bf8:	00235517          	auipc	a0,0x235
    80003bfc:	58850513          	addi	a0,a0,1416 # 80239180 <ftable>
    80003c00:	00003097          	auipc	ra,0x3
    80003c04:	8b2080e7          	jalr	-1870(ra) # 800064b2 <acquire>
  if(f->ref < 1)
    80003c08:	40dc                	lw	a5,4(s1)
    80003c0a:	02f05263          	blez	a5,80003c2e <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003c0e:	2785                	addiw	a5,a5,1
    80003c10:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003c12:	00235517          	auipc	a0,0x235
    80003c16:	56e50513          	addi	a0,a0,1390 # 80239180 <ftable>
    80003c1a:	00003097          	auipc	ra,0x3
    80003c1e:	948080e7          	jalr	-1720(ra) # 80006562 <release>
  return f;
}
    80003c22:	8526                	mv	a0,s1
    80003c24:	60e2                	ld	ra,24(sp)
    80003c26:	6442                	ld	s0,16(sp)
    80003c28:	64a2                	ld	s1,8(sp)
    80003c2a:	6105                	addi	sp,sp,32
    80003c2c:	8082                	ret
    panic("filedup");
    80003c2e:	00005517          	auipc	a0,0x5
    80003c32:	90a50513          	addi	a0,a0,-1782 # 80008538 <etext+0x538>
    80003c36:	00002097          	auipc	ra,0x2
    80003c3a:	2fc080e7          	jalr	764(ra) # 80005f32 <panic>

0000000080003c3e <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003c3e:	7139                	addi	sp,sp,-64
    80003c40:	fc06                	sd	ra,56(sp)
    80003c42:	f822                	sd	s0,48(sp)
    80003c44:	f426                	sd	s1,40(sp)
    80003c46:	0080                	addi	s0,sp,64
    80003c48:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003c4a:	00235517          	auipc	a0,0x235
    80003c4e:	53650513          	addi	a0,a0,1334 # 80239180 <ftable>
    80003c52:	00003097          	auipc	ra,0x3
    80003c56:	860080e7          	jalr	-1952(ra) # 800064b2 <acquire>
  if(f->ref < 1)
    80003c5a:	40dc                	lw	a5,4(s1)
    80003c5c:	04f05a63          	blez	a5,80003cb0 <fileclose+0x72>
    panic("fileclose");
  if(--f->ref > 0){
    80003c60:	37fd                	addiw	a5,a5,-1
    80003c62:	c0dc                	sw	a5,4(s1)
    80003c64:	06f04263          	bgtz	a5,80003cc8 <fileclose+0x8a>
    80003c68:	f04a                	sd	s2,32(sp)
    80003c6a:	ec4e                	sd	s3,24(sp)
    80003c6c:	e852                	sd	s4,16(sp)
    80003c6e:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003c70:	0004a903          	lw	s2,0(s1)
    80003c74:	0094ca83          	lbu	s5,9(s1)
    80003c78:	0104ba03          	ld	s4,16(s1)
    80003c7c:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003c80:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003c84:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003c88:	00235517          	auipc	a0,0x235
    80003c8c:	4f850513          	addi	a0,a0,1272 # 80239180 <ftable>
    80003c90:	00003097          	auipc	ra,0x3
    80003c94:	8d2080e7          	jalr	-1838(ra) # 80006562 <release>

  if(ff.type == FD_PIPE){
    80003c98:	4785                	li	a5,1
    80003c9a:	04f90463          	beq	s2,a5,80003ce2 <fileclose+0xa4>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003c9e:	3979                	addiw	s2,s2,-2
    80003ca0:	4785                	li	a5,1
    80003ca2:	0527fb63          	bgeu	a5,s2,80003cf8 <fileclose+0xba>
    80003ca6:	7902                	ld	s2,32(sp)
    80003ca8:	69e2                	ld	s3,24(sp)
    80003caa:	6a42                	ld	s4,16(sp)
    80003cac:	6aa2                	ld	s5,8(sp)
    80003cae:	a02d                	j	80003cd8 <fileclose+0x9a>
    80003cb0:	f04a                	sd	s2,32(sp)
    80003cb2:	ec4e                	sd	s3,24(sp)
    80003cb4:	e852                	sd	s4,16(sp)
    80003cb6:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80003cb8:	00005517          	auipc	a0,0x5
    80003cbc:	88850513          	addi	a0,a0,-1912 # 80008540 <etext+0x540>
    80003cc0:	00002097          	auipc	ra,0x2
    80003cc4:	272080e7          	jalr	626(ra) # 80005f32 <panic>
    release(&ftable.lock);
    80003cc8:	00235517          	auipc	a0,0x235
    80003ccc:	4b850513          	addi	a0,a0,1208 # 80239180 <ftable>
    80003cd0:	00003097          	auipc	ra,0x3
    80003cd4:	892080e7          	jalr	-1902(ra) # 80006562 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80003cd8:	70e2                	ld	ra,56(sp)
    80003cda:	7442                	ld	s0,48(sp)
    80003cdc:	74a2                	ld	s1,40(sp)
    80003cde:	6121                	addi	sp,sp,64
    80003ce0:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003ce2:	85d6                	mv	a1,s5
    80003ce4:	8552                	mv	a0,s4
    80003ce6:	00000097          	auipc	ra,0x0
    80003cea:	3ac080e7          	jalr	940(ra) # 80004092 <pipeclose>
    80003cee:	7902                	ld	s2,32(sp)
    80003cf0:	69e2                	ld	s3,24(sp)
    80003cf2:	6a42                	ld	s4,16(sp)
    80003cf4:	6aa2                	ld	s5,8(sp)
    80003cf6:	b7cd                	j	80003cd8 <fileclose+0x9a>
    begin_op();
    80003cf8:	00000097          	auipc	ra,0x0
    80003cfc:	a76080e7          	jalr	-1418(ra) # 8000376e <begin_op>
    iput(ff.ip);
    80003d00:	854e                	mv	a0,s3
    80003d02:	fffff097          	auipc	ra,0xfffff
    80003d06:	238080e7          	jalr	568(ra) # 80002f3a <iput>
    end_op();
    80003d0a:	00000097          	auipc	ra,0x0
    80003d0e:	ade080e7          	jalr	-1314(ra) # 800037e8 <end_op>
    80003d12:	7902                	ld	s2,32(sp)
    80003d14:	69e2                	ld	s3,24(sp)
    80003d16:	6a42                	ld	s4,16(sp)
    80003d18:	6aa2                	ld	s5,8(sp)
    80003d1a:	bf7d                	j	80003cd8 <fileclose+0x9a>

0000000080003d1c <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003d1c:	715d                	addi	sp,sp,-80
    80003d1e:	e486                	sd	ra,72(sp)
    80003d20:	e0a2                	sd	s0,64(sp)
    80003d22:	fc26                	sd	s1,56(sp)
    80003d24:	f44e                	sd	s3,40(sp)
    80003d26:	0880                	addi	s0,sp,80
    80003d28:	84aa                	mv	s1,a0
    80003d2a:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003d2c:	ffffd097          	auipc	ra,0xffffd
    80003d30:	33e080e7          	jalr	830(ra) # 8000106a <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003d34:	409c                	lw	a5,0(s1)
    80003d36:	37f9                	addiw	a5,a5,-2
    80003d38:	4705                	li	a4,1
    80003d3a:	04f76a63          	bltu	a4,a5,80003d8e <filestat+0x72>
    80003d3e:	f84a                	sd	s2,48(sp)
    80003d40:	f052                	sd	s4,32(sp)
    80003d42:	892a                	mv	s2,a0
    ilock(f->ip);
    80003d44:	6c88                	ld	a0,24(s1)
    80003d46:	fffff097          	auipc	ra,0xfffff
    80003d4a:	036080e7          	jalr	54(ra) # 80002d7c <ilock>
    stati(f->ip, &st);
    80003d4e:	fb840a13          	addi	s4,s0,-72
    80003d52:	85d2                	mv	a1,s4
    80003d54:	6c88                	ld	a0,24(s1)
    80003d56:	fffff097          	auipc	ra,0xfffff
    80003d5a:	2b4080e7          	jalr	692(ra) # 8000300a <stati>
    iunlock(f->ip);
    80003d5e:	6c88                	ld	a0,24(s1)
    80003d60:	fffff097          	auipc	ra,0xfffff
    80003d64:	0e2080e7          	jalr	226(ra) # 80002e42 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003d68:	46e1                	li	a3,24
    80003d6a:	8652                	mv	a2,s4
    80003d6c:	85ce                	mv	a1,s3
    80003d6e:	05093503          	ld	a0,80(s2)
    80003d72:	ffffd097          	auipc	ra,0xffffd
    80003d76:	eca080e7          	jalr	-310(ra) # 80000c3c <copyout>
    80003d7a:	41f5551b          	sraiw	a0,a0,0x1f
    80003d7e:	7942                	ld	s2,48(sp)
    80003d80:	7a02                	ld	s4,32(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80003d82:	60a6                	ld	ra,72(sp)
    80003d84:	6406                	ld	s0,64(sp)
    80003d86:	74e2                	ld	s1,56(sp)
    80003d88:	79a2                	ld	s3,40(sp)
    80003d8a:	6161                	addi	sp,sp,80
    80003d8c:	8082                	ret
  return -1;
    80003d8e:	557d                	li	a0,-1
    80003d90:	bfcd                	j	80003d82 <filestat+0x66>

0000000080003d92 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003d92:	7179                	addi	sp,sp,-48
    80003d94:	f406                	sd	ra,40(sp)
    80003d96:	f022                	sd	s0,32(sp)
    80003d98:	e84a                	sd	s2,16(sp)
    80003d9a:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003d9c:	00854783          	lbu	a5,8(a0)
    80003da0:	cbc5                	beqz	a5,80003e50 <fileread+0xbe>
    80003da2:	ec26                	sd	s1,24(sp)
    80003da4:	e44e                	sd	s3,8(sp)
    80003da6:	84aa                	mv	s1,a0
    80003da8:	89ae                	mv	s3,a1
    80003daa:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003dac:	411c                	lw	a5,0(a0)
    80003dae:	4705                	li	a4,1
    80003db0:	04e78963          	beq	a5,a4,80003e02 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003db4:	470d                	li	a4,3
    80003db6:	04e78f63          	beq	a5,a4,80003e14 <fileread+0x82>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003dba:	4709                	li	a4,2
    80003dbc:	08e79263          	bne	a5,a4,80003e40 <fileread+0xae>
    ilock(f->ip);
    80003dc0:	6d08                	ld	a0,24(a0)
    80003dc2:	fffff097          	auipc	ra,0xfffff
    80003dc6:	fba080e7          	jalr	-70(ra) # 80002d7c <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003dca:	874a                	mv	a4,s2
    80003dcc:	5094                	lw	a3,32(s1)
    80003dce:	864e                	mv	a2,s3
    80003dd0:	4585                	li	a1,1
    80003dd2:	6c88                	ld	a0,24(s1)
    80003dd4:	fffff097          	auipc	ra,0xfffff
    80003dd8:	264080e7          	jalr	612(ra) # 80003038 <readi>
    80003ddc:	892a                	mv	s2,a0
    80003dde:	00a05563          	blez	a0,80003de8 <fileread+0x56>
      f->off += r;
    80003de2:	509c                	lw	a5,32(s1)
    80003de4:	9fa9                	addw	a5,a5,a0
    80003de6:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003de8:	6c88                	ld	a0,24(s1)
    80003dea:	fffff097          	auipc	ra,0xfffff
    80003dee:	058080e7          	jalr	88(ra) # 80002e42 <iunlock>
    80003df2:	64e2                	ld	s1,24(sp)
    80003df4:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80003df6:	854a                	mv	a0,s2
    80003df8:	70a2                	ld	ra,40(sp)
    80003dfa:	7402                	ld	s0,32(sp)
    80003dfc:	6942                	ld	s2,16(sp)
    80003dfe:	6145                	addi	sp,sp,48
    80003e00:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003e02:	6908                	ld	a0,16(a0)
    80003e04:	00000097          	auipc	ra,0x0
    80003e08:	414080e7          	jalr	1044(ra) # 80004218 <piperead>
    80003e0c:	892a                	mv	s2,a0
    80003e0e:	64e2                	ld	s1,24(sp)
    80003e10:	69a2                	ld	s3,8(sp)
    80003e12:	b7d5                	j	80003df6 <fileread+0x64>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003e14:	02451783          	lh	a5,36(a0)
    80003e18:	03079693          	slli	a3,a5,0x30
    80003e1c:	92c1                	srli	a3,a3,0x30
    80003e1e:	4725                	li	a4,9
    80003e20:	02d76a63          	bltu	a4,a3,80003e54 <fileread+0xc2>
    80003e24:	0792                	slli	a5,a5,0x4
    80003e26:	00235717          	auipc	a4,0x235
    80003e2a:	2ba70713          	addi	a4,a4,698 # 802390e0 <devsw>
    80003e2e:	97ba                	add	a5,a5,a4
    80003e30:	639c                	ld	a5,0(a5)
    80003e32:	c78d                	beqz	a5,80003e5c <fileread+0xca>
    r = devsw[f->major].read(1, addr, n);
    80003e34:	4505                	li	a0,1
    80003e36:	9782                	jalr	a5
    80003e38:	892a                	mv	s2,a0
    80003e3a:	64e2                	ld	s1,24(sp)
    80003e3c:	69a2                	ld	s3,8(sp)
    80003e3e:	bf65                	j	80003df6 <fileread+0x64>
    panic("fileread");
    80003e40:	00004517          	auipc	a0,0x4
    80003e44:	71050513          	addi	a0,a0,1808 # 80008550 <etext+0x550>
    80003e48:	00002097          	auipc	ra,0x2
    80003e4c:	0ea080e7          	jalr	234(ra) # 80005f32 <panic>
    return -1;
    80003e50:	597d                	li	s2,-1
    80003e52:	b755                	j	80003df6 <fileread+0x64>
      return -1;
    80003e54:	597d                	li	s2,-1
    80003e56:	64e2                	ld	s1,24(sp)
    80003e58:	69a2                	ld	s3,8(sp)
    80003e5a:	bf71                	j	80003df6 <fileread+0x64>
    80003e5c:	597d                	li	s2,-1
    80003e5e:	64e2                	ld	s1,24(sp)
    80003e60:	69a2                	ld	s3,8(sp)
    80003e62:	bf51                	j	80003df6 <fileread+0x64>

0000000080003e64 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003e64:	00954783          	lbu	a5,9(a0)
    80003e68:	12078c63          	beqz	a5,80003fa0 <filewrite+0x13c>
{
    80003e6c:	711d                	addi	sp,sp,-96
    80003e6e:	ec86                	sd	ra,88(sp)
    80003e70:	e8a2                	sd	s0,80(sp)
    80003e72:	e0ca                	sd	s2,64(sp)
    80003e74:	f456                	sd	s5,40(sp)
    80003e76:	f05a                	sd	s6,32(sp)
    80003e78:	1080                	addi	s0,sp,96
    80003e7a:	892a                	mv	s2,a0
    80003e7c:	8b2e                	mv	s6,a1
    80003e7e:	8ab2                	mv	s5,a2
    return -1;

  if(f->type == FD_PIPE){
    80003e80:	411c                	lw	a5,0(a0)
    80003e82:	4705                	li	a4,1
    80003e84:	02e78963          	beq	a5,a4,80003eb6 <filewrite+0x52>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003e88:	470d                	li	a4,3
    80003e8a:	02e78c63          	beq	a5,a4,80003ec2 <filewrite+0x5e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003e8e:	4709                	li	a4,2
    80003e90:	0ee79a63          	bne	a5,a4,80003f84 <filewrite+0x120>
    80003e94:	f852                	sd	s4,48(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003e96:	0cc05563          	blez	a2,80003f60 <filewrite+0xfc>
    80003e9a:	e4a6                	sd	s1,72(sp)
    80003e9c:	fc4e                	sd	s3,56(sp)
    80003e9e:	ec5e                	sd	s7,24(sp)
    80003ea0:	e862                	sd	s8,16(sp)
    80003ea2:	e466                	sd	s9,8(sp)
    int i = 0;
    80003ea4:	4a01                	li	s4,0
      int n1 = n - i;
      if(n1 > max)
    80003ea6:	6b85                	lui	s7,0x1
    80003ea8:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003eac:	6c85                	lui	s9,0x1
    80003eae:	c00c8c9b          	addiw	s9,s9,-1024 # c00 <_entry-0x7ffff400>
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003eb2:	4c05                	li	s8,1
    80003eb4:	a849                	j	80003f46 <filewrite+0xe2>
    ret = pipewrite(f->pipe, addr, n);
    80003eb6:	6908                	ld	a0,16(a0)
    80003eb8:	00000097          	auipc	ra,0x0
    80003ebc:	24a080e7          	jalr	586(ra) # 80004102 <pipewrite>
    80003ec0:	a85d                	j	80003f76 <filewrite+0x112>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003ec2:	02451783          	lh	a5,36(a0)
    80003ec6:	03079693          	slli	a3,a5,0x30
    80003eca:	92c1                	srli	a3,a3,0x30
    80003ecc:	4725                	li	a4,9
    80003ece:	0cd76b63          	bltu	a4,a3,80003fa4 <filewrite+0x140>
    80003ed2:	0792                	slli	a5,a5,0x4
    80003ed4:	00235717          	auipc	a4,0x235
    80003ed8:	20c70713          	addi	a4,a4,524 # 802390e0 <devsw>
    80003edc:	97ba                	add	a5,a5,a4
    80003ede:	679c                	ld	a5,8(a5)
    80003ee0:	c7e1                	beqz	a5,80003fa8 <filewrite+0x144>
    ret = devsw[f->major].write(1, addr, n);
    80003ee2:	4505                	li	a0,1
    80003ee4:	9782                	jalr	a5
    80003ee6:	a841                	j	80003f76 <filewrite+0x112>
      if(n1 > max)
    80003ee8:	2981                	sext.w	s3,s3
      begin_op();
    80003eea:	00000097          	auipc	ra,0x0
    80003eee:	884080e7          	jalr	-1916(ra) # 8000376e <begin_op>
      ilock(f->ip);
    80003ef2:	01893503          	ld	a0,24(s2)
    80003ef6:	fffff097          	auipc	ra,0xfffff
    80003efa:	e86080e7          	jalr	-378(ra) # 80002d7c <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003efe:	874e                	mv	a4,s3
    80003f00:	02092683          	lw	a3,32(s2)
    80003f04:	016a0633          	add	a2,s4,s6
    80003f08:	85e2                	mv	a1,s8
    80003f0a:	01893503          	ld	a0,24(s2)
    80003f0e:	fffff097          	auipc	ra,0xfffff
    80003f12:	224080e7          	jalr	548(ra) # 80003132 <writei>
    80003f16:	84aa                	mv	s1,a0
    80003f18:	00a05763          	blez	a0,80003f26 <filewrite+0xc2>
        f->off += r;
    80003f1c:	02092783          	lw	a5,32(s2)
    80003f20:	9fa9                	addw	a5,a5,a0
    80003f22:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003f26:	01893503          	ld	a0,24(s2)
    80003f2a:	fffff097          	auipc	ra,0xfffff
    80003f2e:	f18080e7          	jalr	-232(ra) # 80002e42 <iunlock>
      end_op();
    80003f32:	00000097          	auipc	ra,0x0
    80003f36:	8b6080e7          	jalr	-1866(ra) # 800037e8 <end_op>

      if(r != n1){
    80003f3a:	02999563          	bne	s3,s1,80003f64 <filewrite+0x100>
        // error from writei
        break;
      }
      i += r;
    80003f3e:	01448a3b          	addw	s4,s1,s4
    while(i < n){
    80003f42:	015a5963          	bge	s4,s5,80003f54 <filewrite+0xf0>
      int n1 = n - i;
    80003f46:	414a87bb          	subw	a5,s5,s4
    80003f4a:	89be                	mv	s3,a5
      if(n1 > max)
    80003f4c:	f8fbdee3          	bge	s7,a5,80003ee8 <filewrite+0x84>
    80003f50:	89e6                	mv	s3,s9
    80003f52:	bf59                	j	80003ee8 <filewrite+0x84>
    80003f54:	64a6                	ld	s1,72(sp)
    80003f56:	79e2                	ld	s3,56(sp)
    80003f58:	6be2                	ld	s7,24(sp)
    80003f5a:	6c42                	ld	s8,16(sp)
    80003f5c:	6ca2                	ld	s9,8(sp)
    80003f5e:	a801                	j	80003f6e <filewrite+0x10a>
    int i = 0;
    80003f60:	4a01                	li	s4,0
    80003f62:	a031                	j	80003f6e <filewrite+0x10a>
    80003f64:	64a6                	ld	s1,72(sp)
    80003f66:	79e2                	ld	s3,56(sp)
    80003f68:	6be2                	ld	s7,24(sp)
    80003f6a:	6c42                	ld	s8,16(sp)
    80003f6c:	6ca2                	ld	s9,8(sp)
    }
    ret = (i == n ? n : -1);
    80003f6e:	034a9f63          	bne	s5,s4,80003fac <filewrite+0x148>
    80003f72:	8556                	mv	a0,s5
    80003f74:	7a42                	ld	s4,48(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003f76:	60e6                	ld	ra,88(sp)
    80003f78:	6446                	ld	s0,80(sp)
    80003f7a:	6906                	ld	s2,64(sp)
    80003f7c:	7aa2                	ld	s5,40(sp)
    80003f7e:	7b02                	ld	s6,32(sp)
    80003f80:	6125                	addi	sp,sp,96
    80003f82:	8082                	ret
    80003f84:	e4a6                	sd	s1,72(sp)
    80003f86:	fc4e                	sd	s3,56(sp)
    80003f88:	f852                	sd	s4,48(sp)
    80003f8a:	ec5e                	sd	s7,24(sp)
    80003f8c:	e862                	sd	s8,16(sp)
    80003f8e:	e466                	sd	s9,8(sp)
    panic("filewrite");
    80003f90:	00004517          	auipc	a0,0x4
    80003f94:	5d050513          	addi	a0,a0,1488 # 80008560 <etext+0x560>
    80003f98:	00002097          	auipc	ra,0x2
    80003f9c:	f9a080e7          	jalr	-102(ra) # 80005f32 <panic>
    return -1;
    80003fa0:	557d                	li	a0,-1
}
    80003fa2:	8082                	ret
      return -1;
    80003fa4:	557d                	li	a0,-1
    80003fa6:	bfc1                	j	80003f76 <filewrite+0x112>
    80003fa8:	557d                	li	a0,-1
    80003faa:	b7f1                	j	80003f76 <filewrite+0x112>
    ret = (i == n ? n : -1);
    80003fac:	557d                	li	a0,-1
    80003fae:	7a42                	ld	s4,48(sp)
    80003fb0:	b7d9                	j	80003f76 <filewrite+0x112>

0000000080003fb2 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003fb2:	7179                	addi	sp,sp,-48
    80003fb4:	f406                	sd	ra,40(sp)
    80003fb6:	f022                	sd	s0,32(sp)
    80003fb8:	ec26                	sd	s1,24(sp)
    80003fba:	e052                	sd	s4,0(sp)
    80003fbc:	1800                	addi	s0,sp,48
    80003fbe:	84aa                	mv	s1,a0
    80003fc0:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003fc2:	0005b023          	sd	zero,0(a1)
    80003fc6:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003fca:	00000097          	auipc	ra,0x0
    80003fce:	bb8080e7          	jalr	-1096(ra) # 80003b82 <filealloc>
    80003fd2:	e088                	sd	a0,0(s1)
    80003fd4:	cd49                	beqz	a0,8000406e <pipealloc+0xbc>
    80003fd6:	00000097          	auipc	ra,0x0
    80003fda:	bac080e7          	jalr	-1108(ra) # 80003b82 <filealloc>
    80003fde:	00aa3023          	sd	a0,0(s4)
    80003fe2:	c141                	beqz	a0,80004062 <pipealloc+0xb0>
    80003fe4:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003fe6:	ffffc097          	auipc	ra,0xffffc
    80003fea:	1b4080e7          	jalr	436(ra) # 8000019a <kalloc>
    80003fee:	892a                	mv	s2,a0
    80003ff0:	c13d                	beqz	a0,80004056 <pipealloc+0xa4>
    80003ff2:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80003ff4:	4985                	li	s3,1
    80003ff6:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003ffa:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003ffe:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004002:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004006:	00004597          	auipc	a1,0x4
    8000400a:	56a58593          	addi	a1,a1,1386 # 80008570 <etext+0x570>
    8000400e:	00002097          	auipc	ra,0x2
    80004012:	410080e7          	jalr	1040(ra) # 8000641e <initlock>
  (*f0)->type = FD_PIPE;
    80004016:	609c                	ld	a5,0(s1)
    80004018:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    8000401c:	609c                	ld	a5,0(s1)
    8000401e:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004022:	609c                	ld	a5,0(s1)
    80004024:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004028:	609c                	ld	a5,0(s1)
    8000402a:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    8000402e:	000a3783          	ld	a5,0(s4)
    80004032:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004036:	000a3783          	ld	a5,0(s4)
    8000403a:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    8000403e:	000a3783          	ld	a5,0(s4)
    80004042:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004046:	000a3783          	ld	a5,0(s4)
    8000404a:	0127b823          	sd	s2,16(a5)
  return 0;
    8000404e:	4501                	li	a0,0
    80004050:	6942                	ld	s2,16(sp)
    80004052:	69a2                	ld	s3,8(sp)
    80004054:	a03d                	j	80004082 <pipealloc+0xd0>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004056:	6088                	ld	a0,0(s1)
    80004058:	c119                	beqz	a0,8000405e <pipealloc+0xac>
    8000405a:	6942                	ld	s2,16(sp)
    8000405c:	a029                	j	80004066 <pipealloc+0xb4>
    8000405e:	6942                	ld	s2,16(sp)
    80004060:	a039                	j	8000406e <pipealloc+0xbc>
    80004062:	6088                	ld	a0,0(s1)
    80004064:	c50d                	beqz	a0,8000408e <pipealloc+0xdc>
    fileclose(*f0);
    80004066:	00000097          	auipc	ra,0x0
    8000406a:	bd8080e7          	jalr	-1064(ra) # 80003c3e <fileclose>
  if(*f1)
    8000406e:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004072:	557d                	li	a0,-1
  if(*f1)
    80004074:	c799                	beqz	a5,80004082 <pipealloc+0xd0>
    fileclose(*f1);
    80004076:	853e                	mv	a0,a5
    80004078:	00000097          	auipc	ra,0x0
    8000407c:	bc6080e7          	jalr	-1082(ra) # 80003c3e <fileclose>
  return -1;
    80004080:	557d                	li	a0,-1
}
    80004082:	70a2                	ld	ra,40(sp)
    80004084:	7402                	ld	s0,32(sp)
    80004086:	64e2                	ld	s1,24(sp)
    80004088:	6a02                	ld	s4,0(sp)
    8000408a:	6145                	addi	sp,sp,48
    8000408c:	8082                	ret
  return -1;
    8000408e:	557d                	li	a0,-1
    80004090:	bfcd                	j	80004082 <pipealloc+0xd0>

0000000080004092 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004092:	1101                	addi	sp,sp,-32
    80004094:	ec06                	sd	ra,24(sp)
    80004096:	e822                	sd	s0,16(sp)
    80004098:	e426                	sd	s1,8(sp)
    8000409a:	e04a                	sd	s2,0(sp)
    8000409c:	1000                	addi	s0,sp,32
    8000409e:	84aa                	mv	s1,a0
    800040a0:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800040a2:	00002097          	auipc	ra,0x2
    800040a6:	410080e7          	jalr	1040(ra) # 800064b2 <acquire>
  if(writable){
    800040aa:	02090d63          	beqz	s2,800040e4 <pipeclose+0x52>
    pi->writeopen = 0;
    800040ae:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800040b2:	21848513          	addi	a0,s1,536
    800040b6:	ffffe097          	auipc	ra,0xffffe
    800040ba:	800080e7          	jalr	-2048(ra) # 800018b6 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    800040be:	2204b783          	ld	a5,544(s1)
    800040c2:	eb95                	bnez	a5,800040f6 <pipeclose+0x64>
    release(&pi->lock);
    800040c4:	8526                	mv	a0,s1
    800040c6:	00002097          	auipc	ra,0x2
    800040ca:	49c080e7          	jalr	1180(ra) # 80006562 <release>
    kfree((char*)pi);
    800040ce:	8526                	mv	a0,s1
    800040d0:	ffffc097          	auipc	ra,0xffffc
    800040d4:	f4c080e7          	jalr	-180(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    800040d8:	60e2                	ld	ra,24(sp)
    800040da:	6442                	ld	s0,16(sp)
    800040dc:	64a2                	ld	s1,8(sp)
    800040de:	6902                	ld	s2,0(sp)
    800040e0:	6105                	addi	sp,sp,32
    800040e2:	8082                	ret
    pi->readopen = 0;
    800040e4:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800040e8:	21c48513          	addi	a0,s1,540
    800040ec:	ffffd097          	auipc	ra,0xffffd
    800040f0:	7ca080e7          	jalr	1994(ra) # 800018b6 <wakeup>
    800040f4:	b7e9                	j	800040be <pipeclose+0x2c>
    release(&pi->lock);
    800040f6:	8526                	mv	a0,s1
    800040f8:	00002097          	auipc	ra,0x2
    800040fc:	46a080e7          	jalr	1130(ra) # 80006562 <release>
}
    80004100:	bfe1                	j	800040d8 <pipeclose+0x46>

0000000080004102 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004102:	7159                	addi	sp,sp,-112
    80004104:	f486                	sd	ra,104(sp)
    80004106:	f0a2                	sd	s0,96(sp)
    80004108:	eca6                	sd	s1,88(sp)
    8000410a:	e8ca                	sd	s2,80(sp)
    8000410c:	e4ce                	sd	s3,72(sp)
    8000410e:	e0d2                	sd	s4,64(sp)
    80004110:	fc56                	sd	s5,56(sp)
    80004112:	1880                	addi	s0,sp,112
    80004114:	84aa                	mv	s1,a0
    80004116:	8aae                	mv	s5,a1
    80004118:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    8000411a:	ffffd097          	auipc	ra,0xffffd
    8000411e:	f50080e7          	jalr	-176(ra) # 8000106a <myproc>
    80004122:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004124:	8526                	mv	a0,s1
    80004126:	00002097          	auipc	ra,0x2
    8000412a:	38c080e7          	jalr	908(ra) # 800064b2 <acquire>
  while(i < n){
    8000412e:	0d405d63          	blez	s4,80004208 <pipewrite+0x106>
    80004132:	f85a                	sd	s6,48(sp)
    80004134:	f45e                	sd	s7,40(sp)
    80004136:	f062                	sd	s8,32(sp)
    80004138:	ec66                	sd	s9,24(sp)
    8000413a:	e86a                	sd	s10,16(sp)
  int i = 0;
    8000413c:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000413e:	f9f40c13          	addi	s8,s0,-97
    80004142:	4b85                	li	s7,1
    80004144:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004146:	21848d13          	addi	s10,s1,536
      sleep(&pi->nwrite, &pi->lock);
    8000414a:	21c48c93          	addi	s9,s1,540
    8000414e:	a099                	j	80004194 <pipewrite+0x92>
      release(&pi->lock);
    80004150:	8526                	mv	a0,s1
    80004152:	00002097          	auipc	ra,0x2
    80004156:	410080e7          	jalr	1040(ra) # 80006562 <release>
      return -1;
    8000415a:	597d                	li	s2,-1
    8000415c:	7b42                	ld	s6,48(sp)
    8000415e:	7ba2                	ld	s7,40(sp)
    80004160:	7c02                	ld	s8,32(sp)
    80004162:	6ce2                	ld	s9,24(sp)
    80004164:	6d42                	ld	s10,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004166:	854a                	mv	a0,s2
    80004168:	70a6                	ld	ra,104(sp)
    8000416a:	7406                	ld	s0,96(sp)
    8000416c:	64e6                	ld	s1,88(sp)
    8000416e:	6946                	ld	s2,80(sp)
    80004170:	69a6                	ld	s3,72(sp)
    80004172:	6a06                	ld	s4,64(sp)
    80004174:	7ae2                	ld	s5,56(sp)
    80004176:	6165                	addi	sp,sp,112
    80004178:	8082                	ret
      wakeup(&pi->nread);
    8000417a:	856a                	mv	a0,s10
    8000417c:	ffffd097          	auipc	ra,0xffffd
    80004180:	73a080e7          	jalr	1850(ra) # 800018b6 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004184:	85a6                	mv	a1,s1
    80004186:	8566                	mv	a0,s9
    80004188:	ffffd097          	auipc	ra,0xffffd
    8000418c:	5a8080e7          	jalr	1448(ra) # 80001730 <sleep>
  while(i < n){
    80004190:	05495b63          	bge	s2,s4,800041e6 <pipewrite+0xe4>
    if(pi->readopen == 0 || pr->killed){
    80004194:	2204a783          	lw	a5,544(s1)
    80004198:	dfc5                	beqz	a5,80004150 <pipewrite+0x4e>
    8000419a:	0289a783          	lw	a5,40(s3)
    8000419e:	fbcd                	bnez	a5,80004150 <pipewrite+0x4e>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    800041a0:	2184a783          	lw	a5,536(s1)
    800041a4:	21c4a703          	lw	a4,540(s1)
    800041a8:	2007879b          	addiw	a5,a5,512
    800041ac:	fcf707e3          	beq	a4,a5,8000417a <pipewrite+0x78>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800041b0:	86de                	mv	a3,s7
    800041b2:	01590633          	add	a2,s2,s5
    800041b6:	85e2                	mv	a1,s8
    800041b8:	0509b503          	ld	a0,80(s3)
    800041bc:	ffffd097          	auipc	ra,0xffffd
    800041c0:	be6080e7          	jalr	-1050(ra) # 80000da2 <copyin>
    800041c4:	05650463          	beq	a0,s6,8000420c <pipewrite+0x10a>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800041c8:	21c4a783          	lw	a5,540(s1)
    800041cc:	0017871b          	addiw	a4,a5,1
    800041d0:	20e4ae23          	sw	a4,540(s1)
    800041d4:	1ff7f793          	andi	a5,a5,511
    800041d8:	97a6                	add	a5,a5,s1
    800041da:	f9f44703          	lbu	a4,-97(s0)
    800041de:	00e78c23          	sb	a4,24(a5)
      i++;
    800041e2:	2905                	addiw	s2,s2,1
    800041e4:	b775                	j	80004190 <pipewrite+0x8e>
    800041e6:	7b42                	ld	s6,48(sp)
    800041e8:	7ba2                	ld	s7,40(sp)
    800041ea:	7c02                	ld	s8,32(sp)
    800041ec:	6ce2                	ld	s9,24(sp)
    800041ee:	6d42                	ld	s10,16(sp)
  wakeup(&pi->nread);
    800041f0:	21848513          	addi	a0,s1,536
    800041f4:	ffffd097          	auipc	ra,0xffffd
    800041f8:	6c2080e7          	jalr	1730(ra) # 800018b6 <wakeup>
  release(&pi->lock);
    800041fc:	8526                	mv	a0,s1
    800041fe:	00002097          	auipc	ra,0x2
    80004202:	364080e7          	jalr	868(ra) # 80006562 <release>
  return i;
    80004206:	b785                	j	80004166 <pipewrite+0x64>
  int i = 0;
    80004208:	4901                	li	s2,0
    8000420a:	b7dd                	j	800041f0 <pipewrite+0xee>
    8000420c:	7b42                	ld	s6,48(sp)
    8000420e:	7ba2                	ld	s7,40(sp)
    80004210:	7c02                	ld	s8,32(sp)
    80004212:	6ce2                	ld	s9,24(sp)
    80004214:	6d42                	ld	s10,16(sp)
    80004216:	bfe9                	j	800041f0 <pipewrite+0xee>

0000000080004218 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004218:	711d                	addi	sp,sp,-96
    8000421a:	ec86                	sd	ra,88(sp)
    8000421c:	e8a2                	sd	s0,80(sp)
    8000421e:	e4a6                	sd	s1,72(sp)
    80004220:	e0ca                	sd	s2,64(sp)
    80004222:	fc4e                	sd	s3,56(sp)
    80004224:	f852                	sd	s4,48(sp)
    80004226:	f456                	sd	s5,40(sp)
    80004228:	1080                	addi	s0,sp,96
    8000422a:	84aa                	mv	s1,a0
    8000422c:	892e                	mv	s2,a1
    8000422e:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004230:	ffffd097          	auipc	ra,0xffffd
    80004234:	e3a080e7          	jalr	-454(ra) # 8000106a <myproc>
    80004238:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    8000423a:	8526                	mv	a0,s1
    8000423c:	00002097          	auipc	ra,0x2
    80004240:	276080e7          	jalr	630(ra) # 800064b2 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004244:	2184a703          	lw	a4,536(s1)
    80004248:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000424c:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004250:	02f71863          	bne	a4,a5,80004280 <piperead+0x68>
    80004254:	2244a783          	lw	a5,548(s1)
    80004258:	cf9d                	beqz	a5,80004296 <piperead+0x7e>
    if(pr->killed){
    8000425a:	028a2783          	lw	a5,40(s4)
    8000425e:	e78d                	bnez	a5,80004288 <piperead+0x70>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004260:	85a6                	mv	a1,s1
    80004262:	854e                	mv	a0,s3
    80004264:	ffffd097          	auipc	ra,0xffffd
    80004268:	4cc080e7          	jalr	1228(ra) # 80001730 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000426c:	2184a703          	lw	a4,536(s1)
    80004270:	21c4a783          	lw	a5,540(s1)
    80004274:	fef700e3          	beq	a4,a5,80004254 <piperead+0x3c>
    80004278:	f05a                	sd	s6,32(sp)
    8000427a:	ec5e                	sd	s7,24(sp)
    8000427c:	e862                	sd	s8,16(sp)
    8000427e:	a839                	j	8000429c <piperead+0x84>
    80004280:	f05a                	sd	s6,32(sp)
    80004282:	ec5e                	sd	s7,24(sp)
    80004284:	e862                	sd	s8,16(sp)
    80004286:	a819                	j	8000429c <piperead+0x84>
      release(&pi->lock);
    80004288:	8526                	mv	a0,s1
    8000428a:	00002097          	auipc	ra,0x2
    8000428e:	2d8080e7          	jalr	728(ra) # 80006562 <release>
      return -1;
    80004292:	59fd                	li	s3,-1
    80004294:	a895                	j	80004308 <piperead+0xf0>
    80004296:	f05a                	sd	s6,32(sp)
    80004298:	ec5e                	sd	s7,24(sp)
    8000429a:	e862                	sd	s8,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000429c:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000429e:	faf40c13          	addi	s8,s0,-81
    800042a2:	4b85                	li	s7,1
    800042a4:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800042a6:	05505363          	blez	s5,800042ec <piperead+0xd4>
    if(pi->nread == pi->nwrite)
    800042aa:	2184a783          	lw	a5,536(s1)
    800042ae:	21c4a703          	lw	a4,540(s1)
    800042b2:	02f70d63          	beq	a4,a5,800042ec <piperead+0xd4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800042b6:	0017871b          	addiw	a4,a5,1
    800042ba:	20e4ac23          	sw	a4,536(s1)
    800042be:	1ff7f793          	andi	a5,a5,511
    800042c2:	97a6                	add	a5,a5,s1
    800042c4:	0187c783          	lbu	a5,24(a5)
    800042c8:	faf407a3          	sb	a5,-81(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800042cc:	86de                	mv	a3,s7
    800042ce:	8662                	mv	a2,s8
    800042d0:	85ca                	mv	a1,s2
    800042d2:	050a3503          	ld	a0,80(s4)
    800042d6:	ffffd097          	auipc	ra,0xffffd
    800042da:	966080e7          	jalr	-1690(ra) # 80000c3c <copyout>
    800042de:	01650763          	beq	a0,s6,800042ec <piperead+0xd4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800042e2:	2985                	addiw	s3,s3,1
    800042e4:	0905                	addi	s2,s2,1
    800042e6:	fd3a92e3          	bne	s5,s3,800042aa <piperead+0x92>
    800042ea:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800042ec:	21c48513          	addi	a0,s1,540
    800042f0:	ffffd097          	auipc	ra,0xffffd
    800042f4:	5c6080e7          	jalr	1478(ra) # 800018b6 <wakeup>
  release(&pi->lock);
    800042f8:	8526                	mv	a0,s1
    800042fa:	00002097          	auipc	ra,0x2
    800042fe:	268080e7          	jalr	616(ra) # 80006562 <release>
    80004302:	7b02                	ld	s6,32(sp)
    80004304:	6be2                	ld	s7,24(sp)
    80004306:	6c42                	ld	s8,16(sp)
  return i;
}
    80004308:	854e                	mv	a0,s3
    8000430a:	60e6                	ld	ra,88(sp)
    8000430c:	6446                	ld	s0,80(sp)
    8000430e:	64a6                	ld	s1,72(sp)
    80004310:	6906                	ld	s2,64(sp)
    80004312:	79e2                	ld	s3,56(sp)
    80004314:	7a42                	ld	s4,48(sp)
    80004316:	7aa2                	ld	s5,40(sp)
    80004318:	6125                	addi	sp,sp,96
    8000431a:	8082                	ret

000000008000431c <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    8000431c:	de010113          	addi	sp,sp,-544
    80004320:	20113c23          	sd	ra,536(sp)
    80004324:	20813823          	sd	s0,528(sp)
    80004328:	20913423          	sd	s1,520(sp)
    8000432c:	21213023          	sd	s2,512(sp)
    80004330:	1400                	addi	s0,sp,544
    80004332:	892a                	mv	s2,a0
    80004334:	dea43823          	sd	a0,-528(s0)
    80004338:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000433c:	ffffd097          	auipc	ra,0xffffd
    80004340:	d2e080e7          	jalr	-722(ra) # 8000106a <myproc>
    80004344:	84aa                	mv	s1,a0

  begin_op();
    80004346:	fffff097          	auipc	ra,0xfffff
    8000434a:	428080e7          	jalr	1064(ra) # 8000376e <begin_op>

  if((ip = namei(path)) == 0){
    8000434e:	854a                	mv	a0,s2
    80004350:	fffff097          	auipc	ra,0xfffff
    80004354:	218080e7          	jalr	536(ra) # 80003568 <namei>
    80004358:	c525                	beqz	a0,800043c0 <exec+0xa4>
    8000435a:	fbd2                	sd	s4,496(sp)
    8000435c:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000435e:	fffff097          	auipc	ra,0xfffff
    80004362:	a1e080e7          	jalr	-1506(ra) # 80002d7c <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004366:	04000713          	li	a4,64
    8000436a:	4681                	li	a3,0
    8000436c:	e5040613          	addi	a2,s0,-432
    80004370:	4581                	li	a1,0
    80004372:	8552                	mv	a0,s4
    80004374:	fffff097          	auipc	ra,0xfffff
    80004378:	cc4080e7          	jalr	-828(ra) # 80003038 <readi>
    8000437c:	04000793          	li	a5,64
    80004380:	00f51a63          	bne	a0,a5,80004394 <exec+0x78>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004384:	e5042703          	lw	a4,-432(s0)
    80004388:	464c47b7          	lui	a5,0x464c4
    8000438c:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004390:	02f70e63          	beq	a4,a5,800043cc <exec+0xb0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004394:	8552                	mv	a0,s4
    80004396:	fffff097          	auipc	ra,0xfffff
    8000439a:	c4c080e7          	jalr	-948(ra) # 80002fe2 <iunlockput>
    end_op();
    8000439e:	fffff097          	auipc	ra,0xfffff
    800043a2:	44a080e7          	jalr	1098(ra) # 800037e8 <end_op>
  }
  return -1;
    800043a6:	557d                	li	a0,-1
    800043a8:	7a5e                	ld	s4,496(sp)
}
    800043aa:	21813083          	ld	ra,536(sp)
    800043ae:	21013403          	ld	s0,528(sp)
    800043b2:	20813483          	ld	s1,520(sp)
    800043b6:	20013903          	ld	s2,512(sp)
    800043ba:	22010113          	addi	sp,sp,544
    800043be:	8082                	ret
    end_op();
    800043c0:	fffff097          	auipc	ra,0xfffff
    800043c4:	428080e7          	jalr	1064(ra) # 800037e8 <end_op>
    return -1;
    800043c8:	557d                	li	a0,-1
    800043ca:	b7c5                	j	800043aa <exec+0x8e>
    800043cc:	f3da                	sd	s6,480(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    800043ce:	8526                	mv	a0,s1
    800043d0:	ffffd097          	auipc	ra,0xffffd
    800043d4:	d5e080e7          	jalr	-674(ra) # 8000112e <proc_pagetable>
    800043d8:	8b2a                	mv	s6,a0
    800043da:	2a050863          	beqz	a0,8000468a <exec+0x36e>
    800043de:	ffce                	sd	s3,504(sp)
    800043e0:	f7d6                	sd	s5,488(sp)
    800043e2:	efde                	sd	s7,472(sp)
    800043e4:	ebe2                	sd	s8,464(sp)
    800043e6:	e7e6                	sd	s9,456(sp)
    800043e8:	e3ea                	sd	s10,448(sp)
    800043ea:	ff6e                	sd	s11,440(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800043ec:	e7042683          	lw	a3,-400(s0)
    800043f0:	e8845783          	lhu	a5,-376(s0)
    800043f4:	cbfd                	beqz	a5,800044ea <exec+0x1ce>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800043f6:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800043f8:	4d01                	li	s10,0
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800043fa:	03800d93          	li	s11,56
    if((ph.vaddr % PGSIZE) != 0)
    800043fe:	6c85                	lui	s9,0x1
    80004400:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004404:	def43423          	sd	a5,-536(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80004408:	6a85                	lui	s5,0x1
    8000440a:	a0b5                	j	80004476 <exec+0x15a>
      panic("loadseg: address should exist");
    8000440c:	00004517          	auipc	a0,0x4
    80004410:	16c50513          	addi	a0,a0,364 # 80008578 <etext+0x578>
    80004414:	00002097          	auipc	ra,0x2
    80004418:	b1e080e7          	jalr	-1250(ra) # 80005f32 <panic>
    if(sz - i < PGSIZE)
    8000441c:	2901                	sext.w	s2,s2
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    8000441e:	874a                	mv	a4,s2
    80004420:	009c06bb          	addw	a3,s8,s1
    80004424:	4581                	li	a1,0
    80004426:	8552                	mv	a0,s4
    80004428:	fffff097          	auipc	ra,0xfffff
    8000442c:	c10080e7          	jalr	-1008(ra) # 80003038 <readi>
    80004430:	26a91163          	bne	s2,a0,80004692 <exec+0x376>
  for(i = 0; i < sz; i += PGSIZE){
    80004434:	009a84bb          	addw	s1,s5,s1
    80004438:	0334f463          	bgeu	s1,s3,80004460 <exec+0x144>
    pa = walkaddr(pagetable, va + i);
    8000443c:	02049593          	slli	a1,s1,0x20
    80004440:	9181                	srli	a1,a1,0x20
    80004442:	95de                	add	a1,a1,s7
    80004444:	855a                	mv	a0,s6
    80004446:	ffffc097          	auipc	ra,0xffffc
    8000444a:	198080e7          	jalr	408(ra) # 800005de <walkaddr>
    8000444e:	862a                	mv	a2,a0
    if(pa == 0)
    80004450:	dd55                	beqz	a0,8000440c <exec+0xf0>
    if(sz - i < PGSIZE)
    80004452:	409987bb          	subw	a5,s3,s1
    80004456:	893e                	mv	s2,a5
    80004458:	fcfcf2e3          	bgeu	s9,a5,8000441c <exec+0x100>
    8000445c:	8956                	mv	s2,s5
    8000445e:	bf7d                	j	8000441c <exec+0x100>
    sz = sz1;
    80004460:	df843483          	ld	s1,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004464:	2d05                	addiw	s10,s10,1
    80004466:	e0843783          	ld	a5,-504(s0)
    8000446a:	0387869b          	addiw	a3,a5,56
    8000446e:	e8845783          	lhu	a5,-376(s0)
    80004472:	06fd5d63          	bge	s10,a5,800044ec <exec+0x1d0>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004476:	e0d43423          	sd	a3,-504(s0)
    8000447a:	876e                	mv	a4,s11
    8000447c:	e1840613          	addi	a2,s0,-488
    80004480:	4581                	li	a1,0
    80004482:	8552                	mv	a0,s4
    80004484:	fffff097          	auipc	ra,0xfffff
    80004488:	bb4080e7          	jalr	-1100(ra) # 80003038 <readi>
    8000448c:	21b51163          	bne	a0,s11,8000468e <exec+0x372>
    if(ph.type != ELF_PROG_LOAD)
    80004490:	e1842783          	lw	a5,-488(s0)
    80004494:	4705                	li	a4,1
    80004496:	fce797e3          	bne	a5,a4,80004464 <exec+0x148>
    if(ph.memsz < ph.filesz)
    8000449a:	e4043603          	ld	a2,-448(s0)
    8000449e:	e3843783          	ld	a5,-456(s0)
    800044a2:	20f66863          	bltu	a2,a5,800046b2 <exec+0x396>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800044a6:	e2843783          	ld	a5,-472(s0)
    800044aa:	963e                	add	a2,a2,a5
    800044ac:	20f66663          	bltu	a2,a5,800046b8 <exec+0x39c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800044b0:	85a6                	mv	a1,s1
    800044b2:	855a                	mv	a0,s6
    800044b4:	ffffc097          	auipc	ra,0xffffc
    800044b8:	4ee080e7          	jalr	1262(ra) # 800009a2 <uvmalloc>
    800044bc:	dea43c23          	sd	a0,-520(s0)
    800044c0:	1e050f63          	beqz	a0,800046be <exec+0x3a2>
    if((ph.vaddr % PGSIZE) != 0)
    800044c4:	e2843b83          	ld	s7,-472(s0)
    800044c8:	de843783          	ld	a5,-536(s0)
    800044cc:	00fbf7b3          	and	a5,s7,a5
    800044d0:	1c079163          	bnez	a5,80004692 <exec+0x376>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800044d4:	e2042c03          	lw	s8,-480(s0)
    800044d8:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800044dc:	00098463          	beqz	s3,800044e4 <exec+0x1c8>
    800044e0:	4481                	li	s1,0
    800044e2:	bfa9                	j	8000443c <exec+0x120>
    sz = sz1;
    800044e4:	df843483          	ld	s1,-520(s0)
    800044e8:	bfb5                	j	80004464 <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800044ea:	4481                	li	s1,0
  iunlockput(ip);
    800044ec:	8552                	mv	a0,s4
    800044ee:	fffff097          	auipc	ra,0xfffff
    800044f2:	af4080e7          	jalr	-1292(ra) # 80002fe2 <iunlockput>
  end_op();
    800044f6:	fffff097          	auipc	ra,0xfffff
    800044fa:	2f2080e7          	jalr	754(ra) # 800037e8 <end_op>
  p = myproc();
    800044fe:	ffffd097          	auipc	ra,0xffffd
    80004502:	b6c080e7          	jalr	-1172(ra) # 8000106a <myproc>
    80004506:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004508:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    8000450c:	6985                	lui	s3,0x1
    8000450e:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80004510:	99a6                	add	s3,s3,s1
    80004512:	77fd                	lui	a5,0xfffff
    80004514:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004518:	6609                	lui	a2,0x2
    8000451a:	964e                	add	a2,a2,s3
    8000451c:	85ce                	mv	a1,s3
    8000451e:	855a                	mv	a0,s6
    80004520:	ffffc097          	auipc	ra,0xffffc
    80004524:	482080e7          	jalr	1154(ra) # 800009a2 <uvmalloc>
    80004528:	8a2a                	mv	s4,a0
    8000452a:	e115                	bnez	a0,8000454e <exec+0x232>
    proc_freepagetable(pagetable, sz);
    8000452c:	85ce                	mv	a1,s3
    8000452e:	855a                	mv	a0,s6
    80004530:	ffffd097          	auipc	ra,0xffffd
    80004534:	c9a080e7          	jalr	-870(ra) # 800011ca <proc_freepagetable>
  return -1;
    80004538:	557d                	li	a0,-1
    8000453a:	79fe                	ld	s3,504(sp)
    8000453c:	7a5e                	ld	s4,496(sp)
    8000453e:	7abe                	ld	s5,488(sp)
    80004540:	7b1e                	ld	s6,480(sp)
    80004542:	6bfe                	ld	s7,472(sp)
    80004544:	6c5e                	ld	s8,464(sp)
    80004546:	6cbe                	ld	s9,456(sp)
    80004548:	6d1e                	ld	s10,448(sp)
    8000454a:	7dfa                	ld	s11,440(sp)
    8000454c:	bdb9                	j	800043aa <exec+0x8e>
  uvmclear(pagetable, sz-2*PGSIZE);
    8000454e:	75f9                	lui	a1,0xffffe
    80004550:	95aa                	add	a1,a1,a0
    80004552:	855a                	mv	a0,s6
    80004554:	ffffc097          	auipc	ra,0xffffc
    80004558:	6b6080e7          	jalr	1718(ra) # 80000c0a <uvmclear>
  stackbase = sp - PGSIZE;
    8000455c:	7bfd                	lui	s7,0xfffff
    8000455e:	9bd2                	add	s7,s7,s4
  for(argc = 0; argv[argc]; argc++) {
    80004560:	e0043783          	ld	a5,-512(s0)
    80004564:	6388                	ld	a0,0(a5)
  sp = sz;
    80004566:	8952                	mv	s2,s4
  for(argc = 0; argv[argc]; argc++) {
    80004568:	4481                	li	s1,0
    ustack[argc] = sp;
    8000456a:	e9040c93          	addi	s9,s0,-368
    if(argc >= MAXARG)
    8000456e:	02000c13          	li	s8,32
  for(argc = 0; argv[argc]; argc++) {
    80004572:	c135                	beqz	a0,800045d6 <exec+0x2ba>
    sp -= strlen(argv[argc]) + 1;
    80004574:	ffffc097          	auipc	ra,0xffffc
    80004578:	e58080e7          	jalr	-424(ra) # 800003cc <strlen>
    8000457c:	0015079b          	addiw	a5,a0,1
    80004580:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004584:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80004588:	13796e63          	bltu	s2,s7,800046c4 <exec+0x3a8>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000458c:	e0043d83          	ld	s11,-512(s0)
    80004590:	000db983          	ld	s3,0(s11)
    80004594:	854e                	mv	a0,s3
    80004596:	ffffc097          	auipc	ra,0xffffc
    8000459a:	e36080e7          	jalr	-458(ra) # 800003cc <strlen>
    8000459e:	0015069b          	addiw	a3,a0,1
    800045a2:	864e                	mv	a2,s3
    800045a4:	85ca                	mv	a1,s2
    800045a6:	855a                	mv	a0,s6
    800045a8:	ffffc097          	auipc	ra,0xffffc
    800045ac:	694080e7          	jalr	1684(ra) # 80000c3c <copyout>
    800045b0:	10054c63          	bltz	a0,800046c8 <exec+0x3ac>
    ustack[argc] = sp;
    800045b4:	00349793          	slli	a5,s1,0x3
    800045b8:	97e6                	add	a5,a5,s9
    800045ba:	0127b023          	sd	s2,0(a5) # fffffffffffff000 <end+0xffffffff7fdb8dc0>
  for(argc = 0; argv[argc]; argc++) {
    800045be:	0485                	addi	s1,s1,1
    800045c0:	008d8793          	addi	a5,s11,8
    800045c4:	e0f43023          	sd	a5,-512(s0)
    800045c8:	008db503          	ld	a0,8(s11)
    800045cc:	c509                	beqz	a0,800045d6 <exec+0x2ba>
    if(argc >= MAXARG)
    800045ce:	fb8493e3          	bne	s1,s8,80004574 <exec+0x258>
  sz = sz1;
    800045d2:	89d2                	mv	s3,s4
    800045d4:	bfa1                	j	8000452c <exec+0x210>
  ustack[argc] = 0;
    800045d6:	00349793          	slli	a5,s1,0x3
    800045da:	f9078793          	addi	a5,a5,-112
    800045de:	97a2                	add	a5,a5,s0
    800045e0:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    800045e4:	00148693          	addi	a3,s1,1
    800045e8:	068e                	slli	a3,a3,0x3
    800045ea:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800045ee:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    800045f2:	89d2                	mv	s3,s4
  if(sp < stackbase)
    800045f4:	f3796ce3          	bltu	s2,s7,8000452c <exec+0x210>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800045f8:	e9040613          	addi	a2,s0,-368
    800045fc:	85ca                	mv	a1,s2
    800045fe:	855a                	mv	a0,s6
    80004600:	ffffc097          	auipc	ra,0xffffc
    80004604:	63c080e7          	jalr	1596(ra) # 80000c3c <copyout>
    80004608:	f20542e3          	bltz	a0,8000452c <exec+0x210>
  p->trapframe->a1 = sp;
    8000460c:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80004610:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004614:	df043783          	ld	a5,-528(s0)
    80004618:	0007c703          	lbu	a4,0(a5)
    8000461c:	cf11                	beqz	a4,80004638 <exec+0x31c>
    8000461e:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004620:	02f00693          	li	a3,47
    80004624:	a029                	j	8000462e <exec+0x312>
  for(last=s=path; *s; s++)
    80004626:	0785                	addi	a5,a5,1
    80004628:	fff7c703          	lbu	a4,-1(a5)
    8000462c:	c711                	beqz	a4,80004638 <exec+0x31c>
    if(*s == '/')
    8000462e:	fed71ce3          	bne	a4,a3,80004626 <exec+0x30a>
      last = s+1;
    80004632:	def43823          	sd	a5,-528(s0)
    80004636:	bfc5                	j	80004626 <exec+0x30a>
  safestrcpy(p->name, last, sizeof(p->name));
    80004638:	4641                	li	a2,16
    8000463a:	df043583          	ld	a1,-528(s0)
    8000463e:	158a8513          	addi	a0,s5,344
    80004642:	ffffc097          	auipc	ra,0xffffc
    80004646:	d54080e7          	jalr	-684(ra) # 80000396 <safestrcpy>
  oldpagetable = p->pagetable;
    8000464a:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    8000464e:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80004652:	054ab423          	sd	s4,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004656:	058ab783          	ld	a5,88(s5)
    8000465a:	e6843703          	ld	a4,-408(s0)
    8000465e:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004660:	058ab783          	ld	a5,88(s5)
    80004664:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004668:	85ea                	mv	a1,s10
    8000466a:	ffffd097          	auipc	ra,0xffffd
    8000466e:	b60080e7          	jalr	-1184(ra) # 800011ca <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004672:	0004851b          	sext.w	a0,s1
    80004676:	79fe                	ld	s3,504(sp)
    80004678:	7a5e                	ld	s4,496(sp)
    8000467a:	7abe                	ld	s5,488(sp)
    8000467c:	7b1e                	ld	s6,480(sp)
    8000467e:	6bfe                	ld	s7,472(sp)
    80004680:	6c5e                	ld	s8,464(sp)
    80004682:	6cbe                	ld	s9,456(sp)
    80004684:	6d1e                	ld	s10,448(sp)
    80004686:	7dfa                	ld	s11,440(sp)
    80004688:	b30d                	j	800043aa <exec+0x8e>
    8000468a:	7b1e                	ld	s6,480(sp)
    8000468c:	b321                	j	80004394 <exec+0x78>
    8000468e:	de943c23          	sd	s1,-520(s0)
    proc_freepagetable(pagetable, sz);
    80004692:	df843583          	ld	a1,-520(s0)
    80004696:	855a                	mv	a0,s6
    80004698:	ffffd097          	auipc	ra,0xffffd
    8000469c:	b32080e7          	jalr	-1230(ra) # 800011ca <proc_freepagetable>
  if(ip){
    800046a0:	79fe                	ld	s3,504(sp)
    800046a2:	7abe                	ld	s5,488(sp)
    800046a4:	7b1e                	ld	s6,480(sp)
    800046a6:	6bfe                	ld	s7,472(sp)
    800046a8:	6c5e                	ld	s8,464(sp)
    800046aa:	6cbe                	ld	s9,456(sp)
    800046ac:	6d1e                	ld	s10,448(sp)
    800046ae:	7dfa                	ld	s11,440(sp)
    800046b0:	b1d5                	j	80004394 <exec+0x78>
    800046b2:	de943c23          	sd	s1,-520(s0)
    800046b6:	bff1                	j	80004692 <exec+0x376>
    800046b8:	de943c23          	sd	s1,-520(s0)
    800046bc:	bfd9                	j	80004692 <exec+0x376>
    800046be:	de943c23          	sd	s1,-520(s0)
    800046c2:	bfc1                	j	80004692 <exec+0x376>
  sz = sz1;
    800046c4:	89d2                	mv	s3,s4
    800046c6:	b59d                	j	8000452c <exec+0x210>
    800046c8:	89d2                	mv	s3,s4
    800046ca:	b58d                	j	8000452c <exec+0x210>

00000000800046cc <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800046cc:	7179                	addi	sp,sp,-48
    800046ce:	f406                	sd	ra,40(sp)
    800046d0:	f022                	sd	s0,32(sp)
    800046d2:	ec26                	sd	s1,24(sp)
    800046d4:	e84a                	sd	s2,16(sp)
    800046d6:	1800                	addi	s0,sp,48
    800046d8:	892e                	mv	s2,a1
    800046da:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    800046dc:	fdc40593          	addi	a1,s0,-36
    800046e0:	ffffe097          	auipc	ra,0xffffe
    800046e4:	b48080e7          	jalr	-1208(ra) # 80002228 <argint>
    800046e8:	04054063          	bltz	a0,80004728 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800046ec:	fdc42703          	lw	a4,-36(s0)
    800046f0:	47bd                	li	a5,15
    800046f2:	02e7ed63          	bltu	a5,a4,8000472c <argfd+0x60>
    800046f6:	ffffd097          	auipc	ra,0xffffd
    800046fa:	974080e7          	jalr	-1676(ra) # 8000106a <myproc>
    800046fe:	fdc42703          	lw	a4,-36(s0)
    80004702:	01a70793          	addi	a5,a4,26
    80004706:	078e                	slli	a5,a5,0x3
    80004708:	953e                	add	a0,a0,a5
    8000470a:	611c                	ld	a5,0(a0)
    8000470c:	c395                	beqz	a5,80004730 <argfd+0x64>
    return -1;
  if(pfd)
    8000470e:	00090463          	beqz	s2,80004716 <argfd+0x4a>
    *pfd = fd;
    80004712:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004716:	4501                	li	a0,0
  if(pf)
    80004718:	c091                	beqz	s1,8000471c <argfd+0x50>
    *pf = f;
    8000471a:	e09c                	sd	a5,0(s1)
}
    8000471c:	70a2                	ld	ra,40(sp)
    8000471e:	7402                	ld	s0,32(sp)
    80004720:	64e2                	ld	s1,24(sp)
    80004722:	6942                	ld	s2,16(sp)
    80004724:	6145                	addi	sp,sp,48
    80004726:	8082                	ret
    return -1;
    80004728:	557d                	li	a0,-1
    8000472a:	bfcd                	j	8000471c <argfd+0x50>
    return -1;
    8000472c:	557d                	li	a0,-1
    8000472e:	b7fd                	j	8000471c <argfd+0x50>
    80004730:	557d                	li	a0,-1
    80004732:	b7ed                	j	8000471c <argfd+0x50>

0000000080004734 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004734:	1101                	addi	sp,sp,-32
    80004736:	ec06                	sd	ra,24(sp)
    80004738:	e822                	sd	s0,16(sp)
    8000473a:	e426                	sd	s1,8(sp)
    8000473c:	1000                	addi	s0,sp,32
    8000473e:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004740:	ffffd097          	auipc	ra,0xffffd
    80004744:	92a080e7          	jalr	-1750(ra) # 8000106a <myproc>
    80004748:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    8000474a:	0d050793          	addi	a5,a0,208
    8000474e:	4501                	li	a0,0
    80004750:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004752:	6398                	ld	a4,0(a5)
    80004754:	cb19                	beqz	a4,8000476a <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004756:	2505                	addiw	a0,a0,1
    80004758:	07a1                	addi	a5,a5,8
    8000475a:	fed51ce3          	bne	a0,a3,80004752 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000475e:	557d                	li	a0,-1
}
    80004760:	60e2                	ld	ra,24(sp)
    80004762:	6442                	ld	s0,16(sp)
    80004764:	64a2                	ld	s1,8(sp)
    80004766:	6105                	addi	sp,sp,32
    80004768:	8082                	ret
      p->ofile[fd] = f;
    8000476a:	01a50793          	addi	a5,a0,26
    8000476e:	078e                	slli	a5,a5,0x3
    80004770:	963e                	add	a2,a2,a5
    80004772:	e204                	sd	s1,0(a2)
      return fd;
    80004774:	b7f5                	j	80004760 <fdalloc+0x2c>

0000000080004776 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004776:	715d                	addi	sp,sp,-80
    80004778:	e486                	sd	ra,72(sp)
    8000477a:	e0a2                	sd	s0,64(sp)
    8000477c:	fc26                	sd	s1,56(sp)
    8000477e:	f84a                	sd	s2,48(sp)
    80004780:	f44e                	sd	s3,40(sp)
    80004782:	f052                	sd	s4,32(sp)
    80004784:	ec56                	sd	s5,24(sp)
    80004786:	0880                	addi	s0,sp,80
    80004788:	8aae                	mv	s5,a1
    8000478a:	8a32                	mv	s4,a2
    8000478c:	89b6                	mv	s3,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    8000478e:	fb040593          	addi	a1,s0,-80
    80004792:	fffff097          	auipc	ra,0xfffff
    80004796:	df4080e7          	jalr	-524(ra) # 80003586 <nameiparent>
    8000479a:	892a                	mv	s2,a0
    8000479c:	12050c63          	beqz	a0,800048d4 <create+0x15e>
    return 0;

  ilock(dp);
    800047a0:	ffffe097          	auipc	ra,0xffffe
    800047a4:	5dc080e7          	jalr	1500(ra) # 80002d7c <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800047a8:	4601                	li	a2,0
    800047aa:	fb040593          	addi	a1,s0,-80
    800047ae:	854a                	mv	a0,s2
    800047b0:	fffff097          	auipc	ra,0xfffff
    800047b4:	abc080e7          	jalr	-1348(ra) # 8000326c <dirlookup>
    800047b8:	84aa                	mv	s1,a0
    800047ba:	c539                	beqz	a0,80004808 <create+0x92>
    iunlockput(dp);
    800047bc:	854a                	mv	a0,s2
    800047be:	fffff097          	auipc	ra,0xfffff
    800047c2:	824080e7          	jalr	-2012(ra) # 80002fe2 <iunlockput>
    ilock(ip);
    800047c6:	8526                	mv	a0,s1
    800047c8:	ffffe097          	auipc	ra,0xffffe
    800047cc:	5b4080e7          	jalr	1460(ra) # 80002d7c <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800047d0:	4789                	li	a5,2
    800047d2:	02fa9463          	bne	s5,a5,800047fa <create+0x84>
    800047d6:	0444d783          	lhu	a5,68(s1)
    800047da:	37f9                	addiw	a5,a5,-2
    800047dc:	17c2                	slli	a5,a5,0x30
    800047de:	93c1                	srli	a5,a5,0x30
    800047e0:	4705                	li	a4,1
    800047e2:	00f76c63          	bltu	a4,a5,800047fa <create+0x84>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    800047e6:	8526                	mv	a0,s1
    800047e8:	60a6                	ld	ra,72(sp)
    800047ea:	6406                	ld	s0,64(sp)
    800047ec:	74e2                	ld	s1,56(sp)
    800047ee:	7942                	ld	s2,48(sp)
    800047f0:	79a2                	ld	s3,40(sp)
    800047f2:	7a02                	ld	s4,32(sp)
    800047f4:	6ae2                	ld	s5,24(sp)
    800047f6:	6161                	addi	sp,sp,80
    800047f8:	8082                	ret
    iunlockput(ip);
    800047fa:	8526                	mv	a0,s1
    800047fc:	ffffe097          	auipc	ra,0xffffe
    80004800:	7e6080e7          	jalr	2022(ra) # 80002fe2 <iunlockput>
    return 0;
    80004804:	4481                	li	s1,0
    80004806:	b7c5                	j	800047e6 <create+0x70>
  if((ip = ialloc(dp->dev, type)) == 0)
    80004808:	85d6                	mv	a1,s5
    8000480a:	00092503          	lw	a0,0(s2)
    8000480e:	ffffe097          	auipc	ra,0xffffe
    80004812:	3da080e7          	jalr	986(ra) # 80002be8 <ialloc>
    80004816:	84aa                	mv	s1,a0
    80004818:	c139                	beqz	a0,8000485e <create+0xe8>
  ilock(ip);
    8000481a:	ffffe097          	auipc	ra,0xffffe
    8000481e:	562080e7          	jalr	1378(ra) # 80002d7c <ilock>
  ip->major = major;
    80004822:	05449323          	sh	s4,70(s1)
  ip->minor = minor;
    80004826:	05349423          	sh	s3,72(s1)
  ip->nlink = 1;
    8000482a:	4985                	li	s3,1
    8000482c:	05349523          	sh	s3,74(s1)
  iupdate(ip);
    80004830:	8526                	mv	a0,s1
    80004832:	ffffe097          	auipc	ra,0xffffe
    80004836:	47e080e7          	jalr	1150(ra) # 80002cb0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    8000483a:	033a8a63          	beq	s5,s3,8000486e <create+0xf8>
  if(dirlink(dp, name, ip->inum) < 0)
    8000483e:	40d0                	lw	a2,4(s1)
    80004840:	fb040593          	addi	a1,s0,-80
    80004844:	854a                	mv	a0,s2
    80004846:	fffff097          	auipc	ra,0xfffff
    8000484a:	c4c080e7          	jalr	-948(ra) # 80003492 <dirlink>
    8000484e:	06054b63          	bltz	a0,800048c4 <create+0x14e>
  iunlockput(dp);
    80004852:	854a                	mv	a0,s2
    80004854:	ffffe097          	auipc	ra,0xffffe
    80004858:	78e080e7          	jalr	1934(ra) # 80002fe2 <iunlockput>
  return ip;
    8000485c:	b769                	j	800047e6 <create+0x70>
    panic("create: ialloc");
    8000485e:	00004517          	auipc	a0,0x4
    80004862:	d3a50513          	addi	a0,a0,-710 # 80008598 <etext+0x598>
    80004866:	00001097          	auipc	ra,0x1
    8000486a:	6cc080e7          	jalr	1740(ra) # 80005f32 <panic>
    dp->nlink++;  // for ".."
    8000486e:	04a95783          	lhu	a5,74(s2)
    80004872:	2785                	addiw	a5,a5,1
    80004874:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    80004878:	854a                	mv	a0,s2
    8000487a:	ffffe097          	auipc	ra,0xffffe
    8000487e:	436080e7          	jalr	1078(ra) # 80002cb0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004882:	40d0                	lw	a2,4(s1)
    80004884:	00004597          	auipc	a1,0x4
    80004888:	d2458593          	addi	a1,a1,-732 # 800085a8 <etext+0x5a8>
    8000488c:	8526                	mv	a0,s1
    8000488e:	fffff097          	auipc	ra,0xfffff
    80004892:	c04080e7          	jalr	-1020(ra) # 80003492 <dirlink>
    80004896:	00054f63          	bltz	a0,800048b4 <create+0x13e>
    8000489a:	00492603          	lw	a2,4(s2)
    8000489e:	00004597          	auipc	a1,0x4
    800048a2:	d1258593          	addi	a1,a1,-750 # 800085b0 <etext+0x5b0>
    800048a6:	8526                	mv	a0,s1
    800048a8:	fffff097          	auipc	ra,0xfffff
    800048ac:	bea080e7          	jalr	-1046(ra) # 80003492 <dirlink>
    800048b0:	f80557e3          	bgez	a0,8000483e <create+0xc8>
      panic("create dots");
    800048b4:	00004517          	auipc	a0,0x4
    800048b8:	d0450513          	addi	a0,a0,-764 # 800085b8 <etext+0x5b8>
    800048bc:	00001097          	auipc	ra,0x1
    800048c0:	676080e7          	jalr	1654(ra) # 80005f32 <panic>
    panic("create: dirlink");
    800048c4:	00004517          	auipc	a0,0x4
    800048c8:	d0450513          	addi	a0,a0,-764 # 800085c8 <etext+0x5c8>
    800048cc:	00001097          	auipc	ra,0x1
    800048d0:	666080e7          	jalr	1638(ra) # 80005f32 <panic>
    return 0;
    800048d4:	84aa                	mv	s1,a0
    800048d6:	bf01                	j	800047e6 <create+0x70>

00000000800048d8 <sys_dup>:
{
    800048d8:	7179                	addi	sp,sp,-48
    800048da:	f406                	sd	ra,40(sp)
    800048dc:	f022                	sd	s0,32(sp)
    800048de:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800048e0:	fd840613          	addi	a2,s0,-40
    800048e4:	4581                	li	a1,0
    800048e6:	4501                	li	a0,0
    800048e8:	00000097          	auipc	ra,0x0
    800048ec:	de4080e7          	jalr	-540(ra) # 800046cc <argfd>
    return -1;
    800048f0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800048f2:	02054763          	bltz	a0,80004920 <sys_dup+0x48>
    800048f6:	ec26                	sd	s1,24(sp)
    800048f8:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    800048fa:	fd843903          	ld	s2,-40(s0)
    800048fe:	854a                	mv	a0,s2
    80004900:	00000097          	auipc	ra,0x0
    80004904:	e34080e7          	jalr	-460(ra) # 80004734 <fdalloc>
    80004908:	84aa                	mv	s1,a0
    return -1;
    8000490a:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    8000490c:	00054f63          	bltz	a0,8000492a <sys_dup+0x52>
  filedup(f);
    80004910:	854a                	mv	a0,s2
    80004912:	fffff097          	auipc	ra,0xfffff
    80004916:	2da080e7          	jalr	730(ra) # 80003bec <filedup>
  return fd;
    8000491a:	87a6                	mv	a5,s1
    8000491c:	64e2                	ld	s1,24(sp)
    8000491e:	6942                	ld	s2,16(sp)
}
    80004920:	853e                	mv	a0,a5
    80004922:	70a2                	ld	ra,40(sp)
    80004924:	7402                	ld	s0,32(sp)
    80004926:	6145                	addi	sp,sp,48
    80004928:	8082                	ret
    8000492a:	64e2                	ld	s1,24(sp)
    8000492c:	6942                	ld	s2,16(sp)
    8000492e:	bfcd                	j	80004920 <sys_dup+0x48>

0000000080004930 <sys_read>:
{
    80004930:	7179                	addi	sp,sp,-48
    80004932:	f406                	sd	ra,40(sp)
    80004934:	f022                	sd	s0,32(sp)
    80004936:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004938:	fe840613          	addi	a2,s0,-24
    8000493c:	4581                	li	a1,0
    8000493e:	4501                	li	a0,0
    80004940:	00000097          	auipc	ra,0x0
    80004944:	d8c080e7          	jalr	-628(ra) # 800046cc <argfd>
    return -1;
    80004948:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000494a:	04054163          	bltz	a0,8000498c <sys_read+0x5c>
    8000494e:	fe440593          	addi	a1,s0,-28
    80004952:	4509                	li	a0,2
    80004954:	ffffe097          	auipc	ra,0xffffe
    80004958:	8d4080e7          	jalr	-1836(ra) # 80002228 <argint>
    return -1;
    8000495c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000495e:	02054763          	bltz	a0,8000498c <sys_read+0x5c>
    80004962:	fd840593          	addi	a1,s0,-40
    80004966:	4505                	li	a0,1
    80004968:	ffffe097          	auipc	ra,0xffffe
    8000496c:	8e2080e7          	jalr	-1822(ra) # 8000224a <argaddr>
    return -1;
    80004970:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004972:	00054d63          	bltz	a0,8000498c <sys_read+0x5c>
  return fileread(f, p, n);
    80004976:	fe442603          	lw	a2,-28(s0)
    8000497a:	fd843583          	ld	a1,-40(s0)
    8000497e:	fe843503          	ld	a0,-24(s0)
    80004982:	fffff097          	auipc	ra,0xfffff
    80004986:	410080e7          	jalr	1040(ra) # 80003d92 <fileread>
    8000498a:	87aa                	mv	a5,a0
}
    8000498c:	853e                	mv	a0,a5
    8000498e:	70a2                	ld	ra,40(sp)
    80004990:	7402                	ld	s0,32(sp)
    80004992:	6145                	addi	sp,sp,48
    80004994:	8082                	ret

0000000080004996 <sys_write>:
{
    80004996:	7179                	addi	sp,sp,-48
    80004998:	f406                	sd	ra,40(sp)
    8000499a:	f022                	sd	s0,32(sp)
    8000499c:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000499e:	fe840613          	addi	a2,s0,-24
    800049a2:	4581                	li	a1,0
    800049a4:	4501                	li	a0,0
    800049a6:	00000097          	auipc	ra,0x0
    800049aa:	d26080e7          	jalr	-730(ra) # 800046cc <argfd>
    return -1;
    800049ae:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800049b0:	04054163          	bltz	a0,800049f2 <sys_write+0x5c>
    800049b4:	fe440593          	addi	a1,s0,-28
    800049b8:	4509                	li	a0,2
    800049ba:	ffffe097          	auipc	ra,0xffffe
    800049be:	86e080e7          	jalr	-1938(ra) # 80002228 <argint>
    return -1;
    800049c2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800049c4:	02054763          	bltz	a0,800049f2 <sys_write+0x5c>
    800049c8:	fd840593          	addi	a1,s0,-40
    800049cc:	4505                	li	a0,1
    800049ce:	ffffe097          	auipc	ra,0xffffe
    800049d2:	87c080e7          	jalr	-1924(ra) # 8000224a <argaddr>
    return -1;
    800049d6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800049d8:	00054d63          	bltz	a0,800049f2 <sys_write+0x5c>
  return filewrite(f, p, n);
    800049dc:	fe442603          	lw	a2,-28(s0)
    800049e0:	fd843583          	ld	a1,-40(s0)
    800049e4:	fe843503          	ld	a0,-24(s0)
    800049e8:	fffff097          	auipc	ra,0xfffff
    800049ec:	47c080e7          	jalr	1148(ra) # 80003e64 <filewrite>
    800049f0:	87aa                	mv	a5,a0
}
    800049f2:	853e                	mv	a0,a5
    800049f4:	70a2                	ld	ra,40(sp)
    800049f6:	7402                	ld	s0,32(sp)
    800049f8:	6145                	addi	sp,sp,48
    800049fa:	8082                	ret

00000000800049fc <sys_close>:
{
    800049fc:	1101                	addi	sp,sp,-32
    800049fe:	ec06                	sd	ra,24(sp)
    80004a00:	e822                	sd	s0,16(sp)
    80004a02:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004a04:	fe040613          	addi	a2,s0,-32
    80004a08:	fec40593          	addi	a1,s0,-20
    80004a0c:	4501                	li	a0,0
    80004a0e:	00000097          	auipc	ra,0x0
    80004a12:	cbe080e7          	jalr	-834(ra) # 800046cc <argfd>
    return -1;
    80004a16:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004a18:	02054463          	bltz	a0,80004a40 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004a1c:	ffffc097          	auipc	ra,0xffffc
    80004a20:	64e080e7          	jalr	1614(ra) # 8000106a <myproc>
    80004a24:	fec42783          	lw	a5,-20(s0)
    80004a28:	07e9                	addi	a5,a5,26
    80004a2a:	078e                	slli	a5,a5,0x3
    80004a2c:	953e                	add	a0,a0,a5
    80004a2e:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004a32:	fe043503          	ld	a0,-32(s0)
    80004a36:	fffff097          	auipc	ra,0xfffff
    80004a3a:	208080e7          	jalr	520(ra) # 80003c3e <fileclose>
  return 0;
    80004a3e:	4781                	li	a5,0
}
    80004a40:	853e                	mv	a0,a5
    80004a42:	60e2                	ld	ra,24(sp)
    80004a44:	6442                	ld	s0,16(sp)
    80004a46:	6105                	addi	sp,sp,32
    80004a48:	8082                	ret

0000000080004a4a <sys_fstat>:
{
    80004a4a:	1101                	addi	sp,sp,-32
    80004a4c:	ec06                	sd	ra,24(sp)
    80004a4e:	e822                	sd	s0,16(sp)
    80004a50:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004a52:	fe840613          	addi	a2,s0,-24
    80004a56:	4581                	li	a1,0
    80004a58:	4501                	li	a0,0
    80004a5a:	00000097          	auipc	ra,0x0
    80004a5e:	c72080e7          	jalr	-910(ra) # 800046cc <argfd>
    return -1;
    80004a62:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004a64:	02054563          	bltz	a0,80004a8e <sys_fstat+0x44>
    80004a68:	fe040593          	addi	a1,s0,-32
    80004a6c:	4505                	li	a0,1
    80004a6e:	ffffd097          	auipc	ra,0xffffd
    80004a72:	7dc080e7          	jalr	2012(ra) # 8000224a <argaddr>
    return -1;
    80004a76:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004a78:	00054b63          	bltz	a0,80004a8e <sys_fstat+0x44>
  return filestat(f, st);
    80004a7c:	fe043583          	ld	a1,-32(s0)
    80004a80:	fe843503          	ld	a0,-24(s0)
    80004a84:	fffff097          	auipc	ra,0xfffff
    80004a88:	298080e7          	jalr	664(ra) # 80003d1c <filestat>
    80004a8c:	87aa                	mv	a5,a0
}
    80004a8e:	853e                	mv	a0,a5
    80004a90:	60e2                	ld	ra,24(sp)
    80004a92:	6442                	ld	s0,16(sp)
    80004a94:	6105                	addi	sp,sp,32
    80004a96:	8082                	ret

0000000080004a98 <sys_link>:
{
    80004a98:	7169                	addi	sp,sp,-304
    80004a9a:	f606                	sd	ra,296(sp)
    80004a9c:	f222                	sd	s0,288(sp)
    80004a9e:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004aa0:	08000613          	li	a2,128
    80004aa4:	ed040593          	addi	a1,s0,-304
    80004aa8:	4501                	li	a0,0
    80004aaa:	ffffd097          	auipc	ra,0xffffd
    80004aae:	7c2080e7          	jalr	1986(ra) # 8000226c <argstr>
    return -1;
    80004ab2:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004ab4:	12054663          	bltz	a0,80004be0 <sys_link+0x148>
    80004ab8:	08000613          	li	a2,128
    80004abc:	f5040593          	addi	a1,s0,-176
    80004ac0:	4505                	li	a0,1
    80004ac2:	ffffd097          	auipc	ra,0xffffd
    80004ac6:	7aa080e7          	jalr	1962(ra) # 8000226c <argstr>
    return -1;
    80004aca:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004acc:	10054a63          	bltz	a0,80004be0 <sys_link+0x148>
    80004ad0:	ee26                	sd	s1,280(sp)
  begin_op();
    80004ad2:	fffff097          	auipc	ra,0xfffff
    80004ad6:	c9c080e7          	jalr	-868(ra) # 8000376e <begin_op>
  if((ip = namei(old)) == 0){
    80004ada:	ed040513          	addi	a0,s0,-304
    80004ade:	fffff097          	auipc	ra,0xfffff
    80004ae2:	a8a080e7          	jalr	-1398(ra) # 80003568 <namei>
    80004ae6:	84aa                	mv	s1,a0
    80004ae8:	c949                	beqz	a0,80004b7a <sys_link+0xe2>
  ilock(ip);
    80004aea:	ffffe097          	auipc	ra,0xffffe
    80004aee:	292080e7          	jalr	658(ra) # 80002d7c <ilock>
  if(ip->type == T_DIR){
    80004af2:	04449703          	lh	a4,68(s1)
    80004af6:	4785                	li	a5,1
    80004af8:	08f70863          	beq	a4,a5,80004b88 <sys_link+0xf0>
    80004afc:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004afe:	04a4d783          	lhu	a5,74(s1)
    80004b02:	2785                	addiw	a5,a5,1
    80004b04:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004b08:	8526                	mv	a0,s1
    80004b0a:	ffffe097          	auipc	ra,0xffffe
    80004b0e:	1a6080e7          	jalr	422(ra) # 80002cb0 <iupdate>
  iunlock(ip);
    80004b12:	8526                	mv	a0,s1
    80004b14:	ffffe097          	auipc	ra,0xffffe
    80004b18:	32e080e7          	jalr	814(ra) # 80002e42 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004b1c:	fd040593          	addi	a1,s0,-48
    80004b20:	f5040513          	addi	a0,s0,-176
    80004b24:	fffff097          	auipc	ra,0xfffff
    80004b28:	a62080e7          	jalr	-1438(ra) # 80003586 <nameiparent>
    80004b2c:	892a                	mv	s2,a0
    80004b2e:	cd35                	beqz	a0,80004baa <sys_link+0x112>
  ilock(dp);
    80004b30:	ffffe097          	auipc	ra,0xffffe
    80004b34:	24c080e7          	jalr	588(ra) # 80002d7c <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004b38:	00092703          	lw	a4,0(s2)
    80004b3c:	409c                	lw	a5,0(s1)
    80004b3e:	06f71163          	bne	a4,a5,80004ba0 <sys_link+0x108>
    80004b42:	40d0                	lw	a2,4(s1)
    80004b44:	fd040593          	addi	a1,s0,-48
    80004b48:	854a                	mv	a0,s2
    80004b4a:	fffff097          	auipc	ra,0xfffff
    80004b4e:	948080e7          	jalr	-1720(ra) # 80003492 <dirlink>
    80004b52:	04054763          	bltz	a0,80004ba0 <sys_link+0x108>
  iunlockput(dp);
    80004b56:	854a                	mv	a0,s2
    80004b58:	ffffe097          	auipc	ra,0xffffe
    80004b5c:	48a080e7          	jalr	1162(ra) # 80002fe2 <iunlockput>
  iput(ip);
    80004b60:	8526                	mv	a0,s1
    80004b62:	ffffe097          	auipc	ra,0xffffe
    80004b66:	3d8080e7          	jalr	984(ra) # 80002f3a <iput>
  end_op();
    80004b6a:	fffff097          	auipc	ra,0xfffff
    80004b6e:	c7e080e7          	jalr	-898(ra) # 800037e8 <end_op>
  return 0;
    80004b72:	4781                	li	a5,0
    80004b74:	64f2                	ld	s1,280(sp)
    80004b76:	6952                	ld	s2,272(sp)
    80004b78:	a0a5                	j	80004be0 <sys_link+0x148>
    end_op();
    80004b7a:	fffff097          	auipc	ra,0xfffff
    80004b7e:	c6e080e7          	jalr	-914(ra) # 800037e8 <end_op>
    return -1;
    80004b82:	57fd                	li	a5,-1
    80004b84:	64f2                	ld	s1,280(sp)
    80004b86:	a8a9                	j	80004be0 <sys_link+0x148>
    iunlockput(ip);
    80004b88:	8526                	mv	a0,s1
    80004b8a:	ffffe097          	auipc	ra,0xffffe
    80004b8e:	458080e7          	jalr	1112(ra) # 80002fe2 <iunlockput>
    end_op();
    80004b92:	fffff097          	auipc	ra,0xfffff
    80004b96:	c56080e7          	jalr	-938(ra) # 800037e8 <end_op>
    return -1;
    80004b9a:	57fd                	li	a5,-1
    80004b9c:	64f2                	ld	s1,280(sp)
    80004b9e:	a089                	j	80004be0 <sys_link+0x148>
    iunlockput(dp);
    80004ba0:	854a                	mv	a0,s2
    80004ba2:	ffffe097          	auipc	ra,0xffffe
    80004ba6:	440080e7          	jalr	1088(ra) # 80002fe2 <iunlockput>
  ilock(ip);
    80004baa:	8526                	mv	a0,s1
    80004bac:	ffffe097          	auipc	ra,0xffffe
    80004bb0:	1d0080e7          	jalr	464(ra) # 80002d7c <ilock>
  ip->nlink--;
    80004bb4:	04a4d783          	lhu	a5,74(s1)
    80004bb8:	37fd                	addiw	a5,a5,-1
    80004bba:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004bbe:	8526                	mv	a0,s1
    80004bc0:	ffffe097          	auipc	ra,0xffffe
    80004bc4:	0f0080e7          	jalr	240(ra) # 80002cb0 <iupdate>
  iunlockput(ip);
    80004bc8:	8526                	mv	a0,s1
    80004bca:	ffffe097          	auipc	ra,0xffffe
    80004bce:	418080e7          	jalr	1048(ra) # 80002fe2 <iunlockput>
  end_op();
    80004bd2:	fffff097          	auipc	ra,0xfffff
    80004bd6:	c16080e7          	jalr	-1002(ra) # 800037e8 <end_op>
  return -1;
    80004bda:	57fd                	li	a5,-1
    80004bdc:	64f2                	ld	s1,280(sp)
    80004bde:	6952                	ld	s2,272(sp)
}
    80004be0:	853e                	mv	a0,a5
    80004be2:	70b2                	ld	ra,296(sp)
    80004be4:	7412                	ld	s0,288(sp)
    80004be6:	6155                	addi	sp,sp,304
    80004be8:	8082                	ret

0000000080004bea <sys_unlink>:
{
    80004bea:	7111                	addi	sp,sp,-256
    80004bec:	fd86                	sd	ra,248(sp)
    80004bee:	f9a2                	sd	s0,240(sp)
    80004bf0:	0200                	addi	s0,sp,256
  if(argstr(0, path, MAXPATH) < 0)
    80004bf2:	08000613          	li	a2,128
    80004bf6:	f2040593          	addi	a1,s0,-224
    80004bfa:	4501                	li	a0,0
    80004bfc:	ffffd097          	auipc	ra,0xffffd
    80004c00:	670080e7          	jalr	1648(ra) # 8000226c <argstr>
    80004c04:	1c054063          	bltz	a0,80004dc4 <sys_unlink+0x1da>
    80004c08:	f5a6                	sd	s1,232(sp)
  begin_op();
    80004c0a:	fffff097          	auipc	ra,0xfffff
    80004c0e:	b64080e7          	jalr	-1180(ra) # 8000376e <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004c12:	fa040593          	addi	a1,s0,-96
    80004c16:	f2040513          	addi	a0,s0,-224
    80004c1a:	fffff097          	auipc	ra,0xfffff
    80004c1e:	96c080e7          	jalr	-1684(ra) # 80003586 <nameiparent>
    80004c22:	84aa                	mv	s1,a0
    80004c24:	c165                	beqz	a0,80004d04 <sys_unlink+0x11a>
  ilock(dp);
    80004c26:	ffffe097          	auipc	ra,0xffffe
    80004c2a:	156080e7          	jalr	342(ra) # 80002d7c <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004c2e:	00004597          	auipc	a1,0x4
    80004c32:	97a58593          	addi	a1,a1,-1670 # 800085a8 <etext+0x5a8>
    80004c36:	fa040513          	addi	a0,s0,-96
    80004c3a:	ffffe097          	auipc	ra,0xffffe
    80004c3e:	618080e7          	jalr	1560(ra) # 80003252 <namecmp>
    80004c42:	16050263          	beqz	a0,80004da6 <sys_unlink+0x1bc>
    80004c46:	00004597          	auipc	a1,0x4
    80004c4a:	96a58593          	addi	a1,a1,-1686 # 800085b0 <etext+0x5b0>
    80004c4e:	fa040513          	addi	a0,s0,-96
    80004c52:	ffffe097          	auipc	ra,0xffffe
    80004c56:	600080e7          	jalr	1536(ra) # 80003252 <namecmp>
    80004c5a:	14050663          	beqz	a0,80004da6 <sys_unlink+0x1bc>
    80004c5e:	f1ca                	sd	s2,224(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004c60:	f1c40613          	addi	a2,s0,-228
    80004c64:	fa040593          	addi	a1,s0,-96
    80004c68:	8526                	mv	a0,s1
    80004c6a:	ffffe097          	auipc	ra,0xffffe
    80004c6e:	602080e7          	jalr	1538(ra) # 8000326c <dirlookup>
    80004c72:	892a                	mv	s2,a0
    80004c74:	12050863          	beqz	a0,80004da4 <sys_unlink+0x1ba>
    80004c78:	edce                	sd	s3,216(sp)
  ilock(ip);
    80004c7a:	ffffe097          	auipc	ra,0xffffe
    80004c7e:	102080e7          	jalr	258(ra) # 80002d7c <ilock>
  if(ip->nlink < 1)
    80004c82:	04a91783          	lh	a5,74(s2)
    80004c86:	08f05663          	blez	a5,80004d12 <sys_unlink+0x128>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004c8a:	04491703          	lh	a4,68(s2)
    80004c8e:	4785                	li	a5,1
    80004c90:	08f70b63          	beq	a4,a5,80004d26 <sys_unlink+0x13c>
  memset(&de, 0, sizeof(de));
    80004c94:	fb040993          	addi	s3,s0,-80
    80004c98:	4641                	li	a2,16
    80004c9a:	4581                	li	a1,0
    80004c9c:	854e                	mv	a0,s3
    80004c9e:	ffffb097          	auipc	ra,0xffffb
    80004ca2:	5a2080e7          	jalr	1442(ra) # 80000240 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004ca6:	4741                	li	a4,16
    80004ca8:	f1c42683          	lw	a3,-228(s0)
    80004cac:	864e                	mv	a2,s3
    80004cae:	4581                	li	a1,0
    80004cb0:	8526                	mv	a0,s1
    80004cb2:	ffffe097          	auipc	ra,0xffffe
    80004cb6:	480080e7          	jalr	1152(ra) # 80003132 <writei>
    80004cba:	47c1                	li	a5,16
    80004cbc:	0af51f63          	bne	a0,a5,80004d7a <sys_unlink+0x190>
  if(ip->type == T_DIR){
    80004cc0:	04491703          	lh	a4,68(s2)
    80004cc4:	4785                	li	a5,1
    80004cc6:	0cf70463          	beq	a4,a5,80004d8e <sys_unlink+0x1a4>
  iunlockput(dp);
    80004cca:	8526                	mv	a0,s1
    80004ccc:	ffffe097          	auipc	ra,0xffffe
    80004cd0:	316080e7          	jalr	790(ra) # 80002fe2 <iunlockput>
  ip->nlink--;
    80004cd4:	04a95783          	lhu	a5,74(s2)
    80004cd8:	37fd                	addiw	a5,a5,-1
    80004cda:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004cde:	854a                	mv	a0,s2
    80004ce0:	ffffe097          	auipc	ra,0xffffe
    80004ce4:	fd0080e7          	jalr	-48(ra) # 80002cb0 <iupdate>
  iunlockput(ip);
    80004ce8:	854a                	mv	a0,s2
    80004cea:	ffffe097          	auipc	ra,0xffffe
    80004cee:	2f8080e7          	jalr	760(ra) # 80002fe2 <iunlockput>
  end_op();
    80004cf2:	fffff097          	auipc	ra,0xfffff
    80004cf6:	af6080e7          	jalr	-1290(ra) # 800037e8 <end_op>
  return 0;
    80004cfa:	4501                	li	a0,0
    80004cfc:	74ae                	ld	s1,232(sp)
    80004cfe:	790e                	ld	s2,224(sp)
    80004d00:	69ee                	ld	s3,216(sp)
    80004d02:	a86d                	j	80004dbc <sys_unlink+0x1d2>
    end_op();
    80004d04:	fffff097          	auipc	ra,0xfffff
    80004d08:	ae4080e7          	jalr	-1308(ra) # 800037e8 <end_op>
    return -1;
    80004d0c:	557d                	li	a0,-1
    80004d0e:	74ae                	ld	s1,232(sp)
    80004d10:	a075                	j	80004dbc <sys_unlink+0x1d2>
    80004d12:	e9d2                	sd	s4,208(sp)
    80004d14:	e5d6                	sd	s5,200(sp)
    panic("unlink: nlink < 1");
    80004d16:	00004517          	auipc	a0,0x4
    80004d1a:	8c250513          	addi	a0,a0,-1854 # 800085d8 <etext+0x5d8>
    80004d1e:	00001097          	auipc	ra,0x1
    80004d22:	214080e7          	jalr	532(ra) # 80005f32 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004d26:	04c92703          	lw	a4,76(s2)
    80004d2a:	02000793          	li	a5,32
    80004d2e:	f6e7f3e3          	bgeu	a5,a4,80004c94 <sys_unlink+0xaa>
    80004d32:	e9d2                	sd	s4,208(sp)
    80004d34:	e5d6                	sd	s5,200(sp)
    80004d36:	89be                	mv	s3,a5
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004d38:	f0840a93          	addi	s5,s0,-248
    80004d3c:	4a41                	li	s4,16
    80004d3e:	8752                	mv	a4,s4
    80004d40:	86ce                	mv	a3,s3
    80004d42:	8656                	mv	a2,s5
    80004d44:	4581                	li	a1,0
    80004d46:	854a                	mv	a0,s2
    80004d48:	ffffe097          	auipc	ra,0xffffe
    80004d4c:	2f0080e7          	jalr	752(ra) # 80003038 <readi>
    80004d50:	01451d63          	bne	a0,s4,80004d6a <sys_unlink+0x180>
    if(de.inum != 0)
    80004d54:	f0845783          	lhu	a5,-248(s0)
    80004d58:	eba5                	bnez	a5,80004dc8 <sys_unlink+0x1de>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004d5a:	29c1                	addiw	s3,s3,16
    80004d5c:	04c92783          	lw	a5,76(s2)
    80004d60:	fcf9efe3          	bltu	s3,a5,80004d3e <sys_unlink+0x154>
    80004d64:	6a4e                	ld	s4,208(sp)
    80004d66:	6aae                	ld	s5,200(sp)
    80004d68:	b735                	j	80004c94 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004d6a:	00004517          	auipc	a0,0x4
    80004d6e:	88650513          	addi	a0,a0,-1914 # 800085f0 <etext+0x5f0>
    80004d72:	00001097          	auipc	ra,0x1
    80004d76:	1c0080e7          	jalr	448(ra) # 80005f32 <panic>
    80004d7a:	e9d2                	sd	s4,208(sp)
    80004d7c:	e5d6                	sd	s5,200(sp)
    panic("unlink: writei");
    80004d7e:	00004517          	auipc	a0,0x4
    80004d82:	88a50513          	addi	a0,a0,-1910 # 80008608 <etext+0x608>
    80004d86:	00001097          	auipc	ra,0x1
    80004d8a:	1ac080e7          	jalr	428(ra) # 80005f32 <panic>
    dp->nlink--;
    80004d8e:	04a4d783          	lhu	a5,74(s1)
    80004d92:	37fd                	addiw	a5,a5,-1
    80004d94:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004d98:	8526                	mv	a0,s1
    80004d9a:	ffffe097          	auipc	ra,0xffffe
    80004d9e:	f16080e7          	jalr	-234(ra) # 80002cb0 <iupdate>
    80004da2:	b725                	j	80004cca <sys_unlink+0xe0>
    80004da4:	790e                	ld	s2,224(sp)
  iunlockput(dp);
    80004da6:	8526                	mv	a0,s1
    80004da8:	ffffe097          	auipc	ra,0xffffe
    80004dac:	23a080e7          	jalr	570(ra) # 80002fe2 <iunlockput>
  end_op();
    80004db0:	fffff097          	auipc	ra,0xfffff
    80004db4:	a38080e7          	jalr	-1480(ra) # 800037e8 <end_op>
  return -1;
    80004db8:	557d                	li	a0,-1
    80004dba:	74ae                	ld	s1,232(sp)
}
    80004dbc:	70ee                	ld	ra,248(sp)
    80004dbe:	744e                	ld	s0,240(sp)
    80004dc0:	6111                	addi	sp,sp,256
    80004dc2:	8082                	ret
    return -1;
    80004dc4:	557d                	li	a0,-1
    80004dc6:	bfdd                	j	80004dbc <sys_unlink+0x1d2>
    iunlockput(ip);
    80004dc8:	854a                	mv	a0,s2
    80004dca:	ffffe097          	auipc	ra,0xffffe
    80004dce:	218080e7          	jalr	536(ra) # 80002fe2 <iunlockput>
    goto bad;
    80004dd2:	790e                	ld	s2,224(sp)
    80004dd4:	69ee                	ld	s3,216(sp)
    80004dd6:	6a4e                	ld	s4,208(sp)
    80004dd8:	6aae                	ld	s5,200(sp)
    80004dda:	b7f1                	j	80004da6 <sys_unlink+0x1bc>

0000000080004ddc <sys_open>:

uint64
sys_open(void)
{
    80004ddc:	7131                	addi	sp,sp,-192
    80004dde:	fd06                	sd	ra,184(sp)
    80004de0:	f922                	sd	s0,176(sp)
    80004de2:	f526                	sd	s1,168(sp)
    80004de4:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004de6:	08000613          	li	a2,128
    80004dea:	f5040593          	addi	a1,s0,-176
    80004dee:	4501                	li	a0,0
    80004df0:	ffffd097          	auipc	ra,0xffffd
    80004df4:	47c080e7          	jalr	1148(ra) # 8000226c <argstr>
    return -1;
    80004df8:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004dfa:	0c054563          	bltz	a0,80004ec4 <sys_open+0xe8>
    80004dfe:	f4c40593          	addi	a1,s0,-180
    80004e02:	4505                	li	a0,1
    80004e04:	ffffd097          	auipc	ra,0xffffd
    80004e08:	424080e7          	jalr	1060(ra) # 80002228 <argint>
    80004e0c:	0a054c63          	bltz	a0,80004ec4 <sys_open+0xe8>
    80004e10:	f14a                	sd	s2,160(sp)

  begin_op();
    80004e12:	fffff097          	auipc	ra,0xfffff
    80004e16:	95c080e7          	jalr	-1700(ra) # 8000376e <begin_op>

  if(omode & O_CREATE){
    80004e1a:	f4c42783          	lw	a5,-180(s0)
    80004e1e:	2007f793          	andi	a5,a5,512
    80004e22:	cfcd                	beqz	a5,80004edc <sys_open+0x100>
    ip = create(path, T_FILE, 0, 0);
    80004e24:	4681                	li	a3,0
    80004e26:	4601                	li	a2,0
    80004e28:	4589                	li	a1,2
    80004e2a:	f5040513          	addi	a0,s0,-176
    80004e2e:	00000097          	auipc	ra,0x0
    80004e32:	948080e7          	jalr	-1720(ra) # 80004776 <create>
    80004e36:	892a                	mv	s2,a0
    if(ip == 0){
    80004e38:	cd41                	beqz	a0,80004ed0 <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004e3a:	04491703          	lh	a4,68(s2)
    80004e3e:	478d                	li	a5,3
    80004e40:	00f71763          	bne	a4,a5,80004e4e <sys_open+0x72>
    80004e44:	04695703          	lhu	a4,70(s2)
    80004e48:	47a5                	li	a5,9
    80004e4a:	0ee7e063          	bltu	a5,a4,80004f2a <sys_open+0x14e>
    80004e4e:	ed4e                	sd	s3,152(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004e50:	fffff097          	auipc	ra,0xfffff
    80004e54:	d32080e7          	jalr	-718(ra) # 80003b82 <filealloc>
    80004e58:	89aa                	mv	s3,a0
    80004e5a:	c96d                	beqz	a0,80004f4c <sys_open+0x170>
    80004e5c:	00000097          	auipc	ra,0x0
    80004e60:	8d8080e7          	jalr	-1832(ra) # 80004734 <fdalloc>
    80004e64:	84aa                	mv	s1,a0
    80004e66:	0c054e63          	bltz	a0,80004f42 <sys_open+0x166>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004e6a:	04491703          	lh	a4,68(s2)
    80004e6e:	478d                	li	a5,3
    80004e70:	0ef70b63          	beq	a4,a5,80004f66 <sys_open+0x18a>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004e74:	4789                	li	a5,2
    80004e76:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004e7a:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004e7e:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004e82:	f4c42783          	lw	a5,-180(s0)
    80004e86:	0017f713          	andi	a4,a5,1
    80004e8a:	00174713          	xori	a4,a4,1
    80004e8e:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004e92:	0037f713          	andi	a4,a5,3
    80004e96:	00e03733          	snez	a4,a4
    80004e9a:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004e9e:	4007f793          	andi	a5,a5,1024
    80004ea2:	c791                	beqz	a5,80004eae <sys_open+0xd2>
    80004ea4:	04491703          	lh	a4,68(s2)
    80004ea8:	4789                	li	a5,2
    80004eaa:	0cf70563          	beq	a4,a5,80004f74 <sys_open+0x198>
    itrunc(ip);
  }

  iunlock(ip);
    80004eae:	854a                	mv	a0,s2
    80004eb0:	ffffe097          	auipc	ra,0xffffe
    80004eb4:	f92080e7          	jalr	-110(ra) # 80002e42 <iunlock>
  end_op();
    80004eb8:	fffff097          	auipc	ra,0xfffff
    80004ebc:	930080e7          	jalr	-1744(ra) # 800037e8 <end_op>
    80004ec0:	790a                	ld	s2,160(sp)
    80004ec2:	69ea                	ld	s3,152(sp)

  return fd;
}
    80004ec4:	8526                	mv	a0,s1
    80004ec6:	70ea                	ld	ra,184(sp)
    80004ec8:	744a                	ld	s0,176(sp)
    80004eca:	74aa                	ld	s1,168(sp)
    80004ecc:	6129                	addi	sp,sp,192
    80004ece:	8082                	ret
      end_op();
    80004ed0:	fffff097          	auipc	ra,0xfffff
    80004ed4:	918080e7          	jalr	-1768(ra) # 800037e8 <end_op>
      return -1;
    80004ed8:	790a                	ld	s2,160(sp)
    80004eda:	b7ed                	j	80004ec4 <sys_open+0xe8>
    if((ip = namei(path)) == 0){
    80004edc:	f5040513          	addi	a0,s0,-176
    80004ee0:	ffffe097          	auipc	ra,0xffffe
    80004ee4:	688080e7          	jalr	1672(ra) # 80003568 <namei>
    80004ee8:	892a                	mv	s2,a0
    80004eea:	c90d                	beqz	a0,80004f1c <sys_open+0x140>
    ilock(ip);
    80004eec:	ffffe097          	auipc	ra,0xffffe
    80004ef0:	e90080e7          	jalr	-368(ra) # 80002d7c <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004ef4:	04491703          	lh	a4,68(s2)
    80004ef8:	4785                	li	a5,1
    80004efa:	f4f710e3          	bne	a4,a5,80004e3a <sys_open+0x5e>
    80004efe:	f4c42783          	lw	a5,-180(s0)
    80004f02:	d7b1                	beqz	a5,80004e4e <sys_open+0x72>
      iunlockput(ip);
    80004f04:	854a                	mv	a0,s2
    80004f06:	ffffe097          	auipc	ra,0xffffe
    80004f0a:	0dc080e7          	jalr	220(ra) # 80002fe2 <iunlockput>
      end_op();
    80004f0e:	fffff097          	auipc	ra,0xfffff
    80004f12:	8da080e7          	jalr	-1830(ra) # 800037e8 <end_op>
      return -1;
    80004f16:	54fd                	li	s1,-1
    80004f18:	790a                	ld	s2,160(sp)
    80004f1a:	b76d                	j	80004ec4 <sys_open+0xe8>
      end_op();
    80004f1c:	fffff097          	auipc	ra,0xfffff
    80004f20:	8cc080e7          	jalr	-1844(ra) # 800037e8 <end_op>
      return -1;
    80004f24:	54fd                	li	s1,-1
    80004f26:	790a                	ld	s2,160(sp)
    80004f28:	bf71                	j	80004ec4 <sys_open+0xe8>
    iunlockput(ip);
    80004f2a:	854a                	mv	a0,s2
    80004f2c:	ffffe097          	auipc	ra,0xffffe
    80004f30:	0b6080e7          	jalr	182(ra) # 80002fe2 <iunlockput>
    end_op();
    80004f34:	fffff097          	auipc	ra,0xfffff
    80004f38:	8b4080e7          	jalr	-1868(ra) # 800037e8 <end_op>
    return -1;
    80004f3c:	54fd                	li	s1,-1
    80004f3e:	790a                	ld	s2,160(sp)
    80004f40:	b751                	j	80004ec4 <sys_open+0xe8>
      fileclose(f);
    80004f42:	854e                	mv	a0,s3
    80004f44:	fffff097          	auipc	ra,0xfffff
    80004f48:	cfa080e7          	jalr	-774(ra) # 80003c3e <fileclose>
    iunlockput(ip);
    80004f4c:	854a                	mv	a0,s2
    80004f4e:	ffffe097          	auipc	ra,0xffffe
    80004f52:	094080e7          	jalr	148(ra) # 80002fe2 <iunlockput>
    end_op();
    80004f56:	fffff097          	auipc	ra,0xfffff
    80004f5a:	892080e7          	jalr	-1902(ra) # 800037e8 <end_op>
    return -1;
    80004f5e:	54fd                	li	s1,-1
    80004f60:	790a                	ld	s2,160(sp)
    80004f62:	69ea                	ld	s3,152(sp)
    80004f64:	b785                	j	80004ec4 <sys_open+0xe8>
    f->type = FD_DEVICE;
    80004f66:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004f6a:	04691783          	lh	a5,70(s2)
    80004f6e:	02f99223          	sh	a5,36(s3)
    80004f72:	b731                	j	80004e7e <sys_open+0xa2>
    itrunc(ip);
    80004f74:	854a                	mv	a0,s2
    80004f76:	ffffe097          	auipc	ra,0xffffe
    80004f7a:	f18080e7          	jalr	-232(ra) # 80002e8e <itrunc>
    80004f7e:	bf05                	j	80004eae <sys_open+0xd2>

0000000080004f80 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004f80:	7175                	addi	sp,sp,-144
    80004f82:	e506                	sd	ra,136(sp)
    80004f84:	e122                	sd	s0,128(sp)
    80004f86:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004f88:	ffffe097          	auipc	ra,0xffffe
    80004f8c:	7e6080e7          	jalr	2022(ra) # 8000376e <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004f90:	08000613          	li	a2,128
    80004f94:	f7040593          	addi	a1,s0,-144
    80004f98:	4501                	li	a0,0
    80004f9a:	ffffd097          	auipc	ra,0xffffd
    80004f9e:	2d2080e7          	jalr	722(ra) # 8000226c <argstr>
    80004fa2:	02054963          	bltz	a0,80004fd4 <sys_mkdir+0x54>
    80004fa6:	4681                	li	a3,0
    80004fa8:	4601                	li	a2,0
    80004faa:	4585                	li	a1,1
    80004fac:	f7040513          	addi	a0,s0,-144
    80004fb0:	fffff097          	auipc	ra,0xfffff
    80004fb4:	7c6080e7          	jalr	1990(ra) # 80004776 <create>
    80004fb8:	cd11                	beqz	a0,80004fd4 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004fba:	ffffe097          	auipc	ra,0xffffe
    80004fbe:	028080e7          	jalr	40(ra) # 80002fe2 <iunlockput>
  end_op();
    80004fc2:	fffff097          	auipc	ra,0xfffff
    80004fc6:	826080e7          	jalr	-2010(ra) # 800037e8 <end_op>
  return 0;
    80004fca:	4501                	li	a0,0
}
    80004fcc:	60aa                	ld	ra,136(sp)
    80004fce:	640a                	ld	s0,128(sp)
    80004fd0:	6149                	addi	sp,sp,144
    80004fd2:	8082                	ret
    end_op();
    80004fd4:	fffff097          	auipc	ra,0xfffff
    80004fd8:	814080e7          	jalr	-2028(ra) # 800037e8 <end_op>
    return -1;
    80004fdc:	557d                	li	a0,-1
    80004fde:	b7fd                	j	80004fcc <sys_mkdir+0x4c>

0000000080004fe0 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004fe0:	7135                	addi	sp,sp,-160
    80004fe2:	ed06                	sd	ra,152(sp)
    80004fe4:	e922                	sd	s0,144(sp)
    80004fe6:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004fe8:	ffffe097          	auipc	ra,0xffffe
    80004fec:	786080e7          	jalr	1926(ra) # 8000376e <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004ff0:	08000613          	li	a2,128
    80004ff4:	f7040593          	addi	a1,s0,-144
    80004ff8:	4501                	li	a0,0
    80004ffa:	ffffd097          	auipc	ra,0xffffd
    80004ffe:	272080e7          	jalr	626(ra) # 8000226c <argstr>
    80005002:	04054a63          	bltz	a0,80005056 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80005006:	f6c40593          	addi	a1,s0,-148
    8000500a:	4505                	li	a0,1
    8000500c:	ffffd097          	auipc	ra,0xffffd
    80005010:	21c080e7          	jalr	540(ra) # 80002228 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005014:	04054163          	bltz	a0,80005056 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80005018:	f6840593          	addi	a1,s0,-152
    8000501c:	4509                	li	a0,2
    8000501e:	ffffd097          	auipc	ra,0xffffd
    80005022:	20a080e7          	jalr	522(ra) # 80002228 <argint>
     argint(1, &major) < 0 ||
    80005026:	02054863          	bltz	a0,80005056 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    8000502a:	f6841683          	lh	a3,-152(s0)
    8000502e:	f6c41603          	lh	a2,-148(s0)
    80005032:	458d                	li	a1,3
    80005034:	f7040513          	addi	a0,s0,-144
    80005038:	fffff097          	auipc	ra,0xfffff
    8000503c:	73e080e7          	jalr	1854(ra) # 80004776 <create>
     argint(2, &minor) < 0 ||
    80005040:	c919                	beqz	a0,80005056 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005042:	ffffe097          	auipc	ra,0xffffe
    80005046:	fa0080e7          	jalr	-96(ra) # 80002fe2 <iunlockput>
  end_op();
    8000504a:	ffffe097          	auipc	ra,0xffffe
    8000504e:	79e080e7          	jalr	1950(ra) # 800037e8 <end_op>
  return 0;
    80005052:	4501                	li	a0,0
    80005054:	a031                	j	80005060 <sys_mknod+0x80>
    end_op();
    80005056:	ffffe097          	auipc	ra,0xffffe
    8000505a:	792080e7          	jalr	1938(ra) # 800037e8 <end_op>
    return -1;
    8000505e:	557d                	li	a0,-1
}
    80005060:	60ea                	ld	ra,152(sp)
    80005062:	644a                	ld	s0,144(sp)
    80005064:	610d                	addi	sp,sp,160
    80005066:	8082                	ret

0000000080005068 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005068:	7135                	addi	sp,sp,-160
    8000506a:	ed06                	sd	ra,152(sp)
    8000506c:	e922                	sd	s0,144(sp)
    8000506e:	e14a                	sd	s2,128(sp)
    80005070:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005072:	ffffc097          	auipc	ra,0xffffc
    80005076:	ff8080e7          	jalr	-8(ra) # 8000106a <myproc>
    8000507a:	892a                	mv	s2,a0
  
  begin_op();
    8000507c:	ffffe097          	auipc	ra,0xffffe
    80005080:	6f2080e7          	jalr	1778(ra) # 8000376e <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005084:	08000613          	li	a2,128
    80005088:	f6040593          	addi	a1,s0,-160
    8000508c:	4501                	li	a0,0
    8000508e:	ffffd097          	auipc	ra,0xffffd
    80005092:	1de080e7          	jalr	478(ra) # 8000226c <argstr>
    80005096:	04054d63          	bltz	a0,800050f0 <sys_chdir+0x88>
    8000509a:	e526                	sd	s1,136(sp)
    8000509c:	f6040513          	addi	a0,s0,-160
    800050a0:	ffffe097          	auipc	ra,0xffffe
    800050a4:	4c8080e7          	jalr	1224(ra) # 80003568 <namei>
    800050a8:	84aa                	mv	s1,a0
    800050aa:	c131                	beqz	a0,800050ee <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    800050ac:	ffffe097          	auipc	ra,0xffffe
    800050b0:	cd0080e7          	jalr	-816(ra) # 80002d7c <ilock>
  if(ip->type != T_DIR){
    800050b4:	04449703          	lh	a4,68(s1)
    800050b8:	4785                	li	a5,1
    800050ba:	04f71163          	bne	a4,a5,800050fc <sys_chdir+0x94>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    800050be:	8526                	mv	a0,s1
    800050c0:	ffffe097          	auipc	ra,0xffffe
    800050c4:	d82080e7          	jalr	-638(ra) # 80002e42 <iunlock>
  iput(p->cwd);
    800050c8:	15093503          	ld	a0,336(s2)
    800050cc:	ffffe097          	auipc	ra,0xffffe
    800050d0:	e6e080e7          	jalr	-402(ra) # 80002f3a <iput>
  end_op();
    800050d4:	ffffe097          	auipc	ra,0xffffe
    800050d8:	714080e7          	jalr	1812(ra) # 800037e8 <end_op>
  p->cwd = ip;
    800050dc:	14993823          	sd	s1,336(s2)
  return 0;
    800050e0:	4501                	li	a0,0
    800050e2:	64aa                	ld	s1,136(sp)
}
    800050e4:	60ea                	ld	ra,152(sp)
    800050e6:	644a                	ld	s0,144(sp)
    800050e8:	690a                	ld	s2,128(sp)
    800050ea:	610d                	addi	sp,sp,160
    800050ec:	8082                	ret
    800050ee:	64aa                	ld	s1,136(sp)
    end_op();
    800050f0:	ffffe097          	auipc	ra,0xffffe
    800050f4:	6f8080e7          	jalr	1784(ra) # 800037e8 <end_op>
    return -1;
    800050f8:	557d                	li	a0,-1
    800050fa:	b7ed                	j	800050e4 <sys_chdir+0x7c>
    iunlockput(ip);
    800050fc:	8526                	mv	a0,s1
    800050fe:	ffffe097          	auipc	ra,0xffffe
    80005102:	ee4080e7          	jalr	-284(ra) # 80002fe2 <iunlockput>
    end_op();
    80005106:	ffffe097          	auipc	ra,0xffffe
    8000510a:	6e2080e7          	jalr	1762(ra) # 800037e8 <end_op>
    return -1;
    8000510e:	557d                	li	a0,-1
    80005110:	64aa                	ld	s1,136(sp)
    80005112:	bfc9                	j	800050e4 <sys_chdir+0x7c>

0000000080005114 <sys_exec>:

uint64
sys_exec(void)
{
    80005114:	7105                	addi	sp,sp,-480
    80005116:	ef86                	sd	ra,472(sp)
    80005118:	eba2                	sd	s0,464(sp)
    8000511a:	e3ca                	sd	s2,448(sp)
    8000511c:	1380                	addi	s0,sp,480
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    8000511e:	08000613          	li	a2,128
    80005122:	f3040593          	addi	a1,s0,-208
    80005126:	4501                	li	a0,0
    80005128:	ffffd097          	auipc	ra,0xffffd
    8000512c:	144080e7          	jalr	324(ra) # 8000226c <argstr>
    return -1;
    80005130:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005132:	10054963          	bltz	a0,80005244 <sys_exec+0x130>
    80005136:	e2840593          	addi	a1,s0,-472
    8000513a:	4505                	li	a0,1
    8000513c:	ffffd097          	auipc	ra,0xffffd
    80005140:	10e080e7          	jalr	270(ra) # 8000224a <argaddr>
    80005144:	10054063          	bltz	a0,80005244 <sys_exec+0x130>
    80005148:	e7a6                	sd	s1,456(sp)
    8000514a:	ff4e                	sd	s3,440(sp)
    8000514c:	fb52                	sd	s4,432(sp)
    8000514e:	f756                	sd	s5,424(sp)
    80005150:	f35a                	sd	s6,416(sp)
    80005152:	ef5e                	sd	s7,408(sp)
  }
  memset(argv, 0, sizeof(argv));
    80005154:	e3040a13          	addi	s4,s0,-464
    80005158:	10000613          	li	a2,256
    8000515c:	4581                	li	a1,0
    8000515e:	8552                	mv	a0,s4
    80005160:	ffffb097          	auipc	ra,0xffffb
    80005164:	0e0080e7          	jalr	224(ra) # 80000240 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005168:	84d2                	mv	s1,s4
  memset(argv, 0, sizeof(argv));
    8000516a:	89d2                	mv	s3,s4
    8000516c:	4901                	li	s2,0
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    8000516e:	e2040a93          	addi	s5,s0,-480
      break;
    }
    argv[i] = kalloc();
    if(argv[i] == 0)
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005172:	6b05                	lui	s6,0x1
    if(i >= NELEM(argv)){
    80005174:	02000b93          	li	s7,32
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005178:	00391513          	slli	a0,s2,0x3
    8000517c:	85d6                	mv	a1,s5
    8000517e:	e2843783          	ld	a5,-472(s0)
    80005182:	953e                	add	a0,a0,a5
    80005184:	ffffd097          	auipc	ra,0xffffd
    80005188:	00a080e7          	jalr	10(ra) # 8000218e <fetchaddr>
    8000518c:	02054a63          	bltz	a0,800051c0 <sys_exec+0xac>
    if(uarg == 0){
    80005190:	e2043783          	ld	a5,-480(s0)
    80005194:	cba9                	beqz	a5,800051e6 <sys_exec+0xd2>
    argv[i] = kalloc();
    80005196:	ffffb097          	auipc	ra,0xffffb
    8000519a:	004080e7          	jalr	4(ra) # 8000019a <kalloc>
    8000519e:	85aa                	mv	a1,a0
    800051a0:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800051a4:	cd11                	beqz	a0,800051c0 <sys_exec+0xac>
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800051a6:	865a                	mv	a2,s6
    800051a8:	e2043503          	ld	a0,-480(s0)
    800051ac:	ffffd097          	auipc	ra,0xffffd
    800051b0:	034080e7          	jalr	52(ra) # 800021e0 <fetchstr>
    800051b4:	00054663          	bltz	a0,800051c0 <sys_exec+0xac>
    if(i >= NELEM(argv)){
    800051b8:	0905                	addi	s2,s2,1
    800051ba:	09a1                	addi	s3,s3,8
    800051bc:	fb791ee3          	bne	s2,s7,80005178 <sys_exec+0x64>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800051c0:	100a0a13          	addi	s4,s4,256
    800051c4:	6088                	ld	a0,0(s1)
    800051c6:	c925                	beqz	a0,80005236 <sys_exec+0x122>
    kfree(argv[i]);
    800051c8:	ffffb097          	auipc	ra,0xffffb
    800051cc:	e54080e7          	jalr	-428(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800051d0:	04a1                	addi	s1,s1,8
    800051d2:	ff4499e3          	bne	s1,s4,800051c4 <sys_exec+0xb0>
  return -1;
    800051d6:	597d                	li	s2,-1
    800051d8:	64be                	ld	s1,456(sp)
    800051da:	79fa                	ld	s3,440(sp)
    800051dc:	7a5a                	ld	s4,432(sp)
    800051de:	7aba                	ld	s5,424(sp)
    800051e0:	7b1a                	ld	s6,416(sp)
    800051e2:	6bfa                	ld	s7,408(sp)
    800051e4:	a085                	j	80005244 <sys_exec+0x130>
      argv[i] = 0;
    800051e6:	0009079b          	sext.w	a5,s2
    800051ea:	e3040593          	addi	a1,s0,-464
    800051ee:	078e                	slli	a5,a5,0x3
    800051f0:	97ae                	add	a5,a5,a1
    800051f2:	0007b023          	sd	zero,0(a5)
  int ret = exec(path, argv);
    800051f6:	f3040513          	addi	a0,s0,-208
    800051fa:	fffff097          	auipc	ra,0xfffff
    800051fe:	122080e7          	jalr	290(ra) # 8000431c <exec>
    80005202:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005204:	100a0a13          	addi	s4,s4,256
    80005208:	6088                	ld	a0,0(s1)
    8000520a:	cd19                	beqz	a0,80005228 <sys_exec+0x114>
    kfree(argv[i]);
    8000520c:	ffffb097          	auipc	ra,0xffffb
    80005210:	e10080e7          	jalr	-496(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005214:	04a1                	addi	s1,s1,8
    80005216:	ff4499e3          	bne	s1,s4,80005208 <sys_exec+0xf4>
    8000521a:	64be                	ld	s1,456(sp)
    8000521c:	79fa                	ld	s3,440(sp)
    8000521e:	7a5a                	ld	s4,432(sp)
    80005220:	7aba                	ld	s5,424(sp)
    80005222:	7b1a                	ld	s6,416(sp)
    80005224:	6bfa                	ld	s7,408(sp)
    80005226:	a839                	j	80005244 <sys_exec+0x130>
  return ret;
    80005228:	64be                	ld	s1,456(sp)
    8000522a:	79fa                	ld	s3,440(sp)
    8000522c:	7a5a                	ld	s4,432(sp)
    8000522e:	7aba                	ld	s5,424(sp)
    80005230:	7b1a                	ld	s6,416(sp)
    80005232:	6bfa                	ld	s7,408(sp)
    80005234:	a801                	j	80005244 <sys_exec+0x130>
  return -1;
    80005236:	597d                	li	s2,-1
    80005238:	64be                	ld	s1,456(sp)
    8000523a:	79fa                	ld	s3,440(sp)
    8000523c:	7a5a                	ld	s4,432(sp)
    8000523e:	7aba                	ld	s5,424(sp)
    80005240:	7b1a                	ld	s6,416(sp)
    80005242:	6bfa                	ld	s7,408(sp)
}
    80005244:	854a                	mv	a0,s2
    80005246:	60fe                	ld	ra,472(sp)
    80005248:	645e                	ld	s0,464(sp)
    8000524a:	691e                	ld	s2,448(sp)
    8000524c:	613d                	addi	sp,sp,480
    8000524e:	8082                	ret

0000000080005250 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005250:	7139                	addi	sp,sp,-64
    80005252:	fc06                	sd	ra,56(sp)
    80005254:	f822                	sd	s0,48(sp)
    80005256:	f426                	sd	s1,40(sp)
    80005258:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    8000525a:	ffffc097          	auipc	ra,0xffffc
    8000525e:	e10080e7          	jalr	-496(ra) # 8000106a <myproc>
    80005262:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80005264:	fd840593          	addi	a1,s0,-40
    80005268:	4501                	li	a0,0
    8000526a:	ffffd097          	auipc	ra,0xffffd
    8000526e:	fe0080e7          	jalr	-32(ra) # 8000224a <argaddr>
    return -1;
    80005272:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80005274:	0e054063          	bltz	a0,80005354 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80005278:	fc840593          	addi	a1,s0,-56
    8000527c:	fd040513          	addi	a0,s0,-48
    80005280:	fffff097          	auipc	ra,0xfffff
    80005284:	d32080e7          	jalr	-718(ra) # 80003fb2 <pipealloc>
    return -1;
    80005288:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    8000528a:	0c054563          	bltz	a0,80005354 <sys_pipe+0x104>
  fd0 = -1;
    8000528e:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005292:	fd043503          	ld	a0,-48(s0)
    80005296:	fffff097          	auipc	ra,0xfffff
    8000529a:	49e080e7          	jalr	1182(ra) # 80004734 <fdalloc>
    8000529e:	fca42223          	sw	a0,-60(s0)
    800052a2:	08054c63          	bltz	a0,8000533a <sys_pipe+0xea>
    800052a6:	fc843503          	ld	a0,-56(s0)
    800052aa:	fffff097          	auipc	ra,0xfffff
    800052ae:	48a080e7          	jalr	1162(ra) # 80004734 <fdalloc>
    800052b2:	fca42023          	sw	a0,-64(s0)
    800052b6:	06054963          	bltz	a0,80005328 <sys_pipe+0xd8>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800052ba:	4691                	li	a3,4
    800052bc:	fc440613          	addi	a2,s0,-60
    800052c0:	fd843583          	ld	a1,-40(s0)
    800052c4:	68a8                	ld	a0,80(s1)
    800052c6:	ffffc097          	auipc	ra,0xffffc
    800052ca:	976080e7          	jalr	-1674(ra) # 80000c3c <copyout>
    800052ce:	02054063          	bltz	a0,800052ee <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800052d2:	4691                	li	a3,4
    800052d4:	fc040613          	addi	a2,s0,-64
    800052d8:	fd843583          	ld	a1,-40(s0)
    800052dc:	95b6                	add	a1,a1,a3
    800052de:	68a8                	ld	a0,80(s1)
    800052e0:	ffffc097          	auipc	ra,0xffffc
    800052e4:	95c080e7          	jalr	-1700(ra) # 80000c3c <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800052e8:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800052ea:	06055563          	bgez	a0,80005354 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    800052ee:	fc442783          	lw	a5,-60(s0)
    800052f2:	07e9                	addi	a5,a5,26
    800052f4:	078e                	slli	a5,a5,0x3
    800052f6:	97a6                	add	a5,a5,s1
    800052f8:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800052fc:	fc042783          	lw	a5,-64(s0)
    80005300:	07e9                	addi	a5,a5,26
    80005302:	078e                	slli	a5,a5,0x3
    80005304:	00f48533          	add	a0,s1,a5
    80005308:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    8000530c:	fd043503          	ld	a0,-48(s0)
    80005310:	fffff097          	auipc	ra,0xfffff
    80005314:	92e080e7          	jalr	-1746(ra) # 80003c3e <fileclose>
    fileclose(wf);
    80005318:	fc843503          	ld	a0,-56(s0)
    8000531c:	fffff097          	auipc	ra,0xfffff
    80005320:	922080e7          	jalr	-1758(ra) # 80003c3e <fileclose>
    return -1;
    80005324:	57fd                	li	a5,-1
    80005326:	a03d                	j	80005354 <sys_pipe+0x104>
    if(fd0 >= 0)
    80005328:	fc442783          	lw	a5,-60(s0)
    8000532c:	0007c763          	bltz	a5,8000533a <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005330:	07e9                	addi	a5,a5,26
    80005332:	078e                	slli	a5,a5,0x3
    80005334:	97a6                	add	a5,a5,s1
    80005336:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    8000533a:	fd043503          	ld	a0,-48(s0)
    8000533e:	fffff097          	auipc	ra,0xfffff
    80005342:	900080e7          	jalr	-1792(ra) # 80003c3e <fileclose>
    fileclose(wf);
    80005346:	fc843503          	ld	a0,-56(s0)
    8000534a:	fffff097          	auipc	ra,0xfffff
    8000534e:	8f4080e7          	jalr	-1804(ra) # 80003c3e <fileclose>
    return -1;
    80005352:	57fd                	li	a5,-1
}
    80005354:	853e                	mv	a0,a5
    80005356:	70e2                	ld	ra,56(sp)
    80005358:	7442                	ld	s0,48(sp)
    8000535a:	74a2                	ld	s1,40(sp)
    8000535c:	6121                	addi	sp,sp,64
    8000535e:	8082                	ret

0000000080005360 <kernelvec>:
    80005360:	7111                	addi	sp,sp,-256
    80005362:	e006                	sd	ra,0(sp)
    80005364:	e40a                	sd	sp,8(sp)
    80005366:	e80e                	sd	gp,16(sp)
    80005368:	ec12                	sd	tp,24(sp)
    8000536a:	f016                	sd	t0,32(sp)
    8000536c:	f41a                	sd	t1,40(sp)
    8000536e:	f81e                	sd	t2,48(sp)
    80005370:	fc22                	sd	s0,56(sp)
    80005372:	e0a6                	sd	s1,64(sp)
    80005374:	e4aa                	sd	a0,72(sp)
    80005376:	e8ae                	sd	a1,80(sp)
    80005378:	ecb2                	sd	a2,88(sp)
    8000537a:	f0b6                	sd	a3,96(sp)
    8000537c:	f4ba                	sd	a4,104(sp)
    8000537e:	f8be                	sd	a5,112(sp)
    80005380:	fcc2                	sd	a6,120(sp)
    80005382:	e146                	sd	a7,128(sp)
    80005384:	e54a                	sd	s2,136(sp)
    80005386:	e94e                	sd	s3,144(sp)
    80005388:	ed52                	sd	s4,152(sp)
    8000538a:	f156                	sd	s5,160(sp)
    8000538c:	f55a                	sd	s6,168(sp)
    8000538e:	f95e                	sd	s7,176(sp)
    80005390:	fd62                	sd	s8,184(sp)
    80005392:	e1e6                	sd	s9,192(sp)
    80005394:	e5ea                	sd	s10,200(sp)
    80005396:	e9ee                	sd	s11,208(sp)
    80005398:	edf2                	sd	t3,216(sp)
    8000539a:	f1f6                	sd	t4,224(sp)
    8000539c:	f5fa                	sd	t5,232(sp)
    8000539e:	f9fe                	sd	t6,240(sp)
    800053a0:	cbbfc0ef          	jal	8000205a <kerneltrap>
    800053a4:	6082                	ld	ra,0(sp)
    800053a6:	6122                	ld	sp,8(sp)
    800053a8:	61c2                	ld	gp,16(sp)
    800053aa:	7282                	ld	t0,32(sp)
    800053ac:	7322                	ld	t1,40(sp)
    800053ae:	73c2                	ld	t2,48(sp)
    800053b0:	7462                	ld	s0,56(sp)
    800053b2:	6486                	ld	s1,64(sp)
    800053b4:	6526                	ld	a0,72(sp)
    800053b6:	65c6                	ld	a1,80(sp)
    800053b8:	6666                	ld	a2,88(sp)
    800053ba:	7686                	ld	a3,96(sp)
    800053bc:	7726                	ld	a4,104(sp)
    800053be:	77c6                	ld	a5,112(sp)
    800053c0:	7866                	ld	a6,120(sp)
    800053c2:	688a                	ld	a7,128(sp)
    800053c4:	692a                	ld	s2,136(sp)
    800053c6:	69ca                	ld	s3,144(sp)
    800053c8:	6a6a                	ld	s4,152(sp)
    800053ca:	7a8a                	ld	s5,160(sp)
    800053cc:	7b2a                	ld	s6,168(sp)
    800053ce:	7bca                	ld	s7,176(sp)
    800053d0:	7c6a                	ld	s8,184(sp)
    800053d2:	6c8e                	ld	s9,192(sp)
    800053d4:	6d2e                	ld	s10,200(sp)
    800053d6:	6dce                	ld	s11,208(sp)
    800053d8:	6e6e                	ld	t3,216(sp)
    800053da:	7e8e                	ld	t4,224(sp)
    800053dc:	7f2e                	ld	t5,232(sp)
    800053de:	7fce                	ld	t6,240(sp)
    800053e0:	6111                	addi	sp,sp,256
    800053e2:	10200073          	sret
    800053e6:	00000013          	nop
    800053ea:	00000013          	nop
    800053ee:	0001                	nop

00000000800053f0 <timervec>:
    800053f0:	34051573          	csrrw	a0,mscratch,a0
    800053f4:	e10c                	sd	a1,0(a0)
    800053f6:	e510                	sd	a2,8(a0)
    800053f8:	e914                	sd	a3,16(a0)
    800053fa:	6d0c                	ld	a1,24(a0)
    800053fc:	7110                	ld	a2,32(a0)
    800053fe:	6194                	ld	a3,0(a1)
    80005400:	96b2                	add	a3,a3,a2
    80005402:	e194                	sd	a3,0(a1)
    80005404:	4589                	li	a1,2
    80005406:	14459073          	csrw	sip,a1
    8000540a:	6914                	ld	a3,16(a0)
    8000540c:	6510                	ld	a2,8(a0)
    8000540e:	610c                	ld	a1,0(a0)
    80005410:	34051573          	csrrw	a0,mscratch,a0
    80005414:	30200073          	mret
	...

000000008000541a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000541a:	1141                	addi	sp,sp,-16
    8000541c:	e406                	sd	ra,8(sp)
    8000541e:	e022                	sd	s0,0(sp)
    80005420:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005422:	0c000737          	lui	a4,0xc000
    80005426:	4785                	li	a5,1
    80005428:	d71c                	sw	a5,40(a4)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    8000542a:	c35c                	sw	a5,4(a4)
}
    8000542c:	60a2                	ld	ra,8(sp)
    8000542e:	6402                	ld	s0,0(sp)
    80005430:	0141                	addi	sp,sp,16
    80005432:	8082                	ret

0000000080005434 <plicinithart>:

void
plicinithart(void)
{
    80005434:	1141                	addi	sp,sp,-16
    80005436:	e406                	sd	ra,8(sp)
    80005438:	e022                	sd	s0,0(sp)
    8000543a:	0800                	addi	s0,sp,16
  int hart = cpuid();
    8000543c:	ffffc097          	auipc	ra,0xffffc
    80005440:	bfa080e7          	jalr	-1030(ra) # 80001036 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005444:	0085171b          	slliw	a4,a0,0x8
    80005448:	0c0027b7          	lui	a5,0xc002
    8000544c:	97ba                	add	a5,a5,a4
    8000544e:	40200713          	li	a4,1026
    80005452:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005456:	00d5151b          	slliw	a0,a0,0xd
    8000545a:	0c2017b7          	lui	a5,0xc201
    8000545e:	97aa                	add	a5,a5,a0
    80005460:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005464:	60a2                	ld	ra,8(sp)
    80005466:	6402                	ld	s0,0(sp)
    80005468:	0141                	addi	sp,sp,16
    8000546a:	8082                	ret

000000008000546c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000546c:	1141                	addi	sp,sp,-16
    8000546e:	e406                	sd	ra,8(sp)
    80005470:	e022                	sd	s0,0(sp)
    80005472:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005474:	ffffc097          	auipc	ra,0xffffc
    80005478:	bc2080e7          	jalr	-1086(ra) # 80001036 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    8000547c:	00d5151b          	slliw	a0,a0,0xd
    80005480:	0c2017b7          	lui	a5,0xc201
    80005484:	97aa                	add	a5,a5,a0
  return irq;
}
    80005486:	43c8                	lw	a0,4(a5)
    80005488:	60a2                	ld	ra,8(sp)
    8000548a:	6402                	ld	s0,0(sp)
    8000548c:	0141                	addi	sp,sp,16
    8000548e:	8082                	ret

0000000080005490 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80005490:	1101                	addi	sp,sp,-32
    80005492:	ec06                	sd	ra,24(sp)
    80005494:	e822                	sd	s0,16(sp)
    80005496:	e426                	sd	s1,8(sp)
    80005498:	1000                	addi	s0,sp,32
    8000549a:	84aa                	mv	s1,a0
  int hart = cpuid();
    8000549c:	ffffc097          	auipc	ra,0xffffc
    800054a0:	b9a080e7          	jalr	-1126(ra) # 80001036 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800054a4:	00d5179b          	slliw	a5,a0,0xd
    800054a8:	0c201737          	lui	a4,0xc201
    800054ac:	97ba                	add	a5,a5,a4
    800054ae:	c3c4                	sw	s1,4(a5)
}
    800054b0:	60e2                	ld	ra,24(sp)
    800054b2:	6442                	ld	s0,16(sp)
    800054b4:	64a2                	ld	s1,8(sp)
    800054b6:	6105                	addi	sp,sp,32
    800054b8:	8082                	ret

00000000800054ba <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800054ba:	1141                	addi	sp,sp,-16
    800054bc:	e406                	sd	ra,8(sp)
    800054be:	e022                	sd	s0,0(sp)
    800054c0:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800054c2:	479d                	li	a5,7
    800054c4:	06a7c863          	blt	a5,a0,80005534 <free_desc+0x7a>
    panic("free_desc 1");
  if(disk.free[i])
    800054c8:	00236717          	auipc	a4,0x236
    800054cc:	b3870713          	addi	a4,a4,-1224 # 8023b000 <disk>
    800054d0:	972a                	add	a4,a4,a0
    800054d2:	6789                	lui	a5,0x2
    800054d4:	97ba                	add	a5,a5,a4
    800054d6:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    800054da:	e7ad                	bnez	a5,80005544 <free_desc+0x8a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800054dc:	00451793          	slli	a5,a0,0x4
    800054e0:	00238717          	auipc	a4,0x238
    800054e4:	b2070713          	addi	a4,a4,-1248 # 8023d000 <disk+0x2000>
    800054e8:	6314                	ld	a3,0(a4)
    800054ea:	96be                	add	a3,a3,a5
    800054ec:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800054f0:	6314                	ld	a3,0(a4)
    800054f2:	96be                	add	a3,a3,a5
    800054f4:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    800054f8:	6314                	ld	a3,0(a4)
    800054fa:	96be                	add	a3,a3,a5
    800054fc:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    80005500:	6318                	ld	a4,0(a4)
    80005502:	97ba                	add	a5,a5,a4
    80005504:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005508:	00236717          	auipc	a4,0x236
    8000550c:	af870713          	addi	a4,a4,-1288 # 8023b000 <disk>
    80005510:	972a                	add	a4,a4,a0
    80005512:	6789                	lui	a5,0x2
    80005514:	97ba                	add	a5,a5,a4
    80005516:	4705                	li	a4,1
    80005518:	00e78c23          	sb	a4,24(a5) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    8000551c:	00238517          	auipc	a0,0x238
    80005520:	afc50513          	addi	a0,a0,-1284 # 8023d018 <disk+0x2018>
    80005524:	ffffc097          	auipc	ra,0xffffc
    80005528:	392080e7          	jalr	914(ra) # 800018b6 <wakeup>
}
    8000552c:	60a2                	ld	ra,8(sp)
    8000552e:	6402                	ld	s0,0(sp)
    80005530:	0141                	addi	sp,sp,16
    80005532:	8082                	ret
    panic("free_desc 1");
    80005534:	00003517          	auipc	a0,0x3
    80005538:	0e450513          	addi	a0,a0,228 # 80008618 <etext+0x618>
    8000553c:	00001097          	auipc	ra,0x1
    80005540:	9f6080e7          	jalr	-1546(ra) # 80005f32 <panic>
    panic("free_desc 2");
    80005544:	00003517          	auipc	a0,0x3
    80005548:	0e450513          	addi	a0,a0,228 # 80008628 <etext+0x628>
    8000554c:	00001097          	auipc	ra,0x1
    80005550:	9e6080e7          	jalr	-1562(ra) # 80005f32 <panic>

0000000080005554 <virtio_disk_init>:
{
    80005554:	1141                	addi	sp,sp,-16
    80005556:	e406                	sd	ra,8(sp)
    80005558:	e022                	sd	s0,0(sp)
    8000555a:	0800                	addi	s0,sp,16
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000555c:	00003597          	auipc	a1,0x3
    80005560:	0dc58593          	addi	a1,a1,220 # 80008638 <etext+0x638>
    80005564:	00238517          	auipc	a0,0x238
    80005568:	bc450513          	addi	a0,a0,-1084 # 8023d128 <disk+0x2128>
    8000556c:	00001097          	auipc	ra,0x1
    80005570:	eb2080e7          	jalr	-334(ra) # 8000641e <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005574:	100017b7          	lui	a5,0x10001
    80005578:	4398                	lw	a4,0(a5)
    8000557a:	2701                	sext.w	a4,a4
    8000557c:	747277b7          	lui	a5,0x74727
    80005580:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005584:	0ef71563          	bne	a4,a5,8000566e <virtio_disk_init+0x11a>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005588:	100017b7          	lui	a5,0x10001
    8000558c:	43dc                	lw	a5,4(a5)
    8000558e:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005590:	4705                	li	a4,1
    80005592:	0ce79e63          	bne	a5,a4,8000566e <virtio_disk_init+0x11a>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005596:	100017b7          	lui	a5,0x10001
    8000559a:	479c                	lw	a5,8(a5)
    8000559c:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    8000559e:	4709                	li	a4,2
    800055a0:	0ce79763          	bne	a5,a4,8000566e <virtio_disk_init+0x11a>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800055a4:	100017b7          	lui	a5,0x10001
    800055a8:	47d8                	lw	a4,12(a5)
    800055aa:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800055ac:	554d47b7          	lui	a5,0x554d4
    800055b0:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800055b4:	0af71d63          	bne	a4,a5,8000566e <virtio_disk_init+0x11a>
  *R(VIRTIO_MMIO_STATUS) = status;
    800055b8:	100017b7          	lui	a5,0x10001
    800055bc:	4705                	li	a4,1
    800055be:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800055c0:	470d                	li	a4,3
    800055c2:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800055c4:	10001737          	lui	a4,0x10001
    800055c8:	4b18                	lw	a4,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800055ca:	c7ffe6b7          	lui	a3,0xc7ffe
    800055ce:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47db851f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800055d2:	8f75                	and	a4,a4,a3
    800055d4:	100016b7          	lui	a3,0x10001
    800055d8:	d298                	sw	a4,32(a3)
  *R(VIRTIO_MMIO_STATUS) = status;
    800055da:	472d                	li	a4,11
    800055dc:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800055de:	473d                	li	a4,15
    800055e0:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    800055e2:	6705                	lui	a4,0x1
    800055e4:	d698                	sw	a4,40(a3)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800055e6:	0206a823          	sw	zero,48(a3) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800055ea:	5adc                	lw	a5,52(a3)
    800055ec:	2781                	sext.w	a5,a5
  if(max == 0)
    800055ee:	cbc1                	beqz	a5,8000567e <virtio_disk_init+0x12a>
  if(max < NUM)
    800055f0:	471d                	li	a4,7
    800055f2:	08f77e63          	bgeu	a4,a5,8000568e <virtio_disk_init+0x13a>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800055f6:	100017b7          	lui	a5,0x10001
    800055fa:	4721                	li	a4,8
    800055fc:	df98                	sw	a4,56(a5)
  memset(disk.pages, 0, sizeof(disk.pages));
    800055fe:	6609                	lui	a2,0x2
    80005600:	4581                	li	a1,0
    80005602:	00236517          	auipc	a0,0x236
    80005606:	9fe50513          	addi	a0,a0,-1538 # 8023b000 <disk>
    8000560a:	ffffb097          	auipc	ra,0xffffb
    8000560e:	c36080e7          	jalr	-970(ra) # 80000240 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    80005612:	00236717          	auipc	a4,0x236
    80005616:	9ee70713          	addi	a4,a4,-1554 # 8023b000 <disk>
    8000561a:	00c75793          	srli	a5,a4,0xc
    8000561e:	2781                	sext.w	a5,a5
    80005620:	100016b7          	lui	a3,0x10001
    80005624:	c2bc                	sw	a5,64(a3)
  disk.desc = (struct virtq_desc *) disk.pages;
    80005626:	00238797          	auipc	a5,0x238
    8000562a:	9da78793          	addi	a5,a5,-1574 # 8023d000 <disk+0x2000>
    8000562e:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005630:	00236717          	auipc	a4,0x236
    80005634:	a5070713          	addi	a4,a4,-1456 # 8023b080 <disk+0x80>
    80005638:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    8000563a:	00237717          	auipc	a4,0x237
    8000563e:	9c670713          	addi	a4,a4,-1594 # 8023c000 <disk+0x1000>
    80005642:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    80005644:	4705                	li	a4,1
    80005646:	00e78c23          	sb	a4,24(a5)
    8000564a:	00e78ca3          	sb	a4,25(a5)
    8000564e:	00e78d23          	sb	a4,26(a5)
    80005652:	00e78da3          	sb	a4,27(a5)
    80005656:	00e78e23          	sb	a4,28(a5)
    8000565a:	00e78ea3          	sb	a4,29(a5)
    8000565e:	00e78f23          	sb	a4,30(a5)
    80005662:	00e78fa3          	sb	a4,31(a5)
}
    80005666:	60a2                	ld	ra,8(sp)
    80005668:	6402                	ld	s0,0(sp)
    8000566a:	0141                	addi	sp,sp,16
    8000566c:	8082                	ret
    panic("could not find virtio disk");
    8000566e:	00003517          	auipc	a0,0x3
    80005672:	fda50513          	addi	a0,a0,-38 # 80008648 <etext+0x648>
    80005676:	00001097          	auipc	ra,0x1
    8000567a:	8bc080e7          	jalr	-1860(ra) # 80005f32 <panic>
    panic("virtio disk has no queue 0");
    8000567e:	00003517          	auipc	a0,0x3
    80005682:	fea50513          	addi	a0,a0,-22 # 80008668 <etext+0x668>
    80005686:	00001097          	auipc	ra,0x1
    8000568a:	8ac080e7          	jalr	-1876(ra) # 80005f32 <panic>
    panic("virtio disk max queue too short");
    8000568e:	00003517          	auipc	a0,0x3
    80005692:	ffa50513          	addi	a0,a0,-6 # 80008688 <etext+0x688>
    80005696:	00001097          	auipc	ra,0x1
    8000569a:	89c080e7          	jalr	-1892(ra) # 80005f32 <panic>

000000008000569e <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    8000569e:	711d                	addi	sp,sp,-96
    800056a0:	ec86                	sd	ra,88(sp)
    800056a2:	e8a2                	sd	s0,80(sp)
    800056a4:	e4a6                	sd	s1,72(sp)
    800056a6:	e0ca                	sd	s2,64(sp)
    800056a8:	fc4e                	sd	s3,56(sp)
    800056aa:	f852                	sd	s4,48(sp)
    800056ac:	f456                	sd	s5,40(sp)
    800056ae:	f05a                	sd	s6,32(sp)
    800056b0:	ec5e                	sd	s7,24(sp)
    800056b2:	e862                	sd	s8,16(sp)
    800056b4:	1080                	addi	s0,sp,96
    800056b6:	89aa                	mv	s3,a0
    800056b8:	8c2e                	mv	s8,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800056ba:	00c52b83          	lw	s7,12(a0)
    800056be:	001b9b9b          	slliw	s7,s7,0x1
    800056c2:	1b82                	slli	s7,s7,0x20
    800056c4:	020bdb93          	srli	s7,s7,0x20

  acquire(&disk.vdisk_lock);
    800056c8:	00238517          	auipc	a0,0x238
    800056cc:	a6050513          	addi	a0,a0,-1440 # 8023d128 <disk+0x2128>
    800056d0:	00001097          	auipc	ra,0x1
    800056d4:	de2080e7          	jalr	-542(ra) # 800064b2 <acquire>
  for(int i = 0; i < NUM; i++){
    800056d8:	44a1                	li	s1,8
      disk.free[i] = 0;
    800056da:	00236b17          	auipc	s6,0x236
    800056de:	926b0b13          	addi	s6,s6,-1754 # 8023b000 <disk>
    800056e2:	6a89                	lui	s5,0x2
  for(int i = 0; i < 3; i++){
    800056e4:	4a0d                	li	s4,3
    800056e6:	a88d                	j	80005758 <virtio_disk_rw+0xba>
      disk.free[i] = 0;
    800056e8:	00fb0733          	add	a4,s6,a5
    800056ec:	9756                	add	a4,a4,s5
    800056ee:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800056f2:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800056f4:	0207c563          	bltz	a5,8000571e <virtio_disk_rw+0x80>
  for(int i = 0; i < 3; i++){
    800056f8:	2905                	addiw	s2,s2,1
    800056fa:	0611                	addi	a2,a2,4 # 2004 <_entry-0x7fffdffc>
    800056fc:	1b490063          	beq	s2,s4,8000589c <virtio_disk_rw+0x1fe>
    idx[i] = alloc_desc();
    80005700:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80005702:	00238717          	auipc	a4,0x238
    80005706:	91670713          	addi	a4,a4,-1770 # 8023d018 <disk+0x2018>
    8000570a:	4781                	li	a5,0
    if(disk.free[i]){
    8000570c:	00074683          	lbu	a3,0(a4)
    80005710:	fee1                	bnez	a3,800056e8 <virtio_disk_rw+0x4a>
  for(int i = 0; i < NUM; i++){
    80005712:	2785                	addiw	a5,a5,1
    80005714:	0705                	addi	a4,a4,1
    80005716:	fe979be3          	bne	a5,s1,8000570c <virtio_disk_rw+0x6e>
    idx[i] = alloc_desc();
    8000571a:	57fd                	li	a5,-1
    8000571c:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    8000571e:	03205163          	blez	s2,80005740 <virtio_disk_rw+0xa2>
        free_desc(idx[j]);
    80005722:	fa042503          	lw	a0,-96(s0)
    80005726:	00000097          	auipc	ra,0x0
    8000572a:	d94080e7          	jalr	-620(ra) # 800054ba <free_desc>
      for(int j = 0; j < i; j++)
    8000572e:	4785                	li	a5,1
    80005730:	0127d863          	bge	a5,s2,80005740 <virtio_disk_rw+0xa2>
        free_desc(idx[j]);
    80005734:	fa442503          	lw	a0,-92(s0)
    80005738:	00000097          	auipc	ra,0x0
    8000573c:	d82080e7          	jalr	-638(ra) # 800054ba <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005740:	00238597          	auipc	a1,0x238
    80005744:	9e858593          	addi	a1,a1,-1560 # 8023d128 <disk+0x2128>
    80005748:	00238517          	auipc	a0,0x238
    8000574c:	8d050513          	addi	a0,a0,-1840 # 8023d018 <disk+0x2018>
    80005750:	ffffc097          	auipc	ra,0xffffc
    80005754:	fe0080e7          	jalr	-32(ra) # 80001730 <sleep>
  for(int i = 0; i < 3; i++){
    80005758:	fa040613          	addi	a2,s0,-96
    8000575c:	4901                	li	s2,0
    8000575e:	b74d                	j	80005700 <virtio_disk_rw+0x62>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80005760:	00238717          	auipc	a4,0x238
    80005764:	8a073703          	ld	a4,-1888(a4) # 8023d000 <disk+0x2000>
    80005768:	973e                	add	a4,a4,a5
    8000576a:	00071623          	sh	zero,12(a4)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000576e:	00236897          	auipc	a7,0x236
    80005772:	89288893          	addi	a7,a7,-1902 # 8023b000 <disk>
    80005776:	00238717          	auipc	a4,0x238
    8000577a:	88a70713          	addi	a4,a4,-1910 # 8023d000 <disk+0x2000>
    8000577e:	6314                	ld	a3,0(a4)
    80005780:	96be                	add	a3,a3,a5
    80005782:	00c6d583          	lhu	a1,12(a3) # 1000100c <_entry-0x6fffeff4>
    80005786:	0015e593          	ori	a1,a1,1
    8000578a:	00b69623          	sh	a1,12(a3)
  disk.desc[idx[1]].next = idx[2];
    8000578e:	fa842683          	lw	a3,-88(s0)
    80005792:	630c                	ld	a1,0(a4)
    80005794:	97ae                	add	a5,a5,a1
    80005796:	00d79723          	sh	a3,14(a5)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    8000579a:	20050593          	addi	a1,a0,512
    8000579e:	0592                	slli	a1,a1,0x4
    800057a0:	95c6                	add	a1,a1,a7
    800057a2:	57fd                	li	a5,-1
    800057a4:	02f58823          	sb	a5,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800057a8:	00469793          	slli	a5,a3,0x4
    800057ac:	00073803          	ld	a6,0(a4)
    800057b0:	983e                	add	a6,a6,a5
    800057b2:	6689                	lui	a3,0x2
    800057b4:	03068693          	addi	a3,a3,48 # 2030 <_entry-0x7fffdfd0>
    800057b8:	96b2                	add	a3,a3,a2
    800057ba:	96c6                	add	a3,a3,a7
    800057bc:	00d83023          	sd	a3,0(a6)
  disk.desc[idx[2]].len = 1;
    800057c0:	6314                	ld	a3,0(a4)
    800057c2:	96be                	add	a3,a3,a5
    800057c4:	4605                	li	a2,1
    800057c6:	c690                	sw	a2,8(a3)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800057c8:	6314                	ld	a3,0(a4)
    800057ca:	96be                	add	a3,a3,a5
    800057cc:	4809                	li	a6,2
    800057ce:	01069623          	sh	a6,12(a3)
  disk.desc[idx[2]].next = 0;
    800057d2:	6314                	ld	a3,0(a4)
    800057d4:	97b6                	add	a5,a5,a3
    800057d6:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800057da:	00c9a223          	sw	a2,4(s3)
  disk.info[idx[0]].b = b;
    800057de:	0335b423          	sd	s3,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800057e2:	6714                	ld	a3,8(a4)
    800057e4:	0026d783          	lhu	a5,2(a3)
    800057e8:	8b9d                	andi	a5,a5,7
    800057ea:	0786                	slli	a5,a5,0x1
    800057ec:	96be                	add	a3,a3,a5
    800057ee:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    800057f2:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800057f6:	6718                	ld	a4,8(a4)
    800057f8:	00275783          	lhu	a5,2(a4)
    800057fc:	2785                	addiw	a5,a5,1
    800057fe:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005802:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005806:	100017b7          	lui	a5,0x10001
    8000580a:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    8000580e:	0049a783          	lw	a5,4(s3)
    80005812:	02c79163          	bne	a5,a2,80005834 <virtio_disk_rw+0x196>
    sleep(b, &disk.vdisk_lock);
    80005816:	00238917          	auipc	s2,0x238
    8000581a:	91290913          	addi	s2,s2,-1774 # 8023d128 <disk+0x2128>
  while(b->disk == 1) {
    8000581e:	84b2                	mv	s1,a2
    sleep(b, &disk.vdisk_lock);
    80005820:	85ca                	mv	a1,s2
    80005822:	854e                	mv	a0,s3
    80005824:	ffffc097          	auipc	ra,0xffffc
    80005828:	f0c080e7          	jalr	-244(ra) # 80001730 <sleep>
  while(b->disk == 1) {
    8000582c:	0049a783          	lw	a5,4(s3)
    80005830:	fe9788e3          	beq	a5,s1,80005820 <virtio_disk_rw+0x182>
  }

  disk.info[idx[0]].b = 0;
    80005834:	fa042903          	lw	s2,-96(s0)
    80005838:	20090713          	addi	a4,s2,512
    8000583c:	0712                	slli	a4,a4,0x4
    8000583e:	00235797          	auipc	a5,0x235
    80005842:	7c278793          	addi	a5,a5,1986 # 8023b000 <disk>
    80005846:	97ba                	add	a5,a5,a4
    80005848:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    8000584c:	00237997          	auipc	s3,0x237
    80005850:	7b498993          	addi	s3,s3,1972 # 8023d000 <disk+0x2000>
    80005854:	00491713          	slli	a4,s2,0x4
    80005858:	0009b783          	ld	a5,0(s3)
    8000585c:	97ba                	add	a5,a5,a4
    8000585e:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005862:	854a                	mv	a0,s2
    80005864:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005868:	00000097          	auipc	ra,0x0
    8000586c:	c52080e7          	jalr	-942(ra) # 800054ba <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005870:	8885                	andi	s1,s1,1
    80005872:	f0ed                	bnez	s1,80005854 <virtio_disk_rw+0x1b6>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005874:	00238517          	auipc	a0,0x238
    80005878:	8b450513          	addi	a0,a0,-1868 # 8023d128 <disk+0x2128>
    8000587c:	00001097          	auipc	ra,0x1
    80005880:	ce6080e7          	jalr	-794(ra) # 80006562 <release>
}
    80005884:	60e6                	ld	ra,88(sp)
    80005886:	6446                	ld	s0,80(sp)
    80005888:	64a6                	ld	s1,72(sp)
    8000588a:	6906                	ld	s2,64(sp)
    8000588c:	79e2                	ld	s3,56(sp)
    8000588e:	7a42                	ld	s4,48(sp)
    80005890:	7aa2                	ld	s5,40(sp)
    80005892:	7b02                	ld	s6,32(sp)
    80005894:	6be2                	ld	s7,24(sp)
    80005896:	6c42                	ld	s8,16(sp)
    80005898:	6125                	addi	sp,sp,96
    8000589a:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000589c:	fa042503          	lw	a0,-96(s0)
    800058a0:	00451613          	slli	a2,a0,0x4
  if(write)
    800058a4:	00235597          	auipc	a1,0x235
    800058a8:	75c58593          	addi	a1,a1,1884 # 8023b000 <disk>
    800058ac:	20050793          	addi	a5,a0,512
    800058b0:	0792                	slli	a5,a5,0x4
    800058b2:	97ae                	add	a5,a5,a1
    800058b4:	01803733          	snez	a4,s8
    800058b8:	0ae7a423          	sw	a4,168(a5)
  buf0->reserved = 0;
    800058bc:	0a07a623          	sw	zero,172(a5)
  buf0->sector = sector;
    800058c0:	0b77b823          	sd	s7,176(a5)
  disk.desc[idx[0]].addr = (uint64) buf0;
    800058c4:	00237717          	auipc	a4,0x237
    800058c8:	73c70713          	addi	a4,a4,1852 # 8023d000 <disk+0x2000>
    800058cc:	6314                	ld	a3,0(a4)
    800058ce:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800058d0:	6789                	lui	a5,0x2
    800058d2:	0a878793          	addi	a5,a5,168 # 20a8 <_entry-0x7fffdf58>
    800058d6:	97b2                	add	a5,a5,a2
    800058d8:	97ae                	add	a5,a5,a1
  disk.desc[idx[0]].addr = (uint64) buf0;
    800058da:	e29c                	sd	a5,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800058dc:	631c                	ld	a5,0(a4)
    800058de:	97b2                	add	a5,a5,a2
    800058e0:	46c1                	li	a3,16
    800058e2:	c794                	sw	a3,8(a5)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800058e4:	631c                	ld	a5,0(a4)
    800058e6:	97b2                	add	a5,a5,a2
    800058e8:	4685                	li	a3,1
    800058ea:	00d79623          	sh	a3,12(a5)
  disk.desc[idx[0]].next = idx[1];
    800058ee:	fa442783          	lw	a5,-92(s0)
    800058f2:	6314                	ld	a3,0(a4)
    800058f4:	96b2                	add	a3,a3,a2
    800058f6:	00f69723          	sh	a5,14(a3)
  disk.desc[idx[1]].addr = (uint64) b->data;
    800058fa:	0792                	slli	a5,a5,0x4
    800058fc:	6314                	ld	a3,0(a4)
    800058fe:	96be                	add	a3,a3,a5
    80005900:	05898593          	addi	a1,s3,88
    80005904:	e28c                	sd	a1,0(a3)
  disk.desc[idx[1]].len = BSIZE;
    80005906:	6318                	ld	a4,0(a4)
    80005908:	973e                	add	a4,a4,a5
    8000590a:	40000693          	li	a3,1024
    8000590e:	c714                	sw	a3,8(a4)
  if(write)
    80005910:	e40c18e3          	bnez	s8,80005760 <virtio_disk_rw+0xc2>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80005914:	00237717          	auipc	a4,0x237
    80005918:	6ec73703          	ld	a4,1772(a4) # 8023d000 <disk+0x2000>
    8000591c:	973e                	add	a4,a4,a5
    8000591e:	4689                	li	a3,2
    80005920:	00d71623          	sh	a3,12(a4)
    80005924:	b5a9                	j	8000576e <virtio_disk_rw+0xd0>

0000000080005926 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005926:	1101                	addi	sp,sp,-32
    80005928:	ec06                	sd	ra,24(sp)
    8000592a:	e822                	sd	s0,16(sp)
    8000592c:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000592e:	00237517          	auipc	a0,0x237
    80005932:	7fa50513          	addi	a0,a0,2042 # 8023d128 <disk+0x2128>
    80005936:	00001097          	auipc	ra,0x1
    8000593a:	b7c080e7          	jalr	-1156(ra) # 800064b2 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    8000593e:	100017b7          	lui	a5,0x10001
    80005942:	53bc                	lw	a5,96(a5)
    80005944:	8b8d                	andi	a5,a5,3
    80005946:	10001737          	lui	a4,0x10001
    8000594a:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    8000594c:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005950:	00237797          	auipc	a5,0x237
    80005954:	6b078793          	addi	a5,a5,1712 # 8023d000 <disk+0x2000>
    80005958:	6b94                	ld	a3,16(a5)
    8000595a:	0207d703          	lhu	a4,32(a5)
    8000595e:	0026d783          	lhu	a5,2(a3)
    80005962:	06f70563          	beq	a4,a5,800059cc <virtio_disk_intr+0xa6>
    80005966:	e426                	sd	s1,8(sp)
    80005968:	e04a                	sd	s2,0(sp)
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000596a:	00235917          	auipc	s2,0x235
    8000596e:	69690913          	addi	s2,s2,1686 # 8023b000 <disk>
    80005972:	00237497          	auipc	s1,0x237
    80005976:	68e48493          	addi	s1,s1,1678 # 8023d000 <disk+0x2000>
    __sync_synchronize();
    8000597a:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000597e:	6898                	ld	a4,16(s1)
    80005980:	0204d783          	lhu	a5,32(s1)
    80005984:	8b9d                	andi	a5,a5,7
    80005986:	078e                	slli	a5,a5,0x3
    80005988:	97ba                	add	a5,a5,a4
    8000598a:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    8000598c:	20078713          	addi	a4,a5,512
    80005990:	0712                	slli	a4,a4,0x4
    80005992:	974a                	add	a4,a4,s2
    80005994:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    80005998:	e731                	bnez	a4,800059e4 <virtio_disk_intr+0xbe>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    8000599a:	20078793          	addi	a5,a5,512
    8000599e:	0792                	slli	a5,a5,0x4
    800059a0:	97ca                	add	a5,a5,s2
    800059a2:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    800059a4:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800059a8:	ffffc097          	auipc	ra,0xffffc
    800059ac:	f0e080e7          	jalr	-242(ra) # 800018b6 <wakeup>

    disk.used_idx += 1;
    800059b0:	0204d783          	lhu	a5,32(s1)
    800059b4:	2785                	addiw	a5,a5,1
    800059b6:	17c2                	slli	a5,a5,0x30
    800059b8:	93c1                	srli	a5,a5,0x30
    800059ba:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800059be:	6898                	ld	a4,16(s1)
    800059c0:	00275703          	lhu	a4,2(a4)
    800059c4:	faf71be3          	bne	a4,a5,8000597a <virtio_disk_intr+0x54>
    800059c8:	64a2                	ld	s1,8(sp)
    800059ca:	6902                	ld	s2,0(sp)
  }

  release(&disk.vdisk_lock);
    800059cc:	00237517          	auipc	a0,0x237
    800059d0:	75c50513          	addi	a0,a0,1884 # 8023d128 <disk+0x2128>
    800059d4:	00001097          	auipc	ra,0x1
    800059d8:	b8e080e7          	jalr	-1138(ra) # 80006562 <release>
}
    800059dc:	60e2                	ld	ra,24(sp)
    800059de:	6442                	ld	s0,16(sp)
    800059e0:	6105                	addi	sp,sp,32
    800059e2:	8082                	ret
      panic("virtio_disk_intr status");
    800059e4:	00003517          	auipc	a0,0x3
    800059e8:	cc450513          	addi	a0,a0,-828 # 800086a8 <etext+0x6a8>
    800059ec:	00000097          	auipc	ra,0x0
    800059f0:	546080e7          	jalr	1350(ra) # 80005f32 <panic>

00000000800059f4 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    800059f4:	1141                	addi	sp,sp,-16
    800059f6:	e406                	sd	ra,8(sp)
    800059f8:	e022                	sd	s0,0(sp)
    800059fa:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800059fc:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005a00:	2781                	sext.w	a5,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005a02:	0037961b          	slliw	a2,a5,0x3
    80005a06:	02004737          	lui	a4,0x2004
    80005a0a:	963a                	add	a2,a2,a4
    80005a0c:	0200c737          	lui	a4,0x200c
    80005a10:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005a14:	000f46b7          	lui	a3,0xf4
    80005a18:	24068693          	addi	a3,a3,576 # f4240 <_entry-0x7ff0bdc0>
    80005a1c:	9736                	add	a4,a4,a3
    80005a1e:	e218                	sd	a4,0(a2)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005a20:	00279713          	slli	a4,a5,0x2
    80005a24:	973e                	add	a4,a4,a5
    80005a26:	070e                	slli	a4,a4,0x3
    80005a28:	00238797          	auipc	a5,0x238
    80005a2c:	5d878793          	addi	a5,a5,1496 # 8023e000 <timer_scratch>
    80005a30:	97ba                	add	a5,a5,a4
  scratch[3] = CLINT_MTIMECMP(id);
    80005a32:	ef90                	sd	a2,24(a5)
  scratch[4] = interval;
    80005a34:	f394                	sd	a3,32(a5)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005a36:	34079073          	csrw	mscratch,a5
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005a3a:	00000797          	auipc	a5,0x0
    80005a3e:	9b678793          	addi	a5,a5,-1610 # 800053f0 <timervec>
    80005a42:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005a46:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005a4a:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005a4e:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005a52:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005a56:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005a5a:	30479073          	csrw	mie,a5
}
    80005a5e:	60a2                	ld	ra,8(sp)
    80005a60:	6402                	ld	s0,0(sp)
    80005a62:	0141                	addi	sp,sp,16
    80005a64:	8082                	ret

0000000080005a66 <start>:
{
    80005a66:	1141                	addi	sp,sp,-16
    80005a68:	e406                	sd	ra,8(sp)
    80005a6a:	e022                	sd	s0,0(sp)
    80005a6c:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005a6e:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005a72:	7779                	lui	a4,0xffffe
    80005a74:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7fdb85bf>
    80005a78:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005a7a:	6705                	lui	a4,0x1
    80005a7c:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005a80:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005a82:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005a86:	ffffb797          	auipc	a5,0xffffb
    80005a8a:	97478793          	addi	a5,a5,-1676 # 800003fa <main>
    80005a8e:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005a92:	4781                	li	a5,0
    80005a94:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005a98:	67c1                	lui	a5,0x10
    80005a9a:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80005a9c:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005aa0:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005aa4:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005aa8:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005aac:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005ab0:	57fd                	li	a5,-1
    80005ab2:	83a9                	srli	a5,a5,0xa
    80005ab4:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005ab8:	47bd                	li	a5,15
    80005aba:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005abe:	00000097          	auipc	ra,0x0
    80005ac2:	f36080e7          	jalr	-202(ra) # 800059f4 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005ac6:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005aca:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005acc:	823e                	mv	tp,a5
  asm volatile("mret");
    80005ace:	30200073          	mret
}
    80005ad2:	60a2                	ld	ra,8(sp)
    80005ad4:	6402                	ld	s0,0(sp)
    80005ad6:	0141                	addi	sp,sp,16
    80005ad8:	8082                	ret

0000000080005ada <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005ada:	711d                	addi	sp,sp,-96
    80005adc:	ec86                	sd	ra,88(sp)
    80005ade:	e8a2                	sd	s0,80(sp)
    80005ae0:	e0ca                	sd	s2,64(sp)
    80005ae2:	1080                	addi	s0,sp,96
  int i;

  for(i = 0; i < n; i++){
    80005ae4:	04c05c63          	blez	a2,80005b3c <consolewrite+0x62>
    80005ae8:	e4a6                	sd	s1,72(sp)
    80005aea:	fc4e                	sd	s3,56(sp)
    80005aec:	f852                	sd	s4,48(sp)
    80005aee:	f456                	sd	s5,40(sp)
    80005af0:	f05a                	sd	s6,32(sp)
    80005af2:	ec5e                	sd	s7,24(sp)
    80005af4:	8a2a                	mv	s4,a0
    80005af6:	84ae                	mv	s1,a1
    80005af8:	89b2                	mv	s3,a2
    80005afa:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005afc:	faf40b93          	addi	s7,s0,-81
    80005b00:	4b05                	li	s6,1
    80005b02:	5afd                	li	s5,-1
    80005b04:	86da                	mv	a3,s6
    80005b06:	8626                	mv	a2,s1
    80005b08:	85d2                	mv	a1,s4
    80005b0a:	855e                	mv	a0,s7
    80005b0c:	ffffc097          	auipc	ra,0xffffc
    80005b10:	018080e7          	jalr	24(ra) # 80001b24 <either_copyin>
    80005b14:	03550663          	beq	a0,s5,80005b40 <consolewrite+0x66>
      break;
    uartputc(c);
    80005b18:	faf44503          	lbu	a0,-81(s0)
    80005b1c:	00000097          	auipc	ra,0x0
    80005b20:	7d4080e7          	jalr	2004(ra) # 800062f0 <uartputc>
  for(i = 0; i < n; i++){
    80005b24:	2905                	addiw	s2,s2,1
    80005b26:	0485                	addi	s1,s1,1
    80005b28:	fd299ee3          	bne	s3,s2,80005b04 <consolewrite+0x2a>
    80005b2c:	894e                	mv	s2,s3
    80005b2e:	64a6                	ld	s1,72(sp)
    80005b30:	79e2                	ld	s3,56(sp)
    80005b32:	7a42                	ld	s4,48(sp)
    80005b34:	7aa2                	ld	s5,40(sp)
    80005b36:	7b02                	ld	s6,32(sp)
    80005b38:	6be2                	ld	s7,24(sp)
    80005b3a:	a809                	j	80005b4c <consolewrite+0x72>
    80005b3c:	4901                	li	s2,0
    80005b3e:	a039                	j	80005b4c <consolewrite+0x72>
    80005b40:	64a6                	ld	s1,72(sp)
    80005b42:	79e2                	ld	s3,56(sp)
    80005b44:	7a42                	ld	s4,48(sp)
    80005b46:	7aa2                	ld	s5,40(sp)
    80005b48:	7b02                	ld	s6,32(sp)
    80005b4a:	6be2                	ld	s7,24(sp)
  }

  return i;
}
    80005b4c:	854a                	mv	a0,s2
    80005b4e:	60e6                	ld	ra,88(sp)
    80005b50:	6446                	ld	s0,80(sp)
    80005b52:	6906                	ld	s2,64(sp)
    80005b54:	6125                	addi	sp,sp,96
    80005b56:	8082                	ret

0000000080005b58 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005b58:	711d                	addi	sp,sp,-96
    80005b5a:	ec86                	sd	ra,88(sp)
    80005b5c:	e8a2                	sd	s0,80(sp)
    80005b5e:	e4a6                	sd	s1,72(sp)
    80005b60:	e0ca                	sd	s2,64(sp)
    80005b62:	fc4e                	sd	s3,56(sp)
    80005b64:	f852                	sd	s4,48(sp)
    80005b66:	f456                	sd	s5,40(sp)
    80005b68:	f05a                	sd	s6,32(sp)
    80005b6a:	1080                	addi	s0,sp,96
    80005b6c:	8aaa                	mv	s5,a0
    80005b6e:	8a2e                	mv	s4,a1
    80005b70:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005b72:	8b32                	mv	s6,a2
  acquire(&cons.lock);
    80005b74:	00240517          	auipc	a0,0x240
    80005b78:	5cc50513          	addi	a0,a0,1484 # 80246140 <cons>
    80005b7c:	00001097          	auipc	ra,0x1
    80005b80:	936080e7          	jalr	-1738(ra) # 800064b2 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005b84:	00240497          	auipc	s1,0x240
    80005b88:	5bc48493          	addi	s1,s1,1468 # 80246140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005b8c:	00240917          	auipc	s2,0x240
    80005b90:	64c90913          	addi	s2,s2,1612 # 802461d8 <cons+0x98>
  while(n > 0){
    80005b94:	0d305263          	blez	s3,80005c58 <consoleread+0x100>
    while(cons.r == cons.w){
    80005b98:	0984a783          	lw	a5,152(s1)
    80005b9c:	09c4a703          	lw	a4,156(s1)
    80005ba0:	0af71763          	bne	a4,a5,80005c4e <consoleread+0xf6>
      if(myproc()->killed){
    80005ba4:	ffffb097          	auipc	ra,0xffffb
    80005ba8:	4c6080e7          	jalr	1222(ra) # 8000106a <myproc>
    80005bac:	551c                	lw	a5,40(a0)
    80005bae:	e7ad                	bnez	a5,80005c18 <consoleread+0xc0>
      sleep(&cons.r, &cons.lock);
    80005bb0:	85a6                	mv	a1,s1
    80005bb2:	854a                	mv	a0,s2
    80005bb4:	ffffc097          	auipc	ra,0xffffc
    80005bb8:	b7c080e7          	jalr	-1156(ra) # 80001730 <sleep>
    while(cons.r == cons.w){
    80005bbc:	0984a783          	lw	a5,152(s1)
    80005bc0:	09c4a703          	lw	a4,156(s1)
    80005bc4:	fef700e3          	beq	a4,a5,80005ba4 <consoleread+0x4c>
    80005bc8:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF];
    80005bca:	00240717          	auipc	a4,0x240
    80005bce:	57670713          	addi	a4,a4,1398 # 80246140 <cons>
    80005bd2:	0017869b          	addiw	a3,a5,1
    80005bd6:	08d72c23          	sw	a3,152(a4)
    80005bda:	07f7f693          	andi	a3,a5,127
    80005bde:	9736                	add	a4,a4,a3
    80005be0:	01874703          	lbu	a4,24(a4)
    80005be4:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80005be8:	4691                	li	a3,4
    80005bea:	04db8a63          	beq	s7,a3,80005c3e <consoleread+0xe6>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80005bee:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005bf2:	4685                	li	a3,1
    80005bf4:	faf40613          	addi	a2,s0,-81
    80005bf8:	85d2                	mv	a1,s4
    80005bfa:	8556                	mv	a0,s5
    80005bfc:	ffffc097          	auipc	ra,0xffffc
    80005c00:	ed2080e7          	jalr	-302(ra) # 80001ace <either_copyout>
    80005c04:	57fd                	li	a5,-1
    80005c06:	04f50863          	beq	a0,a5,80005c56 <consoleread+0xfe>
      break;

    dst++;
    80005c0a:	0a05                	addi	s4,s4,1
    --n;
    80005c0c:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    80005c0e:	47a9                	li	a5,10
    80005c10:	04fb8f63          	beq	s7,a5,80005c6e <consoleread+0x116>
    80005c14:	6be2                	ld	s7,24(sp)
    80005c16:	bfbd                	j	80005b94 <consoleread+0x3c>
        release(&cons.lock);
    80005c18:	00240517          	auipc	a0,0x240
    80005c1c:	52850513          	addi	a0,a0,1320 # 80246140 <cons>
    80005c20:	00001097          	auipc	ra,0x1
    80005c24:	942080e7          	jalr	-1726(ra) # 80006562 <release>
        return -1;
    80005c28:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80005c2a:	60e6                	ld	ra,88(sp)
    80005c2c:	6446                	ld	s0,80(sp)
    80005c2e:	64a6                	ld	s1,72(sp)
    80005c30:	6906                	ld	s2,64(sp)
    80005c32:	79e2                	ld	s3,56(sp)
    80005c34:	7a42                	ld	s4,48(sp)
    80005c36:	7aa2                	ld	s5,40(sp)
    80005c38:	7b02                	ld	s6,32(sp)
    80005c3a:	6125                	addi	sp,sp,96
    80005c3c:	8082                	ret
      if(n < target){
    80005c3e:	0169fa63          	bgeu	s3,s6,80005c52 <consoleread+0xfa>
        cons.r--;
    80005c42:	00240717          	auipc	a4,0x240
    80005c46:	58f72b23          	sw	a5,1430(a4) # 802461d8 <cons+0x98>
    80005c4a:	6be2                	ld	s7,24(sp)
    80005c4c:	a031                	j	80005c58 <consoleread+0x100>
    80005c4e:	ec5e                	sd	s7,24(sp)
    80005c50:	bfad                	j	80005bca <consoleread+0x72>
    80005c52:	6be2                	ld	s7,24(sp)
    80005c54:	a011                	j	80005c58 <consoleread+0x100>
    80005c56:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80005c58:	00240517          	auipc	a0,0x240
    80005c5c:	4e850513          	addi	a0,a0,1256 # 80246140 <cons>
    80005c60:	00001097          	auipc	ra,0x1
    80005c64:	902080e7          	jalr	-1790(ra) # 80006562 <release>
  return target - n;
    80005c68:	413b053b          	subw	a0,s6,s3
    80005c6c:	bf7d                	j	80005c2a <consoleread+0xd2>
    80005c6e:	6be2                	ld	s7,24(sp)
    80005c70:	b7e5                	j	80005c58 <consoleread+0x100>

0000000080005c72 <consputc>:
{
    80005c72:	1141                	addi	sp,sp,-16
    80005c74:	e406                	sd	ra,8(sp)
    80005c76:	e022                	sd	s0,0(sp)
    80005c78:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005c7a:	10000793          	li	a5,256
    80005c7e:	00f50a63          	beq	a0,a5,80005c92 <consputc+0x20>
    uartputc_sync(c);
    80005c82:	00000097          	auipc	ra,0x0
    80005c86:	590080e7          	jalr	1424(ra) # 80006212 <uartputc_sync>
}
    80005c8a:	60a2                	ld	ra,8(sp)
    80005c8c:	6402                	ld	s0,0(sp)
    80005c8e:	0141                	addi	sp,sp,16
    80005c90:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005c92:	4521                	li	a0,8
    80005c94:	00000097          	auipc	ra,0x0
    80005c98:	57e080e7          	jalr	1406(ra) # 80006212 <uartputc_sync>
    80005c9c:	02000513          	li	a0,32
    80005ca0:	00000097          	auipc	ra,0x0
    80005ca4:	572080e7          	jalr	1394(ra) # 80006212 <uartputc_sync>
    80005ca8:	4521                	li	a0,8
    80005caa:	00000097          	auipc	ra,0x0
    80005cae:	568080e7          	jalr	1384(ra) # 80006212 <uartputc_sync>
    80005cb2:	bfe1                	j	80005c8a <consputc+0x18>

0000000080005cb4 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005cb4:	7179                	addi	sp,sp,-48
    80005cb6:	f406                	sd	ra,40(sp)
    80005cb8:	f022                	sd	s0,32(sp)
    80005cba:	ec26                	sd	s1,24(sp)
    80005cbc:	1800                	addi	s0,sp,48
    80005cbe:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005cc0:	00240517          	auipc	a0,0x240
    80005cc4:	48050513          	addi	a0,a0,1152 # 80246140 <cons>
    80005cc8:	00000097          	auipc	ra,0x0
    80005ccc:	7ea080e7          	jalr	2026(ra) # 800064b2 <acquire>

  switch(c){
    80005cd0:	47d5                	li	a5,21
    80005cd2:	0af48463          	beq	s1,a5,80005d7a <consoleintr+0xc6>
    80005cd6:	0297c963          	blt	a5,s1,80005d08 <consoleintr+0x54>
    80005cda:	47a1                	li	a5,8
    80005cdc:	10f48063          	beq	s1,a5,80005ddc <consoleintr+0x128>
    80005ce0:	47c1                	li	a5,16
    80005ce2:	12f49363          	bne	s1,a5,80005e08 <consoleintr+0x154>
  case C('P'):  // Print process list.
    procdump();
    80005ce6:	ffffc097          	auipc	ra,0xffffc
    80005cea:	e94080e7          	jalr	-364(ra) # 80001b7a <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005cee:	00240517          	auipc	a0,0x240
    80005cf2:	45250513          	addi	a0,a0,1106 # 80246140 <cons>
    80005cf6:	00001097          	auipc	ra,0x1
    80005cfa:	86c080e7          	jalr	-1940(ra) # 80006562 <release>
}
    80005cfe:	70a2                	ld	ra,40(sp)
    80005d00:	7402                	ld	s0,32(sp)
    80005d02:	64e2                	ld	s1,24(sp)
    80005d04:	6145                	addi	sp,sp,48
    80005d06:	8082                	ret
  switch(c){
    80005d08:	07f00793          	li	a5,127
    80005d0c:	0cf48863          	beq	s1,a5,80005ddc <consoleintr+0x128>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005d10:	00240717          	auipc	a4,0x240
    80005d14:	43070713          	addi	a4,a4,1072 # 80246140 <cons>
    80005d18:	0a072783          	lw	a5,160(a4)
    80005d1c:	09872703          	lw	a4,152(a4)
    80005d20:	9f99                	subw	a5,a5,a4
    80005d22:	07f00713          	li	a4,127
    80005d26:	fcf764e3          	bltu	a4,a5,80005cee <consoleintr+0x3a>
      c = (c == '\r') ? '\n' : c;
    80005d2a:	47b5                	li	a5,13
    80005d2c:	0ef48163          	beq	s1,a5,80005e0e <consoleintr+0x15a>
      consputc(c);
    80005d30:	8526                	mv	a0,s1
    80005d32:	00000097          	auipc	ra,0x0
    80005d36:	f40080e7          	jalr	-192(ra) # 80005c72 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005d3a:	00240797          	auipc	a5,0x240
    80005d3e:	40678793          	addi	a5,a5,1030 # 80246140 <cons>
    80005d42:	0a07a703          	lw	a4,160(a5)
    80005d46:	0017069b          	addiw	a3,a4,1
    80005d4a:	8636                	mv	a2,a3
    80005d4c:	0ad7a023          	sw	a3,160(a5)
    80005d50:	07f77713          	andi	a4,a4,127
    80005d54:	97ba                	add	a5,a5,a4
    80005d56:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005d5a:	47a9                	li	a5,10
    80005d5c:	0cf48f63          	beq	s1,a5,80005e3a <consoleintr+0x186>
    80005d60:	4791                	li	a5,4
    80005d62:	0cf48c63          	beq	s1,a5,80005e3a <consoleintr+0x186>
    80005d66:	00240797          	auipc	a5,0x240
    80005d6a:	4727a783          	lw	a5,1138(a5) # 802461d8 <cons+0x98>
    80005d6e:	0807879b          	addiw	a5,a5,128
    80005d72:	f6f69ee3          	bne	a3,a5,80005cee <consoleintr+0x3a>
    80005d76:	863e                	mv	a2,a5
    80005d78:	a0c9                	j	80005e3a <consoleintr+0x186>
    80005d7a:	e84a                	sd	s2,16(sp)
    80005d7c:	e44e                	sd	s3,8(sp)
    while(cons.e != cons.w &&
    80005d7e:	00240717          	auipc	a4,0x240
    80005d82:	3c270713          	addi	a4,a4,962 # 80246140 <cons>
    80005d86:	0a072783          	lw	a5,160(a4)
    80005d8a:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005d8e:	00240497          	auipc	s1,0x240
    80005d92:	3b248493          	addi	s1,s1,946 # 80246140 <cons>
    while(cons.e != cons.w &&
    80005d96:	4929                	li	s2,10
      consputc(BACKSPACE);
    80005d98:	10000993          	li	s3,256
    while(cons.e != cons.w &&
    80005d9c:	02f70a63          	beq	a4,a5,80005dd0 <consoleintr+0x11c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005da0:	37fd                	addiw	a5,a5,-1
    80005da2:	07f7f713          	andi	a4,a5,127
    80005da6:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005da8:	01874703          	lbu	a4,24(a4)
    80005dac:	03270563          	beq	a4,s2,80005dd6 <consoleintr+0x122>
      cons.e--;
    80005db0:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005db4:	854e                	mv	a0,s3
    80005db6:	00000097          	auipc	ra,0x0
    80005dba:	ebc080e7          	jalr	-324(ra) # 80005c72 <consputc>
    while(cons.e != cons.w &&
    80005dbe:	0a04a783          	lw	a5,160(s1)
    80005dc2:	09c4a703          	lw	a4,156(s1)
    80005dc6:	fcf71de3          	bne	a4,a5,80005da0 <consoleintr+0xec>
    80005dca:	6942                	ld	s2,16(sp)
    80005dcc:	69a2                	ld	s3,8(sp)
    80005dce:	b705                	j	80005cee <consoleintr+0x3a>
    80005dd0:	6942                	ld	s2,16(sp)
    80005dd2:	69a2                	ld	s3,8(sp)
    80005dd4:	bf29                	j	80005cee <consoleintr+0x3a>
    80005dd6:	6942                	ld	s2,16(sp)
    80005dd8:	69a2                	ld	s3,8(sp)
    80005dda:	bf11                	j	80005cee <consoleintr+0x3a>
    if(cons.e != cons.w){
    80005ddc:	00240717          	auipc	a4,0x240
    80005de0:	36470713          	addi	a4,a4,868 # 80246140 <cons>
    80005de4:	0a072783          	lw	a5,160(a4)
    80005de8:	09c72703          	lw	a4,156(a4)
    80005dec:	f0f701e3          	beq	a4,a5,80005cee <consoleintr+0x3a>
      cons.e--;
    80005df0:	37fd                	addiw	a5,a5,-1
    80005df2:	00240717          	auipc	a4,0x240
    80005df6:	3ef72723          	sw	a5,1006(a4) # 802461e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005dfa:	10000513          	li	a0,256
    80005dfe:	00000097          	auipc	ra,0x0
    80005e02:	e74080e7          	jalr	-396(ra) # 80005c72 <consputc>
    80005e06:	b5e5                	j	80005cee <consoleintr+0x3a>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005e08:	ee0483e3          	beqz	s1,80005cee <consoleintr+0x3a>
    80005e0c:	b711                	j	80005d10 <consoleintr+0x5c>
      consputc(c);
    80005e0e:	4529                	li	a0,10
    80005e10:	00000097          	auipc	ra,0x0
    80005e14:	e62080e7          	jalr	-414(ra) # 80005c72 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005e18:	00240797          	auipc	a5,0x240
    80005e1c:	32878793          	addi	a5,a5,808 # 80246140 <cons>
    80005e20:	0a07a703          	lw	a4,160(a5)
    80005e24:	0017069b          	addiw	a3,a4,1
    80005e28:	8636                	mv	a2,a3
    80005e2a:	0ad7a023          	sw	a3,160(a5)
    80005e2e:	07f77713          	andi	a4,a4,127
    80005e32:	97ba                	add	a5,a5,a4
    80005e34:	4729                	li	a4,10
    80005e36:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005e3a:	00240797          	auipc	a5,0x240
    80005e3e:	3ac7a123          	sw	a2,930(a5) # 802461dc <cons+0x9c>
        wakeup(&cons.r);
    80005e42:	00240517          	auipc	a0,0x240
    80005e46:	39650513          	addi	a0,a0,918 # 802461d8 <cons+0x98>
    80005e4a:	ffffc097          	auipc	ra,0xffffc
    80005e4e:	a6c080e7          	jalr	-1428(ra) # 800018b6 <wakeup>
    80005e52:	bd71                	j	80005cee <consoleintr+0x3a>

0000000080005e54 <consoleinit>:

void
consoleinit(void)
{
    80005e54:	1141                	addi	sp,sp,-16
    80005e56:	e406                	sd	ra,8(sp)
    80005e58:	e022                	sd	s0,0(sp)
    80005e5a:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005e5c:	00003597          	auipc	a1,0x3
    80005e60:	86458593          	addi	a1,a1,-1948 # 800086c0 <etext+0x6c0>
    80005e64:	00240517          	auipc	a0,0x240
    80005e68:	2dc50513          	addi	a0,a0,732 # 80246140 <cons>
    80005e6c:	00000097          	auipc	ra,0x0
    80005e70:	5b2080e7          	jalr	1458(ra) # 8000641e <initlock>

  uartinit();
    80005e74:	00000097          	auipc	ra,0x0
    80005e78:	344080e7          	jalr	836(ra) # 800061b8 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005e7c:	00233797          	auipc	a5,0x233
    80005e80:	26478793          	addi	a5,a5,612 # 802390e0 <devsw>
    80005e84:	00000717          	auipc	a4,0x0
    80005e88:	cd470713          	addi	a4,a4,-812 # 80005b58 <consoleread>
    80005e8c:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005e8e:	00000717          	auipc	a4,0x0
    80005e92:	c4c70713          	addi	a4,a4,-948 # 80005ada <consolewrite>
    80005e96:	ef98                	sd	a4,24(a5)
}
    80005e98:	60a2                	ld	ra,8(sp)
    80005e9a:	6402                	ld	s0,0(sp)
    80005e9c:	0141                	addi	sp,sp,16
    80005e9e:	8082                	ret

0000000080005ea0 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005ea0:	7179                	addi	sp,sp,-48
    80005ea2:	f406                	sd	ra,40(sp)
    80005ea4:	f022                	sd	s0,32(sp)
    80005ea6:	ec26                	sd	s1,24(sp)
    80005ea8:	e84a                	sd	s2,16(sp)
    80005eaa:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005eac:	c219                	beqz	a2,80005eb2 <printint+0x12>
    80005eae:	06054e63          	bltz	a0,80005f2a <printint+0x8a>
    x = -xx;
  else
    x = xx;
    80005eb2:	4e01                	li	t3,0

  i = 0;
    80005eb4:	fd040313          	addi	t1,s0,-48
    x = xx;
    80005eb8:	869a                	mv	a3,t1
  i = 0;
    80005eba:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    80005ebc:	00003817          	auipc	a6,0x3
    80005ec0:	96480813          	addi	a6,a6,-1692 # 80008820 <digits>
    80005ec4:	88be                	mv	a7,a5
    80005ec6:	0017861b          	addiw	a2,a5,1
    80005eca:	87b2                	mv	a5,a2
    80005ecc:	02b5773b          	remuw	a4,a0,a1
    80005ed0:	1702                	slli	a4,a4,0x20
    80005ed2:	9301                	srli	a4,a4,0x20
    80005ed4:	9742                	add	a4,a4,a6
    80005ed6:	00074703          	lbu	a4,0(a4)
    80005eda:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    80005ede:	872a                	mv	a4,a0
    80005ee0:	02b5553b          	divuw	a0,a0,a1
    80005ee4:	0685                	addi	a3,a3,1
    80005ee6:	fcb77fe3          	bgeu	a4,a1,80005ec4 <printint+0x24>

  if(sign)
    80005eea:	000e0c63          	beqz	t3,80005f02 <printint+0x62>
    buf[i++] = '-';
    80005eee:	fe060793          	addi	a5,a2,-32
    80005ef2:	00878633          	add	a2,a5,s0
    80005ef6:	02d00793          	li	a5,45
    80005efa:	fef60823          	sb	a5,-16(a2)
    80005efe:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
    80005f02:	fff7891b          	addiw	s2,a5,-1
    80005f06:	006784b3          	add	s1,a5,t1
    consputc(buf[i]);
    80005f0a:	fff4c503          	lbu	a0,-1(s1)
    80005f0e:	00000097          	auipc	ra,0x0
    80005f12:	d64080e7          	jalr	-668(ra) # 80005c72 <consputc>
  while(--i >= 0)
    80005f16:	397d                	addiw	s2,s2,-1
    80005f18:	14fd                	addi	s1,s1,-1
    80005f1a:	fe0958e3          	bgez	s2,80005f0a <printint+0x6a>
}
    80005f1e:	70a2                	ld	ra,40(sp)
    80005f20:	7402                	ld	s0,32(sp)
    80005f22:	64e2                	ld	s1,24(sp)
    80005f24:	6942                	ld	s2,16(sp)
    80005f26:	6145                	addi	sp,sp,48
    80005f28:	8082                	ret
    x = -xx;
    80005f2a:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005f2e:	4e05                	li	t3,1
    x = -xx;
    80005f30:	b751                	j	80005eb4 <printint+0x14>

0000000080005f32 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005f32:	1101                	addi	sp,sp,-32
    80005f34:	ec06                	sd	ra,24(sp)
    80005f36:	e822                	sd	s0,16(sp)
    80005f38:	e426                	sd	s1,8(sp)
    80005f3a:	1000                	addi	s0,sp,32
    80005f3c:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005f3e:	00240797          	auipc	a5,0x240
    80005f42:	2c07a123          	sw	zero,706(a5) # 80246200 <pr+0x18>
  printf("panic: ");
    80005f46:	00002517          	auipc	a0,0x2
    80005f4a:	78250513          	addi	a0,a0,1922 # 800086c8 <etext+0x6c8>
    80005f4e:	00000097          	auipc	ra,0x0
    80005f52:	02e080e7          	jalr	46(ra) # 80005f7c <printf>
  printf(s);
    80005f56:	8526                	mv	a0,s1
    80005f58:	00000097          	auipc	ra,0x0
    80005f5c:	024080e7          	jalr	36(ra) # 80005f7c <printf>
  printf("\n");
    80005f60:	00002517          	auipc	a0,0x2
    80005f64:	0c050513          	addi	a0,a0,192 # 80008020 <etext+0x20>
    80005f68:	00000097          	auipc	ra,0x0
    80005f6c:	014080e7          	jalr	20(ra) # 80005f7c <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005f70:	4785                	li	a5,1
    80005f72:	00003717          	auipc	a4,0x3
    80005f76:	0af72523          	sw	a5,170(a4) # 8000901c <panicked>
  for(;;)
    80005f7a:	a001                	j	80005f7a <panic+0x48>

0000000080005f7c <printf>:
{
    80005f7c:	7131                	addi	sp,sp,-192
    80005f7e:	fc86                	sd	ra,120(sp)
    80005f80:	f8a2                	sd	s0,112(sp)
    80005f82:	e8d2                	sd	s4,80(sp)
    80005f84:	ec6e                	sd	s11,24(sp)
    80005f86:	0100                	addi	s0,sp,128
    80005f88:	8a2a                	mv	s4,a0
    80005f8a:	e40c                	sd	a1,8(s0)
    80005f8c:	e810                	sd	a2,16(s0)
    80005f8e:	ec14                	sd	a3,24(s0)
    80005f90:	f018                	sd	a4,32(s0)
    80005f92:	f41c                	sd	a5,40(s0)
    80005f94:	03043823          	sd	a6,48(s0)
    80005f98:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005f9c:	00240d97          	auipc	s11,0x240
    80005fa0:	264dad83          	lw	s11,612(s11) # 80246200 <pr+0x18>
  if(locking)
    80005fa4:	040d9463          	bnez	s11,80005fec <printf+0x70>
  if (fmt == 0)
    80005fa8:	040a0b63          	beqz	s4,80005ffe <printf+0x82>
  va_start(ap, fmt);
    80005fac:	00840793          	addi	a5,s0,8
    80005fb0:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005fb4:	000a4503          	lbu	a0,0(s4)
    80005fb8:	18050c63          	beqz	a0,80006150 <printf+0x1d4>
    80005fbc:	f4a6                	sd	s1,104(sp)
    80005fbe:	f0ca                	sd	s2,96(sp)
    80005fc0:	ecce                	sd	s3,88(sp)
    80005fc2:	e4d6                	sd	s5,72(sp)
    80005fc4:	e0da                	sd	s6,64(sp)
    80005fc6:	fc5e                	sd	s7,56(sp)
    80005fc8:	f862                	sd	s8,48(sp)
    80005fca:	f466                	sd	s9,40(sp)
    80005fcc:	f06a                	sd	s10,32(sp)
    80005fce:	4981                	li	s3,0
    if(c != '%'){
    80005fd0:	02500b13          	li	s6,37
    switch(c){
    80005fd4:	07000b93          	li	s7,112
  consputc('x');
    80005fd8:	07800c93          	li	s9,120
    80005fdc:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005fde:	00003a97          	auipc	s5,0x3
    80005fe2:	842a8a93          	addi	s5,s5,-1982 # 80008820 <digits>
    switch(c){
    80005fe6:	07300c13          	li	s8,115
    80005fea:	a0b9                	j	80006038 <printf+0xbc>
    acquire(&pr.lock);
    80005fec:	00240517          	auipc	a0,0x240
    80005ff0:	1fc50513          	addi	a0,a0,508 # 802461e8 <pr>
    80005ff4:	00000097          	auipc	ra,0x0
    80005ff8:	4be080e7          	jalr	1214(ra) # 800064b2 <acquire>
    80005ffc:	b775                	j	80005fa8 <printf+0x2c>
    80005ffe:	f4a6                	sd	s1,104(sp)
    80006000:	f0ca                	sd	s2,96(sp)
    80006002:	ecce                	sd	s3,88(sp)
    80006004:	e4d6                	sd	s5,72(sp)
    80006006:	e0da                	sd	s6,64(sp)
    80006008:	fc5e                	sd	s7,56(sp)
    8000600a:	f862                	sd	s8,48(sp)
    8000600c:	f466                	sd	s9,40(sp)
    8000600e:	f06a                	sd	s10,32(sp)
    panic("null fmt");
    80006010:	00002517          	auipc	a0,0x2
    80006014:	6c850513          	addi	a0,a0,1736 # 800086d8 <etext+0x6d8>
    80006018:	00000097          	auipc	ra,0x0
    8000601c:	f1a080e7          	jalr	-230(ra) # 80005f32 <panic>
      consputc(c);
    80006020:	00000097          	auipc	ra,0x0
    80006024:	c52080e7          	jalr	-942(ra) # 80005c72 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80006028:	0019879b          	addiw	a5,s3,1
    8000602c:	89be                	mv	s3,a5
    8000602e:	97d2                	add	a5,a5,s4
    80006030:	0007c503          	lbu	a0,0(a5)
    80006034:	10050563          	beqz	a0,8000613e <printf+0x1c2>
    if(c != '%'){
    80006038:	ff6514e3          	bne	a0,s6,80006020 <printf+0xa4>
    c = fmt[++i] & 0xff;
    8000603c:	0019879b          	addiw	a5,s3,1
    80006040:	89be                	mv	s3,a5
    80006042:	97d2                	add	a5,a5,s4
    80006044:	0007c783          	lbu	a5,0(a5)
    80006048:	0007849b          	sext.w	s1,a5
    if(c == 0)
    8000604c:	10078a63          	beqz	a5,80006160 <printf+0x1e4>
    switch(c){
    80006050:	05778a63          	beq	a5,s7,800060a4 <printf+0x128>
    80006054:	02fbf463          	bgeu	s7,a5,8000607c <printf+0x100>
    80006058:	09878763          	beq	a5,s8,800060e6 <printf+0x16a>
    8000605c:	0d979663          	bne	a5,s9,80006128 <printf+0x1ac>
      printint(va_arg(ap, int), 16, 1);
    80006060:	f8843783          	ld	a5,-120(s0)
    80006064:	00878713          	addi	a4,a5,8
    80006068:	f8e43423          	sd	a4,-120(s0)
    8000606c:	4605                	li	a2,1
    8000606e:	85ea                	mv	a1,s10
    80006070:	4388                	lw	a0,0(a5)
    80006072:	00000097          	auipc	ra,0x0
    80006076:	e2e080e7          	jalr	-466(ra) # 80005ea0 <printint>
      break;
    8000607a:	b77d                	j	80006028 <printf+0xac>
    switch(c){
    8000607c:	0b678063          	beq	a5,s6,8000611c <printf+0x1a0>
    80006080:	06400713          	li	a4,100
    80006084:	0ae79263          	bne	a5,a4,80006128 <printf+0x1ac>
      printint(va_arg(ap, int), 10, 1);
    80006088:	f8843783          	ld	a5,-120(s0)
    8000608c:	00878713          	addi	a4,a5,8
    80006090:	f8e43423          	sd	a4,-120(s0)
    80006094:	4605                	li	a2,1
    80006096:	45a9                	li	a1,10
    80006098:	4388                	lw	a0,0(a5)
    8000609a:	00000097          	auipc	ra,0x0
    8000609e:	e06080e7          	jalr	-506(ra) # 80005ea0 <printint>
      break;
    800060a2:	b759                	j	80006028 <printf+0xac>
      printptr(va_arg(ap, uint64));
    800060a4:	f8843783          	ld	a5,-120(s0)
    800060a8:	00878713          	addi	a4,a5,8
    800060ac:	f8e43423          	sd	a4,-120(s0)
    800060b0:	0007b903          	ld	s2,0(a5)
  consputc('0');
    800060b4:	03000513          	li	a0,48
    800060b8:	00000097          	auipc	ra,0x0
    800060bc:	bba080e7          	jalr	-1094(ra) # 80005c72 <consputc>
  consputc('x');
    800060c0:	8566                	mv	a0,s9
    800060c2:	00000097          	auipc	ra,0x0
    800060c6:	bb0080e7          	jalr	-1104(ra) # 80005c72 <consputc>
    800060ca:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800060cc:	03c95793          	srli	a5,s2,0x3c
    800060d0:	97d6                	add	a5,a5,s5
    800060d2:	0007c503          	lbu	a0,0(a5)
    800060d6:	00000097          	auipc	ra,0x0
    800060da:	b9c080e7          	jalr	-1124(ra) # 80005c72 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800060de:	0912                	slli	s2,s2,0x4
    800060e0:	34fd                	addiw	s1,s1,-1
    800060e2:	f4ed                	bnez	s1,800060cc <printf+0x150>
    800060e4:	b791                	j	80006028 <printf+0xac>
      if((s = va_arg(ap, char*)) == 0)
    800060e6:	f8843783          	ld	a5,-120(s0)
    800060ea:	00878713          	addi	a4,a5,8
    800060ee:	f8e43423          	sd	a4,-120(s0)
    800060f2:	6384                	ld	s1,0(a5)
    800060f4:	cc89                	beqz	s1,8000610e <printf+0x192>
      for(; *s; s++)
    800060f6:	0004c503          	lbu	a0,0(s1)
    800060fa:	d51d                	beqz	a0,80006028 <printf+0xac>
        consputc(*s);
    800060fc:	00000097          	auipc	ra,0x0
    80006100:	b76080e7          	jalr	-1162(ra) # 80005c72 <consputc>
      for(; *s; s++)
    80006104:	0485                	addi	s1,s1,1
    80006106:	0004c503          	lbu	a0,0(s1)
    8000610a:	f96d                	bnez	a0,800060fc <printf+0x180>
    8000610c:	bf31                	j	80006028 <printf+0xac>
        s = "(null)";
    8000610e:	00002497          	auipc	s1,0x2
    80006112:	5c248493          	addi	s1,s1,1474 # 800086d0 <etext+0x6d0>
      for(; *s; s++)
    80006116:	02800513          	li	a0,40
    8000611a:	b7cd                	j	800060fc <printf+0x180>
      consputc('%');
    8000611c:	855a                	mv	a0,s6
    8000611e:	00000097          	auipc	ra,0x0
    80006122:	b54080e7          	jalr	-1196(ra) # 80005c72 <consputc>
      break;
    80006126:	b709                	j	80006028 <printf+0xac>
      consputc('%');
    80006128:	855a                	mv	a0,s6
    8000612a:	00000097          	auipc	ra,0x0
    8000612e:	b48080e7          	jalr	-1208(ra) # 80005c72 <consputc>
      consputc(c);
    80006132:	8526                	mv	a0,s1
    80006134:	00000097          	auipc	ra,0x0
    80006138:	b3e080e7          	jalr	-1218(ra) # 80005c72 <consputc>
      break;
    8000613c:	b5f5                	j	80006028 <printf+0xac>
    8000613e:	74a6                	ld	s1,104(sp)
    80006140:	7906                	ld	s2,96(sp)
    80006142:	69e6                	ld	s3,88(sp)
    80006144:	6aa6                	ld	s5,72(sp)
    80006146:	6b06                	ld	s6,64(sp)
    80006148:	7be2                	ld	s7,56(sp)
    8000614a:	7c42                	ld	s8,48(sp)
    8000614c:	7ca2                	ld	s9,40(sp)
    8000614e:	7d02                	ld	s10,32(sp)
  if(locking)
    80006150:	020d9263          	bnez	s11,80006174 <printf+0x1f8>
}
    80006154:	70e6                	ld	ra,120(sp)
    80006156:	7446                	ld	s0,112(sp)
    80006158:	6a46                	ld	s4,80(sp)
    8000615a:	6de2                	ld	s11,24(sp)
    8000615c:	6129                	addi	sp,sp,192
    8000615e:	8082                	ret
    80006160:	74a6                	ld	s1,104(sp)
    80006162:	7906                	ld	s2,96(sp)
    80006164:	69e6                	ld	s3,88(sp)
    80006166:	6aa6                	ld	s5,72(sp)
    80006168:	6b06                	ld	s6,64(sp)
    8000616a:	7be2                	ld	s7,56(sp)
    8000616c:	7c42                	ld	s8,48(sp)
    8000616e:	7ca2                	ld	s9,40(sp)
    80006170:	7d02                	ld	s10,32(sp)
    80006172:	bff9                	j	80006150 <printf+0x1d4>
    release(&pr.lock);
    80006174:	00240517          	auipc	a0,0x240
    80006178:	07450513          	addi	a0,a0,116 # 802461e8 <pr>
    8000617c:	00000097          	auipc	ra,0x0
    80006180:	3e6080e7          	jalr	998(ra) # 80006562 <release>
}
    80006184:	bfc1                	j	80006154 <printf+0x1d8>

0000000080006186 <printfinit>:
    ;
}

void
printfinit(void)
{
    80006186:	1101                	addi	sp,sp,-32
    80006188:	ec06                	sd	ra,24(sp)
    8000618a:	e822                	sd	s0,16(sp)
    8000618c:	e426                	sd	s1,8(sp)
    8000618e:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80006190:	00240497          	auipc	s1,0x240
    80006194:	05848493          	addi	s1,s1,88 # 802461e8 <pr>
    80006198:	00002597          	auipc	a1,0x2
    8000619c:	55058593          	addi	a1,a1,1360 # 800086e8 <etext+0x6e8>
    800061a0:	8526                	mv	a0,s1
    800061a2:	00000097          	auipc	ra,0x0
    800061a6:	27c080e7          	jalr	636(ra) # 8000641e <initlock>
  pr.locking = 1;
    800061aa:	4785                	li	a5,1
    800061ac:	cc9c                	sw	a5,24(s1)
}
    800061ae:	60e2                	ld	ra,24(sp)
    800061b0:	6442                	ld	s0,16(sp)
    800061b2:	64a2                	ld	s1,8(sp)
    800061b4:	6105                	addi	sp,sp,32
    800061b6:	8082                	ret

00000000800061b8 <uartinit>:

void uartstart();

void
uartinit(void)
{
    800061b8:	1141                	addi	sp,sp,-16
    800061ba:	e406                	sd	ra,8(sp)
    800061bc:	e022                	sd	s0,0(sp)
    800061be:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800061c0:	100007b7          	lui	a5,0x10000
    800061c4:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800061c8:	10000737          	lui	a4,0x10000
    800061cc:	f8000693          	li	a3,-128
    800061d0:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800061d4:	468d                	li	a3,3
    800061d6:	10000637          	lui	a2,0x10000
    800061da:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800061de:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800061e2:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800061e6:	8732                	mv	a4,a2
    800061e8:	461d                	li	a2,7
    800061ea:	00c70123          	sb	a2,2(a4)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800061ee:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    800061f2:	00002597          	auipc	a1,0x2
    800061f6:	4fe58593          	addi	a1,a1,1278 # 800086f0 <etext+0x6f0>
    800061fa:	00240517          	auipc	a0,0x240
    800061fe:	00e50513          	addi	a0,a0,14 # 80246208 <uart_tx_lock>
    80006202:	00000097          	auipc	ra,0x0
    80006206:	21c080e7          	jalr	540(ra) # 8000641e <initlock>
}
    8000620a:	60a2                	ld	ra,8(sp)
    8000620c:	6402                	ld	s0,0(sp)
    8000620e:	0141                	addi	sp,sp,16
    80006210:	8082                	ret

0000000080006212 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80006212:	1101                	addi	sp,sp,-32
    80006214:	ec06                	sd	ra,24(sp)
    80006216:	e822                	sd	s0,16(sp)
    80006218:	e426                	sd	s1,8(sp)
    8000621a:	1000                	addi	s0,sp,32
    8000621c:	84aa                	mv	s1,a0
  push_off();
    8000621e:	00000097          	auipc	ra,0x0
    80006222:	248080e7          	jalr	584(ra) # 80006466 <push_off>

  if(panicked){
    80006226:	00003797          	auipc	a5,0x3
    8000622a:	df67a783          	lw	a5,-522(a5) # 8000901c <panicked>
    8000622e:	eb85                	bnez	a5,8000625e <uartputc_sync+0x4c>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006230:	10000737          	lui	a4,0x10000
    80006234:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80006236:	00074783          	lbu	a5,0(a4)
    8000623a:	0207f793          	andi	a5,a5,32
    8000623e:	dfe5                	beqz	a5,80006236 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80006240:	0ff4f513          	zext.b	a0,s1
    80006244:	100007b7          	lui	a5,0x10000
    80006248:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    8000624c:	00000097          	auipc	ra,0x0
    80006250:	2ba080e7          	jalr	698(ra) # 80006506 <pop_off>
}
    80006254:	60e2                	ld	ra,24(sp)
    80006256:	6442                	ld	s0,16(sp)
    80006258:	64a2                	ld	s1,8(sp)
    8000625a:	6105                	addi	sp,sp,32
    8000625c:	8082                	ret
    for(;;)
    8000625e:	a001                	j	8000625e <uartputc_sync+0x4c>

0000000080006260 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80006260:	00003797          	auipc	a5,0x3
    80006264:	dc07b783          	ld	a5,-576(a5) # 80009020 <uart_tx_r>
    80006268:	00003717          	auipc	a4,0x3
    8000626c:	dc073703          	ld	a4,-576(a4) # 80009028 <uart_tx_w>
    80006270:	06f70f63          	beq	a4,a5,800062ee <uartstart+0x8e>
{
    80006274:	7139                	addi	sp,sp,-64
    80006276:	fc06                	sd	ra,56(sp)
    80006278:	f822                	sd	s0,48(sp)
    8000627a:	f426                	sd	s1,40(sp)
    8000627c:	f04a                	sd	s2,32(sp)
    8000627e:	ec4e                	sd	s3,24(sp)
    80006280:	e852                	sd	s4,16(sp)
    80006282:	e456                	sd	s5,8(sp)
    80006284:	e05a                	sd	s6,0(sp)
    80006286:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006288:	10000937          	lui	s2,0x10000
    8000628c:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000628e:	00240a97          	auipc	s5,0x240
    80006292:	f7aa8a93          	addi	s5,s5,-134 # 80246208 <uart_tx_lock>
    uart_tx_r += 1;
    80006296:	00003497          	auipc	s1,0x3
    8000629a:	d8a48493          	addi	s1,s1,-630 # 80009020 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    8000629e:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    800062a2:	00003997          	auipc	s3,0x3
    800062a6:	d8698993          	addi	s3,s3,-634 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800062aa:	00094703          	lbu	a4,0(s2)
    800062ae:	02077713          	andi	a4,a4,32
    800062b2:	c705                	beqz	a4,800062da <uartstart+0x7a>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800062b4:	01f7f713          	andi	a4,a5,31
    800062b8:	9756                	add	a4,a4,s5
    800062ba:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    800062be:	0785                	addi	a5,a5,1
    800062c0:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    800062c2:	8526                	mv	a0,s1
    800062c4:	ffffb097          	auipc	ra,0xffffb
    800062c8:	5f2080e7          	jalr	1522(ra) # 800018b6 <wakeup>
    WriteReg(THR, c);
    800062cc:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    800062d0:	609c                	ld	a5,0(s1)
    800062d2:	0009b703          	ld	a4,0(s3)
    800062d6:	fcf71ae3          	bne	a4,a5,800062aa <uartstart+0x4a>
  }
}
    800062da:	70e2                	ld	ra,56(sp)
    800062dc:	7442                	ld	s0,48(sp)
    800062de:	74a2                	ld	s1,40(sp)
    800062e0:	7902                	ld	s2,32(sp)
    800062e2:	69e2                	ld	s3,24(sp)
    800062e4:	6a42                	ld	s4,16(sp)
    800062e6:	6aa2                	ld	s5,8(sp)
    800062e8:	6b02                	ld	s6,0(sp)
    800062ea:	6121                	addi	sp,sp,64
    800062ec:	8082                	ret
    800062ee:	8082                	ret

00000000800062f0 <uartputc>:
{
    800062f0:	7179                	addi	sp,sp,-48
    800062f2:	f406                	sd	ra,40(sp)
    800062f4:	f022                	sd	s0,32(sp)
    800062f6:	e052                	sd	s4,0(sp)
    800062f8:	1800                	addi	s0,sp,48
    800062fa:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800062fc:	00240517          	auipc	a0,0x240
    80006300:	f0c50513          	addi	a0,a0,-244 # 80246208 <uart_tx_lock>
    80006304:	00000097          	auipc	ra,0x0
    80006308:	1ae080e7          	jalr	430(ra) # 800064b2 <acquire>
  if(panicked){
    8000630c:	00003797          	auipc	a5,0x3
    80006310:	d107a783          	lw	a5,-752(a5) # 8000901c <panicked>
    80006314:	c391                	beqz	a5,80006318 <uartputc+0x28>
    for(;;)
    80006316:	a001                	j	80006316 <uartputc+0x26>
    80006318:	ec26                	sd	s1,24(sp)
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000631a:	00003717          	auipc	a4,0x3
    8000631e:	d0e73703          	ld	a4,-754(a4) # 80009028 <uart_tx_w>
    80006322:	00003797          	auipc	a5,0x3
    80006326:	cfe7b783          	ld	a5,-770(a5) # 80009020 <uart_tx_r>
    8000632a:	02078793          	addi	a5,a5,32
    8000632e:	02e79f63          	bne	a5,a4,8000636c <uartputc+0x7c>
    80006332:	e84a                	sd	s2,16(sp)
    80006334:	e44e                	sd	s3,8(sp)
      sleep(&uart_tx_r, &uart_tx_lock);
    80006336:	00240997          	auipc	s3,0x240
    8000633a:	ed298993          	addi	s3,s3,-302 # 80246208 <uart_tx_lock>
    8000633e:	00003497          	auipc	s1,0x3
    80006342:	ce248493          	addi	s1,s1,-798 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006346:	00003917          	auipc	s2,0x3
    8000634a:	ce290913          	addi	s2,s2,-798 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    8000634e:	85ce                	mv	a1,s3
    80006350:	8526                	mv	a0,s1
    80006352:	ffffb097          	auipc	ra,0xffffb
    80006356:	3de080e7          	jalr	990(ra) # 80001730 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000635a:	00093703          	ld	a4,0(s2)
    8000635e:	609c                	ld	a5,0(s1)
    80006360:	02078793          	addi	a5,a5,32
    80006364:	fee785e3          	beq	a5,a4,8000634e <uartputc+0x5e>
    80006368:	6942                	ld	s2,16(sp)
    8000636a:	69a2                	ld	s3,8(sp)
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    8000636c:	00240497          	auipc	s1,0x240
    80006370:	e9c48493          	addi	s1,s1,-356 # 80246208 <uart_tx_lock>
    80006374:	01f77793          	andi	a5,a4,31
    80006378:	97a6                	add	a5,a5,s1
    8000637a:	01478c23          	sb	s4,24(a5)
      uart_tx_w += 1;
    8000637e:	0705                	addi	a4,a4,1
    80006380:	00003797          	auipc	a5,0x3
    80006384:	cae7b423          	sd	a4,-856(a5) # 80009028 <uart_tx_w>
      uartstart();
    80006388:	00000097          	auipc	ra,0x0
    8000638c:	ed8080e7          	jalr	-296(ra) # 80006260 <uartstart>
      release(&uart_tx_lock);
    80006390:	8526                	mv	a0,s1
    80006392:	00000097          	auipc	ra,0x0
    80006396:	1d0080e7          	jalr	464(ra) # 80006562 <release>
    8000639a:	64e2                	ld	s1,24(sp)
}
    8000639c:	70a2                	ld	ra,40(sp)
    8000639e:	7402                	ld	s0,32(sp)
    800063a0:	6a02                	ld	s4,0(sp)
    800063a2:	6145                	addi	sp,sp,48
    800063a4:	8082                	ret

00000000800063a6 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800063a6:	1141                	addi	sp,sp,-16
    800063a8:	e406                	sd	ra,8(sp)
    800063aa:	e022                	sd	s0,0(sp)
    800063ac:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800063ae:	100007b7          	lui	a5,0x10000
    800063b2:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800063b6:	8b85                	andi	a5,a5,1
    800063b8:	cb89                	beqz	a5,800063ca <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    800063ba:	100007b7          	lui	a5,0x10000
    800063be:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800063c2:	60a2                	ld	ra,8(sp)
    800063c4:	6402                	ld	s0,0(sp)
    800063c6:	0141                	addi	sp,sp,16
    800063c8:	8082                	ret
    return -1;
    800063ca:	557d                	li	a0,-1
    800063cc:	bfdd                	j	800063c2 <uartgetc+0x1c>

00000000800063ce <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    800063ce:	1101                	addi	sp,sp,-32
    800063d0:	ec06                	sd	ra,24(sp)
    800063d2:	e822                	sd	s0,16(sp)
    800063d4:	e426                	sd	s1,8(sp)
    800063d6:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800063d8:	54fd                	li	s1,-1
    int c = uartgetc();
    800063da:	00000097          	auipc	ra,0x0
    800063de:	fcc080e7          	jalr	-52(ra) # 800063a6 <uartgetc>
    if(c == -1)
    800063e2:	00950763          	beq	a0,s1,800063f0 <uartintr+0x22>
      break;
    consoleintr(c);
    800063e6:	00000097          	auipc	ra,0x0
    800063ea:	8ce080e7          	jalr	-1842(ra) # 80005cb4 <consoleintr>
  while(1){
    800063ee:	b7f5                	j	800063da <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800063f0:	00240497          	auipc	s1,0x240
    800063f4:	e1848493          	addi	s1,s1,-488 # 80246208 <uart_tx_lock>
    800063f8:	8526                	mv	a0,s1
    800063fa:	00000097          	auipc	ra,0x0
    800063fe:	0b8080e7          	jalr	184(ra) # 800064b2 <acquire>
  uartstart();
    80006402:	00000097          	auipc	ra,0x0
    80006406:	e5e080e7          	jalr	-418(ra) # 80006260 <uartstart>
  release(&uart_tx_lock);
    8000640a:	8526                	mv	a0,s1
    8000640c:	00000097          	auipc	ra,0x0
    80006410:	156080e7          	jalr	342(ra) # 80006562 <release>
}
    80006414:	60e2                	ld	ra,24(sp)
    80006416:	6442                	ld	s0,16(sp)
    80006418:	64a2                	ld	s1,8(sp)
    8000641a:	6105                	addi	sp,sp,32
    8000641c:	8082                	ret

000000008000641e <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    8000641e:	1141                	addi	sp,sp,-16
    80006420:	e406                	sd	ra,8(sp)
    80006422:	e022                	sd	s0,0(sp)
    80006424:	0800                	addi	s0,sp,16
  lk->name = name;
    80006426:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80006428:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    8000642c:	00053823          	sd	zero,16(a0)
}
    80006430:	60a2                	ld	ra,8(sp)
    80006432:	6402                	ld	s0,0(sp)
    80006434:	0141                	addi	sp,sp,16
    80006436:	8082                	ret

0000000080006438 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006438:	411c                	lw	a5,0(a0)
    8000643a:	e399                	bnez	a5,80006440 <holding+0x8>
    8000643c:	4501                	li	a0,0
  return r;
}
    8000643e:	8082                	ret
{
    80006440:	1101                	addi	sp,sp,-32
    80006442:	ec06                	sd	ra,24(sp)
    80006444:	e822                	sd	s0,16(sp)
    80006446:	e426                	sd	s1,8(sp)
    80006448:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    8000644a:	6904                	ld	s1,16(a0)
    8000644c:	ffffb097          	auipc	ra,0xffffb
    80006450:	bfe080e7          	jalr	-1026(ra) # 8000104a <mycpu>
    80006454:	40a48533          	sub	a0,s1,a0
    80006458:	00153513          	seqz	a0,a0
}
    8000645c:	60e2                	ld	ra,24(sp)
    8000645e:	6442                	ld	s0,16(sp)
    80006460:	64a2                	ld	s1,8(sp)
    80006462:	6105                	addi	sp,sp,32
    80006464:	8082                	ret

0000000080006466 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006466:	1101                	addi	sp,sp,-32
    80006468:	ec06                	sd	ra,24(sp)
    8000646a:	e822                	sd	s0,16(sp)
    8000646c:	e426                	sd	s1,8(sp)
    8000646e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006470:	100024f3          	csrr	s1,sstatus
    80006474:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006478:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000647a:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    8000647e:	ffffb097          	auipc	ra,0xffffb
    80006482:	bcc080e7          	jalr	-1076(ra) # 8000104a <mycpu>
    80006486:	5d3c                	lw	a5,120(a0)
    80006488:	cf89                	beqz	a5,800064a2 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    8000648a:	ffffb097          	auipc	ra,0xffffb
    8000648e:	bc0080e7          	jalr	-1088(ra) # 8000104a <mycpu>
    80006492:	5d3c                	lw	a5,120(a0)
    80006494:	2785                	addiw	a5,a5,1
    80006496:	dd3c                	sw	a5,120(a0)
}
    80006498:	60e2                	ld	ra,24(sp)
    8000649a:	6442                	ld	s0,16(sp)
    8000649c:	64a2                	ld	s1,8(sp)
    8000649e:	6105                	addi	sp,sp,32
    800064a0:	8082                	ret
    mycpu()->intena = old;
    800064a2:	ffffb097          	auipc	ra,0xffffb
    800064a6:	ba8080e7          	jalr	-1112(ra) # 8000104a <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800064aa:	8085                	srli	s1,s1,0x1
    800064ac:	8885                	andi	s1,s1,1
    800064ae:	dd64                	sw	s1,124(a0)
    800064b0:	bfe9                	j	8000648a <push_off+0x24>

00000000800064b2 <acquire>:
{
    800064b2:	1101                	addi	sp,sp,-32
    800064b4:	ec06                	sd	ra,24(sp)
    800064b6:	e822                	sd	s0,16(sp)
    800064b8:	e426                	sd	s1,8(sp)
    800064ba:	1000                	addi	s0,sp,32
    800064bc:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800064be:	00000097          	auipc	ra,0x0
    800064c2:	fa8080e7          	jalr	-88(ra) # 80006466 <push_off>
  if(holding(lk))
    800064c6:	8526                	mv	a0,s1
    800064c8:	00000097          	auipc	ra,0x0
    800064cc:	f70080e7          	jalr	-144(ra) # 80006438 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800064d0:	4705                	li	a4,1
  if(holding(lk))
    800064d2:	e115                	bnez	a0,800064f6 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800064d4:	87ba                	mv	a5,a4
    800064d6:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800064da:	2781                	sext.w	a5,a5
    800064dc:	ffe5                	bnez	a5,800064d4 <acquire+0x22>
  __sync_synchronize();
    800064de:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    800064e2:	ffffb097          	auipc	ra,0xffffb
    800064e6:	b68080e7          	jalr	-1176(ra) # 8000104a <mycpu>
    800064ea:	e888                	sd	a0,16(s1)
}
    800064ec:	60e2                	ld	ra,24(sp)
    800064ee:	6442                	ld	s0,16(sp)
    800064f0:	64a2                	ld	s1,8(sp)
    800064f2:	6105                	addi	sp,sp,32
    800064f4:	8082                	ret
    panic("acquire");
    800064f6:	00002517          	auipc	a0,0x2
    800064fa:	20250513          	addi	a0,a0,514 # 800086f8 <etext+0x6f8>
    800064fe:	00000097          	auipc	ra,0x0
    80006502:	a34080e7          	jalr	-1484(ra) # 80005f32 <panic>

0000000080006506 <pop_off>:

void
pop_off(void)
{
    80006506:	1141                	addi	sp,sp,-16
    80006508:	e406                	sd	ra,8(sp)
    8000650a:	e022                	sd	s0,0(sp)
    8000650c:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    8000650e:	ffffb097          	auipc	ra,0xffffb
    80006512:	b3c080e7          	jalr	-1220(ra) # 8000104a <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006516:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000651a:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000651c:	e39d                	bnez	a5,80006542 <pop_off+0x3c>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    8000651e:	5d3c                	lw	a5,120(a0)
    80006520:	02f05963          	blez	a5,80006552 <pop_off+0x4c>
    panic("pop_off");
  c->noff -= 1;
    80006524:	37fd                	addiw	a5,a5,-1
    80006526:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006528:	eb89                	bnez	a5,8000653a <pop_off+0x34>
    8000652a:	5d7c                	lw	a5,124(a0)
    8000652c:	c799                	beqz	a5,8000653a <pop_off+0x34>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000652e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006532:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006536:	10079073          	csrw	sstatus,a5
    intr_on();
}
    8000653a:	60a2                	ld	ra,8(sp)
    8000653c:	6402                	ld	s0,0(sp)
    8000653e:	0141                	addi	sp,sp,16
    80006540:	8082                	ret
    panic("pop_off - interruptible");
    80006542:	00002517          	auipc	a0,0x2
    80006546:	1be50513          	addi	a0,a0,446 # 80008700 <etext+0x700>
    8000654a:	00000097          	auipc	ra,0x0
    8000654e:	9e8080e7          	jalr	-1560(ra) # 80005f32 <panic>
    panic("pop_off");
    80006552:	00002517          	auipc	a0,0x2
    80006556:	1c650513          	addi	a0,a0,454 # 80008718 <etext+0x718>
    8000655a:	00000097          	auipc	ra,0x0
    8000655e:	9d8080e7          	jalr	-1576(ra) # 80005f32 <panic>

0000000080006562 <release>:
{
    80006562:	1101                	addi	sp,sp,-32
    80006564:	ec06                	sd	ra,24(sp)
    80006566:	e822                	sd	s0,16(sp)
    80006568:	e426                	sd	s1,8(sp)
    8000656a:	1000                	addi	s0,sp,32
    8000656c:	84aa                	mv	s1,a0
  if(!holding(lk))
    8000656e:	00000097          	auipc	ra,0x0
    80006572:	eca080e7          	jalr	-310(ra) # 80006438 <holding>
    80006576:	c115                	beqz	a0,8000659a <release+0x38>
  lk->cpu = 0;
    80006578:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    8000657c:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    80006580:	0310000f          	fence	rw,w
    80006584:	0004a023          	sw	zero,0(s1)
  pop_off();
    80006588:	00000097          	auipc	ra,0x0
    8000658c:	f7e080e7          	jalr	-130(ra) # 80006506 <pop_off>
}
    80006590:	60e2                	ld	ra,24(sp)
    80006592:	6442                	ld	s0,16(sp)
    80006594:	64a2                	ld	s1,8(sp)
    80006596:	6105                	addi	sp,sp,32
    80006598:	8082                	ret
    panic("release");
    8000659a:	00002517          	auipc	a0,0x2
    8000659e:	18650513          	addi	a0,a0,390 # 80008720 <etext+0x720>
    800065a2:	00000097          	auipc	ra,0x0
    800065a6:	990080e7          	jalr	-1648(ra) # 80005f32 <panic>
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
