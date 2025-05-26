
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0001e117          	auipc	sp,0x1e
    80000004:	14010113          	addi	sp,sp,320 # 8001e140 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	001050ef          	jal	80005816 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	ebb9                	bnez	a5,80000082 <kfree+0x66>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00026797          	auipc	a5,0x26
    80000034:	21078793          	addi	a5,a5,528 # 80026240 <end>
    80000038:	04f56563          	bltu	a0,a5,80000082 <kfree+0x66>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	04f57163          	bgeu	a0,a5,80000082 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	00000097          	auipc	ra,0x0
    8000004c:	132080e7          	jalr	306(ra) # 8000017a <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	fe090913          	addi	s2,s2,-32 # 80009030 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	208080e7          	jalr	520(ra) # 80006262 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	2a4080e7          	jalr	676(ra) # 80006312 <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	addi	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00008517          	auipc	a0,0x8
    80000086:	f7e50513          	addi	a0,a0,-130 # 80008000 <etext>
    8000008a:	00006097          	auipc	ra,0x6
    8000008e:	c58080e7          	jalr	-936(ra) # 80005ce2 <panic>

0000000080000092 <freerange>:
{
    80000092:	7179                	addi	sp,sp,-48
    80000094:	f406                	sd	ra,40(sp)
    80000096:	f022                	sd	s0,32(sp)
    80000098:	ec26                	sd	s1,24(sp)
    8000009a:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    8000009c:	6785                	lui	a5,0x1
    8000009e:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    800000a2:	00e504b3          	add	s1,a0,a4
    800000a6:	777d                	lui	a4,0xfffff
    800000a8:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000aa:	94be                	add	s1,s1,a5
    800000ac:	0295e463          	bltu	a1,s1,800000d4 <freerange+0x42>
    800000b0:	e84a                	sd	s2,16(sp)
    800000b2:	e44e                	sd	s3,8(sp)
    800000b4:	e052                	sd	s4,0(sp)
    800000b6:	892e                	mv	s2,a1
    kfree(p);
    800000b8:	8a3a                	mv	s4,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ba:	89be                	mv	s3,a5
    kfree(p);
    800000bc:	01448533          	add	a0,s1,s4
    800000c0:	00000097          	auipc	ra,0x0
    800000c4:	f5c080e7          	jalr	-164(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000c8:	94ce                	add	s1,s1,s3
    800000ca:	fe9979e3          	bgeu	s2,s1,800000bc <freerange+0x2a>
    800000ce:	6942                	ld	s2,16(sp)
    800000d0:	69a2                	ld	s3,8(sp)
    800000d2:	6a02                	ld	s4,0(sp)
}
    800000d4:	70a2                	ld	ra,40(sp)
    800000d6:	7402                	ld	s0,32(sp)
    800000d8:	64e2                	ld	s1,24(sp)
    800000da:	6145                	addi	sp,sp,48
    800000dc:	8082                	ret

00000000800000de <kinit>:
{
    800000de:	1141                	addi	sp,sp,-16
    800000e0:	e406                	sd	ra,8(sp)
    800000e2:	e022                	sd	s0,0(sp)
    800000e4:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000e6:	00008597          	auipc	a1,0x8
    800000ea:	f2a58593          	addi	a1,a1,-214 # 80008010 <etext+0x10>
    800000ee:	00009517          	auipc	a0,0x9
    800000f2:	f4250513          	addi	a0,a0,-190 # 80009030 <kmem>
    800000f6:	00006097          	auipc	ra,0x6
    800000fa:	0d8080e7          	jalr	216(ra) # 800061ce <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fe:	45c5                	li	a1,17
    80000100:	05ee                	slli	a1,a1,0x1b
    80000102:	00026517          	auipc	a0,0x26
    80000106:	13e50513          	addi	a0,a0,318 # 80026240 <end>
    8000010a:	00000097          	auipc	ra,0x0
    8000010e:	f88080e7          	jalr	-120(ra) # 80000092 <freerange>
}
    80000112:	60a2                	ld	ra,8(sp)
    80000114:	6402                	ld	s0,0(sp)
    80000116:	0141                	addi	sp,sp,16
    80000118:	8082                	ret

000000008000011a <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    8000011a:	1101                	addi	sp,sp,-32
    8000011c:	ec06                	sd	ra,24(sp)
    8000011e:	e822                	sd	s0,16(sp)
    80000120:	e426                	sd	s1,8(sp)
    80000122:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000124:	00009497          	auipc	s1,0x9
    80000128:	f0c48493          	addi	s1,s1,-244 # 80009030 <kmem>
    8000012c:	8526                	mv	a0,s1
    8000012e:	00006097          	auipc	ra,0x6
    80000132:	134080e7          	jalr	308(ra) # 80006262 <acquire>
  r = kmem.freelist;
    80000136:	6c84                	ld	s1,24(s1)
  if(r)
    80000138:	c885                	beqz	s1,80000168 <kalloc+0x4e>
    kmem.freelist = r->next;
    8000013a:	609c                	ld	a5,0(s1)
    8000013c:	00009517          	auipc	a0,0x9
    80000140:	ef450513          	addi	a0,a0,-268 # 80009030 <kmem>
    80000144:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000146:	00006097          	auipc	ra,0x6
    8000014a:	1cc080e7          	jalr	460(ra) # 80006312 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014e:	6605                	lui	a2,0x1
    80000150:	4595                	li	a1,5
    80000152:	8526                	mv	a0,s1
    80000154:	00000097          	auipc	ra,0x0
    80000158:	026080e7          	jalr	38(ra) # 8000017a <memset>
  return (void*)r;
}
    8000015c:	8526                	mv	a0,s1
    8000015e:	60e2                	ld	ra,24(sp)
    80000160:	6442                	ld	s0,16(sp)
    80000162:	64a2                	ld	s1,8(sp)
    80000164:	6105                	addi	sp,sp,32
    80000166:	8082                	ret
  release(&kmem.lock);
    80000168:	00009517          	auipc	a0,0x9
    8000016c:	ec850513          	addi	a0,a0,-312 # 80009030 <kmem>
    80000170:	00006097          	auipc	ra,0x6
    80000174:	1a2080e7          	jalr	418(ra) # 80006312 <release>
  if(r)
    80000178:	b7d5                	j	8000015c <kalloc+0x42>

000000008000017a <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    8000017a:	1141                	addi	sp,sp,-16
    8000017c:	e406                	sd	ra,8(sp)
    8000017e:	e022                	sd	s0,0(sp)
    80000180:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000182:	ca19                	beqz	a2,80000198 <memset+0x1e>
    80000184:	87aa                	mv	a5,a0
    80000186:	1602                	slli	a2,a2,0x20
    80000188:	9201                	srli	a2,a2,0x20
    8000018a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    8000018e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000192:	0785                	addi	a5,a5,1
    80000194:	fee79de3          	bne	a5,a4,8000018e <memset+0x14>
  }
  return dst;
}
    80000198:	60a2                	ld	ra,8(sp)
    8000019a:	6402                	ld	s0,0(sp)
    8000019c:	0141                	addi	sp,sp,16
    8000019e:	8082                	ret

00000000800001a0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    800001a0:	1141                	addi	sp,sp,-16
    800001a2:	e406                	sd	ra,8(sp)
    800001a4:	e022                	sd	s0,0(sp)
    800001a6:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001a8:	ca0d                	beqz	a2,800001da <memcmp+0x3a>
    800001aa:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    800001ae:	1682                	slli	a3,a3,0x20
    800001b0:	9281                	srli	a3,a3,0x20
    800001b2:	0685                	addi	a3,a3,1
    800001b4:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001b6:	00054783          	lbu	a5,0(a0)
    800001ba:	0005c703          	lbu	a4,0(a1)
    800001be:	00e79863          	bne	a5,a4,800001ce <memcmp+0x2e>
      return *s1 - *s2;
    s1++, s2++;
    800001c2:	0505                	addi	a0,a0,1
    800001c4:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001c6:	fed518e3          	bne	a0,a3,800001b6 <memcmp+0x16>
  }

  return 0;
    800001ca:	4501                	li	a0,0
    800001cc:	a019                	j	800001d2 <memcmp+0x32>
      return *s1 - *s2;
    800001ce:	40e7853b          	subw	a0,a5,a4
}
    800001d2:	60a2                	ld	ra,8(sp)
    800001d4:	6402                	ld	s0,0(sp)
    800001d6:	0141                	addi	sp,sp,16
    800001d8:	8082                	ret
  return 0;
    800001da:	4501                	li	a0,0
    800001dc:	bfdd                	j	800001d2 <memcmp+0x32>

00000000800001de <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001de:	1141                	addi	sp,sp,-16
    800001e0:	e406                	sd	ra,8(sp)
    800001e2:	e022                	sd	s0,0(sp)
    800001e4:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001e6:	c205                	beqz	a2,80000206 <memmove+0x28>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001e8:	02a5e363          	bltu	a1,a0,8000020e <memmove+0x30>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001ec:	1602                	slli	a2,a2,0x20
    800001ee:	9201                	srli	a2,a2,0x20
    800001f0:	00c587b3          	add	a5,a1,a2
{
    800001f4:	872a                	mv	a4,a0
      *d++ = *s++;
    800001f6:	0585                	addi	a1,a1,1
    800001f8:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffd8dc1>
    800001fa:	fff5c683          	lbu	a3,-1(a1)
    800001fe:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000202:	feb79ae3          	bne	a5,a1,800001f6 <memmove+0x18>

  return dst;
}
    80000206:	60a2                	ld	ra,8(sp)
    80000208:	6402                	ld	s0,0(sp)
    8000020a:	0141                	addi	sp,sp,16
    8000020c:	8082                	ret
  if(s < d && s + n > d){
    8000020e:	02061693          	slli	a3,a2,0x20
    80000212:	9281                	srli	a3,a3,0x20
    80000214:	00d58733          	add	a4,a1,a3
    80000218:	fce57ae3          	bgeu	a0,a4,800001ec <memmove+0xe>
    d += n;
    8000021c:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    8000021e:	fff6079b          	addiw	a5,a2,-1
    80000222:	1782                	slli	a5,a5,0x20
    80000224:	9381                	srli	a5,a5,0x20
    80000226:	fff7c793          	not	a5,a5
    8000022a:	97ba                	add	a5,a5,a4
      *--d = *--s;
    8000022c:	177d                	addi	a4,a4,-1
    8000022e:	16fd                	addi	a3,a3,-1
    80000230:	00074603          	lbu	a2,0(a4)
    80000234:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000238:	fee79ae3          	bne	a5,a4,8000022c <memmove+0x4e>
    8000023c:	b7e9                	j	80000206 <memmove+0x28>

000000008000023e <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    8000023e:	1141                	addi	sp,sp,-16
    80000240:	e406                	sd	ra,8(sp)
    80000242:	e022                	sd	s0,0(sp)
    80000244:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000246:	00000097          	auipc	ra,0x0
    8000024a:	f98080e7          	jalr	-104(ra) # 800001de <memmove>
}
    8000024e:	60a2                	ld	ra,8(sp)
    80000250:	6402                	ld	s0,0(sp)
    80000252:	0141                	addi	sp,sp,16
    80000254:	8082                	ret

0000000080000256 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000256:	1141                	addi	sp,sp,-16
    80000258:	e406                	sd	ra,8(sp)
    8000025a:	e022                	sd	s0,0(sp)
    8000025c:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    8000025e:	ce11                	beqz	a2,8000027a <strncmp+0x24>
    80000260:	00054783          	lbu	a5,0(a0)
    80000264:	cf89                	beqz	a5,8000027e <strncmp+0x28>
    80000266:	0005c703          	lbu	a4,0(a1)
    8000026a:	00f71a63          	bne	a4,a5,8000027e <strncmp+0x28>
    n--, p++, q++;
    8000026e:	367d                	addiw	a2,a2,-1
    80000270:	0505                	addi	a0,a0,1
    80000272:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000274:	f675                	bnez	a2,80000260 <strncmp+0xa>
  if(n == 0)
    return 0;
    80000276:	4501                	li	a0,0
    80000278:	a801                	j	80000288 <strncmp+0x32>
    8000027a:	4501                	li	a0,0
    8000027c:	a031                	j	80000288 <strncmp+0x32>
  return (uchar)*p - (uchar)*q;
    8000027e:	00054503          	lbu	a0,0(a0)
    80000282:	0005c783          	lbu	a5,0(a1)
    80000286:	9d1d                	subw	a0,a0,a5
}
    80000288:	60a2                	ld	ra,8(sp)
    8000028a:	6402                	ld	s0,0(sp)
    8000028c:	0141                	addi	sp,sp,16
    8000028e:	8082                	ret

0000000080000290 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000290:	1141                	addi	sp,sp,-16
    80000292:	e406                	sd	ra,8(sp)
    80000294:	e022                	sd	s0,0(sp)
    80000296:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000298:	87aa                	mv	a5,a0
    8000029a:	86b2                	mv	a3,a2
    8000029c:	367d                	addiw	a2,a2,-1
    8000029e:	02d05563          	blez	a3,800002c8 <strncpy+0x38>
    800002a2:	0785                	addi	a5,a5,1
    800002a4:	0005c703          	lbu	a4,0(a1)
    800002a8:	fee78fa3          	sb	a4,-1(a5)
    800002ac:	0585                	addi	a1,a1,1
    800002ae:	f775                	bnez	a4,8000029a <strncpy+0xa>
    ;
  while(n-- > 0)
    800002b0:	873e                	mv	a4,a5
    800002b2:	00c05b63          	blez	a2,800002c8 <strncpy+0x38>
    800002b6:	9fb5                	addw	a5,a5,a3
    800002b8:	37fd                	addiw	a5,a5,-1
    *s++ = 0;
    800002ba:	0705                	addi	a4,a4,1
    800002bc:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    800002c0:	40e786bb          	subw	a3,a5,a4
    800002c4:	fed04be3          	bgtz	a3,800002ba <strncpy+0x2a>
  return os;
}
    800002c8:	60a2                	ld	ra,8(sp)
    800002ca:	6402                	ld	s0,0(sp)
    800002cc:	0141                	addi	sp,sp,16
    800002ce:	8082                	ret

00000000800002d0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002d0:	1141                	addi	sp,sp,-16
    800002d2:	e406                	sd	ra,8(sp)
    800002d4:	e022                	sd	s0,0(sp)
    800002d6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002d8:	02c05363          	blez	a2,800002fe <safestrcpy+0x2e>
    800002dc:	fff6069b          	addiw	a3,a2,-1
    800002e0:	1682                	slli	a3,a3,0x20
    800002e2:	9281                	srli	a3,a3,0x20
    800002e4:	96ae                	add	a3,a3,a1
    800002e6:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002e8:	00d58963          	beq	a1,a3,800002fa <safestrcpy+0x2a>
    800002ec:	0585                	addi	a1,a1,1
    800002ee:	0785                	addi	a5,a5,1
    800002f0:	fff5c703          	lbu	a4,-1(a1)
    800002f4:	fee78fa3          	sb	a4,-1(a5)
    800002f8:	fb65                	bnez	a4,800002e8 <safestrcpy+0x18>
    ;
  *s = 0;
    800002fa:	00078023          	sb	zero,0(a5)
  return os;
}
    800002fe:	60a2                	ld	ra,8(sp)
    80000300:	6402                	ld	s0,0(sp)
    80000302:	0141                	addi	sp,sp,16
    80000304:	8082                	ret

0000000080000306 <strlen>:

int
strlen(const char *s)
{
    80000306:	1141                	addi	sp,sp,-16
    80000308:	e406                	sd	ra,8(sp)
    8000030a:	e022                	sd	s0,0(sp)
    8000030c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    8000030e:	00054783          	lbu	a5,0(a0)
    80000312:	cf99                	beqz	a5,80000330 <strlen+0x2a>
    80000314:	0505                	addi	a0,a0,1
    80000316:	87aa                	mv	a5,a0
    80000318:	86be                	mv	a3,a5
    8000031a:	0785                	addi	a5,a5,1
    8000031c:	fff7c703          	lbu	a4,-1(a5)
    80000320:	ff65                	bnez	a4,80000318 <strlen+0x12>
    80000322:	40a6853b          	subw	a0,a3,a0
    80000326:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    80000328:	60a2                	ld	ra,8(sp)
    8000032a:	6402                	ld	s0,0(sp)
    8000032c:	0141                	addi	sp,sp,16
    8000032e:	8082                	ret
  for(n = 0; s[n]; n++)
    80000330:	4501                	li	a0,0
    80000332:	bfdd                	j	80000328 <strlen+0x22>

0000000080000334 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000334:	1141                	addi	sp,sp,-16
    80000336:	e406                	sd	ra,8(sp)
    80000338:	e022                	sd	s0,0(sp)
    8000033a:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    8000033c:	00001097          	auipc	ra,0x1
    80000340:	b04080e7          	jalr	-1276(ra) # 80000e40 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000344:	00009717          	auipc	a4,0x9
    80000348:	cbc70713          	addi	a4,a4,-836 # 80009000 <started>
  if(cpuid() == 0){
    8000034c:	c139                	beqz	a0,80000392 <main+0x5e>
    while(started == 0)
    8000034e:	431c                	lw	a5,0(a4)
    80000350:	2781                	sext.w	a5,a5
    80000352:	dff5                	beqz	a5,8000034e <main+0x1a>
      ;
    __sync_synchronize();
    80000354:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    80000358:	00001097          	auipc	ra,0x1
    8000035c:	ae8080e7          	jalr	-1304(ra) # 80000e40 <cpuid>
    80000360:	85aa                	mv	a1,a0
    80000362:	00008517          	auipc	a0,0x8
    80000366:	cd650513          	addi	a0,a0,-810 # 80008038 <etext+0x38>
    8000036a:	00006097          	auipc	ra,0x6
    8000036e:	9c2080e7          	jalr	-1598(ra) # 80005d2c <printf>
    kvminithart();    // turn on paging
    80000372:	00000097          	auipc	ra,0x0
    80000376:	0d8080e7          	jalr	216(ra) # 8000044a <kvminithart>
    trapinithart();   // install kernel trap vector
    8000037a:	00001097          	auipc	ra,0x1
    8000037e:	74c080e7          	jalr	1868(ra) # 80001ac6 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000382:	00005097          	auipc	ra,0x5
    80000386:	e62080e7          	jalr	-414(ra) # 800051e4 <plicinithart>
  }

  scheduler();        
    8000038a:	00001097          	auipc	ra,0x1
    8000038e:	ffe080e7          	jalr	-2(ra) # 80001388 <scheduler>
    consoleinit();
    80000392:	00006097          	auipc	ra,0x6
    80000396:	872080e7          	jalr	-1934(ra) # 80005c04 <consoleinit>
    printfinit();
    8000039a:	00006097          	auipc	ra,0x6
    8000039e:	b9c080e7          	jalr	-1124(ra) # 80005f36 <printfinit>
    printf("\n");
    800003a2:	00008517          	auipc	a0,0x8
    800003a6:	c7650513          	addi	a0,a0,-906 # 80008018 <etext+0x18>
    800003aa:	00006097          	auipc	ra,0x6
    800003ae:	982080e7          	jalr	-1662(ra) # 80005d2c <printf>
    printf("xv6 kernel is booting\n");
    800003b2:	00008517          	auipc	a0,0x8
    800003b6:	c6e50513          	addi	a0,a0,-914 # 80008020 <etext+0x20>
    800003ba:	00006097          	auipc	ra,0x6
    800003be:	972080e7          	jalr	-1678(ra) # 80005d2c <printf>
    printf("\n");
    800003c2:	00008517          	auipc	a0,0x8
    800003c6:	c5650513          	addi	a0,a0,-938 # 80008018 <etext+0x18>
    800003ca:	00006097          	auipc	ra,0x6
    800003ce:	962080e7          	jalr	-1694(ra) # 80005d2c <printf>
    kinit();         // physical page allocator
    800003d2:	00000097          	auipc	ra,0x0
    800003d6:	d0c080e7          	jalr	-756(ra) # 800000de <kinit>
    kvminit();       // create kernel page table
    800003da:	00000097          	auipc	ra,0x0
    800003de:	326080e7          	jalr	806(ra) # 80000700 <kvminit>
    kvminithart();   // turn on paging
    800003e2:	00000097          	auipc	ra,0x0
    800003e6:	068080e7          	jalr	104(ra) # 8000044a <kvminithart>
    procinit();      // process table
    800003ea:	00001097          	auipc	ra,0x1
    800003ee:	99e080e7          	jalr	-1634(ra) # 80000d88 <procinit>
    trapinit();      // trap vectors
    800003f2:	00001097          	auipc	ra,0x1
    800003f6:	6ac080e7          	jalr	1708(ra) # 80001a9e <trapinit>
    trapinithart();  // install kernel trap vector
    800003fa:	00001097          	auipc	ra,0x1
    800003fe:	6cc080e7          	jalr	1740(ra) # 80001ac6 <trapinithart>
    plicinit();      // set up interrupt controller
    80000402:	00005097          	auipc	ra,0x5
    80000406:	dc8080e7          	jalr	-568(ra) # 800051ca <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    8000040a:	00005097          	auipc	ra,0x5
    8000040e:	dda080e7          	jalr	-550(ra) # 800051e4 <plicinithart>
    binit();         // buffer cache
    80000412:	00002097          	auipc	ra,0x2
    80000416:	eaa080e7          	jalr	-342(ra) # 800022bc <binit>
    iinit();         // inode table
    8000041a:	00002097          	auipc	ra,0x2
    8000041e:	518080e7          	jalr	1304(ra) # 80002932 <iinit>
    fileinit();      // file table
    80000422:	00003097          	auipc	ra,0x3
    80000426:	4e2080e7          	jalr	1250(ra) # 80003904 <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000042a:	00005097          	auipc	ra,0x5
    8000042e:	eda080e7          	jalr	-294(ra) # 80005304 <virtio_disk_init>
    userinit();      // first user process
    80000432:	00001097          	auipc	ra,0x1
    80000436:	d1a080e7          	jalr	-742(ra) # 8000114c <userinit>
    __sync_synchronize();
    8000043a:	0330000f          	fence	rw,rw
    started = 1;
    8000043e:	4785                	li	a5,1
    80000440:	00009717          	auipc	a4,0x9
    80000444:	bcf72023          	sw	a5,-1088(a4) # 80009000 <started>
    80000448:	b789                	j	8000038a <main+0x56>

000000008000044a <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    8000044a:	1141                	addi	sp,sp,-16
    8000044c:	e406                	sd	ra,8(sp)
    8000044e:	e022                	sd	s0,0(sp)
    80000450:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    80000452:	00009797          	auipc	a5,0x9
    80000456:	bb67b783          	ld	a5,-1098(a5) # 80009008 <kernel_pagetable>
    8000045a:	83b1                	srli	a5,a5,0xc
    8000045c:	577d                	li	a4,-1
    8000045e:	177e                	slli	a4,a4,0x3f
    80000460:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    80000462:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000466:	12000073          	sfence.vma
  sfence_vma();
}
    8000046a:	60a2                	ld	ra,8(sp)
    8000046c:	6402                	ld	s0,0(sp)
    8000046e:	0141                	addi	sp,sp,16
    80000470:	8082                	ret

0000000080000472 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000472:	7139                	addi	sp,sp,-64
    80000474:	fc06                	sd	ra,56(sp)
    80000476:	f822                	sd	s0,48(sp)
    80000478:	f426                	sd	s1,40(sp)
    8000047a:	f04a                	sd	s2,32(sp)
    8000047c:	ec4e                	sd	s3,24(sp)
    8000047e:	e852                	sd	s4,16(sp)
    80000480:	e456                	sd	s5,8(sp)
    80000482:	e05a                	sd	s6,0(sp)
    80000484:	0080                	addi	s0,sp,64
    80000486:	84aa                	mv	s1,a0
    80000488:	89ae                	mv	s3,a1
    8000048a:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    8000048c:	57fd                	li	a5,-1
    8000048e:	83e9                	srli	a5,a5,0x1a
    80000490:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000492:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000494:	04b7e263          	bltu	a5,a1,800004d8 <walk+0x66>
    pte_t *pte = &pagetable[PX(level, va)];
    80000498:	0149d933          	srl	s2,s3,s4
    8000049c:	1ff97913          	andi	s2,s2,511
    800004a0:	090e                	slli	s2,s2,0x3
    800004a2:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004a4:	00093483          	ld	s1,0(s2)
    800004a8:	0014f793          	andi	a5,s1,1
    800004ac:	cf95                	beqz	a5,800004e8 <walk+0x76>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004ae:	80a9                	srli	s1,s1,0xa
    800004b0:	04b2                	slli	s1,s1,0xc
  for(int level = 2; level > 0; level--) {
    800004b2:	3a5d                	addiw	s4,s4,-9
    800004b4:	ff6a12e3          	bne	s4,s6,80000498 <walk+0x26>
        return 0;
      memset(pagetable, 0, PGSIZE);
      *pte = PA2PTE(pagetable) | PTE_V;
    }
  }
  return &pagetable[PX(0, va)];
    800004b8:	00c9d513          	srli	a0,s3,0xc
    800004bc:	1ff57513          	andi	a0,a0,511
    800004c0:	050e                	slli	a0,a0,0x3
    800004c2:	9526                	add	a0,a0,s1
}
    800004c4:	70e2                	ld	ra,56(sp)
    800004c6:	7442                	ld	s0,48(sp)
    800004c8:	74a2                	ld	s1,40(sp)
    800004ca:	7902                	ld	s2,32(sp)
    800004cc:	69e2                	ld	s3,24(sp)
    800004ce:	6a42                	ld	s4,16(sp)
    800004d0:	6aa2                	ld	s5,8(sp)
    800004d2:	6b02                	ld	s6,0(sp)
    800004d4:	6121                	addi	sp,sp,64
    800004d6:	8082                	ret
    panic("walk");
    800004d8:	00008517          	auipc	a0,0x8
    800004dc:	b7850513          	addi	a0,a0,-1160 # 80008050 <etext+0x50>
    800004e0:	00006097          	auipc	ra,0x6
    800004e4:	802080e7          	jalr	-2046(ra) # 80005ce2 <panic>
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800004e8:	020a8663          	beqz	s5,80000514 <walk+0xa2>
    800004ec:	00000097          	auipc	ra,0x0
    800004f0:	c2e080e7          	jalr	-978(ra) # 8000011a <kalloc>
    800004f4:	84aa                	mv	s1,a0
    800004f6:	d579                	beqz	a0,800004c4 <walk+0x52>
      memset(pagetable, 0, PGSIZE);
    800004f8:	6605                	lui	a2,0x1
    800004fa:	4581                	li	a1,0
    800004fc:	00000097          	auipc	ra,0x0
    80000500:	c7e080e7          	jalr	-898(ra) # 8000017a <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000504:	00c4d793          	srli	a5,s1,0xc
    80000508:	07aa                	slli	a5,a5,0xa
    8000050a:	0017e793          	ori	a5,a5,1
    8000050e:	00f93023          	sd	a5,0(s2)
    80000512:	b745                	j	800004b2 <walk+0x40>
        return 0;
    80000514:	4501                	li	a0,0
    80000516:	b77d                	j	800004c4 <walk+0x52>

0000000080000518 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000518:	57fd                	li	a5,-1
    8000051a:	83e9                	srli	a5,a5,0x1a
    8000051c:	00b7f463          	bgeu	a5,a1,80000524 <walkaddr+0xc>
    return 0;
    80000520:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000522:	8082                	ret
{
    80000524:	1141                	addi	sp,sp,-16
    80000526:	e406                	sd	ra,8(sp)
    80000528:	e022                	sd	s0,0(sp)
    8000052a:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000052c:	4601                	li	a2,0
    8000052e:	00000097          	auipc	ra,0x0
    80000532:	f44080e7          	jalr	-188(ra) # 80000472 <walk>
  if(pte == 0)
    80000536:	c105                	beqz	a0,80000556 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000538:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000053a:	0117f693          	andi	a3,a5,17
    8000053e:	4745                	li	a4,17
    return 0;
    80000540:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000542:	00e68663          	beq	a3,a4,8000054e <walkaddr+0x36>
}
    80000546:	60a2                	ld	ra,8(sp)
    80000548:	6402                	ld	s0,0(sp)
    8000054a:	0141                	addi	sp,sp,16
    8000054c:	8082                	ret
  pa = PTE2PA(*pte);
    8000054e:	83a9                	srli	a5,a5,0xa
    80000550:	00c79513          	slli	a0,a5,0xc
  return pa;
    80000554:	bfcd                	j	80000546 <walkaddr+0x2e>
    return 0;
    80000556:	4501                	li	a0,0
    80000558:	b7fd                	j	80000546 <walkaddr+0x2e>

000000008000055a <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000055a:	715d                	addi	sp,sp,-80
    8000055c:	e486                	sd	ra,72(sp)
    8000055e:	e0a2                	sd	s0,64(sp)
    80000560:	fc26                	sd	s1,56(sp)
    80000562:	f84a                	sd	s2,48(sp)
    80000564:	f44e                	sd	s3,40(sp)
    80000566:	f052                	sd	s4,32(sp)
    80000568:	ec56                	sd	s5,24(sp)
    8000056a:	e85a                	sd	s6,16(sp)
    8000056c:	e45e                	sd	s7,8(sp)
    8000056e:	e062                	sd	s8,0(sp)
    80000570:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    80000572:	ca21                	beqz	a2,800005c2 <mappages+0x68>
    80000574:	8aaa                	mv	s5,a0
    80000576:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    80000578:	777d                	lui	a4,0xfffff
    8000057a:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    8000057e:	fff58993          	addi	s3,a1,-1
    80000582:	99b2                	add	s3,s3,a2
    80000584:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    80000588:	893e                	mv	s2,a5
    8000058a:	40f68a33          	sub	s4,a3,a5
  for(;;){
    if((pte = walk(pagetable, a, 1)) == 0)
    8000058e:	4b85                	li	s7,1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80000590:	6c05                	lui	s8,0x1
    80000592:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    80000596:	865e                	mv	a2,s7
    80000598:	85ca                	mv	a1,s2
    8000059a:	8556                	mv	a0,s5
    8000059c:	00000097          	auipc	ra,0x0
    800005a0:	ed6080e7          	jalr	-298(ra) # 80000472 <walk>
    800005a4:	cd1d                	beqz	a0,800005e2 <mappages+0x88>
    if(*pte & PTE_V)
    800005a6:	611c                	ld	a5,0(a0)
    800005a8:	8b85                	andi	a5,a5,1
    800005aa:	e785                	bnez	a5,800005d2 <mappages+0x78>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800005ac:	80b1                	srli	s1,s1,0xc
    800005ae:	04aa                	slli	s1,s1,0xa
    800005b0:	0164e4b3          	or	s1,s1,s6
    800005b4:	0014e493          	ori	s1,s1,1
    800005b8:	e104                	sd	s1,0(a0)
    if(a == last)
    800005ba:	05390163          	beq	s2,s3,800005fc <mappages+0xa2>
    a += PGSIZE;
    800005be:	9962                	add	s2,s2,s8
    if((pte = walk(pagetable, a, 1)) == 0)
    800005c0:	bfc9                	j	80000592 <mappages+0x38>
    panic("mappages: size");
    800005c2:	00008517          	auipc	a0,0x8
    800005c6:	a9650513          	addi	a0,a0,-1386 # 80008058 <etext+0x58>
    800005ca:	00005097          	auipc	ra,0x5
    800005ce:	718080e7          	jalr	1816(ra) # 80005ce2 <panic>
      panic("mappages: remap");
    800005d2:	00008517          	auipc	a0,0x8
    800005d6:	a9650513          	addi	a0,a0,-1386 # 80008068 <etext+0x68>
    800005da:	00005097          	auipc	ra,0x5
    800005de:	708080e7          	jalr	1800(ra) # 80005ce2 <panic>
      return -1;
    800005e2:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800005e4:	60a6                	ld	ra,72(sp)
    800005e6:	6406                	ld	s0,64(sp)
    800005e8:	74e2                	ld	s1,56(sp)
    800005ea:	7942                	ld	s2,48(sp)
    800005ec:	79a2                	ld	s3,40(sp)
    800005ee:	7a02                	ld	s4,32(sp)
    800005f0:	6ae2                	ld	s5,24(sp)
    800005f2:	6b42                	ld	s6,16(sp)
    800005f4:	6ba2                	ld	s7,8(sp)
    800005f6:	6c02                	ld	s8,0(sp)
    800005f8:	6161                	addi	sp,sp,80
    800005fa:	8082                	ret
  return 0;
    800005fc:	4501                	li	a0,0
    800005fe:	b7dd                	j	800005e4 <mappages+0x8a>

0000000080000600 <kvmmap>:
{
    80000600:	1141                	addi	sp,sp,-16
    80000602:	e406                	sd	ra,8(sp)
    80000604:	e022                	sd	s0,0(sp)
    80000606:	0800                	addi	s0,sp,16
    80000608:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    8000060a:	86b2                	mv	a3,a2
    8000060c:	863e                	mv	a2,a5
    8000060e:	00000097          	auipc	ra,0x0
    80000612:	f4c080e7          	jalr	-180(ra) # 8000055a <mappages>
    80000616:	e509                	bnez	a0,80000620 <kvmmap+0x20>
}
    80000618:	60a2                	ld	ra,8(sp)
    8000061a:	6402                	ld	s0,0(sp)
    8000061c:	0141                	addi	sp,sp,16
    8000061e:	8082                	ret
    panic("kvmmap");
    80000620:	00008517          	auipc	a0,0x8
    80000624:	a5850513          	addi	a0,a0,-1448 # 80008078 <etext+0x78>
    80000628:	00005097          	auipc	ra,0x5
    8000062c:	6ba080e7          	jalr	1722(ra) # 80005ce2 <panic>

0000000080000630 <kvmmake>:
{
    80000630:	1101                	addi	sp,sp,-32
    80000632:	ec06                	sd	ra,24(sp)
    80000634:	e822                	sd	s0,16(sp)
    80000636:	e426                	sd	s1,8(sp)
    80000638:	e04a                	sd	s2,0(sp)
    8000063a:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    8000063c:	00000097          	auipc	ra,0x0
    80000640:	ade080e7          	jalr	-1314(ra) # 8000011a <kalloc>
    80000644:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000646:	6605                	lui	a2,0x1
    80000648:	4581                	li	a1,0
    8000064a:	00000097          	auipc	ra,0x0
    8000064e:	b30080e7          	jalr	-1232(ra) # 8000017a <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000652:	4719                	li	a4,6
    80000654:	6685                	lui	a3,0x1
    80000656:	10000637          	lui	a2,0x10000
    8000065a:	85b2                	mv	a1,a2
    8000065c:	8526                	mv	a0,s1
    8000065e:	00000097          	auipc	ra,0x0
    80000662:	fa2080e7          	jalr	-94(ra) # 80000600 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80000666:	4719                	li	a4,6
    80000668:	6685                	lui	a3,0x1
    8000066a:	10001637          	lui	a2,0x10001
    8000066e:	85b2                	mv	a1,a2
    80000670:	8526                	mv	a0,s1
    80000672:	00000097          	auipc	ra,0x0
    80000676:	f8e080e7          	jalr	-114(ra) # 80000600 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    8000067a:	4719                	li	a4,6
    8000067c:	004006b7          	lui	a3,0x400
    80000680:	0c000637          	lui	a2,0xc000
    80000684:	85b2                	mv	a1,a2
    80000686:	8526                	mv	a0,s1
    80000688:	00000097          	auipc	ra,0x0
    8000068c:	f78080e7          	jalr	-136(ra) # 80000600 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80000690:	00008917          	auipc	s2,0x8
    80000694:	97090913          	addi	s2,s2,-1680 # 80008000 <etext>
    80000698:	4729                	li	a4,10
    8000069a:	80008697          	auipc	a3,0x80008
    8000069e:	96668693          	addi	a3,a3,-1690 # 8000 <_entry-0x7fff8000>
    800006a2:	4605                	li	a2,1
    800006a4:	067e                	slli	a2,a2,0x1f
    800006a6:	85b2                	mv	a1,a2
    800006a8:	8526                	mv	a0,s1
    800006aa:	00000097          	auipc	ra,0x0
    800006ae:	f56080e7          	jalr	-170(ra) # 80000600 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800006b2:	4719                	li	a4,6
    800006b4:	46c5                	li	a3,17
    800006b6:	06ee                	slli	a3,a3,0x1b
    800006b8:	412686b3          	sub	a3,a3,s2
    800006bc:	864a                	mv	a2,s2
    800006be:	85ca                	mv	a1,s2
    800006c0:	8526                	mv	a0,s1
    800006c2:	00000097          	auipc	ra,0x0
    800006c6:	f3e080e7          	jalr	-194(ra) # 80000600 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006ca:	4729                	li	a4,10
    800006cc:	6685                	lui	a3,0x1
    800006ce:	00007617          	auipc	a2,0x7
    800006d2:	93260613          	addi	a2,a2,-1742 # 80007000 <_trampoline>
    800006d6:	040005b7          	lui	a1,0x4000
    800006da:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800006dc:	05b2                	slli	a1,a1,0xc
    800006de:	8526                	mv	a0,s1
    800006e0:	00000097          	auipc	ra,0x0
    800006e4:	f20080e7          	jalr	-224(ra) # 80000600 <kvmmap>
  proc_mapstacks(kpgtbl);
    800006e8:	8526                	mv	a0,s1
    800006ea:	00000097          	auipc	ra,0x0
    800006ee:	5f4080e7          	jalr	1524(ra) # 80000cde <proc_mapstacks>
}
    800006f2:	8526                	mv	a0,s1
    800006f4:	60e2                	ld	ra,24(sp)
    800006f6:	6442                	ld	s0,16(sp)
    800006f8:	64a2                	ld	s1,8(sp)
    800006fa:	6902                	ld	s2,0(sp)
    800006fc:	6105                	addi	sp,sp,32
    800006fe:	8082                	ret

0000000080000700 <kvminit>:
{
    80000700:	1141                	addi	sp,sp,-16
    80000702:	e406                	sd	ra,8(sp)
    80000704:	e022                	sd	s0,0(sp)
    80000706:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80000708:	00000097          	auipc	ra,0x0
    8000070c:	f28080e7          	jalr	-216(ra) # 80000630 <kvmmake>
    80000710:	00009797          	auipc	a5,0x9
    80000714:	8ea7bc23          	sd	a0,-1800(a5) # 80009008 <kernel_pagetable>
}
    80000718:	60a2                	ld	ra,8(sp)
    8000071a:	6402                	ld	s0,0(sp)
    8000071c:	0141                	addi	sp,sp,16
    8000071e:	8082                	ret

0000000080000720 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000720:	715d                	addi	sp,sp,-80
    80000722:	e486                	sd	ra,72(sp)
    80000724:	e0a2                	sd	s0,64(sp)
    80000726:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000728:	03459793          	slli	a5,a1,0x34
    8000072c:	e39d                	bnez	a5,80000752 <uvmunmap+0x32>
    8000072e:	f84a                	sd	s2,48(sp)
    80000730:	f44e                	sd	s3,40(sp)
    80000732:	f052                	sd	s4,32(sp)
    80000734:	ec56                	sd	s5,24(sp)
    80000736:	e85a                	sd	s6,16(sp)
    80000738:	e45e                	sd	s7,8(sp)
    8000073a:	8a2a                	mv	s4,a0
    8000073c:	892e                	mv	s2,a1
    8000073e:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000740:	0632                	slli	a2,a2,0xc
    80000742:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000746:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000748:	6b05                	lui	s6,0x1
    8000074a:	0935fb63          	bgeu	a1,s3,800007e0 <uvmunmap+0xc0>
    8000074e:	fc26                	sd	s1,56(sp)
    80000750:	a8a9                	j	800007aa <uvmunmap+0x8a>
    80000752:	fc26                	sd	s1,56(sp)
    80000754:	f84a                	sd	s2,48(sp)
    80000756:	f44e                	sd	s3,40(sp)
    80000758:	f052                	sd	s4,32(sp)
    8000075a:	ec56                	sd	s5,24(sp)
    8000075c:	e85a                	sd	s6,16(sp)
    8000075e:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    80000760:	00008517          	auipc	a0,0x8
    80000764:	92050513          	addi	a0,a0,-1760 # 80008080 <etext+0x80>
    80000768:	00005097          	auipc	ra,0x5
    8000076c:	57a080e7          	jalr	1402(ra) # 80005ce2 <panic>
      panic("uvmunmap: walk");
    80000770:	00008517          	auipc	a0,0x8
    80000774:	92850513          	addi	a0,a0,-1752 # 80008098 <etext+0x98>
    80000778:	00005097          	auipc	ra,0x5
    8000077c:	56a080e7          	jalr	1386(ra) # 80005ce2 <panic>
      panic("uvmunmap: not mapped");
    80000780:	00008517          	auipc	a0,0x8
    80000784:	92850513          	addi	a0,a0,-1752 # 800080a8 <etext+0xa8>
    80000788:	00005097          	auipc	ra,0x5
    8000078c:	55a080e7          	jalr	1370(ra) # 80005ce2 <panic>
      panic("uvmunmap: not a leaf");
    80000790:	00008517          	auipc	a0,0x8
    80000794:	93050513          	addi	a0,a0,-1744 # 800080c0 <etext+0xc0>
    80000798:	00005097          	auipc	ra,0x5
    8000079c:	54a080e7          	jalr	1354(ra) # 80005ce2 <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    800007a0:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800007a4:	995a                	add	s2,s2,s6
    800007a6:	03397c63          	bgeu	s2,s3,800007de <uvmunmap+0xbe>
    if((pte = walk(pagetable, a, 0)) == 0)
    800007aa:	4601                	li	a2,0
    800007ac:	85ca                	mv	a1,s2
    800007ae:	8552                	mv	a0,s4
    800007b0:	00000097          	auipc	ra,0x0
    800007b4:	cc2080e7          	jalr	-830(ra) # 80000472 <walk>
    800007b8:	84aa                	mv	s1,a0
    800007ba:	d95d                	beqz	a0,80000770 <uvmunmap+0x50>
    if((*pte & PTE_V) == 0)
    800007bc:	6108                	ld	a0,0(a0)
    800007be:	00157793          	andi	a5,a0,1
    800007c2:	dfdd                	beqz	a5,80000780 <uvmunmap+0x60>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007c4:	3ff57793          	andi	a5,a0,1023
    800007c8:	fd7784e3          	beq	a5,s7,80000790 <uvmunmap+0x70>
    if(do_free){
    800007cc:	fc0a8ae3          	beqz	s5,800007a0 <uvmunmap+0x80>
      uint64 pa = PTE2PA(*pte);
    800007d0:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800007d2:	0532                	slli	a0,a0,0xc
    800007d4:	00000097          	auipc	ra,0x0
    800007d8:	848080e7          	jalr	-1976(ra) # 8000001c <kfree>
    800007dc:	b7d1                	j	800007a0 <uvmunmap+0x80>
    800007de:	74e2                	ld	s1,56(sp)
    800007e0:	7942                	ld	s2,48(sp)
    800007e2:	79a2                	ld	s3,40(sp)
    800007e4:	7a02                	ld	s4,32(sp)
    800007e6:	6ae2                	ld	s5,24(sp)
    800007e8:	6b42                	ld	s6,16(sp)
    800007ea:	6ba2                	ld	s7,8(sp)
  }
}
    800007ec:	60a6                	ld	ra,72(sp)
    800007ee:	6406                	ld	s0,64(sp)
    800007f0:	6161                	addi	sp,sp,80
    800007f2:	8082                	ret

00000000800007f4 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007f4:	1101                	addi	sp,sp,-32
    800007f6:	ec06                	sd	ra,24(sp)
    800007f8:	e822                	sd	s0,16(sp)
    800007fa:	e426                	sd	s1,8(sp)
    800007fc:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800007fe:	00000097          	auipc	ra,0x0
    80000802:	91c080e7          	jalr	-1764(ra) # 8000011a <kalloc>
    80000806:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000808:	c519                	beqz	a0,80000816 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    8000080a:	6605                	lui	a2,0x1
    8000080c:	4581                	li	a1,0
    8000080e:	00000097          	auipc	ra,0x0
    80000812:	96c080e7          	jalr	-1684(ra) # 8000017a <memset>
  return pagetable;
}
    80000816:	8526                	mv	a0,s1
    80000818:	60e2                	ld	ra,24(sp)
    8000081a:	6442                	ld	s0,16(sp)
    8000081c:	64a2                	ld	s1,8(sp)
    8000081e:	6105                	addi	sp,sp,32
    80000820:	8082                	ret

0000000080000822 <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    80000822:	7179                	addi	sp,sp,-48
    80000824:	f406                	sd	ra,40(sp)
    80000826:	f022                	sd	s0,32(sp)
    80000828:	ec26                	sd	s1,24(sp)
    8000082a:	e84a                	sd	s2,16(sp)
    8000082c:	e44e                	sd	s3,8(sp)
    8000082e:	e052                	sd	s4,0(sp)
    80000830:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000832:	6785                	lui	a5,0x1
    80000834:	04f67863          	bgeu	a2,a5,80000884 <uvminit+0x62>
    80000838:	8a2a                	mv	s4,a0
    8000083a:	89ae                	mv	s3,a1
    8000083c:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    8000083e:	00000097          	auipc	ra,0x0
    80000842:	8dc080e7          	jalr	-1828(ra) # 8000011a <kalloc>
    80000846:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000848:	6605                	lui	a2,0x1
    8000084a:	4581                	li	a1,0
    8000084c:	00000097          	auipc	ra,0x0
    80000850:	92e080e7          	jalr	-1746(ra) # 8000017a <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000854:	4779                	li	a4,30
    80000856:	86ca                	mv	a3,s2
    80000858:	6605                	lui	a2,0x1
    8000085a:	4581                	li	a1,0
    8000085c:	8552                	mv	a0,s4
    8000085e:	00000097          	auipc	ra,0x0
    80000862:	cfc080e7          	jalr	-772(ra) # 8000055a <mappages>
  memmove(mem, src, sz);
    80000866:	8626                	mv	a2,s1
    80000868:	85ce                	mv	a1,s3
    8000086a:	854a                	mv	a0,s2
    8000086c:	00000097          	auipc	ra,0x0
    80000870:	972080e7          	jalr	-1678(ra) # 800001de <memmove>
}
    80000874:	70a2                	ld	ra,40(sp)
    80000876:	7402                	ld	s0,32(sp)
    80000878:	64e2                	ld	s1,24(sp)
    8000087a:	6942                	ld	s2,16(sp)
    8000087c:	69a2                	ld	s3,8(sp)
    8000087e:	6a02                	ld	s4,0(sp)
    80000880:	6145                	addi	sp,sp,48
    80000882:	8082                	ret
    panic("inituvm: more than a page");
    80000884:	00008517          	auipc	a0,0x8
    80000888:	85450513          	addi	a0,a0,-1964 # 800080d8 <etext+0xd8>
    8000088c:	00005097          	auipc	ra,0x5
    80000890:	456080e7          	jalr	1110(ra) # 80005ce2 <panic>

0000000080000894 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000894:	1101                	addi	sp,sp,-32
    80000896:	ec06                	sd	ra,24(sp)
    80000898:	e822                	sd	s0,16(sp)
    8000089a:	e426                	sd	s1,8(sp)
    8000089c:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    8000089e:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800008a0:	00b67d63          	bgeu	a2,a1,800008ba <uvmdealloc+0x26>
    800008a4:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800008a6:	6785                	lui	a5,0x1
    800008a8:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008aa:	00f60733          	add	a4,a2,a5
    800008ae:	76fd                	lui	a3,0xfffff
    800008b0:	8f75                	and	a4,a4,a3
    800008b2:	97ae                	add	a5,a5,a1
    800008b4:	8ff5                	and	a5,a5,a3
    800008b6:	00f76863          	bltu	a4,a5,800008c6 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800008ba:	8526                	mv	a0,s1
    800008bc:	60e2                	ld	ra,24(sp)
    800008be:	6442                	ld	s0,16(sp)
    800008c0:	64a2                	ld	s1,8(sp)
    800008c2:	6105                	addi	sp,sp,32
    800008c4:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008c6:	8f99                	sub	a5,a5,a4
    800008c8:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008ca:	4685                	li	a3,1
    800008cc:	0007861b          	sext.w	a2,a5
    800008d0:	85ba                	mv	a1,a4
    800008d2:	00000097          	auipc	ra,0x0
    800008d6:	e4e080e7          	jalr	-434(ra) # 80000720 <uvmunmap>
    800008da:	b7c5                	j	800008ba <uvmdealloc+0x26>

00000000800008dc <uvmalloc>:
  if(newsz < oldsz)
    800008dc:	0ab66e63          	bltu	a2,a1,80000998 <uvmalloc+0xbc>
{
    800008e0:	715d                	addi	sp,sp,-80
    800008e2:	e486                	sd	ra,72(sp)
    800008e4:	e0a2                	sd	s0,64(sp)
    800008e6:	f052                	sd	s4,32(sp)
    800008e8:	ec56                	sd	s5,24(sp)
    800008ea:	e85a                	sd	s6,16(sp)
    800008ec:	0880                	addi	s0,sp,80
    800008ee:	8b2a                	mv	s6,a0
    800008f0:	8ab2                	mv	s5,a2
  oldsz = PGROUNDUP(oldsz);
    800008f2:	6785                	lui	a5,0x1
    800008f4:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008f6:	95be                	add	a1,a1,a5
    800008f8:	77fd                	lui	a5,0xfffff
    800008fa:	00f5fa33          	and	s4,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    800008fe:	08ca7f63          	bgeu	s4,a2,8000099c <uvmalloc+0xc0>
    80000902:	fc26                	sd	s1,56(sp)
    80000904:	f84a                	sd	s2,48(sp)
    80000906:	f44e                	sd	s3,40(sp)
    80000908:	e45e                	sd	s7,8(sp)
    8000090a:	8952                	mv	s2,s4
    memset(mem, 0, PGSIZE);
    8000090c:	6985                	lui	s3,0x1
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    8000090e:	4bf9                	li	s7,30
    mem = kalloc();
    80000910:	00000097          	auipc	ra,0x0
    80000914:	80a080e7          	jalr	-2038(ra) # 8000011a <kalloc>
    80000918:	84aa                	mv	s1,a0
    if(mem == 0){
    8000091a:	c915                	beqz	a0,8000094e <uvmalloc+0x72>
    memset(mem, 0, PGSIZE);
    8000091c:	864e                	mv	a2,s3
    8000091e:	4581                	li	a1,0
    80000920:	00000097          	auipc	ra,0x0
    80000924:	85a080e7          	jalr	-1958(ra) # 8000017a <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    80000928:	875e                	mv	a4,s7
    8000092a:	86a6                	mv	a3,s1
    8000092c:	864e                	mv	a2,s3
    8000092e:	85ca                	mv	a1,s2
    80000930:	855a                	mv	a0,s6
    80000932:	00000097          	auipc	ra,0x0
    80000936:	c28080e7          	jalr	-984(ra) # 8000055a <mappages>
    8000093a:	ed0d                	bnez	a0,80000974 <uvmalloc+0x98>
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000093c:	994e                	add	s2,s2,s3
    8000093e:	fd5969e3          	bltu	s2,s5,80000910 <uvmalloc+0x34>
  return newsz;
    80000942:	8556                	mv	a0,s5
    80000944:	74e2                	ld	s1,56(sp)
    80000946:	7942                	ld	s2,48(sp)
    80000948:	79a2                	ld	s3,40(sp)
    8000094a:	6ba2                	ld	s7,8(sp)
    8000094c:	a829                	j	80000966 <uvmalloc+0x8a>
      uvmdealloc(pagetable, a, oldsz);
    8000094e:	8652                	mv	a2,s4
    80000950:	85ca                	mv	a1,s2
    80000952:	855a                	mv	a0,s6
    80000954:	00000097          	auipc	ra,0x0
    80000958:	f40080e7          	jalr	-192(ra) # 80000894 <uvmdealloc>
      return 0;
    8000095c:	4501                	li	a0,0
    8000095e:	74e2                	ld	s1,56(sp)
    80000960:	7942                	ld	s2,48(sp)
    80000962:	79a2                	ld	s3,40(sp)
    80000964:	6ba2                	ld	s7,8(sp)
}
    80000966:	60a6                	ld	ra,72(sp)
    80000968:	6406                	ld	s0,64(sp)
    8000096a:	7a02                	ld	s4,32(sp)
    8000096c:	6ae2                	ld	s5,24(sp)
    8000096e:	6b42                	ld	s6,16(sp)
    80000970:	6161                	addi	sp,sp,80
    80000972:	8082                	ret
      kfree(mem);
    80000974:	8526                	mv	a0,s1
    80000976:	fffff097          	auipc	ra,0xfffff
    8000097a:	6a6080e7          	jalr	1702(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000097e:	8652                	mv	a2,s4
    80000980:	85ca                	mv	a1,s2
    80000982:	855a                	mv	a0,s6
    80000984:	00000097          	auipc	ra,0x0
    80000988:	f10080e7          	jalr	-240(ra) # 80000894 <uvmdealloc>
      return 0;
    8000098c:	4501                	li	a0,0
    8000098e:	74e2                	ld	s1,56(sp)
    80000990:	7942                	ld	s2,48(sp)
    80000992:	79a2                	ld	s3,40(sp)
    80000994:	6ba2                	ld	s7,8(sp)
    80000996:	bfc1                	j	80000966 <uvmalloc+0x8a>
    return oldsz;
    80000998:	852e                	mv	a0,a1
}
    8000099a:	8082                	ret
  return newsz;
    8000099c:	8532                	mv	a0,a2
    8000099e:	b7e1                	j	80000966 <uvmalloc+0x8a>

00000000800009a0 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800009a0:	7179                	addi	sp,sp,-48
    800009a2:	f406                	sd	ra,40(sp)
    800009a4:	f022                	sd	s0,32(sp)
    800009a6:	ec26                	sd	s1,24(sp)
    800009a8:	e84a                	sd	s2,16(sp)
    800009aa:	e44e                	sd	s3,8(sp)
    800009ac:	e052                	sd	s4,0(sp)
    800009ae:	1800                	addi	s0,sp,48
    800009b0:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800009b2:	84aa                	mv	s1,a0
    800009b4:	6905                	lui	s2,0x1
    800009b6:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009b8:	4985                	li	s3,1
    800009ba:	a829                	j	800009d4 <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800009bc:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    800009be:	00c79513          	slli	a0,a5,0xc
    800009c2:	00000097          	auipc	ra,0x0
    800009c6:	fde080e7          	jalr	-34(ra) # 800009a0 <freewalk>
      pagetable[i] = 0;
    800009ca:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800009ce:	04a1                	addi	s1,s1,8
    800009d0:	03248163          	beq	s1,s2,800009f2 <freewalk+0x52>
    pte_t pte = pagetable[i];
    800009d4:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009d6:	00f7f713          	andi	a4,a5,15
    800009da:	ff3701e3          	beq	a4,s3,800009bc <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009de:	8b85                	andi	a5,a5,1
    800009e0:	d7fd                	beqz	a5,800009ce <freewalk+0x2e>
      panic("freewalk: leaf");
    800009e2:	00007517          	auipc	a0,0x7
    800009e6:	71650513          	addi	a0,a0,1814 # 800080f8 <etext+0xf8>
    800009ea:	00005097          	auipc	ra,0x5
    800009ee:	2f8080e7          	jalr	760(ra) # 80005ce2 <panic>
    }
  }
  kfree((void*)pagetable);
    800009f2:	8552                	mv	a0,s4
    800009f4:	fffff097          	auipc	ra,0xfffff
    800009f8:	628080e7          	jalr	1576(ra) # 8000001c <kfree>
}
    800009fc:	70a2                	ld	ra,40(sp)
    800009fe:	7402                	ld	s0,32(sp)
    80000a00:	64e2                	ld	s1,24(sp)
    80000a02:	6942                	ld	s2,16(sp)
    80000a04:	69a2                	ld	s3,8(sp)
    80000a06:	6a02                	ld	s4,0(sp)
    80000a08:	6145                	addi	sp,sp,48
    80000a0a:	8082                	ret

0000000080000a0c <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000a0c:	1101                	addi	sp,sp,-32
    80000a0e:	ec06                	sd	ra,24(sp)
    80000a10:	e822                	sd	s0,16(sp)
    80000a12:	e426                	sd	s1,8(sp)
    80000a14:	1000                	addi	s0,sp,32
    80000a16:	84aa                	mv	s1,a0
  if(sz > 0)
    80000a18:	e999                	bnez	a1,80000a2e <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000a1a:	8526                	mv	a0,s1
    80000a1c:	00000097          	auipc	ra,0x0
    80000a20:	f84080e7          	jalr	-124(ra) # 800009a0 <freewalk>
}
    80000a24:	60e2                	ld	ra,24(sp)
    80000a26:	6442                	ld	s0,16(sp)
    80000a28:	64a2                	ld	s1,8(sp)
    80000a2a:	6105                	addi	sp,sp,32
    80000a2c:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000a2e:	6785                	lui	a5,0x1
    80000a30:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000a32:	95be                	add	a1,a1,a5
    80000a34:	4685                	li	a3,1
    80000a36:	00c5d613          	srli	a2,a1,0xc
    80000a3a:	4581                	li	a1,0
    80000a3c:	00000097          	auipc	ra,0x0
    80000a40:	ce4080e7          	jalr	-796(ra) # 80000720 <uvmunmap>
    80000a44:	bfd9                	j	80000a1a <uvmfree+0xe>

0000000080000a46 <uvmcopy>:
{
  pte_t *pte;
  uint64 pa, i;
  uint flags;

  for(i = 0; i < sz; i += PGSIZE){
    80000a46:	c255                	beqz	a2,80000aea <uvmcopy+0xa4>
{
    80000a48:	7139                	addi	sp,sp,-64
    80000a4a:	fc06                	sd	ra,56(sp)
    80000a4c:	f822                	sd	s0,48(sp)
    80000a4e:	f426                	sd	s1,40(sp)
    80000a50:	f04a                	sd	s2,32(sp)
    80000a52:	ec4e                	sd	s3,24(sp)
    80000a54:	e852                	sd	s4,16(sp)
    80000a56:	e456                	sd	s5,8(sp)
    80000a58:	0080                	addi	s0,sp,64
    80000a5a:	8aaa                	mv	s5,a0
    80000a5c:	8a2e                	mv	s4,a1
    80000a5e:	89b2                	mv	s3,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a60:	4481                	li	s1,0
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    flags = PTE_FLAGS(*pte);
    flags &= ~PTE_W;
    *pte = (*pte & ~PTE_W);
    if(mappages(new, i, PGSIZE, pa, flags) != 0){
    80000a62:	6905                	lui	s2,0x1
    if((pte = walk(old, i, 0)) == 0)
    80000a64:	4601                	li	a2,0
    80000a66:	85a6                	mv	a1,s1
    80000a68:	8556                	mv	a0,s5
    80000a6a:	00000097          	auipc	ra,0x0
    80000a6e:	a08080e7          	jalr	-1528(ra) # 80000472 <walk>
    80000a72:	c90d                	beqz	a0,80000aa4 <uvmcopy+0x5e>
    if((*pte & PTE_V) == 0)
    80000a74:	6118                	ld	a4,0(a0)
    80000a76:	00177793          	andi	a5,a4,1
    80000a7a:	cf8d                	beqz	a5,80000ab4 <uvmcopy+0x6e>
    *pte = (*pte & ~PTE_W);
    80000a7c:	ffb77793          	andi	a5,a4,-5
    80000a80:	e11c                	sd	a5,0(a0)
    pa = PTE2PA(*pte);
    80000a82:	00a75693          	srli	a3,a4,0xa
    if(mappages(new, i, PGSIZE, pa, flags) != 0){
    80000a86:	3fb77713          	andi	a4,a4,1019
    80000a8a:	06b2                	slli	a3,a3,0xc
    80000a8c:	864a                	mv	a2,s2
    80000a8e:	85a6                	mv	a1,s1
    80000a90:	8552                	mv	a0,s4
    80000a92:	00000097          	auipc	ra,0x0
    80000a96:	ac8080e7          	jalr	-1336(ra) # 8000055a <mappages>
    80000a9a:	e50d                	bnez	a0,80000ac4 <uvmcopy+0x7e>
  for(i = 0; i < sz; i += PGSIZE){
    80000a9c:	94ca                	add	s1,s1,s2
    80000a9e:	fd34e3e3          	bltu	s1,s3,80000a64 <uvmcopy+0x1e>
    80000aa2:	a81d                	j	80000ad8 <uvmcopy+0x92>
      panic("uvmcopy: pte should exist");
    80000aa4:	00007517          	auipc	a0,0x7
    80000aa8:	66450513          	addi	a0,a0,1636 # 80008108 <etext+0x108>
    80000aac:	00005097          	auipc	ra,0x5
    80000ab0:	236080e7          	jalr	566(ra) # 80005ce2 <panic>
      panic("uvmcopy: page not present");
    80000ab4:	00007517          	auipc	a0,0x7
    80000ab8:	67450513          	addi	a0,a0,1652 # 80008128 <etext+0x128>
    80000abc:	00005097          	auipc	ra,0x5
    80000ac0:	226080e7          	jalr	550(ra) # 80005ce2 <panic>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000ac4:	4685                	li	a3,1
    80000ac6:	00c4d613          	srli	a2,s1,0xc
    80000aca:	4581                	li	a1,0
    80000acc:	8552                	mv	a0,s4
    80000ace:	00000097          	auipc	ra,0x0
    80000ad2:	c52080e7          	jalr	-942(ra) # 80000720 <uvmunmap>
  return -1;
    80000ad6:	557d                	li	a0,-1
}
    80000ad8:	70e2                	ld	ra,56(sp)
    80000ada:	7442                	ld	s0,48(sp)
    80000adc:	74a2                	ld	s1,40(sp)
    80000ade:	7902                	ld	s2,32(sp)
    80000ae0:	69e2                	ld	s3,24(sp)
    80000ae2:	6a42                	ld	s4,16(sp)
    80000ae4:	6aa2                	ld	s5,8(sp)
    80000ae6:	6121                	addi	sp,sp,64
    80000ae8:	8082                	ret
  return 0;
    80000aea:	4501                	li	a0,0
}
    80000aec:	8082                	ret

0000000080000aee <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000aee:	1141                	addi	sp,sp,-16
    80000af0:	e406                	sd	ra,8(sp)
    80000af2:	e022                	sd	s0,0(sp)
    80000af4:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000af6:	4601                	li	a2,0
    80000af8:	00000097          	auipc	ra,0x0
    80000afc:	97a080e7          	jalr	-1670(ra) # 80000472 <walk>
  if(pte == 0)
    80000b00:	c901                	beqz	a0,80000b10 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000b02:	611c                	ld	a5,0(a0)
    80000b04:	9bbd                	andi	a5,a5,-17
    80000b06:	e11c                	sd	a5,0(a0)
}
    80000b08:	60a2                	ld	ra,8(sp)
    80000b0a:	6402                	ld	s0,0(sp)
    80000b0c:	0141                	addi	sp,sp,16
    80000b0e:	8082                	ret
    panic("uvmclear");
    80000b10:	00007517          	auipc	a0,0x7
    80000b14:	63850513          	addi	a0,a0,1592 # 80008148 <etext+0x148>
    80000b18:	00005097          	auipc	ra,0x5
    80000b1c:	1ca080e7          	jalr	458(ra) # 80005ce2 <panic>

0000000080000b20 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b20:	c6bd                	beqz	a3,80000b8e <copyout+0x6e>
{
    80000b22:	715d                	addi	sp,sp,-80
    80000b24:	e486                	sd	ra,72(sp)
    80000b26:	e0a2                	sd	s0,64(sp)
    80000b28:	fc26                	sd	s1,56(sp)
    80000b2a:	f84a                	sd	s2,48(sp)
    80000b2c:	f44e                	sd	s3,40(sp)
    80000b2e:	f052                	sd	s4,32(sp)
    80000b30:	ec56                	sd	s5,24(sp)
    80000b32:	e85a                	sd	s6,16(sp)
    80000b34:	e45e                	sd	s7,8(sp)
    80000b36:	e062                	sd	s8,0(sp)
    80000b38:	0880                	addi	s0,sp,80
    80000b3a:	8b2a                	mv	s6,a0
    80000b3c:	8c2e                	mv	s8,a1
    80000b3e:	8a32                	mv	s4,a2
    80000b40:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b42:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b44:	6a85                	lui	s5,0x1
    80000b46:	a015                	j	80000b6a <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b48:	9562                	add	a0,a0,s8
    80000b4a:	0004861b          	sext.w	a2,s1
    80000b4e:	85d2                	mv	a1,s4
    80000b50:	41250533          	sub	a0,a0,s2
    80000b54:	fffff097          	auipc	ra,0xfffff
    80000b58:	68a080e7          	jalr	1674(ra) # 800001de <memmove>

    len -= n;
    80000b5c:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b60:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b62:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b66:	02098263          	beqz	s3,80000b8a <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b6a:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b6e:	85ca                	mv	a1,s2
    80000b70:	855a                	mv	a0,s6
    80000b72:	00000097          	auipc	ra,0x0
    80000b76:	9a6080e7          	jalr	-1626(ra) # 80000518 <walkaddr>
    if(pa0 == 0)
    80000b7a:	cd01                	beqz	a0,80000b92 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000b7c:	418904b3          	sub	s1,s2,s8
    80000b80:	94d6                	add	s1,s1,s5
    if(n > len)
    80000b82:	fc99f3e3          	bgeu	s3,s1,80000b48 <copyout+0x28>
    80000b86:	84ce                	mv	s1,s3
    80000b88:	b7c1                	j	80000b48 <copyout+0x28>
  }
  return 0;
    80000b8a:	4501                	li	a0,0
    80000b8c:	a021                	j	80000b94 <copyout+0x74>
    80000b8e:	4501                	li	a0,0
}
    80000b90:	8082                	ret
      return -1;
    80000b92:	557d                	li	a0,-1
}
    80000b94:	60a6                	ld	ra,72(sp)
    80000b96:	6406                	ld	s0,64(sp)
    80000b98:	74e2                	ld	s1,56(sp)
    80000b9a:	7942                	ld	s2,48(sp)
    80000b9c:	79a2                	ld	s3,40(sp)
    80000b9e:	7a02                	ld	s4,32(sp)
    80000ba0:	6ae2                	ld	s5,24(sp)
    80000ba2:	6b42                	ld	s6,16(sp)
    80000ba4:	6ba2                	ld	s7,8(sp)
    80000ba6:	6c02                	ld	s8,0(sp)
    80000ba8:	6161                	addi	sp,sp,80
    80000baa:	8082                	ret

0000000080000bac <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000bac:	caa5                	beqz	a3,80000c1c <copyin+0x70>
{
    80000bae:	715d                	addi	sp,sp,-80
    80000bb0:	e486                	sd	ra,72(sp)
    80000bb2:	e0a2                	sd	s0,64(sp)
    80000bb4:	fc26                	sd	s1,56(sp)
    80000bb6:	f84a                	sd	s2,48(sp)
    80000bb8:	f44e                	sd	s3,40(sp)
    80000bba:	f052                	sd	s4,32(sp)
    80000bbc:	ec56                	sd	s5,24(sp)
    80000bbe:	e85a                	sd	s6,16(sp)
    80000bc0:	e45e                	sd	s7,8(sp)
    80000bc2:	e062                	sd	s8,0(sp)
    80000bc4:	0880                	addi	s0,sp,80
    80000bc6:	8b2a                	mv	s6,a0
    80000bc8:	8a2e                	mv	s4,a1
    80000bca:	8c32                	mv	s8,a2
    80000bcc:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000bce:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000bd0:	6a85                	lui	s5,0x1
    80000bd2:	a01d                	j	80000bf8 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000bd4:	018505b3          	add	a1,a0,s8
    80000bd8:	0004861b          	sext.w	a2,s1
    80000bdc:	412585b3          	sub	a1,a1,s2
    80000be0:	8552                	mv	a0,s4
    80000be2:	fffff097          	auipc	ra,0xfffff
    80000be6:	5fc080e7          	jalr	1532(ra) # 800001de <memmove>

    len -= n;
    80000bea:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000bee:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000bf0:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000bf4:	02098263          	beqz	s3,80000c18 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000bf8:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000bfc:	85ca                	mv	a1,s2
    80000bfe:	855a                	mv	a0,s6
    80000c00:	00000097          	auipc	ra,0x0
    80000c04:	918080e7          	jalr	-1768(ra) # 80000518 <walkaddr>
    if(pa0 == 0)
    80000c08:	cd01                	beqz	a0,80000c20 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000c0a:	418904b3          	sub	s1,s2,s8
    80000c0e:	94d6                	add	s1,s1,s5
    if(n > len)
    80000c10:	fc99f2e3          	bgeu	s3,s1,80000bd4 <copyin+0x28>
    80000c14:	84ce                	mv	s1,s3
    80000c16:	bf7d                	j	80000bd4 <copyin+0x28>
  }
  return 0;
    80000c18:	4501                	li	a0,0
    80000c1a:	a021                	j	80000c22 <copyin+0x76>
    80000c1c:	4501                	li	a0,0
}
    80000c1e:	8082                	ret
      return -1;
    80000c20:	557d                	li	a0,-1
}
    80000c22:	60a6                	ld	ra,72(sp)
    80000c24:	6406                	ld	s0,64(sp)
    80000c26:	74e2                	ld	s1,56(sp)
    80000c28:	7942                	ld	s2,48(sp)
    80000c2a:	79a2                	ld	s3,40(sp)
    80000c2c:	7a02                	ld	s4,32(sp)
    80000c2e:	6ae2                	ld	s5,24(sp)
    80000c30:	6b42                	ld	s6,16(sp)
    80000c32:	6ba2                	ld	s7,8(sp)
    80000c34:	6c02                	ld	s8,0(sp)
    80000c36:	6161                	addi	sp,sp,80
    80000c38:	8082                	ret

0000000080000c3a <copyinstr>:
// Copy bytes to dst from virtual address srcva in a given page table,
// until a '\0', or max.
// Return 0 on success, -1 on error.
int
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
    80000c3a:	715d                	addi	sp,sp,-80
    80000c3c:	e486                	sd	ra,72(sp)
    80000c3e:	e0a2                	sd	s0,64(sp)
    80000c40:	fc26                	sd	s1,56(sp)
    80000c42:	f84a                	sd	s2,48(sp)
    80000c44:	f44e                	sd	s3,40(sp)
    80000c46:	f052                	sd	s4,32(sp)
    80000c48:	ec56                	sd	s5,24(sp)
    80000c4a:	e85a                	sd	s6,16(sp)
    80000c4c:	e45e                	sd	s7,8(sp)
    80000c4e:	0880                	addi	s0,sp,80
    80000c50:	8aaa                	mv	s5,a0
    80000c52:	89ae                	mv	s3,a1
    80000c54:	8bb2                	mv	s7,a2
    80000c56:	84b6                	mv	s1,a3
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    va0 = PGROUNDDOWN(srcva);
    80000c58:	7b7d                	lui	s6,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c5a:	6a05                	lui	s4,0x1
    80000c5c:	a02d                	j	80000c86 <copyinstr+0x4c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c5e:	00078023          	sb	zero,0(a5)
    80000c62:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c64:	0017c793          	xori	a5,a5,1
    80000c68:	40f0053b          	negw	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000c6c:	60a6                	ld	ra,72(sp)
    80000c6e:	6406                	ld	s0,64(sp)
    80000c70:	74e2                	ld	s1,56(sp)
    80000c72:	7942                	ld	s2,48(sp)
    80000c74:	79a2                	ld	s3,40(sp)
    80000c76:	7a02                	ld	s4,32(sp)
    80000c78:	6ae2                	ld	s5,24(sp)
    80000c7a:	6b42                	ld	s6,16(sp)
    80000c7c:	6ba2                	ld	s7,8(sp)
    80000c7e:	6161                	addi	sp,sp,80
    80000c80:	8082                	ret
    srcva = va0 + PGSIZE;
    80000c82:	01490bb3          	add	s7,s2,s4
  while(got_null == 0 && max > 0){
    80000c86:	c8a1                	beqz	s1,80000cd6 <copyinstr+0x9c>
    va0 = PGROUNDDOWN(srcva);
    80000c88:	016bf933          	and	s2,s7,s6
    pa0 = walkaddr(pagetable, va0);
    80000c8c:	85ca                	mv	a1,s2
    80000c8e:	8556                	mv	a0,s5
    80000c90:	00000097          	auipc	ra,0x0
    80000c94:	888080e7          	jalr	-1912(ra) # 80000518 <walkaddr>
    if(pa0 == 0)
    80000c98:	c129                	beqz	a0,80000cda <copyinstr+0xa0>
    n = PGSIZE - (srcva - va0);
    80000c9a:	41790633          	sub	a2,s2,s7
    80000c9e:	9652                	add	a2,a2,s4
    if(n > max)
    80000ca0:	00c4f363          	bgeu	s1,a2,80000ca6 <copyinstr+0x6c>
    80000ca4:	8626                	mv	a2,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000ca6:	412b8bb3          	sub	s7,s7,s2
    80000caa:	9baa                	add	s7,s7,a0
    while(n > 0){
    80000cac:	da79                	beqz	a2,80000c82 <copyinstr+0x48>
    80000cae:	87ce                	mv	a5,s3
      if(*p == '\0'){
    80000cb0:	413b86b3          	sub	a3,s7,s3
    while(n > 0){
    80000cb4:	964e                	add	a2,a2,s3
    80000cb6:	85be                	mv	a1,a5
      if(*p == '\0'){
    80000cb8:	00f68733          	add	a4,a3,a5
    80000cbc:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffd8dc0>
    80000cc0:	df59                	beqz	a4,80000c5e <copyinstr+0x24>
        *dst = *p;
    80000cc2:	00e78023          	sb	a4,0(a5)
      dst++;
    80000cc6:	0785                	addi	a5,a5,1
    while(n > 0){
    80000cc8:	fec797e3          	bne	a5,a2,80000cb6 <copyinstr+0x7c>
    80000ccc:	14fd                	addi	s1,s1,-1
    80000cce:	94ce                	add	s1,s1,s3
      --max;
    80000cd0:	8c8d                	sub	s1,s1,a1
    80000cd2:	89be                	mv	s3,a5
    80000cd4:	b77d                	j	80000c82 <copyinstr+0x48>
    80000cd6:	4781                	li	a5,0
    80000cd8:	b771                	j	80000c64 <copyinstr+0x2a>
      return -1;
    80000cda:	557d                	li	a0,-1
    80000cdc:	bf41                	j	80000c6c <copyinstr+0x32>

0000000080000cde <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000cde:	715d                	addi	sp,sp,-80
    80000ce0:	e486                	sd	ra,72(sp)
    80000ce2:	e0a2                	sd	s0,64(sp)
    80000ce4:	fc26                	sd	s1,56(sp)
    80000ce6:	f84a                	sd	s2,48(sp)
    80000ce8:	f44e                	sd	s3,40(sp)
    80000cea:	f052                	sd	s4,32(sp)
    80000cec:	ec56                	sd	s5,24(sp)
    80000cee:	e85a                	sd	s6,16(sp)
    80000cf0:	e45e                	sd	s7,8(sp)
    80000cf2:	e062                	sd	s8,0(sp)
    80000cf4:	0880                	addi	s0,sp,80
    80000cf6:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cf8:	00008497          	auipc	s1,0x8
    80000cfc:	78848493          	addi	s1,s1,1928 # 80009480 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000d00:	8c26                	mv	s8,s1
    80000d02:	a4fa57b7          	lui	a5,0xa4fa5
    80000d06:	fa578793          	addi	a5,a5,-91 # ffffffffa4fa4fa5 <end+0xffffffff24f7ed65>
    80000d0a:	4fa50937          	lui	s2,0x4fa50
    80000d0e:	a5090913          	addi	s2,s2,-1456 # 4fa4fa50 <_entry-0x305b05b0>
    80000d12:	1902                	slli	s2,s2,0x20
    80000d14:	993e                	add	s2,s2,a5
    80000d16:	040009b7          	lui	s3,0x4000
    80000d1a:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000d1c:	09b2                	slli	s3,s3,0xc
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d1e:	4b99                	li	s7,6
    80000d20:	6b05                	lui	s6,0x1
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d22:	0000ea97          	auipc	s5,0xe
    80000d26:	15ea8a93          	addi	s5,s5,350 # 8000ee80 <tickslock>
    char *pa = kalloc();
    80000d2a:	fffff097          	auipc	ra,0xfffff
    80000d2e:	3f0080e7          	jalr	1008(ra) # 8000011a <kalloc>
    80000d32:	862a                	mv	a2,a0
    if(pa == 0)
    80000d34:	c131                	beqz	a0,80000d78 <proc_mapstacks+0x9a>
    uint64 va = KSTACK((int) (p - proc));
    80000d36:	418485b3          	sub	a1,s1,s8
    80000d3a:	858d                	srai	a1,a1,0x3
    80000d3c:	032585b3          	mul	a1,a1,s2
    80000d40:	2585                	addiw	a1,a1,1
    80000d42:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d46:	875e                	mv	a4,s7
    80000d48:	86da                	mv	a3,s6
    80000d4a:	40b985b3          	sub	a1,s3,a1
    80000d4e:	8552                	mv	a0,s4
    80000d50:	00000097          	auipc	ra,0x0
    80000d54:	8b0080e7          	jalr	-1872(ra) # 80000600 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d58:	16848493          	addi	s1,s1,360
    80000d5c:	fd5497e3          	bne	s1,s5,80000d2a <proc_mapstacks+0x4c>
  }
}
    80000d60:	60a6                	ld	ra,72(sp)
    80000d62:	6406                	ld	s0,64(sp)
    80000d64:	74e2                	ld	s1,56(sp)
    80000d66:	7942                	ld	s2,48(sp)
    80000d68:	79a2                	ld	s3,40(sp)
    80000d6a:	7a02                	ld	s4,32(sp)
    80000d6c:	6ae2                	ld	s5,24(sp)
    80000d6e:	6b42                	ld	s6,16(sp)
    80000d70:	6ba2                	ld	s7,8(sp)
    80000d72:	6c02                	ld	s8,0(sp)
    80000d74:	6161                	addi	sp,sp,80
    80000d76:	8082                	ret
      panic("kalloc");
    80000d78:	00007517          	auipc	a0,0x7
    80000d7c:	3e050513          	addi	a0,a0,992 # 80008158 <etext+0x158>
    80000d80:	00005097          	auipc	ra,0x5
    80000d84:	f62080e7          	jalr	-158(ra) # 80005ce2 <panic>

0000000080000d88 <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000d88:	7139                	addi	sp,sp,-64
    80000d8a:	fc06                	sd	ra,56(sp)
    80000d8c:	f822                	sd	s0,48(sp)
    80000d8e:	f426                	sd	s1,40(sp)
    80000d90:	f04a                	sd	s2,32(sp)
    80000d92:	ec4e                	sd	s3,24(sp)
    80000d94:	e852                	sd	s4,16(sp)
    80000d96:	e456                	sd	s5,8(sp)
    80000d98:	e05a                	sd	s6,0(sp)
    80000d9a:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000d9c:	00007597          	auipc	a1,0x7
    80000da0:	3c458593          	addi	a1,a1,964 # 80008160 <etext+0x160>
    80000da4:	00008517          	auipc	a0,0x8
    80000da8:	2ac50513          	addi	a0,a0,684 # 80009050 <pid_lock>
    80000dac:	00005097          	auipc	ra,0x5
    80000db0:	422080e7          	jalr	1058(ra) # 800061ce <initlock>
  initlock(&wait_lock, "wait_lock");
    80000db4:	00007597          	auipc	a1,0x7
    80000db8:	3b458593          	addi	a1,a1,948 # 80008168 <etext+0x168>
    80000dbc:	00008517          	auipc	a0,0x8
    80000dc0:	2ac50513          	addi	a0,a0,684 # 80009068 <wait_lock>
    80000dc4:	00005097          	auipc	ra,0x5
    80000dc8:	40a080e7          	jalr	1034(ra) # 800061ce <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dcc:	00008497          	auipc	s1,0x8
    80000dd0:	6b448493          	addi	s1,s1,1716 # 80009480 <proc>
      initlock(&p->lock, "proc");
    80000dd4:	00007b17          	auipc	s6,0x7
    80000dd8:	3a4b0b13          	addi	s6,s6,932 # 80008178 <etext+0x178>
      p->kstack = KSTACK((int) (p - proc));
    80000ddc:	8aa6                	mv	s5,s1
    80000dde:	a4fa57b7          	lui	a5,0xa4fa5
    80000de2:	fa578793          	addi	a5,a5,-91 # ffffffffa4fa4fa5 <end+0xffffffff24f7ed65>
    80000de6:	4fa50937          	lui	s2,0x4fa50
    80000dea:	a5090913          	addi	s2,s2,-1456 # 4fa4fa50 <_entry-0x305b05b0>
    80000dee:	1902                	slli	s2,s2,0x20
    80000df0:	993e                	add	s2,s2,a5
    80000df2:	040009b7          	lui	s3,0x4000
    80000df6:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000df8:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dfa:	0000ea17          	auipc	s4,0xe
    80000dfe:	086a0a13          	addi	s4,s4,134 # 8000ee80 <tickslock>
      initlock(&p->lock, "proc");
    80000e02:	85da                	mv	a1,s6
    80000e04:	8526                	mv	a0,s1
    80000e06:	00005097          	auipc	ra,0x5
    80000e0a:	3c8080e7          	jalr	968(ra) # 800061ce <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000e0e:	415487b3          	sub	a5,s1,s5
    80000e12:	878d                	srai	a5,a5,0x3
    80000e14:	032787b3          	mul	a5,a5,s2
    80000e18:	2785                	addiw	a5,a5,1
    80000e1a:	00d7979b          	slliw	a5,a5,0xd
    80000e1e:	40f987b3          	sub	a5,s3,a5
    80000e22:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e24:	16848493          	addi	s1,s1,360
    80000e28:	fd449de3          	bne	s1,s4,80000e02 <procinit+0x7a>
  }
}
    80000e2c:	70e2                	ld	ra,56(sp)
    80000e2e:	7442                	ld	s0,48(sp)
    80000e30:	74a2                	ld	s1,40(sp)
    80000e32:	7902                	ld	s2,32(sp)
    80000e34:	69e2                	ld	s3,24(sp)
    80000e36:	6a42                	ld	s4,16(sp)
    80000e38:	6aa2                	ld	s5,8(sp)
    80000e3a:	6b02                	ld	s6,0(sp)
    80000e3c:	6121                	addi	sp,sp,64
    80000e3e:	8082                	ret

0000000080000e40 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e40:	1141                	addi	sp,sp,-16
    80000e42:	e406                	sd	ra,8(sp)
    80000e44:	e022                	sd	s0,0(sp)
    80000e46:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e48:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e4a:	2501                	sext.w	a0,a0
    80000e4c:	60a2                	ld	ra,8(sp)
    80000e4e:	6402                	ld	s0,0(sp)
    80000e50:	0141                	addi	sp,sp,16
    80000e52:	8082                	ret

0000000080000e54 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000e54:	1141                	addi	sp,sp,-16
    80000e56:	e406                	sd	ra,8(sp)
    80000e58:	e022                	sd	s0,0(sp)
    80000e5a:	0800                	addi	s0,sp,16
    80000e5c:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e5e:	2781                	sext.w	a5,a5
    80000e60:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e62:	00008517          	auipc	a0,0x8
    80000e66:	21e50513          	addi	a0,a0,542 # 80009080 <cpus>
    80000e6a:	953e                	add	a0,a0,a5
    80000e6c:	60a2                	ld	ra,8(sp)
    80000e6e:	6402                	ld	s0,0(sp)
    80000e70:	0141                	addi	sp,sp,16
    80000e72:	8082                	ret

0000000080000e74 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000e74:	1101                	addi	sp,sp,-32
    80000e76:	ec06                	sd	ra,24(sp)
    80000e78:	e822                	sd	s0,16(sp)
    80000e7a:	e426                	sd	s1,8(sp)
    80000e7c:	1000                	addi	s0,sp,32
  push_off();
    80000e7e:	00005097          	auipc	ra,0x5
    80000e82:	398080e7          	jalr	920(ra) # 80006216 <push_off>
    80000e86:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000e88:	2781                	sext.w	a5,a5
    80000e8a:	079e                	slli	a5,a5,0x7
    80000e8c:	00008717          	auipc	a4,0x8
    80000e90:	1c470713          	addi	a4,a4,452 # 80009050 <pid_lock>
    80000e94:	97ba                	add	a5,a5,a4
    80000e96:	7b84                	ld	s1,48(a5)
  pop_off();
    80000e98:	00005097          	auipc	ra,0x5
    80000e9c:	41e080e7          	jalr	1054(ra) # 800062b6 <pop_off>
  return p;
}
    80000ea0:	8526                	mv	a0,s1
    80000ea2:	60e2                	ld	ra,24(sp)
    80000ea4:	6442                	ld	s0,16(sp)
    80000ea6:	64a2                	ld	s1,8(sp)
    80000ea8:	6105                	addi	sp,sp,32
    80000eaa:	8082                	ret

0000000080000eac <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000eac:	1141                	addi	sp,sp,-16
    80000eae:	e406                	sd	ra,8(sp)
    80000eb0:	e022                	sd	s0,0(sp)
    80000eb2:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000eb4:	00000097          	auipc	ra,0x0
    80000eb8:	fc0080e7          	jalr	-64(ra) # 80000e74 <myproc>
    80000ebc:	00005097          	auipc	ra,0x5
    80000ec0:	456080e7          	jalr	1110(ra) # 80006312 <release>

  if (first) {
    80000ec4:	00008797          	auipc	a5,0x8
    80000ec8:	94c7a783          	lw	a5,-1716(a5) # 80008810 <first.1>
    80000ecc:	eb89                	bnez	a5,80000ede <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000ece:	00001097          	auipc	ra,0x1
    80000ed2:	c14080e7          	jalr	-1004(ra) # 80001ae2 <usertrapret>
}
    80000ed6:	60a2                	ld	ra,8(sp)
    80000ed8:	6402                	ld	s0,0(sp)
    80000eda:	0141                	addi	sp,sp,16
    80000edc:	8082                	ret
    first = 0;
    80000ede:	00008797          	auipc	a5,0x8
    80000ee2:	9207a923          	sw	zero,-1742(a5) # 80008810 <first.1>
    fsinit(ROOTDEV);
    80000ee6:	4505                	li	a0,1
    80000ee8:	00002097          	auipc	ra,0x2
    80000eec:	9ca080e7          	jalr	-1590(ra) # 800028b2 <fsinit>
    80000ef0:	bff9                	j	80000ece <forkret+0x22>

0000000080000ef2 <allocpid>:
allocpid() {
    80000ef2:	1101                	addi	sp,sp,-32
    80000ef4:	ec06                	sd	ra,24(sp)
    80000ef6:	e822                	sd	s0,16(sp)
    80000ef8:	e426                	sd	s1,8(sp)
    80000efa:	e04a                	sd	s2,0(sp)
    80000efc:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000efe:	00008917          	auipc	s2,0x8
    80000f02:	15290913          	addi	s2,s2,338 # 80009050 <pid_lock>
    80000f06:	854a                	mv	a0,s2
    80000f08:	00005097          	auipc	ra,0x5
    80000f0c:	35a080e7          	jalr	858(ra) # 80006262 <acquire>
  pid = nextpid;
    80000f10:	00008797          	auipc	a5,0x8
    80000f14:	90478793          	addi	a5,a5,-1788 # 80008814 <nextpid>
    80000f18:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000f1a:	0014871b          	addiw	a4,s1,1
    80000f1e:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000f20:	854a                	mv	a0,s2
    80000f22:	00005097          	auipc	ra,0x5
    80000f26:	3f0080e7          	jalr	1008(ra) # 80006312 <release>
}
    80000f2a:	8526                	mv	a0,s1
    80000f2c:	60e2                	ld	ra,24(sp)
    80000f2e:	6442                	ld	s0,16(sp)
    80000f30:	64a2                	ld	s1,8(sp)
    80000f32:	6902                	ld	s2,0(sp)
    80000f34:	6105                	addi	sp,sp,32
    80000f36:	8082                	ret

0000000080000f38 <proc_pagetable>:
{
    80000f38:	1101                	addi	sp,sp,-32
    80000f3a:	ec06                	sd	ra,24(sp)
    80000f3c:	e822                	sd	s0,16(sp)
    80000f3e:	e426                	sd	s1,8(sp)
    80000f40:	e04a                	sd	s2,0(sp)
    80000f42:	1000                	addi	s0,sp,32
    80000f44:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f46:	00000097          	auipc	ra,0x0
    80000f4a:	8ae080e7          	jalr	-1874(ra) # 800007f4 <uvmcreate>
    80000f4e:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f50:	c121                	beqz	a0,80000f90 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f52:	4729                	li	a4,10
    80000f54:	00006697          	auipc	a3,0x6
    80000f58:	0ac68693          	addi	a3,a3,172 # 80007000 <_trampoline>
    80000f5c:	6605                	lui	a2,0x1
    80000f5e:	040005b7          	lui	a1,0x4000
    80000f62:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f64:	05b2                	slli	a1,a1,0xc
    80000f66:	fffff097          	auipc	ra,0xfffff
    80000f6a:	5f4080e7          	jalr	1524(ra) # 8000055a <mappages>
    80000f6e:	02054863          	bltz	a0,80000f9e <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f72:	4719                	li	a4,6
    80000f74:	05893683          	ld	a3,88(s2)
    80000f78:	6605                	lui	a2,0x1
    80000f7a:	020005b7          	lui	a1,0x2000
    80000f7e:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000f80:	05b6                	slli	a1,a1,0xd
    80000f82:	8526                	mv	a0,s1
    80000f84:	fffff097          	auipc	ra,0xfffff
    80000f88:	5d6080e7          	jalr	1494(ra) # 8000055a <mappages>
    80000f8c:	02054163          	bltz	a0,80000fae <proc_pagetable+0x76>
}
    80000f90:	8526                	mv	a0,s1
    80000f92:	60e2                	ld	ra,24(sp)
    80000f94:	6442                	ld	s0,16(sp)
    80000f96:	64a2                	ld	s1,8(sp)
    80000f98:	6902                	ld	s2,0(sp)
    80000f9a:	6105                	addi	sp,sp,32
    80000f9c:	8082                	ret
    uvmfree(pagetable, 0);
    80000f9e:	4581                	li	a1,0
    80000fa0:	8526                	mv	a0,s1
    80000fa2:	00000097          	auipc	ra,0x0
    80000fa6:	a6a080e7          	jalr	-1430(ra) # 80000a0c <uvmfree>
    return 0;
    80000faa:	4481                	li	s1,0
    80000fac:	b7d5                	j	80000f90 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fae:	4681                	li	a3,0
    80000fb0:	4605                	li	a2,1
    80000fb2:	040005b7          	lui	a1,0x4000
    80000fb6:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000fb8:	05b2                	slli	a1,a1,0xc
    80000fba:	8526                	mv	a0,s1
    80000fbc:	fffff097          	auipc	ra,0xfffff
    80000fc0:	764080e7          	jalr	1892(ra) # 80000720 <uvmunmap>
    uvmfree(pagetable, 0);
    80000fc4:	4581                	li	a1,0
    80000fc6:	8526                	mv	a0,s1
    80000fc8:	00000097          	auipc	ra,0x0
    80000fcc:	a44080e7          	jalr	-1468(ra) # 80000a0c <uvmfree>
    return 0;
    80000fd0:	4481                	li	s1,0
    80000fd2:	bf7d                	j	80000f90 <proc_pagetable+0x58>

0000000080000fd4 <proc_freepagetable>:
{
    80000fd4:	1101                	addi	sp,sp,-32
    80000fd6:	ec06                	sd	ra,24(sp)
    80000fd8:	e822                	sd	s0,16(sp)
    80000fda:	e426                	sd	s1,8(sp)
    80000fdc:	e04a                	sd	s2,0(sp)
    80000fde:	1000                	addi	s0,sp,32
    80000fe0:	84aa                	mv	s1,a0
    80000fe2:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fe4:	4681                	li	a3,0
    80000fe6:	4605                	li	a2,1
    80000fe8:	040005b7          	lui	a1,0x4000
    80000fec:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000fee:	05b2                	slli	a1,a1,0xc
    80000ff0:	fffff097          	auipc	ra,0xfffff
    80000ff4:	730080e7          	jalr	1840(ra) # 80000720 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000ff8:	4681                	li	a3,0
    80000ffa:	4605                	li	a2,1
    80000ffc:	020005b7          	lui	a1,0x2000
    80001000:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001002:	05b6                	slli	a1,a1,0xd
    80001004:	8526                	mv	a0,s1
    80001006:	fffff097          	auipc	ra,0xfffff
    8000100a:	71a080e7          	jalr	1818(ra) # 80000720 <uvmunmap>
  uvmfree(pagetable, sz);
    8000100e:	85ca                	mv	a1,s2
    80001010:	8526                	mv	a0,s1
    80001012:	00000097          	auipc	ra,0x0
    80001016:	9fa080e7          	jalr	-1542(ra) # 80000a0c <uvmfree>
}
    8000101a:	60e2                	ld	ra,24(sp)
    8000101c:	6442                	ld	s0,16(sp)
    8000101e:	64a2                	ld	s1,8(sp)
    80001020:	6902                	ld	s2,0(sp)
    80001022:	6105                	addi	sp,sp,32
    80001024:	8082                	ret

0000000080001026 <freeproc>:
{
    80001026:	1101                	addi	sp,sp,-32
    80001028:	ec06                	sd	ra,24(sp)
    8000102a:	e822                	sd	s0,16(sp)
    8000102c:	e426                	sd	s1,8(sp)
    8000102e:	1000                	addi	s0,sp,32
    80001030:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001032:	6d28                	ld	a0,88(a0)
    80001034:	c509                	beqz	a0,8000103e <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001036:	fffff097          	auipc	ra,0xfffff
    8000103a:	fe6080e7          	jalr	-26(ra) # 8000001c <kfree>
  p->trapframe = 0;
    8000103e:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001042:	68a8                	ld	a0,80(s1)
    80001044:	c511                	beqz	a0,80001050 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001046:	64ac                	ld	a1,72(s1)
    80001048:	00000097          	auipc	ra,0x0
    8000104c:	f8c080e7          	jalr	-116(ra) # 80000fd4 <proc_freepagetable>
  p->pagetable = 0;
    80001050:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001054:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001058:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    8000105c:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001060:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001064:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001068:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    8000106c:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001070:	0004ac23          	sw	zero,24(s1)
}
    80001074:	60e2                	ld	ra,24(sp)
    80001076:	6442                	ld	s0,16(sp)
    80001078:	64a2                	ld	s1,8(sp)
    8000107a:	6105                	addi	sp,sp,32
    8000107c:	8082                	ret

000000008000107e <allocproc>:
{
    8000107e:	1101                	addi	sp,sp,-32
    80001080:	ec06                	sd	ra,24(sp)
    80001082:	e822                	sd	s0,16(sp)
    80001084:	e426                	sd	s1,8(sp)
    80001086:	e04a                	sd	s2,0(sp)
    80001088:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    8000108a:	00008497          	auipc	s1,0x8
    8000108e:	3f648493          	addi	s1,s1,1014 # 80009480 <proc>
    80001092:	0000e917          	auipc	s2,0xe
    80001096:	dee90913          	addi	s2,s2,-530 # 8000ee80 <tickslock>
    acquire(&p->lock);
    8000109a:	8526                	mv	a0,s1
    8000109c:	00005097          	auipc	ra,0x5
    800010a0:	1c6080e7          	jalr	454(ra) # 80006262 <acquire>
    if(p->state == UNUSED) {
    800010a4:	4c9c                	lw	a5,24(s1)
    800010a6:	cf81                	beqz	a5,800010be <allocproc+0x40>
      release(&p->lock);
    800010a8:	8526                	mv	a0,s1
    800010aa:	00005097          	auipc	ra,0x5
    800010ae:	268080e7          	jalr	616(ra) # 80006312 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800010b2:	16848493          	addi	s1,s1,360
    800010b6:	ff2492e3          	bne	s1,s2,8000109a <allocproc+0x1c>
  return 0;
    800010ba:	4481                	li	s1,0
    800010bc:	a889                	j	8000110e <allocproc+0x90>
  p->pid = allocpid();
    800010be:	00000097          	auipc	ra,0x0
    800010c2:	e34080e7          	jalr	-460(ra) # 80000ef2 <allocpid>
    800010c6:	d888                	sw	a0,48(s1)
  p->state = USED;
    800010c8:	4785                	li	a5,1
    800010ca:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800010cc:	fffff097          	auipc	ra,0xfffff
    800010d0:	04e080e7          	jalr	78(ra) # 8000011a <kalloc>
    800010d4:	892a                	mv	s2,a0
    800010d6:	eca8                	sd	a0,88(s1)
    800010d8:	c131                	beqz	a0,8000111c <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800010da:	8526                	mv	a0,s1
    800010dc:	00000097          	auipc	ra,0x0
    800010e0:	e5c080e7          	jalr	-420(ra) # 80000f38 <proc_pagetable>
    800010e4:	892a                	mv	s2,a0
    800010e6:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800010e8:	c531                	beqz	a0,80001134 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    800010ea:	07000613          	li	a2,112
    800010ee:	4581                	li	a1,0
    800010f0:	06048513          	addi	a0,s1,96
    800010f4:	fffff097          	auipc	ra,0xfffff
    800010f8:	086080e7          	jalr	134(ra) # 8000017a <memset>
  p->context.ra = (uint64)forkret;
    800010fc:	00000797          	auipc	a5,0x0
    80001100:	db078793          	addi	a5,a5,-592 # 80000eac <forkret>
    80001104:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001106:	60bc                	ld	a5,64(s1)
    80001108:	6705                	lui	a4,0x1
    8000110a:	97ba                	add	a5,a5,a4
    8000110c:	f4bc                	sd	a5,104(s1)
}
    8000110e:	8526                	mv	a0,s1
    80001110:	60e2                	ld	ra,24(sp)
    80001112:	6442                	ld	s0,16(sp)
    80001114:	64a2                	ld	s1,8(sp)
    80001116:	6902                	ld	s2,0(sp)
    80001118:	6105                	addi	sp,sp,32
    8000111a:	8082                	ret
    freeproc(p);
    8000111c:	8526                	mv	a0,s1
    8000111e:	00000097          	auipc	ra,0x0
    80001122:	f08080e7          	jalr	-248(ra) # 80001026 <freeproc>
    release(&p->lock);
    80001126:	8526                	mv	a0,s1
    80001128:	00005097          	auipc	ra,0x5
    8000112c:	1ea080e7          	jalr	490(ra) # 80006312 <release>
    return 0;
    80001130:	84ca                	mv	s1,s2
    80001132:	bff1                	j	8000110e <allocproc+0x90>
    freeproc(p);
    80001134:	8526                	mv	a0,s1
    80001136:	00000097          	auipc	ra,0x0
    8000113a:	ef0080e7          	jalr	-272(ra) # 80001026 <freeproc>
    release(&p->lock);
    8000113e:	8526                	mv	a0,s1
    80001140:	00005097          	auipc	ra,0x5
    80001144:	1d2080e7          	jalr	466(ra) # 80006312 <release>
    return 0;
    80001148:	84ca                	mv	s1,s2
    8000114a:	b7d1                	j	8000110e <allocproc+0x90>

000000008000114c <userinit>:
{
    8000114c:	1101                	addi	sp,sp,-32
    8000114e:	ec06                	sd	ra,24(sp)
    80001150:	e822                	sd	s0,16(sp)
    80001152:	e426                	sd	s1,8(sp)
    80001154:	1000                	addi	s0,sp,32
  p = allocproc();
    80001156:	00000097          	auipc	ra,0x0
    8000115a:	f28080e7          	jalr	-216(ra) # 8000107e <allocproc>
    8000115e:	84aa                	mv	s1,a0
  initproc = p;
    80001160:	00008797          	auipc	a5,0x8
    80001164:	eaa7b823          	sd	a0,-336(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001168:	03400613          	li	a2,52
    8000116c:	00007597          	auipc	a1,0x7
    80001170:	6b458593          	addi	a1,a1,1716 # 80008820 <initcode>
    80001174:	6928                	ld	a0,80(a0)
    80001176:	fffff097          	auipc	ra,0xfffff
    8000117a:	6ac080e7          	jalr	1708(ra) # 80000822 <uvminit>
  p->sz = PGSIZE;
    8000117e:	6785                	lui	a5,0x1
    80001180:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001182:	6cb8                	ld	a4,88(s1)
    80001184:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001188:	6cb8                	ld	a4,88(s1)
    8000118a:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    8000118c:	4641                	li	a2,16
    8000118e:	00007597          	auipc	a1,0x7
    80001192:	ff258593          	addi	a1,a1,-14 # 80008180 <etext+0x180>
    80001196:	15848513          	addi	a0,s1,344
    8000119a:	fffff097          	auipc	ra,0xfffff
    8000119e:	136080e7          	jalr	310(ra) # 800002d0 <safestrcpy>
  p->cwd = namei("/");
    800011a2:	00007517          	auipc	a0,0x7
    800011a6:	fee50513          	addi	a0,a0,-18 # 80008190 <etext+0x190>
    800011aa:	00002097          	auipc	ra,0x2
    800011ae:	168080e7          	jalr	360(ra) # 80003312 <namei>
    800011b2:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800011b6:	478d                	li	a5,3
    800011b8:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800011ba:	8526                	mv	a0,s1
    800011bc:	00005097          	auipc	ra,0x5
    800011c0:	156080e7          	jalr	342(ra) # 80006312 <release>
}
    800011c4:	60e2                	ld	ra,24(sp)
    800011c6:	6442                	ld	s0,16(sp)
    800011c8:	64a2                	ld	s1,8(sp)
    800011ca:	6105                	addi	sp,sp,32
    800011cc:	8082                	ret

00000000800011ce <growproc>:
{
    800011ce:	1101                	addi	sp,sp,-32
    800011d0:	ec06                	sd	ra,24(sp)
    800011d2:	e822                	sd	s0,16(sp)
    800011d4:	e426                	sd	s1,8(sp)
    800011d6:	e04a                	sd	s2,0(sp)
    800011d8:	1000                	addi	s0,sp,32
    800011da:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800011dc:	00000097          	auipc	ra,0x0
    800011e0:	c98080e7          	jalr	-872(ra) # 80000e74 <myproc>
    800011e4:	892a                	mv	s2,a0
  sz = p->sz;
    800011e6:	652c                	ld	a1,72(a0)
    800011e8:	0005879b          	sext.w	a5,a1
  if(n > 0){
    800011ec:	00904f63          	bgtz	s1,8000120a <growproc+0x3c>
  } else if(n < 0){
    800011f0:	0204cd63          	bltz	s1,8000122a <growproc+0x5c>
  p->sz = sz;
    800011f4:	1782                	slli	a5,a5,0x20
    800011f6:	9381                	srli	a5,a5,0x20
    800011f8:	04f93423          	sd	a5,72(s2)
  return 0;
    800011fc:	4501                	li	a0,0
}
    800011fe:	60e2                	ld	ra,24(sp)
    80001200:	6442                	ld	s0,16(sp)
    80001202:	64a2                	ld	s1,8(sp)
    80001204:	6902                	ld	s2,0(sp)
    80001206:	6105                	addi	sp,sp,32
    80001208:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    8000120a:	00f4863b          	addw	a2,s1,a5
    8000120e:	1602                	slli	a2,a2,0x20
    80001210:	9201                	srli	a2,a2,0x20
    80001212:	1582                	slli	a1,a1,0x20
    80001214:	9181                	srli	a1,a1,0x20
    80001216:	6928                	ld	a0,80(a0)
    80001218:	fffff097          	auipc	ra,0xfffff
    8000121c:	6c4080e7          	jalr	1732(ra) # 800008dc <uvmalloc>
    80001220:	0005079b          	sext.w	a5,a0
    80001224:	fbe1                	bnez	a5,800011f4 <growproc+0x26>
      return -1;
    80001226:	557d                	li	a0,-1
    80001228:	bfd9                	j	800011fe <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    8000122a:	00f4863b          	addw	a2,s1,a5
    8000122e:	1602                	slli	a2,a2,0x20
    80001230:	9201                	srli	a2,a2,0x20
    80001232:	1582                	slli	a1,a1,0x20
    80001234:	9181                	srli	a1,a1,0x20
    80001236:	6928                	ld	a0,80(a0)
    80001238:	fffff097          	auipc	ra,0xfffff
    8000123c:	65c080e7          	jalr	1628(ra) # 80000894 <uvmdealloc>
    80001240:	0005079b          	sext.w	a5,a0
    80001244:	bf45                	j	800011f4 <growproc+0x26>

0000000080001246 <fork>:
{
    80001246:	7139                	addi	sp,sp,-64
    80001248:	fc06                	sd	ra,56(sp)
    8000124a:	f822                	sd	s0,48(sp)
    8000124c:	f04a                	sd	s2,32(sp)
    8000124e:	e456                	sd	s5,8(sp)
    80001250:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001252:	00000097          	auipc	ra,0x0
    80001256:	c22080e7          	jalr	-990(ra) # 80000e74 <myproc>
    8000125a:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    8000125c:	00000097          	auipc	ra,0x0
    80001260:	e22080e7          	jalr	-478(ra) # 8000107e <allocproc>
    80001264:	12050063          	beqz	a0,80001384 <fork+0x13e>
    80001268:	e852                	sd	s4,16(sp)
    8000126a:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    8000126c:	048ab603          	ld	a2,72(s5)
    80001270:	692c                	ld	a1,80(a0)
    80001272:	050ab503          	ld	a0,80(s5)
    80001276:	fffff097          	auipc	ra,0xfffff
    8000127a:	7d0080e7          	jalr	2000(ra) # 80000a46 <uvmcopy>
    8000127e:	04054a63          	bltz	a0,800012d2 <fork+0x8c>
    80001282:	f426                	sd	s1,40(sp)
    80001284:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    80001286:	048ab783          	ld	a5,72(s5)
    8000128a:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    8000128e:	058ab683          	ld	a3,88(s5)
    80001292:	87b6                	mv	a5,a3
    80001294:	058a3703          	ld	a4,88(s4)
    80001298:	12068693          	addi	a3,a3,288
    8000129c:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800012a0:	6788                	ld	a0,8(a5)
    800012a2:	6b8c                	ld	a1,16(a5)
    800012a4:	6f90                	ld	a2,24(a5)
    800012a6:	01073023          	sd	a6,0(a4)
    800012aa:	e708                	sd	a0,8(a4)
    800012ac:	eb0c                	sd	a1,16(a4)
    800012ae:	ef10                	sd	a2,24(a4)
    800012b0:	02078793          	addi	a5,a5,32
    800012b4:	02070713          	addi	a4,a4,32
    800012b8:	fed792e3          	bne	a5,a3,8000129c <fork+0x56>
  np->trapframe->a0 = 0;
    800012bc:	058a3783          	ld	a5,88(s4)
    800012c0:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800012c4:	0d0a8493          	addi	s1,s5,208
    800012c8:	0d0a0913          	addi	s2,s4,208
    800012cc:	150a8993          	addi	s3,s5,336
    800012d0:	a015                	j	800012f4 <fork+0xae>
    freeproc(np);
    800012d2:	8552                	mv	a0,s4
    800012d4:	00000097          	auipc	ra,0x0
    800012d8:	d52080e7          	jalr	-686(ra) # 80001026 <freeproc>
    release(&np->lock);
    800012dc:	8552                	mv	a0,s4
    800012de:	00005097          	auipc	ra,0x5
    800012e2:	034080e7          	jalr	52(ra) # 80006312 <release>
    return -1;
    800012e6:	597d                	li	s2,-1
    800012e8:	6a42                	ld	s4,16(sp)
    800012ea:	a071                	j	80001376 <fork+0x130>
  for(i = 0; i < NOFILE; i++)
    800012ec:	04a1                	addi	s1,s1,8
    800012ee:	0921                	addi	s2,s2,8
    800012f0:	01348b63          	beq	s1,s3,80001306 <fork+0xc0>
    if(p->ofile[i])
    800012f4:	6088                	ld	a0,0(s1)
    800012f6:	d97d                	beqz	a0,800012ec <fork+0xa6>
      np->ofile[i] = filedup(p->ofile[i]);
    800012f8:	00002097          	auipc	ra,0x2
    800012fc:	69e080e7          	jalr	1694(ra) # 80003996 <filedup>
    80001300:	00a93023          	sd	a0,0(s2)
    80001304:	b7e5                	j	800012ec <fork+0xa6>
  np->cwd = idup(p->cwd);
    80001306:	150ab503          	ld	a0,336(s5)
    8000130a:	00001097          	auipc	ra,0x1
    8000130e:	7de080e7          	jalr	2014(ra) # 80002ae8 <idup>
    80001312:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001316:	4641                	li	a2,16
    80001318:	158a8593          	addi	a1,s5,344
    8000131c:	158a0513          	addi	a0,s4,344
    80001320:	fffff097          	auipc	ra,0xfffff
    80001324:	fb0080e7          	jalr	-80(ra) # 800002d0 <safestrcpy>
  pid = np->pid;
    80001328:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    8000132c:	8552                	mv	a0,s4
    8000132e:	00005097          	auipc	ra,0x5
    80001332:	fe4080e7          	jalr	-28(ra) # 80006312 <release>
  acquire(&wait_lock);
    80001336:	00008497          	auipc	s1,0x8
    8000133a:	d3248493          	addi	s1,s1,-718 # 80009068 <wait_lock>
    8000133e:	8526                	mv	a0,s1
    80001340:	00005097          	auipc	ra,0x5
    80001344:	f22080e7          	jalr	-222(ra) # 80006262 <acquire>
  np->parent = p;
    80001348:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    8000134c:	8526                	mv	a0,s1
    8000134e:	00005097          	auipc	ra,0x5
    80001352:	fc4080e7          	jalr	-60(ra) # 80006312 <release>
  acquire(&np->lock);
    80001356:	8552                	mv	a0,s4
    80001358:	00005097          	auipc	ra,0x5
    8000135c:	f0a080e7          	jalr	-246(ra) # 80006262 <acquire>
  np->state = RUNNABLE;
    80001360:	478d                	li	a5,3
    80001362:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001366:	8552                	mv	a0,s4
    80001368:	00005097          	auipc	ra,0x5
    8000136c:	faa080e7          	jalr	-86(ra) # 80006312 <release>
  return pid;
    80001370:	74a2                	ld	s1,40(sp)
    80001372:	69e2                	ld	s3,24(sp)
    80001374:	6a42                	ld	s4,16(sp)
}
    80001376:	854a                	mv	a0,s2
    80001378:	70e2                	ld	ra,56(sp)
    8000137a:	7442                	ld	s0,48(sp)
    8000137c:	7902                	ld	s2,32(sp)
    8000137e:	6aa2                	ld	s5,8(sp)
    80001380:	6121                	addi	sp,sp,64
    80001382:	8082                	ret
    return -1;
    80001384:	597d                	li	s2,-1
    80001386:	bfc5                	j	80001376 <fork+0x130>

0000000080001388 <scheduler>:
{
    80001388:	7139                	addi	sp,sp,-64
    8000138a:	fc06                	sd	ra,56(sp)
    8000138c:	f822                	sd	s0,48(sp)
    8000138e:	f426                	sd	s1,40(sp)
    80001390:	f04a                	sd	s2,32(sp)
    80001392:	ec4e                	sd	s3,24(sp)
    80001394:	e852                	sd	s4,16(sp)
    80001396:	e456                	sd	s5,8(sp)
    80001398:	e05a                	sd	s6,0(sp)
    8000139a:	0080                	addi	s0,sp,64
    8000139c:	8792                	mv	a5,tp
  int id = r_tp();
    8000139e:	2781                	sext.w	a5,a5
  c->proc = 0;
    800013a0:	00779a93          	slli	s5,a5,0x7
    800013a4:	00008717          	auipc	a4,0x8
    800013a8:	cac70713          	addi	a4,a4,-852 # 80009050 <pid_lock>
    800013ac:	9756                	add	a4,a4,s5
    800013ae:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800013b2:	00008717          	auipc	a4,0x8
    800013b6:	cd670713          	addi	a4,a4,-810 # 80009088 <cpus+0x8>
    800013ba:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800013bc:	498d                	li	s3,3
        p->state = RUNNING;
    800013be:	4b11                	li	s6,4
        c->proc = p;
    800013c0:	079e                	slli	a5,a5,0x7
    800013c2:	00008a17          	auipc	s4,0x8
    800013c6:	c8ea0a13          	addi	s4,s4,-882 # 80009050 <pid_lock>
    800013ca:	9a3e                	add	s4,s4,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800013cc:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800013d0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800013d4:	10079073          	csrw	sstatus,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800013d8:	00008497          	auipc	s1,0x8
    800013dc:	0a848493          	addi	s1,s1,168 # 80009480 <proc>
    800013e0:	0000e917          	auipc	s2,0xe
    800013e4:	aa090913          	addi	s2,s2,-1376 # 8000ee80 <tickslock>
    800013e8:	a811                	j	800013fc <scheduler+0x74>
      release(&p->lock);
    800013ea:	8526                	mv	a0,s1
    800013ec:	00005097          	auipc	ra,0x5
    800013f0:	f26080e7          	jalr	-218(ra) # 80006312 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800013f4:	16848493          	addi	s1,s1,360
    800013f8:	fd248ae3          	beq	s1,s2,800013cc <scheduler+0x44>
      acquire(&p->lock);
    800013fc:	8526                	mv	a0,s1
    800013fe:	00005097          	auipc	ra,0x5
    80001402:	e64080e7          	jalr	-412(ra) # 80006262 <acquire>
      if(p->state == RUNNABLE) {
    80001406:	4c9c                	lw	a5,24(s1)
    80001408:	ff3791e3          	bne	a5,s3,800013ea <scheduler+0x62>
        p->state = RUNNING;
    8000140c:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001410:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001414:	06048593          	addi	a1,s1,96
    80001418:	8556                	mv	a0,s5
    8000141a:	00000097          	auipc	ra,0x0
    8000141e:	61a080e7          	jalr	1562(ra) # 80001a34 <swtch>
        c->proc = 0;
    80001422:	020a3823          	sd	zero,48(s4)
    80001426:	b7d1                	j	800013ea <scheduler+0x62>

0000000080001428 <sched>:
{
    80001428:	7179                	addi	sp,sp,-48
    8000142a:	f406                	sd	ra,40(sp)
    8000142c:	f022                	sd	s0,32(sp)
    8000142e:	ec26                	sd	s1,24(sp)
    80001430:	e84a                	sd	s2,16(sp)
    80001432:	e44e                	sd	s3,8(sp)
    80001434:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001436:	00000097          	auipc	ra,0x0
    8000143a:	a3e080e7          	jalr	-1474(ra) # 80000e74 <myproc>
    8000143e:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001440:	00005097          	auipc	ra,0x5
    80001444:	da8080e7          	jalr	-600(ra) # 800061e8 <holding>
    80001448:	c93d                	beqz	a0,800014be <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000144a:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000144c:	2781                	sext.w	a5,a5
    8000144e:	079e                	slli	a5,a5,0x7
    80001450:	00008717          	auipc	a4,0x8
    80001454:	c0070713          	addi	a4,a4,-1024 # 80009050 <pid_lock>
    80001458:	97ba                	add	a5,a5,a4
    8000145a:	0a87a703          	lw	a4,168(a5)
    8000145e:	4785                	li	a5,1
    80001460:	06f71763          	bne	a4,a5,800014ce <sched+0xa6>
  if(p->state == RUNNING)
    80001464:	4c98                	lw	a4,24(s1)
    80001466:	4791                	li	a5,4
    80001468:	06f70b63          	beq	a4,a5,800014de <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000146c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001470:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001472:	efb5                	bnez	a5,800014ee <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001474:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001476:	00008917          	auipc	s2,0x8
    8000147a:	bda90913          	addi	s2,s2,-1062 # 80009050 <pid_lock>
    8000147e:	2781                	sext.w	a5,a5
    80001480:	079e                	slli	a5,a5,0x7
    80001482:	97ca                	add	a5,a5,s2
    80001484:	0ac7a983          	lw	s3,172(a5)
    80001488:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    8000148a:	2781                	sext.w	a5,a5
    8000148c:	079e                	slli	a5,a5,0x7
    8000148e:	00008597          	auipc	a1,0x8
    80001492:	bfa58593          	addi	a1,a1,-1030 # 80009088 <cpus+0x8>
    80001496:	95be                	add	a1,a1,a5
    80001498:	06048513          	addi	a0,s1,96
    8000149c:	00000097          	auipc	ra,0x0
    800014a0:	598080e7          	jalr	1432(ra) # 80001a34 <swtch>
    800014a4:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800014a6:	2781                	sext.w	a5,a5
    800014a8:	079e                	slli	a5,a5,0x7
    800014aa:	993e                	add	s2,s2,a5
    800014ac:	0b392623          	sw	s3,172(s2)
}
    800014b0:	70a2                	ld	ra,40(sp)
    800014b2:	7402                	ld	s0,32(sp)
    800014b4:	64e2                	ld	s1,24(sp)
    800014b6:	6942                	ld	s2,16(sp)
    800014b8:	69a2                	ld	s3,8(sp)
    800014ba:	6145                	addi	sp,sp,48
    800014bc:	8082                	ret
    panic("sched p->lock");
    800014be:	00007517          	auipc	a0,0x7
    800014c2:	cda50513          	addi	a0,a0,-806 # 80008198 <etext+0x198>
    800014c6:	00005097          	auipc	ra,0x5
    800014ca:	81c080e7          	jalr	-2020(ra) # 80005ce2 <panic>
    panic("sched locks");
    800014ce:	00007517          	auipc	a0,0x7
    800014d2:	cda50513          	addi	a0,a0,-806 # 800081a8 <etext+0x1a8>
    800014d6:	00005097          	auipc	ra,0x5
    800014da:	80c080e7          	jalr	-2036(ra) # 80005ce2 <panic>
    panic("sched running");
    800014de:	00007517          	auipc	a0,0x7
    800014e2:	cda50513          	addi	a0,a0,-806 # 800081b8 <etext+0x1b8>
    800014e6:	00004097          	auipc	ra,0x4
    800014ea:	7fc080e7          	jalr	2044(ra) # 80005ce2 <panic>
    panic("sched interruptible");
    800014ee:	00007517          	auipc	a0,0x7
    800014f2:	cda50513          	addi	a0,a0,-806 # 800081c8 <etext+0x1c8>
    800014f6:	00004097          	auipc	ra,0x4
    800014fa:	7ec080e7          	jalr	2028(ra) # 80005ce2 <panic>

00000000800014fe <yield>:
{
    800014fe:	1101                	addi	sp,sp,-32
    80001500:	ec06                	sd	ra,24(sp)
    80001502:	e822                	sd	s0,16(sp)
    80001504:	e426                	sd	s1,8(sp)
    80001506:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001508:	00000097          	auipc	ra,0x0
    8000150c:	96c080e7          	jalr	-1684(ra) # 80000e74 <myproc>
    80001510:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001512:	00005097          	auipc	ra,0x5
    80001516:	d50080e7          	jalr	-688(ra) # 80006262 <acquire>
  p->state = RUNNABLE;
    8000151a:	478d                	li	a5,3
    8000151c:	cc9c                	sw	a5,24(s1)
  sched();
    8000151e:	00000097          	auipc	ra,0x0
    80001522:	f0a080e7          	jalr	-246(ra) # 80001428 <sched>
  release(&p->lock);
    80001526:	8526                	mv	a0,s1
    80001528:	00005097          	auipc	ra,0x5
    8000152c:	dea080e7          	jalr	-534(ra) # 80006312 <release>
}
    80001530:	60e2                	ld	ra,24(sp)
    80001532:	6442                	ld	s0,16(sp)
    80001534:	64a2                	ld	s1,8(sp)
    80001536:	6105                	addi	sp,sp,32
    80001538:	8082                	ret

000000008000153a <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    8000153a:	7179                	addi	sp,sp,-48
    8000153c:	f406                	sd	ra,40(sp)
    8000153e:	f022                	sd	s0,32(sp)
    80001540:	ec26                	sd	s1,24(sp)
    80001542:	e84a                	sd	s2,16(sp)
    80001544:	e44e                	sd	s3,8(sp)
    80001546:	1800                	addi	s0,sp,48
    80001548:	89aa                	mv	s3,a0
    8000154a:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000154c:	00000097          	auipc	ra,0x0
    80001550:	928080e7          	jalr	-1752(ra) # 80000e74 <myproc>
    80001554:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001556:	00005097          	auipc	ra,0x5
    8000155a:	d0c080e7          	jalr	-756(ra) # 80006262 <acquire>
  release(lk);
    8000155e:	854a                	mv	a0,s2
    80001560:	00005097          	auipc	ra,0x5
    80001564:	db2080e7          	jalr	-590(ra) # 80006312 <release>

  // Go to sleep.
  p->chan = chan;
    80001568:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000156c:	4789                	li	a5,2
    8000156e:	cc9c                	sw	a5,24(s1)

  sched();
    80001570:	00000097          	auipc	ra,0x0
    80001574:	eb8080e7          	jalr	-328(ra) # 80001428 <sched>

  // Tidy up.
  p->chan = 0;
    80001578:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000157c:	8526                	mv	a0,s1
    8000157e:	00005097          	auipc	ra,0x5
    80001582:	d94080e7          	jalr	-620(ra) # 80006312 <release>
  acquire(lk);
    80001586:	854a                	mv	a0,s2
    80001588:	00005097          	auipc	ra,0x5
    8000158c:	cda080e7          	jalr	-806(ra) # 80006262 <acquire>
}
    80001590:	70a2                	ld	ra,40(sp)
    80001592:	7402                	ld	s0,32(sp)
    80001594:	64e2                	ld	s1,24(sp)
    80001596:	6942                	ld	s2,16(sp)
    80001598:	69a2                	ld	s3,8(sp)
    8000159a:	6145                	addi	sp,sp,48
    8000159c:	8082                	ret

000000008000159e <wait>:
{
    8000159e:	715d                	addi	sp,sp,-80
    800015a0:	e486                	sd	ra,72(sp)
    800015a2:	e0a2                	sd	s0,64(sp)
    800015a4:	fc26                	sd	s1,56(sp)
    800015a6:	f84a                	sd	s2,48(sp)
    800015a8:	f44e                	sd	s3,40(sp)
    800015aa:	f052                	sd	s4,32(sp)
    800015ac:	ec56                	sd	s5,24(sp)
    800015ae:	e85a                	sd	s6,16(sp)
    800015b0:	e45e                	sd	s7,8(sp)
    800015b2:	0880                	addi	s0,sp,80
    800015b4:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800015b6:	00000097          	auipc	ra,0x0
    800015ba:	8be080e7          	jalr	-1858(ra) # 80000e74 <myproc>
    800015be:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800015c0:	00008517          	auipc	a0,0x8
    800015c4:	aa850513          	addi	a0,a0,-1368 # 80009068 <wait_lock>
    800015c8:	00005097          	auipc	ra,0x5
    800015cc:	c9a080e7          	jalr	-870(ra) # 80006262 <acquire>
        if(np->state == ZOMBIE){
    800015d0:	4a15                	li	s4,5
        havekids = 1;
    800015d2:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    800015d4:	0000e997          	auipc	s3,0xe
    800015d8:	8ac98993          	addi	s3,s3,-1876 # 8000ee80 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800015dc:	00008b97          	auipc	s7,0x8
    800015e0:	a8cb8b93          	addi	s7,s7,-1396 # 80009068 <wait_lock>
    800015e4:	a875                	j	800016a0 <wait+0x102>
          pid = np->pid;
    800015e6:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    800015ea:	000b0e63          	beqz	s6,80001606 <wait+0x68>
    800015ee:	4691                	li	a3,4
    800015f0:	02c48613          	addi	a2,s1,44
    800015f4:	85da                	mv	a1,s6
    800015f6:	05093503          	ld	a0,80(s2)
    800015fa:	fffff097          	auipc	ra,0xfffff
    800015fe:	526080e7          	jalr	1318(ra) # 80000b20 <copyout>
    80001602:	04054063          	bltz	a0,80001642 <wait+0xa4>
          freeproc(np);
    80001606:	8526                	mv	a0,s1
    80001608:	00000097          	auipc	ra,0x0
    8000160c:	a1e080e7          	jalr	-1506(ra) # 80001026 <freeproc>
          release(&np->lock);
    80001610:	8526                	mv	a0,s1
    80001612:	00005097          	auipc	ra,0x5
    80001616:	d00080e7          	jalr	-768(ra) # 80006312 <release>
          release(&wait_lock);
    8000161a:	00008517          	auipc	a0,0x8
    8000161e:	a4e50513          	addi	a0,a0,-1458 # 80009068 <wait_lock>
    80001622:	00005097          	auipc	ra,0x5
    80001626:	cf0080e7          	jalr	-784(ra) # 80006312 <release>
}
    8000162a:	854e                	mv	a0,s3
    8000162c:	60a6                	ld	ra,72(sp)
    8000162e:	6406                	ld	s0,64(sp)
    80001630:	74e2                	ld	s1,56(sp)
    80001632:	7942                	ld	s2,48(sp)
    80001634:	79a2                	ld	s3,40(sp)
    80001636:	7a02                	ld	s4,32(sp)
    80001638:	6ae2                	ld	s5,24(sp)
    8000163a:	6b42                	ld	s6,16(sp)
    8000163c:	6ba2                	ld	s7,8(sp)
    8000163e:	6161                	addi	sp,sp,80
    80001640:	8082                	ret
            release(&np->lock);
    80001642:	8526                	mv	a0,s1
    80001644:	00005097          	auipc	ra,0x5
    80001648:	cce080e7          	jalr	-818(ra) # 80006312 <release>
            release(&wait_lock);
    8000164c:	00008517          	auipc	a0,0x8
    80001650:	a1c50513          	addi	a0,a0,-1508 # 80009068 <wait_lock>
    80001654:	00005097          	auipc	ra,0x5
    80001658:	cbe080e7          	jalr	-834(ra) # 80006312 <release>
            return -1;
    8000165c:	59fd                	li	s3,-1
    8000165e:	b7f1                	j	8000162a <wait+0x8c>
    for(np = proc; np < &proc[NPROC]; np++){
    80001660:	16848493          	addi	s1,s1,360
    80001664:	03348463          	beq	s1,s3,8000168c <wait+0xee>
      if(np->parent == p){
    80001668:	7c9c                	ld	a5,56(s1)
    8000166a:	ff279be3          	bne	a5,s2,80001660 <wait+0xc2>
        acquire(&np->lock);
    8000166e:	8526                	mv	a0,s1
    80001670:	00005097          	auipc	ra,0x5
    80001674:	bf2080e7          	jalr	-1038(ra) # 80006262 <acquire>
        if(np->state == ZOMBIE){
    80001678:	4c9c                	lw	a5,24(s1)
    8000167a:	f74786e3          	beq	a5,s4,800015e6 <wait+0x48>
        release(&np->lock);
    8000167e:	8526                	mv	a0,s1
    80001680:	00005097          	auipc	ra,0x5
    80001684:	c92080e7          	jalr	-878(ra) # 80006312 <release>
        havekids = 1;
    80001688:	8756                	mv	a4,s5
    8000168a:	bfd9                	j	80001660 <wait+0xc2>
    if(!havekids || p->killed){
    8000168c:	c305                	beqz	a4,800016ac <wait+0x10e>
    8000168e:	02892783          	lw	a5,40(s2)
    80001692:	ef89                	bnez	a5,800016ac <wait+0x10e>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001694:	85de                	mv	a1,s7
    80001696:	854a                	mv	a0,s2
    80001698:	00000097          	auipc	ra,0x0
    8000169c:	ea2080e7          	jalr	-350(ra) # 8000153a <sleep>
    havekids = 0;
    800016a0:	4701                	li	a4,0
    for(np = proc; np < &proc[NPROC]; np++){
    800016a2:	00008497          	auipc	s1,0x8
    800016a6:	dde48493          	addi	s1,s1,-546 # 80009480 <proc>
    800016aa:	bf7d                	j	80001668 <wait+0xca>
      release(&wait_lock);
    800016ac:	00008517          	auipc	a0,0x8
    800016b0:	9bc50513          	addi	a0,a0,-1604 # 80009068 <wait_lock>
    800016b4:	00005097          	auipc	ra,0x5
    800016b8:	c5e080e7          	jalr	-930(ra) # 80006312 <release>
      return -1;
    800016bc:	59fd                	li	s3,-1
    800016be:	b7b5                	j	8000162a <wait+0x8c>

00000000800016c0 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800016c0:	7139                	addi	sp,sp,-64
    800016c2:	fc06                	sd	ra,56(sp)
    800016c4:	f822                	sd	s0,48(sp)
    800016c6:	f426                	sd	s1,40(sp)
    800016c8:	f04a                	sd	s2,32(sp)
    800016ca:	ec4e                	sd	s3,24(sp)
    800016cc:	e852                	sd	s4,16(sp)
    800016ce:	e456                	sd	s5,8(sp)
    800016d0:	0080                	addi	s0,sp,64
    800016d2:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800016d4:	00008497          	auipc	s1,0x8
    800016d8:	dac48493          	addi	s1,s1,-596 # 80009480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800016dc:	4989                	li	s3,2
        p->state = RUNNABLE;
    800016de:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800016e0:	0000d917          	auipc	s2,0xd
    800016e4:	7a090913          	addi	s2,s2,1952 # 8000ee80 <tickslock>
    800016e8:	a811                	j	800016fc <wakeup+0x3c>
      }
      release(&p->lock);
    800016ea:	8526                	mv	a0,s1
    800016ec:	00005097          	auipc	ra,0x5
    800016f0:	c26080e7          	jalr	-986(ra) # 80006312 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800016f4:	16848493          	addi	s1,s1,360
    800016f8:	03248663          	beq	s1,s2,80001724 <wakeup+0x64>
    if(p != myproc()){
    800016fc:	fffff097          	auipc	ra,0xfffff
    80001700:	778080e7          	jalr	1912(ra) # 80000e74 <myproc>
    80001704:	fea488e3          	beq	s1,a0,800016f4 <wakeup+0x34>
      acquire(&p->lock);
    80001708:	8526                	mv	a0,s1
    8000170a:	00005097          	auipc	ra,0x5
    8000170e:	b58080e7          	jalr	-1192(ra) # 80006262 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001712:	4c9c                	lw	a5,24(s1)
    80001714:	fd379be3          	bne	a5,s3,800016ea <wakeup+0x2a>
    80001718:	709c                	ld	a5,32(s1)
    8000171a:	fd4798e3          	bne	a5,s4,800016ea <wakeup+0x2a>
        p->state = RUNNABLE;
    8000171e:	0154ac23          	sw	s5,24(s1)
    80001722:	b7e1                	j	800016ea <wakeup+0x2a>
    }
  }
}
    80001724:	70e2                	ld	ra,56(sp)
    80001726:	7442                	ld	s0,48(sp)
    80001728:	74a2                	ld	s1,40(sp)
    8000172a:	7902                	ld	s2,32(sp)
    8000172c:	69e2                	ld	s3,24(sp)
    8000172e:	6a42                	ld	s4,16(sp)
    80001730:	6aa2                	ld	s5,8(sp)
    80001732:	6121                	addi	sp,sp,64
    80001734:	8082                	ret

0000000080001736 <reparent>:
{
    80001736:	7179                	addi	sp,sp,-48
    80001738:	f406                	sd	ra,40(sp)
    8000173a:	f022                	sd	s0,32(sp)
    8000173c:	ec26                	sd	s1,24(sp)
    8000173e:	e84a                	sd	s2,16(sp)
    80001740:	e44e                	sd	s3,8(sp)
    80001742:	e052                	sd	s4,0(sp)
    80001744:	1800                	addi	s0,sp,48
    80001746:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001748:	00008497          	auipc	s1,0x8
    8000174c:	d3848493          	addi	s1,s1,-712 # 80009480 <proc>
      pp->parent = initproc;
    80001750:	00008a17          	auipc	s4,0x8
    80001754:	8c0a0a13          	addi	s4,s4,-1856 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001758:	0000d997          	auipc	s3,0xd
    8000175c:	72898993          	addi	s3,s3,1832 # 8000ee80 <tickslock>
    80001760:	a029                	j	8000176a <reparent+0x34>
    80001762:	16848493          	addi	s1,s1,360
    80001766:	01348d63          	beq	s1,s3,80001780 <reparent+0x4a>
    if(pp->parent == p){
    8000176a:	7c9c                	ld	a5,56(s1)
    8000176c:	ff279be3          	bne	a5,s2,80001762 <reparent+0x2c>
      pp->parent = initproc;
    80001770:	000a3503          	ld	a0,0(s4)
    80001774:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001776:	00000097          	auipc	ra,0x0
    8000177a:	f4a080e7          	jalr	-182(ra) # 800016c0 <wakeup>
    8000177e:	b7d5                	j	80001762 <reparent+0x2c>
}
    80001780:	70a2                	ld	ra,40(sp)
    80001782:	7402                	ld	s0,32(sp)
    80001784:	64e2                	ld	s1,24(sp)
    80001786:	6942                	ld	s2,16(sp)
    80001788:	69a2                	ld	s3,8(sp)
    8000178a:	6a02                	ld	s4,0(sp)
    8000178c:	6145                	addi	sp,sp,48
    8000178e:	8082                	ret

0000000080001790 <exit>:
{
    80001790:	7179                	addi	sp,sp,-48
    80001792:	f406                	sd	ra,40(sp)
    80001794:	f022                	sd	s0,32(sp)
    80001796:	ec26                	sd	s1,24(sp)
    80001798:	e84a                	sd	s2,16(sp)
    8000179a:	e44e                	sd	s3,8(sp)
    8000179c:	e052                	sd	s4,0(sp)
    8000179e:	1800                	addi	s0,sp,48
    800017a0:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800017a2:	fffff097          	auipc	ra,0xfffff
    800017a6:	6d2080e7          	jalr	1746(ra) # 80000e74 <myproc>
    800017aa:	89aa                	mv	s3,a0
  if(p == initproc)
    800017ac:	00008797          	auipc	a5,0x8
    800017b0:	8647b783          	ld	a5,-1948(a5) # 80009010 <initproc>
    800017b4:	0d050493          	addi	s1,a0,208
    800017b8:	15050913          	addi	s2,a0,336
    800017bc:	00a79d63          	bne	a5,a0,800017d6 <exit+0x46>
    panic("init exiting");
    800017c0:	00007517          	auipc	a0,0x7
    800017c4:	a2050513          	addi	a0,a0,-1504 # 800081e0 <etext+0x1e0>
    800017c8:	00004097          	auipc	ra,0x4
    800017cc:	51a080e7          	jalr	1306(ra) # 80005ce2 <panic>
  for(int fd = 0; fd < NOFILE; fd++){
    800017d0:	04a1                	addi	s1,s1,8
    800017d2:	01248b63          	beq	s1,s2,800017e8 <exit+0x58>
    if(p->ofile[fd]){
    800017d6:	6088                	ld	a0,0(s1)
    800017d8:	dd65                	beqz	a0,800017d0 <exit+0x40>
      fileclose(f);
    800017da:	00002097          	auipc	ra,0x2
    800017de:	20e080e7          	jalr	526(ra) # 800039e8 <fileclose>
      p->ofile[fd] = 0;
    800017e2:	0004b023          	sd	zero,0(s1)
    800017e6:	b7ed                	j	800017d0 <exit+0x40>
  begin_op();
    800017e8:	00002097          	auipc	ra,0x2
    800017ec:	d30080e7          	jalr	-720(ra) # 80003518 <begin_op>
  iput(p->cwd);
    800017f0:	1509b503          	ld	a0,336(s3)
    800017f4:	00001097          	auipc	ra,0x1
    800017f8:	4f0080e7          	jalr	1264(ra) # 80002ce4 <iput>
  end_op();
    800017fc:	00002097          	auipc	ra,0x2
    80001800:	d96080e7          	jalr	-618(ra) # 80003592 <end_op>
  p->cwd = 0;
    80001804:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001808:	00008497          	auipc	s1,0x8
    8000180c:	86048493          	addi	s1,s1,-1952 # 80009068 <wait_lock>
    80001810:	8526                	mv	a0,s1
    80001812:	00005097          	auipc	ra,0x5
    80001816:	a50080e7          	jalr	-1456(ra) # 80006262 <acquire>
  reparent(p);
    8000181a:	854e                	mv	a0,s3
    8000181c:	00000097          	auipc	ra,0x0
    80001820:	f1a080e7          	jalr	-230(ra) # 80001736 <reparent>
  wakeup(p->parent);
    80001824:	0389b503          	ld	a0,56(s3)
    80001828:	00000097          	auipc	ra,0x0
    8000182c:	e98080e7          	jalr	-360(ra) # 800016c0 <wakeup>
  acquire(&p->lock);
    80001830:	854e                	mv	a0,s3
    80001832:	00005097          	auipc	ra,0x5
    80001836:	a30080e7          	jalr	-1488(ra) # 80006262 <acquire>
  p->xstate = status;
    8000183a:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    8000183e:	4795                	li	a5,5
    80001840:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001844:	8526                	mv	a0,s1
    80001846:	00005097          	auipc	ra,0x5
    8000184a:	acc080e7          	jalr	-1332(ra) # 80006312 <release>
  sched();
    8000184e:	00000097          	auipc	ra,0x0
    80001852:	bda080e7          	jalr	-1062(ra) # 80001428 <sched>
  panic("zombie exit");
    80001856:	00007517          	auipc	a0,0x7
    8000185a:	99a50513          	addi	a0,a0,-1638 # 800081f0 <etext+0x1f0>
    8000185e:	00004097          	auipc	ra,0x4
    80001862:	484080e7          	jalr	1156(ra) # 80005ce2 <panic>

0000000080001866 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001866:	7179                	addi	sp,sp,-48
    80001868:	f406                	sd	ra,40(sp)
    8000186a:	f022                	sd	s0,32(sp)
    8000186c:	ec26                	sd	s1,24(sp)
    8000186e:	e84a                	sd	s2,16(sp)
    80001870:	e44e                	sd	s3,8(sp)
    80001872:	1800                	addi	s0,sp,48
    80001874:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001876:	00008497          	auipc	s1,0x8
    8000187a:	c0a48493          	addi	s1,s1,-1014 # 80009480 <proc>
    8000187e:	0000d997          	auipc	s3,0xd
    80001882:	60298993          	addi	s3,s3,1538 # 8000ee80 <tickslock>
    acquire(&p->lock);
    80001886:	8526                	mv	a0,s1
    80001888:	00005097          	auipc	ra,0x5
    8000188c:	9da080e7          	jalr	-1574(ra) # 80006262 <acquire>
    if(p->pid == pid){
    80001890:	589c                	lw	a5,48(s1)
    80001892:	01278d63          	beq	a5,s2,800018ac <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001896:	8526                	mv	a0,s1
    80001898:	00005097          	auipc	ra,0x5
    8000189c:	a7a080e7          	jalr	-1414(ra) # 80006312 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800018a0:	16848493          	addi	s1,s1,360
    800018a4:	ff3491e3          	bne	s1,s3,80001886 <kill+0x20>
  }
  return -1;
    800018a8:	557d                	li	a0,-1
    800018aa:	a829                	j	800018c4 <kill+0x5e>
      p->killed = 1;
    800018ac:	4785                	li	a5,1
    800018ae:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800018b0:	4c98                	lw	a4,24(s1)
    800018b2:	4789                	li	a5,2
    800018b4:	00f70f63          	beq	a4,a5,800018d2 <kill+0x6c>
      release(&p->lock);
    800018b8:	8526                	mv	a0,s1
    800018ba:	00005097          	auipc	ra,0x5
    800018be:	a58080e7          	jalr	-1448(ra) # 80006312 <release>
      return 0;
    800018c2:	4501                	li	a0,0
}
    800018c4:	70a2                	ld	ra,40(sp)
    800018c6:	7402                	ld	s0,32(sp)
    800018c8:	64e2                	ld	s1,24(sp)
    800018ca:	6942                	ld	s2,16(sp)
    800018cc:	69a2                	ld	s3,8(sp)
    800018ce:	6145                	addi	sp,sp,48
    800018d0:	8082                	ret
        p->state = RUNNABLE;
    800018d2:	478d                	li	a5,3
    800018d4:	cc9c                	sw	a5,24(s1)
    800018d6:	b7cd                	j	800018b8 <kill+0x52>

00000000800018d8 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800018d8:	7179                	addi	sp,sp,-48
    800018da:	f406                	sd	ra,40(sp)
    800018dc:	f022                	sd	s0,32(sp)
    800018de:	ec26                	sd	s1,24(sp)
    800018e0:	e84a                	sd	s2,16(sp)
    800018e2:	e44e                	sd	s3,8(sp)
    800018e4:	e052                	sd	s4,0(sp)
    800018e6:	1800                	addi	s0,sp,48
    800018e8:	84aa                	mv	s1,a0
    800018ea:	892e                	mv	s2,a1
    800018ec:	89b2                	mv	s3,a2
    800018ee:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800018f0:	fffff097          	auipc	ra,0xfffff
    800018f4:	584080e7          	jalr	1412(ra) # 80000e74 <myproc>
  if(user_dst){
    800018f8:	c08d                	beqz	s1,8000191a <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    800018fa:	86d2                	mv	a3,s4
    800018fc:	864e                	mv	a2,s3
    800018fe:	85ca                	mv	a1,s2
    80001900:	6928                	ld	a0,80(a0)
    80001902:	fffff097          	auipc	ra,0xfffff
    80001906:	21e080e7          	jalr	542(ra) # 80000b20 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    8000190a:	70a2                	ld	ra,40(sp)
    8000190c:	7402                	ld	s0,32(sp)
    8000190e:	64e2                	ld	s1,24(sp)
    80001910:	6942                	ld	s2,16(sp)
    80001912:	69a2                	ld	s3,8(sp)
    80001914:	6a02                	ld	s4,0(sp)
    80001916:	6145                	addi	sp,sp,48
    80001918:	8082                	ret
    memmove((char *)dst, src, len);
    8000191a:	000a061b          	sext.w	a2,s4
    8000191e:	85ce                	mv	a1,s3
    80001920:	854a                	mv	a0,s2
    80001922:	fffff097          	auipc	ra,0xfffff
    80001926:	8bc080e7          	jalr	-1860(ra) # 800001de <memmove>
    return 0;
    8000192a:	8526                	mv	a0,s1
    8000192c:	bff9                	j	8000190a <either_copyout+0x32>

000000008000192e <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8000192e:	7179                	addi	sp,sp,-48
    80001930:	f406                	sd	ra,40(sp)
    80001932:	f022                	sd	s0,32(sp)
    80001934:	ec26                	sd	s1,24(sp)
    80001936:	e84a                	sd	s2,16(sp)
    80001938:	e44e                	sd	s3,8(sp)
    8000193a:	e052                	sd	s4,0(sp)
    8000193c:	1800                	addi	s0,sp,48
    8000193e:	892a                	mv	s2,a0
    80001940:	84ae                	mv	s1,a1
    80001942:	89b2                	mv	s3,a2
    80001944:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001946:	fffff097          	auipc	ra,0xfffff
    8000194a:	52e080e7          	jalr	1326(ra) # 80000e74 <myproc>
  if(user_src){
    8000194e:	c08d                	beqz	s1,80001970 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001950:	86d2                	mv	a3,s4
    80001952:	864e                	mv	a2,s3
    80001954:	85ca                	mv	a1,s2
    80001956:	6928                	ld	a0,80(a0)
    80001958:	fffff097          	auipc	ra,0xfffff
    8000195c:	254080e7          	jalr	596(ra) # 80000bac <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001960:	70a2                	ld	ra,40(sp)
    80001962:	7402                	ld	s0,32(sp)
    80001964:	64e2                	ld	s1,24(sp)
    80001966:	6942                	ld	s2,16(sp)
    80001968:	69a2                	ld	s3,8(sp)
    8000196a:	6a02                	ld	s4,0(sp)
    8000196c:	6145                	addi	sp,sp,48
    8000196e:	8082                	ret
    memmove(dst, (char*)src, len);
    80001970:	000a061b          	sext.w	a2,s4
    80001974:	85ce                	mv	a1,s3
    80001976:	854a                	mv	a0,s2
    80001978:	fffff097          	auipc	ra,0xfffff
    8000197c:	866080e7          	jalr	-1946(ra) # 800001de <memmove>
    return 0;
    80001980:	8526                	mv	a0,s1
    80001982:	bff9                	j	80001960 <either_copyin+0x32>

0000000080001984 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001984:	715d                	addi	sp,sp,-80
    80001986:	e486                	sd	ra,72(sp)
    80001988:	e0a2                	sd	s0,64(sp)
    8000198a:	fc26                	sd	s1,56(sp)
    8000198c:	f84a                	sd	s2,48(sp)
    8000198e:	f44e                	sd	s3,40(sp)
    80001990:	f052                	sd	s4,32(sp)
    80001992:	ec56                	sd	s5,24(sp)
    80001994:	e85a                	sd	s6,16(sp)
    80001996:	e45e                	sd	s7,8(sp)
    80001998:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    8000199a:	00006517          	auipc	a0,0x6
    8000199e:	67e50513          	addi	a0,a0,1662 # 80008018 <etext+0x18>
    800019a2:	00004097          	auipc	ra,0x4
    800019a6:	38a080e7          	jalr	906(ra) # 80005d2c <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800019aa:	00008497          	auipc	s1,0x8
    800019ae:	c2e48493          	addi	s1,s1,-978 # 800095d8 <proc+0x158>
    800019b2:	0000d917          	auipc	s2,0xd
    800019b6:	62690913          	addi	s2,s2,1574 # 8000efd8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019ba:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800019bc:	00007997          	auipc	s3,0x7
    800019c0:	84498993          	addi	s3,s3,-1980 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    800019c4:	00007a97          	auipc	s5,0x7
    800019c8:	844a8a93          	addi	s5,s5,-1980 # 80008208 <etext+0x208>
    printf("\n");
    800019cc:	00006a17          	auipc	s4,0x6
    800019d0:	64ca0a13          	addi	s4,s4,1612 # 80008018 <etext+0x18>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019d4:	00007b97          	auipc	s7,0x7
    800019d8:	d2cb8b93          	addi	s7,s7,-724 # 80008700 <states.0>
    800019dc:	a00d                	j	800019fe <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    800019de:	ed86a583          	lw	a1,-296(a3)
    800019e2:	8556                	mv	a0,s5
    800019e4:	00004097          	auipc	ra,0x4
    800019e8:	348080e7          	jalr	840(ra) # 80005d2c <printf>
    printf("\n");
    800019ec:	8552                	mv	a0,s4
    800019ee:	00004097          	auipc	ra,0x4
    800019f2:	33e080e7          	jalr	830(ra) # 80005d2c <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800019f6:	16848493          	addi	s1,s1,360
    800019fa:	03248263          	beq	s1,s2,80001a1e <procdump+0x9a>
    if(p->state == UNUSED)
    800019fe:	86a6                	mv	a3,s1
    80001a00:	ec04a783          	lw	a5,-320(s1)
    80001a04:	dbed                	beqz	a5,800019f6 <procdump+0x72>
      state = "???";
    80001a06:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a08:	fcfb6be3          	bltu	s6,a5,800019de <procdump+0x5a>
    80001a0c:	02079713          	slli	a4,a5,0x20
    80001a10:	01d75793          	srli	a5,a4,0x1d
    80001a14:	97de                	add	a5,a5,s7
    80001a16:	6390                	ld	a2,0(a5)
    80001a18:	f279                	bnez	a2,800019de <procdump+0x5a>
      state = "???";
    80001a1a:	864e                	mv	a2,s3
    80001a1c:	b7c9                	j	800019de <procdump+0x5a>
  }
}
    80001a1e:	60a6                	ld	ra,72(sp)
    80001a20:	6406                	ld	s0,64(sp)
    80001a22:	74e2                	ld	s1,56(sp)
    80001a24:	7942                	ld	s2,48(sp)
    80001a26:	79a2                	ld	s3,40(sp)
    80001a28:	7a02                	ld	s4,32(sp)
    80001a2a:	6ae2                	ld	s5,24(sp)
    80001a2c:	6b42                	ld	s6,16(sp)
    80001a2e:	6ba2                	ld	s7,8(sp)
    80001a30:	6161                	addi	sp,sp,80
    80001a32:	8082                	ret

0000000080001a34 <swtch>:
    80001a34:	00153023          	sd	ra,0(a0)
    80001a38:	00253423          	sd	sp,8(a0)
    80001a3c:	e900                	sd	s0,16(a0)
    80001a3e:	ed04                	sd	s1,24(a0)
    80001a40:	03253023          	sd	s2,32(a0)
    80001a44:	03353423          	sd	s3,40(a0)
    80001a48:	03453823          	sd	s4,48(a0)
    80001a4c:	03553c23          	sd	s5,56(a0)
    80001a50:	05653023          	sd	s6,64(a0)
    80001a54:	05753423          	sd	s7,72(a0)
    80001a58:	05853823          	sd	s8,80(a0)
    80001a5c:	05953c23          	sd	s9,88(a0)
    80001a60:	07a53023          	sd	s10,96(a0)
    80001a64:	07b53423          	sd	s11,104(a0)
    80001a68:	0005b083          	ld	ra,0(a1)
    80001a6c:	0085b103          	ld	sp,8(a1)
    80001a70:	6980                	ld	s0,16(a1)
    80001a72:	6d84                	ld	s1,24(a1)
    80001a74:	0205b903          	ld	s2,32(a1)
    80001a78:	0285b983          	ld	s3,40(a1)
    80001a7c:	0305ba03          	ld	s4,48(a1)
    80001a80:	0385ba83          	ld	s5,56(a1)
    80001a84:	0405bb03          	ld	s6,64(a1)
    80001a88:	0485bb83          	ld	s7,72(a1)
    80001a8c:	0505bc03          	ld	s8,80(a1)
    80001a90:	0585bc83          	ld	s9,88(a1)
    80001a94:	0605bd03          	ld	s10,96(a1)
    80001a98:	0685bd83          	ld	s11,104(a1)
    80001a9c:	8082                	ret

0000000080001a9e <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001a9e:	1141                	addi	sp,sp,-16
    80001aa0:	e406                	sd	ra,8(sp)
    80001aa2:	e022                	sd	s0,0(sp)
    80001aa4:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001aa6:	00006597          	auipc	a1,0x6
    80001aaa:	79a58593          	addi	a1,a1,1946 # 80008240 <etext+0x240>
    80001aae:	0000d517          	auipc	a0,0xd
    80001ab2:	3d250513          	addi	a0,a0,978 # 8000ee80 <tickslock>
    80001ab6:	00004097          	auipc	ra,0x4
    80001aba:	718080e7          	jalr	1816(ra) # 800061ce <initlock>
}
    80001abe:	60a2                	ld	ra,8(sp)
    80001ac0:	6402                	ld	s0,0(sp)
    80001ac2:	0141                	addi	sp,sp,16
    80001ac4:	8082                	ret

0000000080001ac6 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001ac6:	1141                	addi	sp,sp,-16
    80001ac8:	e406                	sd	ra,8(sp)
    80001aca:	e022                	sd	s0,0(sp)
    80001acc:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001ace:	00003797          	auipc	a5,0x3
    80001ad2:	64278793          	addi	a5,a5,1602 # 80005110 <kernelvec>
    80001ad6:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001ada:	60a2                	ld	ra,8(sp)
    80001adc:	6402                	ld	s0,0(sp)
    80001ade:	0141                	addi	sp,sp,16
    80001ae0:	8082                	ret

0000000080001ae2 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001ae2:	1141                	addi	sp,sp,-16
    80001ae4:	e406                	sd	ra,8(sp)
    80001ae6:	e022                	sd	s0,0(sp)
    80001ae8:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001aea:	fffff097          	auipc	ra,0xfffff
    80001aee:	38a080e7          	jalr	906(ra) # 80000e74 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001af2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001af6:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001af8:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001afc:	00005697          	auipc	a3,0x5
    80001b00:	50468693          	addi	a3,a3,1284 # 80007000 <_trampoline>
    80001b04:	00005717          	auipc	a4,0x5
    80001b08:	4fc70713          	addi	a4,a4,1276 # 80007000 <_trampoline>
    80001b0c:	8f15                	sub	a4,a4,a3
    80001b0e:	040007b7          	lui	a5,0x4000
    80001b12:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001b14:	07b2                	slli	a5,a5,0xc
    80001b16:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b18:	10571073          	csrw	stvec,a4

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001b1c:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001b1e:	18002673          	csrr	a2,satp
    80001b22:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001b24:	6d30                	ld	a2,88(a0)
    80001b26:	6138                	ld	a4,64(a0)
    80001b28:	6585                	lui	a1,0x1
    80001b2a:	972e                	add	a4,a4,a1
    80001b2c:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001b2e:	6d38                	ld	a4,88(a0)
    80001b30:	00000617          	auipc	a2,0x0
    80001b34:	14060613          	addi	a2,a2,320 # 80001c70 <usertrap>
    80001b38:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001b3a:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001b3c:	8612                	mv	a2,tp
    80001b3e:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b40:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001b44:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001b48:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b4c:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001b50:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001b52:	6f18                	ld	a4,24(a4)
    80001b54:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001b58:	692c                	ld	a1,80(a0)
    80001b5a:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001b5c:	00005717          	auipc	a4,0x5
    80001b60:	53470713          	addi	a4,a4,1332 # 80007090 <userret>
    80001b64:	8f15                	sub	a4,a4,a3
    80001b66:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001b68:	577d                	li	a4,-1
    80001b6a:	177e                	slli	a4,a4,0x3f
    80001b6c:	8dd9                	or	a1,a1,a4
    80001b6e:	02000537          	lui	a0,0x2000
    80001b72:	157d                	addi	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    80001b74:	0536                	slli	a0,a0,0xd
    80001b76:	9782                	jalr	a5
}
    80001b78:	60a2                	ld	ra,8(sp)
    80001b7a:	6402                	ld	s0,0(sp)
    80001b7c:	0141                	addi	sp,sp,16
    80001b7e:	8082                	ret

0000000080001b80 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001b80:	1101                	addi	sp,sp,-32
    80001b82:	ec06                	sd	ra,24(sp)
    80001b84:	e822                	sd	s0,16(sp)
    80001b86:	e426                	sd	s1,8(sp)
    80001b88:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001b8a:	0000d497          	auipc	s1,0xd
    80001b8e:	2f648493          	addi	s1,s1,758 # 8000ee80 <tickslock>
    80001b92:	8526                	mv	a0,s1
    80001b94:	00004097          	auipc	ra,0x4
    80001b98:	6ce080e7          	jalr	1742(ra) # 80006262 <acquire>
  ticks++;
    80001b9c:	00007517          	auipc	a0,0x7
    80001ba0:	47c50513          	addi	a0,a0,1148 # 80009018 <ticks>
    80001ba4:	411c                	lw	a5,0(a0)
    80001ba6:	2785                	addiw	a5,a5,1
    80001ba8:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001baa:	00000097          	auipc	ra,0x0
    80001bae:	b16080e7          	jalr	-1258(ra) # 800016c0 <wakeup>
  release(&tickslock);
    80001bb2:	8526                	mv	a0,s1
    80001bb4:	00004097          	auipc	ra,0x4
    80001bb8:	75e080e7          	jalr	1886(ra) # 80006312 <release>
}
    80001bbc:	60e2                	ld	ra,24(sp)
    80001bbe:	6442                	ld	s0,16(sp)
    80001bc0:	64a2                	ld	s1,8(sp)
    80001bc2:	6105                	addi	sp,sp,32
    80001bc4:	8082                	ret

0000000080001bc6 <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001bc6:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001bca:	4501                	li	a0,0
  if((scause & 0x8000000000000000L) &&
    80001bcc:	0a07d163          	bgez	a5,80001c6e <devintr+0xa8>
{
    80001bd0:	1101                	addi	sp,sp,-32
    80001bd2:	ec06                	sd	ra,24(sp)
    80001bd4:	e822                	sd	s0,16(sp)
    80001bd6:	1000                	addi	s0,sp,32
     (scause & 0xff) == 9){
    80001bd8:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    80001bdc:	46a5                	li	a3,9
    80001bde:	00d70c63          	beq	a4,a3,80001bf6 <devintr+0x30>
  } else if(scause == 0x8000000000000001L){
    80001be2:	577d                	li	a4,-1
    80001be4:	177e                	slli	a4,a4,0x3f
    80001be6:	0705                	addi	a4,a4,1
    return 0;
    80001be8:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001bea:	06e78163          	beq	a5,a4,80001c4c <devintr+0x86>
  }
}
    80001bee:	60e2                	ld	ra,24(sp)
    80001bf0:	6442                	ld	s0,16(sp)
    80001bf2:	6105                	addi	sp,sp,32
    80001bf4:	8082                	ret
    80001bf6:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80001bf8:	00003097          	auipc	ra,0x3
    80001bfc:	624080e7          	jalr	1572(ra) # 8000521c <plic_claim>
    80001c00:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001c02:	47a9                	li	a5,10
    80001c04:	00f50963          	beq	a0,a5,80001c16 <devintr+0x50>
    } else if(irq == VIRTIO0_IRQ){
    80001c08:	4785                	li	a5,1
    80001c0a:	00f50b63          	beq	a0,a5,80001c20 <devintr+0x5a>
    return 1;
    80001c0e:	4505                	li	a0,1
    } else if(irq){
    80001c10:	ec89                	bnez	s1,80001c2a <devintr+0x64>
    80001c12:	64a2                	ld	s1,8(sp)
    80001c14:	bfe9                	j	80001bee <devintr+0x28>
      uartintr();
    80001c16:	00004097          	auipc	ra,0x4
    80001c1a:	568080e7          	jalr	1384(ra) # 8000617e <uartintr>
    if(irq)
    80001c1e:	a839                	j	80001c3c <devintr+0x76>
      virtio_disk_intr();
    80001c20:	00004097          	auipc	ra,0x4
    80001c24:	ab6080e7          	jalr	-1354(ra) # 800056d6 <virtio_disk_intr>
    if(irq)
    80001c28:	a811                	j	80001c3c <devintr+0x76>
      printf("unexpected interrupt irq=%d\n", irq);
    80001c2a:	85a6                	mv	a1,s1
    80001c2c:	00006517          	auipc	a0,0x6
    80001c30:	61c50513          	addi	a0,a0,1564 # 80008248 <etext+0x248>
    80001c34:	00004097          	auipc	ra,0x4
    80001c38:	0f8080e7          	jalr	248(ra) # 80005d2c <printf>
      plic_complete(irq);
    80001c3c:	8526                	mv	a0,s1
    80001c3e:	00003097          	auipc	ra,0x3
    80001c42:	602080e7          	jalr	1538(ra) # 80005240 <plic_complete>
    return 1;
    80001c46:	4505                	li	a0,1
    80001c48:	64a2                	ld	s1,8(sp)
    80001c4a:	b755                	j	80001bee <devintr+0x28>
    if(cpuid() == 0){
    80001c4c:	fffff097          	auipc	ra,0xfffff
    80001c50:	1f4080e7          	jalr	500(ra) # 80000e40 <cpuid>
    80001c54:	c901                	beqz	a0,80001c64 <devintr+0x9e>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001c56:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001c5a:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001c5c:	14479073          	csrw	sip,a5
    return 2;
    80001c60:	4509                	li	a0,2
    80001c62:	b771                	j	80001bee <devintr+0x28>
      clockintr();
    80001c64:	00000097          	auipc	ra,0x0
    80001c68:	f1c080e7          	jalr	-228(ra) # 80001b80 <clockintr>
    80001c6c:	b7ed                	j	80001c56 <devintr+0x90>
}
    80001c6e:	8082                	ret

0000000080001c70 <usertrap>:
{
    80001c70:	7139                	addi	sp,sp,-64
    80001c72:	fc06                	sd	ra,56(sp)
    80001c74:	f822                	sd	s0,48(sp)
    80001c76:	0080                	addi	s0,sp,64
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c78:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001c7c:	1007f793          	andi	a5,a5,256
    80001c80:	e7a5                	bnez	a5,80001ce8 <usertrap+0x78>
    80001c82:	f426                	sd	s1,40(sp)
    80001c84:	f04a                	sd	s2,32(sp)
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c86:	00003797          	auipc	a5,0x3
    80001c8a:	48a78793          	addi	a5,a5,1162 # 80005110 <kernelvec>
    80001c8e:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001c92:	fffff097          	auipc	ra,0xfffff
    80001c96:	1e2080e7          	jalr	482(ra) # 80000e74 <myproc>
    80001c9a:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001c9c:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001c9e:	14102773          	csrr	a4,sepc
    80001ca2:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ca4:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001ca8:	47a1                	li	a5,8
    80001caa:	06f71263          	bne	a4,a5,80001d0e <usertrap+0x9e>
    if(p->killed)
    80001cae:	551c                	lw	a5,40(a0)
    80001cb0:	eba9                	bnez	a5,80001d02 <usertrap+0x92>
    p->trapframe->epc += 4;
    80001cb2:	6cb8                	ld	a4,88(s1)
    80001cb4:	6f1c                	ld	a5,24(a4)
    80001cb6:	0791                	addi	a5,a5,4
    80001cb8:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cba:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001cbe:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001cc2:	10079073          	csrw	sstatus,a5
    syscall();
    80001cc6:	00000097          	auipc	ra,0x0
    80001cca:	380080e7          	jalr	896(ra) # 80002046 <syscall>
  if(p->killed)
    80001cce:	549c                	lw	a5,40(s1)
    80001cd0:	12079263          	bnez	a5,80001df4 <usertrap+0x184>
  usertrapret();
    80001cd4:	00000097          	auipc	ra,0x0
    80001cd8:	e0e080e7          	jalr	-498(ra) # 80001ae2 <usertrapret>
    80001cdc:	74a2                	ld	s1,40(sp)
    80001cde:	7902                	ld	s2,32(sp)
}
    80001ce0:	70e2                	ld	ra,56(sp)
    80001ce2:	7442                	ld	s0,48(sp)
    80001ce4:	6121                	addi	sp,sp,64
    80001ce6:	8082                	ret
    80001ce8:	f426                	sd	s1,40(sp)
    80001cea:	f04a                	sd	s2,32(sp)
    80001cec:	ec4e                	sd	s3,24(sp)
    80001cee:	e852                	sd	s4,16(sp)
    80001cf0:	e456                	sd	s5,8(sp)
    panic("usertrap: not from user mode");
    80001cf2:	00006517          	auipc	a0,0x6
    80001cf6:	57650513          	addi	a0,a0,1398 # 80008268 <etext+0x268>
    80001cfa:	00004097          	auipc	ra,0x4
    80001cfe:	fe8080e7          	jalr	-24(ra) # 80005ce2 <panic>
      exit(-1);
    80001d02:	557d                	li	a0,-1
    80001d04:	00000097          	auipc	ra,0x0
    80001d08:	a8c080e7          	jalr	-1396(ra) # 80001790 <exit>
    80001d0c:	b75d                	j	80001cb2 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001d0e:	00000097          	auipc	ra,0x0
    80001d12:	eb8080e7          	jalr	-328(ra) # 80001bc6 <devintr>
    80001d16:	892a                	mv	s2,a0
    80001d18:	e979                	bnez	a0,80001dee <usertrap+0x17e>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d1a:	14202773          	csrr	a4,scause
  } else if(r_scause() == 13 || r_scause() == 15){ // 13: load page fault, 15: store page fault
    80001d1e:	47b5                	li	a5,13
    80001d20:	00f70763          	beq	a4,a5,80001d2e <usertrap+0xbe>
    80001d24:	14202773          	csrr	a4,scause
    80001d28:	47bd                	li	a5,15
    80001d2a:	08f71a63          	bne	a4,a5,80001dbe <usertrap+0x14e>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001d2e:	143025f3          	csrr	a1,stval
    if(va >= MAXVA) {
    80001d32:	57fd                	li	a5,-1
    80001d34:	83e9                	srli	a5,a5,0x1a
    80001d36:	02b7f163          	bgeu	a5,a1,80001d58 <usertrap+0xe8>
        p->killed = 1;
    80001d3a:	4785                	li	a5,1
    80001d3c:	d49c                	sw	a5,40(s1)
    exit(-1);
    80001d3e:	557d                	li	a0,-1
    80001d40:	00000097          	auipc	ra,0x0
    80001d44:	a50080e7          	jalr	-1456(ra) # 80001790 <exit>
  if(which_dev == 2)
    80001d48:	4789                	li	a5,2
    80001d4a:	f8f915e3          	bne	s2,a5,80001cd4 <usertrap+0x64>
    yield();
    80001d4e:	fffff097          	auipc	ra,0xfffff
    80001d52:	7b0080e7          	jalr	1968(ra) # 800014fe <yield>
    80001d56:	bfbd                	j	80001cd4 <usertrap+0x64>
    80001d58:	ec4e                	sd	s3,24(sp)
      pte_t *pte = walk(p->pagetable, va, 0);
    80001d5a:	4601                	li	a2,0
    80001d5c:	68a8                	ld	a0,80(s1)
    80001d5e:	ffffe097          	auipc	ra,0xffffe
    80001d62:	714080e7          	jalr	1812(ra) # 80000472 <walk>
    80001d66:	89aa                	mv	s3,a0
      if(pte && (*pte & PTE_V) && (*pte & PTE_U) && !(*pte & PTE_W)) {
    80001d68:	c941                	beqz	a0,80001df8 <usertrap+0x188>
    80001d6a:	e852                	sd	s4,16(sp)
    80001d6c:	00053a03          	ld	s4,0(a0)
    80001d70:	015a7713          	andi	a4,s4,21
    80001d74:	47c5                	li	a5,17
    80001d76:	00f70563          	beq	a4,a5,80001d80 <usertrap+0x110>
    80001d7a:	69e2                	ld	s3,24(sp)
    80001d7c:	6a42                	ld	s4,16(sp)
    80001d7e:	bf75                	j	80001d3a <usertrap+0xca>
    80001d80:	e456                	sd	s5,8(sp)
        if((mem = kalloc()) == 0){
    80001d82:	ffffe097          	auipc	ra,0xffffe
    80001d86:	398080e7          	jalr	920(ra) # 8000011a <kalloc>
    80001d8a:	8aaa                	mv	s5,a0
    80001d8c:	c925                	beqz	a0,80001dfc <usertrap+0x18c>
        uint64 pa = PTE2PA(*pte);
    80001d8e:	00aa5593          	srli	a1,s4,0xa
          memmove(mem, (char*)pa, PGSIZE);
    80001d92:	6605                	lui	a2,0x1
    80001d94:	05b2                	slli	a1,a1,0xc
    80001d96:	ffffe097          	auipc	ra,0xffffe
    80001d9a:	448080e7          	jalr	1096(ra) # 800001de <memmove>
          uint flags = PTE_FLAGS(*pte);
    80001d9e:	0009b703          	ld	a4,0(s3)
    80001da2:	3ff77713          	andi	a4,a4,1023
          *pte = PA2PTE((uint64)mem) | flags;
    80001da6:	00cad793          	srli	a5,s5,0xc
    80001daa:	07aa                	slli	a5,a5,0xa
    80001dac:	00476713          	ori	a4,a4,4
    80001db0:	8fd9                	or	a5,a5,a4
    80001db2:	00f9b023          	sd	a5,0(s3)
    80001db6:	69e2                	ld	s3,24(sp)
    80001db8:	6a42                	ld	s4,16(sp)
    80001dba:	6aa2                	ld	s5,8(sp)
    80001dbc:	bf09                	j	80001cce <usertrap+0x5e>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001dbe:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001dc2:	5890                	lw	a2,48(s1)
    80001dc4:	00006517          	auipc	a0,0x6
    80001dc8:	4c450513          	addi	a0,a0,1220 # 80008288 <etext+0x288>
    80001dcc:	00004097          	auipc	ra,0x4
    80001dd0:	f60080e7          	jalr	-160(ra) # 80005d2c <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001dd4:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001dd8:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001ddc:	00006517          	auipc	a0,0x6
    80001de0:	4dc50513          	addi	a0,a0,1244 # 800082b8 <etext+0x2b8>
    80001de4:	00004097          	auipc	ra,0x4
    80001de8:	f48080e7          	jalr	-184(ra) # 80005d2c <printf>
    p->killed = 1;
    80001dec:	b7b9                	j	80001d3a <usertrap+0xca>
  if(p->killed)
    80001dee:	549c                	lw	a5,40(s1)
    80001df0:	dfa1                	beqz	a5,80001d48 <usertrap+0xd8>
    80001df2:	b7b1                	j	80001d3e <usertrap+0xce>
    80001df4:	4901                	li	s2,0
    80001df6:	b7a1                	j	80001d3e <usertrap+0xce>
    80001df8:	69e2                	ld	s3,24(sp)
    80001dfa:	b781                	j	80001d3a <usertrap+0xca>
    80001dfc:	69e2                	ld	s3,24(sp)
    80001dfe:	6a42                	ld	s4,16(sp)
    80001e00:	6aa2                	ld	s5,8(sp)
    80001e02:	bf25                	j	80001d3a <usertrap+0xca>

0000000080001e04 <kerneltrap>:
{
    80001e04:	7179                	addi	sp,sp,-48
    80001e06:	f406                	sd	ra,40(sp)
    80001e08:	f022                	sd	s0,32(sp)
    80001e0a:	ec26                	sd	s1,24(sp)
    80001e0c:	e84a                	sd	s2,16(sp)
    80001e0e:	e44e                	sd	s3,8(sp)
    80001e10:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e12:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e16:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e1a:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001e1e:	1004f793          	andi	a5,s1,256
    80001e22:	cb85                	beqz	a5,80001e52 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e24:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001e28:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001e2a:	ef85                	bnez	a5,80001e62 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001e2c:	00000097          	auipc	ra,0x0
    80001e30:	d9a080e7          	jalr	-614(ra) # 80001bc6 <devintr>
    80001e34:	cd1d                	beqz	a0,80001e72 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e36:	4789                	li	a5,2
    80001e38:	06f50a63          	beq	a0,a5,80001eac <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001e3c:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e40:	10049073          	csrw	sstatus,s1
}
    80001e44:	70a2                	ld	ra,40(sp)
    80001e46:	7402                	ld	s0,32(sp)
    80001e48:	64e2                	ld	s1,24(sp)
    80001e4a:	6942                	ld	s2,16(sp)
    80001e4c:	69a2                	ld	s3,8(sp)
    80001e4e:	6145                	addi	sp,sp,48
    80001e50:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001e52:	00006517          	auipc	a0,0x6
    80001e56:	48650513          	addi	a0,a0,1158 # 800082d8 <etext+0x2d8>
    80001e5a:	00004097          	auipc	ra,0x4
    80001e5e:	e88080e7          	jalr	-376(ra) # 80005ce2 <panic>
    panic("kerneltrap: interrupts enabled");
    80001e62:	00006517          	auipc	a0,0x6
    80001e66:	49e50513          	addi	a0,a0,1182 # 80008300 <etext+0x300>
    80001e6a:	00004097          	auipc	ra,0x4
    80001e6e:	e78080e7          	jalr	-392(ra) # 80005ce2 <panic>
    printf("scause %p\n", scause);
    80001e72:	85ce                	mv	a1,s3
    80001e74:	00006517          	auipc	a0,0x6
    80001e78:	4ac50513          	addi	a0,a0,1196 # 80008320 <etext+0x320>
    80001e7c:	00004097          	auipc	ra,0x4
    80001e80:	eb0080e7          	jalr	-336(ra) # 80005d2c <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e84:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e88:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e8c:	00006517          	auipc	a0,0x6
    80001e90:	4a450513          	addi	a0,a0,1188 # 80008330 <etext+0x330>
    80001e94:	00004097          	auipc	ra,0x4
    80001e98:	e98080e7          	jalr	-360(ra) # 80005d2c <printf>
    panic("kerneltrap");
    80001e9c:	00006517          	auipc	a0,0x6
    80001ea0:	4ac50513          	addi	a0,a0,1196 # 80008348 <etext+0x348>
    80001ea4:	00004097          	auipc	ra,0x4
    80001ea8:	e3e080e7          	jalr	-450(ra) # 80005ce2 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001eac:	fffff097          	auipc	ra,0xfffff
    80001eb0:	fc8080e7          	jalr	-56(ra) # 80000e74 <myproc>
    80001eb4:	d541                	beqz	a0,80001e3c <kerneltrap+0x38>
    80001eb6:	fffff097          	auipc	ra,0xfffff
    80001eba:	fbe080e7          	jalr	-66(ra) # 80000e74 <myproc>
    80001ebe:	4d18                	lw	a4,24(a0)
    80001ec0:	4791                	li	a5,4
    80001ec2:	f6f71de3          	bne	a4,a5,80001e3c <kerneltrap+0x38>
    yield();
    80001ec6:	fffff097          	auipc	ra,0xfffff
    80001eca:	638080e7          	jalr	1592(ra) # 800014fe <yield>
    80001ece:	b7bd                	j	80001e3c <kerneltrap+0x38>

0000000080001ed0 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001ed0:	1101                	addi	sp,sp,-32
    80001ed2:	ec06                	sd	ra,24(sp)
    80001ed4:	e822                	sd	s0,16(sp)
    80001ed6:	e426                	sd	s1,8(sp)
    80001ed8:	1000                	addi	s0,sp,32
    80001eda:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001edc:	fffff097          	auipc	ra,0xfffff
    80001ee0:	f98080e7          	jalr	-104(ra) # 80000e74 <myproc>
  switch (n) {
    80001ee4:	4795                	li	a5,5
    80001ee6:	0497e163          	bltu	a5,s1,80001f28 <argraw+0x58>
    80001eea:	048a                	slli	s1,s1,0x2
    80001eec:	00007717          	auipc	a4,0x7
    80001ef0:	84470713          	addi	a4,a4,-1980 # 80008730 <states.0+0x30>
    80001ef4:	94ba                	add	s1,s1,a4
    80001ef6:	409c                	lw	a5,0(s1)
    80001ef8:	97ba                	add	a5,a5,a4
    80001efa:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001efc:	6d3c                	ld	a5,88(a0)
    80001efe:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001f00:	60e2                	ld	ra,24(sp)
    80001f02:	6442                	ld	s0,16(sp)
    80001f04:	64a2                	ld	s1,8(sp)
    80001f06:	6105                	addi	sp,sp,32
    80001f08:	8082                	ret
    return p->trapframe->a1;
    80001f0a:	6d3c                	ld	a5,88(a0)
    80001f0c:	7fa8                	ld	a0,120(a5)
    80001f0e:	bfcd                	j	80001f00 <argraw+0x30>
    return p->trapframe->a2;
    80001f10:	6d3c                	ld	a5,88(a0)
    80001f12:	63c8                	ld	a0,128(a5)
    80001f14:	b7f5                	j	80001f00 <argraw+0x30>
    return p->trapframe->a3;
    80001f16:	6d3c                	ld	a5,88(a0)
    80001f18:	67c8                	ld	a0,136(a5)
    80001f1a:	b7dd                	j	80001f00 <argraw+0x30>
    return p->trapframe->a4;
    80001f1c:	6d3c                	ld	a5,88(a0)
    80001f1e:	6bc8                	ld	a0,144(a5)
    80001f20:	b7c5                	j	80001f00 <argraw+0x30>
    return p->trapframe->a5;
    80001f22:	6d3c                	ld	a5,88(a0)
    80001f24:	6fc8                	ld	a0,152(a5)
    80001f26:	bfe9                	j	80001f00 <argraw+0x30>
  panic("argraw");
    80001f28:	00006517          	auipc	a0,0x6
    80001f2c:	43050513          	addi	a0,a0,1072 # 80008358 <etext+0x358>
    80001f30:	00004097          	auipc	ra,0x4
    80001f34:	db2080e7          	jalr	-590(ra) # 80005ce2 <panic>

0000000080001f38 <fetchaddr>:
{
    80001f38:	1101                	addi	sp,sp,-32
    80001f3a:	ec06                	sd	ra,24(sp)
    80001f3c:	e822                	sd	s0,16(sp)
    80001f3e:	e426                	sd	s1,8(sp)
    80001f40:	e04a                	sd	s2,0(sp)
    80001f42:	1000                	addi	s0,sp,32
    80001f44:	84aa                	mv	s1,a0
    80001f46:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001f48:	fffff097          	auipc	ra,0xfffff
    80001f4c:	f2c080e7          	jalr	-212(ra) # 80000e74 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80001f50:	653c                	ld	a5,72(a0)
    80001f52:	02f4f863          	bgeu	s1,a5,80001f82 <fetchaddr+0x4a>
    80001f56:	00848713          	addi	a4,s1,8
    80001f5a:	02e7e663          	bltu	a5,a4,80001f86 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001f5e:	46a1                	li	a3,8
    80001f60:	8626                	mv	a2,s1
    80001f62:	85ca                	mv	a1,s2
    80001f64:	6928                	ld	a0,80(a0)
    80001f66:	fffff097          	auipc	ra,0xfffff
    80001f6a:	c46080e7          	jalr	-954(ra) # 80000bac <copyin>
    80001f6e:	00a03533          	snez	a0,a0
    80001f72:	40a0053b          	negw	a0,a0
}
    80001f76:	60e2                	ld	ra,24(sp)
    80001f78:	6442                	ld	s0,16(sp)
    80001f7a:	64a2                	ld	s1,8(sp)
    80001f7c:	6902                	ld	s2,0(sp)
    80001f7e:	6105                	addi	sp,sp,32
    80001f80:	8082                	ret
    return -1;
    80001f82:	557d                	li	a0,-1
    80001f84:	bfcd                	j	80001f76 <fetchaddr+0x3e>
    80001f86:	557d                	li	a0,-1
    80001f88:	b7fd                	j	80001f76 <fetchaddr+0x3e>

0000000080001f8a <fetchstr>:
{
    80001f8a:	7179                	addi	sp,sp,-48
    80001f8c:	f406                	sd	ra,40(sp)
    80001f8e:	f022                	sd	s0,32(sp)
    80001f90:	ec26                	sd	s1,24(sp)
    80001f92:	e84a                	sd	s2,16(sp)
    80001f94:	e44e                	sd	s3,8(sp)
    80001f96:	1800                	addi	s0,sp,48
    80001f98:	892a                	mv	s2,a0
    80001f9a:	84ae                	mv	s1,a1
    80001f9c:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001f9e:	fffff097          	auipc	ra,0xfffff
    80001fa2:	ed6080e7          	jalr	-298(ra) # 80000e74 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80001fa6:	86ce                	mv	a3,s3
    80001fa8:	864a                	mv	a2,s2
    80001faa:	85a6                	mv	a1,s1
    80001fac:	6928                	ld	a0,80(a0)
    80001fae:	fffff097          	auipc	ra,0xfffff
    80001fb2:	c8c080e7          	jalr	-884(ra) # 80000c3a <copyinstr>
  if(err < 0)
    80001fb6:	00054763          	bltz	a0,80001fc4 <fetchstr+0x3a>
  return strlen(buf);
    80001fba:	8526                	mv	a0,s1
    80001fbc:	ffffe097          	auipc	ra,0xffffe
    80001fc0:	34a080e7          	jalr	842(ra) # 80000306 <strlen>
}
    80001fc4:	70a2                	ld	ra,40(sp)
    80001fc6:	7402                	ld	s0,32(sp)
    80001fc8:	64e2                	ld	s1,24(sp)
    80001fca:	6942                	ld	s2,16(sp)
    80001fcc:	69a2                	ld	s3,8(sp)
    80001fce:	6145                	addi	sp,sp,48
    80001fd0:	8082                	ret

0000000080001fd2 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80001fd2:	1101                	addi	sp,sp,-32
    80001fd4:	ec06                	sd	ra,24(sp)
    80001fd6:	e822                	sd	s0,16(sp)
    80001fd8:	e426                	sd	s1,8(sp)
    80001fda:	1000                	addi	s0,sp,32
    80001fdc:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001fde:	00000097          	auipc	ra,0x0
    80001fe2:	ef2080e7          	jalr	-270(ra) # 80001ed0 <argraw>
    80001fe6:	c088                	sw	a0,0(s1)
  return 0;
}
    80001fe8:	4501                	li	a0,0
    80001fea:	60e2                	ld	ra,24(sp)
    80001fec:	6442                	ld	s0,16(sp)
    80001fee:	64a2                	ld	s1,8(sp)
    80001ff0:	6105                	addi	sp,sp,32
    80001ff2:	8082                	ret

0000000080001ff4 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80001ff4:	1101                	addi	sp,sp,-32
    80001ff6:	ec06                	sd	ra,24(sp)
    80001ff8:	e822                	sd	s0,16(sp)
    80001ffa:	e426                	sd	s1,8(sp)
    80001ffc:	1000                	addi	s0,sp,32
    80001ffe:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002000:	00000097          	auipc	ra,0x0
    80002004:	ed0080e7          	jalr	-304(ra) # 80001ed0 <argraw>
    80002008:	e088                	sd	a0,0(s1)
  return 0;
}
    8000200a:	4501                	li	a0,0
    8000200c:	60e2                	ld	ra,24(sp)
    8000200e:	6442                	ld	s0,16(sp)
    80002010:	64a2                	ld	s1,8(sp)
    80002012:	6105                	addi	sp,sp,32
    80002014:	8082                	ret

0000000080002016 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002016:	1101                	addi	sp,sp,-32
    80002018:	ec06                	sd	ra,24(sp)
    8000201a:	e822                	sd	s0,16(sp)
    8000201c:	e426                	sd	s1,8(sp)
    8000201e:	e04a                	sd	s2,0(sp)
    80002020:	1000                	addi	s0,sp,32
    80002022:	84ae                	mv	s1,a1
    80002024:	8932                	mv	s2,a2
  *ip = argraw(n);
    80002026:	00000097          	auipc	ra,0x0
    8000202a:	eaa080e7          	jalr	-342(ra) # 80001ed0 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    8000202e:	864a                	mv	a2,s2
    80002030:	85a6                	mv	a1,s1
    80002032:	00000097          	auipc	ra,0x0
    80002036:	f58080e7          	jalr	-168(ra) # 80001f8a <fetchstr>
}
    8000203a:	60e2                	ld	ra,24(sp)
    8000203c:	6442                	ld	s0,16(sp)
    8000203e:	64a2                	ld	s1,8(sp)
    80002040:	6902                	ld	s2,0(sp)
    80002042:	6105                	addi	sp,sp,32
    80002044:	8082                	ret

0000000080002046 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    80002046:	1101                	addi	sp,sp,-32
    80002048:	ec06                	sd	ra,24(sp)
    8000204a:	e822                	sd	s0,16(sp)
    8000204c:	e426                	sd	s1,8(sp)
    8000204e:	e04a                	sd	s2,0(sp)
    80002050:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002052:	fffff097          	auipc	ra,0xfffff
    80002056:	e22080e7          	jalr	-478(ra) # 80000e74 <myproc>
    8000205a:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    8000205c:	05853903          	ld	s2,88(a0)
    80002060:	0a893783          	ld	a5,168(s2)
    80002064:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002068:	37fd                	addiw	a5,a5,-1
    8000206a:	4751                	li	a4,20
    8000206c:	00f76f63          	bltu	a4,a5,8000208a <syscall+0x44>
    80002070:	00369713          	slli	a4,a3,0x3
    80002074:	00006797          	auipc	a5,0x6
    80002078:	6d478793          	addi	a5,a5,1748 # 80008748 <syscalls>
    8000207c:	97ba                	add	a5,a5,a4
    8000207e:	639c                	ld	a5,0(a5)
    80002080:	c789                	beqz	a5,8000208a <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    80002082:	9782                	jalr	a5
    80002084:	06a93823          	sd	a0,112(s2)
    80002088:	a839                	j	800020a6 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    8000208a:	15848613          	addi	a2,s1,344
    8000208e:	588c                	lw	a1,48(s1)
    80002090:	00006517          	auipc	a0,0x6
    80002094:	2d050513          	addi	a0,a0,720 # 80008360 <etext+0x360>
    80002098:	00004097          	auipc	ra,0x4
    8000209c:	c94080e7          	jalr	-876(ra) # 80005d2c <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800020a0:	6cbc                	ld	a5,88(s1)
    800020a2:	577d                	li	a4,-1
    800020a4:	fbb8                	sd	a4,112(a5)
  }
}
    800020a6:	60e2                	ld	ra,24(sp)
    800020a8:	6442                	ld	s0,16(sp)
    800020aa:	64a2                	ld	s1,8(sp)
    800020ac:	6902                	ld	s2,0(sp)
    800020ae:	6105                	addi	sp,sp,32
    800020b0:	8082                	ret

00000000800020b2 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    800020b2:	1101                	addi	sp,sp,-32
    800020b4:	ec06                	sd	ra,24(sp)
    800020b6:	e822                	sd	s0,16(sp)
    800020b8:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    800020ba:	fec40593          	addi	a1,s0,-20
    800020be:	4501                	li	a0,0
    800020c0:	00000097          	auipc	ra,0x0
    800020c4:	f12080e7          	jalr	-238(ra) # 80001fd2 <argint>
    return -1;
    800020c8:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800020ca:	00054963          	bltz	a0,800020dc <sys_exit+0x2a>
  exit(n);
    800020ce:	fec42503          	lw	a0,-20(s0)
    800020d2:	fffff097          	auipc	ra,0xfffff
    800020d6:	6be080e7          	jalr	1726(ra) # 80001790 <exit>
  return 0;  // not reached
    800020da:	4781                	li	a5,0
}
    800020dc:	853e                	mv	a0,a5
    800020de:	60e2                	ld	ra,24(sp)
    800020e0:	6442                	ld	s0,16(sp)
    800020e2:	6105                	addi	sp,sp,32
    800020e4:	8082                	ret

00000000800020e6 <sys_getpid>:

uint64
sys_getpid(void)
{
    800020e6:	1141                	addi	sp,sp,-16
    800020e8:	e406                	sd	ra,8(sp)
    800020ea:	e022                	sd	s0,0(sp)
    800020ec:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800020ee:	fffff097          	auipc	ra,0xfffff
    800020f2:	d86080e7          	jalr	-634(ra) # 80000e74 <myproc>
}
    800020f6:	5908                	lw	a0,48(a0)
    800020f8:	60a2                	ld	ra,8(sp)
    800020fa:	6402                	ld	s0,0(sp)
    800020fc:	0141                	addi	sp,sp,16
    800020fe:	8082                	ret

0000000080002100 <sys_fork>:

uint64
sys_fork(void)
{
    80002100:	1141                	addi	sp,sp,-16
    80002102:	e406                	sd	ra,8(sp)
    80002104:	e022                	sd	s0,0(sp)
    80002106:	0800                	addi	s0,sp,16
  return fork();
    80002108:	fffff097          	auipc	ra,0xfffff
    8000210c:	13e080e7          	jalr	318(ra) # 80001246 <fork>
}
    80002110:	60a2                	ld	ra,8(sp)
    80002112:	6402                	ld	s0,0(sp)
    80002114:	0141                	addi	sp,sp,16
    80002116:	8082                	ret

0000000080002118 <sys_wait>:

uint64
sys_wait(void)
{
    80002118:	1101                	addi	sp,sp,-32
    8000211a:	ec06                	sd	ra,24(sp)
    8000211c:	e822                	sd	s0,16(sp)
    8000211e:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002120:	fe840593          	addi	a1,s0,-24
    80002124:	4501                	li	a0,0
    80002126:	00000097          	auipc	ra,0x0
    8000212a:	ece080e7          	jalr	-306(ra) # 80001ff4 <argaddr>
    8000212e:	87aa                	mv	a5,a0
    return -1;
    80002130:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002132:	0007c863          	bltz	a5,80002142 <sys_wait+0x2a>
  return wait(p);
    80002136:	fe843503          	ld	a0,-24(s0)
    8000213a:	fffff097          	auipc	ra,0xfffff
    8000213e:	464080e7          	jalr	1124(ra) # 8000159e <wait>
}
    80002142:	60e2                	ld	ra,24(sp)
    80002144:	6442                	ld	s0,16(sp)
    80002146:	6105                	addi	sp,sp,32
    80002148:	8082                	ret

000000008000214a <sys_sbrk>:

uint64
sys_sbrk(void)
{
    8000214a:	7179                	addi	sp,sp,-48
    8000214c:	f406                	sd	ra,40(sp)
    8000214e:	f022                	sd	s0,32(sp)
    80002150:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80002152:	fdc40593          	addi	a1,s0,-36
    80002156:	4501                	li	a0,0
    80002158:	00000097          	auipc	ra,0x0
    8000215c:	e7a080e7          	jalr	-390(ra) # 80001fd2 <argint>
    80002160:	87aa                	mv	a5,a0
    return -1;
    80002162:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    80002164:	0207c263          	bltz	a5,80002188 <sys_sbrk+0x3e>
    80002168:	ec26                	sd	s1,24(sp)
  addr = myproc()->sz;
    8000216a:	fffff097          	auipc	ra,0xfffff
    8000216e:	d0a080e7          	jalr	-758(ra) # 80000e74 <myproc>
    80002172:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    80002174:	fdc42503          	lw	a0,-36(s0)
    80002178:	fffff097          	auipc	ra,0xfffff
    8000217c:	056080e7          	jalr	86(ra) # 800011ce <growproc>
    80002180:	00054863          	bltz	a0,80002190 <sys_sbrk+0x46>
    return -1;
  return addr;
    80002184:	8526                	mv	a0,s1
    80002186:	64e2                	ld	s1,24(sp)
}
    80002188:	70a2                	ld	ra,40(sp)
    8000218a:	7402                	ld	s0,32(sp)
    8000218c:	6145                	addi	sp,sp,48
    8000218e:	8082                	ret
    return -1;
    80002190:	557d                	li	a0,-1
    80002192:	64e2                	ld	s1,24(sp)
    80002194:	bfd5                	j	80002188 <sys_sbrk+0x3e>

0000000080002196 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002196:	7139                	addi	sp,sp,-64
    80002198:	fc06                	sd	ra,56(sp)
    8000219a:	f822                	sd	s0,48(sp)
    8000219c:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    8000219e:	fcc40593          	addi	a1,s0,-52
    800021a2:	4501                	li	a0,0
    800021a4:	00000097          	auipc	ra,0x0
    800021a8:	e2e080e7          	jalr	-466(ra) # 80001fd2 <argint>
    return -1;
    800021ac:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800021ae:	06054b63          	bltz	a0,80002224 <sys_sleep+0x8e>
    800021b2:	f04a                	sd	s2,32(sp)
  acquire(&tickslock);
    800021b4:	0000d517          	auipc	a0,0xd
    800021b8:	ccc50513          	addi	a0,a0,-820 # 8000ee80 <tickslock>
    800021bc:	00004097          	auipc	ra,0x4
    800021c0:	0a6080e7          	jalr	166(ra) # 80006262 <acquire>
  ticks0 = ticks;
    800021c4:	00007917          	auipc	s2,0x7
    800021c8:	e5492903          	lw	s2,-428(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    800021cc:	fcc42783          	lw	a5,-52(s0)
    800021d0:	c3a1                	beqz	a5,80002210 <sys_sleep+0x7a>
    800021d2:	f426                	sd	s1,40(sp)
    800021d4:	ec4e                	sd	s3,24(sp)
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800021d6:	0000d997          	auipc	s3,0xd
    800021da:	caa98993          	addi	s3,s3,-854 # 8000ee80 <tickslock>
    800021de:	00007497          	auipc	s1,0x7
    800021e2:	e3a48493          	addi	s1,s1,-454 # 80009018 <ticks>
    if(myproc()->killed){
    800021e6:	fffff097          	auipc	ra,0xfffff
    800021ea:	c8e080e7          	jalr	-882(ra) # 80000e74 <myproc>
    800021ee:	551c                	lw	a5,40(a0)
    800021f0:	ef9d                	bnez	a5,8000222e <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    800021f2:	85ce                	mv	a1,s3
    800021f4:	8526                	mv	a0,s1
    800021f6:	fffff097          	auipc	ra,0xfffff
    800021fa:	344080e7          	jalr	836(ra) # 8000153a <sleep>
  while(ticks - ticks0 < n){
    800021fe:	409c                	lw	a5,0(s1)
    80002200:	412787bb          	subw	a5,a5,s2
    80002204:	fcc42703          	lw	a4,-52(s0)
    80002208:	fce7efe3          	bltu	a5,a4,800021e6 <sys_sleep+0x50>
    8000220c:	74a2                	ld	s1,40(sp)
    8000220e:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80002210:	0000d517          	auipc	a0,0xd
    80002214:	c7050513          	addi	a0,a0,-912 # 8000ee80 <tickslock>
    80002218:	00004097          	auipc	ra,0x4
    8000221c:	0fa080e7          	jalr	250(ra) # 80006312 <release>
  return 0;
    80002220:	4781                	li	a5,0
    80002222:	7902                	ld	s2,32(sp)
}
    80002224:	853e                	mv	a0,a5
    80002226:	70e2                	ld	ra,56(sp)
    80002228:	7442                	ld	s0,48(sp)
    8000222a:	6121                	addi	sp,sp,64
    8000222c:	8082                	ret
      release(&tickslock);
    8000222e:	0000d517          	auipc	a0,0xd
    80002232:	c5250513          	addi	a0,a0,-942 # 8000ee80 <tickslock>
    80002236:	00004097          	auipc	ra,0x4
    8000223a:	0dc080e7          	jalr	220(ra) # 80006312 <release>
      return -1;
    8000223e:	57fd                	li	a5,-1
    80002240:	74a2                	ld	s1,40(sp)
    80002242:	7902                	ld	s2,32(sp)
    80002244:	69e2                	ld	s3,24(sp)
    80002246:	bff9                	j	80002224 <sys_sleep+0x8e>

0000000080002248 <sys_kill>:

uint64
sys_kill(void)
{
    80002248:	1101                	addi	sp,sp,-32
    8000224a:	ec06                	sd	ra,24(sp)
    8000224c:	e822                	sd	s0,16(sp)
    8000224e:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002250:	fec40593          	addi	a1,s0,-20
    80002254:	4501                	li	a0,0
    80002256:	00000097          	auipc	ra,0x0
    8000225a:	d7c080e7          	jalr	-644(ra) # 80001fd2 <argint>
    8000225e:	87aa                	mv	a5,a0
    return -1;
    80002260:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80002262:	0007c863          	bltz	a5,80002272 <sys_kill+0x2a>
  return kill(pid);
    80002266:	fec42503          	lw	a0,-20(s0)
    8000226a:	fffff097          	auipc	ra,0xfffff
    8000226e:	5fc080e7          	jalr	1532(ra) # 80001866 <kill>
}
    80002272:	60e2                	ld	ra,24(sp)
    80002274:	6442                	ld	s0,16(sp)
    80002276:	6105                	addi	sp,sp,32
    80002278:	8082                	ret

000000008000227a <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    8000227a:	1101                	addi	sp,sp,-32
    8000227c:	ec06                	sd	ra,24(sp)
    8000227e:	e822                	sd	s0,16(sp)
    80002280:	e426                	sd	s1,8(sp)
    80002282:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002284:	0000d517          	auipc	a0,0xd
    80002288:	bfc50513          	addi	a0,a0,-1028 # 8000ee80 <tickslock>
    8000228c:	00004097          	auipc	ra,0x4
    80002290:	fd6080e7          	jalr	-42(ra) # 80006262 <acquire>
  xticks = ticks;
    80002294:	00007497          	auipc	s1,0x7
    80002298:	d844a483          	lw	s1,-636(s1) # 80009018 <ticks>
  release(&tickslock);
    8000229c:	0000d517          	auipc	a0,0xd
    800022a0:	be450513          	addi	a0,a0,-1052 # 8000ee80 <tickslock>
    800022a4:	00004097          	auipc	ra,0x4
    800022a8:	06e080e7          	jalr	110(ra) # 80006312 <release>
  return xticks;
}
    800022ac:	02049513          	slli	a0,s1,0x20
    800022b0:	9101                	srli	a0,a0,0x20
    800022b2:	60e2                	ld	ra,24(sp)
    800022b4:	6442                	ld	s0,16(sp)
    800022b6:	64a2                	ld	s1,8(sp)
    800022b8:	6105                	addi	sp,sp,32
    800022ba:	8082                	ret

00000000800022bc <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800022bc:	7179                	addi	sp,sp,-48
    800022be:	f406                	sd	ra,40(sp)
    800022c0:	f022                	sd	s0,32(sp)
    800022c2:	ec26                	sd	s1,24(sp)
    800022c4:	e84a                	sd	s2,16(sp)
    800022c6:	e44e                	sd	s3,8(sp)
    800022c8:	e052                	sd	s4,0(sp)
    800022ca:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800022cc:	00006597          	auipc	a1,0x6
    800022d0:	0b458593          	addi	a1,a1,180 # 80008380 <etext+0x380>
    800022d4:	0000d517          	auipc	a0,0xd
    800022d8:	bc450513          	addi	a0,a0,-1084 # 8000ee98 <bcache>
    800022dc:	00004097          	auipc	ra,0x4
    800022e0:	ef2080e7          	jalr	-270(ra) # 800061ce <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800022e4:	00015797          	auipc	a5,0x15
    800022e8:	bb478793          	addi	a5,a5,-1100 # 80016e98 <bcache+0x8000>
    800022ec:	00015717          	auipc	a4,0x15
    800022f0:	e1470713          	addi	a4,a4,-492 # 80017100 <bcache+0x8268>
    800022f4:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800022f8:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800022fc:	0000d497          	auipc	s1,0xd
    80002300:	bb448493          	addi	s1,s1,-1100 # 8000eeb0 <bcache+0x18>
    b->next = bcache.head.next;
    80002304:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002306:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002308:	00006a17          	auipc	s4,0x6
    8000230c:	080a0a13          	addi	s4,s4,128 # 80008388 <etext+0x388>
    b->next = bcache.head.next;
    80002310:	2b893783          	ld	a5,696(s2)
    80002314:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002316:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000231a:	85d2                	mv	a1,s4
    8000231c:	01048513          	addi	a0,s1,16
    80002320:	00001097          	auipc	ra,0x1
    80002324:	4ba080e7          	jalr	1210(ra) # 800037da <initsleeplock>
    bcache.head.next->prev = b;
    80002328:	2b893783          	ld	a5,696(s2)
    8000232c:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    8000232e:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002332:	45848493          	addi	s1,s1,1112
    80002336:	fd349de3          	bne	s1,s3,80002310 <binit+0x54>
  }
}
    8000233a:	70a2                	ld	ra,40(sp)
    8000233c:	7402                	ld	s0,32(sp)
    8000233e:	64e2                	ld	s1,24(sp)
    80002340:	6942                	ld	s2,16(sp)
    80002342:	69a2                	ld	s3,8(sp)
    80002344:	6a02                	ld	s4,0(sp)
    80002346:	6145                	addi	sp,sp,48
    80002348:	8082                	ret

000000008000234a <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000234a:	7179                	addi	sp,sp,-48
    8000234c:	f406                	sd	ra,40(sp)
    8000234e:	f022                	sd	s0,32(sp)
    80002350:	ec26                	sd	s1,24(sp)
    80002352:	e84a                	sd	s2,16(sp)
    80002354:	e44e                	sd	s3,8(sp)
    80002356:	1800                	addi	s0,sp,48
    80002358:	892a                	mv	s2,a0
    8000235a:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    8000235c:	0000d517          	auipc	a0,0xd
    80002360:	b3c50513          	addi	a0,a0,-1220 # 8000ee98 <bcache>
    80002364:	00004097          	auipc	ra,0x4
    80002368:	efe080e7          	jalr	-258(ra) # 80006262 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000236c:	00015497          	auipc	s1,0x15
    80002370:	de44b483          	ld	s1,-540(s1) # 80017150 <bcache+0x82b8>
    80002374:	00015797          	auipc	a5,0x15
    80002378:	d8c78793          	addi	a5,a5,-628 # 80017100 <bcache+0x8268>
    8000237c:	02f48f63          	beq	s1,a5,800023ba <bread+0x70>
    80002380:	873e                	mv	a4,a5
    80002382:	a021                	j	8000238a <bread+0x40>
    80002384:	68a4                	ld	s1,80(s1)
    80002386:	02e48a63          	beq	s1,a4,800023ba <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    8000238a:	449c                	lw	a5,8(s1)
    8000238c:	ff279ce3          	bne	a5,s2,80002384 <bread+0x3a>
    80002390:	44dc                	lw	a5,12(s1)
    80002392:	ff3799e3          	bne	a5,s3,80002384 <bread+0x3a>
      b->refcnt++;
    80002396:	40bc                	lw	a5,64(s1)
    80002398:	2785                	addiw	a5,a5,1
    8000239a:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000239c:	0000d517          	auipc	a0,0xd
    800023a0:	afc50513          	addi	a0,a0,-1284 # 8000ee98 <bcache>
    800023a4:	00004097          	auipc	ra,0x4
    800023a8:	f6e080e7          	jalr	-146(ra) # 80006312 <release>
      acquiresleep(&b->lock);
    800023ac:	01048513          	addi	a0,s1,16
    800023b0:	00001097          	auipc	ra,0x1
    800023b4:	464080e7          	jalr	1124(ra) # 80003814 <acquiresleep>
      return b;
    800023b8:	a8b9                	j	80002416 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800023ba:	00015497          	auipc	s1,0x15
    800023be:	d8e4b483          	ld	s1,-626(s1) # 80017148 <bcache+0x82b0>
    800023c2:	00015797          	auipc	a5,0x15
    800023c6:	d3e78793          	addi	a5,a5,-706 # 80017100 <bcache+0x8268>
    800023ca:	00f48863          	beq	s1,a5,800023da <bread+0x90>
    800023ce:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800023d0:	40bc                	lw	a5,64(s1)
    800023d2:	cf81                	beqz	a5,800023ea <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800023d4:	64a4                	ld	s1,72(s1)
    800023d6:	fee49de3          	bne	s1,a4,800023d0 <bread+0x86>
  panic("bget: no buffers");
    800023da:	00006517          	auipc	a0,0x6
    800023de:	fb650513          	addi	a0,a0,-74 # 80008390 <etext+0x390>
    800023e2:	00004097          	auipc	ra,0x4
    800023e6:	900080e7          	jalr	-1792(ra) # 80005ce2 <panic>
      b->dev = dev;
    800023ea:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800023ee:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800023f2:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800023f6:	4785                	li	a5,1
    800023f8:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800023fa:	0000d517          	auipc	a0,0xd
    800023fe:	a9e50513          	addi	a0,a0,-1378 # 8000ee98 <bcache>
    80002402:	00004097          	auipc	ra,0x4
    80002406:	f10080e7          	jalr	-240(ra) # 80006312 <release>
      acquiresleep(&b->lock);
    8000240a:	01048513          	addi	a0,s1,16
    8000240e:	00001097          	auipc	ra,0x1
    80002412:	406080e7          	jalr	1030(ra) # 80003814 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002416:	409c                	lw	a5,0(s1)
    80002418:	cb89                	beqz	a5,8000242a <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000241a:	8526                	mv	a0,s1
    8000241c:	70a2                	ld	ra,40(sp)
    8000241e:	7402                	ld	s0,32(sp)
    80002420:	64e2                	ld	s1,24(sp)
    80002422:	6942                	ld	s2,16(sp)
    80002424:	69a2                	ld	s3,8(sp)
    80002426:	6145                	addi	sp,sp,48
    80002428:	8082                	ret
    virtio_disk_rw(b, 0);
    8000242a:	4581                	li	a1,0
    8000242c:	8526                	mv	a0,s1
    8000242e:	00003097          	auipc	ra,0x3
    80002432:	020080e7          	jalr	32(ra) # 8000544e <virtio_disk_rw>
    b->valid = 1;
    80002436:	4785                	li	a5,1
    80002438:	c09c                	sw	a5,0(s1)
  return b;
    8000243a:	b7c5                	j	8000241a <bread+0xd0>

000000008000243c <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    8000243c:	1101                	addi	sp,sp,-32
    8000243e:	ec06                	sd	ra,24(sp)
    80002440:	e822                	sd	s0,16(sp)
    80002442:	e426                	sd	s1,8(sp)
    80002444:	1000                	addi	s0,sp,32
    80002446:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002448:	0541                	addi	a0,a0,16
    8000244a:	00001097          	auipc	ra,0x1
    8000244e:	464080e7          	jalr	1124(ra) # 800038ae <holdingsleep>
    80002452:	cd01                	beqz	a0,8000246a <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002454:	4585                	li	a1,1
    80002456:	8526                	mv	a0,s1
    80002458:	00003097          	auipc	ra,0x3
    8000245c:	ff6080e7          	jalr	-10(ra) # 8000544e <virtio_disk_rw>
}
    80002460:	60e2                	ld	ra,24(sp)
    80002462:	6442                	ld	s0,16(sp)
    80002464:	64a2                	ld	s1,8(sp)
    80002466:	6105                	addi	sp,sp,32
    80002468:	8082                	ret
    panic("bwrite");
    8000246a:	00006517          	auipc	a0,0x6
    8000246e:	f3e50513          	addi	a0,a0,-194 # 800083a8 <etext+0x3a8>
    80002472:	00004097          	auipc	ra,0x4
    80002476:	870080e7          	jalr	-1936(ra) # 80005ce2 <panic>

000000008000247a <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000247a:	1101                	addi	sp,sp,-32
    8000247c:	ec06                	sd	ra,24(sp)
    8000247e:	e822                	sd	s0,16(sp)
    80002480:	e426                	sd	s1,8(sp)
    80002482:	e04a                	sd	s2,0(sp)
    80002484:	1000                	addi	s0,sp,32
    80002486:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002488:	01050913          	addi	s2,a0,16
    8000248c:	854a                	mv	a0,s2
    8000248e:	00001097          	auipc	ra,0x1
    80002492:	420080e7          	jalr	1056(ra) # 800038ae <holdingsleep>
    80002496:	c535                	beqz	a0,80002502 <brelse+0x88>
    panic("brelse");

  releasesleep(&b->lock);
    80002498:	854a                	mv	a0,s2
    8000249a:	00001097          	auipc	ra,0x1
    8000249e:	3d0080e7          	jalr	976(ra) # 8000386a <releasesleep>

  acquire(&bcache.lock);
    800024a2:	0000d517          	auipc	a0,0xd
    800024a6:	9f650513          	addi	a0,a0,-1546 # 8000ee98 <bcache>
    800024aa:	00004097          	auipc	ra,0x4
    800024ae:	db8080e7          	jalr	-584(ra) # 80006262 <acquire>
  b->refcnt--;
    800024b2:	40bc                	lw	a5,64(s1)
    800024b4:	37fd                	addiw	a5,a5,-1
    800024b6:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800024b8:	e79d                	bnez	a5,800024e6 <brelse+0x6c>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800024ba:	68b8                	ld	a4,80(s1)
    800024bc:	64bc                	ld	a5,72(s1)
    800024be:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    800024c0:	68b8                	ld	a4,80(s1)
    800024c2:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800024c4:	00015797          	auipc	a5,0x15
    800024c8:	9d478793          	addi	a5,a5,-1580 # 80016e98 <bcache+0x8000>
    800024cc:	2b87b703          	ld	a4,696(a5)
    800024d0:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800024d2:	00015717          	auipc	a4,0x15
    800024d6:	c2e70713          	addi	a4,a4,-978 # 80017100 <bcache+0x8268>
    800024da:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800024dc:	2b87b703          	ld	a4,696(a5)
    800024e0:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800024e2:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800024e6:	0000d517          	auipc	a0,0xd
    800024ea:	9b250513          	addi	a0,a0,-1614 # 8000ee98 <bcache>
    800024ee:	00004097          	auipc	ra,0x4
    800024f2:	e24080e7          	jalr	-476(ra) # 80006312 <release>
}
    800024f6:	60e2                	ld	ra,24(sp)
    800024f8:	6442                	ld	s0,16(sp)
    800024fa:	64a2                	ld	s1,8(sp)
    800024fc:	6902                	ld	s2,0(sp)
    800024fe:	6105                	addi	sp,sp,32
    80002500:	8082                	ret
    panic("brelse");
    80002502:	00006517          	auipc	a0,0x6
    80002506:	eae50513          	addi	a0,a0,-338 # 800083b0 <etext+0x3b0>
    8000250a:	00003097          	auipc	ra,0x3
    8000250e:	7d8080e7          	jalr	2008(ra) # 80005ce2 <panic>

0000000080002512 <bpin>:

void
bpin(struct buf *b) {
    80002512:	1101                	addi	sp,sp,-32
    80002514:	ec06                	sd	ra,24(sp)
    80002516:	e822                	sd	s0,16(sp)
    80002518:	e426                	sd	s1,8(sp)
    8000251a:	1000                	addi	s0,sp,32
    8000251c:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000251e:	0000d517          	auipc	a0,0xd
    80002522:	97a50513          	addi	a0,a0,-1670 # 8000ee98 <bcache>
    80002526:	00004097          	auipc	ra,0x4
    8000252a:	d3c080e7          	jalr	-708(ra) # 80006262 <acquire>
  b->refcnt++;
    8000252e:	40bc                	lw	a5,64(s1)
    80002530:	2785                	addiw	a5,a5,1
    80002532:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002534:	0000d517          	auipc	a0,0xd
    80002538:	96450513          	addi	a0,a0,-1692 # 8000ee98 <bcache>
    8000253c:	00004097          	auipc	ra,0x4
    80002540:	dd6080e7          	jalr	-554(ra) # 80006312 <release>
}
    80002544:	60e2                	ld	ra,24(sp)
    80002546:	6442                	ld	s0,16(sp)
    80002548:	64a2                	ld	s1,8(sp)
    8000254a:	6105                	addi	sp,sp,32
    8000254c:	8082                	ret

000000008000254e <bunpin>:

void
bunpin(struct buf *b) {
    8000254e:	1101                	addi	sp,sp,-32
    80002550:	ec06                	sd	ra,24(sp)
    80002552:	e822                	sd	s0,16(sp)
    80002554:	e426                	sd	s1,8(sp)
    80002556:	1000                	addi	s0,sp,32
    80002558:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000255a:	0000d517          	auipc	a0,0xd
    8000255e:	93e50513          	addi	a0,a0,-1730 # 8000ee98 <bcache>
    80002562:	00004097          	auipc	ra,0x4
    80002566:	d00080e7          	jalr	-768(ra) # 80006262 <acquire>
  b->refcnt--;
    8000256a:	40bc                	lw	a5,64(s1)
    8000256c:	37fd                	addiw	a5,a5,-1
    8000256e:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002570:	0000d517          	auipc	a0,0xd
    80002574:	92850513          	addi	a0,a0,-1752 # 8000ee98 <bcache>
    80002578:	00004097          	auipc	ra,0x4
    8000257c:	d9a080e7          	jalr	-614(ra) # 80006312 <release>
}
    80002580:	60e2                	ld	ra,24(sp)
    80002582:	6442                	ld	s0,16(sp)
    80002584:	64a2                	ld	s1,8(sp)
    80002586:	6105                	addi	sp,sp,32
    80002588:	8082                	ret

000000008000258a <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000258a:	1101                	addi	sp,sp,-32
    8000258c:	ec06                	sd	ra,24(sp)
    8000258e:	e822                	sd	s0,16(sp)
    80002590:	e426                	sd	s1,8(sp)
    80002592:	e04a                	sd	s2,0(sp)
    80002594:	1000                	addi	s0,sp,32
    80002596:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002598:	00d5d79b          	srliw	a5,a1,0xd
    8000259c:	00015597          	auipc	a1,0x15
    800025a0:	fd85a583          	lw	a1,-40(a1) # 80017574 <sb+0x1c>
    800025a4:	9dbd                	addw	a1,a1,a5
    800025a6:	00000097          	auipc	ra,0x0
    800025aa:	da4080e7          	jalr	-604(ra) # 8000234a <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800025ae:	0074f713          	andi	a4,s1,7
    800025b2:	4785                	li	a5,1
    800025b4:	00e797bb          	sllw	a5,a5,a4
  bi = b % BPB;
    800025b8:	14ce                	slli	s1,s1,0x33
  if((bp->data[bi/8] & m) == 0)
    800025ba:	90d9                	srli	s1,s1,0x36
    800025bc:	00950733          	add	a4,a0,s1
    800025c0:	05874703          	lbu	a4,88(a4)
    800025c4:	00e7f6b3          	and	a3,a5,a4
    800025c8:	c69d                	beqz	a3,800025f6 <bfree+0x6c>
    800025ca:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800025cc:	94aa                	add	s1,s1,a0
    800025ce:	fff7c793          	not	a5,a5
    800025d2:	8f7d                	and	a4,a4,a5
    800025d4:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    800025d8:	00001097          	auipc	ra,0x1
    800025dc:	11e080e7          	jalr	286(ra) # 800036f6 <log_write>
  brelse(bp);
    800025e0:	854a                	mv	a0,s2
    800025e2:	00000097          	auipc	ra,0x0
    800025e6:	e98080e7          	jalr	-360(ra) # 8000247a <brelse>
}
    800025ea:	60e2                	ld	ra,24(sp)
    800025ec:	6442                	ld	s0,16(sp)
    800025ee:	64a2                	ld	s1,8(sp)
    800025f0:	6902                	ld	s2,0(sp)
    800025f2:	6105                	addi	sp,sp,32
    800025f4:	8082                	ret
    panic("freeing free block");
    800025f6:	00006517          	auipc	a0,0x6
    800025fa:	dc250513          	addi	a0,a0,-574 # 800083b8 <etext+0x3b8>
    800025fe:	00003097          	auipc	ra,0x3
    80002602:	6e4080e7          	jalr	1764(ra) # 80005ce2 <panic>

0000000080002606 <balloc>:
{
    80002606:	715d                	addi	sp,sp,-80
    80002608:	e486                	sd	ra,72(sp)
    8000260a:	e0a2                	sd	s0,64(sp)
    8000260c:	fc26                	sd	s1,56(sp)
    8000260e:	f84a                	sd	s2,48(sp)
    80002610:	f44e                	sd	s3,40(sp)
    80002612:	f052                	sd	s4,32(sp)
    80002614:	ec56                	sd	s5,24(sp)
    80002616:	e85a                	sd	s6,16(sp)
    80002618:	e45e                	sd	s7,8(sp)
    8000261a:	e062                	sd	s8,0(sp)
    8000261c:	0880                	addi	s0,sp,80
  for(b = 0; b < sb.size; b += BPB){
    8000261e:	00015797          	auipc	a5,0x15
    80002622:	f3e7a783          	lw	a5,-194(a5) # 8001755c <sb+0x4>
    80002626:	c7c1                	beqz	a5,800026ae <balloc+0xa8>
    80002628:	8baa                	mv	s7,a0
    8000262a:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000262c:	00015b17          	auipc	s6,0x15
    80002630:	f2cb0b13          	addi	s6,s6,-212 # 80017558 <sb>
      m = 1 << (bi % 8);
    80002634:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002636:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002638:	6c09                	lui	s8,0x2
    8000263a:	a821                	j	80002652 <balloc+0x4c>
    brelse(bp);
    8000263c:	854a                	mv	a0,s2
    8000263e:	00000097          	auipc	ra,0x0
    80002642:	e3c080e7          	jalr	-452(ra) # 8000247a <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002646:	015c0abb          	addw	s5,s8,s5
    8000264a:	004b2783          	lw	a5,4(s6)
    8000264e:	06faf063          	bgeu	s5,a5,800026ae <balloc+0xa8>
    bp = bread(dev, BBLOCK(b, sb));
    80002652:	41fad79b          	sraiw	a5,s5,0x1f
    80002656:	0137d79b          	srliw	a5,a5,0x13
    8000265a:	015787bb          	addw	a5,a5,s5
    8000265e:	40d7d79b          	sraiw	a5,a5,0xd
    80002662:	01cb2583          	lw	a1,28(s6)
    80002666:	9dbd                	addw	a1,a1,a5
    80002668:	855e                	mv	a0,s7
    8000266a:	00000097          	auipc	ra,0x0
    8000266e:	ce0080e7          	jalr	-800(ra) # 8000234a <bread>
    80002672:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002674:	004b2503          	lw	a0,4(s6)
    80002678:	84d6                	mv	s1,s5
    8000267a:	4701                	li	a4,0
    8000267c:	fca4f0e3          	bgeu	s1,a0,8000263c <balloc+0x36>
      m = 1 << (bi % 8);
    80002680:	00777693          	andi	a3,a4,7
    80002684:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002688:	41f7579b          	sraiw	a5,a4,0x1f
    8000268c:	01d7d79b          	srliw	a5,a5,0x1d
    80002690:	9fb9                	addw	a5,a5,a4
    80002692:	4037d79b          	sraiw	a5,a5,0x3
    80002696:	00f90633          	add	a2,s2,a5
    8000269a:	05864603          	lbu	a2,88(a2) # 1058 <_entry-0x7fffefa8>
    8000269e:	00c6f5b3          	and	a1,a3,a2
    800026a2:	cd91                	beqz	a1,800026be <balloc+0xb8>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026a4:	2705                	addiw	a4,a4,1
    800026a6:	2485                	addiw	s1,s1,1
    800026a8:	fd471ae3          	bne	a4,s4,8000267c <balloc+0x76>
    800026ac:	bf41                	j	8000263c <balloc+0x36>
  panic("balloc: out of blocks");
    800026ae:	00006517          	auipc	a0,0x6
    800026b2:	d2250513          	addi	a0,a0,-734 # 800083d0 <etext+0x3d0>
    800026b6:	00003097          	auipc	ra,0x3
    800026ba:	62c080e7          	jalr	1580(ra) # 80005ce2 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    800026be:	97ca                	add	a5,a5,s2
    800026c0:	8e55                	or	a2,a2,a3
    800026c2:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800026c6:	854a                	mv	a0,s2
    800026c8:	00001097          	auipc	ra,0x1
    800026cc:	02e080e7          	jalr	46(ra) # 800036f6 <log_write>
        brelse(bp);
    800026d0:	854a                	mv	a0,s2
    800026d2:	00000097          	auipc	ra,0x0
    800026d6:	da8080e7          	jalr	-600(ra) # 8000247a <brelse>
  bp = bread(dev, bno);
    800026da:	85a6                	mv	a1,s1
    800026dc:	855e                	mv	a0,s7
    800026de:	00000097          	auipc	ra,0x0
    800026e2:	c6c080e7          	jalr	-916(ra) # 8000234a <bread>
    800026e6:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800026e8:	40000613          	li	a2,1024
    800026ec:	4581                	li	a1,0
    800026ee:	05850513          	addi	a0,a0,88
    800026f2:	ffffe097          	auipc	ra,0xffffe
    800026f6:	a88080e7          	jalr	-1400(ra) # 8000017a <memset>
  log_write(bp);
    800026fa:	854a                	mv	a0,s2
    800026fc:	00001097          	auipc	ra,0x1
    80002700:	ffa080e7          	jalr	-6(ra) # 800036f6 <log_write>
  brelse(bp);
    80002704:	854a                	mv	a0,s2
    80002706:	00000097          	auipc	ra,0x0
    8000270a:	d74080e7          	jalr	-652(ra) # 8000247a <brelse>
}
    8000270e:	8526                	mv	a0,s1
    80002710:	60a6                	ld	ra,72(sp)
    80002712:	6406                	ld	s0,64(sp)
    80002714:	74e2                	ld	s1,56(sp)
    80002716:	7942                	ld	s2,48(sp)
    80002718:	79a2                	ld	s3,40(sp)
    8000271a:	7a02                	ld	s4,32(sp)
    8000271c:	6ae2                	ld	s5,24(sp)
    8000271e:	6b42                	ld	s6,16(sp)
    80002720:	6ba2                	ld	s7,8(sp)
    80002722:	6c02                	ld	s8,0(sp)
    80002724:	6161                	addi	sp,sp,80
    80002726:	8082                	ret

0000000080002728 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    80002728:	7179                	addi	sp,sp,-48
    8000272a:	f406                	sd	ra,40(sp)
    8000272c:	f022                	sd	s0,32(sp)
    8000272e:	ec26                	sd	s1,24(sp)
    80002730:	e84a                	sd	s2,16(sp)
    80002732:	e44e                	sd	s3,8(sp)
    80002734:	1800                	addi	s0,sp,48
    80002736:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002738:	47ad                	li	a5,11
    8000273a:	04b7fd63          	bgeu	a5,a1,80002794 <bmap+0x6c>
    8000273e:	e052                	sd	s4,0(sp)
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80002740:	ff45849b          	addiw	s1,a1,-12

  if(bn < NINDIRECT){
    80002744:	0ff00793          	li	a5,255
    80002748:	0897ef63          	bltu	a5,s1,800027e6 <bmap+0xbe>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    8000274c:	08052583          	lw	a1,128(a0)
    80002750:	c5a5                	beqz	a1,800027b8 <bmap+0x90>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80002752:	00092503          	lw	a0,0(s2)
    80002756:	00000097          	auipc	ra,0x0
    8000275a:	bf4080e7          	jalr	-1036(ra) # 8000234a <bread>
    8000275e:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002760:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002764:	02049713          	slli	a4,s1,0x20
    80002768:	01e75593          	srli	a1,a4,0x1e
    8000276c:	00b784b3          	add	s1,a5,a1
    80002770:	0004a983          	lw	s3,0(s1)
    80002774:	04098b63          	beqz	s3,800027ca <bmap+0xa2>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80002778:	8552                	mv	a0,s4
    8000277a:	00000097          	auipc	ra,0x0
    8000277e:	d00080e7          	jalr	-768(ra) # 8000247a <brelse>
    return addr;
    80002782:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80002784:	854e                	mv	a0,s3
    80002786:	70a2                	ld	ra,40(sp)
    80002788:	7402                	ld	s0,32(sp)
    8000278a:	64e2                	ld	s1,24(sp)
    8000278c:	6942                	ld	s2,16(sp)
    8000278e:	69a2                	ld	s3,8(sp)
    80002790:	6145                	addi	sp,sp,48
    80002792:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80002794:	02059793          	slli	a5,a1,0x20
    80002798:	01e7d593          	srli	a1,a5,0x1e
    8000279c:	00b504b3          	add	s1,a0,a1
    800027a0:	0504a983          	lw	s3,80(s1)
    800027a4:	fe0990e3          	bnez	s3,80002784 <bmap+0x5c>
      ip->addrs[bn] = addr = balloc(ip->dev);
    800027a8:	4108                	lw	a0,0(a0)
    800027aa:	00000097          	auipc	ra,0x0
    800027ae:	e5c080e7          	jalr	-420(ra) # 80002606 <balloc>
    800027b2:	89aa                	mv	s3,a0
    800027b4:	c8a8                	sw	a0,80(s1)
    800027b6:	b7f9                	j	80002784 <bmap+0x5c>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    800027b8:	4108                	lw	a0,0(a0)
    800027ba:	00000097          	auipc	ra,0x0
    800027be:	e4c080e7          	jalr	-436(ra) # 80002606 <balloc>
    800027c2:	85aa                	mv	a1,a0
    800027c4:	08a92023          	sw	a0,128(s2)
    800027c8:	b769                	j	80002752 <bmap+0x2a>
      a[bn] = addr = balloc(ip->dev);
    800027ca:	00092503          	lw	a0,0(s2)
    800027ce:	00000097          	auipc	ra,0x0
    800027d2:	e38080e7          	jalr	-456(ra) # 80002606 <balloc>
    800027d6:	89aa                	mv	s3,a0
    800027d8:	c088                	sw	a0,0(s1)
      log_write(bp);
    800027da:	8552                	mv	a0,s4
    800027dc:	00001097          	auipc	ra,0x1
    800027e0:	f1a080e7          	jalr	-230(ra) # 800036f6 <log_write>
    800027e4:	bf51                	j	80002778 <bmap+0x50>
  panic("bmap: out of range");
    800027e6:	00006517          	auipc	a0,0x6
    800027ea:	c0250513          	addi	a0,a0,-1022 # 800083e8 <etext+0x3e8>
    800027ee:	00003097          	auipc	ra,0x3
    800027f2:	4f4080e7          	jalr	1268(ra) # 80005ce2 <panic>

00000000800027f6 <iget>:
{
    800027f6:	7179                	addi	sp,sp,-48
    800027f8:	f406                	sd	ra,40(sp)
    800027fa:	f022                	sd	s0,32(sp)
    800027fc:	ec26                	sd	s1,24(sp)
    800027fe:	e84a                	sd	s2,16(sp)
    80002800:	e44e                	sd	s3,8(sp)
    80002802:	e052                	sd	s4,0(sp)
    80002804:	1800                	addi	s0,sp,48
    80002806:	89aa                	mv	s3,a0
    80002808:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    8000280a:	00015517          	auipc	a0,0x15
    8000280e:	d6e50513          	addi	a0,a0,-658 # 80017578 <itable>
    80002812:	00004097          	auipc	ra,0x4
    80002816:	a50080e7          	jalr	-1456(ra) # 80006262 <acquire>
  empty = 0;
    8000281a:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000281c:	00015497          	auipc	s1,0x15
    80002820:	d7448493          	addi	s1,s1,-652 # 80017590 <itable+0x18>
    80002824:	00016697          	auipc	a3,0x16
    80002828:	7fc68693          	addi	a3,a3,2044 # 80019020 <log>
    8000282c:	a039                	j	8000283a <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000282e:	02090b63          	beqz	s2,80002864 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002832:	08848493          	addi	s1,s1,136
    80002836:	02d48a63          	beq	s1,a3,8000286a <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    8000283a:	449c                	lw	a5,8(s1)
    8000283c:	fef059e3          	blez	a5,8000282e <iget+0x38>
    80002840:	4098                	lw	a4,0(s1)
    80002842:	ff3716e3          	bne	a4,s3,8000282e <iget+0x38>
    80002846:	40d8                	lw	a4,4(s1)
    80002848:	ff4713e3          	bne	a4,s4,8000282e <iget+0x38>
      ip->ref++;
    8000284c:	2785                	addiw	a5,a5,1
    8000284e:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002850:	00015517          	auipc	a0,0x15
    80002854:	d2850513          	addi	a0,a0,-728 # 80017578 <itable>
    80002858:	00004097          	auipc	ra,0x4
    8000285c:	aba080e7          	jalr	-1350(ra) # 80006312 <release>
      return ip;
    80002860:	8926                	mv	s2,s1
    80002862:	a03d                	j	80002890 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002864:	f7f9                	bnez	a5,80002832 <iget+0x3c>
      empty = ip;
    80002866:	8926                	mv	s2,s1
    80002868:	b7e9                	j	80002832 <iget+0x3c>
  if(empty == 0)
    8000286a:	02090c63          	beqz	s2,800028a2 <iget+0xac>
  ip->dev = dev;
    8000286e:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002872:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002876:	4785                	li	a5,1
    80002878:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    8000287c:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002880:	00015517          	auipc	a0,0x15
    80002884:	cf850513          	addi	a0,a0,-776 # 80017578 <itable>
    80002888:	00004097          	auipc	ra,0x4
    8000288c:	a8a080e7          	jalr	-1398(ra) # 80006312 <release>
}
    80002890:	854a                	mv	a0,s2
    80002892:	70a2                	ld	ra,40(sp)
    80002894:	7402                	ld	s0,32(sp)
    80002896:	64e2                	ld	s1,24(sp)
    80002898:	6942                	ld	s2,16(sp)
    8000289a:	69a2                	ld	s3,8(sp)
    8000289c:	6a02                	ld	s4,0(sp)
    8000289e:	6145                	addi	sp,sp,48
    800028a0:	8082                	ret
    panic("iget: no inodes");
    800028a2:	00006517          	auipc	a0,0x6
    800028a6:	b5e50513          	addi	a0,a0,-1186 # 80008400 <etext+0x400>
    800028aa:	00003097          	auipc	ra,0x3
    800028ae:	438080e7          	jalr	1080(ra) # 80005ce2 <panic>

00000000800028b2 <fsinit>:
fsinit(int dev) {
    800028b2:	7179                	addi	sp,sp,-48
    800028b4:	f406                	sd	ra,40(sp)
    800028b6:	f022                	sd	s0,32(sp)
    800028b8:	ec26                	sd	s1,24(sp)
    800028ba:	e84a                	sd	s2,16(sp)
    800028bc:	e44e                	sd	s3,8(sp)
    800028be:	1800                	addi	s0,sp,48
    800028c0:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800028c2:	4585                	li	a1,1
    800028c4:	00000097          	auipc	ra,0x0
    800028c8:	a86080e7          	jalr	-1402(ra) # 8000234a <bread>
    800028cc:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800028ce:	00015997          	auipc	s3,0x15
    800028d2:	c8a98993          	addi	s3,s3,-886 # 80017558 <sb>
    800028d6:	02000613          	li	a2,32
    800028da:	05850593          	addi	a1,a0,88
    800028de:	854e                	mv	a0,s3
    800028e0:	ffffe097          	auipc	ra,0xffffe
    800028e4:	8fe080e7          	jalr	-1794(ra) # 800001de <memmove>
  brelse(bp);
    800028e8:	8526                	mv	a0,s1
    800028ea:	00000097          	auipc	ra,0x0
    800028ee:	b90080e7          	jalr	-1136(ra) # 8000247a <brelse>
  if(sb.magic != FSMAGIC)
    800028f2:	0009a703          	lw	a4,0(s3)
    800028f6:	102037b7          	lui	a5,0x10203
    800028fa:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800028fe:	02f71263          	bne	a4,a5,80002922 <fsinit+0x70>
  initlog(dev, &sb);
    80002902:	00015597          	auipc	a1,0x15
    80002906:	c5658593          	addi	a1,a1,-938 # 80017558 <sb>
    8000290a:	854a                	mv	a0,s2
    8000290c:	00001097          	auipc	ra,0x1
    80002910:	b74080e7          	jalr	-1164(ra) # 80003480 <initlog>
}
    80002914:	70a2                	ld	ra,40(sp)
    80002916:	7402                	ld	s0,32(sp)
    80002918:	64e2                	ld	s1,24(sp)
    8000291a:	6942                	ld	s2,16(sp)
    8000291c:	69a2                	ld	s3,8(sp)
    8000291e:	6145                	addi	sp,sp,48
    80002920:	8082                	ret
    panic("invalid file system");
    80002922:	00006517          	auipc	a0,0x6
    80002926:	aee50513          	addi	a0,a0,-1298 # 80008410 <etext+0x410>
    8000292a:	00003097          	auipc	ra,0x3
    8000292e:	3b8080e7          	jalr	952(ra) # 80005ce2 <panic>

0000000080002932 <iinit>:
{
    80002932:	7179                	addi	sp,sp,-48
    80002934:	f406                	sd	ra,40(sp)
    80002936:	f022                	sd	s0,32(sp)
    80002938:	ec26                	sd	s1,24(sp)
    8000293a:	e84a                	sd	s2,16(sp)
    8000293c:	e44e                	sd	s3,8(sp)
    8000293e:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002940:	00006597          	auipc	a1,0x6
    80002944:	ae858593          	addi	a1,a1,-1304 # 80008428 <etext+0x428>
    80002948:	00015517          	auipc	a0,0x15
    8000294c:	c3050513          	addi	a0,a0,-976 # 80017578 <itable>
    80002950:	00004097          	auipc	ra,0x4
    80002954:	87e080e7          	jalr	-1922(ra) # 800061ce <initlock>
  for(i = 0; i < NINODE; i++) {
    80002958:	00015497          	auipc	s1,0x15
    8000295c:	c4848493          	addi	s1,s1,-952 # 800175a0 <itable+0x28>
    80002960:	00016997          	auipc	s3,0x16
    80002964:	6d098993          	addi	s3,s3,1744 # 80019030 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002968:	00006917          	auipc	s2,0x6
    8000296c:	ac890913          	addi	s2,s2,-1336 # 80008430 <etext+0x430>
    80002970:	85ca                	mv	a1,s2
    80002972:	8526                	mv	a0,s1
    80002974:	00001097          	auipc	ra,0x1
    80002978:	e66080e7          	jalr	-410(ra) # 800037da <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    8000297c:	08848493          	addi	s1,s1,136
    80002980:	ff3498e3          	bne	s1,s3,80002970 <iinit+0x3e>
}
    80002984:	70a2                	ld	ra,40(sp)
    80002986:	7402                	ld	s0,32(sp)
    80002988:	64e2                	ld	s1,24(sp)
    8000298a:	6942                	ld	s2,16(sp)
    8000298c:	69a2                	ld	s3,8(sp)
    8000298e:	6145                	addi	sp,sp,48
    80002990:	8082                	ret

0000000080002992 <ialloc>:
{
    80002992:	7139                	addi	sp,sp,-64
    80002994:	fc06                	sd	ra,56(sp)
    80002996:	f822                	sd	s0,48(sp)
    80002998:	f426                	sd	s1,40(sp)
    8000299a:	f04a                	sd	s2,32(sp)
    8000299c:	ec4e                	sd	s3,24(sp)
    8000299e:	e852                	sd	s4,16(sp)
    800029a0:	e456                	sd	s5,8(sp)
    800029a2:	e05a                	sd	s6,0(sp)
    800029a4:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    800029a6:	00015717          	auipc	a4,0x15
    800029aa:	bbe72703          	lw	a4,-1090(a4) # 80017564 <sb+0xc>
    800029ae:	4785                	li	a5,1
    800029b0:	04e7f863          	bgeu	a5,a4,80002a00 <ialloc+0x6e>
    800029b4:	8aaa                	mv	s5,a0
    800029b6:	8b2e                	mv	s6,a1
    800029b8:	893e                	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
    800029ba:	00015a17          	auipc	s4,0x15
    800029be:	b9ea0a13          	addi	s4,s4,-1122 # 80017558 <sb>
    800029c2:	00495593          	srli	a1,s2,0x4
    800029c6:	018a2783          	lw	a5,24(s4)
    800029ca:	9dbd                	addw	a1,a1,a5
    800029cc:	8556                	mv	a0,s5
    800029ce:	00000097          	auipc	ra,0x0
    800029d2:	97c080e7          	jalr	-1668(ra) # 8000234a <bread>
    800029d6:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800029d8:	05850993          	addi	s3,a0,88
    800029dc:	00f97793          	andi	a5,s2,15
    800029e0:	079a                	slli	a5,a5,0x6
    800029e2:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800029e4:	00099783          	lh	a5,0(s3)
    800029e8:	c785                	beqz	a5,80002a10 <ialloc+0x7e>
    brelse(bp);
    800029ea:	00000097          	auipc	ra,0x0
    800029ee:	a90080e7          	jalr	-1392(ra) # 8000247a <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800029f2:	0905                	addi	s2,s2,1
    800029f4:	00ca2703          	lw	a4,12(s4)
    800029f8:	0009079b          	sext.w	a5,s2
    800029fc:	fce7e3e3          	bltu	a5,a4,800029c2 <ialloc+0x30>
  panic("ialloc: no inodes");
    80002a00:	00006517          	auipc	a0,0x6
    80002a04:	a3850513          	addi	a0,a0,-1480 # 80008438 <etext+0x438>
    80002a08:	00003097          	auipc	ra,0x3
    80002a0c:	2da080e7          	jalr	730(ra) # 80005ce2 <panic>
      memset(dip, 0, sizeof(*dip));
    80002a10:	04000613          	li	a2,64
    80002a14:	4581                	li	a1,0
    80002a16:	854e                	mv	a0,s3
    80002a18:	ffffd097          	auipc	ra,0xffffd
    80002a1c:	762080e7          	jalr	1890(ra) # 8000017a <memset>
      dip->type = type;
    80002a20:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002a24:	8526                	mv	a0,s1
    80002a26:	00001097          	auipc	ra,0x1
    80002a2a:	cd0080e7          	jalr	-816(ra) # 800036f6 <log_write>
      brelse(bp);
    80002a2e:	8526                	mv	a0,s1
    80002a30:	00000097          	auipc	ra,0x0
    80002a34:	a4a080e7          	jalr	-1462(ra) # 8000247a <brelse>
      return iget(dev, inum);
    80002a38:	0009059b          	sext.w	a1,s2
    80002a3c:	8556                	mv	a0,s5
    80002a3e:	00000097          	auipc	ra,0x0
    80002a42:	db8080e7          	jalr	-584(ra) # 800027f6 <iget>
}
    80002a46:	70e2                	ld	ra,56(sp)
    80002a48:	7442                	ld	s0,48(sp)
    80002a4a:	74a2                	ld	s1,40(sp)
    80002a4c:	7902                	ld	s2,32(sp)
    80002a4e:	69e2                	ld	s3,24(sp)
    80002a50:	6a42                	ld	s4,16(sp)
    80002a52:	6aa2                	ld	s5,8(sp)
    80002a54:	6b02                	ld	s6,0(sp)
    80002a56:	6121                	addi	sp,sp,64
    80002a58:	8082                	ret

0000000080002a5a <iupdate>:
{
    80002a5a:	1101                	addi	sp,sp,-32
    80002a5c:	ec06                	sd	ra,24(sp)
    80002a5e:	e822                	sd	s0,16(sp)
    80002a60:	e426                	sd	s1,8(sp)
    80002a62:	e04a                	sd	s2,0(sp)
    80002a64:	1000                	addi	s0,sp,32
    80002a66:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002a68:	415c                	lw	a5,4(a0)
    80002a6a:	0047d79b          	srliw	a5,a5,0x4
    80002a6e:	00015597          	auipc	a1,0x15
    80002a72:	b025a583          	lw	a1,-1278(a1) # 80017570 <sb+0x18>
    80002a76:	9dbd                	addw	a1,a1,a5
    80002a78:	4108                	lw	a0,0(a0)
    80002a7a:	00000097          	auipc	ra,0x0
    80002a7e:	8d0080e7          	jalr	-1840(ra) # 8000234a <bread>
    80002a82:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002a84:	05850793          	addi	a5,a0,88
    80002a88:	40d8                	lw	a4,4(s1)
    80002a8a:	8b3d                	andi	a4,a4,15
    80002a8c:	071a                	slli	a4,a4,0x6
    80002a8e:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002a90:	04449703          	lh	a4,68(s1)
    80002a94:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002a98:	04649703          	lh	a4,70(s1)
    80002a9c:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002aa0:	04849703          	lh	a4,72(s1)
    80002aa4:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002aa8:	04a49703          	lh	a4,74(s1)
    80002aac:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002ab0:	44f8                	lw	a4,76(s1)
    80002ab2:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002ab4:	03400613          	li	a2,52
    80002ab8:	05048593          	addi	a1,s1,80
    80002abc:	00c78513          	addi	a0,a5,12
    80002ac0:	ffffd097          	auipc	ra,0xffffd
    80002ac4:	71e080e7          	jalr	1822(ra) # 800001de <memmove>
  log_write(bp);
    80002ac8:	854a                	mv	a0,s2
    80002aca:	00001097          	auipc	ra,0x1
    80002ace:	c2c080e7          	jalr	-980(ra) # 800036f6 <log_write>
  brelse(bp);
    80002ad2:	854a                	mv	a0,s2
    80002ad4:	00000097          	auipc	ra,0x0
    80002ad8:	9a6080e7          	jalr	-1626(ra) # 8000247a <brelse>
}
    80002adc:	60e2                	ld	ra,24(sp)
    80002ade:	6442                	ld	s0,16(sp)
    80002ae0:	64a2                	ld	s1,8(sp)
    80002ae2:	6902                	ld	s2,0(sp)
    80002ae4:	6105                	addi	sp,sp,32
    80002ae6:	8082                	ret

0000000080002ae8 <idup>:
{
    80002ae8:	1101                	addi	sp,sp,-32
    80002aea:	ec06                	sd	ra,24(sp)
    80002aec:	e822                	sd	s0,16(sp)
    80002aee:	e426                	sd	s1,8(sp)
    80002af0:	1000                	addi	s0,sp,32
    80002af2:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002af4:	00015517          	auipc	a0,0x15
    80002af8:	a8450513          	addi	a0,a0,-1404 # 80017578 <itable>
    80002afc:	00003097          	auipc	ra,0x3
    80002b00:	766080e7          	jalr	1894(ra) # 80006262 <acquire>
  ip->ref++;
    80002b04:	449c                	lw	a5,8(s1)
    80002b06:	2785                	addiw	a5,a5,1
    80002b08:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002b0a:	00015517          	auipc	a0,0x15
    80002b0e:	a6e50513          	addi	a0,a0,-1426 # 80017578 <itable>
    80002b12:	00004097          	auipc	ra,0x4
    80002b16:	800080e7          	jalr	-2048(ra) # 80006312 <release>
}
    80002b1a:	8526                	mv	a0,s1
    80002b1c:	60e2                	ld	ra,24(sp)
    80002b1e:	6442                	ld	s0,16(sp)
    80002b20:	64a2                	ld	s1,8(sp)
    80002b22:	6105                	addi	sp,sp,32
    80002b24:	8082                	ret

0000000080002b26 <ilock>:
{
    80002b26:	1101                	addi	sp,sp,-32
    80002b28:	ec06                	sd	ra,24(sp)
    80002b2a:	e822                	sd	s0,16(sp)
    80002b2c:	e426                	sd	s1,8(sp)
    80002b2e:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002b30:	c10d                	beqz	a0,80002b52 <ilock+0x2c>
    80002b32:	84aa                	mv	s1,a0
    80002b34:	451c                	lw	a5,8(a0)
    80002b36:	00f05e63          	blez	a5,80002b52 <ilock+0x2c>
  acquiresleep(&ip->lock);
    80002b3a:	0541                	addi	a0,a0,16
    80002b3c:	00001097          	auipc	ra,0x1
    80002b40:	cd8080e7          	jalr	-808(ra) # 80003814 <acquiresleep>
  if(ip->valid == 0){
    80002b44:	40bc                	lw	a5,64(s1)
    80002b46:	cf99                	beqz	a5,80002b64 <ilock+0x3e>
}
    80002b48:	60e2                	ld	ra,24(sp)
    80002b4a:	6442                	ld	s0,16(sp)
    80002b4c:	64a2                	ld	s1,8(sp)
    80002b4e:	6105                	addi	sp,sp,32
    80002b50:	8082                	ret
    80002b52:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80002b54:	00006517          	auipc	a0,0x6
    80002b58:	8fc50513          	addi	a0,a0,-1796 # 80008450 <etext+0x450>
    80002b5c:	00003097          	auipc	ra,0x3
    80002b60:	186080e7          	jalr	390(ra) # 80005ce2 <panic>
    80002b64:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b66:	40dc                	lw	a5,4(s1)
    80002b68:	0047d79b          	srliw	a5,a5,0x4
    80002b6c:	00015597          	auipc	a1,0x15
    80002b70:	a045a583          	lw	a1,-1532(a1) # 80017570 <sb+0x18>
    80002b74:	9dbd                	addw	a1,a1,a5
    80002b76:	4088                	lw	a0,0(s1)
    80002b78:	fffff097          	auipc	ra,0xfffff
    80002b7c:	7d2080e7          	jalr	2002(ra) # 8000234a <bread>
    80002b80:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b82:	05850593          	addi	a1,a0,88
    80002b86:	40dc                	lw	a5,4(s1)
    80002b88:	8bbd                	andi	a5,a5,15
    80002b8a:	079a                	slli	a5,a5,0x6
    80002b8c:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002b8e:	00059783          	lh	a5,0(a1)
    80002b92:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002b96:	00259783          	lh	a5,2(a1)
    80002b9a:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002b9e:	00459783          	lh	a5,4(a1)
    80002ba2:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002ba6:	00659783          	lh	a5,6(a1)
    80002baa:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002bae:	459c                	lw	a5,8(a1)
    80002bb0:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002bb2:	03400613          	li	a2,52
    80002bb6:	05b1                	addi	a1,a1,12
    80002bb8:	05048513          	addi	a0,s1,80
    80002bbc:	ffffd097          	auipc	ra,0xffffd
    80002bc0:	622080e7          	jalr	1570(ra) # 800001de <memmove>
    brelse(bp);
    80002bc4:	854a                	mv	a0,s2
    80002bc6:	00000097          	auipc	ra,0x0
    80002bca:	8b4080e7          	jalr	-1868(ra) # 8000247a <brelse>
    ip->valid = 1;
    80002bce:	4785                	li	a5,1
    80002bd0:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002bd2:	04449783          	lh	a5,68(s1)
    80002bd6:	c399                	beqz	a5,80002bdc <ilock+0xb6>
    80002bd8:	6902                	ld	s2,0(sp)
    80002bda:	b7bd                	j	80002b48 <ilock+0x22>
      panic("ilock: no type");
    80002bdc:	00006517          	auipc	a0,0x6
    80002be0:	87c50513          	addi	a0,a0,-1924 # 80008458 <etext+0x458>
    80002be4:	00003097          	auipc	ra,0x3
    80002be8:	0fe080e7          	jalr	254(ra) # 80005ce2 <panic>

0000000080002bec <iunlock>:
{
    80002bec:	1101                	addi	sp,sp,-32
    80002bee:	ec06                	sd	ra,24(sp)
    80002bf0:	e822                	sd	s0,16(sp)
    80002bf2:	e426                	sd	s1,8(sp)
    80002bf4:	e04a                	sd	s2,0(sp)
    80002bf6:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002bf8:	c905                	beqz	a0,80002c28 <iunlock+0x3c>
    80002bfa:	84aa                	mv	s1,a0
    80002bfc:	01050913          	addi	s2,a0,16
    80002c00:	854a                	mv	a0,s2
    80002c02:	00001097          	auipc	ra,0x1
    80002c06:	cac080e7          	jalr	-852(ra) # 800038ae <holdingsleep>
    80002c0a:	cd19                	beqz	a0,80002c28 <iunlock+0x3c>
    80002c0c:	449c                	lw	a5,8(s1)
    80002c0e:	00f05d63          	blez	a5,80002c28 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002c12:	854a                	mv	a0,s2
    80002c14:	00001097          	auipc	ra,0x1
    80002c18:	c56080e7          	jalr	-938(ra) # 8000386a <releasesleep>
}
    80002c1c:	60e2                	ld	ra,24(sp)
    80002c1e:	6442                	ld	s0,16(sp)
    80002c20:	64a2                	ld	s1,8(sp)
    80002c22:	6902                	ld	s2,0(sp)
    80002c24:	6105                	addi	sp,sp,32
    80002c26:	8082                	ret
    panic("iunlock");
    80002c28:	00006517          	auipc	a0,0x6
    80002c2c:	84050513          	addi	a0,a0,-1984 # 80008468 <etext+0x468>
    80002c30:	00003097          	auipc	ra,0x3
    80002c34:	0b2080e7          	jalr	178(ra) # 80005ce2 <panic>

0000000080002c38 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002c38:	7179                	addi	sp,sp,-48
    80002c3a:	f406                	sd	ra,40(sp)
    80002c3c:	f022                	sd	s0,32(sp)
    80002c3e:	ec26                	sd	s1,24(sp)
    80002c40:	e84a                	sd	s2,16(sp)
    80002c42:	e44e                	sd	s3,8(sp)
    80002c44:	1800                	addi	s0,sp,48
    80002c46:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002c48:	05050493          	addi	s1,a0,80
    80002c4c:	08050913          	addi	s2,a0,128
    80002c50:	a021                	j	80002c58 <itrunc+0x20>
    80002c52:	0491                	addi	s1,s1,4
    80002c54:	01248d63          	beq	s1,s2,80002c6e <itrunc+0x36>
    if(ip->addrs[i]){
    80002c58:	408c                	lw	a1,0(s1)
    80002c5a:	dde5                	beqz	a1,80002c52 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80002c5c:	0009a503          	lw	a0,0(s3)
    80002c60:	00000097          	auipc	ra,0x0
    80002c64:	92a080e7          	jalr	-1750(ra) # 8000258a <bfree>
      ip->addrs[i] = 0;
    80002c68:	0004a023          	sw	zero,0(s1)
    80002c6c:	b7dd                	j	80002c52 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002c6e:	0809a583          	lw	a1,128(s3)
    80002c72:	ed99                	bnez	a1,80002c90 <itrunc+0x58>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002c74:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002c78:	854e                	mv	a0,s3
    80002c7a:	00000097          	auipc	ra,0x0
    80002c7e:	de0080e7          	jalr	-544(ra) # 80002a5a <iupdate>
}
    80002c82:	70a2                	ld	ra,40(sp)
    80002c84:	7402                	ld	s0,32(sp)
    80002c86:	64e2                	ld	s1,24(sp)
    80002c88:	6942                	ld	s2,16(sp)
    80002c8a:	69a2                	ld	s3,8(sp)
    80002c8c:	6145                	addi	sp,sp,48
    80002c8e:	8082                	ret
    80002c90:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002c92:	0009a503          	lw	a0,0(s3)
    80002c96:	fffff097          	auipc	ra,0xfffff
    80002c9a:	6b4080e7          	jalr	1716(ra) # 8000234a <bread>
    80002c9e:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002ca0:	05850493          	addi	s1,a0,88
    80002ca4:	45850913          	addi	s2,a0,1112
    80002ca8:	a021                	j	80002cb0 <itrunc+0x78>
    80002caa:	0491                	addi	s1,s1,4
    80002cac:	01248b63          	beq	s1,s2,80002cc2 <itrunc+0x8a>
      if(a[j])
    80002cb0:	408c                	lw	a1,0(s1)
    80002cb2:	dde5                	beqz	a1,80002caa <itrunc+0x72>
        bfree(ip->dev, a[j]);
    80002cb4:	0009a503          	lw	a0,0(s3)
    80002cb8:	00000097          	auipc	ra,0x0
    80002cbc:	8d2080e7          	jalr	-1838(ra) # 8000258a <bfree>
    80002cc0:	b7ed                	j	80002caa <itrunc+0x72>
    brelse(bp);
    80002cc2:	8552                	mv	a0,s4
    80002cc4:	fffff097          	auipc	ra,0xfffff
    80002cc8:	7b6080e7          	jalr	1974(ra) # 8000247a <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002ccc:	0809a583          	lw	a1,128(s3)
    80002cd0:	0009a503          	lw	a0,0(s3)
    80002cd4:	00000097          	auipc	ra,0x0
    80002cd8:	8b6080e7          	jalr	-1866(ra) # 8000258a <bfree>
    ip->addrs[NDIRECT] = 0;
    80002cdc:	0809a023          	sw	zero,128(s3)
    80002ce0:	6a02                	ld	s4,0(sp)
    80002ce2:	bf49                	j	80002c74 <itrunc+0x3c>

0000000080002ce4 <iput>:
{
    80002ce4:	1101                	addi	sp,sp,-32
    80002ce6:	ec06                	sd	ra,24(sp)
    80002ce8:	e822                	sd	s0,16(sp)
    80002cea:	e426                	sd	s1,8(sp)
    80002cec:	1000                	addi	s0,sp,32
    80002cee:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002cf0:	00015517          	auipc	a0,0x15
    80002cf4:	88850513          	addi	a0,a0,-1912 # 80017578 <itable>
    80002cf8:	00003097          	auipc	ra,0x3
    80002cfc:	56a080e7          	jalr	1386(ra) # 80006262 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002d00:	4498                	lw	a4,8(s1)
    80002d02:	4785                	li	a5,1
    80002d04:	02f70263          	beq	a4,a5,80002d28 <iput+0x44>
  ip->ref--;
    80002d08:	449c                	lw	a5,8(s1)
    80002d0a:	37fd                	addiw	a5,a5,-1
    80002d0c:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002d0e:	00015517          	auipc	a0,0x15
    80002d12:	86a50513          	addi	a0,a0,-1942 # 80017578 <itable>
    80002d16:	00003097          	auipc	ra,0x3
    80002d1a:	5fc080e7          	jalr	1532(ra) # 80006312 <release>
}
    80002d1e:	60e2                	ld	ra,24(sp)
    80002d20:	6442                	ld	s0,16(sp)
    80002d22:	64a2                	ld	s1,8(sp)
    80002d24:	6105                	addi	sp,sp,32
    80002d26:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002d28:	40bc                	lw	a5,64(s1)
    80002d2a:	dff9                	beqz	a5,80002d08 <iput+0x24>
    80002d2c:	04a49783          	lh	a5,74(s1)
    80002d30:	ffe1                	bnez	a5,80002d08 <iput+0x24>
    80002d32:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80002d34:	01048913          	addi	s2,s1,16
    80002d38:	854a                	mv	a0,s2
    80002d3a:	00001097          	auipc	ra,0x1
    80002d3e:	ada080e7          	jalr	-1318(ra) # 80003814 <acquiresleep>
    release(&itable.lock);
    80002d42:	00015517          	auipc	a0,0x15
    80002d46:	83650513          	addi	a0,a0,-1994 # 80017578 <itable>
    80002d4a:	00003097          	auipc	ra,0x3
    80002d4e:	5c8080e7          	jalr	1480(ra) # 80006312 <release>
    itrunc(ip);
    80002d52:	8526                	mv	a0,s1
    80002d54:	00000097          	auipc	ra,0x0
    80002d58:	ee4080e7          	jalr	-284(ra) # 80002c38 <itrunc>
    ip->type = 0;
    80002d5c:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002d60:	8526                	mv	a0,s1
    80002d62:	00000097          	auipc	ra,0x0
    80002d66:	cf8080e7          	jalr	-776(ra) # 80002a5a <iupdate>
    ip->valid = 0;
    80002d6a:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002d6e:	854a                	mv	a0,s2
    80002d70:	00001097          	auipc	ra,0x1
    80002d74:	afa080e7          	jalr	-1286(ra) # 8000386a <releasesleep>
    acquire(&itable.lock);
    80002d78:	00015517          	auipc	a0,0x15
    80002d7c:	80050513          	addi	a0,a0,-2048 # 80017578 <itable>
    80002d80:	00003097          	auipc	ra,0x3
    80002d84:	4e2080e7          	jalr	1250(ra) # 80006262 <acquire>
    80002d88:	6902                	ld	s2,0(sp)
    80002d8a:	bfbd                	j	80002d08 <iput+0x24>

0000000080002d8c <iunlockput>:
{
    80002d8c:	1101                	addi	sp,sp,-32
    80002d8e:	ec06                	sd	ra,24(sp)
    80002d90:	e822                	sd	s0,16(sp)
    80002d92:	e426                	sd	s1,8(sp)
    80002d94:	1000                	addi	s0,sp,32
    80002d96:	84aa                	mv	s1,a0
  iunlock(ip);
    80002d98:	00000097          	auipc	ra,0x0
    80002d9c:	e54080e7          	jalr	-428(ra) # 80002bec <iunlock>
  iput(ip);
    80002da0:	8526                	mv	a0,s1
    80002da2:	00000097          	auipc	ra,0x0
    80002da6:	f42080e7          	jalr	-190(ra) # 80002ce4 <iput>
}
    80002daa:	60e2                	ld	ra,24(sp)
    80002dac:	6442                	ld	s0,16(sp)
    80002dae:	64a2                	ld	s1,8(sp)
    80002db0:	6105                	addi	sp,sp,32
    80002db2:	8082                	ret

0000000080002db4 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002db4:	1141                	addi	sp,sp,-16
    80002db6:	e406                	sd	ra,8(sp)
    80002db8:	e022                	sd	s0,0(sp)
    80002dba:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002dbc:	411c                	lw	a5,0(a0)
    80002dbe:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002dc0:	415c                	lw	a5,4(a0)
    80002dc2:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002dc4:	04451783          	lh	a5,68(a0)
    80002dc8:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002dcc:	04a51783          	lh	a5,74(a0)
    80002dd0:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002dd4:	04c56783          	lwu	a5,76(a0)
    80002dd8:	e99c                	sd	a5,16(a1)
}
    80002dda:	60a2                	ld	ra,8(sp)
    80002ddc:	6402                	ld	s0,0(sp)
    80002dde:	0141                	addi	sp,sp,16
    80002de0:	8082                	ret

0000000080002de2 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002de2:	457c                	lw	a5,76(a0)
    80002de4:	0ed7ea63          	bltu	a5,a3,80002ed8 <readi+0xf6>
{
    80002de8:	7159                	addi	sp,sp,-112
    80002dea:	f486                	sd	ra,104(sp)
    80002dec:	f0a2                	sd	s0,96(sp)
    80002dee:	eca6                	sd	s1,88(sp)
    80002df0:	fc56                	sd	s5,56(sp)
    80002df2:	f85a                	sd	s6,48(sp)
    80002df4:	f45e                	sd	s7,40(sp)
    80002df6:	ec66                	sd	s9,24(sp)
    80002df8:	1880                	addi	s0,sp,112
    80002dfa:	8baa                	mv	s7,a0
    80002dfc:	8cae                	mv	s9,a1
    80002dfe:	8ab2                	mv	s5,a2
    80002e00:	84b6                	mv	s1,a3
    80002e02:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002e04:	9f35                	addw	a4,a4,a3
    return 0;
    80002e06:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002e08:	0ad76763          	bltu	a4,a3,80002eb6 <readi+0xd4>
    80002e0c:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80002e0e:	00e7f463          	bgeu	a5,a4,80002e16 <readi+0x34>
    n = ip->size - off;
    80002e12:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002e16:	0a0b0f63          	beqz	s6,80002ed4 <readi+0xf2>
    80002e1a:	e8ca                	sd	s2,80(sp)
    80002e1c:	e0d2                	sd	s4,64(sp)
    80002e1e:	f062                	sd	s8,32(sp)
    80002e20:	e86a                	sd	s10,16(sp)
    80002e22:	e46e                	sd	s11,8(sp)
    80002e24:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002e26:	40000d93          	li	s11,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002e2a:	5d7d                	li	s10,-1
    80002e2c:	a82d                	j	80002e66 <readi+0x84>
    80002e2e:	020a1c13          	slli	s8,s4,0x20
    80002e32:	020c5c13          	srli	s8,s8,0x20
    80002e36:	05890613          	addi	a2,s2,88
    80002e3a:	86e2                	mv	a3,s8
    80002e3c:	963e                	add	a2,a2,a5
    80002e3e:	85d6                	mv	a1,s5
    80002e40:	8566                	mv	a0,s9
    80002e42:	fffff097          	auipc	ra,0xfffff
    80002e46:	a96080e7          	jalr	-1386(ra) # 800018d8 <either_copyout>
    80002e4a:	05a50963          	beq	a0,s10,80002e9c <readi+0xba>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002e4e:	854a                	mv	a0,s2
    80002e50:	fffff097          	auipc	ra,0xfffff
    80002e54:	62a080e7          	jalr	1578(ra) # 8000247a <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002e58:	013a09bb          	addw	s3,s4,s3
    80002e5c:	009a04bb          	addw	s1,s4,s1
    80002e60:	9ae2                	add	s5,s5,s8
    80002e62:	0769f363          	bgeu	s3,s6,80002ec8 <readi+0xe6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002e66:	000ba903          	lw	s2,0(s7)
    80002e6a:	00a4d59b          	srliw	a1,s1,0xa
    80002e6e:	855e                	mv	a0,s7
    80002e70:	00000097          	auipc	ra,0x0
    80002e74:	8b8080e7          	jalr	-1864(ra) # 80002728 <bmap>
    80002e78:	85aa                	mv	a1,a0
    80002e7a:	854a                	mv	a0,s2
    80002e7c:	fffff097          	auipc	ra,0xfffff
    80002e80:	4ce080e7          	jalr	1230(ra) # 8000234a <bread>
    80002e84:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002e86:	3ff4f793          	andi	a5,s1,1023
    80002e8a:	40fd873b          	subw	a4,s11,a5
    80002e8e:	413b06bb          	subw	a3,s6,s3
    80002e92:	8a3a                	mv	s4,a4
    80002e94:	f8e6fde3          	bgeu	a3,a4,80002e2e <readi+0x4c>
    80002e98:	8a36                	mv	s4,a3
    80002e9a:	bf51                	j	80002e2e <readi+0x4c>
      brelse(bp);
    80002e9c:	854a                	mv	a0,s2
    80002e9e:	fffff097          	auipc	ra,0xfffff
    80002ea2:	5dc080e7          	jalr	1500(ra) # 8000247a <brelse>
      tot = -1;
    80002ea6:	59fd                	li	s3,-1
      break;
    80002ea8:	6946                	ld	s2,80(sp)
    80002eaa:	6a06                	ld	s4,64(sp)
    80002eac:	7c02                	ld	s8,32(sp)
    80002eae:	6d42                	ld	s10,16(sp)
    80002eb0:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80002eb2:	854e                	mv	a0,s3
    80002eb4:	69a6                	ld	s3,72(sp)
}
    80002eb6:	70a6                	ld	ra,104(sp)
    80002eb8:	7406                	ld	s0,96(sp)
    80002eba:	64e6                	ld	s1,88(sp)
    80002ebc:	7ae2                	ld	s5,56(sp)
    80002ebe:	7b42                	ld	s6,48(sp)
    80002ec0:	7ba2                	ld	s7,40(sp)
    80002ec2:	6ce2                	ld	s9,24(sp)
    80002ec4:	6165                	addi	sp,sp,112
    80002ec6:	8082                	ret
    80002ec8:	6946                	ld	s2,80(sp)
    80002eca:	6a06                	ld	s4,64(sp)
    80002ecc:	7c02                	ld	s8,32(sp)
    80002ece:	6d42                	ld	s10,16(sp)
    80002ed0:	6da2                	ld	s11,8(sp)
    80002ed2:	b7c5                	j	80002eb2 <readi+0xd0>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002ed4:	89da                	mv	s3,s6
    80002ed6:	bff1                	j	80002eb2 <readi+0xd0>
    return 0;
    80002ed8:	4501                	li	a0,0
}
    80002eda:	8082                	ret

0000000080002edc <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002edc:	457c                	lw	a5,76(a0)
    80002ede:	10d7e963          	bltu	a5,a3,80002ff0 <writei+0x114>
{
    80002ee2:	7159                	addi	sp,sp,-112
    80002ee4:	f486                	sd	ra,104(sp)
    80002ee6:	f0a2                	sd	s0,96(sp)
    80002ee8:	e8ca                	sd	s2,80(sp)
    80002eea:	fc56                	sd	s5,56(sp)
    80002eec:	f45e                	sd	s7,40(sp)
    80002eee:	f062                	sd	s8,32(sp)
    80002ef0:	ec66                	sd	s9,24(sp)
    80002ef2:	1880                	addi	s0,sp,112
    80002ef4:	8baa                	mv	s7,a0
    80002ef6:	8cae                	mv	s9,a1
    80002ef8:	8ab2                	mv	s5,a2
    80002efa:	8936                	mv	s2,a3
    80002efc:	8c3a                	mv	s8,a4
  if(off > ip->size || off + n < off)
    80002efe:	00e687bb          	addw	a5,a3,a4
    80002f02:	0ed7e963          	bltu	a5,a3,80002ff4 <writei+0x118>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002f06:	00043737          	lui	a4,0x43
    80002f0a:	0ef76763          	bltu	a4,a5,80002ff8 <writei+0x11c>
    80002f0e:	e0d2                	sd	s4,64(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002f10:	0c0c0863          	beqz	s8,80002fe0 <writei+0x104>
    80002f14:	eca6                	sd	s1,88(sp)
    80002f16:	e4ce                	sd	s3,72(sp)
    80002f18:	f85a                	sd	s6,48(sp)
    80002f1a:	e86a                	sd	s10,16(sp)
    80002f1c:	e46e                	sd	s11,8(sp)
    80002f1e:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f20:	40000d93          	li	s11,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002f24:	5d7d                	li	s10,-1
    80002f26:	a091                	j	80002f6a <writei+0x8e>
    80002f28:	02099b13          	slli	s6,s3,0x20
    80002f2c:	020b5b13          	srli	s6,s6,0x20
    80002f30:	05848513          	addi	a0,s1,88
    80002f34:	86da                	mv	a3,s6
    80002f36:	8656                	mv	a2,s5
    80002f38:	85e6                	mv	a1,s9
    80002f3a:	953e                	add	a0,a0,a5
    80002f3c:	fffff097          	auipc	ra,0xfffff
    80002f40:	9f2080e7          	jalr	-1550(ra) # 8000192e <either_copyin>
    80002f44:	05a50e63          	beq	a0,s10,80002fa0 <writei+0xc4>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002f48:	8526                	mv	a0,s1
    80002f4a:	00000097          	auipc	ra,0x0
    80002f4e:	7ac080e7          	jalr	1964(ra) # 800036f6 <log_write>
    brelse(bp);
    80002f52:	8526                	mv	a0,s1
    80002f54:	fffff097          	auipc	ra,0xfffff
    80002f58:	526080e7          	jalr	1318(ra) # 8000247a <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002f5c:	01498a3b          	addw	s4,s3,s4
    80002f60:	0129893b          	addw	s2,s3,s2
    80002f64:	9ada                	add	s5,s5,s6
    80002f66:	058a7263          	bgeu	s4,s8,80002faa <writei+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002f6a:	000ba483          	lw	s1,0(s7)
    80002f6e:	00a9559b          	srliw	a1,s2,0xa
    80002f72:	855e                	mv	a0,s7
    80002f74:	fffff097          	auipc	ra,0xfffff
    80002f78:	7b4080e7          	jalr	1972(ra) # 80002728 <bmap>
    80002f7c:	85aa                	mv	a1,a0
    80002f7e:	8526                	mv	a0,s1
    80002f80:	fffff097          	auipc	ra,0xfffff
    80002f84:	3ca080e7          	jalr	970(ra) # 8000234a <bread>
    80002f88:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f8a:	3ff97793          	andi	a5,s2,1023
    80002f8e:	40fd873b          	subw	a4,s11,a5
    80002f92:	414c06bb          	subw	a3,s8,s4
    80002f96:	89ba                	mv	s3,a4
    80002f98:	f8e6f8e3          	bgeu	a3,a4,80002f28 <writei+0x4c>
    80002f9c:	89b6                	mv	s3,a3
    80002f9e:	b769                	j	80002f28 <writei+0x4c>
      brelse(bp);
    80002fa0:	8526                	mv	a0,s1
    80002fa2:	fffff097          	auipc	ra,0xfffff
    80002fa6:	4d8080e7          	jalr	1240(ra) # 8000247a <brelse>
  }

  if(off > ip->size)
    80002faa:	04cba783          	lw	a5,76(s7)
    80002fae:	0327fb63          	bgeu	a5,s2,80002fe4 <writei+0x108>
    ip->size = off;
    80002fb2:	052ba623          	sw	s2,76(s7)
    80002fb6:	64e6                	ld	s1,88(sp)
    80002fb8:	69a6                	ld	s3,72(sp)
    80002fba:	7b42                	ld	s6,48(sp)
    80002fbc:	6d42                	ld	s10,16(sp)
    80002fbe:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002fc0:	855e                	mv	a0,s7
    80002fc2:	00000097          	auipc	ra,0x0
    80002fc6:	a98080e7          	jalr	-1384(ra) # 80002a5a <iupdate>

  return tot;
    80002fca:	8552                	mv	a0,s4
    80002fcc:	6a06                	ld	s4,64(sp)
}
    80002fce:	70a6                	ld	ra,104(sp)
    80002fd0:	7406                	ld	s0,96(sp)
    80002fd2:	6946                	ld	s2,80(sp)
    80002fd4:	7ae2                	ld	s5,56(sp)
    80002fd6:	7ba2                	ld	s7,40(sp)
    80002fd8:	7c02                	ld	s8,32(sp)
    80002fda:	6ce2                	ld	s9,24(sp)
    80002fdc:	6165                	addi	sp,sp,112
    80002fde:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002fe0:	8a62                	mv	s4,s8
    80002fe2:	bff9                	j	80002fc0 <writei+0xe4>
    80002fe4:	64e6                	ld	s1,88(sp)
    80002fe6:	69a6                	ld	s3,72(sp)
    80002fe8:	7b42                	ld	s6,48(sp)
    80002fea:	6d42                	ld	s10,16(sp)
    80002fec:	6da2                	ld	s11,8(sp)
    80002fee:	bfc9                	j	80002fc0 <writei+0xe4>
    return -1;
    80002ff0:	557d                	li	a0,-1
}
    80002ff2:	8082                	ret
    return -1;
    80002ff4:	557d                	li	a0,-1
    80002ff6:	bfe1                	j	80002fce <writei+0xf2>
    return -1;
    80002ff8:	557d                	li	a0,-1
    80002ffa:	bfd1                	j	80002fce <writei+0xf2>

0000000080002ffc <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002ffc:	1141                	addi	sp,sp,-16
    80002ffe:	e406                	sd	ra,8(sp)
    80003000:	e022                	sd	s0,0(sp)
    80003002:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003004:	4639                	li	a2,14
    80003006:	ffffd097          	auipc	ra,0xffffd
    8000300a:	250080e7          	jalr	592(ra) # 80000256 <strncmp>
}
    8000300e:	60a2                	ld	ra,8(sp)
    80003010:	6402                	ld	s0,0(sp)
    80003012:	0141                	addi	sp,sp,16
    80003014:	8082                	ret

0000000080003016 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003016:	711d                	addi	sp,sp,-96
    80003018:	ec86                	sd	ra,88(sp)
    8000301a:	e8a2                	sd	s0,80(sp)
    8000301c:	e4a6                	sd	s1,72(sp)
    8000301e:	e0ca                	sd	s2,64(sp)
    80003020:	fc4e                	sd	s3,56(sp)
    80003022:	f852                	sd	s4,48(sp)
    80003024:	f456                	sd	s5,40(sp)
    80003026:	f05a                	sd	s6,32(sp)
    80003028:	ec5e                	sd	s7,24(sp)
    8000302a:	1080                	addi	s0,sp,96
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    8000302c:	04451703          	lh	a4,68(a0)
    80003030:	4785                	li	a5,1
    80003032:	00f71f63          	bne	a4,a5,80003050 <dirlookup+0x3a>
    80003036:	892a                	mv	s2,a0
    80003038:	8aae                	mv	s5,a1
    8000303a:	8bb2                	mv	s7,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    8000303c:	457c                	lw	a5,76(a0)
    8000303e:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003040:	fa040a13          	addi	s4,s0,-96
    80003044:	49c1                	li	s3,16
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
    80003046:	fa240b13          	addi	s6,s0,-94
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    8000304a:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000304c:	e79d                	bnez	a5,8000307a <dirlookup+0x64>
    8000304e:	a88d                	j	800030c0 <dirlookup+0xaa>
    panic("dirlookup not DIR");
    80003050:	00005517          	auipc	a0,0x5
    80003054:	42050513          	addi	a0,a0,1056 # 80008470 <etext+0x470>
    80003058:	00003097          	auipc	ra,0x3
    8000305c:	c8a080e7          	jalr	-886(ra) # 80005ce2 <panic>
      panic("dirlookup read");
    80003060:	00005517          	auipc	a0,0x5
    80003064:	42850513          	addi	a0,a0,1064 # 80008488 <etext+0x488>
    80003068:	00003097          	auipc	ra,0x3
    8000306c:	c7a080e7          	jalr	-902(ra) # 80005ce2 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003070:	24c1                	addiw	s1,s1,16
    80003072:	04c92783          	lw	a5,76(s2)
    80003076:	04f4f463          	bgeu	s1,a5,800030be <dirlookup+0xa8>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000307a:	874e                	mv	a4,s3
    8000307c:	86a6                	mv	a3,s1
    8000307e:	8652                	mv	a2,s4
    80003080:	4581                	li	a1,0
    80003082:	854a                	mv	a0,s2
    80003084:	00000097          	auipc	ra,0x0
    80003088:	d5e080e7          	jalr	-674(ra) # 80002de2 <readi>
    8000308c:	fd351ae3          	bne	a0,s3,80003060 <dirlookup+0x4a>
    if(de.inum == 0)
    80003090:	fa045783          	lhu	a5,-96(s0)
    80003094:	dff1                	beqz	a5,80003070 <dirlookup+0x5a>
    if(namecmp(name, de.name) == 0){
    80003096:	85da                	mv	a1,s6
    80003098:	8556                	mv	a0,s5
    8000309a:	00000097          	auipc	ra,0x0
    8000309e:	f62080e7          	jalr	-158(ra) # 80002ffc <namecmp>
    800030a2:	f579                	bnez	a0,80003070 <dirlookup+0x5a>
      if(poff)
    800030a4:	000b8463          	beqz	s7,800030ac <dirlookup+0x96>
        *poff = off;
    800030a8:	009ba023          	sw	s1,0(s7)
      return iget(dp->dev, inum);
    800030ac:	fa045583          	lhu	a1,-96(s0)
    800030b0:	00092503          	lw	a0,0(s2)
    800030b4:	fffff097          	auipc	ra,0xfffff
    800030b8:	742080e7          	jalr	1858(ra) # 800027f6 <iget>
    800030bc:	a011                	j	800030c0 <dirlookup+0xaa>
  return 0;
    800030be:	4501                	li	a0,0
}
    800030c0:	60e6                	ld	ra,88(sp)
    800030c2:	6446                	ld	s0,80(sp)
    800030c4:	64a6                	ld	s1,72(sp)
    800030c6:	6906                	ld	s2,64(sp)
    800030c8:	79e2                	ld	s3,56(sp)
    800030ca:	7a42                	ld	s4,48(sp)
    800030cc:	7aa2                	ld	s5,40(sp)
    800030ce:	7b02                	ld	s6,32(sp)
    800030d0:	6be2                	ld	s7,24(sp)
    800030d2:	6125                	addi	sp,sp,96
    800030d4:	8082                	ret

00000000800030d6 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800030d6:	711d                	addi	sp,sp,-96
    800030d8:	ec86                	sd	ra,88(sp)
    800030da:	e8a2                	sd	s0,80(sp)
    800030dc:	e4a6                	sd	s1,72(sp)
    800030de:	e0ca                	sd	s2,64(sp)
    800030e0:	fc4e                	sd	s3,56(sp)
    800030e2:	f852                	sd	s4,48(sp)
    800030e4:	f456                	sd	s5,40(sp)
    800030e6:	f05a                	sd	s6,32(sp)
    800030e8:	ec5e                	sd	s7,24(sp)
    800030ea:	e862                	sd	s8,16(sp)
    800030ec:	e466                	sd	s9,8(sp)
    800030ee:	e06a                	sd	s10,0(sp)
    800030f0:	1080                	addi	s0,sp,96
    800030f2:	84aa                	mv	s1,a0
    800030f4:	8b2e                	mv	s6,a1
    800030f6:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800030f8:	00054703          	lbu	a4,0(a0)
    800030fc:	02f00793          	li	a5,47
    80003100:	02f70363          	beq	a4,a5,80003126 <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003104:	ffffe097          	auipc	ra,0xffffe
    80003108:	d70080e7          	jalr	-656(ra) # 80000e74 <myproc>
    8000310c:	15053503          	ld	a0,336(a0)
    80003110:	00000097          	auipc	ra,0x0
    80003114:	9d8080e7          	jalr	-1576(ra) # 80002ae8 <idup>
    80003118:	8a2a                	mv	s4,a0
  while(*path == '/')
    8000311a:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    8000311e:	4c35                	li	s8,13
    memmove(name, s, DIRSIZ);
    80003120:	4cb9                	li	s9,14

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003122:	4b85                	li	s7,1
    80003124:	a87d                	j	800031e2 <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    80003126:	4585                	li	a1,1
    80003128:	852e                	mv	a0,a1
    8000312a:	fffff097          	auipc	ra,0xfffff
    8000312e:	6cc080e7          	jalr	1740(ra) # 800027f6 <iget>
    80003132:	8a2a                	mv	s4,a0
    80003134:	b7dd                	j	8000311a <namex+0x44>
      iunlockput(ip);
    80003136:	8552                	mv	a0,s4
    80003138:	00000097          	auipc	ra,0x0
    8000313c:	c54080e7          	jalr	-940(ra) # 80002d8c <iunlockput>
      return 0;
    80003140:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003142:	8552                	mv	a0,s4
    80003144:	60e6                	ld	ra,88(sp)
    80003146:	6446                	ld	s0,80(sp)
    80003148:	64a6                	ld	s1,72(sp)
    8000314a:	6906                	ld	s2,64(sp)
    8000314c:	79e2                	ld	s3,56(sp)
    8000314e:	7a42                	ld	s4,48(sp)
    80003150:	7aa2                	ld	s5,40(sp)
    80003152:	7b02                	ld	s6,32(sp)
    80003154:	6be2                	ld	s7,24(sp)
    80003156:	6c42                	ld	s8,16(sp)
    80003158:	6ca2                	ld	s9,8(sp)
    8000315a:	6d02                	ld	s10,0(sp)
    8000315c:	6125                	addi	sp,sp,96
    8000315e:	8082                	ret
      iunlock(ip);
    80003160:	8552                	mv	a0,s4
    80003162:	00000097          	auipc	ra,0x0
    80003166:	a8a080e7          	jalr	-1398(ra) # 80002bec <iunlock>
      return ip;
    8000316a:	bfe1                	j	80003142 <namex+0x6c>
      iunlockput(ip);
    8000316c:	8552                	mv	a0,s4
    8000316e:	00000097          	auipc	ra,0x0
    80003172:	c1e080e7          	jalr	-994(ra) # 80002d8c <iunlockput>
      return 0;
    80003176:	8a4e                	mv	s4,s3
    80003178:	b7e9                	j	80003142 <namex+0x6c>
  len = path - s;
    8000317a:	40998633          	sub	a2,s3,s1
    8000317e:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    80003182:	09ac5863          	bge	s8,s10,80003212 <namex+0x13c>
    memmove(name, s, DIRSIZ);
    80003186:	8666                	mv	a2,s9
    80003188:	85a6                	mv	a1,s1
    8000318a:	8556                	mv	a0,s5
    8000318c:	ffffd097          	auipc	ra,0xffffd
    80003190:	052080e7          	jalr	82(ra) # 800001de <memmove>
    80003194:	84ce                	mv	s1,s3
  while(*path == '/')
    80003196:	0004c783          	lbu	a5,0(s1)
    8000319a:	01279763          	bne	a5,s2,800031a8 <namex+0xd2>
    path++;
    8000319e:	0485                	addi	s1,s1,1
  while(*path == '/')
    800031a0:	0004c783          	lbu	a5,0(s1)
    800031a4:	ff278de3          	beq	a5,s2,8000319e <namex+0xc8>
    ilock(ip);
    800031a8:	8552                	mv	a0,s4
    800031aa:	00000097          	auipc	ra,0x0
    800031ae:	97c080e7          	jalr	-1668(ra) # 80002b26 <ilock>
    if(ip->type != T_DIR){
    800031b2:	044a1783          	lh	a5,68(s4)
    800031b6:	f97790e3          	bne	a5,s7,80003136 <namex+0x60>
    if(nameiparent && *path == '\0'){
    800031ba:	000b0563          	beqz	s6,800031c4 <namex+0xee>
    800031be:	0004c783          	lbu	a5,0(s1)
    800031c2:	dfd9                	beqz	a5,80003160 <namex+0x8a>
    if((next = dirlookup(ip, name, 0)) == 0){
    800031c4:	4601                	li	a2,0
    800031c6:	85d6                	mv	a1,s5
    800031c8:	8552                	mv	a0,s4
    800031ca:	00000097          	auipc	ra,0x0
    800031ce:	e4c080e7          	jalr	-436(ra) # 80003016 <dirlookup>
    800031d2:	89aa                	mv	s3,a0
    800031d4:	dd41                	beqz	a0,8000316c <namex+0x96>
    iunlockput(ip);
    800031d6:	8552                	mv	a0,s4
    800031d8:	00000097          	auipc	ra,0x0
    800031dc:	bb4080e7          	jalr	-1100(ra) # 80002d8c <iunlockput>
    ip = next;
    800031e0:	8a4e                	mv	s4,s3
  while(*path == '/')
    800031e2:	0004c783          	lbu	a5,0(s1)
    800031e6:	01279763          	bne	a5,s2,800031f4 <namex+0x11e>
    path++;
    800031ea:	0485                	addi	s1,s1,1
  while(*path == '/')
    800031ec:	0004c783          	lbu	a5,0(s1)
    800031f0:	ff278de3          	beq	a5,s2,800031ea <namex+0x114>
  if(*path == 0)
    800031f4:	cb9d                	beqz	a5,8000322a <namex+0x154>
  while(*path != '/' && *path != 0)
    800031f6:	0004c783          	lbu	a5,0(s1)
    800031fa:	89a6                	mv	s3,s1
  len = path - s;
    800031fc:	4d01                	li	s10,0
    800031fe:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80003200:	01278963          	beq	a5,s2,80003212 <namex+0x13c>
    80003204:	dbbd                	beqz	a5,8000317a <namex+0xa4>
    path++;
    80003206:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80003208:	0009c783          	lbu	a5,0(s3)
    8000320c:	ff279ce3          	bne	a5,s2,80003204 <namex+0x12e>
    80003210:	b7ad                	j	8000317a <namex+0xa4>
    memmove(name, s, len);
    80003212:	2601                	sext.w	a2,a2
    80003214:	85a6                	mv	a1,s1
    80003216:	8556                	mv	a0,s5
    80003218:	ffffd097          	auipc	ra,0xffffd
    8000321c:	fc6080e7          	jalr	-58(ra) # 800001de <memmove>
    name[len] = 0;
    80003220:	9d56                	add	s10,s10,s5
    80003222:	000d0023          	sb	zero,0(s10)
    80003226:	84ce                	mv	s1,s3
    80003228:	b7bd                	j	80003196 <namex+0xc0>
  if(nameiparent){
    8000322a:	f00b0ce3          	beqz	s6,80003142 <namex+0x6c>
    iput(ip);
    8000322e:	8552                	mv	a0,s4
    80003230:	00000097          	auipc	ra,0x0
    80003234:	ab4080e7          	jalr	-1356(ra) # 80002ce4 <iput>
    return 0;
    80003238:	4a01                	li	s4,0
    8000323a:	b721                	j	80003142 <namex+0x6c>

000000008000323c <dirlink>:
{
    8000323c:	715d                	addi	sp,sp,-80
    8000323e:	e486                	sd	ra,72(sp)
    80003240:	e0a2                	sd	s0,64(sp)
    80003242:	f84a                	sd	s2,48(sp)
    80003244:	ec56                	sd	s5,24(sp)
    80003246:	e85a                	sd	s6,16(sp)
    80003248:	0880                	addi	s0,sp,80
    8000324a:	892a                	mv	s2,a0
    8000324c:	8aae                	mv	s5,a1
    8000324e:	8b32                	mv	s6,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003250:	4601                	li	a2,0
    80003252:	00000097          	auipc	ra,0x0
    80003256:	dc4080e7          	jalr	-572(ra) # 80003016 <dirlookup>
    8000325a:	e129                	bnez	a0,8000329c <dirlink+0x60>
    8000325c:	fc26                	sd	s1,56(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000325e:	04c92483          	lw	s1,76(s2)
    80003262:	cca9                	beqz	s1,800032bc <dirlink+0x80>
    80003264:	f44e                	sd	s3,40(sp)
    80003266:	f052                	sd	s4,32(sp)
    80003268:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000326a:	fb040a13          	addi	s4,s0,-80
    8000326e:	49c1                	li	s3,16
    80003270:	874e                	mv	a4,s3
    80003272:	86a6                	mv	a3,s1
    80003274:	8652                	mv	a2,s4
    80003276:	4581                	li	a1,0
    80003278:	854a                	mv	a0,s2
    8000327a:	00000097          	auipc	ra,0x0
    8000327e:	b68080e7          	jalr	-1176(ra) # 80002de2 <readi>
    80003282:	03351363          	bne	a0,s3,800032a8 <dirlink+0x6c>
    if(de.inum == 0)
    80003286:	fb045783          	lhu	a5,-80(s0)
    8000328a:	c79d                	beqz	a5,800032b8 <dirlink+0x7c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000328c:	24c1                	addiw	s1,s1,16
    8000328e:	04c92783          	lw	a5,76(s2)
    80003292:	fcf4efe3          	bltu	s1,a5,80003270 <dirlink+0x34>
    80003296:	79a2                	ld	s3,40(sp)
    80003298:	7a02                	ld	s4,32(sp)
    8000329a:	a00d                	j	800032bc <dirlink+0x80>
    iput(ip);
    8000329c:	00000097          	auipc	ra,0x0
    800032a0:	a48080e7          	jalr	-1464(ra) # 80002ce4 <iput>
    return -1;
    800032a4:	557d                	li	a0,-1
    800032a6:	a0a9                	j	800032f0 <dirlink+0xb4>
      panic("dirlink read");
    800032a8:	00005517          	auipc	a0,0x5
    800032ac:	1f050513          	addi	a0,a0,496 # 80008498 <etext+0x498>
    800032b0:	00003097          	auipc	ra,0x3
    800032b4:	a32080e7          	jalr	-1486(ra) # 80005ce2 <panic>
    800032b8:	79a2                	ld	s3,40(sp)
    800032ba:	7a02                	ld	s4,32(sp)
  strncpy(de.name, name, DIRSIZ);
    800032bc:	4639                	li	a2,14
    800032be:	85d6                	mv	a1,s5
    800032c0:	fb240513          	addi	a0,s0,-78
    800032c4:	ffffd097          	auipc	ra,0xffffd
    800032c8:	fcc080e7          	jalr	-52(ra) # 80000290 <strncpy>
  de.inum = inum;
    800032cc:	fb641823          	sh	s6,-80(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800032d0:	4741                	li	a4,16
    800032d2:	86a6                	mv	a3,s1
    800032d4:	fb040613          	addi	a2,s0,-80
    800032d8:	4581                	li	a1,0
    800032da:	854a                	mv	a0,s2
    800032dc:	00000097          	auipc	ra,0x0
    800032e0:	c00080e7          	jalr	-1024(ra) # 80002edc <writei>
    800032e4:	872a                	mv	a4,a0
    800032e6:	47c1                	li	a5,16
  return 0;
    800032e8:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800032ea:	00f71a63          	bne	a4,a5,800032fe <dirlink+0xc2>
    800032ee:	74e2                	ld	s1,56(sp)
}
    800032f0:	60a6                	ld	ra,72(sp)
    800032f2:	6406                	ld	s0,64(sp)
    800032f4:	7942                	ld	s2,48(sp)
    800032f6:	6ae2                	ld	s5,24(sp)
    800032f8:	6b42                	ld	s6,16(sp)
    800032fa:	6161                	addi	sp,sp,80
    800032fc:	8082                	ret
    800032fe:	f44e                	sd	s3,40(sp)
    80003300:	f052                	sd	s4,32(sp)
    panic("dirlink");
    80003302:	00005517          	auipc	a0,0x5
    80003306:	2a650513          	addi	a0,a0,678 # 800085a8 <etext+0x5a8>
    8000330a:	00003097          	auipc	ra,0x3
    8000330e:	9d8080e7          	jalr	-1576(ra) # 80005ce2 <panic>

0000000080003312 <namei>:

struct inode*
namei(char *path)
{
    80003312:	1101                	addi	sp,sp,-32
    80003314:	ec06                	sd	ra,24(sp)
    80003316:	e822                	sd	s0,16(sp)
    80003318:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    8000331a:	fe040613          	addi	a2,s0,-32
    8000331e:	4581                	li	a1,0
    80003320:	00000097          	auipc	ra,0x0
    80003324:	db6080e7          	jalr	-586(ra) # 800030d6 <namex>
}
    80003328:	60e2                	ld	ra,24(sp)
    8000332a:	6442                	ld	s0,16(sp)
    8000332c:	6105                	addi	sp,sp,32
    8000332e:	8082                	ret

0000000080003330 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003330:	1141                	addi	sp,sp,-16
    80003332:	e406                	sd	ra,8(sp)
    80003334:	e022                	sd	s0,0(sp)
    80003336:	0800                	addi	s0,sp,16
    80003338:	862e                	mv	a2,a1
  return namex(path, 1, name);
    8000333a:	4585                	li	a1,1
    8000333c:	00000097          	auipc	ra,0x0
    80003340:	d9a080e7          	jalr	-614(ra) # 800030d6 <namex>
}
    80003344:	60a2                	ld	ra,8(sp)
    80003346:	6402                	ld	s0,0(sp)
    80003348:	0141                	addi	sp,sp,16
    8000334a:	8082                	ret

000000008000334c <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    8000334c:	1101                	addi	sp,sp,-32
    8000334e:	ec06                	sd	ra,24(sp)
    80003350:	e822                	sd	s0,16(sp)
    80003352:	e426                	sd	s1,8(sp)
    80003354:	e04a                	sd	s2,0(sp)
    80003356:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003358:	00016917          	auipc	s2,0x16
    8000335c:	cc890913          	addi	s2,s2,-824 # 80019020 <log>
    80003360:	01892583          	lw	a1,24(s2)
    80003364:	02892503          	lw	a0,40(s2)
    80003368:	fffff097          	auipc	ra,0xfffff
    8000336c:	fe2080e7          	jalr	-30(ra) # 8000234a <bread>
    80003370:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003372:	02c92603          	lw	a2,44(s2)
    80003376:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003378:	00c05f63          	blez	a2,80003396 <write_head+0x4a>
    8000337c:	00016717          	auipc	a4,0x16
    80003380:	cd470713          	addi	a4,a4,-812 # 80019050 <log+0x30>
    80003384:	87aa                	mv	a5,a0
    80003386:	060a                	slli	a2,a2,0x2
    80003388:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    8000338a:	4314                	lw	a3,0(a4)
    8000338c:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    8000338e:	0711                	addi	a4,a4,4
    80003390:	0791                	addi	a5,a5,4
    80003392:	fec79ce3          	bne	a5,a2,8000338a <write_head+0x3e>
  }
  bwrite(buf);
    80003396:	8526                	mv	a0,s1
    80003398:	fffff097          	auipc	ra,0xfffff
    8000339c:	0a4080e7          	jalr	164(ra) # 8000243c <bwrite>
  brelse(buf);
    800033a0:	8526                	mv	a0,s1
    800033a2:	fffff097          	auipc	ra,0xfffff
    800033a6:	0d8080e7          	jalr	216(ra) # 8000247a <brelse>
}
    800033aa:	60e2                	ld	ra,24(sp)
    800033ac:	6442                	ld	s0,16(sp)
    800033ae:	64a2                	ld	s1,8(sp)
    800033b0:	6902                	ld	s2,0(sp)
    800033b2:	6105                	addi	sp,sp,32
    800033b4:	8082                	ret

00000000800033b6 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800033b6:	00016797          	auipc	a5,0x16
    800033ba:	c967a783          	lw	a5,-874(a5) # 8001904c <log+0x2c>
    800033be:	0cf05063          	blez	a5,8000347e <install_trans+0xc8>
{
    800033c2:	715d                	addi	sp,sp,-80
    800033c4:	e486                	sd	ra,72(sp)
    800033c6:	e0a2                	sd	s0,64(sp)
    800033c8:	fc26                	sd	s1,56(sp)
    800033ca:	f84a                	sd	s2,48(sp)
    800033cc:	f44e                	sd	s3,40(sp)
    800033ce:	f052                	sd	s4,32(sp)
    800033d0:	ec56                	sd	s5,24(sp)
    800033d2:	e85a                	sd	s6,16(sp)
    800033d4:	e45e                	sd	s7,8(sp)
    800033d6:	0880                	addi	s0,sp,80
    800033d8:	8b2a                	mv	s6,a0
    800033da:	00016a97          	auipc	s5,0x16
    800033de:	c76a8a93          	addi	s5,s5,-906 # 80019050 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800033e2:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800033e4:	00016997          	auipc	s3,0x16
    800033e8:	c3c98993          	addi	s3,s3,-964 # 80019020 <log>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800033ec:	40000b93          	li	s7,1024
    800033f0:	a00d                	j	80003412 <install_trans+0x5c>
    brelse(lbuf);
    800033f2:	854a                	mv	a0,s2
    800033f4:	fffff097          	auipc	ra,0xfffff
    800033f8:	086080e7          	jalr	134(ra) # 8000247a <brelse>
    brelse(dbuf);
    800033fc:	8526                	mv	a0,s1
    800033fe:	fffff097          	auipc	ra,0xfffff
    80003402:	07c080e7          	jalr	124(ra) # 8000247a <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003406:	2a05                	addiw	s4,s4,1
    80003408:	0a91                	addi	s5,s5,4
    8000340a:	02c9a783          	lw	a5,44(s3)
    8000340e:	04fa5d63          	bge	s4,a5,80003468 <install_trans+0xb2>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003412:	0189a583          	lw	a1,24(s3)
    80003416:	014585bb          	addw	a1,a1,s4
    8000341a:	2585                	addiw	a1,a1,1
    8000341c:	0289a503          	lw	a0,40(s3)
    80003420:	fffff097          	auipc	ra,0xfffff
    80003424:	f2a080e7          	jalr	-214(ra) # 8000234a <bread>
    80003428:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000342a:	000aa583          	lw	a1,0(s5)
    8000342e:	0289a503          	lw	a0,40(s3)
    80003432:	fffff097          	auipc	ra,0xfffff
    80003436:	f18080e7          	jalr	-232(ra) # 8000234a <bread>
    8000343a:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000343c:	865e                	mv	a2,s7
    8000343e:	05890593          	addi	a1,s2,88
    80003442:	05850513          	addi	a0,a0,88
    80003446:	ffffd097          	auipc	ra,0xffffd
    8000344a:	d98080e7          	jalr	-616(ra) # 800001de <memmove>
    bwrite(dbuf);  // write dst to disk
    8000344e:	8526                	mv	a0,s1
    80003450:	fffff097          	auipc	ra,0xfffff
    80003454:	fec080e7          	jalr	-20(ra) # 8000243c <bwrite>
    if(recovering == 0)
    80003458:	f80b1de3          	bnez	s6,800033f2 <install_trans+0x3c>
      bunpin(dbuf);
    8000345c:	8526                	mv	a0,s1
    8000345e:	fffff097          	auipc	ra,0xfffff
    80003462:	0f0080e7          	jalr	240(ra) # 8000254e <bunpin>
    80003466:	b771                	j	800033f2 <install_trans+0x3c>
}
    80003468:	60a6                	ld	ra,72(sp)
    8000346a:	6406                	ld	s0,64(sp)
    8000346c:	74e2                	ld	s1,56(sp)
    8000346e:	7942                	ld	s2,48(sp)
    80003470:	79a2                	ld	s3,40(sp)
    80003472:	7a02                	ld	s4,32(sp)
    80003474:	6ae2                	ld	s5,24(sp)
    80003476:	6b42                	ld	s6,16(sp)
    80003478:	6ba2                	ld	s7,8(sp)
    8000347a:	6161                	addi	sp,sp,80
    8000347c:	8082                	ret
    8000347e:	8082                	ret

0000000080003480 <initlog>:
{
    80003480:	7179                	addi	sp,sp,-48
    80003482:	f406                	sd	ra,40(sp)
    80003484:	f022                	sd	s0,32(sp)
    80003486:	ec26                	sd	s1,24(sp)
    80003488:	e84a                	sd	s2,16(sp)
    8000348a:	e44e                	sd	s3,8(sp)
    8000348c:	1800                	addi	s0,sp,48
    8000348e:	892a                	mv	s2,a0
    80003490:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003492:	00016497          	auipc	s1,0x16
    80003496:	b8e48493          	addi	s1,s1,-1138 # 80019020 <log>
    8000349a:	00005597          	auipc	a1,0x5
    8000349e:	00e58593          	addi	a1,a1,14 # 800084a8 <etext+0x4a8>
    800034a2:	8526                	mv	a0,s1
    800034a4:	00003097          	auipc	ra,0x3
    800034a8:	d2a080e7          	jalr	-726(ra) # 800061ce <initlock>
  log.start = sb->logstart;
    800034ac:	0149a583          	lw	a1,20(s3)
    800034b0:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800034b2:	0109a783          	lw	a5,16(s3)
    800034b6:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800034b8:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800034bc:	854a                	mv	a0,s2
    800034be:	fffff097          	auipc	ra,0xfffff
    800034c2:	e8c080e7          	jalr	-372(ra) # 8000234a <bread>
  log.lh.n = lh->n;
    800034c6:	4d30                	lw	a2,88(a0)
    800034c8:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800034ca:	00c05f63          	blez	a2,800034e8 <initlog+0x68>
    800034ce:	87aa                	mv	a5,a0
    800034d0:	00016717          	auipc	a4,0x16
    800034d4:	b8070713          	addi	a4,a4,-1152 # 80019050 <log+0x30>
    800034d8:	060a                	slli	a2,a2,0x2
    800034da:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    800034dc:	4ff4                	lw	a3,92(a5)
    800034de:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800034e0:	0791                	addi	a5,a5,4
    800034e2:	0711                	addi	a4,a4,4
    800034e4:	fec79ce3          	bne	a5,a2,800034dc <initlog+0x5c>
  brelse(buf);
    800034e8:	fffff097          	auipc	ra,0xfffff
    800034ec:	f92080e7          	jalr	-110(ra) # 8000247a <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800034f0:	4505                	li	a0,1
    800034f2:	00000097          	auipc	ra,0x0
    800034f6:	ec4080e7          	jalr	-316(ra) # 800033b6 <install_trans>
  log.lh.n = 0;
    800034fa:	00016797          	auipc	a5,0x16
    800034fe:	b407a923          	sw	zero,-1198(a5) # 8001904c <log+0x2c>
  write_head(); // clear the log
    80003502:	00000097          	auipc	ra,0x0
    80003506:	e4a080e7          	jalr	-438(ra) # 8000334c <write_head>
}
    8000350a:	70a2                	ld	ra,40(sp)
    8000350c:	7402                	ld	s0,32(sp)
    8000350e:	64e2                	ld	s1,24(sp)
    80003510:	6942                	ld	s2,16(sp)
    80003512:	69a2                	ld	s3,8(sp)
    80003514:	6145                	addi	sp,sp,48
    80003516:	8082                	ret

0000000080003518 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003518:	1101                	addi	sp,sp,-32
    8000351a:	ec06                	sd	ra,24(sp)
    8000351c:	e822                	sd	s0,16(sp)
    8000351e:	e426                	sd	s1,8(sp)
    80003520:	e04a                	sd	s2,0(sp)
    80003522:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003524:	00016517          	auipc	a0,0x16
    80003528:	afc50513          	addi	a0,a0,-1284 # 80019020 <log>
    8000352c:	00003097          	auipc	ra,0x3
    80003530:	d36080e7          	jalr	-714(ra) # 80006262 <acquire>
  while(1){
    if(log.committing){
    80003534:	00016497          	auipc	s1,0x16
    80003538:	aec48493          	addi	s1,s1,-1300 # 80019020 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000353c:	4979                	li	s2,30
    8000353e:	a039                	j	8000354c <begin_op+0x34>
      sleep(&log, &log.lock);
    80003540:	85a6                	mv	a1,s1
    80003542:	8526                	mv	a0,s1
    80003544:	ffffe097          	auipc	ra,0xffffe
    80003548:	ff6080e7          	jalr	-10(ra) # 8000153a <sleep>
    if(log.committing){
    8000354c:	50dc                	lw	a5,36(s1)
    8000354e:	fbed                	bnez	a5,80003540 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003550:	5098                	lw	a4,32(s1)
    80003552:	2705                	addiw	a4,a4,1
    80003554:	0027179b          	slliw	a5,a4,0x2
    80003558:	9fb9                	addw	a5,a5,a4
    8000355a:	0017979b          	slliw	a5,a5,0x1
    8000355e:	54d4                	lw	a3,44(s1)
    80003560:	9fb5                	addw	a5,a5,a3
    80003562:	00f95963          	bge	s2,a5,80003574 <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003566:	85a6                	mv	a1,s1
    80003568:	8526                	mv	a0,s1
    8000356a:	ffffe097          	auipc	ra,0xffffe
    8000356e:	fd0080e7          	jalr	-48(ra) # 8000153a <sleep>
    80003572:	bfe9                	j	8000354c <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003574:	00016517          	auipc	a0,0x16
    80003578:	aac50513          	addi	a0,a0,-1364 # 80019020 <log>
    8000357c:	d118                	sw	a4,32(a0)
      release(&log.lock);
    8000357e:	00003097          	auipc	ra,0x3
    80003582:	d94080e7          	jalr	-620(ra) # 80006312 <release>
      break;
    }
  }
}
    80003586:	60e2                	ld	ra,24(sp)
    80003588:	6442                	ld	s0,16(sp)
    8000358a:	64a2                	ld	s1,8(sp)
    8000358c:	6902                	ld	s2,0(sp)
    8000358e:	6105                	addi	sp,sp,32
    80003590:	8082                	ret

0000000080003592 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003592:	7139                	addi	sp,sp,-64
    80003594:	fc06                	sd	ra,56(sp)
    80003596:	f822                	sd	s0,48(sp)
    80003598:	f426                	sd	s1,40(sp)
    8000359a:	f04a                	sd	s2,32(sp)
    8000359c:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000359e:	00016497          	auipc	s1,0x16
    800035a2:	a8248493          	addi	s1,s1,-1406 # 80019020 <log>
    800035a6:	8526                	mv	a0,s1
    800035a8:	00003097          	auipc	ra,0x3
    800035ac:	cba080e7          	jalr	-838(ra) # 80006262 <acquire>
  log.outstanding -= 1;
    800035b0:	509c                	lw	a5,32(s1)
    800035b2:	37fd                	addiw	a5,a5,-1
    800035b4:	893e                	mv	s2,a5
    800035b6:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800035b8:	50dc                	lw	a5,36(s1)
    800035ba:	e7b9                	bnez	a5,80003608 <end_op+0x76>
    panic("log.committing");
  if(log.outstanding == 0){
    800035bc:	06091263          	bnez	s2,80003620 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    800035c0:	00016497          	auipc	s1,0x16
    800035c4:	a6048493          	addi	s1,s1,-1440 # 80019020 <log>
    800035c8:	4785                	li	a5,1
    800035ca:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800035cc:	8526                	mv	a0,s1
    800035ce:	00003097          	auipc	ra,0x3
    800035d2:	d44080e7          	jalr	-700(ra) # 80006312 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800035d6:	54dc                	lw	a5,44(s1)
    800035d8:	06f04863          	bgtz	a5,80003648 <end_op+0xb6>
    acquire(&log.lock);
    800035dc:	00016497          	auipc	s1,0x16
    800035e0:	a4448493          	addi	s1,s1,-1468 # 80019020 <log>
    800035e4:	8526                	mv	a0,s1
    800035e6:	00003097          	auipc	ra,0x3
    800035ea:	c7c080e7          	jalr	-900(ra) # 80006262 <acquire>
    log.committing = 0;
    800035ee:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800035f2:	8526                	mv	a0,s1
    800035f4:	ffffe097          	auipc	ra,0xffffe
    800035f8:	0cc080e7          	jalr	204(ra) # 800016c0 <wakeup>
    release(&log.lock);
    800035fc:	8526                	mv	a0,s1
    800035fe:	00003097          	auipc	ra,0x3
    80003602:	d14080e7          	jalr	-748(ra) # 80006312 <release>
}
    80003606:	a81d                	j	8000363c <end_op+0xaa>
    80003608:	ec4e                	sd	s3,24(sp)
    8000360a:	e852                	sd	s4,16(sp)
    8000360c:	e456                	sd	s5,8(sp)
    8000360e:	e05a                	sd	s6,0(sp)
    panic("log.committing");
    80003610:	00005517          	auipc	a0,0x5
    80003614:	ea050513          	addi	a0,a0,-352 # 800084b0 <etext+0x4b0>
    80003618:	00002097          	auipc	ra,0x2
    8000361c:	6ca080e7          	jalr	1738(ra) # 80005ce2 <panic>
    wakeup(&log);
    80003620:	00016497          	auipc	s1,0x16
    80003624:	a0048493          	addi	s1,s1,-1536 # 80019020 <log>
    80003628:	8526                	mv	a0,s1
    8000362a:	ffffe097          	auipc	ra,0xffffe
    8000362e:	096080e7          	jalr	150(ra) # 800016c0 <wakeup>
  release(&log.lock);
    80003632:	8526                	mv	a0,s1
    80003634:	00003097          	auipc	ra,0x3
    80003638:	cde080e7          	jalr	-802(ra) # 80006312 <release>
}
    8000363c:	70e2                	ld	ra,56(sp)
    8000363e:	7442                	ld	s0,48(sp)
    80003640:	74a2                	ld	s1,40(sp)
    80003642:	7902                	ld	s2,32(sp)
    80003644:	6121                	addi	sp,sp,64
    80003646:	8082                	ret
    80003648:	ec4e                	sd	s3,24(sp)
    8000364a:	e852                	sd	s4,16(sp)
    8000364c:	e456                	sd	s5,8(sp)
    8000364e:	e05a                	sd	s6,0(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80003650:	00016a97          	auipc	s5,0x16
    80003654:	a00a8a93          	addi	s5,s5,-1536 # 80019050 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003658:	00016a17          	auipc	s4,0x16
    8000365c:	9c8a0a13          	addi	s4,s4,-1592 # 80019020 <log>
    memmove(to->data, from->data, BSIZE);
    80003660:	40000b13          	li	s6,1024
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003664:	018a2583          	lw	a1,24(s4)
    80003668:	012585bb          	addw	a1,a1,s2
    8000366c:	2585                	addiw	a1,a1,1
    8000366e:	028a2503          	lw	a0,40(s4)
    80003672:	fffff097          	auipc	ra,0xfffff
    80003676:	cd8080e7          	jalr	-808(ra) # 8000234a <bread>
    8000367a:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000367c:	000aa583          	lw	a1,0(s5)
    80003680:	028a2503          	lw	a0,40(s4)
    80003684:	fffff097          	auipc	ra,0xfffff
    80003688:	cc6080e7          	jalr	-826(ra) # 8000234a <bread>
    8000368c:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000368e:	865a                	mv	a2,s6
    80003690:	05850593          	addi	a1,a0,88
    80003694:	05848513          	addi	a0,s1,88
    80003698:	ffffd097          	auipc	ra,0xffffd
    8000369c:	b46080e7          	jalr	-1210(ra) # 800001de <memmove>
    bwrite(to);  // write the log
    800036a0:	8526                	mv	a0,s1
    800036a2:	fffff097          	auipc	ra,0xfffff
    800036a6:	d9a080e7          	jalr	-614(ra) # 8000243c <bwrite>
    brelse(from);
    800036aa:	854e                	mv	a0,s3
    800036ac:	fffff097          	auipc	ra,0xfffff
    800036b0:	dce080e7          	jalr	-562(ra) # 8000247a <brelse>
    brelse(to);
    800036b4:	8526                	mv	a0,s1
    800036b6:	fffff097          	auipc	ra,0xfffff
    800036ba:	dc4080e7          	jalr	-572(ra) # 8000247a <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800036be:	2905                	addiw	s2,s2,1
    800036c0:	0a91                	addi	s5,s5,4
    800036c2:	02ca2783          	lw	a5,44(s4)
    800036c6:	f8f94fe3          	blt	s2,a5,80003664 <end_op+0xd2>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800036ca:	00000097          	auipc	ra,0x0
    800036ce:	c82080e7          	jalr	-894(ra) # 8000334c <write_head>
    install_trans(0); // Now install writes to home locations
    800036d2:	4501                	li	a0,0
    800036d4:	00000097          	auipc	ra,0x0
    800036d8:	ce2080e7          	jalr	-798(ra) # 800033b6 <install_trans>
    log.lh.n = 0;
    800036dc:	00016797          	auipc	a5,0x16
    800036e0:	9607a823          	sw	zero,-1680(a5) # 8001904c <log+0x2c>
    write_head();    // Erase the transaction from the log
    800036e4:	00000097          	auipc	ra,0x0
    800036e8:	c68080e7          	jalr	-920(ra) # 8000334c <write_head>
    800036ec:	69e2                	ld	s3,24(sp)
    800036ee:	6a42                	ld	s4,16(sp)
    800036f0:	6aa2                	ld	s5,8(sp)
    800036f2:	6b02                	ld	s6,0(sp)
    800036f4:	b5e5                	j	800035dc <end_op+0x4a>

00000000800036f6 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800036f6:	1101                	addi	sp,sp,-32
    800036f8:	ec06                	sd	ra,24(sp)
    800036fa:	e822                	sd	s0,16(sp)
    800036fc:	e426                	sd	s1,8(sp)
    800036fe:	e04a                	sd	s2,0(sp)
    80003700:	1000                	addi	s0,sp,32
    80003702:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003704:	00016917          	auipc	s2,0x16
    80003708:	91c90913          	addi	s2,s2,-1764 # 80019020 <log>
    8000370c:	854a                	mv	a0,s2
    8000370e:	00003097          	auipc	ra,0x3
    80003712:	b54080e7          	jalr	-1196(ra) # 80006262 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003716:	02c92603          	lw	a2,44(s2)
    8000371a:	47f5                	li	a5,29
    8000371c:	06c7c563          	blt	a5,a2,80003786 <log_write+0x90>
    80003720:	00016797          	auipc	a5,0x16
    80003724:	91c7a783          	lw	a5,-1764(a5) # 8001903c <log+0x1c>
    80003728:	37fd                	addiw	a5,a5,-1
    8000372a:	04f65e63          	bge	a2,a5,80003786 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000372e:	00016797          	auipc	a5,0x16
    80003732:	9127a783          	lw	a5,-1774(a5) # 80019040 <log+0x20>
    80003736:	06f05063          	blez	a5,80003796 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    8000373a:	4781                	li	a5,0
    8000373c:	06c05563          	blez	a2,800037a6 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003740:	44cc                	lw	a1,12(s1)
    80003742:	00016717          	auipc	a4,0x16
    80003746:	90e70713          	addi	a4,a4,-1778 # 80019050 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    8000374a:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000374c:	4314                	lw	a3,0(a4)
    8000374e:	04b68c63          	beq	a3,a1,800037a6 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003752:	2785                	addiw	a5,a5,1
    80003754:	0711                	addi	a4,a4,4
    80003756:	fef61be3          	bne	a2,a5,8000374c <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    8000375a:	0621                	addi	a2,a2,8
    8000375c:	060a                	slli	a2,a2,0x2
    8000375e:	00016797          	auipc	a5,0x16
    80003762:	8c278793          	addi	a5,a5,-1854 # 80019020 <log>
    80003766:	97b2                	add	a5,a5,a2
    80003768:	44d8                	lw	a4,12(s1)
    8000376a:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    8000376c:	8526                	mv	a0,s1
    8000376e:	fffff097          	auipc	ra,0xfffff
    80003772:	da4080e7          	jalr	-604(ra) # 80002512 <bpin>
    log.lh.n++;
    80003776:	00016717          	auipc	a4,0x16
    8000377a:	8aa70713          	addi	a4,a4,-1878 # 80019020 <log>
    8000377e:	575c                	lw	a5,44(a4)
    80003780:	2785                	addiw	a5,a5,1
    80003782:	d75c                	sw	a5,44(a4)
    80003784:	a82d                	j	800037be <log_write+0xc8>
    panic("too big a transaction");
    80003786:	00005517          	auipc	a0,0x5
    8000378a:	d3a50513          	addi	a0,a0,-710 # 800084c0 <etext+0x4c0>
    8000378e:	00002097          	auipc	ra,0x2
    80003792:	554080e7          	jalr	1364(ra) # 80005ce2 <panic>
    panic("log_write outside of trans");
    80003796:	00005517          	auipc	a0,0x5
    8000379a:	d4250513          	addi	a0,a0,-702 # 800084d8 <etext+0x4d8>
    8000379e:	00002097          	auipc	ra,0x2
    800037a2:	544080e7          	jalr	1348(ra) # 80005ce2 <panic>
  log.lh.block[i] = b->blockno;
    800037a6:	00878693          	addi	a3,a5,8
    800037aa:	068a                	slli	a3,a3,0x2
    800037ac:	00016717          	auipc	a4,0x16
    800037b0:	87470713          	addi	a4,a4,-1932 # 80019020 <log>
    800037b4:	9736                	add	a4,a4,a3
    800037b6:	44d4                	lw	a3,12(s1)
    800037b8:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800037ba:	faf609e3          	beq	a2,a5,8000376c <log_write+0x76>
  }
  release(&log.lock);
    800037be:	00016517          	auipc	a0,0x16
    800037c2:	86250513          	addi	a0,a0,-1950 # 80019020 <log>
    800037c6:	00003097          	auipc	ra,0x3
    800037ca:	b4c080e7          	jalr	-1204(ra) # 80006312 <release>
}
    800037ce:	60e2                	ld	ra,24(sp)
    800037d0:	6442                	ld	s0,16(sp)
    800037d2:	64a2                	ld	s1,8(sp)
    800037d4:	6902                	ld	s2,0(sp)
    800037d6:	6105                	addi	sp,sp,32
    800037d8:	8082                	ret

00000000800037da <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800037da:	1101                	addi	sp,sp,-32
    800037dc:	ec06                	sd	ra,24(sp)
    800037de:	e822                	sd	s0,16(sp)
    800037e0:	e426                	sd	s1,8(sp)
    800037e2:	e04a                	sd	s2,0(sp)
    800037e4:	1000                	addi	s0,sp,32
    800037e6:	84aa                	mv	s1,a0
    800037e8:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800037ea:	00005597          	auipc	a1,0x5
    800037ee:	d0e58593          	addi	a1,a1,-754 # 800084f8 <etext+0x4f8>
    800037f2:	0521                	addi	a0,a0,8
    800037f4:	00003097          	auipc	ra,0x3
    800037f8:	9da080e7          	jalr	-1574(ra) # 800061ce <initlock>
  lk->name = name;
    800037fc:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003800:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003804:	0204a423          	sw	zero,40(s1)
}
    80003808:	60e2                	ld	ra,24(sp)
    8000380a:	6442                	ld	s0,16(sp)
    8000380c:	64a2                	ld	s1,8(sp)
    8000380e:	6902                	ld	s2,0(sp)
    80003810:	6105                	addi	sp,sp,32
    80003812:	8082                	ret

0000000080003814 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003814:	1101                	addi	sp,sp,-32
    80003816:	ec06                	sd	ra,24(sp)
    80003818:	e822                	sd	s0,16(sp)
    8000381a:	e426                	sd	s1,8(sp)
    8000381c:	e04a                	sd	s2,0(sp)
    8000381e:	1000                	addi	s0,sp,32
    80003820:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003822:	00850913          	addi	s2,a0,8
    80003826:	854a                	mv	a0,s2
    80003828:	00003097          	auipc	ra,0x3
    8000382c:	a3a080e7          	jalr	-1478(ra) # 80006262 <acquire>
  while (lk->locked) {
    80003830:	409c                	lw	a5,0(s1)
    80003832:	cb89                	beqz	a5,80003844 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003834:	85ca                	mv	a1,s2
    80003836:	8526                	mv	a0,s1
    80003838:	ffffe097          	auipc	ra,0xffffe
    8000383c:	d02080e7          	jalr	-766(ra) # 8000153a <sleep>
  while (lk->locked) {
    80003840:	409c                	lw	a5,0(s1)
    80003842:	fbed                	bnez	a5,80003834 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003844:	4785                	li	a5,1
    80003846:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003848:	ffffd097          	auipc	ra,0xffffd
    8000384c:	62c080e7          	jalr	1580(ra) # 80000e74 <myproc>
    80003850:	591c                	lw	a5,48(a0)
    80003852:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003854:	854a                	mv	a0,s2
    80003856:	00003097          	auipc	ra,0x3
    8000385a:	abc080e7          	jalr	-1348(ra) # 80006312 <release>
}
    8000385e:	60e2                	ld	ra,24(sp)
    80003860:	6442                	ld	s0,16(sp)
    80003862:	64a2                	ld	s1,8(sp)
    80003864:	6902                	ld	s2,0(sp)
    80003866:	6105                	addi	sp,sp,32
    80003868:	8082                	ret

000000008000386a <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    8000386a:	1101                	addi	sp,sp,-32
    8000386c:	ec06                	sd	ra,24(sp)
    8000386e:	e822                	sd	s0,16(sp)
    80003870:	e426                	sd	s1,8(sp)
    80003872:	e04a                	sd	s2,0(sp)
    80003874:	1000                	addi	s0,sp,32
    80003876:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003878:	00850913          	addi	s2,a0,8
    8000387c:	854a                	mv	a0,s2
    8000387e:	00003097          	auipc	ra,0x3
    80003882:	9e4080e7          	jalr	-1564(ra) # 80006262 <acquire>
  lk->locked = 0;
    80003886:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000388a:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    8000388e:	8526                	mv	a0,s1
    80003890:	ffffe097          	auipc	ra,0xffffe
    80003894:	e30080e7          	jalr	-464(ra) # 800016c0 <wakeup>
  release(&lk->lk);
    80003898:	854a                	mv	a0,s2
    8000389a:	00003097          	auipc	ra,0x3
    8000389e:	a78080e7          	jalr	-1416(ra) # 80006312 <release>
}
    800038a2:	60e2                	ld	ra,24(sp)
    800038a4:	6442                	ld	s0,16(sp)
    800038a6:	64a2                	ld	s1,8(sp)
    800038a8:	6902                	ld	s2,0(sp)
    800038aa:	6105                	addi	sp,sp,32
    800038ac:	8082                	ret

00000000800038ae <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800038ae:	7179                	addi	sp,sp,-48
    800038b0:	f406                	sd	ra,40(sp)
    800038b2:	f022                	sd	s0,32(sp)
    800038b4:	ec26                	sd	s1,24(sp)
    800038b6:	e84a                	sd	s2,16(sp)
    800038b8:	1800                	addi	s0,sp,48
    800038ba:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800038bc:	00850913          	addi	s2,a0,8
    800038c0:	854a                	mv	a0,s2
    800038c2:	00003097          	auipc	ra,0x3
    800038c6:	9a0080e7          	jalr	-1632(ra) # 80006262 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800038ca:	409c                	lw	a5,0(s1)
    800038cc:	ef91                	bnez	a5,800038e8 <holdingsleep+0x3a>
    800038ce:	4481                	li	s1,0
  release(&lk->lk);
    800038d0:	854a                	mv	a0,s2
    800038d2:	00003097          	auipc	ra,0x3
    800038d6:	a40080e7          	jalr	-1472(ra) # 80006312 <release>
  return r;
}
    800038da:	8526                	mv	a0,s1
    800038dc:	70a2                	ld	ra,40(sp)
    800038de:	7402                	ld	s0,32(sp)
    800038e0:	64e2                	ld	s1,24(sp)
    800038e2:	6942                	ld	s2,16(sp)
    800038e4:	6145                	addi	sp,sp,48
    800038e6:	8082                	ret
    800038e8:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    800038ea:	0284a983          	lw	s3,40(s1)
    800038ee:	ffffd097          	auipc	ra,0xffffd
    800038f2:	586080e7          	jalr	1414(ra) # 80000e74 <myproc>
    800038f6:	5904                	lw	s1,48(a0)
    800038f8:	413484b3          	sub	s1,s1,s3
    800038fc:	0014b493          	seqz	s1,s1
    80003900:	69a2                	ld	s3,8(sp)
    80003902:	b7f9                	j	800038d0 <holdingsleep+0x22>

0000000080003904 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003904:	1141                	addi	sp,sp,-16
    80003906:	e406                	sd	ra,8(sp)
    80003908:	e022                	sd	s0,0(sp)
    8000390a:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    8000390c:	00005597          	auipc	a1,0x5
    80003910:	bfc58593          	addi	a1,a1,-1028 # 80008508 <etext+0x508>
    80003914:	00016517          	auipc	a0,0x16
    80003918:	85450513          	addi	a0,a0,-1964 # 80019168 <ftable>
    8000391c:	00003097          	auipc	ra,0x3
    80003920:	8b2080e7          	jalr	-1870(ra) # 800061ce <initlock>
}
    80003924:	60a2                	ld	ra,8(sp)
    80003926:	6402                	ld	s0,0(sp)
    80003928:	0141                	addi	sp,sp,16
    8000392a:	8082                	ret

000000008000392c <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    8000392c:	1101                	addi	sp,sp,-32
    8000392e:	ec06                	sd	ra,24(sp)
    80003930:	e822                	sd	s0,16(sp)
    80003932:	e426                	sd	s1,8(sp)
    80003934:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003936:	00016517          	auipc	a0,0x16
    8000393a:	83250513          	addi	a0,a0,-1998 # 80019168 <ftable>
    8000393e:	00003097          	auipc	ra,0x3
    80003942:	924080e7          	jalr	-1756(ra) # 80006262 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003946:	00016497          	auipc	s1,0x16
    8000394a:	83a48493          	addi	s1,s1,-1990 # 80019180 <ftable+0x18>
    8000394e:	00016717          	auipc	a4,0x16
    80003952:	7d270713          	addi	a4,a4,2002 # 8001a120 <ftable+0xfb8>
    if(f->ref == 0){
    80003956:	40dc                	lw	a5,4(s1)
    80003958:	cf99                	beqz	a5,80003976 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000395a:	02848493          	addi	s1,s1,40
    8000395e:	fee49ce3          	bne	s1,a4,80003956 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003962:	00016517          	auipc	a0,0x16
    80003966:	80650513          	addi	a0,a0,-2042 # 80019168 <ftable>
    8000396a:	00003097          	auipc	ra,0x3
    8000396e:	9a8080e7          	jalr	-1624(ra) # 80006312 <release>
  return 0;
    80003972:	4481                	li	s1,0
    80003974:	a819                	j	8000398a <filealloc+0x5e>
      f->ref = 1;
    80003976:	4785                	li	a5,1
    80003978:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    8000397a:	00015517          	auipc	a0,0x15
    8000397e:	7ee50513          	addi	a0,a0,2030 # 80019168 <ftable>
    80003982:	00003097          	auipc	ra,0x3
    80003986:	990080e7          	jalr	-1648(ra) # 80006312 <release>
}
    8000398a:	8526                	mv	a0,s1
    8000398c:	60e2                	ld	ra,24(sp)
    8000398e:	6442                	ld	s0,16(sp)
    80003990:	64a2                	ld	s1,8(sp)
    80003992:	6105                	addi	sp,sp,32
    80003994:	8082                	ret

0000000080003996 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003996:	1101                	addi	sp,sp,-32
    80003998:	ec06                	sd	ra,24(sp)
    8000399a:	e822                	sd	s0,16(sp)
    8000399c:	e426                	sd	s1,8(sp)
    8000399e:	1000                	addi	s0,sp,32
    800039a0:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800039a2:	00015517          	auipc	a0,0x15
    800039a6:	7c650513          	addi	a0,a0,1990 # 80019168 <ftable>
    800039aa:	00003097          	auipc	ra,0x3
    800039ae:	8b8080e7          	jalr	-1864(ra) # 80006262 <acquire>
  if(f->ref < 1)
    800039b2:	40dc                	lw	a5,4(s1)
    800039b4:	02f05263          	blez	a5,800039d8 <filedup+0x42>
    panic("filedup");
  f->ref++;
    800039b8:	2785                	addiw	a5,a5,1
    800039ba:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800039bc:	00015517          	auipc	a0,0x15
    800039c0:	7ac50513          	addi	a0,a0,1964 # 80019168 <ftable>
    800039c4:	00003097          	auipc	ra,0x3
    800039c8:	94e080e7          	jalr	-1714(ra) # 80006312 <release>
  return f;
}
    800039cc:	8526                	mv	a0,s1
    800039ce:	60e2                	ld	ra,24(sp)
    800039d0:	6442                	ld	s0,16(sp)
    800039d2:	64a2                	ld	s1,8(sp)
    800039d4:	6105                	addi	sp,sp,32
    800039d6:	8082                	ret
    panic("filedup");
    800039d8:	00005517          	auipc	a0,0x5
    800039dc:	b3850513          	addi	a0,a0,-1224 # 80008510 <etext+0x510>
    800039e0:	00002097          	auipc	ra,0x2
    800039e4:	302080e7          	jalr	770(ra) # 80005ce2 <panic>

00000000800039e8 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800039e8:	7139                	addi	sp,sp,-64
    800039ea:	fc06                	sd	ra,56(sp)
    800039ec:	f822                	sd	s0,48(sp)
    800039ee:	f426                	sd	s1,40(sp)
    800039f0:	0080                	addi	s0,sp,64
    800039f2:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800039f4:	00015517          	auipc	a0,0x15
    800039f8:	77450513          	addi	a0,a0,1908 # 80019168 <ftable>
    800039fc:	00003097          	auipc	ra,0x3
    80003a00:	866080e7          	jalr	-1946(ra) # 80006262 <acquire>
  if(f->ref < 1)
    80003a04:	40dc                	lw	a5,4(s1)
    80003a06:	04f05a63          	blez	a5,80003a5a <fileclose+0x72>
    panic("fileclose");
  if(--f->ref > 0){
    80003a0a:	37fd                	addiw	a5,a5,-1
    80003a0c:	c0dc                	sw	a5,4(s1)
    80003a0e:	06f04263          	bgtz	a5,80003a72 <fileclose+0x8a>
    80003a12:	f04a                	sd	s2,32(sp)
    80003a14:	ec4e                	sd	s3,24(sp)
    80003a16:	e852                	sd	s4,16(sp)
    80003a18:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003a1a:	0004a903          	lw	s2,0(s1)
    80003a1e:	0094ca83          	lbu	s5,9(s1)
    80003a22:	0104ba03          	ld	s4,16(s1)
    80003a26:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003a2a:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003a2e:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003a32:	00015517          	auipc	a0,0x15
    80003a36:	73650513          	addi	a0,a0,1846 # 80019168 <ftable>
    80003a3a:	00003097          	auipc	ra,0x3
    80003a3e:	8d8080e7          	jalr	-1832(ra) # 80006312 <release>

  if(ff.type == FD_PIPE){
    80003a42:	4785                	li	a5,1
    80003a44:	04f90463          	beq	s2,a5,80003a8c <fileclose+0xa4>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003a48:	3979                	addiw	s2,s2,-2
    80003a4a:	4785                	li	a5,1
    80003a4c:	0527fb63          	bgeu	a5,s2,80003aa2 <fileclose+0xba>
    80003a50:	7902                	ld	s2,32(sp)
    80003a52:	69e2                	ld	s3,24(sp)
    80003a54:	6a42                	ld	s4,16(sp)
    80003a56:	6aa2                	ld	s5,8(sp)
    80003a58:	a02d                	j	80003a82 <fileclose+0x9a>
    80003a5a:	f04a                	sd	s2,32(sp)
    80003a5c:	ec4e                	sd	s3,24(sp)
    80003a5e:	e852                	sd	s4,16(sp)
    80003a60:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80003a62:	00005517          	auipc	a0,0x5
    80003a66:	ab650513          	addi	a0,a0,-1354 # 80008518 <etext+0x518>
    80003a6a:	00002097          	auipc	ra,0x2
    80003a6e:	278080e7          	jalr	632(ra) # 80005ce2 <panic>
    release(&ftable.lock);
    80003a72:	00015517          	auipc	a0,0x15
    80003a76:	6f650513          	addi	a0,a0,1782 # 80019168 <ftable>
    80003a7a:	00003097          	auipc	ra,0x3
    80003a7e:	898080e7          	jalr	-1896(ra) # 80006312 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80003a82:	70e2                	ld	ra,56(sp)
    80003a84:	7442                	ld	s0,48(sp)
    80003a86:	74a2                	ld	s1,40(sp)
    80003a88:	6121                	addi	sp,sp,64
    80003a8a:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003a8c:	85d6                	mv	a1,s5
    80003a8e:	8552                	mv	a0,s4
    80003a90:	00000097          	auipc	ra,0x0
    80003a94:	3ac080e7          	jalr	940(ra) # 80003e3c <pipeclose>
    80003a98:	7902                	ld	s2,32(sp)
    80003a9a:	69e2                	ld	s3,24(sp)
    80003a9c:	6a42                	ld	s4,16(sp)
    80003a9e:	6aa2                	ld	s5,8(sp)
    80003aa0:	b7cd                	j	80003a82 <fileclose+0x9a>
    begin_op();
    80003aa2:	00000097          	auipc	ra,0x0
    80003aa6:	a76080e7          	jalr	-1418(ra) # 80003518 <begin_op>
    iput(ff.ip);
    80003aaa:	854e                	mv	a0,s3
    80003aac:	fffff097          	auipc	ra,0xfffff
    80003ab0:	238080e7          	jalr	568(ra) # 80002ce4 <iput>
    end_op();
    80003ab4:	00000097          	auipc	ra,0x0
    80003ab8:	ade080e7          	jalr	-1314(ra) # 80003592 <end_op>
    80003abc:	7902                	ld	s2,32(sp)
    80003abe:	69e2                	ld	s3,24(sp)
    80003ac0:	6a42                	ld	s4,16(sp)
    80003ac2:	6aa2                	ld	s5,8(sp)
    80003ac4:	bf7d                	j	80003a82 <fileclose+0x9a>

0000000080003ac6 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003ac6:	715d                	addi	sp,sp,-80
    80003ac8:	e486                	sd	ra,72(sp)
    80003aca:	e0a2                	sd	s0,64(sp)
    80003acc:	fc26                	sd	s1,56(sp)
    80003ace:	f44e                	sd	s3,40(sp)
    80003ad0:	0880                	addi	s0,sp,80
    80003ad2:	84aa                	mv	s1,a0
    80003ad4:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003ad6:	ffffd097          	auipc	ra,0xffffd
    80003ada:	39e080e7          	jalr	926(ra) # 80000e74 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003ade:	409c                	lw	a5,0(s1)
    80003ae0:	37f9                	addiw	a5,a5,-2
    80003ae2:	4705                	li	a4,1
    80003ae4:	04f76a63          	bltu	a4,a5,80003b38 <filestat+0x72>
    80003ae8:	f84a                	sd	s2,48(sp)
    80003aea:	f052                	sd	s4,32(sp)
    80003aec:	892a                	mv	s2,a0
    ilock(f->ip);
    80003aee:	6c88                	ld	a0,24(s1)
    80003af0:	fffff097          	auipc	ra,0xfffff
    80003af4:	036080e7          	jalr	54(ra) # 80002b26 <ilock>
    stati(f->ip, &st);
    80003af8:	fb840a13          	addi	s4,s0,-72
    80003afc:	85d2                	mv	a1,s4
    80003afe:	6c88                	ld	a0,24(s1)
    80003b00:	fffff097          	auipc	ra,0xfffff
    80003b04:	2b4080e7          	jalr	692(ra) # 80002db4 <stati>
    iunlock(f->ip);
    80003b08:	6c88                	ld	a0,24(s1)
    80003b0a:	fffff097          	auipc	ra,0xfffff
    80003b0e:	0e2080e7          	jalr	226(ra) # 80002bec <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003b12:	46e1                	li	a3,24
    80003b14:	8652                	mv	a2,s4
    80003b16:	85ce                	mv	a1,s3
    80003b18:	05093503          	ld	a0,80(s2)
    80003b1c:	ffffd097          	auipc	ra,0xffffd
    80003b20:	004080e7          	jalr	4(ra) # 80000b20 <copyout>
    80003b24:	41f5551b          	sraiw	a0,a0,0x1f
    80003b28:	7942                	ld	s2,48(sp)
    80003b2a:	7a02                	ld	s4,32(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80003b2c:	60a6                	ld	ra,72(sp)
    80003b2e:	6406                	ld	s0,64(sp)
    80003b30:	74e2                	ld	s1,56(sp)
    80003b32:	79a2                	ld	s3,40(sp)
    80003b34:	6161                	addi	sp,sp,80
    80003b36:	8082                	ret
  return -1;
    80003b38:	557d                	li	a0,-1
    80003b3a:	bfcd                	j	80003b2c <filestat+0x66>

0000000080003b3c <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003b3c:	7179                	addi	sp,sp,-48
    80003b3e:	f406                	sd	ra,40(sp)
    80003b40:	f022                	sd	s0,32(sp)
    80003b42:	e84a                	sd	s2,16(sp)
    80003b44:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003b46:	00854783          	lbu	a5,8(a0)
    80003b4a:	cbc5                	beqz	a5,80003bfa <fileread+0xbe>
    80003b4c:	ec26                	sd	s1,24(sp)
    80003b4e:	e44e                	sd	s3,8(sp)
    80003b50:	84aa                	mv	s1,a0
    80003b52:	89ae                	mv	s3,a1
    80003b54:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003b56:	411c                	lw	a5,0(a0)
    80003b58:	4705                	li	a4,1
    80003b5a:	04e78963          	beq	a5,a4,80003bac <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003b5e:	470d                	li	a4,3
    80003b60:	04e78f63          	beq	a5,a4,80003bbe <fileread+0x82>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003b64:	4709                	li	a4,2
    80003b66:	08e79263          	bne	a5,a4,80003bea <fileread+0xae>
    ilock(f->ip);
    80003b6a:	6d08                	ld	a0,24(a0)
    80003b6c:	fffff097          	auipc	ra,0xfffff
    80003b70:	fba080e7          	jalr	-70(ra) # 80002b26 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003b74:	874a                	mv	a4,s2
    80003b76:	5094                	lw	a3,32(s1)
    80003b78:	864e                	mv	a2,s3
    80003b7a:	4585                	li	a1,1
    80003b7c:	6c88                	ld	a0,24(s1)
    80003b7e:	fffff097          	auipc	ra,0xfffff
    80003b82:	264080e7          	jalr	612(ra) # 80002de2 <readi>
    80003b86:	892a                	mv	s2,a0
    80003b88:	00a05563          	blez	a0,80003b92 <fileread+0x56>
      f->off += r;
    80003b8c:	509c                	lw	a5,32(s1)
    80003b8e:	9fa9                	addw	a5,a5,a0
    80003b90:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003b92:	6c88                	ld	a0,24(s1)
    80003b94:	fffff097          	auipc	ra,0xfffff
    80003b98:	058080e7          	jalr	88(ra) # 80002bec <iunlock>
    80003b9c:	64e2                	ld	s1,24(sp)
    80003b9e:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80003ba0:	854a                	mv	a0,s2
    80003ba2:	70a2                	ld	ra,40(sp)
    80003ba4:	7402                	ld	s0,32(sp)
    80003ba6:	6942                	ld	s2,16(sp)
    80003ba8:	6145                	addi	sp,sp,48
    80003baa:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003bac:	6908                	ld	a0,16(a0)
    80003bae:	00000097          	auipc	ra,0x0
    80003bb2:	414080e7          	jalr	1044(ra) # 80003fc2 <piperead>
    80003bb6:	892a                	mv	s2,a0
    80003bb8:	64e2                	ld	s1,24(sp)
    80003bba:	69a2                	ld	s3,8(sp)
    80003bbc:	b7d5                	j	80003ba0 <fileread+0x64>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003bbe:	02451783          	lh	a5,36(a0)
    80003bc2:	03079693          	slli	a3,a5,0x30
    80003bc6:	92c1                	srli	a3,a3,0x30
    80003bc8:	4725                	li	a4,9
    80003bca:	02d76a63          	bltu	a4,a3,80003bfe <fileread+0xc2>
    80003bce:	0792                	slli	a5,a5,0x4
    80003bd0:	00015717          	auipc	a4,0x15
    80003bd4:	4f870713          	addi	a4,a4,1272 # 800190c8 <devsw>
    80003bd8:	97ba                	add	a5,a5,a4
    80003bda:	639c                	ld	a5,0(a5)
    80003bdc:	c78d                	beqz	a5,80003c06 <fileread+0xca>
    r = devsw[f->major].read(1, addr, n);
    80003bde:	4505                	li	a0,1
    80003be0:	9782                	jalr	a5
    80003be2:	892a                	mv	s2,a0
    80003be4:	64e2                	ld	s1,24(sp)
    80003be6:	69a2                	ld	s3,8(sp)
    80003be8:	bf65                	j	80003ba0 <fileread+0x64>
    panic("fileread");
    80003bea:	00005517          	auipc	a0,0x5
    80003bee:	93e50513          	addi	a0,a0,-1730 # 80008528 <etext+0x528>
    80003bf2:	00002097          	auipc	ra,0x2
    80003bf6:	0f0080e7          	jalr	240(ra) # 80005ce2 <panic>
    return -1;
    80003bfa:	597d                	li	s2,-1
    80003bfc:	b755                	j	80003ba0 <fileread+0x64>
      return -1;
    80003bfe:	597d                	li	s2,-1
    80003c00:	64e2                	ld	s1,24(sp)
    80003c02:	69a2                	ld	s3,8(sp)
    80003c04:	bf71                	j	80003ba0 <fileread+0x64>
    80003c06:	597d                	li	s2,-1
    80003c08:	64e2                	ld	s1,24(sp)
    80003c0a:	69a2                	ld	s3,8(sp)
    80003c0c:	bf51                	j	80003ba0 <fileread+0x64>

0000000080003c0e <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003c0e:	00954783          	lbu	a5,9(a0)
    80003c12:	12078c63          	beqz	a5,80003d4a <filewrite+0x13c>
{
    80003c16:	711d                	addi	sp,sp,-96
    80003c18:	ec86                	sd	ra,88(sp)
    80003c1a:	e8a2                	sd	s0,80(sp)
    80003c1c:	e0ca                	sd	s2,64(sp)
    80003c1e:	f456                	sd	s5,40(sp)
    80003c20:	f05a                	sd	s6,32(sp)
    80003c22:	1080                	addi	s0,sp,96
    80003c24:	892a                	mv	s2,a0
    80003c26:	8b2e                	mv	s6,a1
    80003c28:	8ab2                	mv	s5,a2
    return -1;

  if(f->type == FD_PIPE){
    80003c2a:	411c                	lw	a5,0(a0)
    80003c2c:	4705                	li	a4,1
    80003c2e:	02e78963          	beq	a5,a4,80003c60 <filewrite+0x52>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003c32:	470d                	li	a4,3
    80003c34:	02e78c63          	beq	a5,a4,80003c6c <filewrite+0x5e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003c38:	4709                	li	a4,2
    80003c3a:	0ee79a63          	bne	a5,a4,80003d2e <filewrite+0x120>
    80003c3e:	f852                	sd	s4,48(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003c40:	0cc05563          	blez	a2,80003d0a <filewrite+0xfc>
    80003c44:	e4a6                	sd	s1,72(sp)
    80003c46:	fc4e                	sd	s3,56(sp)
    80003c48:	ec5e                	sd	s7,24(sp)
    80003c4a:	e862                	sd	s8,16(sp)
    80003c4c:	e466                	sd	s9,8(sp)
    int i = 0;
    80003c4e:	4a01                	li	s4,0
      int n1 = n - i;
      if(n1 > max)
    80003c50:	6b85                	lui	s7,0x1
    80003c52:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003c56:	6c85                	lui	s9,0x1
    80003c58:	c00c8c9b          	addiw	s9,s9,-1024 # c00 <_entry-0x7ffff400>
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003c5c:	4c05                	li	s8,1
    80003c5e:	a849                	j	80003cf0 <filewrite+0xe2>
    ret = pipewrite(f->pipe, addr, n);
    80003c60:	6908                	ld	a0,16(a0)
    80003c62:	00000097          	auipc	ra,0x0
    80003c66:	24a080e7          	jalr	586(ra) # 80003eac <pipewrite>
    80003c6a:	a85d                	j	80003d20 <filewrite+0x112>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003c6c:	02451783          	lh	a5,36(a0)
    80003c70:	03079693          	slli	a3,a5,0x30
    80003c74:	92c1                	srli	a3,a3,0x30
    80003c76:	4725                	li	a4,9
    80003c78:	0cd76b63          	bltu	a4,a3,80003d4e <filewrite+0x140>
    80003c7c:	0792                	slli	a5,a5,0x4
    80003c7e:	00015717          	auipc	a4,0x15
    80003c82:	44a70713          	addi	a4,a4,1098 # 800190c8 <devsw>
    80003c86:	97ba                	add	a5,a5,a4
    80003c88:	679c                	ld	a5,8(a5)
    80003c8a:	c7e1                	beqz	a5,80003d52 <filewrite+0x144>
    ret = devsw[f->major].write(1, addr, n);
    80003c8c:	4505                	li	a0,1
    80003c8e:	9782                	jalr	a5
    80003c90:	a841                	j	80003d20 <filewrite+0x112>
      if(n1 > max)
    80003c92:	2981                	sext.w	s3,s3
      begin_op();
    80003c94:	00000097          	auipc	ra,0x0
    80003c98:	884080e7          	jalr	-1916(ra) # 80003518 <begin_op>
      ilock(f->ip);
    80003c9c:	01893503          	ld	a0,24(s2)
    80003ca0:	fffff097          	auipc	ra,0xfffff
    80003ca4:	e86080e7          	jalr	-378(ra) # 80002b26 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003ca8:	874e                	mv	a4,s3
    80003caa:	02092683          	lw	a3,32(s2)
    80003cae:	016a0633          	add	a2,s4,s6
    80003cb2:	85e2                	mv	a1,s8
    80003cb4:	01893503          	ld	a0,24(s2)
    80003cb8:	fffff097          	auipc	ra,0xfffff
    80003cbc:	224080e7          	jalr	548(ra) # 80002edc <writei>
    80003cc0:	84aa                	mv	s1,a0
    80003cc2:	00a05763          	blez	a0,80003cd0 <filewrite+0xc2>
        f->off += r;
    80003cc6:	02092783          	lw	a5,32(s2)
    80003cca:	9fa9                	addw	a5,a5,a0
    80003ccc:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003cd0:	01893503          	ld	a0,24(s2)
    80003cd4:	fffff097          	auipc	ra,0xfffff
    80003cd8:	f18080e7          	jalr	-232(ra) # 80002bec <iunlock>
      end_op();
    80003cdc:	00000097          	auipc	ra,0x0
    80003ce0:	8b6080e7          	jalr	-1866(ra) # 80003592 <end_op>

      if(r != n1){
    80003ce4:	02999563          	bne	s3,s1,80003d0e <filewrite+0x100>
        // error from writei
        break;
      }
      i += r;
    80003ce8:	01448a3b          	addw	s4,s1,s4
    while(i < n){
    80003cec:	015a5963          	bge	s4,s5,80003cfe <filewrite+0xf0>
      int n1 = n - i;
    80003cf0:	414a87bb          	subw	a5,s5,s4
    80003cf4:	89be                	mv	s3,a5
      if(n1 > max)
    80003cf6:	f8fbdee3          	bge	s7,a5,80003c92 <filewrite+0x84>
    80003cfa:	89e6                	mv	s3,s9
    80003cfc:	bf59                	j	80003c92 <filewrite+0x84>
    80003cfe:	64a6                	ld	s1,72(sp)
    80003d00:	79e2                	ld	s3,56(sp)
    80003d02:	6be2                	ld	s7,24(sp)
    80003d04:	6c42                	ld	s8,16(sp)
    80003d06:	6ca2                	ld	s9,8(sp)
    80003d08:	a801                	j	80003d18 <filewrite+0x10a>
    int i = 0;
    80003d0a:	4a01                	li	s4,0
    80003d0c:	a031                	j	80003d18 <filewrite+0x10a>
    80003d0e:	64a6                	ld	s1,72(sp)
    80003d10:	79e2                	ld	s3,56(sp)
    80003d12:	6be2                	ld	s7,24(sp)
    80003d14:	6c42                	ld	s8,16(sp)
    80003d16:	6ca2                	ld	s9,8(sp)
    }
    ret = (i == n ? n : -1);
    80003d18:	034a9f63          	bne	s5,s4,80003d56 <filewrite+0x148>
    80003d1c:	8556                	mv	a0,s5
    80003d1e:	7a42                	ld	s4,48(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003d20:	60e6                	ld	ra,88(sp)
    80003d22:	6446                	ld	s0,80(sp)
    80003d24:	6906                	ld	s2,64(sp)
    80003d26:	7aa2                	ld	s5,40(sp)
    80003d28:	7b02                	ld	s6,32(sp)
    80003d2a:	6125                	addi	sp,sp,96
    80003d2c:	8082                	ret
    80003d2e:	e4a6                	sd	s1,72(sp)
    80003d30:	fc4e                	sd	s3,56(sp)
    80003d32:	f852                	sd	s4,48(sp)
    80003d34:	ec5e                	sd	s7,24(sp)
    80003d36:	e862                	sd	s8,16(sp)
    80003d38:	e466                	sd	s9,8(sp)
    panic("filewrite");
    80003d3a:	00004517          	auipc	a0,0x4
    80003d3e:	7fe50513          	addi	a0,a0,2046 # 80008538 <etext+0x538>
    80003d42:	00002097          	auipc	ra,0x2
    80003d46:	fa0080e7          	jalr	-96(ra) # 80005ce2 <panic>
    return -1;
    80003d4a:	557d                	li	a0,-1
}
    80003d4c:	8082                	ret
      return -1;
    80003d4e:	557d                	li	a0,-1
    80003d50:	bfc1                	j	80003d20 <filewrite+0x112>
    80003d52:	557d                	li	a0,-1
    80003d54:	b7f1                	j	80003d20 <filewrite+0x112>
    ret = (i == n ? n : -1);
    80003d56:	557d                	li	a0,-1
    80003d58:	7a42                	ld	s4,48(sp)
    80003d5a:	b7d9                	j	80003d20 <filewrite+0x112>

0000000080003d5c <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003d5c:	7179                	addi	sp,sp,-48
    80003d5e:	f406                	sd	ra,40(sp)
    80003d60:	f022                	sd	s0,32(sp)
    80003d62:	ec26                	sd	s1,24(sp)
    80003d64:	e052                	sd	s4,0(sp)
    80003d66:	1800                	addi	s0,sp,48
    80003d68:	84aa                	mv	s1,a0
    80003d6a:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003d6c:	0005b023          	sd	zero,0(a1)
    80003d70:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003d74:	00000097          	auipc	ra,0x0
    80003d78:	bb8080e7          	jalr	-1096(ra) # 8000392c <filealloc>
    80003d7c:	e088                	sd	a0,0(s1)
    80003d7e:	cd49                	beqz	a0,80003e18 <pipealloc+0xbc>
    80003d80:	00000097          	auipc	ra,0x0
    80003d84:	bac080e7          	jalr	-1108(ra) # 8000392c <filealloc>
    80003d88:	00aa3023          	sd	a0,0(s4)
    80003d8c:	c141                	beqz	a0,80003e0c <pipealloc+0xb0>
    80003d8e:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003d90:	ffffc097          	auipc	ra,0xffffc
    80003d94:	38a080e7          	jalr	906(ra) # 8000011a <kalloc>
    80003d98:	892a                	mv	s2,a0
    80003d9a:	c13d                	beqz	a0,80003e00 <pipealloc+0xa4>
    80003d9c:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80003d9e:	4985                	li	s3,1
    80003da0:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003da4:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003da8:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003dac:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003db0:	00004597          	auipc	a1,0x4
    80003db4:	79858593          	addi	a1,a1,1944 # 80008548 <etext+0x548>
    80003db8:	00002097          	auipc	ra,0x2
    80003dbc:	416080e7          	jalr	1046(ra) # 800061ce <initlock>
  (*f0)->type = FD_PIPE;
    80003dc0:	609c                	ld	a5,0(s1)
    80003dc2:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003dc6:	609c                	ld	a5,0(s1)
    80003dc8:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003dcc:	609c                	ld	a5,0(s1)
    80003dce:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003dd2:	609c                	ld	a5,0(s1)
    80003dd4:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003dd8:	000a3783          	ld	a5,0(s4)
    80003ddc:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003de0:	000a3783          	ld	a5,0(s4)
    80003de4:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003de8:	000a3783          	ld	a5,0(s4)
    80003dec:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003df0:	000a3783          	ld	a5,0(s4)
    80003df4:	0127b823          	sd	s2,16(a5)
  return 0;
    80003df8:	4501                	li	a0,0
    80003dfa:	6942                	ld	s2,16(sp)
    80003dfc:	69a2                	ld	s3,8(sp)
    80003dfe:	a03d                	j	80003e2c <pipealloc+0xd0>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003e00:	6088                	ld	a0,0(s1)
    80003e02:	c119                	beqz	a0,80003e08 <pipealloc+0xac>
    80003e04:	6942                	ld	s2,16(sp)
    80003e06:	a029                	j	80003e10 <pipealloc+0xb4>
    80003e08:	6942                	ld	s2,16(sp)
    80003e0a:	a039                	j	80003e18 <pipealloc+0xbc>
    80003e0c:	6088                	ld	a0,0(s1)
    80003e0e:	c50d                	beqz	a0,80003e38 <pipealloc+0xdc>
    fileclose(*f0);
    80003e10:	00000097          	auipc	ra,0x0
    80003e14:	bd8080e7          	jalr	-1064(ra) # 800039e8 <fileclose>
  if(*f1)
    80003e18:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003e1c:	557d                	li	a0,-1
  if(*f1)
    80003e1e:	c799                	beqz	a5,80003e2c <pipealloc+0xd0>
    fileclose(*f1);
    80003e20:	853e                	mv	a0,a5
    80003e22:	00000097          	auipc	ra,0x0
    80003e26:	bc6080e7          	jalr	-1082(ra) # 800039e8 <fileclose>
  return -1;
    80003e2a:	557d                	li	a0,-1
}
    80003e2c:	70a2                	ld	ra,40(sp)
    80003e2e:	7402                	ld	s0,32(sp)
    80003e30:	64e2                	ld	s1,24(sp)
    80003e32:	6a02                	ld	s4,0(sp)
    80003e34:	6145                	addi	sp,sp,48
    80003e36:	8082                	ret
  return -1;
    80003e38:	557d                	li	a0,-1
    80003e3a:	bfcd                	j	80003e2c <pipealloc+0xd0>

0000000080003e3c <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003e3c:	1101                	addi	sp,sp,-32
    80003e3e:	ec06                	sd	ra,24(sp)
    80003e40:	e822                	sd	s0,16(sp)
    80003e42:	e426                	sd	s1,8(sp)
    80003e44:	e04a                	sd	s2,0(sp)
    80003e46:	1000                	addi	s0,sp,32
    80003e48:	84aa                	mv	s1,a0
    80003e4a:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003e4c:	00002097          	auipc	ra,0x2
    80003e50:	416080e7          	jalr	1046(ra) # 80006262 <acquire>
  if(writable){
    80003e54:	02090d63          	beqz	s2,80003e8e <pipeclose+0x52>
    pi->writeopen = 0;
    80003e58:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003e5c:	21848513          	addi	a0,s1,536
    80003e60:	ffffe097          	auipc	ra,0xffffe
    80003e64:	860080e7          	jalr	-1952(ra) # 800016c0 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003e68:	2204b783          	ld	a5,544(s1)
    80003e6c:	eb95                	bnez	a5,80003ea0 <pipeclose+0x64>
    release(&pi->lock);
    80003e6e:	8526                	mv	a0,s1
    80003e70:	00002097          	auipc	ra,0x2
    80003e74:	4a2080e7          	jalr	1186(ra) # 80006312 <release>
    kfree((char*)pi);
    80003e78:	8526                	mv	a0,s1
    80003e7a:	ffffc097          	auipc	ra,0xffffc
    80003e7e:	1a2080e7          	jalr	418(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003e82:	60e2                	ld	ra,24(sp)
    80003e84:	6442                	ld	s0,16(sp)
    80003e86:	64a2                	ld	s1,8(sp)
    80003e88:	6902                	ld	s2,0(sp)
    80003e8a:	6105                	addi	sp,sp,32
    80003e8c:	8082                	ret
    pi->readopen = 0;
    80003e8e:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003e92:	21c48513          	addi	a0,s1,540
    80003e96:	ffffe097          	auipc	ra,0xffffe
    80003e9a:	82a080e7          	jalr	-2006(ra) # 800016c0 <wakeup>
    80003e9e:	b7e9                	j	80003e68 <pipeclose+0x2c>
    release(&pi->lock);
    80003ea0:	8526                	mv	a0,s1
    80003ea2:	00002097          	auipc	ra,0x2
    80003ea6:	470080e7          	jalr	1136(ra) # 80006312 <release>
}
    80003eaa:	bfe1                	j	80003e82 <pipeclose+0x46>

0000000080003eac <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003eac:	7159                	addi	sp,sp,-112
    80003eae:	f486                	sd	ra,104(sp)
    80003eb0:	f0a2                	sd	s0,96(sp)
    80003eb2:	eca6                	sd	s1,88(sp)
    80003eb4:	e8ca                	sd	s2,80(sp)
    80003eb6:	e4ce                	sd	s3,72(sp)
    80003eb8:	e0d2                	sd	s4,64(sp)
    80003eba:	fc56                	sd	s5,56(sp)
    80003ebc:	1880                	addi	s0,sp,112
    80003ebe:	84aa                	mv	s1,a0
    80003ec0:	8aae                	mv	s5,a1
    80003ec2:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003ec4:	ffffd097          	auipc	ra,0xffffd
    80003ec8:	fb0080e7          	jalr	-80(ra) # 80000e74 <myproc>
    80003ecc:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003ece:	8526                	mv	a0,s1
    80003ed0:	00002097          	auipc	ra,0x2
    80003ed4:	392080e7          	jalr	914(ra) # 80006262 <acquire>
  while(i < n){
    80003ed8:	0d405d63          	blez	s4,80003fb2 <pipewrite+0x106>
    80003edc:	f85a                	sd	s6,48(sp)
    80003ede:	f45e                	sd	s7,40(sp)
    80003ee0:	f062                	sd	s8,32(sp)
    80003ee2:	ec66                	sd	s9,24(sp)
    80003ee4:	e86a                	sd	s10,16(sp)
  int i = 0;
    80003ee6:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003ee8:	f9f40c13          	addi	s8,s0,-97
    80003eec:	4b85                	li	s7,1
    80003eee:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003ef0:	21848d13          	addi	s10,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003ef4:	21c48c93          	addi	s9,s1,540
    80003ef8:	a099                	j	80003f3e <pipewrite+0x92>
      release(&pi->lock);
    80003efa:	8526                	mv	a0,s1
    80003efc:	00002097          	auipc	ra,0x2
    80003f00:	416080e7          	jalr	1046(ra) # 80006312 <release>
      return -1;
    80003f04:	597d                	li	s2,-1
    80003f06:	7b42                	ld	s6,48(sp)
    80003f08:	7ba2                	ld	s7,40(sp)
    80003f0a:	7c02                	ld	s8,32(sp)
    80003f0c:	6ce2                	ld	s9,24(sp)
    80003f0e:	6d42                	ld	s10,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003f10:	854a                	mv	a0,s2
    80003f12:	70a6                	ld	ra,104(sp)
    80003f14:	7406                	ld	s0,96(sp)
    80003f16:	64e6                	ld	s1,88(sp)
    80003f18:	6946                	ld	s2,80(sp)
    80003f1a:	69a6                	ld	s3,72(sp)
    80003f1c:	6a06                	ld	s4,64(sp)
    80003f1e:	7ae2                	ld	s5,56(sp)
    80003f20:	6165                	addi	sp,sp,112
    80003f22:	8082                	ret
      wakeup(&pi->nread);
    80003f24:	856a                	mv	a0,s10
    80003f26:	ffffd097          	auipc	ra,0xffffd
    80003f2a:	79a080e7          	jalr	1946(ra) # 800016c0 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003f2e:	85a6                	mv	a1,s1
    80003f30:	8566                	mv	a0,s9
    80003f32:	ffffd097          	auipc	ra,0xffffd
    80003f36:	608080e7          	jalr	1544(ra) # 8000153a <sleep>
  while(i < n){
    80003f3a:	05495b63          	bge	s2,s4,80003f90 <pipewrite+0xe4>
    if(pi->readopen == 0 || pr->killed){
    80003f3e:	2204a783          	lw	a5,544(s1)
    80003f42:	dfc5                	beqz	a5,80003efa <pipewrite+0x4e>
    80003f44:	0289a783          	lw	a5,40(s3)
    80003f48:	fbcd                	bnez	a5,80003efa <pipewrite+0x4e>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003f4a:	2184a783          	lw	a5,536(s1)
    80003f4e:	21c4a703          	lw	a4,540(s1)
    80003f52:	2007879b          	addiw	a5,a5,512
    80003f56:	fcf707e3          	beq	a4,a5,80003f24 <pipewrite+0x78>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f5a:	86de                	mv	a3,s7
    80003f5c:	01590633          	add	a2,s2,s5
    80003f60:	85e2                	mv	a1,s8
    80003f62:	0509b503          	ld	a0,80(s3)
    80003f66:	ffffd097          	auipc	ra,0xffffd
    80003f6a:	c46080e7          	jalr	-954(ra) # 80000bac <copyin>
    80003f6e:	05650463          	beq	a0,s6,80003fb6 <pipewrite+0x10a>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003f72:	21c4a783          	lw	a5,540(s1)
    80003f76:	0017871b          	addiw	a4,a5,1
    80003f7a:	20e4ae23          	sw	a4,540(s1)
    80003f7e:	1ff7f793          	andi	a5,a5,511
    80003f82:	97a6                	add	a5,a5,s1
    80003f84:	f9f44703          	lbu	a4,-97(s0)
    80003f88:	00e78c23          	sb	a4,24(a5)
      i++;
    80003f8c:	2905                	addiw	s2,s2,1
    80003f8e:	b775                	j	80003f3a <pipewrite+0x8e>
    80003f90:	7b42                	ld	s6,48(sp)
    80003f92:	7ba2                	ld	s7,40(sp)
    80003f94:	7c02                	ld	s8,32(sp)
    80003f96:	6ce2                	ld	s9,24(sp)
    80003f98:	6d42                	ld	s10,16(sp)
  wakeup(&pi->nread);
    80003f9a:	21848513          	addi	a0,s1,536
    80003f9e:	ffffd097          	auipc	ra,0xffffd
    80003fa2:	722080e7          	jalr	1826(ra) # 800016c0 <wakeup>
  release(&pi->lock);
    80003fa6:	8526                	mv	a0,s1
    80003fa8:	00002097          	auipc	ra,0x2
    80003fac:	36a080e7          	jalr	874(ra) # 80006312 <release>
  return i;
    80003fb0:	b785                	j	80003f10 <pipewrite+0x64>
  int i = 0;
    80003fb2:	4901                	li	s2,0
    80003fb4:	b7dd                	j	80003f9a <pipewrite+0xee>
    80003fb6:	7b42                	ld	s6,48(sp)
    80003fb8:	7ba2                	ld	s7,40(sp)
    80003fba:	7c02                	ld	s8,32(sp)
    80003fbc:	6ce2                	ld	s9,24(sp)
    80003fbe:	6d42                	ld	s10,16(sp)
    80003fc0:	bfe9                	j	80003f9a <pipewrite+0xee>

0000000080003fc2 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003fc2:	711d                	addi	sp,sp,-96
    80003fc4:	ec86                	sd	ra,88(sp)
    80003fc6:	e8a2                	sd	s0,80(sp)
    80003fc8:	e4a6                	sd	s1,72(sp)
    80003fca:	e0ca                	sd	s2,64(sp)
    80003fcc:	fc4e                	sd	s3,56(sp)
    80003fce:	f852                	sd	s4,48(sp)
    80003fd0:	f456                	sd	s5,40(sp)
    80003fd2:	1080                	addi	s0,sp,96
    80003fd4:	84aa                	mv	s1,a0
    80003fd6:	892e                	mv	s2,a1
    80003fd8:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003fda:	ffffd097          	auipc	ra,0xffffd
    80003fde:	e9a080e7          	jalr	-358(ra) # 80000e74 <myproc>
    80003fe2:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003fe4:	8526                	mv	a0,s1
    80003fe6:	00002097          	auipc	ra,0x2
    80003fea:	27c080e7          	jalr	636(ra) # 80006262 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003fee:	2184a703          	lw	a4,536(s1)
    80003ff2:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003ff6:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003ffa:	02f71863          	bne	a4,a5,8000402a <piperead+0x68>
    80003ffe:	2244a783          	lw	a5,548(s1)
    80004002:	cf9d                	beqz	a5,80004040 <piperead+0x7e>
    if(pr->killed){
    80004004:	028a2783          	lw	a5,40(s4)
    80004008:	e78d                	bnez	a5,80004032 <piperead+0x70>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000400a:	85a6                	mv	a1,s1
    8000400c:	854e                	mv	a0,s3
    8000400e:	ffffd097          	auipc	ra,0xffffd
    80004012:	52c080e7          	jalr	1324(ra) # 8000153a <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004016:	2184a703          	lw	a4,536(s1)
    8000401a:	21c4a783          	lw	a5,540(s1)
    8000401e:	fef700e3          	beq	a4,a5,80003ffe <piperead+0x3c>
    80004022:	f05a                	sd	s6,32(sp)
    80004024:	ec5e                	sd	s7,24(sp)
    80004026:	e862                	sd	s8,16(sp)
    80004028:	a839                	j	80004046 <piperead+0x84>
    8000402a:	f05a                	sd	s6,32(sp)
    8000402c:	ec5e                	sd	s7,24(sp)
    8000402e:	e862                	sd	s8,16(sp)
    80004030:	a819                	j	80004046 <piperead+0x84>
      release(&pi->lock);
    80004032:	8526                	mv	a0,s1
    80004034:	00002097          	auipc	ra,0x2
    80004038:	2de080e7          	jalr	734(ra) # 80006312 <release>
      return -1;
    8000403c:	59fd                	li	s3,-1
    8000403e:	a895                	j	800040b2 <piperead+0xf0>
    80004040:	f05a                	sd	s6,32(sp)
    80004042:	ec5e                	sd	s7,24(sp)
    80004044:	e862                	sd	s8,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004046:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004048:	faf40c13          	addi	s8,s0,-81
    8000404c:	4b85                	li	s7,1
    8000404e:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004050:	05505363          	blez	s5,80004096 <piperead+0xd4>
    if(pi->nread == pi->nwrite)
    80004054:	2184a783          	lw	a5,536(s1)
    80004058:	21c4a703          	lw	a4,540(s1)
    8000405c:	02f70d63          	beq	a4,a5,80004096 <piperead+0xd4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004060:	0017871b          	addiw	a4,a5,1
    80004064:	20e4ac23          	sw	a4,536(s1)
    80004068:	1ff7f793          	andi	a5,a5,511
    8000406c:	97a6                	add	a5,a5,s1
    8000406e:	0187c783          	lbu	a5,24(a5)
    80004072:	faf407a3          	sb	a5,-81(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004076:	86de                	mv	a3,s7
    80004078:	8662                	mv	a2,s8
    8000407a:	85ca                	mv	a1,s2
    8000407c:	050a3503          	ld	a0,80(s4)
    80004080:	ffffd097          	auipc	ra,0xffffd
    80004084:	aa0080e7          	jalr	-1376(ra) # 80000b20 <copyout>
    80004088:	01650763          	beq	a0,s6,80004096 <piperead+0xd4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000408c:	2985                	addiw	s3,s3,1
    8000408e:	0905                	addi	s2,s2,1
    80004090:	fd3a92e3          	bne	s5,s3,80004054 <piperead+0x92>
    80004094:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004096:	21c48513          	addi	a0,s1,540
    8000409a:	ffffd097          	auipc	ra,0xffffd
    8000409e:	626080e7          	jalr	1574(ra) # 800016c0 <wakeup>
  release(&pi->lock);
    800040a2:	8526                	mv	a0,s1
    800040a4:	00002097          	auipc	ra,0x2
    800040a8:	26e080e7          	jalr	622(ra) # 80006312 <release>
    800040ac:	7b02                	ld	s6,32(sp)
    800040ae:	6be2                	ld	s7,24(sp)
    800040b0:	6c42                	ld	s8,16(sp)
  return i;
}
    800040b2:	854e                	mv	a0,s3
    800040b4:	60e6                	ld	ra,88(sp)
    800040b6:	6446                	ld	s0,80(sp)
    800040b8:	64a6                	ld	s1,72(sp)
    800040ba:	6906                	ld	s2,64(sp)
    800040bc:	79e2                	ld	s3,56(sp)
    800040be:	7a42                	ld	s4,48(sp)
    800040c0:	7aa2                	ld	s5,40(sp)
    800040c2:	6125                	addi	sp,sp,96
    800040c4:	8082                	ret

00000000800040c6 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    800040c6:	de010113          	addi	sp,sp,-544
    800040ca:	20113c23          	sd	ra,536(sp)
    800040ce:	20813823          	sd	s0,528(sp)
    800040d2:	20913423          	sd	s1,520(sp)
    800040d6:	21213023          	sd	s2,512(sp)
    800040da:	1400                	addi	s0,sp,544
    800040dc:	892a                	mv	s2,a0
    800040de:	dea43823          	sd	a0,-528(s0)
    800040e2:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800040e6:	ffffd097          	auipc	ra,0xffffd
    800040ea:	d8e080e7          	jalr	-626(ra) # 80000e74 <myproc>
    800040ee:	84aa                	mv	s1,a0

  begin_op();
    800040f0:	fffff097          	auipc	ra,0xfffff
    800040f4:	428080e7          	jalr	1064(ra) # 80003518 <begin_op>

  if((ip = namei(path)) == 0){
    800040f8:	854a                	mv	a0,s2
    800040fa:	fffff097          	auipc	ra,0xfffff
    800040fe:	218080e7          	jalr	536(ra) # 80003312 <namei>
    80004102:	c525                	beqz	a0,8000416a <exec+0xa4>
    80004104:	fbd2                	sd	s4,496(sp)
    80004106:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004108:	fffff097          	auipc	ra,0xfffff
    8000410c:	a1e080e7          	jalr	-1506(ra) # 80002b26 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004110:	04000713          	li	a4,64
    80004114:	4681                	li	a3,0
    80004116:	e5040613          	addi	a2,s0,-432
    8000411a:	4581                	li	a1,0
    8000411c:	8552                	mv	a0,s4
    8000411e:	fffff097          	auipc	ra,0xfffff
    80004122:	cc4080e7          	jalr	-828(ra) # 80002de2 <readi>
    80004126:	04000793          	li	a5,64
    8000412a:	00f51a63          	bne	a0,a5,8000413e <exec+0x78>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    8000412e:	e5042703          	lw	a4,-432(s0)
    80004132:	464c47b7          	lui	a5,0x464c4
    80004136:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000413a:	02f70e63          	beq	a4,a5,80004176 <exec+0xb0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    8000413e:	8552                	mv	a0,s4
    80004140:	fffff097          	auipc	ra,0xfffff
    80004144:	c4c080e7          	jalr	-948(ra) # 80002d8c <iunlockput>
    end_op();
    80004148:	fffff097          	auipc	ra,0xfffff
    8000414c:	44a080e7          	jalr	1098(ra) # 80003592 <end_op>
  }
  return -1;
    80004150:	557d                	li	a0,-1
    80004152:	7a5e                	ld	s4,496(sp)
}
    80004154:	21813083          	ld	ra,536(sp)
    80004158:	21013403          	ld	s0,528(sp)
    8000415c:	20813483          	ld	s1,520(sp)
    80004160:	20013903          	ld	s2,512(sp)
    80004164:	22010113          	addi	sp,sp,544
    80004168:	8082                	ret
    end_op();
    8000416a:	fffff097          	auipc	ra,0xfffff
    8000416e:	428080e7          	jalr	1064(ra) # 80003592 <end_op>
    return -1;
    80004172:	557d                	li	a0,-1
    80004174:	b7c5                	j	80004154 <exec+0x8e>
    80004176:	f3da                	sd	s6,480(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80004178:	8526                	mv	a0,s1
    8000417a:	ffffd097          	auipc	ra,0xffffd
    8000417e:	dbe080e7          	jalr	-578(ra) # 80000f38 <proc_pagetable>
    80004182:	8b2a                	mv	s6,a0
    80004184:	2a050863          	beqz	a0,80004434 <exec+0x36e>
    80004188:	ffce                	sd	s3,504(sp)
    8000418a:	f7d6                	sd	s5,488(sp)
    8000418c:	efde                	sd	s7,472(sp)
    8000418e:	ebe2                	sd	s8,464(sp)
    80004190:	e7e6                	sd	s9,456(sp)
    80004192:	e3ea                	sd	s10,448(sp)
    80004194:	ff6e                	sd	s11,440(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004196:	e7042683          	lw	a3,-400(s0)
    8000419a:	e8845783          	lhu	a5,-376(s0)
    8000419e:	cbfd                	beqz	a5,80004294 <exec+0x1ce>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800041a0:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800041a2:	4d01                	li	s10,0
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800041a4:	03800d93          	li	s11,56
    if((ph.vaddr % PGSIZE) != 0)
    800041a8:	6c85                	lui	s9,0x1
    800041aa:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800041ae:	def43423          	sd	a5,-536(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    800041b2:	6a85                	lui	s5,0x1
    800041b4:	a0b5                	j	80004220 <exec+0x15a>
      panic("loadseg: address should exist");
    800041b6:	00004517          	auipc	a0,0x4
    800041ba:	39a50513          	addi	a0,a0,922 # 80008550 <etext+0x550>
    800041be:	00002097          	auipc	ra,0x2
    800041c2:	b24080e7          	jalr	-1244(ra) # 80005ce2 <panic>
    if(sz - i < PGSIZE)
    800041c6:	2901                	sext.w	s2,s2
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800041c8:	874a                	mv	a4,s2
    800041ca:	009c06bb          	addw	a3,s8,s1
    800041ce:	4581                	li	a1,0
    800041d0:	8552                	mv	a0,s4
    800041d2:	fffff097          	auipc	ra,0xfffff
    800041d6:	c10080e7          	jalr	-1008(ra) # 80002de2 <readi>
    800041da:	26a91163          	bne	s2,a0,8000443c <exec+0x376>
  for(i = 0; i < sz; i += PGSIZE){
    800041de:	009a84bb          	addw	s1,s5,s1
    800041e2:	0334f463          	bgeu	s1,s3,8000420a <exec+0x144>
    pa = walkaddr(pagetable, va + i);
    800041e6:	02049593          	slli	a1,s1,0x20
    800041ea:	9181                	srli	a1,a1,0x20
    800041ec:	95de                	add	a1,a1,s7
    800041ee:	855a                	mv	a0,s6
    800041f0:	ffffc097          	auipc	ra,0xffffc
    800041f4:	328080e7          	jalr	808(ra) # 80000518 <walkaddr>
    800041f8:	862a                	mv	a2,a0
    if(pa == 0)
    800041fa:	dd55                	beqz	a0,800041b6 <exec+0xf0>
    if(sz - i < PGSIZE)
    800041fc:	409987bb          	subw	a5,s3,s1
    80004200:	893e                	mv	s2,a5
    80004202:	fcfcf2e3          	bgeu	s9,a5,800041c6 <exec+0x100>
    80004206:	8956                	mv	s2,s5
    80004208:	bf7d                	j	800041c6 <exec+0x100>
    sz = sz1;
    8000420a:	df843483          	ld	s1,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000420e:	2d05                	addiw	s10,s10,1
    80004210:	e0843783          	ld	a5,-504(s0)
    80004214:	0387869b          	addiw	a3,a5,56
    80004218:	e8845783          	lhu	a5,-376(s0)
    8000421c:	06fd5d63          	bge	s10,a5,80004296 <exec+0x1d0>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004220:	e0d43423          	sd	a3,-504(s0)
    80004224:	876e                	mv	a4,s11
    80004226:	e1840613          	addi	a2,s0,-488
    8000422a:	4581                	li	a1,0
    8000422c:	8552                	mv	a0,s4
    8000422e:	fffff097          	auipc	ra,0xfffff
    80004232:	bb4080e7          	jalr	-1100(ra) # 80002de2 <readi>
    80004236:	21b51163          	bne	a0,s11,80004438 <exec+0x372>
    if(ph.type != ELF_PROG_LOAD)
    8000423a:	e1842783          	lw	a5,-488(s0)
    8000423e:	4705                	li	a4,1
    80004240:	fce797e3          	bne	a5,a4,8000420e <exec+0x148>
    if(ph.memsz < ph.filesz)
    80004244:	e4043603          	ld	a2,-448(s0)
    80004248:	e3843783          	ld	a5,-456(s0)
    8000424c:	20f66863          	bltu	a2,a5,8000445c <exec+0x396>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004250:	e2843783          	ld	a5,-472(s0)
    80004254:	963e                	add	a2,a2,a5
    80004256:	20f66663          	bltu	a2,a5,80004462 <exec+0x39c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    8000425a:	85a6                	mv	a1,s1
    8000425c:	855a                	mv	a0,s6
    8000425e:	ffffc097          	auipc	ra,0xffffc
    80004262:	67e080e7          	jalr	1662(ra) # 800008dc <uvmalloc>
    80004266:	dea43c23          	sd	a0,-520(s0)
    8000426a:	1e050f63          	beqz	a0,80004468 <exec+0x3a2>
    if((ph.vaddr % PGSIZE) != 0)
    8000426e:	e2843b83          	ld	s7,-472(s0)
    80004272:	de843783          	ld	a5,-536(s0)
    80004276:	00fbf7b3          	and	a5,s7,a5
    8000427a:	1c079163          	bnez	a5,8000443c <exec+0x376>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000427e:	e2042c03          	lw	s8,-480(s0)
    80004282:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004286:	00098463          	beqz	s3,8000428e <exec+0x1c8>
    8000428a:	4481                	li	s1,0
    8000428c:	bfa9                	j	800041e6 <exec+0x120>
    sz = sz1;
    8000428e:	df843483          	ld	s1,-520(s0)
    80004292:	bfb5                	j	8000420e <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004294:	4481                	li	s1,0
  iunlockput(ip);
    80004296:	8552                	mv	a0,s4
    80004298:	fffff097          	auipc	ra,0xfffff
    8000429c:	af4080e7          	jalr	-1292(ra) # 80002d8c <iunlockput>
  end_op();
    800042a0:	fffff097          	auipc	ra,0xfffff
    800042a4:	2f2080e7          	jalr	754(ra) # 80003592 <end_op>
  p = myproc();
    800042a8:	ffffd097          	auipc	ra,0xffffd
    800042ac:	bcc080e7          	jalr	-1076(ra) # 80000e74 <myproc>
    800042b0:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800042b2:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    800042b6:	6985                	lui	s3,0x1
    800042b8:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    800042ba:	99a6                	add	s3,s3,s1
    800042bc:	77fd                	lui	a5,0xfffff
    800042be:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800042c2:	6609                	lui	a2,0x2
    800042c4:	964e                	add	a2,a2,s3
    800042c6:	85ce                	mv	a1,s3
    800042c8:	855a                	mv	a0,s6
    800042ca:	ffffc097          	auipc	ra,0xffffc
    800042ce:	612080e7          	jalr	1554(ra) # 800008dc <uvmalloc>
    800042d2:	8a2a                	mv	s4,a0
    800042d4:	e115                	bnez	a0,800042f8 <exec+0x232>
    proc_freepagetable(pagetable, sz);
    800042d6:	85ce                	mv	a1,s3
    800042d8:	855a                	mv	a0,s6
    800042da:	ffffd097          	auipc	ra,0xffffd
    800042de:	cfa080e7          	jalr	-774(ra) # 80000fd4 <proc_freepagetable>
  return -1;
    800042e2:	557d                	li	a0,-1
    800042e4:	79fe                	ld	s3,504(sp)
    800042e6:	7a5e                	ld	s4,496(sp)
    800042e8:	7abe                	ld	s5,488(sp)
    800042ea:	7b1e                	ld	s6,480(sp)
    800042ec:	6bfe                	ld	s7,472(sp)
    800042ee:	6c5e                	ld	s8,464(sp)
    800042f0:	6cbe                	ld	s9,456(sp)
    800042f2:	6d1e                	ld	s10,448(sp)
    800042f4:	7dfa                	ld	s11,440(sp)
    800042f6:	bdb9                	j	80004154 <exec+0x8e>
  uvmclear(pagetable, sz-2*PGSIZE);
    800042f8:	75f9                	lui	a1,0xffffe
    800042fa:	95aa                	add	a1,a1,a0
    800042fc:	855a                	mv	a0,s6
    800042fe:	ffffc097          	auipc	ra,0xffffc
    80004302:	7f0080e7          	jalr	2032(ra) # 80000aee <uvmclear>
  stackbase = sp - PGSIZE;
    80004306:	7bfd                	lui	s7,0xfffff
    80004308:	9bd2                	add	s7,s7,s4
  for(argc = 0; argv[argc]; argc++) {
    8000430a:	e0043783          	ld	a5,-512(s0)
    8000430e:	6388                	ld	a0,0(a5)
  sp = sz;
    80004310:	8952                	mv	s2,s4
  for(argc = 0; argv[argc]; argc++) {
    80004312:	4481                	li	s1,0
    ustack[argc] = sp;
    80004314:	e9040c93          	addi	s9,s0,-368
    if(argc >= MAXARG)
    80004318:	02000c13          	li	s8,32
  for(argc = 0; argv[argc]; argc++) {
    8000431c:	c135                	beqz	a0,80004380 <exec+0x2ba>
    sp -= strlen(argv[argc]) + 1;
    8000431e:	ffffc097          	auipc	ra,0xffffc
    80004322:	fe8080e7          	jalr	-24(ra) # 80000306 <strlen>
    80004326:	0015079b          	addiw	a5,a0,1
    8000432a:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    8000432e:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80004332:	13796e63          	bltu	s2,s7,8000446e <exec+0x3a8>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004336:	e0043d83          	ld	s11,-512(s0)
    8000433a:	000db983          	ld	s3,0(s11)
    8000433e:	854e                	mv	a0,s3
    80004340:	ffffc097          	auipc	ra,0xffffc
    80004344:	fc6080e7          	jalr	-58(ra) # 80000306 <strlen>
    80004348:	0015069b          	addiw	a3,a0,1
    8000434c:	864e                	mv	a2,s3
    8000434e:	85ca                	mv	a1,s2
    80004350:	855a                	mv	a0,s6
    80004352:	ffffc097          	auipc	ra,0xffffc
    80004356:	7ce080e7          	jalr	1998(ra) # 80000b20 <copyout>
    8000435a:	10054c63          	bltz	a0,80004472 <exec+0x3ac>
    ustack[argc] = sp;
    8000435e:	00349793          	slli	a5,s1,0x3
    80004362:	97e6                	add	a5,a5,s9
    80004364:	0127b023          	sd	s2,0(a5) # fffffffffffff000 <end+0xffffffff7ffd8dc0>
  for(argc = 0; argv[argc]; argc++) {
    80004368:	0485                	addi	s1,s1,1
    8000436a:	008d8793          	addi	a5,s11,8
    8000436e:	e0f43023          	sd	a5,-512(s0)
    80004372:	008db503          	ld	a0,8(s11)
    80004376:	c509                	beqz	a0,80004380 <exec+0x2ba>
    if(argc >= MAXARG)
    80004378:	fb8493e3          	bne	s1,s8,8000431e <exec+0x258>
  sz = sz1;
    8000437c:	89d2                	mv	s3,s4
    8000437e:	bfa1                	j	800042d6 <exec+0x210>
  ustack[argc] = 0;
    80004380:	00349793          	slli	a5,s1,0x3
    80004384:	f9078793          	addi	a5,a5,-112
    80004388:	97a2                	add	a5,a5,s0
    8000438a:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    8000438e:	00148693          	addi	a3,s1,1
    80004392:	068e                	slli	a3,a3,0x3
    80004394:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004398:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    8000439c:	89d2                	mv	s3,s4
  if(sp < stackbase)
    8000439e:	f3796ce3          	bltu	s2,s7,800042d6 <exec+0x210>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800043a2:	e9040613          	addi	a2,s0,-368
    800043a6:	85ca                	mv	a1,s2
    800043a8:	855a                	mv	a0,s6
    800043aa:	ffffc097          	auipc	ra,0xffffc
    800043ae:	776080e7          	jalr	1910(ra) # 80000b20 <copyout>
    800043b2:	f20542e3          	bltz	a0,800042d6 <exec+0x210>
  p->trapframe->a1 = sp;
    800043b6:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    800043ba:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800043be:	df043783          	ld	a5,-528(s0)
    800043c2:	0007c703          	lbu	a4,0(a5)
    800043c6:	cf11                	beqz	a4,800043e2 <exec+0x31c>
    800043c8:	0785                	addi	a5,a5,1
    if(*s == '/')
    800043ca:	02f00693          	li	a3,47
    800043ce:	a029                	j	800043d8 <exec+0x312>
  for(last=s=path; *s; s++)
    800043d0:	0785                	addi	a5,a5,1
    800043d2:	fff7c703          	lbu	a4,-1(a5)
    800043d6:	c711                	beqz	a4,800043e2 <exec+0x31c>
    if(*s == '/')
    800043d8:	fed71ce3          	bne	a4,a3,800043d0 <exec+0x30a>
      last = s+1;
    800043dc:	def43823          	sd	a5,-528(s0)
    800043e0:	bfc5                	j	800043d0 <exec+0x30a>
  safestrcpy(p->name, last, sizeof(p->name));
    800043e2:	4641                	li	a2,16
    800043e4:	df043583          	ld	a1,-528(s0)
    800043e8:	158a8513          	addi	a0,s5,344
    800043ec:	ffffc097          	auipc	ra,0xffffc
    800043f0:	ee4080e7          	jalr	-284(ra) # 800002d0 <safestrcpy>
  oldpagetable = p->pagetable;
    800043f4:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    800043f8:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    800043fc:	054ab423          	sd	s4,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004400:	058ab783          	ld	a5,88(s5)
    80004404:	e6843703          	ld	a4,-408(s0)
    80004408:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000440a:	058ab783          	ld	a5,88(s5)
    8000440e:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004412:	85ea                	mv	a1,s10
    80004414:	ffffd097          	auipc	ra,0xffffd
    80004418:	bc0080e7          	jalr	-1088(ra) # 80000fd4 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000441c:	0004851b          	sext.w	a0,s1
    80004420:	79fe                	ld	s3,504(sp)
    80004422:	7a5e                	ld	s4,496(sp)
    80004424:	7abe                	ld	s5,488(sp)
    80004426:	7b1e                	ld	s6,480(sp)
    80004428:	6bfe                	ld	s7,472(sp)
    8000442a:	6c5e                	ld	s8,464(sp)
    8000442c:	6cbe                	ld	s9,456(sp)
    8000442e:	6d1e                	ld	s10,448(sp)
    80004430:	7dfa                	ld	s11,440(sp)
    80004432:	b30d                	j	80004154 <exec+0x8e>
    80004434:	7b1e                	ld	s6,480(sp)
    80004436:	b321                	j	8000413e <exec+0x78>
    80004438:	de943c23          	sd	s1,-520(s0)
    proc_freepagetable(pagetable, sz);
    8000443c:	df843583          	ld	a1,-520(s0)
    80004440:	855a                	mv	a0,s6
    80004442:	ffffd097          	auipc	ra,0xffffd
    80004446:	b92080e7          	jalr	-1134(ra) # 80000fd4 <proc_freepagetable>
  if(ip){
    8000444a:	79fe                	ld	s3,504(sp)
    8000444c:	7abe                	ld	s5,488(sp)
    8000444e:	7b1e                	ld	s6,480(sp)
    80004450:	6bfe                	ld	s7,472(sp)
    80004452:	6c5e                	ld	s8,464(sp)
    80004454:	6cbe                	ld	s9,456(sp)
    80004456:	6d1e                	ld	s10,448(sp)
    80004458:	7dfa                	ld	s11,440(sp)
    8000445a:	b1d5                	j	8000413e <exec+0x78>
    8000445c:	de943c23          	sd	s1,-520(s0)
    80004460:	bff1                	j	8000443c <exec+0x376>
    80004462:	de943c23          	sd	s1,-520(s0)
    80004466:	bfd9                	j	8000443c <exec+0x376>
    80004468:	de943c23          	sd	s1,-520(s0)
    8000446c:	bfc1                	j	8000443c <exec+0x376>
  sz = sz1;
    8000446e:	89d2                	mv	s3,s4
    80004470:	b59d                	j	800042d6 <exec+0x210>
    80004472:	89d2                	mv	s3,s4
    80004474:	b58d                	j	800042d6 <exec+0x210>

0000000080004476 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004476:	7179                	addi	sp,sp,-48
    80004478:	f406                	sd	ra,40(sp)
    8000447a:	f022                	sd	s0,32(sp)
    8000447c:	ec26                	sd	s1,24(sp)
    8000447e:	e84a                	sd	s2,16(sp)
    80004480:	1800                	addi	s0,sp,48
    80004482:	892e                	mv	s2,a1
    80004484:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80004486:	fdc40593          	addi	a1,s0,-36
    8000448a:	ffffe097          	auipc	ra,0xffffe
    8000448e:	b48080e7          	jalr	-1208(ra) # 80001fd2 <argint>
    80004492:	04054063          	bltz	a0,800044d2 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004496:	fdc42703          	lw	a4,-36(s0)
    8000449a:	47bd                	li	a5,15
    8000449c:	02e7ed63          	bltu	a5,a4,800044d6 <argfd+0x60>
    800044a0:	ffffd097          	auipc	ra,0xffffd
    800044a4:	9d4080e7          	jalr	-1580(ra) # 80000e74 <myproc>
    800044a8:	fdc42703          	lw	a4,-36(s0)
    800044ac:	01a70793          	addi	a5,a4,26
    800044b0:	078e                	slli	a5,a5,0x3
    800044b2:	953e                	add	a0,a0,a5
    800044b4:	611c                	ld	a5,0(a0)
    800044b6:	c395                	beqz	a5,800044da <argfd+0x64>
    return -1;
  if(pfd)
    800044b8:	00090463          	beqz	s2,800044c0 <argfd+0x4a>
    *pfd = fd;
    800044bc:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800044c0:	4501                	li	a0,0
  if(pf)
    800044c2:	c091                	beqz	s1,800044c6 <argfd+0x50>
    *pf = f;
    800044c4:	e09c                	sd	a5,0(s1)
}
    800044c6:	70a2                	ld	ra,40(sp)
    800044c8:	7402                	ld	s0,32(sp)
    800044ca:	64e2                	ld	s1,24(sp)
    800044cc:	6942                	ld	s2,16(sp)
    800044ce:	6145                	addi	sp,sp,48
    800044d0:	8082                	ret
    return -1;
    800044d2:	557d                	li	a0,-1
    800044d4:	bfcd                	j	800044c6 <argfd+0x50>
    return -1;
    800044d6:	557d                	li	a0,-1
    800044d8:	b7fd                	j	800044c6 <argfd+0x50>
    800044da:	557d                	li	a0,-1
    800044dc:	b7ed                	j	800044c6 <argfd+0x50>

00000000800044de <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800044de:	1101                	addi	sp,sp,-32
    800044e0:	ec06                	sd	ra,24(sp)
    800044e2:	e822                	sd	s0,16(sp)
    800044e4:	e426                	sd	s1,8(sp)
    800044e6:	1000                	addi	s0,sp,32
    800044e8:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800044ea:	ffffd097          	auipc	ra,0xffffd
    800044ee:	98a080e7          	jalr	-1654(ra) # 80000e74 <myproc>
    800044f2:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800044f4:	0d050793          	addi	a5,a0,208
    800044f8:	4501                	li	a0,0
    800044fa:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800044fc:	6398                	ld	a4,0(a5)
    800044fe:	cb19                	beqz	a4,80004514 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004500:	2505                	addiw	a0,a0,1
    80004502:	07a1                	addi	a5,a5,8
    80004504:	fed51ce3          	bne	a0,a3,800044fc <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004508:	557d                	li	a0,-1
}
    8000450a:	60e2                	ld	ra,24(sp)
    8000450c:	6442                	ld	s0,16(sp)
    8000450e:	64a2                	ld	s1,8(sp)
    80004510:	6105                	addi	sp,sp,32
    80004512:	8082                	ret
      p->ofile[fd] = f;
    80004514:	01a50793          	addi	a5,a0,26
    80004518:	078e                	slli	a5,a5,0x3
    8000451a:	963e                	add	a2,a2,a5
    8000451c:	e204                	sd	s1,0(a2)
      return fd;
    8000451e:	b7f5                	j	8000450a <fdalloc+0x2c>

0000000080004520 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004520:	715d                	addi	sp,sp,-80
    80004522:	e486                	sd	ra,72(sp)
    80004524:	e0a2                	sd	s0,64(sp)
    80004526:	fc26                	sd	s1,56(sp)
    80004528:	f84a                	sd	s2,48(sp)
    8000452a:	f44e                	sd	s3,40(sp)
    8000452c:	f052                	sd	s4,32(sp)
    8000452e:	ec56                	sd	s5,24(sp)
    80004530:	0880                	addi	s0,sp,80
    80004532:	8aae                	mv	s5,a1
    80004534:	8a32                	mv	s4,a2
    80004536:	89b6                	mv	s3,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004538:	fb040593          	addi	a1,s0,-80
    8000453c:	fffff097          	auipc	ra,0xfffff
    80004540:	df4080e7          	jalr	-524(ra) # 80003330 <nameiparent>
    80004544:	892a                	mv	s2,a0
    80004546:	12050c63          	beqz	a0,8000467e <create+0x15e>
    return 0;

  ilock(dp);
    8000454a:	ffffe097          	auipc	ra,0xffffe
    8000454e:	5dc080e7          	jalr	1500(ra) # 80002b26 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004552:	4601                	li	a2,0
    80004554:	fb040593          	addi	a1,s0,-80
    80004558:	854a                	mv	a0,s2
    8000455a:	fffff097          	auipc	ra,0xfffff
    8000455e:	abc080e7          	jalr	-1348(ra) # 80003016 <dirlookup>
    80004562:	84aa                	mv	s1,a0
    80004564:	c539                	beqz	a0,800045b2 <create+0x92>
    iunlockput(dp);
    80004566:	854a                	mv	a0,s2
    80004568:	fffff097          	auipc	ra,0xfffff
    8000456c:	824080e7          	jalr	-2012(ra) # 80002d8c <iunlockput>
    ilock(ip);
    80004570:	8526                	mv	a0,s1
    80004572:	ffffe097          	auipc	ra,0xffffe
    80004576:	5b4080e7          	jalr	1460(ra) # 80002b26 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000457a:	4789                	li	a5,2
    8000457c:	02fa9463          	bne	s5,a5,800045a4 <create+0x84>
    80004580:	0444d783          	lhu	a5,68(s1)
    80004584:	37f9                	addiw	a5,a5,-2
    80004586:	17c2                	slli	a5,a5,0x30
    80004588:	93c1                	srli	a5,a5,0x30
    8000458a:	4705                	li	a4,1
    8000458c:	00f76c63          	bltu	a4,a5,800045a4 <create+0x84>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80004590:	8526                	mv	a0,s1
    80004592:	60a6                	ld	ra,72(sp)
    80004594:	6406                	ld	s0,64(sp)
    80004596:	74e2                	ld	s1,56(sp)
    80004598:	7942                	ld	s2,48(sp)
    8000459a:	79a2                	ld	s3,40(sp)
    8000459c:	7a02                	ld	s4,32(sp)
    8000459e:	6ae2                	ld	s5,24(sp)
    800045a0:	6161                	addi	sp,sp,80
    800045a2:	8082                	ret
    iunlockput(ip);
    800045a4:	8526                	mv	a0,s1
    800045a6:	ffffe097          	auipc	ra,0xffffe
    800045aa:	7e6080e7          	jalr	2022(ra) # 80002d8c <iunlockput>
    return 0;
    800045ae:	4481                	li	s1,0
    800045b0:	b7c5                	j	80004590 <create+0x70>
  if((ip = ialloc(dp->dev, type)) == 0)
    800045b2:	85d6                	mv	a1,s5
    800045b4:	00092503          	lw	a0,0(s2)
    800045b8:	ffffe097          	auipc	ra,0xffffe
    800045bc:	3da080e7          	jalr	986(ra) # 80002992 <ialloc>
    800045c0:	84aa                	mv	s1,a0
    800045c2:	c139                	beqz	a0,80004608 <create+0xe8>
  ilock(ip);
    800045c4:	ffffe097          	auipc	ra,0xffffe
    800045c8:	562080e7          	jalr	1378(ra) # 80002b26 <ilock>
  ip->major = major;
    800045cc:	05449323          	sh	s4,70(s1)
  ip->minor = minor;
    800045d0:	05349423          	sh	s3,72(s1)
  ip->nlink = 1;
    800045d4:	4985                	li	s3,1
    800045d6:	05349523          	sh	s3,74(s1)
  iupdate(ip);
    800045da:	8526                	mv	a0,s1
    800045dc:	ffffe097          	auipc	ra,0xffffe
    800045e0:	47e080e7          	jalr	1150(ra) # 80002a5a <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800045e4:	033a8a63          	beq	s5,s3,80004618 <create+0xf8>
  if(dirlink(dp, name, ip->inum) < 0)
    800045e8:	40d0                	lw	a2,4(s1)
    800045ea:	fb040593          	addi	a1,s0,-80
    800045ee:	854a                	mv	a0,s2
    800045f0:	fffff097          	auipc	ra,0xfffff
    800045f4:	c4c080e7          	jalr	-948(ra) # 8000323c <dirlink>
    800045f8:	06054b63          	bltz	a0,8000466e <create+0x14e>
  iunlockput(dp);
    800045fc:	854a                	mv	a0,s2
    800045fe:	ffffe097          	auipc	ra,0xffffe
    80004602:	78e080e7          	jalr	1934(ra) # 80002d8c <iunlockput>
  return ip;
    80004606:	b769                	j	80004590 <create+0x70>
    panic("create: ialloc");
    80004608:	00004517          	auipc	a0,0x4
    8000460c:	f6850513          	addi	a0,a0,-152 # 80008570 <etext+0x570>
    80004610:	00001097          	auipc	ra,0x1
    80004614:	6d2080e7          	jalr	1746(ra) # 80005ce2 <panic>
    dp->nlink++;  // for ".."
    80004618:	04a95783          	lhu	a5,74(s2)
    8000461c:	2785                	addiw	a5,a5,1
    8000461e:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    80004622:	854a                	mv	a0,s2
    80004624:	ffffe097          	auipc	ra,0xffffe
    80004628:	436080e7          	jalr	1078(ra) # 80002a5a <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000462c:	40d0                	lw	a2,4(s1)
    8000462e:	00004597          	auipc	a1,0x4
    80004632:	f5258593          	addi	a1,a1,-174 # 80008580 <etext+0x580>
    80004636:	8526                	mv	a0,s1
    80004638:	fffff097          	auipc	ra,0xfffff
    8000463c:	c04080e7          	jalr	-1020(ra) # 8000323c <dirlink>
    80004640:	00054f63          	bltz	a0,8000465e <create+0x13e>
    80004644:	00492603          	lw	a2,4(s2)
    80004648:	00004597          	auipc	a1,0x4
    8000464c:	f4058593          	addi	a1,a1,-192 # 80008588 <etext+0x588>
    80004650:	8526                	mv	a0,s1
    80004652:	fffff097          	auipc	ra,0xfffff
    80004656:	bea080e7          	jalr	-1046(ra) # 8000323c <dirlink>
    8000465a:	f80557e3          	bgez	a0,800045e8 <create+0xc8>
      panic("create dots");
    8000465e:	00004517          	auipc	a0,0x4
    80004662:	f3250513          	addi	a0,a0,-206 # 80008590 <etext+0x590>
    80004666:	00001097          	auipc	ra,0x1
    8000466a:	67c080e7          	jalr	1660(ra) # 80005ce2 <panic>
    panic("create: dirlink");
    8000466e:	00004517          	auipc	a0,0x4
    80004672:	f3250513          	addi	a0,a0,-206 # 800085a0 <etext+0x5a0>
    80004676:	00001097          	auipc	ra,0x1
    8000467a:	66c080e7          	jalr	1644(ra) # 80005ce2 <panic>
    return 0;
    8000467e:	84aa                	mv	s1,a0
    80004680:	bf01                	j	80004590 <create+0x70>

0000000080004682 <sys_dup>:
{
    80004682:	7179                	addi	sp,sp,-48
    80004684:	f406                	sd	ra,40(sp)
    80004686:	f022                	sd	s0,32(sp)
    80004688:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000468a:	fd840613          	addi	a2,s0,-40
    8000468e:	4581                	li	a1,0
    80004690:	4501                	li	a0,0
    80004692:	00000097          	auipc	ra,0x0
    80004696:	de4080e7          	jalr	-540(ra) # 80004476 <argfd>
    return -1;
    8000469a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000469c:	02054763          	bltz	a0,800046ca <sys_dup+0x48>
    800046a0:	ec26                	sd	s1,24(sp)
    800046a2:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    800046a4:	fd843903          	ld	s2,-40(s0)
    800046a8:	854a                	mv	a0,s2
    800046aa:	00000097          	auipc	ra,0x0
    800046ae:	e34080e7          	jalr	-460(ra) # 800044de <fdalloc>
    800046b2:	84aa                	mv	s1,a0
    return -1;
    800046b4:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800046b6:	00054f63          	bltz	a0,800046d4 <sys_dup+0x52>
  filedup(f);
    800046ba:	854a                	mv	a0,s2
    800046bc:	fffff097          	auipc	ra,0xfffff
    800046c0:	2da080e7          	jalr	730(ra) # 80003996 <filedup>
  return fd;
    800046c4:	87a6                	mv	a5,s1
    800046c6:	64e2                	ld	s1,24(sp)
    800046c8:	6942                	ld	s2,16(sp)
}
    800046ca:	853e                	mv	a0,a5
    800046cc:	70a2                	ld	ra,40(sp)
    800046ce:	7402                	ld	s0,32(sp)
    800046d0:	6145                	addi	sp,sp,48
    800046d2:	8082                	ret
    800046d4:	64e2                	ld	s1,24(sp)
    800046d6:	6942                	ld	s2,16(sp)
    800046d8:	bfcd                	j	800046ca <sys_dup+0x48>

00000000800046da <sys_read>:
{
    800046da:	7179                	addi	sp,sp,-48
    800046dc:	f406                	sd	ra,40(sp)
    800046de:	f022                	sd	s0,32(sp)
    800046e0:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046e2:	fe840613          	addi	a2,s0,-24
    800046e6:	4581                	li	a1,0
    800046e8:	4501                	li	a0,0
    800046ea:	00000097          	auipc	ra,0x0
    800046ee:	d8c080e7          	jalr	-628(ra) # 80004476 <argfd>
    return -1;
    800046f2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046f4:	04054163          	bltz	a0,80004736 <sys_read+0x5c>
    800046f8:	fe440593          	addi	a1,s0,-28
    800046fc:	4509                	li	a0,2
    800046fe:	ffffe097          	auipc	ra,0xffffe
    80004702:	8d4080e7          	jalr	-1836(ra) # 80001fd2 <argint>
    return -1;
    80004706:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004708:	02054763          	bltz	a0,80004736 <sys_read+0x5c>
    8000470c:	fd840593          	addi	a1,s0,-40
    80004710:	4505                	li	a0,1
    80004712:	ffffe097          	auipc	ra,0xffffe
    80004716:	8e2080e7          	jalr	-1822(ra) # 80001ff4 <argaddr>
    return -1;
    8000471a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000471c:	00054d63          	bltz	a0,80004736 <sys_read+0x5c>
  return fileread(f, p, n);
    80004720:	fe442603          	lw	a2,-28(s0)
    80004724:	fd843583          	ld	a1,-40(s0)
    80004728:	fe843503          	ld	a0,-24(s0)
    8000472c:	fffff097          	auipc	ra,0xfffff
    80004730:	410080e7          	jalr	1040(ra) # 80003b3c <fileread>
    80004734:	87aa                	mv	a5,a0
}
    80004736:	853e                	mv	a0,a5
    80004738:	70a2                	ld	ra,40(sp)
    8000473a:	7402                	ld	s0,32(sp)
    8000473c:	6145                	addi	sp,sp,48
    8000473e:	8082                	ret

0000000080004740 <sys_write>:
{
    80004740:	7179                	addi	sp,sp,-48
    80004742:	f406                	sd	ra,40(sp)
    80004744:	f022                	sd	s0,32(sp)
    80004746:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004748:	fe840613          	addi	a2,s0,-24
    8000474c:	4581                	li	a1,0
    8000474e:	4501                	li	a0,0
    80004750:	00000097          	auipc	ra,0x0
    80004754:	d26080e7          	jalr	-730(ra) # 80004476 <argfd>
    return -1;
    80004758:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000475a:	04054163          	bltz	a0,8000479c <sys_write+0x5c>
    8000475e:	fe440593          	addi	a1,s0,-28
    80004762:	4509                	li	a0,2
    80004764:	ffffe097          	auipc	ra,0xffffe
    80004768:	86e080e7          	jalr	-1938(ra) # 80001fd2 <argint>
    return -1;
    8000476c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000476e:	02054763          	bltz	a0,8000479c <sys_write+0x5c>
    80004772:	fd840593          	addi	a1,s0,-40
    80004776:	4505                	li	a0,1
    80004778:	ffffe097          	auipc	ra,0xffffe
    8000477c:	87c080e7          	jalr	-1924(ra) # 80001ff4 <argaddr>
    return -1;
    80004780:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004782:	00054d63          	bltz	a0,8000479c <sys_write+0x5c>
  return filewrite(f, p, n);
    80004786:	fe442603          	lw	a2,-28(s0)
    8000478a:	fd843583          	ld	a1,-40(s0)
    8000478e:	fe843503          	ld	a0,-24(s0)
    80004792:	fffff097          	auipc	ra,0xfffff
    80004796:	47c080e7          	jalr	1148(ra) # 80003c0e <filewrite>
    8000479a:	87aa                	mv	a5,a0
}
    8000479c:	853e                	mv	a0,a5
    8000479e:	70a2                	ld	ra,40(sp)
    800047a0:	7402                	ld	s0,32(sp)
    800047a2:	6145                	addi	sp,sp,48
    800047a4:	8082                	ret

00000000800047a6 <sys_close>:
{
    800047a6:	1101                	addi	sp,sp,-32
    800047a8:	ec06                	sd	ra,24(sp)
    800047aa:	e822                	sd	s0,16(sp)
    800047ac:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800047ae:	fe040613          	addi	a2,s0,-32
    800047b2:	fec40593          	addi	a1,s0,-20
    800047b6:	4501                	li	a0,0
    800047b8:	00000097          	auipc	ra,0x0
    800047bc:	cbe080e7          	jalr	-834(ra) # 80004476 <argfd>
    return -1;
    800047c0:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800047c2:	02054463          	bltz	a0,800047ea <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800047c6:	ffffc097          	auipc	ra,0xffffc
    800047ca:	6ae080e7          	jalr	1710(ra) # 80000e74 <myproc>
    800047ce:	fec42783          	lw	a5,-20(s0)
    800047d2:	07e9                	addi	a5,a5,26
    800047d4:	078e                	slli	a5,a5,0x3
    800047d6:	953e                	add	a0,a0,a5
    800047d8:	00053023          	sd	zero,0(a0)
  fileclose(f);
    800047dc:	fe043503          	ld	a0,-32(s0)
    800047e0:	fffff097          	auipc	ra,0xfffff
    800047e4:	208080e7          	jalr	520(ra) # 800039e8 <fileclose>
  return 0;
    800047e8:	4781                	li	a5,0
}
    800047ea:	853e                	mv	a0,a5
    800047ec:	60e2                	ld	ra,24(sp)
    800047ee:	6442                	ld	s0,16(sp)
    800047f0:	6105                	addi	sp,sp,32
    800047f2:	8082                	ret

00000000800047f4 <sys_fstat>:
{
    800047f4:	1101                	addi	sp,sp,-32
    800047f6:	ec06                	sd	ra,24(sp)
    800047f8:	e822                	sd	s0,16(sp)
    800047fa:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800047fc:	fe840613          	addi	a2,s0,-24
    80004800:	4581                	li	a1,0
    80004802:	4501                	li	a0,0
    80004804:	00000097          	auipc	ra,0x0
    80004808:	c72080e7          	jalr	-910(ra) # 80004476 <argfd>
    return -1;
    8000480c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000480e:	02054563          	bltz	a0,80004838 <sys_fstat+0x44>
    80004812:	fe040593          	addi	a1,s0,-32
    80004816:	4505                	li	a0,1
    80004818:	ffffd097          	auipc	ra,0xffffd
    8000481c:	7dc080e7          	jalr	2012(ra) # 80001ff4 <argaddr>
    return -1;
    80004820:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004822:	00054b63          	bltz	a0,80004838 <sys_fstat+0x44>
  return filestat(f, st);
    80004826:	fe043583          	ld	a1,-32(s0)
    8000482a:	fe843503          	ld	a0,-24(s0)
    8000482e:	fffff097          	auipc	ra,0xfffff
    80004832:	298080e7          	jalr	664(ra) # 80003ac6 <filestat>
    80004836:	87aa                	mv	a5,a0
}
    80004838:	853e                	mv	a0,a5
    8000483a:	60e2                	ld	ra,24(sp)
    8000483c:	6442                	ld	s0,16(sp)
    8000483e:	6105                	addi	sp,sp,32
    80004840:	8082                	ret

0000000080004842 <sys_link>:
{
    80004842:	7169                	addi	sp,sp,-304
    80004844:	f606                	sd	ra,296(sp)
    80004846:	f222                	sd	s0,288(sp)
    80004848:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000484a:	08000613          	li	a2,128
    8000484e:	ed040593          	addi	a1,s0,-304
    80004852:	4501                	li	a0,0
    80004854:	ffffd097          	auipc	ra,0xffffd
    80004858:	7c2080e7          	jalr	1986(ra) # 80002016 <argstr>
    return -1;
    8000485c:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000485e:	12054663          	bltz	a0,8000498a <sys_link+0x148>
    80004862:	08000613          	li	a2,128
    80004866:	f5040593          	addi	a1,s0,-176
    8000486a:	4505                	li	a0,1
    8000486c:	ffffd097          	auipc	ra,0xffffd
    80004870:	7aa080e7          	jalr	1962(ra) # 80002016 <argstr>
    return -1;
    80004874:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004876:	10054a63          	bltz	a0,8000498a <sys_link+0x148>
    8000487a:	ee26                	sd	s1,280(sp)
  begin_op();
    8000487c:	fffff097          	auipc	ra,0xfffff
    80004880:	c9c080e7          	jalr	-868(ra) # 80003518 <begin_op>
  if((ip = namei(old)) == 0){
    80004884:	ed040513          	addi	a0,s0,-304
    80004888:	fffff097          	auipc	ra,0xfffff
    8000488c:	a8a080e7          	jalr	-1398(ra) # 80003312 <namei>
    80004890:	84aa                	mv	s1,a0
    80004892:	c949                	beqz	a0,80004924 <sys_link+0xe2>
  ilock(ip);
    80004894:	ffffe097          	auipc	ra,0xffffe
    80004898:	292080e7          	jalr	658(ra) # 80002b26 <ilock>
  if(ip->type == T_DIR){
    8000489c:	04449703          	lh	a4,68(s1)
    800048a0:	4785                	li	a5,1
    800048a2:	08f70863          	beq	a4,a5,80004932 <sys_link+0xf0>
    800048a6:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    800048a8:	04a4d783          	lhu	a5,74(s1)
    800048ac:	2785                	addiw	a5,a5,1
    800048ae:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800048b2:	8526                	mv	a0,s1
    800048b4:	ffffe097          	auipc	ra,0xffffe
    800048b8:	1a6080e7          	jalr	422(ra) # 80002a5a <iupdate>
  iunlock(ip);
    800048bc:	8526                	mv	a0,s1
    800048be:	ffffe097          	auipc	ra,0xffffe
    800048c2:	32e080e7          	jalr	814(ra) # 80002bec <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800048c6:	fd040593          	addi	a1,s0,-48
    800048ca:	f5040513          	addi	a0,s0,-176
    800048ce:	fffff097          	auipc	ra,0xfffff
    800048d2:	a62080e7          	jalr	-1438(ra) # 80003330 <nameiparent>
    800048d6:	892a                	mv	s2,a0
    800048d8:	cd35                	beqz	a0,80004954 <sys_link+0x112>
  ilock(dp);
    800048da:	ffffe097          	auipc	ra,0xffffe
    800048de:	24c080e7          	jalr	588(ra) # 80002b26 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800048e2:	00092703          	lw	a4,0(s2)
    800048e6:	409c                	lw	a5,0(s1)
    800048e8:	06f71163          	bne	a4,a5,8000494a <sys_link+0x108>
    800048ec:	40d0                	lw	a2,4(s1)
    800048ee:	fd040593          	addi	a1,s0,-48
    800048f2:	854a                	mv	a0,s2
    800048f4:	fffff097          	auipc	ra,0xfffff
    800048f8:	948080e7          	jalr	-1720(ra) # 8000323c <dirlink>
    800048fc:	04054763          	bltz	a0,8000494a <sys_link+0x108>
  iunlockput(dp);
    80004900:	854a                	mv	a0,s2
    80004902:	ffffe097          	auipc	ra,0xffffe
    80004906:	48a080e7          	jalr	1162(ra) # 80002d8c <iunlockput>
  iput(ip);
    8000490a:	8526                	mv	a0,s1
    8000490c:	ffffe097          	auipc	ra,0xffffe
    80004910:	3d8080e7          	jalr	984(ra) # 80002ce4 <iput>
  end_op();
    80004914:	fffff097          	auipc	ra,0xfffff
    80004918:	c7e080e7          	jalr	-898(ra) # 80003592 <end_op>
  return 0;
    8000491c:	4781                	li	a5,0
    8000491e:	64f2                	ld	s1,280(sp)
    80004920:	6952                	ld	s2,272(sp)
    80004922:	a0a5                	j	8000498a <sys_link+0x148>
    end_op();
    80004924:	fffff097          	auipc	ra,0xfffff
    80004928:	c6e080e7          	jalr	-914(ra) # 80003592 <end_op>
    return -1;
    8000492c:	57fd                	li	a5,-1
    8000492e:	64f2                	ld	s1,280(sp)
    80004930:	a8a9                	j	8000498a <sys_link+0x148>
    iunlockput(ip);
    80004932:	8526                	mv	a0,s1
    80004934:	ffffe097          	auipc	ra,0xffffe
    80004938:	458080e7          	jalr	1112(ra) # 80002d8c <iunlockput>
    end_op();
    8000493c:	fffff097          	auipc	ra,0xfffff
    80004940:	c56080e7          	jalr	-938(ra) # 80003592 <end_op>
    return -1;
    80004944:	57fd                	li	a5,-1
    80004946:	64f2                	ld	s1,280(sp)
    80004948:	a089                	j	8000498a <sys_link+0x148>
    iunlockput(dp);
    8000494a:	854a                	mv	a0,s2
    8000494c:	ffffe097          	auipc	ra,0xffffe
    80004950:	440080e7          	jalr	1088(ra) # 80002d8c <iunlockput>
  ilock(ip);
    80004954:	8526                	mv	a0,s1
    80004956:	ffffe097          	auipc	ra,0xffffe
    8000495a:	1d0080e7          	jalr	464(ra) # 80002b26 <ilock>
  ip->nlink--;
    8000495e:	04a4d783          	lhu	a5,74(s1)
    80004962:	37fd                	addiw	a5,a5,-1
    80004964:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004968:	8526                	mv	a0,s1
    8000496a:	ffffe097          	auipc	ra,0xffffe
    8000496e:	0f0080e7          	jalr	240(ra) # 80002a5a <iupdate>
  iunlockput(ip);
    80004972:	8526                	mv	a0,s1
    80004974:	ffffe097          	auipc	ra,0xffffe
    80004978:	418080e7          	jalr	1048(ra) # 80002d8c <iunlockput>
  end_op();
    8000497c:	fffff097          	auipc	ra,0xfffff
    80004980:	c16080e7          	jalr	-1002(ra) # 80003592 <end_op>
  return -1;
    80004984:	57fd                	li	a5,-1
    80004986:	64f2                	ld	s1,280(sp)
    80004988:	6952                	ld	s2,272(sp)
}
    8000498a:	853e                	mv	a0,a5
    8000498c:	70b2                	ld	ra,296(sp)
    8000498e:	7412                	ld	s0,288(sp)
    80004990:	6155                	addi	sp,sp,304
    80004992:	8082                	ret

0000000080004994 <sys_unlink>:
{
    80004994:	7111                	addi	sp,sp,-256
    80004996:	fd86                	sd	ra,248(sp)
    80004998:	f9a2                	sd	s0,240(sp)
    8000499a:	0200                	addi	s0,sp,256
  if(argstr(0, path, MAXPATH) < 0)
    8000499c:	08000613          	li	a2,128
    800049a0:	f2040593          	addi	a1,s0,-224
    800049a4:	4501                	li	a0,0
    800049a6:	ffffd097          	auipc	ra,0xffffd
    800049aa:	670080e7          	jalr	1648(ra) # 80002016 <argstr>
    800049ae:	1c054063          	bltz	a0,80004b6e <sys_unlink+0x1da>
    800049b2:	f5a6                	sd	s1,232(sp)
  begin_op();
    800049b4:	fffff097          	auipc	ra,0xfffff
    800049b8:	b64080e7          	jalr	-1180(ra) # 80003518 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800049bc:	fa040593          	addi	a1,s0,-96
    800049c0:	f2040513          	addi	a0,s0,-224
    800049c4:	fffff097          	auipc	ra,0xfffff
    800049c8:	96c080e7          	jalr	-1684(ra) # 80003330 <nameiparent>
    800049cc:	84aa                	mv	s1,a0
    800049ce:	c165                	beqz	a0,80004aae <sys_unlink+0x11a>
  ilock(dp);
    800049d0:	ffffe097          	auipc	ra,0xffffe
    800049d4:	156080e7          	jalr	342(ra) # 80002b26 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800049d8:	00004597          	auipc	a1,0x4
    800049dc:	ba858593          	addi	a1,a1,-1112 # 80008580 <etext+0x580>
    800049e0:	fa040513          	addi	a0,s0,-96
    800049e4:	ffffe097          	auipc	ra,0xffffe
    800049e8:	618080e7          	jalr	1560(ra) # 80002ffc <namecmp>
    800049ec:	16050263          	beqz	a0,80004b50 <sys_unlink+0x1bc>
    800049f0:	00004597          	auipc	a1,0x4
    800049f4:	b9858593          	addi	a1,a1,-1128 # 80008588 <etext+0x588>
    800049f8:	fa040513          	addi	a0,s0,-96
    800049fc:	ffffe097          	auipc	ra,0xffffe
    80004a00:	600080e7          	jalr	1536(ra) # 80002ffc <namecmp>
    80004a04:	14050663          	beqz	a0,80004b50 <sys_unlink+0x1bc>
    80004a08:	f1ca                	sd	s2,224(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004a0a:	f1c40613          	addi	a2,s0,-228
    80004a0e:	fa040593          	addi	a1,s0,-96
    80004a12:	8526                	mv	a0,s1
    80004a14:	ffffe097          	auipc	ra,0xffffe
    80004a18:	602080e7          	jalr	1538(ra) # 80003016 <dirlookup>
    80004a1c:	892a                	mv	s2,a0
    80004a1e:	12050863          	beqz	a0,80004b4e <sys_unlink+0x1ba>
    80004a22:	edce                	sd	s3,216(sp)
  ilock(ip);
    80004a24:	ffffe097          	auipc	ra,0xffffe
    80004a28:	102080e7          	jalr	258(ra) # 80002b26 <ilock>
  if(ip->nlink < 1)
    80004a2c:	04a91783          	lh	a5,74(s2)
    80004a30:	08f05663          	blez	a5,80004abc <sys_unlink+0x128>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004a34:	04491703          	lh	a4,68(s2)
    80004a38:	4785                	li	a5,1
    80004a3a:	08f70b63          	beq	a4,a5,80004ad0 <sys_unlink+0x13c>
  memset(&de, 0, sizeof(de));
    80004a3e:	fb040993          	addi	s3,s0,-80
    80004a42:	4641                	li	a2,16
    80004a44:	4581                	li	a1,0
    80004a46:	854e                	mv	a0,s3
    80004a48:	ffffb097          	auipc	ra,0xffffb
    80004a4c:	732080e7          	jalr	1842(ra) # 8000017a <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a50:	4741                	li	a4,16
    80004a52:	f1c42683          	lw	a3,-228(s0)
    80004a56:	864e                	mv	a2,s3
    80004a58:	4581                	li	a1,0
    80004a5a:	8526                	mv	a0,s1
    80004a5c:	ffffe097          	auipc	ra,0xffffe
    80004a60:	480080e7          	jalr	1152(ra) # 80002edc <writei>
    80004a64:	47c1                	li	a5,16
    80004a66:	0af51f63          	bne	a0,a5,80004b24 <sys_unlink+0x190>
  if(ip->type == T_DIR){
    80004a6a:	04491703          	lh	a4,68(s2)
    80004a6e:	4785                	li	a5,1
    80004a70:	0cf70463          	beq	a4,a5,80004b38 <sys_unlink+0x1a4>
  iunlockput(dp);
    80004a74:	8526                	mv	a0,s1
    80004a76:	ffffe097          	auipc	ra,0xffffe
    80004a7a:	316080e7          	jalr	790(ra) # 80002d8c <iunlockput>
  ip->nlink--;
    80004a7e:	04a95783          	lhu	a5,74(s2)
    80004a82:	37fd                	addiw	a5,a5,-1
    80004a84:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004a88:	854a                	mv	a0,s2
    80004a8a:	ffffe097          	auipc	ra,0xffffe
    80004a8e:	fd0080e7          	jalr	-48(ra) # 80002a5a <iupdate>
  iunlockput(ip);
    80004a92:	854a                	mv	a0,s2
    80004a94:	ffffe097          	auipc	ra,0xffffe
    80004a98:	2f8080e7          	jalr	760(ra) # 80002d8c <iunlockput>
  end_op();
    80004a9c:	fffff097          	auipc	ra,0xfffff
    80004aa0:	af6080e7          	jalr	-1290(ra) # 80003592 <end_op>
  return 0;
    80004aa4:	4501                	li	a0,0
    80004aa6:	74ae                	ld	s1,232(sp)
    80004aa8:	790e                	ld	s2,224(sp)
    80004aaa:	69ee                	ld	s3,216(sp)
    80004aac:	a86d                	j	80004b66 <sys_unlink+0x1d2>
    end_op();
    80004aae:	fffff097          	auipc	ra,0xfffff
    80004ab2:	ae4080e7          	jalr	-1308(ra) # 80003592 <end_op>
    return -1;
    80004ab6:	557d                	li	a0,-1
    80004ab8:	74ae                	ld	s1,232(sp)
    80004aba:	a075                	j	80004b66 <sys_unlink+0x1d2>
    80004abc:	e9d2                	sd	s4,208(sp)
    80004abe:	e5d6                	sd	s5,200(sp)
    panic("unlink: nlink < 1");
    80004ac0:	00004517          	auipc	a0,0x4
    80004ac4:	af050513          	addi	a0,a0,-1296 # 800085b0 <etext+0x5b0>
    80004ac8:	00001097          	auipc	ra,0x1
    80004acc:	21a080e7          	jalr	538(ra) # 80005ce2 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004ad0:	04c92703          	lw	a4,76(s2)
    80004ad4:	02000793          	li	a5,32
    80004ad8:	f6e7f3e3          	bgeu	a5,a4,80004a3e <sys_unlink+0xaa>
    80004adc:	e9d2                	sd	s4,208(sp)
    80004ade:	e5d6                	sd	s5,200(sp)
    80004ae0:	89be                	mv	s3,a5
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004ae2:	f0840a93          	addi	s5,s0,-248
    80004ae6:	4a41                	li	s4,16
    80004ae8:	8752                	mv	a4,s4
    80004aea:	86ce                	mv	a3,s3
    80004aec:	8656                	mv	a2,s5
    80004aee:	4581                	li	a1,0
    80004af0:	854a                	mv	a0,s2
    80004af2:	ffffe097          	auipc	ra,0xffffe
    80004af6:	2f0080e7          	jalr	752(ra) # 80002de2 <readi>
    80004afa:	01451d63          	bne	a0,s4,80004b14 <sys_unlink+0x180>
    if(de.inum != 0)
    80004afe:	f0845783          	lhu	a5,-248(s0)
    80004b02:	eba5                	bnez	a5,80004b72 <sys_unlink+0x1de>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004b04:	29c1                	addiw	s3,s3,16
    80004b06:	04c92783          	lw	a5,76(s2)
    80004b0a:	fcf9efe3          	bltu	s3,a5,80004ae8 <sys_unlink+0x154>
    80004b0e:	6a4e                	ld	s4,208(sp)
    80004b10:	6aae                	ld	s5,200(sp)
    80004b12:	b735                	j	80004a3e <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004b14:	00004517          	auipc	a0,0x4
    80004b18:	ab450513          	addi	a0,a0,-1356 # 800085c8 <etext+0x5c8>
    80004b1c:	00001097          	auipc	ra,0x1
    80004b20:	1c6080e7          	jalr	454(ra) # 80005ce2 <panic>
    80004b24:	e9d2                	sd	s4,208(sp)
    80004b26:	e5d6                	sd	s5,200(sp)
    panic("unlink: writei");
    80004b28:	00004517          	auipc	a0,0x4
    80004b2c:	ab850513          	addi	a0,a0,-1352 # 800085e0 <etext+0x5e0>
    80004b30:	00001097          	auipc	ra,0x1
    80004b34:	1b2080e7          	jalr	434(ra) # 80005ce2 <panic>
    dp->nlink--;
    80004b38:	04a4d783          	lhu	a5,74(s1)
    80004b3c:	37fd                	addiw	a5,a5,-1
    80004b3e:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004b42:	8526                	mv	a0,s1
    80004b44:	ffffe097          	auipc	ra,0xffffe
    80004b48:	f16080e7          	jalr	-234(ra) # 80002a5a <iupdate>
    80004b4c:	b725                	j	80004a74 <sys_unlink+0xe0>
    80004b4e:	790e                	ld	s2,224(sp)
  iunlockput(dp);
    80004b50:	8526                	mv	a0,s1
    80004b52:	ffffe097          	auipc	ra,0xffffe
    80004b56:	23a080e7          	jalr	570(ra) # 80002d8c <iunlockput>
  end_op();
    80004b5a:	fffff097          	auipc	ra,0xfffff
    80004b5e:	a38080e7          	jalr	-1480(ra) # 80003592 <end_op>
  return -1;
    80004b62:	557d                	li	a0,-1
    80004b64:	74ae                	ld	s1,232(sp)
}
    80004b66:	70ee                	ld	ra,248(sp)
    80004b68:	744e                	ld	s0,240(sp)
    80004b6a:	6111                	addi	sp,sp,256
    80004b6c:	8082                	ret
    return -1;
    80004b6e:	557d                	li	a0,-1
    80004b70:	bfdd                	j	80004b66 <sys_unlink+0x1d2>
    iunlockput(ip);
    80004b72:	854a                	mv	a0,s2
    80004b74:	ffffe097          	auipc	ra,0xffffe
    80004b78:	218080e7          	jalr	536(ra) # 80002d8c <iunlockput>
    goto bad;
    80004b7c:	790e                	ld	s2,224(sp)
    80004b7e:	69ee                	ld	s3,216(sp)
    80004b80:	6a4e                	ld	s4,208(sp)
    80004b82:	6aae                	ld	s5,200(sp)
    80004b84:	b7f1                	j	80004b50 <sys_unlink+0x1bc>

0000000080004b86 <sys_open>:

uint64
sys_open(void)
{
    80004b86:	7131                	addi	sp,sp,-192
    80004b88:	fd06                	sd	ra,184(sp)
    80004b8a:	f922                	sd	s0,176(sp)
    80004b8c:	f526                	sd	s1,168(sp)
    80004b8e:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004b90:	08000613          	li	a2,128
    80004b94:	f5040593          	addi	a1,s0,-176
    80004b98:	4501                	li	a0,0
    80004b9a:	ffffd097          	auipc	ra,0xffffd
    80004b9e:	47c080e7          	jalr	1148(ra) # 80002016 <argstr>
    return -1;
    80004ba2:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004ba4:	0c054563          	bltz	a0,80004c6e <sys_open+0xe8>
    80004ba8:	f4c40593          	addi	a1,s0,-180
    80004bac:	4505                	li	a0,1
    80004bae:	ffffd097          	auipc	ra,0xffffd
    80004bb2:	424080e7          	jalr	1060(ra) # 80001fd2 <argint>
    80004bb6:	0a054c63          	bltz	a0,80004c6e <sys_open+0xe8>
    80004bba:	f14a                	sd	s2,160(sp)

  begin_op();
    80004bbc:	fffff097          	auipc	ra,0xfffff
    80004bc0:	95c080e7          	jalr	-1700(ra) # 80003518 <begin_op>

  if(omode & O_CREATE){
    80004bc4:	f4c42783          	lw	a5,-180(s0)
    80004bc8:	2007f793          	andi	a5,a5,512
    80004bcc:	cfcd                	beqz	a5,80004c86 <sys_open+0x100>
    ip = create(path, T_FILE, 0, 0);
    80004bce:	4681                	li	a3,0
    80004bd0:	4601                	li	a2,0
    80004bd2:	4589                	li	a1,2
    80004bd4:	f5040513          	addi	a0,s0,-176
    80004bd8:	00000097          	auipc	ra,0x0
    80004bdc:	948080e7          	jalr	-1720(ra) # 80004520 <create>
    80004be0:	892a                	mv	s2,a0
    if(ip == 0){
    80004be2:	cd41                	beqz	a0,80004c7a <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004be4:	04491703          	lh	a4,68(s2)
    80004be8:	478d                	li	a5,3
    80004bea:	00f71763          	bne	a4,a5,80004bf8 <sys_open+0x72>
    80004bee:	04695703          	lhu	a4,70(s2)
    80004bf2:	47a5                	li	a5,9
    80004bf4:	0ee7e063          	bltu	a5,a4,80004cd4 <sys_open+0x14e>
    80004bf8:	ed4e                	sd	s3,152(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004bfa:	fffff097          	auipc	ra,0xfffff
    80004bfe:	d32080e7          	jalr	-718(ra) # 8000392c <filealloc>
    80004c02:	89aa                	mv	s3,a0
    80004c04:	c96d                	beqz	a0,80004cf6 <sys_open+0x170>
    80004c06:	00000097          	auipc	ra,0x0
    80004c0a:	8d8080e7          	jalr	-1832(ra) # 800044de <fdalloc>
    80004c0e:	84aa                	mv	s1,a0
    80004c10:	0c054e63          	bltz	a0,80004cec <sys_open+0x166>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004c14:	04491703          	lh	a4,68(s2)
    80004c18:	478d                	li	a5,3
    80004c1a:	0ef70b63          	beq	a4,a5,80004d10 <sys_open+0x18a>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004c1e:	4789                	li	a5,2
    80004c20:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004c24:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004c28:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004c2c:	f4c42783          	lw	a5,-180(s0)
    80004c30:	0017f713          	andi	a4,a5,1
    80004c34:	00174713          	xori	a4,a4,1
    80004c38:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004c3c:	0037f713          	andi	a4,a5,3
    80004c40:	00e03733          	snez	a4,a4
    80004c44:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004c48:	4007f793          	andi	a5,a5,1024
    80004c4c:	c791                	beqz	a5,80004c58 <sys_open+0xd2>
    80004c4e:	04491703          	lh	a4,68(s2)
    80004c52:	4789                	li	a5,2
    80004c54:	0cf70563          	beq	a4,a5,80004d1e <sys_open+0x198>
    itrunc(ip);
  }

  iunlock(ip);
    80004c58:	854a                	mv	a0,s2
    80004c5a:	ffffe097          	auipc	ra,0xffffe
    80004c5e:	f92080e7          	jalr	-110(ra) # 80002bec <iunlock>
  end_op();
    80004c62:	fffff097          	auipc	ra,0xfffff
    80004c66:	930080e7          	jalr	-1744(ra) # 80003592 <end_op>
    80004c6a:	790a                	ld	s2,160(sp)
    80004c6c:	69ea                	ld	s3,152(sp)

  return fd;
}
    80004c6e:	8526                	mv	a0,s1
    80004c70:	70ea                	ld	ra,184(sp)
    80004c72:	744a                	ld	s0,176(sp)
    80004c74:	74aa                	ld	s1,168(sp)
    80004c76:	6129                	addi	sp,sp,192
    80004c78:	8082                	ret
      end_op();
    80004c7a:	fffff097          	auipc	ra,0xfffff
    80004c7e:	918080e7          	jalr	-1768(ra) # 80003592 <end_op>
      return -1;
    80004c82:	790a                	ld	s2,160(sp)
    80004c84:	b7ed                	j	80004c6e <sys_open+0xe8>
    if((ip = namei(path)) == 0){
    80004c86:	f5040513          	addi	a0,s0,-176
    80004c8a:	ffffe097          	auipc	ra,0xffffe
    80004c8e:	688080e7          	jalr	1672(ra) # 80003312 <namei>
    80004c92:	892a                	mv	s2,a0
    80004c94:	c90d                	beqz	a0,80004cc6 <sys_open+0x140>
    ilock(ip);
    80004c96:	ffffe097          	auipc	ra,0xffffe
    80004c9a:	e90080e7          	jalr	-368(ra) # 80002b26 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004c9e:	04491703          	lh	a4,68(s2)
    80004ca2:	4785                	li	a5,1
    80004ca4:	f4f710e3          	bne	a4,a5,80004be4 <sys_open+0x5e>
    80004ca8:	f4c42783          	lw	a5,-180(s0)
    80004cac:	d7b1                	beqz	a5,80004bf8 <sys_open+0x72>
      iunlockput(ip);
    80004cae:	854a                	mv	a0,s2
    80004cb0:	ffffe097          	auipc	ra,0xffffe
    80004cb4:	0dc080e7          	jalr	220(ra) # 80002d8c <iunlockput>
      end_op();
    80004cb8:	fffff097          	auipc	ra,0xfffff
    80004cbc:	8da080e7          	jalr	-1830(ra) # 80003592 <end_op>
      return -1;
    80004cc0:	54fd                	li	s1,-1
    80004cc2:	790a                	ld	s2,160(sp)
    80004cc4:	b76d                	j	80004c6e <sys_open+0xe8>
      end_op();
    80004cc6:	fffff097          	auipc	ra,0xfffff
    80004cca:	8cc080e7          	jalr	-1844(ra) # 80003592 <end_op>
      return -1;
    80004cce:	54fd                	li	s1,-1
    80004cd0:	790a                	ld	s2,160(sp)
    80004cd2:	bf71                	j	80004c6e <sys_open+0xe8>
    iunlockput(ip);
    80004cd4:	854a                	mv	a0,s2
    80004cd6:	ffffe097          	auipc	ra,0xffffe
    80004cda:	0b6080e7          	jalr	182(ra) # 80002d8c <iunlockput>
    end_op();
    80004cde:	fffff097          	auipc	ra,0xfffff
    80004ce2:	8b4080e7          	jalr	-1868(ra) # 80003592 <end_op>
    return -1;
    80004ce6:	54fd                	li	s1,-1
    80004ce8:	790a                	ld	s2,160(sp)
    80004cea:	b751                	j	80004c6e <sys_open+0xe8>
      fileclose(f);
    80004cec:	854e                	mv	a0,s3
    80004cee:	fffff097          	auipc	ra,0xfffff
    80004cf2:	cfa080e7          	jalr	-774(ra) # 800039e8 <fileclose>
    iunlockput(ip);
    80004cf6:	854a                	mv	a0,s2
    80004cf8:	ffffe097          	auipc	ra,0xffffe
    80004cfc:	094080e7          	jalr	148(ra) # 80002d8c <iunlockput>
    end_op();
    80004d00:	fffff097          	auipc	ra,0xfffff
    80004d04:	892080e7          	jalr	-1902(ra) # 80003592 <end_op>
    return -1;
    80004d08:	54fd                	li	s1,-1
    80004d0a:	790a                	ld	s2,160(sp)
    80004d0c:	69ea                	ld	s3,152(sp)
    80004d0e:	b785                	j	80004c6e <sys_open+0xe8>
    f->type = FD_DEVICE;
    80004d10:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004d14:	04691783          	lh	a5,70(s2)
    80004d18:	02f99223          	sh	a5,36(s3)
    80004d1c:	b731                	j	80004c28 <sys_open+0xa2>
    itrunc(ip);
    80004d1e:	854a                	mv	a0,s2
    80004d20:	ffffe097          	auipc	ra,0xffffe
    80004d24:	f18080e7          	jalr	-232(ra) # 80002c38 <itrunc>
    80004d28:	bf05                	j	80004c58 <sys_open+0xd2>

0000000080004d2a <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004d2a:	7175                	addi	sp,sp,-144
    80004d2c:	e506                	sd	ra,136(sp)
    80004d2e:	e122                	sd	s0,128(sp)
    80004d30:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004d32:	ffffe097          	auipc	ra,0xffffe
    80004d36:	7e6080e7          	jalr	2022(ra) # 80003518 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004d3a:	08000613          	li	a2,128
    80004d3e:	f7040593          	addi	a1,s0,-144
    80004d42:	4501                	li	a0,0
    80004d44:	ffffd097          	auipc	ra,0xffffd
    80004d48:	2d2080e7          	jalr	722(ra) # 80002016 <argstr>
    80004d4c:	02054963          	bltz	a0,80004d7e <sys_mkdir+0x54>
    80004d50:	4681                	li	a3,0
    80004d52:	4601                	li	a2,0
    80004d54:	4585                	li	a1,1
    80004d56:	f7040513          	addi	a0,s0,-144
    80004d5a:	fffff097          	auipc	ra,0xfffff
    80004d5e:	7c6080e7          	jalr	1990(ra) # 80004520 <create>
    80004d62:	cd11                	beqz	a0,80004d7e <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004d64:	ffffe097          	auipc	ra,0xffffe
    80004d68:	028080e7          	jalr	40(ra) # 80002d8c <iunlockput>
  end_op();
    80004d6c:	fffff097          	auipc	ra,0xfffff
    80004d70:	826080e7          	jalr	-2010(ra) # 80003592 <end_op>
  return 0;
    80004d74:	4501                	li	a0,0
}
    80004d76:	60aa                	ld	ra,136(sp)
    80004d78:	640a                	ld	s0,128(sp)
    80004d7a:	6149                	addi	sp,sp,144
    80004d7c:	8082                	ret
    end_op();
    80004d7e:	fffff097          	auipc	ra,0xfffff
    80004d82:	814080e7          	jalr	-2028(ra) # 80003592 <end_op>
    return -1;
    80004d86:	557d                	li	a0,-1
    80004d88:	b7fd                	j	80004d76 <sys_mkdir+0x4c>

0000000080004d8a <sys_mknod>:

uint64
sys_mknod(void)
{
    80004d8a:	7135                	addi	sp,sp,-160
    80004d8c:	ed06                	sd	ra,152(sp)
    80004d8e:	e922                	sd	s0,144(sp)
    80004d90:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004d92:	ffffe097          	auipc	ra,0xffffe
    80004d96:	786080e7          	jalr	1926(ra) # 80003518 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d9a:	08000613          	li	a2,128
    80004d9e:	f7040593          	addi	a1,s0,-144
    80004da2:	4501                	li	a0,0
    80004da4:	ffffd097          	auipc	ra,0xffffd
    80004da8:	272080e7          	jalr	626(ra) # 80002016 <argstr>
    80004dac:	04054a63          	bltz	a0,80004e00 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004db0:	f6c40593          	addi	a1,s0,-148
    80004db4:	4505                	li	a0,1
    80004db6:	ffffd097          	auipc	ra,0xffffd
    80004dba:	21c080e7          	jalr	540(ra) # 80001fd2 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004dbe:	04054163          	bltz	a0,80004e00 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004dc2:	f6840593          	addi	a1,s0,-152
    80004dc6:	4509                	li	a0,2
    80004dc8:	ffffd097          	auipc	ra,0xffffd
    80004dcc:	20a080e7          	jalr	522(ra) # 80001fd2 <argint>
     argint(1, &major) < 0 ||
    80004dd0:	02054863          	bltz	a0,80004e00 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004dd4:	f6841683          	lh	a3,-152(s0)
    80004dd8:	f6c41603          	lh	a2,-148(s0)
    80004ddc:	458d                	li	a1,3
    80004dde:	f7040513          	addi	a0,s0,-144
    80004de2:	fffff097          	auipc	ra,0xfffff
    80004de6:	73e080e7          	jalr	1854(ra) # 80004520 <create>
     argint(2, &minor) < 0 ||
    80004dea:	c919                	beqz	a0,80004e00 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004dec:	ffffe097          	auipc	ra,0xffffe
    80004df0:	fa0080e7          	jalr	-96(ra) # 80002d8c <iunlockput>
  end_op();
    80004df4:	ffffe097          	auipc	ra,0xffffe
    80004df8:	79e080e7          	jalr	1950(ra) # 80003592 <end_op>
  return 0;
    80004dfc:	4501                	li	a0,0
    80004dfe:	a031                	j	80004e0a <sys_mknod+0x80>
    end_op();
    80004e00:	ffffe097          	auipc	ra,0xffffe
    80004e04:	792080e7          	jalr	1938(ra) # 80003592 <end_op>
    return -1;
    80004e08:	557d                	li	a0,-1
}
    80004e0a:	60ea                	ld	ra,152(sp)
    80004e0c:	644a                	ld	s0,144(sp)
    80004e0e:	610d                	addi	sp,sp,160
    80004e10:	8082                	ret

0000000080004e12 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004e12:	7135                	addi	sp,sp,-160
    80004e14:	ed06                	sd	ra,152(sp)
    80004e16:	e922                	sd	s0,144(sp)
    80004e18:	e14a                	sd	s2,128(sp)
    80004e1a:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004e1c:	ffffc097          	auipc	ra,0xffffc
    80004e20:	058080e7          	jalr	88(ra) # 80000e74 <myproc>
    80004e24:	892a                	mv	s2,a0
  
  begin_op();
    80004e26:	ffffe097          	auipc	ra,0xffffe
    80004e2a:	6f2080e7          	jalr	1778(ra) # 80003518 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004e2e:	08000613          	li	a2,128
    80004e32:	f6040593          	addi	a1,s0,-160
    80004e36:	4501                	li	a0,0
    80004e38:	ffffd097          	auipc	ra,0xffffd
    80004e3c:	1de080e7          	jalr	478(ra) # 80002016 <argstr>
    80004e40:	04054d63          	bltz	a0,80004e9a <sys_chdir+0x88>
    80004e44:	e526                	sd	s1,136(sp)
    80004e46:	f6040513          	addi	a0,s0,-160
    80004e4a:	ffffe097          	auipc	ra,0xffffe
    80004e4e:	4c8080e7          	jalr	1224(ra) # 80003312 <namei>
    80004e52:	84aa                	mv	s1,a0
    80004e54:	c131                	beqz	a0,80004e98 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004e56:	ffffe097          	auipc	ra,0xffffe
    80004e5a:	cd0080e7          	jalr	-816(ra) # 80002b26 <ilock>
  if(ip->type != T_DIR){
    80004e5e:	04449703          	lh	a4,68(s1)
    80004e62:	4785                	li	a5,1
    80004e64:	04f71163          	bne	a4,a5,80004ea6 <sys_chdir+0x94>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004e68:	8526                	mv	a0,s1
    80004e6a:	ffffe097          	auipc	ra,0xffffe
    80004e6e:	d82080e7          	jalr	-638(ra) # 80002bec <iunlock>
  iput(p->cwd);
    80004e72:	15093503          	ld	a0,336(s2)
    80004e76:	ffffe097          	auipc	ra,0xffffe
    80004e7a:	e6e080e7          	jalr	-402(ra) # 80002ce4 <iput>
  end_op();
    80004e7e:	ffffe097          	auipc	ra,0xffffe
    80004e82:	714080e7          	jalr	1812(ra) # 80003592 <end_op>
  p->cwd = ip;
    80004e86:	14993823          	sd	s1,336(s2)
  return 0;
    80004e8a:	4501                	li	a0,0
    80004e8c:	64aa                	ld	s1,136(sp)
}
    80004e8e:	60ea                	ld	ra,152(sp)
    80004e90:	644a                	ld	s0,144(sp)
    80004e92:	690a                	ld	s2,128(sp)
    80004e94:	610d                	addi	sp,sp,160
    80004e96:	8082                	ret
    80004e98:	64aa                	ld	s1,136(sp)
    end_op();
    80004e9a:	ffffe097          	auipc	ra,0xffffe
    80004e9e:	6f8080e7          	jalr	1784(ra) # 80003592 <end_op>
    return -1;
    80004ea2:	557d                	li	a0,-1
    80004ea4:	b7ed                	j	80004e8e <sys_chdir+0x7c>
    iunlockput(ip);
    80004ea6:	8526                	mv	a0,s1
    80004ea8:	ffffe097          	auipc	ra,0xffffe
    80004eac:	ee4080e7          	jalr	-284(ra) # 80002d8c <iunlockput>
    end_op();
    80004eb0:	ffffe097          	auipc	ra,0xffffe
    80004eb4:	6e2080e7          	jalr	1762(ra) # 80003592 <end_op>
    return -1;
    80004eb8:	557d                	li	a0,-1
    80004eba:	64aa                	ld	s1,136(sp)
    80004ebc:	bfc9                	j	80004e8e <sys_chdir+0x7c>

0000000080004ebe <sys_exec>:

uint64
sys_exec(void)
{
    80004ebe:	7105                	addi	sp,sp,-480
    80004ec0:	ef86                	sd	ra,472(sp)
    80004ec2:	eba2                	sd	s0,464(sp)
    80004ec4:	e3ca                	sd	s2,448(sp)
    80004ec6:	1380                	addi	s0,sp,480
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004ec8:	08000613          	li	a2,128
    80004ecc:	f3040593          	addi	a1,s0,-208
    80004ed0:	4501                	li	a0,0
    80004ed2:	ffffd097          	auipc	ra,0xffffd
    80004ed6:	144080e7          	jalr	324(ra) # 80002016 <argstr>
    return -1;
    80004eda:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004edc:	10054963          	bltz	a0,80004fee <sys_exec+0x130>
    80004ee0:	e2840593          	addi	a1,s0,-472
    80004ee4:	4505                	li	a0,1
    80004ee6:	ffffd097          	auipc	ra,0xffffd
    80004eea:	10e080e7          	jalr	270(ra) # 80001ff4 <argaddr>
    80004eee:	10054063          	bltz	a0,80004fee <sys_exec+0x130>
    80004ef2:	e7a6                	sd	s1,456(sp)
    80004ef4:	ff4e                	sd	s3,440(sp)
    80004ef6:	fb52                	sd	s4,432(sp)
    80004ef8:	f756                	sd	s5,424(sp)
    80004efa:	f35a                	sd	s6,416(sp)
    80004efc:	ef5e                	sd	s7,408(sp)
  }
  memset(argv, 0, sizeof(argv));
    80004efe:	e3040a13          	addi	s4,s0,-464
    80004f02:	10000613          	li	a2,256
    80004f06:	4581                	li	a1,0
    80004f08:	8552                	mv	a0,s4
    80004f0a:	ffffb097          	auipc	ra,0xffffb
    80004f0e:	270080e7          	jalr	624(ra) # 8000017a <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004f12:	84d2                	mv	s1,s4
  memset(argv, 0, sizeof(argv));
    80004f14:	89d2                	mv	s3,s4
    80004f16:	4901                	li	s2,0
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004f18:	e2040a93          	addi	s5,s0,-480
      break;
    }
    argv[i] = kalloc();
    if(argv[i] == 0)
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004f1c:	6b05                	lui	s6,0x1
    if(i >= NELEM(argv)){
    80004f1e:	02000b93          	li	s7,32
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004f22:	00391513          	slli	a0,s2,0x3
    80004f26:	85d6                	mv	a1,s5
    80004f28:	e2843783          	ld	a5,-472(s0)
    80004f2c:	953e                	add	a0,a0,a5
    80004f2e:	ffffd097          	auipc	ra,0xffffd
    80004f32:	00a080e7          	jalr	10(ra) # 80001f38 <fetchaddr>
    80004f36:	02054a63          	bltz	a0,80004f6a <sys_exec+0xac>
    if(uarg == 0){
    80004f3a:	e2043783          	ld	a5,-480(s0)
    80004f3e:	cba9                	beqz	a5,80004f90 <sys_exec+0xd2>
    argv[i] = kalloc();
    80004f40:	ffffb097          	auipc	ra,0xffffb
    80004f44:	1da080e7          	jalr	474(ra) # 8000011a <kalloc>
    80004f48:	85aa                	mv	a1,a0
    80004f4a:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004f4e:	cd11                	beqz	a0,80004f6a <sys_exec+0xac>
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004f50:	865a                	mv	a2,s6
    80004f52:	e2043503          	ld	a0,-480(s0)
    80004f56:	ffffd097          	auipc	ra,0xffffd
    80004f5a:	034080e7          	jalr	52(ra) # 80001f8a <fetchstr>
    80004f5e:	00054663          	bltz	a0,80004f6a <sys_exec+0xac>
    if(i >= NELEM(argv)){
    80004f62:	0905                	addi	s2,s2,1
    80004f64:	09a1                	addi	s3,s3,8
    80004f66:	fb791ee3          	bne	s2,s7,80004f22 <sys_exec+0x64>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f6a:	100a0a13          	addi	s4,s4,256
    80004f6e:	6088                	ld	a0,0(s1)
    80004f70:	c925                	beqz	a0,80004fe0 <sys_exec+0x122>
    kfree(argv[i]);
    80004f72:	ffffb097          	auipc	ra,0xffffb
    80004f76:	0aa080e7          	jalr	170(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f7a:	04a1                	addi	s1,s1,8
    80004f7c:	ff4499e3          	bne	s1,s4,80004f6e <sys_exec+0xb0>
  return -1;
    80004f80:	597d                	li	s2,-1
    80004f82:	64be                	ld	s1,456(sp)
    80004f84:	79fa                	ld	s3,440(sp)
    80004f86:	7a5a                	ld	s4,432(sp)
    80004f88:	7aba                	ld	s5,424(sp)
    80004f8a:	7b1a                	ld	s6,416(sp)
    80004f8c:	6bfa                	ld	s7,408(sp)
    80004f8e:	a085                	j	80004fee <sys_exec+0x130>
      argv[i] = 0;
    80004f90:	0009079b          	sext.w	a5,s2
    80004f94:	e3040593          	addi	a1,s0,-464
    80004f98:	078e                	slli	a5,a5,0x3
    80004f9a:	97ae                	add	a5,a5,a1
    80004f9c:	0007b023          	sd	zero,0(a5)
  int ret = exec(path, argv);
    80004fa0:	f3040513          	addi	a0,s0,-208
    80004fa4:	fffff097          	auipc	ra,0xfffff
    80004fa8:	122080e7          	jalr	290(ra) # 800040c6 <exec>
    80004fac:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004fae:	100a0a13          	addi	s4,s4,256
    80004fb2:	6088                	ld	a0,0(s1)
    80004fb4:	cd19                	beqz	a0,80004fd2 <sys_exec+0x114>
    kfree(argv[i]);
    80004fb6:	ffffb097          	auipc	ra,0xffffb
    80004fba:	066080e7          	jalr	102(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004fbe:	04a1                	addi	s1,s1,8
    80004fc0:	ff4499e3          	bne	s1,s4,80004fb2 <sys_exec+0xf4>
    80004fc4:	64be                	ld	s1,456(sp)
    80004fc6:	79fa                	ld	s3,440(sp)
    80004fc8:	7a5a                	ld	s4,432(sp)
    80004fca:	7aba                	ld	s5,424(sp)
    80004fcc:	7b1a                	ld	s6,416(sp)
    80004fce:	6bfa                	ld	s7,408(sp)
    80004fd0:	a839                	j	80004fee <sys_exec+0x130>
  return ret;
    80004fd2:	64be                	ld	s1,456(sp)
    80004fd4:	79fa                	ld	s3,440(sp)
    80004fd6:	7a5a                	ld	s4,432(sp)
    80004fd8:	7aba                	ld	s5,424(sp)
    80004fda:	7b1a                	ld	s6,416(sp)
    80004fdc:	6bfa                	ld	s7,408(sp)
    80004fde:	a801                	j	80004fee <sys_exec+0x130>
  return -1;
    80004fe0:	597d                	li	s2,-1
    80004fe2:	64be                	ld	s1,456(sp)
    80004fe4:	79fa                	ld	s3,440(sp)
    80004fe6:	7a5a                	ld	s4,432(sp)
    80004fe8:	7aba                	ld	s5,424(sp)
    80004fea:	7b1a                	ld	s6,416(sp)
    80004fec:	6bfa                	ld	s7,408(sp)
}
    80004fee:	854a                	mv	a0,s2
    80004ff0:	60fe                	ld	ra,472(sp)
    80004ff2:	645e                	ld	s0,464(sp)
    80004ff4:	691e                	ld	s2,448(sp)
    80004ff6:	613d                	addi	sp,sp,480
    80004ff8:	8082                	ret

0000000080004ffa <sys_pipe>:

uint64
sys_pipe(void)
{
    80004ffa:	7139                	addi	sp,sp,-64
    80004ffc:	fc06                	sd	ra,56(sp)
    80004ffe:	f822                	sd	s0,48(sp)
    80005000:	f426                	sd	s1,40(sp)
    80005002:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005004:	ffffc097          	auipc	ra,0xffffc
    80005008:	e70080e7          	jalr	-400(ra) # 80000e74 <myproc>
    8000500c:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    8000500e:	fd840593          	addi	a1,s0,-40
    80005012:	4501                	li	a0,0
    80005014:	ffffd097          	auipc	ra,0xffffd
    80005018:	fe0080e7          	jalr	-32(ra) # 80001ff4 <argaddr>
    return -1;
    8000501c:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    8000501e:	0e054063          	bltz	a0,800050fe <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80005022:	fc840593          	addi	a1,s0,-56
    80005026:	fd040513          	addi	a0,s0,-48
    8000502a:	fffff097          	auipc	ra,0xfffff
    8000502e:	d32080e7          	jalr	-718(ra) # 80003d5c <pipealloc>
    return -1;
    80005032:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005034:	0c054563          	bltz	a0,800050fe <sys_pipe+0x104>
  fd0 = -1;
    80005038:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    8000503c:	fd043503          	ld	a0,-48(s0)
    80005040:	fffff097          	auipc	ra,0xfffff
    80005044:	49e080e7          	jalr	1182(ra) # 800044de <fdalloc>
    80005048:	fca42223          	sw	a0,-60(s0)
    8000504c:	08054c63          	bltz	a0,800050e4 <sys_pipe+0xea>
    80005050:	fc843503          	ld	a0,-56(s0)
    80005054:	fffff097          	auipc	ra,0xfffff
    80005058:	48a080e7          	jalr	1162(ra) # 800044de <fdalloc>
    8000505c:	fca42023          	sw	a0,-64(s0)
    80005060:	06054963          	bltz	a0,800050d2 <sys_pipe+0xd8>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005064:	4691                	li	a3,4
    80005066:	fc440613          	addi	a2,s0,-60
    8000506a:	fd843583          	ld	a1,-40(s0)
    8000506e:	68a8                	ld	a0,80(s1)
    80005070:	ffffc097          	auipc	ra,0xffffc
    80005074:	ab0080e7          	jalr	-1360(ra) # 80000b20 <copyout>
    80005078:	02054063          	bltz	a0,80005098 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    8000507c:	4691                	li	a3,4
    8000507e:	fc040613          	addi	a2,s0,-64
    80005082:	fd843583          	ld	a1,-40(s0)
    80005086:	95b6                	add	a1,a1,a3
    80005088:	68a8                	ld	a0,80(s1)
    8000508a:	ffffc097          	auipc	ra,0xffffc
    8000508e:	a96080e7          	jalr	-1386(ra) # 80000b20 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005092:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005094:	06055563          	bgez	a0,800050fe <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005098:	fc442783          	lw	a5,-60(s0)
    8000509c:	07e9                	addi	a5,a5,26
    8000509e:	078e                	slli	a5,a5,0x3
    800050a0:	97a6                	add	a5,a5,s1
    800050a2:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800050a6:	fc042783          	lw	a5,-64(s0)
    800050aa:	07e9                	addi	a5,a5,26
    800050ac:	078e                	slli	a5,a5,0x3
    800050ae:	00f48533          	add	a0,s1,a5
    800050b2:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    800050b6:	fd043503          	ld	a0,-48(s0)
    800050ba:	fffff097          	auipc	ra,0xfffff
    800050be:	92e080e7          	jalr	-1746(ra) # 800039e8 <fileclose>
    fileclose(wf);
    800050c2:	fc843503          	ld	a0,-56(s0)
    800050c6:	fffff097          	auipc	ra,0xfffff
    800050ca:	922080e7          	jalr	-1758(ra) # 800039e8 <fileclose>
    return -1;
    800050ce:	57fd                	li	a5,-1
    800050d0:	a03d                	j	800050fe <sys_pipe+0x104>
    if(fd0 >= 0)
    800050d2:	fc442783          	lw	a5,-60(s0)
    800050d6:	0007c763          	bltz	a5,800050e4 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    800050da:	07e9                	addi	a5,a5,26
    800050dc:	078e                	slli	a5,a5,0x3
    800050de:	97a6                	add	a5,a5,s1
    800050e0:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    800050e4:	fd043503          	ld	a0,-48(s0)
    800050e8:	fffff097          	auipc	ra,0xfffff
    800050ec:	900080e7          	jalr	-1792(ra) # 800039e8 <fileclose>
    fileclose(wf);
    800050f0:	fc843503          	ld	a0,-56(s0)
    800050f4:	fffff097          	auipc	ra,0xfffff
    800050f8:	8f4080e7          	jalr	-1804(ra) # 800039e8 <fileclose>
    return -1;
    800050fc:	57fd                	li	a5,-1
}
    800050fe:	853e                	mv	a0,a5
    80005100:	70e2                	ld	ra,56(sp)
    80005102:	7442                	ld	s0,48(sp)
    80005104:	74a2                	ld	s1,40(sp)
    80005106:	6121                	addi	sp,sp,64
    80005108:	8082                	ret
    8000510a:	0000                	unimp
    8000510c:	0000                	unimp
	...

0000000080005110 <kernelvec>:
    80005110:	7111                	addi	sp,sp,-256
    80005112:	e006                	sd	ra,0(sp)
    80005114:	e40a                	sd	sp,8(sp)
    80005116:	e80e                	sd	gp,16(sp)
    80005118:	ec12                	sd	tp,24(sp)
    8000511a:	f016                	sd	t0,32(sp)
    8000511c:	f41a                	sd	t1,40(sp)
    8000511e:	f81e                	sd	t2,48(sp)
    80005120:	fc22                	sd	s0,56(sp)
    80005122:	e0a6                	sd	s1,64(sp)
    80005124:	e4aa                	sd	a0,72(sp)
    80005126:	e8ae                	sd	a1,80(sp)
    80005128:	ecb2                	sd	a2,88(sp)
    8000512a:	f0b6                	sd	a3,96(sp)
    8000512c:	f4ba                	sd	a4,104(sp)
    8000512e:	f8be                	sd	a5,112(sp)
    80005130:	fcc2                	sd	a6,120(sp)
    80005132:	e146                	sd	a7,128(sp)
    80005134:	e54a                	sd	s2,136(sp)
    80005136:	e94e                	sd	s3,144(sp)
    80005138:	ed52                	sd	s4,152(sp)
    8000513a:	f156                	sd	s5,160(sp)
    8000513c:	f55a                	sd	s6,168(sp)
    8000513e:	f95e                	sd	s7,176(sp)
    80005140:	fd62                	sd	s8,184(sp)
    80005142:	e1e6                	sd	s9,192(sp)
    80005144:	e5ea                	sd	s10,200(sp)
    80005146:	e9ee                	sd	s11,208(sp)
    80005148:	edf2                	sd	t3,216(sp)
    8000514a:	f1f6                	sd	t4,224(sp)
    8000514c:	f5fa                	sd	t5,232(sp)
    8000514e:	f9fe                	sd	t6,240(sp)
    80005150:	cb5fc0ef          	jal	80001e04 <kerneltrap>
    80005154:	6082                	ld	ra,0(sp)
    80005156:	6122                	ld	sp,8(sp)
    80005158:	61c2                	ld	gp,16(sp)
    8000515a:	7282                	ld	t0,32(sp)
    8000515c:	7322                	ld	t1,40(sp)
    8000515e:	73c2                	ld	t2,48(sp)
    80005160:	7462                	ld	s0,56(sp)
    80005162:	6486                	ld	s1,64(sp)
    80005164:	6526                	ld	a0,72(sp)
    80005166:	65c6                	ld	a1,80(sp)
    80005168:	6666                	ld	a2,88(sp)
    8000516a:	7686                	ld	a3,96(sp)
    8000516c:	7726                	ld	a4,104(sp)
    8000516e:	77c6                	ld	a5,112(sp)
    80005170:	7866                	ld	a6,120(sp)
    80005172:	688a                	ld	a7,128(sp)
    80005174:	692a                	ld	s2,136(sp)
    80005176:	69ca                	ld	s3,144(sp)
    80005178:	6a6a                	ld	s4,152(sp)
    8000517a:	7a8a                	ld	s5,160(sp)
    8000517c:	7b2a                	ld	s6,168(sp)
    8000517e:	7bca                	ld	s7,176(sp)
    80005180:	7c6a                	ld	s8,184(sp)
    80005182:	6c8e                	ld	s9,192(sp)
    80005184:	6d2e                	ld	s10,200(sp)
    80005186:	6dce                	ld	s11,208(sp)
    80005188:	6e6e                	ld	t3,216(sp)
    8000518a:	7e8e                	ld	t4,224(sp)
    8000518c:	7f2e                	ld	t5,232(sp)
    8000518e:	7fce                	ld	t6,240(sp)
    80005190:	6111                	addi	sp,sp,256
    80005192:	10200073          	sret
    80005196:	00000013          	nop
    8000519a:	00000013          	nop
    8000519e:	0001                	nop

00000000800051a0 <timervec>:
    800051a0:	34051573          	csrrw	a0,mscratch,a0
    800051a4:	e10c                	sd	a1,0(a0)
    800051a6:	e510                	sd	a2,8(a0)
    800051a8:	e914                	sd	a3,16(a0)
    800051aa:	6d0c                	ld	a1,24(a0)
    800051ac:	7110                	ld	a2,32(a0)
    800051ae:	6194                	ld	a3,0(a1)
    800051b0:	96b2                	add	a3,a3,a2
    800051b2:	e194                	sd	a3,0(a1)
    800051b4:	4589                	li	a1,2
    800051b6:	14459073          	csrw	sip,a1
    800051ba:	6914                	ld	a3,16(a0)
    800051bc:	6510                	ld	a2,8(a0)
    800051be:	610c                	ld	a1,0(a0)
    800051c0:	34051573          	csrrw	a0,mscratch,a0
    800051c4:	30200073          	mret
	...

00000000800051ca <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800051ca:	1141                	addi	sp,sp,-16
    800051cc:	e406                	sd	ra,8(sp)
    800051ce:	e022                	sd	s0,0(sp)
    800051d0:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800051d2:	0c000737          	lui	a4,0xc000
    800051d6:	4785                	li	a5,1
    800051d8:	d71c                	sw	a5,40(a4)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800051da:	c35c                	sw	a5,4(a4)
}
    800051dc:	60a2                	ld	ra,8(sp)
    800051de:	6402                	ld	s0,0(sp)
    800051e0:	0141                	addi	sp,sp,16
    800051e2:	8082                	ret

00000000800051e4 <plicinithart>:

void
plicinithart(void)
{
    800051e4:	1141                	addi	sp,sp,-16
    800051e6:	e406                	sd	ra,8(sp)
    800051e8:	e022                	sd	s0,0(sp)
    800051ea:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800051ec:	ffffc097          	auipc	ra,0xffffc
    800051f0:	c54080e7          	jalr	-940(ra) # 80000e40 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800051f4:	0085171b          	slliw	a4,a0,0x8
    800051f8:	0c0027b7          	lui	a5,0xc002
    800051fc:	97ba                	add	a5,a5,a4
    800051fe:	40200713          	li	a4,1026
    80005202:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005206:	00d5151b          	slliw	a0,a0,0xd
    8000520a:	0c2017b7          	lui	a5,0xc201
    8000520e:	97aa                	add	a5,a5,a0
    80005210:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005214:	60a2                	ld	ra,8(sp)
    80005216:	6402                	ld	s0,0(sp)
    80005218:	0141                	addi	sp,sp,16
    8000521a:	8082                	ret

000000008000521c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000521c:	1141                	addi	sp,sp,-16
    8000521e:	e406                	sd	ra,8(sp)
    80005220:	e022                	sd	s0,0(sp)
    80005222:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005224:	ffffc097          	auipc	ra,0xffffc
    80005228:	c1c080e7          	jalr	-996(ra) # 80000e40 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    8000522c:	00d5151b          	slliw	a0,a0,0xd
    80005230:	0c2017b7          	lui	a5,0xc201
    80005234:	97aa                	add	a5,a5,a0
  return irq;
}
    80005236:	43c8                	lw	a0,4(a5)
    80005238:	60a2                	ld	ra,8(sp)
    8000523a:	6402                	ld	s0,0(sp)
    8000523c:	0141                	addi	sp,sp,16
    8000523e:	8082                	ret

0000000080005240 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80005240:	1101                	addi	sp,sp,-32
    80005242:	ec06                	sd	ra,24(sp)
    80005244:	e822                	sd	s0,16(sp)
    80005246:	e426                	sd	s1,8(sp)
    80005248:	1000                	addi	s0,sp,32
    8000524a:	84aa                	mv	s1,a0
  int hart = cpuid();
    8000524c:	ffffc097          	auipc	ra,0xffffc
    80005250:	bf4080e7          	jalr	-1036(ra) # 80000e40 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005254:	00d5179b          	slliw	a5,a0,0xd
    80005258:	0c201737          	lui	a4,0xc201
    8000525c:	97ba                	add	a5,a5,a4
    8000525e:	c3c4                	sw	s1,4(a5)
}
    80005260:	60e2                	ld	ra,24(sp)
    80005262:	6442                	ld	s0,16(sp)
    80005264:	64a2                	ld	s1,8(sp)
    80005266:	6105                	addi	sp,sp,32
    80005268:	8082                	ret

000000008000526a <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    8000526a:	1141                	addi	sp,sp,-16
    8000526c:	e406                	sd	ra,8(sp)
    8000526e:	e022                	sd	s0,0(sp)
    80005270:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80005272:	479d                	li	a5,7
    80005274:	06a7c863          	blt	a5,a0,800052e4 <free_desc+0x7a>
    panic("free_desc 1");
  if(disk.free[i])
    80005278:	00016717          	auipc	a4,0x16
    8000527c:	d8870713          	addi	a4,a4,-632 # 8001b000 <disk>
    80005280:	972a                	add	a4,a4,a0
    80005282:	6789                	lui	a5,0x2
    80005284:	97ba                	add	a5,a5,a4
    80005286:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    8000528a:	e7ad                	bnez	a5,800052f4 <free_desc+0x8a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000528c:	00451793          	slli	a5,a0,0x4
    80005290:	00018717          	auipc	a4,0x18
    80005294:	d7070713          	addi	a4,a4,-656 # 8001d000 <disk+0x2000>
    80005298:	6314                	ld	a3,0(a4)
    8000529a:	96be                	add	a3,a3,a5
    8000529c:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800052a0:	6314                	ld	a3,0(a4)
    800052a2:	96be                	add	a3,a3,a5
    800052a4:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    800052a8:	6314                	ld	a3,0(a4)
    800052aa:	96be                	add	a3,a3,a5
    800052ac:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    800052b0:	6318                	ld	a4,0(a4)
    800052b2:	97ba                	add	a5,a5,a4
    800052b4:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    800052b8:	00016717          	auipc	a4,0x16
    800052bc:	d4870713          	addi	a4,a4,-696 # 8001b000 <disk>
    800052c0:	972a                	add	a4,a4,a0
    800052c2:	6789                	lui	a5,0x2
    800052c4:	97ba                	add	a5,a5,a4
    800052c6:	4705                	li	a4,1
    800052c8:	00e78c23          	sb	a4,24(a5) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    800052cc:	00018517          	auipc	a0,0x18
    800052d0:	d4c50513          	addi	a0,a0,-692 # 8001d018 <disk+0x2018>
    800052d4:	ffffc097          	auipc	ra,0xffffc
    800052d8:	3ec080e7          	jalr	1004(ra) # 800016c0 <wakeup>
}
    800052dc:	60a2                	ld	ra,8(sp)
    800052de:	6402                	ld	s0,0(sp)
    800052e0:	0141                	addi	sp,sp,16
    800052e2:	8082                	ret
    panic("free_desc 1");
    800052e4:	00003517          	auipc	a0,0x3
    800052e8:	30c50513          	addi	a0,a0,780 # 800085f0 <etext+0x5f0>
    800052ec:	00001097          	auipc	ra,0x1
    800052f0:	9f6080e7          	jalr	-1546(ra) # 80005ce2 <panic>
    panic("free_desc 2");
    800052f4:	00003517          	auipc	a0,0x3
    800052f8:	30c50513          	addi	a0,a0,780 # 80008600 <etext+0x600>
    800052fc:	00001097          	auipc	ra,0x1
    80005300:	9e6080e7          	jalr	-1562(ra) # 80005ce2 <panic>

0000000080005304 <virtio_disk_init>:
{
    80005304:	1141                	addi	sp,sp,-16
    80005306:	e406                	sd	ra,8(sp)
    80005308:	e022                	sd	s0,0(sp)
    8000530a:	0800                	addi	s0,sp,16
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000530c:	00003597          	auipc	a1,0x3
    80005310:	30458593          	addi	a1,a1,772 # 80008610 <etext+0x610>
    80005314:	00018517          	auipc	a0,0x18
    80005318:	e1450513          	addi	a0,a0,-492 # 8001d128 <disk+0x2128>
    8000531c:	00001097          	auipc	ra,0x1
    80005320:	eb2080e7          	jalr	-334(ra) # 800061ce <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005324:	100017b7          	lui	a5,0x10001
    80005328:	4398                	lw	a4,0(a5)
    8000532a:	2701                	sext.w	a4,a4
    8000532c:	747277b7          	lui	a5,0x74727
    80005330:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005334:	0ef71563          	bne	a4,a5,8000541e <virtio_disk_init+0x11a>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005338:	100017b7          	lui	a5,0x10001
    8000533c:	43dc                	lw	a5,4(a5)
    8000533e:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005340:	4705                	li	a4,1
    80005342:	0ce79e63          	bne	a5,a4,8000541e <virtio_disk_init+0x11a>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005346:	100017b7          	lui	a5,0x10001
    8000534a:	479c                	lw	a5,8(a5)
    8000534c:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    8000534e:	4709                	li	a4,2
    80005350:	0ce79763          	bne	a5,a4,8000541e <virtio_disk_init+0x11a>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005354:	100017b7          	lui	a5,0x10001
    80005358:	47d8                	lw	a4,12(a5)
    8000535a:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000535c:	554d47b7          	lui	a5,0x554d4
    80005360:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005364:	0af71d63          	bne	a4,a5,8000541e <virtio_disk_init+0x11a>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005368:	100017b7          	lui	a5,0x10001
    8000536c:	4705                	li	a4,1
    8000536e:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005370:	470d                	li	a4,3
    80005372:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005374:	10001737          	lui	a4,0x10001
    80005378:	4b18                	lw	a4,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    8000537a:	c7ffe6b7          	lui	a3,0xc7ffe
    8000537e:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fd851f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005382:	8f75                	and	a4,a4,a3
    80005384:	100016b7          	lui	a3,0x10001
    80005388:	d298                	sw	a4,32(a3)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000538a:	472d                	li	a4,11
    8000538c:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000538e:	473d                	li	a4,15
    80005390:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80005392:	6705                	lui	a4,0x1
    80005394:	d698                	sw	a4,40(a3)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005396:	0206a823          	sw	zero,48(a3) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    8000539a:	5adc                	lw	a5,52(a3)
    8000539c:	2781                	sext.w	a5,a5
  if(max == 0)
    8000539e:	cbc1                	beqz	a5,8000542e <virtio_disk_init+0x12a>
  if(max < NUM)
    800053a0:	471d                	li	a4,7
    800053a2:	08f77e63          	bgeu	a4,a5,8000543e <virtio_disk_init+0x13a>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800053a6:	100017b7          	lui	a5,0x10001
    800053aa:	4721                	li	a4,8
    800053ac:	df98                	sw	a4,56(a5)
  memset(disk.pages, 0, sizeof(disk.pages));
    800053ae:	6609                	lui	a2,0x2
    800053b0:	4581                	li	a1,0
    800053b2:	00016517          	auipc	a0,0x16
    800053b6:	c4e50513          	addi	a0,a0,-946 # 8001b000 <disk>
    800053ba:	ffffb097          	auipc	ra,0xffffb
    800053be:	dc0080e7          	jalr	-576(ra) # 8000017a <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    800053c2:	00016717          	auipc	a4,0x16
    800053c6:	c3e70713          	addi	a4,a4,-962 # 8001b000 <disk>
    800053ca:	00c75793          	srli	a5,a4,0xc
    800053ce:	2781                	sext.w	a5,a5
    800053d0:	100016b7          	lui	a3,0x10001
    800053d4:	c2bc                	sw	a5,64(a3)
  disk.desc = (struct virtq_desc *) disk.pages;
    800053d6:	00018797          	auipc	a5,0x18
    800053da:	c2a78793          	addi	a5,a5,-982 # 8001d000 <disk+0x2000>
    800053de:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    800053e0:	00016717          	auipc	a4,0x16
    800053e4:	ca070713          	addi	a4,a4,-864 # 8001b080 <disk+0x80>
    800053e8:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    800053ea:	00017717          	auipc	a4,0x17
    800053ee:	c1670713          	addi	a4,a4,-1002 # 8001c000 <disk+0x1000>
    800053f2:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    800053f4:	4705                	li	a4,1
    800053f6:	00e78c23          	sb	a4,24(a5)
    800053fa:	00e78ca3          	sb	a4,25(a5)
    800053fe:	00e78d23          	sb	a4,26(a5)
    80005402:	00e78da3          	sb	a4,27(a5)
    80005406:	00e78e23          	sb	a4,28(a5)
    8000540a:	00e78ea3          	sb	a4,29(a5)
    8000540e:	00e78f23          	sb	a4,30(a5)
    80005412:	00e78fa3          	sb	a4,31(a5)
}
    80005416:	60a2                	ld	ra,8(sp)
    80005418:	6402                	ld	s0,0(sp)
    8000541a:	0141                	addi	sp,sp,16
    8000541c:	8082                	ret
    panic("could not find virtio disk");
    8000541e:	00003517          	auipc	a0,0x3
    80005422:	20250513          	addi	a0,a0,514 # 80008620 <etext+0x620>
    80005426:	00001097          	auipc	ra,0x1
    8000542a:	8bc080e7          	jalr	-1860(ra) # 80005ce2 <panic>
    panic("virtio disk has no queue 0");
    8000542e:	00003517          	auipc	a0,0x3
    80005432:	21250513          	addi	a0,a0,530 # 80008640 <etext+0x640>
    80005436:	00001097          	auipc	ra,0x1
    8000543a:	8ac080e7          	jalr	-1876(ra) # 80005ce2 <panic>
    panic("virtio disk max queue too short");
    8000543e:	00003517          	auipc	a0,0x3
    80005442:	22250513          	addi	a0,a0,546 # 80008660 <etext+0x660>
    80005446:	00001097          	auipc	ra,0x1
    8000544a:	89c080e7          	jalr	-1892(ra) # 80005ce2 <panic>

000000008000544e <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    8000544e:	711d                	addi	sp,sp,-96
    80005450:	ec86                	sd	ra,88(sp)
    80005452:	e8a2                	sd	s0,80(sp)
    80005454:	e4a6                	sd	s1,72(sp)
    80005456:	e0ca                	sd	s2,64(sp)
    80005458:	fc4e                	sd	s3,56(sp)
    8000545a:	f852                	sd	s4,48(sp)
    8000545c:	f456                	sd	s5,40(sp)
    8000545e:	f05a                	sd	s6,32(sp)
    80005460:	ec5e                	sd	s7,24(sp)
    80005462:	e862                	sd	s8,16(sp)
    80005464:	1080                	addi	s0,sp,96
    80005466:	89aa                	mv	s3,a0
    80005468:	8c2e                	mv	s8,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    8000546a:	00c52b83          	lw	s7,12(a0)
    8000546e:	001b9b9b          	slliw	s7,s7,0x1
    80005472:	1b82                	slli	s7,s7,0x20
    80005474:	020bdb93          	srli	s7,s7,0x20

  acquire(&disk.vdisk_lock);
    80005478:	00018517          	auipc	a0,0x18
    8000547c:	cb050513          	addi	a0,a0,-848 # 8001d128 <disk+0x2128>
    80005480:	00001097          	auipc	ra,0x1
    80005484:	de2080e7          	jalr	-542(ra) # 80006262 <acquire>
  for(int i = 0; i < NUM; i++){
    80005488:	44a1                	li	s1,8
      disk.free[i] = 0;
    8000548a:	00016b17          	auipc	s6,0x16
    8000548e:	b76b0b13          	addi	s6,s6,-1162 # 8001b000 <disk>
    80005492:	6a89                	lui	s5,0x2
  for(int i = 0; i < 3; i++){
    80005494:	4a0d                	li	s4,3
    80005496:	a88d                	j	80005508 <virtio_disk_rw+0xba>
      disk.free[i] = 0;
    80005498:	00fb0733          	add	a4,s6,a5
    8000549c:	9756                	add	a4,a4,s5
    8000549e:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800054a2:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800054a4:	0207c563          	bltz	a5,800054ce <virtio_disk_rw+0x80>
  for(int i = 0; i < 3; i++){
    800054a8:	2905                	addiw	s2,s2,1
    800054aa:	0611                	addi	a2,a2,4 # 2004 <_entry-0x7fffdffc>
    800054ac:	1b490063          	beq	s2,s4,8000564c <virtio_disk_rw+0x1fe>
    idx[i] = alloc_desc();
    800054b0:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    800054b2:	00018717          	auipc	a4,0x18
    800054b6:	b6670713          	addi	a4,a4,-1178 # 8001d018 <disk+0x2018>
    800054ba:	4781                	li	a5,0
    if(disk.free[i]){
    800054bc:	00074683          	lbu	a3,0(a4)
    800054c0:	fee1                	bnez	a3,80005498 <virtio_disk_rw+0x4a>
  for(int i = 0; i < NUM; i++){
    800054c2:	2785                	addiw	a5,a5,1
    800054c4:	0705                	addi	a4,a4,1
    800054c6:	fe979be3          	bne	a5,s1,800054bc <virtio_disk_rw+0x6e>
    idx[i] = alloc_desc();
    800054ca:	57fd                	li	a5,-1
    800054cc:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    800054ce:	03205163          	blez	s2,800054f0 <virtio_disk_rw+0xa2>
        free_desc(idx[j]);
    800054d2:	fa042503          	lw	a0,-96(s0)
    800054d6:	00000097          	auipc	ra,0x0
    800054da:	d94080e7          	jalr	-620(ra) # 8000526a <free_desc>
      for(int j = 0; j < i; j++)
    800054de:	4785                	li	a5,1
    800054e0:	0127d863          	bge	a5,s2,800054f0 <virtio_disk_rw+0xa2>
        free_desc(idx[j]);
    800054e4:	fa442503          	lw	a0,-92(s0)
    800054e8:	00000097          	auipc	ra,0x0
    800054ec:	d82080e7          	jalr	-638(ra) # 8000526a <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800054f0:	00018597          	auipc	a1,0x18
    800054f4:	c3858593          	addi	a1,a1,-968 # 8001d128 <disk+0x2128>
    800054f8:	00018517          	auipc	a0,0x18
    800054fc:	b2050513          	addi	a0,a0,-1248 # 8001d018 <disk+0x2018>
    80005500:	ffffc097          	auipc	ra,0xffffc
    80005504:	03a080e7          	jalr	58(ra) # 8000153a <sleep>
  for(int i = 0; i < 3; i++){
    80005508:	fa040613          	addi	a2,s0,-96
    8000550c:	4901                	li	s2,0
    8000550e:	b74d                	j	800054b0 <virtio_disk_rw+0x62>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80005510:	00018717          	auipc	a4,0x18
    80005514:	af073703          	ld	a4,-1296(a4) # 8001d000 <disk+0x2000>
    80005518:	973e                	add	a4,a4,a5
    8000551a:	00071623          	sh	zero,12(a4)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000551e:	00016897          	auipc	a7,0x16
    80005522:	ae288893          	addi	a7,a7,-1310 # 8001b000 <disk>
    80005526:	00018717          	auipc	a4,0x18
    8000552a:	ada70713          	addi	a4,a4,-1318 # 8001d000 <disk+0x2000>
    8000552e:	6314                	ld	a3,0(a4)
    80005530:	96be                	add	a3,a3,a5
    80005532:	00c6d583          	lhu	a1,12(a3) # 1000100c <_entry-0x6fffeff4>
    80005536:	0015e593          	ori	a1,a1,1
    8000553a:	00b69623          	sh	a1,12(a3)
  disk.desc[idx[1]].next = idx[2];
    8000553e:	fa842683          	lw	a3,-88(s0)
    80005542:	630c                	ld	a1,0(a4)
    80005544:	97ae                	add	a5,a5,a1
    80005546:	00d79723          	sh	a3,14(a5)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    8000554a:	20050593          	addi	a1,a0,512
    8000554e:	0592                	slli	a1,a1,0x4
    80005550:	95c6                	add	a1,a1,a7
    80005552:	57fd                	li	a5,-1
    80005554:	02f58823          	sb	a5,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005558:	00469793          	slli	a5,a3,0x4
    8000555c:	00073803          	ld	a6,0(a4)
    80005560:	983e                	add	a6,a6,a5
    80005562:	6689                	lui	a3,0x2
    80005564:	03068693          	addi	a3,a3,48 # 2030 <_entry-0x7fffdfd0>
    80005568:	96b2                	add	a3,a3,a2
    8000556a:	96c6                	add	a3,a3,a7
    8000556c:	00d83023          	sd	a3,0(a6)
  disk.desc[idx[2]].len = 1;
    80005570:	6314                	ld	a3,0(a4)
    80005572:	96be                	add	a3,a3,a5
    80005574:	4605                	li	a2,1
    80005576:	c690                	sw	a2,8(a3)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005578:	6314                	ld	a3,0(a4)
    8000557a:	96be                	add	a3,a3,a5
    8000557c:	4809                	li	a6,2
    8000557e:	01069623          	sh	a6,12(a3)
  disk.desc[idx[2]].next = 0;
    80005582:	6314                	ld	a3,0(a4)
    80005584:	97b6                	add	a5,a5,a3
    80005586:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000558a:	00c9a223          	sw	a2,4(s3)
  disk.info[idx[0]].b = b;
    8000558e:	0335b423          	sd	s3,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005592:	6714                	ld	a3,8(a4)
    80005594:	0026d783          	lhu	a5,2(a3)
    80005598:	8b9d                	andi	a5,a5,7
    8000559a:	0786                	slli	a5,a5,0x1
    8000559c:	96be                	add	a3,a3,a5
    8000559e:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    800055a2:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800055a6:	6718                	ld	a4,8(a4)
    800055a8:	00275783          	lhu	a5,2(a4)
    800055ac:	2785                	addiw	a5,a5,1
    800055ae:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800055b2:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800055b6:	100017b7          	lui	a5,0x10001
    800055ba:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800055be:	0049a783          	lw	a5,4(s3)
    800055c2:	02c79163          	bne	a5,a2,800055e4 <virtio_disk_rw+0x196>
    sleep(b, &disk.vdisk_lock);
    800055c6:	00018917          	auipc	s2,0x18
    800055ca:	b6290913          	addi	s2,s2,-1182 # 8001d128 <disk+0x2128>
  while(b->disk == 1) {
    800055ce:	84b2                	mv	s1,a2
    sleep(b, &disk.vdisk_lock);
    800055d0:	85ca                	mv	a1,s2
    800055d2:	854e                	mv	a0,s3
    800055d4:	ffffc097          	auipc	ra,0xffffc
    800055d8:	f66080e7          	jalr	-154(ra) # 8000153a <sleep>
  while(b->disk == 1) {
    800055dc:	0049a783          	lw	a5,4(s3)
    800055e0:	fe9788e3          	beq	a5,s1,800055d0 <virtio_disk_rw+0x182>
  }

  disk.info[idx[0]].b = 0;
    800055e4:	fa042903          	lw	s2,-96(s0)
    800055e8:	20090713          	addi	a4,s2,512
    800055ec:	0712                	slli	a4,a4,0x4
    800055ee:	00016797          	auipc	a5,0x16
    800055f2:	a1278793          	addi	a5,a5,-1518 # 8001b000 <disk>
    800055f6:	97ba                	add	a5,a5,a4
    800055f8:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    800055fc:	00018997          	auipc	s3,0x18
    80005600:	a0498993          	addi	s3,s3,-1532 # 8001d000 <disk+0x2000>
    80005604:	00491713          	slli	a4,s2,0x4
    80005608:	0009b783          	ld	a5,0(s3)
    8000560c:	97ba                	add	a5,a5,a4
    8000560e:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005612:	854a                	mv	a0,s2
    80005614:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005618:	00000097          	auipc	ra,0x0
    8000561c:	c52080e7          	jalr	-942(ra) # 8000526a <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005620:	8885                	andi	s1,s1,1
    80005622:	f0ed                	bnez	s1,80005604 <virtio_disk_rw+0x1b6>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005624:	00018517          	auipc	a0,0x18
    80005628:	b0450513          	addi	a0,a0,-1276 # 8001d128 <disk+0x2128>
    8000562c:	00001097          	auipc	ra,0x1
    80005630:	ce6080e7          	jalr	-794(ra) # 80006312 <release>
}
    80005634:	60e6                	ld	ra,88(sp)
    80005636:	6446                	ld	s0,80(sp)
    80005638:	64a6                	ld	s1,72(sp)
    8000563a:	6906                	ld	s2,64(sp)
    8000563c:	79e2                	ld	s3,56(sp)
    8000563e:	7a42                	ld	s4,48(sp)
    80005640:	7aa2                	ld	s5,40(sp)
    80005642:	7b02                	ld	s6,32(sp)
    80005644:	6be2                	ld	s7,24(sp)
    80005646:	6c42                	ld	s8,16(sp)
    80005648:	6125                	addi	sp,sp,96
    8000564a:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000564c:	fa042503          	lw	a0,-96(s0)
    80005650:	00451613          	slli	a2,a0,0x4
  if(write)
    80005654:	00016597          	auipc	a1,0x16
    80005658:	9ac58593          	addi	a1,a1,-1620 # 8001b000 <disk>
    8000565c:	20050793          	addi	a5,a0,512
    80005660:	0792                	slli	a5,a5,0x4
    80005662:	97ae                	add	a5,a5,a1
    80005664:	01803733          	snez	a4,s8
    80005668:	0ae7a423          	sw	a4,168(a5)
  buf0->reserved = 0;
    8000566c:	0a07a623          	sw	zero,172(a5)
  buf0->sector = sector;
    80005670:	0b77b823          	sd	s7,176(a5)
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005674:	00018717          	auipc	a4,0x18
    80005678:	98c70713          	addi	a4,a4,-1652 # 8001d000 <disk+0x2000>
    8000567c:	6314                	ld	a3,0(a4)
    8000567e:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005680:	6789                	lui	a5,0x2
    80005682:	0a878793          	addi	a5,a5,168 # 20a8 <_entry-0x7fffdf58>
    80005686:	97b2                	add	a5,a5,a2
    80005688:	97ae                	add	a5,a5,a1
  disk.desc[idx[0]].addr = (uint64) buf0;
    8000568a:	e29c                	sd	a5,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000568c:	631c                	ld	a5,0(a4)
    8000568e:	97b2                	add	a5,a5,a2
    80005690:	46c1                	li	a3,16
    80005692:	c794                	sw	a3,8(a5)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005694:	631c                	ld	a5,0(a4)
    80005696:	97b2                	add	a5,a5,a2
    80005698:	4685                	li	a3,1
    8000569a:	00d79623          	sh	a3,12(a5)
  disk.desc[idx[0]].next = idx[1];
    8000569e:	fa442783          	lw	a5,-92(s0)
    800056a2:	6314                	ld	a3,0(a4)
    800056a4:	96b2                	add	a3,a3,a2
    800056a6:	00f69723          	sh	a5,14(a3)
  disk.desc[idx[1]].addr = (uint64) b->data;
    800056aa:	0792                	slli	a5,a5,0x4
    800056ac:	6314                	ld	a3,0(a4)
    800056ae:	96be                	add	a3,a3,a5
    800056b0:	05898593          	addi	a1,s3,88
    800056b4:	e28c                	sd	a1,0(a3)
  disk.desc[idx[1]].len = BSIZE;
    800056b6:	6318                	ld	a4,0(a4)
    800056b8:	973e                	add	a4,a4,a5
    800056ba:	40000693          	li	a3,1024
    800056be:	c714                	sw	a3,8(a4)
  if(write)
    800056c0:	e40c18e3          	bnez	s8,80005510 <virtio_disk_rw+0xc2>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    800056c4:	00018717          	auipc	a4,0x18
    800056c8:	93c73703          	ld	a4,-1732(a4) # 8001d000 <disk+0x2000>
    800056cc:	973e                	add	a4,a4,a5
    800056ce:	4689                	li	a3,2
    800056d0:	00d71623          	sh	a3,12(a4)
    800056d4:	b5a9                	j	8000551e <virtio_disk_rw+0xd0>

00000000800056d6 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800056d6:	1101                	addi	sp,sp,-32
    800056d8:	ec06                	sd	ra,24(sp)
    800056da:	e822                	sd	s0,16(sp)
    800056dc:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800056de:	00018517          	auipc	a0,0x18
    800056e2:	a4a50513          	addi	a0,a0,-1462 # 8001d128 <disk+0x2128>
    800056e6:	00001097          	auipc	ra,0x1
    800056ea:	b7c080e7          	jalr	-1156(ra) # 80006262 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800056ee:	100017b7          	lui	a5,0x10001
    800056f2:	53bc                	lw	a5,96(a5)
    800056f4:	8b8d                	andi	a5,a5,3
    800056f6:	10001737          	lui	a4,0x10001
    800056fa:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800056fc:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005700:	00018797          	auipc	a5,0x18
    80005704:	90078793          	addi	a5,a5,-1792 # 8001d000 <disk+0x2000>
    80005708:	6b94                	ld	a3,16(a5)
    8000570a:	0207d703          	lhu	a4,32(a5)
    8000570e:	0026d783          	lhu	a5,2(a3)
    80005712:	06f70563          	beq	a4,a5,8000577c <virtio_disk_intr+0xa6>
    80005716:	e426                	sd	s1,8(sp)
    80005718:	e04a                	sd	s2,0(sp)
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000571a:	00016917          	auipc	s2,0x16
    8000571e:	8e690913          	addi	s2,s2,-1818 # 8001b000 <disk>
    80005722:	00018497          	auipc	s1,0x18
    80005726:	8de48493          	addi	s1,s1,-1826 # 8001d000 <disk+0x2000>
    __sync_synchronize();
    8000572a:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000572e:	6898                	ld	a4,16(s1)
    80005730:	0204d783          	lhu	a5,32(s1)
    80005734:	8b9d                	andi	a5,a5,7
    80005736:	078e                	slli	a5,a5,0x3
    80005738:	97ba                	add	a5,a5,a4
    8000573a:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    8000573c:	20078713          	addi	a4,a5,512
    80005740:	0712                	slli	a4,a4,0x4
    80005742:	974a                	add	a4,a4,s2
    80005744:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    80005748:	e731                	bnez	a4,80005794 <virtio_disk_intr+0xbe>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    8000574a:	20078793          	addi	a5,a5,512
    8000574e:	0792                	slli	a5,a5,0x4
    80005750:	97ca                	add	a5,a5,s2
    80005752:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    80005754:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005758:	ffffc097          	auipc	ra,0xffffc
    8000575c:	f68080e7          	jalr	-152(ra) # 800016c0 <wakeup>

    disk.used_idx += 1;
    80005760:	0204d783          	lhu	a5,32(s1)
    80005764:	2785                	addiw	a5,a5,1
    80005766:	17c2                	slli	a5,a5,0x30
    80005768:	93c1                	srli	a5,a5,0x30
    8000576a:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    8000576e:	6898                	ld	a4,16(s1)
    80005770:	00275703          	lhu	a4,2(a4)
    80005774:	faf71be3          	bne	a4,a5,8000572a <virtio_disk_intr+0x54>
    80005778:	64a2                	ld	s1,8(sp)
    8000577a:	6902                	ld	s2,0(sp)
  }

  release(&disk.vdisk_lock);
    8000577c:	00018517          	auipc	a0,0x18
    80005780:	9ac50513          	addi	a0,a0,-1620 # 8001d128 <disk+0x2128>
    80005784:	00001097          	auipc	ra,0x1
    80005788:	b8e080e7          	jalr	-1138(ra) # 80006312 <release>
}
    8000578c:	60e2                	ld	ra,24(sp)
    8000578e:	6442                	ld	s0,16(sp)
    80005790:	6105                	addi	sp,sp,32
    80005792:	8082                	ret
      panic("virtio_disk_intr status");
    80005794:	00003517          	auipc	a0,0x3
    80005798:	eec50513          	addi	a0,a0,-276 # 80008680 <etext+0x680>
    8000579c:	00000097          	auipc	ra,0x0
    800057a0:	546080e7          	jalr	1350(ra) # 80005ce2 <panic>

00000000800057a4 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    800057a4:	1141                	addi	sp,sp,-16
    800057a6:	e406                	sd	ra,8(sp)
    800057a8:	e022                	sd	s0,0(sp)
    800057aa:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800057ac:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    800057b0:	2781                	sext.w	a5,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    800057b2:	0037961b          	slliw	a2,a5,0x3
    800057b6:	02004737          	lui	a4,0x2004
    800057ba:	963a                	add	a2,a2,a4
    800057bc:	0200c737          	lui	a4,0x200c
    800057c0:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    800057c4:	000f46b7          	lui	a3,0xf4
    800057c8:	24068693          	addi	a3,a3,576 # f4240 <_entry-0x7ff0bdc0>
    800057cc:	9736                	add	a4,a4,a3
    800057ce:	e218                	sd	a4,0(a2)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    800057d0:	00279713          	slli	a4,a5,0x2
    800057d4:	973e                	add	a4,a4,a5
    800057d6:	070e                	slli	a4,a4,0x3
    800057d8:	00019797          	auipc	a5,0x19
    800057dc:	82878793          	addi	a5,a5,-2008 # 8001e000 <timer_scratch>
    800057e0:	97ba                	add	a5,a5,a4
  scratch[3] = CLINT_MTIMECMP(id);
    800057e2:	ef90                	sd	a2,24(a5)
  scratch[4] = interval;
    800057e4:	f394                	sd	a3,32(a5)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    800057e6:	34079073          	csrw	mscratch,a5
  asm volatile("csrw mtvec, %0" : : "r" (x));
    800057ea:	00000797          	auipc	a5,0x0
    800057ee:	9b678793          	addi	a5,a5,-1610 # 800051a0 <timervec>
    800057f2:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800057f6:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    800057fa:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800057fe:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005802:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005806:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    8000580a:	30479073          	csrw	mie,a5
}
    8000580e:	60a2                	ld	ra,8(sp)
    80005810:	6402                	ld	s0,0(sp)
    80005812:	0141                	addi	sp,sp,16
    80005814:	8082                	ret

0000000080005816 <start>:
{
    80005816:	1141                	addi	sp,sp,-16
    80005818:	e406                	sd	ra,8(sp)
    8000581a:	e022                	sd	s0,0(sp)
    8000581c:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000581e:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005822:	7779                	lui	a4,0xffffe
    80005824:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd85bf>
    80005828:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000582a:	6705                	lui	a4,0x1
    8000582c:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005830:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005832:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005836:	ffffb797          	auipc	a5,0xffffb
    8000583a:	afe78793          	addi	a5,a5,-1282 # 80000334 <main>
    8000583e:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005842:	4781                	li	a5,0
    80005844:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005848:	67c1                	lui	a5,0x10
    8000584a:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    8000584c:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005850:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005854:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005858:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    8000585c:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005860:	57fd                	li	a5,-1
    80005862:	83a9                	srli	a5,a5,0xa
    80005864:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005868:	47bd                	li	a5,15
    8000586a:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    8000586e:	00000097          	auipc	ra,0x0
    80005872:	f36080e7          	jalr	-202(ra) # 800057a4 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005876:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    8000587a:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    8000587c:	823e                	mv	tp,a5
  asm volatile("mret");
    8000587e:	30200073          	mret
}
    80005882:	60a2                	ld	ra,8(sp)
    80005884:	6402                	ld	s0,0(sp)
    80005886:	0141                	addi	sp,sp,16
    80005888:	8082                	ret

000000008000588a <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    8000588a:	711d                	addi	sp,sp,-96
    8000588c:	ec86                	sd	ra,88(sp)
    8000588e:	e8a2                	sd	s0,80(sp)
    80005890:	e0ca                	sd	s2,64(sp)
    80005892:	1080                	addi	s0,sp,96
  int i;

  for(i = 0; i < n; i++){
    80005894:	04c05c63          	blez	a2,800058ec <consolewrite+0x62>
    80005898:	e4a6                	sd	s1,72(sp)
    8000589a:	fc4e                	sd	s3,56(sp)
    8000589c:	f852                	sd	s4,48(sp)
    8000589e:	f456                	sd	s5,40(sp)
    800058a0:	f05a                	sd	s6,32(sp)
    800058a2:	ec5e                	sd	s7,24(sp)
    800058a4:	8a2a                	mv	s4,a0
    800058a6:	84ae                	mv	s1,a1
    800058a8:	89b2                	mv	s3,a2
    800058aa:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    800058ac:	faf40b93          	addi	s7,s0,-81
    800058b0:	4b05                	li	s6,1
    800058b2:	5afd                	li	s5,-1
    800058b4:	86da                	mv	a3,s6
    800058b6:	8626                	mv	a2,s1
    800058b8:	85d2                	mv	a1,s4
    800058ba:	855e                	mv	a0,s7
    800058bc:	ffffc097          	auipc	ra,0xffffc
    800058c0:	072080e7          	jalr	114(ra) # 8000192e <either_copyin>
    800058c4:	03550663          	beq	a0,s5,800058f0 <consolewrite+0x66>
      break;
    uartputc(c);
    800058c8:	faf44503          	lbu	a0,-81(s0)
    800058cc:	00000097          	auipc	ra,0x0
    800058d0:	7d4080e7          	jalr	2004(ra) # 800060a0 <uartputc>
  for(i = 0; i < n; i++){
    800058d4:	2905                	addiw	s2,s2,1
    800058d6:	0485                	addi	s1,s1,1
    800058d8:	fd299ee3          	bne	s3,s2,800058b4 <consolewrite+0x2a>
    800058dc:	894e                	mv	s2,s3
    800058de:	64a6                	ld	s1,72(sp)
    800058e0:	79e2                	ld	s3,56(sp)
    800058e2:	7a42                	ld	s4,48(sp)
    800058e4:	7aa2                	ld	s5,40(sp)
    800058e6:	7b02                	ld	s6,32(sp)
    800058e8:	6be2                	ld	s7,24(sp)
    800058ea:	a809                	j	800058fc <consolewrite+0x72>
    800058ec:	4901                	li	s2,0
    800058ee:	a039                	j	800058fc <consolewrite+0x72>
    800058f0:	64a6                	ld	s1,72(sp)
    800058f2:	79e2                	ld	s3,56(sp)
    800058f4:	7a42                	ld	s4,48(sp)
    800058f6:	7aa2                	ld	s5,40(sp)
    800058f8:	7b02                	ld	s6,32(sp)
    800058fa:	6be2                	ld	s7,24(sp)
  }

  return i;
}
    800058fc:	854a                	mv	a0,s2
    800058fe:	60e6                	ld	ra,88(sp)
    80005900:	6446                	ld	s0,80(sp)
    80005902:	6906                	ld	s2,64(sp)
    80005904:	6125                	addi	sp,sp,96
    80005906:	8082                	ret

0000000080005908 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005908:	711d                	addi	sp,sp,-96
    8000590a:	ec86                	sd	ra,88(sp)
    8000590c:	e8a2                	sd	s0,80(sp)
    8000590e:	e4a6                	sd	s1,72(sp)
    80005910:	e0ca                	sd	s2,64(sp)
    80005912:	fc4e                	sd	s3,56(sp)
    80005914:	f852                	sd	s4,48(sp)
    80005916:	f456                	sd	s5,40(sp)
    80005918:	f05a                	sd	s6,32(sp)
    8000591a:	1080                	addi	s0,sp,96
    8000591c:	8aaa                	mv	s5,a0
    8000591e:	8a2e                	mv	s4,a1
    80005920:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005922:	8b32                	mv	s6,a2
  acquire(&cons.lock);
    80005924:	00021517          	auipc	a0,0x21
    80005928:	81c50513          	addi	a0,a0,-2020 # 80026140 <cons>
    8000592c:	00001097          	auipc	ra,0x1
    80005930:	936080e7          	jalr	-1738(ra) # 80006262 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005934:	00021497          	auipc	s1,0x21
    80005938:	80c48493          	addi	s1,s1,-2036 # 80026140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    8000593c:	00021917          	auipc	s2,0x21
    80005940:	89c90913          	addi	s2,s2,-1892 # 800261d8 <cons+0x98>
  while(n > 0){
    80005944:	0d305263          	blez	s3,80005a08 <consoleread+0x100>
    while(cons.r == cons.w){
    80005948:	0984a783          	lw	a5,152(s1)
    8000594c:	09c4a703          	lw	a4,156(s1)
    80005950:	0af71763          	bne	a4,a5,800059fe <consoleread+0xf6>
      if(myproc()->killed){
    80005954:	ffffb097          	auipc	ra,0xffffb
    80005958:	520080e7          	jalr	1312(ra) # 80000e74 <myproc>
    8000595c:	551c                	lw	a5,40(a0)
    8000595e:	e7ad                	bnez	a5,800059c8 <consoleread+0xc0>
      sleep(&cons.r, &cons.lock);
    80005960:	85a6                	mv	a1,s1
    80005962:	854a                	mv	a0,s2
    80005964:	ffffc097          	auipc	ra,0xffffc
    80005968:	bd6080e7          	jalr	-1066(ra) # 8000153a <sleep>
    while(cons.r == cons.w){
    8000596c:	0984a783          	lw	a5,152(s1)
    80005970:	09c4a703          	lw	a4,156(s1)
    80005974:	fef700e3          	beq	a4,a5,80005954 <consoleread+0x4c>
    80005978:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF];
    8000597a:	00020717          	auipc	a4,0x20
    8000597e:	7c670713          	addi	a4,a4,1990 # 80026140 <cons>
    80005982:	0017869b          	addiw	a3,a5,1
    80005986:	08d72c23          	sw	a3,152(a4)
    8000598a:	07f7f693          	andi	a3,a5,127
    8000598e:	9736                	add	a4,a4,a3
    80005990:	01874703          	lbu	a4,24(a4)
    80005994:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80005998:	4691                	li	a3,4
    8000599a:	04db8a63          	beq	s7,a3,800059ee <consoleread+0xe6>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    8000599e:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800059a2:	4685                	li	a3,1
    800059a4:	faf40613          	addi	a2,s0,-81
    800059a8:	85d2                	mv	a1,s4
    800059aa:	8556                	mv	a0,s5
    800059ac:	ffffc097          	auipc	ra,0xffffc
    800059b0:	f2c080e7          	jalr	-212(ra) # 800018d8 <either_copyout>
    800059b4:	57fd                	li	a5,-1
    800059b6:	04f50863          	beq	a0,a5,80005a06 <consoleread+0xfe>
      break;

    dst++;
    800059ba:	0a05                	addi	s4,s4,1
    --n;
    800059bc:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    800059be:	47a9                	li	a5,10
    800059c0:	04fb8f63          	beq	s7,a5,80005a1e <consoleread+0x116>
    800059c4:	6be2                	ld	s7,24(sp)
    800059c6:	bfbd                	j	80005944 <consoleread+0x3c>
        release(&cons.lock);
    800059c8:	00020517          	auipc	a0,0x20
    800059cc:	77850513          	addi	a0,a0,1912 # 80026140 <cons>
    800059d0:	00001097          	auipc	ra,0x1
    800059d4:	942080e7          	jalr	-1726(ra) # 80006312 <release>
        return -1;
    800059d8:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    800059da:	60e6                	ld	ra,88(sp)
    800059dc:	6446                	ld	s0,80(sp)
    800059de:	64a6                	ld	s1,72(sp)
    800059e0:	6906                	ld	s2,64(sp)
    800059e2:	79e2                	ld	s3,56(sp)
    800059e4:	7a42                	ld	s4,48(sp)
    800059e6:	7aa2                	ld	s5,40(sp)
    800059e8:	7b02                	ld	s6,32(sp)
    800059ea:	6125                	addi	sp,sp,96
    800059ec:	8082                	ret
      if(n < target){
    800059ee:	0169fa63          	bgeu	s3,s6,80005a02 <consoleread+0xfa>
        cons.r--;
    800059f2:	00020717          	auipc	a4,0x20
    800059f6:	7ef72323          	sw	a5,2022(a4) # 800261d8 <cons+0x98>
    800059fa:	6be2                	ld	s7,24(sp)
    800059fc:	a031                	j	80005a08 <consoleread+0x100>
    800059fe:	ec5e                	sd	s7,24(sp)
    80005a00:	bfad                	j	8000597a <consoleread+0x72>
    80005a02:	6be2                	ld	s7,24(sp)
    80005a04:	a011                	j	80005a08 <consoleread+0x100>
    80005a06:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80005a08:	00020517          	auipc	a0,0x20
    80005a0c:	73850513          	addi	a0,a0,1848 # 80026140 <cons>
    80005a10:	00001097          	auipc	ra,0x1
    80005a14:	902080e7          	jalr	-1790(ra) # 80006312 <release>
  return target - n;
    80005a18:	413b053b          	subw	a0,s6,s3
    80005a1c:	bf7d                	j	800059da <consoleread+0xd2>
    80005a1e:	6be2                	ld	s7,24(sp)
    80005a20:	b7e5                	j	80005a08 <consoleread+0x100>

0000000080005a22 <consputc>:
{
    80005a22:	1141                	addi	sp,sp,-16
    80005a24:	e406                	sd	ra,8(sp)
    80005a26:	e022                	sd	s0,0(sp)
    80005a28:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005a2a:	10000793          	li	a5,256
    80005a2e:	00f50a63          	beq	a0,a5,80005a42 <consputc+0x20>
    uartputc_sync(c);
    80005a32:	00000097          	auipc	ra,0x0
    80005a36:	590080e7          	jalr	1424(ra) # 80005fc2 <uartputc_sync>
}
    80005a3a:	60a2                	ld	ra,8(sp)
    80005a3c:	6402                	ld	s0,0(sp)
    80005a3e:	0141                	addi	sp,sp,16
    80005a40:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005a42:	4521                	li	a0,8
    80005a44:	00000097          	auipc	ra,0x0
    80005a48:	57e080e7          	jalr	1406(ra) # 80005fc2 <uartputc_sync>
    80005a4c:	02000513          	li	a0,32
    80005a50:	00000097          	auipc	ra,0x0
    80005a54:	572080e7          	jalr	1394(ra) # 80005fc2 <uartputc_sync>
    80005a58:	4521                	li	a0,8
    80005a5a:	00000097          	auipc	ra,0x0
    80005a5e:	568080e7          	jalr	1384(ra) # 80005fc2 <uartputc_sync>
    80005a62:	bfe1                	j	80005a3a <consputc+0x18>

0000000080005a64 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005a64:	7179                	addi	sp,sp,-48
    80005a66:	f406                	sd	ra,40(sp)
    80005a68:	f022                	sd	s0,32(sp)
    80005a6a:	ec26                	sd	s1,24(sp)
    80005a6c:	1800                	addi	s0,sp,48
    80005a6e:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005a70:	00020517          	auipc	a0,0x20
    80005a74:	6d050513          	addi	a0,a0,1744 # 80026140 <cons>
    80005a78:	00000097          	auipc	ra,0x0
    80005a7c:	7ea080e7          	jalr	2026(ra) # 80006262 <acquire>

  switch(c){
    80005a80:	47d5                	li	a5,21
    80005a82:	0af48463          	beq	s1,a5,80005b2a <consoleintr+0xc6>
    80005a86:	0297c963          	blt	a5,s1,80005ab8 <consoleintr+0x54>
    80005a8a:	47a1                	li	a5,8
    80005a8c:	10f48063          	beq	s1,a5,80005b8c <consoleintr+0x128>
    80005a90:	47c1                	li	a5,16
    80005a92:	12f49363          	bne	s1,a5,80005bb8 <consoleintr+0x154>
  case C('P'):  // Print process list.
    procdump();
    80005a96:	ffffc097          	auipc	ra,0xffffc
    80005a9a:	eee080e7          	jalr	-274(ra) # 80001984 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005a9e:	00020517          	auipc	a0,0x20
    80005aa2:	6a250513          	addi	a0,a0,1698 # 80026140 <cons>
    80005aa6:	00001097          	auipc	ra,0x1
    80005aaa:	86c080e7          	jalr	-1940(ra) # 80006312 <release>
}
    80005aae:	70a2                	ld	ra,40(sp)
    80005ab0:	7402                	ld	s0,32(sp)
    80005ab2:	64e2                	ld	s1,24(sp)
    80005ab4:	6145                	addi	sp,sp,48
    80005ab6:	8082                	ret
  switch(c){
    80005ab8:	07f00793          	li	a5,127
    80005abc:	0cf48863          	beq	s1,a5,80005b8c <consoleintr+0x128>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005ac0:	00020717          	auipc	a4,0x20
    80005ac4:	68070713          	addi	a4,a4,1664 # 80026140 <cons>
    80005ac8:	0a072783          	lw	a5,160(a4)
    80005acc:	09872703          	lw	a4,152(a4)
    80005ad0:	9f99                	subw	a5,a5,a4
    80005ad2:	07f00713          	li	a4,127
    80005ad6:	fcf764e3          	bltu	a4,a5,80005a9e <consoleintr+0x3a>
      c = (c == '\r') ? '\n' : c;
    80005ada:	47b5                	li	a5,13
    80005adc:	0ef48163          	beq	s1,a5,80005bbe <consoleintr+0x15a>
      consputc(c);
    80005ae0:	8526                	mv	a0,s1
    80005ae2:	00000097          	auipc	ra,0x0
    80005ae6:	f40080e7          	jalr	-192(ra) # 80005a22 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005aea:	00020797          	auipc	a5,0x20
    80005aee:	65678793          	addi	a5,a5,1622 # 80026140 <cons>
    80005af2:	0a07a703          	lw	a4,160(a5)
    80005af6:	0017069b          	addiw	a3,a4,1
    80005afa:	8636                	mv	a2,a3
    80005afc:	0ad7a023          	sw	a3,160(a5)
    80005b00:	07f77713          	andi	a4,a4,127
    80005b04:	97ba                	add	a5,a5,a4
    80005b06:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005b0a:	47a9                	li	a5,10
    80005b0c:	0cf48f63          	beq	s1,a5,80005bea <consoleintr+0x186>
    80005b10:	4791                	li	a5,4
    80005b12:	0cf48c63          	beq	s1,a5,80005bea <consoleintr+0x186>
    80005b16:	00020797          	auipc	a5,0x20
    80005b1a:	6c27a783          	lw	a5,1730(a5) # 800261d8 <cons+0x98>
    80005b1e:	0807879b          	addiw	a5,a5,128
    80005b22:	f6f69ee3          	bne	a3,a5,80005a9e <consoleintr+0x3a>
    80005b26:	863e                	mv	a2,a5
    80005b28:	a0c9                	j	80005bea <consoleintr+0x186>
    80005b2a:	e84a                	sd	s2,16(sp)
    80005b2c:	e44e                	sd	s3,8(sp)
    while(cons.e != cons.w &&
    80005b2e:	00020717          	auipc	a4,0x20
    80005b32:	61270713          	addi	a4,a4,1554 # 80026140 <cons>
    80005b36:	0a072783          	lw	a5,160(a4)
    80005b3a:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005b3e:	00020497          	auipc	s1,0x20
    80005b42:	60248493          	addi	s1,s1,1538 # 80026140 <cons>
    while(cons.e != cons.w &&
    80005b46:	4929                	li	s2,10
      consputc(BACKSPACE);
    80005b48:	10000993          	li	s3,256
    while(cons.e != cons.w &&
    80005b4c:	02f70a63          	beq	a4,a5,80005b80 <consoleintr+0x11c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005b50:	37fd                	addiw	a5,a5,-1
    80005b52:	07f7f713          	andi	a4,a5,127
    80005b56:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005b58:	01874703          	lbu	a4,24(a4)
    80005b5c:	03270563          	beq	a4,s2,80005b86 <consoleintr+0x122>
      cons.e--;
    80005b60:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005b64:	854e                	mv	a0,s3
    80005b66:	00000097          	auipc	ra,0x0
    80005b6a:	ebc080e7          	jalr	-324(ra) # 80005a22 <consputc>
    while(cons.e != cons.w &&
    80005b6e:	0a04a783          	lw	a5,160(s1)
    80005b72:	09c4a703          	lw	a4,156(s1)
    80005b76:	fcf71de3          	bne	a4,a5,80005b50 <consoleintr+0xec>
    80005b7a:	6942                	ld	s2,16(sp)
    80005b7c:	69a2                	ld	s3,8(sp)
    80005b7e:	b705                	j	80005a9e <consoleintr+0x3a>
    80005b80:	6942                	ld	s2,16(sp)
    80005b82:	69a2                	ld	s3,8(sp)
    80005b84:	bf29                	j	80005a9e <consoleintr+0x3a>
    80005b86:	6942                	ld	s2,16(sp)
    80005b88:	69a2                	ld	s3,8(sp)
    80005b8a:	bf11                	j	80005a9e <consoleintr+0x3a>
    if(cons.e != cons.w){
    80005b8c:	00020717          	auipc	a4,0x20
    80005b90:	5b470713          	addi	a4,a4,1460 # 80026140 <cons>
    80005b94:	0a072783          	lw	a5,160(a4)
    80005b98:	09c72703          	lw	a4,156(a4)
    80005b9c:	f0f701e3          	beq	a4,a5,80005a9e <consoleintr+0x3a>
      cons.e--;
    80005ba0:	37fd                	addiw	a5,a5,-1
    80005ba2:	00020717          	auipc	a4,0x20
    80005ba6:	62f72f23          	sw	a5,1598(a4) # 800261e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005baa:	10000513          	li	a0,256
    80005bae:	00000097          	auipc	ra,0x0
    80005bb2:	e74080e7          	jalr	-396(ra) # 80005a22 <consputc>
    80005bb6:	b5e5                	j	80005a9e <consoleintr+0x3a>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005bb8:	ee0483e3          	beqz	s1,80005a9e <consoleintr+0x3a>
    80005bbc:	b711                	j	80005ac0 <consoleintr+0x5c>
      consputc(c);
    80005bbe:	4529                	li	a0,10
    80005bc0:	00000097          	auipc	ra,0x0
    80005bc4:	e62080e7          	jalr	-414(ra) # 80005a22 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005bc8:	00020797          	auipc	a5,0x20
    80005bcc:	57878793          	addi	a5,a5,1400 # 80026140 <cons>
    80005bd0:	0a07a703          	lw	a4,160(a5)
    80005bd4:	0017069b          	addiw	a3,a4,1
    80005bd8:	8636                	mv	a2,a3
    80005bda:	0ad7a023          	sw	a3,160(a5)
    80005bde:	07f77713          	andi	a4,a4,127
    80005be2:	97ba                	add	a5,a5,a4
    80005be4:	4729                	li	a4,10
    80005be6:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005bea:	00020797          	auipc	a5,0x20
    80005bee:	5ec7a923          	sw	a2,1522(a5) # 800261dc <cons+0x9c>
        wakeup(&cons.r);
    80005bf2:	00020517          	auipc	a0,0x20
    80005bf6:	5e650513          	addi	a0,a0,1510 # 800261d8 <cons+0x98>
    80005bfa:	ffffc097          	auipc	ra,0xffffc
    80005bfe:	ac6080e7          	jalr	-1338(ra) # 800016c0 <wakeup>
    80005c02:	bd71                	j	80005a9e <consoleintr+0x3a>

0000000080005c04 <consoleinit>:

void
consoleinit(void)
{
    80005c04:	1141                	addi	sp,sp,-16
    80005c06:	e406                	sd	ra,8(sp)
    80005c08:	e022                	sd	s0,0(sp)
    80005c0a:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005c0c:	00003597          	auipc	a1,0x3
    80005c10:	a8c58593          	addi	a1,a1,-1396 # 80008698 <etext+0x698>
    80005c14:	00020517          	auipc	a0,0x20
    80005c18:	52c50513          	addi	a0,a0,1324 # 80026140 <cons>
    80005c1c:	00000097          	auipc	ra,0x0
    80005c20:	5b2080e7          	jalr	1458(ra) # 800061ce <initlock>

  uartinit();
    80005c24:	00000097          	auipc	ra,0x0
    80005c28:	344080e7          	jalr	836(ra) # 80005f68 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005c2c:	00013797          	auipc	a5,0x13
    80005c30:	49c78793          	addi	a5,a5,1180 # 800190c8 <devsw>
    80005c34:	00000717          	auipc	a4,0x0
    80005c38:	cd470713          	addi	a4,a4,-812 # 80005908 <consoleread>
    80005c3c:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005c3e:	00000717          	auipc	a4,0x0
    80005c42:	c4c70713          	addi	a4,a4,-948 # 8000588a <consolewrite>
    80005c46:	ef98                	sd	a4,24(a5)
}
    80005c48:	60a2                	ld	ra,8(sp)
    80005c4a:	6402                	ld	s0,0(sp)
    80005c4c:	0141                	addi	sp,sp,16
    80005c4e:	8082                	ret

0000000080005c50 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005c50:	7179                	addi	sp,sp,-48
    80005c52:	f406                	sd	ra,40(sp)
    80005c54:	f022                	sd	s0,32(sp)
    80005c56:	ec26                	sd	s1,24(sp)
    80005c58:	e84a                	sd	s2,16(sp)
    80005c5a:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005c5c:	c219                	beqz	a2,80005c62 <printint+0x12>
    80005c5e:	06054e63          	bltz	a0,80005cda <printint+0x8a>
    x = -xx;
  else
    x = xx;
    80005c62:	4e01                	li	t3,0

  i = 0;
    80005c64:	fd040313          	addi	t1,s0,-48
    x = xx;
    80005c68:	869a                	mv	a3,t1
  i = 0;
    80005c6a:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    80005c6c:	00003817          	auipc	a6,0x3
    80005c70:	b8c80813          	addi	a6,a6,-1140 # 800087f8 <digits>
    80005c74:	88be                	mv	a7,a5
    80005c76:	0017861b          	addiw	a2,a5,1
    80005c7a:	87b2                	mv	a5,a2
    80005c7c:	02b5773b          	remuw	a4,a0,a1
    80005c80:	1702                	slli	a4,a4,0x20
    80005c82:	9301                	srli	a4,a4,0x20
    80005c84:	9742                	add	a4,a4,a6
    80005c86:	00074703          	lbu	a4,0(a4)
    80005c8a:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    80005c8e:	872a                	mv	a4,a0
    80005c90:	02b5553b          	divuw	a0,a0,a1
    80005c94:	0685                	addi	a3,a3,1
    80005c96:	fcb77fe3          	bgeu	a4,a1,80005c74 <printint+0x24>

  if(sign)
    80005c9a:	000e0c63          	beqz	t3,80005cb2 <printint+0x62>
    buf[i++] = '-';
    80005c9e:	fe060793          	addi	a5,a2,-32
    80005ca2:	00878633          	add	a2,a5,s0
    80005ca6:	02d00793          	li	a5,45
    80005caa:	fef60823          	sb	a5,-16(a2)
    80005cae:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
    80005cb2:	fff7891b          	addiw	s2,a5,-1
    80005cb6:	006784b3          	add	s1,a5,t1
    consputc(buf[i]);
    80005cba:	fff4c503          	lbu	a0,-1(s1)
    80005cbe:	00000097          	auipc	ra,0x0
    80005cc2:	d64080e7          	jalr	-668(ra) # 80005a22 <consputc>
  while(--i >= 0)
    80005cc6:	397d                	addiw	s2,s2,-1
    80005cc8:	14fd                	addi	s1,s1,-1
    80005cca:	fe0958e3          	bgez	s2,80005cba <printint+0x6a>
}
    80005cce:	70a2                	ld	ra,40(sp)
    80005cd0:	7402                	ld	s0,32(sp)
    80005cd2:	64e2                	ld	s1,24(sp)
    80005cd4:	6942                	ld	s2,16(sp)
    80005cd6:	6145                	addi	sp,sp,48
    80005cd8:	8082                	ret
    x = -xx;
    80005cda:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005cde:	4e05                	li	t3,1
    x = -xx;
    80005ce0:	b751                	j	80005c64 <printint+0x14>

0000000080005ce2 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005ce2:	1101                	addi	sp,sp,-32
    80005ce4:	ec06                	sd	ra,24(sp)
    80005ce6:	e822                	sd	s0,16(sp)
    80005ce8:	e426                	sd	s1,8(sp)
    80005cea:	1000                	addi	s0,sp,32
    80005cec:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005cee:	00020797          	auipc	a5,0x20
    80005cf2:	5007a923          	sw	zero,1298(a5) # 80026200 <pr+0x18>
  printf("panic: ");
    80005cf6:	00003517          	auipc	a0,0x3
    80005cfa:	9aa50513          	addi	a0,a0,-1622 # 800086a0 <etext+0x6a0>
    80005cfe:	00000097          	auipc	ra,0x0
    80005d02:	02e080e7          	jalr	46(ra) # 80005d2c <printf>
  printf(s);
    80005d06:	8526                	mv	a0,s1
    80005d08:	00000097          	auipc	ra,0x0
    80005d0c:	024080e7          	jalr	36(ra) # 80005d2c <printf>
  printf("\n");
    80005d10:	00002517          	auipc	a0,0x2
    80005d14:	30850513          	addi	a0,a0,776 # 80008018 <etext+0x18>
    80005d18:	00000097          	auipc	ra,0x0
    80005d1c:	014080e7          	jalr	20(ra) # 80005d2c <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005d20:	4785                	li	a5,1
    80005d22:	00003717          	auipc	a4,0x3
    80005d26:	2ef72d23          	sw	a5,762(a4) # 8000901c <panicked>
  for(;;)
    80005d2a:	a001                	j	80005d2a <panic+0x48>

0000000080005d2c <printf>:
{
    80005d2c:	7131                	addi	sp,sp,-192
    80005d2e:	fc86                	sd	ra,120(sp)
    80005d30:	f8a2                	sd	s0,112(sp)
    80005d32:	e8d2                	sd	s4,80(sp)
    80005d34:	ec6e                	sd	s11,24(sp)
    80005d36:	0100                	addi	s0,sp,128
    80005d38:	8a2a                	mv	s4,a0
    80005d3a:	e40c                	sd	a1,8(s0)
    80005d3c:	e810                	sd	a2,16(s0)
    80005d3e:	ec14                	sd	a3,24(s0)
    80005d40:	f018                	sd	a4,32(s0)
    80005d42:	f41c                	sd	a5,40(s0)
    80005d44:	03043823          	sd	a6,48(s0)
    80005d48:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005d4c:	00020d97          	auipc	s11,0x20
    80005d50:	4b4dad83          	lw	s11,1204(s11) # 80026200 <pr+0x18>
  if(locking)
    80005d54:	040d9463          	bnez	s11,80005d9c <printf+0x70>
  if (fmt == 0)
    80005d58:	040a0b63          	beqz	s4,80005dae <printf+0x82>
  va_start(ap, fmt);
    80005d5c:	00840793          	addi	a5,s0,8
    80005d60:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005d64:	000a4503          	lbu	a0,0(s4)
    80005d68:	18050c63          	beqz	a0,80005f00 <printf+0x1d4>
    80005d6c:	f4a6                	sd	s1,104(sp)
    80005d6e:	f0ca                	sd	s2,96(sp)
    80005d70:	ecce                	sd	s3,88(sp)
    80005d72:	e4d6                	sd	s5,72(sp)
    80005d74:	e0da                	sd	s6,64(sp)
    80005d76:	fc5e                	sd	s7,56(sp)
    80005d78:	f862                	sd	s8,48(sp)
    80005d7a:	f466                	sd	s9,40(sp)
    80005d7c:	f06a                	sd	s10,32(sp)
    80005d7e:	4981                	li	s3,0
    if(c != '%'){
    80005d80:	02500b13          	li	s6,37
    switch(c){
    80005d84:	07000b93          	li	s7,112
  consputc('x');
    80005d88:	07800c93          	li	s9,120
    80005d8c:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005d8e:	00003a97          	auipc	s5,0x3
    80005d92:	a6aa8a93          	addi	s5,s5,-1430 # 800087f8 <digits>
    switch(c){
    80005d96:	07300c13          	li	s8,115
    80005d9a:	a0b9                	j	80005de8 <printf+0xbc>
    acquire(&pr.lock);
    80005d9c:	00020517          	auipc	a0,0x20
    80005da0:	44c50513          	addi	a0,a0,1100 # 800261e8 <pr>
    80005da4:	00000097          	auipc	ra,0x0
    80005da8:	4be080e7          	jalr	1214(ra) # 80006262 <acquire>
    80005dac:	b775                	j	80005d58 <printf+0x2c>
    80005dae:	f4a6                	sd	s1,104(sp)
    80005db0:	f0ca                	sd	s2,96(sp)
    80005db2:	ecce                	sd	s3,88(sp)
    80005db4:	e4d6                	sd	s5,72(sp)
    80005db6:	e0da                	sd	s6,64(sp)
    80005db8:	fc5e                	sd	s7,56(sp)
    80005dba:	f862                	sd	s8,48(sp)
    80005dbc:	f466                	sd	s9,40(sp)
    80005dbe:	f06a                	sd	s10,32(sp)
    panic("null fmt");
    80005dc0:	00003517          	auipc	a0,0x3
    80005dc4:	8f050513          	addi	a0,a0,-1808 # 800086b0 <etext+0x6b0>
    80005dc8:	00000097          	auipc	ra,0x0
    80005dcc:	f1a080e7          	jalr	-230(ra) # 80005ce2 <panic>
      consputc(c);
    80005dd0:	00000097          	auipc	ra,0x0
    80005dd4:	c52080e7          	jalr	-942(ra) # 80005a22 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005dd8:	0019879b          	addiw	a5,s3,1
    80005ddc:	89be                	mv	s3,a5
    80005dde:	97d2                	add	a5,a5,s4
    80005de0:	0007c503          	lbu	a0,0(a5)
    80005de4:	10050563          	beqz	a0,80005eee <printf+0x1c2>
    if(c != '%'){
    80005de8:	ff6514e3          	bne	a0,s6,80005dd0 <printf+0xa4>
    c = fmt[++i] & 0xff;
    80005dec:	0019879b          	addiw	a5,s3,1
    80005df0:	89be                	mv	s3,a5
    80005df2:	97d2                	add	a5,a5,s4
    80005df4:	0007c783          	lbu	a5,0(a5)
    80005df8:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005dfc:	10078a63          	beqz	a5,80005f10 <printf+0x1e4>
    switch(c){
    80005e00:	05778a63          	beq	a5,s7,80005e54 <printf+0x128>
    80005e04:	02fbf463          	bgeu	s7,a5,80005e2c <printf+0x100>
    80005e08:	09878763          	beq	a5,s8,80005e96 <printf+0x16a>
    80005e0c:	0d979663          	bne	a5,s9,80005ed8 <printf+0x1ac>
      printint(va_arg(ap, int), 16, 1);
    80005e10:	f8843783          	ld	a5,-120(s0)
    80005e14:	00878713          	addi	a4,a5,8
    80005e18:	f8e43423          	sd	a4,-120(s0)
    80005e1c:	4605                	li	a2,1
    80005e1e:	85ea                	mv	a1,s10
    80005e20:	4388                	lw	a0,0(a5)
    80005e22:	00000097          	auipc	ra,0x0
    80005e26:	e2e080e7          	jalr	-466(ra) # 80005c50 <printint>
      break;
    80005e2a:	b77d                	j	80005dd8 <printf+0xac>
    switch(c){
    80005e2c:	0b678063          	beq	a5,s6,80005ecc <printf+0x1a0>
    80005e30:	06400713          	li	a4,100
    80005e34:	0ae79263          	bne	a5,a4,80005ed8 <printf+0x1ac>
      printint(va_arg(ap, int), 10, 1);
    80005e38:	f8843783          	ld	a5,-120(s0)
    80005e3c:	00878713          	addi	a4,a5,8
    80005e40:	f8e43423          	sd	a4,-120(s0)
    80005e44:	4605                	li	a2,1
    80005e46:	45a9                	li	a1,10
    80005e48:	4388                	lw	a0,0(a5)
    80005e4a:	00000097          	auipc	ra,0x0
    80005e4e:	e06080e7          	jalr	-506(ra) # 80005c50 <printint>
      break;
    80005e52:	b759                	j	80005dd8 <printf+0xac>
      printptr(va_arg(ap, uint64));
    80005e54:	f8843783          	ld	a5,-120(s0)
    80005e58:	00878713          	addi	a4,a5,8
    80005e5c:	f8e43423          	sd	a4,-120(s0)
    80005e60:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005e64:	03000513          	li	a0,48
    80005e68:	00000097          	auipc	ra,0x0
    80005e6c:	bba080e7          	jalr	-1094(ra) # 80005a22 <consputc>
  consputc('x');
    80005e70:	8566                	mv	a0,s9
    80005e72:	00000097          	auipc	ra,0x0
    80005e76:	bb0080e7          	jalr	-1104(ra) # 80005a22 <consputc>
    80005e7a:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005e7c:	03c95793          	srli	a5,s2,0x3c
    80005e80:	97d6                	add	a5,a5,s5
    80005e82:	0007c503          	lbu	a0,0(a5)
    80005e86:	00000097          	auipc	ra,0x0
    80005e8a:	b9c080e7          	jalr	-1124(ra) # 80005a22 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005e8e:	0912                	slli	s2,s2,0x4
    80005e90:	34fd                	addiw	s1,s1,-1
    80005e92:	f4ed                	bnez	s1,80005e7c <printf+0x150>
    80005e94:	b791                	j	80005dd8 <printf+0xac>
      if((s = va_arg(ap, char*)) == 0)
    80005e96:	f8843783          	ld	a5,-120(s0)
    80005e9a:	00878713          	addi	a4,a5,8
    80005e9e:	f8e43423          	sd	a4,-120(s0)
    80005ea2:	6384                	ld	s1,0(a5)
    80005ea4:	cc89                	beqz	s1,80005ebe <printf+0x192>
      for(; *s; s++)
    80005ea6:	0004c503          	lbu	a0,0(s1)
    80005eaa:	d51d                	beqz	a0,80005dd8 <printf+0xac>
        consputc(*s);
    80005eac:	00000097          	auipc	ra,0x0
    80005eb0:	b76080e7          	jalr	-1162(ra) # 80005a22 <consputc>
      for(; *s; s++)
    80005eb4:	0485                	addi	s1,s1,1
    80005eb6:	0004c503          	lbu	a0,0(s1)
    80005eba:	f96d                	bnez	a0,80005eac <printf+0x180>
    80005ebc:	bf31                	j	80005dd8 <printf+0xac>
        s = "(null)";
    80005ebe:	00002497          	auipc	s1,0x2
    80005ec2:	7ea48493          	addi	s1,s1,2026 # 800086a8 <etext+0x6a8>
      for(; *s; s++)
    80005ec6:	02800513          	li	a0,40
    80005eca:	b7cd                	j	80005eac <printf+0x180>
      consputc('%');
    80005ecc:	855a                	mv	a0,s6
    80005ece:	00000097          	auipc	ra,0x0
    80005ed2:	b54080e7          	jalr	-1196(ra) # 80005a22 <consputc>
      break;
    80005ed6:	b709                	j	80005dd8 <printf+0xac>
      consputc('%');
    80005ed8:	855a                	mv	a0,s6
    80005eda:	00000097          	auipc	ra,0x0
    80005ede:	b48080e7          	jalr	-1208(ra) # 80005a22 <consputc>
      consputc(c);
    80005ee2:	8526                	mv	a0,s1
    80005ee4:	00000097          	auipc	ra,0x0
    80005ee8:	b3e080e7          	jalr	-1218(ra) # 80005a22 <consputc>
      break;
    80005eec:	b5f5                	j	80005dd8 <printf+0xac>
    80005eee:	74a6                	ld	s1,104(sp)
    80005ef0:	7906                	ld	s2,96(sp)
    80005ef2:	69e6                	ld	s3,88(sp)
    80005ef4:	6aa6                	ld	s5,72(sp)
    80005ef6:	6b06                	ld	s6,64(sp)
    80005ef8:	7be2                	ld	s7,56(sp)
    80005efa:	7c42                	ld	s8,48(sp)
    80005efc:	7ca2                	ld	s9,40(sp)
    80005efe:	7d02                	ld	s10,32(sp)
  if(locking)
    80005f00:	020d9263          	bnez	s11,80005f24 <printf+0x1f8>
}
    80005f04:	70e6                	ld	ra,120(sp)
    80005f06:	7446                	ld	s0,112(sp)
    80005f08:	6a46                	ld	s4,80(sp)
    80005f0a:	6de2                	ld	s11,24(sp)
    80005f0c:	6129                	addi	sp,sp,192
    80005f0e:	8082                	ret
    80005f10:	74a6                	ld	s1,104(sp)
    80005f12:	7906                	ld	s2,96(sp)
    80005f14:	69e6                	ld	s3,88(sp)
    80005f16:	6aa6                	ld	s5,72(sp)
    80005f18:	6b06                	ld	s6,64(sp)
    80005f1a:	7be2                	ld	s7,56(sp)
    80005f1c:	7c42                	ld	s8,48(sp)
    80005f1e:	7ca2                	ld	s9,40(sp)
    80005f20:	7d02                	ld	s10,32(sp)
    80005f22:	bff9                	j	80005f00 <printf+0x1d4>
    release(&pr.lock);
    80005f24:	00020517          	auipc	a0,0x20
    80005f28:	2c450513          	addi	a0,a0,708 # 800261e8 <pr>
    80005f2c:	00000097          	auipc	ra,0x0
    80005f30:	3e6080e7          	jalr	998(ra) # 80006312 <release>
}
    80005f34:	bfc1                	j	80005f04 <printf+0x1d8>

0000000080005f36 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005f36:	1101                	addi	sp,sp,-32
    80005f38:	ec06                	sd	ra,24(sp)
    80005f3a:	e822                	sd	s0,16(sp)
    80005f3c:	e426                	sd	s1,8(sp)
    80005f3e:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005f40:	00020497          	auipc	s1,0x20
    80005f44:	2a848493          	addi	s1,s1,680 # 800261e8 <pr>
    80005f48:	00002597          	auipc	a1,0x2
    80005f4c:	77858593          	addi	a1,a1,1912 # 800086c0 <etext+0x6c0>
    80005f50:	8526                	mv	a0,s1
    80005f52:	00000097          	auipc	ra,0x0
    80005f56:	27c080e7          	jalr	636(ra) # 800061ce <initlock>
  pr.locking = 1;
    80005f5a:	4785                	li	a5,1
    80005f5c:	cc9c                	sw	a5,24(s1)
}
    80005f5e:	60e2                	ld	ra,24(sp)
    80005f60:	6442                	ld	s0,16(sp)
    80005f62:	64a2                	ld	s1,8(sp)
    80005f64:	6105                	addi	sp,sp,32
    80005f66:	8082                	ret

0000000080005f68 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005f68:	1141                	addi	sp,sp,-16
    80005f6a:	e406                	sd	ra,8(sp)
    80005f6c:	e022                	sd	s0,0(sp)
    80005f6e:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005f70:	100007b7          	lui	a5,0x10000
    80005f74:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005f78:	10000737          	lui	a4,0x10000
    80005f7c:	f8000693          	li	a3,-128
    80005f80:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005f84:	468d                	li	a3,3
    80005f86:	10000637          	lui	a2,0x10000
    80005f8a:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005f8e:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005f92:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005f96:	8732                	mv	a4,a2
    80005f98:	461d                	li	a2,7
    80005f9a:	00c70123          	sb	a2,2(a4)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005f9e:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005fa2:	00002597          	auipc	a1,0x2
    80005fa6:	72658593          	addi	a1,a1,1830 # 800086c8 <etext+0x6c8>
    80005faa:	00020517          	auipc	a0,0x20
    80005fae:	25e50513          	addi	a0,a0,606 # 80026208 <uart_tx_lock>
    80005fb2:	00000097          	auipc	ra,0x0
    80005fb6:	21c080e7          	jalr	540(ra) # 800061ce <initlock>
}
    80005fba:	60a2                	ld	ra,8(sp)
    80005fbc:	6402                	ld	s0,0(sp)
    80005fbe:	0141                	addi	sp,sp,16
    80005fc0:	8082                	ret

0000000080005fc2 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005fc2:	1101                	addi	sp,sp,-32
    80005fc4:	ec06                	sd	ra,24(sp)
    80005fc6:	e822                	sd	s0,16(sp)
    80005fc8:	e426                	sd	s1,8(sp)
    80005fca:	1000                	addi	s0,sp,32
    80005fcc:	84aa                	mv	s1,a0
  push_off();
    80005fce:	00000097          	auipc	ra,0x0
    80005fd2:	248080e7          	jalr	584(ra) # 80006216 <push_off>

  if(panicked){
    80005fd6:	00003797          	auipc	a5,0x3
    80005fda:	0467a783          	lw	a5,70(a5) # 8000901c <panicked>
    80005fde:	eb85                	bnez	a5,8000600e <uartputc_sync+0x4c>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005fe0:	10000737          	lui	a4,0x10000
    80005fe4:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80005fe6:	00074783          	lbu	a5,0(a4)
    80005fea:	0207f793          	andi	a5,a5,32
    80005fee:	dfe5                	beqz	a5,80005fe6 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80005ff0:	0ff4f513          	zext.b	a0,s1
    80005ff4:	100007b7          	lui	a5,0x10000
    80005ff8:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80005ffc:	00000097          	auipc	ra,0x0
    80006000:	2ba080e7          	jalr	698(ra) # 800062b6 <pop_off>
}
    80006004:	60e2                	ld	ra,24(sp)
    80006006:	6442                	ld	s0,16(sp)
    80006008:	64a2                	ld	s1,8(sp)
    8000600a:	6105                	addi	sp,sp,32
    8000600c:	8082                	ret
    for(;;)
    8000600e:	a001                	j	8000600e <uartputc_sync+0x4c>

0000000080006010 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80006010:	00003797          	auipc	a5,0x3
    80006014:	0107b783          	ld	a5,16(a5) # 80009020 <uart_tx_r>
    80006018:	00003717          	auipc	a4,0x3
    8000601c:	01073703          	ld	a4,16(a4) # 80009028 <uart_tx_w>
    80006020:	06f70f63          	beq	a4,a5,8000609e <uartstart+0x8e>
{
    80006024:	7139                	addi	sp,sp,-64
    80006026:	fc06                	sd	ra,56(sp)
    80006028:	f822                	sd	s0,48(sp)
    8000602a:	f426                	sd	s1,40(sp)
    8000602c:	f04a                	sd	s2,32(sp)
    8000602e:	ec4e                	sd	s3,24(sp)
    80006030:	e852                	sd	s4,16(sp)
    80006032:	e456                	sd	s5,8(sp)
    80006034:	e05a                	sd	s6,0(sp)
    80006036:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006038:	10000937          	lui	s2,0x10000
    8000603c:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000603e:	00020a97          	auipc	s5,0x20
    80006042:	1caa8a93          	addi	s5,s5,458 # 80026208 <uart_tx_lock>
    uart_tx_r += 1;
    80006046:	00003497          	auipc	s1,0x3
    8000604a:	fda48493          	addi	s1,s1,-38 # 80009020 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    8000604e:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    80006052:	00003997          	auipc	s3,0x3
    80006056:	fd698993          	addi	s3,s3,-42 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000605a:	00094703          	lbu	a4,0(s2)
    8000605e:	02077713          	andi	a4,a4,32
    80006062:	c705                	beqz	a4,8000608a <uartstart+0x7a>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006064:	01f7f713          	andi	a4,a5,31
    80006068:	9756                	add	a4,a4,s5
    8000606a:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    8000606e:	0785                	addi	a5,a5,1
    80006070:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    80006072:	8526                	mv	a0,s1
    80006074:	ffffb097          	auipc	ra,0xffffb
    80006078:	64c080e7          	jalr	1612(ra) # 800016c0 <wakeup>
    WriteReg(THR, c);
    8000607c:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    80006080:	609c                	ld	a5,0(s1)
    80006082:	0009b703          	ld	a4,0(s3)
    80006086:	fcf71ae3          	bne	a4,a5,8000605a <uartstart+0x4a>
  }
}
    8000608a:	70e2                	ld	ra,56(sp)
    8000608c:	7442                	ld	s0,48(sp)
    8000608e:	74a2                	ld	s1,40(sp)
    80006090:	7902                	ld	s2,32(sp)
    80006092:	69e2                	ld	s3,24(sp)
    80006094:	6a42                	ld	s4,16(sp)
    80006096:	6aa2                	ld	s5,8(sp)
    80006098:	6b02                	ld	s6,0(sp)
    8000609a:	6121                	addi	sp,sp,64
    8000609c:	8082                	ret
    8000609e:	8082                	ret

00000000800060a0 <uartputc>:
{
    800060a0:	7179                	addi	sp,sp,-48
    800060a2:	f406                	sd	ra,40(sp)
    800060a4:	f022                	sd	s0,32(sp)
    800060a6:	e052                	sd	s4,0(sp)
    800060a8:	1800                	addi	s0,sp,48
    800060aa:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800060ac:	00020517          	auipc	a0,0x20
    800060b0:	15c50513          	addi	a0,a0,348 # 80026208 <uart_tx_lock>
    800060b4:	00000097          	auipc	ra,0x0
    800060b8:	1ae080e7          	jalr	430(ra) # 80006262 <acquire>
  if(panicked){
    800060bc:	00003797          	auipc	a5,0x3
    800060c0:	f607a783          	lw	a5,-160(a5) # 8000901c <panicked>
    800060c4:	c391                	beqz	a5,800060c8 <uartputc+0x28>
    for(;;)
    800060c6:	a001                	j	800060c6 <uartputc+0x26>
    800060c8:	ec26                	sd	s1,24(sp)
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800060ca:	00003717          	auipc	a4,0x3
    800060ce:	f5e73703          	ld	a4,-162(a4) # 80009028 <uart_tx_w>
    800060d2:	00003797          	auipc	a5,0x3
    800060d6:	f4e7b783          	ld	a5,-178(a5) # 80009020 <uart_tx_r>
    800060da:	02078793          	addi	a5,a5,32
    800060de:	02e79f63          	bne	a5,a4,8000611c <uartputc+0x7c>
    800060e2:	e84a                	sd	s2,16(sp)
    800060e4:	e44e                	sd	s3,8(sp)
      sleep(&uart_tx_r, &uart_tx_lock);
    800060e6:	00020997          	auipc	s3,0x20
    800060ea:	12298993          	addi	s3,s3,290 # 80026208 <uart_tx_lock>
    800060ee:	00003497          	auipc	s1,0x3
    800060f2:	f3248493          	addi	s1,s1,-206 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800060f6:	00003917          	auipc	s2,0x3
    800060fa:	f3290913          	addi	s2,s2,-206 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    800060fe:	85ce                	mv	a1,s3
    80006100:	8526                	mv	a0,s1
    80006102:	ffffb097          	auipc	ra,0xffffb
    80006106:	438080e7          	jalr	1080(ra) # 8000153a <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000610a:	00093703          	ld	a4,0(s2)
    8000610e:	609c                	ld	a5,0(s1)
    80006110:	02078793          	addi	a5,a5,32
    80006114:	fee785e3          	beq	a5,a4,800060fe <uartputc+0x5e>
    80006118:	6942                	ld	s2,16(sp)
    8000611a:	69a2                	ld	s3,8(sp)
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    8000611c:	00020497          	auipc	s1,0x20
    80006120:	0ec48493          	addi	s1,s1,236 # 80026208 <uart_tx_lock>
    80006124:	01f77793          	andi	a5,a4,31
    80006128:	97a6                	add	a5,a5,s1
    8000612a:	01478c23          	sb	s4,24(a5)
      uart_tx_w += 1;
    8000612e:	0705                	addi	a4,a4,1
    80006130:	00003797          	auipc	a5,0x3
    80006134:	eee7bc23          	sd	a4,-264(a5) # 80009028 <uart_tx_w>
      uartstart();
    80006138:	00000097          	auipc	ra,0x0
    8000613c:	ed8080e7          	jalr	-296(ra) # 80006010 <uartstart>
      release(&uart_tx_lock);
    80006140:	8526                	mv	a0,s1
    80006142:	00000097          	auipc	ra,0x0
    80006146:	1d0080e7          	jalr	464(ra) # 80006312 <release>
    8000614a:	64e2                	ld	s1,24(sp)
}
    8000614c:	70a2                	ld	ra,40(sp)
    8000614e:	7402                	ld	s0,32(sp)
    80006150:	6a02                	ld	s4,0(sp)
    80006152:	6145                	addi	sp,sp,48
    80006154:	8082                	ret

0000000080006156 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80006156:	1141                	addi	sp,sp,-16
    80006158:	e406                	sd	ra,8(sp)
    8000615a:	e022                	sd	s0,0(sp)
    8000615c:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    8000615e:	100007b7          	lui	a5,0x10000
    80006162:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80006166:	8b85                	andi	a5,a5,1
    80006168:	cb89                	beqz	a5,8000617a <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    8000616a:	100007b7          	lui	a5,0x10000
    8000616e:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80006172:	60a2                	ld	ra,8(sp)
    80006174:	6402                	ld	s0,0(sp)
    80006176:	0141                	addi	sp,sp,16
    80006178:	8082                	ret
    return -1;
    8000617a:	557d                	li	a0,-1
    8000617c:	bfdd                	j	80006172 <uartgetc+0x1c>

000000008000617e <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    8000617e:	1101                	addi	sp,sp,-32
    80006180:	ec06                	sd	ra,24(sp)
    80006182:	e822                	sd	s0,16(sp)
    80006184:	e426                	sd	s1,8(sp)
    80006186:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80006188:	54fd                	li	s1,-1
    int c = uartgetc();
    8000618a:	00000097          	auipc	ra,0x0
    8000618e:	fcc080e7          	jalr	-52(ra) # 80006156 <uartgetc>
    if(c == -1)
    80006192:	00950763          	beq	a0,s1,800061a0 <uartintr+0x22>
      break;
    consoleintr(c);
    80006196:	00000097          	auipc	ra,0x0
    8000619a:	8ce080e7          	jalr	-1842(ra) # 80005a64 <consoleintr>
  while(1){
    8000619e:	b7f5                	j	8000618a <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800061a0:	00020497          	auipc	s1,0x20
    800061a4:	06848493          	addi	s1,s1,104 # 80026208 <uart_tx_lock>
    800061a8:	8526                	mv	a0,s1
    800061aa:	00000097          	auipc	ra,0x0
    800061ae:	0b8080e7          	jalr	184(ra) # 80006262 <acquire>
  uartstart();
    800061b2:	00000097          	auipc	ra,0x0
    800061b6:	e5e080e7          	jalr	-418(ra) # 80006010 <uartstart>
  release(&uart_tx_lock);
    800061ba:	8526                	mv	a0,s1
    800061bc:	00000097          	auipc	ra,0x0
    800061c0:	156080e7          	jalr	342(ra) # 80006312 <release>
}
    800061c4:	60e2                	ld	ra,24(sp)
    800061c6:	6442                	ld	s0,16(sp)
    800061c8:	64a2                	ld	s1,8(sp)
    800061ca:	6105                	addi	sp,sp,32
    800061cc:	8082                	ret

00000000800061ce <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    800061ce:	1141                	addi	sp,sp,-16
    800061d0:	e406                	sd	ra,8(sp)
    800061d2:	e022                	sd	s0,0(sp)
    800061d4:	0800                	addi	s0,sp,16
  lk->name = name;
    800061d6:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800061d8:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800061dc:	00053823          	sd	zero,16(a0)
}
    800061e0:	60a2                	ld	ra,8(sp)
    800061e2:	6402                	ld	s0,0(sp)
    800061e4:	0141                	addi	sp,sp,16
    800061e6:	8082                	ret

00000000800061e8 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800061e8:	411c                	lw	a5,0(a0)
    800061ea:	e399                	bnez	a5,800061f0 <holding+0x8>
    800061ec:	4501                	li	a0,0
  return r;
}
    800061ee:	8082                	ret
{
    800061f0:	1101                	addi	sp,sp,-32
    800061f2:	ec06                	sd	ra,24(sp)
    800061f4:	e822                	sd	s0,16(sp)
    800061f6:	e426                	sd	s1,8(sp)
    800061f8:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800061fa:	6904                	ld	s1,16(a0)
    800061fc:	ffffb097          	auipc	ra,0xffffb
    80006200:	c58080e7          	jalr	-936(ra) # 80000e54 <mycpu>
    80006204:	40a48533          	sub	a0,s1,a0
    80006208:	00153513          	seqz	a0,a0
}
    8000620c:	60e2                	ld	ra,24(sp)
    8000620e:	6442                	ld	s0,16(sp)
    80006210:	64a2                	ld	s1,8(sp)
    80006212:	6105                	addi	sp,sp,32
    80006214:	8082                	ret

0000000080006216 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006216:	1101                	addi	sp,sp,-32
    80006218:	ec06                	sd	ra,24(sp)
    8000621a:	e822                	sd	s0,16(sp)
    8000621c:	e426                	sd	s1,8(sp)
    8000621e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006220:	100024f3          	csrr	s1,sstatus
    80006224:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006228:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000622a:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    8000622e:	ffffb097          	auipc	ra,0xffffb
    80006232:	c26080e7          	jalr	-986(ra) # 80000e54 <mycpu>
    80006236:	5d3c                	lw	a5,120(a0)
    80006238:	cf89                	beqz	a5,80006252 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    8000623a:	ffffb097          	auipc	ra,0xffffb
    8000623e:	c1a080e7          	jalr	-998(ra) # 80000e54 <mycpu>
    80006242:	5d3c                	lw	a5,120(a0)
    80006244:	2785                	addiw	a5,a5,1
    80006246:	dd3c                	sw	a5,120(a0)
}
    80006248:	60e2                	ld	ra,24(sp)
    8000624a:	6442                	ld	s0,16(sp)
    8000624c:	64a2                	ld	s1,8(sp)
    8000624e:	6105                	addi	sp,sp,32
    80006250:	8082                	ret
    mycpu()->intena = old;
    80006252:	ffffb097          	auipc	ra,0xffffb
    80006256:	c02080e7          	jalr	-1022(ra) # 80000e54 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    8000625a:	8085                	srli	s1,s1,0x1
    8000625c:	8885                	andi	s1,s1,1
    8000625e:	dd64                	sw	s1,124(a0)
    80006260:	bfe9                	j	8000623a <push_off+0x24>

0000000080006262 <acquire>:
{
    80006262:	1101                	addi	sp,sp,-32
    80006264:	ec06                	sd	ra,24(sp)
    80006266:	e822                	sd	s0,16(sp)
    80006268:	e426                	sd	s1,8(sp)
    8000626a:	1000                	addi	s0,sp,32
    8000626c:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    8000626e:	00000097          	auipc	ra,0x0
    80006272:	fa8080e7          	jalr	-88(ra) # 80006216 <push_off>
  if(holding(lk))
    80006276:	8526                	mv	a0,s1
    80006278:	00000097          	auipc	ra,0x0
    8000627c:	f70080e7          	jalr	-144(ra) # 800061e8 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006280:	4705                	li	a4,1
  if(holding(lk))
    80006282:	e115                	bnez	a0,800062a6 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006284:	87ba                	mv	a5,a4
    80006286:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    8000628a:	2781                	sext.w	a5,a5
    8000628c:	ffe5                	bnez	a5,80006284 <acquire+0x22>
  __sync_synchronize();
    8000628e:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80006292:	ffffb097          	auipc	ra,0xffffb
    80006296:	bc2080e7          	jalr	-1086(ra) # 80000e54 <mycpu>
    8000629a:	e888                	sd	a0,16(s1)
}
    8000629c:	60e2                	ld	ra,24(sp)
    8000629e:	6442                	ld	s0,16(sp)
    800062a0:	64a2                	ld	s1,8(sp)
    800062a2:	6105                	addi	sp,sp,32
    800062a4:	8082                	ret
    panic("acquire");
    800062a6:	00002517          	auipc	a0,0x2
    800062aa:	42a50513          	addi	a0,a0,1066 # 800086d0 <etext+0x6d0>
    800062ae:	00000097          	auipc	ra,0x0
    800062b2:	a34080e7          	jalr	-1484(ra) # 80005ce2 <panic>

00000000800062b6 <pop_off>:

void
pop_off(void)
{
    800062b6:	1141                	addi	sp,sp,-16
    800062b8:	e406                	sd	ra,8(sp)
    800062ba:	e022                	sd	s0,0(sp)
    800062bc:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    800062be:	ffffb097          	auipc	ra,0xffffb
    800062c2:	b96080e7          	jalr	-1130(ra) # 80000e54 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800062c6:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800062ca:	8b89                	andi	a5,a5,2
  if(intr_get())
    800062cc:	e39d                	bnez	a5,800062f2 <pop_off+0x3c>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800062ce:	5d3c                	lw	a5,120(a0)
    800062d0:	02f05963          	blez	a5,80006302 <pop_off+0x4c>
    panic("pop_off");
  c->noff -= 1;
    800062d4:	37fd                	addiw	a5,a5,-1
    800062d6:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800062d8:	eb89                	bnez	a5,800062ea <pop_off+0x34>
    800062da:	5d7c                	lw	a5,124(a0)
    800062dc:	c799                	beqz	a5,800062ea <pop_off+0x34>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800062de:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800062e2:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800062e6:	10079073          	csrw	sstatus,a5
    intr_on();
}
    800062ea:	60a2                	ld	ra,8(sp)
    800062ec:	6402                	ld	s0,0(sp)
    800062ee:	0141                	addi	sp,sp,16
    800062f0:	8082                	ret
    panic("pop_off - interruptible");
    800062f2:	00002517          	auipc	a0,0x2
    800062f6:	3e650513          	addi	a0,a0,998 # 800086d8 <etext+0x6d8>
    800062fa:	00000097          	auipc	ra,0x0
    800062fe:	9e8080e7          	jalr	-1560(ra) # 80005ce2 <panic>
    panic("pop_off");
    80006302:	00002517          	auipc	a0,0x2
    80006306:	3ee50513          	addi	a0,a0,1006 # 800086f0 <etext+0x6f0>
    8000630a:	00000097          	auipc	ra,0x0
    8000630e:	9d8080e7          	jalr	-1576(ra) # 80005ce2 <panic>

0000000080006312 <release>:
{
    80006312:	1101                	addi	sp,sp,-32
    80006314:	ec06                	sd	ra,24(sp)
    80006316:	e822                	sd	s0,16(sp)
    80006318:	e426                	sd	s1,8(sp)
    8000631a:	1000                	addi	s0,sp,32
    8000631c:	84aa                	mv	s1,a0
  if(!holding(lk))
    8000631e:	00000097          	auipc	ra,0x0
    80006322:	eca080e7          	jalr	-310(ra) # 800061e8 <holding>
    80006326:	c115                	beqz	a0,8000634a <release+0x38>
  lk->cpu = 0;
    80006328:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    8000632c:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    80006330:	0310000f          	fence	rw,w
    80006334:	0004a023          	sw	zero,0(s1)
  pop_off();
    80006338:	00000097          	auipc	ra,0x0
    8000633c:	f7e080e7          	jalr	-130(ra) # 800062b6 <pop_off>
}
    80006340:	60e2                	ld	ra,24(sp)
    80006342:	6442                	ld	s0,16(sp)
    80006344:	64a2                	ld	s1,8(sp)
    80006346:	6105                	addi	sp,sp,32
    80006348:	8082                	ret
    panic("release");
    8000634a:	00002517          	auipc	a0,0x2
    8000634e:	3ae50513          	addi	a0,a0,942 # 800086f8 <etext+0x6f8>
    80006352:	00000097          	auipc	ra,0x0
    80006356:	990080e7          	jalr	-1648(ra) # 80005ce2 <panic>
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
