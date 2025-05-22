
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
    80000016:	738050ef          	jal	8000574e <start>

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
    8000005e:	1a4080e7          	jalr	420(ra) # 800061fe <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	244080e7          	jalr	580(ra) # 800062b2 <release>
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
    8000008e:	c24080e7          	jalr	-988(ra) # 80005cae <panic>

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
    800000fa:	078080e7          	jalr	120(ra) # 8000616e <initlock>
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
    80000132:	0d0080e7          	jalr	208(ra) # 800061fe <acquire>
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
    8000014a:	16c080e7          	jalr	364(ra) # 800062b2 <release>

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
    80000174:	142080e7          	jalr	322(ra) # 800062b2 <release>
  if(r)
    80000178:	b7d5                	j	8000015c <kalloc+0x42>

000000008000017a <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    8000017a:	1141                	addi	sp,sp,-16
    8000017c:	e422                	sd	s0,8(sp)
    8000017e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000180:	ca19                	beqz	a2,80000196 <memset+0x1c>
    80000182:	87aa                	mv	a5,a0
    80000184:	1602                	slli	a2,a2,0x20
    80000186:	9201                	srli	a2,a2,0x20
    80000188:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    8000018c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000190:	0785                	addi	a5,a5,1
    80000192:	fee79de3          	bne	a5,a4,8000018c <memset+0x12>
  }
  return dst;
}
    80000196:	6422                	ld	s0,8(sp)
    80000198:	0141                	addi	sp,sp,16
    8000019a:	8082                	ret

000000008000019c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    8000019c:	1141                	addi	sp,sp,-16
    8000019e:	e422                	sd	s0,8(sp)
    800001a0:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001a2:	ca05                	beqz	a2,800001d2 <memcmp+0x36>
    800001a4:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    800001a8:	1682                	slli	a3,a3,0x20
    800001aa:	9281                	srli	a3,a3,0x20
    800001ac:	0685                	addi	a3,a3,1
    800001ae:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001b0:	00054783          	lbu	a5,0(a0)
    800001b4:	0005c703          	lbu	a4,0(a1)
    800001b8:	00e79863          	bne	a5,a4,800001c8 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001bc:	0505                	addi	a0,a0,1
    800001be:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001c0:	fed518e3          	bne	a0,a3,800001b0 <memcmp+0x14>
  }

  return 0;
    800001c4:	4501                	li	a0,0
    800001c6:	a019                	j	800001cc <memcmp+0x30>
      return *s1 - *s2;
    800001c8:	40e7853b          	subw	a0,a5,a4
}
    800001cc:	6422                	ld	s0,8(sp)
    800001ce:	0141                	addi	sp,sp,16
    800001d0:	8082                	ret
  return 0;
    800001d2:	4501                	li	a0,0
    800001d4:	bfe5                	j	800001cc <memcmp+0x30>

00000000800001d6 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001d6:	1141                	addi	sp,sp,-16
    800001d8:	e422                	sd	s0,8(sp)
    800001da:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001dc:	c205                	beqz	a2,800001fc <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001de:	02a5e263          	bltu	a1,a0,80000202 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001e2:	1602                	slli	a2,a2,0x20
    800001e4:	9201                	srli	a2,a2,0x20
    800001e6:	00c587b3          	add	a5,a1,a2
{
    800001ea:	872a                	mv	a4,a0
      *d++ = *s++;
    800001ec:	0585                	addi	a1,a1,1
    800001ee:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffd8dc1>
    800001f0:	fff5c683          	lbu	a3,-1(a1)
    800001f4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800001f8:	feb79ae3          	bne	a5,a1,800001ec <memmove+0x16>

  return dst;
}
    800001fc:	6422                	ld	s0,8(sp)
    800001fe:	0141                	addi	sp,sp,16
    80000200:	8082                	ret
  if(s < d && s + n > d){
    80000202:	02061693          	slli	a3,a2,0x20
    80000206:	9281                	srli	a3,a3,0x20
    80000208:	00d58733          	add	a4,a1,a3
    8000020c:	fce57be3          	bgeu	a0,a4,800001e2 <memmove+0xc>
    d += n;
    80000210:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000212:	fff6079b          	addiw	a5,a2,-1
    80000216:	1782                	slli	a5,a5,0x20
    80000218:	9381                	srli	a5,a5,0x20
    8000021a:	fff7c793          	not	a5,a5
    8000021e:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000220:	177d                	addi	a4,a4,-1
    80000222:	16fd                	addi	a3,a3,-1
    80000224:	00074603          	lbu	a2,0(a4)
    80000228:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    8000022c:	fef71ae3          	bne	a4,a5,80000220 <memmove+0x4a>
    80000230:	b7f1                	j	800001fc <memmove+0x26>

0000000080000232 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000232:	1141                	addi	sp,sp,-16
    80000234:	e406                	sd	ra,8(sp)
    80000236:	e022                	sd	s0,0(sp)
    80000238:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    8000023a:	00000097          	auipc	ra,0x0
    8000023e:	f9c080e7          	jalr	-100(ra) # 800001d6 <memmove>
}
    80000242:	60a2                	ld	ra,8(sp)
    80000244:	6402                	ld	s0,0(sp)
    80000246:	0141                	addi	sp,sp,16
    80000248:	8082                	ret

000000008000024a <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    8000024a:	1141                	addi	sp,sp,-16
    8000024c:	e422                	sd	s0,8(sp)
    8000024e:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000250:	ce11                	beqz	a2,8000026c <strncmp+0x22>
    80000252:	00054783          	lbu	a5,0(a0)
    80000256:	cf89                	beqz	a5,80000270 <strncmp+0x26>
    80000258:	0005c703          	lbu	a4,0(a1)
    8000025c:	00f71a63          	bne	a4,a5,80000270 <strncmp+0x26>
    n--, p++, q++;
    80000260:	367d                	addiw	a2,a2,-1
    80000262:	0505                	addi	a0,a0,1
    80000264:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000266:	f675                	bnez	a2,80000252 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000268:	4501                	li	a0,0
    8000026a:	a801                	j	8000027a <strncmp+0x30>
    8000026c:	4501                	li	a0,0
    8000026e:	a031                	j	8000027a <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
    80000270:	00054503          	lbu	a0,0(a0)
    80000274:	0005c783          	lbu	a5,0(a1)
    80000278:	9d1d                	subw	a0,a0,a5
}
    8000027a:	6422                	ld	s0,8(sp)
    8000027c:	0141                	addi	sp,sp,16
    8000027e:	8082                	ret

0000000080000280 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000280:	1141                	addi	sp,sp,-16
    80000282:	e422                	sd	s0,8(sp)
    80000284:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000286:	87aa                	mv	a5,a0
    80000288:	86b2                	mv	a3,a2
    8000028a:	367d                	addiw	a2,a2,-1
    8000028c:	02d05563          	blez	a3,800002b6 <strncpy+0x36>
    80000290:	0785                	addi	a5,a5,1
    80000292:	0005c703          	lbu	a4,0(a1)
    80000296:	fee78fa3          	sb	a4,-1(a5)
    8000029a:	0585                	addi	a1,a1,1
    8000029c:	f775                	bnez	a4,80000288 <strncpy+0x8>
    ;
  while(n-- > 0)
    8000029e:	873e                	mv	a4,a5
    800002a0:	9fb5                	addw	a5,a5,a3
    800002a2:	37fd                	addiw	a5,a5,-1
    800002a4:	00c05963          	blez	a2,800002b6 <strncpy+0x36>
    *s++ = 0;
    800002a8:	0705                	addi	a4,a4,1
    800002aa:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    800002ae:	40e786bb          	subw	a3,a5,a4
    800002b2:	fed04be3          	bgtz	a3,800002a8 <strncpy+0x28>
  return os;
}
    800002b6:	6422                	ld	s0,8(sp)
    800002b8:	0141                	addi	sp,sp,16
    800002ba:	8082                	ret

00000000800002bc <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002bc:	1141                	addi	sp,sp,-16
    800002be:	e422                	sd	s0,8(sp)
    800002c0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002c2:	02c05363          	blez	a2,800002e8 <safestrcpy+0x2c>
    800002c6:	fff6069b          	addiw	a3,a2,-1
    800002ca:	1682                	slli	a3,a3,0x20
    800002cc:	9281                	srli	a3,a3,0x20
    800002ce:	96ae                	add	a3,a3,a1
    800002d0:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002d2:	00d58963          	beq	a1,a3,800002e4 <safestrcpy+0x28>
    800002d6:	0585                	addi	a1,a1,1
    800002d8:	0785                	addi	a5,a5,1
    800002da:	fff5c703          	lbu	a4,-1(a1)
    800002de:	fee78fa3          	sb	a4,-1(a5)
    800002e2:	fb65                	bnez	a4,800002d2 <safestrcpy+0x16>
    ;
  *s = 0;
    800002e4:	00078023          	sb	zero,0(a5)
  return os;
}
    800002e8:	6422                	ld	s0,8(sp)
    800002ea:	0141                	addi	sp,sp,16
    800002ec:	8082                	ret

00000000800002ee <strlen>:

int
strlen(const char *s)
{
    800002ee:	1141                	addi	sp,sp,-16
    800002f0:	e422                	sd	s0,8(sp)
    800002f2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800002f4:	00054783          	lbu	a5,0(a0)
    800002f8:	cf91                	beqz	a5,80000314 <strlen+0x26>
    800002fa:	0505                	addi	a0,a0,1
    800002fc:	87aa                	mv	a5,a0
    800002fe:	86be                	mv	a3,a5
    80000300:	0785                	addi	a5,a5,1
    80000302:	fff7c703          	lbu	a4,-1(a5)
    80000306:	ff65                	bnez	a4,800002fe <strlen+0x10>
    80000308:	40a6853b          	subw	a0,a3,a0
    8000030c:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    8000030e:	6422                	ld	s0,8(sp)
    80000310:	0141                	addi	sp,sp,16
    80000312:	8082                	ret
  for(n = 0; s[n]; n++)
    80000314:	4501                	li	a0,0
    80000316:	bfe5                	j	8000030e <strlen+0x20>

0000000080000318 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000318:	1141                	addi	sp,sp,-16
    8000031a:	e406                	sd	ra,8(sp)
    8000031c:	e022                	sd	s0,0(sp)
    8000031e:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000320:	00001097          	auipc	ra,0x1
    80000324:	b30080e7          	jalr	-1232(ra) # 80000e50 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000328:	00009717          	auipc	a4,0x9
    8000032c:	cd870713          	addi	a4,a4,-808 # 80009000 <started>
  if(cpuid() == 0){
    80000330:	c139                	beqz	a0,80000376 <main+0x5e>
    while(started == 0)
    80000332:	431c                	lw	a5,0(a4)
    80000334:	2781                	sext.w	a5,a5
    80000336:	dff5                	beqz	a5,80000332 <main+0x1a>
      ;
    __sync_synchronize();
    80000338:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    8000033c:	00001097          	auipc	ra,0x1
    80000340:	b14080e7          	jalr	-1260(ra) # 80000e50 <cpuid>
    80000344:	85aa                	mv	a1,a0
    80000346:	00008517          	auipc	a0,0x8
    8000034a:	cf250513          	addi	a0,a0,-782 # 80008038 <etext+0x38>
    8000034e:	00006097          	auipc	ra,0x6
    80000352:	9b2080e7          	jalr	-1614(ra) # 80005d00 <printf>
    kvminithart();    // turn on paging
    80000356:	00000097          	auipc	ra,0x0
    8000035a:	0d8080e7          	jalr	216(ra) # 8000042e <kvminithart>
    trapinithart();   // install kernel trap vector
    8000035e:	00001097          	auipc	ra,0x1
    80000362:	776080e7          	jalr	1910(ra) # 80001ad4 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000366:	00005097          	auipc	ra,0x5
    8000036a:	d9e080e7          	jalr	-610(ra) # 80005104 <plicinithart>
  }

  scheduler();        
    8000036e:	00001097          	auipc	ra,0x1
    80000372:	022080e7          	jalr	34(ra) # 80001390 <scheduler>
    consoleinit();
    80000376:	00005097          	auipc	ra,0x5
    8000037a:	7b6080e7          	jalr	1974(ra) # 80005b2c <consoleinit>
    printfinit();
    8000037e:	00006097          	auipc	ra,0x6
    80000382:	89e080e7          	jalr	-1890(ra) # 80005c1c <printfinit>
    printf("\n");
    80000386:	00008517          	auipc	a0,0x8
    8000038a:	c9250513          	addi	a0,a0,-878 # 80008018 <etext+0x18>
    8000038e:	00006097          	auipc	ra,0x6
    80000392:	972080e7          	jalr	-1678(ra) # 80005d00 <printf>
    printf("xv6 kernel is booting\n");
    80000396:	00008517          	auipc	a0,0x8
    8000039a:	c8a50513          	addi	a0,a0,-886 # 80008020 <etext+0x20>
    8000039e:	00006097          	auipc	ra,0x6
    800003a2:	962080e7          	jalr	-1694(ra) # 80005d00 <printf>
    printf("\n");
    800003a6:	00008517          	auipc	a0,0x8
    800003aa:	c7250513          	addi	a0,a0,-910 # 80008018 <etext+0x18>
    800003ae:	00006097          	auipc	ra,0x6
    800003b2:	952080e7          	jalr	-1710(ra) # 80005d00 <printf>
    kinit();         // physical page allocator
    800003b6:	00000097          	auipc	ra,0x0
    800003ba:	d28080e7          	jalr	-728(ra) # 800000de <kinit>
    kvminit();       // create kernel page table
    800003be:	00000097          	auipc	ra,0x0
    800003c2:	322080e7          	jalr	802(ra) # 800006e0 <kvminit>
    kvminithart();   // turn on paging
    800003c6:	00000097          	auipc	ra,0x0
    800003ca:	068080e7          	jalr	104(ra) # 8000042e <kvminithart>
    procinit();      // process table
    800003ce:	00001097          	auipc	ra,0x1
    800003d2:	9c4080e7          	jalr	-1596(ra) # 80000d92 <procinit>
    trapinit();      // trap vectors
    800003d6:	00001097          	auipc	ra,0x1
    800003da:	6d6080e7          	jalr	1750(ra) # 80001aac <trapinit>
    trapinithart();  // install kernel trap vector
    800003de:	00001097          	auipc	ra,0x1
    800003e2:	6f6080e7          	jalr	1782(ra) # 80001ad4 <trapinithart>
    plicinit();      // set up interrupt controller
    800003e6:	00005097          	auipc	ra,0x5
    800003ea:	d04080e7          	jalr	-764(ra) # 800050ea <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003ee:	00005097          	auipc	ra,0x5
    800003f2:	d16080e7          	jalr	-746(ra) # 80005104 <plicinithart>
    binit();         // buffer cache
    800003f6:	00002097          	auipc	ra,0x2
    800003fa:	e38080e7          	jalr	-456(ra) # 8000222e <binit>
    iinit();         // inode table
    800003fe:	00002097          	auipc	ra,0x2
    80000402:	4c4080e7          	jalr	1220(ra) # 800028c2 <iinit>
    fileinit();      // file table
    80000406:	00003097          	auipc	ra,0x3
    8000040a:	468080e7          	jalr	1128(ra) # 8000386e <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000040e:	00005097          	auipc	ra,0x5
    80000412:	e16080e7          	jalr	-490(ra) # 80005224 <virtio_disk_init>
    userinit();      // first user process
    80000416:	00001097          	auipc	ra,0x1
    8000041a:	d3e080e7          	jalr	-706(ra) # 80001154 <userinit>
    __sync_synchronize();
    8000041e:	0ff0000f          	fence
    started = 1;
    80000422:	4785                	li	a5,1
    80000424:	00009717          	auipc	a4,0x9
    80000428:	bcf72e23          	sw	a5,-1060(a4) # 80009000 <started>
    8000042c:	b789                	j	8000036e <main+0x56>

000000008000042e <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    8000042e:	1141                	addi	sp,sp,-16
    80000430:	e422                	sd	s0,8(sp)
    80000432:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    80000434:	00009797          	auipc	a5,0x9
    80000438:	bd47b783          	ld	a5,-1068(a5) # 80009008 <kernel_pagetable>
    8000043c:	83b1                	srli	a5,a5,0xc
    8000043e:	577d                	li	a4,-1
    80000440:	177e                	slli	a4,a4,0x3f
    80000442:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    80000444:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000448:	12000073          	sfence.vma
  sfence_vma();
}
    8000044c:	6422                	ld	s0,8(sp)
    8000044e:	0141                	addi	sp,sp,16
    80000450:	8082                	ret

0000000080000452 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000452:	7139                	addi	sp,sp,-64
    80000454:	fc06                	sd	ra,56(sp)
    80000456:	f822                	sd	s0,48(sp)
    80000458:	f426                	sd	s1,40(sp)
    8000045a:	f04a                	sd	s2,32(sp)
    8000045c:	ec4e                	sd	s3,24(sp)
    8000045e:	e852                	sd	s4,16(sp)
    80000460:	e456                	sd	s5,8(sp)
    80000462:	e05a                	sd	s6,0(sp)
    80000464:	0080                	addi	s0,sp,64
    80000466:	84aa                	mv	s1,a0
    80000468:	89ae                	mv	s3,a1
    8000046a:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    8000046c:	57fd                	li	a5,-1
    8000046e:	83e9                	srli	a5,a5,0x1a
    80000470:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000472:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000474:	04b7f263          	bgeu	a5,a1,800004b8 <walk+0x66>
    panic("walk");
    80000478:	00008517          	auipc	a0,0x8
    8000047c:	bd850513          	addi	a0,a0,-1064 # 80008050 <etext+0x50>
    80000480:	00006097          	auipc	ra,0x6
    80000484:	82e080e7          	jalr	-2002(ra) # 80005cae <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000488:	060a8663          	beqz	s5,800004f4 <walk+0xa2>
    8000048c:	00000097          	auipc	ra,0x0
    80000490:	c8e080e7          	jalr	-882(ra) # 8000011a <kalloc>
    80000494:	84aa                	mv	s1,a0
    80000496:	c529                	beqz	a0,800004e0 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000498:	6605                	lui	a2,0x1
    8000049a:	4581                	li	a1,0
    8000049c:	00000097          	auipc	ra,0x0
    800004a0:	cde080e7          	jalr	-802(ra) # 8000017a <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004a4:	00c4d793          	srli	a5,s1,0xc
    800004a8:	07aa                	slli	a5,a5,0xa
    800004aa:	0017e793          	ori	a5,a5,1
    800004ae:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004b2:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffd8db7>
    800004b4:	036a0063          	beq	s4,s6,800004d4 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004b8:	0149d933          	srl	s2,s3,s4
    800004bc:	1ff97913          	andi	s2,s2,511
    800004c0:	090e                	slli	s2,s2,0x3
    800004c2:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004c4:	00093483          	ld	s1,0(s2)
    800004c8:	0014f793          	andi	a5,s1,1
    800004cc:	dfd5                	beqz	a5,80000488 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004ce:	80a9                	srli	s1,s1,0xa
    800004d0:	04b2                	slli	s1,s1,0xc
    800004d2:	b7c5                	j	800004b2 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800004d4:	00c9d513          	srli	a0,s3,0xc
    800004d8:	1ff57513          	andi	a0,a0,511
    800004dc:	050e                	slli	a0,a0,0x3
    800004de:	9526                	add	a0,a0,s1
}
    800004e0:	70e2                	ld	ra,56(sp)
    800004e2:	7442                	ld	s0,48(sp)
    800004e4:	74a2                	ld	s1,40(sp)
    800004e6:	7902                	ld	s2,32(sp)
    800004e8:	69e2                	ld	s3,24(sp)
    800004ea:	6a42                	ld	s4,16(sp)
    800004ec:	6aa2                	ld	s5,8(sp)
    800004ee:	6b02                	ld	s6,0(sp)
    800004f0:	6121                	addi	sp,sp,64
    800004f2:	8082                	ret
        return 0;
    800004f4:	4501                	li	a0,0
    800004f6:	b7ed                	j	800004e0 <walk+0x8e>

00000000800004f8 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    800004f8:	57fd                	li	a5,-1
    800004fa:	83e9                	srli	a5,a5,0x1a
    800004fc:	00b7f463          	bgeu	a5,a1,80000504 <walkaddr+0xc>
    return 0;
    80000500:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000502:	8082                	ret
{
    80000504:	1141                	addi	sp,sp,-16
    80000506:	e406                	sd	ra,8(sp)
    80000508:	e022                	sd	s0,0(sp)
    8000050a:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000050c:	4601                	li	a2,0
    8000050e:	00000097          	auipc	ra,0x0
    80000512:	f44080e7          	jalr	-188(ra) # 80000452 <walk>
  if(pte == 0)
    80000516:	c105                	beqz	a0,80000536 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000518:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000051a:	0117f693          	andi	a3,a5,17
    8000051e:	4745                	li	a4,17
    return 0;
    80000520:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000522:	00e68663          	beq	a3,a4,8000052e <walkaddr+0x36>
}
    80000526:	60a2                	ld	ra,8(sp)
    80000528:	6402                	ld	s0,0(sp)
    8000052a:	0141                	addi	sp,sp,16
    8000052c:	8082                	ret
  pa = PTE2PA(*pte);
    8000052e:	83a9                	srli	a5,a5,0xa
    80000530:	00c79513          	slli	a0,a5,0xc
  return pa;
    80000534:	bfcd                	j	80000526 <walkaddr+0x2e>
    return 0;
    80000536:	4501                	li	a0,0
    80000538:	b7fd                	j	80000526 <walkaddr+0x2e>

000000008000053a <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000053a:	715d                	addi	sp,sp,-80
    8000053c:	e486                	sd	ra,72(sp)
    8000053e:	e0a2                	sd	s0,64(sp)
    80000540:	fc26                	sd	s1,56(sp)
    80000542:	f84a                	sd	s2,48(sp)
    80000544:	f44e                	sd	s3,40(sp)
    80000546:	f052                	sd	s4,32(sp)
    80000548:	ec56                	sd	s5,24(sp)
    8000054a:	e85a                	sd	s6,16(sp)
    8000054c:	e45e                	sd	s7,8(sp)
    8000054e:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    80000550:	c639                	beqz	a2,8000059e <mappages+0x64>
    80000552:	8aaa                	mv	s5,a0
    80000554:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    80000556:	777d                	lui	a4,0xfffff
    80000558:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    8000055c:	fff58993          	addi	s3,a1,-1
    80000560:	99b2                	add	s3,s3,a2
    80000562:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    80000566:	893e                	mv	s2,a5
    80000568:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    8000056c:	6b85                	lui	s7,0x1
    8000056e:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    80000572:	4605                	li	a2,1
    80000574:	85ca                	mv	a1,s2
    80000576:	8556                	mv	a0,s5
    80000578:	00000097          	auipc	ra,0x0
    8000057c:	eda080e7          	jalr	-294(ra) # 80000452 <walk>
    80000580:	cd1d                	beqz	a0,800005be <mappages+0x84>
    if(*pte & PTE_V)
    80000582:	611c                	ld	a5,0(a0)
    80000584:	8b85                	andi	a5,a5,1
    80000586:	e785                	bnez	a5,800005ae <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80000588:	80b1                	srli	s1,s1,0xc
    8000058a:	04aa                	slli	s1,s1,0xa
    8000058c:	0164e4b3          	or	s1,s1,s6
    80000590:	0014e493          	ori	s1,s1,1
    80000594:	e104                	sd	s1,0(a0)
    if(a == last)
    80000596:	05390063          	beq	s2,s3,800005d6 <mappages+0x9c>
    a += PGSIZE;
    8000059a:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    8000059c:	bfc9                	j	8000056e <mappages+0x34>
    panic("mappages: size");
    8000059e:	00008517          	auipc	a0,0x8
    800005a2:	aba50513          	addi	a0,a0,-1350 # 80008058 <etext+0x58>
    800005a6:	00005097          	auipc	ra,0x5
    800005aa:	708080e7          	jalr	1800(ra) # 80005cae <panic>
      panic("mappages: remap");
    800005ae:	00008517          	auipc	a0,0x8
    800005b2:	aba50513          	addi	a0,a0,-1350 # 80008068 <etext+0x68>
    800005b6:	00005097          	auipc	ra,0x5
    800005ba:	6f8080e7          	jalr	1784(ra) # 80005cae <panic>
      return -1;
    800005be:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800005c0:	60a6                	ld	ra,72(sp)
    800005c2:	6406                	ld	s0,64(sp)
    800005c4:	74e2                	ld	s1,56(sp)
    800005c6:	7942                	ld	s2,48(sp)
    800005c8:	79a2                	ld	s3,40(sp)
    800005ca:	7a02                	ld	s4,32(sp)
    800005cc:	6ae2                	ld	s5,24(sp)
    800005ce:	6b42                	ld	s6,16(sp)
    800005d0:	6ba2                	ld	s7,8(sp)
    800005d2:	6161                	addi	sp,sp,80
    800005d4:	8082                	ret
  return 0;
    800005d6:	4501                	li	a0,0
    800005d8:	b7e5                	j	800005c0 <mappages+0x86>

00000000800005da <kvmmap>:
{
    800005da:	1141                	addi	sp,sp,-16
    800005dc:	e406                	sd	ra,8(sp)
    800005de:	e022                	sd	s0,0(sp)
    800005e0:	0800                	addi	s0,sp,16
    800005e2:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800005e4:	86b2                	mv	a3,a2
    800005e6:	863e                	mv	a2,a5
    800005e8:	00000097          	auipc	ra,0x0
    800005ec:	f52080e7          	jalr	-174(ra) # 8000053a <mappages>
    800005f0:	e509                	bnez	a0,800005fa <kvmmap+0x20>
}
    800005f2:	60a2                	ld	ra,8(sp)
    800005f4:	6402                	ld	s0,0(sp)
    800005f6:	0141                	addi	sp,sp,16
    800005f8:	8082                	ret
    panic("kvmmap");
    800005fa:	00008517          	auipc	a0,0x8
    800005fe:	a7e50513          	addi	a0,a0,-1410 # 80008078 <etext+0x78>
    80000602:	00005097          	auipc	ra,0x5
    80000606:	6ac080e7          	jalr	1708(ra) # 80005cae <panic>

000000008000060a <kvmmake>:
{
    8000060a:	1101                	addi	sp,sp,-32
    8000060c:	ec06                	sd	ra,24(sp)
    8000060e:	e822                	sd	s0,16(sp)
    80000610:	e426                	sd	s1,8(sp)
    80000612:	e04a                	sd	s2,0(sp)
    80000614:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000616:	00000097          	auipc	ra,0x0
    8000061a:	b04080e7          	jalr	-1276(ra) # 8000011a <kalloc>
    8000061e:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000620:	6605                	lui	a2,0x1
    80000622:	4581                	li	a1,0
    80000624:	00000097          	auipc	ra,0x0
    80000628:	b56080e7          	jalr	-1194(ra) # 8000017a <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000062c:	4719                	li	a4,6
    8000062e:	6685                	lui	a3,0x1
    80000630:	10000637          	lui	a2,0x10000
    80000634:	100005b7          	lui	a1,0x10000
    80000638:	8526                	mv	a0,s1
    8000063a:	00000097          	auipc	ra,0x0
    8000063e:	fa0080e7          	jalr	-96(ra) # 800005da <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80000642:	4719                	li	a4,6
    80000644:	6685                	lui	a3,0x1
    80000646:	10001637          	lui	a2,0x10001
    8000064a:	100015b7          	lui	a1,0x10001
    8000064e:	8526                	mv	a0,s1
    80000650:	00000097          	auipc	ra,0x0
    80000654:	f8a080e7          	jalr	-118(ra) # 800005da <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000658:	4719                	li	a4,6
    8000065a:	004006b7          	lui	a3,0x400
    8000065e:	0c000637          	lui	a2,0xc000
    80000662:	0c0005b7          	lui	a1,0xc000
    80000666:	8526                	mv	a0,s1
    80000668:	00000097          	auipc	ra,0x0
    8000066c:	f72080e7          	jalr	-142(ra) # 800005da <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80000670:	00008917          	auipc	s2,0x8
    80000674:	99090913          	addi	s2,s2,-1648 # 80008000 <etext>
    80000678:	4729                	li	a4,10
    8000067a:	80008697          	auipc	a3,0x80008
    8000067e:	98668693          	addi	a3,a3,-1658 # 8000 <_entry-0x7fff8000>
    80000682:	4605                	li	a2,1
    80000684:	067e                	slli	a2,a2,0x1f
    80000686:	85b2                	mv	a1,a2
    80000688:	8526                	mv	a0,s1
    8000068a:	00000097          	auipc	ra,0x0
    8000068e:	f50080e7          	jalr	-176(ra) # 800005da <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80000692:	46c5                	li	a3,17
    80000694:	06ee                	slli	a3,a3,0x1b
    80000696:	4719                	li	a4,6
    80000698:	412686b3          	sub	a3,a3,s2
    8000069c:	864a                	mv	a2,s2
    8000069e:	85ca                	mv	a1,s2
    800006a0:	8526                	mv	a0,s1
    800006a2:	00000097          	auipc	ra,0x0
    800006a6:	f38080e7          	jalr	-200(ra) # 800005da <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006aa:	4729                	li	a4,10
    800006ac:	6685                	lui	a3,0x1
    800006ae:	00007617          	auipc	a2,0x7
    800006b2:	95260613          	addi	a2,a2,-1710 # 80007000 <_trampoline>
    800006b6:	040005b7          	lui	a1,0x4000
    800006ba:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800006bc:	05b2                	slli	a1,a1,0xc
    800006be:	8526                	mv	a0,s1
    800006c0:	00000097          	auipc	ra,0x0
    800006c4:	f1a080e7          	jalr	-230(ra) # 800005da <kvmmap>
  proc_mapstacks(kpgtbl);
    800006c8:	8526                	mv	a0,s1
    800006ca:	00000097          	auipc	ra,0x0
    800006ce:	624080e7          	jalr	1572(ra) # 80000cee <proc_mapstacks>
}
    800006d2:	8526                	mv	a0,s1
    800006d4:	60e2                	ld	ra,24(sp)
    800006d6:	6442                	ld	s0,16(sp)
    800006d8:	64a2                	ld	s1,8(sp)
    800006da:	6902                	ld	s2,0(sp)
    800006dc:	6105                	addi	sp,sp,32
    800006de:	8082                	ret

00000000800006e0 <kvminit>:
{
    800006e0:	1141                	addi	sp,sp,-16
    800006e2:	e406                	sd	ra,8(sp)
    800006e4:	e022                	sd	s0,0(sp)
    800006e6:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800006e8:	00000097          	auipc	ra,0x0
    800006ec:	f22080e7          	jalr	-222(ra) # 8000060a <kvmmake>
    800006f0:	00009797          	auipc	a5,0x9
    800006f4:	90a7bc23          	sd	a0,-1768(a5) # 80009008 <kernel_pagetable>
}
    800006f8:	60a2                	ld	ra,8(sp)
    800006fa:	6402                	ld	s0,0(sp)
    800006fc:	0141                	addi	sp,sp,16
    800006fe:	8082                	ret

0000000080000700 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000700:	715d                	addi	sp,sp,-80
    80000702:	e486                	sd	ra,72(sp)
    80000704:	e0a2                	sd	s0,64(sp)
    80000706:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000708:	03459793          	slli	a5,a1,0x34
    8000070c:	e39d                	bnez	a5,80000732 <uvmunmap+0x32>
    8000070e:	f84a                	sd	s2,48(sp)
    80000710:	f44e                	sd	s3,40(sp)
    80000712:	f052                	sd	s4,32(sp)
    80000714:	ec56                	sd	s5,24(sp)
    80000716:	e85a                	sd	s6,16(sp)
    80000718:	e45e                	sd	s7,8(sp)
    8000071a:	8a2a                	mv	s4,a0
    8000071c:	892e                	mv	s2,a1
    8000071e:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000720:	0632                	slli	a2,a2,0xc
    80000722:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000726:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000728:	6b05                	lui	s6,0x1
    8000072a:	0935fb63          	bgeu	a1,s3,800007c0 <uvmunmap+0xc0>
    8000072e:	fc26                	sd	s1,56(sp)
    80000730:	a8a9                	j	8000078a <uvmunmap+0x8a>
    80000732:	fc26                	sd	s1,56(sp)
    80000734:	f84a                	sd	s2,48(sp)
    80000736:	f44e                	sd	s3,40(sp)
    80000738:	f052                	sd	s4,32(sp)
    8000073a:	ec56                	sd	s5,24(sp)
    8000073c:	e85a                	sd	s6,16(sp)
    8000073e:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    80000740:	00008517          	auipc	a0,0x8
    80000744:	94050513          	addi	a0,a0,-1728 # 80008080 <etext+0x80>
    80000748:	00005097          	auipc	ra,0x5
    8000074c:	566080e7          	jalr	1382(ra) # 80005cae <panic>
      panic("uvmunmap: walk");
    80000750:	00008517          	auipc	a0,0x8
    80000754:	94850513          	addi	a0,a0,-1720 # 80008098 <etext+0x98>
    80000758:	00005097          	auipc	ra,0x5
    8000075c:	556080e7          	jalr	1366(ra) # 80005cae <panic>
      panic("uvmunmap: not mapped");
    80000760:	00008517          	auipc	a0,0x8
    80000764:	94850513          	addi	a0,a0,-1720 # 800080a8 <etext+0xa8>
    80000768:	00005097          	auipc	ra,0x5
    8000076c:	546080e7          	jalr	1350(ra) # 80005cae <panic>
      panic("uvmunmap: not a leaf");
    80000770:	00008517          	auipc	a0,0x8
    80000774:	95050513          	addi	a0,a0,-1712 # 800080c0 <etext+0xc0>
    80000778:	00005097          	auipc	ra,0x5
    8000077c:	536080e7          	jalr	1334(ra) # 80005cae <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    80000780:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000784:	995a                	add	s2,s2,s6
    80000786:	03397c63          	bgeu	s2,s3,800007be <uvmunmap+0xbe>
    if((pte = walk(pagetable, a, 0)) == 0)
    8000078a:	4601                	li	a2,0
    8000078c:	85ca                	mv	a1,s2
    8000078e:	8552                	mv	a0,s4
    80000790:	00000097          	auipc	ra,0x0
    80000794:	cc2080e7          	jalr	-830(ra) # 80000452 <walk>
    80000798:	84aa                	mv	s1,a0
    8000079a:	d95d                	beqz	a0,80000750 <uvmunmap+0x50>
    if((*pte & PTE_V) == 0)
    8000079c:	6108                	ld	a0,0(a0)
    8000079e:	00157793          	andi	a5,a0,1
    800007a2:	dfdd                	beqz	a5,80000760 <uvmunmap+0x60>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007a4:	3ff57793          	andi	a5,a0,1023
    800007a8:	fd7784e3          	beq	a5,s7,80000770 <uvmunmap+0x70>
    if(do_free){
    800007ac:	fc0a8ae3          	beqz	s5,80000780 <uvmunmap+0x80>
      uint64 pa = PTE2PA(*pte);
    800007b0:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800007b2:	0532                	slli	a0,a0,0xc
    800007b4:	00000097          	auipc	ra,0x0
    800007b8:	868080e7          	jalr	-1944(ra) # 8000001c <kfree>
    800007bc:	b7d1                	j	80000780 <uvmunmap+0x80>
    800007be:	74e2                	ld	s1,56(sp)
    800007c0:	7942                	ld	s2,48(sp)
    800007c2:	79a2                	ld	s3,40(sp)
    800007c4:	7a02                	ld	s4,32(sp)
    800007c6:	6ae2                	ld	s5,24(sp)
    800007c8:	6b42                	ld	s6,16(sp)
    800007ca:	6ba2                	ld	s7,8(sp)
  }
}
    800007cc:	60a6                	ld	ra,72(sp)
    800007ce:	6406                	ld	s0,64(sp)
    800007d0:	6161                	addi	sp,sp,80
    800007d2:	8082                	ret

00000000800007d4 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007d4:	1101                	addi	sp,sp,-32
    800007d6:	ec06                	sd	ra,24(sp)
    800007d8:	e822                	sd	s0,16(sp)
    800007da:	e426                	sd	s1,8(sp)
    800007dc:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800007de:	00000097          	auipc	ra,0x0
    800007e2:	93c080e7          	jalr	-1732(ra) # 8000011a <kalloc>
    800007e6:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800007e8:	c519                	beqz	a0,800007f6 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800007ea:	6605                	lui	a2,0x1
    800007ec:	4581                	li	a1,0
    800007ee:	00000097          	auipc	ra,0x0
    800007f2:	98c080e7          	jalr	-1652(ra) # 8000017a <memset>
  return pagetable;
}
    800007f6:	8526                	mv	a0,s1
    800007f8:	60e2                	ld	ra,24(sp)
    800007fa:	6442                	ld	s0,16(sp)
    800007fc:	64a2                	ld	s1,8(sp)
    800007fe:	6105                	addi	sp,sp,32
    80000800:	8082                	ret

0000000080000802 <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    80000802:	7179                	addi	sp,sp,-48
    80000804:	f406                	sd	ra,40(sp)
    80000806:	f022                	sd	s0,32(sp)
    80000808:	ec26                	sd	s1,24(sp)
    8000080a:	e84a                	sd	s2,16(sp)
    8000080c:	e44e                	sd	s3,8(sp)
    8000080e:	e052                	sd	s4,0(sp)
    80000810:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000812:	6785                	lui	a5,0x1
    80000814:	04f67863          	bgeu	a2,a5,80000864 <uvminit+0x62>
    80000818:	8a2a                	mv	s4,a0
    8000081a:	89ae                	mv	s3,a1
    8000081c:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    8000081e:	00000097          	auipc	ra,0x0
    80000822:	8fc080e7          	jalr	-1796(ra) # 8000011a <kalloc>
    80000826:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000828:	6605                	lui	a2,0x1
    8000082a:	4581                	li	a1,0
    8000082c:	00000097          	auipc	ra,0x0
    80000830:	94e080e7          	jalr	-1714(ra) # 8000017a <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000834:	4779                	li	a4,30
    80000836:	86ca                	mv	a3,s2
    80000838:	6605                	lui	a2,0x1
    8000083a:	4581                	li	a1,0
    8000083c:	8552                	mv	a0,s4
    8000083e:	00000097          	auipc	ra,0x0
    80000842:	cfc080e7          	jalr	-772(ra) # 8000053a <mappages>
  memmove(mem, src, sz);
    80000846:	8626                	mv	a2,s1
    80000848:	85ce                	mv	a1,s3
    8000084a:	854a                	mv	a0,s2
    8000084c:	00000097          	auipc	ra,0x0
    80000850:	98a080e7          	jalr	-1654(ra) # 800001d6 <memmove>
}
    80000854:	70a2                	ld	ra,40(sp)
    80000856:	7402                	ld	s0,32(sp)
    80000858:	64e2                	ld	s1,24(sp)
    8000085a:	6942                	ld	s2,16(sp)
    8000085c:	69a2                	ld	s3,8(sp)
    8000085e:	6a02                	ld	s4,0(sp)
    80000860:	6145                	addi	sp,sp,48
    80000862:	8082                	ret
    panic("inituvm: more than a page");
    80000864:	00008517          	auipc	a0,0x8
    80000868:	87450513          	addi	a0,a0,-1932 # 800080d8 <etext+0xd8>
    8000086c:	00005097          	auipc	ra,0x5
    80000870:	442080e7          	jalr	1090(ra) # 80005cae <panic>

0000000080000874 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000874:	1101                	addi	sp,sp,-32
    80000876:	ec06                	sd	ra,24(sp)
    80000878:	e822                	sd	s0,16(sp)
    8000087a:	e426                	sd	s1,8(sp)
    8000087c:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    8000087e:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80000880:	00b67d63          	bgeu	a2,a1,8000089a <uvmdealloc+0x26>
    80000884:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000886:	6785                	lui	a5,0x1
    80000888:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000088a:	00f60733          	add	a4,a2,a5
    8000088e:	76fd                	lui	a3,0xfffff
    80000890:	8f75                	and	a4,a4,a3
    80000892:	97ae                	add	a5,a5,a1
    80000894:	8ff5                	and	a5,a5,a3
    80000896:	00f76863          	bltu	a4,a5,800008a6 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    8000089a:	8526                	mv	a0,s1
    8000089c:	60e2                	ld	ra,24(sp)
    8000089e:	6442                	ld	s0,16(sp)
    800008a0:	64a2                	ld	s1,8(sp)
    800008a2:	6105                	addi	sp,sp,32
    800008a4:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008a6:	8f99                	sub	a5,a5,a4
    800008a8:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008aa:	4685                	li	a3,1
    800008ac:	0007861b          	sext.w	a2,a5
    800008b0:	85ba                	mv	a1,a4
    800008b2:	00000097          	auipc	ra,0x0
    800008b6:	e4e080e7          	jalr	-434(ra) # 80000700 <uvmunmap>
    800008ba:	b7c5                	j	8000089a <uvmdealloc+0x26>

00000000800008bc <uvmalloc>:
  if(newsz < oldsz)
    800008bc:	0ab66563          	bltu	a2,a1,80000966 <uvmalloc+0xaa>
{
    800008c0:	7139                	addi	sp,sp,-64
    800008c2:	fc06                	sd	ra,56(sp)
    800008c4:	f822                	sd	s0,48(sp)
    800008c6:	ec4e                	sd	s3,24(sp)
    800008c8:	e852                	sd	s4,16(sp)
    800008ca:	e456                	sd	s5,8(sp)
    800008cc:	0080                	addi	s0,sp,64
    800008ce:	8aaa                	mv	s5,a0
    800008d0:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800008d2:	6785                	lui	a5,0x1
    800008d4:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008d6:	95be                	add	a1,a1,a5
    800008d8:	77fd                	lui	a5,0xfffff
    800008da:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    800008de:	08c9f663          	bgeu	s3,a2,8000096a <uvmalloc+0xae>
    800008e2:	f426                	sd	s1,40(sp)
    800008e4:	f04a                	sd	s2,32(sp)
    800008e6:	894e                	mv	s2,s3
    mem = kalloc();
    800008e8:	00000097          	auipc	ra,0x0
    800008ec:	832080e7          	jalr	-1998(ra) # 8000011a <kalloc>
    800008f0:	84aa                	mv	s1,a0
    if(mem == 0){
    800008f2:	c90d                	beqz	a0,80000924 <uvmalloc+0x68>
    memset(mem, 0, PGSIZE);
    800008f4:	6605                	lui	a2,0x1
    800008f6:	4581                	li	a1,0
    800008f8:	00000097          	auipc	ra,0x0
    800008fc:	882080e7          	jalr	-1918(ra) # 8000017a <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    80000900:	4779                	li	a4,30
    80000902:	86a6                	mv	a3,s1
    80000904:	6605                	lui	a2,0x1
    80000906:	85ca                	mv	a1,s2
    80000908:	8556                	mv	a0,s5
    8000090a:	00000097          	auipc	ra,0x0
    8000090e:	c30080e7          	jalr	-976(ra) # 8000053a <mappages>
    80000912:	e915                	bnez	a0,80000946 <uvmalloc+0x8a>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000914:	6785                	lui	a5,0x1
    80000916:	993e                	add	s2,s2,a5
    80000918:	fd4968e3          	bltu	s2,s4,800008e8 <uvmalloc+0x2c>
  return newsz;
    8000091c:	8552                	mv	a0,s4
    8000091e:	74a2                	ld	s1,40(sp)
    80000920:	7902                	ld	s2,32(sp)
    80000922:	a819                	j	80000938 <uvmalloc+0x7c>
      uvmdealloc(pagetable, a, oldsz);
    80000924:	864e                	mv	a2,s3
    80000926:	85ca                	mv	a1,s2
    80000928:	8556                	mv	a0,s5
    8000092a:	00000097          	auipc	ra,0x0
    8000092e:	f4a080e7          	jalr	-182(ra) # 80000874 <uvmdealloc>
      return 0;
    80000932:	4501                	li	a0,0
    80000934:	74a2                	ld	s1,40(sp)
    80000936:	7902                	ld	s2,32(sp)
}
    80000938:	70e2                	ld	ra,56(sp)
    8000093a:	7442                	ld	s0,48(sp)
    8000093c:	69e2                	ld	s3,24(sp)
    8000093e:	6a42                	ld	s4,16(sp)
    80000940:	6aa2                	ld	s5,8(sp)
    80000942:	6121                	addi	sp,sp,64
    80000944:	8082                	ret
      kfree(mem);
    80000946:	8526                	mv	a0,s1
    80000948:	fffff097          	auipc	ra,0xfffff
    8000094c:	6d4080e7          	jalr	1748(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000950:	864e                	mv	a2,s3
    80000952:	85ca                	mv	a1,s2
    80000954:	8556                	mv	a0,s5
    80000956:	00000097          	auipc	ra,0x0
    8000095a:	f1e080e7          	jalr	-226(ra) # 80000874 <uvmdealloc>
      return 0;
    8000095e:	4501                	li	a0,0
    80000960:	74a2                	ld	s1,40(sp)
    80000962:	7902                	ld	s2,32(sp)
    80000964:	bfd1                	j	80000938 <uvmalloc+0x7c>
    return oldsz;
    80000966:	852e                	mv	a0,a1
}
    80000968:	8082                	ret
  return newsz;
    8000096a:	8532                	mv	a0,a2
    8000096c:	b7f1                	j	80000938 <uvmalloc+0x7c>

000000008000096e <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    8000096e:	7179                	addi	sp,sp,-48
    80000970:	f406                	sd	ra,40(sp)
    80000972:	f022                	sd	s0,32(sp)
    80000974:	ec26                	sd	s1,24(sp)
    80000976:	e84a                	sd	s2,16(sp)
    80000978:	e44e                	sd	s3,8(sp)
    8000097a:	e052                	sd	s4,0(sp)
    8000097c:	1800                	addi	s0,sp,48
    8000097e:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000980:	84aa                	mv	s1,a0
    80000982:	6905                	lui	s2,0x1
    80000984:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000986:	4985                	li	s3,1
    80000988:	a829                	j	800009a2 <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    8000098a:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    8000098c:	00c79513          	slli	a0,a5,0xc
    80000990:	00000097          	auipc	ra,0x0
    80000994:	fde080e7          	jalr	-34(ra) # 8000096e <freewalk>
      pagetable[i] = 0;
    80000998:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    8000099c:	04a1                	addi	s1,s1,8
    8000099e:	03248163          	beq	s1,s2,800009c0 <freewalk+0x52>
    pte_t pte = pagetable[i];
    800009a2:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009a4:	00f7f713          	andi	a4,a5,15
    800009a8:	ff3701e3          	beq	a4,s3,8000098a <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009ac:	8b85                	andi	a5,a5,1
    800009ae:	d7fd                	beqz	a5,8000099c <freewalk+0x2e>
      panic("freewalk: leaf");
    800009b0:	00007517          	auipc	a0,0x7
    800009b4:	74850513          	addi	a0,a0,1864 # 800080f8 <etext+0xf8>
    800009b8:	00005097          	auipc	ra,0x5
    800009bc:	2f6080e7          	jalr	758(ra) # 80005cae <panic>
    }
  }
  kfree((void*)pagetable);
    800009c0:	8552                	mv	a0,s4
    800009c2:	fffff097          	auipc	ra,0xfffff
    800009c6:	65a080e7          	jalr	1626(ra) # 8000001c <kfree>
}
    800009ca:	70a2                	ld	ra,40(sp)
    800009cc:	7402                	ld	s0,32(sp)
    800009ce:	64e2                	ld	s1,24(sp)
    800009d0:	6942                	ld	s2,16(sp)
    800009d2:	69a2                	ld	s3,8(sp)
    800009d4:	6a02                	ld	s4,0(sp)
    800009d6:	6145                	addi	sp,sp,48
    800009d8:	8082                	ret

00000000800009da <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800009da:	1101                	addi	sp,sp,-32
    800009dc:	ec06                	sd	ra,24(sp)
    800009de:	e822                	sd	s0,16(sp)
    800009e0:	e426                	sd	s1,8(sp)
    800009e2:	1000                	addi	s0,sp,32
    800009e4:	84aa                	mv	s1,a0
  if(sz > 0)
    800009e6:	e999                	bnez	a1,800009fc <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800009e8:	8526                	mv	a0,s1
    800009ea:	00000097          	auipc	ra,0x0
    800009ee:	f84080e7          	jalr	-124(ra) # 8000096e <freewalk>
}
    800009f2:	60e2                	ld	ra,24(sp)
    800009f4:	6442                	ld	s0,16(sp)
    800009f6:	64a2                	ld	s1,8(sp)
    800009f8:	6105                	addi	sp,sp,32
    800009fa:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800009fc:	6785                	lui	a5,0x1
    800009fe:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000a00:	95be                	add	a1,a1,a5
    80000a02:	4685                	li	a3,1
    80000a04:	00c5d613          	srli	a2,a1,0xc
    80000a08:	4581                	li	a1,0
    80000a0a:	00000097          	auipc	ra,0x0
    80000a0e:	cf6080e7          	jalr	-778(ra) # 80000700 <uvmunmap>
    80000a12:	bfd9                	j	800009e8 <uvmfree+0xe>

0000000080000a14 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a14:	c679                	beqz	a2,80000ae2 <uvmcopy+0xce>
{
    80000a16:	715d                	addi	sp,sp,-80
    80000a18:	e486                	sd	ra,72(sp)
    80000a1a:	e0a2                	sd	s0,64(sp)
    80000a1c:	fc26                	sd	s1,56(sp)
    80000a1e:	f84a                	sd	s2,48(sp)
    80000a20:	f44e                	sd	s3,40(sp)
    80000a22:	f052                	sd	s4,32(sp)
    80000a24:	ec56                	sd	s5,24(sp)
    80000a26:	e85a                	sd	s6,16(sp)
    80000a28:	e45e                	sd	s7,8(sp)
    80000a2a:	0880                	addi	s0,sp,80
    80000a2c:	8b2a                	mv	s6,a0
    80000a2e:	8aae                	mv	s5,a1
    80000a30:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a32:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a34:	4601                	li	a2,0
    80000a36:	85ce                	mv	a1,s3
    80000a38:	855a                	mv	a0,s6
    80000a3a:	00000097          	auipc	ra,0x0
    80000a3e:	a18080e7          	jalr	-1512(ra) # 80000452 <walk>
    80000a42:	c531                	beqz	a0,80000a8e <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a44:	6118                	ld	a4,0(a0)
    80000a46:	00177793          	andi	a5,a4,1
    80000a4a:	cbb1                	beqz	a5,80000a9e <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a4c:	00a75593          	srli	a1,a4,0xa
    80000a50:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a54:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a58:	fffff097          	auipc	ra,0xfffff
    80000a5c:	6c2080e7          	jalr	1730(ra) # 8000011a <kalloc>
    80000a60:	892a                	mv	s2,a0
    80000a62:	c939                	beqz	a0,80000ab8 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a64:	6605                	lui	a2,0x1
    80000a66:	85de                	mv	a1,s7
    80000a68:	fffff097          	auipc	ra,0xfffff
    80000a6c:	76e080e7          	jalr	1902(ra) # 800001d6 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000a70:	8726                	mv	a4,s1
    80000a72:	86ca                	mv	a3,s2
    80000a74:	6605                	lui	a2,0x1
    80000a76:	85ce                	mv	a1,s3
    80000a78:	8556                	mv	a0,s5
    80000a7a:	00000097          	auipc	ra,0x0
    80000a7e:	ac0080e7          	jalr	-1344(ra) # 8000053a <mappages>
    80000a82:	e515                	bnez	a0,80000aae <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000a84:	6785                	lui	a5,0x1
    80000a86:	99be                	add	s3,s3,a5
    80000a88:	fb49e6e3          	bltu	s3,s4,80000a34 <uvmcopy+0x20>
    80000a8c:	a081                	j	80000acc <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000a8e:	00007517          	auipc	a0,0x7
    80000a92:	67a50513          	addi	a0,a0,1658 # 80008108 <etext+0x108>
    80000a96:	00005097          	auipc	ra,0x5
    80000a9a:	218080e7          	jalr	536(ra) # 80005cae <panic>
      panic("uvmcopy: page not present");
    80000a9e:	00007517          	auipc	a0,0x7
    80000aa2:	68a50513          	addi	a0,a0,1674 # 80008128 <etext+0x128>
    80000aa6:	00005097          	auipc	ra,0x5
    80000aaa:	208080e7          	jalr	520(ra) # 80005cae <panic>
      kfree(mem);
    80000aae:	854a                	mv	a0,s2
    80000ab0:	fffff097          	auipc	ra,0xfffff
    80000ab4:	56c080e7          	jalr	1388(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000ab8:	4685                	li	a3,1
    80000aba:	00c9d613          	srli	a2,s3,0xc
    80000abe:	4581                	li	a1,0
    80000ac0:	8556                	mv	a0,s5
    80000ac2:	00000097          	auipc	ra,0x0
    80000ac6:	c3e080e7          	jalr	-962(ra) # 80000700 <uvmunmap>
  return -1;
    80000aca:	557d                	li	a0,-1
}
    80000acc:	60a6                	ld	ra,72(sp)
    80000ace:	6406                	ld	s0,64(sp)
    80000ad0:	74e2                	ld	s1,56(sp)
    80000ad2:	7942                	ld	s2,48(sp)
    80000ad4:	79a2                	ld	s3,40(sp)
    80000ad6:	7a02                	ld	s4,32(sp)
    80000ad8:	6ae2                	ld	s5,24(sp)
    80000ada:	6b42                	ld	s6,16(sp)
    80000adc:	6ba2                	ld	s7,8(sp)
    80000ade:	6161                	addi	sp,sp,80
    80000ae0:	8082                	ret
  return 0;
    80000ae2:	4501                	li	a0,0
}
    80000ae4:	8082                	ret

0000000080000ae6 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000ae6:	1141                	addi	sp,sp,-16
    80000ae8:	e406                	sd	ra,8(sp)
    80000aea:	e022                	sd	s0,0(sp)
    80000aec:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000aee:	4601                	li	a2,0
    80000af0:	00000097          	auipc	ra,0x0
    80000af4:	962080e7          	jalr	-1694(ra) # 80000452 <walk>
  if(pte == 0)
    80000af8:	c901                	beqz	a0,80000b08 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000afa:	611c                	ld	a5,0(a0)
    80000afc:	9bbd                	andi	a5,a5,-17
    80000afe:	e11c                	sd	a5,0(a0)
}
    80000b00:	60a2                	ld	ra,8(sp)
    80000b02:	6402                	ld	s0,0(sp)
    80000b04:	0141                	addi	sp,sp,16
    80000b06:	8082                	ret
    panic("uvmclear");
    80000b08:	00007517          	auipc	a0,0x7
    80000b0c:	64050513          	addi	a0,a0,1600 # 80008148 <etext+0x148>
    80000b10:	00005097          	auipc	ra,0x5
    80000b14:	19e080e7          	jalr	414(ra) # 80005cae <panic>

0000000080000b18 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b18:	c6bd                	beqz	a3,80000b86 <copyout+0x6e>
{
    80000b1a:	715d                	addi	sp,sp,-80
    80000b1c:	e486                	sd	ra,72(sp)
    80000b1e:	e0a2                	sd	s0,64(sp)
    80000b20:	fc26                	sd	s1,56(sp)
    80000b22:	f84a                	sd	s2,48(sp)
    80000b24:	f44e                	sd	s3,40(sp)
    80000b26:	f052                	sd	s4,32(sp)
    80000b28:	ec56                	sd	s5,24(sp)
    80000b2a:	e85a                	sd	s6,16(sp)
    80000b2c:	e45e                	sd	s7,8(sp)
    80000b2e:	e062                	sd	s8,0(sp)
    80000b30:	0880                	addi	s0,sp,80
    80000b32:	8b2a                	mv	s6,a0
    80000b34:	8c2e                	mv	s8,a1
    80000b36:	8a32                	mv	s4,a2
    80000b38:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b3a:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b3c:	6a85                	lui	s5,0x1
    80000b3e:	a015                	j	80000b62 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b40:	9562                	add	a0,a0,s8
    80000b42:	0004861b          	sext.w	a2,s1
    80000b46:	85d2                	mv	a1,s4
    80000b48:	41250533          	sub	a0,a0,s2
    80000b4c:	fffff097          	auipc	ra,0xfffff
    80000b50:	68a080e7          	jalr	1674(ra) # 800001d6 <memmove>

    len -= n;
    80000b54:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b58:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b5a:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b5e:	02098263          	beqz	s3,80000b82 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b62:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b66:	85ca                	mv	a1,s2
    80000b68:	855a                	mv	a0,s6
    80000b6a:	00000097          	auipc	ra,0x0
    80000b6e:	98e080e7          	jalr	-1650(ra) # 800004f8 <walkaddr>
    if(pa0 == 0)
    80000b72:	cd01                	beqz	a0,80000b8a <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000b74:	418904b3          	sub	s1,s2,s8
    80000b78:	94d6                	add	s1,s1,s5
    if(n > len)
    80000b7a:	fc99f3e3          	bgeu	s3,s1,80000b40 <copyout+0x28>
    80000b7e:	84ce                	mv	s1,s3
    80000b80:	b7c1                	j	80000b40 <copyout+0x28>
  }
  return 0;
    80000b82:	4501                	li	a0,0
    80000b84:	a021                	j	80000b8c <copyout+0x74>
    80000b86:	4501                	li	a0,0
}
    80000b88:	8082                	ret
      return -1;
    80000b8a:	557d                	li	a0,-1
}
    80000b8c:	60a6                	ld	ra,72(sp)
    80000b8e:	6406                	ld	s0,64(sp)
    80000b90:	74e2                	ld	s1,56(sp)
    80000b92:	7942                	ld	s2,48(sp)
    80000b94:	79a2                	ld	s3,40(sp)
    80000b96:	7a02                	ld	s4,32(sp)
    80000b98:	6ae2                	ld	s5,24(sp)
    80000b9a:	6b42                	ld	s6,16(sp)
    80000b9c:	6ba2                	ld	s7,8(sp)
    80000b9e:	6c02                	ld	s8,0(sp)
    80000ba0:	6161                	addi	sp,sp,80
    80000ba2:	8082                	ret

0000000080000ba4 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000ba4:	caa5                	beqz	a3,80000c14 <copyin+0x70>
{
    80000ba6:	715d                	addi	sp,sp,-80
    80000ba8:	e486                	sd	ra,72(sp)
    80000baa:	e0a2                	sd	s0,64(sp)
    80000bac:	fc26                	sd	s1,56(sp)
    80000bae:	f84a                	sd	s2,48(sp)
    80000bb0:	f44e                	sd	s3,40(sp)
    80000bb2:	f052                	sd	s4,32(sp)
    80000bb4:	ec56                	sd	s5,24(sp)
    80000bb6:	e85a                	sd	s6,16(sp)
    80000bb8:	e45e                	sd	s7,8(sp)
    80000bba:	e062                	sd	s8,0(sp)
    80000bbc:	0880                	addi	s0,sp,80
    80000bbe:	8b2a                	mv	s6,a0
    80000bc0:	8a2e                	mv	s4,a1
    80000bc2:	8c32                	mv	s8,a2
    80000bc4:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000bc6:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000bc8:	6a85                	lui	s5,0x1
    80000bca:	a01d                	j	80000bf0 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000bcc:	018505b3          	add	a1,a0,s8
    80000bd0:	0004861b          	sext.w	a2,s1
    80000bd4:	412585b3          	sub	a1,a1,s2
    80000bd8:	8552                	mv	a0,s4
    80000bda:	fffff097          	auipc	ra,0xfffff
    80000bde:	5fc080e7          	jalr	1532(ra) # 800001d6 <memmove>

    len -= n;
    80000be2:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000be6:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000be8:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000bec:	02098263          	beqz	s3,80000c10 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000bf0:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000bf4:	85ca                	mv	a1,s2
    80000bf6:	855a                	mv	a0,s6
    80000bf8:	00000097          	auipc	ra,0x0
    80000bfc:	900080e7          	jalr	-1792(ra) # 800004f8 <walkaddr>
    if(pa0 == 0)
    80000c00:	cd01                	beqz	a0,80000c18 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000c02:	418904b3          	sub	s1,s2,s8
    80000c06:	94d6                	add	s1,s1,s5
    if(n > len)
    80000c08:	fc99f2e3          	bgeu	s3,s1,80000bcc <copyin+0x28>
    80000c0c:	84ce                	mv	s1,s3
    80000c0e:	bf7d                	j	80000bcc <copyin+0x28>
  }
  return 0;
    80000c10:	4501                	li	a0,0
    80000c12:	a021                	j	80000c1a <copyin+0x76>
    80000c14:	4501                	li	a0,0
}
    80000c16:	8082                	ret
      return -1;
    80000c18:	557d                	li	a0,-1
}
    80000c1a:	60a6                	ld	ra,72(sp)
    80000c1c:	6406                	ld	s0,64(sp)
    80000c1e:	74e2                	ld	s1,56(sp)
    80000c20:	7942                	ld	s2,48(sp)
    80000c22:	79a2                	ld	s3,40(sp)
    80000c24:	7a02                	ld	s4,32(sp)
    80000c26:	6ae2                	ld	s5,24(sp)
    80000c28:	6b42                	ld	s6,16(sp)
    80000c2a:	6ba2                	ld	s7,8(sp)
    80000c2c:	6c02                	ld	s8,0(sp)
    80000c2e:	6161                	addi	sp,sp,80
    80000c30:	8082                	ret

0000000080000c32 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c32:	cacd                	beqz	a3,80000ce4 <copyinstr+0xb2>
{
    80000c34:	715d                	addi	sp,sp,-80
    80000c36:	e486                	sd	ra,72(sp)
    80000c38:	e0a2                	sd	s0,64(sp)
    80000c3a:	fc26                	sd	s1,56(sp)
    80000c3c:	f84a                	sd	s2,48(sp)
    80000c3e:	f44e                	sd	s3,40(sp)
    80000c40:	f052                	sd	s4,32(sp)
    80000c42:	ec56                	sd	s5,24(sp)
    80000c44:	e85a                	sd	s6,16(sp)
    80000c46:	e45e                	sd	s7,8(sp)
    80000c48:	0880                	addi	s0,sp,80
    80000c4a:	8a2a                	mv	s4,a0
    80000c4c:	8b2e                	mv	s6,a1
    80000c4e:	8bb2                	mv	s7,a2
    80000c50:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(srcva);
    80000c52:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c54:	6985                	lui	s3,0x1
    80000c56:	a825                	j	80000c8e <copyinstr+0x5c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c58:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c5c:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c5e:	37fd                	addiw	a5,a5,-1
    80000c60:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
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
    80000c76:	6161                	addi	sp,sp,80
    80000c78:	8082                	ret
    80000c7a:	fff90713          	addi	a4,s2,-1 # fff <_entry-0x7ffff001>
    80000c7e:	9742                	add	a4,a4,a6
      --max;
    80000c80:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    80000c84:	01348bb3          	add	s7,s1,s3
  while(got_null == 0 && max > 0){
    80000c88:	04e58663          	beq	a1,a4,80000cd4 <copyinstr+0xa2>
{
    80000c8c:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    80000c8e:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000c92:	85a6                	mv	a1,s1
    80000c94:	8552                	mv	a0,s4
    80000c96:	00000097          	auipc	ra,0x0
    80000c9a:	862080e7          	jalr	-1950(ra) # 800004f8 <walkaddr>
    if(pa0 == 0)
    80000c9e:	cd0d                	beqz	a0,80000cd8 <copyinstr+0xa6>
    n = PGSIZE - (srcva - va0);
    80000ca0:	417486b3          	sub	a3,s1,s7
    80000ca4:	96ce                	add	a3,a3,s3
    if(n > max)
    80000ca6:	00d97363          	bgeu	s2,a3,80000cac <copyinstr+0x7a>
    80000caa:	86ca                	mv	a3,s2
    char *p = (char *) (pa0 + (srcva - va0));
    80000cac:	955e                	add	a0,a0,s7
    80000cae:	8d05                	sub	a0,a0,s1
    while(n > 0){
    80000cb0:	c695                	beqz	a3,80000cdc <copyinstr+0xaa>
    80000cb2:	87da                	mv	a5,s6
    80000cb4:	885a                	mv	a6,s6
      if(*p == '\0'){
    80000cb6:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80000cba:	96da                	add	a3,a3,s6
    80000cbc:	85be                	mv	a1,a5
      if(*p == '\0'){
    80000cbe:	00f60733          	add	a4,a2,a5
    80000cc2:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffd8dc0>
    80000cc6:	db49                	beqz	a4,80000c58 <copyinstr+0x26>
        *dst = *p;
    80000cc8:	00e78023          	sb	a4,0(a5)
      dst++;
    80000ccc:	0785                	addi	a5,a5,1
    while(n > 0){
    80000cce:	fed797e3          	bne	a5,a3,80000cbc <copyinstr+0x8a>
    80000cd2:	b765                	j	80000c7a <copyinstr+0x48>
    80000cd4:	4781                	li	a5,0
    80000cd6:	b761                	j	80000c5e <copyinstr+0x2c>
      return -1;
    80000cd8:	557d                	li	a0,-1
    80000cda:	b769                	j	80000c64 <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    80000cdc:	6b85                	lui	s7,0x1
    80000cde:	9ba6                	add	s7,s7,s1
    80000ce0:	87da                	mv	a5,s6
    80000ce2:	b76d                	j	80000c8c <copyinstr+0x5a>
  int got_null = 0;
    80000ce4:	4781                	li	a5,0
  if(got_null){
    80000ce6:	37fd                	addiw	a5,a5,-1
    80000ce8:	0007851b          	sext.w	a0,a5
}
    80000cec:	8082                	ret

0000000080000cee <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000cee:	7139                	addi	sp,sp,-64
    80000cf0:	fc06                	sd	ra,56(sp)
    80000cf2:	f822                	sd	s0,48(sp)
    80000cf4:	f426                	sd	s1,40(sp)
    80000cf6:	f04a                	sd	s2,32(sp)
    80000cf8:	ec4e                	sd	s3,24(sp)
    80000cfa:	e852                	sd	s4,16(sp)
    80000cfc:	e456                	sd	s5,8(sp)
    80000cfe:	e05a                	sd	s6,0(sp)
    80000d00:	0080                	addi	s0,sp,64
    80000d02:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d04:	00008497          	auipc	s1,0x8
    80000d08:	77c48493          	addi	s1,s1,1916 # 80009480 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000d0c:	8b26                	mv	s6,s1
    80000d0e:	04fa5937          	lui	s2,0x4fa5
    80000d12:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    80000d16:	0932                	slli	s2,s2,0xc
    80000d18:	fa590913          	addi	s2,s2,-91
    80000d1c:	0932                	slli	s2,s2,0xc
    80000d1e:	fa590913          	addi	s2,s2,-91
    80000d22:	0932                	slli	s2,s2,0xc
    80000d24:	fa590913          	addi	s2,s2,-91
    80000d28:	040009b7          	lui	s3,0x4000
    80000d2c:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000d2e:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d30:	0000ea97          	auipc	s5,0xe
    80000d34:	150a8a93          	addi	s5,s5,336 # 8000ee80 <tickslock>
    char *pa = kalloc();
    80000d38:	fffff097          	auipc	ra,0xfffff
    80000d3c:	3e2080e7          	jalr	994(ra) # 8000011a <kalloc>
    80000d40:	862a                	mv	a2,a0
    if(pa == 0)
    80000d42:	c121                	beqz	a0,80000d82 <proc_mapstacks+0x94>
    uint64 va = KSTACK((int) (p - proc));
    80000d44:	416485b3          	sub	a1,s1,s6
    80000d48:	858d                	srai	a1,a1,0x3
    80000d4a:	032585b3          	mul	a1,a1,s2
    80000d4e:	2585                	addiw	a1,a1,1
    80000d50:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d54:	4719                	li	a4,6
    80000d56:	6685                	lui	a3,0x1
    80000d58:	40b985b3          	sub	a1,s3,a1
    80000d5c:	8552                	mv	a0,s4
    80000d5e:	00000097          	auipc	ra,0x0
    80000d62:	87c080e7          	jalr	-1924(ra) # 800005da <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d66:	16848493          	addi	s1,s1,360
    80000d6a:	fd5497e3          	bne	s1,s5,80000d38 <proc_mapstacks+0x4a>
  }
}
    80000d6e:	70e2                	ld	ra,56(sp)
    80000d70:	7442                	ld	s0,48(sp)
    80000d72:	74a2                	ld	s1,40(sp)
    80000d74:	7902                	ld	s2,32(sp)
    80000d76:	69e2                	ld	s3,24(sp)
    80000d78:	6a42                	ld	s4,16(sp)
    80000d7a:	6aa2                	ld	s5,8(sp)
    80000d7c:	6b02                	ld	s6,0(sp)
    80000d7e:	6121                	addi	sp,sp,64
    80000d80:	8082                	ret
      panic("kalloc");
    80000d82:	00007517          	auipc	a0,0x7
    80000d86:	3d650513          	addi	a0,a0,982 # 80008158 <etext+0x158>
    80000d8a:	00005097          	auipc	ra,0x5
    80000d8e:	f24080e7          	jalr	-220(ra) # 80005cae <panic>

0000000080000d92 <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000d92:	7139                	addi	sp,sp,-64
    80000d94:	fc06                	sd	ra,56(sp)
    80000d96:	f822                	sd	s0,48(sp)
    80000d98:	f426                	sd	s1,40(sp)
    80000d9a:	f04a                	sd	s2,32(sp)
    80000d9c:	ec4e                	sd	s3,24(sp)
    80000d9e:	e852                	sd	s4,16(sp)
    80000da0:	e456                	sd	s5,8(sp)
    80000da2:	e05a                	sd	s6,0(sp)
    80000da4:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000da6:	00007597          	auipc	a1,0x7
    80000daa:	3ba58593          	addi	a1,a1,954 # 80008160 <etext+0x160>
    80000dae:	00008517          	auipc	a0,0x8
    80000db2:	2a250513          	addi	a0,a0,674 # 80009050 <pid_lock>
    80000db6:	00005097          	auipc	ra,0x5
    80000dba:	3b8080e7          	jalr	952(ra) # 8000616e <initlock>
  initlock(&wait_lock, "wait_lock");
    80000dbe:	00007597          	auipc	a1,0x7
    80000dc2:	3aa58593          	addi	a1,a1,938 # 80008168 <etext+0x168>
    80000dc6:	00008517          	auipc	a0,0x8
    80000dca:	2a250513          	addi	a0,a0,674 # 80009068 <wait_lock>
    80000dce:	00005097          	auipc	ra,0x5
    80000dd2:	3a0080e7          	jalr	928(ra) # 8000616e <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dd6:	00008497          	auipc	s1,0x8
    80000dda:	6aa48493          	addi	s1,s1,1706 # 80009480 <proc>
      initlock(&p->lock, "proc");
    80000dde:	00007b17          	auipc	s6,0x7
    80000de2:	39ab0b13          	addi	s6,s6,922 # 80008178 <etext+0x178>
      p->kstack = KSTACK((int) (p - proc));
    80000de6:	8aa6                	mv	s5,s1
    80000de8:	04fa5937          	lui	s2,0x4fa5
    80000dec:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    80000df0:	0932                	slli	s2,s2,0xc
    80000df2:	fa590913          	addi	s2,s2,-91
    80000df6:	0932                	slli	s2,s2,0xc
    80000df8:	fa590913          	addi	s2,s2,-91
    80000dfc:	0932                	slli	s2,s2,0xc
    80000dfe:	fa590913          	addi	s2,s2,-91
    80000e02:	040009b7          	lui	s3,0x4000
    80000e06:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000e08:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e0a:	0000ea17          	auipc	s4,0xe
    80000e0e:	076a0a13          	addi	s4,s4,118 # 8000ee80 <tickslock>
      initlock(&p->lock, "proc");
    80000e12:	85da                	mv	a1,s6
    80000e14:	8526                	mv	a0,s1
    80000e16:	00005097          	auipc	ra,0x5
    80000e1a:	358080e7          	jalr	856(ra) # 8000616e <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000e1e:	415487b3          	sub	a5,s1,s5
    80000e22:	878d                	srai	a5,a5,0x3
    80000e24:	032787b3          	mul	a5,a5,s2
    80000e28:	2785                	addiw	a5,a5,1
    80000e2a:	00d7979b          	slliw	a5,a5,0xd
    80000e2e:	40f987b3          	sub	a5,s3,a5
    80000e32:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e34:	16848493          	addi	s1,s1,360
    80000e38:	fd449de3          	bne	s1,s4,80000e12 <procinit+0x80>
  }
}
    80000e3c:	70e2                	ld	ra,56(sp)
    80000e3e:	7442                	ld	s0,48(sp)
    80000e40:	74a2                	ld	s1,40(sp)
    80000e42:	7902                	ld	s2,32(sp)
    80000e44:	69e2                	ld	s3,24(sp)
    80000e46:	6a42                	ld	s4,16(sp)
    80000e48:	6aa2                	ld	s5,8(sp)
    80000e4a:	6b02                	ld	s6,0(sp)
    80000e4c:	6121                	addi	sp,sp,64
    80000e4e:	8082                	ret

0000000080000e50 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e50:	1141                	addi	sp,sp,-16
    80000e52:	e422                	sd	s0,8(sp)
    80000e54:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e56:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e58:	2501                	sext.w	a0,a0
    80000e5a:	6422                	ld	s0,8(sp)
    80000e5c:	0141                	addi	sp,sp,16
    80000e5e:	8082                	ret

0000000080000e60 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000e60:	1141                	addi	sp,sp,-16
    80000e62:	e422                	sd	s0,8(sp)
    80000e64:	0800                	addi	s0,sp,16
    80000e66:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e68:	2781                	sext.w	a5,a5
    80000e6a:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e6c:	00008517          	auipc	a0,0x8
    80000e70:	21450513          	addi	a0,a0,532 # 80009080 <cpus>
    80000e74:	953e                	add	a0,a0,a5
    80000e76:	6422                	ld	s0,8(sp)
    80000e78:	0141                	addi	sp,sp,16
    80000e7a:	8082                	ret

0000000080000e7c <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000e7c:	1101                	addi	sp,sp,-32
    80000e7e:	ec06                	sd	ra,24(sp)
    80000e80:	e822                	sd	s0,16(sp)
    80000e82:	e426                	sd	s1,8(sp)
    80000e84:	1000                	addi	s0,sp,32
  push_off();
    80000e86:	00005097          	auipc	ra,0x5
    80000e8a:	32c080e7          	jalr	812(ra) # 800061b2 <push_off>
    80000e8e:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000e90:	2781                	sext.w	a5,a5
    80000e92:	079e                	slli	a5,a5,0x7
    80000e94:	00008717          	auipc	a4,0x8
    80000e98:	1bc70713          	addi	a4,a4,444 # 80009050 <pid_lock>
    80000e9c:	97ba                	add	a5,a5,a4
    80000e9e:	7b84                	ld	s1,48(a5)
  pop_off();
    80000ea0:	00005097          	auipc	ra,0x5
    80000ea4:	3b2080e7          	jalr	946(ra) # 80006252 <pop_off>
  return p;
}
    80000ea8:	8526                	mv	a0,s1
    80000eaa:	60e2                	ld	ra,24(sp)
    80000eac:	6442                	ld	s0,16(sp)
    80000eae:	64a2                	ld	s1,8(sp)
    80000eb0:	6105                	addi	sp,sp,32
    80000eb2:	8082                	ret

0000000080000eb4 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000eb4:	1141                	addi	sp,sp,-16
    80000eb6:	e406                	sd	ra,8(sp)
    80000eb8:	e022                	sd	s0,0(sp)
    80000eba:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000ebc:	00000097          	auipc	ra,0x0
    80000ec0:	fc0080e7          	jalr	-64(ra) # 80000e7c <myproc>
    80000ec4:	00005097          	auipc	ra,0x5
    80000ec8:	3ee080e7          	jalr	1006(ra) # 800062b2 <release>

  if (first) {
    80000ecc:	00008797          	auipc	a5,0x8
    80000ed0:	9547a783          	lw	a5,-1708(a5) # 80008820 <first.1>
    80000ed4:	eb89                	bnez	a5,80000ee6 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000ed6:	00001097          	auipc	ra,0x1
    80000eda:	c16080e7          	jalr	-1002(ra) # 80001aec <usertrapret>
}
    80000ede:	60a2                	ld	ra,8(sp)
    80000ee0:	6402                	ld	s0,0(sp)
    80000ee2:	0141                	addi	sp,sp,16
    80000ee4:	8082                	ret
    first = 0;
    80000ee6:	00008797          	auipc	a5,0x8
    80000eea:	9207ad23          	sw	zero,-1734(a5) # 80008820 <first.1>
    fsinit(ROOTDEV);
    80000eee:	4505                	li	a0,1
    80000ef0:	00002097          	auipc	ra,0x2
    80000ef4:	952080e7          	jalr	-1710(ra) # 80002842 <fsinit>
    80000ef8:	bff9                	j	80000ed6 <forkret+0x22>

0000000080000efa <allocpid>:
allocpid() {
    80000efa:	1101                	addi	sp,sp,-32
    80000efc:	ec06                	sd	ra,24(sp)
    80000efe:	e822                	sd	s0,16(sp)
    80000f00:	e426                	sd	s1,8(sp)
    80000f02:	e04a                	sd	s2,0(sp)
    80000f04:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000f06:	00008917          	auipc	s2,0x8
    80000f0a:	14a90913          	addi	s2,s2,330 # 80009050 <pid_lock>
    80000f0e:	854a                	mv	a0,s2
    80000f10:	00005097          	auipc	ra,0x5
    80000f14:	2ee080e7          	jalr	750(ra) # 800061fe <acquire>
  pid = nextpid;
    80000f18:	00008797          	auipc	a5,0x8
    80000f1c:	90c78793          	addi	a5,a5,-1780 # 80008824 <nextpid>
    80000f20:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000f22:	0014871b          	addiw	a4,s1,1
    80000f26:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000f28:	854a                	mv	a0,s2
    80000f2a:	00005097          	auipc	ra,0x5
    80000f2e:	388080e7          	jalr	904(ra) # 800062b2 <release>
}
    80000f32:	8526                	mv	a0,s1
    80000f34:	60e2                	ld	ra,24(sp)
    80000f36:	6442                	ld	s0,16(sp)
    80000f38:	64a2                	ld	s1,8(sp)
    80000f3a:	6902                	ld	s2,0(sp)
    80000f3c:	6105                	addi	sp,sp,32
    80000f3e:	8082                	ret

0000000080000f40 <proc_pagetable>:
{
    80000f40:	1101                	addi	sp,sp,-32
    80000f42:	ec06                	sd	ra,24(sp)
    80000f44:	e822                	sd	s0,16(sp)
    80000f46:	e426                	sd	s1,8(sp)
    80000f48:	e04a                	sd	s2,0(sp)
    80000f4a:	1000                	addi	s0,sp,32
    80000f4c:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f4e:	00000097          	auipc	ra,0x0
    80000f52:	886080e7          	jalr	-1914(ra) # 800007d4 <uvmcreate>
    80000f56:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f58:	c121                	beqz	a0,80000f98 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f5a:	4729                	li	a4,10
    80000f5c:	00006697          	auipc	a3,0x6
    80000f60:	0a468693          	addi	a3,a3,164 # 80007000 <_trampoline>
    80000f64:	6605                	lui	a2,0x1
    80000f66:	040005b7          	lui	a1,0x4000
    80000f6a:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f6c:	05b2                	slli	a1,a1,0xc
    80000f6e:	fffff097          	auipc	ra,0xfffff
    80000f72:	5cc080e7          	jalr	1484(ra) # 8000053a <mappages>
    80000f76:	02054863          	bltz	a0,80000fa6 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f7a:	4719                	li	a4,6
    80000f7c:	05893683          	ld	a3,88(s2)
    80000f80:	6605                	lui	a2,0x1
    80000f82:	020005b7          	lui	a1,0x2000
    80000f86:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000f88:	05b6                	slli	a1,a1,0xd
    80000f8a:	8526                	mv	a0,s1
    80000f8c:	fffff097          	auipc	ra,0xfffff
    80000f90:	5ae080e7          	jalr	1454(ra) # 8000053a <mappages>
    80000f94:	02054163          	bltz	a0,80000fb6 <proc_pagetable+0x76>
}
    80000f98:	8526                	mv	a0,s1
    80000f9a:	60e2                	ld	ra,24(sp)
    80000f9c:	6442                	ld	s0,16(sp)
    80000f9e:	64a2                	ld	s1,8(sp)
    80000fa0:	6902                	ld	s2,0(sp)
    80000fa2:	6105                	addi	sp,sp,32
    80000fa4:	8082                	ret
    uvmfree(pagetable, 0);
    80000fa6:	4581                	li	a1,0
    80000fa8:	8526                	mv	a0,s1
    80000faa:	00000097          	auipc	ra,0x0
    80000fae:	a30080e7          	jalr	-1488(ra) # 800009da <uvmfree>
    return 0;
    80000fb2:	4481                	li	s1,0
    80000fb4:	b7d5                	j	80000f98 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fb6:	4681                	li	a3,0
    80000fb8:	4605                	li	a2,1
    80000fba:	040005b7          	lui	a1,0x4000
    80000fbe:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000fc0:	05b2                	slli	a1,a1,0xc
    80000fc2:	8526                	mv	a0,s1
    80000fc4:	fffff097          	auipc	ra,0xfffff
    80000fc8:	73c080e7          	jalr	1852(ra) # 80000700 <uvmunmap>
    uvmfree(pagetable, 0);
    80000fcc:	4581                	li	a1,0
    80000fce:	8526                	mv	a0,s1
    80000fd0:	00000097          	auipc	ra,0x0
    80000fd4:	a0a080e7          	jalr	-1526(ra) # 800009da <uvmfree>
    return 0;
    80000fd8:	4481                	li	s1,0
    80000fda:	bf7d                	j	80000f98 <proc_pagetable+0x58>

0000000080000fdc <proc_freepagetable>:
{
    80000fdc:	1101                	addi	sp,sp,-32
    80000fde:	ec06                	sd	ra,24(sp)
    80000fe0:	e822                	sd	s0,16(sp)
    80000fe2:	e426                	sd	s1,8(sp)
    80000fe4:	e04a                	sd	s2,0(sp)
    80000fe6:	1000                	addi	s0,sp,32
    80000fe8:	84aa                	mv	s1,a0
    80000fea:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fec:	4681                	li	a3,0
    80000fee:	4605                	li	a2,1
    80000ff0:	040005b7          	lui	a1,0x4000
    80000ff4:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000ff6:	05b2                	slli	a1,a1,0xc
    80000ff8:	fffff097          	auipc	ra,0xfffff
    80000ffc:	708080e7          	jalr	1800(ra) # 80000700 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001000:	4681                	li	a3,0
    80001002:	4605                	li	a2,1
    80001004:	020005b7          	lui	a1,0x2000
    80001008:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    8000100a:	05b6                	slli	a1,a1,0xd
    8000100c:	8526                	mv	a0,s1
    8000100e:	fffff097          	auipc	ra,0xfffff
    80001012:	6f2080e7          	jalr	1778(ra) # 80000700 <uvmunmap>
  uvmfree(pagetable, sz);
    80001016:	85ca                	mv	a1,s2
    80001018:	8526                	mv	a0,s1
    8000101a:	00000097          	auipc	ra,0x0
    8000101e:	9c0080e7          	jalr	-1600(ra) # 800009da <uvmfree>
}
    80001022:	60e2                	ld	ra,24(sp)
    80001024:	6442                	ld	s0,16(sp)
    80001026:	64a2                	ld	s1,8(sp)
    80001028:	6902                	ld	s2,0(sp)
    8000102a:	6105                	addi	sp,sp,32
    8000102c:	8082                	ret

000000008000102e <freeproc>:
{
    8000102e:	1101                	addi	sp,sp,-32
    80001030:	ec06                	sd	ra,24(sp)
    80001032:	e822                	sd	s0,16(sp)
    80001034:	e426                	sd	s1,8(sp)
    80001036:	1000                	addi	s0,sp,32
    80001038:	84aa                	mv	s1,a0
  if(p->trapframe)
    8000103a:	6d28                	ld	a0,88(a0)
    8000103c:	c509                	beqz	a0,80001046 <freeproc+0x18>
    kfree((void*)p->trapframe);
    8000103e:	fffff097          	auipc	ra,0xfffff
    80001042:	fde080e7          	jalr	-34(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001046:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    8000104a:	68a8                	ld	a0,80(s1)
    8000104c:	c511                	beqz	a0,80001058 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    8000104e:	64ac                	ld	a1,72(s1)
    80001050:	00000097          	auipc	ra,0x0
    80001054:	f8c080e7          	jalr	-116(ra) # 80000fdc <proc_freepagetable>
  p->pagetable = 0;
    80001058:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    8000105c:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001060:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001064:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001068:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    8000106c:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001070:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001074:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001078:	0004ac23          	sw	zero,24(s1)
}
    8000107c:	60e2                	ld	ra,24(sp)
    8000107e:	6442                	ld	s0,16(sp)
    80001080:	64a2                	ld	s1,8(sp)
    80001082:	6105                	addi	sp,sp,32
    80001084:	8082                	ret

0000000080001086 <allocproc>:
{
    80001086:	1101                	addi	sp,sp,-32
    80001088:	ec06                	sd	ra,24(sp)
    8000108a:	e822                	sd	s0,16(sp)
    8000108c:	e426                	sd	s1,8(sp)
    8000108e:	e04a                	sd	s2,0(sp)
    80001090:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001092:	00008497          	auipc	s1,0x8
    80001096:	3ee48493          	addi	s1,s1,1006 # 80009480 <proc>
    8000109a:	0000e917          	auipc	s2,0xe
    8000109e:	de690913          	addi	s2,s2,-538 # 8000ee80 <tickslock>
    acquire(&p->lock);
    800010a2:	8526                	mv	a0,s1
    800010a4:	00005097          	auipc	ra,0x5
    800010a8:	15a080e7          	jalr	346(ra) # 800061fe <acquire>
    if(p->state == UNUSED) {
    800010ac:	4c9c                	lw	a5,24(s1)
    800010ae:	cf81                	beqz	a5,800010c6 <allocproc+0x40>
      release(&p->lock);
    800010b0:	8526                	mv	a0,s1
    800010b2:	00005097          	auipc	ra,0x5
    800010b6:	200080e7          	jalr	512(ra) # 800062b2 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800010ba:	16848493          	addi	s1,s1,360
    800010be:	ff2492e3          	bne	s1,s2,800010a2 <allocproc+0x1c>
  return 0;
    800010c2:	4481                	li	s1,0
    800010c4:	a889                	j	80001116 <allocproc+0x90>
  p->pid = allocpid();
    800010c6:	00000097          	auipc	ra,0x0
    800010ca:	e34080e7          	jalr	-460(ra) # 80000efa <allocpid>
    800010ce:	d888                	sw	a0,48(s1)
  p->state = USED;
    800010d0:	4785                	li	a5,1
    800010d2:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800010d4:	fffff097          	auipc	ra,0xfffff
    800010d8:	046080e7          	jalr	70(ra) # 8000011a <kalloc>
    800010dc:	892a                	mv	s2,a0
    800010de:	eca8                	sd	a0,88(s1)
    800010e0:	c131                	beqz	a0,80001124 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800010e2:	8526                	mv	a0,s1
    800010e4:	00000097          	auipc	ra,0x0
    800010e8:	e5c080e7          	jalr	-420(ra) # 80000f40 <proc_pagetable>
    800010ec:	892a                	mv	s2,a0
    800010ee:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800010f0:	c531                	beqz	a0,8000113c <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    800010f2:	07000613          	li	a2,112
    800010f6:	4581                	li	a1,0
    800010f8:	06048513          	addi	a0,s1,96
    800010fc:	fffff097          	auipc	ra,0xfffff
    80001100:	07e080e7          	jalr	126(ra) # 8000017a <memset>
  p->context.ra = (uint64)forkret;
    80001104:	00000797          	auipc	a5,0x0
    80001108:	db078793          	addi	a5,a5,-592 # 80000eb4 <forkret>
    8000110c:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    8000110e:	60bc                	ld	a5,64(s1)
    80001110:	6705                	lui	a4,0x1
    80001112:	97ba                	add	a5,a5,a4
    80001114:	f4bc                	sd	a5,104(s1)
}
    80001116:	8526                	mv	a0,s1
    80001118:	60e2                	ld	ra,24(sp)
    8000111a:	6442                	ld	s0,16(sp)
    8000111c:	64a2                	ld	s1,8(sp)
    8000111e:	6902                	ld	s2,0(sp)
    80001120:	6105                	addi	sp,sp,32
    80001122:	8082                	ret
    freeproc(p);
    80001124:	8526                	mv	a0,s1
    80001126:	00000097          	auipc	ra,0x0
    8000112a:	f08080e7          	jalr	-248(ra) # 8000102e <freeproc>
    release(&p->lock);
    8000112e:	8526                	mv	a0,s1
    80001130:	00005097          	auipc	ra,0x5
    80001134:	182080e7          	jalr	386(ra) # 800062b2 <release>
    return 0;
    80001138:	84ca                	mv	s1,s2
    8000113a:	bff1                	j	80001116 <allocproc+0x90>
    freeproc(p);
    8000113c:	8526                	mv	a0,s1
    8000113e:	00000097          	auipc	ra,0x0
    80001142:	ef0080e7          	jalr	-272(ra) # 8000102e <freeproc>
    release(&p->lock);
    80001146:	8526                	mv	a0,s1
    80001148:	00005097          	auipc	ra,0x5
    8000114c:	16a080e7          	jalr	362(ra) # 800062b2 <release>
    return 0;
    80001150:	84ca                	mv	s1,s2
    80001152:	b7d1                	j	80001116 <allocproc+0x90>

0000000080001154 <userinit>:
{
    80001154:	1101                	addi	sp,sp,-32
    80001156:	ec06                	sd	ra,24(sp)
    80001158:	e822                	sd	s0,16(sp)
    8000115a:	e426                	sd	s1,8(sp)
    8000115c:	1000                	addi	s0,sp,32
  p = allocproc();
    8000115e:	00000097          	auipc	ra,0x0
    80001162:	f28080e7          	jalr	-216(ra) # 80001086 <allocproc>
    80001166:	84aa                	mv	s1,a0
  initproc = p;
    80001168:	00008797          	auipc	a5,0x8
    8000116c:	eaa7b423          	sd	a0,-344(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001170:	03400613          	li	a2,52
    80001174:	00007597          	auipc	a1,0x7
    80001178:	6bc58593          	addi	a1,a1,1724 # 80008830 <initcode>
    8000117c:	6928                	ld	a0,80(a0)
    8000117e:	fffff097          	auipc	ra,0xfffff
    80001182:	684080e7          	jalr	1668(ra) # 80000802 <uvminit>
  p->sz = PGSIZE;
    80001186:	6785                	lui	a5,0x1
    80001188:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    8000118a:	6cb8                	ld	a4,88(s1)
    8000118c:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001190:	6cb8                	ld	a4,88(s1)
    80001192:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001194:	4641                	li	a2,16
    80001196:	00007597          	auipc	a1,0x7
    8000119a:	fea58593          	addi	a1,a1,-22 # 80008180 <etext+0x180>
    8000119e:	15848513          	addi	a0,s1,344
    800011a2:	fffff097          	auipc	ra,0xfffff
    800011a6:	11a080e7          	jalr	282(ra) # 800002bc <safestrcpy>
  p->cwd = namei("/");
    800011aa:	00007517          	auipc	a0,0x7
    800011ae:	fe650513          	addi	a0,a0,-26 # 80008190 <etext+0x190>
    800011b2:	00002097          	auipc	ra,0x2
    800011b6:	0d6080e7          	jalr	214(ra) # 80003288 <namei>
    800011ba:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800011be:	478d                	li	a5,3
    800011c0:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800011c2:	8526                	mv	a0,s1
    800011c4:	00005097          	auipc	ra,0x5
    800011c8:	0ee080e7          	jalr	238(ra) # 800062b2 <release>
}
    800011cc:	60e2                	ld	ra,24(sp)
    800011ce:	6442                	ld	s0,16(sp)
    800011d0:	64a2                	ld	s1,8(sp)
    800011d2:	6105                	addi	sp,sp,32
    800011d4:	8082                	ret

00000000800011d6 <growproc>:
{
    800011d6:	1101                	addi	sp,sp,-32
    800011d8:	ec06                	sd	ra,24(sp)
    800011da:	e822                	sd	s0,16(sp)
    800011dc:	e426                	sd	s1,8(sp)
    800011de:	e04a                	sd	s2,0(sp)
    800011e0:	1000                	addi	s0,sp,32
    800011e2:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800011e4:	00000097          	auipc	ra,0x0
    800011e8:	c98080e7          	jalr	-872(ra) # 80000e7c <myproc>
    800011ec:	892a                	mv	s2,a0
  sz = p->sz;
    800011ee:	652c                	ld	a1,72(a0)
    800011f0:	0005879b          	sext.w	a5,a1
  if(n > 0){
    800011f4:	00904f63          	bgtz	s1,80001212 <growproc+0x3c>
  } else if(n < 0){
    800011f8:	0204cd63          	bltz	s1,80001232 <growproc+0x5c>
  p->sz = sz;
    800011fc:	1782                	slli	a5,a5,0x20
    800011fe:	9381                	srli	a5,a5,0x20
    80001200:	04f93423          	sd	a5,72(s2)
  return 0;
    80001204:	4501                	li	a0,0
}
    80001206:	60e2                	ld	ra,24(sp)
    80001208:	6442                	ld	s0,16(sp)
    8000120a:	64a2                	ld	s1,8(sp)
    8000120c:	6902                	ld	s2,0(sp)
    8000120e:	6105                	addi	sp,sp,32
    80001210:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001212:	00f4863b          	addw	a2,s1,a5
    80001216:	1602                	slli	a2,a2,0x20
    80001218:	9201                	srli	a2,a2,0x20
    8000121a:	1582                	slli	a1,a1,0x20
    8000121c:	9181                	srli	a1,a1,0x20
    8000121e:	6928                	ld	a0,80(a0)
    80001220:	fffff097          	auipc	ra,0xfffff
    80001224:	69c080e7          	jalr	1692(ra) # 800008bc <uvmalloc>
    80001228:	0005079b          	sext.w	a5,a0
    8000122c:	fbe1                	bnez	a5,800011fc <growproc+0x26>
      return -1;
    8000122e:	557d                	li	a0,-1
    80001230:	bfd9                	j	80001206 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001232:	00f4863b          	addw	a2,s1,a5
    80001236:	1602                	slli	a2,a2,0x20
    80001238:	9201                	srli	a2,a2,0x20
    8000123a:	1582                	slli	a1,a1,0x20
    8000123c:	9181                	srli	a1,a1,0x20
    8000123e:	6928                	ld	a0,80(a0)
    80001240:	fffff097          	auipc	ra,0xfffff
    80001244:	634080e7          	jalr	1588(ra) # 80000874 <uvmdealloc>
    80001248:	0005079b          	sext.w	a5,a0
    8000124c:	bf45                	j	800011fc <growproc+0x26>

000000008000124e <fork>:
{
    8000124e:	7139                	addi	sp,sp,-64
    80001250:	fc06                	sd	ra,56(sp)
    80001252:	f822                	sd	s0,48(sp)
    80001254:	f04a                	sd	s2,32(sp)
    80001256:	e456                	sd	s5,8(sp)
    80001258:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    8000125a:	00000097          	auipc	ra,0x0
    8000125e:	c22080e7          	jalr	-990(ra) # 80000e7c <myproc>
    80001262:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001264:	00000097          	auipc	ra,0x0
    80001268:	e22080e7          	jalr	-478(ra) # 80001086 <allocproc>
    8000126c:	12050063          	beqz	a0,8000138c <fork+0x13e>
    80001270:	e852                	sd	s4,16(sp)
    80001272:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001274:	048ab603          	ld	a2,72(s5)
    80001278:	692c                	ld	a1,80(a0)
    8000127a:	050ab503          	ld	a0,80(s5)
    8000127e:	fffff097          	auipc	ra,0xfffff
    80001282:	796080e7          	jalr	1942(ra) # 80000a14 <uvmcopy>
    80001286:	04054a63          	bltz	a0,800012da <fork+0x8c>
    8000128a:	f426                	sd	s1,40(sp)
    8000128c:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    8000128e:	048ab783          	ld	a5,72(s5)
    80001292:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001296:	058ab683          	ld	a3,88(s5)
    8000129a:	87b6                	mv	a5,a3
    8000129c:	058a3703          	ld	a4,88(s4)
    800012a0:	12068693          	addi	a3,a3,288
    800012a4:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800012a8:	6788                	ld	a0,8(a5)
    800012aa:	6b8c                	ld	a1,16(a5)
    800012ac:	6f90                	ld	a2,24(a5)
    800012ae:	01073023          	sd	a6,0(a4)
    800012b2:	e708                	sd	a0,8(a4)
    800012b4:	eb0c                	sd	a1,16(a4)
    800012b6:	ef10                	sd	a2,24(a4)
    800012b8:	02078793          	addi	a5,a5,32
    800012bc:	02070713          	addi	a4,a4,32
    800012c0:	fed792e3          	bne	a5,a3,800012a4 <fork+0x56>
  np->trapframe->a0 = 0;
    800012c4:	058a3783          	ld	a5,88(s4)
    800012c8:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800012cc:	0d0a8493          	addi	s1,s5,208
    800012d0:	0d0a0913          	addi	s2,s4,208
    800012d4:	150a8993          	addi	s3,s5,336
    800012d8:	a015                	j	800012fc <fork+0xae>
    freeproc(np);
    800012da:	8552                	mv	a0,s4
    800012dc:	00000097          	auipc	ra,0x0
    800012e0:	d52080e7          	jalr	-686(ra) # 8000102e <freeproc>
    release(&np->lock);
    800012e4:	8552                	mv	a0,s4
    800012e6:	00005097          	auipc	ra,0x5
    800012ea:	fcc080e7          	jalr	-52(ra) # 800062b2 <release>
    return -1;
    800012ee:	597d                	li	s2,-1
    800012f0:	6a42                	ld	s4,16(sp)
    800012f2:	a071                	j	8000137e <fork+0x130>
  for(i = 0; i < NOFILE; i++)
    800012f4:	04a1                	addi	s1,s1,8
    800012f6:	0921                	addi	s2,s2,8
    800012f8:	01348b63          	beq	s1,s3,8000130e <fork+0xc0>
    if(p->ofile[i])
    800012fc:	6088                	ld	a0,0(s1)
    800012fe:	d97d                	beqz	a0,800012f4 <fork+0xa6>
      np->ofile[i] = filedup(p->ofile[i]);
    80001300:	00002097          	auipc	ra,0x2
    80001304:	600080e7          	jalr	1536(ra) # 80003900 <filedup>
    80001308:	00a93023          	sd	a0,0(s2)
    8000130c:	b7e5                	j	800012f4 <fork+0xa6>
  np->cwd = idup(p->cwd);
    8000130e:	150ab503          	ld	a0,336(s5)
    80001312:	00001097          	auipc	ra,0x1
    80001316:	766080e7          	jalr	1894(ra) # 80002a78 <idup>
    8000131a:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    8000131e:	4641                	li	a2,16
    80001320:	158a8593          	addi	a1,s5,344
    80001324:	158a0513          	addi	a0,s4,344
    80001328:	fffff097          	auipc	ra,0xfffff
    8000132c:	f94080e7          	jalr	-108(ra) # 800002bc <safestrcpy>
  pid = np->pid;
    80001330:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001334:	8552                	mv	a0,s4
    80001336:	00005097          	auipc	ra,0x5
    8000133a:	f7c080e7          	jalr	-132(ra) # 800062b2 <release>
  acquire(&wait_lock);
    8000133e:	00008497          	auipc	s1,0x8
    80001342:	d2a48493          	addi	s1,s1,-726 # 80009068 <wait_lock>
    80001346:	8526                	mv	a0,s1
    80001348:	00005097          	auipc	ra,0x5
    8000134c:	eb6080e7          	jalr	-330(ra) # 800061fe <acquire>
  np->parent = p;
    80001350:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001354:	8526                	mv	a0,s1
    80001356:	00005097          	auipc	ra,0x5
    8000135a:	f5c080e7          	jalr	-164(ra) # 800062b2 <release>
  acquire(&np->lock);
    8000135e:	8552                	mv	a0,s4
    80001360:	00005097          	auipc	ra,0x5
    80001364:	e9e080e7          	jalr	-354(ra) # 800061fe <acquire>
  np->state = RUNNABLE;
    80001368:	478d                	li	a5,3
    8000136a:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    8000136e:	8552                	mv	a0,s4
    80001370:	00005097          	auipc	ra,0x5
    80001374:	f42080e7          	jalr	-190(ra) # 800062b2 <release>
  return pid;
    80001378:	74a2                	ld	s1,40(sp)
    8000137a:	69e2                	ld	s3,24(sp)
    8000137c:	6a42                	ld	s4,16(sp)
}
    8000137e:	854a                	mv	a0,s2
    80001380:	70e2                	ld	ra,56(sp)
    80001382:	7442                	ld	s0,48(sp)
    80001384:	7902                	ld	s2,32(sp)
    80001386:	6aa2                	ld	s5,8(sp)
    80001388:	6121                	addi	sp,sp,64
    8000138a:	8082                	ret
    return -1;
    8000138c:	597d                	li	s2,-1
    8000138e:	bfc5                	j	8000137e <fork+0x130>

0000000080001390 <scheduler>:
{
    80001390:	7139                	addi	sp,sp,-64
    80001392:	fc06                	sd	ra,56(sp)
    80001394:	f822                	sd	s0,48(sp)
    80001396:	f426                	sd	s1,40(sp)
    80001398:	f04a                	sd	s2,32(sp)
    8000139a:	ec4e                	sd	s3,24(sp)
    8000139c:	e852                	sd	s4,16(sp)
    8000139e:	e456                	sd	s5,8(sp)
    800013a0:	e05a                	sd	s6,0(sp)
    800013a2:	0080                	addi	s0,sp,64
    800013a4:	8792                	mv	a5,tp
  int id = r_tp();
    800013a6:	2781                	sext.w	a5,a5
  c->proc = 0;
    800013a8:	00779a93          	slli	s5,a5,0x7
    800013ac:	00008717          	auipc	a4,0x8
    800013b0:	ca470713          	addi	a4,a4,-860 # 80009050 <pid_lock>
    800013b4:	9756                	add	a4,a4,s5
    800013b6:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800013ba:	00008717          	auipc	a4,0x8
    800013be:	cce70713          	addi	a4,a4,-818 # 80009088 <cpus+0x8>
    800013c2:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800013c4:	498d                	li	s3,3
        p->state = RUNNING;
    800013c6:	4b11                	li	s6,4
        c->proc = p;
    800013c8:	079e                	slli	a5,a5,0x7
    800013ca:	00008a17          	auipc	s4,0x8
    800013ce:	c86a0a13          	addi	s4,s4,-890 # 80009050 <pid_lock>
    800013d2:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800013d4:	0000e917          	auipc	s2,0xe
    800013d8:	aac90913          	addi	s2,s2,-1364 # 8000ee80 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800013dc:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800013e0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800013e4:	10079073          	csrw	sstatus,a5
    800013e8:	00008497          	auipc	s1,0x8
    800013ec:	09848493          	addi	s1,s1,152 # 80009480 <proc>
    800013f0:	a811                	j	80001404 <scheduler+0x74>
      release(&p->lock);
    800013f2:	8526                	mv	a0,s1
    800013f4:	00005097          	auipc	ra,0x5
    800013f8:	ebe080e7          	jalr	-322(ra) # 800062b2 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800013fc:	16848493          	addi	s1,s1,360
    80001400:	fd248ee3          	beq	s1,s2,800013dc <scheduler+0x4c>
      acquire(&p->lock);
    80001404:	8526                	mv	a0,s1
    80001406:	00005097          	auipc	ra,0x5
    8000140a:	df8080e7          	jalr	-520(ra) # 800061fe <acquire>
      if(p->state == RUNNABLE) {
    8000140e:	4c9c                	lw	a5,24(s1)
    80001410:	ff3791e3          	bne	a5,s3,800013f2 <scheduler+0x62>
        p->state = RUNNING;
    80001414:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001418:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    8000141c:	06048593          	addi	a1,s1,96
    80001420:	8556                	mv	a0,s5
    80001422:	00000097          	auipc	ra,0x0
    80001426:	620080e7          	jalr	1568(ra) # 80001a42 <swtch>
        c->proc = 0;
    8000142a:	020a3823          	sd	zero,48(s4)
    8000142e:	b7d1                	j	800013f2 <scheduler+0x62>

0000000080001430 <sched>:
{
    80001430:	7179                	addi	sp,sp,-48
    80001432:	f406                	sd	ra,40(sp)
    80001434:	f022                	sd	s0,32(sp)
    80001436:	ec26                	sd	s1,24(sp)
    80001438:	e84a                	sd	s2,16(sp)
    8000143a:	e44e                	sd	s3,8(sp)
    8000143c:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000143e:	00000097          	auipc	ra,0x0
    80001442:	a3e080e7          	jalr	-1474(ra) # 80000e7c <myproc>
    80001446:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001448:	00005097          	auipc	ra,0x5
    8000144c:	d3c080e7          	jalr	-708(ra) # 80006184 <holding>
    80001450:	c93d                	beqz	a0,800014c6 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001452:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001454:	2781                	sext.w	a5,a5
    80001456:	079e                	slli	a5,a5,0x7
    80001458:	00008717          	auipc	a4,0x8
    8000145c:	bf870713          	addi	a4,a4,-1032 # 80009050 <pid_lock>
    80001460:	97ba                	add	a5,a5,a4
    80001462:	0a87a703          	lw	a4,168(a5)
    80001466:	4785                	li	a5,1
    80001468:	06f71763          	bne	a4,a5,800014d6 <sched+0xa6>
  if(p->state == RUNNING)
    8000146c:	4c98                	lw	a4,24(s1)
    8000146e:	4791                	li	a5,4
    80001470:	06f70b63          	beq	a4,a5,800014e6 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001474:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001478:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000147a:	efb5                	bnez	a5,800014f6 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000147c:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000147e:	00008917          	auipc	s2,0x8
    80001482:	bd290913          	addi	s2,s2,-1070 # 80009050 <pid_lock>
    80001486:	2781                	sext.w	a5,a5
    80001488:	079e                	slli	a5,a5,0x7
    8000148a:	97ca                	add	a5,a5,s2
    8000148c:	0ac7a983          	lw	s3,172(a5)
    80001490:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001492:	2781                	sext.w	a5,a5
    80001494:	079e                	slli	a5,a5,0x7
    80001496:	00008597          	auipc	a1,0x8
    8000149a:	bf258593          	addi	a1,a1,-1038 # 80009088 <cpus+0x8>
    8000149e:	95be                	add	a1,a1,a5
    800014a0:	06048513          	addi	a0,s1,96
    800014a4:	00000097          	auipc	ra,0x0
    800014a8:	59e080e7          	jalr	1438(ra) # 80001a42 <swtch>
    800014ac:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800014ae:	2781                	sext.w	a5,a5
    800014b0:	079e                	slli	a5,a5,0x7
    800014b2:	993e                	add	s2,s2,a5
    800014b4:	0b392623          	sw	s3,172(s2)
}
    800014b8:	70a2                	ld	ra,40(sp)
    800014ba:	7402                	ld	s0,32(sp)
    800014bc:	64e2                	ld	s1,24(sp)
    800014be:	6942                	ld	s2,16(sp)
    800014c0:	69a2                	ld	s3,8(sp)
    800014c2:	6145                	addi	sp,sp,48
    800014c4:	8082                	ret
    panic("sched p->lock");
    800014c6:	00007517          	auipc	a0,0x7
    800014ca:	cd250513          	addi	a0,a0,-814 # 80008198 <etext+0x198>
    800014ce:	00004097          	auipc	ra,0x4
    800014d2:	7e0080e7          	jalr	2016(ra) # 80005cae <panic>
    panic("sched locks");
    800014d6:	00007517          	auipc	a0,0x7
    800014da:	cd250513          	addi	a0,a0,-814 # 800081a8 <etext+0x1a8>
    800014de:	00004097          	auipc	ra,0x4
    800014e2:	7d0080e7          	jalr	2000(ra) # 80005cae <panic>
    panic("sched running");
    800014e6:	00007517          	auipc	a0,0x7
    800014ea:	cd250513          	addi	a0,a0,-814 # 800081b8 <etext+0x1b8>
    800014ee:	00004097          	auipc	ra,0x4
    800014f2:	7c0080e7          	jalr	1984(ra) # 80005cae <panic>
    panic("sched interruptible");
    800014f6:	00007517          	auipc	a0,0x7
    800014fa:	cd250513          	addi	a0,a0,-814 # 800081c8 <etext+0x1c8>
    800014fe:	00004097          	auipc	ra,0x4
    80001502:	7b0080e7          	jalr	1968(ra) # 80005cae <panic>

0000000080001506 <yield>:
{
    80001506:	1101                	addi	sp,sp,-32
    80001508:	ec06                	sd	ra,24(sp)
    8000150a:	e822                	sd	s0,16(sp)
    8000150c:	e426                	sd	s1,8(sp)
    8000150e:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001510:	00000097          	auipc	ra,0x0
    80001514:	96c080e7          	jalr	-1684(ra) # 80000e7c <myproc>
    80001518:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000151a:	00005097          	auipc	ra,0x5
    8000151e:	ce4080e7          	jalr	-796(ra) # 800061fe <acquire>
  p->state = RUNNABLE;
    80001522:	478d                	li	a5,3
    80001524:	cc9c                	sw	a5,24(s1)
  sched();
    80001526:	00000097          	auipc	ra,0x0
    8000152a:	f0a080e7          	jalr	-246(ra) # 80001430 <sched>
  release(&p->lock);
    8000152e:	8526                	mv	a0,s1
    80001530:	00005097          	auipc	ra,0x5
    80001534:	d82080e7          	jalr	-638(ra) # 800062b2 <release>
}
    80001538:	60e2                	ld	ra,24(sp)
    8000153a:	6442                	ld	s0,16(sp)
    8000153c:	64a2                	ld	s1,8(sp)
    8000153e:	6105                	addi	sp,sp,32
    80001540:	8082                	ret

0000000080001542 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001542:	7179                	addi	sp,sp,-48
    80001544:	f406                	sd	ra,40(sp)
    80001546:	f022                	sd	s0,32(sp)
    80001548:	ec26                	sd	s1,24(sp)
    8000154a:	e84a                	sd	s2,16(sp)
    8000154c:	e44e                	sd	s3,8(sp)
    8000154e:	1800                	addi	s0,sp,48
    80001550:	89aa                	mv	s3,a0
    80001552:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001554:	00000097          	auipc	ra,0x0
    80001558:	928080e7          	jalr	-1752(ra) # 80000e7c <myproc>
    8000155c:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    8000155e:	00005097          	auipc	ra,0x5
    80001562:	ca0080e7          	jalr	-864(ra) # 800061fe <acquire>
  release(lk);
    80001566:	854a                	mv	a0,s2
    80001568:	00005097          	auipc	ra,0x5
    8000156c:	d4a080e7          	jalr	-694(ra) # 800062b2 <release>

  // Go to sleep.
  p->chan = chan;
    80001570:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001574:	4789                	li	a5,2
    80001576:	cc9c                	sw	a5,24(s1)

  sched();
    80001578:	00000097          	auipc	ra,0x0
    8000157c:	eb8080e7          	jalr	-328(ra) # 80001430 <sched>

  // Tidy up.
  p->chan = 0;
    80001580:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001584:	8526                	mv	a0,s1
    80001586:	00005097          	auipc	ra,0x5
    8000158a:	d2c080e7          	jalr	-724(ra) # 800062b2 <release>
  acquire(lk);
    8000158e:	854a                	mv	a0,s2
    80001590:	00005097          	auipc	ra,0x5
    80001594:	c6e080e7          	jalr	-914(ra) # 800061fe <acquire>
}
    80001598:	70a2                	ld	ra,40(sp)
    8000159a:	7402                	ld	s0,32(sp)
    8000159c:	64e2                	ld	s1,24(sp)
    8000159e:	6942                	ld	s2,16(sp)
    800015a0:	69a2                	ld	s3,8(sp)
    800015a2:	6145                	addi	sp,sp,48
    800015a4:	8082                	ret

00000000800015a6 <wait>:
{
    800015a6:	715d                	addi	sp,sp,-80
    800015a8:	e486                	sd	ra,72(sp)
    800015aa:	e0a2                	sd	s0,64(sp)
    800015ac:	fc26                	sd	s1,56(sp)
    800015ae:	f84a                	sd	s2,48(sp)
    800015b0:	f44e                	sd	s3,40(sp)
    800015b2:	f052                	sd	s4,32(sp)
    800015b4:	ec56                	sd	s5,24(sp)
    800015b6:	e85a                	sd	s6,16(sp)
    800015b8:	e45e                	sd	s7,8(sp)
    800015ba:	e062                	sd	s8,0(sp)
    800015bc:	0880                	addi	s0,sp,80
    800015be:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800015c0:	00000097          	auipc	ra,0x0
    800015c4:	8bc080e7          	jalr	-1860(ra) # 80000e7c <myproc>
    800015c8:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800015ca:	00008517          	auipc	a0,0x8
    800015ce:	a9e50513          	addi	a0,a0,-1378 # 80009068 <wait_lock>
    800015d2:	00005097          	auipc	ra,0x5
    800015d6:	c2c080e7          	jalr	-980(ra) # 800061fe <acquire>
    havekids = 0;
    800015da:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    800015dc:	4a15                	li	s4,5
        havekids = 1;
    800015de:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    800015e0:	0000e997          	auipc	s3,0xe
    800015e4:	8a098993          	addi	s3,s3,-1888 # 8000ee80 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800015e8:	00008c17          	auipc	s8,0x8
    800015ec:	a80c0c13          	addi	s8,s8,-1408 # 80009068 <wait_lock>
    800015f0:	a87d                	j	800016ae <wait+0x108>
          pid = np->pid;
    800015f2:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    800015f6:	000b0e63          	beqz	s6,80001612 <wait+0x6c>
    800015fa:	4691                	li	a3,4
    800015fc:	02c48613          	addi	a2,s1,44
    80001600:	85da                	mv	a1,s6
    80001602:	05093503          	ld	a0,80(s2)
    80001606:	fffff097          	auipc	ra,0xfffff
    8000160a:	512080e7          	jalr	1298(ra) # 80000b18 <copyout>
    8000160e:	04054163          	bltz	a0,80001650 <wait+0xaa>
          freeproc(np);
    80001612:	8526                	mv	a0,s1
    80001614:	00000097          	auipc	ra,0x0
    80001618:	a1a080e7          	jalr	-1510(ra) # 8000102e <freeproc>
          release(&np->lock);
    8000161c:	8526                	mv	a0,s1
    8000161e:	00005097          	auipc	ra,0x5
    80001622:	c94080e7          	jalr	-876(ra) # 800062b2 <release>
          release(&wait_lock);
    80001626:	00008517          	auipc	a0,0x8
    8000162a:	a4250513          	addi	a0,a0,-1470 # 80009068 <wait_lock>
    8000162e:	00005097          	auipc	ra,0x5
    80001632:	c84080e7          	jalr	-892(ra) # 800062b2 <release>
}
    80001636:	854e                	mv	a0,s3
    80001638:	60a6                	ld	ra,72(sp)
    8000163a:	6406                	ld	s0,64(sp)
    8000163c:	74e2                	ld	s1,56(sp)
    8000163e:	7942                	ld	s2,48(sp)
    80001640:	79a2                	ld	s3,40(sp)
    80001642:	7a02                	ld	s4,32(sp)
    80001644:	6ae2                	ld	s5,24(sp)
    80001646:	6b42                	ld	s6,16(sp)
    80001648:	6ba2                	ld	s7,8(sp)
    8000164a:	6c02                	ld	s8,0(sp)
    8000164c:	6161                	addi	sp,sp,80
    8000164e:	8082                	ret
            release(&np->lock);
    80001650:	8526                	mv	a0,s1
    80001652:	00005097          	auipc	ra,0x5
    80001656:	c60080e7          	jalr	-928(ra) # 800062b2 <release>
            release(&wait_lock);
    8000165a:	00008517          	auipc	a0,0x8
    8000165e:	a0e50513          	addi	a0,a0,-1522 # 80009068 <wait_lock>
    80001662:	00005097          	auipc	ra,0x5
    80001666:	c50080e7          	jalr	-944(ra) # 800062b2 <release>
            return -1;
    8000166a:	59fd                	li	s3,-1
    8000166c:	b7e9                	j	80001636 <wait+0x90>
    for(np = proc; np < &proc[NPROC]; np++){
    8000166e:	16848493          	addi	s1,s1,360
    80001672:	03348463          	beq	s1,s3,8000169a <wait+0xf4>
      if(np->parent == p){
    80001676:	7c9c                	ld	a5,56(s1)
    80001678:	ff279be3          	bne	a5,s2,8000166e <wait+0xc8>
        acquire(&np->lock);
    8000167c:	8526                	mv	a0,s1
    8000167e:	00005097          	auipc	ra,0x5
    80001682:	b80080e7          	jalr	-1152(ra) # 800061fe <acquire>
        if(np->state == ZOMBIE){
    80001686:	4c9c                	lw	a5,24(s1)
    80001688:	f74785e3          	beq	a5,s4,800015f2 <wait+0x4c>
        release(&np->lock);
    8000168c:	8526                	mv	a0,s1
    8000168e:	00005097          	auipc	ra,0x5
    80001692:	c24080e7          	jalr	-988(ra) # 800062b2 <release>
        havekids = 1;
    80001696:	8756                	mv	a4,s5
    80001698:	bfd9                	j	8000166e <wait+0xc8>
    if(!havekids || p->killed){
    8000169a:	c305                	beqz	a4,800016ba <wait+0x114>
    8000169c:	02892783          	lw	a5,40(s2)
    800016a0:	ef89                	bnez	a5,800016ba <wait+0x114>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800016a2:	85e2                	mv	a1,s8
    800016a4:	854a                	mv	a0,s2
    800016a6:	00000097          	auipc	ra,0x0
    800016aa:	e9c080e7          	jalr	-356(ra) # 80001542 <sleep>
    havekids = 0;
    800016ae:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    800016b0:	00008497          	auipc	s1,0x8
    800016b4:	dd048493          	addi	s1,s1,-560 # 80009480 <proc>
    800016b8:	bf7d                	j	80001676 <wait+0xd0>
      release(&wait_lock);
    800016ba:	00008517          	auipc	a0,0x8
    800016be:	9ae50513          	addi	a0,a0,-1618 # 80009068 <wait_lock>
    800016c2:	00005097          	auipc	ra,0x5
    800016c6:	bf0080e7          	jalr	-1040(ra) # 800062b2 <release>
      return -1;
    800016ca:	59fd                	li	s3,-1
    800016cc:	b7ad                	j	80001636 <wait+0x90>

00000000800016ce <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800016ce:	7139                	addi	sp,sp,-64
    800016d0:	fc06                	sd	ra,56(sp)
    800016d2:	f822                	sd	s0,48(sp)
    800016d4:	f426                	sd	s1,40(sp)
    800016d6:	f04a                	sd	s2,32(sp)
    800016d8:	ec4e                	sd	s3,24(sp)
    800016da:	e852                	sd	s4,16(sp)
    800016dc:	e456                	sd	s5,8(sp)
    800016de:	0080                	addi	s0,sp,64
    800016e0:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800016e2:	00008497          	auipc	s1,0x8
    800016e6:	d9e48493          	addi	s1,s1,-610 # 80009480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800016ea:	4989                	li	s3,2
        p->state = RUNNABLE;
    800016ec:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800016ee:	0000d917          	auipc	s2,0xd
    800016f2:	79290913          	addi	s2,s2,1938 # 8000ee80 <tickslock>
    800016f6:	a811                	j	8000170a <wakeup+0x3c>
      }
      release(&p->lock);
    800016f8:	8526                	mv	a0,s1
    800016fa:	00005097          	auipc	ra,0x5
    800016fe:	bb8080e7          	jalr	-1096(ra) # 800062b2 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001702:	16848493          	addi	s1,s1,360
    80001706:	03248663          	beq	s1,s2,80001732 <wakeup+0x64>
    if(p != myproc()){
    8000170a:	fffff097          	auipc	ra,0xfffff
    8000170e:	772080e7          	jalr	1906(ra) # 80000e7c <myproc>
    80001712:	fea488e3          	beq	s1,a0,80001702 <wakeup+0x34>
      acquire(&p->lock);
    80001716:	8526                	mv	a0,s1
    80001718:	00005097          	auipc	ra,0x5
    8000171c:	ae6080e7          	jalr	-1306(ra) # 800061fe <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001720:	4c9c                	lw	a5,24(s1)
    80001722:	fd379be3          	bne	a5,s3,800016f8 <wakeup+0x2a>
    80001726:	709c                	ld	a5,32(s1)
    80001728:	fd4798e3          	bne	a5,s4,800016f8 <wakeup+0x2a>
        p->state = RUNNABLE;
    8000172c:	0154ac23          	sw	s5,24(s1)
    80001730:	b7e1                	j	800016f8 <wakeup+0x2a>
    }
  }
}
    80001732:	70e2                	ld	ra,56(sp)
    80001734:	7442                	ld	s0,48(sp)
    80001736:	74a2                	ld	s1,40(sp)
    80001738:	7902                	ld	s2,32(sp)
    8000173a:	69e2                	ld	s3,24(sp)
    8000173c:	6a42                	ld	s4,16(sp)
    8000173e:	6aa2                	ld	s5,8(sp)
    80001740:	6121                	addi	sp,sp,64
    80001742:	8082                	ret

0000000080001744 <reparent>:
{
    80001744:	7179                	addi	sp,sp,-48
    80001746:	f406                	sd	ra,40(sp)
    80001748:	f022                	sd	s0,32(sp)
    8000174a:	ec26                	sd	s1,24(sp)
    8000174c:	e84a                	sd	s2,16(sp)
    8000174e:	e44e                	sd	s3,8(sp)
    80001750:	e052                	sd	s4,0(sp)
    80001752:	1800                	addi	s0,sp,48
    80001754:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001756:	00008497          	auipc	s1,0x8
    8000175a:	d2a48493          	addi	s1,s1,-726 # 80009480 <proc>
      pp->parent = initproc;
    8000175e:	00008a17          	auipc	s4,0x8
    80001762:	8b2a0a13          	addi	s4,s4,-1870 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001766:	0000d997          	auipc	s3,0xd
    8000176a:	71a98993          	addi	s3,s3,1818 # 8000ee80 <tickslock>
    8000176e:	a029                	j	80001778 <reparent+0x34>
    80001770:	16848493          	addi	s1,s1,360
    80001774:	01348d63          	beq	s1,s3,8000178e <reparent+0x4a>
    if(pp->parent == p){
    80001778:	7c9c                	ld	a5,56(s1)
    8000177a:	ff279be3          	bne	a5,s2,80001770 <reparent+0x2c>
      pp->parent = initproc;
    8000177e:	000a3503          	ld	a0,0(s4)
    80001782:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001784:	00000097          	auipc	ra,0x0
    80001788:	f4a080e7          	jalr	-182(ra) # 800016ce <wakeup>
    8000178c:	b7d5                	j	80001770 <reparent+0x2c>
}
    8000178e:	70a2                	ld	ra,40(sp)
    80001790:	7402                	ld	s0,32(sp)
    80001792:	64e2                	ld	s1,24(sp)
    80001794:	6942                	ld	s2,16(sp)
    80001796:	69a2                	ld	s3,8(sp)
    80001798:	6a02                	ld	s4,0(sp)
    8000179a:	6145                	addi	sp,sp,48
    8000179c:	8082                	ret

000000008000179e <exit>:
{
    8000179e:	7179                	addi	sp,sp,-48
    800017a0:	f406                	sd	ra,40(sp)
    800017a2:	f022                	sd	s0,32(sp)
    800017a4:	ec26                	sd	s1,24(sp)
    800017a6:	e84a                	sd	s2,16(sp)
    800017a8:	e44e                	sd	s3,8(sp)
    800017aa:	e052                	sd	s4,0(sp)
    800017ac:	1800                	addi	s0,sp,48
    800017ae:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800017b0:	fffff097          	auipc	ra,0xfffff
    800017b4:	6cc080e7          	jalr	1740(ra) # 80000e7c <myproc>
    800017b8:	89aa                	mv	s3,a0
  if(p == initproc)
    800017ba:	00008797          	auipc	a5,0x8
    800017be:	8567b783          	ld	a5,-1962(a5) # 80009010 <initproc>
    800017c2:	0d050493          	addi	s1,a0,208
    800017c6:	15050913          	addi	s2,a0,336
    800017ca:	02a79363          	bne	a5,a0,800017f0 <exit+0x52>
    panic("init exiting");
    800017ce:	00007517          	auipc	a0,0x7
    800017d2:	a1250513          	addi	a0,a0,-1518 # 800081e0 <etext+0x1e0>
    800017d6:	00004097          	auipc	ra,0x4
    800017da:	4d8080e7          	jalr	1240(ra) # 80005cae <panic>
      fileclose(f);
    800017de:	00002097          	auipc	ra,0x2
    800017e2:	174080e7          	jalr	372(ra) # 80003952 <fileclose>
      p->ofile[fd] = 0;
    800017e6:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800017ea:	04a1                	addi	s1,s1,8
    800017ec:	01248563          	beq	s1,s2,800017f6 <exit+0x58>
    if(p->ofile[fd]){
    800017f0:	6088                	ld	a0,0(s1)
    800017f2:	f575                	bnez	a0,800017de <exit+0x40>
    800017f4:	bfdd                	j	800017ea <exit+0x4c>
  begin_op();
    800017f6:	00002097          	auipc	ra,0x2
    800017fa:	c92080e7          	jalr	-878(ra) # 80003488 <begin_op>
  iput(p->cwd);
    800017fe:	1509b503          	ld	a0,336(s3)
    80001802:	00001097          	auipc	ra,0x1
    80001806:	472080e7          	jalr	1138(ra) # 80002c74 <iput>
  end_op();
    8000180a:	00002097          	auipc	ra,0x2
    8000180e:	cf8080e7          	jalr	-776(ra) # 80003502 <end_op>
  p->cwd = 0;
    80001812:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001816:	00008497          	auipc	s1,0x8
    8000181a:	85248493          	addi	s1,s1,-1966 # 80009068 <wait_lock>
    8000181e:	8526                	mv	a0,s1
    80001820:	00005097          	auipc	ra,0x5
    80001824:	9de080e7          	jalr	-1570(ra) # 800061fe <acquire>
  reparent(p);
    80001828:	854e                	mv	a0,s3
    8000182a:	00000097          	auipc	ra,0x0
    8000182e:	f1a080e7          	jalr	-230(ra) # 80001744 <reparent>
  wakeup(p->parent);
    80001832:	0389b503          	ld	a0,56(s3)
    80001836:	00000097          	auipc	ra,0x0
    8000183a:	e98080e7          	jalr	-360(ra) # 800016ce <wakeup>
  acquire(&p->lock);
    8000183e:	854e                	mv	a0,s3
    80001840:	00005097          	auipc	ra,0x5
    80001844:	9be080e7          	jalr	-1602(ra) # 800061fe <acquire>
  p->xstate = status;
    80001848:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    8000184c:	4795                	li	a5,5
    8000184e:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001852:	8526                	mv	a0,s1
    80001854:	00005097          	auipc	ra,0x5
    80001858:	a5e080e7          	jalr	-1442(ra) # 800062b2 <release>
  sched();
    8000185c:	00000097          	auipc	ra,0x0
    80001860:	bd4080e7          	jalr	-1068(ra) # 80001430 <sched>
  panic("zombie exit");
    80001864:	00007517          	auipc	a0,0x7
    80001868:	98c50513          	addi	a0,a0,-1652 # 800081f0 <etext+0x1f0>
    8000186c:	00004097          	auipc	ra,0x4
    80001870:	442080e7          	jalr	1090(ra) # 80005cae <panic>

0000000080001874 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001874:	7179                	addi	sp,sp,-48
    80001876:	f406                	sd	ra,40(sp)
    80001878:	f022                	sd	s0,32(sp)
    8000187a:	ec26                	sd	s1,24(sp)
    8000187c:	e84a                	sd	s2,16(sp)
    8000187e:	e44e                	sd	s3,8(sp)
    80001880:	1800                	addi	s0,sp,48
    80001882:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001884:	00008497          	auipc	s1,0x8
    80001888:	bfc48493          	addi	s1,s1,-1028 # 80009480 <proc>
    8000188c:	0000d997          	auipc	s3,0xd
    80001890:	5f498993          	addi	s3,s3,1524 # 8000ee80 <tickslock>
    acquire(&p->lock);
    80001894:	8526                	mv	a0,s1
    80001896:	00005097          	auipc	ra,0x5
    8000189a:	968080e7          	jalr	-1688(ra) # 800061fe <acquire>
    if(p->pid == pid){
    8000189e:	589c                	lw	a5,48(s1)
    800018a0:	01278d63          	beq	a5,s2,800018ba <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800018a4:	8526                	mv	a0,s1
    800018a6:	00005097          	auipc	ra,0x5
    800018aa:	a0c080e7          	jalr	-1524(ra) # 800062b2 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800018ae:	16848493          	addi	s1,s1,360
    800018b2:	ff3491e3          	bne	s1,s3,80001894 <kill+0x20>
  }
  return -1;
    800018b6:	557d                	li	a0,-1
    800018b8:	a829                	j	800018d2 <kill+0x5e>
      p->killed = 1;
    800018ba:	4785                	li	a5,1
    800018bc:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800018be:	4c98                	lw	a4,24(s1)
    800018c0:	4789                	li	a5,2
    800018c2:	00f70f63          	beq	a4,a5,800018e0 <kill+0x6c>
      release(&p->lock);
    800018c6:	8526                	mv	a0,s1
    800018c8:	00005097          	auipc	ra,0x5
    800018cc:	9ea080e7          	jalr	-1558(ra) # 800062b2 <release>
      return 0;
    800018d0:	4501                	li	a0,0
}
    800018d2:	70a2                	ld	ra,40(sp)
    800018d4:	7402                	ld	s0,32(sp)
    800018d6:	64e2                	ld	s1,24(sp)
    800018d8:	6942                	ld	s2,16(sp)
    800018da:	69a2                	ld	s3,8(sp)
    800018dc:	6145                	addi	sp,sp,48
    800018de:	8082                	ret
        p->state = RUNNABLE;
    800018e0:	478d                	li	a5,3
    800018e2:	cc9c                	sw	a5,24(s1)
    800018e4:	b7cd                	j	800018c6 <kill+0x52>

00000000800018e6 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800018e6:	7179                	addi	sp,sp,-48
    800018e8:	f406                	sd	ra,40(sp)
    800018ea:	f022                	sd	s0,32(sp)
    800018ec:	ec26                	sd	s1,24(sp)
    800018ee:	e84a                	sd	s2,16(sp)
    800018f0:	e44e                	sd	s3,8(sp)
    800018f2:	e052                	sd	s4,0(sp)
    800018f4:	1800                	addi	s0,sp,48
    800018f6:	84aa                	mv	s1,a0
    800018f8:	892e                	mv	s2,a1
    800018fa:	89b2                	mv	s3,a2
    800018fc:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800018fe:	fffff097          	auipc	ra,0xfffff
    80001902:	57e080e7          	jalr	1406(ra) # 80000e7c <myproc>
  if(user_dst){
    80001906:	c08d                	beqz	s1,80001928 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001908:	86d2                	mv	a3,s4
    8000190a:	864e                	mv	a2,s3
    8000190c:	85ca                	mv	a1,s2
    8000190e:	6928                	ld	a0,80(a0)
    80001910:	fffff097          	auipc	ra,0xfffff
    80001914:	208080e7          	jalr	520(ra) # 80000b18 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001918:	70a2                	ld	ra,40(sp)
    8000191a:	7402                	ld	s0,32(sp)
    8000191c:	64e2                	ld	s1,24(sp)
    8000191e:	6942                	ld	s2,16(sp)
    80001920:	69a2                	ld	s3,8(sp)
    80001922:	6a02                	ld	s4,0(sp)
    80001924:	6145                	addi	sp,sp,48
    80001926:	8082                	ret
    memmove((char *)dst, src, len);
    80001928:	000a061b          	sext.w	a2,s4
    8000192c:	85ce                	mv	a1,s3
    8000192e:	854a                	mv	a0,s2
    80001930:	fffff097          	auipc	ra,0xfffff
    80001934:	8a6080e7          	jalr	-1882(ra) # 800001d6 <memmove>
    return 0;
    80001938:	8526                	mv	a0,s1
    8000193a:	bff9                	j	80001918 <either_copyout+0x32>

000000008000193c <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8000193c:	7179                	addi	sp,sp,-48
    8000193e:	f406                	sd	ra,40(sp)
    80001940:	f022                	sd	s0,32(sp)
    80001942:	ec26                	sd	s1,24(sp)
    80001944:	e84a                	sd	s2,16(sp)
    80001946:	e44e                	sd	s3,8(sp)
    80001948:	e052                	sd	s4,0(sp)
    8000194a:	1800                	addi	s0,sp,48
    8000194c:	892a                	mv	s2,a0
    8000194e:	84ae                	mv	s1,a1
    80001950:	89b2                	mv	s3,a2
    80001952:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001954:	fffff097          	auipc	ra,0xfffff
    80001958:	528080e7          	jalr	1320(ra) # 80000e7c <myproc>
  if(user_src){
    8000195c:	c08d                	beqz	s1,8000197e <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    8000195e:	86d2                	mv	a3,s4
    80001960:	864e                	mv	a2,s3
    80001962:	85ca                	mv	a1,s2
    80001964:	6928                	ld	a0,80(a0)
    80001966:	fffff097          	auipc	ra,0xfffff
    8000196a:	23e080e7          	jalr	574(ra) # 80000ba4 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    8000196e:	70a2                	ld	ra,40(sp)
    80001970:	7402                	ld	s0,32(sp)
    80001972:	64e2                	ld	s1,24(sp)
    80001974:	6942                	ld	s2,16(sp)
    80001976:	69a2                	ld	s3,8(sp)
    80001978:	6a02                	ld	s4,0(sp)
    8000197a:	6145                	addi	sp,sp,48
    8000197c:	8082                	ret
    memmove(dst, (char*)src, len);
    8000197e:	000a061b          	sext.w	a2,s4
    80001982:	85ce                	mv	a1,s3
    80001984:	854a                	mv	a0,s2
    80001986:	fffff097          	auipc	ra,0xfffff
    8000198a:	850080e7          	jalr	-1968(ra) # 800001d6 <memmove>
    return 0;
    8000198e:	8526                	mv	a0,s1
    80001990:	bff9                	j	8000196e <either_copyin+0x32>

0000000080001992 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001992:	715d                	addi	sp,sp,-80
    80001994:	e486                	sd	ra,72(sp)
    80001996:	e0a2                	sd	s0,64(sp)
    80001998:	fc26                	sd	s1,56(sp)
    8000199a:	f84a                	sd	s2,48(sp)
    8000199c:	f44e                	sd	s3,40(sp)
    8000199e:	f052                	sd	s4,32(sp)
    800019a0:	ec56                	sd	s5,24(sp)
    800019a2:	e85a                	sd	s6,16(sp)
    800019a4:	e45e                	sd	s7,8(sp)
    800019a6:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800019a8:	00006517          	auipc	a0,0x6
    800019ac:	67050513          	addi	a0,a0,1648 # 80008018 <etext+0x18>
    800019b0:	00004097          	auipc	ra,0x4
    800019b4:	350080e7          	jalr	848(ra) # 80005d00 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800019b8:	00008497          	auipc	s1,0x8
    800019bc:	c2048493          	addi	s1,s1,-992 # 800095d8 <proc+0x158>
    800019c0:	0000d917          	auipc	s2,0xd
    800019c4:	61890913          	addi	s2,s2,1560 # 8000efd8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019c8:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800019ca:	00007997          	auipc	s3,0x7
    800019ce:	83698993          	addi	s3,s3,-1994 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    800019d2:	00007a97          	auipc	s5,0x7
    800019d6:	836a8a93          	addi	s5,s5,-1994 # 80008208 <etext+0x208>
    printf("\n");
    800019da:	00006a17          	auipc	s4,0x6
    800019de:	63ea0a13          	addi	s4,s4,1598 # 80008018 <etext+0x18>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019e2:	00007b97          	auipc	s7,0x7
    800019e6:	d26b8b93          	addi	s7,s7,-730 # 80008708 <states.0>
    800019ea:	a00d                	j	80001a0c <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    800019ec:	ed86a583          	lw	a1,-296(a3)
    800019f0:	8556                	mv	a0,s5
    800019f2:	00004097          	auipc	ra,0x4
    800019f6:	30e080e7          	jalr	782(ra) # 80005d00 <printf>
    printf("\n");
    800019fa:	8552                	mv	a0,s4
    800019fc:	00004097          	auipc	ra,0x4
    80001a00:	304080e7          	jalr	772(ra) # 80005d00 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a04:	16848493          	addi	s1,s1,360
    80001a08:	03248263          	beq	s1,s2,80001a2c <procdump+0x9a>
    if(p->state == UNUSED)
    80001a0c:	86a6                	mv	a3,s1
    80001a0e:	ec04a783          	lw	a5,-320(s1)
    80001a12:	dbed                	beqz	a5,80001a04 <procdump+0x72>
      state = "???";
    80001a14:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a16:	fcfb6be3          	bltu	s6,a5,800019ec <procdump+0x5a>
    80001a1a:	02079713          	slli	a4,a5,0x20
    80001a1e:	01d75793          	srli	a5,a4,0x1d
    80001a22:	97de                	add	a5,a5,s7
    80001a24:	6390                	ld	a2,0(a5)
    80001a26:	f279                	bnez	a2,800019ec <procdump+0x5a>
      state = "???";
    80001a28:	864e                	mv	a2,s3
    80001a2a:	b7c9                	j	800019ec <procdump+0x5a>
  }
}
    80001a2c:	60a6                	ld	ra,72(sp)
    80001a2e:	6406                	ld	s0,64(sp)
    80001a30:	74e2                	ld	s1,56(sp)
    80001a32:	7942                	ld	s2,48(sp)
    80001a34:	79a2                	ld	s3,40(sp)
    80001a36:	7a02                	ld	s4,32(sp)
    80001a38:	6ae2                	ld	s5,24(sp)
    80001a3a:	6b42                	ld	s6,16(sp)
    80001a3c:	6ba2                	ld	s7,8(sp)
    80001a3e:	6161                	addi	sp,sp,80
    80001a40:	8082                	ret

0000000080001a42 <swtch>:
    80001a42:	00153023          	sd	ra,0(a0)
    80001a46:	00253423          	sd	sp,8(a0)
    80001a4a:	e900                	sd	s0,16(a0)
    80001a4c:	ed04                	sd	s1,24(a0)
    80001a4e:	03253023          	sd	s2,32(a0)
    80001a52:	03353423          	sd	s3,40(a0)
    80001a56:	03453823          	sd	s4,48(a0)
    80001a5a:	03553c23          	sd	s5,56(a0)
    80001a5e:	05653023          	sd	s6,64(a0)
    80001a62:	05753423          	sd	s7,72(a0)
    80001a66:	05853823          	sd	s8,80(a0)
    80001a6a:	05953c23          	sd	s9,88(a0)
    80001a6e:	07a53023          	sd	s10,96(a0)
    80001a72:	07b53423          	sd	s11,104(a0)
    80001a76:	0005b083          	ld	ra,0(a1)
    80001a7a:	0085b103          	ld	sp,8(a1)
    80001a7e:	6980                	ld	s0,16(a1)
    80001a80:	6d84                	ld	s1,24(a1)
    80001a82:	0205b903          	ld	s2,32(a1)
    80001a86:	0285b983          	ld	s3,40(a1)
    80001a8a:	0305ba03          	ld	s4,48(a1)
    80001a8e:	0385ba83          	ld	s5,56(a1)
    80001a92:	0405bb03          	ld	s6,64(a1)
    80001a96:	0485bb83          	ld	s7,72(a1)
    80001a9a:	0505bc03          	ld	s8,80(a1)
    80001a9e:	0585bc83          	ld	s9,88(a1)
    80001aa2:	0605bd03          	ld	s10,96(a1)
    80001aa6:	0685bd83          	ld	s11,104(a1)
    80001aaa:	8082                	ret

0000000080001aac <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001aac:	1141                	addi	sp,sp,-16
    80001aae:	e406                	sd	ra,8(sp)
    80001ab0:	e022                	sd	s0,0(sp)
    80001ab2:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001ab4:	00006597          	auipc	a1,0x6
    80001ab8:	78c58593          	addi	a1,a1,1932 # 80008240 <etext+0x240>
    80001abc:	0000d517          	auipc	a0,0xd
    80001ac0:	3c450513          	addi	a0,a0,964 # 8000ee80 <tickslock>
    80001ac4:	00004097          	auipc	ra,0x4
    80001ac8:	6aa080e7          	jalr	1706(ra) # 8000616e <initlock>
}
    80001acc:	60a2                	ld	ra,8(sp)
    80001ace:	6402                	ld	s0,0(sp)
    80001ad0:	0141                	addi	sp,sp,16
    80001ad2:	8082                	ret

0000000080001ad4 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001ad4:	1141                	addi	sp,sp,-16
    80001ad6:	e422                	sd	s0,8(sp)
    80001ad8:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001ada:	00003797          	auipc	a5,0x3
    80001ade:	55678793          	addi	a5,a5,1366 # 80005030 <kernelvec>
    80001ae2:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001ae6:	6422                	ld	s0,8(sp)
    80001ae8:	0141                	addi	sp,sp,16
    80001aea:	8082                	ret

0000000080001aec <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001aec:	1141                	addi	sp,sp,-16
    80001aee:	e406                	sd	ra,8(sp)
    80001af0:	e022                	sd	s0,0(sp)
    80001af2:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001af4:	fffff097          	auipc	ra,0xfffff
    80001af8:	388080e7          	jalr	904(ra) # 80000e7c <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001afc:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001b00:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b02:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001b06:	00005697          	auipc	a3,0x5
    80001b0a:	4fa68693          	addi	a3,a3,1274 # 80007000 <_trampoline>
    80001b0e:	00005717          	auipc	a4,0x5
    80001b12:	4f270713          	addi	a4,a4,1266 # 80007000 <_trampoline>
    80001b16:	8f15                	sub	a4,a4,a3
    80001b18:	040007b7          	lui	a5,0x4000
    80001b1c:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001b1e:	07b2                	slli	a5,a5,0xc
    80001b20:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b22:	10571073          	csrw	stvec,a4

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001b26:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001b28:	18002673          	csrr	a2,satp
    80001b2c:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001b2e:	6d30                	ld	a2,88(a0)
    80001b30:	6138                	ld	a4,64(a0)
    80001b32:	6585                	lui	a1,0x1
    80001b34:	972e                	add	a4,a4,a1
    80001b36:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001b38:	6d38                	ld	a4,88(a0)
    80001b3a:	00000617          	auipc	a2,0x0
    80001b3e:	14060613          	addi	a2,a2,320 # 80001c7a <usertrap>
    80001b42:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001b44:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001b46:	8612                	mv	a2,tp
    80001b48:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b4a:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001b4e:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001b52:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b56:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001b5a:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001b5c:	6f18                	ld	a4,24(a4)
    80001b5e:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001b62:	692c                	ld	a1,80(a0)
    80001b64:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001b66:	00005717          	auipc	a4,0x5
    80001b6a:	52a70713          	addi	a4,a4,1322 # 80007090 <userret>
    80001b6e:	8f15                	sub	a4,a4,a3
    80001b70:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001b72:	577d                	li	a4,-1
    80001b74:	177e                	slli	a4,a4,0x3f
    80001b76:	8dd9                	or	a1,a1,a4
    80001b78:	02000537          	lui	a0,0x2000
    80001b7c:	157d                	addi	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    80001b7e:	0536                	slli	a0,a0,0xd
    80001b80:	9782                	jalr	a5
}
    80001b82:	60a2                	ld	ra,8(sp)
    80001b84:	6402                	ld	s0,0(sp)
    80001b86:	0141                	addi	sp,sp,16
    80001b88:	8082                	ret

0000000080001b8a <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001b8a:	1101                	addi	sp,sp,-32
    80001b8c:	ec06                	sd	ra,24(sp)
    80001b8e:	e822                	sd	s0,16(sp)
    80001b90:	e426                	sd	s1,8(sp)
    80001b92:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001b94:	0000d497          	auipc	s1,0xd
    80001b98:	2ec48493          	addi	s1,s1,748 # 8000ee80 <tickslock>
    80001b9c:	8526                	mv	a0,s1
    80001b9e:	00004097          	auipc	ra,0x4
    80001ba2:	660080e7          	jalr	1632(ra) # 800061fe <acquire>
  ticks++;
    80001ba6:	00007517          	auipc	a0,0x7
    80001baa:	47250513          	addi	a0,a0,1138 # 80009018 <ticks>
    80001bae:	411c                	lw	a5,0(a0)
    80001bb0:	2785                	addiw	a5,a5,1
    80001bb2:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001bb4:	00000097          	auipc	ra,0x0
    80001bb8:	b1a080e7          	jalr	-1254(ra) # 800016ce <wakeup>
  release(&tickslock);
    80001bbc:	8526                	mv	a0,s1
    80001bbe:	00004097          	auipc	ra,0x4
    80001bc2:	6f4080e7          	jalr	1780(ra) # 800062b2 <release>
}
    80001bc6:	60e2                	ld	ra,24(sp)
    80001bc8:	6442                	ld	s0,16(sp)
    80001bca:	64a2                	ld	s1,8(sp)
    80001bcc:	6105                	addi	sp,sp,32
    80001bce:	8082                	ret

0000000080001bd0 <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001bd0:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001bd4:	4501                	li	a0,0
  if((scause & 0x8000000000000000L) &&
    80001bd6:	0a07d163          	bgez	a5,80001c78 <devintr+0xa8>
{
    80001bda:	1101                	addi	sp,sp,-32
    80001bdc:	ec06                	sd	ra,24(sp)
    80001bde:	e822                	sd	s0,16(sp)
    80001be0:	1000                	addi	s0,sp,32
     (scause & 0xff) == 9){
    80001be2:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    80001be6:	46a5                	li	a3,9
    80001be8:	00d70c63          	beq	a4,a3,80001c00 <devintr+0x30>
  } else if(scause == 0x8000000000000001L){
    80001bec:	577d                	li	a4,-1
    80001bee:	177e                	slli	a4,a4,0x3f
    80001bf0:	0705                	addi	a4,a4,1
    return 0;
    80001bf2:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001bf4:	06e78163          	beq	a5,a4,80001c56 <devintr+0x86>
  }
}
    80001bf8:	60e2                	ld	ra,24(sp)
    80001bfa:	6442                	ld	s0,16(sp)
    80001bfc:	6105                	addi	sp,sp,32
    80001bfe:	8082                	ret
    80001c00:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80001c02:	00003097          	auipc	ra,0x3
    80001c06:	53a080e7          	jalr	1338(ra) # 8000513c <plic_claim>
    80001c0a:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001c0c:	47a9                	li	a5,10
    80001c0e:	00f50963          	beq	a0,a5,80001c20 <devintr+0x50>
    } else if(irq == VIRTIO0_IRQ){
    80001c12:	4785                	li	a5,1
    80001c14:	00f50b63          	beq	a0,a5,80001c2a <devintr+0x5a>
    return 1;
    80001c18:	4505                	li	a0,1
    } else if(irq){
    80001c1a:	ec89                	bnez	s1,80001c34 <devintr+0x64>
    80001c1c:	64a2                	ld	s1,8(sp)
    80001c1e:	bfe9                	j	80001bf8 <devintr+0x28>
      uartintr();
    80001c20:	00004097          	auipc	ra,0x4
    80001c24:	4fe080e7          	jalr	1278(ra) # 8000611e <uartintr>
    if(irq)
    80001c28:	a839                	j	80001c46 <devintr+0x76>
      virtio_disk_intr();
    80001c2a:	00004097          	auipc	ra,0x4
    80001c2e:	9e6080e7          	jalr	-1562(ra) # 80005610 <virtio_disk_intr>
    if(irq)
    80001c32:	a811                	j	80001c46 <devintr+0x76>
      printf("unexpected interrupt irq=%d\n", irq);
    80001c34:	85a6                	mv	a1,s1
    80001c36:	00006517          	auipc	a0,0x6
    80001c3a:	61250513          	addi	a0,a0,1554 # 80008248 <etext+0x248>
    80001c3e:	00004097          	auipc	ra,0x4
    80001c42:	0c2080e7          	jalr	194(ra) # 80005d00 <printf>
      plic_complete(irq);
    80001c46:	8526                	mv	a0,s1
    80001c48:	00003097          	auipc	ra,0x3
    80001c4c:	518080e7          	jalr	1304(ra) # 80005160 <plic_complete>
    return 1;
    80001c50:	4505                	li	a0,1
    80001c52:	64a2                	ld	s1,8(sp)
    80001c54:	b755                	j	80001bf8 <devintr+0x28>
    if(cpuid() == 0){
    80001c56:	fffff097          	auipc	ra,0xfffff
    80001c5a:	1fa080e7          	jalr	506(ra) # 80000e50 <cpuid>
    80001c5e:	c901                	beqz	a0,80001c6e <devintr+0x9e>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001c60:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001c64:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001c66:	14479073          	csrw	sip,a5
    return 2;
    80001c6a:	4509                	li	a0,2
    80001c6c:	b771                	j	80001bf8 <devintr+0x28>
      clockintr();
    80001c6e:	00000097          	auipc	ra,0x0
    80001c72:	f1c080e7          	jalr	-228(ra) # 80001b8a <clockintr>
    80001c76:	b7ed                	j	80001c60 <devintr+0x90>
}
    80001c78:	8082                	ret

0000000080001c7a <usertrap>:
{
    80001c7a:	1101                	addi	sp,sp,-32
    80001c7c:	ec06                	sd	ra,24(sp)
    80001c7e:	e822                	sd	s0,16(sp)
    80001c80:	e426                	sd	s1,8(sp)
    80001c82:	e04a                	sd	s2,0(sp)
    80001c84:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c86:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001c8a:	1007f793          	andi	a5,a5,256
    80001c8e:	e3ad                	bnez	a5,80001cf0 <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c90:	00003797          	auipc	a5,0x3
    80001c94:	3a078793          	addi	a5,a5,928 # 80005030 <kernelvec>
    80001c98:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001c9c:	fffff097          	auipc	ra,0xfffff
    80001ca0:	1e0080e7          	jalr	480(ra) # 80000e7c <myproc>
    80001ca4:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001ca6:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ca8:	14102773          	csrr	a4,sepc
    80001cac:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001cae:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001cb2:	47a1                	li	a5,8
    80001cb4:	04f71c63          	bne	a4,a5,80001d0c <usertrap+0x92>
    if(p->killed)
    80001cb8:	551c                	lw	a5,40(a0)
    80001cba:	e3b9                	bnez	a5,80001d00 <usertrap+0x86>
    p->trapframe->epc += 4;
    80001cbc:	6cb8                	ld	a4,88(s1)
    80001cbe:	6f1c                	ld	a5,24(a4)
    80001cc0:	0791                	addi	a5,a5,4
    80001cc2:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cc4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001cc8:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ccc:	10079073          	csrw	sstatus,a5
    syscall();
    80001cd0:	00000097          	auipc	ra,0x0
    80001cd4:	2e0080e7          	jalr	736(ra) # 80001fb0 <syscall>
  if(p->killed)
    80001cd8:	549c                	lw	a5,40(s1)
    80001cda:	ebc1                	bnez	a5,80001d6a <usertrap+0xf0>
  usertrapret();
    80001cdc:	00000097          	auipc	ra,0x0
    80001ce0:	e10080e7          	jalr	-496(ra) # 80001aec <usertrapret>
}
    80001ce4:	60e2                	ld	ra,24(sp)
    80001ce6:	6442                	ld	s0,16(sp)
    80001ce8:	64a2                	ld	s1,8(sp)
    80001cea:	6902                	ld	s2,0(sp)
    80001cec:	6105                	addi	sp,sp,32
    80001cee:	8082                	ret
    panic("usertrap: not from user mode");
    80001cf0:	00006517          	auipc	a0,0x6
    80001cf4:	57850513          	addi	a0,a0,1400 # 80008268 <etext+0x268>
    80001cf8:	00004097          	auipc	ra,0x4
    80001cfc:	fb6080e7          	jalr	-74(ra) # 80005cae <panic>
      exit(-1);
    80001d00:	557d                	li	a0,-1
    80001d02:	00000097          	auipc	ra,0x0
    80001d06:	a9c080e7          	jalr	-1380(ra) # 8000179e <exit>
    80001d0a:	bf4d                	j	80001cbc <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001d0c:	00000097          	auipc	ra,0x0
    80001d10:	ec4080e7          	jalr	-316(ra) # 80001bd0 <devintr>
    80001d14:	892a                	mv	s2,a0
    80001d16:	c501                	beqz	a0,80001d1e <usertrap+0xa4>
  if(p->killed)
    80001d18:	549c                	lw	a5,40(s1)
    80001d1a:	c3a1                	beqz	a5,80001d5a <usertrap+0xe0>
    80001d1c:	a815                	j	80001d50 <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d1e:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001d22:	5890                	lw	a2,48(s1)
    80001d24:	00006517          	auipc	a0,0x6
    80001d28:	56450513          	addi	a0,a0,1380 # 80008288 <etext+0x288>
    80001d2c:	00004097          	auipc	ra,0x4
    80001d30:	fd4080e7          	jalr	-44(ra) # 80005d00 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d34:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001d38:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001d3c:	00006517          	auipc	a0,0x6
    80001d40:	57c50513          	addi	a0,a0,1404 # 800082b8 <etext+0x2b8>
    80001d44:	00004097          	auipc	ra,0x4
    80001d48:	fbc080e7          	jalr	-68(ra) # 80005d00 <printf>
    p->killed = 1;
    80001d4c:	4785                	li	a5,1
    80001d4e:	d49c                	sw	a5,40(s1)
    exit(-1);
    80001d50:	557d                	li	a0,-1
    80001d52:	00000097          	auipc	ra,0x0
    80001d56:	a4c080e7          	jalr	-1460(ra) # 8000179e <exit>
  if(which_dev == 2)
    80001d5a:	4789                	li	a5,2
    80001d5c:	f8f910e3          	bne	s2,a5,80001cdc <usertrap+0x62>
    yield();
    80001d60:	fffff097          	auipc	ra,0xfffff
    80001d64:	7a6080e7          	jalr	1958(ra) # 80001506 <yield>
    80001d68:	bf95                	j	80001cdc <usertrap+0x62>
  int which_dev = 0;
    80001d6a:	4901                	li	s2,0
    80001d6c:	b7d5                	j	80001d50 <usertrap+0xd6>

0000000080001d6e <kerneltrap>:
{
    80001d6e:	7179                	addi	sp,sp,-48
    80001d70:	f406                	sd	ra,40(sp)
    80001d72:	f022                	sd	s0,32(sp)
    80001d74:	ec26                	sd	s1,24(sp)
    80001d76:	e84a                	sd	s2,16(sp)
    80001d78:	e44e                	sd	s3,8(sp)
    80001d7a:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d7c:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d80:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d84:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001d88:	1004f793          	andi	a5,s1,256
    80001d8c:	cb85                	beqz	a5,80001dbc <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d8e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001d92:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001d94:	ef85                	bnez	a5,80001dcc <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001d96:	00000097          	auipc	ra,0x0
    80001d9a:	e3a080e7          	jalr	-454(ra) # 80001bd0 <devintr>
    80001d9e:	cd1d                	beqz	a0,80001ddc <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001da0:	4789                	li	a5,2
    80001da2:	06f50a63          	beq	a0,a5,80001e16 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001da6:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001daa:	10049073          	csrw	sstatus,s1
}
    80001dae:	70a2                	ld	ra,40(sp)
    80001db0:	7402                	ld	s0,32(sp)
    80001db2:	64e2                	ld	s1,24(sp)
    80001db4:	6942                	ld	s2,16(sp)
    80001db6:	69a2                	ld	s3,8(sp)
    80001db8:	6145                	addi	sp,sp,48
    80001dba:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001dbc:	00006517          	auipc	a0,0x6
    80001dc0:	51c50513          	addi	a0,a0,1308 # 800082d8 <etext+0x2d8>
    80001dc4:	00004097          	auipc	ra,0x4
    80001dc8:	eea080e7          	jalr	-278(ra) # 80005cae <panic>
    panic("kerneltrap: interrupts enabled");
    80001dcc:	00006517          	auipc	a0,0x6
    80001dd0:	53450513          	addi	a0,a0,1332 # 80008300 <etext+0x300>
    80001dd4:	00004097          	auipc	ra,0x4
    80001dd8:	eda080e7          	jalr	-294(ra) # 80005cae <panic>
    printf("scause %p\n", scause);
    80001ddc:	85ce                	mv	a1,s3
    80001dde:	00006517          	auipc	a0,0x6
    80001de2:	54250513          	addi	a0,a0,1346 # 80008320 <etext+0x320>
    80001de6:	00004097          	auipc	ra,0x4
    80001dea:	f1a080e7          	jalr	-230(ra) # 80005d00 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001dee:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001df2:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001df6:	00006517          	auipc	a0,0x6
    80001dfa:	53a50513          	addi	a0,a0,1338 # 80008330 <etext+0x330>
    80001dfe:	00004097          	auipc	ra,0x4
    80001e02:	f02080e7          	jalr	-254(ra) # 80005d00 <printf>
    panic("kerneltrap");
    80001e06:	00006517          	auipc	a0,0x6
    80001e0a:	54250513          	addi	a0,a0,1346 # 80008348 <etext+0x348>
    80001e0e:	00004097          	auipc	ra,0x4
    80001e12:	ea0080e7          	jalr	-352(ra) # 80005cae <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e16:	fffff097          	auipc	ra,0xfffff
    80001e1a:	066080e7          	jalr	102(ra) # 80000e7c <myproc>
    80001e1e:	d541                	beqz	a0,80001da6 <kerneltrap+0x38>
    80001e20:	fffff097          	auipc	ra,0xfffff
    80001e24:	05c080e7          	jalr	92(ra) # 80000e7c <myproc>
    80001e28:	4d18                	lw	a4,24(a0)
    80001e2a:	4791                	li	a5,4
    80001e2c:	f6f71de3          	bne	a4,a5,80001da6 <kerneltrap+0x38>
    yield();
    80001e30:	fffff097          	auipc	ra,0xfffff
    80001e34:	6d6080e7          	jalr	1750(ra) # 80001506 <yield>
    80001e38:	b7bd                	j	80001da6 <kerneltrap+0x38>

0000000080001e3a <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001e3a:	1101                	addi	sp,sp,-32
    80001e3c:	ec06                	sd	ra,24(sp)
    80001e3e:	e822                	sd	s0,16(sp)
    80001e40:	e426                	sd	s1,8(sp)
    80001e42:	1000                	addi	s0,sp,32
    80001e44:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001e46:	fffff097          	auipc	ra,0xfffff
    80001e4a:	036080e7          	jalr	54(ra) # 80000e7c <myproc>
  switch (n) {
    80001e4e:	4795                	li	a5,5
    80001e50:	0497e163          	bltu	a5,s1,80001e92 <argraw+0x58>
    80001e54:	048a                	slli	s1,s1,0x2
    80001e56:	00007717          	auipc	a4,0x7
    80001e5a:	8e270713          	addi	a4,a4,-1822 # 80008738 <states.0+0x30>
    80001e5e:	94ba                	add	s1,s1,a4
    80001e60:	409c                	lw	a5,0(s1)
    80001e62:	97ba                	add	a5,a5,a4
    80001e64:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001e66:	6d3c                	ld	a5,88(a0)
    80001e68:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001e6a:	60e2                	ld	ra,24(sp)
    80001e6c:	6442                	ld	s0,16(sp)
    80001e6e:	64a2                	ld	s1,8(sp)
    80001e70:	6105                	addi	sp,sp,32
    80001e72:	8082                	ret
    return p->trapframe->a1;
    80001e74:	6d3c                	ld	a5,88(a0)
    80001e76:	7fa8                	ld	a0,120(a5)
    80001e78:	bfcd                	j	80001e6a <argraw+0x30>
    return p->trapframe->a2;
    80001e7a:	6d3c                	ld	a5,88(a0)
    80001e7c:	63c8                	ld	a0,128(a5)
    80001e7e:	b7f5                	j	80001e6a <argraw+0x30>
    return p->trapframe->a3;
    80001e80:	6d3c                	ld	a5,88(a0)
    80001e82:	67c8                	ld	a0,136(a5)
    80001e84:	b7dd                	j	80001e6a <argraw+0x30>
    return p->trapframe->a4;
    80001e86:	6d3c                	ld	a5,88(a0)
    80001e88:	6bc8                	ld	a0,144(a5)
    80001e8a:	b7c5                	j	80001e6a <argraw+0x30>
    return p->trapframe->a5;
    80001e8c:	6d3c                	ld	a5,88(a0)
    80001e8e:	6fc8                	ld	a0,152(a5)
    80001e90:	bfe9                	j	80001e6a <argraw+0x30>
  panic("argraw");
    80001e92:	00006517          	auipc	a0,0x6
    80001e96:	4c650513          	addi	a0,a0,1222 # 80008358 <etext+0x358>
    80001e9a:	00004097          	auipc	ra,0x4
    80001e9e:	e14080e7          	jalr	-492(ra) # 80005cae <panic>

0000000080001ea2 <fetchaddr>:
{
    80001ea2:	1101                	addi	sp,sp,-32
    80001ea4:	ec06                	sd	ra,24(sp)
    80001ea6:	e822                	sd	s0,16(sp)
    80001ea8:	e426                	sd	s1,8(sp)
    80001eaa:	e04a                	sd	s2,0(sp)
    80001eac:	1000                	addi	s0,sp,32
    80001eae:	84aa                	mv	s1,a0
    80001eb0:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001eb2:	fffff097          	auipc	ra,0xfffff
    80001eb6:	fca080e7          	jalr	-54(ra) # 80000e7c <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80001eba:	653c                	ld	a5,72(a0)
    80001ebc:	02f4f863          	bgeu	s1,a5,80001eec <fetchaddr+0x4a>
    80001ec0:	00848713          	addi	a4,s1,8
    80001ec4:	02e7e663          	bltu	a5,a4,80001ef0 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001ec8:	46a1                	li	a3,8
    80001eca:	8626                	mv	a2,s1
    80001ecc:	85ca                	mv	a1,s2
    80001ece:	6928                	ld	a0,80(a0)
    80001ed0:	fffff097          	auipc	ra,0xfffff
    80001ed4:	cd4080e7          	jalr	-812(ra) # 80000ba4 <copyin>
    80001ed8:	00a03533          	snez	a0,a0
    80001edc:	40a00533          	neg	a0,a0
}
    80001ee0:	60e2                	ld	ra,24(sp)
    80001ee2:	6442                	ld	s0,16(sp)
    80001ee4:	64a2                	ld	s1,8(sp)
    80001ee6:	6902                	ld	s2,0(sp)
    80001ee8:	6105                	addi	sp,sp,32
    80001eea:	8082                	ret
    return -1;
    80001eec:	557d                	li	a0,-1
    80001eee:	bfcd                	j	80001ee0 <fetchaddr+0x3e>
    80001ef0:	557d                	li	a0,-1
    80001ef2:	b7fd                	j	80001ee0 <fetchaddr+0x3e>

0000000080001ef4 <fetchstr>:
{
    80001ef4:	7179                	addi	sp,sp,-48
    80001ef6:	f406                	sd	ra,40(sp)
    80001ef8:	f022                	sd	s0,32(sp)
    80001efa:	ec26                	sd	s1,24(sp)
    80001efc:	e84a                	sd	s2,16(sp)
    80001efe:	e44e                	sd	s3,8(sp)
    80001f00:	1800                	addi	s0,sp,48
    80001f02:	892a                	mv	s2,a0
    80001f04:	84ae                	mv	s1,a1
    80001f06:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001f08:	fffff097          	auipc	ra,0xfffff
    80001f0c:	f74080e7          	jalr	-140(ra) # 80000e7c <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80001f10:	86ce                	mv	a3,s3
    80001f12:	864a                	mv	a2,s2
    80001f14:	85a6                	mv	a1,s1
    80001f16:	6928                	ld	a0,80(a0)
    80001f18:	fffff097          	auipc	ra,0xfffff
    80001f1c:	d1a080e7          	jalr	-742(ra) # 80000c32 <copyinstr>
  if(err < 0)
    80001f20:	00054763          	bltz	a0,80001f2e <fetchstr+0x3a>
  return strlen(buf);
    80001f24:	8526                	mv	a0,s1
    80001f26:	ffffe097          	auipc	ra,0xffffe
    80001f2a:	3c8080e7          	jalr	968(ra) # 800002ee <strlen>
}
    80001f2e:	70a2                	ld	ra,40(sp)
    80001f30:	7402                	ld	s0,32(sp)
    80001f32:	64e2                	ld	s1,24(sp)
    80001f34:	6942                	ld	s2,16(sp)
    80001f36:	69a2                	ld	s3,8(sp)
    80001f38:	6145                	addi	sp,sp,48
    80001f3a:	8082                	ret

0000000080001f3c <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80001f3c:	1101                	addi	sp,sp,-32
    80001f3e:	ec06                	sd	ra,24(sp)
    80001f40:	e822                	sd	s0,16(sp)
    80001f42:	e426                	sd	s1,8(sp)
    80001f44:	1000                	addi	s0,sp,32
    80001f46:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001f48:	00000097          	auipc	ra,0x0
    80001f4c:	ef2080e7          	jalr	-270(ra) # 80001e3a <argraw>
    80001f50:	c088                	sw	a0,0(s1)
  return 0;
}
    80001f52:	4501                	li	a0,0
    80001f54:	60e2                	ld	ra,24(sp)
    80001f56:	6442                	ld	s0,16(sp)
    80001f58:	64a2                	ld	s1,8(sp)
    80001f5a:	6105                	addi	sp,sp,32
    80001f5c:	8082                	ret

0000000080001f5e <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80001f5e:	1101                	addi	sp,sp,-32
    80001f60:	ec06                	sd	ra,24(sp)
    80001f62:	e822                	sd	s0,16(sp)
    80001f64:	e426                	sd	s1,8(sp)
    80001f66:	1000                	addi	s0,sp,32
    80001f68:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001f6a:	00000097          	auipc	ra,0x0
    80001f6e:	ed0080e7          	jalr	-304(ra) # 80001e3a <argraw>
    80001f72:	e088                	sd	a0,0(s1)
  return 0;
}
    80001f74:	4501                	li	a0,0
    80001f76:	60e2                	ld	ra,24(sp)
    80001f78:	6442                	ld	s0,16(sp)
    80001f7a:	64a2                	ld	s1,8(sp)
    80001f7c:	6105                	addi	sp,sp,32
    80001f7e:	8082                	ret

0000000080001f80 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001f80:	1101                	addi	sp,sp,-32
    80001f82:	ec06                	sd	ra,24(sp)
    80001f84:	e822                	sd	s0,16(sp)
    80001f86:	e426                	sd	s1,8(sp)
    80001f88:	e04a                	sd	s2,0(sp)
    80001f8a:	1000                	addi	s0,sp,32
    80001f8c:	84ae                	mv	s1,a1
    80001f8e:	8932                	mv	s2,a2
  *ip = argraw(n);
    80001f90:	00000097          	auipc	ra,0x0
    80001f94:	eaa080e7          	jalr	-342(ra) # 80001e3a <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80001f98:	864a                	mv	a2,s2
    80001f9a:	85a6                	mv	a1,s1
    80001f9c:	00000097          	auipc	ra,0x0
    80001fa0:	f58080e7          	jalr	-168(ra) # 80001ef4 <fetchstr>
}
    80001fa4:	60e2                	ld	ra,24(sp)
    80001fa6:	6442                	ld	s0,16(sp)
    80001fa8:	64a2                	ld	s1,8(sp)
    80001faa:	6902                	ld	s2,0(sp)
    80001fac:	6105                	addi	sp,sp,32
    80001fae:	8082                	ret

0000000080001fb0 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    80001fb0:	1101                	addi	sp,sp,-32
    80001fb2:	ec06                	sd	ra,24(sp)
    80001fb4:	e822                	sd	s0,16(sp)
    80001fb6:	e426                	sd	s1,8(sp)
    80001fb8:	e04a                	sd	s2,0(sp)
    80001fba:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80001fbc:	fffff097          	auipc	ra,0xfffff
    80001fc0:	ec0080e7          	jalr	-320(ra) # 80000e7c <myproc>
    80001fc4:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80001fc6:	05853903          	ld	s2,88(a0)
    80001fca:	0a893783          	ld	a5,168(s2)
    80001fce:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80001fd2:	37fd                	addiw	a5,a5,-1
    80001fd4:	4751                	li	a4,20
    80001fd6:	00f76f63          	bltu	a4,a5,80001ff4 <syscall+0x44>
    80001fda:	00369713          	slli	a4,a3,0x3
    80001fde:	00006797          	auipc	a5,0x6
    80001fe2:	77278793          	addi	a5,a5,1906 # 80008750 <syscalls>
    80001fe6:	97ba                	add	a5,a5,a4
    80001fe8:	639c                	ld	a5,0(a5)
    80001fea:	c789                	beqz	a5,80001ff4 <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    80001fec:	9782                	jalr	a5
    80001fee:	06a93823          	sd	a0,112(s2)
    80001ff2:	a839                	j	80002010 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80001ff4:	15848613          	addi	a2,s1,344
    80001ff8:	588c                	lw	a1,48(s1)
    80001ffa:	00006517          	auipc	a0,0x6
    80001ffe:	36650513          	addi	a0,a0,870 # 80008360 <etext+0x360>
    80002002:	00004097          	auipc	ra,0x4
    80002006:	cfe080e7          	jalr	-770(ra) # 80005d00 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    8000200a:	6cbc                	ld	a5,88(s1)
    8000200c:	577d                	li	a4,-1
    8000200e:	fbb8                	sd	a4,112(a5)
  }
}
    80002010:	60e2                	ld	ra,24(sp)
    80002012:	6442                	ld	s0,16(sp)
    80002014:	64a2                	ld	s1,8(sp)
    80002016:	6902                	ld	s2,0(sp)
    80002018:	6105                	addi	sp,sp,32
    8000201a:	8082                	ret

000000008000201c <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    8000201c:	1101                	addi	sp,sp,-32
    8000201e:	ec06                	sd	ra,24(sp)
    80002020:	e822                	sd	s0,16(sp)
    80002022:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80002024:	fec40593          	addi	a1,s0,-20
    80002028:	4501                	li	a0,0
    8000202a:	00000097          	auipc	ra,0x0
    8000202e:	f12080e7          	jalr	-238(ra) # 80001f3c <argint>
    return -1;
    80002032:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002034:	00054963          	bltz	a0,80002046 <sys_exit+0x2a>
  exit(n);
    80002038:	fec42503          	lw	a0,-20(s0)
    8000203c:	fffff097          	auipc	ra,0xfffff
    80002040:	762080e7          	jalr	1890(ra) # 8000179e <exit>
  return 0;  // not reached
    80002044:	4781                	li	a5,0
}
    80002046:	853e                	mv	a0,a5
    80002048:	60e2                	ld	ra,24(sp)
    8000204a:	6442                	ld	s0,16(sp)
    8000204c:	6105                	addi	sp,sp,32
    8000204e:	8082                	ret

0000000080002050 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002050:	1141                	addi	sp,sp,-16
    80002052:	e406                	sd	ra,8(sp)
    80002054:	e022                	sd	s0,0(sp)
    80002056:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002058:	fffff097          	auipc	ra,0xfffff
    8000205c:	e24080e7          	jalr	-476(ra) # 80000e7c <myproc>
}
    80002060:	5908                	lw	a0,48(a0)
    80002062:	60a2                	ld	ra,8(sp)
    80002064:	6402                	ld	s0,0(sp)
    80002066:	0141                	addi	sp,sp,16
    80002068:	8082                	ret

000000008000206a <sys_fork>:

uint64
sys_fork(void)
{
    8000206a:	1141                	addi	sp,sp,-16
    8000206c:	e406                	sd	ra,8(sp)
    8000206e:	e022                	sd	s0,0(sp)
    80002070:	0800                	addi	s0,sp,16
  return fork();
    80002072:	fffff097          	auipc	ra,0xfffff
    80002076:	1dc080e7          	jalr	476(ra) # 8000124e <fork>
}
    8000207a:	60a2                	ld	ra,8(sp)
    8000207c:	6402                	ld	s0,0(sp)
    8000207e:	0141                	addi	sp,sp,16
    80002080:	8082                	ret

0000000080002082 <sys_wait>:

uint64
sys_wait(void)
{
    80002082:	1101                	addi	sp,sp,-32
    80002084:	ec06                	sd	ra,24(sp)
    80002086:	e822                	sd	s0,16(sp)
    80002088:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    8000208a:	fe840593          	addi	a1,s0,-24
    8000208e:	4501                	li	a0,0
    80002090:	00000097          	auipc	ra,0x0
    80002094:	ece080e7          	jalr	-306(ra) # 80001f5e <argaddr>
    80002098:	87aa                	mv	a5,a0
    return -1;
    8000209a:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    8000209c:	0007c863          	bltz	a5,800020ac <sys_wait+0x2a>
  return wait(p);
    800020a0:	fe843503          	ld	a0,-24(s0)
    800020a4:	fffff097          	auipc	ra,0xfffff
    800020a8:	502080e7          	jalr	1282(ra) # 800015a6 <wait>
}
    800020ac:	60e2                	ld	ra,24(sp)
    800020ae:	6442                	ld	s0,16(sp)
    800020b0:	6105                	addi	sp,sp,32
    800020b2:	8082                	ret

00000000800020b4 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800020b4:	7179                	addi	sp,sp,-48
    800020b6:	f406                	sd	ra,40(sp)
    800020b8:	f022                	sd	s0,32(sp)
    800020ba:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    800020bc:	fdc40593          	addi	a1,s0,-36
    800020c0:	4501                	li	a0,0
    800020c2:	00000097          	auipc	ra,0x0
    800020c6:	e7a080e7          	jalr	-390(ra) # 80001f3c <argint>
    800020ca:	87aa                	mv	a5,a0
    return -1;
    800020cc:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    800020ce:	0207c263          	bltz	a5,800020f2 <sys_sbrk+0x3e>
    800020d2:	ec26                	sd	s1,24(sp)
  addr = myproc()->sz;
    800020d4:	fffff097          	auipc	ra,0xfffff
    800020d8:	da8080e7          	jalr	-600(ra) # 80000e7c <myproc>
    800020dc:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    800020de:	fdc42503          	lw	a0,-36(s0)
    800020e2:	fffff097          	auipc	ra,0xfffff
    800020e6:	0f4080e7          	jalr	244(ra) # 800011d6 <growproc>
    800020ea:	00054863          	bltz	a0,800020fa <sys_sbrk+0x46>
    return -1;
  return addr;
    800020ee:	8526                	mv	a0,s1
    800020f0:	64e2                	ld	s1,24(sp)
}
    800020f2:	70a2                	ld	ra,40(sp)
    800020f4:	7402                	ld	s0,32(sp)
    800020f6:	6145                	addi	sp,sp,48
    800020f8:	8082                	ret
    return -1;
    800020fa:	557d                	li	a0,-1
    800020fc:	64e2                	ld	s1,24(sp)
    800020fe:	bfd5                	j	800020f2 <sys_sbrk+0x3e>

0000000080002100 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002100:	7139                	addi	sp,sp,-64
    80002102:	fc06                	sd	ra,56(sp)
    80002104:	f822                	sd	s0,48(sp)
    80002106:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    80002108:	fcc40593          	addi	a1,s0,-52
    8000210c:	4501                	li	a0,0
    8000210e:	00000097          	auipc	ra,0x0
    80002112:	e2e080e7          	jalr	-466(ra) # 80001f3c <argint>
    return -1;
    80002116:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002118:	06054f63          	bltz	a0,80002196 <sys_sleep+0x96>
    8000211c:	f04a                	sd	s2,32(sp)
  acquire(&tickslock);
    8000211e:	0000d517          	auipc	a0,0xd
    80002122:	d6250513          	addi	a0,a0,-670 # 8000ee80 <tickslock>
    80002126:	00004097          	auipc	ra,0x4
    8000212a:	0d8080e7          	jalr	216(ra) # 800061fe <acquire>
  ticks0 = ticks;
    8000212e:	00007917          	auipc	s2,0x7
    80002132:	eea92903          	lw	s2,-278(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    80002136:	fcc42783          	lw	a5,-52(s0)
    8000213a:	c3a1                	beqz	a5,8000217a <sys_sleep+0x7a>
    8000213c:	f426                	sd	s1,40(sp)
    8000213e:	ec4e                	sd	s3,24(sp)
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002140:	0000d997          	auipc	s3,0xd
    80002144:	d4098993          	addi	s3,s3,-704 # 8000ee80 <tickslock>
    80002148:	00007497          	auipc	s1,0x7
    8000214c:	ed048493          	addi	s1,s1,-304 # 80009018 <ticks>
    if(myproc()->killed){
    80002150:	fffff097          	auipc	ra,0xfffff
    80002154:	d2c080e7          	jalr	-724(ra) # 80000e7c <myproc>
    80002158:	551c                	lw	a5,40(a0)
    8000215a:	e3b9                	bnez	a5,800021a0 <sys_sleep+0xa0>
    sleep(&ticks, &tickslock);
    8000215c:	85ce                	mv	a1,s3
    8000215e:	8526                	mv	a0,s1
    80002160:	fffff097          	auipc	ra,0xfffff
    80002164:	3e2080e7          	jalr	994(ra) # 80001542 <sleep>
  while(ticks - ticks0 < n){
    80002168:	409c                	lw	a5,0(s1)
    8000216a:	412787bb          	subw	a5,a5,s2
    8000216e:	fcc42703          	lw	a4,-52(s0)
    80002172:	fce7efe3          	bltu	a5,a4,80002150 <sys_sleep+0x50>
    80002176:	74a2                	ld	s1,40(sp)
    80002178:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    8000217a:	0000d517          	auipc	a0,0xd
    8000217e:	d0650513          	addi	a0,a0,-762 # 8000ee80 <tickslock>
    80002182:	00004097          	auipc	ra,0x4
    80002186:	130080e7          	jalr	304(ra) # 800062b2 <release>
  backtrace();
    8000218a:	00004097          	auipc	ra,0x4
    8000218e:	ac4080e7          	jalr	-1340(ra) # 80005c4e <backtrace>
  return 0;
    80002192:	4781                	li	a5,0
    80002194:	7902                	ld	s2,32(sp)
}
    80002196:	853e                	mv	a0,a5
    80002198:	70e2                	ld	ra,56(sp)
    8000219a:	7442                	ld	s0,48(sp)
    8000219c:	6121                	addi	sp,sp,64
    8000219e:	8082                	ret
      release(&tickslock);
    800021a0:	0000d517          	auipc	a0,0xd
    800021a4:	ce050513          	addi	a0,a0,-800 # 8000ee80 <tickslock>
    800021a8:	00004097          	auipc	ra,0x4
    800021ac:	10a080e7          	jalr	266(ra) # 800062b2 <release>
      return -1;
    800021b0:	57fd                	li	a5,-1
    800021b2:	74a2                	ld	s1,40(sp)
    800021b4:	7902                	ld	s2,32(sp)
    800021b6:	69e2                	ld	s3,24(sp)
    800021b8:	bff9                	j	80002196 <sys_sleep+0x96>

00000000800021ba <sys_kill>:

uint64
sys_kill(void)
{
    800021ba:	1101                	addi	sp,sp,-32
    800021bc:	ec06                	sd	ra,24(sp)
    800021be:	e822                	sd	s0,16(sp)
    800021c0:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    800021c2:	fec40593          	addi	a1,s0,-20
    800021c6:	4501                	li	a0,0
    800021c8:	00000097          	auipc	ra,0x0
    800021cc:	d74080e7          	jalr	-652(ra) # 80001f3c <argint>
    800021d0:	87aa                	mv	a5,a0
    return -1;
    800021d2:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    800021d4:	0007c863          	bltz	a5,800021e4 <sys_kill+0x2a>
  return kill(pid);
    800021d8:	fec42503          	lw	a0,-20(s0)
    800021dc:	fffff097          	auipc	ra,0xfffff
    800021e0:	698080e7          	jalr	1688(ra) # 80001874 <kill>
}
    800021e4:	60e2                	ld	ra,24(sp)
    800021e6:	6442                	ld	s0,16(sp)
    800021e8:	6105                	addi	sp,sp,32
    800021ea:	8082                	ret

00000000800021ec <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800021ec:	1101                	addi	sp,sp,-32
    800021ee:	ec06                	sd	ra,24(sp)
    800021f0:	e822                	sd	s0,16(sp)
    800021f2:	e426                	sd	s1,8(sp)
    800021f4:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800021f6:	0000d517          	auipc	a0,0xd
    800021fa:	c8a50513          	addi	a0,a0,-886 # 8000ee80 <tickslock>
    800021fe:	00004097          	auipc	ra,0x4
    80002202:	000080e7          	jalr	ra # 800061fe <acquire>
  xticks = ticks;
    80002206:	00007497          	auipc	s1,0x7
    8000220a:	e124a483          	lw	s1,-494(s1) # 80009018 <ticks>
  release(&tickslock);
    8000220e:	0000d517          	auipc	a0,0xd
    80002212:	c7250513          	addi	a0,a0,-910 # 8000ee80 <tickslock>
    80002216:	00004097          	auipc	ra,0x4
    8000221a:	09c080e7          	jalr	156(ra) # 800062b2 <release>
  return xticks;
}
    8000221e:	02049513          	slli	a0,s1,0x20
    80002222:	9101                	srli	a0,a0,0x20
    80002224:	60e2                	ld	ra,24(sp)
    80002226:	6442                	ld	s0,16(sp)
    80002228:	64a2                	ld	s1,8(sp)
    8000222a:	6105                	addi	sp,sp,32
    8000222c:	8082                	ret

000000008000222e <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000222e:	7179                	addi	sp,sp,-48
    80002230:	f406                	sd	ra,40(sp)
    80002232:	f022                	sd	s0,32(sp)
    80002234:	ec26                	sd	s1,24(sp)
    80002236:	e84a                	sd	s2,16(sp)
    80002238:	e44e                	sd	s3,8(sp)
    8000223a:	e052                	sd	s4,0(sp)
    8000223c:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000223e:	00006597          	auipc	a1,0x6
    80002242:	14258593          	addi	a1,a1,322 # 80008380 <etext+0x380>
    80002246:	0000d517          	auipc	a0,0xd
    8000224a:	c5250513          	addi	a0,a0,-942 # 8000ee98 <bcache>
    8000224e:	00004097          	auipc	ra,0x4
    80002252:	f20080e7          	jalr	-224(ra) # 8000616e <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002256:	00015797          	auipc	a5,0x15
    8000225a:	c4278793          	addi	a5,a5,-958 # 80016e98 <bcache+0x8000>
    8000225e:	00015717          	auipc	a4,0x15
    80002262:	ea270713          	addi	a4,a4,-350 # 80017100 <bcache+0x8268>
    80002266:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000226a:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000226e:	0000d497          	auipc	s1,0xd
    80002272:	c4248493          	addi	s1,s1,-958 # 8000eeb0 <bcache+0x18>
    b->next = bcache.head.next;
    80002276:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002278:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000227a:	00006a17          	auipc	s4,0x6
    8000227e:	10ea0a13          	addi	s4,s4,270 # 80008388 <etext+0x388>
    b->next = bcache.head.next;
    80002282:	2b893783          	ld	a5,696(s2)
    80002286:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002288:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000228c:	85d2                	mv	a1,s4
    8000228e:	01048513          	addi	a0,s1,16
    80002292:	00001097          	auipc	ra,0x1
    80002296:	4b2080e7          	jalr	1202(ra) # 80003744 <initsleeplock>
    bcache.head.next->prev = b;
    8000229a:	2b893783          	ld	a5,696(s2)
    8000229e:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800022a0:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800022a4:	45848493          	addi	s1,s1,1112
    800022a8:	fd349de3          	bne	s1,s3,80002282 <binit+0x54>
  }
}
    800022ac:	70a2                	ld	ra,40(sp)
    800022ae:	7402                	ld	s0,32(sp)
    800022b0:	64e2                	ld	s1,24(sp)
    800022b2:	6942                	ld	s2,16(sp)
    800022b4:	69a2                	ld	s3,8(sp)
    800022b6:	6a02                	ld	s4,0(sp)
    800022b8:	6145                	addi	sp,sp,48
    800022ba:	8082                	ret

00000000800022bc <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800022bc:	7179                	addi	sp,sp,-48
    800022be:	f406                	sd	ra,40(sp)
    800022c0:	f022                	sd	s0,32(sp)
    800022c2:	ec26                	sd	s1,24(sp)
    800022c4:	e84a                	sd	s2,16(sp)
    800022c6:	e44e                	sd	s3,8(sp)
    800022c8:	1800                	addi	s0,sp,48
    800022ca:	892a                	mv	s2,a0
    800022cc:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800022ce:	0000d517          	auipc	a0,0xd
    800022d2:	bca50513          	addi	a0,a0,-1078 # 8000ee98 <bcache>
    800022d6:	00004097          	auipc	ra,0x4
    800022da:	f28080e7          	jalr	-216(ra) # 800061fe <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800022de:	00015497          	auipc	s1,0x15
    800022e2:	e724b483          	ld	s1,-398(s1) # 80017150 <bcache+0x82b8>
    800022e6:	00015797          	auipc	a5,0x15
    800022ea:	e1a78793          	addi	a5,a5,-486 # 80017100 <bcache+0x8268>
    800022ee:	02f48f63          	beq	s1,a5,8000232c <bread+0x70>
    800022f2:	873e                	mv	a4,a5
    800022f4:	a021                	j	800022fc <bread+0x40>
    800022f6:	68a4                	ld	s1,80(s1)
    800022f8:	02e48a63          	beq	s1,a4,8000232c <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800022fc:	449c                	lw	a5,8(s1)
    800022fe:	ff279ce3          	bne	a5,s2,800022f6 <bread+0x3a>
    80002302:	44dc                	lw	a5,12(s1)
    80002304:	ff3799e3          	bne	a5,s3,800022f6 <bread+0x3a>
      b->refcnt++;
    80002308:	40bc                	lw	a5,64(s1)
    8000230a:	2785                	addiw	a5,a5,1
    8000230c:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000230e:	0000d517          	auipc	a0,0xd
    80002312:	b8a50513          	addi	a0,a0,-1142 # 8000ee98 <bcache>
    80002316:	00004097          	auipc	ra,0x4
    8000231a:	f9c080e7          	jalr	-100(ra) # 800062b2 <release>
      acquiresleep(&b->lock);
    8000231e:	01048513          	addi	a0,s1,16
    80002322:	00001097          	auipc	ra,0x1
    80002326:	45c080e7          	jalr	1116(ra) # 8000377e <acquiresleep>
      return b;
    8000232a:	a8b9                	j	80002388 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000232c:	00015497          	auipc	s1,0x15
    80002330:	e1c4b483          	ld	s1,-484(s1) # 80017148 <bcache+0x82b0>
    80002334:	00015797          	auipc	a5,0x15
    80002338:	dcc78793          	addi	a5,a5,-564 # 80017100 <bcache+0x8268>
    8000233c:	00f48863          	beq	s1,a5,8000234c <bread+0x90>
    80002340:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002342:	40bc                	lw	a5,64(s1)
    80002344:	cf81                	beqz	a5,8000235c <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002346:	64a4                	ld	s1,72(s1)
    80002348:	fee49de3          	bne	s1,a4,80002342 <bread+0x86>
  panic("bget: no buffers");
    8000234c:	00006517          	auipc	a0,0x6
    80002350:	04450513          	addi	a0,a0,68 # 80008390 <etext+0x390>
    80002354:	00004097          	auipc	ra,0x4
    80002358:	95a080e7          	jalr	-1702(ra) # 80005cae <panic>
      b->dev = dev;
    8000235c:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002360:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002364:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002368:	4785                	li	a5,1
    8000236a:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000236c:	0000d517          	auipc	a0,0xd
    80002370:	b2c50513          	addi	a0,a0,-1236 # 8000ee98 <bcache>
    80002374:	00004097          	auipc	ra,0x4
    80002378:	f3e080e7          	jalr	-194(ra) # 800062b2 <release>
      acquiresleep(&b->lock);
    8000237c:	01048513          	addi	a0,s1,16
    80002380:	00001097          	auipc	ra,0x1
    80002384:	3fe080e7          	jalr	1022(ra) # 8000377e <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002388:	409c                	lw	a5,0(s1)
    8000238a:	cb89                	beqz	a5,8000239c <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000238c:	8526                	mv	a0,s1
    8000238e:	70a2                	ld	ra,40(sp)
    80002390:	7402                	ld	s0,32(sp)
    80002392:	64e2                	ld	s1,24(sp)
    80002394:	6942                	ld	s2,16(sp)
    80002396:	69a2                	ld	s3,8(sp)
    80002398:	6145                	addi	sp,sp,48
    8000239a:	8082                	ret
    virtio_disk_rw(b, 0);
    8000239c:	4581                	li	a1,0
    8000239e:	8526                	mv	a0,s1
    800023a0:	00003097          	auipc	ra,0x3
    800023a4:	fe2080e7          	jalr	-30(ra) # 80005382 <virtio_disk_rw>
    b->valid = 1;
    800023a8:	4785                	li	a5,1
    800023aa:	c09c                	sw	a5,0(s1)
  return b;
    800023ac:	b7c5                	j	8000238c <bread+0xd0>

00000000800023ae <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800023ae:	1101                	addi	sp,sp,-32
    800023b0:	ec06                	sd	ra,24(sp)
    800023b2:	e822                	sd	s0,16(sp)
    800023b4:	e426                	sd	s1,8(sp)
    800023b6:	1000                	addi	s0,sp,32
    800023b8:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800023ba:	0541                	addi	a0,a0,16
    800023bc:	00001097          	auipc	ra,0x1
    800023c0:	45c080e7          	jalr	1116(ra) # 80003818 <holdingsleep>
    800023c4:	cd01                	beqz	a0,800023dc <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800023c6:	4585                	li	a1,1
    800023c8:	8526                	mv	a0,s1
    800023ca:	00003097          	auipc	ra,0x3
    800023ce:	fb8080e7          	jalr	-72(ra) # 80005382 <virtio_disk_rw>
}
    800023d2:	60e2                	ld	ra,24(sp)
    800023d4:	6442                	ld	s0,16(sp)
    800023d6:	64a2                	ld	s1,8(sp)
    800023d8:	6105                	addi	sp,sp,32
    800023da:	8082                	ret
    panic("bwrite");
    800023dc:	00006517          	auipc	a0,0x6
    800023e0:	fcc50513          	addi	a0,a0,-52 # 800083a8 <etext+0x3a8>
    800023e4:	00004097          	auipc	ra,0x4
    800023e8:	8ca080e7          	jalr	-1846(ra) # 80005cae <panic>

00000000800023ec <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800023ec:	1101                	addi	sp,sp,-32
    800023ee:	ec06                	sd	ra,24(sp)
    800023f0:	e822                	sd	s0,16(sp)
    800023f2:	e426                	sd	s1,8(sp)
    800023f4:	e04a                	sd	s2,0(sp)
    800023f6:	1000                	addi	s0,sp,32
    800023f8:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800023fa:	01050913          	addi	s2,a0,16
    800023fe:	854a                	mv	a0,s2
    80002400:	00001097          	auipc	ra,0x1
    80002404:	418080e7          	jalr	1048(ra) # 80003818 <holdingsleep>
    80002408:	c925                	beqz	a0,80002478 <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    8000240a:	854a                	mv	a0,s2
    8000240c:	00001097          	auipc	ra,0x1
    80002410:	3c8080e7          	jalr	968(ra) # 800037d4 <releasesleep>

  acquire(&bcache.lock);
    80002414:	0000d517          	auipc	a0,0xd
    80002418:	a8450513          	addi	a0,a0,-1404 # 8000ee98 <bcache>
    8000241c:	00004097          	auipc	ra,0x4
    80002420:	de2080e7          	jalr	-542(ra) # 800061fe <acquire>
  b->refcnt--;
    80002424:	40bc                	lw	a5,64(s1)
    80002426:	37fd                	addiw	a5,a5,-1
    80002428:	0007871b          	sext.w	a4,a5
    8000242c:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000242e:	e71d                	bnez	a4,8000245c <brelse+0x70>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002430:	68b8                	ld	a4,80(s1)
    80002432:	64bc                	ld	a5,72(s1)
    80002434:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002436:	68b8                	ld	a4,80(s1)
    80002438:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000243a:	00015797          	auipc	a5,0x15
    8000243e:	a5e78793          	addi	a5,a5,-1442 # 80016e98 <bcache+0x8000>
    80002442:	2b87b703          	ld	a4,696(a5)
    80002446:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002448:	00015717          	auipc	a4,0x15
    8000244c:	cb870713          	addi	a4,a4,-840 # 80017100 <bcache+0x8268>
    80002450:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002452:	2b87b703          	ld	a4,696(a5)
    80002456:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002458:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000245c:	0000d517          	auipc	a0,0xd
    80002460:	a3c50513          	addi	a0,a0,-1476 # 8000ee98 <bcache>
    80002464:	00004097          	auipc	ra,0x4
    80002468:	e4e080e7          	jalr	-434(ra) # 800062b2 <release>
}
    8000246c:	60e2                	ld	ra,24(sp)
    8000246e:	6442                	ld	s0,16(sp)
    80002470:	64a2                	ld	s1,8(sp)
    80002472:	6902                	ld	s2,0(sp)
    80002474:	6105                	addi	sp,sp,32
    80002476:	8082                	ret
    panic("brelse");
    80002478:	00006517          	auipc	a0,0x6
    8000247c:	f3850513          	addi	a0,a0,-200 # 800083b0 <etext+0x3b0>
    80002480:	00004097          	auipc	ra,0x4
    80002484:	82e080e7          	jalr	-2002(ra) # 80005cae <panic>

0000000080002488 <bpin>:

void
bpin(struct buf *b) {
    80002488:	1101                	addi	sp,sp,-32
    8000248a:	ec06                	sd	ra,24(sp)
    8000248c:	e822                	sd	s0,16(sp)
    8000248e:	e426                	sd	s1,8(sp)
    80002490:	1000                	addi	s0,sp,32
    80002492:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002494:	0000d517          	auipc	a0,0xd
    80002498:	a0450513          	addi	a0,a0,-1532 # 8000ee98 <bcache>
    8000249c:	00004097          	auipc	ra,0x4
    800024a0:	d62080e7          	jalr	-670(ra) # 800061fe <acquire>
  b->refcnt++;
    800024a4:	40bc                	lw	a5,64(s1)
    800024a6:	2785                	addiw	a5,a5,1
    800024a8:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800024aa:	0000d517          	auipc	a0,0xd
    800024ae:	9ee50513          	addi	a0,a0,-1554 # 8000ee98 <bcache>
    800024b2:	00004097          	auipc	ra,0x4
    800024b6:	e00080e7          	jalr	-512(ra) # 800062b2 <release>
}
    800024ba:	60e2                	ld	ra,24(sp)
    800024bc:	6442                	ld	s0,16(sp)
    800024be:	64a2                	ld	s1,8(sp)
    800024c0:	6105                	addi	sp,sp,32
    800024c2:	8082                	ret

00000000800024c4 <bunpin>:

void
bunpin(struct buf *b) {
    800024c4:	1101                	addi	sp,sp,-32
    800024c6:	ec06                	sd	ra,24(sp)
    800024c8:	e822                	sd	s0,16(sp)
    800024ca:	e426                	sd	s1,8(sp)
    800024cc:	1000                	addi	s0,sp,32
    800024ce:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800024d0:	0000d517          	auipc	a0,0xd
    800024d4:	9c850513          	addi	a0,a0,-1592 # 8000ee98 <bcache>
    800024d8:	00004097          	auipc	ra,0x4
    800024dc:	d26080e7          	jalr	-730(ra) # 800061fe <acquire>
  b->refcnt--;
    800024e0:	40bc                	lw	a5,64(s1)
    800024e2:	37fd                	addiw	a5,a5,-1
    800024e4:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800024e6:	0000d517          	auipc	a0,0xd
    800024ea:	9b250513          	addi	a0,a0,-1614 # 8000ee98 <bcache>
    800024ee:	00004097          	auipc	ra,0x4
    800024f2:	dc4080e7          	jalr	-572(ra) # 800062b2 <release>
}
    800024f6:	60e2                	ld	ra,24(sp)
    800024f8:	6442                	ld	s0,16(sp)
    800024fa:	64a2                	ld	s1,8(sp)
    800024fc:	6105                	addi	sp,sp,32
    800024fe:	8082                	ret

0000000080002500 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002500:	1101                	addi	sp,sp,-32
    80002502:	ec06                	sd	ra,24(sp)
    80002504:	e822                	sd	s0,16(sp)
    80002506:	e426                	sd	s1,8(sp)
    80002508:	e04a                	sd	s2,0(sp)
    8000250a:	1000                	addi	s0,sp,32
    8000250c:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000250e:	00d5d59b          	srliw	a1,a1,0xd
    80002512:	00015797          	auipc	a5,0x15
    80002516:	0627a783          	lw	a5,98(a5) # 80017574 <sb+0x1c>
    8000251a:	9dbd                	addw	a1,a1,a5
    8000251c:	00000097          	auipc	ra,0x0
    80002520:	da0080e7          	jalr	-608(ra) # 800022bc <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002524:	0074f713          	andi	a4,s1,7
    80002528:	4785                	li	a5,1
    8000252a:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000252e:	14ce                	slli	s1,s1,0x33
    80002530:	90d9                	srli	s1,s1,0x36
    80002532:	00950733          	add	a4,a0,s1
    80002536:	05874703          	lbu	a4,88(a4)
    8000253a:	00e7f6b3          	and	a3,a5,a4
    8000253e:	c69d                	beqz	a3,8000256c <bfree+0x6c>
    80002540:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002542:	94aa                	add	s1,s1,a0
    80002544:	fff7c793          	not	a5,a5
    80002548:	8f7d                	and	a4,a4,a5
    8000254a:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    8000254e:	00001097          	auipc	ra,0x1
    80002552:	112080e7          	jalr	274(ra) # 80003660 <log_write>
  brelse(bp);
    80002556:	854a                	mv	a0,s2
    80002558:	00000097          	auipc	ra,0x0
    8000255c:	e94080e7          	jalr	-364(ra) # 800023ec <brelse>
}
    80002560:	60e2                	ld	ra,24(sp)
    80002562:	6442                	ld	s0,16(sp)
    80002564:	64a2                	ld	s1,8(sp)
    80002566:	6902                	ld	s2,0(sp)
    80002568:	6105                	addi	sp,sp,32
    8000256a:	8082                	ret
    panic("freeing free block");
    8000256c:	00006517          	auipc	a0,0x6
    80002570:	e4c50513          	addi	a0,a0,-436 # 800083b8 <etext+0x3b8>
    80002574:	00003097          	auipc	ra,0x3
    80002578:	73a080e7          	jalr	1850(ra) # 80005cae <panic>

000000008000257c <balloc>:
{
    8000257c:	711d                	addi	sp,sp,-96
    8000257e:	ec86                	sd	ra,88(sp)
    80002580:	e8a2                	sd	s0,80(sp)
    80002582:	e4a6                	sd	s1,72(sp)
    80002584:	e0ca                	sd	s2,64(sp)
    80002586:	fc4e                	sd	s3,56(sp)
    80002588:	f852                	sd	s4,48(sp)
    8000258a:	f456                	sd	s5,40(sp)
    8000258c:	f05a                	sd	s6,32(sp)
    8000258e:	ec5e                	sd	s7,24(sp)
    80002590:	e862                	sd	s8,16(sp)
    80002592:	e466                	sd	s9,8(sp)
    80002594:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002596:	00015797          	auipc	a5,0x15
    8000259a:	fc67a783          	lw	a5,-58(a5) # 8001755c <sb+0x4>
    8000259e:	cbc1                	beqz	a5,8000262e <balloc+0xb2>
    800025a0:	8baa                	mv	s7,a0
    800025a2:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800025a4:	00015b17          	auipc	s6,0x15
    800025a8:	fb4b0b13          	addi	s6,s6,-76 # 80017558 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800025ac:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800025ae:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800025b0:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800025b2:	6c89                	lui	s9,0x2
    800025b4:	a831                	j	800025d0 <balloc+0x54>
    brelse(bp);
    800025b6:	854a                	mv	a0,s2
    800025b8:	00000097          	auipc	ra,0x0
    800025bc:	e34080e7          	jalr	-460(ra) # 800023ec <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800025c0:	015c87bb          	addw	a5,s9,s5
    800025c4:	00078a9b          	sext.w	s5,a5
    800025c8:	004b2703          	lw	a4,4(s6)
    800025cc:	06eaf163          	bgeu	s5,a4,8000262e <balloc+0xb2>
    bp = bread(dev, BBLOCK(b, sb));
    800025d0:	41fad79b          	sraiw	a5,s5,0x1f
    800025d4:	0137d79b          	srliw	a5,a5,0x13
    800025d8:	015787bb          	addw	a5,a5,s5
    800025dc:	40d7d79b          	sraiw	a5,a5,0xd
    800025e0:	01cb2583          	lw	a1,28(s6)
    800025e4:	9dbd                	addw	a1,a1,a5
    800025e6:	855e                	mv	a0,s7
    800025e8:	00000097          	auipc	ra,0x0
    800025ec:	cd4080e7          	jalr	-812(ra) # 800022bc <bread>
    800025f0:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800025f2:	004b2503          	lw	a0,4(s6)
    800025f6:	000a849b          	sext.w	s1,s5
    800025fa:	8762                	mv	a4,s8
    800025fc:	faa4fde3          	bgeu	s1,a0,800025b6 <balloc+0x3a>
      m = 1 << (bi % 8);
    80002600:	00777693          	andi	a3,a4,7
    80002604:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002608:	41f7579b          	sraiw	a5,a4,0x1f
    8000260c:	01d7d79b          	srliw	a5,a5,0x1d
    80002610:	9fb9                	addw	a5,a5,a4
    80002612:	4037d79b          	sraiw	a5,a5,0x3
    80002616:	00f90633          	add	a2,s2,a5
    8000261a:	05864603          	lbu	a2,88(a2)
    8000261e:	00c6f5b3          	and	a1,a3,a2
    80002622:	cd91                	beqz	a1,8000263e <balloc+0xc2>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002624:	2705                	addiw	a4,a4,1
    80002626:	2485                	addiw	s1,s1,1
    80002628:	fd471ae3          	bne	a4,s4,800025fc <balloc+0x80>
    8000262c:	b769                	j	800025b6 <balloc+0x3a>
  panic("balloc: out of blocks");
    8000262e:	00006517          	auipc	a0,0x6
    80002632:	da250513          	addi	a0,a0,-606 # 800083d0 <etext+0x3d0>
    80002636:	00003097          	auipc	ra,0x3
    8000263a:	678080e7          	jalr	1656(ra) # 80005cae <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000263e:	97ca                	add	a5,a5,s2
    80002640:	8e55                	or	a2,a2,a3
    80002642:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002646:	854a                	mv	a0,s2
    80002648:	00001097          	auipc	ra,0x1
    8000264c:	018080e7          	jalr	24(ra) # 80003660 <log_write>
        brelse(bp);
    80002650:	854a                	mv	a0,s2
    80002652:	00000097          	auipc	ra,0x0
    80002656:	d9a080e7          	jalr	-614(ra) # 800023ec <brelse>
  bp = bread(dev, bno);
    8000265a:	85a6                	mv	a1,s1
    8000265c:	855e                	mv	a0,s7
    8000265e:	00000097          	auipc	ra,0x0
    80002662:	c5e080e7          	jalr	-930(ra) # 800022bc <bread>
    80002666:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002668:	40000613          	li	a2,1024
    8000266c:	4581                	li	a1,0
    8000266e:	05850513          	addi	a0,a0,88
    80002672:	ffffe097          	auipc	ra,0xffffe
    80002676:	b08080e7          	jalr	-1272(ra) # 8000017a <memset>
  log_write(bp);
    8000267a:	854a                	mv	a0,s2
    8000267c:	00001097          	auipc	ra,0x1
    80002680:	fe4080e7          	jalr	-28(ra) # 80003660 <log_write>
  brelse(bp);
    80002684:	854a                	mv	a0,s2
    80002686:	00000097          	auipc	ra,0x0
    8000268a:	d66080e7          	jalr	-666(ra) # 800023ec <brelse>
}
    8000268e:	8526                	mv	a0,s1
    80002690:	60e6                	ld	ra,88(sp)
    80002692:	6446                	ld	s0,80(sp)
    80002694:	64a6                	ld	s1,72(sp)
    80002696:	6906                	ld	s2,64(sp)
    80002698:	79e2                	ld	s3,56(sp)
    8000269a:	7a42                	ld	s4,48(sp)
    8000269c:	7aa2                	ld	s5,40(sp)
    8000269e:	7b02                	ld	s6,32(sp)
    800026a0:	6be2                	ld	s7,24(sp)
    800026a2:	6c42                	ld	s8,16(sp)
    800026a4:	6ca2                	ld	s9,8(sp)
    800026a6:	6125                	addi	sp,sp,96
    800026a8:	8082                	ret

00000000800026aa <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    800026aa:	7179                	addi	sp,sp,-48
    800026ac:	f406                	sd	ra,40(sp)
    800026ae:	f022                	sd	s0,32(sp)
    800026b0:	ec26                	sd	s1,24(sp)
    800026b2:	e84a                	sd	s2,16(sp)
    800026b4:	e44e                	sd	s3,8(sp)
    800026b6:	1800                	addi	s0,sp,48
    800026b8:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800026ba:	47ad                	li	a5,11
    800026bc:	04b7ff63          	bgeu	a5,a1,8000271a <bmap+0x70>
    800026c0:	e052                	sd	s4,0(sp)
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    800026c2:	ff45849b          	addiw	s1,a1,-12
    800026c6:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800026ca:	0ff00793          	li	a5,255
    800026ce:	0ae7e463          	bltu	a5,a4,80002776 <bmap+0xcc>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    800026d2:	08052583          	lw	a1,128(a0)
    800026d6:	c5b5                	beqz	a1,80002742 <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    800026d8:	00092503          	lw	a0,0(s2)
    800026dc:	00000097          	auipc	ra,0x0
    800026e0:	be0080e7          	jalr	-1056(ra) # 800022bc <bread>
    800026e4:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800026e6:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800026ea:	02049713          	slli	a4,s1,0x20
    800026ee:	01e75593          	srli	a1,a4,0x1e
    800026f2:	00b784b3          	add	s1,a5,a1
    800026f6:	0004a983          	lw	s3,0(s1)
    800026fa:	04098e63          	beqz	s3,80002756 <bmap+0xac>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    800026fe:	8552                	mv	a0,s4
    80002700:	00000097          	auipc	ra,0x0
    80002704:	cec080e7          	jalr	-788(ra) # 800023ec <brelse>
    return addr;
    80002708:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    8000270a:	854e                	mv	a0,s3
    8000270c:	70a2                	ld	ra,40(sp)
    8000270e:	7402                	ld	s0,32(sp)
    80002710:	64e2                	ld	s1,24(sp)
    80002712:	6942                	ld	s2,16(sp)
    80002714:	69a2                	ld	s3,8(sp)
    80002716:	6145                	addi	sp,sp,48
    80002718:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    8000271a:	02059793          	slli	a5,a1,0x20
    8000271e:	01e7d593          	srli	a1,a5,0x1e
    80002722:	00b504b3          	add	s1,a0,a1
    80002726:	0504a983          	lw	s3,80(s1)
    8000272a:	fe0990e3          	bnez	s3,8000270a <bmap+0x60>
      ip->addrs[bn] = addr = balloc(ip->dev);
    8000272e:	4108                	lw	a0,0(a0)
    80002730:	00000097          	auipc	ra,0x0
    80002734:	e4c080e7          	jalr	-436(ra) # 8000257c <balloc>
    80002738:	0005099b          	sext.w	s3,a0
    8000273c:	0534a823          	sw	s3,80(s1)
    80002740:	b7e9                	j	8000270a <bmap+0x60>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80002742:	4108                	lw	a0,0(a0)
    80002744:	00000097          	auipc	ra,0x0
    80002748:	e38080e7          	jalr	-456(ra) # 8000257c <balloc>
    8000274c:	0005059b          	sext.w	a1,a0
    80002750:	08b92023          	sw	a1,128(s2)
    80002754:	b751                	j	800026d8 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80002756:	00092503          	lw	a0,0(s2)
    8000275a:	00000097          	auipc	ra,0x0
    8000275e:	e22080e7          	jalr	-478(ra) # 8000257c <balloc>
    80002762:	0005099b          	sext.w	s3,a0
    80002766:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    8000276a:	8552                	mv	a0,s4
    8000276c:	00001097          	auipc	ra,0x1
    80002770:	ef4080e7          	jalr	-268(ra) # 80003660 <log_write>
    80002774:	b769                	j	800026fe <bmap+0x54>
  panic("bmap: out of range");
    80002776:	00006517          	auipc	a0,0x6
    8000277a:	c7250513          	addi	a0,a0,-910 # 800083e8 <etext+0x3e8>
    8000277e:	00003097          	auipc	ra,0x3
    80002782:	530080e7          	jalr	1328(ra) # 80005cae <panic>

0000000080002786 <iget>:
{
    80002786:	7179                	addi	sp,sp,-48
    80002788:	f406                	sd	ra,40(sp)
    8000278a:	f022                	sd	s0,32(sp)
    8000278c:	ec26                	sd	s1,24(sp)
    8000278e:	e84a                	sd	s2,16(sp)
    80002790:	e44e                	sd	s3,8(sp)
    80002792:	e052                	sd	s4,0(sp)
    80002794:	1800                	addi	s0,sp,48
    80002796:	89aa                	mv	s3,a0
    80002798:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    8000279a:	00015517          	auipc	a0,0x15
    8000279e:	dde50513          	addi	a0,a0,-546 # 80017578 <itable>
    800027a2:	00004097          	auipc	ra,0x4
    800027a6:	a5c080e7          	jalr	-1444(ra) # 800061fe <acquire>
  empty = 0;
    800027aa:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800027ac:	00015497          	auipc	s1,0x15
    800027b0:	de448493          	addi	s1,s1,-540 # 80017590 <itable+0x18>
    800027b4:	00017697          	auipc	a3,0x17
    800027b8:	86c68693          	addi	a3,a3,-1940 # 80019020 <log>
    800027bc:	a039                	j	800027ca <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800027be:	02090b63          	beqz	s2,800027f4 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800027c2:	08848493          	addi	s1,s1,136
    800027c6:	02d48a63          	beq	s1,a3,800027fa <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800027ca:	449c                	lw	a5,8(s1)
    800027cc:	fef059e3          	blez	a5,800027be <iget+0x38>
    800027d0:	4098                	lw	a4,0(s1)
    800027d2:	ff3716e3          	bne	a4,s3,800027be <iget+0x38>
    800027d6:	40d8                	lw	a4,4(s1)
    800027d8:	ff4713e3          	bne	a4,s4,800027be <iget+0x38>
      ip->ref++;
    800027dc:	2785                	addiw	a5,a5,1
    800027de:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800027e0:	00015517          	auipc	a0,0x15
    800027e4:	d9850513          	addi	a0,a0,-616 # 80017578 <itable>
    800027e8:	00004097          	auipc	ra,0x4
    800027ec:	aca080e7          	jalr	-1334(ra) # 800062b2 <release>
      return ip;
    800027f0:	8926                	mv	s2,s1
    800027f2:	a03d                	j	80002820 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800027f4:	f7f9                	bnez	a5,800027c2 <iget+0x3c>
      empty = ip;
    800027f6:	8926                	mv	s2,s1
    800027f8:	b7e9                	j	800027c2 <iget+0x3c>
  if(empty == 0)
    800027fa:	02090c63          	beqz	s2,80002832 <iget+0xac>
  ip->dev = dev;
    800027fe:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002802:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002806:	4785                	li	a5,1
    80002808:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    8000280c:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002810:	00015517          	auipc	a0,0x15
    80002814:	d6850513          	addi	a0,a0,-664 # 80017578 <itable>
    80002818:	00004097          	auipc	ra,0x4
    8000281c:	a9a080e7          	jalr	-1382(ra) # 800062b2 <release>
}
    80002820:	854a                	mv	a0,s2
    80002822:	70a2                	ld	ra,40(sp)
    80002824:	7402                	ld	s0,32(sp)
    80002826:	64e2                	ld	s1,24(sp)
    80002828:	6942                	ld	s2,16(sp)
    8000282a:	69a2                	ld	s3,8(sp)
    8000282c:	6a02                	ld	s4,0(sp)
    8000282e:	6145                	addi	sp,sp,48
    80002830:	8082                	ret
    panic("iget: no inodes");
    80002832:	00006517          	auipc	a0,0x6
    80002836:	bce50513          	addi	a0,a0,-1074 # 80008400 <etext+0x400>
    8000283a:	00003097          	auipc	ra,0x3
    8000283e:	474080e7          	jalr	1140(ra) # 80005cae <panic>

0000000080002842 <fsinit>:
fsinit(int dev) {
    80002842:	7179                	addi	sp,sp,-48
    80002844:	f406                	sd	ra,40(sp)
    80002846:	f022                	sd	s0,32(sp)
    80002848:	ec26                	sd	s1,24(sp)
    8000284a:	e84a                	sd	s2,16(sp)
    8000284c:	e44e                	sd	s3,8(sp)
    8000284e:	1800                	addi	s0,sp,48
    80002850:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002852:	4585                	li	a1,1
    80002854:	00000097          	auipc	ra,0x0
    80002858:	a68080e7          	jalr	-1432(ra) # 800022bc <bread>
    8000285c:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    8000285e:	00015997          	auipc	s3,0x15
    80002862:	cfa98993          	addi	s3,s3,-774 # 80017558 <sb>
    80002866:	02000613          	li	a2,32
    8000286a:	05850593          	addi	a1,a0,88
    8000286e:	854e                	mv	a0,s3
    80002870:	ffffe097          	auipc	ra,0xffffe
    80002874:	966080e7          	jalr	-1690(ra) # 800001d6 <memmove>
  brelse(bp);
    80002878:	8526                	mv	a0,s1
    8000287a:	00000097          	auipc	ra,0x0
    8000287e:	b72080e7          	jalr	-1166(ra) # 800023ec <brelse>
  if(sb.magic != FSMAGIC)
    80002882:	0009a703          	lw	a4,0(s3)
    80002886:	102037b7          	lui	a5,0x10203
    8000288a:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    8000288e:	02f71263          	bne	a4,a5,800028b2 <fsinit+0x70>
  initlog(dev, &sb);
    80002892:	00015597          	auipc	a1,0x15
    80002896:	cc658593          	addi	a1,a1,-826 # 80017558 <sb>
    8000289a:	854a                	mv	a0,s2
    8000289c:	00001097          	auipc	ra,0x1
    800028a0:	b54080e7          	jalr	-1196(ra) # 800033f0 <initlog>
}
    800028a4:	70a2                	ld	ra,40(sp)
    800028a6:	7402                	ld	s0,32(sp)
    800028a8:	64e2                	ld	s1,24(sp)
    800028aa:	6942                	ld	s2,16(sp)
    800028ac:	69a2                	ld	s3,8(sp)
    800028ae:	6145                	addi	sp,sp,48
    800028b0:	8082                	ret
    panic("invalid file system");
    800028b2:	00006517          	auipc	a0,0x6
    800028b6:	b5e50513          	addi	a0,a0,-1186 # 80008410 <etext+0x410>
    800028ba:	00003097          	auipc	ra,0x3
    800028be:	3f4080e7          	jalr	1012(ra) # 80005cae <panic>

00000000800028c2 <iinit>:
{
    800028c2:	7179                	addi	sp,sp,-48
    800028c4:	f406                	sd	ra,40(sp)
    800028c6:	f022                	sd	s0,32(sp)
    800028c8:	ec26                	sd	s1,24(sp)
    800028ca:	e84a                	sd	s2,16(sp)
    800028cc:	e44e                	sd	s3,8(sp)
    800028ce:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800028d0:	00006597          	auipc	a1,0x6
    800028d4:	b5858593          	addi	a1,a1,-1192 # 80008428 <etext+0x428>
    800028d8:	00015517          	auipc	a0,0x15
    800028dc:	ca050513          	addi	a0,a0,-864 # 80017578 <itable>
    800028e0:	00004097          	auipc	ra,0x4
    800028e4:	88e080e7          	jalr	-1906(ra) # 8000616e <initlock>
  for(i = 0; i < NINODE; i++) {
    800028e8:	00015497          	auipc	s1,0x15
    800028ec:	cb848493          	addi	s1,s1,-840 # 800175a0 <itable+0x28>
    800028f0:	00016997          	auipc	s3,0x16
    800028f4:	74098993          	addi	s3,s3,1856 # 80019030 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800028f8:	00006917          	auipc	s2,0x6
    800028fc:	b3890913          	addi	s2,s2,-1224 # 80008430 <etext+0x430>
    80002900:	85ca                	mv	a1,s2
    80002902:	8526                	mv	a0,s1
    80002904:	00001097          	auipc	ra,0x1
    80002908:	e40080e7          	jalr	-448(ra) # 80003744 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    8000290c:	08848493          	addi	s1,s1,136
    80002910:	ff3498e3          	bne	s1,s3,80002900 <iinit+0x3e>
}
    80002914:	70a2                	ld	ra,40(sp)
    80002916:	7402                	ld	s0,32(sp)
    80002918:	64e2                	ld	s1,24(sp)
    8000291a:	6942                	ld	s2,16(sp)
    8000291c:	69a2                	ld	s3,8(sp)
    8000291e:	6145                	addi	sp,sp,48
    80002920:	8082                	ret

0000000080002922 <ialloc>:
{
    80002922:	7139                	addi	sp,sp,-64
    80002924:	fc06                	sd	ra,56(sp)
    80002926:	f822                	sd	s0,48(sp)
    80002928:	f426                	sd	s1,40(sp)
    8000292a:	f04a                	sd	s2,32(sp)
    8000292c:	ec4e                	sd	s3,24(sp)
    8000292e:	e852                	sd	s4,16(sp)
    80002930:	e456                	sd	s5,8(sp)
    80002932:	e05a                	sd	s6,0(sp)
    80002934:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002936:	00015717          	auipc	a4,0x15
    8000293a:	c2e72703          	lw	a4,-978(a4) # 80017564 <sb+0xc>
    8000293e:	4785                	li	a5,1
    80002940:	04e7f863          	bgeu	a5,a4,80002990 <ialloc+0x6e>
    80002944:	8aaa                	mv	s5,a0
    80002946:	8b2e                	mv	s6,a1
    80002948:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    8000294a:	00015a17          	auipc	s4,0x15
    8000294e:	c0ea0a13          	addi	s4,s4,-1010 # 80017558 <sb>
    80002952:	00495593          	srli	a1,s2,0x4
    80002956:	018a2783          	lw	a5,24(s4)
    8000295a:	9dbd                	addw	a1,a1,a5
    8000295c:	8556                	mv	a0,s5
    8000295e:	00000097          	auipc	ra,0x0
    80002962:	95e080e7          	jalr	-1698(ra) # 800022bc <bread>
    80002966:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002968:	05850993          	addi	s3,a0,88
    8000296c:	00f97793          	andi	a5,s2,15
    80002970:	079a                	slli	a5,a5,0x6
    80002972:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002974:	00099783          	lh	a5,0(s3)
    80002978:	c785                	beqz	a5,800029a0 <ialloc+0x7e>
    brelse(bp);
    8000297a:	00000097          	auipc	ra,0x0
    8000297e:	a72080e7          	jalr	-1422(ra) # 800023ec <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002982:	0905                	addi	s2,s2,1
    80002984:	00ca2703          	lw	a4,12(s4)
    80002988:	0009079b          	sext.w	a5,s2
    8000298c:	fce7e3e3          	bltu	a5,a4,80002952 <ialloc+0x30>
  panic("ialloc: no inodes");
    80002990:	00006517          	auipc	a0,0x6
    80002994:	aa850513          	addi	a0,a0,-1368 # 80008438 <etext+0x438>
    80002998:	00003097          	auipc	ra,0x3
    8000299c:	316080e7          	jalr	790(ra) # 80005cae <panic>
      memset(dip, 0, sizeof(*dip));
    800029a0:	04000613          	li	a2,64
    800029a4:	4581                	li	a1,0
    800029a6:	854e                	mv	a0,s3
    800029a8:	ffffd097          	auipc	ra,0xffffd
    800029ac:	7d2080e7          	jalr	2002(ra) # 8000017a <memset>
      dip->type = type;
    800029b0:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    800029b4:	8526                	mv	a0,s1
    800029b6:	00001097          	auipc	ra,0x1
    800029ba:	caa080e7          	jalr	-854(ra) # 80003660 <log_write>
      brelse(bp);
    800029be:	8526                	mv	a0,s1
    800029c0:	00000097          	auipc	ra,0x0
    800029c4:	a2c080e7          	jalr	-1492(ra) # 800023ec <brelse>
      return iget(dev, inum);
    800029c8:	0009059b          	sext.w	a1,s2
    800029cc:	8556                	mv	a0,s5
    800029ce:	00000097          	auipc	ra,0x0
    800029d2:	db8080e7          	jalr	-584(ra) # 80002786 <iget>
}
    800029d6:	70e2                	ld	ra,56(sp)
    800029d8:	7442                	ld	s0,48(sp)
    800029da:	74a2                	ld	s1,40(sp)
    800029dc:	7902                	ld	s2,32(sp)
    800029de:	69e2                	ld	s3,24(sp)
    800029e0:	6a42                	ld	s4,16(sp)
    800029e2:	6aa2                	ld	s5,8(sp)
    800029e4:	6b02                	ld	s6,0(sp)
    800029e6:	6121                	addi	sp,sp,64
    800029e8:	8082                	ret

00000000800029ea <iupdate>:
{
    800029ea:	1101                	addi	sp,sp,-32
    800029ec:	ec06                	sd	ra,24(sp)
    800029ee:	e822                	sd	s0,16(sp)
    800029f0:	e426                	sd	s1,8(sp)
    800029f2:	e04a                	sd	s2,0(sp)
    800029f4:	1000                	addi	s0,sp,32
    800029f6:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800029f8:	415c                	lw	a5,4(a0)
    800029fa:	0047d79b          	srliw	a5,a5,0x4
    800029fe:	00015597          	auipc	a1,0x15
    80002a02:	b725a583          	lw	a1,-1166(a1) # 80017570 <sb+0x18>
    80002a06:	9dbd                	addw	a1,a1,a5
    80002a08:	4108                	lw	a0,0(a0)
    80002a0a:	00000097          	auipc	ra,0x0
    80002a0e:	8b2080e7          	jalr	-1870(ra) # 800022bc <bread>
    80002a12:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002a14:	05850793          	addi	a5,a0,88
    80002a18:	40d8                	lw	a4,4(s1)
    80002a1a:	8b3d                	andi	a4,a4,15
    80002a1c:	071a                	slli	a4,a4,0x6
    80002a1e:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002a20:	04449703          	lh	a4,68(s1)
    80002a24:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002a28:	04649703          	lh	a4,70(s1)
    80002a2c:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002a30:	04849703          	lh	a4,72(s1)
    80002a34:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002a38:	04a49703          	lh	a4,74(s1)
    80002a3c:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002a40:	44f8                	lw	a4,76(s1)
    80002a42:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002a44:	03400613          	li	a2,52
    80002a48:	05048593          	addi	a1,s1,80
    80002a4c:	00c78513          	addi	a0,a5,12
    80002a50:	ffffd097          	auipc	ra,0xffffd
    80002a54:	786080e7          	jalr	1926(ra) # 800001d6 <memmove>
  log_write(bp);
    80002a58:	854a                	mv	a0,s2
    80002a5a:	00001097          	auipc	ra,0x1
    80002a5e:	c06080e7          	jalr	-1018(ra) # 80003660 <log_write>
  brelse(bp);
    80002a62:	854a                	mv	a0,s2
    80002a64:	00000097          	auipc	ra,0x0
    80002a68:	988080e7          	jalr	-1656(ra) # 800023ec <brelse>
}
    80002a6c:	60e2                	ld	ra,24(sp)
    80002a6e:	6442                	ld	s0,16(sp)
    80002a70:	64a2                	ld	s1,8(sp)
    80002a72:	6902                	ld	s2,0(sp)
    80002a74:	6105                	addi	sp,sp,32
    80002a76:	8082                	ret

0000000080002a78 <idup>:
{
    80002a78:	1101                	addi	sp,sp,-32
    80002a7a:	ec06                	sd	ra,24(sp)
    80002a7c:	e822                	sd	s0,16(sp)
    80002a7e:	e426                	sd	s1,8(sp)
    80002a80:	1000                	addi	s0,sp,32
    80002a82:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002a84:	00015517          	auipc	a0,0x15
    80002a88:	af450513          	addi	a0,a0,-1292 # 80017578 <itable>
    80002a8c:	00003097          	auipc	ra,0x3
    80002a90:	772080e7          	jalr	1906(ra) # 800061fe <acquire>
  ip->ref++;
    80002a94:	449c                	lw	a5,8(s1)
    80002a96:	2785                	addiw	a5,a5,1
    80002a98:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002a9a:	00015517          	auipc	a0,0x15
    80002a9e:	ade50513          	addi	a0,a0,-1314 # 80017578 <itable>
    80002aa2:	00004097          	auipc	ra,0x4
    80002aa6:	810080e7          	jalr	-2032(ra) # 800062b2 <release>
}
    80002aaa:	8526                	mv	a0,s1
    80002aac:	60e2                	ld	ra,24(sp)
    80002aae:	6442                	ld	s0,16(sp)
    80002ab0:	64a2                	ld	s1,8(sp)
    80002ab2:	6105                	addi	sp,sp,32
    80002ab4:	8082                	ret

0000000080002ab6 <ilock>:
{
    80002ab6:	1101                	addi	sp,sp,-32
    80002ab8:	ec06                	sd	ra,24(sp)
    80002aba:	e822                	sd	s0,16(sp)
    80002abc:	e426                	sd	s1,8(sp)
    80002abe:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002ac0:	c10d                	beqz	a0,80002ae2 <ilock+0x2c>
    80002ac2:	84aa                	mv	s1,a0
    80002ac4:	451c                	lw	a5,8(a0)
    80002ac6:	00f05e63          	blez	a5,80002ae2 <ilock+0x2c>
  acquiresleep(&ip->lock);
    80002aca:	0541                	addi	a0,a0,16
    80002acc:	00001097          	auipc	ra,0x1
    80002ad0:	cb2080e7          	jalr	-846(ra) # 8000377e <acquiresleep>
  if(ip->valid == 0){
    80002ad4:	40bc                	lw	a5,64(s1)
    80002ad6:	cf99                	beqz	a5,80002af4 <ilock+0x3e>
}
    80002ad8:	60e2                	ld	ra,24(sp)
    80002ada:	6442                	ld	s0,16(sp)
    80002adc:	64a2                	ld	s1,8(sp)
    80002ade:	6105                	addi	sp,sp,32
    80002ae0:	8082                	ret
    80002ae2:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80002ae4:	00006517          	auipc	a0,0x6
    80002ae8:	96c50513          	addi	a0,a0,-1684 # 80008450 <etext+0x450>
    80002aec:	00003097          	auipc	ra,0x3
    80002af0:	1c2080e7          	jalr	450(ra) # 80005cae <panic>
    80002af4:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002af6:	40dc                	lw	a5,4(s1)
    80002af8:	0047d79b          	srliw	a5,a5,0x4
    80002afc:	00015597          	auipc	a1,0x15
    80002b00:	a745a583          	lw	a1,-1420(a1) # 80017570 <sb+0x18>
    80002b04:	9dbd                	addw	a1,a1,a5
    80002b06:	4088                	lw	a0,0(s1)
    80002b08:	fffff097          	auipc	ra,0xfffff
    80002b0c:	7b4080e7          	jalr	1972(ra) # 800022bc <bread>
    80002b10:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b12:	05850593          	addi	a1,a0,88
    80002b16:	40dc                	lw	a5,4(s1)
    80002b18:	8bbd                	andi	a5,a5,15
    80002b1a:	079a                	slli	a5,a5,0x6
    80002b1c:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002b1e:	00059783          	lh	a5,0(a1)
    80002b22:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002b26:	00259783          	lh	a5,2(a1)
    80002b2a:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002b2e:	00459783          	lh	a5,4(a1)
    80002b32:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002b36:	00659783          	lh	a5,6(a1)
    80002b3a:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002b3e:	459c                	lw	a5,8(a1)
    80002b40:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002b42:	03400613          	li	a2,52
    80002b46:	05b1                	addi	a1,a1,12
    80002b48:	05048513          	addi	a0,s1,80
    80002b4c:	ffffd097          	auipc	ra,0xffffd
    80002b50:	68a080e7          	jalr	1674(ra) # 800001d6 <memmove>
    brelse(bp);
    80002b54:	854a                	mv	a0,s2
    80002b56:	00000097          	auipc	ra,0x0
    80002b5a:	896080e7          	jalr	-1898(ra) # 800023ec <brelse>
    ip->valid = 1;
    80002b5e:	4785                	li	a5,1
    80002b60:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002b62:	04449783          	lh	a5,68(s1)
    80002b66:	c399                	beqz	a5,80002b6c <ilock+0xb6>
    80002b68:	6902                	ld	s2,0(sp)
    80002b6a:	b7bd                	j	80002ad8 <ilock+0x22>
      panic("ilock: no type");
    80002b6c:	00006517          	auipc	a0,0x6
    80002b70:	8ec50513          	addi	a0,a0,-1812 # 80008458 <etext+0x458>
    80002b74:	00003097          	auipc	ra,0x3
    80002b78:	13a080e7          	jalr	314(ra) # 80005cae <panic>

0000000080002b7c <iunlock>:
{
    80002b7c:	1101                	addi	sp,sp,-32
    80002b7e:	ec06                	sd	ra,24(sp)
    80002b80:	e822                	sd	s0,16(sp)
    80002b82:	e426                	sd	s1,8(sp)
    80002b84:	e04a                	sd	s2,0(sp)
    80002b86:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002b88:	c905                	beqz	a0,80002bb8 <iunlock+0x3c>
    80002b8a:	84aa                	mv	s1,a0
    80002b8c:	01050913          	addi	s2,a0,16
    80002b90:	854a                	mv	a0,s2
    80002b92:	00001097          	auipc	ra,0x1
    80002b96:	c86080e7          	jalr	-890(ra) # 80003818 <holdingsleep>
    80002b9a:	cd19                	beqz	a0,80002bb8 <iunlock+0x3c>
    80002b9c:	449c                	lw	a5,8(s1)
    80002b9e:	00f05d63          	blez	a5,80002bb8 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002ba2:	854a                	mv	a0,s2
    80002ba4:	00001097          	auipc	ra,0x1
    80002ba8:	c30080e7          	jalr	-976(ra) # 800037d4 <releasesleep>
}
    80002bac:	60e2                	ld	ra,24(sp)
    80002bae:	6442                	ld	s0,16(sp)
    80002bb0:	64a2                	ld	s1,8(sp)
    80002bb2:	6902                	ld	s2,0(sp)
    80002bb4:	6105                	addi	sp,sp,32
    80002bb6:	8082                	ret
    panic("iunlock");
    80002bb8:	00006517          	auipc	a0,0x6
    80002bbc:	8b050513          	addi	a0,a0,-1872 # 80008468 <etext+0x468>
    80002bc0:	00003097          	auipc	ra,0x3
    80002bc4:	0ee080e7          	jalr	238(ra) # 80005cae <panic>

0000000080002bc8 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002bc8:	7179                	addi	sp,sp,-48
    80002bca:	f406                	sd	ra,40(sp)
    80002bcc:	f022                	sd	s0,32(sp)
    80002bce:	ec26                	sd	s1,24(sp)
    80002bd0:	e84a                	sd	s2,16(sp)
    80002bd2:	e44e                	sd	s3,8(sp)
    80002bd4:	1800                	addi	s0,sp,48
    80002bd6:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002bd8:	05050493          	addi	s1,a0,80
    80002bdc:	08050913          	addi	s2,a0,128
    80002be0:	a021                	j	80002be8 <itrunc+0x20>
    80002be2:	0491                	addi	s1,s1,4
    80002be4:	01248d63          	beq	s1,s2,80002bfe <itrunc+0x36>
    if(ip->addrs[i]){
    80002be8:	408c                	lw	a1,0(s1)
    80002bea:	dde5                	beqz	a1,80002be2 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80002bec:	0009a503          	lw	a0,0(s3)
    80002bf0:	00000097          	auipc	ra,0x0
    80002bf4:	910080e7          	jalr	-1776(ra) # 80002500 <bfree>
      ip->addrs[i] = 0;
    80002bf8:	0004a023          	sw	zero,0(s1)
    80002bfc:	b7dd                	j	80002be2 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002bfe:	0809a583          	lw	a1,128(s3)
    80002c02:	ed99                	bnez	a1,80002c20 <itrunc+0x58>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002c04:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002c08:	854e                	mv	a0,s3
    80002c0a:	00000097          	auipc	ra,0x0
    80002c0e:	de0080e7          	jalr	-544(ra) # 800029ea <iupdate>
}
    80002c12:	70a2                	ld	ra,40(sp)
    80002c14:	7402                	ld	s0,32(sp)
    80002c16:	64e2                	ld	s1,24(sp)
    80002c18:	6942                	ld	s2,16(sp)
    80002c1a:	69a2                	ld	s3,8(sp)
    80002c1c:	6145                	addi	sp,sp,48
    80002c1e:	8082                	ret
    80002c20:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002c22:	0009a503          	lw	a0,0(s3)
    80002c26:	fffff097          	auipc	ra,0xfffff
    80002c2a:	696080e7          	jalr	1686(ra) # 800022bc <bread>
    80002c2e:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002c30:	05850493          	addi	s1,a0,88
    80002c34:	45850913          	addi	s2,a0,1112
    80002c38:	a021                	j	80002c40 <itrunc+0x78>
    80002c3a:	0491                	addi	s1,s1,4
    80002c3c:	01248b63          	beq	s1,s2,80002c52 <itrunc+0x8a>
      if(a[j])
    80002c40:	408c                	lw	a1,0(s1)
    80002c42:	dde5                	beqz	a1,80002c3a <itrunc+0x72>
        bfree(ip->dev, a[j]);
    80002c44:	0009a503          	lw	a0,0(s3)
    80002c48:	00000097          	auipc	ra,0x0
    80002c4c:	8b8080e7          	jalr	-1864(ra) # 80002500 <bfree>
    80002c50:	b7ed                	j	80002c3a <itrunc+0x72>
    brelse(bp);
    80002c52:	8552                	mv	a0,s4
    80002c54:	fffff097          	auipc	ra,0xfffff
    80002c58:	798080e7          	jalr	1944(ra) # 800023ec <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002c5c:	0809a583          	lw	a1,128(s3)
    80002c60:	0009a503          	lw	a0,0(s3)
    80002c64:	00000097          	auipc	ra,0x0
    80002c68:	89c080e7          	jalr	-1892(ra) # 80002500 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002c6c:	0809a023          	sw	zero,128(s3)
    80002c70:	6a02                	ld	s4,0(sp)
    80002c72:	bf49                	j	80002c04 <itrunc+0x3c>

0000000080002c74 <iput>:
{
    80002c74:	1101                	addi	sp,sp,-32
    80002c76:	ec06                	sd	ra,24(sp)
    80002c78:	e822                	sd	s0,16(sp)
    80002c7a:	e426                	sd	s1,8(sp)
    80002c7c:	1000                	addi	s0,sp,32
    80002c7e:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002c80:	00015517          	auipc	a0,0x15
    80002c84:	8f850513          	addi	a0,a0,-1800 # 80017578 <itable>
    80002c88:	00003097          	auipc	ra,0x3
    80002c8c:	576080e7          	jalr	1398(ra) # 800061fe <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002c90:	4498                	lw	a4,8(s1)
    80002c92:	4785                	li	a5,1
    80002c94:	02f70263          	beq	a4,a5,80002cb8 <iput+0x44>
  ip->ref--;
    80002c98:	449c                	lw	a5,8(s1)
    80002c9a:	37fd                	addiw	a5,a5,-1
    80002c9c:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002c9e:	00015517          	auipc	a0,0x15
    80002ca2:	8da50513          	addi	a0,a0,-1830 # 80017578 <itable>
    80002ca6:	00003097          	auipc	ra,0x3
    80002caa:	60c080e7          	jalr	1548(ra) # 800062b2 <release>
}
    80002cae:	60e2                	ld	ra,24(sp)
    80002cb0:	6442                	ld	s0,16(sp)
    80002cb2:	64a2                	ld	s1,8(sp)
    80002cb4:	6105                	addi	sp,sp,32
    80002cb6:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002cb8:	40bc                	lw	a5,64(s1)
    80002cba:	dff9                	beqz	a5,80002c98 <iput+0x24>
    80002cbc:	04a49783          	lh	a5,74(s1)
    80002cc0:	ffe1                	bnez	a5,80002c98 <iput+0x24>
    80002cc2:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80002cc4:	01048913          	addi	s2,s1,16
    80002cc8:	854a                	mv	a0,s2
    80002cca:	00001097          	auipc	ra,0x1
    80002cce:	ab4080e7          	jalr	-1356(ra) # 8000377e <acquiresleep>
    release(&itable.lock);
    80002cd2:	00015517          	auipc	a0,0x15
    80002cd6:	8a650513          	addi	a0,a0,-1882 # 80017578 <itable>
    80002cda:	00003097          	auipc	ra,0x3
    80002cde:	5d8080e7          	jalr	1496(ra) # 800062b2 <release>
    itrunc(ip);
    80002ce2:	8526                	mv	a0,s1
    80002ce4:	00000097          	auipc	ra,0x0
    80002ce8:	ee4080e7          	jalr	-284(ra) # 80002bc8 <itrunc>
    ip->type = 0;
    80002cec:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002cf0:	8526                	mv	a0,s1
    80002cf2:	00000097          	auipc	ra,0x0
    80002cf6:	cf8080e7          	jalr	-776(ra) # 800029ea <iupdate>
    ip->valid = 0;
    80002cfa:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002cfe:	854a                	mv	a0,s2
    80002d00:	00001097          	auipc	ra,0x1
    80002d04:	ad4080e7          	jalr	-1324(ra) # 800037d4 <releasesleep>
    acquire(&itable.lock);
    80002d08:	00015517          	auipc	a0,0x15
    80002d0c:	87050513          	addi	a0,a0,-1936 # 80017578 <itable>
    80002d10:	00003097          	auipc	ra,0x3
    80002d14:	4ee080e7          	jalr	1262(ra) # 800061fe <acquire>
    80002d18:	6902                	ld	s2,0(sp)
    80002d1a:	bfbd                	j	80002c98 <iput+0x24>

0000000080002d1c <iunlockput>:
{
    80002d1c:	1101                	addi	sp,sp,-32
    80002d1e:	ec06                	sd	ra,24(sp)
    80002d20:	e822                	sd	s0,16(sp)
    80002d22:	e426                	sd	s1,8(sp)
    80002d24:	1000                	addi	s0,sp,32
    80002d26:	84aa                	mv	s1,a0
  iunlock(ip);
    80002d28:	00000097          	auipc	ra,0x0
    80002d2c:	e54080e7          	jalr	-428(ra) # 80002b7c <iunlock>
  iput(ip);
    80002d30:	8526                	mv	a0,s1
    80002d32:	00000097          	auipc	ra,0x0
    80002d36:	f42080e7          	jalr	-190(ra) # 80002c74 <iput>
}
    80002d3a:	60e2                	ld	ra,24(sp)
    80002d3c:	6442                	ld	s0,16(sp)
    80002d3e:	64a2                	ld	s1,8(sp)
    80002d40:	6105                	addi	sp,sp,32
    80002d42:	8082                	ret

0000000080002d44 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002d44:	1141                	addi	sp,sp,-16
    80002d46:	e422                	sd	s0,8(sp)
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
    80002d68:	6422                	ld	s0,8(sp)
    80002d6a:	0141                	addi	sp,sp,16
    80002d6c:	8082                	ret

0000000080002d6e <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002d6e:	457c                	lw	a5,76(a0)
    80002d70:	0ed7ef63          	bltu	a5,a3,80002e6e <readi+0x100>
{
    80002d74:	7159                	addi	sp,sp,-112
    80002d76:	f486                	sd	ra,104(sp)
    80002d78:	f0a2                	sd	s0,96(sp)
    80002d7a:	eca6                	sd	s1,88(sp)
    80002d7c:	fc56                	sd	s5,56(sp)
    80002d7e:	f85a                	sd	s6,48(sp)
    80002d80:	f45e                	sd	s7,40(sp)
    80002d82:	f062                	sd	s8,32(sp)
    80002d84:	1880                	addi	s0,sp,112
    80002d86:	8baa                	mv	s7,a0
    80002d88:	8c2e                	mv	s8,a1
    80002d8a:	8ab2                	mv	s5,a2
    80002d8c:	84b6                	mv	s1,a3
    80002d8e:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002d90:	9f35                	addw	a4,a4,a3
    return 0;
    80002d92:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002d94:	0ad76c63          	bltu	a4,a3,80002e4c <readi+0xde>
    80002d98:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80002d9a:	00e7f463          	bgeu	a5,a4,80002da2 <readi+0x34>
    n = ip->size - off;
    80002d9e:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002da2:	0c0b0463          	beqz	s6,80002e6a <readi+0xfc>
    80002da6:	e8ca                	sd	s2,80(sp)
    80002da8:	e0d2                	sd	s4,64(sp)
    80002daa:	ec66                	sd	s9,24(sp)
    80002dac:	e86a                	sd	s10,16(sp)
    80002dae:	e46e                	sd	s11,8(sp)
    80002db0:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002db2:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002db6:	5cfd                	li	s9,-1
    80002db8:	a82d                	j	80002df2 <readi+0x84>
    80002dba:	020a1d93          	slli	s11,s4,0x20
    80002dbe:	020ddd93          	srli	s11,s11,0x20
    80002dc2:	05890613          	addi	a2,s2,88
    80002dc6:	86ee                	mv	a3,s11
    80002dc8:	963a                	add	a2,a2,a4
    80002dca:	85d6                	mv	a1,s5
    80002dcc:	8562                	mv	a0,s8
    80002dce:	fffff097          	auipc	ra,0xfffff
    80002dd2:	b18080e7          	jalr	-1256(ra) # 800018e6 <either_copyout>
    80002dd6:	05950d63          	beq	a0,s9,80002e30 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002dda:	854a                	mv	a0,s2
    80002ddc:	fffff097          	auipc	ra,0xfffff
    80002de0:	610080e7          	jalr	1552(ra) # 800023ec <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002de4:	013a09bb          	addw	s3,s4,s3
    80002de8:	009a04bb          	addw	s1,s4,s1
    80002dec:	9aee                	add	s5,s5,s11
    80002dee:	0769f863          	bgeu	s3,s6,80002e5e <readi+0xf0>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002df2:	000ba903          	lw	s2,0(s7)
    80002df6:	00a4d59b          	srliw	a1,s1,0xa
    80002dfa:	855e                	mv	a0,s7
    80002dfc:	00000097          	auipc	ra,0x0
    80002e00:	8ae080e7          	jalr	-1874(ra) # 800026aa <bmap>
    80002e04:	0005059b          	sext.w	a1,a0
    80002e08:	854a                	mv	a0,s2
    80002e0a:	fffff097          	auipc	ra,0xfffff
    80002e0e:	4b2080e7          	jalr	1202(ra) # 800022bc <bread>
    80002e12:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002e14:	3ff4f713          	andi	a4,s1,1023
    80002e18:	40ed07bb          	subw	a5,s10,a4
    80002e1c:	413b06bb          	subw	a3,s6,s3
    80002e20:	8a3e                	mv	s4,a5
    80002e22:	2781                	sext.w	a5,a5
    80002e24:	0006861b          	sext.w	a2,a3
    80002e28:	f8f679e3          	bgeu	a2,a5,80002dba <readi+0x4c>
    80002e2c:	8a36                	mv	s4,a3
    80002e2e:	b771                	j	80002dba <readi+0x4c>
      brelse(bp);
    80002e30:	854a                	mv	a0,s2
    80002e32:	fffff097          	auipc	ra,0xfffff
    80002e36:	5ba080e7          	jalr	1466(ra) # 800023ec <brelse>
      tot = -1;
    80002e3a:	59fd                	li	s3,-1
      break;
    80002e3c:	6946                	ld	s2,80(sp)
    80002e3e:	6a06                	ld	s4,64(sp)
    80002e40:	6ce2                	ld	s9,24(sp)
    80002e42:	6d42                	ld	s10,16(sp)
    80002e44:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80002e46:	0009851b          	sext.w	a0,s3
    80002e4a:	69a6                	ld	s3,72(sp)
}
    80002e4c:	70a6                	ld	ra,104(sp)
    80002e4e:	7406                	ld	s0,96(sp)
    80002e50:	64e6                	ld	s1,88(sp)
    80002e52:	7ae2                	ld	s5,56(sp)
    80002e54:	7b42                	ld	s6,48(sp)
    80002e56:	7ba2                	ld	s7,40(sp)
    80002e58:	7c02                	ld	s8,32(sp)
    80002e5a:	6165                	addi	sp,sp,112
    80002e5c:	8082                	ret
    80002e5e:	6946                	ld	s2,80(sp)
    80002e60:	6a06                	ld	s4,64(sp)
    80002e62:	6ce2                	ld	s9,24(sp)
    80002e64:	6d42                	ld	s10,16(sp)
    80002e66:	6da2                	ld	s11,8(sp)
    80002e68:	bff9                	j	80002e46 <readi+0xd8>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002e6a:	89da                	mv	s3,s6
    80002e6c:	bfe9                	j	80002e46 <readi+0xd8>
    return 0;
    80002e6e:	4501                	li	a0,0
}
    80002e70:	8082                	ret

0000000080002e72 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002e72:	457c                	lw	a5,76(a0)
    80002e74:	10d7ee63          	bltu	a5,a3,80002f90 <writei+0x11e>
{
    80002e78:	7159                	addi	sp,sp,-112
    80002e7a:	f486                	sd	ra,104(sp)
    80002e7c:	f0a2                	sd	s0,96(sp)
    80002e7e:	e8ca                	sd	s2,80(sp)
    80002e80:	fc56                	sd	s5,56(sp)
    80002e82:	f85a                	sd	s6,48(sp)
    80002e84:	f45e                	sd	s7,40(sp)
    80002e86:	f062                	sd	s8,32(sp)
    80002e88:	1880                	addi	s0,sp,112
    80002e8a:	8b2a                	mv	s6,a0
    80002e8c:	8c2e                	mv	s8,a1
    80002e8e:	8ab2                	mv	s5,a2
    80002e90:	8936                	mv	s2,a3
    80002e92:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80002e94:	00e687bb          	addw	a5,a3,a4
    80002e98:	0ed7ee63          	bltu	a5,a3,80002f94 <writei+0x122>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002e9c:	00043737          	lui	a4,0x43
    80002ea0:	0ef76c63          	bltu	a4,a5,80002f98 <writei+0x126>
    80002ea4:	e0d2                	sd	s4,64(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002ea6:	0c0b8d63          	beqz	s7,80002f80 <writei+0x10e>
    80002eaa:	eca6                	sd	s1,88(sp)
    80002eac:	e4ce                	sd	s3,72(sp)
    80002eae:	ec66                	sd	s9,24(sp)
    80002eb0:	e86a                	sd	s10,16(sp)
    80002eb2:	e46e                	sd	s11,8(sp)
    80002eb4:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002eb6:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002eba:	5cfd                	li	s9,-1
    80002ebc:	a091                	j	80002f00 <writei+0x8e>
    80002ebe:	02099d93          	slli	s11,s3,0x20
    80002ec2:	020ddd93          	srli	s11,s11,0x20
    80002ec6:	05848513          	addi	a0,s1,88
    80002eca:	86ee                	mv	a3,s11
    80002ecc:	8656                	mv	a2,s5
    80002ece:	85e2                	mv	a1,s8
    80002ed0:	953a                	add	a0,a0,a4
    80002ed2:	fffff097          	auipc	ra,0xfffff
    80002ed6:	a6a080e7          	jalr	-1430(ra) # 8000193c <either_copyin>
    80002eda:	07950263          	beq	a0,s9,80002f3e <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002ede:	8526                	mv	a0,s1
    80002ee0:	00000097          	auipc	ra,0x0
    80002ee4:	780080e7          	jalr	1920(ra) # 80003660 <log_write>
    brelse(bp);
    80002ee8:	8526                	mv	a0,s1
    80002eea:	fffff097          	auipc	ra,0xfffff
    80002eee:	502080e7          	jalr	1282(ra) # 800023ec <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002ef2:	01498a3b          	addw	s4,s3,s4
    80002ef6:	0129893b          	addw	s2,s3,s2
    80002efa:	9aee                	add	s5,s5,s11
    80002efc:	057a7663          	bgeu	s4,s7,80002f48 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002f00:	000b2483          	lw	s1,0(s6)
    80002f04:	00a9559b          	srliw	a1,s2,0xa
    80002f08:	855a                	mv	a0,s6
    80002f0a:	fffff097          	auipc	ra,0xfffff
    80002f0e:	7a0080e7          	jalr	1952(ra) # 800026aa <bmap>
    80002f12:	0005059b          	sext.w	a1,a0
    80002f16:	8526                	mv	a0,s1
    80002f18:	fffff097          	auipc	ra,0xfffff
    80002f1c:	3a4080e7          	jalr	932(ra) # 800022bc <bread>
    80002f20:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f22:	3ff97713          	andi	a4,s2,1023
    80002f26:	40ed07bb          	subw	a5,s10,a4
    80002f2a:	414b86bb          	subw	a3,s7,s4
    80002f2e:	89be                	mv	s3,a5
    80002f30:	2781                	sext.w	a5,a5
    80002f32:	0006861b          	sext.w	a2,a3
    80002f36:	f8f674e3          	bgeu	a2,a5,80002ebe <writei+0x4c>
    80002f3a:	89b6                	mv	s3,a3
    80002f3c:	b749                	j	80002ebe <writei+0x4c>
      brelse(bp);
    80002f3e:	8526                	mv	a0,s1
    80002f40:	fffff097          	auipc	ra,0xfffff
    80002f44:	4ac080e7          	jalr	1196(ra) # 800023ec <brelse>
  }

  if(off > ip->size)
    80002f48:	04cb2783          	lw	a5,76(s6)
    80002f4c:	0327fc63          	bgeu	a5,s2,80002f84 <writei+0x112>
    ip->size = off;
    80002f50:	052b2623          	sw	s2,76(s6)
    80002f54:	64e6                	ld	s1,88(sp)
    80002f56:	69a6                	ld	s3,72(sp)
    80002f58:	6ce2                	ld	s9,24(sp)
    80002f5a:	6d42                	ld	s10,16(sp)
    80002f5c:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002f5e:	855a                	mv	a0,s6
    80002f60:	00000097          	auipc	ra,0x0
    80002f64:	a8a080e7          	jalr	-1398(ra) # 800029ea <iupdate>

  return tot;
    80002f68:	000a051b          	sext.w	a0,s4
    80002f6c:	6a06                	ld	s4,64(sp)
}
    80002f6e:	70a6                	ld	ra,104(sp)
    80002f70:	7406                	ld	s0,96(sp)
    80002f72:	6946                	ld	s2,80(sp)
    80002f74:	7ae2                	ld	s5,56(sp)
    80002f76:	7b42                	ld	s6,48(sp)
    80002f78:	7ba2                	ld	s7,40(sp)
    80002f7a:	7c02                	ld	s8,32(sp)
    80002f7c:	6165                	addi	sp,sp,112
    80002f7e:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002f80:	8a5e                	mv	s4,s7
    80002f82:	bff1                	j	80002f5e <writei+0xec>
    80002f84:	64e6                	ld	s1,88(sp)
    80002f86:	69a6                	ld	s3,72(sp)
    80002f88:	6ce2                	ld	s9,24(sp)
    80002f8a:	6d42                	ld	s10,16(sp)
    80002f8c:	6da2                	ld	s11,8(sp)
    80002f8e:	bfc1                	j	80002f5e <writei+0xec>
    return -1;
    80002f90:	557d                	li	a0,-1
}
    80002f92:	8082                	ret
    return -1;
    80002f94:	557d                	li	a0,-1
    80002f96:	bfe1                	j	80002f6e <writei+0xfc>
    return -1;
    80002f98:	557d                	li	a0,-1
    80002f9a:	bfd1                	j	80002f6e <writei+0xfc>

0000000080002f9c <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002f9c:	1141                	addi	sp,sp,-16
    80002f9e:	e406                	sd	ra,8(sp)
    80002fa0:	e022                	sd	s0,0(sp)
    80002fa2:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002fa4:	4639                	li	a2,14
    80002fa6:	ffffd097          	auipc	ra,0xffffd
    80002faa:	2a4080e7          	jalr	676(ra) # 8000024a <strncmp>
}
    80002fae:	60a2                	ld	ra,8(sp)
    80002fb0:	6402                	ld	s0,0(sp)
    80002fb2:	0141                	addi	sp,sp,16
    80002fb4:	8082                	ret

0000000080002fb6 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80002fb6:	7139                	addi	sp,sp,-64
    80002fb8:	fc06                	sd	ra,56(sp)
    80002fba:	f822                	sd	s0,48(sp)
    80002fbc:	f426                	sd	s1,40(sp)
    80002fbe:	f04a                	sd	s2,32(sp)
    80002fc0:	ec4e                	sd	s3,24(sp)
    80002fc2:	e852                	sd	s4,16(sp)
    80002fc4:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80002fc6:	04451703          	lh	a4,68(a0)
    80002fca:	4785                	li	a5,1
    80002fcc:	00f71a63          	bne	a4,a5,80002fe0 <dirlookup+0x2a>
    80002fd0:	892a                	mv	s2,a0
    80002fd2:	89ae                	mv	s3,a1
    80002fd4:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80002fd6:	457c                	lw	a5,76(a0)
    80002fd8:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002fda:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002fdc:	e79d                	bnez	a5,8000300a <dirlookup+0x54>
    80002fde:	a8a5                	j	80003056 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80002fe0:	00005517          	auipc	a0,0x5
    80002fe4:	49050513          	addi	a0,a0,1168 # 80008470 <etext+0x470>
    80002fe8:	00003097          	auipc	ra,0x3
    80002fec:	cc6080e7          	jalr	-826(ra) # 80005cae <panic>
      panic("dirlookup read");
    80002ff0:	00005517          	auipc	a0,0x5
    80002ff4:	49850513          	addi	a0,a0,1176 # 80008488 <etext+0x488>
    80002ff8:	00003097          	auipc	ra,0x3
    80002ffc:	cb6080e7          	jalr	-842(ra) # 80005cae <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003000:	24c1                	addiw	s1,s1,16
    80003002:	04c92783          	lw	a5,76(s2)
    80003006:	04f4f763          	bgeu	s1,a5,80003054 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000300a:	4741                	li	a4,16
    8000300c:	86a6                	mv	a3,s1
    8000300e:	fc040613          	addi	a2,s0,-64
    80003012:	4581                	li	a1,0
    80003014:	854a                	mv	a0,s2
    80003016:	00000097          	auipc	ra,0x0
    8000301a:	d58080e7          	jalr	-680(ra) # 80002d6e <readi>
    8000301e:	47c1                	li	a5,16
    80003020:	fcf518e3          	bne	a0,a5,80002ff0 <dirlookup+0x3a>
    if(de.inum == 0)
    80003024:	fc045783          	lhu	a5,-64(s0)
    80003028:	dfe1                	beqz	a5,80003000 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    8000302a:	fc240593          	addi	a1,s0,-62
    8000302e:	854e                	mv	a0,s3
    80003030:	00000097          	auipc	ra,0x0
    80003034:	f6c080e7          	jalr	-148(ra) # 80002f9c <namecmp>
    80003038:	f561                	bnez	a0,80003000 <dirlookup+0x4a>
      if(poff)
    8000303a:	000a0463          	beqz	s4,80003042 <dirlookup+0x8c>
        *poff = off;
    8000303e:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003042:	fc045583          	lhu	a1,-64(s0)
    80003046:	00092503          	lw	a0,0(s2)
    8000304a:	fffff097          	auipc	ra,0xfffff
    8000304e:	73c080e7          	jalr	1852(ra) # 80002786 <iget>
    80003052:	a011                	j	80003056 <dirlookup+0xa0>
  return 0;
    80003054:	4501                	li	a0,0
}
    80003056:	70e2                	ld	ra,56(sp)
    80003058:	7442                	ld	s0,48(sp)
    8000305a:	74a2                	ld	s1,40(sp)
    8000305c:	7902                	ld	s2,32(sp)
    8000305e:	69e2                	ld	s3,24(sp)
    80003060:	6a42                	ld	s4,16(sp)
    80003062:	6121                	addi	sp,sp,64
    80003064:	8082                	ret

0000000080003066 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003066:	711d                	addi	sp,sp,-96
    80003068:	ec86                	sd	ra,88(sp)
    8000306a:	e8a2                	sd	s0,80(sp)
    8000306c:	e4a6                	sd	s1,72(sp)
    8000306e:	e0ca                	sd	s2,64(sp)
    80003070:	fc4e                	sd	s3,56(sp)
    80003072:	f852                	sd	s4,48(sp)
    80003074:	f456                	sd	s5,40(sp)
    80003076:	f05a                	sd	s6,32(sp)
    80003078:	ec5e                	sd	s7,24(sp)
    8000307a:	e862                	sd	s8,16(sp)
    8000307c:	e466                	sd	s9,8(sp)
    8000307e:	1080                	addi	s0,sp,96
    80003080:	84aa                	mv	s1,a0
    80003082:	8b2e                	mv	s6,a1
    80003084:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003086:	00054703          	lbu	a4,0(a0)
    8000308a:	02f00793          	li	a5,47
    8000308e:	02f70263          	beq	a4,a5,800030b2 <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003092:	ffffe097          	auipc	ra,0xffffe
    80003096:	dea080e7          	jalr	-534(ra) # 80000e7c <myproc>
    8000309a:	15053503          	ld	a0,336(a0)
    8000309e:	00000097          	auipc	ra,0x0
    800030a2:	9da080e7          	jalr	-1574(ra) # 80002a78 <idup>
    800030a6:	8a2a                	mv	s4,a0
  while(*path == '/')
    800030a8:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    800030ac:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800030ae:	4b85                	li	s7,1
    800030b0:	a875                	j	8000316c <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    800030b2:	4585                	li	a1,1
    800030b4:	4505                	li	a0,1
    800030b6:	fffff097          	auipc	ra,0xfffff
    800030ba:	6d0080e7          	jalr	1744(ra) # 80002786 <iget>
    800030be:	8a2a                	mv	s4,a0
    800030c0:	b7e5                	j	800030a8 <namex+0x42>
      iunlockput(ip);
    800030c2:	8552                	mv	a0,s4
    800030c4:	00000097          	auipc	ra,0x0
    800030c8:	c58080e7          	jalr	-936(ra) # 80002d1c <iunlockput>
      return 0;
    800030cc:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800030ce:	8552                	mv	a0,s4
    800030d0:	60e6                	ld	ra,88(sp)
    800030d2:	6446                	ld	s0,80(sp)
    800030d4:	64a6                	ld	s1,72(sp)
    800030d6:	6906                	ld	s2,64(sp)
    800030d8:	79e2                	ld	s3,56(sp)
    800030da:	7a42                	ld	s4,48(sp)
    800030dc:	7aa2                	ld	s5,40(sp)
    800030de:	7b02                	ld	s6,32(sp)
    800030e0:	6be2                	ld	s7,24(sp)
    800030e2:	6c42                	ld	s8,16(sp)
    800030e4:	6ca2                	ld	s9,8(sp)
    800030e6:	6125                	addi	sp,sp,96
    800030e8:	8082                	ret
      iunlock(ip);
    800030ea:	8552                	mv	a0,s4
    800030ec:	00000097          	auipc	ra,0x0
    800030f0:	a90080e7          	jalr	-1392(ra) # 80002b7c <iunlock>
      return ip;
    800030f4:	bfe9                	j	800030ce <namex+0x68>
      iunlockput(ip);
    800030f6:	8552                	mv	a0,s4
    800030f8:	00000097          	auipc	ra,0x0
    800030fc:	c24080e7          	jalr	-988(ra) # 80002d1c <iunlockput>
      return 0;
    80003100:	8a4e                	mv	s4,s3
    80003102:	b7f1                	j	800030ce <namex+0x68>
  len = path - s;
    80003104:	40998633          	sub	a2,s3,s1
    80003108:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    8000310c:	099c5863          	bge	s8,s9,8000319c <namex+0x136>
    memmove(name, s, DIRSIZ);
    80003110:	4639                	li	a2,14
    80003112:	85a6                	mv	a1,s1
    80003114:	8556                	mv	a0,s5
    80003116:	ffffd097          	auipc	ra,0xffffd
    8000311a:	0c0080e7          	jalr	192(ra) # 800001d6 <memmove>
    8000311e:	84ce                	mv	s1,s3
  while(*path == '/')
    80003120:	0004c783          	lbu	a5,0(s1)
    80003124:	01279763          	bne	a5,s2,80003132 <namex+0xcc>
    path++;
    80003128:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000312a:	0004c783          	lbu	a5,0(s1)
    8000312e:	ff278de3          	beq	a5,s2,80003128 <namex+0xc2>
    ilock(ip);
    80003132:	8552                	mv	a0,s4
    80003134:	00000097          	auipc	ra,0x0
    80003138:	982080e7          	jalr	-1662(ra) # 80002ab6 <ilock>
    if(ip->type != T_DIR){
    8000313c:	044a1783          	lh	a5,68(s4)
    80003140:	f97791e3          	bne	a5,s7,800030c2 <namex+0x5c>
    if(nameiparent && *path == '\0'){
    80003144:	000b0563          	beqz	s6,8000314e <namex+0xe8>
    80003148:	0004c783          	lbu	a5,0(s1)
    8000314c:	dfd9                	beqz	a5,800030ea <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    8000314e:	4601                	li	a2,0
    80003150:	85d6                	mv	a1,s5
    80003152:	8552                	mv	a0,s4
    80003154:	00000097          	auipc	ra,0x0
    80003158:	e62080e7          	jalr	-414(ra) # 80002fb6 <dirlookup>
    8000315c:	89aa                	mv	s3,a0
    8000315e:	dd41                	beqz	a0,800030f6 <namex+0x90>
    iunlockput(ip);
    80003160:	8552                	mv	a0,s4
    80003162:	00000097          	auipc	ra,0x0
    80003166:	bba080e7          	jalr	-1094(ra) # 80002d1c <iunlockput>
    ip = next;
    8000316a:	8a4e                	mv	s4,s3
  while(*path == '/')
    8000316c:	0004c783          	lbu	a5,0(s1)
    80003170:	01279763          	bne	a5,s2,8000317e <namex+0x118>
    path++;
    80003174:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003176:	0004c783          	lbu	a5,0(s1)
    8000317a:	ff278de3          	beq	a5,s2,80003174 <namex+0x10e>
  if(*path == 0)
    8000317e:	cb9d                	beqz	a5,800031b4 <namex+0x14e>
  while(*path != '/' && *path != 0)
    80003180:	0004c783          	lbu	a5,0(s1)
    80003184:	89a6                	mv	s3,s1
  len = path - s;
    80003186:	4c81                	li	s9,0
    80003188:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    8000318a:	01278963          	beq	a5,s2,8000319c <namex+0x136>
    8000318e:	dbbd                	beqz	a5,80003104 <namex+0x9e>
    path++;
    80003190:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80003192:	0009c783          	lbu	a5,0(s3)
    80003196:	ff279ce3          	bne	a5,s2,8000318e <namex+0x128>
    8000319a:	b7ad                	j	80003104 <namex+0x9e>
    memmove(name, s, len);
    8000319c:	2601                	sext.w	a2,a2
    8000319e:	85a6                	mv	a1,s1
    800031a0:	8556                	mv	a0,s5
    800031a2:	ffffd097          	auipc	ra,0xffffd
    800031a6:	034080e7          	jalr	52(ra) # 800001d6 <memmove>
    name[len] = 0;
    800031aa:	9cd6                	add	s9,s9,s5
    800031ac:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    800031b0:	84ce                	mv	s1,s3
    800031b2:	b7bd                	j	80003120 <namex+0xba>
  if(nameiparent){
    800031b4:	f00b0de3          	beqz	s6,800030ce <namex+0x68>
    iput(ip);
    800031b8:	8552                	mv	a0,s4
    800031ba:	00000097          	auipc	ra,0x0
    800031be:	aba080e7          	jalr	-1350(ra) # 80002c74 <iput>
    return 0;
    800031c2:	4a01                	li	s4,0
    800031c4:	b729                	j	800030ce <namex+0x68>

00000000800031c6 <dirlink>:
{
    800031c6:	7139                	addi	sp,sp,-64
    800031c8:	fc06                	sd	ra,56(sp)
    800031ca:	f822                	sd	s0,48(sp)
    800031cc:	f04a                	sd	s2,32(sp)
    800031ce:	ec4e                	sd	s3,24(sp)
    800031d0:	e852                	sd	s4,16(sp)
    800031d2:	0080                	addi	s0,sp,64
    800031d4:	892a                	mv	s2,a0
    800031d6:	8a2e                	mv	s4,a1
    800031d8:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800031da:	4601                	li	a2,0
    800031dc:	00000097          	auipc	ra,0x0
    800031e0:	dda080e7          	jalr	-550(ra) # 80002fb6 <dirlookup>
    800031e4:	ed25                	bnez	a0,8000325c <dirlink+0x96>
    800031e6:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    800031e8:	04c92483          	lw	s1,76(s2)
    800031ec:	c49d                	beqz	s1,8000321a <dirlink+0x54>
    800031ee:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800031f0:	4741                	li	a4,16
    800031f2:	86a6                	mv	a3,s1
    800031f4:	fc040613          	addi	a2,s0,-64
    800031f8:	4581                	li	a1,0
    800031fa:	854a                	mv	a0,s2
    800031fc:	00000097          	auipc	ra,0x0
    80003200:	b72080e7          	jalr	-1166(ra) # 80002d6e <readi>
    80003204:	47c1                	li	a5,16
    80003206:	06f51163          	bne	a0,a5,80003268 <dirlink+0xa2>
    if(de.inum == 0)
    8000320a:	fc045783          	lhu	a5,-64(s0)
    8000320e:	c791                	beqz	a5,8000321a <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003210:	24c1                	addiw	s1,s1,16
    80003212:	04c92783          	lw	a5,76(s2)
    80003216:	fcf4ede3          	bltu	s1,a5,800031f0 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    8000321a:	4639                	li	a2,14
    8000321c:	85d2                	mv	a1,s4
    8000321e:	fc240513          	addi	a0,s0,-62
    80003222:	ffffd097          	auipc	ra,0xffffd
    80003226:	05e080e7          	jalr	94(ra) # 80000280 <strncpy>
  de.inum = inum;
    8000322a:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000322e:	4741                	li	a4,16
    80003230:	86a6                	mv	a3,s1
    80003232:	fc040613          	addi	a2,s0,-64
    80003236:	4581                	li	a1,0
    80003238:	854a                	mv	a0,s2
    8000323a:	00000097          	auipc	ra,0x0
    8000323e:	c38080e7          	jalr	-968(ra) # 80002e72 <writei>
    80003242:	872a                	mv	a4,a0
    80003244:	47c1                	li	a5,16
  return 0;
    80003246:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003248:	02f71863          	bne	a4,a5,80003278 <dirlink+0xb2>
    8000324c:	74a2                	ld	s1,40(sp)
}
    8000324e:	70e2                	ld	ra,56(sp)
    80003250:	7442                	ld	s0,48(sp)
    80003252:	7902                	ld	s2,32(sp)
    80003254:	69e2                	ld	s3,24(sp)
    80003256:	6a42                	ld	s4,16(sp)
    80003258:	6121                	addi	sp,sp,64
    8000325a:	8082                	ret
    iput(ip);
    8000325c:	00000097          	auipc	ra,0x0
    80003260:	a18080e7          	jalr	-1512(ra) # 80002c74 <iput>
    return -1;
    80003264:	557d                	li	a0,-1
    80003266:	b7e5                	j	8000324e <dirlink+0x88>
      panic("dirlink read");
    80003268:	00005517          	auipc	a0,0x5
    8000326c:	23050513          	addi	a0,a0,560 # 80008498 <etext+0x498>
    80003270:	00003097          	auipc	ra,0x3
    80003274:	a3e080e7          	jalr	-1474(ra) # 80005cae <panic>
    panic("dirlink");
    80003278:	00005517          	auipc	a0,0x5
    8000327c:	33050513          	addi	a0,a0,816 # 800085a8 <etext+0x5a8>
    80003280:	00003097          	auipc	ra,0x3
    80003284:	a2e080e7          	jalr	-1490(ra) # 80005cae <panic>

0000000080003288 <namei>:

struct inode*
namei(char *path)
{
    80003288:	1101                	addi	sp,sp,-32
    8000328a:	ec06                	sd	ra,24(sp)
    8000328c:	e822                	sd	s0,16(sp)
    8000328e:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003290:	fe040613          	addi	a2,s0,-32
    80003294:	4581                	li	a1,0
    80003296:	00000097          	auipc	ra,0x0
    8000329a:	dd0080e7          	jalr	-560(ra) # 80003066 <namex>
}
    8000329e:	60e2                	ld	ra,24(sp)
    800032a0:	6442                	ld	s0,16(sp)
    800032a2:	6105                	addi	sp,sp,32
    800032a4:	8082                	ret

00000000800032a6 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800032a6:	1141                	addi	sp,sp,-16
    800032a8:	e406                	sd	ra,8(sp)
    800032aa:	e022                	sd	s0,0(sp)
    800032ac:	0800                	addi	s0,sp,16
    800032ae:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800032b0:	4585                	li	a1,1
    800032b2:	00000097          	auipc	ra,0x0
    800032b6:	db4080e7          	jalr	-588(ra) # 80003066 <namex>
}
    800032ba:	60a2                	ld	ra,8(sp)
    800032bc:	6402                	ld	s0,0(sp)
    800032be:	0141                	addi	sp,sp,16
    800032c0:	8082                	ret

00000000800032c2 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800032c2:	1101                	addi	sp,sp,-32
    800032c4:	ec06                	sd	ra,24(sp)
    800032c6:	e822                	sd	s0,16(sp)
    800032c8:	e426                	sd	s1,8(sp)
    800032ca:	e04a                	sd	s2,0(sp)
    800032cc:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800032ce:	00016917          	auipc	s2,0x16
    800032d2:	d5290913          	addi	s2,s2,-686 # 80019020 <log>
    800032d6:	01892583          	lw	a1,24(s2)
    800032da:	02892503          	lw	a0,40(s2)
    800032de:	fffff097          	auipc	ra,0xfffff
    800032e2:	fde080e7          	jalr	-34(ra) # 800022bc <bread>
    800032e6:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800032e8:	02c92603          	lw	a2,44(s2)
    800032ec:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800032ee:	00c05f63          	blez	a2,8000330c <write_head+0x4a>
    800032f2:	00016717          	auipc	a4,0x16
    800032f6:	d5e70713          	addi	a4,a4,-674 # 80019050 <log+0x30>
    800032fa:	87aa                	mv	a5,a0
    800032fc:	060a                	slli	a2,a2,0x2
    800032fe:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003300:	4314                	lw	a3,0(a4)
    80003302:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003304:	0711                	addi	a4,a4,4
    80003306:	0791                	addi	a5,a5,4
    80003308:	fec79ce3          	bne	a5,a2,80003300 <write_head+0x3e>
  }
  bwrite(buf);
    8000330c:	8526                	mv	a0,s1
    8000330e:	fffff097          	auipc	ra,0xfffff
    80003312:	0a0080e7          	jalr	160(ra) # 800023ae <bwrite>
  brelse(buf);
    80003316:	8526                	mv	a0,s1
    80003318:	fffff097          	auipc	ra,0xfffff
    8000331c:	0d4080e7          	jalr	212(ra) # 800023ec <brelse>
}
    80003320:	60e2                	ld	ra,24(sp)
    80003322:	6442                	ld	s0,16(sp)
    80003324:	64a2                	ld	s1,8(sp)
    80003326:	6902                	ld	s2,0(sp)
    80003328:	6105                	addi	sp,sp,32
    8000332a:	8082                	ret

000000008000332c <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000332c:	00016797          	auipc	a5,0x16
    80003330:	d207a783          	lw	a5,-736(a5) # 8001904c <log+0x2c>
    80003334:	0af05d63          	blez	a5,800033ee <install_trans+0xc2>
{
    80003338:	7139                	addi	sp,sp,-64
    8000333a:	fc06                	sd	ra,56(sp)
    8000333c:	f822                	sd	s0,48(sp)
    8000333e:	f426                	sd	s1,40(sp)
    80003340:	f04a                	sd	s2,32(sp)
    80003342:	ec4e                	sd	s3,24(sp)
    80003344:	e852                	sd	s4,16(sp)
    80003346:	e456                	sd	s5,8(sp)
    80003348:	e05a                	sd	s6,0(sp)
    8000334a:	0080                	addi	s0,sp,64
    8000334c:	8b2a                	mv	s6,a0
    8000334e:	00016a97          	auipc	s5,0x16
    80003352:	d02a8a93          	addi	s5,s5,-766 # 80019050 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003356:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003358:	00016997          	auipc	s3,0x16
    8000335c:	cc898993          	addi	s3,s3,-824 # 80019020 <log>
    80003360:	a00d                	j	80003382 <install_trans+0x56>
    brelse(lbuf);
    80003362:	854a                	mv	a0,s2
    80003364:	fffff097          	auipc	ra,0xfffff
    80003368:	088080e7          	jalr	136(ra) # 800023ec <brelse>
    brelse(dbuf);
    8000336c:	8526                	mv	a0,s1
    8000336e:	fffff097          	auipc	ra,0xfffff
    80003372:	07e080e7          	jalr	126(ra) # 800023ec <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003376:	2a05                	addiw	s4,s4,1
    80003378:	0a91                	addi	s5,s5,4
    8000337a:	02c9a783          	lw	a5,44(s3)
    8000337e:	04fa5e63          	bge	s4,a5,800033da <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003382:	0189a583          	lw	a1,24(s3)
    80003386:	014585bb          	addw	a1,a1,s4
    8000338a:	2585                	addiw	a1,a1,1
    8000338c:	0289a503          	lw	a0,40(s3)
    80003390:	fffff097          	auipc	ra,0xfffff
    80003394:	f2c080e7          	jalr	-212(ra) # 800022bc <bread>
    80003398:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000339a:	000aa583          	lw	a1,0(s5)
    8000339e:	0289a503          	lw	a0,40(s3)
    800033a2:	fffff097          	auipc	ra,0xfffff
    800033a6:	f1a080e7          	jalr	-230(ra) # 800022bc <bread>
    800033aa:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800033ac:	40000613          	li	a2,1024
    800033b0:	05890593          	addi	a1,s2,88
    800033b4:	05850513          	addi	a0,a0,88
    800033b8:	ffffd097          	auipc	ra,0xffffd
    800033bc:	e1e080e7          	jalr	-482(ra) # 800001d6 <memmove>
    bwrite(dbuf);  // write dst to disk
    800033c0:	8526                	mv	a0,s1
    800033c2:	fffff097          	auipc	ra,0xfffff
    800033c6:	fec080e7          	jalr	-20(ra) # 800023ae <bwrite>
    if(recovering == 0)
    800033ca:	f80b1ce3          	bnez	s6,80003362 <install_trans+0x36>
      bunpin(dbuf);
    800033ce:	8526                	mv	a0,s1
    800033d0:	fffff097          	auipc	ra,0xfffff
    800033d4:	0f4080e7          	jalr	244(ra) # 800024c4 <bunpin>
    800033d8:	b769                	j	80003362 <install_trans+0x36>
}
    800033da:	70e2                	ld	ra,56(sp)
    800033dc:	7442                	ld	s0,48(sp)
    800033de:	74a2                	ld	s1,40(sp)
    800033e0:	7902                	ld	s2,32(sp)
    800033e2:	69e2                	ld	s3,24(sp)
    800033e4:	6a42                	ld	s4,16(sp)
    800033e6:	6aa2                	ld	s5,8(sp)
    800033e8:	6b02                	ld	s6,0(sp)
    800033ea:	6121                	addi	sp,sp,64
    800033ec:	8082                	ret
    800033ee:	8082                	ret

00000000800033f0 <initlog>:
{
    800033f0:	7179                	addi	sp,sp,-48
    800033f2:	f406                	sd	ra,40(sp)
    800033f4:	f022                	sd	s0,32(sp)
    800033f6:	ec26                	sd	s1,24(sp)
    800033f8:	e84a                	sd	s2,16(sp)
    800033fa:	e44e                	sd	s3,8(sp)
    800033fc:	1800                	addi	s0,sp,48
    800033fe:	892a                	mv	s2,a0
    80003400:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003402:	00016497          	auipc	s1,0x16
    80003406:	c1e48493          	addi	s1,s1,-994 # 80019020 <log>
    8000340a:	00005597          	auipc	a1,0x5
    8000340e:	09e58593          	addi	a1,a1,158 # 800084a8 <etext+0x4a8>
    80003412:	8526                	mv	a0,s1
    80003414:	00003097          	auipc	ra,0x3
    80003418:	d5a080e7          	jalr	-678(ra) # 8000616e <initlock>
  log.start = sb->logstart;
    8000341c:	0149a583          	lw	a1,20(s3)
    80003420:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003422:	0109a783          	lw	a5,16(s3)
    80003426:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003428:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000342c:	854a                	mv	a0,s2
    8000342e:	fffff097          	auipc	ra,0xfffff
    80003432:	e8e080e7          	jalr	-370(ra) # 800022bc <bread>
  log.lh.n = lh->n;
    80003436:	4d30                	lw	a2,88(a0)
    80003438:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000343a:	00c05f63          	blez	a2,80003458 <initlog+0x68>
    8000343e:	87aa                	mv	a5,a0
    80003440:	00016717          	auipc	a4,0x16
    80003444:	c1070713          	addi	a4,a4,-1008 # 80019050 <log+0x30>
    80003448:	060a                	slli	a2,a2,0x2
    8000344a:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    8000344c:	4ff4                	lw	a3,92(a5)
    8000344e:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003450:	0791                	addi	a5,a5,4
    80003452:	0711                	addi	a4,a4,4
    80003454:	fec79ce3          	bne	a5,a2,8000344c <initlog+0x5c>
  brelse(buf);
    80003458:	fffff097          	auipc	ra,0xfffff
    8000345c:	f94080e7          	jalr	-108(ra) # 800023ec <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003460:	4505                	li	a0,1
    80003462:	00000097          	auipc	ra,0x0
    80003466:	eca080e7          	jalr	-310(ra) # 8000332c <install_trans>
  log.lh.n = 0;
    8000346a:	00016797          	auipc	a5,0x16
    8000346e:	be07a123          	sw	zero,-1054(a5) # 8001904c <log+0x2c>
  write_head(); // clear the log
    80003472:	00000097          	auipc	ra,0x0
    80003476:	e50080e7          	jalr	-432(ra) # 800032c2 <write_head>
}
    8000347a:	70a2                	ld	ra,40(sp)
    8000347c:	7402                	ld	s0,32(sp)
    8000347e:	64e2                	ld	s1,24(sp)
    80003480:	6942                	ld	s2,16(sp)
    80003482:	69a2                	ld	s3,8(sp)
    80003484:	6145                	addi	sp,sp,48
    80003486:	8082                	ret

0000000080003488 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003488:	1101                	addi	sp,sp,-32
    8000348a:	ec06                	sd	ra,24(sp)
    8000348c:	e822                	sd	s0,16(sp)
    8000348e:	e426                	sd	s1,8(sp)
    80003490:	e04a                	sd	s2,0(sp)
    80003492:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003494:	00016517          	auipc	a0,0x16
    80003498:	b8c50513          	addi	a0,a0,-1140 # 80019020 <log>
    8000349c:	00003097          	auipc	ra,0x3
    800034a0:	d62080e7          	jalr	-670(ra) # 800061fe <acquire>
  while(1){
    if(log.committing){
    800034a4:	00016497          	auipc	s1,0x16
    800034a8:	b7c48493          	addi	s1,s1,-1156 # 80019020 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800034ac:	4979                	li	s2,30
    800034ae:	a039                	j	800034bc <begin_op+0x34>
      sleep(&log, &log.lock);
    800034b0:	85a6                	mv	a1,s1
    800034b2:	8526                	mv	a0,s1
    800034b4:	ffffe097          	auipc	ra,0xffffe
    800034b8:	08e080e7          	jalr	142(ra) # 80001542 <sleep>
    if(log.committing){
    800034bc:	50dc                	lw	a5,36(s1)
    800034be:	fbed                	bnez	a5,800034b0 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800034c0:	5098                	lw	a4,32(s1)
    800034c2:	2705                	addiw	a4,a4,1
    800034c4:	0027179b          	slliw	a5,a4,0x2
    800034c8:	9fb9                	addw	a5,a5,a4
    800034ca:	0017979b          	slliw	a5,a5,0x1
    800034ce:	54d4                	lw	a3,44(s1)
    800034d0:	9fb5                	addw	a5,a5,a3
    800034d2:	00f95963          	bge	s2,a5,800034e4 <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800034d6:	85a6                	mv	a1,s1
    800034d8:	8526                	mv	a0,s1
    800034da:	ffffe097          	auipc	ra,0xffffe
    800034de:	068080e7          	jalr	104(ra) # 80001542 <sleep>
    800034e2:	bfe9                	j	800034bc <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800034e4:	00016517          	auipc	a0,0x16
    800034e8:	b3c50513          	addi	a0,a0,-1220 # 80019020 <log>
    800034ec:	d118                	sw	a4,32(a0)
      release(&log.lock);
    800034ee:	00003097          	auipc	ra,0x3
    800034f2:	dc4080e7          	jalr	-572(ra) # 800062b2 <release>
      break;
    }
  }
}
    800034f6:	60e2                	ld	ra,24(sp)
    800034f8:	6442                	ld	s0,16(sp)
    800034fa:	64a2                	ld	s1,8(sp)
    800034fc:	6902                	ld	s2,0(sp)
    800034fe:	6105                	addi	sp,sp,32
    80003500:	8082                	ret

0000000080003502 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003502:	7139                	addi	sp,sp,-64
    80003504:	fc06                	sd	ra,56(sp)
    80003506:	f822                	sd	s0,48(sp)
    80003508:	f426                	sd	s1,40(sp)
    8000350a:	f04a                	sd	s2,32(sp)
    8000350c:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000350e:	00016497          	auipc	s1,0x16
    80003512:	b1248493          	addi	s1,s1,-1262 # 80019020 <log>
    80003516:	8526                	mv	a0,s1
    80003518:	00003097          	auipc	ra,0x3
    8000351c:	ce6080e7          	jalr	-794(ra) # 800061fe <acquire>
  log.outstanding -= 1;
    80003520:	509c                	lw	a5,32(s1)
    80003522:	37fd                	addiw	a5,a5,-1
    80003524:	0007891b          	sext.w	s2,a5
    80003528:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000352a:	50dc                	lw	a5,36(s1)
    8000352c:	e7b9                	bnez	a5,8000357a <end_op+0x78>
    panic("log.committing");
  if(log.outstanding == 0){
    8000352e:	06091163          	bnez	s2,80003590 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80003532:	00016497          	auipc	s1,0x16
    80003536:	aee48493          	addi	s1,s1,-1298 # 80019020 <log>
    8000353a:	4785                	li	a5,1
    8000353c:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000353e:	8526                	mv	a0,s1
    80003540:	00003097          	auipc	ra,0x3
    80003544:	d72080e7          	jalr	-654(ra) # 800062b2 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003548:	54dc                	lw	a5,44(s1)
    8000354a:	06f04763          	bgtz	a5,800035b8 <end_op+0xb6>
    acquire(&log.lock);
    8000354e:	00016497          	auipc	s1,0x16
    80003552:	ad248493          	addi	s1,s1,-1326 # 80019020 <log>
    80003556:	8526                	mv	a0,s1
    80003558:	00003097          	auipc	ra,0x3
    8000355c:	ca6080e7          	jalr	-858(ra) # 800061fe <acquire>
    log.committing = 0;
    80003560:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003564:	8526                	mv	a0,s1
    80003566:	ffffe097          	auipc	ra,0xffffe
    8000356a:	168080e7          	jalr	360(ra) # 800016ce <wakeup>
    release(&log.lock);
    8000356e:	8526                	mv	a0,s1
    80003570:	00003097          	auipc	ra,0x3
    80003574:	d42080e7          	jalr	-702(ra) # 800062b2 <release>
}
    80003578:	a815                	j	800035ac <end_op+0xaa>
    8000357a:	ec4e                	sd	s3,24(sp)
    8000357c:	e852                	sd	s4,16(sp)
    8000357e:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80003580:	00005517          	auipc	a0,0x5
    80003584:	f3050513          	addi	a0,a0,-208 # 800084b0 <etext+0x4b0>
    80003588:	00002097          	auipc	ra,0x2
    8000358c:	726080e7          	jalr	1830(ra) # 80005cae <panic>
    wakeup(&log);
    80003590:	00016497          	auipc	s1,0x16
    80003594:	a9048493          	addi	s1,s1,-1392 # 80019020 <log>
    80003598:	8526                	mv	a0,s1
    8000359a:	ffffe097          	auipc	ra,0xffffe
    8000359e:	134080e7          	jalr	308(ra) # 800016ce <wakeup>
  release(&log.lock);
    800035a2:	8526                	mv	a0,s1
    800035a4:	00003097          	auipc	ra,0x3
    800035a8:	d0e080e7          	jalr	-754(ra) # 800062b2 <release>
}
    800035ac:	70e2                	ld	ra,56(sp)
    800035ae:	7442                	ld	s0,48(sp)
    800035b0:	74a2                	ld	s1,40(sp)
    800035b2:	7902                	ld	s2,32(sp)
    800035b4:	6121                	addi	sp,sp,64
    800035b6:	8082                	ret
    800035b8:	ec4e                	sd	s3,24(sp)
    800035ba:	e852                	sd	s4,16(sp)
    800035bc:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    800035be:	00016a97          	auipc	s5,0x16
    800035c2:	a92a8a93          	addi	s5,s5,-1390 # 80019050 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800035c6:	00016a17          	auipc	s4,0x16
    800035ca:	a5aa0a13          	addi	s4,s4,-1446 # 80019020 <log>
    800035ce:	018a2583          	lw	a1,24(s4)
    800035d2:	012585bb          	addw	a1,a1,s2
    800035d6:	2585                	addiw	a1,a1,1
    800035d8:	028a2503          	lw	a0,40(s4)
    800035dc:	fffff097          	auipc	ra,0xfffff
    800035e0:	ce0080e7          	jalr	-800(ra) # 800022bc <bread>
    800035e4:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800035e6:	000aa583          	lw	a1,0(s5)
    800035ea:	028a2503          	lw	a0,40(s4)
    800035ee:	fffff097          	auipc	ra,0xfffff
    800035f2:	cce080e7          	jalr	-818(ra) # 800022bc <bread>
    800035f6:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800035f8:	40000613          	li	a2,1024
    800035fc:	05850593          	addi	a1,a0,88
    80003600:	05848513          	addi	a0,s1,88
    80003604:	ffffd097          	auipc	ra,0xffffd
    80003608:	bd2080e7          	jalr	-1070(ra) # 800001d6 <memmove>
    bwrite(to);  // write the log
    8000360c:	8526                	mv	a0,s1
    8000360e:	fffff097          	auipc	ra,0xfffff
    80003612:	da0080e7          	jalr	-608(ra) # 800023ae <bwrite>
    brelse(from);
    80003616:	854e                	mv	a0,s3
    80003618:	fffff097          	auipc	ra,0xfffff
    8000361c:	dd4080e7          	jalr	-556(ra) # 800023ec <brelse>
    brelse(to);
    80003620:	8526                	mv	a0,s1
    80003622:	fffff097          	auipc	ra,0xfffff
    80003626:	dca080e7          	jalr	-566(ra) # 800023ec <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000362a:	2905                	addiw	s2,s2,1
    8000362c:	0a91                	addi	s5,s5,4
    8000362e:	02ca2783          	lw	a5,44(s4)
    80003632:	f8f94ee3          	blt	s2,a5,800035ce <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003636:	00000097          	auipc	ra,0x0
    8000363a:	c8c080e7          	jalr	-884(ra) # 800032c2 <write_head>
    install_trans(0); // Now install writes to home locations
    8000363e:	4501                	li	a0,0
    80003640:	00000097          	auipc	ra,0x0
    80003644:	cec080e7          	jalr	-788(ra) # 8000332c <install_trans>
    log.lh.n = 0;
    80003648:	00016797          	auipc	a5,0x16
    8000364c:	a007a223          	sw	zero,-1532(a5) # 8001904c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003650:	00000097          	auipc	ra,0x0
    80003654:	c72080e7          	jalr	-910(ra) # 800032c2 <write_head>
    80003658:	69e2                	ld	s3,24(sp)
    8000365a:	6a42                	ld	s4,16(sp)
    8000365c:	6aa2                	ld	s5,8(sp)
    8000365e:	bdc5                	j	8000354e <end_op+0x4c>

0000000080003660 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003660:	1101                	addi	sp,sp,-32
    80003662:	ec06                	sd	ra,24(sp)
    80003664:	e822                	sd	s0,16(sp)
    80003666:	e426                	sd	s1,8(sp)
    80003668:	e04a                	sd	s2,0(sp)
    8000366a:	1000                	addi	s0,sp,32
    8000366c:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000366e:	00016917          	auipc	s2,0x16
    80003672:	9b290913          	addi	s2,s2,-1614 # 80019020 <log>
    80003676:	854a                	mv	a0,s2
    80003678:	00003097          	auipc	ra,0x3
    8000367c:	b86080e7          	jalr	-1146(ra) # 800061fe <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003680:	02c92603          	lw	a2,44(s2)
    80003684:	47f5                	li	a5,29
    80003686:	06c7c563          	blt	a5,a2,800036f0 <log_write+0x90>
    8000368a:	00016797          	auipc	a5,0x16
    8000368e:	9b27a783          	lw	a5,-1614(a5) # 8001903c <log+0x1c>
    80003692:	37fd                	addiw	a5,a5,-1
    80003694:	04f65e63          	bge	a2,a5,800036f0 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003698:	00016797          	auipc	a5,0x16
    8000369c:	9a87a783          	lw	a5,-1624(a5) # 80019040 <log+0x20>
    800036a0:	06f05063          	blez	a5,80003700 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800036a4:	4781                	li	a5,0
    800036a6:	06c05563          	blez	a2,80003710 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800036aa:	44cc                	lw	a1,12(s1)
    800036ac:	00016717          	auipc	a4,0x16
    800036b0:	9a470713          	addi	a4,a4,-1628 # 80019050 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800036b4:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800036b6:	4314                	lw	a3,0(a4)
    800036b8:	04b68c63          	beq	a3,a1,80003710 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800036bc:	2785                	addiw	a5,a5,1
    800036be:	0711                	addi	a4,a4,4
    800036c0:	fef61be3          	bne	a2,a5,800036b6 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800036c4:	0621                	addi	a2,a2,8
    800036c6:	060a                	slli	a2,a2,0x2
    800036c8:	00016797          	auipc	a5,0x16
    800036cc:	95878793          	addi	a5,a5,-1704 # 80019020 <log>
    800036d0:	97b2                	add	a5,a5,a2
    800036d2:	44d8                	lw	a4,12(s1)
    800036d4:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800036d6:	8526                	mv	a0,s1
    800036d8:	fffff097          	auipc	ra,0xfffff
    800036dc:	db0080e7          	jalr	-592(ra) # 80002488 <bpin>
    log.lh.n++;
    800036e0:	00016717          	auipc	a4,0x16
    800036e4:	94070713          	addi	a4,a4,-1728 # 80019020 <log>
    800036e8:	575c                	lw	a5,44(a4)
    800036ea:	2785                	addiw	a5,a5,1
    800036ec:	d75c                	sw	a5,44(a4)
    800036ee:	a82d                	j	80003728 <log_write+0xc8>
    panic("too big a transaction");
    800036f0:	00005517          	auipc	a0,0x5
    800036f4:	dd050513          	addi	a0,a0,-560 # 800084c0 <etext+0x4c0>
    800036f8:	00002097          	auipc	ra,0x2
    800036fc:	5b6080e7          	jalr	1462(ra) # 80005cae <panic>
    panic("log_write outside of trans");
    80003700:	00005517          	auipc	a0,0x5
    80003704:	dd850513          	addi	a0,a0,-552 # 800084d8 <etext+0x4d8>
    80003708:	00002097          	auipc	ra,0x2
    8000370c:	5a6080e7          	jalr	1446(ra) # 80005cae <panic>
  log.lh.block[i] = b->blockno;
    80003710:	00878693          	addi	a3,a5,8
    80003714:	068a                	slli	a3,a3,0x2
    80003716:	00016717          	auipc	a4,0x16
    8000371a:	90a70713          	addi	a4,a4,-1782 # 80019020 <log>
    8000371e:	9736                	add	a4,a4,a3
    80003720:	44d4                	lw	a3,12(s1)
    80003722:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003724:	faf609e3          	beq	a2,a5,800036d6 <log_write+0x76>
  }
  release(&log.lock);
    80003728:	00016517          	auipc	a0,0x16
    8000372c:	8f850513          	addi	a0,a0,-1800 # 80019020 <log>
    80003730:	00003097          	auipc	ra,0x3
    80003734:	b82080e7          	jalr	-1150(ra) # 800062b2 <release>
}
    80003738:	60e2                	ld	ra,24(sp)
    8000373a:	6442                	ld	s0,16(sp)
    8000373c:	64a2                	ld	s1,8(sp)
    8000373e:	6902                	ld	s2,0(sp)
    80003740:	6105                	addi	sp,sp,32
    80003742:	8082                	ret

0000000080003744 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003744:	1101                	addi	sp,sp,-32
    80003746:	ec06                	sd	ra,24(sp)
    80003748:	e822                	sd	s0,16(sp)
    8000374a:	e426                	sd	s1,8(sp)
    8000374c:	e04a                	sd	s2,0(sp)
    8000374e:	1000                	addi	s0,sp,32
    80003750:	84aa                	mv	s1,a0
    80003752:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003754:	00005597          	auipc	a1,0x5
    80003758:	da458593          	addi	a1,a1,-604 # 800084f8 <etext+0x4f8>
    8000375c:	0521                	addi	a0,a0,8
    8000375e:	00003097          	auipc	ra,0x3
    80003762:	a10080e7          	jalr	-1520(ra) # 8000616e <initlock>
  lk->name = name;
    80003766:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000376a:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000376e:	0204a423          	sw	zero,40(s1)
}
    80003772:	60e2                	ld	ra,24(sp)
    80003774:	6442                	ld	s0,16(sp)
    80003776:	64a2                	ld	s1,8(sp)
    80003778:	6902                	ld	s2,0(sp)
    8000377a:	6105                	addi	sp,sp,32
    8000377c:	8082                	ret

000000008000377e <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000377e:	1101                	addi	sp,sp,-32
    80003780:	ec06                	sd	ra,24(sp)
    80003782:	e822                	sd	s0,16(sp)
    80003784:	e426                	sd	s1,8(sp)
    80003786:	e04a                	sd	s2,0(sp)
    80003788:	1000                	addi	s0,sp,32
    8000378a:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000378c:	00850913          	addi	s2,a0,8
    80003790:	854a                	mv	a0,s2
    80003792:	00003097          	auipc	ra,0x3
    80003796:	a6c080e7          	jalr	-1428(ra) # 800061fe <acquire>
  while (lk->locked) {
    8000379a:	409c                	lw	a5,0(s1)
    8000379c:	cb89                	beqz	a5,800037ae <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    8000379e:	85ca                	mv	a1,s2
    800037a0:	8526                	mv	a0,s1
    800037a2:	ffffe097          	auipc	ra,0xffffe
    800037a6:	da0080e7          	jalr	-608(ra) # 80001542 <sleep>
  while (lk->locked) {
    800037aa:	409c                	lw	a5,0(s1)
    800037ac:	fbed                	bnez	a5,8000379e <acquiresleep+0x20>
  }
  lk->locked = 1;
    800037ae:	4785                	li	a5,1
    800037b0:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800037b2:	ffffd097          	auipc	ra,0xffffd
    800037b6:	6ca080e7          	jalr	1738(ra) # 80000e7c <myproc>
    800037ba:	591c                	lw	a5,48(a0)
    800037bc:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800037be:	854a                	mv	a0,s2
    800037c0:	00003097          	auipc	ra,0x3
    800037c4:	af2080e7          	jalr	-1294(ra) # 800062b2 <release>
}
    800037c8:	60e2                	ld	ra,24(sp)
    800037ca:	6442                	ld	s0,16(sp)
    800037cc:	64a2                	ld	s1,8(sp)
    800037ce:	6902                	ld	s2,0(sp)
    800037d0:	6105                	addi	sp,sp,32
    800037d2:	8082                	ret

00000000800037d4 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800037d4:	1101                	addi	sp,sp,-32
    800037d6:	ec06                	sd	ra,24(sp)
    800037d8:	e822                	sd	s0,16(sp)
    800037da:	e426                	sd	s1,8(sp)
    800037dc:	e04a                	sd	s2,0(sp)
    800037de:	1000                	addi	s0,sp,32
    800037e0:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800037e2:	00850913          	addi	s2,a0,8
    800037e6:	854a                	mv	a0,s2
    800037e8:	00003097          	auipc	ra,0x3
    800037ec:	a16080e7          	jalr	-1514(ra) # 800061fe <acquire>
  lk->locked = 0;
    800037f0:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800037f4:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800037f8:	8526                	mv	a0,s1
    800037fa:	ffffe097          	auipc	ra,0xffffe
    800037fe:	ed4080e7          	jalr	-300(ra) # 800016ce <wakeup>
  release(&lk->lk);
    80003802:	854a                	mv	a0,s2
    80003804:	00003097          	auipc	ra,0x3
    80003808:	aae080e7          	jalr	-1362(ra) # 800062b2 <release>
}
    8000380c:	60e2                	ld	ra,24(sp)
    8000380e:	6442                	ld	s0,16(sp)
    80003810:	64a2                	ld	s1,8(sp)
    80003812:	6902                	ld	s2,0(sp)
    80003814:	6105                	addi	sp,sp,32
    80003816:	8082                	ret

0000000080003818 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003818:	7179                	addi	sp,sp,-48
    8000381a:	f406                	sd	ra,40(sp)
    8000381c:	f022                	sd	s0,32(sp)
    8000381e:	ec26                	sd	s1,24(sp)
    80003820:	e84a                	sd	s2,16(sp)
    80003822:	1800                	addi	s0,sp,48
    80003824:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003826:	00850913          	addi	s2,a0,8
    8000382a:	854a                	mv	a0,s2
    8000382c:	00003097          	auipc	ra,0x3
    80003830:	9d2080e7          	jalr	-1582(ra) # 800061fe <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003834:	409c                	lw	a5,0(s1)
    80003836:	ef91                	bnez	a5,80003852 <holdingsleep+0x3a>
    80003838:	4481                	li	s1,0
  release(&lk->lk);
    8000383a:	854a                	mv	a0,s2
    8000383c:	00003097          	auipc	ra,0x3
    80003840:	a76080e7          	jalr	-1418(ra) # 800062b2 <release>
  return r;
}
    80003844:	8526                	mv	a0,s1
    80003846:	70a2                	ld	ra,40(sp)
    80003848:	7402                	ld	s0,32(sp)
    8000384a:	64e2                	ld	s1,24(sp)
    8000384c:	6942                	ld	s2,16(sp)
    8000384e:	6145                	addi	sp,sp,48
    80003850:	8082                	ret
    80003852:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80003854:	0284a983          	lw	s3,40(s1)
    80003858:	ffffd097          	auipc	ra,0xffffd
    8000385c:	624080e7          	jalr	1572(ra) # 80000e7c <myproc>
    80003860:	5904                	lw	s1,48(a0)
    80003862:	413484b3          	sub	s1,s1,s3
    80003866:	0014b493          	seqz	s1,s1
    8000386a:	69a2                	ld	s3,8(sp)
    8000386c:	b7f9                	j	8000383a <holdingsleep+0x22>

000000008000386e <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    8000386e:	1141                	addi	sp,sp,-16
    80003870:	e406                	sd	ra,8(sp)
    80003872:	e022                	sd	s0,0(sp)
    80003874:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003876:	00005597          	auipc	a1,0x5
    8000387a:	c9258593          	addi	a1,a1,-878 # 80008508 <etext+0x508>
    8000387e:	00016517          	auipc	a0,0x16
    80003882:	8ea50513          	addi	a0,a0,-1814 # 80019168 <ftable>
    80003886:	00003097          	auipc	ra,0x3
    8000388a:	8e8080e7          	jalr	-1816(ra) # 8000616e <initlock>
}
    8000388e:	60a2                	ld	ra,8(sp)
    80003890:	6402                	ld	s0,0(sp)
    80003892:	0141                	addi	sp,sp,16
    80003894:	8082                	ret

0000000080003896 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003896:	1101                	addi	sp,sp,-32
    80003898:	ec06                	sd	ra,24(sp)
    8000389a:	e822                	sd	s0,16(sp)
    8000389c:	e426                	sd	s1,8(sp)
    8000389e:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800038a0:	00016517          	auipc	a0,0x16
    800038a4:	8c850513          	addi	a0,a0,-1848 # 80019168 <ftable>
    800038a8:	00003097          	auipc	ra,0x3
    800038ac:	956080e7          	jalr	-1706(ra) # 800061fe <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800038b0:	00016497          	auipc	s1,0x16
    800038b4:	8d048493          	addi	s1,s1,-1840 # 80019180 <ftable+0x18>
    800038b8:	00017717          	auipc	a4,0x17
    800038bc:	86870713          	addi	a4,a4,-1944 # 8001a120 <ftable+0xfb8>
    if(f->ref == 0){
    800038c0:	40dc                	lw	a5,4(s1)
    800038c2:	cf99                	beqz	a5,800038e0 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800038c4:	02848493          	addi	s1,s1,40
    800038c8:	fee49ce3          	bne	s1,a4,800038c0 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800038cc:	00016517          	auipc	a0,0x16
    800038d0:	89c50513          	addi	a0,a0,-1892 # 80019168 <ftable>
    800038d4:	00003097          	auipc	ra,0x3
    800038d8:	9de080e7          	jalr	-1570(ra) # 800062b2 <release>
  return 0;
    800038dc:	4481                	li	s1,0
    800038de:	a819                	j	800038f4 <filealloc+0x5e>
      f->ref = 1;
    800038e0:	4785                	li	a5,1
    800038e2:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800038e4:	00016517          	auipc	a0,0x16
    800038e8:	88450513          	addi	a0,a0,-1916 # 80019168 <ftable>
    800038ec:	00003097          	auipc	ra,0x3
    800038f0:	9c6080e7          	jalr	-1594(ra) # 800062b2 <release>
}
    800038f4:	8526                	mv	a0,s1
    800038f6:	60e2                	ld	ra,24(sp)
    800038f8:	6442                	ld	s0,16(sp)
    800038fa:	64a2                	ld	s1,8(sp)
    800038fc:	6105                	addi	sp,sp,32
    800038fe:	8082                	ret

0000000080003900 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003900:	1101                	addi	sp,sp,-32
    80003902:	ec06                	sd	ra,24(sp)
    80003904:	e822                	sd	s0,16(sp)
    80003906:	e426                	sd	s1,8(sp)
    80003908:	1000                	addi	s0,sp,32
    8000390a:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    8000390c:	00016517          	auipc	a0,0x16
    80003910:	85c50513          	addi	a0,a0,-1956 # 80019168 <ftable>
    80003914:	00003097          	auipc	ra,0x3
    80003918:	8ea080e7          	jalr	-1814(ra) # 800061fe <acquire>
  if(f->ref < 1)
    8000391c:	40dc                	lw	a5,4(s1)
    8000391e:	02f05263          	blez	a5,80003942 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003922:	2785                	addiw	a5,a5,1
    80003924:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003926:	00016517          	auipc	a0,0x16
    8000392a:	84250513          	addi	a0,a0,-1982 # 80019168 <ftable>
    8000392e:	00003097          	auipc	ra,0x3
    80003932:	984080e7          	jalr	-1660(ra) # 800062b2 <release>
  return f;
}
    80003936:	8526                	mv	a0,s1
    80003938:	60e2                	ld	ra,24(sp)
    8000393a:	6442                	ld	s0,16(sp)
    8000393c:	64a2                	ld	s1,8(sp)
    8000393e:	6105                	addi	sp,sp,32
    80003940:	8082                	ret
    panic("filedup");
    80003942:	00005517          	auipc	a0,0x5
    80003946:	bce50513          	addi	a0,a0,-1074 # 80008510 <etext+0x510>
    8000394a:	00002097          	auipc	ra,0x2
    8000394e:	364080e7          	jalr	868(ra) # 80005cae <panic>

0000000080003952 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003952:	7139                	addi	sp,sp,-64
    80003954:	fc06                	sd	ra,56(sp)
    80003956:	f822                	sd	s0,48(sp)
    80003958:	f426                	sd	s1,40(sp)
    8000395a:	0080                	addi	s0,sp,64
    8000395c:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    8000395e:	00016517          	auipc	a0,0x16
    80003962:	80a50513          	addi	a0,a0,-2038 # 80019168 <ftable>
    80003966:	00003097          	auipc	ra,0x3
    8000396a:	898080e7          	jalr	-1896(ra) # 800061fe <acquire>
  if(f->ref < 1)
    8000396e:	40dc                	lw	a5,4(s1)
    80003970:	04f05c63          	blez	a5,800039c8 <fileclose+0x76>
    panic("fileclose");
  if(--f->ref > 0){
    80003974:	37fd                	addiw	a5,a5,-1
    80003976:	0007871b          	sext.w	a4,a5
    8000397a:	c0dc                	sw	a5,4(s1)
    8000397c:	06e04263          	bgtz	a4,800039e0 <fileclose+0x8e>
    80003980:	f04a                	sd	s2,32(sp)
    80003982:	ec4e                	sd	s3,24(sp)
    80003984:	e852                	sd	s4,16(sp)
    80003986:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003988:	0004a903          	lw	s2,0(s1)
    8000398c:	0094ca83          	lbu	s5,9(s1)
    80003990:	0104ba03          	ld	s4,16(s1)
    80003994:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003998:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    8000399c:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800039a0:	00015517          	auipc	a0,0x15
    800039a4:	7c850513          	addi	a0,a0,1992 # 80019168 <ftable>
    800039a8:	00003097          	auipc	ra,0x3
    800039ac:	90a080e7          	jalr	-1782(ra) # 800062b2 <release>

  if(ff.type == FD_PIPE){
    800039b0:	4785                	li	a5,1
    800039b2:	04f90463          	beq	s2,a5,800039fa <fileclose+0xa8>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    800039b6:	3979                	addiw	s2,s2,-2
    800039b8:	4785                	li	a5,1
    800039ba:	0527fb63          	bgeu	a5,s2,80003a10 <fileclose+0xbe>
    800039be:	7902                	ld	s2,32(sp)
    800039c0:	69e2                	ld	s3,24(sp)
    800039c2:	6a42                	ld	s4,16(sp)
    800039c4:	6aa2                	ld	s5,8(sp)
    800039c6:	a02d                	j	800039f0 <fileclose+0x9e>
    800039c8:	f04a                	sd	s2,32(sp)
    800039ca:	ec4e                	sd	s3,24(sp)
    800039cc:	e852                	sd	s4,16(sp)
    800039ce:	e456                	sd	s5,8(sp)
    panic("fileclose");
    800039d0:	00005517          	auipc	a0,0x5
    800039d4:	b4850513          	addi	a0,a0,-1208 # 80008518 <etext+0x518>
    800039d8:	00002097          	auipc	ra,0x2
    800039dc:	2d6080e7          	jalr	726(ra) # 80005cae <panic>
    release(&ftable.lock);
    800039e0:	00015517          	auipc	a0,0x15
    800039e4:	78850513          	addi	a0,a0,1928 # 80019168 <ftable>
    800039e8:	00003097          	auipc	ra,0x3
    800039ec:	8ca080e7          	jalr	-1846(ra) # 800062b2 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    800039f0:	70e2                	ld	ra,56(sp)
    800039f2:	7442                	ld	s0,48(sp)
    800039f4:	74a2                	ld	s1,40(sp)
    800039f6:	6121                	addi	sp,sp,64
    800039f8:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    800039fa:	85d6                	mv	a1,s5
    800039fc:	8552                	mv	a0,s4
    800039fe:	00000097          	auipc	ra,0x0
    80003a02:	3a2080e7          	jalr	930(ra) # 80003da0 <pipeclose>
    80003a06:	7902                	ld	s2,32(sp)
    80003a08:	69e2                	ld	s3,24(sp)
    80003a0a:	6a42                	ld	s4,16(sp)
    80003a0c:	6aa2                	ld	s5,8(sp)
    80003a0e:	b7cd                	j	800039f0 <fileclose+0x9e>
    begin_op();
    80003a10:	00000097          	auipc	ra,0x0
    80003a14:	a78080e7          	jalr	-1416(ra) # 80003488 <begin_op>
    iput(ff.ip);
    80003a18:	854e                	mv	a0,s3
    80003a1a:	fffff097          	auipc	ra,0xfffff
    80003a1e:	25a080e7          	jalr	602(ra) # 80002c74 <iput>
    end_op();
    80003a22:	00000097          	auipc	ra,0x0
    80003a26:	ae0080e7          	jalr	-1312(ra) # 80003502 <end_op>
    80003a2a:	7902                	ld	s2,32(sp)
    80003a2c:	69e2                	ld	s3,24(sp)
    80003a2e:	6a42                	ld	s4,16(sp)
    80003a30:	6aa2                	ld	s5,8(sp)
    80003a32:	bf7d                	j	800039f0 <fileclose+0x9e>

0000000080003a34 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003a34:	715d                	addi	sp,sp,-80
    80003a36:	e486                	sd	ra,72(sp)
    80003a38:	e0a2                	sd	s0,64(sp)
    80003a3a:	fc26                	sd	s1,56(sp)
    80003a3c:	f44e                	sd	s3,40(sp)
    80003a3e:	0880                	addi	s0,sp,80
    80003a40:	84aa                	mv	s1,a0
    80003a42:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003a44:	ffffd097          	auipc	ra,0xffffd
    80003a48:	438080e7          	jalr	1080(ra) # 80000e7c <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003a4c:	409c                	lw	a5,0(s1)
    80003a4e:	37f9                	addiw	a5,a5,-2
    80003a50:	4705                	li	a4,1
    80003a52:	04f76863          	bltu	a4,a5,80003aa2 <filestat+0x6e>
    80003a56:	f84a                	sd	s2,48(sp)
    80003a58:	892a                	mv	s2,a0
    ilock(f->ip);
    80003a5a:	6c88                	ld	a0,24(s1)
    80003a5c:	fffff097          	auipc	ra,0xfffff
    80003a60:	05a080e7          	jalr	90(ra) # 80002ab6 <ilock>
    stati(f->ip, &st);
    80003a64:	fb840593          	addi	a1,s0,-72
    80003a68:	6c88                	ld	a0,24(s1)
    80003a6a:	fffff097          	auipc	ra,0xfffff
    80003a6e:	2da080e7          	jalr	730(ra) # 80002d44 <stati>
    iunlock(f->ip);
    80003a72:	6c88                	ld	a0,24(s1)
    80003a74:	fffff097          	auipc	ra,0xfffff
    80003a78:	108080e7          	jalr	264(ra) # 80002b7c <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003a7c:	46e1                	li	a3,24
    80003a7e:	fb840613          	addi	a2,s0,-72
    80003a82:	85ce                	mv	a1,s3
    80003a84:	05093503          	ld	a0,80(s2)
    80003a88:	ffffd097          	auipc	ra,0xffffd
    80003a8c:	090080e7          	jalr	144(ra) # 80000b18 <copyout>
    80003a90:	41f5551b          	sraiw	a0,a0,0x1f
    80003a94:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80003a96:	60a6                	ld	ra,72(sp)
    80003a98:	6406                	ld	s0,64(sp)
    80003a9a:	74e2                	ld	s1,56(sp)
    80003a9c:	79a2                	ld	s3,40(sp)
    80003a9e:	6161                	addi	sp,sp,80
    80003aa0:	8082                	ret
  return -1;
    80003aa2:	557d                	li	a0,-1
    80003aa4:	bfcd                	j	80003a96 <filestat+0x62>

0000000080003aa6 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003aa6:	7179                	addi	sp,sp,-48
    80003aa8:	f406                	sd	ra,40(sp)
    80003aaa:	f022                	sd	s0,32(sp)
    80003aac:	e84a                	sd	s2,16(sp)
    80003aae:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003ab0:	00854783          	lbu	a5,8(a0)
    80003ab4:	cbc5                	beqz	a5,80003b64 <fileread+0xbe>
    80003ab6:	ec26                	sd	s1,24(sp)
    80003ab8:	e44e                	sd	s3,8(sp)
    80003aba:	84aa                	mv	s1,a0
    80003abc:	89ae                	mv	s3,a1
    80003abe:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003ac0:	411c                	lw	a5,0(a0)
    80003ac2:	4705                	li	a4,1
    80003ac4:	04e78963          	beq	a5,a4,80003b16 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003ac8:	470d                	li	a4,3
    80003aca:	04e78f63          	beq	a5,a4,80003b28 <fileread+0x82>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003ace:	4709                	li	a4,2
    80003ad0:	08e79263          	bne	a5,a4,80003b54 <fileread+0xae>
    ilock(f->ip);
    80003ad4:	6d08                	ld	a0,24(a0)
    80003ad6:	fffff097          	auipc	ra,0xfffff
    80003ada:	fe0080e7          	jalr	-32(ra) # 80002ab6 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003ade:	874a                	mv	a4,s2
    80003ae0:	5094                	lw	a3,32(s1)
    80003ae2:	864e                	mv	a2,s3
    80003ae4:	4585                	li	a1,1
    80003ae6:	6c88                	ld	a0,24(s1)
    80003ae8:	fffff097          	auipc	ra,0xfffff
    80003aec:	286080e7          	jalr	646(ra) # 80002d6e <readi>
    80003af0:	892a                	mv	s2,a0
    80003af2:	00a05563          	blez	a0,80003afc <fileread+0x56>
      f->off += r;
    80003af6:	509c                	lw	a5,32(s1)
    80003af8:	9fa9                	addw	a5,a5,a0
    80003afa:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003afc:	6c88                	ld	a0,24(s1)
    80003afe:	fffff097          	auipc	ra,0xfffff
    80003b02:	07e080e7          	jalr	126(ra) # 80002b7c <iunlock>
    80003b06:	64e2                	ld	s1,24(sp)
    80003b08:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80003b0a:	854a                	mv	a0,s2
    80003b0c:	70a2                	ld	ra,40(sp)
    80003b0e:	7402                	ld	s0,32(sp)
    80003b10:	6942                	ld	s2,16(sp)
    80003b12:	6145                	addi	sp,sp,48
    80003b14:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003b16:	6908                	ld	a0,16(a0)
    80003b18:	00000097          	auipc	ra,0x0
    80003b1c:	3fa080e7          	jalr	1018(ra) # 80003f12 <piperead>
    80003b20:	892a                	mv	s2,a0
    80003b22:	64e2                	ld	s1,24(sp)
    80003b24:	69a2                	ld	s3,8(sp)
    80003b26:	b7d5                	j	80003b0a <fileread+0x64>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003b28:	02451783          	lh	a5,36(a0)
    80003b2c:	03079693          	slli	a3,a5,0x30
    80003b30:	92c1                	srli	a3,a3,0x30
    80003b32:	4725                	li	a4,9
    80003b34:	02d76a63          	bltu	a4,a3,80003b68 <fileread+0xc2>
    80003b38:	0792                	slli	a5,a5,0x4
    80003b3a:	00015717          	auipc	a4,0x15
    80003b3e:	58e70713          	addi	a4,a4,1422 # 800190c8 <devsw>
    80003b42:	97ba                	add	a5,a5,a4
    80003b44:	639c                	ld	a5,0(a5)
    80003b46:	c78d                	beqz	a5,80003b70 <fileread+0xca>
    r = devsw[f->major].read(1, addr, n);
    80003b48:	4505                	li	a0,1
    80003b4a:	9782                	jalr	a5
    80003b4c:	892a                	mv	s2,a0
    80003b4e:	64e2                	ld	s1,24(sp)
    80003b50:	69a2                	ld	s3,8(sp)
    80003b52:	bf65                	j	80003b0a <fileread+0x64>
    panic("fileread");
    80003b54:	00005517          	auipc	a0,0x5
    80003b58:	9d450513          	addi	a0,a0,-1580 # 80008528 <etext+0x528>
    80003b5c:	00002097          	auipc	ra,0x2
    80003b60:	152080e7          	jalr	338(ra) # 80005cae <panic>
    return -1;
    80003b64:	597d                	li	s2,-1
    80003b66:	b755                	j	80003b0a <fileread+0x64>
      return -1;
    80003b68:	597d                	li	s2,-1
    80003b6a:	64e2                	ld	s1,24(sp)
    80003b6c:	69a2                	ld	s3,8(sp)
    80003b6e:	bf71                	j	80003b0a <fileread+0x64>
    80003b70:	597d                	li	s2,-1
    80003b72:	64e2                	ld	s1,24(sp)
    80003b74:	69a2                	ld	s3,8(sp)
    80003b76:	bf51                	j	80003b0a <fileread+0x64>

0000000080003b78 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003b78:	00954783          	lbu	a5,9(a0)
    80003b7c:	12078963          	beqz	a5,80003cae <filewrite+0x136>
{
    80003b80:	715d                	addi	sp,sp,-80
    80003b82:	e486                	sd	ra,72(sp)
    80003b84:	e0a2                	sd	s0,64(sp)
    80003b86:	f84a                	sd	s2,48(sp)
    80003b88:	f052                	sd	s4,32(sp)
    80003b8a:	e85a                	sd	s6,16(sp)
    80003b8c:	0880                	addi	s0,sp,80
    80003b8e:	892a                	mv	s2,a0
    80003b90:	8b2e                	mv	s6,a1
    80003b92:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003b94:	411c                	lw	a5,0(a0)
    80003b96:	4705                	li	a4,1
    80003b98:	02e78763          	beq	a5,a4,80003bc6 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003b9c:	470d                	li	a4,3
    80003b9e:	02e78a63          	beq	a5,a4,80003bd2 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003ba2:	4709                	li	a4,2
    80003ba4:	0ee79863          	bne	a5,a4,80003c94 <filewrite+0x11c>
    80003ba8:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003baa:	0cc05463          	blez	a2,80003c72 <filewrite+0xfa>
    80003bae:	fc26                	sd	s1,56(sp)
    80003bb0:	ec56                	sd	s5,24(sp)
    80003bb2:	e45e                	sd	s7,8(sp)
    80003bb4:	e062                	sd	s8,0(sp)
    int i = 0;
    80003bb6:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80003bb8:	6b85                	lui	s7,0x1
    80003bba:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003bbe:	6c05                	lui	s8,0x1
    80003bc0:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003bc4:	a851                	j	80003c58 <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80003bc6:	6908                	ld	a0,16(a0)
    80003bc8:	00000097          	auipc	ra,0x0
    80003bcc:	248080e7          	jalr	584(ra) # 80003e10 <pipewrite>
    80003bd0:	a85d                	j	80003c86 <filewrite+0x10e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003bd2:	02451783          	lh	a5,36(a0)
    80003bd6:	03079693          	slli	a3,a5,0x30
    80003bda:	92c1                	srli	a3,a3,0x30
    80003bdc:	4725                	li	a4,9
    80003bde:	0cd76a63          	bltu	a4,a3,80003cb2 <filewrite+0x13a>
    80003be2:	0792                	slli	a5,a5,0x4
    80003be4:	00015717          	auipc	a4,0x15
    80003be8:	4e470713          	addi	a4,a4,1252 # 800190c8 <devsw>
    80003bec:	97ba                	add	a5,a5,a4
    80003bee:	679c                	ld	a5,8(a5)
    80003bf0:	c3f9                	beqz	a5,80003cb6 <filewrite+0x13e>
    ret = devsw[f->major].write(1, addr, n);
    80003bf2:	4505                	li	a0,1
    80003bf4:	9782                	jalr	a5
    80003bf6:	a841                	j	80003c86 <filewrite+0x10e>
      if(n1 > max)
    80003bf8:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80003bfc:	00000097          	auipc	ra,0x0
    80003c00:	88c080e7          	jalr	-1908(ra) # 80003488 <begin_op>
      ilock(f->ip);
    80003c04:	01893503          	ld	a0,24(s2)
    80003c08:	fffff097          	auipc	ra,0xfffff
    80003c0c:	eae080e7          	jalr	-338(ra) # 80002ab6 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003c10:	8756                	mv	a4,s5
    80003c12:	02092683          	lw	a3,32(s2)
    80003c16:	01698633          	add	a2,s3,s6
    80003c1a:	4585                	li	a1,1
    80003c1c:	01893503          	ld	a0,24(s2)
    80003c20:	fffff097          	auipc	ra,0xfffff
    80003c24:	252080e7          	jalr	594(ra) # 80002e72 <writei>
    80003c28:	84aa                	mv	s1,a0
    80003c2a:	00a05763          	blez	a0,80003c38 <filewrite+0xc0>
        f->off += r;
    80003c2e:	02092783          	lw	a5,32(s2)
    80003c32:	9fa9                	addw	a5,a5,a0
    80003c34:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003c38:	01893503          	ld	a0,24(s2)
    80003c3c:	fffff097          	auipc	ra,0xfffff
    80003c40:	f40080e7          	jalr	-192(ra) # 80002b7c <iunlock>
      end_op();
    80003c44:	00000097          	auipc	ra,0x0
    80003c48:	8be080e7          	jalr	-1858(ra) # 80003502 <end_op>

      if(r != n1){
    80003c4c:	029a9563          	bne	s5,s1,80003c76 <filewrite+0xfe>
        // error from writei
        break;
      }
      i += r;
    80003c50:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003c54:	0149da63          	bge	s3,s4,80003c68 <filewrite+0xf0>
      int n1 = n - i;
    80003c58:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80003c5c:	0004879b          	sext.w	a5,s1
    80003c60:	f8fbdce3          	bge	s7,a5,80003bf8 <filewrite+0x80>
    80003c64:	84e2                	mv	s1,s8
    80003c66:	bf49                	j	80003bf8 <filewrite+0x80>
    80003c68:	74e2                	ld	s1,56(sp)
    80003c6a:	6ae2                	ld	s5,24(sp)
    80003c6c:	6ba2                	ld	s7,8(sp)
    80003c6e:	6c02                	ld	s8,0(sp)
    80003c70:	a039                	j	80003c7e <filewrite+0x106>
    int i = 0;
    80003c72:	4981                	li	s3,0
    80003c74:	a029                	j	80003c7e <filewrite+0x106>
    80003c76:	74e2                	ld	s1,56(sp)
    80003c78:	6ae2                	ld	s5,24(sp)
    80003c7a:	6ba2                	ld	s7,8(sp)
    80003c7c:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    80003c7e:	033a1e63          	bne	s4,s3,80003cba <filewrite+0x142>
    80003c82:	8552                	mv	a0,s4
    80003c84:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003c86:	60a6                	ld	ra,72(sp)
    80003c88:	6406                	ld	s0,64(sp)
    80003c8a:	7942                	ld	s2,48(sp)
    80003c8c:	7a02                	ld	s4,32(sp)
    80003c8e:	6b42                	ld	s6,16(sp)
    80003c90:	6161                	addi	sp,sp,80
    80003c92:	8082                	ret
    80003c94:	fc26                	sd	s1,56(sp)
    80003c96:	f44e                	sd	s3,40(sp)
    80003c98:	ec56                	sd	s5,24(sp)
    80003c9a:	e45e                	sd	s7,8(sp)
    80003c9c:	e062                	sd	s8,0(sp)
    panic("filewrite");
    80003c9e:	00005517          	auipc	a0,0x5
    80003ca2:	89a50513          	addi	a0,a0,-1894 # 80008538 <etext+0x538>
    80003ca6:	00002097          	auipc	ra,0x2
    80003caa:	008080e7          	jalr	8(ra) # 80005cae <panic>
    return -1;
    80003cae:	557d                	li	a0,-1
}
    80003cb0:	8082                	ret
      return -1;
    80003cb2:	557d                	li	a0,-1
    80003cb4:	bfc9                	j	80003c86 <filewrite+0x10e>
    80003cb6:	557d                	li	a0,-1
    80003cb8:	b7f9                	j	80003c86 <filewrite+0x10e>
    ret = (i == n ? n : -1);
    80003cba:	557d                	li	a0,-1
    80003cbc:	79a2                	ld	s3,40(sp)
    80003cbe:	b7e1                	j	80003c86 <filewrite+0x10e>

0000000080003cc0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003cc0:	7179                	addi	sp,sp,-48
    80003cc2:	f406                	sd	ra,40(sp)
    80003cc4:	f022                	sd	s0,32(sp)
    80003cc6:	ec26                	sd	s1,24(sp)
    80003cc8:	e052                	sd	s4,0(sp)
    80003cca:	1800                	addi	s0,sp,48
    80003ccc:	84aa                	mv	s1,a0
    80003cce:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003cd0:	0005b023          	sd	zero,0(a1)
    80003cd4:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003cd8:	00000097          	auipc	ra,0x0
    80003cdc:	bbe080e7          	jalr	-1090(ra) # 80003896 <filealloc>
    80003ce0:	e088                	sd	a0,0(s1)
    80003ce2:	cd49                	beqz	a0,80003d7c <pipealloc+0xbc>
    80003ce4:	00000097          	auipc	ra,0x0
    80003ce8:	bb2080e7          	jalr	-1102(ra) # 80003896 <filealloc>
    80003cec:	00aa3023          	sd	a0,0(s4)
    80003cf0:	c141                	beqz	a0,80003d70 <pipealloc+0xb0>
    80003cf2:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003cf4:	ffffc097          	auipc	ra,0xffffc
    80003cf8:	426080e7          	jalr	1062(ra) # 8000011a <kalloc>
    80003cfc:	892a                	mv	s2,a0
    80003cfe:	c13d                	beqz	a0,80003d64 <pipealloc+0xa4>
    80003d00:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80003d02:	4985                	li	s3,1
    80003d04:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003d08:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003d0c:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003d10:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003d14:	00005597          	auipc	a1,0x5
    80003d18:	83458593          	addi	a1,a1,-1996 # 80008548 <etext+0x548>
    80003d1c:	00002097          	auipc	ra,0x2
    80003d20:	452080e7          	jalr	1106(ra) # 8000616e <initlock>
  (*f0)->type = FD_PIPE;
    80003d24:	609c                	ld	a5,0(s1)
    80003d26:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003d2a:	609c                	ld	a5,0(s1)
    80003d2c:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003d30:	609c                	ld	a5,0(s1)
    80003d32:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003d36:	609c                	ld	a5,0(s1)
    80003d38:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003d3c:	000a3783          	ld	a5,0(s4)
    80003d40:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003d44:	000a3783          	ld	a5,0(s4)
    80003d48:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003d4c:	000a3783          	ld	a5,0(s4)
    80003d50:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003d54:	000a3783          	ld	a5,0(s4)
    80003d58:	0127b823          	sd	s2,16(a5)
  return 0;
    80003d5c:	4501                	li	a0,0
    80003d5e:	6942                	ld	s2,16(sp)
    80003d60:	69a2                	ld	s3,8(sp)
    80003d62:	a03d                	j	80003d90 <pipealloc+0xd0>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003d64:	6088                	ld	a0,0(s1)
    80003d66:	c119                	beqz	a0,80003d6c <pipealloc+0xac>
    80003d68:	6942                	ld	s2,16(sp)
    80003d6a:	a029                	j	80003d74 <pipealloc+0xb4>
    80003d6c:	6942                	ld	s2,16(sp)
    80003d6e:	a039                	j	80003d7c <pipealloc+0xbc>
    80003d70:	6088                	ld	a0,0(s1)
    80003d72:	c50d                	beqz	a0,80003d9c <pipealloc+0xdc>
    fileclose(*f0);
    80003d74:	00000097          	auipc	ra,0x0
    80003d78:	bde080e7          	jalr	-1058(ra) # 80003952 <fileclose>
  if(*f1)
    80003d7c:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003d80:	557d                	li	a0,-1
  if(*f1)
    80003d82:	c799                	beqz	a5,80003d90 <pipealloc+0xd0>
    fileclose(*f1);
    80003d84:	853e                	mv	a0,a5
    80003d86:	00000097          	auipc	ra,0x0
    80003d8a:	bcc080e7          	jalr	-1076(ra) # 80003952 <fileclose>
  return -1;
    80003d8e:	557d                	li	a0,-1
}
    80003d90:	70a2                	ld	ra,40(sp)
    80003d92:	7402                	ld	s0,32(sp)
    80003d94:	64e2                	ld	s1,24(sp)
    80003d96:	6a02                	ld	s4,0(sp)
    80003d98:	6145                	addi	sp,sp,48
    80003d9a:	8082                	ret
  return -1;
    80003d9c:	557d                	li	a0,-1
    80003d9e:	bfcd                	j	80003d90 <pipealloc+0xd0>

0000000080003da0 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003da0:	1101                	addi	sp,sp,-32
    80003da2:	ec06                	sd	ra,24(sp)
    80003da4:	e822                	sd	s0,16(sp)
    80003da6:	e426                	sd	s1,8(sp)
    80003da8:	e04a                	sd	s2,0(sp)
    80003daa:	1000                	addi	s0,sp,32
    80003dac:	84aa                	mv	s1,a0
    80003dae:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003db0:	00002097          	auipc	ra,0x2
    80003db4:	44e080e7          	jalr	1102(ra) # 800061fe <acquire>
  if(writable){
    80003db8:	02090d63          	beqz	s2,80003df2 <pipeclose+0x52>
    pi->writeopen = 0;
    80003dbc:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003dc0:	21848513          	addi	a0,s1,536
    80003dc4:	ffffe097          	auipc	ra,0xffffe
    80003dc8:	90a080e7          	jalr	-1782(ra) # 800016ce <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003dcc:	2204b783          	ld	a5,544(s1)
    80003dd0:	eb95                	bnez	a5,80003e04 <pipeclose+0x64>
    release(&pi->lock);
    80003dd2:	8526                	mv	a0,s1
    80003dd4:	00002097          	auipc	ra,0x2
    80003dd8:	4de080e7          	jalr	1246(ra) # 800062b2 <release>
    kfree((char*)pi);
    80003ddc:	8526                	mv	a0,s1
    80003dde:	ffffc097          	auipc	ra,0xffffc
    80003de2:	23e080e7          	jalr	574(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003de6:	60e2                	ld	ra,24(sp)
    80003de8:	6442                	ld	s0,16(sp)
    80003dea:	64a2                	ld	s1,8(sp)
    80003dec:	6902                	ld	s2,0(sp)
    80003dee:	6105                	addi	sp,sp,32
    80003df0:	8082                	ret
    pi->readopen = 0;
    80003df2:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003df6:	21c48513          	addi	a0,s1,540
    80003dfa:	ffffe097          	auipc	ra,0xffffe
    80003dfe:	8d4080e7          	jalr	-1836(ra) # 800016ce <wakeup>
    80003e02:	b7e9                	j	80003dcc <pipeclose+0x2c>
    release(&pi->lock);
    80003e04:	8526                	mv	a0,s1
    80003e06:	00002097          	auipc	ra,0x2
    80003e0a:	4ac080e7          	jalr	1196(ra) # 800062b2 <release>
}
    80003e0e:	bfe1                	j	80003de6 <pipeclose+0x46>

0000000080003e10 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003e10:	711d                	addi	sp,sp,-96
    80003e12:	ec86                	sd	ra,88(sp)
    80003e14:	e8a2                	sd	s0,80(sp)
    80003e16:	e4a6                	sd	s1,72(sp)
    80003e18:	e0ca                	sd	s2,64(sp)
    80003e1a:	fc4e                	sd	s3,56(sp)
    80003e1c:	f852                	sd	s4,48(sp)
    80003e1e:	f456                	sd	s5,40(sp)
    80003e20:	1080                	addi	s0,sp,96
    80003e22:	84aa                	mv	s1,a0
    80003e24:	8aae                	mv	s5,a1
    80003e26:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003e28:	ffffd097          	auipc	ra,0xffffd
    80003e2c:	054080e7          	jalr	84(ra) # 80000e7c <myproc>
    80003e30:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003e32:	8526                	mv	a0,s1
    80003e34:	00002097          	auipc	ra,0x2
    80003e38:	3ca080e7          	jalr	970(ra) # 800061fe <acquire>
  while(i < n){
    80003e3c:	0d405563          	blez	s4,80003f06 <pipewrite+0xf6>
    80003e40:	f05a                	sd	s6,32(sp)
    80003e42:	ec5e                	sd	s7,24(sp)
    80003e44:	e862                	sd	s8,16(sp)
  int i = 0;
    80003e46:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003e48:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003e4a:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003e4e:	21c48b93          	addi	s7,s1,540
    80003e52:	a089                	j	80003e94 <pipewrite+0x84>
      release(&pi->lock);
    80003e54:	8526                	mv	a0,s1
    80003e56:	00002097          	auipc	ra,0x2
    80003e5a:	45c080e7          	jalr	1116(ra) # 800062b2 <release>
      return -1;
    80003e5e:	597d                	li	s2,-1
    80003e60:	7b02                	ld	s6,32(sp)
    80003e62:	6be2                	ld	s7,24(sp)
    80003e64:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003e66:	854a                	mv	a0,s2
    80003e68:	60e6                	ld	ra,88(sp)
    80003e6a:	6446                	ld	s0,80(sp)
    80003e6c:	64a6                	ld	s1,72(sp)
    80003e6e:	6906                	ld	s2,64(sp)
    80003e70:	79e2                	ld	s3,56(sp)
    80003e72:	7a42                	ld	s4,48(sp)
    80003e74:	7aa2                	ld	s5,40(sp)
    80003e76:	6125                	addi	sp,sp,96
    80003e78:	8082                	ret
      wakeup(&pi->nread);
    80003e7a:	8562                	mv	a0,s8
    80003e7c:	ffffe097          	auipc	ra,0xffffe
    80003e80:	852080e7          	jalr	-1966(ra) # 800016ce <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003e84:	85a6                	mv	a1,s1
    80003e86:	855e                	mv	a0,s7
    80003e88:	ffffd097          	auipc	ra,0xffffd
    80003e8c:	6ba080e7          	jalr	1722(ra) # 80001542 <sleep>
  while(i < n){
    80003e90:	05495c63          	bge	s2,s4,80003ee8 <pipewrite+0xd8>
    if(pi->readopen == 0 || pr->killed){
    80003e94:	2204a783          	lw	a5,544(s1)
    80003e98:	dfd5                	beqz	a5,80003e54 <pipewrite+0x44>
    80003e9a:	0289a783          	lw	a5,40(s3)
    80003e9e:	fbdd                	bnez	a5,80003e54 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003ea0:	2184a783          	lw	a5,536(s1)
    80003ea4:	21c4a703          	lw	a4,540(s1)
    80003ea8:	2007879b          	addiw	a5,a5,512
    80003eac:	fcf707e3          	beq	a4,a5,80003e7a <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003eb0:	4685                	li	a3,1
    80003eb2:	01590633          	add	a2,s2,s5
    80003eb6:	faf40593          	addi	a1,s0,-81
    80003eba:	0509b503          	ld	a0,80(s3)
    80003ebe:	ffffd097          	auipc	ra,0xffffd
    80003ec2:	ce6080e7          	jalr	-794(ra) # 80000ba4 <copyin>
    80003ec6:	05650263          	beq	a0,s6,80003f0a <pipewrite+0xfa>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003eca:	21c4a783          	lw	a5,540(s1)
    80003ece:	0017871b          	addiw	a4,a5,1
    80003ed2:	20e4ae23          	sw	a4,540(s1)
    80003ed6:	1ff7f793          	andi	a5,a5,511
    80003eda:	97a6                	add	a5,a5,s1
    80003edc:	faf44703          	lbu	a4,-81(s0)
    80003ee0:	00e78c23          	sb	a4,24(a5)
      i++;
    80003ee4:	2905                	addiw	s2,s2,1
    80003ee6:	b76d                	j	80003e90 <pipewrite+0x80>
    80003ee8:	7b02                	ld	s6,32(sp)
    80003eea:	6be2                	ld	s7,24(sp)
    80003eec:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    80003eee:	21848513          	addi	a0,s1,536
    80003ef2:	ffffd097          	auipc	ra,0xffffd
    80003ef6:	7dc080e7          	jalr	2012(ra) # 800016ce <wakeup>
  release(&pi->lock);
    80003efa:	8526                	mv	a0,s1
    80003efc:	00002097          	auipc	ra,0x2
    80003f00:	3b6080e7          	jalr	950(ra) # 800062b2 <release>
  return i;
    80003f04:	b78d                	j	80003e66 <pipewrite+0x56>
  int i = 0;
    80003f06:	4901                	li	s2,0
    80003f08:	b7dd                	j	80003eee <pipewrite+0xde>
    80003f0a:	7b02                	ld	s6,32(sp)
    80003f0c:	6be2                	ld	s7,24(sp)
    80003f0e:	6c42                	ld	s8,16(sp)
    80003f10:	bff9                	j	80003eee <pipewrite+0xde>

0000000080003f12 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003f12:	715d                	addi	sp,sp,-80
    80003f14:	e486                	sd	ra,72(sp)
    80003f16:	e0a2                	sd	s0,64(sp)
    80003f18:	fc26                	sd	s1,56(sp)
    80003f1a:	f84a                	sd	s2,48(sp)
    80003f1c:	f44e                	sd	s3,40(sp)
    80003f1e:	f052                	sd	s4,32(sp)
    80003f20:	ec56                	sd	s5,24(sp)
    80003f22:	0880                	addi	s0,sp,80
    80003f24:	84aa                	mv	s1,a0
    80003f26:	892e                	mv	s2,a1
    80003f28:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003f2a:	ffffd097          	auipc	ra,0xffffd
    80003f2e:	f52080e7          	jalr	-174(ra) # 80000e7c <myproc>
    80003f32:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003f34:	8526                	mv	a0,s1
    80003f36:	00002097          	auipc	ra,0x2
    80003f3a:	2c8080e7          	jalr	712(ra) # 800061fe <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003f3e:	2184a703          	lw	a4,536(s1)
    80003f42:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003f46:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003f4a:	02f71663          	bne	a4,a5,80003f76 <piperead+0x64>
    80003f4e:	2244a783          	lw	a5,548(s1)
    80003f52:	cb9d                	beqz	a5,80003f88 <piperead+0x76>
    if(pr->killed){
    80003f54:	028a2783          	lw	a5,40(s4)
    80003f58:	e38d                	bnez	a5,80003f7a <piperead+0x68>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003f5a:	85a6                	mv	a1,s1
    80003f5c:	854e                	mv	a0,s3
    80003f5e:	ffffd097          	auipc	ra,0xffffd
    80003f62:	5e4080e7          	jalr	1508(ra) # 80001542 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003f66:	2184a703          	lw	a4,536(s1)
    80003f6a:	21c4a783          	lw	a5,540(s1)
    80003f6e:	fef700e3          	beq	a4,a5,80003f4e <piperead+0x3c>
    80003f72:	e85a                	sd	s6,16(sp)
    80003f74:	a819                	j	80003f8a <piperead+0x78>
    80003f76:	e85a                	sd	s6,16(sp)
    80003f78:	a809                	j	80003f8a <piperead+0x78>
      release(&pi->lock);
    80003f7a:	8526                	mv	a0,s1
    80003f7c:	00002097          	auipc	ra,0x2
    80003f80:	336080e7          	jalr	822(ra) # 800062b2 <release>
      return -1;
    80003f84:	59fd                	li	s3,-1
    80003f86:	a0a5                	j	80003fee <piperead+0xdc>
    80003f88:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003f8a:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003f8c:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003f8e:	05505463          	blez	s5,80003fd6 <piperead+0xc4>
    if(pi->nread == pi->nwrite)
    80003f92:	2184a783          	lw	a5,536(s1)
    80003f96:	21c4a703          	lw	a4,540(s1)
    80003f9a:	02f70e63          	beq	a4,a5,80003fd6 <piperead+0xc4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80003f9e:	0017871b          	addiw	a4,a5,1
    80003fa2:	20e4ac23          	sw	a4,536(s1)
    80003fa6:	1ff7f793          	andi	a5,a5,511
    80003faa:	97a6                	add	a5,a5,s1
    80003fac:	0187c783          	lbu	a5,24(a5)
    80003fb0:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003fb4:	4685                	li	a3,1
    80003fb6:	fbf40613          	addi	a2,s0,-65
    80003fba:	85ca                	mv	a1,s2
    80003fbc:	050a3503          	ld	a0,80(s4)
    80003fc0:	ffffd097          	auipc	ra,0xffffd
    80003fc4:	b58080e7          	jalr	-1192(ra) # 80000b18 <copyout>
    80003fc8:	01650763          	beq	a0,s6,80003fd6 <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003fcc:	2985                	addiw	s3,s3,1
    80003fce:	0905                	addi	s2,s2,1
    80003fd0:	fd3a91e3          	bne	s5,s3,80003f92 <piperead+0x80>
    80003fd4:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80003fd6:	21c48513          	addi	a0,s1,540
    80003fda:	ffffd097          	auipc	ra,0xffffd
    80003fde:	6f4080e7          	jalr	1780(ra) # 800016ce <wakeup>
  release(&pi->lock);
    80003fe2:	8526                	mv	a0,s1
    80003fe4:	00002097          	auipc	ra,0x2
    80003fe8:	2ce080e7          	jalr	718(ra) # 800062b2 <release>
    80003fec:	6b42                	ld	s6,16(sp)
  return i;
}
    80003fee:	854e                	mv	a0,s3
    80003ff0:	60a6                	ld	ra,72(sp)
    80003ff2:	6406                	ld	s0,64(sp)
    80003ff4:	74e2                	ld	s1,56(sp)
    80003ff6:	7942                	ld	s2,48(sp)
    80003ff8:	79a2                	ld	s3,40(sp)
    80003ffa:	7a02                	ld	s4,32(sp)
    80003ffc:	6ae2                	ld	s5,24(sp)
    80003ffe:	6161                	addi	sp,sp,80
    80004000:	8082                	ret

0000000080004002 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80004002:	df010113          	addi	sp,sp,-528
    80004006:	20113423          	sd	ra,520(sp)
    8000400a:	20813023          	sd	s0,512(sp)
    8000400e:	ffa6                	sd	s1,504(sp)
    80004010:	fbca                	sd	s2,496(sp)
    80004012:	0c00                	addi	s0,sp,528
    80004014:	892a                	mv	s2,a0
    80004016:	dea43c23          	sd	a0,-520(s0)
    8000401a:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000401e:	ffffd097          	auipc	ra,0xffffd
    80004022:	e5e080e7          	jalr	-418(ra) # 80000e7c <myproc>
    80004026:	84aa                	mv	s1,a0

  begin_op();
    80004028:	fffff097          	auipc	ra,0xfffff
    8000402c:	460080e7          	jalr	1120(ra) # 80003488 <begin_op>

  if((ip = namei(path)) == 0){
    80004030:	854a                	mv	a0,s2
    80004032:	fffff097          	auipc	ra,0xfffff
    80004036:	256080e7          	jalr	598(ra) # 80003288 <namei>
    8000403a:	c135                	beqz	a0,8000409e <exec+0x9c>
    8000403c:	f3d2                	sd	s4,480(sp)
    8000403e:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004040:	fffff097          	auipc	ra,0xfffff
    80004044:	a76080e7          	jalr	-1418(ra) # 80002ab6 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004048:	04000713          	li	a4,64
    8000404c:	4681                	li	a3,0
    8000404e:	e5040613          	addi	a2,s0,-432
    80004052:	4581                	li	a1,0
    80004054:	8552                	mv	a0,s4
    80004056:	fffff097          	auipc	ra,0xfffff
    8000405a:	d18080e7          	jalr	-744(ra) # 80002d6e <readi>
    8000405e:	04000793          	li	a5,64
    80004062:	00f51a63          	bne	a0,a5,80004076 <exec+0x74>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004066:	e5042703          	lw	a4,-432(s0)
    8000406a:	464c47b7          	lui	a5,0x464c4
    8000406e:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004072:	02f70c63          	beq	a4,a5,800040aa <exec+0xa8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004076:	8552                	mv	a0,s4
    80004078:	fffff097          	auipc	ra,0xfffff
    8000407c:	ca4080e7          	jalr	-860(ra) # 80002d1c <iunlockput>
    end_op();
    80004080:	fffff097          	auipc	ra,0xfffff
    80004084:	482080e7          	jalr	1154(ra) # 80003502 <end_op>
  }
  return -1;
    80004088:	557d                	li	a0,-1
    8000408a:	7a1e                	ld	s4,480(sp)
}
    8000408c:	20813083          	ld	ra,520(sp)
    80004090:	20013403          	ld	s0,512(sp)
    80004094:	74fe                	ld	s1,504(sp)
    80004096:	795e                	ld	s2,496(sp)
    80004098:	21010113          	addi	sp,sp,528
    8000409c:	8082                	ret
    end_op();
    8000409e:	fffff097          	auipc	ra,0xfffff
    800040a2:	464080e7          	jalr	1124(ra) # 80003502 <end_op>
    return -1;
    800040a6:	557d                	li	a0,-1
    800040a8:	b7d5                	j	8000408c <exec+0x8a>
    800040aa:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    800040ac:	8526                	mv	a0,s1
    800040ae:	ffffd097          	auipc	ra,0xffffd
    800040b2:	e92080e7          	jalr	-366(ra) # 80000f40 <proc_pagetable>
    800040b6:	8b2a                	mv	s6,a0
    800040b8:	30050563          	beqz	a0,800043c2 <exec+0x3c0>
    800040bc:	f7ce                	sd	s3,488(sp)
    800040be:	efd6                	sd	s5,472(sp)
    800040c0:	e7de                	sd	s7,456(sp)
    800040c2:	e3e2                	sd	s8,448(sp)
    800040c4:	ff66                	sd	s9,440(sp)
    800040c6:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800040c8:	e7042d03          	lw	s10,-400(s0)
    800040cc:	e8845783          	lhu	a5,-376(s0)
    800040d0:	14078563          	beqz	a5,8000421a <exec+0x218>
    800040d4:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800040d6:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800040d8:	4d81                	li	s11,0
    if((ph.vaddr % PGSIZE) != 0)
    800040da:	6c85                	lui	s9,0x1
    800040dc:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800040e0:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    800040e4:	6a85                	lui	s5,0x1
    800040e6:	a0b5                	j	80004152 <exec+0x150>
      panic("loadseg: address should exist");
    800040e8:	00004517          	auipc	a0,0x4
    800040ec:	46850513          	addi	a0,a0,1128 # 80008550 <etext+0x550>
    800040f0:	00002097          	auipc	ra,0x2
    800040f4:	bbe080e7          	jalr	-1090(ra) # 80005cae <panic>
    if(sz - i < PGSIZE)
    800040f8:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800040fa:	8726                	mv	a4,s1
    800040fc:	012c06bb          	addw	a3,s8,s2
    80004100:	4581                	li	a1,0
    80004102:	8552                	mv	a0,s4
    80004104:	fffff097          	auipc	ra,0xfffff
    80004108:	c6a080e7          	jalr	-918(ra) # 80002d6e <readi>
    8000410c:	2501                	sext.w	a0,a0
    8000410e:	26a49e63          	bne	s1,a0,8000438a <exec+0x388>
  for(i = 0; i < sz; i += PGSIZE){
    80004112:	012a893b          	addw	s2,s5,s2
    80004116:	03397563          	bgeu	s2,s3,80004140 <exec+0x13e>
    pa = walkaddr(pagetable, va + i);
    8000411a:	02091593          	slli	a1,s2,0x20
    8000411e:	9181                	srli	a1,a1,0x20
    80004120:	95de                	add	a1,a1,s7
    80004122:	855a                	mv	a0,s6
    80004124:	ffffc097          	auipc	ra,0xffffc
    80004128:	3d4080e7          	jalr	980(ra) # 800004f8 <walkaddr>
    8000412c:	862a                	mv	a2,a0
    if(pa == 0)
    8000412e:	dd4d                	beqz	a0,800040e8 <exec+0xe6>
    if(sz - i < PGSIZE)
    80004130:	412984bb          	subw	s1,s3,s2
    80004134:	0004879b          	sext.w	a5,s1
    80004138:	fcfcf0e3          	bgeu	s9,a5,800040f8 <exec+0xf6>
    8000413c:	84d6                	mv	s1,s5
    8000413e:	bf6d                	j	800040f8 <exec+0xf6>
    sz = sz1;
    80004140:	e0843483          	ld	s1,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004144:	2d85                	addiw	s11,s11,1
    80004146:	038d0d1b          	addiw	s10,s10,56
    8000414a:	e8845783          	lhu	a5,-376(s0)
    8000414e:	06fddf63          	bge	s11,a5,800041cc <exec+0x1ca>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004152:	2d01                	sext.w	s10,s10
    80004154:	03800713          	li	a4,56
    80004158:	86ea                	mv	a3,s10
    8000415a:	e1840613          	addi	a2,s0,-488
    8000415e:	4581                	li	a1,0
    80004160:	8552                	mv	a0,s4
    80004162:	fffff097          	auipc	ra,0xfffff
    80004166:	c0c080e7          	jalr	-1012(ra) # 80002d6e <readi>
    8000416a:	03800793          	li	a5,56
    8000416e:	1ef51863          	bne	a0,a5,8000435e <exec+0x35c>
    if(ph.type != ELF_PROG_LOAD)
    80004172:	e1842783          	lw	a5,-488(s0)
    80004176:	4705                	li	a4,1
    80004178:	fce796e3          	bne	a5,a4,80004144 <exec+0x142>
    if(ph.memsz < ph.filesz)
    8000417c:	e4043603          	ld	a2,-448(s0)
    80004180:	e3843783          	ld	a5,-456(s0)
    80004184:	1ef66163          	bltu	a2,a5,80004366 <exec+0x364>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004188:	e2843783          	ld	a5,-472(s0)
    8000418c:	963e                	add	a2,a2,a5
    8000418e:	1ef66063          	bltu	a2,a5,8000436e <exec+0x36c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004192:	85a6                	mv	a1,s1
    80004194:	855a                	mv	a0,s6
    80004196:	ffffc097          	auipc	ra,0xffffc
    8000419a:	726080e7          	jalr	1830(ra) # 800008bc <uvmalloc>
    8000419e:	e0a43423          	sd	a0,-504(s0)
    800041a2:	1c050a63          	beqz	a0,80004376 <exec+0x374>
    if((ph.vaddr % PGSIZE) != 0)
    800041a6:	e2843b83          	ld	s7,-472(s0)
    800041aa:	df043783          	ld	a5,-528(s0)
    800041ae:	00fbf7b3          	and	a5,s7,a5
    800041b2:	1c079a63          	bnez	a5,80004386 <exec+0x384>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800041b6:	e2042c03          	lw	s8,-480(s0)
    800041ba:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800041be:	00098463          	beqz	s3,800041c6 <exec+0x1c4>
    800041c2:	4901                	li	s2,0
    800041c4:	bf99                	j	8000411a <exec+0x118>
    sz = sz1;
    800041c6:	e0843483          	ld	s1,-504(s0)
    800041ca:	bfad                	j	80004144 <exec+0x142>
    800041cc:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    800041ce:	8552                	mv	a0,s4
    800041d0:	fffff097          	auipc	ra,0xfffff
    800041d4:	b4c080e7          	jalr	-1204(ra) # 80002d1c <iunlockput>
  end_op();
    800041d8:	fffff097          	auipc	ra,0xfffff
    800041dc:	32a080e7          	jalr	810(ra) # 80003502 <end_op>
  p = myproc();
    800041e0:	ffffd097          	auipc	ra,0xffffd
    800041e4:	c9c080e7          	jalr	-868(ra) # 80000e7c <myproc>
    800041e8:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800041ea:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    800041ee:	6985                	lui	s3,0x1
    800041f0:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    800041f2:	99a6                	add	s3,s3,s1
    800041f4:	77fd                	lui	a5,0xfffff
    800041f6:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800041fa:	6609                	lui	a2,0x2
    800041fc:	964e                	add	a2,a2,s3
    800041fe:	85ce                	mv	a1,s3
    80004200:	855a                	mv	a0,s6
    80004202:	ffffc097          	auipc	ra,0xffffc
    80004206:	6ba080e7          	jalr	1722(ra) # 800008bc <uvmalloc>
    8000420a:	892a                	mv	s2,a0
    8000420c:	e0a43423          	sd	a0,-504(s0)
    80004210:	e519                	bnez	a0,8000421e <exec+0x21c>
  if(pagetable)
    80004212:	e1343423          	sd	s3,-504(s0)
    80004216:	4a01                	li	s4,0
    80004218:	aa95                	j	8000438c <exec+0x38a>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000421a:	4481                	li	s1,0
    8000421c:	bf4d                	j	800041ce <exec+0x1cc>
  uvmclear(pagetable, sz-2*PGSIZE);
    8000421e:	75f9                	lui	a1,0xffffe
    80004220:	95aa                	add	a1,a1,a0
    80004222:	855a                	mv	a0,s6
    80004224:	ffffd097          	auipc	ra,0xffffd
    80004228:	8c2080e7          	jalr	-1854(ra) # 80000ae6 <uvmclear>
  stackbase = sp - PGSIZE;
    8000422c:	7bfd                	lui	s7,0xfffff
    8000422e:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80004230:	e0043783          	ld	a5,-512(s0)
    80004234:	6388                	ld	a0,0(a5)
    80004236:	c52d                	beqz	a0,800042a0 <exec+0x29e>
    80004238:	e9040993          	addi	s3,s0,-368
    8000423c:	f9040c13          	addi	s8,s0,-112
    80004240:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004242:	ffffc097          	auipc	ra,0xffffc
    80004246:	0ac080e7          	jalr	172(ra) # 800002ee <strlen>
    8000424a:	0015079b          	addiw	a5,a0,1
    8000424e:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004252:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80004256:	13796463          	bltu	s2,s7,8000437e <exec+0x37c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000425a:	e0043d03          	ld	s10,-512(s0)
    8000425e:	000d3a03          	ld	s4,0(s10)
    80004262:	8552                	mv	a0,s4
    80004264:	ffffc097          	auipc	ra,0xffffc
    80004268:	08a080e7          	jalr	138(ra) # 800002ee <strlen>
    8000426c:	0015069b          	addiw	a3,a0,1
    80004270:	8652                	mv	a2,s4
    80004272:	85ca                	mv	a1,s2
    80004274:	855a                	mv	a0,s6
    80004276:	ffffd097          	auipc	ra,0xffffd
    8000427a:	8a2080e7          	jalr	-1886(ra) # 80000b18 <copyout>
    8000427e:	10054263          	bltz	a0,80004382 <exec+0x380>
    ustack[argc] = sp;
    80004282:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004286:	0485                	addi	s1,s1,1
    80004288:	008d0793          	addi	a5,s10,8
    8000428c:	e0f43023          	sd	a5,-512(s0)
    80004290:	008d3503          	ld	a0,8(s10)
    80004294:	c909                	beqz	a0,800042a6 <exec+0x2a4>
    if(argc >= MAXARG)
    80004296:	09a1                	addi	s3,s3,8
    80004298:	fb8995e3          	bne	s3,s8,80004242 <exec+0x240>
  ip = 0;
    8000429c:	4a01                	li	s4,0
    8000429e:	a0fd                	j	8000438c <exec+0x38a>
  sp = sz;
    800042a0:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    800042a4:	4481                	li	s1,0
  ustack[argc] = 0;
    800042a6:	00349793          	slli	a5,s1,0x3
    800042aa:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffd8d50>
    800042ae:	97a2                	add	a5,a5,s0
    800042b0:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    800042b4:	00148693          	addi	a3,s1,1
    800042b8:	068e                	slli	a3,a3,0x3
    800042ba:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800042be:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    800042c2:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    800042c6:	f57966e3          	bltu	s2,s7,80004212 <exec+0x210>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800042ca:	e9040613          	addi	a2,s0,-368
    800042ce:	85ca                	mv	a1,s2
    800042d0:	855a                	mv	a0,s6
    800042d2:	ffffd097          	auipc	ra,0xffffd
    800042d6:	846080e7          	jalr	-1978(ra) # 80000b18 <copyout>
    800042da:	0e054663          	bltz	a0,800043c6 <exec+0x3c4>
  p->trapframe->a1 = sp;
    800042de:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    800042e2:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800042e6:	df843783          	ld	a5,-520(s0)
    800042ea:	0007c703          	lbu	a4,0(a5)
    800042ee:	cf11                	beqz	a4,8000430a <exec+0x308>
    800042f0:	0785                	addi	a5,a5,1
    if(*s == '/')
    800042f2:	02f00693          	li	a3,47
    800042f6:	a039                	j	80004304 <exec+0x302>
      last = s+1;
    800042f8:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    800042fc:	0785                	addi	a5,a5,1
    800042fe:	fff7c703          	lbu	a4,-1(a5)
    80004302:	c701                	beqz	a4,8000430a <exec+0x308>
    if(*s == '/')
    80004304:	fed71ce3          	bne	a4,a3,800042fc <exec+0x2fa>
    80004308:	bfc5                	j	800042f8 <exec+0x2f6>
  safestrcpy(p->name, last, sizeof(p->name));
    8000430a:	4641                	li	a2,16
    8000430c:	df843583          	ld	a1,-520(s0)
    80004310:	158a8513          	addi	a0,s5,344
    80004314:	ffffc097          	auipc	ra,0xffffc
    80004318:	fa8080e7          	jalr	-88(ra) # 800002bc <safestrcpy>
  oldpagetable = p->pagetable;
    8000431c:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004320:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80004324:	e0843783          	ld	a5,-504(s0)
    80004328:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    8000432c:	058ab783          	ld	a5,88(s5)
    80004330:	e6843703          	ld	a4,-408(s0)
    80004334:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004336:	058ab783          	ld	a5,88(s5)
    8000433a:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000433e:	85e6                	mv	a1,s9
    80004340:	ffffd097          	auipc	ra,0xffffd
    80004344:	c9c080e7          	jalr	-868(ra) # 80000fdc <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004348:	0004851b          	sext.w	a0,s1
    8000434c:	79be                	ld	s3,488(sp)
    8000434e:	7a1e                	ld	s4,480(sp)
    80004350:	6afe                	ld	s5,472(sp)
    80004352:	6b5e                	ld	s6,464(sp)
    80004354:	6bbe                	ld	s7,456(sp)
    80004356:	6c1e                	ld	s8,448(sp)
    80004358:	7cfa                	ld	s9,440(sp)
    8000435a:	7d5a                	ld	s10,432(sp)
    8000435c:	bb05                	j	8000408c <exec+0x8a>
    8000435e:	e0943423          	sd	s1,-504(s0)
    80004362:	7dba                	ld	s11,424(sp)
    80004364:	a025                	j	8000438c <exec+0x38a>
    80004366:	e0943423          	sd	s1,-504(s0)
    8000436a:	7dba                	ld	s11,424(sp)
    8000436c:	a005                	j	8000438c <exec+0x38a>
    8000436e:	e0943423          	sd	s1,-504(s0)
    80004372:	7dba                	ld	s11,424(sp)
    80004374:	a821                	j	8000438c <exec+0x38a>
    80004376:	e0943423          	sd	s1,-504(s0)
    8000437a:	7dba                	ld	s11,424(sp)
    8000437c:	a801                	j	8000438c <exec+0x38a>
  ip = 0;
    8000437e:	4a01                	li	s4,0
    80004380:	a031                	j	8000438c <exec+0x38a>
    80004382:	4a01                	li	s4,0
  if(pagetable)
    80004384:	a021                	j	8000438c <exec+0x38a>
    80004386:	7dba                	ld	s11,424(sp)
    80004388:	a011                	j	8000438c <exec+0x38a>
    8000438a:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    8000438c:	e0843583          	ld	a1,-504(s0)
    80004390:	855a                	mv	a0,s6
    80004392:	ffffd097          	auipc	ra,0xffffd
    80004396:	c4a080e7          	jalr	-950(ra) # 80000fdc <proc_freepagetable>
  return -1;
    8000439a:	557d                	li	a0,-1
  if(ip){
    8000439c:	000a1b63          	bnez	s4,800043b2 <exec+0x3b0>
    800043a0:	79be                	ld	s3,488(sp)
    800043a2:	7a1e                	ld	s4,480(sp)
    800043a4:	6afe                	ld	s5,472(sp)
    800043a6:	6b5e                	ld	s6,464(sp)
    800043a8:	6bbe                	ld	s7,456(sp)
    800043aa:	6c1e                	ld	s8,448(sp)
    800043ac:	7cfa                	ld	s9,440(sp)
    800043ae:	7d5a                	ld	s10,432(sp)
    800043b0:	b9f1                	j	8000408c <exec+0x8a>
    800043b2:	79be                	ld	s3,488(sp)
    800043b4:	6afe                	ld	s5,472(sp)
    800043b6:	6b5e                	ld	s6,464(sp)
    800043b8:	6bbe                	ld	s7,456(sp)
    800043ba:	6c1e                	ld	s8,448(sp)
    800043bc:	7cfa                	ld	s9,440(sp)
    800043be:	7d5a                	ld	s10,432(sp)
    800043c0:	b95d                	j	80004076 <exec+0x74>
    800043c2:	6b5e                	ld	s6,464(sp)
    800043c4:	b94d                	j	80004076 <exec+0x74>
  sz = sz1;
    800043c6:	e0843983          	ld	s3,-504(s0)
    800043ca:	b5a1                	j	80004212 <exec+0x210>

00000000800043cc <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800043cc:	7179                	addi	sp,sp,-48
    800043ce:	f406                	sd	ra,40(sp)
    800043d0:	f022                	sd	s0,32(sp)
    800043d2:	ec26                	sd	s1,24(sp)
    800043d4:	e84a                	sd	s2,16(sp)
    800043d6:	1800                	addi	s0,sp,48
    800043d8:	892e                	mv	s2,a1
    800043da:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    800043dc:	fdc40593          	addi	a1,s0,-36
    800043e0:	ffffe097          	auipc	ra,0xffffe
    800043e4:	b5c080e7          	jalr	-1188(ra) # 80001f3c <argint>
    800043e8:	04054063          	bltz	a0,80004428 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800043ec:	fdc42703          	lw	a4,-36(s0)
    800043f0:	47bd                	li	a5,15
    800043f2:	02e7ed63          	bltu	a5,a4,8000442c <argfd+0x60>
    800043f6:	ffffd097          	auipc	ra,0xffffd
    800043fa:	a86080e7          	jalr	-1402(ra) # 80000e7c <myproc>
    800043fe:	fdc42703          	lw	a4,-36(s0)
    80004402:	01a70793          	addi	a5,a4,26
    80004406:	078e                	slli	a5,a5,0x3
    80004408:	953e                	add	a0,a0,a5
    8000440a:	611c                	ld	a5,0(a0)
    8000440c:	c395                	beqz	a5,80004430 <argfd+0x64>
    return -1;
  if(pfd)
    8000440e:	00090463          	beqz	s2,80004416 <argfd+0x4a>
    *pfd = fd;
    80004412:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004416:	4501                	li	a0,0
  if(pf)
    80004418:	c091                	beqz	s1,8000441c <argfd+0x50>
    *pf = f;
    8000441a:	e09c                	sd	a5,0(s1)
}
    8000441c:	70a2                	ld	ra,40(sp)
    8000441e:	7402                	ld	s0,32(sp)
    80004420:	64e2                	ld	s1,24(sp)
    80004422:	6942                	ld	s2,16(sp)
    80004424:	6145                	addi	sp,sp,48
    80004426:	8082                	ret
    return -1;
    80004428:	557d                	li	a0,-1
    8000442a:	bfcd                	j	8000441c <argfd+0x50>
    return -1;
    8000442c:	557d                	li	a0,-1
    8000442e:	b7fd                	j	8000441c <argfd+0x50>
    80004430:	557d                	li	a0,-1
    80004432:	b7ed                	j	8000441c <argfd+0x50>

0000000080004434 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004434:	1101                	addi	sp,sp,-32
    80004436:	ec06                	sd	ra,24(sp)
    80004438:	e822                	sd	s0,16(sp)
    8000443a:	e426                	sd	s1,8(sp)
    8000443c:	1000                	addi	s0,sp,32
    8000443e:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004440:	ffffd097          	auipc	ra,0xffffd
    80004444:	a3c080e7          	jalr	-1476(ra) # 80000e7c <myproc>
    80004448:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    8000444a:	0d050793          	addi	a5,a0,208
    8000444e:	4501                	li	a0,0
    80004450:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004452:	6398                	ld	a4,0(a5)
    80004454:	cb19                	beqz	a4,8000446a <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004456:	2505                	addiw	a0,a0,1
    80004458:	07a1                	addi	a5,a5,8
    8000445a:	fed51ce3          	bne	a0,a3,80004452 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000445e:	557d                	li	a0,-1
}
    80004460:	60e2                	ld	ra,24(sp)
    80004462:	6442                	ld	s0,16(sp)
    80004464:	64a2                	ld	s1,8(sp)
    80004466:	6105                	addi	sp,sp,32
    80004468:	8082                	ret
      p->ofile[fd] = f;
    8000446a:	01a50793          	addi	a5,a0,26
    8000446e:	078e                	slli	a5,a5,0x3
    80004470:	963e                	add	a2,a2,a5
    80004472:	e204                	sd	s1,0(a2)
      return fd;
    80004474:	b7f5                	j	80004460 <fdalloc+0x2c>

0000000080004476 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004476:	715d                	addi	sp,sp,-80
    80004478:	e486                	sd	ra,72(sp)
    8000447a:	e0a2                	sd	s0,64(sp)
    8000447c:	fc26                	sd	s1,56(sp)
    8000447e:	f84a                	sd	s2,48(sp)
    80004480:	f44e                	sd	s3,40(sp)
    80004482:	f052                	sd	s4,32(sp)
    80004484:	ec56                	sd	s5,24(sp)
    80004486:	0880                	addi	s0,sp,80
    80004488:	8aae                	mv	s5,a1
    8000448a:	8a32                	mv	s4,a2
    8000448c:	89b6                	mv	s3,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    8000448e:	fb040593          	addi	a1,s0,-80
    80004492:	fffff097          	auipc	ra,0xfffff
    80004496:	e14080e7          	jalr	-492(ra) # 800032a6 <nameiparent>
    8000449a:	892a                	mv	s2,a0
    8000449c:	12050c63          	beqz	a0,800045d4 <create+0x15e>
    return 0;

  ilock(dp);
    800044a0:	ffffe097          	auipc	ra,0xffffe
    800044a4:	616080e7          	jalr	1558(ra) # 80002ab6 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800044a8:	4601                	li	a2,0
    800044aa:	fb040593          	addi	a1,s0,-80
    800044ae:	854a                	mv	a0,s2
    800044b0:	fffff097          	auipc	ra,0xfffff
    800044b4:	b06080e7          	jalr	-1274(ra) # 80002fb6 <dirlookup>
    800044b8:	84aa                	mv	s1,a0
    800044ba:	c539                	beqz	a0,80004508 <create+0x92>
    iunlockput(dp);
    800044bc:	854a                	mv	a0,s2
    800044be:	fffff097          	auipc	ra,0xfffff
    800044c2:	85e080e7          	jalr	-1954(ra) # 80002d1c <iunlockput>
    ilock(ip);
    800044c6:	8526                	mv	a0,s1
    800044c8:	ffffe097          	auipc	ra,0xffffe
    800044cc:	5ee080e7          	jalr	1518(ra) # 80002ab6 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800044d0:	4789                	li	a5,2
    800044d2:	02fa9463          	bne	s5,a5,800044fa <create+0x84>
    800044d6:	0444d783          	lhu	a5,68(s1)
    800044da:	37f9                	addiw	a5,a5,-2
    800044dc:	17c2                	slli	a5,a5,0x30
    800044de:	93c1                	srli	a5,a5,0x30
    800044e0:	4705                	li	a4,1
    800044e2:	00f76c63          	bltu	a4,a5,800044fa <create+0x84>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    800044e6:	8526                	mv	a0,s1
    800044e8:	60a6                	ld	ra,72(sp)
    800044ea:	6406                	ld	s0,64(sp)
    800044ec:	74e2                	ld	s1,56(sp)
    800044ee:	7942                	ld	s2,48(sp)
    800044f0:	79a2                	ld	s3,40(sp)
    800044f2:	7a02                	ld	s4,32(sp)
    800044f4:	6ae2                	ld	s5,24(sp)
    800044f6:	6161                	addi	sp,sp,80
    800044f8:	8082                	ret
    iunlockput(ip);
    800044fa:	8526                	mv	a0,s1
    800044fc:	fffff097          	auipc	ra,0xfffff
    80004500:	820080e7          	jalr	-2016(ra) # 80002d1c <iunlockput>
    return 0;
    80004504:	4481                	li	s1,0
    80004506:	b7c5                	j	800044e6 <create+0x70>
  if((ip = ialloc(dp->dev, type)) == 0)
    80004508:	85d6                	mv	a1,s5
    8000450a:	00092503          	lw	a0,0(s2)
    8000450e:	ffffe097          	auipc	ra,0xffffe
    80004512:	414080e7          	jalr	1044(ra) # 80002922 <ialloc>
    80004516:	84aa                	mv	s1,a0
    80004518:	c139                	beqz	a0,8000455e <create+0xe8>
  ilock(ip);
    8000451a:	ffffe097          	auipc	ra,0xffffe
    8000451e:	59c080e7          	jalr	1436(ra) # 80002ab6 <ilock>
  ip->major = major;
    80004522:	05449323          	sh	s4,70(s1)
  ip->minor = minor;
    80004526:	05349423          	sh	s3,72(s1)
  ip->nlink = 1;
    8000452a:	4985                	li	s3,1
    8000452c:	05349523          	sh	s3,74(s1)
  iupdate(ip);
    80004530:	8526                	mv	a0,s1
    80004532:	ffffe097          	auipc	ra,0xffffe
    80004536:	4b8080e7          	jalr	1208(ra) # 800029ea <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    8000453a:	033a8a63          	beq	s5,s3,8000456e <create+0xf8>
  if(dirlink(dp, name, ip->inum) < 0)
    8000453e:	40d0                	lw	a2,4(s1)
    80004540:	fb040593          	addi	a1,s0,-80
    80004544:	854a                	mv	a0,s2
    80004546:	fffff097          	auipc	ra,0xfffff
    8000454a:	c80080e7          	jalr	-896(ra) # 800031c6 <dirlink>
    8000454e:	06054b63          	bltz	a0,800045c4 <create+0x14e>
  iunlockput(dp);
    80004552:	854a                	mv	a0,s2
    80004554:	ffffe097          	auipc	ra,0xffffe
    80004558:	7c8080e7          	jalr	1992(ra) # 80002d1c <iunlockput>
  return ip;
    8000455c:	b769                	j	800044e6 <create+0x70>
    panic("create: ialloc");
    8000455e:	00004517          	auipc	a0,0x4
    80004562:	01250513          	addi	a0,a0,18 # 80008570 <etext+0x570>
    80004566:	00001097          	auipc	ra,0x1
    8000456a:	748080e7          	jalr	1864(ra) # 80005cae <panic>
    dp->nlink++;  // for ".."
    8000456e:	04a95783          	lhu	a5,74(s2)
    80004572:	2785                	addiw	a5,a5,1
    80004574:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    80004578:	854a                	mv	a0,s2
    8000457a:	ffffe097          	auipc	ra,0xffffe
    8000457e:	470080e7          	jalr	1136(ra) # 800029ea <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004582:	40d0                	lw	a2,4(s1)
    80004584:	00004597          	auipc	a1,0x4
    80004588:	ffc58593          	addi	a1,a1,-4 # 80008580 <etext+0x580>
    8000458c:	8526                	mv	a0,s1
    8000458e:	fffff097          	auipc	ra,0xfffff
    80004592:	c38080e7          	jalr	-968(ra) # 800031c6 <dirlink>
    80004596:	00054f63          	bltz	a0,800045b4 <create+0x13e>
    8000459a:	00492603          	lw	a2,4(s2)
    8000459e:	00004597          	auipc	a1,0x4
    800045a2:	fea58593          	addi	a1,a1,-22 # 80008588 <etext+0x588>
    800045a6:	8526                	mv	a0,s1
    800045a8:	fffff097          	auipc	ra,0xfffff
    800045ac:	c1e080e7          	jalr	-994(ra) # 800031c6 <dirlink>
    800045b0:	f80557e3          	bgez	a0,8000453e <create+0xc8>
      panic("create dots");
    800045b4:	00004517          	auipc	a0,0x4
    800045b8:	fdc50513          	addi	a0,a0,-36 # 80008590 <etext+0x590>
    800045bc:	00001097          	auipc	ra,0x1
    800045c0:	6f2080e7          	jalr	1778(ra) # 80005cae <panic>
    panic("create: dirlink");
    800045c4:	00004517          	auipc	a0,0x4
    800045c8:	fdc50513          	addi	a0,a0,-36 # 800085a0 <etext+0x5a0>
    800045cc:	00001097          	auipc	ra,0x1
    800045d0:	6e2080e7          	jalr	1762(ra) # 80005cae <panic>
    return 0;
    800045d4:	84aa                	mv	s1,a0
    800045d6:	bf01                	j	800044e6 <create+0x70>

00000000800045d8 <sys_dup>:
{
    800045d8:	7179                	addi	sp,sp,-48
    800045da:	f406                	sd	ra,40(sp)
    800045dc:	f022                	sd	s0,32(sp)
    800045de:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800045e0:	fd840613          	addi	a2,s0,-40
    800045e4:	4581                	li	a1,0
    800045e6:	4501                	li	a0,0
    800045e8:	00000097          	auipc	ra,0x0
    800045ec:	de4080e7          	jalr	-540(ra) # 800043cc <argfd>
    return -1;
    800045f0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800045f2:	02054763          	bltz	a0,80004620 <sys_dup+0x48>
    800045f6:	ec26                	sd	s1,24(sp)
    800045f8:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    800045fa:	fd843903          	ld	s2,-40(s0)
    800045fe:	854a                	mv	a0,s2
    80004600:	00000097          	auipc	ra,0x0
    80004604:	e34080e7          	jalr	-460(ra) # 80004434 <fdalloc>
    80004608:	84aa                	mv	s1,a0
    return -1;
    8000460a:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    8000460c:	00054f63          	bltz	a0,8000462a <sys_dup+0x52>
  filedup(f);
    80004610:	854a                	mv	a0,s2
    80004612:	fffff097          	auipc	ra,0xfffff
    80004616:	2ee080e7          	jalr	750(ra) # 80003900 <filedup>
  return fd;
    8000461a:	87a6                	mv	a5,s1
    8000461c:	64e2                	ld	s1,24(sp)
    8000461e:	6942                	ld	s2,16(sp)
}
    80004620:	853e                	mv	a0,a5
    80004622:	70a2                	ld	ra,40(sp)
    80004624:	7402                	ld	s0,32(sp)
    80004626:	6145                	addi	sp,sp,48
    80004628:	8082                	ret
    8000462a:	64e2                	ld	s1,24(sp)
    8000462c:	6942                	ld	s2,16(sp)
    8000462e:	bfcd                	j	80004620 <sys_dup+0x48>

0000000080004630 <sys_read>:
{
    80004630:	7179                	addi	sp,sp,-48
    80004632:	f406                	sd	ra,40(sp)
    80004634:	f022                	sd	s0,32(sp)
    80004636:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004638:	fe840613          	addi	a2,s0,-24
    8000463c:	4581                	li	a1,0
    8000463e:	4501                	li	a0,0
    80004640:	00000097          	auipc	ra,0x0
    80004644:	d8c080e7          	jalr	-628(ra) # 800043cc <argfd>
    return -1;
    80004648:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000464a:	04054163          	bltz	a0,8000468c <sys_read+0x5c>
    8000464e:	fe440593          	addi	a1,s0,-28
    80004652:	4509                	li	a0,2
    80004654:	ffffe097          	auipc	ra,0xffffe
    80004658:	8e8080e7          	jalr	-1816(ra) # 80001f3c <argint>
    return -1;
    8000465c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000465e:	02054763          	bltz	a0,8000468c <sys_read+0x5c>
    80004662:	fd840593          	addi	a1,s0,-40
    80004666:	4505                	li	a0,1
    80004668:	ffffe097          	auipc	ra,0xffffe
    8000466c:	8f6080e7          	jalr	-1802(ra) # 80001f5e <argaddr>
    return -1;
    80004670:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004672:	00054d63          	bltz	a0,8000468c <sys_read+0x5c>
  return fileread(f, p, n);
    80004676:	fe442603          	lw	a2,-28(s0)
    8000467a:	fd843583          	ld	a1,-40(s0)
    8000467e:	fe843503          	ld	a0,-24(s0)
    80004682:	fffff097          	auipc	ra,0xfffff
    80004686:	424080e7          	jalr	1060(ra) # 80003aa6 <fileread>
    8000468a:	87aa                	mv	a5,a0
}
    8000468c:	853e                	mv	a0,a5
    8000468e:	70a2                	ld	ra,40(sp)
    80004690:	7402                	ld	s0,32(sp)
    80004692:	6145                	addi	sp,sp,48
    80004694:	8082                	ret

0000000080004696 <sys_write>:
{
    80004696:	7179                	addi	sp,sp,-48
    80004698:	f406                	sd	ra,40(sp)
    8000469a:	f022                	sd	s0,32(sp)
    8000469c:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000469e:	fe840613          	addi	a2,s0,-24
    800046a2:	4581                	li	a1,0
    800046a4:	4501                	li	a0,0
    800046a6:	00000097          	auipc	ra,0x0
    800046aa:	d26080e7          	jalr	-730(ra) # 800043cc <argfd>
    return -1;
    800046ae:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046b0:	04054163          	bltz	a0,800046f2 <sys_write+0x5c>
    800046b4:	fe440593          	addi	a1,s0,-28
    800046b8:	4509                	li	a0,2
    800046ba:	ffffe097          	auipc	ra,0xffffe
    800046be:	882080e7          	jalr	-1918(ra) # 80001f3c <argint>
    return -1;
    800046c2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046c4:	02054763          	bltz	a0,800046f2 <sys_write+0x5c>
    800046c8:	fd840593          	addi	a1,s0,-40
    800046cc:	4505                	li	a0,1
    800046ce:	ffffe097          	auipc	ra,0xffffe
    800046d2:	890080e7          	jalr	-1904(ra) # 80001f5e <argaddr>
    return -1;
    800046d6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046d8:	00054d63          	bltz	a0,800046f2 <sys_write+0x5c>
  return filewrite(f, p, n);
    800046dc:	fe442603          	lw	a2,-28(s0)
    800046e0:	fd843583          	ld	a1,-40(s0)
    800046e4:	fe843503          	ld	a0,-24(s0)
    800046e8:	fffff097          	auipc	ra,0xfffff
    800046ec:	490080e7          	jalr	1168(ra) # 80003b78 <filewrite>
    800046f0:	87aa                	mv	a5,a0
}
    800046f2:	853e                	mv	a0,a5
    800046f4:	70a2                	ld	ra,40(sp)
    800046f6:	7402                	ld	s0,32(sp)
    800046f8:	6145                	addi	sp,sp,48
    800046fa:	8082                	ret

00000000800046fc <sys_close>:
{
    800046fc:	1101                	addi	sp,sp,-32
    800046fe:	ec06                	sd	ra,24(sp)
    80004700:	e822                	sd	s0,16(sp)
    80004702:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004704:	fe040613          	addi	a2,s0,-32
    80004708:	fec40593          	addi	a1,s0,-20
    8000470c:	4501                	li	a0,0
    8000470e:	00000097          	auipc	ra,0x0
    80004712:	cbe080e7          	jalr	-834(ra) # 800043cc <argfd>
    return -1;
    80004716:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004718:	02054463          	bltz	a0,80004740 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    8000471c:	ffffc097          	auipc	ra,0xffffc
    80004720:	760080e7          	jalr	1888(ra) # 80000e7c <myproc>
    80004724:	fec42783          	lw	a5,-20(s0)
    80004728:	07e9                	addi	a5,a5,26
    8000472a:	078e                	slli	a5,a5,0x3
    8000472c:	953e                	add	a0,a0,a5
    8000472e:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004732:	fe043503          	ld	a0,-32(s0)
    80004736:	fffff097          	auipc	ra,0xfffff
    8000473a:	21c080e7          	jalr	540(ra) # 80003952 <fileclose>
  return 0;
    8000473e:	4781                	li	a5,0
}
    80004740:	853e                	mv	a0,a5
    80004742:	60e2                	ld	ra,24(sp)
    80004744:	6442                	ld	s0,16(sp)
    80004746:	6105                	addi	sp,sp,32
    80004748:	8082                	ret

000000008000474a <sys_fstat>:
{
    8000474a:	1101                	addi	sp,sp,-32
    8000474c:	ec06                	sd	ra,24(sp)
    8000474e:	e822                	sd	s0,16(sp)
    80004750:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004752:	fe840613          	addi	a2,s0,-24
    80004756:	4581                	li	a1,0
    80004758:	4501                	li	a0,0
    8000475a:	00000097          	auipc	ra,0x0
    8000475e:	c72080e7          	jalr	-910(ra) # 800043cc <argfd>
    return -1;
    80004762:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004764:	02054563          	bltz	a0,8000478e <sys_fstat+0x44>
    80004768:	fe040593          	addi	a1,s0,-32
    8000476c:	4505                	li	a0,1
    8000476e:	ffffd097          	auipc	ra,0xffffd
    80004772:	7f0080e7          	jalr	2032(ra) # 80001f5e <argaddr>
    return -1;
    80004776:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004778:	00054b63          	bltz	a0,8000478e <sys_fstat+0x44>
  return filestat(f, st);
    8000477c:	fe043583          	ld	a1,-32(s0)
    80004780:	fe843503          	ld	a0,-24(s0)
    80004784:	fffff097          	auipc	ra,0xfffff
    80004788:	2b0080e7          	jalr	688(ra) # 80003a34 <filestat>
    8000478c:	87aa                	mv	a5,a0
}
    8000478e:	853e                	mv	a0,a5
    80004790:	60e2                	ld	ra,24(sp)
    80004792:	6442                	ld	s0,16(sp)
    80004794:	6105                	addi	sp,sp,32
    80004796:	8082                	ret

0000000080004798 <sys_link>:
{
    80004798:	7169                	addi	sp,sp,-304
    8000479a:	f606                	sd	ra,296(sp)
    8000479c:	f222                	sd	s0,288(sp)
    8000479e:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800047a0:	08000613          	li	a2,128
    800047a4:	ed040593          	addi	a1,s0,-304
    800047a8:	4501                	li	a0,0
    800047aa:	ffffd097          	auipc	ra,0xffffd
    800047ae:	7d6080e7          	jalr	2006(ra) # 80001f80 <argstr>
    return -1;
    800047b2:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800047b4:	12054663          	bltz	a0,800048e0 <sys_link+0x148>
    800047b8:	08000613          	li	a2,128
    800047bc:	f5040593          	addi	a1,s0,-176
    800047c0:	4505                	li	a0,1
    800047c2:	ffffd097          	auipc	ra,0xffffd
    800047c6:	7be080e7          	jalr	1982(ra) # 80001f80 <argstr>
    return -1;
    800047ca:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800047cc:	10054a63          	bltz	a0,800048e0 <sys_link+0x148>
    800047d0:	ee26                	sd	s1,280(sp)
  begin_op();
    800047d2:	fffff097          	auipc	ra,0xfffff
    800047d6:	cb6080e7          	jalr	-842(ra) # 80003488 <begin_op>
  if((ip = namei(old)) == 0){
    800047da:	ed040513          	addi	a0,s0,-304
    800047de:	fffff097          	auipc	ra,0xfffff
    800047e2:	aaa080e7          	jalr	-1366(ra) # 80003288 <namei>
    800047e6:	84aa                	mv	s1,a0
    800047e8:	c949                	beqz	a0,8000487a <sys_link+0xe2>
  ilock(ip);
    800047ea:	ffffe097          	auipc	ra,0xffffe
    800047ee:	2cc080e7          	jalr	716(ra) # 80002ab6 <ilock>
  if(ip->type == T_DIR){
    800047f2:	04449703          	lh	a4,68(s1)
    800047f6:	4785                	li	a5,1
    800047f8:	08f70863          	beq	a4,a5,80004888 <sys_link+0xf0>
    800047fc:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    800047fe:	04a4d783          	lhu	a5,74(s1)
    80004802:	2785                	addiw	a5,a5,1
    80004804:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004808:	8526                	mv	a0,s1
    8000480a:	ffffe097          	auipc	ra,0xffffe
    8000480e:	1e0080e7          	jalr	480(ra) # 800029ea <iupdate>
  iunlock(ip);
    80004812:	8526                	mv	a0,s1
    80004814:	ffffe097          	auipc	ra,0xffffe
    80004818:	368080e7          	jalr	872(ra) # 80002b7c <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    8000481c:	fd040593          	addi	a1,s0,-48
    80004820:	f5040513          	addi	a0,s0,-176
    80004824:	fffff097          	auipc	ra,0xfffff
    80004828:	a82080e7          	jalr	-1406(ra) # 800032a6 <nameiparent>
    8000482c:	892a                	mv	s2,a0
    8000482e:	cd35                	beqz	a0,800048aa <sys_link+0x112>
  ilock(dp);
    80004830:	ffffe097          	auipc	ra,0xffffe
    80004834:	286080e7          	jalr	646(ra) # 80002ab6 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004838:	00092703          	lw	a4,0(s2)
    8000483c:	409c                	lw	a5,0(s1)
    8000483e:	06f71163          	bne	a4,a5,800048a0 <sys_link+0x108>
    80004842:	40d0                	lw	a2,4(s1)
    80004844:	fd040593          	addi	a1,s0,-48
    80004848:	854a                	mv	a0,s2
    8000484a:	fffff097          	auipc	ra,0xfffff
    8000484e:	97c080e7          	jalr	-1668(ra) # 800031c6 <dirlink>
    80004852:	04054763          	bltz	a0,800048a0 <sys_link+0x108>
  iunlockput(dp);
    80004856:	854a                	mv	a0,s2
    80004858:	ffffe097          	auipc	ra,0xffffe
    8000485c:	4c4080e7          	jalr	1220(ra) # 80002d1c <iunlockput>
  iput(ip);
    80004860:	8526                	mv	a0,s1
    80004862:	ffffe097          	auipc	ra,0xffffe
    80004866:	412080e7          	jalr	1042(ra) # 80002c74 <iput>
  end_op();
    8000486a:	fffff097          	auipc	ra,0xfffff
    8000486e:	c98080e7          	jalr	-872(ra) # 80003502 <end_op>
  return 0;
    80004872:	4781                	li	a5,0
    80004874:	64f2                	ld	s1,280(sp)
    80004876:	6952                	ld	s2,272(sp)
    80004878:	a0a5                	j	800048e0 <sys_link+0x148>
    end_op();
    8000487a:	fffff097          	auipc	ra,0xfffff
    8000487e:	c88080e7          	jalr	-888(ra) # 80003502 <end_op>
    return -1;
    80004882:	57fd                	li	a5,-1
    80004884:	64f2                	ld	s1,280(sp)
    80004886:	a8a9                	j	800048e0 <sys_link+0x148>
    iunlockput(ip);
    80004888:	8526                	mv	a0,s1
    8000488a:	ffffe097          	auipc	ra,0xffffe
    8000488e:	492080e7          	jalr	1170(ra) # 80002d1c <iunlockput>
    end_op();
    80004892:	fffff097          	auipc	ra,0xfffff
    80004896:	c70080e7          	jalr	-912(ra) # 80003502 <end_op>
    return -1;
    8000489a:	57fd                	li	a5,-1
    8000489c:	64f2                	ld	s1,280(sp)
    8000489e:	a089                	j	800048e0 <sys_link+0x148>
    iunlockput(dp);
    800048a0:	854a                	mv	a0,s2
    800048a2:	ffffe097          	auipc	ra,0xffffe
    800048a6:	47a080e7          	jalr	1146(ra) # 80002d1c <iunlockput>
  ilock(ip);
    800048aa:	8526                	mv	a0,s1
    800048ac:	ffffe097          	auipc	ra,0xffffe
    800048b0:	20a080e7          	jalr	522(ra) # 80002ab6 <ilock>
  ip->nlink--;
    800048b4:	04a4d783          	lhu	a5,74(s1)
    800048b8:	37fd                	addiw	a5,a5,-1
    800048ba:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800048be:	8526                	mv	a0,s1
    800048c0:	ffffe097          	auipc	ra,0xffffe
    800048c4:	12a080e7          	jalr	298(ra) # 800029ea <iupdate>
  iunlockput(ip);
    800048c8:	8526                	mv	a0,s1
    800048ca:	ffffe097          	auipc	ra,0xffffe
    800048ce:	452080e7          	jalr	1106(ra) # 80002d1c <iunlockput>
  end_op();
    800048d2:	fffff097          	auipc	ra,0xfffff
    800048d6:	c30080e7          	jalr	-976(ra) # 80003502 <end_op>
  return -1;
    800048da:	57fd                	li	a5,-1
    800048dc:	64f2                	ld	s1,280(sp)
    800048de:	6952                	ld	s2,272(sp)
}
    800048e0:	853e                	mv	a0,a5
    800048e2:	70b2                	ld	ra,296(sp)
    800048e4:	7412                	ld	s0,288(sp)
    800048e6:	6155                	addi	sp,sp,304
    800048e8:	8082                	ret

00000000800048ea <sys_unlink>:
{
    800048ea:	7151                	addi	sp,sp,-240
    800048ec:	f586                	sd	ra,232(sp)
    800048ee:	f1a2                	sd	s0,224(sp)
    800048f0:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800048f2:	08000613          	li	a2,128
    800048f6:	f3040593          	addi	a1,s0,-208
    800048fa:	4501                	li	a0,0
    800048fc:	ffffd097          	auipc	ra,0xffffd
    80004900:	684080e7          	jalr	1668(ra) # 80001f80 <argstr>
    80004904:	1a054a63          	bltz	a0,80004ab8 <sys_unlink+0x1ce>
    80004908:	eda6                	sd	s1,216(sp)
  begin_op();
    8000490a:	fffff097          	auipc	ra,0xfffff
    8000490e:	b7e080e7          	jalr	-1154(ra) # 80003488 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004912:	fb040593          	addi	a1,s0,-80
    80004916:	f3040513          	addi	a0,s0,-208
    8000491a:	fffff097          	auipc	ra,0xfffff
    8000491e:	98c080e7          	jalr	-1652(ra) # 800032a6 <nameiparent>
    80004922:	84aa                	mv	s1,a0
    80004924:	cd71                	beqz	a0,80004a00 <sys_unlink+0x116>
  ilock(dp);
    80004926:	ffffe097          	auipc	ra,0xffffe
    8000492a:	190080e7          	jalr	400(ra) # 80002ab6 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    8000492e:	00004597          	auipc	a1,0x4
    80004932:	c5258593          	addi	a1,a1,-942 # 80008580 <etext+0x580>
    80004936:	fb040513          	addi	a0,s0,-80
    8000493a:	ffffe097          	auipc	ra,0xffffe
    8000493e:	662080e7          	jalr	1634(ra) # 80002f9c <namecmp>
    80004942:	14050c63          	beqz	a0,80004a9a <sys_unlink+0x1b0>
    80004946:	00004597          	auipc	a1,0x4
    8000494a:	c4258593          	addi	a1,a1,-958 # 80008588 <etext+0x588>
    8000494e:	fb040513          	addi	a0,s0,-80
    80004952:	ffffe097          	auipc	ra,0xffffe
    80004956:	64a080e7          	jalr	1610(ra) # 80002f9c <namecmp>
    8000495a:	14050063          	beqz	a0,80004a9a <sys_unlink+0x1b0>
    8000495e:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004960:	f2c40613          	addi	a2,s0,-212
    80004964:	fb040593          	addi	a1,s0,-80
    80004968:	8526                	mv	a0,s1
    8000496a:	ffffe097          	auipc	ra,0xffffe
    8000496e:	64c080e7          	jalr	1612(ra) # 80002fb6 <dirlookup>
    80004972:	892a                	mv	s2,a0
    80004974:	12050263          	beqz	a0,80004a98 <sys_unlink+0x1ae>
  ilock(ip);
    80004978:	ffffe097          	auipc	ra,0xffffe
    8000497c:	13e080e7          	jalr	318(ra) # 80002ab6 <ilock>
  if(ip->nlink < 1)
    80004980:	04a91783          	lh	a5,74(s2)
    80004984:	08f05563          	blez	a5,80004a0e <sys_unlink+0x124>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004988:	04491703          	lh	a4,68(s2)
    8000498c:	4785                	li	a5,1
    8000498e:	08f70963          	beq	a4,a5,80004a20 <sys_unlink+0x136>
  memset(&de, 0, sizeof(de));
    80004992:	4641                	li	a2,16
    80004994:	4581                	li	a1,0
    80004996:	fc040513          	addi	a0,s0,-64
    8000499a:	ffffb097          	auipc	ra,0xffffb
    8000499e:	7e0080e7          	jalr	2016(ra) # 8000017a <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800049a2:	4741                	li	a4,16
    800049a4:	f2c42683          	lw	a3,-212(s0)
    800049a8:	fc040613          	addi	a2,s0,-64
    800049ac:	4581                	li	a1,0
    800049ae:	8526                	mv	a0,s1
    800049b0:	ffffe097          	auipc	ra,0xffffe
    800049b4:	4c2080e7          	jalr	1218(ra) # 80002e72 <writei>
    800049b8:	47c1                	li	a5,16
    800049ba:	0af51b63          	bne	a0,a5,80004a70 <sys_unlink+0x186>
  if(ip->type == T_DIR){
    800049be:	04491703          	lh	a4,68(s2)
    800049c2:	4785                	li	a5,1
    800049c4:	0af70f63          	beq	a4,a5,80004a82 <sys_unlink+0x198>
  iunlockput(dp);
    800049c8:	8526                	mv	a0,s1
    800049ca:	ffffe097          	auipc	ra,0xffffe
    800049ce:	352080e7          	jalr	850(ra) # 80002d1c <iunlockput>
  ip->nlink--;
    800049d2:	04a95783          	lhu	a5,74(s2)
    800049d6:	37fd                	addiw	a5,a5,-1
    800049d8:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800049dc:	854a                	mv	a0,s2
    800049de:	ffffe097          	auipc	ra,0xffffe
    800049e2:	00c080e7          	jalr	12(ra) # 800029ea <iupdate>
  iunlockput(ip);
    800049e6:	854a                	mv	a0,s2
    800049e8:	ffffe097          	auipc	ra,0xffffe
    800049ec:	334080e7          	jalr	820(ra) # 80002d1c <iunlockput>
  end_op();
    800049f0:	fffff097          	auipc	ra,0xfffff
    800049f4:	b12080e7          	jalr	-1262(ra) # 80003502 <end_op>
  return 0;
    800049f8:	4501                	li	a0,0
    800049fa:	64ee                	ld	s1,216(sp)
    800049fc:	694e                	ld	s2,208(sp)
    800049fe:	a84d                	j	80004ab0 <sys_unlink+0x1c6>
    end_op();
    80004a00:	fffff097          	auipc	ra,0xfffff
    80004a04:	b02080e7          	jalr	-1278(ra) # 80003502 <end_op>
    return -1;
    80004a08:	557d                	li	a0,-1
    80004a0a:	64ee                	ld	s1,216(sp)
    80004a0c:	a055                	j	80004ab0 <sys_unlink+0x1c6>
    80004a0e:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80004a10:	00004517          	auipc	a0,0x4
    80004a14:	ba050513          	addi	a0,a0,-1120 # 800085b0 <etext+0x5b0>
    80004a18:	00001097          	auipc	ra,0x1
    80004a1c:	296080e7          	jalr	662(ra) # 80005cae <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004a20:	04c92703          	lw	a4,76(s2)
    80004a24:	02000793          	li	a5,32
    80004a28:	f6e7f5e3          	bgeu	a5,a4,80004992 <sys_unlink+0xa8>
    80004a2c:	e5ce                	sd	s3,200(sp)
    80004a2e:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a32:	4741                	li	a4,16
    80004a34:	86ce                	mv	a3,s3
    80004a36:	f1840613          	addi	a2,s0,-232
    80004a3a:	4581                	li	a1,0
    80004a3c:	854a                	mv	a0,s2
    80004a3e:	ffffe097          	auipc	ra,0xffffe
    80004a42:	330080e7          	jalr	816(ra) # 80002d6e <readi>
    80004a46:	47c1                	li	a5,16
    80004a48:	00f51c63          	bne	a0,a5,80004a60 <sys_unlink+0x176>
    if(de.inum != 0)
    80004a4c:	f1845783          	lhu	a5,-232(s0)
    80004a50:	e7b5                	bnez	a5,80004abc <sys_unlink+0x1d2>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004a52:	29c1                	addiw	s3,s3,16
    80004a54:	04c92783          	lw	a5,76(s2)
    80004a58:	fcf9ede3          	bltu	s3,a5,80004a32 <sys_unlink+0x148>
    80004a5c:	69ae                	ld	s3,200(sp)
    80004a5e:	bf15                	j	80004992 <sys_unlink+0xa8>
      panic("isdirempty: readi");
    80004a60:	00004517          	auipc	a0,0x4
    80004a64:	b6850513          	addi	a0,a0,-1176 # 800085c8 <etext+0x5c8>
    80004a68:	00001097          	auipc	ra,0x1
    80004a6c:	246080e7          	jalr	582(ra) # 80005cae <panic>
    80004a70:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80004a72:	00004517          	auipc	a0,0x4
    80004a76:	b6e50513          	addi	a0,a0,-1170 # 800085e0 <etext+0x5e0>
    80004a7a:	00001097          	auipc	ra,0x1
    80004a7e:	234080e7          	jalr	564(ra) # 80005cae <panic>
    dp->nlink--;
    80004a82:	04a4d783          	lhu	a5,74(s1)
    80004a86:	37fd                	addiw	a5,a5,-1
    80004a88:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004a8c:	8526                	mv	a0,s1
    80004a8e:	ffffe097          	auipc	ra,0xffffe
    80004a92:	f5c080e7          	jalr	-164(ra) # 800029ea <iupdate>
    80004a96:	bf0d                	j	800049c8 <sys_unlink+0xde>
    80004a98:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80004a9a:	8526                	mv	a0,s1
    80004a9c:	ffffe097          	auipc	ra,0xffffe
    80004aa0:	280080e7          	jalr	640(ra) # 80002d1c <iunlockput>
  end_op();
    80004aa4:	fffff097          	auipc	ra,0xfffff
    80004aa8:	a5e080e7          	jalr	-1442(ra) # 80003502 <end_op>
  return -1;
    80004aac:	557d                	li	a0,-1
    80004aae:	64ee                	ld	s1,216(sp)
}
    80004ab0:	70ae                	ld	ra,232(sp)
    80004ab2:	740e                	ld	s0,224(sp)
    80004ab4:	616d                	addi	sp,sp,240
    80004ab6:	8082                	ret
    return -1;
    80004ab8:	557d                	li	a0,-1
    80004aba:	bfdd                	j	80004ab0 <sys_unlink+0x1c6>
    iunlockput(ip);
    80004abc:	854a                	mv	a0,s2
    80004abe:	ffffe097          	auipc	ra,0xffffe
    80004ac2:	25e080e7          	jalr	606(ra) # 80002d1c <iunlockput>
    goto bad;
    80004ac6:	694e                	ld	s2,208(sp)
    80004ac8:	69ae                	ld	s3,200(sp)
    80004aca:	bfc1                	j	80004a9a <sys_unlink+0x1b0>

0000000080004acc <sys_open>:

uint64
sys_open(void)
{
    80004acc:	7131                	addi	sp,sp,-192
    80004ace:	fd06                	sd	ra,184(sp)
    80004ad0:	f922                	sd	s0,176(sp)
    80004ad2:	f526                	sd	s1,168(sp)
    80004ad4:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004ad6:	08000613          	li	a2,128
    80004ada:	f5040593          	addi	a1,s0,-176
    80004ade:	4501                	li	a0,0
    80004ae0:	ffffd097          	auipc	ra,0xffffd
    80004ae4:	4a0080e7          	jalr	1184(ra) # 80001f80 <argstr>
    return -1;
    80004ae8:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004aea:	0c054463          	bltz	a0,80004bb2 <sys_open+0xe6>
    80004aee:	f4c40593          	addi	a1,s0,-180
    80004af2:	4505                	li	a0,1
    80004af4:	ffffd097          	auipc	ra,0xffffd
    80004af8:	448080e7          	jalr	1096(ra) # 80001f3c <argint>
    80004afc:	0a054b63          	bltz	a0,80004bb2 <sys_open+0xe6>
    80004b00:	f14a                	sd	s2,160(sp)

  begin_op();
    80004b02:	fffff097          	auipc	ra,0xfffff
    80004b06:	986080e7          	jalr	-1658(ra) # 80003488 <begin_op>

  if(omode & O_CREATE){
    80004b0a:	f4c42783          	lw	a5,-180(s0)
    80004b0e:	2007f793          	andi	a5,a5,512
    80004b12:	cfc5                	beqz	a5,80004bca <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004b14:	4681                	li	a3,0
    80004b16:	4601                	li	a2,0
    80004b18:	4589                	li	a1,2
    80004b1a:	f5040513          	addi	a0,s0,-176
    80004b1e:	00000097          	auipc	ra,0x0
    80004b22:	958080e7          	jalr	-1704(ra) # 80004476 <create>
    80004b26:	892a                	mv	s2,a0
    if(ip == 0){
    80004b28:	c959                	beqz	a0,80004bbe <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004b2a:	04491703          	lh	a4,68(s2)
    80004b2e:	478d                	li	a5,3
    80004b30:	00f71763          	bne	a4,a5,80004b3e <sys_open+0x72>
    80004b34:	04695703          	lhu	a4,70(s2)
    80004b38:	47a5                	li	a5,9
    80004b3a:	0ce7ef63          	bltu	a5,a4,80004c18 <sys_open+0x14c>
    80004b3e:	ed4e                	sd	s3,152(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004b40:	fffff097          	auipc	ra,0xfffff
    80004b44:	d56080e7          	jalr	-682(ra) # 80003896 <filealloc>
    80004b48:	89aa                	mv	s3,a0
    80004b4a:	c965                	beqz	a0,80004c3a <sys_open+0x16e>
    80004b4c:	00000097          	auipc	ra,0x0
    80004b50:	8e8080e7          	jalr	-1816(ra) # 80004434 <fdalloc>
    80004b54:	84aa                	mv	s1,a0
    80004b56:	0c054d63          	bltz	a0,80004c30 <sys_open+0x164>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004b5a:	04491703          	lh	a4,68(s2)
    80004b5e:	478d                	li	a5,3
    80004b60:	0ef70a63          	beq	a4,a5,80004c54 <sys_open+0x188>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004b64:	4789                	li	a5,2
    80004b66:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004b6a:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004b6e:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004b72:	f4c42783          	lw	a5,-180(s0)
    80004b76:	0017c713          	xori	a4,a5,1
    80004b7a:	8b05                	andi	a4,a4,1
    80004b7c:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004b80:	0037f713          	andi	a4,a5,3
    80004b84:	00e03733          	snez	a4,a4
    80004b88:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004b8c:	4007f793          	andi	a5,a5,1024
    80004b90:	c791                	beqz	a5,80004b9c <sys_open+0xd0>
    80004b92:	04491703          	lh	a4,68(s2)
    80004b96:	4789                	li	a5,2
    80004b98:	0cf70563          	beq	a4,a5,80004c62 <sys_open+0x196>
    itrunc(ip);
  }

  iunlock(ip);
    80004b9c:	854a                	mv	a0,s2
    80004b9e:	ffffe097          	auipc	ra,0xffffe
    80004ba2:	fde080e7          	jalr	-34(ra) # 80002b7c <iunlock>
  end_op();
    80004ba6:	fffff097          	auipc	ra,0xfffff
    80004baa:	95c080e7          	jalr	-1700(ra) # 80003502 <end_op>
    80004bae:	790a                	ld	s2,160(sp)
    80004bb0:	69ea                	ld	s3,152(sp)

  return fd;
}
    80004bb2:	8526                	mv	a0,s1
    80004bb4:	70ea                	ld	ra,184(sp)
    80004bb6:	744a                	ld	s0,176(sp)
    80004bb8:	74aa                	ld	s1,168(sp)
    80004bba:	6129                	addi	sp,sp,192
    80004bbc:	8082                	ret
      end_op();
    80004bbe:	fffff097          	auipc	ra,0xfffff
    80004bc2:	944080e7          	jalr	-1724(ra) # 80003502 <end_op>
      return -1;
    80004bc6:	790a                	ld	s2,160(sp)
    80004bc8:	b7ed                	j	80004bb2 <sys_open+0xe6>
    if((ip = namei(path)) == 0){
    80004bca:	f5040513          	addi	a0,s0,-176
    80004bce:	ffffe097          	auipc	ra,0xffffe
    80004bd2:	6ba080e7          	jalr	1722(ra) # 80003288 <namei>
    80004bd6:	892a                	mv	s2,a0
    80004bd8:	c90d                	beqz	a0,80004c0a <sys_open+0x13e>
    ilock(ip);
    80004bda:	ffffe097          	auipc	ra,0xffffe
    80004bde:	edc080e7          	jalr	-292(ra) # 80002ab6 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004be2:	04491703          	lh	a4,68(s2)
    80004be6:	4785                	li	a5,1
    80004be8:	f4f711e3          	bne	a4,a5,80004b2a <sys_open+0x5e>
    80004bec:	f4c42783          	lw	a5,-180(s0)
    80004bf0:	d7b9                	beqz	a5,80004b3e <sys_open+0x72>
      iunlockput(ip);
    80004bf2:	854a                	mv	a0,s2
    80004bf4:	ffffe097          	auipc	ra,0xffffe
    80004bf8:	128080e7          	jalr	296(ra) # 80002d1c <iunlockput>
      end_op();
    80004bfc:	fffff097          	auipc	ra,0xfffff
    80004c00:	906080e7          	jalr	-1786(ra) # 80003502 <end_op>
      return -1;
    80004c04:	54fd                	li	s1,-1
    80004c06:	790a                	ld	s2,160(sp)
    80004c08:	b76d                	j	80004bb2 <sys_open+0xe6>
      end_op();
    80004c0a:	fffff097          	auipc	ra,0xfffff
    80004c0e:	8f8080e7          	jalr	-1800(ra) # 80003502 <end_op>
      return -1;
    80004c12:	54fd                	li	s1,-1
    80004c14:	790a                	ld	s2,160(sp)
    80004c16:	bf71                	j	80004bb2 <sys_open+0xe6>
    iunlockput(ip);
    80004c18:	854a                	mv	a0,s2
    80004c1a:	ffffe097          	auipc	ra,0xffffe
    80004c1e:	102080e7          	jalr	258(ra) # 80002d1c <iunlockput>
    end_op();
    80004c22:	fffff097          	auipc	ra,0xfffff
    80004c26:	8e0080e7          	jalr	-1824(ra) # 80003502 <end_op>
    return -1;
    80004c2a:	54fd                	li	s1,-1
    80004c2c:	790a                	ld	s2,160(sp)
    80004c2e:	b751                	j	80004bb2 <sys_open+0xe6>
      fileclose(f);
    80004c30:	854e                	mv	a0,s3
    80004c32:	fffff097          	auipc	ra,0xfffff
    80004c36:	d20080e7          	jalr	-736(ra) # 80003952 <fileclose>
    iunlockput(ip);
    80004c3a:	854a                	mv	a0,s2
    80004c3c:	ffffe097          	auipc	ra,0xffffe
    80004c40:	0e0080e7          	jalr	224(ra) # 80002d1c <iunlockput>
    end_op();
    80004c44:	fffff097          	auipc	ra,0xfffff
    80004c48:	8be080e7          	jalr	-1858(ra) # 80003502 <end_op>
    return -1;
    80004c4c:	54fd                	li	s1,-1
    80004c4e:	790a                	ld	s2,160(sp)
    80004c50:	69ea                	ld	s3,152(sp)
    80004c52:	b785                	j	80004bb2 <sys_open+0xe6>
    f->type = FD_DEVICE;
    80004c54:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004c58:	04691783          	lh	a5,70(s2)
    80004c5c:	02f99223          	sh	a5,36(s3)
    80004c60:	b739                	j	80004b6e <sys_open+0xa2>
    itrunc(ip);
    80004c62:	854a                	mv	a0,s2
    80004c64:	ffffe097          	auipc	ra,0xffffe
    80004c68:	f64080e7          	jalr	-156(ra) # 80002bc8 <itrunc>
    80004c6c:	bf05                	j	80004b9c <sys_open+0xd0>

0000000080004c6e <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004c6e:	7175                	addi	sp,sp,-144
    80004c70:	e506                	sd	ra,136(sp)
    80004c72:	e122                	sd	s0,128(sp)
    80004c74:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004c76:	fffff097          	auipc	ra,0xfffff
    80004c7a:	812080e7          	jalr	-2030(ra) # 80003488 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004c7e:	08000613          	li	a2,128
    80004c82:	f7040593          	addi	a1,s0,-144
    80004c86:	4501                	li	a0,0
    80004c88:	ffffd097          	auipc	ra,0xffffd
    80004c8c:	2f8080e7          	jalr	760(ra) # 80001f80 <argstr>
    80004c90:	02054963          	bltz	a0,80004cc2 <sys_mkdir+0x54>
    80004c94:	4681                	li	a3,0
    80004c96:	4601                	li	a2,0
    80004c98:	4585                	li	a1,1
    80004c9a:	f7040513          	addi	a0,s0,-144
    80004c9e:	fffff097          	auipc	ra,0xfffff
    80004ca2:	7d8080e7          	jalr	2008(ra) # 80004476 <create>
    80004ca6:	cd11                	beqz	a0,80004cc2 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004ca8:	ffffe097          	auipc	ra,0xffffe
    80004cac:	074080e7          	jalr	116(ra) # 80002d1c <iunlockput>
  end_op();
    80004cb0:	fffff097          	auipc	ra,0xfffff
    80004cb4:	852080e7          	jalr	-1966(ra) # 80003502 <end_op>
  return 0;
    80004cb8:	4501                	li	a0,0
}
    80004cba:	60aa                	ld	ra,136(sp)
    80004cbc:	640a                	ld	s0,128(sp)
    80004cbe:	6149                	addi	sp,sp,144
    80004cc0:	8082                	ret
    end_op();
    80004cc2:	fffff097          	auipc	ra,0xfffff
    80004cc6:	840080e7          	jalr	-1984(ra) # 80003502 <end_op>
    return -1;
    80004cca:	557d                	li	a0,-1
    80004ccc:	b7fd                	j	80004cba <sys_mkdir+0x4c>

0000000080004cce <sys_mknod>:

uint64
sys_mknod(void)
{
    80004cce:	7135                	addi	sp,sp,-160
    80004cd0:	ed06                	sd	ra,152(sp)
    80004cd2:	e922                	sd	s0,144(sp)
    80004cd4:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004cd6:	ffffe097          	auipc	ra,0xffffe
    80004cda:	7b2080e7          	jalr	1970(ra) # 80003488 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004cde:	08000613          	li	a2,128
    80004ce2:	f7040593          	addi	a1,s0,-144
    80004ce6:	4501                	li	a0,0
    80004ce8:	ffffd097          	auipc	ra,0xffffd
    80004cec:	298080e7          	jalr	664(ra) # 80001f80 <argstr>
    80004cf0:	04054a63          	bltz	a0,80004d44 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004cf4:	f6c40593          	addi	a1,s0,-148
    80004cf8:	4505                	li	a0,1
    80004cfa:	ffffd097          	auipc	ra,0xffffd
    80004cfe:	242080e7          	jalr	578(ra) # 80001f3c <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d02:	04054163          	bltz	a0,80004d44 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004d06:	f6840593          	addi	a1,s0,-152
    80004d0a:	4509                	li	a0,2
    80004d0c:	ffffd097          	auipc	ra,0xffffd
    80004d10:	230080e7          	jalr	560(ra) # 80001f3c <argint>
     argint(1, &major) < 0 ||
    80004d14:	02054863          	bltz	a0,80004d44 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004d18:	f6841683          	lh	a3,-152(s0)
    80004d1c:	f6c41603          	lh	a2,-148(s0)
    80004d20:	458d                	li	a1,3
    80004d22:	f7040513          	addi	a0,s0,-144
    80004d26:	fffff097          	auipc	ra,0xfffff
    80004d2a:	750080e7          	jalr	1872(ra) # 80004476 <create>
     argint(2, &minor) < 0 ||
    80004d2e:	c919                	beqz	a0,80004d44 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004d30:	ffffe097          	auipc	ra,0xffffe
    80004d34:	fec080e7          	jalr	-20(ra) # 80002d1c <iunlockput>
  end_op();
    80004d38:	ffffe097          	auipc	ra,0xffffe
    80004d3c:	7ca080e7          	jalr	1994(ra) # 80003502 <end_op>
  return 0;
    80004d40:	4501                	li	a0,0
    80004d42:	a031                	j	80004d4e <sys_mknod+0x80>
    end_op();
    80004d44:	ffffe097          	auipc	ra,0xffffe
    80004d48:	7be080e7          	jalr	1982(ra) # 80003502 <end_op>
    return -1;
    80004d4c:	557d                	li	a0,-1
}
    80004d4e:	60ea                	ld	ra,152(sp)
    80004d50:	644a                	ld	s0,144(sp)
    80004d52:	610d                	addi	sp,sp,160
    80004d54:	8082                	ret

0000000080004d56 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004d56:	7135                	addi	sp,sp,-160
    80004d58:	ed06                	sd	ra,152(sp)
    80004d5a:	e922                	sd	s0,144(sp)
    80004d5c:	e14a                	sd	s2,128(sp)
    80004d5e:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004d60:	ffffc097          	auipc	ra,0xffffc
    80004d64:	11c080e7          	jalr	284(ra) # 80000e7c <myproc>
    80004d68:	892a                	mv	s2,a0
  
  begin_op();
    80004d6a:	ffffe097          	auipc	ra,0xffffe
    80004d6e:	71e080e7          	jalr	1822(ra) # 80003488 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004d72:	08000613          	li	a2,128
    80004d76:	f6040593          	addi	a1,s0,-160
    80004d7a:	4501                	li	a0,0
    80004d7c:	ffffd097          	auipc	ra,0xffffd
    80004d80:	204080e7          	jalr	516(ra) # 80001f80 <argstr>
    80004d84:	04054d63          	bltz	a0,80004dde <sys_chdir+0x88>
    80004d88:	e526                	sd	s1,136(sp)
    80004d8a:	f6040513          	addi	a0,s0,-160
    80004d8e:	ffffe097          	auipc	ra,0xffffe
    80004d92:	4fa080e7          	jalr	1274(ra) # 80003288 <namei>
    80004d96:	84aa                	mv	s1,a0
    80004d98:	c131                	beqz	a0,80004ddc <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004d9a:	ffffe097          	auipc	ra,0xffffe
    80004d9e:	d1c080e7          	jalr	-740(ra) # 80002ab6 <ilock>
  if(ip->type != T_DIR){
    80004da2:	04449703          	lh	a4,68(s1)
    80004da6:	4785                	li	a5,1
    80004da8:	04f71163          	bne	a4,a5,80004dea <sys_chdir+0x94>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004dac:	8526                	mv	a0,s1
    80004dae:	ffffe097          	auipc	ra,0xffffe
    80004db2:	dce080e7          	jalr	-562(ra) # 80002b7c <iunlock>
  iput(p->cwd);
    80004db6:	15093503          	ld	a0,336(s2)
    80004dba:	ffffe097          	auipc	ra,0xffffe
    80004dbe:	eba080e7          	jalr	-326(ra) # 80002c74 <iput>
  end_op();
    80004dc2:	ffffe097          	auipc	ra,0xffffe
    80004dc6:	740080e7          	jalr	1856(ra) # 80003502 <end_op>
  p->cwd = ip;
    80004dca:	14993823          	sd	s1,336(s2)
  return 0;
    80004dce:	4501                	li	a0,0
    80004dd0:	64aa                	ld	s1,136(sp)
}
    80004dd2:	60ea                	ld	ra,152(sp)
    80004dd4:	644a                	ld	s0,144(sp)
    80004dd6:	690a                	ld	s2,128(sp)
    80004dd8:	610d                	addi	sp,sp,160
    80004dda:	8082                	ret
    80004ddc:	64aa                	ld	s1,136(sp)
    end_op();
    80004dde:	ffffe097          	auipc	ra,0xffffe
    80004de2:	724080e7          	jalr	1828(ra) # 80003502 <end_op>
    return -1;
    80004de6:	557d                	li	a0,-1
    80004de8:	b7ed                	j	80004dd2 <sys_chdir+0x7c>
    iunlockput(ip);
    80004dea:	8526                	mv	a0,s1
    80004dec:	ffffe097          	auipc	ra,0xffffe
    80004df0:	f30080e7          	jalr	-208(ra) # 80002d1c <iunlockput>
    end_op();
    80004df4:	ffffe097          	auipc	ra,0xffffe
    80004df8:	70e080e7          	jalr	1806(ra) # 80003502 <end_op>
    return -1;
    80004dfc:	557d                	li	a0,-1
    80004dfe:	64aa                	ld	s1,136(sp)
    80004e00:	bfc9                	j	80004dd2 <sys_chdir+0x7c>

0000000080004e02 <sys_exec>:

uint64
sys_exec(void)
{
    80004e02:	7121                	addi	sp,sp,-448
    80004e04:	ff06                	sd	ra,440(sp)
    80004e06:	fb22                	sd	s0,432(sp)
    80004e08:	f34a                	sd	s2,416(sp)
    80004e0a:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004e0c:	08000613          	li	a2,128
    80004e10:	f5040593          	addi	a1,s0,-176
    80004e14:	4501                	li	a0,0
    80004e16:	ffffd097          	auipc	ra,0xffffd
    80004e1a:	16a080e7          	jalr	362(ra) # 80001f80 <argstr>
    return -1;
    80004e1e:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004e20:	0e054a63          	bltz	a0,80004f14 <sys_exec+0x112>
    80004e24:	e4840593          	addi	a1,s0,-440
    80004e28:	4505                	li	a0,1
    80004e2a:	ffffd097          	auipc	ra,0xffffd
    80004e2e:	134080e7          	jalr	308(ra) # 80001f5e <argaddr>
    80004e32:	0e054163          	bltz	a0,80004f14 <sys_exec+0x112>
    80004e36:	f726                	sd	s1,424(sp)
    80004e38:	ef4e                	sd	s3,408(sp)
    80004e3a:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    80004e3c:	10000613          	li	a2,256
    80004e40:	4581                	li	a1,0
    80004e42:	e5040513          	addi	a0,s0,-432
    80004e46:	ffffb097          	auipc	ra,0xffffb
    80004e4a:	334080e7          	jalr	820(ra) # 8000017a <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004e4e:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80004e52:	89a6                	mv	s3,s1
    80004e54:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004e56:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004e5a:	00391513          	slli	a0,s2,0x3
    80004e5e:	e4040593          	addi	a1,s0,-448
    80004e62:	e4843783          	ld	a5,-440(s0)
    80004e66:	953e                	add	a0,a0,a5
    80004e68:	ffffd097          	auipc	ra,0xffffd
    80004e6c:	03a080e7          	jalr	58(ra) # 80001ea2 <fetchaddr>
    80004e70:	02054a63          	bltz	a0,80004ea4 <sys_exec+0xa2>
      goto bad;
    }
    if(uarg == 0){
    80004e74:	e4043783          	ld	a5,-448(s0)
    80004e78:	c7b1                	beqz	a5,80004ec4 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004e7a:	ffffb097          	auipc	ra,0xffffb
    80004e7e:	2a0080e7          	jalr	672(ra) # 8000011a <kalloc>
    80004e82:	85aa                	mv	a1,a0
    80004e84:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004e88:	cd11                	beqz	a0,80004ea4 <sys_exec+0xa2>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004e8a:	6605                	lui	a2,0x1
    80004e8c:	e4043503          	ld	a0,-448(s0)
    80004e90:	ffffd097          	auipc	ra,0xffffd
    80004e94:	064080e7          	jalr	100(ra) # 80001ef4 <fetchstr>
    80004e98:	00054663          	bltz	a0,80004ea4 <sys_exec+0xa2>
    if(i >= NELEM(argv)){
    80004e9c:	0905                	addi	s2,s2,1
    80004e9e:	09a1                	addi	s3,s3,8
    80004ea0:	fb491de3          	bne	s2,s4,80004e5a <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004ea4:	f5040913          	addi	s2,s0,-176
    80004ea8:	6088                	ld	a0,0(s1)
    80004eaa:	c12d                	beqz	a0,80004f0c <sys_exec+0x10a>
    kfree(argv[i]);
    80004eac:	ffffb097          	auipc	ra,0xffffb
    80004eb0:	170080e7          	jalr	368(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004eb4:	04a1                	addi	s1,s1,8
    80004eb6:	ff2499e3          	bne	s1,s2,80004ea8 <sys_exec+0xa6>
  return -1;
    80004eba:	597d                	li	s2,-1
    80004ebc:	74ba                	ld	s1,424(sp)
    80004ebe:	69fa                	ld	s3,408(sp)
    80004ec0:	6a5a                	ld	s4,400(sp)
    80004ec2:	a889                	j	80004f14 <sys_exec+0x112>
      argv[i] = 0;
    80004ec4:	0009079b          	sext.w	a5,s2
    80004ec8:	078e                	slli	a5,a5,0x3
    80004eca:	fd078793          	addi	a5,a5,-48
    80004ece:	97a2                	add	a5,a5,s0
    80004ed0:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80004ed4:	e5040593          	addi	a1,s0,-432
    80004ed8:	f5040513          	addi	a0,s0,-176
    80004edc:	fffff097          	auipc	ra,0xfffff
    80004ee0:	126080e7          	jalr	294(ra) # 80004002 <exec>
    80004ee4:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004ee6:	f5040993          	addi	s3,s0,-176
    80004eea:	6088                	ld	a0,0(s1)
    80004eec:	cd01                	beqz	a0,80004f04 <sys_exec+0x102>
    kfree(argv[i]);
    80004eee:	ffffb097          	auipc	ra,0xffffb
    80004ef2:	12e080e7          	jalr	302(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004ef6:	04a1                	addi	s1,s1,8
    80004ef8:	ff3499e3          	bne	s1,s3,80004eea <sys_exec+0xe8>
    80004efc:	74ba                	ld	s1,424(sp)
    80004efe:	69fa                	ld	s3,408(sp)
    80004f00:	6a5a                	ld	s4,400(sp)
    80004f02:	a809                	j	80004f14 <sys_exec+0x112>
  return ret;
    80004f04:	74ba                	ld	s1,424(sp)
    80004f06:	69fa                	ld	s3,408(sp)
    80004f08:	6a5a                	ld	s4,400(sp)
    80004f0a:	a029                	j	80004f14 <sys_exec+0x112>
  return -1;
    80004f0c:	597d                	li	s2,-1
    80004f0e:	74ba                	ld	s1,424(sp)
    80004f10:	69fa                	ld	s3,408(sp)
    80004f12:	6a5a                	ld	s4,400(sp)
}
    80004f14:	854a                	mv	a0,s2
    80004f16:	70fa                	ld	ra,440(sp)
    80004f18:	745a                	ld	s0,432(sp)
    80004f1a:	791a                	ld	s2,416(sp)
    80004f1c:	6139                	addi	sp,sp,448
    80004f1e:	8082                	ret

0000000080004f20 <sys_pipe>:

uint64
sys_pipe(void)
{
    80004f20:	7139                	addi	sp,sp,-64
    80004f22:	fc06                	sd	ra,56(sp)
    80004f24:	f822                	sd	s0,48(sp)
    80004f26:	f426                	sd	s1,40(sp)
    80004f28:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004f2a:	ffffc097          	auipc	ra,0xffffc
    80004f2e:	f52080e7          	jalr	-174(ra) # 80000e7c <myproc>
    80004f32:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80004f34:	fd840593          	addi	a1,s0,-40
    80004f38:	4501                	li	a0,0
    80004f3a:	ffffd097          	auipc	ra,0xffffd
    80004f3e:	024080e7          	jalr	36(ra) # 80001f5e <argaddr>
    return -1;
    80004f42:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80004f44:	0e054063          	bltz	a0,80005024 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80004f48:	fc840593          	addi	a1,s0,-56
    80004f4c:	fd040513          	addi	a0,s0,-48
    80004f50:	fffff097          	auipc	ra,0xfffff
    80004f54:	d70080e7          	jalr	-656(ra) # 80003cc0 <pipealloc>
    return -1;
    80004f58:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004f5a:	0c054563          	bltz	a0,80005024 <sys_pipe+0x104>
  fd0 = -1;
    80004f5e:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004f62:	fd043503          	ld	a0,-48(s0)
    80004f66:	fffff097          	auipc	ra,0xfffff
    80004f6a:	4ce080e7          	jalr	1230(ra) # 80004434 <fdalloc>
    80004f6e:	fca42223          	sw	a0,-60(s0)
    80004f72:	08054c63          	bltz	a0,8000500a <sys_pipe+0xea>
    80004f76:	fc843503          	ld	a0,-56(s0)
    80004f7a:	fffff097          	auipc	ra,0xfffff
    80004f7e:	4ba080e7          	jalr	1210(ra) # 80004434 <fdalloc>
    80004f82:	fca42023          	sw	a0,-64(s0)
    80004f86:	06054963          	bltz	a0,80004ff8 <sys_pipe+0xd8>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004f8a:	4691                	li	a3,4
    80004f8c:	fc440613          	addi	a2,s0,-60
    80004f90:	fd843583          	ld	a1,-40(s0)
    80004f94:	68a8                	ld	a0,80(s1)
    80004f96:	ffffc097          	auipc	ra,0xffffc
    80004f9a:	b82080e7          	jalr	-1150(ra) # 80000b18 <copyout>
    80004f9e:	02054063          	bltz	a0,80004fbe <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004fa2:	4691                	li	a3,4
    80004fa4:	fc040613          	addi	a2,s0,-64
    80004fa8:	fd843583          	ld	a1,-40(s0)
    80004fac:	0591                	addi	a1,a1,4
    80004fae:	68a8                	ld	a0,80(s1)
    80004fb0:	ffffc097          	auipc	ra,0xffffc
    80004fb4:	b68080e7          	jalr	-1176(ra) # 80000b18 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004fb8:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004fba:	06055563          	bgez	a0,80005024 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80004fbe:	fc442783          	lw	a5,-60(s0)
    80004fc2:	07e9                	addi	a5,a5,26
    80004fc4:	078e                	slli	a5,a5,0x3
    80004fc6:	97a6                	add	a5,a5,s1
    80004fc8:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80004fcc:	fc042783          	lw	a5,-64(s0)
    80004fd0:	07e9                	addi	a5,a5,26
    80004fd2:	078e                	slli	a5,a5,0x3
    80004fd4:	00f48533          	add	a0,s1,a5
    80004fd8:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80004fdc:	fd043503          	ld	a0,-48(s0)
    80004fe0:	fffff097          	auipc	ra,0xfffff
    80004fe4:	972080e7          	jalr	-1678(ra) # 80003952 <fileclose>
    fileclose(wf);
    80004fe8:	fc843503          	ld	a0,-56(s0)
    80004fec:	fffff097          	auipc	ra,0xfffff
    80004ff0:	966080e7          	jalr	-1690(ra) # 80003952 <fileclose>
    return -1;
    80004ff4:	57fd                	li	a5,-1
    80004ff6:	a03d                	j	80005024 <sys_pipe+0x104>
    if(fd0 >= 0)
    80004ff8:	fc442783          	lw	a5,-60(s0)
    80004ffc:	0007c763          	bltz	a5,8000500a <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005000:	07e9                	addi	a5,a5,26
    80005002:	078e                	slli	a5,a5,0x3
    80005004:	97a6                	add	a5,a5,s1
    80005006:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    8000500a:	fd043503          	ld	a0,-48(s0)
    8000500e:	fffff097          	auipc	ra,0xfffff
    80005012:	944080e7          	jalr	-1724(ra) # 80003952 <fileclose>
    fileclose(wf);
    80005016:	fc843503          	ld	a0,-56(s0)
    8000501a:	fffff097          	auipc	ra,0xfffff
    8000501e:	938080e7          	jalr	-1736(ra) # 80003952 <fileclose>
    return -1;
    80005022:	57fd                	li	a5,-1
}
    80005024:	853e                	mv	a0,a5
    80005026:	70e2                	ld	ra,56(sp)
    80005028:	7442                	ld	s0,48(sp)
    8000502a:	74a2                	ld	s1,40(sp)
    8000502c:	6121                	addi	sp,sp,64
    8000502e:	8082                	ret

0000000080005030 <kernelvec>:
    80005030:	7111                	addi	sp,sp,-256
    80005032:	e006                	sd	ra,0(sp)
    80005034:	e40a                	sd	sp,8(sp)
    80005036:	e80e                	sd	gp,16(sp)
    80005038:	ec12                	sd	tp,24(sp)
    8000503a:	f016                	sd	t0,32(sp)
    8000503c:	f41a                	sd	t1,40(sp)
    8000503e:	f81e                	sd	t2,48(sp)
    80005040:	fc22                	sd	s0,56(sp)
    80005042:	e0a6                	sd	s1,64(sp)
    80005044:	e4aa                	sd	a0,72(sp)
    80005046:	e8ae                	sd	a1,80(sp)
    80005048:	ecb2                	sd	a2,88(sp)
    8000504a:	f0b6                	sd	a3,96(sp)
    8000504c:	f4ba                	sd	a4,104(sp)
    8000504e:	f8be                	sd	a5,112(sp)
    80005050:	fcc2                	sd	a6,120(sp)
    80005052:	e146                	sd	a7,128(sp)
    80005054:	e54a                	sd	s2,136(sp)
    80005056:	e94e                	sd	s3,144(sp)
    80005058:	ed52                	sd	s4,152(sp)
    8000505a:	f156                	sd	s5,160(sp)
    8000505c:	f55a                	sd	s6,168(sp)
    8000505e:	f95e                	sd	s7,176(sp)
    80005060:	fd62                	sd	s8,184(sp)
    80005062:	e1e6                	sd	s9,192(sp)
    80005064:	e5ea                	sd	s10,200(sp)
    80005066:	e9ee                	sd	s11,208(sp)
    80005068:	edf2                	sd	t3,216(sp)
    8000506a:	f1f6                	sd	t4,224(sp)
    8000506c:	f5fa                	sd	t5,232(sp)
    8000506e:	f9fe                	sd	t6,240(sp)
    80005070:	cfffc0ef          	jal	80001d6e <kerneltrap>
    80005074:	6082                	ld	ra,0(sp)
    80005076:	6122                	ld	sp,8(sp)
    80005078:	61c2                	ld	gp,16(sp)
    8000507a:	7282                	ld	t0,32(sp)
    8000507c:	7322                	ld	t1,40(sp)
    8000507e:	73c2                	ld	t2,48(sp)
    80005080:	7462                	ld	s0,56(sp)
    80005082:	6486                	ld	s1,64(sp)
    80005084:	6526                	ld	a0,72(sp)
    80005086:	65c6                	ld	a1,80(sp)
    80005088:	6666                	ld	a2,88(sp)
    8000508a:	7686                	ld	a3,96(sp)
    8000508c:	7726                	ld	a4,104(sp)
    8000508e:	77c6                	ld	a5,112(sp)
    80005090:	7866                	ld	a6,120(sp)
    80005092:	688a                	ld	a7,128(sp)
    80005094:	692a                	ld	s2,136(sp)
    80005096:	69ca                	ld	s3,144(sp)
    80005098:	6a6a                	ld	s4,152(sp)
    8000509a:	7a8a                	ld	s5,160(sp)
    8000509c:	7b2a                	ld	s6,168(sp)
    8000509e:	7bca                	ld	s7,176(sp)
    800050a0:	7c6a                	ld	s8,184(sp)
    800050a2:	6c8e                	ld	s9,192(sp)
    800050a4:	6d2e                	ld	s10,200(sp)
    800050a6:	6dce                	ld	s11,208(sp)
    800050a8:	6e6e                	ld	t3,216(sp)
    800050aa:	7e8e                	ld	t4,224(sp)
    800050ac:	7f2e                	ld	t5,232(sp)
    800050ae:	7fce                	ld	t6,240(sp)
    800050b0:	6111                	addi	sp,sp,256
    800050b2:	10200073          	sret
    800050b6:	00000013          	nop
    800050ba:	00000013          	nop
    800050be:	0001                	nop

00000000800050c0 <timervec>:
    800050c0:	34051573          	csrrw	a0,mscratch,a0
    800050c4:	e10c                	sd	a1,0(a0)
    800050c6:	e510                	sd	a2,8(a0)
    800050c8:	e914                	sd	a3,16(a0)
    800050ca:	6d0c                	ld	a1,24(a0)
    800050cc:	7110                	ld	a2,32(a0)
    800050ce:	6194                	ld	a3,0(a1)
    800050d0:	96b2                	add	a3,a3,a2
    800050d2:	e194                	sd	a3,0(a1)
    800050d4:	4589                	li	a1,2
    800050d6:	14459073          	csrw	sip,a1
    800050da:	6914                	ld	a3,16(a0)
    800050dc:	6510                	ld	a2,8(a0)
    800050de:	610c                	ld	a1,0(a0)
    800050e0:	34051573          	csrrw	a0,mscratch,a0
    800050e4:	30200073          	mret
	...

00000000800050ea <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800050ea:	1141                	addi	sp,sp,-16
    800050ec:	e422                	sd	s0,8(sp)
    800050ee:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800050f0:	0c0007b7          	lui	a5,0xc000
    800050f4:	4705                	li	a4,1
    800050f6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800050f8:	0c0007b7          	lui	a5,0xc000
    800050fc:	c3d8                	sw	a4,4(a5)
}
    800050fe:	6422                	ld	s0,8(sp)
    80005100:	0141                	addi	sp,sp,16
    80005102:	8082                	ret

0000000080005104 <plicinithart>:

void
plicinithart(void)
{
    80005104:	1141                	addi	sp,sp,-16
    80005106:	e406                	sd	ra,8(sp)
    80005108:	e022                	sd	s0,0(sp)
    8000510a:	0800                	addi	s0,sp,16
  int hart = cpuid();
    8000510c:	ffffc097          	auipc	ra,0xffffc
    80005110:	d44080e7          	jalr	-700(ra) # 80000e50 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005114:	0085171b          	slliw	a4,a0,0x8
    80005118:	0c0027b7          	lui	a5,0xc002
    8000511c:	97ba                	add	a5,a5,a4
    8000511e:	40200713          	li	a4,1026
    80005122:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005126:	00d5151b          	slliw	a0,a0,0xd
    8000512a:	0c2017b7          	lui	a5,0xc201
    8000512e:	97aa                	add	a5,a5,a0
    80005130:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005134:	60a2                	ld	ra,8(sp)
    80005136:	6402                	ld	s0,0(sp)
    80005138:	0141                	addi	sp,sp,16
    8000513a:	8082                	ret

000000008000513c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000513c:	1141                	addi	sp,sp,-16
    8000513e:	e406                	sd	ra,8(sp)
    80005140:	e022                	sd	s0,0(sp)
    80005142:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005144:	ffffc097          	auipc	ra,0xffffc
    80005148:	d0c080e7          	jalr	-756(ra) # 80000e50 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    8000514c:	00d5151b          	slliw	a0,a0,0xd
    80005150:	0c2017b7          	lui	a5,0xc201
    80005154:	97aa                	add	a5,a5,a0
  return irq;
}
    80005156:	43c8                	lw	a0,4(a5)
    80005158:	60a2                	ld	ra,8(sp)
    8000515a:	6402                	ld	s0,0(sp)
    8000515c:	0141                	addi	sp,sp,16
    8000515e:	8082                	ret

0000000080005160 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80005160:	1101                	addi	sp,sp,-32
    80005162:	ec06                	sd	ra,24(sp)
    80005164:	e822                	sd	s0,16(sp)
    80005166:	e426                	sd	s1,8(sp)
    80005168:	1000                	addi	s0,sp,32
    8000516a:	84aa                	mv	s1,a0
  int hart = cpuid();
    8000516c:	ffffc097          	auipc	ra,0xffffc
    80005170:	ce4080e7          	jalr	-796(ra) # 80000e50 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005174:	00d5151b          	slliw	a0,a0,0xd
    80005178:	0c2017b7          	lui	a5,0xc201
    8000517c:	97aa                	add	a5,a5,a0
    8000517e:	c3c4                	sw	s1,4(a5)
}
    80005180:	60e2                	ld	ra,24(sp)
    80005182:	6442                	ld	s0,16(sp)
    80005184:	64a2                	ld	s1,8(sp)
    80005186:	6105                	addi	sp,sp,32
    80005188:	8082                	ret

000000008000518a <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    8000518a:	1141                	addi	sp,sp,-16
    8000518c:	e406                	sd	ra,8(sp)
    8000518e:	e022                	sd	s0,0(sp)
    80005190:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80005192:	479d                	li	a5,7
    80005194:	06a7c863          	blt	a5,a0,80005204 <free_desc+0x7a>
    panic("free_desc 1");
  if(disk.free[i])
    80005198:	00016717          	auipc	a4,0x16
    8000519c:	e6870713          	addi	a4,a4,-408 # 8001b000 <disk>
    800051a0:	972a                	add	a4,a4,a0
    800051a2:	6789                	lui	a5,0x2
    800051a4:	97ba                	add	a5,a5,a4
    800051a6:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    800051aa:	e7ad                	bnez	a5,80005214 <free_desc+0x8a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800051ac:	00451793          	slli	a5,a0,0x4
    800051b0:	00018717          	auipc	a4,0x18
    800051b4:	e5070713          	addi	a4,a4,-432 # 8001d000 <disk+0x2000>
    800051b8:	6314                	ld	a3,0(a4)
    800051ba:	96be                	add	a3,a3,a5
    800051bc:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800051c0:	6314                	ld	a3,0(a4)
    800051c2:	96be                	add	a3,a3,a5
    800051c4:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    800051c8:	6314                	ld	a3,0(a4)
    800051ca:	96be                	add	a3,a3,a5
    800051cc:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    800051d0:	6318                	ld	a4,0(a4)
    800051d2:	97ba                	add	a5,a5,a4
    800051d4:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    800051d8:	00016717          	auipc	a4,0x16
    800051dc:	e2870713          	addi	a4,a4,-472 # 8001b000 <disk>
    800051e0:	972a                	add	a4,a4,a0
    800051e2:	6789                	lui	a5,0x2
    800051e4:	97ba                	add	a5,a5,a4
    800051e6:	4705                	li	a4,1
    800051e8:	00e78c23          	sb	a4,24(a5) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    800051ec:	00018517          	auipc	a0,0x18
    800051f0:	e2c50513          	addi	a0,a0,-468 # 8001d018 <disk+0x2018>
    800051f4:	ffffc097          	auipc	ra,0xffffc
    800051f8:	4da080e7          	jalr	1242(ra) # 800016ce <wakeup>
}
    800051fc:	60a2                	ld	ra,8(sp)
    800051fe:	6402                	ld	s0,0(sp)
    80005200:	0141                	addi	sp,sp,16
    80005202:	8082                	ret
    panic("free_desc 1");
    80005204:	00003517          	auipc	a0,0x3
    80005208:	3ec50513          	addi	a0,a0,1004 # 800085f0 <etext+0x5f0>
    8000520c:	00001097          	auipc	ra,0x1
    80005210:	aa2080e7          	jalr	-1374(ra) # 80005cae <panic>
    panic("free_desc 2");
    80005214:	00003517          	auipc	a0,0x3
    80005218:	3ec50513          	addi	a0,a0,1004 # 80008600 <etext+0x600>
    8000521c:	00001097          	auipc	ra,0x1
    80005220:	a92080e7          	jalr	-1390(ra) # 80005cae <panic>

0000000080005224 <virtio_disk_init>:
{
    80005224:	1141                	addi	sp,sp,-16
    80005226:	e406                	sd	ra,8(sp)
    80005228:	e022                	sd	s0,0(sp)
    8000522a:	0800                	addi	s0,sp,16
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000522c:	00003597          	auipc	a1,0x3
    80005230:	3e458593          	addi	a1,a1,996 # 80008610 <etext+0x610>
    80005234:	00018517          	auipc	a0,0x18
    80005238:	ef450513          	addi	a0,a0,-268 # 8001d128 <disk+0x2128>
    8000523c:	00001097          	auipc	ra,0x1
    80005240:	f32080e7          	jalr	-206(ra) # 8000616e <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005244:	100017b7          	lui	a5,0x10001
    80005248:	4398                	lw	a4,0(a5)
    8000524a:	2701                	sext.w	a4,a4
    8000524c:	747277b7          	lui	a5,0x74727
    80005250:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005254:	0ef71f63          	bne	a4,a5,80005352 <virtio_disk_init+0x12e>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005258:	100017b7          	lui	a5,0x10001
    8000525c:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    8000525e:	439c                	lw	a5,0(a5)
    80005260:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005262:	4705                	li	a4,1
    80005264:	0ee79763          	bne	a5,a4,80005352 <virtio_disk_init+0x12e>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005268:	100017b7          	lui	a5,0x10001
    8000526c:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    8000526e:	439c                	lw	a5,0(a5)
    80005270:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005272:	4709                	li	a4,2
    80005274:	0ce79f63          	bne	a5,a4,80005352 <virtio_disk_init+0x12e>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005278:	100017b7          	lui	a5,0x10001
    8000527c:	47d8                	lw	a4,12(a5)
    8000527e:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005280:	554d47b7          	lui	a5,0x554d4
    80005284:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005288:	0cf71563          	bne	a4,a5,80005352 <virtio_disk_init+0x12e>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000528c:	100017b7          	lui	a5,0x10001
    80005290:	4705                	li	a4,1
    80005292:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005294:	470d                	li	a4,3
    80005296:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005298:	10001737          	lui	a4,0x10001
    8000529c:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    8000529e:	c7ffe737          	lui	a4,0xc7ffe
    800052a2:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd851f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800052a6:	8ef9                	and	a3,a3,a4
    800052a8:	10001737          	lui	a4,0x10001
    800052ac:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    800052ae:	472d                	li	a4,11
    800052b0:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800052b2:	473d                	li	a4,15
    800052b4:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    800052b6:	100017b7          	lui	a5,0x10001
    800052ba:	6705                	lui	a4,0x1
    800052bc:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800052be:	100017b7          	lui	a5,0x10001
    800052c2:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800052c6:	100017b7          	lui	a5,0x10001
    800052ca:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    800052ce:	439c                	lw	a5,0(a5)
    800052d0:	2781                	sext.w	a5,a5
  if(max == 0)
    800052d2:	cbc1                	beqz	a5,80005362 <virtio_disk_init+0x13e>
  if(max < NUM)
    800052d4:	471d                	li	a4,7
    800052d6:	08f77e63          	bgeu	a4,a5,80005372 <virtio_disk_init+0x14e>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800052da:	100017b7          	lui	a5,0x10001
    800052de:	4721                	li	a4,8
    800052e0:	df98                	sw	a4,56(a5)
  memset(disk.pages, 0, sizeof(disk.pages));
    800052e2:	6609                	lui	a2,0x2
    800052e4:	4581                	li	a1,0
    800052e6:	00016517          	auipc	a0,0x16
    800052ea:	d1a50513          	addi	a0,a0,-742 # 8001b000 <disk>
    800052ee:	ffffb097          	auipc	ra,0xffffb
    800052f2:	e8c080e7          	jalr	-372(ra) # 8000017a <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    800052f6:	00016697          	auipc	a3,0x16
    800052fa:	d0a68693          	addi	a3,a3,-758 # 8001b000 <disk>
    800052fe:	00c6d713          	srli	a4,a3,0xc
    80005302:	2701                	sext.w	a4,a4
    80005304:	100017b7          	lui	a5,0x10001
    80005308:	c3b8                	sw	a4,64(a5)
  disk.desc = (struct virtq_desc *) disk.pages;
    8000530a:	00018797          	auipc	a5,0x18
    8000530e:	cf678793          	addi	a5,a5,-778 # 8001d000 <disk+0x2000>
    80005312:	e394                	sd	a3,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005314:	00016717          	auipc	a4,0x16
    80005318:	d6c70713          	addi	a4,a4,-660 # 8001b080 <disk+0x80>
    8000531c:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    8000531e:	00017717          	auipc	a4,0x17
    80005322:	ce270713          	addi	a4,a4,-798 # 8001c000 <disk+0x1000>
    80005326:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    80005328:	4705                	li	a4,1
    8000532a:	00e78c23          	sb	a4,24(a5)
    8000532e:	00e78ca3          	sb	a4,25(a5)
    80005332:	00e78d23          	sb	a4,26(a5)
    80005336:	00e78da3          	sb	a4,27(a5)
    8000533a:	00e78e23          	sb	a4,28(a5)
    8000533e:	00e78ea3          	sb	a4,29(a5)
    80005342:	00e78f23          	sb	a4,30(a5)
    80005346:	00e78fa3          	sb	a4,31(a5)
}
    8000534a:	60a2                	ld	ra,8(sp)
    8000534c:	6402                	ld	s0,0(sp)
    8000534e:	0141                	addi	sp,sp,16
    80005350:	8082                	ret
    panic("could not find virtio disk");
    80005352:	00003517          	auipc	a0,0x3
    80005356:	2ce50513          	addi	a0,a0,718 # 80008620 <etext+0x620>
    8000535a:	00001097          	auipc	ra,0x1
    8000535e:	954080e7          	jalr	-1708(ra) # 80005cae <panic>
    panic("virtio disk has no queue 0");
    80005362:	00003517          	auipc	a0,0x3
    80005366:	2de50513          	addi	a0,a0,734 # 80008640 <etext+0x640>
    8000536a:	00001097          	auipc	ra,0x1
    8000536e:	944080e7          	jalr	-1724(ra) # 80005cae <panic>
    panic("virtio disk max queue too short");
    80005372:	00003517          	auipc	a0,0x3
    80005376:	2ee50513          	addi	a0,a0,750 # 80008660 <etext+0x660>
    8000537a:	00001097          	auipc	ra,0x1
    8000537e:	934080e7          	jalr	-1740(ra) # 80005cae <panic>

0000000080005382 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005382:	7159                	addi	sp,sp,-112
    80005384:	f486                	sd	ra,104(sp)
    80005386:	f0a2                	sd	s0,96(sp)
    80005388:	eca6                	sd	s1,88(sp)
    8000538a:	e8ca                	sd	s2,80(sp)
    8000538c:	e4ce                	sd	s3,72(sp)
    8000538e:	e0d2                	sd	s4,64(sp)
    80005390:	fc56                	sd	s5,56(sp)
    80005392:	f85a                	sd	s6,48(sp)
    80005394:	f45e                	sd	s7,40(sp)
    80005396:	f062                	sd	s8,32(sp)
    80005398:	ec66                	sd	s9,24(sp)
    8000539a:	1880                	addi	s0,sp,112
    8000539c:	8a2a                	mv	s4,a0
    8000539e:	8cae                	mv	s9,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800053a0:	00c52c03          	lw	s8,12(a0)
    800053a4:	001c1c1b          	slliw	s8,s8,0x1
    800053a8:	1c02                	slli	s8,s8,0x20
    800053aa:	020c5c13          	srli	s8,s8,0x20

  acquire(&disk.vdisk_lock);
    800053ae:	00018517          	auipc	a0,0x18
    800053b2:	d7a50513          	addi	a0,a0,-646 # 8001d128 <disk+0x2128>
    800053b6:	00001097          	auipc	ra,0x1
    800053ba:	e48080e7          	jalr	-440(ra) # 800061fe <acquire>
  for(int i = 0; i < 3; i++){
    800053be:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800053c0:	44a1                	li	s1,8
      disk.free[i] = 0;
    800053c2:	00016b97          	auipc	s7,0x16
    800053c6:	c3eb8b93          	addi	s7,s7,-962 # 8001b000 <disk>
    800053ca:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    800053cc:	4a8d                	li	s5,3
    800053ce:	a88d                	j	80005440 <virtio_disk_rw+0xbe>
      disk.free[i] = 0;
    800053d0:	00fb8733          	add	a4,s7,a5
    800053d4:	975a                	add	a4,a4,s6
    800053d6:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800053da:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800053dc:	0207c563          	bltz	a5,80005406 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    800053e0:	2905                	addiw	s2,s2,1
    800053e2:	0611                	addi	a2,a2,4 # 2004 <_entry-0x7fffdffc>
    800053e4:	1b590163          	beq	s2,s5,80005586 <virtio_disk_rw+0x204>
    idx[i] = alloc_desc();
    800053e8:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    800053ea:	00018717          	auipc	a4,0x18
    800053ee:	c2e70713          	addi	a4,a4,-978 # 8001d018 <disk+0x2018>
    800053f2:	87ce                	mv	a5,s3
    if(disk.free[i]){
    800053f4:	00074683          	lbu	a3,0(a4)
    800053f8:	fee1                	bnez	a3,800053d0 <virtio_disk_rw+0x4e>
  for(int i = 0; i < NUM; i++){
    800053fa:	2785                	addiw	a5,a5,1
    800053fc:	0705                	addi	a4,a4,1
    800053fe:	fe979be3          	bne	a5,s1,800053f4 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    80005402:	57fd                	li	a5,-1
    80005404:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80005406:	03205163          	blez	s2,80005428 <virtio_disk_rw+0xa6>
        free_desc(idx[j]);
    8000540a:	f9042503          	lw	a0,-112(s0)
    8000540e:	00000097          	auipc	ra,0x0
    80005412:	d7c080e7          	jalr	-644(ra) # 8000518a <free_desc>
      for(int j = 0; j < i; j++)
    80005416:	4785                	li	a5,1
    80005418:	0127d863          	bge	a5,s2,80005428 <virtio_disk_rw+0xa6>
        free_desc(idx[j]);
    8000541c:	f9442503          	lw	a0,-108(s0)
    80005420:	00000097          	auipc	ra,0x0
    80005424:	d6a080e7          	jalr	-662(ra) # 8000518a <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005428:	00018597          	auipc	a1,0x18
    8000542c:	d0058593          	addi	a1,a1,-768 # 8001d128 <disk+0x2128>
    80005430:	00018517          	auipc	a0,0x18
    80005434:	be850513          	addi	a0,a0,-1048 # 8001d018 <disk+0x2018>
    80005438:	ffffc097          	auipc	ra,0xffffc
    8000543c:	10a080e7          	jalr	266(ra) # 80001542 <sleep>
  for(int i = 0; i < 3; i++){
    80005440:	f9040613          	addi	a2,s0,-112
    80005444:	894e                	mv	s2,s3
    80005446:	b74d                	j	800053e8 <virtio_disk_rw+0x66>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80005448:	00018717          	auipc	a4,0x18
    8000544c:	bb873703          	ld	a4,-1096(a4) # 8001d000 <disk+0x2000>
    80005450:	973e                	add	a4,a4,a5
    80005452:	00071623          	sh	zero,12(a4)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005456:	00016897          	auipc	a7,0x16
    8000545a:	baa88893          	addi	a7,a7,-1110 # 8001b000 <disk>
    8000545e:	00018717          	auipc	a4,0x18
    80005462:	ba270713          	addi	a4,a4,-1118 # 8001d000 <disk+0x2000>
    80005466:	6314                	ld	a3,0(a4)
    80005468:	96be                	add	a3,a3,a5
    8000546a:	00c6d583          	lhu	a1,12(a3)
    8000546e:	0015e593          	ori	a1,a1,1
    80005472:	00b69623          	sh	a1,12(a3)
  disk.desc[idx[1]].next = idx[2];
    80005476:	f9842683          	lw	a3,-104(s0)
    8000547a:	630c                	ld	a1,0(a4)
    8000547c:	97ae                	add	a5,a5,a1
    8000547e:	00d79723          	sh	a3,14(a5)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005482:	20050593          	addi	a1,a0,512
    80005486:	0592                	slli	a1,a1,0x4
    80005488:	95c6                	add	a1,a1,a7
    8000548a:	57fd                	li	a5,-1
    8000548c:	02f58823          	sb	a5,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005490:	00469793          	slli	a5,a3,0x4
    80005494:	00073803          	ld	a6,0(a4)
    80005498:	983e                	add	a6,a6,a5
    8000549a:	6689                	lui	a3,0x2
    8000549c:	03068693          	addi	a3,a3,48 # 2030 <_entry-0x7fffdfd0>
    800054a0:	96b2                	add	a3,a3,a2
    800054a2:	96c6                	add	a3,a3,a7
    800054a4:	00d83023          	sd	a3,0(a6)
  disk.desc[idx[2]].len = 1;
    800054a8:	6314                	ld	a3,0(a4)
    800054aa:	96be                	add	a3,a3,a5
    800054ac:	4605                	li	a2,1
    800054ae:	c690                	sw	a2,8(a3)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800054b0:	6314                	ld	a3,0(a4)
    800054b2:	96be                	add	a3,a3,a5
    800054b4:	4809                	li	a6,2
    800054b6:	01069623          	sh	a6,12(a3)
  disk.desc[idx[2]].next = 0;
    800054ba:	6314                	ld	a3,0(a4)
    800054bc:	97b6                	add	a5,a5,a3
    800054be:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800054c2:	00ca2223          	sw	a2,4(s4)
  disk.info[idx[0]].b = b;
    800054c6:	0345b423          	sd	s4,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800054ca:	6714                	ld	a3,8(a4)
    800054cc:	0026d783          	lhu	a5,2(a3)
    800054d0:	8b9d                	andi	a5,a5,7
    800054d2:	0786                	slli	a5,a5,0x1
    800054d4:	96be                	add	a3,a3,a5
    800054d6:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    800054da:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800054de:	6718                	ld	a4,8(a4)
    800054e0:	00275783          	lhu	a5,2(a4)
    800054e4:	2785                	addiw	a5,a5,1
    800054e6:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800054ea:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800054ee:	100017b7          	lui	a5,0x10001
    800054f2:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800054f6:	004a2783          	lw	a5,4(s4)
    800054fa:	02c79163          	bne	a5,a2,8000551c <virtio_disk_rw+0x19a>
    sleep(b, &disk.vdisk_lock);
    800054fe:	00018917          	auipc	s2,0x18
    80005502:	c2a90913          	addi	s2,s2,-982 # 8001d128 <disk+0x2128>
  while(b->disk == 1) {
    80005506:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80005508:	85ca                	mv	a1,s2
    8000550a:	8552                	mv	a0,s4
    8000550c:	ffffc097          	auipc	ra,0xffffc
    80005510:	036080e7          	jalr	54(ra) # 80001542 <sleep>
  while(b->disk == 1) {
    80005514:	004a2783          	lw	a5,4(s4)
    80005518:	fe9788e3          	beq	a5,s1,80005508 <virtio_disk_rw+0x186>
  }

  disk.info[idx[0]].b = 0;
    8000551c:	f9042903          	lw	s2,-112(s0)
    80005520:	20090713          	addi	a4,s2,512
    80005524:	0712                	slli	a4,a4,0x4
    80005526:	00016797          	auipc	a5,0x16
    8000552a:	ada78793          	addi	a5,a5,-1318 # 8001b000 <disk>
    8000552e:	97ba                	add	a5,a5,a4
    80005530:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    80005534:	00018997          	auipc	s3,0x18
    80005538:	acc98993          	addi	s3,s3,-1332 # 8001d000 <disk+0x2000>
    8000553c:	00491713          	slli	a4,s2,0x4
    80005540:	0009b783          	ld	a5,0(s3)
    80005544:	97ba                	add	a5,a5,a4
    80005546:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    8000554a:	854a                	mv	a0,s2
    8000554c:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005550:	00000097          	auipc	ra,0x0
    80005554:	c3a080e7          	jalr	-966(ra) # 8000518a <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005558:	8885                	andi	s1,s1,1
    8000555a:	f0ed                	bnez	s1,8000553c <virtio_disk_rw+0x1ba>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000555c:	00018517          	auipc	a0,0x18
    80005560:	bcc50513          	addi	a0,a0,-1076 # 8001d128 <disk+0x2128>
    80005564:	00001097          	auipc	ra,0x1
    80005568:	d4e080e7          	jalr	-690(ra) # 800062b2 <release>
}
    8000556c:	70a6                	ld	ra,104(sp)
    8000556e:	7406                	ld	s0,96(sp)
    80005570:	64e6                	ld	s1,88(sp)
    80005572:	6946                	ld	s2,80(sp)
    80005574:	69a6                	ld	s3,72(sp)
    80005576:	6a06                	ld	s4,64(sp)
    80005578:	7ae2                	ld	s5,56(sp)
    8000557a:	7b42                	ld	s6,48(sp)
    8000557c:	7ba2                	ld	s7,40(sp)
    8000557e:	7c02                	ld	s8,32(sp)
    80005580:	6ce2                	ld	s9,24(sp)
    80005582:	6165                	addi	sp,sp,112
    80005584:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005586:	f9042503          	lw	a0,-112(s0)
    8000558a:	00451613          	slli	a2,a0,0x4
  if(write)
    8000558e:	00016597          	auipc	a1,0x16
    80005592:	a7258593          	addi	a1,a1,-1422 # 8001b000 <disk>
    80005596:	20050793          	addi	a5,a0,512
    8000559a:	0792                	slli	a5,a5,0x4
    8000559c:	97ae                	add	a5,a5,a1
    8000559e:	01903733          	snez	a4,s9
    800055a2:	0ae7a423          	sw	a4,168(a5)
  buf0->reserved = 0;
    800055a6:	0a07a623          	sw	zero,172(a5)
  buf0->sector = sector;
    800055aa:	0b87b823          	sd	s8,176(a5)
  disk.desc[idx[0]].addr = (uint64) buf0;
    800055ae:	00018717          	auipc	a4,0x18
    800055b2:	a5270713          	addi	a4,a4,-1454 # 8001d000 <disk+0x2000>
    800055b6:	6314                	ld	a3,0(a4)
    800055b8:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800055ba:	6789                	lui	a5,0x2
    800055bc:	0a878793          	addi	a5,a5,168 # 20a8 <_entry-0x7fffdf58>
    800055c0:	97b2                	add	a5,a5,a2
    800055c2:	97ae                	add	a5,a5,a1
  disk.desc[idx[0]].addr = (uint64) buf0;
    800055c4:	e29c                	sd	a5,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800055c6:	631c                	ld	a5,0(a4)
    800055c8:	97b2                	add	a5,a5,a2
    800055ca:	46c1                	li	a3,16
    800055cc:	c794                	sw	a3,8(a5)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800055ce:	631c                	ld	a5,0(a4)
    800055d0:	97b2                	add	a5,a5,a2
    800055d2:	4685                	li	a3,1
    800055d4:	00d79623          	sh	a3,12(a5)
  disk.desc[idx[0]].next = idx[1];
    800055d8:	f9442783          	lw	a5,-108(s0)
    800055dc:	6314                	ld	a3,0(a4)
    800055de:	96b2                	add	a3,a3,a2
    800055e0:	00f69723          	sh	a5,14(a3)
  disk.desc[idx[1]].addr = (uint64) b->data;
    800055e4:	0792                	slli	a5,a5,0x4
    800055e6:	6314                	ld	a3,0(a4)
    800055e8:	96be                	add	a3,a3,a5
    800055ea:	058a0593          	addi	a1,s4,88
    800055ee:	e28c                	sd	a1,0(a3)
  disk.desc[idx[1]].len = BSIZE;
    800055f0:	6318                	ld	a4,0(a4)
    800055f2:	973e                	add	a4,a4,a5
    800055f4:	40000693          	li	a3,1024
    800055f8:	c714                	sw	a3,8(a4)
  if(write)
    800055fa:	e40c97e3          	bnez	s9,80005448 <virtio_disk_rw+0xc6>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    800055fe:	00018717          	auipc	a4,0x18
    80005602:	a0273703          	ld	a4,-1534(a4) # 8001d000 <disk+0x2000>
    80005606:	973e                	add	a4,a4,a5
    80005608:	4689                	li	a3,2
    8000560a:	00d71623          	sh	a3,12(a4)
    8000560e:	b5a1                	j	80005456 <virtio_disk_rw+0xd4>

0000000080005610 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005610:	1101                	addi	sp,sp,-32
    80005612:	ec06                	sd	ra,24(sp)
    80005614:	e822                	sd	s0,16(sp)
    80005616:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005618:	00018517          	auipc	a0,0x18
    8000561c:	b1050513          	addi	a0,a0,-1264 # 8001d128 <disk+0x2128>
    80005620:	00001097          	auipc	ra,0x1
    80005624:	bde080e7          	jalr	-1058(ra) # 800061fe <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005628:	100017b7          	lui	a5,0x10001
    8000562c:	53b8                	lw	a4,96(a5)
    8000562e:	8b0d                	andi	a4,a4,3
    80005630:	100017b7          	lui	a5,0x10001
    80005634:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    80005636:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    8000563a:	00018797          	auipc	a5,0x18
    8000563e:	9c678793          	addi	a5,a5,-1594 # 8001d000 <disk+0x2000>
    80005642:	6b94                	ld	a3,16(a5)
    80005644:	0207d703          	lhu	a4,32(a5)
    80005648:	0026d783          	lhu	a5,2(a3)
    8000564c:	06f70563          	beq	a4,a5,800056b6 <virtio_disk_intr+0xa6>
    80005650:	e426                	sd	s1,8(sp)
    80005652:	e04a                	sd	s2,0(sp)
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005654:	00016917          	auipc	s2,0x16
    80005658:	9ac90913          	addi	s2,s2,-1620 # 8001b000 <disk>
    8000565c:	00018497          	auipc	s1,0x18
    80005660:	9a448493          	addi	s1,s1,-1628 # 8001d000 <disk+0x2000>
    __sync_synchronize();
    80005664:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005668:	6898                	ld	a4,16(s1)
    8000566a:	0204d783          	lhu	a5,32(s1)
    8000566e:	8b9d                	andi	a5,a5,7
    80005670:	078e                	slli	a5,a5,0x3
    80005672:	97ba                	add	a5,a5,a4
    80005674:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005676:	20078713          	addi	a4,a5,512
    8000567a:	0712                	slli	a4,a4,0x4
    8000567c:	974a                	add	a4,a4,s2
    8000567e:	03074703          	lbu	a4,48(a4)
    80005682:	e731                	bnez	a4,800056ce <virtio_disk_intr+0xbe>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005684:	20078793          	addi	a5,a5,512
    80005688:	0792                	slli	a5,a5,0x4
    8000568a:	97ca                	add	a5,a5,s2
    8000568c:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    8000568e:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005692:	ffffc097          	auipc	ra,0xffffc
    80005696:	03c080e7          	jalr	60(ra) # 800016ce <wakeup>

    disk.used_idx += 1;
    8000569a:	0204d783          	lhu	a5,32(s1)
    8000569e:	2785                	addiw	a5,a5,1
    800056a0:	17c2                	slli	a5,a5,0x30
    800056a2:	93c1                	srli	a5,a5,0x30
    800056a4:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800056a8:	6898                	ld	a4,16(s1)
    800056aa:	00275703          	lhu	a4,2(a4)
    800056ae:	faf71be3          	bne	a4,a5,80005664 <virtio_disk_intr+0x54>
    800056b2:	64a2                	ld	s1,8(sp)
    800056b4:	6902                	ld	s2,0(sp)
  }

  release(&disk.vdisk_lock);
    800056b6:	00018517          	auipc	a0,0x18
    800056ba:	a7250513          	addi	a0,a0,-1422 # 8001d128 <disk+0x2128>
    800056be:	00001097          	auipc	ra,0x1
    800056c2:	bf4080e7          	jalr	-1036(ra) # 800062b2 <release>
}
    800056c6:	60e2                	ld	ra,24(sp)
    800056c8:	6442                	ld	s0,16(sp)
    800056ca:	6105                	addi	sp,sp,32
    800056cc:	8082                	ret
      panic("virtio_disk_intr status");
    800056ce:	00003517          	auipc	a0,0x3
    800056d2:	fb250513          	addi	a0,a0,-78 # 80008680 <etext+0x680>
    800056d6:	00000097          	auipc	ra,0x0
    800056da:	5d8080e7          	jalr	1496(ra) # 80005cae <panic>

00000000800056de <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    800056de:	1141                	addi	sp,sp,-16
    800056e0:	e422                	sd	s0,8(sp)
    800056e2:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800056e4:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    800056e8:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    800056ec:	0037979b          	slliw	a5,a5,0x3
    800056f0:	02004737          	lui	a4,0x2004
    800056f4:	97ba                	add	a5,a5,a4
    800056f6:	0200c737          	lui	a4,0x200c
    800056fa:	1761                	addi	a4,a4,-8 # 200bff8 <_entry-0x7dff4008>
    800056fc:	6318                	ld	a4,0(a4)
    800056fe:	000f4637          	lui	a2,0xf4
    80005702:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005706:	9732                	add	a4,a4,a2
    80005708:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    8000570a:	00259693          	slli	a3,a1,0x2
    8000570e:	96ae                	add	a3,a3,a1
    80005710:	068e                	slli	a3,a3,0x3
    80005712:	00019717          	auipc	a4,0x19
    80005716:	8ee70713          	addi	a4,a4,-1810 # 8001e000 <timer_scratch>
    8000571a:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    8000571c:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    8000571e:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005720:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005724:	00000797          	auipc	a5,0x0
    80005728:	99c78793          	addi	a5,a5,-1636 # 800050c0 <timervec>
    8000572c:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005730:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005734:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005738:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    8000573c:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005740:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005744:	30479073          	csrw	mie,a5
}
    80005748:	6422                	ld	s0,8(sp)
    8000574a:	0141                	addi	sp,sp,16
    8000574c:	8082                	ret

000000008000574e <start>:
{
    8000574e:	1141                	addi	sp,sp,-16
    80005750:	e406                	sd	ra,8(sp)
    80005752:	e022                	sd	s0,0(sp)
    80005754:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005756:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    8000575a:	7779                	lui	a4,0xffffe
    8000575c:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd85bf>
    80005760:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005762:	6705                	lui	a4,0x1
    80005764:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005768:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    8000576a:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    8000576e:	ffffb797          	auipc	a5,0xffffb
    80005772:	baa78793          	addi	a5,a5,-1110 # 80000318 <main>
    80005776:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    8000577a:	4781                	li	a5,0
    8000577c:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005780:	67c1                	lui	a5,0x10
    80005782:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80005784:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005788:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    8000578c:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005790:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005794:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005798:	57fd                	li	a5,-1
    8000579a:	83a9                	srli	a5,a5,0xa
    8000579c:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800057a0:	47bd                	li	a5,15
    800057a2:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800057a6:	00000097          	auipc	ra,0x0
    800057aa:	f38080e7          	jalr	-200(ra) # 800056de <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800057ae:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800057b2:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    800057b4:	823e                	mv	tp,a5
  asm volatile("mret");
    800057b6:	30200073          	mret
}
    800057ba:	60a2                	ld	ra,8(sp)
    800057bc:	6402                	ld	s0,0(sp)
    800057be:	0141                	addi	sp,sp,16
    800057c0:	8082                	ret

00000000800057c2 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800057c2:	715d                	addi	sp,sp,-80
    800057c4:	e486                	sd	ra,72(sp)
    800057c6:	e0a2                	sd	s0,64(sp)
    800057c8:	f84a                	sd	s2,48(sp)
    800057ca:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    800057cc:	04c05663          	blez	a2,80005818 <consolewrite+0x56>
    800057d0:	fc26                	sd	s1,56(sp)
    800057d2:	f44e                	sd	s3,40(sp)
    800057d4:	f052                	sd	s4,32(sp)
    800057d6:	ec56                	sd	s5,24(sp)
    800057d8:	8a2a                	mv	s4,a0
    800057da:	84ae                	mv	s1,a1
    800057dc:	89b2                	mv	s3,a2
    800057de:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    800057e0:	5afd                	li	s5,-1
    800057e2:	4685                	li	a3,1
    800057e4:	8626                	mv	a2,s1
    800057e6:	85d2                	mv	a1,s4
    800057e8:	fbf40513          	addi	a0,s0,-65
    800057ec:	ffffc097          	auipc	ra,0xffffc
    800057f0:	150080e7          	jalr	336(ra) # 8000193c <either_copyin>
    800057f4:	03550463          	beq	a0,s5,8000581c <consolewrite+0x5a>
      break;
    uartputc(c);
    800057f8:	fbf44503          	lbu	a0,-65(s0)
    800057fc:	00001097          	auipc	ra,0x1
    80005800:	846080e7          	jalr	-1978(ra) # 80006042 <uartputc>
  for(i = 0; i < n; i++){
    80005804:	2905                	addiw	s2,s2,1
    80005806:	0485                	addi	s1,s1,1
    80005808:	fd299de3          	bne	s3,s2,800057e2 <consolewrite+0x20>
    8000580c:	894e                	mv	s2,s3
    8000580e:	74e2                	ld	s1,56(sp)
    80005810:	79a2                	ld	s3,40(sp)
    80005812:	7a02                	ld	s4,32(sp)
    80005814:	6ae2                	ld	s5,24(sp)
    80005816:	a039                	j	80005824 <consolewrite+0x62>
    80005818:	4901                	li	s2,0
    8000581a:	a029                	j	80005824 <consolewrite+0x62>
    8000581c:	74e2                	ld	s1,56(sp)
    8000581e:	79a2                	ld	s3,40(sp)
    80005820:	7a02                	ld	s4,32(sp)
    80005822:	6ae2                	ld	s5,24(sp)
  }

  return i;
}
    80005824:	854a                	mv	a0,s2
    80005826:	60a6                	ld	ra,72(sp)
    80005828:	6406                	ld	s0,64(sp)
    8000582a:	7942                	ld	s2,48(sp)
    8000582c:	6161                	addi	sp,sp,80
    8000582e:	8082                	ret

0000000080005830 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005830:	711d                	addi	sp,sp,-96
    80005832:	ec86                	sd	ra,88(sp)
    80005834:	e8a2                	sd	s0,80(sp)
    80005836:	e4a6                	sd	s1,72(sp)
    80005838:	e0ca                	sd	s2,64(sp)
    8000583a:	fc4e                	sd	s3,56(sp)
    8000583c:	f852                	sd	s4,48(sp)
    8000583e:	f456                	sd	s5,40(sp)
    80005840:	f05a                	sd	s6,32(sp)
    80005842:	1080                	addi	s0,sp,96
    80005844:	8aaa                	mv	s5,a0
    80005846:	8a2e                	mv	s4,a1
    80005848:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    8000584a:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    8000584e:	00021517          	auipc	a0,0x21
    80005852:	8f250513          	addi	a0,a0,-1806 # 80026140 <cons>
    80005856:	00001097          	auipc	ra,0x1
    8000585a:	9a8080e7          	jalr	-1624(ra) # 800061fe <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000585e:	00021497          	auipc	s1,0x21
    80005862:	8e248493          	addi	s1,s1,-1822 # 80026140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005866:	00021917          	auipc	s2,0x21
    8000586a:	97290913          	addi	s2,s2,-1678 # 800261d8 <cons+0x98>
  while(n > 0){
    8000586e:	0d305463          	blez	s3,80005936 <consoleread+0x106>
    while(cons.r == cons.w){
    80005872:	0984a783          	lw	a5,152(s1)
    80005876:	09c4a703          	lw	a4,156(s1)
    8000587a:	0af71963          	bne	a4,a5,8000592c <consoleread+0xfc>
      if(myproc()->killed){
    8000587e:	ffffb097          	auipc	ra,0xffffb
    80005882:	5fe080e7          	jalr	1534(ra) # 80000e7c <myproc>
    80005886:	551c                	lw	a5,40(a0)
    80005888:	e7ad                	bnez	a5,800058f2 <consoleread+0xc2>
      sleep(&cons.r, &cons.lock);
    8000588a:	85a6                	mv	a1,s1
    8000588c:	854a                	mv	a0,s2
    8000588e:	ffffc097          	auipc	ra,0xffffc
    80005892:	cb4080e7          	jalr	-844(ra) # 80001542 <sleep>
    while(cons.r == cons.w){
    80005896:	0984a783          	lw	a5,152(s1)
    8000589a:	09c4a703          	lw	a4,156(s1)
    8000589e:	fef700e3          	beq	a4,a5,8000587e <consoleread+0x4e>
    800058a2:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF];
    800058a4:	00021717          	auipc	a4,0x21
    800058a8:	89c70713          	addi	a4,a4,-1892 # 80026140 <cons>
    800058ac:	0017869b          	addiw	a3,a5,1
    800058b0:	08d72c23          	sw	a3,152(a4)
    800058b4:	07f7f693          	andi	a3,a5,127
    800058b8:	9736                	add	a4,a4,a3
    800058ba:	01874703          	lbu	a4,24(a4)
    800058be:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    800058c2:	4691                	li	a3,4
    800058c4:	04db8a63          	beq	s7,a3,80005918 <consoleread+0xe8>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    800058c8:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800058cc:	4685                	li	a3,1
    800058ce:	faf40613          	addi	a2,s0,-81
    800058d2:	85d2                	mv	a1,s4
    800058d4:	8556                	mv	a0,s5
    800058d6:	ffffc097          	auipc	ra,0xffffc
    800058da:	010080e7          	jalr	16(ra) # 800018e6 <either_copyout>
    800058de:	57fd                	li	a5,-1
    800058e0:	04f50a63          	beq	a0,a5,80005934 <consoleread+0x104>
      break;

    dst++;
    800058e4:	0a05                	addi	s4,s4,1
    --n;
    800058e6:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    800058e8:	47a9                	li	a5,10
    800058ea:	06fb8163          	beq	s7,a5,8000594c <consoleread+0x11c>
    800058ee:	6be2                	ld	s7,24(sp)
    800058f0:	bfbd                	j	8000586e <consoleread+0x3e>
        release(&cons.lock);
    800058f2:	00021517          	auipc	a0,0x21
    800058f6:	84e50513          	addi	a0,a0,-1970 # 80026140 <cons>
    800058fa:	00001097          	auipc	ra,0x1
    800058fe:	9b8080e7          	jalr	-1608(ra) # 800062b2 <release>
        return -1;
    80005902:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80005904:	60e6                	ld	ra,88(sp)
    80005906:	6446                	ld	s0,80(sp)
    80005908:	64a6                	ld	s1,72(sp)
    8000590a:	6906                	ld	s2,64(sp)
    8000590c:	79e2                	ld	s3,56(sp)
    8000590e:	7a42                	ld	s4,48(sp)
    80005910:	7aa2                	ld	s5,40(sp)
    80005912:	7b02                	ld	s6,32(sp)
    80005914:	6125                	addi	sp,sp,96
    80005916:	8082                	ret
      if(n < target){
    80005918:	0009871b          	sext.w	a4,s3
    8000591c:	01677a63          	bgeu	a4,s6,80005930 <consoleread+0x100>
        cons.r--;
    80005920:	00021717          	auipc	a4,0x21
    80005924:	8af72c23          	sw	a5,-1864(a4) # 800261d8 <cons+0x98>
    80005928:	6be2                	ld	s7,24(sp)
    8000592a:	a031                	j	80005936 <consoleread+0x106>
    8000592c:	ec5e                	sd	s7,24(sp)
    8000592e:	bf9d                	j	800058a4 <consoleread+0x74>
    80005930:	6be2                	ld	s7,24(sp)
    80005932:	a011                	j	80005936 <consoleread+0x106>
    80005934:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80005936:	00021517          	auipc	a0,0x21
    8000593a:	80a50513          	addi	a0,a0,-2038 # 80026140 <cons>
    8000593e:	00001097          	auipc	ra,0x1
    80005942:	974080e7          	jalr	-1676(ra) # 800062b2 <release>
  return target - n;
    80005946:	413b053b          	subw	a0,s6,s3
    8000594a:	bf6d                	j	80005904 <consoleread+0xd4>
    8000594c:	6be2                	ld	s7,24(sp)
    8000594e:	b7e5                	j	80005936 <consoleread+0x106>

0000000080005950 <consputc>:
{
    80005950:	1141                	addi	sp,sp,-16
    80005952:	e406                	sd	ra,8(sp)
    80005954:	e022                	sd	s0,0(sp)
    80005956:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005958:	10000793          	li	a5,256
    8000595c:	00f50a63          	beq	a0,a5,80005970 <consputc+0x20>
    uartputc_sync(c);
    80005960:	00000097          	auipc	ra,0x0
    80005964:	604080e7          	jalr	1540(ra) # 80005f64 <uartputc_sync>
}
    80005968:	60a2                	ld	ra,8(sp)
    8000596a:	6402                	ld	s0,0(sp)
    8000596c:	0141                	addi	sp,sp,16
    8000596e:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005970:	4521                	li	a0,8
    80005972:	00000097          	auipc	ra,0x0
    80005976:	5f2080e7          	jalr	1522(ra) # 80005f64 <uartputc_sync>
    8000597a:	02000513          	li	a0,32
    8000597e:	00000097          	auipc	ra,0x0
    80005982:	5e6080e7          	jalr	1510(ra) # 80005f64 <uartputc_sync>
    80005986:	4521                	li	a0,8
    80005988:	00000097          	auipc	ra,0x0
    8000598c:	5dc080e7          	jalr	1500(ra) # 80005f64 <uartputc_sync>
    80005990:	bfe1                	j	80005968 <consputc+0x18>

0000000080005992 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005992:	1101                	addi	sp,sp,-32
    80005994:	ec06                	sd	ra,24(sp)
    80005996:	e822                	sd	s0,16(sp)
    80005998:	e426                	sd	s1,8(sp)
    8000599a:	1000                	addi	s0,sp,32
    8000599c:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    8000599e:	00020517          	auipc	a0,0x20
    800059a2:	7a250513          	addi	a0,a0,1954 # 80026140 <cons>
    800059a6:	00001097          	auipc	ra,0x1
    800059aa:	858080e7          	jalr	-1960(ra) # 800061fe <acquire>

  switch(c){
    800059ae:	47d5                	li	a5,21
    800059b0:	0af48563          	beq	s1,a5,80005a5a <consoleintr+0xc8>
    800059b4:	0297c963          	blt	a5,s1,800059e6 <consoleintr+0x54>
    800059b8:	47a1                	li	a5,8
    800059ba:	0ef48c63          	beq	s1,a5,80005ab2 <consoleintr+0x120>
    800059be:	47c1                	li	a5,16
    800059c0:	10f49f63          	bne	s1,a5,80005ade <consoleintr+0x14c>
  case C('P'):  // Print process list.
    procdump();
    800059c4:	ffffc097          	auipc	ra,0xffffc
    800059c8:	fce080e7          	jalr	-50(ra) # 80001992 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800059cc:	00020517          	auipc	a0,0x20
    800059d0:	77450513          	addi	a0,a0,1908 # 80026140 <cons>
    800059d4:	00001097          	auipc	ra,0x1
    800059d8:	8de080e7          	jalr	-1826(ra) # 800062b2 <release>
}
    800059dc:	60e2                	ld	ra,24(sp)
    800059de:	6442                	ld	s0,16(sp)
    800059e0:	64a2                	ld	s1,8(sp)
    800059e2:	6105                	addi	sp,sp,32
    800059e4:	8082                	ret
  switch(c){
    800059e6:	07f00793          	li	a5,127
    800059ea:	0cf48463          	beq	s1,a5,80005ab2 <consoleintr+0x120>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    800059ee:	00020717          	auipc	a4,0x20
    800059f2:	75270713          	addi	a4,a4,1874 # 80026140 <cons>
    800059f6:	0a072783          	lw	a5,160(a4)
    800059fa:	09872703          	lw	a4,152(a4)
    800059fe:	9f99                	subw	a5,a5,a4
    80005a00:	07f00713          	li	a4,127
    80005a04:	fcf764e3          	bltu	a4,a5,800059cc <consoleintr+0x3a>
      c = (c == '\r') ? '\n' : c;
    80005a08:	47b5                	li	a5,13
    80005a0a:	0cf48d63          	beq	s1,a5,80005ae4 <consoleintr+0x152>
      consputc(c);
    80005a0e:	8526                	mv	a0,s1
    80005a10:	00000097          	auipc	ra,0x0
    80005a14:	f40080e7          	jalr	-192(ra) # 80005950 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005a18:	00020797          	auipc	a5,0x20
    80005a1c:	72878793          	addi	a5,a5,1832 # 80026140 <cons>
    80005a20:	0a07a703          	lw	a4,160(a5)
    80005a24:	0017069b          	addiw	a3,a4,1
    80005a28:	0006861b          	sext.w	a2,a3
    80005a2c:	0ad7a023          	sw	a3,160(a5)
    80005a30:	07f77713          	andi	a4,a4,127
    80005a34:	97ba                	add	a5,a5,a4
    80005a36:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005a3a:	47a9                	li	a5,10
    80005a3c:	0cf48b63          	beq	s1,a5,80005b12 <consoleintr+0x180>
    80005a40:	4791                	li	a5,4
    80005a42:	0cf48863          	beq	s1,a5,80005b12 <consoleintr+0x180>
    80005a46:	00020797          	auipc	a5,0x20
    80005a4a:	7927a783          	lw	a5,1938(a5) # 800261d8 <cons+0x98>
    80005a4e:	0807879b          	addiw	a5,a5,128
    80005a52:	f6f61de3          	bne	a2,a5,800059cc <consoleintr+0x3a>
    80005a56:	863e                	mv	a2,a5
    80005a58:	a86d                	j	80005b12 <consoleintr+0x180>
    80005a5a:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    80005a5c:	00020717          	auipc	a4,0x20
    80005a60:	6e470713          	addi	a4,a4,1764 # 80026140 <cons>
    80005a64:	0a072783          	lw	a5,160(a4)
    80005a68:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005a6c:	00020497          	auipc	s1,0x20
    80005a70:	6d448493          	addi	s1,s1,1748 # 80026140 <cons>
    while(cons.e != cons.w &&
    80005a74:	4929                	li	s2,10
    80005a76:	02f70a63          	beq	a4,a5,80005aaa <consoleintr+0x118>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005a7a:	37fd                	addiw	a5,a5,-1
    80005a7c:	07f7f713          	andi	a4,a5,127
    80005a80:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005a82:	01874703          	lbu	a4,24(a4)
    80005a86:	03270463          	beq	a4,s2,80005aae <consoleintr+0x11c>
      cons.e--;
    80005a8a:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005a8e:	10000513          	li	a0,256
    80005a92:	00000097          	auipc	ra,0x0
    80005a96:	ebe080e7          	jalr	-322(ra) # 80005950 <consputc>
    while(cons.e != cons.w &&
    80005a9a:	0a04a783          	lw	a5,160(s1)
    80005a9e:	09c4a703          	lw	a4,156(s1)
    80005aa2:	fcf71ce3          	bne	a4,a5,80005a7a <consoleintr+0xe8>
    80005aa6:	6902                	ld	s2,0(sp)
    80005aa8:	b715                	j	800059cc <consoleintr+0x3a>
    80005aaa:	6902                	ld	s2,0(sp)
    80005aac:	b705                	j	800059cc <consoleintr+0x3a>
    80005aae:	6902                	ld	s2,0(sp)
    80005ab0:	bf31                	j	800059cc <consoleintr+0x3a>
    if(cons.e != cons.w){
    80005ab2:	00020717          	auipc	a4,0x20
    80005ab6:	68e70713          	addi	a4,a4,1678 # 80026140 <cons>
    80005aba:	0a072783          	lw	a5,160(a4)
    80005abe:	09c72703          	lw	a4,156(a4)
    80005ac2:	f0f705e3          	beq	a4,a5,800059cc <consoleintr+0x3a>
      cons.e--;
    80005ac6:	37fd                	addiw	a5,a5,-1
    80005ac8:	00020717          	auipc	a4,0x20
    80005acc:	70f72c23          	sw	a5,1816(a4) # 800261e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005ad0:	10000513          	li	a0,256
    80005ad4:	00000097          	auipc	ra,0x0
    80005ad8:	e7c080e7          	jalr	-388(ra) # 80005950 <consputc>
    80005adc:	bdc5                	j	800059cc <consoleintr+0x3a>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005ade:	ee0487e3          	beqz	s1,800059cc <consoleintr+0x3a>
    80005ae2:	b731                	j	800059ee <consoleintr+0x5c>
      consputc(c);
    80005ae4:	4529                	li	a0,10
    80005ae6:	00000097          	auipc	ra,0x0
    80005aea:	e6a080e7          	jalr	-406(ra) # 80005950 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005aee:	00020797          	auipc	a5,0x20
    80005af2:	65278793          	addi	a5,a5,1618 # 80026140 <cons>
    80005af6:	0a07a703          	lw	a4,160(a5)
    80005afa:	0017069b          	addiw	a3,a4,1
    80005afe:	0006861b          	sext.w	a2,a3
    80005b02:	0ad7a023          	sw	a3,160(a5)
    80005b06:	07f77713          	andi	a4,a4,127
    80005b0a:	97ba                	add	a5,a5,a4
    80005b0c:	4729                	li	a4,10
    80005b0e:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005b12:	00020797          	auipc	a5,0x20
    80005b16:	6cc7a523          	sw	a2,1738(a5) # 800261dc <cons+0x9c>
        wakeup(&cons.r);
    80005b1a:	00020517          	auipc	a0,0x20
    80005b1e:	6be50513          	addi	a0,a0,1726 # 800261d8 <cons+0x98>
    80005b22:	ffffc097          	auipc	ra,0xffffc
    80005b26:	bac080e7          	jalr	-1108(ra) # 800016ce <wakeup>
    80005b2a:	b54d                	j	800059cc <consoleintr+0x3a>

0000000080005b2c <consoleinit>:

void
consoleinit(void)
{
    80005b2c:	1141                	addi	sp,sp,-16
    80005b2e:	e406                	sd	ra,8(sp)
    80005b30:	e022                	sd	s0,0(sp)
    80005b32:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005b34:	00003597          	auipc	a1,0x3
    80005b38:	b6458593          	addi	a1,a1,-1180 # 80008698 <etext+0x698>
    80005b3c:	00020517          	auipc	a0,0x20
    80005b40:	60450513          	addi	a0,a0,1540 # 80026140 <cons>
    80005b44:	00000097          	auipc	ra,0x0
    80005b48:	62a080e7          	jalr	1578(ra) # 8000616e <initlock>

  uartinit();
    80005b4c:	00000097          	auipc	ra,0x0
    80005b50:	3bc080e7          	jalr	956(ra) # 80005f08 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005b54:	00013797          	auipc	a5,0x13
    80005b58:	57478793          	addi	a5,a5,1396 # 800190c8 <devsw>
    80005b5c:	00000717          	auipc	a4,0x0
    80005b60:	cd470713          	addi	a4,a4,-812 # 80005830 <consoleread>
    80005b64:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005b66:	00000717          	auipc	a4,0x0
    80005b6a:	c5c70713          	addi	a4,a4,-932 # 800057c2 <consolewrite>
    80005b6e:	ef98                	sd	a4,24(a5)
}
    80005b70:	60a2                	ld	ra,8(sp)
    80005b72:	6402                	ld	s0,0(sp)
    80005b74:	0141                	addi	sp,sp,16
    80005b76:	8082                	ret

0000000080005b78 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005b78:	7179                	addi	sp,sp,-48
    80005b7a:	f406                	sd	ra,40(sp)
    80005b7c:	f022                	sd	s0,32(sp)
    80005b7e:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005b80:	c219                	beqz	a2,80005b86 <printint+0xe>
    80005b82:	08054963          	bltz	a0,80005c14 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005b86:	2501                	sext.w	a0,a0
    80005b88:	4881                	li	a7,0
    80005b8a:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005b8e:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005b90:	2581                	sext.w	a1,a1
    80005b92:	00003617          	auipc	a2,0x3
    80005b96:	c6e60613          	addi	a2,a2,-914 # 80008800 <digits>
    80005b9a:	883a                	mv	a6,a4
    80005b9c:	2705                	addiw	a4,a4,1
    80005b9e:	02b577bb          	remuw	a5,a0,a1
    80005ba2:	1782                	slli	a5,a5,0x20
    80005ba4:	9381                	srli	a5,a5,0x20
    80005ba6:	97b2                	add	a5,a5,a2
    80005ba8:	0007c783          	lbu	a5,0(a5)
    80005bac:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005bb0:	0005079b          	sext.w	a5,a0
    80005bb4:	02b5553b          	divuw	a0,a0,a1
    80005bb8:	0685                	addi	a3,a3,1
    80005bba:	feb7f0e3          	bgeu	a5,a1,80005b9a <printint+0x22>

  if(sign)
    80005bbe:	00088c63          	beqz	a7,80005bd6 <printint+0x5e>
    buf[i++] = '-';
    80005bc2:	fe070793          	addi	a5,a4,-32
    80005bc6:	00878733          	add	a4,a5,s0
    80005bca:	02d00793          	li	a5,45
    80005bce:	fef70823          	sb	a5,-16(a4)
    80005bd2:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005bd6:	02e05b63          	blez	a4,80005c0c <printint+0x94>
    80005bda:	ec26                	sd	s1,24(sp)
    80005bdc:	e84a                	sd	s2,16(sp)
    80005bde:	fd040793          	addi	a5,s0,-48
    80005be2:	00e784b3          	add	s1,a5,a4
    80005be6:	fff78913          	addi	s2,a5,-1
    80005bea:	993a                	add	s2,s2,a4
    80005bec:	377d                	addiw	a4,a4,-1
    80005bee:	1702                	slli	a4,a4,0x20
    80005bf0:	9301                	srli	a4,a4,0x20
    80005bf2:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005bf6:	fff4c503          	lbu	a0,-1(s1)
    80005bfa:	00000097          	auipc	ra,0x0
    80005bfe:	d56080e7          	jalr	-682(ra) # 80005950 <consputc>
  while(--i >= 0)
    80005c02:	14fd                	addi	s1,s1,-1
    80005c04:	ff2499e3          	bne	s1,s2,80005bf6 <printint+0x7e>
    80005c08:	64e2                	ld	s1,24(sp)
    80005c0a:	6942                	ld	s2,16(sp)
}
    80005c0c:	70a2                	ld	ra,40(sp)
    80005c0e:	7402                	ld	s0,32(sp)
    80005c10:	6145                	addi	sp,sp,48
    80005c12:	8082                	ret
    x = -xx;
    80005c14:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005c18:	4885                	li	a7,1
    x = -xx;
    80005c1a:	bf85                	j	80005b8a <printint+0x12>

0000000080005c1c <printfinit>:
    ;
}

void
printfinit(void)
{
    80005c1c:	1101                	addi	sp,sp,-32
    80005c1e:	ec06                	sd	ra,24(sp)
    80005c20:	e822                	sd	s0,16(sp)
    80005c22:	e426                	sd	s1,8(sp)
    80005c24:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005c26:	00020497          	auipc	s1,0x20
    80005c2a:	5c248493          	addi	s1,s1,1474 # 800261e8 <pr>
    80005c2e:	00003597          	auipc	a1,0x3
    80005c32:	a7258593          	addi	a1,a1,-1422 # 800086a0 <etext+0x6a0>
    80005c36:	8526                	mv	a0,s1
    80005c38:	00000097          	auipc	ra,0x0
    80005c3c:	536080e7          	jalr	1334(ra) # 8000616e <initlock>
  pr.locking = 1;
    80005c40:	4785                	li	a5,1
    80005c42:	cc9c                	sw	a5,24(s1)
}
    80005c44:	60e2                	ld	ra,24(sp)
    80005c46:	6442                	ld	s0,16(sp)
    80005c48:	64a2                	ld	s1,8(sp)
    80005c4a:	6105                	addi	sp,sp,32
    80005c4c:	8082                	ret

0000000080005c4e <backtrace>:

void backtrace(void) {
    80005c4e:	7179                	addi	sp,sp,-48
    80005c50:	f406                	sd	ra,40(sp)
    80005c52:	f022                	sd	s0,32(sp)
    80005c54:	ec26                	sd	s1,24(sp)
    80005c56:	e84a                	sd	s2,16(sp)
    80005c58:	e44e                	sd	s3,8(sp)
    80005c5a:	1800                	addi	s0,sp,48
  asm volatile("mv %0, s0" : "=r" (x) );
    80005c5c:	84a2                	mv	s1,s0
  uint64 fp = r_fp();
  uint64 high = PGROUNDUP(fp), low = PGROUNDDOWN(fp);
    80005c5e:	6905                	lui	s2,0x1
    80005c60:	197d                	addi	s2,s2,-1 # fff <_entry-0x7ffff001>
    80005c62:	9926                	add	s2,s2,s1
    80005c64:	79fd                	lui	s3,0xfffff
    80005c66:	01397933          	and	s2,s2,s3
    80005c6a:	0134f9b3          	and	s3,s1,s3
  while (fp > low && fp < high) {
    80005c6e:	0299f963          	bgeu	s3,s1,80005ca0 <backtrace+0x52>
    80005c72:	0324f763          	bgeu	s1,s2,80005ca0 <backtrace+0x52>
    80005c76:	e052                	sd	s4,0(sp)
    uint64 ra = fp - 8;
    uint64 next_fp = fp - 16;
    printf("%p\n", *(uint64*)ra);
    80005c78:	00003a17          	auipc	s4,0x3
    80005c7c:	a30a0a13          	addi	s4,s4,-1488 # 800086a8 <etext+0x6a8>
    80005c80:	ff84b583          	ld	a1,-8(s1)
    80005c84:	8552                	mv	a0,s4
    80005c86:	00000097          	auipc	ra,0x0
    80005c8a:	07a080e7          	jalr	122(ra) # 80005d00 <printf>
    fp = *(uint64*)next_fp;
    80005c8e:	ff04b483          	ld	s1,-16(s1)
  while (fp > low && fp < high) {
    80005c92:	0099f663          	bgeu	s3,s1,80005c9e <backtrace+0x50>
    80005c96:	ff24e5e3          	bltu	s1,s2,80005c80 <backtrace+0x32>
    80005c9a:	6a02                	ld	s4,0(sp)
    80005c9c:	a011                	j	80005ca0 <backtrace+0x52>
    80005c9e:	6a02                	ld	s4,0(sp)
  }
    80005ca0:	70a2                	ld	ra,40(sp)
    80005ca2:	7402                	ld	s0,32(sp)
    80005ca4:	64e2                	ld	s1,24(sp)
    80005ca6:	6942                	ld	s2,16(sp)
    80005ca8:	69a2                	ld	s3,8(sp)
    80005caa:	6145                	addi	sp,sp,48
    80005cac:	8082                	ret

0000000080005cae <panic>:
{
    80005cae:	1101                	addi	sp,sp,-32
    80005cb0:	ec06                	sd	ra,24(sp)
    80005cb2:	e822                	sd	s0,16(sp)
    80005cb4:	e426                	sd	s1,8(sp)
    80005cb6:	1000                	addi	s0,sp,32
    80005cb8:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005cba:	00020797          	auipc	a5,0x20
    80005cbe:	5407a323          	sw	zero,1350(a5) # 80026200 <pr+0x18>
  printf("panic: ");
    80005cc2:	00003517          	auipc	a0,0x3
    80005cc6:	9ee50513          	addi	a0,a0,-1554 # 800086b0 <etext+0x6b0>
    80005cca:	00000097          	auipc	ra,0x0
    80005cce:	036080e7          	jalr	54(ra) # 80005d00 <printf>
  printf(s);
    80005cd2:	8526                	mv	a0,s1
    80005cd4:	00000097          	auipc	ra,0x0
    80005cd8:	02c080e7          	jalr	44(ra) # 80005d00 <printf>
  printf("\n");
    80005cdc:	00002517          	auipc	a0,0x2
    80005ce0:	33c50513          	addi	a0,a0,828 # 80008018 <etext+0x18>
    80005ce4:	00000097          	auipc	ra,0x0
    80005ce8:	01c080e7          	jalr	28(ra) # 80005d00 <printf>
  backtrace();
    80005cec:	00000097          	auipc	ra,0x0
    80005cf0:	f62080e7          	jalr	-158(ra) # 80005c4e <backtrace>
  panicked = 1; // freeze uart output from other CPUs
    80005cf4:	4785                	li	a5,1
    80005cf6:	00003717          	auipc	a4,0x3
    80005cfa:	32f72323          	sw	a5,806(a4) # 8000901c <panicked>
  for(;;)
    80005cfe:	a001                	j	80005cfe <panic+0x50>

0000000080005d00 <printf>:
{
    80005d00:	7131                	addi	sp,sp,-192
    80005d02:	fc86                	sd	ra,120(sp)
    80005d04:	f8a2                	sd	s0,112(sp)
    80005d06:	e8d2                	sd	s4,80(sp)
    80005d08:	f06a                	sd	s10,32(sp)
    80005d0a:	0100                	addi	s0,sp,128
    80005d0c:	8a2a                	mv	s4,a0
    80005d0e:	e40c                	sd	a1,8(s0)
    80005d10:	e810                	sd	a2,16(s0)
    80005d12:	ec14                	sd	a3,24(s0)
    80005d14:	f018                	sd	a4,32(s0)
    80005d16:	f41c                	sd	a5,40(s0)
    80005d18:	03043823          	sd	a6,48(s0)
    80005d1c:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005d20:	00020d17          	auipc	s10,0x20
    80005d24:	4e0d2d03          	lw	s10,1248(s10) # 80026200 <pr+0x18>
  if(locking)
    80005d28:	040d1463          	bnez	s10,80005d70 <printf+0x70>
  if (fmt == 0)
    80005d2c:	040a0b63          	beqz	s4,80005d82 <printf+0x82>
  va_start(ap, fmt);
    80005d30:	00840793          	addi	a5,s0,8
    80005d34:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005d38:	000a4503          	lbu	a0,0(s4)
    80005d3c:	18050b63          	beqz	a0,80005ed2 <printf+0x1d2>
    80005d40:	f4a6                	sd	s1,104(sp)
    80005d42:	f0ca                	sd	s2,96(sp)
    80005d44:	ecce                	sd	s3,88(sp)
    80005d46:	e4d6                	sd	s5,72(sp)
    80005d48:	e0da                	sd	s6,64(sp)
    80005d4a:	fc5e                	sd	s7,56(sp)
    80005d4c:	f862                	sd	s8,48(sp)
    80005d4e:	f466                	sd	s9,40(sp)
    80005d50:	ec6e                	sd	s11,24(sp)
    80005d52:	4981                	li	s3,0
    if(c != '%'){
    80005d54:	02500b13          	li	s6,37
    switch(c){
    80005d58:	07000b93          	li	s7,112
  consputc('x');
    80005d5c:	4cc1                	li	s9,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005d5e:	00003a97          	auipc	s5,0x3
    80005d62:	aa2a8a93          	addi	s5,s5,-1374 # 80008800 <digits>
    switch(c){
    80005d66:	07300c13          	li	s8,115
    80005d6a:	06400d93          	li	s11,100
    80005d6e:	a0b1                	j	80005dba <printf+0xba>
    acquire(&pr.lock);
    80005d70:	00020517          	auipc	a0,0x20
    80005d74:	47850513          	addi	a0,a0,1144 # 800261e8 <pr>
    80005d78:	00000097          	auipc	ra,0x0
    80005d7c:	486080e7          	jalr	1158(ra) # 800061fe <acquire>
    80005d80:	b775                	j	80005d2c <printf+0x2c>
    80005d82:	f4a6                	sd	s1,104(sp)
    80005d84:	f0ca                	sd	s2,96(sp)
    80005d86:	ecce                	sd	s3,88(sp)
    80005d88:	e4d6                	sd	s5,72(sp)
    80005d8a:	e0da                	sd	s6,64(sp)
    80005d8c:	fc5e                	sd	s7,56(sp)
    80005d8e:	f862                	sd	s8,48(sp)
    80005d90:	f466                	sd	s9,40(sp)
    80005d92:	ec6e                	sd	s11,24(sp)
    panic("null fmt");
    80005d94:	00003517          	auipc	a0,0x3
    80005d98:	92c50513          	addi	a0,a0,-1748 # 800086c0 <etext+0x6c0>
    80005d9c:	00000097          	auipc	ra,0x0
    80005da0:	f12080e7          	jalr	-238(ra) # 80005cae <panic>
      consputc(c);
    80005da4:	00000097          	auipc	ra,0x0
    80005da8:	bac080e7          	jalr	-1108(ra) # 80005950 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005dac:	2985                	addiw	s3,s3,1 # fffffffffffff001 <end+0xffffffff7ffd8dc1>
    80005dae:	013a07b3          	add	a5,s4,s3
    80005db2:	0007c503          	lbu	a0,0(a5)
    80005db6:	10050563          	beqz	a0,80005ec0 <printf+0x1c0>
    if(c != '%'){
    80005dba:	ff6515e3          	bne	a0,s6,80005da4 <printf+0xa4>
    c = fmt[++i] & 0xff;
    80005dbe:	2985                	addiw	s3,s3,1
    80005dc0:	013a07b3          	add	a5,s4,s3
    80005dc4:	0007c783          	lbu	a5,0(a5)
    80005dc8:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005dcc:	10078b63          	beqz	a5,80005ee2 <printf+0x1e2>
    switch(c){
    80005dd0:	05778a63          	beq	a5,s7,80005e24 <printf+0x124>
    80005dd4:	02fbf663          	bgeu	s7,a5,80005e00 <printf+0x100>
    80005dd8:	09878863          	beq	a5,s8,80005e68 <printf+0x168>
    80005ddc:	07800713          	li	a4,120
    80005de0:	0ce79563          	bne	a5,a4,80005eaa <printf+0x1aa>
      printint(va_arg(ap, int), 16, 1);
    80005de4:	f8843783          	ld	a5,-120(s0)
    80005de8:	00878713          	addi	a4,a5,8
    80005dec:	f8e43423          	sd	a4,-120(s0)
    80005df0:	4605                	li	a2,1
    80005df2:	85e6                	mv	a1,s9
    80005df4:	4388                	lw	a0,0(a5)
    80005df6:	00000097          	auipc	ra,0x0
    80005dfa:	d82080e7          	jalr	-638(ra) # 80005b78 <printint>
      break;
    80005dfe:	b77d                	j	80005dac <printf+0xac>
    switch(c){
    80005e00:	09678f63          	beq	a5,s6,80005e9e <printf+0x19e>
    80005e04:	0bb79363          	bne	a5,s11,80005eaa <printf+0x1aa>
      printint(va_arg(ap, int), 10, 1);
    80005e08:	f8843783          	ld	a5,-120(s0)
    80005e0c:	00878713          	addi	a4,a5,8
    80005e10:	f8e43423          	sd	a4,-120(s0)
    80005e14:	4605                	li	a2,1
    80005e16:	45a9                	li	a1,10
    80005e18:	4388                	lw	a0,0(a5)
    80005e1a:	00000097          	auipc	ra,0x0
    80005e1e:	d5e080e7          	jalr	-674(ra) # 80005b78 <printint>
      break;
    80005e22:	b769                	j	80005dac <printf+0xac>
      printptr(va_arg(ap, uint64));
    80005e24:	f8843783          	ld	a5,-120(s0)
    80005e28:	00878713          	addi	a4,a5,8
    80005e2c:	f8e43423          	sd	a4,-120(s0)
    80005e30:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005e34:	03000513          	li	a0,48
    80005e38:	00000097          	auipc	ra,0x0
    80005e3c:	b18080e7          	jalr	-1256(ra) # 80005950 <consputc>
  consputc('x');
    80005e40:	07800513          	li	a0,120
    80005e44:	00000097          	auipc	ra,0x0
    80005e48:	b0c080e7          	jalr	-1268(ra) # 80005950 <consputc>
    80005e4c:	84e6                	mv	s1,s9
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005e4e:	03c95793          	srli	a5,s2,0x3c
    80005e52:	97d6                	add	a5,a5,s5
    80005e54:	0007c503          	lbu	a0,0(a5)
    80005e58:	00000097          	auipc	ra,0x0
    80005e5c:	af8080e7          	jalr	-1288(ra) # 80005950 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005e60:	0912                	slli	s2,s2,0x4
    80005e62:	34fd                	addiw	s1,s1,-1
    80005e64:	f4ed                	bnez	s1,80005e4e <printf+0x14e>
    80005e66:	b799                	j	80005dac <printf+0xac>
      if((s = va_arg(ap, char*)) == 0)
    80005e68:	f8843783          	ld	a5,-120(s0)
    80005e6c:	00878713          	addi	a4,a5,8
    80005e70:	f8e43423          	sd	a4,-120(s0)
    80005e74:	6384                	ld	s1,0(a5)
    80005e76:	cc89                	beqz	s1,80005e90 <printf+0x190>
      for(; *s; s++)
    80005e78:	0004c503          	lbu	a0,0(s1)
    80005e7c:	d905                	beqz	a0,80005dac <printf+0xac>
        consputc(*s);
    80005e7e:	00000097          	auipc	ra,0x0
    80005e82:	ad2080e7          	jalr	-1326(ra) # 80005950 <consputc>
      for(; *s; s++)
    80005e86:	0485                	addi	s1,s1,1
    80005e88:	0004c503          	lbu	a0,0(s1)
    80005e8c:	f96d                	bnez	a0,80005e7e <printf+0x17e>
    80005e8e:	bf39                	j	80005dac <printf+0xac>
        s = "(null)";
    80005e90:	00003497          	auipc	s1,0x3
    80005e94:	82848493          	addi	s1,s1,-2008 # 800086b8 <etext+0x6b8>
      for(; *s; s++)
    80005e98:	02800513          	li	a0,40
    80005e9c:	b7cd                	j	80005e7e <printf+0x17e>
      consputc('%');
    80005e9e:	855a                	mv	a0,s6
    80005ea0:	00000097          	auipc	ra,0x0
    80005ea4:	ab0080e7          	jalr	-1360(ra) # 80005950 <consputc>
      break;
    80005ea8:	b711                	j	80005dac <printf+0xac>
      consputc('%');
    80005eaa:	855a                	mv	a0,s6
    80005eac:	00000097          	auipc	ra,0x0
    80005eb0:	aa4080e7          	jalr	-1372(ra) # 80005950 <consputc>
      consputc(c);
    80005eb4:	8526                	mv	a0,s1
    80005eb6:	00000097          	auipc	ra,0x0
    80005eba:	a9a080e7          	jalr	-1382(ra) # 80005950 <consputc>
      break;
    80005ebe:	b5fd                	j	80005dac <printf+0xac>
    80005ec0:	74a6                	ld	s1,104(sp)
    80005ec2:	7906                	ld	s2,96(sp)
    80005ec4:	69e6                	ld	s3,88(sp)
    80005ec6:	6aa6                	ld	s5,72(sp)
    80005ec8:	6b06                	ld	s6,64(sp)
    80005eca:	7be2                	ld	s7,56(sp)
    80005ecc:	7c42                	ld	s8,48(sp)
    80005ece:	7ca2                	ld	s9,40(sp)
    80005ed0:	6de2                	ld	s11,24(sp)
  if(locking)
    80005ed2:	020d1263          	bnez	s10,80005ef6 <printf+0x1f6>
}
    80005ed6:	70e6                	ld	ra,120(sp)
    80005ed8:	7446                	ld	s0,112(sp)
    80005eda:	6a46                	ld	s4,80(sp)
    80005edc:	7d02                	ld	s10,32(sp)
    80005ede:	6129                	addi	sp,sp,192
    80005ee0:	8082                	ret
    80005ee2:	74a6                	ld	s1,104(sp)
    80005ee4:	7906                	ld	s2,96(sp)
    80005ee6:	69e6                	ld	s3,88(sp)
    80005ee8:	6aa6                	ld	s5,72(sp)
    80005eea:	6b06                	ld	s6,64(sp)
    80005eec:	7be2                	ld	s7,56(sp)
    80005eee:	7c42                	ld	s8,48(sp)
    80005ef0:	7ca2                	ld	s9,40(sp)
    80005ef2:	6de2                	ld	s11,24(sp)
    80005ef4:	bff9                	j	80005ed2 <printf+0x1d2>
    release(&pr.lock);
    80005ef6:	00020517          	auipc	a0,0x20
    80005efa:	2f250513          	addi	a0,a0,754 # 800261e8 <pr>
    80005efe:	00000097          	auipc	ra,0x0
    80005f02:	3b4080e7          	jalr	948(ra) # 800062b2 <release>
}
    80005f06:	bfc1                	j	80005ed6 <printf+0x1d6>

0000000080005f08 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005f08:	1141                	addi	sp,sp,-16
    80005f0a:	e406                	sd	ra,8(sp)
    80005f0c:	e022                	sd	s0,0(sp)
    80005f0e:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005f10:	100007b7          	lui	a5,0x10000
    80005f14:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005f18:	10000737          	lui	a4,0x10000
    80005f1c:	f8000693          	li	a3,-128
    80005f20:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005f24:	468d                	li	a3,3
    80005f26:	10000637          	lui	a2,0x10000
    80005f2a:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005f2e:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005f32:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005f36:	10000737          	lui	a4,0x10000
    80005f3a:	461d                	li	a2,7
    80005f3c:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005f40:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005f44:	00002597          	auipc	a1,0x2
    80005f48:	78c58593          	addi	a1,a1,1932 # 800086d0 <etext+0x6d0>
    80005f4c:	00020517          	auipc	a0,0x20
    80005f50:	2bc50513          	addi	a0,a0,700 # 80026208 <uart_tx_lock>
    80005f54:	00000097          	auipc	ra,0x0
    80005f58:	21a080e7          	jalr	538(ra) # 8000616e <initlock>
}
    80005f5c:	60a2                	ld	ra,8(sp)
    80005f5e:	6402                	ld	s0,0(sp)
    80005f60:	0141                	addi	sp,sp,16
    80005f62:	8082                	ret

0000000080005f64 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005f64:	1101                	addi	sp,sp,-32
    80005f66:	ec06                	sd	ra,24(sp)
    80005f68:	e822                	sd	s0,16(sp)
    80005f6a:	e426                	sd	s1,8(sp)
    80005f6c:	1000                	addi	s0,sp,32
    80005f6e:	84aa                	mv	s1,a0
  push_off();
    80005f70:	00000097          	auipc	ra,0x0
    80005f74:	242080e7          	jalr	578(ra) # 800061b2 <push_off>

  if(panicked){
    80005f78:	00003797          	auipc	a5,0x3
    80005f7c:	0a47a783          	lw	a5,164(a5) # 8000901c <panicked>
    80005f80:	eb85                	bnez	a5,80005fb0 <uartputc_sync+0x4c>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005f82:	10000737          	lui	a4,0x10000
    80005f86:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80005f88:	00074783          	lbu	a5,0(a4)
    80005f8c:	0207f793          	andi	a5,a5,32
    80005f90:	dfe5                	beqz	a5,80005f88 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80005f92:	0ff4f513          	zext.b	a0,s1
    80005f96:	100007b7          	lui	a5,0x10000
    80005f9a:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80005f9e:	00000097          	auipc	ra,0x0
    80005fa2:	2b4080e7          	jalr	692(ra) # 80006252 <pop_off>
}
    80005fa6:	60e2                	ld	ra,24(sp)
    80005fa8:	6442                	ld	s0,16(sp)
    80005faa:	64a2                	ld	s1,8(sp)
    80005fac:	6105                	addi	sp,sp,32
    80005fae:	8082                	ret
    for(;;)
    80005fb0:	a001                	j	80005fb0 <uartputc_sync+0x4c>

0000000080005fb2 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005fb2:	00003797          	auipc	a5,0x3
    80005fb6:	06e7b783          	ld	a5,110(a5) # 80009020 <uart_tx_r>
    80005fba:	00003717          	auipc	a4,0x3
    80005fbe:	06e73703          	ld	a4,110(a4) # 80009028 <uart_tx_w>
    80005fc2:	06f70f63          	beq	a4,a5,80006040 <uartstart+0x8e>
{
    80005fc6:	7139                	addi	sp,sp,-64
    80005fc8:	fc06                	sd	ra,56(sp)
    80005fca:	f822                	sd	s0,48(sp)
    80005fcc:	f426                	sd	s1,40(sp)
    80005fce:	f04a                	sd	s2,32(sp)
    80005fd0:	ec4e                	sd	s3,24(sp)
    80005fd2:	e852                	sd	s4,16(sp)
    80005fd4:	e456                	sd	s5,8(sp)
    80005fd6:	e05a                	sd	s6,0(sp)
    80005fd8:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005fda:	10000937          	lui	s2,0x10000
    80005fde:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005fe0:	00020a97          	auipc	s5,0x20
    80005fe4:	228a8a93          	addi	s5,s5,552 # 80026208 <uart_tx_lock>
    uart_tx_r += 1;
    80005fe8:	00003497          	auipc	s1,0x3
    80005fec:	03848493          	addi	s1,s1,56 # 80009020 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    80005ff0:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    80005ff4:	00003997          	auipc	s3,0x3
    80005ff8:	03498993          	addi	s3,s3,52 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005ffc:	00094703          	lbu	a4,0(s2)
    80006000:	02077713          	andi	a4,a4,32
    80006004:	c705                	beqz	a4,8000602c <uartstart+0x7a>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006006:	01f7f713          	andi	a4,a5,31
    8000600a:	9756                	add	a4,a4,s5
    8000600c:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    80006010:	0785                	addi	a5,a5,1
    80006012:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    80006014:	8526                	mv	a0,s1
    80006016:	ffffb097          	auipc	ra,0xffffb
    8000601a:	6b8080e7          	jalr	1720(ra) # 800016ce <wakeup>
    WriteReg(THR, c);
    8000601e:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    80006022:	609c                	ld	a5,0(s1)
    80006024:	0009b703          	ld	a4,0(s3)
    80006028:	fcf71ae3          	bne	a4,a5,80005ffc <uartstart+0x4a>
  }
}
    8000602c:	70e2                	ld	ra,56(sp)
    8000602e:	7442                	ld	s0,48(sp)
    80006030:	74a2                	ld	s1,40(sp)
    80006032:	7902                	ld	s2,32(sp)
    80006034:	69e2                	ld	s3,24(sp)
    80006036:	6a42                	ld	s4,16(sp)
    80006038:	6aa2                	ld	s5,8(sp)
    8000603a:	6b02                	ld	s6,0(sp)
    8000603c:	6121                	addi	sp,sp,64
    8000603e:	8082                	ret
    80006040:	8082                	ret

0000000080006042 <uartputc>:
{
    80006042:	7179                	addi	sp,sp,-48
    80006044:	f406                	sd	ra,40(sp)
    80006046:	f022                	sd	s0,32(sp)
    80006048:	e052                	sd	s4,0(sp)
    8000604a:	1800                	addi	s0,sp,48
    8000604c:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    8000604e:	00020517          	auipc	a0,0x20
    80006052:	1ba50513          	addi	a0,a0,442 # 80026208 <uart_tx_lock>
    80006056:	00000097          	auipc	ra,0x0
    8000605a:	1a8080e7          	jalr	424(ra) # 800061fe <acquire>
  if(panicked){
    8000605e:	00003797          	auipc	a5,0x3
    80006062:	fbe7a783          	lw	a5,-66(a5) # 8000901c <panicked>
    80006066:	c391                	beqz	a5,8000606a <uartputc+0x28>
    for(;;)
    80006068:	a001                	j	80006068 <uartputc+0x26>
    8000606a:	ec26                	sd	s1,24(sp)
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000606c:	00003717          	auipc	a4,0x3
    80006070:	fbc73703          	ld	a4,-68(a4) # 80009028 <uart_tx_w>
    80006074:	00003797          	auipc	a5,0x3
    80006078:	fac7b783          	ld	a5,-84(a5) # 80009020 <uart_tx_r>
    8000607c:	02078793          	addi	a5,a5,32
    80006080:	02e79f63          	bne	a5,a4,800060be <uartputc+0x7c>
    80006084:	e84a                	sd	s2,16(sp)
    80006086:	e44e                	sd	s3,8(sp)
      sleep(&uart_tx_r, &uart_tx_lock);
    80006088:	00020997          	auipc	s3,0x20
    8000608c:	18098993          	addi	s3,s3,384 # 80026208 <uart_tx_lock>
    80006090:	00003497          	auipc	s1,0x3
    80006094:	f9048493          	addi	s1,s1,-112 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006098:	00003917          	auipc	s2,0x3
    8000609c:	f9090913          	addi	s2,s2,-112 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    800060a0:	85ce                	mv	a1,s3
    800060a2:	8526                	mv	a0,s1
    800060a4:	ffffb097          	auipc	ra,0xffffb
    800060a8:	49e080e7          	jalr	1182(ra) # 80001542 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800060ac:	00093703          	ld	a4,0(s2)
    800060b0:	609c                	ld	a5,0(s1)
    800060b2:	02078793          	addi	a5,a5,32
    800060b6:	fee785e3          	beq	a5,a4,800060a0 <uartputc+0x5e>
    800060ba:	6942                	ld	s2,16(sp)
    800060bc:	69a2                	ld	s3,8(sp)
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800060be:	00020497          	auipc	s1,0x20
    800060c2:	14a48493          	addi	s1,s1,330 # 80026208 <uart_tx_lock>
    800060c6:	01f77793          	andi	a5,a4,31
    800060ca:	97a6                	add	a5,a5,s1
    800060cc:	01478c23          	sb	s4,24(a5)
      uart_tx_w += 1;
    800060d0:	0705                	addi	a4,a4,1
    800060d2:	00003797          	auipc	a5,0x3
    800060d6:	f4e7bb23          	sd	a4,-170(a5) # 80009028 <uart_tx_w>
      uartstart();
    800060da:	00000097          	auipc	ra,0x0
    800060de:	ed8080e7          	jalr	-296(ra) # 80005fb2 <uartstart>
      release(&uart_tx_lock);
    800060e2:	8526                	mv	a0,s1
    800060e4:	00000097          	auipc	ra,0x0
    800060e8:	1ce080e7          	jalr	462(ra) # 800062b2 <release>
    800060ec:	64e2                	ld	s1,24(sp)
}
    800060ee:	70a2                	ld	ra,40(sp)
    800060f0:	7402                	ld	s0,32(sp)
    800060f2:	6a02                	ld	s4,0(sp)
    800060f4:	6145                	addi	sp,sp,48
    800060f6:	8082                	ret

00000000800060f8 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800060f8:	1141                	addi	sp,sp,-16
    800060fa:	e422                	sd	s0,8(sp)
    800060fc:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800060fe:	100007b7          	lui	a5,0x10000
    80006102:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    80006104:	0007c783          	lbu	a5,0(a5)
    80006108:	8b85                	andi	a5,a5,1
    8000610a:	cb81                	beqz	a5,8000611a <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    8000610c:	100007b7          	lui	a5,0x10000
    80006110:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80006114:	6422                	ld	s0,8(sp)
    80006116:	0141                	addi	sp,sp,16
    80006118:	8082                	ret
    return -1;
    8000611a:	557d                	li	a0,-1
    8000611c:	bfe5                	j	80006114 <uartgetc+0x1c>

000000008000611e <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    8000611e:	1101                	addi	sp,sp,-32
    80006120:	ec06                	sd	ra,24(sp)
    80006122:	e822                	sd	s0,16(sp)
    80006124:	e426                	sd	s1,8(sp)
    80006126:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80006128:	54fd                	li	s1,-1
    8000612a:	a029                	j	80006134 <uartintr+0x16>
      break;
    consoleintr(c);
    8000612c:	00000097          	auipc	ra,0x0
    80006130:	866080e7          	jalr	-1946(ra) # 80005992 <consoleintr>
    int c = uartgetc();
    80006134:	00000097          	auipc	ra,0x0
    80006138:	fc4080e7          	jalr	-60(ra) # 800060f8 <uartgetc>
    if(c == -1)
    8000613c:	fe9518e3          	bne	a0,s1,8000612c <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006140:	00020497          	auipc	s1,0x20
    80006144:	0c848493          	addi	s1,s1,200 # 80026208 <uart_tx_lock>
    80006148:	8526                	mv	a0,s1
    8000614a:	00000097          	auipc	ra,0x0
    8000614e:	0b4080e7          	jalr	180(ra) # 800061fe <acquire>
  uartstart();
    80006152:	00000097          	auipc	ra,0x0
    80006156:	e60080e7          	jalr	-416(ra) # 80005fb2 <uartstart>
  release(&uart_tx_lock);
    8000615a:	8526                	mv	a0,s1
    8000615c:	00000097          	auipc	ra,0x0
    80006160:	156080e7          	jalr	342(ra) # 800062b2 <release>
}
    80006164:	60e2                	ld	ra,24(sp)
    80006166:	6442                	ld	s0,16(sp)
    80006168:	64a2                	ld	s1,8(sp)
    8000616a:	6105                	addi	sp,sp,32
    8000616c:	8082                	ret

000000008000616e <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    8000616e:	1141                	addi	sp,sp,-16
    80006170:	e422                	sd	s0,8(sp)
    80006172:	0800                	addi	s0,sp,16
  lk->name = name;
    80006174:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80006176:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    8000617a:	00053823          	sd	zero,16(a0)
}
    8000617e:	6422                	ld	s0,8(sp)
    80006180:	0141                	addi	sp,sp,16
    80006182:	8082                	ret

0000000080006184 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006184:	411c                	lw	a5,0(a0)
    80006186:	e399                	bnez	a5,8000618c <holding+0x8>
    80006188:	4501                	li	a0,0
  return r;
}
    8000618a:	8082                	ret
{
    8000618c:	1101                	addi	sp,sp,-32
    8000618e:	ec06                	sd	ra,24(sp)
    80006190:	e822                	sd	s0,16(sp)
    80006192:	e426                	sd	s1,8(sp)
    80006194:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006196:	6904                	ld	s1,16(a0)
    80006198:	ffffb097          	auipc	ra,0xffffb
    8000619c:	cc8080e7          	jalr	-824(ra) # 80000e60 <mycpu>
    800061a0:	40a48533          	sub	a0,s1,a0
    800061a4:	00153513          	seqz	a0,a0
}
    800061a8:	60e2                	ld	ra,24(sp)
    800061aa:	6442                	ld	s0,16(sp)
    800061ac:	64a2                	ld	s1,8(sp)
    800061ae:	6105                	addi	sp,sp,32
    800061b0:	8082                	ret

00000000800061b2 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800061b2:	1101                	addi	sp,sp,-32
    800061b4:	ec06                	sd	ra,24(sp)
    800061b6:	e822                	sd	s0,16(sp)
    800061b8:	e426                	sd	s1,8(sp)
    800061ba:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800061bc:	100024f3          	csrr	s1,sstatus
    800061c0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800061c4:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800061c6:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800061ca:	ffffb097          	auipc	ra,0xffffb
    800061ce:	c96080e7          	jalr	-874(ra) # 80000e60 <mycpu>
    800061d2:	5d3c                	lw	a5,120(a0)
    800061d4:	cf89                	beqz	a5,800061ee <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800061d6:	ffffb097          	auipc	ra,0xffffb
    800061da:	c8a080e7          	jalr	-886(ra) # 80000e60 <mycpu>
    800061de:	5d3c                	lw	a5,120(a0)
    800061e0:	2785                	addiw	a5,a5,1
    800061e2:	dd3c                	sw	a5,120(a0)
}
    800061e4:	60e2                	ld	ra,24(sp)
    800061e6:	6442                	ld	s0,16(sp)
    800061e8:	64a2                	ld	s1,8(sp)
    800061ea:	6105                	addi	sp,sp,32
    800061ec:	8082                	ret
    mycpu()->intena = old;
    800061ee:	ffffb097          	auipc	ra,0xffffb
    800061f2:	c72080e7          	jalr	-910(ra) # 80000e60 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800061f6:	8085                	srli	s1,s1,0x1
    800061f8:	8885                	andi	s1,s1,1
    800061fa:	dd64                	sw	s1,124(a0)
    800061fc:	bfe9                	j	800061d6 <push_off+0x24>

00000000800061fe <acquire>:
{
    800061fe:	1101                	addi	sp,sp,-32
    80006200:	ec06                	sd	ra,24(sp)
    80006202:	e822                	sd	s0,16(sp)
    80006204:	e426                	sd	s1,8(sp)
    80006206:	1000                	addi	s0,sp,32
    80006208:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    8000620a:	00000097          	auipc	ra,0x0
    8000620e:	fa8080e7          	jalr	-88(ra) # 800061b2 <push_off>
  if(holding(lk))
    80006212:	8526                	mv	a0,s1
    80006214:	00000097          	auipc	ra,0x0
    80006218:	f70080e7          	jalr	-144(ra) # 80006184 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000621c:	4705                	li	a4,1
  if(holding(lk))
    8000621e:	e115                	bnez	a0,80006242 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006220:	87ba                	mv	a5,a4
    80006222:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80006226:	2781                	sext.w	a5,a5
    80006228:	ffe5                	bnez	a5,80006220 <acquire+0x22>
  __sync_synchronize();
    8000622a:	0ff0000f          	fence
  lk->cpu = mycpu();
    8000622e:	ffffb097          	auipc	ra,0xffffb
    80006232:	c32080e7          	jalr	-974(ra) # 80000e60 <mycpu>
    80006236:	e888                	sd	a0,16(s1)
}
    80006238:	60e2                	ld	ra,24(sp)
    8000623a:	6442                	ld	s0,16(sp)
    8000623c:	64a2                	ld	s1,8(sp)
    8000623e:	6105                	addi	sp,sp,32
    80006240:	8082                	ret
    panic("acquire");
    80006242:	00002517          	auipc	a0,0x2
    80006246:	49650513          	addi	a0,a0,1174 # 800086d8 <etext+0x6d8>
    8000624a:	00000097          	auipc	ra,0x0
    8000624e:	a64080e7          	jalr	-1436(ra) # 80005cae <panic>

0000000080006252 <pop_off>:

void
pop_off(void)
{
    80006252:	1141                	addi	sp,sp,-16
    80006254:	e406                	sd	ra,8(sp)
    80006256:	e022                	sd	s0,0(sp)
    80006258:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    8000625a:	ffffb097          	auipc	ra,0xffffb
    8000625e:	c06080e7          	jalr	-1018(ra) # 80000e60 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006262:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80006266:	8b89                	andi	a5,a5,2
  if(intr_get())
    80006268:	e78d                	bnez	a5,80006292 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    8000626a:	5d3c                	lw	a5,120(a0)
    8000626c:	02f05b63          	blez	a5,800062a2 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006270:	37fd                	addiw	a5,a5,-1
    80006272:	0007871b          	sext.w	a4,a5
    80006276:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006278:	eb09                	bnez	a4,8000628a <pop_off+0x38>
    8000627a:	5d7c                	lw	a5,124(a0)
    8000627c:	c799                	beqz	a5,8000628a <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000627e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006282:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006286:	10079073          	csrw	sstatus,a5
    intr_on();
}
    8000628a:	60a2                	ld	ra,8(sp)
    8000628c:	6402                	ld	s0,0(sp)
    8000628e:	0141                	addi	sp,sp,16
    80006290:	8082                	ret
    panic("pop_off - interruptible");
    80006292:	00002517          	auipc	a0,0x2
    80006296:	44e50513          	addi	a0,a0,1102 # 800086e0 <etext+0x6e0>
    8000629a:	00000097          	auipc	ra,0x0
    8000629e:	a14080e7          	jalr	-1516(ra) # 80005cae <panic>
    panic("pop_off");
    800062a2:	00002517          	auipc	a0,0x2
    800062a6:	45650513          	addi	a0,a0,1110 # 800086f8 <etext+0x6f8>
    800062aa:	00000097          	auipc	ra,0x0
    800062ae:	a04080e7          	jalr	-1532(ra) # 80005cae <panic>

00000000800062b2 <release>:
{
    800062b2:	1101                	addi	sp,sp,-32
    800062b4:	ec06                	sd	ra,24(sp)
    800062b6:	e822                	sd	s0,16(sp)
    800062b8:	e426                	sd	s1,8(sp)
    800062ba:	1000                	addi	s0,sp,32
    800062bc:	84aa                	mv	s1,a0
  if(!holding(lk))
    800062be:	00000097          	auipc	ra,0x0
    800062c2:	ec6080e7          	jalr	-314(ra) # 80006184 <holding>
    800062c6:	c115                	beqz	a0,800062ea <release+0x38>
  lk->cpu = 0;
    800062c8:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800062cc:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800062d0:	0f50000f          	fence	iorw,ow
    800062d4:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800062d8:	00000097          	auipc	ra,0x0
    800062dc:	f7a080e7          	jalr	-134(ra) # 80006252 <pop_off>
}
    800062e0:	60e2                	ld	ra,24(sp)
    800062e2:	6442                	ld	s0,16(sp)
    800062e4:	64a2                	ld	s1,8(sp)
    800062e6:	6105                	addi	sp,sp,32
    800062e8:	8082                	ret
    panic("release");
    800062ea:	00002517          	auipc	a0,0x2
    800062ee:	41650513          	addi	a0,a0,1046 # 80008700 <etext+0x700>
    800062f2:	00000097          	auipc	ra,0x0
    800062f6:	9bc080e7          	jalr	-1604(ra) # 80005cae <panic>
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
