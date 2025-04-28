
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
    80000016:	089050ef          	jal	8000589e <start>

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
    8000004c:	17c080e7          	jalr	380(ra) # 800001c4 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	fe090913          	addi	s2,s2,-32 # 80009030 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	28c080e7          	jalr	652(ra) # 800062e6 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	32c080e7          	jalr	812(ra) # 8000639a <release>
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
    800000b8:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ba:	6985                	lui	s3,0x1
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
    800000fa:	160080e7          	jalr	352(ra) # 80006256 <initlock>
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
    80000132:	1b8080e7          	jalr	440(ra) # 800062e6 <acquire>
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
    8000014a:	254080e7          	jalr	596(ra) # 8000639a <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014e:	6605                	lui	a2,0x1
    80000150:	4595                	li	a1,5
    80000152:	8526                	mv	a0,s1
    80000154:	00000097          	auipc	ra,0x0
    80000158:	070080e7          	jalr	112(ra) # 800001c4 <memset>
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
    80000174:	22a080e7          	jalr	554(ra) # 8000639a <release>
  if(r)
    80000178:	b7d5                	j	8000015c <kalloc+0x42>

000000008000017a <freemem>:

int freemem(void)
{
    8000017a:	1101                	addi	sp,sp,-32
    8000017c:	ec06                	sd	ra,24(sp)
    8000017e:	e822                	sd	s0,16(sp)
    80000180:	e426                	sd	s1,8(sp)
    80000182:	1000                	addi	s0,sp,32
  struct run *r;
  int n = 0;

  acquire(&kmem.lock);
    80000184:	00009497          	auipc	s1,0x9
    80000188:	eac48493          	addi	s1,s1,-340 # 80009030 <kmem>
    8000018c:	8526                	mv	a0,s1
    8000018e:	00006097          	auipc	ra,0x6
    80000192:	158080e7          	jalr	344(ra) # 800062e6 <acquire>
  r = kmem.freelist;
    80000196:	6c9c                	ld	a5,24(s1)
  while (r)
    80000198:	c785                	beqz	a5,800001c0 <freemem+0x46>
  int n = 0;
    8000019a:	4481                	li	s1,0
  {
    n++;
    8000019c:	2485                	addiw	s1,s1,1
    r = r->next;
    8000019e:	639c                	ld	a5,0(a5)
  while (r)
    800001a0:	fff5                	bnez	a5,8000019c <freemem+0x22>
  }
  release(&kmem.lock);
    800001a2:	00009517          	auipc	a0,0x9
    800001a6:	e8e50513          	addi	a0,a0,-370 # 80009030 <kmem>
    800001aa:	00006097          	auipc	ra,0x6
    800001ae:	1f0080e7          	jalr	496(ra) # 8000639a <release>
  return n * PGSIZE;
}
    800001b2:	00c4951b          	slliw	a0,s1,0xc
    800001b6:	60e2                	ld	ra,24(sp)
    800001b8:	6442                	ld	s0,16(sp)
    800001ba:	64a2                	ld	s1,8(sp)
    800001bc:	6105                	addi	sp,sp,32
    800001be:	8082                	ret
  int n = 0;
    800001c0:	4481                	li	s1,0
    800001c2:	b7c5                	j	800001a2 <freemem+0x28>

00000000800001c4 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    800001c4:	1141                	addi	sp,sp,-16
    800001c6:	e422                	sd	s0,8(sp)
    800001c8:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    800001ca:	ca19                	beqz	a2,800001e0 <memset+0x1c>
    800001cc:	87aa                	mv	a5,a0
    800001ce:	1602                	slli	a2,a2,0x20
    800001d0:	9201                	srli	a2,a2,0x20
    800001d2:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    800001d6:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    800001da:	0785                	addi	a5,a5,1
    800001dc:	fee79de3          	bne	a5,a4,800001d6 <memset+0x12>
  }
  return dst;
}
    800001e0:	6422                	ld	s0,8(sp)
    800001e2:	0141                	addi	sp,sp,16
    800001e4:	8082                	ret

00000000800001e6 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    800001e6:	1141                	addi	sp,sp,-16
    800001e8:	e422                	sd	s0,8(sp)
    800001ea:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001ec:	ca05                	beqz	a2,8000021c <memcmp+0x36>
    800001ee:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    800001f2:	1682                	slli	a3,a3,0x20
    800001f4:	9281                	srli	a3,a3,0x20
    800001f6:	0685                	addi	a3,a3,1
    800001f8:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001fa:	00054783          	lbu	a5,0(a0)
    800001fe:	0005c703          	lbu	a4,0(a1)
    80000202:	00e79863          	bne	a5,a4,80000212 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000206:	0505                	addi	a0,a0,1
    80000208:	0585                	addi	a1,a1,1
  while(n-- > 0){
    8000020a:	fed518e3          	bne	a0,a3,800001fa <memcmp+0x14>
  }

  return 0;
    8000020e:	4501                	li	a0,0
    80000210:	a019                	j	80000216 <memcmp+0x30>
      return *s1 - *s2;
    80000212:	40e7853b          	subw	a0,a5,a4
}
    80000216:	6422                	ld	s0,8(sp)
    80000218:	0141                	addi	sp,sp,16
    8000021a:	8082                	ret
  return 0;
    8000021c:	4501                	li	a0,0
    8000021e:	bfe5                	j	80000216 <memcmp+0x30>

0000000080000220 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000220:	1141                	addi	sp,sp,-16
    80000222:	e422                	sd	s0,8(sp)
    80000224:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000226:	c205                	beqz	a2,80000246 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000228:	02a5e263          	bltu	a1,a0,8000024c <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    8000022c:	1602                	slli	a2,a2,0x20
    8000022e:	9201                	srli	a2,a2,0x20
    80000230:	00c587b3          	add	a5,a1,a2
{
    80000234:	872a                	mv	a4,a0
      *d++ = *s++;
    80000236:	0585                	addi	a1,a1,1
    80000238:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffd8dc1>
    8000023a:	fff5c683          	lbu	a3,-1(a1)
    8000023e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000242:	feb79ae3          	bne	a5,a1,80000236 <memmove+0x16>

  return dst;
}
    80000246:	6422                	ld	s0,8(sp)
    80000248:	0141                	addi	sp,sp,16
    8000024a:	8082                	ret
  if(s < d && s + n > d){
    8000024c:	02061693          	slli	a3,a2,0x20
    80000250:	9281                	srli	a3,a3,0x20
    80000252:	00d58733          	add	a4,a1,a3
    80000256:	fce57be3          	bgeu	a0,a4,8000022c <memmove+0xc>
    d += n;
    8000025a:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    8000025c:	fff6079b          	addiw	a5,a2,-1
    80000260:	1782                	slli	a5,a5,0x20
    80000262:	9381                	srli	a5,a5,0x20
    80000264:	fff7c793          	not	a5,a5
    80000268:	97ba                	add	a5,a5,a4
      *--d = *--s;
    8000026a:	177d                	addi	a4,a4,-1
    8000026c:	16fd                	addi	a3,a3,-1
    8000026e:	00074603          	lbu	a2,0(a4)
    80000272:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000276:	fef71ae3          	bne	a4,a5,8000026a <memmove+0x4a>
    8000027a:	b7f1                	j	80000246 <memmove+0x26>

000000008000027c <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    8000027c:	1141                	addi	sp,sp,-16
    8000027e:	e406                	sd	ra,8(sp)
    80000280:	e022                	sd	s0,0(sp)
    80000282:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000284:	00000097          	auipc	ra,0x0
    80000288:	f9c080e7          	jalr	-100(ra) # 80000220 <memmove>
}
    8000028c:	60a2                	ld	ra,8(sp)
    8000028e:	6402                	ld	s0,0(sp)
    80000290:	0141                	addi	sp,sp,16
    80000292:	8082                	ret

0000000080000294 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000294:	1141                	addi	sp,sp,-16
    80000296:	e422                	sd	s0,8(sp)
    80000298:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    8000029a:	ce11                	beqz	a2,800002b6 <strncmp+0x22>
    8000029c:	00054783          	lbu	a5,0(a0)
    800002a0:	cf89                	beqz	a5,800002ba <strncmp+0x26>
    800002a2:	0005c703          	lbu	a4,0(a1)
    800002a6:	00f71a63          	bne	a4,a5,800002ba <strncmp+0x26>
    n--, p++, q++;
    800002aa:	367d                	addiw	a2,a2,-1
    800002ac:	0505                	addi	a0,a0,1
    800002ae:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    800002b0:	f675                	bnez	a2,8000029c <strncmp+0x8>
  if(n == 0)
    return 0;
    800002b2:	4501                	li	a0,0
    800002b4:	a801                	j	800002c4 <strncmp+0x30>
    800002b6:	4501                	li	a0,0
    800002b8:	a031                	j	800002c4 <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
    800002ba:	00054503          	lbu	a0,0(a0)
    800002be:	0005c783          	lbu	a5,0(a1)
    800002c2:	9d1d                	subw	a0,a0,a5
}
    800002c4:	6422                	ld	s0,8(sp)
    800002c6:	0141                	addi	sp,sp,16
    800002c8:	8082                	ret

00000000800002ca <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    800002ca:	1141                	addi	sp,sp,-16
    800002cc:	e422                	sd	s0,8(sp)
    800002ce:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    800002d0:	87aa                	mv	a5,a0
    800002d2:	86b2                	mv	a3,a2
    800002d4:	367d                	addiw	a2,a2,-1
    800002d6:	02d05563          	blez	a3,80000300 <strncpy+0x36>
    800002da:	0785                	addi	a5,a5,1
    800002dc:	0005c703          	lbu	a4,0(a1)
    800002e0:	fee78fa3          	sb	a4,-1(a5)
    800002e4:	0585                	addi	a1,a1,1
    800002e6:	f775                	bnez	a4,800002d2 <strncpy+0x8>
    ;
  while(n-- > 0)
    800002e8:	873e                	mv	a4,a5
    800002ea:	9fb5                	addw	a5,a5,a3
    800002ec:	37fd                	addiw	a5,a5,-1
    800002ee:	00c05963          	blez	a2,80000300 <strncpy+0x36>
    *s++ = 0;
    800002f2:	0705                	addi	a4,a4,1
    800002f4:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    800002f8:	40e786bb          	subw	a3,a5,a4
    800002fc:	fed04be3          	bgtz	a3,800002f2 <strncpy+0x28>
  return os;
}
    80000300:	6422                	ld	s0,8(sp)
    80000302:	0141                	addi	sp,sp,16
    80000304:	8082                	ret

0000000080000306 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000306:	1141                	addi	sp,sp,-16
    80000308:	e422                	sd	s0,8(sp)
    8000030a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    8000030c:	02c05363          	blez	a2,80000332 <safestrcpy+0x2c>
    80000310:	fff6069b          	addiw	a3,a2,-1
    80000314:	1682                	slli	a3,a3,0x20
    80000316:	9281                	srli	a3,a3,0x20
    80000318:	96ae                	add	a3,a3,a1
    8000031a:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    8000031c:	00d58963          	beq	a1,a3,8000032e <safestrcpy+0x28>
    80000320:	0585                	addi	a1,a1,1
    80000322:	0785                	addi	a5,a5,1
    80000324:	fff5c703          	lbu	a4,-1(a1)
    80000328:	fee78fa3          	sb	a4,-1(a5)
    8000032c:	fb65                	bnez	a4,8000031c <safestrcpy+0x16>
    ;
  *s = 0;
    8000032e:	00078023          	sb	zero,0(a5)
  return os;
}
    80000332:	6422                	ld	s0,8(sp)
    80000334:	0141                	addi	sp,sp,16
    80000336:	8082                	ret

0000000080000338 <strlen>:

int
strlen(const char *s)
{
    80000338:	1141                	addi	sp,sp,-16
    8000033a:	e422                	sd	s0,8(sp)
    8000033c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    8000033e:	00054783          	lbu	a5,0(a0)
    80000342:	cf91                	beqz	a5,8000035e <strlen+0x26>
    80000344:	0505                	addi	a0,a0,1
    80000346:	87aa                	mv	a5,a0
    80000348:	86be                	mv	a3,a5
    8000034a:	0785                	addi	a5,a5,1
    8000034c:	fff7c703          	lbu	a4,-1(a5)
    80000350:	ff65                	bnez	a4,80000348 <strlen+0x10>
    80000352:	40a6853b          	subw	a0,a3,a0
    80000356:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    80000358:	6422                	ld	s0,8(sp)
    8000035a:	0141                	addi	sp,sp,16
    8000035c:	8082                	ret
  for(n = 0; s[n]; n++)
    8000035e:	4501                	li	a0,0
    80000360:	bfe5                	j	80000358 <strlen+0x20>

0000000080000362 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000362:	1141                	addi	sp,sp,-16
    80000364:	e406                	sd	ra,8(sp)
    80000366:	e022                	sd	s0,0(sp)
    80000368:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    8000036a:	00001097          	auipc	ra,0x1
    8000036e:	b30080e7          	jalr	-1232(ra) # 80000e9a <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000372:	00009717          	auipc	a4,0x9
    80000376:	c8e70713          	addi	a4,a4,-882 # 80009000 <started>
  if(cpuid() == 0){
    8000037a:	c139                	beqz	a0,800003c0 <main+0x5e>
    while(started == 0)
    8000037c:	431c                	lw	a5,0(a4)
    8000037e:	2781                	sext.w	a5,a5
    80000380:	dff5                	beqz	a5,8000037c <main+0x1a>
      ;
    __sync_synchronize();
    80000382:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000386:	00001097          	auipc	ra,0x1
    8000038a:	b14080e7          	jalr	-1260(ra) # 80000e9a <cpuid>
    8000038e:	85aa                	mv	a1,a0
    80000390:	00008517          	auipc	a0,0x8
    80000394:	ca850513          	addi	a0,a0,-856 # 80008038 <etext+0x38>
    80000398:	00006097          	auipc	ra,0x6
    8000039c:	a1e080e7          	jalr	-1506(ra) # 80005db6 <printf>
    kvminithart();    // turn on paging
    800003a0:	00000097          	auipc	ra,0x0
    800003a4:	0d8080e7          	jalr	216(ra) # 80000478 <kvminithart>
    trapinithart();   // install kernel trap vector
    800003a8:	00001097          	auipc	ra,0x1
    800003ac:	7ae080e7          	jalr	1966(ra) # 80001b56 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    800003b0:	00005097          	auipc	ra,0x5
    800003b4:	ea4080e7          	jalr	-348(ra) # 80005254 <plicinithart>
  }

  scheduler();        
    800003b8:	00001097          	auipc	ra,0x1
    800003bc:	02a080e7          	jalr	42(ra) # 800013e2 <scheduler>
    consoleinit();
    800003c0:	00006097          	auipc	ra,0x6
    800003c4:	8bc080e7          	jalr	-1860(ra) # 80005c7c <consoleinit>
    printfinit();
    800003c8:	00006097          	auipc	ra,0x6
    800003cc:	bf6080e7          	jalr	-1034(ra) # 80005fbe <printfinit>
    printf("\n");
    800003d0:	00008517          	auipc	a0,0x8
    800003d4:	c4850513          	addi	a0,a0,-952 # 80008018 <etext+0x18>
    800003d8:	00006097          	auipc	ra,0x6
    800003dc:	9de080e7          	jalr	-1570(ra) # 80005db6 <printf>
    printf("xv6 kernel is booting\n");
    800003e0:	00008517          	auipc	a0,0x8
    800003e4:	c4050513          	addi	a0,a0,-960 # 80008020 <etext+0x20>
    800003e8:	00006097          	auipc	ra,0x6
    800003ec:	9ce080e7          	jalr	-1586(ra) # 80005db6 <printf>
    printf("\n");
    800003f0:	00008517          	auipc	a0,0x8
    800003f4:	c2850513          	addi	a0,a0,-984 # 80008018 <etext+0x18>
    800003f8:	00006097          	auipc	ra,0x6
    800003fc:	9be080e7          	jalr	-1602(ra) # 80005db6 <printf>
    kinit();         // physical page allocator
    80000400:	00000097          	auipc	ra,0x0
    80000404:	cde080e7          	jalr	-802(ra) # 800000de <kinit>
    kvminit();       // create kernel page table
    80000408:	00000097          	auipc	ra,0x0
    8000040c:	322080e7          	jalr	802(ra) # 8000072a <kvminit>
    kvminithart();   // turn on paging
    80000410:	00000097          	auipc	ra,0x0
    80000414:	068080e7          	jalr	104(ra) # 80000478 <kvminithart>
    procinit();      // process table
    80000418:	00001097          	auipc	ra,0x1
    8000041c:	9c4080e7          	jalr	-1596(ra) # 80000ddc <procinit>
    trapinit();      // trap vectors
    80000420:	00001097          	auipc	ra,0x1
    80000424:	70e080e7          	jalr	1806(ra) # 80001b2e <trapinit>
    trapinithart();  // install kernel trap vector
    80000428:	00001097          	auipc	ra,0x1
    8000042c:	72e080e7          	jalr	1838(ra) # 80001b56 <trapinithart>
    plicinit();      // set up interrupt controller
    80000430:	00005097          	auipc	ra,0x5
    80000434:	e0a080e7          	jalr	-502(ra) # 8000523a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000438:	00005097          	auipc	ra,0x5
    8000043c:	e1c080e7          	jalr	-484(ra) # 80005254 <plicinithart>
    binit();         // buffer cache
    80000440:	00002097          	auipc	ra,0x2
    80000444:	f36080e7          	jalr	-202(ra) # 80002376 <binit>
    iinit();         // inode table
    80000448:	00002097          	auipc	ra,0x2
    8000044c:	5c2080e7          	jalr	1474(ra) # 80002a0a <iinit>
    fileinit();      // file table
    80000450:	00003097          	auipc	ra,0x3
    80000454:	566080e7          	jalr	1382(ra) # 800039b6 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000458:	00005097          	auipc	ra,0x5
    8000045c:	f1c080e7          	jalr	-228(ra) # 80005374 <virtio_disk_init>
    userinit();      // first user process
    80000460:	00001097          	auipc	ra,0x1
    80000464:	d3e080e7          	jalr	-706(ra) # 8000119e <userinit>
    __sync_synchronize();
    80000468:	0ff0000f          	fence
    started = 1;
    8000046c:	4785                	li	a5,1
    8000046e:	00009717          	auipc	a4,0x9
    80000472:	b8f72923          	sw	a5,-1134(a4) # 80009000 <started>
    80000476:	b789                	j	800003b8 <main+0x56>

0000000080000478 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000478:	1141                	addi	sp,sp,-16
    8000047a:	e422                	sd	s0,8(sp)
    8000047c:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    8000047e:	00009797          	auipc	a5,0x9
    80000482:	b8a7b783          	ld	a5,-1142(a5) # 80009008 <kernel_pagetable>
    80000486:	83b1                	srli	a5,a5,0xc
    80000488:	577d                	li	a4,-1
    8000048a:	177e                	slli	a4,a4,0x3f
    8000048c:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    8000048e:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000492:	12000073          	sfence.vma
  sfence_vma();
}
    80000496:	6422                	ld	s0,8(sp)
    80000498:	0141                	addi	sp,sp,16
    8000049a:	8082                	ret

000000008000049c <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    8000049c:	7139                	addi	sp,sp,-64
    8000049e:	fc06                	sd	ra,56(sp)
    800004a0:	f822                	sd	s0,48(sp)
    800004a2:	f426                	sd	s1,40(sp)
    800004a4:	f04a                	sd	s2,32(sp)
    800004a6:	ec4e                	sd	s3,24(sp)
    800004a8:	e852                	sd	s4,16(sp)
    800004aa:	e456                	sd	s5,8(sp)
    800004ac:	e05a                	sd	s6,0(sp)
    800004ae:	0080                	addi	s0,sp,64
    800004b0:	84aa                	mv	s1,a0
    800004b2:	89ae                	mv	s3,a1
    800004b4:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    800004b6:	57fd                	li	a5,-1
    800004b8:	83e9                	srli	a5,a5,0x1a
    800004ba:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    800004bc:	4b31                	li	s6,12
  if(va >= MAXVA)
    800004be:	04b7f263          	bgeu	a5,a1,80000502 <walk+0x66>
    panic("walk");
    800004c2:	00008517          	auipc	a0,0x8
    800004c6:	b8e50513          	addi	a0,a0,-1138 # 80008050 <etext+0x50>
    800004ca:	00006097          	auipc	ra,0x6
    800004ce:	8a2080e7          	jalr	-1886(ra) # 80005d6c <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800004d2:	060a8663          	beqz	s5,8000053e <walk+0xa2>
    800004d6:	00000097          	auipc	ra,0x0
    800004da:	c44080e7          	jalr	-956(ra) # 8000011a <kalloc>
    800004de:	84aa                	mv	s1,a0
    800004e0:	c529                	beqz	a0,8000052a <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004e2:	6605                	lui	a2,0x1
    800004e4:	4581                	li	a1,0
    800004e6:	00000097          	auipc	ra,0x0
    800004ea:	cde080e7          	jalr	-802(ra) # 800001c4 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004ee:	00c4d793          	srli	a5,s1,0xc
    800004f2:	07aa                	slli	a5,a5,0xa
    800004f4:	0017e793          	ori	a5,a5,1
    800004f8:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004fc:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffd8db7>
    800004fe:	036a0063          	beq	s4,s6,8000051e <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    80000502:	0149d933          	srl	s2,s3,s4
    80000506:	1ff97913          	andi	s2,s2,511
    8000050a:	090e                	slli	s2,s2,0x3
    8000050c:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    8000050e:	00093483          	ld	s1,0(s2)
    80000512:	0014f793          	andi	a5,s1,1
    80000516:	dfd5                	beqz	a5,800004d2 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000518:	80a9                	srli	s1,s1,0xa
    8000051a:	04b2                	slli	s1,s1,0xc
    8000051c:	b7c5                	j	800004fc <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    8000051e:	00c9d513          	srli	a0,s3,0xc
    80000522:	1ff57513          	andi	a0,a0,511
    80000526:	050e                	slli	a0,a0,0x3
    80000528:	9526                	add	a0,a0,s1
}
    8000052a:	70e2                	ld	ra,56(sp)
    8000052c:	7442                	ld	s0,48(sp)
    8000052e:	74a2                	ld	s1,40(sp)
    80000530:	7902                	ld	s2,32(sp)
    80000532:	69e2                	ld	s3,24(sp)
    80000534:	6a42                	ld	s4,16(sp)
    80000536:	6aa2                	ld	s5,8(sp)
    80000538:	6b02                	ld	s6,0(sp)
    8000053a:	6121                	addi	sp,sp,64
    8000053c:	8082                	ret
        return 0;
    8000053e:	4501                	li	a0,0
    80000540:	b7ed                	j	8000052a <walk+0x8e>

0000000080000542 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000542:	57fd                	li	a5,-1
    80000544:	83e9                	srli	a5,a5,0x1a
    80000546:	00b7f463          	bgeu	a5,a1,8000054e <walkaddr+0xc>
    return 0;
    8000054a:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000054c:	8082                	ret
{
    8000054e:	1141                	addi	sp,sp,-16
    80000550:	e406                	sd	ra,8(sp)
    80000552:	e022                	sd	s0,0(sp)
    80000554:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000556:	4601                	li	a2,0
    80000558:	00000097          	auipc	ra,0x0
    8000055c:	f44080e7          	jalr	-188(ra) # 8000049c <walk>
  if(pte == 0)
    80000560:	c105                	beqz	a0,80000580 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000562:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000564:	0117f693          	andi	a3,a5,17
    80000568:	4745                	li	a4,17
    return 0;
    8000056a:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    8000056c:	00e68663          	beq	a3,a4,80000578 <walkaddr+0x36>
}
    80000570:	60a2                	ld	ra,8(sp)
    80000572:	6402                	ld	s0,0(sp)
    80000574:	0141                	addi	sp,sp,16
    80000576:	8082                	ret
  pa = PTE2PA(*pte);
    80000578:	83a9                	srli	a5,a5,0xa
    8000057a:	00c79513          	slli	a0,a5,0xc
  return pa;
    8000057e:	bfcd                	j	80000570 <walkaddr+0x2e>
    return 0;
    80000580:	4501                	li	a0,0
    80000582:	b7fd                	j	80000570 <walkaddr+0x2e>

0000000080000584 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000584:	715d                	addi	sp,sp,-80
    80000586:	e486                	sd	ra,72(sp)
    80000588:	e0a2                	sd	s0,64(sp)
    8000058a:	fc26                	sd	s1,56(sp)
    8000058c:	f84a                	sd	s2,48(sp)
    8000058e:	f44e                	sd	s3,40(sp)
    80000590:	f052                	sd	s4,32(sp)
    80000592:	ec56                	sd	s5,24(sp)
    80000594:	e85a                	sd	s6,16(sp)
    80000596:	e45e                	sd	s7,8(sp)
    80000598:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    8000059a:	c639                	beqz	a2,800005e8 <mappages+0x64>
    8000059c:	8aaa                	mv	s5,a0
    8000059e:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    800005a0:	777d                	lui	a4,0xfffff
    800005a2:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    800005a6:	fff58993          	addi	s3,a1,-1
    800005aa:	99b2                	add	s3,s3,a2
    800005ac:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    800005b0:	893e                	mv	s2,a5
    800005b2:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800005b6:	6b85                	lui	s7,0x1
    800005b8:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    800005bc:	4605                	li	a2,1
    800005be:	85ca                	mv	a1,s2
    800005c0:	8556                	mv	a0,s5
    800005c2:	00000097          	auipc	ra,0x0
    800005c6:	eda080e7          	jalr	-294(ra) # 8000049c <walk>
    800005ca:	cd1d                	beqz	a0,80000608 <mappages+0x84>
    if(*pte & PTE_V)
    800005cc:	611c                	ld	a5,0(a0)
    800005ce:	8b85                	andi	a5,a5,1
    800005d0:	e785                	bnez	a5,800005f8 <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800005d2:	80b1                	srli	s1,s1,0xc
    800005d4:	04aa                	slli	s1,s1,0xa
    800005d6:	0164e4b3          	or	s1,s1,s6
    800005da:	0014e493          	ori	s1,s1,1
    800005de:	e104                	sd	s1,0(a0)
    if(a == last)
    800005e0:	05390063          	beq	s2,s3,80000620 <mappages+0x9c>
    a += PGSIZE;
    800005e4:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800005e6:	bfc9                	j	800005b8 <mappages+0x34>
    panic("mappages: size");
    800005e8:	00008517          	auipc	a0,0x8
    800005ec:	a7050513          	addi	a0,a0,-1424 # 80008058 <etext+0x58>
    800005f0:	00005097          	auipc	ra,0x5
    800005f4:	77c080e7          	jalr	1916(ra) # 80005d6c <panic>
      panic("mappages: remap");
    800005f8:	00008517          	auipc	a0,0x8
    800005fc:	a7050513          	addi	a0,a0,-1424 # 80008068 <etext+0x68>
    80000600:	00005097          	auipc	ra,0x5
    80000604:	76c080e7          	jalr	1900(ra) # 80005d6c <panic>
      return -1;
    80000608:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    8000060a:	60a6                	ld	ra,72(sp)
    8000060c:	6406                	ld	s0,64(sp)
    8000060e:	74e2                	ld	s1,56(sp)
    80000610:	7942                	ld	s2,48(sp)
    80000612:	79a2                	ld	s3,40(sp)
    80000614:	7a02                	ld	s4,32(sp)
    80000616:	6ae2                	ld	s5,24(sp)
    80000618:	6b42                	ld	s6,16(sp)
    8000061a:	6ba2                	ld	s7,8(sp)
    8000061c:	6161                	addi	sp,sp,80
    8000061e:	8082                	ret
  return 0;
    80000620:	4501                	li	a0,0
    80000622:	b7e5                	j	8000060a <mappages+0x86>

0000000080000624 <kvmmap>:
{
    80000624:	1141                	addi	sp,sp,-16
    80000626:	e406                	sd	ra,8(sp)
    80000628:	e022                	sd	s0,0(sp)
    8000062a:	0800                	addi	s0,sp,16
    8000062c:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    8000062e:	86b2                	mv	a3,a2
    80000630:	863e                	mv	a2,a5
    80000632:	00000097          	auipc	ra,0x0
    80000636:	f52080e7          	jalr	-174(ra) # 80000584 <mappages>
    8000063a:	e509                	bnez	a0,80000644 <kvmmap+0x20>
}
    8000063c:	60a2                	ld	ra,8(sp)
    8000063e:	6402                	ld	s0,0(sp)
    80000640:	0141                	addi	sp,sp,16
    80000642:	8082                	ret
    panic("kvmmap");
    80000644:	00008517          	auipc	a0,0x8
    80000648:	a3450513          	addi	a0,a0,-1484 # 80008078 <etext+0x78>
    8000064c:	00005097          	auipc	ra,0x5
    80000650:	720080e7          	jalr	1824(ra) # 80005d6c <panic>

0000000080000654 <kvmmake>:
{
    80000654:	1101                	addi	sp,sp,-32
    80000656:	ec06                	sd	ra,24(sp)
    80000658:	e822                	sd	s0,16(sp)
    8000065a:	e426                	sd	s1,8(sp)
    8000065c:	e04a                	sd	s2,0(sp)
    8000065e:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000660:	00000097          	auipc	ra,0x0
    80000664:	aba080e7          	jalr	-1350(ra) # 8000011a <kalloc>
    80000668:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000066a:	6605                	lui	a2,0x1
    8000066c:	4581                	li	a1,0
    8000066e:	00000097          	auipc	ra,0x0
    80000672:	b56080e7          	jalr	-1194(ra) # 800001c4 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000676:	4719                	li	a4,6
    80000678:	6685                	lui	a3,0x1
    8000067a:	10000637          	lui	a2,0x10000
    8000067e:	100005b7          	lui	a1,0x10000
    80000682:	8526                	mv	a0,s1
    80000684:	00000097          	auipc	ra,0x0
    80000688:	fa0080e7          	jalr	-96(ra) # 80000624 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000068c:	4719                	li	a4,6
    8000068e:	6685                	lui	a3,0x1
    80000690:	10001637          	lui	a2,0x10001
    80000694:	100015b7          	lui	a1,0x10001
    80000698:	8526                	mv	a0,s1
    8000069a:	00000097          	auipc	ra,0x0
    8000069e:	f8a080e7          	jalr	-118(ra) # 80000624 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800006a2:	4719                	li	a4,6
    800006a4:	004006b7          	lui	a3,0x400
    800006a8:	0c000637          	lui	a2,0xc000
    800006ac:	0c0005b7          	lui	a1,0xc000
    800006b0:	8526                	mv	a0,s1
    800006b2:	00000097          	auipc	ra,0x0
    800006b6:	f72080e7          	jalr	-142(ra) # 80000624 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800006ba:	00008917          	auipc	s2,0x8
    800006be:	94690913          	addi	s2,s2,-1722 # 80008000 <etext>
    800006c2:	4729                	li	a4,10
    800006c4:	80008697          	auipc	a3,0x80008
    800006c8:	93c68693          	addi	a3,a3,-1732 # 8000 <_entry-0x7fff8000>
    800006cc:	4605                	li	a2,1
    800006ce:	067e                	slli	a2,a2,0x1f
    800006d0:	85b2                	mv	a1,a2
    800006d2:	8526                	mv	a0,s1
    800006d4:	00000097          	auipc	ra,0x0
    800006d8:	f50080e7          	jalr	-176(ra) # 80000624 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800006dc:	46c5                	li	a3,17
    800006de:	06ee                	slli	a3,a3,0x1b
    800006e0:	4719                	li	a4,6
    800006e2:	412686b3          	sub	a3,a3,s2
    800006e6:	864a                	mv	a2,s2
    800006e8:	85ca                	mv	a1,s2
    800006ea:	8526                	mv	a0,s1
    800006ec:	00000097          	auipc	ra,0x0
    800006f0:	f38080e7          	jalr	-200(ra) # 80000624 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006f4:	4729                	li	a4,10
    800006f6:	6685                	lui	a3,0x1
    800006f8:	00007617          	auipc	a2,0x7
    800006fc:	90860613          	addi	a2,a2,-1784 # 80007000 <_trampoline>
    80000700:	040005b7          	lui	a1,0x4000
    80000704:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000706:	05b2                	slli	a1,a1,0xc
    80000708:	8526                	mv	a0,s1
    8000070a:	00000097          	auipc	ra,0x0
    8000070e:	f1a080e7          	jalr	-230(ra) # 80000624 <kvmmap>
  proc_mapstacks(kpgtbl);
    80000712:	8526                	mv	a0,s1
    80000714:	00000097          	auipc	ra,0x0
    80000718:	624080e7          	jalr	1572(ra) # 80000d38 <proc_mapstacks>
}
    8000071c:	8526                	mv	a0,s1
    8000071e:	60e2                	ld	ra,24(sp)
    80000720:	6442                	ld	s0,16(sp)
    80000722:	64a2                	ld	s1,8(sp)
    80000724:	6902                	ld	s2,0(sp)
    80000726:	6105                	addi	sp,sp,32
    80000728:	8082                	ret

000000008000072a <kvminit>:
{
    8000072a:	1141                	addi	sp,sp,-16
    8000072c:	e406                	sd	ra,8(sp)
    8000072e:	e022                	sd	s0,0(sp)
    80000730:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80000732:	00000097          	auipc	ra,0x0
    80000736:	f22080e7          	jalr	-222(ra) # 80000654 <kvmmake>
    8000073a:	00009797          	auipc	a5,0x9
    8000073e:	8ca7b723          	sd	a0,-1842(a5) # 80009008 <kernel_pagetable>
}
    80000742:	60a2                	ld	ra,8(sp)
    80000744:	6402                	ld	s0,0(sp)
    80000746:	0141                	addi	sp,sp,16
    80000748:	8082                	ret

000000008000074a <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000074a:	715d                	addi	sp,sp,-80
    8000074c:	e486                	sd	ra,72(sp)
    8000074e:	e0a2                	sd	s0,64(sp)
    80000750:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000752:	03459793          	slli	a5,a1,0x34
    80000756:	e39d                	bnez	a5,8000077c <uvmunmap+0x32>
    80000758:	f84a                	sd	s2,48(sp)
    8000075a:	f44e                	sd	s3,40(sp)
    8000075c:	f052                	sd	s4,32(sp)
    8000075e:	ec56                	sd	s5,24(sp)
    80000760:	e85a                	sd	s6,16(sp)
    80000762:	e45e                	sd	s7,8(sp)
    80000764:	8a2a                	mv	s4,a0
    80000766:	892e                	mv	s2,a1
    80000768:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000076a:	0632                	slli	a2,a2,0xc
    8000076c:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000770:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000772:	6b05                	lui	s6,0x1
    80000774:	0935fb63          	bgeu	a1,s3,8000080a <uvmunmap+0xc0>
    80000778:	fc26                	sd	s1,56(sp)
    8000077a:	a8a9                	j	800007d4 <uvmunmap+0x8a>
    8000077c:	fc26                	sd	s1,56(sp)
    8000077e:	f84a                	sd	s2,48(sp)
    80000780:	f44e                	sd	s3,40(sp)
    80000782:	f052                	sd	s4,32(sp)
    80000784:	ec56                	sd	s5,24(sp)
    80000786:	e85a                	sd	s6,16(sp)
    80000788:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    8000078a:	00008517          	auipc	a0,0x8
    8000078e:	8f650513          	addi	a0,a0,-1802 # 80008080 <etext+0x80>
    80000792:	00005097          	auipc	ra,0x5
    80000796:	5da080e7          	jalr	1498(ra) # 80005d6c <panic>
      panic("uvmunmap: walk");
    8000079a:	00008517          	auipc	a0,0x8
    8000079e:	8fe50513          	addi	a0,a0,-1794 # 80008098 <etext+0x98>
    800007a2:	00005097          	auipc	ra,0x5
    800007a6:	5ca080e7          	jalr	1482(ra) # 80005d6c <panic>
      panic("uvmunmap: not mapped");
    800007aa:	00008517          	auipc	a0,0x8
    800007ae:	8fe50513          	addi	a0,a0,-1794 # 800080a8 <etext+0xa8>
    800007b2:	00005097          	auipc	ra,0x5
    800007b6:	5ba080e7          	jalr	1466(ra) # 80005d6c <panic>
      panic("uvmunmap: not a leaf");
    800007ba:	00008517          	auipc	a0,0x8
    800007be:	90650513          	addi	a0,a0,-1786 # 800080c0 <etext+0xc0>
    800007c2:	00005097          	auipc	ra,0x5
    800007c6:	5aa080e7          	jalr	1450(ra) # 80005d6c <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    800007ca:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800007ce:	995a                	add	s2,s2,s6
    800007d0:	03397c63          	bgeu	s2,s3,80000808 <uvmunmap+0xbe>
    if((pte = walk(pagetable, a, 0)) == 0)
    800007d4:	4601                	li	a2,0
    800007d6:	85ca                	mv	a1,s2
    800007d8:	8552                	mv	a0,s4
    800007da:	00000097          	auipc	ra,0x0
    800007de:	cc2080e7          	jalr	-830(ra) # 8000049c <walk>
    800007e2:	84aa                	mv	s1,a0
    800007e4:	d95d                	beqz	a0,8000079a <uvmunmap+0x50>
    if((*pte & PTE_V) == 0)
    800007e6:	6108                	ld	a0,0(a0)
    800007e8:	00157793          	andi	a5,a0,1
    800007ec:	dfdd                	beqz	a5,800007aa <uvmunmap+0x60>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007ee:	3ff57793          	andi	a5,a0,1023
    800007f2:	fd7784e3          	beq	a5,s7,800007ba <uvmunmap+0x70>
    if(do_free){
    800007f6:	fc0a8ae3          	beqz	s5,800007ca <uvmunmap+0x80>
      uint64 pa = PTE2PA(*pte);
    800007fa:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800007fc:	0532                	slli	a0,a0,0xc
    800007fe:	00000097          	auipc	ra,0x0
    80000802:	81e080e7          	jalr	-2018(ra) # 8000001c <kfree>
    80000806:	b7d1                	j	800007ca <uvmunmap+0x80>
    80000808:	74e2                	ld	s1,56(sp)
    8000080a:	7942                	ld	s2,48(sp)
    8000080c:	79a2                	ld	s3,40(sp)
    8000080e:	7a02                	ld	s4,32(sp)
    80000810:	6ae2                	ld	s5,24(sp)
    80000812:	6b42                	ld	s6,16(sp)
    80000814:	6ba2                	ld	s7,8(sp)
  }
}
    80000816:	60a6                	ld	ra,72(sp)
    80000818:	6406                	ld	s0,64(sp)
    8000081a:	6161                	addi	sp,sp,80
    8000081c:	8082                	ret

000000008000081e <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    8000081e:	1101                	addi	sp,sp,-32
    80000820:	ec06                	sd	ra,24(sp)
    80000822:	e822                	sd	s0,16(sp)
    80000824:	e426                	sd	s1,8(sp)
    80000826:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80000828:	00000097          	auipc	ra,0x0
    8000082c:	8f2080e7          	jalr	-1806(ra) # 8000011a <kalloc>
    80000830:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000832:	c519                	beqz	a0,80000840 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000834:	6605                	lui	a2,0x1
    80000836:	4581                	li	a1,0
    80000838:	00000097          	auipc	ra,0x0
    8000083c:	98c080e7          	jalr	-1652(ra) # 800001c4 <memset>
  return pagetable;
}
    80000840:	8526                	mv	a0,s1
    80000842:	60e2                	ld	ra,24(sp)
    80000844:	6442                	ld	s0,16(sp)
    80000846:	64a2                	ld	s1,8(sp)
    80000848:	6105                	addi	sp,sp,32
    8000084a:	8082                	ret

000000008000084c <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    8000084c:	7179                	addi	sp,sp,-48
    8000084e:	f406                	sd	ra,40(sp)
    80000850:	f022                	sd	s0,32(sp)
    80000852:	ec26                	sd	s1,24(sp)
    80000854:	e84a                	sd	s2,16(sp)
    80000856:	e44e                	sd	s3,8(sp)
    80000858:	e052                	sd	s4,0(sp)
    8000085a:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8000085c:	6785                	lui	a5,0x1
    8000085e:	04f67863          	bgeu	a2,a5,800008ae <uvminit+0x62>
    80000862:	8a2a                	mv	s4,a0
    80000864:	89ae                	mv	s3,a1
    80000866:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    80000868:	00000097          	auipc	ra,0x0
    8000086c:	8b2080e7          	jalr	-1870(ra) # 8000011a <kalloc>
    80000870:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000872:	6605                	lui	a2,0x1
    80000874:	4581                	li	a1,0
    80000876:	00000097          	auipc	ra,0x0
    8000087a:	94e080e7          	jalr	-1714(ra) # 800001c4 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000087e:	4779                	li	a4,30
    80000880:	86ca                	mv	a3,s2
    80000882:	6605                	lui	a2,0x1
    80000884:	4581                	li	a1,0
    80000886:	8552                	mv	a0,s4
    80000888:	00000097          	auipc	ra,0x0
    8000088c:	cfc080e7          	jalr	-772(ra) # 80000584 <mappages>
  memmove(mem, src, sz);
    80000890:	8626                	mv	a2,s1
    80000892:	85ce                	mv	a1,s3
    80000894:	854a                	mv	a0,s2
    80000896:	00000097          	auipc	ra,0x0
    8000089a:	98a080e7          	jalr	-1654(ra) # 80000220 <memmove>
}
    8000089e:	70a2                	ld	ra,40(sp)
    800008a0:	7402                	ld	s0,32(sp)
    800008a2:	64e2                	ld	s1,24(sp)
    800008a4:	6942                	ld	s2,16(sp)
    800008a6:	69a2                	ld	s3,8(sp)
    800008a8:	6a02                	ld	s4,0(sp)
    800008aa:	6145                	addi	sp,sp,48
    800008ac:	8082                	ret
    panic("inituvm: more than a page");
    800008ae:	00008517          	auipc	a0,0x8
    800008b2:	82a50513          	addi	a0,a0,-2006 # 800080d8 <etext+0xd8>
    800008b6:	00005097          	auipc	ra,0x5
    800008ba:	4b6080e7          	jalr	1206(ra) # 80005d6c <panic>

00000000800008be <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800008be:	1101                	addi	sp,sp,-32
    800008c0:	ec06                	sd	ra,24(sp)
    800008c2:	e822                	sd	s0,16(sp)
    800008c4:	e426                	sd	s1,8(sp)
    800008c6:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800008c8:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800008ca:	00b67d63          	bgeu	a2,a1,800008e4 <uvmdealloc+0x26>
    800008ce:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800008d0:	6785                	lui	a5,0x1
    800008d2:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008d4:	00f60733          	add	a4,a2,a5
    800008d8:	76fd                	lui	a3,0xfffff
    800008da:	8f75                	and	a4,a4,a3
    800008dc:	97ae                	add	a5,a5,a1
    800008de:	8ff5                	and	a5,a5,a3
    800008e0:	00f76863          	bltu	a4,a5,800008f0 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800008e4:	8526                	mv	a0,s1
    800008e6:	60e2                	ld	ra,24(sp)
    800008e8:	6442                	ld	s0,16(sp)
    800008ea:	64a2                	ld	s1,8(sp)
    800008ec:	6105                	addi	sp,sp,32
    800008ee:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008f0:	8f99                	sub	a5,a5,a4
    800008f2:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008f4:	4685                	li	a3,1
    800008f6:	0007861b          	sext.w	a2,a5
    800008fa:	85ba                	mv	a1,a4
    800008fc:	00000097          	auipc	ra,0x0
    80000900:	e4e080e7          	jalr	-434(ra) # 8000074a <uvmunmap>
    80000904:	b7c5                	j	800008e4 <uvmdealloc+0x26>

0000000080000906 <uvmalloc>:
  if(newsz < oldsz)
    80000906:	0ab66563          	bltu	a2,a1,800009b0 <uvmalloc+0xaa>
{
    8000090a:	7139                	addi	sp,sp,-64
    8000090c:	fc06                	sd	ra,56(sp)
    8000090e:	f822                	sd	s0,48(sp)
    80000910:	ec4e                	sd	s3,24(sp)
    80000912:	e852                	sd	s4,16(sp)
    80000914:	e456                	sd	s5,8(sp)
    80000916:	0080                	addi	s0,sp,64
    80000918:	8aaa                	mv	s5,a0
    8000091a:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    8000091c:	6785                	lui	a5,0x1
    8000091e:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000920:	95be                	add	a1,a1,a5
    80000922:	77fd                	lui	a5,0xfffff
    80000924:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000928:	08c9f663          	bgeu	s3,a2,800009b4 <uvmalloc+0xae>
    8000092c:	f426                	sd	s1,40(sp)
    8000092e:	f04a                	sd	s2,32(sp)
    80000930:	894e                	mv	s2,s3
    mem = kalloc();
    80000932:	fffff097          	auipc	ra,0xfffff
    80000936:	7e8080e7          	jalr	2024(ra) # 8000011a <kalloc>
    8000093a:	84aa                	mv	s1,a0
    if(mem == 0){
    8000093c:	c90d                	beqz	a0,8000096e <uvmalloc+0x68>
    memset(mem, 0, PGSIZE);
    8000093e:	6605                	lui	a2,0x1
    80000940:	4581                	li	a1,0
    80000942:	00000097          	auipc	ra,0x0
    80000946:	882080e7          	jalr	-1918(ra) # 800001c4 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    8000094a:	4779                	li	a4,30
    8000094c:	86a6                	mv	a3,s1
    8000094e:	6605                	lui	a2,0x1
    80000950:	85ca                	mv	a1,s2
    80000952:	8556                	mv	a0,s5
    80000954:	00000097          	auipc	ra,0x0
    80000958:	c30080e7          	jalr	-976(ra) # 80000584 <mappages>
    8000095c:	e915                	bnez	a0,80000990 <uvmalloc+0x8a>
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000095e:	6785                	lui	a5,0x1
    80000960:	993e                	add	s2,s2,a5
    80000962:	fd4968e3          	bltu	s2,s4,80000932 <uvmalloc+0x2c>
  return newsz;
    80000966:	8552                	mv	a0,s4
    80000968:	74a2                	ld	s1,40(sp)
    8000096a:	7902                	ld	s2,32(sp)
    8000096c:	a819                	j	80000982 <uvmalloc+0x7c>
      uvmdealloc(pagetable, a, oldsz);
    8000096e:	864e                	mv	a2,s3
    80000970:	85ca                	mv	a1,s2
    80000972:	8556                	mv	a0,s5
    80000974:	00000097          	auipc	ra,0x0
    80000978:	f4a080e7          	jalr	-182(ra) # 800008be <uvmdealloc>
      return 0;
    8000097c:	4501                	li	a0,0
    8000097e:	74a2                	ld	s1,40(sp)
    80000980:	7902                	ld	s2,32(sp)
}
    80000982:	70e2                	ld	ra,56(sp)
    80000984:	7442                	ld	s0,48(sp)
    80000986:	69e2                	ld	s3,24(sp)
    80000988:	6a42                	ld	s4,16(sp)
    8000098a:	6aa2                	ld	s5,8(sp)
    8000098c:	6121                	addi	sp,sp,64
    8000098e:	8082                	ret
      kfree(mem);
    80000990:	8526                	mv	a0,s1
    80000992:	fffff097          	auipc	ra,0xfffff
    80000996:	68a080e7          	jalr	1674(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000099a:	864e                	mv	a2,s3
    8000099c:	85ca                	mv	a1,s2
    8000099e:	8556                	mv	a0,s5
    800009a0:	00000097          	auipc	ra,0x0
    800009a4:	f1e080e7          	jalr	-226(ra) # 800008be <uvmdealloc>
      return 0;
    800009a8:	4501                	li	a0,0
    800009aa:	74a2                	ld	s1,40(sp)
    800009ac:	7902                	ld	s2,32(sp)
    800009ae:	bfd1                	j	80000982 <uvmalloc+0x7c>
    return oldsz;
    800009b0:	852e                	mv	a0,a1
}
    800009b2:	8082                	ret
  return newsz;
    800009b4:	8532                	mv	a0,a2
    800009b6:	b7f1                	j	80000982 <uvmalloc+0x7c>

00000000800009b8 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800009b8:	7179                	addi	sp,sp,-48
    800009ba:	f406                	sd	ra,40(sp)
    800009bc:	f022                	sd	s0,32(sp)
    800009be:	ec26                	sd	s1,24(sp)
    800009c0:	e84a                	sd	s2,16(sp)
    800009c2:	e44e                	sd	s3,8(sp)
    800009c4:	e052                	sd	s4,0(sp)
    800009c6:	1800                	addi	s0,sp,48
    800009c8:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800009ca:	84aa                	mv	s1,a0
    800009cc:	6905                	lui	s2,0x1
    800009ce:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009d0:	4985                	li	s3,1
    800009d2:	a829                	j	800009ec <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800009d4:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    800009d6:	00c79513          	slli	a0,a5,0xc
    800009da:	00000097          	auipc	ra,0x0
    800009de:	fde080e7          	jalr	-34(ra) # 800009b8 <freewalk>
      pagetable[i] = 0;
    800009e2:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800009e6:	04a1                	addi	s1,s1,8
    800009e8:	03248163          	beq	s1,s2,80000a0a <freewalk+0x52>
    pte_t pte = pagetable[i];
    800009ec:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009ee:	00f7f713          	andi	a4,a5,15
    800009f2:	ff3701e3          	beq	a4,s3,800009d4 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009f6:	8b85                	andi	a5,a5,1
    800009f8:	d7fd                	beqz	a5,800009e6 <freewalk+0x2e>
      panic("freewalk: leaf");
    800009fa:	00007517          	auipc	a0,0x7
    800009fe:	6fe50513          	addi	a0,a0,1790 # 800080f8 <etext+0xf8>
    80000a02:	00005097          	auipc	ra,0x5
    80000a06:	36a080e7          	jalr	874(ra) # 80005d6c <panic>
    }
  }
  kfree((void*)pagetable);
    80000a0a:	8552                	mv	a0,s4
    80000a0c:	fffff097          	auipc	ra,0xfffff
    80000a10:	610080e7          	jalr	1552(ra) # 8000001c <kfree>
}
    80000a14:	70a2                	ld	ra,40(sp)
    80000a16:	7402                	ld	s0,32(sp)
    80000a18:	64e2                	ld	s1,24(sp)
    80000a1a:	6942                	ld	s2,16(sp)
    80000a1c:	69a2                	ld	s3,8(sp)
    80000a1e:	6a02                	ld	s4,0(sp)
    80000a20:	6145                	addi	sp,sp,48
    80000a22:	8082                	ret

0000000080000a24 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000a24:	1101                	addi	sp,sp,-32
    80000a26:	ec06                	sd	ra,24(sp)
    80000a28:	e822                	sd	s0,16(sp)
    80000a2a:	e426                	sd	s1,8(sp)
    80000a2c:	1000                	addi	s0,sp,32
    80000a2e:	84aa                	mv	s1,a0
  if(sz > 0)
    80000a30:	e999                	bnez	a1,80000a46 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000a32:	8526                	mv	a0,s1
    80000a34:	00000097          	auipc	ra,0x0
    80000a38:	f84080e7          	jalr	-124(ra) # 800009b8 <freewalk>
}
    80000a3c:	60e2                	ld	ra,24(sp)
    80000a3e:	6442                	ld	s0,16(sp)
    80000a40:	64a2                	ld	s1,8(sp)
    80000a42:	6105                	addi	sp,sp,32
    80000a44:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000a46:	6785                	lui	a5,0x1
    80000a48:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000a4a:	95be                	add	a1,a1,a5
    80000a4c:	4685                	li	a3,1
    80000a4e:	00c5d613          	srli	a2,a1,0xc
    80000a52:	4581                	li	a1,0
    80000a54:	00000097          	auipc	ra,0x0
    80000a58:	cf6080e7          	jalr	-778(ra) # 8000074a <uvmunmap>
    80000a5c:	bfd9                	j	80000a32 <uvmfree+0xe>

0000000080000a5e <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a5e:	c679                	beqz	a2,80000b2c <uvmcopy+0xce>
{
    80000a60:	715d                	addi	sp,sp,-80
    80000a62:	e486                	sd	ra,72(sp)
    80000a64:	e0a2                	sd	s0,64(sp)
    80000a66:	fc26                	sd	s1,56(sp)
    80000a68:	f84a                	sd	s2,48(sp)
    80000a6a:	f44e                	sd	s3,40(sp)
    80000a6c:	f052                	sd	s4,32(sp)
    80000a6e:	ec56                	sd	s5,24(sp)
    80000a70:	e85a                	sd	s6,16(sp)
    80000a72:	e45e                	sd	s7,8(sp)
    80000a74:	0880                	addi	s0,sp,80
    80000a76:	8b2a                	mv	s6,a0
    80000a78:	8aae                	mv	s5,a1
    80000a7a:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a7c:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a7e:	4601                	li	a2,0
    80000a80:	85ce                	mv	a1,s3
    80000a82:	855a                	mv	a0,s6
    80000a84:	00000097          	auipc	ra,0x0
    80000a88:	a18080e7          	jalr	-1512(ra) # 8000049c <walk>
    80000a8c:	c531                	beqz	a0,80000ad8 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a8e:	6118                	ld	a4,0(a0)
    80000a90:	00177793          	andi	a5,a4,1
    80000a94:	cbb1                	beqz	a5,80000ae8 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a96:	00a75593          	srli	a1,a4,0xa
    80000a9a:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a9e:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000aa2:	fffff097          	auipc	ra,0xfffff
    80000aa6:	678080e7          	jalr	1656(ra) # 8000011a <kalloc>
    80000aaa:	892a                	mv	s2,a0
    80000aac:	c939                	beqz	a0,80000b02 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000aae:	6605                	lui	a2,0x1
    80000ab0:	85de                	mv	a1,s7
    80000ab2:	fffff097          	auipc	ra,0xfffff
    80000ab6:	76e080e7          	jalr	1902(ra) # 80000220 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000aba:	8726                	mv	a4,s1
    80000abc:	86ca                	mv	a3,s2
    80000abe:	6605                	lui	a2,0x1
    80000ac0:	85ce                	mv	a1,s3
    80000ac2:	8556                	mv	a0,s5
    80000ac4:	00000097          	auipc	ra,0x0
    80000ac8:	ac0080e7          	jalr	-1344(ra) # 80000584 <mappages>
    80000acc:	e515                	bnez	a0,80000af8 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000ace:	6785                	lui	a5,0x1
    80000ad0:	99be                	add	s3,s3,a5
    80000ad2:	fb49e6e3          	bltu	s3,s4,80000a7e <uvmcopy+0x20>
    80000ad6:	a081                	j	80000b16 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000ad8:	00007517          	auipc	a0,0x7
    80000adc:	63050513          	addi	a0,a0,1584 # 80008108 <etext+0x108>
    80000ae0:	00005097          	auipc	ra,0x5
    80000ae4:	28c080e7          	jalr	652(ra) # 80005d6c <panic>
      panic("uvmcopy: page not present");
    80000ae8:	00007517          	auipc	a0,0x7
    80000aec:	64050513          	addi	a0,a0,1600 # 80008128 <etext+0x128>
    80000af0:	00005097          	auipc	ra,0x5
    80000af4:	27c080e7          	jalr	636(ra) # 80005d6c <panic>
      kfree(mem);
    80000af8:	854a                	mv	a0,s2
    80000afa:	fffff097          	auipc	ra,0xfffff
    80000afe:	522080e7          	jalr	1314(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000b02:	4685                	li	a3,1
    80000b04:	00c9d613          	srli	a2,s3,0xc
    80000b08:	4581                	li	a1,0
    80000b0a:	8556                	mv	a0,s5
    80000b0c:	00000097          	auipc	ra,0x0
    80000b10:	c3e080e7          	jalr	-962(ra) # 8000074a <uvmunmap>
  return -1;
    80000b14:	557d                	li	a0,-1
}
    80000b16:	60a6                	ld	ra,72(sp)
    80000b18:	6406                	ld	s0,64(sp)
    80000b1a:	74e2                	ld	s1,56(sp)
    80000b1c:	7942                	ld	s2,48(sp)
    80000b1e:	79a2                	ld	s3,40(sp)
    80000b20:	7a02                	ld	s4,32(sp)
    80000b22:	6ae2                	ld	s5,24(sp)
    80000b24:	6b42                	ld	s6,16(sp)
    80000b26:	6ba2                	ld	s7,8(sp)
    80000b28:	6161                	addi	sp,sp,80
    80000b2a:	8082                	ret
  return 0;
    80000b2c:	4501                	li	a0,0
}
    80000b2e:	8082                	ret

0000000080000b30 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000b30:	1141                	addi	sp,sp,-16
    80000b32:	e406                	sd	ra,8(sp)
    80000b34:	e022                	sd	s0,0(sp)
    80000b36:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000b38:	4601                	li	a2,0
    80000b3a:	00000097          	auipc	ra,0x0
    80000b3e:	962080e7          	jalr	-1694(ra) # 8000049c <walk>
  if(pte == 0)
    80000b42:	c901                	beqz	a0,80000b52 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000b44:	611c                	ld	a5,0(a0)
    80000b46:	9bbd                	andi	a5,a5,-17
    80000b48:	e11c                	sd	a5,0(a0)
}
    80000b4a:	60a2                	ld	ra,8(sp)
    80000b4c:	6402                	ld	s0,0(sp)
    80000b4e:	0141                	addi	sp,sp,16
    80000b50:	8082                	ret
    panic("uvmclear");
    80000b52:	00007517          	auipc	a0,0x7
    80000b56:	5f650513          	addi	a0,a0,1526 # 80008148 <etext+0x148>
    80000b5a:	00005097          	auipc	ra,0x5
    80000b5e:	212080e7          	jalr	530(ra) # 80005d6c <panic>

0000000080000b62 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b62:	c6bd                	beqz	a3,80000bd0 <copyout+0x6e>
{
    80000b64:	715d                	addi	sp,sp,-80
    80000b66:	e486                	sd	ra,72(sp)
    80000b68:	e0a2                	sd	s0,64(sp)
    80000b6a:	fc26                	sd	s1,56(sp)
    80000b6c:	f84a                	sd	s2,48(sp)
    80000b6e:	f44e                	sd	s3,40(sp)
    80000b70:	f052                	sd	s4,32(sp)
    80000b72:	ec56                	sd	s5,24(sp)
    80000b74:	e85a                	sd	s6,16(sp)
    80000b76:	e45e                	sd	s7,8(sp)
    80000b78:	e062                	sd	s8,0(sp)
    80000b7a:	0880                	addi	s0,sp,80
    80000b7c:	8b2a                	mv	s6,a0
    80000b7e:	8c2e                	mv	s8,a1
    80000b80:	8a32                	mv	s4,a2
    80000b82:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b84:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b86:	6a85                	lui	s5,0x1
    80000b88:	a015                	j	80000bac <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b8a:	9562                	add	a0,a0,s8
    80000b8c:	0004861b          	sext.w	a2,s1
    80000b90:	85d2                	mv	a1,s4
    80000b92:	41250533          	sub	a0,a0,s2
    80000b96:	fffff097          	auipc	ra,0xfffff
    80000b9a:	68a080e7          	jalr	1674(ra) # 80000220 <memmove>

    len -= n;
    80000b9e:	409989b3          	sub	s3,s3,s1
    src += n;
    80000ba2:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000ba4:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000ba8:	02098263          	beqz	s3,80000bcc <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000bac:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000bb0:	85ca                	mv	a1,s2
    80000bb2:	855a                	mv	a0,s6
    80000bb4:	00000097          	auipc	ra,0x0
    80000bb8:	98e080e7          	jalr	-1650(ra) # 80000542 <walkaddr>
    if(pa0 == 0)
    80000bbc:	cd01                	beqz	a0,80000bd4 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000bbe:	418904b3          	sub	s1,s2,s8
    80000bc2:	94d6                	add	s1,s1,s5
    if(n > len)
    80000bc4:	fc99f3e3          	bgeu	s3,s1,80000b8a <copyout+0x28>
    80000bc8:	84ce                	mv	s1,s3
    80000bca:	b7c1                	j	80000b8a <copyout+0x28>
  }
  return 0;
    80000bcc:	4501                	li	a0,0
    80000bce:	a021                	j	80000bd6 <copyout+0x74>
    80000bd0:	4501                	li	a0,0
}
    80000bd2:	8082                	ret
      return -1;
    80000bd4:	557d                	li	a0,-1
}
    80000bd6:	60a6                	ld	ra,72(sp)
    80000bd8:	6406                	ld	s0,64(sp)
    80000bda:	74e2                	ld	s1,56(sp)
    80000bdc:	7942                	ld	s2,48(sp)
    80000bde:	79a2                	ld	s3,40(sp)
    80000be0:	7a02                	ld	s4,32(sp)
    80000be2:	6ae2                	ld	s5,24(sp)
    80000be4:	6b42                	ld	s6,16(sp)
    80000be6:	6ba2                	ld	s7,8(sp)
    80000be8:	6c02                	ld	s8,0(sp)
    80000bea:	6161                	addi	sp,sp,80
    80000bec:	8082                	ret

0000000080000bee <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000bee:	caa5                	beqz	a3,80000c5e <copyin+0x70>
{
    80000bf0:	715d                	addi	sp,sp,-80
    80000bf2:	e486                	sd	ra,72(sp)
    80000bf4:	e0a2                	sd	s0,64(sp)
    80000bf6:	fc26                	sd	s1,56(sp)
    80000bf8:	f84a                	sd	s2,48(sp)
    80000bfa:	f44e                	sd	s3,40(sp)
    80000bfc:	f052                	sd	s4,32(sp)
    80000bfe:	ec56                	sd	s5,24(sp)
    80000c00:	e85a                	sd	s6,16(sp)
    80000c02:	e45e                	sd	s7,8(sp)
    80000c04:	e062                	sd	s8,0(sp)
    80000c06:	0880                	addi	s0,sp,80
    80000c08:	8b2a                	mv	s6,a0
    80000c0a:	8a2e                	mv	s4,a1
    80000c0c:	8c32                	mv	s8,a2
    80000c0e:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000c10:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c12:	6a85                	lui	s5,0x1
    80000c14:	a01d                	j	80000c3a <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000c16:	018505b3          	add	a1,a0,s8
    80000c1a:	0004861b          	sext.w	a2,s1
    80000c1e:	412585b3          	sub	a1,a1,s2
    80000c22:	8552                	mv	a0,s4
    80000c24:	fffff097          	auipc	ra,0xfffff
    80000c28:	5fc080e7          	jalr	1532(ra) # 80000220 <memmove>

    len -= n;
    80000c2c:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000c30:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000c32:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000c36:	02098263          	beqz	s3,80000c5a <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000c3a:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000c3e:	85ca                	mv	a1,s2
    80000c40:	855a                	mv	a0,s6
    80000c42:	00000097          	auipc	ra,0x0
    80000c46:	900080e7          	jalr	-1792(ra) # 80000542 <walkaddr>
    if(pa0 == 0)
    80000c4a:	cd01                	beqz	a0,80000c62 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000c4c:	418904b3          	sub	s1,s2,s8
    80000c50:	94d6                	add	s1,s1,s5
    if(n > len)
    80000c52:	fc99f2e3          	bgeu	s3,s1,80000c16 <copyin+0x28>
    80000c56:	84ce                	mv	s1,s3
    80000c58:	bf7d                	j	80000c16 <copyin+0x28>
  }
  return 0;
    80000c5a:	4501                	li	a0,0
    80000c5c:	a021                	j	80000c64 <copyin+0x76>
    80000c5e:	4501                	li	a0,0
}
    80000c60:	8082                	ret
      return -1;
    80000c62:	557d                	li	a0,-1
}
    80000c64:	60a6                	ld	ra,72(sp)
    80000c66:	6406                	ld	s0,64(sp)
    80000c68:	74e2                	ld	s1,56(sp)
    80000c6a:	7942                	ld	s2,48(sp)
    80000c6c:	79a2                	ld	s3,40(sp)
    80000c6e:	7a02                	ld	s4,32(sp)
    80000c70:	6ae2                	ld	s5,24(sp)
    80000c72:	6b42                	ld	s6,16(sp)
    80000c74:	6ba2                	ld	s7,8(sp)
    80000c76:	6c02                	ld	s8,0(sp)
    80000c78:	6161                	addi	sp,sp,80
    80000c7a:	8082                	ret

0000000080000c7c <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c7c:	cacd                	beqz	a3,80000d2e <copyinstr+0xb2>
{
    80000c7e:	715d                	addi	sp,sp,-80
    80000c80:	e486                	sd	ra,72(sp)
    80000c82:	e0a2                	sd	s0,64(sp)
    80000c84:	fc26                	sd	s1,56(sp)
    80000c86:	f84a                	sd	s2,48(sp)
    80000c88:	f44e                	sd	s3,40(sp)
    80000c8a:	f052                	sd	s4,32(sp)
    80000c8c:	ec56                	sd	s5,24(sp)
    80000c8e:	e85a                	sd	s6,16(sp)
    80000c90:	e45e                	sd	s7,8(sp)
    80000c92:	0880                	addi	s0,sp,80
    80000c94:	8a2a                	mv	s4,a0
    80000c96:	8b2e                	mv	s6,a1
    80000c98:	8bb2                	mv	s7,a2
    80000c9a:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(srcva);
    80000c9c:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c9e:	6985                	lui	s3,0x1
    80000ca0:	a825                	j	80000cd8 <copyinstr+0x5c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000ca2:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000ca6:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000ca8:	37fd                	addiw	a5,a5,-1
    80000caa:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000cae:	60a6                	ld	ra,72(sp)
    80000cb0:	6406                	ld	s0,64(sp)
    80000cb2:	74e2                	ld	s1,56(sp)
    80000cb4:	7942                	ld	s2,48(sp)
    80000cb6:	79a2                	ld	s3,40(sp)
    80000cb8:	7a02                	ld	s4,32(sp)
    80000cba:	6ae2                	ld	s5,24(sp)
    80000cbc:	6b42                	ld	s6,16(sp)
    80000cbe:	6ba2                	ld	s7,8(sp)
    80000cc0:	6161                	addi	sp,sp,80
    80000cc2:	8082                	ret
    80000cc4:	fff90713          	addi	a4,s2,-1 # fff <_entry-0x7ffff001>
    80000cc8:	9742                	add	a4,a4,a6
      --max;
    80000cca:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    80000cce:	01348bb3          	add	s7,s1,s3
  while(got_null == 0 && max > 0){
    80000cd2:	04e58663          	beq	a1,a4,80000d1e <copyinstr+0xa2>
{
    80000cd6:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    80000cd8:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000cdc:	85a6                	mv	a1,s1
    80000cde:	8552                	mv	a0,s4
    80000ce0:	00000097          	auipc	ra,0x0
    80000ce4:	862080e7          	jalr	-1950(ra) # 80000542 <walkaddr>
    if(pa0 == 0)
    80000ce8:	cd0d                	beqz	a0,80000d22 <copyinstr+0xa6>
    n = PGSIZE - (srcva - va0);
    80000cea:	417486b3          	sub	a3,s1,s7
    80000cee:	96ce                	add	a3,a3,s3
    if(n > max)
    80000cf0:	00d97363          	bgeu	s2,a3,80000cf6 <copyinstr+0x7a>
    80000cf4:	86ca                	mv	a3,s2
    char *p = (char *) (pa0 + (srcva - va0));
    80000cf6:	955e                	add	a0,a0,s7
    80000cf8:	8d05                	sub	a0,a0,s1
    while(n > 0){
    80000cfa:	c695                	beqz	a3,80000d26 <copyinstr+0xaa>
    80000cfc:	87da                	mv	a5,s6
    80000cfe:	885a                	mv	a6,s6
      if(*p == '\0'){
    80000d00:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80000d04:	96da                	add	a3,a3,s6
    80000d06:	85be                	mv	a1,a5
      if(*p == '\0'){
    80000d08:	00f60733          	add	a4,a2,a5
    80000d0c:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffd8dc0>
    80000d10:	db49                	beqz	a4,80000ca2 <copyinstr+0x26>
        *dst = *p;
    80000d12:	00e78023          	sb	a4,0(a5)
      dst++;
    80000d16:	0785                	addi	a5,a5,1
    while(n > 0){
    80000d18:	fed797e3          	bne	a5,a3,80000d06 <copyinstr+0x8a>
    80000d1c:	b765                	j	80000cc4 <copyinstr+0x48>
    80000d1e:	4781                	li	a5,0
    80000d20:	b761                	j	80000ca8 <copyinstr+0x2c>
      return -1;
    80000d22:	557d                	li	a0,-1
    80000d24:	b769                	j	80000cae <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    80000d26:	6b85                	lui	s7,0x1
    80000d28:	9ba6                	add	s7,s7,s1
    80000d2a:	87da                	mv	a5,s6
    80000d2c:	b76d                	j	80000cd6 <copyinstr+0x5a>
  int got_null = 0;
    80000d2e:	4781                	li	a5,0
  if(got_null){
    80000d30:	37fd                	addiw	a5,a5,-1
    80000d32:	0007851b          	sext.w	a0,a5
}
    80000d36:	8082                	ret

0000000080000d38 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000d38:	7139                	addi	sp,sp,-64
    80000d3a:	fc06                	sd	ra,56(sp)
    80000d3c:	f822                	sd	s0,48(sp)
    80000d3e:	f426                	sd	s1,40(sp)
    80000d40:	f04a                	sd	s2,32(sp)
    80000d42:	ec4e                	sd	s3,24(sp)
    80000d44:	e852                	sd	s4,16(sp)
    80000d46:	e456                	sd	s5,8(sp)
    80000d48:	e05a                	sd	s6,0(sp)
    80000d4a:	0080                	addi	s0,sp,64
    80000d4c:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d4e:	00008497          	auipc	s1,0x8
    80000d52:	73248493          	addi	s1,s1,1842 # 80009480 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000d56:	8b26                	mv	s6,s1
    80000d58:	04fa5937          	lui	s2,0x4fa5
    80000d5c:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    80000d60:	0932                	slli	s2,s2,0xc
    80000d62:	fa590913          	addi	s2,s2,-91
    80000d66:	0932                	slli	s2,s2,0xc
    80000d68:	fa590913          	addi	s2,s2,-91
    80000d6c:	0932                	slli	s2,s2,0xc
    80000d6e:	fa590913          	addi	s2,s2,-91
    80000d72:	040009b7          	lui	s3,0x4000
    80000d76:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000d78:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d7a:	0000ea97          	auipc	s5,0xe
    80000d7e:	106a8a93          	addi	s5,s5,262 # 8000ee80 <tickslock>
    char *pa = kalloc();
    80000d82:	fffff097          	auipc	ra,0xfffff
    80000d86:	398080e7          	jalr	920(ra) # 8000011a <kalloc>
    80000d8a:	862a                	mv	a2,a0
    if(pa == 0)
    80000d8c:	c121                	beqz	a0,80000dcc <proc_mapstacks+0x94>
    uint64 va = KSTACK((int) (p - proc));
    80000d8e:	416485b3          	sub	a1,s1,s6
    80000d92:	858d                	srai	a1,a1,0x3
    80000d94:	032585b3          	mul	a1,a1,s2
    80000d98:	2585                	addiw	a1,a1,1
    80000d9a:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d9e:	4719                	li	a4,6
    80000da0:	6685                	lui	a3,0x1
    80000da2:	40b985b3          	sub	a1,s3,a1
    80000da6:	8552                	mv	a0,s4
    80000da8:	00000097          	auipc	ra,0x0
    80000dac:	87c080e7          	jalr	-1924(ra) # 80000624 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000db0:	16848493          	addi	s1,s1,360
    80000db4:	fd5497e3          	bne	s1,s5,80000d82 <proc_mapstacks+0x4a>
  }
}
    80000db8:	70e2                	ld	ra,56(sp)
    80000dba:	7442                	ld	s0,48(sp)
    80000dbc:	74a2                	ld	s1,40(sp)
    80000dbe:	7902                	ld	s2,32(sp)
    80000dc0:	69e2                	ld	s3,24(sp)
    80000dc2:	6a42                	ld	s4,16(sp)
    80000dc4:	6aa2                	ld	s5,8(sp)
    80000dc6:	6b02                	ld	s6,0(sp)
    80000dc8:	6121                	addi	sp,sp,64
    80000dca:	8082                	ret
      panic("kalloc");
    80000dcc:	00007517          	auipc	a0,0x7
    80000dd0:	38c50513          	addi	a0,a0,908 # 80008158 <etext+0x158>
    80000dd4:	00005097          	auipc	ra,0x5
    80000dd8:	f98080e7          	jalr	-104(ra) # 80005d6c <panic>

0000000080000ddc <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000ddc:	7139                	addi	sp,sp,-64
    80000dde:	fc06                	sd	ra,56(sp)
    80000de0:	f822                	sd	s0,48(sp)
    80000de2:	f426                	sd	s1,40(sp)
    80000de4:	f04a                	sd	s2,32(sp)
    80000de6:	ec4e                	sd	s3,24(sp)
    80000de8:	e852                	sd	s4,16(sp)
    80000dea:	e456                	sd	s5,8(sp)
    80000dec:	e05a                	sd	s6,0(sp)
    80000dee:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000df0:	00007597          	auipc	a1,0x7
    80000df4:	37058593          	addi	a1,a1,880 # 80008160 <etext+0x160>
    80000df8:	00008517          	auipc	a0,0x8
    80000dfc:	25850513          	addi	a0,a0,600 # 80009050 <pid_lock>
    80000e00:	00005097          	auipc	ra,0x5
    80000e04:	456080e7          	jalr	1110(ra) # 80006256 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000e08:	00007597          	auipc	a1,0x7
    80000e0c:	36058593          	addi	a1,a1,864 # 80008168 <etext+0x168>
    80000e10:	00008517          	auipc	a0,0x8
    80000e14:	25850513          	addi	a0,a0,600 # 80009068 <wait_lock>
    80000e18:	00005097          	auipc	ra,0x5
    80000e1c:	43e080e7          	jalr	1086(ra) # 80006256 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e20:	00008497          	auipc	s1,0x8
    80000e24:	66048493          	addi	s1,s1,1632 # 80009480 <proc>
      initlock(&p->lock, "proc");
    80000e28:	00007b17          	auipc	s6,0x7
    80000e2c:	350b0b13          	addi	s6,s6,848 # 80008178 <etext+0x178>
      p->kstack = KSTACK((int) (p - proc));
    80000e30:	8aa6                	mv	s5,s1
    80000e32:	04fa5937          	lui	s2,0x4fa5
    80000e36:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    80000e3a:	0932                	slli	s2,s2,0xc
    80000e3c:	fa590913          	addi	s2,s2,-91
    80000e40:	0932                	slli	s2,s2,0xc
    80000e42:	fa590913          	addi	s2,s2,-91
    80000e46:	0932                	slli	s2,s2,0xc
    80000e48:	fa590913          	addi	s2,s2,-91
    80000e4c:	040009b7          	lui	s3,0x4000
    80000e50:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000e52:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e54:	0000ea17          	auipc	s4,0xe
    80000e58:	02ca0a13          	addi	s4,s4,44 # 8000ee80 <tickslock>
      initlock(&p->lock, "proc");
    80000e5c:	85da                	mv	a1,s6
    80000e5e:	8526                	mv	a0,s1
    80000e60:	00005097          	auipc	ra,0x5
    80000e64:	3f6080e7          	jalr	1014(ra) # 80006256 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000e68:	415487b3          	sub	a5,s1,s5
    80000e6c:	878d                	srai	a5,a5,0x3
    80000e6e:	032787b3          	mul	a5,a5,s2
    80000e72:	2785                	addiw	a5,a5,1
    80000e74:	00d7979b          	slliw	a5,a5,0xd
    80000e78:	40f987b3          	sub	a5,s3,a5
    80000e7c:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e7e:	16848493          	addi	s1,s1,360
    80000e82:	fd449de3          	bne	s1,s4,80000e5c <procinit+0x80>
  }
}
    80000e86:	70e2                	ld	ra,56(sp)
    80000e88:	7442                	ld	s0,48(sp)
    80000e8a:	74a2                	ld	s1,40(sp)
    80000e8c:	7902                	ld	s2,32(sp)
    80000e8e:	69e2                	ld	s3,24(sp)
    80000e90:	6a42                	ld	s4,16(sp)
    80000e92:	6aa2                	ld	s5,8(sp)
    80000e94:	6b02                	ld	s6,0(sp)
    80000e96:	6121                	addi	sp,sp,64
    80000e98:	8082                	ret

0000000080000e9a <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e9a:	1141                	addi	sp,sp,-16
    80000e9c:	e422                	sd	s0,8(sp)
    80000e9e:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000ea0:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000ea2:	2501                	sext.w	a0,a0
    80000ea4:	6422                	ld	s0,8(sp)
    80000ea6:	0141                	addi	sp,sp,16
    80000ea8:	8082                	ret

0000000080000eaa <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000eaa:	1141                	addi	sp,sp,-16
    80000eac:	e422                	sd	s0,8(sp)
    80000eae:	0800                	addi	s0,sp,16
    80000eb0:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000eb2:	2781                	sext.w	a5,a5
    80000eb4:	079e                	slli	a5,a5,0x7
  return c;
}
    80000eb6:	00008517          	auipc	a0,0x8
    80000eba:	1ca50513          	addi	a0,a0,458 # 80009080 <cpus>
    80000ebe:	953e                	add	a0,a0,a5
    80000ec0:	6422                	ld	s0,8(sp)
    80000ec2:	0141                	addi	sp,sp,16
    80000ec4:	8082                	ret

0000000080000ec6 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000ec6:	1101                	addi	sp,sp,-32
    80000ec8:	ec06                	sd	ra,24(sp)
    80000eca:	e822                	sd	s0,16(sp)
    80000ecc:	e426                	sd	s1,8(sp)
    80000ece:	1000                	addi	s0,sp,32
  push_off();
    80000ed0:	00005097          	auipc	ra,0x5
    80000ed4:	3ca080e7          	jalr	970(ra) # 8000629a <push_off>
    80000ed8:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000eda:	2781                	sext.w	a5,a5
    80000edc:	079e                	slli	a5,a5,0x7
    80000ede:	00008717          	auipc	a4,0x8
    80000ee2:	17270713          	addi	a4,a4,370 # 80009050 <pid_lock>
    80000ee6:	97ba                	add	a5,a5,a4
    80000ee8:	7b84                	ld	s1,48(a5)
  pop_off();
    80000eea:	00005097          	auipc	ra,0x5
    80000eee:	450080e7          	jalr	1104(ra) # 8000633a <pop_off>
  return p;
}
    80000ef2:	8526                	mv	a0,s1
    80000ef4:	60e2                	ld	ra,24(sp)
    80000ef6:	6442                	ld	s0,16(sp)
    80000ef8:	64a2                	ld	s1,8(sp)
    80000efa:	6105                	addi	sp,sp,32
    80000efc:	8082                	ret

0000000080000efe <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000efe:	1141                	addi	sp,sp,-16
    80000f00:	e406                	sd	ra,8(sp)
    80000f02:	e022                	sd	s0,0(sp)
    80000f04:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000f06:	00000097          	auipc	ra,0x0
    80000f0a:	fc0080e7          	jalr	-64(ra) # 80000ec6 <myproc>
    80000f0e:	00005097          	auipc	ra,0x5
    80000f12:	48c080e7          	jalr	1164(ra) # 8000639a <release>

  if (first) {
    80000f16:	00008797          	auipc	a5,0x8
    80000f1a:	9ca7a783          	lw	a5,-1590(a5) # 800088e0 <first.1>
    80000f1e:	eb89                	bnez	a5,80000f30 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000f20:	00001097          	auipc	ra,0x1
    80000f24:	c4e080e7          	jalr	-946(ra) # 80001b6e <usertrapret>
}
    80000f28:	60a2                	ld	ra,8(sp)
    80000f2a:	6402                	ld	s0,0(sp)
    80000f2c:	0141                	addi	sp,sp,16
    80000f2e:	8082                	ret
    first = 0;
    80000f30:	00008797          	auipc	a5,0x8
    80000f34:	9a07a823          	sw	zero,-1616(a5) # 800088e0 <first.1>
    fsinit(ROOTDEV);
    80000f38:	4505                	li	a0,1
    80000f3a:	00002097          	auipc	ra,0x2
    80000f3e:	a50080e7          	jalr	-1456(ra) # 8000298a <fsinit>
    80000f42:	bff9                	j	80000f20 <forkret+0x22>

0000000080000f44 <allocpid>:
allocpid() {
    80000f44:	1101                	addi	sp,sp,-32
    80000f46:	ec06                	sd	ra,24(sp)
    80000f48:	e822                	sd	s0,16(sp)
    80000f4a:	e426                	sd	s1,8(sp)
    80000f4c:	e04a                	sd	s2,0(sp)
    80000f4e:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000f50:	00008917          	auipc	s2,0x8
    80000f54:	10090913          	addi	s2,s2,256 # 80009050 <pid_lock>
    80000f58:	854a                	mv	a0,s2
    80000f5a:	00005097          	auipc	ra,0x5
    80000f5e:	38c080e7          	jalr	908(ra) # 800062e6 <acquire>
  pid = nextpid;
    80000f62:	00008797          	auipc	a5,0x8
    80000f66:	98278793          	addi	a5,a5,-1662 # 800088e4 <nextpid>
    80000f6a:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000f6c:	0014871b          	addiw	a4,s1,1
    80000f70:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000f72:	854a                	mv	a0,s2
    80000f74:	00005097          	auipc	ra,0x5
    80000f78:	426080e7          	jalr	1062(ra) # 8000639a <release>
}
    80000f7c:	8526                	mv	a0,s1
    80000f7e:	60e2                	ld	ra,24(sp)
    80000f80:	6442                	ld	s0,16(sp)
    80000f82:	64a2                	ld	s1,8(sp)
    80000f84:	6902                	ld	s2,0(sp)
    80000f86:	6105                	addi	sp,sp,32
    80000f88:	8082                	ret

0000000080000f8a <proc_pagetable>:
{
    80000f8a:	1101                	addi	sp,sp,-32
    80000f8c:	ec06                	sd	ra,24(sp)
    80000f8e:	e822                	sd	s0,16(sp)
    80000f90:	e426                	sd	s1,8(sp)
    80000f92:	e04a                	sd	s2,0(sp)
    80000f94:	1000                	addi	s0,sp,32
    80000f96:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f98:	00000097          	auipc	ra,0x0
    80000f9c:	886080e7          	jalr	-1914(ra) # 8000081e <uvmcreate>
    80000fa0:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000fa2:	c121                	beqz	a0,80000fe2 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000fa4:	4729                	li	a4,10
    80000fa6:	00006697          	auipc	a3,0x6
    80000faa:	05a68693          	addi	a3,a3,90 # 80007000 <_trampoline>
    80000fae:	6605                	lui	a2,0x1
    80000fb0:	040005b7          	lui	a1,0x4000
    80000fb4:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000fb6:	05b2                	slli	a1,a1,0xc
    80000fb8:	fffff097          	auipc	ra,0xfffff
    80000fbc:	5cc080e7          	jalr	1484(ra) # 80000584 <mappages>
    80000fc0:	02054863          	bltz	a0,80000ff0 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000fc4:	4719                	li	a4,6
    80000fc6:	05893683          	ld	a3,88(s2)
    80000fca:	6605                	lui	a2,0x1
    80000fcc:	020005b7          	lui	a1,0x2000
    80000fd0:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000fd2:	05b6                	slli	a1,a1,0xd
    80000fd4:	8526                	mv	a0,s1
    80000fd6:	fffff097          	auipc	ra,0xfffff
    80000fda:	5ae080e7          	jalr	1454(ra) # 80000584 <mappages>
    80000fde:	02054163          	bltz	a0,80001000 <proc_pagetable+0x76>
}
    80000fe2:	8526                	mv	a0,s1
    80000fe4:	60e2                	ld	ra,24(sp)
    80000fe6:	6442                	ld	s0,16(sp)
    80000fe8:	64a2                	ld	s1,8(sp)
    80000fea:	6902                	ld	s2,0(sp)
    80000fec:	6105                	addi	sp,sp,32
    80000fee:	8082                	ret
    uvmfree(pagetable, 0);
    80000ff0:	4581                	li	a1,0
    80000ff2:	8526                	mv	a0,s1
    80000ff4:	00000097          	auipc	ra,0x0
    80000ff8:	a30080e7          	jalr	-1488(ra) # 80000a24 <uvmfree>
    return 0;
    80000ffc:	4481                	li	s1,0
    80000ffe:	b7d5                	j	80000fe2 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001000:	4681                	li	a3,0
    80001002:	4605                	li	a2,1
    80001004:	040005b7          	lui	a1,0x4000
    80001008:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000100a:	05b2                	slli	a1,a1,0xc
    8000100c:	8526                	mv	a0,s1
    8000100e:	fffff097          	auipc	ra,0xfffff
    80001012:	73c080e7          	jalr	1852(ra) # 8000074a <uvmunmap>
    uvmfree(pagetable, 0);
    80001016:	4581                	li	a1,0
    80001018:	8526                	mv	a0,s1
    8000101a:	00000097          	auipc	ra,0x0
    8000101e:	a0a080e7          	jalr	-1526(ra) # 80000a24 <uvmfree>
    return 0;
    80001022:	4481                	li	s1,0
    80001024:	bf7d                	j	80000fe2 <proc_pagetable+0x58>

0000000080001026 <proc_freepagetable>:
{
    80001026:	1101                	addi	sp,sp,-32
    80001028:	ec06                	sd	ra,24(sp)
    8000102a:	e822                	sd	s0,16(sp)
    8000102c:	e426                	sd	s1,8(sp)
    8000102e:	e04a                	sd	s2,0(sp)
    80001030:	1000                	addi	s0,sp,32
    80001032:	84aa                	mv	s1,a0
    80001034:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001036:	4681                	li	a3,0
    80001038:	4605                	li	a2,1
    8000103a:	040005b7          	lui	a1,0x4000
    8000103e:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001040:	05b2                	slli	a1,a1,0xc
    80001042:	fffff097          	auipc	ra,0xfffff
    80001046:	708080e7          	jalr	1800(ra) # 8000074a <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    8000104a:	4681                	li	a3,0
    8000104c:	4605                	li	a2,1
    8000104e:	020005b7          	lui	a1,0x2000
    80001052:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001054:	05b6                	slli	a1,a1,0xd
    80001056:	8526                	mv	a0,s1
    80001058:	fffff097          	auipc	ra,0xfffff
    8000105c:	6f2080e7          	jalr	1778(ra) # 8000074a <uvmunmap>
  uvmfree(pagetable, sz);
    80001060:	85ca                	mv	a1,s2
    80001062:	8526                	mv	a0,s1
    80001064:	00000097          	auipc	ra,0x0
    80001068:	9c0080e7          	jalr	-1600(ra) # 80000a24 <uvmfree>
}
    8000106c:	60e2                	ld	ra,24(sp)
    8000106e:	6442                	ld	s0,16(sp)
    80001070:	64a2                	ld	s1,8(sp)
    80001072:	6902                	ld	s2,0(sp)
    80001074:	6105                	addi	sp,sp,32
    80001076:	8082                	ret

0000000080001078 <freeproc>:
{
    80001078:	1101                	addi	sp,sp,-32
    8000107a:	ec06                	sd	ra,24(sp)
    8000107c:	e822                	sd	s0,16(sp)
    8000107e:	e426                	sd	s1,8(sp)
    80001080:	1000                	addi	s0,sp,32
    80001082:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001084:	6d28                	ld	a0,88(a0)
    80001086:	c509                	beqz	a0,80001090 <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001088:	fffff097          	auipc	ra,0xfffff
    8000108c:	f94080e7          	jalr	-108(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001090:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001094:	68a8                	ld	a0,80(s1)
    80001096:	c511                	beqz	a0,800010a2 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001098:	64ac                	ld	a1,72(s1)
    8000109a:	00000097          	auipc	ra,0x0
    8000109e:	f8c080e7          	jalr	-116(ra) # 80001026 <proc_freepagetable>
  p->pagetable = 0;
    800010a2:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    800010a6:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    800010aa:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    800010ae:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    800010b2:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    800010b6:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    800010ba:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    800010be:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    800010c2:	0004ac23          	sw	zero,24(s1)
}
    800010c6:	60e2                	ld	ra,24(sp)
    800010c8:	6442                	ld	s0,16(sp)
    800010ca:	64a2                	ld	s1,8(sp)
    800010cc:	6105                	addi	sp,sp,32
    800010ce:	8082                	ret

00000000800010d0 <allocproc>:
{
    800010d0:	1101                	addi	sp,sp,-32
    800010d2:	ec06                	sd	ra,24(sp)
    800010d4:	e822                	sd	s0,16(sp)
    800010d6:	e426                	sd	s1,8(sp)
    800010d8:	e04a                	sd	s2,0(sp)
    800010da:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    800010dc:	00008497          	auipc	s1,0x8
    800010e0:	3a448493          	addi	s1,s1,932 # 80009480 <proc>
    800010e4:	0000e917          	auipc	s2,0xe
    800010e8:	d9c90913          	addi	s2,s2,-612 # 8000ee80 <tickslock>
    acquire(&p->lock);
    800010ec:	8526                	mv	a0,s1
    800010ee:	00005097          	auipc	ra,0x5
    800010f2:	1f8080e7          	jalr	504(ra) # 800062e6 <acquire>
    if(p->state == UNUSED) {
    800010f6:	4c9c                	lw	a5,24(s1)
    800010f8:	cf81                	beqz	a5,80001110 <allocproc+0x40>
      release(&p->lock);
    800010fa:	8526                	mv	a0,s1
    800010fc:	00005097          	auipc	ra,0x5
    80001100:	29e080e7          	jalr	670(ra) # 8000639a <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001104:	16848493          	addi	s1,s1,360
    80001108:	ff2492e3          	bne	s1,s2,800010ec <allocproc+0x1c>
  return 0;
    8000110c:	4481                	li	s1,0
    8000110e:	a889                	j	80001160 <allocproc+0x90>
  p->pid = allocpid();
    80001110:	00000097          	auipc	ra,0x0
    80001114:	e34080e7          	jalr	-460(ra) # 80000f44 <allocpid>
    80001118:	d888                	sw	a0,48(s1)
  p->state = USED;
    8000111a:	4785                	li	a5,1
    8000111c:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    8000111e:	fffff097          	auipc	ra,0xfffff
    80001122:	ffc080e7          	jalr	-4(ra) # 8000011a <kalloc>
    80001126:	892a                	mv	s2,a0
    80001128:	eca8                	sd	a0,88(s1)
    8000112a:	c131                	beqz	a0,8000116e <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    8000112c:	8526                	mv	a0,s1
    8000112e:	00000097          	auipc	ra,0x0
    80001132:	e5c080e7          	jalr	-420(ra) # 80000f8a <proc_pagetable>
    80001136:	892a                	mv	s2,a0
    80001138:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    8000113a:	c531                	beqz	a0,80001186 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    8000113c:	07000613          	li	a2,112
    80001140:	4581                	li	a1,0
    80001142:	06048513          	addi	a0,s1,96
    80001146:	fffff097          	auipc	ra,0xfffff
    8000114a:	07e080e7          	jalr	126(ra) # 800001c4 <memset>
  p->context.ra = (uint64)forkret;
    8000114e:	00000797          	auipc	a5,0x0
    80001152:	db078793          	addi	a5,a5,-592 # 80000efe <forkret>
    80001156:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001158:	60bc                	ld	a5,64(s1)
    8000115a:	6705                	lui	a4,0x1
    8000115c:	97ba                	add	a5,a5,a4
    8000115e:	f4bc                	sd	a5,104(s1)
}
    80001160:	8526                	mv	a0,s1
    80001162:	60e2                	ld	ra,24(sp)
    80001164:	6442                	ld	s0,16(sp)
    80001166:	64a2                	ld	s1,8(sp)
    80001168:	6902                	ld	s2,0(sp)
    8000116a:	6105                	addi	sp,sp,32
    8000116c:	8082                	ret
    freeproc(p);
    8000116e:	8526                	mv	a0,s1
    80001170:	00000097          	auipc	ra,0x0
    80001174:	f08080e7          	jalr	-248(ra) # 80001078 <freeproc>
    release(&p->lock);
    80001178:	8526                	mv	a0,s1
    8000117a:	00005097          	auipc	ra,0x5
    8000117e:	220080e7          	jalr	544(ra) # 8000639a <release>
    return 0;
    80001182:	84ca                	mv	s1,s2
    80001184:	bff1                	j	80001160 <allocproc+0x90>
    freeproc(p);
    80001186:	8526                	mv	a0,s1
    80001188:	00000097          	auipc	ra,0x0
    8000118c:	ef0080e7          	jalr	-272(ra) # 80001078 <freeproc>
    release(&p->lock);
    80001190:	8526                	mv	a0,s1
    80001192:	00005097          	auipc	ra,0x5
    80001196:	208080e7          	jalr	520(ra) # 8000639a <release>
    return 0;
    8000119a:	84ca                	mv	s1,s2
    8000119c:	b7d1                	j	80001160 <allocproc+0x90>

000000008000119e <userinit>:
{
    8000119e:	1101                	addi	sp,sp,-32
    800011a0:	ec06                	sd	ra,24(sp)
    800011a2:	e822                	sd	s0,16(sp)
    800011a4:	e426                	sd	s1,8(sp)
    800011a6:	1000                	addi	s0,sp,32
  p = allocproc();
    800011a8:	00000097          	auipc	ra,0x0
    800011ac:	f28080e7          	jalr	-216(ra) # 800010d0 <allocproc>
    800011b0:	84aa                	mv	s1,a0
  initproc = p;
    800011b2:	00008797          	auipc	a5,0x8
    800011b6:	e4a7bf23          	sd	a0,-418(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    800011ba:	03400613          	li	a2,52
    800011be:	00007597          	auipc	a1,0x7
    800011c2:	73258593          	addi	a1,a1,1842 # 800088f0 <initcode>
    800011c6:	6928                	ld	a0,80(a0)
    800011c8:	fffff097          	auipc	ra,0xfffff
    800011cc:	684080e7          	jalr	1668(ra) # 8000084c <uvminit>
  p->sz = PGSIZE;
    800011d0:	6785                	lui	a5,0x1
    800011d2:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    800011d4:	6cb8                	ld	a4,88(s1)
    800011d6:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    800011da:	6cb8                	ld	a4,88(s1)
    800011dc:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800011de:	4641                	li	a2,16
    800011e0:	00007597          	auipc	a1,0x7
    800011e4:	fa058593          	addi	a1,a1,-96 # 80008180 <etext+0x180>
    800011e8:	15848513          	addi	a0,s1,344
    800011ec:	fffff097          	auipc	ra,0xfffff
    800011f0:	11a080e7          	jalr	282(ra) # 80000306 <safestrcpy>
  p->cwd = namei("/");
    800011f4:	00007517          	auipc	a0,0x7
    800011f8:	f9c50513          	addi	a0,a0,-100 # 80008190 <etext+0x190>
    800011fc:	00002097          	auipc	ra,0x2
    80001200:	1d4080e7          	jalr	468(ra) # 800033d0 <namei>
    80001204:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001208:	478d                	li	a5,3
    8000120a:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    8000120c:	8526                	mv	a0,s1
    8000120e:	00005097          	auipc	ra,0x5
    80001212:	18c080e7          	jalr	396(ra) # 8000639a <release>
}
    80001216:	60e2                	ld	ra,24(sp)
    80001218:	6442                	ld	s0,16(sp)
    8000121a:	64a2                	ld	s1,8(sp)
    8000121c:	6105                	addi	sp,sp,32
    8000121e:	8082                	ret

0000000080001220 <growproc>:
{
    80001220:	1101                	addi	sp,sp,-32
    80001222:	ec06                	sd	ra,24(sp)
    80001224:	e822                	sd	s0,16(sp)
    80001226:	e426                	sd	s1,8(sp)
    80001228:	e04a                	sd	s2,0(sp)
    8000122a:	1000                	addi	s0,sp,32
    8000122c:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    8000122e:	00000097          	auipc	ra,0x0
    80001232:	c98080e7          	jalr	-872(ra) # 80000ec6 <myproc>
    80001236:	892a                	mv	s2,a0
  sz = p->sz;
    80001238:	652c                	ld	a1,72(a0)
    8000123a:	0005879b          	sext.w	a5,a1
  if(n > 0){
    8000123e:	00904f63          	bgtz	s1,8000125c <growproc+0x3c>
  } else if(n < 0){
    80001242:	0204cd63          	bltz	s1,8000127c <growproc+0x5c>
  p->sz = sz;
    80001246:	1782                	slli	a5,a5,0x20
    80001248:	9381                	srli	a5,a5,0x20
    8000124a:	04f93423          	sd	a5,72(s2)
  return 0;
    8000124e:	4501                	li	a0,0
}
    80001250:	60e2                	ld	ra,24(sp)
    80001252:	6442                	ld	s0,16(sp)
    80001254:	64a2                	ld	s1,8(sp)
    80001256:	6902                	ld	s2,0(sp)
    80001258:	6105                	addi	sp,sp,32
    8000125a:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    8000125c:	00f4863b          	addw	a2,s1,a5
    80001260:	1602                	slli	a2,a2,0x20
    80001262:	9201                	srli	a2,a2,0x20
    80001264:	1582                	slli	a1,a1,0x20
    80001266:	9181                	srli	a1,a1,0x20
    80001268:	6928                	ld	a0,80(a0)
    8000126a:	fffff097          	auipc	ra,0xfffff
    8000126e:	69c080e7          	jalr	1692(ra) # 80000906 <uvmalloc>
    80001272:	0005079b          	sext.w	a5,a0
    80001276:	fbe1                	bnez	a5,80001246 <growproc+0x26>
      return -1;
    80001278:	557d                	li	a0,-1
    8000127a:	bfd9                	j	80001250 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    8000127c:	00f4863b          	addw	a2,s1,a5
    80001280:	1602                	slli	a2,a2,0x20
    80001282:	9201                	srli	a2,a2,0x20
    80001284:	1582                	slli	a1,a1,0x20
    80001286:	9181                	srli	a1,a1,0x20
    80001288:	6928                	ld	a0,80(a0)
    8000128a:	fffff097          	auipc	ra,0xfffff
    8000128e:	634080e7          	jalr	1588(ra) # 800008be <uvmdealloc>
    80001292:	0005079b          	sext.w	a5,a0
    80001296:	bf45                	j	80001246 <growproc+0x26>

0000000080001298 <fork>:
{
    80001298:	7139                	addi	sp,sp,-64
    8000129a:	fc06                	sd	ra,56(sp)
    8000129c:	f822                	sd	s0,48(sp)
    8000129e:	f04a                	sd	s2,32(sp)
    800012a0:	e456                	sd	s5,8(sp)
    800012a2:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    800012a4:	00000097          	auipc	ra,0x0
    800012a8:	c22080e7          	jalr	-990(ra) # 80000ec6 <myproc>
    800012ac:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    800012ae:	00000097          	auipc	ra,0x0
    800012b2:	e22080e7          	jalr	-478(ra) # 800010d0 <allocproc>
    800012b6:	12050463          	beqz	a0,800013de <fork+0x146>
    800012ba:	ec4e                	sd	s3,24(sp)
    800012bc:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800012be:	048ab603          	ld	a2,72(s5)
    800012c2:	692c                	ld	a1,80(a0)
    800012c4:	050ab503          	ld	a0,80(s5)
    800012c8:	fffff097          	auipc	ra,0xfffff
    800012cc:	796080e7          	jalr	1942(ra) # 80000a5e <uvmcopy>
    800012d0:	04054a63          	bltz	a0,80001324 <fork+0x8c>
    800012d4:	f426                	sd	s1,40(sp)
    800012d6:	e852                	sd	s4,16(sp)
  np->sz = p->sz;
    800012d8:	048ab783          	ld	a5,72(s5)
    800012dc:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    800012e0:	058ab683          	ld	a3,88(s5)
    800012e4:	87b6                	mv	a5,a3
    800012e6:	0589b703          	ld	a4,88(s3)
    800012ea:	12068693          	addi	a3,a3,288
    800012ee:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800012f2:	6788                	ld	a0,8(a5)
    800012f4:	6b8c                	ld	a1,16(a5)
    800012f6:	6f90                	ld	a2,24(a5)
    800012f8:	01073023          	sd	a6,0(a4)
    800012fc:	e708                	sd	a0,8(a4)
    800012fe:	eb0c                	sd	a1,16(a4)
    80001300:	ef10                	sd	a2,24(a4)
    80001302:	02078793          	addi	a5,a5,32
    80001306:	02070713          	addi	a4,a4,32
    8000130a:	fed792e3          	bne	a5,a3,800012ee <fork+0x56>
  np->trapframe->a0 = 0;
    8000130e:	0589b783          	ld	a5,88(s3)
    80001312:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001316:	0d0a8493          	addi	s1,s5,208
    8000131a:	0d098913          	addi	s2,s3,208
    8000131e:	150a8a13          	addi	s4,s5,336
    80001322:	a015                	j	80001346 <fork+0xae>
    freeproc(np);
    80001324:	854e                	mv	a0,s3
    80001326:	00000097          	auipc	ra,0x0
    8000132a:	d52080e7          	jalr	-686(ra) # 80001078 <freeproc>
    release(&np->lock);
    8000132e:	854e                	mv	a0,s3
    80001330:	00005097          	auipc	ra,0x5
    80001334:	06a080e7          	jalr	106(ra) # 8000639a <release>
    return -1;
    80001338:	597d                	li	s2,-1
    8000133a:	69e2                	ld	s3,24(sp)
    8000133c:	a851                	j	800013d0 <fork+0x138>
  for(i = 0; i < NOFILE; i++)
    8000133e:	04a1                	addi	s1,s1,8
    80001340:	0921                	addi	s2,s2,8
    80001342:	01448b63          	beq	s1,s4,80001358 <fork+0xc0>
    if(p->ofile[i])
    80001346:	6088                	ld	a0,0(s1)
    80001348:	d97d                	beqz	a0,8000133e <fork+0xa6>
      np->ofile[i] = filedup(p->ofile[i]);
    8000134a:	00002097          	auipc	ra,0x2
    8000134e:	6fe080e7          	jalr	1790(ra) # 80003a48 <filedup>
    80001352:	00a93023          	sd	a0,0(s2)
    80001356:	b7e5                	j	8000133e <fork+0xa6>
  np->cwd = idup(p->cwd);
    80001358:	150ab503          	ld	a0,336(s5)
    8000135c:	00002097          	auipc	ra,0x2
    80001360:	864080e7          	jalr	-1948(ra) # 80002bc0 <idup>
    80001364:	14a9b823          	sd	a0,336(s3)
  np->mask = p->mask;
    80001368:	034aa783          	lw	a5,52(s5)
    8000136c:	02f9aa23          	sw	a5,52(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001370:	4641                	li	a2,16
    80001372:	158a8593          	addi	a1,s5,344
    80001376:	15898513          	addi	a0,s3,344
    8000137a:	fffff097          	auipc	ra,0xfffff
    8000137e:	f8c080e7          	jalr	-116(ra) # 80000306 <safestrcpy>
  pid = np->pid;
    80001382:	0309a903          	lw	s2,48(s3)
  release(&np->lock);
    80001386:	854e                	mv	a0,s3
    80001388:	00005097          	auipc	ra,0x5
    8000138c:	012080e7          	jalr	18(ra) # 8000639a <release>
  acquire(&wait_lock);
    80001390:	00008497          	auipc	s1,0x8
    80001394:	cd848493          	addi	s1,s1,-808 # 80009068 <wait_lock>
    80001398:	8526                	mv	a0,s1
    8000139a:	00005097          	auipc	ra,0x5
    8000139e:	f4c080e7          	jalr	-180(ra) # 800062e6 <acquire>
  np->parent = p;
    800013a2:	0359bc23          	sd	s5,56(s3)
  release(&wait_lock);
    800013a6:	8526                	mv	a0,s1
    800013a8:	00005097          	auipc	ra,0x5
    800013ac:	ff2080e7          	jalr	-14(ra) # 8000639a <release>
  acquire(&np->lock);
    800013b0:	854e                	mv	a0,s3
    800013b2:	00005097          	auipc	ra,0x5
    800013b6:	f34080e7          	jalr	-204(ra) # 800062e6 <acquire>
  np->state = RUNNABLE;
    800013ba:	478d                	li	a5,3
    800013bc:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    800013c0:	854e                	mv	a0,s3
    800013c2:	00005097          	auipc	ra,0x5
    800013c6:	fd8080e7          	jalr	-40(ra) # 8000639a <release>
  return pid;
    800013ca:	74a2                	ld	s1,40(sp)
    800013cc:	69e2                	ld	s3,24(sp)
    800013ce:	6a42                	ld	s4,16(sp)
}
    800013d0:	854a                	mv	a0,s2
    800013d2:	70e2                	ld	ra,56(sp)
    800013d4:	7442                	ld	s0,48(sp)
    800013d6:	7902                	ld	s2,32(sp)
    800013d8:	6aa2                	ld	s5,8(sp)
    800013da:	6121                	addi	sp,sp,64
    800013dc:	8082                	ret
    return -1;
    800013de:	597d                	li	s2,-1
    800013e0:	bfc5                	j	800013d0 <fork+0x138>

00000000800013e2 <scheduler>:
{
    800013e2:	7139                	addi	sp,sp,-64
    800013e4:	fc06                	sd	ra,56(sp)
    800013e6:	f822                	sd	s0,48(sp)
    800013e8:	f426                	sd	s1,40(sp)
    800013ea:	f04a                	sd	s2,32(sp)
    800013ec:	ec4e                	sd	s3,24(sp)
    800013ee:	e852                	sd	s4,16(sp)
    800013f0:	e456                	sd	s5,8(sp)
    800013f2:	e05a                	sd	s6,0(sp)
    800013f4:	0080                	addi	s0,sp,64
    800013f6:	8792                	mv	a5,tp
  int id = r_tp();
    800013f8:	2781                	sext.w	a5,a5
  c->proc = 0;
    800013fa:	00779a93          	slli	s5,a5,0x7
    800013fe:	00008717          	auipc	a4,0x8
    80001402:	c5270713          	addi	a4,a4,-942 # 80009050 <pid_lock>
    80001406:	9756                	add	a4,a4,s5
    80001408:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    8000140c:	00008717          	auipc	a4,0x8
    80001410:	c7c70713          	addi	a4,a4,-900 # 80009088 <cpus+0x8>
    80001414:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001416:	498d                	li	s3,3
        p->state = RUNNING;
    80001418:	4b11                	li	s6,4
        c->proc = p;
    8000141a:	079e                	slli	a5,a5,0x7
    8000141c:	00008a17          	auipc	s4,0x8
    80001420:	c34a0a13          	addi	s4,s4,-972 # 80009050 <pid_lock>
    80001424:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001426:	0000e917          	auipc	s2,0xe
    8000142a:	a5a90913          	addi	s2,s2,-1446 # 8000ee80 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000142e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001432:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001436:	10079073          	csrw	sstatus,a5
    8000143a:	00008497          	auipc	s1,0x8
    8000143e:	04648493          	addi	s1,s1,70 # 80009480 <proc>
    80001442:	a811                	j	80001456 <scheduler+0x74>
      release(&p->lock);
    80001444:	8526                	mv	a0,s1
    80001446:	00005097          	auipc	ra,0x5
    8000144a:	f54080e7          	jalr	-172(ra) # 8000639a <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    8000144e:	16848493          	addi	s1,s1,360
    80001452:	fd248ee3          	beq	s1,s2,8000142e <scheduler+0x4c>
      acquire(&p->lock);
    80001456:	8526                	mv	a0,s1
    80001458:	00005097          	auipc	ra,0x5
    8000145c:	e8e080e7          	jalr	-370(ra) # 800062e6 <acquire>
      if(p->state == RUNNABLE) {
    80001460:	4c9c                	lw	a5,24(s1)
    80001462:	ff3791e3          	bne	a5,s3,80001444 <scheduler+0x62>
        p->state = RUNNING;
    80001466:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    8000146a:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    8000146e:	06048593          	addi	a1,s1,96
    80001472:	8556                	mv	a0,s5
    80001474:	00000097          	auipc	ra,0x0
    80001478:	650080e7          	jalr	1616(ra) # 80001ac4 <swtch>
        c->proc = 0;
    8000147c:	020a3823          	sd	zero,48(s4)
    80001480:	b7d1                	j	80001444 <scheduler+0x62>

0000000080001482 <sched>:
{
    80001482:	7179                	addi	sp,sp,-48
    80001484:	f406                	sd	ra,40(sp)
    80001486:	f022                	sd	s0,32(sp)
    80001488:	ec26                	sd	s1,24(sp)
    8000148a:	e84a                	sd	s2,16(sp)
    8000148c:	e44e                	sd	s3,8(sp)
    8000148e:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001490:	00000097          	auipc	ra,0x0
    80001494:	a36080e7          	jalr	-1482(ra) # 80000ec6 <myproc>
    80001498:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    8000149a:	00005097          	auipc	ra,0x5
    8000149e:	dd2080e7          	jalr	-558(ra) # 8000626c <holding>
    800014a2:	c93d                	beqz	a0,80001518 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    800014a4:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800014a6:	2781                	sext.w	a5,a5
    800014a8:	079e                	slli	a5,a5,0x7
    800014aa:	00008717          	auipc	a4,0x8
    800014ae:	ba670713          	addi	a4,a4,-1114 # 80009050 <pid_lock>
    800014b2:	97ba                	add	a5,a5,a4
    800014b4:	0a87a703          	lw	a4,168(a5)
    800014b8:	4785                	li	a5,1
    800014ba:	06f71763          	bne	a4,a5,80001528 <sched+0xa6>
  if(p->state == RUNNING)
    800014be:	4c98                	lw	a4,24(s1)
    800014c0:	4791                	li	a5,4
    800014c2:	06f70b63          	beq	a4,a5,80001538 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800014c6:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800014ca:	8b89                	andi	a5,a5,2
  if(intr_get())
    800014cc:	efb5                	bnez	a5,80001548 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    800014ce:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800014d0:	00008917          	auipc	s2,0x8
    800014d4:	b8090913          	addi	s2,s2,-1152 # 80009050 <pid_lock>
    800014d8:	2781                	sext.w	a5,a5
    800014da:	079e                	slli	a5,a5,0x7
    800014dc:	97ca                	add	a5,a5,s2
    800014de:	0ac7a983          	lw	s3,172(a5)
    800014e2:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800014e4:	2781                	sext.w	a5,a5
    800014e6:	079e                	slli	a5,a5,0x7
    800014e8:	00008597          	auipc	a1,0x8
    800014ec:	ba058593          	addi	a1,a1,-1120 # 80009088 <cpus+0x8>
    800014f0:	95be                	add	a1,a1,a5
    800014f2:	06048513          	addi	a0,s1,96
    800014f6:	00000097          	auipc	ra,0x0
    800014fa:	5ce080e7          	jalr	1486(ra) # 80001ac4 <swtch>
    800014fe:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001500:	2781                	sext.w	a5,a5
    80001502:	079e                	slli	a5,a5,0x7
    80001504:	993e                	add	s2,s2,a5
    80001506:	0b392623          	sw	s3,172(s2)
}
    8000150a:	70a2                	ld	ra,40(sp)
    8000150c:	7402                	ld	s0,32(sp)
    8000150e:	64e2                	ld	s1,24(sp)
    80001510:	6942                	ld	s2,16(sp)
    80001512:	69a2                	ld	s3,8(sp)
    80001514:	6145                	addi	sp,sp,48
    80001516:	8082                	ret
    panic("sched p->lock");
    80001518:	00007517          	auipc	a0,0x7
    8000151c:	c8050513          	addi	a0,a0,-896 # 80008198 <etext+0x198>
    80001520:	00005097          	auipc	ra,0x5
    80001524:	84c080e7          	jalr	-1972(ra) # 80005d6c <panic>
    panic("sched locks");
    80001528:	00007517          	auipc	a0,0x7
    8000152c:	c8050513          	addi	a0,a0,-896 # 800081a8 <etext+0x1a8>
    80001530:	00005097          	auipc	ra,0x5
    80001534:	83c080e7          	jalr	-1988(ra) # 80005d6c <panic>
    panic("sched running");
    80001538:	00007517          	auipc	a0,0x7
    8000153c:	c8050513          	addi	a0,a0,-896 # 800081b8 <etext+0x1b8>
    80001540:	00005097          	auipc	ra,0x5
    80001544:	82c080e7          	jalr	-2004(ra) # 80005d6c <panic>
    panic("sched interruptible");
    80001548:	00007517          	auipc	a0,0x7
    8000154c:	c8050513          	addi	a0,a0,-896 # 800081c8 <etext+0x1c8>
    80001550:	00005097          	auipc	ra,0x5
    80001554:	81c080e7          	jalr	-2020(ra) # 80005d6c <panic>

0000000080001558 <yield>:
{
    80001558:	1101                	addi	sp,sp,-32
    8000155a:	ec06                	sd	ra,24(sp)
    8000155c:	e822                	sd	s0,16(sp)
    8000155e:	e426                	sd	s1,8(sp)
    80001560:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001562:	00000097          	auipc	ra,0x0
    80001566:	964080e7          	jalr	-1692(ra) # 80000ec6 <myproc>
    8000156a:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000156c:	00005097          	auipc	ra,0x5
    80001570:	d7a080e7          	jalr	-646(ra) # 800062e6 <acquire>
  p->state = RUNNABLE;
    80001574:	478d                	li	a5,3
    80001576:	cc9c                	sw	a5,24(s1)
  sched();
    80001578:	00000097          	auipc	ra,0x0
    8000157c:	f0a080e7          	jalr	-246(ra) # 80001482 <sched>
  release(&p->lock);
    80001580:	8526                	mv	a0,s1
    80001582:	00005097          	auipc	ra,0x5
    80001586:	e18080e7          	jalr	-488(ra) # 8000639a <release>
}
    8000158a:	60e2                	ld	ra,24(sp)
    8000158c:	6442                	ld	s0,16(sp)
    8000158e:	64a2                	ld	s1,8(sp)
    80001590:	6105                	addi	sp,sp,32
    80001592:	8082                	ret

0000000080001594 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001594:	7179                	addi	sp,sp,-48
    80001596:	f406                	sd	ra,40(sp)
    80001598:	f022                	sd	s0,32(sp)
    8000159a:	ec26                	sd	s1,24(sp)
    8000159c:	e84a                	sd	s2,16(sp)
    8000159e:	e44e                	sd	s3,8(sp)
    800015a0:	1800                	addi	s0,sp,48
    800015a2:	89aa                	mv	s3,a0
    800015a4:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800015a6:	00000097          	auipc	ra,0x0
    800015aa:	920080e7          	jalr	-1760(ra) # 80000ec6 <myproc>
    800015ae:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800015b0:	00005097          	auipc	ra,0x5
    800015b4:	d36080e7          	jalr	-714(ra) # 800062e6 <acquire>
  release(lk);
    800015b8:	854a                	mv	a0,s2
    800015ba:	00005097          	auipc	ra,0x5
    800015be:	de0080e7          	jalr	-544(ra) # 8000639a <release>

  // Go to sleep.
  p->chan = chan;
    800015c2:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    800015c6:	4789                	li	a5,2
    800015c8:	cc9c                	sw	a5,24(s1)

  sched();
    800015ca:	00000097          	auipc	ra,0x0
    800015ce:	eb8080e7          	jalr	-328(ra) # 80001482 <sched>

  // Tidy up.
  p->chan = 0;
    800015d2:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800015d6:	8526                	mv	a0,s1
    800015d8:	00005097          	auipc	ra,0x5
    800015dc:	dc2080e7          	jalr	-574(ra) # 8000639a <release>
  acquire(lk);
    800015e0:	854a                	mv	a0,s2
    800015e2:	00005097          	auipc	ra,0x5
    800015e6:	d04080e7          	jalr	-764(ra) # 800062e6 <acquire>
}
    800015ea:	70a2                	ld	ra,40(sp)
    800015ec:	7402                	ld	s0,32(sp)
    800015ee:	64e2                	ld	s1,24(sp)
    800015f0:	6942                	ld	s2,16(sp)
    800015f2:	69a2                	ld	s3,8(sp)
    800015f4:	6145                	addi	sp,sp,48
    800015f6:	8082                	ret

00000000800015f8 <wait>:
{
    800015f8:	715d                	addi	sp,sp,-80
    800015fa:	e486                	sd	ra,72(sp)
    800015fc:	e0a2                	sd	s0,64(sp)
    800015fe:	fc26                	sd	s1,56(sp)
    80001600:	f84a                	sd	s2,48(sp)
    80001602:	f44e                	sd	s3,40(sp)
    80001604:	f052                	sd	s4,32(sp)
    80001606:	ec56                	sd	s5,24(sp)
    80001608:	e85a                	sd	s6,16(sp)
    8000160a:	e45e                	sd	s7,8(sp)
    8000160c:	e062                	sd	s8,0(sp)
    8000160e:	0880                	addi	s0,sp,80
    80001610:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80001612:	00000097          	auipc	ra,0x0
    80001616:	8b4080e7          	jalr	-1868(ra) # 80000ec6 <myproc>
    8000161a:	892a                	mv	s2,a0
  acquire(&wait_lock);
    8000161c:	00008517          	auipc	a0,0x8
    80001620:	a4c50513          	addi	a0,a0,-1460 # 80009068 <wait_lock>
    80001624:	00005097          	auipc	ra,0x5
    80001628:	cc2080e7          	jalr	-830(ra) # 800062e6 <acquire>
    havekids = 0;
    8000162c:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    8000162e:	4a15                	li	s4,5
        havekids = 1;
    80001630:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    80001632:	0000e997          	auipc	s3,0xe
    80001636:	84e98993          	addi	s3,s3,-1970 # 8000ee80 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000163a:	00008c17          	auipc	s8,0x8
    8000163e:	a2ec0c13          	addi	s8,s8,-1490 # 80009068 <wait_lock>
    80001642:	a87d                	j	80001700 <wait+0x108>
          pid = np->pid;
    80001644:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    80001648:	000b0e63          	beqz	s6,80001664 <wait+0x6c>
    8000164c:	4691                	li	a3,4
    8000164e:	02c48613          	addi	a2,s1,44
    80001652:	85da                	mv	a1,s6
    80001654:	05093503          	ld	a0,80(s2)
    80001658:	fffff097          	auipc	ra,0xfffff
    8000165c:	50a080e7          	jalr	1290(ra) # 80000b62 <copyout>
    80001660:	04054163          	bltz	a0,800016a2 <wait+0xaa>
          freeproc(np);
    80001664:	8526                	mv	a0,s1
    80001666:	00000097          	auipc	ra,0x0
    8000166a:	a12080e7          	jalr	-1518(ra) # 80001078 <freeproc>
          release(&np->lock);
    8000166e:	8526                	mv	a0,s1
    80001670:	00005097          	auipc	ra,0x5
    80001674:	d2a080e7          	jalr	-726(ra) # 8000639a <release>
          release(&wait_lock);
    80001678:	00008517          	auipc	a0,0x8
    8000167c:	9f050513          	addi	a0,a0,-1552 # 80009068 <wait_lock>
    80001680:	00005097          	auipc	ra,0x5
    80001684:	d1a080e7          	jalr	-742(ra) # 8000639a <release>
}
    80001688:	854e                	mv	a0,s3
    8000168a:	60a6                	ld	ra,72(sp)
    8000168c:	6406                	ld	s0,64(sp)
    8000168e:	74e2                	ld	s1,56(sp)
    80001690:	7942                	ld	s2,48(sp)
    80001692:	79a2                	ld	s3,40(sp)
    80001694:	7a02                	ld	s4,32(sp)
    80001696:	6ae2                	ld	s5,24(sp)
    80001698:	6b42                	ld	s6,16(sp)
    8000169a:	6ba2                	ld	s7,8(sp)
    8000169c:	6c02                	ld	s8,0(sp)
    8000169e:	6161                	addi	sp,sp,80
    800016a0:	8082                	ret
            release(&np->lock);
    800016a2:	8526                	mv	a0,s1
    800016a4:	00005097          	auipc	ra,0x5
    800016a8:	cf6080e7          	jalr	-778(ra) # 8000639a <release>
            release(&wait_lock);
    800016ac:	00008517          	auipc	a0,0x8
    800016b0:	9bc50513          	addi	a0,a0,-1604 # 80009068 <wait_lock>
    800016b4:	00005097          	auipc	ra,0x5
    800016b8:	ce6080e7          	jalr	-794(ra) # 8000639a <release>
            return -1;
    800016bc:	59fd                	li	s3,-1
    800016be:	b7e9                	j	80001688 <wait+0x90>
    for(np = proc; np < &proc[NPROC]; np++){
    800016c0:	16848493          	addi	s1,s1,360
    800016c4:	03348463          	beq	s1,s3,800016ec <wait+0xf4>
      if(np->parent == p){
    800016c8:	7c9c                	ld	a5,56(s1)
    800016ca:	ff279be3          	bne	a5,s2,800016c0 <wait+0xc8>
        acquire(&np->lock);
    800016ce:	8526                	mv	a0,s1
    800016d0:	00005097          	auipc	ra,0x5
    800016d4:	c16080e7          	jalr	-1002(ra) # 800062e6 <acquire>
        if(np->state == ZOMBIE){
    800016d8:	4c9c                	lw	a5,24(s1)
    800016da:	f74785e3          	beq	a5,s4,80001644 <wait+0x4c>
        release(&np->lock);
    800016de:	8526                	mv	a0,s1
    800016e0:	00005097          	auipc	ra,0x5
    800016e4:	cba080e7          	jalr	-838(ra) # 8000639a <release>
        havekids = 1;
    800016e8:	8756                	mv	a4,s5
    800016ea:	bfd9                	j	800016c0 <wait+0xc8>
    if(!havekids || p->killed){
    800016ec:	c305                	beqz	a4,8000170c <wait+0x114>
    800016ee:	02892783          	lw	a5,40(s2)
    800016f2:	ef89                	bnez	a5,8000170c <wait+0x114>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800016f4:	85e2                	mv	a1,s8
    800016f6:	854a                	mv	a0,s2
    800016f8:	00000097          	auipc	ra,0x0
    800016fc:	e9c080e7          	jalr	-356(ra) # 80001594 <sleep>
    havekids = 0;
    80001700:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    80001702:	00008497          	auipc	s1,0x8
    80001706:	d7e48493          	addi	s1,s1,-642 # 80009480 <proc>
    8000170a:	bf7d                	j	800016c8 <wait+0xd0>
      release(&wait_lock);
    8000170c:	00008517          	auipc	a0,0x8
    80001710:	95c50513          	addi	a0,a0,-1700 # 80009068 <wait_lock>
    80001714:	00005097          	auipc	ra,0x5
    80001718:	c86080e7          	jalr	-890(ra) # 8000639a <release>
      return -1;
    8000171c:	59fd                	li	s3,-1
    8000171e:	b7ad                	j	80001688 <wait+0x90>

0000000080001720 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001720:	7139                	addi	sp,sp,-64
    80001722:	fc06                	sd	ra,56(sp)
    80001724:	f822                	sd	s0,48(sp)
    80001726:	f426                	sd	s1,40(sp)
    80001728:	f04a                	sd	s2,32(sp)
    8000172a:	ec4e                	sd	s3,24(sp)
    8000172c:	e852                	sd	s4,16(sp)
    8000172e:	e456                	sd	s5,8(sp)
    80001730:	0080                	addi	s0,sp,64
    80001732:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001734:	00008497          	auipc	s1,0x8
    80001738:	d4c48493          	addi	s1,s1,-692 # 80009480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    8000173c:	4989                	li	s3,2
        p->state = RUNNABLE;
    8000173e:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001740:	0000d917          	auipc	s2,0xd
    80001744:	74090913          	addi	s2,s2,1856 # 8000ee80 <tickslock>
    80001748:	a811                	j	8000175c <wakeup+0x3c>
      }
      release(&p->lock);
    8000174a:	8526                	mv	a0,s1
    8000174c:	00005097          	auipc	ra,0x5
    80001750:	c4e080e7          	jalr	-946(ra) # 8000639a <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001754:	16848493          	addi	s1,s1,360
    80001758:	03248663          	beq	s1,s2,80001784 <wakeup+0x64>
    if(p != myproc()){
    8000175c:	fffff097          	auipc	ra,0xfffff
    80001760:	76a080e7          	jalr	1898(ra) # 80000ec6 <myproc>
    80001764:	fea488e3          	beq	s1,a0,80001754 <wakeup+0x34>
      acquire(&p->lock);
    80001768:	8526                	mv	a0,s1
    8000176a:	00005097          	auipc	ra,0x5
    8000176e:	b7c080e7          	jalr	-1156(ra) # 800062e6 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001772:	4c9c                	lw	a5,24(s1)
    80001774:	fd379be3          	bne	a5,s3,8000174a <wakeup+0x2a>
    80001778:	709c                	ld	a5,32(s1)
    8000177a:	fd4798e3          	bne	a5,s4,8000174a <wakeup+0x2a>
        p->state = RUNNABLE;
    8000177e:	0154ac23          	sw	s5,24(s1)
    80001782:	b7e1                	j	8000174a <wakeup+0x2a>
    }
  }
}
    80001784:	70e2                	ld	ra,56(sp)
    80001786:	7442                	ld	s0,48(sp)
    80001788:	74a2                	ld	s1,40(sp)
    8000178a:	7902                	ld	s2,32(sp)
    8000178c:	69e2                	ld	s3,24(sp)
    8000178e:	6a42                	ld	s4,16(sp)
    80001790:	6aa2                	ld	s5,8(sp)
    80001792:	6121                	addi	sp,sp,64
    80001794:	8082                	ret

0000000080001796 <reparent>:
{
    80001796:	7179                	addi	sp,sp,-48
    80001798:	f406                	sd	ra,40(sp)
    8000179a:	f022                	sd	s0,32(sp)
    8000179c:	ec26                	sd	s1,24(sp)
    8000179e:	e84a                	sd	s2,16(sp)
    800017a0:	e44e                	sd	s3,8(sp)
    800017a2:	e052                	sd	s4,0(sp)
    800017a4:	1800                	addi	s0,sp,48
    800017a6:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800017a8:	00008497          	auipc	s1,0x8
    800017ac:	cd848493          	addi	s1,s1,-808 # 80009480 <proc>
      pp->parent = initproc;
    800017b0:	00008a17          	auipc	s4,0x8
    800017b4:	860a0a13          	addi	s4,s4,-1952 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800017b8:	0000d997          	auipc	s3,0xd
    800017bc:	6c898993          	addi	s3,s3,1736 # 8000ee80 <tickslock>
    800017c0:	a029                	j	800017ca <reparent+0x34>
    800017c2:	16848493          	addi	s1,s1,360
    800017c6:	01348d63          	beq	s1,s3,800017e0 <reparent+0x4a>
    if(pp->parent == p){
    800017ca:	7c9c                	ld	a5,56(s1)
    800017cc:	ff279be3          	bne	a5,s2,800017c2 <reparent+0x2c>
      pp->parent = initproc;
    800017d0:	000a3503          	ld	a0,0(s4)
    800017d4:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    800017d6:	00000097          	auipc	ra,0x0
    800017da:	f4a080e7          	jalr	-182(ra) # 80001720 <wakeup>
    800017de:	b7d5                	j	800017c2 <reparent+0x2c>
}
    800017e0:	70a2                	ld	ra,40(sp)
    800017e2:	7402                	ld	s0,32(sp)
    800017e4:	64e2                	ld	s1,24(sp)
    800017e6:	6942                	ld	s2,16(sp)
    800017e8:	69a2                	ld	s3,8(sp)
    800017ea:	6a02                	ld	s4,0(sp)
    800017ec:	6145                	addi	sp,sp,48
    800017ee:	8082                	ret

00000000800017f0 <exit>:
{
    800017f0:	7179                	addi	sp,sp,-48
    800017f2:	f406                	sd	ra,40(sp)
    800017f4:	f022                	sd	s0,32(sp)
    800017f6:	ec26                	sd	s1,24(sp)
    800017f8:	e84a                	sd	s2,16(sp)
    800017fa:	e44e                	sd	s3,8(sp)
    800017fc:	e052                	sd	s4,0(sp)
    800017fe:	1800                	addi	s0,sp,48
    80001800:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001802:	fffff097          	auipc	ra,0xfffff
    80001806:	6c4080e7          	jalr	1732(ra) # 80000ec6 <myproc>
    8000180a:	89aa                	mv	s3,a0
  if(p == initproc)
    8000180c:	00008797          	auipc	a5,0x8
    80001810:	8047b783          	ld	a5,-2044(a5) # 80009010 <initproc>
    80001814:	0d050493          	addi	s1,a0,208
    80001818:	15050913          	addi	s2,a0,336
    8000181c:	02a79363          	bne	a5,a0,80001842 <exit+0x52>
    panic("init exiting");
    80001820:	00007517          	auipc	a0,0x7
    80001824:	9c050513          	addi	a0,a0,-1600 # 800081e0 <etext+0x1e0>
    80001828:	00004097          	auipc	ra,0x4
    8000182c:	544080e7          	jalr	1348(ra) # 80005d6c <panic>
      fileclose(f);
    80001830:	00002097          	auipc	ra,0x2
    80001834:	26a080e7          	jalr	618(ra) # 80003a9a <fileclose>
      p->ofile[fd] = 0;
    80001838:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    8000183c:	04a1                	addi	s1,s1,8
    8000183e:	01248563          	beq	s1,s2,80001848 <exit+0x58>
    if(p->ofile[fd]){
    80001842:	6088                	ld	a0,0(s1)
    80001844:	f575                	bnez	a0,80001830 <exit+0x40>
    80001846:	bfdd                	j	8000183c <exit+0x4c>
  begin_op();
    80001848:	00002097          	auipc	ra,0x2
    8000184c:	d88080e7          	jalr	-632(ra) # 800035d0 <begin_op>
  iput(p->cwd);
    80001850:	1509b503          	ld	a0,336(s3)
    80001854:	00001097          	auipc	ra,0x1
    80001858:	568080e7          	jalr	1384(ra) # 80002dbc <iput>
  end_op();
    8000185c:	00002097          	auipc	ra,0x2
    80001860:	dee080e7          	jalr	-530(ra) # 8000364a <end_op>
  p->cwd = 0;
    80001864:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001868:	00008497          	auipc	s1,0x8
    8000186c:	80048493          	addi	s1,s1,-2048 # 80009068 <wait_lock>
    80001870:	8526                	mv	a0,s1
    80001872:	00005097          	auipc	ra,0x5
    80001876:	a74080e7          	jalr	-1420(ra) # 800062e6 <acquire>
  reparent(p);
    8000187a:	854e                	mv	a0,s3
    8000187c:	00000097          	auipc	ra,0x0
    80001880:	f1a080e7          	jalr	-230(ra) # 80001796 <reparent>
  wakeup(p->parent);
    80001884:	0389b503          	ld	a0,56(s3)
    80001888:	00000097          	auipc	ra,0x0
    8000188c:	e98080e7          	jalr	-360(ra) # 80001720 <wakeup>
  acquire(&p->lock);
    80001890:	854e                	mv	a0,s3
    80001892:	00005097          	auipc	ra,0x5
    80001896:	a54080e7          	jalr	-1452(ra) # 800062e6 <acquire>
  p->xstate = status;
    8000189a:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    8000189e:	4795                	li	a5,5
    800018a0:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800018a4:	8526                	mv	a0,s1
    800018a6:	00005097          	auipc	ra,0x5
    800018aa:	af4080e7          	jalr	-1292(ra) # 8000639a <release>
  sched();
    800018ae:	00000097          	auipc	ra,0x0
    800018b2:	bd4080e7          	jalr	-1068(ra) # 80001482 <sched>
  panic("zombie exit");
    800018b6:	00007517          	auipc	a0,0x7
    800018ba:	93a50513          	addi	a0,a0,-1734 # 800081f0 <etext+0x1f0>
    800018be:	00004097          	auipc	ra,0x4
    800018c2:	4ae080e7          	jalr	1198(ra) # 80005d6c <panic>

00000000800018c6 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800018c6:	7179                	addi	sp,sp,-48
    800018c8:	f406                	sd	ra,40(sp)
    800018ca:	f022                	sd	s0,32(sp)
    800018cc:	ec26                	sd	s1,24(sp)
    800018ce:	e84a                	sd	s2,16(sp)
    800018d0:	e44e                	sd	s3,8(sp)
    800018d2:	1800                	addi	s0,sp,48
    800018d4:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800018d6:	00008497          	auipc	s1,0x8
    800018da:	baa48493          	addi	s1,s1,-1110 # 80009480 <proc>
    800018de:	0000d997          	auipc	s3,0xd
    800018e2:	5a298993          	addi	s3,s3,1442 # 8000ee80 <tickslock>
    acquire(&p->lock);
    800018e6:	8526                	mv	a0,s1
    800018e8:	00005097          	auipc	ra,0x5
    800018ec:	9fe080e7          	jalr	-1538(ra) # 800062e6 <acquire>
    if(p->pid == pid){
    800018f0:	589c                	lw	a5,48(s1)
    800018f2:	01278d63          	beq	a5,s2,8000190c <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800018f6:	8526                	mv	a0,s1
    800018f8:	00005097          	auipc	ra,0x5
    800018fc:	aa2080e7          	jalr	-1374(ra) # 8000639a <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001900:	16848493          	addi	s1,s1,360
    80001904:	ff3491e3          	bne	s1,s3,800018e6 <kill+0x20>
  }
  return -1;
    80001908:	557d                	li	a0,-1
    8000190a:	a829                	j	80001924 <kill+0x5e>
      p->killed = 1;
    8000190c:	4785                	li	a5,1
    8000190e:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001910:	4c98                	lw	a4,24(s1)
    80001912:	4789                	li	a5,2
    80001914:	00f70f63          	beq	a4,a5,80001932 <kill+0x6c>
      release(&p->lock);
    80001918:	8526                	mv	a0,s1
    8000191a:	00005097          	auipc	ra,0x5
    8000191e:	a80080e7          	jalr	-1408(ra) # 8000639a <release>
      return 0;
    80001922:	4501                	li	a0,0
}
    80001924:	70a2                	ld	ra,40(sp)
    80001926:	7402                	ld	s0,32(sp)
    80001928:	64e2                	ld	s1,24(sp)
    8000192a:	6942                	ld	s2,16(sp)
    8000192c:	69a2                	ld	s3,8(sp)
    8000192e:	6145                	addi	sp,sp,48
    80001930:	8082                	ret
        p->state = RUNNABLE;
    80001932:	478d                	li	a5,3
    80001934:	cc9c                	sw	a5,24(s1)
    80001936:	b7cd                	j	80001918 <kill+0x52>

0000000080001938 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001938:	7179                	addi	sp,sp,-48
    8000193a:	f406                	sd	ra,40(sp)
    8000193c:	f022                	sd	s0,32(sp)
    8000193e:	ec26                	sd	s1,24(sp)
    80001940:	e84a                	sd	s2,16(sp)
    80001942:	e44e                	sd	s3,8(sp)
    80001944:	e052                	sd	s4,0(sp)
    80001946:	1800                	addi	s0,sp,48
    80001948:	84aa                	mv	s1,a0
    8000194a:	892e                	mv	s2,a1
    8000194c:	89b2                	mv	s3,a2
    8000194e:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001950:	fffff097          	auipc	ra,0xfffff
    80001954:	576080e7          	jalr	1398(ra) # 80000ec6 <myproc>
  if(user_dst){
    80001958:	c08d                	beqz	s1,8000197a <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    8000195a:	86d2                	mv	a3,s4
    8000195c:	864e                	mv	a2,s3
    8000195e:	85ca                	mv	a1,s2
    80001960:	6928                	ld	a0,80(a0)
    80001962:	fffff097          	auipc	ra,0xfffff
    80001966:	200080e7          	jalr	512(ra) # 80000b62 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    8000196a:	70a2                	ld	ra,40(sp)
    8000196c:	7402                	ld	s0,32(sp)
    8000196e:	64e2                	ld	s1,24(sp)
    80001970:	6942                	ld	s2,16(sp)
    80001972:	69a2                	ld	s3,8(sp)
    80001974:	6a02                	ld	s4,0(sp)
    80001976:	6145                	addi	sp,sp,48
    80001978:	8082                	ret
    memmove((char *)dst, src, len);
    8000197a:	000a061b          	sext.w	a2,s4
    8000197e:	85ce                	mv	a1,s3
    80001980:	854a                	mv	a0,s2
    80001982:	fffff097          	auipc	ra,0xfffff
    80001986:	89e080e7          	jalr	-1890(ra) # 80000220 <memmove>
    return 0;
    8000198a:	8526                	mv	a0,s1
    8000198c:	bff9                	j	8000196a <either_copyout+0x32>

000000008000198e <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8000198e:	7179                	addi	sp,sp,-48
    80001990:	f406                	sd	ra,40(sp)
    80001992:	f022                	sd	s0,32(sp)
    80001994:	ec26                	sd	s1,24(sp)
    80001996:	e84a                	sd	s2,16(sp)
    80001998:	e44e                	sd	s3,8(sp)
    8000199a:	e052                	sd	s4,0(sp)
    8000199c:	1800                	addi	s0,sp,48
    8000199e:	892a                	mv	s2,a0
    800019a0:	84ae                	mv	s1,a1
    800019a2:	89b2                	mv	s3,a2
    800019a4:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800019a6:	fffff097          	auipc	ra,0xfffff
    800019aa:	520080e7          	jalr	1312(ra) # 80000ec6 <myproc>
  if(user_src){
    800019ae:	c08d                	beqz	s1,800019d0 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    800019b0:	86d2                	mv	a3,s4
    800019b2:	864e                	mv	a2,s3
    800019b4:	85ca                	mv	a1,s2
    800019b6:	6928                	ld	a0,80(a0)
    800019b8:	fffff097          	auipc	ra,0xfffff
    800019bc:	236080e7          	jalr	566(ra) # 80000bee <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800019c0:	70a2                	ld	ra,40(sp)
    800019c2:	7402                	ld	s0,32(sp)
    800019c4:	64e2                	ld	s1,24(sp)
    800019c6:	6942                	ld	s2,16(sp)
    800019c8:	69a2                	ld	s3,8(sp)
    800019ca:	6a02                	ld	s4,0(sp)
    800019cc:	6145                	addi	sp,sp,48
    800019ce:	8082                	ret
    memmove(dst, (char*)src, len);
    800019d0:	000a061b          	sext.w	a2,s4
    800019d4:	85ce                	mv	a1,s3
    800019d6:	854a                	mv	a0,s2
    800019d8:	fffff097          	auipc	ra,0xfffff
    800019dc:	848080e7          	jalr	-1976(ra) # 80000220 <memmove>
    return 0;
    800019e0:	8526                	mv	a0,s1
    800019e2:	bff9                	j	800019c0 <either_copyin+0x32>

00000000800019e4 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800019e4:	715d                	addi	sp,sp,-80
    800019e6:	e486                	sd	ra,72(sp)
    800019e8:	e0a2                	sd	s0,64(sp)
    800019ea:	fc26                	sd	s1,56(sp)
    800019ec:	f84a                	sd	s2,48(sp)
    800019ee:	f44e                	sd	s3,40(sp)
    800019f0:	f052                	sd	s4,32(sp)
    800019f2:	ec56                	sd	s5,24(sp)
    800019f4:	e85a                	sd	s6,16(sp)
    800019f6:	e45e                	sd	s7,8(sp)
    800019f8:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800019fa:	00006517          	auipc	a0,0x6
    800019fe:	61e50513          	addi	a0,a0,1566 # 80008018 <etext+0x18>
    80001a02:	00004097          	auipc	ra,0x4
    80001a06:	3b4080e7          	jalr	948(ra) # 80005db6 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a0a:	00008497          	auipc	s1,0x8
    80001a0e:	bce48493          	addi	s1,s1,-1074 # 800095d8 <proc+0x158>
    80001a12:	0000d917          	auipc	s2,0xd
    80001a16:	5c690913          	addi	s2,s2,1478 # 8000efd8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a1a:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001a1c:	00006997          	auipc	s3,0x6
    80001a20:	7e498993          	addi	s3,s3,2020 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    80001a24:	00006a97          	auipc	s5,0x6
    80001a28:	7e4a8a93          	addi	s5,s5,2020 # 80008208 <etext+0x208>
    printf("\n");
    80001a2c:	00006a17          	auipc	s4,0x6
    80001a30:	5eca0a13          	addi	s4,s4,1516 # 80008018 <etext+0x18>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a34:	00007b97          	auipc	s7,0x7
    80001a38:	d84b8b93          	addi	s7,s7,-636 # 800087b8 <states.0>
    80001a3c:	a00d                	j	80001a5e <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001a3e:	ed86a583          	lw	a1,-296(a3)
    80001a42:	8556                	mv	a0,s5
    80001a44:	00004097          	auipc	ra,0x4
    80001a48:	372080e7          	jalr	882(ra) # 80005db6 <printf>
    printf("\n");
    80001a4c:	8552                	mv	a0,s4
    80001a4e:	00004097          	auipc	ra,0x4
    80001a52:	368080e7          	jalr	872(ra) # 80005db6 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a56:	16848493          	addi	s1,s1,360
    80001a5a:	03248263          	beq	s1,s2,80001a7e <procdump+0x9a>
    if(p->state == UNUSED)
    80001a5e:	86a6                	mv	a3,s1
    80001a60:	ec04a783          	lw	a5,-320(s1)
    80001a64:	dbed                	beqz	a5,80001a56 <procdump+0x72>
      state = "???";
    80001a66:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a68:	fcfb6be3          	bltu	s6,a5,80001a3e <procdump+0x5a>
    80001a6c:	02079713          	slli	a4,a5,0x20
    80001a70:	01d75793          	srli	a5,a4,0x1d
    80001a74:	97de                	add	a5,a5,s7
    80001a76:	6390                	ld	a2,0(a5)
    80001a78:	f279                	bnez	a2,80001a3e <procdump+0x5a>
      state = "???";
    80001a7a:	864e                	mv	a2,s3
    80001a7c:	b7c9                	j	80001a3e <procdump+0x5a>
  }
}
    80001a7e:	60a6                	ld	ra,72(sp)
    80001a80:	6406                	ld	s0,64(sp)
    80001a82:	74e2                	ld	s1,56(sp)
    80001a84:	7942                	ld	s2,48(sp)
    80001a86:	79a2                	ld	s3,40(sp)
    80001a88:	7a02                	ld	s4,32(sp)
    80001a8a:	6ae2                	ld	s5,24(sp)
    80001a8c:	6b42                	ld	s6,16(sp)
    80001a8e:	6ba2                	ld	s7,8(sp)
    80001a90:	6161                	addi	sp,sp,80
    80001a92:	8082                	ret

0000000080001a94 <nproc>:

int nproc(void) {
    80001a94:	1141                	addi	sp,sp,-16
    80001a96:	e422                	sd	s0,8(sp)
    80001a98:	0800                	addi	s0,sp,16
  int count = 0;
  struct proc *p;
  for(p = proc; p < &proc[NPROC]; p++) {
    80001a9a:	00008797          	auipc	a5,0x8
    80001a9e:	9e678793          	addi	a5,a5,-1562 # 80009480 <proc>
  int count = 0;
    80001aa2:	4501                	li	a0,0
  for(p = proc; p < &proc[NPROC]; p++) {
    80001aa4:	0000d697          	auipc	a3,0xd
    80001aa8:	3dc68693          	addi	a3,a3,988 # 8000ee80 <tickslock>
    80001aac:	a029                	j	80001ab6 <nproc+0x22>
    80001aae:	16878793          	addi	a5,a5,360
    80001ab2:	00d78663          	beq	a5,a3,80001abe <nproc+0x2a>
    if(p->state != UNUSED) {
    80001ab6:	4f98                	lw	a4,24(a5)
    80001ab8:	db7d                	beqz	a4,80001aae <nproc+0x1a>
      count++;
    80001aba:	2505                	addiw	a0,a0,1
    80001abc:	bfcd                	j	80001aae <nproc+0x1a>
    }
  }
  return count;
}
    80001abe:	6422                	ld	s0,8(sp)
    80001ac0:	0141                	addi	sp,sp,16
    80001ac2:	8082                	ret

0000000080001ac4 <swtch>:
    80001ac4:	00153023          	sd	ra,0(a0)
    80001ac8:	00253423          	sd	sp,8(a0)
    80001acc:	e900                	sd	s0,16(a0)
    80001ace:	ed04                	sd	s1,24(a0)
    80001ad0:	03253023          	sd	s2,32(a0)
    80001ad4:	03353423          	sd	s3,40(a0)
    80001ad8:	03453823          	sd	s4,48(a0)
    80001adc:	03553c23          	sd	s5,56(a0)
    80001ae0:	05653023          	sd	s6,64(a0)
    80001ae4:	05753423          	sd	s7,72(a0)
    80001ae8:	05853823          	sd	s8,80(a0)
    80001aec:	05953c23          	sd	s9,88(a0)
    80001af0:	07a53023          	sd	s10,96(a0)
    80001af4:	07b53423          	sd	s11,104(a0)
    80001af8:	0005b083          	ld	ra,0(a1)
    80001afc:	0085b103          	ld	sp,8(a1)
    80001b00:	6980                	ld	s0,16(a1)
    80001b02:	6d84                	ld	s1,24(a1)
    80001b04:	0205b903          	ld	s2,32(a1)
    80001b08:	0285b983          	ld	s3,40(a1)
    80001b0c:	0305ba03          	ld	s4,48(a1)
    80001b10:	0385ba83          	ld	s5,56(a1)
    80001b14:	0405bb03          	ld	s6,64(a1)
    80001b18:	0485bb83          	ld	s7,72(a1)
    80001b1c:	0505bc03          	ld	s8,80(a1)
    80001b20:	0585bc83          	ld	s9,88(a1)
    80001b24:	0605bd03          	ld	s10,96(a1)
    80001b28:	0685bd83          	ld	s11,104(a1)
    80001b2c:	8082                	ret

0000000080001b2e <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001b2e:	1141                	addi	sp,sp,-16
    80001b30:	e406                	sd	ra,8(sp)
    80001b32:	e022                	sd	s0,0(sp)
    80001b34:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001b36:	00006597          	auipc	a1,0x6
    80001b3a:	70a58593          	addi	a1,a1,1802 # 80008240 <etext+0x240>
    80001b3e:	0000d517          	auipc	a0,0xd
    80001b42:	34250513          	addi	a0,a0,834 # 8000ee80 <tickslock>
    80001b46:	00004097          	auipc	ra,0x4
    80001b4a:	710080e7          	jalr	1808(ra) # 80006256 <initlock>
}
    80001b4e:	60a2                	ld	ra,8(sp)
    80001b50:	6402                	ld	s0,0(sp)
    80001b52:	0141                	addi	sp,sp,16
    80001b54:	8082                	ret

0000000080001b56 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001b56:	1141                	addi	sp,sp,-16
    80001b58:	e422                	sd	s0,8(sp)
    80001b5a:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b5c:	00003797          	auipc	a5,0x3
    80001b60:	62478793          	addi	a5,a5,1572 # 80005180 <kernelvec>
    80001b64:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001b68:	6422                	ld	s0,8(sp)
    80001b6a:	0141                	addi	sp,sp,16
    80001b6c:	8082                	ret

0000000080001b6e <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001b6e:	1141                	addi	sp,sp,-16
    80001b70:	e406                	sd	ra,8(sp)
    80001b72:	e022                	sd	s0,0(sp)
    80001b74:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001b76:	fffff097          	auipc	ra,0xfffff
    80001b7a:	350080e7          	jalr	848(ra) # 80000ec6 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b7e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001b82:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b84:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001b88:	00005697          	auipc	a3,0x5
    80001b8c:	47868693          	addi	a3,a3,1144 # 80007000 <_trampoline>
    80001b90:	00005717          	auipc	a4,0x5
    80001b94:	47070713          	addi	a4,a4,1136 # 80007000 <_trampoline>
    80001b98:	8f15                	sub	a4,a4,a3
    80001b9a:	040007b7          	lui	a5,0x4000
    80001b9e:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001ba0:	07b2                	slli	a5,a5,0xc
    80001ba2:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001ba4:	10571073          	csrw	stvec,a4

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001ba8:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001baa:	18002673          	csrr	a2,satp
    80001bae:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001bb0:	6d30                	ld	a2,88(a0)
    80001bb2:	6138                	ld	a4,64(a0)
    80001bb4:	6585                	lui	a1,0x1
    80001bb6:	972e                	add	a4,a4,a1
    80001bb8:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001bba:	6d38                	ld	a4,88(a0)
    80001bbc:	00000617          	auipc	a2,0x0
    80001bc0:	14060613          	addi	a2,a2,320 # 80001cfc <usertrap>
    80001bc4:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001bc6:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001bc8:	8612                	mv	a2,tp
    80001bca:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001bcc:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001bd0:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001bd4:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001bd8:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001bdc:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001bde:	6f18                	ld	a4,24(a4)
    80001be0:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001be4:	692c                	ld	a1,80(a0)
    80001be6:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001be8:	00005717          	auipc	a4,0x5
    80001bec:	4a870713          	addi	a4,a4,1192 # 80007090 <userret>
    80001bf0:	8f15                	sub	a4,a4,a3
    80001bf2:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001bf4:	577d                	li	a4,-1
    80001bf6:	177e                	slli	a4,a4,0x3f
    80001bf8:	8dd9                	or	a1,a1,a4
    80001bfa:	02000537          	lui	a0,0x2000
    80001bfe:	157d                	addi	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    80001c00:	0536                	slli	a0,a0,0xd
    80001c02:	9782                	jalr	a5
}
    80001c04:	60a2                	ld	ra,8(sp)
    80001c06:	6402                	ld	s0,0(sp)
    80001c08:	0141                	addi	sp,sp,16
    80001c0a:	8082                	ret

0000000080001c0c <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001c0c:	1101                	addi	sp,sp,-32
    80001c0e:	ec06                	sd	ra,24(sp)
    80001c10:	e822                	sd	s0,16(sp)
    80001c12:	e426                	sd	s1,8(sp)
    80001c14:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001c16:	0000d497          	auipc	s1,0xd
    80001c1a:	26a48493          	addi	s1,s1,618 # 8000ee80 <tickslock>
    80001c1e:	8526                	mv	a0,s1
    80001c20:	00004097          	auipc	ra,0x4
    80001c24:	6c6080e7          	jalr	1734(ra) # 800062e6 <acquire>
  ticks++;
    80001c28:	00007517          	auipc	a0,0x7
    80001c2c:	3f050513          	addi	a0,a0,1008 # 80009018 <ticks>
    80001c30:	411c                	lw	a5,0(a0)
    80001c32:	2785                	addiw	a5,a5,1
    80001c34:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001c36:	00000097          	auipc	ra,0x0
    80001c3a:	aea080e7          	jalr	-1302(ra) # 80001720 <wakeup>
  release(&tickslock);
    80001c3e:	8526                	mv	a0,s1
    80001c40:	00004097          	auipc	ra,0x4
    80001c44:	75a080e7          	jalr	1882(ra) # 8000639a <release>
}
    80001c48:	60e2                	ld	ra,24(sp)
    80001c4a:	6442                	ld	s0,16(sp)
    80001c4c:	64a2                	ld	s1,8(sp)
    80001c4e:	6105                	addi	sp,sp,32
    80001c50:	8082                	ret

0000000080001c52 <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001c52:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001c56:	4501                	li	a0,0
  if((scause & 0x8000000000000000L) &&
    80001c58:	0a07d163          	bgez	a5,80001cfa <devintr+0xa8>
{
    80001c5c:	1101                	addi	sp,sp,-32
    80001c5e:	ec06                	sd	ra,24(sp)
    80001c60:	e822                	sd	s0,16(sp)
    80001c62:	1000                	addi	s0,sp,32
     (scause & 0xff) == 9){
    80001c64:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    80001c68:	46a5                	li	a3,9
    80001c6a:	00d70c63          	beq	a4,a3,80001c82 <devintr+0x30>
  } else if(scause == 0x8000000000000001L){
    80001c6e:	577d                	li	a4,-1
    80001c70:	177e                	slli	a4,a4,0x3f
    80001c72:	0705                	addi	a4,a4,1
    return 0;
    80001c74:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001c76:	06e78163          	beq	a5,a4,80001cd8 <devintr+0x86>
  }
}
    80001c7a:	60e2                	ld	ra,24(sp)
    80001c7c:	6442                	ld	s0,16(sp)
    80001c7e:	6105                	addi	sp,sp,32
    80001c80:	8082                	ret
    80001c82:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80001c84:	00003097          	auipc	ra,0x3
    80001c88:	608080e7          	jalr	1544(ra) # 8000528c <plic_claim>
    80001c8c:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001c8e:	47a9                	li	a5,10
    80001c90:	00f50963          	beq	a0,a5,80001ca2 <devintr+0x50>
    } else if(irq == VIRTIO0_IRQ){
    80001c94:	4785                	li	a5,1
    80001c96:	00f50b63          	beq	a0,a5,80001cac <devintr+0x5a>
    return 1;
    80001c9a:	4505                	li	a0,1
    } else if(irq){
    80001c9c:	ec89                	bnez	s1,80001cb6 <devintr+0x64>
    80001c9e:	64a2                	ld	s1,8(sp)
    80001ca0:	bfe9                	j	80001c7a <devintr+0x28>
      uartintr();
    80001ca2:	00004097          	auipc	ra,0x4
    80001ca6:	564080e7          	jalr	1380(ra) # 80006206 <uartintr>
    if(irq)
    80001caa:	a839                	j	80001cc8 <devintr+0x76>
      virtio_disk_intr();
    80001cac:	00004097          	auipc	ra,0x4
    80001cb0:	ab4080e7          	jalr	-1356(ra) # 80005760 <virtio_disk_intr>
    if(irq)
    80001cb4:	a811                	j	80001cc8 <devintr+0x76>
      printf("unexpected interrupt irq=%d\n", irq);
    80001cb6:	85a6                	mv	a1,s1
    80001cb8:	00006517          	auipc	a0,0x6
    80001cbc:	59050513          	addi	a0,a0,1424 # 80008248 <etext+0x248>
    80001cc0:	00004097          	auipc	ra,0x4
    80001cc4:	0f6080e7          	jalr	246(ra) # 80005db6 <printf>
      plic_complete(irq);
    80001cc8:	8526                	mv	a0,s1
    80001cca:	00003097          	auipc	ra,0x3
    80001cce:	5e6080e7          	jalr	1510(ra) # 800052b0 <plic_complete>
    return 1;
    80001cd2:	4505                	li	a0,1
    80001cd4:	64a2                	ld	s1,8(sp)
    80001cd6:	b755                	j	80001c7a <devintr+0x28>
    if(cpuid() == 0){
    80001cd8:	fffff097          	auipc	ra,0xfffff
    80001cdc:	1c2080e7          	jalr	450(ra) # 80000e9a <cpuid>
    80001ce0:	c901                	beqz	a0,80001cf0 <devintr+0x9e>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001ce2:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001ce6:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001ce8:	14479073          	csrw	sip,a5
    return 2;
    80001cec:	4509                	li	a0,2
    80001cee:	b771                	j	80001c7a <devintr+0x28>
      clockintr();
    80001cf0:	00000097          	auipc	ra,0x0
    80001cf4:	f1c080e7          	jalr	-228(ra) # 80001c0c <clockintr>
    80001cf8:	b7ed                	j	80001ce2 <devintr+0x90>
}
    80001cfa:	8082                	ret

0000000080001cfc <usertrap>:
{
    80001cfc:	1101                	addi	sp,sp,-32
    80001cfe:	ec06                	sd	ra,24(sp)
    80001d00:	e822                	sd	s0,16(sp)
    80001d02:	e426                	sd	s1,8(sp)
    80001d04:	e04a                	sd	s2,0(sp)
    80001d06:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d08:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001d0c:	1007f793          	andi	a5,a5,256
    80001d10:	e3ad                	bnez	a5,80001d72 <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001d12:	00003797          	auipc	a5,0x3
    80001d16:	46e78793          	addi	a5,a5,1134 # 80005180 <kernelvec>
    80001d1a:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001d1e:	fffff097          	auipc	ra,0xfffff
    80001d22:	1a8080e7          	jalr	424(ra) # 80000ec6 <myproc>
    80001d26:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001d28:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d2a:	14102773          	csrr	a4,sepc
    80001d2e:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d30:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001d34:	47a1                	li	a5,8
    80001d36:	04f71c63          	bne	a4,a5,80001d8e <usertrap+0x92>
    if(p->killed)
    80001d3a:	551c                	lw	a5,40(a0)
    80001d3c:	e3b9                	bnez	a5,80001d82 <usertrap+0x86>
    p->trapframe->epc += 4;
    80001d3e:	6cb8                	ld	a4,88(s1)
    80001d40:	6f1c                	ld	a5,24(a4)
    80001d42:	0791                	addi	a5,a5,4
    80001d44:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d46:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d4a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d4e:	10079073          	csrw	sstatus,a5
    syscall();
    80001d52:	00000097          	auipc	ra,0x0
    80001d56:	2e0080e7          	jalr	736(ra) # 80002032 <syscall>
  if(p->killed)
    80001d5a:	549c                	lw	a5,40(s1)
    80001d5c:	ebc1                	bnez	a5,80001dec <usertrap+0xf0>
  usertrapret();
    80001d5e:	00000097          	auipc	ra,0x0
    80001d62:	e10080e7          	jalr	-496(ra) # 80001b6e <usertrapret>
}
    80001d66:	60e2                	ld	ra,24(sp)
    80001d68:	6442                	ld	s0,16(sp)
    80001d6a:	64a2                	ld	s1,8(sp)
    80001d6c:	6902                	ld	s2,0(sp)
    80001d6e:	6105                	addi	sp,sp,32
    80001d70:	8082                	ret
    panic("usertrap: not from user mode");
    80001d72:	00006517          	auipc	a0,0x6
    80001d76:	4f650513          	addi	a0,a0,1270 # 80008268 <etext+0x268>
    80001d7a:	00004097          	auipc	ra,0x4
    80001d7e:	ff2080e7          	jalr	-14(ra) # 80005d6c <panic>
      exit(-1);
    80001d82:	557d                	li	a0,-1
    80001d84:	00000097          	auipc	ra,0x0
    80001d88:	a6c080e7          	jalr	-1428(ra) # 800017f0 <exit>
    80001d8c:	bf4d                	j	80001d3e <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001d8e:	00000097          	auipc	ra,0x0
    80001d92:	ec4080e7          	jalr	-316(ra) # 80001c52 <devintr>
    80001d96:	892a                	mv	s2,a0
    80001d98:	c501                	beqz	a0,80001da0 <usertrap+0xa4>
  if(p->killed)
    80001d9a:	549c                	lw	a5,40(s1)
    80001d9c:	c3a1                	beqz	a5,80001ddc <usertrap+0xe0>
    80001d9e:	a815                	j	80001dd2 <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001da0:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001da4:	5890                	lw	a2,48(s1)
    80001da6:	00006517          	auipc	a0,0x6
    80001daa:	4e250513          	addi	a0,a0,1250 # 80008288 <etext+0x288>
    80001dae:	00004097          	auipc	ra,0x4
    80001db2:	008080e7          	jalr	8(ra) # 80005db6 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001db6:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001dba:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001dbe:	00006517          	auipc	a0,0x6
    80001dc2:	4fa50513          	addi	a0,a0,1274 # 800082b8 <etext+0x2b8>
    80001dc6:	00004097          	auipc	ra,0x4
    80001dca:	ff0080e7          	jalr	-16(ra) # 80005db6 <printf>
    p->killed = 1;
    80001dce:	4785                	li	a5,1
    80001dd0:	d49c                	sw	a5,40(s1)
    exit(-1);
    80001dd2:	557d                	li	a0,-1
    80001dd4:	00000097          	auipc	ra,0x0
    80001dd8:	a1c080e7          	jalr	-1508(ra) # 800017f0 <exit>
  if(which_dev == 2)
    80001ddc:	4789                	li	a5,2
    80001dde:	f8f910e3          	bne	s2,a5,80001d5e <usertrap+0x62>
    yield();
    80001de2:	fffff097          	auipc	ra,0xfffff
    80001de6:	776080e7          	jalr	1910(ra) # 80001558 <yield>
    80001dea:	bf95                	j	80001d5e <usertrap+0x62>
  int which_dev = 0;
    80001dec:	4901                	li	s2,0
    80001dee:	b7d5                	j	80001dd2 <usertrap+0xd6>

0000000080001df0 <kerneltrap>:
{
    80001df0:	7179                	addi	sp,sp,-48
    80001df2:	f406                	sd	ra,40(sp)
    80001df4:	f022                	sd	s0,32(sp)
    80001df6:	ec26                	sd	s1,24(sp)
    80001df8:	e84a                	sd	s2,16(sp)
    80001dfa:	e44e                	sd	s3,8(sp)
    80001dfc:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001dfe:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e02:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e06:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001e0a:	1004f793          	andi	a5,s1,256
    80001e0e:	cb85                	beqz	a5,80001e3e <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e10:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001e14:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001e16:	ef85                	bnez	a5,80001e4e <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001e18:	00000097          	auipc	ra,0x0
    80001e1c:	e3a080e7          	jalr	-454(ra) # 80001c52 <devintr>
    80001e20:	cd1d                	beqz	a0,80001e5e <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e22:	4789                	li	a5,2
    80001e24:	06f50a63          	beq	a0,a5,80001e98 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001e28:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e2c:	10049073          	csrw	sstatus,s1
}
    80001e30:	70a2                	ld	ra,40(sp)
    80001e32:	7402                	ld	s0,32(sp)
    80001e34:	64e2                	ld	s1,24(sp)
    80001e36:	6942                	ld	s2,16(sp)
    80001e38:	69a2                	ld	s3,8(sp)
    80001e3a:	6145                	addi	sp,sp,48
    80001e3c:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001e3e:	00006517          	auipc	a0,0x6
    80001e42:	49a50513          	addi	a0,a0,1178 # 800082d8 <etext+0x2d8>
    80001e46:	00004097          	auipc	ra,0x4
    80001e4a:	f26080e7          	jalr	-218(ra) # 80005d6c <panic>
    panic("kerneltrap: interrupts enabled");
    80001e4e:	00006517          	auipc	a0,0x6
    80001e52:	4b250513          	addi	a0,a0,1202 # 80008300 <etext+0x300>
    80001e56:	00004097          	auipc	ra,0x4
    80001e5a:	f16080e7          	jalr	-234(ra) # 80005d6c <panic>
    printf("scause %p\n", scause);
    80001e5e:	85ce                	mv	a1,s3
    80001e60:	00006517          	auipc	a0,0x6
    80001e64:	4c050513          	addi	a0,a0,1216 # 80008320 <etext+0x320>
    80001e68:	00004097          	auipc	ra,0x4
    80001e6c:	f4e080e7          	jalr	-178(ra) # 80005db6 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e70:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e74:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e78:	00006517          	auipc	a0,0x6
    80001e7c:	4b850513          	addi	a0,a0,1208 # 80008330 <etext+0x330>
    80001e80:	00004097          	auipc	ra,0x4
    80001e84:	f36080e7          	jalr	-202(ra) # 80005db6 <printf>
    panic("kerneltrap");
    80001e88:	00006517          	auipc	a0,0x6
    80001e8c:	4c050513          	addi	a0,a0,1216 # 80008348 <etext+0x348>
    80001e90:	00004097          	auipc	ra,0x4
    80001e94:	edc080e7          	jalr	-292(ra) # 80005d6c <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e98:	fffff097          	auipc	ra,0xfffff
    80001e9c:	02e080e7          	jalr	46(ra) # 80000ec6 <myproc>
    80001ea0:	d541                	beqz	a0,80001e28 <kerneltrap+0x38>
    80001ea2:	fffff097          	auipc	ra,0xfffff
    80001ea6:	024080e7          	jalr	36(ra) # 80000ec6 <myproc>
    80001eaa:	4d18                	lw	a4,24(a0)
    80001eac:	4791                	li	a5,4
    80001eae:	f6f71de3          	bne	a4,a5,80001e28 <kerneltrap+0x38>
    yield();
    80001eb2:	fffff097          	auipc	ra,0xfffff
    80001eb6:	6a6080e7          	jalr	1702(ra) # 80001558 <yield>
    80001eba:	b7bd                	j	80001e28 <kerneltrap+0x38>

0000000080001ebc <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001ebc:	1101                	addi	sp,sp,-32
    80001ebe:	ec06                	sd	ra,24(sp)
    80001ec0:	e822                	sd	s0,16(sp)
    80001ec2:	e426                	sd	s1,8(sp)
    80001ec4:	1000                	addi	s0,sp,32
    80001ec6:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001ec8:	fffff097          	auipc	ra,0xfffff
    80001ecc:	ffe080e7          	jalr	-2(ra) # 80000ec6 <myproc>
  switch (n) {
    80001ed0:	4795                	li	a5,5
    80001ed2:	0497e163          	bltu	a5,s1,80001f14 <argraw+0x58>
    80001ed6:	048a                	slli	s1,s1,0x2
    80001ed8:	00007717          	auipc	a4,0x7
    80001edc:	91070713          	addi	a4,a4,-1776 # 800087e8 <states.0+0x30>
    80001ee0:	94ba                	add	s1,s1,a4
    80001ee2:	409c                	lw	a5,0(s1)
    80001ee4:	97ba                	add	a5,a5,a4
    80001ee6:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001ee8:	6d3c                	ld	a5,88(a0)
    80001eea:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001eec:	60e2                	ld	ra,24(sp)
    80001eee:	6442                	ld	s0,16(sp)
    80001ef0:	64a2                	ld	s1,8(sp)
    80001ef2:	6105                	addi	sp,sp,32
    80001ef4:	8082                	ret
    return p->trapframe->a1;
    80001ef6:	6d3c                	ld	a5,88(a0)
    80001ef8:	7fa8                	ld	a0,120(a5)
    80001efa:	bfcd                	j	80001eec <argraw+0x30>
    return p->trapframe->a2;
    80001efc:	6d3c                	ld	a5,88(a0)
    80001efe:	63c8                	ld	a0,128(a5)
    80001f00:	b7f5                	j	80001eec <argraw+0x30>
    return p->trapframe->a3;
    80001f02:	6d3c                	ld	a5,88(a0)
    80001f04:	67c8                	ld	a0,136(a5)
    80001f06:	b7dd                	j	80001eec <argraw+0x30>
    return p->trapframe->a4;
    80001f08:	6d3c                	ld	a5,88(a0)
    80001f0a:	6bc8                	ld	a0,144(a5)
    80001f0c:	b7c5                	j	80001eec <argraw+0x30>
    return p->trapframe->a5;
    80001f0e:	6d3c                	ld	a5,88(a0)
    80001f10:	6fc8                	ld	a0,152(a5)
    80001f12:	bfe9                	j	80001eec <argraw+0x30>
  panic("argraw");
    80001f14:	00006517          	auipc	a0,0x6
    80001f18:	44450513          	addi	a0,a0,1092 # 80008358 <etext+0x358>
    80001f1c:	00004097          	auipc	ra,0x4
    80001f20:	e50080e7          	jalr	-432(ra) # 80005d6c <panic>

0000000080001f24 <fetchaddr>:
{
    80001f24:	1101                	addi	sp,sp,-32
    80001f26:	ec06                	sd	ra,24(sp)
    80001f28:	e822                	sd	s0,16(sp)
    80001f2a:	e426                	sd	s1,8(sp)
    80001f2c:	e04a                	sd	s2,0(sp)
    80001f2e:	1000                	addi	s0,sp,32
    80001f30:	84aa                	mv	s1,a0
    80001f32:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001f34:	fffff097          	auipc	ra,0xfffff
    80001f38:	f92080e7          	jalr	-110(ra) # 80000ec6 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80001f3c:	653c                	ld	a5,72(a0)
    80001f3e:	02f4f863          	bgeu	s1,a5,80001f6e <fetchaddr+0x4a>
    80001f42:	00848713          	addi	a4,s1,8
    80001f46:	02e7e663          	bltu	a5,a4,80001f72 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001f4a:	46a1                	li	a3,8
    80001f4c:	8626                	mv	a2,s1
    80001f4e:	85ca                	mv	a1,s2
    80001f50:	6928                	ld	a0,80(a0)
    80001f52:	fffff097          	auipc	ra,0xfffff
    80001f56:	c9c080e7          	jalr	-868(ra) # 80000bee <copyin>
    80001f5a:	00a03533          	snez	a0,a0
    80001f5e:	40a00533          	neg	a0,a0
}
    80001f62:	60e2                	ld	ra,24(sp)
    80001f64:	6442                	ld	s0,16(sp)
    80001f66:	64a2                	ld	s1,8(sp)
    80001f68:	6902                	ld	s2,0(sp)
    80001f6a:	6105                	addi	sp,sp,32
    80001f6c:	8082                	ret
    return -1;
    80001f6e:	557d                	li	a0,-1
    80001f70:	bfcd                	j	80001f62 <fetchaddr+0x3e>
    80001f72:	557d                	li	a0,-1
    80001f74:	b7fd                	j	80001f62 <fetchaddr+0x3e>

0000000080001f76 <fetchstr>:
{
    80001f76:	7179                	addi	sp,sp,-48
    80001f78:	f406                	sd	ra,40(sp)
    80001f7a:	f022                	sd	s0,32(sp)
    80001f7c:	ec26                	sd	s1,24(sp)
    80001f7e:	e84a                	sd	s2,16(sp)
    80001f80:	e44e                	sd	s3,8(sp)
    80001f82:	1800                	addi	s0,sp,48
    80001f84:	892a                	mv	s2,a0
    80001f86:	84ae                	mv	s1,a1
    80001f88:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001f8a:	fffff097          	auipc	ra,0xfffff
    80001f8e:	f3c080e7          	jalr	-196(ra) # 80000ec6 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80001f92:	86ce                	mv	a3,s3
    80001f94:	864a                	mv	a2,s2
    80001f96:	85a6                	mv	a1,s1
    80001f98:	6928                	ld	a0,80(a0)
    80001f9a:	fffff097          	auipc	ra,0xfffff
    80001f9e:	ce2080e7          	jalr	-798(ra) # 80000c7c <copyinstr>
  if(err < 0)
    80001fa2:	00054763          	bltz	a0,80001fb0 <fetchstr+0x3a>
  return strlen(buf);
    80001fa6:	8526                	mv	a0,s1
    80001fa8:	ffffe097          	auipc	ra,0xffffe
    80001fac:	390080e7          	jalr	912(ra) # 80000338 <strlen>
}
    80001fb0:	70a2                	ld	ra,40(sp)
    80001fb2:	7402                	ld	s0,32(sp)
    80001fb4:	64e2                	ld	s1,24(sp)
    80001fb6:	6942                	ld	s2,16(sp)
    80001fb8:	69a2                	ld	s3,8(sp)
    80001fba:	6145                	addi	sp,sp,48
    80001fbc:	8082                	ret

0000000080001fbe <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80001fbe:	1101                	addi	sp,sp,-32
    80001fc0:	ec06                	sd	ra,24(sp)
    80001fc2:	e822                	sd	s0,16(sp)
    80001fc4:	e426                	sd	s1,8(sp)
    80001fc6:	1000                	addi	s0,sp,32
    80001fc8:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001fca:	00000097          	auipc	ra,0x0
    80001fce:	ef2080e7          	jalr	-270(ra) # 80001ebc <argraw>
    80001fd2:	c088                	sw	a0,0(s1)
  return 0;
}
    80001fd4:	4501                	li	a0,0
    80001fd6:	60e2                	ld	ra,24(sp)
    80001fd8:	6442                	ld	s0,16(sp)
    80001fda:	64a2                	ld	s1,8(sp)
    80001fdc:	6105                	addi	sp,sp,32
    80001fde:	8082                	ret

0000000080001fe0 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80001fe0:	1101                	addi	sp,sp,-32
    80001fe2:	ec06                	sd	ra,24(sp)
    80001fe4:	e822                	sd	s0,16(sp)
    80001fe6:	e426                	sd	s1,8(sp)
    80001fe8:	1000                	addi	s0,sp,32
    80001fea:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001fec:	00000097          	auipc	ra,0x0
    80001ff0:	ed0080e7          	jalr	-304(ra) # 80001ebc <argraw>
    80001ff4:	e088                	sd	a0,0(s1)
  return 0;
}
    80001ff6:	4501                	li	a0,0
    80001ff8:	60e2                	ld	ra,24(sp)
    80001ffa:	6442                	ld	s0,16(sp)
    80001ffc:	64a2                	ld	s1,8(sp)
    80001ffe:	6105                	addi	sp,sp,32
    80002000:	8082                	ret

0000000080002002 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002002:	1101                	addi	sp,sp,-32
    80002004:	ec06                	sd	ra,24(sp)
    80002006:	e822                	sd	s0,16(sp)
    80002008:	e426                	sd	s1,8(sp)
    8000200a:	e04a                	sd	s2,0(sp)
    8000200c:	1000                	addi	s0,sp,32
    8000200e:	84ae                	mv	s1,a1
    80002010:	8932                	mv	s2,a2
  *ip = argraw(n);
    80002012:	00000097          	auipc	ra,0x0
    80002016:	eaa080e7          	jalr	-342(ra) # 80001ebc <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    8000201a:	864a                	mv	a2,s2
    8000201c:	85a6                	mv	a1,s1
    8000201e:	00000097          	auipc	ra,0x0
    80002022:	f58080e7          	jalr	-168(ra) # 80001f76 <fetchstr>
}
    80002026:	60e2                	ld	ra,24(sp)
    80002028:	6442                	ld	s0,16(sp)
    8000202a:	64a2                	ld	s1,8(sp)
    8000202c:	6902                	ld	s2,0(sp)
    8000202e:	6105                	addi	sp,sp,32
    80002030:	8082                	ret

0000000080002032 <syscall>:
  "trace"
};

void
syscall(void)
{
    80002032:	7179                	addi	sp,sp,-48
    80002034:	f406                	sd	ra,40(sp)
    80002036:	f022                	sd	s0,32(sp)
    80002038:	ec26                	sd	s1,24(sp)
    8000203a:	e84a                	sd	s2,16(sp)
    8000203c:	e44e                	sd	s3,8(sp)
    8000203e:	1800                	addi	s0,sp,48
  int num;
  struct proc *p = myproc();
    80002040:	fffff097          	auipc	ra,0xfffff
    80002044:	e86080e7          	jalr	-378(ra) # 80000ec6 <myproc>
    80002048:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    8000204a:	05853903          	ld	s2,88(a0)
    8000204e:	0a893783          	ld	a5,168(s2)
    80002052:	0007899b          	sext.w	s3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002056:	37fd                	addiw	a5,a5,-1
    80002058:	4759                	li	a4,22
    8000205a:	04f76763          	bltu	a4,a5,800020a8 <syscall+0x76>
    8000205e:	00399713          	slli	a4,s3,0x3
    80002062:	00006797          	auipc	a5,0x6
    80002066:	79e78793          	addi	a5,a5,1950 # 80008800 <syscalls>
    8000206a:	97ba                	add	a5,a5,a4
    8000206c:	639c                	ld	a5,0(a5)
    8000206e:	cf8d                	beqz	a5,800020a8 <syscall+0x76>
    p->trapframe->a0 = syscalls[num]();
    80002070:	9782                	jalr	a5
    80002072:	06a93823          	sd	a0,112(s2)
    if (p->mask & (1 << num)) {
    80002076:	58dc                	lw	a5,52(s1)
    80002078:	4137d7bb          	sraw	a5,a5,s3
    8000207c:	8b85                	andi	a5,a5,1
    8000207e:	c7a1                	beqz	a5,800020c6 <syscall+0x94>
      printf("%d: syscall %s -> %d\n",
    80002080:	6cb8                	ld	a4,88(s1)
    80002082:	39fd                	addiw	s3,s3,-1
    80002084:	098e                	slli	s3,s3,0x3
    80002086:	00007797          	auipc	a5,0x7
    8000208a:	8a278793          	addi	a5,a5,-1886 # 80008928 <syscallnames>
    8000208e:	97ce                	add	a5,a5,s3
    80002090:	7b34                	ld	a3,112(a4)
    80002092:	6390                	ld	a2,0(a5)
    80002094:	588c                	lw	a1,48(s1)
    80002096:	00006517          	auipc	a0,0x6
    8000209a:	2ca50513          	addi	a0,a0,714 # 80008360 <etext+0x360>
    8000209e:	00004097          	auipc	ra,0x4
    800020a2:	d18080e7          	jalr	-744(ra) # 80005db6 <printf>
    800020a6:	a005                	j	800020c6 <syscall+0x94>
             p->pid, syscallnames[num-1], p->trapframe->a0);
    }
    
  } else {
    printf("%d %s: unknown sys call %d\n",
    800020a8:	86ce                	mv	a3,s3
    800020aa:	15848613          	addi	a2,s1,344
    800020ae:	588c                	lw	a1,48(s1)
    800020b0:	00006517          	auipc	a0,0x6
    800020b4:	2c850513          	addi	a0,a0,712 # 80008378 <etext+0x378>
    800020b8:	00004097          	auipc	ra,0x4
    800020bc:	cfe080e7          	jalr	-770(ra) # 80005db6 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800020c0:	6cbc                	ld	a5,88(s1)
    800020c2:	577d                	li	a4,-1
    800020c4:	fbb8                	sd	a4,112(a5)
  }
}
    800020c6:	70a2                	ld	ra,40(sp)
    800020c8:	7402                	ld	s0,32(sp)
    800020ca:	64e2                	ld	s1,24(sp)
    800020cc:	6942                	ld	s2,16(sp)
    800020ce:	69a2                	ld	s3,8(sp)
    800020d0:	6145                	addi	sp,sp,48
    800020d2:	8082                	ret

00000000800020d4 <sys_exit>:
#include "sysinfo.h"
#include "syscall.h"

uint64
sys_exit(void)
{
    800020d4:	1101                	addi	sp,sp,-32
    800020d6:	ec06                	sd	ra,24(sp)
    800020d8:	e822                	sd	s0,16(sp)
    800020da:	1000                	addi	s0,sp,32
  int n;
  if (argint(0, &n) < 0)
    800020dc:	fec40593          	addi	a1,s0,-20
    800020e0:	4501                	li	a0,0
    800020e2:	00000097          	auipc	ra,0x0
    800020e6:	edc080e7          	jalr	-292(ra) # 80001fbe <argint>
    return -1;
    800020ea:	57fd                	li	a5,-1
  if (argint(0, &n) < 0)
    800020ec:	00054963          	bltz	a0,800020fe <sys_exit+0x2a>
  exit(n);
    800020f0:	fec42503          	lw	a0,-20(s0)
    800020f4:	fffff097          	auipc	ra,0xfffff
    800020f8:	6fc080e7          	jalr	1788(ra) # 800017f0 <exit>
  return 0; // not reached
    800020fc:	4781                	li	a5,0
}
    800020fe:	853e                	mv	a0,a5
    80002100:	60e2                	ld	ra,24(sp)
    80002102:	6442                	ld	s0,16(sp)
    80002104:	6105                	addi	sp,sp,32
    80002106:	8082                	ret

0000000080002108 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002108:	1141                	addi	sp,sp,-16
    8000210a:	e406                	sd	ra,8(sp)
    8000210c:	e022                	sd	s0,0(sp)
    8000210e:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002110:	fffff097          	auipc	ra,0xfffff
    80002114:	db6080e7          	jalr	-586(ra) # 80000ec6 <myproc>
}
    80002118:	5908                	lw	a0,48(a0)
    8000211a:	60a2                	ld	ra,8(sp)
    8000211c:	6402                	ld	s0,0(sp)
    8000211e:	0141                	addi	sp,sp,16
    80002120:	8082                	ret

0000000080002122 <sys_fork>:

uint64
sys_fork(void)
{
    80002122:	1141                	addi	sp,sp,-16
    80002124:	e406                	sd	ra,8(sp)
    80002126:	e022                	sd	s0,0(sp)
    80002128:	0800                	addi	s0,sp,16
  return fork();
    8000212a:	fffff097          	auipc	ra,0xfffff
    8000212e:	16e080e7          	jalr	366(ra) # 80001298 <fork>
}
    80002132:	60a2                	ld	ra,8(sp)
    80002134:	6402                	ld	s0,0(sp)
    80002136:	0141                	addi	sp,sp,16
    80002138:	8082                	ret

000000008000213a <sys_wait>:

uint64
sys_wait(void)
{
    8000213a:	1101                	addi	sp,sp,-32
    8000213c:	ec06                	sd	ra,24(sp)
    8000213e:	e822                	sd	s0,16(sp)
    80002140:	1000                	addi	s0,sp,32
  uint64 p;
  if (argaddr(0, &p) < 0)
    80002142:	fe840593          	addi	a1,s0,-24
    80002146:	4501                	li	a0,0
    80002148:	00000097          	auipc	ra,0x0
    8000214c:	e98080e7          	jalr	-360(ra) # 80001fe0 <argaddr>
    80002150:	87aa                	mv	a5,a0
    return -1;
    80002152:	557d                	li	a0,-1
  if (argaddr(0, &p) < 0)
    80002154:	0007c863          	bltz	a5,80002164 <sys_wait+0x2a>
  return wait(p);
    80002158:	fe843503          	ld	a0,-24(s0)
    8000215c:	fffff097          	auipc	ra,0xfffff
    80002160:	49c080e7          	jalr	1180(ra) # 800015f8 <wait>
}
    80002164:	60e2                	ld	ra,24(sp)
    80002166:	6442                	ld	s0,16(sp)
    80002168:	6105                	addi	sp,sp,32
    8000216a:	8082                	ret

000000008000216c <sys_sbrk>:

uint64
sys_sbrk(void)
{
    8000216c:	7179                	addi	sp,sp,-48
    8000216e:	f406                	sd	ra,40(sp)
    80002170:	f022                	sd	s0,32(sp)
    80002172:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if (argint(0, &n) < 0)
    80002174:	fdc40593          	addi	a1,s0,-36
    80002178:	4501                	li	a0,0
    8000217a:	00000097          	auipc	ra,0x0
    8000217e:	e44080e7          	jalr	-444(ra) # 80001fbe <argint>
    80002182:	87aa                	mv	a5,a0
    return -1;
    80002184:	557d                	li	a0,-1
  if (argint(0, &n) < 0)
    80002186:	0207c263          	bltz	a5,800021aa <sys_sbrk+0x3e>
    8000218a:	ec26                	sd	s1,24(sp)
  addr = myproc()->sz;
    8000218c:	fffff097          	auipc	ra,0xfffff
    80002190:	d3a080e7          	jalr	-710(ra) # 80000ec6 <myproc>
    80002194:	4524                	lw	s1,72(a0)
  if (growproc(n) < 0)
    80002196:	fdc42503          	lw	a0,-36(s0)
    8000219a:	fffff097          	auipc	ra,0xfffff
    8000219e:	086080e7          	jalr	134(ra) # 80001220 <growproc>
    800021a2:	00054863          	bltz	a0,800021b2 <sys_sbrk+0x46>
    return -1;
  return addr;
    800021a6:	8526                	mv	a0,s1
    800021a8:	64e2                	ld	s1,24(sp)
}
    800021aa:	70a2                	ld	ra,40(sp)
    800021ac:	7402                	ld	s0,32(sp)
    800021ae:	6145                	addi	sp,sp,48
    800021b0:	8082                	ret
    return -1;
    800021b2:	557d                	li	a0,-1
    800021b4:	64e2                	ld	s1,24(sp)
    800021b6:	bfd5                	j	800021aa <sys_sbrk+0x3e>

00000000800021b8 <sys_sleep>:

uint64
sys_sleep(void)
{
    800021b8:	7139                	addi	sp,sp,-64
    800021ba:	fc06                	sd	ra,56(sp)
    800021bc:	f822                	sd	s0,48(sp)
    800021be:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if (argint(0, &n) < 0)
    800021c0:	fcc40593          	addi	a1,s0,-52
    800021c4:	4501                	li	a0,0
    800021c6:	00000097          	auipc	ra,0x0
    800021ca:	df8080e7          	jalr	-520(ra) # 80001fbe <argint>
    return -1;
    800021ce:	57fd                	li	a5,-1
  if (argint(0, &n) < 0)
    800021d0:	06054b63          	bltz	a0,80002246 <sys_sleep+0x8e>
    800021d4:	f04a                	sd	s2,32(sp)
  acquire(&tickslock);
    800021d6:	0000d517          	auipc	a0,0xd
    800021da:	caa50513          	addi	a0,a0,-854 # 8000ee80 <tickslock>
    800021de:	00004097          	auipc	ra,0x4
    800021e2:	108080e7          	jalr	264(ra) # 800062e6 <acquire>
  ticks0 = ticks;
    800021e6:	00007917          	auipc	s2,0x7
    800021ea:	e3292903          	lw	s2,-462(s2) # 80009018 <ticks>
  while (ticks - ticks0 < n)
    800021ee:	fcc42783          	lw	a5,-52(s0)
    800021f2:	c3a1                	beqz	a5,80002232 <sys_sleep+0x7a>
    800021f4:	f426                	sd	s1,40(sp)
    800021f6:	ec4e                	sd	s3,24(sp)
    if (myproc()->killed)
    {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800021f8:	0000d997          	auipc	s3,0xd
    800021fc:	c8898993          	addi	s3,s3,-888 # 8000ee80 <tickslock>
    80002200:	00007497          	auipc	s1,0x7
    80002204:	e1848493          	addi	s1,s1,-488 # 80009018 <ticks>
    if (myproc()->killed)
    80002208:	fffff097          	auipc	ra,0xfffff
    8000220c:	cbe080e7          	jalr	-834(ra) # 80000ec6 <myproc>
    80002210:	551c                	lw	a5,40(a0)
    80002212:	ef9d                	bnez	a5,80002250 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    80002214:	85ce                	mv	a1,s3
    80002216:	8526                	mv	a0,s1
    80002218:	fffff097          	auipc	ra,0xfffff
    8000221c:	37c080e7          	jalr	892(ra) # 80001594 <sleep>
  while (ticks - ticks0 < n)
    80002220:	409c                	lw	a5,0(s1)
    80002222:	412787bb          	subw	a5,a5,s2
    80002226:	fcc42703          	lw	a4,-52(s0)
    8000222a:	fce7efe3          	bltu	a5,a4,80002208 <sys_sleep+0x50>
    8000222e:	74a2                	ld	s1,40(sp)
    80002230:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80002232:	0000d517          	auipc	a0,0xd
    80002236:	c4e50513          	addi	a0,a0,-946 # 8000ee80 <tickslock>
    8000223a:	00004097          	auipc	ra,0x4
    8000223e:	160080e7          	jalr	352(ra) # 8000639a <release>
  return 0;
    80002242:	4781                	li	a5,0
    80002244:	7902                	ld	s2,32(sp)
}
    80002246:	853e                	mv	a0,a5
    80002248:	70e2                	ld	ra,56(sp)
    8000224a:	7442                	ld	s0,48(sp)
    8000224c:	6121                	addi	sp,sp,64
    8000224e:	8082                	ret
      release(&tickslock);
    80002250:	0000d517          	auipc	a0,0xd
    80002254:	c3050513          	addi	a0,a0,-976 # 8000ee80 <tickslock>
    80002258:	00004097          	auipc	ra,0x4
    8000225c:	142080e7          	jalr	322(ra) # 8000639a <release>
      return -1;
    80002260:	57fd                	li	a5,-1
    80002262:	74a2                	ld	s1,40(sp)
    80002264:	7902                	ld	s2,32(sp)
    80002266:	69e2                	ld	s3,24(sp)
    80002268:	bff9                	j	80002246 <sys_sleep+0x8e>

000000008000226a <sys_kill>:

uint64
sys_kill(void)
{
    8000226a:	1101                	addi	sp,sp,-32
    8000226c:	ec06                	sd	ra,24(sp)
    8000226e:	e822                	sd	s0,16(sp)
    80002270:	1000                	addi	s0,sp,32
  int pid;

  if (argint(0, &pid) < 0)
    80002272:	fec40593          	addi	a1,s0,-20
    80002276:	4501                	li	a0,0
    80002278:	00000097          	auipc	ra,0x0
    8000227c:	d46080e7          	jalr	-698(ra) # 80001fbe <argint>
    80002280:	87aa                	mv	a5,a0
    return -1;
    80002282:	557d                	li	a0,-1
  if (argint(0, &pid) < 0)
    80002284:	0007c863          	bltz	a5,80002294 <sys_kill+0x2a>
  return kill(pid);
    80002288:	fec42503          	lw	a0,-20(s0)
    8000228c:	fffff097          	auipc	ra,0xfffff
    80002290:	63a080e7          	jalr	1594(ra) # 800018c6 <kill>
}
    80002294:	60e2                	ld	ra,24(sp)
    80002296:	6442                	ld	s0,16(sp)
    80002298:	6105                	addi	sp,sp,32
    8000229a:	8082                	ret

000000008000229c <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    8000229c:	1101                	addi	sp,sp,-32
    8000229e:	ec06                	sd	ra,24(sp)
    800022a0:	e822                	sd	s0,16(sp)
    800022a2:	e426                	sd	s1,8(sp)
    800022a4:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800022a6:	0000d517          	auipc	a0,0xd
    800022aa:	bda50513          	addi	a0,a0,-1062 # 8000ee80 <tickslock>
    800022ae:	00004097          	auipc	ra,0x4
    800022b2:	038080e7          	jalr	56(ra) # 800062e6 <acquire>
  xticks = ticks;
    800022b6:	00007497          	auipc	s1,0x7
    800022ba:	d624a483          	lw	s1,-670(s1) # 80009018 <ticks>
  release(&tickslock);
    800022be:	0000d517          	auipc	a0,0xd
    800022c2:	bc250513          	addi	a0,a0,-1086 # 8000ee80 <tickslock>
    800022c6:	00004097          	auipc	ra,0x4
    800022ca:	0d4080e7          	jalr	212(ra) # 8000639a <release>
  return xticks;
}
    800022ce:	02049513          	slli	a0,s1,0x20
    800022d2:	9101                	srli	a0,a0,0x20
    800022d4:	60e2                	ld	ra,24(sp)
    800022d6:	6442                	ld	s0,16(sp)
    800022d8:	64a2                	ld	s1,8(sp)
    800022da:	6105                	addi	sp,sp,32
    800022dc:	8082                	ret

00000000800022de <sys_trace>:

uint64
sys_trace(void)
{
    800022de:	1101                	addi	sp,sp,-32
    800022e0:	ec06                	sd	ra,24(sp)
    800022e2:	e822                	sd	s0,16(sp)
    800022e4:	1000                	addi	s0,sp,32
  int mask;
  if (argint(0, &mask) < 0)
    800022e6:	fec40593          	addi	a1,s0,-20
    800022ea:	4501                	li	a0,0
    800022ec:	00000097          	auipc	ra,0x0
    800022f0:	cd2080e7          	jalr	-814(ra) # 80001fbe <argint>
    return -1;
    800022f4:	57fd                	li	a5,-1
  if (argint(0, &mask) < 0)
    800022f6:	00054a63          	bltz	a0,8000230a <sys_trace+0x2c>
  struct proc *p = myproc();
    800022fa:	fffff097          	auipc	ra,0xfffff
    800022fe:	bcc080e7          	jalr	-1076(ra) # 80000ec6 <myproc>
  p->mask = mask;
    80002302:	fec42783          	lw	a5,-20(s0)
    80002306:	d95c                	sw	a5,52(a0)
  return 0;
    80002308:	4781                	li	a5,0
}
    8000230a:	853e                	mv	a0,a5
    8000230c:	60e2                	ld	ra,24(sp)
    8000230e:	6442                	ld	s0,16(sp)
    80002310:	6105                	addi	sp,sp,32
    80002312:	8082                	ret

0000000080002314 <sys_sysinfo>:

uint64
sys_sysinfo(void)
{
    80002314:	7179                	addi	sp,sp,-48
    80002316:	f406                	sd	ra,40(sp)
    80002318:	f022                	sd	s0,32(sp)
    8000231a:	ec26                	sd	s1,24(sp)
    8000231c:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000231e:	fffff097          	auipc	ra,0xfffff
    80002322:	ba8080e7          	jalr	-1112(ra) # 80000ec6 <myproc>
    80002326:	84aa                	mv	s1,a0
  struct sysinfo info;
  if (argaddr(0, (uint64 *)&info) < 0)
    80002328:	fd040593          	addi	a1,s0,-48
    8000232c:	4501                	li	a0,0
    8000232e:	00000097          	auipc	ra,0x0
    80002332:	cb2080e7          	jalr	-846(ra) # 80001fe0 <argaddr>
    80002336:	87aa                	mv	a5,a0
    return -1;
    80002338:	557d                	li	a0,-1
  if (argaddr(0, (uint64 *)&info) < 0)
    8000233a:	0207c963          	bltz	a5,8000236c <sys_sysinfo+0x58>
  info.freemem = freemem();
    8000233e:	ffffe097          	auipc	ra,0xffffe
    80002342:	e3c080e7          	jalr	-452(ra) # 8000017a <freemem>
    80002346:	fca43823          	sd	a0,-48(s0)
  info.nproc = nproc();
    8000234a:	fffff097          	auipc	ra,0xfffff
    8000234e:	74a080e7          	jalr	1866(ra) # 80001a94 <nproc>
    80002352:	fca43c23          	sd	a0,-40(s0)
  if (copyout(p->pagetable, p->trapframe->a0, (char *)&info, sizeof(info)) < 0)
    80002356:	6cbc                	ld	a5,88(s1)
    80002358:	46c1                	li	a3,16
    8000235a:	fd040613          	addi	a2,s0,-48
    8000235e:	7bac                	ld	a1,112(a5)
    80002360:	68a8                	ld	a0,80(s1)
    80002362:	fffff097          	auipc	ra,0xfffff
    80002366:	800080e7          	jalr	-2048(ra) # 80000b62 <copyout>
    8000236a:	957d                	srai	a0,a0,0x3f
    return -1;
  return 0;
}
    8000236c:	70a2                	ld	ra,40(sp)
    8000236e:	7402                	ld	s0,32(sp)
    80002370:	64e2                	ld	s1,24(sp)
    80002372:	6145                	addi	sp,sp,48
    80002374:	8082                	ret

0000000080002376 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002376:	7179                	addi	sp,sp,-48
    80002378:	f406                	sd	ra,40(sp)
    8000237a:	f022                	sd	s0,32(sp)
    8000237c:	ec26                	sd	s1,24(sp)
    8000237e:	e84a                	sd	s2,16(sp)
    80002380:	e44e                	sd	s3,8(sp)
    80002382:	e052                	sd	s4,0(sp)
    80002384:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002386:	00006597          	auipc	a1,0x6
    8000238a:	0ba58593          	addi	a1,a1,186 # 80008440 <etext+0x440>
    8000238e:	0000d517          	auipc	a0,0xd
    80002392:	b0a50513          	addi	a0,a0,-1270 # 8000ee98 <bcache>
    80002396:	00004097          	auipc	ra,0x4
    8000239a:	ec0080e7          	jalr	-320(ra) # 80006256 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    8000239e:	00015797          	auipc	a5,0x15
    800023a2:	afa78793          	addi	a5,a5,-1286 # 80016e98 <bcache+0x8000>
    800023a6:	00015717          	auipc	a4,0x15
    800023aa:	d5a70713          	addi	a4,a4,-678 # 80017100 <bcache+0x8268>
    800023ae:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800023b2:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800023b6:	0000d497          	auipc	s1,0xd
    800023ba:	afa48493          	addi	s1,s1,-1286 # 8000eeb0 <bcache+0x18>
    b->next = bcache.head.next;
    800023be:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800023c0:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800023c2:	00006a17          	auipc	s4,0x6
    800023c6:	086a0a13          	addi	s4,s4,134 # 80008448 <etext+0x448>
    b->next = bcache.head.next;
    800023ca:	2b893783          	ld	a5,696(s2)
    800023ce:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800023d0:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800023d4:	85d2                	mv	a1,s4
    800023d6:	01048513          	addi	a0,s1,16
    800023da:	00001097          	auipc	ra,0x1
    800023de:	4b2080e7          	jalr	1202(ra) # 8000388c <initsleeplock>
    bcache.head.next->prev = b;
    800023e2:	2b893783          	ld	a5,696(s2)
    800023e6:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800023e8:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800023ec:	45848493          	addi	s1,s1,1112
    800023f0:	fd349de3          	bne	s1,s3,800023ca <binit+0x54>
  }
}
    800023f4:	70a2                	ld	ra,40(sp)
    800023f6:	7402                	ld	s0,32(sp)
    800023f8:	64e2                	ld	s1,24(sp)
    800023fa:	6942                	ld	s2,16(sp)
    800023fc:	69a2                	ld	s3,8(sp)
    800023fe:	6a02                	ld	s4,0(sp)
    80002400:	6145                	addi	sp,sp,48
    80002402:	8082                	ret

0000000080002404 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002404:	7179                	addi	sp,sp,-48
    80002406:	f406                	sd	ra,40(sp)
    80002408:	f022                	sd	s0,32(sp)
    8000240a:	ec26                	sd	s1,24(sp)
    8000240c:	e84a                	sd	s2,16(sp)
    8000240e:	e44e                	sd	s3,8(sp)
    80002410:	1800                	addi	s0,sp,48
    80002412:	892a                	mv	s2,a0
    80002414:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002416:	0000d517          	auipc	a0,0xd
    8000241a:	a8250513          	addi	a0,a0,-1406 # 8000ee98 <bcache>
    8000241e:	00004097          	auipc	ra,0x4
    80002422:	ec8080e7          	jalr	-312(ra) # 800062e6 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002426:	00015497          	auipc	s1,0x15
    8000242a:	d2a4b483          	ld	s1,-726(s1) # 80017150 <bcache+0x82b8>
    8000242e:	00015797          	auipc	a5,0x15
    80002432:	cd278793          	addi	a5,a5,-814 # 80017100 <bcache+0x8268>
    80002436:	02f48f63          	beq	s1,a5,80002474 <bread+0x70>
    8000243a:	873e                	mv	a4,a5
    8000243c:	a021                	j	80002444 <bread+0x40>
    8000243e:	68a4                	ld	s1,80(s1)
    80002440:	02e48a63          	beq	s1,a4,80002474 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002444:	449c                	lw	a5,8(s1)
    80002446:	ff279ce3          	bne	a5,s2,8000243e <bread+0x3a>
    8000244a:	44dc                	lw	a5,12(s1)
    8000244c:	ff3799e3          	bne	a5,s3,8000243e <bread+0x3a>
      b->refcnt++;
    80002450:	40bc                	lw	a5,64(s1)
    80002452:	2785                	addiw	a5,a5,1
    80002454:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002456:	0000d517          	auipc	a0,0xd
    8000245a:	a4250513          	addi	a0,a0,-1470 # 8000ee98 <bcache>
    8000245e:	00004097          	auipc	ra,0x4
    80002462:	f3c080e7          	jalr	-196(ra) # 8000639a <release>
      acquiresleep(&b->lock);
    80002466:	01048513          	addi	a0,s1,16
    8000246a:	00001097          	auipc	ra,0x1
    8000246e:	45c080e7          	jalr	1116(ra) # 800038c6 <acquiresleep>
      return b;
    80002472:	a8b9                	j	800024d0 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002474:	00015497          	auipc	s1,0x15
    80002478:	cd44b483          	ld	s1,-812(s1) # 80017148 <bcache+0x82b0>
    8000247c:	00015797          	auipc	a5,0x15
    80002480:	c8478793          	addi	a5,a5,-892 # 80017100 <bcache+0x8268>
    80002484:	00f48863          	beq	s1,a5,80002494 <bread+0x90>
    80002488:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    8000248a:	40bc                	lw	a5,64(s1)
    8000248c:	cf81                	beqz	a5,800024a4 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000248e:	64a4                	ld	s1,72(s1)
    80002490:	fee49de3          	bne	s1,a4,8000248a <bread+0x86>
  panic("bget: no buffers");
    80002494:	00006517          	auipc	a0,0x6
    80002498:	fbc50513          	addi	a0,a0,-68 # 80008450 <etext+0x450>
    8000249c:	00004097          	auipc	ra,0x4
    800024a0:	8d0080e7          	jalr	-1840(ra) # 80005d6c <panic>
      b->dev = dev;
    800024a4:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800024a8:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800024ac:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800024b0:	4785                	li	a5,1
    800024b2:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800024b4:	0000d517          	auipc	a0,0xd
    800024b8:	9e450513          	addi	a0,a0,-1564 # 8000ee98 <bcache>
    800024bc:	00004097          	auipc	ra,0x4
    800024c0:	ede080e7          	jalr	-290(ra) # 8000639a <release>
      acquiresleep(&b->lock);
    800024c4:	01048513          	addi	a0,s1,16
    800024c8:	00001097          	auipc	ra,0x1
    800024cc:	3fe080e7          	jalr	1022(ra) # 800038c6 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800024d0:	409c                	lw	a5,0(s1)
    800024d2:	cb89                	beqz	a5,800024e4 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800024d4:	8526                	mv	a0,s1
    800024d6:	70a2                	ld	ra,40(sp)
    800024d8:	7402                	ld	s0,32(sp)
    800024da:	64e2                	ld	s1,24(sp)
    800024dc:	6942                	ld	s2,16(sp)
    800024de:	69a2                	ld	s3,8(sp)
    800024e0:	6145                	addi	sp,sp,48
    800024e2:	8082                	ret
    virtio_disk_rw(b, 0);
    800024e4:	4581                	li	a1,0
    800024e6:	8526                	mv	a0,s1
    800024e8:	00003097          	auipc	ra,0x3
    800024ec:	fea080e7          	jalr	-22(ra) # 800054d2 <virtio_disk_rw>
    b->valid = 1;
    800024f0:	4785                	li	a5,1
    800024f2:	c09c                	sw	a5,0(s1)
  return b;
    800024f4:	b7c5                	j	800024d4 <bread+0xd0>

00000000800024f6 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800024f6:	1101                	addi	sp,sp,-32
    800024f8:	ec06                	sd	ra,24(sp)
    800024fa:	e822                	sd	s0,16(sp)
    800024fc:	e426                	sd	s1,8(sp)
    800024fe:	1000                	addi	s0,sp,32
    80002500:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002502:	0541                	addi	a0,a0,16
    80002504:	00001097          	auipc	ra,0x1
    80002508:	45c080e7          	jalr	1116(ra) # 80003960 <holdingsleep>
    8000250c:	cd01                	beqz	a0,80002524 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    8000250e:	4585                	li	a1,1
    80002510:	8526                	mv	a0,s1
    80002512:	00003097          	auipc	ra,0x3
    80002516:	fc0080e7          	jalr	-64(ra) # 800054d2 <virtio_disk_rw>
}
    8000251a:	60e2                	ld	ra,24(sp)
    8000251c:	6442                	ld	s0,16(sp)
    8000251e:	64a2                	ld	s1,8(sp)
    80002520:	6105                	addi	sp,sp,32
    80002522:	8082                	ret
    panic("bwrite");
    80002524:	00006517          	auipc	a0,0x6
    80002528:	f4450513          	addi	a0,a0,-188 # 80008468 <etext+0x468>
    8000252c:	00004097          	auipc	ra,0x4
    80002530:	840080e7          	jalr	-1984(ra) # 80005d6c <panic>

0000000080002534 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002534:	1101                	addi	sp,sp,-32
    80002536:	ec06                	sd	ra,24(sp)
    80002538:	e822                	sd	s0,16(sp)
    8000253a:	e426                	sd	s1,8(sp)
    8000253c:	e04a                	sd	s2,0(sp)
    8000253e:	1000                	addi	s0,sp,32
    80002540:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002542:	01050913          	addi	s2,a0,16
    80002546:	854a                	mv	a0,s2
    80002548:	00001097          	auipc	ra,0x1
    8000254c:	418080e7          	jalr	1048(ra) # 80003960 <holdingsleep>
    80002550:	c925                	beqz	a0,800025c0 <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    80002552:	854a                	mv	a0,s2
    80002554:	00001097          	auipc	ra,0x1
    80002558:	3c8080e7          	jalr	968(ra) # 8000391c <releasesleep>

  acquire(&bcache.lock);
    8000255c:	0000d517          	auipc	a0,0xd
    80002560:	93c50513          	addi	a0,a0,-1732 # 8000ee98 <bcache>
    80002564:	00004097          	auipc	ra,0x4
    80002568:	d82080e7          	jalr	-638(ra) # 800062e6 <acquire>
  b->refcnt--;
    8000256c:	40bc                	lw	a5,64(s1)
    8000256e:	37fd                	addiw	a5,a5,-1
    80002570:	0007871b          	sext.w	a4,a5
    80002574:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002576:	e71d                	bnez	a4,800025a4 <brelse+0x70>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002578:	68b8                	ld	a4,80(s1)
    8000257a:	64bc                	ld	a5,72(s1)
    8000257c:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    8000257e:	68b8                	ld	a4,80(s1)
    80002580:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002582:	00015797          	auipc	a5,0x15
    80002586:	91678793          	addi	a5,a5,-1770 # 80016e98 <bcache+0x8000>
    8000258a:	2b87b703          	ld	a4,696(a5)
    8000258e:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002590:	00015717          	auipc	a4,0x15
    80002594:	b7070713          	addi	a4,a4,-1168 # 80017100 <bcache+0x8268>
    80002598:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000259a:	2b87b703          	ld	a4,696(a5)
    8000259e:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800025a0:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800025a4:	0000d517          	auipc	a0,0xd
    800025a8:	8f450513          	addi	a0,a0,-1804 # 8000ee98 <bcache>
    800025ac:	00004097          	auipc	ra,0x4
    800025b0:	dee080e7          	jalr	-530(ra) # 8000639a <release>
}
    800025b4:	60e2                	ld	ra,24(sp)
    800025b6:	6442                	ld	s0,16(sp)
    800025b8:	64a2                	ld	s1,8(sp)
    800025ba:	6902                	ld	s2,0(sp)
    800025bc:	6105                	addi	sp,sp,32
    800025be:	8082                	ret
    panic("brelse");
    800025c0:	00006517          	auipc	a0,0x6
    800025c4:	eb050513          	addi	a0,a0,-336 # 80008470 <etext+0x470>
    800025c8:	00003097          	auipc	ra,0x3
    800025cc:	7a4080e7          	jalr	1956(ra) # 80005d6c <panic>

00000000800025d0 <bpin>:

void
bpin(struct buf *b) {
    800025d0:	1101                	addi	sp,sp,-32
    800025d2:	ec06                	sd	ra,24(sp)
    800025d4:	e822                	sd	s0,16(sp)
    800025d6:	e426                	sd	s1,8(sp)
    800025d8:	1000                	addi	s0,sp,32
    800025da:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800025dc:	0000d517          	auipc	a0,0xd
    800025e0:	8bc50513          	addi	a0,a0,-1860 # 8000ee98 <bcache>
    800025e4:	00004097          	auipc	ra,0x4
    800025e8:	d02080e7          	jalr	-766(ra) # 800062e6 <acquire>
  b->refcnt++;
    800025ec:	40bc                	lw	a5,64(s1)
    800025ee:	2785                	addiw	a5,a5,1
    800025f0:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800025f2:	0000d517          	auipc	a0,0xd
    800025f6:	8a650513          	addi	a0,a0,-1882 # 8000ee98 <bcache>
    800025fa:	00004097          	auipc	ra,0x4
    800025fe:	da0080e7          	jalr	-608(ra) # 8000639a <release>
}
    80002602:	60e2                	ld	ra,24(sp)
    80002604:	6442                	ld	s0,16(sp)
    80002606:	64a2                	ld	s1,8(sp)
    80002608:	6105                	addi	sp,sp,32
    8000260a:	8082                	ret

000000008000260c <bunpin>:

void
bunpin(struct buf *b) {
    8000260c:	1101                	addi	sp,sp,-32
    8000260e:	ec06                	sd	ra,24(sp)
    80002610:	e822                	sd	s0,16(sp)
    80002612:	e426                	sd	s1,8(sp)
    80002614:	1000                	addi	s0,sp,32
    80002616:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002618:	0000d517          	auipc	a0,0xd
    8000261c:	88050513          	addi	a0,a0,-1920 # 8000ee98 <bcache>
    80002620:	00004097          	auipc	ra,0x4
    80002624:	cc6080e7          	jalr	-826(ra) # 800062e6 <acquire>
  b->refcnt--;
    80002628:	40bc                	lw	a5,64(s1)
    8000262a:	37fd                	addiw	a5,a5,-1
    8000262c:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000262e:	0000d517          	auipc	a0,0xd
    80002632:	86a50513          	addi	a0,a0,-1942 # 8000ee98 <bcache>
    80002636:	00004097          	auipc	ra,0x4
    8000263a:	d64080e7          	jalr	-668(ra) # 8000639a <release>
}
    8000263e:	60e2                	ld	ra,24(sp)
    80002640:	6442                	ld	s0,16(sp)
    80002642:	64a2                	ld	s1,8(sp)
    80002644:	6105                	addi	sp,sp,32
    80002646:	8082                	ret

0000000080002648 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002648:	1101                	addi	sp,sp,-32
    8000264a:	ec06                	sd	ra,24(sp)
    8000264c:	e822                	sd	s0,16(sp)
    8000264e:	e426                	sd	s1,8(sp)
    80002650:	e04a                	sd	s2,0(sp)
    80002652:	1000                	addi	s0,sp,32
    80002654:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002656:	00d5d59b          	srliw	a1,a1,0xd
    8000265a:	00015797          	auipc	a5,0x15
    8000265e:	f1a7a783          	lw	a5,-230(a5) # 80017574 <sb+0x1c>
    80002662:	9dbd                	addw	a1,a1,a5
    80002664:	00000097          	auipc	ra,0x0
    80002668:	da0080e7          	jalr	-608(ra) # 80002404 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000266c:	0074f713          	andi	a4,s1,7
    80002670:	4785                	li	a5,1
    80002672:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002676:	14ce                	slli	s1,s1,0x33
    80002678:	90d9                	srli	s1,s1,0x36
    8000267a:	00950733          	add	a4,a0,s1
    8000267e:	05874703          	lbu	a4,88(a4)
    80002682:	00e7f6b3          	and	a3,a5,a4
    80002686:	c69d                	beqz	a3,800026b4 <bfree+0x6c>
    80002688:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000268a:	94aa                	add	s1,s1,a0
    8000268c:	fff7c793          	not	a5,a5
    80002690:	8f7d                	and	a4,a4,a5
    80002692:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002696:	00001097          	auipc	ra,0x1
    8000269a:	112080e7          	jalr	274(ra) # 800037a8 <log_write>
  brelse(bp);
    8000269e:	854a                	mv	a0,s2
    800026a0:	00000097          	auipc	ra,0x0
    800026a4:	e94080e7          	jalr	-364(ra) # 80002534 <brelse>
}
    800026a8:	60e2                	ld	ra,24(sp)
    800026aa:	6442                	ld	s0,16(sp)
    800026ac:	64a2                	ld	s1,8(sp)
    800026ae:	6902                	ld	s2,0(sp)
    800026b0:	6105                	addi	sp,sp,32
    800026b2:	8082                	ret
    panic("freeing free block");
    800026b4:	00006517          	auipc	a0,0x6
    800026b8:	dc450513          	addi	a0,a0,-572 # 80008478 <etext+0x478>
    800026bc:	00003097          	auipc	ra,0x3
    800026c0:	6b0080e7          	jalr	1712(ra) # 80005d6c <panic>

00000000800026c4 <balloc>:
{
    800026c4:	711d                	addi	sp,sp,-96
    800026c6:	ec86                	sd	ra,88(sp)
    800026c8:	e8a2                	sd	s0,80(sp)
    800026ca:	e4a6                	sd	s1,72(sp)
    800026cc:	e0ca                	sd	s2,64(sp)
    800026ce:	fc4e                	sd	s3,56(sp)
    800026d0:	f852                	sd	s4,48(sp)
    800026d2:	f456                	sd	s5,40(sp)
    800026d4:	f05a                	sd	s6,32(sp)
    800026d6:	ec5e                	sd	s7,24(sp)
    800026d8:	e862                	sd	s8,16(sp)
    800026da:	e466                	sd	s9,8(sp)
    800026dc:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800026de:	00015797          	auipc	a5,0x15
    800026e2:	e7e7a783          	lw	a5,-386(a5) # 8001755c <sb+0x4>
    800026e6:	cbc1                	beqz	a5,80002776 <balloc+0xb2>
    800026e8:	8baa                	mv	s7,a0
    800026ea:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800026ec:	00015b17          	auipc	s6,0x15
    800026f0:	e6cb0b13          	addi	s6,s6,-404 # 80017558 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026f4:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800026f6:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026f8:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800026fa:	6c89                	lui	s9,0x2
    800026fc:	a831                	j	80002718 <balloc+0x54>
    brelse(bp);
    800026fe:	854a                	mv	a0,s2
    80002700:	00000097          	auipc	ra,0x0
    80002704:	e34080e7          	jalr	-460(ra) # 80002534 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002708:	015c87bb          	addw	a5,s9,s5
    8000270c:	00078a9b          	sext.w	s5,a5
    80002710:	004b2703          	lw	a4,4(s6)
    80002714:	06eaf163          	bgeu	s5,a4,80002776 <balloc+0xb2>
    bp = bread(dev, BBLOCK(b, sb));
    80002718:	41fad79b          	sraiw	a5,s5,0x1f
    8000271c:	0137d79b          	srliw	a5,a5,0x13
    80002720:	015787bb          	addw	a5,a5,s5
    80002724:	40d7d79b          	sraiw	a5,a5,0xd
    80002728:	01cb2583          	lw	a1,28(s6)
    8000272c:	9dbd                	addw	a1,a1,a5
    8000272e:	855e                	mv	a0,s7
    80002730:	00000097          	auipc	ra,0x0
    80002734:	cd4080e7          	jalr	-812(ra) # 80002404 <bread>
    80002738:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000273a:	004b2503          	lw	a0,4(s6)
    8000273e:	000a849b          	sext.w	s1,s5
    80002742:	8762                	mv	a4,s8
    80002744:	faa4fde3          	bgeu	s1,a0,800026fe <balloc+0x3a>
      m = 1 << (bi % 8);
    80002748:	00777693          	andi	a3,a4,7
    8000274c:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002750:	41f7579b          	sraiw	a5,a4,0x1f
    80002754:	01d7d79b          	srliw	a5,a5,0x1d
    80002758:	9fb9                	addw	a5,a5,a4
    8000275a:	4037d79b          	sraiw	a5,a5,0x3
    8000275e:	00f90633          	add	a2,s2,a5
    80002762:	05864603          	lbu	a2,88(a2)
    80002766:	00c6f5b3          	and	a1,a3,a2
    8000276a:	cd91                	beqz	a1,80002786 <balloc+0xc2>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000276c:	2705                	addiw	a4,a4,1
    8000276e:	2485                	addiw	s1,s1,1
    80002770:	fd471ae3          	bne	a4,s4,80002744 <balloc+0x80>
    80002774:	b769                	j	800026fe <balloc+0x3a>
  panic("balloc: out of blocks");
    80002776:	00006517          	auipc	a0,0x6
    8000277a:	d1a50513          	addi	a0,a0,-742 # 80008490 <etext+0x490>
    8000277e:	00003097          	auipc	ra,0x3
    80002782:	5ee080e7          	jalr	1518(ra) # 80005d6c <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002786:	97ca                	add	a5,a5,s2
    80002788:	8e55                	or	a2,a2,a3
    8000278a:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    8000278e:	854a                	mv	a0,s2
    80002790:	00001097          	auipc	ra,0x1
    80002794:	018080e7          	jalr	24(ra) # 800037a8 <log_write>
        brelse(bp);
    80002798:	854a                	mv	a0,s2
    8000279a:	00000097          	auipc	ra,0x0
    8000279e:	d9a080e7          	jalr	-614(ra) # 80002534 <brelse>
  bp = bread(dev, bno);
    800027a2:	85a6                	mv	a1,s1
    800027a4:	855e                	mv	a0,s7
    800027a6:	00000097          	auipc	ra,0x0
    800027aa:	c5e080e7          	jalr	-930(ra) # 80002404 <bread>
    800027ae:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800027b0:	40000613          	li	a2,1024
    800027b4:	4581                	li	a1,0
    800027b6:	05850513          	addi	a0,a0,88
    800027ba:	ffffe097          	auipc	ra,0xffffe
    800027be:	a0a080e7          	jalr	-1526(ra) # 800001c4 <memset>
  log_write(bp);
    800027c2:	854a                	mv	a0,s2
    800027c4:	00001097          	auipc	ra,0x1
    800027c8:	fe4080e7          	jalr	-28(ra) # 800037a8 <log_write>
  brelse(bp);
    800027cc:	854a                	mv	a0,s2
    800027ce:	00000097          	auipc	ra,0x0
    800027d2:	d66080e7          	jalr	-666(ra) # 80002534 <brelse>
}
    800027d6:	8526                	mv	a0,s1
    800027d8:	60e6                	ld	ra,88(sp)
    800027da:	6446                	ld	s0,80(sp)
    800027dc:	64a6                	ld	s1,72(sp)
    800027de:	6906                	ld	s2,64(sp)
    800027e0:	79e2                	ld	s3,56(sp)
    800027e2:	7a42                	ld	s4,48(sp)
    800027e4:	7aa2                	ld	s5,40(sp)
    800027e6:	7b02                	ld	s6,32(sp)
    800027e8:	6be2                	ld	s7,24(sp)
    800027ea:	6c42                	ld	s8,16(sp)
    800027ec:	6ca2                	ld	s9,8(sp)
    800027ee:	6125                	addi	sp,sp,96
    800027f0:	8082                	ret

00000000800027f2 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    800027f2:	7179                	addi	sp,sp,-48
    800027f4:	f406                	sd	ra,40(sp)
    800027f6:	f022                	sd	s0,32(sp)
    800027f8:	ec26                	sd	s1,24(sp)
    800027fa:	e84a                	sd	s2,16(sp)
    800027fc:	e44e                	sd	s3,8(sp)
    800027fe:	1800                	addi	s0,sp,48
    80002800:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002802:	47ad                	li	a5,11
    80002804:	04b7ff63          	bgeu	a5,a1,80002862 <bmap+0x70>
    80002808:	e052                	sd	s4,0(sp)
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    8000280a:	ff45849b          	addiw	s1,a1,-12
    8000280e:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002812:	0ff00793          	li	a5,255
    80002816:	0ae7e463          	bltu	a5,a4,800028be <bmap+0xcc>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    8000281a:	08052583          	lw	a1,128(a0)
    8000281e:	c5b5                	beqz	a1,8000288a <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80002820:	00092503          	lw	a0,0(s2)
    80002824:	00000097          	auipc	ra,0x0
    80002828:	be0080e7          	jalr	-1056(ra) # 80002404 <bread>
    8000282c:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000282e:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002832:	02049713          	slli	a4,s1,0x20
    80002836:	01e75593          	srli	a1,a4,0x1e
    8000283a:	00b784b3          	add	s1,a5,a1
    8000283e:	0004a983          	lw	s3,0(s1)
    80002842:	04098e63          	beqz	s3,8000289e <bmap+0xac>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80002846:	8552                	mv	a0,s4
    80002848:	00000097          	auipc	ra,0x0
    8000284c:	cec080e7          	jalr	-788(ra) # 80002534 <brelse>
    return addr;
    80002850:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80002852:	854e                	mv	a0,s3
    80002854:	70a2                	ld	ra,40(sp)
    80002856:	7402                	ld	s0,32(sp)
    80002858:	64e2                	ld	s1,24(sp)
    8000285a:	6942                	ld	s2,16(sp)
    8000285c:	69a2                	ld	s3,8(sp)
    8000285e:	6145                	addi	sp,sp,48
    80002860:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80002862:	02059793          	slli	a5,a1,0x20
    80002866:	01e7d593          	srli	a1,a5,0x1e
    8000286a:	00b504b3          	add	s1,a0,a1
    8000286e:	0504a983          	lw	s3,80(s1)
    80002872:	fe0990e3          	bnez	s3,80002852 <bmap+0x60>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80002876:	4108                	lw	a0,0(a0)
    80002878:	00000097          	auipc	ra,0x0
    8000287c:	e4c080e7          	jalr	-436(ra) # 800026c4 <balloc>
    80002880:	0005099b          	sext.w	s3,a0
    80002884:	0534a823          	sw	s3,80(s1)
    80002888:	b7e9                	j	80002852 <bmap+0x60>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    8000288a:	4108                	lw	a0,0(a0)
    8000288c:	00000097          	auipc	ra,0x0
    80002890:	e38080e7          	jalr	-456(ra) # 800026c4 <balloc>
    80002894:	0005059b          	sext.w	a1,a0
    80002898:	08b92023          	sw	a1,128(s2)
    8000289c:	b751                	j	80002820 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    8000289e:	00092503          	lw	a0,0(s2)
    800028a2:	00000097          	auipc	ra,0x0
    800028a6:	e22080e7          	jalr	-478(ra) # 800026c4 <balloc>
    800028aa:	0005099b          	sext.w	s3,a0
    800028ae:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    800028b2:	8552                	mv	a0,s4
    800028b4:	00001097          	auipc	ra,0x1
    800028b8:	ef4080e7          	jalr	-268(ra) # 800037a8 <log_write>
    800028bc:	b769                	j	80002846 <bmap+0x54>
  panic("bmap: out of range");
    800028be:	00006517          	auipc	a0,0x6
    800028c2:	bea50513          	addi	a0,a0,-1046 # 800084a8 <etext+0x4a8>
    800028c6:	00003097          	auipc	ra,0x3
    800028ca:	4a6080e7          	jalr	1190(ra) # 80005d6c <panic>

00000000800028ce <iget>:
{
    800028ce:	7179                	addi	sp,sp,-48
    800028d0:	f406                	sd	ra,40(sp)
    800028d2:	f022                	sd	s0,32(sp)
    800028d4:	ec26                	sd	s1,24(sp)
    800028d6:	e84a                	sd	s2,16(sp)
    800028d8:	e44e                	sd	s3,8(sp)
    800028da:	e052                	sd	s4,0(sp)
    800028dc:	1800                	addi	s0,sp,48
    800028de:	89aa                	mv	s3,a0
    800028e0:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800028e2:	00015517          	auipc	a0,0x15
    800028e6:	c9650513          	addi	a0,a0,-874 # 80017578 <itable>
    800028ea:	00004097          	auipc	ra,0x4
    800028ee:	9fc080e7          	jalr	-1540(ra) # 800062e6 <acquire>
  empty = 0;
    800028f2:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800028f4:	00015497          	auipc	s1,0x15
    800028f8:	c9c48493          	addi	s1,s1,-868 # 80017590 <itable+0x18>
    800028fc:	00016697          	auipc	a3,0x16
    80002900:	72468693          	addi	a3,a3,1828 # 80019020 <log>
    80002904:	a039                	j	80002912 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002906:	02090b63          	beqz	s2,8000293c <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000290a:	08848493          	addi	s1,s1,136
    8000290e:	02d48a63          	beq	s1,a3,80002942 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002912:	449c                	lw	a5,8(s1)
    80002914:	fef059e3          	blez	a5,80002906 <iget+0x38>
    80002918:	4098                	lw	a4,0(s1)
    8000291a:	ff3716e3          	bne	a4,s3,80002906 <iget+0x38>
    8000291e:	40d8                	lw	a4,4(s1)
    80002920:	ff4713e3          	bne	a4,s4,80002906 <iget+0x38>
      ip->ref++;
    80002924:	2785                	addiw	a5,a5,1
    80002926:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002928:	00015517          	auipc	a0,0x15
    8000292c:	c5050513          	addi	a0,a0,-944 # 80017578 <itable>
    80002930:	00004097          	auipc	ra,0x4
    80002934:	a6a080e7          	jalr	-1430(ra) # 8000639a <release>
      return ip;
    80002938:	8926                	mv	s2,s1
    8000293a:	a03d                	j	80002968 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000293c:	f7f9                	bnez	a5,8000290a <iget+0x3c>
      empty = ip;
    8000293e:	8926                	mv	s2,s1
    80002940:	b7e9                	j	8000290a <iget+0x3c>
  if(empty == 0)
    80002942:	02090c63          	beqz	s2,8000297a <iget+0xac>
  ip->dev = dev;
    80002946:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    8000294a:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    8000294e:	4785                	li	a5,1
    80002950:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002954:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002958:	00015517          	auipc	a0,0x15
    8000295c:	c2050513          	addi	a0,a0,-992 # 80017578 <itable>
    80002960:	00004097          	auipc	ra,0x4
    80002964:	a3a080e7          	jalr	-1478(ra) # 8000639a <release>
}
    80002968:	854a                	mv	a0,s2
    8000296a:	70a2                	ld	ra,40(sp)
    8000296c:	7402                	ld	s0,32(sp)
    8000296e:	64e2                	ld	s1,24(sp)
    80002970:	6942                	ld	s2,16(sp)
    80002972:	69a2                	ld	s3,8(sp)
    80002974:	6a02                	ld	s4,0(sp)
    80002976:	6145                	addi	sp,sp,48
    80002978:	8082                	ret
    panic("iget: no inodes");
    8000297a:	00006517          	auipc	a0,0x6
    8000297e:	b4650513          	addi	a0,a0,-1210 # 800084c0 <etext+0x4c0>
    80002982:	00003097          	auipc	ra,0x3
    80002986:	3ea080e7          	jalr	1002(ra) # 80005d6c <panic>

000000008000298a <fsinit>:
fsinit(int dev) {
    8000298a:	7179                	addi	sp,sp,-48
    8000298c:	f406                	sd	ra,40(sp)
    8000298e:	f022                	sd	s0,32(sp)
    80002990:	ec26                	sd	s1,24(sp)
    80002992:	e84a                	sd	s2,16(sp)
    80002994:	e44e                	sd	s3,8(sp)
    80002996:	1800                	addi	s0,sp,48
    80002998:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    8000299a:	4585                	li	a1,1
    8000299c:	00000097          	auipc	ra,0x0
    800029a0:	a68080e7          	jalr	-1432(ra) # 80002404 <bread>
    800029a4:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800029a6:	00015997          	auipc	s3,0x15
    800029aa:	bb298993          	addi	s3,s3,-1102 # 80017558 <sb>
    800029ae:	02000613          	li	a2,32
    800029b2:	05850593          	addi	a1,a0,88
    800029b6:	854e                	mv	a0,s3
    800029b8:	ffffe097          	auipc	ra,0xffffe
    800029bc:	868080e7          	jalr	-1944(ra) # 80000220 <memmove>
  brelse(bp);
    800029c0:	8526                	mv	a0,s1
    800029c2:	00000097          	auipc	ra,0x0
    800029c6:	b72080e7          	jalr	-1166(ra) # 80002534 <brelse>
  if(sb.magic != FSMAGIC)
    800029ca:	0009a703          	lw	a4,0(s3)
    800029ce:	102037b7          	lui	a5,0x10203
    800029d2:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800029d6:	02f71263          	bne	a4,a5,800029fa <fsinit+0x70>
  initlog(dev, &sb);
    800029da:	00015597          	auipc	a1,0x15
    800029de:	b7e58593          	addi	a1,a1,-1154 # 80017558 <sb>
    800029e2:	854a                	mv	a0,s2
    800029e4:	00001097          	auipc	ra,0x1
    800029e8:	b54080e7          	jalr	-1196(ra) # 80003538 <initlog>
}
    800029ec:	70a2                	ld	ra,40(sp)
    800029ee:	7402                	ld	s0,32(sp)
    800029f0:	64e2                	ld	s1,24(sp)
    800029f2:	6942                	ld	s2,16(sp)
    800029f4:	69a2                	ld	s3,8(sp)
    800029f6:	6145                	addi	sp,sp,48
    800029f8:	8082                	ret
    panic("invalid file system");
    800029fa:	00006517          	auipc	a0,0x6
    800029fe:	ad650513          	addi	a0,a0,-1322 # 800084d0 <etext+0x4d0>
    80002a02:	00003097          	auipc	ra,0x3
    80002a06:	36a080e7          	jalr	874(ra) # 80005d6c <panic>

0000000080002a0a <iinit>:
{
    80002a0a:	7179                	addi	sp,sp,-48
    80002a0c:	f406                	sd	ra,40(sp)
    80002a0e:	f022                	sd	s0,32(sp)
    80002a10:	ec26                	sd	s1,24(sp)
    80002a12:	e84a                	sd	s2,16(sp)
    80002a14:	e44e                	sd	s3,8(sp)
    80002a16:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002a18:	00006597          	auipc	a1,0x6
    80002a1c:	ad058593          	addi	a1,a1,-1328 # 800084e8 <etext+0x4e8>
    80002a20:	00015517          	auipc	a0,0x15
    80002a24:	b5850513          	addi	a0,a0,-1192 # 80017578 <itable>
    80002a28:	00004097          	auipc	ra,0x4
    80002a2c:	82e080e7          	jalr	-2002(ra) # 80006256 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002a30:	00015497          	auipc	s1,0x15
    80002a34:	b7048493          	addi	s1,s1,-1168 # 800175a0 <itable+0x28>
    80002a38:	00016997          	auipc	s3,0x16
    80002a3c:	5f898993          	addi	s3,s3,1528 # 80019030 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002a40:	00006917          	auipc	s2,0x6
    80002a44:	ab090913          	addi	s2,s2,-1360 # 800084f0 <etext+0x4f0>
    80002a48:	85ca                	mv	a1,s2
    80002a4a:	8526                	mv	a0,s1
    80002a4c:	00001097          	auipc	ra,0x1
    80002a50:	e40080e7          	jalr	-448(ra) # 8000388c <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002a54:	08848493          	addi	s1,s1,136
    80002a58:	ff3498e3          	bne	s1,s3,80002a48 <iinit+0x3e>
}
    80002a5c:	70a2                	ld	ra,40(sp)
    80002a5e:	7402                	ld	s0,32(sp)
    80002a60:	64e2                	ld	s1,24(sp)
    80002a62:	6942                	ld	s2,16(sp)
    80002a64:	69a2                	ld	s3,8(sp)
    80002a66:	6145                	addi	sp,sp,48
    80002a68:	8082                	ret

0000000080002a6a <ialloc>:
{
    80002a6a:	7139                	addi	sp,sp,-64
    80002a6c:	fc06                	sd	ra,56(sp)
    80002a6e:	f822                	sd	s0,48(sp)
    80002a70:	f426                	sd	s1,40(sp)
    80002a72:	f04a                	sd	s2,32(sp)
    80002a74:	ec4e                	sd	s3,24(sp)
    80002a76:	e852                	sd	s4,16(sp)
    80002a78:	e456                	sd	s5,8(sp)
    80002a7a:	e05a                	sd	s6,0(sp)
    80002a7c:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a7e:	00015717          	auipc	a4,0x15
    80002a82:	ae672703          	lw	a4,-1306(a4) # 80017564 <sb+0xc>
    80002a86:	4785                	li	a5,1
    80002a88:	04e7f863          	bgeu	a5,a4,80002ad8 <ialloc+0x6e>
    80002a8c:	8aaa                	mv	s5,a0
    80002a8e:	8b2e                	mv	s6,a1
    80002a90:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002a92:	00015a17          	auipc	s4,0x15
    80002a96:	ac6a0a13          	addi	s4,s4,-1338 # 80017558 <sb>
    80002a9a:	00495593          	srli	a1,s2,0x4
    80002a9e:	018a2783          	lw	a5,24(s4)
    80002aa2:	9dbd                	addw	a1,a1,a5
    80002aa4:	8556                	mv	a0,s5
    80002aa6:	00000097          	auipc	ra,0x0
    80002aaa:	95e080e7          	jalr	-1698(ra) # 80002404 <bread>
    80002aae:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002ab0:	05850993          	addi	s3,a0,88
    80002ab4:	00f97793          	andi	a5,s2,15
    80002ab8:	079a                	slli	a5,a5,0x6
    80002aba:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002abc:	00099783          	lh	a5,0(s3)
    80002ac0:	c785                	beqz	a5,80002ae8 <ialloc+0x7e>
    brelse(bp);
    80002ac2:	00000097          	auipc	ra,0x0
    80002ac6:	a72080e7          	jalr	-1422(ra) # 80002534 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002aca:	0905                	addi	s2,s2,1
    80002acc:	00ca2703          	lw	a4,12(s4)
    80002ad0:	0009079b          	sext.w	a5,s2
    80002ad4:	fce7e3e3          	bltu	a5,a4,80002a9a <ialloc+0x30>
  panic("ialloc: no inodes");
    80002ad8:	00006517          	auipc	a0,0x6
    80002adc:	a2050513          	addi	a0,a0,-1504 # 800084f8 <etext+0x4f8>
    80002ae0:	00003097          	auipc	ra,0x3
    80002ae4:	28c080e7          	jalr	652(ra) # 80005d6c <panic>
      memset(dip, 0, sizeof(*dip));
    80002ae8:	04000613          	li	a2,64
    80002aec:	4581                	li	a1,0
    80002aee:	854e                	mv	a0,s3
    80002af0:	ffffd097          	auipc	ra,0xffffd
    80002af4:	6d4080e7          	jalr	1748(ra) # 800001c4 <memset>
      dip->type = type;
    80002af8:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002afc:	8526                	mv	a0,s1
    80002afe:	00001097          	auipc	ra,0x1
    80002b02:	caa080e7          	jalr	-854(ra) # 800037a8 <log_write>
      brelse(bp);
    80002b06:	8526                	mv	a0,s1
    80002b08:	00000097          	auipc	ra,0x0
    80002b0c:	a2c080e7          	jalr	-1492(ra) # 80002534 <brelse>
      return iget(dev, inum);
    80002b10:	0009059b          	sext.w	a1,s2
    80002b14:	8556                	mv	a0,s5
    80002b16:	00000097          	auipc	ra,0x0
    80002b1a:	db8080e7          	jalr	-584(ra) # 800028ce <iget>
}
    80002b1e:	70e2                	ld	ra,56(sp)
    80002b20:	7442                	ld	s0,48(sp)
    80002b22:	74a2                	ld	s1,40(sp)
    80002b24:	7902                	ld	s2,32(sp)
    80002b26:	69e2                	ld	s3,24(sp)
    80002b28:	6a42                	ld	s4,16(sp)
    80002b2a:	6aa2                	ld	s5,8(sp)
    80002b2c:	6b02                	ld	s6,0(sp)
    80002b2e:	6121                	addi	sp,sp,64
    80002b30:	8082                	ret

0000000080002b32 <iupdate>:
{
    80002b32:	1101                	addi	sp,sp,-32
    80002b34:	ec06                	sd	ra,24(sp)
    80002b36:	e822                	sd	s0,16(sp)
    80002b38:	e426                	sd	s1,8(sp)
    80002b3a:	e04a                	sd	s2,0(sp)
    80002b3c:	1000                	addi	s0,sp,32
    80002b3e:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b40:	415c                	lw	a5,4(a0)
    80002b42:	0047d79b          	srliw	a5,a5,0x4
    80002b46:	00015597          	auipc	a1,0x15
    80002b4a:	a2a5a583          	lw	a1,-1494(a1) # 80017570 <sb+0x18>
    80002b4e:	9dbd                	addw	a1,a1,a5
    80002b50:	4108                	lw	a0,0(a0)
    80002b52:	00000097          	auipc	ra,0x0
    80002b56:	8b2080e7          	jalr	-1870(ra) # 80002404 <bread>
    80002b5a:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b5c:	05850793          	addi	a5,a0,88
    80002b60:	40d8                	lw	a4,4(s1)
    80002b62:	8b3d                	andi	a4,a4,15
    80002b64:	071a                	slli	a4,a4,0x6
    80002b66:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002b68:	04449703          	lh	a4,68(s1)
    80002b6c:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002b70:	04649703          	lh	a4,70(s1)
    80002b74:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002b78:	04849703          	lh	a4,72(s1)
    80002b7c:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002b80:	04a49703          	lh	a4,74(s1)
    80002b84:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002b88:	44f8                	lw	a4,76(s1)
    80002b8a:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002b8c:	03400613          	li	a2,52
    80002b90:	05048593          	addi	a1,s1,80
    80002b94:	00c78513          	addi	a0,a5,12
    80002b98:	ffffd097          	auipc	ra,0xffffd
    80002b9c:	688080e7          	jalr	1672(ra) # 80000220 <memmove>
  log_write(bp);
    80002ba0:	854a                	mv	a0,s2
    80002ba2:	00001097          	auipc	ra,0x1
    80002ba6:	c06080e7          	jalr	-1018(ra) # 800037a8 <log_write>
  brelse(bp);
    80002baa:	854a                	mv	a0,s2
    80002bac:	00000097          	auipc	ra,0x0
    80002bb0:	988080e7          	jalr	-1656(ra) # 80002534 <brelse>
}
    80002bb4:	60e2                	ld	ra,24(sp)
    80002bb6:	6442                	ld	s0,16(sp)
    80002bb8:	64a2                	ld	s1,8(sp)
    80002bba:	6902                	ld	s2,0(sp)
    80002bbc:	6105                	addi	sp,sp,32
    80002bbe:	8082                	ret

0000000080002bc0 <idup>:
{
    80002bc0:	1101                	addi	sp,sp,-32
    80002bc2:	ec06                	sd	ra,24(sp)
    80002bc4:	e822                	sd	s0,16(sp)
    80002bc6:	e426                	sd	s1,8(sp)
    80002bc8:	1000                	addi	s0,sp,32
    80002bca:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002bcc:	00015517          	auipc	a0,0x15
    80002bd0:	9ac50513          	addi	a0,a0,-1620 # 80017578 <itable>
    80002bd4:	00003097          	auipc	ra,0x3
    80002bd8:	712080e7          	jalr	1810(ra) # 800062e6 <acquire>
  ip->ref++;
    80002bdc:	449c                	lw	a5,8(s1)
    80002bde:	2785                	addiw	a5,a5,1
    80002be0:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002be2:	00015517          	auipc	a0,0x15
    80002be6:	99650513          	addi	a0,a0,-1642 # 80017578 <itable>
    80002bea:	00003097          	auipc	ra,0x3
    80002bee:	7b0080e7          	jalr	1968(ra) # 8000639a <release>
}
    80002bf2:	8526                	mv	a0,s1
    80002bf4:	60e2                	ld	ra,24(sp)
    80002bf6:	6442                	ld	s0,16(sp)
    80002bf8:	64a2                	ld	s1,8(sp)
    80002bfa:	6105                	addi	sp,sp,32
    80002bfc:	8082                	ret

0000000080002bfe <ilock>:
{
    80002bfe:	1101                	addi	sp,sp,-32
    80002c00:	ec06                	sd	ra,24(sp)
    80002c02:	e822                	sd	s0,16(sp)
    80002c04:	e426                	sd	s1,8(sp)
    80002c06:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002c08:	c10d                	beqz	a0,80002c2a <ilock+0x2c>
    80002c0a:	84aa                	mv	s1,a0
    80002c0c:	451c                	lw	a5,8(a0)
    80002c0e:	00f05e63          	blez	a5,80002c2a <ilock+0x2c>
  acquiresleep(&ip->lock);
    80002c12:	0541                	addi	a0,a0,16
    80002c14:	00001097          	auipc	ra,0x1
    80002c18:	cb2080e7          	jalr	-846(ra) # 800038c6 <acquiresleep>
  if(ip->valid == 0){
    80002c1c:	40bc                	lw	a5,64(s1)
    80002c1e:	cf99                	beqz	a5,80002c3c <ilock+0x3e>
}
    80002c20:	60e2                	ld	ra,24(sp)
    80002c22:	6442                	ld	s0,16(sp)
    80002c24:	64a2                	ld	s1,8(sp)
    80002c26:	6105                	addi	sp,sp,32
    80002c28:	8082                	ret
    80002c2a:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80002c2c:	00006517          	auipc	a0,0x6
    80002c30:	8e450513          	addi	a0,a0,-1820 # 80008510 <etext+0x510>
    80002c34:	00003097          	auipc	ra,0x3
    80002c38:	138080e7          	jalr	312(ra) # 80005d6c <panic>
    80002c3c:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c3e:	40dc                	lw	a5,4(s1)
    80002c40:	0047d79b          	srliw	a5,a5,0x4
    80002c44:	00015597          	auipc	a1,0x15
    80002c48:	92c5a583          	lw	a1,-1748(a1) # 80017570 <sb+0x18>
    80002c4c:	9dbd                	addw	a1,a1,a5
    80002c4e:	4088                	lw	a0,0(s1)
    80002c50:	fffff097          	auipc	ra,0xfffff
    80002c54:	7b4080e7          	jalr	1972(ra) # 80002404 <bread>
    80002c58:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c5a:	05850593          	addi	a1,a0,88
    80002c5e:	40dc                	lw	a5,4(s1)
    80002c60:	8bbd                	andi	a5,a5,15
    80002c62:	079a                	slli	a5,a5,0x6
    80002c64:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002c66:	00059783          	lh	a5,0(a1)
    80002c6a:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002c6e:	00259783          	lh	a5,2(a1)
    80002c72:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002c76:	00459783          	lh	a5,4(a1)
    80002c7a:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002c7e:	00659783          	lh	a5,6(a1)
    80002c82:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002c86:	459c                	lw	a5,8(a1)
    80002c88:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002c8a:	03400613          	li	a2,52
    80002c8e:	05b1                	addi	a1,a1,12
    80002c90:	05048513          	addi	a0,s1,80
    80002c94:	ffffd097          	auipc	ra,0xffffd
    80002c98:	58c080e7          	jalr	1420(ra) # 80000220 <memmove>
    brelse(bp);
    80002c9c:	854a                	mv	a0,s2
    80002c9e:	00000097          	auipc	ra,0x0
    80002ca2:	896080e7          	jalr	-1898(ra) # 80002534 <brelse>
    ip->valid = 1;
    80002ca6:	4785                	li	a5,1
    80002ca8:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002caa:	04449783          	lh	a5,68(s1)
    80002cae:	c399                	beqz	a5,80002cb4 <ilock+0xb6>
    80002cb0:	6902                	ld	s2,0(sp)
    80002cb2:	b7bd                	j	80002c20 <ilock+0x22>
      panic("ilock: no type");
    80002cb4:	00006517          	auipc	a0,0x6
    80002cb8:	86450513          	addi	a0,a0,-1948 # 80008518 <etext+0x518>
    80002cbc:	00003097          	auipc	ra,0x3
    80002cc0:	0b0080e7          	jalr	176(ra) # 80005d6c <panic>

0000000080002cc4 <iunlock>:
{
    80002cc4:	1101                	addi	sp,sp,-32
    80002cc6:	ec06                	sd	ra,24(sp)
    80002cc8:	e822                	sd	s0,16(sp)
    80002cca:	e426                	sd	s1,8(sp)
    80002ccc:	e04a                	sd	s2,0(sp)
    80002cce:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002cd0:	c905                	beqz	a0,80002d00 <iunlock+0x3c>
    80002cd2:	84aa                	mv	s1,a0
    80002cd4:	01050913          	addi	s2,a0,16
    80002cd8:	854a                	mv	a0,s2
    80002cda:	00001097          	auipc	ra,0x1
    80002cde:	c86080e7          	jalr	-890(ra) # 80003960 <holdingsleep>
    80002ce2:	cd19                	beqz	a0,80002d00 <iunlock+0x3c>
    80002ce4:	449c                	lw	a5,8(s1)
    80002ce6:	00f05d63          	blez	a5,80002d00 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002cea:	854a                	mv	a0,s2
    80002cec:	00001097          	auipc	ra,0x1
    80002cf0:	c30080e7          	jalr	-976(ra) # 8000391c <releasesleep>
}
    80002cf4:	60e2                	ld	ra,24(sp)
    80002cf6:	6442                	ld	s0,16(sp)
    80002cf8:	64a2                	ld	s1,8(sp)
    80002cfa:	6902                	ld	s2,0(sp)
    80002cfc:	6105                	addi	sp,sp,32
    80002cfe:	8082                	ret
    panic("iunlock");
    80002d00:	00006517          	auipc	a0,0x6
    80002d04:	82850513          	addi	a0,a0,-2008 # 80008528 <etext+0x528>
    80002d08:	00003097          	auipc	ra,0x3
    80002d0c:	064080e7          	jalr	100(ra) # 80005d6c <panic>

0000000080002d10 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002d10:	7179                	addi	sp,sp,-48
    80002d12:	f406                	sd	ra,40(sp)
    80002d14:	f022                	sd	s0,32(sp)
    80002d16:	ec26                	sd	s1,24(sp)
    80002d18:	e84a                	sd	s2,16(sp)
    80002d1a:	e44e                	sd	s3,8(sp)
    80002d1c:	1800                	addi	s0,sp,48
    80002d1e:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002d20:	05050493          	addi	s1,a0,80
    80002d24:	08050913          	addi	s2,a0,128
    80002d28:	a021                	j	80002d30 <itrunc+0x20>
    80002d2a:	0491                	addi	s1,s1,4
    80002d2c:	01248d63          	beq	s1,s2,80002d46 <itrunc+0x36>
    if(ip->addrs[i]){
    80002d30:	408c                	lw	a1,0(s1)
    80002d32:	dde5                	beqz	a1,80002d2a <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80002d34:	0009a503          	lw	a0,0(s3)
    80002d38:	00000097          	auipc	ra,0x0
    80002d3c:	910080e7          	jalr	-1776(ra) # 80002648 <bfree>
      ip->addrs[i] = 0;
    80002d40:	0004a023          	sw	zero,0(s1)
    80002d44:	b7dd                	j	80002d2a <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002d46:	0809a583          	lw	a1,128(s3)
    80002d4a:	ed99                	bnez	a1,80002d68 <itrunc+0x58>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002d4c:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002d50:	854e                	mv	a0,s3
    80002d52:	00000097          	auipc	ra,0x0
    80002d56:	de0080e7          	jalr	-544(ra) # 80002b32 <iupdate>
}
    80002d5a:	70a2                	ld	ra,40(sp)
    80002d5c:	7402                	ld	s0,32(sp)
    80002d5e:	64e2                	ld	s1,24(sp)
    80002d60:	6942                	ld	s2,16(sp)
    80002d62:	69a2                	ld	s3,8(sp)
    80002d64:	6145                	addi	sp,sp,48
    80002d66:	8082                	ret
    80002d68:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002d6a:	0009a503          	lw	a0,0(s3)
    80002d6e:	fffff097          	auipc	ra,0xfffff
    80002d72:	696080e7          	jalr	1686(ra) # 80002404 <bread>
    80002d76:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002d78:	05850493          	addi	s1,a0,88
    80002d7c:	45850913          	addi	s2,a0,1112
    80002d80:	a021                	j	80002d88 <itrunc+0x78>
    80002d82:	0491                	addi	s1,s1,4
    80002d84:	01248b63          	beq	s1,s2,80002d9a <itrunc+0x8a>
      if(a[j])
    80002d88:	408c                	lw	a1,0(s1)
    80002d8a:	dde5                	beqz	a1,80002d82 <itrunc+0x72>
        bfree(ip->dev, a[j]);
    80002d8c:	0009a503          	lw	a0,0(s3)
    80002d90:	00000097          	auipc	ra,0x0
    80002d94:	8b8080e7          	jalr	-1864(ra) # 80002648 <bfree>
    80002d98:	b7ed                	j	80002d82 <itrunc+0x72>
    brelse(bp);
    80002d9a:	8552                	mv	a0,s4
    80002d9c:	fffff097          	auipc	ra,0xfffff
    80002da0:	798080e7          	jalr	1944(ra) # 80002534 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002da4:	0809a583          	lw	a1,128(s3)
    80002da8:	0009a503          	lw	a0,0(s3)
    80002dac:	00000097          	auipc	ra,0x0
    80002db0:	89c080e7          	jalr	-1892(ra) # 80002648 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002db4:	0809a023          	sw	zero,128(s3)
    80002db8:	6a02                	ld	s4,0(sp)
    80002dba:	bf49                	j	80002d4c <itrunc+0x3c>

0000000080002dbc <iput>:
{
    80002dbc:	1101                	addi	sp,sp,-32
    80002dbe:	ec06                	sd	ra,24(sp)
    80002dc0:	e822                	sd	s0,16(sp)
    80002dc2:	e426                	sd	s1,8(sp)
    80002dc4:	1000                	addi	s0,sp,32
    80002dc6:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002dc8:	00014517          	auipc	a0,0x14
    80002dcc:	7b050513          	addi	a0,a0,1968 # 80017578 <itable>
    80002dd0:	00003097          	auipc	ra,0x3
    80002dd4:	516080e7          	jalr	1302(ra) # 800062e6 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002dd8:	4498                	lw	a4,8(s1)
    80002dda:	4785                	li	a5,1
    80002ddc:	02f70263          	beq	a4,a5,80002e00 <iput+0x44>
  ip->ref--;
    80002de0:	449c                	lw	a5,8(s1)
    80002de2:	37fd                	addiw	a5,a5,-1
    80002de4:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002de6:	00014517          	auipc	a0,0x14
    80002dea:	79250513          	addi	a0,a0,1938 # 80017578 <itable>
    80002dee:	00003097          	auipc	ra,0x3
    80002df2:	5ac080e7          	jalr	1452(ra) # 8000639a <release>
}
    80002df6:	60e2                	ld	ra,24(sp)
    80002df8:	6442                	ld	s0,16(sp)
    80002dfa:	64a2                	ld	s1,8(sp)
    80002dfc:	6105                	addi	sp,sp,32
    80002dfe:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002e00:	40bc                	lw	a5,64(s1)
    80002e02:	dff9                	beqz	a5,80002de0 <iput+0x24>
    80002e04:	04a49783          	lh	a5,74(s1)
    80002e08:	ffe1                	bnez	a5,80002de0 <iput+0x24>
    80002e0a:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80002e0c:	01048913          	addi	s2,s1,16
    80002e10:	854a                	mv	a0,s2
    80002e12:	00001097          	auipc	ra,0x1
    80002e16:	ab4080e7          	jalr	-1356(ra) # 800038c6 <acquiresleep>
    release(&itable.lock);
    80002e1a:	00014517          	auipc	a0,0x14
    80002e1e:	75e50513          	addi	a0,a0,1886 # 80017578 <itable>
    80002e22:	00003097          	auipc	ra,0x3
    80002e26:	578080e7          	jalr	1400(ra) # 8000639a <release>
    itrunc(ip);
    80002e2a:	8526                	mv	a0,s1
    80002e2c:	00000097          	auipc	ra,0x0
    80002e30:	ee4080e7          	jalr	-284(ra) # 80002d10 <itrunc>
    ip->type = 0;
    80002e34:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002e38:	8526                	mv	a0,s1
    80002e3a:	00000097          	auipc	ra,0x0
    80002e3e:	cf8080e7          	jalr	-776(ra) # 80002b32 <iupdate>
    ip->valid = 0;
    80002e42:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002e46:	854a                	mv	a0,s2
    80002e48:	00001097          	auipc	ra,0x1
    80002e4c:	ad4080e7          	jalr	-1324(ra) # 8000391c <releasesleep>
    acquire(&itable.lock);
    80002e50:	00014517          	auipc	a0,0x14
    80002e54:	72850513          	addi	a0,a0,1832 # 80017578 <itable>
    80002e58:	00003097          	auipc	ra,0x3
    80002e5c:	48e080e7          	jalr	1166(ra) # 800062e6 <acquire>
    80002e60:	6902                	ld	s2,0(sp)
    80002e62:	bfbd                	j	80002de0 <iput+0x24>

0000000080002e64 <iunlockput>:
{
    80002e64:	1101                	addi	sp,sp,-32
    80002e66:	ec06                	sd	ra,24(sp)
    80002e68:	e822                	sd	s0,16(sp)
    80002e6a:	e426                	sd	s1,8(sp)
    80002e6c:	1000                	addi	s0,sp,32
    80002e6e:	84aa                	mv	s1,a0
  iunlock(ip);
    80002e70:	00000097          	auipc	ra,0x0
    80002e74:	e54080e7          	jalr	-428(ra) # 80002cc4 <iunlock>
  iput(ip);
    80002e78:	8526                	mv	a0,s1
    80002e7a:	00000097          	auipc	ra,0x0
    80002e7e:	f42080e7          	jalr	-190(ra) # 80002dbc <iput>
}
    80002e82:	60e2                	ld	ra,24(sp)
    80002e84:	6442                	ld	s0,16(sp)
    80002e86:	64a2                	ld	s1,8(sp)
    80002e88:	6105                	addi	sp,sp,32
    80002e8a:	8082                	ret

0000000080002e8c <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002e8c:	1141                	addi	sp,sp,-16
    80002e8e:	e422                	sd	s0,8(sp)
    80002e90:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002e92:	411c                	lw	a5,0(a0)
    80002e94:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002e96:	415c                	lw	a5,4(a0)
    80002e98:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002e9a:	04451783          	lh	a5,68(a0)
    80002e9e:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002ea2:	04a51783          	lh	a5,74(a0)
    80002ea6:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002eaa:	04c56783          	lwu	a5,76(a0)
    80002eae:	e99c                	sd	a5,16(a1)
}
    80002eb0:	6422                	ld	s0,8(sp)
    80002eb2:	0141                	addi	sp,sp,16
    80002eb4:	8082                	ret

0000000080002eb6 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002eb6:	457c                	lw	a5,76(a0)
    80002eb8:	0ed7ef63          	bltu	a5,a3,80002fb6 <readi+0x100>
{
    80002ebc:	7159                	addi	sp,sp,-112
    80002ebe:	f486                	sd	ra,104(sp)
    80002ec0:	f0a2                	sd	s0,96(sp)
    80002ec2:	eca6                	sd	s1,88(sp)
    80002ec4:	fc56                	sd	s5,56(sp)
    80002ec6:	f85a                	sd	s6,48(sp)
    80002ec8:	f45e                	sd	s7,40(sp)
    80002eca:	f062                	sd	s8,32(sp)
    80002ecc:	1880                	addi	s0,sp,112
    80002ece:	8baa                	mv	s7,a0
    80002ed0:	8c2e                	mv	s8,a1
    80002ed2:	8ab2                	mv	s5,a2
    80002ed4:	84b6                	mv	s1,a3
    80002ed6:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002ed8:	9f35                	addw	a4,a4,a3
    return 0;
    80002eda:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002edc:	0ad76c63          	bltu	a4,a3,80002f94 <readi+0xde>
    80002ee0:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80002ee2:	00e7f463          	bgeu	a5,a4,80002eea <readi+0x34>
    n = ip->size - off;
    80002ee6:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002eea:	0c0b0463          	beqz	s6,80002fb2 <readi+0xfc>
    80002eee:	e8ca                	sd	s2,80(sp)
    80002ef0:	e0d2                	sd	s4,64(sp)
    80002ef2:	ec66                	sd	s9,24(sp)
    80002ef4:	e86a                	sd	s10,16(sp)
    80002ef6:	e46e                	sd	s11,8(sp)
    80002ef8:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002efa:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002efe:	5cfd                	li	s9,-1
    80002f00:	a82d                	j	80002f3a <readi+0x84>
    80002f02:	020a1d93          	slli	s11,s4,0x20
    80002f06:	020ddd93          	srli	s11,s11,0x20
    80002f0a:	05890613          	addi	a2,s2,88
    80002f0e:	86ee                	mv	a3,s11
    80002f10:	963a                	add	a2,a2,a4
    80002f12:	85d6                	mv	a1,s5
    80002f14:	8562                	mv	a0,s8
    80002f16:	fffff097          	auipc	ra,0xfffff
    80002f1a:	a22080e7          	jalr	-1502(ra) # 80001938 <either_copyout>
    80002f1e:	05950d63          	beq	a0,s9,80002f78 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002f22:	854a                	mv	a0,s2
    80002f24:	fffff097          	auipc	ra,0xfffff
    80002f28:	610080e7          	jalr	1552(ra) # 80002534 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f2c:	013a09bb          	addw	s3,s4,s3
    80002f30:	009a04bb          	addw	s1,s4,s1
    80002f34:	9aee                	add	s5,s5,s11
    80002f36:	0769f863          	bgeu	s3,s6,80002fa6 <readi+0xf0>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002f3a:	000ba903          	lw	s2,0(s7)
    80002f3e:	00a4d59b          	srliw	a1,s1,0xa
    80002f42:	855e                	mv	a0,s7
    80002f44:	00000097          	auipc	ra,0x0
    80002f48:	8ae080e7          	jalr	-1874(ra) # 800027f2 <bmap>
    80002f4c:	0005059b          	sext.w	a1,a0
    80002f50:	854a                	mv	a0,s2
    80002f52:	fffff097          	auipc	ra,0xfffff
    80002f56:	4b2080e7          	jalr	1202(ra) # 80002404 <bread>
    80002f5a:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f5c:	3ff4f713          	andi	a4,s1,1023
    80002f60:	40ed07bb          	subw	a5,s10,a4
    80002f64:	413b06bb          	subw	a3,s6,s3
    80002f68:	8a3e                	mv	s4,a5
    80002f6a:	2781                	sext.w	a5,a5
    80002f6c:	0006861b          	sext.w	a2,a3
    80002f70:	f8f679e3          	bgeu	a2,a5,80002f02 <readi+0x4c>
    80002f74:	8a36                	mv	s4,a3
    80002f76:	b771                	j	80002f02 <readi+0x4c>
      brelse(bp);
    80002f78:	854a                	mv	a0,s2
    80002f7a:	fffff097          	auipc	ra,0xfffff
    80002f7e:	5ba080e7          	jalr	1466(ra) # 80002534 <brelse>
      tot = -1;
    80002f82:	59fd                	li	s3,-1
      break;
    80002f84:	6946                	ld	s2,80(sp)
    80002f86:	6a06                	ld	s4,64(sp)
    80002f88:	6ce2                	ld	s9,24(sp)
    80002f8a:	6d42                	ld	s10,16(sp)
    80002f8c:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80002f8e:	0009851b          	sext.w	a0,s3
    80002f92:	69a6                	ld	s3,72(sp)
}
    80002f94:	70a6                	ld	ra,104(sp)
    80002f96:	7406                	ld	s0,96(sp)
    80002f98:	64e6                	ld	s1,88(sp)
    80002f9a:	7ae2                	ld	s5,56(sp)
    80002f9c:	7b42                	ld	s6,48(sp)
    80002f9e:	7ba2                	ld	s7,40(sp)
    80002fa0:	7c02                	ld	s8,32(sp)
    80002fa2:	6165                	addi	sp,sp,112
    80002fa4:	8082                	ret
    80002fa6:	6946                	ld	s2,80(sp)
    80002fa8:	6a06                	ld	s4,64(sp)
    80002faa:	6ce2                	ld	s9,24(sp)
    80002fac:	6d42                	ld	s10,16(sp)
    80002fae:	6da2                	ld	s11,8(sp)
    80002fb0:	bff9                	j	80002f8e <readi+0xd8>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002fb2:	89da                	mv	s3,s6
    80002fb4:	bfe9                	j	80002f8e <readi+0xd8>
    return 0;
    80002fb6:	4501                	li	a0,0
}
    80002fb8:	8082                	ret

0000000080002fba <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002fba:	457c                	lw	a5,76(a0)
    80002fbc:	10d7ee63          	bltu	a5,a3,800030d8 <writei+0x11e>
{
    80002fc0:	7159                	addi	sp,sp,-112
    80002fc2:	f486                	sd	ra,104(sp)
    80002fc4:	f0a2                	sd	s0,96(sp)
    80002fc6:	e8ca                	sd	s2,80(sp)
    80002fc8:	fc56                	sd	s5,56(sp)
    80002fca:	f85a                	sd	s6,48(sp)
    80002fcc:	f45e                	sd	s7,40(sp)
    80002fce:	f062                	sd	s8,32(sp)
    80002fd0:	1880                	addi	s0,sp,112
    80002fd2:	8b2a                	mv	s6,a0
    80002fd4:	8c2e                	mv	s8,a1
    80002fd6:	8ab2                	mv	s5,a2
    80002fd8:	8936                	mv	s2,a3
    80002fda:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80002fdc:	00e687bb          	addw	a5,a3,a4
    80002fe0:	0ed7ee63          	bltu	a5,a3,800030dc <writei+0x122>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002fe4:	00043737          	lui	a4,0x43
    80002fe8:	0ef76c63          	bltu	a4,a5,800030e0 <writei+0x126>
    80002fec:	e0d2                	sd	s4,64(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002fee:	0c0b8d63          	beqz	s7,800030c8 <writei+0x10e>
    80002ff2:	eca6                	sd	s1,88(sp)
    80002ff4:	e4ce                	sd	s3,72(sp)
    80002ff6:	ec66                	sd	s9,24(sp)
    80002ff8:	e86a                	sd	s10,16(sp)
    80002ffa:	e46e                	sd	s11,8(sp)
    80002ffc:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ffe:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003002:	5cfd                	li	s9,-1
    80003004:	a091                	j	80003048 <writei+0x8e>
    80003006:	02099d93          	slli	s11,s3,0x20
    8000300a:	020ddd93          	srli	s11,s11,0x20
    8000300e:	05848513          	addi	a0,s1,88
    80003012:	86ee                	mv	a3,s11
    80003014:	8656                	mv	a2,s5
    80003016:	85e2                	mv	a1,s8
    80003018:	953a                	add	a0,a0,a4
    8000301a:	fffff097          	auipc	ra,0xfffff
    8000301e:	974080e7          	jalr	-1676(ra) # 8000198e <either_copyin>
    80003022:	07950263          	beq	a0,s9,80003086 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003026:	8526                	mv	a0,s1
    80003028:	00000097          	auipc	ra,0x0
    8000302c:	780080e7          	jalr	1920(ra) # 800037a8 <log_write>
    brelse(bp);
    80003030:	8526                	mv	a0,s1
    80003032:	fffff097          	auipc	ra,0xfffff
    80003036:	502080e7          	jalr	1282(ra) # 80002534 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000303a:	01498a3b          	addw	s4,s3,s4
    8000303e:	0129893b          	addw	s2,s3,s2
    80003042:	9aee                	add	s5,s5,s11
    80003044:	057a7663          	bgeu	s4,s7,80003090 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003048:	000b2483          	lw	s1,0(s6)
    8000304c:	00a9559b          	srliw	a1,s2,0xa
    80003050:	855a                	mv	a0,s6
    80003052:	fffff097          	auipc	ra,0xfffff
    80003056:	7a0080e7          	jalr	1952(ra) # 800027f2 <bmap>
    8000305a:	0005059b          	sext.w	a1,a0
    8000305e:	8526                	mv	a0,s1
    80003060:	fffff097          	auipc	ra,0xfffff
    80003064:	3a4080e7          	jalr	932(ra) # 80002404 <bread>
    80003068:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000306a:	3ff97713          	andi	a4,s2,1023
    8000306e:	40ed07bb          	subw	a5,s10,a4
    80003072:	414b86bb          	subw	a3,s7,s4
    80003076:	89be                	mv	s3,a5
    80003078:	2781                	sext.w	a5,a5
    8000307a:	0006861b          	sext.w	a2,a3
    8000307e:	f8f674e3          	bgeu	a2,a5,80003006 <writei+0x4c>
    80003082:	89b6                	mv	s3,a3
    80003084:	b749                	j	80003006 <writei+0x4c>
      brelse(bp);
    80003086:	8526                	mv	a0,s1
    80003088:	fffff097          	auipc	ra,0xfffff
    8000308c:	4ac080e7          	jalr	1196(ra) # 80002534 <brelse>
  }

  if(off > ip->size)
    80003090:	04cb2783          	lw	a5,76(s6)
    80003094:	0327fc63          	bgeu	a5,s2,800030cc <writei+0x112>
    ip->size = off;
    80003098:	052b2623          	sw	s2,76(s6)
    8000309c:	64e6                	ld	s1,88(sp)
    8000309e:	69a6                	ld	s3,72(sp)
    800030a0:	6ce2                	ld	s9,24(sp)
    800030a2:	6d42                	ld	s10,16(sp)
    800030a4:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800030a6:	855a                	mv	a0,s6
    800030a8:	00000097          	auipc	ra,0x0
    800030ac:	a8a080e7          	jalr	-1398(ra) # 80002b32 <iupdate>

  return tot;
    800030b0:	000a051b          	sext.w	a0,s4
    800030b4:	6a06                	ld	s4,64(sp)
}
    800030b6:	70a6                	ld	ra,104(sp)
    800030b8:	7406                	ld	s0,96(sp)
    800030ba:	6946                	ld	s2,80(sp)
    800030bc:	7ae2                	ld	s5,56(sp)
    800030be:	7b42                	ld	s6,48(sp)
    800030c0:	7ba2                	ld	s7,40(sp)
    800030c2:	7c02                	ld	s8,32(sp)
    800030c4:	6165                	addi	sp,sp,112
    800030c6:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800030c8:	8a5e                	mv	s4,s7
    800030ca:	bff1                	j	800030a6 <writei+0xec>
    800030cc:	64e6                	ld	s1,88(sp)
    800030ce:	69a6                	ld	s3,72(sp)
    800030d0:	6ce2                	ld	s9,24(sp)
    800030d2:	6d42                	ld	s10,16(sp)
    800030d4:	6da2                	ld	s11,8(sp)
    800030d6:	bfc1                	j	800030a6 <writei+0xec>
    return -1;
    800030d8:	557d                	li	a0,-1
}
    800030da:	8082                	ret
    return -1;
    800030dc:	557d                	li	a0,-1
    800030de:	bfe1                	j	800030b6 <writei+0xfc>
    return -1;
    800030e0:	557d                	li	a0,-1
    800030e2:	bfd1                	j	800030b6 <writei+0xfc>

00000000800030e4 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800030e4:	1141                	addi	sp,sp,-16
    800030e6:	e406                	sd	ra,8(sp)
    800030e8:	e022                	sd	s0,0(sp)
    800030ea:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800030ec:	4639                	li	a2,14
    800030ee:	ffffd097          	auipc	ra,0xffffd
    800030f2:	1a6080e7          	jalr	422(ra) # 80000294 <strncmp>
}
    800030f6:	60a2                	ld	ra,8(sp)
    800030f8:	6402                	ld	s0,0(sp)
    800030fa:	0141                	addi	sp,sp,16
    800030fc:	8082                	ret

00000000800030fe <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800030fe:	7139                	addi	sp,sp,-64
    80003100:	fc06                	sd	ra,56(sp)
    80003102:	f822                	sd	s0,48(sp)
    80003104:	f426                	sd	s1,40(sp)
    80003106:	f04a                	sd	s2,32(sp)
    80003108:	ec4e                	sd	s3,24(sp)
    8000310a:	e852                	sd	s4,16(sp)
    8000310c:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    8000310e:	04451703          	lh	a4,68(a0)
    80003112:	4785                	li	a5,1
    80003114:	00f71a63          	bne	a4,a5,80003128 <dirlookup+0x2a>
    80003118:	892a                	mv	s2,a0
    8000311a:	89ae                	mv	s3,a1
    8000311c:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    8000311e:	457c                	lw	a5,76(a0)
    80003120:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003122:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003124:	e79d                	bnez	a5,80003152 <dirlookup+0x54>
    80003126:	a8a5                	j	8000319e <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003128:	00005517          	auipc	a0,0x5
    8000312c:	40850513          	addi	a0,a0,1032 # 80008530 <etext+0x530>
    80003130:	00003097          	auipc	ra,0x3
    80003134:	c3c080e7          	jalr	-964(ra) # 80005d6c <panic>
      panic("dirlookup read");
    80003138:	00005517          	auipc	a0,0x5
    8000313c:	41050513          	addi	a0,a0,1040 # 80008548 <etext+0x548>
    80003140:	00003097          	auipc	ra,0x3
    80003144:	c2c080e7          	jalr	-980(ra) # 80005d6c <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003148:	24c1                	addiw	s1,s1,16
    8000314a:	04c92783          	lw	a5,76(s2)
    8000314e:	04f4f763          	bgeu	s1,a5,8000319c <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003152:	4741                	li	a4,16
    80003154:	86a6                	mv	a3,s1
    80003156:	fc040613          	addi	a2,s0,-64
    8000315a:	4581                	li	a1,0
    8000315c:	854a                	mv	a0,s2
    8000315e:	00000097          	auipc	ra,0x0
    80003162:	d58080e7          	jalr	-680(ra) # 80002eb6 <readi>
    80003166:	47c1                	li	a5,16
    80003168:	fcf518e3          	bne	a0,a5,80003138 <dirlookup+0x3a>
    if(de.inum == 0)
    8000316c:	fc045783          	lhu	a5,-64(s0)
    80003170:	dfe1                	beqz	a5,80003148 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003172:	fc240593          	addi	a1,s0,-62
    80003176:	854e                	mv	a0,s3
    80003178:	00000097          	auipc	ra,0x0
    8000317c:	f6c080e7          	jalr	-148(ra) # 800030e4 <namecmp>
    80003180:	f561                	bnez	a0,80003148 <dirlookup+0x4a>
      if(poff)
    80003182:	000a0463          	beqz	s4,8000318a <dirlookup+0x8c>
        *poff = off;
    80003186:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    8000318a:	fc045583          	lhu	a1,-64(s0)
    8000318e:	00092503          	lw	a0,0(s2)
    80003192:	fffff097          	auipc	ra,0xfffff
    80003196:	73c080e7          	jalr	1852(ra) # 800028ce <iget>
    8000319a:	a011                	j	8000319e <dirlookup+0xa0>
  return 0;
    8000319c:	4501                	li	a0,0
}
    8000319e:	70e2                	ld	ra,56(sp)
    800031a0:	7442                	ld	s0,48(sp)
    800031a2:	74a2                	ld	s1,40(sp)
    800031a4:	7902                	ld	s2,32(sp)
    800031a6:	69e2                	ld	s3,24(sp)
    800031a8:	6a42                	ld	s4,16(sp)
    800031aa:	6121                	addi	sp,sp,64
    800031ac:	8082                	ret

00000000800031ae <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800031ae:	711d                	addi	sp,sp,-96
    800031b0:	ec86                	sd	ra,88(sp)
    800031b2:	e8a2                	sd	s0,80(sp)
    800031b4:	e4a6                	sd	s1,72(sp)
    800031b6:	e0ca                	sd	s2,64(sp)
    800031b8:	fc4e                	sd	s3,56(sp)
    800031ba:	f852                	sd	s4,48(sp)
    800031bc:	f456                	sd	s5,40(sp)
    800031be:	f05a                	sd	s6,32(sp)
    800031c0:	ec5e                	sd	s7,24(sp)
    800031c2:	e862                	sd	s8,16(sp)
    800031c4:	e466                	sd	s9,8(sp)
    800031c6:	1080                	addi	s0,sp,96
    800031c8:	84aa                	mv	s1,a0
    800031ca:	8b2e                	mv	s6,a1
    800031cc:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800031ce:	00054703          	lbu	a4,0(a0)
    800031d2:	02f00793          	li	a5,47
    800031d6:	02f70263          	beq	a4,a5,800031fa <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800031da:	ffffe097          	auipc	ra,0xffffe
    800031de:	cec080e7          	jalr	-788(ra) # 80000ec6 <myproc>
    800031e2:	15053503          	ld	a0,336(a0)
    800031e6:	00000097          	auipc	ra,0x0
    800031ea:	9da080e7          	jalr	-1574(ra) # 80002bc0 <idup>
    800031ee:	8a2a                	mv	s4,a0
  while(*path == '/')
    800031f0:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    800031f4:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800031f6:	4b85                	li	s7,1
    800031f8:	a875                	j	800032b4 <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    800031fa:	4585                	li	a1,1
    800031fc:	4505                	li	a0,1
    800031fe:	fffff097          	auipc	ra,0xfffff
    80003202:	6d0080e7          	jalr	1744(ra) # 800028ce <iget>
    80003206:	8a2a                	mv	s4,a0
    80003208:	b7e5                	j	800031f0 <namex+0x42>
      iunlockput(ip);
    8000320a:	8552                	mv	a0,s4
    8000320c:	00000097          	auipc	ra,0x0
    80003210:	c58080e7          	jalr	-936(ra) # 80002e64 <iunlockput>
      return 0;
    80003214:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003216:	8552                	mv	a0,s4
    80003218:	60e6                	ld	ra,88(sp)
    8000321a:	6446                	ld	s0,80(sp)
    8000321c:	64a6                	ld	s1,72(sp)
    8000321e:	6906                	ld	s2,64(sp)
    80003220:	79e2                	ld	s3,56(sp)
    80003222:	7a42                	ld	s4,48(sp)
    80003224:	7aa2                	ld	s5,40(sp)
    80003226:	7b02                	ld	s6,32(sp)
    80003228:	6be2                	ld	s7,24(sp)
    8000322a:	6c42                	ld	s8,16(sp)
    8000322c:	6ca2                	ld	s9,8(sp)
    8000322e:	6125                	addi	sp,sp,96
    80003230:	8082                	ret
      iunlock(ip);
    80003232:	8552                	mv	a0,s4
    80003234:	00000097          	auipc	ra,0x0
    80003238:	a90080e7          	jalr	-1392(ra) # 80002cc4 <iunlock>
      return ip;
    8000323c:	bfe9                	j	80003216 <namex+0x68>
      iunlockput(ip);
    8000323e:	8552                	mv	a0,s4
    80003240:	00000097          	auipc	ra,0x0
    80003244:	c24080e7          	jalr	-988(ra) # 80002e64 <iunlockput>
      return 0;
    80003248:	8a4e                	mv	s4,s3
    8000324a:	b7f1                	j	80003216 <namex+0x68>
  len = path - s;
    8000324c:	40998633          	sub	a2,s3,s1
    80003250:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80003254:	099c5863          	bge	s8,s9,800032e4 <namex+0x136>
    memmove(name, s, DIRSIZ);
    80003258:	4639                	li	a2,14
    8000325a:	85a6                	mv	a1,s1
    8000325c:	8556                	mv	a0,s5
    8000325e:	ffffd097          	auipc	ra,0xffffd
    80003262:	fc2080e7          	jalr	-62(ra) # 80000220 <memmove>
    80003266:	84ce                	mv	s1,s3
  while(*path == '/')
    80003268:	0004c783          	lbu	a5,0(s1)
    8000326c:	01279763          	bne	a5,s2,8000327a <namex+0xcc>
    path++;
    80003270:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003272:	0004c783          	lbu	a5,0(s1)
    80003276:	ff278de3          	beq	a5,s2,80003270 <namex+0xc2>
    ilock(ip);
    8000327a:	8552                	mv	a0,s4
    8000327c:	00000097          	auipc	ra,0x0
    80003280:	982080e7          	jalr	-1662(ra) # 80002bfe <ilock>
    if(ip->type != T_DIR){
    80003284:	044a1783          	lh	a5,68(s4)
    80003288:	f97791e3          	bne	a5,s7,8000320a <namex+0x5c>
    if(nameiparent && *path == '\0'){
    8000328c:	000b0563          	beqz	s6,80003296 <namex+0xe8>
    80003290:	0004c783          	lbu	a5,0(s1)
    80003294:	dfd9                	beqz	a5,80003232 <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003296:	4601                	li	a2,0
    80003298:	85d6                	mv	a1,s5
    8000329a:	8552                	mv	a0,s4
    8000329c:	00000097          	auipc	ra,0x0
    800032a0:	e62080e7          	jalr	-414(ra) # 800030fe <dirlookup>
    800032a4:	89aa                	mv	s3,a0
    800032a6:	dd41                	beqz	a0,8000323e <namex+0x90>
    iunlockput(ip);
    800032a8:	8552                	mv	a0,s4
    800032aa:	00000097          	auipc	ra,0x0
    800032ae:	bba080e7          	jalr	-1094(ra) # 80002e64 <iunlockput>
    ip = next;
    800032b2:	8a4e                	mv	s4,s3
  while(*path == '/')
    800032b4:	0004c783          	lbu	a5,0(s1)
    800032b8:	01279763          	bne	a5,s2,800032c6 <namex+0x118>
    path++;
    800032bc:	0485                	addi	s1,s1,1
  while(*path == '/')
    800032be:	0004c783          	lbu	a5,0(s1)
    800032c2:	ff278de3          	beq	a5,s2,800032bc <namex+0x10e>
  if(*path == 0)
    800032c6:	cb9d                	beqz	a5,800032fc <namex+0x14e>
  while(*path != '/' && *path != 0)
    800032c8:	0004c783          	lbu	a5,0(s1)
    800032cc:	89a6                	mv	s3,s1
  len = path - s;
    800032ce:	4c81                	li	s9,0
    800032d0:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    800032d2:	01278963          	beq	a5,s2,800032e4 <namex+0x136>
    800032d6:	dbbd                	beqz	a5,8000324c <namex+0x9e>
    path++;
    800032d8:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    800032da:	0009c783          	lbu	a5,0(s3)
    800032de:	ff279ce3          	bne	a5,s2,800032d6 <namex+0x128>
    800032e2:	b7ad                	j	8000324c <namex+0x9e>
    memmove(name, s, len);
    800032e4:	2601                	sext.w	a2,a2
    800032e6:	85a6                	mv	a1,s1
    800032e8:	8556                	mv	a0,s5
    800032ea:	ffffd097          	auipc	ra,0xffffd
    800032ee:	f36080e7          	jalr	-202(ra) # 80000220 <memmove>
    name[len] = 0;
    800032f2:	9cd6                	add	s9,s9,s5
    800032f4:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    800032f8:	84ce                	mv	s1,s3
    800032fa:	b7bd                	j	80003268 <namex+0xba>
  if(nameiparent){
    800032fc:	f00b0de3          	beqz	s6,80003216 <namex+0x68>
    iput(ip);
    80003300:	8552                	mv	a0,s4
    80003302:	00000097          	auipc	ra,0x0
    80003306:	aba080e7          	jalr	-1350(ra) # 80002dbc <iput>
    return 0;
    8000330a:	4a01                	li	s4,0
    8000330c:	b729                	j	80003216 <namex+0x68>

000000008000330e <dirlink>:
{
    8000330e:	7139                	addi	sp,sp,-64
    80003310:	fc06                	sd	ra,56(sp)
    80003312:	f822                	sd	s0,48(sp)
    80003314:	f04a                	sd	s2,32(sp)
    80003316:	ec4e                	sd	s3,24(sp)
    80003318:	e852                	sd	s4,16(sp)
    8000331a:	0080                	addi	s0,sp,64
    8000331c:	892a                	mv	s2,a0
    8000331e:	8a2e                	mv	s4,a1
    80003320:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003322:	4601                	li	a2,0
    80003324:	00000097          	auipc	ra,0x0
    80003328:	dda080e7          	jalr	-550(ra) # 800030fe <dirlookup>
    8000332c:	ed25                	bnez	a0,800033a4 <dirlink+0x96>
    8000332e:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003330:	04c92483          	lw	s1,76(s2)
    80003334:	c49d                	beqz	s1,80003362 <dirlink+0x54>
    80003336:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003338:	4741                	li	a4,16
    8000333a:	86a6                	mv	a3,s1
    8000333c:	fc040613          	addi	a2,s0,-64
    80003340:	4581                	li	a1,0
    80003342:	854a                	mv	a0,s2
    80003344:	00000097          	auipc	ra,0x0
    80003348:	b72080e7          	jalr	-1166(ra) # 80002eb6 <readi>
    8000334c:	47c1                	li	a5,16
    8000334e:	06f51163          	bne	a0,a5,800033b0 <dirlink+0xa2>
    if(de.inum == 0)
    80003352:	fc045783          	lhu	a5,-64(s0)
    80003356:	c791                	beqz	a5,80003362 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003358:	24c1                	addiw	s1,s1,16
    8000335a:	04c92783          	lw	a5,76(s2)
    8000335e:	fcf4ede3          	bltu	s1,a5,80003338 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003362:	4639                	li	a2,14
    80003364:	85d2                	mv	a1,s4
    80003366:	fc240513          	addi	a0,s0,-62
    8000336a:	ffffd097          	auipc	ra,0xffffd
    8000336e:	f60080e7          	jalr	-160(ra) # 800002ca <strncpy>
  de.inum = inum;
    80003372:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003376:	4741                	li	a4,16
    80003378:	86a6                	mv	a3,s1
    8000337a:	fc040613          	addi	a2,s0,-64
    8000337e:	4581                	li	a1,0
    80003380:	854a                	mv	a0,s2
    80003382:	00000097          	auipc	ra,0x0
    80003386:	c38080e7          	jalr	-968(ra) # 80002fba <writei>
    8000338a:	872a                	mv	a4,a0
    8000338c:	47c1                	li	a5,16
  return 0;
    8000338e:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003390:	02f71863          	bne	a4,a5,800033c0 <dirlink+0xb2>
    80003394:	74a2                	ld	s1,40(sp)
}
    80003396:	70e2                	ld	ra,56(sp)
    80003398:	7442                	ld	s0,48(sp)
    8000339a:	7902                	ld	s2,32(sp)
    8000339c:	69e2                	ld	s3,24(sp)
    8000339e:	6a42                	ld	s4,16(sp)
    800033a0:	6121                	addi	sp,sp,64
    800033a2:	8082                	ret
    iput(ip);
    800033a4:	00000097          	auipc	ra,0x0
    800033a8:	a18080e7          	jalr	-1512(ra) # 80002dbc <iput>
    return -1;
    800033ac:	557d                	li	a0,-1
    800033ae:	b7e5                	j	80003396 <dirlink+0x88>
      panic("dirlink read");
    800033b0:	00005517          	auipc	a0,0x5
    800033b4:	1a850513          	addi	a0,a0,424 # 80008558 <etext+0x558>
    800033b8:	00003097          	auipc	ra,0x3
    800033bc:	9b4080e7          	jalr	-1612(ra) # 80005d6c <panic>
    panic("dirlink");
    800033c0:	00005517          	auipc	a0,0x5
    800033c4:	2a050513          	addi	a0,a0,672 # 80008660 <etext+0x660>
    800033c8:	00003097          	auipc	ra,0x3
    800033cc:	9a4080e7          	jalr	-1628(ra) # 80005d6c <panic>

00000000800033d0 <namei>:

struct inode*
namei(char *path)
{
    800033d0:	1101                	addi	sp,sp,-32
    800033d2:	ec06                	sd	ra,24(sp)
    800033d4:	e822                	sd	s0,16(sp)
    800033d6:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800033d8:	fe040613          	addi	a2,s0,-32
    800033dc:	4581                	li	a1,0
    800033de:	00000097          	auipc	ra,0x0
    800033e2:	dd0080e7          	jalr	-560(ra) # 800031ae <namex>
}
    800033e6:	60e2                	ld	ra,24(sp)
    800033e8:	6442                	ld	s0,16(sp)
    800033ea:	6105                	addi	sp,sp,32
    800033ec:	8082                	ret

00000000800033ee <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800033ee:	1141                	addi	sp,sp,-16
    800033f0:	e406                	sd	ra,8(sp)
    800033f2:	e022                	sd	s0,0(sp)
    800033f4:	0800                	addi	s0,sp,16
    800033f6:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800033f8:	4585                	li	a1,1
    800033fa:	00000097          	auipc	ra,0x0
    800033fe:	db4080e7          	jalr	-588(ra) # 800031ae <namex>
}
    80003402:	60a2                	ld	ra,8(sp)
    80003404:	6402                	ld	s0,0(sp)
    80003406:	0141                	addi	sp,sp,16
    80003408:	8082                	ret

000000008000340a <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    8000340a:	1101                	addi	sp,sp,-32
    8000340c:	ec06                	sd	ra,24(sp)
    8000340e:	e822                	sd	s0,16(sp)
    80003410:	e426                	sd	s1,8(sp)
    80003412:	e04a                	sd	s2,0(sp)
    80003414:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003416:	00016917          	auipc	s2,0x16
    8000341a:	c0a90913          	addi	s2,s2,-1014 # 80019020 <log>
    8000341e:	01892583          	lw	a1,24(s2)
    80003422:	02892503          	lw	a0,40(s2)
    80003426:	fffff097          	auipc	ra,0xfffff
    8000342a:	fde080e7          	jalr	-34(ra) # 80002404 <bread>
    8000342e:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003430:	02c92603          	lw	a2,44(s2)
    80003434:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003436:	00c05f63          	blez	a2,80003454 <write_head+0x4a>
    8000343a:	00016717          	auipc	a4,0x16
    8000343e:	c1670713          	addi	a4,a4,-1002 # 80019050 <log+0x30>
    80003442:	87aa                	mv	a5,a0
    80003444:	060a                	slli	a2,a2,0x2
    80003446:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003448:	4314                	lw	a3,0(a4)
    8000344a:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    8000344c:	0711                	addi	a4,a4,4
    8000344e:	0791                	addi	a5,a5,4
    80003450:	fec79ce3          	bne	a5,a2,80003448 <write_head+0x3e>
  }
  bwrite(buf);
    80003454:	8526                	mv	a0,s1
    80003456:	fffff097          	auipc	ra,0xfffff
    8000345a:	0a0080e7          	jalr	160(ra) # 800024f6 <bwrite>
  brelse(buf);
    8000345e:	8526                	mv	a0,s1
    80003460:	fffff097          	auipc	ra,0xfffff
    80003464:	0d4080e7          	jalr	212(ra) # 80002534 <brelse>
}
    80003468:	60e2                	ld	ra,24(sp)
    8000346a:	6442                	ld	s0,16(sp)
    8000346c:	64a2                	ld	s1,8(sp)
    8000346e:	6902                	ld	s2,0(sp)
    80003470:	6105                	addi	sp,sp,32
    80003472:	8082                	ret

0000000080003474 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003474:	00016797          	auipc	a5,0x16
    80003478:	bd87a783          	lw	a5,-1064(a5) # 8001904c <log+0x2c>
    8000347c:	0af05d63          	blez	a5,80003536 <install_trans+0xc2>
{
    80003480:	7139                	addi	sp,sp,-64
    80003482:	fc06                	sd	ra,56(sp)
    80003484:	f822                	sd	s0,48(sp)
    80003486:	f426                	sd	s1,40(sp)
    80003488:	f04a                	sd	s2,32(sp)
    8000348a:	ec4e                	sd	s3,24(sp)
    8000348c:	e852                	sd	s4,16(sp)
    8000348e:	e456                	sd	s5,8(sp)
    80003490:	e05a                	sd	s6,0(sp)
    80003492:	0080                	addi	s0,sp,64
    80003494:	8b2a                	mv	s6,a0
    80003496:	00016a97          	auipc	s5,0x16
    8000349a:	bbaa8a93          	addi	s5,s5,-1094 # 80019050 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000349e:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800034a0:	00016997          	auipc	s3,0x16
    800034a4:	b8098993          	addi	s3,s3,-1152 # 80019020 <log>
    800034a8:	a00d                	j	800034ca <install_trans+0x56>
    brelse(lbuf);
    800034aa:	854a                	mv	a0,s2
    800034ac:	fffff097          	auipc	ra,0xfffff
    800034b0:	088080e7          	jalr	136(ra) # 80002534 <brelse>
    brelse(dbuf);
    800034b4:	8526                	mv	a0,s1
    800034b6:	fffff097          	auipc	ra,0xfffff
    800034ba:	07e080e7          	jalr	126(ra) # 80002534 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800034be:	2a05                	addiw	s4,s4,1
    800034c0:	0a91                	addi	s5,s5,4
    800034c2:	02c9a783          	lw	a5,44(s3)
    800034c6:	04fa5e63          	bge	s4,a5,80003522 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800034ca:	0189a583          	lw	a1,24(s3)
    800034ce:	014585bb          	addw	a1,a1,s4
    800034d2:	2585                	addiw	a1,a1,1
    800034d4:	0289a503          	lw	a0,40(s3)
    800034d8:	fffff097          	auipc	ra,0xfffff
    800034dc:	f2c080e7          	jalr	-212(ra) # 80002404 <bread>
    800034e0:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800034e2:	000aa583          	lw	a1,0(s5)
    800034e6:	0289a503          	lw	a0,40(s3)
    800034ea:	fffff097          	auipc	ra,0xfffff
    800034ee:	f1a080e7          	jalr	-230(ra) # 80002404 <bread>
    800034f2:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800034f4:	40000613          	li	a2,1024
    800034f8:	05890593          	addi	a1,s2,88
    800034fc:	05850513          	addi	a0,a0,88
    80003500:	ffffd097          	auipc	ra,0xffffd
    80003504:	d20080e7          	jalr	-736(ra) # 80000220 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003508:	8526                	mv	a0,s1
    8000350a:	fffff097          	auipc	ra,0xfffff
    8000350e:	fec080e7          	jalr	-20(ra) # 800024f6 <bwrite>
    if(recovering == 0)
    80003512:	f80b1ce3          	bnez	s6,800034aa <install_trans+0x36>
      bunpin(dbuf);
    80003516:	8526                	mv	a0,s1
    80003518:	fffff097          	auipc	ra,0xfffff
    8000351c:	0f4080e7          	jalr	244(ra) # 8000260c <bunpin>
    80003520:	b769                	j	800034aa <install_trans+0x36>
}
    80003522:	70e2                	ld	ra,56(sp)
    80003524:	7442                	ld	s0,48(sp)
    80003526:	74a2                	ld	s1,40(sp)
    80003528:	7902                	ld	s2,32(sp)
    8000352a:	69e2                	ld	s3,24(sp)
    8000352c:	6a42                	ld	s4,16(sp)
    8000352e:	6aa2                	ld	s5,8(sp)
    80003530:	6b02                	ld	s6,0(sp)
    80003532:	6121                	addi	sp,sp,64
    80003534:	8082                	ret
    80003536:	8082                	ret

0000000080003538 <initlog>:
{
    80003538:	7179                	addi	sp,sp,-48
    8000353a:	f406                	sd	ra,40(sp)
    8000353c:	f022                	sd	s0,32(sp)
    8000353e:	ec26                	sd	s1,24(sp)
    80003540:	e84a                	sd	s2,16(sp)
    80003542:	e44e                	sd	s3,8(sp)
    80003544:	1800                	addi	s0,sp,48
    80003546:	892a                	mv	s2,a0
    80003548:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000354a:	00016497          	auipc	s1,0x16
    8000354e:	ad648493          	addi	s1,s1,-1322 # 80019020 <log>
    80003552:	00005597          	auipc	a1,0x5
    80003556:	01658593          	addi	a1,a1,22 # 80008568 <etext+0x568>
    8000355a:	8526                	mv	a0,s1
    8000355c:	00003097          	auipc	ra,0x3
    80003560:	cfa080e7          	jalr	-774(ra) # 80006256 <initlock>
  log.start = sb->logstart;
    80003564:	0149a583          	lw	a1,20(s3)
    80003568:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000356a:	0109a783          	lw	a5,16(s3)
    8000356e:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003570:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003574:	854a                	mv	a0,s2
    80003576:	fffff097          	auipc	ra,0xfffff
    8000357a:	e8e080e7          	jalr	-370(ra) # 80002404 <bread>
  log.lh.n = lh->n;
    8000357e:	4d30                	lw	a2,88(a0)
    80003580:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003582:	00c05f63          	blez	a2,800035a0 <initlog+0x68>
    80003586:	87aa                	mv	a5,a0
    80003588:	00016717          	auipc	a4,0x16
    8000358c:	ac870713          	addi	a4,a4,-1336 # 80019050 <log+0x30>
    80003590:	060a                	slli	a2,a2,0x2
    80003592:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003594:	4ff4                	lw	a3,92(a5)
    80003596:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003598:	0791                	addi	a5,a5,4
    8000359a:	0711                	addi	a4,a4,4
    8000359c:	fec79ce3          	bne	a5,a2,80003594 <initlog+0x5c>
  brelse(buf);
    800035a0:	fffff097          	auipc	ra,0xfffff
    800035a4:	f94080e7          	jalr	-108(ra) # 80002534 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800035a8:	4505                	li	a0,1
    800035aa:	00000097          	auipc	ra,0x0
    800035ae:	eca080e7          	jalr	-310(ra) # 80003474 <install_trans>
  log.lh.n = 0;
    800035b2:	00016797          	auipc	a5,0x16
    800035b6:	a807ad23          	sw	zero,-1382(a5) # 8001904c <log+0x2c>
  write_head(); // clear the log
    800035ba:	00000097          	auipc	ra,0x0
    800035be:	e50080e7          	jalr	-432(ra) # 8000340a <write_head>
}
    800035c2:	70a2                	ld	ra,40(sp)
    800035c4:	7402                	ld	s0,32(sp)
    800035c6:	64e2                	ld	s1,24(sp)
    800035c8:	6942                	ld	s2,16(sp)
    800035ca:	69a2                	ld	s3,8(sp)
    800035cc:	6145                	addi	sp,sp,48
    800035ce:	8082                	ret

00000000800035d0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800035d0:	1101                	addi	sp,sp,-32
    800035d2:	ec06                	sd	ra,24(sp)
    800035d4:	e822                	sd	s0,16(sp)
    800035d6:	e426                	sd	s1,8(sp)
    800035d8:	e04a                	sd	s2,0(sp)
    800035da:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800035dc:	00016517          	auipc	a0,0x16
    800035e0:	a4450513          	addi	a0,a0,-1468 # 80019020 <log>
    800035e4:	00003097          	auipc	ra,0x3
    800035e8:	d02080e7          	jalr	-766(ra) # 800062e6 <acquire>
  while(1){
    if(log.committing){
    800035ec:	00016497          	auipc	s1,0x16
    800035f0:	a3448493          	addi	s1,s1,-1484 # 80019020 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800035f4:	4979                	li	s2,30
    800035f6:	a039                	j	80003604 <begin_op+0x34>
      sleep(&log, &log.lock);
    800035f8:	85a6                	mv	a1,s1
    800035fa:	8526                	mv	a0,s1
    800035fc:	ffffe097          	auipc	ra,0xffffe
    80003600:	f98080e7          	jalr	-104(ra) # 80001594 <sleep>
    if(log.committing){
    80003604:	50dc                	lw	a5,36(s1)
    80003606:	fbed                	bnez	a5,800035f8 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003608:	5098                	lw	a4,32(s1)
    8000360a:	2705                	addiw	a4,a4,1
    8000360c:	0027179b          	slliw	a5,a4,0x2
    80003610:	9fb9                	addw	a5,a5,a4
    80003612:	0017979b          	slliw	a5,a5,0x1
    80003616:	54d4                	lw	a3,44(s1)
    80003618:	9fb5                	addw	a5,a5,a3
    8000361a:	00f95963          	bge	s2,a5,8000362c <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000361e:	85a6                	mv	a1,s1
    80003620:	8526                	mv	a0,s1
    80003622:	ffffe097          	auipc	ra,0xffffe
    80003626:	f72080e7          	jalr	-142(ra) # 80001594 <sleep>
    8000362a:	bfe9                	j	80003604 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    8000362c:	00016517          	auipc	a0,0x16
    80003630:	9f450513          	addi	a0,a0,-1548 # 80019020 <log>
    80003634:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80003636:	00003097          	auipc	ra,0x3
    8000363a:	d64080e7          	jalr	-668(ra) # 8000639a <release>
      break;
    }
  }
}
    8000363e:	60e2                	ld	ra,24(sp)
    80003640:	6442                	ld	s0,16(sp)
    80003642:	64a2                	ld	s1,8(sp)
    80003644:	6902                	ld	s2,0(sp)
    80003646:	6105                	addi	sp,sp,32
    80003648:	8082                	ret

000000008000364a <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000364a:	7139                	addi	sp,sp,-64
    8000364c:	fc06                	sd	ra,56(sp)
    8000364e:	f822                	sd	s0,48(sp)
    80003650:	f426                	sd	s1,40(sp)
    80003652:	f04a                	sd	s2,32(sp)
    80003654:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003656:	00016497          	auipc	s1,0x16
    8000365a:	9ca48493          	addi	s1,s1,-1590 # 80019020 <log>
    8000365e:	8526                	mv	a0,s1
    80003660:	00003097          	auipc	ra,0x3
    80003664:	c86080e7          	jalr	-890(ra) # 800062e6 <acquire>
  log.outstanding -= 1;
    80003668:	509c                	lw	a5,32(s1)
    8000366a:	37fd                	addiw	a5,a5,-1
    8000366c:	0007891b          	sext.w	s2,a5
    80003670:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003672:	50dc                	lw	a5,36(s1)
    80003674:	e7b9                	bnez	a5,800036c2 <end_op+0x78>
    panic("log.committing");
  if(log.outstanding == 0){
    80003676:	06091163          	bnez	s2,800036d8 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    8000367a:	00016497          	auipc	s1,0x16
    8000367e:	9a648493          	addi	s1,s1,-1626 # 80019020 <log>
    80003682:	4785                	li	a5,1
    80003684:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003686:	8526                	mv	a0,s1
    80003688:	00003097          	auipc	ra,0x3
    8000368c:	d12080e7          	jalr	-750(ra) # 8000639a <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003690:	54dc                	lw	a5,44(s1)
    80003692:	06f04763          	bgtz	a5,80003700 <end_op+0xb6>
    acquire(&log.lock);
    80003696:	00016497          	auipc	s1,0x16
    8000369a:	98a48493          	addi	s1,s1,-1654 # 80019020 <log>
    8000369e:	8526                	mv	a0,s1
    800036a0:	00003097          	auipc	ra,0x3
    800036a4:	c46080e7          	jalr	-954(ra) # 800062e6 <acquire>
    log.committing = 0;
    800036a8:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800036ac:	8526                	mv	a0,s1
    800036ae:	ffffe097          	auipc	ra,0xffffe
    800036b2:	072080e7          	jalr	114(ra) # 80001720 <wakeup>
    release(&log.lock);
    800036b6:	8526                	mv	a0,s1
    800036b8:	00003097          	auipc	ra,0x3
    800036bc:	ce2080e7          	jalr	-798(ra) # 8000639a <release>
}
    800036c0:	a815                	j	800036f4 <end_op+0xaa>
    800036c2:	ec4e                	sd	s3,24(sp)
    800036c4:	e852                	sd	s4,16(sp)
    800036c6:	e456                	sd	s5,8(sp)
    panic("log.committing");
    800036c8:	00005517          	auipc	a0,0x5
    800036cc:	ea850513          	addi	a0,a0,-344 # 80008570 <etext+0x570>
    800036d0:	00002097          	auipc	ra,0x2
    800036d4:	69c080e7          	jalr	1692(ra) # 80005d6c <panic>
    wakeup(&log);
    800036d8:	00016497          	auipc	s1,0x16
    800036dc:	94848493          	addi	s1,s1,-1720 # 80019020 <log>
    800036e0:	8526                	mv	a0,s1
    800036e2:	ffffe097          	auipc	ra,0xffffe
    800036e6:	03e080e7          	jalr	62(ra) # 80001720 <wakeup>
  release(&log.lock);
    800036ea:	8526                	mv	a0,s1
    800036ec:	00003097          	auipc	ra,0x3
    800036f0:	cae080e7          	jalr	-850(ra) # 8000639a <release>
}
    800036f4:	70e2                	ld	ra,56(sp)
    800036f6:	7442                	ld	s0,48(sp)
    800036f8:	74a2                	ld	s1,40(sp)
    800036fa:	7902                	ld	s2,32(sp)
    800036fc:	6121                	addi	sp,sp,64
    800036fe:	8082                	ret
    80003700:	ec4e                	sd	s3,24(sp)
    80003702:	e852                	sd	s4,16(sp)
    80003704:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80003706:	00016a97          	auipc	s5,0x16
    8000370a:	94aa8a93          	addi	s5,s5,-1718 # 80019050 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    8000370e:	00016a17          	auipc	s4,0x16
    80003712:	912a0a13          	addi	s4,s4,-1774 # 80019020 <log>
    80003716:	018a2583          	lw	a1,24(s4)
    8000371a:	012585bb          	addw	a1,a1,s2
    8000371e:	2585                	addiw	a1,a1,1
    80003720:	028a2503          	lw	a0,40(s4)
    80003724:	fffff097          	auipc	ra,0xfffff
    80003728:	ce0080e7          	jalr	-800(ra) # 80002404 <bread>
    8000372c:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000372e:	000aa583          	lw	a1,0(s5)
    80003732:	028a2503          	lw	a0,40(s4)
    80003736:	fffff097          	auipc	ra,0xfffff
    8000373a:	cce080e7          	jalr	-818(ra) # 80002404 <bread>
    8000373e:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003740:	40000613          	li	a2,1024
    80003744:	05850593          	addi	a1,a0,88
    80003748:	05848513          	addi	a0,s1,88
    8000374c:	ffffd097          	auipc	ra,0xffffd
    80003750:	ad4080e7          	jalr	-1324(ra) # 80000220 <memmove>
    bwrite(to);  // write the log
    80003754:	8526                	mv	a0,s1
    80003756:	fffff097          	auipc	ra,0xfffff
    8000375a:	da0080e7          	jalr	-608(ra) # 800024f6 <bwrite>
    brelse(from);
    8000375e:	854e                	mv	a0,s3
    80003760:	fffff097          	auipc	ra,0xfffff
    80003764:	dd4080e7          	jalr	-556(ra) # 80002534 <brelse>
    brelse(to);
    80003768:	8526                	mv	a0,s1
    8000376a:	fffff097          	auipc	ra,0xfffff
    8000376e:	dca080e7          	jalr	-566(ra) # 80002534 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003772:	2905                	addiw	s2,s2,1
    80003774:	0a91                	addi	s5,s5,4
    80003776:	02ca2783          	lw	a5,44(s4)
    8000377a:	f8f94ee3          	blt	s2,a5,80003716 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000377e:	00000097          	auipc	ra,0x0
    80003782:	c8c080e7          	jalr	-884(ra) # 8000340a <write_head>
    install_trans(0); // Now install writes to home locations
    80003786:	4501                	li	a0,0
    80003788:	00000097          	auipc	ra,0x0
    8000378c:	cec080e7          	jalr	-788(ra) # 80003474 <install_trans>
    log.lh.n = 0;
    80003790:	00016797          	auipc	a5,0x16
    80003794:	8a07ae23          	sw	zero,-1860(a5) # 8001904c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003798:	00000097          	auipc	ra,0x0
    8000379c:	c72080e7          	jalr	-910(ra) # 8000340a <write_head>
    800037a0:	69e2                	ld	s3,24(sp)
    800037a2:	6a42                	ld	s4,16(sp)
    800037a4:	6aa2                	ld	s5,8(sp)
    800037a6:	bdc5                	j	80003696 <end_op+0x4c>

00000000800037a8 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800037a8:	1101                	addi	sp,sp,-32
    800037aa:	ec06                	sd	ra,24(sp)
    800037ac:	e822                	sd	s0,16(sp)
    800037ae:	e426                	sd	s1,8(sp)
    800037b0:	e04a                	sd	s2,0(sp)
    800037b2:	1000                	addi	s0,sp,32
    800037b4:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800037b6:	00016917          	auipc	s2,0x16
    800037ba:	86a90913          	addi	s2,s2,-1942 # 80019020 <log>
    800037be:	854a                	mv	a0,s2
    800037c0:	00003097          	auipc	ra,0x3
    800037c4:	b26080e7          	jalr	-1242(ra) # 800062e6 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800037c8:	02c92603          	lw	a2,44(s2)
    800037cc:	47f5                	li	a5,29
    800037ce:	06c7c563          	blt	a5,a2,80003838 <log_write+0x90>
    800037d2:	00016797          	auipc	a5,0x16
    800037d6:	86a7a783          	lw	a5,-1942(a5) # 8001903c <log+0x1c>
    800037da:	37fd                	addiw	a5,a5,-1
    800037dc:	04f65e63          	bge	a2,a5,80003838 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800037e0:	00016797          	auipc	a5,0x16
    800037e4:	8607a783          	lw	a5,-1952(a5) # 80019040 <log+0x20>
    800037e8:	06f05063          	blez	a5,80003848 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800037ec:	4781                	li	a5,0
    800037ee:	06c05563          	blez	a2,80003858 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800037f2:	44cc                	lw	a1,12(s1)
    800037f4:	00016717          	auipc	a4,0x16
    800037f8:	85c70713          	addi	a4,a4,-1956 # 80019050 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800037fc:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800037fe:	4314                	lw	a3,0(a4)
    80003800:	04b68c63          	beq	a3,a1,80003858 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003804:	2785                	addiw	a5,a5,1
    80003806:	0711                	addi	a4,a4,4
    80003808:	fef61be3          	bne	a2,a5,800037fe <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    8000380c:	0621                	addi	a2,a2,8
    8000380e:	060a                	slli	a2,a2,0x2
    80003810:	00016797          	auipc	a5,0x16
    80003814:	81078793          	addi	a5,a5,-2032 # 80019020 <log>
    80003818:	97b2                	add	a5,a5,a2
    8000381a:	44d8                	lw	a4,12(s1)
    8000381c:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    8000381e:	8526                	mv	a0,s1
    80003820:	fffff097          	auipc	ra,0xfffff
    80003824:	db0080e7          	jalr	-592(ra) # 800025d0 <bpin>
    log.lh.n++;
    80003828:	00015717          	auipc	a4,0x15
    8000382c:	7f870713          	addi	a4,a4,2040 # 80019020 <log>
    80003830:	575c                	lw	a5,44(a4)
    80003832:	2785                	addiw	a5,a5,1
    80003834:	d75c                	sw	a5,44(a4)
    80003836:	a82d                	j	80003870 <log_write+0xc8>
    panic("too big a transaction");
    80003838:	00005517          	auipc	a0,0x5
    8000383c:	d4850513          	addi	a0,a0,-696 # 80008580 <etext+0x580>
    80003840:	00002097          	auipc	ra,0x2
    80003844:	52c080e7          	jalr	1324(ra) # 80005d6c <panic>
    panic("log_write outside of trans");
    80003848:	00005517          	auipc	a0,0x5
    8000384c:	d5050513          	addi	a0,a0,-688 # 80008598 <etext+0x598>
    80003850:	00002097          	auipc	ra,0x2
    80003854:	51c080e7          	jalr	1308(ra) # 80005d6c <panic>
  log.lh.block[i] = b->blockno;
    80003858:	00878693          	addi	a3,a5,8
    8000385c:	068a                	slli	a3,a3,0x2
    8000385e:	00015717          	auipc	a4,0x15
    80003862:	7c270713          	addi	a4,a4,1986 # 80019020 <log>
    80003866:	9736                	add	a4,a4,a3
    80003868:	44d4                	lw	a3,12(s1)
    8000386a:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000386c:	faf609e3          	beq	a2,a5,8000381e <log_write+0x76>
  }
  release(&log.lock);
    80003870:	00015517          	auipc	a0,0x15
    80003874:	7b050513          	addi	a0,a0,1968 # 80019020 <log>
    80003878:	00003097          	auipc	ra,0x3
    8000387c:	b22080e7          	jalr	-1246(ra) # 8000639a <release>
}
    80003880:	60e2                	ld	ra,24(sp)
    80003882:	6442                	ld	s0,16(sp)
    80003884:	64a2                	ld	s1,8(sp)
    80003886:	6902                	ld	s2,0(sp)
    80003888:	6105                	addi	sp,sp,32
    8000388a:	8082                	ret

000000008000388c <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000388c:	1101                	addi	sp,sp,-32
    8000388e:	ec06                	sd	ra,24(sp)
    80003890:	e822                	sd	s0,16(sp)
    80003892:	e426                	sd	s1,8(sp)
    80003894:	e04a                	sd	s2,0(sp)
    80003896:	1000                	addi	s0,sp,32
    80003898:	84aa                	mv	s1,a0
    8000389a:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000389c:	00005597          	auipc	a1,0x5
    800038a0:	d1c58593          	addi	a1,a1,-740 # 800085b8 <etext+0x5b8>
    800038a4:	0521                	addi	a0,a0,8
    800038a6:	00003097          	auipc	ra,0x3
    800038aa:	9b0080e7          	jalr	-1616(ra) # 80006256 <initlock>
  lk->name = name;
    800038ae:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800038b2:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800038b6:	0204a423          	sw	zero,40(s1)
}
    800038ba:	60e2                	ld	ra,24(sp)
    800038bc:	6442                	ld	s0,16(sp)
    800038be:	64a2                	ld	s1,8(sp)
    800038c0:	6902                	ld	s2,0(sp)
    800038c2:	6105                	addi	sp,sp,32
    800038c4:	8082                	ret

00000000800038c6 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800038c6:	1101                	addi	sp,sp,-32
    800038c8:	ec06                	sd	ra,24(sp)
    800038ca:	e822                	sd	s0,16(sp)
    800038cc:	e426                	sd	s1,8(sp)
    800038ce:	e04a                	sd	s2,0(sp)
    800038d0:	1000                	addi	s0,sp,32
    800038d2:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800038d4:	00850913          	addi	s2,a0,8
    800038d8:	854a                	mv	a0,s2
    800038da:	00003097          	auipc	ra,0x3
    800038de:	a0c080e7          	jalr	-1524(ra) # 800062e6 <acquire>
  while (lk->locked) {
    800038e2:	409c                	lw	a5,0(s1)
    800038e4:	cb89                	beqz	a5,800038f6 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800038e6:	85ca                	mv	a1,s2
    800038e8:	8526                	mv	a0,s1
    800038ea:	ffffe097          	auipc	ra,0xffffe
    800038ee:	caa080e7          	jalr	-854(ra) # 80001594 <sleep>
  while (lk->locked) {
    800038f2:	409c                	lw	a5,0(s1)
    800038f4:	fbed                	bnez	a5,800038e6 <acquiresleep+0x20>
  }
  lk->locked = 1;
    800038f6:	4785                	li	a5,1
    800038f8:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800038fa:	ffffd097          	auipc	ra,0xffffd
    800038fe:	5cc080e7          	jalr	1484(ra) # 80000ec6 <myproc>
    80003902:	591c                	lw	a5,48(a0)
    80003904:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003906:	854a                	mv	a0,s2
    80003908:	00003097          	auipc	ra,0x3
    8000390c:	a92080e7          	jalr	-1390(ra) # 8000639a <release>
}
    80003910:	60e2                	ld	ra,24(sp)
    80003912:	6442                	ld	s0,16(sp)
    80003914:	64a2                	ld	s1,8(sp)
    80003916:	6902                	ld	s2,0(sp)
    80003918:	6105                	addi	sp,sp,32
    8000391a:	8082                	ret

000000008000391c <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    8000391c:	1101                	addi	sp,sp,-32
    8000391e:	ec06                	sd	ra,24(sp)
    80003920:	e822                	sd	s0,16(sp)
    80003922:	e426                	sd	s1,8(sp)
    80003924:	e04a                	sd	s2,0(sp)
    80003926:	1000                	addi	s0,sp,32
    80003928:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000392a:	00850913          	addi	s2,a0,8
    8000392e:	854a                	mv	a0,s2
    80003930:	00003097          	auipc	ra,0x3
    80003934:	9b6080e7          	jalr	-1610(ra) # 800062e6 <acquire>
  lk->locked = 0;
    80003938:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000393c:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003940:	8526                	mv	a0,s1
    80003942:	ffffe097          	auipc	ra,0xffffe
    80003946:	dde080e7          	jalr	-546(ra) # 80001720 <wakeup>
  release(&lk->lk);
    8000394a:	854a                	mv	a0,s2
    8000394c:	00003097          	auipc	ra,0x3
    80003950:	a4e080e7          	jalr	-1458(ra) # 8000639a <release>
}
    80003954:	60e2                	ld	ra,24(sp)
    80003956:	6442                	ld	s0,16(sp)
    80003958:	64a2                	ld	s1,8(sp)
    8000395a:	6902                	ld	s2,0(sp)
    8000395c:	6105                	addi	sp,sp,32
    8000395e:	8082                	ret

0000000080003960 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003960:	7179                	addi	sp,sp,-48
    80003962:	f406                	sd	ra,40(sp)
    80003964:	f022                	sd	s0,32(sp)
    80003966:	ec26                	sd	s1,24(sp)
    80003968:	e84a                	sd	s2,16(sp)
    8000396a:	1800                	addi	s0,sp,48
    8000396c:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    8000396e:	00850913          	addi	s2,a0,8
    80003972:	854a                	mv	a0,s2
    80003974:	00003097          	auipc	ra,0x3
    80003978:	972080e7          	jalr	-1678(ra) # 800062e6 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    8000397c:	409c                	lw	a5,0(s1)
    8000397e:	ef91                	bnez	a5,8000399a <holdingsleep+0x3a>
    80003980:	4481                	li	s1,0
  release(&lk->lk);
    80003982:	854a                	mv	a0,s2
    80003984:	00003097          	auipc	ra,0x3
    80003988:	a16080e7          	jalr	-1514(ra) # 8000639a <release>
  return r;
}
    8000398c:	8526                	mv	a0,s1
    8000398e:	70a2                	ld	ra,40(sp)
    80003990:	7402                	ld	s0,32(sp)
    80003992:	64e2                	ld	s1,24(sp)
    80003994:	6942                	ld	s2,16(sp)
    80003996:	6145                	addi	sp,sp,48
    80003998:	8082                	ret
    8000399a:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    8000399c:	0284a983          	lw	s3,40(s1)
    800039a0:	ffffd097          	auipc	ra,0xffffd
    800039a4:	526080e7          	jalr	1318(ra) # 80000ec6 <myproc>
    800039a8:	5904                	lw	s1,48(a0)
    800039aa:	413484b3          	sub	s1,s1,s3
    800039ae:	0014b493          	seqz	s1,s1
    800039b2:	69a2                	ld	s3,8(sp)
    800039b4:	b7f9                	j	80003982 <holdingsleep+0x22>

00000000800039b6 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800039b6:	1141                	addi	sp,sp,-16
    800039b8:	e406                	sd	ra,8(sp)
    800039ba:	e022                	sd	s0,0(sp)
    800039bc:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800039be:	00005597          	auipc	a1,0x5
    800039c2:	c0a58593          	addi	a1,a1,-1014 # 800085c8 <etext+0x5c8>
    800039c6:	00015517          	auipc	a0,0x15
    800039ca:	7a250513          	addi	a0,a0,1954 # 80019168 <ftable>
    800039ce:	00003097          	auipc	ra,0x3
    800039d2:	888080e7          	jalr	-1912(ra) # 80006256 <initlock>
}
    800039d6:	60a2                	ld	ra,8(sp)
    800039d8:	6402                	ld	s0,0(sp)
    800039da:	0141                	addi	sp,sp,16
    800039dc:	8082                	ret

00000000800039de <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800039de:	1101                	addi	sp,sp,-32
    800039e0:	ec06                	sd	ra,24(sp)
    800039e2:	e822                	sd	s0,16(sp)
    800039e4:	e426                	sd	s1,8(sp)
    800039e6:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800039e8:	00015517          	auipc	a0,0x15
    800039ec:	78050513          	addi	a0,a0,1920 # 80019168 <ftable>
    800039f0:	00003097          	auipc	ra,0x3
    800039f4:	8f6080e7          	jalr	-1802(ra) # 800062e6 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800039f8:	00015497          	auipc	s1,0x15
    800039fc:	78848493          	addi	s1,s1,1928 # 80019180 <ftable+0x18>
    80003a00:	00016717          	auipc	a4,0x16
    80003a04:	72070713          	addi	a4,a4,1824 # 8001a120 <ftable+0xfb8>
    if(f->ref == 0){
    80003a08:	40dc                	lw	a5,4(s1)
    80003a0a:	cf99                	beqz	a5,80003a28 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003a0c:	02848493          	addi	s1,s1,40
    80003a10:	fee49ce3          	bne	s1,a4,80003a08 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003a14:	00015517          	auipc	a0,0x15
    80003a18:	75450513          	addi	a0,a0,1876 # 80019168 <ftable>
    80003a1c:	00003097          	auipc	ra,0x3
    80003a20:	97e080e7          	jalr	-1666(ra) # 8000639a <release>
  return 0;
    80003a24:	4481                	li	s1,0
    80003a26:	a819                	j	80003a3c <filealloc+0x5e>
      f->ref = 1;
    80003a28:	4785                	li	a5,1
    80003a2a:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003a2c:	00015517          	auipc	a0,0x15
    80003a30:	73c50513          	addi	a0,a0,1852 # 80019168 <ftable>
    80003a34:	00003097          	auipc	ra,0x3
    80003a38:	966080e7          	jalr	-1690(ra) # 8000639a <release>
}
    80003a3c:	8526                	mv	a0,s1
    80003a3e:	60e2                	ld	ra,24(sp)
    80003a40:	6442                	ld	s0,16(sp)
    80003a42:	64a2                	ld	s1,8(sp)
    80003a44:	6105                	addi	sp,sp,32
    80003a46:	8082                	ret

0000000080003a48 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003a48:	1101                	addi	sp,sp,-32
    80003a4a:	ec06                	sd	ra,24(sp)
    80003a4c:	e822                	sd	s0,16(sp)
    80003a4e:	e426                	sd	s1,8(sp)
    80003a50:	1000                	addi	s0,sp,32
    80003a52:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003a54:	00015517          	auipc	a0,0x15
    80003a58:	71450513          	addi	a0,a0,1812 # 80019168 <ftable>
    80003a5c:	00003097          	auipc	ra,0x3
    80003a60:	88a080e7          	jalr	-1910(ra) # 800062e6 <acquire>
  if(f->ref < 1)
    80003a64:	40dc                	lw	a5,4(s1)
    80003a66:	02f05263          	blez	a5,80003a8a <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003a6a:	2785                	addiw	a5,a5,1
    80003a6c:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003a6e:	00015517          	auipc	a0,0x15
    80003a72:	6fa50513          	addi	a0,a0,1786 # 80019168 <ftable>
    80003a76:	00003097          	auipc	ra,0x3
    80003a7a:	924080e7          	jalr	-1756(ra) # 8000639a <release>
  return f;
}
    80003a7e:	8526                	mv	a0,s1
    80003a80:	60e2                	ld	ra,24(sp)
    80003a82:	6442                	ld	s0,16(sp)
    80003a84:	64a2                	ld	s1,8(sp)
    80003a86:	6105                	addi	sp,sp,32
    80003a88:	8082                	ret
    panic("filedup");
    80003a8a:	00005517          	auipc	a0,0x5
    80003a8e:	b4650513          	addi	a0,a0,-1210 # 800085d0 <etext+0x5d0>
    80003a92:	00002097          	auipc	ra,0x2
    80003a96:	2da080e7          	jalr	730(ra) # 80005d6c <panic>

0000000080003a9a <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003a9a:	7139                	addi	sp,sp,-64
    80003a9c:	fc06                	sd	ra,56(sp)
    80003a9e:	f822                	sd	s0,48(sp)
    80003aa0:	f426                	sd	s1,40(sp)
    80003aa2:	0080                	addi	s0,sp,64
    80003aa4:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003aa6:	00015517          	auipc	a0,0x15
    80003aaa:	6c250513          	addi	a0,a0,1730 # 80019168 <ftable>
    80003aae:	00003097          	auipc	ra,0x3
    80003ab2:	838080e7          	jalr	-1992(ra) # 800062e6 <acquire>
  if(f->ref < 1)
    80003ab6:	40dc                	lw	a5,4(s1)
    80003ab8:	04f05c63          	blez	a5,80003b10 <fileclose+0x76>
    panic("fileclose");
  if(--f->ref > 0){
    80003abc:	37fd                	addiw	a5,a5,-1
    80003abe:	0007871b          	sext.w	a4,a5
    80003ac2:	c0dc                	sw	a5,4(s1)
    80003ac4:	06e04263          	bgtz	a4,80003b28 <fileclose+0x8e>
    80003ac8:	f04a                	sd	s2,32(sp)
    80003aca:	ec4e                	sd	s3,24(sp)
    80003acc:	e852                	sd	s4,16(sp)
    80003ace:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003ad0:	0004a903          	lw	s2,0(s1)
    80003ad4:	0094ca83          	lbu	s5,9(s1)
    80003ad8:	0104ba03          	ld	s4,16(s1)
    80003adc:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003ae0:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003ae4:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003ae8:	00015517          	auipc	a0,0x15
    80003aec:	68050513          	addi	a0,a0,1664 # 80019168 <ftable>
    80003af0:	00003097          	auipc	ra,0x3
    80003af4:	8aa080e7          	jalr	-1878(ra) # 8000639a <release>

  if(ff.type == FD_PIPE){
    80003af8:	4785                	li	a5,1
    80003afa:	04f90463          	beq	s2,a5,80003b42 <fileclose+0xa8>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003afe:	3979                	addiw	s2,s2,-2
    80003b00:	4785                	li	a5,1
    80003b02:	0527fb63          	bgeu	a5,s2,80003b58 <fileclose+0xbe>
    80003b06:	7902                	ld	s2,32(sp)
    80003b08:	69e2                	ld	s3,24(sp)
    80003b0a:	6a42                	ld	s4,16(sp)
    80003b0c:	6aa2                	ld	s5,8(sp)
    80003b0e:	a02d                	j	80003b38 <fileclose+0x9e>
    80003b10:	f04a                	sd	s2,32(sp)
    80003b12:	ec4e                	sd	s3,24(sp)
    80003b14:	e852                	sd	s4,16(sp)
    80003b16:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80003b18:	00005517          	auipc	a0,0x5
    80003b1c:	ac050513          	addi	a0,a0,-1344 # 800085d8 <etext+0x5d8>
    80003b20:	00002097          	auipc	ra,0x2
    80003b24:	24c080e7          	jalr	588(ra) # 80005d6c <panic>
    release(&ftable.lock);
    80003b28:	00015517          	auipc	a0,0x15
    80003b2c:	64050513          	addi	a0,a0,1600 # 80019168 <ftable>
    80003b30:	00003097          	auipc	ra,0x3
    80003b34:	86a080e7          	jalr	-1942(ra) # 8000639a <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80003b38:	70e2                	ld	ra,56(sp)
    80003b3a:	7442                	ld	s0,48(sp)
    80003b3c:	74a2                	ld	s1,40(sp)
    80003b3e:	6121                	addi	sp,sp,64
    80003b40:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003b42:	85d6                	mv	a1,s5
    80003b44:	8552                	mv	a0,s4
    80003b46:	00000097          	auipc	ra,0x0
    80003b4a:	3a2080e7          	jalr	930(ra) # 80003ee8 <pipeclose>
    80003b4e:	7902                	ld	s2,32(sp)
    80003b50:	69e2                	ld	s3,24(sp)
    80003b52:	6a42                	ld	s4,16(sp)
    80003b54:	6aa2                	ld	s5,8(sp)
    80003b56:	b7cd                	j	80003b38 <fileclose+0x9e>
    begin_op();
    80003b58:	00000097          	auipc	ra,0x0
    80003b5c:	a78080e7          	jalr	-1416(ra) # 800035d0 <begin_op>
    iput(ff.ip);
    80003b60:	854e                	mv	a0,s3
    80003b62:	fffff097          	auipc	ra,0xfffff
    80003b66:	25a080e7          	jalr	602(ra) # 80002dbc <iput>
    end_op();
    80003b6a:	00000097          	auipc	ra,0x0
    80003b6e:	ae0080e7          	jalr	-1312(ra) # 8000364a <end_op>
    80003b72:	7902                	ld	s2,32(sp)
    80003b74:	69e2                	ld	s3,24(sp)
    80003b76:	6a42                	ld	s4,16(sp)
    80003b78:	6aa2                	ld	s5,8(sp)
    80003b7a:	bf7d                	j	80003b38 <fileclose+0x9e>

0000000080003b7c <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003b7c:	715d                	addi	sp,sp,-80
    80003b7e:	e486                	sd	ra,72(sp)
    80003b80:	e0a2                	sd	s0,64(sp)
    80003b82:	fc26                	sd	s1,56(sp)
    80003b84:	f44e                	sd	s3,40(sp)
    80003b86:	0880                	addi	s0,sp,80
    80003b88:	84aa                	mv	s1,a0
    80003b8a:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003b8c:	ffffd097          	auipc	ra,0xffffd
    80003b90:	33a080e7          	jalr	826(ra) # 80000ec6 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003b94:	409c                	lw	a5,0(s1)
    80003b96:	37f9                	addiw	a5,a5,-2
    80003b98:	4705                	li	a4,1
    80003b9a:	04f76863          	bltu	a4,a5,80003bea <filestat+0x6e>
    80003b9e:	f84a                	sd	s2,48(sp)
    80003ba0:	892a                	mv	s2,a0
    ilock(f->ip);
    80003ba2:	6c88                	ld	a0,24(s1)
    80003ba4:	fffff097          	auipc	ra,0xfffff
    80003ba8:	05a080e7          	jalr	90(ra) # 80002bfe <ilock>
    stati(f->ip, &st);
    80003bac:	fb840593          	addi	a1,s0,-72
    80003bb0:	6c88                	ld	a0,24(s1)
    80003bb2:	fffff097          	auipc	ra,0xfffff
    80003bb6:	2da080e7          	jalr	730(ra) # 80002e8c <stati>
    iunlock(f->ip);
    80003bba:	6c88                	ld	a0,24(s1)
    80003bbc:	fffff097          	auipc	ra,0xfffff
    80003bc0:	108080e7          	jalr	264(ra) # 80002cc4 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003bc4:	46e1                	li	a3,24
    80003bc6:	fb840613          	addi	a2,s0,-72
    80003bca:	85ce                	mv	a1,s3
    80003bcc:	05093503          	ld	a0,80(s2)
    80003bd0:	ffffd097          	auipc	ra,0xffffd
    80003bd4:	f92080e7          	jalr	-110(ra) # 80000b62 <copyout>
    80003bd8:	41f5551b          	sraiw	a0,a0,0x1f
    80003bdc:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80003bde:	60a6                	ld	ra,72(sp)
    80003be0:	6406                	ld	s0,64(sp)
    80003be2:	74e2                	ld	s1,56(sp)
    80003be4:	79a2                	ld	s3,40(sp)
    80003be6:	6161                	addi	sp,sp,80
    80003be8:	8082                	ret
  return -1;
    80003bea:	557d                	li	a0,-1
    80003bec:	bfcd                	j	80003bde <filestat+0x62>

0000000080003bee <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003bee:	7179                	addi	sp,sp,-48
    80003bf0:	f406                	sd	ra,40(sp)
    80003bf2:	f022                	sd	s0,32(sp)
    80003bf4:	e84a                	sd	s2,16(sp)
    80003bf6:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003bf8:	00854783          	lbu	a5,8(a0)
    80003bfc:	cbc5                	beqz	a5,80003cac <fileread+0xbe>
    80003bfe:	ec26                	sd	s1,24(sp)
    80003c00:	e44e                	sd	s3,8(sp)
    80003c02:	84aa                	mv	s1,a0
    80003c04:	89ae                	mv	s3,a1
    80003c06:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003c08:	411c                	lw	a5,0(a0)
    80003c0a:	4705                	li	a4,1
    80003c0c:	04e78963          	beq	a5,a4,80003c5e <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003c10:	470d                	li	a4,3
    80003c12:	04e78f63          	beq	a5,a4,80003c70 <fileread+0x82>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003c16:	4709                	li	a4,2
    80003c18:	08e79263          	bne	a5,a4,80003c9c <fileread+0xae>
    ilock(f->ip);
    80003c1c:	6d08                	ld	a0,24(a0)
    80003c1e:	fffff097          	auipc	ra,0xfffff
    80003c22:	fe0080e7          	jalr	-32(ra) # 80002bfe <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003c26:	874a                	mv	a4,s2
    80003c28:	5094                	lw	a3,32(s1)
    80003c2a:	864e                	mv	a2,s3
    80003c2c:	4585                	li	a1,1
    80003c2e:	6c88                	ld	a0,24(s1)
    80003c30:	fffff097          	auipc	ra,0xfffff
    80003c34:	286080e7          	jalr	646(ra) # 80002eb6 <readi>
    80003c38:	892a                	mv	s2,a0
    80003c3a:	00a05563          	blez	a0,80003c44 <fileread+0x56>
      f->off += r;
    80003c3e:	509c                	lw	a5,32(s1)
    80003c40:	9fa9                	addw	a5,a5,a0
    80003c42:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003c44:	6c88                	ld	a0,24(s1)
    80003c46:	fffff097          	auipc	ra,0xfffff
    80003c4a:	07e080e7          	jalr	126(ra) # 80002cc4 <iunlock>
    80003c4e:	64e2                	ld	s1,24(sp)
    80003c50:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80003c52:	854a                	mv	a0,s2
    80003c54:	70a2                	ld	ra,40(sp)
    80003c56:	7402                	ld	s0,32(sp)
    80003c58:	6942                	ld	s2,16(sp)
    80003c5a:	6145                	addi	sp,sp,48
    80003c5c:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003c5e:	6908                	ld	a0,16(a0)
    80003c60:	00000097          	auipc	ra,0x0
    80003c64:	3fa080e7          	jalr	1018(ra) # 8000405a <piperead>
    80003c68:	892a                	mv	s2,a0
    80003c6a:	64e2                	ld	s1,24(sp)
    80003c6c:	69a2                	ld	s3,8(sp)
    80003c6e:	b7d5                	j	80003c52 <fileread+0x64>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003c70:	02451783          	lh	a5,36(a0)
    80003c74:	03079693          	slli	a3,a5,0x30
    80003c78:	92c1                	srli	a3,a3,0x30
    80003c7a:	4725                	li	a4,9
    80003c7c:	02d76a63          	bltu	a4,a3,80003cb0 <fileread+0xc2>
    80003c80:	0792                	slli	a5,a5,0x4
    80003c82:	00015717          	auipc	a4,0x15
    80003c86:	44670713          	addi	a4,a4,1094 # 800190c8 <devsw>
    80003c8a:	97ba                	add	a5,a5,a4
    80003c8c:	639c                	ld	a5,0(a5)
    80003c8e:	c78d                	beqz	a5,80003cb8 <fileread+0xca>
    r = devsw[f->major].read(1, addr, n);
    80003c90:	4505                	li	a0,1
    80003c92:	9782                	jalr	a5
    80003c94:	892a                	mv	s2,a0
    80003c96:	64e2                	ld	s1,24(sp)
    80003c98:	69a2                	ld	s3,8(sp)
    80003c9a:	bf65                	j	80003c52 <fileread+0x64>
    panic("fileread");
    80003c9c:	00005517          	auipc	a0,0x5
    80003ca0:	94c50513          	addi	a0,a0,-1716 # 800085e8 <etext+0x5e8>
    80003ca4:	00002097          	auipc	ra,0x2
    80003ca8:	0c8080e7          	jalr	200(ra) # 80005d6c <panic>
    return -1;
    80003cac:	597d                	li	s2,-1
    80003cae:	b755                	j	80003c52 <fileread+0x64>
      return -1;
    80003cb0:	597d                	li	s2,-1
    80003cb2:	64e2                	ld	s1,24(sp)
    80003cb4:	69a2                	ld	s3,8(sp)
    80003cb6:	bf71                	j	80003c52 <fileread+0x64>
    80003cb8:	597d                	li	s2,-1
    80003cba:	64e2                	ld	s1,24(sp)
    80003cbc:	69a2                	ld	s3,8(sp)
    80003cbe:	bf51                	j	80003c52 <fileread+0x64>

0000000080003cc0 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003cc0:	00954783          	lbu	a5,9(a0)
    80003cc4:	12078963          	beqz	a5,80003df6 <filewrite+0x136>
{
    80003cc8:	715d                	addi	sp,sp,-80
    80003cca:	e486                	sd	ra,72(sp)
    80003ccc:	e0a2                	sd	s0,64(sp)
    80003cce:	f84a                	sd	s2,48(sp)
    80003cd0:	f052                	sd	s4,32(sp)
    80003cd2:	e85a                	sd	s6,16(sp)
    80003cd4:	0880                	addi	s0,sp,80
    80003cd6:	892a                	mv	s2,a0
    80003cd8:	8b2e                	mv	s6,a1
    80003cda:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003cdc:	411c                	lw	a5,0(a0)
    80003cde:	4705                	li	a4,1
    80003ce0:	02e78763          	beq	a5,a4,80003d0e <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003ce4:	470d                	li	a4,3
    80003ce6:	02e78a63          	beq	a5,a4,80003d1a <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003cea:	4709                	li	a4,2
    80003cec:	0ee79863          	bne	a5,a4,80003ddc <filewrite+0x11c>
    80003cf0:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003cf2:	0cc05463          	blez	a2,80003dba <filewrite+0xfa>
    80003cf6:	fc26                	sd	s1,56(sp)
    80003cf8:	ec56                	sd	s5,24(sp)
    80003cfa:	e45e                	sd	s7,8(sp)
    80003cfc:	e062                	sd	s8,0(sp)
    int i = 0;
    80003cfe:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80003d00:	6b85                	lui	s7,0x1
    80003d02:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003d06:	6c05                	lui	s8,0x1
    80003d08:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003d0c:	a851                	j	80003da0 <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80003d0e:	6908                	ld	a0,16(a0)
    80003d10:	00000097          	auipc	ra,0x0
    80003d14:	248080e7          	jalr	584(ra) # 80003f58 <pipewrite>
    80003d18:	a85d                	j	80003dce <filewrite+0x10e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003d1a:	02451783          	lh	a5,36(a0)
    80003d1e:	03079693          	slli	a3,a5,0x30
    80003d22:	92c1                	srli	a3,a3,0x30
    80003d24:	4725                	li	a4,9
    80003d26:	0cd76a63          	bltu	a4,a3,80003dfa <filewrite+0x13a>
    80003d2a:	0792                	slli	a5,a5,0x4
    80003d2c:	00015717          	auipc	a4,0x15
    80003d30:	39c70713          	addi	a4,a4,924 # 800190c8 <devsw>
    80003d34:	97ba                	add	a5,a5,a4
    80003d36:	679c                	ld	a5,8(a5)
    80003d38:	c3f9                	beqz	a5,80003dfe <filewrite+0x13e>
    ret = devsw[f->major].write(1, addr, n);
    80003d3a:	4505                	li	a0,1
    80003d3c:	9782                	jalr	a5
    80003d3e:	a841                	j	80003dce <filewrite+0x10e>
      if(n1 > max)
    80003d40:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80003d44:	00000097          	auipc	ra,0x0
    80003d48:	88c080e7          	jalr	-1908(ra) # 800035d0 <begin_op>
      ilock(f->ip);
    80003d4c:	01893503          	ld	a0,24(s2)
    80003d50:	fffff097          	auipc	ra,0xfffff
    80003d54:	eae080e7          	jalr	-338(ra) # 80002bfe <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003d58:	8756                	mv	a4,s5
    80003d5a:	02092683          	lw	a3,32(s2)
    80003d5e:	01698633          	add	a2,s3,s6
    80003d62:	4585                	li	a1,1
    80003d64:	01893503          	ld	a0,24(s2)
    80003d68:	fffff097          	auipc	ra,0xfffff
    80003d6c:	252080e7          	jalr	594(ra) # 80002fba <writei>
    80003d70:	84aa                	mv	s1,a0
    80003d72:	00a05763          	blez	a0,80003d80 <filewrite+0xc0>
        f->off += r;
    80003d76:	02092783          	lw	a5,32(s2)
    80003d7a:	9fa9                	addw	a5,a5,a0
    80003d7c:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003d80:	01893503          	ld	a0,24(s2)
    80003d84:	fffff097          	auipc	ra,0xfffff
    80003d88:	f40080e7          	jalr	-192(ra) # 80002cc4 <iunlock>
      end_op();
    80003d8c:	00000097          	auipc	ra,0x0
    80003d90:	8be080e7          	jalr	-1858(ra) # 8000364a <end_op>

      if(r != n1){
    80003d94:	029a9563          	bne	s5,s1,80003dbe <filewrite+0xfe>
        // error from writei
        break;
      }
      i += r;
    80003d98:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003d9c:	0149da63          	bge	s3,s4,80003db0 <filewrite+0xf0>
      int n1 = n - i;
    80003da0:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80003da4:	0004879b          	sext.w	a5,s1
    80003da8:	f8fbdce3          	bge	s7,a5,80003d40 <filewrite+0x80>
    80003dac:	84e2                	mv	s1,s8
    80003dae:	bf49                	j	80003d40 <filewrite+0x80>
    80003db0:	74e2                	ld	s1,56(sp)
    80003db2:	6ae2                	ld	s5,24(sp)
    80003db4:	6ba2                	ld	s7,8(sp)
    80003db6:	6c02                	ld	s8,0(sp)
    80003db8:	a039                	j	80003dc6 <filewrite+0x106>
    int i = 0;
    80003dba:	4981                	li	s3,0
    80003dbc:	a029                	j	80003dc6 <filewrite+0x106>
    80003dbe:	74e2                	ld	s1,56(sp)
    80003dc0:	6ae2                	ld	s5,24(sp)
    80003dc2:	6ba2                	ld	s7,8(sp)
    80003dc4:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    80003dc6:	033a1e63          	bne	s4,s3,80003e02 <filewrite+0x142>
    80003dca:	8552                	mv	a0,s4
    80003dcc:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003dce:	60a6                	ld	ra,72(sp)
    80003dd0:	6406                	ld	s0,64(sp)
    80003dd2:	7942                	ld	s2,48(sp)
    80003dd4:	7a02                	ld	s4,32(sp)
    80003dd6:	6b42                	ld	s6,16(sp)
    80003dd8:	6161                	addi	sp,sp,80
    80003dda:	8082                	ret
    80003ddc:	fc26                	sd	s1,56(sp)
    80003dde:	f44e                	sd	s3,40(sp)
    80003de0:	ec56                	sd	s5,24(sp)
    80003de2:	e45e                	sd	s7,8(sp)
    80003de4:	e062                	sd	s8,0(sp)
    panic("filewrite");
    80003de6:	00005517          	auipc	a0,0x5
    80003dea:	81250513          	addi	a0,a0,-2030 # 800085f8 <etext+0x5f8>
    80003dee:	00002097          	auipc	ra,0x2
    80003df2:	f7e080e7          	jalr	-130(ra) # 80005d6c <panic>
    return -1;
    80003df6:	557d                	li	a0,-1
}
    80003df8:	8082                	ret
      return -1;
    80003dfa:	557d                	li	a0,-1
    80003dfc:	bfc9                	j	80003dce <filewrite+0x10e>
    80003dfe:	557d                	li	a0,-1
    80003e00:	b7f9                	j	80003dce <filewrite+0x10e>
    ret = (i == n ? n : -1);
    80003e02:	557d                	li	a0,-1
    80003e04:	79a2                	ld	s3,40(sp)
    80003e06:	b7e1                	j	80003dce <filewrite+0x10e>

0000000080003e08 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003e08:	7179                	addi	sp,sp,-48
    80003e0a:	f406                	sd	ra,40(sp)
    80003e0c:	f022                	sd	s0,32(sp)
    80003e0e:	ec26                	sd	s1,24(sp)
    80003e10:	e052                	sd	s4,0(sp)
    80003e12:	1800                	addi	s0,sp,48
    80003e14:	84aa                	mv	s1,a0
    80003e16:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003e18:	0005b023          	sd	zero,0(a1)
    80003e1c:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003e20:	00000097          	auipc	ra,0x0
    80003e24:	bbe080e7          	jalr	-1090(ra) # 800039de <filealloc>
    80003e28:	e088                	sd	a0,0(s1)
    80003e2a:	cd49                	beqz	a0,80003ec4 <pipealloc+0xbc>
    80003e2c:	00000097          	auipc	ra,0x0
    80003e30:	bb2080e7          	jalr	-1102(ra) # 800039de <filealloc>
    80003e34:	00aa3023          	sd	a0,0(s4)
    80003e38:	c141                	beqz	a0,80003eb8 <pipealloc+0xb0>
    80003e3a:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003e3c:	ffffc097          	auipc	ra,0xffffc
    80003e40:	2de080e7          	jalr	734(ra) # 8000011a <kalloc>
    80003e44:	892a                	mv	s2,a0
    80003e46:	c13d                	beqz	a0,80003eac <pipealloc+0xa4>
    80003e48:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80003e4a:	4985                	li	s3,1
    80003e4c:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003e50:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003e54:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003e58:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003e5c:	00004597          	auipc	a1,0x4
    80003e60:	55458593          	addi	a1,a1,1364 # 800083b0 <etext+0x3b0>
    80003e64:	00002097          	auipc	ra,0x2
    80003e68:	3f2080e7          	jalr	1010(ra) # 80006256 <initlock>
  (*f0)->type = FD_PIPE;
    80003e6c:	609c                	ld	a5,0(s1)
    80003e6e:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003e72:	609c                	ld	a5,0(s1)
    80003e74:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003e78:	609c                	ld	a5,0(s1)
    80003e7a:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003e7e:	609c                	ld	a5,0(s1)
    80003e80:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003e84:	000a3783          	ld	a5,0(s4)
    80003e88:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003e8c:	000a3783          	ld	a5,0(s4)
    80003e90:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003e94:	000a3783          	ld	a5,0(s4)
    80003e98:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003e9c:	000a3783          	ld	a5,0(s4)
    80003ea0:	0127b823          	sd	s2,16(a5)
  return 0;
    80003ea4:	4501                	li	a0,0
    80003ea6:	6942                	ld	s2,16(sp)
    80003ea8:	69a2                	ld	s3,8(sp)
    80003eaa:	a03d                	j	80003ed8 <pipealloc+0xd0>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003eac:	6088                	ld	a0,0(s1)
    80003eae:	c119                	beqz	a0,80003eb4 <pipealloc+0xac>
    80003eb0:	6942                	ld	s2,16(sp)
    80003eb2:	a029                	j	80003ebc <pipealloc+0xb4>
    80003eb4:	6942                	ld	s2,16(sp)
    80003eb6:	a039                	j	80003ec4 <pipealloc+0xbc>
    80003eb8:	6088                	ld	a0,0(s1)
    80003eba:	c50d                	beqz	a0,80003ee4 <pipealloc+0xdc>
    fileclose(*f0);
    80003ebc:	00000097          	auipc	ra,0x0
    80003ec0:	bde080e7          	jalr	-1058(ra) # 80003a9a <fileclose>
  if(*f1)
    80003ec4:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003ec8:	557d                	li	a0,-1
  if(*f1)
    80003eca:	c799                	beqz	a5,80003ed8 <pipealloc+0xd0>
    fileclose(*f1);
    80003ecc:	853e                	mv	a0,a5
    80003ece:	00000097          	auipc	ra,0x0
    80003ed2:	bcc080e7          	jalr	-1076(ra) # 80003a9a <fileclose>
  return -1;
    80003ed6:	557d                	li	a0,-1
}
    80003ed8:	70a2                	ld	ra,40(sp)
    80003eda:	7402                	ld	s0,32(sp)
    80003edc:	64e2                	ld	s1,24(sp)
    80003ede:	6a02                	ld	s4,0(sp)
    80003ee0:	6145                	addi	sp,sp,48
    80003ee2:	8082                	ret
  return -1;
    80003ee4:	557d                	li	a0,-1
    80003ee6:	bfcd                	j	80003ed8 <pipealloc+0xd0>

0000000080003ee8 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003ee8:	1101                	addi	sp,sp,-32
    80003eea:	ec06                	sd	ra,24(sp)
    80003eec:	e822                	sd	s0,16(sp)
    80003eee:	e426                	sd	s1,8(sp)
    80003ef0:	e04a                	sd	s2,0(sp)
    80003ef2:	1000                	addi	s0,sp,32
    80003ef4:	84aa                	mv	s1,a0
    80003ef6:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003ef8:	00002097          	auipc	ra,0x2
    80003efc:	3ee080e7          	jalr	1006(ra) # 800062e6 <acquire>
  if(writable){
    80003f00:	02090d63          	beqz	s2,80003f3a <pipeclose+0x52>
    pi->writeopen = 0;
    80003f04:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003f08:	21848513          	addi	a0,s1,536
    80003f0c:	ffffe097          	auipc	ra,0xffffe
    80003f10:	814080e7          	jalr	-2028(ra) # 80001720 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003f14:	2204b783          	ld	a5,544(s1)
    80003f18:	eb95                	bnez	a5,80003f4c <pipeclose+0x64>
    release(&pi->lock);
    80003f1a:	8526                	mv	a0,s1
    80003f1c:	00002097          	auipc	ra,0x2
    80003f20:	47e080e7          	jalr	1150(ra) # 8000639a <release>
    kfree((char*)pi);
    80003f24:	8526                	mv	a0,s1
    80003f26:	ffffc097          	auipc	ra,0xffffc
    80003f2a:	0f6080e7          	jalr	246(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003f2e:	60e2                	ld	ra,24(sp)
    80003f30:	6442                	ld	s0,16(sp)
    80003f32:	64a2                	ld	s1,8(sp)
    80003f34:	6902                	ld	s2,0(sp)
    80003f36:	6105                	addi	sp,sp,32
    80003f38:	8082                	ret
    pi->readopen = 0;
    80003f3a:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003f3e:	21c48513          	addi	a0,s1,540
    80003f42:	ffffd097          	auipc	ra,0xffffd
    80003f46:	7de080e7          	jalr	2014(ra) # 80001720 <wakeup>
    80003f4a:	b7e9                	j	80003f14 <pipeclose+0x2c>
    release(&pi->lock);
    80003f4c:	8526                	mv	a0,s1
    80003f4e:	00002097          	auipc	ra,0x2
    80003f52:	44c080e7          	jalr	1100(ra) # 8000639a <release>
}
    80003f56:	bfe1                	j	80003f2e <pipeclose+0x46>

0000000080003f58 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003f58:	711d                	addi	sp,sp,-96
    80003f5a:	ec86                	sd	ra,88(sp)
    80003f5c:	e8a2                	sd	s0,80(sp)
    80003f5e:	e4a6                	sd	s1,72(sp)
    80003f60:	e0ca                	sd	s2,64(sp)
    80003f62:	fc4e                	sd	s3,56(sp)
    80003f64:	f852                	sd	s4,48(sp)
    80003f66:	f456                	sd	s5,40(sp)
    80003f68:	1080                	addi	s0,sp,96
    80003f6a:	84aa                	mv	s1,a0
    80003f6c:	8aae                	mv	s5,a1
    80003f6e:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003f70:	ffffd097          	auipc	ra,0xffffd
    80003f74:	f56080e7          	jalr	-170(ra) # 80000ec6 <myproc>
    80003f78:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003f7a:	8526                	mv	a0,s1
    80003f7c:	00002097          	auipc	ra,0x2
    80003f80:	36a080e7          	jalr	874(ra) # 800062e6 <acquire>
  while(i < n){
    80003f84:	0d405563          	blez	s4,8000404e <pipewrite+0xf6>
    80003f88:	f05a                	sd	s6,32(sp)
    80003f8a:	ec5e                	sd	s7,24(sp)
    80003f8c:	e862                	sd	s8,16(sp)
  int i = 0;
    80003f8e:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f90:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003f92:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003f96:	21c48b93          	addi	s7,s1,540
    80003f9a:	a089                	j	80003fdc <pipewrite+0x84>
      release(&pi->lock);
    80003f9c:	8526                	mv	a0,s1
    80003f9e:	00002097          	auipc	ra,0x2
    80003fa2:	3fc080e7          	jalr	1020(ra) # 8000639a <release>
      return -1;
    80003fa6:	597d                	li	s2,-1
    80003fa8:	7b02                	ld	s6,32(sp)
    80003faa:	6be2                	ld	s7,24(sp)
    80003fac:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003fae:	854a                	mv	a0,s2
    80003fb0:	60e6                	ld	ra,88(sp)
    80003fb2:	6446                	ld	s0,80(sp)
    80003fb4:	64a6                	ld	s1,72(sp)
    80003fb6:	6906                	ld	s2,64(sp)
    80003fb8:	79e2                	ld	s3,56(sp)
    80003fba:	7a42                	ld	s4,48(sp)
    80003fbc:	7aa2                	ld	s5,40(sp)
    80003fbe:	6125                	addi	sp,sp,96
    80003fc0:	8082                	ret
      wakeup(&pi->nread);
    80003fc2:	8562                	mv	a0,s8
    80003fc4:	ffffd097          	auipc	ra,0xffffd
    80003fc8:	75c080e7          	jalr	1884(ra) # 80001720 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003fcc:	85a6                	mv	a1,s1
    80003fce:	855e                	mv	a0,s7
    80003fd0:	ffffd097          	auipc	ra,0xffffd
    80003fd4:	5c4080e7          	jalr	1476(ra) # 80001594 <sleep>
  while(i < n){
    80003fd8:	05495c63          	bge	s2,s4,80004030 <pipewrite+0xd8>
    if(pi->readopen == 0 || pr->killed){
    80003fdc:	2204a783          	lw	a5,544(s1)
    80003fe0:	dfd5                	beqz	a5,80003f9c <pipewrite+0x44>
    80003fe2:	0289a783          	lw	a5,40(s3)
    80003fe6:	fbdd                	bnez	a5,80003f9c <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003fe8:	2184a783          	lw	a5,536(s1)
    80003fec:	21c4a703          	lw	a4,540(s1)
    80003ff0:	2007879b          	addiw	a5,a5,512
    80003ff4:	fcf707e3          	beq	a4,a5,80003fc2 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003ff8:	4685                	li	a3,1
    80003ffa:	01590633          	add	a2,s2,s5
    80003ffe:	faf40593          	addi	a1,s0,-81
    80004002:	0509b503          	ld	a0,80(s3)
    80004006:	ffffd097          	auipc	ra,0xffffd
    8000400a:	be8080e7          	jalr	-1048(ra) # 80000bee <copyin>
    8000400e:	05650263          	beq	a0,s6,80004052 <pipewrite+0xfa>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004012:	21c4a783          	lw	a5,540(s1)
    80004016:	0017871b          	addiw	a4,a5,1
    8000401a:	20e4ae23          	sw	a4,540(s1)
    8000401e:	1ff7f793          	andi	a5,a5,511
    80004022:	97a6                	add	a5,a5,s1
    80004024:	faf44703          	lbu	a4,-81(s0)
    80004028:	00e78c23          	sb	a4,24(a5)
      i++;
    8000402c:	2905                	addiw	s2,s2,1
    8000402e:	b76d                	j	80003fd8 <pipewrite+0x80>
    80004030:	7b02                	ld	s6,32(sp)
    80004032:	6be2                	ld	s7,24(sp)
    80004034:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    80004036:	21848513          	addi	a0,s1,536
    8000403a:	ffffd097          	auipc	ra,0xffffd
    8000403e:	6e6080e7          	jalr	1766(ra) # 80001720 <wakeup>
  release(&pi->lock);
    80004042:	8526                	mv	a0,s1
    80004044:	00002097          	auipc	ra,0x2
    80004048:	356080e7          	jalr	854(ra) # 8000639a <release>
  return i;
    8000404c:	b78d                	j	80003fae <pipewrite+0x56>
  int i = 0;
    8000404e:	4901                	li	s2,0
    80004050:	b7dd                	j	80004036 <pipewrite+0xde>
    80004052:	7b02                	ld	s6,32(sp)
    80004054:	6be2                	ld	s7,24(sp)
    80004056:	6c42                	ld	s8,16(sp)
    80004058:	bff9                	j	80004036 <pipewrite+0xde>

000000008000405a <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    8000405a:	715d                	addi	sp,sp,-80
    8000405c:	e486                	sd	ra,72(sp)
    8000405e:	e0a2                	sd	s0,64(sp)
    80004060:	fc26                	sd	s1,56(sp)
    80004062:	f84a                	sd	s2,48(sp)
    80004064:	f44e                	sd	s3,40(sp)
    80004066:	f052                	sd	s4,32(sp)
    80004068:	ec56                	sd	s5,24(sp)
    8000406a:	0880                	addi	s0,sp,80
    8000406c:	84aa                	mv	s1,a0
    8000406e:	892e                	mv	s2,a1
    80004070:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004072:	ffffd097          	auipc	ra,0xffffd
    80004076:	e54080e7          	jalr	-428(ra) # 80000ec6 <myproc>
    8000407a:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    8000407c:	8526                	mv	a0,s1
    8000407e:	00002097          	auipc	ra,0x2
    80004082:	268080e7          	jalr	616(ra) # 800062e6 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004086:	2184a703          	lw	a4,536(s1)
    8000408a:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000408e:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004092:	02f71663          	bne	a4,a5,800040be <piperead+0x64>
    80004096:	2244a783          	lw	a5,548(s1)
    8000409a:	cb9d                	beqz	a5,800040d0 <piperead+0x76>
    if(pr->killed){
    8000409c:	028a2783          	lw	a5,40(s4)
    800040a0:	e38d                	bnez	a5,800040c2 <piperead+0x68>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800040a2:	85a6                	mv	a1,s1
    800040a4:	854e                	mv	a0,s3
    800040a6:	ffffd097          	auipc	ra,0xffffd
    800040aa:	4ee080e7          	jalr	1262(ra) # 80001594 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040ae:	2184a703          	lw	a4,536(s1)
    800040b2:	21c4a783          	lw	a5,540(s1)
    800040b6:	fef700e3          	beq	a4,a5,80004096 <piperead+0x3c>
    800040ba:	e85a                	sd	s6,16(sp)
    800040bc:	a819                	j	800040d2 <piperead+0x78>
    800040be:	e85a                	sd	s6,16(sp)
    800040c0:	a809                	j	800040d2 <piperead+0x78>
      release(&pi->lock);
    800040c2:	8526                	mv	a0,s1
    800040c4:	00002097          	auipc	ra,0x2
    800040c8:	2d6080e7          	jalr	726(ra) # 8000639a <release>
      return -1;
    800040cc:	59fd                	li	s3,-1
    800040ce:	a0a5                	j	80004136 <piperead+0xdc>
    800040d0:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040d2:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800040d4:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040d6:	05505463          	blez	s5,8000411e <piperead+0xc4>
    if(pi->nread == pi->nwrite)
    800040da:	2184a783          	lw	a5,536(s1)
    800040de:	21c4a703          	lw	a4,540(s1)
    800040e2:	02f70e63          	beq	a4,a5,8000411e <piperead+0xc4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800040e6:	0017871b          	addiw	a4,a5,1
    800040ea:	20e4ac23          	sw	a4,536(s1)
    800040ee:	1ff7f793          	andi	a5,a5,511
    800040f2:	97a6                	add	a5,a5,s1
    800040f4:	0187c783          	lbu	a5,24(a5)
    800040f8:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800040fc:	4685                	li	a3,1
    800040fe:	fbf40613          	addi	a2,s0,-65
    80004102:	85ca                	mv	a1,s2
    80004104:	050a3503          	ld	a0,80(s4)
    80004108:	ffffd097          	auipc	ra,0xffffd
    8000410c:	a5a080e7          	jalr	-1446(ra) # 80000b62 <copyout>
    80004110:	01650763          	beq	a0,s6,8000411e <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004114:	2985                	addiw	s3,s3,1
    80004116:	0905                	addi	s2,s2,1
    80004118:	fd3a91e3          	bne	s5,s3,800040da <piperead+0x80>
    8000411c:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8000411e:	21c48513          	addi	a0,s1,540
    80004122:	ffffd097          	auipc	ra,0xffffd
    80004126:	5fe080e7          	jalr	1534(ra) # 80001720 <wakeup>
  release(&pi->lock);
    8000412a:	8526                	mv	a0,s1
    8000412c:	00002097          	auipc	ra,0x2
    80004130:	26e080e7          	jalr	622(ra) # 8000639a <release>
    80004134:	6b42                	ld	s6,16(sp)
  return i;
}
    80004136:	854e                	mv	a0,s3
    80004138:	60a6                	ld	ra,72(sp)
    8000413a:	6406                	ld	s0,64(sp)
    8000413c:	74e2                	ld	s1,56(sp)
    8000413e:	7942                	ld	s2,48(sp)
    80004140:	79a2                	ld	s3,40(sp)
    80004142:	7a02                	ld	s4,32(sp)
    80004144:	6ae2                	ld	s5,24(sp)
    80004146:	6161                	addi	sp,sp,80
    80004148:	8082                	ret

000000008000414a <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    8000414a:	df010113          	addi	sp,sp,-528
    8000414e:	20113423          	sd	ra,520(sp)
    80004152:	20813023          	sd	s0,512(sp)
    80004156:	ffa6                	sd	s1,504(sp)
    80004158:	fbca                	sd	s2,496(sp)
    8000415a:	0c00                	addi	s0,sp,528
    8000415c:	892a                	mv	s2,a0
    8000415e:	dea43c23          	sd	a0,-520(s0)
    80004162:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004166:	ffffd097          	auipc	ra,0xffffd
    8000416a:	d60080e7          	jalr	-672(ra) # 80000ec6 <myproc>
    8000416e:	84aa                	mv	s1,a0

  begin_op();
    80004170:	fffff097          	auipc	ra,0xfffff
    80004174:	460080e7          	jalr	1120(ra) # 800035d0 <begin_op>

  if((ip = namei(path)) == 0){
    80004178:	854a                	mv	a0,s2
    8000417a:	fffff097          	auipc	ra,0xfffff
    8000417e:	256080e7          	jalr	598(ra) # 800033d0 <namei>
    80004182:	c135                	beqz	a0,800041e6 <exec+0x9c>
    80004184:	f3d2                	sd	s4,480(sp)
    80004186:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004188:	fffff097          	auipc	ra,0xfffff
    8000418c:	a76080e7          	jalr	-1418(ra) # 80002bfe <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004190:	04000713          	li	a4,64
    80004194:	4681                	li	a3,0
    80004196:	e5040613          	addi	a2,s0,-432
    8000419a:	4581                	li	a1,0
    8000419c:	8552                	mv	a0,s4
    8000419e:	fffff097          	auipc	ra,0xfffff
    800041a2:	d18080e7          	jalr	-744(ra) # 80002eb6 <readi>
    800041a6:	04000793          	li	a5,64
    800041aa:	00f51a63          	bne	a0,a5,800041be <exec+0x74>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    800041ae:	e5042703          	lw	a4,-432(s0)
    800041b2:	464c47b7          	lui	a5,0x464c4
    800041b6:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800041ba:	02f70c63          	beq	a4,a5,800041f2 <exec+0xa8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800041be:	8552                	mv	a0,s4
    800041c0:	fffff097          	auipc	ra,0xfffff
    800041c4:	ca4080e7          	jalr	-860(ra) # 80002e64 <iunlockput>
    end_op();
    800041c8:	fffff097          	auipc	ra,0xfffff
    800041cc:	482080e7          	jalr	1154(ra) # 8000364a <end_op>
  }
  return -1;
    800041d0:	557d                	li	a0,-1
    800041d2:	7a1e                	ld	s4,480(sp)
}
    800041d4:	20813083          	ld	ra,520(sp)
    800041d8:	20013403          	ld	s0,512(sp)
    800041dc:	74fe                	ld	s1,504(sp)
    800041de:	795e                	ld	s2,496(sp)
    800041e0:	21010113          	addi	sp,sp,528
    800041e4:	8082                	ret
    end_op();
    800041e6:	fffff097          	auipc	ra,0xfffff
    800041ea:	464080e7          	jalr	1124(ra) # 8000364a <end_op>
    return -1;
    800041ee:	557d                	li	a0,-1
    800041f0:	b7d5                	j	800041d4 <exec+0x8a>
    800041f2:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    800041f4:	8526                	mv	a0,s1
    800041f6:	ffffd097          	auipc	ra,0xffffd
    800041fa:	d94080e7          	jalr	-620(ra) # 80000f8a <proc_pagetable>
    800041fe:	8b2a                	mv	s6,a0
    80004200:	30050563          	beqz	a0,8000450a <exec+0x3c0>
    80004204:	f7ce                	sd	s3,488(sp)
    80004206:	efd6                	sd	s5,472(sp)
    80004208:	e7de                	sd	s7,456(sp)
    8000420a:	e3e2                	sd	s8,448(sp)
    8000420c:	ff66                	sd	s9,440(sp)
    8000420e:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004210:	e7042d03          	lw	s10,-400(s0)
    80004214:	e8845783          	lhu	a5,-376(s0)
    80004218:	14078563          	beqz	a5,80004362 <exec+0x218>
    8000421c:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000421e:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004220:	4d81                	li	s11,0
    if((ph.vaddr % PGSIZE) != 0)
    80004222:	6c85                	lui	s9,0x1
    80004224:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004228:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    8000422c:	6a85                	lui	s5,0x1
    8000422e:	a0b5                	j	8000429a <exec+0x150>
      panic("loadseg: address should exist");
    80004230:	00004517          	auipc	a0,0x4
    80004234:	3d850513          	addi	a0,a0,984 # 80008608 <etext+0x608>
    80004238:	00002097          	auipc	ra,0x2
    8000423c:	b34080e7          	jalr	-1228(ra) # 80005d6c <panic>
    if(sz - i < PGSIZE)
    80004240:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004242:	8726                	mv	a4,s1
    80004244:	012c06bb          	addw	a3,s8,s2
    80004248:	4581                	li	a1,0
    8000424a:	8552                	mv	a0,s4
    8000424c:	fffff097          	auipc	ra,0xfffff
    80004250:	c6a080e7          	jalr	-918(ra) # 80002eb6 <readi>
    80004254:	2501                	sext.w	a0,a0
    80004256:	26a49e63          	bne	s1,a0,800044d2 <exec+0x388>
  for(i = 0; i < sz; i += PGSIZE){
    8000425a:	012a893b          	addw	s2,s5,s2
    8000425e:	03397563          	bgeu	s2,s3,80004288 <exec+0x13e>
    pa = walkaddr(pagetable, va + i);
    80004262:	02091593          	slli	a1,s2,0x20
    80004266:	9181                	srli	a1,a1,0x20
    80004268:	95de                	add	a1,a1,s7
    8000426a:	855a                	mv	a0,s6
    8000426c:	ffffc097          	auipc	ra,0xffffc
    80004270:	2d6080e7          	jalr	726(ra) # 80000542 <walkaddr>
    80004274:	862a                	mv	a2,a0
    if(pa == 0)
    80004276:	dd4d                	beqz	a0,80004230 <exec+0xe6>
    if(sz - i < PGSIZE)
    80004278:	412984bb          	subw	s1,s3,s2
    8000427c:	0004879b          	sext.w	a5,s1
    80004280:	fcfcf0e3          	bgeu	s9,a5,80004240 <exec+0xf6>
    80004284:	84d6                	mv	s1,s5
    80004286:	bf6d                	j	80004240 <exec+0xf6>
    sz = sz1;
    80004288:	e0843483          	ld	s1,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000428c:	2d85                	addiw	s11,s11,1
    8000428e:	038d0d1b          	addiw	s10,s10,56
    80004292:	e8845783          	lhu	a5,-376(s0)
    80004296:	06fddf63          	bge	s11,a5,80004314 <exec+0x1ca>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000429a:	2d01                	sext.w	s10,s10
    8000429c:	03800713          	li	a4,56
    800042a0:	86ea                	mv	a3,s10
    800042a2:	e1840613          	addi	a2,s0,-488
    800042a6:	4581                	li	a1,0
    800042a8:	8552                	mv	a0,s4
    800042aa:	fffff097          	auipc	ra,0xfffff
    800042ae:	c0c080e7          	jalr	-1012(ra) # 80002eb6 <readi>
    800042b2:	03800793          	li	a5,56
    800042b6:	1ef51863          	bne	a0,a5,800044a6 <exec+0x35c>
    if(ph.type != ELF_PROG_LOAD)
    800042ba:	e1842783          	lw	a5,-488(s0)
    800042be:	4705                	li	a4,1
    800042c0:	fce796e3          	bne	a5,a4,8000428c <exec+0x142>
    if(ph.memsz < ph.filesz)
    800042c4:	e4043603          	ld	a2,-448(s0)
    800042c8:	e3843783          	ld	a5,-456(s0)
    800042cc:	1ef66163          	bltu	a2,a5,800044ae <exec+0x364>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800042d0:	e2843783          	ld	a5,-472(s0)
    800042d4:	963e                	add	a2,a2,a5
    800042d6:	1ef66063          	bltu	a2,a5,800044b6 <exec+0x36c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800042da:	85a6                	mv	a1,s1
    800042dc:	855a                	mv	a0,s6
    800042de:	ffffc097          	auipc	ra,0xffffc
    800042e2:	628080e7          	jalr	1576(ra) # 80000906 <uvmalloc>
    800042e6:	e0a43423          	sd	a0,-504(s0)
    800042ea:	1c050a63          	beqz	a0,800044be <exec+0x374>
    if((ph.vaddr % PGSIZE) != 0)
    800042ee:	e2843b83          	ld	s7,-472(s0)
    800042f2:	df043783          	ld	a5,-528(s0)
    800042f6:	00fbf7b3          	and	a5,s7,a5
    800042fa:	1c079a63          	bnez	a5,800044ce <exec+0x384>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800042fe:	e2042c03          	lw	s8,-480(s0)
    80004302:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004306:	00098463          	beqz	s3,8000430e <exec+0x1c4>
    8000430a:	4901                	li	s2,0
    8000430c:	bf99                	j	80004262 <exec+0x118>
    sz = sz1;
    8000430e:	e0843483          	ld	s1,-504(s0)
    80004312:	bfad                	j	8000428c <exec+0x142>
    80004314:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    80004316:	8552                	mv	a0,s4
    80004318:	fffff097          	auipc	ra,0xfffff
    8000431c:	b4c080e7          	jalr	-1204(ra) # 80002e64 <iunlockput>
  end_op();
    80004320:	fffff097          	auipc	ra,0xfffff
    80004324:	32a080e7          	jalr	810(ra) # 8000364a <end_op>
  p = myproc();
    80004328:	ffffd097          	auipc	ra,0xffffd
    8000432c:	b9e080e7          	jalr	-1122(ra) # 80000ec6 <myproc>
    80004330:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004332:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    80004336:	6985                	lui	s3,0x1
    80004338:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    8000433a:	99a6                	add	s3,s3,s1
    8000433c:	77fd                	lui	a5,0xfffff
    8000433e:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004342:	6609                	lui	a2,0x2
    80004344:	964e                	add	a2,a2,s3
    80004346:	85ce                	mv	a1,s3
    80004348:	855a                	mv	a0,s6
    8000434a:	ffffc097          	auipc	ra,0xffffc
    8000434e:	5bc080e7          	jalr	1468(ra) # 80000906 <uvmalloc>
    80004352:	892a                	mv	s2,a0
    80004354:	e0a43423          	sd	a0,-504(s0)
    80004358:	e519                	bnez	a0,80004366 <exec+0x21c>
  if(pagetable)
    8000435a:	e1343423          	sd	s3,-504(s0)
    8000435e:	4a01                	li	s4,0
    80004360:	aa95                	j	800044d4 <exec+0x38a>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004362:	4481                	li	s1,0
    80004364:	bf4d                	j	80004316 <exec+0x1cc>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004366:	75f9                	lui	a1,0xffffe
    80004368:	95aa                	add	a1,a1,a0
    8000436a:	855a                	mv	a0,s6
    8000436c:	ffffc097          	auipc	ra,0xffffc
    80004370:	7c4080e7          	jalr	1988(ra) # 80000b30 <uvmclear>
  stackbase = sp - PGSIZE;
    80004374:	7bfd                	lui	s7,0xfffff
    80004376:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80004378:	e0043783          	ld	a5,-512(s0)
    8000437c:	6388                	ld	a0,0(a5)
    8000437e:	c52d                	beqz	a0,800043e8 <exec+0x29e>
    80004380:	e9040993          	addi	s3,s0,-368
    80004384:	f9040c13          	addi	s8,s0,-112
    80004388:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    8000438a:	ffffc097          	auipc	ra,0xffffc
    8000438e:	fae080e7          	jalr	-82(ra) # 80000338 <strlen>
    80004392:	0015079b          	addiw	a5,a0,1
    80004396:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    8000439a:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    8000439e:	13796463          	bltu	s2,s7,800044c6 <exec+0x37c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800043a2:	e0043d03          	ld	s10,-512(s0)
    800043a6:	000d3a03          	ld	s4,0(s10)
    800043aa:	8552                	mv	a0,s4
    800043ac:	ffffc097          	auipc	ra,0xffffc
    800043b0:	f8c080e7          	jalr	-116(ra) # 80000338 <strlen>
    800043b4:	0015069b          	addiw	a3,a0,1
    800043b8:	8652                	mv	a2,s4
    800043ba:	85ca                	mv	a1,s2
    800043bc:	855a                	mv	a0,s6
    800043be:	ffffc097          	auipc	ra,0xffffc
    800043c2:	7a4080e7          	jalr	1956(ra) # 80000b62 <copyout>
    800043c6:	10054263          	bltz	a0,800044ca <exec+0x380>
    ustack[argc] = sp;
    800043ca:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800043ce:	0485                	addi	s1,s1,1
    800043d0:	008d0793          	addi	a5,s10,8
    800043d4:	e0f43023          	sd	a5,-512(s0)
    800043d8:	008d3503          	ld	a0,8(s10)
    800043dc:	c909                	beqz	a0,800043ee <exec+0x2a4>
    if(argc >= MAXARG)
    800043de:	09a1                	addi	s3,s3,8
    800043e0:	fb8995e3          	bne	s3,s8,8000438a <exec+0x240>
  ip = 0;
    800043e4:	4a01                	li	s4,0
    800043e6:	a0fd                	j	800044d4 <exec+0x38a>
  sp = sz;
    800043e8:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    800043ec:	4481                	li	s1,0
  ustack[argc] = 0;
    800043ee:	00349793          	slli	a5,s1,0x3
    800043f2:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffd8d50>
    800043f6:	97a2                	add	a5,a5,s0
    800043f8:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    800043fc:	00148693          	addi	a3,s1,1
    80004400:	068e                	slli	a3,a3,0x3
    80004402:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004406:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    8000440a:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    8000440e:	f57966e3          	bltu	s2,s7,8000435a <exec+0x210>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004412:	e9040613          	addi	a2,s0,-368
    80004416:	85ca                	mv	a1,s2
    80004418:	855a                	mv	a0,s6
    8000441a:	ffffc097          	auipc	ra,0xffffc
    8000441e:	748080e7          	jalr	1864(ra) # 80000b62 <copyout>
    80004422:	0e054663          	bltz	a0,8000450e <exec+0x3c4>
  p->trapframe->a1 = sp;
    80004426:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    8000442a:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    8000442e:	df843783          	ld	a5,-520(s0)
    80004432:	0007c703          	lbu	a4,0(a5)
    80004436:	cf11                	beqz	a4,80004452 <exec+0x308>
    80004438:	0785                	addi	a5,a5,1
    if(*s == '/')
    8000443a:	02f00693          	li	a3,47
    8000443e:	a039                	j	8000444c <exec+0x302>
      last = s+1;
    80004440:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004444:	0785                	addi	a5,a5,1
    80004446:	fff7c703          	lbu	a4,-1(a5)
    8000444a:	c701                	beqz	a4,80004452 <exec+0x308>
    if(*s == '/')
    8000444c:	fed71ce3          	bne	a4,a3,80004444 <exec+0x2fa>
    80004450:	bfc5                	j	80004440 <exec+0x2f6>
  safestrcpy(p->name, last, sizeof(p->name));
    80004452:	4641                	li	a2,16
    80004454:	df843583          	ld	a1,-520(s0)
    80004458:	158a8513          	addi	a0,s5,344
    8000445c:	ffffc097          	auipc	ra,0xffffc
    80004460:	eaa080e7          	jalr	-342(ra) # 80000306 <safestrcpy>
  oldpagetable = p->pagetable;
    80004464:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004468:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    8000446c:	e0843783          	ld	a5,-504(s0)
    80004470:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004474:	058ab783          	ld	a5,88(s5)
    80004478:	e6843703          	ld	a4,-408(s0)
    8000447c:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000447e:	058ab783          	ld	a5,88(s5)
    80004482:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004486:	85e6                	mv	a1,s9
    80004488:	ffffd097          	auipc	ra,0xffffd
    8000448c:	b9e080e7          	jalr	-1122(ra) # 80001026 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004490:	0004851b          	sext.w	a0,s1
    80004494:	79be                	ld	s3,488(sp)
    80004496:	7a1e                	ld	s4,480(sp)
    80004498:	6afe                	ld	s5,472(sp)
    8000449a:	6b5e                	ld	s6,464(sp)
    8000449c:	6bbe                	ld	s7,456(sp)
    8000449e:	6c1e                	ld	s8,448(sp)
    800044a0:	7cfa                	ld	s9,440(sp)
    800044a2:	7d5a                	ld	s10,432(sp)
    800044a4:	bb05                	j	800041d4 <exec+0x8a>
    800044a6:	e0943423          	sd	s1,-504(s0)
    800044aa:	7dba                	ld	s11,424(sp)
    800044ac:	a025                	j	800044d4 <exec+0x38a>
    800044ae:	e0943423          	sd	s1,-504(s0)
    800044b2:	7dba                	ld	s11,424(sp)
    800044b4:	a005                	j	800044d4 <exec+0x38a>
    800044b6:	e0943423          	sd	s1,-504(s0)
    800044ba:	7dba                	ld	s11,424(sp)
    800044bc:	a821                	j	800044d4 <exec+0x38a>
    800044be:	e0943423          	sd	s1,-504(s0)
    800044c2:	7dba                	ld	s11,424(sp)
    800044c4:	a801                	j	800044d4 <exec+0x38a>
  ip = 0;
    800044c6:	4a01                	li	s4,0
    800044c8:	a031                	j	800044d4 <exec+0x38a>
    800044ca:	4a01                	li	s4,0
  if(pagetable)
    800044cc:	a021                	j	800044d4 <exec+0x38a>
    800044ce:	7dba                	ld	s11,424(sp)
    800044d0:	a011                	j	800044d4 <exec+0x38a>
    800044d2:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    800044d4:	e0843583          	ld	a1,-504(s0)
    800044d8:	855a                	mv	a0,s6
    800044da:	ffffd097          	auipc	ra,0xffffd
    800044de:	b4c080e7          	jalr	-1204(ra) # 80001026 <proc_freepagetable>
  return -1;
    800044e2:	557d                	li	a0,-1
  if(ip){
    800044e4:	000a1b63          	bnez	s4,800044fa <exec+0x3b0>
    800044e8:	79be                	ld	s3,488(sp)
    800044ea:	7a1e                	ld	s4,480(sp)
    800044ec:	6afe                	ld	s5,472(sp)
    800044ee:	6b5e                	ld	s6,464(sp)
    800044f0:	6bbe                	ld	s7,456(sp)
    800044f2:	6c1e                	ld	s8,448(sp)
    800044f4:	7cfa                	ld	s9,440(sp)
    800044f6:	7d5a                	ld	s10,432(sp)
    800044f8:	b9f1                	j	800041d4 <exec+0x8a>
    800044fa:	79be                	ld	s3,488(sp)
    800044fc:	6afe                	ld	s5,472(sp)
    800044fe:	6b5e                	ld	s6,464(sp)
    80004500:	6bbe                	ld	s7,456(sp)
    80004502:	6c1e                	ld	s8,448(sp)
    80004504:	7cfa                	ld	s9,440(sp)
    80004506:	7d5a                	ld	s10,432(sp)
    80004508:	b95d                	j	800041be <exec+0x74>
    8000450a:	6b5e                	ld	s6,464(sp)
    8000450c:	b94d                	j	800041be <exec+0x74>
  sz = sz1;
    8000450e:	e0843983          	ld	s3,-504(s0)
    80004512:	b5a1                	j	8000435a <exec+0x210>

0000000080004514 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004514:	7179                	addi	sp,sp,-48
    80004516:	f406                	sd	ra,40(sp)
    80004518:	f022                	sd	s0,32(sp)
    8000451a:	ec26                	sd	s1,24(sp)
    8000451c:	e84a                	sd	s2,16(sp)
    8000451e:	1800                	addi	s0,sp,48
    80004520:	892e                	mv	s2,a1
    80004522:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80004524:	fdc40593          	addi	a1,s0,-36
    80004528:	ffffe097          	auipc	ra,0xffffe
    8000452c:	a96080e7          	jalr	-1386(ra) # 80001fbe <argint>
    80004530:	04054063          	bltz	a0,80004570 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004534:	fdc42703          	lw	a4,-36(s0)
    80004538:	47bd                	li	a5,15
    8000453a:	02e7ed63          	bltu	a5,a4,80004574 <argfd+0x60>
    8000453e:	ffffd097          	auipc	ra,0xffffd
    80004542:	988080e7          	jalr	-1656(ra) # 80000ec6 <myproc>
    80004546:	fdc42703          	lw	a4,-36(s0)
    8000454a:	01a70793          	addi	a5,a4,26
    8000454e:	078e                	slli	a5,a5,0x3
    80004550:	953e                	add	a0,a0,a5
    80004552:	611c                	ld	a5,0(a0)
    80004554:	c395                	beqz	a5,80004578 <argfd+0x64>
    return -1;
  if(pfd)
    80004556:	00090463          	beqz	s2,8000455e <argfd+0x4a>
    *pfd = fd;
    8000455a:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    8000455e:	4501                	li	a0,0
  if(pf)
    80004560:	c091                	beqz	s1,80004564 <argfd+0x50>
    *pf = f;
    80004562:	e09c                	sd	a5,0(s1)
}
    80004564:	70a2                	ld	ra,40(sp)
    80004566:	7402                	ld	s0,32(sp)
    80004568:	64e2                	ld	s1,24(sp)
    8000456a:	6942                	ld	s2,16(sp)
    8000456c:	6145                	addi	sp,sp,48
    8000456e:	8082                	ret
    return -1;
    80004570:	557d                	li	a0,-1
    80004572:	bfcd                	j	80004564 <argfd+0x50>
    return -1;
    80004574:	557d                	li	a0,-1
    80004576:	b7fd                	j	80004564 <argfd+0x50>
    80004578:	557d                	li	a0,-1
    8000457a:	b7ed                	j	80004564 <argfd+0x50>

000000008000457c <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    8000457c:	1101                	addi	sp,sp,-32
    8000457e:	ec06                	sd	ra,24(sp)
    80004580:	e822                	sd	s0,16(sp)
    80004582:	e426                	sd	s1,8(sp)
    80004584:	1000                	addi	s0,sp,32
    80004586:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004588:	ffffd097          	auipc	ra,0xffffd
    8000458c:	93e080e7          	jalr	-1730(ra) # 80000ec6 <myproc>
    80004590:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004592:	0d050793          	addi	a5,a0,208
    80004596:	4501                	li	a0,0
    80004598:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    8000459a:	6398                	ld	a4,0(a5)
    8000459c:	cb19                	beqz	a4,800045b2 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    8000459e:	2505                	addiw	a0,a0,1
    800045a0:	07a1                	addi	a5,a5,8
    800045a2:	fed51ce3          	bne	a0,a3,8000459a <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800045a6:	557d                	li	a0,-1
}
    800045a8:	60e2                	ld	ra,24(sp)
    800045aa:	6442                	ld	s0,16(sp)
    800045ac:	64a2                	ld	s1,8(sp)
    800045ae:	6105                	addi	sp,sp,32
    800045b0:	8082                	ret
      p->ofile[fd] = f;
    800045b2:	01a50793          	addi	a5,a0,26
    800045b6:	078e                	slli	a5,a5,0x3
    800045b8:	963e                	add	a2,a2,a5
    800045ba:	e204                	sd	s1,0(a2)
      return fd;
    800045bc:	b7f5                	j	800045a8 <fdalloc+0x2c>

00000000800045be <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800045be:	715d                	addi	sp,sp,-80
    800045c0:	e486                	sd	ra,72(sp)
    800045c2:	e0a2                	sd	s0,64(sp)
    800045c4:	fc26                	sd	s1,56(sp)
    800045c6:	f84a                	sd	s2,48(sp)
    800045c8:	f44e                	sd	s3,40(sp)
    800045ca:	f052                	sd	s4,32(sp)
    800045cc:	ec56                	sd	s5,24(sp)
    800045ce:	0880                	addi	s0,sp,80
    800045d0:	8aae                	mv	s5,a1
    800045d2:	8a32                	mv	s4,a2
    800045d4:	89b6                	mv	s3,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800045d6:	fb040593          	addi	a1,s0,-80
    800045da:	fffff097          	auipc	ra,0xfffff
    800045de:	e14080e7          	jalr	-492(ra) # 800033ee <nameiparent>
    800045e2:	892a                	mv	s2,a0
    800045e4:	12050c63          	beqz	a0,8000471c <create+0x15e>
    return 0;

  ilock(dp);
    800045e8:	ffffe097          	auipc	ra,0xffffe
    800045ec:	616080e7          	jalr	1558(ra) # 80002bfe <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800045f0:	4601                	li	a2,0
    800045f2:	fb040593          	addi	a1,s0,-80
    800045f6:	854a                	mv	a0,s2
    800045f8:	fffff097          	auipc	ra,0xfffff
    800045fc:	b06080e7          	jalr	-1274(ra) # 800030fe <dirlookup>
    80004600:	84aa                	mv	s1,a0
    80004602:	c539                	beqz	a0,80004650 <create+0x92>
    iunlockput(dp);
    80004604:	854a                	mv	a0,s2
    80004606:	fffff097          	auipc	ra,0xfffff
    8000460a:	85e080e7          	jalr	-1954(ra) # 80002e64 <iunlockput>
    ilock(ip);
    8000460e:	8526                	mv	a0,s1
    80004610:	ffffe097          	auipc	ra,0xffffe
    80004614:	5ee080e7          	jalr	1518(ra) # 80002bfe <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004618:	4789                	li	a5,2
    8000461a:	02fa9463          	bne	s5,a5,80004642 <create+0x84>
    8000461e:	0444d783          	lhu	a5,68(s1)
    80004622:	37f9                	addiw	a5,a5,-2
    80004624:	17c2                	slli	a5,a5,0x30
    80004626:	93c1                	srli	a5,a5,0x30
    80004628:	4705                	li	a4,1
    8000462a:	00f76c63          	bltu	a4,a5,80004642 <create+0x84>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    8000462e:	8526                	mv	a0,s1
    80004630:	60a6                	ld	ra,72(sp)
    80004632:	6406                	ld	s0,64(sp)
    80004634:	74e2                	ld	s1,56(sp)
    80004636:	7942                	ld	s2,48(sp)
    80004638:	79a2                	ld	s3,40(sp)
    8000463a:	7a02                	ld	s4,32(sp)
    8000463c:	6ae2                	ld	s5,24(sp)
    8000463e:	6161                	addi	sp,sp,80
    80004640:	8082                	ret
    iunlockput(ip);
    80004642:	8526                	mv	a0,s1
    80004644:	fffff097          	auipc	ra,0xfffff
    80004648:	820080e7          	jalr	-2016(ra) # 80002e64 <iunlockput>
    return 0;
    8000464c:	4481                	li	s1,0
    8000464e:	b7c5                	j	8000462e <create+0x70>
  if((ip = ialloc(dp->dev, type)) == 0)
    80004650:	85d6                	mv	a1,s5
    80004652:	00092503          	lw	a0,0(s2)
    80004656:	ffffe097          	auipc	ra,0xffffe
    8000465a:	414080e7          	jalr	1044(ra) # 80002a6a <ialloc>
    8000465e:	84aa                	mv	s1,a0
    80004660:	c139                	beqz	a0,800046a6 <create+0xe8>
  ilock(ip);
    80004662:	ffffe097          	auipc	ra,0xffffe
    80004666:	59c080e7          	jalr	1436(ra) # 80002bfe <ilock>
  ip->major = major;
    8000466a:	05449323          	sh	s4,70(s1)
  ip->minor = minor;
    8000466e:	05349423          	sh	s3,72(s1)
  ip->nlink = 1;
    80004672:	4985                	li	s3,1
    80004674:	05349523          	sh	s3,74(s1)
  iupdate(ip);
    80004678:	8526                	mv	a0,s1
    8000467a:	ffffe097          	auipc	ra,0xffffe
    8000467e:	4b8080e7          	jalr	1208(ra) # 80002b32 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004682:	033a8a63          	beq	s5,s3,800046b6 <create+0xf8>
  if(dirlink(dp, name, ip->inum) < 0)
    80004686:	40d0                	lw	a2,4(s1)
    80004688:	fb040593          	addi	a1,s0,-80
    8000468c:	854a                	mv	a0,s2
    8000468e:	fffff097          	auipc	ra,0xfffff
    80004692:	c80080e7          	jalr	-896(ra) # 8000330e <dirlink>
    80004696:	06054b63          	bltz	a0,8000470c <create+0x14e>
  iunlockput(dp);
    8000469a:	854a                	mv	a0,s2
    8000469c:	ffffe097          	auipc	ra,0xffffe
    800046a0:	7c8080e7          	jalr	1992(ra) # 80002e64 <iunlockput>
  return ip;
    800046a4:	b769                	j	8000462e <create+0x70>
    panic("create: ialloc");
    800046a6:	00004517          	auipc	a0,0x4
    800046aa:	f8250513          	addi	a0,a0,-126 # 80008628 <etext+0x628>
    800046ae:	00001097          	auipc	ra,0x1
    800046b2:	6be080e7          	jalr	1726(ra) # 80005d6c <panic>
    dp->nlink++;  // for ".."
    800046b6:	04a95783          	lhu	a5,74(s2)
    800046ba:	2785                	addiw	a5,a5,1
    800046bc:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    800046c0:	854a                	mv	a0,s2
    800046c2:	ffffe097          	auipc	ra,0xffffe
    800046c6:	470080e7          	jalr	1136(ra) # 80002b32 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800046ca:	40d0                	lw	a2,4(s1)
    800046cc:	00004597          	auipc	a1,0x4
    800046d0:	f6c58593          	addi	a1,a1,-148 # 80008638 <etext+0x638>
    800046d4:	8526                	mv	a0,s1
    800046d6:	fffff097          	auipc	ra,0xfffff
    800046da:	c38080e7          	jalr	-968(ra) # 8000330e <dirlink>
    800046de:	00054f63          	bltz	a0,800046fc <create+0x13e>
    800046e2:	00492603          	lw	a2,4(s2)
    800046e6:	00004597          	auipc	a1,0x4
    800046ea:	f5a58593          	addi	a1,a1,-166 # 80008640 <etext+0x640>
    800046ee:	8526                	mv	a0,s1
    800046f0:	fffff097          	auipc	ra,0xfffff
    800046f4:	c1e080e7          	jalr	-994(ra) # 8000330e <dirlink>
    800046f8:	f80557e3          	bgez	a0,80004686 <create+0xc8>
      panic("create dots");
    800046fc:	00004517          	auipc	a0,0x4
    80004700:	f4c50513          	addi	a0,a0,-180 # 80008648 <etext+0x648>
    80004704:	00001097          	auipc	ra,0x1
    80004708:	668080e7          	jalr	1640(ra) # 80005d6c <panic>
    panic("create: dirlink");
    8000470c:	00004517          	auipc	a0,0x4
    80004710:	f4c50513          	addi	a0,a0,-180 # 80008658 <etext+0x658>
    80004714:	00001097          	auipc	ra,0x1
    80004718:	658080e7          	jalr	1624(ra) # 80005d6c <panic>
    return 0;
    8000471c:	84aa                	mv	s1,a0
    8000471e:	bf01                	j	8000462e <create+0x70>

0000000080004720 <sys_dup>:
{
    80004720:	7179                	addi	sp,sp,-48
    80004722:	f406                	sd	ra,40(sp)
    80004724:	f022                	sd	s0,32(sp)
    80004726:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004728:	fd840613          	addi	a2,s0,-40
    8000472c:	4581                	li	a1,0
    8000472e:	4501                	li	a0,0
    80004730:	00000097          	auipc	ra,0x0
    80004734:	de4080e7          	jalr	-540(ra) # 80004514 <argfd>
    return -1;
    80004738:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000473a:	02054763          	bltz	a0,80004768 <sys_dup+0x48>
    8000473e:	ec26                	sd	s1,24(sp)
    80004740:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80004742:	fd843903          	ld	s2,-40(s0)
    80004746:	854a                	mv	a0,s2
    80004748:	00000097          	auipc	ra,0x0
    8000474c:	e34080e7          	jalr	-460(ra) # 8000457c <fdalloc>
    80004750:	84aa                	mv	s1,a0
    return -1;
    80004752:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004754:	00054f63          	bltz	a0,80004772 <sys_dup+0x52>
  filedup(f);
    80004758:	854a                	mv	a0,s2
    8000475a:	fffff097          	auipc	ra,0xfffff
    8000475e:	2ee080e7          	jalr	750(ra) # 80003a48 <filedup>
  return fd;
    80004762:	87a6                	mv	a5,s1
    80004764:	64e2                	ld	s1,24(sp)
    80004766:	6942                	ld	s2,16(sp)
}
    80004768:	853e                	mv	a0,a5
    8000476a:	70a2                	ld	ra,40(sp)
    8000476c:	7402                	ld	s0,32(sp)
    8000476e:	6145                	addi	sp,sp,48
    80004770:	8082                	ret
    80004772:	64e2                	ld	s1,24(sp)
    80004774:	6942                	ld	s2,16(sp)
    80004776:	bfcd                	j	80004768 <sys_dup+0x48>

0000000080004778 <sys_read>:
{
    80004778:	7179                	addi	sp,sp,-48
    8000477a:	f406                	sd	ra,40(sp)
    8000477c:	f022                	sd	s0,32(sp)
    8000477e:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004780:	fe840613          	addi	a2,s0,-24
    80004784:	4581                	li	a1,0
    80004786:	4501                	li	a0,0
    80004788:	00000097          	auipc	ra,0x0
    8000478c:	d8c080e7          	jalr	-628(ra) # 80004514 <argfd>
    return -1;
    80004790:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004792:	04054163          	bltz	a0,800047d4 <sys_read+0x5c>
    80004796:	fe440593          	addi	a1,s0,-28
    8000479a:	4509                	li	a0,2
    8000479c:	ffffe097          	auipc	ra,0xffffe
    800047a0:	822080e7          	jalr	-2014(ra) # 80001fbe <argint>
    return -1;
    800047a4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047a6:	02054763          	bltz	a0,800047d4 <sys_read+0x5c>
    800047aa:	fd840593          	addi	a1,s0,-40
    800047ae:	4505                	li	a0,1
    800047b0:	ffffe097          	auipc	ra,0xffffe
    800047b4:	830080e7          	jalr	-2000(ra) # 80001fe0 <argaddr>
    return -1;
    800047b8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047ba:	00054d63          	bltz	a0,800047d4 <sys_read+0x5c>
  return fileread(f, p, n);
    800047be:	fe442603          	lw	a2,-28(s0)
    800047c2:	fd843583          	ld	a1,-40(s0)
    800047c6:	fe843503          	ld	a0,-24(s0)
    800047ca:	fffff097          	auipc	ra,0xfffff
    800047ce:	424080e7          	jalr	1060(ra) # 80003bee <fileread>
    800047d2:	87aa                	mv	a5,a0
}
    800047d4:	853e                	mv	a0,a5
    800047d6:	70a2                	ld	ra,40(sp)
    800047d8:	7402                	ld	s0,32(sp)
    800047da:	6145                	addi	sp,sp,48
    800047dc:	8082                	ret

00000000800047de <sys_write>:
{
    800047de:	7179                	addi	sp,sp,-48
    800047e0:	f406                	sd	ra,40(sp)
    800047e2:	f022                	sd	s0,32(sp)
    800047e4:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047e6:	fe840613          	addi	a2,s0,-24
    800047ea:	4581                	li	a1,0
    800047ec:	4501                	li	a0,0
    800047ee:	00000097          	auipc	ra,0x0
    800047f2:	d26080e7          	jalr	-730(ra) # 80004514 <argfd>
    return -1;
    800047f6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047f8:	04054163          	bltz	a0,8000483a <sys_write+0x5c>
    800047fc:	fe440593          	addi	a1,s0,-28
    80004800:	4509                	li	a0,2
    80004802:	ffffd097          	auipc	ra,0xffffd
    80004806:	7bc080e7          	jalr	1980(ra) # 80001fbe <argint>
    return -1;
    8000480a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000480c:	02054763          	bltz	a0,8000483a <sys_write+0x5c>
    80004810:	fd840593          	addi	a1,s0,-40
    80004814:	4505                	li	a0,1
    80004816:	ffffd097          	auipc	ra,0xffffd
    8000481a:	7ca080e7          	jalr	1994(ra) # 80001fe0 <argaddr>
    return -1;
    8000481e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004820:	00054d63          	bltz	a0,8000483a <sys_write+0x5c>
  return filewrite(f, p, n);
    80004824:	fe442603          	lw	a2,-28(s0)
    80004828:	fd843583          	ld	a1,-40(s0)
    8000482c:	fe843503          	ld	a0,-24(s0)
    80004830:	fffff097          	auipc	ra,0xfffff
    80004834:	490080e7          	jalr	1168(ra) # 80003cc0 <filewrite>
    80004838:	87aa                	mv	a5,a0
}
    8000483a:	853e                	mv	a0,a5
    8000483c:	70a2                	ld	ra,40(sp)
    8000483e:	7402                	ld	s0,32(sp)
    80004840:	6145                	addi	sp,sp,48
    80004842:	8082                	ret

0000000080004844 <sys_close>:
{
    80004844:	1101                	addi	sp,sp,-32
    80004846:	ec06                	sd	ra,24(sp)
    80004848:	e822                	sd	s0,16(sp)
    8000484a:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    8000484c:	fe040613          	addi	a2,s0,-32
    80004850:	fec40593          	addi	a1,s0,-20
    80004854:	4501                	li	a0,0
    80004856:	00000097          	auipc	ra,0x0
    8000485a:	cbe080e7          	jalr	-834(ra) # 80004514 <argfd>
    return -1;
    8000485e:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004860:	02054463          	bltz	a0,80004888 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004864:	ffffc097          	auipc	ra,0xffffc
    80004868:	662080e7          	jalr	1634(ra) # 80000ec6 <myproc>
    8000486c:	fec42783          	lw	a5,-20(s0)
    80004870:	07e9                	addi	a5,a5,26
    80004872:	078e                	slli	a5,a5,0x3
    80004874:	953e                	add	a0,a0,a5
    80004876:	00053023          	sd	zero,0(a0)
  fileclose(f);
    8000487a:	fe043503          	ld	a0,-32(s0)
    8000487e:	fffff097          	auipc	ra,0xfffff
    80004882:	21c080e7          	jalr	540(ra) # 80003a9a <fileclose>
  return 0;
    80004886:	4781                	li	a5,0
}
    80004888:	853e                	mv	a0,a5
    8000488a:	60e2                	ld	ra,24(sp)
    8000488c:	6442                	ld	s0,16(sp)
    8000488e:	6105                	addi	sp,sp,32
    80004890:	8082                	ret

0000000080004892 <sys_fstat>:
{
    80004892:	1101                	addi	sp,sp,-32
    80004894:	ec06                	sd	ra,24(sp)
    80004896:	e822                	sd	s0,16(sp)
    80004898:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000489a:	fe840613          	addi	a2,s0,-24
    8000489e:	4581                	li	a1,0
    800048a0:	4501                	li	a0,0
    800048a2:	00000097          	auipc	ra,0x0
    800048a6:	c72080e7          	jalr	-910(ra) # 80004514 <argfd>
    return -1;
    800048aa:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800048ac:	02054563          	bltz	a0,800048d6 <sys_fstat+0x44>
    800048b0:	fe040593          	addi	a1,s0,-32
    800048b4:	4505                	li	a0,1
    800048b6:	ffffd097          	auipc	ra,0xffffd
    800048ba:	72a080e7          	jalr	1834(ra) # 80001fe0 <argaddr>
    return -1;
    800048be:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800048c0:	00054b63          	bltz	a0,800048d6 <sys_fstat+0x44>
  return filestat(f, st);
    800048c4:	fe043583          	ld	a1,-32(s0)
    800048c8:	fe843503          	ld	a0,-24(s0)
    800048cc:	fffff097          	auipc	ra,0xfffff
    800048d0:	2b0080e7          	jalr	688(ra) # 80003b7c <filestat>
    800048d4:	87aa                	mv	a5,a0
}
    800048d6:	853e                	mv	a0,a5
    800048d8:	60e2                	ld	ra,24(sp)
    800048da:	6442                	ld	s0,16(sp)
    800048dc:	6105                	addi	sp,sp,32
    800048de:	8082                	ret

00000000800048e0 <sys_link>:
{
    800048e0:	7169                	addi	sp,sp,-304
    800048e2:	f606                	sd	ra,296(sp)
    800048e4:	f222                	sd	s0,288(sp)
    800048e6:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800048e8:	08000613          	li	a2,128
    800048ec:	ed040593          	addi	a1,s0,-304
    800048f0:	4501                	li	a0,0
    800048f2:	ffffd097          	auipc	ra,0xffffd
    800048f6:	710080e7          	jalr	1808(ra) # 80002002 <argstr>
    return -1;
    800048fa:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800048fc:	12054663          	bltz	a0,80004a28 <sys_link+0x148>
    80004900:	08000613          	li	a2,128
    80004904:	f5040593          	addi	a1,s0,-176
    80004908:	4505                	li	a0,1
    8000490a:	ffffd097          	auipc	ra,0xffffd
    8000490e:	6f8080e7          	jalr	1784(ra) # 80002002 <argstr>
    return -1;
    80004912:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004914:	10054a63          	bltz	a0,80004a28 <sys_link+0x148>
    80004918:	ee26                	sd	s1,280(sp)
  begin_op();
    8000491a:	fffff097          	auipc	ra,0xfffff
    8000491e:	cb6080e7          	jalr	-842(ra) # 800035d0 <begin_op>
  if((ip = namei(old)) == 0){
    80004922:	ed040513          	addi	a0,s0,-304
    80004926:	fffff097          	auipc	ra,0xfffff
    8000492a:	aaa080e7          	jalr	-1366(ra) # 800033d0 <namei>
    8000492e:	84aa                	mv	s1,a0
    80004930:	c949                	beqz	a0,800049c2 <sys_link+0xe2>
  ilock(ip);
    80004932:	ffffe097          	auipc	ra,0xffffe
    80004936:	2cc080e7          	jalr	716(ra) # 80002bfe <ilock>
  if(ip->type == T_DIR){
    8000493a:	04449703          	lh	a4,68(s1)
    8000493e:	4785                	li	a5,1
    80004940:	08f70863          	beq	a4,a5,800049d0 <sys_link+0xf0>
    80004944:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004946:	04a4d783          	lhu	a5,74(s1)
    8000494a:	2785                	addiw	a5,a5,1
    8000494c:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004950:	8526                	mv	a0,s1
    80004952:	ffffe097          	auipc	ra,0xffffe
    80004956:	1e0080e7          	jalr	480(ra) # 80002b32 <iupdate>
  iunlock(ip);
    8000495a:	8526                	mv	a0,s1
    8000495c:	ffffe097          	auipc	ra,0xffffe
    80004960:	368080e7          	jalr	872(ra) # 80002cc4 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004964:	fd040593          	addi	a1,s0,-48
    80004968:	f5040513          	addi	a0,s0,-176
    8000496c:	fffff097          	auipc	ra,0xfffff
    80004970:	a82080e7          	jalr	-1406(ra) # 800033ee <nameiparent>
    80004974:	892a                	mv	s2,a0
    80004976:	cd35                	beqz	a0,800049f2 <sys_link+0x112>
  ilock(dp);
    80004978:	ffffe097          	auipc	ra,0xffffe
    8000497c:	286080e7          	jalr	646(ra) # 80002bfe <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004980:	00092703          	lw	a4,0(s2)
    80004984:	409c                	lw	a5,0(s1)
    80004986:	06f71163          	bne	a4,a5,800049e8 <sys_link+0x108>
    8000498a:	40d0                	lw	a2,4(s1)
    8000498c:	fd040593          	addi	a1,s0,-48
    80004990:	854a                	mv	a0,s2
    80004992:	fffff097          	auipc	ra,0xfffff
    80004996:	97c080e7          	jalr	-1668(ra) # 8000330e <dirlink>
    8000499a:	04054763          	bltz	a0,800049e8 <sys_link+0x108>
  iunlockput(dp);
    8000499e:	854a                	mv	a0,s2
    800049a0:	ffffe097          	auipc	ra,0xffffe
    800049a4:	4c4080e7          	jalr	1220(ra) # 80002e64 <iunlockput>
  iput(ip);
    800049a8:	8526                	mv	a0,s1
    800049aa:	ffffe097          	auipc	ra,0xffffe
    800049ae:	412080e7          	jalr	1042(ra) # 80002dbc <iput>
  end_op();
    800049b2:	fffff097          	auipc	ra,0xfffff
    800049b6:	c98080e7          	jalr	-872(ra) # 8000364a <end_op>
  return 0;
    800049ba:	4781                	li	a5,0
    800049bc:	64f2                	ld	s1,280(sp)
    800049be:	6952                	ld	s2,272(sp)
    800049c0:	a0a5                	j	80004a28 <sys_link+0x148>
    end_op();
    800049c2:	fffff097          	auipc	ra,0xfffff
    800049c6:	c88080e7          	jalr	-888(ra) # 8000364a <end_op>
    return -1;
    800049ca:	57fd                	li	a5,-1
    800049cc:	64f2                	ld	s1,280(sp)
    800049ce:	a8a9                	j	80004a28 <sys_link+0x148>
    iunlockput(ip);
    800049d0:	8526                	mv	a0,s1
    800049d2:	ffffe097          	auipc	ra,0xffffe
    800049d6:	492080e7          	jalr	1170(ra) # 80002e64 <iunlockput>
    end_op();
    800049da:	fffff097          	auipc	ra,0xfffff
    800049de:	c70080e7          	jalr	-912(ra) # 8000364a <end_op>
    return -1;
    800049e2:	57fd                	li	a5,-1
    800049e4:	64f2                	ld	s1,280(sp)
    800049e6:	a089                	j	80004a28 <sys_link+0x148>
    iunlockput(dp);
    800049e8:	854a                	mv	a0,s2
    800049ea:	ffffe097          	auipc	ra,0xffffe
    800049ee:	47a080e7          	jalr	1146(ra) # 80002e64 <iunlockput>
  ilock(ip);
    800049f2:	8526                	mv	a0,s1
    800049f4:	ffffe097          	auipc	ra,0xffffe
    800049f8:	20a080e7          	jalr	522(ra) # 80002bfe <ilock>
  ip->nlink--;
    800049fc:	04a4d783          	lhu	a5,74(s1)
    80004a00:	37fd                	addiw	a5,a5,-1
    80004a02:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004a06:	8526                	mv	a0,s1
    80004a08:	ffffe097          	auipc	ra,0xffffe
    80004a0c:	12a080e7          	jalr	298(ra) # 80002b32 <iupdate>
  iunlockput(ip);
    80004a10:	8526                	mv	a0,s1
    80004a12:	ffffe097          	auipc	ra,0xffffe
    80004a16:	452080e7          	jalr	1106(ra) # 80002e64 <iunlockput>
  end_op();
    80004a1a:	fffff097          	auipc	ra,0xfffff
    80004a1e:	c30080e7          	jalr	-976(ra) # 8000364a <end_op>
  return -1;
    80004a22:	57fd                	li	a5,-1
    80004a24:	64f2                	ld	s1,280(sp)
    80004a26:	6952                	ld	s2,272(sp)
}
    80004a28:	853e                	mv	a0,a5
    80004a2a:	70b2                	ld	ra,296(sp)
    80004a2c:	7412                	ld	s0,288(sp)
    80004a2e:	6155                	addi	sp,sp,304
    80004a30:	8082                	ret

0000000080004a32 <sys_unlink>:
{
    80004a32:	7151                	addi	sp,sp,-240
    80004a34:	f586                	sd	ra,232(sp)
    80004a36:	f1a2                	sd	s0,224(sp)
    80004a38:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004a3a:	08000613          	li	a2,128
    80004a3e:	f3040593          	addi	a1,s0,-208
    80004a42:	4501                	li	a0,0
    80004a44:	ffffd097          	auipc	ra,0xffffd
    80004a48:	5be080e7          	jalr	1470(ra) # 80002002 <argstr>
    80004a4c:	1a054a63          	bltz	a0,80004c00 <sys_unlink+0x1ce>
    80004a50:	eda6                	sd	s1,216(sp)
  begin_op();
    80004a52:	fffff097          	auipc	ra,0xfffff
    80004a56:	b7e080e7          	jalr	-1154(ra) # 800035d0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004a5a:	fb040593          	addi	a1,s0,-80
    80004a5e:	f3040513          	addi	a0,s0,-208
    80004a62:	fffff097          	auipc	ra,0xfffff
    80004a66:	98c080e7          	jalr	-1652(ra) # 800033ee <nameiparent>
    80004a6a:	84aa                	mv	s1,a0
    80004a6c:	cd71                	beqz	a0,80004b48 <sys_unlink+0x116>
  ilock(dp);
    80004a6e:	ffffe097          	auipc	ra,0xffffe
    80004a72:	190080e7          	jalr	400(ra) # 80002bfe <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004a76:	00004597          	auipc	a1,0x4
    80004a7a:	bc258593          	addi	a1,a1,-1086 # 80008638 <etext+0x638>
    80004a7e:	fb040513          	addi	a0,s0,-80
    80004a82:	ffffe097          	auipc	ra,0xffffe
    80004a86:	662080e7          	jalr	1634(ra) # 800030e4 <namecmp>
    80004a8a:	14050c63          	beqz	a0,80004be2 <sys_unlink+0x1b0>
    80004a8e:	00004597          	auipc	a1,0x4
    80004a92:	bb258593          	addi	a1,a1,-1102 # 80008640 <etext+0x640>
    80004a96:	fb040513          	addi	a0,s0,-80
    80004a9a:	ffffe097          	auipc	ra,0xffffe
    80004a9e:	64a080e7          	jalr	1610(ra) # 800030e4 <namecmp>
    80004aa2:	14050063          	beqz	a0,80004be2 <sys_unlink+0x1b0>
    80004aa6:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004aa8:	f2c40613          	addi	a2,s0,-212
    80004aac:	fb040593          	addi	a1,s0,-80
    80004ab0:	8526                	mv	a0,s1
    80004ab2:	ffffe097          	auipc	ra,0xffffe
    80004ab6:	64c080e7          	jalr	1612(ra) # 800030fe <dirlookup>
    80004aba:	892a                	mv	s2,a0
    80004abc:	12050263          	beqz	a0,80004be0 <sys_unlink+0x1ae>
  ilock(ip);
    80004ac0:	ffffe097          	auipc	ra,0xffffe
    80004ac4:	13e080e7          	jalr	318(ra) # 80002bfe <ilock>
  if(ip->nlink < 1)
    80004ac8:	04a91783          	lh	a5,74(s2)
    80004acc:	08f05563          	blez	a5,80004b56 <sys_unlink+0x124>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004ad0:	04491703          	lh	a4,68(s2)
    80004ad4:	4785                	li	a5,1
    80004ad6:	08f70963          	beq	a4,a5,80004b68 <sys_unlink+0x136>
  memset(&de, 0, sizeof(de));
    80004ada:	4641                	li	a2,16
    80004adc:	4581                	li	a1,0
    80004ade:	fc040513          	addi	a0,s0,-64
    80004ae2:	ffffb097          	auipc	ra,0xffffb
    80004ae6:	6e2080e7          	jalr	1762(ra) # 800001c4 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004aea:	4741                	li	a4,16
    80004aec:	f2c42683          	lw	a3,-212(s0)
    80004af0:	fc040613          	addi	a2,s0,-64
    80004af4:	4581                	li	a1,0
    80004af6:	8526                	mv	a0,s1
    80004af8:	ffffe097          	auipc	ra,0xffffe
    80004afc:	4c2080e7          	jalr	1218(ra) # 80002fba <writei>
    80004b00:	47c1                	li	a5,16
    80004b02:	0af51b63          	bne	a0,a5,80004bb8 <sys_unlink+0x186>
  if(ip->type == T_DIR){
    80004b06:	04491703          	lh	a4,68(s2)
    80004b0a:	4785                	li	a5,1
    80004b0c:	0af70f63          	beq	a4,a5,80004bca <sys_unlink+0x198>
  iunlockput(dp);
    80004b10:	8526                	mv	a0,s1
    80004b12:	ffffe097          	auipc	ra,0xffffe
    80004b16:	352080e7          	jalr	850(ra) # 80002e64 <iunlockput>
  ip->nlink--;
    80004b1a:	04a95783          	lhu	a5,74(s2)
    80004b1e:	37fd                	addiw	a5,a5,-1
    80004b20:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004b24:	854a                	mv	a0,s2
    80004b26:	ffffe097          	auipc	ra,0xffffe
    80004b2a:	00c080e7          	jalr	12(ra) # 80002b32 <iupdate>
  iunlockput(ip);
    80004b2e:	854a                	mv	a0,s2
    80004b30:	ffffe097          	auipc	ra,0xffffe
    80004b34:	334080e7          	jalr	820(ra) # 80002e64 <iunlockput>
  end_op();
    80004b38:	fffff097          	auipc	ra,0xfffff
    80004b3c:	b12080e7          	jalr	-1262(ra) # 8000364a <end_op>
  return 0;
    80004b40:	4501                	li	a0,0
    80004b42:	64ee                	ld	s1,216(sp)
    80004b44:	694e                	ld	s2,208(sp)
    80004b46:	a84d                	j	80004bf8 <sys_unlink+0x1c6>
    end_op();
    80004b48:	fffff097          	auipc	ra,0xfffff
    80004b4c:	b02080e7          	jalr	-1278(ra) # 8000364a <end_op>
    return -1;
    80004b50:	557d                	li	a0,-1
    80004b52:	64ee                	ld	s1,216(sp)
    80004b54:	a055                	j	80004bf8 <sys_unlink+0x1c6>
    80004b56:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80004b58:	00004517          	auipc	a0,0x4
    80004b5c:	b1050513          	addi	a0,a0,-1264 # 80008668 <etext+0x668>
    80004b60:	00001097          	auipc	ra,0x1
    80004b64:	20c080e7          	jalr	524(ra) # 80005d6c <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004b68:	04c92703          	lw	a4,76(s2)
    80004b6c:	02000793          	li	a5,32
    80004b70:	f6e7f5e3          	bgeu	a5,a4,80004ada <sys_unlink+0xa8>
    80004b74:	e5ce                	sd	s3,200(sp)
    80004b76:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b7a:	4741                	li	a4,16
    80004b7c:	86ce                	mv	a3,s3
    80004b7e:	f1840613          	addi	a2,s0,-232
    80004b82:	4581                	li	a1,0
    80004b84:	854a                	mv	a0,s2
    80004b86:	ffffe097          	auipc	ra,0xffffe
    80004b8a:	330080e7          	jalr	816(ra) # 80002eb6 <readi>
    80004b8e:	47c1                	li	a5,16
    80004b90:	00f51c63          	bne	a0,a5,80004ba8 <sys_unlink+0x176>
    if(de.inum != 0)
    80004b94:	f1845783          	lhu	a5,-232(s0)
    80004b98:	e7b5                	bnez	a5,80004c04 <sys_unlink+0x1d2>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004b9a:	29c1                	addiw	s3,s3,16
    80004b9c:	04c92783          	lw	a5,76(s2)
    80004ba0:	fcf9ede3          	bltu	s3,a5,80004b7a <sys_unlink+0x148>
    80004ba4:	69ae                	ld	s3,200(sp)
    80004ba6:	bf15                	j	80004ada <sys_unlink+0xa8>
      panic("isdirempty: readi");
    80004ba8:	00004517          	auipc	a0,0x4
    80004bac:	ad850513          	addi	a0,a0,-1320 # 80008680 <etext+0x680>
    80004bb0:	00001097          	auipc	ra,0x1
    80004bb4:	1bc080e7          	jalr	444(ra) # 80005d6c <panic>
    80004bb8:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80004bba:	00004517          	auipc	a0,0x4
    80004bbe:	ade50513          	addi	a0,a0,-1314 # 80008698 <etext+0x698>
    80004bc2:	00001097          	auipc	ra,0x1
    80004bc6:	1aa080e7          	jalr	426(ra) # 80005d6c <panic>
    dp->nlink--;
    80004bca:	04a4d783          	lhu	a5,74(s1)
    80004bce:	37fd                	addiw	a5,a5,-1
    80004bd0:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004bd4:	8526                	mv	a0,s1
    80004bd6:	ffffe097          	auipc	ra,0xffffe
    80004bda:	f5c080e7          	jalr	-164(ra) # 80002b32 <iupdate>
    80004bde:	bf0d                	j	80004b10 <sys_unlink+0xde>
    80004be0:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80004be2:	8526                	mv	a0,s1
    80004be4:	ffffe097          	auipc	ra,0xffffe
    80004be8:	280080e7          	jalr	640(ra) # 80002e64 <iunlockput>
  end_op();
    80004bec:	fffff097          	auipc	ra,0xfffff
    80004bf0:	a5e080e7          	jalr	-1442(ra) # 8000364a <end_op>
  return -1;
    80004bf4:	557d                	li	a0,-1
    80004bf6:	64ee                	ld	s1,216(sp)
}
    80004bf8:	70ae                	ld	ra,232(sp)
    80004bfa:	740e                	ld	s0,224(sp)
    80004bfc:	616d                	addi	sp,sp,240
    80004bfe:	8082                	ret
    return -1;
    80004c00:	557d                	li	a0,-1
    80004c02:	bfdd                	j	80004bf8 <sys_unlink+0x1c6>
    iunlockput(ip);
    80004c04:	854a                	mv	a0,s2
    80004c06:	ffffe097          	auipc	ra,0xffffe
    80004c0a:	25e080e7          	jalr	606(ra) # 80002e64 <iunlockput>
    goto bad;
    80004c0e:	694e                	ld	s2,208(sp)
    80004c10:	69ae                	ld	s3,200(sp)
    80004c12:	bfc1                	j	80004be2 <sys_unlink+0x1b0>

0000000080004c14 <sys_open>:

uint64
sys_open(void)
{
    80004c14:	7131                	addi	sp,sp,-192
    80004c16:	fd06                	sd	ra,184(sp)
    80004c18:	f922                	sd	s0,176(sp)
    80004c1a:	f526                	sd	s1,168(sp)
    80004c1c:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004c1e:	08000613          	li	a2,128
    80004c22:	f5040593          	addi	a1,s0,-176
    80004c26:	4501                	li	a0,0
    80004c28:	ffffd097          	auipc	ra,0xffffd
    80004c2c:	3da080e7          	jalr	986(ra) # 80002002 <argstr>
    return -1;
    80004c30:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004c32:	0c054463          	bltz	a0,80004cfa <sys_open+0xe6>
    80004c36:	f4c40593          	addi	a1,s0,-180
    80004c3a:	4505                	li	a0,1
    80004c3c:	ffffd097          	auipc	ra,0xffffd
    80004c40:	382080e7          	jalr	898(ra) # 80001fbe <argint>
    80004c44:	0a054b63          	bltz	a0,80004cfa <sys_open+0xe6>
    80004c48:	f14a                	sd	s2,160(sp)

  begin_op();
    80004c4a:	fffff097          	auipc	ra,0xfffff
    80004c4e:	986080e7          	jalr	-1658(ra) # 800035d0 <begin_op>

  if(omode & O_CREATE){
    80004c52:	f4c42783          	lw	a5,-180(s0)
    80004c56:	2007f793          	andi	a5,a5,512
    80004c5a:	cfc5                	beqz	a5,80004d12 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004c5c:	4681                	li	a3,0
    80004c5e:	4601                	li	a2,0
    80004c60:	4589                	li	a1,2
    80004c62:	f5040513          	addi	a0,s0,-176
    80004c66:	00000097          	auipc	ra,0x0
    80004c6a:	958080e7          	jalr	-1704(ra) # 800045be <create>
    80004c6e:	892a                	mv	s2,a0
    if(ip == 0){
    80004c70:	c959                	beqz	a0,80004d06 <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004c72:	04491703          	lh	a4,68(s2)
    80004c76:	478d                	li	a5,3
    80004c78:	00f71763          	bne	a4,a5,80004c86 <sys_open+0x72>
    80004c7c:	04695703          	lhu	a4,70(s2)
    80004c80:	47a5                	li	a5,9
    80004c82:	0ce7ef63          	bltu	a5,a4,80004d60 <sys_open+0x14c>
    80004c86:	ed4e                	sd	s3,152(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004c88:	fffff097          	auipc	ra,0xfffff
    80004c8c:	d56080e7          	jalr	-682(ra) # 800039de <filealloc>
    80004c90:	89aa                	mv	s3,a0
    80004c92:	c965                	beqz	a0,80004d82 <sys_open+0x16e>
    80004c94:	00000097          	auipc	ra,0x0
    80004c98:	8e8080e7          	jalr	-1816(ra) # 8000457c <fdalloc>
    80004c9c:	84aa                	mv	s1,a0
    80004c9e:	0c054d63          	bltz	a0,80004d78 <sys_open+0x164>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004ca2:	04491703          	lh	a4,68(s2)
    80004ca6:	478d                	li	a5,3
    80004ca8:	0ef70a63          	beq	a4,a5,80004d9c <sys_open+0x188>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004cac:	4789                	li	a5,2
    80004cae:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004cb2:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004cb6:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004cba:	f4c42783          	lw	a5,-180(s0)
    80004cbe:	0017c713          	xori	a4,a5,1
    80004cc2:	8b05                	andi	a4,a4,1
    80004cc4:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004cc8:	0037f713          	andi	a4,a5,3
    80004ccc:	00e03733          	snez	a4,a4
    80004cd0:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004cd4:	4007f793          	andi	a5,a5,1024
    80004cd8:	c791                	beqz	a5,80004ce4 <sys_open+0xd0>
    80004cda:	04491703          	lh	a4,68(s2)
    80004cde:	4789                	li	a5,2
    80004ce0:	0cf70563          	beq	a4,a5,80004daa <sys_open+0x196>
    itrunc(ip);
  }

  iunlock(ip);
    80004ce4:	854a                	mv	a0,s2
    80004ce6:	ffffe097          	auipc	ra,0xffffe
    80004cea:	fde080e7          	jalr	-34(ra) # 80002cc4 <iunlock>
  end_op();
    80004cee:	fffff097          	auipc	ra,0xfffff
    80004cf2:	95c080e7          	jalr	-1700(ra) # 8000364a <end_op>
    80004cf6:	790a                	ld	s2,160(sp)
    80004cf8:	69ea                	ld	s3,152(sp)

  return fd;
}
    80004cfa:	8526                	mv	a0,s1
    80004cfc:	70ea                	ld	ra,184(sp)
    80004cfe:	744a                	ld	s0,176(sp)
    80004d00:	74aa                	ld	s1,168(sp)
    80004d02:	6129                	addi	sp,sp,192
    80004d04:	8082                	ret
      end_op();
    80004d06:	fffff097          	auipc	ra,0xfffff
    80004d0a:	944080e7          	jalr	-1724(ra) # 8000364a <end_op>
      return -1;
    80004d0e:	790a                	ld	s2,160(sp)
    80004d10:	b7ed                	j	80004cfa <sys_open+0xe6>
    if((ip = namei(path)) == 0){
    80004d12:	f5040513          	addi	a0,s0,-176
    80004d16:	ffffe097          	auipc	ra,0xffffe
    80004d1a:	6ba080e7          	jalr	1722(ra) # 800033d0 <namei>
    80004d1e:	892a                	mv	s2,a0
    80004d20:	c90d                	beqz	a0,80004d52 <sys_open+0x13e>
    ilock(ip);
    80004d22:	ffffe097          	auipc	ra,0xffffe
    80004d26:	edc080e7          	jalr	-292(ra) # 80002bfe <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004d2a:	04491703          	lh	a4,68(s2)
    80004d2e:	4785                	li	a5,1
    80004d30:	f4f711e3          	bne	a4,a5,80004c72 <sys_open+0x5e>
    80004d34:	f4c42783          	lw	a5,-180(s0)
    80004d38:	d7b9                	beqz	a5,80004c86 <sys_open+0x72>
      iunlockput(ip);
    80004d3a:	854a                	mv	a0,s2
    80004d3c:	ffffe097          	auipc	ra,0xffffe
    80004d40:	128080e7          	jalr	296(ra) # 80002e64 <iunlockput>
      end_op();
    80004d44:	fffff097          	auipc	ra,0xfffff
    80004d48:	906080e7          	jalr	-1786(ra) # 8000364a <end_op>
      return -1;
    80004d4c:	54fd                	li	s1,-1
    80004d4e:	790a                	ld	s2,160(sp)
    80004d50:	b76d                	j	80004cfa <sys_open+0xe6>
      end_op();
    80004d52:	fffff097          	auipc	ra,0xfffff
    80004d56:	8f8080e7          	jalr	-1800(ra) # 8000364a <end_op>
      return -1;
    80004d5a:	54fd                	li	s1,-1
    80004d5c:	790a                	ld	s2,160(sp)
    80004d5e:	bf71                	j	80004cfa <sys_open+0xe6>
    iunlockput(ip);
    80004d60:	854a                	mv	a0,s2
    80004d62:	ffffe097          	auipc	ra,0xffffe
    80004d66:	102080e7          	jalr	258(ra) # 80002e64 <iunlockput>
    end_op();
    80004d6a:	fffff097          	auipc	ra,0xfffff
    80004d6e:	8e0080e7          	jalr	-1824(ra) # 8000364a <end_op>
    return -1;
    80004d72:	54fd                	li	s1,-1
    80004d74:	790a                	ld	s2,160(sp)
    80004d76:	b751                	j	80004cfa <sys_open+0xe6>
      fileclose(f);
    80004d78:	854e                	mv	a0,s3
    80004d7a:	fffff097          	auipc	ra,0xfffff
    80004d7e:	d20080e7          	jalr	-736(ra) # 80003a9a <fileclose>
    iunlockput(ip);
    80004d82:	854a                	mv	a0,s2
    80004d84:	ffffe097          	auipc	ra,0xffffe
    80004d88:	0e0080e7          	jalr	224(ra) # 80002e64 <iunlockput>
    end_op();
    80004d8c:	fffff097          	auipc	ra,0xfffff
    80004d90:	8be080e7          	jalr	-1858(ra) # 8000364a <end_op>
    return -1;
    80004d94:	54fd                	li	s1,-1
    80004d96:	790a                	ld	s2,160(sp)
    80004d98:	69ea                	ld	s3,152(sp)
    80004d9a:	b785                	j	80004cfa <sys_open+0xe6>
    f->type = FD_DEVICE;
    80004d9c:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004da0:	04691783          	lh	a5,70(s2)
    80004da4:	02f99223          	sh	a5,36(s3)
    80004da8:	b739                	j	80004cb6 <sys_open+0xa2>
    itrunc(ip);
    80004daa:	854a                	mv	a0,s2
    80004dac:	ffffe097          	auipc	ra,0xffffe
    80004db0:	f64080e7          	jalr	-156(ra) # 80002d10 <itrunc>
    80004db4:	bf05                	j	80004ce4 <sys_open+0xd0>

0000000080004db6 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004db6:	7175                	addi	sp,sp,-144
    80004db8:	e506                	sd	ra,136(sp)
    80004dba:	e122                	sd	s0,128(sp)
    80004dbc:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004dbe:	fffff097          	auipc	ra,0xfffff
    80004dc2:	812080e7          	jalr	-2030(ra) # 800035d0 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004dc6:	08000613          	li	a2,128
    80004dca:	f7040593          	addi	a1,s0,-144
    80004dce:	4501                	li	a0,0
    80004dd0:	ffffd097          	auipc	ra,0xffffd
    80004dd4:	232080e7          	jalr	562(ra) # 80002002 <argstr>
    80004dd8:	02054963          	bltz	a0,80004e0a <sys_mkdir+0x54>
    80004ddc:	4681                	li	a3,0
    80004dde:	4601                	li	a2,0
    80004de0:	4585                	li	a1,1
    80004de2:	f7040513          	addi	a0,s0,-144
    80004de6:	fffff097          	auipc	ra,0xfffff
    80004dea:	7d8080e7          	jalr	2008(ra) # 800045be <create>
    80004dee:	cd11                	beqz	a0,80004e0a <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004df0:	ffffe097          	auipc	ra,0xffffe
    80004df4:	074080e7          	jalr	116(ra) # 80002e64 <iunlockput>
  end_op();
    80004df8:	fffff097          	auipc	ra,0xfffff
    80004dfc:	852080e7          	jalr	-1966(ra) # 8000364a <end_op>
  return 0;
    80004e00:	4501                	li	a0,0
}
    80004e02:	60aa                	ld	ra,136(sp)
    80004e04:	640a                	ld	s0,128(sp)
    80004e06:	6149                	addi	sp,sp,144
    80004e08:	8082                	ret
    end_op();
    80004e0a:	fffff097          	auipc	ra,0xfffff
    80004e0e:	840080e7          	jalr	-1984(ra) # 8000364a <end_op>
    return -1;
    80004e12:	557d                	li	a0,-1
    80004e14:	b7fd                	j	80004e02 <sys_mkdir+0x4c>

0000000080004e16 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004e16:	7135                	addi	sp,sp,-160
    80004e18:	ed06                	sd	ra,152(sp)
    80004e1a:	e922                	sd	s0,144(sp)
    80004e1c:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004e1e:	ffffe097          	auipc	ra,0xffffe
    80004e22:	7b2080e7          	jalr	1970(ra) # 800035d0 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004e26:	08000613          	li	a2,128
    80004e2a:	f7040593          	addi	a1,s0,-144
    80004e2e:	4501                	li	a0,0
    80004e30:	ffffd097          	auipc	ra,0xffffd
    80004e34:	1d2080e7          	jalr	466(ra) # 80002002 <argstr>
    80004e38:	04054a63          	bltz	a0,80004e8c <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004e3c:	f6c40593          	addi	a1,s0,-148
    80004e40:	4505                	li	a0,1
    80004e42:	ffffd097          	auipc	ra,0xffffd
    80004e46:	17c080e7          	jalr	380(ra) # 80001fbe <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004e4a:	04054163          	bltz	a0,80004e8c <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004e4e:	f6840593          	addi	a1,s0,-152
    80004e52:	4509                	li	a0,2
    80004e54:	ffffd097          	auipc	ra,0xffffd
    80004e58:	16a080e7          	jalr	362(ra) # 80001fbe <argint>
     argint(1, &major) < 0 ||
    80004e5c:	02054863          	bltz	a0,80004e8c <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004e60:	f6841683          	lh	a3,-152(s0)
    80004e64:	f6c41603          	lh	a2,-148(s0)
    80004e68:	458d                	li	a1,3
    80004e6a:	f7040513          	addi	a0,s0,-144
    80004e6e:	fffff097          	auipc	ra,0xfffff
    80004e72:	750080e7          	jalr	1872(ra) # 800045be <create>
     argint(2, &minor) < 0 ||
    80004e76:	c919                	beqz	a0,80004e8c <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004e78:	ffffe097          	auipc	ra,0xffffe
    80004e7c:	fec080e7          	jalr	-20(ra) # 80002e64 <iunlockput>
  end_op();
    80004e80:	ffffe097          	auipc	ra,0xffffe
    80004e84:	7ca080e7          	jalr	1994(ra) # 8000364a <end_op>
  return 0;
    80004e88:	4501                	li	a0,0
    80004e8a:	a031                	j	80004e96 <sys_mknod+0x80>
    end_op();
    80004e8c:	ffffe097          	auipc	ra,0xffffe
    80004e90:	7be080e7          	jalr	1982(ra) # 8000364a <end_op>
    return -1;
    80004e94:	557d                	li	a0,-1
}
    80004e96:	60ea                	ld	ra,152(sp)
    80004e98:	644a                	ld	s0,144(sp)
    80004e9a:	610d                	addi	sp,sp,160
    80004e9c:	8082                	ret

0000000080004e9e <sys_chdir>:

uint64
sys_chdir(void)
{
    80004e9e:	7135                	addi	sp,sp,-160
    80004ea0:	ed06                	sd	ra,152(sp)
    80004ea2:	e922                	sd	s0,144(sp)
    80004ea4:	e14a                	sd	s2,128(sp)
    80004ea6:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004ea8:	ffffc097          	auipc	ra,0xffffc
    80004eac:	01e080e7          	jalr	30(ra) # 80000ec6 <myproc>
    80004eb0:	892a                	mv	s2,a0
  
  begin_op();
    80004eb2:	ffffe097          	auipc	ra,0xffffe
    80004eb6:	71e080e7          	jalr	1822(ra) # 800035d0 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004eba:	08000613          	li	a2,128
    80004ebe:	f6040593          	addi	a1,s0,-160
    80004ec2:	4501                	li	a0,0
    80004ec4:	ffffd097          	auipc	ra,0xffffd
    80004ec8:	13e080e7          	jalr	318(ra) # 80002002 <argstr>
    80004ecc:	04054d63          	bltz	a0,80004f26 <sys_chdir+0x88>
    80004ed0:	e526                	sd	s1,136(sp)
    80004ed2:	f6040513          	addi	a0,s0,-160
    80004ed6:	ffffe097          	auipc	ra,0xffffe
    80004eda:	4fa080e7          	jalr	1274(ra) # 800033d0 <namei>
    80004ede:	84aa                	mv	s1,a0
    80004ee0:	c131                	beqz	a0,80004f24 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004ee2:	ffffe097          	auipc	ra,0xffffe
    80004ee6:	d1c080e7          	jalr	-740(ra) # 80002bfe <ilock>
  if(ip->type != T_DIR){
    80004eea:	04449703          	lh	a4,68(s1)
    80004eee:	4785                	li	a5,1
    80004ef0:	04f71163          	bne	a4,a5,80004f32 <sys_chdir+0x94>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004ef4:	8526                	mv	a0,s1
    80004ef6:	ffffe097          	auipc	ra,0xffffe
    80004efa:	dce080e7          	jalr	-562(ra) # 80002cc4 <iunlock>
  iput(p->cwd);
    80004efe:	15093503          	ld	a0,336(s2)
    80004f02:	ffffe097          	auipc	ra,0xffffe
    80004f06:	eba080e7          	jalr	-326(ra) # 80002dbc <iput>
  end_op();
    80004f0a:	ffffe097          	auipc	ra,0xffffe
    80004f0e:	740080e7          	jalr	1856(ra) # 8000364a <end_op>
  p->cwd = ip;
    80004f12:	14993823          	sd	s1,336(s2)
  return 0;
    80004f16:	4501                	li	a0,0
    80004f18:	64aa                	ld	s1,136(sp)
}
    80004f1a:	60ea                	ld	ra,152(sp)
    80004f1c:	644a                	ld	s0,144(sp)
    80004f1e:	690a                	ld	s2,128(sp)
    80004f20:	610d                	addi	sp,sp,160
    80004f22:	8082                	ret
    80004f24:	64aa                	ld	s1,136(sp)
    end_op();
    80004f26:	ffffe097          	auipc	ra,0xffffe
    80004f2a:	724080e7          	jalr	1828(ra) # 8000364a <end_op>
    return -1;
    80004f2e:	557d                	li	a0,-1
    80004f30:	b7ed                	j	80004f1a <sys_chdir+0x7c>
    iunlockput(ip);
    80004f32:	8526                	mv	a0,s1
    80004f34:	ffffe097          	auipc	ra,0xffffe
    80004f38:	f30080e7          	jalr	-208(ra) # 80002e64 <iunlockput>
    end_op();
    80004f3c:	ffffe097          	auipc	ra,0xffffe
    80004f40:	70e080e7          	jalr	1806(ra) # 8000364a <end_op>
    return -1;
    80004f44:	557d                	li	a0,-1
    80004f46:	64aa                	ld	s1,136(sp)
    80004f48:	bfc9                	j	80004f1a <sys_chdir+0x7c>

0000000080004f4a <sys_exec>:

uint64
sys_exec(void)
{
    80004f4a:	7121                	addi	sp,sp,-448
    80004f4c:	ff06                	sd	ra,440(sp)
    80004f4e:	fb22                	sd	s0,432(sp)
    80004f50:	f34a                	sd	s2,416(sp)
    80004f52:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004f54:	08000613          	li	a2,128
    80004f58:	f5040593          	addi	a1,s0,-176
    80004f5c:	4501                	li	a0,0
    80004f5e:	ffffd097          	auipc	ra,0xffffd
    80004f62:	0a4080e7          	jalr	164(ra) # 80002002 <argstr>
    return -1;
    80004f66:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004f68:	0e054a63          	bltz	a0,8000505c <sys_exec+0x112>
    80004f6c:	e4840593          	addi	a1,s0,-440
    80004f70:	4505                	li	a0,1
    80004f72:	ffffd097          	auipc	ra,0xffffd
    80004f76:	06e080e7          	jalr	110(ra) # 80001fe0 <argaddr>
    80004f7a:	0e054163          	bltz	a0,8000505c <sys_exec+0x112>
    80004f7e:	f726                	sd	s1,424(sp)
    80004f80:	ef4e                	sd	s3,408(sp)
    80004f82:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    80004f84:	10000613          	li	a2,256
    80004f88:	4581                	li	a1,0
    80004f8a:	e5040513          	addi	a0,s0,-432
    80004f8e:	ffffb097          	auipc	ra,0xffffb
    80004f92:	236080e7          	jalr	566(ra) # 800001c4 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004f96:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80004f9a:	89a6                	mv	s3,s1
    80004f9c:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004f9e:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004fa2:	00391513          	slli	a0,s2,0x3
    80004fa6:	e4040593          	addi	a1,s0,-448
    80004faa:	e4843783          	ld	a5,-440(s0)
    80004fae:	953e                	add	a0,a0,a5
    80004fb0:	ffffd097          	auipc	ra,0xffffd
    80004fb4:	f74080e7          	jalr	-140(ra) # 80001f24 <fetchaddr>
    80004fb8:	02054a63          	bltz	a0,80004fec <sys_exec+0xa2>
      goto bad;
    }
    if(uarg == 0){
    80004fbc:	e4043783          	ld	a5,-448(s0)
    80004fc0:	c7b1                	beqz	a5,8000500c <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004fc2:	ffffb097          	auipc	ra,0xffffb
    80004fc6:	158080e7          	jalr	344(ra) # 8000011a <kalloc>
    80004fca:	85aa                	mv	a1,a0
    80004fcc:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004fd0:	cd11                	beqz	a0,80004fec <sys_exec+0xa2>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004fd2:	6605                	lui	a2,0x1
    80004fd4:	e4043503          	ld	a0,-448(s0)
    80004fd8:	ffffd097          	auipc	ra,0xffffd
    80004fdc:	f9e080e7          	jalr	-98(ra) # 80001f76 <fetchstr>
    80004fe0:	00054663          	bltz	a0,80004fec <sys_exec+0xa2>
    if(i >= NELEM(argv)){
    80004fe4:	0905                	addi	s2,s2,1
    80004fe6:	09a1                	addi	s3,s3,8
    80004fe8:	fb491de3          	bne	s2,s4,80004fa2 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004fec:	f5040913          	addi	s2,s0,-176
    80004ff0:	6088                	ld	a0,0(s1)
    80004ff2:	c12d                	beqz	a0,80005054 <sys_exec+0x10a>
    kfree(argv[i]);
    80004ff4:	ffffb097          	auipc	ra,0xffffb
    80004ff8:	028080e7          	jalr	40(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004ffc:	04a1                	addi	s1,s1,8
    80004ffe:	ff2499e3          	bne	s1,s2,80004ff0 <sys_exec+0xa6>
  return -1;
    80005002:	597d                	li	s2,-1
    80005004:	74ba                	ld	s1,424(sp)
    80005006:	69fa                	ld	s3,408(sp)
    80005008:	6a5a                	ld	s4,400(sp)
    8000500a:	a889                	j	8000505c <sys_exec+0x112>
      argv[i] = 0;
    8000500c:	0009079b          	sext.w	a5,s2
    80005010:	078e                	slli	a5,a5,0x3
    80005012:	fd078793          	addi	a5,a5,-48
    80005016:	97a2                	add	a5,a5,s0
    80005018:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    8000501c:	e5040593          	addi	a1,s0,-432
    80005020:	f5040513          	addi	a0,s0,-176
    80005024:	fffff097          	auipc	ra,0xfffff
    80005028:	126080e7          	jalr	294(ra) # 8000414a <exec>
    8000502c:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000502e:	f5040993          	addi	s3,s0,-176
    80005032:	6088                	ld	a0,0(s1)
    80005034:	cd01                	beqz	a0,8000504c <sys_exec+0x102>
    kfree(argv[i]);
    80005036:	ffffb097          	auipc	ra,0xffffb
    8000503a:	fe6080e7          	jalr	-26(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000503e:	04a1                	addi	s1,s1,8
    80005040:	ff3499e3          	bne	s1,s3,80005032 <sys_exec+0xe8>
    80005044:	74ba                	ld	s1,424(sp)
    80005046:	69fa                	ld	s3,408(sp)
    80005048:	6a5a                	ld	s4,400(sp)
    8000504a:	a809                	j	8000505c <sys_exec+0x112>
  return ret;
    8000504c:	74ba                	ld	s1,424(sp)
    8000504e:	69fa                	ld	s3,408(sp)
    80005050:	6a5a                	ld	s4,400(sp)
    80005052:	a029                	j	8000505c <sys_exec+0x112>
  return -1;
    80005054:	597d                	li	s2,-1
    80005056:	74ba                	ld	s1,424(sp)
    80005058:	69fa                	ld	s3,408(sp)
    8000505a:	6a5a                	ld	s4,400(sp)
}
    8000505c:	854a                	mv	a0,s2
    8000505e:	70fa                	ld	ra,440(sp)
    80005060:	745a                	ld	s0,432(sp)
    80005062:	791a                	ld	s2,416(sp)
    80005064:	6139                	addi	sp,sp,448
    80005066:	8082                	ret

0000000080005068 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005068:	7139                	addi	sp,sp,-64
    8000506a:	fc06                	sd	ra,56(sp)
    8000506c:	f822                	sd	s0,48(sp)
    8000506e:	f426                	sd	s1,40(sp)
    80005070:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005072:	ffffc097          	auipc	ra,0xffffc
    80005076:	e54080e7          	jalr	-428(ra) # 80000ec6 <myproc>
    8000507a:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    8000507c:	fd840593          	addi	a1,s0,-40
    80005080:	4501                	li	a0,0
    80005082:	ffffd097          	auipc	ra,0xffffd
    80005086:	f5e080e7          	jalr	-162(ra) # 80001fe0 <argaddr>
    return -1;
    8000508a:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    8000508c:	0e054063          	bltz	a0,8000516c <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80005090:	fc840593          	addi	a1,s0,-56
    80005094:	fd040513          	addi	a0,s0,-48
    80005098:	fffff097          	auipc	ra,0xfffff
    8000509c:	d70080e7          	jalr	-656(ra) # 80003e08 <pipealloc>
    return -1;
    800050a0:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800050a2:	0c054563          	bltz	a0,8000516c <sys_pipe+0x104>
  fd0 = -1;
    800050a6:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800050aa:	fd043503          	ld	a0,-48(s0)
    800050ae:	fffff097          	auipc	ra,0xfffff
    800050b2:	4ce080e7          	jalr	1230(ra) # 8000457c <fdalloc>
    800050b6:	fca42223          	sw	a0,-60(s0)
    800050ba:	08054c63          	bltz	a0,80005152 <sys_pipe+0xea>
    800050be:	fc843503          	ld	a0,-56(s0)
    800050c2:	fffff097          	auipc	ra,0xfffff
    800050c6:	4ba080e7          	jalr	1210(ra) # 8000457c <fdalloc>
    800050ca:	fca42023          	sw	a0,-64(s0)
    800050ce:	06054963          	bltz	a0,80005140 <sys_pipe+0xd8>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800050d2:	4691                	li	a3,4
    800050d4:	fc440613          	addi	a2,s0,-60
    800050d8:	fd843583          	ld	a1,-40(s0)
    800050dc:	68a8                	ld	a0,80(s1)
    800050de:	ffffc097          	auipc	ra,0xffffc
    800050e2:	a84080e7          	jalr	-1404(ra) # 80000b62 <copyout>
    800050e6:	02054063          	bltz	a0,80005106 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800050ea:	4691                	li	a3,4
    800050ec:	fc040613          	addi	a2,s0,-64
    800050f0:	fd843583          	ld	a1,-40(s0)
    800050f4:	0591                	addi	a1,a1,4
    800050f6:	68a8                	ld	a0,80(s1)
    800050f8:	ffffc097          	auipc	ra,0xffffc
    800050fc:	a6a080e7          	jalr	-1430(ra) # 80000b62 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005100:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005102:	06055563          	bgez	a0,8000516c <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005106:	fc442783          	lw	a5,-60(s0)
    8000510a:	07e9                	addi	a5,a5,26
    8000510c:	078e                	slli	a5,a5,0x3
    8000510e:	97a6                	add	a5,a5,s1
    80005110:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005114:	fc042783          	lw	a5,-64(s0)
    80005118:	07e9                	addi	a5,a5,26
    8000511a:	078e                	slli	a5,a5,0x3
    8000511c:	00f48533          	add	a0,s1,a5
    80005120:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005124:	fd043503          	ld	a0,-48(s0)
    80005128:	fffff097          	auipc	ra,0xfffff
    8000512c:	972080e7          	jalr	-1678(ra) # 80003a9a <fileclose>
    fileclose(wf);
    80005130:	fc843503          	ld	a0,-56(s0)
    80005134:	fffff097          	auipc	ra,0xfffff
    80005138:	966080e7          	jalr	-1690(ra) # 80003a9a <fileclose>
    return -1;
    8000513c:	57fd                	li	a5,-1
    8000513e:	a03d                	j	8000516c <sys_pipe+0x104>
    if(fd0 >= 0)
    80005140:	fc442783          	lw	a5,-60(s0)
    80005144:	0007c763          	bltz	a5,80005152 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005148:	07e9                	addi	a5,a5,26
    8000514a:	078e                	slli	a5,a5,0x3
    8000514c:	97a6                	add	a5,a5,s1
    8000514e:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005152:	fd043503          	ld	a0,-48(s0)
    80005156:	fffff097          	auipc	ra,0xfffff
    8000515a:	944080e7          	jalr	-1724(ra) # 80003a9a <fileclose>
    fileclose(wf);
    8000515e:	fc843503          	ld	a0,-56(s0)
    80005162:	fffff097          	auipc	ra,0xfffff
    80005166:	938080e7          	jalr	-1736(ra) # 80003a9a <fileclose>
    return -1;
    8000516a:	57fd                	li	a5,-1
}
    8000516c:	853e                	mv	a0,a5
    8000516e:	70e2                	ld	ra,56(sp)
    80005170:	7442                	ld	s0,48(sp)
    80005172:	74a2                	ld	s1,40(sp)
    80005174:	6121                	addi	sp,sp,64
    80005176:	8082                	ret
	...

0000000080005180 <kernelvec>:
    80005180:	7111                	addi	sp,sp,-256
    80005182:	e006                	sd	ra,0(sp)
    80005184:	e40a                	sd	sp,8(sp)
    80005186:	e80e                	sd	gp,16(sp)
    80005188:	ec12                	sd	tp,24(sp)
    8000518a:	f016                	sd	t0,32(sp)
    8000518c:	f41a                	sd	t1,40(sp)
    8000518e:	f81e                	sd	t2,48(sp)
    80005190:	fc22                	sd	s0,56(sp)
    80005192:	e0a6                	sd	s1,64(sp)
    80005194:	e4aa                	sd	a0,72(sp)
    80005196:	e8ae                	sd	a1,80(sp)
    80005198:	ecb2                	sd	a2,88(sp)
    8000519a:	f0b6                	sd	a3,96(sp)
    8000519c:	f4ba                	sd	a4,104(sp)
    8000519e:	f8be                	sd	a5,112(sp)
    800051a0:	fcc2                	sd	a6,120(sp)
    800051a2:	e146                	sd	a7,128(sp)
    800051a4:	e54a                	sd	s2,136(sp)
    800051a6:	e94e                	sd	s3,144(sp)
    800051a8:	ed52                	sd	s4,152(sp)
    800051aa:	f156                	sd	s5,160(sp)
    800051ac:	f55a                	sd	s6,168(sp)
    800051ae:	f95e                	sd	s7,176(sp)
    800051b0:	fd62                	sd	s8,184(sp)
    800051b2:	e1e6                	sd	s9,192(sp)
    800051b4:	e5ea                	sd	s10,200(sp)
    800051b6:	e9ee                	sd	s11,208(sp)
    800051b8:	edf2                	sd	t3,216(sp)
    800051ba:	f1f6                	sd	t4,224(sp)
    800051bc:	f5fa                	sd	t5,232(sp)
    800051be:	f9fe                	sd	t6,240(sp)
    800051c0:	c31fc0ef          	jal	80001df0 <kerneltrap>
    800051c4:	6082                	ld	ra,0(sp)
    800051c6:	6122                	ld	sp,8(sp)
    800051c8:	61c2                	ld	gp,16(sp)
    800051ca:	7282                	ld	t0,32(sp)
    800051cc:	7322                	ld	t1,40(sp)
    800051ce:	73c2                	ld	t2,48(sp)
    800051d0:	7462                	ld	s0,56(sp)
    800051d2:	6486                	ld	s1,64(sp)
    800051d4:	6526                	ld	a0,72(sp)
    800051d6:	65c6                	ld	a1,80(sp)
    800051d8:	6666                	ld	a2,88(sp)
    800051da:	7686                	ld	a3,96(sp)
    800051dc:	7726                	ld	a4,104(sp)
    800051de:	77c6                	ld	a5,112(sp)
    800051e0:	7866                	ld	a6,120(sp)
    800051e2:	688a                	ld	a7,128(sp)
    800051e4:	692a                	ld	s2,136(sp)
    800051e6:	69ca                	ld	s3,144(sp)
    800051e8:	6a6a                	ld	s4,152(sp)
    800051ea:	7a8a                	ld	s5,160(sp)
    800051ec:	7b2a                	ld	s6,168(sp)
    800051ee:	7bca                	ld	s7,176(sp)
    800051f0:	7c6a                	ld	s8,184(sp)
    800051f2:	6c8e                	ld	s9,192(sp)
    800051f4:	6d2e                	ld	s10,200(sp)
    800051f6:	6dce                	ld	s11,208(sp)
    800051f8:	6e6e                	ld	t3,216(sp)
    800051fa:	7e8e                	ld	t4,224(sp)
    800051fc:	7f2e                	ld	t5,232(sp)
    800051fe:	7fce                	ld	t6,240(sp)
    80005200:	6111                	addi	sp,sp,256
    80005202:	10200073          	sret
    80005206:	00000013          	nop
    8000520a:	00000013          	nop
    8000520e:	0001                	nop

0000000080005210 <timervec>:
    80005210:	34051573          	csrrw	a0,mscratch,a0
    80005214:	e10c                	sd	a1,0(a0)
    80005216:	e510                	sd	a2,8(a0)
    80005218:	e914                	sd	a3,16(a0)
    8000521a:	6d0c                	ld	a1,24(a0)
    8000521c:	7110                	ld	a2,32(a0)
    8000521e:	6194                	ld	a3,0(a1)
    80005220:	96b2                	add	a3,a3,a2
    80005222:	e194                	sd	a3,0(a1)
    80005224:	4589                	li	a1,2
    80005226:	14459073          	csrw	sip,a1
    8000522a:	6914                	ld	a3,16(a0)
    8000522c:	6510                	ld	a2,8(a0)
    8000522e:	610c                	ld	a1,0(a0)
    80005230:	34051573          	csrrw	a0,mscratch,a0
    80005234:	30200073          	mret
	...

000000008000523a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000523a:	1141                	addi	sp,sp,-16
    8000523c:	e422                	sd	s0,8(sp)
    8000523e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005240:	0c0007b7          	lui	a5,0xc000
    80005244:	4705                	li	a4,1
    80005246:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005248:	0c0007b7          	lui	a5,0xc000
    8000524c:	c3d8                	sw	a4,4(a5)
}
    8000524e:	6422                	ld	s0,8(sp)
    80005250:	0141                	addi	sp,sp,16
    80005252:	8082                	ret

0000000080005254 <plicinithart>:

void
plicinithart(void)
{
    80005254:	1141                	addi	sp,sp,-16
    80005256:	e406                	sd	ra,8(sp)
    80005258:	e022                	sd	s0,0(sp)
    8000525a:	0800                	addi	s0,sp,16
  int hart = cpuid();
    8000525c:	ffffc097          	auipc	ra,0xffffc
    80005260:	c3e080e7          	jalr	-962(ra) # 80000e9a <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005264:	0085171b          	slliw	a4,a0,0x8
    80005268:	0c0027b7          	lui	a5,0xc002
    8000526c:	97ba                	add	a5,a5,a4
    8000526e:	40200713          	li	a4,1026
    80005272:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005276:	00d5151b          	slliw	a0,a0,0xd
    8000527a:	0c2017b7          	lui	a5,0xc201
    8000527e:	97aa                	add	a5,a5,a0
    80005280:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005284:	60a2                	ld	ra,8(sp)
    80005286:	6402                	ld	s0,0(sp)
    80005288:	0141                	addi	sp,sp,16
    8000528a:	8082                	ret

000000008000528c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000528c:	1141                	addi	sp,sp,-16
    8000528e:	e406                	sd	ra,8(sp)
    80005290:	e022                	sd	s0,0(sp)
    80005292:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005294:	ffffc097          	auipc	ra,0xffffc
    80005298:	c06080e7          	jalr	-1018(ra) # 80000e9a <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    8000529c:	00d5151b          	slliw	a0,a0,0xd
    800052a0:	0c2017b7          	lui	a5,0xc201
    800052a4:	97aa                	add	a5,a5,a0
  return irq;
}
    800052a6:	43c8                	lw	a0,4(a5)
    800052a8:	60a2                	ld	ra,8(sp)
    800052aa:	6402                	ld	s0,0(sp)
    800052ac:	0141                	addi	sp,sp,16
    800052ae:	8082                	ret

00000000800052b0 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800052b0:	1101                	addi	sp,sp,-32
    800052b2:	ec06                	sd	ra,24(sp)
    800052b4:	e822                	sd	s0,16(sp)
    800052b6:	e426                	sd	s1,8(sp)
    800052b8:	1000                	addi	s0,sp,32
    800052ba:	84aa                	mv	s1,a0
  int hart = cpuid();
    800052bc:	ffffc097          	auipc	ra,0xffffc
    800052c0:	bde080e7          	jalr	-1058(ra) # 80000e9a <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800052c4:	00d5151b          	slliw	a0,a0,0xd
    800052c8:	0c2017b7          	lui	a5,0xc201
    800052cc:	97aa                	add	a5,a5,a0
    800052ce:	c3c4                	sw	s1,4(a5)
}
    800052d0:	60e2                	ld	ra,24(sp)
    800052d2:	6442                	ld	s0,16(sp)
    800052d4:	64a2                	ld	s1,8(sp)
    800052d6:	6105                	addi	sp,sp,32
    800052d8:	8082                	ret

00000000800052da <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800052da:	1141                	addi	sp,sp,-16
    800052dc:	e406                	sd	ra,8(sp)
    800052de:	e022                	sd	s0,0(sp)
    800052e0:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800052e2:	479d                	li	a5,7
    800052e4:	06a7c863          	blt	a5,a0,80005354 <free_desc+0x7a>
    panic("free_desc 1");
  if(disk.free[i])
    800052e8:	00016717          	auipc	a4,0x16
    800052ec:	d1870713          	addi	a4,a4,-744 # 8001b000 <disk>
    800052f0:	972a                	add	a4,a4,a0
    800052f2:	6789                	lui	a5,0x2
    800052f4:	97ba                	add	a5,a5,a4
    800052f6:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    800052fa:	e7ad                	bnez	a5,80005364 <free_desc+0x8a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800052fc:	00451793          	slli	a5,a0,0x4
    80005300:	00018717          	auipc	a4,0x18
    80005304:	d0070713          	addi	a4,a4,-768 # 8001d000 <disk+0x2000>
    80005308:	6314                	ld	a3,0(a4)
    8000530a:	96be                	add	a3,a3,a5
    8000530c:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    80005310:	6314                	ld	a3,0(a4)
    80005312:	96be                	add	a3,a3,a5
    80005314:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005318:	6314                	ld	a3,0(a4)
    8000531a:	96be                	add	a3,a3,a5
    8000531c:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    80005320:	6318                	ld	a4,0(a4)
    80005322:	97ba                	add	a5,a5,a4
    80005324:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005328:	00016717          	auipc	a4,0x16
    8000532c:	cd870713          	addi	a4,a4,-808 # 8001b000 <disk>
    80005330:	972a                	add	a4,a4,a0
    80005332:	6789                	lui	a5,0x2
    80005334:	97ba                	add	a5,a5,a4
    80005336:	4705                	li	a4,1
    80005338:	00e78c23          	sb	a4,24(a5) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    8000533c:	00018517          	auipc	a0,0x18
    80005340:	cdc50513          	addi	a0,a0,-804 # 8001d018 <disk+0x2018>
    80005344:	ffffc097          	auipc	ra,0xffffc
    80005348:	3dc080e7          	jalr	988(ra) # 80001720 <wakeup>
}
    8000534c:	60a2                	ld	ra,8(sp)
    8000534e:	6402                	ld	s0,0(sp)
    80005350:	0141                	addi	sp,sp,16
    80005352:	8082                	ret
    panic("free_desc 1");
    80005354:	00003517          	auipc	a0,0x3
    80005358:	35450513          	addi	a0,a0,852 # 800086a8 <etext+0x6a8>
    8000535c:	00001097          	auipc	ra,0x1
    80005360:	a10080e7          	jalr	-1520(ra) # 80005d6c <panic>
    panic("free_desc 2");
    80005364:	00003517          	auipc	a0,0x3
    80005368:	35450513          	addi	a0,a0,852 # 800086b8 <etext+0x6b8>
    8000536c:	00001097          	auipc	ra,0x1
    80005370:	a00080e7          	jalr	-1536(ra) # 80005d6c <panic>

0000000080005374 <virtio_disk_init>:
{
    80005374:	1141                	addi	sp,sp,-16
    80005376:	e406                	sd	ra,8(sp)
    80005378:	e022                	sd	s0,0(sp)
    8000537a:	0800                	addi	s0,sp,16
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000537c:	00003597          	auipc	a1,0x3
    80005380:	34c58593          	addi	a1,a1,844 # 800086c8 <etext+0x6c8>
    80005384:	00018517          	auipc	a0,0x18
    80005388:	da450513          	addi	a0,a0,-604 # 8001d128 <disk+0x2128>
    8000538c:	00001097          	auipc	ra,0x1
    80005390:	eca080e7          	jalr	-310(ra) # 80006256 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005394:	100017b7          	lui	a5,0x10001
    80005398:	4398                	lw	a4,0(a5)
    8000539a:	2701                	sext.w	a4,a4
    8000539c:	747277b7          	lui	a5,0x74727
    800053a0:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800053a4:	0ef71f63          	bne	a4,a5,800054a2 <virtio_disk_init+0x12e>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800053a8:	100017b7          	lui	a5,0x10001
    800053ac:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    800053ae:	439c                	lw	a5,0(a5)
    800053b0:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800053b2:	4705                	li	a4,1
    800053b4:	0ee79763          	bne	a5,a4,800054a2 <virtio_disk_init+0x12e>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800053b8:	100017b7          	lui	a5,0x10001
    800053bc:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    800053be:	439c                	lw	a5,0(a5)
    800053c0:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800053c2:	4709                	li	a4,2
    800053c4:	0ce79f63          	bne	a5,a4,800054a2 <virtio_disk_init+0x12e>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800053c8:	100017b7          	lui	a5,0x10001
    800053cc:	47d8                	lw	a4,12(a5)
    800053ce:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800053d0:	554d47b7          	lui	a5,0x554d4
    800053d4:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800053d8:	0cf71563          	bne	a4,a5,800054a2 <virtio_disk_init+0x12e>
  *R(VIRTIO_MMIO_STATUS) = status;
    800053dc:	100017b7          	lui	a5,0x10001
    800053e0:	4705                	li	a4,1
    800053e2:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800053e4:	470d                	li	a4,3
    800053e6:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800053e8:	10001737          	lui	a4,0x10001
    800053ec:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800053ee:	c7ffe737          	lui	a4,0xc7ffe
    800053f2:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd851f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800053f6:	8ef9                	and	a3,a3,a4
    800053f8:	10001737          	lui	a4,0x10001
    800053fc:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    800053fe:	472d                	li	a4,11
    80005400:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005402:	473d                	li	a4,15
    80005404:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80005406:	100017b7          	lui	a5,0x10001
    8000540a:	6705                	lui	a4,0x1
    8000540c:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000540e:	100017b7          	lui	a5,0x10001
    80005412:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005416:	100017b7          	lui	a5,0x10001
    8000541a:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    8000541e:	439c                	lw	a5,0(a5)
    80005420:	2781                	sext.w	a5,a5
  if(max == 0)
    80005422:	cbc1                	beqz	a5,800054b2 <virtio_disk_init+0x13e>
  if(max < NUM)
    80005424:	471d                	li	a4,7
    80005426:	08f77e63          	bgeu	a4,a5,800054c2 <virtio_disk_init+0x14e>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000542a:	100017b7          	lui	a5,0x10001
    8000542e:	4721                	li	a4,8
    80005430:	df98                	sw	a4,56(a5)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005432:	6609                	lui	a2,0x2
    80005434:	4581                	li	a1,0
    80005436:	00016517          	auipc	a0,0x16
    8000543a:	bca50513          	addi	a0,a0,-1078 # 8001b000 <disk>
    8000543e:	ffffb097          	auipc	ra,0xffffb
    80005442:	d86080e7          	jalr	-634(ra) # 800001c4 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    80005446:	00016697          	auipc	a3,0x16
    8000544a:	bba68693          	addi	a3,a3,-1094 # 8001b000 <disk>
    8000544e:	00c6d713          	srli	a4,a3,0xc
    80005452:	2701                	sext.w	a4,a4
    80005454:	100017b7          	lui	a5,0x10001
    80005458:	c3b8                	sw	a4,64(a5)
  disk.desc = (struct virtq_desc *) disk.pages;
    8000545a:	00018797          	auipc	a5,0x18
    8000545e:	ba678793          	addi	a5,a5,-1114 # 8001d000 <disk+0x2000>
    80005462:	e394                	sd	a3,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005464:	00016717          	auipc	a4,0x16
    80005468:	c1c70713          	addi	a4,a4,-996 # 8001b080 <disk+0x80>
    8000546c:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    8000546e:	00017717          	auipc	a4,0x17
    80005472:	b9270713          	addi	a4,a4,-1134 # 8001c000 <disk+0x1000>
    80005476:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    80005478:	4705                	li	a4,1
    8000547a:	00e78c23          	sb	a4,24(a5)
    8000547e:	00e78ca3          	sb	a4,25(a5)
    80005482:	00e78d23          	sb	a4,26(a5)
    80005486:	00e78da3          	sb	a4,27(a5)
    8000548a:	00e78e23          	sb	a4,28(a5)
    8000548e:	00e78ea3          	sb	a4,29(a5)
    80005492:	00e78f23          	sb	a4,30(a5)
    80005496:	00e78fa3          	sb	a4,31(a5)
}
    8000549a:	60a2                	ld	ra,8(sp)
    8000549c:	6402                	ld	s0,0(sp)
    8000549e:	0141                	addi	sp,sp,16
    800054a0:	8082                	ret
    panic("could not find virtio disk");
    800054a2:	00003517          	auipc	a0,0x3
    800054a6:	23650513          	addi	a0,a0,566 # 800086d8 <etext+0x6d8>
    800054aa:	00001097          	auipc	ra,0x1
    800054ae:	8c2080e7          	jalr	-1854(ra) # 80005d6c <panic>
    panic("virtio disk has no queue 0");
    800054b2:	00003517          	auipc	a0,0x3
    800054b6:	24650513          	addi	a0,a0,582 # 800086f8 <etext+0x6f8>
    800054ba:	00001097          	auipc	ra,0x1
    800054be:	8b2080e7          	jalr	-1870(ra) # 80005d6c <panic>
    panic("virtio disk max queue too short");
    800054c2:	00003517          	auipc	a0,0x3
    800054c6:	25650513          	addi	a0,a0,598 # 80008718 <etext+0x718>
    800054ca:	00001097          	auipc	ra,0x1
    800054ce:	8a2080e7          	jalr	-1886(ra) # 80005d6c <panic>

00000000800054d2 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800054d2:	7159                	addi	sp,sp,-112
    800054d4:	f486                	sd	ra,104(sp)
    800054d6:	f0a2                	sd	s0,96(sp)
    800054d8:	eca6                	sd	s1,88(sp)
    800054da:	e8ca                	sd	s2,80(sp)
    800054dc:	e4ce                	sd	s3,72(sp)
    800054de:	e0d2                	sd	s4,64(sp)
    800054e0:	fc56                	sd	s5,56(sp)
    800054e2:	f85a                	sd	s6,48(sp)
    800054e4:	f45e                	sd	s7,40(sp)
    800054e6:	f062                	sd	s8,32(sp)
    800054e8:	ec66                	sd	s9,24(sp)
    800054ea:	1880                	addi	s0,sp,112
    800054ec:	8a2a                	mv	s4,a0
    800054ee:	8cae                	mv	s9,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800054f0:	00c52c03          	lw	s8,12(a0)
    800054f4:	001c1c1b          	slliw	s8,s8,0x1
    800054f8:	1c02                	slli	s8,s8,0x20
    800054fa:	020c5c13          	srli	s8,s8,0x20

  acquire(&disk.vdisk_lock);
    800054fe:	00018517          	auipc	a0,0x18
    80005502:	c2a50513          	addi	a0,a0,-982 # 8001d128 <disk+0x2128>
    80005506:	00001097          	auipc	ra,0x1
    8000550a:	de0080e7          	jalr	-544(ra) # 800062e6 <acquire>
  for(int i = 0; i < 3; i++){
    8000550e:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005510:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005512:	00016b97          	auipc	s7,0x16
    80005516:	aeeb8b93          	addi	s7,s7,-1298 # 8001b000 <disk>
    8000551a:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    8000551c:	4a8d                	li	s5,3
    8000551e:	a88d                	j	80005590 <virtio_disk_rw+0xbe>
      disk.free[i] = 0;
    80005520:	00fb8733          	add	a4,s7,a5
    80005524:	975a                	add	a4,a4,s6
    80005526:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    8000552a:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    8000552c:	0207c563          	bltz	a5,80005556 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    80005530:	2905                	addiw	s2,s2,1
    80005532:	0611                	addi	a2,a2,4 # 2004 <_entry-0x7fffdffc>
    80005534:	1b590163          	beq	s2,s5,800056d6 <virtio_disk_rw+0x204>
    idx[i] = alloc_desc();
    80005538:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    8000553a:	00018717          	auipc	a4,0x18
    8000553e:	ade70713          	addi	a4,a4,-1314 # 8001d018 <disk+0x2018>
    80005542:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80005544:	00074683          	lbu	a3,0(a4)
    80005548:	fee1                	bnez	a3,80005520 <virtio_disk_rw+0x4e>
  for(int i = 0; i < NUM; i++){
    8000554a:	2785                	addiw	a5,a5,1
    8000554c:	0705                	addi	a4,a4,1
    8000554e:	fe979be3          	bne	a5,s1,80005544 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    80005552:	57fd                	li	a5,-1
    80005554:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80005556:	03205163          	blez	s2,80005578 <virtio_disk_rw+0xa6>
        free_desc(idx[j]);
    8000555a:	f9042503          	lw	a0,-112(s0)
    8000555e:	00000097          	auipc	ra,0x0
    80005562:	d7c080e7          	jalr	-644(ra) # 800052da <free_desc>
      for(int j = 0; j < i; j++)
    80005566:	4785                	li	a5,1
    80005568:	0127d863          	bge	a5,s2,80005578 <virtio_disk_rw+0xa6>
        free_desc(idx[j]);
    8000556c:	f9442503          	lw	a0,-108(s0)
    80005570:	00000097          	auipc	ra,0x0
    80005574:	d6a080e7          	jalr	-662(ra) # 800052da <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005578:	00018597          	auipc	a1,0x18
    8000557c:	bb058593          	addi	a1,a1,-1104 # 8001d128 <disk+0x2128>
    80005580:	00018517          	auipc	a0,0x18
    80005584:	a9850513          	addi	a0,a0,-1384 # 8001d018 <disk+0x2018>
    80005588:	ffffc097          	auipc	ra,0xffffc
    8000558c:	00c080e7          	jalr	12(ra) # 80001594 <sleep>
  for(int i = 0; i < 3; i++){
    80005590:	f9040613          	addi	a2,s0,-112
    80005594:	894e                	mv	s2,s3
    80005596:	b74d                	j	80005538 <virtio_disk_rw+0x66>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80005598:	00018717          	auipc	a4,0x18
    8000559c:	a6873703          	ld	a4,-1432(a4) # 8001d000 <disk+0x2000>
    800055a0:	973e                	add	a4,a4,a5
    800055a2:	00071623          	sh	zero,12(a4)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800055a6:	00016897          	auipc	a7,0x16
    800055aa:	a5a88893          	addi	a7,a7,-1446 # 8001b000 <disk>
    800055ae:	00018717          	auipc	a4,0x18
    800055b2:	a5270713          	addi	a4,a4,-1454 # 8001d000 <disk+0x2000>
    800055b6:	6314                	ld	a3,0(a4)
    800055b8:	96be                	add	a3,a3,a5
    800055ba:	00c6d583          	lhu	a1,12(a3)
    800055be:	0015e593          	ori	a1,a1,1
    800055c2:	00b69623          	sh	a1,12(a3)
  disk.desc[idx[1]].next = idx[2];
    800055c6:	f9842683          	lw	a3,-104(s0)
    800055ca:	630c                	ld	a1,0(a4)
    800055cc:	97ae                	add	a5,a5,a1
    800055ce:	00d79723          	sh	a3,14(a5)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800055d2:	20050593          	addi	a1,a0,512
    800055d6:	0592                	slli	a1,a1,0x4
    800055d8:	95c6                	add	a1,a1,a7
    800055da:	57fd                	li	a5,-1
    800055dc:	02f58823          	sb	a5,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800055e0:	00469793          	slli	a5,a3,0x4
    800055e4:	00073803          	ld	a6,0(a4)
    800055e8:	983e                	add	a6,a6,a5
    800055ea:	6689                	lui	a3,0x2
    800055ec:	03068693          	addi	a3,a3,48 # 2030 <_entry-0x7fffdfd0>
    800055f0:	96b2                	add	a3,a3,a2
    800055f2:	96c6                	add	a3,a3,a7
    800055f4:	00d83023          	sd	a3,0(a6)
  disk.desc[idx[2]].len = 1;
    800055f8:	6314                	ld	a3,0(a4)
    800055fa:	96be                	add	a3,a3,a5
    800055fc:	4605                	li	a2,1
    800055fe:	c690                	sw	a2,8(a3)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005600:	6314                	ld	a3,0(a4)
    80005602:	96be                	add	a3,a3,a5
    80005604:	4809                	li	a6,2
    80005606:	01069623          	sh	a6,12(a3)
  disk.desc[idx[2]].next = 0;
    8000560a:	6314                	ld	a3,0(a4)
    8000560c:	97b6                	add	a5,a5,a3
    8000560e:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005612:	00ca2223          	sw	a2,4(s4)
  disk.info[idx[0]].b = b;
    80005616:	0345b423          	sd	s4,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    8000561a:	6714                	ld	a3,8(a4)
    8000561c:	0026d783          	lhu	a5,2(a3)
    80005620:	8b9d                	andi	a5,a5,7
    80005622:	0786                	slli	a5,a5,0x1
    80005624:	96be                	add	a3,a3,a5
    80005626:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    8000562a:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000562e:	6718                	ld	a4,8(a4)
    80005630:	00275783          	lhu	a5,2(a4)
    80005634:	2785                	addiw	a5,a5,1
    80005636:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    8000563a:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000563e:	100017b7          	lui	a5,0x10001
    80005642:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005646:	004a2783          	lw	a5,4(s4)
    8000564a:	02c79163          	bne	a5,a2,8000566c <virtio_disk_rw+0x19a>
    sleep(b, &disk.vdisk_lock);
    8000564e:	00018917          	auipc	s2,0x18
    80005652:	ada90913          	addi	s2,s2,-1318 # 8001d128 <disk+0x2128>
  while(b->disk == 1) {
    80005656:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80005658:	85ca                	mv	a1,s2
    8000565a:	8552                	mv	a0,s4
    8000565c:	ffffc097          	auipc	ra,0xffffc
    80005660:	f38080e7          	jalr	-200(ra) # 80001594 <sleep>
  while(b->disk == 1) {
    80005664:	004a2783          	lw	a5,4(s4)
    80005668:	fe9788e3          	beq	a5,s1,80005658 <virtio_disk_rw+0x186>
  }

  disk.info[idx[0]].b = 0;
    8000566c:	f9042903          	lw	s2,-112(s0)
    80005670:	20090713          	addi	a4,s2,512
    80005674:	0712                	slli	a4,a4,0x4
    80005676:	00016797          	auipc	a5,0x16
    8000567a:	98a78793          	addi	a5,a5,-1654 # 8001b000 <disk>
    8000567e:	97ba                	add	a5,a5,a4
    80005680:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    80005684:	00018997          	auipc	s3,0x18
    80005688:	97c98993          	addi	s3,s3,-1668 # 8001d000 <disk+0x2000>
    8000568c:	00491713          	slli	a4,s2,0x4
    80005690:	0009b783          	ld	a5,0(s3)
    80005694:	97ba                	add	a5,a5,a4
    80005696:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    8000569a:	854a                	mv	a0,s2
    8000569c:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800056a0:	00000097          	auipc	ra,0x0
    800056a4:	c3a080e7          	jalr	-966(ra) # 800052da <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800056a8:	8885                	andi	s1,s1,1
    800056aa:	f0ed                	bnez	s1,8000568c <virtio_disk_rw+0x1ba>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800056ac:	00018517          	auipc	a0,0x18
    800056b0:	a7c50513          	addi	a0,a0,-1412 # 8001d128 <disk+0x2128>
    800056b4:	00001097          	auipc	ra,0x1
    800056b8:	ce6080e7          	jalr	-794(ra) # 8000639a <release>
}
    800056bc:	70a6                	ld	ra,104(sp)
    800056be:	7406                	ld	s0,96(sp)
    800056c0:	64e6                	ld	s1,88(sp)
    800056c2:	6946                	ld	s2,80(sp)
    800056c4:	69a6                	ld	s3,72(sp)
    800056c6:	6a06                	ld	s4,64(sp)
    800056c8:	7ae2                	ld	s5,56(sp)
    800056ca:	7b42                	ld	s6,48(sp)
    800056cc:	7ba2                	ld	s7,40(sp)
    800056ce:	7c02                	ld	s8,32(sp)
    800056d0:	6ce2                	ld	s9,24(sp)
    800056d2:	6165                	addi	sp,sp,112
    800056d4:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800056d6:	f9042503          	lw	a0,-112(s0)
    800056da:	00451613          	slli	a2,a0,0x4
  if(write)
    800056de:	00016597          	auipc	a1,0x16
    800056e2:	92258593          	addi	a1,a1,-1758 # 8001b000 <disk>
    800056e6:	20050793          	addi	a5,a0,512
    800056ea:	0792                	slli	a5,a5,0x4
    800056ec:	97ae                	add	a5,a5,a1
    800056ee:	01903733          	snez	a4,s9
    800056f2:	0ae7a423          	sw	a4,168(a5)
  buf0->reserved = 0;
    800056f6:	0a07a623          	sw	zero,172(a5)
  buf0->sector = sector;
    800056fa:	0b87b823          	sd	s8,176(a5)
  disk.desc[idx[0]].addr = (uint64) buf0;
    800056fe:	00018717          	auipc	a4,0x18
    80005702:	90270713          	addi	a4,a4,-1790 # 8001d000 <disk+0x2000>
    80005706:	6314                	ld	a3,0(a4)
    80005708:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000570a:	6789                	lui	a5,0x2
    8000570c:	0a878793          	addi	a5,a5,168 # 20a8 <_entry-0x7fffdf58>
    80005710:	97b2                	add	a5,a5,a2
    80005712:	97ae                	add	a5,a5,a1
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005714:	e29c                	sd	a5,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005716:	631c                	ld	a5,0(a4)
    80005718:	97b2                	add	a5,a5,a2
    8000571a:	46c1                	li	a3,16
    8000571c:	c794                	sw	a3,8(a5)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000571e:	631c                	ld	a5,0(a4)
    80005720:	97b2                	add	a5,a5,a2
    80005722:	4685                	li	a3,1
    80005724:	00d79623          	sh	a3,12(a5)
  disk.desc[idx[0]].next = idx[1];
    80005728:	f9442783          	lw	a5,-108(s0)
    8000572c:	6314                	ld	a3,0(a4)
    8000572e:	96b2                	add	a3,a3,a2
    80005730:	00f69723          	sh	a5,14(a3)
  disk.desc[idx[1]].addr = (uint64) b->data;
    80005734:	0792                	slli	a5,a5,0x4
    80005736:	6314                	ld	a3,0(a4)
    80005738:	96be                	add	a3,a3,a5
    8000573a:	058a0593          	addi	a1,s4,88
    8000573e:	e28c                	sd	a1,0(a3)
  disk.desc[idx[1]].len = BSIZE;
    80005740:	6318                	ld	a4,0(a4)
    80005742:	973e                	add	a4,a4,a5
    80005744:	40000693          	li	a3,1024
    80005748:	c714                	sw	a3,8(a4)
  if(write)
    8000574a:	e40c97e3          	bnez	s9,80005598 <virtio_disk_rw+0xc6>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000574e:	00018717          	auipc	a4,0x18
    80005752:	8b273703          	ld	a4,-1870(a4) # 8001d000 <disk+0x2000>
    80005756:	973e                	add	a4,a4,a5
    80005758:	4689                	li	a3,2
    8000575a:	00d71623          	sh	a3,12(a4)
    8000575e:	b5a1                	j	800055a6 <virtio_disk_rw+0xd4>

0000000080005760 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005760:	1101                	addi	sp,sp,-32
    80005762:	ec06                	sd	ra,24(sp)
    80005764:	e822                	sd	s0,16(sp)
    80005766:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005768:	00018517          	auipc	a0,0x18
    8000576c:	9c050513          	addi	a0,a0,-1600 # 8001d128 <disk+0x2128>
    80005770:	00001097          	auipc	ra,0x1
    80005774:	b76080e7          	jalr	-1162(ra) # 800062e6 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005778:	100017b7          	lui	a5,0x10001
    8000577c:	53b8                	lw	a4,96(a5)
    8000577e:	8b0d                	andi	a4,a4,3
    80005780:	100017b7          	lui	a5,0x10001
    80005784:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    80005786:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    8000578a:	00018797          	auipc	a5,0x18
    8000578e:	87678793          	addi	a5,a5,-1930 # 8001d000 <disk+0x2000>
    80005792:	6b94                	ld	a3,16(a5)
    80005794:	0207d703          	lhu	a4,32(a5)
    80005798:	0026d783          	lhu	a5,2(a3)
    8000579c:	06f70563          	beq	a4,a5,80005806 <virtio_disk_intr+0xa6>
    800057a0:	e426                	sd	s1,8(sp)
    800057a2:	e04a                	sd	s2,0(sp)
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800057a4:	00016917          	auipc	s2,0x16
    800057a8:	85c90913          	addi	s2,s2,-1956 # 8001b000 <disk>
    800057ac:	00018497          	auipc	s1,0x18
    800057b0:	85448493          	addi	s1,s1,-1964 # 8001d000 <disk+0x2000>
    __sync_synchronize();
    800057b4:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800057b8:	6898                	ld	a4,16(s1)
    800057ba:	0204d783          	lhu	a5,32(s1)
    800057be:	8b9d                	andi	a5,a5,7
    800057c0:	078e                	slli	a5,a5,0x3
    800057c2:	97ba                	add	a5,a5,a4
    800057c4:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800057c6:	20078713          	addi	a4,a5,512
    800057ca:	0712                	slli	a4,a4,0x4
    800057cc:	974a                	add	a4,a4,s2
    800057ce:	03074703          	lbu	a4,48(a4)
    800057d2:	e731                	bnez	a4,8000581e <virtio_disk_intr+0xbe>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800057d4:	20078793          	addi	a5,a5,512
    800057d8:	0792                	slli	a5,a5,0x4
    800057da:	97ca                	add	a5,a5,s2
    800057dc:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    800057de:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800057e2:	ffffc097          	auipc	ra,0xffffc
    800057e6:	f3e080e7          	jalr	-194(ra) # 80001720 <wakeup>

    disk.used_idx += 1;
    800057ea:	0204d783          	lhu	a5,32(s1)
    800057ee:	2785                	addiw	a5,a5,1
    800057f0:	17c2                	slli	a5,a5,0x30
    800057f2:	93c1                	srli	a5,a5,0x30
    800057f4:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800057f8:	6898                	ld	a4,16(s1)
    800057fa:	00275703          	lhu	a4,2(a4)
    800057fe:	faf71be3          	bne	a4,a5,800057b4 <virtio_disk_intr+0x54>
    80005802:	64a2                	ld	s1,8(sp)
    80005804:	6902                	ld	s2,0(sp)
  }

  release(&disk.vdisk_lock);
    80005806:	00018517          	auipc	a0,0x18
    8000580a:	92250513          	addi	a0,a0,-1758 # 8001d128 <disk+0x2128>
    8000580e:	00001097          	auipc	ra,0x1
    80005812:	b8c080e7          	jalr	-1140(ra) # 8000639a <release>
}
    80005816:	60e2                	ld	ra,24(sp)
    80005818:	6442                	ld	s0,16(sp)
    8000581a:	6105                	addi	sp,sp,32
    8000581c:	8082                	ret
      panic("virtio_disk_intr status");
    8000581e:	00003517          	auipc	a0,0x3
    80005822:	f1a50513          	addi	a0,a0,-230 # 80008738 <etext+0x738>
    80005826:	00000097          	auipc	ra,0x0
    8000582a:	546080e7          	jalr	1350(ra) # 80005d6c <panic>

000000008000582e <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000582e:	1141                	addi	sp,sp,-16
    80005830:	e422                	sd	s0,8(sp)
    80005832:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005834:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005838:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    8000583c:	0037979b          	slliw	a5,a5,0x3
    80005840:	02004737          	lui	a4,0x2004
    80005844:	97ba                	add	a5,a5,a4
    80005846:	0200c737          	lui	a4,0x200c
    8000584a:	1761                	addi	a4,a4,-8 # 200bff8 <_entry-0x7dff4008>
    8000584c:	6318                	ld	a4,0(a4)
    8000584e:	000f4637          	lui	a2,0xf4
    80005852:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005856:	9732                	add	a4,a4,a2
    80005858:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    8000585a:	00259693          	slli	a3,a1,0x2
    8000585e:	96ae                	add	a3,a3,a1
    80005860:	068e                	slli	a3,a3,0x3
    80005862:	00018717          	auipc	a4,0x18
    80005866:	79e70713          	addi	a4,a4,1950 # 8001e000 <timer_scratch>
    8000586a:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    8000586c:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    8000586e:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005870:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005874:	00000797          	auipc	a5,0x0
    80005878:	99c78793          	addi	a5,a5,-1636 # 80005210 <timervec>
    8000587c:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005880:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005884:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005888:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    8000588c:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005890:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005894:	30479073          	csrw	mie,a5
}
    80005898:	6422                	ld	s0,8(sp)
    8000589a:	0141                	addi	sp,sp,16
    8000589c:	8082                	ret

000000008000589e <start>:
{
    8000589e:	1141                	addi	sp,sp,-16
    800058a0:	e406                	sd	ra,8(sp)
    800058a2:	e022                	sd	s0,0(sp)
    800058a4:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800058a6:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800058aa:	7779                	lui	a4,0xffffe
    800058ac:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd85bf>
    800058b0:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800058b2:	6705                	lui	a4,0x1
    800058b4:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800058b8:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800058ba:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800058be:	ffffb797          	auipc	a5,0xffffb
    800058c2:	aa478793          	addi	a5,a5,-1372 # 80000362 <main>
    800058c6:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800058ca:	4781                	li	a5,0
    800058cc:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800058d0:	67c1                	lui	a5,0x10
    800058d2:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    800058d4:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800058d8:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800058dc:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800058e0:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800058e4:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800058e8:	57fd                	li	a5,-1
    800058ea:	83a9                	srli	a5,a5,0xa
    800058ec:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800058f0:	47bd                	li	a5,15
    800058f2:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800058f6:	00000097          	auipc	ra,0x0
    800058fa:	f38080e7          	jalr	-200(ra) # 8000582e <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800058fe:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005902:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005904:	823e                	mv	tp,a5
  asm volatile("mret");
    80005906:	30200073          	mret
}
    8000590a:	60a2                	ld	ra,8(sp)
    8000590c:	6402                	ld	s0,0(sp)
    8000590e:	0141                	addi	sp,sp,16
    80005910:	8082                	ret

0000000080005912 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005912:	715d                	addi	sp,sp,-80
    80005914:	e486                	sd	ra,72(sp)
    80005916:	e0a2                	sd	s0,64(sp)
    80005918:	f84a                	sd	s2,48(sp)
    8000591a:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    8000591c:	04c05663          	blez	a2,80005968 <consolewrite+0x56>
    80005920:	fc26                	sd	s1,56(sp)
    80005922:	f44e                	sd	s3,40(sp)
    80005924:	f052                	sd	s4,32(sp)
    80005926:	ec56                	sd	s5,24(sp)
    80005928:	8a2a                	mv	s4,a0
    8000592a:	84ae                	mv	s1,a1
    8000592c:	89b2                	mv	s3,a2
    8000592e:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005930:	5afd                	li	s5,-1
    80005932:	4685                	li	a3,1
    80005934:	8626                	mv	a2,s1
    80005936:	85d2                	mv	a1,s4
    80005938:	fbf40513          	addi	a0,s0,-65
    8000593c:	ffffc097          	auipc	ra,0xffffc
    80005940:	052080e7          	jalr	82(ra) # 8000198e <either_copyin>
    80005944:	03550463          	beq	a0,s5,8000596c <consolewrite+0x5a>
      break;
    uartputc(c);
    80005948:	fbf44503          	lbu	a0,-65(s0)
    8000594c:	00000097          	auipc	ra,0x0
    80005950:	7de080e7          	jalr	2014(ra) # 8000612a <uartputc>
  for(i = 0; i < n; i++){
    80005954:	2905                	addiw	s2,s2,1
    80005956:	0485                	addi	s1,s1,1
    80005958:	fd299de3          	bne	s3,s2,80005932 <consolewrite+0x20>
    8000595c:	894e                	mv	s2,s3
    8000595e:	74e2                	ld	s1,56(sp)
    80005960:	79a2                	ld	s3,40(sp)
    80005962:	7a02                	ld	s4,32(sp)
    80005964:	6ae2                	ld	s5,24(sp)
    80005966:	a039                	j	80005974 <consolewrite+0x62>
    80005968:	4901                	li	s2,0
    8000596a:	a029                	j	80005974 <consolewrite+0x62>
    8000596c:	74e2                	ld	s1,56(sp)
    8000596e:	79a2                	ld	s3,40(sp)
    80005970:	7a02                	ld	s4,32(sp)
    80005972:	6ae2                	ld	s5,24(sp)
  }

  return i;
}
    80005974:	854a                	mv	a0,s2
    80005976:	60a6                	ld	ra,72(sp)
    80005978:	6406                	ld	s0,64(sp)
    8000597a:	7942                	ld	s2,48(sp)
    8000597c:	6161                	addi	sp,sp,80
    8000597e:	8082                	ret

0000000080005980 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005980:	711d                	addi	sp,sp,-96
    80005982:	ec86                	sd	ra,88(sp)
    80005984:	e8a2                	sd	s0,80(sp)
    80005986:	e4a6                	sd	s1,72(sp)
    80005988:	e0ca                	sd	s2,64(sp)
    8000598a:	fc4e                	sd	s3,56(sp)
    8000598c:	f852                	sd	s4,48(sp)
    8000598e:	f456                	sd	s5,40(sp)
    80005990:	f05a                	sd	s6,32(sp)
    80005992:	1080                	addi	s0,sp,96
    80005994:	8aaa                	mv	s5,a0
    80005996:	8a2e                	mv	s4,a1
    80005998:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    8000599a:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    8000599e:	00020517          	auipc	a0,0x20
    800059a2:	7a250513          	addi	a0,a0,1954 # 80026140 <cons>
    800059a6:	00001097          	auipc	ra,0x1
    800059aa:	940080e7          	jalr	-1728(ra) # 800062e6 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800059ae:	00020497          	auipc	s1,0x20
    800059b2:	79248493          	addi	s1,s1,1938 # 80026140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800059b6:	00021917          	auipc	s2,0x21
    800059ba:	82290913          	addi	s2,s2,-2014 # 800261d8 <cons+0x98>
  while(n > 0){
    800059be:	0d305463          	blez	s3,80005a86 <consoleread+0x106>
    while(cons.r == cons.w){
    800059c2:	0984a783          	lw	a5,152(s1)
    800059c6:	09c4a703          	lw	a4,156(s1)
    800059ca:	0af71963          	bne	a4,a5,80005a7c <consoleread+0xfc>
      if(myproc()->killed){
    800059ce:	ffffb097          	auipc	ra,0xffffb
    800059d2:	4f8080e7          	jalr	1272(ra) # 80000ec6 <myproc>
    800059d6:	551c                	lw	a5,40(a0)
    800059d8:	e7ad                	bnez	a5,80005a42 <consoleread+0xc2>
      sleep(&cons.r, &cons.lock);
    800059da:	85a6                	mv	a1,s1
    800059dc:	854a                	mv	a0,s2
    800059de:	ffffc097          	auipc	ra,0xffffc
    800059e2:	bb6080e7          	jalr	-1098(ra) # 80001594 <sleep>
    while(cons.r == cons.w){
    800059e6:	0984a783          	lw	a5,152(s1)
    800059ea:	09c4a703          	lw	a4,156(s1)
    800059ee:	fef700e3          	beq	a4,a5,800059ce <consoleread+0x4e>
    800059f2:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF];
    800059f4:	00020717          	auipc	a4,0x20
    800059f8:	74c70713          	addi	a4,a4,1868 # 80026140 <cons>
    800059fc:	0017869b          	addiw	a3,a5,1
    80005a00:	08d72c23          	sw	a3,152(a4)
    80005a04:	07f7f693          	andi	a3,a5,127
    80005a08:	9736                	add	a4,a4,a3
    80005a0a:	01874703          	lbu	a4,24(a4)
    80005a0e:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80005a12:	4691                	li	a3,4
    80005a14:	04db8a63          	beq	s7,a3,80005a68 <consoleread+0xe8>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80005a18:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005a1c:	4685                	li	a3,1
    80005a1e:	faf40613          	addi	a2,s0,-81
    80005a22:	85d2                	mv	a1,s4
    80005a24:	8556                	mv	a0,s5
    80005a26:	ffffc097          	auipc	ra,0xffffc
    80005a2a:	f12080e7          	jalr	-238(ra) # 80001938 <either_copyout>
    80005a2e:	57fd                	li	a5,-1
    80005a30:	04f50a63          	beq	a0,a5,80005a84 <consoleread+0x104>
      break;

    dst++;
    80005a34:	0a05                	addi	s4,s4,1
    --n;
    80005a36:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    80005a38:	47a9                	li	a5,10
    80005a3a:	06fb8163          	beq	s7,a5,80005a9c <consoleread+0x11c>
    80005a3e:	6be2                	ld	s7,24(sp)
    80005a40:	bfbd                	j	800059be <consoleread+0x3e>
        release(&cons.lock);
    80005a42:	00020517          	auipc	a0,0x20
    80005a46:	6fe50513          	addi	a0,a0,1790 # 80026140 <cons>
    80005a4a:	00001097          	auipc	ra,0x1
    80005a4e:	950080e7          	jalr	-1712(ra) # 8000639a <release>
        return -1;
    80005a52:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80005a54:	60e6                	ld	ra,88(sp)
    80005a56:	6446                	ld	s0,80(sp)
    80005a58:	64a6                	ld	s1,72(sp)
    80005a5a:	6906                	ld	s2,64(sp)
    80005a5c:	79e2                	ld	s3,56(sp)
    80005a5e:	7a42                	ld	s4,48(sp)
    80005a60:	7aa2                	ld	s5,40(sp)
    80005a62:	7b02                	ld	s6,32(sp)
    80005a64:	6125                	addi	sp,sp,96
    80005a66:	8082                	ret
      if(n < target){
    80005a68:	0009871b          	sext.w	a4,s3
    80005a6c:	01677a63          	bgeu	a4,s6,80005a80 <consoleread+0x100>
        cons.r--;
    80005a70:	00020717          	auipc	a4,0x20
    80005a74:	76f72423          	sw	a5,1896(a4) # 800261d8 <cons+0x98>
    80005a78:	6be2                	ld	s7,24(sp)
    80005a7a:	a031                	j	80005a86 <consoleread+0x106>
    80005a7c:	ec5e                	sd	s7,24(sp)
    80005a7e:	bf9d                	j	800059f4 <consoleread+0x74>
    80005a80:	6be2                	ld	s7,24(sp)
    80005a82:	a011                	j	80005a86 <consoleread+0x106>
    80005a84:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80005a86:	00020517          	auipc	a0,0x20
    80005a8a:	6ba50513          	addi	a0,a0,1722 # 80026140 <cons>
    80005a8e:	00001097          	auipc	ra,0x1
    80005a92:	90c080e7          	jalr	-1780(ra) # 8000639a <release>
  return target - n;
    80005a96:	413b053b          	subw	a0,s6,s3
    80005a9a:	bf6d                	j	80005a54 <consoleread+0xd4>
    80005a9c:	6be2                	ld	s7,24(sp)
    80005a9e:	b7e5                	j	80005a86 <consoleread+0x106>

0000000080005aa0 <consputc>:
{
    80005aa0:	1141                	addi	sp,sp,-16
    80005aa2:	e406                	sd	ra,8(sp)
    80005aa4:	e022                	sd	s0,0(sp)
    80005aa6:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005aa8:	10000793          	li	a5,256
    80005aac:	00f50a63          	beq	a0,a5,80005ac0 <consputc+0x20>
    uartputc_sync(c);
    80005ab0:	00000097          	auipc	ra,0x0
    80005ab4:	59c080e7          	jalr	1436(ra) # 8000604c <uartputc_sync>
}
    80005ab8:	60a2                	ld	ra,8(sp)
    80005aba:	6402                	ld	s0,0(sp)
    80005abc:	0141                	addi	sp,sp,16
    80005abe:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005ac0:	4521                	li	a0,8
    80005ac2:	00000097          	auipc	ra,0x0
    80005ac6:	58a080e7          	jalr	1418(ra) # 8000604c <uartputc_sync>
    80005aca:	02000513          	li	a0,32
    80005ace:	00000097          	auipc	ra,0x0
    80005ad2:	57e080e7          	jalr	1406(ra) # 8000604c <uartputc_sync>
    80005ad6:	4521                	li	a0,8
    80005ad8:	00000097          	auipc	ra,0x0
    80005adc:	574080e7          	jalr	1396(ra) # 8000604c <uartputc_sync>
    80005ae0:	bfe1                	j	80005ab8 <consputc+0x18>

0000000080005ae2 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005ae2:	1101                	addi	sp,sp,-32
    80005ae4:	ec06                	sd	ra,24(sp)
    80005ae6:	e822                	sd	s0,16(sp)
    80005ae8:	e426                	sd	s1,8(sp)
    80005aea:	1000                	addi	s0,sp,32
    80005aec:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005aee:	00020517          	auipc	a0,0x20
    80005af2:	65250513          	addi	a0,a0,1618 # 80026140 <cons>
    80005af6:	00000097          	auipc	ra,0x0
    80005afa:	7f0080e7          	jalr	2032(ra) # 800062e6 <acquire>

  switch(c){
    80005afe:	47d5                	li	a5,21
    80005b00:	0af48563          	beq	s1,a5,80005baa <consoleintr+0xc8>
    80005b04:	0297c963          	blt	a5,s1,80005b36 <consoleintr+0x54>
    80005b08:	47a1                	li	a5,8
    80005b0a:	0ef48c63          	beq	s1,a5,80005c02 <consoleintr+0x120>
    80005b0e:	47c1                	li	a5,16
    80005b10:	10f49f63          	bne	s1,a5,80005c2e <consoleintr+0x14c>
  case C('P'):  // Print process list.
    procdump();
    80005b14:	ffffc097          	auipc	ra,0xffffc
    80005b18:	ed0080e7          	jalr	-304(ra) # 800019e4 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005b1c:	00020517          	auipc	a0,0x20
    80005b20:	62450513          	addi	a0,a0,1572 # 80026140 <cons>
    80005b24:	00001097          	auipc	ra,0x1
    80005b28:	876080e7          	jalr	-1930(ra) # 8000639a <release>
}
    80005b2c:	60e2                	ld	ra,24(sp)
    80005b2e:	6442                	ld	s0,16(sp)
    80005b30:	64a2                	ld	s1,8(sp)
    80005b32:	6105                	addi	sp,sp,32
    80005b34:	8082                	ret
  switch(c){
    80005b36:	07f00793          	li	a5,127
    80005b3a:	0cf48463          	beq	s1,a5,80005c02 <consoleintr+0x120>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005b3e:	00020717          	auipc	a4,0x20
    80005b42:	60270713          	addi	a4,a4,1538 # 80026140 <cons>
    80005b46:	0a072783          	lw	a5,160(a4)
    80005b4a:	09872703          	lw	a4,152(a4)
    80005b4e:	9f99                	subw	a5,a5,a4
    80005b50:	07f00713          	li	a4,127
    80005b54:	fcf764e3          	bltu	a4,a5,80005b1c <consoleintr+0x3a>
      c = (c == '\r') ? '\n' : c;
    80005b58:	47b5                	li	a5,13
    80005b5a:	0cf48d63          	beq	s1,a5,80005c34 <consoleintr+0x152>
      consputc(c);
    80005b5e:	8526                	mv	a0,s1
    80005b60:	00000097          	auipc	ra,0x0
    80005b64:	f40080e7          	jalr	-192(ra) # 80005aa0 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005b68:	00020797          	auipc	a5,0x20
    80005b6c:	5d878793          	addi	a5,a5,1496 # 80026140 <cons>
    80005b70:	0a07a703          	lw	a4,160(a5)
    80005b74:	0017069b          	addiw	a3,a4,1
    80005b78:	0006861b          	sext.w	a2,a3
    80005b7c:	0ad7a023          	sw	a3,160(a5)
    80005b80:	07f77713          	andi	a4,a4,127
    80005b84:	97ba                	add	a5,a5,a4
    80005b86:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005b8a:	47a9                	li	a5,10
    80005b8c:	0cf48b63          	beq	s1,a5,80005c62 <consoleintr+0x180>
    80005b90:	4791                	li	a5,4
    80005b92:	0cf48863          	beq	s1,a5,80005c62 <consoleintr+0x180>
    80005b96:	00020797          	auipc	a5,0x20
    80005b9a:	6427a783          	lw	a5,1602(a5) # 800261d8 <cons+0x98>
    80005b9e:	0807879b          	addiw	a5,a5,128
    80005ba2:	f6f61de3          	bne	a2,a5,80005b1c <consoleintr+0x3a>
    80005ba6:	863e                	mv	a2,a5
    80005ba8:	a86d                	j	80005c62 <consoleintr+0x180>
    80005baa:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    80005bac:	00020717          	auipc	a4,0x20
    80005bb0:	59470713          	addi	a4,a4,1428 # 80026140 <cons>
    80005bb4:	0a072783          	lw	a5,160(a4)
    80005bb8:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005bbc:	00020497          	auipc	s1,0x20
    80005bc0:	58448493          	addi	s1,s1,1412 # 80026140 <cons>
    while(cons.e != cons.w &&
    80005bc4:	4929                	li	s2,10
    80005bc6:	02f70a63          	beq	a4,a5,80005bfa <consoleintr+0x118>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005bca:	37fd                	addiw	a5,a5,-1
    80005bcc:	07f7f713          	andi	a4,a5,127
    80005bd0:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005bd2:	01874703          	lbu	a4,24(a4)
    80005bd6:	03270463          	beq	a4,s2,80005bfe <consoleintr+0x11c>
      cons.e--;
    80005bda:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005bde:	10000513          	li	a0,256
    80005be2:	00000097          	auipc	ra,0x0
    80005be6:	ebe080e7          	jalr	-322(ra) # 80005aa0 <consputc>
    while(cons.e != cons.w &&
    80005bea:	0a04a783          	lw	a5,160(s1)
    80005bee:	09c4a703          	lw	a4,156(s1)
    80005bf2:	fcf71ce3          	bne	a4,a5,80005bca <consoleintr+0xe8>
    80005bf6:	6902                	ld	s2,0(sp)
    80005bf8:	b715                	j	80005b1c <consoleintr+0x3a>
    80005bfa:	6902                	ld	s2,0(sp)
    80005bfc:	b705                	j	80005b1c <consoleintr+0x3a>
    80005bfe:	6902                	ld	s2,0(sp)
    80005c00:	bf31                	j	80005b1c <consoleintr+0x3a>
    if(cons.e != cons.w){
    80005c02:	00020717          	auipc	a4,0x20
    80005c06:	53e70713          	addi	a4,a4,1342 # 80026140 <cons>
    80005c0a:	0a072783          	lw	a5,160(a4)
    80005c0e:	09c72703          	lw	a4,156(a4)
    80005c12:	f0f705e3          	beq	a4,a5,80005b1c <consoleintr+0x3a>
      cons.e--;
    80005c16:	37fd                	addiw	a5,a5,-1
    80005c18:	00020717          	auipc	a4,0x20
    80005c1c:	5cf72423          	sw	a5,1480(a4) # 800261e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005c20:	10000513          	li	a0,256
    80005c24:	00000097          	auipc	ra,0x0
    80005c28:	e7c080e7          	jalr	-388(ra) # 80005aa0 <consputc>
    80005c2c:	bdc5                	j	80005b1c <consoleintr+0x3a>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005c2e:	ee0487e3          	beqz	s1,80005b1c <consoleintr+0x3a>
    80005c32:	b731                	j	80005b3e <consoleintr+0x5c>
      consputc(c);
    80005c34:	4529                	li	a0,10
    80005c36:	00000097          	auipc	ra,0x0
    80005c3a:	e6a080e7          	jalr	-406(ra) # 80005aa0 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005c3e:	00020797          	auipc	a5,0x20
    80005c42:	50278793          	addi	a5,a5,1282 # 80026140 <cons>
    80005c46:	0a07a703          	lw	a4,160(a5)
    80005c4a:	0017069b          	addiw	a3,a4,1
    80005c4e:	0006861b          	sext.w	a2,a3
    80005c52:	0ad7a023          	sw	a3,160(a5)
    80005c56:	07f77713          	andi	a4,a4,127
    80005c5a:	97ba                	add	a5,a5,a4
    80005c5c:	4729                	li	a4,10
    80005c5e:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005c62:	00020797          	auipc	a5,0x20
    80005c66:	56c7ad23          	sw	a2,1402(a5) # 800261dc <cons+0x9c>
        wakeup(&cons.r);
    80005c6a:	00020517          	auipc	a0,0x20
    80005c6e:	56e50513          	addi	a0,a0,1390 # 800261d8 <cons+0x98>
    80005c72:	ffffc097          	auipc	ra,0xffffc
    80005c76:	aae080e7          	jalr	-1362(ra) # 80001720 <wakeup>
    80005c7a:	b54d                	j	80005b1c <consoleintr+0x3a>

0000000080005c7c <consoleinit>:

void
consoleinit(void)
{
    80005c7c:	1141                	addi	sp,sp,-16
    80005c7e:	e406                	sd	ra,8(sp)
    80005c80:	e022                	sd	s0,0(sp)
    80005c82:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005c84:	00003597          	auipc	a1,0x3
    80005c88:	acc58593          	addi	a1,a1,-1332 # 80008750 <etext+0x750>
    80005c8c:	00020517          	auipc	a0,0x20
    80005c90:	4b450513          	addi	a0,a0,1204 # 80026140 <cons>
    80005c94:	00000097          	auipc	ra,0x0
    80005c98:	5c2080e7          	jalr	1474(ra) # 80006256 <initlock>

  uartinit();
    80005c9c:	00000097          	auipc	ra,0x0
    80005ca0:	354080e7          	jalr	852(ra) # 80005ff0 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005ca4:	00013797          	auipc	a5,0x13
    80005ca8:	42478793          	addi	a5,a5,1060 # 800190c8 <devsw>
    80005cac:	00000717          	auipc	a4,0x0
    80005cb0:	cd470713          	addi	a4,a4,-812 # 80005980 <consoleread>
    80005cb4:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005cb6:	00000717          	auipc	a4,0x0
    80005cba:	c5c70713          	addi	a4,a4,-932 # 80005912 <consolewrite>
    80005cbe:	ef98                	sd	a4,24(a5)
}
    80005cc0:	60a2                	ld	ra,8(sp)
    80005cc2:	6402                	ld	s0,0(sp)
    80005cc4:	0141                	addi	sp,sp,16
    80005cc6:	8082                	ret

0000000080005cc8 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005cc8:	7179                	addi	sp,sp,-48
    80005cca:	f406                	sd	ra,40(sp)
    80005ccc:	f022                	sd	s0,32(sp)
    80005cce:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005cd0:	c219                	beqz	a2,80005cd6 <printint+0xe>
    80005cd2:	08054963          	bltz	a0,80005d64 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005cd6:	2501                	sext.w	a0,a0
    80005cd8:	4881                	li	a7,0
    80005cda:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005cde:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005ce0:	2581                	sext.w	a1,a1
    80005ce2:	00003617          	auipc	a2,0x3
    80005ce6:	bde60613          	addi	a2,a2,-1058 # 800088c0 <digits>
    80005cea:	883a                	mv	a6,a4
    80005cec:	2705                	addiw	a4,a4,1
    80005cee:	02b577bb          	remuw	a5,a0,a1
    80005cf2:	1782                	slli	a5,a5,0x20
    80005cf4:	9381                	srli	a5,a5,0x20
    80005cf6:	97b2                	add	a5,a5,a2
    80005cf8:	0007c783          	lbu	a5,0(a5)
    80005cfc:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005d00:	0005079b          	sext.w	a5,a0
    80005d04:	02b5553b          	divuw	a0,a0,a1
    80005d08:	0685                	addi	a3,a3,1
    80005d0a:	feb7f0e3          	bgeu	a5,a1,80005cea <printint+0x22>

  if(sign)
    80005d0e:	00088c63          	beqz	a7,80005d26 <printint+0x5e>
    buf[i++] = '-';
    80005d12:	fe070793          	addi	a5,a4,-32
    80005d16:	00878733          	add	a4,a5,s0
    80005d1a:	02d00793          	li	a5,45
    80005d1e:	fef70823          	sb	a5,-16(a4)
    80005d22:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005d26:	02e05b63          	blez	a4,80005d5c <printint+0x94>
    80005d2a:	ec26                	sd	s1,24(sp)
    80005d2c:	e84a                	sd	s2,16(sp)
    80005d2e:	fd040793          	addi	a5,s0,-48
    80005d32:	00e784b3          	add	s1,a5,a4
    80005d36:	fff78913          	addi	s2,a5,-1
    80005d3a:	993a                	add	s2,s2,a4
    80005d3c:	377d                	addiw	a4,a4,-1
    80005d3e:	1702                	slli	a4,a4,0x20
    80005d40:	9301                	srli	a4,a4,0x20
    80005d42:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005d46:	fff4c503          	lbu	a0,-1(s1)
    80005d4a:	00000097          	auipc	ra,0x0
    80005d4e:	d56080e7          	jalr	-682(ra) # 80005aa0 <consputc>
  while(--i >= 0)
    80005d52:	14fd                	addi	s1,s1,-1
    80005d54:	ff2499e3          	bne	s1,s2,80005d46 <printint+0x7e>
    80005d58:	64e2                	ld	s1,24(sp)
    80005d5a:	6942                	ld	s2,16(sp)
}
    80005d5c:	70a2                	ld	ra,40(sp)
    80005d5e:	7402                	ld	s0,32(sp)
    80005d60:	6145                	addi	sp,sp,48
    80005d62:	8082                	ret
    x = -xx;
    80005d64:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005d68:	4885                	li	a7,1
    x = -xx;
    80005d6a:	bf85                	j	80005cda <printint+0x12>

0000000080005d6c <panic>:
    release(&pr.lock);
}

void
panic(char *s)
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
    80005d84:	9d850513          	addi	a0,a0,-1576 # 80008758 <etext+0x758>
    80005d88:	00000097          	auipc	ra,0x0
    80005d8c:	02e080e7          	jalr	46(ra) # 80005db6 <printf>
  printf(s);
    80005d90:	8526                	mv	a0,s1
    80005d92:	00000097          	auipc	ra,0x0
    80005d96:	024080e7          	jalr	36(ra) # 80005db6 <printf>
  printf("\n");
    80005d9a:	00002517          	auipc	a0,0x2
    80005d9e:	27e50513          	addi	a0,a0,638 # 80008018 <etext+0x18>
    80005da2:	00000097          	auipc	ra,0x0
    80005da6:	014080e7          	jalr	20(ra) # 80005db6 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005daa:	4785                	li	a5,1
    80005dac:	00003717          	auipc	a4,0x3
    80005db0:	26f72823          	sw	a5,624(a4) # 8000901c <panicked>
  for(;;)
    80005db4:	a001                	j	80005db4 <panic+0x48>

0000000080005db6 <printf>:
{
    80005db6:	7131                	addi	sp,sp,-192
    80005db8:	fc86                	sd	ra,120(sp)
    80005dba:	f8a2                	sd	s0,112(sp)
    80005dbc:	e8d2                	sd	s4,80(sp)
    80005dbe:	f06a                	sd	s10,32(sp)
    80005dc0:	0100                	addi	s0,sp,128
    80005dc2:	8a2a                	mv	s4,a0
    80005dc4:	e40c                	sd	a1,8(s0)
    80005dc6:	e810                	sd	a2,16(s0)
    80005dc8:	ec14                	sd	a3,24(s0)
    80005dca:	f018                	sd	a4,32(s0)
    80005dcc:	f41c                	sd	a5,40(s0)
    80005dce:	03043823          	sd	a6,48(s0)
    80005dd2:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005dd6:	00020d17          	auipc	s10,0x20
    80005dda:	42ad2d03          	lw	s10,1066(s10) # 80026200 <pr+0x18>
  if(locking)
    80005dde:	040d1463          	bnez	s10,80005e26 <printf+0x70>
  if (fmt == 0)
    80005de2:	040a0b63          	beqz	s4,80005e38 <printf+0x82>
  va_start(ap, fmt);
    80005de6:	00840793          	addi	a5,s0,8
    80005dea:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005dee:	000a4503          	lbu	a0,0(s4)
    80005df2:	18050b63          	beqz	a0,80005f88 <printf+0x1d2>
    80005df6:	f4a6                	sd	s1,104(sp)
    80005df8:	f0ca                	sd	s2,96(sp)
    80005dfa:	ecce                	sd	s3,88(sp)
    80005dfc:	e4d6                	sd	s5,72(sp)
    80005dfe:	e0da                	sd	s6,64(sp)
    80005e00:	fc5e                	sd	s7,56(sp)
    80005e02:	f862                	sd	s8,48(sp)
    80005e04:	f466                	sd	s9,40(sp)
    80005e06:	ec6e                	sd	s11,24(sp)
    80005e08:	4981                	li	s3,0
    if(c != '%'){
    80005e0a:	02500b13          	li	s6,37
    switch(c){
    80005e0e:	07000b93          	li	s7,112
  consputc('x');
    80005e12:	4cc1                	li	s9,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005e14:	00003a97          	auipc	s5,0x3
    80005e18:	aaca8a93          	addi	s5,s5,-1364 # 800088c0 <digits>
    switch(c){
    80005e1c:	07300c13          	li	s8,115
    80005e20:	06400d93          	li	s11,100
    80005e24:	a0b1                	j	80005e70 <printf+0xba>
    acquire(&pr.lock);
    80005e26:	00020517          	auipc	a0,0x20
    80005e2a:	3c250513          	addi	a0,a0,962 # 800261e8 <pr>
    80005e2e:	00000097          	auipc	ra,0x0
    80005e32:	4b8080e7          	jalr	1208(ra) # 800062e6 <acquire>
    80005e36:	b775                	j	80005de2 <printf+0x2c>
    80005e38:	f4a6                	sd	s1,104(sp)
    80005e3a:	f0ca                	sd	s2,96(sp)
    80005e3c:	ecce                	sd	s3,88(sp)
    80005e3e:	e4d6                	sd	s5,72(sp)
    80005e40:	e0da                	sd	s6,64(sp)
    80005e42:	fc5e                	sd	s7,56(sp)
    80005e44:	f862                	sd	s8,48(sp)
    80005e46:	f466                	sd	s9,40(sp)
    80005e48:	ec6e                	sd	s11,24(sp)
    panic("null fmt");
    80005e4a:	00003517          	auipc	a0,0x3
    80005e4e:	91e50513          	addi	a0,a0,-1762 # 80008768 <etext+0x768>
    80005e52:	00000097          	auipc	ra,0x0
    80005e56:	f1a080e7          	jalr	-230(ra) # 80005d6c <panic>
      consputc(c);
    80005e5a:	00000097          	auipc	ra,0x0
    80005e5e:	c46080e7          	jalr	-954(ra) # 80005aa0 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005e62:	2985                	addiw	s3,s3,1
    80005e64:	013a07b3          	add	a5,s4,s3
    80005e68:	0007c503          	lbu	a0,0(a5)
    80005e6c:	10050563          	beqz	a0,80005f76 <printf+0x1c0>
    if(c != '%'){
    80005e70:	ff6515e3          	bne	a0,s6,80005e5a <printf+0xa4>
    c = fmt[++i] & 0xff;
    80005e74:	2985                	addiw	s3,s3,1
    80005e76:	013a07b3          	add	a5,s4,s3
    80005e7a:	0007c783          	lbu	a5,0(a5)
    80005e7e:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005e82:	10078b63          	beqz	a5,80005f98 <printf+0x1e2>
    switch(c){
    80005e86:	05778a63          	beq	a5,s7,80005eda <printf+0x124>
    80005e8a:	02fbf663          	bgeu	s7,a5,80005eb6 <printf+0x100>
    80005e8e:	09878863          	beq	a5,s8,80005f1e <printf+0x168>
    80005e92:	07800713          	li	a4,120
    80005e96:	0ce79563          	bne	a5,a4,80005f60 <printf+0x1aa>
      printint(va_arg(ap, int), 16, 1);
    80005e9a:	f8843783          	ld	a5,-120(s0)
    80005e9e:	00878713          	addi	a4,a5,8
    80005ea2:	f8e43423          	sd	a4,-120(s0)
    80005ea6:	4605                	li	a2,1
    80005ea8:	85e6                	mv	a1,s9
    80005eaa:	4388                	lw	a0,0(a5)
    80005eac:	00000097          	auipc	ra,0x0
    80005eb0:	e1c080e7          	jalr	-484(ra) # 80005cc8 <printint>
      break;
    80005eb4:	b77d                	j	80005e62 <printf+0xac>
    switch(c){
    80005eb6:	09678f63          	beq	a5,s6,80005f54 <printf+0x19e>
    80005eba:	0bb79363          	bne	a5,s11,80005f60 <printf+0x1aa>
      printint(va_arg(ap, int), 10, 1);
    80005ebe:	f8843783          	ld	a5,-120(s0)
    80005ec2:	00878713          	addi	a4,a5,8
    80005ec6:	f8e43423          	sd	a4,-120(s0)
    80005eca:	4605                	li	a2,1
    80005ecc:	45a9                	li	a1,10
    80005ece:	4388                	lw	a0,0(a5)
    80005ed0:	00000097          	auipc	ra,0x0
    80005ed4:	df8080e7          	jalr	-520(ra) # 80005cc8 <printint>
      break;
    80005ed8:	b769                	j	80005e62 <printf+0xac>
      printptr(va_arg(ap, uint64));
    80005eda:	f8843783          	ld	a5,-120(s0)
    80005ede:	00878713          	addi	a4,a5,8
    80005ee2:	f8e43423          	sd	a4,-120(s0)
    80005ee6:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005eea:	03000513          	li	a0,48
    80005eee:	00000097          	auipc	ra,0x0
    80005ef2:	bb2080e7          	jalr	-1102(ra) # 80005aa0 <consputc>
  consputc('x');
    80005ef6:	07800513          	li	a0,120
    80005efa:	00000097          	auipc	ra,0x0
    80005efe:	ba6080e7          	jalr	-1114(ra) # 80005aa0 <consputc>
    80005f02:	84e6                	mv	s1,s9
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005f04:	03c95793          	srli	a5,s2,0x3c
    80005f08:	97d6                	add	a5,a5,s5
    80005f0a:	0007c503          	lbu	a0,0(a5)
    80005f0e:	00000097          	auipc	ra,0x0
    80005f12:	b92080e7          	jalr	-1134(ra) # 80005aa0 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005f16:	0912                	slli	s2,s2,0x4
    80005f18:	34fd                	addiw	s1,s1,-1
    80005f1a:	f4ed                	bnez	s1,80005f04 <printf+0x14e>
    80005f1c:	b799                	j	80005e62 <printf+0xac>
      if((s = va_arg(ap, char*)) == 0)
    80005f1e:	f8843783          	ld	a5,-120(s0)
    80005f22:	00878713          	addi	a4,a5,8
    80005f26:	f8e43423          	sd	a4,-120(s0)
    80005f2a:	6384                	ld	s1,0(a5)
    80005f2c:	cc89                	beqz	s1,80005f46 <printf+0x190>
      for(; *s; s++)
    80005f2e:	0004c503          	lbu	a0,0(s1)
    80005f32:	d905                	beqz	a0,80005e62 <printf+0xac>
        consputc(*s);
    80005f34:	00000097          	auipc	ra,0x0
    80005f38:	b6c080e7          	jalr	-1172(ra) # 80005aa0 <consputc>
      for(; *s; s++)
    80005f3c:	0485                	addi	s1,s1,1
    80005f3e:	0004c503          	lbu	a0,0(s1)
    80005f42:	f96d                	bnez	a0,80005f34 <printf+0x17e>
    80005f44:	bf39                	j	80005e62 <printf+0xac>
        s = "(null)";
    80005f46:	00003497          	auipc	s1,0x3
    80005f4a:	81a48493          	addi	s1,s1,-2022 # 80008760 <etext+0x760>
      for(; *s; s++)
    80005f4e:	02800513          	li	a0,40
    80005f52:	b7cd                	j	80005f34 <printf+0x17e>
      consputc('%');
    80005f54:	855a                	mv	a0,s6
    80005f56:	00000097          	auipc	ra,0x0
    80005f5a:	b4a080e7          	jalr	-1206(ra) # 80005aa0 <consputc>
      break;
    80005f5e:	b711                	j	80005e62 <printf+0xac>
      consputc('%');
    80005f60:	855a                	mv	a0,s6
    80005f62:	00000097          	auipc	ra,0x0
    80005f66:	b3e080e7          	jalr	-1218(ra) # 80005aa0 <consputc>
      consputc(c);
    80005f6a:	8526                	mv	a0,s1
    80005f6c:	00000097          	auipc	ra,0x0
    80005f70:	b34080e7          	jalr	-1228(ra) # 80005aa0 <consputc>
      break;
    80005f74:	b5fd                	j	80005e62 <printf+0xac>
    80005f76:	74a6                	ld	s1,104(sp)
    80005f78:	7906                	ld	s2,96(sp)
    80005f7a:	69e6                	ld	s3,88(sp)
    80005f7c:	6aa6                	ld	s5,72(sp)
    80005f7e:	6b06                	ld	s6,64(sp)
    80005f80:	7be2                	ld	s7,56(sp)
    80005f82:	7c42                	ld	s8,48(sp)
    80005f84:	7ca2                	ld	s9,40(sp)
    80005f86:	6de2                	ld	s11,24(sp)
  if(locking)
    80005f88:	020d1263          	bnez	s10,80005fac <printf+0x1f6>
}
    80005f8c:	70e6                	ld	ra,120(sp)
    80005f8e:	7446                	ld	s0,112(sp)
    80005f90:	6a46                	ld	s4,80(sp)
    80005f92:	7d02                	ld	s10,32(sp)
    80005f94:	6129                	addi	sp,sp,192
    80005f96:	8082                	ret
    80005f98:	74a6                	ld	s1,104(sp)
    80005f9a:	7906                	ld	s2,96(sp)
    80005f9c:	69e6                	ld	s3,88(sp)
    80005f9e:	6aa6                	ld	s5,72(sp)
    80005fa0:	6b06                	ld	s6,64(sp)
    80005fa2:	7be2                	ld	s7,56(sp)
    80005fa4:	7c42                	ld	s8,48(sp)
    80005fa6:	7ca2                	ld	s9,40(sp)
    80005fa8:	6de2                	ld	s11,24(sp)
    80005faa:	bff9                	j	80005f88 <printf+0x1d2>
    release(&pr.lock);
    80005fac:	00020517          	auipc	a0,0x20
    80005fb0:	23c50513          	addi	a0,a0,572 # 800261e8 <pr>
    80005fb4:	00000097          	auipc	ra,0x0
    80005fb8:	3e6080e7          	jalr	998(ra) # 8000639a <release>
}
    80005fbc:	bfc1                	j	80005f8c <printf+0x1d6>

0000000080005fbe <printfinit>:
    ;
}

void
printfinit(void)
{
    80005fbe:	1101                	addi	sp,sp,-32
    80005fc0:	ec06                	sd	ra,24(sp)
    80005fc2:	e822                	sd	s0,16(sp)
    80005fc4:	e426                	sd	s1,8(sp)
    80005fc6:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005fc8:	00020497          	auipc	s1,0x20
    80005fcc:	22048493          	addi	s1,s1,544 # 800261e8 <pr>
    80005fd0:	00002597          	auipc	a1,0x2
    80005fd4:	7a858593          	addi	a1,a1,1960 # 80008778 <etext+0x778>
    80005fd8:	8526                	mv	a0,s1
    80005fda:	00000097          	auipc	ra,0x0
    80005fde:	27c080e7          	jalr	636(ra) # 80006256 <initlock>
  pr.locking = 1;
    80005fe2:	4785                	li	a5,1
    80005fe4:	cc9c                	sw	a5,24(s1)
}
    80005fe6:	60e2                	ld	ra,24(sp)
    80005fe8:	6442                	ld	s0,16(sp)
    80005fea:	64a2                	ld	s1,8(sp)
    80005fec:	6105                	addi	sp,sp,32
    80005fee:	8082                	ret

0000000080005ff0 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005ff0:	1141                	addi	sp,sp,-16
    80005ff2:	e406                	sd	ra,8(sp)
    80005ff4:	e022                	sd	s0,0(sp)
    80005ff6:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005ff8:	100007b7          	lui	a5,0x10000
    80005ffc:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80006000:	10000737          	lui	a4,0x10000
    80006004:	f8000693          	li	a3,-128
    80006008:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    8000600c:	468d                	li	a3,3
    8000600e:	10000637          	lui	a2,0x10000
    80006012:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80006016:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    8000601a:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    8000601e:	10000737          	lui	a4,0x10000
    80006022:	461d                	li	a2,7
    80006024:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80006028:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    8000602c:	00002597          	auipc	a1,0x2
    80006030:	75458593          	addi	a1,a1,1876 # 80008780 <etext+0x780>
    80006034:	00020517          	auipc	a0,0x20
    80006038:	1d450513          	addi	a0,a0,468 # 80026208 <uart_tx_lock>
    8000603c:	00000097          	auipc	ra,0x0
    80006040:	21a080e7          	jalr	538(ra) # 80006256 <initlock>
}
    80006044:	60a2                	ld	ra,8(sp)
    80006046:	6402                	ld	s0,0(sp)
    80006048:	0141                	addi	sp,sp,16
    8000604a:	8082                	ret

000000008000604c <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    8000604c:	1101                	addi	sp,sp,-32
    8000604e:	ec06                	sd	ra,24(sp)
    80006050:	e822                	sd	s0,16(sp)
    80006052:	e426                	sd	s1,8(sp)
    80006054:	1000                	addi	s0,sp,32
    80006056:	84aa                	mv	s1,a0
  push_off();
    80006058:	00000097          	auipc	ra,0x0
    8000605c:	242080e7          	jalr	578(ra) # 8000629a <push_off>

  if(panicked){
    80006060:	00003797          	auipc	a5,0x3
    80006064:	fbc7a783          	lw	a5,-68(a5) # 8000901c <panicked>
    80006068:	eb85                	bnez	a5,80006098 <uartputc_sync+0x4c>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000606a:	10000737          	lui	a4,0x10000
    8000606e:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80006070:	00074783          	lbu	a5,0(a4)
    80006074:	0207f793          	andi	a5,a5,32
    80006078:	dfe5                	beqz	a5,80006070 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    8000607a:	0ff4f513          	zext.b	a0,s1
    8000607e:	100007b7          	lui	a5,0x10000
    80006082:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80006086:	00000097          	auipc	ra,0x0
    8000608a:	2b4080e7          	jalr	692(ra) # 8000633a <pop_off>
}
    8000608e:	60e2                	ld	ra,24(sp)
    80006090:	6442                	ld	s0,16(sp)
    80006092:	64a2                	ld	s1,8(sp)
    80006094:	6105                	addi	sp,sp,32
    80006096:	8082                	ret
    for(;;)
    80006098:	a001                	j	80006098 <uartputc_sync+0x4c>

000000008000609a <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    8000609a:	00003797          	auipc	a5,0x3
    8000609e:	f867b783          	ld	a5,-122(a5) # 80009020 <uart_tx_r>
    800060a2:	00003717          	auipc	a4,0x3
    800060a6:	f8673703          	ld	a4,-122(a4) # 80009028 <uart_tx_w>
    800060aa:	06f70f63          	beq	a4,a5,80006128 <uartstart+0x8e>
{
    800060ae:	7139                	addi	sp,sp,-64
    800060b0:	fc06                	sd	ra,56(sp)
    800060b2:	f822                	sd	s0,48(sp)
    800060b4:	f426                	sd	s1,40(sp)
    800060b6:	f04a                	sd	s2,32(sp)
    800060b8:	ec4e                	sd	s3,24(sp)
    800060ba:	e852                	sd	s4,16(sp)
    800060bc:	e456                	sd	s5,8(sp)
    800060be:	e05a                	sd	s6,0(sp)
    800060c0:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800060c2:	10000937          	lui	s2,0x10000
    800060c6:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800060c8:	00020a97          	auipc	s5,0x20
    800060cc:	140a8a93          	addi	s5,s5,320 # 80026208 <uart_tx_lock>
    uart_tx_r += 1;
    800060d0:	00003497          	auipc	s1,0x3
    800060d4:	f5048493          	addi	s1,s1,-176 # 80009020 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    800060d8:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    800060dc:	00003997          	auipc	s3,0x3
    800060e0:	f4c98993          	addi	s3,s3,-180 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800060e4:	00094703          	lbu	a4,0(s2)
    800060e8:	02077713          	andi	a4,a4,32
    800060ec:	c705                	beqz	a4,80006114 <uartstart+0x7a>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800060ee:	01f7f713          	andi	a4,a5,31
    800060f2:	9756                	add	a4,a4,s5
    800060f4:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    800060f8:	0785                	addi	a5,a5,1
    800060fa:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    800060fc:	8526                	mv	a0,s1
    800060fe:	ffffb097          	auipc	ra,0xffffb
    80006102:	622080e7          	jalr	1570(ra) # 80001720 <wakeup>
    WriteReg(THR, c);
    80006106:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    8000610a:	609c                	ld	a5,0(s1)
    8000610c:	0009b703          	ld	a4,0(s3)
    80006110:	fcf71ae3          	bne	a4,a5,800060e4 <uartstart+0x4a>
  }
}
    80006114:	70e2                	ld	ra,56(sp)
    80006116:	7442                	ld	s0,48(sp)
    80006118:	74a2                	ld	s1,40(sp)
    8000611a:	7902                	ld	s2,32(sp)
    8000611c:	69e2                	ld	s3,24(sp)
    8000611e:	6a42                	ld	s4,16(sp)
    80006120:	6aa2                	ld	s5,8(sp)
    80006122:	6b02                	ld	s6,0(sp)
    80006124:	6121                	addi	sp,sp,64
    80006126:	8082                	ret
    80006128:	8082                	ret

000000008000612a <uartputc>:
{
    8000612a:	7179                	addi	sp,sp,-48
    8000612c:	f406                	sd	ra,40(sp)
    8000612e:	f022                	sd	s0,32(sp)
    80006130:	e052                	sd	s4,0(sp)
    80006132:	1800                	addi	s0,sp,48
    80006134:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80006136:	00020517          	auipc	a0,0x20
    8000613a:	0d250513          	addi	a0,a0,210 # 80026208 <uart_tx_lock>
    8000613e:	00000097          	auipc	ra,0x0
    80006142:	1a8080e7          	jalr	424(ra) # 800062e6 <acquire>
  if(panicked){
    80006146:	00003797          	auipc	a5,0x3
    8000614a:	ed67a783          	lw	a5,-298(a5) # 8000901c <panicked>
    8000614e:	c391                	beqz	a5,80006152 <uartputc+0x28>
    for(;;)
    80006150:	a001                	j	80006150 <uartputc+0x26>
    80006152:	ec26                	sd	s1,24(sp)
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006154:	00003717          	auipc	a4,0x3
    80006158:	ed473703          	ld	a4,-300(a4) # 80009028 <uart_tx_w>
    8000615c:	00003797          	auipc	a5,0x3
    80006160:	ec47b783          	ld	a5,-316(a5) # 80009020 <uart_tx_r>
    80006164:	02078793          	addi	a5,a5,32
    80006168:	02e79f63          	bne	a5,a4,800061a6 <uartputc+0x7c>
    8000616c:	e84a                	sd	s2,16(sp)
    8000616e:	e44e                	sd	s3,8(sp)
      sleep(&uart_tx_r, &uart_tx_lock);
    80006170:	00020997          	auipc	s3,0x20
    80006174:	09898993          	addi	s3,s3,152 # 80026208 <uart_tx_lock>
    80006178:	00003497          	auipc	s1,0x3
    8000617c:	ea848493          	addi	s1,s1,-344 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006180:	00003917          	auipc	s2,0x3
    80006184:	ea890913          	addi	s2,s2,-344 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006188:	85ce                	mv	a1,s3
    8000618a:	8526                	mv	a0,s1
    8000618c:	ffffb097          	auipc	ra,0xffffb
    80006190:	408080e7          	jalr	1032(ra) # 80001594 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006194:	00093703          	ld	a4,0(s2)
    80006198:	609c                	ld	a5,0(s1)
    8000619a:	02078793          	addi	a5,a5,32
    8000619e:	fee785e3          	beq	a5,a4,80006188 <uartputc+0x5e>
    800061a2:	6942                	ld	s2,16(sp)
    800061a4:	69a2                	ld	s3,8(sp)
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800061a6:	00020497          	auipc	s1,0x20
    800061aa:	06248493          	addi	s1,s1,98 # 80026208 <uart_tx_lock>
    800061ae:	01f77793          	andi	a5,a4,31
    800061b2:	97a6                	add	a5,a5,s1
    800061b4:	01478c23          	sb	s4,24(a5)
      uart_tx_w += 1;
    800061b8:	0705                	addi	a4,a4,1
    800061ba:	00003797          	auipc	a5,0x3
    800061be:	e6e7b723          	sd	a4,-402(a5) # 80009028 <uart_tx_w>
      uartstart();
    800061c2:	00000097          	auipc	ra,0x0
    800061c6:	ed8080e7          	jalr	-296(ra) # 8000609a <uartstart>
      release(&uart_tx_lock);
    800061ca:	8526                	mv	a0,s1
    800061cc:	00000097          	auipc	ra,0x0
    800061d0:	1ce080e7          	jalr	462(ra) # 8000639a <release>
    800061d4:	64e2                	ld	s1,24(sp)
}
    800061d6:	70a2                	ld	ra,40(sp)
    800061d8:	7402                	ld	s0,32(sp)
    800061da:	6a02                	ld	s4,0(sp)
    800061dc:	6145                	addi	sp,sp,48
    800061de:	8082                	ret

00000000800061e0 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800061e0:	1141                	addi	sp,sp,-16
    800061e2:	e422                	sd	s0,8(sp)
    800061e4:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800061e6:	100007b7          	lui	a5,0x10000
    800061ea:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    800061ec:	0007c783          	lbu	a5,0(a5)
    800061f0:	8b85                	andi	a5,a5,1
    800061f2:	cb81                	beqz	a5,80006202 <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    800061f4:	100007b7          	lui	a5,0x10000
    800061f8:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800061fc:	6422                	ld	s0,8(sp)
    800061fe:	0141                	addi	sp,sp,16
    80006200:	8082                	ret
    return -1;
    80006202:	557d                	li	a0,-1
    80006204:	bfe5                	j	800061fc <uartgetc+0x1c>

0000000080006206 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80006206:	1101                	addi	sp,sp,-32
    80006208:	ec06                	sd	ra,24(sp)
    8000620a:	e822                	sd	s0,16(sp)
    8000620c:	e426                	sd	s1,8(sp)
    8000620e:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80006210:	54fd                	li	s1,-1
    80006212:	a029                	j	8000621c <uartintr+0x16>
      break;
    consoleintr(c);
    80006214:	00000097          	auipc	ra,0x0
    80006218:	8ce080e7          	jalr	-1842(ra) # 80005ae2 <consoleintr>
    int c = uartgetc();
    8000621c:	00000097          	auipc	ra,0x0
    80006220:	fc4080e7          	jalr	-60(ra) # 800061e0 <uartgetc>
    if(c == -1)
    80006224:	fe9518e3          	bne	a0,s1,80006214 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006228:	00020497          	auipc	s1,0x20
    8000622c:	fe048493          	addi	s1,s1,-32 # 80026208 <uart_tx_lock>
    80006230:	8526                	mv	a0,s1
    80006232:	00000097          	auipc	ra,0x0
    80006236:	0b4080e7          	jalr	180(ra) # 800062e6 <acquire>
  uartstart();
    8000623a:	00000097          	auipc	ra,0x0
    8000623e:	e60080e7          	jalr	-416(ra) # 8000609a <uartstart>
  release(&uart_tx_lock);
    80006242:	8526                	mv	a0,s1
    80006244:	00000097          	auipc	ra,0x0
    80006248:	156080e7          	jalr	342(ra) # 8000639a <release>
}
    8000624c:	60e2                	ld	ra,24(sp)
    8000624e:	6442                	ld	s0,16(sp)
    80006250:	64a2                	ld	s1,8(sp)
    80006252:	6105                	addi	sp,sp,32
    80006254:	8082                	ret

0000000080006256 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80006256:	1141                	addi	sp,sp,-16
    80006258:	e422                	sd	s0,8(sp)
    8000625a:	0800                	addi	s0,sp,16
  lk->name = name;
    8000625c:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    8000625e:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006262:	00053823          	sd	zero,16(a0)
}
    80006266:	6422                	ld	s0,8(sp)
    80006268:	0141                	addi	sp,sp,16
    8000626a:	8082                	ret

000000008000626c <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    8000626c:	411c                	lw	a5,0(a0)
    8000626e:	e399                	bnez	a5,80006274 <holding+0x8>
    80006270:	4501                	li	a0,0
  return r;
}
    80006272:	8082                	ret
{
    80006274:	1101                	addi	sp,sp,-32
    80006276:	ec06                	sd	ra,24(sp)
    80006278:	e822                	sd	s0,16(sp)
    8000627a:	e426                	sd	s1,8(sp)
    8000627c:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    8000627e:	6904                	ld	s1,16(a0)
    80006280:	ffffb097          	auipc	ra,0xffffb
    80006284:	c2a080e7          	jalr	-982(ra) # 80000eaa <mycpu>
    80006288:	40a48533          	sub	a0,s1,a0
    8000628c:	00153513          	seqz	a0,a0
}
    80006290:	60e2                	ld	ra,24(sp)
    80006292:	6442                	ld	s0,16(sp)
    80006294:	64a2                	ld	s1,8(sp)
    80006296:	6105                	addi	sp,sp,32
    80006298:	8082                	ret

000000008000629a <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    8000629a:	1101                	addi	sp,sp,-32
    8000629c:	ec06                	sd	ra,24(sp)
    8000629e:	e822                	sd	s0,16(sp)
    800062a0:	e426                	sd	s1,8(sp)
    800062a2:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800062a4:	100024f3          	csrr	s1,sstatus
    800062a8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800062ac:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800062ae:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800062b2:	ffffb097          	auipc	ra,0xffffb
    800062b6:	bf8080e7          	jalr	-1032(ra) # 80000eaa <mycpu>
    800062ba:	5d3c                	lw	a5,120(a0)
    800062bc:	cf89                	beqz	a5,800062d6 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800062be:	ffffb097          	auipc	ra,0xffffb
    800062c2:	bec080e7          	jalr	-1044(ra) # 80000eaa <mycpu>
    800062c6:	5d3c                	lw	a5,120(a0)
    800062c8:	2785                	addiw	a5,a5,1
    800062ca:	dd3c                	sw	a5,120(a0)
}
    800062cc:	60e2                	ld	ra,24(sp)
    800062ce:	6442                	ld	s0,16(sp)
    800062d0:	64a2                	ld	s1,8(sp)
    800062d2:	6105                	addi	sp,sp,32
    800062d4:	8082                	ret
    mycpu()->intena = old;
    800062d6:	ffffb097          	auipc	ra,0xffffb
    800062da:	bd4080e7          	jalr	-1068(ra) # 80000eaa <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800062de:	8085                	srli	s1,s1,0x1
    800062e0:	8885                	andi	s1,s1,1
    800062e2:	dd64                	sw	s1,124(a0)
    800062e4:	bfe9                	j	800062be <push_off+0x24>

00000000800062e6 <acquire>:
{
    800062e6:	1101                	addi	sp,sp,-32
    800062e8:	ec06                	sd	ra,24(sp)
    800062ea:	e822                	sd	s0,16(sp)
    800062ec:	e426                	sd	s1,8(sp)
    800062ee:	1000                	addi	s0,sp,32
    800062f0:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800062f2:	00000097          	auipc	ra,0x0
    800062f6:	fa8080e7          	jalr	-88(ra) # 8000629a <push_off>
  if(holding(lk))
    800062fa:	8526                	mv	a0,s1
    800062fc:	00000097          	auipc	ra,0x0
    80006300:	f70080e7          	jalr	-144(ra) # 8000626c <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006304:	4705                	li	a4,1
  if(holding(lk))
    80006306:	e115                	bnez	a0,8000632a <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006308:	87ba                	mv	a5,a4
    8000630a:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    8000630e:	2781                	sext.w	a5,a5
    80006310:	ffe5                	bnez	a5,80006308 <acquire+0x22>
  __sync_synchronize();
    80006312:	0ff0000f          	fence
  lk->cpu = mycpu();
    80006316:	ffffb097          	auipc	ra,0xffffb
    8000631a:	b94080e7          	jalr	-1132(ra) # 80000eaa <mycpu>
    8000631e:	e888                	sd	a0,16(s1)
}
    80006320:	60e2                	ld	ra,24(sp)
    80006322:	6442                	ld	s0,16(sp)
    80006324:	64a2                	ld	s1,8(sp)
    80006326:	6105                	addi	sp,sp,32
    80006328:	8082                	ret
    panic("acquire");
    8000632a:	00002517          	auipc	a0,0x2
    8000632e:	45e50513          	addi	a0,a0,1118 # 80008788 <etext+0x788>
    80006332:	00000097          	auipc	ra,0x0
    80006336:	a3a080e7          	jalr	-1478(ra) # 80005d6c <panic>

000000008000633a <pop_off>:

void
pop_off(void)
{
    8000633a:	1141                	addi	sp,sp,-16
    8000633c:	e406                	sd	ra,8(sp)
    8000633e:	e022                	sd	s0,0(sp)
    80006340:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006342:	ffffb097          	auipc	ra,0xffffb
    80006346:	b68080e7          	jalr	-1176(ra) # 80000eaa <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000634a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000634e:	8b89                	andi	a5,a5,2
  if(intr_get())
    80006350:	e78d                	bnez	a5,8000637a <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006352:	5d3c                	lw	a5,120(a0)
    80006354:	02f05b63          	blez	a5,8000638a <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006358:	37fd                	addiw	a5,a5,-1
    8000635a:	0007871b          	sext.w	a4,a5
    8000635e:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006360:	eb09                	bnez	a4,80006372 <pop_off+0x38>
    80006362:	5d7c                	lw	a5,124(a0)
    80006364:	c799                	beqz	a5,80006372 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006366:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000636a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000636e:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006372:	60a2                	ld	ra,8(sp)
    80006374:	6402                	ld	s0,0(sp)
    80006376:	0141                	addi	sp,sp,16
    80006378:	8082                	ret
    panic("pop_off - interruptible");
    8000637a:	00002517          	auipc	a0,0x2
    8000637e:	41650513          	addi	a0,a0,1046 # 80008790 <etext+0x790>
    80006382:	00000097          	auipc	ra,0x0
    80006386:	9ea080e7          	jalr	-1558(ra) # 80005d6c <panic>
    panic("pop_off");
    8000638a:	00002517          	auipc	a0,0x2
    8000638e:	41e50513          	addi	a0,a0,1054 # 800087a8 <etext+0x7a8>
    80006392:	00000097          	auipc	ra,0x0
    80006396:	9da080e7          	jalr	-1574(ra) # 80005d6c <panic>

000000008000639a <release>:
{
    8000639a:	1101                	addi	sp,sp,-32
    8000639c:	ec06                	sd	ra,24(sp)
    8000639e:	e822                	sd	s0,16(sp)
    800063a0:	e426                	sd	s1,8(sp)
    800063a2:	1000                	addi	s0,sp,32
    800063a4:	84aa                	mv	s1,a0
  if(!holding(lk))
    800063a6:	00000097          	auipc	ra,0x0
    800063aa:	ec6080e7          	jalr	-314(ra) # 8000626c <holding>
    800063ae:	c115                	beqz	a0,800063d2 <release+0x38>
  lk->cpu = 0;
    800063b0:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800063b4:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800063b8:	0f50000f          	fence	iorw,ow
    800063bc:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800063c0:	00000097          	auipc	ra,0x0
    800063c4:	f7a080e7          	jalr	-134(ra) # 8000633a <pop_off>
}
    800063c8:	60e2                	ld	ra,24(sp)
    800063ca:	6442                	ld	s0,16(sp)
    800063cc:	64a2                	ld	s1,8(sp)
    800063ce:	6105                	addi	sp,sp,32
    800063d0:	8082                	ret
    panic("release");
    800063d2:	00002517          	auipc	a0,0x2
    800063d6:	3de50513          	addi	a0,a0,990 # 800087b0 <etext+0x7b0>
    800063da:	00000097          	auipc	ra,0x0
    800063de:	992080e7          	jalr	-1646(ra) # 80005d6c <panic>
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
