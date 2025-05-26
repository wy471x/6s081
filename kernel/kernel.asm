
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
    80000016:	760050ef          	jal	80005776 <start>

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
    8000005e:	168080e7          	jalr	360(ra) # 800061c2 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	204080e7          	jalr	516(ra) # 80006272 <release>
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
    8000008e:	bb8080e7          	jalr	-1096(ra) # 80005c42 <panic>

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
    800000fa:	038080e7          	jalr	56(ra) # 8000612e <initlock>
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
    80000132:	094080e7          	jalr	148(ra) # 800061c2 <acquire>
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
    8000014a:	12c080e7          	jalr	300(ra) # 80006272 <release>

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
    80000174:	102080e7          	jalr	258(ra) # 80006272 <release>
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
    8000036e:	922080e7          	jalr	-1758(ra) # 80005c8c <printf>
    kvminithart();    // turn on paging
    80000372:	00000097          	auipc	ra,0x0
    80000376:	0d8080e7          	jalr	216(ra) # 8000044a <kvminithart>
    trapinithart();   // install kernel trap vector
    8000037a:	00001097          	auipc	ra,0x1
    8000037e:	74c080e7          	jalr	1868(ra) # 80001ac6 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000382:	00005097          	auipc	ra,0x5
    80000386:	dc2080e7          	jalr	-574(ra) # 80005144 <plicinithart>
  }

  scheduler();        
    8000038a:	00001097          	auipc	ra,0x1
    8000038e:	ffe080e7          	jalr	-2(ra) # 80001388 <scheduler>
    consoleinit();
    80000392:	00005097          	auipc	ra,0x5
    80000396:	7d2080e7          	jalr	2002(ra) # 80005b64 <consoleinit>
    printfinit();
    8000039a:	00006097          	auipc	ra,0x6
    8000039e:	afc080e7          	jalr	-1284(ra) # 80005e96 <printfinit>
    printf("\n");
    800003a2:	00008517          	auipc	a0,0x8
    800003a6:	c7650513          	addi	a0,a0,-906 # 80008018 <etext+0x18>
    800003aa:	00006097          	auipc	ra,0x6
    800003ae:	8e2080e7          	jalr	-1822(ra) # 80005c8c <printf>
    printf("xv6 kernel is booting\n");
    800003b2:	00008517          	auipc	a0,0x8
    800003b6:	c6e50513          	addi	a0,a0,-914 # 80008020 <etext+0x20>
    800003ba:	00006097          	auipc	ra,0x6
    800003be:	8d2080e7          	jalr	-1838(ra) # 80005c8c <printf>
    printf("\n");
    800003c2:	00008517          	auipc	a0,0x8
    800003c6:	c5650513          	addi	a0,a0,-938 # 80008018 <etext+0x18>
    800003ca:	00006097          	auipc	ra,0x6
    800003ce:	8c2080e7          	jalr	-1854(ra) # 80005c8c <printf>
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
    80000406:	d28080e7          	jalr	-728(ra) # 8000512a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    8000040a:	00005097          	auipc	ra,0x5
    8000040e:	d3a080e7          	jalr	-710(ra) # 80005144 <plicinithart>
    binit();         // buffer cache
    80000412:	00002097          	auipc	ra,0x2
    80000416:	e0a080e7          	jalr	-502(ra) # 8000221c <binit>
    iinit();         // inode table
    8000041a:	00002097          	auipc	ra,0x2
    8000041e:	478080e7          	jalr	1144(ra) # 80002892 <iinit>
    fileinit();      // file table
    80000422:	00003097          	auipc	ra,0x3
    80000426:	442080e7          	jalr	1090(ra) # 80003864 <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000042a:	00005097          	auipc	ra,0x5
    8000042e:	e3a080e7          	jalr	-454(ra) # 80005264 <virtio_disk_init>
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
    800004e0:	00005097          	auipc	ra,0x5
    800004e4:	762080e7          	jalr	1890(ra) # 80005c42 <panic>
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
    800005ce:	678080e7          	jalr	1656(ra) # 80005c42 <panic>
      panic("mappages: remap");
    800005d2:	00008517          	auipc	a0,0x8
    800005d6:	a9650513          	addi	a0,a0,-1386 # 80008068 <etext+0x68>
    800005da:	00005097          	auipc	ra,0x5
    800005de:	668080e7          	jalr	1640(ra) # 80005c42 <panic>
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
    8000062c:	61a080e7          	jalr	1562(ra) # 80005c42 <panic>

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
    8000076c:	4da080e7          	jalr	1242(ra) # 80005c42 <panic>
      panic("uvmunmap: walk");
    80000770:	00008517          	auipc	a0,0x8
    80000774:	92850513          	addi	a0,a0,-1752 # 80008098 <etext+0x98>
    80000778:	00005097          	auipc	ra,0x5
    8000077c:	4ca080e7          	jalr	1226(ra) # 80005c42 <panic>
      panic("uvmunmap: not mapped");
    80000780:	00008517          	auipc	a0,0x8
    80000784:	92850513          	addi	a0,a0,-1752 # 800080a8 <etext+0xa8>
    80000788:	00005097          	auipc	ra,0x5
    8000078c:	4ba080e7          	jalr	1210(ra) # 80005c42 <panic>
      panic("uvmunmap: not a leaf");
    80000790:	00008517          	auipc	a0,0x8
    80000794:	93050513          	addi	a0,a0,-1744 # 800080c0 <etext+0xc0>
    80000798:	00005097          	auipc	ra,0x5
    8000079c:	4aa080e7          	jalr	1194(ra) # 80005c42 <panic>
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
    80000890:	3b6080e7          	jalr	950(ra) # 80005c42 <panic>

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
    800009ee:	258080e7          	jalr	600(ra) # 80005c42 <panic>
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
    80000ab0:	196080e7          	jalr	406(ra) # 80005c42 <panic>
      panic("uvmcopy: page not present");
    80000ab4:	00007517          	auipc	a0,0x7
    80000ab8:	67450513          	addi	a0,a0,1652 # 80008128 <etext+0x128>
    80000abc:	00005097          	auipc	ra,0x5
    80000ac0:	186080e7          	jalr	390(ra) # 80005c42 <panic>
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
    80000b1c:	12a080e7          	jalr	298(ra) # 80005c42 <panic>

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
    80000d84:	ec2080e7          	jalr	-318(ra) # 80005c42 <panic>

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
    80000db0:	382080e7          	jalr	898(ra) # 8000612e <initlock>
  initlock(&wait_lock, "wait_lock");
    80000db4:	00007597          	auipc	a1,0x7
    80000db8:	3b458593          	addi	a1,a1,948 # 80008168 <etext+0x168>
    80000dbc:	00008517          	auipc	a0,0x8
    80000dc0:	2ac50513          	addi	a0,a0,684 # 80009068 <wait_lock>
    80000dc4:	00005097          	auipc	ra,0x5
    80000dc8:	36a080e7          	jalr	874(ra) # 8000612e <initlock>
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
    80000e0a:	328080e7          	jalr	808(ra) # 8000612e <initlock>
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
    80000e82:	2f8080e7          	jalr	760(ra) # 80006176 <push_off>
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
    80000e9c:	37e080e7          	jalr	894(ra) # 80006216 <pop_off>
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
    80000ec0:	3b6080e7          	jalr	950(ra) # 80006272 <release>

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
    80000eec:	92a080e7          	jalr	-1750(ra) # 80002812 <fsinit>
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
    80000f0c:	2ba080e7          	jalr	698(ra) # 800061c2 <acquire>
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
    80000f26:	350080e7          	jalr	848(ra) # 80006272 <release>
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
    800010a0:	126080e7          	jalr	294(ra) # 800061c2 <acquire>
    if(p->state == UNUSED) {
    800010a4:	4c9c                	lw	a5,24(s1)
    800010a6:	cf81                	beqz	a5,800010be <allocproc+0x40>
      release(&p->lock);
    800010a8:	8526                	mv	a0,s1
    800010aa:	00005097          	auipc	ra,0x5
    800010ae:	1c8080e7          	jalr	456(ra) # 80006272 <release>
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
    8000112c:	14a080e7          	jalr	330(ra) # 80006272 <release>
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
    80001144:	132080e7          	jalr	306(ra) # 80006272 <release>
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
    800011ae:	0c8080e7          	jalr	200(ra) # 80003272 <namei>
    800011b2:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800011b6:	478d                	li	a5,3
    800011b8:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800011ba:	8526                	mv	a0,s1
    800011bc:	00005097          	auipc	ra,0x5
    800011c0:	0b6080e7          	jalr	182(ra) # 80006272 <release>
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
    800012e2:	f94080e7          	jalr	-108(ra) # 80006272 <release>
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
    800012fc:	5fe080e7          	jalr	1534(ra) # 800038f6 <filedup>
    80001300:	00a93023          	sd	a0,0(s2)
    80001304:	b7e5                	j	800012ec <fork+0xa6>
  np->cwd = idup(p->cwd);
    80001306:	150ab503          	ld	a0,336(s5)
    8000130a:	00001097          	auipc	ra,0x1
    8000130e:	73e080e7          	jalr	1854(ra) # 80002a48 <idup>
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
    80001332:	f44080e7          	jalr	-188(ra) # 80006272 <release>
  acquire(&wait_lock);
    80001336:	00008497          	auipc	s1,0x8
    8000133a:	d3248493          	addi	s1,s1,-718 # 80009068 <wait_lock>
    8000133e:	8526                	mv	a0,s1
    80001340:	00005097          	auipc	ra,0x5
    80001344:	e82080e7          	jalr	-382(ra) # 800061c2 <acquire>
  np->parent = p;
    80001348:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    8000134c:	8526                	mv	a0,s1
    8000134e:	00005097          	auipc	ra,0x5
    80001352:	f24080e7          	jalr	-220(ra) # 80006272 <release>
  acquire(&np->lock);
    80001356:	8552                	mv	a0,s4
    80001358:	00005097          	auipc	ra,0x5
    8000135c:	e6a080e7          	jalr	-406(ra) # 800061c2 <acquire>
  np->state = RUNNABLE;
    80001360:	478d                	li	a5,3
    80001362:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001366:	8552                	mv	a0,s4
    80001368:	00005097          	auipc	ra,0x5
    8000136c:	f0a080e7          	jalr	-246(ra) # 80006272 <release>
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
    800013f0:	e86080e7          	jalr	-378(ra) # 80006272 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800013f4:	16848493          	addi	s1,s1,360
    800013f8:	fd248ae3          	beq	s1,s2,800013cc <scheduler+0x44>
      acquire(&p->lock);
    800013fc:	8526                	mv	a0,s1
    800013fe:	00005097          	auipc	ra,0x5
    80001402:	dc4080e7          	jalr	-572(ra) # 800061c2 <acquire>
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
    80001444:	d08080e7          	jalr	-760(ra) # 80006148 <holding>
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
    800014c6:	00004097          	auipc	ra,0x4
    800014ca:	77c080e7          	jalr	1916(ra) # 80005c42 <panic>
    panic("sched locks");
    800014ce:	00007517          	auipc	a0,0x7
    800014d2:	cda50513          	addi	a0,a0,-806 # 800081a8 <etext+0x1a8>
    800014d6:	00004097          	auipc	ra,0x4
    800014da:	76c080e7          	jalr	1900(ra) # 80005c42 <panic>
    panic("sched running");
    800014de:	00007517          	auipc	a0,0x7
    800014e2:	cda50513          	addi	a0,a0,-806 # 800081b8 <etext+0x1b8>
    800014e6:	00004097          	auipc	ra,0x4
    800014ea:	75c080e7          	jalr	1884(ra) # 80005c42 <panic>
    panic("sched interruptible");
    800014ee:	00007517          	auipc	a0,0x7
    800014f2:	cda50513          	addi	a0,a0,-806 # 800081c8 <etext+0x1c8>
    800014f6:	00004097          	auipc	ra,0x4
    800014fa:	74c080e7          	jalr	1868(ra) # 80005c42 <panic>

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
    80001516:	cb0080e7          	jalr	-848(ra) # 800061c2 <acquire>
  p->state = RUNNABLE;
    8000151a:	478d                	li	a5,3
    8000151c:	cc9c                	sw	a5,24(s1)
  sched();
    8000151e:	00000097          	auipc	ra,0x0
    80001522:	f0a080e7          	jalr	-246(ra) # 80001428 <sched>
  release(&p->lock);
    80001526:	8526                	mv	a0,s1
    80001528:	00005097          	auipc	ra,0x5
    8000152c:	d4a080e7          	jalr	-694(ra) # 80006272 <release>
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
    8000155a:	c6c080e7          	jalr	-916(ra) # 800061c2 <acquire>
  release(lk);
    8000155e:	854a                	mv	a0,s2
    80001560:	00005097          	auipc	ra,0x5
    80001564:	d12080e7          	jalr	-750(ra) # 80006272 <release>

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
    80001582:	cf4080e7          	jalr	-780(ra) # 80006272 <release>
  acquire(lk);
    80001586:	854a                	mv	a0,s2
    80001588:	00005097          	auipc	ra,0x5
    8000158c:	c3a080e7          	jalr	-966(ra) # 800061c2 <acquire>
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
    800015cc:	bfa080e7          	jalr	-1030(ra) # 800061c2 <acquire>
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
    80001616:	c60080e7          	jalr	-928(ra) # 80006272 <release>
          release(&wait_lock);
    8000161a:	00008517          	auipc	a0,0x8
    8000161e:	a4e50513          	addi	a0,a0,-1458 # 80009068 <wait_lock>
    80001622:	00005097          	auipc	ra,0x5
    80001626:	c50080e7          	jalr	-944(ra) # 80006272 <release>
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
    80001648:	c2e080e7          	jalr	-978(ra) # 80006272 <release>
            release(&wait_lock);
    8000164c:	00008517          	auipc	a0,0x8
    80001650:	a1c50513          	addi	a0,a0,-1508 # 80009068 <wait_lock>
    80001654:	00005097          	auipc	ra,0x5
    80001658:	c1e080e7          	jalr	-994(ra) # 80006272 <release>
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
    80001674:	b52080e7          	jalr	-1198(ra) # 800061c2 <acquire>
        if(np->state == ZOMBIE){
    80001678:	4c9c                	lw	a5,24(s1)
    8000167a:	f74786e3          	beq	a5,s4,800015e6 <wait+0x48>
        release(&np->lock);
    8000167e:	8526                	mv	a0,s1
    80001680:	00005097          	auipc	ra,0x5
    80001684:	bf2080e7          	jalr	-1038(ra) # 80006272 <release>
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
    800016b8:	bbe080e7          	jalr	-1090(ra) # 80006272 <release>
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
    800016f0:	b86080e7          	jalr	-1146(ra) # 80006272 <release>
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
    8000170e:	ab8080e7          	jalr	-1352(ra) # 800061c2 <acquire>
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
    800017cc:	47a080e7          	jalr	1146(ra) # 80005c42 <panic>
  for(int fd = 0; fd < NOFILE; fd++){
    800017d0:	04a1                	addi	s1,s1,8
    800017d2:	01248b63          	beq	s1,s2,800017e8 <exit+0x58>
    if(p->ofile[fd]){
    800017d6:	6088                	ld	a0,0(s1)
    800017d8:	dd65                	beqz	a0,800017d0 <exit+0x40>
      fileclose(f);
    800017da:	00002097          	auipc	ra,0x2
    800017de:	16e080e7          	jalr	366(ra) # 80003948 <fileclose>
      p->ofile[fd] = 0;
    800017e2:	0004b023          	sd	zero,0(s1)
    800017e6:	b7ed                	j	800017d0 <exit+0x40>
  begin_op();
    800017e8:	00002097          	auipc	ra,0x2
    800017ec:	c90080e7          	jalr	-880(ra) # 80003478 <begin_op>
  iput(p->cwd);
    800017f0:	1509b503          	ld	a0,336(s3)
    800017f4:	00001097          	auipc	ra,0x1
    800017f8:	450080e7          	jalr	1104(ra) # 80002c44 <iput>
  end_op();
    800017fc:	00002097          	auipc	ra,0x2
    80001800:	cf6080e7          	jalr	-778(ra) # 800034f2 <end_op>
  p->cwd = 0;
    80001804:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001808:	00008497          	auipc	s1,0x8
    8000180c:	86048493          	addi	s1,s1,-1952 # 80009068 <wait_lock>
    80001810:	8526                	mv	a0,s1
    80001812:	00005097          	auipc	ra,0x5
    80001816:	9b0080e7          	jalr	-1616(ra) # 800061c2 <acquire>
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
    80001836:	990080e7          	jalr	-1648(ra) # 800061c2 <acquire>
  p->xstate = status;
    8000183a:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    8000183e:	4795                	li	a5,5
    80001840:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001844:	8526                	mv	a0,s1
    80001846:	00005097          	auipc	ra,0x5
    8000184a:	a2c080e7          	jalr	-1492(ra) # 80006272 <release>
  sched();
    8000184e:	00000097          	auipc	ra,0x0
    80001852:	bda080e7          	jalr	-1062(ra) # 80001428 <sched>
  panic("zombie exit");
    80001856:	00007517          	auipc	a0,0x7
    8000185a:	99a50513          	addi	a0,a0,-1638 # 800081f0 <etext+0x1f0>
    8000185e:	00004097          	auipc	ra,0x4
    80001862:	3e4080e7          	jalr	996(ra) # 80005c42 <panic>

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
    8000188c:	93a080e7          	jalr	-1734(ra) # 800061c2 <acquire>
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
    8000189c:	9da080e7          	jalr	-1574(ra) # 80006272 <release>
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
    800018be:	9b8080e7          	jalr	-1608(ra) # 80006272 <release>
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
    800019a6:	2ea080e7          	jalr	746(ra) # 80005c8c <printf>
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
    800019e8:	2a8080e7          	jalr	680(ra) # 80005c8c <printf>
    printf("\n");
    800019ec:	8552                	mv	a0,s4
    800019ee:	00004097          	auipc	ra,0x4
    800019f2:	29e080e7          	jalr	670(ra) # 80005c8c <printf>
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
    80001aba:	678080e7          	jalr	1656(ra) # 8000612e <initlock>
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
    80001ad2:	5a278793          	addi	a5,a5,1442 # 80005070 <kernelvec>
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
    80001b98:	62e080e7          	jalr	1582(ra) # 800061c2 <acquire>
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
    80001bb8:	6be080e7          	jalr	1726(ra) # 80006272 <release>
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
    80001bfc:	584080e7          	jalr	1412(ra) # 8000517c <plic_claim>
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
    80001c1a:	4c8080e7          	jalr	1224(ra) # 800060de <uartintr>
    if(irq)
    80001c1e:	a839                	j	80001c3c <devintr+0x76>
      virtio_disk_intr();
    80001c20:	00004097          	auipc	ra,0x4
    80001c24:	a16080e7          	jalr	-1514(ra) # 80005636 <virtio_disk_intr>
    if(irq)
    80001c28:	a811                	j	80001c3c <devintr+0x76>
      printf("unexpected interrupt irq=%d\n", irq);
    80001c2a:	85a6                	mv	a1,s1
    80001c2c:	00006517          	auipc	a0,0x6
    80001c30:	61c50513          	addi	a0,a0,1564 # 80008248 <etext+0x248>
    80001c34:	00004097          	auipc	ra,0x4
    80001c38:	058080e7          	jalr	88(ra) # 80005c8c <printf>
      plic_complete(irq);
    80001c3c:	8526                	mv	a0,s1
    80001c3e:	00003097          	auipc	ra,0x3
    80001c42:	562080e7          	jalr	1378(ra) # 800051a0 <plic_complete>
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
    80001c70:	1101                	addi	sp,sp,-32
    80001c72:	ec06                	sd	ra,24(sp)
    80001c74:	e822                	sd	s0,16(sp)
    80001c76:	e426                	sd	s1,8(sp)
    80001c78:	e04a                	sd	s2,0(sp)
    80001c7a:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c7c:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001c80:	1007f793          	andi	a5,a5,256
    80001c84:	e3ad                	bnez	a5,80001ce6 <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c86:	00003797          	auipc	a5,0x3
    80001c8a:	3ea78793          	addi	a5,a5,1002 # 80005070 <kernelvec>
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
    80001caa:	04f71c63          	bne	a4,a5,80001d02 <usertrap+0x92>
    if(p->killed)
    80001cae:	551c                	lw	a5,40(a0)
    80001cb0:	e3b9                	bnez	a5,80001cf6 <usertrap+0x86>
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
    80001cca:	2e0080e7          	jalr	736(ra) # 80001fa6 <syscall>
  if(p->killed)
    80001cce:	549c                	lw	a5,40(s1)
    80001cd0:	ebc1                	bnez	a5,80001d60 <usertrap+0xf0>
  usertrapret();
    80001cd2:	00000097          	auipc	ra,0x0
    80001cd6:	e10080e7          	jalr	-496(ra) # 80001ae2 <usertrapret>
}
    80001cda:	60e2                	ld	ra,24(sp)
    80001cdc:	6442                	ld	s0,16(sp)
    80001cde:	64a2                	ld	s1,8(sp)
    80001ce0:	6902                	ld	s2,0(sp)
    80001ce2:	6105                	addi	sp,sp,32
    80001ce4:	8082                	ret
    panic("usertrap: not from user mode");
    80001ce6:	00006517          	auipc	a0,0x6
    80001cea:	58250513          	addi	a0,a0,1410 # 80008268 <etext+0x268>
    80001cee:	00004097          	auipc	ra,0x4
    80001cf2:	f54080e7          	jalr	-172(ra) # 80005c42 <panic>
      exit(-1);
    80001cf6:	557d                	li	a0,-1
    80001cf8:	00000097          	auipc	ra,0x0
    80001cfc:	a98080e7          	jalr	-1384(ra) # 80001790 <exit>
    80001d00:	bf4d                	j	80001cb2 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001d02:	00000097          	auipc	ra,0x0
    80001d06:	ec4080e7          	jalr	-316(ra) # 80001bc6 <devintr>
    80001d0a:	892a                	mv	s2,a0
    80001d0c:	c501                	beqz	a0,80001d14 <usertrap+0xa4>
  if(p->killed)
    80001d0e:	549c                	lw	a5,40(s1)
    80001d10:	c3a1                	beqz	a5,80001d50 <usertrap+0xe0>
    80001d12:	a815                	j	80001d46 <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d14:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001d18:	5890                	lw	a2,48(s1)
    80001d1a:	00006517          	auipc	a0,0x6
    80001d1e:	56e50513          	addi	a0,a0,1390 # 80008288 <etext+0x288>
    80001d22:	00004097          	auipc	ra,0x4
    80001d26:	f6a080e7          	jalr	-150(ra) # 80005c8c <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d2a:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001d2e:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001d32:	00006517          	auipc	a0,0x6
    80001d36:	58650513          	addi	a0,a0,1414 # 800082b8 <etext+0x2b8>
    80001d3a:	00004097          	auipc	ra,0x4
    80001d3e:	f52080e7          	jalr	-174(ra) # 80005c8c <printf>
    p->killed = 1;
    80001d42:	4785                	li	a5,1
    80001d44:	d49c                	sw	a5,40(s1)
    exit(-1);
    80001d46:	557d                	li	a0,-1
    80001d48:	00000097          	auipc	ra,0x0
    80001d4c:	a48080e7          	jalr	-1464(ra) # 80001790 <exit>
  if(which_dev == 2)
    80001d50:	4789                	li	a5,2
    80001d52:	f8f910e3          	bne	s2,a5,80001cd2 <usertrap+0x62>
    yield();
    80001d56:	fffff097          	auipc	ra,0xfffff
    80001d5a:	7a8080e7          	jalr	1960(ra) # 800014fe <yield>
    80001d5e:	bf95                	j	80001cd2 <usertrap+0x62>
  int which_dev = 0;
    80001d60:	4901                	li	s2,0
    80001d62:	b7d5                	j	80001d46 <usertrap+0xd6>

0000000080001d64 <kerneltrap>:
{
    80001d64:	7179                	addi	sp,sp,-48
    80001d66:	f406                	sd	ra,40(sp)
    80001d68:	f022                	sd	s0,32(sp)
    80001d6a:	ec26                	sd	s1,24(sp)
    80001d6c:	e84a                	sd	s2,16(sp)
    80001d6e:	e44e                	sd	s3,8(sp)
    80001d70:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d72:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d76:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d7a:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001d7e:	1004f793          	andi	a5,s1,256
    80001d82:	cb85                	beqz	a5,80001db2 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d84:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001d88:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001d8a:	ef85                	bnez	a5,80001dc2 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001d8c:	00000097          	auipc	ra,0x0
    80001d90:	e3a080e7          	jalr	-454(ra) # 80001bc6 <devintr>
    80001d94:	cd1d                	beqz	a0,80001dd2 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001d96:	4789                	li	a5,2
    80001d98:	06f50a63          	beq	a0,a5,80001e0c <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001d9c:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001da0:	10049073          	csrw	sstatus,s1
}
    80001da4:	70a2                	ld	ra,40(sp)
    80001da6:	7402                	ld	s0,32(sp)
    80001da8:	64e2                	ld	s1,24(sp)
    80001daa:	6942                	ld	s2,16(sp)
    80001dac:	69a2                	ld	s3,8(sp)
    80001dae:	6145                	addi	sp,sp,48
    80001db0:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001db2:	00006517          	auipc	a0,0x6
    80001db6:	52650513          	addi	a0,a0,1318 # 800082d8 <etext+0x2d8>
    80001dba:	00004097          	auipc	ra,0x4
    80001dbe:	e88080e7          	jalr	-376(ra) # 80005c42 <panic>
    panic("kerneltrap: interrupts enabled");
    80001dc2:	00006517          	auipc	a0,0x6
    80001dc6:	53e50513          	addi	a0,a0,1342 # 80008300 <etext+0x300>
    80001dca:	00004097          	auipc	ra,0x4
    80001dce:	e78080e7          	jalr	-392(ra) # 80005c42 <panic>
    printf("scause %p\n", scause);
    80001dd2:	85ce                	mv	a1,s3
    80001dd4:	00006517          	auipc	a0,0x6
    80001dd8:	54c50513          	addi	a0,a0,1356 # 80008320 <etext+0x320>
    80001ddc:	00004097          	auipc	ra,0x4
    80001de0:	eb0080e7          	jalr	-336(ra) # 80005c8c <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001de4:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001de8:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001dec:	00006517          	auipc	a0,0x6
    80001df0:	54450513          	addi	a0,a0,1348 # 80008330 <etext+0x330>
    80001df4:	00004097          	auipc	ra,0x4
    80001df8:	e98080e7          	jalr	-360(ra) # 80005c8c <printf>
    panic("kerneltrap");
    80001dfc:	00006517          	auipc	a0,0x6
    80001e00:	54c50513          	addi	a0,a0,1356 # 80008348 <etext+0x348>
    80001e04:	00004097          	auipc	ra,0x4
    80001e08:	e3e080e7          	jalr	-450(ra) # 80005c42 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e0c:	fffff097          	auipc	ra,0xfffff
    80001e10:	068080e7          	jalr	104(ra) # 80000e74 <myproc>
    80001e14:	d541                	beqz	a0,80001d9c <kerneltrap+0x38>
    80001e16:	fffff097          	auipc	ra,0xfffff
    80001e1a:	05e080e7          	jalr	94(ra) # 80000e74 <myproc>
    80001e1e:	4d18                	lw	a4,24(a0)
    80001e20:	4791                	li	a5,4
    80001e22:	f6f71de3          	bne	a4,a5,80001d9c <kerneltrap+0x38>
    yield();
    80001e26:	fffff097          	auipc	ra,0xfffff
    80001e2a:	6d8080e7          	jalr	1752(ra) # 800014fe <yield>
    80001e2e:	b7bd                	j	80001d9c <kerneltrap+0x38>

0000000080001e30 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001e30:	1101                	addi	sp,sp,-32
    80001e32:	ec06                	sd	ra,24(sp)
    80001e34:	e822                	sd	s0,16(sp)
    80001e36:	e426                	sd	s1,8(sp)
    80001e38:	1000                	addi	s0,sp,32
    80001e3a:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001e3c:	fffff097          	auipc	ra,0xfffff
    80001e40:	038080e7          	jalr	56(ra) # 80000e74 <myproc>
  switch (n) {
    80001e44:	4795                	li	a5,5
    80001e46:	0497e163          	bltu	a5,s1,80001e88 <argraw+0x58>
    80001e4a:	048a                	slli	s1,s1,0x2
    80001e4c:	00007717          	auipc	a4,0x7
    80001e50:	8e470713          	addi	a4,a4,-1820 # 80008730 <states.0+0x30>
    80001e54:	94ba                	add	s1,s1,a4
    80001e56:	409c                	lw	a5,0(s1)
    80001e58:	97ba                	add	a5,a5,a4
    80001e5a:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001e5c:	6d3c                	ld	a5,88(a0)
    80001e5e:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001e60:	60e2                	ld	ra,24(sp)
    80001e62:	6442                	ld	s0,16(sp)
    80001e64:	64a2                	ld	s1,8(sp)
    80001e66:	6105                	addi	sp,sp,32
    80001e68:	8082                	ret
    return p->trapframe->a1;
    80001e6a:	6d3c                	ld	a5,88(a0)
    80001e6c:	7fa8                	ld	a0,120(a5)
    80001e6e:	bfcd                	j	80001e60 <argraw+0x30>
    return p->trapframe->a2;
    80001e70:	6d3c                	ld	a5,88(a0)
    80001e72:	63c8                	ld	a0,128(a5)
    80001e74:	b7f5                	j	80001e60 <argraw+0x30>
    return p->trapframe->a3;
    80001e76:	6d3c                	ld	a5,88(a0)
    80001e78:	67c8                	ld	a0,136(a5)
    80001e7a:	b7dd                	j	80001e60 <argraw+0x30>
    return p->trapframe->a4;
    80001e7c:	6d3c                	ld	a5,88(a0)
    80001e7e:	6bc8                	ld	a0,144(a5)
    80001e80:	b7c5                	j	80001e60 <argraw+0x30>
    return p->trapframe->a5;
    80001e82:	6d3c                	ld	a5,88(a0)
    80001e84:	6fc8                	ld	a0,152(a5)
    80001e86:	bfe9                	j	80001e60 <argraw+0x30>
  panic("argraw");
    80001e88:	00006517          	auipc	a0,0x6
    80001e8c:	4d050513          	addi	a0,a0,1232 # 80008358 <etext+0x358>
    80001e90:	00004097          	auipc	ra,0x4
    80001e94:	db2080e7          	jalr	-590(ra) # 80005c42 <panic>

0000000080001e98 <fetchaddr>:
{
    80001e98:	1101                	addi	sp,sp,-32
    80001e9a:	ec06                	sd	ra,24(sp)
    80001e9c:	e822                	sd	s0,16(sp)
    80001e9e:	e426                	sd	s1,8(sp)
    80001ea0:	e04a                	sd	s2,0(sp)
    80001ea2:	1000                	addi	s0,sp,32
    80001ea4:	84aa                	mv	s1,a0
    80001ea6:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001ea8:	fffff097          	auipc	ra,0xfffff
    80001eac:	fcc080e7          	jalr	-52(ra) # 80000e74 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80001eb0:	653c                	ld	a5,72(a0)
    80001eb2:	02f4f863          	bgeu	s1,a5,80001ee2 <fetchaddr+0x4a>
    80001eb6:	00848713          	addi	a4,s1,8
    80001eba:	02e7e663          	bltu	a5,a4,80001ee6 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001ebe:	46a1                	li	a3,8
    80001ec0:	8626                	mv	a2,s1
    80001ec2:	85ca                	mv	a1,s2
    80001ec4:	6928                	ld	a0,80(a0)
    80001ec6:	fffff097          	auipc	ra,0xfffff
    80001eca:	ce6080e7          	jalr	-794(ra) # 80000bac <copyin>
    80001ece:	00a03533          	snez	a0,a0
    80001ed2:	40a0053b          	negw	a0,a0
}
    80001ed6:	60e2                	ld	ra,24(sp)
    80001ed8:	6442                	ld	s0,16(sp)
    80001eda:	64a2                	ld	s1,8(sp)
    80001edc:	6902                	ld	s2,0(sp)
    80001ede:	6105                	addi	sp,sp,32
    80001ee0:	8082                	ret
    return -1;
    80001ee2:	557d                	li	a0,-1
    80001ee4:	bfcd                	j	80001ed6 <fetchaddr+0x3e>
    80001ee6:	557d                	li	a0,-1
    80001ee8:	b7fd                	j	80001ed6 <fetchaddr+0x3e>

0000000080001eea <fetchstr>:
{
    80001eea:	7179                	addi	sp,sp,-48
    80001eec:	f406                	sd	ra,40(sp)
    80001eee:	f022                	sd	s0,32(sp)
    80001ef0:	ec26                	sd	s1,24(sp)
    80001ef2:	e84a                	sd	s2,16(sp)
    80001ef4:	e44e                	sd	s3,8(sp)
    80001ef6:	1800                	addi	s0,sp,48
    80001ef8:	892a                	mv	s2,a0
    80001efa:	84ae                	mv	s1,a1
    80001efc:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001efe:	fffff097          	auipc	ra,0xfffff
    80001f02:	f76080e7          	jalr	-138(ra) # 80000e74 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80001f06:	86ce                	mv	a3,s3
    80001f08:	864a                	mv	a2,s2
    80001f0a:	85a6                	mv	a1,s1
    80001f0c:	6928                	ld	a0,80(a0)
    80001f0e:	fffff097          	auipc	ra,0xfffff
    80001f12:	d2c080e7          	jalr	-724(ra) # 80000c3a <copyinstr>
  if(err < 0)
    80001f16:	00054763          	bltz	a0,80001f24 <fetchstr+0x3a>
  return strlen(buf);
    80001f1a:	8526                	mv	a0,s1
    80001f1c:	ffffe097          	auipc	ra,0xffffe
    80001f20:	3ea080e7          	jalr	1002(ra) # 80000306 <strlen>
}
    80001f24:	70a2                	ld	ra,40(sp)
    80001f26:	7402                	ld	s0,32(sp)
    80001f28:	64e2                	ld	s1,24(sp)
    80001f2a:	6942                	ld	s2,16(sp)
    80001f2c:	69a2                	ld	s3,8(sp)
    80001f2e:	6145                	addi	sp,sp,48
    80001f30:	8082                	ret

0000000080001f32 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80001f32:	1101                	addi	sp,sp,-32
    80001f34:	ec06                	sd	ra,24(sp)
    80001f36:	e822                	sd	s0,16(sp)
    80001f38:	e426                	sd	s1,8(sp)
    80001f3a:	1000                	addi	s0,sp,32
    80001f3c:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001f3e:	00000097          	auipc	ra,0x0
    80001f42:	ef2080e7          	jalr	-270(ra) # 80001e30 <argraw>
    80001f46:	c088                	sw	a0,0(s1)
  return 0;
}
    80001f48:	4501                	li	a0,0
    80001f4a:	60e2                	ld	ra,24(sp)
    80001f4c:	6442                	ld	s0,16(sp)
    80001f4e:	64a2                	ld	s1,8(sp)
    80001f50:	6105                	addi	sp,sp,32
    80001f52:	8082                	ret

0000000080001f54 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80001f54:	1101                	addi	sp,sp,-32
    80001f56:	ec06                	sd	ra,24(sp)
    80001f58:	e822                	sd	s0,16(sp)
    80001f5a:	e426                	sd	s1,8(sp)
    80001f5c:	1000                	addi	s0,sp,32
    80001f5e:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001f60:	00000097          	auipc	ra,0x0
    80001f64:	ed0080e7          	jalr	-304(ra) # 80001e30 <argraw>
    80001f68:	e088                	sd	a0,0(s1)
  return 0;
}
    80001f6a:	4501                	li	a0,0
    80001f6c:	60e2                	ld	ra,24(sp)
    80001f6e:	6442                	ld	s0,16(sp)
    80001f70:	64a2                	ld	s1,8(sp)
    80001f72:	6105                	addi	sp,sp,32
    80001f74:	8082                	ret

0000000080001f76 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001f76:	1101                	addi	sp,sp,-32
    80001f78:	ec06                	sd	ra,24(sp)
    80001f7a:	e822                	sd	s0,16(sp)
    80001f7c:	e426                	sd	s1,8(sp)
    80001f7e:	e04a                	sd	s2,0(sp)
    80001f80:	1000                	addi	s0,sp,32
    80001f82:	84ae                	mv	s1,a1
    80001f84:	8932                	mv	s2,a2
  *ip = argraw(n);
    80001f86:	00000097          	auipc	ra,0x0
    80001f8a:	eaa080e7          	jalr	-342(ra) # 80001e30 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80001f8e:	864a                	mv	a2,s2
    80001f90:	85a6                	mv	a1,s1
    80001f92:	00000097          	auipc	ra,0x0
    80001f96:	f58080e7          	jalr	-168(ra) # 80001eea <fetchstr>
}
    80001f9a:	60e2                	ld	ra,24(sp)
    80001f9c:	6442                	ld	s0,16(sp)
    80001f9e:	64a2                	ld	s1,8(sp)
    80001fa0:	6902                	ld	s2,0(sp)
    80001fa2:	6105                	addi	sp,sp,32
    80001fa4:	8082                	ret

0000000080001fa6 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    80001fa6:	1101                	addi	sp,sp,-32
    80001fa8:	ec06                	sd	ra,24(sp)
    80001faa:	e822                	sd	s0,16(sp)
    80001fac:	e426                	sd	s1,8(sp)
    80001fae:	e04a                	sd	s2,0(sp)
    80001fb0:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80001fb2:	fffff097          	auipc	ra,0xfffff
    80001fb6:	ec2080e7          	jalr	-318(ra) # 80000e74 <myproc>
    80001fba:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80001fbc:	05853903          	ld	s2,88(a0)
    80001fc0:	0a893783          	ld	a5,168(s2)
    80001fc4:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80001fc8:	37fd                	addiw	a5,a5,-1
    80001fca:	4751                	li	a4,20
    80001fcc:	00f76f63          	bltu	a4,a5,80001fea <syscall+0x44>
    80001fd0:	00369713          	slli	a4,a3,0x3
    80001fd4:	00006797          	auipc	a5,0x6
    80001fd8:	77478793          	addi	a5,a5,1908 # 80008748 <syscalls>
    80001fdc:	97ba                	add	a5,a5,a4
    80001fde:	639c                	ld	a5,0(a5)
    80001fe0:	c789                	beqz	a5,80001fea <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    80001fe2:	9782                	jalr	a5
    80001fe4:	06a93823          	sd	a0,112(s2)
    80001fe8:	a839                	j	80002006 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80001fea:	15848613          	addi	a2,s1,344
    80001fee:	588c                	lw	a1,48(s1)
    80001ff0:	00006517          	auipc	a0,0x6
    80001ff4:	37050513          	addi	a0,a0,880 # 80008360 <etext+0x360>
    80001ff8:	00004097          	auipc	ra,0x4
    80001ffc:	c94080e7          	jalr	-876(ra) # 80005c8c <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002000:	6cbc                	ld	a5,88(s1)
    80002002:	577d                	li	a4,-1
    80002004:	fbb8                	sd	a4,112(a5)
  }
}
    80002006:	60e2                	ld	ra,24(sp)
    80002008:	6442                	ld	s0,16(sp)
    8000200a:	64a2                	ld	s1,8(sp)
    8000200c:	6902                	ld	s2,0(sp)
    8000200e:	6105                	addi	sp,sp,32
    80002010:	8082                	ret

0000000080002012 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002012:	1101                	addi	sp,sp,-32
    80002014:	ec06                	sd	ra,24(sp)
    80002016:	e822                	sd	s0,16(sp)
    80002018:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    8000201a:	fec40593          	addi	a1,s0,-20
    8000201e:	4501                	li	a0,0
    80002020:	00000097          	auipc	ra,0x0
    80002024:	f12080e7          	jalr	-238(ra) # 80001f32 <argint>
    return -1;
    80002028:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    8000202a:	00054963          	bltz	a0,8000203c <sys_exit+0x2a>
  exit(n);
    8000202e:	fec42503          	lw	a0,-20(s0)
    80002032:	fffff097          	auipc	ra,0xfffff
    80002036:	75e080e7          	jalr	1886(ra) # 80001790 <exit>
  return 0;  // not reached
    8000203a:	4781                	li	a5,0
}
    8000203c:	853e                	mv	a0,a5
    8000203e:	60e2                	ld	ra,24(sp)
    80002040:	6442                	ld	s0,16(sp)
    80002042:	6105                	addi	sp,sp,32
    80002044:	8082                	ret

0000000080002046 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002046:	1141                	addi	sp,sp,-16
    80002048:	e406                	sd	ra,8(sp)
    8000204a:	e022                	sd	s0,0(sp)
    8000204c:	0800                	addi	s0,sp,16
  return myproc()->pid;
    8000204e:	fffff097          	auipc	ra,0xfffff
    80002052:	e26080e7          	jalr	-474(ra) # 80000e74 <myproc>
}
    80002056:	5908                	lw	a0,48(a0)
    80002058:	60a2                	ld	ra,8(sp)
    8000205a:	6402                	ld	s0,0(sp)
    8000205c:	0141                	addi	sp,sp,16
    8000205e:	8082                	ret

0000000080002060 <sys_fork>:

uint64
sys_fork(void)
{
    80002060:	1141                	addi	sp,sp,-16
    80002062:	e406                	sd	ra,8(sp)
    80002064:	e022                	sd	s0,0(sp)
    80002066:	0800                	addi	s0,sp,16
  return fork();
    80002068:	fffff097          	auipc	ra,0xfffff
    8000206c:	1de080e7          	jalr	478(ra) # 80001246 <fork>
}
    80002070:	60a2                	ld	ra,8(sp)
    80002072:	6402                	ld	s0,0(sp)
    80002074:	0141                	addi	sp,sp,16
    80002076:	8082                	ret

0000000080002078 <sys_wait>:

uint64
sys_wait(void)
{
    80002078:	1101                	addi	sp,sp,-32
    8000207a:	ec06                	sd	ra,24(sp)
    8000207c:	e822                	sd	s0,16(sp)
    8000207e:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002080:	fe840593          	addi	a1,s0,-24
    80002084:	4501                	li	a0,0
    80002086:	00000097          	auipc	ra,0x0
    8000208a:	ece080e7          	jalr	-306(ra) # 80001f54 <argaddr>
    8000208e:	87aa                	mv	a5,a0
    return -1;
    80002090:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002092:	0007c863          	bltz	a5,800020a2 <sys_wait+0x2a>
  return wait(p);
    80002096:	fe843503          	ld	a0,-24(s0)
    8000209a:	fffff097          	auipc	ra,0xfffff
    8000209e:	504080e7          	jalr	1284(ra) # 8000159e <wait>
}
    800020a2:	60e2                	ld	ra,24(sp)
    800020a4:	6442                	ld	s0,16(sp)
    800020a6:	6105                	addi	sp,sp,32
    800020a8:	8082                	ret

00000000800020aa <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800020aa:	7179                	addi	sp,sp,-48
    800020ac:	f406                	sd	ra,40(sp)
    800020ae:	f022                	sd	s0,32(sp)
    800020b0:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    800020b2:	fdc40593          	addi	a1,s0,-36
    800020b6:	4501                	li	a0,0
    800020b8:	00000097          	auipc	ra,0x0
    800020bc:	e7a080e7          	jalr	-390(ra) # 80001f32 <argint>
    800020c0:	87aa                	mv	a5,a0
    return -1;
    800020c2:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    800020c4:	0207c263          	bltz	a5,800020e8 <sys_sbrk+0x3e>
    800020c8:	ec26                	sd	s1,24(sp)
  addr = myproc()->sz;
    800020ca:	fffff097          	auipc	ra,0xfffff
    800020ce:	daa080e7          	jalr	-598(ra) # 80000e74 <myproc>
    800020d2:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    800020d4:	fdc42503          	lw	a0,-36(s0)
    800020d8:	fffff097          	auipc	ra,0xfffff
    800020dc:	0f6080e7          	jalr	246(ra) # 800011ce <growproc>
    800020e0:	00054863          	bltz	a0,800020f0 <sys_sbrk+0x46>
    return -1;
  return addr;
    800020e4:	8526                	mv	a0,s1
    800020e6:	64e2                	ld	s1,24(sp)
}
    800020e8:	70a2                	ld	ra,40(sp)
    800020ea:	7402                	ld	s0,32(sp)
    800020ec:	6145                	addi	sp,sp,48
    800020ee:	8082                	ret
    return -1;
    800020f0:	557d                	li	a0,-1
    800020f2:	64e2                	ld	s1,24(sp)
    800020f4:	bfd5                	j	800020e8 <sys_sbrk+0x3e>

00000000800020f6 <sys_sleep>:

uint64
sys_sleep(void)
{
    800020f6:	7139                	addi	sp,sp,-64
    800020f8:	fc06                	sd	ra,56(sp)
    800020fa:	f822                	sd	s0,48(sp)
    800020fc:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    800020fe:	fcc40593          	addi	a1,s0,-52
    80002102:	4501                	li	a0,0
    80002104:	00000097          	auipc	ra,0x0
    80002108:	e2e080e7          	jalr	-466(ra) # 80001f32 <argint>
    return -1;
    8000210c:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    8000210e:	06054b63          	bltz	a0,80002184 <sys_sleep+0x8e>
    80002112:	f04a                	sd	s2,32(sp)
  acquire(&tickslock);
    80002114:	0000d517          	auipc	a0,0xd
    80002118:	d6c50513          	addi	a0,a0,-660 # 8000ee80 <tickslock>
    8000211c:	00004097          	auipc	ra,0x4
    80002120:	0a6080e7          	jalr	166(ra) # 800061c2 <acquire>
  ticks0 = ticks;
    80002124:	00007917          	auipc	s2,0x7
    80002128:	ef492903          	lw	s2,-268(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    8000212c:	fcc42783          	lw	a5,-52(s0)
    80002130:	c3a1                	beqz	a5,80002170 <sys_sleep+0x7a>
    80002132:	f426                	sd	s1,40(sp)
    80002134:	ec4e                	sd	s3,24(sp)
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002136:	0000d997          	auipc	s3,0xd
    8000213a:	d4a98993          	addi	s3,s3,-694 # 8000ee80 <tickslock>
    8000213e:	00007497          	auipc	s1,0x7
    80002142:	eda48493          	addi	s1,s1,-294 # 80009018 <ticks>
    if(myproc()->killed){
    80002146:	fffff097          	auipc	ra,0xfffff
    8000214a:	d2e080e7          	jalr	-722(ra) # 80000e74 <myproc>
    8000214e:	551c                	lw	a5,40(a0)
    80002150:	ef9d                	bnez	a5,8000218e <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    80002152:	85ce                	mv	a1,s3
    80002154:	8526                	mv	a0,s1
    80002156:	fffff097          	auipc	ra,0xfffff
    8000215a:	3e4080e7          	jalr	996(ra) # 8000153a <sleep>
  while(ticks - ticks0 < n){
    8000215e:	409c                	lw	a5,0(s1)
    80002160:	412787bb          	subw	a5,a5,s2
    80002164:	fcc42703          	lw	a4,-52(s0)
    80002168:	fce7efe3          	bltu	a5,a4,80002146 <sys_sleep+0x50>
    8000216c:	74a2                	ld	s1,40(sp)
    8000216e:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80002170:	0000d517          	auipc	a0,0xd
    80002174:	d1050513          	addi	a0,a0,-752 # 8000ee80 <tickslock>
    80002178:	00004097          	auipc	ra,0x4
    8000217c:	0fa080e7          	jalr	250(ra) # 80006272 <release>
  return 0;
    80002180:	4781                	li	a5,0
    80002182:	7902                	ld	s2,32(sp)
}
    80002184:	853e                	mv	a0,a5
    80002186:	70e2                	ld	ra,56(sp)
    80002188:	7442                	ld	s0,48(sp)
    8000218a:	6121                	addi	sp,sp,64
    8000218c:	8082                	ret
      release(&tickslock);
    8000218e:	0000d517          	auipc	a0,0xd
    80002192:	cf250513          	addi	a0,a0,-782 # 8000ee80 <tickslock>
    80002196:	00004097          	auipc	ra,0x4
    8000219a:	0dc080e7          	jalr	220(ra) # 80006272 <release>
      return -1;
    8000219e:	57fd                	li	a5,-1
    800021a0:	74a2                	ld	s1,40(sp)
    800021a2:	7902                	ld	s2,32(sp)
    800021a4:	69e2                	ld	s3,24(sp)
    800021a6:	bff9                	j	80002184 <sys_sleep+0x8e>

00000000800021a8 <sys_kill>:

uint64
sys_kill(void)
{
    800021a8:	1101                	addi	sp,sp,-32
    800021aa:	ec06                	sd	ra,24(sp)
    800021ac:	e822                	sd	s0,16(sp)
    800021ae:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    800021b0:	fec40593          	addi	a1,s0,-20
    800021b4:	4501                	li	a0,0
    800021b6:	00000097          	auipc	ra,0x0
    800021ba:	d7c080e7          	jalr	-644(ra) # 80001f32 <argint>
    800021be:	87aa                	mv	a5,a0
    return -1;
    800021c0:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    800021c2:	0007c863          	bltz	a5,800021d2 <sys_kill+0x2a>
  return kill(pid);
    800021c6:	fec42503          	lw	a0,-20(s0)
    800021ca:	fffff097          	auipc	ra,0xfffff
    800021ce:	69c080e7          	jalr	1692(ra) # 80001866 <kill>
}
    800021d2:	60e2                	ld	ra,24(sp)
    800021d4:	6442                	ld	s0,16(sp)
    800021d6:	6105                	addi	sp,sp,32
    800021d8:	8082                	ret

00000000800021da <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800021da:	1101                	addi	sp,sp,-32
    800021dc:	ec06                	sd	ra,24(sp)
    800021de:	e822                	sd	s0,16(sp)
    800021e0:	e426                	sd	s1,8(sp)
    800021e2:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800021e4:	0000d517          	auipc	a0,0xd
    800021e8:	c9c50513          	addi	a0,a0,-868 # 8000ee80 <tickslock>
    800021ec:	00004097          	auipc	ra,0x4
    800021f0:	fd6080e7          	jalr	-42(ra) # 800061c2 <acquire>
  xticks = ticks;
    800021f4:	00007497          	auipc	s1,0x7
    800021f8:	e244a483          	lw	s1,-476(s1) # 80009018 <ticks>
  release(&tickslock);
    800021fc:	0000d517          	auipc	a0,0xd
    80002200:	c8450513          	addi	a0,a0,-892 # 8000ee80 <tickslock>
    80002204:	00004097          	auipc	ra,0x4
    80002208:	06e080e7          	jalr	110(ra) # 80006272 <release>
  return xticks;
}
    8000220c:	02049513          	slli	a0,s1,0x20
    80002210:	9101                	srli	a0,a0,0x20
    80002212:	60e2                	ld	ra,24(sp)
    80002214:	6442                	ld	s0,16(sp)
    80002216:	64a2                	ld	s1,8(sp)
    80002218:	6105                	addi	sp,sp,32
    8000221a:	8082                	ret

000000008000221c <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000221c:	7179                	addi	sp,sp,-48
    8000221e:	f406                	sd	ra,40(sp)
    80002220:	f022                	sd	s0,32(sp)
    80002222:	ec26                	sd	s1,24(sp)
    80002224:	e84a                	sd	s2,16(sp)
    80002226:	e44e                	sd	s3,8(sp)
    80002228:	e052                	sd	s4,0(sp)
    8000222a:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000222c:	00006597          	auipc	a1,0x6
    80002230:	15458593          	addi	a1,a1,340 # 80008380 <etext+0x380>
    80002234:	0000d517          	auipc	a0,0xd
    80002238:	c6450513          	addi	a0,a0,-924 # 8000ee98 <bcache>
    8000223c:	00004097          	auipc	ra,0x4
    80002240:	ef2080e7          	jalr	-270(ra) # 8000612e <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002244:	00015797          	auipc	a5,0x15
    80002248:	c5478793          	addi	a5,a5,-940 # 80016e98 <bcache+0x8000>
    8000224c:	00015717          	auipc	a4,0x15
    80002250:	eb470713          	addi	a4,a4,-332 # 80017100 <bcache+0x8268>
    80002254:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002258:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000225c:	0000d497          	auipc	s1,0xd
    80002260:	c5448493          	addi	s1,s1,-940 # 8000eeb0 <bcache+0x18>
    b->next = bcache.head.next;
    80002264:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002266:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002268:	00006a17          	auipc	s4,0x6
    8000226c:	120a0a13          	addi	s4,s4,288 # 80008388 <etext+0x388>
    b->next = bcache.head.next;
    80002270:	2b893783          	ld	a5,696(s2)
    80002274:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002276:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000227a:	85d2                	mv	a1,s4
    8000227c:	01048513          	addi	a0,s1,16
    80002280:	00001097          	auipc	ra,0x1
    80002284:	4ba080e7          	jalr	1210(ra) # 8000373a <initsleeplock>
    bcache.head.next->prev = b;
    80002288:	2b893783          	ld	a5,696(s2)
    8000228c:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    8000228e:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002292:	45848493          	addi	s1,s1,1112
    80002296:	fd349de3          	bne	s1,s3,80002270 <binit+0x54>
  }
}
    8000229a:	70a2                	ld	ra,40(sp)
    8000229c:	7402                	ld	s0,32(sp)
    8000229e:	64e2                	ld	s1,24(sp)
    800022a0:	6942                	ld	s2,16(sp)
    800022a2:	69a2                	ld	s3,8(sp)
    800022a4:	6a02                	ld	s4,0(sp)
    800022a6:	6145                	addi	sp,sp,48
    800022a8:	8082                	ret

00000000800022aa <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800022aa:	7179                	addi	sp,sp,-48
    800022ac:	f406                	sd	ra,40(sp)
    800022ae:	f022                	sd	s0,32(sp)
    800022b0:	ec26                	sd	s1,24(sp)
    800022b2:	e84a                	sd	s2,16(sp)
    800022b4:	e44e                	sd	s3,8(sp)
    800022b6:	1800                	addi	s0,sp,48
    800022b8:	892a                	mv	s2,a0
    800022ba:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800022bc:	0000d517          	auipc	a0,0xd
    800022c0:	bdc50513          	addi	a0,a0,-1060 # 8000ee98 <bcache>
    800022c4:	00004097          	auipc	ra,0x4
    800022c8:	efe080e7          	jalr	-258(ra) # 800061c2 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800022cc:	00015497          	auipc	s1,0x15
    800022d0:	e844b483          	ld	s1,-380(s1) # 80017150 <bcache+0x82b8>
    800022d4:	00015797          	auipc	a5,0x15
    800022d8:	e2c78793          	addi	a5,a5,-468 # 80017100 <bcache+0x8268>
    800022dc:	02f48f63          	beq	s1,a5,8000231a <bread+0x70>
    800022e0:	873e                	mv	a4,a5
    800022e2:	a021                	j	800022ea <bread+0x40>
    800022e4:	68a4                	ld	s1,80(s1)
    800022e6:	02e48a63          	beq	s1,a4,8000231a <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800022ea:	449c                	lw	a5,8(s1)
    800022ec:	ff279ce3          	bne	a5,s2,800022e4 <bread+0x3a>
    800022f0:	44dc                	lw	a5,12(s1)
    800022f2:	ff3799e3          	bne	a5,s3,800022e4 <bread+0x3a>
      b->refcnt++;
    800022f6:	40bc                	lw	a5,64(s1)
    800022f8:	2785                	addiw	a5,a5,1
    800022fa:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800022fc:	0000d517          	auipc	a0,0xd
    80002300:	b9c50513          	addi	a0,a0,-1124 # 8000ee98 <bcache>
    80002304:	00004097          	auipc	ra,0x4
    80002308:	f6e080e7          	jalr	-146(ra) # 80006272 <release>
      acquiresleep(&b->lock);
    8000230c:	01048513          	addi	a0,s1,16
    80002310:	00001097          	auipc	ra,0x1
    80002314:	464080e7          	jalr	1124(ra) # 80003774 <acquiresleep>
      return b;
    80002318:	a8b9                	j	80002376 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000231a:	00015497          	auipc	s1,0x15
    8000231e:	e2e4b483          	ld	s1,-466(s1) # 80017148 <bcache+0x82b0>
    80002322:	00015797          	auipc	a5,0x15
    80002326:	dde78793          	addi	a5,a5,-546 # 80017100 <bcache+0x8268>
    8000232a:	00f48863          	beq	s1,a5,8000233a <bread+0x90>
    8000232e:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002330:	40bc                	lw	a5,64(s1)
    80002332:	cf81                	beqz	a5,8000234a <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002334:	64a4                	ld	s1,72(s1)
    80002336:	fee49de3          	bne	s1,a4,80002330 <bread+0x86>
  panic("bget: no buffers");
    8000233a:	00006517          	auipc	a0,0x6
    8000233e:	05650513          	addi	a0,a0,86 # 80008390 <etext+0x390>
    80002342:	00004097          	auipc	ra,0x4
    80002346:	900080e7          	jalr	-1792(ra) # 80005c42 <panic>
      b->dev = dev;
    8000234a:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    8000234e:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002352:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002356:	4785                	li	a5,1
    80002358:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000235a:	0000d517          	auipc	a0,0xd
    8000235e:	b3e50513          	addi	a0,a0,-1218 # 8000ee98 <bcache>
    80002362:	00004097          	auipc	ra,0x4
    80002366:	f10080e7          	jalr	-240(ra) # 80006272 <release>
      acquiresleep(&b->lock);
    8000236a:	01048513          	addi	a0,s1,16
    8000236e:	00001097          	auipc	ra,0x1
    80002372:	406080e7          	jalr	1030(ra) # 80003774 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002376:	409c                	lw	a5,0(s1)
    80002378:	cb89                	beqz	a5,8000238a <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000237a:	8526                	mv	a0,s1
    8000237c:	70a2                	ld	ra,40(sp)
    8000237e:	7402                	ld	s0,32(sp)
    80002380:	64e2                	ld	s1,24(sp)
    80002382:	6942                	ld	s2,16(sp)
    80002384:	69a2                	ld	s3,8(sp)
    80002386:	6145                	addi	sp,sp,48
    80002388:	8082                	ret
    virtio_disk_rw(b, 0);
    8000238a:	4581                	li	a1,0
    8000238c:	8526                	mv	a0,s1
    8000238e:	00003097          	auipc	ra,0x3
    80002392:	020080e7          	jalr	32(ra) # 800053ae <virtio_disk_rw>
    b->valid = 1;
    80002396:	4785                	li	a5,1
    80002398:	c09c                	sw	a5,0(s1)
  return b;
    8000239a:	b7c5                	j	8000237a <bread+0xd0>

000000008000239c <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    8000239c:	1101                	addi	sp,sp,-32
    8000239e:	ec06                	sd	ra,24(sp)
    800023a0:	e822                	sd	s0,16(sp)
    800023a2:	e426                	sd	s1,8(sp)
    800023a4:	1000                	addi	s0,sp,32
    800023a6:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800023a8:	0541                	addi	a0,a0,16
    800023aa:	00001097          	auipc	ra,0x1
    800023ae:	464080e7          	jalr	1124(ra) # 8000380e <holdingsleep>
    800023b2:	cd01                	beqz	a0,800023ca <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800023b4:	4585                	li	a1,1
    800023b6:	8526                	mv	a0,s1
    800023b8:	00003097          	auipc	ra,0x3
    800023bc:	ff6080e7          	jalr	-10(ra) # 800053ae <virtio_disk_rw>
}
    800023c0:	60e2                	ld	ra,24(sp)
    800023c2:	6442                	ld	s0,16(sp)
    800023c4:	64a2                	ld	s1,8(sp)
    800023c6:	6105                	addi	sp,sp,32
    800023c8:	8082                	ret
    panic("bwrite");
    800023ca:	00006517          	auipc	a0,0x6
    800023ce:	fde50513          	addi	a0,a0,-34 # 800083a8 <etext+0x3a8>
    800023d2:	00004097          	auipc	ra,0x4
    800023d6:	870080e7          	jalr	-1936(ra) # 80005c42 <panic>

00000000800023da <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800023da:	1101                	addi	sp,sp,-32
    800023dc:	ec06                	sd	ra,24(sp)
    800023de:	e822                	sd	s0,16(sp)
    800023e0:	e426                	sd	s1,8(sp)
    800023e2:	e04a                	sd	s2,0(sp)
    800023e4:	1000                	addi	s0,sp,32
    800023e6:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800023e8:	01050913          	addi	s2,a0,16
    800023ec:	854a                	mv	a0,s2
    800023ee:	00001097          	auipc	ra,0x1
    800023f2:	420080e7          	jalr	1056(ra) # 8000380e <holdingsleep>
    800023f6:	c535                	beqz	a0,80002462 <brelse+0x88>
    panic("brelse");

  releasesleep(&b->lock);
    800023f8:	854a                	mv	a0,s2
    800023fa:	00001097          	auipc	ra,0x1
    800023fe:	3d0080e7          	jalr	976(ra) # 800037ca <releasesleep>

  acquire(&bcache.lock);
    80002402:	0000d517          	auipc	a0,0xd
    80002406:	a9650513          	addi	a0,a0,-1386 # 8000ee98 <bcache>
    8000240a:	00004097          	auipc	ra,0x4
    8000240e:	db8080e7          	jalr	-584(ra) # 800061c2 <acquire>
  b->refcnt--;
    80002412:	40bc                	lw	a5,64(s1)
    80002414:	37fd                	addiw	a5,a5,-1
    80002416:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002418:	e79d                	bnez	a5,80002446 <brelse+0x6c>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000241a:	68b8                	ld	a4,80(s1)
    8000241c:	64bc                	ld	a5,72(s1)
    8000241e:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002420:	68b8                	ld	a4,80(s1)
    80002422:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002424:	00015797          	auipc	a5,0x15
    80002428:	a7478793          	addi	a5,a5,-1420 # 80016e98 <bcache+0x8000>
    8000242c:	2b87b703          	ld	a4,696(a5)
    80002430:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002432:	00015717          	auipc	a4,0x15
    80002436:	cce70713          	addi	a4,a4,-818 # 80017100 <bcache+0x8268>
    8000243a:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000243c:	2b87b703          	ld	a4,696(a5)
    80002440:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002442:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002446:	0000d517          	auipc	a0,0xd
    8000244a:	a5250513          	addi	a0,a0,-1454 # 8000ee98 <bcache>
    8000244e:	00004097          	auipc	ra,0x4
    80002452:	e24080e7          	jalr	-476(ra) # 80006272 <release>
}
    80002456:	60e2                	ld	ra,24(sp)
    80002458:	6442                	ld	s0,16(sp)
    8000245a:	64a2                	ld	s1,8(sp)
    8000245c:	6902                	ld	s2,0(sp)
    8000245e:	6105                	addi	sp,sp,32
    80002460:	8082                	ret
    panic("brelse");
    80002462:	00006517          	auipc	a0,0x6
    80002466:	f4e50513          	addi	a0,a0,-178 # 800083b0 <etext+0x3b0>
    8000246a:	00003097          	auipc	ra,0x3
    8000246e:	7d8080e7          	jalr	2008(ra) # 80005c42 <panic>

0000000080002472 <bpin>:

void
bpin(struct buf *b) {
    80002472:	1101                	addi	sp,sp,-32
    80002474:	ec06                	sd	ra,24(sp)
    80002476:	e822                	sd	s0,16(sp)
    80002478:	e426                	sd	s1,8(sp)
    8000247a:	1000                	addi	s0,sp,32
    8000247c:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000247e:	0000d517          	auipc	a0,0xd
    80002482:	a1a50513          	addi	a0,a0,-1510 # 8000ee98 <bcache>
    80002486:	00004097          	auipc	ra,0x4
    8000248a:	d3c080e7          	jalr	-708(ra) # 800061c2 <acquire>
  b->refcnt++;
    8000248e:	40bc                	lw	a5,64(s1)
    80002490:	2785                	addiw	a5,a5,1
    80002492:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002494:	0000d517          	auipc	a0,0xd
    80002498:	a0450513          	addi	a0,a0,-1532 # 8000ee98 <bcache>
    8000249c:	00004097          	auipc	ra,0x4
    800024a0:	dd6080e7          	jalr	-554(ra) # 80006272 <release>
}
    800024a4:	60e2                	ld	ra,24(sp)
    800024a6:	6442                	ld	s0,16(sp)
    800024a8:	64a2                	ld	s1,8(sp)
    800024aa:	6105                	addi	sp,sp,32
    800024ac:	8082                	ret

00000000800024ae <bunpin>:

void
bunpin(struct buf *b) {
    800024ae:	1101                	addi	sp,sp,-32
    800024b0:	ec06                	sd	ra,24(sp)
    800024b2:	e822                	sd	s0,16(sp)
    800024b4:	e426                	sd	s1,8(sp)
    800024b6:	1000                	addi	s0,sp,32
    800024b8:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800024ba:	0000d517          	auipc	a0,0xd
    800024be:	9de50513          	addi	a0,a0,-1570 # 8000ee98 <bcache>
    800024c2:	00004097          	auipc	ra,0x4
    800024c6:	d00080e7          	jalr	-768(ra) # 800061c2 <acquire>
  b->refcnt--;
    800024ca:	40bc                	lw	a5,64(s1)
    800024cc:	37fd                	addiw	a5,a5,-1
    800024ce:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800024d0:	0000d517          	auipc	a0,0xd
    800024d4:	9c850513          	addi	a0,a0,-1592 # 8000ee98 <bcache>
    800024d8:	00004097          	auipc	ra,0x4
    800024dc:	d9a080e7          	jalr	-614(ra) # 80006272 <release>
}
    800024e0:	60e2                	ld	ra,24(sp)
    800024e2:	6442                	ld	s0,16(sp)
    800024e4:	64a2                	ld	s1,8(sp)
    800024e6:	6105                	addi	sp,sp,32
    800024e8:	8082                	ret

00000000800024ea <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800024ea:	1101                	addi	sp,sp,-32
    800024ec:	ec06                	sd	ra,24(sp)
    800024ee:	e822                	sd	s0,16(sp)
    800024f0:	e426                	sd	s1,8(sp)
    800024f2:	e04a                	sd	s2,0(sp)
    800024f4:	1000                	addi	s0,sp,32
    800024f6:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800024f8:	00d5d79b          	srliw	a5,a1,0xd
    800024fc:	00015597          	auipc	a1,0x15
    80002500:	0785a583          	lw	a1,120(a1) # 80017574 <sb+0x1c>
    80002504:	9dbd                	addw	a1,a1,a5
    80002506:	00000097          	auipc	ra,0x0
    8000250a:	da4080e7          	jalr	-604(ra) # 800022aa <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000250e:	0074f713          	andi	a4,s1,7
    80002512:	4785                	li	a5,1
    80002514:	00e797bb          	sllw	a5,a5,a4
  bi = b % BPB;
    80002518:	14ce                	slli	s1,s1,0x33
  if((bp->data[bi/8] & m) == 0)
    8000251a:	90d9                	srli	s1,s1,0x36
    8000251c:	00950733          	add	a4,a0,s1
    80002520:	05874703          	lbu	a4,88(a4)
    80002524:	00e7f6b3          	and	a3,a5,a4
    80002528:	c69d                	beqz	a3,80002556 <bfree+0x6c>
    8000252a:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000252c:	94aa                	add	s1,s1,a0
    8000252e:	fff7c793          	not	a5,a5
    80002532:	8f7d                	and	a4,a4,a5
    80002534:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002538:	00001097          	auipc	ra,0x1
    8000253c:	11e080e7          	jalr	286(ra) # 80003656 <log_write>
  brelse(bp);
    80002540:	854a                	mv	a0,s2
    80002542:	00000097          	auipc	ra,0x0
    80002546:	e98080e7          	jalr	-360(ra) # 800023da <brelse>
}
    8000254a:	60e2                	ld	ra,24(sp)
    8000254c:	6442                	ld	s0,16(sp)
    8000254e:	64a2                	ld	s1,8(sp)
    80002550:	6902                	ld	s2,0(sp)
    80002552:	6105                	addi	sp,sp,32
    80002554:	8082                	ret
    panic("freeing free block");
    80002556:	00006517          	auipc	a0,0x6
    8000255a:	e6250513          	addi	a0,a0,-414 # 800083b8 <etext+0x3b8>
    8000255e:	00003097          	auipc	ra,0x3
    80002562:	6e4080e7          	jalr	1764(ra) # 80005c42 <panic>

0000000080002566 <balloc>:
{
    80002566:	715d                	addi	sp,sp,-80
    80002568:	e486                	sd	ra,72(sp)
    8000256a:	e0a2                	sd	s0,64(sp)
    8000256c:	fc26                	sd	s1,56(sp)
    8000256e:	f84a                	sd	s2,48(sp)
    80002570:	f44e                	sd	s3,40(sp)
    80002572:	f052                	sd	s4,32(sp)
    80002574:	ec56                	sd	s5,24(sp)
    80002576:	e85a                	sd	s6,16(sp)
    80002578:	e45e                	sd	s7,8(sp)
    8000257a:	e062                	sd	s8,0(sp)
    8000257c:	0880                	addi	s0,sp,80
  for(b = 0; b < sb.size; b += BPB){
    8000257e:	00015797          	auipc	a5,0x15
    80002582:	fde7a783          	lw	a5,-34(a5) # 8001755c <sb+0x4>
    80002586:	c7c1                	beqz	a5,8000260e <balloc+0xa8>
    80002588:	8baa                	mv	s7,a0
    8000258a:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000258c:	00015b17          	auipc	s6,0x15
    80002590:	fccb0b13          	addi	s6,s6,-52 # 80017558 <sb>
      m = 1 << (bi % 8);
    80002594:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002596:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002598:	6c09                	lui	s8,0x2
    8000259a:	a821                	j	800025b2 <balloc+0x4c>
    brelse(bp);
    8000259c:	854a                	mv	a0,s2
    8000259e:	00000097          	auipc	ra,0x0
    800025a2:	e3c080e7          	jalr	-452(ra) # 800023da <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800025a6:	015c0abb          	addw	s5,s8,s5
    800025aa:	004b2783          	lw	a5,4(s6)
    800025ae:	06faf063          	bgeu	s5,a5,8000260e <balloc+0xa8>
    bp = bread(dev, BBLOCK(b, sb));
    800025b2:	41fad79b          	sraiw	a5,s5,0x1f
    800025b6:	0137d79b          	srliw	a5,a5,0x13
    800025ba:	015787bb          	addw	a5,a5,s5
    800025be:	40d7d79b          	sraiw	a5,a5,0xd
    800025c2:	01cb2583          	lw	a1,28(s6)
    800025c6:	9dbd                	addw	a1,a1,a5
    800025c8:	855e                	mv	a0,s7
    800025ca:	00000097          	auipc	ra,0x0
    800025ce:	ce0080e7          	jalr	-800(ra) # 800022aa <bread>
    800025d2:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800025d4:	004b2503          	lw	a0,4(s6)
    800025d8:	84d6                	mv	s1,s5
    800025da:	4701                	li	a4,0
    800025dc:	fca4f0e3          	bgeu	s1,a0,8000259c <balloc+0x36>
      m = 1 << (bi % 8);
    800025e0:	00777693          	andi	a3,a4,7
    800025e4:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800025e8:	41f7579b          	sraiw	a5,a4,0x1f
    800025ec:	01d7d79b          	srliw	a5,a5,0x1d
    800025f0:	9fb9                	addw	a5,a5,a4
    800025f2:	4037d79b          	sraiw	a5,a5,0x3
    800025f6:	00f90633          	add	a2,s2,a5
    800025fa:	05864603          	lbu	a2,88(a2)
    800025fe:	00c6f5b3          	and	a1,a3,a2
    80002602:	cd91                	beqz	a1,8000261e <balloc+0xb8>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002604:	2705                	addiw	a4,a4,1
    80002606:	2485                	addiw	s1,s1,1
    80002608:	fd471ae3          	bne	a4,s4,800025dc <balloc+0x76>
    8000260c:	bf41                	j	8000259c <balloc+0x36>
  panic("balloc: out of blocks");
    8000260e:	00006517          	auipc	a0,0x6
    80002612:	dc250513          	addi	a0,a0,-574 # 800083d0 <etext+0x3d0>
    80002616:	00003097          	auipc	ra,0x3
    8000261a:	62c080e7          	jalr	1580(ra) # 80005c42 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000261e:	97ca                	add	a5,a5,s2
    80002620:	8e55                	or	a2,a2,a3
    80002622:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002626:	854a                	mv	a0,s2
    80002628:	00001097          	auipc	ra,0x1
    8000262c:	02e080e7          	jalr	46(ra) # 80003656 <log_write>
        brelse(bp);
    80002630:	854a                	mv	a0,s2
    80002632:	00000097          	auipc	ra,0x0
    80002636:	da8080e7          	jalr	-600(ra) # 800023da <brelse>
  bp = bread(dev, bno);
    8000263a:	85a6                	mv	a1,s1
    8000263c:	855e                	mv	a0,s7
    8000263e:	00000097          	auipc	ra,0x0
    80002642:	c6c080e7          	jalr	-916(ra) # 800022aa <bread>
    80002646:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002648:	40000613          	li	a2,1024
    8000264c:	4581                	li	a1,0
    8000264e:	05850513          	addi	a0,a0,88
    80002652:	ffffe097          	auipc	ra,0xffffe
    80002656:	b28080e7          	jalr	-1240(ra) # 8000017a <memset>
  log_write(bp);
    8000265a:	854a                	mv	a0,s2
    8000265c:	00001097          	auipc	ra,0x1
    80002660:	ffa080e7          	jalr	-6(ra) # 80003656 <log_write>
  brelse(bp);
    80002664:	854a                	mv	a0,s2
    80002666:	00000097          	auipc	ra,0x0
    8000266a:	d74080e7          	jalr	-652(ra) # 800023da <brelse>
}
    8000266e:	8526                	mv	a0,s1
    80002670:	60a6                	ld	ra,72(sp)
    80002672:	6406                	ld	s0,64(sp)
    80002674:	74e2                	ld	s1,56(sp)
    80002676:	7942                	ld	s2,48(sp)
    80002678:	79a2                	ld	s3,40(sp)
    8000267a:	7a02                	ld	s4,32(sp)
    8000267c:	6ae2                	ld	s5,24(sp)
    8000267e:	6b42                	ld	s6,16(sp)
    80002680:	6ba2                	ld	s7,8(sp)
    80002682:	6c02                	ld	s8,0(sp)
    80002684:	6161                	addi	sp,sp,80
    80002686:	8082                	ret

0000000080002688 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    80002688:	7179                	addi	sp,sp,-48
    8000268a:	f406                	sd	ra,40(sp)
    8000268c:	f022                	sd	s0,32(sp)
    8000268e:	ec26                	sd	s1,24(sp)
    80002690:	e84a                	sd	s2,16(sp)
    80002692:	e44e                	sd	s3,8(sp)
    80002694:	1800                	addi	s0,sp,48
    80002696:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002698:	47ad                	li	a5,11
    8000269a:	04b7fd63          	bgeu	a5,a1,800026f4 <bmap+0x6c>
    8000269e:	e052                	sd	s4,0(sp)
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    800026a0:	ff45849b          	addiw	s1,a1,-12

  if(bn < NINDIRECT){
    800026a4:	0ff00793          	li	a5,255
    800026a8:	0897ef63          	bltu	a5,s1,80002746 <bmap+0xbe>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    800026ac:	08052583          	lw	a1,128(a0)
    800026b0:	c5a5                	beqz	a1,80002718 <bmap+0x90>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    800026b2:	00092503          	lw	a0,0(s2)
    800026b6:	00000097          	auipc	ra,0x0
    800026ba:	bf4080e7          	jalr	-1036(ra) # 800022aa <bread>
    800026be:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800026c0:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800026c4:	02049713          	slli	a4,s1,0x20
    800026c8:	01e75593          	srli	a1,a4,0x1e
    800026cc:	00b784b3          	add	s1,a5,a1
    800026d0:	0004a983          	lw	s3,0(s1)
    800026d4:	04098b63          	beqz	s3,8000272a <bmap+0xa2>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    800026d8:	8552                	mv	a0,s4
    800026da:	00000097          	auipc	ra,0x0
    800026de:	d00080e7          	jalr	-768(ra) # 800023da <brelse>
    return addr;
    800026e2:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    800026e4:	854e                	mv	a0,s3
    800026e6:	70a2                	ld	ra,40(sp)
    800026e8:	7402                	ld	s0,32(sp)
    800026ea:	64e2                	ld	s1,24(sp)
    800026ec:	6942                	ld	s2,16(sp)
    800026ee:	69a2                	ld	s3,8(sp)
    800026f0:	6145                	addi	sp,sp,48
    800026f2:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    800026f4:	02059793          	slli	a5,a1,0x20
    800026f8:	01e7d593          	srli	a1,a5,0x1e
    800026fc:	00b504b3          	add	s1,a0,a1
    80002700:	0504a983          	lw	s3,80(s1)
    80002704:	fe0990e3          	bnez	s3,800026e4 <bmap+0x5c>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80002708:	4108                	lw	a0,0(a0)
    8000270a:	00000097          	auipc	ra,0x0
    8000270e:	e5c080e7          	jalr	-420(ra) # 80002566 <balloc>
    80002712:	89aa                	mv	s3,a0
    80002714:	c8a8                	sw	a0,80(s1)
    80002716:	b7f9                	j	800026e4 <bmap+0x5c>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80002718:	4108                	lw	a0,0(a0)
    8000271a:	00000097          	auipc	ra,0x0
    8000271e:	e4c080e7          	jalr	-436(ra) # 80002566 <balloc>
    80002722:	85aa                	mv	a1,a0
    80002724:	08a92023          	sw	a0,128(s2)
    80002728:	b769                	j	800026b2 <bmap+0x2a>
      a[bn] = addr = balloc(ip->dev);
    8000272a:	00092503          	lw	a0,0(s2)
    8000272e:	00000097          	auipc	ra,0x0
    80002732:	e38080e7          	jalr	-456(ra) # 80002566 <balloc>
    80002736:	89aa                	mv	s3,a0
    80002738:	c088                	sw	a0,0(s1)
      log_write(bp);
    8000273a:	8552                	mv	a0,s4
    8000273c:	00001097          	auipc	ra,0x1
    80002740:	f1a080e7          	jalr	-230(ra) # 80003656 <log_write>
    80002744:	bf51                	j	800026d8 <bmap+0x50>
  panic("bmap: out of range");
    80002746:	00006517          	auipc	a0,0x6
    8000274a:	ca250513          	addi	a0,a0,-862 # 800083e8 <etext+0x3e8>
    8000274e:	00003097          	auipc	ra,0x3
    80002752:	4f4080e7          	jalr	1268(ra) # 80005c42 <panic>

0000000080002756 <iget>:
{
    80002756:	7179                	addi	sp,sp,-48
    80002758:	f406                	sd	ra,40(sp)
    8000275a:	f022                	sd	s0,32(sp)
    8000275c:	ec26                	sd	s1,24(sp)
    8000275e:	e84a                	sd	s2,16(sp)
    80002760:	e44e                	sd	s3,8(sp)
    80002762:	e052                	sd	s4,0(sp)
    80002764:	1800                	addi	s0,sp,48
    80002766:	89aa                	mv	s3,a0
    80002768:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    8000276a:	00015517          	auipc	a0,0x15
    8000276e:	e0e50513          	addi	a0,a0,-498 # 80017578 <itable>
    80002772:	00004097          	auipc	ra,0x4
    80002776:	a50080e7          	jalr	-1456(ra) # 800061c2 <acquire>
  empty = 0;
    8000277a:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000277c:	00015497          	auipc	s1,0x15
    80002780:	e1448493          	addi	s1,s1,-492 # 80017590 <itable+0x18>
    80002784:	00017697          	auipc	a3,0x17
    80002788:	89c68693          	addi	a3,a3,-1892 # 80019020 <log>
    8000278c:	a039                	j	8000279a <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000278e:	02090b63          	beqz	s2,800027c4 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002792:	08848493          	addi	s1,s1,136
    80002796:	02d48a63          	beq	s1,a3,800027ca <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    8000279a:	449c                	lw	a5,8(s1)
    8000279c:	fef059e3          	blez	a5,8000278e <iget+0x38>
    800027a0:	4098                	lw	a4,0(s1)
    800027a2:	ff3716e3          	bne	a4,s3,8000278e <iget+0x38>
    800027a6:	40d8                	lw	a4,4(s1)
    800027a8:	ff4713e3          	bne	a4,s4,8000278e <iget+0x38>
      ip->ref++;
    800027ac:	2785                	addiw	a5,a5,1
    800027ae:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800027b0:	00015517          	auipc	a0,0x15
    800027b4:	dc850513          	addi	a0,a0,-568 # 80017578 <itable>
    800027b8:	00004097          	auipc	ra,0x4
    800027bc:	aba080e7          	jalr	-1350(ra) # 80006272 <release>
      return ip;
    800027c0:	8926                	mv	s2,s1
    800027c2:	a03d                	j	800027f0 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800027c4:	f7f9                	bnez	a5,80002792 <iget+0x3c>
      empty = ip;
    800027c6:	8926                	mv	s2,s1
    800027c8:	b7e9                	j	80002792 <iget+0x3c>
  if(empty == 0)
    800027ca:	02090c63          	beqz	s2,80002802 <iget+0xac>
  ip->dev = dev;
    800027ce:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800027d2:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800027d6:	4785                	li	a5,1
    800027d8:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800027dc:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800027e0:	00015517          	auipc	a0,0x15
    800027e4:	d9850513          	addi	a0,a0,-616 # 80017578 <itable>
    800027e8:	00004097          	auipc	ra,0x4
    800027ec:	a8a080e7          	jalr	-1398(ra) # 80006272 <release>
}
    800027f0:	854a                	mv	a0,s2
    800027f2:	70a2                	ld	ra,40(sp)
    800027f4:	7402                	ld	s0,32(sp)
    800027f6:	64e2                	ld	s1,24(sp)
    800027f8:	6942                	ld	s2,16(sp)
    800027fa:	69a2                	ld	s3,8(sp)
    800027fc:	6a02                	ld	s4,0(sp)
    800027fe:	6145                	addi	sp,sp,48
    80002800:	8082                	ret
    panic("iget: no inodes");
    80002802:	00006517          	auipc	a0,0x6
    80002806:	bfe50513          	addi	a0,a0,-1026 # 80008400 <etext+0x400>
    8000280a:	00003097          	auipc	ra,0x3
    8000280e:	438080e7          	jalr	1080(ra) # 80005c42 <panic>

0000000080002812 <fsinit>:
fsinit(int dev) {
    80002812:	7179                	addi	sp,sp,-48
    80002814:	f406                	sd	ra,40(sp)
    80002816:	f022                	sd	s0,32(sp)
    80002818:	ec26                	sd	s1,24(sp)
    8000281a:	e84a                	sd	s2,16(sp)
    8000281c:	e44e                	sd	s3,8(sp)
    8000281e:	1800                	addi	s0,sp,48
    80002820:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002822:	4585                	li	a1,1
    80002824:	00000097          	auipc	ra,0x0
    80002828:	a86080e7          	jalr	-1402(ra) # 800022aa <bread>
    8000282c:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    8000282e:	00015997          	auipc	s3,0x15
    80002832:	d2a98993          	addi	s3,s3,-726 # 80017558 <sb>
    80002836:	02000613          	li	a2,32
    8000283a:	05850593          	addi	a1,a0,88
    8000283e:	854e                	mv	a0,s3
    80002840:	ffffe097          	auipc	ra,0xffffe
    80002844:	99e080e7          	jalr	-1634(ra) # 800001de <memmove>
  brelse(bp);
    80002848:	8526                	mv	a0,s1
    8000284a:	00000097          	auipc	ra,0x0
    8000284e:	b90080e7          	jalr	-1136(ra) # 800023da <brelse>
  if(sb.magic != FSMAGIC)
    80002852:	0009a703          	lw	a4,0(s3)
    80002856:	102037b7          	lui	a5,0x10203
    8000285a:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    8000285e:	02f71263          	bne	a4,a5,80002882 <fsinit+0x70>
  initlog(dev, &sb);
    80002862:	00015597          	auipc	a1,0x15
    80002866:	cf658593          	addi	a1,a1,-778 # 80017558 <sb>
    8000286a:	854a                	mv	a0,s2
    8000286c:	00001097          	auipc	ra,0x1
    80002870:	b74080e7          	jalr	-1164(ra) # 800033e0 <initlog>
}
    80002874:	70a2                	ld	ra,40(sp)
    80002876:	7402                	ld	s0,32(sp)
    80002878:	64e2                	ld	s1,24(sp)
    8000287a:	6942                	ld	s2,16(sp)
    8000287c:	69a2                	ld	s3,8(sp)
    8000287e:	6145                	addi	sp,sp,48
    80002880:	8082                	ret
    panic("invalid file system");
    80002882:	00006517          	auipc	a0,0x6
    80002886:	b8e50513          	addi	a0,a0,-1138 # 80008410 <etext+0x410>
    8000288a:	00003097          	auipc	ra,0x3
    8000288e:	3b8080e7          	jalr	952(ra) # 80005c42 <panic>

0000000080002892 <iinit>:
{
    80002892:	7179                	addi	sp,sp,-48
    80002894:	f406                	sd	ra,40(sp)
    80002896:	f022                	sd	s0,32(sp)
    80002898:	ec26                	sd	s1,24(sp)
    8000289a:	e84a                	sd	s2,16(sp)
    8000289c:	e44e                	sd	s3,8(sp)
    8000289e:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800028a0:	00006597          	auipc	a1,0x6
    800028a4:	b8858593          	addi	a1,a1,-1144 # 80008428 <etext+0x428>
    800028a8:	00015517          	auipc	a0,0x15
    800028ac:	cd050513          	addi	a0,a0,-816 # 80017578 <itable>
    800028b0:	00004097          	auipc	ra,0x4
    800028b4:	87e080e7          	jalr	-1922(ra) # 8000612e <initlock>
  for(i = 0; i < NINODE; i++) {
    800028b8:	00015497          	auipc	s1,0x15
    800028bc:	ce848493          	addi	s1,s1,-792 # 800175a0 <itable+0x28>
    800028c0:	00016997          	auipc	s3,0x16
    800028c4:	77098993          	addi	s3,s3,1904 # 80019030 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800028c8:	00006917          	auipc	s2,0x6
    800028cc:	b6890913          	addi	s2,s2,-1176 # 80008430 <etext+0x430>
    800028d0:	85ca                	mv	a1,s2
    800028d2:	8526                	mv	a0,s1
    800028d4:	00001097          	auipc	ra,0x1
    800028d8:	e66080e7          	jalr	-410(ra) # 8000373a <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800028dc:	08848493          	addi	s1,s1,136
    800028e0:	ff3498e3          	bne	s1,s3,800028d0 <iinit+0x3e>
}
    800028e4:	70a2                	ld	ra,40(sp)
    800028e6:	7402                	ld	s0,32(sp)
    800028e8:	64e2                	ld	s1,24(sp)
    800028ea:	6942                	ld	s2,16(sp)
    800028ec:	69a2                	ld	s3,8(sp)
    800028ee:	6145                	addi	sp,sp,48
    800028f0:	8082                	ret

00000000800028f2 <ialloc>:
{
    800028f2:	7139                	addi	sp,sp,-64
    800028f4:	fc06                	sd	ra,56(sp)
    800028f6:	f822                	sd	s0,48(sp)
    800028f8:	f426                	sd	s1,40(sp)
    800028fa:	f04a                	sd	s2,32(sp)
    800028fc:	ec4e                	sd	s3,24(sp)
    800028fe:	e852                	sd	s4,16(sp)
    80002900:	e456                	sd	s5,8(sp)
    80002902:	e05a                	sd	s6,0(sp)
    80002904:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002906:	00015717          	auipc	a4,0x15
    8000290a:	c5e72703          	lw	a4,-930(a4) # 80017564 <sb+0xc>
    8000290e:	4785                	li	a5,1
    80002910:	04e7f863          	bgeu	a5,a4,80002960 <ialloc+0x6e>
    80002914:	8aaa                	mv	s5,a0
    80002916:	8b2e                	mv	s6,a1
    80002918:	893e                	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
    8000291a:	00015a17          	auipc	s4,0x15
    8000291e:	c3ea0a13          	addi	s4,s4,-962 # 80017558 <sb>
    80002922:	00495593          	srli	a1,s2,0x4
    80002926:	018a2783          	lw	a5,24(s4)
    8000292a:	9dbd                	addw	a1,a1,a5
    8000292c:	8556                	mv	a0,s5
    8000292e:	00000097          	auipc	ra,0x0
    80002932:	97c080e7          	jalr	-1668(ra) # 800022aa <bread>
    80002936:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002938:	05850993          	addi	s3,a0,88
    8000293c:	00f97793          	andi	a5,s2,15
    80002940:	079a                	slli	a5,a5,0x6
    80002942:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002944:	00099783          	lh	a5,0(s3)
    80002948:	c785                	beqz	a5,80002970 <ialloc+0x7e>
    brelse(bp);
    8000294a:	00000097          	auipc	ra,0x0
    8000294e:	a90080e7          	jalr	-1392(ra) # 800023da <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002952:	0905                	addi	s2,s2,1
    80002954:	00ca2703          	lw	a4,12(s4)
    80002958:	0009079b          	sext.w	a5,s2
    8000295c:	fce7e3e3          	bltu	a5,a4,80002922 <ialloc+0x30>
  panic("ialloc: no inodes");
    80002960:	00006517          	auipc	a0,0x6
    80002964:	ad850513          	addi	a0,a0,-1320 # 80008438 <etext+0x438>
    80002968:	00003097          	auipc	ra,0x3
    8000296c:	2da080e7          	jalr	730(ra) # 80005c42 <panic>
      memset(dip, 0, sizeof(*dip));
    80002970:	04000613          	li	a2,64
    80002974:	4581                	li	a1,0
    80002976:	854e                	mv	a0,s3
    80002978:	ffffe097          	auipc	ra,0xffffe
    8000297c:	802080e7          	jalr	-2046(ra) # 8000017a <memset>
      dip->type = type;
    80002980:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002984:	8526                	mv	a0,s1
    80002986:	00001097          	auipc	ra,0x1
    8000298a:	cd0080e7          	jalr	-816(ra) # 80003656 <log_write>
      brelse(bp);
    8000298e:	8526                	mv	a0,s1
    80002990:	00000097          	auipc	ra,0x0
    80002994:	a4a080e7          	jalr	-1462(ra) # 800023da <brelse>
      return iget(dev, inum);
    80002998:	0009059b          	sext.w	a1,s2
    8000299c:	8556                	mv	a0,s5
    8000299e:	00000097          	auipc	ra,0x0
    800029a2:	db8080e7          	jalr	-584(ra) # 80002756 <iget>
}
    800029a6:	70e2                	ld	ra,56(sp)
    800029a8:	7442                	ld	s0,48(sp)
    800029aa:	74a2                	ld	s1,40(sp)
    800029ac:	7902                	ld	s2,32(sp)
    800029ae:	69e2                	ld	s3,24(sp)
    800029b0:	6a42                	ld	s4,16(sp)
    800029b2:	6aa2                	ld	s5,8(sp)
    800029b4:	6b02                	ld	s6,0(sp)
    800029b6:	6121                	addi	sp,sp,64
    800029b8:	8082                	ret

00000000800029ba <iupdate>:
{
    800029ba:	1101                	addi	sp,sp,-32
    800029bc:	ec06                	sd	ra,24(sp)
    800029be:	e822                	sd	s0,16(sp)
    800029c0:	e426                	sd	s1,8(sp)
    800029c2:	e04a                	sd	s2,0(sp)
    800029c4:	1000                	addi	s0,sp,32
    800029c6:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800029c8:	415c                	lw	a5,4(a0)
    800029ca:	0047d79b          	srliw	a5,a5,0x4
    800029ce:	00015597          	auipc	a1,0x15
    800029d2:	ba25a583          	lw	a1,-1118(a1) # 80017570 <sb+0x18>
    800029d6:	9dbd                	addw	a1,a1,a5
    800029d8:	4108                	lw	a0,0(a0)
    800029da:	00000097          	auipc	ra,0x0
    800029de:	8d0080e7          	jalr	-1840(ra) # 800022aa <bread>
    800029e2:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    800029e4:	05850793          	addi	a5,a0,88
    800029e8:	40d8                	lw	a4,4(s1)
    800029ea:	8b3d                	andi	a4,a4,15
    800029ec:	071a                	slli	a4,a4,0x6
    800029ee:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    800029f0:	04449703          	lh	a4,68(s1)
    800029f4:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    800029f8:	04649703          	lh	a4,70(s1)
    800029fc:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002a00:	04849703          	lh	a4,72(s1)
    80002a04:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002a08:	04a49703          	lh	a4,74(s1)
    80002a0c:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002a10:	44f8                	lw	a4,76(s1)
    80002a12:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002a14:	03400613          	li	a2,52
    80002a18:	05048593          	addi	a1,s1,80
    80002a1c:	00c78513          	addi	a0,a5,12
    80002a20:	ffffd097          	auipc	ra,0xffffd
    80002a24:	7be080e7          	jalr	1982(ra) # 800001de <memmove>
  log_write(bp);
    80002a28:	854a                	mv	a0,s2
    80002a2a:	00001097          	auipc	ra,0x1
    80002a2e:	c2c080e7          	jalr	-980(ra) # 80003656 <log_write>
  brelse(bp);
    80002a32:	854a                	mv	a0,s2
    80002a34:	00000097          	auipc	ra,0x0
    80002a38:	9a6080e7          	jalr	-1626(ra) # 800023da <brelse>
}
    80002a3c:	60e2                	ld	ra,24(sp)
    80002a3e:	6442                	ld	s0,16(sp)
    80002a40:	64a2                	ld	s1,8(sp)
    80002a42:	6902                	ld	s2,0(sp)
    80002a44:	6105                	addi	sp,sp,32
    80002a46:	8082                	ret

0000000080002a48 <idup>:
{
    80002a48:	1101                	addi	sp,sp,-32
    80002a4a:	ec06                	sd	ra,24(sp)
    80002a4c:	e822                	sd	s0,16(sp)
    80002a4e:	e426                	sd	s1,8(sp)
    80002a50:	1000                	addi	s0,sp,32
    80002a52:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002a54:	00015517          	auipc	a0,0x15
    80002a58:	b2450513          	addi	a0,a0,-1244 # 80017578 <itable>
    80002a5c:	00003097          	auipc	ra,0x3
    80002a60:	766080e7          	jalr	1894(ra) # 800061c2 <acquire>
  ip->ref++;
    80002a64:	449c                	lw	a5,8(s1)
    80002a66:	2785                	addiw	a5,a5,1
    80002a68:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002a6a:	00015517          	auipc	a0,0x15
    80002a6e:	b0e50513          	addi	a0,a0,-1266 # 80017578 <itable>
    80002a72:	00004097          	auipc	ra,0x4
    80002a76:	800080e7          	jalr	-2048(ra) # 80006272 <release>
}
    80002a7a:	8526                	mv	a0,s1
    80002a7c:	60e2                	ld	ra,24(sp)
    80002a7e:	6442                	ld	s0,16(sp)
    80002a80:	64a2                	ld	s1,8(sp)
    80002a82:	6105                	addi	sp,sp,32
    80002a84:	8082                	ret

0000000080002a86 <ilock>:
{
    80002a86:	1101                	addi	sp,sp,-32
    80002a88:	ec06                	sd	ra,24(sp)
    80002a8a:	e822                	sd	s0,16(sp)
    80002a8c:	e426                	sd	s1,8(sp)
    80002a8e:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002a90:	c10d                	beqz	a0,80002ab2 <ilock+0x2c>
    80002a92:	84aa                	mv	s1,a0
    80002a94:	451c                	lw	a5,8(a0)
    80002a96:	00f05e63          	blez	a5,80002ab2 <ilock+0x2c>
  acquiresleep(&ip->lock);
    80002a9a:	0541                	addi	a0,a0,16
    80002a9c:	00001097          	auipc	ra,0x1
    80002aa0:	cd8080e7          	jalr	-808(ra) # 80003774 <acquiresleep>
  if(ip->valid == 0){
    80002aa4:	40bc                	lw	a5,64(s1)
    80002aa6:	cf99                	beqz	a5,80002ac4 <ilock+0x3e>
}
    80002aa8:	60e2                	ld	ra,24(sp)
    80002aaa:	6442                	ld	s0,16(sp)
    80002aac:	64a2                	ld	s1,8(sp)
    80002aae:	6105                	addi	sp,sp,32
    80002ab0:	8082                	ret
    80002ab2:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80002ab4:	00006517          	auipc	a0,0x6
    80002ab8:	99c50513          	addi	a0,a0,-1636 # 80008450 <etext+0x450>
    80002abc:	00003097          	auipc	ra,0x3
    80002ac0:	186080e7          	jalr	390(ra) # 80005c42 <panic>
    80002ac4:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002ac6:	40dc                	lw	a5,4(s1)
    80002ac8:	0047d79b          	srliw	a5,a5,0x4
    80002acc:	00015597          	auipc	a1,0x15
    80002ad0:	aa45a583          	lw	a1,-1372(a1) # 80017570 <sb+0x18>
    80002ad4:	9dbd                	addw	a1,a1,a5
    80002ad6:	4088                	lw	a0,0(s1)
    80002ad8:	fffff097          	auipc	ra,0xfffff
    80002adc:	7d2080e7          	jalr	2002(ra) # 800022aa <bread>
    80002ae0:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002ae2:	05850593          	addi	a1,a0,88
    80002ae6:	40dc                	lw	a5,4(s1)
    80002ae8:	8bbd                	andi	a5,a5,15
    80002aea:	079a                	slli	a5,a5,0x6
    80002aec:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002aee:	00059783          	lh	a5,0(a1)
    80002af2:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002af6:	00259783          	lh	a5,2(a1)
    80002afa:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002afe:	00459783          	lh	a5,4(a1)
    80002b02:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002b06:	00659783          	lh	a5,6(a1)
    80002b0a:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002b0e:	459c                	lw	a5,8(a1)
    80002b10:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002b12:	03400613          	li	a2,52
    80002b16:	05b1                	addi	a1,a1,12
    80002b18:	05048513          	addi	a0,s1,80
    80002b1c:	ffffd097          	auipc	ra,0xffffd
    80002b20:	6c2080e7          	jalr	1730(ra) # 800001de <memmove>
    brelse(bp);
    80002b24:	854a                	mv	a0,s2
    80002b26:	00000097          	auipc	ra,0x0
    80002b2a:	8b4080e7          	jalr	-1868(ra) # 800023da <brelse>
    ip->valid = 1;
    80002b2e:	4785                	li	a5,1
    80002b30:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002b32:	04449783          	lh	a5,68(s1)
    80002b36:	c399                	beqz	a5,80002b3c <ilock+0xb6>
    80002b38:	6902                	ld	s2,0(sp)
    80002b3a:	b7bd                	j	80002aa8 <ilock+0x22>
      panic("ilock: no type");
    80002b3c:	00006517          	auipc	a0,0x6
    80002b40:	91c50513          	addi	a0,a0,-1764 # 80008458 <etext+0x458>
    80002b44:	00003097          	auipc	ra,0x3
    80002b48:	0fe080e7          	jalr	254(ra) # 80005c42 <panic>

0000000080002b4c <iunlock>:
{
    80002b4c:	1101                	addi	sp,sp,-32
    80002b4e:	ec06                	sd	ra,24(sp)
    80002b50:	e822                	sd	s0,16(sp)
    80002b52:	e426                	sd	s1,8(sp)
    80002b54:	e04a                	sd	s2,0(sp)
    80002b56:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002b58:	c905                	beqz	a0,80002b88 <iunlock+0x3c>
    80002b5a:	84aa                	mv	s1,a0
    80002b5c:	01050913          	addi	s2,a0,16
    80002b60:	854a                	mv	a0,s2
    80002b62:	00001097          	auipc	ra,0x1
    80002b66:	cac080e7          	jalr	-852(ra) # 8000380e <holdingsleep>
    80002b6a:	cd19                	beqz	a0,80002b88 <iunlock+0x3c>
    80002b6c:	449c                	lw	a5,8(s1)
    80002b6e:	00f05d63          	blez	a5,80002b88 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002b72:	854a                	mv	a0,s2
    80002b74:	00001097          	auipc	ra,0x1
    80002b78:	c56080e7          	jalr	-938(ra) # 800037ca <releasesleep>
}
    80002b7c:	60e2                	ld	ra,24(sp)
    80002b7e:	6442                	ld	s0,16(sp)
    80002b80:	64a2                	ld	s1,8(sp)
    80002b82:	6902                	ld	s2,0(sp)
    80002b84:	6105                	addi	sp,sp,32
    80002b86:	8082                	ret
    panic("iunlock");
    80002b88:	00006517          	auipc	a0,0x6
    80002b8c:	8e050513          	addi	a0,a0,-1824 # 80008468 <etext+0x468>
    80002b90:	00003097          	auipc	ra,0x3
    80002b94:	0b2080e7          	jalr	178(ra) # 80005c42 <panic>

0000000080002b98 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002b98:	7179                	addi	sp,sp,-48
    80002b9a:	f406                	sd	ra,40(sp)
    80002b9c:	f022                	sd	s0,32(sp)
    80002b9e:	ec26                	sd	s1,24(sp)
    80002ba0:	e84a                	sd	s2,16(sp)
    80002ba2:	e44e                	sd	s3,8(sp)
    80002ba4:	1800                	addi	s0,sp,48
    80002ba6:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002ba8:	05050493          	addi	s1,a0,80
    80002bac:	08050913          	addi	s2,a0,128
    80002bb0:	a021                	j	80002bb8 <itrunc+0x20>
    80002bb2:	0491                	addi	s1,s1,4
    80002bb4:	01248d63          	beq	s1,s2,80002bce <itrunc+0x36>
    if(ip->addrs[i]){
    80002bb8:	408c                	lw	a1,0(s1)
    80002bba:	dde5                	beqz	a1,80002bb2 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80002bbc:	0009a503          	lw	a0,0(s3)
    80002bc0:	00000097          	auipc	ra,0x0
    80002bc4:	92a080e7          	jalr	-1750(ra) # 800024ea <bfree>
      ip->addrs[i] = 0;
    80002bc8:	0004a023          	sw	zero,0(s1)
    80002bcc:	b7dd                	j	80002bb2 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002bce:	0809a583          	lw	a1,128(s3)
    80002bd2:	ed99                	bnez	a1,80002bf0 <itrunc+0x58>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002bd4:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002bd8:	854e                	mv	a0,s3
    80002bda:	00000097          	auipc	ra,0x0
    80002bde:	de0080e7          	jalr	-544(ra) # 800029ba <iupdate>
}
    80002be2:	70a2                	ld	ra,40(sp)
    80002be4:	7402                	ld	s0,32(sp)
    80002be6:	64e2                	ld	s1,24(sp)
    80002be8:	6942                	ld	s2,16(sp)
    80002bea:	69a2                	ld	s3,8(sp)
    80002bec:	6145                	addi	sp,sp,48
    80002bee:	8082                	ret
    80002bf0:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002bf2:	0009a503          	lw	a0,0(s3)
    80002bf6:	fffff097          	auipc	ra,0xfffff
    80002bfa:	6b4080e7          	jalr	1716(ra) # 800022aa <bread>
    80002bfe:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002c00:	05850493          	addi	s1,a0,88
    80002c04:	45850913          	addi	s2,a0,1112
    80002c08:	a021                	j	80002c10 <itrunc+0x78>
    80002c0a:	0491                	addi	s1,s1,4
    80002c0c:	01248b63          	beq	s1,s2,80002c22 <itrunc+0x8a>
      if(a[j])
    80002c10:	408c                	lw	a1,0(s1)
    80002c12:	dde5                	beqz	a1,80002c0a <itrunc+0x72>
        bfree(ip->dev, a[j]);
    80002c14:	0009a503          	lw	a0,0(s3)
    80002c18:	00000097          	auipc	ra,0x0
    80002c1c:	8d2080e7          	jalr	-1838(ra) # 800024ea <bfree>
    80002c20:	b7ed                	j	80002c0a <itrunc+0x72>
    brelse(bp);
    80002c22:	8552                	mv	a0,s4
    80002c24:	fffff097          	auipc	ra,0xfffff
    80002c28:	7b6080e7          	jalr	1974(ra) # 800023da <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002c2c:	0809a583          	lw	a1,128(s3)
    80002c30:	0009a503          	lw	a0,0(s3)
    80002c34:	00000097          	auipc	ra,0x0
    80002c38:	8b6080e7          	jalr	-1866(ra) # 800024ea <bfree>
    ip->addrs[NDIRECT] = 0;
    80002c3c:	0809a023          	sw	zero,128(s3)
    80002c40:	6a02                	ld	s4,0(sp)
    80002c42:	bf49                	j	80002bd4 <itrunc+0x3c>

0000000080002c44 <iput>:
{
    80002c44:	1101                	addi	sp,sp,-32
    80002c46:	ec06                	sd	ra,24(sp)
    80002c48:	e822                	sd	s0,16(sp)
    80002c4a:	e426                	sd	s1,8(sp)
    80002c4c:	1000                	addi	s0,sp,32
    80002c4e:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002c50:	00015517          	auipc	a0,0x15
    80002c54:	92850513          	addi	a0,a0,-1752 # 80017578 <itable>
    80002c58:	00003097          	auipc	ra,0x3
    80002c5c:	56a080e7          	jalr	1386(ra) # 800061c2 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002c60:	4498                	lw	a4,8(s1)
    80002c62:	4785                	li	a5,1
    80002c64:	02f70263          	beq	a4,a5,80002c88 <iput+0x44>
  ip->ref--;
    80002c68:	449c                	lw	a5,8(s1)
    80002c6a:	37fd                	addiw	a5,a5,-1
    80002c6c:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002c6e:	00015517          	auipc	a0,0x15
    80002c72:	90a50513          	addi	a0,a0,-1782 # 80017578 <itable>
    80002c76:	00003097          	auipc	ra,0x3
    80002c7a:	5fc080e7          	jalr	1532(ra) # 80006272 <release>
}
    80002c7e:	60e2                	ld	ra,24(sp)
    80002c80:	6442                	ld	s0,16(sp)
    80002c82:	64a2                	ld	s1,8(sp)
    80002c84:	6105                	addi	sp,sp,32
    80002c86:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002c88:	40bc                	lw	a5,64(s1)
    80002c8a:	dff9                	beqz	a5,80002c68 <iput+0x24>
    80002c8c:	04a49783          	lh	a5,74(s1)
    80002c90:	ffe1                	bnez	a5,80002c68 <iput+0x24>
    80002c92:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80002c94:	01048913          	addi	s2,s1,16
    80002c98:	854a                	mv	a0,s2
    80002c9a:	00001097          	auipc	ra,0x1
    80002c9e:	ada080e7          	jalr	-1318(ra) # 80003774 <acquiresleep>
    release(&itable.lock);
    80002ca2:	00015517          	auipc	a0,0x15
    80002ca6:	8d650513          	addi	a0,a0,-1834 # 80017578 <itable>
    80002caa:	00003097          	auipc	ra,0x3
    80002cae:	5c8080e7          	jalr	1480(ra) # 80006272 <release>
    itrunc(ip);
    80002cb2:	8526                	mv	a0,s1
    80002cb4:	00000097          	auipc	ra,0x0
    80002cb8:	ee4080e7          	jalr	-284(ra) # 80002b98 <itrunc>
    ip->type = 0;
    80002cbc:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002cc0:	8526                	mv	a0,s1
    80002cc2:	00000097          	auipc	ra,0x0
    80002cc6:	cf8080e7          	jalr	-776(ra) # 800029ba <iupdate>
    ip->valid = 0;
    80002cca:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002cce:	854a                	mv	a0,s2
    80002cd0:	00001097          	auipc	ra,0x1
    80002cd4:	afa080e7          	jalr	-1286(ra) # 800037ca <releasesleep>
    acquire(&itable.lock);
    80002cd8:	00015517          	auipc	a0,0x15
    80002cdc:	8a050513          	addi	a0,a0,-1888 # 80017578 <itable>
    80002ce0:	00003097          	auipc	ra,0x3
    80002ce4:	4e2080e7          	jalr	1250(ra) # 800061c2 <acquire>
    80002ce8:	6902                	ld	s2,0(sp)
    80002cea:	bfbd                	j	80002c68 <iput+0x24>

0000000080002cec <iunlockput>:
{
    80002cec:	1101                	addi	sp,sp,-32
    80002cee:	ec06                	sd	ra,24(sp)
    80002cf0:	e822                	sd	s0,16(sp)
    80002cf2:	e426                	sd	s1,8(sp)
    80002cf4:	1000                	addi	s0,sp,32
    80002cf6:	84aa                	mv	s1,a0
  iunlock(ip);
    80002cf8:	00000097          	auipc	ra,0x0
    80002cfc:	e54080e7          	jalr	-428(ra) # 80002b4c <iunlock>
  iput(ip);
    80002d00:	8526                	mv	a0,s1
    80002d02:	00000097          	auipc	ra,0x0
    80002d06:	f42080e7          	jalr	-190(ra) # 80002c44 <iput>
}
    80002d0a:	60e2                	ld	ra,24(sp)
    80002d0c:	6442                	ld	s0,16(sp)
    80002d0e:	64a2                	ld	s1,8(sp)
    80002d10:	6105                	addi	sp,sp,32
    80002d12:	8082                	ret

0000000080002d14 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002d14:	1141                	addi	sp,sp,-16
    80002d16:	e406                	sd	ra,8(sp)
    80002d18:	e022                	sd	s0,0(sp)
    80002d1a:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002d1c:	411c                	lw	a5,0(a0)
    80002d1e:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002d20:	415c                	lw	a5,4(a0)
    80002d22:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002d24:	04451783          	lh	a5,68(a0)
    80002d28:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002d2c:	04a51783          	lh	a5,74(a0)
    80002d30:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002d34:	04c56783          	lwu	a5,76(a0)
    80002d38:	e99c                	sd	a5,16(a1)
}
    80002d3a:	60a2                	ld	ra,8(sp)
    80002d3c:	6402                	ld	s0,0(sp)
    80002d3e:	0141                	addi	sp,sp,16
    80002d40:	8082                	ret

0000000080002d42 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002d42:	457c                	lw	a5,76(a0)
    80002d44:	0ed7ea63          	bltu	a5,a3,80002e38 <readi+0xf6>
{
    80002d48:	7159                	addi	sp,sp,-112
    80002d4a:	f486                	sd	ra,104(sp)
    80002d4c:	f0a2                	sd	s0,96(sp)
    80002d4e:	eca6                	sd	s1,88(sp)
    80002d50:	fc56                	sd	s5,56(sp)
    80002d52:	f85a                	sd	s6,48(sp)
    80002d54:	f45e                	sd	s7,40(sp)
    80002d56:	ec66                	sd	s9,24(sp)
    80002d58:	1880                	addi	s0,sp,112
    80002d5a:	8baa                	mv	s7,a0
    80002d5c:	8cae                	mv	s9,a1
    80002d5e:	8ab2                	mv	s5,a2
    80002d60:	84b6                	mv	s1,a3
    80002d62:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002d64:	9f35                	addw	a4,a4,a3
    return 0;
    80002d66:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002d68:	0ad76763          	bltu	a4,a3,80002e16 <readi+0xd4>
    80002d6c:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80002d6e:	00e7f463          	bgeu	a5,a4,80002d76 <readi+0x34>
    n = ip->size - off;
    80002d72:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002d76:	0a0b0f63          	beqz	s6,80002e34 <readi+0xf2>
    80002d7a:	e8ca                	sd	s2,80(sp)
    80002d7c:	e0d2                	sd	s4,64(sp)
    80002d7e:	f062                	sd	s8,32(sp)
    80002d80:	e86a                	sd	s10,16(sp)
    80002d82:	e46e                	sd	s11,8(sp)
    80002d84:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002d86:	40000d93          	li	s11,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002d8a:	5d7d                	li	s10,-1
    80002d8c:	a82d                	j	80002dc6 <readi+0x84>
    80002d8e:	020a1c13          	slli	s8,s4,0x20
    80002d92:	020c5c13          	srli	s8,s8,0x20
    80002d96:	05890613          	addi	a2,s2,88
    80002d9a:	86e2                	mv	a3,s8
    80002d9c:	963e                	add	a2,a2,a5
    80002d9e:	85d6                	mv	a1,s5
    80002da0:	8566                	mv	a0,s9
    80002da2:	fffff097          	auipc	ra,0xfffff
    80002da6:	b36080e7          	jalr	-1226(ra) # 800018d8 <either_copyout>
    80002daa:	05a50963          	beq	a0,s10,80002dfc <readi+0xba>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002dae:	854a                	mv	a0,s2
    80002db0:	fffff097          	auipc	ra,0xfffff
    80002db4:	62a080e7          	jalr	1578(ra) # 800023da <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002db8:	013a09bb          	addw	s3,s4,s3
    80002dbc:	009a04bb          	addw	s1,s4,s1
    80002dc0:	9ae2                	add	s5,s5,s8
    80002dc2:	0769f363          	bgeu	s3,s6,80002e28 <readi+0xe6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002dc6:	000ba903          	lw	s2,0(s7)
    80002dca:	00a4d59b          	srliw	a1,s1,0xa
    80002dce:	855e                	mv	a0,s7
    80002dd0:	00000097          	auipc	ra,0x0
    80002dd4:	8b8080e7          	jalr	-1864(ra) # 80002688 <bmap>
    80002dd8:	85aa                	mv	a1,a0
    80002dda:	854a                	mv	a0,s2
    80002ddc:	fffff097          	auipc	ra,0xfffff
    80002de0:	4ce080e7          	jalr	1230(ra) # 800022aa <bread>
    80002de4:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002de6:	3ff4f793          	andi	a5,s1,1023
    80002dea:	40fd873b          	subw	a4,s11,a5
    80002dee:	413b06bb          	subw	a3,s6,s3
    80002df2:	8a3a                	mv	s4,a4
    80002df4:	f8e6fde3          	bgeu	a3,a4,80002d8e <readi+0x4c>
    80002df8:	8a36                	mv	s4,a3
    80002dfa:	bf51                	j	80002d8e <readi+0x4c>
      brelse(bp);
    80002dfc:	854a                	mv	a0,s2
    80002dfe:	fffff097          	auipc	ra,0xfffff
    80002e02:	5dc080e7          	jalr	1500(ra) # 800023da <brelse>
      tot = -1;
    80002e06:	59fd                	li	s3,-1
      break;
    80002e08:	6946                	ld	s2,80(sp)
    80002e0a:	6a06                	ld	s4,64(sp)
    80002e0c:	7c02                	ld	s8,32(sp)
    80002e0e:	6d42                	ld	s10,16(sp)
    80002e10:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80002e12:	854e                	mv	a0,s3
    80002e14:	69a6                	ld	s3,72(sp)
}
    80002e16:	70a6                	ld	ra,104(sp)
    80002e18:	7406                	ld	s0,96(sp)
    80002e1a:	64e6                	ld	s1,88(sp)
    80002e1c:	7ae2                	ld	s5,56(sp)
    80002e1e:	7b42                	ld	s6,48(sp)
    80002e20:	7ba2                	ld	s7,40(sp)
    80002e22:	6ce2                	ld	s9,24(sp)
    80002e24:	6165                	addi	sp,sp,112
    80002e26:	8082                	ret
    80002e28:	6946                	ld	s2,80(sp)
    80002e2a:	6a06                	ld	s4,64(sp)
    80002e2c:	7c02                	ld	s8,32(sp)
    80002e2e:	6d42                	ld	s10,16(sp)
    80002e30:	6da2                	ld	s11,8(sp)
    80002e32:	b7c5                	j	80002e12 <readi+0xd0>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002e34:	89da                	mv	s3,s6
    80002e36:	bff1                	j	80002e12 <readi+0xd0>
    return 0;
    80002e38:	4501                	li	a0,0
}
    80002e3a:	8082                	ret

0000000080002e3c <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002e3c:	457c                	lw	a5,76(a0)
    80002e3e:	10d7e963          	bltu	a5,a3,80002f50 <writei+0x114>
{
    80002e42:	7159                	addi	sp,sp,-112
    80002e44:	f486                	sd	ra,104(sp)
    80002e46:	f0a2                	sd	s0,96(sp)
    80002e48:	e8ca                	sd	s2,80(sp)
    80002e4a:	fc56                	sd	s5,56(sp)
    80002e4c:	f45e                	sd	s7,40(sp)
    80002e4e:	f062                	sd	s8,32(sp)
    80002e50:	ec66                	sd	s9,24(sp)
    80002e52:	1880                	addi	s0,sp,112
    80002e54:	8baa                	mv	s7,a0
    80002e56:	8cae                	mv	s9,a1
    80002e58:	8ab2                	mv	s5,a2
    80002e5a:	8936                	mv	s2,a3
    80002e5c:	8c3a                	mv	s8,a4
  if(off > ip->size || off + n < off)
    80002e5e:	00e687bb          	addw	a5,a3,a4
    80002e62:	0ed7e963          	bltu	a5,a3,80002f54 <writei+0x118>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002e66:	00043737          	lui	a4,0x43
    80002e6a:	0ef76763          	bltu	a4,a5,80002f58 <writei+0x11c>
    80002e6e:	e0d2                	sd	s4,64(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002e70:	0c0c0863          	beqz	s8,80002f40 <writei+0x104>
    80002e74:	eca6                	sd	s1,88(sp)
    80002e76:	e4ce                	sd	s3,72(sp)
    80002e78:	f85a                	sd	s6,48(sp)
    80002e7a:	e86a                	sd	s10,16(sp)
    80002e7c:	e46e                	sd	s11,8(sp)
    80002e7e:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002e80:	40000d93          	li	s11,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002e84:	5d7d                	li	s10,-1
    80002e86:	a091                	j	80002eca <writei+0x8e>
    80002e88:	02099b13          	slli	s6,s3,0x20
    80002e8c:	020b5b13          	srli	s6,s6,0x20
    80002e90:	05848513          	addi	a0,s1,88
    80002e94:	86da                	mv	a3,s6
    80002e96:	8656                	mv	a2,s5
    80002e98:	85e6                	mv	a1,s9
    80002e9a:	953e                	add	a0,a0,a5
    80002e9c:	fffff097          	auipc	ra,0xfffff
    80002ea0:	a92080e7          	jalr	-1390(ra) # 8000192e <either_copyin>
    80002ea4:	05a50e63          	beq	a0,s10,80002f00 <writei+0xc4>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002ea8:	8526                	mv	a0,s1
    80002eaa:	00000097          	auipc	ra,0x0
    80002eae:	7ac080e7          	jalr	1964(ra) # 80003656 <log_write>
    brelse(bp);
    80002eb2:	8526                	mv	a0,s1
    80002eb4:	fffff097          	auipc	ra,0xfffff
    80002eb8:	526080e7          	jalr	1318(ra) # 800023da <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002ebc:	01498a3b          	addw	s4,s3,s4
    80002ec0:	0129893b          	addw	s2,s3,s2
    80002ec4:	9ada                	add	s5,s5,s6
    80002ec6:	058a7263          	bgeu	s4,s8,80002f0a <writei+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002eca:	000ba483          	lw	s1,0(s7)
    80002ece:	00a9559b          	srliw	a1,s2,0xa
    80002ed2:	855e                	mv	a0,s7
    80002ed4:	fffff097          	auipc	ra,0xfffff
    80002ed8:	7b4080e7          	jalr	1972(ra) # 80002688 <bmap>
    80002edc:	85aa                	mv	a1,a0
    80002ede:	8526                	mv	a0,s1
    80002ee0:	fffff097          	auipc	ra,0xfffff
    80002ee4:	3ca080e7          	jalr	970(ra) # 800022aa <bread>
    80002ee8:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002eea:	3ff97793          	andi	a5,s2,1023
    80002eee:	40fd873b          	subw	a4,s11,a5
    80002ef2:	414c06bb          	subw	a3,s8,s4
    80002ef6:	89ba                	mv	s3,a4
    80002ef8:	f8e6f8e3          	bgeu	a3,a4,80002e88 <writei+0x4c>
    80002efc:	89b6                	mv	s3,a3
    80002efe:	b769                	j	80002e88 <writei+0x4c>
      brelse(bp);
    80002f00:	8526                	mv	a0,s1
    80002f02:	fffff097          	auipc	ra,0xfffff
    80002f06:	4d8080e7          	jalr	1240(ra) # 800023da <brelse>
  }

  if(off > ip->size)
    80002f0a:	04cba783          	lw	a5,76(s7)
    80002f0e:	0327fb63          	bgeu	a5,s2,80002f44 <writei+0x108>
    ip->size = off;
    80002f12:	052ba623          	sw	s2,76(s7)
    80002f16:	64e6                	ld	s1,88(sp)
    80002f18:	69a6                	ld	s3,72(sp)
    80002f1a:	7b42                	ld	s6,48(sp)
    80002f1c:	6d42                	ld	s10,16(sp)
    80002f1e:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002f20:	855e                	mv	a0,s7
    80002f22:	00000097          	auipc	ra,0x0
    80002f26:	a98080e7          	jalr	-1384(ra) # 800029ba <iupdate>

  return tot;
    80002f2a:	8552                	mv	a0,s4
    80002f2c:	6a06                	ld	s4,64(sp)
}
    80002f2e:	70a6                	ld	ra,104(sp)
    80002f30:	7406                	ld	s0,96(sp)
    80002f32:	6946                	ld	s2,80(sp)
    80002f34:	7ae2                	ld	s5,56(sp)
    80002f36:	7ba2                	ld	s7,40(sp)
    80002f38:	7c02                	ld	s8,32(sp)
    80002f3a:	6ce2                	ld	s9,24(sp)
    80002f3c:	6165                	addi	sp,sp,112
    80002f3e:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002f40:	8a62                	mv	s4,s8
    80002f42:	bff9                	j	80002f20 <writei+0xe4>
    80002f44:	64e6                	ld	s1,88(sp)
    80002f46:	69a6                	ld	s3,72(sp)
    80002f48:	7b42                	ld	s6,48(sp)
    80002f4a:	6d42                	ld	s10,16(sp)
    80002f4c:	6da2                	ld	s11,8(sp)
    80002f4e:	bfc9                	j	80002f20 <writei+0xe4>
    return -1;
    80002f50:	557d                	li	a0,-1
}
    80002f52:	8082                	ret
    return -1;
    80002f54:	557d                	li	a0,-1
    80002f56:	bfe1                	j	80002f2e <writei+0xf2>
    return -1;
    80002f58:	557d                	li	a0,-1
    80002f5a:	bfd1                	j	80002f2e <writei+0xf2>

0000000080002f5c <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002f5c:	1141                	addi	sp,sp,-16
    80002f5e:	e406                	sd	ra,8(sp)
    80002f60:	e022                	sd	s0,0(sp)
    80002f62:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002f64:	4639                	li	a2,14
    80002f66:	ffffd097          	auipc	ra,0xffffd
    80002f6a:	2f0080e7          	jalr	752(ra) # 80000256 <strncmp>
}
    80002f6e:	60a2                	ld	ra,8(sp)
    80002f70:	6402                	ld	s0,0(sp)
    80002f72:	0141                	addi	sp,sp,16
    80002f74:	8082                	ret

0000000080002f76 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80002f76:	711d                	addi	sp,sp,-96
    80002f78:	ec86                	sd	ra,88(sp)
    80002f7a:	e8a2                	sd	s0,80(sp)
    80002f7c:	e4a6                	sd	s1,72(sp)
    80002f7e:	e0ca                	sd	s2,64(sp)
    80002f80:	fc4e                	sd	s3,56(sp)
    80002f82:	f852                	sd	s4,48(sp)
    80002f84:	f456                	sd	s5,40(sp)
    80002f86:	f05a                	sd	s6,32(sp)
    80002f88:	ec5e                	sd	s7,24(sp)
    80002f8a:	1080                	addi	s0,sp,96
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80002f8c:	04451703          	lh	a4,68(a0)
    80002f90:	4785                	li	a5,1
    80002f92:	00f71f63          	bne	a4,a5,80002fb0 <dirlookup+0x3a>
    80002f96:	892a                	mv	s2,a0
    80002f98:	8aae                	mv	s5,a1
    80002f9a:	8bb2                	mv	s7,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80002f9c:	457c                	lw	a5,76(a0)
    80002f9e:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002fa0:	fa040a13          	addi	s4,s0,-96
    80002fa4:	49c1                	li	s3,16
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
    80002fa6:	fa240b13          	addi	s6,s0,-94
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002faa:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002fac:	e79d                	bnez	a5,80002fda <dirlookup+0x64>
    80002fae:	a88d                	j	80003020 <dirlookup+0xaa>
    panic("dirlookup not DIR");
    80002fb0:	00005517          	auipc	a0,0x5
    80002fb4:	4c050513          	addi	a0,a0,1216 # 80008470 <etext+0x470>
    80002fb8:	00003097          	auipc	ra,0x3
    80002fbc:	c8a080e7          	jalr	-886(ra) # 80005c42 <panic>
      panic("dirlookup read");
    80002fc0:	00005517          	auipc	a0,0x5
    80002fc4:	4c850513          	addi	a0,a0,1224 # 80008488 <etext+0x488>
    80002fc8:	00003097          	auipc	ra,0x3
    80002fcc:	c7a080e7          	jalr	-902(ra) # 80005c42 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002fd0:	24c1                	addiw	s1,s1,16
    80002fd2:	04c92783          	lw	a5,76(s2)
    80002fd6:	04f4f463          	bgeu	s1,a5,8000301e <dirlookup+0xa8>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002fda:	874e                	mv	a4,s3
    80002fdc:	86a6                	mv	a3,s1
    80002fde:	8652                	mv	a2,s4
    80002fe0:	4581                	li	a1,0
    80002fe2:	854a                	mv	a0,s2
    80002fe4:	00000097          	auipc	ra,0x0
    80002fe8:	d5e080e7          	jalr	-674(ra) # 80002d42 <readi>
    80002fec:	fd351ae3          	bne	a0,s3,80002fc0 <dirlookup+0x4a>
    if(de.inum == 0)
    80002ff0:	fa045783          	lhu	a5,-96(s0)
    80002ff4:	dff1                	beqz	a5,80002fd0 <dirlookup+0x5a>
    if(namecmp(name, de.name) == 0){
    80002ff6:	85da                	mv	a1,s6
    80002ff8:	8556                	mv	a0,s5
    80002ffa:	00000097          	auipc	ra,0x0
    80002ffe:	f62080e7          	jalr	-158(ra) # 80002f5c <namecmp>
    80003002:	f579                	bnez	a0,80002fd0 <dirlookup+0x5a>
      if(poff)
    80003004:	000b8463          	beqz	s7,8000300c <dirlookup+0x96>
        *poff = off;
    80003008:	009ba023          	sw	s1,0(s7)
      return iget(dp->dev, inum);
    8000300c:	fa045583          	lhu	a1,-96(s0)
    80003010:	00092503          	lw	a0,0(s2)
    80003014:	fffff097          	auipc	ra,0xfffff
    80003018:	742080e7          	jalr	1858(ra) # 80002756 <iget>
    8000301c:	a011                	j	80003020 <dirlookup+0xaa>
  return 0;
    8000301e:	4501                	li	a0,0
}
    80003020:	60e6                	ld	ra,88(sp)
    80003022:	6446                	ld	s0,80(sp)
    80003024:	64a6                	ld	s1,72(sp)
    80003026:	6906                	ld	s2,64(sp)
    80003028:	79e2                	ld	s3,56(sp)
    8000302a:	7a42                	ld	s4,48(sp)
    8000302c:	7aa2                	ld	s5,40(sp)
    8000302e:	7b02                	ld	s6,32(sp)
    80003030:	6be2                	ld	s7,24(sp)
    80003032:	6125                	addi	sp,sp,96
    80003034:	8082                	ret

0000000080003036 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003036:	711d                	addi	sp,sp,-96
    80003038:	ec86                	sd	ra,88(sp)
    8000303a:	e8a2                	sd	s0,80(sp)
    8000303c:	e4a6                	sd	s1,72(sp)
    8000303e:	e0ca                	sd	s2,64(sp)
    80003040:	fc4e                	sd	s3,56(sp)
    80003042:	f852                	sd	s4,48(sp)
    80003044:	f456                	sd	s5,40(sp)
    80003046:	f05a                	sd	s6,32(sp)
    80003048:	ec5e                	sd	s7,24(sp)
    8000304a:	e862                	sd	s8,16(sp)
    8000304c:	e466                	sd	s9,8(sp)
    8000304e:	e06a                	sd	s10,0(sp)
    80003050:	1080                	addi	s0,sp,96
    80003052:	84aa                	mv	s1,a0
    80003054:	8b2e                	mv	s6,a1
    80003056:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003058:	00054703          	lbu	a4,0(a0)
    8000305c:	02f00793          	li	a5,47
    80003060:	02f70363          	beq	a4,a5,80003086 <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003064:	ffffe097          	auipc	ra,0xffffe
    80003068:	e10080e7          	jalr	-496(ra) # 80000e74 <myproc>
    8000306c:	15053503          	ld	a0,336(a0)
    80003070:	00000097          	auipc	ra,0x0
    80003074:	9d8080e7          	jalr	-1576(ra) # 80002a48 <idup>
    80003078:	8a2a                	mv	s4,a0
  while(*path == '/')
    8000307a:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    8000307e:	4c35                	li	s8,13
    memmove(name, s, DIRSIZ);
    80003080:	4cb9                	li	s9,14

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003082:	4b85                	li	s7,1
    80003084:	a87d                	j	80003142 <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    80003086:	4585                	li	a1,1
    80003088:	852e                	mv	a0,a1
    8000308a:	fffff097          	auipc	ra,0xfffff
    8000308e:	6cc080e7          	jalr	1740(ra) # 80002756 <iget>
    80003092:	8a2a                	mv	s4,a0
    80003094:	b7dd                	j	8000307a <namex+0x44>
      iunlockput(ip);
    80003096:	8552                	mv	a0,s4
    80003098:	00000097          	auipc	ra,0x0
    8000309c:	c54080e7          	jalr	-940(ra) # 80002cec <iunlockput>
      return 0;
    800030a0:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800030a2:	8552                	mv	a0,s4
    800030a4:	60e6                	ld	ra,88(sp)
    800030a6:	6446                	ld	s0,80(sp)
    800030a8:	64a6                	ld	s1,72(sp)
    800030aa:	6906                	ld	s2,64(sp)
    800030ac:	79e2                	ld	s3,56(sp)
    800030ae:	7a42                	ld	s4,48(sp)
    800030b0:	7aa2                	ld	s5,40(sp)
    800030b2:	7b02                	ld	s6,32(sp)
    800030b4:	6be2                	ld	s7,24(sp)
    800030b6:	6c42                	ld	s8,16(sp)
    800030b8:	6ca2                	ld	s9,8(sp)
    800030ba:	6d02                	ld	s10,0(sp)
    800030bc:	6125                	addi	sp,sp,96
    800030be:	8082                	ret
      iunlock(ip);
    800030c0:	8552                	mv	a0,s4
    800030c2:	00000097          	auipc	ra,0x0
    800030c6:	a8a080e7          	jalr	-1398(ra) # 80002b4c <iunlock>
      return ip;
    800030ca:	bfe1                	j	800030a2 <namex+0x6c>
      iunlockput(ip);
    800030cc:	8552                	mv	a0,s4
    800030ce:	00000097          	auipc	ra,0x0
    800030d2:	c1e080e7          	jalr	-994(ra) # 80002cec <iunlockput>
      return 0;
    800030d6:	8a4e                	mv	s4,s3
    800030d8:	b7e9                	j	800030a2 <namex+0x6c>
  len = path - s;
    800030da:	40998633          	sub	a2,s3,s1
    800030de:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    800030e2:	09ac5863          	bge	s8,s10,80003172 <namex+0x13c>
    memmove(name, s, DIRSIZ);
    800030e6:	8666                	mv	a2,s9
    800030e8:	85a6                	mv	a1,s1
    800030ea:	8556                	mv	a0,s5
    800030ec:	ffffd097          	auipc	ra,0xffffd
    800030f0:	0f2080e7          	jalr	242(ra) # 800001de <memmove>
    800030f4:	84ce                	mv	s1,s3
  while(*path == '/')
    800030f6:	0004c783          	lbu	a5,0(s1)
    800030fa:	01279763          	bne	a5,s2,80003108 <namex+0xd2>
    path++;
    800030fe:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003100:	0004c783          	lbu	a5,0(s1)
    80003104:	ff278de3          	beq	a5,s2,800030fe <namex+0xc8>
    ilock(ip);
    80003108:	8552                	mv	a0,s4
    8000310a:	00000097          	auipc	ra,0x0
    8000310e:	97c080e7          	jalr	-1668(ra) # 80002a86 <ilock>
    if(ip->type != T_DIR){
    80003112:	044a1783          	lh	a5,68(s4)
    80003116:	f97790e3          	bne	a5,s7,80003096 <namex+0x60>
    if(nameiparent && *path == '\0'){
    8000311a:	000b0563          	beqz	s6,80003124 <namex+0xee>
    8000311e:	0004c783          	lbu	a5,0(s1)
    80003122:	dfd9                	beqz	a5,800030c0 <namex+0x8a>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003124:	4601                	li	a2,0
    80003126:	85d6                	mv	a1,s5
    80003128:	8552                	mv	a0,s4
    8000312a:	00000097          	auipc	ra,0x0
    8000312e:	e4c080e7          	jalr	-436(ra) # 80002f76 <dirlookup>
    80003132:	89aa                	mv	s3,a0
    80003134:	dd41                	beqz	a0,800030cc <namex+0x96>
    iunlockput(ip);
    80003136:	8552                	mv	a0,s4
    80003138:	00000097          	auipc	ra,0x0
    8000313c:	bb4080e7          	jalr	-1100(ra) # 80002cec <iunlockput>
    ip = next;
    80003140:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003142:	0004c783          	lbu	a5,0(s1)
    80003146:	01279763          	bne	a5,s2,80003154 <namex+0x11e>
    path++;
    8000314a:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000314c:	0004c783          	lbu	a5,0(s1)
    80003150:	ff278de3          	beq	a5,s2,8000314a <namex+0x114>
  if(*path == 0)
    80003154:	cb9d                	beqz	a5,8000318a <namex+0x154>
  while(*path != '/' && *path != 0)
    80003156:	0004c783          	lbu	a5,0(s1)
    8000315a:	89a6                	mv	s3,s1
  len = path - s;
    8000315c:	4d01                	li	s10,0
    8000315e:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80003160:	01278963          	beq	a5,s2,80003172 <namex+0x13c>
    80003164:	dbbd                	beqz	a5,800030da <namex+0xa4>
    path++;
    80003166:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80003168:	0009c783          	lbu	a5,0(s3)
    8000316c:	ff279ce3          	bne	a5,s2,80003164 <namex+0x12e>
    80003170:	b7ad                	j	800030da <namex+0xa4>
    memmove(name, s, len);
    80003172:	2601                	sext.w	a2,a2
    80003174:	85a6                	mv	a1,s1
    80003176:	8556                	mv	a0,s5
    80003178:	ffffd097          	auipc	ra,0xffffd
    8000317c:	066080e7          	jalr	102(ra) # 800001de <memmove>
    name[len] = 0;
    80003180:	9d56                	add	s10,s10,s5
    80003182:	000d0023          	sb	zero,0(s10)
    80003186:	84ce                	mv	s1,s3
    80003188:	b7bd                	j	800030f6 <namex+0xc0>
  if(nameiparent){
    8000318a:	f00b0ce3          	beqz	s6,800030a2 <namex+0x6c>
    iput(ip);
    8000318e:	8552                	mv	a0,s4
    80003190:	00000097          	auipc	ra,0x0
    80003194:	ab4080e7          	jalr	-1356(ra) # 80002c44 <iput>
    return 0;
    80003198:	4a01                	li	s4,0
    8000319a:	b721                	j	800030a2 <namex+0x6c>

000000008000319c <dirlink>:
{
    8000319c:	715d                	addi	sp,sp,-80
    8000319e:	e486                	sd	ra,72(sp)
    800031a0:	e0a2                	sd	s0,64(sp)
    800031a2:	f84a                	sd	s2,48(sp)
    800031a4:	ec56                	sd	s5,24(sp)
    800031a6:	e85a                	sd	s6,16(sp)
    800031a8:	0880                	addi	s0,sp,80
    800031aa:	892a                	mv	s2,a0
    800031ac:	8aae                	mv	s5,a1
    800031ae:	8b32                	mv	s6,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800031b0:	4601                	li	a2,0
    800031b2:	00000097          	auipc	ra,0x0
    800031b6:	dc4080e7          	jalr	-572(ra) # 80002f76 <dirlookup>
    800031ba:	e129                	bnez	a0,800031fc <dirlink+0x60>
    800031bc:	fc26                	sd	s1,56(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    800031be:	04c92483          	lw	s1,76(s2)
    800031c2:	cca9                	beqz	s1,8000321c <dirlink+0x80>
    800031c4:	f44e                	sd	s3,40(sp)
    800031c6:	f052                	sd	s4,32(sp)
    800031c8:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800031ca:	fb040a13          	addi	s4,s0,-80
    800031ce:	49c1                	li	s3,16
    800031d0:	874e                	mv	a4,s3
    800031d2:	86a6                	mv	a3,s1
    800031d4:	8652                	mv	a2,s4
    800031d6:	4581                	li	a1,0
    800031d8:	854a                	mv	a0,s2
    800031da:	00000097          	auipc	ra,0x0
    800031de:	b68080e7          	jalr	-1176(ra) # 80002d42 <readi>
    800031e2:	03351363          	bne	a0,s3,80003208 <dirlink+0x6c>
    if(de.inum == 0)
    800031e6:	fb045783          	lhu	a5,-80(s0)
    800031ea:	c79d                	beqz	a5,80003218 <dirlink+0x7c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800031ec:	24c1                	addiw	s1,s1,16
    800031ee:	04c92783          	lw	a5,76(s2)
    800031f2:	fcf4efe3          	bltu	s1,a5,800031d0 <dirlink+0x34>
    800031f6:	79a2                	ld	s3,40(sp)
    800031f8:	7a02                	ld	s4,32(sp)
    800031fa:	a00d                	j	8000321c <dirlink+0x80>
    iput(ip);
    800031fc:	00000097          	auipc	ra,0x0
    80003200:	a48080e7          	jalr	-1464(ra) # 80002c44 <iput>
    return -1;
    80003204:	557d                	li	a0,-1
    80003206:	a0a9                	j	80003250 <dirlink+0xb4>
      panic("dirlink read");
    80003208:	00005517          	auipc	a0,0x5
    8000320c:	29050513          	addi	a0,a0,656 # 80008498 <etext+0x498>
    80003210:	00003097          	auipc	ra,0x3
    80003214:	a32080e7          	jalr	-1486(ra) # 80005c42 <panic>
    80003218:	79a2                	ld	s3,40(sp)
    8000321a:	7a02                	ld	s4,32(sp)
  strncpy(de.name, name, DIRSIZ);
    8000321c:	4639                	li	a2,14
    8000321e:	85d6                	mv	a1,s5
    80003220:	fb240513          	addi	a0,s0,-78
    80003224:	ffffd097          	auipc	ra,0xffffd
    80003228:	06c080e7          	jalr	108(ra) # 80000290 <strncpy>
  de.inum = inum;
    8000322c:	fb641823          	sh	s6,-80(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003230:	4741                	li	a4,16
    80003232:	86a6                	mv	a3,s1
    80003234:	fb040613          	addi	a2,s0,-80
    80003238:	4581                	li	a1,0
    8000323a:	854a                	mv	a0,s2
    8000323c:	00000097          	auipc	ra,0x0
    80003240:	c00080e7          	jalr	-1024(ra) # 80002e3c <writei>
    80003244:	872a                	mv	a4,a0
    80003246:	47c1                	li	a5,16
  return 0;
    80003248:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000324a:	00f71a63          	bne	a4,a5,8000325e <dirlink+0xc2>
    8000324e:	74e2                	ld	s1,56(sp)
}
    80003250:	60a6                	ld	ra,72(sp)
    80003252:	6406                	ld	s0,64(sp)
    80003254:	7942                	ld	s2,48(sp)
    80003256:	6ae2                	ld	s5,24(sp)
    80003258:	6b42                	ld	s6,16(sp)
    8000325a:	6161                	addi	sp,sp,80
    8000325c:	8082                	ret
    8000325e:	f44e                	sd	s3,40(sp)
    80003260:	f052                	sd	s4,32(sp)
    panic("dirlink");
    80003262:	00005517          	auipc	a0,0x5
    80003266:	34650513          	addi	a0,a0,838 # 800085a8 <etext+0x5a8>
    8000326a:	00003097          	auipc	ra,0x3
    8000326e:	9d8080e7          	jalr	-1576(ra) # 80005c42 <panic>

0000000080003272 <namei>:

struct inode*
namei(char *path)
{
    80003272:	1101                	addi	sp,sp,-32
    80003274:	ec06                	sd	ra,24(sp)
    80003276:	e822                	sd	s0,16(sp)
    80003278:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    8000327a:	fe040613          	addi	a2,s0,-32
    8000327e:	4581                	li	a1,0
    80003280:	00000097          	auipc	ra,0x0
    80003284:	db6080e7          	jalr	-586(ra) # 80003036 <namex>
}
    80003288:	60e2                	ld	ra,24(sp)
    8000328a:	6442                	ld	s0,16(sp)
    8000328c:	6105                	addi	sp,sp,32
    8000328e:	8082                	ret

0000000080003290 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003290:	1141                	addi	sp,sp,-16
    80003292:	e406                	sd	ra,8(sp)
    80003294:	e022                	sd	s0,0(sp)
    80003296:	0800                	addi	s0,sp,16
    80003298:	862e                	mv	a2,a1
  return namex(path, 1, name);
    8000329a:	4585                	li	a1,1
    8000329c:	00000097          	auipc	ra,0x0
    800032a0:	d9a080e7          	jalr	-614(ra) # 80003036 <namex>
}
    800032a4:	60a2                	ld	ra,8(sp)
    800032a6:	6402                	ld	s0,0(sp)
    800032a8:	0141                	addi	sp,sp,16
    800032aa:	8082                	ret

00000000800032ac <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800032ac:	1101                	addi	sp,sp,-32
    800032ae:	ec06                	sd	ra,24(sp)
    800032b0:	e822                	sd	s0,16(sp)
    800032b2:	e426                	sd	s1,8(sp)
    800032b4:	e04a                	sd	s2,0(sp)
    800032b6:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800032b8:	00016917          	auipc	s2,0x16
    800032bc:	d6890913          	addi	s2,s2,-664 # 80019020 <log>
    800032c0:	01892583          	lw	a1,24(s2)
    800032c4:	02892503          	lw	a0,40(s2)
    800032c8:	fffff097          	auipc	ra,0xfffff
    800032cc:	fe2080e7          	jalr	-30(ra) # 800022aa <bread>
    800032d0:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800032d2:	02c92603          	lw	a2,44(s2)
    800032d6:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800032d8:	00c05f63          	blez	a2,800032f6 <write_head+0x4a>
    800032dc:	00016717          	auipc	a4,0x16
    800032e0:	d7470713          	addi	a4,a4,-652 # 80019050 <log+0x30>
    800032e4:	87aa                	mv	a5,a0
    800032e6:	060a                	slli	a2,a2,0x2
    800032e8:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    800032ea:	4314                	lw	a3,0(a4)
    800032ec:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    800032ee:	0711                	addi	a4,a4,4
    800032f0:	0791                	addi	a5,a5,4
    800032f2:	fec79ce3          	bne	a5,a2,800032ea <write_head+0x3e>
  }
  bwrite(buf);
    800032f6:	8526                	mv	a0,s1
    800032f8:	fffff097          	auipc	ra,0xfffff
    800032fc:	0a4080e7          	jalr	164(ra) # 8000239c <bwrite>
  brelse(buf);
    80003300:	8526                	mv	a0,s1
    80003302:	fffff097          	auipc	ra,0xfffff
    80003306:	0d8080e7          	jalr	216(ra) # 800023da <brelse>
}
    8000330a:	60e2                	ld	ra,24(sp)
    8000330c:	6442                	ld	s0,16(sp)
    8000330e:	64a2                	ld	s1,8(sp)
    80003310:	6902                	ld	s2,0(sp)
    80003312:	6105                	addi	sp,sp,32
    80003314:	8082                	ret

0000000080003316 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003316:	00016797          	auipc	a5,0x16
    8000331a:	d367a783          	lw	a5,-714(a5) # 8001904c <log+0x2c>
    8000331e:	0cf05063          	blez	a5,800033de <install_trans+0xc8>
{
    80003322:	715d                	addi	sp,sp,-80
    80003324:	e486                	sd	ra,72(sp)
    80003326:	e0a2                	sd	s0,64(sp)
    80003328:	fc26                	sd	s1,56(sp)
    8000332a:	f84a                	sd	s2,48(sp)
    8000332c:	f44e                	sd	s3,40(sp)
    8000332e:	f052                	sd	s4,32(sp)
    80003330:	ec56                	sd	s5,24(sp)
    80003332:	e85a                	sd	s6,16(sp)
    80003334:	e45e                	sd	s7,8(sp)
    80003336:	0880                	addi	s0,sp,80
    80003338:	8b2a                	mv	s6,a0
    8000333a:	00016a97          	auipc	s5,0x16
    8000333e:	d16a8a93          	addi	s5,s5,-746 # 80019050 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003342:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003344:	00016997          	auipc	s3,0x16
    80003348:	cdc98993          	addi	s3,s3,-804 # 80019020 <log>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000334c:	40000b93          	li	s7,1024
    80003350:	a00d                	j	80003372 <install_trans+0x5c>
    brelse(lbuf);
    80003352:	854a                	mv	a0,s2
    80003354:	fffff097          	auipc	ra,0xfffff
    80003358:	086080e7          	jalr	134(ra) # 800023da <brelse>
    brelse(dbuf);
    8000335c:	8526                	mv	a0,s1
    8000335e:	fffff097          	auipc	ra,0xfffff
    80003362:	07c080e7          	jalr	124(ra) # 800023da <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003366:	2a05                	addiw	s4,s4,1
    80003368:	0a91                	addi	s5,s5,4
    8000336a:	02c9a783          	lw	a5,44(s3)
    8000336e:	04fa5d63          	bge	s4,a5,800033c8 <install_trans+0xb2>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003372:	0189a583          	lw	a1,24(s3)
    80003376:	014585bb          	addw	a1,a1,s4
    8000337a:	2585                	addiw	a1,a1,1
    8000337c:	0289a503          	lw	a0,40(s3)
    80003380:	fffff097          	auipc	ra,0xfffff
    80003384:	f2a080e7          	jalr	-214(ra) # 800022aa <bread>
    80003388:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000338a:	000aa583          	lw	a1,0(s5)
    8000338e:	0289a503          	lw	a0,40(s3)
    80003392:	fffff097          	auipc	ra,0xfffff
    80003396:	f18080e7          	jalr	-232(ra) # 800022aa <bread>
    8000339a:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000339c:	865e                	mv	a2,s7
    8000339e:	05890593          	addi	a1,s2,88
    800033a2:	05850513          	addi	a0,a0,88
    800033a6:	ffffd097          	auipc	ra,0xffffd
    800033aa:	e38080e7          	jalr	-456(ra) # 800001de <memmove>
    bwrite(dbuf);  // write dst to disk
    800033ae:	8526                	mv	a0,s1
    800033b0:	fffff097          	auipc	ra,0xfffff
    800033b4:	fec080e7          	jalr	-20(ra) # 8000239c <bwrite>
    if(recovering == 0)
    800033b8:	f80b1de3          	bnez	s6,80003352 <install_trans+0x3c>
      bunpin(dbuf);
    800033bc:	8526                	mv	a0,s1
    800033be:	fffff097          	auipc	ra,0xfffff
    800033c2:	0f0080e7          	jalr	240(ra) # 800024ae <bunpin>
    800033c6:	b771                	j	80003352 <install_trans+0x3c>
}
    800033c8:	60a6                	ld	ra,72(sp)
    800033ca:	6406                	ld	s0,64(sp)
    800033cc:	74e2                	ld	s1,56(sp)
    800033ce:	7942                	ld	s2,48(sp)
    800033d0:	79a2                	ld	s3,40(sp)
    800033d2:	7a02                	ld	s4,32(sp)
    800033d4:	6ae2                	ld	s5,24(sp)
    800033d6:	6b42                	ld	s6,16(sp)
    800033d8:	6ba2                	ld	s7,8(sp)
    800033da:	6161                	addi	sp,sp,80
    800033dc:	8082                	ret
    800033de:	8082                	ret

00000000800033e0 <initlog>:
{
    800033e0:	7179                	addi	sp,sp,-48
    800033e2:	f406                	sd	ra,40(sp)
    800033e4:	f022                	sd	s0,32(sp)
    800033e6:	ec26                	sd	s1,24(sp)
    800033e8:	e84a                	sd	s2,16(sp)
    800033ea:	e44e                	sd	s3,8(sp)
    800033ec:	1800                	addi	s0,sp,48
    800033ee:	892a                	mv	s2,a0
    800033f0:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800033f2:	00016497          	auipc	s1,0x16
    800033f6:	c2e48493          	addi	s1,s1,-978 # 80019020 <log>
    800033fa:	00005597          	auipc	a1,0x5
    800033fe:	0ae58593          	addi	a1,a1,174 # 800084a8 <etext+0x4a8>
    80003402:	8526                	mv	a0,s1
    80003404:	00003097          	auipc	ra,0x3
    80003408:	d2a080e7          	jalr	-726(ra) # 8000612e <initlock>
  log.start = sb->logstart;
    8000340c:	0149a583          	lw	a1,20(s3)
    80003410:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003412:	0109a783          	lw	a5,16(s3)
    80003416:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003418:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000341c:	854a                	mv	a0,s2
    8000341e:	fffff097          	auipc	ra,0xfffff
    80003422:	e8c080e7          	jalr	-372(ra) # 800022aa <bread>
  log.lh.n = lh->n;
    80003426:	4d30                	lw	a2,88(a0)
    80003428:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000342a:	00c05f63          	blez	a2,80003448 <initlog+0x68>
    8000342e:	87aa                	mv	a5,a0
    80003430:	00016717          	auipc	a4,0x16
    80003434:	c2070713          	addi	a4,a4,-992 # 80019050 <log+0x30>
    80003438:	060a                	slli	a2,a2,0x2
    8000343a:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    8000343c:	4ff4                	lw	a3,92(a5)
    8000343e:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003440:	0791                	addi	a5,a5,4
    80003442:	0711                	addi	a4,a4,4
    80003444:	fec79ce3          	bne	a5,a2,8000343c <initlog+0x5c>
  brelse(buf);
    80003448:	fffff097          	auipc	ra,0xfffff
    8000344c:	f92080e7          	jalr	-110(ra) # 800023da <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003450:	4505                	li	a0,1
    80003452:	00000097          	auipc	ra,0x0
    80003456:	ec4080e7          	jalr	-316(ra) # 80003316 <install_trans>
  log.lh.n = 0;
    8000345a:	00016797          	auipc	a5,0x16
    8000345e:	be07a923          	sw	zero,-1038(a5) # 8001904c <log+0x2c>
  write_head(); // clear the log
    80003462:	00000097          	auipc	ra,0x0
    80003466:	e4a080e7          	jalr	-438(ra) # 800032ac <write_head>
}
    8000346a:	70a2                	ld	ra,40(sp)
    8000346c:	7402                	ld	s0,32(sp)
    8000346e:	64e2                	ld	s1,24(sp)
    80003470:	6942                	ld	s2,16(sp)
    80003472:	69a2                	ld	s3,8(sp)
    80003474:	6145                	addi	sp,sp,48
    80003476:	8082                	ret

0000000080003478 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003478:	1101                	addi	sp,sp,-32
    8000347a:	ec06                	sd	ra,24(sp)
    8000347c:	e822                	sd	s0,16(sp)
    8000347e:	e426                	sd	s1,8(sp)
    80003480:	e04a                	sd	s2,0(sp)
    80003482:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003484:	00016517          	auipc	a0,0x16
    80003488:	b9c50513          	addi	a0,a0,-1124 # 80019020 <log>
    8000348c:	00003097          	auipc	ra,0x3
    80003490:	d36080e7          	jalr	-714(ra) # 800061c2 <acquire>
  while(1){
    if(log.committing){
    80003494:	00016497          	auipc	s1,0x16
    80003498:	b8c48493          	addi	s1,s1,-1140 # 80019020 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000349c:	4979                	li	s2,30
    8000349e:	a039                	j	800034ac <begin_op+0x34>
      sleep(&log, &log.lock);
    800034a0:	85a6                	mv	a1,s1
    800034a2:	8526                	mv	a0,s1
    800034a4:	ffffe097          	auipc	ra,0xffffe
    800034a8:	096080e7          	jalr	150(ra) # 8000153a <sleep>
    if(log.committing){
    800034ac:	50dc                	lw	a5,36(s1)
    800034ae:	fbed                	bnez	a5,800034a0 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800034b0:	5098                	lw	a4,32(s1)
    800034b2:	2705                	addiw	a4,a4,1
    800034b4:	0027179b          	slliw	a5,a4,0x2
    800034b8:	9fb9                	addw	a5,a5,a4
    800034ba:	0017979b          	slliw	a5,a5,0x1
    800034be:	54d4                	lw	a3,44(s1)
    800034c0:	9fb5                	addw	a5,a5,a3
    800034c2:	00f95963          	bge	s2,a5,800034d4 <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800034c6:	85a6                	mv	a1,s1
    800034c8:	8526                	mv	a0,s1
    800034ca:	ffffe097          	auipc	ra,0xffffe
    800034ce:	070080e7          	jalr	112(ra) # 8000153a <sleep>
    800034d2:	bfe9                	j	800034ac <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800034d4:	00016517          	auipc	a0,0x16
    800034d8:	b4c50513          	addi	a0,a0,-1204 # 80019020 <log>
    800034dc:	d118                	sw	a4,32(a0)
      release(&log.lock);
    800034de:	00003097          	auipc	ra,0x3
    800034e2:	d94080e7          	jalr	-620(ra) # 80006272 <release>
      break;
    }
  }
}
    800034e6:	60e2                	ld	ra,24(sp)
    800034e8:	6442                	ld	s0,16(sp)
    800034ea:	64a2                	ld	s1,8(sp)
    800034ec:	6902                	ld	s2,0(sp)
    800034ee:	6105                	addi	sp,sp,32
    800034f0:	8082                	ret

00000000800034f2 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800034f2:	7139                	addi	sp,sp,-64
    800034f4:	fc06                	sd	ra,56(sp)
    800034f6:	f822                	sd	s0,48(sp)
    800034f8:	f426                	sd	s1,40(sp)
    800034fa:	f04a                	sd	s2,32(sp)
    800034fc:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800034fe:	00016497          	auipc	s1,0x16
    80003502:	b2248493          	addi	s1,s1,-1246 # 80019020 <log>
    80003506:	8526                	mv	a0,s1
    80003508:	00003097          	auipc	ra,0x3
    8000350c:	cba080e7          	jalr	-838(ra) # 800061c2 <acquire>
  log.outstanding -= 1;
    80003510:	509c                	lw	a5,32(s1)
    80003512:	37fd                	addiw	a5,a5,-1
    80003514:	893e                	mv	s2,a5
    80003516:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003518:	50dc                	lw	a5,36(s1)
    8000351a:	e7b9                	bnez	a5,80003568 <end_op+0x76>
    panic("log.committing");
  if(log.outstanding == 0){
    8000351c:	06091263          	bnez	s2,80003580 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80003520:	00016497          	auipc	s1,0x16
    80003524:	b0048493          	addi	s1,s1,-1280 # 80019020 <log>
    80003528:	4785                	li	a5,1
    8000352a:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000352c:	8526                	mv	a0,s1
    8000352e:	00003097          	auipc	ra,0x3
    80003532:	d44080e7          	jalr	-700(ra) # 80006272 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003536:	54dc                	lw	a5,44(s1)
    80003538:	06f04863          	bgtz	a5,800035a8 <end_op+0xb6>
    acquire(&log.lock);
    8000353c:	00016497          	auipc	s1,0x16
    80003540:	ae448493          	addi	s1,s1,-1308 # 80019020 <log>
    80003544:	8526                	mv	a0,s1
    80003546:	00003097          	auipc	ra,0x3
    8000354a:	c7c080e7          	jalr	-900(ra) # 800061c2 <acquire>
    log.committing = 0;
    8000354e:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003552:	8526                	mv	a0,s1
    80003554:	ffffe097          	auipc	ra,0xffffe
    80003558:	16c080e7          	jalr	364(ra) # 800016c0 <wakeup>
    release(&log.lock);
    8000355c:	8526                	mv	a0,s1
    8000355e:	00003097          	auipc	ra,0x3
    80003562:	d14080e7          	jalr	-748(ra) # 80006272 <release>
}
    80003566:	a81d                	j	8000359c <end_op+0xaa>
    80003568:	ec4e                	sd	s3,24(sp)
    8000356a:	e852                	sd	s4,16(sp)
    8000356c:	e456                	sd	s5,8(sp)
    8000356e:	e05a                	sd	s6,0(sp)
    panic("log.committing");
    80003570:	00005517          	auipc	a0,0x5
    80003574:	f4050513          	addi	a0,a0,-192 # 800084b0 <etext+0x4b0>
    80003578:	00002097          	auipc	ra,0x2
    8000357c:	6ca080e7          	jalr	1738(ra) # 80005c42 <panic>
    wakeup(&log);
    80003580:	00016497          	auipc	s1,0x16
    80003584:	aa048493          	addi	s1,s1,-1376 # 80019020 <log>
    80003588:	8526                	mv	a0,s1
    8000358a:	ffffe097          	auipc	ra,0xffffe
    8000358e:	136080e7          	jalr	310(ra) # 800016c0 <wakeup>
  release(&log.lock);
    80003592:	8526                	mv	a0,s1
    80003594:	00003097          	auipc	ra,0x3
    80003598:	cde080e7          	jalr	-802(ra) # 80006272 <release>
}
    8000359c:	70e2                	ld	ra,56(sp)
    8000359e:	7442                	ld	s0,48(sp)
    800035a0:	74a2                	ld	s1,40(sp)
    800035a2:	7902                	ld	s2,32(sp)
    800035a4:	6121                	addi	sp,sp,64
    800035a6:	8082                	ret
    800035a8:	ec4e                	sd	s3,24(sp)
    800035aa:	e852                	sd	s4,16(sp)
    800035ac:	e456                	sd	s5,8(sp)
    800035ae:	e05a                	sd	s6,0(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    800035b0:	00016a97          	auipc	s5,0x16
    800035b4:	aa0a8a93          	addi	s5,s5,-1376 # 80019050 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800035b8:	00016a17          	auipc	s4,0x16
    800035bc:	a68a0a13          	addi	s4,s4,-1432 # 80019020 <log>
    memmove(to->data, from->data, BSIZE);
    800035c0:	40000b13          	li	s6,1024
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800035c4:	018a2583          	lw	a1,24(s4)
    800035c8:	012585bb          	addw	a1,a1,s2
    800035cc:	2585                	addiw	a1,a1,1
    800035ce:	028a2503          	lw	a0,40(s4)
    800035d2:	fffff097          	auipc	ra,0xfffff
    800035d6:	cd8080e7          	jalr	-808(ra) # 800022aa <bread>
    800035da:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800035dc:	000aa583          	lw	a1,0(s5)
    800035e0:	028a2503          	lw	a0,40(s4)
    800035e4:	fffff097          	auipc	ra,0xfffff
    800035e8:	cc6080e7          	jalr	-826(ra) # 800022aa <bread>
    800035ec:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800035ee:	865a                	mv	a2,s6
    800035f0:	05850593          	addi	a1,a0,88
    800035f4:	05848513          	addi	a0,s1,88
    800035f8:	ffffd097          	auipc	ra,0xffffd
    800035fc:	be6080e7          	jalr	-1050(ra) # 800001de <memmove>
    bwrite(to);  // write the log
    80003600:	8526                	mv	a0,s1
    80003602:	fffff097          	auipc	ra,0xfffff
    80003606:	d9a080e7          	jalr	-614(ra) # 8000239c <bwrite>
    brelse(from);
    8000360a:	854e                	mv	a0,s3
    8000360c:	fffff097          	auipc	ra,0xfffff
    80003610:	dce080e7          	jalr	-562(ra) # 800023da <brelse>
    brelse(to);
    80003614:	8526                	mv	a0,s1
    80003616:	fffff097          	auipc	ra,0xfffff
    8000361a:	dc4080e7          	jalr	-572(ra) # 800023da <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000361e:	2905                	addiw	s2,s2,1
    80003620:	0a91                	addi	s5,s5,4
    80003622:	02ca2783          	lw	a5,44(s4)
    80003626:	f8f94fe3          	blt	s2,a5,800035c4 <end_op+0xd2>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000362a:	00000097          	auipc	ra,0x0
    8000362e:	c82080e7          	jalr	-894(ra) # 800032ac <write_head>
    install_trans(0); // Now install writes to home locations
    80003632:	4501                	li	a0,0
    80003634:	00000097          	auipc	ra,0x0
    80003638:	ce2080e7          	jalr	-798(ra) # 80003316 <install_trans>
    log.lh.n = 0;
    8000363c:	00016797          	auipc	a5,0x16
    80003640:	a007a823          	sw	zero,-1520(a5) # 8001904c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003644:	00000097          	auipc	ra,0x0
    80003648:	c68080e7          	jalr	-920(ra) # 800032ac <write_head>
    8000364c:	69e2                	ld	s3,24(sp)
    8000364e:	6a42                	ld	s4,16(sp)
    80003650:	6aa2                	ld	s5,8(sp)
    80003652:	6b02                	ld	s6,0(sp)
    80003654:	b5e5                	j	8000353c <end_op+0x4a>

0000000080003656 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003656:	1101                	addi	sp,sp,-32
    80003658:	ec06                	sd	ra,24(sp)
    8000365a:	e822                	sd	s0,16(sp)
    8000365c:	e426                	sd	s1,8(sp)
    8000365e:	e04a                	sd	s2,0(sp)
    80003660:	1000                	addi	s0,sp,32
    80003662:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003664:	00016917          	auipc	s2,0x16
    80003668:	9bc90913          	addi	s2,s2,-1604 # 80019020 <log>
    8000366c:	854a                	mv	a0,s2
    8000366e:	00003097          	auipc	ra,0x3
    80003672:	b54080e7          	jalr	-1196(ra) # 800061c2 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003676:	02c92603          	lw	a2,44(s2)
    8000367a:	47f5                	li	a5,29
    8000367c:	06c7c563          	blt	a5,a2,800036e6 <log_write+0x90>
    80003680:	00016797          	auipc	a5,0x16
    80003684:	9bc7a783          	lw	a5,-1604(a5) # 8001903c <log+0x1c>
    80003688:	37fd                	addiw	a5,a5,-1
    8000368a:	04f65e63          	bge	a2,a5,800036e6 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000368e:	00016797          	auipc	a5,0x16
    80003692:	9b27a783          	lw	a5,-1614(a5) # 80019040 <log+0x20>
    80003696:	06f05063          	blez	a5,800036f6 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    8000369a:	4781                	li	a5,0
    8000369c:	06c05563          	blez	a2,80003706 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800036a0:	44cc                	lw	a1,12(s1)
    800036a2:	00016717          	auipc	a4,0x16
    800036a6:	9ae70713          	addi	a4,a4,-1618 # 80019050 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800036aa:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800036ac:	4314                	lw	a3,0(a4)
    800036ae:	04b68c63          	beq	a3,a1,80003706 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800036b2:	2785                	addiw	a5,a5,1
    800036b4:	0711                	addi	a4,a4,4
    800036b6:	fef61be3          	bne	a2,a5,800036ac <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800036ba:	0621                	addi	a2,a2,8
    800036bc:	060a                	slli	a2,a2,0x2
    800036be:	00016797          	auipc	a5,0x16
    800036c2:	96278793          	addi	a5,a5,-1694 # 80019020 <log>
    800036c6:	97b2                	add	a5,a5,a2
    800036c8:	44d8                	lw	a4,12(s1)
    800036ca:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800036cc:	8526                	mv	a0,s1
    800036ce:	fffff097          	auipc	ra,0xfffff
    800036d2:	da4080e7          	jalr	-604(ra) # 80002472 <bpin>
    log.lh.n++;
    800036d6:	00016717          	auipc	a4,0x16
    800036da:	94a70713          	addi	a4,a4,-1718 # 80019020 <log>
    800036de:	575c                	lw	a5,44(a4)
    800036e0:	2785                	addiw	a5,a5,1
    800036e2:	d75c                	sw	a5,44(a4)
    800036e4:	a82d                	j	8000371e <log_write+0xc8>
    panic("too big a transaction");
    800036e6:	00005517          	auipc	a0,0x5
    800036ea:	dda50513          	addi	a0,a0,-550 # 800084c0 <etext+0x4c0>
    800036ee:	00002097          	auipc	ra,0x2
    800036f2:	554080e7          	jalr	1364(ra) # 80005c42 <panic>
    panic("log_write outside of trans");
    800036f6:	00005517          	auipc	a0,0x5
    800036fa:	de250513          	addi	a0,a0,-542 # 800084d8 <etext+0x4d8>
    800036fe:	00002097          	auipc	ra,0x2
    80003702:	544080e7          	jalr	1348(ra) # 80005c42 <panic>
  log.lh.block[i] = b->blockno;
    80003706:	00878693          	addi	a3,a5,8
    8000370a:	068a                	slli	a3,a3,0x2
    8000370c:	00016717          	auipc	a4,0x16
    80003710:	91470713          	addi	a4,a4,-1772 # 80019020 <log>
    80003714:	9736                	add	a4,a4,a3
    80003716:	44d4                	lw	a3,12(s1)
    80003718:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000371a:	faf609e3          	beq	a2,a5,800036cc <log_write+0x76>
  }
  release(&log.lock);
    8000371e:	00016517          	auipc	a0,0x16
    80003722:	90250513          	addi	a0,a0,-1790 # 80019020 <log>
    80003726:	00003097          	auipc	ra,0x3
    8000372a:	b4c080e7          	jalr	-1204(ra) # 80006272 <release>
}
    8000372e:	60e2                	ld	ra,24(sp)
    80003730:	6442                	ld	s0,16(sp)
    80003732:	64a2                	ld	s1,8(sp)
    80003734:	6902                	ld	s2,0(sp)
    80003736:	6105                	addi	sp,sp,32
    80003738:	8082                	ret

000000008000373a <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000373a:	1101                	addi	sp,sp,-32
    8000373c:	ec06                	sd	ra,24(sp)
    8000373e:	e822                	sd	s0,16(sp)
    80003740:	e426                	sd	s1,8(sp)
    80003742:	e04a                	sd	s2,0(sp)
    80003744:	1000                	addi	s0,sp,32
    80003746:	84aa                	mv	s1,a0
    80003748:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000374a:	00005597          	auipc	a1,0x5
    8000374e:	dae58593          	addi	a1,a1,-594 # 800084f8 <etext+0x4f8>
    80003752:	0521                	addi	a0,a0,8
    80003754:	00003097          	auipc	ra,0x3
    80003758:	9da080e7          	jalr	-1574(ra) # 8000612e <initlock>
  lk->name = name;
    8000375c:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003760:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003764:	0204a423          	sw	zero,40(s1)
}
    80003768:	60e2                	ld	ra,24(sp)
    8000376a:	6442                	ld	s0,16(sp)
    8000376c:	64a2                	ld	s1,8(sp)
    8000376e:	6902                	ld	s2,0(sp)
    80003770:	6105                	addi	sp,sp,32
    80003772:	8082                	ret

0000000080003774 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003774:	1101                	addi	sp,sp,-32
    80003776:	ec06                	sd	ra,24(sp)
    80003778:	e822                	sd	s0,16(sp)
    8000377a:	e426                	sd	s1,8(sp)
    8000377c:	e04a                	sd	s2,0(sp)
    8000377e:	1000                	addi	s0,sp,32
    80003780:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003782:	00850913          	addi	s2,a0,8
    80003786:	854a                	mv	a0,s2
    80003788:	00003097          	auipc	ra,0x3
    8000378c:	a3a080e7          	jalr	-1478(ra) # 800061c2 <acquire>
  while (lk->locked) {
    80003790:	409c                	lw	a5,0(s1)
    80003792:	cb89                	beqz	a5,800037a4 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003794:	85ca                	mv	a1,s2
    80003796:	8526                	mv	a0,s1
    80003798:	ffffe097          	auipc	ra,0xffffe
    8000379c:	da2080e7          	jalr	-606(ra) # 8000153a <sleep>
  while (lk->locked) {
    800037a0:	409c                	lw	a5,0(s1)
    800037a2:	fbed                	bnez	a5,80003794 <acquiresleep+0x20>
  }
  lk->locked = 1;
    800037a4:	4785                	li	a5,1
    800037a6:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800037a8:	ffffd097          	auipc	ra,0xffffd
    800037ac:	6cc080e7          	jalr	1740(ra) # 80000e74 <myproc>
    800037b0:	591c                	lw	a5,48(a0)
    800037b2:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800037b4:	854a                	mv	a0,s2
    800037b6:	00003097          	auipc	ra,0x3
    800037ba:	abc080e7          	jalr	-1348(ra) # 80006272 <release>
}
    800037be:	60e2                	ld	ra,24(sp)
    800037c0:	6442                	ld	s0,16(sp)
    800037c2:	64a2                	ld	s1,8(sp)
    800037c4:	6902                	ld	s2,0(sp)
    800037c6:	6105                	addi	sp,sp,32
    800037c8:	8082                	ret

00000000800037ca <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800037ca:	1101                	addi	sp,sp,-32
    800037cc:	ec06                	sd	ra,24(sp)
    800037ce:	e822                	sd	s0,16(sp)
    800037d0:	e426                	sd	s1,8(sp)
    800037d2:	e04a                	sd	s2,0(sp)
    800037d4:	1000                	addi	s0,sp,32
    800037d6:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800037d8:	00850913          	addi	s2,a0,8
    800037dc:	854a                	mv	a0,s2
    800037de:	00003097          	auipc	ra,0x3
    800037e2:	9e4080e7          	jalr	-1564(ra) # 800061c2 <acquire>
  lk->locked = 0;
    800037e6:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800037ea:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800037ee:	8526                	mv	a0,s1
    800037f0:	ffffe097          	auipc	ra,0xffffe
    800037f4:	ed0080e7          	jalr	-304(ra) # 800016c0 <wakeup>
  release(&lk->lk);
    800037f8:	854a                	mv	a0,s2
    800037fa:	00003097          	auipc	ra,0x3
    800037fe:	a78080e7          	jalr	-1416(ra) # 80006272 <release>
}
    80003802:	60e2                	ld	ra,24(sp)
    80003804:	6442                	ld	s0,16(sp)
    80003806:	64a2                	ld	s1,8(sp)
    80003808:	6902                	ld	s2,0(sp)
    8000380a:	6105                	addi	sp,sp,32
    8000380c:	8082                	ret

000000008000380e <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8000380e:	7179                	addi	sp,sp,-48
    80003810:	f406                	sd	ra,40(sp)
    80003812:	f022                	sd	s0,32(sp)
    80003814:	ec26                	sd	s1,24(sp)
    80003816:	e84a                	sd	s2,16(sp)
    80003818:	1800                	addi	s0,sp,48
    8000381a:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    8000381c:	00850913          	addi	s2,a0,8
    80003820:	854a                	mv	a0,s2
    80003822:	00003097          	auipc	ra,0x3
    80003826:	9a0080e7          	jalr	-1632(ra) # 800061c2 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    8000382a:	409c                	lw	a5,0(s1)
    8000382c:	ef91                	bnez	a5,80003848 <holdingsleep+0x3a>
    8000382e:	4481                	li	s1,0
  release(&lk->lk);
    80003830:	854a                	mv	a0,s2
    80003832:	00003097          	auipc	ra,0x3
    80003836:	a40080e7          	jalr	-1472(ra) # 80006272 <release>
  return r;
}
    8000383a:	8526                	mv	a0,s1
    8000383c:	70a2                	ld	ra,40(sp)
    8000383e:	7402                	ld	s0,32(sp)
    80003840:	64e2                	ld	s1,24(sp)
    80003842:	6942                	ld	s2,16(sp)
    80003844:	6145                	addi	sp,sp,48
    80003846:	8082                	ret
    80003848:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    8000384a:	0284a983          	lw	s3,40(s1)
    8000384e:	ffffd097          	auipc	ra,0xffffd
    80003852:	626080e7          	jalr	1574(ra) # 80000e74 <myproc>
    80003856:	5904                	lw	s1,48(a0)
    80003858:	413484b3          	sub	s1,s1,s3
    8000385c:	0014b493          	seqz	s1,s1
    80003860:	69a2                	ld	s3,8(sp)
    80003862:	b7f9                	j	80003830 <holdingsleep+0x22>

0000000080003864 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003864:	1141                	addi	sp,sp,-16
    80003866:	e406                	sd	ra,8(sp)
    80003868:	e022                	sd	s0,0(sp)
    8000386a:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    8000386c:	00005597          	auipc	a1,0x5
    80003870:	c9c58593          	addi	a1,a1,-868 # 80008508 <etext+0x508>
    80003874:	00016517          	auipc	a0,0x16
    80003878:	8f450513          	addi	a0,a0,-1804 # 80019168 <ftable>
    8000387c:	00003097          	auipc	ra,0x3
    80003880:	8b2080e7          	jalr	-1870(ra) # 8000612e <initlock>
}
    80003884:	60a2                	ld	ra,8(sp)
    80003886:	6402                	ld	s0,0(sp)
    80003888:	0141                	addi	sp,sp,16
    8000388a:	8082                	ret

000000008000388c <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    8000388c:	1101                	addi	sp,sp,-32
    8000388e:	ec06                	sd	ra,24(sp)
    80003890:	e822                	sd	s0,16(sp)
    80003892:	e426                	sd	s1,8(sp)
    80003894:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003896:	00016517          	auipc	a0,0x16
    8000389a:	8d250513          	addi	a0,a0,-1838 # 80019168 <ftable>
    8000389e:	00003097          	auipc	ra,0x3
    800038a2:	924080e7          	jalr	-1756(ra) # 800061c2 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800038a6:	00016497          	auipc	s1,0x16
    800038aa:	8da48493          	addi	s1,s1,-1830 # 80019180 <ftable+0x18>
    800038ae:	00017717          	auipc	a4,0x17
    800038b2:	87270713          	addi	a4,a4,-1934 # 8001a120 <ftable+0xfb8>
    if(f->ref == 0){
    800038b6:	40dc                	lw	a5,4(s1)
    800038b8:	cf99                	beqz	a5,800038d6 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800038ba:	02848493          	addi	s1,s1,40
    800038be:	fee49ce3          	bne	s1,a4,800038b6 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800038c2:	00016517          	auipc	a0,0x16
    800038c6:	8a650513          	addi	a0,a0,-1882 # 80019168 <ftable>
    800038ca:	00003097          	auipc	ra,0x3
    800038ce:	9a8080e7          	jalr	-1624(ra) # 80006272 <release>
  return 0;
    800038d2:	4481                	li	s1,0
    800038d4:	a819                	j	800038ea <filealloc+0x5e>
      f->ref = 1;
    800038d6:	4785                	li	a5,1
    800038d8:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800038da:	00016517          	auipc	a0,0x16
    800038de:	88e50513          	addi	a0,a0,-1906 # 80019168 <ftable>
    800038e2:	00003097          	auipc	ra,0x3
    800038e6:	990080e7          	jalr	-1648(ra) # 80006272 <release>
}
    800038ea:	8526                	mv	a0,s1
    800038ec:	60e2                	ld	ra,24(sp)
    800038ee:	6442                	ld	s0,16(sp)
    800038f0:	64a2                	ld	s1,8(sp)
    800038f2:	6105                	addi	sp,sp,32
    800038f4:	8082                	ret

00000000800038f6 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    800038f6:	1101                	addi	sp,sp,-32
    800038f8:	ec06                	sd	ra,24(sp)
    800038fa:	e822                	sd	s0,16(sp)
    800038fc:	e426                	sd	s1,8(sp)
    800038fe:	1000                	addi	s0,sp,32
    80003900:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003902:	00016517          	auipc	a0,0x16
    80003906:	86650513          	addi	a0,a0,-1946 # 80019168 <ftable>
    8000390a:	00003097          	auipc	ra,0x3
    8000390e:	8b8080e7          	jalr	-1864(ra) # 800061c2 <acquire>
  if(f->ref < 1)
    80003912:	40dc                	lw	a5,4(s1)
    80003914:	02f05263          	blez	a5,80003938 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003918:	2785                	addiw	a5,a5,1
    8000391a:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    8000391c:	00016517          	auipc	a0,0x16
    80003920:	84c50513          	addi	a0,a0,-1972 # 80019168 <ftable>
    80003924:	00003097          	auipc	ra,0x3
    80003928:	94e080e7          	jalr	-1714(ra) # 80006272 <release>
  return f;
}
    8000392c:	8526                	mv	a0,s1
    8000392e:	60e2                	ld	ra,24(sp)
    80003930:	6442                	ld	s0,16(sp)
    80003932:	64a2                	ld	s1,8(sp)
    80003934:	6105                	addi	sp,sp,32
    80003936:	8082                	ret
    panic("filedup");
    80003938:	00005517          	auipc	a0,0x5
    8000393c:	bd850513          	addi	a0,a0,-1064 # 80008510 <etext+0x510>
    80003940:	00002097          	auipc	ra,0x2
    80003944:	302080e7          	jalr	770(ra) # 80005c42 <panic>

0000000080003948 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003948:	7139                	addi	sp,sp,-64
    8000394a:	fc06                	sd	ra,56(sp)
    8000394c:	f822                	sd	s0,48(sp)
    8000394e:	f426                	sd	s1,40(sp)
    80003950:	0080                	addi	s0,sp,64
    80003952:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003954:	00016517          	auipc	a0,0x16
    80003958:	81450513          	addi	a0,a0,-2028 # 80019168 <ftable>
    8000395c:	00003097          	auipc	ra,0x3
    80003960:	866080e7          	jalr	-1946(ra) # 800061c2 <acquire>
  if(f->ref < 1)
    80003964:	40dc                	lw	a5,4(s1)
    80003966:	04f05a63          	blez	a5,800039ba <fileclose+0x72>
    panic("fileclose");
  if(--f->ref > 0){
    8000396a:	37fd                	addiw	a5,a5,-1
    8000396c:	c0dc                	sw	a5,4(s1)
    8000396e:	06f04263          	bgtz	a5,800039d2 <fileclose+0x8a>
    80003972:	f04a                	sd	s2,32(sp)
    80003974:	ec4e                	sd	s3,24(sp)
    80003976:	e852                	sd	s4,16(sp)
    80003978:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    8000397a:	0004a903          	lw	s2,0(s1)
    8000397e:	0094ca83          	lbu	s5,9(s1)
    80003982:	0104ba03          	ld	s4,16(s1)
    80003986:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    8000398a:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    8000398e:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003992:	00015517          	auipc	a0,0x15
    80003996:	7d650513          	addi	a0,a0,2006 # 80019168 <ftable>
    8000399a:	00003097          	auipc	ra,0x3
    8000399e:	8d8080e7          	jalr	-1832(ra) # 80006272 <release>

  if(ff.type == FD_PIPE){
    800039a2:	4785                	li	a5,1
    800039a4:	04f90463          	beq	s2,a5,800039ec <fileclose+0xa4>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    800039a8:	3979                	addiw	s2,s2,-2
    800039aa:	4785                	li	a5,1
    800039ac:	0527fb63          	bgeu	a5,s2,80003a02 <fileclose+0xba>
    800039b0:	7902                	ld	s2,32(sp)
    800039b2:	69e2                	ld	s3,24(sp)
    800039b4:	6a42                	ld	s4,16(sp)
    800039b6:	6aa2                	ld	s5,8(sp)
    800039b8:	a02d                	j	800039e2 <fileclose+0x9a>
    800039ba:	f04a                	sd	s2,32(sp)
    800039bc:	ec4e                	sd	s3,24(sp)
    800039be:	e852                	sd	s4,16(sp)
    800039c0:	e456                	sd	s5,8(sp)
    panic("fileclose");
    800039c2:	00005517          	auipc	a0,0x5
    800039c6:	b5650513          	addi	a0,a0,-1194 # 80008518 <etext+0x518>
    800039ca:	00002097          	auipc	ra,0x2
    800039ce:	278080e7          	jalr	632(ra) # 80005c42 <panic>
    release(&ftable.lock);
    800039d2:	00015517          	auipc	a0,0x15
    800039d6:	79650513          	addi	a0,a0,1942 # 80019168 <ftable>
    800039da:	00003097          	auipc	ra,0x3
    800039de:	898080e7          	jalr	-1896(ra) # 80006272 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    800039e2:	70e2                	ld	ra,56(sp)
    800039e4:	7442                	ld	s0,48(sp)
    800039e6:	74a2                	ld	s1,40(sp)
    800039e8:	6121                	addi	sp,sp,64
    800039ea:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    800039ec:	85d6                	mv	a1,s5
    800039ee:	8552                	mv	a0,s4
    800039f0:	00000097          	auipc	ra,0x0
    800039f4:	3ac080e7          	jalr	940(ra) # 80003d9c <pipeclose>
    800039f8:	7902                	ld	s2,32(sp)
    800039fa:	69e2                	ld	s3,24(sp)
    800039fc:	6a42                	ld	s4,16(sp)
    800039fe:	6aa2                	ld	s5,8(sp)
    80003a00:	b7cd                	j	800039e2 <fileclose+0x9a>
    begin_op();
    80003a02:	00000097          	auipc	ra,0x0
    80003a06:	a76080e7          	jalr	-1418(ra) # 80003478 <begin_op>
    iput(ff.ip);
    80003a0a:	854e                	mv	a0,s3
    80003a0c:	fffff097          	auipc	ra,0xfffff
    80003a10:	238080e7          	jalr	568(ra) # 80002c44 <iput>
    end_op();
    80003a14:	00000097          	auipc	ra,0x0
    80003a18:	ade080e7          	jalr	-1314(ra) # 800034f2 <end_op>
    80003a1c:	7902                	ld	s2,32(sp)
    80003a1e:	69e2                	ld	s3,24(sp)
    80003a20:	6a42                	ld	s4,16(sp)
    80003a22:	6aa2                	ld	s5,8(sp)
    80003a24:	bf7d                	j	800039e2 <fileclose+0x9a>

0000000080003a26 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003a26:	715d                	addi	sp,sp,-80
    80003a28:	e486                	sd	ra,72(sp)
    80003a2a:	e0a2                	sd	s0,64(sp)
    80003a2c:	fc26                	sd	s1,56(sp)
    80003a2e:	f44e                	sd	s3,40(sp)
    80003a30:	0880                	addi	s0,sp,80
    80003a32:	84aa                	mv	s1,a0
    80003a34:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003a36:	ffffd097          	auipc	ra,0xffffd
    80003a3a:	43e080e7          	jalr	1086(ra) # 80000e74 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003a3e:	409c                	lw	a5,0(s1)
    80003a40:	37f9                	addiw	a5,a5,-2
    80003a42:	4705                	li	a4,1
    80003a44:	04f76a63          	bltu	a4,a5,80003a98 <filestat+0x72>
    80003a48:	f84a                	sd	s2,48(sp)
    80003a4a:	f052                	sd	s4,32(sp)
    80003a4c:	892a                	mv	s2,a0
    ilock(f->ip);
    80003a4e:	6c88                	ld	a0,24(s1)
    80003a50:	fffff097          	auipc	ra,0xfffff
    80003a54:	036080e7          	jalr	54(ra) # 80002a86 <ilock>
    stati(f->ip, &st);
    80003a58:	fb840a13          	addi	s4,s0,-72
    80003a5c:	85d2                	mv	a1,s4
    80003a5e:	6c88                	ld	a0,24(s1)
    80003a60:	fffff097          	auipc	ra,0xfffff
    80003a64:	2b4080e7          	jalr	692(ra) # 80002d14 <stati>
    iunlock(f->ip);
    80003a68:	6c88                	ld	a0,24(s1)
    80003a6a:	fffff097          	auipc	ra,0xfffff
    80003a6e:	0e2080e7          	jalr	226(ra) # 80002b4c <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003a72:	46e1                	li	a3,24
    80003a74:	8652                	mv	a2,s4
    80003a76:	85ce                	mv	a1,s3
    80003a78:	05093503          	ld	a0,80(s2)
    80003a7c:	ffffd097          	auipc	ra,0xffffd
    80003a80:	0a4080e7          	jalr	164(ra) # 80000b20 <copyout>
    80003a84:	41f5551b          	sraiw	a0,a0,0x1f
    80003a88:	7942                	ld	s2,48(sp)
    80003a8a:	7a02                	ld	s4,32(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80003a8c:	60a6                	ld	ra,72(sp)
    80003a8e:	6406                	ld	s0,64(sp)
    80003a90:	74e2                	ld	s1,56(sp)
    80003a92:	79a2                	ld	s3,40(sp)
    80003a94:	6161                	addi	sp,sp,80
    80003a96:	8082                	ret
  return -1;
    80003a98:	557d                	li	a0,-1
    80003a9a:	bfcd                	j	80003a8c <filestat+0x66>

0000000080003a9c <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003a9c:	7179                	addi	sp,sp,-48
    80003a9e:	f406                	sd	ra,40(sp)
    80003aa0:	f022                	sd	s0,32(sp)
    80003aa2:	e84a                	sd	s2,16(sp)
    80003aa4:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003aa6:	00854783          	lbu	a5,8(a0)
    80003aaa:	cbc5                	beqz	a5,80003b5a <fileread+0xbe>
    80003aac:	ec26                	sd	s1,24(sp)
    80003aae:	e44e                	sd	s3,8(sp)
    80003ab0:	84aa                	mv	s1,a0
    80003ab2:	89ae                	mv	s3,a1
    80003ab4:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003ab6:	411c                	lw	a5,0(a0)
    80003ab8:	4705                	li	a4,1
    80003aba:	04e78963          	beq	a5,a4,80003b0c <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003abe:	470d                	li	a4,3
    80003ac0:	04e78f63          	beq	a5,a4,80003b1e <fileread+0x82>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003ac4:	4709                	li	a4,2
    80003ac6:	08e79263          	bne	a5,a4,80003b4a <fileread+0xae>
    ilock(f->ip);
    80003aca:	6d08                	ld	a0,24(a0)
    80003acc:	fffff097          	auipc	ra,0xfffff
    80003ad0:	fba080e7          	jalr	-70(ra) # 80002a86 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003ad4:	874a                	mv	a4,s2
    80003ad6:	5094                	lw	a3,32(s1)
    80003ad8:	864e                	mv	a2,s3
    80003ada:	4585                	li	a1,1
    80003adc:	6c88                	ld	a0,24(s1)
    80003ade:	fffff097          	auipc	ra,0xfffff
    80003ae2:	264080e7          	jalr	612(ra) # 80002d42 <readi>
    80003ae6:	892a                	mv	s2,a0
    80003ae8:	00a05563          	blez	a0,80003af2 <fileread+0x56>
      f->off += r;
    80003aec:	509c                	lw	a5,32(s1)
    80003aee:	9fa9                	addw	a5,a5,a0
    80003af0:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003af2:	6c88                	ld	a0,24(s1)
    80003af4:	fffff097          	auipc	ra,0xfffff
    80003af8:	058080e7          	jalr	88(ra) # 80002b4c <iunlock>
    80003afc:	64e2                	ld	s1,24(sp)
    80003afe:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80003b00:	854a                	mv	a0,s2
    80003b02:	70a2                	ld	ra,40(sp)
    80003b04:	7402                	ld	s0,32(sp)
    80003b06:	6942                	ld	s2,16(sp)
    80003b08:	6145                	addi	sp,sp,48
    80003b0a:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003b0c:	6908                	ld	a0,16(a0)
    80003b0e:	00000097          	auipc	ra,0x0
    80003b12:	414080e7          	jalr	1044(ra) # 80003f22 <piperead>
    80003b16:	892a                	mv	s2,a0
    80003b18:	64e2                	ld	s1,24(sp)
    80003b1a:	69a2                	ld	s3,8(sp)
    80003b1c:	b7d5                	j	80003b00 <fileread+0x64>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003b1e:	02451783          	lh	a5,36(a0)
    80003b22:	03079693          	slli	a3,a5,0x30
    80003b26:	92c1                	srli	a3,a3,0x30
    80003b28:	4725                	li	a4,9
    80003b2a:	02d76a63          	bltu	a4,a3,80003b5e <fileread+0xc2>
    80003b2e:	0792                	slli	a5,a5,0x4
    80003b30:	00015717          	auipc	a4,0x15
    80003b34:	59870713          	addi	a4,a4,1432 # 800190c8 <devsw>
    80003b38:	97ba                	add	a5,a5,a4
    80003b3a:	639c                	ld	a5,0(a5)
    80003b3c:	c78d                	beqz	a5,80003b66 <fileread+0xca>
    r = devsw[f->major].read(1, addr, n);
    80003b3e:	4505                	li	a0,1
    80003b40:	9782                	jalr	a5
    80003b42:	892a                	mv	s2,a0
    80003b44:	64e2                	ld	s1,24(sp)
    80003b46:	69a2                	ld	s3,8(sp)
    80003b48:	bf65                	j	80003b00 <fileread+0x64>
    panic("fileread");
    80003b4a:	00005517          	auipc	a0,0x5
    80003b4e:	9de50513          	addi	a0,a0,-1570 # 80008528 <etext+0x528>
    80003b52:	00002097          	auipc	ra,0x2
    80003b56:	0f0080e7          	jalr	240(ra) # 80005c42 <panic>
    return -1;
    80003b5a:	597d                	li	s2,-1
    80003b5c:	b755                	j	80003b00 <fileread+0x64>
      return -1;
    80003b5e:	597d                	li	s2,-1
    80003b60:	64e2                	ld	s1,24(sp)
    80003b62:	69a2                	ld	s3,8(sp)
    80003b64:	bf71                	j	80003b00 <fileread+0x64>
    80003b66:	597d                	li	s2,-1
    80003b68:	64e2                	ld	s1,24(sp)
    80003b6a:	69a2                	ld	s3,8(sp)
    80003b6c:	bf51                	j	80003b00 <fileread+0x64>

0000000080003b6e <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003b6e:	00954783          	lbu	a5,9(a0)
    80003b72:	12078c63          	beqz	a5,80003caa <filewrite+0x13c>
{
    80003b76:	711d                	addi	sp,sp,-96
    80003b78:	ec86                	sd	ra,88(sp)
    80003b7a:	e8a2                	sd	s0,80(sp)
    80003b7c:	e0ca                	sd	s2,64(sp)
    80003b7e:	f456                	sd	s5,40(sp)
    80003b80:	f05a                	sd	s6,32(sp)
    80003b82:	1080                	addi	s0,sp,96
    80003b84:	892a                	mv	s2,a0
    80003b86:	8b2e                	mv	s6,a1
    80003b88:	8ab2                	mv	s5,a2
    return -1;

  if(f->type == FD_PIPE){
    80003b8a:	411c                	lw	a5,0(a0)
    80003b8c:	4705                	li	a4,1
    80003b8e:	02e78963          	beq	a5,a4,80003bc0 <filewrite+0x52>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003b92:	470d                	li	a4,3
    80003b94:	02e78c63          	beq	a5,a4,80003bcc <filewrite+0x5e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003b98:	4709                	li	a4,2
    80003b9a:	0ee79a63          	bne	a5,a4,80003c8e <filewrite+0x120>
    80003b9e:	f852                	sd	s4,48(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003ba0:	0cc05563          	blez	a2,80003c6a <filewrite+0xfc>
    80003ba4:	e4a6                	sd	s1,72(sp)
    80003ba6:	fc4e                	sd	s3,56(sp)
    80003ba8:	ec5e                	sd	s7,24(sp)
    80003baa:	e862                	sd	s8,16(sp)
    80003bac:	e466                	sd	s9,8(sp)
    int i = 0;
    80003bae:	4a01                	li	s4,0
      int n1 = n - i;
      if(n1 > max)
    80003bb0:	6b85                	lui	s7,0x1
    80003bb2:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003bb6:	6c85                	lui	s9,0x1
    80003bb8:	c00c8c9b          	addiw	s9,s9,-1024 # c00 <_entry-0x7ffff400>
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003bbc:	4c05                	li	s8,1
    80003bbe:	a849                	j	80003c50 <filewrite+0xe2>
    ret = pipewrite(f->pipe, addr, n);
    80003bc0:	6908                	ld	a0,16(a0)
    80003bc2:	00000097          	auipc	ra,0x0
    80003bc6:	24a080e7          	jalr	586(ra) # 80003e0c <pipewrite>
    80003bca:	a85d                	j	80003c80 <filewrite+0x112>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003bcc:	02451783          	lh	a5,36(a0)
    80003bd0:	03079693          	slli	a3,a5,0x30
    80003bd4:	92c1                	srli	a3,a3,0x30
    80003bd6:	4725                	li	a4,9
    80003bd8:	0cd76b63          	bltu	a4,a3,80003cae <filewrite+0x140>
    80003bdc:	0792                	slli	a5,a5,0x4
    80003bde:	00015717          	auipc	a4,0x15
    80003be2:	4ea70713          	addi	a4,a4,1258 # 800190c8 <devsw>
    80003be6:	97ba                	add	a5,a5,a4
    80003be8:	679c                	ld	a5,8(a5)
    80003bea:	c7e1                	beqz	a5,80003cb2 <filewrite+0x144>
    ret = devsw[f->major].write(1, addr, n);
    80003bec:	4505                	li	a0,1
    80003bee:	9782                	jalr	a5
    80003bf0:	a841                	j	80003c80 <filewrite+0x112>
      if(n1 > max)
    80003bf2:	2981                	sext.w	s3,s3
      begin_op();
    80003bf4:	00000097          	auipc	ra,0x0
    80003bf8:	884080e7          	jalr	-1916(ra) # 80003478 <begin_op>
      ilock(f->ip);
    80003bfc:	01893503          	ld	a0,24(s2)
    80003c00:	fffff097          	auipc	ra,0xfffff
    80003c04:	e86080e7          	jalr	-378(ra) # 80002a86 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003c08:	874e                	mv	a4,s3
    80003c0a:	02092683          	lw	a3,32(s2)
    80003c0e:	016a0633          	add	a2,s4,s6
    80003c12:	85e2                	mv	a1,s8
    80003c14:	01893503          	ld	a0,24(s2)
    80003c18:	fffff097          	auipc	ra,0xfffff
    80003c1c:	224080e7          	jalr	548(ra) # 80002e3c <writei>
    80003c20:	84aa                	mv	s1,a0
    80003c22:	00a05763          	blez	a0,80003c30 <filewrite+0xc2>
        f->off += r;
    80003c26:	02092783          	lw	a5,32(s2)
    80003c2a:	9fa9                	addw	a5,a5,a0
    80003c2c:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003c30:	01893503          	ld	a0,24(s2)
    80003c34:	fffff097          	auipc	ra,0xfffff
    80003c38:	f18080e7          	jalr	-232(ra) # 80002b4c <iunlock>
      end_op();
    80003c3c:	00000097          	auipc	ra,0x0
    80003c40:	8b6080e7          	jalr	-1866(ra) # 800034f2 <end_op>

      if(r != n1){
    80003c44:	02999563          	bne	s3,s1,80003c6e <filewrite+0x100>
        // error from writei
        break;
      }
      i += r;
    80003c48:	01448a3b          	addw	s4,s1,s4
    while(i < n){
    80003c4c:	015a5963          	bge	s4,s5,80003c5e <filewrite+0xf0>
      int n1 = n - i;
    80003c50:	414a87bb          	subw	a5,s5,s4
    80003c54:	89be                	mv	s3,a5
      if(n1 > max)
    80003c56:	f8fbdee3          	bge	s7,a5,80003bf2 <filewrite+0x84>
    80003c5a:	89e6                	mv	s3,s9
    80003c5c:	bf59                	j	80003bf2 <filewrite+0x84>
    80003c5e:	64a6                	ld	s1,72(sp)
    80003c60:	79e2                	ld	s3,56(sp)
    80003c62:	6be2                	ld	s7,24(sp)
    80003c64:	6c42                	ld	s8,16(sp)
    80003c66:	6ca2                	ld	s9,8(sp)
    80003c68:	a801                	j	80003c78 <filewrite+0x10a>
    int i = 0;
    80003c6a:	4a01                	li	s4,0
    80003c6c:	a031                	j	80003c78 <filewrite+0x10a>
    80003c6e:	64a6                	ld	s1,72(sp)
    80003c70:	79e2                	ld	s3,56(sp)
    80003c72:	6be2                	ld	s7,24(sp)
    80003c74:	6c42                	ld	s8,16(sp)
    80003c76:	6ca2                	ld	s9,8(sp)
    }
    ret = (i == n ? n : -1);
    80003c78:	034a9f63          	bne	s5,s4,80003cb6 <filewrite+0x148>
    80003c7c:	8556                	mv	a0,s5
    80003c7e:	7a42                	ld	s4,48(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003c80:	60e6                	ld	ra,88(sp)
    80003c82:	6446                	ld	s0,80(sp)
    80003c84:	6906                	ld	s2,64(sp)
    80003c86:	7aa2                	ld	s5,40(sp)
    80003c88:	7b02                	ld	s6,32(sp)
    80003c8a:	6125                	addi	sp,sp,96
    80003c8c:	8082                	ret
    80003c8e:	e4a6                	sd	s1,72(sp)
    80003c90:	fc4e                	sd	s3,56(sp)
    80003c92:	f852                	sd	s4,48(sp)
    80003c94:	ec5e                	sd	s7,24(sp)
    80003c96:	e862                	sd	s8,16(sp)
    80003c98:	e466                	sd	s9,8(sp)
    panic("filewrite");
    80003c9a:	00005517          	auipc	a0,0x5
    80003c9e:	89e50513          	addi	a0,a0,-1890 # 80008538 <etext+0x538>
    80003ca2:	00002097          	auipc	ra,0x2
    80003ca6:	fa0080e7          	jalr	-96(ra) # 80005c42 <panic>
    return -1;
    80003caa:	557d                	li	a0,-1
}
    80003cac:	8082                	ret
      return -1;
    80003cae:	557d                	li	a0,-1
    80003cb0:	bfc1                	j	80003c80 <filewrite+0x112>
    80003cb2:	557d                	li	a0,-1
    80003cb4:	b7f1                	j	80003c80 <filewrite+0x112>
    ret = (i == n ? n : -1);
    80003cb6:	557d                	li	a0,-1
    80003cb8:	7a42                	ld	s4,48(sp)
    80003cba:	b7d9                	j	80003c80 <filewrite+0x112>

0000000080003cbc <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003cbc:	7179                	addi	sp,sp,-48
    80003cbe:	f406                	sd	ra,40(sp)
    80003cc0:	f022                	sd	s0,32(sp)
    80003cc2:	ec26                	sd	s1,24(sp)
    80003cc4:	e052                	sd	s4,0(sp)
    80003cc6:	1800                	addi	s0,sp,48
    80003cc8:	84aa                	mv	s1,a0
    80003cca:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003ccc:	0005b023          	sd	zero,0(a1)
    80003cd0:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003cd4:	00000097          	auipc	ra,0x0
    80003cd8:	bb8080e7          	jalr	-1096(ra) # 8000388c <filealloc>
    80003cdc:	e088                	sd	a0,0(s1)
    80003cde:	cd49                	beqz	a0,80003d78 <pipealloc+0xbc>
    80003ce0:	00000097          	auipc	ra,0x0
    80003ce4:	bac080e7          	jalr	-1108(ra) # 8000388c <filealloc>
    80003ce8:	00aa3023          	sd	a0,0(s4)
    80003cec:	c141                	beqz	a0,80003d6c <pipealloc+0xb0>
    80003cee:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003cf0:	ffffc097          	auipc	ra,0xffffc
    80003cf4:	42a080e7          	jalr	1066(ra) # 8000011a <kalloc>
    80003cf8:	892a                	mv	s2,a0
    80003cfa:	c13d                	beqz	a0,80003d60 <pipealloc+0xa4>
    80003cfc:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80003cfe:	4985                	li	s3,1
    80003d00:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003d04:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003d08:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003d0c:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003d10:	00005597          	auipc	a1,0x5
    80003d14:	83858593          	addi	a1,a1,-1992 # 80008548 <etext+0x548>
    80003d18:	00002097          	auipc	ra,0x2
    80003d1c:	416080e7          	jalr	1046(ra) # 8000612e <initlock>
  (*f0)->type = FD_PIPE;
    80003d20:	609c                	ld	a5,0(s1)
    80003d22:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003d26:	609c                	ld	a5,0(s1)
    80003d28:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003d2c:	609c                	ld	a5,0(s1)
    80003d2e:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003d32:	609c                	ld	a5,0(s1)
    80003d34:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003d38:	000a3783          	ld	a5,0(s4)
    80003d3c:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003d40:	000a3783          	ld	a5,0(s4)
    80003d44:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003d48:	000a3783          	ld	a5,0(s4)
    80003d4c:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003d50:	000a3783          	ld	a5,0(s4)
    80003d54:	0127b823          	sd	s2,16(a5)
  return 0;
    80003d58:	4501                	li	a0,0
    80003d5a:	6942                	ld	s2,16(sp)
    80003d5c:	69a2                	ld	s3,8(sp)
    80003d5e:	a03d                	j	80003d8c <pipealloc+0xd0>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003d60:	6088                	ld	a0,0(s1)
    80003d62:	c119                	beqz	a0,80003d68 <pipealloc+0xac>
    80003d64:	6942                	ld	s2,16(sp)
    80003d66:	a029                	j	80003d70 <pipealloc+0xb4>
    80003d68:	6942                	ld	s2,16(sp)
    80003d6a:	a039                	j	80003d78 <pipealloc+0xbc>
    80003d6c:	6088                	ld	a0,0(s1)
    80003d6e:	c50d                	beqz	a0,80003d98 <pipealloc+0xdc>
    fileclose(*f0);
    80003d70:	00000097          	auipc	ra,0x0
    80003d74:	bd8080e7          	jalr	-1064(ra) # 80003948 <fileclose>
  if(*f1)
    80003d78:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003d7c:	557d                	li	a0,-1
  if(*f1)
    80003d7e:	c799                	beqz	a5,80003d8c <pipealloc+0xd0>
    fileclose(*f1);
    80003d80:	853e                	mv	a0,a5
    80003d82:	00000097          	auipc	ra,0x0
    80003d86:	bc6080e7          	jalr	-1082(ra) # 80003948 <fileclose>
  return -1;
    80003d8a:	557d                	li	a0,-1
}
    80003d8c:	70a2                	ld	ra,40(sp)
    80003d8e:	7402                	ld	s0,32(sp)
    80003d90:	64e2                	ld	s1,24(sp)
    80003d92:	6a02                	ld	s4,0(sp)
    80003d94:	6145                	addi	sp,sp,48
    80003d96:	8082                	ret
  return -1;
    80003d98:	557d                	li	a0,-1
    80003d9a:	bfcd                	j	80003d8c <pipealloc+0xd0>

0000000080003d9c <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003d9c:	1101                	addi	sp,sp,-32
    80003d9e:	ec06                	sd	ra,24(sp)
    80003da0:	e822                	sd	s0,16(sp)
    80003da2:	e426                	sd	s1,8(sp)
    80003da4:	e04a                	sd	s2,0(sp)
    80003da6:	1000                	addi	s0,sp,32
    80003da8:	84aa                	mv	s1,a0
    80003daa:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003dac:	00002097          	auipc	ra,0x2
    80003db0:	416080e7          	jalr	1046(ra) # 800061c2 <acquire>
  if(writable){
    80003db4:	02090d63          	beqz	s2,80003dee <pipeclose+0x52>
    pi->writeopen = 0;
    80003db8:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003dbc:	21848513          	addi	a0,s1,536
    80003dc0:	ffffe097          	auipc	ra,0xffffe
    80003dc4:	900080e7          	jalr	-1792(ra) # 800016c0 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003dc8:	2204b783          	ld	a5,544(s1)
    80003dcc:	eb95                	bnez	a5,80003e00 <pipeclose+0x64>
    release(&pi->lock);
    80003dce:	8526                	mv	a0,s1
    80003dd0:	00002097          	auipc	ra,0x2
    80003dd4:	4a2080e7          	jalr	1186(ra) # 80006272 <release>
    kfree((char*)pi);
    80003dd8:	8526                	mv	a0,s1
    80003dda:	ffffc097          	auipc	ra,0xffffc
    80003dde:	242080e7          	jalr	578(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003de2:	60e2                	ld	ra,24(sp)
    80003de4:	6442                	ld	s0,16(sp)
    80003de6:	64a2                	ld	s1,8(sp)
    80003de8:	6902                	ld	s2,0(sp)
    80003dea:	6105                	addi	sp,sp,32
    80003dec:	8082                	ret
    pi->readopen = 0;
    80003dee:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003df2:	21c48513          	addi	a0,s1,540
    80003df6:	ffffe097          	auipc	ra,0xffffe
    80003dfa:	8ca080e7          	jalr	-1846(ra) # 800016c0 <wakeup>
    80003dfe:	b7e9                	j	80003dc8 <pipeclose+0x2c>
    release(&pi->lock);
    80003e00:	8526                	mv	a0,s1
    80003e02:	00002097          	auipc	ra,0x2
    80003e06:	470080e7          	jalr	1136(ra) # 80006272 <release>
}
    80003e0a:	bfe1                	j	80003de2 <pipeclose+0x46>

0000000080003e0c <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003e0c:	7159                	addi	sp,sp,-112
    80003e0e:	f486                	sd	ra,104(sp)
    80003e10:	f0a2                	sd	s0,96(sp)
    80003e12:	eca6                	sd	s1,88(sp)
    80003e14:	e8ca                	sd	s2,80(sp)
    80003e16:	e4ce                	sd	s3,72(sp)
    80003e18:	e0d2                	sd	s4,64(sp)
    80003e1a:	fc56                	sd	s5,56(sp)
    80003e1c:	1880                	addi	s0,sp,112
    80003e1e:	84aa                	mv	s1,a0
    80003e20:	8aae                	mv	s5,a1
    80003e22:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003e24:	ffffd097          	auipc	ra,0xffffd
    80003e28:	050080e7          	jalr	80(ra) # 80000e74 <myproc>
    80003e2c:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003e2e:	8526                	mv	a0,s1
    80003e30:	00002097          	auipc	ra,0x2
    80003e34:	392080e7          	jalr	914(ra) # 800061c2 <acquire>
  while(i < n){
    80003e38:	0d405d63          	blez	s4,80003f12 <pipewrite+0x106>
    80003e3c:	f85a                	sd	s6,48(sp)
    80003e3e:	f45e                	sd	s7,40(sp)
    80003e40:	f062                	sd	s8,32(sp)
    80003e42:	ec66                	sd	s9,24(sp)
    80003e44:	e86a                	sd	s10,16(sp)
  int i = 0;
    80003e46:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003e48:	f9f40c13          	addi	s8,s0,-97
    80003e4c:	4b85                	li	s7,1
    80003e4e:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003e50:	21848d13          	addi	s10,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003e54:	21c48c93          	addi	s9,s1,540
    80003e58:	a099                	j	80003e9e <pipewrite+0x92>
      release(&pi->lock);
    80003e5a:	8526                	mv	a0,s1
    80003e5c:	00002097          	auipc	ra,0x2
    80003e60:	416080e7          	jalr	1046(ra) # 80006272 <release>
      return -1;
    80003e64:	597d                	li	s2,-1
    80003e66:	7b42                	ld	s6,48(sp)
    80003e68:	7ba2                	ld	s7,40(sp)
    80003e6a:	7c02                	ld	s8,32(sp)
    80003e6c:	6ce2                	ld	s9,24(sp)
    80003e6e:	6d42                	ld	s10,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003e70:	854a                	mv	a0,s2
    80003e72:	70a6                	ld	ra,104(sp)
    80003e74:	7406                	ld	s0,96(sp)
    80003e76:	64e6                	ld	s1,88(sp)
    80003e78:	6946                	ld	s2,80(sp)
    80003e7a:	69a6                	ld	s3,72(sp)
    80003e7c:	6a06                	ld	s4,64(sp)
    80003e7e:	7ae2                	ld	s5,56(sp)
    80003e80:	6165                	addi	sp,sp,112
    80003e82:	8082                	ret
      wakeup(&pi->nread);
    80003e84:	856a                	mv	a0,s10
    80003e86:	ffffe097          	auipc	ra,0xffffe
    80003e8a:	83a080e7          	jalr	-1990(ra) # 800016c0 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003e8e:	85a6                	mv	a1,s1
    80003e90:	8566                	mv	a0,s9
    80003e92:	ffffd097          	auipc	ra,0xffffd
    80003e96:	6a8080e7          	jalr	1704(ra) # 8000153a <sleep>
  while(i < n){
    80003e9a:	05495b63          	bge	s2,s4,80003ef0 <pipewrite+0xe4>
    if(pi->readopen == 0 || pr->killed){
    80003e9e:	2204a783          	lw	a5,544(s1)
    80003ea2:	dfc5                	beqz	a5,80003e5a <pipewrite+0x4e>
    80003ea4:	0289a783          	lw	a5,40(s3)
    80003ea8:	fbcd                	bnez	a5,80003e5a <pipewrite+0x4e>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003eaa:	2184a783          	lw	a5,536(s1)
    80003eae:	21c4a703          	lw	a4,540(s1)
    80003eb2:	2007879b          	addiw	a5,a5,512
    80003eb6:	fcf707e3          	beq	a4,a5,80003e84 <pipewrite+0x78>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003eba:	86de                	mv	a3,s7
    80003ebc:	01590633          	add	a2,s2,s5
    80003ec0:	85e2                	mv	a1,s8
    80003ec2:	0509b503          	ld	a0,80(s3)
    80003ec6:	ffffd097          	auipc	ra,0xffffd
    80003eca:	ce6080e7          	jalr	-794(ra) # 80000bac <copyin>
    80003ece:	05650463          	beq	a0,s6,80003f16 <pipewrite+0x10a>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003ed2:	21c4a783          	lw	a5,540(s1)
    80003ed6:	0017871b          	addiw	a4,a5,1
    80003eda:	20e4ae23          	sw	a4,540(s1)
    80003ede:	1ff7f793          	andi	a5,a5,511
    80003ee2:	97a6                	add	a5,a5,s1
    80003ee4:	f9f44703          	lbu	a4,-97(s0)
    80003ee8:	00e78c23          	sb	a4,24(a5)
      i++;
    80003eec:	2905                	addiw	s2,s2,1
    80003eee:	b775                	j	80003e9a <pipewrite+0x8e>
    80003ef0:	7b42                	ld	s6,48(sp)
    80003ef2:	7ba2                	ld	s7,40(sp)
    80003ef4:	7c02                	ld	s8,32(sp)
    80003ef6:	6ce2                	ld	s9,24(sp)
    80003ef8:	6d42                	ld	s10,16(sp)
  wakeup(&pi->nread);
    80003efa:	21848513          	addi	a0,s1,536
    80003efe:	ffffd097          	auipc	ra,0xffffd
    80003f02:	7c2080e7          	jalr	1986(ra) # 800016c0 <wakeup>
  release(&pi->lock);
    80003f06:	8526                	mv	a0,s1
    80003f08:	00002097          	auipc	ra,0x2
    80003f0c:	36a080e7          	jalr	874(ra) # 80006272 <release>
  return i;
    80003f10:	b785                	j	80003e70 <pipewrite+0x64>
  int i = 0;
    80003f12:	4901                	li	s2,0
    80003f14:	b7dd                	j	80003efa <pipewrite+0xee>
    80003f16:	7b42                	ld	s6,48(sp)
    80003f18:	7ba2                	ld	s7,40(sp)
    80003f1a:	7c02                	ld	s8,32(sp)
    80003f1c:	6ce2                	ld	s9,24(sp)
    80003f1e:	6d42                	ld	s10,16(sp)
    80003f20:	bfe9                	j	80003efa <pipewrite+0xee>

0000000080003f22 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003f22:	711d                	addi	sp,sp,-96
    80003f24:	ec86                	sd	ra,88(sp)
    80003f26:	e8a2                	sd	s0,80(sp)
    80003f28:	e4a6                	sd	s1,72(sp)
    80003f2a:	e0ca                	sd	s2,64(sp)
    80003f2c:	fc4e                	sd	s3,56(sp)
    80003f2e:	f852                	sd	s4,48(sp)
    80003f30:	f456                	sd	s5,40(sp)
    80003f32:	1080                	addi	s0,sp,96
    80003f34:	84aa                	mv	s1,a0
    80003f36:	892e                	mv	s2,a1
    80003f38:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003f3a:	ffffd097          	auipc	ra,0xffffd
    80003f3e:	f3a080e7          	jalr	-198(ra) # 80000e74 <myproc>
    80003f42:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003f44:	8526                	mv	a0,s1
    80003f46:	00002097          	auipc	ra,0x2
    80003f4a:	27c080e7          	jalr	636(ra) # 800061c2 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003f4e:	2184a703          	lw	a4,536(s1)
    80003f52:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003f56:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003f5a:	02f71863          	bne	a4,a5,80003f8a <piperead+0x68>
    80003f5e:	2244a783          	lw	a5,548(s1)
    80003f62:	cf9d                	beqz	a5,80003fa0 <piperead+0x7e>
    if(pr->killed){
    80003f64:	028a2783          	lw	a5,40(s4)
    80003f68:	e78d                	bnez	a5,80003f92 <piperead+0x70>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003f6a:	85a6                	mv	a1,s1
    80003f6c:	854e                	mv	a0,s3
    80003f6e:	ffffd097          	auipc	ra,0xffffd
    80003f72:	5cc080e7          	jalr	1484(ra) # 8000153a <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003f76:	2184a703          	lw	a4,536(s1)
    80003f7a:	21c4a783          	lw	a5,540(s1)
    80003f7e:	fef700e3          	beq	a4,a5,80003f5e <piperead+0x3c>
    80003f82:	f05a                	sd	s6,32(sp)
    80003f84:	ec5e                	sd	s7,24(sp)
    80003f86:	e862                	sd	s8,16(sp)
    80003f88:	a839                	j	80003fa6 <piperead+0x84>
    80003f8a:	f05a                	sd	s6,32(sp)
    80003f8c:	ec5e                	sd	s7,24(sp)
    80003f8e:	e862                	sd	s8,16(sp)
    80003f90:	a819                	j	80003fa6 <piperead+0x84>
      release(&pi->lock);
    80003f92:	8526                	mv	a0,s1
    80003f94:	00002097          	auipc	ra,0x2
    80003f98:	2de080e7          	jalr	734(ra) # 80006272 <release>
      return -1;
    80003f9c:	59fd                	li	s3,-1
    80003f9e:	a895                	j	80004012 <piperead+0xf0>
    80003fa0:	f05a                	sd	s6,32(sp)
    80003fa2:	ec5e                	sd	s7,24(sp)
    80003fa4:	e862                	sd	s8,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003fa6:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003fa8:	faf40c13          	addi	s8,s0,-81
    80003fac:	4b85                	li	s7,1
    80003fae:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003fb0:	05505363          	blez	s5,80003ff6 <piperead+0xd4>
    if(pi->nread == pi->nwrite)
    80003fb4:	2184a783          	lw	a5,536(s1)
    80003fb8:	21c4a703          	lw	a4,540(s1)
    80003fbc:	02f70d63          	beq	a4,a5,80003ff6 <piperead+0xd4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80003fc0:	0017871b          	addiw	a4,a5,1
    80003fc4:	20e4ac23          	sw	a4,536(s1)
    80003fc8:	1ff7f793          	andi	a5,a5,511
    80003fcc:	97a6                	add	a5,a5,s1
    80003fce:	0187c783          	lbu	a5,24(a5)
    80003fd2:	faf407a3          	sb	a5,-81(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003fd6:	86de                	mv	a3,s7
    80003fd8:	8662                	mv	a2,s8
    80003fda:	85ca                	mv	a1,s2
    80003fdc:	050a3503          	ld	a0,80(s4)
    80003fe0:	ffffd097          	auipc	ra,0xffffd
    80003fe4:	b40080e7          	jalr	-1216(ra) # 80000b20 <copyout>
    80003fe8:	01650763          	beq	a0,s6,80003ff6 <piperead+0xd4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003fec:	2985                	addiw	s3,s3,1
    80003fee:	0905                	addi	s2,s2,1
    80003ff0:	fd3a92e3          	bne	s5,s3,80003fb4 <piperead+0x92>
    80003ff4:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80003ff6:	21c48513          	addi	a0,s1,540
    80003ffa:	ffffd097          	auipc	ra,0xffffd
    80003ffe:	6c6080e7          	jalr	1734(ra) # 800016c0 <wakeup>
  release(&pi->lock);
    80004002:	8526                	mv	a0,s1
    80004004:	00002097          	auipc	ra,0x2
    80004008:	26e080e7          	jalr	622(ra) # 80006272 <release>
    8000400c:	7b02                	ld	s6,32(sp)
    8000400e:	6be2                	ld	s7,24(sp)
    80004010:	6c42                	ld	s8,16(sp)
  return i;
}
    80004012:	854e                	mv	a0,s3
    80004014:	60e6                	ld	ra,88(sp)
    80004016:	6446                	ld	s0,80(sp)
    80004018:	64a6                	ld	s1,72(sp)
    8000401a:	6906                	ld	s2,64(sp)
    8000401c:	79e2                	ld	s3,56(sp)
    8000401e:	7a42                	ld	s4,48(sp)
    80004020:	7aa2                	ld	s5,40(sp)
    80004022:	6125                	addi	sp,sp,96
    80004024:	8082                	ret

0000000080004026 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80004026:	de010113          	addi	sp,sp,-544
    8000402a:	20113c23          	sd	ra,536(sp)
    8000402e:	20813823          	sd	s0,528(sp)
    80004032:	20913423          	sd	s1,520(sp)
    80004036:	21213023          	sd	s2,512(sp)
    8000403a:	1400                	addi	s0,sp,544
    8000403c:	892a                	mv	s2,a0
    8000403e:	dea43823          	sd	a0,-528(s0)
    80004042:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004046:	ffffd097          	auipc	ra,0xffffd
    8000404a:	e2e080e7          	jalr	-466(ra) # 80000e74 <myproc>
    8000404e:	84aa                	mv	s1,a0

  begin_op();
    80004050:	fffff097          	auipc	ra,0xfffff
    80004054:	428080e7          	jalr	1064(ra) # 80003478 <begin_op>

  if((ip = namei(path)) == 0){
    80004058:	854a                	mv	a0,s2
    8000405a:	fffff097          	auipc	ra,0xfffff
    8000405e:	218080e7          	jalr	536(ra) # 80003272 <namei>
    80004062:	c525                	beqz	a0,800040ca <exec+0xa4>
    80004064:	fbd2                	sd	s4,496(sp)
    80004066:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004068:	fffff097          	auipc	ra,0xfffff
    8000406c:	a1e080e7          	jalr	-1506(ra) # 80002a86 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004070:	04000713          	li	a4,64
    80004074:	4681                	li	a3,0
    80004076:	e5040613          	addi	a2,s0,-432
    8000407a:	4581                	li	a1,0
    8000407c:	8552                	mv	a0,s4
    8000407e:	fffff097          	auipc	ra,0xfffff
    80004082:	cc4080e7          	jalr	-828(ra) # 80002d42 <readi>
    80004086:	04000793          	li	a5,64
    8000408a:	00f51a63          	bne	a0,a5,8000409e <exec+0x78>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    8000408e:	e5042703          	lw	a4,-432(s0)
    80004092:	464c47b7          	lui	a5,0x464c4
    80004096:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000409a:	02f70e63          	beq	a4,a5,800040d6 <exec+0xb0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    8000409e:	8552                	mv	a0,s4
    800040a0:	fffff097          	auipc	ra,0xfffff
    800040a4:	c4c080e7          	jalr	-948(ra) # 80002cec <iunlockput>
    end_op();
    800040a8:	fffff097          	auipc	ra,0xfffff
    800040ac:	44a080e7          	jalr	1098(ra) # 800034f2 <end_op>
  }
  return -1;
    800040b0:	557d                	li	a0,-1
    800040b2:	7a5e                	ld	s4,496(sp)
}
    800040b4:	21813083          	ld	ra,536(sp)
    800040b8:	21013403          	ld	s0,528(sp)
    800040bc:	20813483          	ld	s1,520(sp)
    800040c0:	20013903          	ld	s2,512(sp)
    800040c4:	22010113          	addi	sp,sp,544
    800040c8:	8082                	ret
    end_op();
    800040ca:	fffff097          	auipc	ra,0xfffff
    800040ce:	428080e7          	jalr	1064(ra) # 800034f2 <end_op>
    return -1;
    800040d2:	557d                	li	a0,-1
    800040d4:	b7c5                	j	800040b4 <exec+0x8e>
    800040d6:	f3da                	sd	s6,480(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    800040d8:	8526                	mv	a0,s1
    800040da:	ffffd097          	auipc	ra,0xffffd
    800040de:	e5e080e7          	jalr	-418(ra) # 80000f38 <proc_pagetable>
    800040e2:	8b2a                	mv	s6,a0
    800040e4:	2a050863          	beqz	a0,80004394 <exec+0x36e>
    800040e8:	ffce                	sd	s3,504(sp)
    800040ea:	f7d6                	sd	s5,488(sp)
    800040ec:	efde                	sd	s7,472(sp)
    800040ee:	ebe2                	sd	s8,464(sp)
    800040f0:	e7e6                	sd	s9,456(sp)
    800040f2:	e3ea                	sd	s10,448(sp)
    800040f4:	ff6e                	sd	s11,440(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800040f6:	e7042683          	lw	a3,-400(s0)
    800040fa:	e8845783          	lhu	a5,-376(s0)
    800040fe:	cbfd                	beqz	a5,800041f4 <exec+0x1ce>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004100:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004102:	4d01                	li	s10,0
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004104:	03800d93          	li	s11,56
    if((ph.vaddr % PGSIZE) != 0)
    80004108:	6c85                	lui	s9,0x1
    8000410a:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    8000410e:	def43423          	sd	a5,-536(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80004112:	6a85                	lui	s5,0x1
    80004114:	a0b5                	j	80004180 <exec+0x15a>
      panic("loadseg: address should exist");
    80004116:	00004517          	auipc	a0,0x4
    8000411a:	43a50513          	addi	a0,a0,1082 # 80008550 <etext+0x550>
    8000411e:	00002097          	auipc	ra,0x2
    80004122:	b24080e7          	jalr	-1244(ra) # 80005c42 <panic>
    if(sz - i < PGSIZE)
    80004126:	2901                	sext.w	s2,s2
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004128:	874a                	mv	a4,s2
    8000412a:	009c06bb          	addw	a3,s8,s1
    8000412e:	4581                	li	a1,0
    80004130:	8552                	mv	a0,s4
    80004132:	fffff097          	auipc	ra,0xfffff
    80004136:	c10080e7          	jalr	-1008(ra) # 80002d42 <readi>
    8000413a:	26a91163          	bne	s2,a0,8000439c <exec+0x376>
  for(i = 0; i < sz; i += PGSIZE){
    8000413e:	009a84bb          	addw	s1,s5,s1
    80004142:	0334f463          	bgeu	s1,s3,8000416a <exec+0x144>
    pa = walkaddr(pagetable, va + i);
    80004146:	02049593          	slli	a1,s1,0x20
    8000414a:	9181                	srli	a1,a1,0x20
    8000414c:	95de                	add	a1,a1,s7
    8000414e:	855a                	mv	a0,s6
    80004150:	ffffc097          	auipc	ra,0xffffc
    80004154:	3c8080e7          	jalr	968(ra) # 80000518 <walkaddr>
    80004158:	862a                	mv	a2,a0
    if(pa == 0)
    8000415a:	dd55                	beqz	a0,80004116 <exec+0xf0>
    if(sz - i < PGSIZE)
    8000415c:	409987bb          	subw	a5,s3,s1
    80004160:	893e                	mv	s2,a5
    80004162:	fcfcf2e3          	bgeu	s9,a5,80004126 <exec+0x100>
    80004166:	8956                	mv	s2,s5
    80004168:	bf7d                	j	80004126 <exec+0x100>
    sz = sz1;
    8000416a:	df843483          	ld	s1,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000416e:	2d05                	addiw	s10,s10,1
    80004170:	e0843783          	ld	a5,-504(s0)
    80004174:	0387869b          	addiw	a3,a5,56
    80004178:	e8845783          	lhu	a5,-376(s0)
    8000417c:	06fd5d63          	bge	s10,a5,800041f6 <exec+0x1d0>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004180:	e0d43423          	sd	a3,-504(s0)
    80004184:	876e                	mv	a4,s11
    80004186:	e1840613          	addi	a2,s0,-488
    8000418a:	4581                	li	a1,0
    8000418c:	8552                	mv	a0,s4
    8000418e:	fffff097          	auipc	ra,0xfffff
    80004192:	bb4080e7          	jalr	-1100(ra) # 80002d42 <readi>
    80004196:	21b51163          	bne	a0,s11,80004398 <exec+0x372>
    if(ph.type != ELF_PROG_LOAD)
    8000419a:	e1842783          	lw	a5,-488(s0)
    8000419e:	4705                	li	a4,1
    800041a0:	fce797e3          	bne	a5,a4,8000416e <exec+0x148>
    if(ph.memsz < ph.filesz)
    800041a4:	e4043603          	ld	a2,-448(s0)
    800041a8:	e3843783          	ld	a5,-456(s0)
    800041ac:	20f66863          	bltu	a2,a5,800043bc <exec+0x396>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800041b0:	e2843783          	ld	a5,-472(s0)
    800041b4:	963e                	add	a2,a2,a5
    800041b6:	20f66663          	bltu	a2,a5,800043c2 <exec+0x39c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800041ba:	85a6                	mv	a1,s1
    800041bc:	855a                	mv	a0,s6
    800041be:	ffffc097          	auipc	ra,0xffffc
    800041c2:	71e080e7          	jalr	1822(ra) # 800008dc <uvmalloc>
    800041c6:	dea43c23          	sd	a0,-520(s0)
    800041ca:	1e050f63          	beqz	a0,800043c8 <exec+0x3a2>
    if((ph.vaddr % PGSIZE) != 0)
    800041ce:	e2843b83          	ld	s7,-472(s0)
    800041d2:	de843783          	ld	a5,-536(s0)
    800041d6:	00fbf7b3          	and	a5,s7,a5
    800041da:	1c079163          	bnez	a5,8000439c <exec+0x376>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800041de:	e2042c03          	lw	s8,-480(s0)
    800041e2:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800041e6:	00098463          	beqz	s3,800041ee <exec+0x1c8>
    800041ea:	4481                	li	s1,0
    800041ec:	bfa9                	j	80004146 <exec+0x120>
    sz = sz1;
    800041ee:	df843483          	ld	s1,-520(s0)
    800041f2:	bfb5                	j	8000416e <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800041f4:	4481                	li	s1,0
  iunlockput(ip);
    800041f6:	8552                	mv	a0,s4
    800041f8:	fffff097          	auipc	ra,0xfffff
    800041fc:	af4080e7          	jalr	-1292(ra) # 80002cec <iunlockput>
  end_op();
    80004200:	fffff097          	auipc	ra,0xfffff
    80004204:	2f2080e7          	jalr	754(ra) # 800034f2 <end_op>
  p = myproc();
    80004208:	ffffd097          	auipc	ra,0xffffd
    8000420c:	c6c080e7          	jalr	-916(ra) # 80000e74 <myproc>
    80004210:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004212:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004216:	6985                	lui	s3,0x1
    80004218:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    8000421a:	99a6                	add	s3,s3,s1
    8000421c:	77fd                	lui	a5,0xfffff
    8000421e:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004222:	6609                	lui	a2,0x2
    80004224:	964e                	add	a2,a2,s3
    80004226:	85ce                	mv	a1,s3
    80004228:	855a                	mv	a0,s6
    8000422a:	ffffc097          	auipc	ra,0xffffc
    8000422e:	6b2080e7          	jalr	1714(ra) # 800008dc <uvmalloc>
    80004232:	8a2a                	mv	s4,a0
    80004234:	e115                	bnez	a0,80004258 <exec+0x232>
    proc_freepagetable(pagetable, sz);
    80004236:	85ce                	mv	a1,s3
    80004238:	855a                	mv	a0,s6
    8000423a:	ffffd097          	auipc	ra,0xffffd
    8000423e:	d9a080e7          	jalr	-614(ra) # 80000fd4 <proc_freepagetable>
  return -1;
    80004242:	557d                	li	a0,-1
    80004244:	79fe                	ld	s3,504(sp)
    80004246:	7a5e                	ld	s4,496(sp)
    80004248:	7abe                	ld	s5,488(sp)
    8000424a:	7b1e                	ld	s6,480(sp)
    8000424c:	6bfe                	ld	s7,472(sp)
    8000424e:	6c5e                	ld	s8,464(sp)
    80004250:	6cbe                	ld	s9,456(sp)
    80004252:	6d1e                	ld	s10,448(sp)
    80004254:	7dfa                	ld	s11,440(sp)
    80004256:	bdb9                	j	800040b4 <exec+0x8e>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004258:	75f9                	lui	a1,0xffffe
    8000425a:	95aa                	add	a1,a1,a0
    8000425c:	855a                	mv	a0,s6
    8000425e:	ffffd097          	auipc	ra,0xffffd
    80004262:	890080e7          	jalr	-1904(ra) # 80000aee <uvmclear>
  stackbase = sp - PGSIZE;
    80004266:	7bfd                	lui	s7,0xfffff
    80004268:	9bd2                	add	s7,s7,s4
  for(argc = 0; argv[argc]; argc++) {
    8000426a:	e0043783          	ld	a5,-512(s0)
    8000426e:	6388                	ld	a0,0(a5)
  sp = sz;
    80004270:	8952                	mv	s2,s4
  for(argc = 0; argv[argc]; argc++) {
    80004272:	4481                	li	s1,0
    ustack[argc] = sp;
    80004274:	e9040c93          	addi	s9,s0,-368
    if(argc >= MAXARG)
    80004278:	02000c13          	li	s8,32
  for(argc = 0; argv[argc]; argc++) {
    8000427c:	c135                	beqz	a0,800042e0 <exec+0x2ba>
    sp -= strlen(argv[argc]) + 1;
    8000427e:	ffffc097          	auipc	ra,0xffffc
    80004282:	088080e7          	jalr	136(ra) # 80000306 <strlen>
    80004286:	0015079b          	addiw	a5,a0,1
    8000428a:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    8000428e:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80004292:	13796e63          	bltu	s2,s7,800043ce <exec+0x3a8>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004296:	e0043d83          	ld	s11,-512(s0)
    8000429a:	000db983          	ld	s3,0(s11)
    8000429e:	854e                	mv	a0,s3
    800042a0:	ffffc097          	auipc	ra,0xffffc
    800042a4:	066080e7          	jalr	102(ra) # 80000306 <strlen>
    800042a8:	0015069b          	addiw	a3,a0,1
    800042ac:	864e                	mv	a2,s3
    800042ae:	85ca                	mv	a1,s2
    800042b0:	855a                	mv	a0,s6
    800042b2:	ffffd097          	auipc	ra,0xffffd
    800042b6:	86e080e7          	jalr	-1938(ra) # 80000b20 <copyout>
    800042ba:	10054c63          	bltz	a0,800043d2 <exec+0x3ac>
    ustack[argc] = sp;
    800042be:	00349793          	slli	a5,s1,0x3
    800042c2:	97e6                	add	a5,a5,s9
    800042c4:	0127b023          	sd	s2,0(a5) # fffffffffffff000 <end+0xffffffff7ffd8dc0>
  for(argc = 0; argv[argc]; argc++) {
    800042c8:	0485                	addi	s1,s1,1
    800042ca:	008d8793          	addi	a5,s11,8
    800042ce:	e0f43023          	sd	a5,-512(s0)
    800042d2:	008db503          	ld	a0,8(s11)
    800042d6:	c509                	beqz	a0,800042e0 <exec+0x2ba>
    if(argc >= MAXARG)
    800042d8:	fb8493e3          	bne	s1,s8,8000427e <exec+0x258>
  sz = sz1;
    800042dc:	89d2                	mv	s3,s4
    800042de:	bfa1                	j	80004236 <exec+0x210>
  ustack[argc] = 0;
    800042e0:	00349793          	slli	a5,s1,0x3
    800042e4:	f9078793          	addi	a5,a5,-112
    800042e8:	97a2                	add	a5,a5,s0
    800042ea:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    800042ee:	00148693          	addi	a3,s1,1
    800042f2:	068e                	slli	a3,a3,0x3
    800042f4:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800042f8:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    800042fc:	89d2                	mv	s3,s4
  if(sp < stackbase)
    800042fe:	f3796ce3          	bltu	s2,s7,80004236 <exec+0x210>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004302:	e9040613          	addi	a2,s0,-368
    80004306:	85ca                	mv	a1,s2
    80004308:	855a                	mv	a0,s6
    8000430a:	ffffd097          	auipc	ra,0xffffd
    8000430e:	816080e7          	jalr	-2026(ra) # 80000b20 <copyout>
    80004312:	f20542e3          	bltz	a0,80004236 <exec+0x210>
  p->trapframe->a1 = sp;
    80004316:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    8000431a:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    8000431e:	df043783          	ld	a5,-528(s0)
    80004322:	0007c703          	lbu	a4,0(a5)
    80004326:	cf11                	beqz	a4,80004342 <exec+0x31c>
    80004328:	0785                	addi	a5,a5,1
    if(*s == '/')
    8000432a:	02f00693          	li	a3,47
    8000432e:	a029                	j	80004338 <exec+0x312>
  for(last=s=path; *s; s++)
    80004330:	0785                	addi	a5,a5,1
    80004332:	fff7c703          	lbu	a4,-1(a5)
    80004336:	c711                	beqz	a4,80004342 <exec+0x31c>
    if(*s == '/')
    80004338:	fed71ce3          	bne	a4,a3,80004330 <exec+0x30a>
      last = s+1;
    8000433c:	def43823          	sd	a5,-528(s0)
    80004340:	bfc5                	j	80004330 <exec+0x30a>
  safestrcpy(p->name, last, sizeof(p->name));
    80004342:	4641                	li	a2,16
    80004344:	df043583          	ld	a1,-528(s0)
    80004348:	158a8513          	addi	a0,s5,344
    8000434c:	ffffc097          	auipc	ra,0xffffc
    80004350:	f84080e7          	jalr	-124(ra) # 800002d0 <safestrcpy>
  oldpagetable = p->pagetable;
    80004354:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004358:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    8000435c:	054ab423          	sd	s4,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004360:	058ab783          	ld	a5,88(s5)
    80004364:	e6843703          	ld	a4,-408(s0)
    80004368:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000436a:	058ab783          	ld	a5,88(s5)
    8000436e:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004372:	85ea                	mv	a1,s10
    80004374:	ffffd097          	auipc	ra,0xffffd
    80004378:	c60080e7          	jalr	-928(ra) # 80000fd4 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000437c:	0004851b          	sext.w	a0,s1
    80004380:	79fe                	ld	s3,504(sp)
    80004382:	7a5e                	ld	s4,496(sp)
    80004384:	7abe                	ld	s5,488(sp)
    80004386:	7b1e                	ld	s6,480(sp)
    80004388:	6bfe                	ld	s7,472(sp)
    8000438a:	6c5e                	ld	s8,464(sp)
    8000438c:	6cbe                	ld	s9,456(sp)
    8000438e:	6d1e                	ld	s10,448(sp)
    80004390:	7dfa                	ld	s11,440(sp)
    80004392:	b30d                	j	800040b4 <exec+0x8e>
    80004394:	7b1e                	ld	s6,480(sp)
    80004396:	b321                	j	8000409e <exec+0x78>
    80004398:	de943c23          	sd	s1,-520(s0)
    proc_freepagetable(pagetable, sz);
    8000439c:	df843583          	ld	a1,-520(s0)
    800043a0:	855a                	mv	a0,s6
    800043a2:	ffffd097          	auipc	ra,0xffffd
    800043a6:	c32080e7          	jalr	-974(ra) # 80000fd4 <proc_freepagetable>
  if(ip){
    800043aa:	79fe                	ld	s3,504(sp)
    800043ac:	7abe                	ld	s5,488(sp)
    800043ae:	7b1e                	ld	s6,480(sp)
    800043b0:	6bfe                	ld	s7,472(sp)
    800043b2:	6c5e                	ld	s8,464(sp)
    800043b4:	6cbe                	ld	s9,456(sp)
    800043b6:	6d1e                	ld	s10,448(sp)
    800043b8:	7dfa                	ld	s11,440(sp)
    800043ba:	b1d5                	j	8000409e <exec+0x78>
    800043bc:	de943c23          	sd	s1,-520(s0)
    800043c0:	bff1                	j	8000439c <exec+0x376>
    800043c2:	de943c23          	sd	s1,-520(s0)
    800043c6:	bfd9                	j	8000439c <exec+0x376>
    800043c8:	de943c23          	sd	s1,-520(s0)
    800043cc:	bfc1                	j	8000439c <exec+0x376>
  sz = sz1;
    800043ce:	89d2                	mv	s3,s4
    800043d0:	b59d                	j	80004236 <exec+0x210>
    800043d2:	89d2                	mv	s3,s4
    800043d4:	b58d                	j	80004236 <exec+0x210>

00000000800043d6 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800043d6:	7179                	addi	sp,sp,-48
    800043d8:	f406                	sd	ra,40(sp)
    800043da:	f022                	sd	s0,32(sp)
    800043dc:	ec26                	sd	s1,24(sp)
    800043de:	e84a                	sd	s2,16(sp)
    800043e0:	1800                	addi	s0,sp,48
    800043e2:	892e                	mv	s2,a1
    800043e4:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    800043e6:	fdc40593          	addi	a1,s0,-36
    800043ea:	ffffe097          	auipc	ra,0xffffe
    800043ee:	b48080e7          	jalr	-1208(ra) # 80001f32 <argint>
    800043f2:	04054063          	bltz	a0,80004432 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800043f6:	fdc42703          	lw	a4,-36(s0)
    800043fa:	47bd                	li	a5,15
    800043fc:	02e7ed63          	bltu	a5,a4,80004436 <argfd+0x60>
    80004400:	ffffd097          	auipc	ra,0xffffd
    80004404:	a74080e7          	jalr	-1420(ra) # 80000e74 <myproc>
    80004408:	fdc42703          	lw	a4,-36(s0)
    8000440c:	01a70793          	addi	a5,a4,26
    80004410:	078e                	slli	a5,a5,0x3
    80004412:	953e                	add	a0,a0,a5
    80004414:	611c                	ld	a5,0(a0)
    80004416:	c395                	beqz	a5,8000443a <argfd+0x64>
    return -1;
  if(pfd)
    80004418:	00090463          	beqz	s2,80004420 <argfd+0x4a>
    *pfd = fd;
    8000441c:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004420:	4501                	li	a0,0
  if(pf)
    80004422:	c091                	beqz	s1,80004426 <argfd+0x50>
    *pf = f;
    80004424:	e09c                	sd	a5,0(s1)
}
    80004426:	70a2                	ld	ra,40(sp)
    80004428:	7402                	ld	s0,32(sp)
    8000442a:	64e2                	ld	s1,24(sp)
    8000442c:	6942                	ld	s2,16(sp)
    8000442e:	6145                	addi	sp,sp,48
    80004430:	8082                	ret
    return -1;
    80004432:	557d                	li	a0,-1
    80004434:	bfcd                	j	80004426 <argfd+0x50>
    return -1;
    80004436:	557d                	li	a0,-1
    80004438:	b7fd                	j	80004426 <argfd+0x50>
    8000443a:	557d                	li	a0,-1
    8000443c:	b7ed                	j	80004426 <argfd+0x50>

000000008000443e <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    8000443e:	1101                	addi	sp,sp,-32
    80004440:	ec06                	sd	ra,24(sp)
    80004442:	e822                	sd	s0,16(sp)
    80004444:	e426                	sd	s1,8(sp)
    80004446:	1000                	addi	s0,sp,32
    80004448:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000444a:	ffffd097          	auipc	ra,0xffffd
    8000444e:	a2a080e7          	jalr	-1494(ra) # 80000e74 <myproc>
    80004452:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004454:	0d050793          	addi	a5,a0,208
    80004458:	4501                	li	a0,0
    8000445a:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    8000445c:	6398                	ld	a4,0(a5)
    8000445e:	cb19                	beqz	a4,80004474 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004460:	2505                	addiw	a0,a0,1
    80004462:	07a1                	addi	a5,a5,8
    80004464:	fed51ce3          	bne	a0,a3,8000445c <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004468:	557d                	li	a0,-1
}
    8000446a:	60e2                	ld	ra,24(sp)
    8000446c:	6442                	ld	s0,16(sp)
    8000446e:	64a2                	ld	s1,8(sp)
    80004470:	6105                	addi	sp,sp,32
    80004472:	8082                	ret
      p->ofile[fd] = f;
    80004474:	01a50793          	addi	a5,a0,26
    80004478:	078e                	slli	a5,a5,0x3
    8000447a:	963e                	add	a2,a2,a5
    8000447c:	e204                	sd	s1,0(a2)
      return fd;
    8000447e:	b7f5                	j	8000446a <fdalloc+0x2c>

0000000080004480 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004480:	715d                	addi	sp,sp,-80
    80004482:	e486                	sd	ra,72(sp)
    80004484:	e0a2                	sd	s0,64(sp)
    80004486:	fc26                	sd	s1,56(sp)
    80004488:	f84a                	sd	s2,48(sp)
    8000448a:	f44e                	sd	s3,40(sp)
    8000448c:	f052                	sd	s4,32(sp)
    8000448e:	ec56                	sd	s5,24(sp)
    80004490:	0880                	addi	s0,sp,80
    80004492:	8aae                	mv	s5,a1
    80004494:	8a32                	mv	s4,a2
    80004496:	89b6                	mv	s3,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004498:	fb040593          	addi	a1,s0,-80
    8000449c:	fffff097          	auipc	ra,0xfffff
    800044a0:	df4080e7          	jalr	-524(ra) # 80003290 <nameiparent>
    800044a4:	892a                	mv	s2,a0
    800044a6:	12050c63          	beqz	a0,800045de <create+0x15e>
    return 0;

  ilock(dp);
    800044aa:	ffffe097          	auipc	ra,0xffffe
    800044ae:	5dc080e7          	jalr	1500(ra) # 80002a86 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800044b2:	4601                	li	a2,0
    800044b4:	fb040593          	addi	a1,s0,-80
    800044b8:	854a                	mv	a0,s2
    800044ba:	fffff097          	auipc	ra,0xfffff
    800044be:	abc080e7          	jalr	-1348(ra) # 80002f76 <dirlookup>
    800044c2:	84aa                	mv	s1,a0
    800044c4:	c539                	beqz	a0,80004512 <create+0x92>
    iunlockput(dp);
    800044c6:	854a                	mv	a0,s2
    800044c8:	fffff097          	auipc	ra,0xfffff
    800044cc:	824080e7          	jalr	-2012(ra) # 80002cec <iunlockput>
    ilock(ip);
    800044d0:	8526                	mv	a0,s1
    800044d2:	ffffe097          	auipc	ra,0xffffe
    800044d6:	5b4080e7          	jalr	1460(ra) # 80002a86 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800044da:	4789                	li	a5,2
    800044dc:	02fa9463          	bne	s5,a5,80004504 <create+0x84>
    800044e0:	0444d783          	lhu	a5,68(s1)
    800044e4:	37f9                	addiw	a5,a5,-2
    800044e6:	17c2                	slli	a5,a5,0x30
    800044e8:	93c1                	srli	a5,a5,0x30
    800044ea:	4705                	li	a4,1
    800044ec:	00f76c63          	bltu	a4,a5,80004504 <create+0x84>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    800044f0:	8526                	mv	a0,s1
    800044f2:	60a6                	ld	ra,72(sp)
    800044f4:	6406                	ld	s0,64(sp)
    800044f6:	74e2                	ld	s1,56(sp)
    800044f8:	7942                	ld	s2,48(sp)
    800044fa:	79a2                	ld	s3,40(sp)
    800044fc:	7a02                	ld	s4,32(sp)
    800044fe:	6ae2                	ld	s5,24(sp)
    80004500:	6161                	addi	sp,sp,80
    80004502:	8082                	ret
    iunlockput(ip);
    80004504:	8526                	mv	a0,s1
    80004506:	ffffe097          	auipc	ra,0xffffe
    8000450a:	7e6080e7          	jalr	2022(ra) # 80002cec <iunlockput>
    return 0;
    8000450e:	4481                	li	s1,0
    80004510:	b7c5                	j	800044f0 <create+0x70>
  if((ip = ialloc(dp->dev, type)) == 0)
    80004512:	85d6                	mv	a1,s5
    80004514:	00092503          	lw	a0,0(s2)
    80004518:	ffffe097          	auipc	ra,0xffffe
    8000451c:	3da080e7          	jalr	986(ra) # 800028f2 <ialloc>
    80004520:	84aa                	mv	s1,a0
    80004522:	c139                	beqz	a0,80004568 <create+0xe8>
  ilock(ip);
    80004524:	ffffe097          	auipc	ra,0xffffe
    80004528:	562080e7          	jalr	1378(ra) # 80002a86 <ilock>
  ip->major = major;
    8000452c:	05449323          	sh	s4,70(s1)
  ip->minor = minor;
    80004530:	05349423          	sh	s3,72(s1)
  ip->nlink = 1;
    80004534:	4985                	li	s3,1
    80004536:	05349523          	sh	s3,74(s1)
  iupdate(ip);
    8000453a:	8526                	mv	a0,s1
    8000453c:	ffffe097          	auipc	ra,0xffffe
    80004540:	47e080e7          	jalr	1150(ra) # 800029ba <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004544:	033a8a63          	beq	s5,s3,80004578 <create+0xf8>
  if(dirlink(dp, name, ip->inum) < 0)
    80004548:	40d0                	lw	a2,4(s1)
    8000454a:	fb040593          	addi	a1,s0,-80
    8000454e:	854a                	mv	a0,s2
    80004550:	fffff097          	auipc	ra,0xfffff
    80004554:	c4c080e7          	jalr	-948(ra) # 8000319c <dirlink>
    80004558:	06054b63          	bltz	a0,800045ce <create+0x14e>
  iunlockput(dp);
    8000455c:	854a                	mv	a0,s2
    8000455e:	ffffe097          	auipc	ra,0xffffe
    80004562:	78e080e7          	jalr	1934(ra) # 80002cec <iunlockput>
  return ip;
    80004566:	b769                	j	800044f0 <create+0x70>
    panic("create: ialloc");
    80004568:	00004517          	auipc	a0,0x4
    8000456c:	00850513          	addi	a0,a0,8 # 80008570 <etext+0x570>
    80004570:	00001097          	auipc	ra,0x1
    80004574:	6d2080e7          	jalr	1746(ra) # 80005c42 <panic>
    dp->nlink++;  // for ".."
    80004578:	04a95783          	lhu	a5,74(s2)
    8000457c:	2785                	addiw	a5,a5,1
    8000457e:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    80004582:	854a                	mv	a0,s2
    80004584:	ffffe097          	auipc	ra,0xffffe
    80004588:	436080e7          	jalr	1078(ra) # 800029ba <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000458c:	40d0                	lw	a2,4(s1)
    8000458e:	00004597          	auipc	a1,0x4
    80004592:	ff258593          	addi	a1,a1,-14 # 80008580 <etext+0x580>
    80004596:	8526                	mv	a0,s1
    80004598:	fffff097          	auipc	ra,0xfffff
    8000459c:	c04080e7          	jalr	-1020(ra) # 8000319c <dirlink>
    800045a0:	00054f63          	bltz	a0,800045be <create+0x13e>
    800045a4:	00492603          	lw	a2,4(s2)
    800045a8:	00004597          	auipc	a1,0x4
    800045ac:	fe058593          	addi	a1,a1,-32 # 80008588 <etext+0x588>
    800045b0:	8526                	mv	a0,s1
    800045b2:	fffff097          	auipc	ra,0xfffff
    800045b6:	bea080e7          	jalr	-1046(ra) # 8000319c <dirlink>
    800045ba:	f80557e3          	bgez	a0,80004548 <create+0xc8>
      panic("create dots");
    800045be:	00004517          	auipc	a0,0x4
    800045c2:	fd250513          	addi	a0,a0,-46 # 80008590 <etext+0x590>
    800045c6:	00001097          	auipc	ra,0x1
    800045ca:	67c080e7          	jalr	1660(ra) # 80005c42 <panic>
    panic("create: dirlink");
    800045ce:	00004517          	auipc	a0,0x4
    800045d2:	fd250513          	addi	a0,a0,-46 # 800085a0 <etext+0x5a0>
    800045d6:	00001097          	auipc	ra,0x1
    800045da:	66c080e7          	jalr	1644(ra) # 80005c42 <panic>
    return 0;
    800045de:	84aa                	mv	s1,a0
    800045e0:	bf01                	j	800044f0 <create+0x70>

00000000800045e2 <sys_dup>:
{
    800045e2:	7179                	addi	sp,sp,-48
    800045e4:	f406                	sd	ra,40(sp)
    800045e6:	f022                	sd	s0,32(sp)
    800045e8:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800045ea:	fd840613          	addi	a2,s0,-40
    800045ee:	4581                	li	a1,0
    800045f0:	4501                	li	a0,0
    800045f2:	00000097          	auipc	ra,0x0
    800045f6:	de4080e7          	jalr	-540(ra) # 800043d6 <argfd>
    return -1;
    800045fa:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800045fc:	02054763          	bltz	a0,8000462a <sys_dup+0x48>
    80004600:	ec26                	sd	s1,24(sp)
    80004602:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80004604:	fd843903          	ld	s2,-40(s0)
    80004608:	854a                	mv	a0,s2
    8000460a:	00000097          	auipc	ra,0x0
    8000460e:	e34080e7          	jalr	-460(ra) # 8000443e <fdalloc>
    80004612:	84aa                	mv	s1,a0
    return -1;
    80004614:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004616:	00054f63          	bltz	a0,80004634 <sys_dup+0x52>
  filedup(f);
    8000461a:	854a                	mv	a0,s2
    8000461c:	fffff097          	auipc	ra,0xfffff
    80004620:	2da080e7          	jalr	730(ra) # 800038f6 <filedup>
  return fd;
    80004624:	87a6                	mv	a5,s1
    80004626:	64e2                	ld	s1,24(sp)
    80004628:	6942                	ld	s2,16(sp)
}
    8000462a:	853e                	mv	a0,a5
    8000462c:	70a2                	ld	ra,40(sp)
    8000462e:	7402                	ld	s0,32(sp)
    80004630:	6145                	addi	sp,sp,48
    80004632:	8082                	ret
    80004634:	64e2                	ld	s1,24(sp)
    80004636:	6942                	ld	s2,16(sp)
    80004638:	bfcd                	j	8000462a <sys_dup+0x48>

000000008000463a <sys_read>:
{
    8000463a:	7179                	addi	sp,sp,-48
    8000463c:	f406                	sd	ra,40(sp)
    8000463e:	f022                	sd	s0,32(sp)
    80004640:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004642:	fe840613          	addi	a2,s0,-24
    80004646:	4581                	li	a1,0
    80004648:	4501                	li	a0,0
    8000464a:	00000097          	auipc	ra,0x0
    8000464e:	d8c080e7          	jalr	-628(ra) # 800043d6 <argfd>
    return -1;
    80004652:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004654:	04054163          	bltz	a0,80004696 <sys_read+0x5c>
    80004658:	fe440593          	addi	a1,s0,-28
    8000465c:	4509                	li	a0,2
    8000465e:	ffffe097          	auipc	ra,0xffffe
    80004662:	8d4080e7          	jalr	-1836(ra) # 80001f32 <argint>
    return -1;
    80004666:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004668:	02054763          	bltz	a0,80004696 <sys_read+0x5c>
    8000466c:	fd840593          	addi	a1,s0,-40
    80004670:	4505                	li	a0,1
    80004672:	ffffe097          	auipc	ra,0xffffe
    80004676:	8e2080e7          	jalr	-1822(ra) # 80001f54 <argaddr>
    return -1;
    8000467a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000467c:	00054d63          	bltz	a0,80004696 <sys_read+0x5c>
  return fileread(f, p, n);
    80004680:	fe442603          	lw	a2,-28(s0)
    80004684:	fd843583          	ld	a1,-40(s0)
    80004688:	fe843503          	ld	a0,-24(s0)
    8000468c:	fffff097          	auipc	ra,0xfffff
    80004690:	410080e7          	jalr	1040(ra) # 80003a9c <fileread>
    80004694:	87aa                	mv	a5,a0
}
    80004696:	853e                	mv	a0,a5
    80004698:	70a2                	ld	ra,40(sp)
    8000469a:	7402                	ld	s0,32(sp)
    8000469c:	6145                	addi	sp,sp,48
    8000469e:	8082                	ret

00000000800046a0 <sys_write>:
{
    800046a0:	7179                	addi	sp,sp,-48
    800046a2:	f406                	sd	ra,40(sp)
    800046a4:	f022                	sd	s0,32(sp)
    800046a6:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046a8:	fe840613          	addi	a2,s0,-24
    800046ac:	4581                	li	a1,0
    800046ae:	4501                	li	a0,0
    800046b0:	00000097          	auipc	ra,0x0
    800046b4:	d26080e7          	jalr	-730(ra) # 800043d6 <argfd>
    return -1;
    800046b8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046ba:	04054163          	bltz	a0,800046fc <sys_write+0x5c>
    800046be:	fe440593          	addi	a1,s0,-28
    800046c2:	4509                	li	a0,2
    800046c4:	ffffe097          	auipc	ra,0xffffe
    800046c8:	86e080e7          	jalr	-1938(ra) # 80001f32 <argint>
    return -1;
    800046cc:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046ce:	02054763          	bltz	a0,800046fc <sys_write+0x5c>
    800046d2:	fd840593          	addi	a1,s0,-40
    800046d6:	4505                	li	a0,1
    800046d8:	ffffe097          	auipc	ra,0xffffe
    800046dc:	87c080e7          	jalr	-1924(ra) # 80001f54 <argaddr>
    return -1;
    800046e0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046e2:	00054d63          	bltz	a0,800046fc <sys_write+0x5c>
  return filewrite(f, p, n);
    800046e6:	fe442603          	lw	a2,-28(s0)
    800046ea:	fd843583          	ld	a1,-40(s0)
    800046ee:	fe843503          	ld	a0,-24(s0)
    800046f2:	fffff097          	auipc	ra,0xfffff
    800046f6:	47c080e7          	jalr	1148(ra) # 80003b6e <filewrite>
    800046fa:	87aa                	mv	a5,a0
}
    800046fc:	853e                	mv	a0,a5
    800046fe:	70a2                	ld	ra,40(sp)
    80004700:	7402                	ld	s0,32(sp)
    80004702:	6145                	addi	sp,sp,48
    80004704:	8082                	ret

0000000080004706 <sys_close>:
{
    80004706:	1101                	addi	sp,sp,-32
    80004708:	ec06                	sd	ra,24(sp)
    8000470a:	e822                	sd	s0,16(sp)
    8000470c:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    8000470e:	fe040613          	addi	a2,s0,-32
    80004712:	fec40593          	addi	a1,s0,-20
    80004716:	4501                	li	a0,0
    80004718:	00000097          	auipc	ra,0x0
    8000471c:	cbe080e7          	jalr	-834(ra) # 800043d6 <argfd>
    return -1;
    80004720:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004722:	02054463          	bltz	a0,8000474a <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004726:	ffffc097          	auipc	ra,0xffffc
    8000472a:	74e080e7          	jalr	1870(ra) # 80000e74 <myproc>
    8000472e:	fec42783          	lw	a5,-20(s0)
    80004732:	07e9                	addi	a5,a5,26
    80004734:	078e                	slli	a5,a5,0x3
    80004736:	953e                	add	a0,a0,a5
    80004738:	00053023          	sd	zero,0(a0)
  fileclose(f);
    8000473c:	fe043503          	ld	a0,-32(s0)
    80004740:	fffff097          	auipc	ra,0xfffff
    80004744:	208080e7          	jalr	520(ra) # 80003948 <fileclose>
  return 0;
    80004748:	4781                	li	a5,0
}
    8000474a:	853e                	mv	a0,a5
    8000474c:	60e2                	ld	ra,24(sp)
    8000474e:	6442                	ld	s0,16(sp)
    80004750:	6105                	addi	sp,sp,32
    80004752:	8082                	ret

0000000080004754 <sys_fstat>:
{
    80004754:	1101                	addi	sp,sp,-32
    80004756:	ec06                	sd	ra,24(sp)
    80004758:	e822                	sd	s0,16(sp)
    8000475a:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000475c:	fe840613          	addi	a2,s0,-24
    80004760:	4581                	li	a1,0
    80004762:	4501                	li	a0,0
    80004764:	00000097          	auipc	ra,0x0
    80004768:	c72080e7          	jalr	-910(ra) # 800043d6 <argfd>
    return -1;
    8000476c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000476e:	02054563          	bltz	a0,80004798 <sys_fstat+0x44>
    80004772:	fe040593          	addi	a1,s0,-32
    80004776:	4505                	li	a0,1
    80004778:	ffffd097          	auipc	ra,0xffffd
    8000477c:	7dc080e7          	jalr	2012(ra) # 80001f54 <argaddr>
    return -1;
    80004780:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004782:	00054b63          	bltz	a0,80004798 <sys_fstat+0x44>
  return filestat(f, st);
    80004786:	fe043583          	ld	a1,-32(s0)
    8000478a:	fe843503          	ld	a0,-24(s0)
    8000478e:	fffff097          	auipc	ra,0xfffff
    80004792:	298080e7          	jalr	664(ra) # 80003a26 <filestat>
    80004796:	87aa                	mv	a5,a0
}
    80004798:	853e                	mv	a0,a5
    8000479a:	60e2                	ld	ra,24(sp)
    8000479c:	6442                	ld	s0,16(sp)
    8000479e:	6105                	addi	sp,sp,32
    800047a0:	8082                	ret

00000000800047a2 <sys_link>:
{
    800047a2:	7169                	addi	sp,sp,-304
    800047a4:	f606                	sd	ra,296(sp)
    800047a6:	f222                	sd	s0,288(sp)
    800047a8:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800047aa:	08000613          	li	a2,128
    800047ae:	ed040593          	addi	a1,s0,-304
    800047b2:	4501                	li	a0,0
    800047b4:	ffffd097          	auipc	ra,0xffffd
    800047b8:	7c2080e7          	jalr	1986(ra) # 80001f76 <argstr>
    return -1;
    800047bc:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800047be:	12054663          	bltz	a0,800048ea <sys_link+0x148>
    800047c2:	08000613          	li	a2,128
    800047c6:	f5040593          	addi	a1,s0,-176
    800047ca:	4505                	li	a0,1
    800047cc:	ffffd097          	auipc	ra,0xffffd
    800047d0:	7aa080e7          	jalr	1962(ra) # 80001f76 <argstr>
    return -1;
    800047d4:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800047d6:	10054a63          	bltz	a0,800048ea <sys_link+0x148>
    800047da:	ee26                	sd	s1,280(sp)
  begin_op();
    800047dc:	fffff097          	auipc	ra,0xfffff
    800047e0:	c9c080e7          	jalr	-868(ra) # 80003478 <begin_op>
  if((ip = namei(old)) == 0){
    800047e4:	ed040513          	addi	a0,s0,-304
    800047e8:	fffff097          	auipc	ra,0xfffff
    800047ec:	a8a080e7          	jalr	-1398(ra) # 80003272 <namei>
    800047f0:	84aa                	mv	s1,a0
    800047f2:	c949                	beqz	a0,80004884 <sys_link+0xe2>
  ilock(ip);
    800047f4:	ffffe097          	auipc	ra,0xffffe
    800047f8:	292080e7          	jalr	658(ra) # 80002a86 <ilock>
  if(ip->type == T_DIR){
    800047fc:	04449703          	lh	a4,68(s1)
    80004800:	4785                	li	a5,1
    80004802:	08f70863          	beq	a4,a5,80004892 <sys_link+0xf0>
    80004806:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004808:	04a4d783          	lhu	a5,74(s1)
    8000480c:	2785                	addiw	a5,a5,1
    8000480e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004812:	8526                	mv	a0,s1
    80004814:	ffffe097          	auipc	ra,0xffffe
    80004818:	1a6080e7          	jalr	422(ra) # 800029ba <iupdate>
  iunlock(ip);
    8000481c:	8526                	mv	a0,s1
    8000481e:	ffffe097          	auipc	ra,0xffffe
    80004822:	32e080e7          	jalr	814(ra) # 80002b4c <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004826:	fd040593          	addi	a1,s0,-48
    8000482a:	f5040513          	addi	a0,s0,-176
    8000482e:	fffff097          	auipc	ra,0xfffff
    80004832:	a62080e7          	jalr	-1438(ra) # 80003290 <nameiparent>
    80004836:	892a                	mv	s2,a0
    80004838:	cd35                	beqz	a0,800048b4 <sys_link+0x112>
  ilock(dp);
    8000483a:	ffffe097          	auipc	ra,0xffffe
    8000483e:	24c080e7          	jalr	588(ra) # 80002a86 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004842:	00092703          	lw	a4,0(s2)
    80004846:	409c                	lw	a5,0(s1)
    80004848:	06f71163          	bne	a4,a5,800048aa <sys_link+0x108>
    8000484c:	40d0                	lw	a2,4(s1)
    8000484e:	fd040593          	addi	a1,s0,-48
    80004852:	854a                	mv	a0,s2
    80004854:	fffff097          	auipc	ra,0xfffff
    80004858:	948080e7          	jalr	-1720(ra) # 8000319c <dirlink>
    8000485c:	04054763          	bltz	a0,800048aa <sys_link+0x108>
  iunlockput(dp);
    80004860:	854a                	mv	a0,s2
    80004862:	ffffe097          	auipc	ra,0xffffe
    80004866:	48a080e7          	jalr	1162(ra) # 80002cec <iunlockput>
  iput(ip);
    8000486a:	8526                	mv	a0,s1
    8000486c:	ffffe097          	auipc	ra,0xffffe
    80004870:	3d8080e7          	jalr	984(ra) # 80002c44 <iput>
  end_op();
    80004874:	fffff097          	auipc	ra,0xfffff
    80004878:	c7e080e7          	jalr	-898(ra) # 800034f2 <end_op>
  return 0;
    8000487c:	4781                	li	a5,0
    8000487e:	64f2                	ld	s1,280(sp)
    80004880:	6952                	ld	s2,272(sp)
    80004882:	a0a5                	j	800048ea <sys_link+0x148>
    end_op();
    80004884:	fffff097          	auipc	ra,0xfffff
    80004888:	c6e080e7          	jalr	-914(ra) # 800034f2 <end_op>
    return -1;
    8000488c:	57fd                	li	a5,-1
    8000488e:	64f2                	ld	s1,280(sp)
    80004890:	a8a9                	j	800048ea <sys_link+0x148>
    iunlockput(ip);
    80004892:	8526                	mv	a0,s1
    80004894:	ffffe097          	auipc	ra,0xffffe
    80004898:	458080e7          	jalr	1112(ra) # 80002cec <iunlockput>
    end_op();
    8000489c:	fffff097          	auipc	ra,0xfffff
    800048a0:	c56080e7          	jalr	-938(ra) # 800034f2 <end_op>
    return -1;
    800048a4:	57fd                	li	a5,-1
    800048a6:	64f2                	ld	s1,280(sp)
    800048a8:	a089                	j	800048ea <sys_link+0x148>
    iunlockput(dp);
    800048aa:	854a                	mv	a0,s2
    800048ac:	ffffe097          	auipc	ra,0xffffe
    800048b0:	440080e7          	jalr	1088(ra) # 80002cec <iunlockput>
  ilock(ip);
    800048b4:	8526                	mv	a0,s1
    800048b6:	ffffe097          	auipc	ra,0xffffe
    800048ba:	1d0080e7          	jalr	464(ra) # 80002a86 <ilock>
  ip->nlink--;
    800048be:	04a4d783          	lhu	a5,74(s1)
    800048c2:	37fd                	addiw	a5,a5,-1
    800048c4:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800048c8:	8526                	mv	a0,s1
    800048ca:	ffffe097          	auipc	ra,0xffffe
    800048ce:	0f0080e7          	jalr	240(ra) # 800029ba <iupdate>
  iunlockput(ip);
    800048d2:	8526                	mv	a0,s1
    800048d4:	ffffe097          	auipc	ra,0xffffe
    800048d8:	418080e7          	jalr	1048(ra) # 80002cec <iunlockput>
  end_op();
    800048dc:	fffff097          	auipc	ra,0xfffff
    800048e0:	c16080e7          	jalr	-1002(ra) # 800034f2 <end_op>
  return -1;
    800048e4:	57fd                	li	a5,-1
    800048e6:	64f2                	ld	s1,280(sp)
    800048e8:	6952                	ld	s2,272(sp)
}
    800048ea:	853e                	mv	a0,a5
    800048ec:	70b2                	ld	ra,296(sp)
    800048ee:	7412                	ld	s0,288(sp)
    800048f0:	6155                	addi	sp,sp,304
    800048f2:	8082                	ret

00000000800048f4 <sys_unlink>:
{
    800048f4:	7111                	addi	sp,sp,-256
    800048f6:	fd86                	sd	ra,248(sp)
    800048f8:	f9a2                	sd	s0,240(sp)
    800048fa:	0200                	addi	s0,sp,256
  if(argstr(0, path, MAXPATH) < 0)
    800048fc:	08000613          	li	a2,128
    80004900:	f2040593          	addi	a1,s0,-224
    80004904:	4501                	li	a0,0
    80004906:	ffffd097          	auipc	ra,0xffffd
    8000490a:	670080e7          	jalr	1648(ra) # 80001f76 <argstr>
    8000490e:	1c054063          	bltz	a0,80004ace <sys_unlink+0x1da>
    80004912:	f5a6                	sd	s1,232(sp)
  begin_op();
    80004914:	fffff097          	auipc	ra,0xfffff
    80004918:	b64080e7          	jalr	-1180(ra) # 80003478 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    8000491c:	fa040593          	addi	a1,s0,-96
    80004920:	f2040513          	addi	a0,s0,-224
    80004924:	fffff097          	auipc	ra,0xfffff
    80004928:	96c080e7          	jalr	-1684(ra) # 80003290 <nameiparent>
    8000492c:	84aa                	mv	s1,a0
    8000492e:	c165                	beqz	a0,80004a0e <sys_unlink+0x11a>
  ilock(dp);
    80004930:	ffffe097          	auipc	ra,0xffffe
    80004934:	156080e7          	jalr	342(ra) # 80002a86 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004938:	00004597          	auipc	a1,0x4
    8000493c:	c4858593          	addi	a1,a1,-952 # 80008580 <etext+0x580>
    80004940:	fa040513          	addi	a0,s0,-96
    80004944:	ffffe097          	auipc	ra,0xffffe
    80004948:	618080e7          	jalr	1560(ra) # 80002f5c <namecmp>
    8000494c:	16050263          	beqz	a0,80004ab0 <sys_unlink+0x1bc>
    80004950:	00004597          	auipc	a1,0x4
    80004954:	c3858593          	addi	a1,a1,-968 # 80008588 <etext+0x588>
    80004958:	fa040513          	addi	a0,s0,-96
    8000495c:	ffffe097          	auipc	ra,0xffffe
    80004960:	600080e7          	jalr	1536(ra) # 80002f5c <namecmp>
    80004964:	14050663          	beqz	a0,80004ab0 <sys_unlink+0x1bc>
    80004968:	f1ca                	sd	s2,224(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    8000496a:	f1c40613          	addi	a2,s0,-228
    8000496e:	fa040593          	addi	a1,s0,-96
    80004972:	8526                	mv	a0,s1
    80004974:	ffffe097          	auipc	ra,0xffffe
    80004978:	602080e7          	jalr	1538(ra) # 80002f76 <dirlookup>
    8000497c:	892a                	mv	s2,a0
    8000497e:	12050863          	beqz	a0,80004aae <sys_unlink+0x1ba>
    80004982:	edce                	sd	s3,216(sp)
  ilock(ip);
    80004984:	ffffe097          	auipc	ra,0xffffe
    80004988:	102080e7          	jalr	258(ra) # 80002a86 <ilock>
  if(ip->nlink < 1)
    8000498c:	04a91783          	lh	a5,74(s2)
    80004990:	08f05663          	blez	a5,80004a1c <sys_unlink+0x128>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004994:	04491703          	lh	a4,68(s2)
    80004998:	4785                	li	a5,1
    8000499a:	08f70b63          	beq	a4,a5,80004a30 <sys_unlink+0x13c>
  memset(&de, 0, sizeof(de));
    8000499e:	fb040993          	addi	s3,s0,-80
    800049a2:	4641                	li	a2,16
    800049a4:	4581                	li	a1,0
    800049a6:	854e                	mv	a0,s3
    800049a8:	ffffb097          	auipc	ra,0xffffb
    800049ac:	7d2080e7          	jalr	2002(ra) # 8000017a <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800049b0:	4741                	li	a4,16
    800049b2:	f1c42683          	lw	a3,-228(s0)
    800049b6:	864e                	mv	a2,s3
    800049b8:	4581                	li	a1,0
    800049ba:	8526                	mv	a0,s1
    800049bc:	ffffe097          	auipc	ra,0xffffe
    800049c0:	480080e7          	jalr	1152(ra) # 80002e3c <writei>
    800049c4:	47c1                	li	a5,16
    800049c6:	0af51f63          	bne	a0,a5,80004a84 <sys_unlink+0x190>
  if(ip->type == T_DIR){
    800049ca:	04491703          	lh	a4,68(s2)
    800049ce:	4785                	li	a5,1
    800049d0:	0cf70463          	beq	a4,a5,80004a98 <sys_unlink+0x1a4>
  iunlockput(dp);
    800049d4:	8526                	mv	a0,s1
    800049d6:	ffffe097          	auipc	ra,0xffffe
    800049da:	316080e7          	jalr	790(ra) # 80002cec <iunlockput>
  ip->nlink--;
    800049de:	04a95783          	lhu	a5,74(s2)
    800049e2:	37fd                	addiw	a5,a5,-1
    800049e4:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800049e8:	854a                	mv	a0,s2
    800049ea:	ffffe097          	auipc	ra,0xffffe
    800049ee:	fd0080e7          	jalr	-48(ra) # 800029ba <iupdate>
  iunlockput(ip);
    800049f2:	854a                	mv	a0,s2
    800049f4:	ffffe097          	auipc	ra,0xffffe
    800049f8:	2f8080e7          	jalr	760(ra) # 80002cec <iunlockput>
  end_op();
    800049fc:	fffff097          	auipc	ra,0xfffff
    80004a00:	af6080e7          	jalr	-1290(ra) # 800034f2 <end_op>
  return 0;
    80004a04:	4501                	li	a0,0
    80004a06:	74ae                	ld	s1,232(sp)
    80004a08:	790e                	ld	s2,224(sp)
    80004a0a:	69ee                	ld	s3,216(sp)
    80004a0c:	a86d                	j	80004ac6 <sys_unlink+0x1d2>
    end_op();
    80004a0e:	fffff097          	auipc	ra,0xfffff
    80004a12:	ae4080e7          	jalr	-1308(ra) # 800034f2 <end_op>
    return -1;
    80004a16:	557d                	li	a0,-1
    80004a18:	74ae                	ld	s1,232(sp)
    80004a1a:	a075                	j	80004ac6 <sys_unlink+0x1d2>
    80004a1c:	e9d2                	sd	s4,208(sp)
    80004a1e:	e5d6                	sd	s5,200(sp)
    panic("unlink: nlink < 1");
    80004a20:	00004517          	auipc	a0,0x4
    80004a24:	b9050513          	addi	a0,a0,-1136 # 800085b0 <etext+0x5b0>
    80004a28:	00001097          	auipc	ra,0x1
    80004a2c:	21a080e7          	jalr	538(ra) # 80005c42 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004a30:	04c92703          	lw	a4,76(s2)
    80004a34:	02000793          	li	a5,32
    80004a38:	f6e7f3e3          	bgeu	a5,a4,8000499e <sys_unlink+0xaa>
    80004a3c:	e9d2                	sd	s4,208(sp)
    80004a3e:	e5d6                	sd	s5,200(sp)
    80004a40:	89be                	mv	s3,a5
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a42:	f0840a93          	addi	s5,s0,-248
    80004a46:	4a41                	li	s4,16
    80004a48:	8752                	mv	a4,s4
    80004a4a:	86ce                	mv	a3,s3
    80004a4c:	8656                	mv	a2,s5
    80004a4e:	4581                	li	a1,0
    80004a50:	854a                	mv	a0,s2
    80004a52:	ffffe097          	auipc	ra,0xffffe
    80004a56:	2f0080e7          	jalr	752(ra) # 80002d42 <readi>
    80004a5a:	01451d63          	bne	a0,s4,80004a74 <sys_unlink+0x180>
    if(de.inum != 0)
    80004a5e:	f0845783          	lhu	a5,-248(s0)
    80004a62:	eba5                	bnez	a5,80004ad2 <sys_unlink+0x1de>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004a64:	29c1                	addiw	s3,s3,16
    80004a66:	04c92783          	lw	a5,76(s2)
    80004a6a:	fcf9efe3          	bltu	s3,a5,80004a48 <sys_unlink+0x154>
    80004a6e:	6a4e                	ld	s4,208(sp)
    80004a70:	6aae                	ld	s5,200(sp)
    80004a72:	b735                	j	8000499e <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004a74:	00004517          	auipc	a0,0x4
    80004a78:	b5450513          	addi	a0,a0,-1196 # 800085c8 <etext+0x5c8>
    80004a7c:	00001097          	auipc	ra,0x1
    80004a80:	1c6080e7          	jalr	454(ra) # 80005c42 <panic>
    80004a84:	e9d2                	sd	s4,208(sp)
    80004a86:	e5d6                	sd	s5,200(sp)
    panic("unlink: writei");
    80004a88:	00004517          	auipc	a0,0x4
    80004a8c:	b5850513          	addi	a0,a0,-1192 # 800085e0 <etext+0x5e0>
    80004a90:	00001097          	auipc	ra,0x1
    80004a94:	1b2080e7          	jalr	434(ra) # 80005c42 <panic>
    dp->nlink--;
    80004a98:	04a4d783          	lhu	a5,74(s1)
    80004a9c:	37fd                	addiw	a5,a5,-1
    80004a9e:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004aa2:	8526                	mv	a0,s1
    80004aa4:	ffffe097          	auipc	ra,0xffffe
    80004aa8:	f16080e7          	jalr	-234(ra) # 800029ba <iupdate>
    80004aac:	b725                	j	800049d4 <sys_unlink+0xe0>
    80004aae:	790e                	ld	s2,224(sp)
  iunlockput(dp);
    80004ab0:	8526                	mv	a0,s1
    80004ab2:	ffffe097          	auipc	ra,0xffffe
    80004ab6:	23a080e7          	jalr	570(ra) # 80002cec <iunlockput>
  end_op();
    80004aba:	fffff097          	auipc	ra,0xfffff
    80004abe:	a38080e7          	jalr	-1480(ra) # 800034f2 <end_op>
  return -1;
    80004ac2:	557d                	li	a0,-1
    80004ac4:	74ae                	ld	s1,232(sp)
}
    80004ac6:	70ee                	ld	ra,248(sp)
    80004ac8:	744e                	ld	s0,240(sp)
    80004aca:	6111                	addi	sp,sp,256
    80004acc:	8082                	ret
    return -1;
    80004ace:	557d                	li	a0,-1
    80004ad0:	bfdd                	j	80004ac6 <sys_unlink+0x1d2>
    iunlockput(ip);
    80004ad2:	854a                	mv	a0,s2
    80004ad4:	ffffe097          	auipc	ra,0xffffe
    80004ad8:	218080e7          	jalr	536(ra) # 80002cec <iunlockput>
    goto bad;
    80004adc:	790e                	ld	s2,224(sp)
    80004ade:	69ee                	ld	s3,216(sp)
    80004ae0:	6a4e                	ld	s4,208(sp)
    80004ae2:	6aae                	ld	s5,200(sp)
    80004ae4:	b7f1                	j	80004ab0 <sys_unlink+0x1bc>

0000000080004ae6 <sys_open>:

uint64
sys_open(void)
{
    80004ae6:	7131                	addi	sp,sp,-192
    80004ae8:	fd06                	sd	ra,184(sp)
    80004aea:	f922                	sd	s0,176(sp)
    80004aec:	f526                	sd	s1,168(sp)
    80004aee:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004af0:	08000613          	li	a2,128
    80004af4:	f5040593          	addi	a1,s0,-176
    80004af8:	4501                	li	a0,0
    80004afa:	ffffd097          	auipc	ra,0xffffd
    80004afe:	47c080e7          	jalr	1148(ra) # 80001f76 <argstr>
    return -1;
    80004b02:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004b04:	0c054563          	bltz	a0,80004bce <sys_open+0xe8>
    80004b08:	f4c40593          	addi	a1,s0,-180
    80004b0c:	4505                	li	a0,1
    80004b0e:	ffffd097          	auipc	ra,0xffffd
    80004b12:	424080e7          	jalr	1060(ra) # 80001f32 <argint>
    80004b16:	0a054c63          	bltz	a0,80004bce <sys_open+0xe8>
    80004b1a:	f14a                	sd	s2,160(sp)

  begin_op();
    80004b1c:	fffff097          	auipc	ra,0xfffff
    80004b20:	95c080e7          	jalr	-1700(ra) # 80003478 <begin_op>

  if(omode & O_CREATE){
    80004b24:	f4c42783          	lw	a5,-180(s0)
    80004b28:	2007f793          	andi	a5,a5,512
    80004b2c:	cfcd                	beqz	a5,80004be6 <sys_open+0x100>
    ip = create(path, T_FILE, 0, 0);
    80004b2e:	4681                	li	a3,0
    80004b30:	4601                	li	a2,0
    80004b32:	4589                	li	a1,2
    80004b34:	f5040513          	addi	a0,s0,-176
    80004b38:	00000097          	auipc	ra,0x0
    80004b3c:	948080e7          	jalr	-1720(ra) # 80004480 <create>
    80004b40:	892a                	mv	s2,a0
    if(ip == 0){
    80004b42:	cd41                	beqz	a0,80004bda <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004b44:	04491703          	lh	a4,68(s2)
    80004b48:	478d                	li	a5,3
    80004b4a:	00f71763          	bne	a4,a5,80004b58 <sys_open+0x72>
    80004b4e:	04695703          	lhu	a4,70(s2)
    80004b52:	47a5                	li	a5,9
    80004b54:	0ee7e063          	bltu	a5,a4,80004c34 <sys_open+0x14e>
    80004b58:	ed4e                	sd	s3,152(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004b5a:	fffff097          	auipc	ra,0xfffff
    80004b5e:	d32080e7          	jalr	-718(ra) # 8000388c <filealloc>
    80004b62:	89aa                	mv	s3,a0
    80004b64:	c96d                	beqz	a0,80004c56 <sys_open+0x170>
    80004b66:	00000097          	auipc	ra,0x0
    80004b6a:	8d8080e7          	jalr	-1832(ra) # 8000443e <fdalloc>
    80004b6e:	84aa                	mv	s1,a0
    80004b70:	0c054e63          	bltz	a0,80004c4c <sys_open+0x166>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004b74:	04491703          	lh	a4,68(s2)
    80004b78:	478d                	li	a5,3
    80004b7a:	0ef70b63          	beq	a4,a5,80004c70 <sys_open+0x18a>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004b7e:	4789                	li	a5,2
    80004b80:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004b84:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004b88:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004b8c:	f4c42783          	lw	a5,-180(s0)
    80004b90:	0017f713          	andi	a4,a5,1
    80004b94:	00174713          	xori	a4,a4,1
    80004b98:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004b9c:	0037f713          	andi	a4,a5,3
    80004ba0:	00e03733          	snez	a4,a4
    80004ba4:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004ba8:	4007f793          	andi	a5,a5,1024
    80004bac:	c791                	beqz	a5,80004bb8 <sys_open+0xd2>
    80004bae:	04491703          	lh	a4,68(s2)
    80004bb2:	4789                	li	a5,2
    80004bb4:	0cf70563          	beq	a4,a5,80004c7e <sys_open+0x198>
    itrunc(ip);
  }

  iunlock(ip);
    80004bb8:	854a                	mv	a0,s2
    80004bba:	ffffe097          	auipc	ra,0xffffe
    80004bbe:	f92080e7          	jalr	-110(ra) # 80002b4c <iunlock>
  end_op();
    80004bc2:	fffff097          	auipc	ra,0xfffff
    80004bc6:	930080e7          	jalr	-1744(ra) # 800034f2 <end_op>
    80004bca:	790a                	ld	s2,160(sp)
    80004bcc:	69ea                	ld	s3,152(sp)

  return fd;
}
    80004bce:	8526                	mv	a0,s1
    80004bd0:	70ea                	ld	ra,184(sp)
    80004bd2:	744a                	ld	s0,176(sp)
    80004bd4:	74aa                	ld	s1,168(sp)
    80004bd6:	6129                	addi	sp,sp,192
    80004bd8:	8082                	ret
      end_op();
    80004bda:	fffff097          	auipc	ra,0xfffff
    80004bde:	918080e7          	jalr	-1768(ra) # 800034f2 <end_op>
      return -1;
    80004be2:	790a                	ld	s2,160(sp)
    80004be4:	b7ed                	j	80004bce <sys_open+0xe8>
    if((ip = namei(path)) == 0){
    80004be6:	f5040513          	addi	a0,s0,-176
    80004bea:	ffffe097          	auipc	ra,0xffffe
    80004bee:	688080e7          	jalr	1672(ra) # 80003272 <namei>
    80004bf2:	892a                	mv	s2,a0
    80004bf4:	c90d                	beqz	a0,80004c26 <sys_open+0x140>
    ilock(ip);
    80004bf6:	ffffe097          	auipc	ra,0xffffe
    80004bfa:	e90080e7          	jalr	-368(ra) # 80002a86 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004bfe:	04491703          	lh	a4,68(s2)
    80004c02:	4785                	li	a5,1
    80004c04:	f4f710e3          	bne	a4,a5,80004b44 <sys_open+0x5e>
    80004c08:	f4c42783          	lw	a5,-180(s0)
    80004c0c:	d7b1                	beqz	a5,80004b58 <sys_open+0x72>
      iunlockput(ip);
    80004c0e:	854a                	mv	a0,s2
    80004c10:	ffffe097          	auipc	ra,0xffffe
    80004c14:	0dc080e7          	jalr	220(ra) # 80002cec <iunlockput>
      end_op();
    80004c18:	fffff097          	auipc	ra,0xfffff
    80004c1c:	8da080e7          	jalr	-1830(ra) # 800034f2 <end_op>
      return -1;
    80004c20:	54fd                	li	s1,-1
    80004c22:	790a                	ld	s2,160(sp)
    80004c24:	b76d                	j	80004bce <sys_open+0xe8>
      end_op();
    80004c26:	fffff097          	auipc	ra,0xfffff
    80004c2a:	8cc080e7          	jalr	-1844(ra) # 800034f2 <end_op>
      return -1;
    80004c2e:	54fd                	li	s1,-1
    80004c30:	790a                	ld	s2,160(sp)
    80004c32:	bf71                	j	80004bce <sys_open+0xe8>
    iunlockput(ip);
    80004c34:	854a                	mv	a0,s2
    80004c36:	ffffe097          	auipc	ra,0xffffe
    80004c3a:	0b6080e7          	jalr	182(ra) # 80002cec <iunlockput>
    end_op();
    80004c3e:	fffff097          	auipc	ra,0xfffff
    80004c42:	8b4080e7          	jalr	-1868(ra) # 800034f2 <end_op>
    return -1;
    80004c46:	54fd                	li	s1,-1
    80004c48:	790a                	ld	s2,160(sp)
    80004c4a:	b751                	j	80004bce <sys_open+0xe8>
      fileclose(f);
    80004c4c:	854e                	mv	a0,s3
    80004c4e:	fffff097          	auipc	ra,0xfffff
    80004c52:	cfa080e7          	jalr	-774(ra) # 80003948 <fileclose>
    iunlockput(ip);
    80004c56:	854a                	mv	a0,s2
    80004c58:	ffffe097          	auipc	ra,0xffffe
    80004c5c:	094080e7          	jalr	148(ra) # 80002cec <iunlockput>
    end_op();
    80004c60:	fffff097          	auipc	ra,0xfffff
    80004c64:	892080e7          	jalr	-1902(ra) # 800034f2 <end_op>
    return -1;
    80004c68:	54fd                	li	s1,-1
    80004c6a:	790a                	ld	s2,160(sp)
    80004c6c:	69ea                	ld	s3,152(sp)
    80004c6e:	b785                	j	80004bce <sys_open+0xe8>
    f->type = FD_DEVICE;
    80004c70:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004c74:	04691783          	lh	a5,70(s2)
    80004c78:	02f99223          	sh	a5,36(s3)
    80004c7c:	b731                	j	80004b88 <sys_open+0xa2>
    itrunc(ip);
    80004c7e:	854a                	mv	a0,s2
    80004c80:	ffffe097          	auipc	ra,0xffffe
    80004c84:	f18080e7          	jalr	-232(ra) # 80002b98 <itrunc>
    80004c88:	bf05                	j	80004bb8 <sys_open+0xd2>

0000000080004c8a <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004c8a:	7175                	addi	sp,sp,-144
    80004c8c:	e506                	sd	ra,136(sp)
    80004c8e:	e122                	sd	s0,128(sp)
    80004c90:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004c92:	ffffe097          	auipc	ra,0xffffe
    80004c96:	7e6080e7          	jalr	2022(ra) # 80003478 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004c9a:	08000613          	li	a2,128
    80004c9e:	f7040593          	addi	a1,s0,-144
    80004ca2:	4501                	li	a0,0
    80004ca4:	ffffd097          	auipc	ra,0xffffd
    80004ca8:	2d2080e7          	jalr	722(ra) # 80001f76 <argstr>
    80004cac:	02054963          	bltz	a0,80004cde <sys_mkdir+0x54>
    80004cb0:	4681                	li	a3,0
    80004cb2:	4601                	li	a2,0
    80004cb4:	4585                	li	a1,1
    80004cb6:	f7040513          	addi	a0,s0,-144
    80004cba:	fffff097          	auipc	ra,0xfffff
    80004cbe:	7c6080e7          	jalr	1990(ra) # 80004480 <create>
    80004cc2:	cd11                	beqz	a0,80004cde <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004cc4:	ffffe097          	auipc	ra,0xffffe
    80004cc8:	028080e7          	jalr	40(ra) # 80002cec <iunlockput>
  end_op();
    80004ccc:	fffff097          	auipc	ra,0xfffff
    80004cd0:	826080e7          	jalr	-2010(ra) # 800034f2 <end_op>
  return 0;
    80004cd4:	4501                	li	a0,0
}
    80004cd6:	60aa                	ld	ra,136(sp)
    80004cd8:	640a                	ld	s0,128(sp)
    80004cda:	6149                	addi	sp,sp,144
    80004cdc:	8082                	ret
    end_op();
    80004cde:	fffff097          	auipc	ra,0xfffff
    80004ce2:	814080e7          	jalr	-2028(ra) # 800034f2 <end_op>
    return -1;
    80004ce6:	557d                	li	a0,-1
    80004ce8:	b7fd                	j	80004cd6 <sys_mkdir+0x4c>

0000000080004cea <sys_mknod>:

uint64
sys_mknod(void)
{
    80004cea:	7135                	addi	sp,sp,-160
    80004cec:	ed06                	sd	ra,152(sp)
    80004cee:	e922                	sd	s0,144(sp)
    80004cf0:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004cf2:	ffffe097          	auipc	ra,0xffffe
    80004cf6:	786080e7          	jalr	1926(ra) # 80003478 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004cfa:	08000613          	li	a2,128
    80004cfe:	f7040593          	addi	a1,s0,-144
    80004d02:	4501                	li	a0,0
    80004d04:	ffffd097          	auipc	ra,0xffffd
    80004d08:	272080e7          	jalr	626(ra) # 80001f76 <argstr>
    80004d0c:	04054a63          	bltz	a0,80004d60 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004d10:	f6c40593          	addi	a1,s0,-148
    80004d14:	4505                	li	a0,1
    80004d16:	ffffd097          	auipc	ra,0xffffd
    80004d1a:	21c080e7          	jalr	540(ra) # 80001f32 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d1e:	04054163          	bltz	a0,80004d60 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004d22:	f6840593          	addi	a1,s0,-152
    80004d26:	4509                	li	a0,2
    80004d28:	ffffd097          	auipc	ra,0xffffd
    80004d2c:	20a080e7          	jalr	522(ra) # 80001f32 <argint>
     argint(1, &major) < 0 ||
    80004d30:	02054863          	bltz	a0,80004d60 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004d34:	f6841683          	lh	a3,-152(s0)
    80004d38:	f6c41603          	lh	a2,-148(s0)
    80004d3c:	458d                	li	a1,3
    80004d3e:	f7040513          	addi	a0,s0,-144
    80004d42:	fffff097          	auipc	ra,0xfffff
    80004d46:	73e080e7          	jalr	1854(ra) # 80004480 <create>
     argint(2, &minor) < 0 ||
    80004d4a:	c919                	beqz	a0,80004d60 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004d4c:	ffffe097          	auipc	ra,0xffffe
    80004d50:	fa0080e7          	jalr	-96(ra) # 80002cec <iunlockput>
  end_op();
    80004d54:	ffffe097          	auipc	ra,0xffffe
    80004d58:	79e080e7          	jalr	1950(ra) # 800034f2 <end_op>
  return 0;
    80004d5c:	4501                	li	a0,0
    80004d5e:	a031                	j	80004d6a <sys_mknod+0x80>
    end_op();
    80004d60:	ffffe097          	auipc	ra,0xffffe
    80004d64:	792080e7          	jalr	1938(ra) # 800034f2 <end_op>
    return -1;
    80004d68:	557d                	li	a0,-1
}
    80004d6a:	60ea                	ld	ra,152(sp)
    80004d6c:	644a                	ld	s0,144(sp)
    80004d6e:	610d                	addi	sp,sp,160
    80004d70:	8082                	ret

0000000080004d72 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004d72:	7135                	addi	sp,sp,-160
    80004d74:	ed06                	sd	ra,152(sp)
    80004d76:	e922                	sd	s0,144(sp)
    80004d78:	e14a                	sd	s2,128(sp)
    80004d7a:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004d7c:	ffffc097          	auipc	ra,0xffffc
    80004d80:	0f8080e7          	jalr	248(ra) # 80000e74 <myproc>
    80004d84:	892a                	mv	s2,a0
  
  begin_op();
    80004d86:	ffffe097          	auipc	ra,0xffffe
    80004d8a:	6f2080e7          	jalr	1778(ra) # 80003478 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004d8e:	08000613          	li	a2,128
    80004d92:	f6040593          	addi	a1,s0,-160
    80004d96:	4501                	li	a0,0
    80004d98:	ffffd097          	auipc	ra,0xffffd
    80004d9c:	1de080e7          	jalr	478(ra) # 80001f76 <argstr>
    80004da0:	04054d63          	bltz	a0,80004dfa <sys_chdir+0x88>
    80004da4:	e526                	sd	s1,136(sp)
    80004da6:	f6040513          	addi	a0,s0,-160
    80004daa:	ffffe097          	auipc	ra,0xffffe
    80004dae:	4c8080e7          	jalr	1224(ra) # 80003272 <namei>
    80004db2:	84aa                	mv	s1,a0
    80004db4:	c131                	beqz	a0,80004df8 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004db6:	ffffe097          	auipc	ra,0xffffe
    80004dba:	cd0080e7          	jalr	-816(ra) # 80002a86 <ilock>
  if(ip->type != T_DIR){
    80004dbe:	04449703          	lh	a4,68(s1)
    80004dc2:	4785                	li	a5,1
    80004dc4:	04f71163          	bne	a4,a5,80004e06 <sys_chdir+0x94>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004dc8:	8526                	mv	a0,s1
    80004dca:	ffffe097          	auipc	ra,0xffffe
    80004dce:	d82080e7          	jalr	-638(ra) # 80002b4c <iunlock>
  iput(p->cwd);
    80004dd2:	15093503          	ld	a0,336(s2)
    80004dd6:	ffffe097          	auipc	ra,0xffffe
    80004dda:	e6e080e7          	jalr	-402(ra) # 80002c44 <iput>
  end_op();
    80004dde:	ffffe097          	auipc	ra,0xffffe
    80004de2:	714080e7          	jalr	1812(ra) # 800034f2 <end_op>
  p->cwd = ip;
    80004de6:	14993823          	sd	s1,336(s2)
  return 0;
    80004dea:	4501                	li	a0,0
    80004dec:	64aa                	ld	s1,136(sp)
}
    80004dee:	60ea                	ld	ra,152(sp)
    80004df0:	644a                	ld	s0,144(sp)
    80004df2:	690a                	ld	s2,128(sp)
    80004df4:	610d                	addi	sp,sp,160
    80004df6:	8082                	ret
    80004df8:	64aa                	ld	s1,136(sp)
    end_op();
    80004dfa:	ffffe097          	auipc	ra,0xffffe
    80004dfe:	6f8080e7          	jalr	1784(ra) # 800034f2 <end_op>
    return -1;
    80004e02:	557d                	li	a0,-1
    80004e04:	b7ed                	j	80004dee <sys_chdir+0x7c>
    iunlockput(ip);
    80004e06:	8526                	mv	a0,s1
    80004e08:	ffffe097          	auipc	ra,0xffffe
    80004e0c:	ee4080e7          	jalr	-284(ra) # 80002cec <iunlockput>
    end_op();
    80004e10:	ffffe097          	auipc	ra,0xffffe
    80004e14:	6e2080e7          	jalr	1762(ra) # 800034f2 <end_op>
    return -1;
    80004e18:	557d                	li	a0,-1
    80004e1a:	64aa                	ld	s1,136(sp)
    80004e1c:	bfc9                	j	80004dee <sys_chdir+0x7c>

0000000080004e1e <sys_exec>:

uint64
sys_exec(void)
{
    80004e1e:	7105                	addi	sp,sp,-480
    80004e20:	ef86                	sd	ra,472(sp)
    80004e22:	eba2                	sd	s0,464(sp)
    80004e24:	e3ca                	sd	s2,448(sp)
    80004e26:	1380                	addi	s0,sp,480
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004e28:	08000613          	li	a2,128
    80004e2c:	f3040593          	addi	a1,s0,-208
    80004e30:	4501                	li	a0,0
    80004e32:	ffffd097          	auipc	ra,0xffffd
    80004e36:	144080e7          	jalr	324(ra) # 80001f76 <argstr>
    return -1;
    80004e3a:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004e3c:	10054963          	bltz	a0,80004f4e <sys_exec+0x130>
    80004e40:	e2840593          	addi	a1,s0,-472
    80004e44:	4505                	li	a0,1
    80004e46:	ffffd097          	auipc	ra,0xffffd
    80004e4a:	10e080e7          	jalr	270(ra) # 80001f54 <argaddr>
    80004e4e:	10054063          	bltz	a0,80004f4e <sys_exec+0x130>
    80004e52:	e7a6                	sd	s1,456(sp)
    80004e54:	ff4e                	sd	s3,440(sp)
    80004e56:	fb52                	sd	s4,432(sp)
    80004e58:	f756                	sd	s5,424(sp)
    80004e5a:	f35a                	sd	s6,416(sp)
    80004e5c:	ef5e                	sd	s7,408(sp)
  }
  memset(argv, 0, sizeof(argv));
    80004e5e:	e3040a13          	addi	s4,s0,-464
    80004e62:	10000613          	li	a2,256
    80004e66:	4581                	li	a1,0
    80004e68:	8552                	mv	a0,s4
    80004e6a:	ffffb097          	auipc	ra,0xffffb
    80004e6e:	310080e7          	jalr	784(ra) # 8000017a <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004e72:	84d2                	mv	s1,s4
  memset(argv, 0, sizeof(argv));
    80004e74:	89d2                	mv	s3,s4
    80004e76:	4901                	li	s2,0
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004e78:	e2040a93          	addi	s5,s0,-480
      break;
    }
    argv[i] = kalloc();
    if(argv[i] == 0)
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004e7c:	6b05                	lui	s6,0x1
    if(i >= NELEM(argv)){
    80004e7e:	02000b93          	li	s7,32
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004e82:	00391513          	slli	a0,s2,0x3
    80004e86:	85d6                	mv	a1,s5
    80004e88:	e2843783          	ld	a5,-472(s0)
    80004e8c:	953e                	add	a0,a0,a5
    80004e8e:	ffffd097          	auipc	ra,0xffffd
    80004e92:	00a080e7          	jalr	10(ra) # 80001e98 <fetchaddr>
    80004e96:	02054a63          	bltz	a0,80004eca <sys_exec+0xac>
    if(uarg == 0){
    80004e9a:	e2043783          	ld	a5,-480(s0)
    80004e9e:	cba9                	beqz	a5,80004ef0 <sys_exec+0xd2>
    argv[i] = kalloc();
    80004ea0:	ffffb097          	auipc	ra,0xffffb
    80004ea4:	27a080e7          	jalr	634(ra) # 8000011a <kalloc>
    80004ea8:	85aa                	mv	a1,a0
    80004eaa:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004eae:	cd11                	beqz	a0,80004eca <sys_exec+0xac>
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004eb0:	865a                	mv	a2,s6
    80004eb2:	e2043503          	ld	a0,-480(s0)
    80004eb6:	ffffd097          	auipc	ra,0xffffd
    80004eba:	034080e7          	jalr	52(ra) # 80001eea <fetchstr>
    80004ebe:	00054663          	bltz	a0,80004eca <sys_exec+0xac>
    if(i >= NELEM(argv)){
    80004ec2:	0905                	addi	s2,s2,1
    80004ec4:	09a1                	addi	s3,s3,8
    80004ec6:	fb791ee3          	bne	s2,s7,80004e82 <sys_exec+0x64>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004eca:	100a0a13          	addi	s4,s4,256
    80004ece:	6088                	ld	a0,0(s1)
    80004ed0:	c925                	beqz	a0,80004f40 <sys_exec+0x122>
    kfree(argv[i]);
    80004ed2:	ffffb097          	auipc	ra,0xffffb
    80004ed6:	14a080e7          	jalr	330(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004eda:	04a1                	addi	s1,s1,8
    80004edc:	ff4499e3          	bne	s1,s4,80004ece <sys_exec+0xb0>
  return -1;
    80004ee0:	597d                	li	s2,-1
    80004ee2:	64be                	ld	s1,456(sp)
    80004ee4:	79fa                	ld	s3,440(sp)
    80004ee6:	7a5a                	ld	s4,432(sp)
    80004ee8:	7aba                	ld	s5,424(sp)
    80004eea:	7b1a                	ld	s6,416(sp)
    80004eec:	6bfa                	ld	s7,408(sp)
    80004eee:	a085                	j	80004f4e <sys_exec+0x130>
      argv[i] = 0;
    80004ef0:	0009079b          	sext.w	a5,s2
    80004ef4:	e3040593          	addi	a1,s0,-464
    80004ef8:	078e                	slli	a5,a5,0x3
    80004efa:	97ae                	add	a5,a5,a1
    80004efc:	0007b023          	sd	zero,0(a5)
  int ret = exec(path, argv);
    80004f00:	f3040513          	addi	a0,s0,-208
    80004f04:	fffff097          	auipc	ra,0xfffff
    80004f08:	122080e7          	jalr	290(ra) # 80004026 <exec>
    80004f0c:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f0e:	100a0a13          	addi	s4,s4,256
    80004f12:	6088                	ld	a0,0(s1)
    80004f14:	cd19                	beqz	a0,80004f32 <sys_exec+0x114>
    kfree(argv[i]);
    80004f16:	ffffb097          	auipc	ra,0xffffb
    80004f1a:	106080e7          	jalr	262(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f1e:	04a1                	addi	s1,s1,8
    80004f20:	ff4499e3          	bne	s1,s4,80004f12 <sys_exec+0xf4>
    80004f24:	64be                	ld	s1,456(sp)
    80004f26:	79fa                	ld	s3,440(sp)
    80004f28:	7a5a                	ld	s4,432(sp)
    80004f2a:	7aba                	ld	s5,424(sp)
    80004f2c:	7b1a                	ld	s6,416(sp)
    80004f2e:	6bfa                	ld	s7,408(sp)
    80004f30:	a839                	j	80004f4e <sys_exec+0x130>
  return ret;
    80004f32:	64be                	ld	s1,456(sp)
    80004f34:	79fa                	ld	s3,440(sp)
    80004f36:	7a5a                	ld	s4,432(sp)
    80004f38:	7aba                	ld	s5,424(sp)
    80004f3a:	7b1a                	ld	s6,416(sp)
    80004f3c:	6bfa                	ld	s7,408(sp)
    80004f3e:	a801                	j	80004f4e <sys_exec+0x130>
  return -1;
    80004f40:	597d                	li	s2,-1
    80004f42:	64be                	ld	s1,456(sp)
    80004f44:	79fa                	ld	s3,440(sp)
    80004f46:	7a5a                	ld	s4,432(sp)
    80004f48:	7aba                	ld	s5,424(sp)
    80004f4a:	7b1a                	ld	s6,416(sp)
    80004f4c:	6bfa                	ld	s7,408(sp)
}
    80004f4e:	854a                	mv	a0,s2
    80004f50:	60fe                	ld	ra,472(sp)
    80004f52:	645e                	ld	s0,464(sp)
    80004f54:	691e                	ld	s2,448(sp)
    80004f56:	613d                	addi	sp,sp,480
    80004f58:	8082                	ret

0000000080004f5a <sys_pipe>:

uint64
sys_pipe(void)
{
    80004f5a:	7139                	addi	sp,sp,-64
    80004f5c:	fc06                	sd	ra,56(sp)
    80004f5e:	f822                	sd	s0,48(sp)
    80004f60:	f426                	sd	s1,40(sp)
    80004f62:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004f64:	ffffc097          	auipc	ra,0xffffc
    80004f68:	f10080e7          	jalr	-240(ra) # 80000e74 <myproc>
    80004f6c:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80004f6e:	fd840593          	addi	a1,s0,-40
    80004f72:	4501                	li	a0,0
    80004f74:	ffffd097          	auipc	ra,0xffffd
    80004f78:	fe0080e7          	jalr	-32(ra) # 80001f54 <argaddr>
    return -1;
    80004f7c:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80004f7e:	0e054063          	bltz	a0,8000505e <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80004f82:	fc840593          	addi	a1,s0,-56
    80004f86:	fd040513          	addi	a0,s0,-48
    80004f8a:	fffff097          	auipc	ra,0xfffff
    80004f8e:	d32080e7          	jalr	-718(ra) # 80003cbc <pipealloc>
    return -1;
    80004f92:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004f94:	0c054563          	bltz	a0,8000505e <sys_pipe+0x104>
  fd0 = -1;
    80004f98:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004f9c:	fd043503          	ld	a0,-48(s0)
    80004fa0:	fffff097          	auipc	ra,0xfffff
    80004fa4:	49e080e7          	jalr	1182(ra) # 8000443e <fdalloc>
    80004fa8:	fca42223          	sw	a0,-60(s0)
    80004fac:	08054c63          	bltz	a0,80005044 <sys_pipe+0xea>
    80004fb0:	fc843503          	ld	a0,-56(s0)
    80004fb4:	fffff097          	auipc	ra,0xfffff
    80004fb8:	48a080e7          	jalr	1162(ra) # 8000443e <fdalloc>
    80004fbc:	fca42023          	sw	a0,-64(s0)
    80004fc0:	06054963          	bltz	a0,80005032 <sys_pipe+0xd8>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004fc4:	4691                	li	a3,4
    80004fc6:	fc440613          	addi	a2,s0,-60
    80004fca:	fd843583          	ld	a1,-40(s0)
    80004fce:	68a8                	ld	a0,80(s1)
    80004fd0:	ffffc097          	auipc	ra,0xffffc
    80004fd4:	b50080e7          	jalr	-1200(ra) # 80000b20 <copyout>
    80004fd8:	02054063          	bltz	a0,80004ff8 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004fdc:	4691                	li	a3,4
    80004fde:	fc040613          	addi	a2,s0,-64
    80004fe2:	fd843583          	ld	a1,-40(s0)
    80004fe6:	95b6                	add	a1,a1,a3
    80004fe8:	68a8                	ld	a0,80(s1)
    80004fea:	ffffc097          	auipc	ra,0xffffc
    80004fee:	b36080e7          	jalr	-1226(ra) # 80000b20 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004ff2:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004ff4:	06055563          	bgez	a0,8000505e <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80004ff8:	fc442783          	lw	a5,-60(s0)
    80004ffc:	07e9                	addi	a5,a5,26
    80004ffe:	078e                	slli	a5,a5,0x3
    80005000:	97a6                	add	a5,a5,s1
    80005002:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005006:	fc042783          	lw	a5,-64(s0)
    8000500a:	07e9                	addi	a5,a5,26
    8000500c:	078e                	slli	a5,a5,0x3
    8000500e:	00f48533          	add	a0,s1,a5
    80005012:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005016:	fd043503          	ld	a0,-48(s0)
    8000501a:	fffff097          	auipc	ra,0xfffff
    8000501e:	92e080e7          	jalr	-1746(ra) # 80003948 <fileclose>
    fileclose(wf);
    80005022:	fc843503          	ld	a0,-56(s0)
    80005026:	fffff097          	auipc	ra,0xfffff
    8000502a:	922080e7          	jalr	-1758(ra) # 80003948 <fileclose>
    return -1;
    8000502e:	57fd                	li	a5,-1
    80005030:	a03d                	j	8000505e <sys_pipe+0x104>
    if(fd0 >= 0)
    80005032:	fc442783          	lw	a5,-60(s0)
    80005036:	0007c763          	bltz	a5,80005044 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    8000503a:	07e9                	addi	a5,a5,26
    8000503c:	078e                	slli	a5,a5,0x3
    8000503e:	97a6                	add	a5,a5,s1
    80005040:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005044:	fd043503          	ld	a0,-48(s0)
    80005048:	fffff097          	auipc	ra,0xfffff
    8000504c:	900080e7          	jalr	-1792(ra) # 80003948 <fileclose>
    fileclose(wf);
    80005050:	fc843503          	ld	a0,-56(s0)
    80005054:	fffff097          	auipc	ra,0xfffff
    80005058:	8f4080e7          	jalr	-1804(ra) # 80003948 <fileclose>
    return -1;
    8000505c:	57fd                	li	a5,-1
}
    8000505e:	853e                	mv	a0,a5
    80005060:	70e2                	ld	ra,56(sp)
    80005062:	7442                	ld	s0,48(sp)
    80005064:	74a2                	ld	s1,40(sp)
    80005066:	6121                	addi	sp,sp,64
    80005068:	8082                	ret
    8000506a:	0000                	unimp
    8000506c:	0000                	unimp
	...

0000000080005070 <kernelvec>:
    80005070:	7111                	addi	sp,sp,-256
    80005072:	e006                	sd	ra,0(sp)
    80005074:	e40a                	sd	sp,8(sp)
    80005076:	e80e                	sd	gp,16(sp)
    80005078:	ec12                	sd	tp,24(sp)
    8000507a:	f016                	sd	t0,32(sp)
    8000507c:	f41a                	sd	t1,40(sp)
    8000507e:	f81e                	sd	t2,48(sp)
    80005080:	fc22                	sd	s0,56(sp)
    80005082:	e0a6                	sd	s1,64(sp)
    80005084:	e4aa                	sd	a0,72(sp)
    80005086:	e8ae                	sd	a1,80(sp)
    80005088:	ecb2                	sd	a2,88(sp)
    8000508a:	f0b6                	sd	a3,96(sp)
    8000508c:	f4ba                	sd	a4,104(sp)
    8000508e:	f8be                	sd	a5,112(sp)
    80005090:	fcc2                	sd	a6,120(sp)
    80005092:	e146                	sd	a7,128(sp)
    80005094:	e54a                	sd	s2,136(sp)
    80005096:	e94e                	sd	s3,144(sp)
    80005098:	ed52                	sd	s4,152(sp)
    8000509a:	f156                	sd	s5,160(sp)
    8000509c:	f55a                	sd	s6,168(sp)
    8000509e:	f95e                	sd	s7,176(sp)
    800050a0:	fd62                	sd	s8,184(sp)
    800050a2:	e1e6                	sd	s9,192(sp)
    800050a4:	e5ea                	sd	s10,200(sp)
    800050a6:	e9ee                	sd	s11,208(sp)
    800050a8:	edf2                	sd	t3,216(sp)
    800050aa:	f1f6                	sd	t4,224(sp)
    800050ac:	f5fa                	sd	t5,232(sp)
    800050ae:	f9fe                	sd	t6,240(sp)
    800050b0:	cb5fc0ef          	jal	80001d64 <kerneltrap>
    800050b4:	6082                	ld	ra,0(sp)
    800050b6:	6122                	ld	sp,8(sp)
    800050b8:	61c2                	ld	gp,16(sp)
    800050ba:	7282                	ld	t0,32(sp)
    800050bc:	7322                	ld	t1,40(sp)
    800050be:	73c2                	ld	t2,48(sp)
    800050c0:	7462                	ld	s0,56(sp)
    800050c2:	6486                	ld	s1,64(sp)
    800050c4:	6526                	ld	a0,72(sp)
    800050c6:	65c6                	ld	a1,80(sp)
    800050c8:	6666                	ld	a2,88(sp)
    800050ca:	7686                	ld	a3,96(sp)
    800050cc:	7726                	ld	a4,104(sp)
    800050ce:	77c6                	ld	a5,112(sp)
    800050d0:	7866                	ld	a6,120(sp)
    800050d2:	688a                	ld	a7,128(sp)
    800050d4:	692a                	ld	s2,136(sp)
    800050d6:	69ca                	ld	s3,144(sp)
    800050d8:	6a6a                	ld	s4,152(sp)
    800050da:	7a8a                	ld	s5,160(sp)
    800050dc:	7b2a                	ld	s6,168(sp)
    800050de:	7bca                	ld	s7,176(sp)
    800050e0:	7c6a                	ld	s8,184(sp)
    800050e2:	6c8e                	ld	s9,192(sp)
    800050e4:	6d2e                	ld	s10,200(sp)
    800050e6:	6dce                	ld	s11,208(sp)
    800050e8:	6e6e                	ld	t3,216(sp)
    800050ea:	7e8e                	ld	t4,224(sp)
    800050ec:	7f2e                	ld	t5,232(sp)
    800050ee:	7fce                	ld	t6,240(sp)
    800050f0:	6111                	addi	sp,sp,256
    800050f2:	10200073          	sret
    800050f6:	00000013          	nop
    800050fa:	00000013          	nop
    800050fe:	0001                	nop

0000000080005100 <timervec>:
    80005100:	34051573          	csrrw	a0,mscratch,a0
    80005104:	e10c                	sd	a1,0(a0)
    80005106:	e510                	sd	a2,8(a0)
    80005108:	e914                	sd	a3,16(a0)
    8000510a:	6d0c                	ld	a1,24(a0)
    8000510c:	7110                	ld	a2,32(a0)
    8000510e:	6194                	ld	a3,0(a1)
    80005110:	96b2                	add	a3,a3,a2
    80005112:	e194                	sd	a3,0(a1)
    80005114:	4589                	li	a1,2
    80005116:	14459073          	csrw	sip,a1
    8000511a:	6914                	ld	a3,16(a0)
    8000511c:	6510                	ld	a2,8(a0)
    8000511e:	610c                	ld	a1,0(a0)
    80005120:	34051573          	csrrw	a0,mscratch,a0
    80005124:	30200073          	mret
	...

000000008000512a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000512a:	1141                	addi	sp,sp,-16
    8000512c:	e406                	sd	ra,8(sp)
    8000512e:	e022                	sd	s0,0(sp)
    80005130:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005132:	0c000737          	lui	a4,0xc000
    80005136:	4785                	li	a5,1
    80005138:	d71c                	sw	a5,40(a4)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    8000513a:	c35c                	sw	a5,4(a4)
}
    8000513c:	60a2                	ld	ra,8(sp)
    8000513e:	6402                	ld	s0,0(sp)
    80005140:	0141                	addi	sp,sp,16
    80005142:	8082                	ret

0000000080005144 <plicinithart>:

void
plicinithart(void)
{
    80005144:	1141                	addi	sp,sp,-16
    80005146:	e406                	sd	ra,8(sp)
    80005148:	e022                	sd	s0,0(sp)
    8000514a:	0800                	addi	s0,sp,16
  int hart = cpuid();
    8000514c:	ffffc097          	auipc	ra,0xffffc
    80005150:	cf4080e7          	jalr	-780(ra) # 80000e40 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005154:	0085171b          	slliw	a4,a0,0x8
    80005158:	0c0027b7          	lui	a5,0xc002
    8000515c:	97ba                	add	a5,a5,a4
    8000515e:	40200713          	li	a4,1026
    80005162:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005166:	00d5151b          	slliw	a0,a0,0xd
    8000516a:	0c2017b7          	lui	a5,0xc201
    8000516e:	97aa                	add	a5,a5,a0
    80005170:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005174:	60a2                	ld	ra,8(sp)
    80005176:	6402                	ld	s0,0(sp)
    80005178:	0141                	addi	sp,sp,16
    8000517a:	8082                	ret

000000008000517c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000517c:	1141                	addi	sp,sp,-16
    8000517e:	e406                	sd	ra,8(sp)
    80005180:	e022                	sd	s0,0(sp)
    80005182:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005184:	ffffc097          	auipc	ra,0xffffc
    80005188:	cbc080e7          	jalr	-836(ra) # 80000e40 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    8000518c:	00d5151b          	slliw	a0,a0,0xd
    80005190:	0c2017b7          	lui	a5,0xc201
    80005194:	97aa                	add	a5,a5,a0
  return irq;
}
    80005196:	43c8                	lw	a0,4(a5)
    80005198:	60a2                	ld	ra,8(sp)
    8000519a:	6402                	ld	s0,0(sp)
    8000519c:	0141                	addi	sp,sp,16
    8000519e:	8082                	ret

00000000800051a0 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800051a0:	1101                	addi	sp,sp,-32
    800051a2:	ec06                	sd	ra,24(sp)
    800051a4:	e822                	sd	s0,16(sp)
    800051a6:	e426                	sd	s1,8(sp)
    800051a8:	1000                	addi	s0,sp,32
    800051aa:	84aa                	mv	s1,a0
  int hart = cpuid();
    800051ac:	ffffc097          	auipc	ra,0xffffc
    800051b0:	c94080e7          	jalr	-876(ra) # 80000e40 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800051b4:	00d5179b          	slliw	a5,a0,0xd
    800051b8:	0c201737          	lui	a4,0xc201
    800051bc:	97ba                	add	a5,a5,a4
    800051be:	c3c4                	sw	s1,4(a5)
}
    800051c0:	60e2                	ld	ra,24(sp)
    800051c2:	6442                	ld	s0,16(sp)
    800051c4:	64a2                	ld	s1,8(sp)
    800051c6:	6105                	addi	sp,sp,32
    800051c8:	8082                	ret

00000000800051ca <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800051ca:	1141                	addi	sp,sp,-16
    800051cc:	e406                	sd	ra,8(sp)
    800051ce:	e022                	sd	s0,0(sp)
    800051d0:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800051d2:	479d                	li	a5,7
    800051d4:	06a7c863          	blt	a5,a0,80005244 <free_desc+0x7a>
    panic("free_desc 1");
  if(disk.free[i])
    800051d8:	00016717          	auipc	a4,0x16
    800051dc:	e2870713          	addi	a4,a4,-472 # 8001b000 <disk>
    800051e0:	972a                	add	a4,a4,a0
    800051e2:	6789                	lui	a5,0x2
    800051e4:	97ba                	add	a5,a5,a4
    800051e6:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    800051ea:	e7ad                	bnez	a5,80005254 <free_desc+0x8a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800051ec:	00451793          	slli	a5,a0,0x4
    800051f0:	00018717          	auipc	a4,0x18
    800051f4:	e1070713          	addi	a4,a4,-496 # 8001d000 <disk+0x2000>
    800051f8:	6314                	ld	a3,0(a4)
    800051fa:	96be                	add	a3,a3,a5
    800051fc:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    80005200:	6314                	ld	a3,0(a4)
    80005202:	96be                	add	a3,a3,a5
    80005204:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005208:	6314                	ld	a3,0(a4)
    8000520a:	96be                	add	a3,a3,a5
    8000520c:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    80005210:	6318                	ld	a4,0(a4)
    80005212:	97ba                	add	a5,a5,a4
    80005214:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005218:	00016717          	auipc	a4,0x16
    8000521c:	de870713          	addi	a4,a4,-536 # 8001b000 <disk>
    80005220:	972a                	add	a4,a4,a0
    80005222:	6789                	lui	a5,0x2
    80005224:	97ba                	add	a5,a5,a4
    80005226:	4705                	li	a4,1
    80005228:	00e78c23          	sb	a4,24(a5) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    8000522c:	00018517          	auipc	a0,0x18
    80005230:	dec50513          	addi	a0,a0,-532 # 8001d018 <disk+0x2018>
    80005234:	ffffc097          	auipc	ra,0xffffc
    80005238:	48c080e7          	jalr	1164(ra) # 800016c0 <wakeup>
}
    8000523c:	60a2                	ld	ra,8(sp)
    8000523e:	6402                	ld	s0,0(sp)
    80005240:	0141                	addi	sp,sp,16
    80005242:	8082                	ret
    panic("free_desc 1");
    80005244:	00003517          	auipc	a0,0x3
    80005248:	3ac50513          	addi	a0,a0,940 # 800085f0 <etext+0x5f0>
    8000524c:	00001097          	auipc	ra,0x1
    80005250:	9f6080e7          	jalr	-1546(ra) # 80005c42 <panic>
    panic("free_desc 2");
    80005254:	00003517          	auipc	a0,0x3
    80005258:	3ac50513          	addi	a0,a0,940 # 80008600 <etext+0x600>
    8000525c:	00001097          	auipc	ra,0x1
    80005260:	9e6080e7          	jalr	-1562(ra) # 80005c42 <panic>

0000000080005264 <virtio_disk_init>:
{
    80005264:	1141                	addi	sp,sp,-16
    80005266:	e406                	sd	ra,8(sp)
    80005268:	e022                	sd	s0,0(sp)
    8000526a:	0800                	addi	s0,sp,16
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000526c:	00003597          	auipc	a1,0x3
    80005270:	3a458593          	addi	a1,a1,932 # 80008610 <etext+0x610>
    80005274:	00018517          	auipc	a0,0x18
    80005278:	eb450513          	addi	a0,a0,-332 # 8001d128 <disk+0x2128>
    8000527c:	00001097          	auipc	ra,0x1
    80005280:	eb2080e7          	jalr	-334(ra) # 8000612e <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005284:	100017b7          	lui	a5,0x10001
    80005288:	4398                	lw	a4,0(a5)
    8000528a:	2701                	sext.w	a4,a4
    8000528c:	747277b7          	lui	a5,0x74727
    80005290:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005294:	0ef71563          	bne	a4,a5,8000537e <virtio_disk_init+0x11a>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005298:	100017b7          	lui	a5,0x10001
    8000529c:	43dc                	lw	a5,4(a5)
    8000529e:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800052a0:	4705                	li	a4,1
    800052a2:	0ce79e63          	bne	a5,a4,8000537e <virtio_disk_init+0x11a>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800052a6:	100017b7          	lui	a5,0x10001
    800052aa:	479c                	lw	a5,8(a5)
    800052ac:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800052ae:	4709                	li	a4,2
    800052b0:	0ce79763          	bne	a5,a4,8000537e <virtio_disk_init+0x11a>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800052b4:	100017b7          	lui	a5,0x10001
    800052b8:	47d8                	lw	a4,12(a5)
    800052ba:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800052bc:	554d47b7          	lui	a5,0x554d4
    800052c0:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800052c4:	0af71d63          	bne	a4,a5,8000537e <virtio_disk_init+0x11a>
  *R(VIRTIO_MMIO_STATUS) = status;
    800052c8:	100017b7          	lui	a5,0x10001
    800052cc:	4705                	li	a4,1
    800052ce:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800052d0:	470d                	li	a4,3
    800052d2:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800052d4:	10001737          	lui	a4,0x10001
    800052d8:	4b18                	lw	a4,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800052da:	c7ffe6b7          	lui	a3,0xc7ffe
    800052de:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fd851f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800052e2:	8f75                	and	a4,a4,a3
    800052e4:	100016b7          	lui	a3,0x10001
    800052e8:	d298                	sw	a4,32(a3)
  *R(VIRTIO_MMIO_STATUS) = status;
    800052ea:	472d                	li	a4,11
    800052ec:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800052ee:	473d                	li	a4,15
    800052f0:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    800052f2:	6705                	lui	a4,0x1
    800052f4:	d698                	sw	a4,40(a3)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800052f6:	0206a823          	sw	zero,48(a3) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800052fa:	5adc                	lw	a5,52(a3)
    800052fc:	2781                	sext.w	a5,a5
  if(max == 0)
    800052fe:	cbc1                	beqz	a5,8000538e <virtio_disk_init+0x12a>
  if(max < NUM)
    80005300:	471d                	li	a4,7
    80005302:	08f77e63          	bgeu	a4,a5,8000539e <virtio_disk_init+0x13a>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005306:	100017b7          	lui	a5,0x10001
    8000530a:	4721                	li	a4,8
    8000530c:	df98                	sw	a4,56(a5)
  memset(disk.pages, 0, sizeof(disk.pages));
    8000530e:	6609                	lui	a2,0x2
    80005310:	4581                	li	a1,0
    80005312:	00016517          	auipc	a0,0x16
    80005316:	cee50513          	addi	a0,a0,-786 # 8001b000 <disk>
    8000531a:	ffffb097          	auipc	ra,0xffffb
    8000531e:	e60080e7          	jalr	-416(ra) # 8000017a <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    80005322:	00016717          	auipc	a4,0x16
    80005326:	cde70713          	addi	a4,a4,-802 # 8001b000 <disk>
    8000532a:	00c75793          	srli	a5,a4,0xc
    8000532e:	2781                	sext.w	a5,a5
    80005330:	100016b7          	lui	a3,0x10001
    80005334:	c2bc                	sw	a5,64(a3)
  disk.desc = (struct virtq_desc *) disk.pages;
    80005336:	00018797          	auipc	a5,0x18
    8000533a:	cca78793          	addi	a5,a5,-822 # 8001d000 <disk+0x2000>
    8000533e:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005340:	00016717          	auipc	a4,0x16
    80005344:	d4070713          	addi	a4,a4,-704 # 8001b080 <disk+0x80>
    80005348:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    8000534a:	00017717          	auipc	a4,0x17
    8000534e:	cb670713          	addi	a4,a4,-842 # 8001c000 <disk+0x1000>
    80005352:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    80005354:	4705                	li	a4,1
    80005356:	00e78c23          	sb	a4,24(a5)
    8000535a:	00e78ca3          	sb	a4,25(a5)
    8000535e:	00e78d23          	sb	a4,26(a5)
    80005362:	00e78da3          	sb	a4,27(a5)
    80005366:	00e78e23          	sb	a4,28(a5)
    8000536a:	00e78ea3          	sb	a4,29(a5)
    8000536e:	00e78f23          	sb	a4,30(a5)
    80005372:	00e78fa3          	sb	a4,31(a5)
}
    80005376:	60a2                	ld	ra,8(sp)
    80005378:	6402                	ld	s0,0(sp)
    8000537a:	0141                	addi	sp,sp,16
    8000537c:	8082                	ret
    panic("could not find virtio disk");
    8000537e:	00003517          	auipc	a0,0x3
    80005382:	2a250513          	addi	a0,a0,674 # 80008620 <etext+0x620>
    80005386:	00001097          	auipc	ra,0x1
    8000538a:	8bc080e7          	jalr	-1860(ra) # 80005c42 <panic>
    panic("virtio disk has no queue 0");
    8000538e:	00003517          	auipc	a0,0x3
    80005392:	2b250513          	addi	a0,a0,690 # 80008640 <etext+0x640>
    80005396:	00001097          	auipc	ra,0x1
    8000539a:	8ac080e7          	jalr	-1876(ra) # 80005c42 <panic>
    panic("virtio disk max queue too short");
    8000539e:	00003517          	auipc	a0,0x3
    800053a2:	2c250513          	addi	a0,a0,706 # 80008660 <etext+0x660>
    800053a6:	00001097          	auipc	ra,0x1
    800053aa:	89c080e7          	jalr	-1892(ra) # 80005c42 <panic>

00000000800053ae <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800053ae:	711d                	addi	sp,sp,-96
    800053b0:	ec86                	sd	ra,88(sp)
    800053b2:	e8a2                	sd	s0,80(sp)
    800053b4:	e4a6                	sd	s1,72(sp)
    800053b6:	e0ca                	sd	s2,64(sp)
    800053b8:	fc4e                	sd	s3,56(sp)
    800053ba:	f852                	sd	s4,48(sp)
    800053bc:	f456                	sd	s5,40(sp)
    800053be:	f05a                	sd	s6,32(sp)
    800053c0:	ec5e                	sd	s7,24(sp)
    800053c2:	e862                	sd	s8,16(sp)
    800053c4:	1080                	addi	s0,sp,96
    800053c6:	89aa                	mv	s3,a0
    800053c8:	8c2e                	mv	s8,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800053ca:	00c52b83          	lw	s7,12(a0)
    800053ce:	001b9b9b          	slliw	s7,s7,0x1
    800053d2:	1b82                	slli	s7,s7,0x20
    800053d4:	020bdb93          	srli	s7,s7,0x20

  acquire(&disk.vdisk_lock);
    800053d8:	00018517          	auipc	a0,0x18
    800053dc:	d5050513          	addi	a0,a0,-688 # 8001d128 <disk+0x2128>
    800053e0:	00001097          	auipc	ra,0x1
    800053e4:	de2080e7          	jalr	-542(ra) # 800061c2 <acquire>
  for(int i = 0; i < NUM; i++){
    800053e8:	44a1                	li	s1,8
      disk.free[i] = 0;
    800053ea:	00016b17          	auipc	s6,0x16
    800053ee:	c16b0b13          	addi	s6,s6,-1002 # 8001b000 <disk>
    800053f2:	6a89                	lui	s5,0x2
  for(int i = 0; i < 3; i++){
    800053f4:	4a0d                	li	s4,3
    800053f6:	a88d                	j	80005468 <virtio_disk_rw+0xba>
      disk.free[i] = 0;
    800053f8:	00fb0733          	add	a4,s6,a5
    800053fc:	9756                	add	a4,a4,s5
    800053fe:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80005402:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80005404:	0207c563          	bltz	a5,8000542e <virtio_disk_rw+0x80>
  for(int i = 0; i < 3; i++){
    80005408:	2905                	addiw	s2,s2,1
    8000540a:	0611                	addi	a2,a2,4 # 2004 <_entry-0x7fffdffc>
    8000540c:	1b490063          	beq	s2,s4,800055ac <virtio_disk_rw+0x1fe>
    idx[i] = alloc_desc();
    80005410:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80005412:	00018717          	auipc	a4,0x18
    80005416:	c0670713          	addi	a4,a4,-1018 # 8001d018 <disk+0x2018>
    8000541a:	4781                	li	a5,0
    if(disk.free[i]){
    8000541c:	00074683          	lbu	a3,0(a4)
    80005420:	fee1                	bnez	a3,800053f8 <virtio_disk_rw+0x4a>
  for(int i = 0; i < NUM; i++){
    80005422:	2785                	addiw	a5,a5,1
    80005424:	0705                	addi	a4,a4,1
    80005426:	fe979be3          	bne	a5,s1,8000541c <virtio_disk_rw+0x6e>
    idx[i] = alloc_desc();
    8000542a:	57fd                	li	a5,-1
    8000542c:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    8000542e:	03205163          	blez	s2,80005450 <virtio_disk_rw+0xa2>
        free_desc(idx[j]);
    80005432:	fa042503          	lw	a0,-96(s0)
    80005436:	00000097          	auipc	ra,0x0
    8000543a:	d94080e7          	jalr	-620(ra) # 800051ca <free_desc>
      for(int j = 0; j < i; j++)
    8000543e:	4785                	li	a5,1
    80005440:	0127d863          	bge	a5,s2,80005450 <virtio_disk_rw+0xa2>
        free_desc(idx[j]);
    80005444:	fa442503          	lw	a0,-92(s0)
    80005448:	00000097          	auipc	ra,0x0
    8000544c:	d82080e7          	jalr	-638(ra) # 800051ca <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005450:	00018597          	auipc	a1,0x18
    80005454:	cd858593          	addi	a1,a1,-808 # 8001d128 <disk+0x2128>
    80005458:	00018517          	auipc	a0,0x18
    8000545c:	bc050513          	addi	a0,a0,-1088 # 8001d018 <disk+0x2018>
    80005460:	ffffc097          	auipc	ra,0xffffc
    80005464:	0da080e7          	jalr	218(ra) # 8000153a <sleep>
  for(int i = 0; i < 3; i++){
    80005468:	fa040613          	addi	a2,s0,-96
    8000546c:	4901                	li	s2,0
    8000546e:	b74d                	j	80005410 <virtio_disk_rw+0x62>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80005470:	00018717          	auipc	a4,0x18
    80005474:	b9073703          	ld	a4,-1136(a4) # 8001d000 <disk+0x2000>
    80005478:	973e                	add	a4,a4,a5
    8000547a:	00071623          	sh	zero,12(a4)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000547e:	00016897          	auipc	a7,0x16
    80005482:	b8288893          	addi	a7,a7,-1150 # 8001b000 <disk>
    80005486:	00018717          	auipc	a4,0x18
    8000548a:	b7a70713          	addi	a4,a4,-1158 # 8001d000 <disk+0x2000>
    8000548e:	6314                	ld	a3,0(a4)
    80005490:	96be                	add	a3,a3,a5
    80005492:	00c6d583          	lhu	a1,12(a3) # 1000100c <_entry-0x6fffeff4>
    80005496:	0015e593          	ori	a1,a1,1
    8000549a:	00b69623          	sh	a1,12(a3)
  disk.desc[idx[1]].next = idx[2];
    8000549e:	fa842683          	lw	a3,-88(s0)
    800054a2:	630c                	ld	a1,0(a4)
    800054a4:	97ae                	add	a5,a5,a1
    800054a6:	00d79723          	sh	a3,14(a5)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800054aa:	20050593          	addi	a1,a0,512
    800054ae:	0592                	slli	a1,a1,0x4
    800054b0:	95c6                	add	a1,a1,a7
    800054b2:	57fd                	li	a5,-1
    800054b4:	02f58823          	sb	a5,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800054b8:	00469793          	slli	a5,a3,0x4
    800054bc:	00073803          	ld	a6,0(a4)
    800054c0:	983e                	add	a6,a6,a5
    800054c2:	6689                	lui	a3,0x2
    800054c4:	03068693          	addi	a3,a3,48 # 2030 <_entry-0x7fffdfd0>
    800054c8:	96b2                	add	a3,a3,a2
    800054ca:	96c6                	add	a3,a3,a7
    800054cc:	00d83023          	sd	a3,0(a6)
  disk.desc[idx[2]].len = 1;
    800054d0:	6314                	ld	a3,0(a4)
    800054d2:	96be                	add	a3,a3,a5
    800054d4:	4605                	li	a2,1
    800054d6:	c690                	sw	a2,8(a3)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800054d8:	6314                	ld	a3,0(a4)
    800054da:	96be                	add	a3,a3,a5
    800054dc:	4809                	li	a6,2
    800054de:	01069623          	sh	a6,12(a3)
  disk.desc[idx[2]].next = 0;
    800054e2:	6314                	ld	a3,0(a4)
    800054e4:	97b6                	add	a5,a5,a3
    800054e6:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800054ea:	00c9a223          	sw	a2,4(s3)
  disk.info[idx[0]].b = b;
    800054ee:	0335b423          	sd	s3,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800054f2:	6714                	ld	a3,8(a4)
    800054f4:	0026d783          	lhu	a5,2(a3)
    800054f8:	8b9d                	andi	a5,a5,7
    800054fa:	0786                	slli	a5,a5,0x1
    800054fc:	96be                	add	a3,a3,a5
    800054fe:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80005502:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005506:	6718                	ld	a4,8(a4)
    80005508:	00275783          	lhu	a5,2(a4)
    8000550c:	2785                	addiw	a5,a5,1
    8000550e:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005512:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005516:	100017b7          	lui	a5,0x10001
    8000551a:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    8000551e:	0049a783          	lw	a5,4(s3)
    80005522:	02c79163          	bne	a5,a2,80005544 <virtio_disk_rw+0x196>
    sleep(b, &disk.vdisk_lock);
    80005526:	00018917          	auipc	s2,0x18
    8000552a:	c0290913          	addi	s2,s2,-1022 # 8001d128 <disk+0x2128>
  while(b->disk == 1) {
    8000552e:	84b2                	mv	s1,a2
    sleep(b, &disk.vdisk_lock);
    80005530:	85ca                	mv	a1,s2
    80005532:	854e                	mv	a0,s3
    80005534:	ffffc097          	auipc	ra,0xffffc
    80005538:	006080e7          	jalr	6(ra) # 8000153a <sleep>
  while(b->disk == 1) {
    8000553c:	0049a783          	lw	a5,4(s3)
    80005540:	fe9788e3          	beq	a5,s1,80005530 <virtio_disk_rw+0x182>
  }

  disk.info[idx[0]].b = 0;
    80005544:	fa042903          	lw	s2,-96(s0)
    80005548:	20090713          	addi	a4,s2,512
    8000554c:	0712                	slli	a4,a4,0x4
    8000554e:	00016797          	auipc	a5,0x16
    80005552:	ab278793          	addi	a5,a5,-1358 # 8001b000 <disk>
    80005556:	97ba                	add	a5,a5,a4
    80005558:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    8000555c:	00018997          	auipc	s3,0x18
    80005560:	aa498993          	addi	s3,s3,-1372 # 8001d000 <disk+0x2000>
    80005564:	00491713          	slli	a4,s2,0x4
    80005568:	0009b783          	ld	a5,0(s3)
    8000556c:	97ba                	add	a5,a5,a4
    8000556e:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005572:	854a                	mv	a0,s2
    80005574:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005578:	00000097          	auipc	ra,0x0
    8000557c:	c52080e7          	jalr	-942(ra) # 800051ca <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005580:	8885                	andi	s1,s1,1
    80005582:	f0ed                	bnez	s1,80005564 <virtio_disk_rw+0x1b6>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005584:	00018517          	auipc	a0,0x18
    80005588:	ba450513          	addi	a0,a0,-1116 # 8001d128 <disk+0x2128>
    8000558c:	00001097          	auipc	ra,0x1
    80005590:	ce6080e7          	jalr	-794(ra) # 80006272 <release>
}
    80005594:	60e6                	ld	ra,88(sp)
    80005596:	6446                	ld	s0,80(sp)
    80005598:	64a6                	ld	s1,72(sp)
    8000559a:	6906                	ld	s2,64(sp)
    8000559c:	79e2                	ld	s3,56(sp)
    8000559e:	7a42                	ld	s4,48(sp)
    800055a0:	7aa2                	ld	s5,40(sp)
    800055a2:	7b02                	ld	s6,32(sp)
    800055a4:	6be2                	ld	s7,24(sp)
    800055a6:	6c42                	ld	s8,16(sp)
    800055a8:	6125                	addi	sp,sp,96
    800055aa:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800055ac:	fa042503          	lw	a0,-96(s0)
    800055b0:	00451613          	slli	a2,a0,0x4
  if(write)
    800055b4:	00016597          	auipc	a1,0x16
    800055b8:	a4c58593          	addi	a1,a1,-1460 # 8001b000 <disk>
    800055bc:	20050793          	addi	a5,a0,512
    800055c0:	0792                	slli	a5,a5,0x4
    800055c2:	97ae                	add	a5,a5,a1
    800055c4:	01803733          	snez	a4,s8
    800055c8:	0ae7a423          	sw	a4,168(a5)
  buf0->reserved = 0;
    800055cc:	0a07a623          	sw	zero,172(a5)
  buf0->sector = sector;
    800055d0:	0b77b823          	sd	s7,176(a5)
  disk.desc[idx[0]].addr = (uint64) buf0;
    800055d4:	00018717          	auipc	a4,0x18
    800055d8:	a2c70713          	addi	a4,a4,-1492 # 8001d000 <disk+0x2000>
    800055dc:	6314                	ld	a3,0(a4)
    800055de:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800055e0:	6789                	lui	a5,0x2
    800055e2:	0a878793          	addi	a5,a5,168 # 20a8 <_entry-0x7fffdf58>
    800055e6:	97b2                	add	a5,a5,a2
    800055e8:	97ae                	add	a5,a5,a1
  disk.desc[idx[0]].addr = (uint64) buf0;
    800055ea:	e29c                	sd	a5,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800055ec:	631c                	ld	a5,0(a4)
    800055ee:	97b2                	add	a5,a5,a2
    800055f0:	46c1                	li	a3,16
    800055f2:	c794                	sw	a3,8(a5)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800055f4:	631c                	ld	a5,0(a4)
    800055f6:	97b2                	add	a5,a5,a2
    800055f8:	4685                	li	a3,1
    800055fa:	00d79623          	sh	a3,12(a5)
  disk.desc[idx[0]].next = idx[1];
    800055fe:	fa442783          	lw	a5,-92(s0)
    80005602:	6314                	ld	a3,0(a4)
    80005604:	96b2                	add	a3,a3,a2
    80005606:	00f69723          	sh	a5,14(a3)
  disk.desc[idx[1]].addr = (uint64) b->data;
    8000560a:	0792                	slli	a5,a5,0x4
    8000560c:	6314                	ld	a3,0(a4)
    8000560e:	96be                	add	a3,a3,a5
    80005610:	05898593          	addi	a1,s3,88
    80005614:	e28c                	sd	a1,0(a3)
  disk.desc[idx[1]].len = BSIZE;
    80005616:	6318                	ld	a4,0(a4)
    80005618:	973e                	add	a4,a4,a5
    8000561a:	40000693          	li	a3,1024
    8000561e:	c714                	sw	a3,8(a4)
  if(write)
    80005620:	e40c18e3          	bnez	s8,80005470 <virtio_disk_rw+0xc2>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80005624:	00018717          	auipc	a4,0x18
    80005628:	9dc73703          	ld	a4,-1572(a4) # 8001d000 <disk+0x2000>
    8000562c:	973e                	add	a4,a4,a5
    8000562e:	4689                	li	a3,2
    80005630:	00d71623          	sh	a3,12(a4)
    80005634:	b5a9                	j	8000547e <virtio_disk_rw+0xd0>

0000000080005636 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005636:	1101                	addi	sp,sp,-32
    80005638:	ec06                	sd	ra,24(sp)
    8000563a:	e822                	sd	s0,16(sp)
    8000563c:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000563e:	00018517          	auipc	a0,0x18
    80005642:	aea50513          	addi	a0,a0,-1302 # 8001d128 <disk+0x2128>
    80005646:	00001097          	auipc	ra,0x1
    8000564a:	b7c080e7          	jalr	-1156(ra) # 800061c2 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    8000564e:	100017b7          	lui	a5,0x10001
    80005652:	53bc                	lw	a5,96(a5)
    80005654:	8b8d                	andi	a5,a5,3
    80005656:	10001737          	lui	a4,0x10001
    8000565a:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    8000565c:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005660:	00018797          	auipc	a5,0x18
    80005664:	9a078793          	addi	a5,a5,-1632 # 8001d000 <disk+0x2000>
    80005668:	6b94                	ld	a3,16(a5)
    8000566a:	0207d703          	lhu	a4,32(a5)
    8000566e:	0026d783          	lhu	a5,2(a3)
    80005672:	06f70563          	beq	a4,a5,800056dc <virtio_disk_intr+0xa6>
    80005676:	e426                	sd	s1,8(sp)
    80005678:	e04a                	sd	s2,0(sp)
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000567a:	00016917          	auipc	s2,0x16
    8000567e:	98690913          	addi	s2,s2,-1658 # 8001b000 <disk>
    80005682:	00018497          	auipc	s1,0x18
    80005686:	97e48493          	addi	s1,s1,-1666 # 8001d000 <disk+0x2000>
    __sync_synchronize();
    8000568a:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000568e:	6898                	ld	a4,16(s1)
    80005690:	0204d783          	lhu	a5,32(s1)
    80005694:	8b9d                	andi	a5,a5,7
    80005696:	078e                	slli	a5,a5,0x3
    80005698:	97ba                	add	a5,a5,a4
    8000569a:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    8000569c:	20078713          	addi	a4,a5,512
    800056a0:	0712                	slli	a4,a4,0x4
    800056a2:	974a                	add	a4,a4,s2
    800056a4:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    800056a8:	e731                	bnez	a4,800056f4 <virtio_disk_intr+0xbe>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800056aa:	20078793          	addi	a5,a5,512
    800056ae:	0792                	slli	a5,a5,0x4
    800056b0:	97ca                	add	a5,a5,s2
    800056b2:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    800056b4:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800056b8:	ffffc097          	auipc	ra,0xffffc
    800056bc:	008080e7          	jalr	8(ra) # 800016c0 <wakeup>

    disk.used_idx += 1;
    800056c0:	0204d783          	lhu	a5,32(s1)
    800056c4:	2785                	addiw	a5,a5,1
    800056c6:	17c2                	slli	a5,a5,0x30
    800056c8:	93c1                	srli	a5,a5,0x30
    800056ca:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800056ce:	6898                	ld	a4,16(s1)
    800056d0:	00275703          	lhu	a4,2(a4)
    800056d4:	faf71be3          	bne	a4,a5,8000568a <virtio_disk_intr+0x54>
    800056d8:	64a2                	ld	s1,8(sp)
    800056da:	6902                	ld	s2,0(sp)
  }

  release(&disk.vdisk_lock);
    800056dc:	00018517          	auipc	a0,0x18
    800056e0:	a4c50513          	addi	a0,a0,-1460 # 8001d128 <disk+0x2128>
    800056e4:	00001097          	auipc	ra,0x1
    800056e8:	b8e080e7          	jalr	-1138(ra) # 80006272 <release>
}
    800056ec:	60e2                	ld	ra,24(sp)
    800056ee:	6442                	ld	s0,16(sp)
    800056f0:	6105                	addi	sp,sp,32
    800056f2:	8082                	ret
      panic("virtio_disk_intr status");
    800056f4:	00003517          	auipc	a0,0x3
    800056f8:	f8c50513          	addi	a0,a0,-116 # 80008680 <etext+0x680>
    800056fc:	00000097          	auipc	ra,0x0
    80005700:	546080e7          	jalr	1350(ra) # 80005c42 <panic>

0000000080005704 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005704:	1141                	addi	sp,sp,-16
    80005706:	e406                	sd	ra,8(sp)
    80005708:	e022                	sd	s0,0(sp)
    8000570a:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000570c:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005710:	2781                	sext.w	a5,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005712:	0037961b          	slliw	a2,a5,0x3
    80005716:	02004737          	lui	a4,0x2004
    8000571a:	963a                	add	a2,a2,a4
    8000571c:	0200c737          	lui	a4,0x200c
    80005720:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005724:	000f46b7          	lui	a3,0xf4
    80005728:	24068693          	addi	a3,a3,576 # f4240 <_entry-0x7ff0bdc0>
    8000572c:	9736                	add	a4,a4,a3
    8000572e:	e218                	sd	a4,0(a2)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005730:	00279713          	slli	a4,a5,0x2
    80005734:	973e                	add	a4,a4,a5
    80005736:	070e                	slli	a4,a4,0x3
    80005738:	00019797          	auipc	a5,0x19
    8000573c:	8c878793          	addi	a5,a5,-1848 # 8001e000 <timer_scratch>
    80005740:	97ba                	add	a5,a5,a4
  scratch[3] = CLINT_MTIMECMP(id);
    80005742:	ef90                	sd	a2,24(a5)
  scratch[4] = interval;
    80005744:	f394                	sd	a3,32(a5)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005746:	34079073          	csrw	mscratch,a5
  asm volatile("csrw mtvec, %0" : : "r" (x));
    8000574a:	00000797          	auipc	a5,0x0
    8000574e:	9b678793          	addi	a5,a5,-1610 # 80005100 <timervec>
    80005752:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005756:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    8000575a:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    8000575e:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005762:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005766:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    8000576a:	30479073          	csrw	mie,a5
}
    8000576e:	60a2                	ld	ra,8(sp)
    80005770:	6402                	ld	s0,0(sp)
    80005772:	0141                	addi	sp,sp,16
    80005774:	8082                	ret

0000000080005776 <start>:
{
    80005776:	1141                	addi	sp,sp,-16
    80005778:	e406                	sd	ra,8(sp)
    8000577a:	e022                	sd	s0,0(sp)
    8000577c:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000577e:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005782:	7779                	lui	a4,0xffffe
    80005784:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd85bf>
    80005788:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000578a:	6705                	lui	a4,0x1
    8000578c:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005790:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005792:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005796:	ffffb797          	auipc	a5,0xffffb
    8000579a:	b9e78793          	addi	a5,a5,-1122 # 80000334 <main>
    8000579e:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800057a2:	4781                	li	a5,0
    800057a4:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800057a8:	67c1                	lui	a5,0x10
    800057aa:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    800057ac:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800057b0:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800057b4:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800057b8:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800057bc:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800057c0:	57fd                	li	a5,-1
    800057c2:	83a9                	srli	a5,a5,0xa
    800057c4:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800057c8:	47bd                	li	a5,15
    800057ca:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800057ce:	00000097          	auipc	ra,0x0
    800057d2:	f36080e7          	jalr	-202(ra) # 80005704 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800057d6:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800057da:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    800057dc:	823e                	mv	tp,a5
  asm volatile("mret");
    800057de:	30200073          	mret
}
    800057e2:	60a2                	ld	ra,8(sp)
    800057e4:	6402                	ld	s0,0(sp)
    800057e6:	0141                	addi	sp,sp,16
    800057e8:	8082                	ret

00000000800057ea <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800057ea:	711d                	addi	sp,sp,-96
    800057ec:	ec86                	sd	ra,88(sp)
    800057ee:	e8a2                	sd	s0,80(sp)
    800057f0:	e0ca                	sd	s2,64(sp)
    800057f2:	1080                	addi	s0,sp,96
  int i;

  for(i = 0; i < n; i++){
    800057f4:	04c05c63          	blez	a2,8000584c <consolewrite+0x62>
    800057f8:	e4a6                	sd	s1,72(sp)
    800057fa:	fc4e                	sd	s3,56(sp)
    800057fc:	f852                	sd	s4,48(sp)
    800057fe:	f456                	sd	s5,40(sp)
    80005800:	f05a                	sd	s6,32(sp)
    80005802:	ec5e                	sd	s7,24(sp)
    80005804:	8a2a                	mv	s4,a0
    80005806:	84ae                	mv	s1,a1
    80005808:	89b2                	mv	s3,a2
    8000580a:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000580c:	faf40b93          	addi	s7,s0,-81
    80005810:	4b05                	li	s6,1
    80005812:	5afd                	li	s5,-1
    80005814:	86da                	mv	a3,s6
    80005816:	8626                	mv	a2,s1
    80005818:	85d2                	mv	a1,s4
    8000581a:	855e                	mv	a0,s7
    8000581c:	ffffc097          	auipc	ra,0xffffc
    80005820:	112080e7          	jalr	274(ra) # 8000192e <either_copyin>
    80005824:	03550663          	beq	a0,s5,80005850 <consolewrite+0x66>
      break;
    uartputc(c);
    80005828:	faf44503          	lbu	a0,-81(s0)
    8000582c:	00000097          	auipc	ra,0x0
    80005830:	7d4080e7          	jalr	2004(ra) # 80006000 <uartputc>
  for(i = 0; i < n; i++){
    80005834:	2905                	addiw	s2,s2,1
    80005836:	0485                	addi	s1,s1,1
    80005838:	fd299ee3          	bne	s3,s2,80005814 <consolewrite+0x2a>
    8000583c:	894e                	mv	s2,s3
    8000583e:	64a6                	ld	s1,72(sp)
    80005840:	79e2                	ld	s3,56(sp)
    80005842:	7a42                	ld	s4,48(sp)
    80005844:	7aa2                	ld	s5,40(sp)
    80005846:	7b02                	ld	s6,32(sp)
    80005848:	6be2                	ld	s7,24(sp)
    8000584a:	a809                	j	8000585c <consolewrite+0x72>
    8000584c:	4901                	li	s2,0
    8000584e:	a039                	j	8000585c <consolewrite+0x72>
    80005850:	64a6                	ld	s1,72(sp)
    80005852:	79e2                	ld	s3,56(sp)
    80005854:	7a42                	ld	s4,48(sp)
    80005856:	7aa2                	ld	s5,40(sp)
    80005858:	7b02                	ld	s6,32(sp)
    8000585a:	6be2                	ld	s7,24(sp)
  }

  return i;
}
    8000585c:	854a                	mv	a0,s2
    8000585e:	60e6                	ld	ra,88(sp)
    80005860:	6446                	ld	s0,80(sp)
    80005862:	6906                	ld	s2,64(sp)
    80005864:	6125                	addi	sp,sp,96
    80005866:	8082                	ret

0000000080005868 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005868:	711d                	addi	sp,sp,-96
    8000586a:	ec86                	sd	ra,88(sp)
    8000586c:	e8a2                	sd	s0,80(sp)
    8000586e:	e4a6                	sd	s1,72(sp)
    80005870:	e0ca                	sd	s2,64(sp)
    80005872:	fc4e                	sd	s3,56(sp)
    80005874:	f852                	sd	s4,48(sp)
    80005876:	f456                	sd	s5,40(sp)
    80005878:	f05a                	sd	s6,32(sp)
    8000587a:	1080                	addi	s0,sp,96
    8000587c:	8aaa                	mv	s5,a0
    8000587e:	8a2e                	mv	s4,a1
    80005880:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005882:	8b32                	mv	s6,a2
  acquire(&cons.lock);
    80005884:	00021517          	auipc	a0,0x21
    80005888:	8bc50513          	addi	a0,a0,-1860 # 80026140 <cons>
    8000588c:	00001097          	auipc	ra,0x1
    80005890:	936080e7          	jalr	-1738(ra) # 800061c2 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005894:	00021497          	auipc	s1,0x21
    80005898:	8ac48493          	addi	s1,s1,-1876 # 80026140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    8000589c:	00021917          	auipc	s2,0x21
    800058a0:	93c90913          	addi	s2,s2,-1732 # 800261d8 <cons+0x98>
  while(n > 0){
    800058a4:	0d305263          	blez	s3,80005968 <consoleread+0x100>
    while(cons.r == cons.w){
    800058a8:	0984a783          	lw	a5,152(s1)
    800058ac:	09c4a703          	lw	a4,156(s1)
    800058b0:	0af71763          	bne	a4,a5,8000595e <consoleread+0xf6>
      if(myproc()->killed){
    800058b4:	ffffb097          	auipc	ra,0xffffb
    800058b8:	5c0080e7          	jalr	1472(ra) # 80000e74 <myproc>
    800058bc:	551c                	lw	a5,40(a0)
    800058be:	e7ad                	bnez	a5,80005928 <consoleread+0xc0>
      sleep(&cons.r, &cons.lock);
    800058c0:	85a6                	mv	a1,s1
    800058c2:	854a                	mv	a0,s2
    800058c4:	ffffc097          	auipc	ra,0xffffc
    800058c8:	c76080e7          	jalr	-906(ra) # 8000153a <sleep>
    while(cons.r == cons.w){
    800058cc:	0984a783          	lw	a5,152(s1)
    800058d0:	09c4a703          	lw	a4,156(s1)
    800058d4:	fef700e3          	beq	a4,a5,800058b4 <consoleread+0x4c>
    800058d8:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF];
    800058da:	00021717          	auipc	a4,0x21
    800058de:	86670713          	addi	a4,a4,-1946 # 80026140 <cons>
    800058e2:	0017869b          	addiw	a3,a5,1
    800058e6:	08d72c23          	sw	a3,152(a4)
    800058ea:	07f7f693          	andi	a3,a5,127
    800058ee:	9736                	add	a4,a4,a3
    800058f0:	01874703          	lbu	a4,24(a4)
    800058f4:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    800058f8:	4691                	li	a3,4
    800058fa:	04db8a63          	beq	s7,a3,8000594e <consoleread+0xe6>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    800058fe:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005902:	4685                	li	a3,1
    80005904:	faf40613          	addi	a2,s0,-81
    80005908:	85d2                	mv	a1,s4
    8000590a:	8556                	mv	a0,s5
    8000590c:	ffffc097          	auipc	ra,0xffffc
    80005910:	fcc080e7          	jalr	-52(ra) # 800018d8 <either_copyout>
    80005914:	57fd                	li	a5,-1
    80005916:	04f50863          	beq	a0,a5,80005966 <consoleread+0xfe>
      break;

    dst++;
    8000591a:	0a05                	addi	s4,s4,1
    --n;
    8000591c:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    8000591e:	47a9                	li	a5,10
    80005920:	04fb8f63          	beq	s7,a5,8000597e <consoleread+0x116>
    80005924:	6be2                	ld	s7,24(sp)
    80005926:	bfbd                	j	800058a4 <consoleread+0x3c>
        release(&cons.lock);
    80005928:	00021517          	auipc	a0,0x21
    8000592c:	81850513          	addi	a0,a0,-2024 # 80026140 <cons>
    80005930:	00001097          	auipc	ra,0x1
    80005934:	942080e7          	jalr	-1726(ra) # 80006272 <release>
        return -1;
    80005938:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    8000593a:	60e6                	ld	ra,88(sp)
    8000593c:	6446                	ld	s0,80(sp)
    8000593e:	64a6                	ld	s1,72(sp)
    80005940:	6906                	ld	s2,64(sp)
    80005942:	79e2                	ld	s3,56(sp)
    80005944:	7a42                	ld	s4,48(sp)
    80005946:	7aa2                	ld	s5,40(sp)
    80005948:	7b02                	ld	s6,32(sp)
    8000594a:	6125                	addi	sp,sp,96
    8000594c:	8082                	ret
      if(n < target){
    8000594e:	0169fa63          	bgeu	s3,s6,80005962 <consoleread+0xfa>
        cons.r--;
    80005952:	00021717          	auipc	a4,0x21
    80005956:	88f72323          	sw	a5,-1914(a4) # 800261d8 <cons+0x98>
    8000595a:	6be2                	ld	s7,24(sp)
    8000595c:	a031                	j	80005968 <consoleread+0x100>
    8000595e:	ec5e                	sd	s7,24(sp)
    80005960:	bfad                	j	800058da <consoleread+0x72>
    80005962:	6be2                	ld	s7,24(sp)
    80005964:	a011                	j	80005968 <consoleread+0x100>
    80005966:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80005968:	00020517          	auipc	a0,0x20
    8000596c:	7d850513          	addi	a0,a0,2008 # 80026140 <cons>
    80005970:	00001097          	auipc	ra,0x1
    80005974:	902080e7          	jalr	-1790(ra) # 80006272 <release>
  return target - n;
    80005978:	413b053b          	subw	a0,s6,s3
    8000597c:	bf7d                	j	8000593a <consoleread+0xd2>
    8000597e:	6be2                	ld	s7,24(sp)
    80005980:	b7e5                	j	80005968 <consoleread+0x100>

0000000080005982 <consputc>:
{
    80005982:	1141                	addi	sp,sp,-16
    80005984:	e406                	sd	ra,8(sp)
    80005986:	e022                	sd	s0,0(sp)
    80005988:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    8000598a:	10000793          	li	a5,256
    8000598e:	00f50a63          	beq	a0,a5,800059a2 <consputc+0x20>
    uartputc_sync(c);
    80005992:	00000097          	auipc	ra,0x0
    80005996:	590080e7          	jalr	1424(ra) # 80005f22 <uartputc_sync>
}
    8000599a:	60a2                	ld	ra,8(sp)
    8000599c:	6402                	ld	s0,0(sp)
    8000599e:	0141                	addi	sp,sp,16
    800059a0:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800059a2:	4521                	li	a0,8
    800059a4:	00000097          	auipc	ra,0x0
    800059a8:	57e080e7          	jalr	1406(ra) # 80005f22 <uartputc_sync>
    800059ac:	02000513          	li	a0,32
    800059b0:	00000097          	auipc	ra,0x0
    800059b4:	572080e7          	jalr	1394(ra) # 80005f22 <uartputc_sync>
    800059b8:	4521                	li	a0,8
    800059ba:	00000097          	auipc	ra,0x0
    800059be:	568080e7          	jalr	1384(ra) # 80005f22 <uartputc_sync>
    800059c2:	bfe1                	j	8000599a <consputc+0x18>

00000000800059c4 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800059c4:	7179                	addi	sp,sp,-48
    800059c6:	f406                	sd	ra,40(sp)
    800059c8:	f022                	sd	s0,32(sp)
    800059ca:	ec26                	sd	s1,24(sp)
    800059cc:	1800                	addi	s0,sp,48
    800059ce:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800059d0:	00020517          	auipc	a0,0x20
    800059d4:	77050513          	addi	a0,a0,1904 # 80026140 <cons>
    800059d8:	00000097          	auipc	ra,0x0
    800059dc:	7ea080e7          	jalr	2026(ra) # 800061c2 <acquire>

  switch(c){
    800059e0:	47d5                	li	a5,21
    800059e2:	0af48463          	beq	s1,a5,80005a8a <consoleintr+0xc6>
    800059e6:	0297c963          	blt	a5,s1,80005a18 <consoleintr+0x54>
    800059ea:	47a1                	li	a5,8
    800059ec:	10f48063          	beq	s1,a5,80005aec <consoleintr+0x128>
    800059f0:	47c1                	li	a5,16
    800059f2:	12f49363          	bne	s1,a5,80005b18 <consoleintr+0x154>
  case C('P'):  // Print process list.
    procdump();
    800059f6:	ffffc097          	auipc	ra,0xffffc
    800059fa:	f8e080e7          	jalr	-114(ra) # 80001984 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800059fe:	00020517          	auipc	a0,0x20
    80005a02:	74250513          	addi	a0,a0,1858 # 80026140 <cons>
    80005a06:	00001097          	auipc	ra,0x1
    80005a0a:	86c080e7          	jalr	-1940(ra) # 80006272 <release>
}
    80005a0e:	70a2                	ld	ra,40(sp)
    80005a10:	7402                	ld	s0,32(sp)
    80005a12:	64e2                	ld	s1,24(sp)
    80005a14:	6145                	addi	sp,sp,48
    80005a16:	8082                	ret
  switch(c){
    80005a18:	07f00793          	li	a5,127
    80005a1c:	0cf48863          	beq	s1,a5,80005aec <consoleintr+0x128>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005a20:	00020717          	auipc	a4,0x20
    80005a24:	72070713          	addi	a4,a4,1824 # 80026140 <cons>
    80005a28:	0a072783          	lw	a5,160(a4)
    80005a2c:	09872703          	lw	a4,152(a4)
    80005a30:	9f99                	subw	a5,a5,a4
    80005a32:	07f00713          	li	a4,127
    80005a36:	fcf764e3          	bltu	a4,a5,800059fe <consoleintr+0x3a>
      c = (c == '\r') ? '\n' : c;
    80005a3a:	47b5                	li	a5,13
    80005a3c:	0ef48163          	beq	s1,a5,80005b1e <consoleintr+0x15a>
      consputc(c);
    80005a40:	8526                	mv	a0,s1
    80005a42:	00000097          	auipc	ra,0x0
    80005a46:	f40080e7          	jalr	-192(ra) # 80005982 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005a4a:	00020797          	auipc	a5,0x20
    80005a4e:	6f678793          	addi	a5,a5,1782 # 80026140 <cons>
    80005a52:	0a07a703          	lw	a4,160(a5)
    80005a56:	0017069b          	addiw	a3,a4,1
    80005a5a:	8636                	mv	a2,a3
    80005a5c:	0ad7a023          	sw	a3,160(a5)
    80005a60:	07f77713          	andi	a4,a4,127
    80005a64:	97ba                	add	a5,a5,a4
    80005a66:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005a6a:	47a9                	li	a5,10
    80005a6c:	0cf48f63          	beq	s1,a5,80005b4a <consoleintr+0x186>
    80005a70:	4791                	li	a5,4
    80005a72:	0cf48c63          	beq	s1,a5,80005b4a <consoleintr+0x186>
    80005a76:	00020797          	auipc	a5,0x20
    80005a7a:	7627a783          	lw	a5,1890(a5) # 800261d8 <cons+0x98>
    80005a7e:	0807879b          	addiw	a5,a5,128
    80005a82:	f6f69ee3          	bne	a3,a5,800059fe <consoleintr+0x3a>
    80005a86:	863e                	mv	a2,a5
    80005a88:	a0c9                	j	80005b4a <consoleintr+0x186>
    80005a8a:	e84a                	sd	s2,16(sp)
    80005a8c:	e44e                	sd	s3,8(sp)
    while(cons.e != cons.w &&
    80005a8e:	00020717          	auipc	a4,0x20
    80005a92:	6b270713          	addi	a4,a4,1714 # 80026140 <cons>
    80005a96:	0a072783          	lw	a5,160(a4)
    80005a9a:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005a9e:	00020497          	auipc	s1,0x20
    80005aa2:	6a248493          	addi	s1,s1,1698 # 80026140 <cons>
    while(cons.e != cons.w &&
    80005aa6:	4929                	li	s2,10
      consputc(BACKSPACE);
    80005aa8:	10000993          	li	s3,256
    while(cons.e != cons.w &&
    80005aac:	02f70a63          	beq	a4,a5,80005ae0 <consoleintr+0x11c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005ab0:	37fd                	addiw	a5,a5,-1
    80005ab2:	07f7f713          	andi	a4,a5,127
    80005ab6:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005ab8:	01874703          	lbu	a4,24(a4)
    80005abc:	03270563          	beq	a4,s2,80005ae6 <consoleintr+0x122>
      cons.e--;
    80005ac0:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005ac4:	854e                	mv	a0,s3
    80005ac6:	00000097          	auipc	ra,0x0
    80005aca:	ebc080e7          	jalr	-324(ra) # 80005982 <consputc>
    while(cons.e != cons.w &&
    80005ace:	0a04a783          	lw	a5,160(s1)
    80005ad2:	09c4a703          	lw	a4,156(s1)
    80005ad6:	fcf71de3          	bne	a4,a5,80005ab0 <consoleintr+0xec>
    80005ada:	6942                	ld	s2,16(sp)
    80005adc:	69a2                	ld	s3,8(sp)
    80005ade:	b705                	j	800059fe <consoleintr+0x3a>
    80005ae0:	6942                	ld	s2,16(sp)
    80005ae2:	69a2                	ld	s3,8(sp)
    80005ae4:	bf29                	j	800059fe <consoleintr+0x3a>
    80005ae6:	6942                	ld	s2,16(sp)
    80005ae8:	69a2                	ld	s3,8(sp)
    80005aea:	bf11                	j	800059fe <consoleintr+0x3a>
    if(cons.e != cons.w){
    80005aec:	00020717          	auipc	a4,0x20
    80005af0:	65470713          	addi	a4,a4,1620 # 80026140 <cons>
    80005af4:	0a072783          	lw	a5,160(a4)
    80005af8:	09c72703          	lw	a4,156(a4)
    80005afc:	f0f701e3          	beq	a4,a5,800059fe <consoleintr+0x3a>
      cons.e--;
    80005b00:	37fd                	addiw	a5,a5,-1
    80005b02:	00020717          	auipc	a4,0x20
    80005b06:	6cf72f23          	sw	a5,1758(a4) # 800261e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005b0a:	10000513          	li	a0,256
    80005b0e:	00000097          	auipc	ra,0x0
    80005b12:	e74080e7          	jalr	-396(ra) # 80005982 <consputc>
    80005b16:	b5e5                	j	800059fe <consoleintr+0x3a>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005b18:	ee0483e3          	beqz	s1,800059fe <consoleintr+0x3a>
    80005b1c:	b711                	j	80005a20 <consoleintr+0x5c>
      consputc(c);
    80005b1e:	4529                	li	a0,10
    80005b20:	00000097          	auipc	ra,0x0
    80005b24:	e62080e7          	jalr	-414(ra) # 80005982 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005b28:	00020797          	auipc	a5,0x20
    80005b2c:	61878793          	addi	a5,a5,1560 # 80026140 <cons>
    80005b30:	0a07a703          	lw	a4,160(a5)
    80005b34:	0017069b          	addiw	a3,a4,1
    80005b38:	8636                	mv	a2,a3
    80005b3a:	0ad7a023          	sw	a3,160(a5)
    80005b3e:	07f77713          	andi	a4,a4,127
    80005b42:	97ba                	add	a5,a5,a4
    80005b44:	4729                	li	a4,10
    80005b46:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005b4a:	00020797          	auipc	a5,0x20
    80005b4e:	68c7a923          	sw	a2,1682(a5) # 800261dc <cons+0x9c>
        wakeup(&cons.r);
    80005b52:	00020517          	auipc	a0,0x20
    80005b56:	68650513          	addi	a0,a0,1670 # 800261d8 <cons+0x98>
    80005b5a:	ffffc097          	auipc	ra,0xffffc
    80005b5e:	b66080e7          	jalr	-1178(ra) # 800016c0 <wakeup>
    80005b62:	bd71                	j	800059fe <consoleintr+0x3a>

0000000080005b64 <consoleinit>:

void
consoleinit(void)
{
    80005b64:	1141                	addi	sp,sp,-16
    80005b66:	e406                	sd	ra,8(sp)
    80005b68:	e022                	sd	s0,0(sp)
    80005b6a:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005b6c:	00003597          	auipc	a1,0x3
    80005b70:	b2c58593          	addi	a1,a1,-1236 # 80008698 <etext+0x698>
    80005b74:	00020517          	auipc	a0,0x20
    80005b78:	5cc50513          	addi	a0,a0,1484 # 80026140 <cons>
    80005b7c:	00000097          	auipc	ra,0x0
    80005b80:	5b2080e7          	jalr	1458(ra) # 8000612e <initlock>

  uartinit();
    80005b84:	00000097          	auipc	ra,0x0
    80005b88:	344080e7          	jalr	836(ra) # 80005ec8 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005b8c:	00013797          	auipc	a5,0x13
    80005b90:	53c78793          	addi	a5,a5,1340 # 800190c8 <devsw>
    80005b94:	00000717          	auipc	a4,0x0
    80005b98:	cd470713          	addi	a4,a4,-812 # 80005868 <consoleread>
    80005b9c:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005b9e:	00000717          	auipc	a4,0x0
    80005ba2:	c4c70713          	addi	a4,a4,-948 # 800057ea <consolewrite>
    80005ba6:	ef98                	sd	a4,24(a5)
}
    80005ba8:	60a2                	ld	ra,8(sp)
    80005baa:	6402                	ld	s0,0(sp)
    80005bac:	0141                	addi	sp,sp,16
    80005bae:	8082                	ret

0000000080005bb0 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005bb0:	7179                	addi	sp,sp,-48
    80005bb2:	f406                	sd	ra,40(sp)
    80005bb4:	f022                	sd	s0,32(sp)
    80005bb6:	ec26                	sd	s1,24(sp)
    80005bb8:	e84a                	sd	s2,16(sp)
    80005bba:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005bbc:	c219                	beqz	a2,80005bc2 <printint+0x12>
    80005bbe:	06054e63          	bltz	a0,80005c3a <printint+0x8a>
    x = -xx;
  else
    x = xx;
    80005bc2:	4e01                	li	t3,0

  i = 0;
    80005bc4:	fd040313          	addi	t1,s0,-48
    x = xx;
    80005bc8:	869a                	mv	a3,t1
  i = 0;
    80005bca:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    80005bcc:	00003817          	auipc	a6,0x3
    80005bd0:	c2c80813          	addi	a6,a6,-980 # 800087f8 <digits>
    80005bd4:	88be                	mv	a7,a5
    80005bd6:	0017861b          	addiw	a2,a5,1
    80005bda:	87b2                	mv	a5,a2
    80005bdc:	02b5773b          	remuw	a4,a0,a1
    80005be0:	1702                	slli	a4,a4,0x20
    80005be2:	9301                	srli	a4,a4,0x20
    80005be4:	9742                	add	a4,a4,a6
    80005be6:	00074703          	lbu	a4,0(a4)
    80005bea:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    80005bee:	872a                	mv	a4,a0
    80005bf0:	02b5553b          	divuw	a0,a0,a1
    80005bf4:	0685                	addi	a3,a3,1
    80005bf6:	fcb77fe3          	bgeu	a4,a1,80005bd4 <printint+0x24>

  if(sign)
    80005bfa:	000e0c63          	beqz	t3,80005c12 <printint+0x62>
    buf[i++] = '-';
    80005bfe:	fe060793          	addi	a5,a2,-32
    80005c02:	00878633          	add	a2,a5,s0
    80005c06:	02d00793          	li	a5,45
    80005c0a:	fef60823          	sb	a5,-16(a2)
    80005c0e:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
    80005c12:	fff7891b          	addiw	s2,a5,-1
    80005c16:	006784b3          	add	s1,a5,t1
    consputc(buf[i]);
    80005c1a:	fff4c503          	lbu	a0,-1(s1)
    80005c1e:	00000097          	auipc	ra,0x0
    80005c22:	d64080e7          	jalr	-668(ra) # 80005982 <consputc>
  while(--i >= 0)
    80005c26:	397d                	addiw	s2,s2,-1
    80005c28:	14fd                	addi	s1,s1,-1
    80005c2a:	fe0958e3          	bgez	s2,80005c1a <printint+0x6a>
}
    80005c2e:	70a2                	ld	ra,40(sp)
    80005c30:	7402                	ld	s0,32(sp)
    80005c32:	64e2                	ld	s1,24(sp)
    80005c34:	6942                	ld	s2,16(sp)
    80005c36:	6145                	addi	sp,sp,48
    80005c38:	8082                	ret
    x = -xx;
    80005c3a:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005c3e:	4e05                	li	t3,1
    x = -xx;
    80005c40:	b751                	j	80005bc4 <printint+0x14>

0000000080005c42 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005c42:	1101                	addi	sp,sp,-32
    80005c44:	ec06                	sd	ra,24(sp)
    80005c46:	e822                	sd	s0,16(sp)
    80005c48:	e426                	sd	s1,8(sp)
    80005c4a:	1000                	addi	s0,sp,32
    80005c4c:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005c4e:	00020797          	auipc	a5,0x20
    80005c52:	5a07a923          	sw	zero,1458(a5) # 80026200 <pr+0x18>
  printf("panic: ");
    80005c56:	00003517          	auipc	a0,0x3
    80005c5a:	a4a50513          	addi	a0,a0,-1462 # 800086a0 <etext+0x6a0>
    80005c5e:	00000097          	auipc	ra,0x0
    80005c62:	02e080e7          	jalr	46(ra) # 80005c8c <printf>
  printf(s);
    80005c66:	8526                	mv	a0,s1
    80005c68:	00000097          	auipc	ra,0x0
    80005c6c:	024080e7          	jalr	36(ra) # 80005c8c <printf>
  printf("\n");
    80005c70:	00002517          	auipc	a0,0x2
    80005c74:	3a850513          	addi	a0,a0,936 # 80008018 <etext+0x18>
    80005c78:	00000097          	auipc	ra,0x0
    80005c7c:	014080e7          	jalr	20(ra) # 80005c8c <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005c80:	4785                	li	a5,1
    80005c82:	00003717          	auipc	a4,0x3
    80005c86:	38f72d23          	sw	a5,922(a4) # 8000901c <panicked>
  for(;;)
    80005c8a:	a001                	j	80005c8a <panic+0x48>

0000000080005c8c <printf>:
{
    80005c8c:	7131                	addi	sp,sp,-192
    80005c8e:	fc86                	sd	ra,120(sp)
    80005c90:	f8a2                	sd	s0,112(sp)
    80005c92:	e8d2                	sd	s4,80(sp)
    80005c94:	ec6e                	sd	s11,24(sp)
    80005c96:	0100                	addi	s0,sp,128
    80005c98:	8a2a                	mv	s4,a0
    80005c9a:	e40c                	sd	a1,8(s0)
    80005c9c:	e810                	sd	a2,16(s0)
    80005c9e:	ec14                	sd	a3,24(s0)
    80005ca0:	f018                	sd	a4,32(s0)
    80005ca2:	f41c                	sd	a5,40(s0)
    80005ca4:	03043823          	sd	a6,48(s0)
    80005ca8:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005cac:	00020d97          	auipc	s11,0x20
    80005cb0:	554dad83          	lw	s11,1364(s11) # 80026200 <pr+0x18>
  if(locking)
    80005cb4:	040d9463          	bnez	s11,80005cfc <printf+0x70>
  if (fmt == 0)
    80005cb8:	040a0b63          	beqz	s4,80005d0e <printf+0x82>
  va_start(ap, fmt);
    80005cbc:	00840793          	addi	a5,s0,8
    80005cc0:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005cc4:	000a4503          	lbu	a0,0(s4)
    80005cc8:	18050c63          	beqz	a0,80005e60 <printf+0x1d4>
    80005ccc:	f4a6                	sd	s1,104(sp)
    80005cce:	f0ca                	sd	s2,96(sp)
    80005cd0:	ecce                	sd	s3,88(sp)
    80005cd2:	e4d6                	sd	s5,72(sp)
    80005cd4:	e0da                	sd	s6,64(sp)
    80005cd6:	fc5e                	sd	s7,56(sp)
    80005cd8:	f862                	sd	s8,48(sp)
    80005cda:	f466                	sd	s9,40(sp)
    80005cdc:	f06a                	sd	s10,32(sp)
    80005cde:	4981                	li	s3,0
    if(c != '%'){
    80005ce0:	02500b13          	li	s6,37
    switch(c){
    80005ce4:	07000b93          	li	s7,112
  consputc('x');
    80005ce8:	07800c93          	li	s9,120
    80005cec:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005cee:	00003a97          	auipc	s5,0x3
    80005cf2:	b0aa8a93          	addi	s5,s5,-1270 # 800087f8 <digits>
    switch(c){
    80005cf6:	07300c13          	li	s8,115
    80005cfa:	a0b9                	j	80005d48 <printf+0xbc>
    acquire(&pr.lock);
    80005cfc:	00020517          	auipc	a0,0x20
    80005d00:	4ec50513          	addi	a0,a0,1260 # 800261e8 <pr>
    80005d04:	00000097          	auipc	ra,0x0
    80005d08:	4be080e7          	jalr	1214(ra) # 800061c2 <acquire>
    80005d0c:	b775                	j	80005cb8 <printf+0x2c>
    80005d0e:	f4a6                	sd	s1,104(sp)
    80005d10:	f0ca                	sd	s2,96(sp)
    80005d12:	ecce                	sd	s3,88(sp)
    80005d14:	e4d6                	sd	s5,72(sp)
    80005d16:	e0da                	sd	s6,64(sp)
    80005d18:	fc5e                	sd	s7,56(sp)
    80005d1a:	f862                	sd	s8,48(sp)
    80005d1c:	f466                	sd	s9,40(sp)
    80005d1e:	f06a                	sd	s10,32(sp)
    panic("null fmt");
    80005d20:	00003517          	auipc	a0,0x3
    80005d24:	99050513          	addi	a0,a0,-1648 # 800086b0 <etext+0x6b0>
    80005d28:	00000097          	auipc	ra,0x0
    80005d2c:	f1a080e7          	jalr	-230(ra) # 80005c42 <panic>
      consputc(c);
    80005d30:	00000097          	auipc	ra,0x0
    80005d34:	c52080e7          	jalr	-942(ra) # 80005982 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005d38:	0019879b          	addiw	a5,s3,1
    80005d3c:	89be                	mv	s3,a5
    80005d3e:	97d2                	add	a5,a5,s4
    80005d40:	0007c503          	lbu	a0,0(a5)
    80005d44:	10050563          	beqz	a0,80005e4e <printf+0x1c2>
    if(c != '%'){
    80005d48:	ff6514e3          	bne	a0,s6,80005d30 <printf+0xa4>
    c = fmt[++i] & 0xff;
    80005d4c:	0019879b          	addiw	a5,s3,1
    80005d50:	89be                	mv	s3,a5
    80005d52:	97d2                	add	a5,a5,s4
    80005d54:	0007c783          	lbu	a5,0(a5)
    80005d58:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005d5c:	10078a63          	beqz	a5,80005e70 <printf+0x1e4>
    switch(c){
    80005d60:	05778a63          	beq	a5,s7,80005db4 <printf+0x128>
    80005d64:	02fbf463          	bgeu	s7,a5,80005d8c <printf+0x100>
    80005d68:	09878763          	beq	a5,s8,80005df6 <printf+0x16a>
    80005d6c:	0d979663          	bne	a5,s9,80005e38 <printf+0x1ac>
      printint(va_arg(ap, int), 16, 1);
    80005d70:	f8843783          	ld	a5,-120(s0)
    80005d74:	00878713          	addi	a4,a5,8
    80005d78:	f8e43423          	sd	a4,-120(s0)
    80005d7c:	4605                	li	a2,1
    80005d7e:	85ea                	mv	a1,s10
    80005d80:	4388                	lw	a0,0(a5)
    80005d82:	00000097          	auipc	ra,0x0
    80005d86:	e2e080e7          	jalr	-466(ra) # 80005bb0 <printint>
      break;
    80005d8a:	b77d                	j	80005d38 <printf+0xac>
    switch(c){
    80005d8c:	0b678063          	beq	a5,s6,80005e2c <printf+0x1a0>
    80005d90:	06400713          	li	a4,100
    80005d94:	0ae79263          	bne	a5,a4,80005e38 <printf+0x1ac>
      printint(va_arg(ap, int), 10, 1);
    80005d98:	f8843783          	ld	a5,-120(s0)
    80005d9c:	00878713          	addi	a4,a5,8
    80005da0:	f8e43423          	sd	a4,-120(s0)
    80005da4:	4605                	li	a2,1
    80005da6:	45a9                	li	a1,10
    80005da8:	4388                	lw	a0,0(a5)
    80005daa:	00000097          	auipc	ra,0x0
    80005dae:	e06080e7          	jalr	-506(ra) # 80005bb0 <printint>
      break;
    80005db2:	b759                	j	80005d38 <printf+0xac>
      printptr(va_arg(ap, uint64));
    80005db4:	f8843783          	ld	a5,-120(s0)
    80005db8:	00878713          	addi	a4,a5,8
    80005dbc:	f8e43423          	sd	a4,-120(s0)
    80005dc0:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005dc4:	03000513          	li	a0,48
    80005dc8:	00000097          	auipc	ra,0x0
    80005dcc:	bba080e7          	jalr	-1094(ra) # 80005982 <consputc>
  consputc('x');
    80005dd0:	8566                	mv	a0,s9
    80005dd2:	00000097          	auipc	ra,0x0
    80005dd6:	bb0080e7          	jalr	-1104(ra) # 80005982 <consputc>
    80005dda:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005ddc:	03c95793          	srli	a5,s2,0x3c
    80005de0:	97d6                	add	a5,a5,s5
    80005de2:	0007c503          	lbu	a0,0(a5)
    80005de6:	00000097          	auipc	ra,0x0
    80005dea:	b9c080e7          	jalr	-1124(ra) # 80005982 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005dee:	0912                	slli	s2,s2,0x4
    80005df0:	34fd                	addiw	s1,s1,-1
    80005df2:	f4ed                	bnez	s1,80005ddc <printf+0x150>
    80005df4:	b791                	j	80005d38 <printf+0xac>
      if((s = va_arg(ap, char*)) == 0)
    80005df6:	f8843783          	ld	a5,-120(s0)
    80005dfa:	00878713          	addi	a4,a5,8
    80005dfe:	f8e43423          	sd	a4,-120(s0)
    80005e02:	6384                	ld	s1,0(a5)
    80005e04:	cc89                	beqz	s1,80005e1e <printf+0x192>
      for(; *s; s++)
    80005e06:	0004c503          	lbu	a0,0(s1)
    80005e0a:	d51d                	beqz	a0,80005d38 <printf+0xac>
        consputc(*s);
    80005e0c:	00000097          	auipc	ra,0x0
    80005e10:	b76080e7          	jalr	-1162(ra) # 80005982 <consputc>
      for(; *s; s++)
    80005e14:	0485                	addi	s1,s1,1
    80005e16:	0004c503          	lbu	a0,0(s1)
    80005e1a:	f96d                	bnez	a0,80005e0c <printf+0x180>
    80005e1c:	bf31                	j	80005d38 <printf+0xac>
        s = "(null)";
    80005e1e:	00003497          	auipc	s1,0x3
    80005e22:	88a48493          	addi	s1,s1,-1910 # 800086a8 <etext+0x6a8>
      for(; *s; s++)
    80005e26:	02800513          	li	a0,40
    80005e2a:	b7cd                	j	80005e0c <printf+0x180>
      consputc('%');
    80005e2c:	855a                	mv	a0,s6
    80005e2e:	00000097          	auipc	ra,0x0
    80005e32:	b54080e7          	jalr	-1196(ra) # 80005982 <consputc>
      break;
    80005e36:	b709                	j	80005d38 <printf+0xac>
      consputc('%');
    80005e38:	855a                	mv	a0,s6
    80005e3a:	00000097          	auipc	ra,0x0
    80005e3e:	b48080e7          	jalr	-1208(ra) # 80005982 <consputc>
      consputc(c);
    80005e42:	8526                	mv	a0,s1
    80005e44:	00000097          	auipc	ra,0x0
    80005e48:	b3e080e7          	jalr	-1218(ra) # 80005982 <consputc>
      break;
    80005e4c:	b5f5                	j	80005d38 <printf+0xac>
    80005e4e:	74a6                	ld	s1,104(sp)
    80005e50:	7906                	ld	s2,96(sp)
    80005e52:	69e6                	ld	s3,88(sp)
    80005e54:	6aa6                	ld	s5,72(sp)
    80005e56:	6b06                	ld	s6,64(sp)
    80005e58:	7be2                	ld	s7,56(sp)
    80005e5a:	7c42                	ld	s8,48(sp)
    80005e5c:	7ca2                	ld	s9,40(sp)
    80005e5e:	7d02                	ld	s10,32(sp)
  if(locking)
    80005e60:	020d9263          	bnez	s11,80005e84 <printf+0x1f8>
}
    80005e64:	70e6                	ld	ra,120(sp)
    80005e66:	7446                	ld	s0,112(sp)
    80005e68:	6a46                	ld	s4,80(sp)
    80005e6a:	6de2                	ld	s11,24(sp)
    80005e6c:	6129                	addi	sp,sp,192
    80005e6e:	8082                	ret
    80005e70:	74a6                	ld	s1,104(sp)
    80005e72:	7906                	ld	s2,96(sp)
    80005e74:	69e6                	ld	s3,88(sp)
    80005e76:	6aa6                	ld	s5,72(sp)
    80005e78:	6b06                	ld	s6,64(sp)
    80005e7a:	7be2                	ld	s7,56(sp)
    80005e7c:	7c42                	ld	s8,48(sp)
    80005e7e:	7ca2                	ld	s9,40(sp)
    80005e80:	7d02                	ld	s10,32(sp)
    80005e82:	bff9                	j	80005e60 <printf+0x1d4>
    release(&pr.lock);
    80005e84:	00020517          	auipc	a0,0x20
    80005e88:	36450513          	addi	a0,a0,868 # 800261e8 <pr>
    80005e8c:	00000097          	auipc	ra,0x0
    80005e90:	3e6080e7          	jalr	998(ra) # 80006272 <release>
}
    80005e94:	bfc1                	j	80005e64 <printf+0x1d8>

0000000080005e96 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005e96:	1101                	addi	sp,sp,-32
    80005e98:	ec06                	sd	ra,24(sp)
    80005e9a:	e822                	sd	s0,16(sp)
    80005e9c:	e426                	sd	s1,8(sp)
    80005e9e:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005ea0:	00020497          	auipc	s1,0x20
    80005ea4:	34848493          	addi	s1,s1,840 # 800261e8 <pr>
    80005ea8:	00003597          	auipc	a1,0x3
    80005eac:	81858593          	addi	a1,a1,-2024 # 800086c0 <etext+0x6c0>
    80005eb0:	8526                	mv	a0,s1
    80005eb2:	00000097          	auipc	ra,0x0
    80005eb6:	27c080e7          	jalr	636(ra) # 8000612e <initlock>
  pr.locking = 1;
    80005eba:	4785                	li	a5,1
    80005ebc:	cc9c                	sw	a5,24(s1)
}
    80005ebe:	60e2                	ld	ra,24(sp)
    80005ec0:	6442                	ld	s0,16(sp)
    80005ec2:	64a2                	ld	s1,8(sp)
    80005ec4:	6105                	addi	sp,sp,32
    80005ec6:	8082                	ret

0000000080005ec8 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005ec8:	1141                	addi	sp,sp,-16
    80005eca:	e406                	sd	ra,8(sp)
    80005ecc:	e022                	sd	s0,0(sp)
    80005ece:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005ed0:	100007b7          	lui	a5,0x10000
    80005ed4:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005ed8:	10000737          	lui	a4,0x10000
    80005edc:	f8000693          	li	a3,-128
    80005ee0:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005ee4:	468d                	li	a3,3
    80005ee6:	10000637          	lui	a2,0x10000
    80005eea:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005eee:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005ef2:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005ef6:	8732                	mv	a4,a2
    80005ef8:	461d                	li	a2,7
    80005efa:	00c70123          	sb	a2,2(a4)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005efe:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005f02:	00002597          	auipc	a1,0x2
    80005f06:	7c658593          	addi	a1,a1,1990 # 800086c8 <etext+0x6c8>
    80005f0a:	00020517          	auipc	a0,0x20
    80005f0e:	2fe50513          	addi	a0,a0,766 # 80026208 <uart_tx_lock>
    80005f12:	00000097          	auipc	ra,0x0
    80005f16:	21c080e7          	jalr	540(ra) # 8000612e <initlock>
}
    80005f1a:	60a2                	ld	ra,8(sp)
    80005f1c:	6402                	ld	s0,0(sp)
    80005f1e:	0141                	addi	sp,sp,16
    80005f20:	8082                	ret

0000000080005f22 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005f22:	1101                	addi	sp,sp,-32
    80005f24:	ec06                	sd	ra,24(sp)
    80005f26:	e822                	sd	s0,16(sp)
    80005f28:	e426                	sd	s1,8(sp)
    80005f2a:	1000                	addi	s0,sp,32
    80005f2c:	84aa                	mv	s1,a0
  push_off();
    80005f2e:	00000097          	auipc	ra,0x0
    80005f32:	248080e7          	jalr	584(ra) # 80006176 <push_off>

  if(panicked){
    80005f36:	00003797          	auipc	a5,0x3
    80005f3a:	0e67a783          	lw	a5,230(a5) # 8000901c <panicked>
    80005f3e:	eb85                	bnez	a5,80005f6e <uartputc_sync+0x4c>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005f40:	10000737          	lui	a4,0x10000
    80005f44:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80005f46:	00074783          	lbu	a5,0(a4)
    80005f4a:	0207f793          	andi	a5,a5,32
    80005f4e:	dfe5                	beqz	a5,80005f46 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80005f50:	0ff4f513          	zext.b	a0,s1
    80005f54:	100007b7          	lui	a5,0x10000
    80005f58:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80005f5c:	00000097          	auipc	ra,0x0
    80005f60:	2ba080e7          	jalr	698(ra) # 80006216 <pop_off>
}
    80005f64:	60e2                	ld	ra,24(sp)
    80005f66:	6442                	ld	s0,16(sp)
    80005f68:	64a2                	ld	s1,8(sp)
    80005f6a:	6105                	addi	sp,sp,32
    80005f6c:	8082                	ret
    for(;;)
    80005f6e:	a001                	j	80005f6e <uartputc_sync+0x4c>

0000000080005f70 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005f70:	00003797          	auipc	a5,0x3
    80005f74:	0b07b783          	ld	a5,176(a5) # 80009020 <uart_tx_r>
    80005f78:	00003717          	auipc	a4,0x3
    80005f7c:	0b073703          	ld	a4,176(a4) # 80009028 <uart_tx_w>
    80005f80:	06f70f63          	beq	a4,a5,80005ffe <uartstart+0x8e>
{
    80005f84:	7139                	addi	sp,sp,-64
    80005f86:	fc06                	sd	ra,56(sp)
    80005f88:	f822                	sd	s0,48(sp)
    80005f8a:	f426                	sd	s1,40(sp)
    80005f8c:	f04a                	sd	s2,32(sp)
    80005f8e:	ec4e                	sd	s3,24(sp)
    80005f90:	e852                	sd	s4,16(sp)
    80005f92:	e456                	sd	s5,8(sp)
    80005f94:	e05a                	sd	s6,0(sp)
    80005f96:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005f98:	10000937          	lui	s2,0x10000
    80005f9c:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005f9e:	00020a97          	auipc	s5,0x20
    80005fa2:	26aa8a93          	addi	s5,s5,618 # 80026208 <uart_tx_lock>
    uart_tx_r += 1;
    80005fa6:	00003497          	auipc	s1,0x3
    80005faa:	07a48493          	addi	s1,s1,122 # 80009020 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    80005fae:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    80005fb2:	00003997          	auipc	s3,0x3
    80005fb6:	07698993          	addi	s3,s3,118 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005fba:	00094703          	lbu	a4,0(s2)
    80005fbe:	02077713          	andi	a4,a4,32
    80005fc2:	c705                	beqz	a4,80005fea <uartstart+0x7a>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005fc4:	01f7f713          	andi	a4,a5,31
    80005fc8:	9756                	add	a4,a4,s5
    80005fca:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    80005fce:	0785                	addi	a5,a5,1
    80005fd0:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    80005fd2:	8526                	mv	a0,s1
    80005fd4:	ffffb097          	auipc	ra,0xffffb
    80005fd8:	6ec080e7          	jalr	1772(ra) # 800016c0 <wakeup>
    WriteReg(THR, c);
    80005fdc:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    80005fe0:	609c                	ld	a5,0(s1)
    80005fe2:	0009b703          	ld	a4,0(s3)
    80005fe6:	fcf71ae3          	bne	a4,a5,80005fba <uartstart+0x4a>
  }
}
    80005fea:	70e2                	ld	ra,56(sp)
    80005fec:	7442                	ld	s0,48(sp)
    80005fee:	74a2                	ld	s1,40(sp)
    80005ff0:	7902                	ld	s2,32(sp)
    80005ff2:	69e2                	ld	s3,24(sp)
    80005ff4:	6a42                	ld	s4,16(sp)
    80005ff6:	6aa2                	ld	s5,8(sp)
    80005ff8:	6b02                	ld	s6,0(sp)
    80005ffa:	6121                	addi	sp,sp,64
    80005ffc:	8082                	ret
    80005ffe:	8082                	ret

0000000080006000 <uartputc>:
{
    80006000:	7179                	addi	sp,sp,-48
    80006002:	f406                	sd	ra,40(sp)
    80006004:	f022                	sd	s0,32(sp)
    80006006:	e052                	sd	s4,0(sp)
    80006008:	1800                	addi	s0,sp,48
    8000600a:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    8000600c:	00020517          	auipc	a0,0x20
    80006010:	1fc50513          	addi	a0,a0,508 # 80026208 <uart_tx_lock>
    80006014:	00000097          	auipc	ra,0x0
    80006018:	1ae080e7          	jalr	430(ra) # 800061c2 <acquire>
  if(panicked){
    8000601c:	00003797          	auipc	a5,0x3
    80006020:	0007a783          	lw	a5,0(a5) # 8000901c <panicked>
    80006024:	c391                	beqz	a5,80006028 <uartputc+0x28>
    for(;;)
    80006026:	a001                	j	80006026 <uartputc+0x26>
    80006028:	ec26                	sd	s1,24(sp)
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000602a:	00003717          	auipc	a4,0x3
    8000602e:	ffe73703          	ld	a4,-2(a4) # 80009028 <uart_tx_w>
    80006032:	00003797          	auipc	a5,0x3
    80006036:	fee7b783          	ld	a5,-18(a5) # 80009020 <uart_tx_r>
    8000603a:	02078793          	addi	a5,a5,32
    8000603e:	02e79f63          	bne	a5,a4,8000607c <uartputc+0x7c>
    80006042:	e84a                	sd	s2,16(sp)
    80006044:	e44e                	sd	s3,8(sp)
      sleep(&uart_tx_r, &uart_tx_lock);
    80006046:	00020997          	auipc	s3,0x20
    8000604a:	1c298993          	addi	s3,s3,450 # 80026208 <uart_tx_lock>
    8000604e:	00003497          	auipc	s1,0x3
    80006052:	fd248493          	addi	s1,s1,-46 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006056:	00003917          	auipc	s2,0x3
    8000605a:	fd290913          	addi	s2,s2,-46 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    8000605e:	85ce                	mv	a1,s3
    80006060:	8526                	mv	a0,s1
    80006062:	ffffb097          	auipc	ra,0xffffb
    80006066:	4d8080e7          	jalr	1240(ra) # 8000153a <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000606a:	00093703          	ld	a4,0(s2)
    8000606e:	609c                	ld	a5,0(s1)
    80006070:	02078793          	addi	a5,a5,32
    80006074:	fee785e3          	beq	a5,a4,8000605e <uartputc+0x5e>
    80006078:	6942                	ld	s2,16(sp)
    8000607a:	69a2                	ld	s3,8(sp)
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    8000607c:	00020497          	auipc	s1,0x20
    80006080:	18c48493          	addi	s1,s1,396 # 80026208 <uart_tx_lock>
    80006084:	01f77793          	andi	a5,a4,31
    80006088:	97a6                	add	a5,a5,s1
    8000608a:	01478c23          	sb	s4,24(a5)
      uart_tx_w += 1;
    8000608e:	0705                	addi	a4,a4,1
    80006090:	00003797          	auipc	a5,0x3
    80006094:	f8e7bc23          	sd	a4,-104(a5) # 80009028 <uart_tx_w>
      uartstart();
    80006098:	00000097          	auipc	ra,0x0
    8000609c:	ed8080e7          	jalr	-296(ra) # 80005f70 <uartstart>
      release(&uart_tx_lock);
    800060a0:	8526                	mv	a0,s1
    800060a2:	00000097          	auipc	ra,0x0
    800060a6:	1d0080e7          	jalr	464(ra) # 80006272 <release>
    800060aa:	64e2                	ld	s1,24(sp)
}
    800060ac:	70a2                	ld	ra,40(sp)
    800060ae:	7402                	ld	s0,32(sp)
    800060b0:	6a02                	ld	s4,0(sp)
    800060b2:	6145                	addi	sp,sp,48
    800060b4:	8082                	ret

00000000800060b6 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800060b6:	1141                	addi	sp,sp,-16
    800060b8:	e406                	sd	ra,8(sp)
    800060ba:	e022                	sd	s0,0(sp)
    800060bc:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800060be:	100007b7          	lui	a5,0x10000
    800060c2:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800060c6:	8b85                	andi	a5,a5,1
    800060c8:	cb89                	beqz	a5,800060da <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    800060ca:	100007b7          	lui	a5,0x10000
    800060ce:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800060d2:	60a2                	ld	ra,8(sp)
    800060d4:	6402                	ld	s0,0(sp)
    800060d6:	0141                	addi	sp,sp,16
    800060d8:	8082                	ret
    return -1;
    800060da:	557d                	li	a0,-1
    800060dc:	bfdd                	j	800060d2 <uartgetc+0x1c>

00000000800060de <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    800060de:	1101                	addi	sp,sp,-32
    800060e0:	ec06                	sd	ra,24(sp)
    800060e2:	e822                	sd	s0,16(sp)
    800060e4:	e426                	sd	s1,8(sp)
    800060e6:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800060e8:	54fd                	li	s1,-1
    int c = uartgetc();
    800060ea:	00000097          	auipc	ra,0x0
    800060ee:	fcc080e7          	jalr	-52(ra) # 800060b6 <uartgetc>
    if(c == -1)
    800060f2:	00950763          	beq	a0,s1,80006100 <uartintr+0x22>
      break;
    consoleintr(c);
    800060f6:	00000097          	auipc	ra,0x0
    800060fa:	8ce080e7          	jalr	-1842(ra) # 800059c4 <consoleintr>
  while(1){
    800060fe:	b7f5                	j	800060ea <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006100:	00020497          	auipc	s1,0x20
    80006104:	10848493          	addi	s1,s1,264 # 80026208 <uart_tx_lock>
    80006108:	8526                	mv	a0,s1
    8000610a:	00000097          	auipc	ra,0x0
    8000610e:	0b8080e7          	jalr	184(ra) # 800061c2 <acquire>
  uartstart();
    80006112:	00000097          	auipc	ra,0x0
    80006116:	e5e080e7          	jalr	-418(ra) # 80005f70 <uartstart>
  release(&uart_tx_lock);
    8000611a:	8526                	mv	a0,s1
    8000611c:	00000097          	auipc	ra,0x0
    80006120:	156080e7          	jalr	342(ra) # 80006272 <release>
}
    80006124:	60e2                	ld	ra,24(sp)
    80006126:	6442                	ld	s0,16(sp)
    80006128:	64a2                	ld	s1,8(sp)
    8000612a:	6105                	addi	sp,sp,32
    8000612c:	8082                	ret

000000008000612e <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    8000612e:	1141                	addi	sp,sp,-16
    80006130:	e406                	sd	ra,8(sp)
    80006132:	e022                	sd	s0,0(sp)
    80006134:	0800                	addi	s0,sp,16
  lk->name = name;
    80006136:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80006138:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    8000613c:	00053823          	sd	zero,16(a0)
}
    80006140:	60a2                	ld	ra,8(sp)
    80006142:	6402                	ld	s0,0(sp)
    80006144:	0141                	addi	sp,sp,16
    80006146:	8082                	ret

0000000080006148 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006148:	411c                	lw	a5,0(a0)
    8000614a:	e399                	bnez	a5,80006150 <holding+0x8>
    8000614c:	4501                	li	a0,0
  return r;
}
    8000614e:	8082                	ret
{
    80006150:	1101                	addi	sp,sp,-32
    80006152:	ec06                	sd	ra,24(sp)
    80006154:	e822                	sd	s0,16(sp)
    80006156:	e426                	sd	s1,8(sp)
    80006158:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    8000615a:	6904                	ld	s1,16(a0)
    8000615c:	ffffb097          	auipc	ra,0xffffb
    80006160:	cf8080e7          	jalr	-776(ra) # 80000e54 <mycpu>
    80006164:	40a48533          	sub	a0,s1,a0
    80006168:	00153513          	seqz	a0,a0
}
    8000616c:	60e2                	ld	ra,24(sp)
    8000616e:	6442                	ld	s0,16(sp)
    80006170:	64a2                	ld	s1,8(sp)
    80006172:	6105                	addi	sp,sp,32
    80006174:	8082                	ret

0000000080006176 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006176:	1101                	addi	sp,sp,-32
    80006178:	ec06                	sd	ra,24(sp)
    8000617a:	e822                	sd	s0,16(sp)
    8000617c:	e426                	sd	s1,8(sp)
    8000617e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006180:	100024f3          	csrr	s1,sstatus
    80006184:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006188:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000618a:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    8000618e:	ffffb097          	auipc	ra,0xffffb
    80006192:	cc6080e7          	jalr	-826(ra) # 80000e54 <mycpu>
    80006196:	5d3c                	lw	a5,120(a0)
    80006198:	cf89                	beqz	a5,800061b2 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    8000619a:	ffffb097          	auipc	ra,0xffffb
    8000619e:	cba080e7          	jalr	-838(ra) # 80000e54 <mycpu>
    800061a2:	5d3c                	lw	a5,120(a0)
    800061a4:	2785                	addiw	a5,a5,1
    800061a6:	dd3c                	sw	a5,120(a0)
}
    800061a8:	60e2                	ld	ra,24(sp)
    800061aa:	6442                	ld	s0,16(sp)
    800061ac:	64a2                	ld	s1,8(sp)
    800061ae:	6105                	addi	sp,sp,32
    800061b0:	8082                	ret
    mycpu()->intena = old;
    800061b2:	ffffb097          	auipc	ra,0xffffb
    800061b6:	ca2080e7          	jalr	-862(ra) # 80000e54 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800061ba:	8085                	srli	s1,s1,0x1
    800061bc:	8885                	andi	s1,s1,1
    800061be:	dd64                	sw	s1,124(a0)
    800061c0:	bfe9                	j	8000619a <push_off+0x24>

00000000800061c2 <acquire>:
{
    800061c2:	1101                	addi	sp,sp,-32
    800061c4:	ec06                	sd	ra,24(sp)
    800061c6:	e822                	sd	s0,16(sp)
    800061c8:	e426                	sd	s1,8(sp)
    800061ca:	1000                	addi	s0,sp,32
    800061cc:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800061ce:	00000097          	auipc	ra,0x0
    800061d2:	fa8080e7          	jalr	-88(ra) # 80006176 <push_off>
  if(holding(lk))
    800061d6:	8526                	mv	a0,s1
    800061d8:	00000097          	auipc	ra,0x0
    800061dc:	f70080e7          	jalr	-144(ra) # 80006148 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800061e0:	4705                	li	a4,1
  if(holding(lk))
    800061e2:	e115                	bnez	a0,80006206 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800061e4:	87ba                	mv	a5,a4
    800061e6:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800061ea:	2781                	sext.w	a5,a5
    800061ec:	ffe5                	bnez	a5,800061e4 <acquire+0x22>
  __sync_synchronize();
    800061ee:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    800061f2:	ffffb097          	auipc	ra,0xffffb
    800061f6:	c62080e7          	jalr	-926(ra) # 80000e54 <mycpu>
    800061fa:	e888                	sd	a0,16(s1)
}
    800061fc:	60e2                	ld	ra,24(sp)
    800061fe:	6442                	ld	s0,16(sp)
    80006200:	64a2                	ld	s1,8(sp)
    80006202:	6105                	addi	sp,sp,32
    80006204:	8082                	ret
    panic("acquire");
    80006206:	00002517          	auipc	a0,0x2
    8000620a:	4ca50513          	addi	a0,a0,1226 # 800086d0 <etext+0x6d0>
    8000620e:	00000097          	auipc	ra,0x0
    80006212:	a34080e7          	jalr	-1484(ra) # 80005c42 <panic>

0000000080006216 <pop_off>:

void
pop_off(void)
{
    80006216:	1141                	addi	sp,sp,-16
    80006218:	e406                	sd	ra,8(sp)
    8000621a:	e022                	sd	s0,0(sp)
    8000621c:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    8000621e:	ffffb097          	auipc	ra,0xffffb
    80006222:	c36080e7          	jalr	-970(ra) # 80000e54 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006226:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000622a:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000622c:	e39d                	bnez	a5,80006252 <pop_off+0x3c>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    8000622e:	5d3c                	lw	a5,120(a0)
    80006230:	02f05963          	blez	a5,80006262 <pop_off+0x4c>
    panic("pop_off");
  c->noff -= 1;
    80006234:	37fd                	addiw	a5,a5,-1
    80006236:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006238:	eb89                	bnez	a5,8000624a <pop_off+0x34>
    8000623a:	5d7c                	lw	a5,124(a0)
    8000623c:	c799                	beqz	a5,8000624a <pop_off+0x34>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000623e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006242:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006246:	10079073          	csrw	sstatus,a5
    intr_on();
}
    8000624a:	60a2                	ld	ra,8(sp)
    8000624c:	6402                	ld	s0,0(sp)
    8000624e:	0141                	addi	sp,sp,16
    80006250:	8082                	ret
    panic("pop_off - interruptible");
    80006252:	00002517          	auipc	a0,0x2
    80006256:	48650513          	addi	a0,a0,1158 # 800086d8 <etext+0x6d8>
    8000625a:	00000097          	auipc	ra,0x0
    8000625e:	9e8080e7          	jalr	-1560(ra) # 80005c42 <panic>
    panic("pop_off");
    80006262:	00002517          	auipc	a0,0x2
    80006266:	48e50513          	addi	a0,a0,1166 # 800086f0 <etext+0x6f0>
    8000626a:	00000097          	auipc	ra,0x0
    8000626e:	9d8080e7          	jalr	-1576(ra) # 80005c42 <panic>

0000000080006272 <release>:
{
    80006272:	1101                	addi	sp,sp,-32
    80006274:	ec06                	sd	ra,24(sp)
    80006276:	e822                	sd	s0,16(sp)
    80006278:	e426                	sd	s1,8(sp)
    8000627a:	1000                	addi	s0,sp,32
    8000627c:	84aa                	mv	s1,a0
  if(!holding(lk))
    8000627e:	00000097          	auipc	ra,0x0
    80006282:	eca080e7          	jalr	-310(ra) # 80006148 <holding>
    80006286:	c115                	beqz	a0,800062aa <release+0x38>
  lk->cpu = 0;
    80006288:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    8000628c:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    80006290:	0310000f          	fence	rw,w
    80006294:	0004a023          	sw	zero,0(s1)
  pop_off();
    80006298:	00000097          	auipc	ra,0x0
    8000629c:	f7e080e7          	jalr	-130(ra) # 80006216 <pop_off>
}
    800062a0:	60e2                	ld	ra,24(sp)
    800062a2:	6442                	ld	s0,16(sp)
    800062a4:	64a2                	ld	s1,8(sp)
    800062a6:	6105                	addi	sp,sp,32
    800062a8:	8082                	ret
    panic("release");
    800062aa:	00002517          	auipc	a0,0x2
    800062ae:	44e50513          	addi	a0,a0,1102 # 800086f8 <etext+0x6f8>
    800062b2:	00000097          	auipc	ra,0x0
    800062b6:	990080e7          	jalr	-1648(ra) # 80005c42 <panic>
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
