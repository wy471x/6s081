
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
    80000016:	790050ef          	jal	800057a6 <start>

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
    8000005e:	198080e7          	jalr	408(ra) # 800061f2 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	234080e7          	jalr	564(ra) # 800062a2 <release>
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
    8000008e:	be8080e7          	jalr	-1048(ra) # 80005c72 <panic>

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
    800000fa:	068080e7          	jalr	104(ra) # 8000615e <initlock>
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
    80000132:	0c4080e7          	jalr	196(ra) # 800061f2 <acquire>
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
    8000014a:	15c080e7          	jalr	348(ra) # 800062a2 <release>

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
    80000174:	132080e7          	jalr	306(ra) # 800062a2 <release>
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
    80000340:	b32080e7          	jalr	-1230(ra) # 80000e6e <cpuid>
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
    8000035c:	b16080e7          	jalr	-1258(ra) # 80000e6e <cpuid>
    80000360:	85aa                	mv	a1,a0
    80000362:	00008517          	auipc	a0,0x8
    80000366:	cd650513          	addi	a0,a0,-810 # 80008038 <etext+0x38>
    8000036a:	00006097          	auipc	ra,0x6
    8000036e:	952080e7          	jalr	-1710(ra) # 80005cbc <printf>
    kvminithart();    // turn on paging
    80000372:	00000097          	auipc	ra,0x0
    80000376:	0d8080e7          	jalr	216(ra) # 8000044a <kvminithart>
    trapinithart();   // install kernel trap vector
    8000037a:	00001097          	auipc	ra,0x1
    8000037e:	77a080e7          	jalr	1914(ra) # 80001af4 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000382:	00005097          	auipc	ra,0x5
    80000386:	df2080e7          	jalr	-526(ra) # 80005174 <plicinithart>
  }

  scheduler();        
    8000038a:	00001097          	auipc	ra,0x1
    8000038e:	02c080e7          	jalr	44(ra) # 800013b6 <scheduler>
    consoleinit();
    80000392:	00006097          	auipc	ra,0x6
    80000396:	802080e7          	jalr	-2046(ra) # 80005b94 <consoleinit>
    printfinit();
    8000039a:	00006097          	auipc	ra,0x6
    8000039e:	b2c080e7          	jalr	-1236(ra) # 80005ec6 <printfinit>
    printf("\n");
    800003a2:	00008517          	auipc	a0,0x8
    800003a6:	c7650513          	addi	a0,a0,-906 # 80008018 <etext+0x18>
    800003aa:	00006097          	auipc	ra,0x6
    800003ae:	912080e7          	jalr	-1774(ra) # 80005cbc <printf>
    printf("xv6 kernel is booting\n");
    800003b2:	00008517          	auipc	a0,0x8
    800003b6:	c6e50513          	addi	a0,a0,-914 # 80008020 <etext+0x20>
    800003ba:	00006097          	auipc	ra,0x6
    800003be:	902080e7          	jalr	-1790(ra) # 80005cbc <printf>
    printf("\n");
    800003c2:	00008517          	auipc	a0,0x8
    800003c6:	c5650513          	addi	a0,a0,-938 # 80008018 <etext+0x18>
    800003ca:	00006097          	auipc	ra,0x6
    800003ce:	8f2080e7          	jalr	-1806(ra) # 80005cbc <printf>
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
    800003ee:	9cc080e7          	jalr	-1588(ra) # 80000db6 <procinit>
    trapinit();      // trap vectors
    800003f2:	00001097          	auipc	ra,0x1
    800003f6:	6da080e7          	jalr	1754(ra) # 80001acc <trapinit>
    trapinithart();  // install kernel trap vector
    800003fa:	00001097          	auipc	ra,0x1
    800003fe:	6fa080e7          	jalr	1786(ra) # 80001af4 <trapinithart>
    plicinit();      // set up interrupt controller
    80000402:	00005097          	auipc	ra,0x5
    80000406:	d58080e7          	jalr	-680(ra) # 8000515a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    8000040a:	00005097          	auipc	ra,0x5
    8000040e:	d6a080e7          	jalr	-662(ra) # 80005174 <plicinithart>
    binit();         // buffer cache
    80000412:	00002097          	auipc	ra,0x2
    80000416:	e38080e7          	jalr	-456(ra) # 8000224a <binit>
    iinit();         // inode table
    8000041a:	00002097          	auipc	ra,0x2
    8000041e:	4a6080e7          	jalr	1190(ra) # 800028c0 <iinit>
    fileinit();      // file table
    80000422:	00003097          	auipc	ra,0x3
    80000426:	470080e7          	jalr	1136(ra) # 80003892 <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000042a:	00005097          	auipc	ra,0x5
    8000042e:	e6a080e7          	jalr	-406(ra) # 80005294 <virtio_disk_init>
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
    800004e0:	00005097          	auipc	ra,0x5
    800004e4:	792080e7          	jalr	1938(ra) # 80005c72 <panic>
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
    800005ce:	6a8080e7          	jalr	1704(ra) # 80005c72 <panic>
      panic("mappages: remap");
    800005d2:	00008517          	auipc	a0,0x8
    800005d6:	a9650513          	addi	a0,a0,-1386 # 80008068 <etext+0x68>
    800005da:	00005097          	auipc	ra,0x5
    800005de:	698080e7          	jalr	1688(ra) # 80005c72 <panic>
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
    8000062c:	64a080e7          	jalr	1610(ra) # 80005c72 <panic>

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
    8000076c:	50a080e7          	jalr	1290(ra) # 80005c72 <panic>
      panic("uvmunmap: walk");
    80000770:	00008517          	auipc	a0,0x8
    80000774:	92850513          	addi	a0,a0,-1752 # 80008098 <etext+0x98>
    80000778:	00005097          	auipc	ra,0x5
    8000077c:	4fa080e7          	jalr	1274(ra) # 80005c72 <panic>
      panic("uvmunmap: not mapped");
    80000780:	00008517          	auipc	a0,0x8
    80000784:	92850513          	addi	a0,a0,-1752 # 800080a8 <etext+0xa8>
    80000788:	00005097          	auipc	ra,0x5
    8000078c:	4ea080e7          	jalr	1258(ra) # 80005c72 <panic>
      panic("uvmunmap: not a leaf");
    80000790:	00008517          	auipc	a0,0x8
    80000794:	93050513          	addi	a0,a0,-1744 # 800080c0 <etext+0xc0>
    80000798:	00005097          	auipc	ra,0x5
    8000079c:	4da080e7          	jalr	1242(ra) # 80005c72 <panic>
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
    80000890:	3e6080e7          	jalr	998(ra) # 80005c72 <panic>

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
    800009ee:	288080e7          	jalr	648(ra) # 80005c72 <panic>
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
    80000ace:	1a8080e7          	jalr	424(ra) # 80005c72 <panic>
      panic("uvmcopy: page not present");
    80000ad2:	00007517          	auipc	a0,0x7
    80000ad6:	65650513          	addi	a0,a0,1622 # 80008128 <etext+0x128>
    80000ada:	00005097          	auipc	ra,0x5
    80000ade:	198080e7          	jalr	408(ra) # 80005c72 <panic>
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
    80000b4a:	12c080e7          	jalr	300(ra) # 80005c72 <panic>

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
    80000d30:	a4fa57b7          	lui	a5,0xa4fa5
    80000d34:	fa578793          	addi	a5,a5,-91 # ffffffffa4fa4fa5 <end+0xffffffff24f7ed65>
    80000d38:	4fa50937          	lui	s2,0x4fa50
    80000d3c:	a5090913          	addi	s2,s2,-1456 # 4fa4fa50 <_entry-0x305b05b0>
    80000d40:	1902                	slli	s2,s2,0x20
    80000d42:	993e                	add	s2,s2,a5
    80000d44:	040009b7          	lui	s3,0x4000
    80000d48:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000d4a:	09b2                	slli	s3,s3,0xc
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d4c:	4b99                	li	s7,6
    80000d4e:	6b05                	lui	s6,0x1
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d50:	0000ea97          	auipc	s5,0xe
    80000d54:	130a8a93          	addi	s5,s5,304 # 8000ee80 <tickslock>
    char *pa = kalloc();
    80000d58:	fffff097          	auipc	ra,0xfffff
    80000d5c:	3c2080e7          	jalr	962(ra) # 8000011a <kalloc>
    80000d60:	862a                	mv	a2,a0
    if(pa == 0)
    80000d62:	c131                	beqz	a0,80000da6 <proc_mapstacks+0x9a>
    uint64 va = KSTACK((int) (p - proc));
    80000d64:	418485b3          	sub	a1,s1,s8
    80000d68:	858d                	srai	a1,a1,0x3
    80000d6a:	032585b3          	mul	a1,a1,s2
    80000d6e:	2585                	addiw	a1,a1,1
    80000d70:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d74:	875e                	mv	a4,s7
    80000d76:	86da                	mv	a3,s6
    80000d78:	40b985b3          	sub	a1,s3,a1
    80000d7c:	8552                	mv	a0,s4
    80000d7e:	00000097          	auipc	ra,0x0
    80000d82:	882080e7          	jalr	-1918(ra) # 80000600 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d86:	16848493          	addi	s1,s1,360
    80000d8a:	fd5497e3          	bne	s1,s5,80000d58 <proc_mapstacks+0x4c>
  }
}
    80000d8e:	60a6                	ld	ra,72(sp)
    80000d90:	6406                	ld	s0,64(sp)
    80000d92:	74e2                	ld	s1,56(sp)
    80000d94:	7942                	ld	s2,48(sp)
    80000d96:	79a2                	ld	s3,40(sp)
    80000d98:	7a02                	ld	s4,32(sp)
    80000d9a:	6ae2                	ld	s5,24(sp)
    80000d9c:	6b42                	ld	s6,16(sp)
    80000d9e:	6ba2                	ld	s7,8(sp)
    80000da0:	6c02                	ld	s8,0(sp)
    80000da2:	6161                	addi	sp,sp,80
    80000da4:	8082                	ret
      panic("kalloc");
    80000da6:	00007517          	auipc	a0,0x7
    80000daa:	3b250513          	addi	a0,a0,946 # 80008158 <etext+0x158>
    80000dae:	00005097          	auipc	ra,0x5
    80000db2:	ec4080e7          	jalr	-316(ra) # 80005c72 <panic>

0000000080000db6 <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000db6:	7139                	addi	sp,sp,-64
    80000db8:	fc06                	sd	ra,56(sp)
    80000dba:	f822                	sd	s0,48(sp)
    80000dbc:	f426                	sd	s1,40(sp)
    80000dbe:	f04a                	sd	s2,32(sp)
    80000dc0:	ec4e                	sd	s3,24(sp)
    80000dc2:	e852                	sd	s4,16(sp)
    80000dc4:	e456                	sd	s5,8(sp)
    80000dc6:	e05a                	sd	s6,0(sp)
    80000dc8:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000dca:	00007597          	auipc	a1,0x7
    80000dce:	39658593          	addi	a1,a1,918 # 80008160 <etext+0x160>
    80000dd2:	00008517          	auipc	a0,0x8
    80000dd6:	27e50513          	addi	a0,a0,638 # 80009050 <pid_lock>
    80000dda:	00005097          	auipc	ra,0x5
    80000dde:	384080e7          	jalr	900(ra) # 8000615e <initlock>
  initlock(&wait_lock, "wait_lock");
    80000de2:	00007597          	auipc	a1,0x7
    80000de6:	38658593          	addi	a1,a1,902 # 80008168 <etext+0x168>
    80000dea:	00008517          	auipc	a0,0x8
    80000dee:	27e50513          	addi	a0,a0,638 # 80009068 <wait_lock>
    80000df2:	00005097          	auipc	ra,0x5
    80000df6:	36c080e7          	jalr	876(ra) # 8000615e <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dfa:	00008497          	auipc	s1,0x8
    80000dfe:	68648493          	addi	s1,s1,1670 # 80009480 <proc>
      initlock(&p->lock, "proc");
    80000e02:	00007b17          	auipc	s6,0x7
    80000e06:	376b0b13          	addi	s6,s6,886 # 80008178 <etext+0x178>
      p->kstack = KSTACK((int) (p - proc));
    80000e0a:	8aa6                	mv	s5,s1
    80000e0c:	a4fa57b7          	lui	a5,0xa4fa5
    80000e10:	fa578793          	addi	a5,a5,-91 # ffffffffa4fa4fa5 <end+0xffffffff24f7ed65>
    80000e14:	4fa50937          	lui	s2,0x4fa50
    80000e18:	a5090913          	addi	s2,s2,-1456 # 4fa4fa50 <_entry-0x305b05b0>
    80000e1c:	1902                	slli	s2,s2,0x20
    80000e1e:	993e                	add	s2,s2,a5
    80000e20:	040009b7          	lui	s3,0x4000
    80000e24:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000e26:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e28:	0000ea17          	auipc	s4,0xe
    80000e2c:	058a0a13          	addi	s4,s4,88 # 8000ee80 <tickslock>
      initlock(&p->lock, "proc");
    80000e30:	85da                	mv	a1,s6
    80000e32:	8526                	mv	a0,s1
    80000e34:	00005097          	auipc	ra,0x5
    80000e38:	32a080e7          	jalr	810(ra) # 8000615e <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000e3c:	415487b3          	sub	a5,s1,s5
    80000e40:	878d                	srai	a5,a5,0x3
    80000e42:	032787b3          	mul	a5,a5,s2
    80000e46:	2785                	addiw	a5,a5,1
    80000e48:	00d7979b          	slliw	a5,a5,0xd
    80000e4c:	40f987b3          	sub	a5,s3,a5
    80000e50:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e52:	16848493          	addi	s1,s1,360
    80000e56:	fd449de3          	bne	s1,s4,80000e30 <procinit+0x7a>
  }
}
    80000e5a:	70e2                	ld	ra,56(sp)
    80000e5c:	7442                	ld	s0,48(sp)
    80000e5e:	74a2                	ld	s1,40(sp)
    80000e60:	7902                	ld	s2,32(sp)
    80000e62:	69e2                	ld	s3,24(sp)
    80000e64:	6a42                	ld	s4,16(sp)
    80000e66:	6aa2                	ld	s5,8(sp)
    80000e68:	6b02                	ld	s6,0(sp)
    80000e6a:	6121                	addi	sp,sp,64
    80000e6c:	8082                	ret

0000000080000e6e <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e6e:	1141                	addi	sp,sp,-16
    80000e70:	e406                	sd	ra,8(sp)
    80000e72:	e022                	sd	s0,0(sp)
    80000e74:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e76:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e78:	2501                	sext.w	a0,a0
    80000e7a:	60a2                	ld	ra,8(sp)
    80000e7c:	6402                	ld	s0,0(sp)
    80000e7e:	0141                	addi	sp,sp,16
    80000e80:	8082                	ret

0000000080000e82 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000e82:	1141                	addi	sp,sp,-16
    80000e84:	e406                	sd	ra,8(sp)
    80000e86:	e022                	sd	s0,0(sp)
    80000e88:	0800                	addi	s0,sp,16
    80000e8a:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e8c:	2781                	sext.w	a5,a5
    80000e8e:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e90:	00008517          	auipc	a0,0x8
    80000e94:	1f050513          	addi	a0,a0,496 # 80009080 <cpus>
    80000e98:	953e                	add	a0,a0,a5
    80000e9a:	60a2                	ld	ra,8(sp)
    80000e9c:	6402                	ld	s0,0(sp)
    80000e9e:	0141                	addi	sp,sp,16
    80000ea0:	8082                	ret

0000000080000ea2 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000ea2:	1101                	addi	sp,sp,-32
    80000ea4:	ec06                	sd	ra,24(sp)
    80000ea6:	e822                	sd	s0,16(sp)
    80000ea8:	e426                	sd	s1,8(sp)
    80000eaa:	1000                	addi	s0,sp,32
  push_off();
    80000eac:	00005097          	auipc	ra,0x5
    80000eb0:	2fa080e7          	jalr	762(ra) # 800061a6 <push_off>
    80000eb4:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000eb6:	2781                	sext.w	a5,a5
    80000eb8:	079e                	slli	a5,a5,0x7
    80000eba:	00008717          	auipc	a4,0x8
    80000ebe:	19670713          	addi	a4,a4,406 # 80009050 <pid_lock>
    80000ec2:	97ba                	add	a5,a5,a4
    80000ec4:	7b84                	ld	s1,48(a5)
  pop_off();
    80000ec6:	00005097          	auipc	ra,0x5
    80000eca:	380080e7          	jalr	896(ra) # 80006246 <pop_off>
  return p;
}
    80000ece:	8526                	mv	a0,s1
    80000ed0:	60e2                	ld	ra,24(sp)
    80000ed2:	6442                	ld	s0,16(sp)
    80000ed4:	64a2                	ld	s1,8(sp)
    80000ed6:	6105                	addi	sp,sp,32
    80000ed8:	8082                	ret

0000000080000eda <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000eda:	1141                	addi	sp,sp,-16
    80000edc:	e406                	sd	ra,8(sp)
    80000ede:	e022                	sd	s0,0(sp)
    80000ee0:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000ee2:	00000097          	auipc	ra,0x0
    80000ee6:	fc0080e7          	jalr	-64(ra) # 80000ea2 <myproc>
    80000eea:	00005097          	auipc	ra,0x5
    80000eee:	3b8080e7          	jalr	952(ra) # 800062a2 <release>

  if (first) {
    80000ef2:	00008797          	auipc	a5,0x8
    80000ef6:	91e7a783          	lw	a5,-1762(a5) # 80008810 <first.1>
    80000efa:	eb89                	bnez	a5,80000f0c <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000efc:	00001097          	auipc	ra,0x1
    80000f00:	c14080e7          	jalr	-1004(ra) # 80001b10 <usertrapret>
}
    80000f04:	60a2                	ld	ra,8(sp)
    80000f06:	6402                	ld	s0,0(sp)
    80000f08:	0141                	addi	sp,sp,16
    80000f0a:	8082                	ret
    first = 0;
    80000f0c:	00008797          	auipc	a5,0x8
    80000f10:	9007a223          	sw	zero,-1788(a5) # 80008810 <first.1>
    fsinit(ROOTDEV);
    80000f14:	4505                	li	a0,1
    80000f16:	00002097          	auipc	ra,0x2
    80000f1a:	92a080e7          	jalr	-1750(ra) # 80002840 <fsinit>
    80000f1e:	bff9                	j	80000efc <forkret+0x22>

0000000080000f20 <allocpid>:
allocpid() {
    80000f20:	1101                	addi	sp,sp,-32
    80000f22:	ec06                	sd	ra,24(sp)
    80000f24:	e822                	sd	s0,16(sp)
    80000f26:	e426                	sd	s1,8(sp)
    80000f28:	e04a                	sd	s2,0(sp)
    80000f2a:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000f2c:	00008917          	auipc	s2,0x8
    80000f30:	12490913          	addi	s2,s2,292 # 80009050 <pid_lock>
    80000f34:	854a                	mv	a0,s2
    80000f36:	00005097          	auipc	ra,0x5
    80000f3a:	2bc080e7          	jalr	700(ra) # 800061f2 <acquire>
  pid = nextpid;
    80000f3e:	00008797          	auipc	a5,0x8
    80000f42:	8d678793          	addi	a5,a5,-1834 # 80008814 <nextpid>
    80000f46:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000f48:	0014871b          	addiw	a4,s1,1
    80000f4c:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000f4e:	854a                	mv	a0,s2
    80000f50:	00005097          	auipc	ra,0x5
    80000f54:	352080e7          	jalr	850(ra) # 800062a2 <release>
}
    80000f58:	8526                	mv	a0,s1
    80000f5a:	60e2                	ld	ra,24(sp)
    80000f5c:	6442                	ld	s0,16(sp)
    80000f5e:	64a2                	ld	s1,8(sp)
    80000f60:	6902                	ld	s2,0(sp)
    80000f62:	6105                	addi	sp,sp,32
    80000f64:	8082                	ret

0000000080000f66 <proc_pagetable>:
{
    80000f66:	1101                	addi	sp,sp,-32
    80000f68:	ec06                	sd	ra,24(sp)
    80000f6a:	e822                	sd	s0,16(sp)
    80000f6c:	e426                	sd	s1,8(sp)
    80000f6e:	e04a                	sd	s2,0(sp)
    80000f70:	1000                	addi	s0,sp,32
    80000f72:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f74:	00000097          	auipc	ra,0x0
    80000f78:	880080e7          	jalr	-1920(ra) # 800007f4 <uvmcreate>
    80000f7c:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f7e:	c121                	beqz	a0,80000fbe <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f80:	4729                	li	a4,10
    80000f82:	00006697          	auipc	a3,0x6
    80000f86:	07e68693          	addi	a3,a3,126 # 80007000 <_trampoline>
    80000f8a:	6605                	lui	a2,0x1
    80000f8c:	040005b7          	lui	a1,0x4000
    80000f90:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f92:	05b2                	slli	a1,a1,0xc
    80000f94:	fffff097          	auipc	ra,0xfffff
    80000f98:	5c6080e7          	jalr	1478(ra) # 8000055a <mappages>
    80000f9c:	02054863          	bltz	a0,80000fcc <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000fa0:	4719                	li	a4,6
    80000fa2:	05893683          	ld	a3,88(s2)
    80000fa6:	6605                	lui	a2,0x1
    80000fa8:	020005b7          	lui	a1,0x2000
    80000fac:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000fae:	05b6                	slli	a1,a1,0xd
    80000fb0:	8526                	mv	a0,s1
    80000fb2:	fffff097          	auipc	ra,0xfffff
    80000fb6:	5a8080e7          	jalr	1448(ra) # 8000055a <mappages>
    80000fba:	02054163          	bltz	a0,80000fdc <proc_pagetable+0x76>
}
    80000fbe:	8526                	mv	a0,s1
    80000fc0:	60e2                	ld	ra,24(sp)
    80000fc2:	6442                	ld	s0,16(sp)
    80000fc4:	64a2                	ld	s1,8(sp)
    80000fc6:	6902                	ld	s2,0(sp)
    80000fc8:	6105                	addi	sp,sp,32
    80000fca:	8082                	ret
    uvmfree(pagetable, 0);
    80000fcc:	4581                	li	a1,0
    80000fce:	8526                	mv	a0,s1
    80000fd0:	00000097          	auipc	ra,0x0
    80000fd4:	a3c080e7          	jalr	-1476(ra) # 80000a0c <uvmfree>
    return 0;
    80000fd8:	4481                	li	s1,0
    80000fda:	b7d5                	j	80000fbe <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fdc:	4681                	li	a3,0
    80000fde:	4605                	li	a2,1
    80000fe0:	040005b7          	lui	a1,0x4000
    80000fe4:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000fe6:	05b2                	slli	a1,a1,0xc
    80000fe8:	8526                	mv	a0,s1
    80000fea:	fffff097          	auipc	ra,0xfffff
    80000fee:	736080e7          	jalr	1846(ra) # 80000720 <uvmunmap>
    uvmfree(pagetable, 0);
    80000ff2:	4581                	li	a1,0
    80000ff4:	8526                	mv	a0,s1
    80000ff6:	00000097          	auipc	ra,0x0
    80000ffa:	a16080e7          	jalr	-1514(ra) # 80000a0c <uvmfree>
    return 0;
    80000ffe:	4481                	li	s1,0
    80001000:	bf7d                	j	80000fbe <proc_pagetable+0x58>

0000000080001002 <proc_freepagetable>:
{
    80001002:	1101                	addi	sp,sp,-32
    80001004:	ec06                	sd	ra,24(sp)
    80001006:	e822                	sd	s0,16(sp)
    80001008:	e426                	sd	s1,8(sp)
    8000100a:	e04a                	sd	s2,0(sp)
    8000100c:	1000                	addi	s0,sp,32
    8000100e:	84aa                	mv	s1,a0
    80001010:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001012:	4681                	li	a3,0
    80001014:	4605                	li	a2,1
    80001016:	040005b7          	lui	a1,0x4000
    8000101a:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000101c:	05b2                	slli	a1,a1,0xc
    8000101e:	fffff097          	auipc	ra,0xfffff
    80001022:	702080e7          	jalr	1794(ra) # 80000720 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001026:	4681                	li	a3,0
    80001028:	4605                	li	a2,1
    8000102a:	020005b7          	lui	a1,0x2000
    8000102e:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001030:	05b6                	slli	a1,a1,0xd
    80001032:	8526                	mv	a0,s1
    80001034:	fffff097          	auipc	ra,0xfffff
    80001038:	6ec080e7          	jalr	1772(ra) # 80000720 <uvmunmap>
  uvmfree(pagetable, sz);
    8000103c:	85ca                	mv	a1,s2
    8000103e:	8526                	mv	a0,s1
    80001040:	00000097          	auipc	ra,0x0
    80001044:	9cc080e7          	jalr	-1588(ra) # 80000a0c <uvmfree>
}
    80001048:	60e2                	ld	ra,24(sp)
    8000104a:	6442                	ld	s0,16(sp)
    8000104c:	64a2                	ld	s1,8(sp)
    8000104e:	6902                	ld	s2,0(sp)
    80001050:	6105                	addi	sp,sp,32
    80001052:	8082                	ret

0000000080001054 <freeproc>:
{
    80001054:	1101                	addi	sp,sp,-32
    80001056:	ec06                	sd	ra,24(sp)
    80001058:	e822                	sd	s0,16(sp)
    8000105a:	e426                	sd	s1,8(sp)
    8000105c:	1000                	addi	s0,sp,32
    8000105e:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001060:	6d28                	ld	a0,88(a0)
    80001062:	c509                	beqz	a0,8000106c <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001064:	fffff097          	auipc	ra,0xfffff
    80001068:	fb8080e7          	jalr	-72(ra) # 8000001c <kfree>
  p->trapframe = 0;
    8000106c:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001070:	68a8                	ld	a0,80(s1)
    80001072:	c511                	beqz	a0,8000107e <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001074:	64ac                	ld	a1,72(s1)
    80001076:	00000097          	auipc	ra,0x0
    8000107a:	f8c080e7          	jalr	-116(ra) # 80001002 <proc_freepagetable>
  p->pagetable = 0;
    8000107e:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001082:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001086:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    8000108a:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    8000108e:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001092:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001096:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    8000109a:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    8000109e:	0004ac23          	sw	zero,24(s1)
}
    800010a2:	60e2                	ld	ra,24(sp)
    800010a4:	6442                	ld	s0,16(sp)
    800010a6:	64a2                	ld	s1,8(sp)
    800010a8:	6105                	addi	sp,sp,32
    800010aa:	8082                	ret

00000000800010ac <allocproc>:
{
    800010ac:	1101                	addi	sp,sp,-32
    800010ae:	ec06                	sd	ra,24(sp)
    800010b0:	e822                	sd	s0,16(sp)
    800010b2:	e426                	sd	s1,8(sp)
    800010b4:	e04a                	sd	s2,0(sp)
    800010b6:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    800010b8:	00008497          	auipc	s1,0x8
    800010bc:	3c848493          	addi	s1,s1,968 # 80009480 <proc>
    800010c0:	0000e917          	auipc	s2,0xe
    800010c4:	dc090913          	addi	s2,s2,-576 # 8000ee80 <tickslock>
    acquire(&p->lock);
    800010c8:	8526                	mv	a0,s1
    800010ca:	00005097          	auipc	ra,0x5
    800010ce:	128080e7          	jalr	296(ra) # 800061f2 <acquire>
    if(p->state == UNUSED) {
    800010d2:	4c9c                	lw	a5,24(s1)
    800010d4:	cf81                	beqz	a5,800010ec <allocproc+0x40>
      release(&p->lock);
    800010d6:	8526                	mv	a0,s1
    800010d8:	00005097          	auipc	ra,0x5
    800010dc:	1ca080e7          	jalr	458(ra) # 800062a2 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800010e0:	16848493          	addi	s1,s1,360
    800010e4:	ff2492e3          	bne	s1,s2,800010c8 <allocproc+0x1c>
  return 0;
    800010e8:	4481                	li	s1,0
    800010ea:	a889                	j	8000113c <allocproc+0x90>
  p->pid = allocpid();
    800010ec:	00000097          	auipc	ra,0x0
    800010f0:	e34080e7          	jalr	-460(ra) # 80000f20 <allocpid>
    800010f4:	d888                	sw	a0,48(s1)
  p->state = USED;
    800010f6:	4785                	li	a5,1
    800010f8:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800010fa:	fffff097          	auipc	ra,0xfffff
    800010fe:	020080e7          	jalr	32(ra) # 8000011a <kalloc>
    80001102:	892a                	mv	s2,a0
    80001104:	eca8                	sd	a0,88(s1)
    80001106:	c131                	beqz	a0,8000114a <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    80001108:	8526                	mv	a0,s1
    8000110a:	00000097          	auipc	ra,0x0
    8000110e:	e5c080e7          	jalr	-420(ra) # 80000f66 <proc_pagetable>
    80001112:	892a                	mv	s2,a0
    80001114:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001116:	c531                	beqz	a0,80001162 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    80001118:	07000613          	li	a2,112
    8000111c:	4581                	li	a1,0
    8000111e:	06048513          	addi	a0,s1,96
    80001122:	fffff097          	auipc	ra,0xfffff
    80001126:	058080e7          	jalr	88(ra) # 8000017a <memset>
  p->context.ra = (uint64)forkret;
    8000112a:	00000797          	auipc	a5,0x0
    8000112e:	db078793          	addi	a5,a5,-592 # 80000eda <forkret>
    80001132:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001134:	60bc                	ld	a5,64(s1)
    80001136:	6705                	lui	a4,0x1
    80001138:	97ba                	add	a5,a5,a4
    8000113a:	f4bc                	sd	a5,104(s1)
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
    80001150:	f08080e7          	jalr	-248(ra) # 80001054 <freeproc>
    release(&p->lock);
    80001154:	8526                	mv	a0,s1
    80001156:	00005097          	auipc	ra,0x5
    8000115a:	14c080e7          	jalr	332(ra) # 800062a2 <release>
    return 0;
    8000115e:	84ca                	mv	s1,s2
    80001160:	bff1                	j	8000113c <allocproc+0x90>
    freeproc(p);
    80001162:	8526                	mv	a0,s1
    80001164:	00000097          	auipc	ra,0x0
    80001168:	ef0080e7          	jalr	-272(ra) # 80001054 <freeproc>
    release(&p->lock);
    8000116c:	8526                	mv	a0,s1
    8000116e:	00005097          	auipc	ra,0x5
    80001172:	134080e7          	jalr	308(ra) # 800062a2 <release>
    return 0;
    80001176:	84ca                	mv	s1,s2
    80001178:	b7d1                	j	8000113c <allocproc+0x90>

000000008000117a <userinit>:
{
    8000117a:	1101                	addi	sp,sp,-32
    8000117c:	ec06                	sd	ra,24(sp)
    8000117e:	e822                	sd	s0,16(sp)
    80001180:	e426                	sd	s1,8(sp)
    80001182:	1000                	addi	s0,sp,32
  p = allocproc();
    80001184:	00000097          	auipc	ra,0x0
    80001188:	f28080e7          	jalr	-216(ra) # 800010ac <allocproc>
    8000118c:	84aa                	mv	s1,a0
  initproc = p;
    8000118e:	00008797          	auipc	a5,0x8
    80001192:	e8a7b123          	sd	a0,-382(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001196:	03400613          	li	a2,52
    8000119a:	00007597          	auipc	a1,0x7
    8000119e:	68658593          	addi	a1,a1,1670 # 80008820 <initcode>
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
    800011dc:	0c8080e7          	jalr	200(ra) # 800032a0 <namei>
    800011e0:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800011e4:	478d                	li	a5,3
    800011e6:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800011e8:	8526                	mv	a0,s1
    800011ea:	00005097          	auipc	ra,0x5
    800011ee:	0b8080e7          	jalr	184(ra) # 800062a2 <release>
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
    8000120e:	c98080e7          	jalr	-872(ra) # 80000ea2 <myproc>
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
    80001284:	c22080e7          	jalr	-990(ra) # 80000ea2 <myproc>
    80001288:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    8000128a:	00000097          	auipc	ra,0x0
    8000128e:	e22080e7          	jalr	-478(ra) # 800010ac <allocproc>
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
    80001306:	d52080e7          	jalr	-686(ra) # 80001054 <freeproc>
    release(&np->lock);
    8000130a:	8552                	mv	a0,s4
    8000130c:	00005097          	auipc	ra,0x5
    80001310:	f96080e7          	jalr	-106(ra) # 800062a2 <release>
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
    8000132a:	5fe080e7          	jalr	1534(ra) # 80003924 <filedup>
    8000132e:	00a93023          	sd	a0,0(s2)
    80001332:	b7e5                	j	8000131a <fork+0xa6>
  np->cwd = idup(p->cwd);
    80001334:	150ab503          	ld	a0,336(s5)
    80001338:	00001097          	auipc	ra,0x1
    8000133c:	73e080e7          	jalr	1854(ra) # 80002a76 <idup>
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
    80001360:	f46080e7          	jalr	-186(ra) # 800062a2 <release>
  acquire(&wait_lock);
    80001364:	00008497          	auipc	s1,0x8
    80001368:	d0448493          	addi	s1,s1,-764 # 80009068 <wait_lock>
    8000136c:	8526                	mv	a0,s1
    8000136e:	00005097          	auipc	ra,0x5
    80001372:	e84080e7          	jalr	-380(ra) # 800061f2 <acquire>
  np->parent = p;
    80001376:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    8000137a:	8526                	mv	a0,s1
    8000137c:	00005097          	auipc	ra,0x5
    80001380:	f26080e7          	jalr	-218(ra) # 800062a2 <release>
  acquire(&np->lock);
    80001384:	8552                	mv	a0,s4
    80001386:	00005097          	auipc	ra,0x5
    8000138a:	e6c080e7          	jalr	-404(ra) # 800061f2 <acquire>
  np->state = RUNNABLE;
    8000138e:	478d                	li	a5,3
    80001390:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001394:	8552                	mv	a0,s4
    80001396:	00005097          	auipc	ra,0x5
    8000139a:	f0c080e7          	jalr	-244(ra) # 800062a2 <release>
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
    80001412:	a7290913          	addi	s2,s2,-1422 # 8000ee80 <tickslock>
    80001416:	a811                	j	8000142a <scheduler+0x74>
      release(&p->lock);
    80001418:	8526                	mv	a0,s1
    8000141a:	00005097          	auipc	ra,0x5
    8000141e:	e88080e7          	jalr	-376(ra) # 800062a2 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001422:	16848493          	addi	s1,s1,360
    80001426:	fd248ae3          	beq	s1,s2,800013fa <scheduler+0x44>
      acquire(&p->lock);
    8000142a:	8526                	mv	a0,s1
    8000142c:	00005097          	auipc	ra,0x5
    80001430:	dc6080e7          	jalr	-570(ra) # 800061f2 <acquire>
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
    80001468:	a3e080e7          	jalr	-1474(ra) # 80000ea2 <myproc>
    8000146c:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    8000146e:	00005097          	auipc	ra,0x5
    80001472:	d0a080e7          	jalr	-758(ra) # 80006178 <holding>
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
    800014f4:	00004097          	auipc	ra,0x4
    800014f8:	77e080e7          	jalr	1918(ra) # 80005c72 <panic>
    panic("sched locks");
    800014fc:	00007517          	auipc	a0,0x7
    80001500:	cac50513          	addi	a0,a0,-852 # 800081a8 <etext+0x1a8>
    80001504:	00004097          	auipc	ra,0x4
    80001508:	76e080e7          	jalr	1902(ra) # 80005c72 <panic>
    panic("sched running");
    8000150c:	00007517          	auipc	a0,0x7
    80001510:	cac50513          	addi	a0,a0,-852 # 800081b8 <etext+0x1b8>
    80001514:	00004097          	auipc	ra,0x4
    80001518:	75e080e7          	jalr	1886(ra) # 80005c72 <panic>
    panic("sched interruptible");
    8000151c:	00007517          	auipc	a0,0x7
    80001520:	cac50513          	addi	a0,a0,-852 # 800081c8 <etext+0x1c8>
    80001524:	00004097          	auipc	ra,0x4
    80001528:	74e080e7          	jalr	1870(ra) # 80005c72 <panic>

000000008000152c <yield>:
{
    8000152c:	1101                	addi	sp,sp,-32
    8000152e:	ec06                	sd	ra,24(sp)
    80001530:	e822                	sd	s0,16(sp)
    80001532:	e426                	sd	s1,8(sp)
    80001534:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001536:	00000097          	auipc	ra,0x0
    8000153a:	96c080e7          	jalr	-1684(ra) # 80000ea2 <myproc>
    8000153e:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001540:	00005097          	auipc	ra,0x5
    80001544:	cb2080e7          	jalr	-846(ra) # 800061f2 <acquire>
  p->state = RUNNABLE;
    80001548:	478d                	li	a5,3
    8000154a:	cc9c                	sw	a5,24(s1)
  sched();
    8000154c:	00000097          	auipc	ra,0x0
    80001550:	f0a080e7          	jalr	-246(ra) # 80001456 <sched>
  release(&p->lock);
    80001554:	8526                	mv	a0,s1
    80001556:	00005097          	auipc	ra,0x5
    8000155a:	d4c080e7          	jalr	-692(ra) # 800062a2 <release>
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
    8000157e:	928080e7          	jalr	-1752(ra) # 80000ea2 <myproc>
    80001582:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001584:	00005097          	auipc	ra,0x5
    80001588:	c6e080e7          	jalr	-914(ra) # 800061f2 <acquire>
  release(lk);
    8000158c:	854a                	mv	a0,s2
    8000158e:	00005097          	auipc	ra,0x5
    80001592:	d14080e7          	jalr	-748(ra) # 800062a2 <release>

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
    800015b0:	cf6080e7          	jalr	-778(ra) # 800062a2 <release>
  acquire(lk);
    800015b4:	854a                	mv	a0,s2
    800015b6:	00005097          	auipc	ra,0x5
    800015ba:	c3c080e7          	jalr	-964(ra) # 800061f2 <acquire>
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
    800015e8:	8be080e7          	jalr	-1858(ra) # 80000ea2 <myproc>
    800015ec:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800015ee:	00008517          	auipc	a0,0x8
    800015f2:	a7a50513          	addi	a0,a0,-1414 # 80009068 <wait_lock>
    800015f6:	00005097          	auipc	ra,0x5
    800015fa:	bfc080e7          	jalr	-1028(ra) # 800061f2 <acquire>
        if(np->state == ZOMBIE){
    800015fe:	4a15                	li	s4,5
        havekids = 1;
    80001600:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    80001602:	0000e997          	auipc	s3,0xe
    80001606:	87e98993          	addi	s3,s3,-1922 # 8000ee80 <tickslock>
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
    8000163a:	a1e080e7          	jalr	-1506(ra) # 80001054 <freeproc>
          release(&np->lock);
    8000163e:	8526                	mv	a0,s1
    80001640:	00005097          	auipc	ra,0x5
    80001644:	c62080e7          	jalr	-926(ra) # 800062a2 <release>
          release(&wait_lock);
    80001648:	00008517          	auipc	a0,0x8
    8000164c:	a2050513          	addi	a0,a0,-1504 # 80009068 <wait_lock>
    80001650:	00005097          	auipc	ra,0x5
    80001654:	c52080e7          	jalr	-942(ra) # 800062a2 <release>
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
    80001676:	c30080e7          	jalr	-976(ra) # 800062a2 <release>
            release(&wait_lock);
    8000167a:	00008517          	auipc	a0,0x8
    8000167e:	9ee50513          	addi	a0,a0,-1554 # 80009068 <wait_lock>
    80001682:	00005097          	auipc	ra,0x5
    80001686:	c20080e7          	jalr	-992(ra) # 800062a2 <release>
            return -1;
    8000168a:	59fd                	li	s3,-1
    8000168c:	b7f1                	j	80001658 <wait+0x8c>
    for(np = proc; np < &proc[NPROC]; np++){
    8000168e:	16848493          	addi	s1,s1,360
    80001692:	03348463          	beq	s1,s3,800016ba <wait+0xee>
      if(np->parent == p){
    80001696:	7c9c                	ld	a5,56(s1)
    80001698:	ff279be3          	bne	a5,s2,8000168e <wait+0xc2>
        acquire(&np->lock);
    8000169c:	8526                	mv	a0,s1
    8000169e:	00005097          	auipc	ra,0x5
    800016a2:	b54080e7          	jalr	-1196(ra) # 800061f2 <acquire>
        if(np->state == ZOMBIE){
    800016a6:	4c9c                	lw	a5,24(s1)
    800016a8:	f74786e3          	beq	a5,s4,80001614 <wait+0x48>
        release(&np->lock);
    800016ac:	8526                	mv	a0,s1
    800016ae:	00005097          	auipc	ra,0x5
    800016b2:	bf4080e7          	jalr	-1036(ra) # 800062a2 <release>
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
    800016e6:	bc0080e7          	jalr	-1088(ra) # 800062a2 <release>
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
    8000170e:	0000d917          	auipc	s2,0xd
    80001712:	77290913          	addi	s2,s2,1906 # 8000ee80 <tickslock>
    80001716:	a811                	j	8000172a <wakeup+0x3c>
      }
      release(&p->lock);
    80001718:	8526                	mv	a0,s1
    8000171a:	00005097          	auipc	ra,0x5
    8000171e:	b88080e7          	jalr	-1144(ra) # 800062a2 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001722:	16848493          	addi	s1,s1,360
    80001726:	03248663          	beq	s1,s2,80001752 <wakeup+0x64>
    if(p != myproc()){
    8000172a:	fffff097          	auipc	ra,0xfffff
    8000172e:	778080e7          	jalr	1912(ra) # 80000ea2 <myproc>
    80001732:	fea488e3          	beq	s1,a0,80001722 <wakeup+0x34>
      acquire(&p->lock);
    80001736:	8526                	mv	a0,s1
    80001738:	00005097          	auipc	ra,0x5
    8000173c:	aba080e7          	jalr	-1350(ra) # 800061f2 <acquire>
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
    80001786:	0000d997          	auipc	s3,0xd
    8000178a:	6fa98993          	addi	s3,s3,1786 # 8000ee80 <tickslock>
    8000178e:	a029                	j	80001798 <reparent+0x34>
    80001790:	16848493          	addi	s1,s1,360
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
    800017d4:	6d2080e7          	jalr	1746(ra) # 80000ea2 <myproc>
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
    800017fa:	47c080e7          	jalr	1148(ra) # 80005c72 <panic>
  for(int fd = 0; fd < NOFILE; fd++){
    800017fe:	04a1                	addi	s1,s1,8
    80001800:	01248b63          	beq	s1,s2,80001816 <exit+0x58>
    if(p->ofile[fd]){
    80001804:	6088                	ld	a0,0(s1)
    80001806:	dd65                	beqz	a0,800017fe <exit+0x40>
      fileclose(f);
    80001808:	00002097          	auipc	ra,0x2
    8000180c:	16e080e7          	jalr	366(ra) # 80003976 <fileclose>
      p->ofile[fd] = 0;
    80001810:	0004b023          	sd	zero,0(s1)
    80001814:	b7ed                	j	800017fe <exit+0x40>
  begin_op();
    80001816:	00002097          	auipc	ra,0x2
    8000181a:	c90080e7          	jalr	-880(ra) # 800034a6 <begin_op>
  iput(p->cwd);
    8000181e:	1509b503          	ld	a0,336(s3)
    80001822:	00001097          	auipc	ra,0x1
    80001826:	450080e7          	jalr	1104(ra) # 80002c72 <iput>
  end_op();
    8000182a:	00002097          	auipc	ra,0x2
    8000182e:	cf6080e7          	jalr	-778(ra) # 80003520 <end_op>
  p->cwd = 0;
    80001832:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001836:	00008497          	auipc	s1,0x8
    8000183a:	83248493          	addi	s1,s1,-1998 # 80009068 <wait_lock>
    8000183e:	8526                	mv	a0,s1
    80001840:	00005097          	auipc	ra,0x5
    80001844:	9b2080e7          	jalr	-1614(ra) # 800061f2 <acquire>
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
    80001864:	992080e7          	jalr	-1646(ra) # 800061f2 <acquire>
  p->xstate = status;
    80001868:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    8000186c:	4795                	li	a5,5
    8000186e:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001872:	8526                	mv	a0,s1
    80001874:	00005097          	auipc	ra,0x5
    80001878:	a2e080e7          	jalr	-1490(ra) # 800062a2 <release>
  sched();
    8000187c:	00000097          	auipc	ra,0x0
    80001880:	bda080e7          	jalr	-1062(ra) # 80001456 <sched>
  panic("zombie exit");
    80001884:	00007517          	auipc	a0,0x7
    80001888:	96c50513          	addi	a0,a0,-1684 # 800081f0 <etext+0x1f0>
    8000188c:	00004097          	auipc	ra,0x4
    80001890:	3e6080e7          	jalr	998(ra) # 80005c72 <panic>

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
    800018ac:	0000d997          	auipc	s3,0xd
    800018b0:	5d498993          	addi	s3,s3,1492 # 8000ee80 <tickslock>
    acquire(&p->lock);
    800018b4:	8526                	mv	a0,s1
    800018b6:	00005097          	auipc	ra,0x5
    800018ba:	93c080e7          	jalr	-1732(ra) # 800061f2 <acquire>
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
    800018ca:	9dc080e7          	jalr	-1572(ra) # 800062a2 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800018ce:	16848493          	addi	s1,s1,360
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
    800018ec:	9ba080e7          	jalr	-1606(ra) # 800062a2 <release>
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
    80001922:	584080e7          	jalr	1412(ra) # 80000ea2 <myproc>
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
    80001978:	52e080e7          	jalr	1326(ra) # 80000ea2 <myproc>
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
    800019d4:	2ec080e7          	jalr	748(ra) # 80005cbc <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800019d8:	00008497          	auipc	s1,0x8
    800019dc:	c0048493          	addi	s1,s1,-1024 # 800095d8 <proc+0x158>
    800019e0:	0000d917          	auipc	s2,0xd
    800019e4:	5f890913          	addi	s2,s2,1528 # 8000efd8 <bcache+0x140>
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
    80001a06:	cfeb8b93          	addi	s7,s7,-770 # 80008700 <states.0>
    80001a0a:	a00d                	j	80001a2c <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001a0c:	ed86a583          	lw	a1,-296(a3)
    80001a10:	8556                	mv	a0,s5
    80001a12:	00004097          	auipc	ra,0x4
    80001a16:	2aa080e7          	jalr	682(ra) # 80005cbc <printf>
    printf("\n");
    80001a1a:	8552                	mv	a0,s4
    80001a1c:	00004097          	auipc	ra,0x4
    80001a20:	2a0080e7          	jalr	672(ra) # 80005cbc <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a24:	16848493          	addi	s1,s1,360
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
    80001adc:	0000d517          	auipc	a0,0xd
    80001ae0:	3a450513          	addi	a0,a0,932 # 8000ee80 <tickslock>
    80001ae4:	00004097          	auipc	ra,0x4
    80001ae8:	67a080e7          	jalr	1658(ra) # 8000615e <initlock>
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
    80001b00:	5a478793          	addi	a5,a5,1444 # 800050a0 <kernelvec>
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
    80001b1c:	38a080e7          	jalr	906(ra) # 80000ea2 <myproc>
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
    80001bb8:	0000d497          	auipc	s1,0xd
    80001bbc:	2c848493          	addi	s1,s1,712 # 8000ee80 <tickslock>
    80001bc0:	8526                	mv	a0,s1
    80001bc2:	00004097          	auipc	ra,0x4
    80001bc6:	630080e7          	jalr	1584(ra) # 800061f2 <acquire>
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
    80001be6:	6c0080e7          	jalr	1728(ra) # 800062a2 <release>
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
    80001c2a:	586080e7          	jalr	1414(ra) # 800051ac <plic_claim>
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
    80001c48:	4ca080e7          	jalr	1226(ra) # 8000610e <uartintr>
    if(irq)
    80001c4c:	a839                	j	80001c6a <devintr+0x76>
      virtio_disk_intr();
    80001c4e:	00004097          	auipc	ra,0x4
    80001c52:	a18080e7          	jalr	-1512(ra) # 80005666 <virtio_disk_intr>
    if(irq)
    80001c56:	a811                	j	80001c6a <devintr+0x76>
      printf("unexpected interrupt irq=%d\n", irq);
    80001c58:	85a6                	mv	a1,s1
    80001c5a:	00006517          	auipc	a0,0x6
    80001c5e:	5ee50513          	addi	a0,a0,1518 # 80008248 <etext+0x248>
    80001c62:	00004097          	auipc	ra,0x4
    80001c66:	05a080e7          	jalr	90(ra) # 80005cbc <printf>
      plic_complete(irq);
    80001c6a:	8526                	mv	a0,s1
    80001c6c:	00003097          	auipc	ra,0x3
    80001c70:	564080e7          	jalr	1380(ra) # 800051d0 <plic_complete>
    return 1;
    80001c74:	4505                	li	a0,1
    80001c76:	64a2                	ld	s1,8(sp)
    80001c78:	b755                	j	80001c1c <devintr+0x28>
    if(cpuid() == 0){
    80001c7a:	fffff097          	auipc	ra,0xfffff
    80001c7e:	1f4080e7          	jalr	500(ra) # 80000e6e <cpuid>
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
    80001cb8:	3ec78793          	addi	a5,a5,1004 # 800050a0 <kernelvec>
    80001cbc:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001cc0:	fffff097          	auipc	ra,0xfffff
    80001cc4:	1e2080e7          	jalr	482(ra) # 80000ea2 <myproc>
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
    80001d20:	f56080e7          	jalr	-170(ra) # 80005c72 <panic>
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
    80001d54:	f6c080e7          	jalr	-148(ra) # 80005cbc <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d58:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001d5c:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001d60:	00006517          	auipc	a0,0x6
    80001d64:	55850513          	addi	a0,a0,1368 # 800082b8 <etext+0x2b8>
    80001d68:	00004097          	auipc	ra,0x4
    80001d6c:	f54080e7          	jalr	-172(ra) # 80005cbc <printf>
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
    80001dec:	e8a080e7          	jalr	-374(ra) # 80005c72 <panic>
    panic("kerneltrap: interrupts enabled");
    80001df0:	00006517          	auipc	a0,0x6
    80001df4:	51050513          	addi	a0,a0,1296 # 80008300 <etext+0x300>
    80001df8:	00004097          	auipc	ra,0x4
    80001dfc:	e7a080e7          	jalr	-390(ra) # 80005c72 <panic>
    printf("scause %p\n", scause);
    80001e00:	85ce                	mv	a1,s3
    80001e02:	00006517          	auipc	a0,0x6
    80001e06:	51e50513          	addi	a0,a0,1310 # 80008320 <etext+0x320>
    80001e0a:	00004097          	auipc	ra,0x4
    80001e0e:	eb2080e7          	jalr	-334(ra) # 80005cbc <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e12:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e16:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e1a:	00006517          	auipc	a0,0x6
    80001e1e:	51650513          	addi	a0,a0,1302 # 80008330 <etext+0x330>
    80001e22:	00004097          	auipc	ra,0x4
    80001e26:	e9a080e7          	jalr	-358(ra) # 80005cbc <printf>
    panic("kerneltrap");
    80001e2a:	00006517          	auipc	a0,0x6
    80001e2e:	51e50513          	addi	a0,a0,1310 # 80008348 <etext+0x348>
    80001e32:	00004097          	auipc	ra,0x4
    80001e36:	e40080e7          	jalr	-448(ra) # 80005c72 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e3a:	fffff097          	auipc	ra,0xfffff
    80001e3e:	068080e7          	jalr	104(ra) # 80000ea2 <myproc>
    80001e42:	d541                	beqz	a0,80001dca <kerneltrap+0x38>
    80001e44:	fffff097          	auipc	ra,0xfffff
    80001e48:	05e080e7          	jalr	94(ra) # 80000ea2 <myproc>
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
    80001e6e:	038080e7          	jalr	56(ra) # 80000ea2 <myproc>
  switch (n) {
    80001e72:	4795                	li	a5,5
    80001e74:	0497e163          	bltu	a5,s1,80001eb6 <argraw+0x58>
    80001e78:	048a                	slli	s1,s1,0x2
    80001e7a:	00007717          	auipc	a4,0x7
    80001e7e:	8b670713          	addi	a4,a4,-1866 # 80008730 <states.0+0x30>
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
    80001ec2:	db4080e7          	jalr	-588(ra) # 80005c72 <panic>

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
    80001eda:	fcc080e7          	jalr	-52(ra) # 80000ea2 <myproc>
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
    80001f30:	f76080e7          	jalr	-138(ra) # 80000ea2 <myproc>
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
[SYS_close]   sys_close,
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
    80001fe4:	ec2080e7          	jalr	-318(ra) # 80000ea2 <myproc>
    80001fe8:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80001fea:	05853903          	ld	s2,88(a0)
    80001fee:	0a893783          	ld	a5,168(s2)
    80001ff2:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80001ff6:	37fd                	addiw	a5,a5,-1
    80001ff8:	4751                	li	a4,20
    80001ffa:	00f76f63          	bltu	a4,a5,80002018 <syscall+0x44>
    80001ffe:	00369713          	slli	a4,a3,0x3
    80002002:	00006797          	auipc	a5,0x6
    80002006:	74678793          	addi	a5,a5,1862 # 80008748 <syscalls>
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
    8000202a:	c96080e7          	jalr	-874(ra) # 80005cbc <printf>
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
    80002080:	e26080e7          	jalr	-474(ra) # 80000ea2 <myproc>
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
    800020fc:	daa080e7          	jalr	-598(ra) # 80000ea2 <myproc>
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
    8000213c:	06054b63          	bltz	a0,800021b2 <sys_sleep+0x8e>
    80002140:	f04a                	sd	s2,32(sp)
  acquire(&tickslock);
    80002142:	0000d517          	auipc	a0,0xd
    80002146:	d3e50513          	addi	a0,a0,-706 # 8000ee80 <tickslock>
    8000214a:	00004097          	auipc	ra,0x4
    8000214e:	0a8080e7          	jalr	168(ra) # 800061f2 <acquire>
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
    80002168:	d1c98993          	addi	s3,s3,-740 # 8000ee80 <tickslock>
    8000216c:	00007497          	auipc	s1,0x7
    80002170:	eac48493          	addi	s1,s1,-340 # 80009018 <ticks>
    if(myproc()->killed){
    80002174:	fffff097          	auipc	ra,0xfffff
    80002178:	d2e080e7          	jalr	-722(ra) # 80000ea2 <myproc>
    8000217c:	551c                	lw	a5,40(a0)
    8000217e:	ef9d                	bnez	a5,800021bc <sys_sleep+0x98>
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
    800021a2:	ce250513          	addi	a0,a0,-798 # 8000ee80 <tickslock>
    800021a6:	00004097          	auipc	ra,0x4
    800021aa:	0fc080e7          	jalr	252(ra) # 800062a2 <release>
  return 0;
    800021ae:	4781                	li	a5,0
    800021b0:	7902                	ld	s2,32(sp)
}
    800021b2:	853e                	mv	a0,a5
    800021b4:	70e2                	ld	ra,56(sp)
    800021b6:	7442                	ld	s0,48(sp)
    800021b8:	6121                	addi	sp,sp,64
    800021ba:	8082                	ret
      release(&tickslock);
    800021bc:	0000d517          	auipc	a0,0xd
    800021c0:	cc450513          	addi	a0,a0,-828 # 8000ee80 <tickslock>
    800021c4:	00004097          	auipc	ra,0x4
    800021c8:	0de080e7          	jalr	222(ra) # 800062a2 <release>
      return -1;
    800021cc:	57fd                	li	a5,-1
    800021ce:	74a2                	ld	s1,40(sp)
    800021d0:	7902                	ld	s2,32(sp)
    800021d2:	69e2                	ld	s3,24(sp)
    800021d4:	bff9                	j	800021b2 <sys_sleep+0x8e>

00000000800021d6 <sys_kill>:

uint64
sys_kill(void)
{
    800021d6:	1101                	addi	sp,sp,-32
    800021d8:	ec06                	sd	ra,24(sp)
    800021da:	e822                	sd	s0,16(sp)
    800021dc:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    800021de:	fec40593          	addi	a1,s0,-20
    800021e2:	4501                	li	a0,0
    800021e4:	00000097          	auipc	ra,0x0
    800021e8:	d7c080e7          	jalr	-644(ra) # 80001f60 <argint>
    800021ec:	87aa                	mv	a5,a0
    return -1;
    800021ee:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    800021f0:	0007c863          	bltz	a5,80002200 <sys_kill+0x2a>
  return kill(pid);
    800021f4:	fec42503          	lw	a0,-20(s0)
    800021f8:	fffff097          	auipc	ra,0xfffff
    800021fc:	69c080e7          	jalr	1692(ra) # 80001894 <kill>
}
    80002200:	60e2                	ld	ra,24(sp)
    80002202:	6442                	ld	s0,16(sp)
    80002204:	6105                	addi	sp,sp,32
    80002206:	8082                	ret

0000000080002208 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002208:	1101                	addi	sp,sp,-32
    8000220a:	ec06                	sd	ra,24(sp)
    8000220c:	e822                	sd	s0,16(sp)
    8000220e:	e426                	sd	s1,8(sp)
    80002210:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002212:	0000d517          	auipc	a0,0xd
    80002216:	c6e50513          	addi	a0,a0,-914 # 8000ee80 <tickslock>
    8000221a:	00004097          	auipc	ra,0x4
    8000221e:	fd8080e7          	jalr	-40(ra) # 800061f2 <acquire>
  xticks = ticks;
    80002222:	00007497          	auipc	s1,0x7
    80002226:	df64a483          	lw	s1,-522(s1) # 80009018 <ticks>
  release(&tickslock);
    8000222a:	0000d517          	auipc	a0,0xd
    8000222e:	c5650513          	addi	a0,a0,-938 # 8000ee80 <tickslock>
    80002232:	00004097          	auipc	ra,0x4
    80002236:	070080e7          	jalr	112(ra) # 800062a2 <release>
  return xticks;
}
    8000223a:	02049513          	slli	a0,s1,0x20
    8000223e:	9101                	srli	a0,a0,0x20
    80002240:	60e2                	ld	ra,24(sp)
    80002242:	6442                	ld	s0,16(sp)
    80002244:	64a2                	ld	s1,8(sp)
    80002246:	6105                	addi	sp,sp,32
    80002248:	8082                	ret

000000008000224a <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000224a:	7179                	addi	sp,sp,-48
    8000224c:	f406                	sd	ra,40(sp)
    8000224e:	f022                	sd	s0,32(sp)
    80002250:	ec26                	sd	s1,24(sp)
    80002252:	e84a                	sd	s2,16(sp)
    80002254:	e44e                	sd	s3,8(sp)
    80002256:	e052                	sd	s4,0(sp)
    80002258:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000225a:	00006597          	auipc	a1,0x6
    8000225e:	12658593          	addi	a1,a1,294 # 80008380 <etext+0x380>
    80002262:	0000d517          	auipc	a0,0xd
    80002266:	c3650513          	addi	a0,a0,-970 # 8000ee98 <bcache>
    8000226a:	00004097          	auipc	ra,0x4
    8000226e:	ef4080e7          	jalr	-268(ra) # 8000615e <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002272:	00015797          	auipc	a5,0x15
    80002276:	c2678793          	addi	a5,a5,-986 # 80016e98 <bcache+0x8000>
    8000227a:	00015717          	auipc	a4,0x15
    8000227e:	e8670713          	addi	a4,a4,-378 # 80017100 <bcache+0x8268>
    80002282:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002286:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000228a:	0000d497          	auipc	s1,0xd
    8000228e:	c2648493          	addi	s1,s1,-986 # 8000eeb0 <bcache+0x18>
    b->next = bcache.head.next;
    80002292:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002294:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002296:	00006a17          	auipc	s4,0x6
    8000229a:	0f2a0a13          	addi	s4,s4,242 # 80008388 <etext+0x388>
    b->next = bcache.head.next;
    8000229e:	2b893783          	ld	a5,696(s2)
    800022a2:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800022a4:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800022a8:	85d2                	mv	a1,s4
    800022aa:	01048513          	addi	a0,s1,16
    800022ae:	00001097          	auipc	ra,0x1
    800022b2:	4ba080e7          	jalr	1210(ra) # 80003768 <initsleeplock>
    bcache.head.next->prev = b;
    800022b6:	2b893783          	ld	a5,696(s2)
    800022ba:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800022bc:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800022c0:	45848493          	addi	s1,s1,1112
    800022c4:	fd349de3          	bne	s1,s3,8000229e <binit+0x54>
  }
}
    800022c8:	70a2                	ld	ra,40(sp)
    800022ca:	7402                	ld	s0,32(sp)
    800022cc:	64e2                	ld	s1,24(sp)
    800022ce:	6942                	ld	s2,16(sp)
    800022d0:	69a2                	ld	s3,8(sp)
    800022d2:	6a02                	ld	s4,0(sp)
    800022d4:	6145                	addi	sp,sp,48
    800022d6:	8082                	ret

00000000800022d8 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800022d8:	7179                	addi	sp,sp,-48
    800022da:	f406                	sd	ra,40(sp)
    800022dc:	f022                	sd	s0,32(sp)
    800022de:	ec26                	sd	s1,24(sp)
    800022e0:	e84a                	sd	s2,16(sp)
    800022e2:	e44e                	sd	s3,8(sp)
    800022e4:	1800                	addi	s0,sp,48
    800022e6:	892a                	mv	s2,a0
    800022e8:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800022ea:	0000d517          	auipc	a0,0xd
    800022ee:	bae50513          	addi	a0,a0,-1106 # 8000ee98 <bcache>
    800022f2:	00004097          	auipc	ra,0x4
    800022f6:	f00080e7          	jalr	-256(ra) # 800061f2 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800022fa:	00015497          	auipc	s1,0x15
    800022fe:	e564b483          	ld	s1,-426(s1) # 80017150 <bcache+0x82b8>
    80002302:	00015797          	auipc	a5,0x15
    80002306:	dfe78793          	addi	a5,a5,-514 # 80017100 <bcache+0x8268>
    8000230a:	02f48f63          	beq	s1,a5,80002348 <bread+0x70>
    8000230e:	873e                	mv	a4,a5
    80002310:	a021                	j	80002318 <bread+0x40>
    80002312:	68a4                	ld	s1,80(s1)
    80002314:	02e48a63          	beq	s1,a4,80002348 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002318:	449c                	lw	a5,8(s1)
    8000231a:	ff279ce3          	bne	a5,s2,80002312 <bread+0x3a>
    8000231e:	44dc                	lw	a5,12(s1)
    80002320:	ff3799e3          	bne	a5,s3,80002312 <bread+0x3a>
      b->refcnt++;
    80002324:	40bc                	lw	a5,64(s1)
    80002326:	2785                	addiw	a5,a5,1
    80002328:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000232a:	0000d517          	auipc	a0,0xd
    8000232e:	b6e50513          	addi	a0,a0,-1170 # 8000ee98 <bcache>
    80002332:	00004097          	auipc	ra,0x4
    80002336:	f70080e7          	jalr	-144(ra) # 800062a2 <release>
      acquiresleep(&b->lock);
    8000233a:	01048513          	addi	a0,s1,16
    8000233e:	00001097          	auipc	ra,0x1
    80002342:	464080e7          	jalr	1124(ra) # 800037a2 <acquiresleep>
      return b;
    80002346:	a8b9                	j	800023a4 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002348:	00015497          	auipc	s1,0x15
    8000234c:	e004b483          	ld	s1,-512(s1) # 80017148 <bcache+0x82b0>
    80002350:	00015797          	auipc	a5,0x15
    80002354:	db078793          	addi	a5,a5,-592 # 80017100 <bcache+0x8268>
    80002358:	00f48863          	beq	s1,a5,80002368 <bread+0x90>
    8000235c:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    8000235e:	40bc                	lw	a5,64(s1)
    80002360:	cf81                	beqz	a5,80002378 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002362:	64a4                	ld	s1,72(s1)
    80002364:	fee49de3          	bne	s1,a4,8000235e <bread+0x86>
  panic("bget: no buffers");
    80002368:	00006517          	auipc	a0,0x6
    8000236c:	02850513          	addi	a0,a0,40 # 80008390 <etext+0x390>
    80002370:	00004097          	auipc	ra,0x4
    80002374:	902080e7          	jalr	-1790(ra) # 80005c72 <panic>
      b->dev = dev;
    80002378:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    8000237c:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002380:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002384:	4785                	li	a5,1
    80002386:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002388:	0000d517          	auipc	a0,0xd
    8000238c:	b1050513          	addi	a0,a0,-1264 # 8000ee98 <bcache>
    80002390:	00004097          	auipc	ra,0x4
    80002394:	f12080e7          	jalr	-238(ra) # 800062a2 <release>
      acquiresleep(&b->lock);
    80002398:	01048513          	addi	a0,s1,16
    8000239c:	00001097          	auipc	ra,0x1
    800023a0:	406080e7          	jalr	1030(ra) # 800037a2 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800023a4:	409c                	lw	a5,0(s1)
    800023a6:	cb89                	beqz	a5,800023b8 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800023a8:	8526                	mv	a0,s1
    800023aa:	70a2                	ld	ra,40(sp)
    800023ac:	7402                	ld	s0,32(sp)
    800023ae:	64e2                	ld	s1,24(sp)
    800023b0:	6942                	ld	s2,16(sp)
    800023b2:	69a2                	ld	s3,8(sp)
    800023b4:	6145                	addi	sp,sp,48
    800023b6:	8082                	ret
    virtio_disk_rw(b, 0);
    800023b8:	4581                	li	a1,0
    800023ba:	8526                	mv	a0,s1
    800023bc:	00003097          	auipc	ra,0x3
    800023c0:	022080e7          	jalr	34(ra) # 800053de <virtio_disk_rw>
    b->valid = 1;
    800023c4:	4785                	li	a5,1
    800023c6:	c09c                	sw	a5,0(s1)
  return b;
    800023c8:	b7c5                	j	800023a8 <bread+0xd0>

00000000800023ca <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800023ca:	1101                	addi	sp,sp,-32
    800023cc:	ec06                	sd	ra,24(sp)
    800023ce:	e822                	sd	s0,16(sp)
    800023d0:	e426                	sd	s1,8(sp)
    800023d2:	1000                	addi	s0,sp,32
    800023d4:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800023d6:	0541                	addi	a0,a0,16
    800023d8:	00001097          	auipc	ra,0x1
    800023dc:	464080e7          	jalr	1124(ra) # 8000383c <holdingsleep>
    800023e0:	cd01                	beqz	a0,800023f8 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800023e2:	4585                	li	a1,1
    800023e4:	8526                	mv	a0,s1
    800023e6:	00003097          	auipc	ra,0x3
    800023ea:	ff8080e7          	jalr	-8(ra) # 800053de <virtio_disk_rw>
}
    800023ee:	60e2                	ld	ra,24(sp)
    800023f0:	6442                	ld	s0,16(sp)
    800023f2:	64a2                	ld	s1,8(sp)
    800023f4:	6105                	addi	sp,sp,32
    800023f6:	8082                	ret
    panic("bwrite");
    800023f8:	00006517          	auipc	a0,0x6
    800023fc:	fb050513          	addi	a0,a0,-80 # 800083a8 <etext+0x3a8>
    80002400:	00004097          	auipc	ra,0x4
    80002404:	872080e7          	jalr	-1934(ra) # 80005c72 <panic>

0000000080002408 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002408:	1101                	addi	sp,sp,-32
    8000240a:	ec06                	sd	ra,24(sp)
    8000240c:	e822                	sd	s0,16(sp)
    8000240e:	e426                	sd	s1,8(sp)
    80002410:	e04a                	sd	s2,0(sp)
    80002412:	1000                	addi	s0,sp,32
    80002414:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002416:	01050913          	addi	s2,a0,16
    8000241a:	854a                	mv	a0,s2
    8000241c:	00001097          	auipc	ra,0x1
    80002420:	420080e7          	jalr	1056(ra) # 8000383c <holdingsleep>
    80002424:	c535                	beqz	a0,80002490 <brelse+0x88>
    panic("brelse");

  releasesleep(&b->lock);
    80002426:	854a                	mv	a0,s2
    80002428:	00001097          	auipc	ra,0x1
    8000242c:	3d0080e7          	jalr	976(ra) # 800037f8 <releasesleep>

  acquire(&bcache.lock);
    80002430:	0000d517          	auipc	a0,0xd
    80002434:	a6850513          	addi	a0,a0,-1432 # 8000ee98 <bcache>
    80002438:	00004097          	auipc	ra,0x4
    8000243c:	dba080e7          	jalr	-582(ra) # 800061f2 <acquire>
  b->refcnt--;
    80002440:	40bc                	lw	a5,64(s1)
    80002442:	37fd                	addiw	a5,a5,-1
    80002444:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002446:	e79d                	bnez	a5,80002474 <brelse+0x6c>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002448:	68b8                	ld	a4,80(s1)
    8000244a:	64bc                	ld	a5,72(s1)
    8000244c:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    8000244e:	68b8                	ld	a4,80(s1)
    80002450:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002452:	00015797          	auipc	a5,0x15
    80002456:	a4678793          	addi	a5,a5,-1466 # 80016e98 <bcache+0x8000>
    8000245a:	2b87b703          	ld	a4,696(a5)
    8000245e:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002460:	00015717          	auipc	a4,0x15
    80002464:	ca070713          	addi	a4,a4,-864 # 80017100 <bcache+0x8268>
    80002468:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000246a:	2b87b703          	ld	a4,696(a5)
    8000246e:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002470:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002474:	0000d517          	auipc	a0,0xd
    80002478:	a2450513          	addi	a0,a0,-1500 # 8000ee98 <bcache>
    8000247c:	00004097          	auipc	ra,0x4
    80002480:	e26080e7          	jalr	-474(ra) # 800062a2 <release>
}
    80002484:	60e2                	ld	ra,24(sp)
    80002486:	6442                	ld	s0,16(sp)
    80002488:	64a2                	ld	s1,8(sp)
    8000248a:	6902                	ld	s2,0(sp)
    8000248c:	6105                	addi	sp,sp,32
    8000248e:	8082                	ret
    panic("brelse");
    80002490:	00006517          	auipc	a0,0x6
    80002494:	f2050513          	addi	a0,a0,-224 # 800083b0 <etext+0x3b0>
    80002498:	00003097          	auipc	ra,0x3
    8000249c:	7da080e7          	jalr	2010(ra) # 80005c72 <panic>

00000000800024a0 <bpin>:

void
bpin(struct buf *b) {
    800024a0:	1101                	addi	sp,sp,-32
    800024a2:	ec06                	sd	ra,24(sp)
    800024a4:	e822                	sd	s0,16(sp)
    800024a6:	e426                	sd	s1,8(sp)
    800024a8:	1000                	addi	s0,sp,32
    800024aa:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800024ac:	0000d517          	auipc	a0,0xd
    800024b0:	9ec50513          	addi	a0,a0,-1556 # 8000ee98 <bcache>
    800024b4:	00004097          	auipc	ra,0x4
    800024b8:	d3e080e7          	jalr	-706(ra) # 800061f2 <acquire>
  b->refcnt++;
    800024bc:	40bc                	lw	a5,64(s1)
    800024be:	2785                	addiw	a5,a5,1
    800024c0:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800024c2:	0000d517          	auipc	a0,0xd
    800024c6:	9d650513          	addi	a0,a0,-1578 # 8000ee98 <bcache>
    800024ca:	00004097          	auipc	ra,0x4
    800024ce:	dd8080e7          	jalr	-552(ra) # 800062a2 <release>
}
    800024d2:	60e2                	ld	ra,24(sp)
    800024d4:	6442                	ld	s0,16(sp)
    800024d6:	64a2                	ld	s1,8(sp)
    800024d8:	6105                	addi	sp,sp,32
    800024da:	8082                	ret

00000000800024dc <bunpin>:

void
bunpin(struct buf *b) {
    800024dc:	1101                	addi	sp,sp,-32
    800024de:	ec06                	sd	ra,24(sp)
    800024e0:	e822                	sd	s0,16(sp)
    800024e2:	e426                	sd	s1,8(sp)
    800024e4:	1000                	addi	s0,sp,32
    800024e6:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800024e8:	0000d517          	auipc	a0,0xd
    800024ec:	9b050513          	addi	a0,a0,-1616 # 8000ee98 <bcache>
    800024f0:	00004097          	auipc	ra,0x4
    800024f4:	d02080e7          	jalr	-766(ra) # 800061f2 <acquire>
  b->refcnt--;
    800024f8:	40bc                	lw	a5,64(s1)
    800024fa:	37fd                	addiw	a5,a5,-1
    800024fc:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800024fe:	0000d517          	auipc	a0,0xd
    80002502:	99a50513          	addi	a0,a0,-1638 # 8000ee98 <bcache>
    80002506:	00004097          	auipc	ra,0x4
    8000250a:	d9c080e7          	jalr	-612(ra) # 800062a2 <release>
}
    8000250e:	60e2                	ld	ra,24(sp)
    80002510:	6442                	ld	s0,16(sp)
    80002512:	64a2                	ld	s1,8(sp)
    80002514:	6105                	addi	sp,sp,32
    80002516:	8082                	ret

0000000080002518 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002518:	1101                	addi	sp,sp,-32
    8000251a:	ec06                	sd	ra,24(sp)
    8000251c:	e822                	sd	s0,16(sp)
    8000251e:	e426                	sd	s1,8(sp)
    80002520:	e04a                	sd	s2,0(sp)
    80002522:	1000                	addi	s0,sp,32
    80002524:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002526:	00d5d79b          	srliw	a5,a1,0xd
    8000252a:	00015597          	auipc	a1,0x15
    8000252e:	04a5a583          	lw	a1,74(a1) # 80017574 <sb+0x1c>
    80002532:	9dbd                	addw	a1,a1,a5
    80002534:	00000097          	auipc	ra,0x0
    80002538:	da4080e7          	jalr	-604(ra) # 800022d8 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000253c:	0074f713          	andi	a4,s1,7
    80002540:	4785                	li	a5,1
    80002542:	00e797bb          	sllw	a5,a5,a4
  bi = b % BPB;
    80002546:	14ce                	slli	s1,s1,0x33
  if((bp->data[bi/8] & m) == 0)
    80002548:	90d9                	srli	s1,s1,0x36
    8000254a:	00950733          	add	a4,a0,s1
    8000254e:	05874703          	lbu	a4,88(a4)
    80002552:	00e7f6b3          	and	a3,a5,a4
    80002556:	c69d                	beqz	a3,80002584 <bfree+0x6c>
    80002558:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000255a:	94aa                	add	s1,s1,a0
    8000255c:	fff7c793          	not	a5,a5
    80002560:	8f7d                	and	a4,a4,a5
    80002562:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002566:	00001097          	auipc	ra,0x1
    8000256a:	11e080e7          	jalr	286(ra) # 80003684 <log_write>
  brelse(bp);
    8000256e:	854a                	mv	a0,s2
    80002570:	00000097          	auipc	ra,0x0
    80002574:	e98080e7          	jalr	-360(ra) # 80002408 <brelse>
}
    80002578:	60e2                	ld	ra,24(sp)
    8000257a:	6442                	ld	s0,16(sp)
    8000257c:	64a2                	ld	s1,8(sp)
    8000257e:	6902                	ld	s2,0(sp)
    80002580:	6105                	addi	sp,sp,32
    80002582:	8082                	ret
    panic("freeing free block");
    80002584:	00006517          	auipc	a0,0x6
    80002588:	e3450513          	addi	a0,a0,-460 # 800083b8 <etext+0x3b8>
    8000258c:	00003097          	auipc	ra,0x3
    80002590:	6e6080e7          	jalr	1766(ra) # 80005c72 <panic>

0000000080002594 <balloc>:
{
    80002594:	715d                	addi	sp,sp,-80
    80002596:	e486                	sd	ra,72(sp)
    80002598:	e0a2                	sd	s0,64(sp)
    8000259a:	fc26                	sd	s1,56(sp)
    8000259c:	f84a                	sd	s2,48(sp)
    8000259e:	f44e                	sd	s3,40(sp)
    800025a0:	f052                	sd	s4,32(sp)
    800025a2:	ec56                	sd	s5,24(sp)
    800025a4:	e85a                	sd	s6,16(sp)
    800025a6:	e45e                	sd	s7,8(sp)
    800025a8:	e062                	sd	s8,0(sp)
    800025aa:	0880                	addi	s0,sp,80
  for(b = 0; b < sb.size; b += BPB){
    800025ac:	00015797          	auipc	a5,0x15
    800025b0:	fb07a783          	lw	a5,-80(a5) # 8001755c <sb+0x4>
    800025b4:	c7c1                	beqz	a5,8000263c <balloc+0xa8>
    800025b6:	8baa                	mv	s7,a0
    800025b8:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800025ba:	00015b17          	auipc	s6,0x15
    800025be:	f9eb0b13          	addi	s6,s6,-98 # 80017558 <sb>
      m = 1 << (bi % 8);
    800025c2:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800025c4:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800025c6:	6c09                	lui	s8,0x2
    800025c8:	a821                	j	800025e0 <balloc+0x4c>
    brelse(bp);
    800025ca:	854a                	mv	a0,s2
    800025cc:	00000097          	auipc	ra,0x0
    800025d0:	e3c080e7          	jalr	-452(ra) # 80002408 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800025d4:	015c0abb          	addw	s5,s8,s5
    800025d8:	004b2783          	lw	a5,4(s6)
    800025dc:	06faf063          	bgeu	s5,a5,8000263c <balloc+0xa8>
    bp = bread(dev, BBLOCK(b, sb));
    800025e0:	41fad79b          	sraiw	a5,s5,0x1f
    800025e4:	0137d79b          	srliw	a5,a5,0x13
    800025e8:	015787bb          	addw	a5,a5,s5
    800025ec:	40d7d79b          	sraiw	a5,a5,0xd
    800025f0:	01cb2583          	lw	a1,28(s6)
    800025f4:	9dbd                	addw	a1,a1,a5
    800025f6:	855e                	mv	a0,s7
    800025f8:	00000097          	auipc	ra,0x0
    800025fc:	ce0080e7          	jalr	-800(ra) # 800022d8 <bread>
    80002600:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002602:	004b2503          	lw	a0,4(s6)
    80002606:	84d6                	mv	s1,s5
    80002608:	4701                	li	a4,0
    8000260a:	fca4f0e3          	bgeu	s1,a0,800025ca <balloc+0x36>
      m = 1 << (bi % 8);
    8000260e:	00777693          	andi	a3,a4,7
    80002612:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002616:	41f7579b          	sraiw	a5,a4,0x1f
    8000261a:	01d7d79b          	srliw	a5,a5,0x1d
    8000261e:	9fb9                	addw	a5,a5,a4
    80002620:	4037d79b          	sraiw	a5,a5,0x3
    80002624:	00f90633          	add	a2,s2,a5
    80002628:	05864603          	lbu	a2,88(a2)
    8000262c:	00c6f5b3          	and	a1,a3,a2
    80002630:	cd91                	beqz	a1,8000264c <balloc+0xb8>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002632:	2705                	addiw	a4,a4,1
    80002634:	2485                	addiw	s1,s1,1
    80002636:	fd471ae3          	bne	a4,s4,8000260a <balloc+0x76>
    8000263a:	bf41                	j	800025ca <balloc+0x36>
  panic("balloc: out of blocks");
    8000263c:	00006517          	auipc	a0,0x6
    80002640:	d9450513          	addi	a0,a0,-620 # 800083d0 <etext+0x3d0>
    80002644:	00003097          	auipc	ra,0x3
    80002648:	62e080e7          	jalr	1582(ra) # 80005c72 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000264c:	97ca                	add	a5,a5,s2
    8000264e:	8e55                	or	a2,a2,a3
    80002650:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002654:	854a                	mv	a0,s2
    80002656:	00001097          	auipc	ra,0x1
    8000265a:	02e080e7          	jalr	46(ra) # 80003684 <log_write>
        brelse(bp);
    8000265e:	854a                	mv	a0,s2
    80002660:	00000097          	auipc	ra,0x0
    80002664:	da8080e7          	jalr	-600(ra) # 80002408 <brelse>
  bp = bread(dev, bno);
    80002668:	85a6                	mv	a1,s1
    8000266a:	855e                	mv	a0,s7
    8000266c:	00000097          	auipc	ra,0x0
    80002670:	c6c080e7          	jalr	-916(ra) # 800022d8 <bread>
    80002674:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002676:	40000613          	li	a2,1024
    8000267a:	4581                	li	a1,0
    8000267c:	05850513          	addi	a0,a0,88
    80002680:	ffffe097          	auipc	ra,0xffffe
    80002684:	afa080e7          	jalr	-1286(ra) # 8000017a <memset>
  log_write(bp);
    80002688:	854a                	mv	a0,s2
    8000268a:	00001097          	auipc	ra,0x1
    8000268e:	ffa080e7          	jalr	-6(ra) # 80003684 <log_write>
  brelse(bp);
    80002692:	854a                	mv	a0,s2
    80002694:	00000097          	auipc	ra,0x0
    80002698:	d74080e7          	jalr	-652(ra) # 80002408 <brelse>
}
    8000269c:	8526                	mv	a0,s1
    8000269e:	60a6                	ld	ra,72(sp)
    800026a0:	6406                	ld	s0,64(sp)
    800026a2:	74e2                	ld	s1,56(sp)
    800026a4:	7942                	ld	s2,48(sp)
    800026a6:	79a2                	ld	s3,40(sp)
    800026a8:	7a02                	ld	s4,32(sp)
    800026aa:	6ae2                	ld	s5,24(sp)
    800026ac:	6b42                	ld	s6,16(sp)
    800026ae:	6ba2                	ld	s7,8(sp)
    800026b0:	6c02                	ld	s8,0(sp)
    800026b2:	6161                	addi	sp,sp,80
    800026b4:	8082                	ret

00000000800026b6 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    800026b6:	7179                	addi	sp,sp,-48
    800026b8:	f406                	sd	ra,40(sp)
    800026ba:	f022                	sd	s0,32(sp)
    800026bc:	ec26                	sd	s1,24(sp)
    800026be:	e84a                	sd	s2,16(sp)
    800026c0:	e44e                	sd	s3,8(sp)
    800026c2:	1800                	addi	s0,sp,48
    800026c4:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800026c6:	47ad                	li	a5,11
    800026c8:	04b7fd63          	bgeu	a5,a1,80002722 <bmap+0x6c>
    800026cc:	e052                	sd	s4,0(sp)
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    800026ce:	ff45849b          	addiw	s1,a1,-12

  if(bn < NINDIRECT){
    800026d2:	0ff00793          	li	a5,255
    800026d6:	0897ef63          	bltu	a5,s1,80002774 <bmap+0xbe>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    800026da:	08052583          	lw	a1,128(a0)
    800026de:	c5a5                	beqz	a1,80002746 <bmap+0x90>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    800026e0:	00092503          	lw	a0,0(s2)
    800026e4:	00000097          	auipc	ra,0x0
    800026e8:	bf4080e7          	jalr	-1036(ra) # 800022d8 <bread>
    800026ec:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800026ee:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800026f2:	02049713          	slli	a4,s1,0x20
    800026f6:	01e75593          	srli	a1,a4,0x1e
    800026fa:	00b784b3          	add	s1,a5,a1
    800026fe:	0004a983          	lw	s3,0(s1)
    80002702:	04098b63          	beqz	s3,80002758 <bmap+0xa2>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80002706:	8552                	mv	a0,s4
    80002708:	00000097          	auipc	ra,0x0
    8000270c:	d00080e7          	jalr	-768(ra) # 80002408 <brelse>
    return addr;
    80002710:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80002712:	854e                	mv	a0,s3
    80002714:	70a2                	ld	ra,40(sp)
    80002716:	7402                	ld	s0,32(sp)
    80002718:	64e2                	ld	s1,24(sp)
    8000271a:	6942                	ld	s2,16(sp)
    8000271c:	69a2                	ld	s3,8(sp)
    8000271e:	6145                	addi	sp,sp,48
    80002720:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80002722:	02059793          	slli	a5,a1,0x20
    80002726:	01e7d593          	srli	a1,a5,0x1e
    8000272a:	00b504b3          	add	s1,a0,a1
    8000272e:	0504a983          	lw	s3,80(s1)
    80002732:	fe0990e3          	bnez	s3,80002712 <bmap+0x5c>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80002736:	4108                	lw	a0,0(a0)
    80002738:	00000097          	auipc	ra,0x0
    8000273c:	e5c080e7          	jalr	-420(ra) # 80002594 <balloc>
    80002740:	89aa                	mv	s3,a0
    80002742:	c8a8                	sw	a0,80(s1)
    80002744:	b7f9                	j	80002712 <bmap+0x5c>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80002746:	4108                	lw	a0,0(a0)
    80002748:	00000097          	auipc	ra,0x0
    8000274c:	e4c080e7          	jalr	-436(ra) # 80002594 <balloc>
    80002750:	85aa                	mv	a1,a0
    80002752:	08a92023          	sw	a0,128(s2)
    80002756:	b769                	j	800026e0 <bmap+0x2a>
      a[bn] = addr = balloc(ip->dev);
    80002758:	00092503          	lw	a0,0(s2)
    8000275c:	00000097          	auipc	ra,0x0
    80002760:	e38080e7          	jalr	-456(ra) # 80002594 <balloc>
    80002764:	89aa                	mv	s3,a0
    80002766:	c088                	sw	a0,0(s1)
      log_write(bp);
    80002768:	8552                	mv	a0,s4
    8000276a:	00001097          	auipc	ra,0x1
    8000276e:	f1a080e7          	jalr	-230(ra) # 80003684 <log_write>
    80002772:	bf51                	j	80002706 <bmap+0x50>
  panic("bmap: out of range");
    80002774:	00006517          	auipc	a0,0x6
    80002778:	c7450513          	addi	a0,a0,-908 # 800083e8 <etext+0x3e8>
    8000277c:	00003097          	auipc	ra,0x3
    80002780:	4f6080e7          	jalr	1270(ra) # 80005c72 <panic>

0000000080002784 <iget>:
{
    80002784:	7179                	addi	sp,sp,-48
    80002786:	f406                	sd	ra,40(sp)
    80002788:	f022                	sd	s0,32(sp)
    8000278a:	ec26                	sd	s1,24(sp)
    8000278c:	e84a                	sd	s2,16(sp)
    8000278e:	e44e                	sd	s3,8(sp)
    80002790:	e052                	sd	s4,0(sp)
    80002792:	1800                	addi	s0,sp,48
    80002794:	89aa                	mv	s3,a0
    80002796:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002798:	00015517          	auipc	a0,0x15
    8000279c:	de050513          	addi	a0,a0,-544 # 80017578 <itable>
    800027a0:	00004097          	auipc	ra,0x4
    800027a4:	a52080e7          	jalr	-1454(ra) # 800061f2 <acquire>
  empty = 0;
    800027a8:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800027aa:	00015497          	auipc	s1,0x15
    800027ae:	de648493          	addi	s1,s1,-538 # 80017590 <itable+0x18>
    800027b2:	00017697          	auipc	a3,0x17
    800027b6:	86e68693          	addi	a3,a3,-1938 # 80019020 <log>
    800027ba:	a039                	j	800027c8 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800027bc:	02090b63          	beqz	s2,800027f2 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800027c0:	08848493          	addi	s1,s1,136
    800027c4:	02d48a63          	beq	s1,a3,800027f8 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800027c8:	449c                	lw	a5,8(s1)
    800027ca:	fef059e3          	blez	a5,800027bc <iget+0x38>
    800027ce:	4098                	lw	a4,0(s1)
    800027d0:	ff3716e3          	bne	a4,s3,800027bc <iget+0x38>
    800027d4:	40d8                	lw	a4,4(s1)
    800027d6:	ff4713e3          	bne	a4,s4,800027bc <iget+0x38>
      ip->ref++;
    800027da:	2785                	addiw	a5,a5,1
    800027dc:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800027de:	00015517          	auipc	a0,0x15
    800027e2:	d9a50513          	addi	a0,a0,-614 # 80017578 <itable>
    800027e6:	00004097          	auipc	ra,0x4
    800027ea:	abc080e7          	jalr	-1348(ra) # 800062a2 <release>
      return ip;
    800027ee:	8926                	mv	s2,s1
    800027f0:	a03d                	j	8000281e <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800027f2:	f7f9                	bnez	a5,800027c0 <iget+0x3c>
      empty = ip;
    800027f4:	8926                	mv	s2,s1
    800027f6:	b7e9                	j	800027c0 <iget+0x3c>
  if(empty == 0)
    800027f8:	02090c63          	beqz	s2,80002830 <iget+0xac>
  ip->dev = dev;
    800027fc:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002800:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002804:	4785                	li	a5,1
    80002806:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    8000280a:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    8000280e:	00015517          	auipc	a0,0x15
    80002812:	d6a50513          	addi	a0,a0,-662 # 80017578 <itable>
    80002816:	00004097          	auipc	ra,0x4
    8000281a:	a8c080e7          	jalr	-1396(ra) # 800062a2 <release>
}
    8000281e:	854a                	mv	a0,s2
    80002820:	70a2                	ld	ra,40(sp)
    80002822:	7402                	ld	s0,32(sp)
    80002824:	64e2                	ld	s1,24(sp)
    80002826:	6942                	ld	s2,16(sp)
    80002828:	69a2                	ld	s3,8(sp)
    8000282a:	6a02                	ld	s4,0(sp)
    8000282c:	6145                	addi	sp,sp,48
    8000282e:	8082                	ret
    panic("iget: no inodes");
    80002830:	00006517          	auipc	a0,0x6
    80002834:	bd050513          	addi	a0,a0,-1072 # 80008400 <etext+0x400>
    80002838:	00003097          	auipc	ra,0x3
    8000283c:	43a080e7          	jalr	1082(ra) # 80005c72 <panic>

0000000080002840 <fsinit>:
fsinit(int dev) {
    80002840:	7179                	addi	sp,sp,-48
    80002842:	f406                	sd	ra,40(sp)
    80002844:	f022                	sd	s0,32(sp)
    80002846:	ec26                	sd	s1,24(sp)
    80002848:	e84a                	sd	s2,16(sp)
    8000284a:	e44e                	sd	s3,8(sp)
    8000284c:	1800                	addi	s0,sp,48
    8000284e:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002850:	4585                	li	a1,1
    80002852:	00000097          	auipc	ra,0x0
    80002856:	a86080e7          	jalr	-1402(ra) # 800022d8 <bread>
    8000285a:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    8000285c:	00015997          	auipc	s3,0x15
    80002860:	cfc98993          	addi	s3,s3,-772 # 80017558 <sb>
    80002864:	02000613          	li	a2,32
    80002868:	05850593          	addi	a1,a0,88
    8000286c:	854e                	mv	a0,s3
    8000286e:	ffffe097          	auipc	ra,0xffffe
    80002872:	970080e7          	jalr	-1680(ra) # 800001de <memmove>
  brelse(bp);
    80002876:	8526                	mv	a0,s1
    80002878:	00000097          	auipc	ra,0x0
    8000287c:	b90080e7          	jalr	-1136(ra) # 80002408 <brelse>
  if(sb.magic != FSMAGIC)
    80002880:	0009a703          	lw	a4,0(s3)
    80002884:	102037b7          	lui	a5,0x10203
    80002888:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    8000288c:	02f71263          	bne	a4,a5,800028b0 <fsinit+0x70>
  initlog(dev, &sb);
    80002890:	00015597          	auipc	a1,0x15
    80002894:	cc858593          	addi	a1,a1,-824 # 80017558 <sb>
    80002898:	854a                	mv	a0,s2
    8000289a:	00001097          	auipc	ra,0x1
    8000289e:	b74080e7          	jalr	-1164(ra) # 8000340e <initlog>
}
    800028a2:	70a2                	ld	ra,40(sp)
    800028a4:	7402                	ld	s0,32(sp)
    800028a6:	64e2                	ld	s1,24(sp)
    800028a8:	6942                	ld	s2,16(sp)
    800028aa:	69a2                	ld	s3,8(sp)
    800028ac:	6145                	addi	sp,sp,48
    800028ae:	8082                	ret
    panic("invalid file system");
    800028b0:	00006517          	auipc	a0,0x6
    800028b4:	b6050513          	addi	a0,a0,-1184 # 80008410 <etext+0x410>
    800028b8:	00003097          	auipc	ra,0x3
    800028bc:	3ba080e7          	jalr	954(ra) # 80005c72 <panic>

00000000800028c0 <iinit>:
{
    800028c0:	7179                	addi	sp,sp,-48
    800028c2:	f406                	sd	ra,40(sp)
    800028c4:	f022                	sd	s0,32(sp)
    800028c6:	ec26                	sd	s1,24(sp)
    800028c8:	e84a                	sd	s2,16(sp)
    800028ca:	e44e                	sd	s3,8(sp)
    800028cc:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800028ce:	00006597          	auipc	a1,0x6
    800028d2:	b5a58593          	addi	a1,a1,-1190 # 80008428 <etext+0x428>
    800028d6:	00015517          	auipc	a0,0x15
    800028da:	ca250513          	addi	a0,a0,-862 # 80017578 <itable>
    800028de:	00004097          	auipc	ra,0x4
    800028e2:	880080e7          	jalr	-1920(ra) # 8000615e <initlock>
  for(i = 0; i < NINODE; i++) {
    800028e6:	00015497          	auipc	s1,0x15
    800028ea:	cba48493          	addi	s1,s1,-838 # 800175a0 <itable+0x28>
    800028ee:	00016997          	auipc	s3,0x16
    800028f2:	74298993          	addi	s3,s3,1858 # 80019030 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800028f6:	00006917          	auipc	s2,0x6
    800028fa:	b3a90913          	addi	s2,s2,-1222 # 80008430 <etext+0x430>
    800028fe:	85ca                	mv	a1,s2
    80002900:	8526                	mv	a0,s1
    80002902:	00001097          	auipc	ra,0x1
    80002906:	e66080e7          	jalr	-410(ra) # 80003768 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    8000290a:	08848493          	addi	s1,s1,136
    8000290e:	ff3498e3          	bne	s1,s3,800028fe <iinit+0x3e>
}
    80002912:	70a2                	ld	ra,40(sp)
    80002914:	7402                	ld	s0,32(sp)
    80002916:	64e2                	ld	s1,24(sp)
    80002918:	6942                	ld	s2,16(sp)
    8000291a:	69a2                	ld	s3,8(sp)
    8000291c:	6145                	addi	sp,sp,48
    8000291e:	8082                	ret

0000000080002920 <ialloc>:
{
    80002920:	7139                	addi	sp,sp,-64
    80002922:	fc06                	sd	ra,56(sp)
    80002924:	f822                	sd	s0,48(sp)
    80002926:	f426                	sd	s1,40(sp)
    80002928:	f04a                	sd	s2,32(sp)
    8000292a:	ec4e                	sd	s3,24(sp)
    8000292c:	e852                	sd	s4,16(sp)
    8000292e:	e456                	sd	s5,8(sp)
    80002930:	e05a                	sd	s6,0(sp)
    80002932:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002934:	00015717          	auipc	a4,0x15
    80002938:	c3072703          	lw	a4,-976(a4) # 80017564 <sb+0xc>
    8000293c:	4785                	li	a5,1
    8000293e:	04e7f863          	bgeu	a5,a4,8000298e <ialloc+0x6e>
    80002942:	8aaa                	mv	s5,a0
    80002944:	8b2e                	mv	s6,a1
    80002946:	893e                	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
    80002948:	00015a17          	auipc	s4,0x15
    8000294c:	c10a0a13          	addi	s4,s4,-1008 # 80017558 <sb>
    80002950:	00495593          	srli	a1,s2,0x4
    80002954:	018a2783          	lw	a5,24(s4)
    80002958:	9dbd                	addw	a1,a1,a5
    8000295a:	8556                	mv	a0,s5
    8000295c:	00000097          	auipc	ra,0x0
    80002960:	97c080e7          	jalr	-1668(ra) # 800022d8 <bread>
    80002964:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002966:	05850993          	addi	s3,a0,88
    8000296a:	00f97793          	andi	a5,s2,15
    8000296e:	079a                	slli	a5,a5,0x6
    80002970:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002972:	00099783          	lh	a5,0(s3)
    80002976:	c785                	beqz	a5,8000299e <ialloc+0x7e>
    brelse(bp);
    80002978:	00000097          	auipc	ra,0x0
    8000297c:	a90080e7          	jalr	-1392(ra) # 80002408 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002980:	0905                	addi	s2,s2,1
    80002982:	00ca2703          	lw	a4,12(s4)
    80002986:	0009079b          	sext.w	a5,s2
    8000298a:	fce7e3e3          	bltu	a5,a4,80002950 <ialloc+0x30>
  panic("ialloc: no inodes");
    8000298e:	00006517          	auipc	a0,0x6
    80002992:	aaa50513          	addi	a0,a0,-1366 # 80008438 <etext+0x438>
    80002996:	00003097          	auipc	ra,0x3
    8000299a:	2dc080e7          	jalr	732(ra) # 80005c72 <panic>
      memset(dip, 0, sizeof(*dip));
    8000299e:	04000613          	li	a2,64
    800029a2:	4581                	li	a1,0
    800029a4:	854e                	mv	a0,s3
    800029a6:	ffffd097          	auipc	ra,0xffffd
    800029aa:	7d4080e7          	jalr	2004(ra) # 8000017a <memset>
      dip->type = type;
    800029ae:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    800029b2:	8526                	mv	a0,s1
    800029b4:	00001097          	auipc	ra,0x1
    800029b8:	cd0080e7          	jalr	-816(ra) # 80003684 <log_write>
      brelse(bp);
    800029bc:	8526                	mv	a0,s1
    800029be:	00000097          	auipc	ra,0x0
    800029c2:	a4a080e7          	jalr	-1462(ra) # 80002408 <brelse>
      return iget(dev, inum);
    800029c6:	0009059b          	sext.w	a1,s2
    800029ca:	8556                	mv	a0,s5
    800029cc:	00000097          	auipc	ra,0x0
    800029d0:	db8080e7          	jalr	-584(ra) # 80002784 <iget>
}
    800029d4:	70e2                	ld	ra,56(sp)
    800029d6:	7442                	ld	s0,48(sp)
    800029d8:	74a2                	ld	s1,40(sp)
    800029da:	7902                	ld	s2,32(sp)
    800029dc:	69e2                	ld	s3,24(sp)
    800029de:	6a42                	ld	s4,16(sp)
    800029e0:	6aa2                	ld	s5,8(sp)
    800029e2:	6b02                	ld	s6,0(sp)
    800029e4:	6121                	addi	sp,sp,64
    800029e6:	8082                	ret

00000000800029e8 <iupdate>:
{
    800029e8:	1101                	addi	sp,sp,-32
    800029ea:	ec06                	sd	ra,24(sp)
    800029ec:	e822                	sd	s0,16(sp)
    800029ee:	e426                	sd	s1,8(sp)
    800029f0:	e04a                	sd	s2,0(sp)
    800029f2:	1000                	addi	s0,sp,32
    800029f4:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800029f6:	415c                	lw	a5,4(a0)
    800029f8:	0047d79b          	srliw	a5,a5,0x4
    800029fc:	00015597          	auipc	a1,0x15
    80002a00:	b745a583          	lw	a1,-1164(a1) # 80017570 <sb+0x18>
    80002a04:	9dbd                	addw	a1,a1,a5
    80002a06:	4108                	lw	a0,0(a0)
    80002a08:	00000097          	auipc	ra,0x0
    80002a0c:	8d0080e7          	jalr	-1840(ra) # 800022d8 <bread>
    80002a10:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002a12:	05850793          	addi	a5,a0,88
    80002a16:	40d8                	lw	a4,4(s1)
    80002a18:	8b3d                	andi	a4,a4,15
    80002a1a:	071a                	slli	a4,a4,0x6
    80002a1c:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002a1e:	04449703          	lh	a4,68(s1)
    80002a22:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002a26:	04649703          	lh	a4,70(s1)
    80002a2a:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002a2e:	04849703          	lh	a4,72(s1)
    80002a32:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002a36:	04a49703          	lh	a4,74(s1)
    80002a3a:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002a3e:	44f8                	lw	a4,76(s1)
    80002a40:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002a42:	03400613          	li	a2,52
    80002a46:	05048593          	addi	a1,s1,80
    80002a4a:	00c78513          	addi	a0,a5,12
    80002a4e:	ffffd097          	auipc	ra,0xffffd
    80002a52:	790080e7          	jalr	1936(ra) # 800001de <memmove>
  log_write(bp);
    80002a56:	854a                	mv	a0,s2
    80002a58:	00001097          	auipc	ra,0x1
    80002a5c:	c2c080e7          	jalr	-980(ra) # 80003684 <log_write>
  brelse(bp);
    80002a60:	854a                	mv	a0,s2
    80002a62:	00000097          	auipc	ra,0x0
    80002a66:	9a6080e7          	jalr	-1626(ra) # 80002408 <brelse>
}
    80002a6a:	60e2                	ld	ra,24(sp)
    80002a6c:	6442                	ld	s0,16(sp)
    80002a6e:	64a2                	ld	s1,8(sp)
    80002a70:	6902                	ld	s2,0(sp)
    80002a72:	6105                	addi	sp,sp,32
    80002a74:	8082                	ret

0000000080002a76 <idup>:
{
    80002a76:	1101                	addi	sp,sp,-32
    80002a78:	ec06                	sd	ra,24(sp)
    80002a7a:	e822                	sd	s0,16(sp)
    80002a7c:	e426                	sd	s1,8(sp)
    80002a7e:	1000                	addi	s0,sp,32
    80002a80:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002a82:	00015517          	auipc	a0,0x15
    80002a86:	af650513          	addi	a0,a0,-1290 # 80017578 <itable>
    80002a8a:	00003097          	auipc	ra,0x3
    80002a8e:	768080e7          	jalr	1896(ra) # 800061f2 <acquire>
  ip->ref++;
    80002a92:	449c                	lw	a5,8(s1)
    80002a94:	2785                	addiw	a5,a5,1
    80002a96:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002a98:	00015517          	auipc	a0,0x15
    80002a9c:	ae050513          	addi	a0,a0,-1312 # 80017578 <itable>
    80002aa0:	00004097          	auipc	ra,0x4
    80002aa4:	802080e7          	jalr	-2046(ra) # 800062a2 <release>
}
    80002aa8:	8526                	mv	a0,s1
    80002aaa:	60e2                	ld	ra,24(sp)
    80002aac:	6442                	ld	s0,16(sp)
    80002aae:	64a2                	ld	s1,8(sp)
    80002ab0:	6105                	addi	sp,sp,32
    80002ab2:	8082                	ret

0000000080002ab4 <ilock>:
{
    80002ab4:	1101                	addi	sp,sp,-32
    80002ab6:	ec06                	sd	ra,24(sp)
    80002ab8:	e822                	sd	s0,16(sp)
    80002aba:	e426                	sd	s1,8(sp)
    80002abc:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002abe:	c10d                	beqz	a0,80002ae0 <ilock+0x2c>
    80002ac0:	84aa                	mv	s1,a0
    80002ac2:	451c                	lw	a5,8(a0)
    80002ac4:	00f05e63          	blez	a5,80002ae0 <ilock+0x2c>
  acquiresleep(&ip->lock);
    80002ac8:	0541                	addi	a0,a0,16
    80002aca:	00001097          	auipc	ra,0x1
    80002ace:	cd8080e7          	jalr	-808(ra) # 800037a2 <acquiresleep>
  if(ip->valid == 0){
    80002ad2:	40bc                	lw	a5,64(s1)
    80002ad4:	cf99                	beqz	a5,80002af2 <ilock+0x3e>
}
    80002ad6:	60e2                	ld	ra,24(sp)
    80002ad8:	6442                	ld	s0,16(sp)
    80002ada:	64a2                	ld	s1,8(sp)
    80002adc:	6105                	addi	sp,sp,32
    80002ade:	8082                	ret
    80002ae0:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80002ae2:	00006517          	auipc	a0,0x6
    80002ae6:	96e50513          	addi	a0,a0,-1682 # 80008450 <etext+0x450>
    80002aea:	00003097          	auipc	ra,0x3
    80002aee:	188080e7          	jalr	392(ra) # 80005c72 <panic>
    80002af2:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002af4:	40dc                	lw	a5,4(s1)
    80002af6:	0047d79b          	srliw	a5,a5,0x4
    80002afa:	00015597          	auipc	a1,0x15
    80002afe:	a765a583          	lw	a1,-1418(a1) # 80017570 <sb+0x18>
    80002b02:	9dbd                	addw	a1,a1,a5
    80002b04:	4088                	lw	a0,0(s1)
    80002b06:	fffff097          	auipc	ra,0xfffff
    80002b0a:	7d2080e7          	jalr	2002(ra) # 800022d8 <bread>
    80002b0e:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b10:	05850593          	addi	a1,a0,88
    80002b14:	40dc                	lw	a5,4(s1)
    80002b16:	8bbd                	andi	a5,a5,15
    80002b18:	079a                	slli	a5,a5,0x6
    80002b1a:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002b1c:	00059783          	lh	a5,0(a1)
    80002b20:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002b24:	00259783          	lh	a5,2(a1)
    80002b28:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002b2c:	00459783          	lh	a5,4(a1)
    80002b30:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002b34:	00659783          	lh	a5,6(a1)
    80002b38:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002b3c:	459c                	lw	a5,8(a1)
    80002b3e:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002b40:	03400613          	li	a2,52
    80002b44:	05b1                	addi	a1,a1,12
    80002b46:	05048513          	addi	a0,s1,80
    80002b4a:	ffffd097          	auipc	ra,0xffffd
    80002b4e:	694080e7          	jalr	1684(ra) # 800001de <memmove>
    brelse(bp);
    80002b52:	854a                	mv	a0,s2
    80002b54:	00000097          	auipc	ra,0x0
    80002b58:	8b4080e7          	jalr	-1868(ra) # 80002408 <brelse>
    ip->valid = 1;
    80002b5c:	4785                	li	a5,1
    80002b5e:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002b60:	04449783          	lh	a5,68(s1)
    80002b64:	c399                	beqz	a5,80002b6a <ilock+0xb6>
    80002b66:	6902                	ld	s2,0(sp)
    80002b68:	b7bd                	j	80002ad6 <ilock+0x22>
      panic("ilock: no type");
    80002b6a:	00006517          	auipc	a0,0x6
    80002b6e:	8ee50513          	addi	a0,a0,-1810 # 80008458 <etext+0x458>
    80002b72:	00003097          	auipc	ra,0x3
    80002b76:	100080e7          	jalr	256(ra) # 80005c72 <panic>

0000000080002b7a <iunlock>:
{
    80002b7a:	1101                	addi	sp,sp,-32
    80002b7c:	ec06                	sd	ra,24(sp)
    80002b7e:	e822                	sd	s0,16(sp)
    80002b80:	e426                	sd	s1,8(sp)
    80002b82:	e04a                	sd	s2,0(sp)
    80002b84:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002b86:	c905                	beqz	a0,80002bb6 <iunlock+0x3c>
    80002b88:	84aa                	mv	s1,a0
    80002b8a:	01050913          	addi	s2,a0,16
    80002b8e:	854a                	mv	a0,s2
    80002b90:	00001097          	auipc	ra,0x1
    80002b94:	cac080e7          	jalr	-852(ra) # 8000383c <holdingsleep>
    80002b98:	cd19                	beqz	a0,80002bb6 <iunlock+0x3c>
    80002b9a:	449c                	lw	a5,8(s1)
    80002b9c:	00f05d63          	blez	a5,80002bb6 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002ba0:	854a                	mv	a0,s2
    80002ba2:	00001097          	auipc	ra,0x1
    80002ba6:	c56080e7          	jalr	-938(ra) # 800037f8 <releasesleep>
}
    80002baa:	60e2                	ld	ra,24(sp)
    80002bac:	6442                	ld	s0,16(sp)
    80002bae:	64a2                	ld	s1,8(sp)
    80002bb0:	6902                	ld	s2,0(sp)
    80002bb2:	6105                	addi	sp,sp,32
    80002bb4:	8082                	ret
    panic("iunlock");
    80002bb6:	00006517          	auipc	a0,0x6
    80002bba:	8b250513          	addi	a0,a0,-1870 # 80008468 <etext+0x468>
    80002bbe:	00003097          	auipc	ra,0x3
    80002bc2:	0b4080e7          	jalr	180(ra) # 80005c72 <panic>

0000000080002bc6 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002bc6:	7179                	addi	sp,sp,-48
    80002bc8:	f406                	sd	ra,40(sp)
    80002bca:	f022                	sd	s0,32(sp)
    80002bcc:	ec26                	sd	s1,24(sp)
    80002bce:	e84a                	sd	s2,16(sp)
    80002bd0:	e44e                	sd	s3,8(sp)
    80002bd2:	1800                	addi	s0,sp,48
    80002bd4:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002bd6:	05050493          	addi	s1,a0,80
    80002bda:	08050913          	addi	s2,a0,128
    80002bde:	a021                	j	80002be6 <itrunc+0x20>
    80002be0:	0491                	addi	s1,s1,4
    80002be2:	01248d63          	beq	s1,s2,80002bfc <itrunc+0x36>
    if(ip->addrs[i]){
    80002be6:	408c                	lw	a1,0(s1)
    80002be8:	dde5                	beqz	a1,80002be0 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80002bea:	0009a503          	lw	a0,0(s3)
    80002bee:	00000097          	auipc	ra,0x0
    80002bf2:	92a080e7          	jalr	-1750(ra) # 80002518 <bfree>
      ip->addrs[i] = 0;
    80002bf6:	0004a023          	sw	zero,0(s1)
    80002bfa:	b7dd                	j	80002be0 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002bfc:	0809a583          	lw	a1,128(s3)
    80002c00:	ed99                	bnez	a1,80002c1e <itrunc+0x58>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002c02:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002c06:	854e                	mv	a0,s3
    80002c08:	00000097          	auipc	ra,0x0
    80002c0c:	de0080e7          	jalr	-544(ra) # 800029e8 <iupdate>
}
    80002c10:	70a2                	ld	ra,40(sp)
    80002c12:	7402                	ld	s0,32(sp)
    80002c14:	64e2                	ld	s1,24(sp)
    80002c16:	6942                	ld	s2,16(sp)
    80002c18:	69a2                	ld	s3,8(sp)
    80002c1a:	6145                	addi	sp,sp,48
    80002c1c:	8082                	ret
    80002c1e:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002c20:	0009a503          	lw	a0,0(s3)
    80002c24:	fffff097          	auipc	ra,0xfffff
    80002c28:	6b4080e7          	jalr	1716(ra) # 800022d8 <bread>
    80002c2c:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002c2e:	05850493          	addi	s1,a0,88
    80002c32:	45850913          	addi	s2,a0,1112
    80002c36:	a021                	j	80002c3e <itrunc+0x78>
    80002c38:	0491                	addi	s1,s1,4
    80002c3a:	01248b63          	beq	s1,s2,80002c50 <itrunc+0x8a>
      if(a[j])
    80002c3e:	408c                	lw	a1,0(s1)
    80002c40:	dde5                	beqz	a1,80002c38 <itrunc+0x72>
        bfree(ip->dev, a[j]);
    80002c42:	0009a503          	lw	a0,0(s3)
    80002c46:	00000097          	auipc	ra,0x0
    80002c4a:	8d2080e7          	jalr	-1838(ra) # 80002518 <bfree>
    80002c4e:	b7ed                	j	80002c38 <itrunc+0x72>
    brelse(bp);
    80002c50:	8552                	mv	a0,s4
    80002c52:	fffff097          	auipc	ra,0xfffff
    80002c56:	7b6080e7          	jalr	1974(ra) # 80002408 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002c5a:	0809a583          	lw	a1,128(s3)
    80002c5e:	0009a503          	lw	a0,0(s3)
    80002c62:	00000097          	auipc	ra,0x0
    80002c66:	8b6080e7          	jalr	-1866(ra) # 80002518 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002c6a:	0809a023          	sw	zero,128(s3)
    80002c6e:	6a02                	ld	s4,0(sp)
    80002c70:	bf49                	j	80002c02 <itrunc+0x3c>

0000000080002c72 <iput>:
{
    80002c72:	1101                	addi	sp,sp,-32
    80002c74:	ec06                	sd	ra,24(sp)
    80002c76:	e822                	sd	s0,16(sp)
    80002c78:	e426                	sd	s1,8(sp)
    80002c7a:	1000                	addi	s0,sp,32
    80002c7c:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002c7e:	00015517          	auipc	a0,0x15
    80002c82:	8fa50513          	addi	a0,a0,-1798 # 80017578 <itable>
    80002c86:	00003097          	auipc	ra,0x3
    80002c8a:	56c080e7          	jalr	1388(ra) # 800061f2 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002c8e:	4498                	lw	a4,8(s1)
    80002c90:	4785                	li	a5,1
    80002c92:	02f70263          	beq	a4,a5,80002cb6 <iput+0x44>
  ip->ref--;
    80002c96:	449c                	lw	a5,8(s1)
    80002c98:	37fd                	addiw	a5,a5,-1
    80002c9a:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002c9c:	00015517          	auipc	a0,0x15
    80002ca0:	8dc50513          	addi	a0,a0,-1828 # 80017578 <itable>
    80002ca4:	00003097          	auipc	ra,0x3
    80002ca8:	5fe080e7          	jalr	1534(ra) # 800062a2 <release>
}
    80002cac:	60e2                	ld	ra,24(sp)
    80002cae:	6442                	ld	s0,16(sp)
    80002cb0:	64a2                	ld	s1,8(sp)
    80002cb2:	6105                	addi	sp,sp,32
    80002cb4:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002cb6:	40bc                	lw	a5,64(s1)
    80002cb8:	dff9                	beqz	a5,80002c96 <iput+0x24>
    80002cba:	04a49783          	lh	a5,74(s1)
    80002cbe:	ffe1                	bnez	a5,80002c96 <iput+0x24>
    80002cc0:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80002cc2:	01048913          	addi	s2,s1,16
    80002cc6:	854a                	mv	a0,s2
    80002cc8:	00001097          	auipc	ra,0x1
    80002ccc:	ada080e7          	jalr	-1318(ra) # 800037a2 <acquiresleep>
    release(&itable.lock);
    80002cd0:	00015517          	auipc	a0,0x15
    80002cd4:	8a850513          	addi	a0,a0,-1880 # 80017578 <itable>
    80002cd8:	00003097          	auipc	ra,0x3
    80002cdc:	5ca080e7          	jalr	1482(ra) # 800062a2 <release>
    itrunc(ip);
    80002ce0:	8526                	mv	a0,s1
    80002ce2:	00000097          	auipc	ra,0x0
    80002ce6:	ee4080e7          	jalr	-284(ra) # 80002bc6 <itrunc>
    ip->type = 0;
    80002cea:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002cee:	8526                	mv	a0,s1
    80002cf0:	00000097          	auipc	ra,0x0
    80002cf4:	cf8080e7          	jalr	-776(ra) # 800029e8 <iupdate>
    ip->valid = 0;
    80002cf8:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002cfc:	854a                	mv	a0,s2
    80002cfe:	00001097          	auipc	ra,0x1
    80002d02:	afa080e7          	jalr	-1286(ra) # 800037f8 <releasesleep>
    acquire(&itable.lock);
    80002d06:	00015517          	auipc	a0,0x15
    80002d0a:	87250513          	addi	a0,a0,-1934 # 80017578 <itable>
    80002d0e:	00003097          	auipc	ra,0x3
    80002d12:	4e4080e7          	jalr	1252(ra) # 800061f2 <acquire>
    80002d16:	6902                	ld	s2,0(sp)
    80002d18:	bfbd                	j	80002c96 <iput+0x24>

0000000080002d1a <iunlockput>:
{
    80002d1a:	1101                	addi	sp,sp,-32
    80002d1c:	ec06                	sd	ra,24(sp)
    80002d1e:	e822                	sd	s0,16(sp)
    80002d20:	e426                	sd	s1,8(sp)
    80002d22:	1000                	addi	s0,sp,32
    80002d24:	84aa                	mv	s1,a0
  iunlock(ip);
    80002d26:	00000097          	auipc	ra,0x0
    80002d2a:	e54080e7          	jalr	-428(ra) # 80002b7a <iunlock>
  iput(ip);
    80002d2e:	8526                	mv	a0,s1
    80002d30:	00000097          	auipc	ra,0x0
    80002d34:	f42080e7          	jalr	-190(ra) # 80002c72 <iput>
}
    80002d38:	60e2                	ld	ra,24(sp)
    80002d3a:	6442                	ld	s0,16(sp)
    80002d3c:	64a2                	ld	s1,8(sp)
    80002d3e:	6105                	addi	sp,sp,32
    80002d40:	8082                	ret

0000000080002d42 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002d42:	1141                	addi	sp,sp,-16
    80002d44:	e406                	sd	ra,8(sp)
    80002d46:	e022                	sd	s0,0(sp)
    80002d48:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002d4a:	411c                	lw	a5,0(a0)
    80002d4c:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002d4e:	415c                	lw	a5,4(a0)
    80002d50:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002d52:	04451783          	lh	a5,68(a0)
    80002d56:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002d5a:	04a51783          	lh	a5,74(a0)
    80002d5e:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002d62:	04c56783          	lwu	a5,76(a0)
    80002d66:	e99c                	sd	a5,16(a1)
}
    80002d68:	60a2                	ld	ra,8(sp)
    80002d6a:	6402                	ld	s0,0(sp)
    80002d6c:	0141                	addi	sp,sp,16
    80002d6e:	8082                	ret

0000000080002d70 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002d70:	457c                	lw	a5,76(a0)
    80002d72:	0ed7ea63          	bltu	a5,a3,80002e66 <readi+0xf6>
{
    80002d76:	7159                	addi	sp,sp,-112
    80002d78:	f486                	sd	ra,104(sp)
    80002d7a:	f0a2                	sd	s0,96(sp)
    80002d7c:	eca6                	sd	s1,88(sp)
    80002d7e:	fc56                	sd	s5,56(sp)
    80002d80:	f85a                	sd	s6,48(sp)
    80002d82:	f45e                	sd	s7,40(sp)
    80002d84:	ec66                	sd	s9,24(sp)
    80002d86:	1880                	addi	s0,sp,112
    80002d88:	8baa                	mv	s7,a0
    80002d8a:	8cae                	mv	s9,a1
    80002d8c:	8ab2                	mv	s5,a2
    80002d8e:	84b6                	mv	s1,a3
    80002d90:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002d92:	9f35                	addw	a4,a4,a3
    return 0;
    80002d94:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002d96:	0ad76763          	bltu	a4,a3,80002e44 <readi+0xd4>
    80002d9a:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80002d9c:	00e7f463          	bgeu	a5,a4,80002da4 <readi+0x34>
    n = ip->size - off;
    80002da0:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002da4:	0a0b0f63          	beqz	s6,80002e62 <readi+0xf2>
    80002da8:	e8ca                	sd	s2,80(sp)
    80002daa:	e0d2                	sd	s4,64(sp)
    80002dac:	f062                	sd	s8,32(sp)
    80002dae:	e86a                	sd	s10,16(sp)
    80002db0:	e46e                	sd	s11,8(sp)
    80002db2:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002db4:	40000d93          	li	s11,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002db8:	5d7d                	li	s10,-1
    80002dba:	a82d                	j	80002df4 <readi+0x84>
    80002dbc:	020a1c13          	slli	s8,s4,0x20
    80002dc0:	020c5c13          	srli	s8,s8,0x20
    80002dc4:	05890613          	addi	a2,s2,88
    80002dc8:	86e2                	mv	a3,s8
    80002dca:	963e                	add	a2,a2,a5
    80002dcc:	85d6                	mv	a1,s5
    80002dce:	8566                	mv	a0,s9
    80002dd0:	fffff097          	auipc	ra,0xfffff
    80002dd4:	b36080e7          	jalr	-1226(ra) # 80001906 <either_copyout>
    80002dd8:	05a50963          	beq	a0,s10,80002e2a <readi+0xba>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002ddc:	854a                	mv	a0,s2
    80002dde:	fffff097          	auipc	ra,0xfffff
    80002de2:	62a080e7          	jalr	1578(ra) # 80002408 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002de6:	013a09bb          	addw	s3,s4,s3
    80002dea:	009a04bb          	addw	s1,s4,s1
    80002dee:	9ae2                	add	s5,s5,s8
    80002df0:	0769f363          	bgeu	s3,s6,80002e56 <readi+0xe6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002df4:	000ba903          	lw	s2,0(s7)
    80002df8:	00a4d59b          	srliw	a1,s1,0xa
    80002dfc:	855e                	mv	a0,s7
    80002dfe:	00000097          	auipc	ra,0x0
    80002e02:	8b8080e7          	jalr	-1864(ra) # 800026b6 <bmap>
    80002e06:	85aa                	mv	a1,a0
    80002e08:	854a                	mv	a0,s2
    80002e0a:	fffff097          	auipc	ra,0xfffff
    80002e0e:	4ce080e7          	jalr	1230(ra) # 800022d8 <bread>
    80002e12:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002e14:	3ff4f793          	andi	a5,s1,1023
    80002e18:	40fd873b          	subw	a4,s11,a5
    80002e1c:	413b06bb          	subw	a3,s6,s3
    80002e20:	8a3a                	mv	s4,a4
    80002e22:	f8e6fde3          	bgeu	a3,a4,80002dbc <readi+0x4c>
    80002e26:	8a36                	mv	s4,a3
    80002e28:	bf51                	j	80002dbc <readi+0x4c>
      brelse(bp);
    80002e2a:	854a                	mv	a0,s2
    80002e2c:	fffff097          	auipc	ra,0xfffff
    80002e30:	5dc080e7          	jalr	1500(ra) # 80002408 <brelse>
      tot = -1;
    80002e34:	59fd                	li	s3,-1
      break;
    80002e36:	6946                	ld	s2,80(sp)
    80002e38:	6a06                	ld	s4,64(sp)
    80002e3a:	7c02                	ld	s8,32(sp)
    80002e3c:	6d42                	ld	s10,16(sp)
    80002e3e:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80002e40:	854e                	mv	a0,s3
    80002e42:	69a6                	ld	s3,72(sp)
}
    80002e44:	70a6                	ld	ra,104(sp)
    80002e46:	7406                	ld	s0,96(sp)
    80002e48:	64e6                	ld	s1,88(sp)
    80002e4a:	7ae2                	ld	s5,56(sp)
    80002e4c:	7b42                	ld	s6,48(sp)
    80002e4e:	7ba2                	ld	s7,40(sp)
    80002e50:	6ce2                	ld	s9,24(sp)
    80002e52:	6165                	addi	sp,sp,112
    80002e54:	8082                	ret
    80002e56:	6946                	ld	s2,80(sp)
    80002e58:	6a06                	ld	s4,64(sp)
    80002e5a:	7c02                	ld	s8,32(sp)
    80002e5c:	6d42                	ld	s10,16(sp)
    80002e5e:	6da2                	ld	s11,8(sp)
    80002e60:	b7c5                	j	80002e40 <readi+0xd0>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002e62:	89da                	mv	s3,s6
    80002e64:	bff1                	j	80002e40 <readi+0xd0>
    return 0;
    80002e66:	4501                	li	a0,0
}
    80002e68:	8082                	ret

0000000080002e6a <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002e6a:	457c                	lw	a5,76(a0)
    80002e6c:	10d7e963          	bltu	a5,a3,80002f7e <writei+0x114>
{
    80002e70:	7159                	addi	sp,sp,-112
    80002e72:	f486                	sd	ra,104(sp)
    80002e74:	f0a2                	sd	s0,96(sp)
    80002e76:	e8ca                	sd	s2,80(sp)
    80002e78:	fc56                	sd	s5,56(sp)
    80002e7a:	f45e                	sd	s7,40(sp)
    80002e7c:	f062                	sd	s8,32(sp)
    80002e7e:	ec66                	sd	s9,24(sp)
    80002e80:	1880                	addi	s0,sp,112
    80002e82:	8baa                	mv	s7,a0
    80002e84:	8cae                	mv	s9,a1
    80002e86:	8ab2                	mv	s5,a2
    80002e88:	8936                	mv	s2,a3
    80002e8a:	8c3a                	mv	s8,a4
  if(off > ip->size || off + n < off)
    80002e8c:	00e687bb          	addw	a5,a3,a4
    80002e90:	0ed7e963          	bltu	a5,a3,80002f82 <writei+0x118>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002e94:	00043737          	lui	a4,0x43
    80002e98:	0ef76763          	bltu	a4,a5,80002f86 <writei+0x11c>
    80002e9c:	e0d2                	sd	s4,64(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002e9e:	0c0c0863          	beqz	s8,80002f6e <writei+0x104>
    80002ea2:	eca6                	sd	s1,88(sp)
    80002ea4:	e4ce                	sd	s3,72(sp)
    80002ea6:	f85a                	sd	s6,48(sp)
    80002ea8:	e86a                	sd	s10,16(sp)
    80002eaa:	e46e                	sd	s11,8(sp)
    80002eac:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002eae:	40000d93          	li	s11,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002eb2:	5d7d                	li	s10,-1
    80002eb4:	a091                	j	80002ef8 <writei+0x8e>
    80002eb6:	02099b13          	slli	s6,s3,0x20
    80002eba:	020b5b13          	srli	s6,s6,0x20
    80002ebe:	05848513          	addi	a0,s1,88
    80002ec2:	86da                	mv	a3,s6
    80002ec4:	8656                	mv	a2,s5
    80002ec6:	85e6                	mv	a1,s9
    80002ec8:	953e                	add	a0,a0,a5
    80002eca:	fffff097          	auipc	ra,0xfffff
    80002ece:	a92080e7          	jalr	-1390(ra) # 8000195c <either_copyin>
    80002ed2:	05a50e63          	beq	a0,s10,80002f2e <writei+0xc4>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002ed6:	8526                	mv	a0,s1
    80002ed8:	00000097          	auipc	ra,0x0
    80002edc:	7ac080e7          	jalr	1964(ra) # 80003684 <log_write>
    brelse(bp);
    80002ee0:	8526                	mv	a0,s1
    80002ee2:	fffff097          	auipc	ra,0xfffff
    80002ee6:	526080e7          	jalr	1318(ra) # 80002408 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002eea:	01498a3b          	addw	s4,s3,s4
    80002eee:	0129893b          	addw	s2,s3,s2
    80002ef2:	9ada                	add	s5,s5,s6
    80002ef4:	058a7263          	bgeu	s4,s8,80002f38 <writei+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002ef8:	000ba483          	lw	s1,0(s7)
    80002efc:	00a9559b          	srliw	a1,s2,0xa
    80002f00:	855e                	mv	a0,s7
    80002f02:	fffff097          	auipc	ra,0xfffff
    80002f06:	7b4080e7          	jalr	1972(ra) # 800026b6 <bmap>
    80002f0a:	85aa                	mv	a1,a0
    80002f0c:	8526                	mv	a0,s1
    80002f0e:	fffff097          	auipc	ra,0xfffff
    80002f12:	3ca080e7          	jalr	970(ra) # 800022d8 <bread>
    80002f16:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f18:	3ff97793          	andi	a5,s2,1023
    80002f1c:	40fd873b          	subw	a4,s11,a5
    80002f20:	414c06bb          	subw	a3,s8,s4
    80002f24:	89ba                	mv	s3,a4
    80002f26:	f8e6f8e3          	bgeu	a3,a4,80002eb6 <writei+0x4c>
    80002f2a:	89b6                	mv	s3,a3
    80002f2c:	b769                	j	80002eb6 <writei+0x4c>
      brelse(bp);
    80002f2e:	8526                	mv	a0,s1
    80002f30:	fffff097          	auipc	ra,0xfffff
    80002f34:	4d8080e7          	jalr	1240(ra) # 80002408 <brelse>
  }

  if(off > ip->size)
    80002f38:	04cba783          	lw	a5,76(s7)
    80002f3c:	0327fb63          	bgeu	a5,s2,80002f72 <writei+0x108>
    ip->size = off;
    80002f40:	052ba623          	sw	s2,76(s7)
    80002f44:	64e6                	ld	s1,88(sp)
    80002f46:	69a6                	ld	s3,72(sp)
    80002f48:	7b42                	ld	s6,48(sp)
    80002f4a:	6d42                	ld	s10,16(sp)
    80002f4c:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002f4e:	855e                	mv	a0,s7
    80002f50:	00000097          	auipc	ra,0x0
    80002f54:	a98080e7          	jalr	-1384(ra) # 800029e8 <iupdate>

  return tot;
    80002f58:	8552                	mv	a0,s4
    80002f5a:	6a06                	ld	s4,64(sp)
}
    80002f5c:	70a6                	ld	ra,104(sp)
    80002f5e:	7406                	ld	s0,96(sp)
    80002f60:	6946                	ld	s2,80(sp)
    80002f62:	7ae2                	ld	s5,56(sp)
    80002f64:	7ba2                	ld	s7,40(sp)
    80002f66:	7c02                	ld	s8,32(sp)
    80002f68:	6ce2                	ld	s9,24(sp)
    80002f6a:	6165                	addi	sp,sp,112
    80002f6c:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002f6e:	8a62                	mv	s4,s8
    80002f70:	bff9                	j	80002f4e <writei+0xe4>
    80002f72:	64e6                	ld	s1,88(sp)
    80002f74:	69a6                	ld	s3,72(sp)
    80002f76:	7b42                	ld	s6,48(sp)
    80002f78:	6d42                	ld	s10,16(sp)
    80002f7a:	6da2                	ld	s11,8(sp)
    80002f7c:	bfc9                	j	80002f4e <writei+0xe4>
    return -1;
    80002f7e:	557d                	li	a0,-1
}
    80002f80:	8082                	ret
    return -1;
    80002f82:	557d                	li	a0,-1
    80002f84:	bfe1                	j	80002f5c <writei+0xf2>
    return -1;
    80002f86:	557d                	li	a0,-1
    80002f88:	bfd1                	j	80002f5c <writei+0xf2>

0000000080002f8a <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002f8a:	1141                	addi	sp,sp,-16
    80002f8c:	e406                	sd	ra,8(sp)
    80002f8e:	e022                	sd	s0,0(sp)
    80002f90:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002f92:	4639                	li	a2,14
    80002f94:	ffffd097          	auipc	ra,0xffffd
    80002f98:	2c2080e7          	jalr	706(ra) # 80000256 <strncmp>
}
    80002f9c:	60a2                	ld	ra,8(sp)
    80002f9e:	6402                	ld	s0,0(sp)
    80002fa0:	0141                	addi	sp,sp,16
    80002fa2:	8082                	ret

0000000080002fa4 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80002fa4:	711d                	addi	sp,sp,-96
    80002fa6:	ec86                	sd	ra,88(sp)
    80002fa8:	e8a2                	sd	s0,80(sp)
    80002faa:	e4a6                	sd	s1,72(sp)
    80002fac:	e0ca                	sd	s2,64(sp)
    80002fae:	fc4e                	sd	s3,56(sp)
    80002fb0:	f852                	sd	s4,48(sp)
    80002fb2:	f456                	sd	s5,40(sp)
    80002fb4:	f05a                	sd	s6,32(sp)
    80002fb6:	ec5e                	sd	s7,24(sp)
    80002fb8:	1080                	addi	s0,sp,96
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80002fba:	04451703          	lh	a4,68(a0)
    80002fbe:	4785                	li	a5,1
    80002fc0:	00f71f63          	bne	a4,a5,80002fde <dirlookup+0x3a>
    80002fc4:	892a                	mv	s2,a0
    80002fc6:	8aae                	mv	s5,a1
    80002fc8:	8bb2                	mv	s7,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80002fca:	457c                	lw	a5,76(a0)
    80002fcc:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002fce:	fa040a13          	addi	s4,s0,-96
    80002fd2:	49c1                	li	s3,16
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
    80002fd4:	fa240b13          	addi	s6,s0,-94
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002fd8:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002fda:	e79d                	bnez	a5,80003008 <dirlookup+0x64>
    80002fdc:	a88d                	j	8000304e <dirlookup+0xaa>
    panic("dirlookup not DIR");
    80002fde:	00005517          	auipc	a0,0x5
    80002fe2:	49250513          	addi	a0,a0,1170 # 80008470 <etext+0x470>
    80002fe6:	00003097          	auipc	ra,0x3
    80002fea:	c8c080e7          	jalr	-884(ra) # 80005c72 <panic>
      panic("dirlookup read");
    80002fee:	00005517          	auipc	a0,0x5
    80002ff2:	49a50513          	addi	a0,a0,1178 # 80008488 <etext+0x488>
    80002ff6:	00003097          	auipc	ra,0x3
    80002ffa:	c7c080e7          	jalr	-900(ra) # 80005c72 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002ffe:	24c1                	addiw	s1,s1,16
    80003000:	04c92783          	lw	a5,76(s2)
    80003004:	04f4f463          	bgeu	s1,a5,8000304c <dirlookup+0xa8>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003008:	874e                	mv	a4,s3
    8000300a:	86a6                	mv	a3,s1
    8000300c:	8652                	mv	a2,s4
    8000300e:	4581                	li	a1,0
    80003010:	854a                	mv	a0,s2
    80003012:	00000097          	auipc	ra,0x0
    80003016:	d5e080e7          	jalr	-674(ra) # 80002d70 <readi>
    8000301a:	fd351ae3          	bne	a0,s3,80002fee <dirlookup+0x4a>
    if(de.inum == 0)
    8000301e:	fa045783          	lhu	a5,-96(s0)
    80003022:	dff1                	beqz	a5,80002ffe <dirlookup+0x5a>
    if(namecmp(name, de.name) == 0){
    80003024:	85da                	mv	a1,s6
    80003026:	8556                	mv	a0,s5
    80003028:	00000097          	auipc	ra,0x0
    8000302c:	f62080e7          	jalr	-158(ra) # 80002f8a <namecmp>
    80003030:	f579                	bnez	a0,80002ffe <dirlookup+0x5a>
      if(poff)
    80003032:	000b8463          	beqz	s7,8000303a <dirlookup+0x96>
        *poff = off;
    80003036:	009ba023          	sw	s1,0(s7)
      return iget(dp->dev, inum);
    8000303a:	fa045583          	lhu	a1,-96(s0)
    8000303e:	00092503          	lw	a0,0(s2)
    80003042:	fffff097          	auipc	ra,0xfffff
    80003046:	742080e7          	jalr	1858(ra) # 80002784 <iget>
    8000304a:	a011                	j	8000304e <dirlookup+0xaa>
  return 0;
    8000304c:	4501                	li	a0,0
}
    8000304e:	60e6                	ld	ra,88(sp)
    80003050:	6446                	ld	s0,80(sp)
    80003052:	64a6                	ld	s1,72(sp)
    80003054:	6906                	ld	s2,64(sp)
    80003056:	79e2                	ld	s3,56(sp)
    80003058:	7a42                	ld	s4,48(sp)
    8000305a:	7aa2                	ld	s5,40(sp)
    8000305c:	7b02                	ld	s6,32(sp)
    8000305e:	6be2                	ld	s7,24(sp)
    80003060:	6125                	addi	sp,sp,96
    80003062:	8082                	ret

0000000080003064 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003064:	711d                	addi	sp,sp,-96
    80003066:	ec86                	sd	ra,88(sp)
    80003068:	e8a2                	sd	s0,80(sp)
    8000306a:	e4a6                	sd	s1,72(sp)
    8000306c:	e0ca                	sd	s2,64(sp)
    8000306e:	fc4e                	sd	s3,56(sp)
    80003070:	f852                	sd	s4,48(sp)
    80003072:	f456                	sd	s5,40(sp)
    80003074:	f05a                	sd	s6,32(sp)
    80003076:	ec5e                	sd	s7,24(sp)
    80003078:	e862                	sd	s8,16(sp)
    8000307a:	e466                	sd	s9,8(sp)
    8000307c:	e06a                	sd	s10,0(sp)
    8000307e:	1080                	addi	s0,sp,96
    80003080:	84aa                	mv	s1,a0
    80003082:	8b2e                	mv	s6,a1
    80003084:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003086:	00054703          	lbu	a4,0(a0)
    8000308a:	02f00793          	li	a5,47
    8000308e:	02f70363          	beq	a4,a5,800030b4 <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003092:	ffffe097          	auipc	ra,0xffffe
    80003096:	e10080e7          	jalr	-496(ra) # 80000ea2 <myproc>
    8000309a:	15053503          	ld	a0,336(a0)
    8000309e:	00000097          	auipc	ra,0x0
    800030a2:	9d8080e7          	jalr	-1576(ra) # 80002a76 <idup>
    800030a6:	8a2a                	mv	s4,a0
  while(*path == '/')
    800030a8:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    800030ac:	4c35                	li	s8,13
    memmove(name, s, DIRSIZ);
    800030ae:	4cb9                	li	s9,14

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800030b0:	4b85                	li	s7,1
    800030b2:	a87d                	j	80003170 <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    800030b4:	4585                	li	a1,1
    800030b6:	852e                	mv	a0,a1
    800030b8:	fffff097          	auipc	ra,0xfffff
    800030bc:	6cc080e7          	jalr	1740(ra) # 80002784 <iget>
    800030c0:	8a2a                	mv	s4,a0
    800030c2:	b7dd                	j	800030a8 <namex+0x44>
      iunlockput(ip);
    800030c4:	8552                	mv	a0,s4
    800030c6:	00000097          	auipc	ra,0x0
    800030ca:	c54080e7          	jalr	-940(ra) # 80002d1a <iunlockput>
      return 0;
    800030ce:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800030d0:	8552                	mv	a0,s4
    800030d2:	60e6                	ld	ra,88(sp)
    800030d4:	6446                	ld	s0,80(sp)
    800030d6:	64a6                	ld	s1,72(sp)
    800030d8:	6906                	ld	s2,64(sp)
    800030da:	79e2                	ld	s3,56(sp)
    800030dc:	7a42                	ld	s4,48(sp)
    800030de:	7aa2                	ld	s5,40(sp)
    800030e0:	7b02                	ld	s6,32(sp)
    800030e2:	6be2                	ld	s7,24(sp)
    800030e4:	6c42                	ld	s8,16(sp)
    800030e6:	6ca2                	ld	s9,8(sp)
    800030e8:	6d02                	ld	s10,0(sp)
    800030ea:	6125                	addi	sp,sp,96
    800030ec:	8082                	ret
      iunlock(ip);
    800030ee:	8552                	mv	a0,s4
    800030f0:	00000097          	auipc	ra,0x0
    800030f4:	a8a080e7          	jalr	-1398(ra) # 80002b7a <iunlock>
      return ip;
    800030f8:	bfe1                	j	800030d0 <namex+0x6c>
      iunlockput(ip);
    800030fa:	8552                	mv	a0,s4
    800030fc:	00000097          	auipc	ra,0x0
    80003100:	c1e080e7          	jalr	-994(ra) # 80002d1a <iunlockput>
      return 0;
    80003104:	8a4e                	mv	s4,s3
    80003106:	b7e9                	j	800030d0 <namex+0x6c>
  len = path - s;
    80003108:	40998633          	sub	a2,s3,s1
    8000310c:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    80003110:	09ac5863          	bge	s8,s10,800031a0 <namex+0x13c>
    memmove(name, s, DIRSIZ);
    80003114:	8666                	mv	a2,s9
    80003116:	85a6                	mv	a1,s1
    80003118:	8556                	mv	a0,s5
    8000311a:	ffffd097          	auipc	ra,0xffffd
    8000311e:	0c4080e7          	jalr	196(ra) # 800001de <memmove>
    80003122:	84ce                	mv	s1,s3
  while(*path == '/')
    80003124:	0004c783          	lbu	a5,0(s1)
    80003128:	01279763          	bne	a5,s2,80003136 <namex+0xd2>
    path++;
    8000312c:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000312e:	0004c783          	lbu	a5,0(s1)
    80003132:	ff278de3          	beq	a5,s2,8000312c <namex+0xc8>
    ilock(ip);
    80003136:	8552                	mv	a0,s4
    80003138:	00000097          	auipc	ra,0x0
    8000313c:	97c080e7          	jalr	-1668(ra) # 80002ab4 <ilock>
    if(ip->type != T_DIR){
    80003140:	044a1783          	lh	a5,68(s4)
    80003144:	f97790e3          	bne	a5,s7,800030c4 <namex+0x60>
    if(nameiparent && *path == '\0'){
    80003148:	000b0563          	beqz	s6,80003152 <namex+0xee>
    8000314c:	0004c783          	lbu	a5,0(s1)
    80003150:	dfd9                	beqz	a5,800030ee <namex+0x8a>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003152:	4601                	li	a2,0
    80003154:	85d6                	mv	a1,s5
    80003156:	8552                	mv	a0,s4
    80003158:	00000097          	auipc	ra,0x0
    8000315c:	e4c080e7          	jalr	-436(ra) # 80002fa4 <dirlookup>
    80003160:	89aa                	mv	s3,a0
    80003162:	dd41                	beqz	a0,800030fa <namex+0x96>
    iunlockput(ip);
    80003164:	8552                	mv	a0,s4
    80003166:	00000097          	auipc	ra,0x0
    8000316a:	bb4080e7          	jalr	-1100(ra) # 80002d1a <iunlockput>
    ip = next;
    8000316e:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003170:	0004c783          	lbu	a5,0(s1)
    80003174:	01279763          	bne	a5,s2,80003182 <namex+0x11e>
    path++;
    80003178:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000317a:	0004c783          	lbu	a5,0(s1)
    8000317e:	ff278de3          	beq	a5,s2,80003178 <namex+0x114>
  if(*path == 0)
    80003182:	cb9d                	beqz	a5,800031b8 <namex+0x154>
  while(*path != '/' && *path != 0)
    80003184:	0004c783          	lbu	a5,0(s1)
    80003188:	89a6                	mv	s3,s1
  len = path - s;
    8000318a:	4d01                	li	s10,0
    8000318c:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    8000318e:	01278963          	beq	a5,s2,800031a0 <namex+0x13c>
    80003192:	dbbd                	beqz	a5,80003108 <namex+0xa4>
    path++;
    80003194:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80003196:	0009c783          	lbu	a5,0(s3)
    8000319a:	ff279ce3          	bne	a5,s2,80003192 <namex+0x12e>
    8000319e:	b7ad                	j	80003108 <namex+0xa4>
    memmove(name, s, len);
    800031a0:	2601                	sext.w	a2,a2
    800031a2:	85a6                	mv	a1,s1
    800031a4:	8556                	mv	a0,s5
    800031a6:	ffffd097          	auipc	ra,0xffffd
    800031aa:	038080e7          	jalr	56(ra) # 800001de <memmove>
    name[len] = 0;
    800031ae:	9d56                	add	s10,s10,s5
    800031b0:	000d0023          	sb	zero,0(s10)
    800031b4:	84ce                	mv	s1,s3
    800031b6:	b7bd                	j	80003124 <namex+0xc0>
  if(nameiparent){
    800031b8:	f00b0ce3          	beqz	s6,800030d0 <namex+0x6c>
    iput(ip);
    800031bc:	8552                	mv	a0,s4
    800031be:	00000097          	auipc	ra,0x0
    800031c2:	ab4080e7          	jalr	-1356(ra) # 80002c72 <iput>
    return 0;
    800031c6:	4a01                	li	s4,0
    800031c8:	b721                	j	800030d0 <namex+0x6c>

00000000800031ca <dirlink>:
{
    800031ca:	715d                	addi	sp,sp,-80
    800031cc:	e486                	sd	ra,72(sp)
    800031ce:	e0a2                	sd	s0,64(sp)
    800031d0:	f84a                	sd	s2,48(sp)
    800031d2:	ec56                	sd	s5,24(sp)
    800031d4:	e85a                	sd	s6,16(sp)
    800031d6:	0880                	addi	s0,sp,80
    800031d8:	892a                	mv	s2,a0
    800031da:	8aae                	mv	s5,a1
    800031dc:	8b32                	mv	s6,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800031de:	4601                	li	a2,0
    800031e0:	00000097          	auipc	ra,0x0
    800031e4:	dc4080e7          	jalr	-572(ra) # 80002fa4 <dirlookup>
    800031e8:	e129                	bnez	a0,8000322a <dirlink+0x60>
    800031ea:	fc26                	sd	s1,56(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    800031ec:	04c92483          	lw	s1,76(s2)
    800031f0:	cca9                	beqz	s1,8000324a <dirlink+0x80>
    800031f2:	f44e                	sd	s3,40(sp)
    800031f4:	f052                	sd	s4,32(sp)
    800031f6:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800031f8:	fb040a13          	addi	s4,s0,-80
    800031fc:	49c1                	li	s3,16
    800031fe:	874e                	mv	a4,s3
    80003200:	86a6                	mv	a3,s1
    80003202:	8652                	mv	a2,s4
    80003204:	4581                	li	a1,0
    80003206:	854a                	mv	a0,s2
    80003208:	00000097          	auipc	ra,0x0
    8000320c:	b68080e7          	jalr	-1176(ra) # 80002d70 <readi>
    80003210:	03351363          	bne	a0,s3,80003236 <dirlink+0x6c>
    if(de.inum == 0)
    80003214:	fb045783          	lhu	a5,-80(s0)
    80003218:	c79d                	beqz	a5,80003246 <dirlink+0x7c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000321a:	24c1                	addiw	s1,s1,16
    8000321c:	04c92783          	lw	a5,76(s2)
    80003220:	fcf4efe3          	bltu	s1,a5,800031fe <dirlink+0x34>
    80003224:	79a2                	ld	s3,40(sp)
    80003226:	7a02                	ld	s4,32(sp)
    80003228:	a00d                	j	8000324a <dirlink+0x80>
    iput(ip);
    8000322a:	00000097          	auipc	ra,0x0
    8000322e:	a48080e7          	jalr	-1464(ra) # 80002c72 <iput>
    return -1;
    80003232:	557d                	li	a0,-1
    80003234:	a0a9                	j	8000327e <dirlink+0xb4>
      panic("dirlink read");
    80003236:	00005517          	auipc	a0,0x5
    8000323a:	26250513          	addi	a0,a0,610 # 80008498 <etext+0x498>
    8000323e:	00003097          	auipc	ra,0x3
    80003242:	a34080e7          	jalr	-1484(ra) # 80005c72 <panic>
    80003246:	79a2                	ld	s3,40(sp)
    80003248:	7a02                	ld	s4,32(sp)
  strncpy(de.name, name, DIRSIZ);
    8000324a:	4639                	li	a2,14
    8000324c:	85d6                	mv	a1,s5
    8000324e:	fb240513          	addi	a0,s0,-78
    80003252:	ffffd097          	auipc	ra,0xffffd
    80003256:	03e080e7          	jalr	62(ra) # 80000290 <strncpy>
  de.inum = inum;
    8000325a:	fb641823          	sh	s6,-80(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000325e:	4741                	li	a4,16
    80003260:	86a6                	mv	a3,s1
    80003262:	fb040613          	addi	a2,s0,-80
    80003266:	4581                	li	a1,0
    80003268:	854a                	mv	a0,s2
    8000326a:	00000097          	auipc	ra,0x0
    8000326e:	c00080e7          	jalr	-1024(ra) # 80002e6a <writei>
    80003272:	872a                	mv	a4,a0
    80003274:	47c1                	li	a5,16
  return 0;
    80003276:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003278:	00f71a63          	bne	a4,a5,8000328c <dirlink+0xc2>
    8000327c:	74e2                	ld	s1,56(sp)
}
    8000327e:	60a6                	ld	ra,72(sp)
    80003280:	6406                	ld	s0,64(sp)
    80003282:	7942                	ld	s2,48(sp)
    80003284:	6ae2                	ld	s5,24(sp)
    80003286:	6b42                	ld	s6,16(sp)
    80003288:	6161                	addi	sp,sp,80
    8000328a:	8082                	ret
    8000328c:	f44e                	sd	s3,40(sp)
    8000328e:	f052                	sd	s4,32(sp)
    panic("dirlink");
    80003290:	00005517          	auipc	a0,0x5
    80003294:	31850513          	addi	a0,a0,792 # 800085a8 <etext+0x5a8>
    80003298:	00003097          	auipc	ra,0x3
    8000329c:	9da080e7          	jalr	-1574(ra) # 80005c72 <panic>

00000000800032a0 <namei>:

struct inode*
namei(char *path)
{
    800032a0:	1101                	addi	sp,sp,-32
    800032a2:	ec06                	sd	ra,24(sp)
    800032a4:	e822                	sd	s0,16(sp)
    800032a6:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800032a8:	fe040613          	addi	a2,s0,-32
    800032ac:	4581                	li	a1,0
    800032ae:	00000097          	auipc	ra,0x0
    800032b2:	db6080e7          	jalr	-586(ra) # 80003064 <namex>
}
    800032b6:	60e2                	ld	ra,24(sp)
    800032b8:	6442                	ld	s0,16(sp)
    800032ba:	6105                	addi	sp,sp,32
    800032bc:	8082                	ret

00000000800032be <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800032be:	1141                	addi	sp,sp,-16
    800032c0:	e406                	sd	ra,8(sp)
    800032c2:	e022                	sd	s0,0(sp)
    800032c4:	0800                	addi	s0,sp,16
    800032c6:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800032c8:	4585                	li	a1,1
    800032ca:	00000097          	auipc	ra,0x0
    800032ce:	d9a080e7          	jalr	-614(ra) # 80003064 <namex>
}
    800032d2:	60a2                	ld	ra,8(sp)
    800032d4:	6402                	ld	s0,0(sp)
    800032d6:	0141                	addi	sp,sp,16
    800032d8:	8082                	ret

00000000800032da <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800032da:	1101                	addi	sp,sp,-32
    800032dc:	ec06                	sd	ra,24(sp)
    800032de:	e822                	sd	s0,16(sp)
    800032e0:	e426                	sd	s1,8(sp)
    800032e2:	e04a                	sd	s2,0(sp)
    800032e4:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800032e6:	00016917          	auipc	s2,0x16
    800032ea:	d3a90913          	addi	s2,s2,-710 # 80019020 <log>
    800032ee:	01892583          	lw	a1,24(s2)
    800032f2:	02892503          	lw	a0,40(s2)
    800032f6:	fffff097          	auipc	ra,0xfffff
    800032fa:	fe2080e7          	jalr	-30(ra) # 800022d8 <bread>
    800032fe:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003300:	02c92603          	lw	a2,44(s2)
    80003304:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003306:	00c05f63          	blez	a2,80003324 <write_head+0x4a>
    8000330a:	00016717          	auipc	a4,0x16
    8000330e:	d4670713          	addi	a4,a4,-698 # 80019050 <log+0x30>
    80003312:	87aa                	mv	a5,a0
    80003314:	060a                	slli	a2,a2,0x2
    80003316:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003318:	4314                	lw	a3,0(a4)
    8000331a:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    8000331c:	0711                	addi	a4,a4,4
    8000331e:	0791                	addi	a5,a5,4
    80003320:	fec79ce3          	bne	a5,a2,80003318 <write_head+0x3e>
  }
  bwrite(buf);
    80003324:	8526                	mv	a0,s1
    80003326:	fffff097          	auipc	ra,0xfffff
    8000332a:	0a4080e7          	jalr	164(ra) # 800023ca <bwrite>
  brelse(buf);
    8000332e:	8526                	mv	a0,s1
    80003330:	fffff097          	auipc	ra,0xfffff
    80003334:	0d8080e7          	jalr	216(ra) # 80002408 <brelse>
}
    80003338:	60e2                	ld	ra,24(sp)
    8000333a:	6442                	ld	s0,16(sp)
    8000333c:	64a2                	ld	s1,8(sp)
    8000333e:	6902                	ld	s2,0(sp)
    80003340:	6105                	addi	sp,sp,32
    80003342:	8082                	ret

0000000080003344 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003344:	00016797          	auipc	a5,0x16
    80003348:	d087a783          	lw	a5,-760(a5) # 8001904c <log+0x2c>
    8000334c:	0cf05063          	blez	a5,8000340c <install_trans+0xc8>
{
    80003350:	715d                	addi	sp,sp,-80
    80003352:	e486                	sd	ra,72(sp)
    80003354:	e0a2                	sd	s0,64(sp)
    80003356:	fc26                	sd	s1,56(sp)
    80003358:	f84a                	sd	s2,48(sp)
    8000335a:	f44e                	sd	s3,40(sp)
    8000335c:	f052                	sd	s4,32(sp)
    8000335e:	ec56                	sd	s5,24(sp)
    80003360:	e85a                	sd	s6,16(sp)
    80003362:	e45e                	sd	s7,8(sp)
    80003364:	0880                	addi	s0,sp,80
    80003366:	8b2a                	mv	s6,a0
    80003368:	00016a97          	auipc	s5,0x16
    8000336c:	ce8a8a93          	addi	s5,s5,-792 # 80019050 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003370:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003372:	00016997          	auipc	s3,0x16
    80003376:	cae98993          	addi	s3,s3,-850 # 80019020 <log>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000337a:	40000b93          	li	s7,1024
    8000337e:	a00d                	j	800033a0 <install_trans+0x5c>
    brelse(lbuf);
    80003380:	854a                	mv	a0,s2
    80003382:	fffff097          	auipc	ra,0xfffff
    80003386:	086080e7          	jalr	134(ra) # 80002408 <brelse>
    brelse(dbuf);
    8000338a:	8526                	mv	a0,s1
    8000338c:	fffff097          	auipc	ra,0xfffff
    80003390:	07c080e7          	jalr	124(ra) # 80002408 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003394:	2a05                	addiw	s4,s4,1
    80003396:	0a91                	addi	s5,s5,4
    80003398:	02c9a783          	lw	a5,44(s3)
    8000339c:	04fa5d63          	bge	s4,a5,800033f6 <install_trans+0xb2>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800033a0:	0189a583          	lw	a1,24(s3)
    800033a4:	014585bb          	addw	a1,a1,s4
    800033a8:	2585                	addiw	a1,a1,1
    800033aa:	0289a503          	lw	a0,40(s3)
    800033ae:	fffff097          	auipc	ra,0xfffff
    800033b2:	f2a080e7          	jalr	-214(ra) # 800022d8 <bread>
    800033b6:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800033b8:	000aa583          	lw	a1,0(s5)
    800033bc:	0289a503          	lw	a0,40(s3)
    800033c0:	fffff097          	auipc	ra,0xfffff
    800033c4:	f18080e7          	jalr	-232(ra) # 800022d8 <bread>
    800033c8:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800033ca:	865e                	mv	a2,s7
    800033cc:	05890593          	addi	a1,s2,88
    800033d0:	05850513          	addi	a0,a0,88
    800033d4:	ffffd097          	auipc	ra,0xffffd
    800033d8:	e0a080e7          	jalr	-502(ra) # 800001de <memmove>
    bwrite(dbuf);  // write dst to disk
    800033dc:	8526                	mv	a0,s1
    800033de:	fffff097          	auipc	ra,0xfffff
    800033e2:	fec080e7          	jalr	-20(ra) # 800023ca <bwrite>
    if(recovering == 0)
    800033e6:	f80b1de3          	bnez	s6,80003380 <install_trans+0x3c>
      bunpin(dbuf);
    800033ea:	8526                	mv	a0,s1
    800033ec:	fffff097          	auipc	ra,0xfffff
    800033f0:	0f0080e7          	jalr	240(ra) # 800024dc <bunpin>
    800033f4:	b771                	j	80003380 <install_trans+0x3c>
}
    800033f6:	60a6                	ld	ra,72(sp)
    800033f8:	6406                	ld	s0,64(sp)
    800033fa:	74e2                	ld	s1,56(sp)
    800033fc:	7942                	ld	s2,48(sp)
    800033fe:	79a2                	ld	s3,40(sp)
    80003400:	7a02                	ld	s4,32(sp)
    80003402:	6ae2                	ld	s5,24(sp)
    80003404:	6b42                	ld	s6,16(sp)
    80003406:	6ba2                	ld	s7,8(sp)
    80003408:	6161                	addi	sp,sp,80
    8000340a:	8082                	ret
    8000340c:	8082                	ret

000000008000340e <initlog>:
{
    8000340e:	7179                	addi	sp,sp,-48
    80003410:	f406                	sd	ra,40(sp)
    80003412:	f022                	sd	s0,32(sp)
    80003414:	ec26                	sd	s1,24(sp)
    80003416:	e84a                	sd	s2,16(sp)
    80003418:	e44e                	sd	s3,8(sp)
    8000341a:	1800                	addi	s0,sp,48
    8000341c:	892a                	mv	s2,a0
    8000341e:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003420:	00016497          	auipc	s1,0x16
    80003424:	c0048493          	addi	s1,s1,-1024 # 80019020 <log>
    80003428:	00005597          	auipc	a1,0x5
    8000342c:	08058593          	addi	a1,a1,128 # 800084a8 <etext+0x4a8>
    80003430:	8526                	mv	a0,s1
    80003432:	00003097          	auipc	ra,0x3
    80003436:	d2c080e7          	jalr	-724(ra) # 8000615e <initlock>
  log.start = sb->logstart;
    8000343a:	0149a583          	lw	a1,20(s3)
    8000343e:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003440:	0109a783          	lw	a5,16(s3)
    80003444:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003446:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000344a:	854a                	mv	a0,s2
    8000344c:	fffff097          	auipc	ra,0xfffff
    80003450:	e8c080e7          	jalr	-372(ra) # 800022d8 <bread>
  log.lh.n = lh->n;
    80003454:	4d30                	lw	a2,88(a0)
    80003456:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003458:	00c05f63          	blez	a2,80003476 <initlog+0x68>
    8000345c:	87aa                	mv	a5,a0
    8000345e:	00016717          	auipc	a4,0x16
    80003462:	bf270713          	addi	a4,a4,-1038 # 80019050 <log+0x30>
    80003466:	060a                	slli	a2,a2,0x2
    80003468:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    8000346a:	4ff4                	lw	a3,92(a5)
    8000346c:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000346e:	0791                	addi	a5,a5,4
    80003470:	0711                	addi	a4,a4,4
    80003472:	fec79ce3          	bne	a5,a2,8000346a <initlog+0x5c>
  brelse(buf);
    80003476:	fffff097          	auipc	ra,0xfffff
    8000347a:	f92080e7          	jalr	-110(ra) # 80002408 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    8000347e:	4505                	li	a0,1
    80003480:	00000097          	auipc	ra,0x0
    80003484:	ec4080e7          	jalr	-316(ra) # 80003344 <install_trans>
  log.lh.n = 0;
    80003488:	00016797          	auipc	a5,0x16
    8000348c:	bc07a223          	sw	zero,-1084(a5) # 8001904c <log+0x2c>
  write_head(); // clear the log
    80003490:	00000097          	auipc	ra,0x0
    80003494:	e4a080e7          	jalr	-438(ra) # 800032da <write_head>
}
    80003498:	70a2                	ld	ra,40(sp)
    8000349a:	7402                	ld	s0,32(sp)
    8000349c:	64e2                	ld	s1,24(sp)
    8000349e:	6942                	ld	s2,16(sp)
    800034a0:	69a2                	ld	s3,8(sp)
    800034a2:	6145                	addi	sp,sp,48
    800034a4:	8082                	ret

00000000800034a6 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800034a6:	1101                	addi	sp,sp,-32
    800034a8:	ec06                	sd	ra,24(sp)
    800034aa:	e822                	sd	s0,16(sp)
    800034ac:	e426                	sd	s1,8(sp)
    800034ae:	e04a                	sd	s2,0(sp)
    800034b0:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800034b2:	00016517          	auipc	a0,0x16
    800034b6:	b6e50513          	addi	a0,a0,-1170 # 80019020 <log>
    800034ba:	00003097          	auipc	ra,0x3
    800034be:	d38080e7          	jalr	-712(ra) # 800061f2 <acquire>
  while(1){
    if(log.committing){
    800034c2:	00016497          	auipc	s1,0x16
    800034c6:	b5e48493          	addi	s1,s1,-1186 # 80019020 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800034ca:	4979                	li	s2,30
    800034cc:	a039                	j	800034da <begin_op+0x34>
      sleep(&log, &log.lock);
    800034ce:	85a6                	mv	a1,s1
    800034d0:	8526                	mv	a0,s1
    800034d2:	ffffe097          	auipc	ra,0xffffe
    800034d6:	096080e7          	jalr	150(ra) # 80001568 <sleep>
    if(log.committing){
    800034da:	50dc                	lw	a5,36(s1)
    800034dc:	fbed                	bnez	a5,800034ce <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800034de:	5098                	lw	a4,32(s1)
    800034e0:	2705                	addiw	a4,a4,1
    800034e2:	0027179b          	slliw	a5,a4,0x2
    800034e6:	9fb9                	addw	a5,a5,a4
    800034e8:	0017979b          	slliw	a5,a5,0x1
    800034ec:	54d4                	lw	a3,44(s1)
    800034ee:	9fb5                	addw	a5,a5,a3
    800034f0:	00f95963          	bge	s2,a5,80003502 <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800034f4:	85a6                	mv	a1,s1
    800034f6:	8526                	mv	a0,s1
    800034f8:	ffffe097          	auipc	ra,0xffffe
    800034fc:	070080e7          	jalr	112(ra) # 80001568 <sleep>
    80003500:	bfe9                	j	800034da <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003502:	00016517          	auipc	a0,0x16
    80003506:	b1e50513          	addi	a0,a0,-1250 # 80019020 <log>
    8000350a:	d118                	sw	a4,32(a0)
      release(&log.lock);
    8000350c:	00003097          	auipc	ra,0x3
    80003510:	d96080e7          	jalr	-618(ra) # 800062a2 <release>
      break;
    }
  }
}
    80003514:	60e2                	ld	ra,24(sp)
    80003516:	6442                	ld	s0,16(sp)
    80003518:	64a2                	ld	s1,8(sp)
    8000351a:	6902                	ld	s2,0(sp)
    8000351c:	6105                	addi	sp,sp,32
    8000351e:	8082                	ret

0000000080003520 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003520:	7139                	addi	sp,sp,-64
    80003522:	fc06                	sd	ra,56(sp)
    80003524:	f822                	sd	s0,48(sp)
    80003526:	f426                	sd	s1,40(sp)
    80003528:	f04a                	sd	s2,32(sp)
    8000352a:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000352c:	00016497          	auipc	s1,0x16
    80003530:	af448493          	addi	s1,s1,-1292 # 80019020 <log>
    80003534:	8526                	mv	a0,s1
    80003536:	00003097          	auipc	ra,0x3
    8000353a:	cbc080e7          	jalr	-836(ra) # 800061f2 <acquire>
  log.outstanding -= 1;
    8000353e:	509c                	lw	a5,32(s1)
    80003540:	37fd                	addiw	a5,a5,-1
    80003542:	893e                	mv	s2,a5
    80003544:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003546:	50dc                	lw	a5,36(s1)
    80003548:	e7b9                	bnez	a5,80003596 <end_op+0x76>
    panic("log.committing");
  if(log.outstanding == 0){
    8000354a:	06091263          	bnez	s2,800035ae <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    8000354e:	00016497          	auipc	s1,0x16
    80003552:	ad248493          	addi	s1,s1,-1326 # 80019020 <log>
    80003556:	4785                	li	a5,1
    80003558:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000355a:	8526                	mv	a0,s1
    8000355c:	00003097          	auipc	ra,0x3
    80003560:	d46080e7          	jalr	-698(ra) # 800062a2 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003564:	54dc                	lw	a5,44(s1)
    80003566:	06f04863          	bgtz	a5,800035d6 <end_op+0xb6>
    acquire(&log.lock);
    8000356a:	00016497          	auipc	s1,0x16
    8000356e:	ab648493          	addi	s1,s1,-1354 # 80019020 <log>
    80003572:	8526                	mv	a0,s1
    80003574:	00003097          	auipc	ra,0x3
    80003578:	c7e080e7          	jalr	-898(ra) # 800061f2 <acquire>
    log.committing = 0;
    8000357c:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003580:	8526                	mv	a0,s1
    80003582:	ffffe097          	auipc	ra,0xffffe
    80003586:	16c080e7          	jalr	364(ra) # 800016ee <wakeup>
    release(&log.lock);
    8000358a:	8526                	mv	a0,s1
    8000358c:	00003097          	auipc	ra,0x3
    80003590:	d16080e7          	jalr	-746(ra) # 800062a2 <release>
}
    80003594:	a81d                	j	800035ca <end_op+0xaa>
    80003596:	ec4e                	sd	s3,24(sp)
    80003598:	e852                	sd	s4,16(sp)
    8000359a:	e456                	sd	s5,8(sp)
    8000359c:	e05a                	sd	s6,0(sp)
    panic("log.committing");
    8000359e:	00005517          	auipc	a0,0x5
    800035a2:	f1250513          	addi	a0,a0,-238 # 800084b0 <etext+0x4b0>
    800035a6:	00002097          	auipc	ra,0x2
    800035aa:	6cc080e7          	jalr	1740(ra) # 80005c72 <panic>
    wakeup(&log);
    800035ae:	00016497          	auipc	s1,0x16
    800035b2:	a7248493          	addi	s1,s1,-1422 # 80019020 <log>
    800035b6:	8526                	mv	a0,s1
    800035b8:	ffffe097          	auipc	ra,0xffffe
    800035bc:	136080e7          	jalr	310(ra) # 800016ee <wakeup>
  release(&log.lock);
    800035c0:	8526                	mv	a0,s1
    800035c2:	00003097          	auipc	ra,0x3
    800035c6:	ce0080e7          	jalr	-800(ra) # 800062a2 <release>
}
    800035ca:	70e2                	ld	ra,56(sp)
    800035cc:	7442                	ld	s0,48(sp)
    800035ce:	74a2                	ld	s1,40(sp)
    800035d0:	7902                	ld	s2,32(sp)
    800035d2:	6121                	addi	sp,sp,64
    800035d4:	8082                	ret
    800035d6:	ec4e                	sd	s3,24(sp)
    800035d8:	e852                	sd	s4,16(sp)
    800035da:	e456                	sd	s5,8(sp)
    800035dc:	e05a                	sd	s6,0(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    800035de:	00016a97          	auipc	s5,0x16
    800035e2:	a72a8a93          	addi	s5,s5,-1422 # 80019050 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800035e6:	00016a17          	auipc	s4,0x16
    800035ea:	a3aa0a13          	addi	s4,s4,-1478 # 80019020 <log>
    memmove(to->data, from->data, BSIZE);
    800035ee:	40000b13          	li	s6,1024
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800035f2:	018a2583          	lw	a1,24(s4)
    800035f6:	012585bb          	addw	a1,a1,s2
    800035fa:	2585                	addiw	a1,a1,1
    800035fc:	028a2503          	lw	a0,40(s4)
    80003600:	fffff097          	auipc	ra,0xfffff
    80003604:	cd8080e7          	jalr	-808(ra) # 800022d8 <bread>
    80003608:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000360a:	000aa583          	lw	a1,0(s5)
    8000360e:	028a2503          	lw	a0,40(s4)
    80003612:	fffff097          	auipc	ra,0xfffff
    80003616:	cc6080e7          	jalr	-826(ra) # 800022d8 <bread>
    8000361a:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000361c:	865a                	mv	a2,s6
    8000361e:	05850593          	addi	a1,a0,88
    80003622:	05848513          	addi	a0,s1,88
    80003626:	ffffd097          	auipc	ra,0xffffd
    8000362a:	bb8080e7          	jalr	-1096(ra) # 800001de <memmove>
    bwrite(to);  // write the log
    8000362e:	8526                	mv	a0,s1
    80003630:	fffff097          	auipc	ra,0xfffff
    80003634:	d9a080e7          	jalr	-614(ra) # 800023ca <bwrite>
    brelse(from);
    80003638:	854e                	mv	a0,s3
    8000363a:	fffff097          	auipc	ra,0xfffff
    8000363e:	dce080e7          	jalr	-562(ra) # 80002408 <brelse>
    brelse(to);
    80003642:	8526                	mv	a0,s1
    80003644:	fffff097          	auipc	ra,0xfffff
    80003648:	dc4080e7          	jalr	-572(ra) # 80002408 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000364c:	2905                	addiw	s2,s2,1
    8000364e:	0a91                	addi	s5,s5,4
    80003650:	02ca2783          	lw	a5,44(s4)
    80003654:	f8f94fe3          	blt	s2,a5,800035f2 <end_op+0xd2>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003658:	00000097          	auipc	ra,0x0
    8000365c:	c82080e7          	jalr	-894(ra) # 800032da <write_head>
    install_trans(0); // Now install writes to home locations
    80003660:	4501                	li	a0,0
    80003662:	00000097          	auipc	ra,0x0
    80003666:	ce2080e7          	jalr	-798(ra) # 80003344 <install_trans>
    log.lh.n = 0;
    8000366a:	00016797          	auipc	a5,0x16
    8000366e:	9e07a123          	sw	zero,-1566(a5) # 8001904c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003672:	00000097          	auipc	ra,0x0
    80003676:	c68080e7          	jalr	-920(ra) # 800032da <write_head>
    8000367a:	69e2                	ld	s3,24(sp)
    8000367c:	6a42                	ld	s4,16(sp)
    8000367e:	6aa2                	ld	s5,8(sp)
    80003680:	6b02                	ld	s6,0(sp)
    80003682:	b5e5                	j	8000356a <end_op+0x4a>

0000000080003684 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003684:	1101                	addi	sp,sp,-32
    80003686:	ec06                	sd	ra,24(sp)
    80003688:	e822                	sd	s0,16(sp)
    8000368a:	e426                	sd	s1,8(sp)
    8000368c:	e04a                	sd	s2,0(sp)
    8000368e:	1000                	addi	s0,sp,32
    80003690:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003692:	00016917          	auipc	s2,0x16
    80003696:	98e90913          	addi	s2,s2,-1650 # 80019020 <log>
    8000369a:	854a                	mv	a0,s2
    8000369c:	00003097          	auipc	ra,0x3
    800036a0:	b56080e7          	jalr	-1194(ra) # 800061f2 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800036a4:	02c92603          	lw	a2,44(s2)
    800036a8:	47f5                	li	a5,29
    800036aa:	06c7c563          	blt	a5,a2,80003714 <log_write+0x90>
    800036ae:	00016797          	auipc	a5,0x16
    800036b2:	98e7a783          	lw	a5,-1650(a5) # 8001903c <log+0x1c>
    800036b6:	37fd                	addiw	a5,a5,-1
    800036b8:	04f65e63          	bge	a2,a5,80003714 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800036bc:	00016797          	auipc	a5,0x16
    800036c0:	9847a783          	lw	a5,-1660(a5) # 80019040 <log+0x20>
    800036c4:	06f05063          	blez	a5,80003724 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800036c8:	4781                	li	a5,0
    800036ca:	06c05563          	blez	a2,80003734 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800036ce:	44cc                	lw	a1,12(s1)
    800036d0:	00016717          	auipc	a4,0x16
    800036d4:	98070713          	addi	a4,a4,-1664 # 80019050 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800036d8:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800036da:	4314                	lw	a3,0(a4)
    800036dc:	04b68c63          	beq	a3,a1,80003734 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800036e0:	2785                	addiw	a5,a5,1
    800036e2:	0711                	addi	a4,a4,4
    800036e4:	fef61be3          	bne	a2,a5,800036da <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800036e8:	0621                	addi	a2,a2,8
    800036ea:	060a                	slli	a2,a2,0x2
    800036ec:	00016797          	auipc	a5,0x16
    800036f0:	93478793          	addi	a5,a5,-1740 # 80019020 <log>
    800036f4:	97b2                	add	a5,a5,a2
    800036f6:	44d8                	lw	a4,12(s1)
    800036f8:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800036fa:	8526                	mv	a0,s1
    800036fc:	fffff097          	auipc	ra,0xfffff
    80003700:	da4080e7          	jalr	-604(ra) # 800024a0 <bpin>
    log.lh.n++;
    80003704:	00016717          	auipc	a4,0x16
    80003708:	91c70713          	addi	a4,a4,-1764 # 80019020 <log>
    8000370c:	575c                	lw	a5,44(a4)
    8000370e:	2785                	addiw	a5,a5,1
    80003710:	d75c                	sw	a5,44(a4)
    80003712:	a82d                	j	8000374c <log_write+0xc8>
    panic("too big a transaction");
    80003714:	00005517          	auipc	a0,0x5
    80003718:	dac50513          	addi	a0,a0,-596 # 800084c0 <etext+0x4c0>
    8000371c:	00002097          	auipc	ra,0x2
    80003720:	556080e7          	jalr	1366(ra) # 80005c72 <panic>
    panic("log_write outside of trans");
    80003724:	00005517          	auipc	a0,0x5
    80003728:	db450513          	addi	a0,a0,-588 # 800084d8 <etext+0x4d8>
    8000372c:	00002097          	auipc	ra,0x2
    80003730:	546080e7          	jalr	1350(ra) # 80005c72 <panic>
  log.lh.block[i] = b->blockno;
    80003734:	00878693          	addi	a3,a5,8
    80003738:	068a                	slli	a3,a3,0x2
    8000373a:	00016717          	auipc	a4,0x16
    8000373e:	8e670713          	addi	a4,a4,-1818 # 80019020 <log>
    80003742:	9736                	add	a4,a4,a3
    80003744:	44d4                	lw	a3,12(s1)
    80003746:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003748:	faf609e3          	beq	a2,a5,800036fa <log_write+0x76>
  }
  release(&log.lock);
    8000374c:	00016517          	auipc	a0,0x16
    80003750:	8d450513          	addi	a0,a0,-1836 # 80019020 <log>
    80003754:	00003097          	auipc	ra,0x3
    80003758:	b4e080e7          	jalr	-1202(ra) # 800062a2 <release>
}
    8000375c:	60e2                	ld	ra,24(sp)
    8000375e:	6442                	ld	s0,16(sp)
    80003760:	64a2                	ld	s1,8(sp)
    80003762:	6902                	ld	s2,0(sp)
    80003764:	6105                	addi	sp,sp,32
    80003766:	8082                	ret

0000000080003768 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003768:	1101                	addi	sp,sp,-32
    8000376a:	ec06                	sd	ra,24(sp)
    8000376c:	e822                	sd	s0,16(sp)
    8000376e:	e426                	sd	s1,8(sp)
    80003770:	e04a                	sd	s2,0(sp)
    80003772:	1000                	addi	s0,sp,32
    80003774:	84aa                	mv	s1,a0
    80003776:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003778:	00005597          	auipc	a1,0x5
    8000377c:	d8058593          	addi	a1,a1,-640 # 800084f8 <etext+0x4f8>
    80003780:	0521                	addi	a0,a0,8
    80003782:	00003097          	auipc	ra,0x3
    80003786:	9dc080e7          	jalr	-1572(ra) # 8000615e <initlock>
  lk->name = name;
    8000378a:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000378e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003792:	0204a423          	sw	zero,40(s1)
}
    80003796:	60e2                	ld	ra,24(sp)
    80003798:	6442                	ld	s0,16(sp)
    8000379a:	64a2                	ld	s1,8(sp)
    8000379c:	6902                	ld	s2,0(sp)
    8000379e:	6105                	addi	sp,sp,32
    800037a0:	8082                	ret

00000000800037a2 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800037a2:	1101                	addi	sp,sp,-32
    800037a4:	ec06                	sd	ra,24(sp)
    800037a6:	e822                	sd	s0,16(sp)
    800037a8:	e426                	sd	s1,8(sp)
    800037aa:	e04a                	sd	s2,0(sp)
    800037ac:	1000                	addi	s0,sp,32
    800037ae:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800037b0:	00850913          	addi	s2,a0,8
    800037b4:	854a                	mv	a0,s2
    800037b6:	00003097          	auipc	ra,0x3
    800037ba:	a3c080e7          	jalr	-1476(ra) # 800061f2 <acquire>
  while (lk->locked) {
    800037be:	409c                	lw	a5,0(s1)
    800037c0:	cb89                	beqz	a5,800037d2 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800037c2:	85ca                	mv	a1,s2
    800037c4:	8526                	mv	a0,s1
    800037c6:	ffffe097          	auipc	ra,0xffffe
    800037ca:	da2080e7          	jalr	-606(ra) # 80001568 <sleep>
  while (lk->locked) {
    800037ce:	409c                	lw	a5,0(s1)
    800037d0:	fbed                	bnez	a5,800037c2 <acquiresleep+0x20>
  }
  lk->locked = 1;
    800037d2:	4785                	li	a5,1
    800037d4:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800037d6:	ffffd097          	auipc	ra,0xffffd
    800037da:	6cc080e7          	jalr	1740(ra) # 80000ea2 <myproc>
    800037de:	591c                	lw	a5,48(a0)
    800037e0:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800037e2:	854a                	mv	a0,s2
    800037e4:	00003097          	auipc	ra,0x3
    800037e8:	abe080e7          	jalr	-1346(ra) # 800062a2 <release>
}
    800037ec:	60e2                	ld	ra,24(sp)
    800037ee:	6442                	ld	s0,16(sp)
    800037f0:	64a2                	ld	s1,8(sp)
    800037f2:	6902                	ld	s2,0(sp)
    800037f4:	6105                	addi	sp,sp,32
    800037f6:	8082                	ret

00000000800037f8 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800037f8:	1101                	addi	sp,sp,-32
    800037fa:	ec06                	sd	ra,24(sp)
    800037fc:	e822                	sd	s0,16(sp)
    800037fe:	e426                	sd	s1,8(sp)
    80003800:	e04a                	sd	s2,0(sp)
    80003802:	1000                	addi	s0,sp,32
    80003804:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003806:	00850913          	addi	s2,a0,8
    8000380a:	854a                	mv	a0,s2
    8000380c:	00003097          	auipc	ra,0x3
    80003810:	9e6080e7          	jalr	-1562(ra) # 800061f2 <acquire>
  lk->locked = 0;
    80003814:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003818:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    8000381c:	8526                	mv	a0,s1
    8000381e:	ffffe097          	auipc	ra,0xffffe
    80003822:	ed0080e7          	jalr	-304(ra) # 800016ee <wakeup>
  release(&lk->lk);
    80003826:	854a                	mv	a0,s2
    80003828:	00003097          	auipc	ra,0x3
    8000382c:	a7a080e7          	jalr	-1414(ra) # 800062a2 <release>
}
    80003830:	60e2                	ld	ra,24(sp)
    80003832:	6442                	ld	s0,16(sp)
    80003834:	64a2                	ld	s1,8(sp)
    80003836:	6902                	ld	s2,0(sp)
    80003838:	6105                	addi	sp,sp,32
    8000383a:	8082                	ret

000000008000383c <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8000383c:	7179                	addi	sp,sp,-48
    8000383e:	f406                	sd	ra,40(sp)
    80003840:	f022                	sd	s0,32(sp)
    80003842:	ec26                	sd	s1,24(sp)
    80003844:	e84a                	sd	s2,16(sp)
    80003846:	1800                	addi	s0,sp,48
    80003848:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    8000384a:	00850913          	addi	s2,a0,8
    8000384e:	854a                	mv	a0,s2
    80003850:	00003097          	auipc	ra,0x3
    80003854:	9a2080e7          	jalr	-1630(ra) # 800061f2 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003858:	409c                	lw	a5,0(s1)
    8000385a:	ef91                	bnez	a5,80003876 <holdingsleep+0x3a>
    8000385c:	4481                	li	s1,0
  release(&lk->lk);
    8000385e:	854a                	mv	a0,s2
    80003860:	00003097          	auipc	ra,0x3
    80003864:	a42080e7          	jalr	-1470(ra) # 800062a2 <release>
  return r;
}
    80003868:	8526                	mv	a0,s1
    8000386a:	70a2                	ld	ra,40(sp)
    8000386c:	7402                	ld	s0,32(sp)
    8000386e:	64e2                	ld	s1,24(sp)
    80003870:	6942                	ld	s2,16(sp)
    80003872:	6145                	addi	sp,sp,48
    80003874:	8082                	ret
    80003876:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80003878:	0284a983          	lw	s3,40(s1)
    8000387c:	ffffd097          	auipc	ra,0xffffd
    80003880:	626080e7          	jalr	1574(ra) # 80000ea2 <myproc>
    80003884:	5904                	lw	s1,48(a0)
    80003886:	413484b3          	sub	s1,s1,s3
    8000388a:	0014b493          	seqz	s1,s1
    8000388e:	69a2                	ld	s3,8(sp)
    80003890:	b7f9                	j	8000385e <holdingsleep+0x22>

0000000080003892 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003892:	1141                	addi	sp,sp,-16
    80003894:	e406                	sd	ra,8(sp)
    80003896:	e022                	sd	s0,0(sp)
    80003898:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    8000389a:	00005597          	auipc	a1,0x5
    8000389e:	c6e58593          	addi	a1,a1,-914 # 80008508 <etext+0x508>
    800038a2:	00016517          	auipc	a0,0x16
    800038a6:	8c650513          	addi	a0,a0,-1850 # 80019168 <ftable>
    800038aa:	00003097          	auipc	ra,0x3
    800038ae:	8b4080e7          	jalr	-1868(ra) # 8000615e <initlock>
}
    800038b2:	60a2                	ld	ra,8(sp)
    800038b4:	6402                	ld	s0,0(sp)
    800038b6:	0141                	addi	sp,sp,16
    800038b8:	8082                	ret

00000000800038ba <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800038ba:	1101                	addi	sp,sp,-32
    800038bc:	ec06                	sd	ra,24(sp)
    800038be:	e822                	sd	s0,16(sp)
    800038c0:	e426                	sd	s1,8(sp)
    800038c2:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800038c4:	00016517          	auipc	a0,0x16
    800038c8:	8a450513          	addi	a0,a0,-1884 # 80019168 <ftable>
    800038cc:	00003097          	auipc	ra,0x3
    800038d0:	926080e7          	jalr	-1754(ra) # 800061f2 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800038d4:	00016497          	auipc	s1,0x16
    800038d8:	8ac48493          	addi	s1,s1,-1876 # 80019180 <ftable+0x18>
    800038dc:	00017717          	auipc	a4,0x17
    800038e0:	84470713          	addi	a4,a4,-1980 # 8001a120 <ftable+0xfb8>
    if(f->ref == 0){
    800038e4:	40dc                	lw	a5,4(s1)
    800038e6:	cf99                	beqz	a5,80003904 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800038e8:	02848493          	addi	s1,s1,40
    800038ec:	fee49ce3          	bne	s1,a4,800038e4 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800038f0:	00016517          	auipc	a0,0x16
    800038f4:	87850513          	addi	a0,a0,-1928 # 80019168 <ftable>
    800038f8:	00003097          	auipc	ra,0x3
    800038fc:	9aa080e7          	jalr	-1622(ra) # 800062a2 <release>
  return 0;
    80003900:	4481                	li	s1,0
    80003902:	a819                	j	80003918 <filealloc+0x5e>
      f->ref = 1;
    80003904:	4785                	li	a5,1
    80003906:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003908:	00016517          	auipc	a0,0x16
    8000390c:	86050513          	addi	a0,a0,-1952 # 80019168 <ftable>
    80003910:	00003097          	auipc	ra,0x3
    80003914:	992080e7          	jalr	-1646(ra) # 800062a2 <release>
}
    80003918:	8526                	mv	a0,s1
    8000391a:	60e2                	ld	ra,24(sp)
    8000391c:	6442                	ld	s0,16(sp)
    8000391e:	64a2                	ld	s1,8(sp)
    80003920:	6105                	addi	sp,sp,32
    80003922:	8082                	ret

0000000080003924 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003924:	1101                	addi	sp,sp,-32
    80003926:	ec06                	sd	ra,24(sp)
    80003928:	e822                	sd	s0,16(sp)
    8000392a:	e426                	sd	s1,8(sp)
    8000392c:	1000                	addi	s0,sp,32
    8000392e:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003930:	00016517          	auipc	a0,0x16
    80003934:	83850513          	addi	a0,a0,-1992 # 80019168 <ftable>
    80003938:	00003097          	auipc	ra,0x3
    8000393c:	8ba080e7          	jalr	-1862(ra) # 800061f2 <acquire>
  if(f->ref < 1)
    80003940:	40dc                	lw	a5,4(s1)
    80003942:	02f05263          	blez	a5,80003966 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003946:	2785                	addiw	a5,a5,1
    80003948:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    8000394a:	00016517          	auipc	a0,0x16
    8000394e:	81e50513          	addi	a0,a0,-2018 # 80019168 <ftable>
    80003952:	00003097          	auipc	ra,0x3
    80003956:	950080e7          	jalr	-1712(ra) # 800062a2 <release>
  return f;
}
    8000395a:	8526                	mv	a0,s1
    8000395c:	60e2                	ld	ra,24(sp)
    8000395e:	6442                	ld	s0,16(sp)
    80003960:	64a2                	ld	s1,8(sp)
    80003962:	6105                	addi	sp,sp,32
    80003964:	8082                	ret
    panic("filedup");
    80003966:	00005517          	auipc	a0,0x5
    8000396a:	baa50513          	addi	a0,a0,-1110 # 80008510 <etext+0x510>
    8000396e:	00002097          	auipc	ra,0x2
    80003972:	304080e7          	jalr	772(ra) # 80005c72 <panic>

0000000080003976 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003976:	7139                	addi	sp,sp,-64
    80003978:	fc06                	sd	ra,56(sp)
    8000397a:	f822                	sd	s0,48(sp)
    8000397c:	f426                	sd	s1,40(sp)
    8000397e:	0080                	addi	s0,sp,64
    80003980:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003982:	00015517          	auipc	a0,0x15
    80003986:	7e650513          	addi	a0,a0,2022 # 80019168 <ftable>
    8000398a:	00003097          	auipc	ra,0x3
    8000398e:	868080e7          	jalr	-1944(ra) # 800061f2 <acquire>
  if(f->ref < 1)
    80003992:	40dc                	lw	a5,4(s1)
    80003994:	04f05a63          	blez	a5,800039e8 <fileclose+0x72>
    panic("fileclose");
  if(--f->ref > 0){
    80003998:	37fd                	addiw	a5,a5,-1
    8000399a:	c0dc                	sw	a5,4(s1)
    8000399c:	06f04263          	bgtz	a5,80003a00 <fileclose+0x8a>
    800039a0:	f04a                	sd	s2,32(sp)
    800039a2:	ec4e                	sd	s3,24(sp)
    800039a4:	e852                	sd	s4,16(sp)
    800039a6:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800039a8:	0004a903          	lw	s2,0(s1)
    800039ac:	0094ca83          	lbu	s5,9(s1)
    800039b0:	0104ba03          	ld	s4,16(s1)
    800039b4:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    800039b8:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800039bc:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800039c0:	00015517          	auipc	a0,0x15
    800039c4:	7a850513          	addi	a0,a0,1960 # 80019168 <ftable>
    800039c8:	00003097          	auipc	ra,0x3
    800039cc:	8da080e7          	jalr	-1830(ra) # 800062a2 <release>

  if(ff.type == FD_PIPE){
    800039d0:	4785                	li	a5,1
    800039d2:	04f90463          	beq	s2,a5,80003a1a <fileclose+0xa4>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    800039d6:	3979                	addiw	s2,s2,-2
    800039d8:	4785                	li	a5,1
    800039da:	0527fb63          	bgeu	a5,s2,80003a30 <fileclose+0xba>
    800039de:	7902                	ld	s2,32(sp)
    800039e0:	69e2                	ld	s3,24(sp)
    800039e2:	6a42                	ld	s4,16(sp)
    800039e4:	6aa2                	ld	s5,8(sp)
    800039e6:	a02d                	j	80003a10 <fileclose+0x9a>
    800039e8:	f04a                	sd	s2,32(sp)
    800039ea:	ec4e                	sd	s3,24(sp)
    800039ec:	e852                	sd	s4,16(sp)
    800039ee:	e456                	sd	s5,8(sp)
    panic("fileclose");
    800039f0:	00005517          	auipc	a0,0x5
    800039f4:	b2850513          	addi	a0,a0,-1240 # 80008518 <etext+0x518>
    800039f8:	00002097          	auipc	ra,0x2
    800039fc:	27a080e7          	jalr	634(ra) # 80005c72 <panic>
    release(&ftable.lock);
    80003a00:	00015517          	auipc	a0,0x15
    80003a04:	76850513          	addi	a0,a0,1896 # 80019168 <ftable>
    80003a08:	00003097          	auipc	ra,0x3
    80003a0c:	89a080e7          	jalr	-1894(ra) # 800062a2 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80003a10:	70e2                	ld	ra,56(sp)
    80003a12:	7442                	ld	s0,48(sp)
    80003a14:	74a2                	ld	s1,40(sp)
    80003a16:	6121                	addi	sp,sp,64
    80003a18:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003a1a:	85d6                	mv	a1,s5
    80003a1c:	8552                	mv	a0,s4
    80003a1e:	00000097          	auipc	ra,0x0
    80003a22:	3ac080e7          	jalr	940(ra) # 80003dca <pipeclose>
    80003a26:	7902                	ld	s2,32(sp)
    80003a28:	69e2                	ld	s3,24(sp)
    80003a2a:	6a42                	ld	s4,16(sp)
    80003a2c:	6aa2                	ld	s5,8(sp)
    80003a2e:	b7cd                	j	80003a10 <fileclose+0x9a>
    begin_op();
    80003a30:	00000097          	auipc	ra,0x0
    80003a34:	a76080e7          	jalr	-1418(ra) # 800034a6 <begin_op>
    iput(ff.ip);
    80003a38:	854e                	mv	a0,s3
    80003a3a:	fffff097          	auipc	ra,0xfffff
    80003a3e:	238080e7          	jalr	568(ra) # 80002c72 <iput>
    end_op();
    80003a42:	00000097          	auipc	ra,0x0
    80003a46:	ade080e7          	jalr	-1314(ra) # 80003520 <end_op>
    80003a4a:	7902                	ld	s2,32(sp)
    80003a4c:	69e2                	ld	s3,24(sp)
    80003a4e:	6a42                	ld	s4,16(sp)
    80003a50:	6aa2                	ld	s5,8(sp)
    80003a52:	bf7d                	j	80003a10 <fileclose+0x9a>

0000000080003a54 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003a54:	715d                	addi	sp,sp,-80
    80003a56:	e486                	sd	ra,72(sp)
    80003a58:	e0a2                	sd	s0,64(sp)
    80003a5a:	fc26                	sd	s1,56(sp)
    80003a5c:	f44e                	sd	s3,40(sp)
    80003a5e:	0880                	addi	s0,sp,80
    80003a60:	84aa                	mv	s1,a0
    80003a62:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003a64:	ffffd097          	auipc	ra,0xffffd
    80003a68:	43e080e7          	jalr	1086(ra) # 80000ea2 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003a6c:	409c                	lw	a5,0(s1)
    80003a6e:	37f9                	addiw	a5,a5,-2
    80003a70:	4705                	li	a4,1
    80003a72:	04f76a63          	bltu	a4,a5,80003ac6 <filestat+0x72>
    80003a76:	f84a                	sd	s2,48(sp)
    80003a78:	f052                	sd	s4,32(sp)
    80003a7a:	892a                	mv	s2,a0
    ilock(f->ip);
    80003a7c:	6c88                	ld	a0,24(s1)
    80003a7e:	fffff097          	auipc	ra,0xfffff
    80003a82:	036080e7          	jalr	54(ra) # 80002ab4 <ilock>
    stati(f->ip, &st);
    80003a86:	fb840a13          	addi	s4,s0,-72
    80003a8a:	85d2                	mv	a1,s4
    80003a8c:	6c88                	ld	a0,24(s1)
    80003a8e:	fffff097          	auipc	ra,0xfffff
    80003a92:	2b4080e7          	jalr	692(ra) # 80002d42 <stati>
    iunlock(f->ip);
    80003a96:	6c88                	ld	a0,24(s1)
    80003a98:	fffff097          	auipc	ra,0xfffff
    80003a9c:	0e2080e7          	jalr	226(ra) # 80002b7a <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003aa0:	46e1                	li	a3,24
    80003aa2:	8652                	mv	a2,s4
    80003aa4:	85ce                	mv	a1,s3
    80003aa6:	05093503          	ld	a0,80(s2)
    80003aaa:	ffffd097          	auipc	ra,0xffffd
    80003aae:	0a4080e7          	jalr	164(ra) # 80000b4e <copyout>
    80003ab2:	41f5551b          	sraiw	a0,a0,0x1f
    80003ab6:	7942                	ld	s2,48(sp)
    80003ab8:	7a02                	ld	s4,32(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80003aba:	60a6                	ld	ra,72(sp)
    80003abc:	6406                	ld	s0,64(sp)
    80003abe:	74e2                	ld	s1,56(sp)
    80003ac0:	79a2                	ld	s3,40(sp)
    80003ac2:	6161                	addi	sp,sp,80
    80003ac4:	8082                	ret
  return -1;
    80003ac6:	557d                	li	a0,-1
    80003ac8:	bfcd                	j	80003aba <filestat+0x66>

0000000080003aca <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003aca:	7179                	addi	sp,sp,-48
    80003acc:	f406                	sd	ra,40(sp)
    80003ace:	f022                	sd	s0,32(sp)
    80003ad0:	e84a                	sd	s2,16(sp)
    80003ad2:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003ad4:	00854783          	lbu	a5,8(a0)
    80003ad8:	cbc5                	beqz	a5,80003b88 <fileread+0xbe>
    80003ada:	ec26                	sd	s1,24(sp)
    80003adc:	e44e                	sd	s3,8(sp)
    80003ade:	84aa                	mv	s1,a0
    80003ae0:	89ae                	mv	s3,a1
    80003ae2:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003ae4:	411c                	lw	a5,0(a0)
    80003ae6:	4705                	li	a4,1
    80003ae8:	04e78963          	beq	a5,a4,80003b3a <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003aec:	470d                	li	a4,3
    80003aee:	04e78f63          	beq	a5,a4,80003b4c <fileread+0x82>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003af2:	4709                	li	a4,2
    80003af4:	08e79263          	bne	a5,a4,80003b78 <fileread+0xae>
    ilock(f->ip);
    80003af8:	6d08                	ld	a0,24(a0)
    80003afa:	fffff097          	auipc	ra,0xfffff
    80003afe:	fba080e7          	jalr	-70(ra) # 80002ab4 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003b02:	874a                	mv	a4,s2
    80003b04:	5094                	lw	a3,32(s1)
    80003b06:	864e                	mv	a2,s3
    80003b08:	4585                	li	a1,1
    80003b0a:	6c88                	ld	a0,24(s1)
    80003b0c:	fffff097          	auipc	ra,0xfffff
    80003b10:	264080e7          	jalr	612(ra) # 80002d70 <readi>
    80003b14:	892a                	mv	s2,a0
    80003b16:	00a05563          	blez	a0,80003b20 <fileread+0x56>
      f->off += r;
    80003b1a:	509c                	lw	a5,32(s1)
    80003b1c:	9fa9                	addw	a5,a5,a0
    80003b1e:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003b20:	6c88                	ld	a0,24(s1)
    80003b22:	fffff097          	auipc	ra,0xfffff
    80003b26:	058080e7          	jalr	88(ra) # 80002b7a <iunlock>
    80003b2a:	64e2                	ld	s1,24(sp)
    80003b2c:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80003b2e:	854a                	mv	a0,s2
    80003b30:	70a2                	ld	ra,40(sp)
    80003b32:	7402                	ld	s0,32(sp)
    80003b34:	6942                	ld	s2,16(sp)
    80003b36:	6145                	addi	sp,sp,48
    80003b38:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003b3a:	6908                	ld	a0,16(a0)
    80003b3c:	00000097          	auipc	ra,0x0
    80003b40:	414080e7          	jalr	1044(ra) # 80003f50 <piperead>
    80003b44:	892a                	mv	s2,a0
    80003b46:	64e2                	ld	s1,24(sp)
    80003b48:	69a2                	ld	s3,8(sp)
    80003b4a:	b7d5                	j	80003b2e <fileread+0x64>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003b4c:	02451783          	lh	a5,36(a0)
    80003b50:	03079693          	slli	a3,a5,0x30
    80003b54:	92c1                	srli	a3,a3,0x30
    80003b56:	4725                	li	a4,9
    80003b58:	02d76a63          	bltu	a4,a3,80003b8c <fileread+0xc2>
    80003b5c:	0792                	slli	a5,a5,0x4
    80003b5e:	00015717          	auipc	a4,0x15
    80003b62:	56a70713          	addi	a4,a4,1386 # 800190c8 <devsw>
    80003b66:	97ba                	add	a5,a5,a4
    80003b68:	639c                	ld	a5,0(a5)
    80003b6a:	c78d                	beqz	a5,80003b94 <fileread+0xca>
    r = devsw[f->major].read(1, addr, n);
    80003b6c:	4505                	li	a0,1
    80003b6e:	9782                	jalr	a5
    80003b70:	892a                	mv	s2,a0
    80003b72:	64e2                	ld	s1,24(sp)
    80003b74:	69a2                	ld	s3,8(sp)
    80003b76:	bf65                	j	80003b2e <fileread+0x64>
    panic("fileread");
    80003b78:	00005517          	auipc	a0,0x5
    80003b7c:	9b050513          	addi	a0,a0,-1616 # 80008528 <etext+0x528>
    80003b80:	00002097          	auipc	ra,0x2
    80003b84:	0f2080e7          	jalr	242(ra) # 80005c72 <panic>
    return -1;
    80003b88:	597d                	li	s2,-1
    80003b8a:	b755                	j	80003b2e <fileread+0x64>
      return -1;
    80003b8c:	597d                	li	s2,-1
    80003b8e:	64e2                	ld	s1,24(sp)
    80003b90:	69a2                	ld	s3,8(sp)
    80003b92:	bf71                	j	80003b2e <fileread+0x64>
    80003b94:	597d                	li	s2,-1
    80003b96:	64e2                	ld	s1,24(sp)
    80003b98:	69a2                	ld	s3,8(sp)
    80003b9a:	bf51                	j	80003b2e <fileread+0x64>

0000000080003b9c <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003b9c:	00954783          	lbu	a5,9(a0)
    80003ba0:	12078c63          	beqz	a5,80003cd8 <filewrite+0x13c>
{
    80003ba4:	711d                	addi	sp,sp,-96
    80003ba6:	ec86                	sd	ra,88(sp)
    80003ba8:	e8a2                	sd	s0,80(sp)
    80003baa:	e0ca                	sd	s2,64(sp)
    80003bac:	f456                	sd	s5,40(sp)
    80003bae:	f05a                	sd	s6,32(sp)
    80003bb0:	1080                	addi	s0,sp,96
    80003bb2:	892a                	mv	s2,a0
    80003bb4:	8b2e                	mv	s6,a1
    80003bb6:	8ab2                	mv	s5,a2
    return -1;

  if(f->type == FD_PIPE){
    80003bb8:	411c                	lw	a5,0(a0)
    80003bba:	4705                	li	a4,1
    80003bbc:	02e78963          	beq	a5,a4,80003bee <filewrite+0x52>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003bc0:	470d                	li	a4,3
    80003bc2:	02e78c63          	beq	a5,a4,80003bfa <filewrite+0x5e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003bc6:	4709                	li	a4,2
    80003bc8:	0ee79a63          	bne	a5,a4,80003cbc <filewrite+0x120>
    80003bcc:	f852                	sd	s4,48(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003bce:	0cc05563          	blez	a2,80003c98 <filewrite+0xfc>
    80003bd2:	e4a6                	sd	s1,72(sp)
    80003bd4:	fc4e                	sd	s3,56(sp)
    80003bd6:	ec5e                	sd	s7,24(sp)
    80003bd8:	e862                	sd	s8,16(sp)
    80003bda:	e466                	sd	s9,8(sp)
    int i = 0;
    80003bdc:	4a01                	li	s4,0
      int n1 = n - i;
      if(n1 > max)
    80003bde:	6b85                	lui	s7,0x1
    80003be0:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003be4:	6c85                	lui	s9,0x1
    80003be6:	c00c8c9b          	addiw	s9,s9,-1024 # c00 <_entry-0x7ffff400>
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003bea:	4c05                	li	s8,1
    80003bec:	a849                	j	80003c7e <filewrite+0xe2>
    ret = pipewrite(f->pipe, addr, n);
    80003bee:	6908                	ld	a0,16(a0)
    80003bf0:	00000097          	auipc	ra,0x0
    80003bf4:	24a080e7          	jalr	586(ra) # 80003e3a <pipewrite>
    80003bf8:	a85d                	j	80003cae <filewrite+0x112>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003bfa:	02451783          	lh	a5,36(a0)
    80003bfe:	03079693          	slli	a3,a5,0x30
    80003c02:	92c1                	srli	a3,a3,0x30
    80003c04:	4725                	li	a4,9
    80003c06:	0cd76b63          	bltu	a4,a3,80003cdc <filewrite+0x140>
    80003c0a:	0792                	slli	a5,a5,0x4
    80003c0c:	00015717          	auipc	a4,0x15
    80003c10:	4bc70713          	addi	a4,a4,1212 # 800190c8 <devsw>
    80003c14:	97ba                	add	a5,a5,a4
    80003c16:	679c                	ld	a5,8(a5)
    80003c18:	c7e1                	beqz	a5,80003ce0 <filewrite+0x144>
    ret = devsw[f->major].write(1, addr, n);
    80003c1a:	4505                	li	a0,1
    80003c1c:	9782                	jalr	a5
    80003c1e:	a841                	j	80003cae <filewrite+0x112>
      if(n1 > max)
    80003c20:	2981                	sext.w	s3,s3
      begin_op();
    80003c22:	00000097          	auipc	ra,0x0
    80003c26:	884080e7          	jalr	-1916(ra) # 800034a6 <begin_op>
      ilock(f->ip);
    80003c2a:	01893503          	ld	a0,24(s2)
    80003c2e:	fffff097          	auipc	ra,0xfffff
    80003c32:	e86080e7          	jalr	-378(ra) # 80002ab4 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003c36:	874e                	mv	a4,s3
    80003c38:	02092683          	lw	a3,32(s2)
    80003c3c:	016a0633          	add	a2,s4,s6
    80003c40:	85e2                	mv	a1,s8
    80003c42:	01893503          	ld	a0,24(s2)
    80003c46:	fffff097          	auipc	ra,0xfffff
    80003c4a:	224080e7          	jalr	548(ra) # 80002e6a <writei>
    80003c4e:	84aa                	mv	s1,a0
    80003c50:	00a05763          	blez	a0,80003c5e <filewrite+0xc2>
        f->off += r;
    80003c54:	02092783          	lw	a5,32(s2)
    80003c58:	9fa9                	addw	a5,a5,a0
    80003c5a:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003c5e:	01893503          	ld	a0,24(s2)
    80003c62:	fffff097          	auipc	ra,0xfffff
    80003c66:	f18080e7          	jalr	-232(ra) # 80002b7a <iunlock>
      end_op();
    80003c6a:	00000097          	auipc	ra,0x0
    80003c6e:	8b6080e7          	jalr	-1866(ra) # 80003520 <end_op>

      if(r != n1){
    80003c72:	02999563          	bne	s3,s1,80003c9c <filewrite+0x100>
        // error from writei
        break;
      }
      i += r;
    80003c76:	01448a3b          	addw	s4,s1,s4
    while(i < n){
    80003c7a:	015a5963          	bge	s4,s5,80003c8c <filewrite+0xf0>
      int n1 = n - i;
    80003c7e:	414a87bb          	subw	a5,s5,s4
    80003c82:	89be                	mv	s3,a5
      if(n1 > max)
    80003c84:	f8fbdee3          	bge	s7,a5,80003c20 <filewrite+0x84>
    80003c88:	89e6                	mv	s3,s9
    80003c8a:	bf59                	j	80003c20 <filewrite+0x84>
    80003c8c:	64a6                	ld	s1,72(sp)
    80003c8e:	79e2                	ld	s3,56(sp)
    80003c90:	6be2                	ld	s7,24(sp)
    80003c92:	6c42                	ld	s8,16(sp)
    80003c94:	6ca2                	ld	s9,8(sp)
    80003c96:	a801                	j	80003ca6 <filewrite+0x10a>
    int i = 0;
    80003c98:	4a01                	li	s4,0
    80003c9a:	a031                	j	80003ca6 <filewrite+0x10a>
    80003c9c:	64a6                	ld	s1,72(sp)
    80003c9e:	79e2                	ld	s3,56(sp)
    80003ca0:	6be2                	ld	s7,24(sp)
    80003ca2:	6c42                	ld	s8,16(sp)
    80003ca4:	6ca2                	ld	s9,8(sp)
    }
    ret = (i == n ? n : -1);
    80003ca6:	034a9f63          	bne	s5,s4,80003ce4 <filewrite+0x148>
    80003caa:	8556                	mv	a0,s5
    80003cac:	7a42                	ld	s4,48(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003cae:	60e6                	ld	ra,88(sp)
    80003cb0:	6446                	ld	s0,80(sp)
    80003cb2:	6906                	ld	s2,64(sp)
    80003cb4:	7aa2                	ld	s5,40(sp)
    80003cb6:	7b02                	ld	s6,32(sp)
    80003cb8:	6125                	addi	sp,sp,96
    80003cba:	8082                	ret
    80003cbc:	e4a6                	sd	s1,72(sp)
    80003cbe:	fc4e                	sd	s3,56(sp)
    80003cc0:	f852                	sd	s4,48(sp)
    80003cc2:	ec5e                	sd	s7,24(sp)
    80003cc4:	e862                	sd	s8,16(sp)
    80003cc6:	e466                	sd	s9,8(sp)
    panic("filewrite");
    80003cc8:	00005517          	auipc	a0,0x5
    80003ccc:	87050513          	addi	a0,a0,-1936 # 80008538 <etext+0x538>
    80003cd0:	00002097          	auipc	ra,0x2
    80003cd4:	fa2080e7          	jalr	-94(ra) # 80005c72 <panic>
    return -1;
    80003cd8:	557d                	li	a0,-1
}
    80003cda:	8082                	ret
      return -1;
    80003cdc:	557d                	li	a0,-1
    80003cde:	bfc1                	j	80003cae <filewrite+0x112>
    80003ce0:	557d                	li	a0,-1
    80003ce2:	b7f1                	j	80003cae <filewrite+0x112>
    ret = (i == n ? n : -1);
    80003ce4:	557d                	li	a0,-1
    80003ce6:	7a42                	ld	s4,48(sp)
    80003ce8:	b7d9                	j	80003cae <filewrite+0x112>

0000000080003cea <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003cea:	7179                	addi	sp,sp,-48
    80003cec:	f406                	sd	ra,40(sp)
    80003cee:	f022                	sd	s0,32(sp)
    80003cf0:	ec26                	sd	s1,24(sp)
    80003cf2:	e052                	sd	s4,0(sp)
    80003cf4:	1800                	addi	s0,sp,48
    80003cf6:	84aa                	mv	s1,a0
    80003cf8:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003cfa:	0005b023          	sd	zero,0(a1)
    80003cfe:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003d02:	00000097          	auipc	ra,0x0
    80003d06:	bb8080e7          	jalr	-1096(ra) # 800038ba <filealloc>
    80003d0a:	e088                	sd	a0,0(s1)
    80003d0c:	cd49                	beqz	a0,80003da6 <pipealloc+0xbc>
    80003d0e:	00000097          	auipc	ra,0x0
    80003d12:	bac080e7          	jalr	-1108(ra) # 800038ba <filealloc>
    80003d16:	00aa3023          	sd	a0,0(s4)
    80003d1a:	c141                	beqz	a0,80003d9a <pipealloc+0xb0>
    80003d1c:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003d1e:	ffffc097          	auipc	ra,0xffffc
    80003d22:	3fc080e7          	jalr	1020(ra) # 8000011a <kalloc>
    80003d26:	892a                	mv	s2,a0
    80003d28:	c13d                	beqz	a0,80003d8e <pipealloc+0xa4>
    80003d2a:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80003d2c:	4985                	li	s3,1
    80003d2e:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003d32:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003d36:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003d3a:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003d3e:	00005597          	auipc	a1,0x5
    80003d42:	80a58593          	addi	a1,a1,-2038 # 80008548 <etext+0x548>
    80003d46:	00002097          	auipc	ra,0x2
    80003d4a:	418080e7          	jalr	1048(ra) # 8000615e <initlock>
  (*f0)->type = FD_PIPE;
    80003d4e:	609c                	ld	a5,0(s1)
    80003d50:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003d54:	609c                	ld	a5,0(s1)
    80003d56:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003d5a:	609c                	ld	a5,0(s1)
    80003d5c:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003d60:	609c                	ld	a5,0(s1)
    80003d62:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003d66:	000a3783          	ld	a5,0(s4)
    80003d6a:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003d6e:	000a3783          	ld	a5,0(s4)
    80003d72:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003d76:	000a3783          	ld	a5,0(s4)
    80003d7a:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003d7e:	000a3783          	ld	a5,0(s4)
    80003d82:	0127b823          	sd	s2,16(a5)
  return 0;
    80003d86:	4501                	li	a0,0
    80003d88:	6942                	ld	s2,16(sp)
    80003d8a:	69a2                	ld	s3,8(sp)
    80003d8c:	a03d                	j	80003dba <pipealloc+0xd0>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003d8e:	6088                	ld	a0,0(s1)
    80003d90:	c119                	beqz	a0,80003d96 <pipealloc+0xac>
    80003d92:	6942                	ld	s2,16(sp)
    80003d94:	a029                	j	80003d9e <pipealloc+0xb4>
    80003d96:	6942                	ld	s2,16(sp)
    80003d98:	a039                	j	80003da6 <pipealloc+0xbc>
    80003d9a:	6088                	ld	a0,0(s1)
    80003d9c:	c50d                	beqz	a0,80003dc6 <pipealloc+0xdc>
    fileclose(*f0);
    80003d9e:	00000097          	auipc	ra,0x0
    80003da2:	bd8080e7          	jalr	-1064(ra) # 80003976 <fileclose>
  if(*f1)
    80003da6:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003daa:	557d                	li	a0,-1
  if(*f1)
    80003dac:	c799                	beqz	a5,80003dba <pipealloc+0xd0>
    fileclose(*f1);
    80003dae:	853e                	mv	a0,a5
    80003db0:	00000097          	auipc	ra,0x0
    80003db4:	bc6080e7          	jalr	-1082(ra) # 80003976 <fileclose>
  return -1;
    80003db8:	557d                	li	a0,-1
}
    80003dba:	70a2                	ld	ra,40(sp)
    80003dbc:	7402                	ld	s0,32(sp)
    80003dbe:	64e2                	ld	s1,24(sp)
    80003dc0:	6a02                	ld	s4,0(sp)
    80003dc2:	6145                	addi	sp,sp,48
    80003dc4:	8082                	ret
  return -1;
    80003dc6:	557d                	li	a0,-1
    80003dc8:	bfcd                	j	80003dba <pipealloc+0xd0>

0000000080003dca <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003dca:	1101                	addi	sp,sp,-32
    80003dcc:	ec06                	sd	ra,24(sp)
    80003dce:	e822                	sd	s0,16(sp)
    80003dd0:	e426                	sd	s1,8(sp)
    80003dd2:	e04a                	sd	s2,0(sp)
    80003dd4:	1000                	addi	s0,sp,32
    80003dd6:	84aa                	mv	s1,a0
    80003dd8:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003dda:	00002097          	auipc	ra,0x2
    80003dde:	418080e7          	jalr	1048(ra) # 800061f2 <acquire>
  if(writable){
    80003de2:	02090d63          	beqz	s2,80003e1c <pipeclose+0x52>
    pi->writeopen = 0;
    80003de6:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003dea:	21848513          	addi	a0,s1,536
    80003dee:	ffffe097          	auipc	ra,0xffffe
    80003df2:	900080e7          	jalr	-1792(ra) # 800016ee <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003df6:	2204b783          	ld	a5,544(s1)
    80003dfa:	eb95                	bnez	a5,80003e2e <pipeclose+0x64>
    release(&pi->lock);
    80003dfc:	8526                	mv	a0,s1
    80003dfe:	00002097          	auipc	ra,0x2
    80003e02:	4a4080e7          	jalr	1188(ra) # 800062a2 <release>
    kfree((char*)pi);
    80003e06:	8526                	mv	a0,s1
    80003e08:	ffffc097          	auipc	ra,0xffffc
    80003e0c:	214080e7          	jalr	532(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003e10:	60e2                	ld	ra,24(sp)
    80003e12:	6442                	ld	s0,16(sp)
    80003e14:	64a2                	ld	s1,8(sp)
    80003e16:	6902                	ld	s2,0(sp)
    80003e18:	6105                	addi	sp,sp,32
    80003e1a:	8082                	ret
    pi->readopen = 0;
    80003e1c:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003e20:	21c48513          	addi	a0,s1,540
    80003e24:	ffffe097          	auipc	ra,0xffffe
    80003e28:	8ca080e7          	jalr	-1846(ra) # 800016ee <wakeup>
    80003e2c:	b7e9                	j	80003df6 <pipeclose+0x2c>
    release(&pi->lock);
    80003e2e:	8526                	mv	a0,s1
    80003e30:	00002097          	auipc	ra,0x2
    80003e34:	472080e7          	jalr	1138(ra) # 800062a2 <release>
}
    80003e38:	bfe1                	j	80003e10 <pipeclose+0x46>

0000000080003e3a <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003e3a:	7159                	addi	sp,sp,-112
    80003e3c:	f486                	sd	ra,104(sp)
    80003e3e:	f0a2                	sd	s0,96(sp)
    80003e40:	eca6                	sd	s1,88(sp)
    80003e42:	e8ca                	sd	s2,80(sp)
    80003e44:	e4ce                	sd	s3,72(sp)
    80003e46:	e0d2                	sd	s4,64(sp)
    80003e48:	fc56                	sd	s5,56(sp)
    80003e4a:	1880                	addi	s0,sp,112
    80003e4c:	84aa                	mv	s1,a0
    80003e4e:	8aae                	mv	s5,a1
    80003e50:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003e52:	ffffd097          	auipc	ra,0xffffd
    80003e56:	050080e7          	jalr	80(ra) # 80000ea2 <myproc>
    80003e5a:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003e5c:	8526                	mv	a0,s1
    80003e5e:	00002097          	auipc	ra,0x2
    80003e62:	394080e7          	jalr	916(ra) # 800061f2 <acquire>
  while(i < n){
    80003e66:	0d405d63          	blez	s4,80003f40 <pipewrite+0x106>
    80003e6a:	f85a                	sd	s6,48(sp)
    80003e6c:	f45e                	sd	s7,40(sp)
    80003e6e:	f062                	sd	s8,32(sp)
    80003e70:	ec66                	sd	s9,24(sp)
    80003e72:	e86a                	sd	s10,16(sp)
  int i = 0;
    80003e74:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003e76:	f9f40c13          	addi	s8,s0,-97
    80003e7a:	4b85                	li	s7,1
    80003e7c:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003e7e:	21848d13          	addi	s10,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003e82:	21c48c93          	addi	s9,s1,540
    80003e86:	a099                	j	80003ecc <pipewrite+0x92>
      release(&pi->lock);
    80003e88:	8526                	mv	a0,s1
    80003e8a:	00002097          	auipc	ra,0x2
    80003e8e:	418080e7          	jalr	1048(ra) # 800062a2 <release>
      return -1;
    80003e92:	597d                	li	s2,-1
    80003e94:	7b42                	ld	s6,48(sp)
    80003e96:	7ba2                	ld	s7,40(sp)
    80003e98:	7c02                	ld	s8,32(sp)
    80003e9a:	6ce2                	ld	s9,24(sp)
    80003e9c:	6d42                	ld	s10,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003e9e:	854a                	mv	a0,s2
    80003ea0:	70a6                	ld	ra,104(sp)
    80003ea2:	7406                	ld	s0,96(sp)
    80003ea4:	64e6                	ld	s1,88(sp)
    80003ea6:	6946                	ld	s2,80(sp)
    80003ea8:	69a6                	ld	s3,72(sp)
    80003eaa:	6a06                	ld	s4,64(sp)
    80003eac:	7ae2                	ld	s5,56(sp)
    80003eae:	6165                	addi	sp,sp,112
    80003eb0:	8082                	ret
      wakeup(&pi->nread);
    80003eb2:	856a                	mv	a0,s10
    80003eb4:	ffffe097          	auipc	ra,0xffffe
    80003eb8:	83a080e7          	jalr	-1990(ra) # 800016ee <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003ebc:	85a6                	mv	a1,s1
    80003ebe:	8566                	mv	a0,s9
    80003ec0:	ffffd097          	auipc	ra,0xffffd
    80003ec4:	6a8080e7          	jalr	1704(ra) # 80001568 <sleep>
  while(i < n){
    80003ec8:	05495b63          	bge	s2,s4,80003f1e <pipewrite+0xe4>
    if(pi->readopen == 0 || pr->killed){
    80003ecc:	2204a783          	lw	a5,544(s1)
    80003ed0:	dfc5                	beqz	a5,80003e88 <pipewrite+0x4e>
    80003ed2:	0289a783          	lw	a5,40(s3)
    80003ed6:	fbcd                	bnez	a5,80003e88 <pipewrite+0x4e>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003ed8:	2184a783          	lw	a5,536(s1)
    80003edc:	21c4a703          	lw	a4,540(s1)
    80003ee0:	2007879b          	addiw	a5,a5,512
    80003ee4:	fcf707e3          	beq	a4,a5,80003eb2 <pipewrite+0x78>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003ee8:	86de                	mv	a3,s7
    80003eea:	01590633          	add	a2,s2,s5
    80003eee:	85e2                	mv	a1,s8
    80003ef0:	0509b503          	ld	a0,80(s3)
    80003ef4:	ffffd097          	auipc	ra,0xffffd
    80003ef8:	ce6080e7          	jalr	-794(ra) # 80000bda <copyin>
    80003efc:	05650463          	beq	a0,s6,80003f44 <pipewrite+0x10a>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003f00:	21c4a783          	lw	a5,540(s1)
    80003f04:	0017871b          	addiw	a4,a5,1
    80003f08:	20e4ae23          	sw	a4,540(s1)
    80003f0c:	1ff7f793          	andi	a5,a5,511
    80003f10:	97a6                	add	a5,a5,s1
    80003f12:	f9f44703          	lbu	a4,-97(s0)
    80003f16:	00e78c23          	sb	a4,24(a5)
      i++;
    80003f1a:	2905                	addiw	s2,s2,1
    80003f1c:	b775                	j	80003ec8 <pipewrite+0x8e>
    80003f1e:	7b42                	ld	s6,48(sp)
    80003f20:	7ba2                	ld	s7,40(sp)
    80003f22:	7c02                	ld	s8,32(sp)
    80003f24:	6ce2                	ld	s9,24(sp)
    80003f26:	6d42                	ld	s10,16(sp)
  wakeup(&pi->nread);
    80003f28:	21848513          	addi	a0,s1,536
    80003f2c:	ffffd097          	auipc	ra,0xffffd
    80003f30:	7c2080e7          	jalr	1986(ra) # 800016ee <wakeup>
  release(&pi->lock);
    80003f34:	8526                	mv	a0,s1
    80003f36:	00002097          	auipc	ra,0x2
    80003f3a:	36c080e7          	jalr	876(ra) # 800062a2 <release>
  return i;
    80003f3e:	b785                	j	80003e9e <pipewrite+0x64>
  int i = 0;
    80003f40:	4901                	li	s2,0
    80003f42:	b7dd                	j	80003f28 <pipewrite+0xee>
    80003f44:	7b42                	ld	s6,48(sp)
    80003f46:	7ba2                	ld	s7,40(sp)
    80003f48:	7c02                	ld	s8,32(sp)
    80003f4a:	6ce2                	ld	s9,24(sp)
    80003f4c:	6d42                	ld	s10,16(sp)
    80003f4e:	bfe9                	j	80003f28 <pipewrite+0xee>

0000000080003f50 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003f50:	711d                	addi	sp,sp,-96
    80003f52:	ec86                	sd	ra,88(sp)
    80003f54:	e8a2                	sd	s0,80(sp)
    80003f56:	e4a6                	sd	s1,72(sp)
    80003f58:	e0ca                	sd	s2,64(sp)
    80003f5a:	fc4e                	sd	s3,56(sp)
    80003f5c:	f852                	sd	s4,48(sp)
    80003f5e:	f456                	sd	s5,40(sp)
    80003f60:	1080                	addi	s0,sp,96
    80003f62:	84aa                	mv	s1,a0
    80003f64:	892e                	mv	s2,a1
    80003f66:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003f68:	ffffd097          	auipc	ra,0xffffd
    80003f6c:	f3a080e7          	jalr	-198(ra) # 80000ea2 <myproc>
    80003f70:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003f72:	8526                	mv	a0,s1
    80003f74:	00002097          	auipc	ra,0x2
    80003f78:	27e080e7          	jalr	638(ra) # 800061f2 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003f7c:	2184a703          	lw	a4,536(s1)
    80003f80:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003f84:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003f88:	02f71863          	bne	a4,a5,80003fb8 <piperead+0x68>
    80003f8c:	2244a783          	lw	a5,548(s1)
    80003f90:	cf9d                	beqz	a5,80003fce <piperead+0x7e>
    if(pr->killed){
    80003f92:	028a2783          	lw	a5,40(s4)
    80003f96:	e78d                	bnez	a5,80003fc0 <piperead+0x70>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003f98:	85a6                	mv	a1,s1
    80003f9a:	854e                	mv	a0,s3
    80003f9c:	ffffd097          	auipc	ra,0xffffd
    80003fa0:	5cc080e7          	jalr	1484(ra) # 80001568 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003fa4:	2184a703          	lw	a4,536(s1)
    80003fa8:	21c4a783          	lw	a5,540(s1)
    80003fac:	fef700e3          	beq	a4,a5,80003f8c <piperead+0x3c>
    80003fb0:	f05a                	sd	s6,32(sp)
    80003fb2:	ec5e                	sd	s7,24(sp)
    80003fb4:	e862                	sd	s8,16(sp)
    80003fb6:	a839                	j	80003fd4 <piperead+0x84>
    80003fb8:	f05a                	sd	s6,32(sp)
    80003fba:	ec5e                	sd	s7,24(sp)
    80003fbc:	e862                	sd	s8,16(sp)
    80003fbe:	a819                	j	80003fd4 <piperead+0x84>
      release(&pi->lock);
    80003fc0:	8526                	mv	a0,s1
    80003fc2:	00002097          	auipc	ra,0x2
    80003fc6:	2e0080e7          	jalr	736(ra) # 800062a2 <release>
      return -1;
    80003fca:	59fd                	li	s3,-1
    80003fcc:	a895                	j	80004040 <piperead+0xf0>
    80003fce:	f05a                	sd	s6,32(sp)
    80003fd0:	ec5e                	sd	s7,24(sp)
    80003fd2:	e862                	sd	s8,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003fd4:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003fd6:	faf40c13          	addi	s8,s0,-81
    80003fda:	4b85                	li	s7,1
    80003fdc:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003fde:	05505363          	blez	s5,80004024 <piperead+0xd4>
    if(pi->nread == pi->nwrite)
    80003fe2:	2184a783          	lw	a5,536(s1)
    80003fe6:	21c4a703          	lw	a4,540(s1)
    80003fea:	02f70d63          	beq	a4,a5,80004024 <piperead+0xd4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80003fee:	0017871b          	addiw	a4,a5,1
    80003ff2:	20e4ac23          	sw	a4,536(s1)
    80003ff6:	1ff7f793          	andi	a5,a5,511
    80003ffa:	97a6                	add	a5,a5,s1
    80003ffc:	0187c783          	lbu	a5,24(a5)
    80004000:	faf407a3          	sb	a5,-81(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004004:	86de                	mv	a3,s7
    80004006:	8662                	mv	a2,s8
    80004008:	85ca                	mv	a1,s2
    8000400a:	050a3503          	ld	a0,80(s4)
    8000400e:	ffffd097          	auipc	ra,0xffffd
    80004012:	b40080e7          	jalr	-1216(ra) # 80000b4e <copyout>
    80004016:	01650763          	beq	a0,s6,80004024 <piperead+0xd4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000401a:	2985                	addiw	s3,s3,1
    8000401c:	0905                	addi	s2,s2,1
    8000401e:	fd3a92e3          	bne	s5,s3,80003fe2 <piperead+0x92>
    80004022:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004024:	21c48513          	addi	a0,s1,540
    80004028:	ffffd097          	auipc	ra,0xffffd
    8000402c:	6c6080e7          	jalr	1734(ra) # 800016ee <wakeup>
  release(&pi->lock);
    80004030:	8526                	mv	a0,s1
    80004032:	00002097          	auipc	ra,0x2
    80004036:	270080e7          	jalr	624(ra) # 800062a2 <release>
    8000403a:	7b02                	ld	s6,32(sp)
    8000403c:	6be2                	ld	s7,24(sp)
    8000403e:	6c42                	ld	s8,16(sp)
  return i;
}
    80004040:	854e                	mv	a0,s3
    80004042:	60e6                	ld	ra,88(sp)
    80004044:	6446                	ld	s0,80(sp)
    80004046:	64a6                	ld	s1,72(sp)
    80004048:	6906                	ld	s2,64(sp)
    8000404a:	79e2                	ld	s3,56(sp)
    8000404c:	7a42                	ld	s4,48(sp)
    8000404e:	7aa2                	ld	s5,40(sp)
    80004050:	6125                	addi	sp,sp,96
    80004052:	8082                	ret

0000000080004054 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80004054:	de010113          	addi	sp,sp,-544
    80004058:	20113c23          	sd	ra,536(sp)
    8000405c:	20813823          	sd	s0,528(sp)
    80004060:	20913423          	sd	s1,520(sp)
    80004064:	21213023          	sd	s2,512(sp)
    80004068:	1400                	addi	s0,sp,544
    8000406a:	892a                	mv	s2,a0
    8000406c:	dea43823          	sd	a0,-528(s0)
    80004070:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004074:	ffffd097          	auipc	ra,0xffffd
    80004078:	e2e080e7          	jalr	-466(ra) # 80000ea2 <myproc>
    8000407c:	84aa                	mv	s1,a0

  begin_op();
    8000407e:	fffff097          	auipc	ra,0xfffff
    80004082:	428080e7          	jalr	1064(ra) # 800034a6 <begin_op>

  if((ip = namei(path)) == 0){
    80004086:	854a                	mv	a0,s2
    80004088:	fffff097          	auipc	ra,0xfffff
    8000408c:	218080e7          	jalr	536(ra) # 800032a0 <namei>
    80004090:	c525                	beqz	a0,800040f8 <exec+0xa4>
    80004092:	fbd2                	sd	s4,496(sp)
    80004094:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004096:	fffff097          	auipc	ra,0xfffff
    8000409a:	a1e080e7          	jalr	-1506(ra) # 80002ab4 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    8000409e:	04000713          	li	a4,64
    800040a2:	4681                	li	a3,0
    800040a4:	e5040613          	addi	a2,s0,-432
    800040a8:	4581                	li	a1,0
    800040aa:	8552                	mv	a0,s4
    800040ac:	fffff097          	auipc	ra,0xfffff
    800040b0:	cc4080e7          	jalr	-828(ra) # 80002d70 <readi>
    800040b4:	04000793          	li	a5,64
    800040b8:	00f51a63          	bne	a0,a5,800040cc <exec+0x78>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    800040bc:	e5042703          	lw	a4,-432(s0)
    800040c0:	464c47b7          	lui	a5,0x464c4
    800040c4:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800040c8:	02f70e63          	beq	a4,a5,80004104 <exec+0xb0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800040cc:	8552                	mv	a0,s4
    800040ce:	fffff097          	auipc	ra,0xfffff
    800040d2:	c4c080e7          	jalr	-948(ra) # 80002d1a <iunlockput>
    end_op();
    800040d6:	fffff097          	auipc	ra,0xfffff
    800040da:	44a080e7          	jalr	1098(ra) # 80003520 <end_op>
  }
  return -1;
    800040de:	557d                	li	a0,-1
    800040e0:	7a5e                	ld	s4,496(sp)
}
    800040e2:	21813083          	ld	ra,536(sp)
    800040e6:	21013403          	ld	s0,528(sp)
    800040ea:	20813483          	ld	s1,520(sp)
    800040ee:	20013903          	ld	s2,512(sp)
    800040f2:	22010113          	addi	sp,sp,544
    800040f6:	8082                	ret
    end_op();
    800040f8:	fffff097          	auipc	ra,0xfffff
    800040fc:	428080e7          	jalr	1064(ra) # 80003520 <end_op>
    return -1;
    80004100:	557d                	li	a0,-1
    80004102:	b7c5                	j	800040e2 <exec+0x8e>
    80004104:	f3da                	sd	s6,480(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80004106:	8526                	mv	a0,s1
    80004108:	ffffd097          	auipc	ra,0xffffd
    8000410c:	e5e080e7          	jalr	-418(ra) # 80000f66 <proc_pagetable>
    80004110:	8b2a                	mv	s6,a0
    80004112:	2a050863          	beqz	a0,800043c2 <exec+0x36e>
    80004116:	ffce                	sd	s3,504(sp)
    80004118:	f7d6                	sd	s5,488(sp)
    8000411a:	efde                	sd	s7,472(sp)
    8000411c:	ebe2                	sd	s8,464(sp)
    8000411e:	e7e6                	sd	s9,456(sp)
    80004120:	e3ea                	sd	s10,448(sp)
    80004122:	ff6e                	sd	s11,440(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004124:	e7042683          	lw	a3,-400(s0)
    80004128:	e8845783          	lhu	a5,-376(s0)
    8000412c:	cbfd                	beqz	a5,80004222 <exec+0x1ce>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000412e:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004130:	4d01                	li	s10,0
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004132:	03800d93          	li	s11,56
    if((ph.vaddr % PGSIZE) != 0)
    80004136:	6c85                	lui	s9,0x1
    80004138:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    8000413c:	def43423          	sd	a5,-536(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80004140:	6a85                	lui	s5,0x1
    80004142:	a0b5                	j	800041ae <exec+0x15a>
      panic("loadseg: address should exist");
    80004144:	00004517          	auipc	a0,0x4
    80004148:	40c50513          	addi	a0,a0,1036 # 80008550 <etext+0x550>
    8000414c:	00002097          	auipc	ra,0x2
    80004150:	b26080e7          	jalr	-1242(ra) # 80005c72 <panic>
    if(sz - i < PGSIZE)
    80004154:	2901                	sext.w	s2,s2
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004156:	874a                	mv	a4,s2
    80004158:	009c06bb          	addw	a3,s8,s1
    8000415c:	4581                	li	a1,0
    8000415e:	8552                	mv	a0,s4
    80004160:	fffff097          	auipc	ra,0xfffff
    80004164:	c10080e7          	jalr	-1008(ra) # 80002d70 <readi>
    80004168:	26a91163          	bne	s2,a0,800043ca <exec+0x376>
  for(i = 0; i < sz; i += PGSIZE){
    8000416c:	009a84bb          	addw	s1,s5,s1
    80004170:	0334f463          	bgeu	s1,s3,80004198 <exec+0x144>
    pa = walkaddr(pagetable, va + i);
    80004174:	02049593          	slli	a1,s1,0x20
    80004178:	9181                	srli	a1,a1,0x20
    8000417a:	95de                	add	a1,a1,s7
    8000417c:	855a                	mv	a0,s6
    8000417e:	ffffc097          	auipc	ra,0xffffc
    80004182:	39a080e7          	jalr	922(ra) # 80000518 <walkaddr>
    80004186:	862a                	mv	a2,a0
    if(pa == 0)
    80004188:	dd55                	beqz	a0,80004144 <exec+0xf0>
    if(sz - i < PGSIZE)
    8000418a:	409987bb          	subw	a5,s3,s1
    8000418e:	893e                	mv	s2,a5
    80004190:	fcfcf2e3          	bgeu	s9,a5,80004154 <exec+0x100>
    80004194:	8956                	mv	s2,s5
    80004196:	bf7d                	j	80004154 <exec+0x100>
    sz = sz1;
    80004198:	df843483          	ld	s1,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000419c:	2d05                	addiw	s10,s10,1
    8000419e:	e0843783          	ld	a5,-504(s0)
    800041a2:	0387869b          	addiw	a3,a5,56
    800041a6:	e8845783          	lhu	a5,-376(s0)
    800041aa:	06fd5d63          	bge	s10,a5,80004224 <exec+0x1d0>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800041ae:	e0d43423          	sd	a3,-504(s0)
    800041b2:	876e                	mv	a4,s11
    800041b4:	e1840613          	addi	a2,s0,-488
    800041b8:	4581                	li	a1,0
    800041ba:	8552                	mv	a0,s4
    800041bc:	fffff097          	auipc	ra,0xfffff
    800041c0:	bb4080e7          	jalr	-1100(ra) # 80002d70 <readi>
    800041c4:	21b51163          	bne	a0,s11,800043c6 <exec+0x372>
    if(ph.type != ELF_PROG_LOAD)
    800041c8:	e1842783          	lw	a5,-488(s0)
    800041cc:	4705                	li	a4,1
    800041ce:	fce797e3          	bne	a5,a4,8000419c <exec+0x148>
    if(ph.memsz < ph.filesz)
    800041d2:	e4043603          	ld	a2,-448(s0)
    800041d6:	e3843783          	ld	a5,-456(s0)
    800041da:	20f66863          	bltu	a2,a5,800043ea <exec+0x396>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800041de:	e2843783          	ld	a5,-472(s0)
    800041e2:	963e                	add	a2,a2,a5
    800041e4:	20f66663          	bltu	a2,a5,800043f0 <exec+0x39c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800041e8:	85a6                	mv	a1,s1
    800041ea:	855a                	mv	a0,s6
    800041ec:	ffffc097          	auipc	ra,0xffffc
    800041f0:	6f0080e7          	jalr	1776(ra) # 800008dc <uvmalloc>
    800041f4:	dea43c23          	sd	a0,-520(s0)
    800041f8:	1e050f63          	beqz	a0,800043f6 <exec+0x3a2>
    if((ph.vaddr % PGSIZE) != 0)
    800041fc:	e2843b83          	ld	s7,-472(s0)
    80004200:	de843783          	ld	a5,-536(s0)
    80004204:	00fbf7b3          	and	a5,s7,a5
    80004208:	1c079163          	bnez	a5,800043ca <exec+0x376>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000420c:	e2042c03          	lw	s8,-480(s0)
    80004210:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004214:	00098463          	beqz	s3,8000421c <exec+0x1c8>
    80004218:	4481                	li	s1,0
    8000421a:	bfa9                	j	80004174 <exec+0x120>
    sz = sz1;
    8000421c:	df843483          	ld	s1,-520(s0)
    80004220:	bfb5                	j	8000419c <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004222:	4481                	li	s1,0
  iunlockput(ip);
    80004224:	8552                	mv	a0,s4
    80004226:	fffff097          	auipc	ra,0xfffff
    8000422a:	af4080e7          	jalr	-1292(ra) # 80002d1a <iunlockput>
  end_op();
    8000422e:	fffff097          	auipc	ra,0xfffff
    80004232:	2f2080e7          	jalr	754(ra) # 80003520 <end_op>
  p = myproc();
    80004236:	ffffd097          	auipc	ra,0xffffd
    8000423a:	c6c080e7          	jalr	-916(ra) # 80000ea2 <myproc>
    8000423e:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004240:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004244:	6985                	lui	s3,0x1
    80004246:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80004248:	99a6                	add	s3,s3,s1
    8000424a:	77fd                	lui	a5,0xfffff
    8000424c:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004250:	6609                	lui	a2,0x2
    80004252:	964e                	add	a2,a2,s3
    80004254:	85ce                	mv	a1,s3
    80004256:	855a                	mv	a0,s6
    80004258:	ffffc097          	auipc	ra,0xffffc
    8000425c:	684080e7          	jalr	1668(ra) # 800008dc <uvmalloc>
    80004260:	8a2a                	mv	s4,a0
    80004262:	e115                	bnez	a0,80004286 <exec+0x232>
    proc_freepagetable(pagetable, sz);
    80004264:	85ce                	mv	a1,s3
    80004266:	855a                	mv	a0,s6
    80004268:	ffffd097          	auipc	ra,0xffffd
    8000426c:	d9a080e7          	jalr	-614(ra) # 80001002 <proc_freepagetable>
  return -1;
    80004270:	557d                	li	a0,-1
    80004272:	79fe                	ld	s3,504(sp)
    80004274:	7a5e                	ld	s4,496(sp)
    80004276:	7abe                	ld	s5,488(sp)
    80004278:	7b1e                	ld	s6,480(sp)
    8000427a:	6bfe                	ld	s7,472(sp)
    8000427c:	6c5e                	ld	s8,464(sp)
    8000427e:	6cbe                	ld	s9,456(sp)
    80004280:	6d1e                	ld	s10,448(sp)
    80004282:	7dfa                	ld	s11,440(sp)
    80004284:	bdb9                	j	800040e2 <exec+0x8e>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004286:	75f9                	lui	a1,0xffffe
    80004288:	95aa                	add	a1,a1,a0
    8000428a:	855a                	mv	a0,s6
    8000428c:	ffffd097          	auipc	ra,0xffffd
    80004290:	890080e7          	jalr	-1904(ra) # 80000b1c <uvmclear>
  stackbase = sp - PGSIZE;
    80004294:	7bfd                	lui	s7,0xfffff
    80004296:	9bd2                	add	s7,s7,s4
  for(argc = 0; argv[argc]; argc++) {
    80004298:	e0043783          	ld	a5,-512(s0)
    8000429c:	6388                	ld	a0,0(a5)
  sp = sz;
    8000429e:	8952                	mv	s2,s4
  for(argc = 0; argv[argc]; argc++) {
    800042a0:	4481                	li	s1,0
    ustack[argc] = sp;
    800042a2:	e9040c93          	addi	s9,s0,-368
    if(argc >= MAXARG)
    800042a6:	02000c13          	li	s8,32
  for(argc = 0; argv[argc]; argc++) {
    800042aa:	c135                	beqz	a0,8000430e <exec+0x2ba>
    sp -= strlen(argv[argc]) + 1;
    800042ac:	ffffc097          	auipc	ra,0xffffc
    800042b0:	05a080e7          	jalr	90(ra) # 80000306 <strlen>
    800042b4:	0015079b          	addiw	a5,a0,1
    800042b8:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800042bc:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    800042c0:	13796e63          	bltu	s2,s7,800043fc <exec+0x3a8>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800042c4:	e0043d83          	ld	s11,-512(s0)
    800042c8:	000db983          	ld	s3,0(s11)
    800042cc:	854e                	mv	a0,s3
    800042ce:	ffffc097          	auipc	ra,0xffffc
    800042d2:	038080e7          	jalr	56(ra) # 80000306 <strlen>
    800042d6:	0015069b          	addiw	a3,a0,1
    800042da:	864e                	mv	a2,s3
    800042dc:	85ca                	mv	a1,s2
    800042de:	855a                	mv	a0,s6
    800042e0:	ffffd097          	auipc	ra,0xffffd
    800042e4:	86e080e7          	jalr	-1938(ra) # 80000b4e <copyout>
    800042e8:	10054c63          	bltz	a0,80004400 <exec+0x3ac>
    ustack[argc] = sp;
    800042ec:	00349793          	slli	a5,s1,0x3
    800042f0:	97e6                	add	a5,a5,s9
    800042f2:	0127b023          	sd	s2,0(a5) # fffffffffffff000 <end+0xffffffff7ffd8dc0>
  for(argc = 0; argv[argc]; argc++) {
    800042f6:	0485                	addi	s1,s1,1
    800042f8:	008d8793          	addi	a5,s11,8
    800042fc:	e0f43023          	sd	a5,-512(s0)
    80004300:	008db503          	ld	a0,8(s11)
    80004304:	c509                	beqz	a0,8000430e <exec+0x2ba>
    if(argc >= MAXARG)
    80004306:	fb8493e3          	bne	s1,s8,800042ac <exec+0x258>
  sz = sz1;
    8000430a:	89d2                	mv	s3,s4
    8000430c:	bfa1                	j	80004264 <exec+0x210>
  ustack[argc] = 0;
    8000430e:	00349793          	slli	a5,s1,0x3
    80004312:	f9078793          	addi	a5,a5,-112
    80004316:	97a2                	add	a5,a5,s0
    80004318:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    8000431c:	00148693          	addi	a3,s1,1
    80004320:	068e                	slli	a3,a3,0x3
    80004322:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004326:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    8000432a:	89d2                	mv	s3,s4
  if(sp < stackbase)
    8000432c:	f3796ce3          	bltu	s2,s7,80004264 <exec+0x210>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004330:	e9040613          	addi	a2,s0,-368
    80004334:	85ca                	mv	a1,s2
    80004336:	855a                	mv	a0,s6
    80004338:	ffffd097          	auipc	ra,0xffffd
    8000433c:	816080e7          	jalr	-2026(ra) # 80000b4e <copyout>
    80004340:	f20542e3          	bltz	a0,80004264 <exec+0x210>
  p->trapframe->a1 = sp;
    80004344:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80004348:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    8000434c:	df043783          	ld	a5,-528(s0)
    80004350:	0007c703          	lbu	a4,0(a5)
    80004354:	cf11                	beqz	a4,80004370 <exec+0x31c>
    80004356:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004358:	02f00693          	li	a3,47
    8000435c:	a029                	j	80004366 <exec+0x312>
  for(last=s=path; *s; s++)
    8000435e:	0785                	addi	a5,a5,1
    80004360:	fff7c703          	lbu	a4,-1(a5)
    80004364:	c711                	beqz	a4,80004370 <exec+0x31c>
    if(*s == '/')
    80004366:	fed71ce3          	bne	a4,a3,8000435e <exec+0x30a>
      last = s+1;
    8000436a:	def43823          	sd	a5,-528(s0)
    8000436e:	bfc5                	j	8000435e <exec+0x30a>
  safestrcpy(p->name, last, sizeof(p->name));
    80004370:	4641                	li	a2,16
    80004372:	df043583          	ld	a1,-528(s0)
    80004376:	158a8513          	addi	a0,s5,344
    8000437a:	ffffc097          	auipc	ra,0xffffc
    8000437e:	f56080e7          	jalr	-170(ra) # 800002d0 <safestrcpy>
  oldpagetable = p->pagetable;
    80004382:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004386:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    8000438a:	054ab423          	sd	s4,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    8000438e:	058ab783          	ld	a5,88(s5)
    80004392:	e6843703          	ld	a4,-408(s0)
    80004396:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004398:	058ab783          	ld	a5,88(s5)
    8000439c:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800043a0:	85ea                	mv	a1,s10
    800043a2:	ffffd097          	auipc	ra,0xffffd
    800043a6:	c60080e7          	jalr	-928(ra) # 80001002 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800043aa:	0004851b          	sext.w	a0,s1
    800043ae:	79fe                	ld	s3,504(sp)
    800043b0:	7a5e                	ld	s4,496(sp)
    800043b2:	7abe                	ld	s5,488(sp)
    800043b4:	7b1e                	ld	s6,480(sp)
    800043b6:	6bfe                	ld	s7,472(sp)
    800043b8:	6c5e                	ld	s8,464(sp)
    800043ba:	6cbe                	ld	s9,456(sp)
    800043bc:	6d1e                	ld	s10,448(sp)
    800043be:	7dfa                	ld	s11,440(sp)
    800043c0:	b30d                	j	800040e2 <exec+0x8e>
    800043c2:	7b1e                	ld	s6,480(sp)
    800043c4:	b321                	j	800040cc <exec+0x78>
    800043c6:	de943c23          	sd	s1,-520(s0)
    proc_freepagetable(pagetable, sz);
    800043ca:	df843583          	ld	a1,-520(s0)
    800043ce:	855a                	mv	a0,s6
    800043d0:	ffffd097          	auipc	ra,0xffffd
    800043d4:	c32080e7          	jalr	-974(ra) # 80001002 <proc_freepagetable>
  if(ip){
    800043d8:	79fe                	ld	s3,504(sp)
    800043da:	7abe                	ld	s5,488(sp)
    800043dc:	7b1e                	ld	s6,480(sp)
    800043de:	6bfe                	ld	s7,472(sp)
    800043e0:	6c5e                	ld	s8,464(sp)
    800043e2:	6cbe                	ld	s9,456(sp)
    800043e4:	6d1e                	ld	s10,448(sp)
    800043e6:	7dfa                	ld	s11,440(sp)
    800043e8:	b1d5                	j	800040cc <exec+0x78>
    800043ea:	de943c23          	sd	s1,-520(s0)
    800043ee:	bff1                	j	800043ca <exec+0x376>
    800043f0:	de943c23          	sd	s1,-520(s0)
    800043f4:	bfd9                	j	800043ca <exec+0x376>
    800043f6:	de943c23          	sd	s1,-520(s0)
    800043fa:	bfc1                	j	800043ca <exec+0x376>
  sz = sz1;
    800043fc:	89d2                	mv	s3,s4
    800043fe:	b59d                	j	80004264 <exec+0x210>
    80004400:	89d2                	mv	s3,s4
    80004402:	b58d                	j	80004264 <exec+0x210>

0000000080004404 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004404:	7179                	addi	sp,sp,-48
    80004406:	f406                	sd	ra,40(sp)
    80004408:	f022                	sd	s0,32(sp)
    8000440a:	ec26                	sd	s1,24(sp)
    8000440c:	e84a                	sd	s2,16(sp)
    8000440e:	1800                	addi	s0,sp,48
    80004410:	892e                	mv	s2,a1
    80004412:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80004414:	fdc40593          	addi	a1,s0,-36
    80004418:	ffffe097          	auipc	ra,0xffffe
    8000441c:	b48080e7          	jalr	-1208(ra) # 80001f60 <argint>
    80004420:	04054063          	bltz	a0,80004460 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004424:	fdc42703          	lw	a4,-36(s0)
    80004428:	47bd                	li	a5,15
    8000442a:	02e7ed63          	bltu	a5,a4,80004464 <argfd+0x60>
    8000442e:	ffffd097          	auipc	ra,0xffffd
    80004432:	a74080e7          	jalr	-1420(ra) # 80000ea2 <myproc>
    80004436:	fdc42703          	lw	a4,-36(s0)
    8000443a:	01a70793          	addi	a5,a4,26
    8000443e:	078e                	slli	a5,a5,0x3
    80004440:	953e                	add	a0,a0,a5
    80004442:	611c                	ld	a5,0(a0)
    80004444:	c395                	beqz	a5,80004468 <argfd+0x64>
    return -1;
  if(pfd)
    80004446:	00090463          	beqz	s2,8000444e <argfd+0x4a>
    *pfd = fd;
    8000444a:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    8000444e:	4501                	li	a0,0
  if(pf)
    80004450:	c091                	beqz	s1,80004454 <argfd+0x50>
    *pf = f;
    80004452:	e09c                	sd	a5,0(s1)
}
    80004454:	70a2                	ld	ra,40(sp)
    80004456:	7402                	ld	s0,32(sp)
    80004458:	64e2                	ld	s1,24(sp)
    8000445a:	6942                	ld	s2,16(sp)
    8000445c:	6145                	addi	sp,sp,48
    8000445e:	8082                	ret
    return -1;
    80004460:	557d                	li	a0,-1
    80004462:	bfcd                	j	80004454 <argfd+0x50>
    return -1;
    80004464:	557d                	li	a0,-1
    80004466:	b7fd                	j	80004454 <argfd+0x50>
    80004468:	557d                	li	a0,-1
    8000446a:	b7ed                	j	80004454 <argfd+0x50>

000000008000446c <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    8000446c:	1101                	addi	sp,sp,-32
    8000446e:	ec06                	sd	ra,24(sp)
    80004470:	e822                	sd	s0,16(sp)
    80004472:	e426                	sd	s1,8(sp)
    80004474:	1000                	addi	s0,sp,32
    80004476:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004478:	ffffd097          	auipc	ra,0xffffd
    8000447c:	a2a080e7          	jalr	-1494(ra) # 80000ea2 <myproc>
    80004480:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004482:	0d050793          	addi	a5,a0,208
    80004486:	4501                	li	a0,0
    80004488:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    8000448a:	6398                	ld	a4,0(a5)
    8000448c:	cb19                	beqz	a4,800044a2 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    8000448e:	2505                	addiw	a0,a0,1
    80004490:	07a1                	addi	a5,a5,8
    80004492:	fed51ce3          	bne	a0,a3,8000448a <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004496:	557d                	li	a0,-1
}
    80004498:	60e2                	ld	ra,24(sp)
    8000449a:	6442                	ld	s0,16(sp)
    8000449c:	64a2                	ld	s1,8(sp)
    8000449e:	6105                	addi	sp,sp,32
    800044a0:	8082                	ret
      p->ofile[fd] = f;
    800044a2:	01a50793          	addi	a5,a0,26
    800044a6:	078e                	slli	a5,a5,0x3
    800044a8:	963e                	add	a2,a2,a5
    800044aa:	e204                	sd	s1,0(a2)
      return fd;
    800044ac:	b7f5                	j	80004498 <fdalloc+0x2c>

00000000800044ae <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800044ae:	715d                	addi	sp,sp,-80
    800044b0:	e486                	sd	ra,72(sp)
    800044b2:	e0a2                	sd	s0,64(sp)
    800044b4:	fc26                	sd	s1,56(sp)
    800044b6:	f84a                	sd	s2,48(sp)
    800044b8:	f44e                	sd	s3,40(sp)
    800044ba:	f052                	sd	s4,32(sp)
    800044bc:	ec56                	sd	s5,24(sp)
    800044be:	0880                	addi	s0,sp,80
    800044c0:	8aae                	mv	s5,a1
    800044c2:	8a32                	mv	s4,a2
    800044c4:	89b6                	mv	s3,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800044c6:	fb040593          	addi	a1,s0,-80
    800044ca:	fffff097          	auipc	ra,0xfffff
    800044ce:	df4080e7          	jalr	-524(ra) # 800032be <nameiparent>
    800044d2:	892a                	mv	s2,a0
    800044d4:	12050c63          	beqz	a0,8000460c <create+0x15e>
    return 0;

  ilock(dp);
    800044d8:	ffffe097          	auipc	ra,0xffffe
    800044dc:	5dc080e7          	jalr	1500(ra) # 80002ab4 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800044e0:	4601                	li	a2,0
    800044e2:	fb040593          	addi	a1,s0,-80
    800044e6:	854a                	mv	a0,s2
    800044e8:	fffff097          	auipc	ra,0xfffff
    800044ec:	abc080e7          	jalr	-1348(ra) # 80002fa4 <dirlookup>
    800044f0:	84aa                	mv	s1,a0
    800044f2:	c539                	beqz	a0,80004540 <create+0x92>
    iunlockput(dp);
    800044f4:	854a                	mv	a0,s2
    800044f6:	fffff097          	auipc	ra,0xfffff
    800044fa:	824080e7          	jalr	-2012(ra) # 80002d1a <iunlockput>
    ilock(ip);
    800044fe:	8526                	mv	a0,s1
    80004500:	ffffe097          	auipc	ra,0xffffe
    80004504:	5b4080e7          	jalr	1460(ra) # 80002ab4 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004508:	4789                	li	a5,2
    8000450a:	02fa9463          	bne	s5,a5,80004532 <create+0x84>
    8000450e:	0444d783          	lhu	a5,68(s1)
    80004512:	37f9                	addiw	a5,a5,-2
    80004514:	17c2                	slli	a5,a5,0x30
    80004516:	93c1                	srli	a5,a5,0x30
    80004518:	4705                	li	a4,1
    8000451a:	00f76c63          	bltu	a4,a5,80004532 <create+0x84>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    8000451e:	8526                	mv	a0,s1
    80004520:	60a6                	ld	ra,72(sp)
    80004522:	6406                	ld	s0,64(sp)
    80004524:	74e2                	ld	s1,56(sp)
    80004526:	7942                	ld	s2,48(sp)
    80004528:	79a2                	ld	s3,40(sp)
    8000452a:	7a02                	ld	s4,32(sp)
    8000452c:	6ae2                	ld	s5,24(sp)
    8000452e:	6161                	addi	sp,sp,80
    80004530:	8082                	ret
    iunlockput(ip);
    80004532:	8526                	mv	a0,s1
    80004534:	ffffe097          	auipc	ra,0xffffe
    80004538:	7e6080e7          	jalr	2022(ra) # 80002d1a <iunlockput>
    return 0;
    8000453c:	4481                	li	s1,0
    8000453e:	b7c5                	j	8000451e <create+0x70>
  if((ip = ialloc(dp->dev, type)) == 0)
    80004540:	85d6                	mv	a1,s5
    80004542:	00092503          	lw	a0,0(s2)
    80004546:	ffffe097          	auipc	ra,0xffffe
    8000454a:	3da080e7          	jalr	986(ra) # 80002920 <ialloc>
    8000454e:	84aa                	mv	s1,a0
    80004550:	c139                	beqz	a0,80004596 <create+0xe8>
  ilock(ip);
    80004552:	ffffe097          	auipc	ra,0xffffe
    80004556:	562080e7          	jalr	1378(ra) # 80002ab4 <ilock>
  ip->major = major;
    8000455a:	05449323          	sh	s4,70(s1)
  ip->minor = minor;
    8000455e:	05349423          	sh	s3,72(s1)
  ip->nlink = 1;
    80004562:	4985                	li	s3,1
    80004564:	05349523          	sh	s3,74(s1)
  iupdate(ip);
    80004568:	8526                	mv	a0,s1
    8000456a:	ffffe097          	auipc	ra,0xffffe
    8000456e:	47e080e7          	jalr	1150(ra) # 800029e8 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004572:	033a8a63          	beq	s5,s3,800045a6 <create+0xf8>
  if(dirlink(dp, name, ip->inum) < 0)
    80004576:	40d0                	lw	a2,4(s1)
    80004578:	fb040593          	addi	a1,s0,-80
    8000457c:	854a                	mv	a0,s2
    8000457e:	fffff097          	auipc	ra,0xfffff
    80004582:	c4c080e7          	jalr	-948(ra) # 800031ca <dirlink>
    80004586:	06054b63          	bltz	a0,800045fc <create+0x14e>
  iunlockput(dp);
    8000458a:	854a                	mv	a0,s2
    8000458c:	ffffe097          	auipc	ra,0xffffe
    80004590:	78e080e7          	jalr	1934(ra) # 80002d1a <iunlockput>
  return ip;
    80004594:	b769                	j	8000451e <create+0x70>
    panic("create: ialloc");
    80004596:	00004517          	auipc	a0,0x4
    8000459a:	fda50513          	addi	a0,a0,-38 # 80008570 <etext+0x570>
    8000459e:	00001097          	auipc	ra,0x1
    800045a2:	6d4080e7          	jalr	1748(ra) # 80005c72 <panic>
    dp->nlink++;  // for ".."
    800045a6:	04a95783          	lhu	a5,74(s2)
    800045aa:	2785                	addiw	a5,a5,1
    800045ac:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    800045b0:	854a                	mv	a0,s2
    800045b2:	ffffe097          	auipc	ra,0xffffe
    800045b6:	436080e7          	jalr	1078(ra) # 800029e8 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800045ba:	40d0                	lw	a2,4(s1)
    800045bc:	00004597          	auipc	a1,0x4
    800045c0:	fc458593          	addi	a1,a1,-60 # 80008580 <etext+0x580>
    800045c4:	8526                	mv	a0,s1
    800045c6:	fffff097          	auipc	ra,0xfffff
    800045ca:	c04080e7          	jalr	-1020(ra) # 800031ca <dirlink>
    800045ce:	00054f63          	bltz	a0,800045ec <create+0x13e>
    800045d2:	00492603          	lw	a2,4(s2)
    800045d6:	00004597          	auipc	a1,0x4
    800045da:	fb258593          	addi	a1,a1,-78 # 80008588 <etext+0x588>
    800045de:	8526                	mv	a0,s1
    800045e0:	fffff097          	auipc	ra,0xfffff
    800045e4:	bea080e7          	jalr	-1046(ra) # 800031ca <dirlink>
    800045e8:	f80557e3          	bgez	a0,80004576 <create+0xc8>
      panic("create dots");
    800045ec:	00004517          	auipc	a0,0x4
    800045f0:	fa450513          	addi	a0,a0,-92 # 80008590 <etext+0x590>
    800045f4:	00001097          	auipc	ra,0x1
    800045f8:	67e080e7          	jalr	1662(ra) # 80005c72 <panic>
    panic("create: dirlink");
    800045fc:	00004517          	auipc	a0,0x4
    80004600:	fa450513          	addi	a0,a0,-92 # 800085a0 <etext+0x5a0>
    80004604:	00001097          	auipc	ra,0x1
    80004608:	66e080e7          	jalr	1646(ra) # 80005c72 <panic>
    return 0;
    8000460c:	84aa                	mv	s1,a0
    8000460e:	bf01                	j	8000451e <create+0x70>

0000000080004610 <sys_dup>:
{
    80004610:	7179                	addi	sp,sp,-48
    80004612:	f406                	sd	ra,40(sp)
    80004614:	f022                	sd	s0,32(sp)
    80004616:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004618:	fd840613          	addi	a2,s0,-40
    8000461c:	4581                	li	a1,0
    8000461e:	4501                	li	a0,0
    80004620:	00000097          	auipc	ra,0x0
    80004624:	de4080e7          	jalr	-540(ra) # 80004404 <argfd>
    return -1;
    80004628:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000462a:	02054763          	bltz	a0,80004658 <sys_dup+0x48>
    8000462e:	ec26                	sd	s1,24(sp)
    80004630:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80004632:	fd843903          	ld	s2,-40(s0)
    80004636:	854a                	mv	a0,s2
    80004638:	00000097          	auipc	ra,0x0
    8000463c:	e34080e7          	jalr	-460(ra) # 8000446c <fdalloc>
    80004640:	84aa                	mv	s1,a0
    return -1;
    80004642:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004644:	00054f63          	bltz	a0,80004662 <sys_dup+0x52>
  filedup(f);
    80004648:	854a                	mv	a0,s2
    8000464a:	fffff097          	auipc	ra,0xfffff
    8000464e:	2da080e7          	jalr	730(ra) # 80003924 <filedup>
  return fd;
    80004652:	87a6                	mv	a5,s1
    80004654:	64e2                	ld	s1,24(sp)
    80004656:	6942                	ld	s2,16(sp)
}
    80004658:	853e                	mv	a0,a5
    8000465a:	70a2                	ld	ra,40(sp)
    8000465c:	7402                	ld	s0,32(sp)
    8000465e:	6145                	addi	sp,sp,48
    80004660:	8082                	ret
    80004662:	64e2                	ld	s1,24(sp)
    80004664:	6942                	ld	s2,16(sp)
    80004666:	bfcd                	j	80004658 <sys_dup+0x48>

0000000080004668 <sys_read>:
{
    80004668:	7179                	addi	sp,sp,-48
    8000466a:	f406                	sd	ra,40(sp)
    8000466c:	f022                	sd	s0,32(sp)
    8000466e:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004670:	fe840613          	addi	a2,s0,-24
    80004674:	4581                	li	a1,0
    80004676:	4501                	li	a0,0
    80004678:	00000097          	auipc	ra,0x0
    8000467c:	d8c080e7          	jalr	-628(ra) # 80004404 <argfd>
    return -1;
    80004680:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004682:	04054163          	bltz	a0,800046c4 <sys_read+0x5c>
    80004686:	fe440593          	addi	a1,s0,-28
    8000468a:	4509                	li	a0,2
    8000468c:	ffffe097          	auipc	ra,0xffffe
    80004690:	8d4080e7          	jalr	-1836(ra) # 80001f60 <argint>
    return -1;
    80004694:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004696:	02054763          	bltz	a0,800046c4 <sys_read+0x5c>
    8000469a:	fd840593          	addi	a1,s0,-40
    8000469e:	4505                	li	a0,1
    800046a0:	ffffe097          	auipc	ra,0xffffe
    800046a4:	8e2080e7          	jalr	-1822(ra) # 80001f82 <argaddr>
    return -1;
    800046a8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046aa:	00054d63          	bltz	a0,800046c4 <sys_read+0x5c>
  return fileread(f, p, n);
    800046ae:	fe442603          	lw	a2,-28(s0)
    800046b2:	fd843583          	ld	a1,-40(s0)
    800046b6:	fe843503          	ld	a0,-24(s0)
    800046ba:	fffff097          	auipc	ra,0xfffff
    800046be:	410080e7          	jalr	1040(ra) # 80003aca <fileread>
    800046c2:	87aa                	mv	a5,a0
}
    800046c4:	853e                	mv	a0,a5
    800046c6:	70a2                	ld	ra,40(sp)
    800046c8:	7402                	ld	s0,32(sp)
    800046ca:	6145                	addi	sp,sp,48
    800046cc:	8082                	ret

00000000800046ce <sys_write>:
{
    800046ce:	7179                	addi	sp,sp,-48
    800046d0:	f406                	sd	ra,40(sp)
    800046d2:	f022                	sd	s0,32(sp)
    800046d4:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046d6:	fe840613          	addi	a2,s0,-24
    800046da:	4581                	li	a1,0
    800046dc:	4501                	li	a0,0
    800046de:	00000097          	auipc	ra,0x0
    800046e2:	d26080e7          	jalr	-730(ra) # 80004404 <argfd>
    return -1;
    800046e6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046e8:	04054163          	bltz	a0,8000472a <sys_write+0x5c>
    800046ec:	fe440593          	addi	a1,s0,-28
    800046f0:	4509                	li	a0,2
    800046f2:	ffffe097          	auipc	ra,0xffffe
    800046f6:	86e080e7          	jalr	-1938(ra) # 80001f60 <argint>
    return -1;
    800046fa:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046fc:	02054763          	bltz	a0,8000472a <sys_write+0x5c>
    80004700:	fd840593          	addi	a1,s0,-40
    80004704:	4505                	li	a0,1
    80004706:	ffffe097          	auipc	ra,0xffffe
    8000470a:	87c080e7          	jalr	-1924(ra) # 80001f82 <argaddr>
    return -1;
    8000470e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004710:	00054d63          	bltz	a0,8000472a <sys_write+0x5c>
  return filewrite(f, p, n);
    80004714:	fe442603          	lw	a2,-28(s0)
    80004718:	fd843583          	ld	a1,-40(s0)
    8000471c:	fe843503          	ld	a0,-24(s0)
    80004720:	fffff097          	auipc	ra,0xfffff
    80004724:	47c080e7          	jalr	1148(ra) # 80003b9c <filewrite>
    80004728:	87aa                	mv	a5,a0
}
    8000472a:	853e                	mv	a0,a5
    8000472c:	70a2                	ld	ra,40(sp)
    8000472e:	7402                	ld	s0,32(sp)
    80004730:	6145                	addi	sp,sp,48
    80004732:	8082                	ret

0000000080004734 <sys_close>:
{
    80004734:	1101                	addi	sp,sp,-32
    80004736:	ec06                	sd	ra,24(sp)
    80004738:	e822                	sd	s0,16(sp)
    8000473a:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    8000473c:	fe040613          	addi	a2,s0,-32
    80004740:	fec40593          	addi	a1,s0,-20
    80004744:	4501                	li	a0,0
    80004746:	00000097          	auipc	ra,0x0
    8000474a:	cbe080e7          	jalr	-834(ra) # 80004404 <argfd>
    return -1;
    8000474e:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004750:	02054463          	bltz	a0,80004778 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004754:	ffffc097          	auipc	ra,0xffffc
    80004758:	74e080e7          	jalr	1870(ra) # 80000ea2 <myproc>
    8000475c:	fec42783          	lw	a5,-20(s0)
    80004760:	07e9                	addi	a5,a5,26
    80004762:	078e                	slli	a5,a5,0x3
    80004764:	953e                	add	a0,a0,a5
    80004766:	00053023          	sd	zero,0(a0)
  fileclose(f);
    8000476a:	fe043503          	ld	a0,-32(s0)
    8000476e:	fffff097          	auipc	ra,0xfffff
    80004772:	208080e7          	jalr	520(ra) # 80003976 <fileclose>
  return 0;
    80004776:	4781                	li	a5,0
}
    80004778:	853e                	mv	a0,a5
    8000477a:	60e2                	ld	ra,24(sp)
    8000477c:	6442                	ld	s0,16(sp)
    8000477e:	6105                	addi	sp,sp,32
    80004780:	8082                	ret

0000000080004782 <sys_fstat>:
{
    80004782:	1101                	addi	sp,sp,-32
    80004784:	ec06                	sd	ra,24(sp)
    80004786:	e822                	sd	s0,16(sp)
    80004788:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000478a:	fe840613          	addi	a2,s0,-24
    8000478e:	4581                	li	a1,0
    80004790:	4501                	li	a0,0
    80004792:	00000097          	auipc	ra,0x0
    80004796:	c72080e7          	jalr	-910(ra) # 80004404 <argfd>
    return -1;
    8000479a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000479c:	02054563          	bltz	a0,800047c6 <sys_fstat+0x44>
    800047a0:	fe040593          	addi	a1,s0,-32
    800047a4:	4505                	li	a0,1
    800047a6:	ffffd097          	auipc	ra,0xffffd
    800047aa:	7dc080e7          	jalr	2012(ra) # 80001f82 <argaddr>
    return -1;
    800047ae:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800047b0:	00054b63          	bltz	a0,800047c6 <sys_fstat+0x44>
  return filestat(f, st);
    800047b4:	fe043583          	ld	a1,-32(s0)
    800047b8:	fe843503          	ld	a0,-24(s0)
    800047bc:	fffff097          	auipc	ra,0xfffff
    800047c0:	298080e7          	jalr	664(ra) # 80003a54 <filestat>
    800047c4:	87aa                	mv	a5,a0
}
    800047c6:	853e                	mv	a0,a5
    800047c8:	60e2                	ld	ra,24(sp)
    800047ca:	6442                	ld	s0,16(sp)
    800047cc:	6105                	addi	sp,sp,32
    800047ce:	8082                	ret

00000000800047d0 <sys_link>:
{
    800047d0:	7169                	addi	sp,sp,-304
    800047d2:	f606                	sd	ra,296(sp)
    800047d4:	f222                	sd	s0,288(sp)
    800047d6:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800047d8:	08000613          	li	a2,128
    800047dc:	ed040593          	addi	a1,s0,-304
    800047e0:	4501                	li	a0,0
    800047e2:	ffffd097          	auipc	ra,0xffffd
    800047e6:	7c2080e7          	jalr	1986(ra) # 80001fa4 <argstr>
    return -1;
    800047ea:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800047ec:	12054663          	bltz	a0,80004918 <sys_link+0x148>
    800047f0:	08000613          	li	a2,128
    800047f4:	f5040593          	addi	a1,s0,-176
    800047f8:	4505                	li	a0,1
    800047fa:	ffffd097          	auipc	ra,0xffffd
    800047fe:	7aa080e7          	jalr	1962(ra) # 80001fa4 <argstr>
    return -1;
    80004802:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004804:	10054a63          	bltz	a0,80004918 <sys_link+0x148>
    80004808:	ee26                	sd	s1,280(sp)
  begin_op();
    8000480a:	fffff097          	auipc	ra,0xfffff
    8000480e:	c9c080e7          	jalr	-868(ra) # 800034a6 <begin_op>
  if((ip = namei(old)) == 0){
    80004812:	ed040513          	addi	a0,s0,-304
    80004816:	fffff097          	auipc	ra,0xfffff
    8000481a:	a8a080e7          	jalr	-1398(ra) # 800032a0 <namei>
    8000481e:	84aa                	mv	s1,a0
    80004820:	c949                	beqz	a0,800048b2 <sys_link+0xe2>
  ilock(ip);
    80004822:	ffffe097          	auipc	ra,0xffffe
    80004826:	292080e7          	jalr	658(ra) # 80002ab4 <ilock>
  if(ip->type == T_DIR){
    8000482a:	04449703          	lh	a4,68(s1)
    8000482e:	4785                	li	a5,1
    80004830:	08f70863          	beq	a4,a5,800048c0 <sys_link+0xf0>
    80004834:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004836:	04a4d783          	lhu	a5,74(s1)
    8000483a:	2785                	addiw	a5,a5,1
    8000483c:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004840:	8526                	mv	a0,s1
    80004842:	ffffe097          	auipc	ra,0xffffe
    80004846:	1a6080e7          	jalr	422(ra) # 800029e8 <iupdate>
  iunlock(ip);
    8000484a:	8526                	mv	a0,s1
    8000484c:	ffffe097          	auipc	ra,0xffffe
    80004850:	32e080e7          	jalr	814(ra) # 80002b7a <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004854:	fd040593          	addi	a1,s0,-48
    80004858:	f5040513          	addi	a0,s0,-176
    8000485c:	fffff097          	auipc	ra,0xfffff
    80004860:	a62080e7          	jalr	-1438(ra) # 800032be <nameiparent>
    80004864:	892a                	mv	s2,a0
    80004866:	cd35                	beqz	a0,800048e2 <sys_link+0x112>
  ilock(dp);
    80004868:	ffffe097          	auipc	ra,0xffffe
    8000486c:	24c080e7          	jalr	588(ra) # 80002ab4 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004870:	00092703          	lw	a4,0(s2)
    80004874:	409c                	lw	a5,0(s1)
    80004876:	06f71163          	bne	a4,a5,800048d8 <sys_link+0x108>
    8000487a:	40d0                	lw	a2,4(s1)
    8000487c:	fd040593          	addi	a1,s0,-48
    80004880:	854a                	mv	a0,s2
    80004882:	fffff097          	auipc	ra,0xfffff
    80004886:	948080e7          	jalr	-1720(ra) # 800031ca <dirlink>
    8000488a:	04054763          	bltz	a0,800048d8 <sys_link+0x108>
  iunlockput(dp);
    8000488e:	854a                	mv	a0,s2
    80004890:	ffffe097          	auipc	ra,0xffffe
    80004894:	48a080e7          	jalr	1162(ra) # 80002d1a <iunlockput>
  iput(ip);
    80004898:	8526                	mv	a0,s1
    8000489a:	ffffe097          	auipc	ra,0xffffe
    8000489e:	3d8080e7          	jalr	984(ra) # 80002c72 <iput>
  end_op();
    800048a2:	fffff097          	auipc	ra,0xfffff
    800048a6:	c7e080e7          	jalr	-898(ra) # 80003520 <end_op>
  return 0;
    800048aa:	4781                	li	a5,0
    800048ac:	64f2                	ld	s1,280(sp)
    800048ae:	6952                	ld	s2,272(sp)
    800048b0:	a0a5                	j	80004918 <sys_link+0x148>
    end_op();
    800048b2:	fffff097          	auipc	ra,0xfffff
    800048b6:	c6e080e7          	jalr	-914(ra) # 80003520 <end_op>
    return -1;
    800048ba:	57fd                	li	a5,-1
    800048bc:	64f2                	ld	s1,280(sp)
    800048be:	a8a9                	j	80004918 <sys_link+0x148>
    iunlockput(ip);
    800048c0:	8526                	mv	a0,s1
    800048c2:	ffffe097          	auipc	ra,0xffffe
    800048c6:	458080e7          	jalr	1112(ra) # 80002d1a <iunlockput>
    end_op();
    800048ca:	fffff097          	auipc	ra,0xfffff
    800048ce:	c56080e7          	jalr	-938(ra) # 80003520 <end_op>
    return -1;
    800048d2:	57fd                	li	a5,-1
    800048d4:	64f2                	ld	s1,280(sp)
    800048d6:	a089                	j	80004918 <sys_link+0x148>
    iunlockput(dp);
    800048d8:	854a                	mv	a0,s2
    800048da:	ffffe097          	auipc	ra,0xffffe
    800048de:	440080e7          	jalr	1088(ra) # 80002d1a <iunlockput>
  ilock(ip);
    800048e2:	8526                	mv	a0,s1
    800048e4:	ffffe097          	auipc	ra,0xffffe
    800048e8:	1d0080e7          	jalr	464(ra) # 80002ab4 <ilock>
  ip->nlink--;
    800048ec:	04a4d783          	lhu	a5,74(s1)
    800048f0:	37fd                	addiw	a5,a5,-1
    800048f2:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800048f6:	8526                	mv	a0,s1
    800048f8:	ffffe097          	auipc	ra,0xffffe
    800048fc:	0f0080e7          	jalr	240(ra) # 800029e8 <iupdate>
  iunlockput(ip);
    80004900:	8526                	mv	a0,s1
    80004902:	ffffe097          	auipc	ra,0xffffe
    80004906:	418080e7          	jalr	1048(ra) # 80002d1a <iunlockput>
  end_op();
    8000490a:	fffff097          	auipc	ra,0xfffff
    8000490e:	c16080e7          	jalr	-1002(ra) # 80003520 <end_op>
  return -1;
    80004912:	57fd                	li	a5,-1
    80004914:	64f2                	ld	s1,280(sp)
    80004916:	6952                	ld	s2,272(sp)
}
    80004918:	853e                	mv	a0,a5
    8000491a:	70b2                	ld	ra,296(sp)
    8000491c:	7412                	ld	s0,288(sp)
    8000491e:	6155                	addi	sp,sp,304
    80004920:	8082                	ret

0000000080004922 <sys_unlink>:
{
    80004922:	7111                	addi	sp,sp,-256
    80004924:	fd86                	sd	ra,248(sp)
    80004926:	f9a2                	sd	s0,240(sp)
    80004928:	0200                	addi	s0,sp,256
  if(argstr(0, path, MAXPATH) < 0)
    8000492a:	08000613          	li	a2,128
    8000492e:	f2040593          	addi	a1,s0,-224
    80004932:	4501                	li	a0,0
    80004934:	ffffd097          	auipc	ra,0xffffd
    80004938:	670080e7          	jalr	1648(ra) # 80001fa4 <argstr>
    8000493c:	1c054063          	bltz	a0,80004afc <sys_unlink+0x1da>
    80004940:	f5a6                	sd	s1,232(sp)
  begin_op();
    80004942:	fffff097          	auipc	ra,0xfffff
    80004946:	b64080e7          	jalr	-1180(ra) # 800034a6 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    8000494a:	fa040593          	addi	a1,s0,-96
    8000494e:	f2040513          	addi	a0,s0,-224
    80004952:	fffff097          	auipc	ra,0xfffff
    80004956:	96c080e7          	jalr	-1684(ra) # 800032be <nameiparent>
    8000495a:	84aa                	mv	s1,a0
    8000495c:	c165                	beqz	a0,80004a3c <sys_unlink+0x11a>
  ilock(dp);
    8000495e:	ffffe097          	auipc	ra,0xffffe
    80004962:	156080e7          	jalr	342(ra) # 80002ab4 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004966:	00004597          	auipc	a1,0x4
    8000496a:	c1a58593          	addi	a1,a1,-998 # 80008580 <etext+0x580>
    8000496e:	fa040513          	addi	a0,s0,-96
    80004972:	ffffe097          	auipc	ra,0xffffe
    80004976:	618080e7          	jalr	1560(ra) # 80002f8a <namecmp>
    8000497a:	16050263          	beqz	a0,80004ade <sys_unlink+0x1bc>
    8000497e:	00004597          	auipc	a1,0x4
    80004982:	c0a58593          	addi	a1,a1,-1014 # 80008588 <etext+0x588>
    80004986:	fa040513          	addi	a0,s0,-96
    8000498a:	ffffe097          	auipc	ra,0xffffe
    8000498e:	600080e7          	jalr	1536(ra) # 80002f8a <namecmp>
    80004992:	14050663          	beqz	a0,80004ade <sys_unlink+0x1bc>
    80004996:	f1ca                	sd	s2,224(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004998:	f1c40613          	addi	a2,s0,-228
    8000499c:	fa040593          	addi	a1,s0,-96
    800049a0:	8526                	mv	a0,s1
    800049a2:	ffffe097          	auipc	ra,0xffffe
    800049a6:	602080e7          	jalr	1538(ra) # 80002fa4 <dirlookup>
    800049aa:	892a                	mv	s2,a0
    800049ac:	12050863          	beqz	a0,80004adc <sys_unlink+0x1ba>
    800049b0:	edce                	sd	s3,216(sp)
  ilock(ip);
    800049b2:	ffffe097          	auipc	ra,0xffffe
    800049b6:	102080e7          	jalr	258(ra) # 80002ab4 <ilock>
  if(ip->nlink < 1)
    800049ba:	04a91783          	lh	a5,74(s2)
    800049be:	08f05663          	blez	a5,80004a4a <sys_unlink+0x128>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800049c2:	04491703          	lh	a4,68(s2)
    800049c6:	4785                	li	a5,1
    800049c8:	08f70b63          	beq	a4,a5,80004a5e <sys_unlink+0x13c>
  memset(&de, 0, sizeof(de));
    800049cc:	fb040993          	addi	s3,s0,-80
    800049d0:	4641                	li	a2,16
    800049d2:	4581                	li	a1,0
    800049d4:	854e                	mv	a0,s3
    800049d6:	ffffb097          	auipc	ra,0xffffb
    800049da:	7a4080e7          	jalr	1956(ra) # 8000017a <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800049de:	4741                	li	a4,16
    800049e0:	f1c42683          	lw	a3,-228(s0)
    800049e4:	864e                	mv	a2,s3
    800049e6:	4581                	li	a1,0
    800049e8:	8526                	mv	a0,s1
    800049ea:	ffffe097          	auipc	ra,0xffffe
    800049ee:	480080e7          	jalr	1152(ra) # 80002e6a <writei>
    800049f2:	47c1                	li	a5,16
    800049f4:	0af51f63          	bne	a0,a5,80004ab2 <sys_unlink+0x190>
  if(ip->type == T_DIR){
    800049f8:	04491703          	lh	a4,68(s2)
    800049fc:	4785                	li	a5,1
    800049fe:	0cf70463          	beq	a4,a5,80004ac6 <sys_unlink+0x1a4>
  iunlockput(dp);
    80004a02:	8526                	mv	a0,s1
    80004a04:	ffffe097          	auipc	ra,0xffffe
    80004a08:	316080e7          	jalr	790(ra) # 80002d1a <iunlockput>
  ip->nlink--;
    80004a0c:	04a95783          	lhu	a5,74(s2)
    80004a10:	37fd                	addiw	a5,a5,-1
    80004a12:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004a16:	854a                	mv	a0,s2
    80004a18:	ffffe097          	auipc	ra,0xffffe
    80004a1c:	fd0080e7          	jalr	-48(ra) # 800029e8 <iupdate>
  iunlockput(ip);
    80004a20:	854a                	mv	a0,s2
    80004a22:	ffffe097          	auipc	ra,0xffffe
    80004a26:	2f8080e7          	jalr	760(ra) # 80002d1a <iunlockput>
  end_op();
    80004a2a:	fffff097          	auipc	ra,0xfffff
    80004a2e:	af6080e7          	jalr	-1290(ra) # 80003520 <end_op>
  return 0;
    80004a32:	4501                	li	a0,0
    80004a34:	74ae                	ld	s1,232(sp)
    80004a36:	790e                	ld	s2,224(sp)
    80004a38:	69ee                	ld	s3,216(sp)
    80004a3a:	a86d                	j	80004af4 <sys_unlink+0x1d2>
    end_op();
    80004a3c:	fffff097          	auipc	ra,0xfffff
    80004a40:	ae4080e7          	jalr	-1308(ra) # 80003520 <end_op>
    return -1;
    80004a44:	557d                	li	a0,-1
    80004a46:	74ae                	ld	s1,232(sp)
    80004a48:	a075                	j	80004af4 <sys_unlink+0x1d2>
    80004a4a:	e9d2                	sd	s4,208(sp)
    80004a4c:	e5d6                	sd	s5,200(sp)
    panic("unlink: nlink < 1");
    80004a4e:	00004517          	auipc	a0,0x4
    80004a52:	b6250513          	addi	a0,a0,-1182 # 800085b0 <etext+0x5b0>
    80004a56:	00001097          	auipc	ra,0x1
    80004a5a:	21c080e7          	jalr	540(ra) # 80005c72 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004a5e:	04c92703          	lw	a4,76(s2)
    80004a62:	02000793          	li	a5,32
    80004a66:	f6e7f3e3          	bgeu	a5,a4,800049cc <sys_unlink+0xaa>
    80004a6a:	e9d2                	sd	s4,208(sp)
    80004a6c:	e5d6                	sd	s5,200(sp)
    80004a6e:	89be                	mv	s3,a5
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a70:	f0840a93          	addi	s5,s0,-248
    80004a74:	4a41                	li	s4,16
    80004a76:	8752                	mv	a4,s4
    80004a78:	86ce                	mv	a3,s3
    80004a7a:	8656                	mv	a2,s5
    80004a7c:	4581                	li	a1,0
    80004a7e:	854a                	mv	a0,s2
    80004a80:	ffffe097          	auipc	ra,0xffffe
    80004a84:	2f0080e7          	jalr	752(ra) # 80002d70 <readi>
    80004a88:	01451d63          	bne	a0,s4,80004aa2 <sys_unlink+0x180>
    if(de.inum != 0)
    80004a8c:	f0845783          	lhu	a5,-248(s0)
    80004a90:	eba5                	bnez	a5,80004b00 <sys_unlink+0x1de>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004a92:	29c1                	addiw	s3,s3,16
    80004a94:	04c92783          	lw	a5,76(s2)
    80004a98:	fcf9efe3          	bltu	s3,a5,80004a76 <sys_unlink+0x154>
    80004a9c:	6a4e                	ld	s4,208(sp)
    80004a9e:	6aae                	ld	s5,200(sp)
    80004aa0:	b735                	j	800049cc <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004aa2:	00004517          	auipc	a0,0x4
    80004aa6:	b2650513          	addi	a0,a0,-1242 # 800085c8 <etext+0x5c8>
    80004aaa:	00001097          	auipc	ra,0x1
    80004aae:	1c8080e7          	jalr	456(ra) # 80005c72 <panic>
    80004ab2:	e9d2                	sd	s4,208(sp)
    80004ab4:	e5d6                	sd	s5,200(sp)
    panic("unlink: writei");
    80004ab6:	00004517          	auipc	a0,0x4
    80004aba:	b2a50513          	addi	a0,a0,-1238 # 800085e0 <etext+0x5e0>
    80004abe:	00001097          	auipc	ra,0x1
    80004ac2:	1b4080e7          	jalr	436(ra) # 80005c72 <panic>
    dp->nlink--;
    80004ac6:	04a4d783          	lhu	a5,74(s1)
    80004aca:	37fd                	addiw	a5,a5,-1
    80004acc:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004ad0:	8526                	mv	a0,s1
    80004ad2:	ffffe097          	auipc	ra,0xffffe
    80004ad6:	f16080e7          	jalr	-234(ra) # 800029e8 <iupdate>
    80004ada:	b725                	j	80004a02 <sys_unlink+0xe0>
    80004adc:	790e                	ld	s2,224(sp)
  iunlockput(dp);
    80004ade:	8526                	mv	a0,s1
    80004ae0:	ffffe097          	auipc	ra,0xffffe
    80004ae4:	23a080e7          	jalr	570(ra) # 80002d1a <iunlockput>
  end_op();
    80004ae8:	fffff097          	auipc	ra,0xfffff
    80004aec:	a38080e7          	jalr	-1480(ra) # 80003520 <end_op>
  return -1;
    80004af0:	557d                	li	a0,-1
    80004af2:	74ae                	ld	s1,232(sp)
}
    80004af4:	70ee                	ld	ra,248(sp)
    80004af6:	744e                	ld	s0,240(sp)
    80004af8:	6111                	addi	sp,sp,256
    80004afa:	8082                	ret
    return -1;
    80004afc:	557d                	li	a0,-1
    80004afe:	bfdd                	j	80004af4 <sys_unlink+0x1d2>
    iunlockput(ip);
    80004b00:	854a                	mv	a0,s2
    80004b02:	ffffe097          	auipc	ra,0xffffe
    80004b06:	218080e7          	jalr	536(ra) # 80002d1a <iunlockput>
    goto bad;
    80004b0a:	790e                	ld	s2,224(sp)
    80004b0c:	69ee                	ld	s3,216(sp)
    80004b0e:	6a4e                	ld	s4,208(sp)
    80004b10:	6aae                	ld	s5,200(sp)
    80004b12:	b7f1                	j	80004ade <sys_unlink+0x1bc>

0000000080004b14 <sys_open>:

uint64
sys_open(void)
{
    80004b14:	7131                	addi	sp,sp,-192
    80004b16:	fd06                	sd	ra,184(sp)
    80004b18:	f922                	sd	s0,176(sp)
    80004b1a:	f526                	sd	s1,168(sp)
    80004b1c:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004b1e:	08000613          	li	a2,128
    80004b22:	f5040593          	addi	a1,s0,-176
    80004b26:	4501                	li	a0,0
    80004b28:	ffffd097          	auipc	ra,0xffffd
    80004b2c:	47c080e7          	jalr	1148(ra) # 80001fa4 <argstr>
    return -1;
    80004b30:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004b32:	0c054563          	bltz	a0,80004bfc <sys_open+0xe8>
    80004b36:	f4c40593          	addi	a1,s0,-180
    80004b3a:	4505                	li	a0,1
    80004b3c:	ffffd097          	auipc	ra,0xffffd
    80004b40:	424080e7          	jalr	1060(ra) # 80001f60 <argint>
    80004b44:	0a054c63          	bltz	a0,80004bfc <sys_open+0xe8>
    80004b48:	f14a                	sd	s2,160(sp)

  begin_op();
    80004b4a:	fffff097          	auipc	ra,0xfffff
    80004b4e:	95c080e7          	jalr	-1700(ra) # 800034a6 <begin_op>

  if(omode & O_CREATE){
    80004b52:	f4c42783          	lw	a5,-180(s0)
    80004b56:	2007f793          	andi	a5,a5,512
    80004b5a:	cfcd                	beqz	a5,80004c14 <sys_open+0x100>
    ip = create(path, T_FILE, 0, 0);
    80004b5c:	4681                	li	a3,0
    80004b5e:	4601                	li	a2,0
    80004b60:	4589                	li	a1,2
    80004b62:	f5040513          	addi	a0,s0,-176
    80004b66:	00000097          	auipc	ra,0x0
    80004b6a:	948080e7          	jalr	-1720(ra) # 800044ae <create>
    80004b6e:	892a                	mv	s2,a0
    if(ip == 0){
    80004b70:	cd41                	beqz	a0,80004c08 <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004b72:	04491703          	lh	a4,68(s2)
    80004b76:	478d                	li	a5,3
    80004b78:	00f71763          	bne	a4,a5,80004b86 <sys_open+0x72>
    80004b7c:	04695703          	lhu	a4,70(s2)
    80004b80:	47a5                	li	a5,9
    80004b82:	0ee7e063          	bltu	a5,a4,80004c62 <sys_open+0x14e>
    80004b86:	ed4e                	sd	s3,152(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004b88:	fffff097          	auipc	ra,0xfffff
    80004b8c:	d32080e7          	jalr	-718(ra) # 800038ba <filealloc>
    80004b90:	89aa                	mv	s3,a0
    80004b92:	c96d                	beqz	a0,80004c84 <sys_open+0x170>
    80004b94:	00000097          	auipc	ra,0x0
    80004b98:	8d8080e7          	jalr	-1832(ra) # 8000446c <fdalloc>
    80004b9c:	84aa                	mv	s1,a0
    80004b9e:	0c054e63          	bltz	a0,80004c7a <sys_open+0x166>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004ba2:	04491703          	lh	a4,68(s2)
    80004ba6:	478d                	li	a5,3
    80004ba8:	0ef70b63          	beq	a4,a5,80004c9e <sys_open+0x18a>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004bac:	4789                	li	a5,2
    80004bae:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004bb2:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004bb6:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004bba:	f4c42783          	lw	a5,-180(s0)
    80004bbe:	0017f713          	andi	a4,a5,1
    80004bc2:	00174713          	xori	a4,a4,1
    80004bc6:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004bca:	0037f713          	andi	a4,a5,3
    80004bce:	00e03733          	snez	a4,a4
    80004bd2:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004bd6:	4007f793          	andi	a5,a5,1024
    80004bda:	c791                	beqz	a5,80004be6 <sys_open+0xd2>
    80004bdc:	04491703          	lh	a4,68(s2)
    80004be0:	4789                	li	a5,2
    80004be2:	0cf70563          	beq	a4,a5,80004cac <sys_open+0x198>
    itrunc(ip);
  }

  iunlock(ip);
    80004be6:	854a                	mv	a0,s2
    80004be8:	ffffe097          	auipc	ra,0xffffe
    80004bec:	f92080e7          	jalr	-110(ra) # 80002b7a <iunlock>
  end_op();
    80004bf0:	fffff097          	auipc	ra,0xfffff
    80004bf4:	930080e7          	jalr	-1744(ra) # 80003520 <end_op>
    80004bf8:	790a                	ld	s2,160(sp)
    80004bfa:	69ea                	ld	s3,152(sp)

  return fd;
}
    80004bfc:	8526                	mv	a0,s1
    80004bfe:	70ea                	ld	ra,184(sp)
    80004c00:	744a                	ld	s0,176(sp)
    80004c02:	74aa                	ld	s1,168(sp)
    80004c04:	6129                	addi	sp,sp,192
    80004c06:	8082                	ret
      end_op();
    80004c08:	fffff097          	auipc	ra,0xfffff
    80004c0c:	918080e7          	jalr	-1768(ra) # 80003520 <end_op>
      return -1;
    80004c10:	790a                	ld	s2,160(sp)
    80004c12:	b7ed                	j	80004bfc <sys_open+0xe8>
    if((ip = namei(path)) == 0){
    80004c14:	f5040513          	addi	a0,s0,-176
    80004c18:	ffffe097          	auipc	ra,0xffffe
    80004c1c:	688080e7          	jalr	1672(ra) # 800032a0 <namei>
    80004c20:	892a                	mv	s2,a0
    80004c22:	c90d                	beqz	a0,80004c54 <sys_open+0x140>
    ilock(ip);
    80004c24:	ffffe097          	auipc	ra,0xffffe
    80004c28:	e90080e7          	jalr	-368(ra) # 80002ab4 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004c2c:	04491703          	lh	a4,68(s2)
    80004c30:	4785                	li	a5,1
    80004c32:	f4f710e3          	bne	a4,a5,80004b72 <sys_open+0x5e>
    80004c36:	f4c42783          	lw	a5,-180(s0)
    80004c3a:	d7b1                	beqz	a5,80004b86 <sys_open+0x72>
      iunlockput(ip);
    80004c3c:	854a                	mv	a0,s2
    80004c3e:	ffffe097          	auipc	ra,0xffffe
    80004c42:	0dc080e7          	jalr	220(ra) # 80002d1a <iunlockput>
      end_op();
    80004c46:	fffff097          	auipc	ra,0xfffff
    80004c4a:	8da080e7          	jalr	-1830(ra) # 80003520 <end_op>
      return -1;
    80004c4e:	54fd                	li	s1,-1
    80004c50:	790a                	ld	s2,160(sp)
    80004c52:	b76d                	j	80004bfc <sys_open+0xe8>
      end_op();
    80004c54:	fffff097          	auipc	ra,0xfffff
    80004c58:	8cc080e7          	jalr	-1844(ra) # 80003520 <end_op>
      return -1;
    80004c5c:	54fd                	li	s1,-1
    80004c5e:	790a                	ld	s2,160(sp)
    80004c60:	bf71                	j	80004bfc <sys_open+0xe8>
    iunlockput(ip);
    80004c62:	854a                	mv	a0,s2
    80004c64:	ffffe097          	auipc	ra,0xffffe
    80004c68:	0b6080e7          	jalr	182(ra) # 80002d1a <iunlockput>
    end_op();
    80004c6c:	fffff097          	auipc	ra,0xfffff
    80004c70:	8b4080e7          	jalr	-1868(ra) # 80003520 <end_op>
    return -1;
    80004c74:	54fd                	li	s1,-1
    80004c76:	790a                	ld	s2,160(sp)
    80004c78:	b751                	j	80004bfc <sys_open+0xe8>
      fileclose(f);
    80004c7a:	854e                	mv	a0,s3
    80004c7c:	fffff097          	auipc	ra,0xfffff
    80004c80:	cfa080e7          	jalr	-774(ra) # 80003976 <fileclose>
    iunlockput(ip);
    80004c84:	854a                	mv	a0,s2
    80004c86:	ffffe097          	auipc	ra,0xffffe
    80004c8a:	094080e7          	jalr	148(ra) # 80002d1a <iunlockput>
    end_op();
    80004c8e:	fffff097          	auipc	ra,0xfffff
    80004c92:	892080e7          	jalr	-1902(ra) # 80003520 <end_op>
    return -1;
    80004c96:	54fd                	li	s1,-1
    80004c98:	790a                	ld	s2,160(sp)
    80004c9a:	69ea                	ld	s3,152(sp)
    80004c9c:	b785                	j	80004bfc <sys_open+0xe8>
    f->type = FD_DEVICE;
    80004c9e:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004ca2:	04691783          	lh	a5,70(s2)
    80004ca6:	02f99223          	sh	a5,36(s3)
    80004caa:	b731                	j	80004bb6 <sys_open+0xa2>
    itrunc(ip);
    80004cac:	854a                	mv	a0,s2
    80004cae:	ffffe097          	auipc	ra,0xffffe
    80004cb2:	f18080e7          	jalr	-232(ra) # 80002bc6 <itrunc>
    80004cb6:	bf05                	j	80004be6 <sys_open+0xd2>

0000000080004cb8 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004cb8:	7175                	addi	sp,sp,-144
    80004cba:	e506                	sd	ra,136(sp)
    80004cbc:	e122                	sd	s0,128(sp)
    80004cbe:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004cc0:	ffffe097          	auipc	ra,0xffffe
    80004cc4:	7e6080e7          	jalr	2022(ra) # 800034a6 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004cc8:	08000613          	li	a2,128
    80004ccc:	f7040593          	addi	a1,s0,-144
    80004cd0:	4501                	li	a0,0
    80004cd2:	ffffd097          	auipc	ra,0xffffd
    80004cd6:	2d2080e7          	jalr	722(ra) # 80001fa4 <argstr>
    80004cda:	02054963          	bltz	a0,80004d0c <sys_mkdir+0x54>
    80004cde:	4681                	li	a3,0
    80004ce0:	4601                	li	a2,0
    80004ce2:	4585                	li	a1,1
    80004ce4:	f7040513          	addi	a0,s0,-144
    80004ce8:	fffff097          	auipc	ra,0xfffff
    80004cec:	7c6080e7          	jalr	1990(ra) # 800044ae <create>
    80004cf0:	cd11                	beqz	a0,80004d0c <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004cf2:	ffffe097          	auipc	ra,0xffffe
    80004cf6:	028080e7          	jalr	40(ra) # 80002d1a <iunlockput>
  end_op();
    80004cfa:	fffff097          	auipc	ra,0xfffff
    80004cfe:	826080e7          	jalr	-2010(ra) # 80003520 <end_op>
  return 0;
    80004d02:	4501                	li	a0,0
}
    80004d04:	60aa                	ld	ra,136(sp)
    80004d06:	640a                	ld	s0,128(sp)
    80004d08:	6149                	addi	sp,sp,144
    80004d0a:	8082                	ret
    end_op();
    80004d0c:	fffff097          	auipc	ra,0xfffff
    80004d10:	814080e7          	jalr	-2028(ra) # 80003520 <end_op>
    return -1;
    80004d14:	557d                	li	a0,-1
    80004d16:	b7fd                	j	80004d04 <sys_mkdir+0x4c>

0000000080004d18 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004d18:	7135                	addi	sp,sp,-160
    80004d1a:	ed06                	sd	ra,152(sp)
    80004d1c:	e922                	sd	s0,144(sp)
    80004d1e:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004d20:	ffffe097          	auipc	ra,0xffffe
    80004d24:	786080e7          	jalr	1926(ra) # 800034a6 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d28:	08000613          	li	a2,128
    80004d2c:	f7040593          	addi	a1,s0,-144
    80004d30:	4501                	li	a0,0
    80004d32:	ffffd097          	auipc	ra,0xffffd
    80004d36:	272080e7          	jalr	626(ra) # 80001fa4 <argstr>
    80004d3a:	04054a63          	bltz	a0,80004d8e <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004d3e:	f6c40593          	addi	a1,s0,-148
    80004d42:	4505                	li	a0,1
    80004d44:	ffffd097          	auipc	ra,0xffffd
    80004d48:	21c080e7          	jalr	540(ra) # 80001f60 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d4c:	04054163          	bltz	a0,80004d8e <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004d50:	f6840593          	addi	a1,s0,-152
    80004d54:	4509                	li	a0,2
    80004d56:	ffffd097          	auipc	ra,0xffffd
    80004d5a:	20a080e7          	jalr	522(ra) # 80001f60 <argint>
     argint(1, &major) < 0 ||
    80004d5e:	02054863          	bltz	a0,80004d8e <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004d62:	f6841683          	lh	a3,-152(s0)
    80004d66:	f6c41603          	lh	a2,-148(s0)
    80004d6a:	458d                	li	a1,3
    80004d6c:	f7040513          	addi	a0,s0,-144
    80004d70:	fffff097          	auipc	ra,0xfffff
    80004d74:	73e080e7          	jalr	1854(ra) # 800044ae <create>
     argint(2, &minor) < 0 ||
    80004d78:	c919                	beqz	a0,80004d8e <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004d7a:	ffffe097          	auipc	ra,0xffffe
    80004d7e:	fa0080e7          	jalr	-96(ra) # 80002d1a <iunlockput>
  end_op();
    80004d82:	ffffe097          	auipc	ra,0xffffe
    80004d86:	79e080e7          	jalr	1950(ra) # 80003520 <end_op>
  return 0;
    80004d8a:	4501                	li	a0,0
    80004d8c:	a031                	j	80004d98 <sys_mknod+0x80>
    end_op();
    80004d8e:	ffffe097          	auipc	ra,0xffffe
    80004d92:	792080e7          	jalr	1938(ra) # 80003520 <end_op>
    return -1;
    80004d96:	557d                	li	a0,-1
}
    80004d98:	60ea                	ld	ra,152(sp)
    80004d9a:	644a                	ld	s0,144(sp)
    80004d9c:	610d                	addi	sp,sp,160
    80004d9e:	8082                	ret

0000000080004da0 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004da0:	7135                	addi	sp,sp,-160
    80004da2:	ed06                	sd	ra,152(sp)
    80004da4:	e922                	sd	s0,144(sp)
    80004da6:	e14a                	sd	s2,128(sp)
    80004da8:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004daa:	ffffc097          	auipc	ra,0xffffc
    80004dae:	0f8080e7          	jalr	248(ra) # 80000ea2 <myproc>
    80004db2:	892a                	mv	s2,a0
  
  begin_op();
    80004db4:	ffffe097          	auipc	ra,0xffffe
    80004db8:	6f2080e7          	jalr	1778(ra) # 800034a6 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004dbc:	08000613          	li	a2,128
    80004dc0:	f6040593          	addi	a1,s0,-160
    80004dc4:	4501                	li	a0,0
    80004dc6:	ffffd097          	auipc	ra,0xffffd
    80004dca:	1de080e7          	jalr	478(ra) # 80001fa4 <argstr>
    80004dce:	04054d63          	bltz	a0,80004e28 <sys_chdir+0x88>
    80004dd2:	e526                	sd	s1,136(sp)
    80004dd4:	f6040513          	addi	a0,s0,-160
    80004dd8:	ffffe097          	auipc	ra,0xffffe
    80004ddc:	4c8080e7          	jalr	1224(ra) # 800032a0 <namei>
    80004de0:	84aa                	mv	s1,a0
    80004de2:	c131                	beqz	a0,80004e26 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004de4:	ffffe097          	auipc	ra,0xffffe
    80004de8:	cd0080e7          	jalr	-816(ra) # 80002ab4 <ilock>
  if(ip->type != T_DIR){
    80004dec:	04449703          	lh	a4,68(s1)
    80004df0:	4785                	li	a5,1
    80004df2:	04f71163          	bne	a4,a5,80004e34 <sys_chdir+0x94>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004df6:	8526                	mv	a0,s1
    80004df8:	ffffe097          	auipc	ra,0xffffe
    80004dfc:	d82080e7          	jalr	-638(ra) # 80002b7a <iunlock>
  iput(p->cwd);
    80004e00:	15093503          	ld	a0,336(s2)
    80004e04:	ffffe097          	auipc	ra,0xffffe
    80004e08:	e6e080e7          	jalr	-402(ra) # 80002c72 <iput>
  end_op();
    80004e0c:	ffffe097          	auipc	ra,0xffffe
    80004e10:	714080e7          	jalr	1812(ra) # 80003520 <end_op>
  p->cwd = ip;
    80004e14:	14993823          	sd	s1,336(s2)
  return 0;
    80004e18:	4501                	li	a0,0
    80004e1a:	64aa                	ld	s1,136(sp)
}
    80004e1c:	60ea                	ld	ra,152(sp)
    80004e1e:	644a                	ld	s0,144(sp)
    80004e20:	690a                	ld	s2,128(sp)
    80004e22:	610d                	addi	sp,sp,160
    80004e24:	8082                	ret
    80004e26:	64aa                	ld	s1,136(sp)
    end_op();
    80004e28:	ffffe097          	auipc	ra,0xffffe
    80004e2c:	6f8080e7          	jalr	1784(ra) # 80003520 <end_op>
    return -1;
    80004e30:	557d                	li	a0,-1
    80004e32:	b7ed                	j	80004e1c <sys_chdir+0x7c>
    iunlockput(ip);
    80004e34:	8526                	mv	a0,s1
    80004e36:	ffffe097          	auipc	ra,0xffffe
    80004e3a:	ee4080e7          	jalr	-284(ra) # 80002d1a <iunlockput>
    end_op();
    80004e3e:	ffffe097          	auipc	ra,0xffffe
    80004e42:	6e2080e7          	jalr	1762(ra) # 80003520 <end_op>
    return -1;
    80004e46:	557d                	li	a0,-1
    80004e48:	64aa                	ld	s1,136(sp)
    80004e4a:	bfc9                	j	80004e1c <sys_chdir+0x7c>

0000000080004e4c <sys_exec>:

uint64
sys_exec(void)
{
    80004e4c:	7105                	addi	sp,sp,-480
    80004e4e:	ef86                	sd	ra,472(sp)
    80004e50:	eba2                	sd	s0,464(sp)
    80004e52:	e3ca                	sd	s2,448(sp)
    80004e54:	1380                	addi	s0,sp,480
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004e56:	08000613          	li	a2,128
    80004e5a:	f3040593          	addi	a1,s0,-208
    80004e5e:	4501                	li	a0,0
    80004e60:	ffffd097          	auipc	ra,0xffffd
    80004e64:	144080e7          	jalr	324(ra) # 80001fa4 <argstr>
    return -1;
    80004e68:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004e6a:	10054963          	bltz	a0,80004f7c <sys_exec+0x130>
    80004e6e:	e2840593          	addi	a1,s0,-472
    80004e72:	4505                	li	a0,1
    80004e74:	ffffd097          	auipc	ra,0xffffd
    80004e78:	10e080e7          	jalr	270(ra) # 80001f82 <argaddr>
    80004e7c:	10054063          	bltz	a0,80004f7c <sys_exec+0x130>
    80004e80:	e7a6                	sd	s1,456(sp)
    80004e82:	ff4e                	sd	s3,440(sp)
    80004e84:	fb52                	sd	s4,432(sp)
    80004e86:	f756                	sd	s5,424(sp)
    80004e88:	f35a                	sd	s6,416(sp)
    80004e8a:	ef5e                	sd	s7,408(sp)
  }
  memset(argv, 0, sizeof(argv));
    80004e8c:	e3040a13          	addi	s4,s0,-464
    80004e90:	10000613          	li	a2,256
    80004e94:	4581                	li	a1,0
    80004e96:	8552                	mv	a0,s4
    80004e98:	ffffb097          	auipc	ra,0xffffb
    80004e9c:	2e2080e7          	jalr	738(ra) # 8000017a <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004ea0:	84d2                	mv	s1,s4
  memset(argv, 0, sizeof(argv));
    80004ea2:	89d2                	mv	s3,s4
    80004ea4:	4901                	li	s2,0
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004ea6:	e2040a93          	addi	s5,s0,-480
      break;
    }
    argv[i] = kalloc();
    if(argv[i] == 0)
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004eaa:	6b05                	lui	s6,0x1
    if(i >= NELEM(argv)){
    80004eac:	02000b93          	li	s7,32
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004eb0:	00391513          	slli	a0,s2,0x3
    80004eb4:	85d6                	mv	a1,s5
    80004eb6:	e2843783          	ld	a5,-472(s0)
    80004eba:	953e                	add	a0,a0,a5
    80004ebc:	ffffd097          	auipc	ra,0xffffd
    80004ec0:	00a080e7          	jalr	10(ra) # 80001ec6 <fetchaddr>
    80004ec4:	02054a63          	bltz	a0,80004ef8 <sys_exec+0xac>
    if(uarg == 0){
    80004ec8:	e2043783          	ld	a5,-480(s0)
    80004ecc:	cba9                	beqz	a5,80004f1e <sys_exec+0xd2>
    argv[i] = kalloc();
    80004ece:	ffffb097          	auipc	ra,0xffffb
    80004ed2:	24c080e7          	jalr	588(ra) # 8000011a <kalloc>
    80004ed6:	85aa                	mv	a1,a0
    80004ed8:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004edc:	cd11                	beqz	a0,80004ef8 <sys_exec+0xac>
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004ede:	865a                	mv	a2,s6
    80004ee0:	e2043503          	ld	a0,-480(s0)
    80004ee4:	ffffd097          	auipc	ra,0xffffd
    80004ee8:	034080e7          	jalr	52(ra) # 80001f18 <fetchstr>
    80004eec:	00054663          	bltz	a0,80004ef8 <sys_exec+0xac>
    if(i >= NELEM(argv)){
    80004ef0:	0905                	addi	s2,s2,1
    80004ef2:	09a1                	addi	s3,s3,8
    80004ef4:	fb791ee3          	bne	s2,s7,80004eb0 <sys_exec+0x64>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004ef8:	100a0a13          	addi	s4,s4,256
    80004efc:	6088                	ld	a0,0(s1)
    80004efe:	c925                	beqz	a0,80004f6e <sys_exec+0x122>
    kfree(argv[i]);
    80004f00:	ffffb097          	auipc	ra,0xffffb
    80004f04:	11c080e7          	jalr	284(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f08:	04a1                	addi	s1,s1,8
    80004f0a:	ff4499e3          	bne	s1,s4,80004efc <sys_exec+0xb0>
  return -1;
    80004f0e:	597d                	li	s2,-1
    80004f10:	64be                	ld	s1,456(sp)
    80004f12:	79fa                	ld	s3,440(sp)
    80004f14:	7a5a                	ld	s4,432(sp)
    80004f16:	7aba                	ld	s5,424(sp)
    80004f18:	7b1a                	ld	s6,416(sp)
    80004f1a:	6bfa                	ld	s7,408(sp)
    80004f1c:	a085                	j	80004f7c <sys_exec+0x130>
      argv[i] = 0;
    80004f1e:	0009079b          	sext.w	a5,s2
    80004f22:	e3040593          	addi	a1,s0,-464
    80004f26:	078e                	slli	a5,a5,0x3
    80004f28:	97ae                	add	a5,a5,a1
    80004f2a:	0007b023          	sd	zero,0(a5)
  int ret = exec(path, argv);
    80004f2e:	f3040513          	addi	a0,s0,-208
    80004f32:	fffff097          	auipc	ra,0xfffff
    80004f36:	122080e7          	jalr	290(ra) # 80004054 <exec>
    80004f3a:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f3c:	100a0a13          	addi	s4,s4,256
    80004f40:	6088                	ld	a0,0(s1)
    80004f42:	cd19                	beqz	a0,80004f60 <sys_exec+0x114>
    kfree(argv[i]);
    80004f44:	ffffb097          	auipc	ra,0xffffb
    80004f48:	0d8080e7          	jalr	216(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f4c:	04a1                	addi	s1,s1,8
    80004f4e:	ff4499e3          	bne	s1,s4,80004f40 <sys_exec+0xf4>
    80004f52:	64be                	ld	s1,456(sp)
    80004f54:	79fa                	ld	s3,440(sp)
    80004f56:	7a5a                	ld	s4,432(sp)
    80004f58:	7aba                	ld	s5,424(sp)
    80004f5a:	7b1a                	ld	s6,416(sp)
    80004f5c:	6bfa                	ld	s7,408(sp)
    80004f5e:	a839                	j	80004f7c <sys_exec+0x130>
  return ret;
    80004f60:	64be                	ld	s1,456(sp)
    80004f62:	79fa                	ld	s3,440(sp)
    80004f64:	7a5a                	ld	s4,432(sp)
    80004f66:	7aba                	ld	s5,424(sp)
    80004f68:	7b1a                	ld	s6,416(sp)
    80004f6a:	6bfa                	ld	s7,408(sp)
    80004f6c:	a801                	j	80004f7c <sys_exec+0x130>
  return -1;
    80004f6e:	597d                	li	s2,-1
    80004f70:	64be                	ld	s1,456(sp)
    80004f72:	79fa                	ld	s3,440(sp)
    80004f74:	7a5a                	ld	s4,432(sp)
    80004f76:	7aba                	ld	s5,424(sp)
    80004f78:	7b1a                	ld	s6,416(sp)
    80004f7a:	6bfa                	ld	s7,408(sp)
}
    80004f7c:	854a                	mv	a0,s2
    80004f7e:	60fe                	ld	ra,472(sp)
    80004f80:	645e                	ld	s0,464(sp)
    80004f82:	691e                	ld	s2,448(sp)
    80004f84:	613d                	addi	sp,sp,480
    80004f86:	8082                	ret

0000000080004f88 <sys_pipe>:

uint64
sys_pipe(void)
{
    80004f88:	7139                	addi	sp,sp,-64
    80004f8a:	fc06                	sd	ra,56(sp)
    80004f8c:	f822                	sd	s0,48(sp)
    80004f8e:	f426                	sd	s1,40(sp)
    80004f90:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004f92:	ffffc097          	auipc	ra,0xffffc
    80004f96:	f10080e7          	jalr	-240(ra) # 80000ea2 <myproc>
    80004f9a:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80004f9c:	fd840593          	addi	a1,s0,-40
    80004fa0:	4501                	li	a0,0
    80004fa2:	ffffd097          	auipc	ra,0xffffd
    80004fa6:	fe0080e7          	jalr	-32(ra) # 80001f82 <argaddr>
    return -1;
    80004faa:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80004fac:	0e054063          	bltz	a0,8000508c <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80004fb0:	fc840593          	addi	a1,s0,-56
    80004fb4:	fd040513          	addi	a0,s0,-48
    80004fb8:	fffff097          	auipc	ra,0xfffff
    80004fbc:	d32080e7          	jalr	-718(ra) # 80003cea <pipealloc>
    return -1;
    80004fc0:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004fc2:	0c054563          	bltz	a0,8000508c <sys_pipe+0x104>
  fd0 = -1;
    80004fc6:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004fca:	fd043503          	ld	a0,-48(s0)
    80004fce:	fffff097          	auipc	ra,0xfffff
    80004fd2:	49e080e7          	jalr	1182(ra) # 8000446c <fdalloc>
    80004fd6:	fca42223          	sw	a0,-60(s0)
    80004fda:	08054c63          	bltz	a0,80005072 <sys_pipe+0xea>
    80004fde:	fc843503          	ld	a0,-56(s0)
    80004fe2:	fffff097          	auipc	ra,0xfffff
    80004fe6:	48a080e7          	jalr	1162(ra) # 8000446c <fdalloc>
    80004fea:	fca42023          	sw	a0,-64(s0)
    80004fee:	06054963          	bltz	a0,80005060 <sys_pipe+0xd8>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004ff2:	4691                	li	a3,4
    80004ff4:	fc440613          	addi	a2,s0,-60
    80004ff8:	fd843583          	ld	a1,-40(s0)
    80004ffc:	68a8                	ld	a0,80(s1)
    80004ffe:	ffffc097          	auipc	ra,0xffffc
    80005002:	b50080e7          	jalr	-1200(ra) # 80000b4e <copyout>
    80005006:	02054063          	bltz	a0,80005026 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    8000500a:	4691                	li	a3,4
    8000500c:	fc040613          	addi	a2,s0,-64
    80005010:	fd843583          	ld	a1,-40(s0)
    80005014:	95b6                	add	a1,a1,a3
    80005016:	68a8                	ld	a0,80(s1)
    80005018:	ffffc097          	auipc	ra,0xffffc
    8000501c:	b36080e7          	jalr	-1226(ra) # 80000b4e <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005020:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005022:	06055563          	bgez	a0,8000508c <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005026:	fc442783          	lw	a5,-60(s0)
    8000502a:	07e9                	addi	a5,a5,26
    8000502c:	078e                	slli	a5,a5,0x3
    8000502e:	97a6                	add	a5,a5,s1
    80005030:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005034:	fc042783          	lw	a5,-64(s0)
    80005038:	07e9                	addi	a5,a5,26
    8000503a:	078e                	slli	a5,a5,0x3
    8000503c:	00f48533          	add	a0,s1,a5
    80005040:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005044:	fd043503          	ld	a0,-48(s0)
    80005048:	fffff097          	auipc	ra,0xfffff
    8000504c:	92e080e7          	jalr	-1746(ra) # 80003976 <fileclose>
    fileclose(wf);
    80005050:	fc843503          	ld	a0,-56(s0)
    80005054:	fffff097          	auipc	ra,0xfffff
    80005058:	922080e7          	jalr	-1758(ra) # 80003976 <fileclose>
    return -1;
    8000505c:	57fd                	li	a5,-1
    8000505e:	a03d                	j	8000508c <sys_pipe+0x104>
    if(fd0 >= 0)
    80005060:	fc442783          	lw	a5,-60(s0)
    80005064:	0007c763          	bltz	a5,80005072 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005068:	07e9                	addi	a5,a5,26
    8000506a:	078e                	slli	a5,a5,0x3
    8000506c:	97a6                	add	a5,a5,s1
    8000506e:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005072:	fd043503          	ld	a0,-48(s0)
    80005076:	fffff097          	auipc	ra,0xfffff
    8000507a:	900080e7          	jalr	-1792(ra) # 80003976 <fileclose>
    fileclose(wf);
    8000507e:	fc843503          	ld	a0,-56(s0)
    80005082:	fffff097          	auipc	ra,0xfffff
    80005086:	8f4080e7          	jalr	-1804(ra) # 80003976 <fileclose>
    return -1;
    8000508a:	57fd                	li	a5,-1
}
    8000508c:	853e                	mv	a0,a5
    8000508e:	70e2                	ld	ra,56(sp)
    80005090:	7442                	ld	s0,48(sp)
    80005092:	74a2                	ld	s1,40(sp)
    80005094:	6121                	addi	sp,sp,64
    80005096:	8082                	ret
	...

00000000800050a0 <kernelvec>:
    800050a0:	7111                	addi	sp,sp,-256
    800050a2:	e006                	sd	ra,0(sp)
    800050a4:	e40a                	sd	sp,8(sp)
    800050a6:	e80e                	sd	gp,16(sp)
    800050a8:	ec12                	sd	tp,24(sp)
    800050aa:	f016                	sd	t0,32(sp)
    800050ac:	f41a                	sd	t1,40(sp)
    800050ae:	f81e                	sd	t2,48(sp)
    800050b0:	fc22                	sd	s0,56(sp)
    800050b2:	e0a6                	sd	s1,64(sp)
    800050b4:	e4aa                	sd	a0,72(sp)
    800050b6:	e8ae                	sd	a1,80(sp)
    800050b8:	ecb2                	sd	a2,88(sp)
    800050ba:	f0b6                	sd	a3,96(sp)
    800050bc:	f4ba                	sd	a4,104(sp)
    800050be:	f8be                	sd	a5,112(sp)
    800050c0:	fcc2                	sd	a6,120(sp)
    800050c2:	e146                	sd	a7,128(sp)
    800050c4:	e54a                	sd	s2,136(sp)
    800050c6:	e94e                	sd	s3,144(sp)
    800050c8:	ed52                	sd	s4,152(sp)
    800050ca:	f156                	sd	s5,160(sp)
    800050cc:	f55a                	sd	s6,168(sp)
    800050ce:	f95e                	sd	s7,176(sp)
    800050d0:	fd62                	sd	s8,184(sp)
    800050d2:	e1e6                	sd	s9,192(sp)
    800050d4:	e5ea                	sd	s10,200(sp)
    800050d6:	e9ee                	sd	s11,208(sp)
    800050d8:	edf2                	sd	t3,216(sp)
    800050da:	f1f6                	sd	t4,224(sp)
    800050dc:	f5fa                	sd	t5,232(sp)
    800050de:	f9fe                	sd	t6,240(sp)
    800050e0:	cb3fc0ef          	jal	80001d92 <kerneltrap>
    800050e4:	6082                	ld	ra,0(sp)
    800050e6:	6122                	ld	sp,8(sp)
    800050e8:	61c2                	ld	gp,16(sp)
    800050ea:	7282                	ld	t0,32(sp)
    800050ec:	7322                	ld	t1,40(sp)
    800050ee:	73c2                	ld	t2,48(sp)
    800050f0:	7462                	ld	s0,56(sp)
    800050f2:	6486                	ld	s1,64(sp)
    800050f4:	6526                	ld	a0,72(sp)
    800050f6:	65c6                	ld	a1,80(sp)
    800050f8:	6666                	ld	a2,88(sp)
    800050fa:	7686                	ld	a3,96(sp)
    800050fc:	7726                	ld	a4,104(sp)
    800050fe:	77c6                	ld	a5,112(sp)
    80005100:	7866                	ld	a6,120(sp)
    80005102:	688a                	ld	a7,128(sp)
    80005104:	692a                	ld	s2,136(sp)
    80005106:	69ca                	ld	s3,144(sp)
    80005108:	6a6a                	ld	s4,152(sp)
    8000510a:	7a8a                	ld	s5,160(sp)
    8000510c:	7b2a                	ld	s6,168(sp)
    8000510e:	7bca                	ld	s7,176(sp)
    80005110:	7c6a                	ld	s8,184(sp)
    80005112:	6c8e                	ld	s9,192(sp)
    80005114:	6d2e                	ld	s10,200(sp)
    80005116:	6dce                	ld	s11,208(sp)
    80005118:	6e6e                	ld	t3,216(sp)
    8000511a:	7e8e                	ld	t4,224(sp)
    8000511c:	7f2e                	ld	t5,232(sp)
    8000511e:	7fce                	ld	t6,240(sp)
    80005120:	6111                	addi	sp,sp,256
    80005122:	10200073          	sret
    80005126:	00000013          	nop
    8000512a:	00000013          	nop
    8000512e:	0001                	nop

0000000080005130 <timervec>:
    80005130:	34051573          	csrrw	a0,mscratch,a0
    80005134:	e10c                	sd	a1,0(a0)
    80005136:	e510                	sd	a2,8(a0)
    80005138:	e914                	sd	a3,16(a0)
    8000513a:	6d0c                	ld	a1,24(a0)
    8000513c:	7110                	ld	a2,32(a0)
    8000513e:	6194                	ld	a3,0(a1)
    80005140:	96b2                	add	a3,a3,a2
    80005142:	e194                	sd	a3,0(a1)
    80005144:	4589                	li	a1,2
    80005146:	14459073          	csrw	sip,a1
    8000514a:	6914                	ld	a3,16(a0)
    8000514c:	6510                	ld	a2,8(a0)
    8000514e:	610c                	ld	a1,0(a0)
    80005150:	34051573          	csrrw	a0,mscratch,a0
    80005154:	30200073          	mret
	...

000000008000515a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000515a:	1141                	addi	sp,sp,-16
    8000515c:	e406                	sd	ra,8(sp)
    8000515e:	e022                	sd	s0,0(sp)
    80005160:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005162:	0c000737          	lui	a4,0xc000
    80005166:	4785                	li	a5,1
    80005168:	d71c                	sw	a5,40(a4)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    8000516a:	c35c                	sw	a5,4(a4)
}
    8000516c:	60a2                	ld	ra,8(sp)
    8000516e:	6402                	ld	s0,0(sp)
    80005170:	0141                	addi	sp,sp,16
    80005172:	8082                	ret

0000000080005174 <plicinithart>:

void
plicinithart(void)
{
    80005174:	1141                	addi	sp,sp,-16
    80005176:	e406                	sd	ra,8(sp)
    80005178:	e022                	sd	s0,0(sp)
    8000517a:	0800                	addi	s0,sp,16
  int hart = cpuid();
    8000517c:	ffffc097          	auipc	ra,0xffffc
    80005180:	cf2080e7          	jalr	-782(ra) # 80000e6e <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005184:	0085171b          	slliw	a4,a0,0x8
    80005188:	0c0027b7          	lui	a5,0xc002
    8000518c:	97ba                	add	a5,a5,a4
    8000518e:	40200713          	li	a4,1026
    80005192:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005196:	00d5151b          	slliw	a0,a0,0xd
    8000519a:	0c2017b7          	lui	a5,0xc201
    8000519e:	97aa                	add	a5,a5,a0
    800051a0:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800051a4:	60a2                	ld	ra,8(sp)
    800051a6:	6402                	ld	s0,0(sp)
    800051a8:	0141                	addi	sp,sp,16
    800051aa:	8082                	ret

00000000800051ac <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800051ac:	1141                	addi	sp,sp,-16
    800051ae:	e406                	sd	ra,8(sp)
    800051b0:	e022                	sd	s0,0(sp)
    800051b2:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800051b4:	ffffc097          	auipc	ra,0xffffc
    800051b8:	cba080e7          	jalr	-838(ra) # 80000e6e <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800051bc:	00d5151b          	slliw	a0,a0,0xd
    800051c0:	0c2017b7          	lui	a5,0xc201
    800051c4:	97aa                	add	a5,a5,a0
  return irq;
}
    800051c6:	43c8                	lw	a0,4(a5)
    800051c8:	60a2                	ld	ra,8(sp)
    800051ca:	6402                	ld	s0,0(sp)
    800051cc:	0141                	addi	sp,sp,16
    800051ce:	8082                	ret

00000000800051d0 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800051d0:	1101                	addi	sp,sp,-32
    800051d2:	ec06                	sd	ra,24(sp)
    800051d4:	e822                	sd	s0,16(sp)
    800051d6:	e426                	sd	s1,8(sp)
    800051d8:	1000                	addi	s0,sp,32
    800051da:	84aa                	mv	s1,a0
  int hart = cpuid();
    800051dc:	ffffc097          	auipc	ra,0xffffc
    800051e0:	c92080e7          	jalr	-878(ra) # 80000e6e <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800051e4:	00d5179b          	slliw	a5,a0,0xd
    800051e8:	0c201737          	lui	a4,0xc201
    800051ec:	97ba                	add	a5,a5,a4
    800051ee:	c3c4                	sw	s1,4(a5)
}
    800051f0:	60e2                	ld	ra,24(sp)
    800051f2:	6442                	ld	s0,16(sp)
    800051f4:	64a2                	ld	s1,8(sp)
    800051f6:	6105                	addi	sp,sp,32
    800051f8:	8082                	ret

00000000800051fa <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800051fa:	1141                	addi	sp,sp,-16
    800051fc:	e406                	sd	ra,8(sp)
    800051fe:	e022                	sd	s0,0(sp)
    80005200:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80005202:	479d                	li	a5,7
    80005204:	06a7c863          	blt	a5,a0,80005274 <free_desc+0x7a>
    panic("free_desc 1");
  if(disk.free[i])
    80005208:	00016717          	auipc	a4,0x16
    8000520c:	df870713          	addi	a4,a4,-520 # 8001b000 <disk>
    80005210:	972a                	add	a4,a4,a0
    80005212:	6789                	lui	a5,0x2
    80005214:	97ba                	add	a5,a5,a4
    80005216:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    8000521a:	e7ad                	bnez	a5,80005284 <free_desc+0x8a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000521c:	00451793          	slli	a5,a0,0x4
    80005220:	00018717          	auipc	a4,0x18
    80005224:	de070713          	addi	a4,a4,-544 # 8001d000 <disk+0x2000>
    80005228:	6314                	ld	a3,0(a4)
    8000522a:	96be                	add	a3,a3,a5
    8000522c:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    80005230:	6314                	ld	a3,0(a4)
    80005232:	96be                	add	a3,a3,a5
    80005234:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005238:	6314                	ld	a3,0(a4)
    8000523a:	96be                	add	a3,a3,a5
    8000523c:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    80005240:	6318                	ld	a4,0(a4)
    80005242:	97ba                	add	a5,a5,a4
    80005244:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005248:	00016717          	auipc	a4,0x16
    8000524c:	db870713          	addi	a4,a4,-584 # 8001b000 <disk>
    80005250:	972a                	add	a4,a4,a0
    80005252:	6789                	lui	a5,0x2
    80005254:	97ba                	add	a5,a5,a4
    80005256:	4705                	li	a4,1
    80005258:	00e78c23          	sb	a4,24(a5) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    8000525c:	00018517          	auipc	a0,0x18
    80005260:	dbc50513          	addi	a0,a0,-580 # 8001d018 <disk+0x2018>
    80005264:	ffffc097          	auipc	ra,0xffffc
    80005268:	48a080e7          	jalr	1162(ra) # 800016ee <wakeup>
}
    8000526c:	60a2                	ld	ra,8(sp)
    8000526e:	6402                	ld	s0,0(sp)
    80005270:	0141                	addi	sp,sp,16
    80005272:	8082                	ret
    panic("free_desc 1");
    80005274:	00003517          	auipc	a0,0x3
    80005278:	37c50513          	addi	a0,a0,892 # 800085f0 <etext+0x5f0>
    8000527c:	00001097          	auipc	ra,0x1
    80005280:	9f6080e7          	jalr	-1546(ra) # 80005c72 <panic>
    panic("free_desc 2");
    80005284:	00003517          	auipc	a0,0x3
    80005288:	37c50513          	addi	a0,a0,892 # 80008600 <etext+0x600>
    8000528c:	00001097          	auipc	ra,0x1
    80005290:	9e6080e7          	jalr	-1562(ra) # 80005c72 <panic>

0000000080005294 <virtio_disk_init>:
{
    80005294:	1141                	addi	sp,sp,-16
    80005296:	e406                	sd	ra,8(sp)
    80005298:	e022                	sd	s0,0(sp)
    8000529a:	0800                	addi	s0,sp,16
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000529c:	00003597          	auipc	a1,0x3
    800052a0:	37458593          	addi	a1,a1,884 # 80008610 <etext+0x610>
    800052a4:	00018517          	auipc	a0,0x18
    800052a8:	e8450513          	addi	a0,a0,-380 # 8001d128 <disk+0x2128>
    800052ac:	00001097          	auipc	ra,0x1
    800052b0:	eb2080e7          	jalr	-334(ra) # 8000615e <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800052b4:	100017b7          	lui	a5,0x10001
    800052b8:	4398                	lw	a4,0(a5)
    800052ba:	2701                	sext.w	a4,a4
    800052bc:	747277b7          	lui	a5,0x74727
    800052c0:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800052c4:	0ef71563          	bne	a4,a5,800053ae <virtio_disk_init+0x11a>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800052c8:	100017b7          	lui	a5,0x10001
    800052cc:	43dc                	lw	a5,4(a5)
    800052ce:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800052d0:	4705                	li	a4,1
    800052d2:	0ce79e63          	bne	a5,a4,800053ae <virtio_disk_init+0x11a>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800052d6:	100017b7          	lui	a5,0x10001
    800052da:	479c                	lw	a5,8(a5)
    800052dc:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800052de:	4709                	li	a4,2
    800052e0:	0ce79763          	bne	a5,a4,800053ae <virtio_disk_init+0x11a>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800052e4:	100017b7          	lui	a5,0x10001
    800052e8:	47d8                	lw	a4,12(a5)
    800052ea:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800052ec:	554d47b7          	lui	a5,0x554d4
    800052f0:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800052f4:	0af71d63          	bne	a4,a5,800053ae <virtio_disk_init+0x11a>
  *R(VIRTIO_MMIO_STATUS) = status;
    800052f8:	100017b7          	lui	a5,0x10001
    800052fc:	4705                	li	a4,1
    800052fe:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005300:	470d                	li	a4,3
    80005302:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005304:	10001737          	lui	a4,0x10001
    80005308:	4b18                	lw	a4,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    8000530a:	c7ffe6b7          	lui	a3,0xc7ffe
    8000530e:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fd851f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005312:	8f75                	and	a4,a4,a3
    80005314:	100016b7          	lui	a3,0x10001
    80005318:	d298                	sw	a4,32(a3)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000531a:	472d                	li	a4,11
    8000531c:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000531e:	473d                	li	a4,15
    80005320:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80005322:	6705                	lui	a4,0x1
    80005324:	d698                	sw	a4,40(a3)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005326:	0206a823          	sw	zero,48(a3) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    8000532a:	5adc                	lw	a5,52(a3)
    8000532c:	2781                	sext.w	a5,a5
  if(max == 0)
    8000532e:	cbc1                	beqz	a5,800053be <virtio_disk_init+0x12a>
  if(max < NUM)
    80005330:	471d                	li	a4,7
    80005332:	08f77e63          	bgeu	a4,a5,800053ce <virtio_disk_init+0x13a>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005336:	100017b7          	lui	a5,0x10001
    8000533a:	4721                	li	a4,8
    8000533c:	df98                	sw	a4,56(a5)
  memset(disk.pages, 0, sizeof(disk.pages));
    8000533e:	6609                	lui	a2,0x2
    80005340:	4581                	li	a1,0
    80005342:	00016517          	auipc	a0,0x16
    80005346:	cbe50513          	addi	a0,a0,-834 # 8001b000 <disk>
    8000534a:	ffffb097          	auipc	ra,0xffffb
    8000534e:	e30080e7          	jalr	-464(ra) # 8000017a <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    80005352:	00016717          	auipc	a4,0x16
    80005356:	cae70713          	addi	a4,a4,-850 # 8001b000 <disk>
    8000535a:	00c75793          	srli	a5,a4,0xc
    8000535e:	2781                	sext.w	a5,a5
    80005360:	100016b7          	lui	a3,0x10001
    80005364:	c2bc                	sw	a5,64(a3)
  disk.desc = (struct virtq_desc *) disk.pages;
    80005366:	00018797          	auipc	a5,0x18
    8000536a:	c9a78793          	addi	a5,a5,-870 # 8001d000 <disk+0x2000>
    8000536e:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005370:	00016717          	auipc	a4,0x16
    80005374:	d1070713          	addi	a4,a4,-752 # 8001b080 <disk+0x80>
    80005378:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    8000537a:	00017717          	auipc	a4,0x17
    8000537e:	c8670713          	addi	a4,a4,-890 # 8001c000 <disk+0x1000>
    80005382:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    80005384:	4705                	li	a4,1
    80005386:	00e78c23          	sb	a4,24(a5)
    8000538a:	00e78ca3          	sb	a4,25(a5)
    8000538e:	00e78d23          	sb	a4,26(a5)
    80005392:	00e78da3          	sb	a4,27(a5)
    80005396:	00e78e23          	sb	a4,28(a5)
    8000539a:	00e78ea3          	sb	a4,29(a5)
    8000539e:	00e78f23          	sb	a4,30(a5)
    800053a2:	00e78fa3          	sb	a4,31(a5)
}
    800053a6:	60a2                	ld	ra,8(sp)
    800053a8:	6402                	ld	s0,0(sp)
    800053aa:	0141                	addi	sp,sp,16
    800053ac:	8082                	ret
    panic("could not find virtio disk");
    800053ae:	00003517          	auipc	a0,0x3
    800053b2:	27250513          	addi	a0,a0,626 # 80008620 <etext+0x620>
    800053b6:	00001097          	auipc	ra,0x1
    800053ba:	8bc080e7          	jalr	-1860(ra) # 80005c72 <panic>
    panic("virtio disk has no queue 0");
    800053be:	00003517          	auipc	a0,0x3
    800053c2:	28250513          	addi	a0,a0,642 # 80008640 <etext+0x640>
    800053c6:	00001097          	auipc	ra,0x1
    800053ca:	8ac080e7          	jalr	-1876(ra) # 80005c72 <panic>
    panic("virtio disk max queue too short");
    800053ce:	00003517          	auipc	a0,0x3
    800053d2:	29250513          	addi	a0,a0,658 # 80008660 <etext+0x660>
    800053d6:	00001097          	auipc	ra,0x1
    800053da:	89c080e7          	jalr	-1892(ra) # 80005c72 <panic>

00000000800053de <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800053de:	711d                	addi	sp,sp,-96
    800053e0:	ec86                	sd	ra,88(sp)
    800053e2:	e8a2                	sd	s0,80(sp)
    800053e4:	e4a6                	sd	s1,72(sp)
    800053e6:	e0ca                	sd	s2,64(sp)
    800053e8:	fc4e                	sd	s3,56(sp)
    800053ea:	f852                	sd	s4,48(sp)
    800053ec:	f456                	sd	s5,40(sp)
    800053ee:	f05a                	sd	s6,32(sp)
    800053f0:	ec5e                	sd	s7,24(sp)
    800053f2:	e862                	sd	s8,16(sp)
    800053f4:	1080                	addi	s0,sp,96
    800053f6:	89aa                	mv	s3,a0
    800053f8:	8c2e                	mv	s8,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800053fa:	00c52b83          	lw	s7,12(a0)
    800053fe:	001b9b9b          	slliw	s7,s7,0x1
    80005402:	1b82                	slli	s7,s7,0x20
    80005404:	020bdb93          	srli	s7,s7,0x20

  acquire(&disk.vdisk_lock);
    80005408:	00018517          	auipc	a0,0x18
    8000540c:	d2050513          	addi	a0,a0,-736 # 8001d128 <disk+0x2128>
    80005410:	00001097          	auipc	ra,0x1
    80005414:	de2080e7          	jalr	-542(ra) # 800061f2 <acquire>
  for(int i = 0; i < NUM; i++){
    80005418:	44a1                	li	s1,8
      disk.free[i] = 0;
    8000541a:	00016b17          	auipc	s6,0x16
    8000541e:	be6b0b13          	addi	s6,s6,-1050 # 8001b000 <disk>
    80005422:	6a89                	lui	s5,0x2
  for(int i = 0; i < 3; i++){
    80005424:	4a0d                	li	s4,3
    80005426:	a88d                	j	80005498 <virtio_disk_rw+0xba>
      disk.free[i] = 0;
    80005428:	00fb0733          	add	a4,s6,a5
    8000542c:	9756                	add	a4,a4,s5
    8000542e:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80005432:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80005434:	0207c563          	bltz	a5,8000545e <virtio_disk_rw+0x80>
  for(int i = 0; i < 3; i++){
    80005438:	2905                	addiw	s2,s2,1
    8000543a:	0611                	addi	a2,a2,4 # 2004 <_entry-0x7fffdffc>
    8000543c:	1b490063          	beq	s2,s4,800055dc <virtio_disk_rw+0x1fe>
    idx[i] = alloc_desc();
    80005440:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80005442:	00018717          	auipc	a4,0x18
    80005446:	bd670713          	addi	a4,a4,-1066 # 8001d018 <disk+0x2018>
    8000544a:	4781                	li	a5,0
    if(disk.free[i]){
    8000544c:	00074683          	lbu	a3,0(a4)
    80005450:	fee1                	bnez	a3,80005428 <virtio_disk_rw+0x4a>
  for(int i = 0; i < NUM; i++){
    80005452:	2785                	addiw	a5,a5,1
    80005454:	0705                	addi	a4,a4,1
    80005456:	fe979be3          	bne	a5,s1,8000544c <virtio_disk_rw+0x6e>
    idx[i] = alloc_desc();
    8000545a:	57fd                	li	a5,-1
    8000545c:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    8000545e:	03205163          	blez	s2,80005480 <virtio_disk_rw+0xa2>
        free_desc(idx[j]);
    80005462:	fa042503          	lw	a0,-96(s0)
    80005466:	00000097          	auipc	ra,0x0
    8000546a:	d94080e7          	jalr	-620(ra) # 800051fa <free_desc>
      for(int j = 0; j < i; j++)
    8000546e:	4785                	li	a5,1
    80005470:	0127d863          	bge	a5,s2,80005480 <virtio_disk_rw+0xa2>
        free_desc(idx[j]);
    80005474:	fa442503          	lw	a0,-92(s0)
    80005478:	00000097          	auipc	ra,0x0
    8000547c:	d82080e7          	jalr	-638(ra) # 800051fa <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005480:	00018597          	auipc	a1,0x18
    80005484:	ca858593          	addi	a1,a1,-856 # 8001d128 <disk+0x2128>
    80005488:	00018517          	auipc	a0,0x18
    8000548c:	b9050513          	addi	a0,a0,-1136 # 8001d018 <disk+0x2018>
    80005490:	ffffc097          	auipc	ra,0xffffc
    80005494:	0d8080e7          	jalr	216(ra) # 80001568 <sleep>
  for(int i = 0; i < 3; i++){
    80005498:	fa040613          	addi	a2,s0,-96
    8000549c:	4901                	li	s2,0
    8000549e:	b74d                	j	80005440 <virtio_disk_rw+0x62>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    800054a0:	00018717          	auipc	a4,0x18
    800054a4:	b6073703          	ld	a4,-1184(a4) # 8001d000 <disk+0x2000>
    800054a8:	973e                	add	a4,a4,a5
    800054aa:	00071623          	sh	zero,12(a4)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800054ae:	00016897          	auipc	a7,0x16
    800054b2:	b5288893          	addi	a7,a7,-1198 # 8001b000 <disk>
    800054b6:	00018717          	auipc	a4,0x18
    800054ba:	b4a70713          	addi	a4,a4,-1206 # 8001d000 <disk+0x2000>
    800054be:	6314                	ld	a3,0(a4)
    800054c0:	96be                	add	a3,a3,a5
    800054c2:	00c6d583          	lhu	a1,12(a3) # 1000100c <_entry-0x6fffeff4>
    800054c6:	0015e593          	ori	a1,a1,1
    800054ca:	00b69623          	sh	a1,12(a3)
  disk.desc[idx[1]].next = idx[2];
    800054ce:	fa842683          	lw	a3,-88(s0)
    800054d2:	630c                	ld	a1,0(a4)
    800054d4:	97ae                	add	a5,a5,a1
    800054d6:	00d79723          	sh	a3,14(a5)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800054da:	20050593          	addi	a1,a0,512
    800054de:	0592                	slli	a1,a1,0x4
    800054e0:	95c6                	add	a1,a1,a7
    800054e2:	57fd                	li	a5,-1
    800054e4:	02f58823          	sb	a5,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800054e8:	00469793          	slli	a5,a3,0x4
    800054ec:	00073803          	ld	a6,0(a4)
    800054f0:	983e                	add	a6,a6,a5
    800054f2:	6689                	lui	a3,0x2
    800054f4:	03068693          	addi	a3,a3,48 # 2030 <_entry-0x7fffdfd0>
    800054f8:	96b2                	add	a3,a3,a2
    800054fa:	96c6                	add	a3,a3,a7
    800054fc:	00d83023          	sd	a3,0(a6)
  disk.desc[idx[2]].len = 1;
    80005500:	6314                	ld	a3,0(a4)
    80005502:	96be                	add	a3,a3,a5
    80005504:	4605                	li	a2,1
    80005506:	c690                	sw	a2,8(a3)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005508:	6314                	ld	a3,0(a4)
    8000550a:	96be                	add	a3,a3,a5
    8000550c:	4809                	li	a6,2
    8000550e:	01069623          	sh	a6,12(a3)
  disk.desc[idx[2]].next = 0;
    80005512:	6314                	ld	a3,0(a4)
    80005514:	97b6                	add	a5,a5,a3
    80005516:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000551a:	00c9a223          	sw	a2,4(s3)
  disk.info[idx[0]].b = b;
    8000551e:	0335b423          	sd	s3,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005522:	6714                	ld	a3,8(a4)
    80005524:	0026d783          	lhu	a5,2(a3)
    80005528:	8b9d                	andi	a5,a5,7
    8000552a:	0786                	slli	a5,a5,0x1
    8000552c:	96be                	add	a3,a3,a5
    8000552e:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80005532:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005536:	6718                	ld	a4,8(a4)
    80005538:	00275783          	lhu	a5,2(a4)
    8000553c:	2785                	addiw	a5,a5,1
    8000553e:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005542:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005546:	100017b7          	lui	a5,0x10001
    8000554a:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    8000554e:	0049a783          	lw	a5,4(s3)
    80005552:	02c79163          	bne	a5,a2,80005574 <virtio_disk_rw+0x196>
    sleep(b, &disk.vdisk_lock);
    80005556:	00018917          	auipc	s2,0x18
    8000555a:	bd290913          	addi	s2,s2,-1070 # 8001d128 <disk+0x2128>
  while(b->disk == 1) {
    8000555e:	84b2                	mv	s1,a2
    sleep(b, &disk.vdisk_lock);
    80005560:	85ca                	mv	a1,s2
    80005562:	854e                	mv	a0,s3
    80005564:	ffffc097          	auipc	ra,0xffffc
    80005568:	004080e7          	jalr	4(ra) # 80001568 <sleep>
  while(b->disk == 1) {
    8000556c:	0049a783          	lw	a5,4(s3)
    80005570:	fe9788e3          	beq	a5,s1,80005560 <virtio_disk_rw+0x182>
  }

  disk.info[idx[0]].b = 0;
    80005574:	fa042903          	lw	s2,-96(s0)
    80005578:	20090713          	addi	a4,s2,512
    8000557c:	0712                	slli	a4,a4,0x4
    8000557e:	00016797          	auipc	a5,0x16
    80005582:	a8278793          	addi	a5,a5,-1406 # 8001b000 <disk>
    80005586:	97ba                	add	a5,a5,a4
    80005588:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    8000558c:	00018997          	auipc	s3,0x18
    80005590:	a7498993          	addi	s3,s3,-1420 # 8001d000 <disk+0x2000>
    80005594:	00491713          	slli	a4,s2,0x4
    80005598:	0009b783          	ld	a5,0(s3)
    8000559c:	97ba                	add	a5,a5,a4
    8000559e:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800055a2:	854a                	mv	a0,s2
    800055a4:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800055a8:	00000097          	auipc	ra,0x0
    800055ac:	c52080e7          	jalr	-942(ra) # 800051fa <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800055b0:	8885                	andi	s1,s1,1
    800055b2:	f0ed                	bnez	s1,80005594 <virtio_disk_rw+0x1b6>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800055b4:	00018517          	auipc	a0,0x18
    800055b8:	b7450513          	addi	a0,a0,-1164 # 8001d128 <disk+0x2128>
    800055bc:	00001097          	auipc	ra,0x1
    800055c0:	ce6080e7          	jalr	-794(ra) # 800062a2 <release>
}
    800055c4:	60e6                	ld	ra,88(sp)
    800055c6:	6446                	ld	s0,80(sp)
    800055c8:	64a6                	ld	s1,72(sp)
    800055ca:	6906                	ld	s2,64(sp)
    800055cc:	79e2                	ld	s3,56(sp)
    800055ce:	7a42                	ld	s4,48(sp)
    800055d0:	7aa2                	ld	s5,40(sp)
    800055d2:	7b02                	ld	s6,32(sp)
    800055d4:	6be2                	ld	s7,24(sp)
    800055d6:	6c42                	ld	s8,16(sp)
    800055d8:	6125                	addi	sp,sp,96
    800055da:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800055dc:	fa042503          	lw	a0,-96(s0)
    800055e0:	00451613          	slli	a2,a0,0x4
  if(write)
    800055e4:	00016597          	auipc	a1,0x16
    800055e8:	a1c58593          	addi	a1,a1,-1508 # 8001b000 <disk>
    800055ec:	20050793          	addi	a5,a0,512
    800055f0:	0792                	slli	a5,a5,0x4
    800055f2:	97ae                	add	a5,a5,a1
    800055f4:	01803733          	snez	a4,s8
    800055f8:	0ae7a423          	sw	a4,168(a5)
  buf0->reserved = 0;
    800055fc:	0a07a623          	sw	zero,172(a5)
  buf0->sector = sector;
    80005600:	0b77b823          	sd	s7,176(a5)
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005604:	00018717          	auipc	a4,0x18
    80005608:	9fc70713          	addi	a4,a4,-1540 # 8001d000 <disk+0x2000>
    8000560c:	6314                	ld	a3,0(a4)
    8000560e:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005610:	6789                	lui	a5,0x2
    80005612:	0a878793          	addi	a5,a5,168 # 20a8 <_entry-0x7fffdf58>
    80005616:	97b2                	add	a5,a5,a2
    80005618:	97ae                	add	a5,a5,a1
  disk.desc[idx[0]].addr = (uint64) buf0;
    8000561a:	e29c                	sd	a5,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000561c:	631c                	ld	a5,0(a4)
    8000561e:	97b2                	add	a5,a5,a2
    80005620:	46c1                	li	a3,16
    80005622:	c794                	sw	a3,8(a5)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005624:	631c                	ld	a5,0(a4)
    80005626:	97b2                	add	a5,a5,a2
    80005628:	4685                	li	a3,1
    8000562a:	00d79623          	sh	a3,12(a5)
  disk.desc[idx[0]].next = idx[1];
    8000562e:	fa442783          	lw	a5,-92(s0)
    80005632:	6314                	ld	a3,0(a4)
    80005634:	96b2                	add	a3,a3,a2
    80005636:	00f69723          	sh	a5,14(a3)
  disk.desc[idx[1]].addr = (uint64) b->data;
    8000563a:	0792                	slli	a5,a5,0x4
    8000563c:	6314                	ld	a3,0(a4)
    8000563e:	96be                	add	a3,a3,a5
    80005640:	05898593          	addi	a1,s3,88
    80005644:	e28c                	sd	a1,0(a3)
  disk.desc[idx[1]].len = BSIZE;
    80005646:	6318                	ld	a4,0(a4)
    80005648:	973e                	add	a4,a4,a5
    8000564a:	40000693          	li	a3,1024
    8000564e:	c714                	sw	a3,8(a4)
  if(write)
    80005650:	e40c18e3          	bnez	s8,800054a0 <virtio_disk_rw+0xc2>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80005654:	00018717          	auipc	a4,0x18
    80005658:	9ac73703          	ld	a4,-1620(a4) # 8001d000 <disk+0x2000>
    8000565c:	973e                	add	a4,a4,a5
    8000565e:	4689                	li	a3,2
    80005660:	00d71623          	sh	a3,12(a4)
    80005664:	b5a9                	j	800054ae <virtio_disk_rw+0xd0>

0000000080005666 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005666:	1101                	addi	sp,sp,-32
    80005668:	ec06                	sd	ra,24(sp)
    8000566a:	e822                	sd	s0,16(sp)
    8000566c:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000566e:	00018517          	auipc	a0,0x18
    80005672:	aba50513          	addi	a0,a0,-1350 # 8001d128 <disk+0x2128>
    80005676:	00001097          	auipc	ra,0x1
    8000567a:	b7c080e7          	jalr	-1156(ra) # 800061f2 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    8000567e:	100017b7          	lui	a5,0x10001
    80005682:	53bc                	lw	a5,96(a5)
    80005684:	8b8d                	andi	a5,a5,3
    80005686:	10001737          	lui	a4,0x10001
    8000568a:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    8000568c:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005690:	00018797          	auipc	a5,0x18
    80005694:	97078793          	addi	a5,a5,-1680 # 8001d000 <disk+0x2000>
    80005698:	6b94                	ld	a3,16(a5)
    8000569a:	0207d703          	lhu	a4,32(a5)
    8000569e:	0026d783          	lhu	a5,2(a3)
    800056a2:	06f70563          	beq	a4,a5,8000570c <virtio_disk_intr+0xa6>
    800056a6:	e426                	sd	s1,8(sp)
    800056a8:	e04a                	sd	s2,0(sp)
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800056aa:	00016917          	auipc	s2,0x16
    800056ae:	95690913          	addi	s2,s2,-1706 # 8001b000 <disk>
    800056b2:	00018497          	auipc	s1,0x18
    800056b6:	94e48493          	addi	s1,s1,-1714 # 8001d000 <disk+0x2000>
    __sync_synchronize();
    800056ba:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800056be:	6898                	ld	a4,16(s1)
    800056c0:	0204d783          	lhu	a5,32(s1)
    800056c4:	8b9d                	andi	a5,a5,7
    800056c6:	078e                	slli	a5,a5,0x3
    800056c8:	97ba                	add	a5,a5,a4
    800056ca:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800056cc:	20078713          	addi	a4,a5,512
    800056d0:	0712                	slli	a4,a4,0x4
    800056d2:	974a                	add	a4,a4,s2
    800056d4:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    800056d8:	e731                	bnez	a4,80005724 <virtio_disk_intr+0xbe>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800056da:	20078793          	addi	a5,a5,512
    800056de:	0792                	slli	a5,a5,0x4
    800056e0:	97ca                	add	a5,a5,s2
    800056e2:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    800056e4:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800056e8:	ffffc097          	auipc	ra,0xffffc
    800056ec:	006080e7          	jalr	6(ra) # 800016ee <wakeup>

    disk.used_idx += 1;
    800056f0:	0204d783          	lhu	a5,32(s1)
    800056f4:	2785                	addiw	a5,a5,1
    800056f6:	17c2                	slli	a5,a5,0x30
    800056f8:	93c1                	srli	a5,a5,0x30
    800056fa:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800056fe:	6898                	ld	a4,16(s1)
    80005700:	00275703          	lhu	a4,2(a4)
    80005704:	faf71be3          	bne	a4,a5,800056ba <virtio_disk_intr+0x54>
    80005708:	64a2                	ld	s1,8(sp)
    8000570a:	6902                	ld	s2,0(sp)
  }

  release(&disk.vdisk_lock);
    8000570c:	00018517          	auipc	a0,0x18
    80005710:	a1c50513          	addi	a0,a0,-1508 # 8001d128 <disk+0x2128>
    80005714:	00001097          	auipc	ra,0x1
    80005718:	b8e080e7          	jalr	-1138(ra) # 800062a2 <release>
}
    8000571c:	60e2                	ld	ra,24(sp)
    8000571e:	6442                	ld	s0,16(sp)
    80005720:	6105                	addi	sp,sp,32
    80005722:	8082                	ret
      panic("virtio_disk_intr status");
    80005724:	00003517          	auipc	a0,0x3
    80005728:	f5c50513          	addi	a0,a0,-164 # 80008680 <etext+0x680>
    8000572c:	00000097          	auipc	ra,0x0
    80005730:	546080e7          	jalr	1350(ra) # 80005c72 <panic>

0000000080005734 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005734:	1141                	addi	sp,sp,-16
    80005736:	e406                	sd	ra,8(sp)
    80005738:	e022                	sd	s0,0(sp)
    8000573a:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000573c:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005740:	2781                	sext.w	a5,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005742:	0037961b          	slliw	a2,a5,0x3
    80005746:	02004737          	lui	a4,0x2004
    8000574a:	963a                	add	a2,a2,a4
    8000574c:	0200c737          	lui	a4,0x200c
    80005750:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005754:	000f46b7          	lui	a3,0xf4
    80005758:	24068693          	addi	a3,a3,576 # f4240 <_entry-0x7ff0bdc0>
    8000575c:	9736                	add	a4,a4,a3
    8000575e:	e218                	sd	a4,0(a2)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005760:	00279713          	slli	a4,a5,0x2
    80005764:	973e                	add	a4,a4,a5
    80005766:	070e                	slli	a4,a4,0x3
    80005768:	00019797          	auipc	a5,0x19
    8000576c:	89878793          	addi	a5,a5,-1896 # 8001e000 <timer_scratch>
    80005770:	97ba                	add	a5,a5,a4
  scratch[3] = CLINT_MTIMECMP(id);
    80005772:	ef90                	sd	a2,24(a5)
  scratch[4] = interval;
    80005774:	f394                	sd	a3,32(a5)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005776:	34079073          	csrw	mscratch,a5
  asm volatile("csrw mtvec, %0" : : "r" (x));
    8000577a:	00000797          	auipc	a5,0x0
    8000577e:	9b678793          	addi	a5,a5,-1610 # 80005130 <timervec>
    80005782:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005786:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    8000578a:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    8000578e:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005792:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005796:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    8000579a:	30479073          	csrw	mie,a5
}
    8000579e:	60a2                	ld	ra,8(sp)
    800057a0:	6402                	ld	s0,0(sp)
    800057a2:	0141                	addi	sp,sp,16
    800057a4:	8082                	ret

00000000800057a6 <start>:
{
    800057a6:	1141                	addi	sp,sp,-16
    800057a8:	e406                	sd	ra,8(sp)
    800057aa:	e022                	sd	s0,0(sp)
    800057ac:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800057ae:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800057b2:	7779                	lui	a4,0xffffe
    800057b4:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd85bf>
    800057b8:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800057ba:	6705                	lui	a4,0x1
    800057bc:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800057c0:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800057c2:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800057c6:	ffffb797          	auipc	a5,0xffffb
    800057ca:	b6e78793          	addi	a5,a5,-1170 # 80000334 <main>
    800057ce:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800057d2:	4781                	li	a5,0
    800057d4:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800057d8:	67c1                	lui	a5,0x10
    800057da:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    800057dc:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800057e0:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800057e4:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800057e8:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800057ec:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800057f0:	57fd                	li	a5,-1
    800057f2:	83a9                	srli	a5,a5,0xa
    800057f4:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800057f8:	47bd                	li	a5,15
    800057fa:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800057fe:	00000097          	auipc	ra,0x0
    80005802:	f36080e7          	jalr	-202(ra) # 80005734 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005806:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    8000580a:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    8000580c:	823e                	mv	tp,a5
  asm volatile("mret");
    8000580e:	30200073          	mret
}
    80005812:	60a2                	ld	ra,8(sp)
    80005814:	6402                	ld	s0,0(sp)
    80005816:	0141                	addi	sp,sp,16
    80005818:	8082                	ret

000000008000581a <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    8000581a:	711d                	addi	sp,sp,-96
    8000581c:	ec86                	sd	ra,88(sp)
    8000581e:	e8a2                	sd	s0,80(sp)
    80005820:	e0ca                	sd	s2,64(sp)
    80005822:	1080                	addi	s0,sp,96
  int i;

  for(i = 0; i < n; i++){
    80005824:	04c05c63          	blez	a2,8000587c <consolewrite+0x62>
    80005828:	e4a6                	sd	s1,72(sp)
    8000582a:	fc4e                	sd	s3,56(sp)
    8000582c:	f852                	sd	s4,48(sp)
    8000582e:	f456                	sd	s5,40(sp)
    80005830:	f05a                	sd	s6,32(sp)
    80005832:	ec5e                	sd	s7,24(sp)
    80005834:	8a2a                	mv	s4,a0
    80005836:	84ae                	mv	s1,a1
    80005838:	89b2                	mv	s3,a2
    8000583a:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000583c:	faf40b93          	addi	s7,s0,-81
    80005840:	4b05                	li	s6,1
    80005842:	5afd                	li	s5,-1
    80005844:	86da                	mv	a3,s6
    80005846:	8626                	mv	a2,s1
    80005848:	85d2                	mv	a1,s4
    8000584a:	855e                	mv	a0,s7
    8000584c:	ffffc097          	auipc	ra,0xffffc
    80005850:	110080e7          	jalr	272(ra) # 8000195c <either_copyin>
    80005854:	03550663          	beq	a0,s5,80005880 <consolewrite+0x66>
      break;
    uartputc(c);
    80005858:	faf44503          	lbu	a0,-81(s0)
    8000585c:	00000097          	auipc	ra,0x0
    80005860:	7d4080e7          	jalr	2004(ra) # 80006030 <uartputc>
  for(i = 0; i < n; i++){
    80005864:	2905                	addiw	s2,s2,1
    80005866:	0485                	addi	s1,s1,1
    80005868:	fd299ee3          	bne	s3,s2,80005844 <consolewrite+0x2a>
    8000586c:	894e                	mv	s2,s3
    8000586e:	64a6                	ld	s1,72(sp)
    80005870:	79e2                	ld	s3,56(sp)
    80005872:	7a42                	ld	s4,48(sp)
    80005874:	7aa2                	ld	s5,40(sp)
    80005876:	7b02                	ld	s6,32(sp)
    80005878:	6be2                	ld	s7,24(sp)
    8000587a:	a809                	j	8000588c <consolewrite+0x72>
    8000587c:	4901                	li	s2,0
    8000587e:	a039                	j	8000588c <consolewrite+0x72>
    80005880:	64a6                	ld	s1,72(sp)
    80005882:	79e2                	ld	s3,56(sp)
    80005884:	7a42                	ld	s4,48(sp)
    80005886:	7aa2                	ld	s5,40(sp)
    80005888:	7b02                	ld	s6,32(sp)
    8000588a:	6be2                	ld	s7,24(sp)
  }

  return i;
}
    8000588c:	854a                	mv	a0,s2
    8000588e:	60e6                	ld	ra,88(sp)
    80005890:	6446                	ld	s0,80(sp)
    80005892:	6906                	ld	s2,64(sp)
    80005894:	6125                	addi	sp,sp,96
    80005896:	8082                	ret

0000000080005898 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005898:	711d                	addi	sp,sp,-96
    8000589a:	ec86                	sd	ra,88(sp)
    8000589c:	e8a2                	sd	s0,80(sp)
    8000589e:	e4a6                	sd	s1,72(sp)
    800058a0:	e0ca                	sd	s2,64(sp)
    800058a2:	fc4e                	sd	s3,56(sp)
    800058a4:	f852                	sd	s4,48(sp)
    800058a6:	f456                	sd	s5,40(sp)
    800058a8:	f05a                	sd	s6,32(sp)
    800058aa:	1080                	addi	s0,sp,96
    800058ac:	8aaa                	mv	s5,a0
    800058ae:	8a2e                	mv	s4,a1
    800058b0:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    800058b2:	8b32                	mv	s6,a2
  acquire(&cons.lock);
    800058b4:	00021517          	auipc	a0,0x21
    800058b8:	88c50513          	addi	a0,a0,-1908 # 80026140 <cons>
    800058bc:	00001097          	auipc	ra,0x1
    800058c0:	936080e7          	jalr	-1738(ra) # 800061f2 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800058c4:	00021497          	auipc	s1,0x21
    800058c8:	87c48493          	addi	s1,s1,-1924 # 80026140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800058cc:	00021917          	auipc	s2,0x21
    800058d0:	90c90913          	addi	s2,s2,-1780 # 800261d8 <cons+0x98>
  while(n > 0){
    800058d4:	0d305263          	blez	s3,80005998 <consoleread+0x100>
    while(cons.r == cons.w){
    800058d8:	0984a783          	lw	a5,152(s1)
    800058dc:	09c4a703          	lw	a4,156(s1)
    800058e0:	0af71763          	bne	a4,a5,8000598e <consoleread+0xf6>
      if(myproc()->killed){
    800058e4:	ffffb097          	auipc	ra,0xffffb
    800058e8:	5be080e7          	jalr	1470(ra) # 80000ea2 <myproc>
    800058ec:	551c                	lw	a5,40(a0)
    800058ee:	e7ad                	bnez	a5,80005958 <consoleread+0xc0>
      sleep(&cons.r, &cons.lock);
    800058f0:	85a6                	mv	a1,s1
    800058f2:	854a                	mv	a0,s2
    800058f4:	ffffc097          	auipc	ra,0xffffc
    800058f8:	c74080e7          	jalr	-908(ra) # 80001568 <sleep>
    while(cons.r == cons.w){
    800058fc:	0984a783          	lw	a5,152(s1)
    80005900:	09c4a703          	lw	a4,156(s1)
    80005904:	fef700e3          	beq	a4,a5,800058e4 <consoleread+0x4c>
    80005908:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF];
    8000590a:	00021717          	auipc	a4,0x21
    8000590e:	83670713          	addi	a4,a4,-1994 # 80026140 <cons>
    80005912:	0017869b          	addiw	a3,a5,1
    80005916:	08d72c23          	sw	a3,152(a4)
    8000591a:	07f7f693          	andi	a3,a5,127
    8000591e:	9736                	add	a4,a4,a3
    80005920:	01874703          	lbu	a4,24(a4)
    80005924:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80005928:	4691                	li	a3,4
    8000592a:	04db8a63          	beq	s7,a3,8000597e <consoleread+0xe6>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    8000592e:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005932:	4685                	li	a3,1
    80005934:	faf40613          	addi	a2,s0,-81
    80005938:	85d2                	mv	a1,s4
    8000593a:	8556                	mv	a0,s5
    8000593c:	ffffc097          	auipc	ra,0xffffc
    80005940:	fca080e7          	jalr	-54(ra) # 80001906 <either_copyout>
    80005944:	57fd                	li	a5,-1
    80005946:	04f50863          	beq	a0,a5,80005996 <consoleread+0xfe>
      break;

    dst++;
    8000594a:	0a05                	addi	s4,s4,1
    --n;
    8000594c:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    8000594e:	47a9                	li	a5,10
    80005950:	04fb8f63          	beq	s7,a5,800059ae <consoleread+0x116>
    80005954:	6be2                	ld	s7,24(sp)
    80005956:	bfbd                	j	800058d4 <consoleread+0x3c>
        release(&cons.lock);
    80005958:	00020517          	auipc	a0,0x20
    8000595c:	7e850513          	addi	a0,a0,2024 # 80026140 <cons>
    80005960:	00001097          	auipc	ra,0x1
    80005964:	942080e7          	jalr	-1726(ra) # 800062a2 <release>
        return -1;
    80005968:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    8000596a:	60e6                	ld	ra,88(sp)
    8000596c:	6446                	ld	s0,80(sp)
    8000596e:	64a6                	ld	s1,72(sp)
    80005970:	6906                	ld	s2,64(sp)
    80005972:	79e2                	ld	s3,56(sp)
    80005974:	7a42                	ld	s4,48(sp)
    80005976:	7aa2                	ld	s5,40(sp)
    80005978:	7b02                	ld	s6,32(sp)
    8000597a:	6125                	addi	sp,sp,96
    8000597c:	8082                	ret
      if(n < target){
    8000597e:	0169fa63          	bgeu	s3,s6,80005992 <consoleread+0xfa>
        cons.r--;
    80005982:	00021717          	auipc	a4,0x21
    80005986:	84f72b23          	sw	a5,-1962(a4) # 800261d8 <cons+0x98>
    8000598a:	6be2                	ld	s7,24(sp)
    8000598c:	a031                	j	80005998 <consoleread+0x100>
    8000598e:	ec5e                	sd	s7,24(sp)
    80005990:	bfad                	j	8000590a <consoleread+0x72>
    80005992:	6be2                	ld	s7,24(sp)
    80005994:	a011                	j	80005998 <consoleread+0x100>
    80005996:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80005998:	00020517          	auipc	a0,0x20
    8000599c:	7a850513          	addi	a0,a0,1960 # 80026140 <cons>
    800059a0:	00001097          	auipc	ra,0x1
    800059a4:	902080e7          	jalr	-1790(ra) # 800062a2 <release>
  return target - n;
    800059a8:	413b053b          	subw	a0,s6,s3
    800059ac:	bf7d                	j	8000596a <consoleread+0xd2>
    800059ae:	6be2                	ld	s7,24(sp)
    800059b0:	b7e5                	j	80005998 <consoleread+0x100>

00000000800059b2 <consputc>:
{
    800059b2:	1141                	addi	sp,sp,-16
    800059b4:	e406                	sd	ra,8(sp)
    800059b6:	e022                	sd	s0,0(sp)
    800059b8:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    800059ba:	10000793          	li	a5,256
    800059be:	00f50a63          	beq	a0,a5,800059d2 <consputc+0x20>
    uartputc_sync(c);
    800059c2:	00000097          	auipc	ra,0x0
    800059c6:	590080e7          	jalr	1424(ra) # 80005f52 <uartputc_sync>
}
    800059ca:	60a2                	ld	ra,8(sp)
    800059cc:	6402                	ld	s0,0(sp)
    800059ce:	0141                	addi	sp,sp,16
    800059d0:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800059d2:	4521                	li	a0,8
    800059d4:	00000097          	auipc	ra,0x0
    800059d8:	57e080e7          	jalr	1406(ra) # 80005f52 <uartputc_sync>
    800059dc:	02000513          	li	a0,32
    800059e0:	00000097          	auipc	ra,0x0
    800059e4:	572080e7          	jalr	1394(ra) # 80005f52 <uartputc_sync>
    800059e8:	4521                	li	a0,8
    800059ea:	00000097          	auipc	ra,0x0
    800059ee:	568080e7          	jalr	1384(ra) # 80005f52 <uartputc_sync>
    800059f2:	bfe1                	j	800059ca <consputc+0x18>

00000000800059f4 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800059f4:	7179                	addi	sp,sp,-48
    800059f6:	f406                	sd	ra,40(sp)
    800059f8:	f022                	sd	s0,32(sp)
    800059fa:	ec26                	sd	s1,24(sp)
    800059fc:	1800                	addi	s0,sp,48
    800059fe:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005a00:	00020517          	auipc	a0,0x20
    80005a04:	74050513          	addi	a0,a0,1856 # 80026140 <cons>
    80005a08:	00000097          	auipc	ra,0x0
    80005a0c:	7ea080e7          	jalr	2026(ra) # 800061f2 <acquire>

  switch(c){
    80005a10:	47d5                	li	a5,21
    80005a12:	0af48463          	beq	s1,a5,80005aba <consoleintr+0xc6>
    80005a16:	0297c963          	blt	a5,s1,80005a48 <consoleintr+0x54>
    80005a1a:	47a1                	li	a5,8
    80005a1c:	10f48063          	beq	s1,a5,80005b1c <consoleintr+0x128>
    80005a20:	47c1                	li	a5,16
    80005a22:	12f49363          	bne	s1,a5,80005b48 <consoleintr+0x154>
  case C('P'):  // Print process list.
    procdump();
    80005a26:	ffffc097          	auipc	ra,0xffffc
    80005a2a:	f8c080e7          	jalr	-116(ra) # 800019b2 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005a2e:	00020517          	auipc	a0,0x20
    80005a32:	71250513          	addi	a0,a0,1810 # 80026140 <cons>
    80005a36:	00001097          	auipc	ra,0x1
    80005a3a:	86c080e7          	jalr	-1940(ra) # 800062a2 <release>
}
    80005a3e:	70a2                	ld	ra,40(sp)
    80005a40:	7402                	ld	s0,32(sp)
    80005a42:	64e2                	ld	s1,24(sp)
    80005a44:	6145                	addi	sp,sp,48
    80005a46:	8082                	ret
  switch(c){
    80005a48:	07f00793          	li	a5,127
    80005a4c:	0cf48863          	beq	s1,a5,80005b1c <consoleintr+0x128>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005a50:	00020717          	auipc	a4,0x20
    80005a54:	6f070713          	addi	a4,a4,1776 # 80026140 <cons>
    80005a58:	0a072783          	lw	a5,160(a4)
    80005a5c:	09872703          	lw	a4,152(a4)
    80005a60:	9f99                	subw	a5,a5,a4
    80005a62:	07f00713          	li	a4,127
    80005a66:	fcf764e3          	bltu	a4,a5,80005a2e <consoleintr+0x3a>
      c = (c == '\r') ? '\n' : c;
    80005a6a:	47b5                	li	a5,13
    80005a6c:	0ef48163          	beq	s1,a5,80005b4e <consoleintr+0x15a>
      consputc(c);
    80005a70:	8526                	mv	a0,s1
    80005a72:	00000097          	auipc	ra,0x0
    80005a76:	f40080e7          	jalr	-192(ra) # 800059b2 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005a7a:	00020797          	auipc	a5,0x20
    80005a7e:	6c678793          	addi	a5,a5,1734 # 80026140 <cons>
    80005a82:	0a07a703          	lw	a4,160(a5)
    80005a86:	0017069b          	addiw	a3,a4,1
    80005a8a:	8636                	mv	a2,a3
    80005a8c:	0ad7a023          	sw	a3,160(a5)
    80005a90:	07f77713          	andi	a4,a4,127
    80005a94:	97ba                	add	a5,a5,a4
    80005a96:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005a9a:	47a9                	li	a5,10
    80005a9c:	0cf48f63          	beq	s1,a5,80005b7a <consoleintr+0x186>
    80005aa0:	4791                	li	a5,4
    80005aa2:	0cf48c63          	beq	s1,a5,80005b7a <consoleintr+0x186>
    80005aa6:	00020797          	auipc	a5,0x20
    80005aaa:	7327a783          	lw	a5,1842(a5) # 800261d8 <cons+0x98>
    80005aae:	0807879b          	addiw	a5,a5,128
    80005ab2:	f6f69ee3          	bne	a3,a5,80005a2e <consoleintr+0x3a>
    80005ab6:	863e                	mv	a2,a5
    80005ab8:	a0c9                	j	80005b7a <consoleintr+0x186>
    80005aba:	e84a                	sd	s2,16(sp)
    80005abc:	e44e                	sd	s3,8(sp)
    while(cons.e != cons.w &&
    80005abe:	00020717          	auipc	a4,0x20
    80005ac2:	68270713          	addi	a4,a4,1666 # 80026140 <cons>
    80005ac6:	0a072783          	lw	a5,160(a4)
    80005aca:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005ace:	00020497          	auipc	s1,0x20
    80005ad2:	67248493          	addi	s1,s1,1650 # 80026140 <cons>
    while(cons.e != cons.w &&
    80005ad6:	4929                	li	s2,10
      consputc(BACKSPACE);
    80005ad8:	10000993          	li	s3,256
    while(cons.e != cons.w &&
    80005adc:	02f70a63          	beq	a4,a5,80005b10 <consoleintr+0x11c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005ae0:	37fd                	addiw	a5,a5,-1
    80005ae2:	07f7f713          	andi	a4,a5,127
    80005ae6:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005ae8:	01874703          	lbu	a4,24(a4)
    80005aec:	03270563          	beq	a4,s2,80005b16 <consoleintr+0x122>
      cons.e--;
    80005af0:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005af4:	854e                	mv	a0,s3
    80005af6:	00000097          	auipc	ra,0x0
    80005afa:	ebc080e7          	jalr	-324(ra) # 800059b2 <consputc>
    while(cons.e != cons.w &&
    80005afe:	0a04a783          	lw	a5,160(s1)
    80005b02:	09c4a703          	lw	a4,156(s1)
    80005b06:	fcf71de3          	bne	a4,a5,80005ae0 <consoleintr+0xec>
    80005b0a:	6942                	ld	s2,16(sp)
    80005b0c:	69a2                	ld	s3,8(sp)
    80005b0e:	b705                	j	80005a2e <consoleintr+0x3a>
    80005b10:	6942                	ld	s2,16(sp)
    80005b12:	69a2                	ld	s3,8(sp)
    80005b14:	bf29                	j	80005a2e <consoleintr+0x3a>
    80005b16:	6942                	ld	s2,16(sp)
    80005b18:	69a2                	ld	s3,8(sp)
    80005b1a:	bf11                	j	80005a2e <consoleintr+0x3a>
    if(cons.e != cons.w){
    80005b1c:	00020717          	auipc	a4,0x20
    80005b20:	62470713          	addi	a4,a4,1572 # 80026140 <cons>
    80005b24:	0a072783          	lw	a5,160(a4)
    80005b28:	09c72703          	lw	a4,156(a4)
    80005b2c:	f0f701e3          	beq	a4,a5,80005a2e <consoleintr+0x3a>
      cons.e--;
    80005b30:	37fd                	addiw	a5,a5,-1
    80005b32:	00020717          	auipc	a4,0x20
    80005b36:	6af72723          	sw	a5,1710(a4) # 800261e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005b3a:	10000513          	li	a0,256
    80005b3e:	00000097          	auipc	ra,0x0
    80005b42:	e74080e7          	jalr	-396(ra) # 800059b2 <consputc>
    80005b46:	b5e5                	j	80005a2e <consoleintr+0x3a>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005b48:	ee0483e3          	beqz	s1,80005a2e <consoleintr+0x3a>
    80005b4c:	b711                	j	80005a50 <consoleintr+0x5c>
      consputc(c);
    80005b4e:	4529                	li	a0,10
    80005b50:	00000097          	auipc	ra,0x0
    80005b54:	e62080e7          	jalr	-414(ra) # 800059b2 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005b58:	00020797          	auipc	a5,0x20
    80005b5c:	5e878793          	addi	a5,a5,1512 # 80026140 <cons>
    80005b60:	0a07a703          	lw	a4,160(a5)
    80005b64:	0017069b          	addiw	a3,a4,1
    80005b68:	8636                	mv	a2,a3
    80005b6a:	0ad7a023          	sw	a3,160(a5)
    80005b6e:	07f77713          	andi	a4,a4,127
    80005b72:	97ba                	add	a5,a5,a4
    80005b74:	4729                	li	a4,10
    80005b76:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005b7a:	00020797          	auipc	a5,0x20
    80005b7e:	66c7a123          	sw	a2,1634(a5) # 800261dc <cons+0x9c>
        wakeup(&cons.r);
    80005b82:	00020517          	auipc	a0,0x20
    80005b86:	65650513          	addi	a0,a0,1622 # 800261d8 <cons+0x98>
    80005b8a:	ffffc097          	auipc	ra,0xffffc
    80005b8e:	b64080e7          	jalr	-1180(ra) # 800016ee <wakeup>
    80005b92:	bd71                	j	80005a2e <consoleintr+0x3a>

0000000080005b94 <consoleinit>:

void
consoleinit(void)
{
    80005b94:	1141                	addi	sp,sp,-16
    80005b96:	e406                	sd	ra,8(sp)
    80005b98:	e022                	sd	s0,0(sp)
    80005b9a:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005b9c:	00003597          	auipc	a1,0x3
    80005ba0:	afc58593          	addi	a1,a1,-1284 # 80008698 <etext+0x698>
    80005ba4:	00020517          	auipc	a0,0x20
    80005ba8:	59c50513          	addi	a0,a0,1436 # 80026140 <cons>
    80005bac:	00000097          	auipc	ra,0x0
    80005bb0:	5b2080e7          	jalr	1458(ra) # 8000615e <initlock>

  uartinit();
    80005bb4:	00000097          	auipc	ra,0x0
    80005bb8:	344080e7          	jalr	836(ra) # 80005ef8 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005bbc:	00013797          	auipc	a5,0x13
    80005bc0:	50c78793          	addi	a5,a5,1292 # 800190c8 <devsw>
    80005bc4:	00000717          	auipc	a4,0x0
    80005bc8:	cd470713          	addi	a4,a4,-812 # 80005898 <consoleread>
    80005bcc:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005bce:	00000717          	auipc	a4,0x0
    80005bd2:	c4c70713          	addi	a4,a4,-948 # 8000581a <consolewrite>
    80005bd6:	ef98                	sd	a4,24(a5)
}
    80005bd8:	60a2                	ld	ra,8(sp)
    80005bda:	6402                	ld	s0,0(sp)
    80005bdc:	0141                	addi	sp,sp,16
    80005bde:	8082                	ret

0000000080005be0 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005be0:	7179                	addi	sp,sp,-48
    80005be2:	f406                	sd	ra,40(sp)
    80005be4:	f022                	sd	s0,32(sp)
    80005be6:	ec26                	sd	s1,24(sp)
    80005be8:	e84a                	sd	s2,16(sp)
    80005bea:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005bec:	c219                	beqz	a2,80005bf2 <printint+0x12>
    80005bee:	06054e63          	bltz	a0,80005c6a <printint+0x8a>
    x = -xx;
  else
    x = xx;
    80005bf2:	4e01                	li	t3,0

  i = 0;
    80005bf4:	fd040313          	addi	t1,s0,-48
    x = xx;
    80005bf8:	869a                	mv	a3,t1
  i = 0;
    80005bfa:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    80005bfc:	00003817          	auipc	a6,0x3
    80005c00:	bfc80813          	addi	a6,a6,-1028 # 800087f8 <digits>
    80005c04:	88be                	mv	a7,a5
    80005c06:	0017861b          	addiw	a2,a5,1
    80005c0a:	87b2                	mv	a5,a2
    80005c0c:	02b5773b          	remuw	a4,a0,a1
    80005c10:	1702                	slli	a4,a4,0x20
    80005c12:	9301                	srli	a4,a4,0x20
    80005c14:	9742                	add	a4,a4,a6
    80005c16:	00074703          	lbu	a4,0(a4)
    80005c1a:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    80005c1e:	872a                	mv	a4,a0
    80005c20:	02b5553b          	divuw	a0,a0,a1
    80005c24:	0685                	addi	a3,a3,1
    80005c26:	fcb77fe3          	bgeu	a4,a1,80005c04 <printint+0x24>

  if(sign)
    80005c2a:	000e0c63          	beqz	t3,80005c42 <printint+0x62>
    buf[i++] = '-';
    80005c2e:	fe060793          	addi	a5,a2,-32
    80005c32:	00878633          	add	a2,a5,s0
    80005c36:	02d00793          	li	a5,45
    80005c3a:	fef60823          	sb	a5,-16(a2)
    80005c3e:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
    80005c42:	fff7891b          	addiw	s2,a5,-1
    80005c46:	006784b3          	add	s1,a5,t1
    consputc(buf[i]);
    80005c4a:	fff4c503          	lbu	a0,-1(s1)
    80005c4e:	00000097          	auipc	ra,0x0
    80005c52:	d64080e7          	jalr	-668(ra) # 800059b2 <consputc>
  while(--i >= 0)
    80005c56:	397d                	addiw	s2,s2,-1
    80005c58:	14fd                	addi	s1,s1,-1
    80005c5a:	fe0958e3          	bgez	s2,80005c4a <printint+0x6a>
}
    80005c5e:	70a2                	ld	ra,40(sp)
    80005c60:	7402                	ld	s0,32(sp)
    80005c62:	64e2                	ld	s1,24(sp)
    80005c64:	6942                	ld	s2,16(sp)
    80005c66:	6145                	addi	sp,sp,48
    80005c68:	8082                	ret
    x = -xx;
    80005c6a:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005c6e:	4e05                	li	t3,1
    x = -xx;
    80005c70:	b751                	j	80005bf4 <printint+0x14>

0000000080005c72 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005c72:	1101                	addi	sp,sp,-32
    80005c74:	ec06                	sd	ra,24(sp)
    80005c76:	e822                	sd	s0,16(sp)
    80005c78:	e426                	sd	s1,8(sp)
    80005c7a:	1000                	addi	s0,sp,32
    80005c7c:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005c7e:	00020797          	auipc	a5,0x20
    80005c82:	5807a123          	sw	zero,1410(a5) # 80026200 <pr+0x18>
  printf("panic: ");
    80005c86:	00003517          	auipc	a0,0x3
    80005c8a:	a1a50513          	addi	a0,a0,-1510 # 800086a0 <etext+0x6a0>
    80005c8e:	00000097          	auipc	ra,0x0
    80005c92:	02e080e7          	jalr	46(ra) # 80005cbc <printf>
  printf(s);
    80005c96:	8526                	mv	a0,s1
    80005c98:	00000097          	auipc	ra,0x0
    80005c9c:	024080e7          	jalr	36(ra) # 80005cbc <printf>
  printf("\n");
    80005ca0:	00002517          	auipc	a0,0x2
    80005ca4:	37850513          	addi	a0,a0,888 # 80008018 <etext+0x18>
    80005ca8:	00000097          	auipc	ra,0x0
    80005cac:	014080e7          	jalr	20(ra) # 80005cbc <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005cb0:	4785                	li	a5,1
    80005cb2:	00003717          	auipc	a4,0x3
    80005cb6:	36f72523          	sw	a5,874(a4) # 8000901c <panicked>
  for(;;)
    80005cba:	a001                	j	80005cba <panic+0x48>

0000000080005cbc <printf>:
{
    80005cbc:	7131                	addi	sp,sp,-192
    80005cbe:	fc86                	sd	ra,120(sp)
    80005cc0:	f8a2                	sd	s0,112(sp)
    80005cc2:	e8d2                	sd	s4,80(sp)
    80005cc4:	ec6e                	sd	s11,24(sp)
    80005cc6:	0100                	addi	s0,sp,128
    80005cc8:	8a2a                	mv	s4,a0
    80005cca:	e40c                	sd	a1,8(s0)
    80005ccc:	e810                	sd	a2,16(s0)
    80005cce:	ec14                	sd	a3,24(s0)
    80005cd0:	f018                	sd	a4,32(s0)
    80005cd2:	f41c                	sd	a5,40(s0)
    80005cd4:	03043823          	sd	a6,48(s0)
    80005cd8:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005cdc:	00020d97          	auipc	s11,0x20
    80005ce0:	524dad83          	lw	s11,1316(s11) # 80026200 <pr+0x18>
  if(locking)
    80005ce4:	040d9463          	bnez	s11,80005d2c <printf+0x70>
  if (fmt == 0)
    80005ce8:	040a0b63          	beqz	s4,80005d3e <printf+0x82>
  va_start(ap, fmt);
    80005cec:	00840793          	addi	a5,s0,8
    80005cf0:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005cf4:	000a4503          	lbu	a0,0(s4)
    80005cf8:	18050c63          	beqz	a0,80005e90 <printf+0x1d4>
    80005cfc:	f4a6                	sd	s1,104(sp)
    80005cfe:	f0ca                	sd	s2,96(sp)
    80005d00:	ecce                	sd	s3,88(sp)
    80005d02:	e4d6                	sd	s5,72(sp)
    80005d04:	e0da                	sd	s6,64(sp)
    80005d06:	fc5e                	sd	s7,56(sp)
    80005d08:	f862                	sd	s8,48(sp)
    80005d0a:	f466                	sd	s9,40(sp)
    80005d0c:	f06a                	sd	s10,32(sp)
    80005d0e:	4981                	li	s3,0
    if(c != '%'){
    80005d10:	02500b13          	li	s6,37
    switch(c){
    80005d14:	07000b93          	li	s7,112
  consputc('x');
    80005d18:	07800c93          	li	s9,120
    80005d1c:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005d1e:	00003a97          	auipc	s5,0x3
    80005d22:	adaa8a93          	addi	s5,s5,-1318 # 800087f8 <digits>
    switch(c){
    80005d26:	07300c13          	li	s8,115
    80005d2a:	a0b9                	j	80005d78 <printf+0xbc>
    acquire(&pr.lock);
    80005d2c:	00020517          	auipc	a0,0x20
    80005d30:	4bc50513          	addi	a0,a0,1212 # 800261e8 <pr>
    80005d34:	00000097          	auipc	ra,0x0
    80005d38:	4be080e7          	jalr	1214(ra) # 800061f2 <acquire>
    80005d3c:	b775                	j	80005ce8 <printf+0x2c>
    80005d3e:	f4a6                	sd	s1,104(sp)
    80005d40:	f0ca                	sd	s2,96(sp)
    80005d42:	ecce                	sd	s3,88(sp)
    80005d44:	e4d6                	sd	s5,72(sp)
    80005d46:	e0da                	sd	s6,64(sp)
    80005d48:	fc5e                	sd	s7,56(sp)
    80005d4a:	f862                	sd	s8,48(sp)
    80005d4c:	f466                	sd	s9,40(sp)
    80005d4e:	f06a                	sd	s10,32(sp)
    panic("null fmt");
    80005d50:	00003517          	auipc	a0,0x3
    80005d54:	96050513          	addi	a0,a0,-1696 # 800086b0 <etext+0x6b0>
    80005d58:	00000097          	auipc	ra,0x0
    80005d5c:	f1a080e7          	jalr	-230(ra) # 80005c72 <panic>
      consputc(c);
    80005d60:	00000097          	auipc	ra,0x0
    80005d64:	c52080e7          	jalr	-942(ra) # 800059b2 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005d68:	0019879b          	addiw	a5,s3,1
    80005d6c:	89be                	mv	s3,a5
    80005d6e:	97d2                	add	a5,a5,s4
    80005d70:	0007c503          	lbu	a0,0(a5)
    80005d74:	10050563          	beqz	a0,80005e7e <printf+0x1c2>
    if(c != '%'){
    80005d78:	ff6514e3          	bne	a0,s6,80005d60 <printf+0xa4>
    c = fmt[++i] & 0xff;
    80005d7c:	0019879b          	addiw	a5,s3,1
    80005d80:	89be                	mv	s3,a5
    80005d82:	97d2                	add	a5,a5,s4
    80005d84:	0007c783          	lbu	a5,0(a5)
    80005d88:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005d8c:	10078a63          	beqz	a5,80005ea0 <printf+0x1e4>
    switch(c){
    80005d90:	05778a63          	beq	a5,s7,80005de4 <printf+0x128>
    80005d94:	02fbf463          	bgeu	s7,a5,80005dbc <printf+0x100>
    80005d98:	09878763          	beq	a5,s8,80005e26 <printf+0x16a>
    80005d9c:	0d979663          	bne	a5,s9,80005e68 <printf+0x1ac>
      printint(va_arg(ap, int), 16, 1);
    80005da0:	f8843783          	ld	a5,-120(s0)
    80005da4:	00878713          	addi	a4,a5,8
    80005da8:	f8e43423          	sd	a4,-120(s0)
    80005dac:	4605                	li	a2,1
    80005dae:	85ea                	mv	a1,s10
    80005db0:	4388                	lw	a0,0(a5)
    80005db2:	00000097          	auipc	ra,0x0
    80005db6:	e2e080e7          	jalr	-466(ra) # 80005be0 <printint>
      break;
    80005dba:	b77d                	j	80005d68 <printf+0xac>
    switch(c){
    80005dbc:	0b678063          	beq	a5,s6,80005e5c <printf+0x1a0>
    80005dc0:	06400713          	li	a4,100
    80005dc4:	0ae79263          	bne	a5,a4,80005e68 <printf+0x1ac>
      printint(va_arg(ap, int), 10, 1);
    80005dc8:	f8843783          	ld	a5,-120(s0)
    80005dcc:	00878713          	addi	a4,a5,8
    80005dd0:	f8e43423          	sd	a4,-120(s0)
    80005dd4:	4605                	li	a2,1
    80005dd6:	45a9                	li	a1,10
    80005dd8:	4388                	lw	a0,0(a5)
    80005dda:	00000097          	auipc	ra,0x0
    80005dde:	e06080e7          	jalr	-506(ra) # 80005be0 <printint>
      break;
    80005de2:	b759                	j	80005d68 <printf+0xac>
      printptr(va_arg(ap, uint64));
    80005de4:	f8843783          	ld	a5,-120(s0)
    80005de8:	00878713          	addi	a4,a5,8
    80005dec:	f8e43423          	sd	a4,-120(s0)
    80005df0:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005df4:	03000513          	li	a0,48
    80005df8:	00000097          	auipc	ra,0x0
    80005dfc:	bba080e7          	jalr	-1094(ra) # 800059b2 <consputc>
  consputc('x');
    80005e00:	8566                	mv	a0,s9
    80005e02:	00000097          	auipc	ra,0x0
    80005e06:	bb0080e7          	jalr	-1104(ra) # 800059b2 <consputc>
    80005e0a:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005e0c:	03c95793          	srli	a5,s2,0x3c
    80005e10:	97d6                	add	a5,a5,s5
    80005e12:	0007c503          	lbu	a0,0(a5)
    80005e16:	00000097          	auipc	ra,0x0
    80005e1a:	b9c080e7          	jalr	-1124(ra) # 800059b2 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005e1e:	0912                	slli	s2,s2,0x4
    80005e20:	34fd                	addiw	s1,s1,-1
    80005e22:	f4ed                	bnez	s1,80005e0c <printf+0x150>
    80005e24:	b791                	j	80005d68 <printf+0xac>
      if((s = va_arg(ap, char*)) == 0)
    80005e26:	f8843783          	ld	a5,-120(s0)
    80005e2a:	00878713          	addi	a4,a5,8
    80005e2e:	f8e43423          	sd	a4,-120(s0)
    80005e32:	6384                	ld	s1,0(a5)
    80005e34:	cc89                	beqz	s1,80005e4e <printf+0x192>
      for(; *s; s++)
    80005e36:	0004c503          	lbu	a0,0(s1)
    80005e3a:	d51d                	beqz	a0,80005d68 <printf+0xac>
        consputc(*s);
    80005e3c:	00000097          	auipc	ra,0x0
    80005e40:	b76080e7          	jalr	-1162(ra) # 800059b2 <consputc>
      for(; *s; s++)
    80005e44:	0485                	addi	s1,s1,1
    80005e46:	0004c503          	lbu	a0,0(s1)
    80005e4a:	f96d                	bnez	a0,80005e3c <printf+0x180>
    80005e4c:	bf31                	j	80005d68 <printf+0xac>
        s = "(null)";
    80005e4e:	00003497          	auipc	s1,0x3
    80005e52:	85a48493          	addi	s1,s1,-1958 # 800086a8 <etext+0x6a8>
      for(; *s; s++)
    80005e56:	02800513          	li	a0,40
    80005e5a:	b7cd                	j	80005e3c <printf+0x180>
      consputc('%');
    80005e5c:	855a                	mv	a0,s6
    80005e5e:	00000097          	auipc	ra,0x0
    80005e62:	b54080e7          	jalr	-1196(ra) # 800059b2 <consputc>
      break;
    80005e66:	b709                	j	80005d68 <printf+0xac>
      consputc('%');
    80005e68:	855a                	mv	a0,s6
    80005e6a:	00000097          	auipc	ra,0x0
    80005e6e:	b48080e7          	jalr	-1208(ra) # 800059b2 <consputc>
      consputc(c);
    80005e72:	8526                	mv	a0,s1
    80005e74:	00000097          	auipc	ra,0x0
    80005e78:	b3e080e7          	jalr	-1218(ra) # 800059b2 <consputc>
      break;
    80005e7c:	b5f5                	j	80005d68 <printf+0xac>
    80005e7e:	74a6                	ld	s1,104(sp)
    80005e80:	7906                	ld	s2,96(sp)
    80005e82:	69e6                	ld	s3,88(sp)
    80005e84:	6aa6                	ld	s5,72(sp)
    80005e86:	6b06                	ld	s6,64(sp)
    80005e88:	7be2                	ld	s7,56(sp)
    80005e8a:	7c42                	ld	s8,48(sp)
    80005e8c:	7ca2                	ld	s9,40(sp)
    80005e8e:	7d02                	ld	s10,32(sp)
  if(locking)
    80005e90:	020d9263          	bnez	s11,80005eb4 <printf+0x1f8>
}
    80005e94:	70e6                	ld	ra,120(sp)
    80005e96:	7446                	ld	s0,112(sp)
    80005e98:	6a46                	ld	s4,80(sp)
    80005e9a:	6de2                	ld	s11,24(sp)
    80005e9c:	6129                	addi	sp,sp,192
    80005e9e:	8082                	ret
    80005ea0:	74a6                	ld	s1,104(sp)
    80005ea2:	7906                	ld	s2,96(sp)
    80005ea4:	69e6                	ld	s3,88(sp)
    80005ea6:	6aa6                	ld	s5,72(sp)
    80005ea8:	6b06                	ld	s6,64(sp)
    80005eaa:	7be2                	ld	s7,56(sp)
    80005eac:	7c42                	ld	s8,48(sp)
    80005eae:	7ca2                	ld	s9,40(sp)
    80005eb0:	7d02                	ld	s10,32(sp)
    80005eb2:	bff9                	j	80005e90 <printf+0x1d4>
    release(&pr.lock);
    80005eb4:	00020517          	auipc	a0,0x20
    80005eb8:	33450513          	addi	a0,a0,820 # 800261e8 <pr>
    80005ebc:	00000097          	auipc	ra,0x0
    80005ec0:	3e6080e7          	jalr	998(ra) # 800062a2 <release>
}
    80005ec4:	bfc1                	j	80005e94 <printf+0x1d8>

0000000080005ec6 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005ec6:	1101                	addi	sp,sp,-32
    80005ec8:	ec06                	sd	ra,24(sp)
    80005eca:	e822                	sd	s0,16(sp)
    80005ecc:	e426                	sd	s1,8(sp)
    80005ece:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005ed0:	00020497          	auipc	s1,0x20
    80005ed4:	31848493          	addi	s1,s1,792 # 800261e8 <pr>
    80005ed8:	00002597          	auipc	a1,0x2
    80005edc:	7e858593          	addi	a1,a1,2024 # 800086c0 <etext+0x6c0>
    80005ee0:	8526                	mv	a0,s1
    80005ee2:	00000097          	auipc	ra,0x0
    80005ee6:	27c080e7          	jalr	636(ra) # 8000615e <initlock>
  pr.locking = 1;
    80005eea:	4785                	li	a5,1
    80005eec:	cc9c                	sw	a5,24(s1)
}
    80005eee:	60e2                	ld	ra,24(sp)
    80005ef0:	6442                	ld	s0,16(sp)
    80005ef2:	64a2                	ld	s1,8(sp)
    80005ef4:	6105                	addi	sp,sp,32
    80005ef6:	8082                	ret

0000000080005ef8 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005ef8:	1141                	addi	sp,sp,-16
    80005efa:	e406                	sd	ra,8(sp)
    80005efc:	e022                	sd	s0,0(sp)
    80005efe:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005f00:	100007b7          	lui	a5,0x10000
    80005f04:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005f08:	10000737          	lui	a4,0x10000
    80005f0c:	f8000693          	li	a3,-128
    80005f10:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005f14:	468d                	li	a3,3
    80005f16:	10000637          	lui	a2,0x10000
    80005f1a:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005f1e:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005f22:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005f26:	8732                	mv	a4,a2
    80005f28:	461d                	li	a2,7
    80005f2a:	00c70123          	sb	a2,2(a4)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005f2e:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005f32:	00002597          	auipc	a1,0x2
    80005f36:	79658593          	addi	a1,a1,1942 # 800086c8 <etext+0x6c8>
    80005f3a:	00020517          	auipc	a0,0x20
    80005f3e:	2ce50513          	addi	a0,a0,718 # 80026208 <uart_tx_lock>
    80005f42:	00000097          	auipc	ra,0x0
    80005f46:	21c080e7          	jalr	540(ra) # 8000615e <initlock>
}
    80005f4a:	60a2                	ld	ra,8(sp)
    80005f4c:	6402                	ld	s0,0(sp)
    80005f4e:	0141                	addi	sp,sp,16
    80005f50:	8082                	ret

0000000080005f52 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005f52:	1101                	addi	sp,sp,-32
    80005f54:	ec06                	sd	ra,24(sp)
    80005f56:	e822                	sd	s0,16(sp)
    80005f58:	e426                	sd	s1,8(sp)
    80005f5a:	1000                	addi	s0,sp,32
    80005f5c:	84aa                	mv	s1,a0
  push_off();
    80005f5e:	00000097          	auipc	ra,0x0
    80005f62:	248080e7          	jalr	584(ra) # 800061a6 <push_off>

  if(panicked){
    80005f66:	00003797          	auipc	a5,0x3
    80005f6a:	0b67a783          	lw	a5,182(a5) # 8000901c <panicked>
    80005f6e:	eb85                	bnez	a5,80005f9e <uartputc_sync+0x4c>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005f70:	10000737          	lui	a4,0x10000
    80005f74:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80005f76:	00074783          	lbu	a5,0(a4)
    80005f7a:	0207f793          	andi	a5,a5,32
    80005f7e:	dfe5                	beqz	a5,80005f76 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80005f80:	0ff4f513          	zext.b	a0,s1
    80005f84:	100007b7          	lui	a5,0x10000
    80005f88:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80005f8c:	00000097          	auipc	ra,0x0
    80005f90:	2ba080e7          	jalr	698(ra) # 80006246 <pop_off>
}
    80005f94:	60e2                	ld	ra,24(sp)
    80005f96:	6442                	ld	s0,16(sp)
    80005f98:	64a2                	ld	s1,8(sp)
    80005f9a:	6105                	addi	sp,sp,32
    80005f9c:	8082                	ret
    for(;;)
    80005f9e:	a001                	j	80005f9e <uartputc_sync+0x4c>

0000000080005fa0 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005fa0:	00003797          	auipc	a5,0x3
    80005fa4:	0807b783          	ld	a5,128(a5) # 80009020 <uart_tx_r>
    80005fa8:	00003717          	auipc	a4,0x3
    80005fac:	08073703          	ld	a4,128(a4) # 80009028 <uart_tx_w>
    80005fb0:	06f70f63          	beq	a4,a5,8000602e <uartstart+0x8e>
{
    80005fb4:	7139                	addi	sp,sp,-64
    80005fb6:	fc06                	sd	ra,56(sp)
    80005fb8:	f822                	sd	s0,48(sp)
    80005fba:	f426                	sd	s1,40(sp)
    80005fbc:	f04a                	sd	s2,32(sp)
    80005fbe:	ec4e                	sd	s3,24(sp)
    80005fc0:	e852                	sd	s4,16(sp)
    80005fc2:	e456                	sd	s5,8(sp)
    80005fc4:	e05a                	sd	s6,0(sp)
    80005fc6:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005fc8:	10000937          	lui	s2,0x10000
    80005fcc:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005fce:	00020a97          	auipc	s5,0x20
    80005fd2:	23aa8a93          	addi	s5,s5,570 # 80026208 <uart_tx_lock>
    uart_tx_r += 1;
    80005fd6:	00003497          	auipc	s1,0x3
    80005fda:	04a48493          	addi	s1,s1,74 # 80009020 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    80005fde:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    80005fe2:	00003997          	auipc	s3,0x3
    80005fe6:	04698993          	addi	s3,s3,70 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005fea:	00094703          	lbu	a4,0(s2)
    80005fee:	02077713          	andi	a4,a4,32
    80005ff2:	c705                	beqz	a4,8000601a <uartstart+0x7a>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005ff4:	01f7f713          	andi	a4,a5,31
    80005ff8:	9756                	add	a4,a4,s5
    80005ffa:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    80005ffe:	0785                	addi	a5,a5,1
    80006000:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    80006002:	8526                	mv	a0,s1
    80006004:	ffffb097          	auipc	ra,0xffffb
    80006008:	6ea080e7          	jalr	1770(ra) # 800016ee <wakeup>
    WriteReg(THR, c);
    8000600c:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    80006010:	609c                	ld	a5,0(s1)
    80006012:	0009b703          	ld	a4,0(s3)
    80006016:	fcf71ae3          	bne	a4,a5,80005fea <uartstart+0x4a>
  }
}
    8000601a:	70e2                	ld	ra,56(sp)
    8000601c:	7442                	ld	s0,48(sp)
    8000601e:	74a2                	ld	s1,40(sp)
    80006020:	7902                	ld	s2,32(sp)
    80006022:	69e2                	ld	s3,24(sp)
    80006024:	6a42                	ld	s4,16(sp)
    80006026:	6aa2                	ld	s5,8(sp)
    80006028:	6b02                	ld	s6,0(sp)
    8000602a:	6121                	addi	sp,sp,64
    8000602c:	8082                	ret
    8000602e:	8082                	ret

0000000080006030 <uartputc>:
{
    80006030:	7179                	addi	sp,sp,-48
    80006032:	f406                	sd	ra,40(sp)
    80006034:	f022                	sd	s0,32(sp)
    80006036:	e052                	sd	s4,0(sp)
    80006038:	1800                	addi	s0,sp,48
    8000603a:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    8000603c:	00020517          	auipc	a0,0x20
    80006040:	1cc50513          	addi	a0,a0,460 # 80026208 <uart_tx_lock>
    80006044:	00000097          	auipc	ra,0x0
    80006048:	1ae080e7          	jalr	430(ra) # 800061f2 <acquire>
  if(panicked){
    8000604c:	00003797          	auipc	a5,0x3
    80006050:	fd07a783          	lw	a5,-48(a5) # 8000901c <panicked>
    80006054:	c391                	beqz	a5,80006058 <uartputc+0x28>
    for(;;)
    80006056:	a001                	j	80006056 <uartputc+0x26>
    80006058:	ec26                	sd	s1,24(sp)
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000605a:	00003717          	auipc	a4,0x3
    8000605e:	fce73703          	ld	a4,-50(a4) # 80009028 <uart_tx_w>
    80006062:	00003797          	auipc	a5,0x3
    80006066:	fbe7b783          	ld	a5,-66(a5) # 80009020 <uart_tx_r>
    8000606a:	02078793          	addi	a5,a5,32
    8000606e:	02e79f63          	bne	a5,a4,800060ac <uartputc+0x7c>
    80006072:	e84a                	sd	s2,16(sp)
    80006074:	e44e                	sd	s3,8(sp)
      sleep(&uart_tx_r, &uart_tx_lock);
    80006076:	00020997          	auipc	s3,0x20
    8000607a:	19298993          	addi	s3,s3,402 # 80026208 <uart_tx_lock>
    8000607e:	00003497          	auipc	s1,0x3
    80006082:	fa248493          	addi	s1,s1,-94 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006086:	00003917          	auipc	s2,0x3
    8000608a:	fa290913          	addi	s2,s2,-94 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    8000608e:	85ce                	mv	a1,s3
    80006090:	8526                	mv	a0,s1
    80006092:	ffffb097          	auipc	ra,0xffffb
    80006096:	4d6080e7          	jalr	1238(ra) # 80001568 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000609a:	00093703          	ld	a4,0(s2)
    8000609e:	609c                	ld	a5,0(s1)
    800060a0:	02078793          	addi	a5,a5,32
    800060a4:	fee785e3          	beq	a5,a4,8000608e <uartputc+0x5e>
    800060a8:	6942                	ld	s2,16(sp)
    800060aa:	69a2                	ld	s3,8(sp)
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800060ac:	00020497          	auipc	s1,0x20
    800060b0:	15c48493          	addi	s1,s1,348 # 80026208 <uart_tx_lock>
    800060b4:	01f77793          	andi	a5,a4,31
    800060b8:	97a6                	add	a5,a5,s1
    800060ba:	01478c23          	sb	s4,24(a5)
      uart_tx_w += 1;
    800060be:	0705                	addi	a4,a4,1
    800060c0:	00003797          	auipc	a5,0x3
    800060c4:	f6e7b423          	sd	a4,-152(a5) # 80009028 <uart_tx_w>
      uartstart();
    800060c8:	00000097          	auipc	ra,0x0
    800060cc:	ed8080e7          	jalr	-296(ra) # 80005fa0 <uartstart>
      release(&uart_tx_lock);
    800060d0:	8526                	mv	a0,s1
    800060d2:	00000097          	auipc	ra,0x0
    800060d6:	1d0080e7          	jalr	464(ra) # 800062a2 <release>
    800060da:	64e2                	ld	s1,24(sp)
}
    800060dc:	70a2                	ld	ra,40(sp)
    800060de:	7402                	ld	s0,32(sp)
    800060e0:	6a02                	ld	s4,0(sp)
    800060e2:	6145                	addi	sp,sp,48
    800060e4:	8082                	ret

00000000800060e6 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800060e6:	1141                	addi	sp,sp,-16
    800060e8:	e406                	sd	ra,8(sp)
    800060ea:	e022                	sd	s0,0(sp)
    800060ec:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800060ee:	100007b7          	lui	a5,0x10000
    800060f2:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800060f6:	8b85                	andi	a5,a5,1
    800060f8:	cb89                	beqz	a5,8000610a <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    800060fa:	100007b7          	lui	a5,0x10000
    800060fe:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80006102:	60a2                	ld	ra,8(sp)
    80006104:	6402                	ld	s0,0(sp)
    80006106:	0141                	addi	sp,sp,16
    80006108:	8082                	ret
    return -1;
    8000610a:	557d                	li	a0,-1
    8000610c:	bfdd                	j	80006102 <uartgetc+0x1c>

000000008000610e <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    8000610e:	1101                	addi	sp,sp,-32
    80006110:	ec06                	sd	ra,24(sp)
    80006112:	e822                	sd	s0,16(sp)
    80006114:	e426                	sd	s1,8(sp)
    80006116:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80006118:	54fd                	li	s1,-1
    int c = uartgetc();
    8000611a:	00000097          	auipc	ra,0x0
    8000611e:	fcc080e7          	jalr	-52(ra) # 800060e6 <uartgetc>
    if(c == -1)
    80006122:	00950763          	beq	a0,s1,80006130 <uartintr+0x22>
      break;
    consoleintr(c);
    80006126:	00000097          	auipc	ra,0x0
    8000612a:	8ce080e7          	jalr	-1842(ra) # 800059f4 <consoleintr>
  while(1){
    8000612e:	b7f5                	j	8000611a <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006130:	00020497          	auipc	s1,0x20
    80006134:	0d848493          	addi	s1,s1,216 # 80026208 <uart_tx_lock>
    80006138:	8526                	mv	a0,s1
    8000613a:	00000097          	auipc	ra,0x0
    8000613e:	0b8080e7          	jalr	184(ra) # 800061f2 <acquire>
  uartstart();
    80006142:	00000097          	auipc	ra,0x0
    80006146:	e5e080e7          	jalr	-418(ra) # 80005fa0 <uartstart>
  release(&uart_tx_lock);
    8000614a:	8526                	mv	a0,s1
    8000614c:	00000097          	auipc	ra,0x0
    80006150:	156080e7          	jalr	342(ra) # 800062a2 <release>
}
    80006154:	60e2                	ld	ra,24(sp)
    80006156:	6442                	ld	s0,16(sp)
    80006158:	64a2                	ld	s1,8(sp)
    8000615a:	6105                	addi	sp,sp,32
    8000615c:	8082                	ret

000000008000615e <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    8000615e:	1141                	addi	sp,sp,-16
    80006160:	e406                	sd	ra,8(sp)
    80006162:	e022                	sd	s0,0(sp)
    80006164:	0800                	addi	s0,sp,16
  lk->name = name;
    80006166:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80006168:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    8000616c:	00053823          	sd	zero,16(a0)
}
    80006170:	60a2                	ld	ra,8(sp)
    80006172:	6402                	ld	s0,0(sp)
    80006174:	0141                	addi	sp,sp,16
    80006176:	8082                	ret

0000000080006178 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006178:	411c                	lw	a5,0(a0)
    8000617a:	e399                	bnez	a5,80006180 <holding+0x8>
    8000617c:	4501                	li	a0,0
  return r;
}
    8000617e:	8082                	ret
{
    80006180:	1101                	addi	sp,sp,-32
    80006182:	ec06                	sd	ra,24(sp)
    80006184:	e822                	sd	s0,16(sp)
    80006186:	e426                	sd	s1,8(sp)
    80006188:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    8000618a:	6904                	ld	s1,16(a0)
    8000618c:	ffffb097          	auipc	ra,0xffffb
    80006190:	cf6080e7          	jalr	-778(ra) # 80000e82 <mycpu>
    80006194:	40a48533          	sub	a0,s1,a0
    80006198:	00153513          	seqz	a0,a0
}
    8000619c:	60e2                	ld	ra,24(sp)
    8000619e:	6442                	ld	s0,16(sp)
    800061a0:	64a2                	ld	s1,8(sp)
    800061a2:	6105                	addi	sp,sp,32
    800061a4:	8082                	ret

00000000800061a6 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800061a6:	1101                	addi	sp,sp,-32
    800061a8:	ec06                	sd	ra,24(sp)
    800061aa:	e822                	sd	s0,16(sp)
    800061ac:	e426                	sd	s1,8(sp)
    800061ae:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800061b0:	100024f3          	csrr	s1,sstatus
    800061b4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800061b8:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800061ba:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800061be:	ffffb097          	auipc	ra,0xffffb
    800061c2:	cc4080e7          	jalr	-828(ra) # 80000e82 <mycpu>
    800061c6:	5d3c                	lw	a5,120(a0)
    800061c8:	cf89                	beqz	a5,800061e2 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800061ca:	ffffb097          	auipc	ra,0xffffb
    800061ce:	cb8080e7          	jalr	-840(ra) # 80000e82 <mycpu>
    800061d2:	5d3c                	lw	a5,120(a0)
    800061d4:	2785                	addiw	a5,a5,1
    800061d6:	dd3c                	sw	a5,120(a0)
}
    800061d8:	60e2                	ld	ra,24(sp)
    800061da:	6442                	ld	s0,16(sp)
    800061dc:	64a2                	ld	s1,8(sp)
    800061de:	6105                	addi	sp,sp,32
    800061e0:	8082                	ret
    mycpu()->intena = old;
    800061e2:	ffffb097          	auipc	ra,0xffffb
    800061e6:	ca0080e7          	jalr	-864(ra) # 80000e82 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800061ea:	8085                	srli	s1,s1,0x1
    800061ec:	8885                	andi	s1,s1,1
    800061ee:	dd64                	sw	s1,124(a0)
    800061f0:	bfe9                	j	800061ca <push_off+0x24>

00000000800061f2 <acquire>:
{
    800061f2:	1101                	addi	sp,sp,-32
    800061f4:	ec06                	sd	ra,24(sp)
    800061f6:	e822                	sd	s0,16(sp)
    800061f8:	e426                	sd	s1,8(sp)
    800061fa:	1000                	addi	s0,sp,32
    800061fc:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800061fe:	00000097          	auipc	ra,0x0
    80006202:	fa8080e7          	jalr	-88(ra) # 800061a6 <push_off>
  if(holding(lk))
    80006206:	8526                	mv	a0,s1
    80006208:	00000097          	auipc	ra,0x0
    8000620c:	f70080e7          	jalr	-144(ra) # 80006178 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006210:	4705                	li	a4,1
  if(holding(lk))
    80006212:	e115                	bnez	a0,80006236 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006214:	87ba                	mv	a5,a4
    80006216:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    8000621a:	2781                	sext.w	a5,a5
    8000621c:	ffe5                	bnez	a5,80006214 <acquire+0x22>
  __sync_synchronize();
    8000621e:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80006222:	ffffb097          	auipc	ra,0xffffb
    80006226:	c60080e7          	jalr	-928(ra) # 80000e82 <mycpu>
    8000622a:	e888                	sd	a0,16(s1)
}
    8000622c:	60e2                	ld	ra,24(sp)
    8000622e:	6442                	ld	s0,16(sp)
    80006230:	64a2                	ld	s1,8(sp)
    80006232:	6105                	addi	sp,sp,32
    80006234:	8082                	ret
    panic("acquire");
    80006236:	00002517          	auipc	a0,0x2
    8000623a:	49a50513          	addi	a0,a0,1178 # 800086d0 <etext+0x6d0>
    8000623e:	00000097          	auipc	ra,0x0
    80006242:	a34080e7          	jalr	-1484(ra) # 80005c72 <panic>

0000000080006246 <pop_off>:

void
pop_off(void)
{
    80006246:	1141                	addi	sp,sp,-16
    80006248:	e406                	sd	ra,8(sp)
    8000624a:	e022                	sd	s0,0(sp)
    8000624c:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    8000624e:	ffffb097          	auipc	ra,0xffffb
    80006252:	c34080e7          	jalr	-972(ra) # 80000e82 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006256:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000625a:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000625c:	e39d                	bnez	a5,80006282 <pop_off+0x3c>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    8000625e:	5d3c                	lw	a5,120(a0)
    80006260:	02f05963          	blez	a5,80006292 <pop_off+0x4c>
    panic("pop_off");
  c->noff -= 1;
    80006264:	37fd                	addiw	a5,a5,-1
    80006266:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006268:	eb89                	bnez	a5,8000627a <pop_off+0x34>
    8000626a:	5d7c                	lw	a5,124(a0)
    8000626c:	c799                	beqz	a5,8000627a <pop_off+0x34>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000626e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006272:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006276:	10079073          	csrw	sstatus,a5
    intr_on();
}
    8000627a:	60a2                	ld	ra,8(sp)
    8000627c:	6402                	ld	s0,0(sp)
    8000627e:	0141                	addi	sp,sp,16
    80006280:	8082                	ret
    panic("pop_off - interruptible");
    80006282:	00002517          	auipc	a0,0x2
    80006286:	45650513          	addi	a0,a0,1110 # 800086d8 <etext+0x6d8>
    8000628a:	00000097          	auipc	ra,0x0
    8000628e:	9e8080e7          	jalr	-1560(ra) # 80005c72 <panic>
    panic("pop_off");
    80006292:	00002517          	auipc	a0,0x2
    80006296:	45e50513          	addi	a0,a0,1118 # 800086f0 <etext+0x6f0>
    8000629a:	00000097          	auipc	ra,0x0
    8000629e:	9d8080e7          	jalr	-1576(ra) # 80005c72 <panic>

00000000800062a2 <release>:
{
    800062a2:	1101                	addi	sp,sp,-32
    800062a4:	ec06                	sd	ra,24(sp)
    800062a6:	e822                	sd	s0,16(sp)
    800062a8:	e426                	sd	s1,8(sp)
    800062aa:	1000                	addi	s0,sp,32
    800062ac:	84aa                	mv	s1,a0
  if(!holding(lk))
    800062ae:	00000097          	auipc	ra,0x0
    800062b2:	eca080e7          	jalr	-310(ra) # 80006178 <holding>
    800062b6:	c115                	beqz	a0,800062da <release+0x38>
  lk->cpu = 0;
    800062b8:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800062bc:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    800062c0:	0310000f          	fence	rw,w
    800062c4:	0004a023          	sw	zero,0(s1)
  pop_off();
    800062c8:	00000097          	auipc	ra,0x0
    800062cc:	f7e080e7          	jalr	-130(ra) # 80006246 <pop_off>
}
    800062d0:	60e2                	ld	ra,24(sp)
    800062d2:	6442                	ld	s0,16(sp)
    800062d4:	64a2                	ld	s1,8(sp)
    800062d6:	6105                	addi	sp,sp,32
    800062d8:	8082                	ret
    panic("release");
    800062da:	00002517          	auipc	a0,0x2
    800062de:	41e50513          	addi	a0,a0,1054 # 800086f8 <etext+0x6f8>
    800062e2:	00000097          	auipc	ra,0x0
    800062e6:	990080e7          	jalr	-1648(ra) # 80005c72 <panic>
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
