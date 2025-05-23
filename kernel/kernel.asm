
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
    8000005e:	268080e7          	jalr	616(ra) # 800062c2 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	304080e7          	jalr	772(ra) # 80006372 <release>
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
    8000008e:	ce2080e7          	jalr	-798(ra) # 80005d6c <panic>

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
    800000fa:	138080e7          	jalr	312(ra) # 8000622e <initlock>
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
    80000132:	194080e7          	jalr	404(ra) # 800062c2 <acquire>
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
    8000014a:	22c080e7          	jalr	556(ra) # 80006372 <release>

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
    80000174:	202080e7          	jalr	514(ra) # 80006372 <release>
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
    80000340:	b26080e7          	jalr	-1242(ra) # 80000e62 <cpuid>
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
    8000035c:	b0a080e7          	jalr	-1270(ra) # 80000e62 <cpuid>
    80000360:	85aa                	mv	a1,a0
    80000362:	00008517          	auipc	a0,0x8
    80000366:	cd650513          	addi	a0,a0,-810 # 80008038 <etext+0x38>
    8000036a:	00006097          	auipc	ra,0x6
    8000036e:	a54080e7          	jalr	-1452(ra) # 80005dbe <printf>
    kvminithart();    // turn on paging
    80000372:	00000097          	auipc	ra,0x0
    80000376:	0d8080e7          	jalr	216(ra) # 8000044a <kvminithart>
    trapinithart();   // install kernel trap vector
    8000037a:	00001097          	auipc	ra,0x1
    8000037e:	77a080e7          	jalr	1914(ra) # 80001af4 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000382:	00005097          	auipc	ra,0x5
    80000386:	e62080e7          	jalr	-414(ra) # 800051e4 <plicinithart>
  }

  scheduler();        
    8000038a:	00001097          	auipc	ra,0x1
    8000038e:	02c080e7          	jalr	44(ra) # 800013b6 <scheduler>
    consoleinit();
    80000392:	00006097          	auipc	ra,0x6
    80000396:	872080e7          	jalr	-1934(ra) # 80005c04 <consoleinit>
    printfinit();
    8000039a:	00006097          	auipc	ra,0x6
    8000039e:	948080e7          	jalr	-1720(ra) # 80005ce2 <printfinit>
    printf("\n");
    800003a2:	00008517          	auipc	a0,0x8
    800003a6:	c7650513          	addi	a0,a0,-906 # 80008018 <etext+0x18>
    800003aa:	00006097          	auipc	ra,0x6
    800003ae:	a14080e7          	jalr	-1516(ra) # 80005dbe <printf>
    printf("xv6 kernel is booting\n");
    800003b2:	00008517          	auipc	a0,0x8
    800003b6:	c6e50513          	addi	a0,a0,-914 # 80008020 <etext+0x20>
    800003ba:	00006097          	auipc	ra,0x6
    800003be:	a04080e7          	jalr	-1532(ra) # 80005dbe <printf>
    printf("\n");
    800003c2:	00008517          	auipc	a0,0x8
    800003c6:	c5650513          	addi	a0,a0,-938 # 80008018 <etext+0x18>
    800003ca:	00006097          	auipc	ra,0x6
    800003ce:	9f4080e7          	jalr	-1548(ra) # 80005dbe <printf>
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
    800003ee:	9c6080e7          	jalr	-1594(ra) # 80000db0 <procinit>
    trapinit();      // trap vectors
    800003f2:	00001097          	auipc	ra,0x1
    800003f6:	6da080e7          	jalr	1754(ra) # 80001acc <trapinit>
    trapinithart();  // install kernel trap vector
    800003fa:	00001097          	auipc	ra,0x1
    800003fe:	6fa080e7          	jalr	1786(ra) # 80001af4 <trapinithart>
    plicinit();      // set up interrupt controller
    80000402:	00005097          	auipc	ra,0x5
    80000406:	dc8080e7          	jalr	-568(ra) # 800051ca <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    8000040a:	00005097          	auipc	ra,0x5
    8000040e:	dda080e7          	jalr	-550(ra) # 800051e4 <plicinithart>
    binit();         // buffer cache
    80000412:	00002097          	auipc	ra,0x2
    80000416:	ea8080e7          	jalr	-344(ra) # 800022ba <binit>
    iinit();         // inode table
    8000041a:	00002097          	auipc	ra,0x2
    8000041e:	516080e7          	jalr	1302(ra) # 80002930 <iinit>
    fileinit();      // file table
    80000422:	00003097          	auipc	ra,0x3
    80000426:	4e0080e7          	jalr	1248(ra) # 80003902 <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000042a:	00005097          	auipc	ra,0x5
    8000042e:	eda080e7          	jalr	-294(ra) # 80005304 <virtio_disk_init>
    userinit();      // first user process
    80000432:	00001097          	auipc	ra,0x1
    80000436:	d48080e7          	jalr	-696(ra) # 8000117a <userinit>
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
    800004e4:	88c080e7          	jalr	-1908(ra) # 80005d6c <panic>
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
    800005ce:	7a2080e7          	jalr	1954(ra) # 80005d6c <panic>
      panic("mappages: remap");
    800005d2:	00008517          	auipc	a0,0x8
    800005d6:	a9650513          	addi	a0,a0,-1386 # 80008068 <etext+0x68>
    800005da:	00005097          	auipc	ra,0x5
    800005de:	792080e7          	jalr	1938(ra) # 80005d6c <panic>
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
    8000062c:	744080e7          	jalr	1860(ra) # 80005d6c <panic>

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
    800006ee:	622080e7          	jalr	1570(ra) # 80000d0c <proc_mapstacks>
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
    8000076c:	604080e7          	jalr	1540(ra) # 80005d6c <panic>
      panic("uvmunmap: walk");
    80000770:	00008517          	auipc	a0,0x8
    80000774:	92850513          	addi	a0,a0,-1752 # 80008098 <etext+0x98>
    80000778:	00005097          	auipc	ra,0x5
    8000077c:	5f4080e7          	jalr	1524(ra) # 80005d6c <panic>
      panic("uvmunmap: not mapped");
    80000780:	00008517          	auipc	a0,0x8
    80000784:	92850513          	addi	a0,a0,-1752 # 800080a8 <etext+0xa8>
    80000788:	00005097          	auipc	ra,0x5
    8000078c:	5e4080e7          	jalr	1508(ra) # 80005d6c <panic>
      panic("uvmunmap: not a leaf");
    80000790:	00008517          	auipc	a0,0x8
    80000794:	93050513          	addi	a0,a0,-1744 # 800080c0 <etext+0xc0>
    80000798:	00005097          	auipc	ra,0x5
    8000079c:	5d4080e7          	jalr	1492(ra) # 80005d6c <panic>
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
    80000890:	4e0080e7          	jalr	1248(ra) # 80005d6c <panic>

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
    800009ee:	382080e7          	jalr	898(ra) # 80005d6c <panic>
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
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a46:	ca69                	beqz	a2,80000b18 <uvmcopy+0xd2>
{
    80000a48:	715d                	addi	sp,sp,-80
    80000a4a:	e486                	sd	ra,72(sp)
    80000a4c:	e0a2                	sd	s0,64(sp)
    80000a4e:	fc26                	sd	s1,56(sp)
    80000a50:	f84a                	sd	s2,48(sp)
    80000a52:	f44e                	sd	s3,40(sp)
    80000a54:	f052                	sd	s4,32(sp)
    80000a56:	ec56                	sd	s5,24(sp)
    80000a58:	e85a                	sd	s6,16(sp)
    80000a5a:	e45e                	sd	s7,8(sp)
    80000a5c:	e062                	sd	s8,0(sp)
    80000a5e:	0880                	addi	s0,sp,80
    80000a60:	8baa                	mv	s7,a0
    80000a62:	8b2e                	mv	s6,a1
    80000a64:	8ab2                	mv	s5,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a66:	4981                	li	s3,0
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a68:	6a05                	lui	s4,0x1
    if((pte = walk(old, i, 0)) == 0)
    80000a6a:	4601                	li	a2,0
    80000a6c:	85ce                	mv	a1,s3
    80000a6e:	855e                	mv	a0,s7
    80000a70:	00000097          	auipc	ra,0x0
    80000a74:	a02080e7          	jalr	-1534(ra) # 80000472 <walk>
    80000a78:	c529                	beqz	a0,80000ac2 <uvmcopy+0x7c>
    if((*pte & PTE_V) == 0)
    80000a7a:	6118                	ld	a4,0(a0)
    80000a7c:	00177793          	andi	a5,a4,1
    80000a80:	cba9                	beqz	a5,80000ad2 <uvmcopy+0x8c>
    pa = PTE2PA(*pte);
    80000a82:	00a75593          	srli	a1,a4,0xa
    80000a86:	00c59c13          	slli	s8,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a8a:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a8e:	fffff097          	auipc	ra,0xfffff
    80000a92:	68c080e7          	jalr	1676(ra) # 8000011a <kalloc>
    80000a96:	892a                	mv	s2,a0
    80000a98:	c931                	beqz	a0,80000aec <uvmcopy+0xa6>
    memmove(mem, (char*)pa, PGSIZE);
    80000a9a:	8652                	mv	a2,s4
    80000a9c:	85e2                	mv	a1,s8
    80000a9e:	fffff097          	auipc	ra,0xfffff
    80000aa2:	740080e7          	jalr	1856(ra) # 800001de <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000aa6:	8726                	mv	a4,s1
    80000aa8:	86ca                	mv	a3,s2
    80000aaa:	8652                	mv	a2,s4
    80000aac:	85ce                	mv	a1,s3
    80000aae:	855a                	mv	a0,s6
    80000ab0:	00000097          	auipc	ra,0x0
    80000ab4:	aaa080e7          	jalr	-1366(ra) # 8000055a <mappages>
    80000ab8:	e50d                	bnez	a0,80000ae2 <uvmcopy+0x9c>
  for(i = 0; i < sz; i += PGSIZE){
    80000aba:	99d2                	add	s3,s3,s4
    80000abc:	fb59e7e3          	bltu	s3,s5,80000a6a <uvmcopy+0x24>
    80000ac0:	a081                	j	80000b00 <uvmcopy+0xba>
      panic("uvmcopy: pte should exist");
    80000ac2:	00007517          	auipc	a0,0x7
    80000ac6:	64650513          	addi	a0,a0,1606 # 80008108 <etext+0x108>
    80000aca:	00005097          	auipc	ra,0x5
    80000ace:	2a2080e7          	jalr	674(ra) # 80005d6c <panic>
      panic("uvmcopy: page not present");
    80000ad2:	00007517          	auipc	a0,0x7
    80000ad6:	65650513          	addi	a0,a0,1622 # 80008128 <etext+0x128>
    80000ada:	00005097          	auipc	ra,0x5
    80000ade:	292080e7          	jalr	658(ra) # 80005d6c <panic>
      kfree(mem);
    80000ae2:	854a                	mv	a0,s2
    80000ae4:	fffff097          	auipc	ra,0xfffff
    80000ae8:	538080e7          	jalr	1336(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000aec:	4685                	li	a3,1
    80000aee:	00c9d613          	srli	a2,s3,0xc
    80000af2:	4581                	li	a1,0
    80000af4:	855a                	mv	a0,s6
    80000af6:	00000097          	auipc	ra,0x0
    80000afa:	c2a080e7          	jalr	-982(ra) # 80000720 <uvmunmap>
  return -1;
    80000afe:	557d                	li	a0,-1
}
    80000b00:	60a6                	ld	ra,72(sp)
    80000b02:	6406                	ld	s0,64(sp)
    80000b04:	74e2                	ld	s1,56(sp)
    80000b06:	7942                	ld	s2,48(sp)
    80000b08:	79a2                	ld	s3,40(sp)
    80000b0a:	7a02                	ld	s4,32(sp)
    80000b0c:	6ae2                	ld	s5,24(sp)
    80000b0e:	6b42                	ld	s6,16(sp)
    80000b10:	6ba2                	ld	s7,8(sp)
    80000b12:	6c02                	ld	s8,0(sp)
    80000b14:	6161                	addi	sp,sp,80
    80000b16:	8082                	ret
  return 0;
    80000b18:	4501                	li	a0,0
}
    80000b1a:	8082                	ret

0000000080000b1c <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000b1c:	1141                	addi	sp,sp,-16
    80000b1e:	e406                	sd	ra,8(sp)
    80000b20:	e022                	sd	s0,0(sp)
    80000b22:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000b24:	4601                	li	a2,0
    80000b26:	00000097          	auipc	ra,0x0
    80000b2a:	94c080e7          	jalr	-1716(ra) # 80000472 <walk>
  if(pte == 0)
    80000b2e:	c901                	beqz	a0,80000b3e <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000b30:	611c                	ld	a5,0(a0)
    80000b32:	9bbd                	andi	a5,a5,-17
    80000b34:	e11c                	sd	a5,0(a0)
}
    80000b36:	60a2                	ld	ra,8(sp)
    80000b38:	6402                	ld	s0,0(sp)
    80000b3a:	0141                	addi	sp,sp,16
    80000b3c:	8082                	ret
    panic("uvmclear");
    80000b3e:	00007517          	auipc	a0,0x7
    80000b42:	60a50513          	addi	a0,a0,1546 # 80008148 <etext+0x148>
    80000b46:	00005097          	auipc	ra,0x5
    80000b4a:	226080e7          	jalr	550(ra) # 80005d6c <panic>

0000000080000b4e <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b4e:	c6bd                	beqz	a3,80000bbc <copyout+0x6e>
{
    80000b50:	715d                	addi	sp,sp,-80
    80000b52:	e486                	sd	ra,72(sp)
    80000b54:	e0a2                	sd	s0,64(sp)
    80000b56:	fc26                	sd	s1,56(sp)
    80000b58:	f84a                	sd	s2,48(sp)
    80000b5a:	f44e                	sd	s3,40(sp)
    80000b5c:	f052                	sd	s4,32(sp)
    80000b5e:	ec56                	sd	s5,24(sp)
    80000b60:	e85a                	sd	s6,16(sp)
    80000b62:	e45e                	sd	s7,8(sp)
    80000b64:	e062                	sd	s8,0(sp)
    80000b66:	0880                	addi	s0,sp,80
    80000b68:	8b2a                	mv	s6,a0
    80000b6a:	8c2e                	mv	s8,a1
    80000b6c:	8a32                	mv	s4,a2
    80000b6e:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b70:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b72:	6a85                	lui	s5,0x1
    80000b74:	a015                	j	80000b98 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b76:	9562                	add	a0,a0,s8
    80000b78:	0004861b          	sext.w	a2,s1
    80000b7c:	85d2                	mv	a1,s4
    80000b7e:	41250533          	sub	a0,a0,s2
    80000b82:	fffff097          	auipc	ra,0xfffff
    80000b86:	65c080e7          	jalr	1628(ra) # 800001de <memmove>

    len -= n;
    80000b8a:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b8e:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b90:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b94:	02098263          	beqz	s3,80000bb8 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b98:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b9c:	85ca                	mv	a1,s2
    80000b9e:	855a                	mv	a0,s6
    80000ba0:	00000097          	auipc	ra,0x0
    80000ba4:	978080e7          	jalr	-1672(ra) # 80000518 <walkaddr>
    if(pa0 == 0)
    80000ba8:	cd01                	beqz	a0,80000bc0 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000baa:	418904b3          	sub	s1,s2,s8
    80000bae:	94d6                	add	s1,s1,s5
    if(n > len)
    80000bb0:	fc99f3e3          	bgeu	s3,s1,80000b76 <copyout+0x28>
    80000bb4:	84ce                	mv	s1,s3
    80000bb6:	b7c1                	j	80000b76 <copyout+0x28>
  }
  return 0;
    80000bb8:	4501                	li	a0,0
    80000bba:	a021                	j	80000bc2 <copyout+0x74>
    80000bbc:	4501                	li	a0,0
}
    80000bbe:	8082                	ret
      return -1;
    80000bc0:	557d                	li	a0,-1
}
    80000bc2:	60a6                	ld	ra,72(sp)
    80000bc4:	6406                	ld	s0,64(sp)
    80000bc6:	74e2                	ld	s1,56(sp)
    80000bc8:	7942                	ld	s2,48(sp)
    80000bca:	79a2                	ld	s3,40(sp)
    80000bcc:	7a02                	ld	s4,32(sp)
    80000bce:	6ae2                	ld	s5,24(sp)
    80000bd0:	6b42                	ld	s6,16(sp)
    80000bd2:	6ba2                	ld	s7,8(sp)
    80000bd4:	6c02                	ld	s8,0(sp)
    80000bd6:	6161                	addi	sp,sp,80
    80000bd8:	8082                	ret

0000000080000bda <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000bda:	caa5                	beqz	a3,80000c4a <copyin+0x70>
{
    80000bdc:	715d                	addi	sp,sp,-80
    80000bde:	e486                	sd	ra,72(sp)
    80000be0:	e0a2                	sd	s0,64(sp)
    80000be2:	fc26                	sd	s1,56(sp)
    80000be4:	f84a                	sd	s2,48(sp)
    80000be6:	f44e                	sd	s3,40(sp)
    80000be8:	f052                	sd	s4,32(sp)
    80000bea:	ec56                	sd	s5,24(sp)
    80000bec:	e85a                	sd	s6,16(sp)
    80000bee:	e45e                	sd	s7,8(sp)
    80000bf0:	e062                	sd	s8,0(sp)
    80000bf2:	0880                	addi	s0,sp,80
    80000bf4:	8b2a                	mv	s6,a0
    80000bf6:	8a2e                	mv	s4,a1
    80000bf8:	8c32                	mv	s8,a2
    80000bfa:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000bfc:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000bfe:	6a85                	lui	s5,0x1
    80000c00:	a01d                	j	80000c26 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000c02:	018505b3          	add	a1,a0,s8
    80000c06:	0004861b          	sext.w	a2,s1
    80000c0a:	412585b3          	sub	a1,a1,s2
    80000c0e:	8552                	mv	a0,s4
    80000c10:	fffff097          	auipc	ra,0xfffff
    80000c14:	5ce080e7          	jalr	1486(ra) # 800001de <memmove>

    len -= n;
    80000c18:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000c1c:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000c1e:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000c22:	02098263          	beqz	s3,80000c46 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000c26:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000c2a:	85ca                	mv	a1,s2
    80000c2c:	855a                	mv	a0,s6
    80000c2e:	00000097          	auipc	ra,0x0
    80000c32:	8ea080e7          	jalr	-1814(ra) # 80000518 <walkaddr>
    if(pa0 == 0)
    80000c36:	cd01                	beqz	a0,80000c4e <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000c38:	418904b3          	sub	s1,s2,s8
    80000c3c:	94d6                	add	s1,s1,s5
    if(n > len)
    80000c3e:	fc99f2e3          	bgeu	s3,s1,80000c02 <copyin+0x28>
    80000c42:	84ce                	mv	s1,s3
    80000c44:	bf7d                	j	80000c02 <copyin+0x28>
  }
  return 0;
    80000c46:	4501                	li	a0,0
    80000c48:	a021                	j	80000c50 <copyin+0x76>
    80000c4a:	4501                	li	a0,0
}
    80000c4c:	8082                	ret
      return -1;
    80000c4e:	557d                	li	a0,-1
}
    80000c50:	60a6                	ld	ra,72(sp)
    80000c52:	6406                	ld	s0,64(sp)
    80000c54:	74e2                	ld	s1,56(sp)
    80000c56:	7942                	ld	s2,48(sp)
    80000c58:	79a2                	ld	s3,40(sp)
    80000c5a:	7a02                	ld	s4,32(sp)
    80000c5c:	6ae2                	ld	s5,24(sp)
    80000c5e:	6b42                	ld	s6,16(sp)
    80000c60:	6ba2                	ld	s7,8(sp)
    80000c62:	6c02                	ld	s8,0(sp)
    80000c64:	6161                	addi	sp,sp,80
    80000c66:	8082                	ret

0000000080000c68 <copyinstr>:
// Copy bytes to dst from virtual address srcva in a given page table,
// until a '\0', or max.
// Return 0 on success, -1 on error.
int
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
    80000c68:	715d                	addi	sp,sp,-80
    80000c6a:	e486                	sd	ra,72(sp)
    80000c6c:	e0a2                	sd	s0,64(sp)
    80000c6e:	fc26                	sd	s1,56(sp)
    80000c70:	f84a                	sd	s2,48(sp)
    80000c72:	f44e                	sd	s3,40(sp)
    80000c74:	f052                	sd	s4,32(sp)
    80000c76:	ec56                	sd	s5,24(sp)
    80000c78:	e85a                	sd	s6,16(sp)
    80000c7a:	e45e                	sd	s7,8(sp)
    80000c7c:	0880                	addi	s0,sp,80
    80000c7e:	8aaa                	mv	s5,a0
    80000c80:	89ae                	mv	s3,a1
    80000c82:	8bb2                	mv	s7,a2
    80000c84:	84b6                	mv	s1,a3
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    va0 = PGROUNDDOWN(srcva);
    80000c86:	7b7d                	lui	s6,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c88:	6a05                	lui	s4,0x1
    80000c8a:	a02d                	j	80000cb4 <copyinstr+0x4c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c8c:	00078023          	sb	zero,0(a5)
    80000c90:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c92:	0017c793          	xori	a5,a5,1
    80000c96:	40f0053b          	negw	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000c9a:	60a6                	ld	ra,72(sp)
    80000c9c:	6406                	ld	s0,64(sp)
    80000c9e:	74e2                	ld	s1,56(sp)
    80000ca0:	7942                	ld	s2,48(sp)
    80000ca2:	79a2                	ld	s3,40(sp)
    80000ca4:	7a02                	ld	s4,32(sp)
    80000ca6:	6ae2                	ld	s5,24(sp)
    80000ca8:	6b42                	ld	s6,16(sp)
    80000caa:	6ba2                	ld	s7,8(sp)
    80000cac:	6161                	addi	sp,sp,80
    80000cae:	8082                	ret
    srcva = va0 + PGSIZE;
    80000cb0:	01490bb3          	add	s7,s2,s4
  while(got_null == 0 && max > 0){
    80000cb4:	c8a1                	beqz	s1,80000d04 <copyinstr+0x9c>
    va0 = PGROUNDDOWN(srcva);
    80000cb6:	016bf933          	and	s2,s7,s6
    pa0 = walkaddr(pagetable, va0);
    80000cba:	85ca                	mv	a1,s2
    80000cbc:	8556                	mv	a0,s5
    80000cbe:	00000097          	auipc	ra,0x0
    80000cc2:	85a080e7          	jalr	-1958(ra) # 80000518 <walkaddr>
    if(pa0 == 0)
    80000cc6:	c129                	beqz	a0,80000d08 <copyinstr+0xa0>
    n = PGSIZE - (srcva - va0);
    80000cc8:	41790633          	sub	a2,s2,s7
    80000ccc:	9652                	add	a2,a2,s4
    if(n > max)
    80000cce:	00c4f363          	bgeu	s1,a2,80000cd4 <copyinstr+0x6c>
    80000cd2:	8626                	mv	a2,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000cd4:	412b8bb3          	sub	s7,s7,s2
    80000cd8:	9baa                	add	s7,s7,a0
    while(n > 0){
    80000cda:	da79                	beqz	a2,80000cb0 <copyinstr+0x48>
    80000cdc:	87ce                	mv	a5,s3
      if(*p == '\0'){
    80000cde:	413b86b3          	sub	a3,s7,s3
    while(n > 0){
    80000ce2:	964e                	add	a2,a2,s3
    80000ce4:	85be                	mv	a1,a5
      if(*p == '\0'){
    80000ce6:	00f68733          	add	a4,a3,a5
    80000cea:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffd8dc0>
    80000cee:	df59                	beqz	a4,80000c8c <copyinstr+0x24>
        *dst = *p;
    80000cf0:	00e78023          	sb	a4,0(a5)
      dst++;
    80000cf4:	0785                	addi	a5,a5,1
    while(n > 0){
    80000cf6:	fec797e3          	bne	a5,a2,80000ce4 <copyinstr+0x7c>
    80000cfa:	14fd                	addi	s1,s1,-1
    80000cfc:	94ce                	add	s1,s1,s3
      --max;
    80000cfe:	8c8d                	sub	s1,s1,a1
    80000d00:	89be                	mv	s3,a5
    80000d02:	b77d                	j	80000cb0 <copyinstr+0x48>
    80000d04:	4781                	li	a5,0
    80000d06:	b771                	j	80000c92 <copyinstr+0x2a>
      return -1;
    80000d08:	557d                	li	a0,-1
    80000d0a:	bf41                	j	80000c9a <copyinstr+0x32>

0000000080000d0c <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000d0c:	715d                	addi	sp,sp,-80
    80000d0e:	e486                	sd	ra,72(sp)
    80000d10:	e0a2                	sd	s0,64(sp)
    80000d12:	fc26                	sd	s1,56(sp)
    80000d14:	f84a                	sd	s2,48(sp)
    80000d16:	f44e                	sd	s3,40(sp)
    80000d18:	f052                	sd	s4,32(sp)
    80000d1a:	ec56                	sd	s5,24(sp)
    80000d1c:	e85a                	sd	s6,16(sp)
    80000d1e:	e45e                	sd	s7,8(sp)
    80000d20:	e062                	sd	s8,0(sp)
    80000d22:	0880                	addi	s0,sp,80
    80000d24:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d26:	00008497          	auipc	s1,0x8
    80000d2a:	75a48493          	addi	s1,s1,1882 # 80009480 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000d2e:	8c26                	mv	s8,s1
    80000d30:	aaaab7b7          	lui	a5,0xaaaab
    80000d34:	aab78793          	addi	a5,a5,-1365 # ffffffffaaaaaaab <end+0xffffffff2aa8486b>
    80000d38:	02079993          	slli	s3,a5,0x20
    80000d3c:	99be                	add	s3,s3,a5
    80000d3e:	04000937          	lui	s2,0x4000
    80000d42:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000d44:	0932                	slli	s2,s2,0xc
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d46:	4b99                	li	s7,6
    80000d48:	6b05                	lui	s6,0x1
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d4a:	0000ea97          	auipc	s5,0xe
    80000d4e:	736a8a93          	addi	s5,s5,1846 # 8000f480 <tickslock>
    char *pa = kalloc();
    80000d52:	fffff097          	auipc	ra,0xfffff
    80000d56:	3c8080e7          	jalr	968(ra) # 8000011a <kalloc>
    80000d5a:	862a                	mv	a2,a0
    if(pa == 0)
    80000d5c:	c131                	beqz	a0,80000da0 <proc_mapstacks+0x94>
    uint64 va = KSTACK((int) (p - proc));
    80000d5e:	418485b3          	sub	a1,s1,s8
    80000d62:	859d                	srai	a1,a1,0x7
    80000d64:	033585b3          	mul	a1,a1,s3
    80000d68:	2585                	addiw	a1,a1,1
    80000d6a:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d6e:	875e                	mv	a4,s7
    80000d70:	86da                	mv	a3,s6
    80000d72:	40b905b3          	sub	a1,s2,a1
    80000d76:	8552                	mv	a0,s4
    80000d78:	00000097          	auipc	ra,0x0
    80000d7c:	888080e7          	jalr	-1912(ra) # 80000600 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d80:	18048493          	addi	s1,s1,384
    80000d84:	fd5497e3          	bne	s1,s5,80000d52 <proc_mapstacks+0x46>
  }
}
    80000d88:	60a6                	ld	ra,72(sp)
    80000d8a:	6406                	ld	s0,64(sp)
    80000d8c:	74e2                	ld	s1,56(sp)
    80000d8e:	7942                	ld	s2,48(sp)
    80000d90:	79a2                	ld	s3,40(sp)
    80000d92:	7a02                	ld	s4,32(sp)
    80000d94:	6ae2                	ld	s5,24(sp)
    80000d96:	6b42                	ld	s6,16(sp)
    80000d98:	6ba2                	ld	s7,8(sp)
    80000d9a:	6c02                	ld	s8,0(sp)
    80000d9c:	6161                	addi	sp,sp,80
    80000d9e:	8082                	ret
      panic("kalloc");
    80000da0:	00007517          	auipc	a0,0x7
    80000da4:	3b850513          	addi	a0,a0,952 # 80008158 <etext+0x158>
    80000da8:	00005097          	auipc	ra,0x5
    80000dac:	fc4080e7          	jalr	-60(ra) # 80005d6c <panic>

0000000080000db0 <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000db0:	7139                	addi	sp,sp,-64
    80000db2:	fc06                	sd	ra,56(sp)
    80000db4:	f822                	sd	s0,48(sp)
    80000db6:	f426                	sd	s1,40(sp)
    80000db8:	f04a                	sd	s2,32(sp)
    80000dba:	ec4e                	sd	s3,24(sp)
    80000dbc:	e852                	sd	s4,16(sp)
    80000dbe:	e456                	sd	s5,8(sp)
    80000dc0:	e05a                	sd	s6,0(sp)
    80000dc2:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000dc4:	00007597          	auipc	a1,0x7
    80000dc8:	39c58593          	addi	a1,a1,924 # 80008160 <etext+0x160>
    80000dcc:	00008517          	auipc	a0,0x8
    80000dd0:	28450513          	addi	a0,a0,644 # 80009050 <pid_lock>
    80000dd4:	00005097          	auipc	ra,0x5
    80000dd8:	45a080e7          	jalr	1114(ra) # 8000622e <initlock>
  initlock(&wait_lock, "wait_lock");
    80000ddc:	00007597          	auipc	a1,0x7
    80000de0:	38c58593          	addi	a1,a1,908 # 80008168 <etext+0x168>
    80000de4:	00008517          	auipc	a0,0x8
    80000de8:	28450513          	addi	a0,a0,644 # 80009068 <wait_lock>
    80000dec:	00005097          	auipc	ra,0x5
    80000df0:	442080e7          	jalr	1090(ra) # 8000622e <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000df4:	00008497          	auipc	s1,0x8
    80000df8:	68c48493          	addi	s1,s1,1676 # 80009480 <proc>
      initlock(&p->lock, "proc");
    80000dfc:	00007b17          	auipc	s6,0x7
    80000e00:	37cb0b13          	addi	s6,s6,892 # 80008178 <etext+0x178>
      p->kstack = KSTACK((int) (p - proc));
    80000e04:	8aa6                	mv	s5,s1
    80000e06:	aaaab7b7          	lui	a5,0xaaaab
    80000e0a:	aab78793          	addi	a5,a5,-1365 # ffffffffaaaaaaab <end+0xffffffff2aa8486b>
    80000e0e:	02079993          	slli	s3,a5,0x20
    80000e12:	99be                	add	s3,s3,a5
    80000e14:	04000937          	lui	s2,0x4000
    80000e18:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000e1a:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e1c:	0000ea17          	auipc	s4,0xe
    80000e20:	664a0a13          	addi	s4,s4,1636 # 8000f480 <tickslock>
      initlock(&p->lock, "proc");
    80000e24:	85da                	mv	a1,s6
    80000e26:	8526                	mv	a0,s1
    80000e28:	00005097          	auipc	ra,0x5
    80000e2c:	406080e7          	jalr	1030(ra) # 8000622e <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000e30:	415487b3          	sub	a5,s1,s5
    80000e34:	879d                	srai	a5,a5,0x7
    80000e36:	033787b3          	mul	a5,a5,s3
    80000e3a:	2785                	addiw	a5,a5,1
    80000e3c:	00d7979b          	slliw	a5,a5,0xd
    80000e40:	40f907b3          	sub	a5,s2,a5
    80000e44:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e46:	18048493          	addi	s1,s1,384
    80000e4a:	fd449de3          	bne	s1,s4,80000e24 <procinit+0x74>
  }
}
    80000e4e:	70e2                	ld	ra,56(sp)
    80000e50:	7442                	ld	s0,48(sp)
    80000e52:	74a2                	ld	s1,40(sp)
    80000e54:	7902                	ld	s2,32(sp)
    80000e56:	69e2                	ld	s3,24(sp)
    80000e58:	6a42                	ld	s4,16(sp)
    80000e5a:	6aa2                	ld	s5,8(sp)
    80000e5c:	6b02                	ld	s6,0(sp)
    80000e5e:	6121                	addi	sp,sp,64
    80000e60:	8082                	ret

0000000080000e62 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e62:	1141                	addi	sp,sp,-16
    80000e64:	e406                	sd	ra,8(sp)
    80000e66:	e022                	sd	s0,0(sp)
    80000e68:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e6a:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e6c:	2501                	sext.w	a0,a0
    80000e6e:	60a2                	ld	ra,8(sp)
    80000e70:	6402                	ld	s0,0(sp)
    80000e72:	0141                	addi	sp,sp,16
    80000e74:	8082                	ret

0000000080000e76 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000e76:	1141                	addi	sp,sp,-16
    80000e78:	e406                	sd	ra,8(sp)
    80000e7a:	e022                	sd	s0,0(sp)
    80000e7c:	0800                	addi	s0,sp,16
    80000e7e:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e80:	2781                	sext.w	a5,a5
    80000e82:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e84:	00008517          	auipc	a0,0x8
    80000e88:	1fc50513          	addi	a0,a0,508 # 80009080 <cpus>
    80000e8c:	953e                	add	a0,a0,a5
    80000e8e:	60a2                	ld	ra,8(sp)
    80000e90:	6402                	ld	s0,0(sp)
    80000e92:	0141                	addi	sp,sp,16
    80000e94:	8082                	ret

0000000080000e96 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000e96:	1101                	addi	sp,sp,-32
    80000e98:	ec06                	sd	ra,24(sp)
    80000e9a:	e822                	sd	s0,16(sp)
    80000e9c:	e426                	sd	s1,8(sp)
    80000e9e:	1000                	addi	s0,sp,32
  push_off();
    80000ea0:	00005097          	auipc	ra,0x5
    80000ea4:	3d6080e7          	jalr	982(ra) # 80006276 <push_off>
    80000ea8:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000eaa:	2781                	sext.w	a5,a5
    80000eac:	079e                	slli	a5,a5,0x7
    80000eae:	00008717          	auipc	a4,0x8
    80000eb2:	1a270713          	addi	a4,a4,418 # 80009050 <pid_lock>
    80000eb6:	97ba                	add	a5,a5,a4
    80000eb8:	7b84                	ld	s1,48(a5)
  pop_off();
    80000eba:	00005097          	auipc	ra,0x5
    80000ebe:	45c080e7          	jalr	1116(ra) # 80006316 <pop_off>
  return p;
}
    80000ec2:	8526                	mv	a0,s1
    80000ec4:	60e2                	ld	ra,24(sp)
    80000ec6:	6442                	ld	s0,16(sp)
    80000ec8:	64a2                	ld	s1,8(sp)
    80000eca:	6105                	addi	sp,sp,32
    80000ecc:	8082                	ret

0000000080000ece <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000ece:	1141                	addi	sp,sp,-16
    80000ed0:	e406                	sd	ra,8(sp)
    80000ed2:	e022                	sd	s0,0(sp)
    80000ed4:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000ed6:	00000097          	auipc	ra,0x0
    80000eda:	fc0080e7          	jalr	-64(ra) # 80000e96 <myproc>
    80000ede:	00005097          	auipc	ra,0x5
    80000ee2:	494080e7          	jalr	1172(ra) # 80006372 <release>

  if (first) {
    80000ee6:	00008797          	auipc	a5,0x8
    80000eea:	94a7a783          	lw	a5,-1718(a5) # 80008830 <first.1>
    80000eee:	eb89                	bnez	a5,80000f00 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000ef0:	00001097          	auipc	ra,0x1
    80000ef4:	c20080e7          	jalr	-992(ra) # 80001b10 <usertrapret>
}
    80000ef8:	60a2                	ld	ra,8(sp)
    80000efa:	6402                	ld	s0,0(sp)
    80000efc:	0141                	addi	sp,sp,16
    80000efe:	8082                	ret
    first = 0;
    80000f00:	00008797          	auipc	a5,0x8
    80000f04:	9207a823          	sw	zero,-1744(a5) # 80008830 <first.1>
    fsinit(ROOTDEV);
    80000f08:	4505                	li	a0,1
    80000f0a:	00002097          	auipc	ra,0x2
    80000f0e:	9a6080e7          	jalr	-1626(ra) # 800028b0 <fsinit>
    80000f12:	bff9                	j	80000ef0 <forkret+0x22>

0000000080000f14 <allocpid>:
allocpid() {
    80000f14:	1101                	addi	sp,sp,-32
    80000f16:	ec06                	sd	ra,24(sp)
    80000f18:	e822                	sd	s0,16(sp)
    80000f1a:	e426                	sd	s1,8(sp)
    80000f1c:	e04a                	sd	s2,0(sp)
    80000f1e:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000f20:	00008917          	auipc	s2,0x8
    80000f24:	13090913          	addi	s2,s2,304 # 80009050 <pid_lock>
    80000f28:	854a                	mv	a0,s2
    80000f2a:	00005097          	auipc	ra,0x5
    80000f2e:	398080e7          	jalr	920(ra) # 800062c2 <acquire>
  pid = nextpid;
    80000f32:	00008797          	auipc	a5,0x8
    80000f36:	90278793          	addi	a5,a5,-1790 # 80008834 <nextpid>
    80000f3a:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000f3c:	0014871b          	addiw	a4,s1,1
    80000f40:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000f42:	854a                	mv	a0,s2
    80000f44:	00005097          	auipc	ra,0x5
    80000f48:	42e080e7          	jalr	1070(ra) # 80006372 <release>
}
    80000f4c:	8526                	mv	a0,s1
    80000f4e:	60e2                	ld	ra,24(sp)
    80000f50:	6442                	ld	s0,16(sp)
    80000f52:	64a2                	ld	s1,8(sp)
    80000f54:	6902                	ld	s2,0(sp)
    80000f56:	6105                	addi	sp,sp,32
    80000f58:	8082                	ret

0000000080000f5a <proc_pagetable>:
{
    80000f5a:	1101                	addi	sp,sp,-32
    80000f5c:	ec06                	sd	ra,24(sp)
    80000f5e:	e822                	sd	s0,16(sp)
    80000f60:	e426                	sd	s1,8(sp)
    80000f62:	e04a                	sd	s2,0(sp)
    80000f64:	1000                	addi	s0,sp,32
    80000f66:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f68:	00000097          	auipc	ra,0x0
    80000f6c:	88c080e7          	jalr	-1908(ra) # 800007f4 <uvmcreate>
    80000f70:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f72:	c121                	beqz	a0,80000fb2 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f74:	4729                	li	a4,10
    80000f76:	00006697          	auipc	a3,0x6
    80000f7a:	08a68693          	addi	a3,a3,138 # 80007000 <_trampoline>
    80000f7e:	6605                	lui	a2,0x1
    80000f80:	040005b7          	lui	a1,0x4000
    80000f84:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f86:	05b2                	slli	a1,a1,0xc
    80000f88:	fffff097          	auipc	ra,0xfffff
    80000f8c:	5d2080e7          	jalr	1490(ra) # 8000055a <mappages>
    80000f90:	02054863          	bltz	a0,80000fc0 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f94:	4719                	li	a4,6
    80000f96:	05893683          	ld	a3,88(s2)
    80000f9a:	6605                	lui	a2,0x1
    80000f9c:	020005b7          	lui	a1,0x2000
    80000fa0:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000fa2:	05b6                	slli	a1,a1,0xd
    80000fa4:	8526                	mv	a0,s1
    80000fa6:	fffff097          	auipc	ra,0xfffff
    80000faa:	5b4080e7          	jalr	1460(ra) # 8000055a <mappages>
    80000fae:	02054163          	bltz	a0,80000fd0 <proc_pagetable+0x76>
}
    80000fb2:	8526                	mv	a0,s1
    80000fb4:	60e2                	ld	ra,24(sp)
    80000fb6:	6442                	ld	s0,16(sp)
    80000fb8:	64a2                	ld	s1,8(sp)
    80000fba:	6902                	ld	s2,0(sp)
    80000fbc:	6105                	addi	sp,sp,32
    80000fbe:	8082                	ret
    uvmfree(pagetable, 0);
    80000fc0:	4581                	li	a1,0
    80000fc2:	8526                	mv	a0,s1
    80000fc4:	00000097          	auipc	ra,0x0
    80000fc8:	a48080e7          	jalr	-1464(ra) # 80000a0c <uvmfree>
    return 0;
    80000fcc:	4481                	li	s1,0
    80000fce:	b7d5                	j	80000fb2 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fd0:	4681                	li	a3,0
    80000fd2:	4605                	li	a2,1
    80000fd4:	040005b7          	lui	a1,0x4000
    80000fd8:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000fda:	05b2                	slli	a1,a1,0xc
    80000fdc:	8526                	mv	a0,s1
    80000fde:	fffff097          	auipc	ra,0xfffff
    80000fe2:	742080e7          	jalr	1858(ra) # 80000720 <uvmunmap>
    uvmfree(pagetable, 0);
    80000fe6:	4581                	li	a1,0
    80000fe8:	8526                	mv	a0,s1
    80000fea:	00000097          	auipc	ra,0x0
    80000fee:	a22080e7          	jalr	-1502(ra) # 80000a0c <uvmfree>
    return 0;
    80000ff2:	4481                	li	s1,0
    80000ff4:	bf7d                	j	80000fb2 <proc_pagetable+0x58>

0000000080000ff6 <proc_freepagetable>:
{
    80000ff6:	1101                	addi	sp,sp,-32
    80000ff8:	ec06                	sd	ra,24(sp)
    80000ffa:	e822                	sd	s0,16(sp)
    80000ffc:	e426                	sd	s1,8(sp)
    80000ffe:	e04a                	sd	s2,0(sp)
    80001000:	1000                	addi	s0,sp,32
    80001002:	84aa                	mv	s1,a0
    80001004:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001006:	4681                	li	a3,0
    80001008:	4605                	li	a2,1
    8000100a:	040005b7          	lui	a1,0x4000
    8000100e:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001010:	05b2                	slli	a1,a1,0xc
    80001012:	fffff097          	auipc	ra,0xfffff
    80001016:	70e080e7          	jalr	1806(ra) # 80000720 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    8000101a:	4681                	li	a3,0
    8000101c:	4605                	li	a2,1
    8000101e:	020005b7          	lui	a1,0x2000
    80001022:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001024:	05b6                	slli	a1,a1,0xd
    80001026:	8526                	mv	a0,s1
    80001028:	fffff097          	auipc	ra,0xfffff
    8000102c:	6f8080e7          	jalr	1784(ra) # 80000720 <uvmunmap>
  uvmfree(pagetable, sz);
    80001030:	85ca                	mv	a1,s2
    80001032:	8526                	mv	a0,s1
    80001034:	00000097          	auipc	ra,0x0
    80001038:	9d8080e7          	jalr	-1576(ra) # 80000a0c <uvmfree>
}
    8000103c:	60e2                	ld	ra,24(sp)
    8000103e:	6442                	ld	s0,16(sp)
    80001040:	64a2                	ld	s1,8(sp)
    80001042:	6902                	ld	s2,0(sp)
    80001044:	6105                	addi	sp,sp,32
    80001046:	8082                	ret

0000000080001048 <freeproc>:
{
    80001048:	1101                	addi	sp,sp,-32
    8000104a:	ec06                	sd	ra,24(sp)
    8000104c:	e822                	sd	s0,16(sp)
    8000104e:	e426                	sd	s1,8(sp)
    80001050:	1000                	addi	s0,sp,32
    80001052:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001054:	6d28                	ld	a0,88(a0)
    80001056:	c509                	beqz	a0,80001060 <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001058:	fffff097          	auipc	ra,0xfffff
    8000105c:	fc4080e7          	jalr	-60(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001060:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001064:	68a8                	ld	a0,80(s1)
    80001066:	c511                	beqz	a0,80001072 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001068:	64ac                	ld	a1,72(s1)
    8000106a:	00000097          	auipc	ra,0x0
    8000106e:	f8c080e7          	jalr	-116(ra) # 80000ff6 <proc_freepagetable>
  p->pagetable = 0;
    80001072:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001076:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    8000107a:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    8000107e:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001082:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001086:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    8000108a:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    8000108e:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001092:	0004ac23          	sw	zero,24(s1)
}
    80001096:	60e2                	ld	ra,24(sp)
    80001098:	6442                	ld	s0,16(sp)
    8000109a:	64a2                	ld	s1,8(sp)
    8000109c:	6105                	addi	sp,sp,32
    8000109e:	8082                	ret

00000000800010a0 <allocproc>:
{
    800010a0:	1101                	addi	sp,sp,-32
    800010a2:	ec06                	sd	ra,24(sp)
    800010a4:	e822                	sd	s0,16(sp)
    800010a6:	e426                	sd	s1,8(sp)
    800010a8:	e04a                	sd	s2,0(sp)
    800010aa:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    800010ac:	00008497          	auipc	s1,0x8
    800010b0:	3d448493          	addi	s1,s1,980 # 80009480 <proc>
    800010b4:	0000e917          	auipc	s2,0xe
    800010b8:	3cc90913          	addi	s2,s2,972 # 8000f480 <tickslock>
    acquire(&p->lock);
    800010bc:	8526                	mv	a0,s1
    800010be:	00005097          	auipc	ra,0x5
    800010c2:	204080e7          	jalr	516(ra) # 800062c2 <acquire>
    if(p->state == UNUSED) {
    800010c6:	4c9c                	lw	a5,24(s1)
    800010c8:	cf81                	beqz	a5,800010e0 <allocproc+0x40>
      release(&p->lock);
    800010ca:	8526                	mv	a0,s1
    800010cc:	00005097          	auipc	ra,0x5
    800010d0:	2a6080e7          	jalr	678(ra) # 80006372 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800010d4:	18048493          	addi	s1,s1,384
    800010d8:	ff2492e3          	bne	s1,s2,800010bc <allocproc+0x1c>
  return 0;
    800010dc:	4481                	li	s1,0
    800010de:	a8b9                	j	8000113c <allocproc+0x9c>
  p->pid = allocpid();
    800010e0:	00000097          	auipc	ra,0x0
    800010e4:	e34080e7          	jalr	-460(ra) # 80000f14 <allocpid>
    800010e8:	d888                	sw	a0,48(s1)
  p->state = USED;
    800010ea:	4785                	li	a5,1
    800010ec:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800010ee:	fffff097          	auipc	ra,0xfffff
    800010f2:	02c080e7          	jalr	44(ra) # 8000011a <kalloc>
    800010f6:	892a                	mv	s2,a0
    800010f8:	eca8                	sd	a0,88(s1)
    800010fa:	c921                	beqz	a0,8000114a <allocproc+0xaa>
  p->pagetable = proc_pagetable(p);
    800010fc:	8526                	mv	a0,s1
    800010fe:	00000097          	auipc	ra,0x0
    80001102:	e5c080e7          	jalr	-420(ra) # 80000f5a <proc_pagetable>
    80001106:	892a                	mv	s2,a0
    80001108:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    8000110a:	cd21                	beqz	a0,80001162 <allocproc+0xc2>
  memset(&p->context, 0, sizeof(p->context));
    8000110c:	07000613          	li	a2,112
    80001110:	4581                	li	a1,0
    80001112:	06048513          	addi	a0,s1,96
    80001116:	fffff097          	auipc	ra,0xfffff
    8000111a:	064080e7          	jalr	100(ra) # 8000017a <memset>
  p->context.ra = (uint64)forkret;
    8000111e:	00000797          	auipc	a5,0x0
    80001122:	db078793          	addi	a5,a5,-592 # 80000ece <forkret>
    80001126:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001128:	60bc                	ld	a5,64(s1)
    8000112a:	6705                	lui	a4,0x1
    8000112c:	97ba                	add	a5,a5,a4
    8000112e:	f4bc                	sd	a5,104(s1)
  p->interval = 0;
    80001130:	1604a423          	sw	zero,360(s1)
  p->handler = 0;
    80001134:	1604b823          	sd	zero,368(s1)
  p->tickes_num = 0;
    80001138:	1604ac23          	sw	zero,376(s1)
}
    8000113c:	8526                	mv	a0,s1
    8000113e:	60e2                	ld	ra,24(sp)
    80001140:	6442                	ld	s0,16(sp)
    80001142:	64a2                	ld	s1,8(sp)
    80001144:	6902                	ld	s2,0(sp)
    80001146:	6105                	addi	sp,sp,32
    80001148:	8082                	ret
    freeproc(p);
    8000114a:	8526                	mv	a0,s1
    8000114c:	00000097          	auipc	ra,0x0
    80001150:	efc080e7          	jalr	-260(ra) # 80001048 <freeproc>
    release(&p->lock);
    80001154:	8526                	mv	a0,s1
    80001156:	00005097          	auipc	ra,0x5
    8000115a:	21c080e7          	jalr	540(ra) # 80006372 <release>
    return 0;
    8000115e:	84ca                	mv	s1,s2
    80001160:	bff1                	j	8000113c <allocproc+0x9c>
    freeproc(p);
    80001162:	8526                	mv	a0,s1
    80001164:	00000097          	auipc	ra,0x0
    80001168:	ee4080e7          	jalr	-284(ra) # 80001048 <freeproc>
    release(&p->lock);
    8000116c:	8526                	mv	a0,s1
    8000116e:	00005097          	auipc	ra,0x5
    80001172:	204080e7          	jalr	516(ra) # 80006372 <release>
    return 0;
    80001176:	84ca                	mv	s1,s2
    80001178:	b7d1                	j	8000113c <allocproc+0x9c>

000000008000117a <userinit>:
{
    8000117a:	1101                	addi	sp,sp,-32
    8000117c:	ec06                	sd	ra,24(sp)
    8000117e:	e822                	sd	s0,16(sp)
    80001180:	e426                	sd	s1,8(sp)
    80001182:	1000                	addi	s0,sp,32
  p = allocproc();
    80001184:	00000097          	auipc	ra,0x0
    80001188:	f1c080e7          	jalr	-228(ra) # 800010a0 <allocproc>
    8000118c:	84aa                	mv	s1,a0
  initproc = p;
    8000118e:	00008797          	auipc	a5,0x8
    80001192:	e8a7b123          	sd	a0,-382(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001196:	03400613          	li	a2,52
    8000119a:	00007597          	auipc	a1,0x7
    8000119e:	6a658593          	addi	a1,a1,1702 # 80008840 <initcode>
    800011a2:	6928                	ld	a0,80(a0)
    800011a4:	fffff097          	auipc	ra,0xfffff
    800011a8:	67e080e7          	jalr	1662(ra) # 80000822 <uvminit>
  p->sz = PGSIZE;
    800011ac:	6785                	lui	a5,0x1
    800011ae:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    800011b0:	6cb8                	ld	a4,88(s1)
    800011b2:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    800011b6:	6cb8                	ld	a4,88(s1)
    800011b8:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800011ba:	4641                	li	a2,16
    800011bc:	00007597          	auipc	a1,0x7
    800011c0:	fc458593          	addi	a1,a1,-60 # 80008180 <etext+0x180>
    800011c4:	15848513          	addi	a0,s1,344
    800011c8:	fffff097          	auipc	ra,0xfffff
    800011cc:	108080e7          	jalr	264(ra) # 800002d0 <safestrcpy>
  p->cwd = namei("/");
    800011d0:	00007517          	auipc	a0,0x7
    800011d4:	fc050513          	addi	a0,a0,-64 # 80008190 <etext+0x190>
    800011d8:	00002097          	auipc	ra,0x2
    800011dc:	138080e7          	jalr	312(ra) # 80003310 <namei>
    800011e0:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800011e4:	478d                	li	a5,3
    800011e6:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800011e8:	8526                	mv	a0,s1
    800011ea:	00005097          	auipc	ra,0x5
    800011ee:	188080e7          	jalr	392(ra) # 80006372 <release>
}
    800011f2:	60e2                	ld	ra,24(sp)
    800011f4:	6442                	ld	s0,16(sp)
    800011f6:	64a2                	ld	s1,8(sp)
    800011f8:	6105                	addi	sp,sp,32
    800011fa:	8082                	ret

00000000800011fc <growproc>:
{
    800011fc:	1101                	addi	sp,sp,-32
    800011fe:	ec06                	sd	ra,24(sp)
    80001200:	e822                	sd	s0,16(sp)
    80001202:	e426                	sd	s1,8(sp)
    80001204:	e04a                	sd	s2,0(sp)
    80001206:	1000                	addi	s0,sp,32
    80001208:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    8000120a:	00000097          	auipc	ra,0x0
    8000120e:	c8c080e7          	jalr	-884(ra) # 80000e96 <myproc>
    80001212:	892a                	mv	s2,a0
  sz = p->sz;
    80001214:	652c                	ld	a1,72(a0)
    80001216:	0005879b          	sext.w	a5,a1
  if(n > 0){
    8000121a:	00904f63          	bgtz	s1,80001238 <growproc+0x3c>
  } else if(n < 0){
    8000121e:	0204cd63          	bltz	s1,80001258 <growproc+0x5c>
  p->sz = sz;
    80001222:	1782                	slli	a5,a5,0x20
    80001224:	9381                	srli	a5,a5,0x20
    80001226:	04f93423          	sd	a5,72(s2)
  return 0;
    8000122a:	4501                	li	a0,0
}
    8000122c:	60e2                	ld	ra,24(sp)
    8000122e:	6442                	ld	s0,16(sp)
    80001230:	64a2                	ld	s1,8(sp)
    80001232:	6902                	ld	s2,0(sp)
    80001234:	6105                	addi	sp,sp,32
    80001236:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001238:	00f4863b          	addw	a2,s1,a5
    8000123c:	1602                	slli	a2,a2,0x20
    8000123e:	9201                	srli	a2,a2,0x20
    80001240:	1582                	slli	a1,a1,0x20
    80001242:	9181                	srli	a1,a1,0x20
    80001244:	6928                	ld	a0,80(a0)
    80001246:	fffff097          	auipc	ra,0xfffff
    8000124a:	696080e7          	jalr	1686(ra) # 800008dc <uvmalloc>
    8000124e:	0005079b          	sext.w	a5,a0
    80001252:	fbe1                	bnez	a5,80001222 <growproc+0x26>
      return -1;
    80001254:	557d                	li	a0,-1
    80001256:	bfd9                	j	8000122c <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001258:	00f4863b          	addw	a2,s1,a5
    8000125c:	1602                	slli	a2,a2,0x20
    8000125e:	9201                	srli	a2,a2,0x20
    80001260:	1582                	slli	a1,a1,0x20
    80001262:	9181                	srli	a1,a1,0x20
    80001264:	6928                	ld	a0,80(a0)
    80001266:	fffff097          	auipc	ra,0xfffff
    8000126a:	62e080e7          	jalr	1582(ra) # 80000894 <uvmdealloc>
    8000126e:	0005079b          	sext.w	a5,a0
    80001272:	bf45                	j	80001222 <growproc+0x26>

0000000080001274 <fork>:
{
    80001274:	7139                	addi	sp,sp,-64
    80001276:	fc06                	sd	ra,56(sp)
    80001278:	f822                	sd	s0,48(sp)
    8000127a:	f04a                	sd	s2,32(sp)
    8000127c:	e456                	sd	s5,8(sp)
    8000127e:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001280:	00000097          	auipc	ra,0x0
    80001284:	c16080e7          	jalr	-1002(ra) # 80000e96 <myproc>
    80001288:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    8000128a:	00000097          	auipc	ra,0x0
    8000128e:	e16080e7          	jalr	-490(ra) # 800010a0 <allocproc>
    80001292:	12050063          	beqz	a0,800013b2 <fork+0x13e>
    80001296:	e852                	sd	s4,16(sp)
    80001298:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    8000129a:	048ab603          	ld	a2,72(s5)
    8000129e:	692c                	ld	a1,80(a0)
    800012a0:	050ab503          	ld	a0,80(s5)
    800012a4:	fffff097          	auipc	ra,0xfffff
    800012a8:	7a2080e7          	jalr	1954(ra) # 80000a46 <uvmcopy>
    800012ac:	04054a63          	bltz	a0,80001300 <fork+0x8c>
    800012b0:	f426                	sd	s1,40(sp)
    800012b2:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    800012b4:	048ab783          	ld	a5,72(s5)
    800012b8:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    800012bc:	058ab683          	ld	a3,88(s5)
    800012c0:	87b6                	mv	a5,a3
    800012c2:	058a3703          	ld	a4,88(s4)
    800012c6:	12068693          	addi	a3,a3,288
    800012ca:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800012ce:	6788                	ld	a0,8(a5)
    800012d0:	6b8c                	ld	a1,16(a5)
    800012d2:	6f90                	ld	a2,24(a5)
    800012d4:	01073023          	sd	a6,0(a4)
    800012d8:	e708                	sd	a0,8(a4)
    800012da:	eb0c                	sd	a1,16(a4)
    800012dc:	ef10                	sd	a2,24(a4)
    800012de:	02078793          	addi	a5,a5,32
    800012e2:	02070713          	addi	a4,a4,32
    800012e6:	fed792e3          	bne	a5,a3,800012ca <fork+0x56>
  np->trapframe->a0 = 0;
    800012ea:	058a3783          	ld	a5,88(s4)
    800012ee:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800012f2:	0d0a8493          	addi	s1,s5,208
    800012f6:	0d0a0913          	addi	s2,s4,208
    800012fa:	150a8993          	addi	s3,s5,336
    800012fe:	a015                	j	80001322 <fork+0xae>
    freeproc(np);
    80001300:	8552                	mv	a0,s4
    80001302:	00000097          	auipc	ra,0x0
    80001306:	d46080e7          	jalr	-698(ra) # 80001048 <freeproc>
    release(&np->lock);
    8000130a:	8552                	mv	a0,s4
    8000130c:	00005097          	auipc	ra,0x5
    80001310:	066080e7          	jalr	102(ra) # 80006372 <release>
    return -1;
    80001314:	597d                	li	s2,-1
    80001316:	6a42                	ld	s4,16(sp)
    80001318:	a071                	j	800013a4 <fork+0x130>
  for(i = 0; i < NOFILE; i++)
    8000131a:	04a1                	addi	s1,s1,8
    8000131c:	0921                	addi	s2,s2,8
    8000131e:	01348b63          	beq	s1,s3,80001334 <fork+0xc0>
    if(p->ofile[i])
    80001322:	6088                	ld	a0,0(s1)
    80001324:	d97d                	beqz	a0,8000131a <fork+0xa6>
      np->ofile[i] = filedup(p->ofile[i]);
    80001326:	00002097          	auipc	ra,0x2
    8000132a:	66e080e7          	jalr	1646(ra) # 80003994 <filedup>
    8000132e:	00a93023          	sd	a0,0(s2)
    80001332:	b7e5                	j	8000131a <fork+0xa6>
  np->cwd = idup(p->cwd);
    80001334:	150ab503          	ld	a0,336(s5)
    80001338:	00001097          	auipc	ra,0x1
    8000133c:	7ae080e7          	jalr	1966(ra) # 80002ae6 <idup>
    80001340:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001344:	4641                	li	a2,16
    80001346:	158a8593          	addi	a1,s5,344
    8000134a:	158a0513          	addi	a0,s4,344
    8000134e:	fffff097          	auipc	ra,0xfffff
    80001352:	f82080e7          	jalr	-126(ra) # 800002d0 <safestrcpy>
  pid = np->pid;
    80001356:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    8000135a:	8552                	mv	a0,s4
    8000135c:	00005097          	auipc	ra,0x5
    80001360:	016080e7          	jalr	22(ra) # 80006372 <release>
  acquire(&wait_lock);
    80001364:	00008497          	auipc	s1,0x8
    80001368:	d0448493          	addi	s1,s1,-764 # 80009068 <wait_lock>
    8000136c:	8526                	mv	a0,s1
    8000136e:	00005097          	auipc	ra,0x5
    80001372:	f54080e7          	jalr	-172(ra) # 800062c2 <acquire>
  np->parent = p;
    80001376:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    8000137a:	8526                	mv	a0,s1
    8000137c:	00005097          	auipc	ra,0x5
    80001380:	ff6080e7          	jalr	-10(ra) # 80006372 <release>
  acquire(&np->lock);
    80001384:	8552                	mv	a0,s4
    80001386:	00005097          	auipc	ra,0x5
    8000138a:	f3c080e7          	jalr	-196(ra) # 800062c2 <acquire>
  np->state = RUNNABLE;
    8000138e:	478d                	li	a5,3
    80001390:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001394:	8552                	mv	a0,s4
    80001396:	00005097          	auipc	ra,0x5
    8000139a:	fdc080e7          	jalr	-36(ra) # 80006372 <release>
  return pid;
    8000139e:	74a2                	ld	s1,40(sp)
    800013a0:	69e2                	ld	s3,24(sp)
    800013a2:	6a42                	ld	s4,16(sp)
}
    800013a4:	854a                	mv	a0,s2
    800013a6:	70e2                	ld	ra,56(sp)
    800013a8:	7442                	ld	s0,48(sp)
    800013aa:	7902                	ld	s2,32(sp)
    800013ac:	6aa2                	ld	s5,8(sp)
    800013ae:	6121                	addi	sp,sp,64
    800013b0:	8082                	ret
    return -1;
    800013b2:	597d                	li	s2,-1
    800013b4:	bfc5                	j	800013a4 <fork+0x130>

00000000800013b6 <scheduler>:
{
    800013b6:	7139                	addi	sp,sp,-64
    800013b8:	fc06                	sd	ra,56(sp)
    800013ba:	f822                	sd	s0,48(sp)
    800013bc:	f426                	sd	s1,40(sp)
    800013be:	f04a                	sd	s2,32(sp)
    800013c0:	ec4e                	sd	s3,24(sp)
    800013c2:	e852                	sd	s4,16(sp)
    800013c4:	e456                	sd	s5,8(sp)
    800013c6:	e05a                	sd	s6,0(sp)
    800013c8:	0080                	addi	s0,sp,64
    800013ca:	8792                	mv	a5,tp
  int id = r_tp();
    800013cc:	2781                	sext.w	a5,a5
  c->proc = 0;
    800013ce:	00779a93          	slli	s5,a5,0x7
    800013d2:	00008717          	auipc	a4,0x8
    800013d6:	c7e70713          	addi	a4,a4,-898 # 80009050 <pid_lock>
    800013da:	9756                	add	a4,a4,s5
    800013dc:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800013e0:	00008717          	auipc	a4,0x8
    800013e4:	ca870713          	addi	a4,a4,-856 # 80009088 <cpus+0x8>
    800013e8:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800013ea:	498d                	li	s3,3
        p->state = RUNNING;
    800013ec:	4b11                	li	s6,4
        c->proc = p;
    800013ee:	079e                	slli	a5,a5,0x7
    800013f0:	00008a17          	auipc	s4,0x8
    800013f4:	c60a0a13          	addi	s4,s4,-928 # 80009050 <pid_lock>
    800013f8:	9a3e                	add	s4,s4,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800013fa:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800013fe:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001402:	10079073          	csrw	sstatus,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001406:	00008497          	auipc	s1,0x8
    8000140a:	07a48493          	addi	s1,s1,122 # 80009480 <proc>
    8000140e:	0000e917          	auipc	s2,0xe
    80001412:	07290913          	addi	s2,s2,114 # 8000f480 <tickslock>
    80001416:	a811                	j	8000142a <scheduler+0x74>
      release(&p->lock);
    80001418:	8526                	mv	a0,s1
    8000141a:	00005097          	auipc	ra,0x5
    8000141e:	f58080e7          	jalr	-168(ra) # 80006372 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001422:	18048493          	addi	s1,s1,384
    80001426:	fd248ae3          	beq	s1,s2,800013fa <scheduler+0x44>
      acquire(&p->lock);
    8000142a:	8526                	mv	a0,s1
    8000142c:	00005097          	auipc	ra,0x5
    80001430:	e96080e7          	jalr	-362(ra) # 800062c2 <acquire>
      if(p->state == RUNNABLE) {
    80001434:	4c9c                	lw	a5,24(s1)
    80001436:	ff3791e3          	bne	a5,s3,80001418 <scheduler+0x62>
        p->state = RUNNING;
    8000143a:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    8000143e:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001442:	06048593          	addi	a1,s1,96
    80001446:	8556                	mv	a0,s5
    80001448:	00000097          	auipc	ra,0x0
    8000144c:	61a080e7          	jalr	1562(ra) # 80001a62 <swtch>
        c->proc = 0;
    80001450:	020a3823          	sd	zero,48(s4)
    80001454:	b7d1                	j	80001418 <scheduler+0x62>

0000000080001456 <sched>:
{
    80001456:	7179                	addi	sp,sp,-48
    80001458:	f406                	sd	ra,40(sp)
    8000145a:	f022                	sd	s0,32(sp)
    8000145c:	ec26                	sd	s1,24(sp)
    8000145e:	e84a                	sd	s2,16(sp)
    80001460:	e44e                	sd	s3,8(sp)
    80001462:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001464:	00000097          	auipc	ra,0x0
    80001468:	a32080e7          	jalr	-1486(ra) # 80000e96 <myproc>
    8000146c:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    8000146e:	00005097          	auipc	ra,0x5
    80001472:	dda080e7          	jalr	-550(ra) # 80006248 <holding>
    80001476:	c93d                	beqz	a0,800014ec <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001478:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000147a:	2781                	sext.w	a5,a5
    8000147c:	079e                	slli	a5,a5,0x7
    8000147e:	00008717          	auipc	a4,0x8
    80001482:	bd270713          	addi	a4,a4,-1070 # 80009050 <pid_lock>
    80001486:	97ba                	add	a5,a5,a4
    80001488:	0a87a703          	lw	a4,168(a5)
    8000148c:	4785                	li	a5,1
    8000148e:	06f71763          	bne	a4,a5,800014fc <sched+0xa6>
  if(p->state == RUNNING)
    80001492:	4c98                	lw	a4,24(s1)
    80001494:	4791                	li	a5,4
    80001496:	06f70b63          	beq	a4,a5,8000150c <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000149a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000149e:	8b89                	andi	a5,a5,2
  if(intr_get())
    800014a0:	efb5                	bnez	a5,8000151c <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    800014a2:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800014a4:	00008917          	auipc	s2,0x8
    800014a8:	bac90913          	addi	s2,s2,-1108 # 80009050 <pid_lock>
    800014ac:	2781                	sext.w	a5,a5
    800014ae:	079e                	slli	a5,a5,0x7
    800014b0:	97ca                	add	a5,a5,s2
    800014b2:	0ac7a983          	lw	s3,172(a5)
    800014b6:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800014b8:	2781                	sext.w	a5,a5
    800014ba:	079e                	slli	a5,a5,0x7
    800014bc:	00008597          	auipc	a1,0x8
    800014c0:	bcc58593          	addi	a1,a1,-1076 # 80009088 <cpus+0x8>
    800014c4:	95be                	add	a1,a1,a5
    800014c6:	06048513          	addi	a0,s1,96
    800014ca:	00000097          	auipc	ra,0x0
    800014ce:	598080e7          	jalr	1432(ra) # 80001a62 <swtch>
    800014d2:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800014d4:	2781                	sext.w	a5,a5
    800014d6:	079e                	slli	a5,a5,0x7
    800014d8:	993e                	add	s2,s2,a5
    800014da:	0b392623          	sw	s3,172(s2)
}
    800014de:	70a2                	ld	ra,40(sp)
    800014e0:	7402                	ld	s0,32(sp)
    800014e2:	64e2                	ld	s1,24(sp)
    800014e4:	6942                	ld	s2,16(sp)
    800014e6:	69a2                	ld	s3,8(sp)
    800014e8:	6145                	addi	sp,sp,48
    800014ea:	8082                	ret
    panic("sched p->lock");
    800014ec:	00007517          	auipc	a0,0x7
    800014f0:	cac50513          	addi	a0,a0,-852 # 80008198 <etext+0x198>
    800014f4:	00005097          	auipc	ra,0x5
    800014f8:	878080e7          	jalr	-1928(ra) # 80005d6c <panic>
    panic("sched locks");
    800014fc:	00007517          	auipc	a0,0x7
    80001500:	cac50513          	addi	a0,a0,-852 # 800081a8 <etext+0x1a8>
    80001504:	00005097          	auipc	ra,0x5
    80001508:	868080e7          	jalr	-1944(ra) # 80005d6c <panic>
    panic("sched running");
    8000150c:	00007517          	auipc	a0,0x7
    80001510:	cac50513          	addi	a0,a0,-852 # 800081b8 <etext+0x1b8>
    80001514:	00005097          	auipc	ra,0x5
    80001518:	858080e7          	jalr	-1960(ra) # 80005d6c <panic>
    panic("sched interruptible");
    8000151c:	00007517          	auipc	a0,0x7
    80001520:	cac50513          	addi	a0,a0,-852 # 800081c8 <etext+0x1c8>
    80001524:	00005097          	auipc	ra,0x5
    80001528:	848080e7          	jalr	-1976(ra) # 80005d6c <panic>

000000008000152c <yield>:
{
    8000152c:	1101                	addi	sp,sp,-32
    8000152e:	ec06                	sd	ra,24(sp)
    80001530:	e822                	sd	s0,16(sp)
    80001532:	e426                	sd	s1,8(sp)
    80001534:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001536:	00000097          	auipc	ra,0x0
    8000153a:	960080e7          	jalr	-1696(ra) # 80000e96 <myproc>
    8000153e:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001540:	00005097          	auipc	ra,0x5
    80001544:	d82080e7          	jalr	-638(ra) # 800062c2 <acquire>
  p->state = RUNNABLE;
    80001548:	478d                	li	a5,3
    8000154a:	cc9c                	sw	a5,24(s1)
  sched();
    8000154c:	00000097          	auipc	ra,0x0
    80001550:	f0a080e7          	jalr	-246(ra) # 80001456 <sched>
  release(&p->lock);
    80001554:	8526                	mv	a0,s1
    80001556:	00005097          	auipc	ra,0x5
    8000155a:	e1c080e7          	jalr	-484(ra) # 80006372 <release>
}
    8000155e:	60e2                	ld	ra,24(sp)
    80001560:	6442                	ld	s0,16(sp)
    80001562:	64a2                	ld	s1,8(sp)
    80001564:	6105                	addi	sp,sp,32
    80001566:	8082                	ret

0000000080001568 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001568:	7179                	addi	sp,sp,-48
    8000156a:	f406                	sd	ra,40(sp)
    8000156c:	f022                	sd	s0,32(sp)
    8000156e:	ec26                	sd	s1,24(sp)
    80001570:	e84a                	sd	s2,16(sp)
    80001572:	e44e                	sd	s3,8(sp)
    80001574:	1800                	addi	s0,sp,48
    80001576:	89aa                	mv	s3,a0
    80001578:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000157a:	00000097          	auipc	ra,0x0
    8000157e:	91c080e7          	jalr	-1764(ra) # 80000e96 <myproc>
    80001582:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001584:	00005097          	auipc	ra,0x5
    80001588:	d3e080e7          	jalr	-706(ra) # 800062c2 <acquire>
  release(lk);
    8000158c:	854a                	mv	a0,s2
    8000158e:	00005097          	auipc	ra,0x5
    80001592:	de4080e7          	jalr	-540(ra) # 80006372 <release>

  // Go to sleep.
  p->chan = chan;
    80001596:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000159a:	4789                	li	a5,2
    8000159c:	cc9c                	sw	a5,24(s1)

  sched();
    8000159e:	00000097          	auipc	ra,0x0
    800015a2:	eb8080e7          	jalr	-328(ra) # 80001456 <sched>

  // Tidy up.
  p->chan = 0;
    800015a6:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800015aa:	8526                	mv	a0,s1
    800015ac:	00005097          	auipc	ra,0x5
    800015b0:	dc6080e7          	jalr	-570(ra) # 80006372 <release>
  acquire(lk);
    800015b4:	854a                	mv	a0,s2
    800015b6:	00005097          	auipc	ra,0x5
    800015ba:	d0c080e7          	jalr	-756(ra) # 800062c2 <acquire>
}
    800015be:	70a2                	ld	ra,40(sp)
    800015c0:	7402                	ld	s0,32(sp)
    800015c2:	64e2                	ld	s1,24(sp)
    800015c4:	6942                	ld	s2,16(sp)
    800015c6:	69a2                	ld	s3,8(sp)
    800015c8:	6145                	addi	sp,sp,48
    800015ca:	8082                	ret

00000000800015cc <wait>:
{
    800015cc:	715d                	addi	sp,sp,-80
    800015ce:	e486                	sd	ra,72(sp)
    800015d0:	e0a2                	sd	s0,64(sp)
    800015d2:	fc26                	sd	s1,56(sp)
    800015d4:	f84a                	sd	s2,48(sp)
    800015d6:	f44e                	sd	s3,40(sp)
    800015d8:	f052                	sd	s4,32(sp)
    800015da:	ec56                	sd	s5,24(sp)
    800015dc:	e85a                	sd	s6,16(sp)
    800015de:	e45e                	sd	s7,8(sp)
    800015e0:	0880                	addi	s0,sp,80
    800015e2:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800015e4:	00000097          	auipc	ra,0x0
    800015e8:	8b2080e7          	jalr	-1870(ra) # 80000e96 <myproc>
    800015ec:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800015ee:	00008517          	auipc	a0,0x8
    800015f2:	a7a50513          	addi	a0,a0,-1414 # 80009068 <wait_lock>
    800015f6:	00005097          	auipc	ra,0x5
    800015fa:	ccc080e7          	jalr	-820(ra) # 800062c2 <acquire>
        if(np->state == ZOMBIE){
    800015fe:	4a15                	li	s4,5
        havekids = 1;
    80001600:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    80001602:	0000e997          	auipc	s3,0xe
    80001606:	e7e98993          	addi	s3,s3,-386 # 8000f480 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000160a:	00008b97          	auipc	s7,0x8
    8000160e:	a5eb8b93          	addi	s7,s7,-1442 # 80009068 <wait_lock>
    80001612:	a875                	j	800016ce <wait+0x102>
          pid = np->pid;
    80001614:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    80001618:	000b0e63          	beqz	s6,80001634 <wait+0x68>
    8000161c:	4691                	li	a3,4
    8000161e:	02c48613          	addi	a2,s1,44
    80001622:	85da                	mv	a1,s6
    80001624:	05093503          	ld	a0,80(s2)
    80001628:	fffff097          	auipc	ra,0xfffff
    8000162c:	526080e7          	jalr	1318(ra) # 80000b4e <copyout>
    80001630:	04054063          	bltz	a0,80001670 <wait+0xa4>
          freeproc(np);
    80001634:	8526                	mv	a0,s1
    80001636:	00000097          	auipc	ra,0x0
    8000163a:	a12080e7          	jalr	-1518(ra) # 80001048 <freeproc>
          release(&np->lock);
    8000163e:	8526                	mv	a0,s1
    80001640:	00005097          	auipc	ra,0x5
    80001644:	d32080e7          	jalr	-718(ra) # 80006372 <release>
          release(&wait_lock);
    80001648:	00008517          	auipc	a0,0x8
    8000164c:	a2050513          	addi	a0,a0,-1504 # 80009068 <wait_lock>
    80001650:	00005097          	auipc	ra,0x5
    80001654:	d22080e7          	jalr	-734(ra) # 80006372 <release>
}
    80001658:	854e                	mv	a0,s3
    8000165a:	60a6                	ld	ra,72(sp)
    8000165c:	6406                	ld	s0,64(sp)
    8000165e:	74e2                	ld	s1,56(sp)
    80001660:	7942                	ld	s2,48(sp)
    80001662:	79a2                	ld	s3,40(sp)
    80001664:	7a02                	ld	s4,32(sp)
    80001666:	6ae2                	ld	s5,24(sp)
    80001668:	6b42                	ld	s6,16(sp)
    8000166a:	6ba2                	ld	s7,8(sp)
    8000166c:	6161                	addi	sp,sp,80
    8000166e:	8082                	ret
            release(&np->lock);
    80001670:	8526                	mv	a0,s1
    80001672:	00005097          	auipc	ra,0x5
    80001676:	d00080e7          	jalr	-768(ra) # 80006372 <release>
            release(&wait_lock);
    8000167a:	00008517          	auipc	a0,0x8
    8000167e:	9ee50513          	addi	a0,a0,-1554 # 80009068 <wait_lock>
    80001682:	00005097          	auipc	ra,0x5
    80001686:	cf0080e7          	jalr	-784(ra) # 80006372 <release>
            return -1;
    8000168a:	59fd                	li	s3,-1
    8000168c:	b7f1                	j	80001658 <wait+0x8c>
    for(np = proc; np < &proc[NPROC]; np++){
    8000168e:	18048493          	addi	s1,s1,384
    80001692:	03348463          	beq	s1,s3,800016ba <wait+0xee>
      if(np->parent == p){
    80001696:	7c9c                	ld	a5,56(s1)
    80001698:	ff279be3          	bne	a5,s2,8000168e <wait+0xc2>
        acquire(&np->lock);
    8000169c:	8526                	mv	a0,s1
    8000169e:	00005097          	auipc	ra,0x5
    800016a2:	c24080e7          	jalr	-988(ra) # 800062c2 <acquire>
        if(np->state == ZOMBIE){
    800016a6:	4c9c                	lw	a5,24(s1)
    800016a8:	f74786e3          	beq	a5,s4,80001614 <wait+0x48>
        release(&np->lock);
    800016ac:	8526                	mv	a0,s1
    800016ae:	00005097          	auipc	ra,0x5
    800016b2:	cc4080e7          	jalr	-828(ra) # 80006372 <release>
        havekids = 1;
    800016b6:	8756                	mv	a4,s5
    800016b8:	bfd9                	j	8000168e <wait+0xc2>
    if(!havekids || p->killed){
    800016ba:	c305                	beqz	a4,800016da <wait+0x10e>
    800016bc:	02892783          	lw	a5,40(s2)
    800016c0:	ef89                	bnez	a5,800016da <wait+0x10e>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800016c2:	85de                	mv	a1,s7
    800016c4:	854a                	mv	a0,s2
    800016c6:	00000097          	auipc	ra,0x0
    800016ca:	ea2080e7          	jalr	-350(ra) # 80001568 <sleep>
    havekids = 0;
    800016ce:	4701                	li	a4,0
    for(np = proc; np < &proc[NPROC]; np++){
    800016d0:	00008497          	auipc	s1,0x8
    800016d4:	db048493          	addi	s1,s1,-592 # 80009480 <proc>
    800016d8:	bf7d                	j	80001696 <wait+0xca>
      release(&wait_lock);
    800016da:	00008517          	auipc	a0,0x8
    800016de:	98e50513          	addi	a0,a0,-1650 # 80009068 <wait_lock>
    800016e2:	00005097          	auipc	ra,0x5
    800016e6:	c90080e7          	jalr	-880(ra) # 80006372 <release>
      return -1;
    800016ea:	59fd                	li	s3,-1
    800016ec:	b7b5                	j	80001658 <wait+0x8c>

00000000800016ee <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800016ee:	7139                	addi	sp,sp,-64
    800016f0:	fc06                	sd	ra,56(sp)
    800016f2:	f822                	sd	s0,48(sp)
    800016f4:	f426                	sd	s1,40(sp)
    800016f6:	f04a                	sd	s2,32(sp)
    800016f8:	ec4e                	sd	s3,24(sp)
    800016fa:	e852                	sd	s4,16(sp)
    800016fc:	e456                	sd	s5,8(sp)
    800016fe:	0080                	addi	s0,sp,64
    80001700:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001702:	00008497          	auipc	s1,0x8
    80001706:	d7e48493          	addi	s1,s1,-642 # 80009480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    8000170a:	4989                	li	s3,2
        p->state = RUNNABLE;
    8000170c:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    8000170e:	0000e917          	auipc	s2,0xe
    80001712:	d7290913          	addi	s2,s2,-654 # 8000f480 <tickslock>
    80001716:	a811                	j	8000172a <wakeup+0x3c>
      }
      release(&p->lock);
    80001718:	8526                	mv	a0,s1
    8000171a:	00005097          	auipc	ra,0x5
    8000171e:	c58080e7          	jalr	-936(ra) # 80006372 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001722:	18048493          	addi	s1,s1,384
    80001726:	03248663          	beq	s1,s2,80001752 <wakeup+0x64>
    if(p != myproc()){
    8000172a:	fffff097          	auipc	ra,0xfffff
    8000172e:	76c080e7          	jalr	1900(ra) # 80000e96 <myproc>
    80001732:	fea488e3          	beq	s1,a0,80001722 <wakeup+0x34>
      acquire(&p->lock);
    80001736:	8526                	mv	a0,s1
    80001738:	00005097          	auipc	ra,0x5
    8000173c:	b8a080e7          	jalr	-1142(ra) # 800062c2 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001740:	4c9c                	lw	a5,24(s1)
    80001742:	fd379be3          	bne	a5,s3,80001718 <wakeup+0x2a>
    80001746:	709c                	ld	a5,32(s1)
    80001748:	fd4798e3          	bne	a5,s4,80001718 <wakeup+0x2a>
        p->state = RUNNABLE;
    8000174c:	0154ac23          	sw	s5,24(s1)
    80001750:	b7e1                	j	80001718 <wakeup+0x2a>
    }
  }
}
    80001752:	70e2                	ld	ra,56(sp)
    80001754:	7442                	ld	s0,48(sp)
    80001756:	74a2                	ld	s1,40(sp)
    80001758:	7902                	ld	s2,32(sp)
    8000175a:	69e2                	ld	s3,24(sp)
    8000175c:	6a42                	ld	s4,16(sp)
    8000175e:	6aa2                	ld	s5,8(sp)
    80001760:	6121                	addi	sp,sp,64
    80001762:	8082                	ret

0000000080001764 <reparent>:
{
    80001764:	7179                	addi	sp,sp,-48
    80001766:	f406                	sd	ra,40(sp)
    80001768:	f022                	sd	s0,32(sp)
    8000176a:	ec26                	sd	s1,24(sp)
    8000176c:	e84a                	sd	s2,16(sp)
    8000176e:	e44e                	sd	s3,8(sp)
    80001770:	e052                	sd	s4,0(sp)
    80001772:	1800                	addi	s0,sp,48
    80001774:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001776:	00008497          	auipc	s1,0x8
    8000177a:	d0a48493          	addi	s1,s1,-758 # 80009480 <proc>
      pp->parent = initproc;
    8000177e:	00008a17          	auipc	s4,0x8
    80001782:	892a0a13          	addi	s4,s4,-1902 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001786:	0000e997          	auipc	s3,0xe
    8000178a:	cfa98993          	addi	s3,s3,-774 # 8000f480 <tickslock>
    8000178e:	a029                	j	80001798 <reparent+0x34>
    80001790:	18048493          	addi	s1,s1,384
    80001794:	01348d63          	beq	s1,s3,800017ae <reparent+0x4a>
    if(pp->parent == p){
    80001798:	7c9c                	ld	a5,56(s1)
    8000179a:	ff279be3          	bne	a5,s2,80001790 <reparent+0x2c>
      pp->parent = initproc;
    8000179e:	000a3503          	ld	a0,0(s4)
    800017a2:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    800017a4:	00000097          	auipc	ra,0x0
    800017a8:	f4a080e7          	jalr	-182(ra) # 800016ee <wakeup>
    800017ac:	b7d5                	j	80001790 <reparent+0x2c>
}
    800017ae:	70a2                	ld	ra,40(sp)
    800017b0:	7402                	ld	s0,32(sp)
    800017b2:	64e2                	ld	s1,24(sp)
    800017b4:	6942                	ld	s2,16(sp)
    800017b6:	69a2                	ld	s3,8(sp)
    800017b8:	6a02                	ld	s4,0(sp)
    800017ba:	6145                	addi	sp,sp,48
    800017bc:	8082                	ret

00000000800017be <exit>:
{
    800017be:	7179                	addi	sp,sp,-48
    800017c0:	f406                	sd	ra,40(sp)
    800017c2:	f022                	sd	s0,32(sp)
    800017c4:	ec26                	sd	s1,24(sp)
    800017c6:	e84a                	sd	s2,16(sp)
    800017c8:	e44e                	sd	s3,8(sp)
    800017ca:	e052                	sd	s4,0(sp)
    800017cc:	1800                	addi	s0,sp,48
    800017ce:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800017d0:	fffff097          	auipc	ra,0xfffff
    800017d4:	6c6080e7          	jalr	1734(ra) # 80000e96 <myproc>
    800017d8:	89aa                	mv	s3,a0
  if(p == initproc)
    800017da:	00008797          	auipc	a5,0x8
    800017de:	8367b783          	ld	a5,-1994(a5) # 80009010 <initproc>
    800017e2:	0d050493          	addi	s1,a0,208
    800017e6:	15050913          	addi	s2,a0,336
    800017ea:	00a79d63          	bne	a5,a0,80001804 <exit+0x46>
    panic("init exiting");
    800017ee:	00007517          	auipc	a0,0x7
    800017f2:	9f250513          	addi	a0,a0,-1550 # 800081e0 <etext+0x1e0>
    800017f6:	00004097          	auipc	ra,0x4
    800017fa:	576080e7          	jalr	1398(ra) # 80005d6c <panic>
  for(int fd = 0; fd < NOFILE; fd++){
    800017fe:	04a1                	addi	s1,s1,8
    80001800:	01248b63          	beq	s1,s2,80001816 <exit+0x58>
    if(p->ofile[fd]){
    80001804:	6088                	ld	a0,0(s1)
    80001806:	dd65                	beqz	a0,800017fe <exit+0x40>
      fileclose(f);
    80001808:	00002097          	auipc	ra,0x2
    8000180c:	1de080e7          	jalr	478(ra) # 800039e6 <fileclose>
      p->ofile[fd] = 0;
    80001810:	0004b023          	sd	zero,0(s1)
    80001814:	b7ed                	j	800017fe <exit+0x40>
  begin_op();
    80001816:	00002097          	auipc	ra,0x2
    8000181a:	d00080e7          	jalr	-768(ra) # 80003516 <begin_op>
  iput(p->cwd);
    8000181e:	1509b503          	ld	a0,336(s3)
    80001822:	00001097          	auipc	ra,0x1
    80001826:	4c0080e7          	jalr	1216(ra) # 80002ce2 <iput>
  end_op();
    8000182a:	00002097          	auipc	ra,0x2
    8000182e:	d66080e7          	jalr	-666(ra) # 80003590 <end_op>
  p->cwd = 0;
    80001832:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001836:	00008497          	auipc	s1,0x8
    8000183a:	83248493          	addi	s1,s1,-1998 # 80009068 <wait_lock>
    8000183e:	8526                	mv	a0,s1
    80001840:	00005097          	auipc	ra,0x5
    80001844:	a82080e7          	jalr	-1406(ra) # 800062c2 <acquire>
  reparent(p);
    80001848:	854e                	mv	a0,s3
    8000184a:	00000097          	auipc	ra,0x0
    8000184e:	f1a080e7          	jalr	-230(ra) # 80001764 <reparent>
  wakeup(p->parent);
    80001852:	0389b503          	ld	a0,56(s3)
    80001856:	00000097          	auipc	ra,0x0
    8000185a:	e98080e7          	jalr	-360(ra) # 800016ee <wakeup>
  acquire(&p->lock);
    8000185e:	854e                	mv	a0,s3
    80001860:	00005097          	auipc	ra,0x5
    80001864:	a62080e7          	jalr	-1438(ra) # 800062c2 <acquire>
  p->xstate = status;
    80001868:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    8000186c:	4795                	li	a5,5
    8000186e:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001872:	8526                	mv	a0,s1
    80001874:	00005097          	auipc	ra,0x5
    80001878:	afe080e7          	jalr	-1282(ra) # 80006372 <release>
  sched();
    8000187c:	00000097          	auipc	ra,0x0
    80001880:	bda080e7          	jalr	-1062(ra) # 80001456 <sched>
  panic("zombie exit");
    80001884:	00007517          	auipc	a0,0x7
    80001888:	96c50513          	addi	a0,a0,-1684 # 800081f0 <etext+0x1f0>
    8000188c:	00004097          	auipc	ra,0x4
    80001890:	4e0080e7          	jalr	1248(ra) # 80005d6c <panic>

0000000080001894 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001894:	7179                	addi	sp,sp,-48
    80001896:	f406                	sd	ra,40(sp)
    80001898:	f022                	sd	s0,32(sp)
    8000189a:	ec26                	sd	s1,24(sp)
    8000189c:	e84a                	sd	s2,16(sp)
    8000189e:	e44e                	sd	s3,8(sp)
    800018a0:	1800                	addi	s0,sp,48
    800018a2:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800018a4:	00008497          	auipc	s1,0x8
    800018a8:	bdc48493          	addi	s1,s1,-1060 # 80009480 <proc>
    800018ac:	0000e997          	auipc	s3,0xe
    800018b0:	bd498993          	addi	s3,s3,-1068 # 8000f480 <tickslock>
    acquire(&p->lock);
    800018b4:	8526                	mv	a0,s1
    800018b6:	00005097          	auipc	ra,0x5
    800018ba:	a0c080e7          	jalr	-1524(ra) # 800062c2 <acquire>
    if(p->pid == pid){
    800018be:	589c                	lw	a5,48(s1)
    800018c0:	01278d63          	beq	a5,s2,800018da <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800018c4:	8526                	mv	a0,s1
    800018c6:	00005097          	auipc	ra,0x5
    800018ca:	aac080e7          	jalr	-1364(ra) # 80006372 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800018ce:	18048493          	addi	s1,s1,384
    800018d2:	ff3491e3          	bne	s1,s3,800018b4 <kill+0x20>
  }
  return -1;
    800018d6:	557d                	li	a0,-1
    800018d8:	a829                	j	800018f2 <kill+0x5e>
      p->killed = 1;
    800018da:	4785                	li	a5,1
    800018dc:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800018de:	4c98                	lw	a4,24(s1)
    800018e0:	4789                	li	a5,2
    800018e2:	00f70f63          	beq	a4,a5,80001900 <kill+0x6c>
      release(&p->lock);
    800018e6:	8526                	mv	a0,s1
    800018e8:	00005097          	auipc	ra,0x5
    800018ec:	a8a080e7          	jalr	-1398(ra) # 80006372 <release>
      return 0;
    800018f0:	4501                	li	a0,0
}
    800018f2:	70a2                	ld	ra,40(sp)
    800018f4:	7402                	ld	s0,32(sp)
    800018f6:	64e2                	ld	s1,24(sp)
    800018f8:	6942                	ld	s2,16(sp)
    800018fa:	69a2                	ld	s3,8(sp)
    800018fc:	6145                	addi	sp,sp,48
    800018fe:	8082                	ret
        p->state = RUNNABLE;
    80001900:	478d                	li	a5,3
    80001902:	cc9c                	sw	a5,24(s1)
    80001904:	b7cd                	j	800018e6 <kill+0x52>

0000000080001906 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001906:	7179                	addi	sp,sp,-48
    80001908:	f406                	sd	ra,40(sp)
    8000190a:	f022                	sd	s0,32(sp)
    8000190c:	ec26                	sd	s1,24(sp)
    8000190e:	e84a                	sd	s2,16(sp)
    80001910:	e44e                	sd	s3,8(sp)
    80001912:	e052                	sd	s4,0(sp)
    80001914:	1800                	addi	s0,sp,48
    80001916:	84aa                	mv	s1,a0
    80001918:	892e                	mv	s2,a1
    8000191a:	89b2                	mv	s3,a2
    8000191c:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000191e:	fffff097          	auipc	ra,0xfffff
    80001922:	578080e7          	jalr	1400(ra) # 80000e96 <myproc>
  if(user_dst){
    80001926:	c08d                	beqz	s1,80001948 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001928:	86d2                	mv	a3,s4
    8000192a:	864e                	mv	a2,s3
    8000192c:	85ca                	mv	a1,s2
    8000192e:	6928                	ld	a0,80(a0)
    80001930:	fffff097          	auipc	ra,0xfffff
    80001934:	21e080e7          	jalr	542(ra) # 80000b4e <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001938:	70a2                	ld	ra,40(sp)
    8000193a:	7402                	ld	s0,32(sp)
    8000193c:	64e2                	ld	s1,24(sp)
    8000193e:	6942                	ld	s2,16(sp)
    80001940:	69a2                	ld	s3,8(sp)
    80001942:	6a02                	ld	s4,0(sp)
    80001944:	6145                	addi	sp,sp,48
    80001946:	8082                	ret
    memmove((char *)dst, src, len);
    80001948:	000a061b          	sext.w	a2,s4
    8000194c:	85ce                	mv	a1,s3
    8000194e:	854a                	mv	a0,s2
    80001950:	fffff097          	auipc	ra,0xfffff
    80001954:	88e080e7          	jalr	-1906(ra) # 800001de <memmove>
    return 0;
    80001958:	8526                	mv	a0,s1
    8000195a:	bff9                	j	80001938 <either_copyout+0x32>

000000008000195c <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8000195c:	7179                	addi	sp,sp,-48
    8000195e:	f406                	sd	ra,40(sp)
    80001960:	f022                	sd	s0,32(sp)
    80001962:	ec26                	sd	s1,24(sp)
    80001964:	e84a                	sd	s2,16(sp)
    80001966:	e44e                	sd	s3,8(sp)
    80001968:	e052                	sd	s4,0(sp)
    8000196a:	1800                	addi	s0,sp,48
    8000196c:	892a                	mv	s2,a0
    8000196e:	84ae                	mv	s1,a1
    80001970:	89b2                	mv	s3,a2
    80001972:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001974:	fffff097          	auipc	ra,0xfffff
    80001978:	522080e7          	jalr	1314(ra) # 80000e96 <myproc>
  if(user_src){
    8000197c:	c08d                	beqz	s1,8000199e <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    8000197e:	86d2                	mv	a3,s4
    80001980:	864e                	mv	a2,s3
    80001982:	85ca                	mv	a1,s2
    80001984:	6928                	ld	a0,80(a0)
    80001986:	fffff097          	auipc	ra,0xfffff
    8000198a:	254080e7          	jalr	596(ra) # 80000bda <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    8000198e:	70a2                	ld	ra,40(sp)
    80001990:	7402                	ld	s0,32(sp)
    80001992:	64e2                	ld	s1,24(sp)
    80001994:	6942                	ld	s2,16(sp)
    80001996:	69a2                	ld	s3,8(sp)
    80001998:	6a02                	ld	s4,0(sp)
    8000199a:	6145                	addi	sp,sp,48
    8000199c:	8082                	ret
    memmove(dst, (char*)src, len);
    8000199e:	000a061b          	sext.w	a2,s4
    800019a2:	85ce                	mv	a1,s3
    800019a4:	854a                	mv	a0,s2
    800019a6:	fffff097          	auipc	ra,0xfffff
    800019aa:	838080e7          	jalr	-1992(ra) # 800001de <memmove>
    return 0;
    800019ae:	8526                	mv	a0,s1
    800019b0:	bff9                	j	8000198e <either_copyin+0x32>

00000000800019b2 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800019b2:	715d                	addi	sp,sp,-80
    800019b4:	e486                	sd	ra,72(sp)
    800019b6:	e0a2                	sd	s0,64(sp)
    800019b8:	fc26                	sd	s1,56(sp)
    800019ba:	f84a                	sd	s2,48(sp)
    800019bc:	f44e                	sd	s3,40(sp)
    800019be:	f052                	sd	s4,32(sp)
    800019c0:	ec56                	sd	s5,24(sp)
    800019c2:	e85a                	sd	s6,16(sp)
    800019c4:	e45e                	sd	s7,8(sp)
    800019c6:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800019c8:	00006517          	auipc	a0,0x6
    800019cc:	65050513          	addi	a0,a0,1616 # 80008018 <etext+0x18>
    800019d0:	00004097          	auipc	ra,0x4
    800019d4:	3ee080e7          	jalr	1006(ra) # 80005dbe <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800019d8:	00008497          	auipc	s1,0x8
    800019dc:	c0048493          	addi	s1,s1,-1024 # 800095d8 <proc+0x158>
    800019e0:	0000e917          	auipc	s2,0xe
    800019e4:	bf890913          	addi	s2,s2,-1032 # 8000f5d8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019e8:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800019ea:	00007997          	auipc	s3,0x7
    800019ee:	81698993          	addi	s3,s3,-2026 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    800019f2:	00007a97          	auipc	s5,0x7
    800019f6:	816a8a93          	addi	s5,s5,-2026 # 80008208 <etext+0x208>
    printf("\n");
    800019fa:	00006a17          	auipc	s4,0x6
    800019fe:	61ea0a13          	addi	s4,s4,1566 # 80008018 <etext+0x18>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a02:	00007b97          	auipc	s7,0x7
    80001a06:	d06b8b93          	addi	s7,s7,-762 # 80008708 <states.0>
    80001a0a:	a00d                	j	80001a2c <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001a0c:	ed86a583          	lw	a1,-296(a3)
    80001a10:	8556                	mv	a0,s5
    80001a12:	00004097          	auipc	ra,0x4
    80001a16:	3ac080e7          	jalr	940(ra) # 80005dbe <printf>
    printf("\n");
    80001a1a:	8552                	mv	a0,s4
    80001a1c:	00004097          	auipc	ra,0x4
    80001a20:	3a2080e7          	jalr	930(ra) # 80005dbe <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a24:	18048493          	addi	s1,s1,384
    80001a28:	03248263          	beq	s1,s2,80001a4c <procdump+0x9a>
    if(p->state == UNUSED)
    80001a2c:	86a6                	mv	a3,s1
    80001a2e:	ec04a783          	lw	a5,-320(s1)
    80001a32:	dbed                	beqz	a5,80001a24 <procdump+0x72>
      state = "???";
    80001a34:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a36:	fcfb6be3          	bltu	s6,a5,80001a0c <procdump+0x5a>
    80001a3a:	02079713          	slli	a4,a5,0x20
    80001a3e:	01d75793          	srli	a5,a4,0x1d
    80001a42:	97de                	add	a5,a5,s7
    80001a44:	6390                	ld	a2,0(a5)
    80001a46:	f279                	bnez	a2,80001a0c <procdump+0x5a>
      state = "???";
    80001a48:	864e                	mv	a2,s3
    80001a4a:	b7c9                	j	80001a0c <procdump+0x5a>
  }
}
    80001a4c:	60a6                	ld	ra,72(sp)
    80001a4e:	6406                	ld	s0,64(sp)
    80001a50:	74e2                	ld	s1,56(sp)
    80001a52:	7942                	ld	s2,48(sp)
    80001a54:	79a2                	ld	s3,40(sp)
    80001a56:	7a02                	ld	s4,32(sp)
    80001a58:	6ae2                	ld	s5,24(sp)
    80001a5a:	6b42                	ld	s6,16(sp)
    80001a5c:	6ba2                	ld	s7,8(sp)
    80001a5e:	6161                	addi	sp,sp,80
    80001a60:	8082                	ret

0000000080001a62 <swtch>:
    80001a62:	00153023          	sd	ra,0(a0)
    80001a66:	00253423          	sd	sp,8(a0)
    80001a6a:	e900                	sd	s0,16(a0)
    80001a6c:	ed04                	sd	s1,24(a0)
    80001a6e:	03253023          	sd	s2,32(a0)
    80001a72:	03353423          	sd	s3,40(a0)
    80001a76:	03453823          	sd	s4,48(a0)
    80001a7a:	03553c23          	sd	s5,56(a0)
    80001a7e:	05653023          	sd	s6,64(a0)
    80001a82:	05753423          	sd	s7,72(a0)
    80001a86:	05853823          	sd	s8,80(a0)
    80001a8a:	05953c23          	sd	s9,88(a0)
    80001a8e:	07a53023          	sd	s10,96(a0)
    80001a92:	07b53423          	sd	s11,104(a0)
    80001a96:	0005b083          	ld	ra,0(a1)
    80001a9a:	0085b103          	ld	sp,8(a1)
    80001a9e:	6980                	ld	s0,16(a1)
    80001aa0:	6d84                	ld	s1,24(a1)
    80001aa2:	0205b903          	ld	s2,32(a1)
    80001aa6:	0285b983          	ld	s3,40(a1)
    80001aaa:	0305ba03          	ld	s4,48(a1)
    80001aae:	0385ba83          	ld	s5,56(a1)
    80001ab2:	0405bb03          	ld	s6,64(a1)
    80001ab6:	0485bb83          	ld	s7,72(a1)
    80001aba:	0505bc03          	ld	s8,80(a1)
    80001abe:	0585bc83          	ld	s9,88(a1)
    80001ac2:	0605bd03          	ld	s10,96(a1)
    80001ac6:	0685bd83          	ld	s11,104(a1)
    80001aca:	8082                	ret

0000000080001acc <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001acc:	1141                	addi	sp,sp,-16
    80001ace:	e406                	sd	ra,8(sp)
    80001ad0:	e022                	sd	s0,0(sp)
    80001ad2:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001ad4:	00006597          	auipc	a1,0x6
    80001ad8:	76c58593          	addi	a1,a1,1900 # 80008240 <etext+0x240>
    80001adc:	0000e517          	auipc	a0,0xe
    80001ae0:	9a450513          	addi	a0,a0,-1628 # 8000f480 <tickslock>
    80001ae4:	00004097          	auipc	ra,0x4
    80001ae8:	74a080e7          	jalr	1866(ra) # 8000622e <initlock>
}
    80001aec:	60a2                	ld	ra,8(sp)
    80001aee:	6402                	ld	s0,0(sp)
    80001af0:	0141                	addi	sp,sp,16
    80001af2:	8082                	ret

0000000080001af4 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001af4:	1141                	addi	sp,sp,-16
    80001af6:	e406                	sd	ra,8(sp)
    80001af8:	e022                	sd	s0,0(sp)
    80001afa:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001afc:	00003797          	auipc	a5,0x3
    80001b00:	61478793          	addi	a5,a5,1556 # 80005110 <kernelvec>
    80001b04:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001b08:	60a2                	ld	ra,8(sp)
    80001b0a:	6402                	ld	s0,0(sp)
    80001b0c:	0141                	addi	sp,sp,16
    80001b0e:	8082                	ret

0000000080001b10 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001b10:	1141                	addi	sp,sp,-16
    80001b12:	e406                	sd	ra,8(sp)
    80001b14:	e022                	sd	s0,0(sp)
    80001b16:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001b18:	fffff097          	auipc	ra,0xfffff
    80001b1c:	37e080e7          	jalr	894(ra) # 80000e96 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b20:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001b24:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b26:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001b2a:	00005697          	auipc	a3,0x5
    80001b2e:	4d668693          	addi	a3,a3,1238 # 80007000 <_trampoline>
    80001b32:	00005717          	auipc	a4,0x5
    80001b36:	4ce70713          	addi	a4,a4,1230 # 80007000 <_trampoline>
    80001b3a:	8f15                	sub	a4,a4,a3
    80001b3c:	040007b7          	lui	a5,0x4000
    80001b40:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001b42:	07b2                	slli	a5,a5,0xc
    80001b44:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b46:	10571073          	csrw	stvec,a4

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001b4a:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001b4c:	18002673          	csrr	a2,satp
    80001b50:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001b52:	6d30                	ld	a2,88(a0)
    80001b54:	6138                	ld	a4,64(a0)
    80001b56:	6585                	lui	a1,0x1
    80001b58:	972e                	add	a4,a4,a1
    80001b5a:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001b5c:	6d38                	ld	a4,88(a0)
    80001b5e:	00000617          	auipc	a2,0x0
    80001b62:	14060613          	addi	a2,a2,320 # 80001c9e <usertrap>
    80001b66:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001b68:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001b6a:	8612                	mv	a2,tp
    80001b6c:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b6e:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001b72:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001b76:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b7a:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001b7e:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001b80:	6f18                	ld	a4,24(a4)
    80001b82:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001b86:	692c                	ld	a1,80(a0)
    80001b88:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001b8a:	00005717          	auipc	a4,0x5
    80001b8e:	50670713          	addi	a4,a4,1286 # 80007090 <userret>
    80001b92:	8f15                	sub	a4,a4,a3
    80001b94:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001b96:	577d                	li	a4,-1
    80001b98:	177e                	slli	a4,a4,0x3f
    80001b9a:	8dd9                	or	a1,a1,a4
    80001b9c:	02000537          	lui	a0,0x2000
    80001ba0:	157d                	addi	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    80001ba2:	0536                	slli	a0,a0,0xd
    80001ba4:	9782                	jalr	a5
}
    80001ba6:	60a2                	ld	ra,8(sp)
    80001ba8:	6402                	ld	s0,0(sp)
    80001baa:	0141                	addi	sp,sp,16
    80001bac:	8082                	ret

0000000080001bae <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001bae:	1101                	addi	sp,sp,-32
    80001bb0:	ec06                	sd	ra,24(sp)
    80001bb2:	e822                	sd	s0,16(sp)
    80001bb4:	e426                	sd	s1,8(sp)
    80001bb6:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001bb8:	0000e497          	auipc	s1,0xe
    80001bbc:	8c848493          	addi	s1,s1,-1848 # 8000f480 <tickslock>
    80001bc0:	8526                	mv	a0,s1
    80001bc2:	00004097          	auipc	ra,0x4
    80001bc6:	700080e7          	jalr	1792(ra) # 800062c2 <acquire>
  ticks++;
    80001bca:	00007517          	auipc	a0,0x7
    80001bce:	44e50513          	addi	a0,a0,1102 # 80009018 <ticks>
    80001bd2:	411c                	lw	a5,0(a0)
    80001bd4:	2785                	addiw	a5,a5,1
    80001bd6:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001bd8:	00000097          	auipc	ra,0x0
    80001bdc:	b16080e7          	jalr	-1258(ra) # 800016ee <wakeup>
  release(&tickslock);
    80001be0:	8526                	mv	a0,s1
    80001be2:	00004097          	auipc	ra,0x4
    80001be6:	790080e7          	jalr	1936(ra) # 80006372 <release>
}
    80001bea:	60e2                	ld	ra,24(sp)
    80001bec:	6442                	ld	s0,16(sp)
    80001bee:	64a2                	ld	s1,8(sp)
    80001bf0:	6105                	addi	sp,sp,32
    80001bf2:	8082                	ret

0000000080001bf4 <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001bf4:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001bf8:	4501                	li	a0,0
  if((scause & 0x8000000000000000L) &&
    80001bfa:	0a07d163          	bgez	a5,80001c9c <devintr+0xa8>
{
    80001bfe:	1101                	addi	sp,sp,-32
    80001c00:	ec06                	sd	ra,24(sp)
    80001c02:	e822                	sd	s0,16(sp)
    80001c04:	1000                	addi	s0,sp,32
     (scause & 0xff) == 9){
    80001c06:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    80001c0a:	46a5                	li	a3,9
    80001c0c:	00d70c63          	beq	a4,a3,80001c24 <devintr+0x30>
  } else if(scause == 0x8000000000000001L){
    80001c10:	577d                	li	a4,-1
    80001c12:	177e                	slli	a4,a4,0x3f
    80001c14:	0705                	addi	a4,a4,1
    return 0;
    80001c16:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001c18:	06e78163          	beq	a5,a4,80001c7a <devintr+0x86>
  }
}
    80001c1c:	60e2                	ld	ra,24(sp)
    80001c1e:	6442                	ld	s0,16(sp)
    80001c20:	6105                	addi	sp,sp,32
    80001c22:	8082                	ret
    80001c24:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80001c26:	00003097          	auipc	ra,0x3
    80001c2a:	5f6080e7          	jalr	1526(ra) # 8000521c <plic_claim>
    80001c2e:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001c30:	47a9                	li	a5,10
    80001c32:	00f50963          	beq	a0,a5,80001c44 <devintr+0x50>
    } else if(irq == VIRTIO0_IRQ){
    80001c36:	4785                	li	a5,1
    80001c38:	00f50b63          	beq	a0,a5,80001c4e <devintr+0x5a>
    return 1;
    80001c3c:	4505                	li	a0,1
    } else if(irq){
    80001c3e:	ec89                	bnez	s1,80001c58 <devintr+0x64>
    80001c40:	64a2                	ld	s1,8(sp)
    80001c42:	bfe9                	j	80001c1c <devintr+0x28>
      uartintr();
    80001c44:	00004097          	auipc	ra,0x4
    80001c48:	59a080e7          	jalr	1434(ra) # 800061de <uartintr>
    if(irq)
    80001c4c:	a839                	j	80001c6a <devintr+0x76>
      virtio_disk_intr();
    80001c4e:	00004097          	auipc	ra,0x4
    80001c52:	a88080e7          	jalr	-1400(ra) # 800056d6 <virtio_disk_intr>
    if(irq)
    80001c56:	a811                	j	80001c6a <devintr+0x76>
      printf("unexpected interrupt irq=%d\n", irq);
    80001c58:	85a6                	mv	a1,s1
    80001c5a:	00006517          	auipc	a0,0x6
    80001c5e:	5ee50513          	addi	a0,a0,1518 # 80008248 <etext+0x248>
    80001c62:	00004097          	auipc	ra,0x4
    80001c66:	15c080e7          	jalr	348(ra) # 80005dbe <printf>
      plic_complete(irq);
    80001c6a:	8526                	mv	a0,s1
    80001c6c:	00003097          	auipc	ra,0x3
    80001c70:	5d4080e7          	jalr	1492(ra) # 80005240 <plic_complete>
    return 1;
    80001c74:	4505                	li	a0,1
    80001c76:	64a2                	ld	s1,8(sp)
    80001c78:	b755                	j	80001c1c <devintr+0x28>
    if(cpuid() == 0){
    80001c7a:	fffff097          	auipc	ra,0xfffff
    80001c7e:	1e8080e7          	jalr	488(ra) # 80000e62 <cpuid>
    80001c82:	c901                	beqz	a0,80001c92 <devintr+0x9e>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001c84:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001c88:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001c8a:	14479073          	csrw	sip,a5
    return 2;
    80001c8e:	4509                	li	a0,2
    80001c90:	b771                	j	80001c1c <devintr+0x28>
      clockintr();
    80001c92:	00000097          	auipc	ra,0x0
    80001c96:	f1c080e7          	jalr	-228(ra) # 80001bae <clockintr>
    80001c9a:	b7ed                	j	80001c84 <devintr+0x90>
}
    80001c9c:	8082                	ret

0000000080001c9e <usertrap>:
{
    80001c9e:	1101                	addi	sp,sp,-32
    80001ca0:	ec06                	sd	ra,24(sp)
    80001ca2:	e822                	sd	s0,16(sp)
    80001ca4:	e426                	sd	s1,8(sp)
    80001ca6:	e04a                	sd	s2,0(sp)
    80001ca8:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001caa:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001cae:	1007f793          	andi	a5,a5,256
    80001cb2:	e3ad                	bnez	a5,80001d14 <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001cb4:	00003797          	auipc	a5,0x3
    80001cb8:	45c78793          	addi	a5,a5,1116 # 80005110 <kernelvec>
    80001cbc:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001cc0:	fffff097          	auipc	ra,0xfffff
    80001cc4:	1d6080e7          	jalr	470(ra) # 80000e96 <myproc>
    80001cc8:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001cca:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ccc:	14102773          	csrr	a4,sepc
    80001cd0:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001cd2:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001cd6:	47a1                	li	a5,8
    80001cd8:	04f71c63          	bne	a4,a5,80001d30 <usertrap+0x92>
    if(p->killed)
    80001cdc:	551c                	lw	a5,40(a0)
    80001cde:	e3b9                	bnez	a5,80001d24 <usertrap+0x86>
    p->trapframe->epc += 4;
    80001ce0:	6cb8                	ld	a4,88(s1)
    80001ce2:	6f1c                	ld	a5,24(a4)
    80001ce4:	0791                	addi	a5,a5,4
    80001ce6:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ce8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001cec:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001cf0:	10079073          	csrw	sstatus,a5
    syscall();
    80001cf4:	00000097          	auipc	ra,0x0
    80001cf8:	2e0080e7          	jalr	736(ra) # 80001fd4 <syscall>
  if(p->killed)
    80001cfc:	549c                	lw	a5,40(s1)
    80001cfe:	ebc1                	bnez	a5,80001d8e <usertrap+0xf0>
  usertrapret();
    80001d00:	00000097          	auipc	ra,0x0
    80001d04:	e10080e7          	jalr	-496(ra) # 80001b10 <usertrapret>
}
    80001d08:	60e2                	ld	ra,24(sp)
    80001d0a:	6442                	ld	s0,16(sp)
    80001d0c:	64a2                	ld	s1,8(sp)
    80001d0e:	6902                	ld	s2,0(sp)
    80001d10:	6105                	addi	sp,sp,32
    80001d12:	8082                	ret
    panic("usertrap: not from user mode");
    80001d14:	00006517          	auipc	a0,0x6
    80001d18:	55450513          	addi	a0,a0,1364 # 80008268 <etext+0x268>
    80001d1c:	00004097          	auipc	ra,0x4
    80001d20:	050080e7          	jalr	80(ra) # 80005d6c <panic>
      exit(-1);
    80001d24:	557d                	li	a0,-1
    80001d26:	00000097          	auipc	ra,0x0
    80001d2a:	a98080e7          	jalr	-1384(ra) # 800017be <exit>
    80001d2e:	bf4d                	j	80001ce0 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001d30:	00000097          	auipc	ra,0x0
    80001d34:	ec4080e7          	jalr	-316(ra) # 80001bf4 <devintr>
    80001d38:	892a                	mv	s2,a0
    80001d3a:	c501                	beqz	a0,80001d42 <usertrap+0xa4>
  if(p->killed)
    80001d3c:	549c                	lw	a5,40(s1)
    80001d3e:	c3a1                	beqz	a5,80001d7e <usertrap+0xe0>
    80001d40:	a815                	j	80001d74 <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d42:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001d46:	5890                	lw	a2,48(s1)
    80001d48:	00006517          	auipc	a0,0x6
    80001d4c:	54050513          	addi	a0,a0,1344 # 80008288 <etext+0x288>
    80001d50:	00004097          	auipc	ra,0x4
    80001d54:	06e080e7          	jalr	110(ra) # 80005dbe <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d58:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001d5c:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001d60:	00006517          	auipc	a0,0x6
    80001d64:	55850513          	addi	a0,a0,1368 # 800082b8 <etext+0x2b8>
    80001d68:	00004097          	auipc	ra,0x4
    80001d6c:	056080e7          	jalr	86(ra) # 80005dbe <printf>
    p->killed = 1;
    80001d70:	4785                	li	a5,1
    80001d72:	d49c                	sw	a5,40(s1)
    exit(-1);
    80001d74:	557d                	li	a0,-1
    80001d76:	00000097          	auipc	ra,0x0
    80001d7a:	a48080e7          	jalr	-1464(ra) # 800017be <exit>
  if(which_dev == 2)
    80001d7e:	4789                	li	a5,2
    80001d80:	f8f910e3          	bne	s2,a5,80001d00 <usertrap+0x62>
    yield();
    80001d84:	fffff097          	auipc	ra,0xfffff
    80001d88:	7a8080e7          	jalr	1960(ra) # 8000152c <yield>
    80001d8c:	bf95                	j	80001d00 <usertrap+0x62>
  int which_dev = 0;
    80001d8e:	4901                	li	s2,0
    80001d90:	b7d5                	j	80001d74 <usertrap+0xd6>

0000000080001d92 <kerneltrap>:
{
    80001d92:	7179                	addi	sp,sp,-48
    80001d94:	f406                	sd	ra,40(sp)
    80001d96:	f022                	sd	s0,32(sp)
    80001d98:	ec26                	sd	s1,24(sp)
    80001d9a:	e84a                	sd	s2,16(sp)
    80001d9c:	e44e                	sd	s3,8(sp)
    80001d9e:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001da0:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001da4:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001da8:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001dac:	1004f793          	andi	a5,s1,256
    80001db0:	cb85                	beqz	a5,80001de0 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001db2:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001db6:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001db8:	ef85                	bnez	a5,80001df0 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001dba:	00000097          	auipc	ra,0x0
    80001dbe:	e3a080e7          	jalr	-454(ra) # 80001bf4 <devintr>
    80001dc2:	cd1d                	beqz	a0,80001e00 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001dc4:	4789                	li	a5,2
    80001dc6:	06f50a63          	beq	a0,a5,80001e3a <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001dca:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001dce:	10049073          	csrw	sstatus,s1
}
    80001dd2:	70a2                	ld	ra,40(sp)
    80001dd4:	7402                	ld	s0,32(sp)
    80001dd6:	64e2                	ld	s1,24(sp)
    80001dd8:	6942                	ld	s2,16(sp)
    80001dda:	69a2                	ld	s3,8(sp)
    80001ddc:	6145                	addi	sp,sp,48
    80001dde:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001de0:	00006517          	auipc	a0,0x6
    80001de4:	4f850513          	addi	a0,a0,1272 # 800082d8 <etext+0x2d8>
    80001de8:	00004097          	auipc	ra,0x4
    80001dec:	f84080e7          	jalr	-124(ra) # 80005d6c <panic>
    panic("kerneltrap: interrupts enabled");
    80001df0:	00006517          	auipc	a0,0x6
    80001df4:	51050513          	addi	a0,a0,1296 # 80008300 <etext+0x300>
    80001df8:	00004097          	auipc	ra,0x4
    80001dfc:	f74080e7          	jalr	-140(ra) # 80005d6c <panic>
    printf("scause %p\n", scause);
    80001e00:	85ce                	mv	a1,s3
    80001e02:	00006517          	auipc	a0,0x6
    80001e06:	51e50513          	addi	a0,a0,1310 # 80008320 <etext+0x320>
    80001e0a:	00004097          	auipc	ra,0x4
    80001e0e:	fb4080e7          	jalr	-76(ra) # 80005dbe <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e12:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e16:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e1a:	00006517          	auipc	a0,0x6
    80001e1e:	51650513          	addi	a0,a0,1302 # 80008330 <etext+0x330>
    80001e22:	00004097          	auipc	ra,0x4
    80001e26:	f9c080e7          	jalr	-100(ra) # 80005dbe <printf>
    panic("kerneltrap");
    80001e2a:	00006517          	auipc	a0,0x6
    80001e2e:	51e50513          	addi	a0,a0,1310 # 80008348 <etext+0x348>
    80001e32:	00004097          	auipc	ra,0x4
    80001e36:	f3a080e7          	jalr	-198(ra) # 80005d6c <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e3a:	fffff097          	auipc	ra,0xfffff
    80001e3e:	05c080e7          	jalr	92(ra) # 80000e96 <myproc>
    80001e42:	d541                	beqz	a0,80001dca <kerneltrap+0x38>
    80001e44:	fffff097          	auipc	ra,0xfffff
    80001e48:	052080e7          	jalr	82(ra) # 80000e96 <myproc>
    80001e4c:	4d18                	lw	a4,24(a0)
    80001e4e:	4791                	li	a5,4
    80001e50:	f6f71de3          	bne	a4,a5,80001dca <kerneltrap+0x38>
    yield();
    80001e54:	fffff097          	auipc	ra,0xfffff
    80001e58:	6d8080e7          	jalr	1752(ra) # 8000152c <yield>
    80001e5c:	b7bd                	j	80001dca <kerneltrap+0x38>

0000000080001e5e <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001e5e:	1101                	addi	sp,sp,-32
    80001e60:	ec06                	sd	ra,24(sp)
    80001e62:	e822                	sd	s0,16(sp)
    80001e64:	e426                	sd	s1,8(sp)
    80001e66:	1000                	addi	s0,sp,32
    80001e68:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001e6a:	fffff097          	auipc	ra,0xfffff
    80001e6e:	02c080e7          	jalr	44(ra) # 80000e96 <myproc>
  switch (n) {
    80001e72:	4795                	li	a5,5
    80001e74:	0497e163          	bltu	a5,s1,80001eb6 <argraw+0x58>
    80001e78:	048a                	slli	s1,s1,0x2
    80001e7a:	00007717          	auipc	a4,0x7
    80001e7e:	8be70713          	addi	a4,a4,-1858 # 80008738 <states.0+0x30>
    80001e82:	94ba                	add	s1,s1,a4
    80001e84:	409c                	lw	a5,0(s1)
    80001e86:	97ba                	add	a5,a5,a4
    80001e88:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001e8a:	6d3c                	ld	a5,88(a0)
    80001e8c:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001e8e:	60e2                	ld	ra,24(sp)
    80001e90:	6442                	ld	s0,16(sp)
    80001e92:	64a2                	ld	s1,8(sp)
    80001e94:	6105                	addi	sp,sp,32
    80001e96:	8082                	ret
    return p->trapframe->a1;
    80001e98:	6d3c                	ld	a5,88(a0)
    80001e9a:	7fa8                	ld	a0,120(a5)
    80001e9c:	bfcd                	j	80001e8e <argraw+0x30>
    return p->trapframe->a2;
    80001e9e:	6d3c                	ld	a5,88(a0)
    80001ea0:	63c8                	ld	a0,128(a5)
    80001ea2:	b7f5                	j	80001e8e <argraw+0x30>
    return p->trapframe->a3;
    80001ea4:	6d3c                	ld	a5,88(a0)
    80001ea6:	67c8                	ld	a0,136(a5)
    80001ea8:	b7dd                	j	80001e8e <argraw+0x30>
    return p->trapframe->a4;
    80001eaa:	6d3c                	ld	a5,88(a0)
    80001eac:	6bc8                	ld	a0,144(a5)
    80001eae:	b7c5                	j	80001e8e <argraw+0x30>
    return p->trapframe->a5;
    80001eb0:	6d3c                	ld	a5,88(a0)
    80001eb2:	6fc8                	ld	a0,152(a5)
    80001eb4:	bfe9                	j	80001e8e <argraw+0x30>
  panic("argraw");
    80001eb6:	00006517          	auipc	a0,0x6
    80001eba:	4a250513          	addi	a0,a0,1186 # 80008358 <etext+0x358>
    80001ebe:	00004097          	auipc	ra,0x4
    80001ec2:	eae080e7          	jalr	-338(ra) # 80005d6c <panic>

0000000080001ec6 <fetchaddr>:
{
    80001ec6:	1101                	addi	sp,sp,-32
    80001ec8:	ec06                	sd	ra,24(sp)
    80001eca:	e822                	sd	s0,16(sp)
    80001ecc:	e426                	sd	s1,8(sp)
    80001ece:	e04a                	sd	s2,0(sp)
    80001ed0:	1000                	addi	s0,sp,32
    80001ed2:	84aa                	mv	s1,a0
    80001ed4:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001ed6:	fffff097          	auipc	ra,0xfffff
    80001eda:	fc0080e7          	jalr	-64(ra) # 80000e96 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80001ede:	653c                	ld	a5,72(a0)
    80001ee0:	02f4f863          	bgeu	s1,a5,80001f10 <fetchaddr+0x4a>
    80001ee4:	00848713          	addi	a4,s1,8
    80001ee8:	02e7e663          	bltu	a5,a4,80001f14 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001eec:	46a1                	li	a3,8
    80001eee:	8626                	mv	a2,s1
    80001ef0:	85ca                	mv	a1,s2
    80001ef2:	6928                	ld	a0,80(a0)
    80001ef4:	fffff097          	auipc	ra,0xfffff
    80001ef8:	ce6080e7          	jalr	-794(ra) # 80000bda <copyin>
    80001efc:	00a03533          	snez	a0,a0
    80001f00:	40a0053b          	negw	a0,a0
}
    80001f04:	60e2                	ld	ra,24(sp)
    80001f06:	6442                	ld	s0,16(sp)
    80001f08:	64a2                	ld	s1,8(sp)
    80001f0a:	6902                	ld	s2,0(sp)
    80001f0c:	6105                	addi	sp,sp,32
    80001f0e:	8082                	ret
    return -1;
    80001f10:	557d                	li	a0,-1
    80001f12:	bfcd                	j	80001f04 <fetchaddr+0x3e>
    80001f14:	557d                	li	a0,-1
    80001f16:	b7fd                	j	80001f04 <fetchaddr+0x3e>

0000000080001f18 <fetchstr>:
{
    80001f18:	7179                	addi	sp,sp,-48
    80001f1a:	f406                	sd	ra,40(sp)
    80001f1c:	f022                	sd	s0,32(sp)
    80001f1e:	ec26                	sd	s1,24(sp)
    80001f20:	e84a                	sd	s2,16(sp)
    80001f22:	e44e                	sd	s3,8(sp)
    80001f24:	1800                	addi	s0,sp,48
    80001f26:	892a                	mv	s2,a0
    80001f28:	84ae                	mv	s1,a1
    80001f2a:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001f2c:	fffff097          	auipc	ra,0xfffff
    80001f30:	f6a080e7          	jalr	-150(ra) # 80000e96 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80001f34:	86ce                	mv	a3,s3
    80001f36:	864a                	mv	a2,s2
    80001f38:	85a6                	mv	a1,s1
    80001f3a:	6928                	ld	a0,80(a0)
    80001f3c:	fffff097          	auipc	ra,0xfffff
    80001f40:	d2c080e7          	jalr	-724(ra) # 80000c68 <copyinstr>
  if(err < 0)
    80001f44:	00054763          	bltz	a0,80001f52 <fetchstr+0x3a>
  return strlen(buf);
    80001f48:	8526                	mv	a0,s1
    80001f4a:	ffffe097          	auipc	ra,0xffffe
    80001f4e:	3bc080e7          	jalr	956(ra) # 80000306 <strlen>
}
    80001f52:	70a2                	ld	ra,40(sp)
    80001f54:	7402                	ld	s0,32(sp)
    80001f56:	64e2                	ld	s1,24(sp)
    80001f58:	6942                	ld	s2,16(sp)
    80001f5a:	69a2                	ld	s3,8(sp)
    80001f5c:	6145                	addi	sp,sp,48
    80001f5e:	8082                	ret

0000000080001f60 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80001f60:	1101                	addi	sp,sp,-32
    80001f62:	ec06                	sd	ra,24(sp)
    80001f64:	e822                	sd	s0,16(sp)
    80001f66:	e426                	sd	s1,8(sp)
    80001f68:	1000                	addi	s0,sp,32
    80001f6a:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001f6c:	00000097          	auipc	ra,0x0
    80001f70:	ef2080e7          	jalr	-270(ra) # 80001e5e <argraw>
    80001f74:	c088                	sw	a0,0(s1)
  return 0;
}
    80001f76:	4501                	li	a0,0
    80001f78:	60e2                	ld	ra,24(sp)
    80001f7a:	6442                	ld	s0,16(sp)
    80001f7c:	64a2                	ld	s1,8(sp)
    80001f7e:	6105                	addi	sp,sp,32
    80001f80:	8082                	ret

0000000080001f82 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80001f82:	1101                	addi	sp,sp,-32
    80001f84:	ec06                	sd	ra,24(sp)
    80001f86:	e822                	sd	s0,16(sp)
    80001f88:	e426                	sd	s1,8(sp)
    80001f8a:	1000                	addi	s0,sp,32
    80001f8c:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001f8e:	00000097          	auipc	ra,0x0
    80001f92:	ed0080e7          	jalr	-304(ra) # 80001e5e <argraw>
    80001f96:	e088                	sd	a0,0(s1)
  return 0;
}
    80001f98:	4501                	li	a0,0
    80001f9a:	60e2                	ld	ra,24(sp)
    80001f9c:	6442                	ld	s0,16(sp)
    80001f9e:	64a2                	ld	s1,8(sp)
    80001fa0:	6105                	addi	sp,sp,32
    80001fa2:	8082                	ret

0000000080001fa4 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001fa4:	1101                	addi	sp,sp,-32
    80001fa6:	ec06                	sd	ra,24(sp)
    80001fa8:	e822                	sd	s0,16(sp)
    80001faa:	e426                	sd	s1,8(sp)
    80001fac:	e04a                	sd	s2,0(sp)
    80001fae:	1000                	addi	s0,sp,32
    80001fb0:	84ae                	mv	s1,a1
    80001fb2:	8932                	mv	s2,a2
  *ip = argraw(n);
    80001fb4:	00000097          	auipc	ra,0x0
    80001fb8:	eaa080e7          	jalr	-342(ra) # 80001e5e <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80001fbc:	864a                	mv	a2,s2
    80001fbe:	85a6                	mv	a1,s1
    80001fc0:	00000097          	auipc	ra,0x0
    80001fc4:	f58080e7          	jalr	-168(ra) # 80001f18 <fetchstr>
}
    80001fc8:	60e2                	ld	ra,24(sp)
    80001fca:	6442                	ld	s0,16(sp)
    80001fcc:	64a2                	ld	s1,8(sp)
    80001fce:	6902                	ld	s2,0(sp)
    80001fd0:	6105                	addi	sp,sp,32
    80001fd2:	8082                	ret

0000000080001fd4 <syscall>:
[SYS_sigreturn]   sys_sigreturn,
};

void
syscall(void)
{
    80001fd4:	1101                	addi	sp,sp,-32
    80001fd6:	ec06                	sd	ra,24(sp)
    80001fd8:	e822                	sd	s0,16(sp)
    80001fda:	e426                	sd	s1,8(sp)
    80001fdc:	e04a                	sd	s2,0(sp)
    80001fde:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80001fe0:	fffff097          	auipc	ra,0xfffff
    80001fe4:	eb6080e7          	jalr	-330(ra) # 80000e96 <myproc>
    80001fe8:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80001fea:	05853903          	ld	s2,88(a0)
    80001fee:	0a893783          	ld	a5,168(s2)
    80001ff2:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80001ff6:	37fd                	addiw	a5,a5,-1
    80001ff8:	4759                	li	a4,22
    80001ffa:	00f76f63          	bltu	a4,a5,80002018 <syscall+0x44>
    80001ffe:	00369713          	slli	a4,a3,0x3
    80002002:	00006797          	auipc	a5,0x6
    80002006:	74e78793          	addi	a5,a5,1870 # 80008750 <syscalls>
    8000200a:	97ba                	add	a5,a5,a4
    8000200c:	639c                	ld	a5,0(a5)
    8000200e:	c789                	beqz	a5,80002018 <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    80002010:	9782                	jalr	a5
    80002012:	06a93823          	sd	a0,112(s2)
    80002016:	a839                	j	80002034 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002018:	15848613          	addi	a2,s1,344
    8000201c:	588c                	lw	a1,48(s1)
    8000201e:	00006517          	auipc	a0,0x6
    80002022:	34250513          	addi	a0,a0,834 # 80008360 <etext+0x360>
    80002026:	00004097          	auipc	ra,0x4
    8000202a:	d98080e7          	jalr	-616(ra) # 80005dbe <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    8000202e:	6cbc                	ld	a5,88(s1)
    80002030:	577d                	li	a4,-1
    80002032:	fbb8                	sd	a4,112(a5)
  }
}
    80002034:	60e2                	ld	ra,24(sp)
    80002036:	6442                	ld	s0,16(sp)
    80002038:	64a2                	ld	s1,8(sp)
    8000203a:	6902                	ld	s2,0(sp)
    8000203c:	6105                	addi	sp,sp,32
    8000203e:	8082                	ret

0000000080002040 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002040:	1101                	addi	sp,sp,-32
    80002042:	ec06                	sd	ra,24(sp)
    80002044:	e822                	sd	s0,16(sp)
    80002046:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80002048:	fec40593          	addi	a1,s0,-20
    8000204c:	4501                	li	a0,0
    8000204e:	00000097          	auipc	ra,0x0
    80002052:	f12080e7          	jalr	-238(ra) # 80001f60 <argint>
    return -1;
    80002056:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002058:	00054963          	bltz	a0,8000206a <sys_exit+0x2a>
  exit(n);
    8000205c:	fec42503          	lw	a0,-20(s0)
    80002060:	fffff097          	auipc	ra,0xfffff
    80002064:	75e080e7          	jalr	1886(ra) # 800017be <exit>
  return 0;  // not reached
    80002068:	4781                	li	a5,0
}
    8000206a:	853e                	mv	a0,a5
    8000206c:	60e2                	ld	ra,24(sp)
    8000206e:	6442                	ld	s0,16(sp)
    80002070:	6105                	addi	sp,sp,32
    80002072:	8082                	ret

0000000080002074 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002074:	1141                	addi	sp,sp,-16
    80002076:	e406                	sd	ra,8(sp)
    80002078:	e022                	sd	s0,0(sp)
    8000207a:	0800                	addi	s0,sp,16
  return myproc()->pid;
    8000207c:	fffff097          	auipc	ra,0xfffff
    80002080:	e1a080e7          	jalr	-486(ra) # 80000e96 <myproc>
}
    80002084:	5908                	lw	a0,48(a0)
    80002086:	60a2                	ld	ra,8(sp)
    80002088:	6402                	ld	s0,0(sp)
    8000208a:	0141                	addi	sp,sp,16
    8000208c:	8082                	ret

000000008000208e <sys_fork>:

uint64
sys_fork(void)
{
    8000208e:	1141                	addi	sp,sp,-16
    80002090:	e406                	sd	ra,8(sp)
    80002092:	e022                	sd	s0,0(sp)
    80002094:	0800                	addi	s0,sp,16
  return fork();
    80002096:	fffff097          	auipc	ra,0xfffff
    8000209a:	1de080e7          	jalr	478(ra) # 80001274 <fork>
}
    8000209e:	60a2                	ld	ra,8(sp)
    800020a0:	6402                	ld	s0,0(sp)
    800020a2:	0141                	addi	sp,sp,16
    800020a4:	8082                	ret

00000000800020a6 <sys_wait>:

uint64
sys_wait(void)
{
    800020a6:	1101                	addi	sp,sp,-32
    800020a8:	ec06                	sd	ra,24(sp)
    800020aa:	e822                	sd	s0,16(sp)
    800020ac:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    800020ae:	fe840593          	addi	a1,s0,-24
    800020b2:	4501                	li	a0,0
    800020b4:	00000097          	auipc	ra,0x0
    800020b8:	ece080e7          	jalr	-306(ra) # 80001f82 <argaddr>
    800020bc:	87aa                	mv	a5,a0
    return -1;
    800020be:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    800020c0:	0007c863          	bltz	a5,800020d0 <sys_wait+0x2a>
  return wait(p);
    800020c4:	fe843503          	ld	a0,-24(s0)
    800020c8:	fffff097          	auipc	ra,0xfffff
    800020cc:	504080e7          	jalr	1284(ra) # 800015cc <wait>
}
    800020d0:	60e2                	ld	ra,24(sp)
    800020d2:	6442                	ld	s0,16(sp)
    800020d4:	6105                	addi	sp,sp,32
    800020d6:	8082                	ret

00000000800020d8 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800020d8:	7179                	addi	sp,sp,-48
    800020da:	f406                	sd	ra,40(sp)
    800020dc:	f022                	sd	s0,32(sp)
    800020de:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    800020e0:	fdc40593          	addi	a1,s0,-36
    800020e4:	4501                	li	a0,0
    800020e6:	00000097          	auipc	ra,0x0
    800020ea:	e7a080e7          	jalr	-390(ra) # 80001f60 <argint>
    800020ee:	87aa                	mv	a5,a0
    return -1;
    800020f0:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    800020f2:	0207c263          	bltz	a5,80002116 <sys_sbrk+0x3e>
    800020f6:	ec26                	sd	s1,24(sp)
  addr = myproc()->sz;
    800020f8:	fffff097          	auipc	ra,0xfffff
    800020fc:	d9e080e7          	jalr	-610(ra) # 80000e96 <myproc>
    80002100:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    80002102:	fdc42503          	lw	a0,-36(s0)
    80002106:	fffff097          	auipc	ra,0xfffff
    8000210a:	0f6080e7          	jalr	246(ra) # 800011fc <growproc>
    8000210e:	00054863          	bltz	a0,8000211e <sys_sbrk+0x46>
    return -1;
  return addr;
    80002112:	8526                	mv	a0,s1
    80002114:	64e2                	ld	s1,24(sp)
}
    80002116:	70a2                	ld	ra,40(sp)
    80002118:	7402                	ld	s0,32(sp)
    8000211a:	6145                	addi	sp,sp,48
    8000211c:	8082                	ret
    return -1;
    8000211e:	557d                	li	a0,-1
    80002120:	64e2                	ld	s1,24(sp)
    80002122:	bfd5                	j	80002116 <sys_sbrk+0x3e>

0000000080002124 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002124:	7139                	addi	sp,sp,-64
    80002126:	fc06                	sd	ra,56(sp)
    80002128:	f822                	sd	s0,48(sp)
    8000212a:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    8000212c:	fcc40593          	addi	a1,s0,-52
    80002130:	4501                	li	a0,0
    80002132:	00000097          	auipc	ra,0x0
    80002136:	e2e080e7          	jalr	-466(ra) # 80001f60 <argint>
    return -1;
    8000213a:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    8000213c:	06054f63          	bltz	a0,800021ba <sys_sleep+0x96>
    80002140:	f04a                	sd	s2,32(sp)
  acquire(&tickslock);
    80002142:	0000d517          	auipc	a0,0xd
    80002146:	33e50513          	addi	a0,a0,830 # 8000f480 <tickslock>
    8000214a:	00004097          	auipc	ra,0x4
    8000214e:	178080e7          	jalr	376(ra) # 800062c2 <acquire>
  ticks0 = ticks;
    80002152:	00007917          	auipc	s2,0x7
    80002156:	ec692903          	lw	s2,-314(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    8000215a:	fcc42783          	lw	a5,-52(s0)
    8000215e:	c3a1                	beqz	a5,8000219e <sys_sleep+0x7a>
    80002160:	f426                	sd	s1,40(sp)
    80002162:	ec4e                	sd	s3,24(sp)
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002164:	0000d997          	auipc	s3,0xd
    80002168:	31c98993          	addi	s3,s3,796 # 8000f480 <tickslock>
    8000216c:	00007497          	auipc	s1,0x7
    80002170:	eac48493          	addi	s1,s1,-340 # 80009018 <ticks>
    if(myproc()->killed){
    80002174:	fffff097          	auipc	ra,0xfffff
    80002178:	d22080e7          	jalr	-734(ra) # 80000e96 <myproc>
    8000217c:	551c                	lw	a5,40(a0)
    8000217e:	e3b9                	bnez	a5,800021c4 <sys_sleep+0xa0>
    sleep(&ticks, &tickslock);
    80002180:	85ce                	mv	a1,s3
    80002182:	8526                	mv	a0,s1
    80002184:	fffff097          	auipc	ra,0xfffff
    80002188:	3e4080e7          	jalr	996(ra) # 80001568 <sleep>
  while(ticks - ticks0 < n){
    8000218c:	409c                	lw	a5,0(s1)
    8000218e:	412787bb          	subw	a5,a5,s2
    80002192:	fcc42703          	lw	a4,-52(s0)
    80002196:	fce7efe3          	bltu	a5,a4,80002174 <sys_sleep+0x50>
    8000219a:	74a2                	ld	s1,40(sp)
    8000219c:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    8000219e:	0000d517          	auipc	a0,0xd
    800021a2:	2e250513          	addi	a0,a0,738 # 8000f480 <tickslock>
    800021a6:	00004097          	auipc	ra,0x4
    800021aa:	1cc080e7          	jalr	460(ra) # 80006372 <release>
  backtrace();
    800021ae:	00004097          	auipc	ra,0x4
    800021b2:	b66080e7          	jalr	-1178(ra) # 80005d14 <backtrace>
  return 0;
    800021b6:	4781                	li	a5,0
    800021b8:	7902                	ld	s2,32(sp)
}
    800021ba:	853e                	mv	a0,a5
    800021bc:	70e2                	ld	ra,56(sp)
    800021be:	7442                	ld	s0,48(sp)
    800021c0:	6121                	addi	sp,sp,64
    800021c2:	8082                	ret
      release(&tickslock);
    800021c4:	0000d517          	auipc	a0,0xd
    800021c8:	2bc50513          	addi	a0,a0,700 # 8000f480 <tickslock>
    800021cc:	00004097          	auipc	ra,0x4
    800021d0:	1a6080e7          	jalr	422(ra) # 80006372 <release>
      return -1;
    800021d4:	57fd                	li	a5,-1
    800021d6:	74a2                	ld	s1,40(sp)
    800021d8:	7902                	ld	s2,32(sp)
    800021da:	69e2                	ld	s3,24(sp)
    800021dc:	bff9                	j	800021ba <sys_sleep+0x96>

00000000800021de <sys_kill>:

uint64
sys_kill(void)
{
    800021de:	1101                	addi	sp,sp,-32
    800021e0:	ec06                	sd	ra,24(sp)
    800021e2:	e822                	sd	s0,16(sp)
    800021e4:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    800021e6:	fec40593          	addi	a1,s0,-20
    800021ea:	4501                	li	a0,0
    800021ec:	00000097          	auipc	ra,0x0
    800021f0:	d74080e7          	jalr	-652(ra) # 80001f60 <argint>
    800021f4:	87aa                	mv	a5,a0
    return -1;
    800021f6:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    800021f8:	0007c863          	bltz	a5,80002208 <sys_kill+0x2a>
  return kill(pid);
    800021fc:	fec42503          	lw	a0,-20(s0)
    80002200:	fffff097          	auipc	ra,0xfffff
    80002204:	694080e7          	jalr	1684(ra) # 80001894 <kill>
}
    80002208:	60e2                	ld	ra,24(sp)
    8000220a:	6442                	ld	s0,16(sp)
    8000220c:	6105                	addi	sp,sp,32
    8000220e:	8082                	ret

0000000080002210 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002210:	1101                	addi	sp,sp,-32
    80002212:	ec06                	sd	ra,24(sp)
    80002214:	e822                	sd	s0,16(sp)
    80002216:	e426                	sd	s1,8(sp)
    80002218:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    8000221a:	0000d517          	auipc	a0,0xd
    8000221e:	26650513          	addi	a0,a0,614 # 8000f480 <tickslock>
    80002222:	00004097          	auipc	ra,0x4
    80002226:	0a0080e7          	jalr	160(ra) # 800062c2 <acquire>
  xticks = ticks;
    8000222a:	00007497          	auipc	s1,0x7
    8000222e:	dee4a483          	lw	s1,-530(s1) # 80009018 <ticks>
  release(&tickslock);
    80002232:	0000d517          	auipc	a0,0xd
    80002236:	24e50513          	addi	a0,a0,590 # 8000f480 <tickslock>
    8000223a:	00004097          	auipc	ra,0x4
    8000223e:	138080e7          	jalr	312(ra) # 80006372 <release>
  return xticks;
}
    80002242:	02049513          	slli	a0,s1,0x20
    80002246:	9101                	srli	a0,a0,0x20
    80002248:	60e2                	ld	ra,24(sp)
    8000224a:	6442                	ld	s0,16(sp)
    8000224c:	64a2                	ld	s1,8(sp)
    8000224e:	6105                	addi	sp,sp,32
    80002250:	8082                	ret

0000000080002252 <sys_sigalarm>:

uint64 sys_sigalarm() {
    80002252:	1101                	addi	sp,sp,-32
    80002254:	ec06                	sd	ra,24(sp)
    80002256:	e822                	sd	s0,16(sp)
    80002258:	1000                	addi	s0,sp,32
  int ticks;
  if(argint(0, &ticks) < 0)
    8000225a:	fec40593          	addi	a1,s0,-20
    8000225e:	4501                	li	a0,0
    80002260:	00000097          	auipc	ra,0x0
    80002264:	d00080e7          	jalr	-768(ra) # 80001f60 <argint>
    return -1;
    80002268:	57fd                	li	a5,-1
  if(argint(0, &ticks) < 0)
    8000226a:	02054a63          	bltz	a0,8000229e <sys_sigalarm+0x4c>
  myproc()->interval = ticks;
    8000226e:	fffff097          	auipc	ra,0xfffff
    80002272:	c28080e7          	jalr	-984(ra) # 80000e96 <myproc>
    80002276:	fec42783          	lw	a5,-20(s0)
    8000227a:	16f52423          	sw	a5,360(a0)
  void * handler = 0;
  if(argaddr(1, handler) < 0) {
    8000227e:	4581                	li	a1,0
    80002280:	4505                	li	a0,1
    80002282:	00000097          	auipc	ra,0x0
    80002286:	d00080e7          	jalr	-768(ra) # 80001f82 <argaddr>
    return -1;
    8000228a:	57fd                	li	a5,-1
  if(argaddr(1, handler) < 0) {
    8000228c:	00054963          	bltz	a0,8000229e <sys_sigalarm+0x4c>
  }
  myproc()->handler = handler;
    80002290:	fffff097          	auipc	ra,0xfffff
    80002294:	c06080e7          	jalr	-1018(ra) # 80000e96 <myproc>
    80002298:	16053823          	sd	zero,368(a0)
  return 0;
    8000229c:	4781                	li	a5,0
}
    8000229e:	853e                	mv	a0,a5
    800022a0:	60e2                	ld	ra,24(sp)
    800022a2:	6442                	ld	s0,16(sp)
    800022a4:	6105                	addi	sp,sp,32
    800022a6:	8082                	ret

00000000800022a8 <sys_sigreturn>:

uint64 sys_sigreturn(void) {
    800022a8:	1141                	addi	sp,sp,-16
    800022aa:	e406                	sd	ra,8(sp)
    800022ac:	e022                	sd	s0,0(sp)
    800022ae:	0800                	addi	s0,sp,16
  return 0;
}
    800022b0:	4501                	li	a0,0
    800022b2:	60a2                	ld	ra,8(sp)
    800022b4:	6402                	ld	s0,0(sp)
    800022b6:	0141                	addi	sp,sp,16
    800022b8:	8082                	ret

00000000800022ba <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800022ba:	7179                	addi	sp,sp,-48
    800022bc:	f406                	sd	ra,40(sp)
    800022be:	f022                	sd	s0,32(sp)
    800022c0:	ec26                	sd	s1,24(sp)
    800022c2:	e84a                	sd	s2,16(sp)
    800022c4:	e44e                	sd	s3,8(sp)
    800022c6:	e052                	sd	s4,0(sp)
    800022c8:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800022ca:	00006597          	auipc	a1,0x6
    800022ce:	0b658593          	addi	a1,a1,182 # 80008380 <etext+0x380>
    800022d2:	0000d517          	auipc	a0,0xd
    800022d6:	1c650513          	addi	a0,a0,454 # 8000f498 <bcache>
    800022da:	00004097          	auipc	ra,0x4
    800022de:	f54080e7          	jalr	-172(ra) # 8000622e <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800022e2:	00015797          	auipc	a5,0x15
    800022e6:	1b678793          	addi	a5,a5,438 # 80017498 <bcache+0x8000>
    800022ea:	00015717          	auipc	a4,0x15
    800022ee:	41670713          	addi	a4,a4,1046 # 80017700 <bcache+0x8268>
    800022f2:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800022f6:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800022fa:	0000d497          	auipc	s1,0xd
    800022fe:	1b648493          	addi	s1,s1,438 # 8000f4b0 <bcache+0x18>
    b->next = bcache.head.next;
    80002302:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002304:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002306:	00006a17          	auipc	s4,0x6
    8000230a:	082a0a13          	addi	s4,s4,130 # 80008388 <etext+0x388>
    b->next = bcache.head.next;
    8000230e:	2b893783          	ld	a5,696(s2)
    80002312:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002314:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002318:	85d2                	mv	a1,s4
    8000231a:	01048513          	addi	a0,s1,16
    8000231e:	00001097          	auipc	ra,0x1
    80002322:	4ba080e7          	jalr	1210(ra) # 800037d8 <initsleeplock>
    bcache.head.next->prev = b;
    80002326:	2b893783          	ld	a5,696(s2)
    8000232a:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    8000232c:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002330:	45848493          	addi	s1,s1,1112
    80002334:	fd349de3          	bne	s1,s3,8000230e <binit+0x54>
  }
}
    80002338:	70a2                	ld	ra,40(sp)
    8000233a:	7402                	ld	s0,32(sp)
    8000233c:	64e2                	ld	s1,24(sp)
    8000233e:	6942                	ld	s2,16(sp)
    80002340:	69a2                	ld	s3,8(sp)
    80002342:	6a02                	ld	s4,0(sp)
    80002344:	6145                	addi	sp,sp,48
    80002346:	8082                	ret

0000000080002348 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002348:	7179                	addi	sp,sp,-48
    8000234a:	f406                	sd	ra,40(sp)
    8000234c:	f022                	sd	s0,32(sp)
    8000234e:	ec26                	sd	s1,24(sp)
    80002350:	e84a                	sd	s2,16(sp)
    80002352:	e44e                	sd	s3,8(sp)
    80002354:	1800                	addi	s0,sp,48
    80002356:	892a                	mv	s2,a0
    80002358:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    8000235a:	0000d517          	auipc	a0,0xd
    8000235e:	13e50513          	addi	a0,a0,318 # 8000f498 <bcache>
    80002362:	00004097          	auipc	ra,0x4
    80002366:	f60080e7          	jalr	-160(ra) # 800062c2 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000236a:	00015497          	auipc	s1,0x15
    8000236e:	3e64b483          	ld	s1,998(s1) # 80017750 <bcache+0x82b8>
    80002372:	00015797          	auipc	a5,0x15
    80002376:	38e78793          	addi	a5,a5,910 # 80017700 <bcache+0x8268>
    8000237a:	02f48f63          	beq	s1,a5,800023b8 <bread+0x70>
    8000237e:	873e                	mv	a4,a5
    80002380:	a021                	j	80002388 <bread+0x40>
    80002382:	68a4                	ld	s1,80(s1)
    80002384:	02e48a63          	beq	s1,a4,800023b8 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002388:	449c                	lw	a5,8(s1)
    8000238a:	ff279ce3          	bne	a5,s2,80002382 <bread+0x3a>
    8000238e:	44dc                	lw	a5,12(s1)
    80002390:	ff3799e3          	bne	a5,s3,80002382 <bread+0x3a>
      b->refcnt++;
    80002394:	40bc                	lw	a5,64(s1)
    80002396:	2785                	addiw	a5,a5,1
    80002398:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000239a:	0000d517          	auipc	a0,0xd
    8000239e:	0fe50513          	addi	a0,a0,254 # 8000f498 <bcache>
    800023a2:	00004097          	auipc	ra,0x4
    800023a6:	fd0080e7          	jalr	-48(ra) # 80006372 <release>
      acquiresleep(&b->lock);
    800023aa:	01048513          	addi	a0,s1,16
    800023ae:	00001097          	auipc	ra,0x1
    800023b2:	464080e7          	jalr	1124(ra) # 80003812 <acquiresleep>
      return b;
    800023b6:	a8b9                	j	80002414 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800023b8:	00015497          	auipc	s1,0x15
    800023bc:	3904b483          	ld	s1,912(s1) # 80017748 <bcache+0x82b0>
    800023c0:	00015797          	auipc	a5,0x15
    800023c4:	34078793          	addi	a5,a5,832 # 80017700 <bcache+0x8268>
    800023c8:	00f48863          	beq	s1,a5,800023d8 <bread+0x90>
    800023cc:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800023ce:	40bc                	lw	a5,64(s1)
    800023d0:	cf81                	beqz	a5,800023e8 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800023d2:	64a4                	ld	s1,72(s1)
    800023d4:	fee49de3          	bne	s1,a4,800023ce <bread+0x86>
  panic("bget: no buffers");
    800023d8:	00006517          	auipc	a0,0x6
    800023dc:	fb850513          	addi	a0,a0,-72 # 80008390 <etext+0x390>
    800023e0:	00004097          	auipc	ra,0x4
    800023e4:	98c080e7          	jalr	-1652(ra) # 80005d6c <panic>
      b->dev = dev;
    800023e8:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800023ec:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800023f0:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800023f4:	4785                	li	a5,1
    800023f6:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800023f8:	0000d517          	auipc	a0,0xd
    800023fc:	0a050513          	addi	a0,a0,160 # 8000f498 <bcache>
    80002400:	00004097          	auipc	ra,0x4
    80002404:	f72080e7          	jalr	-142(ra) # 80006372 <release>
      acquiresleep(&b->lock);
    80002408:	01048513          	addi	a0,s1,16
    8000240c:	00001097          	auipc	ra,0x1
    80002410:	406080e7          	jalr	1030(ra) # 80003812 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002414:	409c                	lw	a5,0(s1)
    80002416:	cb89                	beqz	a5,80002428 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002418:	8526                	mv	a0,s1
    8000241a:	70a2                	ld	ra,40(sp)
    8000241c:	7402                	ld	s0,32(sp)
    8000241e:	64e2                	ld	s1,24(sp)
    80002420:	6942                	ld	s2,16(sp)
    80002422:	69a2                	ld	s3,8(sp)
    80002424:	6145                	addi	sp,sp,48
    80002426:	8082                	ret
    virtio_disk_rw(b, 0);
    80002428:	4581                	li	a1,0
    8000242a:	8526                	mv	a0,s1
    8000242c:	00003097          	auipc	ra,0x3
    80002430:	022080e7          	jalr	34(ra) # 8000544e <virtio_disk_rw>
    b->valid = 1;
    80002434:	4785                	li	a5,1
    80002436:	c09c                	sw	a5,0(s1)
  return b;
    80002438:	b7c5                	j	80002418 <bread+0xd0>

000000008000243a <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    8000243a:	1101                	addi	sp,sp,-32
    8000243c:	ec06                	sd	ra,24(sp)
    8000243e:	e822                	sd	s0,16(sp)
    80002440:	e426                	sd	s1,8(sp)
    80002442:	1000                	addi	s0,sp,32
    80002444:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002446:	0541                	addi	a0,a0,16
    80002448:	00001097          	auipc	ra,0x1
    8000244c:	464080e7          	jalr	1124(ra) # 800038ac <holdingsleep>
    80002450:	cd01                	beqz	a0,80002468 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002452:	4585                	li	a1,1
    80002454:	8526                	mv	a0,s1
    80002456:	00003097          	auipc	ra,0x3
    8000245a:	ff8080e7          	jalr	-8(ra) # 8000544e <virtio_disk_rw>
}
    8000245e:	60e2                	ld	ra,24(sp)
    80002460:	6442                	ld	s0,16(sp)
    80002462:	64a2                	ld	s1,8(sp)
    80002464:	6105                	addi	sp,sp,32
    80002466:	8082                	ret
    panic("bwrite");
    80002468:	00006517          	auipc	a0,0x6
    8000246c:	f4050513          	addi	a0,a0,-192 # 800083a8 <etext+0x3a8>
    80002470:	00004097          	auipc	ra,0x4
    80002474:	8fc080e7          	jalr	-1796(ra) # 80005d6c <panic>

0000000080002478 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002478:	1101                	addi	sp,sp,-32
    8000247a:	ec06                	sd	ra,24(sp)
    8000247c:	e822                	sd	s0,16(sp)
    8000247e:	e426                	sd	s1,8(sp)
    80002480:	e04a                	sd	s2,0(sp)
    80002482:	1000                	addi	s0,sp,32
    80002484:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002486:	01050913          	addi	s2,a0,16
    8000248a:	854a                	mv	a0,s2
    8000248c:	00001097          	auipc	ra,0x1
    80002490:	420080e7          	jalr	1056(ra) # 800038ac <holdingsleep>
    80002494:	c535                	beqz	a0,80002500 <brelse+0x88>
    panic("brelse");

  releasesleep(&b->lock);
    80002496:	854a                	mv	a0,s2
    80002498:	00001097          	auipc	ra,0x1
    8000249c:	3d0080e7          	jalr	976(ra) # 80003868 <releasesleep>

  acquire(&bcache.lock);
    800024a0:	0000d517          	auipc	a0,0xd
    800024a4:	ff850513          	addi	a0,a0,-8 # 8000f498 <bcache>
    800024a8:	00004097          	auipc	ra,0x4
    800024ac:	e1a080e7          	jalr	-486(ra) # 800062c2 <acquire>
  b->refcnt--;
    800024b0:	40bc                	lw	a5,64(s1)
    800024b2:	37fd                	addiw	a5,a5,-1
    800024b4:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800024b6:	e79d                	bnez	a5,800024e4 <brelse+0x6c>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800024b8:	68b8                	ld	a4,80(s1)
    800024ba:	64bc                	ld	a5,72(s1)
    800024bc:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    800024be:	68b8                	ld	a4,80(s1)
    800024c0:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800024c2:	00015797          	auipc	a5,0x15
    800024c6:	fd678793          	addi	a5,a5,-42 # 80017498 <bcache+0x8000>
    800024ca:	2b87b703          	ld	a4,696(a5)
    800024ce:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800024d0:	00015717          	auipc	a4,0x15
    800024d4:	23070713          	addi	a4,a4,560 # 80017700 <bcache+0x8268>
    800024d8:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800024da:	2b87b703          	ld	a4,696(a5)
    800024de:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800024e0:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800024e4:	0000d517          	auipc	a0,0xd
    800024e8:	fb450513          	addi	a0,a0,-76 # 8000f498 <bcache>
    800024ec:	00004097          	auipc	ra,0x4
    800024f0:	e86080e7          	jalr	-378(ra) # 80006372 <release>
}
    800024f4:	60e2                	ld	ra,24(sp)
    800024f6:	6442                	ld	s0,16(sp)
    800024f8:	64a2                	ld	s1,8(sp)
    800024fa:	6902                	ld	s2,0(sp)
    800024fc:	6105                	addi	sp,sp,32
    800024fe:	8082                	ret
    panic("brelse");
    80002500:	00006517          	auipc	a0,0x6
    80002504:	eb050513          	addi	a0,a0,-336 # 800083b0 <etext+0x3b0>
    80002508:	00004097          	auipc	ra,0x4
    8000250c:	864080e7          	jalr	-1948(ra) # 80005d6c <panic>

0000000080002510 <bpin>:

void
bpin(struct buf *b) {
    80002510:	1101                	addi	sp,sp,-32
    80002512:	ec06                	sd	ra,24(sp)
    80002514:	e822                	sd	s0,16(sp)
    80002516:	e426                	sd	s1,8(sp)
    80002518:	1000                	addi	s0,sp,32
    8000251a:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000251c:	0000d517          	auipc	a0,0xd
    80002520:	f7c50513          	addi	a0,a0,-132 # 8000f498 <bcache>
    80002524:	00004097          	auipc	ra,0x4
    80002528:	d9e080e7          	jalr	-610(ra) # 800062c2 <acquire>
  b->refcnt++;
    8000252c:	40bc                	lw	a5,64(s1)
    8000252e:	2785                	addiw	a5,a5,1
    80002530:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002532:	0000d517          	auipc	a0,0xd
    80002536:	f6650513          	addi	a0,a0,-154 # 8000f498 <bcache>
    8000253a:	00004097          	auipc	ra,0x4
    8000253e:	e38080e7          	jalr	-456(ra) # 80006372 <release>
}
    80002542:	60e2                	ld	ra,24(sp)
    80002544:	6442                	ld	s0,16(sp)
    80002546:	64a2                	ld	s1,8(sp)
    80002548:	6105                	addi	sp,sp,32
    8000254a:	8082                	ret

000000008000254c <bunpin>:

void
bunpin(struct buf *b) {
    8000254c:	1101                	addi	sp,sp,-32
    8000254e:	ec06                	sd	ra,24(sp)
    80002550:	e822                	sd	s0,16(sp)
    80002552:	e426                	sd	s1,8(sp)
    80002554:	1000                	addi	s0,sp,32
    80002556:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002558:	0000d517          	auipc	a0,0xd
    8000255c:	f4050513          	addi	a0,a0,-192 # 8000f498 <bcache>
    80002560:	00004097          	auipc	ra,0x4
    80002564:	d62080e7          	jalr	-670(ra) # 800062c2 <acquire>
  b->refcnt--;
    80002568:	40bc                	lw	a5,64(s1)
    8000256a:	37fd                	addiw	a5,a5,-1
    8000256c:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000256e:	0000d517          	auipc	a0,0xd
    80002572:	f2a50513          	addi	a0,a0,-214 # 8000f498 <bcache>
    80002576:	00004097          	auipc	ra,0x4
    8000257a:	dfc080e7          	jalr	-516(ra) # 80006372 <release>
}
    8000257e:	60e2                	ld	ra,24(sp)
    80002580:	6442                	ld	s0,16(sp)
    80002582:	64a2                	ld	s1,8(sp)
    80002584:	6105                	addi	sp,sp,32
    80002586:	8082                	ret

0000000080002588 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002588:	1101                	addi	sp,sp,-32
    8000258a:	ec06                	sd	ra,24(sp)
    8000258c:	e822                	sd	s0,16(sp)
    8000258e:	e426                	sd	s1,8(sp)
    80002590:	e04a                	sd	s2,0(sp)
    80002592:	1000                	addi	s0,sp,32
    80002594:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002596:	00d5d79b          	srliw	a5,a1,0xd
    8000259a:	00015597          	auipc	a1,0x15
    8000259e:	5da5a583          	lw	a1,1498(a1) # 80017b74 <sb+0x1c>
    800025a2:	9dbd                	addw	a1,a1,a5
    800025a4:	00000097          	auipc	ra,0x0
    800025a8:	da4080e7          	jalr	-604(ra) # 80002348 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800025ac:	0074f713          	andi	a4,s1,7
    800025b0:	4785                	li	a5,1
    800025b2:	00e797bb          	sllw	a5,a5,a4
  bi = b % BPB;
    800025b6:	14ce                	slli	s1,s1,0x33
  if((bp->data[bi/8] & m) == 0)
    800025b8:	90d9                	srli	s1,s1,0x36
    800025ba:	00950733          	add	a4,a0,s1
    800025be:	05874703          	lbu	a4,88(a4)
    800025c2:	00e7f6b3          	and	a3,a5,a4
    800025c6:	c69d                	beqz	a3,800025f4 <bfree+0x6c>
    800025c8:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800025ca:	94aa                	add	s1,s1,a0
    800025cc:	fff7c793          	not	a5,a5
    800025d0:	8f7d                	and	a4,a4,a5
    800025d2:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    800025d6:	00001097          	auipc	ra,0x1
    800025da:	11e080e7          	jalr	286(ra) # 800036f4 <log_write>
  brelse(bp);
    800025de:	854a                	mv	a0,s2
    800025e0:	00000097          	auipc	ra,0x0
    800025e4:	e98080e7          	jalr	-360(ra) # 80002478 <brelse>
}
    800025e8:	60e2                	ld	ra,24(sp)
    800025ea:	6442                	ld	s0,16(sp)
    800025ec:	64a2                	ld	s1,8(sp)
    800025ee:	6902                	ld	s2,0(sp)
    800025f0:	6105                	addi	sp,sp,32
    800025f2:	8082                	ret
    panic("freeing free block");
    800025f4:	00006517          	auipc	a0,0x6
    800025f8:	dc450513          	addi	a0,a0,-572 # 800083b8 <etext+0x3b8>
    800025fc:	00003097          	auipc	ra,0x3
    80002600:	770080e7          	jalr	1904(ra) # 80005d6c <panic>

0000000080002604 <balloc>:
{
    80002604:	715d                	addi	sp,sp,-80
    80002606:	e486                	sd	ra,72(sp)
    80002608:	e0a2                	sd	s0,64(sp)
    8000260a:	fc26                	sd	s1,56(sp)
    8000260c:	f84a                	sd	s2,48(sp)
    8000260e:	f44e                	sd	s3,40(sp)
    80002610:	f052                	sd	s4,32(sp)
    80002612:	ec56                	sd	s5,24(sp)
    80002614:	e85a                	sd	s6,16(sp)
    80002616:	e45e                	sd	s7,8(sp)
    80002618:	e062                	sd	s8,0(sp)
    8000261a:	0880                	addi	s0,sp,80
  for(b = 0; b < sb.size; b += BPB){
    8000261c:	00015797          	auipc	a5,0x15
    80002620:	5407a783          	lw	a5,1344(a5) # 80017b5c <sb+0x4>
    80002624:	c7c1                	beqz	a5,800026ac <balloc+0xa8>
    80002626:	8baa                	mv	s7,a0
    80002628:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000262a:	00015b17          	auipc	s6,0x15
    8000262e:	52eb0b13          	addi	s6,s6,1326 # 80017b58 <sb>
      m = 1 << (bi % 8);
    80002632:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002634:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002636:	6c09                	lui	s8,0x2
    80002638:	a821                	j	80002650 <balloc+0x4c>
    brelse(bp);
    8000263a:	854a                	mv	a0,s2
    8000263c:	00000097          	auipc	ra,0x0
    80002640:	e3c080e7          	jalr	-452(ra) # 80002478 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002644:	015c0abb          	addw	s5,s8,s5
    80002648:	004b2783          	lw	a5,4(s6)
    8000264c:	06faf063          	bgeu	s5,a5,800026ac <balloc+0xa8>
    bp = bread(dev, BBLOCK(b, sb));
    80002650:	41fad79b          	sraiw	a5,s5,0x1f
    80002654:	0137d79b          	srliw	a5,a5,0x13
    80002658:	015787bb          	addw	a5,a5,s5
    8000265c:	40d7d79b          	sraiw	a5,a5,0xd
    80002660:	01cb2583          	lw	a1,28(s6)
    80002664:	9dbd                	addw	a1,a1,a5
    80002666:	855e                	mv	a0,s7
    80002668:	00000097          	auipc	ra,0x0
    8000266c:	ce0080e7          	jalr	-800(ra) # 80002348 <bread>
    80002670:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002672:	004b2503          	lw	a0,4(s6)
    80002676:	84d6                	mv	s1,s5
    80002678:	4701                	li	a4,0
    8000267a:	fca4f0e3          	bgeu	s1,a0,8000263a <balloc+0x36>
      m = 1 << (bi % 8);
    8000267e:	00777693          	andi	a3,a4,7
    80002682:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002686:	41f7579b          	sraiw	a5,a4,0x1f
    8000268a:	01d7d79b          	srliw	a5,a5,0x1d
    8000268e:	9fb9                	addw	a5,a5,a4
    80002690:	4037d79b          	sraiw	a5,a5,0x3
    80002694:	00f90633          	add	a2,s2,a5
    80002698:	05864603          	lbu	a2,88(a2)
    8000269c:	00c6f5b3          	and	a1,a3,a2
    800026a0:	cd91                	beqz	a1,800026bc <balloc+0xb8>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026a2:	2705                	addiw	a4,a4,1
    800026a4:	2485                	addiw	s1,s1,1
    800026a6:	fd471ae3          	bne	a4,s4,8000267a <balloc+0x76>
    800026aa:	bf41                	j	8000263a <balloc+0x36>
  panic("balloc: out of blocks");
    800026ac:	00006517          	auipc	a0,0x6
    800026b0:	d2450513          	addi	a0,a0,-732 # 800083d0 <etext+0x3d0>
    800026b4:	00003097          	auipc	ra,0x3
    800026b8:	6b8080e7          	jalr	1720(ra) # 80005d6c <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    800026bc:	97ca                	add	a5,a5,s2
    800026be:	8e55                	or	a2,a2,a3
    800026c0:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800026c4:	854a                	mv	a0,s2
    800026c6:	00001097          	auipc	ra,0x1
    800026ca:	02e080e7          	jalr	46(ra) # 800036f4 <log_write>
        brelse(bp);
    800026ce:	854a                	mv	a0,s2
    800026d0:	00000097          	auipc	ra,0x0
    800026d4:	da8080e7          	jalr	-600(ra) # 80002478 <brelse>
  bp = bread(dev, bno);
    800026d8:	85a6                	mv	a1,s1
    800026da:	855e                	mv	a0,s7
    800026dc:	00000097          	auipc	ra,0x0
    800026e0:	c6c080e7          	jalr	-916(ra) # 80002348 <bread>
    800026e4:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800026e6:	40000613          	li	a2,1024
    800026ea:	4581                	li	a1,0
    800026ec:	05850513          	addi	a0,a0,88
    800026f0:	ffffe097          	auipc	ra,0xffffe
    800026f4:	a8a080e7          	jalr	-1398(ra) # 8000017a <memset>
  log_write(bp);
    800026f8:	854a                	mv	a0,s2
    800026fa:	00001097          	auipc	ra,0x1
    800026fe:	ffa080e7          	jalr	-6(ra) # 800036f4 <log_write>
  brelse(bp);
    80002702:	854a                	mv	a0,s2
    80002704:	00000097          	auipc	ra,0x0
    80002708:	d74080e7          	jalr	-652(ra) # 80002478 <brelse>
}
    8000270c:	8526                	mv	a0,s1
    8000270e:	60a6                	ld	ra,72(sp)
    80002710:	6406                	ld	s0,64(sp)
    80002712:	74e2                	ld	s1,56(sp)
    80002714:	7942                	ld	s2,48(sp)
    80002716:	79a2                	ld	s3,40(sp)
    80002718:	7a02                	ld	s4,32(sp)
    8000271a:	6ae2                	ld	s5,24(sp)
    8000271c:	6b42                	ld	s6,16(sp)
    8000271e:	6ba2                	ld	s7,8(sp)
    80002720:	6c02                	ld	s8,0(sp)
    80002722:	6161                	addi	sp,sp,80
    80002724:	8082                	ret

0000000080002726 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    80002726:	7179                	addi	sp,sp,-48
    80002728:	f406                	sd	ra,40(sp)
    8000272a:	f022                	sd	s0,32(sp)
    8000272c:	ec26                	sd	s1,24(sp)
    8000272e:	e84a                	sd	s2,16(sp)
    80002730:	e44e                	sd	s3,8(sp)
    80002732:	1800                	addi	s0,sp,48
    80002734:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002736:	47ad                	li	a5,11
    80002738:	04b7fd63          	bgeu	a5,a1,80002792 <bmap+0x6c>
    8000273c:	e052                	sd	s4,0(sp)
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    8000273e:	ff45849b          	addiw	s1,a1,-12

  if(bn < NINDIRECT){
    80002742:	0ff00793          	li	a5,255
    80002746:	0897ef63          	bltu	a5,s1,800027e4 <bmap+0xbe>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    8000274a:	08052583          	lw	a1,128(a0)
    8000274e:	c5a5                	beqz	a1,800027b6 <bmap+0x90>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80002750:	00092503          	lw	a0,0(s2)
    80002754:	00000097          	auipc	ra,0x0
    80002758:	bf4080e7          	jalr	-1036(ra) # 80002348 <bread>
    8000275c:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000275e:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002762:	02049713          	slli	a4,s1,0x20
    80002766:	01e75593          	srli	a1,a4,0x1e
    8000276a:	00b784b3          	add	s1,a5,a1
    8000276e:	0004a983          	lw	s3,0(s1)
    80002772:	04098b63          	beqz	s3,800027c8 <bmap+0xa2>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80002776:	8552                	mv	a0,s4
    80002778:	00000097          	auipc	ra,0x0
    8000277c:	d00080e7          	jalr	-768(ra) # 80002478 <brelse>
    return addr;
    80002780:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80002782:	854e                	mv	a0,s3
    80002784:	70a2                	ld	ra,40(sp)
    80002786:	7402                	ld	s0,32(sp)
    80002788:	64e2                	ld	s1,24(sp)
    8000278a:	6942                	ld	s2,16(sp)
    8000278c:	69a2                	ld	s3,8(sp)
    8000278e:	6145                	addi	sp,sp,48
    80002790:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80002792:	02059793          	slli	a5,a1,0x20
    80002796:	01e7d593          	srli	a1,a5,0x1e
    8000279a:	00b504b3          	add	s1,a0,a1
    8000279e:	0504a983          	lw	s3,80(s1)
    800027a2:	fe0990e3          	bnez	s3,80002782 <bmap+0x5c>
      ip->addrs[bn] = addr = balloc(ip->dev);
    800027a6:	4108                	lw	a0,0(a0)
    800027a8:	00000097          	auipc	ra,0x0
    800027ac:	e5c080e7          	jalr	-420(ra) # 80002604 <balloc>
    800027b0:	89aa                	mv	s3,a0
    800027b2:	c8a8                	sw	a0,80(s1)
    800027b4:	b7f9                	j	80002782 <bmap+0x5c>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    800027b6:	4108                	lw	a0,0(a0)
    800027b8:	00000097          	auipc	ra,0x0
    800027bc:	e4c080e7          	jalr	-436(ra) # 80002604 <balloc>
    800027c0:	85aa                	mv	a1,a0
    800027c2:	08a92023          	sw	a0,128(s2)
    800027c6:	b769                	j	80002750 <bmap+0x2a>
      a[bn] = addr = balloc(ip->dev);
    800027c8:	00092503          	lw	a0,0(s2)
    800027cc:	00000097          	auipc	ra,0x0
    800027d0:	e38080e7          	jalr	-456(ra) # 80002604 <balloc>
    800027d4:	89aa                	mv	s3,a0
    800027d6:	c088                	sw	a0,0(s1)
      log_write(bp);
    800027d8:	8552                	mv	a0,s4
    800027da:	00001097          	auipc	ra,0x1
    800027de:	f1a080e7          	jalr	-230(ra) # 800036f4 <log_write>
    800027e2:	bf51                	j	80002776 <bmap+0x50>
  panic("bmap: out of range");
    800027e4:	00006517          	auipc	a0,0x6
    800027e8:	c0450513          	addi	a0,a0,-1020 # 800083e8 <etext+0x3e8>
    800027ec:	00003097          	auipc	ra,0x3
    800027f0:	580080e7          	jalr	1408(ra) # 80005d6c <panic>

00000000800027f4 <iget>:
{
    800027f4:	7179                	addi	sp,sp,-48
    800027f6:	f406                	sd	ra,40(sp)
    800027f8:	f022                	sd	s0,32(sp)
    800027fa:	ec26                	sd	s1,24(sp)
    800027fc:	e84a                	sd	s2,16(sp)
    800027fe:	e44e                	sd	s3,8(sp)
    80002800:	e052                	sd	s4,0(sp)
    80002802:	1800                	addi	s0,sp,48
    80002804:	89aa                	mv	s3,a0
    80002806:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002808:	00015517          	auipc	a0,0x15
    8000280c:	37050513          	addi	a0,a0,880 # 80017b78 <itable>
    80002810:	00004097          	auipc	ra,0x4
    80002814:	ab2080e7          	jalr	-1358(ra) # 800062c2 <acquire>
  empty = 0;
    80002818:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000281a:	00015497          	auipc	s1,0x15
    8000281e:	37648493          	addi	s1,s1,886 # 80017b90 <itable+0x18>
    80002822:	00017697          	auipc	a3,0x17
    80002826:	dfe68693          	addi	a3,a3,-514 # 80019620 <log>
    8000282a:	a039                	j	80002838 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000282c:	02090b63          	beqz	s2,80002862 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002830:	08848493          	addi	s1,s1,136
    80002834:	02d48a63          	beq	s1,a3,80002868 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002838:	449c                	lw	a5,8(s1)
    8000283a:	fef059e3          	blez	a5,8000282c <iget+0x38>
    8000283e:	4098                	lw	a4,0(s1)
    80002840:	ff3716e3          	bne	a4,s3,8000282c <iget+0x38>
    80002844:	40d8                	lw	a4,4(s1)
    80002846:	ff4713e3          	bne	a4,s4,8000282c <iget+0x38>
      ip->ref++;
    8000284a:	2785                	addiw	a5,a5,1
    8000284c:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    8000284e:	00015517          	auipc	a0,0x15
    80002852:	32a50513          	addi	a0,a0,810 # 80017b78 <itable>
    80002856:	00004097          	auipc	ra,0x4
    8000285a:	b1c080e7          	jalr	-1252(ra) # 80006372 <release>
      return ip;
    8000285e:	8926                	mv	s2,s1
    80002860:	a03d                	j	8000288e <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002862:	f7f9                	bnez	a5,80002830 <iget+0x3c>
      empty = ip;
    80002864:	8926                	mv	s2,s1
    80002866:	b7e9                	j	80002830 <iget+0x3c>
  if(empty == 0)
    80002868:	02090c63          	beqz	s2,800028a0 <iget+0xac>
  ip->dev = dev;
    8000286c:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002870:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002874:	4785                	li	a5,1
    80002876:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    8000287a:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    8000287e:	00015517          	auipc	a0,0x15
    80002882:	2fa50513          	addi	a0,a0,762 # 80017b78 <itable>
    80002886:	00004097          	auipc	ra,0x4
    8000288a:	aec080e7          	jalr	-1300(ra) # 80006372 <release>
}
    8000288e:	854a                	mv	a0,s2
    80002890:	70a2                	ld	ra,40(sp)
    80002892:	7402                	ld	s0,32(sp)
    80002894:	64e2                	ld	s1,24(sp)
    80002896:	6942                	ld	s2,16(sp)
    80002898:	69a2                	ld	s3,8(sp)
    8000289a:	6a02                	ld	s4,0(sp)
    8000289c:	6145                	addi	sp,sp,48
    8000289e:	8082                	ret
    panic("iget: no inodes");
    800028a0:	00006517          	auipc	a0,0x6
    800028a4:	b6050513          	addi	a0,a0,-1184 # 80008400 <etext+0x400>
    800028a8:	00003097          	auipc	ra,0x3
    800028ac:	4c4080e7          	jalr	1220(ra) # 80005d6c <panic>

00000000800028b0 <fsinit>:
fsinit(int dev) {
    800028b0:	7179                	addi	sp,sp,-48
    800028b2:	f406                	sd	ra,40(sp)
    800028b4:	f022                	sd	s0,32(sp)
    800028b6:	ec26                	sd	s1,24(sp)
    800028b8:	e84a                	sd	s2,16(sp)
    800028ba:	e44e                	sd	s3,8(sp)
    800028bc:	1800                	addi	s0,sp,48
    800028be:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800028c0:	4585                	li	a1,1
    800028c2:	00000097          	auipc	ra,0x0
    800028c6:	a86080e7          	jalr	-1402(ra) # 80002348 <bread>
    800028ca:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800028cc:	00015997          	auipc	s3,0x15
    800028d0:	28c98993          	addi	s3,s3,652 # 80017b58 <sb>
    800028d4:	02000613          	li	a2,32
    800028d8:	05850593          	addi	a1,a0,88
    800028dc:	854e                	mv	a0,s3
    800028de:	ffffe097          	auipc	ra,0xffffe
    800028e2:	900080e7          	jalr	-1792(ra) # 800001de <memmove>
  brelse(bp);
    800028e6:	8526                	mv	a0,s1
    800028e8:	00000097          	auipc	ra,0x0
    800028ec:	b90080e7          	jalr	-1136(ra) # 80002478 <brelse>
  if(sb.magic != FSMAGIC)
    800028f0:	0009a703          	lw	a4,0(s3)
    800028f4:	102037b7          	lui	a5,0x10203
    800028f8:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800028fc:	02f71263          	bne	a4,a5,80002920 <fsinit+0x70>
  initlog(dev, &sb);
    80002900:	00015597          	auipc	a1,0x15
    80002904:	25858593          	addi	a1,a1,600 # 80017b58 <sb>
    80002908:	854a                	mv	a0,s2
    8000290a:	00001097          	auipc	ra,0x1
    8000290e:	b74080e7          	jalr	-1164(ra) # 8000347e <initlog>
}
    80002912:	70a2                	ld	ra,40(sp)
    80002914:	7402                	ld	s0,32(sp)
    80002916:	64e2                	ld	s1,24(sp)
    80002918:	6942                	ld	s2,16(sp)
    8000291a:	69a2                	ld	s3,8(sp)
    8000291c:	6145                	addi	sp,sp,48
    8000291e:	8082                	ret
    panic("invalid file system");
    80002920:	00006517          	auipc	a0,0x6
    80002924:	af050513          	addi	a0,a0,-1296 # 80008410 <etext+0x410>
    80002928:	00003097          	auipc	ra,0x3
    8000292c:	444080e7          	jalr	1092(ra) # 80005d6c <panic>

0000000080002930 <iinit>:
{
    80002930:	7179                	addi	sp,sp,-48
    80002932:	f406                	sd	ra,40(sp)
    80002934:	f022                	sd	s0,32(sp)
    80002936:	ec26                	sd	s1,24(sp)
    80002938:	e84a                	sd	s2,16(sp)
    8000293a:	e44e                	sd	s3,8(sp)
    8000293c:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    8000293e:	00006597          	auipc	a1,0x6
    80002942:	aea58593          	addi	a1,a1,-1302 # 80008428 <etext+0x428>
    80002946:	00015517          	auipc	a0,0x15
    8000294a:	23250513          	addi	a0,a0,562 # 80017b78 <itable>
    8000294e:	00004097          	auipc	ra,0x4
    80002952:	8e0080e7          	jalr	-1824(ra) # 8000622e <initlock>
  for(i = 0; i < NINODE; i++) {
    80002956:	00015497          	auipc	s1,0x15
    8000295a:	24a48493          	addi	s1,s1,586 # 80017ba0 <itable+0x28>
    8000295e:	00017997          	auipc	s3,0x17
    80002962:	cd298993          	addi	s3,s3,-814 # 80019630 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002966:	00006917          	auipc	s2,0x6
    8000296a:	aca90913          	addi	s2,s2,-1334 # 80008430 <etext+0x430>
    8000296e:	85ca                	mv	a1,s2
    80002970:	8526                	mv	a0,s1
    80002972:	00001097          	auipc	ra,0x1
    80002976:	e66080e7          	jalr	-410(ra) # 800037d8 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    8000297a:	08848493          	addi	s1,s1,136
    8000297e:	ff3498e3          	bne	s1,s3,8000296e <iinit+0x3e>
}
    80002982:	70a2                	ld	ra,40(sp)
    80002984:	7402                	ld	s0,32(sp)
    80002986:	64e2                	ld	s1,24(sp)
    80002988:	6942                	ld	s2,16(sp)
    8000298a:	69a2                	ld	s3,8(sp)
    8000298c:	6145                	addi	sp,sp,48
    8000298e:	8082                	ret

0000000080002990 <ialloc>:
{
    80002990:	7139                	addi	sp,sp,-64
    80002992:	fc06                	sd	ra,56(sp)
    80002994:	f822                	sd	s0,48(sp)
    80002996:	f426                	sd	s1,40(sp)
    80002998:	f04a                	sd	s2,32(sp)
    8000299a:	ec4e                	sd	s3,24(sp)
    8000299c:	e852                	sd	s4,16(sp)
    8000299e:	e456                	sd	s5,8(sp)
    800029a0:	e05a                	sd	s6,0(sp)
    800029a2:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    800029a4:	00015717          	auipc	a4,0x15
    800029a8:	1c072703          	lw	a4,448(a4) # 80017b64 <sb+0xc>
    800029ac:	4785                	li	a5,1
    800029ae:	04e7f863          	bgeu	a5,a4,800029fe <ialloc+0x6e>
    800029b2:	8aaa                	mv	s5,a0
    800029b4:	8b2e                	mv	s6,a1
    800029b6:	893e                	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
    800029b8:	00015a17          	auipc	s4,0x15
    800029bc:	1a0a0a13          	addi	s4,s4,416 # 80017b58 <sb>
    800029c0:	00495593          	srli	a1,s2,0x4
    800029c4:	018a2783          	lw	a5,24(s4)
    800029c8:	9dbd                	addw	a1,a1,a5
    800029ca:	8556                	mv	a0,s5
    800029cc:	00000097          	auipc	ra,0x0
    800029d0:	97c080e7          	jalr	-1668(ra) # 80002348 <bread>
    800029d4:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800029d6:	05850993          	addi	s3,a0,88
    800029da:	00f97793          	andi	a5,s2,15
    800029de:	079a                	slli	a5,a5,0x6
    800029e0:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800029e2:	00099783          	lh	a5,0(s3)
    800029e6:	c785                	beqz	a5,80002a0e <ialloc+0x7e>
    brelse(bp);
    800029e8:	00000097          	auipc	ra,0x0
    800029ec:	a90080e7          	jalr	-1392(ra) # 80002478 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800029f0:	0905                	addi	s2,s2,1
    800029f2:	00ca2703          	lw	a4,12(s4)
    800029f6:	0009079b          	sext.w	a5,s2
    800029fa:	fce7e3e3          	bltu	a5,a4,800029c0 <ialloc+0x30>
  panic("ialloc: no inodes");
    800029fe:	00006517          	auipc	a0,0x6
    80002a02:	a3a50513          	addi	a0,a0,-1478 # 80008438 <etext+0x438>
    80002a06:	00003097          	auipc	ra,0x3
    80002a0a:	366080e7          	jalr	870(ra) # 80005d6c <panic>
      memset(dip, 0, sizeof(*dip));
    80002a0e:	04000613          	li	a2,64
    80002a12:	4581                	li	a1,0
    80002a14:	854e                	mv	a0,s3
    80002a16:	ffffd097          	auipc	ra,0xffffd
    80002a1a:	764080e7          	jalr	1892(ra) # 8000017a <memset>
      dip->type = type;
    80002a1e:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002a22:	8526                	mv	a0,s1
    80002a24:	00001097          	auipc	ra,0x1
    80002a28:	cd0080e7          	jalr	-816(ra) # 800036f4 <log_write>
      brelse(bp);
    80002a2c:	8526                	mv	a0,s1
    80002a2e:	00000097          	auipc	ra,0x0
    80002a32:	a4a080e7          	jalr	-1462(ra) # 80002478 <brelse>
      return iget(dev, inum);
    80002a36:	0009059b          	sext.w	a1,s2
    80002a3a:	8556                	mv	a0,s5
    80002a3c:	00000097          	auipc	ra,0x0
    80002a40:	db8080e7          	jalr	-584(ra) # 800027f4 <iget>
}
    80002a44:	70e2                	ld	ra,56(sp)
    80002a46:	7442                	ld	s0,48(sp)
    80002a48:	74a2                	ld	s1,40(sp)
    80002a4a:	7902                	ld	s2,32(sp)
    80002a4c:	69e2                	ld	s3,24(sp)
    80002a4e:	6a42                	ld	s4,16(sp)
    80002a50:	6aa2                	ld	s5,8(sp)
    80002a52:	6b02                	ld	s6,0(sp)
    80002a54:	6121                	addi	sp,sp,64
    80002a56:	8082                	ret

0000000080002a58 <iupdate>:
{
    80002a58:	1101                	addi	sp,sp,-32
    80002a5a:	ec06                	sd	ra,24(sp)
    80002a5c:	e822                	sd	s0,16(sp)
    80002a5e:	e426                	sd	s1,8(sp)
    80002a60:	e04a                	sd	s2,0(sp)
    80002a62:	1000                	addi	s0,sp,32
    80002a64:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002a66:	415c                	lw	a5,4(a0)
    80002a68:	0047d79b          	srliw	a5,a5,0x4
    80002a6c:	00015597          	auipc	a1,0x15
    80002a70:	1045a583          	lw	a1,260(a1) # 80017b70 <sb+0x18>
    80002a74:	9dbd                	addw	a1,a1,a5
    80002a76:	4108                	lw	a0,0(a0)
    80002a78:	00000097          	auipc	ra,0x0
    80002a7c:	8d0080e7          	jalr	-1840(ra) # 80002348 <bread>
    80002a80:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002a82:	05850793          	addi	a5,a0,88
    80002a86:	40d8                	lw	a4,4(s1)
    80002a88:	8b3d                	andi	a4,a4,15
    80002a8a:	071a                	slli	a4,a4,0x6
    80002a8c:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002a8e:	04449703          	lh	a4,68(s1)
    80002a92:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002a96:	04649703          	lh	a4,70(s1)
    80002a9a:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002a9e:	04849703          	lh	a4,72(s1)
    80002aa2:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002aa6:	04a49703          	lh	a4,74(s1)
    80002aaa:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002aae:	44f8                	lw	a4,76(s1)
    80002ab0:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002ab2:	03400613          	li	a2,52
    80002ab6:	05048593          	addi	a1,s1,80
    80002aba:	00c78513          	addi	a0,a5,12
    80002abe:	ffffd097          	auipc	ra,0xffffd
    80002ac2:	720080e7          	jalr	1824(ra) # 800001de <memmove>
  log_write(bp);
    80002ac6:	854a                	mv	a0,s2
    80002ac8:	00001097          	auipc	ra,0x1
    80002acc:	c2c080e7          	jalr	-980(ra) # 800036f4 <log_write>
  brelse(bp);
    80002ad0:	854a                	mv	a0,s2
    80002ad2:	00000097          	auipc	ra,0x0
    80002ad6:	9a6080e7          	jalr	-1626(ra) # 80002478 <brelse>
}
    80002ada:	60e2                	ld	ra,24(sp)
    80002adc:	6442                	ld	s0,16(sp)
    80002ade:	64a2                	ld	s1,8(sp)
    80002ae0:	6902                	ld	s2,0(sp)
    80002ae2:	6105                	addi	sp,sp,32
    80002ae4:	8082                	ret

0000000080002ae6 <idup>:
{
    80002ae6:	1101                	addi	sp,sp,-32
    80002ae8:	ec06                	sd	ra,24(sp)
    80002aea:	e822                	sd	s0,16(sp)
    80002aec:	e426                	sd	s1,8(sp)
    80002aee:	1000                	addi	s0,sp,32
    80002af0:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002af2:	00015517          	auipc	a0,0x15
    80002af6:	08650513          	addi	a0,a0,134 # 80017b78 <itable>
    80002afa:	00003097          	auipc	ra,0x3
    80002afe:	7c8080e7          	jalr	1992(ra) # 800062c2 <acquire>
  ip->ref++;
    80002b02:	449c                	lw	a5,8(s1)
    80002b04:	2785                	addiw	a5,a5,1
    80002b06:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002b08:	00015517          	auipc	a0,0x15
    80002b0c:	07050513          	addi	a0,a0,112 # 80017b78 <itable>
    80002b10:	00004097          	auipc	ra,0x4
    80002b14:	862080e7          	jalr	-1950(ra) # 80006372 <release>
}
    80002b18:	8526                	mv	a0,s1
    80002b1a:	60e2                	ld	ra,24(sp)
    80002b1c:	6442                	ld	s0,16(sp)
    80002b1e:	64a2                	ld	s1,8(sp)
    80002b20:	6105                	addi	sp,sp,32
    80002b22:	8082                	ret

0000000080002b24 <ilock>:
{
    80002b24:	1101                	addi	sp,sp,-32
    80002b26:	ec06                	sd	ra,24(sp)
    80002b28:	e822                	sd	s0,16(sp)
    80002b2a:	e426                	sd	s1,8(sp)
    80002b2c:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002b2e:	c10d                	beqz	a0,80002b50 <ilock+0x2c>
    80002b30:	84aa                	mv	s1,a0
    80002b32:	451c                	lw	a5,8(a0)
    80002b34:	00f05e63          	blez	a5,80002b50 <ilock+0x2c>
  acquiresleep(&ip->lock);
    80002b38:	0541                	addi	a0,a0,16
    80002b3a:	00001097          	auipc	ra,0x1
    80002b3e:	cd8080e7          	jalr	-808(ra) # 80003812 <acquiresleep>
  if(ip->valid == 0){
    80002b42:	40bc                	lw	a5,64(s1)
    80002b44:	cf99                	beqz	a5,80002b62 <ilock+0x3e>
}
    80002b46:	60e2                	ld	ra,24(sp)
    80002b48:	6442                	ld	s0,16(sp)
    80002b4a:	64a2                	ld	s1,8(sp)
    80002b4c:	6105                	addi	sp,sp,32
    80002b4e:	8082                	ret
    80002b50:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80002b52:	00006517          	auipc	a0,0x6
    80002b56:	8fe50513          	addi	a0,a0,-1794 # 80008450 <etext+0x450>
    80002b5a:	00003097          	auipc	ra,0x3
    80002b5e:	212080e7          	jalr	530(ra) # 80005d6c <panic>
    80002b62:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b64:	40dc                	lw	a5,4(s1)
    80002b66:	0047d79b          	srliw	a5,a5,0x4
    80002b6a:	00015597          	auipc	a1,0x15
    80002b6e:	0065a583          	lw	a1,6(a1) # 80017b70 <sb+0x18>
    80002b72:	9dbd                	addw	a1,a1,a5
    80002b74:	4088                	lw	a0,0(s1)
    80002b76:	fffff097          	auipc	ra,0xfffff
    80002b7a:	7d2080e7          	jalr	2002(ra) # 80002348 <bread>
    80002b7e:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b80:	05850593          	addi	a1,a0,88
    80002b84:	40dc                	lw	a5,4(s1)
    80002b86:	8bbd                	andi	a5,a5,15
    80002b88:	079a                	slli	a5,a5,0x6
    80002b8a:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002b8c:	00059783          	lh	a5,0(a1)
    80002b90:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002b94:	00259783          	lh	a5,2(a1)
    80002b98:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002b9c:	00459783          	lh	a5,4(a1)
    80002ba0:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002ba4:	00659783          	lh	a5,6(a1)
    80002ba8:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002bac:	459c                	lw	a5,8(a1)
    80002bae:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002bb0:	03400613          	li	a2,52
    80002bb4:	05b1                	addi	a1,a1,12
    80002bb6:	05048513          	addi	a0,s1,80
    80002bba:	ffffd097          	auipc	ra,0xffffd
    80002bbe:	624080e7          	jalr	1572(ra) # 800001de <memmove>
    brelse(bp);
    80002bc2:	854a                	mv	a0,s2
    80002bc4:	00000097          	auipc	ra,0x0
    80002bc8:	8b4080e7          	jalr	-1868(ra) # 80002478 <brelse>
    ip->valid = 1;
    80002bcc:	4785                	li	a5,1
    80002bce:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002bd0:	04449783          	lh	a5,68(s1)
    80002bd4:	c399                	beqz	a5,80002bda <ilock+0xb6>
    80002bd6:	6902                	ld	s2,0(sp)
    80002bd8:	b7bd                	j	80002b46 <ilock+0x22>
      panic("ilock: no type");
    80002bda:	00006517          	auipc	a0,0x6
    80002bde:	87e50513          	addi	a0,a0,-1922 # 80008458 <etext+0x458>
    80002be2:	00003097          	auipc	ra,0x3
    80002be6:	18a080e7          	jalr	394(ra) # 80005d6c <panic>

0000000080002bea <iunlock>:
{
    80002bea:	1101                	addi	sp,sp,-32
    80002bec:	ec06                	sd	ra,24(sp)
    80002bee:	e822                	sd	s0,16(sp)
    80002bf0:	e426                	sd	s1,8(sp)
    80002bf2:	e04a                	sd	s2,0(sp)
    80002bf4:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002bf6:	c905                	beqz	a0,80002c26 <iunlock+0x3c>
    80002bf8:	84aa                	mv	s1,a0
    80002bfa:	01050913          	addi	s2,a0,16
    80002bfe:	854a                	mv	a0,s2
    80002c00:	00001097          	auipc	ra,0x1
    80002c04:	cac080e7          	jalr	-852(ra) # 800038ac <holdingsleep>
    80002c08:	cd19                	beqz	a0,80002c26 <iunlock+0x3c>
    80002c0a:	449c                	lw	a5,8(s1)
    80002c0c:	00f05d63          	blez	a5,80002c26 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002c10:	854a                	mv	a0,s2
    80002c12:	00001097          	auipc	ra,0x1
    80002c16:	c56080e7          	jalr	-938(ra) # 80003868 <releasesleep>
}
    80002c1a:	60e2                	ld	ra,24(sp)
    80002c1c:	6442                	ld	s0,16(sp)
    80002c1e:	64a2                	ld	s1,8(sp)
    80002c20:	6902                	ld	s2,0(sp)
    80002c22:	6105                	addi	sp,sp,32
    80002c24:	8082                	ret
    panic("iunlock");
    80002c26:	00006517          	auipc	a0,0x6
    80002c2a:	84250513          	addi	a0,a0,-1982 # 80008468 <etext+0x468>
    80002c2e:	00003097          	auipc	ra,0x3
    80002c32:	13e080e7          	jalr	318(ra) # 80005d6c <panic>

0000000080002c36 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002c36:	7179                	addi	sp,sp,-48
    80002c38:	f406                	sd	ra,40(sp)
    80002c3a:	f022                	sd	s0,32(sp)
    80002c3c:	ec26                	sd	s1,24(sp)
    80002c3e:	e84a                	sd	s2,16(sp)
    80002c40:	e44e                	sd	s3,8(sp)
    80002c42:	1800                	addi	s0,sp,48
    80002c44:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002c46:	05050493          	addi	s1,a0,80
    80002c4a:	08050913          	addi	s2,a0,128
    80002c4e:	a021                	j	80002c56 <itrunc+0x20>
    80002c50:	0491                	addi	s1,s1,4
    80002c52:	01248d63          	beq	s1,s2,80002c6c <itrunc+0x36>
    if(ip->addrs[i]){
    80002c56:	408c                	lw	a1,0(s1)
    80002c58:	dde5                	beqz	a1,80002c50 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80002c5a:	0009a503          	lw	a0,0(s3)
    80002c5e:	00000097          	auipc	ra,0x0
    80002c62:	92a080e7          	jalr	-1750(ra) # 80002588 <bfree>
      ip->addrs[i] = 0;
    80002c66:	0004a023          	sw	zero,0(s1)
    80002c6a:	b7dd                	j	80002c50 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002c6c:	0809a583          	lw	a1,128(s3)
    80002c70:	ed99                	bnez	a1,80002c8e <itrunc+0x58>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002c72:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002c76:	854e                	mv	a0,s3
    80002c78:	00000097          	auipc	ra,0x0
    80002c7c:	de0080e7          	jalr	-544(ra) # 80002a58 <iupdate>
}
    80002c80:	70a2                	ld	ra,40(sp)
    80002c82:	7402                	ld	s0,32(sp)
    80002c84:	64e2                	ld	s1,24(sp)
    80002c86:	6942                	ld	s2,16(sp)
    80002c88:	69a2                	ld	s3,8(sp)
    80002c8a:	6145                	addi	sp,sp,48
    80002c8c:	8082                	ret
    80002c8e:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002c90:	0009a503          	lw	a0,0(s3)
    80002c94:	fffff097          	auipc	ra,0xfffff
    80002c98:	6b4080e7          	jalr	1716(ra) # 80002348 <bread>
    80002c9c:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002c9e:	05850493          	addi	s1,a0,88
    80002ca2:	45850913          	addi	s2,a0,1112
    80002ca6:	a021                	j	80002cae <itrunc+0x78>
    80002ca8:	0491                	addi	s1,s1,4
    80002caa:	01248b63          	beq	s1,s2,80002cc0 <itrunc+0x8a>
      if(a[j])
    80002cae:	408c                	lw	a1,0(s1)
    80002cb0:	dde5                	beqz	a1,80002ca8 <itrunc+0x72>
        bfree(ip->dev, a[j]);
    80002cb2:	0009a503          	lw	a0,0(s3)
    80002cb6:	00000097          	auipc	ra,0x0
    80002cba:	8d2080e7          	jalr	-1838(ra) # 80002588 <bfree>
    80002cbe:	b7ed                	j	80002ca8 <itrunc+0x72>
    brelse(bp);
    80002cc0:	8552                	mv	a0,s4
    80002cc2:	fffff097          	auipc	ra,0xfffff
    80002cc6:	7b6080e7          	jalr	1974(ra) # 80002478 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002cca:	0809a583          	lw	a1,128(s3)
    80002cce:	0009a503          	lw	a0,0(s3)
    80002cd2:	00000097          	auipc	ra,0x0
    80002cd6:	8b6080e7          	jalr	-1866(ra) # 80002588 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002cda:	0809a023          	sw	zero,128(s3)
    80002cde:	6a02                	ld	s4,0(sp)
    80002ce0:	bf49                	j	80002c72 <itrunc+0x3c>

0000000080002ce2 <iput>:
{
    80002ce2:	1101                	addi	sp,sp,-32
    80002ce4:	ec06                	sd	ra,24(sp)
    80002ce6:	e822                	sd	s0,16(sp)
    80002ce8:	e426                	sd	s1,8(sp)
    80002cea:	1000                	addi	s0,sp,32
    80002cec:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002cee:	00015517          	auipc	a0,0x15
    80002cf2:	e8a50513          	addi	a0,a0,-374 # 80017b78 <itable>
    80002cf6:	00003097          	auipc	ra,0x3
    80002cfa:	5cc080e7          	jalr	1484(ra) # 800062c2 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002cfe:	4498                	lw	a4,8(s1)
    80002d00:	4785                	li	a5,1
    80002d02:	02f70263          	beq	a4,a5,80002d26 <iput+0x44>
  ip->ref--;
    80002d06:	449c                	lw	a5,8(s1)
    80002d08:	37fd                	addiw	a5,a5,-1
    80002d0a:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002d0c:	00015517          	auipc	a0,0x15
    80002d10:	e6c50513          	addi	a0,a0,-404 # 80017b78 <itable>
    80002d14:	00003097          	auipc	ra,0x3
    80002d18:	65e080e7          	jalr	1630(ra) # 80006372 <release>
}
    80002d1c:	60e2                	ld	ra,24(sp)
    80002d1e:	6442                	ld	s0,16(sp)
    80002d20:	64a2                	ld	s1,8(sp)
    80002d22:	6105                	addi	sp,sp,32
    80002d24:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002d26:	40bc                	lw	a5,64(s1)
    80002d28:	dff9                	beqz	a5,80002d06 <iput+0x24>
    80002d2a:	04a49783          	lh	a5,74(s1)
    80002d2e:	ffe1                	bnez	a5,80002d06 <iput+0x24>
    80002d30:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80002d32:	01048913          	addi	s2,s1,16
    80002d36:	854a                	mv	a0,s2
    80002d38:	00001097          	auipc	ra,0x1
    80002d3c:	ada080e7          	jalr	-1318(ra) # 80003812 <acquiresleep>
    release(&itable.lock);
    80002d40:	00015517          	auipc	a0,0x15
    80002d44:	e3850513          	addi	a0,a0,-456 # 80017b78 <itable>
    80002d48:	00003097          	auipc	ra,0x3
    80002d4c:	62a080e7          	jalr	1578(ra) # 80006372 <release>
    itrunc(ip);
    80002d50:	8526                	mv	a0,s1
    80002d52:	00000097          	auipc	ra,0x0
    80002d56:	ee4080e7          	jalr	-284(ra) # 80002c36 <itrunc>
    ip->type = 0;
    80002d5a:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002d5e:	8526                	mv	a0,s1
    80002d60:	00000097          	auipc	ra,0x0
    80002d64:	cf8080e7          	jalr	-776(ra) # 80002a58 <iupdate>
    ip->valid = 0;
    80002d68:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002d6c:	854a                	mv	a0,s2
    80002d6e:	00001097          	auipc	ra,0x1
    80002d72:	afa080e7          	jalr	-1286(ra) # 80003868 <releasesleep>
    acquire(&itable.lock);
    80002d76:	00015517          	auipc	a0,0x15
    80002d7a:	e0250513          	addi	a0,a0,-510 # 80017b78 <itable>
    80002d7e:	00003097          	auipc	ra,0x3
    80002d82:	544080e7          	jalr	1348(ra) # 800062c2 <acquire>
    80002d86:	6902                	ld	s2,0(sp)
    80002d88:	bfbd                	j	80002d06 <iput+0x24>

0000000080002d8a <iunlockput>:
{
    80002d8a:	1101                	addi	sp,sp,-32
    80002d8c:	ec06                	sd	ra,24(sp)
    80002d8e:	e822                	sd	s0,16(sp)
    80002d90:	e426                	sd	s1,8(sp)
    80002d92:	1000                	addi	s0,sp,32
    80002d94:	84aa                	mv	s1,a0
  iunlock(ip);
    80002d96:	00000097          	auipc	ra,0x0
    80002d9a:	e54080e7          	jalr	-428(ra) # 80002bea <iunlock>
  iput(ip);
    80002d9e:	8526                	mv	a0,s1
    80002da0:	00000097          	auipc	ra,0x0
    80002da4:	f42080e7          	jalr	-190(ra) # 80002ce2 <iput>
}
    80002da8:	60e2                	ld	ra,24(sp)
    80002daa:	6442                	ld	s0,16(sp)
    80002dac:	64a2                	ld	s1,8(sp)
    80002dae:	6105                	addi	sp,sp,32
    80002db0:	8082                	ret

0000000080002db2 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002db2:	1141                	addi	sp,sp,-16
    80002db4:	e406                	sd	ra,8(sp)
    80002db6:	e022                	sd	s0,0(sp)
    80002db8:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002dba:	411c                	lw	a5,0(a0)
    80002dbc:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002dbe:	415c                	lw	a5,4(a0)
    80002dc0:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002dc2:	04451783          	lh	a5,68(a0)
    80002dc6:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002dca:	04a51783          	lh	a5,74(a0)
    80002dce:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002dd2:	04c56783          	lwu	a5,76(a0)
    80002dd6:	e99c                	sd	a5,16(a1)
}
    80002dd8:	60a2                	ld	ra,8(sp)
    80002dda:	6402                	ld	s0,0(sp)
    80002ddc:	0141                	addi	sp,sp,16
    80002dde:	8082                	ret

0000000080002de0 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002de0:	457c                	lw	a5,76(a0)
    80002de2:	0ed7ea63          	bltu	a5,a3,80002ed6 <readi+0xf6>
{
    80002de6:	7159                	addi	sp,sp,-112
    80002de8:	f486                	sd	ra,104(sp)
    80002dea:	f0a2                	sd	s0,96(sp)
    80002dec:	eca6                	sd	s1,88(sp)
    80002dee:	fc56                	sd	s5,56(sp)
    80002df0:	f85a                	sd	s6,48(sp)
    80002df2:	f45e                	sd	s7,40(sp)
    80002df4:	ec66                	sd	s9,24(sp)
    80002df6:	1880                	addi	s0,sp,112
    80002df8:	8baa                	mv	s7,a0
    80002dfa:	8cae                	mv	s9,a1
    80002dfc:	8ab2                	mv	s5,a2
    80002dfe:	84b6                	mv	s1,a3
    80002e00:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002e02:	9f35                	addw	a4,a4,a3
    return 0;
    80002e04:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002e06:	0ad76763          	bltu	a4,a3,80002eb4 <readi+0xd4>
    80002e0a:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80002e0c:	00e7f463          	bgeu	a5,a4,80002e14 <readi+0x34>
    n = ip->size - off;
    80002e10:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002e14:	0a0b0f63          	beqz	s6,80002ed2 <readi+0xf2>
    80002e18:	e8ca                	sd	s2,80(sp)
    80002e1a:	e0d2                	sd	s4,64(sp)
    80002e1c:	f062                	sd	s8,32(sp)
    80002e1e:	e86a                	sd	s10,16(sp)
    80002e20:	e46e                	sd	s11,8(sp)
    80002e22:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002e24:	40000d93          	li	s11,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002e28:	5d7d                	li	s10,-1
    80002e2a:	a82d                	j	80002e64 <readi+0x84>
    80002e2c:	020a1c13          	slli	s8,s4,0x20
    80002e30:	020c5c13          	srli	s8,s8,0x20
    80002e34:	05890613          	addi	a2,s2,88
    80002e38:	86e2                	mv	a3,s8
    80002e3a:	963e                	add	a2,a2,a5
    80002e3c:	85d6                	mv	a1,s5
    80002e3e:	8566                	mv	a0,s9
    80002e40:	fffff097          	auipc	ra,0xfffff
    80002e44:	ac6080e7          	jalr	-1338(ra) # 80001906 <either_copyout>
    80002e48:	05a50963          	beq	a0,s10,80002e9a <readi+0xba>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002e4c:	854a                	mv	a0,s2
    80002e4e:	fffff097          	auipc	ra,0xfffff
    80002e52:	62a080e7          	jalr	1578(ra) # 80002478 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002e56:	013a09bb          	addw	s3,s4,s3
    80002e5a:	009a04bb          	addw	s1,s4,s1
    80002e5e:	9ae2                	add	s5,s5,s8
    80002e60:	0769f363          	bgeu	s3,s6,80002ec6 <readi+0xe6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002e64:	000ba903          	lw	s2,0(s7)
    80002e68:	00a4d59b          	srliw	a1,s1,0xa
    80002e6c:	855e                	mv	a0,s7
    80002e6e:	00000097          	auipc	ra,0x0
    80002e72:	8b8080e7          	jalr	-1864(ra) # 80002726 <bmap>
    80002e76:	85aa                	mv	a1,a0
    80002e78:	854a                	mv	a0,s2
    80002e7a:	fffff097          	auipc	ra,0xfffff
    80002e7e:	4ce080e7          	jalr	1230(ra) # 80002348 <bread>
    80002e82:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002e84:	3ff4f793          	andi	a5,s1,1023
    80002e88:	40fd873b          	subw	a4,s11,a5
    80002e8c:	413b06bb          	subw	a3,s6,s3
    80002e90:	8a3a                	mv	s4,a4
    80002e92:	f8e6fde3          	bgeu	a3,a4,80002e2c <readi+0x4c>
    80002e96:	8a36                	mv	s4,a3
    80002e98:	bf51                	j	80002e2c <readi+0x4c>
      brelse(bp);
    80002e9a:	854a                	mv	a0,s2
    80002e9c:	fffff097          	auipc	ra,0xfffff
    80002ea0:	5dc080e7          	jalr	1500(ra) # 80002478 <brelse>
      tot = -1;
    80002ea4:	59fd                	li	s3,-1
      break;
    80002ea6:	6946                	ld	s2,80(sp)
    80002ea8:	6a06                	ld	s4,64(sp)
    80002eaa:	7c02                	ld	s8,32(sp)
    80002eac:	6d42                	ld	s10,16(sp)
    80002eae:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80002eb0:	854e                	mv	a0,s3
    80002eb2:	69a6                	ld	s3,72(sp)
}
    80002eb4:	70a6                	ld	ra,104(sp)
    80002eb6:	7406                	ld	s0,96(sp)
    80002eb8:	64e6                	ld	s1,88(sp)
    80002eba:	7ae2                	ld	s5,56(sp)
    80002ebc:	7b42                	ld	s6,48(sp)
    80002ebe:	7ba2                	ld	s7,40(sp)
    80002ec0:	6ce2                	ld	s9,24(sp)
    80002ec2:	6165                	addi	sp,sp,112
    80002ec4:	8082                	ret
    80002ec6:	6946                	ld	s2,80(sp)
    80002ec8:	6a06                	ld	s4,64(sp)
    80002eca:	7c02                	ld	s8,32(sp)
    80002ecc:	6d42                	ld	s10,16(sp)
    80002ece:	6da2                	ld	s11,8(sp)
    80002ed0:	b7c5                	j	80002eb0 <readi+0xd0>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002ed2:	89da                	mv	s3,s6
    80002ed4:	bff1                	j	80002eb0 <readi+0xd0>
    return 0;
    80002ed6:	4501                	li	a0,0
}
    80002ed8:	8082                	ret

0000000080002eda <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002eda:	457c                	lw	a5,76(a0)
    80002edc:	10d7e963          	bltu	a5,a3,80002fee <writei+0x114>
{
    80002ee0:	7159                	addi	sp,sp,-112
    80002ee2:	f486                	sd	ra,104(sp)
    80002ee4:	f0a2                	sd	s0,96(sp)
    80002ee6:	e8ca                	sd	s2,80(sp)
    80002ee8:	fc56                	sd	s5,56(sp)
    80002eea:	f45e                	sd	s7,40(sp)
    80002eec:	f062                	sd	s8,32(sp)
    80002eee:	ec66                	sd	s9,24(sp)
    80002ef0:	1880                	addi	s0,sp,112
    80002ef2:	8baa                	mv	s7,a0
    80002ef4:	8cae                	mv	s9,a1
    80002ef6:	8ab2                	mv	s5,a2
    80002ef8:	8936                	mv	s2,a3
    80002efa:	8c3a                	mv	s8,a4
  if(off > ip->size || off + n < off)
    80002efc:	00e687bb          	addw	a5,a3,a4
    80002f00:	0ed7e963          	bltu	a5,a3,80002ff2 <writei+0x118>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002f04:	00043737          	lui	a4,0x43
    80002f08:	0ef76763          	bltu	a4,a5,80002ff6 <writei+0x11c>
    80002f0c:	e0d2                	sd	s4,64(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002f0e:	0c0c0863          	beqz	s8,80002fde <writei+0x104>
    80002f12:	eca6                	sd	s1,88(sp)
    80002f14:	e4ce                	sd	s3,72(sp)
    80002f16:	f85a                	sd	s6,48(sp)
    80002f18:	e86a                	sd	s10,16(sp)
    80002f1a:	e46e                	sd	s11,8(sp)
    80002f1c:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f1e:	40000d93          	li	s11,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002f22:	5d7d                	li	s10,-1
    80002f24:	a091                	j	80002f68 <writei+0x8e>
    80002f26:	02099b13          	slli	s6,s3,0x20
    80002f2a:	020b5b13          	srli	s6,s6,0x20
    80002f2e:	05848513          	addi	a0,s1,88
    80002f32:	86da                	mv	a3,s6
    80002f34:	8656                	mv	a2,s5
    80002f36:	85e6                	mv	a1,s9
    80002f38:	953e                	add	a0,a0,a5
    80002f3a:	fffff097          	auipc	ra,0xfffff
    80002f3e:	a22080e7          	jalr	-1502(ra) # 8000195c <either_copyin>
    80002f42:	05a50e63          	beq	a0,s10,80002f9e <writei+0xc4>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002f46:	8526                	mv	a0,s1
    80002f48:	00000097          	auipc	ra,0x0
    80002f4c:	7ac080e7          	jalr	1964(ra) # 800036f4 <log_write>
    brelse(bp);
    80002f50:	8526                	mv	a0,s1
    80002f52:	fffff097          	auipc	ra,0xfffff
    80002f56:	526080e7          	jalr	1318(ra) # 80002478 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002f5a:	01498a3b          	addw	s4,s3,s4
    80002f5e:	0129893b          	addw	s2,s3,s2
    80002f62:	9ada                	add	s5,s5,s6
    80002f64:	058a7263          	bgeu	s4,s8,80002fa8 <writei+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002f68:	000ba483          	lw	s1,0(s7)
    80002f6c:	00a9559b          	srliw	a1,s2,0xa
    80002f70:	855e                	mv	a0,s7
    80002f72:	fffff097          	auipc	ra,0xfffff
    80002f76:	7b4080e7          	jalr	1972(ra) # 80002726 <bmap>
    80002f7a:	85aa                	mv	a1,a0
    80002f7c:	8526                	mv	a0,s1
    80002f7e:	fffff097          	auipc	ra,0xfffff
    80002f82:	3ca080e7          	jalr	970(ra) # 80002348 <bread>
    80002f86:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f88:	3ff97793          	andi	a5,s2,1023
    80002f8c:	40fd873b          	subw	a4,s11,a5
    80002f90:	414c06bb          	subw	a3,s8,s4
    80002f94:	89ba                	mv	s3,a4
    80002f96:	f8e6f8e3          	bgeu	a3,a4,80002f26 <writei+0x4c>
    80002f9a:	89b6                	mv	s3,a3
    80002f9c:	b769                	j	80002f26 <writei+0x4c>
      brelse(bp);
    80002f9e:	8526                	mv	a0,s1
    80002fa0:	fffff097          	auipc	ra,0xfffff
    80002fa4:	4d8080e7          	jalr	1240(ra) # 80002478 <brelse>
  }

  if(off > ip->size)
    80002fa8:	04cba783          	lw	a5,76(s7)
    80002fac:	0327fb63          	bgeu	a5,s2,80002fe2 <writei+0x108>
    ip->size = off;
    80002fb0:	052ba623          	sw	s2,76(s7)
    80002fb4:	64e6                	ld	s1,88(sp)
    80002fb6:	69a6                	ld	s3,72(sp)
    80002fb8:	7b42                	ld	s6,48(sp)
    80002fba:	6d42                	ld	s10,16(sp)
    80002fbc:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002fbe:	855e                	mv	a0,s7
    80002fc0:	00000097          	auipc	ra,0x0
    80002fc4:	a98080e7          	jalr	-1384(ra) # 80002a58 <iupdate>

  return tot;
    80002fc8:	8552                	mv	a0,s4
    80002fca:	6a06                	ld	s4,64(sp)
}
    80002fcc:	70a6                	ld	ra,104(sp)
    80002fce:	7406                	ld	s0,96(sp)
    80002fd0:	6946                	ld	s2,80(sp)
    80002fd2:	7ae2                	ld	s5,56(sp)
    80002fd4:	7ba2                	ld	s7,40(sp)
    80002fd6:	7c02                	ld	s8,32(sp)
    80002fd8:	6ce2                	ld	s9,24(sp)
    80002fda:	6165                	addi	sp,sp,112
    80002fdc:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002fde:	8a62                	mv	s4,s8
    80002fe0:	bff9                	j	80002fbe <writei+0xe4>
    80002fe2:	64e6                	ld	s1,88(sp)
    80002fe4:	69a6                	ld	s3,72(sp)
    80002fe6:	7b42                	ld	s6,48(sp)
    80002fe8:	6d42                	ld	s10,16(sp)
    80002fea:	6da2                	ld	s11,8(sp)
    80002fec:	bfc9                	j	80002fbe <writei+0xe4>
    return -1;
    80002fee:	557d                	li	a0,-1
}
    80002ff0:	8082                	ret
    return -1;
    80002ff2:	557d                	li	a0,-1
    80002ff4:	bfe1                	j	80002fcc <writei+0xf2>
    return -1;
    80002ff6:	557d                	li	a0,-1
    80002ff8:	bfd1                	j	80002fcc <writei+0xf2>

0000000080002ffa <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002ffa:	1141                	addi	sp,sp,-16
    80002ffc:	e406                	sd	ra,8(sp)
    80002ffe:	e022                	sd	s0,0(sp)
    80003000:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003002:	4639                	li	a2,14
    80003004:	ffffd097          	auipc	ra,0xffffd
    80003008:	252080e7          	jalr	594(ra) # 80000256 <strncmp>
}
    8000300c:	60a2                	ld	ra,8(sp)
    8000300e:	6402                	ld	s0,0(sp)
    80003010:	0141                	addi	sp,sp,16
    80003012:	8082                	ret

0000000080003014 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003014:	711d                	addi	sp,sp,-96
    80003016:	ec86                	sd	ra,88(sp)
    80003018:	e8a2                	sd	s0,80(sp)
    8000301a:	e4a6                	sd	s1,72(sp)
    8000301c:	e0ca                	sd	s2,64(sp)
    8000301e:	fc4e                	sd	s3,56(sp)
    80003020:	f852                	sd	s4,48(sp)
    80003022:	f456                	sd	s5,40(sp)
    80003024:	f05a                	sd	s6,32(sp)
    80003026:	ec5e                	sd	s7,24(sp)
    80003028:	1080                	addi	s0,sp,96
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    8000302a:	04451703          	lh	a4,68(a0)
    8000302e:	4785                	li	a5,1
    80003030:	00f71f63          	bne	a4,a5,8000304e <dirlookup+0x3a>
    80003034:	892a                	mv	s2,a0
    80003036:	8aae                	mv	s5,a1
    80003038:	8bb2                	mv	s7,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    8000303a:	457c                	lw	a5,76(a0)
    8000303c:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000303e:	fa040a13          	addi	s4,s0,-96
    80003042:	49c1                	li	s3,16
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
    80003044:	fa240b13          	addi	s6,s0,-94
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003048:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000304a:	e79d                	bnez	a5,80003078 <dirlookup+0x64>
    8000304c:	a88d                	j	800030be <dirlookup+0xaa>
    panic("dirlookup not DIR");
    8000304e:	00005517          	auipc	a0,0x5
    80003052:	42250513          	addi	a0,a0,1058 # 80008470 <etext+0x470>
    80003056:	00003097          	auipc	ra,0x3
    8000305a:	d16080e7          	jalr	-746(ra) # 80005d6c <panic>
      panic("dirlookup read");
    8000305e:	00005517          	auipc	a0,0x5
    80003062:	42a50513          	addi	a0,a0,1066 # 80008488 <etext+0x488>
    80003066:	00003097          	auipc	ra,0x3
    8000306a:	d06080e7          	jalr	-762(ra) # 80005d6c <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000306e:	24c1                	addiw	s1,s1,16
    80003070:	04c92783          	lw	a5,76(s2)
    80003074:	04f4f463          	bgeu	s1,a5,800030bc <dirlookup+0xa8>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003078:	874e                	mv	a4,s3
    8000307a:	86a6                	mv	a3,s1
    8000307c:	8652                	mv	a2,s4
    8000307e:	4581                	li	a1,0
    80003080:	854a                	mv	a0,s2
    80003082:	00000097          	auipc	ra,0x0
    80003086:	d5e080e7          	jalr	-674(ra) # 80002de0 <readi>
    8000308a:	fd351ae3          	bne	a0,s3,8000305e <dirlookup+0x4a>
    if(de.inum == 0)
    8000308e:	fa045783          	lhu	a5,-96(s0)
    80003092:	dff1                	beqz	a5,8000306e <dirlookup+0x5a>
    if(namecmp(name, de.name) == 0){
    80003094:	85da                	mv	a1,s6
    80003096:	8556                	mv	a0,s5
    80003098:	00000097          	auipc	ra,0x0
    8000309c:	f62080e7          	jalr	-158(ra) # 80002ffa <namecmp>
    800030a0:	f579                	bnez	a0,8000306e <dirlookup+0x5a>
      if(poff)
    800030a2:	000b8463          	beqz	s7,800030aa <dirlookup+0x96>
        *poff = off;
    800030a6:	009ba023          	sw	s1,0(s7)
      return iget(dp->dev, inum);
    800030aa:	fa045583          	lhu	a1,-96(s0)
    800030ae:	00092503          	lw	a0,0(s2)
    800030b2:	fffff097          	auipc	ra,0xfffff
    800030b6:	742080e7          	jalr	1858(ra) # 800027f4 <iget>
    800030ba:	a011                	j	800030be <dirlookup+0xaa>
  return 0;
    800030bc:	4501                	li	a0,0
}
    800030be:	60e6                	ld	ra,88(sp)
    800030c0:	6446                	ld	s0,80(sp)
    800030c2:	64a6                	ld	s1,72(sp)
    800030c4:	6906                	ld	s2,64(sp)
    800030c6:	79e2                	ld	s3,56(sp)
    800030c8:	7a42                	ld	s4,48(sp)
    800030ca:	7aa2                	ld	s5,40(sp)
    800030cc:	7b02                	ld	s6,32(sp)
    800030ce:	6be2                	ld	s7,24(sp)
    800030d0:	6125                	addi	sp,sp,96
    800030d2:	8082                	ret

00000000800030d4 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800030d4:	711d                	addi	sp,sp,-96
    800030d6:	ec86                	sd	ra,88(sp)
    800030d8:	e8a2                	sd	s0,80(sp)
    800030da:	e4a6                	sd	s1,72(sp)
    800030dc:	e0ca                	sd	s2,64(sp)
    800030de:	fc4e                	sd	s3,56(sp)
    800030e0:	f852                	sd	s4,48(sp)
    800030e2:	f456                	sd	s5,40(sp)
    800030e4:	f05a                	sd	s6,32(sp)
    800030e6:	ec5e                	sd	s7,24(sp)
    800030e8:	e862                	sd	s8,16(sp)
    800030ea:	e466                	sd	s9,8(sp)
    800030ec:	e06a                	sd	s10,0(sp)
    800030ee:	1080                	addi	s0,sp,96
    800030f0:	84aa                	mv	s1,a0
    800030f2:	8b2e                	mv	s6,a1
    800030f4:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800030f6:	00054703          	lbu	a4,0(a0)
    800030fa:	02f00793          	li	a5,47
    800030fe:	02f70363          	beq	a4,a5,80003124 <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003102:	ffffe097          	auipc	ra,0xffffe
    80003106:	d94080e7          	jalr	-620(ra) # 80000e96 <myproc>
    8000310a:	15053503          	ld	a0,336(a0)
    8000310e:	00000097          	auipc	ra,0x0
    80003112:	9d8080e7          	jalr	-1576(ra) # 80002ae6 <idup>
    80003116:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003118:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    8000311c:	4c35                	li	s8,13
    memmove(name, s, DIRSIZ);
    8000311e:	4cb9                	li	s9,14

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003120:	4b85                	li	s7,1
    80003122:	a87d                	j	800031e0 <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    80003124:	4585                	li	a1,1
    80003126:	852e                	mv	a0,a1
    80003128:	fffff097          	auipc	ra,0xfffff
    8000312c:	6cc080e7          	jalr	1740(ra) # 800027f4 <iget>
    80003130:	8a2a                	mv	s4,a0
    80003132:	b7dd                	j	80003118 <namex+0x44>
      iunlockput(ip);
    80003134:	8552                	mv	a0,s4
    80003136:	00000097          	auipc	ra,0x0
    8000313a:	c54080e7          	jalr	-940(ra) # 80002d8a <iunlockput>
      return 0;
    8000313e:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003140:	8552                	mv	a0,s4
    80003142:	60e6                	ld	ra,88(sp)
    80003144:	6446                	ld	s0,80(sp)
    80003146:	64a6                	ld	s1,72(sp)
    80003148:	6906                	ld	s2,64(sp)
    8000314a:	79e2                	ld	s3,56(sp)
    8000314c:	7a42                	ld	s4,48(sp)
    8000314e:	7aa2                	ld	s5,40(sp)
    80003150:	7b02                	ld	s6,32(sp)
    80003152:	6be2                	ld	s7,24(sp)
    80003154:	6c42                	ld	s8,16(sp)
    80003156:	6ca2                	ld	s9,8(sp)
    80003158:	6d02                	ld	s10,0(sp)
    8000315a:	6125                	addi	sp,sp,96
    8000315c:	8082                	ret
      iunlock(ip);
    8000315e:	8552                	mv	a0,s4
    80003160:	00000097          	auipc	ra,0x0
    80003164:	a8a080e7          	jalr	-1398(ra) # 80002bea <iunlock>
      return ip;
    80003168:	bfe1                	j	80003140 <namex+0x6c>
      iunlockput(ip);
    8000316a:	8552                	mv	a0,s4
    8000316c:	00000097          	auipc	ra,0x0
    80003170:	c1e080e7          	jalr	-994(ra) # 80002d8a <iunlockput>
      return 0;
    80003174:	8a4e                	mv	s4,s3
    80003176:	b7e9                	j	80003140 <namex+0x6c>
  len = path - s;
    80003178:	40998633          	sub	a2,s3,s1
    8000317c:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    80003180:	09ac5863          	bge	s8,s10,80003210 <namex+0x13c>
    memmove(name, s, DIRSIZ);
    80003184:	8666                	mv	a2,s9
    80003186:	85a6                	mv	a1,s1
    80003188:	8556                	mv	a0,s5
    8000318a:	ffffd097          	auipc	ra,0xffffd
    8000318e:	054080e7          	jalr	84(ra) # 800001de <memmove>
    80003192:	84ce                	mv	s1,s3
  while(*path == '/')
    80003194:	0004c783          	lbu	a5,0(s1)
    80003198:	01279763          	bne	a5,s2,800031a6 <namex+0xd2>
    path++;
    8000319c:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000319e:	0004c783          	lbu	a5,0(s1)
    800031a2:	ff278de3          	beq	a5,s2,8000319c <namex+0xc8>
    ilock(ip);
    800031a6:	8552                	mv	a0,s4
    800031a8:	00000097          	auipc	ra,0x0
    800031ac:	97c080e7          	jalr	-1668(ra) # 80002b24 <ilock>
    if(ip->type != T_DIR){
    800031b0:	044a1783          	lh	a5,68(s4)
    800031b4:	f97790e3          	bne	a5,s7,80003134 <namex+0x60>
    if(nameiparent && *path == '\0'){
    800031b8:	000b0563          	beqz	s6,800031c2 <namex+0xee>
    800031bc:	0004c783          	lbu	a5,0(s1)
    800031c0:	dfd9                	beqz	a5,8000315e <namex+0x8a>
    if((next = dirlookup(ip, name, 0)) == 0){
    800031c2:	4601                	li	a2,0
    800031c4:	85d6                	mv	a1,s5
    800031c6:	8552                	mv	a0,s4
    800031c8:	00000097          	auipc	ra,0x0
    800031cc:	e4c080e7          	jalr	-436(ra) # 80003014 <dirlookup>
    800031d0:	89aa                	mv	s3,a0
    800031d2:	dd41                	beqz	a0,8000316a <namex+0x96>
    iunlockput(ip);
    800031d4:	8552                	mv	a0,s4
    800031d6:	00000097          	auipc	ra,0x0
    800031da:	bb4080e7          	jalr	-1100(ra) # 80002d8a <iunlockput>
    ip = next;
    800031de:	8a4e                	mv	s4,s3
  while(*path == '/')
    800031e0:	0004c783          	lbu	a5,0(s1)
    800031e4:	01279763          	bne	a5,s2,800031f2 <namex+0x11e>
    path++;
    800031e8:	0485                	addi	s1,s1,1
  while(*path == '/')
    800031ea:	0004c783          	lbu	a5,0(s1)
    800031ee:	ff278de3          	beq	a5,s2,800031e8 <namex+0x114>
  if(*path == 0)
    800031f2:	cb9d                	beqz	a5,80003228 <namex+0x154>
  while(*path != '/' && *path != 0)
    800031f4:	0004c783          	lbu	a5,0(s1)
    800031f8:	89a6                	mv	s3,s1
  len = path - s;
    800031fa:	4d01                	li	s10,0
    800031fc:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    800031fe:	01278963          	beq	a5,s2,80003210 <namex+0x13c>
    80003202:	dbbd                	beqz	a5,80003178 <namex+0xa4>
    path++;
    80003204:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80003206:	0009c783          	lbu	a5,0(s3)
    8000320a:	ff279ce3          	bne	a5,s2,80003202 <namex+0x12e>
    8000320e:	b7ad                	j	80003178 <namex+0xa4>
    memmove(name, s, len);
    80003210:	2601                	sext.w	a2,a2
    80003212:	85a6                	mv	a1,s1
    80003214:	8556                	mv	a0,s5
    80003216:	ffffd097          	auipc	ra,0xffffd
    8000321a:	fc8080e7          	jalr	-56(ra) # 800001de <memmove>
    name[len] = 0;
    8000321e:	9d56                	add	s10,s10,s5
    80003220:	000d0023          	sb	zero,0(s10)
    80003224:	84ce                	mv	s1,s3
    80003226:	b7bd                	j	80003194 <namex+0xc0>
  if(nameiparent){
    80003228:	f00b0ce3          	beqz	s6,80003140 <namex+0x6c>
    iput(ip);
    8000322c:	8552                	mv	a0,s4
    8000322e:	00000097          	auipc	ra,0x0
    80003232:	ab4080e7          	jalr	-1356(ra) # 80002ce2 <iput>
    return 0;
    80003236:	4a01                	li	s4,0
    80003238:	b721                	j	80003140 <namex+0x6c>

000000008000323a <dirlink>:
{
    8000323a:	715d                	addi	sp,sp,-80
    8000323c:	e486                	sd	ra,72(sp)
    8000323e:	e0a2                	sd	s0,64(sp)
    80003240:	f84a                	sd	s2,48(sp)
    80003242:	ec56                	sd	s5,24(sp)
    80003244:	e85a                	sd	s6,16(sp)
    80003246:	0880                	addi	s0,sp,80
    80003248:	892a                	mv	s2,a0
    8000324a:	8aae                	mv	s5,a1
    8000324c:	8b32                	mv	s6,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    8000324e:	4601                	li	a2,0
    80003250:	00000097          	auipc	ra,0x0
    80003254:	dc4080e7          	jalr	-572(ra) # 80003014 <dirlookup>
    80003258:	e129                	bnez	a0,8000329a <dirlink+0x60>
    8000325a:	fc26                	sd	s1,56(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000325c:	04c92483          	lw	s1,76(s2)
    80003260:	cca9                	beqz	s1,800032ba <dirlink+0x80>
    80003262:	f44e                	sd	s3,40(sp)
    80003264:	f052                	sd	s4,32(sp)
    80003266:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003268:	fb040a13          	addi	s4,s0,-80
    8000326c:	49c1                	li	s3,16
    8000326e:	874e                	mv	a4,s3
    80003270:	86a6                	mv	a3,s1
    80003272:	8652                	mv	a2,s4
    80003274:	4581                	li	a1,0
    80003276:	854a                	mv	a0,s2
    80003278:	00000097          	auipc	ra,0x0
    8000327c:	b68080e7          	jalr	-1176(ra) # 80002de0 <readi>
    80003280:	03351363          	bne	a0,s3,800032a6 <dirlink+0x6c>
    if(de.inum == 0)
    80003284:	fb045783          	lhu	a5,-80(s0)
    80003288:	c79d                	beqz	a5,800032b6 <dirlink+0x7c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000328a:	24c1                	addiw	s1,s1,16
    8000328c:	04c92783          	lw	a5,76(s2)
    80003290:	fcf4efe3          	bltu	s1,a5,8000326e <dirlink+0x34>
    80003294:	79a2                	ld	s3,40(sp)
    80003296:	7a02                	ld	s4,32(sp)
    80003298:	a00d                	j	800032ba <dirlink+0x80>
    iput(ip);
    8000329a:	00000097          	auipc	ra,0x0
    8000329e:	a48080e7          	jalr	-1464(ra) # 80002ce2 <iput>
    return -1;
    800032a2:	557d                	li	a0,-1
    800032a4:	a0a9                	j	800032ee <dirlink+0xb4>
      panic("dirlink read");
    800032a6:	00005517          	auipc	a0,0x5
    800032aa:	1f250513          	addi	a0,a0,498 # 80008498 <etext+0x498>
    800032ae:	00003097          	auipc	ra,0x3
    800032b2:	abe080e7          	jalr	-1346(ra) # 80005d6c <panic>
    800032b6:	79a2                	ld	s3,40(sp)
    800032b8:	7a02                	ld	s4,32(sp)
  strncpy(de.name, name, DIRSIZ);
    800032ba:	4639                	li	a2,14
    800032bc:	85d6                	mv	a1,s5
    800032be:	fb240513          	addi	a0,s0,-78
    800032c2:	ffffd097          	auipc	ra,0xffffd
    800032c6:	fce080e7          	jalr	-50(ra) # 80000290 <strncpy>
  de.inum = inum;
    800032ca:	fb641823          	sh	s6,-80(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800032ce:	4741                	li	a4,16
    800032d0:	86a6                	mv	a3,s1
    800032d2:	fb040613          	addi	a2,s0,-80
    800032d6:	4581                	li	a1,0
    800032d8:	854a                	mv	a0,s2
    800032da:	00000097          	auipc	ra,0x0
    800032de:	c00080e7          	jalr	-1024(ra) # 80002eda <writei>
    800032e2:	872a                	mv	a4,a0
    800032e4:	47c1                	li	a5,16
  return 0;
    800032e6:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800032e8:	00f71a63          	bne	a4,a5,800032fc <dirlink+0xc2>
    800032ec:	74e2                	ld	s1,56(sp)
}
    800032ee:	60a6                	ld	ra,72(sp)
    800032f0:	6406                	ld	s0,64(sp)
    800032f2:	7942                	ld	s2,48(sp)
    800032f4:	6ae2                	ld	s5,24(sp)
    800032f6:	6b42                	ld	s6,16(sp)
    800032f8:	6161                	addi	sp,sp,80
    800032fa:	8082                	ret
    800032fc:	f44e                	sd	s3,40(sp)
    800032fe:	f052                	sd	s4,32(sp)
    panic("dirlink");
    80003300:	00005517          	auipc	a0,0x5
    80003304:	2a850513          	addi	a0,a0,680 # 800085a8 <etext+0x5a8>
    80003308:	00003097          	auipc	ra,0x3
    8000330c:	a64080e7          	jalr	-1436(ra) # 80005d6c <panic>

0000000080003310 <namei>:

struct inode*
namei(char *path)
{
    80003310:	1101                	addi	sp,sp,-32
    80003312:	ec06                	sd	ra,24(sp)
    80003314:	e822                	sd	s0,16(sp)
    80003316:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003318:	fe040613          	addi	a2,s0,-32
    8000331c:	4581                	li	a1,0
    8000331e:	00000097          	auipc	ra,0x0
    80003322:	db6080e7          	jalr	-586(ra) # 800030d4 <namex>
}
    80003326:	60e2                	ld	ra,24(sp)
    80003328:	6442                	ld	s0,16(sp)
    8000332a:	6105                	addi	sp,sp,32
    8000332c:	8082                	ret

000000008000332e <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    8000332e:	1141                	addi	sp,sp,-16
    80003330:	e406                	sd	ra,8(sp)
    80003332:	e022                	sd	s0,0(sp)
    80003334:	0800                	addi	s0,sp,16
    80003336:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003338:	4585                	li	a1,1
    8000333a:	00000097          	auipc	ra,0x0
    8000333e:	d9a080e7          	jalr	-614(ra) # 800030d4 <namex>
}
    80003342:	60a2                	ld	ra,8(sp)
    80003344:	6402                	ld	s0,0(sp)
    80003346:	0141                	addi	sp,sp,16
    80003348:	8082                	ret

000000008000334a <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    8000334a:	1101                	addi	sp,sp,-32
    8000334c:	ec06                	sd	ra,24(sp)
    8000334e:	e822                	sd	s0,16(sp)
    80003350:	e426                	sd	s1,8(sp)
    80003352:	e04a                	sd	s2,0(sp)
    80003354:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003356:	00016917          	auipc	s2,0x16
    8000335a:	2ca90913          	addi	s2,s2,714 # 80019620 <log>
    8000335e:	01892583          	lw	a1,24(s2)
    80003362:	02892503          	lw	a0,40(s2)
    80003366:	fffff097          	auipc	ra,0xfffff
    8000336a:	fe2080e7          	jalr	-30(ra) # 80002348 <bread>
    8000336e:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003370:	02c92603          	lw	a2,44(s2)
    80003374:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003376:	00c05f63          	blez	a2,80003394 <write_head+0x4a>
    8000337a:	00016717          	auipc	a4,0x16
    8000337e:	2d670713          	addi	a4,a4,726 # 80019650 <log+0x30>
    80003382:	87aa                	mv	a5,a0
    80003384:	060a                	slli	a2,a2,0x2
    80003386:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003388:	4314                	lw	a3,0(a4)
    8000338a:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    8000338c:	0711                	addi	a4,a4,4
    8000338e:	0791                	addi	a5,a5,4
    80003390:	fec79ce3          	bne	a5,a2,80003388 <write_head+0x3e>
  }
  bwrite(buf);
    80003394:	8526                	mv	a0,s1
    80003396:	fffff097          	auipc	ra,0xfffff
    8000339a:	0a4080e7          	jalr	164(ra) # 8000243a <bwrite>
  brelse(buf);
    8000339e:	8526                	mv	a0,s1
    800033a0:	fffff097          	auipc	ra,0xfffff
    800033a4:	0d8080e7          	jalr	216(ra) # 80002478 <brelse>
}
    800033a8:	60e2                	ld	ra,24(sp)
    800033aa:	6442                	ld	s0,16(sp)
    800033ac:	64a2                	ld	s1,8(sp)
    800033ae:	6902                	ld	s2,0(sp)
    800033b0:	6105                	addi	sp,sp,32
    800033b2:	8082                	ret

00000000800033b4 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800033b4:	00016797          	auipc	a5,0x16
    800033b8:	2987a783          	lw	a5,664(a5) # 8001964c <log+0x2c>
    800033bc:	0cf05063          	blez	a5,8000347c <install_trans+0xc8>
{
    800033c0:	715d                	addi	sp,sp,-80
    800033c2:	e486                	sd	ra,72(sp)
    800033c4:	e0a2                	sd	s0,64(sp)
    800033c6:	fc26                	sd	s1,56(sp)
    800033c8:	f84a                	sd	s2,48(sp)
    800033ca:	f44e                	sd	s3,40(sp)
    800033cc:	f052                	sd	s4,32(sp)
    800033ce:	ec56                	sd	s5,24(sp)
    800033d0:	e85a                	sd	s6,16(sp)
    800033d2:	e45e                	sd	s7,8(sp)
    800033d4:	0880                	addi	s0,sp,80
    800033d6:	8b2a                	mv	s6,a0
    800033d8:	00016a97          	auipc	s5,0x16
    800033dc:	278a8a93          	addi	s5,s5,632 # 80019650 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800033e0:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800033e2:	00016997          	auipc	s3,0x16
    800033e6:	23e98993          	addi	s3,s3,574 # 80019620 <log>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800033ea:	40000b93          	li	s7,1024
    800033ee:	a00d                	j	80003410 <install_trans+0x5c>
    brelse(lbuf);
    800033f0:	854a                	mv	a0,s2
    800033f2:	fffff097          	auipc	ra,0xfffff
    800033f6:	086080e7          	jalr	134(ra) # 80002478 <brelse>
    brelse(dbuf);
    800033fa:	8526                	mv	a0,s1
    800033fc:	fffff097          	auipc	ra,0xfffff
    80003400:	07c080e7          	jalr	124(ra) # 80002478 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003404:	2a05                	addiw	s4,s4,1
    80003406:	0a91                	addi	s5,s5,4
    80003408:	02c9a783          	lw	a5,44(s3)
    8000340c:	04fa5d63          	bge	s4,a5,80003466 <install_trans+0xb2>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003410:	0189a583          	lw	a1,24(s3)
    80003414:	014585bb          	addw	a1,a1,s4
    80003418:	2585                	addiw	a1,a1,1
    8000341a:	0289a503          	lw	a0,40(s3)
    8000341e:	fffff097          	auipc	ra,0xfffff
    80003422:	f2a080e7          	jalr	-214(ra) # 80002348 <bread>
    80003426:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003428:	000aa583          	lw	a1,0(s5)
    8000342c:	0289a503          	lw	a0,40(s3)
    80003430:	fffff097          	auipc	ra,0xfffff
    80003434:	f18080e7          	jalr	-232(ra) # 80002348 <bread>
    80003438:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000343a:	865e                	mv	a2,s7
    8000343c:	05890593          	addi	a1,s2,88
    80003440:	05850513          	addi	a0,a0,88
    80003444:	ffffd097          	auipc	ra,0xffffd
    80003448:	d9a080e7          	jalr	-614(ra) # 800001de <memmove>
    bwrite(dbuf);  // write dst to disk
    8000344c:	8526                	mv	a0,s1
    8000344e:	fffff097          	auipc	ra,0xfffff
    80003452:	fec080e7          	jalr	-20(ra) # 8000243a <bwrite>
    if(recovering == 0)
    80003456:	f80b1de3          	bnez	s6,800033f0 <install_trans+0x3c>
      bunpin(dbuf);
    8000345a:	8526                	mv	a0,s1
    8000345c:	fffff097          	auipc	ra,0xfffff
    80003460:	0f0080e7          	jalr	240(ra) # 8000254c <bunpin>
    80003464:	b771                	j	800033f0 <install_trans+0x3c>
}
    80003466:	60a6                	ld	ra,72(sp)
    80003468:	6406                	ld	s0,64(sp)
    8000346a:	74e2                	ld	s1,56(sp)
    8000346c:	7942                	ld	s2,48(sp)
    8000346e:	79a2                	ld	s3,40(sp)
    80003470:	7a02                	ld	s4,32(sp)
    80003472:	6ae2                	ld	s5,24(sp)
    80003474:	6b42                	ld	s6,16(sp)
    80003476:	6ba2                	ld	s7,8(sp)
    80003478:	6161                	addi	sp,sp,80
    8000347a:	8082                	ret
    8000347c:	8082                	ret

000000008000347e <initlog>:
{
    8000347e:	7179                	addi	sp,sp,-48
    80003480:	f406                	sd	ra,40(sp)
    80003482:	f022                	sd	s0,32(sp)
    80003484:	ec26                	sd	s1,24(sp)
    80003486:	e84a                	sd	s2,16(sp)
    80003488:	e44e                	sd	s3,8(sp)
    8000348a:	1800                	addi	s0,sp,48
    8000348c:	892a                	mv	s2,a0
    8000348e:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003490:	00016497          	auipc	s1,0x16
    80003494:	19048493          	addi	s1,s1,400 # 80019620 <log>
    80003498:	00005597          	auipc	a1,0x5
    8000349c:	01058593          	addi	a1,a1,16 # 800084a8 <etext+0x4a8>
    800034a0:	8526                	mv	a0,s1
    800034a2:	00003097          	auipc	ra,0x3
    800034a6:	d8c080e7          	jalr	-628(ra) # 8000622e <initlock>
  log.start = sb->logstart;
    800034aa:	0149a583          	lw	a1,20(s3)
    800034ae:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800034b0:	0109a783          	lw	a5,16(s3)
    800034b4:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800034b6:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800034ba:	854a                	mv	a0,s2
    800034bc:	fffff097          	auipc	ra,0xfffff
    800034c0:	e8c080e7          	jalr	-372(ra) # 80002348 <bread>
  log.lh.n = lh->n;
    800034c4:	4d30                	lw	a2,88(a0)
    800034c6:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800034c8:	00c05f63          	blez	a2,800034e6 <initlog+0x68>
    800034cc:	87aa                	mv	a5,a0
    800034ce:	00016717          	auipc	a4,0x16
    800034d2:	18270713          	addi	a4,a4,386 # 80019650 <log+0x30>
    800034d6:	060a                	slli	a2,a2,0x2
    800034d8:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    800034da:	4ff4                	lw	a3,92(a5)
    800034dc:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800034de:	0791                	addi	a5,a5,4
    800034e0:	0711                	addi	a4,a4,4
    800034e2:	fec79ce3          	bne	a5,a2,800034da <initlog+0x5c>
  brelse(buf);
    800034e6:	fffff097          	auipc	ra,0xfffff
    800034ea:	f92080e7          	jalr	-110(ra) # 80002478 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800034ee:	4505                	li	a0,1
    800034f0:	00000097          	auipc	ra,0x0
    800034f4:	ec4080e7          	jalr	-316(ra) # 800033b4 <install_trans>
  log.lh.n = 0;
    800034f8:	00016797          	auipc	a5,0x16
    800034fc:	1407aa23          	sw	zero,340(a5) # 8001964c <log+0x2c>
  write_head(); // clear the log
    80003500:	00000097          	auipc	ra,0x0
    80003504:	e4a080e7          	jalr	-438(ra) # 8000334a <write_head>
}
    80003508:	70a2                	ld	ra,40(sp)
    8000350a:	7402                	ld	s0,32(sp)
    8000350c:	64e2                	ld	s1,24(sp)
    8000350e:	6942                	ld	s2,16(sp)
    80003510:	69a2                	ld	s3,8(sp)
    80003512:	6145                	addi	sp,sp,48
    80003514:	8082                	ret

0000000080003516 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003516:	1101                	addi	sp,sp,-32
    80003518:	ec06                	sd	ra,24(sp)
    8000351a:	e822                	sd	s0,16(sp)
    8000351c:	e426                	sd	s1,8(sp)
    8000351e:	e04a                	sd	s2,0(sp)
    80003520:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003522:	00016517          	auipc	a0,0x16
    80003526:	0fe50513          	addi	a0,a0,254 # 80019620 <log>
    8000352a:	00003097          	auipc	ra,0x3
    8000352e:	d98080e7          	jalr	-616(ra) # 800062c2 <acquire>
  while(1){
    if(log.committing){
    80003532:	00016497          	auipc	s1,0x16
    80003536:	0ee48493          	addi	s1,s1,238 # 80019620 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000353a:	4979                	li	s2,30
    8000353c:	a039                	j	8000354a <begin_op+0x34>
      sleep(&log, &log.lock);
    8000353e:	85a6                	mv	a1,s1
    80003540:	8526                	mv	a0,s1
    80003542:	ffffe097          	auipc	ra,0xffffe
    80003546:	026080e7          	jalr	38(ra) # 80001568 <sleep>
    if(log.committing){
    8000354a:	50dc                	lw	a5,36(s1)
    8000354c:	fbed                	bnez	a5,8000353e <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000354e:	5098                	lw	a4,32(s1)
    80003550:	2705                	addiw	a4,a4,1
    80003552:	0027179b          	slliw	a5,a4,0x2
    80003556:	9fb9                	addw	a5,a5,a4
    80003558:	0017979b          	slliw	a5,a5,0x1
    8000355c:	54d4                	lw	a3,44(s1)
    8000355e:	9fb5                	addw	a5,a5,a3
    80003560:	00f95963          	bge	s2,a5,80003572 <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003564:	85a6                	mv	a1,s1
    80003566:	8526                	mv	a0,s1
    80003568:	ffffe097          	auipc	ra,0xffffe
    8000356c:	000080e7          	jalr	ra # 80001568 <sleep>
    80003570:	bfe9                	j	8000354a <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003572:	00016517          	auipc	a0,0x16
    80003576:	0ae50513          	addi	a0,a0,174 # 80019620 <log>
    8000357a:	d118                	sw	a4,32(a0)
      release(&log.lock);
    8000357c:	00003097          	auipc	ra,0x3
    80003580:	df6080e7          	jalr	-522(ra) # 80006372 <release>
      break;
    }
  }
}
    80003584:	60e2                	ld	ra,24(sp)
    80003586:	6442                	ld	s0,16(sp)
    80003588:	64a2                	ld	s1,8(sp)
    8000358a:	6902                	ld	s2,0(sp)
    8000358c:	6105                	addi	sp,sp,32
    8000358e:	8082                	ret

0000000080003590 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003590:	7139                	addi	sp,sp,-64
    80003592:	fc06                	sd	ra,56(sp)
    80003594:	f822                	sd	s0,48(sp)
    80003596:	f426                	sd	s1,40(sp)
    80003598:	f04a                	sd	s2,32(sp)
    8000359a:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000359c:	00016497          	auipc	s1,0x16
    800035a0:	08448493          	addi	s1,s1,132 # 80019620 <log>
    800035a4:	8526                	mv	a0,s1
    800035a6:	00003097          	auipc	ra,0x3
    800035aa:	d1c080e7          	jalr	-740(ra) # 800062c2 <acquire>
  log.outstanding -= 1;
    800035ae:	509c                	lw	a5,32(s1)
    800035b0:	37fd                	addiw	a5,a5,-1
    800035b2:	893e                	mv	s2,a5
    800035b4:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800035b6:	50dc                	lw	a5,36(s1)
    800035b8:	e7b9                	bnez	a5,80003606 <end_op+0x76>
    panic("log.committing");
  if(log.outstanding == 0){
    800035ba:	06091263          	bnez	s2,8000361e <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    800035be:	00016497          	auipc	s1,0x16
    800035c2:	06248493          	addi	s1,s1,98 # 80019620 <log>
    800035c6:	4785                	li	a5,1
    800035c8:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800035ca:	8526                	mv	a0,s1
    800035cc:	00003097          	auipc	ra,0x3
    800035d0:	da6080e7          	jalr	-602(ra) # 80006372 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800035d4:	54dc                	lw	a5,44(s1)
    800035d6:	06f04863          	bgtz	a5,80003646 <end_op+0xb6>
    acquire(&log.lock);
    800035da:	00016497          	auipc	s1,0x16
    800035de:	04648493          	addi	s1,s1,70 # 80019620 <log>
    800035e2:	8526                	mv	a0,s1
    800035e4:	00003097          	auipc	ra,0x3
    800035e8:	cde080e7          	jalr	-802(ra) # 800062c2 <acquire>
    log.committing = 0;
    800035ec:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800035f0:	8526                	mv	a0,s1
    800035f2:	ffffe097          	auipc	ra,0xffffe
    800035f6:	0fc080e7          	jalr	252(ra) # 800016ee <wakeup>
    release(&log.lock);
    800035fa:	8526                	mv	a0,s1
    800035fc:	00003097          	auipc	ra,0x3
    80003600:	d76080e7          	jalr	-650(ra) # 80006372 <release>
}
    80003604:	a81d                	j	8000363a <end_op+0xaa>
    80003606:	ec4e                	sd	s3,24(sp)
    80003608:	e852                	sd	s4,16(sp)
    8000360a:	e456                	sd	s5,8(sp)
    8000360c:	e05a                	sd	s6,0(sp)
    panic("log.committing");
    8000360e:	00005517          	auipc	a0,0x5
    80003612:	ea250513          	addi	a0,a0,-350 # 800084b0 <etext+0x4b0>
    80003616:	00002097          	auipc	ra,0x2
    8000361a:	756080e7          	jalr	1878(ra) # 80005d6c <panic>
    wakeup(&log);
    8000361e:	00016497          	auipc	s1,0x16
    80003622:	00248493          	addi	s1,s1,2 # 80019620 <log>
    80003626:	8526                	mv	a0,s1
    80003628:	ffffe097          	auipc	ra,0xffffe
    8000362c:	0c6080e7          	jalr	198(ra) # 800016ee <wakeup>
  release(&log.lock);
    80003630:	8526                	mv	a0,s1
    80003632:	00003097          	auipc	ra,0x3
    80003636:	d40080e7          	jalr	-704(ra) # 80006372 <release>
}
    8000363a:	70e2                	ld	ra,56(sp)
    8000363c:	7442                	ld	s0,48(sp)
    8000363e:	74a2                	ld	s1,40(sp)
    80003640:	7902                	ld	s2,32(sp)
    80003642:	6121                	addi	sp,sp,64
    80003644:	8082                	ret
    80003646:	ec4e                	sd	s3,24(sp)
    80003648:	e852                	sd	s4,16(sp)
    8000364a:	e456                	sd	s5,8(sp)
    8000364c:	e05a                	sd	s6,0(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    8000364e:	00016a97          	auipc	s5,0x16
    80003652:	002a8a93          	addi	s5,s5,2 # 80019650 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003656:	00016a17          	auipc	s4,0x16
    8000365a:	fcaa0a13          	addi	s4,s4,-54 # 80019620 <log>
    memmove(to->data, from->data, BSIZE);
    8000365e:	40000b13          	li	s6,1024
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003662:	018a2583          	lw	a1,24(s4)
    80003666:	012585bb          	addw	a1,a1,s2
    8000366a:	2585                	addiw	a1,a1,1
    8000366c:	028a2503          	lw	a0,40(s4)
    80003670:	fffff097          	auipc	ra,0xfffff
    80003674:	cd8080e7          	jalr	-808(ra) # 80002348 <bread>
    80003678:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000367a:	000aa583          	lw	a1,0(s5)
    8000367e:	028a2503          	lw	a0,40(s4)
    80003682:	fffff097          	auipc	ra,0xfffff
    80003686:	cc6080e7          	jalr	-826(ra) # 80002348 <bread>
    8000368a:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000368c:	865a                	mv	a2,s6
    8000368e:	05850593          	addi	a1,a0,88
    80003692:	05848513          	addi	a0,s1,88
    80003696:	ffffd097          	auipc	ra,0xffffd
    8000369a:	b48080e7          	jalr	-1208(ra) # 800001de <memmove>
    bwrite(to);  // write the log
    8000369e:	8526                	mv	a0,s1
    800036a0:	fffff097          	auipc	ra,0xfffff
    800036a4:	d9a080e7          	jalr	-614(ra) # 8000243a <bwrite>
    brelse(from);
    800036a8:	854e                	mv	a0,s3
    800036aa:	fffff097          	auipc	ra,0xfffff
    800036ae:	dce080e7          	jalr	-562(ra) # 80002478 <brelse>
    brelse(to);
    800036b2:	8526                	mv	a0,s1
    800036b4:	fffff097          	auipc	ra,0xfffff
    800036b8:	dc4080e7          	jalr	-572(ra) # 80002478 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800036bc:	2905                	addiw	s2,s2,1
    800036be:	0a91                	addi	s5,s5,4
    800036c0:	02ca2783          	lw	a5,44(s4)
    800036c4:	f8f94fe3          	blt	s2,a5,80003662 <end_op+0xd2>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800036c8:	00000097          	auipc	ra,0x0
    800036cc:	c82080e7          	jalr	-894(ra) # 8000334a <write_head>
    install_trans(0); // Now install writes to home locations
    800036d0:	4501                	li	a0,0
    800036d2:	00000097          	auipc	ra,0x0
    800036d6:	ce2080e7          	jalr	-798(ra) # 800033b4 <install_trans>
    log.lh.n = 0;
    800036da:	00016797          	auipc	a5,0x16
    800036de:	f607a923          	sw	zero,-142(a5) # 8001964c <log+0x2c>
    write_head();    // Erase the transaction from the log
    800036e2:	00000097          	auipc	ra,0x0
    800036e6:	c68080e7          	jalr	-920(ra) # 8000334a <write_head>
    800036ea:	69e2                	ld	s3,24(sp)
    800036ec:	6a42                	ld	s4,16(sp)
    800036ee:	6aa2                	ld	s5,8(sp)
    800036f0:	6b02                	ld	s6,0(sp)
    800036f2:	b5e5                	j	800035da <end_op+0x4a>

00000000800036f4 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800036f4:	1101                	addi	sp,sp,-32
    800036f6:	ec06                	sd	ra,24(sp)
    800036f8:	e822                	sd	s0,16(sp)
    800036fa:	e426                	sd	s1,8(sp)
    800036fc:	e04a                	sd	s2,0(sp)
    800036fe:	1000                	addi	s0,sp,32
    80003700:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003702:	00016917          	auipc	s2,0x16
    80003706:	f1e90913          	addi	s2,s2,-226 # 80019620 <log>
    8000370a:	854a                	mv	a0,s2
    8000370c:	00003097          	auipc	ra,0x3
    80003710:	bb6080e7          	jalr	-1098(ra) # 800062c2 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003714:	02c92603          	lw	a2,44(s2)
    80003718:	47f5                	li	a5,29
    8000371a:	06c7c563          	blt	a5,a2,80003784 <log_write+0x90>
    8000371e:	00016797          	auipc	a5,0x16
    80003722:	f1e7a783          	lw	a5,-226(a5) # 8001963c <log+0x1c>
    80003726:	37fd                	addiw	a5,a5,-1
    80003728:	04f65e63          	bge	a2,a5,80003784 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000372c:	00016797          	auipc	a5,0x16
    80003730:	f147a783          	lw	a5,-236(a5) # 80019640 <log+0x20>
    80003734:	06f05063          	blez	a5,80003794 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003738:	4781                	li	a5,0
    8000373a:	06c05563          	blez	a2,800037a4 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000373e:	44cc                	lw	a1,12(s1)
    80003740:	00016717          	auipc	a4,0x16
    80003744:	f1070713          	addi	a4,a4,-240 # 80019650 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003748:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000374a:	4314                	lw	a3,0(a4)
    8000374c:	04b68c63          	beq	a3,a1,800037a4 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003750:	2785                	addiw	a5,a5,1
    80003752:	0711                	addi	a4,a4,4
    80003754:	fef61be3          	bne	a2,a5,8000374a <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003758:	0621                	addi	a2,a2,8
    8000375a:	060a                	slli	a2,a2,0x2
    8000375c:	00016797          	auipc	a5,0x16
    80003760:	ec478793          	addi	a5,a5,-316 # 80019620 <log>
    80003764:	97b2                	add	a5,a5,a2
    80003766:	44d8                	lw	a4,12(s1)
    80003768:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    8000376a:	8526                	mv	a0,s1
    8000376c:	fffff097          	auipc	ra,0xfffff
    80003770:	da4080e7          	jalr	-604(ra) # 80002510 <bpin>
    log.lh.n++;
    80003774:	00016717          	auipc	a4,0x16
    80003778:	eac70713          	addi	a4,a4,-340 # 80019620 <log>
    8000377c:	575c                	lw	a5,44(a4)
    8000377e:	2785                	addiw	a5,a5,1
    80003780:	d75c                	sw	a5,44(a4)
    80003782:	a82d                	j	800037bc <log_write+0xc8>
    panic("too big a transaction");
    80003784:	00005517          	auipc	a0,0x5
    80003788:	d3c50513          	addi	a0,a0,-708 # 800084c0 <etext+0x4c0>
    8000378c:	00002097          	auipc	ra,0x2
    80003790:	5e0080e7          	jalr	1504(ra) # 80005d6c <panic>
    panic("log_write outside of trans");
    80003794:	00005517          	auipc	a0,0x5
    80003798:	d4450513          	addi	a0,a0,-700 # 800084d8 <etext+0x4d8>
    8000379c:	00002097          	auipc	ra,0x2
    800037a0:	5d0080e7          	jalr	1488(ra) # 80005d6c <panic>
  log.lh.block[i] = b->blockno;
    800037a4:	00878693          	addi	a3,a5,8
    800037a8:	068a                	slli	a3,a3,0x2
    800037aa:	00016717          	auipc	a4,0x16
    800037ae:	e7670713          	addi	a4,a4,-394 # 80019620 <log>
    800037b2:	9736                	add	a4,a4,a3
    800037b4:	44d4                	lw	a3,12(s1)
    800037b6:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800037b8:	faf609e3          	beq	a2,a5,8000376a <log_write+0x76>
  }
  release(&log.lock);
    800037bc:	00016517          	auipc	a0,0x16
    800037c0:	e6450513          	addi	a0,a0,-412 # 80019620 <log>
    800037c4:	00003097          	auipc	ra,0x3
    800037c8:	bae080e7          	jalr	-1106(ra) # 80006372 <release>
}
    800037cc:	60e2                	ld	ra,24(sp)
    800037ce:	6442                	ld	s0,16(sp)
    800037d0:	64a2                	ld	s1,8(sp)
    800037d2:	6902                	ld	s2,0(sp)
    800037d4:	6105                	addi	sp,sp,32
    800037d6:	8082                	ret

00000000800037d8 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800037d8:	1101                	addi	sp,sp,-32
    800037da:	ec06                	sd	ra,24(sp)
    800037dc:	e822                	sd	s0,16(sp)
    800037de:	e426                	sd	s1,8(sp)
    800037e0:	e04a                	sd	s2,0(sp)
    800037e2:	1000                	addi	s0,sp,32
    800037e4:	84aa                	mv	s1,a0
    800037e6:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800037e8:	00005597          	auipc	a1,0x5
    800037ec:	d1058593          	addi	a1,a1,-752 # 800084f8 <etext+0x4f8>
    800037f0:	0521                	addi	a0,a0,8
    800037f2:	00003097          	auipc	ra,0x3
    800037f6:	a3c080e7          	jalr	-1476(ra) # 8000622e <initlock>
  lk->name = name;
    800037fa:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800037fe:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003802:	0204a423          	sw	zero,40(s1)
}
    80003806:	60e2                	ld	ra,24(sp)
    80003808:	6442                	ld	s0,16(sp)
    8000380a:	64a2                	ld	s1,8(sp)
    8000380c:	6902                	ld	s2,0(sp)
    8000380e:	6105                	addi	sp,sp,32
    80003810:	8082                	ret

0000000080003812 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003812:	1101                	addi	sp,sp,-32
    80003814:	ec06                	sd	ra,24(sp)
    80003816:	e822                	sd	s0,16(sp)
    80003818:	e426                	sd	s1,8(sp)
    8000381a:	e04a                	sd	s2,0(sp)
    8000381c:	1000                	addi	s0,sp,32
    8000381e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003820:	00850913          	addi	s2,a0,8
    80003824:	854a                	mv	a0,s2
    80003826:	00003097          	auipc	ra,0x3
    8000382a:	a9c080e7          	jalr	-1380(ra) # 800062c2 <acquire>
  while (lk->locked) {
    8000382e:	409c                	lw	a5,0(s1)
    80003830:	cb89                	beqz	a5,80003842 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003832:	85ca                	mv	a1,s2
    80003834:	8526                	mv	a0,s1
    80003836:	ffffe097          	auipc	ra,0xffffe
    8000383a:	d32080e7          	jalr	-718(ra) # 80001568 <sleep>
  while (lk->locked) {
    8000383e:	409c                	lw	a5,0(s1)
    80003840:	fbed                	bnez	a5,80003832 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003842:	4785                	li	a5,1
    80003844:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003846:	ffffd097          	auipc	ra,0xffffd
    8000384a:	650080e7          	jalr	1616(ra) # 80000e96 <myproc>
    8000384e:	591c                	lw	a5,48(a0)
    80003850:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003852:	854a                	mv	a0,s2
    80003854:	00003097          	auipc	ra,0x3
    80003858:	b1e080e7          	jalr	-1250(ra) # 80006372 <release>
}
    8000385c:	60e2                	ld	ra,24(sp)
    8000385e:	6442                	ld	s0,16(sp)
    80003860:	64a2                	ld	s1,8(sp)
    80003862:	6902                	ld	s2,0(sp)
    80003864:	6105                	addi	sp,sp,32
    80003866:	8082                	ret

0000000080003868 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003868:	1101                	addi	sp,sp,-32
    8000386a:	ec06                	sd	ra,24(sp)
    8000386c:	e822                	sd	s0,16(sp)
    8000386e:	e426                	sd	s1,8(sp)
    80003870:	e04a                	sd	s2,0(sp)
    80003872:	1000                	addi	s0,sp,32
    80003874:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003876:	00850913          	addi	s2,a0,8
    8000387a:	854a                	mv	a0,s2
    8000387c:	00003097          	auipc	ra,0x3
    80003880:	a46080e7          	jalr	-1466(ra) # 800062c2 <acquire>
  lk->locked = 0;
    80003884:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003888:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    8000388c:	8526                	mv	a0,s1
    8000388e:	ffffe097          	auipc	ra,0xffffe
    80003892:	e60080e7          	jalr	-416(ra) # 800016ee <wakeup>
  release(&lk->lk);
    80003896:	854a                	mv	a0,s2
    80003898:	00003097          	auipc	ra,0x3
    8000389c:	ada080e7          	jalr	-1318(ra) # 80006372 <release>
}
    800038a0:	60e2                	ld	ra,24(sp)
    800038a2:	6442                	ld	s0,16(sp)
    800038a4:	64a2                	ld	s1,8(sp)
    800038a6:	6902                	ld	s2,0(sp)
    800038a8:	6105                	addi	sp,sp,32
    800038aa:	8082                	ret

00000000800038ac <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800038ac:	7179                	addi	sp,sp,-48
    800038ae:	f406                	sd	ra,40(sp)
    800038b0:	f022                	sd	s0,32(sp)
    800038b2:	ec26                	sd	s1,24(sp)
    800038b4:	e84a                	sd	s2,16(sp)
    800038b6:	1800                	addi	s0,sp,48
    800038b8:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800038ba:	00850913          	addi	s2,a0,8
    800038be:	854a                	mv	a0,s2
    800038c0:	00003097          	auipc	ra,0x3
    800038c4:	a02080e7          	jalr	-1534(ra) # 800062c2 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800038c8:	409c                	lw	a5,0(s1)
    800038ca:	ef91                	bnez	a5,800038e6 <holdingsleep+0x3a>
    800038cc:	4481                	li	s1,0
  release(&lk->lk);
    800038ce:	854a                	mv	a0,s2
    800038d0:	00003097          	auipc	ra,0x3
    800038d4:	aa2080e7          	jalr	-1374(ra) # 80006372 <release>
  return r;
}
    800038d8:	8526                	mv	a0,s1
    800038da:	70a2                	ld	ra,40(sp)
    800038dc:	7402                	ld	s0,32(sp)
    800038de:	64e2                	ld	s1,24(sp)
    800038e0:	6942                	ld	s2,16(sp)
    800038e2:	6145                	addi	sp,sp,48
    800038e4:	8082                	ret
    800038e6:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    800038e8:	0284a983          	lw	s3,40(s1)
    800038ec:	ffffd097          	auipc	ra,0xffffd
    800038f0:	5aa080e7          	jalr	1450(ra) # 80000e96 <myproc>
    800038f4:	5904                	lw	s1,48(a0)
    800038f6:	413484b3          	sub	s1,s1,s3
    800038fa:	0014b493          	seqz	s1,s1
    800038fe:	69a2                	ld	s3,8(sp)
    80003900:	b7f9                	j	800038ce <holdingsleep+0x22>

0000000080003902 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003902:	1141                	addi	sp,sp,-16
    80003904:	e406                	sd	ra,8(sp)
    80003906:	e022                	sd	s0,0(sp)
    80003908:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    8000390a:	00005597          	auipc	a1,0x5
    8000390e:	bfe58593          	addi	a1,a1,-1026 # 80008508 <etext+0x508>
    80003912:	00016517          	auipc	a0,0x16
    80003916:	e5650513          	addi	a0,a0,-426 # 80019768 <ftable>
    8000391a:	00003097          	auipc	ra,0x3
    8000391e:	914080e7          	jalr	-1772(ra) # 8000622e <initlock>
}
    80003922:	60a2                	ld	ra,8(sp)
    80003924:	6402                	ld	s0,0(sp)
    80003926:	0141                	addi	sp,sp,16
    80003928:	8082                	ret

000000008000392a <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    8000392a:	1101                	addi	sp,sp,-32
    8000392c:	ec06                	sd	ra,24(sp)
    8000392e:	e822                	sd	s0,16(sp)
    80003930:	e426                	sd	s1,8(sp)
    80003932:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003934:	00016517          	auipc	a0,0x16
    80003938:	e3450513          	addi	a0,a0,-460 # 80019768 <ftable>
    8000393c:	00003097          	auipc	ra,0x3
    80003940:	986080e7          	jalr	-1658(ra) # 800062c2 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003944:	00016497          	auipc	s1,0x16
    80003948:	e3c48493          	addi	s1,s1,-452 # 80019780 <ftable+0x18>
    8000394c:	00017717          	auipc	a4,0x17
    80003950:	dd470713          	addi	a4,a4,-556 # 8001a720 <ftable+0xfb8>
    if(f->ref == 0){
    80003954:	40dc                	lw	a5,4(s1)
    80003956:	cf99                	beqz	a5,80003974 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003958:	02848493          	addi	s1,s1,40
    8000395c:	fee49ce3          	bne	s1,a4,80003954 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003960:	00016517          	auipc	a0,0x16
    80003964:	e0850513          	addi	a0,a0,-504 # 80019768 <ftable>
    80003968:	00003097          	auipc	ra,0x3
    8000396c:	a0a080e7          	jalr	-1526(ra) # 80006372 <release>
  return 0;
    80003970:	4481                	li	s1,0
    80003972:	a819                	j	80003988 <filealloc+0x5e>
      f->ref = 1;
    80003974:	4785                	li	a5,1
    80003976:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003978:	00016517          	auipc	a0,0x16
    8000397c:	df050513          	addi	a0,a0,-528 # 80019768 <ftable>
    80003980:	00003097          	auipc	ra,0x3
    80003984:	9f2080e7          	jalr	-1550(ra) # 80006372 <release>
}
    80003988:	8526                	mv	a0,s1
    8000398a:	60e2                	ld	ra,24(sp)
    8000398c:	6442                	ld	s0,16(sp)
    8000398e:	64a2                	ld	s1,8(sp)
    80003990:	6105                	addi	sp,sp,32
    80003992:	8082                	ret

0000000080003994 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003994:	1101                	addi	sp,sp,-32
    80003996:	ec06                	sd	ra,24(sp)
    80003998:	e822                	sd	s0,16(sp)
    8000399a:	e426                	sd	s1,8(sp)
    8000399c:	1000                	addi	s0,sp,32
    8000399e:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800039a0:	00016517          	auipc	a0,0x16
    800039a4:	dc850513          	addi	a0,a0,-568 # 80019768 <ftable>
    800039a8:	00003097          	auipc	ra,0x3
    800039ac:	91a080e7          	jalr	-1766(ra) # 800062c2 <acquire>
  if(f->ref < 1)
    800039b0:	40dc                	lw	a5,4(s1)
    800039b2:	02f05263          	blez	a5,800039d6 <filedup+0x42>
    panic("filedup");
  f->ref++;
    800039b6:	2785                	addiw	a5,a5,1
    800039b8:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800039ba:	00016517          	auipc	a0,0x16
    800039be:	dae50513          	addi	a0,a0,-594 # 80019768 <ftable>
    800039c2:	00003097          	auipc	ra,0x3
    800039c6:	9b0080e7          	jalr	-1616(ra) # 80006372 <release>
  return f;
}
    800039ca:	8526                	mv	a0,s1
    800039cc:	60e2                	ld	ra,24(sp)
    800039ce:	6442                	ld	s0,16(sp)
    800039d0:	64a2                	ld	s1,8(sp)
    800039d2:	6105                	addi	sp,sp,32
    800039d4:	8082                	ret
    panic("filedup");
    800039d6:	00005517          	auipc	a0,0x5
    800039da:	b3a50513          	addi	a0,a0,-1222 # 80008510 <etext+0x510>
    800039de:	00002097          	auipc	ra,0x2
    800039e2:	38e080e7          	jalr	910(ra) # 80005d6c <panic>

00000000800039e6 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800039e6:	7139                	addi	sp,sp,-64
    800039e8:	fc06                	sd	ra,56(sp)
    800039ea:	f822                	sd	s0,48(sp)
    800039ec:	f426                	sd	s1,40(sp)
    800039ee:	0080                	addi	s0,sp,64
    800039f0:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800039f2:	00016517          	auipc	a0,0x16
    800039f6:	d7650513          	addi	a0,a0,-650 # 80019768 <ftable>
    800039fa:	00003097          	auipc	ra,0x3
    800039fe:	8c8080e7          	jalr	-1848(ra) # 800062c2 <acquire>
  if(f->ref < 1)
    80003a02:	40dc                	lw	a5,4(s1)
    80003a04:	04f05a63          	blez	a5,80003a58 <fileclose+0x72>
    panic("fileclose");
  if(--f->ref > 0){
    80003a08:	37fd                	addiw	a5,a5,-1
    80003a0a:	c0dc                	sw	a5,4(s1)
    80003a0c:	06f04263          	bgtz	a5,80003a70 <fileclose+0x8a>
    80003a10:	f04a                	sd	s2,32(sp)
    80003a12:	ec4e                	sd	s3,24(sp)
    80003a14:	e852                	sd	s4,16(sp)
    80003a16:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003a18:	0004a903          	lw	s2,0(s1)
    80003a1c:	0094ca83          	lbu	s5,9(s1)
    80003a20:	0104ba03          	ld	s4,16(s1)
    80003a24:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003a28:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003a2c:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003a30:	00016517          	auipc	a0,0x16
    80003a34:	d3850513          	addi	a0,a0,-712 # 80019768 <ftable>
    80003a38:	00003097          	auipc	ra,0x3
    80003a3c:	93a080e7          	jalr	-1734(ra) # 80006372 <release>

  if(ff.type == FD_PIPE){
    80003a40:	4785                	li	a5,1
    80003a42:	04f90463          	beq	s2,a5,80003a8a <fileclose+0xa4>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003a46:	3979                	addiw	s2,s2,-2
    80003a48:	4785                	li	a5,1
    80003a4a:	0527fb63          	bgeu	a5,s2,80003aa0 <fileclose+0xba>
    80003a4e:	7902                	ld	s2,32(sp)
    80003a50:	69e2                	ld	s3,24(sp)
    80003a52:	6a42                	ld	s4,16(sp)
    80003a54:	6aa2                	ld	s5,8(sp)
    80003a56:	a02d                	j	80003a80 <fileclose+0x9a>
    80003a58:	f04a                	sd	s2,32(sp)
    80003a5a:	ec4e                	sd	s3,24(sp)
    80003a5c:	e852                	sd	s4,16(sp)
    80003a5e:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80003a60:	00005517          	auipc	a0,0x5
    80003a64:	ab850513          	addi	a0,a0,-1352 # 80008518 <etext+0x518>
    80003a68:	00002097          	auipc	ra,0x2
    80003a6c:	304080e7          	jalr	772(ra) # 80005d6c <panic>
    release(&ftable.lock);
    80003a70:	00016517          	auipc	a0,0x16
    80003a74:	cf850513          	addi	a0,a0,-776 # 80019768 <ftable>
    80003a78:	00003097          	auipc	ra,0x3
    80003a7c:	8fa080e7          	jalr	-1798(ra) # 80006372 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80003a80:	70e2                	ld	ra,56(sp)
    80003a82:	7442                	ld	s0,48(sp)
    80003a84:	74a2                	ld	s1,40(sp)
    80003a86:	6121                	addi	sp,sp,64
    80003a88:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003a8a:	85d6                	mv	a1,s5
    80003a8c:	8552                	mv	a0,s4
    80003a8e:	00000097          	auipc	ra,0x0
    80003a92:	3ac080e7          	jalr	940(ra) # 80003e3a <pipeclose>
    80003a96:	7902                	ld	s2,32(sp)
    80003a98:	69e2                	ld	s3,24(sp)
    80003a9a:	6a42                	ld	s4,16(sp)
    80003a9c:	6aa2                	ld	s5,8(sp)
    80003a9e:	b7cd                	j	80003a80 <fileclose+0x9a>
    begin_op();
    80003aa0:	00000097          	auipc	ra,0x0
    80003aa4:	a76080e7          	jalr	-1418(ra) # 80003516 <begin_op>
    iput(ff.ip);
    80003aa8:	854e                	mv	a0,s3
    80003aaa:	fffff097          	auipc	ra,0xfffff
    80003aae:	238080e7          	jalr	568(ra) # 80002ce2 <iput>
    end_op();
    80003ab2:	00000097          	auipc	ra,0x0
    80003ab6:	ade080e7          	jalr	-1314(ra) # 80003590 <end_op>
    80003aba:	7902                	ld	s2,32(sp)
    80003abc:	69e2                	ld	s3,24(sp)
    80003abe:	6a42                	ld	s4,16(sp)
    80003ac0:	6aa2                	ld	s5,8(sp)
    80003ac2:	bf7d                	j	80003a80 <fileclose+0x9a>

0000000080003ac4 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003ac4:	715d                	addi	sp,sp,-80
    80003ac6:	e486                	sd	ra,72(sp)
    80003ac8:	e0a2                	sd	s0,64(sp)
    80003aca:	fc26                	sd	s1,56(sp)
    80003acc:	f44e                	sd	s3,40(sp)
    80003ace:	0880                	addi	s0,sp,80
    80003ad0:	84aa                	mv	s1,a0
    80003ad2:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003ad4:	ffffd097          	auipc	ra,0xffffd
    80003ad8:	3c2080e7          	jalr	962(ra) # 80000e96 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003adc:	409c                	lw	a5,0(s1)
    80003ade:	37f9                	addiw	a5,a5,-2
    80003ae0:	4705                	li	a4,1
    80003ae2:	04f76a63          	bltu	a4,a5,80003b36 <filestat+0x72>
    80003ae6:	f84a                	sd	s2,48(sp)
    80003ae8:	f052                	sd	s4,32(sp)
    80003aea:	892a                	mv	s2,a0
    ilock(f->ip);
    80003aec:	6c88                	ld	a0,24(s1)
    80003aee:	fffff097          	auipc	ra,0xfffff
    80003af2:	036080e7          	jalr	54(ra) # 80002b24 <ilock>
    stati(f->ip, &st);
    80003af6:	fb840a13          	addi	s4,s0,-72
    80003afa:	85d2                	mv	a1,s4
    80003afc:	6c88                	ld	a0,24(s1)
    80003afe:	fffff097          	auipc	ra,0xfffff
    80003b02:	2b4080e7          	jalr	692(ra) # 80002db2 <stati>
    iunlock(f->ip);
    80003b06:	6c88                	ld	a0,24(s1)
    80003b08:	fffff097          	auipc	ra,0xfffff
    80003b0c:	0e2080e7          	jalr	226(ra) # 80002bea <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003b10:	46e1                	li	a3,24
    80003b12:	8652                	mv	a2,s4
    80003b14:	85ce                	mv	a1,s3
    80003b16:	05093503          	ld	a0,80(s2)
    80003b1a:	ffffd097          	auipc	ra,0xffffd
    80003b1e:	034080e7          	jalr	52(ra) # 80000b4e <copyout>
    80003b22:	41f5551b          	sraiw	a0,a0,0x1f
    80003b26:	7942                	ld	s2,48(sp)
    80003b28:	7a02                	ld	s4,32(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80003b2a:	60a6                	ld	ra,72(sp)
    80003b2c:	6406                	ld	s0,64(sp)
    80003b2e:	74e2                	ld	s1,56(sp)
    80003b30:	79a2                	ld	s3,40(sp)
    80003b32:	6161                	addi	sp,sp,80
    80003b34:	8082                	ret
  return -1;
    80003b36:	557d                	li	a0,-1
    80003b38:	bfcd                	j	80003b2a <filestat+0x66>

0000000080003b3a <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003b3a:	7179                	addi	sp,sp,-48
    80003b3c:	f406                	sd	ra,40(sp)
    80003b3e:	f022                	sd	s0,32(sp)
    80003b40:	e84a                	sd	s2,16(sp)
    80003b42:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003b44:	00854783          	lbu	a5,8(a0)
    80003b48:	cbc5                	beqz	a5,80003bf8 <fileread+0xbe>
    80003b4a:	ec26                	sd	s1,24(sp)
    80003b4c:	e44e                	sd	s3,8(sp)
    80003b4e:	84aa                	mv	s1,a0
    80003b50:	89ae                	mv	s3,a1
    80003b52:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003b54:	411c                	lw	a5,0(a0)
    80003b56:	4705                	li	a4,1
    80003b58:	04e78963          	beq	a5,a4,80003baa <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003b5c:	470d                	li	a4,3
    80003b5e:	04e78f63          	beq	a5,a4,80003bbc <fileread+0x82>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003b62:	4709                	li	a4,2
    80003b64:	08e79263          	bne	a5,a4,80003be8 <fileread+0xae>
    ilock(f->ip);
    80003b68:	6d08                	ld	a0,24(a0)
    80003b6a:	fffff097          	auipc	ra,0xfffff
    80003b6e:	fba080e7          	jalr	-70(ra) # 80002b24 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003b72:	874a                	mv	a4,s2
    80003b74:	5094                	lw	a3,32(s1)
    80003b76:	864e                	mv	a2,s3
    80003b78:	4585                	li	a1,1
    80003b7a:	6c88                	ld	a0,24(s1)
    80003b7c:	fffff097          	auipc	ra,0xfffff
    80003b80:	264080e7          	jalr	612(ra) # 80002de0 <readi>
    80003b84:	892a                	mv	s2,a0
    80003b86:	00a05563          	blez	a0,80003b90 <fileread+0x56>
      f->off += r;
    80003b8a:	509c                	lw	a5,32(s1)
    80003b8c:	9fa9                	addw	a5,a5,a0
    80003b8e:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003b90:	6c88                	ld	a0,24(s1)
    80003b92:	fffff097          	auipc	ra,0xfffff
    80003b96:	058080e7          	jalr	88(ra) # 80002bea <iunlock>
    80003b9a:	64e2                	ld	s1,24(sp)
    80003b9c:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80003b9e:	854a                	mv	a0,s2
    80003ba0:	70a2                	ld	ra,40(sp)
    80003ba2:	7402                	ld	s0,32(sp)
    80003ba4:	6942                	ld	s2,16(sp)
    80003ba6:	6145                	addi	sp,sp,48
    80003ba8:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003baa:	6908                	ld	a0,16(a0)
    80003bac:	00000097          	auipc	ra,0x0
    80003bb0:	414080e7          	jalr	1044(ra) # 80003fc0 <piperead>
    80003bb4:	892a                	mv	s2,a0
    80003bb6:	64e2                	ld	s1,24(sp)
    80003bb8:	69a2                	ld	s3,8(sp)
    80003bba:	b7d5                	j	80003b9e <fileread+0x64>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003bbc:	02451783          	lh	a5,36(a0)
    80003bc0:	03079693          	slli	a3,a5,0x30
    80003bc4:	92c1                	srli	a3,a3,0x30
    80003bc6:	4725                	li	a4,9
    80003bc8:	02d76a63          	bltu	a4,a3,80003bfc <fileread+0xc2>
    80003bcc:	0792                	slli	a5,a5,0x4
    80003bce:	00016717          	auipc	a4,0x16
    80003bd2:	afa70713          	addi	a4,a4,-1286 # 800196c8 <devsw>
    80003bd6:	97ba                	add	a5,a5,a4
    80003bd8:	639c                	ld	a5,0(a5)
    80003bda:	c78d                	beqz	a5,80003c04 <fileread+0xca>
    r = devsw[f->major].read(1, addr, n);
    80003bdc:	4505                	li	a0,1
    80003bde:	9782                	jalr	a5
    80003be0:	892a                	mv	s2,a0
    80003be2:	64e2                	ld	s1,24(sp)
    80003be4:	69a2                	ld	s3,8(sp)
    80003be6:	bf65                	j	80003b9e <fileread+0x64>
    panic("fileread");
    80003be8:	00005517          	auipc	a0,0x5
    80003bec:	94050513          	addi	a0,a0,-1728 # 80008528 <etext+0x528>
    80003bf0:	00002097          	auipc	ra,0x2
    80003bf4:	17c080e7          	jalr	380(ra) # 80005d6c <panic>
    return -1;
    80003bf8:	597d                	li	s2,-1
    80003bfa:	b755                	j	80003b9e <fileread+0x64>
      return -1;
    80003bfc:	597d                	li	s2,-1
    80003bfe:	64e2                	ld	s1,24(sp)
    80003c00:	69a2                	ld	s3,8(sp)
    80003c02:	bf71                	j	80003b9e <fileread+0x64>
    80003c04:	597d                	li	s2,-1
    80003c06:	64e2                	ld	s1,24(sp)
    80003c08:	69a2                	ld	s3,8(sp)
    80003c0a:	bf51                	j	80003b9e <fileread+0x64>

0000000080003c0c <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003c0c:	00954783          	lbu	a5,9(a0)
    80003c10:	12078c63          	beqz	a5,80003d48 <filewrite+0x13c>
{
    80003c14:	711d                	addi	sp,sp,-96
    80003c16:	ec86                	sd	ra,88(sp)
    80003c18:	e8a2                	sd	s0,80(sp)
    80003c1a:	e0ca                	sd	s2,64(sp)
    80003c1c:	f456                	sd	s5,40(sp)
    80003c1e:	f05a                	sd	s6,32(sp)
    80003c20:	1080                	addi	s0,sp,96
    80003c22:	892a                	mv	s2,a0
    80003c24:	8b2e                	mv	s6,a1
    80003c26:	8ab2                	mv	s5,a2
    return -1;

  if(f->type == FD_PIPE){
    80003c28:	411c                	lw	a5,0(a0)
    80003c2a:	4705                	li	a4,1
    80003c2c:	02e78963          	beq	a5,a4,80003c5e <filewrite+0x52>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003c30:	470d                	li	a4,3
    80003c32:	02e78c63          	beq	a5,a4,80003c6a <filewrite+0x5e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003c36:	4709                	li	a4,2
    80003c38:	0ee79a63          	bne	a5,a4,80003d2c <filewrite+0x120>
    80003c3c:	f852                	sd	s4,48(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003c3e:	0cc05563          	blez	a2,80003d08 <filewrite+0xfc>
    80003c42:	e4a6                	sd	s1,72(sp)
    80003c44:	fc4e                	sd	s3,56(sp)
    80003c46:	ec5e                	sd	s7,24(sp)
    80003c48:	e862                	sd	s8,16(sp)
    80003c4a:	e466                	sd	s9,8(sp)
    int i = 0;
    80003c4c:	4a01                	li	s4,0
      int n1 = n - i;
      if(n1 > max)
    80003c4e:	6b85                	lui	s7,0x1
    80003c50:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003c54:	6c85                	lui	s9,0x1
    80003c56:	c00c8c9b          	addiw	s9,s9,-1024 # c00 <_entry-0x7ffff400>
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003c5a:	4c05                	li	s8,1
    80003c5c:	a849                	j	80003cee <filewrite+0xe2>
    ret = pipewrite(f->pipe, addr, n);
    80003c5e:	6908                	ld	a0,16(a0)
    80003c60:	00000097          	auipc	ra,0x0
    80003c64:	24a080e7          	jalr	586(ra) # 80003eaa <pipewrite>
    80003c68:	a85d                	j	80003d1e <filewrite+0x112>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003c6a:	02451783          	lh	a5,36(a0)
    80003c6e:	03079693          	slli	a3,a5,0x30
    80003c72:	92c1                	srli	a3,a3,0x30
    80003c74:	4725                	li	a4,9
    80003c76:	0cd76b63          	bltu	a4,a3,80003d4c <filewrite+0x140>
    80003c7a:	0792                	slli	a5,a5,0x4
    80003c7c:	00016717          	auipc	a4,0x16
    80003c80:	a4c70713          	addi	a4,a4,-1460 # 800196c8 <devsw>
    80003c84:	97ba                	add	a5,a5,a4
    80003c86:	679c                	ld	a5,8(a5)
    80003c88:	c7e1                	beqz	a5,80003d50 <filewrite+0x144>
    ret = devsw[f->major].write(1, addr, n);
    80003c8a:	4505                	li	a0,1
    80003c8c:	9782                	jalr	a5
    80003c8e:	a841                	j	80003d1e <filewrite+0x112>
      if(n1 > max)
    80003c90:	2981                	sext.w	s3,s3
      begin_op();
    80003c92:	00000097          	auipc	ra,0x0
    80003c96:	884080e7          	jalr	-1916(ra) # 80003516 <begin_op>
      ilock(f->ip);
    80003c9a:	01893503          	ld	a0,24(s2)
    80003c9e:	fffff097          	auipc	ra,0xfffff
    80003ca2:	e86080e7          	jalr	-378(ra) # 80002b24 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003ca6:	874e                	mv	a4,s3
    80003ca8:	02092683          	lw	a3,32(s2)
    80003cac:	016a0633          	add	a2,s4,s6
    80003cb0:	85e2                	mv	a1,s8
    80003cb2:	01893503          	ld	a0,24(s2)
    80003cb6:	fffff097          	auipc	ra,0xfffff
    80003cba:	224080e7          	jalr	548(ra) # 80002eda <writei>
    80003cbe:	84aa                	mv	s1,a0
    80003cc0:	00a05763          	blez	a0,80003cce <filewrite+0xc2>
        f->off += r;
    80003cc4:	02092783          	lw	a5,32(s2)
    80003cc8:	9fa9                	addw	a5,a5,a0
    80003cca:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003cce:	01893503          	ld	a0,24(s2)
    80003cd2:	fffff097          	auipc	ra,0xfffff
    80003cd6:	f18080e7          	jalr	-232(ra) # 80002bea <iunlock>
      end_op();
    80003cda:	00000097          	auipc	ra,0x0
    80003cde:	8b6080e7          	jalr	-1866(ra) # 80003590 <end_op>

      if(r != n1){
    80003ce2:	02999563          	bne	s3,s1,80003d0c <filewrite+0x100>
        // error from writei
        break;
      }
      i += r;
    80003ce6:	01448a3b          	addw	s4,s1,s4
    while(i < n){
    80003cea:	015a5963          	bge	s4,s5,80003cfc <filewrite+0xf0>
      int n1 = n - i;
    80003cee:	414a87bb          	subw	a5,s5,s4
    80003cf2:	89be                	mv	s3,a5
      if(n1 > max)
    80003cf4:	f8fbdee3          	bge	s7,a5,80003c90 <filewrite+0x84>
    80003cf8:	89e6                	mv	s3,s9
    80003cfa:	bf59                	j	80003c90 <filewrite+0x84>
    80003cfc:	64a6                	ld	s1,72(sp)
    80003cfe:	79e2                	ld	s3,56(sp)
    80003d00:	6be2                	ld	s7,24(sp)
    80003d02:	6c42                	ld	s8,16(sp)
    80003d04:	6ca2                	ld	s9,8(sp)
    80003d06:	a801                	j	80003d16 <filewrite+0x10a>
    int i = 0;
    80003d08:	4a01                	li	s4,0
    80003d0a:	a031                	j	80003d16 <filewrite+0x10a>
    80003d0c:	64a6                	ld	s1,72(sp)
    80003d0e:	79e2                	ld	s3,56(sp)
    80003d10:	6be2                	ld	s7,24(sp)
    80003d12:	6c42                	ld	s8,16(sp)
    80003d14:	6ca2                	ld	s9,8(sp)
    }
    ret = (i == n ? n : -1);
    80003d16:	034a9f63          	bne	s5,s4,80003d54 <filewrite+0x148>
    80003d1a:	8556                	mv	a0,s5
    80003d1c:	7a42                	ld	s4,48(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003d1e:	60e6                	ld	ra,88(sp)
    80003d20:	6446                	ld	s0,80(sp)
    80003d22:	6906                	ld	s2,64(sp)
    80003d24:	7aa2                	ld	s5,40(sp)
    80003d26:	7b02                	ld	s6,32(sp)
    80003d28:	6125                	addi	sp,sp,96
    80003d2a:	8082                	ret
    80003d2c:	e4a6                	sd	s1,72(sp)
    80003d2e:	fc4e                	sd	s3,56(sp)
    80003d30:	f852                	sd	s4,48(sp)
    80003d32:	ec5e                	sd	s7,24(sp)
    80003d34:	e862                	sd	s8,16(sp)
    80003d36:	e466                	sd	s9,8(sp)
    panic("filewrite");
    80003d38:	00005517          	auipc	a0,0x5
    80003d3c:	80050513          	addi	a0,a0,-2048 # 80008538 <etext+0x538>
    80003d40:	00002097          	auipc	ra,0x2
    80003d44:	02c080e7          	jalr	44(ra) # 80005d6c <panic>
    return -1;
    80003d48:	557d                	li	a0,-1
}
    80003d4a:	8082                	ret
      return -1;
    80003d4c:	557d                	li	a0,-1
    80003d4e:	bfc1                	j	80003d1e <filewrite+0x112>
    80003d50:	557d                	li	a0,-1
    80003d52:	b7f1                	j	80003d1e <filewrite+0x112>
    ret = (i == n ? n : -1);
    80003d54:	557d                	li	a0,-1
    80003d56:	7a42                	ld	s4,48(sp)
    80003d58:	b7d9                	j	80003d1e <filewrite+0x112>

0000000080003d5a <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003d5a:	7179                	addi	sp,sp,-48
    80003d5c:	f406                	sd	ra,40(sp)
    80003d5e:	f022                	sd	s0,32(sp)
    80003d60:	ec26                	sd	s1,24(sp)
    80003d62:	e052                	sd	s4,0(sp)
    80003d64:	1800                	addi	s0,sp,48
    80003d66:	84aa                	mv	s1,a0
    80003d68:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003d6a:	0005b023          	sd	zero,0(a1)
    80003d6e:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003d72:	00000097          	auipc	ra,0x0
    80003d76:	bb8080e7          	jalr	-1096(ra) # 8000392a <filealloc>
    80003d7a:	e088                	sd	a0,0(s1)
    80003d7c:	cd49                	beqz	a0,80003e16 <pipealloc+0xbc>
    80003d7e:	00000097          	auipc	ra,0x0
    80003d82:	bac080e7          	jalr	-1108(ra) # 8000392a <filealloc>
    80003d86:	00aa3023          	sd	a0,0(s4)
    80003d8a:	c141                	beqz	a0,80003e0a <pipealloc+0xb0>
    80003d8c:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003d8e:	ffffc097          	auipc	ra,0xffffc
    80003d92:	38c080e7          	jalr	908(ra) # 8000011a <kalloc>
    80003d96:	892a                	mv	s2,a0
    80003d98:	c13d                	beqz	a0,80003dfe <pipealloc+0xa4>
    80003d9a:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80003d9c:	4985                	li	s3,1
    80003d9e:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003da2:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003da6:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003daa:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003dae:	00004597          	auipc	a1,0x4
    80003db2:	79a58593          	addi	a1,a1,1946 # 80008548 <etext+0x548>
    80003db6:	00002097          	auipc	ra,0x2
    80003dba:	478080e7          	jalr	1144(ra) # 8000622e <initlock>
  (*f0)->type = FD_PIPE;
    80003dbe:	609c                	ld	a5,0(s1)
    80003dc0:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003dc4:	609c                	ld	a5,0(s1)
    80003dc6:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003dca:	609c                	ld	a5,0(s1)
    80003dcc:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003dd0:	609c                	ld	a5,0(s1)
    80003dd2:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003dd6:	000a3783          	ld	a5,0(s4)
    80003dda:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003dde:	000a3783          	ld	a5,0(s4)
    80003de2:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003de6:	000a3783          	ld	a5,0(s4)
    80003dea:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003dee:	000a3783          	ld	a5,0(s4)
    80003df2:	0127b823          	sd	s2,16(a5)
  return 0;
    80003df6:	4501                	li	a0,0
    80003df8:	6942                	ld	s2,16(sp)
    80003dfa:	69a2                	ld	s3,8(sp)
    80003dfc:	a03d                	j	80003e2a <pipealloc+0xd0>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003dfe:	6088                	ld	a0,0(s1)
    80003e00:	c119                	beqz	a0,80003e06 <pipealloc+0xac>
    80003e02:	6942                	ld	s2,16(sp)
    80003e04:	a029                	j	80003e0e <pipealloc+0xb4>
    80003e06:	6942                	ld	s2,16(sp)
    80003e08:	a039                	j	80003e16 <pipealloc+0xbc>
    80003e0a:	6088                	ld	a0,0(s1)
    80003e0c:	c50d                	beqz	a0,80003e36 <pipealloc+0xdc>
    fileclose(*f0);
    80003e0e:	00000097          	auipc	ra,0x0
    80003e12:	bd8080e7          	jalr	-1064(ra) # 800039e6 <fileclose>
  if(*f1)
    80003e16:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003e1a:	557d                	li	a0,-1
  if(*f1)
    80003e1c:	c799                	beqz	a5,80003e2a <pipealloc+0xd0>
    fileclose(*f1);
    80003e1e:	853e                	mv	a0,a5
    80003e20:	00000097          	auipc	ra,0x0
    80003e24:	bc6080e7          	jalr	-1082(ra) # 800039e6 <fileclose>
  return -1;
    80003e28:	557d                	li	a0,-1
}
    80003e2a:	70a2                	ld	ra,40(sp)
    80003e2c:	7402                	ld	s0,32(sp)
    80003e2e:	64e2                	ld	s1,24(sp)
    80003e30:	6a02                	ld	s4,0(sp)
    80003e32:	6145                	addi	sp,sp,48
    80003e34:	8082                	ret
  return -1;
    80003e36:	557d                	li	a0,-1
    80003e38:	bfcd                	j	80003e2a <pipealloc+0xd0>

0000000080003e3a <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003e3a:	1101                	addi	sp,sp,-32
    80003e3c:	ec06                	sd	ra,24(sp)
    80003e3e:	e822                	sd	s0,16(sp)
    80003e40:	e426                	sd	s1,8(sp)
    80003e42:	e04a                	sd	s2,0(sp)
    80003e44:	1000                	addi	s0,sp,32
    80003e46:	84aa                	mv	s1,a0
    80003e48:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003e4a:	00002097          	auipc	ra,0x2
    80003e4e:	478080e7          	jalr	1144(ra) # 800062c2 <acquire>
  if(writable){
    80003e52:	02090d63          	beqz	s2,80003e8c <pipeclose+0x52>
    pi->writeopen = 0;
    80003e56:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003e5a:	21848513          	addi	a0,s1,536
    80003e5e:	ffffe097          	auipc	ra,0xffffe
    80003e62:	890080e7          	jalr	-1904(ra) # 800016ee <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003e66:	2204b783          	ld	a5,544(s1)
    80003e6a:	eb95                	bnez	a5,80003e9e <pipeclose+0x64>
    release(&pi->lock);
    80003e6c:	8526                	mv	a0,s1
    80003e6e:	00002097          	auipc	ra,0x2
    80003e72:	504080e7          	jalr	1284(ra) # 80006372 <release>
    kfree((char*)pi);
    80003e76:	8526                	mv	a0,s1
    80003e78:	ffffc097          	auipc	ra,0xffffc
    80003e7c:	1a4080e7          	jalr	420(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003e80:	60e2                	ld	ra,24(sp)
    80003e82:	6442                	ld	s0,16(sp)
    80003e84:	64a2                	ld	s1,8(sp)
    80003e86:	6902                	ld	s2,0(sp)
    80003e88:	6105                	addi	sp,sp,32
    80003e8a:	8082                	ret
    pi->readopen = 0;
    80003e8c:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003e90:	21c48513          	addi	a0,s1,540
    80003e94:	ffffe097          	auipc	ra,0xffffe
    80003e98:	85a080e7          	jalr	-1958(ra) # 800016ee <wakeup>
    80003e9c:	b7e9                	j	80003e66 <pipeclose+0x2c>
    release(&pi->lock);
    80003e9e:	8526                	mv	a0,s1
    80003ea0:	00002097          	auipc	ra,0x2
    80003ea4:	4d2080e7          	jalr	1234(ra) # 80006372 <release>
}
    80003ea8:	bfe1                	j	80003e80 <pipeclose+0x46>

0000000080003eaa <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003eaa:	7159                	addi	sp,sp,-112
    80003eac:	f486                	sd	ra,104(sp)
    80003eae:	f0a2                	sd	s0,96(sp)
    80003eb0:	eca6                	sd	s1,88(sp)
    80003eb2:	e8ca                	sd	s2,80(sp)
    80003eb4:	e4ce                	sd	s3,72(sp)
    80003eb6:	e0d2                	sd	s4,64(sp)
    80003eb8:	fc56                	sd	s5,56(sp)
    80003eba:	1880                	addi	s0,sp,112
    80003ebc:	84aa                	mv	s1,a0
    80003ebe:	8aae                	mv	s5,a1
    80003ec0:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003ec2:	ffffd097          	auipc	ra,0xffffd
    80003ec6:	fd4080e7          	jalr	-44(ra) # 80000e96 <myproc>
    80003eca:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003ecc:	8526                	mv	a0,s1
    80003ece:	00002097          	auipc	ra,0x2
    80003ed2:	3f4080e7          	jalr	1012(ra) # 800062c2 <acquire>
  while(i < n){
    80003ed6:	0d405d63          	blez	s4,80003fb0 <pipewrite+0x106>
    80003eda:	f85a                	sd	s6,48(sp)
    80003edc:	f45e                	sd	s7,40(sp)
    80003ede:	f062                	sd	s8,32(sp)
    80003ee0:	ec66                	sd	s9,24(sp)
    80003ee2:	e86a                	sd	s10,16(sp)
  int i = 0;
    80003ee4:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003ee6:	f9f40c13          	addi	s8,s0,-97
    80003eea:	4b85                	li	s7,1
    80003eec:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003eee:	21848d13          	addi	s10,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003ef2:	21c48c93          	addi	s9,s1,540
    80003ef6:	a099                	j	80003f3c <pipewrite+0x92>
      release(&pi->lock);
    80003ef8:	8526                	mv	a0,s1
    80003efa:	00002097          	auipc	ra,0x2
    80003efe:	478080e7          	jalr	1144(ra) # 80006372 <release>
      return -1;
    80003f02:	597d                	li	s2,-1
    80003f04:	7b42                	ld	s6,48(sp)
    80003f06:	7ba2                	ld	s7,40(sp)
    80003f08:	7c02                	ld	s8,32(sp)
    80003f0a:	6ce2                	ld	s9,24(sp)
    80003f0c:	6d42                	ld	s10,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003f0e:	854a                	mv	a0,s2
    80003f10:	70a6                	ld	ra,104(sp)
    80003f12:	7406                	ld	s0,96(sp)
    80003f14:	64e6                	ld	s1,88(sp)
    80003f16:	6946                	ld	s2,80(sp)
    80003f18:	69a6                	ld	s3,72(sp)
    80003f1a:	6a06                	ld	s4,64(sp)
    80003f1c:	7ae2                	ld	s5,56(sp)
    80003f1e:	6165                	addi	sp,sp,112
    80003f20:	8082                	ret
      wakeup(&pi->nread);
    80003f22:	856a                	mv	a0,s10
    80003f24:	ffffd097          	auipc	ra,0xffffd
    80003f28:	7ca080e7          	jalr	1994(ra) # 800016ee <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003f2c:	85a6                	mv	a1,s1
    80003f2e:	8566                	mv	a0,s9
    80003f30:	ffffd097          	auipc	ra,0xffffd
    80003f34:	638080e7          	jalr	1592(ra) # 80001568 <sleep>
  while(i < n){
    80003f38:	05495b63          	bge	s2,s4,80003f8e <pipewrite+0xe4>
    if(pi->readopen == 0 || pr->killed){
    80003f3c:	2204a783          	lw	a5,544(s1)
    80003f40:	dfc5                	beqz	a5,80003ef8 <pipewrite+0x4e>
    80003f42:	0289a783          	lw	a5,40(s3)
    80003f46:	fbcd                	bnez	a5,80003ef8 <pipewrite+0x4e>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003f48:	2184a783          	lw	a5,536(s1)
    80003f4c:	21c4a703          	lw	a4,540(s1)
    80003f50:	2007879b          	addiw	a5,a5,512
    80003f54:	fcf707e3          	beq	a4,a5,80003f22 <pipewrite+0x78>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f58:	86de                	mv	a3,s7
    80003f5a:	01590633          	add	a2,s2,s5
    80003f5e:	85e2                	mv	a1,s8
    80003f60:	0509b503          	ld	a0,80(s3)
    80003f64:	ffffd097          	auipc	ra,0xffffd
    80003f68:	c76080e7          	jalr	-906(ra) # 80000bda <copyin>
    80003f6c:	05650463          	beq	a0,s6,80003fb4 <pipewrite+0x10a>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003f70:	21c4a783          	lw	a5,540(s1)
    80003f74:	0017871b          	addiw	a4,a5,1
    80003f78:	20e4ae23          	sw	a4,540(s1)
    80003f7c:	1ff7f793          	andi	a5,a5,511
    80003f80:	97a6                	add	a5,a5,s1
    80003f82:	f9f44703          	lbu	a4,-97(s0)
    80003f86:	00e78c23          	sb	a4,24(a5)
      i++;
    80003f8a:	2905                	addiw	s2,s2,1
    80003f8c:	b775                	j	80003f38 <pipewrite+0x8e>
    80003f8e:	7b42                	ld	s6,48(sp)
    80003f90:	7ba2                	ld	s7,40(sp)
    80003f92:	7c02                	ld	s8,32(sp)
    80003f94:	6ce2                	ld	s9,24(sp)
    80003f96:	6d42                	ld	s10,16(sp)
  wakeup(&pi->nread);
    80003f98:	21848513          	addi	a0,s1,536
    80003f9c:	ffffd097          	auipc	ra,0xffffd
    80003fa0:	752080e7          	jalr	1874(ra) # 800016ee <wakeup>
  release(&pi->lock);
    80003fa4:	8526                	mv	a0,s1
    80003fa6:	00002097          	auipc	ra,0x2
    80003faa:	3cc080e7          	jalr	972(ra) # 80006372 <release>
  return i;
    80003fae:	b785                	j	80003f0e <pipewrite+0x64>
  int i = 0;
    80003fb0:	4901                	li	s2,0
    80003fb2:	b7dd                	j	80003f98 <pipewrite+0xee>
    80003fb4:	7b42                	ld	s6,48(sp)
    80003fb6:	7ba2                	ld	s7,40(sp)
    80003fb8:	7c02                	ld	s8,32(sp)
    80003fba:	6ce2                	ld	s9,24(sp)
    80003fbc:	6d42                	ld	s10,16(sp)
    80003fbe:	bfe9                	j	80003f98 <pipewrite+0xee>

0000000080003fc0 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003fc0:	711d                	addi	sp,sp,-96
    80003fc2:	ec86                	sd	ra,88(sp)
    80003fc4:	e8a2                	sd	s0,80(sp)
    80003fc6:	e4a6                	sd	s1,72(sp)
    80003fc8:	e0ca                	sd	s2,64(sp)
    80003fca:	fc4e                	sd	s3,56(sp)
    80003fcc:	f852                	sd	s4,48(sp)
    80003fce:	f456                	sd	s5,40(sp)
    80003fd0:	1080                	addi	s0,sp,96
    80003fd2:	84aa                	mv	s1,a0
    80003fd4:	892e                	mv	s2,a1
    80003fd6:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003fd8:	ffffd097          	auipc	ra,0xffffd
    80003fdc:	ebe080e7          	jalr	-322(ra) # 80000e96 <myproc>
    80003fe0:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003fe2:	8526                	mv	a0,s1
    80003fe4:	00002097          	auipc	ra,0x2
    80003fe8:	2de080e7          	jalr	734(ra) # 800062c2 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003fec:	2184a703          	lw	a4,536(s1)
    80003ff0:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003ff4:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003ff8:	02f71863          	bne	a4,a5,80004028 <piperead+0x68>
    80003ffc:	2244a783          	lw	a5,548(s1)
    80004000:	cf9d                	beqz	a5,8000403e <piperead+0x7e>
    if(pr->killed){
    80004002:	028a2783          	lw	a5,40(s4)
    80004006:	e78d                	bnez	a5,80004030 <piperead+0x70>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004008:	85a6                	mv	a1,s1
    8000400a:	854e                	mv	a0,s3
    8000400c:	ffffd097          	auipc	ra,0xffffd
    80004010:	55c080e7          	jalr	1372(ra) # 80001568 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004014:	2184a703          	lw	a4,536(s1)
    80004018:	21c4a783          	lw	a5,540(s1)
    8000401c:	fef700e3          	beq	a4,a5,80003ffc <piperead+0x3c>
    80004020:	f05a                	sd	s6,32(sp)
    80004022:	ec5e                	sd	s7,24(sp)
    80004024:	e862                	sd	s8,16(sp)
    80004026:	a839                	j	80004044 <piperead+0x84>
    80004028:	f05a                	sd	s6,32(sp)
    8000402a:	ec5e                	sd	s7,24(sp)
    8000402c:	e862                	sd	s8,16(sp)
    8000402e:	a819                	j	80004044 <piperead+0x84>
      release(&pi->lock);
    80004030:	8526                	mv	a0,s1
    80004032:	00002097          	auipc	ra,0x2
    80004036:	340080e7          	jalr	832(ra) # 80006372 <release>
      return -1;
    8000403a:	59fd                	li	s3,-1
    8000403c:	a895                	j	800040b0 <piperead+0xf0>
    8000403e:	f05a                	sd	s6,32(sp)
    80004040:	ec5e                	sd	s7,24(sp)
    80004042:	e862                	sd	s8,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004044:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004046:	faf40c13          	addi	s8,s0,-81
    8000404a:	4b85                	li	s7,1
    8000404c:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000404e:	05505363          	blez	s5,80004094 <piperead+0xd4>
    if(pi->nread == pi->nwrite)
    80004052:	2184a783          	lw	a5,536(s1)
    80004056:	21c4a703          	lw	a4,540(s1)
    8000405a:	02f70d63          	beq	a4,a5,80004094 <piperead+0xd4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    8000405e:	0017871b          	addiw	a4,a5,1
    80004062:	20e4ac23          	sw	a4,536(s1)
    80004066:	1ff7f793          	andi	a5,a5,511
    8000406a:	97a6                	add	a5,a5,s1
    8000406c:	0187c783          	lbu	a5,24(a5)
    80004070:	faf407a3          	sb	a5,-81(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004074:	86de                	mv	a3,s7
    80004076:	8662                	mv	a2,s8
    80004078:	85ca                	mv	a1,s2
    8000407a:	050a3503          	ld	a0,80(s4)
    8000407e:	ffffd097          	auipc	ra,0xffffd
    80004082:	ad0080e7          	jalr	-1328(ra) # 80000b4e <copyout>
    80004086:	01650763          	beq	a0,s6,80004094 <piperead+0xd4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000408a:	2985                	addiw	s3,s3,1
    8000408c:	0905                	addi	s2,s2,1
    8000408e:	fd3a92e3          	bne	s5,s3,80004052 <piperead+0x92>
    80004092:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004094:	21c48513          	addi	a0,s1,540
    80004098:	ffffd097          	auipc	ra,0xffffd
    8000409c:	656080e7          	jalr	1622(ra) # 800016ee <wakeup>
  release(&pi->lock);
    800040a0:	8526                	mv	a0,s1
    800040a2:	00002097          	auipc	ra,0x2
    800040a6:	2d0080e7          	jalr	720(ra) # 80006372 <release>
    800040aa:	7b02                	ld	s6,32(sp)
    800040ac:	6be2                	ld	s7,24(sp)
    800040ae:	6c42                	ld	s8,16(sp)
  return i;
}
    800040b0:	854e                	mv	a0,s3
    800040b2:	60e6                	ld	ra,88(sp)
    800040b4:	6446                	ld	s0,80(sp)
    800040b6:	64a6                	ld	s1,72(sp)
    800040b8:	6906                	ld	s2,64(sp)
    800040ba:	79e2                	ld	s3,56(sp)
    800040bc:	7a42                	ld	s4,48(sp)
    800040be:	7aa2                	ld	s5,40(sp)
    800040c0:	6125                	addi	sp,sp,96
    800040c2:	8082                	ret

00000000800040c4 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    800040c4:	de010113          	addi	sp,sp,-544
    800040c8:	20113c23          	sd	ra,536(sp)
    800040cc:	20813823          	sd	s0,528(sp)
    800040d0:	20913423          	sd	s1,520(sp)
    800040d4:	21213023          	sd	s2,512(sp)
    800040d8:	1400                	addi	s0,sp,544
    800040da:	892a                	mv	s2,a0
    800040dc:	dea43823          	sd	a0,-528(s0)
    800040e0:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800040e4:	ffffd097          	auipc	ra,0xffffd
    800040e8:	db2080e7          	jalr	-590(ra) # 80000e96 <myproc>
    800040ec:	84aa                	mv	s1,a0

  begin_op();
    800040ee:	fffff097          	auipc	ra,0xfffff
    800040f2:	428080e7          	jalr	1064(ra) # 80003516 <begin_op>

  if((ip = namei(path)) == 0){
    800040f6:	854a                	mv	a0,s2
    800040f8:	fffff097          	auipc	ra,0xfffff
    800040fc:	218080e7          	jalr	536(ra) # 80003310 <namei>
    80004100:	c525                	beqz	a0,80004168 <exec+0xa4>
    80004102:	fbd2                	sd	s4,496(sp)
    80004104:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004106:	fffff097          	auipc	ra,0xfffff
    8000410a:	a1e080e7          	jalr	-1506(ra) # 80002b24 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    8000410e:	04000713          	li	a4,64
    80004112:	4681                	li	a3,0
    80004114:	e5040613          	addi	a2,s0,-432
    80004118:	4581                	li	a1,0
    8000411a:	8552                	mv	a0,s4
    8000411c:	fffff097          	auipc	ra,0xfffff
    80004120:	cc4080e7          	jalr	-828(ra) # 80002de0 <readi>
    80004124:	04000793          	li	a5,64
    80004128:	00f51a63          	bne	a0,a5,8000413c <exec+0x78>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    8000412c:	e5042703          	lw	a4,-432(s0)
    80004130:	464c47b7          	lui	a5,0x464c4
    80004134:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004138:	02f70e63          	beq	a4,a5,80004174 <exec+0xb0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    8000413c:	8552                	mv	a0,s4
    8000413e:	fffff097          	auipc	ra,0xfffff
    80004142:	c4c080e7          	jalr	-948(ra) # 80002d8a <iunlockput>
    end_op();
    80004146:	fffff097          	auipc	ra,0xfffff
    8000414a:	44a080e7          	jalr	1098(ra) # 80003590 <end_op>
  }
  return -1;
    8000414e:	557d                	li	a0,-1
    80004150:	7a5e                	ld	s4,496(sp)
}
    80004152:	21813083          	ld	ra,536(sp)
    80004156:	21013403          	ld	s0,528(sp)
    8000415a:	20813483          	ld	s1,520(sp)
    8000415e:	20013903          	ld	s2,512(sp)
    80004162:	22010113          	addi	sp,sp,544
    80004166:	8082                	ret
    end_op();
    80004168:	fffff097          	auipc	ra,0xfffff
    8000416c:	428080e7          	jalr	1064(ra) # 80003590 <end_op>
    return -1;
    80004170:	557d                	li	a0,-1
    80004172:	b7c5                	j	80004152 <exec+0x8e>
    80004174:	f3da                	sd	s6,480(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80004176:	8526                	mv	a0,s1
    80004178:	ffffd097          	auipc	ra,0xffffd
    8000417c:	de2080e7          	jalr	-542(ra) # 80000f5a <proc_pagetable>
    80004180:	8b2a                	mv	s6,a0
    80004182:	2a050863          	beqz	a0,80004432 <exec+0x36e>
    80004186:	ffce                	sd	s3,504(sp)
    80004188:	f7d6                	sd	s5,488(sp)
    8000418a:	efde                	sd	s7,472(sp)
    8000418c:	ebe2                	sd	s8,464(sp)
    8000418e:	e7e6                	sd	s9,456(sp)
    80004190:	e3ea                	sd	s10,448(sp)
    80004192:	ff6e                	sd	s11,440(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004194:	e7042683          	lw	a3,-400(s0)
    80004198:	e8845783          	lhu	a5,-376(s0)
    8000419c:	cbfd                	beqz	a5,80004292 <exec+0x1ce>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000419e:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800041a0:	4d01                	li	s10,0
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800041a2:	03800d93          	li	s11,56
    if((ph.vaddr % PGSIZE) != 0)
    800041a6:	6c85                	lui	s9,0x1
    800041a8:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800041ac:	def43423          	sd	a5,-536(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    800041b0:	6a85                	lui	s5,0x1
    800041b2:	a0b5                	j	8000421e <exec+0x15a>
      panic("loadseg: address should exist");
    800041b4:	00004517          	auipc	a0,0x4
    800041b8:	39c50513          	addi	a0,a0,924 # 80008550 <etext+0x550>
    800041bc:	00002097          	auipc	ra,0x2
    800041c0:	bb0080e7          	jalr	-1104(ra) # 80005d6c <panic>
    if(sz - i < PGSIZE)
    800041c4:	2901                	sext.w	s2,s2
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800041c6:	874a                	mv	a4,s2
    800041c8:	009c06bb          	addw	a3,s8,s1
    800041cc:	4581                	li	a1,0
    800041ce:	8552                	mv	a0,s4
    800041d0:	fffff097          	auipc	ra,0xfffff
    800041d4:	c10080e7          	jalr	-1008(ra) # 80002de0 <readi>
    800041d8:	26a91163          	bne	s2,a0,8000443a <exec+0x376>
  for(i = 0; i < sz; i += PGSIZE){
    800041dc:	009a84bb          	addw	s1,s5,s1
    800041e0:	0334f463          	bgeu	s1,s3,80004208 <exec+0x144>
    pa = walkaddr(pagetable, va + i);
    800041e4:	02049593          	slli	a1,s1,0x20
    800041e8:	9181                	srli	a1,a1,0x20
    800041ea:	95de                	add	a1,a1,s7
    800041ec:	855a                	mv	a0,s6
    800041ee:	ffffc097          	auipc	ra,0xffffc
    800041f2:	32a080e7          	jalr	810(ra) # 80000518 <walkaddr>
    800041f6:	862a                	mv	a2,a0
    if(pa == 0)
    800041f8:	dd55                	beqz	a0,800041b4 <exec+0xf0>
    if(sz - i < PGSIZE)
    800041fa:	409987bb          	subw	a5,s3,s1
    800041fe:	893e                	mv	s2,a5
    80004200:	fcfcf2e3          	bgeu	s9,a5,800041c4 <exec+0x100>
    80004204:	8956                	mv	s2,s5
    80004206:	bf7d                	j	800041c4 <exec+0x100>
    sz = sz1;
    80004208:	df843483          	ld	s1,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000420c:	2d05                	addiw	s10,s10,1
    8000420e:	e0843783          	ld	a5,-504(s0)
    80004212:	0387869b          	addiw	a3,a5,56
    80004216:	e8845783          	lhu	a5,-376(s0)
    8000421a:	06fd5d63          	bge	s10,a5,80004294 <exec+0x1d0>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000421e:	e0d43423          	sd	a3,-504(s0)
    80004222:	876e                	mv	a4,s11
    80004224:	e1840613          	addi	a2,s0,-488
    80004228:	4581                	li	a1,0
    8000422a:	8552                	mv	a0,s4
    8000422c:	fffff097          	auipc	ra,0xfffff
    80004230:	bb4080e7          	jalr	-1100(ra) # 80002de0 <readi>
    80004234:	21b51163          	bne	a0,s11,80004436 <exec+0x372>
    if(ph.type != ELF_PROG_LOAD)
    80004238:	e1842783          	lw	a5,-488(s0)
    8000423c:	4705                	li	a4,1
    8000423e:	fce797e3          	bne	a5,a4,8000420c <exec+0x148>
    if(ph.memsz < ph.filesz)
    80004242:	e4043603          	ld	a2,-448(s0)
    80004246:	e3843783          	ld	a5,-456(s0)
    8000424a:	20f66863          	bltu	a2,a5,8000445a <exec+0x396>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    8000424e:	e2843783          	ld	a5,-472(s0)
    80004252:	963e                	add	a2,a2,a5
    80004254:	20f66663          	bltu	a2,a5,80004460 <exec+0x39c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004258:	85a6                	mv	a1,s1
    8000425a:	855a                	mv	a0,s6
    8000425c:	ffffc097          	auipc	ra,0xffffc
    80004260:	680080e7          	jalr	1664(ra) # 800008dc <uvmalloc>
    80004264:	dea43c23          	sd	a0,-520(s0)
    80004268:	1e050f63          	beqz	a0,80004466 <exec+0x3a2>
    if((ph.vaddr % PGSIZE) != 0)
    8000426c:	e2843b83          	ld	s7,-472(s0)
    80004270:	de843783          	ld	a5,-536(s0)
    80004274:	00fbf7b3          	and	a5,s7,a5
    80004278:	1c079163          	bnez	a5,8000443a <exec+0x376>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000427c:	e2042c03          	lw	s8,-480(s0)
    80004280:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004284:	00098463          	beqz	s3,8000428c <exec+0x1c8>
    80004288:	4481                	li	s1,0
    8000428a:	bfa9                	j	800041e4 <exec+0x120>
    sz = sz1;
    8000428c:	df843483          	ld	s1,-520(s0)
    80004290:	bfb5                	j	8000420c <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004292:	4481                	li	s1,0
  iunlockput(ip);
    80004294:	8552                	mv	a0,s4
    80004296:	fffff097          	auipc	ra,0xfffff
    8000429a:	af4080e7          	jalr	-1292(ra) # 80002d8a <iunlockput>
  end_op();
    8000429e:	fffff097          	auipc	ra,0xfffff
    800042a2:	2f2080e7          	jalr	754(ra) # 80003590 <end_op>
  p = myproc();
    800042a6:	ffffd097          	auipc	ra,0xffffd
    800042aa:	bf0080e7          	jalr	-1040(ra) # 80000e96 <myproc>
    800042ae:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800042b0:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    800042b4:	6985                	lui	s3,0x1
    800042b6:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    800042b8:	99a6                	add	s3,s3,s1
    800042ba:	77fd                	lui	a5,0xfffff
    800042bc:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800042c0:	6609                	lui	a2,0x2
    800042c2:	964e                	add	a2,a2,s3
    800042c4:	85ce                	mv	a1,s3
    800042c6:	855a                	mv	a0,s6
    800042c8:	ffffc097          	auipc	ra,0xffffc
    800042cc:	614080e7          	jalr	1556(ra) # 800008dc <uvmalloc>
    800042d0:	8a2a                	mv	s4,a0
    800042d2:	e115                	bnez	a0,800042f6 <exec+0x232>
    proc_freepagetable(pagetable, sz);
    800042d4:	85ce                	mv	a1,s3
    800042d6:	855a                	mv	a0,s6
    800042d8:	ffffd097          	auipc	ra,0xffffd
    800042dc:	d1e080e7          	jalr	-738(ra) # 80000ff6 <proc_freepagetable>
  return -1;
    800042e0:	557d                	li	a0,-1
    800042e2:	79fe                	ld	s3,504(sp)
    800042e4:	7a5e                	ld	s4,496(sp)
    800042e6:	7abe                	ld	s5,488(sp)
    800042e8:	7b1e                	ld	s6,480(sp)
    800042ea:	6bfe                	ld	s7,472(sp)
    800042ec:	6c5e                	ld	s8,464(sp)
    800042ee:	6cbe                	ld	s9,456(sp)
    800042f0:	6d1e                	ld	s10,448(sp)
    800042f2:	7dfa                	ld	s11,440(sp)
    800042f4:	bdb9                	j	80004152 <exec+0x8e>
  uvmclear(pagetable, sz-2*PGSIZE);
    800042f6:	75f9                	lui	a1,0xffffe
    800042f8:	95aa                	add	a1,a1,a0
    800042fa:	855a                	mv	a0,s6
    800042fc:	ffffd097          	auipc	ra,0xffffd
    80004300:	820080e7          	jalr	-2016(ra) # 80000b1c <uvmclear>
  stackbase = sp - PGSIZE;
    80004304:	7bfd                	lui	s7,0xfffff
    80004306:	9bd2                	add	s7,s7,s4
  for(argc = 0; argv[argc]; argc++) {
    80004308:	e0043783          	ld	a5,-512(s0)
    8000430c:	6388                	ld	a0,0(a5)
  sp = sz;
    8000430e:	8952                	mv	s2,s4
  for(argc = 0; argv[argc]; argc++) {
    80004310:	4481                	li	s1,0
    ustack[argc] = sp;
    80004312:	e9040c93          	addi	s9,s0,-368
    if(argc >= MAXARG)
    80004316:	02000c13          	li	s8,32
  for(argc = 0; argv[argc]; argc++) {
    8000431a:	c135                	beqz	a0,8000437e <exec+0x2ba>
    sp -= strlen(argv[argc]) + 1;
    8000431c:	ffffc097          	auipc	ra,0xffffc
    80004320:	fea080e7          	jalr	-22(ra) # 80000306 <strlen>
    80004324:	0015079b          	addiw	a5,a0,1
    80004328:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    8000432c:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80004330:	13796e63          	bltu	s2,s7,8000446c <exec+0x3a8>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004334:	e0043d83          	ld	s11,-512(s0)
    80004338:	000db983          	ld	s3,0(s11)
    8000433c:	854e                	mv	a0,s3
    8000433e:	ffffc097          	auipc	ra,0xffffc
    80004342:	fc8080e7          	jalr	-56(ra) # 80000306 <strlen>
    80004346:	0015069b          	addiw	a3,a0,1
    8000434a:	864e                	mv	a2,s3
    8000434c:	85ca                	mv	a1,s2
    8000434e:	855a                	mv	a0,s6
    80004350:	ffffc097          	auipc	ra,0xffffc
    80004354:	7fe080e7          	jalr	2046(ra) # 80000b4e <copyout>
    80004358:	10054c63          	bltz	a0,80004470 <exec+0x3ac>
    ustack[argc] = sp;
    8000435c:	00349793          	slli	a5,s1,0x3
    80004360:	97e6                	add	a5,a5,s9
    80004362:	0127b023          	sd	s2,0(a5) # fffffffffffff000 <end+0xffffffff7ffd8dc0>
  for(argc = 0; argv[argc]; argc++) {
    80004366:	0485                	addi	s1,s1,1
    80004368:	008d8793          	addi	a5,s11,8
    8000436c:	e0f43023          	sd	a5,-512(s0)
    80004370:	008db503          	ld	a0,8(s11)
    80004374:	c509                	beqz	a0,8000437e <exec+0x2ba>
    if(argc >= MAXARG)
    80004376:	fb8493e3          	bne	s1,s8,8000431c <exec+0x258>
  sz = sz1;
    8000437a:	89d2                	mv	s3,s4
    8000437c:	bfa1                	j	800042d4 <exec+0x210>
  ustack[argc] = 0;
    8000437e:	00349793          	slli	a5,s1,0x3
    80004382:	f9078793          	addi	a5,a5,-112
    80004386:	97a2                	add	a5,a5,s0
    80004388:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    8000438c:	00148693          	addi	a3,s1,1
    80004390:	068e                	slli	a3,a3,0x3
    80004392:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004396:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    8000439a:	89d2                	mv	s3,s4
  if(sp < stackbase)
    8000439c:	f3796ce3          	bltu	s2,s7,800042d4 <exec+0x210>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800043a0:	e9040613          	addi	a2,s0,-368
    800043a4:	85ca                	mv	a1,s2
    800043a6:	855a                	mv	a0,s6
    800043a8:	ffffc097          	auipc	ra,0xffffc
    800043ac:	7a6080e7          	jalr	1958(ra) # 80000b4e <copyout>
    800043b0:	f20542e3          	bltz	a0,800042d4 <exec+0x210>
  p->trapframe->a1 = sp;
    800043b4:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    800043b8:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800043bc:	df043783          	ld	a5,-528(s0)
    800043c0:	0007c703          	lbu	a4,0(a5)
    800043c4:	cf11                	beqz	a4,800043e0 <exec+0x31c>
    800043c6:	0785                	addi	a5,a5,1
    if(*s == '/')
    800043c8:	02f00693          	li	a3,47
    800043cc:	a029                	j	800043d6 <exec+0x312>
  for(last=s=path; *s; s++)
    800043ce:	0785                	addi	a5,a5,1
    800043d0:	fff7c703          	lbu	a4,-1(a5)
    800043d4:	c711                	beqz	a4,800043e0 <exec+0x31c>
    if(*s == '/')
    800043d6:	fed71ce3          	bne	a4,a3,800043ce <exec+0x30a>
      last = s+1;
    800043da:	def43823          	sd	a5,-528(s0)
    800043de:	bfc5                	j	800043ce <exec+0x30a>
  safestrcpy(p->name, last, sizeof(p->name));
    800043e0:	4641                	li	a2,16
    800043e2:	df043583          	ld	a1,-528(s0)
    800043e6:	158a8513          	addi	a0,s5,344
    800043ea:	ffffc097          	auipc	ra,0xffffc
    800043ee:	ee6080e7          	jalr	-282(ra) # 800002d0 <safestrcpy>
  oldpagetable = p->pagetable;
    800043f2:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    800043f6:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    800043fa:	054ab423          	sd	s4,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800043fe:	058ab783          	ld	a5,88(s5)
    80004402:	e6843703          	ld	a4,-408(s0)
    80004406:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004408:	058ab783          	ld	a5,88(s5)
    8000440c:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004410:	85ea                	mv	a1,s10
    80004412:	ffffd097          	auipc	ra,0xffffd
    80004416:	be4080e7          	jalr	-1052(ra) # 80000ff6 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000441a:	0004851b          	sext.w	a0,s1
    8000441e:	79fe                	ld	s3,504(sp)
    80004420:	7a5e                	ld	s4,496(sp)
    80004422:	7abe                	ld	s5,488(sp)
    80004424:	7b1e                	ld	s6,480(sp)
    80004426:	6bfe                	ld	s7,472(sp)
    80004428:	6c5e                	ld	s8,464(sp)
    8000442a:	6cbe                	ld	s9,456(sp)
    8000442c:	6d1e                	ld	s10,448(sp)
    8000442e:	7dfa                	ld	s11,440(sp)
    80004430:	b30d                	j	80004152 <exec+0x8e>
    80004432:	7b1e                	ld	s6,480(sp)
    80004434:	b321                	j	8000413c <exec+0x78>
    80004436:	de943c23          	sd	s1,-520(s0)
    proc_freepagetable(pagetable, sz);
    8000443a:	df843583          	ld	a1,-520(s0)
    8000443e:	855a                	mv	a0,s6
    80004440:	ffffd097          	auipc	ra,0xffffd
    80004444:	bb6080e7          	jalr	-1098(ra) # 80000ff6 <proc_freepagetable>
  if(ip){
    80004448:	79fe                	ld	s3,504(sp)
    8000444a:	7abe                	ld	s5,488(sp)
    8000444c:	7b1e                	ld	s6,480(sp)
    8000444e:	6bfe                	ld	s7,472(sp)
    80004450:	6c5e                	ld	s8,464(sp)
    80004452:	6cbe                	ld	s9,456(sp)
    80004454:	6d1e                	ld	s10,448(sp)
    80004456:	7dfa                	ld	s11,440(sp)
    80004458:	b1d5                	j	8000413c <exec+0x78>
    8000445a:	de943c23          	sd	s1,-520(s0)
    8000445e:	bff1                	j	8000443a <exec+0x376>
    80004460:	de943c23          	sd	s1,-520(s0)
    80004464:	bfd9                	j	8000443a <exec+0x376>
    80004466:	de943c23          	sd	s1,-520(s0)
    8000446a:	bfc1                	j	8000443a <exec+0x376>
  sz = sz1;
    8000446c:	89d2                	mv	s3,s4
    8000446e:	b59d                	j	800042d4 <exec+0x210>
    80004470:	89d2                	mv	s3,s4
    80004472:	b58d                	j	800042d4 <exec+0x210>

0000000080004474 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004474:	7179                	addi	sp,sp,-48
    80004476:	f406                	sd	ra,40(sp)
    80004478:	f022                	sd	s0,32(sp)
    8000447a:	ec26                	sd	s1,24(sp)
    8000447c:	e84a                	sd	s2,16(sp)
    8000447e:	1800                	addi	s0,sp,48
    80004480:	892e                	mv	s2,a1
    80004482:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80004484:	fdc40593          	addi	a1,s0,-36
    80004488:	ffffe097          	auipc	ra,0xffffe
    8000448c:	ad8080e7          	jalr	-1320(ra) # 80001f60 <argint>
    80004490:	04054063          	bltz	a0,800044d0 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004494:	fdc42703          	lw	a4,-36(s0)
    80004498:	47bd                	li	a5,15
    8000449a:	02e7ed63          	bltu	a5,a4,800044d4 <argfd+0x60>
    8000449e:	ffffd097          	auipc	ra,0xffffd
    800044a2:	9f8080e7          	jalr	-1544(ra) # 80000e96 <myproc>
    800044a6:	fdc42703          	lw	a4,-36(s0)
    800044aa:	01a70793          	addi	a5,a4,26
    800044ae:	078e                	slli	a5,a5,0x3
    800044b0:	953e                	add	a0,a0,a5
    800044b2:	611c                	ld	a5,0(a0)
    800044b4:	c395                	beqz	a5,800044d8 <argfd+0x64>
    return -1;
  if(pfd)
    800044b6:	00090463          	beqz	s2,800044be <argfd+0x4a>
    *pfd = fd;
    800044ba:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800044be:	4501                	li	a0,0
  if(pf)
    800044c0:	c091                	beqz	s1,800044c4 <argfd+0x50>
    *pf = f;
    800044c2:	e09c                	sd	a5,0(s1)
}
    800044c4:	70a2                	ld	ra,40(sp)
    800044c6:	7402                	ld	s0,32(sp)
    800044c8:	64e2                	ld	s1,24(sp)
    800044ca:	6942                	ld	s2,16(sp)
    800044cc:	6145                	addi	sp,sp,48
    800044ce:	8082                	ret
    return -1;
    800044d0:	557d                	li	a0,-1
    800044d2:	bfcd                	j	800044c4 <argfd+0x50>
    return -1;
    800044d4:	557d                	li	a0,-1
    800044d6:	b7fd                	j	800044c4 <argfd+0x50>
    800044d8:	557d                	li	a0,-1
    800044da:	b7ed                	j	800044c4 <argfd+0x50>

00000000800044dc <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800044dc:	1101                	addi	sp,sp,-32
    800044de:	ec06                	sd	ra,24(sp)
    800044e0:	e822                	sd	s0,16(sp)
    800044e2:	e426                	sd	s1,8(sp)
    800044e4:	1000                	addi	s0,sp,32
    800044e6:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800044e8:	ffffd097          	auipc	ra,0xffffd
    800044ec:	9ae080e7          	jalr	-1618(ra) # 80000e96 <myproc>
    800044f0:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800044f2:	0d050793          	addi	a5,a0,208
    800044f6:	4501                	li	a0,0
    800044f8:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800044fa:	6398                	ld	a4,0(a5)
    800044fc:	cb19                	beqz	a4,80004512 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800044fe:	2505                	addiw	a0,a0,1
    80004500:	07a1                	addi	a5,a5,8
    80004502:	fed51ce3          	bne	a0,a3,800044fa <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004506:	557d                	li	a0,-1
}
    80004508:	60e2                	ld	ra,24(sp)
    8000450a:	6442                	ld	s0,16(sp)
    8000450c:	64a2                	ld	s1,8(sp)
    8000450e:	6105                	addi	sp,sp,32
    80004510:	8082                	ret
      p->ofile[fd] = f;
    80004512:	01a50793          	addi	a5,a0,26
    80004516:	078e                	slli	a5,a5,0x3
    80004518:	963e                	add	a2,a2,a5
    8000451a:	e204                	sd	s1,0(a2)
      return fd;
    8000451c:	b7f5                	j	80004508 <fdalloc+0x2c>

000000008000451e <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    8000451e:	715d                	addi	sp,sp,-80
    80004520:	e486                	sd	ra,72(sp)
    80004522:	e0a2                	sd	s0,64(sp)
    80004524:	fc26                	sd	s1,56(sp)
    80004526:	f84a                	sd	s2,48(sp)
    80004528:	f44e                	sd	s3,40(sp)
    8000452a:	f052                	sd	s4,32(sp)
    8000452c:	ec56                	sd	s5,24(sp)
    8000452e:	0880                	addi	s0,sp,80
    80004530:	8aae                	mv	s5,a1
    80004532:	8a32                	mv	s4,a2
    80004534:	89b6                	mv	s3,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004536:	fb040593          	addi	a1,s0,-80
    8000453a:	fffff097          	auipc	ra,0xfffff
    8000453e:	df4080e7          	jalr	-524(ra) # 8000332e <nameiparent>
    80004542:	892a                	mv	s2,a0
    80004544:	12050c63          	beqz	a0,8000467c <create+0x15e>
    return 0;

  ilock(dp);
    80004548:	ffffe097          	auipc	ra,0xffffe
    8000454c:	5dc080e7          	jalr	1500(ra) # 80002b24 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004550:	4601                	li	a2,0
    80004552:	fb040593          	addi	a1,s0,-80
    80004556:	854a                	mv	a0,s2
    80004558:	fffff097          	auipc	ra,0xfffff
    8000455c:	abc080e7          	jalr	-1348(ra) # 80003014 <dirlookup>
    80004560:	84aa                	mv	s1,a0
    80004562:	c539                	beqz	a0,800045b0 <create+0x92>
    iunlockput(dp);
    80004564:	854a                	mv	a0,s2
    80004566:	fffff097          	auipc	ra,0xfffff
    8000456a:	824080e7          	jalr	-2012(ra) # 80002d8a <iunlockput>
    ilock(ip);
    8000456e:	8526                	mv	a0,s1
    80004570:	ffffe097          	auipc	ra,0xffffe
    80004574:	5b4080e7          	jalr	1460(ra) # 80002b24 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004578:	4789                	li	a5,2
    8000457a:	02fa9463          	bne	s5,a5,800045a2 <create+0x84>
    8000457e:	0444d783          	lhu	a5,68(s1)
    80004582:	37f9                	addiw	a5,a5,-2
    80004584:	17c2                	slli	a5,a5,0x30
    80004586:	93c1                	srli	a5,a5,0x30
    80004588:	4705                	li	a4,1
    8000458a:	00f76c63          	bltu	a4,a5,800045a2 <create+0x84>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    8000458e:	8526                	mv	a0,s1
    80004590:	60a6                	ld	ra,72(sp)
    80004592:	6406                	ld	s0,64(sp)
    80004594:	74e2                	ld	s1,56(sp)
    80004596:	7942                	ld	s2,48(sp)
    80004598:	79a2                	ld	s3,40(sp)
    8000459a:	7a02                	ld	s4,32(sp)
    8000459c:	6ae2                	ld	s5,24(sp)
    8000459e:	6161                	addi	sp,sp,80
    800045a0:	8082                	ret
    iunlockput(ip);
    800045a2:	8526                	mv	a0,s1
    800045a4:	ffffe097          	auipc	ra,0xffffe
    800045a8:	7e6080e7          	jalr	2022(ra) # 80002d8a <iunlockput>
    return 0;
    800045ac:	4481                	li	s1,0
    800045ae:	b7c5                	j	8000458e <create+0x70>
  if((ip = ialloc(dp->dev, type)) == 0)
    800045b0:	85d6                	mv	a1,s5
    800045b2:	00092503          	lw	a0,0(s2)
    800045b6:	ffffe097          	auipc	ra,0xffffe
    800045ba:	3da080e7          	jalr	986(ra) # 80002990 <ialloc>
    800045be:	84aa                	mv	s1,a0
    800045c0:	c139                	beqz	a0,80004606 <create+0xe8>
  ilock(ip);
    800045c2:	ffffe097          	auipc	ra,0xffffe
    800045c6:	562080e7          	jalr	1378(ra) # 80002b24 <ilock>
  ip->major = major;
    800045ca:	05449323          	sh	s4,70(s1)
  ip->minor = minor;
    800045ce:	05349423          	sh	s3,72(s1)
  ip->nlink = 1;
    800045d2:	4985                	li	s3,1
    800045d4:	05349523          	sh	s3,74(s1)
  iupdate(ip);
    800045d8:	8526                	mv	a0,s1
    800045da:	ffffe097          	auipc	ra,0xffffe
    800045de:	47e080e7          	jalr	1150(ra) # 80002a58 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800045e2:	033a8a63          	beq	s5,s3,80004616 <create+0xf8>
  if(dirlink(dp, name, ip->inum) < 0)
    800045e6:	40d0                	lw	a2,4(s1)
    800045e8:	fb040593          	addi	a1,s0,-80
    800045ec:	854a                	mv	a0,s2
    800045ee:	fffff097          	auipc	ra,0xfffff
    800045f2:	c4c080e7          	jalr	-948(ra) # 8000323a <dirlink>
    800045f6:	06054b63          	bltz	a0,8000466c <create+0x14e>
  iunlockput(dp);
    800045fa:	854a                	mv	a0,s2
    800045fc:	ffffe097          	auipc	ra,0xffffe
    80004600:	78e080e7          	jalr	1934(ra) # 80002d8a <iunlockput>
  return ip;
    80004604:	b769                	j	8000458e <create+0x70>
    panic("create: ialloc");
    80004606:	00004517          	auipc	a0,0x4
    8000460a:	f6a50513          	addi	a0,a0,-150 # 80008570 <etext+0x570>
    8000460e:	00001097          	auipc	ra,0x1
    80004612:	75e080e7          	jalr	1886(ra) # 80005d6c <panic>
    dp->nlink++;  // for ".."
    80004616:	04a95783          	lhu	a5,74(s2)
    8000461a:	2785                	addiw	a5,a5,1
    8000461c:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    80004620:	854a                	mv	a0,s2
    80004622:	ffffe097          	auipc	ra,0xffffe
    80004626:	436080e7          	jalr	1078(ra) # 80002a58 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000462a:	40d0                	lw	a2,4(s1)
    8000462c:	00004597          	auipc	a1,0x4
    80004630:	f5458593          	addi	a1,a1,-172 # 80008580 <etext+0x580>
    80004634:	8526                	mv	a0,s1
    80004636:	fffff097          	auipc	ra,0xfffff
    8000463a:	c04080e7          	jalr	-1020(ra) # 8000323a <dirlink>
    8000463e:	00054f63          	bltz	a0,8000465c <create+0x13e>
    80004642:	00492603          	lw	a2,4(s2)
    80004646:	00004597          	auipc	a1,0x4
    8000464a:	f4258593          	addi	a1,a1,-190 # 80008588 <etext+0x588>
    8000464e:	8526                	mv	a0,s1
    80004650:	fffff097          	auipc	ra,0xfffff
    80004654:	bea080e7          	jalr	-1046(ra) # 8000323a <dirlink>
    80004658:	f80557e3          	bgez	a0,800045e6 <create+0xc8>
      panic("create dots");
    8000465c:	00004517          	auipc	a0,0x4
    80004660:	f3450513          	addi	a0,a0,-204 # 80008590 <etext+0x590>
    80004664:	00001097          	auipc	ra,0x1
    80004668:	708080e7          	jalr	1800(ra) # 80005d6c <panic>
    panic("create: dirlink");
    8000466c:	00004517          	auipc	a0,0x4
    80004670:	f3450513          	addi	a0,a0,-204 # 800085a0 <etext+0x5a0>
    80004674:	00001097          	auipc	ra,0x1
    80004678:	6f8080e7          	jalr	1784(ra) # 80005d6c <panic>
    return 0;
    8000467c:	84aa                	mv	s1,a0
    8000467e:	bf01                	j	8000458e <create+0x70>

0000000080004680 <sys_dup>:
{
    80004680:	7179                	addi	sp,sp,-48
    80004682:	f406                	sd	ra,40(sp)
    80004684:	f022                	sd	s0,32(sp)
    80004686:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004688:	fd840613          	addi	a2,s0,-40
    8000468c:	4581                	li	a1,0
    8000468e:	4501                	li	a0,0
    80004690:	00000097          	auipc	ra,0x0
    80004694:	de4080e7          	jalr	-540(ra) # 80004474 <argfd>
    return -1;
    80004698:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000469a:	02054763          	bltz	a0,800046c8 <sys_dup+0x48>
    8000469e:	ec26                	sd	s1,24(sp)
    800046a0:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    800046a2:	fd843903          	ld	s2,-40(s0)
    800046a6:	854a                	mv	a0,s2
    800046a8:	00000097          	auipc	ra,0x0
    800046ac:	e34080e7          	jalr	-460(ra) # 800044dc <fdalloc>
    800046b0:	84aa                	mv	s1,a0
    return -1;
    800046b2:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800046b4:	00054f63          	bltz	a0,800046d2 <sys_dup+0x52>
  filedup(f);
    800046b8:	854a                	mv	a0,s2
    800046ba:	fffff097          	auipc	ra,0xfffff
    800046be:	2da080e7          	jalr	730(ra) # 80003994 <filedup>
  return fd;
    800046c2:	87a6                	mv	a5,s1
    800046c4:	64e2                	ld	s1,24(sp)
    800046c6:	6942                	ld	s2,16(sp)
}
    800046c8:	853e                	mv	a0,a5
    800046ca:	70a2                	ld	ra,40(sp)
    800046cc:	7402                	ld	s0,32(sp)
    800046ce:	6145                	addi	sp,sp,48
    800046d0:	8082                	ret
    800046d2:	64e2                	ld	s1,24(sp)
    800046d4:	6942                	ld	s2,16(sp)
    800046d6:	bfcd                	j	800046c8 <sys_dup+0x48>

00000000800046d8 <sys_read>:
{
    800046d8:	7179                	addi	sp,sp,-48
    800046da:	f406                	sd	ra,40(sp)
    800046dc:	f022                	sd	s0,32(sp)
    800046de:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046e0:	fe840613          	addi	a2,s0,-24
    800046e4:	4581                	li	a1,0
    800046e6:	4501                	li	a0,0
    800046e8:	00000097          	auipc	ra,0x0
    800046ec:	d8c080e7          	jalr	-628(ra) # 80004474 <argfd>
    return -1;
    800046f0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046f2:	04054163          	bltz	a0,80004734 <sys_read+0x5c>
    800046f6:	fe440593          	addi	a1,s0,-28
    800046fa:	4509                	li	a0,2
    800046fc:	ffffe097          	auipc	ra,0xffffe
    80004700:	864080e7          	jalr	-1948(ra) # 80001f60 <argint>
    return -1;
    80004704:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004706:	02054763          	bltz	a0,80004734 <sys_read+0x5c>
    8000470a:	fd840593          	addi	a1,s0,-40
    8000470e:	4505                	li	a0,1
    80004710:	ffffe097          	auipc	ra,0xffffe
    80004714:	872080e7          	jalr	-1934(ra) # 80001f82 <argaddr>
    return -1;
    80004718:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000471a:	00054d63          	bltz	a0,80004734 <sys_read+0x5c>
  return fileread(f, p, n);
    8000471e:	fe442603          	lw	a2,-28(s0)
    80004722:	fd843583          	ld	a1,-40(s0)
    80004726:	fe843503          	ld	a0,-24(s0)
    8000472a:	fffff097          	auipc	ra,0xfffff
    8000472e:	410080e7          	jalr	1040(ra) # 80003b3a <fileread>
    80004732:	87aa                	mv	a5,a0
}
    80004734:	853e                	mv	a0,a5
    80004736:	70a2                	ld	ra,40(sp)
    80004738:	7402                	ld	s0,32(sp)
    8000473a:	6145                	addi	sp,sp,48
    8000473c:	8082                	ret

000000008000473e <sys_write>:
{
    8000473e:	7179                	addi	sp,sp,-48
    80004740:	f406                	sd	ra,40(sp)
    80004742:	f022                	sd	s0,32(sp)
    80004744:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004746:	fe840613          	addi	a2,s0,-24
    8000474a:	4581                	li	a1,0
    8000474c:	4501                	li	a0,0
    8000474e:	00000097          	auipc	ra,0x0
    80004752:	d26080e7          	jalr	-730(ra) # 80004474 <argfd>
    return -1;
    80004756:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004758:	04054163          	bltz	a0,8000479a <sys_write+0x5c>
    8000475c:	fe440593          	addi	a1,s0,-28
    80004760:	4509                	li	a0,2
    80004762:	ffffd097          	auipc	ra,0xffffd
    80004766:	7fe080e7          	jalr	2046(ra) # 80001f60 <argint>
    return -1;
    8000476a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000476c:	02054763          	bltz	a0,8000479a <sys_write+0x5c>
    80004770:	fd840593          	addi	a1,s0,-40
    80004774:	4505                	li	a0,1
    80004776:	ffffe097          	auipc	ra,0xffffe
    8000477a:	80c080e7          	jalr	-2036(ra) # 80001f82 <argaddr>
    return -1;
    8000477e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004780:	00054d63          	bltz	a0,8000479a <sys_write+0x5c>
  return filewrite(f, p, n);
    80004784:	fe442603          	lw	a2,-28(s0)
    80004788:	fd843583          	ld	a1,-40(s0)
    8000478c:	fe843503          	ld	a0,-24(s0)
    80004790:	fffff097          	auipc	ra,0xfffff
    80004794:	47c080e7          	jalr	1148(ra) # 80003c0c <filewrite>
    80004798:	87aa                	mv	a5,a0
}
    8000479a:	853e                	mv	a0,a5
    8000479c:	70a2                	ld	ra,40(sp)
    8000479e:	7402                	ld	s0,32(sp)
    800047a0:	6145                	addi	sp,sp,48
    800047a2:	8082                	ret

00000000800047a4 <sys_close>:
{
    800047a4:	1101                	addi	sp,sp,-32
    800047a6:	ec06                	sd	ra,24(sp)
    800047a8:	e822                	sd	s0,16(sp)
    800047aa:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800047ac:	fe040613          	addi	a2,s0,-32
    800047b0:	fec40593          	addi	a1,s0,-20
    800047b4:	4501                	li	a0,0
    800047b6:	00000097          	auipc	ra,0x0
    800047ba:	cbe080e7          	jalr	-834(ra) # 80004474 <argfd>
    return -1;
    800047be:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800047c0:	02054463          	bltz	a0,800047e8 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800047c4:	ffffc097          	auipc	ra,0xffffc
    800047c8:	6d2080e7          	jalr	1746(ra) # 80000e96 <myproc>
    800047cc:	fec42783          	lw	a5,-20(s0)
    800047d0:	07e9                	addi	a5,a5,26
    800047d2:	078e                	slli	a5,a5,0x3
    800047d4:	953e                	add	a0,a0,a5
    800047d6:	00053023          	sd	zero,0(a0)
  fileclose(f);
    800047da:	fe043503          	ld	a0,-32(s0)
    800047de:	fffff097          	auipc	ra,0xfffff
    800047e2:	208080e7          	jalr	520(ra) # 800039e6 <fileclose>
  return 0;
    800047e6:	4781                	li	a5,0
}
    800047e8:	853e                	mv	a0,a5
    800047ea:	60e2                	ld	ra,24(sp)
    800047ec:	6442                	ld	s0,16(sp)
    800047ee:	6105                	addi	sp,sp,32
    800047f0:	8082                	ret

00000000800047f2 <sys_fstat>:
{
    800047f2:	1101                	addi	sp,sp,-32
    800047f4:	ec06                	sd	ra,24(sp)
    800047f6:	e822                	sd	s0,16(sp)
    800047f8:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800047fa:	fe840613          	addi	a2,s0,-24
    800047fe:	4581                	li	a1,0
    80004800:	4501                	li	a0,0
    80004802:	00000097          	auipc	ra,0x0
    80004806:	c72080e7          	jalr	-910(ra) # 80004474 <argfd>
    return -1;
    8000480a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000480c:	02054563          	bltz	a0,80004836 <sys_fstat+0x44>
    80004810:	fe040593          	addi	a1,s0,-32
    80004814:	4505                	li	a0,1
    80004816:	ffffd097          	auipc	ra,0xffffd
    8000481a:	76c080e7          	jalr	1900(ra) # 80001f82 <argaddr>
    return -1;
    8000481e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004820:	00054b63          	bltz	a0,80004836 <sys_fstat+0x44>
  return filestat(f, st);
    80004824:	fe043583          	ld	a1,-32(s0)
    80004828:	fe843503          	ld	a0,-24(s0)
    8000482c:	fffff097          	auipc	ra,0xfffff
    80004830:	298080e7          	jalr	664(ra) # 80003ac4 <filestat>
    80004834:	87aa                	mv	a5,a0
}
    80004836:	853e                	mv	a0,a5
    80004838:	60e2                	ld	ra,24(sp)
    8000483a:	6442                	ld	s0,16(sp)
    8000483c:	6105                	addi	sp,sp,32
    8000483e:	8082                	ret

0000000080004840 <sys_link>:
{
    80004840:	7169                	addi	sp,sp,-304
    80004842:	f606                	sd	ra,296(sp)
    80004844:	f222                	sd	s0,288(sp)
    80004846:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004848:	08000613          	li	a2,128
    8000484c:	ed040593          	addi	a1,s0,-304
    80004850:	4501                	li	a0,0
    80004852:	ffffd097          	auipc	ra,0xffffd
    80004856:	752080e7          	jalr	1874(ra) # 80001fa4 <argstr>
    return -1;
    8000485a:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000485c:	12054663          	bltz	a0,80004988 <sys_link+0x148>
    80004860:	08000613          	li	a2,128
    80004864:	f5040593          	addi	a1,s0,-176
    80004868:	4505                	li	a0,1
    8000486a:	ffffd097          	auipc	ra,0xffffd
    8000486e:	73a080e7          	jalr	1850(ra) # 80001fa4 <argstr>
    return -1;
    80004872:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004874:	10054a63          	bltz	a0,80004988 <sys_link+0x148>
    80004878:	ee26                	sd	s1,280(sp)
  begin_op();
    8000487a:	fffff097          	auipc	ra,0xfffff
    8000487e:	c9c080e7          	jalr	-868(ra) # 80003516 <begin_op>
  if((ip = namei(old)) == 0){
    80004882:	ed040513          	addi	a0,s0,-304
    80004886:	fffff097          	auipc	ra,0xfffff
    8000488a:	a8a080e7          	jalr	-1398(ra) # 80003310 <namei>
    8000488e:	84aa                	mv	s1,a0
    80004890:	c949                	beqz	a0,80004922 <sys_link+0xe2>
  ilock(ip);
    80004892:	ffffe097          	auipc	ra,0xffffe
    80004896:	292080e7          	jalr	658(ra) # 80002b24 <ilock>
  if(ip->type == T_DIR){
    8000489a:	04449703          	lh	a4,68(s1)
    8000489e:	4785                	li	a5,1
    800048a0:	08f70863          	beq	a4,a5,80004930 <sys_link+0xf0>
    800048a4:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    800048a6:	04a4d783          	lhu	a5,74(s1)
    800048aa:	2785                	addiw	a5,a5,1
    800048ac:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800048b0:	8526                	mv	a0,s1
    800048b2:	ffffe097          	auipc	ra,0xffffe
    800048b6:	1a6080e7          	jalr	422(ra) # 80002a58 <iupdate>
  iunlock(ip);
    800048ba:	8526                	mv	a0,s1
    800048bc:	ffffe097          	auipc	ra,0xffffe
    800048c0:	32e080e7          	jalr	814(ra) # 80002bea <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800048c4:	fd040593          	addi	a1,s0,-48
    800048c8:	f5040513          	addi	a0,s0,-176
    800048cc:	fffff097          	auipc	ra,0xfffff
    800048d0:	a62080e7          	jalr	-1438(ra) # 8000332e <nameiparent>
    800048d4:	892a                	mv	s2,a0
    800048d6:	cd35                	beqz	a0,80004952 <sys_link+0x112>
  ilock(dp);
    800048d8:	ffffe097          	auipc	ra,0xffffe
    800048dc:	24c080e7          	jalr	588(ra) # 80002b24 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800048e0:	00092703          	lw	a4,0(s2)
    800048e4:	409c                	lw	a5,0(s1)
    800048e6:	06f71163          	bne	a4,a5,80004948 <sys_link+0x108>
    800048ea:	40d0                	lw	a2,4(s1)
    800048ec:	fd040593          	addi	a1,s0,-48
    800048f0:	854a                	mv	a0,s2
    800048f2:	fffff097          	auipc	ra,0xfffff
    800048f6:	948080e7          	jalr	-1720(ra) # 8000323a <dirlink>
    800048fa:	04054763          	bltz	a0,80004948 <sys_link+0x108>
  iunlockput(dp);
    800048fe:	854a                	mv	a0,s2
    80004900:	ffffe097          	auipc	ra,0xffffe
    80004904:	48a080e7          	jalr	1162(ra) # 80002d8a <iunlockput>
  iput(ip);
    80004908:	8526                	mv	a0,s1
    8000490a:	ffffe097          	auipc	ra,0xffffe
    8000490e:	3d8080e7          	jalr	984(ra) # 80002ce2 <iput>
  end_op();
    80004912:	fffff097          	auipc	ra,0xfffff
    80004916:	c7e080e7          	jalr	-898(ra) # 80003590 <end_op>
  return 0;
    8000491a:	4781                	li	a5,0
    8000491c:	64f2                	ld	s1,280(sp)
    8000491e:	6952                	ld	s2,272(sp)
    80004920:	a0a5                	j	80004988 <sys_link+0x148>
    end_op();
    80004922:	fffff097          	auipc	ra,0xfffff
    80004926:	c6e080e7          	jalr	-914(ra) # 80003590 <end_op>
    return -1;
    8000492a:	57fd                	li	a5,-1
    8000492c:	64f2                	ld	s1,280(sp)
    8000492e:	a8a9                	j	80004988 <sys_link+0x148>
    iunlockput(ip);
    80004930:	8526                	mv	a0,s1
    80004932:	ffffe097          	auipc	ra,0xffffe
    80004936:	458080e7          	jalr	1112(ra) # 80002d8a <iunlockput>
    end_op();
    8000493a:	fffff097          	auipc	ra,0xfffff
    8000493e:	c56080e7          	jalr	-938(ra) # 80003590 <end_op>
    return -1;
    80004942:	57fd                	li	a5,-1
    80004944:	64f2                	ld	s1,280(sp)
    80004946:	a089                	j	80004988 <sys_link+0x148>
    iunlockput(dp);
    80004948:	854a                	mv	a0,s2
    8000494a:	ffffe097          	auipc	ra,0xffffe
    8000494e:	440080e7          	jalr	1088(ra) # 80002d8a <iunlockput>
  ilock(ip);
    80004952:	8526                	mv	a0,s1
    80004954:	ffffe097          	auipc	ra,0xffffe
    80004958:	1d0080e7          	jalr	464(ra) # 80002b24 <ilock>
  ip->nlink--;
    8000495c:	04a4d783          	lhu	a5,74(s1)
    80004960:	37fd                	addiw	a5,a5,-1
    80004962:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004966:	8526                	mv	a0,s1
    80004968:	ffffe097          	auipc	ra,0xffffe
    8000496c:	0f0080e7          	jalr	240(ra) # 80002a58 <iupdate>
  iunlockput(ip);
    80004970:	8526                	mv	a0,s1
    80004972:	ffffe097          	auipc	ra,0xffffe
    80004976:	418080e7          	jalr	1048(ra) # 80002d8a <iunlockput>
  end_op();
    8000497a:	fffff097          	auipc	ra,0xfffff
    8000497e:	c16080e7          	jalr	-1002(ra) # 80003590 <end_op>
  return -1;
    80004982:	57fd                	li	a5,-1
    80004984:	64f2                	ld	s1,280(sp)
    80004986:	6952                	ld	s2,272(sp)
}
    80004988:	853e                	mv	a0,a5
    8000498a:	70b2                	ld	ra,296(sp)
    8000498c:	7412                	ld	s0,288(sp)
    8000498e:	6155                	addi	sp,sp,304
    80004990:	8082                	ret

0000000080004992 <sys_unlink>:
{
    80004992:	7111                	addi	sp,sp,-256
    80004994:	fd86                	sd	ra,248(sp)
    80004996:	f9a2                	sd	s0,240(sp)
    80004998:	0200                	addi	s0,sp,256
  if(argstr(0, path, MAXPATH) < 0)
    8000499a:	08000613          	li	a2,128
    8000499e:	f2040593          	addi	a1,s0,-224
    800049a2:	4501                	li	a0,0
    800049a4:	ffffd097          	auipc	ra,0xffffd
    800049a8:	600080e7          	jalr	1536(ra) # 80001fa4 <argstr>
    800049ac:	1c054063          	bltz	a0,80004b6c <sys_unlink+0x1da>
    800049b0:	f5a6                	sd	s1,232(sp)
  begin_op();
    800049b2:	fffff097          	auipc	ra,0xfffff
    800049b6:	b64080e7          	jalr	-1180(ra) # 80003516 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800049ba:	fa040593          	addi	a1,s0,-96
    800049be:	f2040513          	addi	a0,s0,-224
    800049c2:	fffff097          	auipc	ra,0xfffff
    800049c6:	96c080e7          	jalr	-1684(ra) # 8000332e <nameiparent>
    800049ca:	84aa                	mv	s1,a0
    800049cc:	c165                	beqz	a0,80004aac <sys_unlink+0x11a>
  ilock(dp);
    800049ce:	ffffe097          	auipc	ra,0xffffe
    800049d2:	156080e7          	jalr	342(ra) # 80002b24 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800049d6:	00004597          	auipc	a1,0x4
    800049da:	baa58593          	addi	a1,a1,-1110 # 80008580 <etext+0x580>
    800049de:	fa040513          	addi	a0,s0,-96
    800049e2:	ffffe097          	auipc	ra,0xffffe
    800049e6:	618080e7          	jalr	1560(ra) # 80002ffa <namecmp>
    800049ea:	16050263          	beqz	a0,80004b4e <sys_unlink+0x1bc>
    800049ee:	00004597          	auipc	a1,0x4
    800049f2:	b9a58593          	addi	a1,a1,-1126 # 80008588 <etext+0x588>
    800049f6:	fa040513          	addi	a0,s0,-96
    800049fa:	ffffe097          	auipc	ra,0xffffe
    800049fe:	600080e7          	jalr	1536(ra) # 80002ffa <namecmp>
    80004a02:	14050663          	beqz	a0,80004b4e <sys_unlink+0x1bc>
    80004a06:	f1ca                	sd	s2,224(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004a08:	f1c40613          	addi	a2,s0,-228
    80004a0c:	fa040593          	addi	a1,s0,-96
    80004a10:	8526                	mv	a0,s1
    80004a12:	ffffe097          	auipc	ra,0xffffe
    80004a16:	602080e7          	jalr	1538(ra) # 80003014 <dirlookup>
    80004a1a:	892a                	mv	s2,a0
    80004a1c:	12050863          	beqz	a0,80004b4c <sys_unlink+0x1ba>
    80004a20:	edce                	sd	s3,216(sp)
  ilock(ip);
    80004a22:	ffffe097          	auipc	ra,0xffffe
    80004a26:	102080e7          	jalr	258(ra) # 80002b24 <ilock>
  if(ip->nlink < 1)
    80004a2a:	04a91783          	lh	a5,74(s2)
    80004a2e:	08f05663          	blez	a5,80004aba <sys_unlink+0x128>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004a32:	04491703          	lh	a4,68(s2)
    80004a36:	4785                	li	a5,1
    80004a38:	08f70b63          	beq	a4,a5,80004ace <sys_unlink+0x13c>
  memset(&de, 0, sizeof(de));
    80004a3c:	fb040993          	addi	s3,s0,-80
    80004a40:	4641                	li	a2,16
    80004a42:	4581                	li	a1,0
    80004a44:	854e                	mv	a0,s3
    80004a46:	ffffb097          	auipc	ra,0xffffb
    80004a4a:	734080e7          	jalr	1844(ra) # 8000017a <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a4e:	4741                	li	a4,16
    80004a50:	f1c42683          	lw	a3,-228(s0)
    80004a54:	864e                	mv	a2,s3
    80004a56:	4581                	li	a1,0
    80004a58:	8526                	mv	a0,s1
    80004a5a:	ffffe097          	auipc	ra,0xffffe
    80004a5e:	480080e7          	jalr	1152(ra) # 80002eda <writei>
    80004a62:	47c1                	li	a5,16
    80004a64:	0af51f63          	bne	a0,a5,80004b22 <sys_unlink+0x190>
  if(ip->type == T_DIR){
    80004a68:	04491703          	lh	a4,68(s2)
    80004a6c:	4785                	li	a5,1
    80004a6e:	0cf70463          	beq	a4,a5,80004b36 <sys_unlink+0x1a4>
  iunlockput(dp);
    80004a72:	8526                	mv	a0,s1
    80004a74:	ffffe097          	auipc	ra,0xffffe
    80004a78:	316080e7          	jalr	790(ra) # 80002d8a <iunlockput>
  ip->nlink--;
    80004a7c:	04a95783          	lhu	a5,74(s2)
    80004a80:	37fd                	addiw	a5,a5,-1
    80004a82:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004a86:	854a                	mv	a0,s2
    80004a88:	ffffe097          	auipc	ra,0xffffe
    80004a8c:	fd0080e7          	jalr	-48(ra) # 80002a58 <iupdate>
  iunlockput(ip);
    80004a90:	854a                	mv	a0,s2
    80004a92:	ffffe097          	auipc	ra,0xffffe
    80004a96:	2f8080e7          	jalr	760(ra) # 80002d8a <iunlockput>
  end_op();
    80004a9a:	fffff097          	auipc	ra,0xfffff
    80004a9e:	af6080e7          	jalr	-1290(ra) # 80003590 <end_op>
  return 0;
    80004aa2:	4501                	li	a0,0
    80004aa4:	74ae                	ld	s1,232(sp)
    80004aa6:	790e                	ld	s2,224(sp)
    80004aa8:	69ee                	ld	s3,216(sp)
    80004aaa:	a86d                	j	80004b64 <sys_unlink+0x1d2>
    end_op();
    80004aac:	fffff097          	auipc	ra,0xfffff
    80004ab0:	ae4080e7          	jalr	-1308(ra) # 80003590 <end_op>
    return -1;
    80004ab4:	557d                	li	a0,-1
    80004ab6:	74ae                	ld	s1,232(sp)
    80004ab8:	a075                	j	80004b64 <sys_unlink+0x1d2>
    80004aba:	e9d2                	sd	s4,208(sp)
    80004abc:	e5d6                	sd	s5,200(sp)
    panic("unlink: nlink < 1");
    80004abe:	00004517          	auipc	a0,0x4
    80004ac2:	af250513          	addi	a0,a0,-1294 # 800085b0 <etext+0x5b0>
    80004ac6:	00001097          	auipc	ra,0x1
    80004aca:	2a6080e7          	jalr	678(ra) # 80005d6c <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004ace:	04c92703          	lw	a4,76(s2)
    80004ad2:	02000793          	li	a5,32
    80004ad6:	f6e7f3e3          	bgeu	a5,a4,80004a3c <sys_unlink+0xaa>
    80004ada:	e9d2                	sd	s4,208(sp)
    80004adc:	e5d6                	sd	s5,200(sp)
    80004ade:	89be                	mv	s3,a5
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004ae0:	f0840a93          	addi	s5,s0,-248
    80004ae4:	4a41                	li	s4,16
    80004ae6:	8752                	mv	a4,s4
    80004ae8:	86ce                	mv	a3,s3
    80004aea:	8656                	mv	a2,s5
    80004aec:	4581                	li	a1,0
    80004aee:	854a                	mv	a0,s2
    80004af0:	ffffe097          	auipc	ra,0xffffe
    80004af4:	2f0080e7          	jalr	752(ra) # 80002de0 <readi>
    80004af8:	01451d63          	bne	a0,s4,80004b12 <sys_unlink+0x180>
    if(de.inum != 0)
    80004afc:	f0845783          	lhu	a5,-248(s0)
    80004b00:	eba5                	bnez	a5,80004b70 <sys_unlink+0x1de>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004b02:	29c1                	addiw	s3,s3,16
    80004b04:	04c92783          	lw	a5,76(s2)
    80004b08:	fcf9efe3          	bltu	s3,a5,80004ae6 <sys_unlink+0x154>
    80004b0c:	6a4e                	ld	s4,208(sp)
    80004b0e:	6aae                	ld	s5,200(sp)
    80004b10:	b735                	j	80004a3c <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004b12:	00004517          	auipc	a0,0x4
    80004b16:	ab650513          	addi	a0,a0,-1354 # 800085c8 <etext+0x5c8>
    80004b1a:	00001097          	auipc	ra,0x1
    80004b1e:	252080e7          	jalr	594(ra) # 80005d6c <panic>
    80004b22:	e9d2                	sd	s4,208(sp)
    80004b24:	e5d6                	sd	s5,200(sp)
    panic("unlink: writei");
    80004b26:	00004517          	auipc	a0,0x4
    80004b2a:	aba50513          	addi	a0,a0,-1350 # 800085e0 <etext+0x5e0>
    80004b2e:	00001097          	auipc	ra,0x1
    80004b32:	23e080e7          	jalr	574(ra) # 80005d6c <panic>
    dp->nlink--;
    80004b36:	04a4d783          	lhu	a5,74(s1)
    80004b3a:	37fd                	addiw	a5,a5,-1
    80004b3c:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004b40:	8526                	mv	a0,s1
    80004b42:	ffffe097          	auipc	ra,0xffffe
    80004b46:	f16080e7          	jalr	-234(ra) # 80002a58 <iupdate>
    80004b4a:	b725                	j	80004a72 <sys_unlink+0xe0>
    80004b4c:	790e                	ld	s2,224(sp)
  iunlockput(dp);
    80004b4e:	8526                	mv	a0,s1
    80004b50:	ffffe097          	auipc	ra,0xffffe
    80004b54:	23a080e7          	jalr	570(ra) # 80002d8a <iunlockput>
  end_op();
    80004b58:	fffff097          	auipc	ra,0xfffff
    80004b5c:	a38080e7          	jalr	-1480(ra) # 80003590 <end_op>
  return -1;
    80004b60:	557d                	li	a0,-1
    80004b62:	74ae                	ld	s1,232(sp)
}
    80004b64:	70ee                	ld	ra,248(sp)
    80004b66:	744e                	ld	s0,240(sp)
    80004b68:	6111                	addi	sp,sp,256
    80004b6a:	8082                	ret
    return -1;
    80004b6c:	557d                	li	a0,-1
    80004b6e:	bfdd                	j	80004b64 <sys_unlink+0x1d2>
    iunlockput(ip);
    80004b70:	854a                	mv	a0,s2
    80004b72:	ffffe097          	auipc	ra,0xffffe
    80004b76:	218080e7          	jalr	536(ra) # 80002d8a <iunlockput>
    goto bad;
    80004b7a:	790e                	ld	s2,224(sp)
    80004b7c:	69ee                	ld	s3,216(sp)
    80004b7e:	6a4e                	ld	s4,208(sp)
    80004b80:	6aae                	ld	s5,200(sp)
    80004b82:	b7f1                	j	80004b4e <sys_unlink+0x1bc>

0000000080004b84 <sys_open>:

uint64
sys_open(void)
{
    80004b84:	7131                	addi	sp,sp,-192
    80004b86:	fd06                	sd	ra,184(sp)
    80004b88:	f922                	sd	s0,176(sp)
    80004b8a:	f526                	sd	s1,168(sp)
    80004b8c:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004b8e:	08000613          	li	a2,128
    80004b92:	f5040593          	addi	a1,s0,-176
    80004b96:	4501                	li	a0,0
    80004b98:	ffffd097          	auipc	ra,0xffffd
    80004b9c:	40c080e7          	jalr	1036(ra) # 80001fa4 <argstr>
    return -1;
    80004ba0:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004ba2:	0c054563          	bltz	a0,80004c6c <sys_open+0xe8>
    80004ba6:	f4c40593          	addi	a1,s0,-180
    80004baa:	4505                	li	a0,1
    80004bac:	ffffd097          	auipc	ra,0xffffd
    80004bb0:	3b4080e7          	jalr	948(ra) # 80001f60 <argint>
    80004bb4:	0a054c63          	bltz	a0,80004c6c <sys_open+0xe8>
    80004bb8:	f14a                	sd	s2,160(sp)

  begin_op();
    80004bba:	fffff097          	auipc	ra,0xfffff
    80004bbe:	95c080e7          	jalr	-1700(ra) # 80003516 <begin_op>

  if(omode & O_CREATE){
    80004bc2:	f4c42783          	lw	a5,-180(s0)
    80004bc6:	2007f793          	andi	a5,a5,512
    80004bca:	cfcd                	beqz	a5,80004c84 <sys_open+0x100>
    ip = create(path, T_FILE, 0, 0);
    80004bcc:	4681                	li	a3,0
    80004bce:	4601                	li	a2,0
    80004bd0:	4589                	li	a1,2
    80004bd2:	f5040513          	addi	a0,s0,-176
    80004bd6:	00000097          	auipc	ra,0x0
    80004bda:	948080e7          	jalr	-1720(ra) # 8000451e <create>
    80004bde:	892a                	mv	s2,a0
    if(ip == 0){
    80004be0:	cd41                	beqz	a0,80004c78 <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004be2:	04491703          	lh	a4,68(s2)
    80004be6:	478d                	li	a5,3
    80004be8:	00f71763          	bne	a4,a5,80004bf6 <sys_open+0x72>
    80004bec:	04695703          	lhu	a4,70(s2)
    80004bf0:	47a5                	li	a5,9
    80004bf2:	0ee7e063          	bltu	a5,a4,80004cd2 <sys_open+0x14e>
    80004bf6:	ed4e                	sd	s3,152(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004bf8:	fffff097          	auipc	ra,0xfffff
    80004bfc:	d32080e7          	jalr	-718(ra) # 8000392a <filealloc>
    80004c00:	89aa                	mv	s3,a0
    80004c02:	c96d                	beqz	a0,80004cf4 <sys_open+0x170>
    80004c04:	00000097          	auipc	ra,0x0
    80004c08:	8d8080e7          	jalr	-1832(ra) # 800044dc <fdalloc>
    80004c0c:	84aa                	mv	s1,a0
    80004c0e:	0c054e63          	bltz	a0,80004cea <sys_open+0x166>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004c12:	04491703          	lh	a4,68(s2)
    80004c16:	478d                	li	a5,3
    80004c18:	0ef70b63          	beq	a4,a5,80004d0e <sys_open+0x18a>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004c1c:	4789                	li	a5,2
    80004c1e:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004c22:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004c26:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004c2a:	f4c42783          	lw	a5,-180(s0)
    80004c2e:	0017f713          	andi	a4,a5,1
    80004c32:	00174713          	xori	a4,a4,1
    80004c36:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004c3a:	0037f713          	andi	a4,a5,3
    80004c3e:	00e03733          	snez	a4,a4
    80004c42:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004c46:	4007f793          	andi	a5,a5,1024
    80004c4a:	c791                	beqz	a5,80004c56 <sys_open+0xd2>
    80004c4c:	04491703          	lh	a4,68(s2)
    80004c50:	4789                	li	a5,2
    80004c52:	0cf70563          	beq	a4,a5,80004d1c <sys_open+0x198>
    itrunc(ip);
  }

  iunlock(ip);
    80004c56:	854a                	mv	a0,s2
    80004c58:	ffffe097          	auipc	ra,0xffffe
    80004c5c:	f92080e7          	jalr	-110(ra) # 80002bea <iunlock>
  end_op();
    80004c60:	fffff097          	auipc	ra,0xfffff
    80004c64:	930080e7          	jalr	-1744(ra) # 80003590 <end_op>
    80004c68:	790a                	ld	s2,160(sp)
    80004c6a:	69ea                	ld	s3,152(sp)

  return fd;
}
    80004c6c:	8526                	mv	a0,s1
    80004c6e:	70ea                	ld	ra,184(sp)
    80004c70:	744a                	ld	s0,176(sp)
    80004c72:	74aa                	ld	s1,168(sp)
    80004c74:	6129                	addi	sp,sp,192
    80004c76:	8082                	ret
      end_op();
    80004c78:	fffff097          	auipc	ra,0xfffff
    80004c7c:	918080e7          	jalr	-1768(ra) # 80003590 <end_op>
      return -1;
    80004c80:	790a                	ld	s2,160(sp)
    80004c82:	b7ed                	j	80004c6c <sys_open+0xe8>
    if((ip = namei(path)) == 0){
    80004c84:	f5040513          	addi	a0,s0,-176
    80004c88:	ffffe097          	auipc	ra,0xffffe
    80004c8c:	688080e7          	jalr	1672(ra) # 80003310 <namei>
    80004c90:	892a                	mv	s2,a0
    80004c92:	c90d                	beqz	a0,80004cc4 <sys_open+0x140>
    ilock(ip);
    80004c94:	ffffe097          	auipc	ra,0xffffe
    80004c98:	e90080e7          	jalr	-368(ra) # 80002b24 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004c9c:	04491703          	lh	a4,68(s2)
    80004ca0:	4785                	li	a5,1
    80004ca2:	f4f710e3          	bne	a4,a5,80004be2 <sys_open+0x5e>
    80004ca6:	f4c42783          	lw	a5,-180(s0)
    80004caa:	d7b1                	beqz	a5,80004bf6 <sys_open+0x72>
      iunlockput(ip);
    80004cac:	854a                	mv	a0,s2
    80004cae:	ffffe097          	auipc	ra,0xffffe
    80004cb2:	0dc080e7          	jalr	220(ra) # 80002d8a <iunlockput>
      end_op();
    80004cb6:	fffff097          	auipc	ra,0xfffff
    80004cba:	8da080e7          	jalr	-1830(ra) # 80003590 <end_op>
      return -1;
    80004cbe:	54fd                	li	s1,-1
    80004cc0:	790a                	ld	s2,160(sp)
    80004cc2:	b76d                	j	80004c6c <sys_open+0xe8>
      end_op();
    80004cc4:	fffff097          	auipc	ra,0xfffff
    80004cc8:	8cc080e7          	jalr	-1844(ra) # 80003590 <end_op>
      return -1;
    80004ccc:	54fd                	li	s1,-1
    80004cce:	790a                	ld	s2,160(sp)
    80004cd0:	bf71                	j	80004c6c <sys_open+0xe8>
    iunlockput(ip);
    80004cd2:	854a                	mv	a0,s2
    80004cd4:	ffffe097          	auipc	ra,0xffffe
    80004cd8:	0b6080e7          	jalr	182(ra) # 80002d8a <iunlockput>
    end_op();
    80004cdc:	fffff097          	auipc	ra,0xfffff
    80004ce0:	8b4080e7          	jalr	-1868(ra) # 80003590 <end_op>
    return -1;
    80004ce4:	54fd                	li	s1,-1
    80004ce6:	790a                	ld	s2,160(sp)
    80004ce8:	b751                	j	80004c6c <sys_open+0xe8>
      fileclose(f);
    80004cea:	854e                	mv	a0,s3
    80004cec:	fffff097          	auipc	ra,0xfffff
    80004cf0:	cfa080e7          	jalr	-774(ra) # 800039e6 <fileclose>
    iunlockput(ip);
    80004cf4:	854a                	mv	a0,s2
    80004cf6:	ffffe097          	auipc	ra,0xffffe
    80004cfa:	094080e7          	jalr	148(ra) # 80002d8a <iunlockput>
    end_op();
    80004cfe:	fffff097          	auipc	ra,0xfffff
    80004d02:	892080e7          	jalr	-1902(ra) # 80003590 <end_op>
    return -1;
    80004d06:	54fd                	li	s1,-1
    80004d08:	790a                	ld	s2,160(sp)
    80004d0a:	69ea                	ld	s3,152(sp)
    80004d0c:	b785                	j	80004c6c <sys_open+0xe8>
    f->type = FD_DEVICE;
    80004d0e:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004d12:	04691783          	lh	a5,70(s2)
    80004d16:	02f99223          	sh	a5,36(s3)
    80004d1a:	b731                	j	80004c26 <sys_open+0xa2>
    itrunc(ip);
    80004d1c:	854a                	mv	a0,s2
    80004d1e:	ffffe097          	auipc	ra,0xffffe
    80004d22:	f18080e7          	jalr	-232(ra) # 80002c36 <itrunc>
    80004d26:	bf05                	j	80004c56 <sys_open+0xd2>

0000000080004d28 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004d28:	7175                	addi	sp,sp,-144
    80004d2a:	e506                	sd	ra,136(sp)
    80004d2c:	e122                	sd	s0,128(sp)
    80004d2e:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004d30:	ffffe097          	auipc	ra,0xffffe
    80004d34:	7e6080e7          	jalr	2022(ra) # 80003516 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004d38:	08000613          	li	a2,128
    80004d3c:	f7040593          	addi	a1,s0,-144
    80004d40:	4501                	li	a0,0
    80004d42:	ffffd097          	auipc	ra,0xffffd
    80004d46:	262080e7          	jalr	610(ra) # 80001fa4 <argstr>
    80004d4a:	02054963          	bltz	a0,80004d7c <sys_mkdir+0x54>
    80004d4e:	4681                	li	a3,0
    80004d50:	4601                	li	a2,0
    80004d52:	4585                	li	a1,1
    80004d54:	f7040513          	addi	a0,s0,-144
    80004d58:	fffff097          	auipc	ra,0xfffff
    80004d5c:	7c6080e7          	jalr	1990(ra) # 8000451e <create>
    80004d60:	cd11                	beqz	a0,80004d7c <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004d62:	ffffe097          	auipc	ra,0xffffe
    80004d66:	028080e7          	jalr	40(ra) # 80002d8a <iunlockput>
  end_op();
    80004d6a:	fffff097          	auipc	ra,0xfffff
    80004d6e:	826080e7          	jalr	-2010(ra) # 80003590 <end_op>
  return 0;
    80004d72:	4501                	li	a0,0
}
    80004d74:	60aa                	ld	ra,136(sp)
    80004d76:	640a                	ld	s0,128(sp)
    80004d78:	6149                	addi	sp,sp,144
    80004d7a:	8082                	ret
    end_op();
    80004d7c:	fffff097          	auipc	ra,0xfffff
    80004d80:	814080e7          	jalr	-2028(ra) # 80003590 <end_op>
    return -1;
    80004d84:	557d                	li	a0,-1
    80004d86:	b7fd                	j	80004d74 <sys_mkdir+0x4c>

0000000080004d88 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004d88:	7135                	addi	sp,sp,-160
    80004d8a:	ed06                	sd	ra,152(sp)
    80004d8c:	e922                	sd	s0,144(sp)
    80004d8e:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004d90:	ffffe097          	auipc	ra,0xffffe
    80004d94:	786080e7          	jalr	1926(ra) # 80003516 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d98:	08000613          	li	a2,128
    80004d9c:	f7040593          	addi	a1,s0,-144
    80004da0:	4501                	li	a0,0
    80004da2:	ffffd097          	auipc	ra,0xffffd
    80004da6:	202080e7          	jalr	514(ra) # 80001fa4 <argstr>
    80004daa:	04054a63          	bltz	a0,80004dfe <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004dae:	f6c40593          	addi	a1,s0,-148
    80004db2:	4505                	li	a0,1
    80004db4:	ffffd097          	auipc	ra,0xffffd
    80004db8:	1ac080e7          	jalr	428(ra) # 80001f60 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004dbc:	04054163          	bltz	a0,80004dfe <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004dc0:	f6840593          	addi	a1,s0,-152
    80004dc4:	4509                	li	a0,2
    80004dc6:	ffffd097          	auipc	ra,0xffffd
    80004dca:	19a080e7          	jalr	410(ra) # 80001f60 <argint>
     argint(1, &major) < 0 ||
    80004dce:	02054863          	bltz	a0,80004dfe <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004dd2:	f6841683          	lh	a3,-152(s0)
    80004dd6:	f6c41603          	lh	a2,-148(s0)
    80004dda:	458d                	li	a1,3
    80004ddc:	f7040513          	addi	a0,s0,-144
    80004de0:	fffff097          	auipc	ra,0xfffff
    80004de4:	73e080e7          	jalr	1854(ra) # 8000451e <create>
     argint(2, &minor) < 0 ||
    80004de8:	c919                	beqz	a0,80004dfe <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004dea:	ffffe097          	auipc	ra,0xffffe
    80004dee:	fa0080e7          	jalr	-96(ra) # 80002d8a <iunlockput>
  end_op();
    80004df2:	ffffe097          	auipc	ra,0xffffe
    80004df6:	79e080e7          	jalr	1950(ra) # 80003590 <end_op>
  return 0;
    80004dfa:	4501                	li	a0,0
    80004dfc:	a031                	j	80004e08 <sys_mknod+0x80>
    end_op();
    80004dfe:	ffffe097          	auipc	ra,0xffffe
    80004e02:	792080e7          	jalr	1938(ra) # 80003590 <end_op>
    return -1;
    80004e06:	557d                	li	a0,-1
}
    80004e08:	60ea                	ld	ra,152(sp)
    80004e0a:	644a                	ld	s0,144(sp)
    80004e0c:	610d                	addi	sp,sp,160
    80004e0e:	8082                	ret

0000000080004e10 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004e10:	7135                	addi	sp,sp,-160
    80004e12:	ed06                	sd	ra,152(sp)
    80004e14:	e922                	sd	s0,144(sp)
    80004e16:	e14a                	sd	s2,128(sp)
    80004e18:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004e1a:	ffffc097          	auipc	ra,0xffffc
    80004e1e:	07c080e7          	jalr	124(ra) # 80000e96 <myproc>
    80004e22:	892a                	mv	s2,a0
  
  begin_op();
    80004e24:	ffffe097          	auipc	ra,0xffffe
    80004e28:	6f2080e7          	jalr	1778(ra) # 80003516 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004e2c:	08000613          	li	a2,128
    80004e30:	f6040593          	addi	a1,s0,-160
    80004e34:	4501                	li	a0,0
    80004e36:	ffffd097          	auipc	ra,0xffffd
    80004e3a:	16e080e7          	jalr	366(ra) # 80001fa4 <argstr>
    80004e3e:	04054d63          	bltz	a0,80004e98 <sys_chdir+0x88>
    80004e42:	e526                	sd	s1,136(sp)
    80004e44:	f6040513          	addi	a0,s0,-160
    80004e48:	ffffe097          	auipc	ra,0xffffe
    80004e4c:	4c8080e7          	jalr	1224(ra) # 80003310 <namei>
    80004e50:	84aa                	mv	s1,a0
    80004e52:	c131                	beqz	a0,80004e96 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004e54:	ffffe097          	auipc	ra,0xffffe
    80004e58:	cd0080e7          	jalr	-816(ra) # 80002b24 <ilock>
  if(ip->type != T_DIR){
    80004e5c:	04449703          	lh	a4,68(s1)
    80004e60:	4785                	li	a5,1
    80004e62:	04f71163          	bne	a4,a5,80004ea4 <sys_chdir+0x94>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004e66:	8526                	mv	a0,s1
    80004e68:	ffffe097          	auipc	ra,0xffffe
    80004e6c:	d82080e7          	jalr	-638(ra) # 80002bea <iunlock>
  iput(p->cwd);
    80004e70:	15093503          	ld	a0,336(s2)
    80004e74:	ffffe097          	auipc	ra,0xffffe
    80004e78:	e6e080e7          	jalr	-402(ra) # 80002ce2 <iput>
  end_op();
    80004e7c:	ffffe097          	auipc	ra,0xffffe
    80004e80:	714080e7          	jalr	1812(ra) # 80003590 <end_op>
  p->cwd = ip;
    80004e84:	14993823          	sd	s1,336(s2)
  return 0;
    80004e88:	4501                	li	a0,0
    80004e8a:	64aa                	ld	s1,136(sp)
}
    80004e8c:	60ea                	ld	ra,152(sp)
    80004e8e:	644a                	ld	s0,144(sp)
    80004e90:	690a                	ld	s2,128(sp)
    80004e92:	610d                	addi	sp,sp,160
    80004e94:	8082                	ret
    80004e96:	64aa                	ld	s1,136(sp)
    end_op();
    80004e98:	ffffe097          	auipc	ra,0xffffe
    80004e9c:	6f8080e7          	jalr	1784(ra) # 80003590 <end_op>
    return -1;
    80004ea0:	557d                	li	a0,-1
    80004ea2:	b7ed                	j	80004e8c <sys_chdir+0x7c>
    iunlockput(ip);
    80004ea4:	8526                	mv	a0,s1
    80004ea6:	ffffe097          	auipc	ra,0xffffe
    80004eaa:	ee4080e7          	jalr	-284(ra) # 80002d8a <iunlockput>
    end_op();
    80004eae:	ffffe097          	auipc	ra,0xffffe
    80004eb2:	6e2080e7          	jalr	1762(ra) # 80003590 <end_op>
    return -1;
    80004eb6:	557d                	li	a0,-1
    80004eb8:	64aa                	ld	s1,136(sp)
    80004eba:	bfc9                	j	80004e8c <sys_chdir+0x7c>

0000000080004ebc <sys_exec>:

uint64
sys_exec(void)
{
    80004ebc:	7105                	addi	sp,sp,-480
    80004ebe:	ef86                	sd	ra,472(sp)
    80004ec0:	eba2                	sd	s0,464(sp)
    80004ec2:	e3ca                	sd	s2,448(sp)
    80004ec4:	1380                	addi	s0,sp,480
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004ec6:	08000613          	li	a2,128
    80004eca:	f3040593          	addi	a1,s0,-208
    80004ece:	4501                	li	a0,0
    80004ed0:	ffffd097          	auipc	ra,0xffffd
    80004ed4:	0d4080e7          	jalr	212(ra) # 80001fa4 <argstr>
    return -1;
    80004ed8:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004eda:	10054963          	bltz	a0,80004fec <sys_exec+0x130>
    80004ede:	e2840593          	addi	a1,s0,-472
    80004ee2:	4505                	li	a0,1
    80004ee4:	ffffd097          	auipc	ra,0xffffd
    80004ee8:	09e080e7          	jalr	158(ra) # 80001f82 <argaddr>
    80004eec:	10054063          	bltz	a0,80004fec <sys_exec+0x130>
    80004ef0:	e7a6                	sd	s1,456(sp)
    80004ef2:	ff4e                	sd	s3,440(sp)
    80004ef4:	fb52                	sd	s4,432(sp)
    80004ef6:	f756                	sd	s5,424(sp)
    80004ef8:	f35a                	sd	s6,416(sp)
    80004efa:	ef5e                	sd	s7,408(sp)
  }
  memset(argv, 0, sizeof(argv));
    80004efc:	e3040a13          	addi	s4,s0,-464
    80004f00:	10000613          	li	a2,256
    80004f04:	4581                	li	a1,0
    80004f06:	8552                	mv	a0,s4
    80004f08:	ffffb097          	auipc	ra,0xffffb
    80004f0c:	272080e7          	jalr	626(ra) # 8000017a <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004f10:	84d2                	mv	s1,s4
  memset(argv, 0, sizeof(argv));
    80004f12:	89d2                	mv	s3,s4
    80004f14:	4901                	li	s2,0
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004f16:	e2040a93          	addi	s5,s0,-480
      break;
    }
    argv[i] = kalloc();
    if(argv[i] == 0)
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004f1a:	6b05                	lui	s6,0x1
    if(i >= NELEM(argv)){
    80004f1c:	02000b93          	li	s7,32
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004f20:	00391513          	slli	a0,s2,0x3
    80004f24:	85d6                	mv	a1,s5
    80004f26:	e2843783          	ld	a5,-472(s0)
    80004f2a:	953e                	add	a0,a0,a5
    80004f2c:	ffffd097          	auipc	ra,0xffffd
    80004f30:	f9a080e7          	jalr	-102(ra) # 80001ec6 <fetchaddr>
    80004f34:	02054a63          	bltz	a0,80004f68 <sys_exec+0xac>
    if(uarg == 0){
    80004f38:	e2043783          	ld	a5,-480(s0)
    80004f3c:	cba9                	beqz	a5,80004f8e <sys_exec+0xd2>
    argv[i] = kalloc();
    80004f3e:	ffffb097          	auipc	ra,0xffffb
    80004f42:	1dc080e7          	jalr	476(ra) # 8000011a <kalloc>
    80004f46:	85aa                	mv	a1,a0
    80004f48:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004f4c:	cd11                	beqz	a0,80004f68 <sys_exec+0xac>
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004f4e:	865a                	mv	a2,s6
    80004f50:	e2043503          	ld	a0,-480(s0)
    80004f54:	ffffd097          	auipc	ra,0xffffd
    80004f58:	fc4080e7          	jalr	-60(ra) # 80001f18 <fetchstr>
    80004f5c:	00054663          	bltz	a0,80004f68 <sys_exec+0xac>
    if(i >= NELEM(argv)){
    80004f60:	0905                	addi	s2,s2,1
    80004f62:	09a1                	addi	s3,s3,8
    80004f64:	fb791ee3          	bne	s2,s7,80004f20 <sys_exec+0x64>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f68:	100a0a13          	addi	s4,s4,256
    80004f6c:	6088                	ld	a0,0(s1)
    80004f6e:	c925                	beqz	a0,80004fde <sys_exec+0x122>
    kfree(argv[i]);
    80004f70:	ffffb097          	auipc	ra,0xffffb
    80004f74:	0ac080e7          	jalr	172(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f78:	04a1                	addi	s1,s1,8
    80004f7a:	ff4499e3          	bne	s1,s4,80004f6c <sys_exec+0xb0>
  return -1;
    80004f7e:	597d                	li	s2,-1
    80004f80:	64be                	ld	s1,456(sp)
    80004f82:	79fa                	ld	s3,440(sp)
    80004f84:	7a5a                	ld	s4,432(sp)
    80004f86:	7aba                	ld	s5,424(sp)
    80004f88:	7b1a                	ld	s6,416(sp)
    80004f8a:	6bfa                	ld	s7,408(sp)
    80004f8c:	a085                	j	80004fec <sys_exec+0x130>
      argv[i] = 0;
    80004f8e:	0009079b          	sext.w	a5,s2
    80004f92:	e3040593          	addi	a1,s0,-464
    80004f96:	078e                	slli	a5,a5,0x3
    80004f98:	97ae                	add	a5,a5,a1
    80004f9a:	0007b023          	sd	zero,0(a5)
  int ret = exec(path, argv);
    80004f9e:	f3040513          	addi	a0,s0,-208
    80004fa2:	fffff097          	auipc	ra,0xfffff
    80004fa6:	122080e7          	jalr	290(ra) # 800040c4 <exec>
    80004faa:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004fac:	100a0a13          	addi	s4,s4,256
    80004fb0:	6088                	ld	a0,0(s1)
    80004fb2:	cd19                	beqz	a0,80004fd0 <sys_exec+0x114>
    kfree(argv[i]);
    80004fb4:	ffffb097          	auipc	ra,0xffffb
    80004fb8:	068080e7          	jalr	104(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004fbc:	04a1                	addi	s1,s1,8
    80004fbe:	ff4499e3          	bne	s1,s4,80004fb0 <sys_exec+0xf4>
    80004fc2:	64be                	ld	s1,456(sp)
    80004fc4:	79fa                	ld	s3,440(sp)
    80004fc6:	7a5a                	ld	s4,432(sp)
    80004fc8:	7aba                	ld	s5,424(sp)
    80004fca:	7b1a                	ld	s6,416(sp)
    80004fcc:	6bfa                	ld	s7,408(sp)
    80004fce:	a839                	j	80004fec <sys_exec+0x130>
  return ret;
    80004fd0:	64be                	ld	s1,456(sp)
    80004fd2:	79fa                	ld	s3,440(sp)
    80004fd4:	7a5a                	ld	s4,432(sp)
    80004fd6:	7aba                	ld	s5,424(sp)
    80004fd8:	7b1a                	ld	s6,416(sp)
    80004fda:	6bfa                	ld	s7,408(sp)
    80004fdc:	a801                	j	80004fec <sys_exec+0x130>
  return -1;
    80004fde:	597d                	li	s2,-1
    80004fe0:	64be                	ld	s1,456(sp)
    80004fe2:	79fa                	ld	s3,440(sp)
    80004fe4:	7a5a                	ld	s4,432(sp)
    80004fe6:	7aba                	ld	s5,424(sp)
    80004fe8:	7b1a                	ld	s6,416(sp)
    80004fea:	6bfa                	ld	s7,408(sp)
}
    80004fec:	854a                	mv	a0,s2
    80004fee:	60fe                	ld	ra,472(sp)
    80004ff0:	645e                	ld	s0,464(sp)
    80004ff2:	691e                	ld	s2,448(sp)
    80004ff4:	613d                	addi	sp,sp,480
    80004ff6:	8082                	ret

0000000080004ff8 <sys_pipe>:

uint64
sys_pipe(void)
{
    80004ff8:	7139                	addi	sp,sp,-64
    80004ffa:	fc06                	sd	ra,56(sp)
    80004ffc:	f822                	sd	s0,48(sp)
    80004ffe:	f426                	sd	s1,40(sp)
    80005000:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005002:	ffffc097          	auipc	ra,0xffffc
    80005006:	e94080e7          	jalr	-364(ra) # 80000e96 <myproc>
    8000500a:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    8000500c:	fd840593          	addi	a1,s0,-40
    80005010:	4501                	li	a0,0
    80005012:	ffffd097          	auipc	ra,0xffffd
    80005016:	f70080e7          	jalr	-144(ra) # 80001f82 <argaddr>
    return -1;
    8000501a:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    8000501c:	0e054063          	bltz	a0,800050fc <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80005020:	fc840593          	addi	a1,s0,-56
    80005024:	fd040513          	addi	a0,s0,-48
    80005028:	fffff097          	auipc	ra,0xfffff
    8000502c:	d32080e7          	jalr	-718(ra) # 80003d5a <pipealloc>
    return -1;
    80005030:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005032:	0c054563          	bltz	a0,800050fc <sys_pipe+0x104>
  fd0 = -1;
    80005036:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    8000503a:	fd043503          	ld	a0,-48(s0)
    8000503e:	fffff097          	auipc	ra,0xfffff
    80005042:	49e080e7          	jalr	1182(ra) # 800044dc <fdalloc>
    80005046:	fca42223          	sw	a0,-60(s0)
    8000504a:	08054c63          	bltz	a0,800050e2 <sys_pipe+0xea>
    8000504e:	fc843503          	ld	a0,-56(s0)
    80005052:	fffff097          	auipc	ra,0xfffff
    80005056:	48a080e7          	jalr	1162(ra) # 800044dc <fdalloc>
    8000505a:	fca42023          	sw	a0,-64(s0)
    8000505e:	06054963          	bltz	a0,800050d0 <sys_pipe+0xd8>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005062:	4691                	li	a3,4
    80005064:	fc440613          	addi	a2,s0,-60
    80005068:	fd843583          	ld	a1,-40(s0)
    8000506c:	68a8                	ld	a0,80(s1)
    8000506e:	ffffc097          	auipc	ra,0xffffc
    80005072:	ae0080e7          	jalr	-1312(ra) # 80000b4e <copyout>
    80005076:	02054063          	bltz	a0,80005096 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    8000507a:	4691                	li	a3,4
    8000507c:	fc040613          	addi	a2,s0,-64
    80005080:	fd843583          	ld	a1,-40(s0)
    80005084:	95b6                	add	a1,a1,a3
    80005086:	68a8                	ld	a0,80(s1)
    80005088:	ffffc097          	auipc	ra,0xffffc
    8000508c:	ac6080e7          	jalr	-1338(ra) # 80000b4e <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005090:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005092:	06055563          	bgez	a0,800050fc <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005096:	fc442783          	lw	a5,-60(s0)
    8000509a:	07e9                	addi	a5,a5,26
    8000509c:	078e                	slli	a5,a5,0x3
    8000509e:	97a6                	add	a5,a5,s1
    800050a0:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800050a4:	fc042783          	lw	a5,-64(s0)
    800050a8:	07e9                	addi	a5,a5,26
    800050aa:	078e                	slli	a5,a5,0x3
    800050ac:	00f48533          	add	a0,s1,a5
    800050b0:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    800050b4:	fd043503          	ld	a0,-48(s0)
    800050b8:	fffff097          	auipc	ra,0xfffff
    800050bc:	92e080e7          	jalr	-1746(ra) # 800039e6 <fileclose>
    fileclose(wf);
    800050c0:	fc843503          	ld	a0,-56(s0)
    800050c4:	fffff097          	auipc	ra,0xfffff
    800050c8:	922080e7          	jalr	-1758(ra) # 800039e6 <fileclose>
    return -1;
    800050cc:	57fd                	li	a5,-1
    800050ce:	a03d                	j	800050fc <sys_pipe+0x104>
    if(fd0 >= 0)
    800050d0:	fc442783          	lw	a5,-60(s0)
    800050d4:	0007c763          	bltz	a5,800050e2 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    800050d8:	07e9                	addi	a5,a5,26
    800050da:	078e                	slli	a5,a5,0x3
    800050dc:	97a6                	add	a5,a5,s1
    800050de:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    800050e2:	fd043503          	ld	a0,-48(s0)
    800050e6:	fffff097          	auipc	ra,0xfffff
    800050ea:	900080e7          	jalr	-1792(ra) # 800039e6 <fileclose>
    fileclose(wf);
    800050ee:	fc843503          	ld	a0,-56(s0)
    800050f2:	fffff097          	auipc	ra,0xfffff
    800050f6:	8f4080e7          	jalr	-1804(ra) # 800039e6 <fileclose>
    return -1;
    800050fa:	57fd                	li	a5,-1
}
    800050fc:	853e                	mv	a0,a5
    800050fe:	70e2                	ld	ra,56(sp)
    80005100:	7442                	ld	s0,48(sp)
    80005102:	74a2                	ld	s1,40(sp)
    80005104:	6121                	addi	sp,sp,64
    80005106:	8082                	ret
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
    80005150:	c43fc0ef          	jal	80001d92 <kerneltrap>
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
    800051f0:	c76080e7          	jalr	-906(ra) # 80000e62 <cpuid>
  
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
    80005228:	c3e080e7          	jalr	-962(ra) # 80000e62 <cpuid>
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
    80005250:	c16080e7          	jalr	-1002(ra) # 80000e62 <cpuid>
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
    800052d8:	41a080e7          	jalr	1050(ra) # 800016ee <wakeup>
}
    800052dc:	60a2                	ld	ra,8(sp)
    800052de:	6402                	ld	s0,0(sp)
    800052e0:	0141                	addi	sp,sp,16
    800052e2:	8082                	ret
    panic("free_desc 1");
    800052e4:	00003517          	auipc	a0,0x3
    800052e8:	30c50513          	addi	a0,a0,780 # 800085f0 <etext+0x5f0>
    800052ec:	00001097          	auipc	ra,0x1
    800052f0:	a80080e7          	jalr	-1408(ra) # 80005d6c <panic>
    panic("free_desc 2");
    800052f4:	00003517          	auipc	a0,0x3
    800052f8:	30c50513          	addi	a0,a0,780 # 80008600 <etext+0x600>
    800052fc:	00001097          	auipc	ra,0x1
    80005300:	a70080e7          	jalr	-1424(ra) # 80005d6c <panic>

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
    80005320:	f12080e7          	jalr	-238(ra) # 8000622e <initlock>
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
    8000542a:	946080e7          	jalr	-1722(ra) # 80005d6c <panic>
    panic("virtio disk has no queue 0");
    8000542e:	00003517          	auipc	a0,0x3
    80005432:	21250513          	addi	a0,a0,530 # 80008640 <etext+0x640>
    80005436:	00001097          	auipc	ra,0x1
    8000543a:	936080e7          	jalr	-1738(ra) # 80005d6c <panic>
    panic("virtio disk max queue too short");
    8000543e:	00003517          	auipc	a0,0x3
    80005442:	22250513          	addi	a0,a0,546 # 80008660 <etext+0x660>
    80005446:	00001097          	auipc	ra,0x1
    8000544a:	926080e7          	jalr	-1754(ra) # 80005d6c <panic>

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
    80005484:	e42080e7          	jalr	-446(ra) # 800062c2 <acquire>
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
    80005504:	068080e7          	jalr	104(ra) # 80001568 <sleep>
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
    800055d8:	f94080e7          	jalr	-108(ra) # 80001568 <sleep>
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
    80005630:	d46080e7          	jalr	-698(ra) # 80006372 <release>
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
    800056ea:	bdc080e7          	jalr	-1060(ra) # 800062c2 <acquire>
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
    8000575c:	f96080e7          	jalr	-106(ra) # 800016ee <wakeup>

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
    80005788:	bee080e7          	jalr	-1042(ra) # 80006372 <release>
}
    8000578c:	60e2                	ld	ra,24(sp)
    8000578e:	6442                	ld	s0,16(sp)
    80005790:	6105                	addi	sp,sp,32
    80005792:	8082                	ret
      panic("virtio_disk_intr status");
    80005794:	00003517          	auipc	a0,0x3
    80005798:	eec50513          	addi	a0,a0,-276 # 80008680 <etext+0x680>
    8000579c:	00000097          	auipc	ra,0x0
    800057a0:	5d0080e7          	jalr	1488(ra) # 80005d6c <panic>

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
    800058c0:	0a0080e7          	jalr	160(ra) # 8000195c <either_copyin>
    800058c4:	03550663          	beq	a0,s5,800058f0 <consolewrite+0x66>
      break;
    uartputc(c);
    800058c8:	faf44503          	lbu	a0,-81(s0)
    800058cc:	00001097          	auipc	ra,0x1
    800058d0:	834080e7          	jalr	-1996(ra) # 80006100 <uartputc>
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
    80005930:	996080e7          	jalr	-1642(ra) # 800062c2 <acquire>
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
    80005958:	542080e7          	jalr	1346(ra) # 80000e96 <myproc>
    8000595c:	551c                	lw	a5,40(a0)
    8000595e:	e7ad                	bnez	a5,800059c8 <consoleread+0xc0>
      sleep(&cons.r, &cons.lock);
    80005960:	85a6                	mv	a1,s1
    80005962:	854a                	mv	a0,s2
    80005964:	ffffc097          	auipc	ra,0xffffc
    80005968:	c04080e7          	jalr	-1020(ra) # 80001568 <sleep>
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
    800059b0:	f5a080e7          	jalr	-166(ra) # 80001906 <either_copyout>
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
    800059d4:	9a2080e7          	jalr	-1630(ra) # 80006372 <release>
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
    80005a14:	962080e7          	jalr	-1694(ra) # 80006372 <release>
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
    80005a36:	5f0080e7          	jalr	1520(ra) # 80006022 <uartputc_sync>
}
    80005a3a:	60a2                	ld	ra,8(sp)
    80005a3c:	6402                	ld	s0,0(sp)
    80005a3e:	0141                	addi	sp,sp,16
    80005a40:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005a42:	4521                	li	a0,8
    80005a44:	00000097          	auipc	ra,0x0
    80005a48:	5de080e7          	jalr	1502(ra) # 80006022 <uartputc_sync>
    80005a4c:	02000513          	li	a0,32
    80005a50:	00000097          	auipc	ra,0x0
    80005a54:	5d2080e7          	jalr	1490(ra) # 80006022 <uartputc_sync>
    80005a58:	4521                	li	a0,8
    80005a5a:	00000097          	auipc	ra,0x0
    80005a5e:	5c8080e7          	jalr	1480(ra) # 80006022 <uartputc_sync>
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
    80005a78:	00001097          	auipc	ra,0x1
    80005a7c:	84a080e7          	jalr	-1974(ra) # 800062c2 <acquire>

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
    80005a9a:	f1c080e7          	jalr	-228(ra) # 800019b2 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005a9e:	00020517          	auipc	a0,0x20
    80005aa2:	6a250513          	addi	a0,a0,1698 # 80026140 <cons>
    80005aa6:	00001097          	auipc	ra,0x1
    80005aaa:	8cc080e7          	jalr	-1844(ra) # 80006372 <release>
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
    80005bfe:	af4080e7          	jalr	-1292(ra) # 800016ee <wakeup>
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
    80005c20:	612080e7          	jalr	1554(ra) # 8000622e <initlock>

  uartinit();
    80005c24:	00000097          	auipc	ra,0x0
    80005c28:	3a4080e7          	jalr	932(ra) # 80005fc8 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005c2c:	00014797          	auipc	a5,0x14
    80005c30:	a9c78793          	addi	a5,a5,-1380 # 800196c8 <devsw>
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
    80005c70:	ba480813          	addi	a6,a6,-1116 # 80008810 <digits>
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

0000000080005ce2 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005ce2:	1101                	addi	sp,sp,-32
    80005ce4:	ec06                	sd	ra,24(sp)
    80005ce6:	e822                	sd	s0,16(sp)
    80005ce8:	e426                	sd	s1,8(sp)
    80005cea:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005cec:	00020497          	auipc	s1,0x20
    80005cf0:	4fc48493          	addi	s1,s1,1276 # 800261e8 <pr>
    80005cf4:	00003597          	auipc	a1,0x3
    80005cf8:	9ac58593          	addi	a1,a1,-1620 # 800086a0 <etext+0x6a0>
    80005cfc:	8526                	mv	a0,s1
    80005cfe:	00000097          	auipc	ra,0x0
    80005d02:	530080e7          	jalr	1328(ra) # 8000622e <initlock>
  pr.locking = 1;
    80005d06:	4785                	li	a5,1
    80005d08:	cc9c                	sw	a5,24(s1)
}
    80005d0a:	60e2                	ld	ra,24(sp)
    80005d0c:	6442                	ld	s0,16(sp)
    80005d0e:	64a2                	ld	s1,8(sp)
    80005d10:	6105                	addi	sp,sp,32
    80005d12:	8082                	ret

0000000080005d14 <backtrace>:

void backtrace(void) {
    80005d14:	7179                	addi	sp,sp,-48
    80005d16:	f406                	sd	ra,40(sp)
    80005d18:	f022                	sd	s0,32(sp)
    80005d1a:	ec26                	sd	s1,24(sp)
    80005d1c:	e84a                	sd	s2,16(sp)
    80005d1e:	e44e                	sd	s3,8(sp)
    80005d20:	e052                	sd	s4,0(sp)
    80005d22:	1800                	addi	s0,sp,48
  asm volatile("mv %0, s0" : "=r" (x) );
    80005d24:	84a2                	mv	s1,s0
  uint64 fp = r_fp();
  uint64 high = PGROUNDUP(fp), low = PGROUNDDOWN(fp);
    80005d26:	6905                	lui	s2,0x1
    80005d28:	197d                	addi	s2,s2,-1 # fff <_entry-0x7ffff001>
    80005d2a:	9926                	add	s2,s2,s1
    80005d2c:	79fd                	lui	s3,0xfffff
    80005d2e:	01397933          	and	s2,s2,s3
    80005d32:	0134f9b3          	and	s3,s1,s3
  while (fp > low && fp < high) {
    uint64 ra = fp - 8;
    uint64 next_fp = fp - 16;
    printf("%p\n", *(uint64*)ra);
    80005d36:	00003a17          	auipc	s4,0x3
    80005d3a:	972a0a13          	addi	s4,s4,-1678 # 800086a8 <etext+0x6a8>
  while (fp > low && fp < high) {
    80005d3e:	0099ff63          	bgeu	s3,s1,80005d5c <backtrace+0x48>
    80005d42:	0124fd63          	bgeu	s1,s2,80005d5c <backtrace+0x48>
    printf("%p\n", *(uint64*)ra);
    80005d46:	ff84b583          	ld	a1,-8(s1)
    80005d4a:	8552                	mv	a0,s4
    80005d4c:	00000097          	auipc	ra,0x0
    80005d50:	072080e7          	jalr	114(ra) # 80005dbe <printf>
    fp = *(uint64*)next_fp;
    80005d54:	ff04b483          	ld	s1,-16(s1)
  while (fp > low && fp < high) {
    80005d58:	fe99e5e3          	bltu	s3,s1,80005d42 <backtrace+0x2e>
  }
    80005d5c:	70a2                	ld	ra,40(sp)
    80005d5e:	7402                	ld	s0,32(sp)
    80005d60:	64e2                	ld	s1,24(sp)
    80005d62:	6942                	ld	s2,16(sp)
    80005d64:	69a2                	ld	s3,8(sp)
    80005d66:	6a02                	ld	s4,0(sp)
    80005d68:	6145                	addi	sp,sp,48
    80005d6a:	8082                	ret

0000000080005d6c <panic>:
{
    80005d6c:	1101                	addi	sp,sp,-32
    80005d6e:	ec06                	sd	ra,24(sp)
    80005d70:	e822                	sd	s0,16(sp)
    80005d72:	e426                	sd	s1,8(sp)
    80005d74:	1000                	addi	s0,sp,32
    80005d76:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005d78:	00020797          	auipc	a5,0x20
    80005d7c:	4807a423          	sw	zero,1160(a5) # 80026200 <pr+0x18>
  printf("panic: ");
    80005d80:	00003517          	auipc	a0,0x3
    80005d84:	93050513          	addi	a0,a0,-1744 # 800086b0 <etext+0x6b0>
    80005d88:	00000097          	auipc	ra,0x0
    80005d8c:	036080e7          	jalr	54(ra) # 80005dbe <printf>
  printf(s);
    80005d90:	8526                	mv	a0,s1
    80005d92:	00000097          	auipc	ra,0x0
    80005d96:	02c080e7          	jalr	44(ra) # 80005dbe <printf>
  printf("\n");
    80005d9a:	00002517          	auipc	a0,0x2
    80005d9e:	27e50513          	addi	a0,a0,638 # 80008018 <etext+0x18>
    80005da2:	00000097          	auipc	ra,0x0
    80005da6:	01c080e7          	jalr	28(ra) # 80005dbe <printf>
  backtrace();
    80005daa:	00000097          	auipc	ra,0x0
    80005dae:	f6a080e7          	jalr	-150(ra) # 80005d14 <backtrace>
  panicked = 1; // freeze uart output from other CPUs
    80005db2:	4785                	li	a5,1
    80005db4:	00003717          	auipc	a4,0x3
    80005db8:	26f72423          	sw	a5,616(a4) # 8000901c <panicked>
  for(;;)
    80005dbc:	a001                	j	80005dbc <panic+0x50>

0000000080005dbe <printf>:
{
    80005dbe:	7131                	addi	sp,sp,-192
    80005dc0:	fc86                	sd	ra,120(sp)
    80005dc2:	f8a2                	sd	s0,112(sp)
    80005dc4:	e8d2                	sd	s4,80(sp)
    80005dc6:	ec6e                	sd	s11,24(sp)
    80005dc8:	0100                	addi	s0,sp,128
    80005dca:	8a2a                	mv	s4,a0
    80005dcc:	e40c                	sd	a1,8(s0)
    80005dce:	e810                	sd	a2,16(s0)
    80005dd0:	ec14                	sd	a3,24(s0)
    80005dd2:	f018                	sd	a4,32(s0)
    80005dd4:	f41c                	sd	a5,40(s0)
    80005dd6:	03043823          	sd	a6,48(s0)
    80005dda:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005dde:	00020d97          	auipc	s11,0x20
    80005de2:	422dad83          	lw	s11,1058(s11) # 80026200 <pr+0x18>
  if(locking)
    80005de6:	040d9463          	bnez	s11,80005e2e <printf+0x70>
  if (fmt == 0)
    80005dea:	040a0b63          	beqz	s4,80005e40 <printf+0x82>
  va_start(ap, fmt);
    80005dee:	00840793          	addi	a5,s0,8
    80005df2:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005df6:	000a4503          	lbu	a0,0(s4)
    80005dfa:	18050c63          	beqz	a0,80005f92 <printf+0x1d4>
    80005dfe:	f4a6                	sd	s1,104(sp)
    80005e00:	f0ca                	sd	s2,96(sp)
    80005e02:	ecce                	sd	s3,88(sp)
    80005e04:	e4d6                	sd	s5,72(sp)
    80005e06:	e0da                	sd	s6,64(sp)
    80005e08:	fc5e                	sd	s7,56(sp)
    80005e0a:	f862                	sd	s8,48(sp)
    80005e0c:	f466                	sd	s9,40(sp)
    80005e0e:	f06a                	sd	s10,32(sp)
    80005e10:	4981                	li	s3,0
    if(c != '%'){
    80005e12:	02500b13          	li	s6,37
    switch(c){
    80005e16:	07000b93          	li	s7,112
  consputc('x');
    80005e1a:	07800c93          	li	s9,120
    80005e1e:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005e20:	00003a97          	auipc	s5,0x3
    80005e24:	9f0a8a93          	addi	s5,s5,-1552 # 80008810 <digits>
    switch(c){
    80005e28:	07300c13          	li	s8,115
    80005e2c:	a0b9                	j	80005e7a <printf+0xbc>
    acquire(&pr.lock);
    80005e2e:	00020517          	auipc	a0,0x20
    80005e32:	3ba50513          	addi	a0,a0,954 # 800261e8 <pr>
    80005e36:	00000097          	auipc	ra,0x0
    80005e3a:	48c080e7          	jalr	1164(ra) # 800062c2 <acquire>
    80005e3e:	b775                	j	80005dea <printf+0x2c>
    80005e40:	f4a6                	sd	s1,104(sp)
    80005e42:	f0ca                	sd	s2,96(sp)
    80005e44:	ecce                	sd	s3,88(sp)
    80005e46:	e4d6                	sd	s5,72(sp)
    80005e48:	e0da                	sd	s6,64(sp)
    80005e4a:	fc5e                	sd	s7,56(sp)
    80005e4c:	f862                	sd	s8,48(sp)
    80005e4e:	f466                	sd	s9,40(sp)
    80005e50:	f06a                	sd	s10,32(sp)
    panic("null fmt");
    80005e52:	00003517          	auipc	a0,0x3
    80005e56:	86e50513          	addi	a0,a0,-1938 # 800086c0 <etext+0x6c0>
    80005e5a:	00000097          	auipc	ra,0x0
    80005e5e:	f12080e7          	jalr	-238(ra) # 80005d6c <panic>
      consputc(c);
    80005e62:	00000097          	auipc	ra,0x0
    80005e66:	bc0080e7          	jalr	-1088(ra) # 80005a22 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005e6a:	0019879b          	addiw	a5,s3,1 # fffffffffffff001 <end+0xffffffff7ffd8dc1>
    80005e6e:	89be                	mv	s3,a5
    80005e70:	97d2                	add	a5,a5,s4
    80005e72:	0007c503          	lbu	a0,0(a5)
    80005e76:	10050563          	beqz	a0,80005f80 <printf+0x1c2>
    if(c != '%'){
    80005e7a:	ff6514e3          	bne	a0,s6,80005e62 <printf+0xa4>
    c = fmt[++i] & 0xff;
    80005e7e:	0019879b          	addiw	a5,s3,1
    80005e82:	89be                	mv	s3,a5
    80005e84:	97d2                	add	a5,a5,s4
    80005e86:	0007c783          	lbu	a5,0(a5)
    80005e8a:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005e8e:	10078a63          	beqz	a5,80005fa2 <printf+0x1e4>
    switch(c){
    80005e92:	05778a63          	beq	a5,s7,80005ee6 <printf+0x128>
    80005e96:	02fbf463          	bgeu	s7,a5,80005ebe <printf+0x100>
    80005e9a:	09878763          	beq	a5,s8,80005f28 <printf+0x16a>
    80005e9e:	0d979663          	bne	a5,s9,80005f6a <printf+0x1ac>
      printint(va_arg(ap, int), 16, 1);
    80005ea2:	f8843783          	ld	a5,-120(s0)
    80005ea6:	00878713          	addi	a4,a5,8
    80005eaa:	f8e43423          	sd	a4,-120(s0)
    80005eae:	4605                	li	a2,1
    80005eb0:	85ea                	mv	a1,s10
    80005eb2:	4388                	lw	a0,0(a5)
    80005eb4:	00000097          	auipc	ra,0x0
    80005eb8:	d9c080e7          	jalr	-612(ra) # 80005c50 <printint>
      break;
    80005ebc:	b77d                	j	80005e6a <printf+0xac>
    switch(c){
    80005ebe:	0b678063          	beq	a5,s6,80005f5e <printf+0x1a0>
    80005ec2:	06400713          	li	a4,100
    80005ec6:	0ae79263          	bne	a5,a4,80005f6a <printf+0x1ac>
      printint(va_arg(ap, int), 10, 1);
    80005eca:	f8843783          	ld	a5,-120(s0)
    80005ece:	00878713          	addi	a4,a5,8
    80005ed2:	f8e43423          	sd	a4,-120(s0)
    80005ed6:	4605                	li	a2,1
    80005ed8:	45a9                	li	a1,10
    80005eda:	4388                	lw	a0,0(a5)
    80005edc:	00000097          	auipc	ra,0x0
    80005ee0:	d74080e7          	jalr	-652(ra) # 80005c50 <printint>
      break;
    80005ee4:	b759                	j	80005e6a <printf+0xac>
      printptr(va_arg(ap, uint64));
    80005ee6:	f8843783          	ld	a5,-120(s0)
    80005eea:	00878713          	addi	a4,a5,8
    80005eee:	f8e43423          	sd	a4,-120(s0)
    80005ef2:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005ef6:	03000513          	li	a0,48
    80005efa:	00000097          	auipc	ra,0x0
    80005efe:	b28080e7          	jalr	-1240(ra) # 80005a22 <consputc>
  consputc('x');
    80005f02:	8566                	mv	a0,s9
    80005f04:	00000097          	auipc	ra,0x0
    80005f08:	b1e080e7          	jalr	-1250(ra) # 80005a22 <consputc>
    80005f0c:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005f0e:	03c95793          	srli	a5,s2,0x3c
    80005f12:	97d6                	add	a5,a5,s5
    80005f14:	0007c503          	lbu	a0,0(a5)
    80005f18:	00000097          	auipc	ra,0x0
    80005f1c:	b0a080e7          	jalr	-1270(ra) # 80005a22 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005f20:	0912                	slli	s2,s2,0x4
    80005f22:	34fd                	addiw	s1,s1,-1
    80005f24:	f4ed                	bnez	s1,80005f0e <printf+0x150>
    80005f26:	b791                	j	80005e6a <printf+0xac>
      if((s = va_arg(ap, char*)) == 0)
    80005f28:	f8843783          	ld	a5,-120(s0)
    80005f2c:	00878713          	addi	a4,a5,8
    80005f30:	f8e43423          	sd	a4,-120(s0)
    80005f34:	6384                	ld	s1,0(a5)
    80005f36:	cc89                	beqz	s1,80005f50 <printf+0x192>
      for(; *s; s++)
    80005f38:	0004c503          	lbu	a0,0(s1)
    80005f3c:	d51d                	beqz	a0,80005e6a <printf+0xac>
        consputc(*s);
    80005f3e:	00000097          	auipc	ra,0x0
    80005f42:	ae4080e7          	jalr	-1308(ra) # 80005a22 <consputc>
      for(; *s; s++)
    80005f46:	0485                	addi	s1,s1,1
    80005f48:	0004c503          	lbu	a0,0(s1)
    80005f4c:	f96d                	bnez	a0,80005f3e <printf+0x180>
    80005f4e:	bf31                	j	80005e6a <printf+0xac>
        s = "(null)";
    80005f50:	00002497          	auipc	s1,0x2
    80005f54:	76848493          	addi	s1,s1,1896 # 800086b8 <etext+0x6b8>
      for(; *s; s++)
    80005f58:	02800513          	li	a0,40
    80005f5c:	b7cd                	j	80005f3e <printf+0x180>
      consputc('%');
    80005f5e:	855a                	mv	a0,s6
    80005f60:	00000097          	auipc	ra,0x0
    80005f64:	ac2080e7          	jalr	-1342(ra) # 80005a22 <consputc>
      break;
    80005f68:	b709                	j	80005e6a <printf+0xac>
      consputc('%');
    80005f6a:	855a                	mv	a0,s6
    80005f6c:	00000097          	auipc	ra,0x0
    80005f70:	ab6080e7          	jalr	-1354(ra) # 80005a22 <consputc>
      consputc(c);
    80005f74:	8526                	mv	a0,s1
    80005f76:	00000097          	auipc	ra,0x0
    80005f7a:	aac080e7          	jalr	-1364(ra) # 80005a22 <consputc>
      break;
    80005f7e:	b5f5                	j	80005e6a <printf+0xac>
    80005f80:	74a6                	ld	s1,104(sp)
    80005f82:	7906                	ld	s2,96(sp)
    80005f84:	69e6                	ld	s3,88(sp)
    80005f86:	6aa6                	ld	s5,72(sp)
    80005f88:	6b06                	ld	s6,64(sp)
    80005f8a:	7be2                	ld	s7,56(sp)
    80005f8c:	7c42                	ld	s8,48(sp)
    80005f8e:	7ca2                	ld	s9,40(sp)
    80005f90:	7d02                	ld	s10,32(sp)
  if(locking)
    80005f92:	020d9263          	bnez	s11,80005fb6 <printf+0x1f8>
}
    80005f96:	70e6                	ld	ra,120(sp)
    80005f98:	7446                	ld	s0,112(sp)
    80005f9a:	6a46                	ld	s4,80(sp)
    80005f9c:	6de2                	ld	s11,24(sp)
    80005f9e:	6129                	addi	sp,sp,192
    80005fa0:	8082                	ret
    80005fa2:	74a6                	ld	s1,104(sp)
    80005fa4:	7906                	ld	s2,96(sp)
    80005fa6:	69e6                	ld	s3,88(sp)
    80005fa8:	6aa6                	ld	s5,72(sp)
    80005faa:	6b06                	ld	s6,64(sp)
    80005fac:	7be2                	ld	s7,56(sp)
    80005fae:	7c42                	ld	s8,48(sp)
    80005fb0:	7ca2                	ld	s9,40(sp)
    80005fb2:	7d02                	ld	s10,32(sp)
    80005fb4:	bff9                	j	80005f92 <printf+0x1d4>
    release(&pr.lock);
    80005fb6:	00020517          	auipc	a0,0x20
    80005fba:	23250513          	addi	a0,a0,562 # 800261e8 <pr>
    80005fbe:	00000097          	auipc	ra,0x0
    80005fc2:	3b4080e7          	jalr	948(ra) # 80006372 <release>
}
    80005fc6:	bfc1                	j	80005f96 <printf+0x1d8>

0000000080005fc8 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005fc8:	1141                	addi	sp,sp,-16
    80005fca:	e406                	sd	ra,8(sp)
    80005fcc:	e022                	sd	s0,0(sp)
    80005fce:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005fd0:	100007b7          	lui	a5,0x10000
    80005fd4:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005fd8:	10000737          	lui	a4,0x10000
    80005fdc:	f8000693          	li	a3,-128
    80005fe0:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005fe4:	468d                	li	a3,3
    80005fe6:	10000637          	lui	a2,0x10000
    80005fea:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005fee:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005ff2:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005ff6:	8732                	mv	a4,a2
    80005ff8:	461d                	li	a2,7
    80005ffa:	00c70123          	sb	a2,2(a4)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005ffe:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    80006002:	00002597          	auipc	a1,0x2
    80006006:	6ce58593          	addi	a1,a1,1742 # 800086d0 <etext+0x6d0>
    8000600a:	00020517          	auipc	a0,0x20
    8000600e:	1fe50513          	addi	a0,a0,510 # 80026208 <uart_tx_lock>
    80006012:	00000097          	auipc	ra,0x0
    80006016:	21c080e7          	jalr	540(ra) # 8000622e <initlock>
}
    8000601a:	60a2                	ld	ra,8(sp)
    8000601c:	6402                	ld	s0,0(sp)
    8000601e:	0141                	addi	sp,sp,16
    80006020:	8082                	ret

0000000080006022 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80006022:	1101                	addi	sp,sp,-32
    80006024:	ec06                	sd	ra,24(sp)
    80006026:	e822                	sd	s0,16(sp)
    80006028:	e426                	sd	s1,8(sp)
    8000602a:	1000                	addi	s0,sp,32
    8000602c:	84aa                	mv	s1,a0
  push_off();
    8000602e:	00000097          	auipc	ra,0x0
    80006032:	248080e7          	jalr	584(ra) # 80006276 <push_off>

  if(panicked){
    80006036:	00003797          	auipc	a5,0x3
    8000603a:	fe67a783          	lw	a5,-26(a5) # 8000901c <panicked>
    8000603e:	eb85                	bnez	a5,8000606e <uartputc_sync+0x4c>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006040:	10000737          	lui	a4,0x10000
    80006044:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80006046:	00074783          	lbu	a5,0(a4)
    8000604a:	0207f793          	andi	a5,a5,32
    8000604e:	dfe5                	beqz	a5,80006046 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80006050:	0ff4f513          	zext.b	a0,s1
    80006054:	100007b7          	lui	a5,0x10000
    80006058:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    8000605c:	00000097          	auipc	ra,0x0
    80006060:	2ba080e7          	jalr	698(ra) # 80006316 <pop_off>
}
    80006064:	60e2                	ld	ra,24(sp)
    80006066:	6442                	ld	s0,16(sp)
    80006068:	64a2                	ld	s1,8(sp)
    8000606a:	6105                	addi	sp,sp,32
    8000606c:	8082                	ret
    for(;;)
    8000606e:	a001                	j	8000606e <uartputc_sync+0x4c>

0000000080006070 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80006070:	00003797          	auipc	a5,0x3
    80006074:	fb07b783          	ld	a5,-80(a5) # 80009020 <uart_tx_r>
    80006078:	00003717          	auipc	a4,0x3
    8000607c:	fb073703          	ld	a4,-80(a4) # 80009028 <uart_tx_w>
    80006080:	06f70f63          	beq	a4,a5,800060fe <uartstart+0x8e>
{
    80006084:	7139                	addi	sp,sp,-64
    80006086:	fc06                	sd	ra,56(sp)
    80006088:	f822                	sd	s0,48(sp)
    8000608a:	f426                	sd	s1,40(sp)
    8000608c:	f04a                	sd	s2,32(sp)
    8000608e:	ec4e                	sd	s3,24(sp)
    80006090:	e852                	sd	s4,16(sp)
    80006092:	e456                	sd	s5,8(sp)
    80006094:	e05a                	sd	s6,0(sp)
    80006096:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006098:	10000937          	lui	s2,0x10000
    8000609c:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000609e:	00020a97          	auipc	s5,0x20
    800060a2:	16aa8a93          	addi	s5,s5,362 # 80026208 <uart_tx_lock>
    uart_tx_r += 1;
    800060a6:	00003497          	auipc	s1,0x3
    800060aa:	f7a48493          	addi	s1,s1,-134 # 80009020 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    800060ae:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    800060b2:	00003997          	auipc	s3,0x3
    800060b6:	f7698993          	addi	s3,s3,-138 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800060ba:	00094703          	lbu	a4,0(s2)
    800060be:	02077713          	andi	a4,a4,32
    800060c2:	c705                	beqz	a4,800060ea <uartstart+0x7a>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800060c4:	01f7f713          	andi	a4,a5,31
    800060c8:	9756                	add	a4,a4,s5
    800060ca:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    800060ce:	0785                	addi	a5,a5,1
    800060d0:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    800060d2:	8526                	mv	a0,s1
    800060d4:	ffffb097          	auipc	ra,0xffffb
    800060d8:	61a080e7          	jalr	1562(ra) # 800016ee <wakeup>
    WriteReg(THR, c);
    800060dc:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    800060e0:	609c                	ld	a5,0(s1)
    800060e2:	0009b703          	ld	a4,0(s3)
    800060e6:	fcf71ae3          	bne	a4,a5,800060ba <uartstart+0x4a>
  }
}
    800060ea:	70e2                	ld	ra,56(sp)
    800060ec:	7442                	ld	s0,48(sp)
    800060ee:	74a2                	ld	s1,40(sp)
    800060f0:	7902                	ld	s2,32(sp)
    800060f2:	69e2                	ld	s3,24(sp)
    800060f4:	6a42                	ld	s4,16(sp)
    800060f6:	6aa2                	ld	s5,8(sp)
    800060f8:	6b02                	ld	s6,0(sp)
    800060fa:	6121                	addi	sp,sp,64
    800060fc:	8082                	ret
    800060fe:	8082                	ret

0000000080006100 <uartputc>:
{
    80006100:	7179                	addi	sp,sp,-48
    80006102:	f406                	sd	ra,40(sp)
    80006104:	f022                	sd	s0,32(sp)
    80006106:	e052                	sd	s4,0(sp)
    80006108:	1800                	addi	s0,sp,48
    8000610a:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    8000610c:	00020517          	auipc	a0,0x20
    80006110:	0fc50513          	addi	a0,a0,252 # 80026208 <uart_tx_lock>
    80006114:	00000097          	auipc	ra,0x0
    80006118:	1ae080e7          	jalr	430(ra) # 800062c2 <acquire>
  if(panicked){
    8000611c:	00003797          	auipc	a5,0x3
    80006120:	f007a783          	lw	a5,-256(a5) # 8000901c <panicked>
    80006124:	c391                	beqz	a5,80006128 <uartputc+0x28>
    for(;;)
    80006126:	a001                	j	80006126 <uartputc+0x26>
    80006128:	ec26                	sd	s1,24(sp)
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000612a:	00003717          	auipc	a4,0x3
    8000612e:	efe73703          	ld	a4,-258(a4) # 80009028 <uart_tx_w>
    80006132:	00003797          	auipc	a5,0x3
    80006136:	eee7b783          	ld	a5,-274(a5) # 80009020 <uart_tx_r>
    8000613a:	02078793          	addi	a5,a5,32
    8000613e:	02e79f63          	bne	a5,a4,8000617c <uartputc+0x7c>
    80006142:	e84a                	sd	s2,16(sp)
    80006144:	e44e                	sd	s3,8(sp)
      sleep(&uart_tx_r, &uart_tx_lock);
    80006146:	00020997          	auipc	s3,0x20
    8000614a:	0c298993          	addi	s3,s3,194 # 80026208 <uart_tx_lock>
    8000614e:	00003497          	auipc	s1,0x3
    80006152:	ed248493          	addi	s1,s1,-302 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006156:	00003917          	auipc	s2,0x3
    8000615a:	ed290913          	addi	s2,s2,-302 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    8000615e:	85ce                	mv	a1,s3
    80006160:	8526                	mv	a0,s1
    80006162:	ffffb097          	auipc	ra,0xffffb
    80006166:	406080e7          	jalr	1030(ra) # 80001568 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000616a:	00093703          	ld	a4,0(s2)
    8000616e:	609c                	ld	a5,0(s1)
    80006170:	02078793          	addi	a5,a5,32
    80006174:	fee785e3          	beq	a5,a4,8000615e <uartputc+0x5e>
    80006178:	6942                	ld	s2,16(sp)
    8000617a:	69a2                	ld	s3,8(sp)
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    8000617c:	00020497          	auipc	s1,0x20
    80006180:	08c48493          	addi	s1,s1,140 # 80026208 <uart_tx_lock>
    80006184:	01f77793          	andi	a5,a4,31
    80006188:	97a6                	add	a5,a5,s1
    8000618a:	01478c23          	sb	s4,24(a5)
      uart_tx_w += 1;
    8000618e:	0705                	addi	a4,a4,1
    80006190:	00003797          	auipc	a5,0x3
    80006194:	e8e7bc23          	sd	a4,-360(a5) # 80009028 <uart_tx_w>
      uartstart();
    80006198:	00000097          	auipc	ra,0x0
    8000619c:	ed8080e7          	jalr	-296(ra) # 80006070 <uartstart>
      release(&uart_tx_lock);
    800061a0:	8526                	mv	a0,s1
    800061a2:	00000097          	auipc	ra,0x0
    800061a6:	1d0080e7          	jalr	464(ra) # 80006372 <release>
    800061aa:	64e2                	ld	s1,24(sp)
}
    800061ac:	70a2                	ld	ra,40(sp)
    800061ae:	7402                	ld	s0,32(sp)
    800061b0:	6a02                	ld	s4,0(sp)
    800061b2:	6145                	addi	sp,sp,48
    800061b4:	8082                	ret

00000000800061b6 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800061b6:	1141                	addi	sp,sp,-16
    800061b8:	e406                	sd	ra,8(sp)
    800061ba:	e022                	sd	s0,0(sp)
    800061bc:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800061be:	100007b7          	lui	a5,0x10000
    800061c2:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800061c6:	8b85                	andi	a5,a5,1
    800061c8:	cb89                	beqz	a5,800061da <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    800061ca:	100007b7          	lui	a5,0x10000
    800061ce:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800061d2:	60a2                	ld	ra,8(sp)
    800061d4:	6402                	ld	s0,0(sp)
    800061d6:	0141                	addi	sp,sp,16
    800061d8:	8082                	ret
    return -1;
    800061da:	557d                	li	a0,-1
    800061dc:	bfdd                	j	800061d2 <uartgetc+0x1c>

00000000800061de <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    800061de:	1101                	addi	sp,sp,-32
    800061e0:	ec06                	sd	ra,24(sp)
    800061e2:	e822                	sd	s0,16(sp)
    800061e4:	e426                	sd	s1,8(sp)
    800061e6:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800061e8:	54fd                	li	s1,-1
    int c = uartgetc();
    800061ea:	00000097          	auipc	ra,0x0
    800061ee:	fcc080e7          	jalr	-52(ra) # 800061b6 <uartgetc>
    if(c == -1)
    800061f2:	00950763          	beq	a0,s1,80006200 <uartintr+0x22>
      break;
    consoleintr(c);
    800061f6:	00000097          	auipc	ra,0x0
    800061fa:	86e080e7          	jalr	-1938(ra) # 80005a64 <consoleintr>
  while(1){
    800061fe:	b7f5                	j	800061ea <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006200:	00020497          	auipc	s1,0x20
    80006204:	00848493          	addi	s1,s1,8 # 80026208 <uart_tx_lock>
    80006208:	8526                	mv	a0,s1
    8000620a:	00000097          	auipc	ra,0x0
    8000620e:	0b8080e7          	jalr	184(ra) # 800062c2 <acquire>
  uartstart();
    80006212:	00000097          	auipc	ra,0x0
    80006216:	e5e080e7          	jalr	-418(ra) # 80006070 <uartstart>
  release(&uart_tx_lock);
    8000621a:	8526                	mv	a0,s1
    8000621c:	00000097          	auipc	ra,0x0
    80006220:	156080e7          	jalr	342(ra) # 80006372 <release>
}
    80006224:	60e2                	ld	ra,24(sp)
    80006226:	6442                	ld	s0,16(sp)
    80006228:	64a2                	ld	s1,8(sp)
    8000622a:	6105                	addi	sp,sp,32
    8000622c:	8082                	ret

000000008000622e <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    8000622e:	1141                	addi	sp,sp,-16
    80006230:	e406                	sd	ra,8(sp)
    80006232:	e022                	sd	s0,0(sp)
    80006234:	0800                	addi	s0,sp,16
  lk->name = name;
    80006236:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80006238:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    8000623c:	00053823          	sd	zero,16(a0)
}
    80006240:	60a2                	ld	ra,8(sp)
    80006242:	6402                	ld	s0,0(sp)
    80006244:	0141                	addi	sp,sp,16
    80006246:	8082                	ret

0000000080006248 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006248:	411c                	lw	a5,0(a0)
    8000624a:	e399                	bnez	a5,80006250 <holding+0x8>
    8000624c:	4501                	li	a0,0
  return r;
}
    8000624e:	8082                	ret
{
    80006250:	1101                	addi	sp,sp,-32
    80006252:	ec06                	sd	ra,24(sp)
    80006254:	e822                	sd	s0,16(sp)
    80006256:	e426                	sd	s1,8(sp)
    80006258:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    8000625a:	6904                	ld	s1,16(a0)
    8000625c:	ffffb097          	auipc	ra,0xffffb
    80006260:	c1a080e7          	jalr	-998(ra) # 80000e76 <mycpu>
    80006264:	40a48533          	sub	a0,s1,a0
    80006268:	00153513          	seqz	a0,a0
}
    8000626c:	60e2                	ld	ra,24(sp)
    8000626e:	6442                	ld	s0,16(sp)
    80006270:	64a2                	ld	s1,8(sp)
    80006272:	6105                	addi	sp,sp,32
    80006274:	8082                	ret

0000000080006276 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006276:	1101                	addi	sp,sp,-32
    80006278:	ec06                	sd	ra,24(sp)
    8000627a:	e822                	sd	s0,16(sp)
    8000627c:	e426                	sd	s1,8(sp)
    8000627e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006280:	100024f3          	csrr	s1,sstatus
    80006284:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006288:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000628a:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    8000628e:	ffffb097          	auipc	ra,0xffffb
    80006292:	be8080e7          	jalr	-1048(ra) # 80000e76 <mycpu>
    80006296:	5d3c                	lw	a5,120(a0)
    80006298:	cf89                	beqz	a5,800062b2 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    8000629a:	ffffb097          	auipc	ra,0xffffb
    8000629e:	bdc080e7          	jalr	-1060(ra) # 80000e76 <mycpu>
    800062a2:	5d3c                	lw	a5,120(a0)
    800062a4:	2785                	addiw	a5,a5,1
    800062a6:	dd3c                	sw	a5,120(a0)
}
    800062a8:	60e2                	ld	ra,24(sp)
    800062aa:	6442                	ld	s0,16(sp)
    800062ac:	64a2                	ld	s1,8(sp)
    800062ae:	6105                	addi	sp,sp,32
    800062b0:	8082                	ret
    mycpu()->intena = old;
    800062b2:	ffffb097          	auipc	ra,0xffffb
    800062b6:	bc4080e7          	jalr	-1084(ra) # 80000e76 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800062ba:	8085                	srli	s1,s1,0x1
    800062bc:	8885                	andi	s1,s1,1
    800062be:	dd64                	sw	s1,124(a0)
    800062c0:	bfe9                	j	8000629a <push_off+0x24>

00000000800062c2 <acquire>:
{
    800062c2:	1101                	addi	sp,sp,-32
    800062c4:	ec06                	sd	ra,24(sp)
    800062c6:	e822                	sd	s0,16(sp)
    800062c8:	e426                	sd	s1,8(sp)
    800062ca:	1000                	addi	s0,sp,32
    800062cc:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800062ce:	00000097          	auipc	ra,0x0
    800062d2:	fa8080e7          	jalr	-88(ra) # 80006276 <push_off>
  if(holding(lk))
    800062d6:	8526                	mv	a0,s1
    800062d8:	00000097          	auipc	ra,0x0
    800062dc:	f70080e7          	jalr	-144(ra) # 80006248 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800062e0:	4705                	li	a4,1
  if(holding(lk))
    800062e2:	e115                	bnez	a0,80006306 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800062e4:	87ba                	mv	a5,a4
    800062e6:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800062ea:	2781                	sext.w	a5,a5
    800062ec:	ffe5                	bnez	a5,800062e4 <acquire+0x22>
  __sync_synchronize();
    800062ee:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    800062f2:	ffffb097          	auipc	ra,0xffffb
    800062f6:	b84080e7          	jalr	-1148(ra) # 80000e76 <mycpu>
    800062fa:	e888                	sd	a0,16(s1)
}
    800062fc:	60e2                	ld	ra,24(sp)
    800062fe:	6442                	ld	s0,16(sp)
    80006300:	64a2                	ld	s1,8(sp)
    80006302:	6105                	addi	sp,sp,32
    80006304:	8082                	ret
    panic("acquire");
    80006306:	00002517          	auipc	a0,0x2
    8000630a:	3d250513          	addi	a0,a0,978 # 800086d8 <etext+0x6d8>
    8000630e:	00000097          	auipc	ra,0x0
    80006312:	a5e080e7          	jalr	-1442(ra) # 80005d6c <panic>

0000000080006316 <pop_off>:

void
pop_off(void)
{
    80006316:	1141                	addi	sp,sp,-16
    80006318:	e406                	sd	ra,8(sp)
    8000631a:	e022                	sd	s0,0(sp)
    8000631c:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    8000631e:	ffffb097          	auipc	ra,0xffffb
    80006322:	b58080e7          	jalr	-1192(ra) # 80000e76 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006326:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000632a:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000632c:	e39d                	bnez	a5,80006352 <pop_off+0x3c>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    8000632e:	5d3c                	lw	a5,120(a0)
    80006330:	02f05963          	blez	a5,80006362 <pop_off+0x4c>
    panic("pop_off");
  c->noff -= 1;
    80006334:	37fd                	addiw	a5,a5,-1
    80006336:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006338:	eb89                	bnez	a5,8000634a <pop_off+0x34>
    8000633a:	5d7c                	lw	a5,124(a0)
    8000633c:	c799                	beqz	a5,8000634a <pop_off+0x34>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000633e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006342:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006346:	10079073          	csrw	sstatus,a5
    intr_on();
}
    8000634a:	60a2                	ld	ra,8(sp)
    8000634c:	6402                	ld	s0,0(sp)
    8000634e:	0141                	addi	sp,sp,16
    80006350:	8082                	ret
    panic("pop_off - interruptible");
    80006352:	00002517          	auipc	a0,0x2
    80006356:	38e50513          	addi	a0,a0,910 # 800086e0 <etext+0x6e0>
    8000635a:	00000097          	auipc	ra,0x0
    8000635e:	a12080e7          	jalr	-1518(ra) # 80005d6c <panic>
    panic("pop_off");
    80006362:	00002517          	auipc	a0,0x2
    80006366:	39650513          	addi	a0,a0,918 # 800086f8 <etext+0x6f8>
    8000636a:	00000097          	auipc	ra,0x0
    8000636e:	a02080e7          	jalr	-1534(ra) # 80005d6c <panic>

0000000080006372 <release>:
{
    80006372:	1101                	addi	sp,sp,-32
    80006374:	ec06                	sd	ra,24(sp)
    80006376:	e822                	sd	s0,16(sp)
    80006378:	e426                	sd	s1,8(sp)
    8000637a:	1000                	addi	s0,sp,32
    8000637c:	84aa                	mv	s1,a0
  if(!holding(lk))
    8000637e:	00000097          	auipc	ra,0x0
    80006382:	eca080e7          	jalr	-310(ra) # 80006248 <holding>
    80006386:	c115                	beqz	a0,800063aa <release+0x38>
  lk->cpu = 0;
    80006388:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    8000638c:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    80006390:	0310000f          	fence	rw,w
    80006394:	0004a023          	sw	zero,0(s1)
  pop_off();
    80006398:	00000097          	auipc	ra,0x0
    8000639c:	f7e080e7          	jalr	-130(ra) # 80006316 <pop_off>
}
    800063a0:	60e2                	ld	ra,24(sp)
    800063a2:	6442                	ld	s0,16(sp)
    800063a4:	64a2                	ld	s1,8(sp)
    800063a6:	6105                	addi	sp,sp,32
    800063a8:	8082                	ret
    panic("release");
    800063aa:	00002517          	auipc	a0,0x2
    800063ae:	35650513          	addi	a0,a0,854 # 80008700 <etext+0x700>
    800063b2:	00000097          	auipc	ra,0x0
    800063b6:	9ba080e7          	jalr	-1606(ra) # 80005d6c <panic>
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
